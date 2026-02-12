`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:05:59 02/11/2026 
// Design Name: 
// Module Name:    bitwiseXOR32 
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
module bitwiseXOR32(input wire [31:0] a, input wire [31:0] b, output wire[31:0] y);

	// loop through each bit and do OR w/ primitive
	genvar i;
	generate
	for(i=0; i < 32; i = i+1)
		begin: xorGate
			xor xor_gate(y[i], a[i], b[i]);
		end
	endgenerate
endmodule
