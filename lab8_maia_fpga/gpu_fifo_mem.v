`timescale 1ns/1ps
//
// GPU DMEM via convertible FIFO - same pattern as memory.v (CPU) but uses
// convertible_fifo BRAM instead of mem64bit256. Put inside pipeline like
// pipeline_pseudoARM has memory inside.
//
// Host: 32-bit writes (even addr = lo, odd = hi of same 64b word).
// Pipeline: 64-bit load/store.
//
module gpu_fifo_mem (
    input         clk,
    input         rst,

    // Host interface (from ids)
    input         write_to_dmem,
    input         read_req_dmem,
    input  [7:0]  addr_dmem_host,
    input  [31:0] data_dmem_host,

    // Pipeline interface
    input  [7:0]  pipeline_addr,
    input  [63:0] pipeline_data,
    input         pipeline_we,
    input         pipeline_mem_read,

    // GPU mode: 1 = enter PROCESSING without network packet
    input         gpu_mode,

    output [63:0] dmem_out
);

    wire [71:0] raw_data_out;
    wire [31:0] cpu_data_out;

    // Host 32-bit -> 64-bit: even addr = lower 32, odd = upper 32 of same word
    wire [7:0] host_phys_addr = addr_dmem_host & 8'hFE;
    reg [31:0] pending_lo;
    always @(posedge clk) begin
        if (rst) pending_lo <= 32'h0;
        else if (write_to_dmem && !addr_dmem_host[0]) pending_lo <= data_dmem_host;
    end
    wire [63:0] host_data_64 = addr_dmem_host[0] ? {data_dmem_host, pending_lo} : {32'h0, data_dmem_host};

    // Host write: only write to BRAM on odd addr (we have full 64b word). Even addr just updates pending_lo.
    wire host_write_odd = write_to_dmem && addr_dmem_host[0];
    wire host_we = host_write_odd;

    // Arbitration: host vs pipeline (same as memory.v)
    wire host_active = write_to_dmem || read_req_dmem;
    wire [7:0] bram_addr = host_active
        ? host_phys_addr
        : (pipeline_mem_read || pipeline_we ? pipeline_addr : 8'h0);

    wire [63:0] data_in_64 = host_active ? host_data_64 : pipeline_data;

    wire fifo_head = (addr_dmem_host == 8'hFE);
    wire fifo_tail = (addr_dmem_host == 8'hFF);
    wire fifo_data = (addr_dmem_host < 8'hFE);

    convertible_fifo fifo_inst (
        .clk                (clk),
        .rst                (rst),
        .cpu_thread         (2'b00),
        .net_rx_data        (72'h0),
        .net_rx_valid       (1'b0),
        .net_rx_sop         (1'b0),
        .net_rx_eop         (1'b0),
        .fifo_full          (),
        .cpu_addr           (addr_dmem_host),
        .bram_addr          (bram_addr),
        .cpu_data_in        (data_dmem_host),
        .data_in_64         (data_in_64),
        .cpu_we             (host_we),
        .fifo_head          (fifo_head),
        .fifo_tail          (fifo_tail),
        .fifo_data          (fifo_data),
        .fifo_ctrl          (1'b0),
        .gpu_mode           (gpu_mode),
        .pipeline_data      (pipeline_data),
        .pipeline_we        (pipeline_we),
        .cpu_data_out       (cpu_data_out),
        .raw_data_out       (raw_data_out),
        .head_reg           (),
        .tail_reg           ()
    );

    assign dmem_out = raw_data_out[63:0];

endmodule
