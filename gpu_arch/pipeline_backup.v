`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:08:58 02/27/2026 
// Design Name: 
// Module Name:    pipeline_backup 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module pipeline_backup(
    input clk,
    input rst,

    //HOST interactions
    input write_to_imem,
    input write_to_dmem,
    input [8:0]  addr_imem_host,
    input [31:0] data_imem_host,
    input [7:0]  addr_dmem_host,
    input [63:0] data_dmem_host,

    input         read_req_dmem,
    output [63:0] data_out_dmem
);

    wire [31:0] instruction;
    wire [31:0] id_inst;
    wire [31:0] pc_plus_1;
    wire        PCSrc;
    wire [31:0] branch_target;

    // =========================================================
    // Hazard / stall wires (declared early ? used by IF and ID)
    // =========================================================
    wire stall;       // from hazard unit ? freeze PC and IF/ID bridge
    wire fwd_rd_en;   // from hazard unit ? bypass mux in EX stage

    // =========================================================
    // IF Stage
    // =========================================================
    ifetch IF (
        .clk(clk),
        .rst(rst),
        .stall(stall),              // PC held when stall asserted
        .PCSrc(PCSrc),
        .branch_target(branch_target),
        .write_to_imem(write_to_imem),
        .addr_imem_host(addr_imem_host),
        .imem_data(data_imem_host),
        .instruction_out(instruction),
        .pc_plus_1_out(pc_plus_1)
    );

    // IF/ID Bridge ? stall freezes this register
    register_generate #(32) if_id (
        .clk(clk),
        .rst(rst),
        .stall(stall),              // hold instruction in place during stall
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
        .exec_op_out(id_exec_op),
        .is_scalar_out(id_is_scalar),
        .is_vec_int_out(id_is_vec_int),
        .is_tensor_out(id_is_tensor),
        .is_vmac_out(id_is_vmac),
        .PCSrc(PCSrc),
        .branch_target(branch_target)
    );

    // =========================================================
    // ID/EX Bridge
    //
    // Width breakdown:
    //   r1data       64
    //   r2data       64
    //   rddata       64  ? VMAC accumulator (3rd RF port)
    //   sign_ext_imm 64
    //   wreg_addr     5
    //   wreg_en       1
    //   wmem_en       1
    //   mem_to_reg    1
    //   mem_read      1
    //   ALUSrc        1
    //   shift         5
    //   exec_op       4
    //   is_scalar     1  ? unit enables
    //   is_vec_int    1
    //   is_tensor     1
    //              -----
    //   TOTAL      278
    // =========================================================
    wire [277:0] id_ex_q;

    // When stall is asserted, inject a bubble (all zeros) instead of
    // the real decode outputs so the EX stage does nothing harmful
    wire [277:0] id_ex_din = stall ? 278'b0 : {
        id_r1data,          // [277:214]
        id_r2data,          // [213:150]
        id_rddata,          // [149:86]
        id_sign_ext_imm,    // [85:22]
        id_wreg_addr,       // [21:17]
        id_wreg_en,         // [16]
        id_wmem_en,         // [15]
        id_mem_to_reg,      // [14]
        id_mem_read,        // [13]
        id_ALUSrc,          // [12]
        id_shift,           // [11:7]
        id_exec_op,         // [6:3]
        id_is_scalar,       // [2]
        id_is_vec_int,      // [1]
        id_is_tensor        // [0]
    };

    register_generate #(278) id_ex_bridge (
        .clk(clk),
        .rst(rst),
		  .stall(stall),              // hold instruction in place during stall
        .d_in(id_ex_din),
        .q_out(id_ex_q)
    );

    // =========================================================
    // STAGE 3: EXEC ? wire extraction
    // =========================================================
    wire [63:0] id_ex_r1           = id_ex_q[277:214];
    wire [63:0] id_ex_r2           = id_ex_q[213:150];
    wire [63:0] id_ex_rd           = id_ex_q[149:86];
    wire [63:0] id_ex_sign_ext_imm = id_ex_q[85:22];
    wire [4:0]  id_ex_wreg         = id_ex_q[21:17];
    wire        id_ex_wreg_en      = id_ex_q[16];
    wire        id_ex_wmem_en      = id_ex_q[15];
    wire        id_ex_mem_to_reg   = id_ex_q[14];
    wire        id_ex_mem_read     = id_ex_q[13];
    wire        id_ex_ALUSrc       = id_ex_q[12];
    wire [4:0]  id_ex_shift        = id_ex_q[11:7];
    wire [3:0]  id_ex_exec_op      = id_ex_q[6:3];
    wire        id_ex_is_scalar    = id_ex_q[2];
    wire        id_ex_is_vec_int   = id_ex_q[1];
    wire        id_ex_is_tensor    = id_ex_q[0];

    // =========================================================
    // Hazard Unit
    // Detects VMAC RAW dependency on a tensor result in EX.
    // Issues stall + fwd_rd_en when incoming VMAC's rd matches
    // the destination of the tensor op currently in EX.
    // =========================================================
    hazard_unit HZD (
        .is_vmac        (id_is_vmac),
        .id_rdaddr      (id_wreg_addr),    // rd field of incoming VMAC
        .id_ex_is_tensor(id_ex_is_tensor), // EX stage is a tensor op
        .id_ex_wreg     (id_ex_wreg),      // EX destination register
        .stall          (stall),
        .fwd_rd_en      (fwd_rd_en)
    );

    // =========================================================
    // EX: Scalar ALU
    // =========================================================
    wire [63:0] alu_B = id_ex_ALUSrc ? id_ex_sign_ext_imm : id_ex_r2;
    wire [63:0] alu_out;

    alu_64bit alu_unit (
        .A    (id_ex_r1),
        .B    (alu_B),
        .Op   (id_ex_exec_op),
        .shift(id_ex_shift),
        .Out  (alu_out)
    );

    // =========================================================
    // EX: Tensor Unit
    // rd_data bypass mux:
    //   fwd_rd_en = 1 ? forward tensor_out from previous EX cycle
    //   fwd_rd_en = 0 ? use value read from RF 3rd port normally
    // tensor_out from the EX/MEM bridge is the previous cycle's
    // result ? it feeds back as the accumulator for chained MACs.
    // =========================================================
    wire [63:0] tensor_out;
    wire [63:0] ex_me_tensor_out; // tensor result from EX/MEM bridge (prev cycle)

    wire [63:0] rd_data_mux = fwd_rd_en ? ex_me_tensor_out : id_ex_rd;

    bf16_tensor tensor_unit (
        .opcode    (id_ex_exec_op[3:0]),  // lower 4 bits map to tensor opcodes
        .r1data    (id_ex_r1),
        .r2data    (id_ex_r2),
        .rd_data   (rd_data_mux),
        .tensor_out(tensor_out),
        .tensor_done()                    // not used by pipeline yet
    );

    // =========================================================
    // EX result mux ? pick scalar ALU or tensor output
    // Only one unit's enable is high at a time.
    // =========================================================
    wire [63:0] ex_result = id_ex_is_tensor ? tensor_out : alu_out;

    // =========================================================
    // EX/MEM Bridge
    //
    //   ex_result    64  (scalar ALU or tensor output)
    //   tensor_out   64  (raw tensor output for forwarding)
    //   store_data   64  (r2 for ST)
    //   wreg          5
    //   wreg_en       1
    //   wmem_en       1
    //   mem_to_reg    1
    //   mem_read      1
    //   is_tensor     1  (needed by WB mux and forwarding)
    //              -----
    //   TOTAL      202
    // =========================================================
    wire [201:0] ex_me_bundle;

    register_generate #(202) ex_me_bridge (
        .clk(clk),
        .rst(rst),
		  .stall(stall),              // hold instruction in place during stall
        .d_in({
            ex_result,          // [201:138]
            tensor_out,         // [137:74]  raw tensor out for bypass
            id_ex_r2,           // [73:10]   store data for ST
            id_ex_wreg,         // [9:5]
            id_ex_wreg_en,      // [4]
            id_ex_wmem_en,      // [3]
            id_ex_mem_to_reg,   // [2]
            id_ex_mem_read,     // [1]
            id_ex_is_tensor     // [0]
        }),
        .q_out(ex_me_bundle)
    );

    // Feedback wire for VMAC forwarding (tensor result from previous EX cycle)
    assign ex_me_tensor_out = ex_me_bundle[137:74];

    // =========================================================
    // STAGE 4: MEMORY
    // =========================================================
    wire [63:0] me_result     = ex_me_bundle[201:138];
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
        .pipeline_addr(me_result),
        .pipeline_data(me_store_data),
        .pipeline_we(me_wme),
        .dmem_out(dmem_raw_output)
    );

    assign data_out_dmem = dmem_raw_output;

    // =========================================================
    // MEM/WB Bridge
    //
    //   wb_result  64
    //   wreg        5
    //   wreg_en     1
    //            ----
    //   TOTAL    70
    // =========================================================
    wire [69:0] me_wb_bundle;

    // WB result mux:
    //   LD         ? data from memory
    //   all others ? execution result (ALU or tensor)
    wire [63:0] wb_result = (me_mem_to_reg & me_mem_read)
                                ? dmem_raw_output
                                : me_result;

    register_generate #(70) me_wb_bridge (
        .clk(clk),
        .rst(rst),
		  .stall(stall),              // hold instruction in place during stall
        .d_in({wb_result, me_wreg, me_wre}),
        .q_out(me_wb_bundle)
    );

    assign wb_data      = me_wb_bundle[69:6];
    assign wb_wreg_addr = me_wb_bundle[5:1];
    assign wb_wreg_en   = me_wb_bundle[0];

endmodule
