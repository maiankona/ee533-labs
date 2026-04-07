`timescale 1ns / 1ps

module registerFile64BRAM_wrapper (
    input              clk,      // pipeline clock
    input              clk2x,    // fast clock (ONLY used here)
    input              reset,

    input      [4:0]   r1addr,
    input      [4:0]   r2addr,
    input      [4:0]   rdaddr,
    input      [4:0]   waddr,
    input      [63:0]  wdata,
    input              wena,

    output reg [63:0]  r1data,
    output reg [63:0]  r2data,
    output reg [63:0]  rddata
);

    // One copy per read port (3 reads total)
    (* ram_style = "block" *) reg [63:0] rf0 [31:0];
    (* ram_style = "block" *) reg [63:0] rf1 [31:0];
    (* ram_style = "block" *) reg [63:0] rf2 [31:0];

    // WRITE (clk2x domain)
    always @(posedge clk2x) begin
        if (wena && (waddr != 5'd0)) begin
            rf0[waddr] <= wdata;
            rf1[waddr] <= wdata;
            rf2[waddr] <= wdata;
        end
    end

    // READ (clk domain)
    always @(posedge clk) begin
        if (reset) begin
            r1data <= 64'd0;
            r2data <= 64'd0;
            rddata <= 64'd0;
        end else begin
            r1data <= (r1addr == 5'd0) ? 64'd0 : rf0[r1addr];
            r2data <= (r2addr == 5'd0) ? 64'd0 : rf1[r2addr];
            rddata <= (rdaddr == 5'd0) ? 64'd0 : rf2[rdaddr];
        end
    end

endmodule