`timescale 1ns/1ps

module ids
  #(
    parameter DATA_WIDTH        = 64,
    parameter CTRL_WIDTH        = DATA_WIDTH/8,
    parameter UDP_REG_SRC_WIDTH = 2
  )
  (
    // Packet data path interface (pass-through for now)
    input  [DATA_WIDTH-1:0]             in_data,
    input  [CTRL_WIDTH-1:0]             in_ctrl,
    input                               in_wr,
    output                              in_rdy,

    output [DATA_WIDTH-1:0]             out_data,
    output [CTRL_WIDTH-1:0]             out_ctrl,
    output                              out_wr,
    input                               out_rdy,

    // Register ring interface
    input                               reg_req_in,
    input                               reg_ack_in,
    input                               reg_rd_wr_L_in,
    input  [`UDP_REG_ADDR_WIDTH-1:0]    reg_addr_in,
    input  [`CPCI_NF2_DATA_WIDTH-1:0]   reg_data_in,
    input  [UDP_REG_SRC_WIDTH-1:0]      reg_src_in,

    output                              reg_req_out,
    output                              reg_ack_out,
    output                              reg_rd_wr_L_out,
    output [`UDP_REG_ADDR_WIDTH-1:0]    reg_addr_out,
    output [`CPCI_NF2_DATA_WIDTH-1:0]   reg_data_out,
    output [UDP_REG_SRC_WIDTH-1:0]      reg_src_out,

    // misc
    input                               reset,
    input                               clk
  );

  // =========================================================================
  // Packet Pass-Through
  // =========================================================================
  assign in_rdy   = out_rdy;
  assign out_wr   = in_wr;
  assign out_ctrl = in_ctrl;
  assign out_data = in_data;

  // =========================================================================
  // IDS Register Block (names match ids.xml)
  // =========================================================================
  wire [31:0] input_type;
  wire [31:0] address;
  wire [31:0] imem;
  wire [31:0] dmem;
  wire [31:0] gpu_mode;

  reg [31:0] dmem_out;
  reg [31:0] imem_out;
  reg [31:0] tensor_out;

  generic_regs #(
    .UDP_REG_SRC_WIDTH  (UDP_REG_SRC_WIDTH),
    .TAG                (`IDS_BLOCK_ADDR),
    .REG_ADDR_WIDTH     (`IDS_REG_ADDR_WIDTH),
    .NUM_COUNTERS       (0),
    .NUM_SOFTWARE_REGS  (5),
    .NUM_HARDWARE_REGS  (3)
  ) ids_regs (
    .reg_req_in       (reg_req_in),
    .reg_ack_in       (reg_ack_in),
    .reg_rd_wr_L_in   (reg_rd_wr_L_in),
    .reg_addr_in      (reg_addr_in),
    .reg_data_in      (reg_data_in),
    .reg_src_in       (reg_src_in),

    .reg_req_out      (reg_req_out),
    .reg_ack_out      (reg_ack_out),
    .reg_rd_wr_L_out  (reg_rd_wr_L_out),
    .reg_addr_out     (reg_addr_out),
    .reg_data_out     (reg_data_out),
    .reg_src_out      (reg_src_out),

    .counter_updates  (),
    .counter_decrement(),

    .software_regs    ({gpu_mode, dmem, imem, address, input_type}),
    .hardware_regs    ({tensor_out, imem_out, dmem_out}),

    .clk              (clk),
    .reset            (reset)
  );

  // =========================================================================
  // Control Signal Decoding
  // =========================================================================
  wire write_to_imem = input_type[0];
  wire write_to_dmem = input_type[1];
  wire read_req_dmem = input_type[2];
  wire gpu_start     = input_type[3];
  wire read_req_imem = input_type[4];

  wire [8:0]  addr_imem_host = address[8:0];
  wire [7:0]  addr_dmem_host = address[7:0];
  wire [31:0] data_imem_host = imem;
  wire [31:0] data_dmem_host = dmem;

  // =========================================================================
  // GPU Pipeline (FIFO inside pipeline, like memory inside pipeline_pseudoARM)
  // =========================================================================
  wire [63:0] gpu_tensor_out;
  wire [63:0] data_out_dmem;
  wire [31:0] data_out_imem;

  // GPU reset: hold until IMEM loaded AND GPU_START pulsed
  reg imem_loaded;
  reg gpu_ready;
  always @(posedge clk) begin
    if (reset) begin
      imem_loaded <= 1'b0;
      gpu_ready   <= 1'b0;
    end else begin
      if (write_to_imem) imem_loaded <= 1'b1;
      if (gpu_start && imem_loaded) gpu_ready <= 1'b1;
    end
  end

  wire gpu_reset = reset | ~gpu_ready;

  pipeline_backup gpu_pipeline (
    .clk                (clk),
    .rst                (gpu_reset),

    // IMEM interface
    .write_to_imem      (write_to_imem),
    .read_req_imem      (read_req_imem),
    .addr_imem_host     (addr_imem_host),
    .data_imem_host     (data_imem_host),
    .data_out_imem      (data_out_imem),

    // DMEM: host signals passed through (FIFO inside pipeline)
    .write_to_dmem      (write_to_dmem),
    .read_req_dmem      (read_req_dmem),
    .addr_dmem_host     (addr_dmem_host),
    .data_dmem_host     (data_dmem_host),
    .gpu_mode           (imem_loaded || (|gpu_mode)),
    .data_out_dmem      (data_out_dmem),

    // Tensor output
    .tensor_out_intercept (gpu_tensor_out)
  );

  // =========================================================================
  // Hardware Register Updates (same pattern as partner)
  // =========================================================================
  wire [31:0] dmem_read_32 = addr_dmem_host[0] ? data_out_dmem[63:32] : data_out_dmem[31:0];

  // IMEM read: mem32bit512 has 1-cycle latency; capture 1 cycle after read_req_imem
  // DMEM read: same-cycle capture (match CPU ids) when read_req_dmem is high
  reg read_req_imem_d1;

  always @(posedge clk) begin
      read_req_imem_d1 <= read_req_imem;
  end

  always @(posedge clk) begin
      if (reset) begin
          dmem_out   <= 32'h0;
          imem_out   <= 32'h0;
          tensor_out <= 32'h0;
      end else begin
          if (read_req_dmem)
              dmem_out <= dmem_read_32;

          if (read_req_imem_d1)
              imem_out <= data_out_imem;

          tensor_out <= gpu_tensor_out[31:0];
      end
  end

endmodule
