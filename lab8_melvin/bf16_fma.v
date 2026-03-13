module bf16_fma (
    input  wire        clk,
    input  wire        rst,
    input  wire [63:0] operand_a,    // 4 lanes BF16
    input  wire [63:0] operand_b,
    input  wire [63:0] operand_c,
    input  wire [1:0]  opcode,       // 00=FMA, 01=VMUL, 10=VADD
    output reg  [63:0] result,
    output reg         valid
);

// --- opcodes ---
localparam FMA  = 2'b00;
localparam VMUL = 2'b01;
localparam VADD = 2'b10;

// --- input steering ---
wire [63:0] op_a, op_b, op_c;
assign op_a = (opcode == VADD) ? 64'h3F80_3F80_3F80_3F80 : operand_a;
assign op_b = (opcode == VADD) ? operand_a                : operand_b;
assign op_c = (opcode == VMUL) ? 64'h0000_0000_0000_0000 : operand_c;

// -------------------------------------------------------
// STAGE 1 ? unpack + multiply + align
// -------------------------------------------------------

// unpack all three operands
wire [3:0]  sign_a, sign_b, sign_c;
wire [31:0] exp_a,  exp_b,  exp_c;
wire [31:0] mant_a, mant_b, mant_c;
wire [3:0]  iszero_a, iszero_b, iszero_c;
wire [3:0]  isinf_a,  isinf_b,  isinf_c;
wire [3:0]  isnan_a,  isnan_b,  isnan_c;

bf16_unpack unpack_a (.operand(op_a), .sign(sign_a), .exponent(exp_a), .mantissa(mant_a), .is_zero(iszero_a), .is_inf(isinf_a), .is_nan(isnan_a));
bf16_unpack unpack_b (.operand(op_b), .sign(sign_b), .exponent(exp_b), .mantissa(mant_b), .is_zero(iszero_b), .is_inf(isinf_b), .is_nan(isnan_b));
bf16_unpack unpack_c (.operand(op_c), .sign(sign_c), .exponent(exp_c), .mantissa(mant_c), .is_zero(iszero_c), .is_inf(isinf_c), .is_nan(isnan_c));

// DSP48 multipliers ? one per lane
wire [15:0] mant_product [0:3];
wire [35:0] dsp_out      [0:3];

