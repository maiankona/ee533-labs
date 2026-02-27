`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:27:07 02/26/2026 
// Design Name: 
// Module Name:    mantMulUnit 
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
module mantMulUnit(
    input [6:0] oprA,
    input [6:0] oprB,
    output[15:0] out
);

wire [7:0] fullMantA = {1'b1, oprA}; // prepend hidden 1
wire [7:0] fullMantB = {1'b1, oprB};
assign out = fullMantA * fullMantB;   // 16-bit result

endmodule