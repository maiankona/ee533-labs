module alu_control(
    input [1:0] ALUOp,      // From main control
    input [5:0] funct,      // Funct field from instruction
    output reg [3:0] ALUControl  // To your ALU (matches your existing Op codes)
);

// will update after deeper analysis of bubble sort opcodes

always @(*) begin
    case (ALUOp)
        2'b00: ALUControl = 4'b0000;  // LW/SW: always ADD
        2'b01: ALUControl = 4'b0001;  // BEQ: always SUB
        2'b10: begin  // R-type: use funct field
            case (funct)
                6'b100000: ALUControl = 4'b0000;  // ADD
                6'b100010: ALUControl = 4'b0001;  // SUB
                6'b100100: ALUControl = 4'b0010;  // AND
                6'b100101: ALUControl = 4'b0011;  // OR
                6'b101010: ALUControl = 4'b1000;  // SLT (less than)
                6'b100110: ALUControl = 4'b1010;  // XOR
                default:   ALUControl = 4'b0000;
            endcase
        end
        default: ALUControl = 4'b0000;
    endcase
end

endmodule
