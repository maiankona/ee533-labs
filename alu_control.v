module alu_control(
    input [1:0] ALUOp,
    input [24:21] funct,      // ARM instruction bits [24:21] (cmd field)
    input [11:4] shamt,       // Shift amount/type
    
    output reg [3:0] ALUControl
);

always @(*) begin
    case (ALUOp)
        2'b00: ALUControl = 4'b0000;  // LDR/STR: ADD
        
        2'b01: ALUControl = 4'b0001;  // Branch: SUB (for condition eval)
        
        2'b10: begin  // Data processing: decode funct
            case (funct)
                4'b0000: ALUControl = 4'b0010;  // AND
                4'b0001: ALUControl = 4'b0110;  // EOR (XOR)
                4'b0010: ALUControl = 4'b0001;  // SUB
                4'b0011: ALUControl = 4'b0001;  // RSB (reverse subtract)
                4'b0100: ALUControl = 4'b0000;  // ADD
                4'b0101: ALUControl = 4'b0000;  // ADC (add with carry)
                4'b0110: ALUControl = 4'b0001;  // SBC (sub with carry)
                4'b0111: ALUControl = 4'b0001;  // RSC
                4'b1000: ALUControl = 4'b0010;  // TST (AND for flags)
                4'b1001: ALUControl = 4'b0110;  // TEQ (XOR for flags)
                4'b1010: ALUControl = 4'b0001;  // CMP (SUB for flags)
                4'b1011: ALUControl = 4'b0000;  // CMN (ADD for flags)
                4'b1100: ALUControl = 4'b0011;  // ORR
                4'b1101: ALUControl = 4'b0100;  // MOV (shift/pass through)
                4'b1110: ALUControl = 4'b0010;  // BIC (bit clear)
                4'b1111: ALUControl = 4'b0101;  // MVN (NOT)
                default: ALUControl = 4'b0000;
            endcase
        end
        
        default: ALUControl = 4'b0000;
    endcase
end

endmodule
