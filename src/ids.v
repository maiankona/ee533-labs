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


   
   //NOT USED
   //wire [31:0]                   pattern_high;
   //wire [31:0]                   pattern_low;
   //wire [31:0]                   ids_cmd;
   // hardware registers
   reg [31:0]                      dmem_out;
   
   wire                            write_to_imem;
   wire                            write_to_dmem;
   wire [8:0]                      addr_imem_host;
   wire [31:0]                     data_imem_host;
   wire [7:0]                      addr_dmem_host;
   wire [31:0]                     data_dmem_host;

	wire                            read_req_dmem;
   wire [31:0]                     data_out_dmem;
   
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
      .NUM_HARDWARE_REGS   (1)                  // Number of hw regs
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
      .hardware_regs    (dmem),

      .clk              (clk),
      .reset            (reset)
    );

   pipeline_backup cpuLab (
      .clk (clk),
      .rst (reset),

      //HOST interactions
      .write_to_imem(write_to_imem),
      .write_to_dmem(write_to_dmem),
      .addr_imem_host(addr_imem_host),
      .data_imem_host(data_imem_host),
      .addr_dmem_host(addr_dmem_host),
      .data_dmem_host(data_dmem_host),

      .read_req_dmem(read_req_dmem),
      .data_out_dmem(data_out_dmem)
   );

   //------------------------- Logic-------------------------------
   
   //intended convention: input_type takes in imem, dmem_write, dmem_read
   wire imem_we = input_type [0];
   wire dmem_we = input_type [1]; 
   wire dmem_read_req = input_type [2]; 

   //interfacing hw and sw
   assign write_to_imem = imem_we;
   assign write_to_dmem = dmem_we;
   assign addr_imem_host = address[8:0];
   assign data_imem_host = imem;
   assign addr_dmem_host = address[7:0];
   assign data_dmem_host = dmem;

	assign read_req_dmem = dmem_read_req;

   always @(posedge clk) begin
	    if (reset) begin
           dmem_out <= 32'b0;
		end
        else if (dmem_read_req) begin
           dmem_out <= data_out_dmem;
        end
   end
 
endmodule 
