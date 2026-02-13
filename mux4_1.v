`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:31:07 02/12/2026 
// Design Name: 
// Module Name:    mux4_1 
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
module mux4_1(input a, b, c, d,
                 input [1:0] sel,
                 output y);

    wire s0, s1, s2, s3;
    wire ns0, ns1;

    not(ns0, sel[0]);
    not(ns1, sel[1]);

    and(s0, a, ns1, ns0);
    and(s1, b, ns1, sel[0]);
    and(s2, c, sel[1], ns0);
    and(s3, d, sel[1], sel[0]);

    or(y, s0, s1, s2, s3);
endmodule
