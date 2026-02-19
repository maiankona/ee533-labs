module control_unit(
    input [5:0] opcode,
    output reg RegWrite,
    output reg MemWrite,
    output reg MemToReg,
    output reg ALUSrc,
    output reg Branch,
    output reg Jump,
    output reg [1:0] ALUOp  // Tells ALU control what type of instruction
);
// will update after deeper analysis of bubble sort opcodes
always @(*) begin
    case (opcode)
        6'b000000: begin  // R-type
            RegWrite = 1;
            MemWrite = 0;
            MemToReg = 0;
            ALUSrc = 0;
            Branch = 0;
            Jump = 0;
            ALUOp = 2'b10;  // R-type: look at funct field
        end
        
        6'b100011: begin  // LW
            RegWrite = 1;
            MemWrite = 0;
            MemToReg = 1;
            ALUSrc = 1;
            Branch = 0;
            Jump = 0;
            ALUOp = 2'b00;  // ADD for address calculation
        end
        
        6'b101011: begin  // SW
            RegWrite = 0;
            MemWrite = 1;
            MemToReg = 0;  // Don't care
            ALUSrc = 1;
            Branch = 0;
            Jump = 0;
            ALUOp = 2'b00;  // ADD for address calculation
        end
        
        6'b000100: begin  // BEQ
            RegWrite = 0;
            MemWrite = 0;
            MemToReg = 0;  // Don't care
            ALUSrc = 0;
            Branch = 1;
            Jump = 0;
            ALUOp = 2'b01;  // SUB for comparison
        end
        
        default: begin  // NOP
            RegWrite = 0;
            MemWrite = 0;
            MemToReg = 0;
            ALUSrc = 0;
            Branch = 0;
            Jump = 0;
            ALUOp = 2'b00;
        end
    endcase
end

endmodule
