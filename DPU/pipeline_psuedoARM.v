`timescale 1ns / 1ps

// Integrated DMEM: ids.v gpu_fifo_mem (convertible_fifo) + lab9_melvin_working CPU fixes:
// - 104b ID/EX carries operands + branch fields (correct EX operands for GPU dispatch STRs)
// - cpu_en_1/2 two-cycle delay after cpu_start (BRAM regfile settle)
// - idecode: BRAM-aligned controls + WB forwarding (see idecode_pseudoARM.v)

module pipeline_pseudoARM(
    input clk,
    input rst,
    input cpu_start,
    input mem_stall,

    input write_to_imem,
    input write_to_dmem,
    input [8:0]  addr_imem_host,
    input [31:0] data_imem_host,
    input [7:0]  addr_dmem_host,
    input [31:0] data_dmem_host,
    input        read_req_dmem,

    output        alu_result_detected,
    output [31:0] data_out_dmem,
    output [31:0] alu_out_intercept,

    output [7:0]  cpu_mem_addr,
    output [63:0] cpu_mem_data,
    output        cpu_mem_we,

    input  [31:0] ext_fifo_rdata,
    input  [63:0] shared_dmem_rdata,

    output        cpu_fifo_req,
    output [7:0]  cpu_fifo_addr,
    output [31:0] cpu_fifo_wdata,
    output        cpu_fifo_we,
    output        cpu_fifo_head,
    output        cpu_fifo_tail,
    output        cpu_fifo_data,
    output        cpu_fifo_ctrl,

    output        cpu_pipe_we,
    output        cpu_pipe_mem_read,
    output [7:0]  cpu_pipe_addr,
    output [63:0] cpu_pipe_wdata
);

    localparam [1:0] CPU_THREAD_SINGLE = 2'b00;

    reg cpu_start_latch;
    reg cpu_en;
    reg cpu_en_1;
    reg cpu_en_2;

    wire stall_cpu = !cpu_en_2 | mem_stall;

    wire [31:0] wb_wdata;
    wire [3:0]  wb_waddr;
    wire        wb_wena;
    wire [1:0]  wb_thread;
    wire        ex_take_branch;
    wire [8:0]  ex_br_addr_to_if;
    wire [1:0]  ex_branch_thread;
    wire [8:0]  if_pc;

    wire [31:0] if_instruction;
    wire [1:0]  if_curr_thread;

    ifetch_arm IF (
        .clk(clk),
        .rst(rst),
        .cpu_start(cpu_start_latch),
        .stall(stall_cpu),
        .write_to_imem(write_to_imem),
        .addr_imem_host(addr_imem_host),
        .imem_data(data_imem_host),
        .take_branch(ex_take_branch),
        .branch_target(ex_br_addr_to_if),
        .branch_thread(ex_branch_thread),
        .instruction_out(if_instruction),
        .pc(if_pc),
        .curr_thread(if_curr_thread)
    );

    wire [1:0]  id_curr_thread;
    wire [8:0]  id_pc;
    wire [31:0] id_inst;

    register_generate #(43) if_id_bridge (
        .clk(clk),
        .rst(rst || cpu_start),
        .stall(stall_cpu),
        .d_in({CPU_THREAD_SINGLE, if_pc, if_instruction}),
        .q_out({id_curr_thread, id_pc, id_inst})
    );

    wire [31:0] id_r1data, id_r2data;
    wire [3:0]  id_wreg_addr;
    wire        id_wreg_en, id_wmem_en, id_mem_read, id_mem_write, id_mem_to_reg, id_branch;
    wire [11:0] id_immediate;
    wire [3:0]  id_alu_ctrl;
    wire [3:0]  id_cond;
    wire [8:0]  id_br_addr;
    wire        id_alu_src;

    idecode ID (
        .clk(clk),
        .rst(rst),
        .id_inst(id_inst),
        .id_pc(id_pc),
        .curr_thread(id_curr_thread),
        .wb_waddr(wb_waddr),
        .wb_wdata(wb_wdata),
        .wb_wena(wb_wena),
        .wb_thread(wb_thread),
        .r1data(id_r1data),
        .r2data(id_r2data),
        .wreg_addr_out(id_wreg_addr),
        .wreg_en_out(id_wreg_en),
        .wmem_en_out(id_wmem_en),
        .alu_ctrl_out(id_alu_ctrl),
        .immediate_out(id_immediate),
        .alu_src(id_alu_src),
        .mem_to_reg_out(id_mem_to_reg),
        .mem_read_out(id_mem_read),
        .mem_write_out(id_mem_write),
        .branch(id_branch),
        .branch_type(id_cond),
        .br_addr(id_br_addr)
    );

    // ID/EX: operands + branch info carried with control (melvin/lab9_melvin_working)
    wire [103:0] id_ex_din = {
        id_br_addr,
        id_branch,
        id_cond,
        id_r1data,
        id_r2data,
        CPU_THREAD_SINGLE,
        id_alu_ctrl,
        id_immediate,
        id_alu_src,
        id_mem_to_reg,
        id_wmem_en,
        id_wreg_addr,
        id_wreg_en
    };

    wire [103:0] id_ex_q;

    register_generate #(104) id_ex_bridge (
        .clk(clk),
        .rst(rst || cpu_start),
        .stall(stall_cpu),
        .d_in(id_ex_din),
        .q_out(id_ex_q)
    );

    wire [8:0]  ex_br_addr_q   = id_ex_q[103:95];
    wire        ex_branch_q    = id_ex_q[94];
    wire [3:0]  ex_cond_q      = id_ex_q[93:90];
    wire [31:0] ex_r1data      = id_ex_q[89:58];
    wire [31:0] ex_r2data      = id_ex_q[57:26];
    wire [1:0]  ex_curr_thread = id_ex_q[25:24];
    wire [3:0]  ex_alu_ctrl    = id_ex_q[23:20];
    wire [11:0] ex_imm         = id_ex_q[19:8];
    wire        ex_alu_src     = id_ex_q[7];
    wire        ex_mem_to_reg  = id_ex_q[6];
    wire        ex_wmem_en     = id_ex_q[5];
    wire [3:0]  ex_waddr       = id_ex_q[4:1];
    wire        ex_wrege       = id_ex_q[0];

    assign ex_br_addr_to_if   = ex_br_addr_q;
    assign ex_branch_thread   = CPU_THREAD_SINGLE;

    wire [31:0] ex_alu_b = ex_alu_src ? {{20{ex_imm[11]}}, ex_imm} : ex_r2data;

    wire [31:0] ex_alu_out;
    wire        ex_alu_zero;
    wire        ex_alu_negative;

    alu_32bit ALU (
        .A(ex_r1data),
        .B(ex_alu_b),
        .Op(ex_alu_ctrl),
        .Out(ex_alu_out),
        .zero(ex_alu_zero),
        .negative(ex_alu_negative)
    );

    assign alu_out_intercept = ex_alu_out;

    reg branch;
    always @(*) begin
        branch = 1'b0;
        if (ex_branch_q) begin
            case (ex_cond_q)
                4'b0000: branch = ex_alu_zero;
                4'b0001: branch = !ex_alu_zero;
                4'b1010: branch = (ex_alu_negative == 1'b0);
                4'b1011: branch = (ex_alu_negative == 1'b1);
                4'b1110: branch = 1'b1;
                default: branch = 1'b0;
            endcase
        end
    end

    assign ex_take_branch = branch;

    wire [72:0] ex_me_d = {
        ex_curr_thread,
        ex_alu_out,
        ex_r2data,
        ex_wmem_en,
        ex_mem_to_reg,
        ex_waddr,
        ex_wrege
    };

    wire [72:0] ex_me_q;
    register_generate #(73) ex_me_bridge (
        .clk(clk),
        .rst(rst || cpu_start),
        .stall(stall_cpu),
        .d_in(ex_me_d),
        .q_out(ex_me_q)
    );

    wire [1:0]  me_curr_thread = ex_me_q[72:71];
    wire [31:0] me_alu_res     = ex_me_q[70:39];
    wire [31:0] me_store_data  = ex_me_q[38:7];
    wire        me_wme         = ex_me_q[6];

    wire        is_fifo_mapped = |me_alu_res[11:8];
    wire [7:0]  store_addr     = me_alu_res[7:0];
    wire        fifo_head      = is_fifo_mapped && (store_addr == 8'd0);
    wire        fifo_tail      = is_fifo_mapped && (store_addr == 8'd4);
    wire        fifo_ctrl      = is_fifo_mapped && (store_addr == 8'd8);
    wire        fifo_data      = is_fifo_mapped && (me_alu_res[11:8] == 4'd2);
    wire        true_store     = !is_fifo_mapped && me_wme;
    wire        fifo_we        = is_fifo_mapped && me_wme;

    assign cpu_fifo_req   = is_fifo_mapped && (me_wme || ex_me_q[5]);
    assign cpu_fifo_addr  = store_addr;
    assign cpu_fifo_wdata = me_store_data;
    assign cpu_fifo_we    = fifo_we;
    assign cpu_fifo_head  = fifo_head;
    assign cpu_fifo_tail  = fifo_tail;
    assign cpu_fifo_data  = fifo_data;
    assign cpu_fifo_ctrl  = fifo_ctrl;

    wire [7:0] adjusted_addr = me_alu_res[7:0];
    assign cpu_pipe_we        = true_store;
    assign cpu_pipe_mem_read  = !is_fifo_mapped && ex_me_q[5] && !me_wme;
    assign cpu_pipe_addr      = adjusted_addr;
    assign cpu_pipe_wdata     = {32'b0, me_store_data};

    wire [31:0] load_data = is_fifo_mapped ? ext_fifo_rdata : shared_dmem_rdata[31:0];

    assign cpu_mem_addr = me_alu_res[7:0];
    assign cpu_mem_data = {32'h0, me_store_data};
    assign cpu_mem_we   = me_wme;

    wire [40:0] me_wb_d = {
        me_curr_thread,
        me_alu_res,
        ex_me_q[5],
        ex_me_q[4:1],
        ex_me_q[0]
    };

    wire [40:0] me_wb_q;
    register_generate #(41) me_me2_bridge (
        .clk(clk),
        .rst(rst || cpu_start),
        .stall(stall_cpu),
        .d_in(me_wb_d),
        .q_out(me_wb_q)
    );

    assign alu_result_detected = me_wme && !is_fifo_mapped;
    assign data_out_dmem       = load_data;
    wire wb_mem_to_reg         = me_wb_q[5];

    assign wb_wdata = wb_mem_to_reg ? load_data : me_wb_q[37:6];
    assign wb_waddr = me_wb_q[4:1];
    assign wb_wena  = me_wb_q[0];
    assign wb_thread  = CPU_THREAD_SINGLE;

    always @(posedge clk) begin
        if (rst) begin
            cpu_start_latch <= 1'b0;
            cpu_en          <= 1'b0;
            cpu_en_1        <= 1'b0;
            cpu_en_2        <= 1'b0;
        end else begin
            if (cpu_start) begin
                cpu_start_latch <= 1'b1;
                cpu_en          <= 1'b1;
            end
            cpu_en_1 <= cpu_en;
            cpu_en_2 <= cpu_en_1;
        end
    end

endmodule
