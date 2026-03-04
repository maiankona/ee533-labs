module registerFile64_bram(
    input clk,
    input clr,                 // we'll handle reset separately
    input [4:0]  r1addr,
    input [4:0]  r2addr,
    input [4:0]  rdaddr,
    input [4:0]  waddr,
    input [63:0] wdata,
    input        wena,
    output [63:0] r1data,
    output [63:0] r2data,
    output [63:0] rddata
);

    wire [63:0] bram0_rdata;
    wire [63:0] bram1_rdata;

    // ============================
    // BRAM 0 (r1 + write)
    // ============================
    rf_bram bram0 (
        .clka(clk),
        .addra(r1addr),
        .dina(64'd0),
        .wea(1'b0),
        .douta(bram0_rdata),

        .clkb(clk),
        .addrb(waddr),
        .dinb(wdata),
        .web(wena && (waddr != 5'd0)),
        .doutb()
    );

    // ============================
    // BRAM 1 (r2 + rd)
    // ============================
    rf_bram bram1 (
        .clka(clk),
        .addra(r2addr),
        .dina(64'd0),
        .wea(1'b0),
        .douta(bram1_rdata),

        .clkb(clk),
        .addrb(rdaddr),
        .dinb(wdata),
        .web(wena && (waddr != 5'd0)),
        .doutb(rddata)
    );

    // ============================
    // Forwarding logic (same as before)
    // ============================

    assign r1data =
        (r1addr == 5'd0) ? 64'd0 :
        (wena && (waddr == r1addr)) ? wdata :
        bram0_rdata;

    assign r2data =
        (r2addr == 5'd0) ? 64'd0 :
        (wena && (waddr == r2addr)) ? wdata :
        bram1_rdata;

endmodule
