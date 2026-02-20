`timescale 1ns / 1ps

module alu_64bit(
    input clk,
    input reset,
	input [63:0] A,
	input [63:0] B,
    input [3:0] Op,
    input [4:0] shift,
	output reg [63:0] Out
);
	//wire [31:0] and_result, or_result, xor_result, xnor_result, sL_result, sR_result;
	
//	bitwiseAND32 uut(.a(A), .b(B), .y(and_result));
//	bitwiseOR32 yut(.a(A), .b(B), .y(or_result));
//	bitwiseXNOR32 zut(.a(A), .b(B), .y(xnor_result));
//	bitwiseXOR32 xut(.a(A), .b(B), .y(xor_result));
//	shiftLeft32 sL(.A(A), .shift_by(shift), .Y(sL_result));
//	shiftRight32 sR(.A(A), .shift_by(shift), .Y(sR_result));

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Out <= 64'b0;
        end else begin
            case (Op)
                4'b0000: Out <= A + B; // ADD
                4'b0001: Out <= A - B; // SUB
                4'b0010: Out <= A & B; // BITWISE AND
                4'b0011: Out <= A | B; // BITWISE OR
                4'b0100: Out <= A << shift; // SHIFT LEFT BY SHIFT UNITS
                4'b0101: Out <= A >> shift; // SHIFT RIGHT BY SHIFT UNITS
                4'b0110: Out <= ~(A ^ B); // BITWISE XNOR
				4'b0111: Out <= (A == B) ? 64'h1 : 64'h0; // COMPARE EQUALITY
				4'b1000: Out <= (A < B) ? 64'h1 : 64'h0; // COMPARE INEQUALITY (less than)
				4'b1001: Out <= (A > B) ? 64'h1 : 64'h0; // COMPARE INEQUALITY (greater than)
                4'b1010: Out <= A ^ B; // BITWISE XOR
				4'b1011: Out <= ((A << shift) == B) ? 64'h1 : 64'h0; // SHIFT-THEN-COMPARE
				4'b1100: Out <= (A[7:0] == B[7:0]) ? 64'h1 : 64'h0; // SUBSTRING COMPARE (lower 8 bits)
				4'b1101: Out <= B - A; // for reverse substruct RSB in bubble sort
				4'b1110: Out <= ~B; // BITWISE NOT for mvn
                default: Out <= 64'b0;
            endcase
        end
    end
endmodule


