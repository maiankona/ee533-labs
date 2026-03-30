`timescale 1ns / 1ps
module decode_gpu (
    input clk,
    input rst,
    input [31:0] id_inst,
    input [8:0]  pc_plus_1,

    // Write-back interface
    input [4:0]  wb_waddr,
    input [63:0] wb_wdata,
    input        wb_wena,

    // Stall input from hazard unit
    input stall,

    // Register file outputs
    output [63:0] r1data,
    output [63:0] r2data,
    output [63:0] rddata,

    // Pipeline control signals
    output [4:0]  wreg_addr_out,
    output        wreg_en_out,
    output        wmem_en_out,
    output        mem_read_out,
    output [63:0] sign_ext_imm_out,
    output        mem_to_reg_out,
    output        ALUSrc_out,
    output [4:0]  shift_out,
    output [1:0]  width_out,

    // Execution unit dispatch
    output [3:0]  exec_op_out,
    output        is_scalar_out,
    output        is_vec_int_out,
    output        is_tensor_out,
    output        is_vmac_out,

    // Branch outputs
    output        PCSrc,
    output [8:0]  branch_target
);

    wire [1:0] fmt    = id_inst[31:30];
    wire [5:0] opcode = id_inst[31:26];

    // R-Type fields
    wire [4:0] rd  = id_inst[25:21];
    wire [4:0] rs1 = id_inst[20:16];
    wire [4:0] rs2 = id_inst[15:11];

    // I-Type fields
    wire [13:0] imm14 = id_inst[15:2];
    wire [1:0]  width = id_inst[1:0];

    // B-Type fields
    wire [4:0]  b_rs1         = id_inst[25:21];
    wire [4:0]  b_rs2         = id_inst[20:16];
    wire [15:0] branch_offset = id_inst[15:0];

    // Format decode
    wire is_R = (fmt == 2'b00);
    wire is_I = (fmt == 2'b01);
    wire is_B = (fmt == 2'b10);

    // Opcode decode
    wire is_NOP       = (opcode == 6'h00);
    wire is_ADD       = (opcode == 6'h01);
    wire is_SUB       = (opcode == 6'h02);
    wire is_CVT       = (opcode == 6'h03);
    wire is_VADD_I16  = (opcode == 6'h04);
    wire is_VSUB_I16  = (opcode == 6'h05);
    wire is_VADD_BF16 = (opcode == 6'h06);
    wire is_VSUB_BF16 = (opcode == 6'h07);
    wire is_VMUL_BF16 = (opcode == 6'h08);
    wire is_VMAC_BF16 = (opcode == 6'h09);
    wire is_VRELU_BF16= (opcode == 6'h0A);
    wire is_HALT      = (opcode == 6'h0B);
    wire is_VMUL_I16  = (opcode == 6'h0C);
    wire is_ADDI      = (opcode == 6'h11);
    wire is_LD        = (opcode == 6'h12);
    wire is_ST        = (opcode == 6'h13);
    wire is_MOVI      = (opcode == 6'h19);
    wire is_BEQ       = (opcode == 6'h25);
    wire is_BLT       = (opcode == 6'h26);
    wire is_BGT       = (opcode == 6'h27);

    // Unit groupings
    wire is_scalar  = is_ADD | is_SUB | is_CVT |
                      is_ADDI | is_LD | is_ST | is_MOVI;
    wire is_vec_int = is_VADD_I16 | is_VSUB_I16 | is_VMUL_I16;
    wire is_tensor  = is_VADD_BF16 | is_VSUB_BF16 | is_VMUL_BF16 |
                      is_VMAC_BF16 | is_VRELU_BF16;

    // Register file address mux
    wire [4:0] r1addr = is_B ? b_rs1 : rs1;
    wire [4:0] r2addr = is_B ? b_rs2 : rs2;
    wire [4:0] rdaddr = rd;

    // =========================================================
    // Register file - single clock, distributed RAM with forwarding
    // =========================================================
    registerFile64 rf_inst (
        .clk   (clk),
        .clr   (rst),
        .r1addr(r1addr),
        .r2addr(r2addr),
        .rdaddr(rdaddr),
        .waddr (wb_waddr),
        .wdata (wb_wdata),
        .wena  (wb_wena),
        .r1data(r1data),
        .r2data(r2data),
        .rddata(rddata)
    );

    // Control signals
    wire wreg_en = (is_R & ~is_NOP & ~is_HALT) |
                   is_ADDI | is_LD | is_MOVI;
    wire wmem_en    = is_ST;
    wire mem_read   = is_LD;
    wire mem_to_reg = is_LD;
    wire ALUSrc     = is_I;
    wire [4:0] wreg_addr = rd;

    // exec_op
    reg [3:0] exec_op;
    always @(*) begin
        case (opcode)
            6'h01:                exec_op = 4'h1; // ADD
            6'h02:                exec_op = 4'h2; // SUB
            6'h03:                exec_op = 4'hA; // CVT
            6'h04:                exec_op = 4'h1; // VADD_I16
            6'h05:                exec_op = 4'h2; // VSUB_I16
            6'h0C:                exec_op = 4'h8; // VMUL_I16
            6'h06:                exec_op = 4'h5; // VADD_BF16
            6'h07:                exec_op = 4'h6; // VSUB_BF16
            6'h08:                exec_op = 4'h7; // VMUL_BF16
            6'h09:                exec_op = 4'h8; // VMAC_BF16
            6'h0A:                exec_op = 4'h9; // VRELU_BF16
            6'h11, 6'h12, 6'h13: exec_op = 4'h1; // ADDI / LD / ST
            6'h19:                exec_op = 4'h9; // MOVI
            default:              exec_op = 4'hF; // NOP / HALT / branch
        endcase
    end

    // Sign extend immediate
    wire [63:0] sign_ext_imm = {{50{imm14[13]}}, imm14};

    // Branch logic
    wire zero         = (r1data == r2data);
    wire less_than    = ($signed(r1data) < $signed(r2data));
    wire greater_than = ($signed(r1data) > $signed(r2data));

    wire branch_taken = (is_BEQ & zero)       |
                        (is_BLT & less_than)   |
                        (is_BGT & greater_than);

    assign PCSrc = branch_taken & ~stall;

    wire [8:0] branch_offset_trunc = branch_offset[8:0];
    assign branch_target = pc_plus_1 + branch_offset_trunc;

    wire [4:0] shift = rs2[4:0];

    // Output assignments
    assign wreg_addr_out    = wreg_addr;
    assign wreg_en_out      = wreg_en;
    assign wmem_en_out      = wmem_en;
    assign mem_read_out     = mem_read;
    assign sign_ext_imm_out = sign_ext_imm;
    assign mem_to_reg_out   = mem_to_reg;
    assign ALUSrc_out       = ALUSrc;
    assign shift_out        = shift;
    assign width_out        = width;
    assign exec_op_out      = exec_op;
    assign is_scalar_out    = is_scalar;
    assign is_vec_int_out   = is_vec_int;
    assign is_tensor_out    = is_tensor;
    assign is_vmac_out      = is_VMAC_BF16;

endmodule
