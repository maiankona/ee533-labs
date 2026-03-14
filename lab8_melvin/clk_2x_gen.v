`timescale 1ns/1ps
module clk_2x_gen (
    input  clk_in,
    output clk2x,
    output locked
);
    wire clk2x_unbuf;

    DCM #(
        .CLKIN_PERIOD        (8.0),
        .CLK_FEEDBACK        ("1X"),
        .CLKOUT_PHASE_SHIFT  ("NONE"),
        .DLL_FREQUENCY_MODE  ("LOW"),
        .DUTY_CYCLE_CORRECTION("TRUE"),
        .STARTUP_WAIT        ("FALSE")
    ) dcm_inst (
        .CLKIN   (clk_in),
        .CLKFB   (clk_in),
        .CLK2X   (clk2x_unbuf),
        .RST     (1'b0),
        .LOCKED  (locked),
        .CLK0    (),
        .CLK90   (),
        .CLK180  (),
        .CLK270  (),
        .CLK2X180(),
        .CLKDV   (),
        .CLKFX   (),
        .CLKFX180(),
        .PSDONE  (),
        .STATUS  ()
    );

    BUFG bufg_2x (
        .I (clk2x_unbuf),
        .O (clk2x)
    );

endmodule