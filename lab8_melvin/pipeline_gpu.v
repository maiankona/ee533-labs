`timescale 1ns / 1ps
module pipeline_gpu(
    input clk,
    input clk2x,   // 2x pipeline clock for double-clocked register file
    input rst,

    //HOST interactions
    input write_to_imem,
    input write_to_dmem,
    input [8:0]  addr_imem_host,
    input [31:0] data_imem_host,
    input [7:0]  addr_dmem_host,
    input [63:0] data_dmem_host,
    input         read_req_dmem,
	 input gpu_dispatch,       		// resets PC to 0 when ARM dispatches
    
	 output [63:0] data_out_dmem,

    // Tensor intercept outputs
    output reg [63:0] tensor_out_intercept,
    output pipeline_done      // tensor_done propagated out
);

    wire [31:0] instruction;
    wire [31:0] id_inst;

    wire [8:0]  pc_plus_1;
    wire        PCSrc;
    wire [8:0]  branch_target;

    wire stall;
    wire fwd_rd_en;

    // =========================================================
    // IF Stage
    // =========================================================
    ifetch IF (
        .clk(clk),
        .rst(rst || gpu_dispatch),			// Reset PC when new instructions are received
        .stall(stall),
        .PCSrc(PCSrc),
        .branch_target(branch_target),
        .write_to_imem(write_to_imem),
        .addr_imem_host(addr_imem_host),
        .imem_data(data_imem_host),
        .instruction_out(instruction),
        .pc_plus_1_out(pc_plus_1)
    );

    // IF/ID Bridge
    register_generate #(32) if_id (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .d_in(instruction),
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
        .clk2x(clk2x),
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
        .stall          (stall),
        .fwd_rd_en      (fwd_rd_en)
    );

    // =========================================================
    // EX: Scalar ALU
    // =========================================================
    wire [63:0] alu_B = id_ex_ALUSrc ? id_ex_sign_ext_imm : id_ex_r2;
    wire [63:0] alu_out;

    alu_64bit_minimal alu_unit (
        .A  (id_ex_r1),
        .B  (alu_B),
        .Op (id_ex_exec_op),
        .Out(alu_out)
    );

    // =========================================================
    // EX: Tensor Unit
    // =========================================================
    wire [63:0] tensor_out;
    wire [63:0] ex_me_tensor_out;
    wire [63:0] rd_data_mux = fwd_rd_en ? ex_me_tensor_out : id_ex_rd;
	 wire tensor_done;

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

    bf16_tensor tensor_unit (
        .clk       (clk),
        .opcode    (tensor_opcode),
        .r1data    (id_ex_r1),
        .r2data    (id_ex_r2),
        .rd_data   (rd_data_mux),
        .tensor_out(tensor_out),
        .tensor_done(tensor_done)
    );
	 
	 assign pipeline_done = tensor_done;

    // EX result mux
    wire [63:0] ex_result = id_ex_is_tensor ? tensor_out : alu_out;

    // =========================================================
    // EX/MEM Bridge (202 bits)
    // =========================================================
    wire [201:0] ex_me_bundle;

    register_generate #(202) ex_me_bridge (
        .clk(clk),
        .rst(rst),
        .stall(1'b0),
        .d_in({
            ex_result,          // [201:138]
            tensor_out,         // [137:74]
            id_ex_rd,           // [73:10] // The accumulated output of the MAC
            id_ex_wreg,         // [9:5]
            id_ex_wreg_en,      // [4]
            id_ex_wmem_en,      // [3]
            id_ex_mem_to_reg,   // [2]
            id_ex_mem_read,     // [1]
            id_ex_is_tensor     // [0]
        }),
        .q_out(ex_me_bundle)
    );

    assign ex_me_tensor_out = ex_me_bundle[137:74];

    // =========================================================
    // STAGE 4: MEMORY
    // =========================================================
    wire [63:0] me_result = me_is_tensor
                        ? ex_me_bundle[137:74]   // delayed tensor_out (correctly timed)
                        : ex_me_bundle[201:138];  // ALU result

    wire [63:0] me_store_data = ex_me_bundle[73:10];
    wire [4:0]  me_wreg       = ex_me_bundle[9:5];
    wire        me_wre        = ex_me_bundle[4];
    wire        me_wme        = ex_me_bundle[3];
    wire        me_mem_to_reg = ex_me_bundle[2];
    wire        me_mem_read   = ex_me_bundle[1];
    wire        me_is_tensor  = ex_me_bundle[0];

    wire [63:0] dmem_raw_output;

    memory ME (
        .clk(clk),
        .write_to_dmem(write_to_dmem),
        .read_req_dmem(read_req_dmem),
        .addr_dmem_host(addr_dmem_host),
        .data_dmem_host(data_dmem_host),
        .pipeline_addr(me_result[7:0]),
        .pipeline_data(me_store_data),
        .pipeline_we(me_wme),
        .dmem_out(dmem_raw_output)
    );

    assign data_out_dmem = dmem_raw_output;

    // =========================================================
    // Tensor Intercept ? two-stage latch
    //
    // Stage 1 (tensor_out_pipe): unconditional register on me_result.
    //   This gives the Xilinx mapper an always-live flop endpoint so
    //   it never trims the add_out path inside bf16_tensor.
    //
    // Stage 2 (tensor_out_intercept): conditional hold register.
    //   Only captures tensor_out_pipe when a tensor instruction with
    //   wreg_en is in the MEM stage. Holds the last valid tensor result
    //   at all other times so the host can read it after the pulse.
    // =========================================================
    reg [63:0] tensor_out_pipe;

    // Stage 1: unconditional ? keeps mapper path alive
    always @(posedge clk or posedge rst) begin
        if (rst) tensor_out_pipe <= 64'b0;
        else     tensor_out_pipe <= me_result;
    end

    // Stage 2: conditional hold ? only valid tensor results get through
    always @(posedge clk or posedge rst) begin
        if (rst)
            tensor_out_intercept <= 64'b0;
        else if (me_is_tensor && me_wre)
            tensor_out_intercept <= tensor_out_pipe;
        // else: retain last valid value for host to read
    end

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
                              ? dmem_raw_output  // LD: BRAM output now valid
                              : wb1_result;      // ALU/tensor result

    register_generate #(70) wb1_wb2_bridge (
        .clk(clk),
        .rst(rst),
        .stall(1'b0),
        .d_in({wb2_din, wb1_wreg, wb1_wreg_en}),
        .q_out(wb1_wb2_bundle)
    );

    assign wb_data      = wb1_wb2_bundle[69:6];
    assign wb_wreg_addr = wb1_wb2_bundle[5:1];
    assign wb_wreg_en   = wb1_wb2_bundle[0];

endmodule