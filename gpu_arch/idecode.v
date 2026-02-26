module decode (
    input clk,
    input rst,
    input [31:0] id_inst,
    input [31:0] pc_plus_1,
    
    input [4:0]  wb_waddr,
    input [63:0] wb_wdata,
    input        wb_wena,
    
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

    // =====================================================
    // Instruction Field Parsing UPDATE THIS for GPU
    // =====================================================
    wire        wmem_en = id_inst[31];
    wire        wreg_en = id_inst[30];
    wire [4:0]  reg1    = id_inst[29:25];
    wire [4:0]  reg2    = id_inst[24:20];
    wire [4:0]  wreg1   = id_inst[19:15];

    wire [3:0]  alu_op  = id_inst[14:11];
    wire        branch  = id_inst[9];
    wire        brType  = id_inst[8];
    wire [7:0]  imm8    = id_inst[7:0];

    wire [4:0] shift = imm8[4:0];

    // =====================================================
    // Register File
    // =====================================================
    registerFile32 rf_inst (
        .clk(clk),
        .clr(rst),
        .r1addr(reg1),
        .r2addr(reg2),
        .waddr(wb_waddr),
        .wdata(wb_wdata),
        .wena(wb_wena),
        .r1data(r1data),
        .r2data(r2data)
    );

    // =====================================================
    // Instruction Type Detection
    // =====================================================
    wire is_store  = wmem_en;
    wire is_load   = (~wmem_en) & wreg_en & (~branch);
    wire is_branch = branch;

    // Define which ALU ops are immediate versions
    localparam ADDI = 4'b1000;
    localparam SUBI = 4'b1001;

    wire is_alu_immediate =
            (alu_op == ADDI) |
            (alu_op == SUBI);

    // =====================================================
    // ALUSrc: Generated from instruction type
    // =====================================================
    assign ALUSrc_out =
            is_store |
            is_load  |
            is_alu_immediate;

    // =====================================================
    // Other Control Signals
    // =====================================================
    assign wreg_addr_out = wreg1;
    assign wreg_en_out   = wreg_en;
    assign wmem_en_out   = wmem_en;

    assign alu_ctrl_out  = alu_op;
    assign shift_out     = shift;

    assign sign_ext_imm_out = {{56{imm8[7]}}, imm8};

    wire zero      = (r1data == r2data);
    wire less_than = ($signed(r1data) < $signed(r2data));

    wire branch_taken =
            branch &
            ((~brType & zero) |
             ( brType & less_than));

    assign PCSrc         = branch_taken;
    assign branch_target = pc_plus_1 + sign_ext_imm_out;

    assign mem_read_out  = is_load;
    assign mem_to_reg_out = is_load;

endmodule

