module bf16_fma (
    input  wire        clk,
    input  wire        rst,
    input  wire        sub_c,
    input  wire [63:0] operand_a,
    input  wire [63:0] operand_b,
    input  wire [63:0] operand_c,
    output reg  [63:0] result,
    output reg         valid
);

// -------------------------------------------------------
// unpack
// -------------------------------------------------------
wire [3:0]  sign_a,   sign_b,   sign_c;
wire [31:0] exp_a,    exp_b,    exp_c;
wire [31:0] mant_a,   mant_b,   mant_c;
wire [3:0]  iszero_a, iszero_b, iszero_c;
wire [3:0]  isinf_a,  isinf_b,  isinf_c;
wire [3:0]  isnan_a,  isnan_b,  isnan_c;

bf16_unpack unpack_a (.operand(operand_a), .sign(sign_a), .exponent(exp_a), .mantissa(mant_a), .is_zero(iszero_a), .is_inf(isinf_a), .is_nan(isnan_a));
bf16_unpack unpack_b (.operand(operand_b), .sign(sign_b), .exponent(exp_b), .mantissa(mant_b), .is_zero(iszero_b), .is_inf(isinf_b), .is_nan(isnan_b));
bf16_unpack unpack_c (.operand(operand_c), .sign(sign_c), .exponent(exp_c), .mantissa(mant_c), .is_zero(iszero_c), .is_inf(isinf_c), .is_nan(isnan_c));

// -------------------------------------------------------
// STAGE 1 - multiply + align C
// -------------------------------------------------------
wire [15:0] mant_product [0:3];
wire [35:0] dsp_out      [0:3];

