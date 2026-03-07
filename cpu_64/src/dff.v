`timescale 1ns / 1ps

module dff_reset (
    input clk,
    input rst,  // Active-high reset
    input D,
    output reg Q
);

    // Asynchronous Reset: Logic triggers immediately when 'reset' goes high
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Q <= 1'b0;  // Reset output to 0
        end else begin
            Q <= D;     // Capture input on the rising edge of clock
        end
    end

endmodule