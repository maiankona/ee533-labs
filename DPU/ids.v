///////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
// NF2 register block (same numeric map as NetFPGA projects; no registers.v include)
`define UDP_REG_ADDR_WIDTH 23
`define CPCI_NF2_DATA_WIDTH 32
`define IDS_BLOCK_ADDR      19'h00008
`define IDS_REG_ADDR_WIDTH  4

module ids
   #(
      parameter DATA_WIDTH = 64,
      parameter CTRL_WIDTH = DATA_WIDTH/8,
      parameter UDP_REG_SRC_WIDTH = 2
   )
   (
      input  [DATA_WIDTH-1:0]             in_data,
      input  [CTRL_WIDTH-1:0]             in_ctrl,
      input                               in_wr,
      output                              in_rdy,

      output [DATA_WIDTH-1:0]             out_data,
      output [CTRL_WIDTH-1:0]             out_ctrl,
      output                              out_wr,
      input                               out_rdy,
      
      input                               reg_req_in,
      input                               reg_ack_in,
      input                               reg_rd_wr_L_in,
      input  [`UDP_REG_ADDR_WIDTH-1:0]    reg_addr_in,
      input  [`CPCI_NF2_DATA_WIDTH-1:0]   reg_data_in,
      input  [UDP_REG_SRC_WIDTH-1:0]      reg_src_in,

      output                              reg_req_out,
      output                              reg_ack_out,
      output                              reg_rd_wr_L_out,
      output  [`UDP_REG_ADDR_WIDTH-1:0]   reg_addr_out,
      output  [`CPCI_NF2_DATA_WIDTH-1:0]  reg_data_out,
      output  [UDP_REG_SRC_WIDTH-1:0]     reg_src_out,

      input                               clk,
      input                               reset
      // cpu_start and arm_write_to_imem moved to SW regs (no longer top-level ports)
   );

   //------------------------- Signals -------------------------------

   wire [31:0]  input_type;
   wire [31:0]  address;
   wire [31:0]  imem;
   wire [31:0]  dmem_in_lo;
   wire [31:0]  dmem_in_hi;

   reg  [31:0]  dmem_out_lo;
   reg  [31:0]  dmem_out_hi;
   reg  [31:0]  imem_out;
   reg  [31:0]  tensor_out;

   wire         write_to_imem;
   wire         write_to_dmem;
   wire         read_req_dmem;
   wire         read_req_imem;

   wire [8:0]   addr_imem_host;
   wire [7:0]   addr_dmem_host;

   wire [63:0]  data_out_dmem;

   wire [63:0]  tensor_out_intercept;

   wire         gpu_start;
   wire [7:0]   bram_inst_addr;
   wire [7:0]   bram_length;
   wire         gpu_irq;
   wire         gpu_imem_we;

   wire         pipeline_done;

   wire [7:0]   cpu_mem_addr;
   wire [63:0]  cpu_mem_data;
   wire         cpu_mem_we;

   wire [31:0]  data_out_imem;

   wire        cpu_fifo_req;
   wire [7:0]  cpu_fifo_addr;
   wire [31:0] cpu_fifo_wdata;
   wire        cpu_fifo_we;
   wire        cpu_fifo_head;
   wire        cpu_fifo_tail;
   wire        cpu_fifo_data;
   wire        cpu_fifo_ctrl;
   wire        cpu_pipe_we;
   wire        cpu_pipe_mem_read;
   wire [7:0]  cpu_pipe_addr;
   wire [63:0] cpu_pipe_wdata;
   wire [31:0] cpu_fifo_rdata;

   // ----------------------------------------------------------------
   wire [31:0] cpu_ctrl;    // SW reg 5: [0]=cpu_start rising-edge detect

   reg  sw_cpu_prev;
   reg  cpu_ctrl_r;
   wire cpu_start_b;        // from cpu_ctrl[0]
   wire cpu_start;

   always @(posedge clk) begin
      if (reset) sw_cpu_prev <= 1'b0;
      else       sw_cpu_prev <= input_type[5];
   end

   always @(posedge clk) begin
      if (reset) cpu_ctrl_r <= 1'b0;
      else       cpu_ctrl_r <= cpu_ctrl[0];
   end
   assign cpu_start_b = cpu_ctrl[0] && !cpu_ctrl_r;
   assign cpu_start = cpu_start_b;

   // cpu_running: gates cpu_mem_we to ctrl unit until cpu_start fires
   reg cpu_running;
   always @(posedge clk) begin
      if (reset)          cpu_running <= 1'b0;
      else if (cpu_start) cpu_running <= 1'b1;
   end
   wire cpu_mem_we_gated = cpu_mem_we && cpu_running;

   // ----------------------------------------------------------------
   // ARM IMEM: input_type[6] = arm_imem_we, reuses address + imem SW regs
   // ----------------------------------------------------------------
   wire arm_write_to_imem  = input_type[6];
   wire [8:0]  arm_addr_imem_host = address[8:0];
   wire [31:0] arm_data_imem_host = imem;

   // SW GPU start edge
   reg          sw_gpu_prev;
   wire         gpu_start_sw_pulse;

   always @(posedge clk) begin
      if (reset)
         sw_gpu_prev <= 1'b0;
      else
         sw_gpu_prev <= input_type[3];
   end
   assign gpu_start_sw_pulse = input_type[3] && !sw_gpu_prev;

   //------------------------- Decodes (lab8 map) --------------------

   assign write_to_imem   = input_type[0];
   assign write_to_dmem   = input_type[1];
   assign read_req_dmem   = input_type[2];
   assign read_req_imem   = input_type[4];

   assign addr_imem_host  = address[8:0];
   assign addr_dmem_host  = address[7:0];

   reg read_req_dmem_d1;
   reg read_req_imem_d1;

   always @(posedge clk) begin
      if (reset) begin
         read_req_dmem_d1 <= 1'b0;
         read_req_imem_d1 <= 1'b0;
      end else begin
         read_req_dmem_d1 <= read_req_dmem;
         read_req_imem_d1 <= read_req_imem;
      end
   end

   wire [63:0] data_dmem_host = {dmem_in_hi, dmem_in_lo};
   wire [63:0] dmem_out       = {dmem_out_hi, dmem_out_lo};

   //------------------------- Register block ------------------------
   generic_regs #(
      .UDP_REG_SRC_WIDTH  (UDP_REG_SRC_WIDTH),
      .TAG                (`IDS_BLOCK_ADDR),
      .REG_ADDR_WIDTH     (`IDS_REG_ADDR_WIDTH),
      .NUM_COUNTERS       (0),
      .NUM_SOFTWARE_REGS  (6),
      .NUM_HARDWARE_REGS  (4)
   ) module_regs (
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
      .software_regs    ({cpu_ctrl, dmem_in_hi, dmem_in_lo, imem, address, input_type}),
      .hardware_regs    ({tensor_out, imem_out, dmem_out_hi, dmem_out_lo}),
      .clk              (clk),
      .reset            (reset)
   );

   //------------------------- Network / packet framing ---------------

   /* --------- Deprecated. Now handled in RX_FSM ---------------------
   reg in_packet;
   always @(posedge clk) begin
      if (reset) begin
         in_packet <= 1'b0;
      end else if (in_wr) begin
         if ((in_ctrl != 8'h00) && (in_ctrl != 8'hFF))
            in_packet <= 1'b0;
         else if (in_ctrl == 8'hFF)
            in_packet <= 1'b1;
      end
   end

   wire is_sop = in_wr && (in_ctrl == 8'hFF) && !in_packet;
   wire is_eop = in_wr && (in_ctrl != 8'h00) && (in_ctrl != 8'hFF) && in_packet;
   */

   wire [7:0]  rx_pl_addr;
   wire [63:0] rx_pl_wdata;
   wire        rx_pl_we;
   wire        rx_fsm_busy;
   wire        rx_in_rdy;

