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
    input  [5:0]  shift,
    input  [1:0]  width,   // 00=16, 01=32, 10=64
    output reg [63:0] Out
);

    // ----------------------------------------
    // 16-bit lanes (4x16 SIMD)
    // ----------------------------------------
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

    // ----------------------------------------
    // 32-bit lanes (2x32 SIMD)
    // ----------------------------------------
    wire signed [31:0] A32_lo = A[31:0];
    wire signed [31:0] A32_hi = A[63:32];
    wire signed [31:0] B32_lo = B[31:0];
    wire signed [31:0] B32_hi = B[63:32];

    // ----------------------------------------
    // 64-bit scalar
    // ----------------------------------------
    wire signed [63:0] A64 = A;
    wire signed [63:0] B64 = B;

    // ----------------------------------------
    // DSP48-mapped multipliers (attribute on own line for ISE parser)
    // 16-bit: 1 DSP48 each, 32-bit: ~4 DSP48s each, 64-bit: ~16 DSP48s
    // mul32/mul64 output width trimmed to actual used bits to reduce routing
    // ----------------------------------------
    (* use_dsp48 = "yes" *)
    wire signed [31:0] mul16_0 = A16[0] * B16[0];
    (* use_dsp48 = "yes" *)
    wire signed [31:0] mul16_1 = A16[1] * B16[1];
    (* use_dsp48 = "yes" *)
    wire signed [31:0] mul16_2 = A16[2] * B16[2];
    (* use_dsp48 = "yes" *)
    wire signed [31:0] mul16_3 = A16[3] * B16[3];

    // Trimmed to 32 bits: lower half of product is the SIMD truncated result
    (* use_dsp48 = "yes" *)
    wire signed [31:0] mul32_lo = A32_lo * B32_lo;
    (* use_dsp48 = "yes" *)
    wire signed [31:0] mul32_hi = A32_hi * B32_hi;

    // 64-bit multiply: trimmed to 64-bit result (upper bits discarded)
    (* use_dsp48 = "yes" *)
    wire signed [63:0] mul64 = A64 * B64;

    // ----------------------------------------
    // Carry-kill SIMD adder/subtractor
    // Replaces 7 separate adder structures (4x16 + 2x32 + 1x64)
    // with ONE 64-bit adder + masking logic.
    //
    // How it works:
    //   1. Zero the MSB of each lane in both operands so the per-lane
    //      sum can carry INTO the MSB position but never PAST it into
    //      the adjacent lane.
    //   2. The MSB of s_lo at each lane boundary IS the carry-to-MSB.
    //   3. Reconstruct correct MSBs via 1-bit full adder (XOR).
    // ----------------------------------------
    wire [63:0] lane_msb;
    wire [63:0] lane_lsb;

    assign lane_msb = (width == 2'b00) ? 64'h8000800080008000 :
                      (width == 2'b01) ? 64'h8000000080000000 :
                                         64'h8000000000000000;

    assign lane_lsb = (width == 2'b00) ? 64'h0001000100010001 :
                      (width == 2'b01) ? 64'h0000000100000001 :
                                         64'h0000000000000001;

    wire        is_sub       = (Op == 4'b0010);
    wire [63:0] B_op         = is_sub ? ~B : B;        // invert B for subtraction
    wire [63:0] cin          = is_sub ? lane_lsb : 64'b0; // +1 per lane (two's complement)
    wire [63:0] A_lo         = A    & ~lane_msb;        // zero lane MSBs in A
    wire [63:0] B_lo         = B_op & ~lane_msb;        // zero lane MSBs in B_op
    wire [63:0] s_lo         = A_lo + B_lo + cin;       // safe: carry can't cross lane boundary
    wire [63:0] carry_to_msb = s_lo & lane_msb;         // carry that arrived at each lane's MSB
    wire [63:0] A_hi         = A    & lane_msb;         // original MSBs of A
    wire [63:0] B_hi         = B_op & lane_msb;         // original MSBs of B_op
    // 1-bit full adder at each lane MSB, lower bits straight from s_lo
    wire [63:0] simd_addsub  = (A_hi ^ B_hi ^ carry_to_msb) | (s_lo & ~lane_msb);

    // ----------------------------------------
    integer i;
    reg signed [15:0] result16 [3:0];
    reg signed [31:0] result32_lo, result32_hi;
    reg signed [63:0] result64;

    // Explicit sensitivity list (avoids ISE misreading * after (* *) attributes)
    always @(A or B or Op or shift or width or
             mul16_0 or mul16_1 or mul16_2 or mul16_3 or
             mul32_lo or mul32_hi or mul64 or
             simd_addsub) begin

        Out = 64'd0;

        case (width)

        // ================================
        // 16-bit SIMD
        // ================================
        2'b00: begin
            for (i = 0; i < 4; i = i+1) begin
                case (Op)
                    // ADD and SUB now use shared carry-kill result (no case needed here)
                    4'b0011: result16[i] = A16[i] << shift;                          // SHL
                    4'b0100: result16[i] = A16[i] >> shift;                          // SHR
                    4'b0101: result16[i] = (A16[i] == B16[i]) ? 16'd1 : 16'd0;      // EQ
                    4'b0110: result16[i] = (A16[i] <  B16[i]) ? 16'd1 : 16'd0;      // LT
                    4'b0111: result16[i] = (A16[i] >  B16[i]) ? 16'd1 : 16'd0;      // GT
                    4'b1001: result16[i] = B16[i];                                   // PASS
                    default: result16[i] = 16'd0;
                endcase
            end

            // MULT: can't index named wires in a loop, handled separately
            if (Op == 4'b1000) begin
                result16[0] = mul16_0[15:0];
                result16[1] = mul16_1[15:0];
                result16[2] = mul16_2[15:0];
                result16[3] = mul16_3[15:0];
            end

            // ADD/SUB: use shared carry-kill adder
            if (Op == 4'b0001 || Op == 4'b0010)
                Out = simd_addsub;
            else
                Out = {result16[3], result16[2], result16[1], result16[0]};
        end

        // ================================
        // 32-bit SIMD
        // ================================
        2'b01: begin
            case (Op)
                4'b0011: begin // SHL
                    result32_lo = A32_lo <<< shift;
                    result32_hi = A32_hi <<< shift;
                end
                4'b0100: begin // SHR
                    result32_lo = A32_lo >>> shift;
                    result32_hi = A32_hi >>> shift;
                end
                4'b0101: begin // EQ
                    result32_lo = (A32_lo == B32_lo) ? 32'd1 : 32'd0;
                    result32_hi = (A32_hi == B32_hi) ? 32'd1 : 32'd0;
                end
                4'b0110: begin // LT
                    result32_lo = (A32_lo < B32_lo) ? 32'd1 : 32'd0;
                    result32_hi = (A32_hi < B32_hi) ? 32'd1 : 32'd0;
                end
                4'b0111: begin // GT
                    result32_lo = (A32_lo > B32_lo) ? 32'd1 : 32'd0;
                    result32_hi = (A32_hi > B32_hi) ? 32'd1 : 32'd0;
                end
                4'b1000: begin // MULT (truncated 32-bit result from DSP48)
                    result32_lo = mul32_lo[31:0];
                    result32_hi = mul32_hi[31:0];
                end
                4'b1001: begin // PASS
                    result32_lo = B32_lo;
                    result32_hi = B32_hi;
                end
                4'b1010: begin // CVT (sign-extend 32 to 64)
                    result32_lo = A32_lo;
                    result32_hi = {32{A32_lo[31]}};
                end
                default: begin
                    result32_lo = 32'd0;
                    result32_hi = 32'd0;
                end
            endcase

            // ADD/SUB: use shared carry-kill adder
            if (Op == 4'b0001 || Op == 4'b0010)
                Out = simd_addsub;
            else
                Out = {result32_hi, result32_lo};
        end

        // ================================
        // 64-bit scalar
        // ================================
        2'b10: begin
            case (Op)
                4'b0011: result64 = A64 <<< shift;                      // SHL
                4'b0100: result64 = A64 >>> shift;                      // SHR
                4'b0101: result64 = (A64 == B64) ? 64'd1 : 64'd0;      // EQ
                4'b0110: result64 = (A64 <  B64) ? 64'd1 : 64'd0;      // LT
                4'b0111: result64 = (A64 >  B64) ? 64'd1 : 64'd0;      // GT
                4'b1000: result64 = mul64[63:0];                        // MULT
                4'b1001: result64 = B64;                                // PASS
                default: result64 = 64'd0;
            endcase

            // ADD/SUB: use shared carry-kill adder
            if (Op == 4'b0001 || Op == 4'b0010)
                Out = simd_addsub;
            else
                Out = result64;
        end

        default: Out = 64'd0;

        endcase
    end
endmodule
