`timescale 1ns / 1ps
module bf16_add (
    input  [15:0] a,
    input  [15:0] b,
    input  [5:0]  operation,  // 6'b000000 = add, 6'b000001 = sub
    output [15:0] result
);
    // =========================================================
    // BF16: 1 sign, 8 exponent (bias 127), 7 mantissa bits
    // Full mantissa with hidden bit: {1, man[6:0]} = 8 bits, hidden at bit 7
    // =========================================================

    wire        a_sign = a[15];
    wire [7:0]  a_exp  = a[14:7];
    wire [6:0]  a_man  = a[6:0];

    wire        b_sign_raw = b[15];
    wire [7:0]  b_exp      = b[14:7];
    wire [6:0]  b_man      = b[6:0];

    // Flip b sign for subtraction
    wire b_sign = b_sign_raw ^ operation[0];

    // Zero detection
    wire a_zero = (a_exp == 8'h00);
    wire b_zero = (b_exp == 8'h00);

    // 8-bit full mantissa with hidden bit at bit 7
    wire [7:0] a_full = a_zero ? 8'h00 : {1'b1, a_man};
    wire [7:0] b_full = b_zero ? 8'h00 : {1'b1, b_man};

    // =========================================================
    // Align smaller exponent operand to larger
    // =========================================================
    wire        a_larger  = (a_exp >= b_exp);
    wire [7:0]  exp_large = a_larger ? a_exp : b_exp;
    wire [7:0]  shift_a   = a_larger ? 8'd0  : (b_exp - a_exp);
    wire [7:0]  shift_b   = a_larger ? (a_exp - b_exp) : 8'd0;

    wire [7:0]  a_aligned = (shift_a >= 8) ? 8'd0 : (a_full >> shift_a);
    wire [7:0]  b_aligned = (shift_b >= 8) ? 8'd0 : (b_full >> shift_b);

    // =========================================================
    // Effective add or subtract based on signs
    // =========================================================
    wire eff_sub = a_sign ^ b_sign;

    // 9-bit sum to capture overflow at bit 8
    wire [8:0] sum_add = {1'b0, a_aligned} + {1'b0, b_aligned};
    wire [8:0] sum_sub = (a_aligned >= b_aligned)
                             ? ({1'b0, a_aligned} - {1'b0, b_aligned})
                             : ({1'b0, b_aligned} - {1'b0, a_aligned});

    wire [8:0] sum_mag = eff_sub ? sum_sub : sum_add;

    wire res_sign = eff_sub ? ((a_aligned >= b_aligned) ? a_sign : b_sign)
                            : a_sign;

    // =========================================================
    // Normalize
    // Overflow: bit 8 set -> shift right 1, increment exponent
    // Otherwise: count leading zeros below bit 7, shift left
    // =========================================================
    wire overflow = sum_mag[8];

    wire [3:0] lz = sum_mag[7] ? 4'd0 :
                    sum_mag[6] ? 4'd1 :
                    sum_mag[5] ? 4'd2 :
                    sum_mag[4] ? 4'd3 :
                    sum_mag[3] ? 4'd4 :
                    sum_mag[2] ? 4'd5 :
                    sum_mag[1] ? 4'd6 :
                    sum_mag[0] ? 4'd7 : 4'd8;

    wire res_zero = (sum_mag == 9'd0);

    // Normalized 8-bit mantissa (hidden bit at bit 7)
    wire [7:0] norm_man = overflow  ? sum_mag[8:1]                   // >>1, drop bit0
                        : res_zero  ? 8'd0
                        :             (sum_mag[7:0] << lz);           // shift up

    wire [7:0] res_exp  = overflow  ? (exp_large + 8'd1)
                        : res_zero  ? 8'd0
                        :             (exp_large - {4'd0, lz});

    // Drop hidden bit (bit 7), keep lower 7 bits as mantissa
    wire [6:0] res_man = norm_man[6:0];

    // =========================================================
    // Output
    // =========================================================
    assign result = res_zero ? 16'h0000 : {res_sign, res_exp, res_man};

endmodule
