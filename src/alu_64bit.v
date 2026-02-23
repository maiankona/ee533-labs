`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:29:37 02/20/2026 
// Design Name: 
// Module Name:    alu_32bit 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module alu_64bit(
    input [63:0] A,
    input [63:0] B,
    input [3:0] Op,
    input [4:0] shift,
    output reg [63:0] Out
);
	
    always @(*) begin
        case (Op)
            4'b0000: Out = A + B; 
            4'b0001: Out = A - B; 
            4'b0010: Out = A & B; 
            4'b0011: Out = A | B; 
            4'b0100: Out = A << shift; 
            4'b0101: Out = A >> shift; 
            4'b0110: Out = ~(A ^ B); 
			4'b0111: Out = (A == B) ? 64'h1 : 64'h0; 
			4'b1000: Out = (A < B) ? 64'h1 : 64'h0; 
			4'b1001: Out = (A > B) ? 64'h1 : 64'h0; 
            4'b1010: Out = A ^ B; 
			4'b1011: Out = ((A << shift) == B) ? 64'h1 : 64'h0; 
			4'b1100: Out = (A[7:0] == B[7:0]) ? 64'h1 : 64'h0; 
			4'b1101: Out = B - A; 
			4'b1110: Out = ~B; 
            default: Out = 64'b0;
        endcase
    end

endmodule