// ------------------------- NETWORK INPUT STREAM HANDLER ------------------------

RX_FSM RX_FSM (
   .clk(clk),
   .reset(reset),
   .in_data(in_data),
   .in_ctrl(in_ctrl),
   .in_wr(in_wr),
   .pipeline_done(pipeline_done),
   .rx_pl_addr(rx_pl_addr),
   .rx_pl_wdata(rx_pl_wdata),
   .rx_pl_we(rx_pl_we),
   .rx_fsm_busy(rx_fsm_busy),
   .in_rdy(rx_in_rdy)
);

// --------------------------- END NETWORK -----------------------------

   //------------------------- ARM + GPU control ---------------------

   gpu_control_interface_2 gpu_ctrl (
      .clk            (clk),
      .rst            (reset),
      .host_addr      (cpu_mem_addr),
      .host_data      (cpu_mem_data),
      .host_we        (cpu_mem_we_gated),
      .gpu_irq        (gpu_irq),
      .gpu_start      (gpu_start),
      .bram_inst_addr (bram_inst_addr),
      .bram_length    (bram_length),
      .pipeline_done  (pipeline_done),
      .imem_we_en     (gpu_imem_we)
   );

   wire gpu_start_merged = gpu_start | gpu_start_sw_pulse;

   wire [7:0] bram_inst_addr_in = gpu_start_merged
                                  ? (gpu_start ? bram_inst_addr : address[7:0])
                                  : address[7:0];
   wire [7:0] bram_length_in    = gpu_start_merged
                                  ? (gpu_start ? bram_length    : address[15:8])
                                  : address[15:8];

   wire write_to_imem_gpu = write_to_imem | gpu_imem_we;

   //------------------------- Shared FIFO / DMEM --------------------

   wire [7:0]  gpu_dmem_pipe_addr;
   wire [63:0] gpu_dmem_pipe_wdata;
   wire        gpu_dmem_pipe_we;
   wire        gpu_dmem_pipe_mem_read;
   wire        fifo_gpu_mode_gpu;
   wire [63:0] shared_dmem_rdata;
   wire [71:0] net_tx_data;
   wire        net_tx_valid;
   wire        net_tx_ready;
   wire        arm_mem_stall;
   wire        gpu_mem_busy;
   wire [7:0]  mux_pl_addr;
   wire [63:0] mux_pl_wdata;
   wire        mux_pl_we;
   wire        mux_pl_mr;

   pipeline_backup gpu_Unit (
      .clk                 (clk),
      .rst                 (reset),
      .write_to_imem       (write_to_imem_gpu),
      .read_req_imem       (read_req_imem),
      .addr_imem_host      (addr_imem_host),
      .data_imem_host      (imem),
      .data_out_imem       (data_out_imem),
      .write_to_dmem       (write_to_dmem),
      .read_req_dmem       (read_req_dmem),
      .gpu_start           (gpu_start_merged),
      .bram_inst_addr      (bram_inst_addr_in),
      .bram_length         (bram_length_in),
      .dmem_rdata_in       (shared_dmem_rdata),
      .dmem_pipe_addr      (gpu_dmem_pipe_addr),
      .dmem_pipe_wdata     (gpu_dmem_pipe_wdata),
      .dmem_pipe_we        (gpu_dmem_pipe_we),
      .dmem_pipe_mem_read  (gpu_dmem_pipe_mem_read),
      .fifo_gpu_mode       (fifo_gpu_mode_gpu),
      .pipeline_done       (pipeline_done),
      .tensor_out_intercept(tensor_out_intercept)
   );

   pipeline_pseudoARM arm_cpu (
      .clk                 (clk),
      .rst                 (reset),
      .cpu_start           (cpu_start),
      .mem_stall           (arm_mem_stall),
      .write_to_imem       (arm_write_to_imem),
      .write_to_dmem       (write_to_dmem),
      .addr_imem_host      (arm_addr_imem_host),
      .data_imem_host      (arm_data_imem_host),
      .addr_dmem_host      (addr_dmem_host),
      .data_dmem_host      (dmem_in_lo),
      .read_req_dmem       (read_req_dmem),
      .alu_result_detected (),
      .data_out_dmem       (),
      .alu_out_intercept   (),
      .cpu_mem_addr        (cpu_mem_addr),
      .cpu_mem_data        (cpu_mem_data),
      .cpu_mem_we          (cpu_mem_we),
      .ext_fifo_rdata      (cpu_fifo_rdata),
      .shared_dmem_rdata   (shared_dmem_rdata),
      .cpu_fifo_req        (cpu_fifo_req),
      .cpu_fifo_addr       (cpu_fifo_addr),
      .cpu_fifo_wdata      (cpu_fifo_wdata),
      .cpu_fifo_we         (cpu_fifo_we),
      .cpu_fifo_head       (cpu_fifo_head),
      .cpu_fifo_tail       (cpu_fifo_tail),
      .cpu_fifo_data       (cpu_fifo_data),
      .cpu_fifo_ctrl       (cpu_fifo_ctrl),
      .cpu_pipe_we         (cpu_pipe_we),
      .cpu_pipe_mem_read   (cpu_pipe_mem_read),
      .cpu_pipe_addr       (cpu_pipe_addr),
      .cpu_pipe_wdata      (cpu_pipe_wdata)
   );

   assign gpu_mem_busy = gpu_dmem_pipe_we | gpu_dmem_pipe_mem_read;

   wire        host_dmem_occupies  = write_to_dmem | read_req_dmem | read_req_dmem_d1;
   wire        cpu_needs_shared_mem = cpu_fifo_req | cpu_pipe_we | cpu_pipe_mem_read;
   wire        shared_port_busy     = gpu_mem_busy | host_dmem_occupies;
   assign      arm_mem_stall = cpu_needs_shared_mem & shared_port_busy;

