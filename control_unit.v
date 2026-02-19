module control_unit(
    input [31:28] cond,       // Condition field (bits 31:28)
    input [27:26] op,         // Instruction type (bits 27:26)
    input [25:20] funct,      // Function field for decoding
    input [4] I_bit,          // Immediate flag (bit 25)
    input [20] S_bit,         // Set condition codes (bit 20)
    
    output reg RegWrite,
    output reg MemWrite,
    output reg MemRead,
    output reg MemToReg,
    output reg ALUSrc,
    output reg RegSrc,        // Register source select
    output reg Branch,
    output reg [1:0] FlagWrite,
    output reg [1:0] ALUOp
);

always @(*) begin
    // Default values
    RegWrite = 0;
    MemWrite = 0;
    MemRead = 0;
    MemToReg = 0;
    ALUSrc = 0;
    RegSrc = 0;
    Branch = 0;
    FlagWrite = 2'b00;
    ALUOp = 2'b00;
    
    case (op)
        2'b00: begin  // Data processing (ADD, SUB, MOV, CMP, etc.)
            if (funct[5] == 0) begin  // Not immediate
                RegWrite = 1;
                ALUSrc = 0;
                ALUOp = 2'b10;  // R-type: use funct field
                if (S_bit) FlagWrite = 2'b11;  // Update flags
            end
            else begin  // Immediate
                RegWrite = (funct[4:1] != 4'b1010);  // Don't write for CMP
                ALUSrc = 1;
                ALUOp = 2'b10;
                if (S_bit) FlagWrite = 2'b11;
            end
        end
        
        2'b01: begin  // Load/Store (LDR, STR)
            if (funct[0] == 1) begin  // LDR (Load)
                RegWrite = 1;
                MemRead = 1;
                MemToReg = 1;
                ALUSrc = 1;
                ALUOp = 2'b00;  // ADD for address calculation
            end
            else begin  // STR (Store)
                MemWrite = 1;
                ALUSrc = 1;
                RegSrc = 1;  // Use Rd as source for store
                ALUOp = 2'b00;  // ADD for address calculation
            end
        end
        
        2'b10: begin  // Branch (B, BL, BLT, BLE, etc.)
            Branch = 1;
            RegWrite = (funct[4] == 1);  // BL writes to LR
            ALUOp = 2'b00;  // ADD for PC calculation
        end
        
        default: begin
            // NOP or unimplemented
        end
    endcase
end

endmodule
