`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:26:37 02/26/2026 
// Design Name: 
// Module Name:    expAddUnit 
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
module expAddUnit (
    input [7:0] oprA,
    input [7:0] oprB,
    output [8:0] out
);

assign out = oprA + oprB;

endmodule