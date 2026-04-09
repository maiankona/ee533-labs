module mant_mul_test (
    input  wire        clk,
    input  wire        rst,
    input  wire [7:0]  mant_a,
    input  wire [7:0]  mant_b,
    output wire [15:0] product
);

wire [35:0] dsp_out;

MULT18X18S dsp48_mul (
    .P  (dsp_out),
    .A  ({10'b0, mant_a}),
    .B  ({10'b0, mant_b}),
    .C  (clk),
    .CE (1'b1),
    .R  (rst)
);

assign product = dsp_out[15:0];

endmodule