`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:40:53 02/10/2026 
// Design Name: 
// Module Name:    alu_64bit_sync 
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
    input clk,
    input reset,
    input [63:0] A,
    input [63:0] B,
    input [3:0] Op,
    input [4:0] shift,
    output reg [63:0] Out
);

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
                4'b1001: Out <= (A > B) ? 64'h1 : 64'h0; //COMPARE INEQUALITY (greater than)
                default: Out <= 64'b0;
            endcase
        end
    end

endmodule
