`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:32:00 02/12/2026 
// Design Name: 
// Module Name:    mux4_32 
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
module mux4_32(
    input [31:0] R0, R1, R2, R3,
    input [1:0] sel,
    output [31:0] Y
);
    genvar i;
    generate
        for(i=0; i<32; i=i+1) begin: MUXES
            mux4_1 m (
                .a(R0[i]),
                .b(R1[i]),
                .c(R2[i]),
                .d(R3[i]),
                .sel(sel),
                .y(Y[i])
            );
        end
    endgenerate
endmodule
