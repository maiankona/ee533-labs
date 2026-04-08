`timescale 1ns / 1ps

module memory (
    input         clk,
    input         write_to_dmem,
    input         read_req_dmem,
    input  [7:0]  addr_dmem_host,
    input  [31:0] data_dmem_host,
    input  [31:0] pipeline_addr,
    input  [63:0] pipeline_data,
    input         pipeline_we,
    output [63:0] dmem_out
);
    wire host_active = write_to_dmem || read_req_dmem;

    wire [7:0]  final_addr = host_active ? addr_dmem_host : pipeline_addr[7:0];

    // Host write: replicate 32-bit data across both 32-bit halves
    // Pipeline write: full 64-bit tensor result
    wire [63:0] final_din = write_to_dmem ? {data_dmem_host, data_dmem_host}
                                           : pipeline_data;

    wire final_we = write_to_dmem ? 1'b1 : pipeline_we;

    mem64bit256 dmem_blk (
        .clka  (clk),
        .clkb  (clk),
        .addra (final_addr),
        .addrb (final_addr),
        .dina  (final_din),
        .wea   (final_we),
        .doutb (dmem_out)
    );

endmodule