genvar k;
generate
    for (k = 0; k < 4; k = k + 1) begin : dsp_lane
        MULT18X18S dsp48 (
            .P  (dsp_out[k]),
            .A  ({10'b0, mant_a[k*8 +: 8]}),
            .B  ({10'b0, mant_b[k*8 +: 8]}),
            .C  (clk),
            .CE (1'b1),
            .R  (rst)
        );
        assign mant_product[k] = dsp_out[k][15:0];
    end
endgenerate

// exponent sum per lane (combinational, registered at stage 1 boundary)
wire [7:0] exp_product [0:3];
generate
    for (k = 0; k < 4; k = k + 1) begin : exp_sum
        assign exp_product[k] = exp_a[k*8 +: 8] + exp_b[k*8 +: 8] - 8'd127;
    end
endgenerate

// product sign per lane
wire [3:0] sign_product;
generate
    for (k = 0; k < 4; k = k + 1) begin : sign_mul
        assign sign_product[k] = sign_a[k] ^ sign_b[k];
    end
endgenerate

// align operand C to product binary point
wire signed [8:0] shift_amt [0:3];  // signed shift amount
wire [27:0] aligned_c  [0:3];       // 28-bit aligned C
wire [3:0]  invert_c;               // subtraction flag
wire [3:0]  sticky;                 // sticky bits

generate
    for (k = 0; k < 4; k = k + 1) begin : align_lane
        assign shift_amt[k] = {1'b0, exp_product[k]} - {1'b0, exp_c[k*8 +: 8]};

        // C mantissa extended to 28 bits, placed at correct position
        wire [27:0] c_extended = {mant_c[k*8 +: 8], 20'h00000};

        assign aligned_c[k] = (iszero_c[k])          ? 28'h0 :
                               (shift_amt[k] >= 28)   ? 28'h0 :
                               (shift_amt[k] >= 0)    ? c_extended >> shift_amt[k] :
                                                        c_extended << (-shift_amt[k]);

        assign sticky[k]   = (shift_amt[k] > 0 && shift_amt[k] < 28) ?
                              |(mant_c[k*8 +: 8] << (8 - shift_amt[k])) : 1'b0;

        assign invert_c[k] = sign_product[k] ^ sign_c[k];
    end
endgenerate

// --- stage 1 pipeline registers ---
// DSP48 internal register IS the stage 1 reg for mant_product
// we register everything else here to match

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
            s1_exp_product[j]  <= 8'h0;
            s1_aligned_c[j]    <= 28'h0;
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
// STAGE 2 ? CSA + CPA + complement
// -------------------------------------------------------

wire [27:0] csa_sum  [0:3];
wire [27:0] csa_carry[0:3];
wire [27:0] cpa_result[0:3];
wire [3:0]  result_sign;

generate
    for (k = 0; k < 4; k = k + 1) begin : csa_lane
        // extend product to 28 bits ? binary point at bit 14
        wire [27:0] prod_ext = {12'b0, s1_mant_product[k]};

        // invert C if subtraction
        wire [27:0] c_in = s1_invert_c[k] ? ~s1_aligned_c[k] : s1_aligned_c[k];

        // 3:2 CSA ? reduces prod_ext, c_in, invert_c (as +1 for two's complement)
        assign csa_sum[k]   = prod_ext ^ c_in ^ {27'b0, s1_invert_c[k]};
        assign csa_carry[k] = ((prod_ext & c_in) |
                               (prod_ext & {27'b0, s1_invert_c[k]}) |
                               (c_in & {27'b0, s1_invert_c[k]})) << 1;

        // CPA resolves sum + carry
        assign cpa_result[k] = csa_sum[k] + csa_carry[k];

        // result is negative if subtraction and carry out lost
        assign result_sign[k] = s1_sign_product[k] ^
                                 (s1_invert_c[k] & ~cpa_result[k][27]);
    end
endgenerate

// complement if result negative
wire [27:0] abs_result[0:3];
generate
    for (k = 0; k < 4; k = k + 1) begin : complement_lane
        assign abs_result[k] = result_sign[k] ? (~cpa_result[k] + 1'b1)
                                               : cpa_result[k];
    end
endgenerate

// --- stage 2 pipeline registers ---
reg [27:0] s2_result     [0:3];
reg [7:0]  s2_exp        [0:3];
reg [3:0]  s2_sign;
reg [3:0]  s2_sticky;
reg [3:0]  s2_iszero_a, s2_iszero_b, s2_iszero_c;
reg [3:0]  s2_isinf_a,  s2_isinf_b,  s2_isinf_c;
reg [3:0]  s2_isnan_a,  s2_isnan_b,  s2_isnan_c;

always @(posedge clk) begin
    if (rst) begin
        s2_sign     <= 4'h0;
        s2_sticky   <= 4'h0;
        s2_iszero_a <= 4'hF;
        s2_iszero_b <= 4'hF;
        s2_iszero_c <= 4'hF;
        s2_isinf_a  <= 4'h0;
        s2_isinf_b  <= 4'h0;
        s2_isinf_c  <= 4'h0;
        s2_isnan_a  <= 4'h0;
        s2_isnan_b  <= 4'h0;
        s2_isnan_c  <= 4'h0;
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
            s2_result[j] <= abs_result[j];
            s2_exp[j]    <= s1_exp_product[j];
        end
    end
end

// -------------------------------------------------------
// STAGE 3 ? LZA + normalize
// -------------------------------------------------------

wire [4:0]  lza_count  [0:3];   // leading zero count (0-27)
wire [27:0] norm_mant  [0:3];
wire [7:0]  norm_exp   [0:3];

generate
    for (k = 0; k < 4; k = k + 1) begin : normalize_lane

        // LZA ? count leading zeros
        wire [27:0] r = s2_result[k];
        assign lza_count[k] = r[27] ? 5'd0  :
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

        // barrel shift left by lza_count to normalize
        assign norm_mant[k] = s2_result[k] << lza_count[k];

        // adjust exponent
        assign norm_exp[k]  = s2_exp[k] - {3'b0, lza_count[k]};
    end
endgenerate

// --- stage 3 pipeline registers ---
reg [27:0] s3_mant [0:3];
reg [7:0]  s3_exp  [0:3];
reg [3:0]  s3_sign;
reg [3:0]  s3_sticky;
reg [3:0]  s3_iszero_a, s3_iszero_b, s3_iszero_c;
reg [3:0]  s3_isinf_a,  s3_isinf_b,  s3_isinf_c;
reg [3:0]  s3_isnan_a,  s3_isnan_b,  s3_isnan_c;

always @(posedge clk) begin
    if (rst) begin
        s3_sign     <= 4'h0;
        s3_sticky   <= 4'h0;
        s3_iszero_a <= 4'hF;
        s3_iszero_b <= 4'hF;
        s3_iszero_c <= 4'hF;
        s3_isinf_a  <= 4'h0;
        s3_isinf_b  <= 4'h0;
        s3_isinf_c  <= 4'h0;
        s3_isnan_a  <= 4'h0;
        s3_isnan_b  <= 4'h0;
        s3_isnan_c  <= 4'h0;
        for (j = 0; j < 4; j = j + 1) begin
            s3_mant[j] <= 28'h0;
            s3_exp[j]  <= 8'h0;
        end
    end else begin
        s3_sign     <= s2_sign;
        s3_sticky   <= s2_sticky;
        s3_iszero_a <= s2_iszero_a;
        s3_iszero_b <= s2_iszero_b;
        s3_iszero_c <= s2_iszero_c;
        s3_isinf_a  <= s2_isinf_a;
        s3_isinf_b  <= s2_isinf_b;
        s3_isinf_c  <= s2_isinf_c;
        s3_isnan_a  <= s2_isnan_a;
        s3_isnan_b  <= s2_isnan_b;
        s3_isnan_c  <= s2_isnan_c;
        for (j = 0; j < 4; j = j + 1) begin
            s3_mant[j] <= norm_mant[j];
            s3_exp[j]  <= norm_exp[j];
        end
    end
end

// -------------------------------------------------------
// STAGE 4 ? round + pack output
// -------------------------------------------------------

wire [6:0]  rounded_mant [0:3];
wire [7:0]  rounded_exp  [0:3];
wire [15:0] packed       [0:3];

generate
    for (k = 0; k < 4; k = k + 1) begin : round_lane

        // guard bit = bit 19 (first bit after the 8-bit mantissa window)
        // round bit = bit 18
        wire guard  = s3_mant[k][19];
        wire round  = s3_mant[k][18];
        wire sticky_in = s3_sticky[k] | (|s3_mant[k][17:0]);

        // round to nearest even
        wire round_up = guard & (round | sticky_in | s3_mant[k][20]);

        wire [7:0] mant_rounded = s3_mant[k][26:19] + {7'b0, round_up};

        // post-normalize: if rounding caused overflow (mant == 8'h00 after +1 wrap)
        wire overflow = round_up & (s3_mant[k][26:19] == 8'hFF);

        assign rounded_mant[k] = mant_rounded[6:0];
        assign rounded_exp[k]  = s3_exp[k] + {7'b0, overflow};

        // special case output mux
        wire out_nan  = s3_isnan_a[k]  | s3_isnan_b[k]  | s3_isnan_c[k]  |
                        (s3_isinf_a[k] & s3_isinf_b[k] & (s3_isnan_a[k] ^ s3_isnan_b[k]));
        wire out_inf  = (s3_isinf_a[k] | s3_isinf_b[k]) & ~out_nan;
        wire out_zero = (s3_iszero_a[k] | s3_iszero_b[k]) & s3_iszero_c[k] & ~out_inf & ~out_nan;

        assign packed[k] = out_nan  ? 16'h7FC0 :
                           out_inf  ? {s3_sign[k], 15'h7F80} :
                           out_zero ? 16'h0000 :
                                      {s3_sign[k], rounded_exp[k], rounded_mant[k]};
    end
endgenerate

// --- stage 4 output register ---
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