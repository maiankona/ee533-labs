///////////////////////////////////////////////////////////////////////////////
// vim:set shiftwidth=3 softtabstop=3 expandtab:
//
//
// Module: user_datapath.v
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

module user_datapath_hard
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

   reg [31:0] regHard0;
   reg [31:0] regHard1;
   reg [31:0] mem_data_test_reg;
   wire [31:0] regHard2;


	// software memory interface registers
	wire [31:0]                   mem_addr; //sw
	wire [31:0]                   mem_data_write; //sw
	wire [31:0]                   mem_cmd; //sw
	
   //hardware memory interface
	wire [31:0]                    mem_data_read; //hw


   //------------------------- Local assignments -------------------------------

   assign regHard2 = 32'hAAAAAAAA;

   //------------------------- Modules-------------------------------


   generic_regs
   #( 
      .UDP_REG_SRC_WIDTH   (UDP_REG_SRC_WIDTH),
      .TAG                 (`IDS_BLOCK_ADDR),          
      .REG_ADDR_WIDTH      (`IDS_REG_ADDR_WIDTH),     
      .NUM_COUNTERS        (0),                 
	  .NUM_SOFTWARE_REGS   (3),   // from 3 to 5 -Maia              
	  .NUM_HARDWARE_REGS   (5)  // from 3 to 4 -Maia                
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
	   .software_regs    ({mem_data_write, mem_addr,mem_cmd}),

      // --- HW regs interface
	   .hardware_regs    ({regHard2, regHard1, regHard0, mem_data_test_reg, mem_data_read}),

      .clk              (clk),
      .reset            (reset)
    );

	// pipeline SKELETON instatiation 
	pipeline_datapath_skeleton processor (
    .clk(clk),
    .rst(reset),
    .mem_addr_reg(mem_addr),
    .mem_data_write_reg(mem_data_write),
    .mem_data_read_reg(mem_data_read),
	 .mem_cmd_reg(mem_cmd)
);
	 

   //------------------------- Logic-------------------------------  

   always @(posedge clk or posedge reset)
   begin
		if(reset)
		begin
			regHard0 <= 9'b00000000;
			regHard1 <= 32'h00000000;
			mem_data_test_reg <= 32'h00000000;
		end
		else
		begin
			regHard0 <= regHard0 + 1; 
			regHard1 <= 32'hFFFFFFFF;
			mem_data_test_reg <= mem_data_read;
		end
   end

endmodule
