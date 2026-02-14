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

	// Instantiate the Unit Under Test (UUT)
	pipeline_datapath_skeleton uut (
		.clk(clk), 
		.rst(rst)
	);

	initial
	forever #25 clk = ~clk;
	
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;

		// Wait 100 ns for global reset to finish
		#5;
      rst = 1;
		
		//
		#5;
      rst = 0;

		//
		
//		$stop;
		
	end
      
endmodule

