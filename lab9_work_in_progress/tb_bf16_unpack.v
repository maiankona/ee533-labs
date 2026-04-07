`timescale 1ns/1ps

module tb_bf16_unpack;

reg [63:0] operand;
wire [3:0]  sign;
wire [31:0] exponent;
wire [31:0] mantissa;
wire [3:0]  is_zero;
wire [3:0]  is_inf;
wire [3:0]  is_nan;

bf16_unpack uut (
    .operand(operand),
    .sign(sign),
    .exponent(exponent),
    .mantissa(mantissa),
    .is_zero(is_zero),
    .is_inf(is_inf),
    .is_nan(is_nan)
);

initial begin
    $display("lane | sign | exp      | mant     | zero | inf | nan");
    $display("-----|------|----------|----------|------|-----|----");

    #10 operand = 64'h0000_0000_0000_0000;
    #1 $display("zero  | %b    | %h | %h | %b    | %b   | %b", sign, exponent, mantissa, is_zero, is_inf, is_nan);

    #10 operand = 64'h8000_8000_8000_8000;
    #1 $display("-zero | %b    | %h | %h | %b    | %b   | %b", sign, exponent, mantissa, is_zero, is_inf, is_nan);

    #10 operand = 64'h7F80_7F80_7F80_7F80;
    #1 $display("inf   | %b    | %h | %h | %b    | %b   | %b", sign, exponent, mantissa, is_zero, is_inf, is_nan);

    #10 operand = 64'h7FC0_7FC0_7FC0_7FC0;
    #1 $display("nan   | %b    | %h | %h | %b    | %b   | %b", sign, exponent, mantissa, is_zero, is_inf, is_nan);

    #10 operand = 64'h0040_0040_0040_0040;
    #1 $display("denorm| %b    | %h | %h | %b    | %b   | %b", sign, exponent, mantissa, is_zero, is_inf, is_nan);

    #10 operand = 64'h3F80_3F80_3F80_3F80;
    #1 $display("1.0   | %b    | %h | %h | %b    | %b   | %b", sign, exponent, mantissa, is_zero, is_inf, is_nan);

    #10 $finish;
end

endmodule