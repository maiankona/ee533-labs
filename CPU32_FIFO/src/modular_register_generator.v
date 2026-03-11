`timescale 1ns / 1ps

//behavioral call to allow for simplified synthesis (generate apparently can mess things up here)
module register_generate #(parameter WIDTH = 1)(
    input clk,
    input rst,
    input [WIDTH-1:0] d_in,
    output reg [WIDTH-1:0] q_out
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q_out <= {WIDTH{1'b0}};
        end else begin
            q_out <= d_in;
        end
    end
endmodule