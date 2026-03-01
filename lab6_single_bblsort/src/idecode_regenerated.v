// idecode.v  -- canonical decoder for your pipeline
`timescale 1ns/1ps
module idecode (
    input  wire        clk,            // Added for RegFile
    input  wire        rst,            // Added for RegFile
    input  wire [31:0] id_inst,

    // Write-back interface (feedback loop from Stage 5)
    input  wire [2:0]  wb_waddr,       
    input  wire [31:0] wb_wdata,       
    input  wire        wb_wena,        

    // basic register file / writeback control
    output wire [31:0] r1data,         // Added RegFile Output
    output wire [31:0] r2data,         // Added RegFile Output
    output wire        wmem_en_out,    // store instruction
    output wire        wreg_en_out,    // writeback enable
    output wire [2:0]  wreg_addr_out,  // destination register

    // ALU / immediate controls
    output wire [3:0]  alu_ctrl_out,   // ALU operation (or opcode subfield)
    output wire        ALUSrc_out,     // select immediate vs register
    output wire [4:0]  shift_out,      // shift amount / extra ctrl bits
    output wire [11:0] immediate_out,  // immediate field

    // Memory / load controls
    output wire        mem_to_reg_out, // select memory data for WB (is_load)
    output wire        mem_read_out,   // memory read (load) REGENERATED
    output wire        mem_write_out,  // memory write (store)

    // Branch controls
    output wire        branch_out,     // instruction is a branch
    output wire [1:0]  br_type_out,    // 2-bit branch type
    output wire [8:0]  br_addr_out     // 9-bit branch offset (signed when used)
);

    // ---------- Field extraction using canonical mapping ----------
    wire        wmem_en = id_inst[31];
    wire        wreg_en = id_inst[30];

    wire [2:0]  rs1  = id_inst[29:27];
    wire [2:0]  rs2  = id_inst[26:24];
    wire [2:0]  rd   = id_inst[23:21];

    wire [3:0]  instr_opcode = id_inst[20:17];  // top-level opcode field
    wire        ALUSrc = id_inst[16];
    wire [3:0]  shift_hi = id_inst[15:12];

    wire [11:0] imm12 = id_inst[11:0];

    // branch subfields (meaningful only when opcode == OPC_BR)
    wire [1:0]  br_type = id_inst[10:9];
    wire [8:0]  br_addr = id_inst[8:0];

    // ---------- Opcode definitions (localparams) ----------
    localparam [3:0] OPC_ALUR  = 4'b0000; // register-register ALU (use shift/func fields)
    localparam [3:0] OPC_ALUI  = 4'b0001; // immediate ALU (ADDI)
    localparam [3:0] OPC_LW    = 4'b0010; // load
    localparam [3:0] OPC_SW    = 4'b0011; // store
    localparam [3:0] OPC_AND   = 4'b0100;
    localparam [3:0] OPC_OR    = 4'b0101;
    localparam [3:0] OPC_XOR   = 4'b0110;
    localparam [3:0] OPC_SUB   = 4'b0111; // SUB moved to 0111
    localparam [3:0] OPC_SLT   = 4'b1000; // signed compare (optional name)
    localparam [3:0] OPC_SH_LF = 4'b0110; // SLL  -> maps to ALU 0110
    localparam [3:0] OPC_SH_RT = 4'b0111; // SRL  -> maps to ALU 0111
    localparam [3:0] OPC_SH_RT_A = 4'b1000; // SRA  -> maps to ALU 1000
    localparam [3:0] OPC_BR    = 4'b1010; // branch family

    
    reg [3:0] alu_ctrl_local;
    always @(*) begin
        case (instr_opcode)
            OPC_ALUR:  alu_ctrl_local = 4'b0000; // register ALU (use shift/func if needed)
            OPC_ALUI:  alu_ctrl_local = 4'b0000; // ADD for ALUI (ADDI)
            OPC_SUB:   alu_ctrl_local = 4'b0001; // SUB
            OPC_AND:   alu_ctrl_local = 4'b0010; // AND
            OPC_OR:    alu_ctrl_local = 4'b0011; // OR
            OPC_XOR:   alu_ctrl_local = 4'b0100; // XOR
            OPC_LW:    alu_ctrl_local = 4'b0000; // ALU does ADD (address calc)
            OPC_SW:    alu_ctrl_local = 4'b0000; // ALU does ADD (address calc)
            OPC_SLT:   alu_ctrl_local = 4'b0101; // SLT (signed)
            OPC_SH_LF: alu_ctrl_local = 4'b0110; // SLL
            OPC_SH_RT: alu_ctrl_local = 4'b0111; // SRL
            OPC_SH_RT_A: alu_ctrl_local = 4'b1000; // SRA
            OPC_BR:    alu_ctrl_local = 4'b0001; //Branch condition with compare
            default:   alu_ctrl_local = 4'b0000; // default to ADD
        endcase
    end

    // ---------- Derived signals ----------
    wire is_load  = (instr_opcode == OPC_LW);
    wire is_store = (instr_opcode == OPC_SW);
    wire is_branch= (instr_opcode == OPC_BR);

    // 2. REGISTER FILE INSTANCE (The Feedback Loop)
    registerFile32 rf_inst (
        .clk(clk),
        .clr(rst),
        .r1addr({2'b00, rs1}), // Zero-padding 3-bit to 5-bit 
        .r2addr({2'b00, rs2}),
        .waddr({2'b00, wb_waddr}), // Feedback from WB stage 
        .wdata(wb_wdata),          // Data to be written 
        .wena(wb_wena),            // Enable from WB stage 
        .r1data(r1data),
        .r2data(r2data)
    );

    // ---------- Output assignments ----------
    assign wmem_en_out    = wmem_en;
    assign wreg_en_out    = wreg_en;
    assign wreg_addr_out  = rd;

    // forward opcode as alu control; change if your ALU mapping differs
    assign alu_ctrl_out   = alu_ctrl_local;
    assign ALUSrc_out     = ALUSrc;
    assign shift_out      = {1'b0, shift_hi}; // 5 bits
    assign immediate_out  = imm12;

    assign mem_to_reg_out = is_load;
    assign mem_read_out   = is_load;
    assign mem_write_out  = is_store;

    assign branch_out     = is_branch;
    assign br_type_out    = br_type;
    assign br_addr_out    = br_addr;

endmodule