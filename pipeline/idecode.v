module decode (
    input clk,
    input rst,
    input [31:0] id_inst,           // From IF/ID bridge 
    
    // Write-back interface (feedback loop from WB stage) 
    input [4:0]  wb_waddr,          // WReg1 from WB stage
    input [31:0] wb_wdata,          // Data from WB stage
    input        wb_wena,           // WRegEn from WB stage
    
    // Outputs to ID/EX bridge 
    output [31:0] r1data,           // Data from Reg1
    output [31:0] r2data,           // Data from Reg2
    output [4:0]  wreg_addr_out,    // Propagated destination address
    output        wreg_en_out,      // Propagated WRegEn
    output        wmem_en_out,      // Propagated WMemEn

    // *** Added outputs required by pipeline ***
    output        mem_read_out,     // Memory read control
    output [31:0] sign_ext_imm_out, // Sign-extended immediate
    output        mem_to_reg_out,   // Select memory data in WB
    output        ALUSrc_out,       // Select immediate for ALU B input
    output [4:0]  shift_out,        // Shift amount
    output [3:0]  alu_ctrl_out      // ALU operation select
);

    // 1. Instruction Parsing (Part 3 Format) 
    wire       wmem_en = id_inst[31];
    wire       wreg_en = id_inst[30];
    wire [4:0] reg1    = id_inst[29:25];
    wire [4:0] reg2    = id_inst[24:20]; 
    wire [4:0] wreg1   = id_inst[19:15]; 

    // *** Added parsing fields for ALU/Immediate ***
    wire [3:0] alu_op  = id_inst[14:11];  
    wire       ALUSrc  = id_inst[10];     
    wire       branch  = id_inst[9];     
    wire       brType  = id_inst[8];  
    wire [7:0] imm8    = id_inst[7:0]; 
    
    assign [4:0] shift = imm8[4:0];
    
    // 2. Register File Instance
    registerFile32 rf_inst (
        .clk(clk),
        .clr(rst),                  // Connected to global reset 
        .r1addr(reg1),
        .r2addr(reg2),
        .waddr(wb_waddr),
        .wdata(wb_wdata),
        .wena(wb_wena),
        .r1data(r1data),
        .r2data(r2data)
    );

    // 3. Drive Outputs for the next stage bridge 
    assign wreg_addr_out = wreg1;
    assign wreg_en_out   = wreg_en;
    assign wmem_en_out   = wmem_en;

    // *** Immediate generation (sign extend 8-bit immediate) ***
    assign sign_ext_imm_out = {{24{imm8[7]}}, imm8};

    // *** ALU control + shift ***
    assign shift_out    = shift;
    assign alu_ctrl_out = alu_op;

    // *** ALUSrc: use immediate if immediate field is non-zero ***
    //assign ALUSrc_out = (imm12 != 12'b0);
    assign ALUSrc_out  = id_instr[16];

    // *** Memory Read Control ***
    // For now: assume load when wmem_en = 0 and wreg_en = 1
    assign mem_read_out = (~wmem_en) & wreg_en;

    // *** MemToReg: only loads write memory data back ***
    assign mem_to_reg_out = mem_read_out;

endmodule
