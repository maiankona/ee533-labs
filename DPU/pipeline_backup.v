`timescale 1ns / 1ps
module pipeline_backup(
    input clk,
    input rst,

    // IMEM interface (host)
    input write_to_imem,
    input read_req_imem,
    input [8:0]  addr_imem_host,
    input [31:0] data_imem_host,
    output [31:0] data_out_imem,

    // Host DMEM strobes (for fifo_gpu_mode only; BRAM lives in ids.v gpu_fifo_mem)
    input         write_to_dmem,
    input         read_req_dmem,
    // GPU_START pulse: hardware fetch window [bram_inst_addr .. bram_inst_addr+len-1]
    input         gpu_start,
    input  [7:0]  bram_inst_addr,
    input  [7:0]  bram_length,

    // Shared FIFO/BRAM readback from ids.v gpu_fifo_mem
    input  [63:0] dmem_rdata_in,

    // MEM stage -> shared gpu_fifo_mem (ids.v)
    output [7:0]  dmem_pipe_addr,
    output [63:0] dmem_pipe_wdata,
    output        dmem_pipe_we,
    output        dmem_pipe_mem_read,
    output        fifo_gpu_mode,

    output        pipeline_done,

    // Tensor intercept outputs
    output reg [63:0] tensor_out_intercept
);

    wire [31:0] instruction;
    wire [31:0] id_inst;

    wire [8:0]  pc_plus_1;
    wire        PCSrc;
    wire [8:0]  branch_target;

    wire stall_hzd;
    wire stall;
    // Declared early because stall logic references it before tensor block.
    wire tensor_cmd_ready;

    // =========================================================
    // GPU execution window (partner-style: fetch N insns then stop)
    // =========================================================
    reg        fetch_active;
    reg        fetch_active_d;
    reg        gpu_start_r;
    reg [8:0]  pc_end_r;
    reg [7:0]  bram_inst_addr_r;
    reg [7:0]  bram_length_r;
    // Post-fetch FIFO drain: FMA/tensor can finish many cycles after last insn fetch.
    reg [5:0]  fetch_drain_ctr;

    // One cycle per rising GPU_START; use combinational bram_inst_addr / bram_length that cycle.
    wire gpu_start_pulse = gpu_start & ~gpu_start_r;

    always @(posedge clk) begin
        if (rst) begin
            fetch_active     <= 1'b0;
            gpu_start_r      <= 1'b0;
            pc_end_r         <= 9'h000;
            bram_inst_addr_r <= 8'h00;
            bram_length_r    <= 8'h00;
            fetch_drain_ctr  <= 6'd0;
        end else begin
            gpu_start_r <= gpu_start;

            // Latch cfg only on GPU_START (do not feed bram_*_r from ids every cycle).
            // In ids.v, bram_length/addr are muxed: valid only while gpu_ctrl gpu_start is high;
            // the next cycles see address[15:8]/address[7:0] from SW regs instead, which would
            // corrupt bram_length_r (often 0) and block pipeline_done forever.
            if (gpu_start_pulse && (bram_length != 8'h00)) begin
                fetch_active     <= 1'b1;
                pc_end_r         <= {1'b0, bram_inst_addr} + {1'b0, bram_length} - 9'd1;
                bram_inst_addr_r <= bram_inst_addr;
                bram_length_r    <= bram_length;
            end else if (fetch_active && (pc_plus_1 > pc_end_r)) begin
                fetch_active <= 1'b0;
            end

            // Post-fetch drain: keep FIFO processing active long enough for the
            // tail of the pipeline (especially STR in MEM) to retire.
            if (fetch_active_d && !fetch_active)
                fetch_drain_ctr <= 6'd48;
            else if (fetch_drain_ctr != 6'd0)
                fetch_drain_ctr <= fetch_drain_ctr - 6'd1;
        end
    end

    always @(posedge clk) begin
        if (rst)
            fetch_active_d <= 1'b0;
        else
            fetch_active_d <= fetch_active;
    end

    // Keep IF/ID quiet while no active fetch window; prevents pre-start re-execution.
    wire [31:0] if_id_din = fetch_active_d ? instruction : 32'b0;

    // =========================================================
    // IF Stage
    // =========================================================
    ifetch IF (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .PCSrc(PCSrc),
        .branch_target(branch_target),
        .write_to_imem(write_to_imem),
        .read_req_imem(read_req_imem),
        .addr_imem_host(addr_imem_host),
        .imem_data(data_imem_host),
        .fetch_active(fetch_active),
        .gpu_redirect(gpu_start_pulse),
        .gpu_pc_target({1'b0, bram_inst_addr}),
        .instruction_out(instruction),
        .data_out_imem(data_out_imem),
        .pc_plus_1_out(pc_plus_1)
    );

    // IF/ID Bridge (bubbles when outside fetch window)
    register_generate #(32) if_id (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .d_in(if_id_din),
        .q_out(id_inst)
    );

    // WB signals
    wire [63:0] wb_data;
    wire [4:0]  wb_wreg_addr;
    wire        wb_wreg_en;

    // =========================================================
    // STAGE 2: DECODE
    // =========================================================
    wire [63:0] id_r1data, id_r2data, id_rddata;
    wire [63:0] id_sign_ext_imm;
    wire [4:0]  id_wreg_addr;
    wire        id_wreg_en, id_wmem_en;
    wire        id_mem_read, id_mem_to_reg;
    wire        id_ALUSrc;
    wire [4:0]  id_shift;
    wire [1:0]  id_width;
    wire [3:0]  id_exec_op;
    wire        id_is_scalar, id_is_vec_int, id_is_tensor, id_is_vmac;

    decode ID (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .pc_plus_1(pc_plus_1),
        .id_inst(id_inst),
        .wb_waddr(wb_wreg_addr),
        .wb_wdata(wb_data),
        .wb_wena(wb_wreg_en),
        .r1data(id_r1data),
        .r2data(id_r2data),
        .rddata(id_rddata),
        .wreg_addr_out(id_wreg_addr),
        .wreg_en_out(id_wreg_en),
        .wmem_en_out(id_wmem_en),
        .mem_read_out(id_mem_read),
        .sign_ext_imm_out(id_sign_ext_imm),
        .mem_to_reg_out(id_mem_to_reg),
        .ALUSrc_out(id_ALUSrc),
        .shift_out(id_shift),
        .width_out(id_width),
        .exec_op_out(id_exec_op),
        .is_scalar_out(id_is_scalar),
        .is_vec_int_out(id_is_vec_int),
        .is_tensor_out(id_is_tensor),
        .is_vmac_out(id_is_vmac),
        .PCSrc(PCSrc),
        .branch_target(branch_target)
    );

    // =========================================================
    // ID/EX Bridge (280 bits)
    // =========================================================
    wire [279:0] id_ex_q;

    wire [279:0] id_ex_din = stall ? 280'b0 : {
        id_r1data,          // [279:216]
        id_r2data,          // [215:152]
        id_rddata,          // [151:88]
        id_sign_ext_imm,    // [87:24]
        id_wreg_addr,       // [23:19]
        id_wreg_en,         // [18]
        id_wmem_en,         // [17]
        id_mem_to_reg,      // [16]
        id_mem_read,        // [15]
        id_ALUSrc,          // [14]
        id_shift,           // [13:9]
        id_exec_op,         // [8:5]
        id_is_scalar,       // [4]
        id_is_vec_int,      // [3]
        id_is_tensor,       // [2]
        id_width            // [1:0]
    };

    register_generate #(280) id_ex_bridge (
        .clk(clk),
        .rst(rst),
        .stall(1'b0),
        .d_in(id_ex_din),
        .q_out(id_ex_q)
    );

    // =========================================================
    // STAGE 3: EXEC - wire extraction
    // =========================================================
    wire [63:0] id_ex_r1           = id_ex_q[279:216];
    wire [63:0] id_ex_r2           = id_ex_q[215:152];
    wire [63:0] id_ex_rd           = id_ex_q[151:88];
    wire [63:0] id_ex_sign_ext_imm = id_ex_q[87:24];
    wire [4:0]  id_ex_wreg         = id_ex_q[23:19];
    wire        id_ex_wreg_en      = id_ex_q[18];
    wire        id_ex_wmem_en      = id_ex_q[17];
    wire        id_ex_mem_to_reg   = id_ex_q[16];
    wire        id_ex_mem_read     = id_ex_q[15];
    wire        id_ex_ALUSrc       = id_ex_q[14];
    wire [4:0]  id_ex_shift        = id_ex_q[13:9];
    wire [3:0]  id_ex_exec_op      = id_ex_q[8:5];
    wire        id_ex_is_scalar    = id_ex_q[4];
    wire        id_ex_is_vec_int   = id_ex_q[3];
    wire        id_ex_is_tensor    = id_ex_q[2];
    wire [1:0]  id_ex_width        = id_ex_q[1:0];

    // =========================================================
    // Hazard Unit
    // =========================================================
    hazard_unit HZD (
        .is_vmac        (id_is_vmac),
        .id_rdaddr      (id_wreg_addr),
        .id_ex_is_tensor(id_ex_is_tensor),
        .id_ex_wreg     (id_ex_wreg),
        .stall          (stall_hzd),
        .fwd_rd_en      ()
    );
    // Keep melvin behavior: hazard-based stall only.
    // ID/EX path injects bubbles when stall=1, so tensor backpressure here can drop tensor ops.
    assign stall = stall_hzd;

    // =========================================================
    // EX: Scalar ALU
    // =========================================================
    wire [63:0] alu_B = id_ex_ALUSrc ? id_ex_sign_ext_imm : id_ex_r2;
    wire [63:0] alu_out;

    alu_64bit alu_unit (
        .A  (id_ex_r1),
        .B  (alu_B),
        .Op (id_ex_exec_op),
        .Out(alu_out)
    );

    // =========================================================
    // EX: Tensor Unit
    // =========================================================
    wire [63:0] tensor_out;
    wire [63:0] rd_data_mux = id_ex_rd;
    wire        tensor_done;
    wire        tensor_cmd_valid;
    wire        tensor_cmd_fire;
    reg         tensor_wb_valid_r;
    reg [63:0]  tensor_wb_data_r;
    reg [4:0]   tensor_wb_addr_r;
    reg         tensor_wb_en_r;

    reg [5:0] tensor_opcode;
    always @(*) begin
        case (id_ex_exec_op)
            4'h5:    tensor_opcode = 6'h06; // VADD_BF16
            4'h6:    tensor_opcode = 6'h07; // VSUB_BF16
            4'h7:    tensor_opcode = 6'h08; // VMUL_BF16
            4'h8:    tensor_opcode = 6'h09; // VMAC_BF16
            4'h9:    tensor_opcode = 6'h0A; // VRELU_BF16
            default: tensor_opcode = 6'h00; // NOP
        endcase
    end

    assign tensor_cmd_valid = id_ex_is_tensor;
    assign tensor_cmd_fire  = tensor_cmd_valid & tensor_cmd_ready;

    bf16_tensor_2 tensor_unit (
        .clk        (clk),
        .rst        (rst),
        .cmd_valid  (tensor_cmd_valid),
        .cmd_ready  (tensor_cmd_ready),
        .opcode     (tensor_opcode),
        .r1data     (id_ex_r1),
        .r2data     (id_ex_r2),
        .rd_data    (rd_data_mux),
        .tensor_out (tensor_out),
        .tensor_done(tensor_done)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tensor_wb_valid_r    <= 1'b0;
            tensor_wb_data_r     <= 64'b0;
            tensor_wb_addr_r     <= 5'b0;
            tensor_wb_en_r       <= 1'b0;
            tensor_out_intercept <= 64'b0;
        end else begin
            tensor_wb_valid_r <= 1'b0;

            if (tensor_cmd_fire) begin
                tensor_wb_addr_r <= id_ex_wreg;
                tensor_wb_en_r   <= id_ex_wreg_en;
            end

            if (tensor_done) begin
                tensor_wb_data_r     <= tensor_out;
                tensor_wb_valid_r    <= 1'b1;
                tensor_out_intercept <= tensor_out;
            end
        end
    end

    // Instruction count (for pipeline_done handshake with gpu_control_interface_2)
    reg [7:0] instr_count;
    always @(posedge clk) begin
        if (rst || gpu_start_pulse)
            instr_count <= 8'h0;
        else if (fetch_active)
            instr_count <= instr_count + 8'h1;
    end

    // Done when all instructions issued and fetch/drain finished (tensor ops may still WB separately).
    // Require bram_length_r != 0: otherwise (instr_count >= bram_length_r) is 0 >= 0 in idle and
    // pipeline_done is true before any dispatch, gpu_ctrl exits EXECUTING immediately, GPU never runs.
    assign pipeline_done = (bram_length_r != 8'h00)
                          && (instr_count >= bram_length_r)
                          && !fetch_active
                          && (fetch_drain_ctr == 6'd0);

    // EX result for scalar path only; tensor uses dedicated writeback path.
    wire [63:0] ex_result = alu_out;

    // =========================================================
    // EX/MEM Bridge (202 bits)
    // =========================================================
    wire [201:0] ex_me_bundle;
    wire [201:0] ex_me_din = id_ex_is_tensor ? 202'b0 : {
        ex_result,          // [201:138]
        64'b0,              // [137:74] unused in tensor-handshake path
        id_ex_rd,           // [73:10] store data (rd path)
        id_ex_wreg,         // [9:5]
        id_ex_wreg_en,      // [4]
        id_ex_wmem_en,      // [3]
        id_ex_mem_to_reg,   // [2]
        id_ex_mem_read,     // [1]
        1'b0                // [0] me_is_tensor not used in this path
    };

    register_generate #(202) ex_me_bridge (
        .clk(clk),
        .rst(rst),
        .stall(1'b0),
        .d_in(ex_me_din),
        .q_out(ex_me_bundle)
    );

    // =========================================================
    // STAGE 4: MEMORY
    // =========================================================
    wire [63:0] me_store_data = ex_me_bundle[73:10];
    wire [4:0]  me_wreg       = ex_me_bundle[9:5];
    wire        me_wre        = ex_me_bundle[4];
    wire        me_wme        = ex_me_bundle[3];
    wire        me_mem_to_reg = ex_me_bundle[2];
    wire        me_mem_read   = ex_me_bundle[1];
    wire [63:0] me_result = ex_me_bundle[201:138];

    // DMEM: convertible FIFO inside pipeline (like memory.v in pipeline_pseudoARM)
    wire [7:0]  pipeline_addr     = me_result[7:0];
    wire [63:0] pipeline_data     = me_store_data;
    wire        pipeline_we       = me_wme;
    wire        pipeline_mem_read = me_mem_read;
    wire [63:0] dmem_out;
    assign dmem_out = dmem_rdata_in;

    // FIFO FSM: PROCESSING while GPU runs, during short drain tail, or host touches DMEM.
    wire fetch_drain_active = (fetch_drain_ctr != 6'd0);
    assign fifo_gpu_mode = fetch_active | fetch_active_d | fetch_drain_active |
                         write_to_dmem | read_req_dmem;

    assign dmem_pipe_addr     = pipeline_addr;
    assign dmem_pipe_wdata    = pipeline_data;
    assign dmem_pipe_we       = pipeline_we;
    assign dmem_pipe_mem_read = pipeline_mem_read;

    // =========================================================
    // MEM/WB1 Bridge (72 bits)
    // =========================================================
    wire [71:0] me_wb1_bundle;

    register_generate #(72) me_wb1_bridge (
        .clk(clk),
        .rst(rst),
        .stall(1'b0),
        .d_in({me_result, me_wreg, me_wre, me_mem_to_reg, me_mem_read}),
        .q_out(me_wb1_bundle)
    );

    wire [63:0] wb1_result     = me_wb1_bundle[71:8];
    wire [4:0]  wb1_wreg       = me_wb1_bundle[7:3];
    wire        wb1_wreg_en    = me_wb1_bundle[2];
    wire        wb1_mem_to_reg = me_wb1_bundle[1];
    wire        wb1_mem_read   = me_wb1_bundle[0];


// =========================================================
    // WB1/WB2 Bridge (70 bits)
    // =========================================================
    wire [69:0] wb1_wb2_bundle;

    wire [63:0] wb2_din = (wb1_mem_to_reg & wb1_mem_read)
                              ? dmem_out         // LD: from FIFO BRAM
                              : wb1_result;      // ALU result

    register_generate #(70) wb1_wb2_bridge (
        .clk(clk),
        .rst(rst),
        .stall(1'b0),
        .d_in({wb2_din, wb1_wreg, wb1_wreg_en}),
        .q_out(wb1_wb2_bundle)
    );

    assign wb_data      = tensor_wb_valid_r ? tensor_wb_data_r : wb1_wb2_bundle[69:6];
    assign wb_wreg_addr = tensor_wb_valid_r ? tensor_wb_addr_r : wb1_wb2_bundle[5:1];
    assign wb_wreg_en   = tensor_wb_valid_r ? tensor_wb_en_r   : wb1_wb2_bundle[0];


endmodule