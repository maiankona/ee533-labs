`timescale 1ns / 1ps

module pipeline_pseudoARM(
    input clk,
    input rst,
    input cpu_start,              // one-cycle pulse: releases ARM PC from idle

    // HOST interactions
    input write_to_imem,
    input write_to_dmem,
    input [8:0]  addr_imem_host,
    input [31:0] data_imem_host,
    input [7:0]  addr_dmem_host,
    input [31:0] data_dmem_host,
    input        read_req_dmem,

    // HOST Expectations
    output        alu_result_detected,
    output [31:0] data_out_dmem,
    output [31:0] alu_out_intercept,

    // --- MEM stage outputs for gpu_control_interface_2 ---
    output [7:0]  cpu_mem_addr,   // me_alu_res[7:0] - address of store
    output [63:0] cpu_mem_data,   // me_store_data zero-extended to 64-bit
    output        cpu_mem_we      // me_wme - store is in MEM stage
);

	 // CPU start & enables
	 reg cpu_start_latch, cpu_en;

    // Feedback Paths
    wire [31:0] wb_wdata;      
    wire [3:0]  wb_waddr;      
    wire        wb_wena;
    wire [1:0]  wb_thread;
    wire        ex_take_branch; 
    wire [8:0]  ex_br_addr;
    wire [1:0]  ex_branch_thread;
    wire [8:0]  if_pc; 

    // --- STAGE 1: INSTRUCTION FETCH (IF) ---
    wire [31:0] if_instruction;
    wire [1:0]  if_curr_thread;

    ifetch IF (
        .clk(clk), .rst(rst),
        .cpu_start(cpu_start_latch),
        .write_to_imem(write_to_imem),
        .addr_imem_host(addr_imem_host),
        .imem_data(data_imem_host),
        .take_branch(ex_take_branch),      
        .branch_target(ex_br_addr),
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
        .stall(!cpu_en),
        .d_in({if_curr_thread, if_pc, if_instruction}),
        .q_out({id_curr_thread, id_pc, id_inst})
    );

    // --- STAGE 2: INSTRUCTION DECODE (ID) ---
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

    // BRIDGE 2: ID/EX
    wire [25:0] id_ex_d = {
        id_curr_thread, // [25:24]
        id_alu_ctrl,    // [23:20]
        id_immediate,   // [19:8]
        id_alu_src,     // [7]
        id_mem_to_reg,  // [6]
        id_wmem_en,     // [5]
        id_wreg_addr,   // [4:1]
        id_wreg_en      // [0]
    };

    wire [25:0] id_ex_q;
    wire [3:0]  ex_cond;
    wire        ex_branch;
    
    register_generate #(41) id_ex_bridge (
        .clk(clk),
        .rst(rst || cpu_start),
        .stall(!cpu_en),
        .d_in({id_br_addr, id_branch, id_cond, id_ex_d}),
        .q_out({ex_br_addr, ex_branch, ex_cond, id_ex_q})
    );

    // --- STAGE 3: EXECUTE (EX) ---
    wire [1:0]  ex_curr_thread = id_ex_q[25:24];
    wire [3:0]  ex_alu_ctrl    = id_ex_q[23:20];
    wire        ex_mem_to_reg  = id_ex_q[6];   
    wire        ex_wmem_en     = id_ex_q[5];   
    wire [3:0]  ex_waddr       = id_ex_q[4:1];
    wire        ex_wrege       = id_ex_q[0];
    wire [11:0] ex_imm         = id_ex_q[19:8];
    wire        ex_alu_src     = id_ex_q[7];

    assign ex_br_target     = ex_br_addr;
    assign ex_branch_thread = ex_curr_thread;

    wire [31:0] ex_alu_b = ex_alu_src ? {{20{ex_imm[11]}}, ex_imm} : id_r2data;
         
    wire [31:0] ex_alu_out;
    wire        ex_alu_zero;
    wire        ex_alu_negative;
    
    alu_32bit ALU (
        .A(id_r1data),
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
        if (ex_branch) begin
            case (ex_cond)
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
        ex_curr_thread,  // [72:71]
        ex_alu_out,      // [70:39]
        id_r2data,       // [38:7]
        ex_wmem_en,      // [6]
        ex_mem_to_reg,   // [5]
        ex_waddr,        // [4:1]
        ex_wrege         // [0]
    };

    // BRIDGE 3: EX/ME
    wire [72:0] ex_me_q;
    register_generate #(73) ex_me_bridge (
        .clk(clk), .rst(rst || cpu_start),
        .stall(!cpu_en),
        .d_in(ex_me_d),
        .q_out(ex_me_q)
    );

    // --- STAGE 4: MEMORY (ME) ---
    wire [1:0]  me_curr_thread = ex_me_q[72:71];
    wire [31:0] me_alu_res     = ex_me_q[70:39];
    wire [31:0] me_store_data  = ex_me_q[38:7];
    wire        me_wme         = ex_me_q[6];
    wire [31:0] dmem_raw_output;

    memory_pseudoARM ME (
        .clk(clk),
        .curr_thread(me_curr_thread),
        .write_to_dmem(write_to_dmem),
        .read_req_dmem(read_req_dmem),
        .addr_dmem_host(addr_dmem_host),
        .data_dmem_host(data_dmem_host),
        .pipeline_addr(me_alu_res),
        .pipeline_data(me_store_data),
        .pipeline_we(me_wme),
        .dmem_out(dmem_raw_output)
    );

    // --- MEM stage outputs for gpu_control_interface_2 ---
    assign cpu_mem_addr = me_alu_res[7:0];
    assign cpu_mem_data = {32'h0, me_store_data};
    assign cpu_mem_we   = me_wme;

    // BRIDGE 4: ME -> WB
    wire [40:0] me_wb_d = {
        me_curr_thread, // [40:39]
        me_alu_res,     // [38:7]
        ex_me_q[5],     // [6] mem_to_reg
        ex_me_q[4:1],   // [5:2] rd
        ex_me_q[0]      // [1] wrege
    };
     
    wire [40:0] me_wb_q;
    register_generate #(41) me_me2_bridge (
        .clk(clk), .rst(rst || cpu_start),
        .stall(!cpu_en),
        .d_in(me_wb_d),
        .q_out(me_wb_q)
    );
     
    assign alu_result_detected = ex_me_q[6];
    assign data_out_dmem       = dmem_raw_output;
    wire wb_mem_to_reg         = me_wb_q[5];

    // WB STAGE
    assign wb_wdata = wb_mem_to_reg ? dmem_raw_output : me_wb_q[37:6];
    assign wb_waddr = me_wb_q[4:1];
    assign wb_wena  = me_wb_q[0];
    assign wb_thread= me_wb_q[39:38];
	 
	 // CPU pipeline start / enable
	 always @(posedge clk) begin
		if (rst) begin
			cpu_start_latch <= 0;
			cpu_en <= 0;
		end
		else if (cpu_start) begin
			cpu_start_latch <= 1;
			cpu_en <= 1;
		end
	 end

endmodule