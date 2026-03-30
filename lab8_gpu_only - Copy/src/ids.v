///////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

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
   );

   //------------------------- Signals -------------------------------

   wire [31:0]  input_type;
   wire [31:0]  address;
   wire [31:0]  imem;
   wire [31:0]  dmem;

   reg  [31:0]  dmem_out;
   reg  [63:0]  tensor_out;

   wire         write_to_dmem;
   wire [8:0]   addr_imem_host;
   wire [31:0]  data_imem_host;
   wire [7:0]   addr_dmem_host;
   wire [63:0]  data_dmem_host;
   wire [63:0]  data_out_dmem;
   wire         read_req_dmem;

   wire [63:0]  tensor_out_intercept;

   // SW register 4: gpu_ctrl
   //   [0] gpu_start  - one-cycle strobe
   wire [31:0]  gpu_ctrl;

   // pipeline_gpu control
   wire         gpu_start;
   wire [7:0]   bram_inst_addr;
   wire [7:0]   bram_length;

   // pipeline_done
   wire         pipeline_done;

  
   //------------------------- Logic ---------------------------------

   // input_type bit assignments:
   //   [0] cpu_imem_we   - unused (CPU removed)
   //   [1] dmem_we       - GPU DMEM write from host
   //   [2] dmem_read_req - GPU DMEM read request
   //   [3] gpu_imem_we   - GPU IMEM write enable
   wire dmem_we       = input_type[1];
   wire dmem_read_req = input_type[2];
   wire gpu_imem_we   = input_type[3];

   // gpu_ctrl SW reg (reg 4):
   //   [0] gpu_start - write 1 to begin execution
   // gpu_ctrl[0]    = gpu_start strobe
   // address[7:0]   = bram_inst_addr (base PC for GPU program)
   // address[15:8]  = bram_length    (number of instructions to execute)
   assign gpu_start      = gpu_ctrl[0];
   assign bram_inst_addr = address[7:0];
   assign bram_length    = address[15:8];

   assign write_to_dmem  = dmem_we;
   assign addr_imem_host = address[8:0];
   assign data_imem_host = imem;
   assign addr_dmem_host = address[7:0];
   assign data_dmem_host = dmem;
   assign read_req_dmem  = dmem_read_req;

 //------------------------- Modules -------------------------------

   generic_regs
   #( 
      .UDP_REG_SRC_WIDTH (UDP_REG_SRC_WIDTH),
      .TAG               (`IDS_BLOCK_ADDR),
      .REG_ADDR_WIDTH    (`IDS_REG_ADDR_WIDTH),
      .NUM_COUNTERS      (0),
      .NUM_SOFTWARE_REGS (5),
      .NUM_HARDWARE_REGS (2)
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
      .software_regs    ({gpu_ctrl, dmem, imem, address, input_type}),
      .hardware_regs    ({tensor_out[31:0], dmem_out}),
      .clk              (clk),
      .reset            (reset)
   );

   // gpuCTRL removed: gpu_start wired directly from SW reg 4
   // bram_inst_addr hardcoded to 0x00
   // bram_length hardcoded to 32

   pipeline_gpu gpu_Unit (
      .clk              (clk),
      .rst              (reset),
      .write_to_imem    (gpu_imem_we),
      .write_to_dmem    (write_to_dmem),
      .addr_imem_host   (addr_imem_host),
      .data_imem_host   (data_imem_host),
      .addr_dmem_host   (addr_dmem_host),
      .data_dmem_host   (data_dmem_host),
      .read_req_dmem    (read_req_dmem),
      .gpu_start        (gpu_start),
      .bram_inst_addr   (bram_inst_addr),
      .bram_length      (bram_length),
      .data_out_dmem    (data_out_dmem),
      .tensor_out_intercept(tensor_out_intercept),
      .pipeline_done    (pipeline_done)
   );

   //------------------------- Datapath tie-offs ---------------------
   assign in_rdy   = 1'b1;
   assign out_data = {DATA_WIDTH{1'b0}};
   assign out_ctrl = {CTRL_WIDTH{1'b0}};
   assign out_wr   = 1'b0;


   always @(posedge clk) begin
      if (reset) begin
         dmem_out   <= 32'b0;
         tensor_out <= 64'b0;
      end else begin
         if (dmem_read_req)
            dmem_out <= data_out_dmem[31:0];
         tensor_out <= tensor_out_intercept;
      end
   end

endmodule
