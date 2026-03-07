`timescale 1ns / 1ps
module registerFile64BRAM(
    input clk2x,  // 2x pipeline clock
    input clr,
    input [4:0]  r1addr,
    input [4:0]  r2addr,
    input [4:0]  rdaddr,
    input [4:0]  waddr,
    input [63:0] wdata,
    input        wena,
    output reg [63:0] r1data,
    output reg [63:0] r2data,
    output reg [63:0] rddata
);
    (* ram_style = "block" *) reg [63:0] rf [31:0];

    // -------- Write on rising edge of 2x clock --------
    // This happens first within the pipeline clock period
    always @(posedge clk2x) begin
        if (wena && waddr != 5'd0)
            rf[waddr] <= wdata;
    end

    // -------- Read on falling edge of 2x clock --------
    // Half a 2x period later = write has already committed,
    // so reads see the just-written value within the same
    // pipeline clock cycle (no extra stage needed)
    always @(negedge clk2x) begin
        if (clr) begin
            r1data <= 64'd0;
            r2data <= 64'd0;
            rddata <= 64'd0;
        end else begin
            r1data <= (r1addr == 5'd0) ? 64'd0 : rf[r1addr];
            r2data <= (r2addr == 5'd0) ? 64'd0 : rf[r2addr];
            rddata <= (rdaddr == 5'd0) ? 64'd0 : rf[rdaddr];
        end
    end

endmodule
