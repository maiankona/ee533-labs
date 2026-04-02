// idecode.v  -- canonical decoder for your pipeline
`timescale 1ns/1ps
module idecode (
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] id_inst,
	input [8:0] id_pc, //okay so it's just better to calculate branch target here

    //thread management
    input [1:0] curr_thread,
    
    // Write-back interface (feedback loop from Stage 5)
    input wire [3:0]  wb_waddr,       
    input wire [31:0] wb_wdata,       
    input wire        wb_wena,
    input wire [1:0] wb_thread, //to only mess with the instruction's registers        

    // basic register file / writeback control
    output wire [31:0] r1data,
    output wire [31:0] r2data,
    output wire        wmem_en_out,
    output wire        wreg_en_out,
    output wire [3:0]  wreg_addr_out,  // destination register (rd)

    // ALU / immediate controls
    output wire [3:0]  alu_ctrl_out,   // ALU operation (or opcode subfield)
    //output wire [31:0] alu_b_out,     // select immediate vs register
    //output wire [4:0]  shift_out,      // shift amount / extra ctrl bits
    output wire [11:0] immediate_out,  // immediate field

    output wire        alu_src, //new support. have to mux this during EX now

    // Memory / load controls
    output wire        mem_to_reg_out, // select memory data for WB (is_load)
    output wire        mem_read_out,   // memory read (load) REGENERATED
    output wire        mem_write_out,  // memory write (store)

    // Branch controls
    output wire        branch,     // instruction is a branch
	output wire [3:0]  branch_type,
    output wire [8:0]  br_addr     // BRANCH TARGET ADDRESS, IN PC NOTATION
);

    // ---------- ARM CHANGES FOR SINGLE TO MULTITHREAD ----------
    wire [3:0]  cond   = id_inst[31:28]; // Condition codes (for branching)
    wire [1:0]  type   = id_inst[27:26]; // 00=ALU, 01=Load/Store, 10=Branch
    wire        i_bit  = id_inst[25];    // Immediate flag for ALU ops
    wire [3:0]  opcode = id_inst[24:21]; // ALUOP
    wire        s_bit  = id_inst[20];    // Set condition codes flag; THIS WILL NOT!!!! BE IMPLEMENTED

    // Register Fields (ARM uses 4 bits for R0-R15)
    wire [3:0]  rs1     = id_inst[19:16]; // Source Register 1 (Base Address)
    wire [3:0]  rd     = id_inst[15:12]; // Destination Register
    wire [11:0] imm12  = id_inst[11:0];  // Immediate / Offset
    wire [3:0]  rs2     = id_inst[3:0];   // Source Register 2 (if not immediate)

    // Instruction Categories
    wire is_dp     = (type == 2'b00); // Data Processing (ALU)
    wire is_mem    = (type == 2'b01); // Memory Access
    wire is_branch = (type == 2'b10); // Branch

    // Specifics
    wire is_load   = is_mem &&  id_inst[20]; // L-bit high = LDR
    wire is_store  = is_mem && ~id_inst[20]; // L-bit low = STR

    // Enables
    assign wreg_en_out   = (is_dp) || is_load; //apparently DP stands for Data Processing and ARM does it like this
    assign wmem_en_out   = is_store;
    assign mem_read_out  = is_load;
    assign mem_write_out = is_store;
    assign alu_src    = (is_dp || is_branch && s_bit) ? i_bit : 1'b1; // Memory offsets always use Immediate

    wire [31:0] sign_ext_imm = {{20{id_inst[11]}}, id_inst[11:0]}; // Sign extend 12-bit to 32-bit
    //assign alu_b_out = (alu_src) ? sign_ext_imm : r2data;
    
    // END OF PARSING FOR INTERNAL SIGNALS AND INSTRUCTION CODING

    // ARM TRANSLATION FOR THIS CPU
    
    // ACTUAL 4-BIT OPCODES FROM ARM MANUAL
    localparam ARM_AND = 4'b0000;
    localparam ARM_EOR = 4'b0001; // Exclusive OR
    localparam ARM_SUB = 4'b0010; // Subtract
    localparam ARM_RSB = 4'b0011; // Reverse Subtract
    localparam ARM_ADD = 4'b0100; // Add
    localparam ARM_ADC = 4'b0101; // Add with Carry
    localparam ARM_SBC = 4'b0110; // Subtract with Carry
    localparam ARM_RSC = 4'b0111; // Reverse Subtract with Carry
    localparam ARM_TST = 4'b1000; // Test (Flags only, does A & B)
    localparam ARM_TEQ = 4'b1001; // Test Equivalence (Flags only, does A ^ B)
	 //THIS INSTRUCTION IS MODDED!
    localparam ARM_CMP = 4'b1010; // Compare_AND_BRANCH (Flags only, does A - B)
    localparam ARM_CMN = 4'b1011; // Compare Negated (Flags only, does A + B)
	 
    localparam ARM_ORR = 4'b1100; // Logical OR
    localparam ARM_MOV = 4'b1101; // Move (Passes B)
    localparam ARM_BIC = 4'b1110; // Bit Clear (A & ~B)
    localparam ARM_MVN = 4'b1111; // Move Not (~B)
	 
	 //ADAPTATION PATCHUPS
	 localparam TYPE_MEM = 2'B01;

    // CUSTOM PIPE'S INITIAL TRANSLATION (BETTER TO JUST HAVE IT AROUND)
    localparam ALU_AND = 4'd2;
    localparam ALU_EOR = 4'd4;
    localparam ALU_SUB = 4'd1;
    localparam ALU_ADD = 4'd0;
    localparam ALU_ORR = 4'd3;
	localparam ALU_SLT = 4'd5;
	localparam ALU_SLL = 4'd6;
	localparam ALU_SRL = 4'd7;
	localparam ALU_SRA = 4'd8;

    reg [3:0] alu_ctrl; //feed this into the stage register

    // TRANSLATION CASE
    always @(*) begin
        case (opcode) // The 4-bit opcode from the fetched instruction
            
            // These pairs share the exact same hardware math circuit!
            ARM_AND, ARM_TST: alu_ctrl = ALU_AND; 
            ARM_EOR, ARM_TEQ: alu_ctrl = ALU_EOR; 
            ARM_SUB, ARM_CMP: alu_ctrl = ALU_SUB; 
            ARM_ADD, ARM_CMN, ARM_MOV: alu_ctrl = ALU_ADD; 
            
            // Single mappings
            ARM_ORR:          alu_ctrl = ALU_ORR; 
            
            // If your hardware doesn't support Carries/Reverse Subtract yet, 
            // you can map them to a safe default or build them later.
            ARM_RSB, ARM_BIC, ARM_ADC, ARM_SBC, ARM_RSC, ARM_MVN: alu_ctrl = ALU_ADD; 
            
            default: alu_ctrl = ALU_ADD;
        endcase
		  
		  if (is_mem) begin
			alu_ctrl = ALU_ADD;
		  end
    end
	 
	 //ARM STYLE: CHOOSE YOUR R2
	 wire [3:0] rs2_sw = is_store ? rd : rs2;
    
    // REGISTER FILE INSTANCES
    registerFile64_BRAM rs1_src (
        .clka(clk),
        .addra({curr_thread, rs1}),
		  .douta(r1data),
        //WB stuff
		  .clkb(clk),
		  .addrb({wb_thread, wb_waddr}), 
        .dinb(wb_wdata),   
        .web(wb_wena)
    );
	 
	registerFile64_BRAM rs2_src (
        .clka(clk),
        .addra({curr_thread, rs2_sw}), 
        .douta(r2data),
        //WB stuff
		  .clkb(clk),
		  .addrb({wb_thread, wb_waddr}), 
        .dinb(wb_wdata),   
        .web(wb_wena)
    );
	 
    assign wreg_addr_out  = rd;

    // forward opcode as alu control; change if your ALU mapping differs
    assign alu_ctrl_out   = alu_ctrl;
    assign shift_out      = id_inst[11:7]; // 5 bits
    assign immediate_out  = imm12;

    assign mem_to_reg_out = is_load;
    assign mem_read_out   = is_load;
    assign mem_write_out  = is_store;

    assign branch     = is_branch;
    assign branch_type    = cond;
    assign br_addr    = id_pc + {id_inst[11], id_inst[11:4]}; //this is kind of what ARMv7 does, but PC+1 styled, depth TRUNCATED. ggez

endmodule