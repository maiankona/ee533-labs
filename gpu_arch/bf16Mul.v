`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:24:56 02/26/2026 
// Design Name: 
// Module Name:    bf16Mul 
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
module bf16Mul (
    input [15:0] oprA,
    input [15:0] oprB,
    output [15:0] result 
);

wire [8:0] expAddOut;
wire [7:0] expAddoutFinal;
wire [6:0] mantOutFinal;
wire [15:0] mantOut;
wire resultSign, addOneSel;

// Adder for exponent
expAddUnit exp(
    .oprA(oprA[14:7]),
    .oprB(oprB[14:7]),
    .out(expAddOut)
);

// Multiplier for Mantissa
mantMulUnit mant(
    .oprA(oprA[6:0]),
    .oprB(oprB[6:0]),
    .out(mantOut)
);

assign addOneSel = mantOut[15]; // Mux select = 1 if present
assign mantOutFinal = addOneSel ? mantOut[14:8] : mantOut[13:7]; // if 1X.XX, shift right -> 1.XX, excludes leading 1 bit15 by default
assign resultSign = oprA[15] ^ oprB[15]; // Sign is result of XOR of the operands' MSB

// Subtract 127 to remove redundant exponent bias
// if shifting right was required, add 1 to exponent to normalize result
assign expAddoutFinal = addOneSel ? (expAddOut - 8'd127 + 1) : (expAddOut - 8'd127); 
assign result = {resultSign,expAddoutFinal,mantOutFinal};

endmodule