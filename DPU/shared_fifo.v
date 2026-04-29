`timescale 1ns/1ps
//
// Single DMEM: convertible_fifo (FIFO_72W256D). Host SW, GPU MEM, and ARM MEM all use
// this block - there is no separate plain SRAM elsewhere.
//
module gpu_fifo_mem (
    input         clk,
    input         rst,

    input         write_to_dmem,
    input         read_req_dmem,
    // ids: delayed read strobe - keep host mux/gpu_mode aligned when HW regs sample BRAM dout
    input         read_req_dmem_d1,
    input  [7:0]  addr_dmem_host,
    input  [31:0] data_dmem_host_lo,
    input  [31:0] data_dmem_host_hi,

    // GPU pipeline (pipeline_backup MEM)
    input  [7:0]  pipeline_addr,
    input  [63:0] pipeline_data,
    input         pipeline_we,
    input         pipeline_mem_read,

    // CPU pipeline FIFO region (from pipeline_pseudoARM when mapped)
    input         cpu_fifo_req,
    input  [7:0]  cpu_fifo_addr,
    input  [31:0] cpu_fifo_wdata,
    input         cpu_fifo_we,
    input         cpu_fifo_head,
    input         cpu_fifo_tail,
    input         cpu_fifo_data,
    input         cpu_fifo_ctrl,

    // Network RX stream into convertible_fifo
    input  [71:0] net_rx_data,
    input         net_rx_valid,
    input         net_rx_sop,
    input         net_rx_eop,

    input         gpu_mode,
    input         net_tx_ready,

    output [63:0] dmem_out,
    output [31:0] cpu_fifo_rdata,
    output [71:0] net_tx_data,
    output        net_tx_valid
);

    wire [71:0] raw_data_out;
    wire [31:0] cpu_data_out;

    reg  write_to_dmem_d1 = 1'b0;
    wire host_we_edge = write_to_dmem && !write_to_dmem_d1;
    always @(posedge clk) begin
        if (rst)
            write_to_dmem_d1 <= 1'b0;
        else
            write_to_dmem_d1 <= write_to_dmem;
    end

    // Use full host address for 64b DMEM words so GPU host preload at 0..N
    // matches GPU LW/ST addresses exactly (melvin flow compatibility).
    wire [7:0] host_phys_addr = addr_dmem_host;
    wire [63:0] host_data_64  = {data_dmem_host_hi, data_dmem_host_lo};
    wire host_we = host_we_edge;

    wire host_active = write_to_dmem || read_req_dmem || read_req_dmem_d1;

    wire gpu_pl = pipeline_mem_read || pipeline_we;
    wire cpu_pl = cpu_fifo_req &&
        (cpu_fifo_we || cpu_fifo_data || cpu_fifo_head || cpu_fifo_tail);

    // When GPU pipeline and CPU FIFO both need the SRAM, match bram_addr priority (GPU wins).
    wire cpu_fifo_decode = cpu_fifo_req && !gpu_pl;

    wire [7:0] bram_addr = host_active ? host_phys_addr
        : (gpu_pl ? pipeline_addr : (cpu_pl ? cpu_fifo_addr : 8'h0));

    wire [63:0] data_in_64 = host_active ? host_data_64
        : (gpu_pl ? pipeline_data : {32'b0, cpu_fifo_wdata});

    // Host decode (SW)
    wire h_fifo_head = (addr_dmem_host == 8'hFE);
    wire h_fifo_tail = (addr_dmem_host == 8'hFF);
    wire h_fifo_data = (addr_dmem_host < 8'hFE);

    // convertible_fifo sideband: same priority as bram_addr - host > GPU pipeline > CPU FIFO
    wire [7:0] cf_cpu_addr = host_active ? addr_dmem_host
        : (gpu_pl ? pipeline_addr : (cpu_pl ? cpu_fifo_addr : pipeline_addr));

    wire cf_fifo_head  = host_active ? h_fifo_head  : (cpu_fifo_decode ? cpu_fifo_head  : 1'b0);
    wire cf_fifo_tail  = host_active ? h_fifo_tail  : (cpu_fifo_decode ? cpu_fifo_tail  : 1'b0);
    wire cf_fifo_data  = host_active ? h_fifo_data  : (cpu_fifo_decode ? cpu_fifo_data  : 1'b0);
    wire cf_fifo_ctrl  = host_active ? 1'b0         : (cpu_fifo_decode ? cpu_fifo_ctrl  : 1'b0);

    wire cf_cpu_we = host_active ? host_we : (cpu_fifo_decode ? cpu_fifo_we : 1'b0);

    convertible_fifo fifo_inst (
        .clk                (clk),
        .rst                (rst),
        .cpu_thread         (2'b00),
        .net_rx_data        (net_rx_data),
        .net_rx_valid       (net_rx_valid),
        .net_rx_sop         (net_rx_sop),
        .net_rx_eop         (net_rx_eop),
        .net_tx_data        (net_tx_data),
        .net_tx_valid       (net_tx_valid),
        .net_tx_ready       (net_tx_ready),
        .fifo_full          (),
        .cpu_addr           (cf_cpu_addr),
        .bram_addr          (bram_addr),
        .cpu_data_in        (host_active ? data_dmem_host_lo : cpu_fifo_wdata),
        .data_in_64         (data_in_64),
        .cpu_we             (cf_cpu_we),
        .fifo_head          (cf_fifo_head),
        .fifo_tail          (cf_fifo_tail),
        .fifo_data          (cf_fifo_data),
        .fifo_ctrl          (cf_fifo_ctrl),
        .gpu_mode           (gpu_mode),
        .pipeline_data      (pipeline_data),
        // GPU MEM wins over CPU FIFO decode; host already masked above
        .pipeline_we      (pipeline_we && !host_active && (gpu_pl || !cpu_fifo_req)),
        .cpu_data_out       (cpu_data_out),
        .raw_data_out       (raw_data_out),
        .head_reg           (),
        .tail_reg           ()
    );

    assign dmem_out       = raw_data_out[63:0];
    assign cpu_fifo_rdata = cpu_data_out;

endmodule