wire rx_active = rx_pl_we;

assign mux_pl_addr  = gpu_mem_busy ? gpu_dmem_pipe_addr     :
                      rx_active    ? rx_pl_addr              : cpu_pipe_addr;

assign mux_pl_wdata = gpu_mem_busy ? gpu_dmem_pipe_wdata    :
                      rx_active    ? rx_pl_wdata             : cpu_pipe_wdata;

assign mux_pl_we    = gpu_mem_busy ? gpu_dmem_pipe_we       :
                      rx_active    ? rx_pl_we                : cpu_pipe_we;

assign mux_pl_mr    = gpu_mem_busy ? gpu_dmem_pipe_mem_read :
                      rx_active    ? 1'b0                    : cpu_pipe_mem_read;

wire fifo_gpu_combined = fifo_gpu_mode_gpu | write_to_dmem | read_req_dmem
                        | read_req_dmem_d1
                        | cpu_fifo_req | cpu_pipe_we | cpu_pipe_mem_read 
                        | gpu_mem_busy | rx_pl_we;

   gpu_fifo_mem shared_fifo (
      .clk                (clk),
      .rst                (reset),
      .write_to_dmem      (write_to_dmem),
      .read_req_dmem      (read_req_dmem),
      .read_req_dmem_d1   (read_req_dmem_d1),
      .addr_dmem_host     (addr_dmem_host),
      .data_dmem_host_lo  (dmem_in_lo),
      .data_dmem_host_hi  (dmem_in_hi),
      .pipeline_addr      (mux_pl_addr),
      .pipeline_data      (mux_pl_wdata),
      .pipeline_we        (mux_pl_we),
      .pipeline_mem_read  (mux_pl_mr),
      .cpu_fifo_req       (cpu_fifo_req),
      .cpu_fifo_addr      (cpu_fifo_addr),
      .cpu_fifo_wdata     (cpu_fifo_wdata),
      .cpu_fifo_we        (cpu_fifo_we),
      .cpu_fifo_head      (cpu_fifo_head),
      .cpu_fifo_tail      (cpu_fifo_tail),
      .cpu_fifo_data      (cpu_fifo_data),
      .cpu_fifo_ctrl      (cpu_fifo_ctrl),
      .net_rx_data        (72'b0),
      .net_rx_valid       (1'b0),
      .net_rx_sop         (1'b0),
      .net_rx_eop         (1'b0),
      .gpu_mode           (fifo_gpu_combined),
      .net_tx_ready       (net_tx_ready),
      .dmem_out           (shared_dmem_rdata),
      .cpu_fifo_rdata     (cpu_fifo_rdata),
      .net_tx_data        (net_tx_data),
      .net_tx_valid       (net_tx_valid)
   );

   assign data_out_dmem = shared_dmem_rdata;

   //------------------------- HW register capture -------------------
   // +++ ILA ADDITION BELOW — only change from original ids.v +++
   //
   // ILA FIFO: 72-bit packet capture buffer
   // Captures {in_ctrl[7:0], in_data[63:0]} on every in_wr cycle.
   // This lets you see the ctrl byte for every word (SOP/payload/EOP).
   //
   // Read interface — pulse input_type[4] to pop one word:
   //   DMEM_OUT_LO  = in_data[31:0]
   //   DMEM_OUT_HI  = in_data[63:32]
   //   IMEM_OUT     = {24'b0, in_ctrl[7:0]}   ctrl byte
   //   TENSOR_OUT   = {21'b0, full, empty, depth[8:0]}
   //
   // NOTE: input_type[4] was previously read_req_imem.
   // The ILA read and IMEM read now share this bit.
   // Do not use both simultaneously.
   // -----------------------------------------------------------------

   wire [71:0] ila_data_out_72;
   wire [8:0]  ila_depth;
   wire        ila_empty, ila_full;
   wire        ila_ren = input_type[4];   // pop one word from ILA FIFO
   wire        ila_wen = in_wr;           // capture every incoming word

   ila #(
      .DATA_WIDTH (72),
      .ADDR_WIDTH (8)
   ) packet_capture (
      .clk      (clk),
      .reset    (reset),
      .data_in  ({in_ctrl, in_data}),     // 72-bit: ctrl[71:64] data[63:0]
      .wen      (ila_wen),
      .ren      (ila_ren),
      .data_out (ila_data_out_72),
      .depth    (ila_depth),
      .empty    (ila_empty),
      .full     (ila_full)
   );

   wire [63:0] ila_captured_data = ila_data_out_72[63:0];
   wire [7:0]  ila_captured_ctrl = ila_data_out_72[71:64];

   always @(posedge clk) begin
      if (reset) begin
         dmem_out_lo <= 32'h0;
         dmem_out_hi <= 32'h0;
         imem_out    <= 32'h0;
         tensor_out  <= 32'h0;
      end else begin
         if (read_req_dmem_d1) begin
            dmem_out_lo <= data_out_dmem[31:0];
            dmem_out_hi <= data_out_dmem[63:32];
         end
         if (ila_ren) begin
            dmem_out_lo <= ila_captured_data[31:0];
            dmem_out_hi <= ila_captured_data[63:32];
            imem_out    <= {24'b0, ila_captured_ctrl};
         end
         if (read_req_imem_d1)
            imem_out <= data_out_imem;
         tensor_out <= {21'b0, ila_full, ila_empty, ila_depth};
      end
   end

   // +++ END ILA ADDITION +++

   //------------------------- Datapath ------------------------------
   assign net_tx_ready = out_rdy;
   assign out_data = net_tx_valid ? net_tx_data[63:0]  : in_data;
   assign out_ctrl = net_tx_valid ? net_tx_data[71:64] : in_ctrl;
   assign out_wr   = net_tx_valid ? 1'b1               : in_wr;
   assign in_rdy = out_rdy && rx_in_rdy && !gpu_mem_busy;

endmodule
