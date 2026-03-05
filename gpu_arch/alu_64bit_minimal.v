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
	module alu_64bit (
    input  [63:0] A,
    input  [63:0] B,
    input  [3:0]  Op,
	input [5:0] shift,
	input  [1:0]  width,   // 00=16, 01=32, 10=64
    output reg [63:0] Out
);

   
    // 16-bit lanes (4x16 SIMD)
   
    wire signed [15:0] A16 [3:0];
    wire signed [15:0] B16 [3:0];

    assign A16[0] = A[15:0];
    assign A16[1] = A[31:16];
    assign A16[2] = A[47:32];
    assign A16[3] = A[63:48];

    assign B16[0] = B[15:0];
    assign B16[1] = B[31:16];
    assign B16[2] = B[47:32];
    assign B16[3] = B[63:48];


    // 32-bit lanes (2x32 SIMD)

    wire signed [31:0] A32_lo = A[31:0];
    wire signed [31:0] A32_hi = A[63:32];
    wire signed [31:0] B32_lo = B[31:0];
    wire signed [31:0] B32_hi = B[63:32];

    // 64-bit scalar

    wire signed [63:0] A64 = A;
    wire signed [63:0] B64 = B;

    integer i;
    reg signed [15:0] result16 [3:0];
    reg signed [31:0] result32_lo, result32_hi;
    reg signed [63:0] result64;

    always @(*) begin

        // defaults
        Out = 64'd0;

        case (width)

        // 16-bit 

        2'b00: begin
            for (i=0; i<4; i=i+1) begin
                case (Op)
                    4'b0001: result16[i] = A16[i] + B16[i]; // ADD (VADD_I16)
                    4'b0010: result16[i] = A16[i] - B16[i]; // SUB (VSUB_I16)
                    4'b0011: result16[i] = A16[i] << shift[3:0]; // SHL (for 16-bit)
                    //4'b1000: result16[i] = A16[i] * B16[i]; // MULT (VMUL_I16)
                    4'b1001: result16[i] = B16[i];          // PASS
                    default: result16[i] = 16'd0;
                endcase
            end

            Out = {result16[3], result16[2], result16[1], result16[0]};
        end

        // 32-bit: not used (decode forces scalar to 64-bit)
 
        2'b01: begin
            Out = 64'd0;
        end

        // 64-bit scalar — address path only
        2'b10: begin
            case (Op)
                4'b0001: result64 = A64 + B64;           // ADD (base + offset)
                4'b0010: result64 = A64 - B64;          // SUB
                4'b0011: result64 = A64 << shift[5:0];  // SHL 
                4'b1001: result64 = B64;               // PASS (MOVI)
                default: result64 = 64'd0;
            endcase

            Out = result64;
        end

        default: Out = 64'd0;

        endcase
    end
endmodule
