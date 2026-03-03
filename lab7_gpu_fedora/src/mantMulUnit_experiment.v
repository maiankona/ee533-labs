`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// mantMulUnit.v  -  BF16 mantissa multiplier
//
// Change from original: added (* use_dsp48 = "yes" *) on a SEPARATE line above
// the product wire declaration so that ISE maps the 8x8 multiply to a DSP48
// block instead of SLICE fabric.
//
// With 4 bf16Mul instances, this frees ~4 x 8 SLICEs (depending on tool version)
// and uses 4 DSP48 blocks (2vp50 has 232, so the budget is comfortable).
//////////////////////////////////////////////////////////////////////////////////

module mantMulUnit (
    input  [6:0]  oprA,
    input  [6:0]  oprB,
    output [15:0] out
);
    // Prepend the implicit leading '1' (hidden bit) to each 7-bit mantissa
    wire [7:0] fullMantA = {1'b1, oprA};
    wire [7:0] fullMantB = {1'b1, oprB};

    // DSP48 directive MUST be on its own line above the wire declaration.
    // Placing it inline (e.g. wire ... (* *) ...) confuses the ISE parser.
    (* use_dsp48 = "yes" *)
    wire [15:0] product = fullMantA * fullMantB;

    assign out = product;

endmodule
