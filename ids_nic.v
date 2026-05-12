///////////////////////////////////////////////////////////////////////////////
// vim:set shiftwidth=3 softtabstop=3 expandtab:
// $Id: module_template 2008-03-13 gac1 $
//
// Module: ids.v
// Project: NF2.1
// Description: Defines a simple ids module for the user data path.  The
// modules reads a 64-bit register that contains a pattern to match and
// counts how many packets match.  The register contents are 7 bytes of
// pattern and one byte of mask.  The mask bits are set to one for each
// byte of the pattern that should be included in the mask -- zero bits
// mean "don't care".
//
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
      
      // --- Register interface
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

      // misc
      input                                reset,
      input                                clk
   );

   // Define the log2 function
   // `LOG2_FUNC

   //------------------------- Signals-------------------------------
   //NO FIFO FOR THIS IMPLEMENTATION
   //wire [DATA_WIDTH-1:0]         in_fifo_data;
   //wire [CTRL_WIDTH-1:0]         in_fifo_ctrl;

   //wire                          in_fifo_nearly_full;
   //wire                          in_fifo_empty;

   //reg                           in_fifo_rd_en;
   //reg                           out_wr_int;

   // software registers 
   wire [31:0]                     input_type;
   wire [31:0]                     address;
   wire [31:0]                     imem;
   wire [31:0]                     dmem;

   wire [31:0] fifo_addr;
   
   //NOT USED
   //wire [31:0]                   pattern_high;
   //wire [31:0]                   pattern_low;
   //wire [31:0]                   ids_cmd;
   // hardware registers
   reg [31:0]                      dmem_out;
   reg [31:0]                      alu_out_check;
   reg [31:0]                      cpu_extract_check;
   
   //FIFO ILA
   reg [31:0]                      packet_check_low, packet_out_low;
   reg [31:0]                      packet_check_mid, packet_out_mid;
   reg [31:0]                      packet_check_high, packet_out_high;

   reg [31:0] gpu_lower, gpu_upper, result_check_lower, result_check_upper, cpu_store, cpu_pc_thread0, cpu_request, alu_zero;
   
   wire                            write_to_imem;
   wire                            write_to_dmem;
   wire [8:0]                      addr_imem_host;
   wire [31:0]                     data_imem_host;
   wire [7:0]                      addr_dmem_host;
   wire [31:0]                     data_dmem_host; //this stays truncated so that we don't have to worry about reading a bunch of 0's

	wire                            read_req_dmem;

   wire                            alu_result_detected;
   wire [31:0]                     data_out_dmem;
   wire [31:0]                     alu_out_intercept;

   //THE NETWORK INPUTS (INTENDED PASSTHROUGH FOR NOW)
   wire [71:0]                     net_rx_data;
   wire                            net_rx_valid;
   wire                            net_rx_sop;
   wire                            net_rx_eop;

   //CPU PACKET OUTPUT
   //wire                            net_tx_ready;
   //wire [71:0]                     net_tx_data;
   //wire                            net_tx_valid;

   //LOGIC ANALYZER 2: THE FIFO INJECT AND INTERCEPT
   wire                            cpu_is_fifo_store;
   wire                            cpu_valid_store;
   wire [31:0]                     cpu_fifo_out_intercept;
   wire [71:0]                     cpu_packet_content_echo; //sanity check if the bottom 64 bits actually exist
   
   //NOT USED
   //reg [31:0]                    matches;

   // internal state NOT USED
   //reg [1:0]                     state, state_next;
   //reg [31:0]                    matches_next;
   //reg                           in_pkt_body, in_pkt_body_next;
   //reg                           end_of_pkt, end_of_pkt_next;
   //reg                           begin_pkt, begin_pkt_next;
   //reg [2:0]                     header_counter, header_counter_next;
   //reg                           counter;

   // local parameter NOT USED
   //parameter                     START = 2'b00;
   //parameter                     HEADER = 2'b01;
   //parameter                     PAYLOAD = 2'b10;

 
   //------------------------- Local assignments -------------------------------
   //NOT USED
   //assign in_rdy     = !in_fifo_nearly_full;
   //assign matcher_en = in_pkt_body;
   //assign matcher_ce = (!in_fifo_empty && out_rdy);
   //assign matcher_reset = (reset || ids_cmd[0] || end_of_pkt);

   //------------------------- Modules-------------------------------

   generic_regs
   #( 
      .UDP_REG_SRC_WIDTH   (UDP_REG_SRC_WIDTH),
      .TAG                 (`IDS_BLOCK_ADDR),          // Tag -- eg. MODULE_TAG
      .REG_ADDR_WIDTH      (`IDS_REG_ADDR_WIDTH),     // Width of block addresses -- eg. MODULE_REG_ADDR_WIDTH
      .NUM_COUNTERS        (0),                 // Number of counters
      .NUM_SOFTWARE_REGS   (4),                 // Number of sw regs
      .NUM_HARDWARE_REGS   (15)                  // Number of hw regs
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

      // --- counters interface
      .counter_updates  (),
      .counter_decrement(),

      // --- SW regs interface
      //.software_regs    ({ids_cmd,pattern_low,pattern_high}),
      .software_regs    ({dmem, imem, address, input_type}),

      // --- HW regs interface
	   .hardware_regs    ({packet_out_low, packet_out_mid, packet_out_high, packet_check_low, packet_check_mid, packet_check_high, alu_zero, cpu_request, cpu_pc_thread0, cpu_store, result_check_lower, 
         result_check_upper, gpu_lower, gpu_upper, dmem_out}),

      .clk              (clk),
      .reset            (reset)
    );

   //intercept whenever the SoC decides to fire a packet
   wire [63:0] soc_net_tx_data;
   wire [7:0]  soc_net_tx_ctrl;
   wire        soc_net_tx_wr;
   
   assign out_data = soc_net_tx_wr ? soc_net_tx_data : in_data;
   assign out_ctrl = soc_net_tx_wr ? soc_net_tx_ctrl : in_ctrl;
   assign out_wr   = soc_net_tx_wr ? 1'b1            : in_wr;
   
   assign in_rdy   = out_rdy;

   //top level pre-parse
   reg in_packet;

   //state machine in case of consecutive starts (PRESERVED FROM YOUR WORKING TEST!)
   always @(posedge clk) begin
      if (reset) begin
         in_packet <= 0;
      end else if (in_wr) begin
         // Look directly at the raw bus inputs to update state
         if ((in_ctrl != 8'h00) && (in_ctrl != 8'hFF)) begin
               // We saw the end-of-packet word
               in_packet <= 0;
         end else if (in_ctrl == 8'hFF) begin
               // We saw a header word
               in_packet <= 1;
         end
      end
   end

   // SOP: It's a header word AND we weren't already tracking a packet
   wire is_sop = in_wr && (in_ctrl == 8'hFF) && !in_packet;
   
   // EOP: It's an end-of-packet word AND we were actively tracking a packet
   wire is_eop = in_wr && (in_ctrl != 8'h00) && (in_ctrl != 8'hFF) && in_packet;

   // ==========================================
   // YOUR NEW SYSTEM-ON-CHIP (CPU + GPU + FIFO + TX FIFO)
   // ==========================================
   wire [63:0] soc_dmem_out;
   wire [63:0] gpu_out, result_check;
   wire is_transmission_store, gpu_capture, cpu_internal_store, cpu_is_thread0, branch_instr;
   wire [31:0] cpu_out, cpu_pc_out, gpu_response;

   wire [7:0] fifo_location;
   wire [71:0] fifo_out, hw_fifo_tx_out;

   integration_top soc_core (
      .clk (clk),
      .rst (reset),

      // Pass the live NetFPGA network ports into the SoC's Network FIFO
      .in_data(in_data),
      .in_ctrl(in_ctrl),
      .in_wr(in_wr),

      //Transmission stuff
      .out_data(soc_net_tx_data),
      .out_ctrl(soc_net_tx_ctrl),
      .out_wr(soc_net_tx_wr),

      // PCI Software Registers (Written by Host PC)
      .sw_input_type(input_type),
      .sw_address(address),
      .sw_imem(imem),
      .sw_dmem_lower(dmem), // Map your existing 32-bit dmem reg to the lower half
      .sw_dmem_upper(32'd0), 

      // PCI Hardware Registers (Read by Host, like the actual host (THATS ME))
      .hw_dmem_out(soc_dmem_out),

      //ILAs
      .result_check(result_check),
      .tpu_transmission_store(is_transmission_store),
      .gpu_debug(gpu_out),
      .gpu_out_cycle(gpu_capture),
      .cpu_dmem_out(cpu_out),
      .cpu_internal_store(cpu_internal_store),
      .cpu_thread0_pc(cpu_pc_out),
      .cpu_is_thread0(cpu_is_thread0),
      .cpu_request_load(gpu_response),
      .alu_zero(branch_instr),

      //network SNOOP      
      .fifo_out_intercept(fifo_out),
      .fifo_tx_out(hw_fifo_tx_out)
   );

   //------------------------- Logic-------------------------------
   
   //quick ILA patchup for branch debugging
   reg [31:0] pc_d;
   reg thread_d;

   always @(posedge clk) begin
      if (reset) begin
         pc_d <= 32'd0;
         thread_d <= 1'b0;
      end else begin
         pc_d <= cpu_pc_out;  // original PC
         thread_d <= cpu_is_thread0;
      end
   end

   always @(posedge clk) begin
      if (reset) begin
         dmem_out <= 32'b0;
         gpu_upper <= 32'b0;
         gpu_lower <= 32'b0;
         result_check_lower <= 32'b0;
         result_check_upper <= 32'b0;

         packet_check_high <= 32'b0;
         packet_check_mid <= 32'b0;
         packet_check_low <= 32'b0;

         packet_out_high <= {24'b0, hw_fifo_tx_out[71:64]};
         packet_out_mid <= hw_fifo_tx_out[63:32];
         packet_out_low <= hw_fifo_tx_out[31:0];

         cpu_store <= 32'b0;
         cpu_pc_thread0 <= 32'b0;
      end
      else begin
         //it's basically the bottom bits of whatever the GPU gave up. but that's enough to prove success for this test
         dmem_out <= soc_dmem_out[31:0];

         packet_check_high <= {24'b0, fifo_out[71:64]};
         packet_check_mid <= fifo_out[63:32];
         packet_check_low <= fifo_out[31:0];

         packet_out_high <= {24'b0, hw_fifo_tx_out[71:64]};
         packet_out_mid <= hw_fifo_tx_out[63:32];
         packet_out_low <= hw_fifo_tx_out[31:0];

         if (is_transmission_store) begin
            result_check_lower <= result_check[31:0];
            result_check_upper <= result_check[63:32];
         end

         if (cpu_internal_store) begin
            cpu_store <= cpu_out;
         end 

         if (pc_d == 32'hE && thread_d) begin
            cpu_request <= gpu_response;
            alu_zero <= {31'b0, branch_instr};
         end
         
         cpu_pc_thread0 <= cpu_pc_out; 

         gpu_upper <= gpu_out[63:32];
         gpu_lower <= gpu_out[31:0];
         
         /*if (gpu_capture) begin
            gpu_upper <= gpu_out[63:32];
            gpu_lower <= gpu_out[31:0];
         end*/

      end
   end // Closes the always block
 
endmodule
