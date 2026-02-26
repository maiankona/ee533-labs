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

// NEED 4 bfloat 16 parallel operations for SIMD
// [15]    [14:7]  [6:0]
// Sign    Exp(8)  Mantissa(7)

module alu_64bit(
	input [63:0] A,
    input [63:0] B,
	input [63:0] C,
    input [3:0] Op,
    input [4:0] shift,
    output reg [63:0] Out
);
	// unpack bfloat16 inputs for A B and C
	wire [15:0] A0 = A[15:0];
    wire [15:0] A1 = A[31:16];
    wire [15:0] A2 = A[47:32];
    wire [15:0] A3 = A[63:48];
    
    wire [15:0] B0 = B[15:0];
    wire [15:0] B1 = B[31:16];
    wire [15:0] B2 = B[47:32];
    wire [15:0] B3 = B[63:48];
    
    wire [15:0] C0 = C[15:0];
    wire [15:0] C1 = C[31:16];
    wire [15:0] C2 = C[47:32];
    wire [15:0] C3 = C[63:48];

	// simd outputs for 4 threads
	reg [15:0] out0, out1, out2, out3;

	// IP cores for bfloat16 operations
	
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
