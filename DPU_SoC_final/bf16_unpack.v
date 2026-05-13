module bf16_unpack (
    input  wire [63:0] operand,
    output wire [3:0]  sign,
    output wire [31:0] exponent,   // 8 bits per lane
    output wire [31:0] mantissa,   // 8 bits per lane, implicit 1 restored
    output wire [3:0]  is_zero,
    output wire [3:0]  is_inf,
    output wire [3:0]  is_nan
);

// --- lane slices ---
wire [15:0] lane [0:3];
assign lane[0] = operand[15:0];
assign lane[1] = operand[31:16];
assign lane[2] = operand[47:32];
assign lane[3] = operand[63:48];

// --- per-lane fields ---
wire [7:0] exp  [0:3];
wire [6:0] mant [0:3];

genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin : unpack_lane
        assign sign[i]              = lane[i][15];
        assign exp[i]               = lane[i][14:7];
        assign mant[i]              = lane[i][6:0];

        // restore implicit leading 1 for normal numbers
        // zero/denormal gets 0 mantissa, normal gets {1, mant}
        assign mantissa[i*8 +: 8]  = (exp[i] == 8'h00) ? 8'h00
                                                        : {1'b1, mant[i]};

        assign exponent[i*8 +: 8]  = exp[i];

        // --- special case flags ---
        assign is_zero[i] = (exp[i] == 8'h00);   // zero + denormal
        assign is_inf[i]  = (exp[i] == 8'hFF) && (mant[i] == 7'h00);
        assign is_nan[i]  = (exp[i] == 8'hFF) && (mant[i] != 7'h00);
    end
endgenerate

endmodule