genvar k;
generate
    for (k = 0; k < 4; k = k + 1) begin : dsp_lane
        MULT18X18 dsp48 (
            .P (dsp_out[k]),
            .A ({10'b0, mant_a[k*8 +: 8]}),
            .B ({10'b0, mant_b[k*8 +: 8]})
        );
        assign mant_product[k] = dsp_out[k][15:0];
    end
endgenerate

// exponent of product: exp_a + exp_b - bias
wire [7:0] exp_product [0:3];
generate
    for (k = 0; k < 4; k = k + 1) begin : exp_sum
        assign exp_product[k] = exp_a[k*8 +: 8] + exp_b[k*8 +: 8] - 8'd127;
    end
endgenerate

// product sign
wire [3:0] sign_product;
generate
    for (k = 0; k < 4; k = k + 1) begin : sign_mul
        assign sign_product[k] = sign_a[k] ^ sign_b[k];
    end
endgenerate

// align C to product binary point
wire signed [8:0] shift_amt [0:3];
wire [27:0] aligned_c [0:3];
wire [3:0]  invert_c;
wire [3:0]  sticky;

generate
    for (k = 0; k < 4; k = k + 1) begin : align_lane
        assign shift_amt[k] = {1'b0, exp_product[k]} - {1'b0, exp_c[k*8 +: 8]};

        // place mant_c implicit-1 (bit 7) at bit 14 of the 28-bit accumulator
        wire [27:0] c_extended = {13'b0, mant_c[k*8 +: 8], 7'b0};

        assign aligned_c[k] = (iszero_c[k])        ? 28'h0 :
                               (shift_amt[k] >= 28) ? 28'h0 :
                               (shift_amt[k] >= 0)  ? c_extended >> shift_amt[k] :
                                                       c_extended << (-shift_amt[k]);

        // sticky: bits shifted below bit 0 of accumulator
        assign sticky[k] = (shift_amt[k] > 0 && shift_amt[k] < 28) ?
                           |(c_extended << (28 - shift_amt[k])) : 1'b0;

        // subtraction control folded in here
        assign invert_c[k] = sign_product[k] ^ sign_c[k] ^ sub_c;
    end
endgenerate

// stage 1 registers
reg [15:0] s1_mant_product [0:3];
reg [7:0]  s1_exp_product  [0:3];
reg [3:0]  s1_sign_product;
reg [27:0] s1_aligned_c    [0:3];
reg [3:0]  s1_invert_c;
reg [3:0]  s1_sticky;
reg [3:0]  s1_iszero_a, s1_iszero_b, s1_iszero_c;
reg [3:0]  s1_isinf_a,  s1_isinf_b,  s1_isinf_c;
reg [3:0]  s1_isnan_a,  s1_isnan_b,  s1_isnan_c;

integer j;
always @(posedge clk) begin
    if (rst) begin
        s1_sign_product <= 4'h0;
        s1_invert_c     <= 4'h0;
        s1_sticky       <= 4'h0;
        s1_iszero_a     <= 4'hF;
        s1_iszero_b     <= 4'hF;
        s1_iszero_c     <= 4'hF;
        s1_isinf_a      <= 4'h0;
        s1_isinf_b      <= 4'h0;
        s1_isinf_c      <= 4'h0;
        s1_isnan_a      <= 4'h0;
        s1_isnan_b      <= 4'h0;
        s1_isnan_c      <= 4'h0;
        for (j = 0; j < 4; j = j + 1) begin
            s1_mant_product[j] <= 16'h0;
            s1_exp_product[j]   <= 8'h0;
            s1_aligned_c[j]     <= 28'h0;
        end
    end else begin
        s1_sign_product <= sign_product;
        s1_invert_c     <= invert_c;
        s1_sticky       <= sticky;
        s1_iszero_a     <= iszero_a;
        s1_iszero_b     <= iszero_b;
        s1_iszero_c     <= iszero_c;
        s1_isinf_a      <= isinf_a;
        s1_isinf_b      <= isinf_b;
        s1_isinf_c      <= isinf_c;
        s1_isnan_a      <= isnan_a;
        s1_isnan_b      <= isnan_b;
        s1_isnan_c      <= isnan_c;
        for (j = 0; j < 4; j = j + 1) begin
            s1_mant_product[j] <= mant_product[j];
            s1_exp_product[j]  <= exp_product[j];
            s1_aligned_c[j]    <= aligned_c[j];
        end
    end
end

// -------------------------------------------------------
// STAGE 2 - add/sub product + C
// -------------------------------------------------------
wire [27:0] mag_result [0:3];
wire [3:0]  result_sign;

generate
    for (k = 0; k < 4; k = k + 1) begin : addsub_lane
        wire [27:0] prod_ext  = {12'b0, s1_mant_product[k]};
        wire        sub_op    = s1_invert_c[k];
        wire        prod_lt_c = (prod_ext < s1_aligned_c[k]);

        assign result_sign[k] = s1_sign_product[k] ^ (sub_op & prod_lt_c);

        assign mag_result[k] = sub_op
            ? (prod_lt_c ? (s1_aligned_c[k] - prod_ext)
                         : (prod_ext - s1_aligned_c[k]))
            : (prod_ext + s1_aligned_c[k]);
    end
endgenerate

// stage 2 registers
reg [27:0] s2_result     [0:3];
reg [7:0]  s2_exp        [0:3];
reg [3:0]  s2_sign;
reg [3:0]  s2_sticky;
reg [3:0]  s2_result_zero;
reg [3:0]  s2_iszero_a, s2_iszero_b, s2_iszero_c;
reg [3:0]  s2_isinf_a,  s2_isinf_b,  s2_isinf_c;
reg [3:0]  s2_isnan_a,  s2_isnan_b,  s2_isnan_c;

always @(posedge clk) begin
    if (rst) begin
        s2_sign        <= 4'h0;
        s2_sticky      <= 4'h0;
        s2_result_zero <= 4'h0;
        s2_iszero_a    <= 4'hF;
        s2_iszero_b    <= 4'hF;
        s2_iszero_c    <= 4'hF;
        s2_isinf_a     <= 4'h0;
        s2_isinf_b     <= 4'h0;
        s2_isinf_c     <= 4'h0;
        s2_isnan_a     <= 4'h0;
        s2_isnan_b     <= 4'h0;
        s2_isnan_c     <= 4'h0;
        for (j = 0; j < 4; j = j + 1) begin
            s2_result[j] <= 28'h0;
            s2_exp[j]    <= 8'h0;
        end
    end else begin
        s2_sign     <= result_sign;
        s2_sticky   <= s1_sticky;
        s2_iszero_a <= s1_iszero_a;
        s2_iszero_b <= s1_iszero_b;
        s2_iszero_c <= s1_iszero_c;
        s2_isinf_a  <= s1_isinf_a;
        s2_isinf_b  <= s1_isinf_b;
        s2_isinf_c  <= s1_isinf_c;
        s2_isnan_a  <= s1_isnan_a;
        s2_isnan_b  <= s1_isnan_b;
        s2_isnan_c  <= s1_isnan_c;
        for (j = 0; j < 4; j = j + 1) begin
            s2_result[j]      <= mag_result[j];
            s2_exp[j]         <= s1_exp_product[j];
            s2_result_zero[j]  <= (mag_result[j] == 28'h0);
        end
    end
end

// -------------------------------------------------------
// STAGE 3 - normalize + round + pack
// -------------------------------------------------------
wire [15:0] packed [0:3];

generate
    for (k = 0; k < 4; k = k + 1) begin : final_lane
        wire [27:0] r = s2_result[k];

        wire [4:0] lza_count =
            r[27] ? 5'd0  :
            r[26] ? 5'd1  :
            r[25] ? 5'd2  :
            r[24] ? 5'd3  :
            r[23] ? 5'd4  :
            r[22] ? 5'd5  :
            r[21] ? 5'd6  :
            r[20] ? 5'd7  :
            r[19] ? 5'd8  :
            r[18] ? 5'd9  :
            r[17] ? 5'd10 :
            r[16] ? 5'd11 :
            r[15] ? 5'd12 :
            r[14] ? 5'd13 :
            r[13] ? 5'd14 :
            r[12] ? 5'd15 :
            r[11] ? 5'd16 :
            r[10] ? 5'd17 :
            r[9]  ? 5'd18 :
            r[8]  ? 5'd19 :
            r[7]  ? 5'd20 :
            r[6]  ? 5'd21 :
            r[5]  ? 5'd22 :
            r[4]  ? 5'd23 :
            r[3]  ? 5'd24 :
            r[2]  ? 5'd25 :
            r[1]  ? 5'd26 :
                     5'd27;

        wire [27:0] norm_mant = r << lza_count;
        wire [7:0]  norm_exp  = s2_exp[k] - {3'b0, lza_count} + 8'd13;

        wire guard      = norm_mant[19];
        wire round_bit  = norm_mant[18];
        wire sticky_in  = s2_sticky[k] | (|norm_mant[17:0]);
        wire lsb        = norm_mant[20];

        wire round_up   = guard & (round_bit | sticky_in | lsb);

        wire [7:0] mant_rounded = {1'b0, norm_mant[26:20]} + {7'b0, round_up};
        wire overflow   = mant_rounded[7];

        wire [6:0] rounded_mant = mant_rounded[6:0];
        wire [7:0] rounded_exp   = norm_exp + {7'b0, overflow};

        wire out_nan  = s2_isnan_a[k] | s2_isnan_b[k] | s2_isnan_c[k] |
                        (s2_isinf_a[k] & s2_isinf_b[k] & (s2_isnan_a[k] ^ s2_isnan_b[k]));
        wire out_inf  = (s2_isinf_a[k] | s2_isinf_b[k]) & ~out_nan;
        wire out_zero = ((s2_iszero_a[k] | s2_iszero_b[k]) & s2_iszero_c[k] |
                         s2_result_zero[k]) & ~out_inf & ~out_nan;

        assign packed[k] = out_nan  ? 16'h7FC0 :
                           out_inf  ? {s2_sign[k], 15'h7F80} :
                           out_zero ? 16'h0000 :
                                      {s2_sign[k], rounded_exp, rounded_mant};
    end
endgenerate

always @(posedge clk) begin
    if (rst) begin
        result <= 64'h0;
        valid  <= 1'b0;
    end else begin
        result <= {packed[3], packed[2], packed[1], packed[0]};
        valid  <= 1'b1;
    end
end

endmodule