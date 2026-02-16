`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:59:48 02/13/2026
// Design Name:   pipeline_datapath_skeleton
// Module Name:   C:/Documents and Settings/Melvin/My Documents/Lab5/pipeline_tb.v
// Project Name:  Lab5
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: pipeline_datapath_skeleton
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module pipeline_tb;

	// Inputs
	reg clk;
	reg rst;
	reg  [31:0] mem_addr_reg_tb;
	reg  [31:0] mem_cmd_reg_in_tb;
	reg  [31:0] mem_data_write_reg_tb;
	wire [31:0] mem_data_read_reg_tb;

	// Instantiate the Unit Under Test (UUT)
	pipeline_datapath_skeleton uut (
		.clk(clk), 
		.rst(rst),
		.mem_addr_reg(mem_addr_reg_tb),
	   .mem_cmd_reg(mem_cmd_reg_in_tb),
	   .mem_data_write_reg(mem_data_write_reg_tb),
	   .mem_data_read_reg(mem_data_read_reg_tb)
	);

	initial
	forever #25 clk = ~clk;
	
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		mem_cmd_reg_in_tb = 6'b000000;
		mem_addr_reg_tb =32'h00000000;
		mem_data_write_reg_tb =32'h00000000; 

		//
		#5;
      rst = 1;
		
		//
		#5;
      rst = 0;
		//
		#65
		mem_cmd_reg_in_tb = 6'b100000; // write to instruction data (must be at least 50 ns)		
		mem_addr_reg_tb =32'h00000002;
		mem_data_write_reg_tb =32'hFFFFFFFF;
			
		#50;
		mem_addr_reg_tb =32'h00000002;
		mem_data_write_reg_tb =32'hFFFFFFFF;
		mem_cmd_reg_in_tb = 6'b000000; // stop writing to instruction data (must be at least 50 ns later)

		
		//
		
//		$stop;
		
	end
      
endmodule

