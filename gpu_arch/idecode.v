module decode (
    input clk,
    input rst,
    input [31:0] id_inst,
    input [31:0] pc_plus_1,

    // Write-back interface
    input [4:0]  wb_waddr,
    input [63:0] wb_wdata,
    input        wb_wena,

    // Outputs to ID/EX bridge
    output [63:0] r1data,
    output [63:0] r2data,
    output [4:0]  wreg_addr_out,
    output        wreg_en_out,
    output        wmem_en_out,
    output        mem_read_out,
    output [63:0] sign_ext_imm_out,
    output        mem_to_reg_out,
    output        ALUSrc_out,
    output [4:0]  shift_out,
    output [3:0]  alu_ctrl_out,
    output        PCSrc,
    output [31:0] branch_target
);

    // =========================================================
    // 1. INSTRUCTION FIELD PARSING — GPU ISA FORMAT
    //
    //  R: | opcode(6) | rd(5) | rs1(5) | rs2(5) | unused(11) |
    //  I: | opcode(6) | rd(5) | rs1(5) | imm16(16)            |
    //  B: | opcode(6) | rs1(5)| rs2(5) | branch_offset(16)    |
    // =========================================================

    wire [1:0] fmt    = id_inst[31:30];   // Format: 00=R, 01=I, 10=B, 11=Rsvd
    wire [5:0] opcode = id_inst[31:26];   // Full 6-bit opcode (includes fmt bits)

    // R-Type fields
    wire [4:0] rd     = id_inst[25:21];
    wire [4:0] rs1    = id_inst[20:16];
    wire [4:0] rs2    = id_inst[15:11];   // R-type only

    // I-Type fields  (rs1 same bits as R-type)
    wire [13:0] imm14 = id_inst[15:2];

    // width bits for I and R
    wire [2:0] width = id_inst[1:0];

    // B-Type fields  (rs1/rs2 same bit positions as R-type rd/rs1)
    wire [4:0]  b_rs1          = id_inst[25:21];
    wire [4:0]  b_rs2          = id_inst[20:16];
    wire [15:0] branch_offset  = id_inst[15:0];

    // =========================================================
    // 2. FORMAT DECODE
    // =========================================================

    wire is_R = (fmt == 2'b00);
    wire is_I = (fmt == 2'b01);
    wire is_B = (fmt == 2'b10);

    // =========================================================
    // 3. OPCODE DECODE — CONTROL SIGNALS
    // =========================================================

    // R-Type opcodes
    wire is_NOP      = (opcode == 6'h00); // alu ops
    wire is_ADD      = (opcode == 6'h01);
    wire is_SUB      = (opcode == 6'h02);
    wire is_CVT = (opcode == 6'0A);
    wire is_VADD_I16 = (opcode == 6'h01);
    wire is_VSUB_I16 = (opcode == 6'h02);
    wire is_VMUL_I16 = (opcode == 6'h08);
    wire is_VADD_BF16= (opcode == 6'h06); // tensor ops (make sure they dont pass through ALU)
    wire is_VSUB_BF16= (opcode == 6'h07);
    wire is_VMUL_BF16= (opcode == 6'h08);
    wire is_VMAC_BF16= (opcode == 6'h09);
    wire is_VRELU_BF16=(opcode == 6'h0A);
    wire is_HALT     = (opcode == 6'h0B);

    // I-Type opcodes
    wire is_ADDI = (opcode == 6'h11); // alu ops
    wire raw_LD   = (opcode == 6'h11);
    wire raw_ST   = (opcode == 6'h11);
    wire is_MOVI = (opcode == 6'h19);

    // B-Type opcodes
    wire is_BEQ  = (opcode == 6'h25); // alu ops
    //wire is_BNE  = (opcode == 6'h21);
    wire is_BLT  = (opcode == 6'h26);
    wire is_BGT  = (opcode == 6'h27);
    //wire is_JMP  = (opcode == 6'h24);

    // =========================================================
    // 4. REGISTER FILE ADDRESS MUX
    //    B-type uses different source fields than R/I
    // =========================================================

    wire [4:0] r1addr = is_B ? b_rs1 : rs1;
    wire [4:0] r2addr = is_B ? b_rs2 : rs2;   // I-type rs2 field unused in RF read

    // =========================================================
    // 5. REGISTER FILE INSTANCE
    // =========================================================

    registerFile64 rf_inst (
        .clk   (clk),
        .clr   (rst),
        .r1addr(r1addr),
        .r2addr(r2addr),
        .waddr (wb_waddr),
        .wdata (wb_wdata),
        .wena  (wb_wena),
        .r1data(r1data),
        .r2data(r2data)
    );

    // =========================================================
    // 6. CONTROL SIGNAL GENERATION
    // =========================================================

    // Write-register destination: R/I types write back; B/NOP/HALT do not
    wire wreg_en = (is_R & ~is_NOP & ~is_HALT) |
                   is_ADDI | is_LD | is_MOVI;

    // Memory write: only ST
    wire wmem_en = is_ST;

    // Memory read: only LD
    wire mem_read = is_LD;

    // MemToReg: load data written back to register file
    wire mem_to_reg = is_LD;

    // ALUSrc: use immediate for I-type ALU ops (not ST/LD address calc handled same way)
    wire ALUSrc = is_I;   // All I-type ops use imm16 as ALU B input

    // Destination register: R and I types use rd field; B-type has no destination
    wire [4:0] wreg_addr = rd;  // valid only when wreg_en asserted

    // =========================================================
    // 7. ALU CONTROL — 4-bit encoding
    //    Extend as your EX stage requires
    // =========================================================
    //  0000 = ADD / ADDI / LD / ST (address)
    //  0001 = SUB
    //  0010 = VADD_I16
    //  0011 = VSUB_I16
    //  0100 = VMUL_I16
    //  0101 = VADD_BF16
    //  0110 = VSUB_BF16
    //  0111 = VMUL_BF16
    //  1000 = VMAC_BF16
    //  1001 = VRELU_BF16
    //  1010 = MOVI (pass imm through)
    //  1111 = NOP / HALT / branch (ALU idle)

    reg [3:0] exec_op;
    assign exec_op = opcode[3:0];
    /*always @(*) begin
        case (opcode)
            6'h01, 6'h10,
            6'h11, 6'h12: alu_op = 4'b0001; // ADD / ADDI / LD / ST
            6'h02:         alu_op = 4'b0001; // SUB
            6'h03:         alu_op = 4'b0010; // VADD_I16
            6'h04:         alu_op = 4'b0011; // VSUB_I16
            6'h05:         alu_op = 4'b0100; // VMUL_I16
            6'h06:         alu_op = 4'b0101; // VADD_BF16
            6'h07:         alu_op = 4'b0110; // VSUB_BF16
            6'h08:         alu_op = 4'b0111; // VMUL_BF16
            6'h09:         alu_op = 4'b1000; // VMAC_BF16
            6'h0A:         alu_op = 4'b1001; // VRELU_BF16
            6'h13:         alu_op = 4'b1010; // MOVI
            default:       alu_op = 4'b1111; // NOP / HALT / branch
        endcase
    end */

    // =========================================================
    // 8. SIGN-EXTEND IMMEDIATE (16-bit → 64-bit)
    // =========================================================

    wire [63:0] sign_ext_imm = {{50{imm14[13]}}, imm14};

    // =========================================================
    // 9. BRANCH LOGIC
    // =========================================================

    wire zero      = (r1data == r2data);
    wire less_than = ($signed(r1data) < $signed(r2data));
    wire greater_than = ($signed(r1data) > $signed(r2data));

    /*wire branch_taken =
        (is_BEQ &  zero)                     |
        (is_BNE & ~zero)                     |
        (is_BLT &  less_than)                |
        (is_BGT &  greater_than)             |
        (is_JMP);                             // unconditional */
    wire branch_taken =
        (is_BEQ &  zero)                     |
        (is_BLT &  less_than)                |
        (is_BGT &  greater_than);      
    
    assign PCSrc = branch_taken;

    // Branch target: PC+1 + sign-extended 16-bit offset
    wire [63:0] sign_ext_branch = {{48{branch_offset[15]}}, branch_offset};
    assign branch_target = pc_plus_1 + sign_ext_branch[31:0];

    // =========================================================
    // 10. SHIFT AMOUNT (from imm16 low bits, R-type only)
    // =========================================================

    wire [4:0] shift = rs2[4:0]; // R-type shift uses rs2 field (conventional)

    // =========================================================
    // 11. OUTPUT ASSIGNMENTS
    // =========================================================

    assign wreg_addr_out    = wreg_addr;
    assign wreg_en_out      = wreg_en;
    assign wmem_en_out      = wmem_en;
    assign mem_read_out     = mem_read;
    assign sign_ext_imm_out = sign_ext_imm;
    assign mem_to_reg_out   = mem_to_reg;
    assign ALUSrc_out       = ALUSrc;
    assign shift_out        = shift;
    assign alu_ctrl_out     = alu_op;

endmodule




