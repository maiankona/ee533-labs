module bf16Mul (
    input  [15:0] oprA,
    input  [15:0] oprB,
    output [15:0] result 
);
    wire [8:0] expAddOut;
    wire [7:0] expAddoutFinal;
    wire [6:0] mantOutFinal;
    wire [15:0] mantOut;
    wire resultSign, addOneSel;

    // Exponent adder
    expAddUnit exp (
        .oprA(oprA[14:7]),
        .oprB(oprB[14:7]),
        .out(expAddOut)
    );

    // Mantissa multiplier
    mantMulUnit mant (
        .oprA(oprA[6:0]),
        .oprB(oprB[6:0]),
        .out(mantOut)
    );

    assign addOneSel     = mantOut[15];
    assign mantOutFinal  = addOneSel ? mantOut[14:8] : mantOut[13:7];
    assign resultSign    = oprA[15] ^ oprB[15];
    assign expAddoutFinal = addOneSel ? (expAddOut - 8'd127 + 1)
                                      : (expAddOut - 8'd127);
												  
    // if two zero exponents (0 + 0 - 127 = -127 wraps to a non-zero value).
    // Check the magnitude bits only (ignore sign) so -0 is also caught.
    wire a_is_zero = (oprA[14:0] == 15'b0);
    wire b_is_zero = (oprB[14:0] == 15'b0);

    assign result = (a_is_zero | b_is_zero)
                        ? 16'b0
                        : {resultSign, expAddoutFinal, mantOutFinal};

endmodule
