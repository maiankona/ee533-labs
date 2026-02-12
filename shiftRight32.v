`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:18:12 02/11/2026 
// Design Name: 
// Module Name:    shiftRight32 
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
module mux2(input a, input b, input sel, output y);
    assign y = sel ? b : a;
endmodule

// slow ahh shifter... worst case runtime O(n^5) 
module shiftRight32(input wire [31:0] A, input wire [4:0] shift_by, output wire [31:0] Y);

    wire [31:0] s1, s2, s4, s8, s16;
    genvar i;

    // shift by 1
    generate
        for(i=0; i<32; i= i+1) begin: SHIFT1
            if (i > 30)
                mux2 minit(.a(A[i]), .b(1'b0), .sel(shift_by[0]), .y(s1[i]));
            else
                mux2 m1(.a(A[i]), .b(A[i+1]), .sel(shift_by[0]), .y(s1[i]));
        end
    endgenerate

    // shift by 2
    generate
        for(i=0; i<32; i= i+1) begin: SHIFT2
            if (i > 29)
                mux2 minit(.a(s1[i]), .b(1'b0), .sel(shift_by[1]), .y(s2[i]));
            else
                mux2 m(.a(s1[i]), .b(s1[i+2]), .sel(shift_by[1]), .y(s2[i]));
        end
    endgenerate

    // shift by 4
    generate
        for(i=0; i<32; i= i+1) begin: SHIFT4
            if (i > 27)
                mux2 minit(.a(s2[i]), .b(1'b0), .sel(shift_by[2]), .y(s4[i]));
            else
                mux2 m(.a(s2[i]), .b(s2[i+4]), .sel(shift_by[2]), .y(s4[i]));
        end
    endgenerate

    // shift by 8
    generate
        for(i=0; i<32; i= i+1) begin: SHIFT8
            if (i > 23)
                mux2 minit(.a(s4[i]), .b(1'b0), .sel(shift_by[3]), .y(s8[i]));
            else
                mux2 m(.a(s4[i]), .b(s4[i+8]), .sel(shift_by[3]), .y(s8[i]));
        end
    endgenerate

    // shift by 16
    generate
        for(i=0; i<32; i= i+1) begin: SHIFT16
            if (i > 15)
                mux2 minit(.a(s8[i]), .b(1'b0), .sel(shift_by[4]), .y(s16[i]));
            else
                mux2 m(.a(s8[i]), .b(s8[i+16]), .sel(shift_by[4]), .y(s16[i]));
        end
    endgenerate

    assign Y = s16;

endmodule
