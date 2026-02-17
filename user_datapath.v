///////////////////////////////////////////////////////////////////////////////
// vim:set shiftwidth=3 softtabstop=3 expandtab:
//
//
// Module: user_datapath.v
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

module user_datapath
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
      input                                clk,
		
		// Integrated Logic Analyzer
		output [DATA_WIDTH-1:0]				 ILA_out
   );

   // Define the log2 function
   // `LOG2_FUNC

   //------------------------- Signals-------------------------------
	
   wire [DATA_WIDTH-1:0]         in_fifo_data;
   wire [CTRL_WIDTH-1:0]         in_fifo_ctrl;

   wire                          in_fifo_nearly_full;
   wire                          in_fifo_empty;

	// For Logic Analyzer
	reg									ILA_rd;
	wire									ILA_empty;
	wire [DATA_WIDTH-1:0]				 ILA_in;
	wire								 ILA_wr;

   reg                           in_fifo_rd_en;
   reg                           out_wr_int;

   // software registers 
   wire [31:0]                   pattern_high;
   wire [31:0]                   pattern_low;
   wire [31:0]                   ids_cmd;
   // hardware registers
   reg [31:0]                    matches;
	reg [63:0]							ILA_data; 	// For Logic Analyzer

	// memory interface registers
	wire [31:0]                   mem_addr; //sw
	wire [31:0]                   mem_data_write; //sw
	wire [31:0]                   mem_cmd; //sw
	assign mem_cmd = ids_cmd;
	reg [31:0]                    mem_data_read; //hw
	
   // internal state
   reg [1:0]                     state, state_next;
   reg [31:0]                    matches_next;
   reg                           in_pkt_body, in_pkt_body_next;
   reg                           end_of_pkt, end_of_pkt_next;
   reg                           begin_pkt, begin_pkt_next;
   reg [2:0]                     header_counter, header_counter_next;
   reg                           counter;

   // local parameter
   parameter                     START = 2'b00;
   parameter                     HEADER = 2'b01;
   parameter                     PAYLOAD = 2'b10;
   // parameter                  EMPTY = 4'b0001;
   // parameter                  FILLING = 4'b0010;
   // parameter                  FULL = 4'b0100;
   // parameter                  DRAINING = 4'b1000;
 
   //------------------------- Local assignments -------------------------------

   assign in_rdy     = !in_fifo_nearly_full;
   assign matcher_en = in_pkt_body;
   assign matcher_ce = (!in_fifo_empty && out_rdy);
   assign matcher_reset = (reset || ids_cmd[0] || end_of_pkt);

	// --- Logic Analyzer
	//Currently monitoring input FIFO (post-input FIFO datapath)

	assign ILA_wr = in_fifo_rd_en;	 //Currently monitoring input FIFO
	assign ILA_in = in_fifo_data;   //Currently monitoring input FIFO

   //------------------------- Modules-------------------------------


   generic_regs
   #( 
      .UDP_REG_SRC_WIDTH   (UDP_REG_SRC_WIDTH),
      .TAG                 (`IDS_BLOCK_ADDR),          
      .REG_ADDR_WIDTH      (`IDS_REG_ADDR_WIDTH),     
      .NUM_COUNTERS        (0),                 
	  .NUM_SOFTWARE_REGS   (5),   // from 3 to 5 -Maia              
	  .NUM_HARDWARE_REGS   (4)  // from 3 to 4 -Maia                
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
	   .software_regs    ({mem_data_write, mem_addr,ids_cmd,pattern_low,pattern_high}),

      // --- HW regs interface
	   .hardware_regs    ({mem_data_read, ILA_data[63:32],ILA_data[31:0],matches}),

      .clk              (clk),
      .reset            (reset)
    );

	// pipeline SKELETON instatiation (for now)
	pipeline_datapath_skeleton processor (
    .clk(clk),
    .rst(reset),
    .mem_addr_reg(mem_addr),
    .mem_data_write_reg(mem_data_write),
    .mem_data_read_reg(mem_data_read),
		.mem_cmd_reg(mem_cmd)
);
	 
	 		// --- Logic Analyzer
		
		/*ILA ILA0 (
		.clk(clk),
		.reset(reset),
		.data_in(ILA_in),
		.wen(ILA_wr),
		.ren(ILA_rd),
		.data_out(ILA_out),
		.depth(),
		.empty(ILA_empty),
		.full()	
		);
		*(/

   //------------------------- Logic-------------------------------
   
   always @(*) begin
      state_next = state;
      matches_next = matches;
      header_counter_next = header_counter;
      in_fifo_rd_en = 0;
      out_wr_int = 0;
      end_of_pkt_next = end_of_pkt;
      in_pkt_body_next = in_pkt_body;
      begin_pkt_next = begin_pkt;

      if (!ILA_empty)
         ILA_rd = 1;  // Drain FIFO whenever data exists
		
      if (!in_fifo_empty && out_rdy) begin
         out_wr_int = 1;
         in_fifo_rd_en = 1;
         
         case(state)
            START: begin
              if (in_fifo_ctrl != 0) begin
                  state_next = HEADER;
                  begin_pkt_next = 1;
                  end_of_pkt_next = 0;
               end
            end
            HEADER: begin
               begin_pkt_next = 0;
               if (in_fifo_ctrl == 0) begin
                  header_counter_next = header_counter + 1'b1;
                  if (header_counter_next == 3)
                    state_next = PAYLOAD;
               end
            end
            PAYLOAD: begin
               if (in_fifo_ctrl != 0) begin
                  state_next = START;
                  header_counter_next = 0;
                  if (matcher_match)
                     matches_next = matches + 1;
                  end_of_pkt_next = 1;
                  in_pkt_body_next = 0;
               end
               else
                  in_pkt_body_next = 1;
            end
         endcase
      end
   end
   
   always @(posedge clk) begin
      if(reset) begin
         header_counter <= 0;
         state <= START;
         begin_pkt <= 0;
         end_of_pkt <= 0;
         in_pkt_body <= 0;
			ILA_data <= 0;	// Initialize the ILA data output to zeros
      end
      else begin
         if (ids_cmd[0]) matches <= 0;
         else matches <= matches_next;

			if (ILA_rd) 
            ILA_data <= ILA_out;	//Only update the data when the read signal is valid

         header_counter <= header_counter_next;
         state <= state_next;
         begin_pkt <= begin_pkt_next;
         end_of_pkt <= end_of_pkt_next;
         in_pkt_body <= in_pkt_body_next;
			counter <= 0;
      end
   end   

endmodule
