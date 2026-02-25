`timescale 1ns / 1ps

module register_generate #(parameter WIDTH = 1)(
    input clk,
    input rst,
    input [WIDTH-1:0] d_in,
    output [WIDTH-1:0] q_out
    );

    genvar i;

    generate //bitwise call for mapping at the bit level
        for (i = 0; i < WIDTH; i = i + 1) begin : dff_gen
            dff_reset dff_inst (
                .clk(clk),
                .rst(rst),
                .D(d_in[i]),
                .Q(q_out[i])
            );
        end
    endgenerate
	 
endmodule