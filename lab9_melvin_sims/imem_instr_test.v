`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:06:11 03/21/2026
// Design Name:   mem32bit512
// Module Name:   C:/Documents and Settings/Melvin/My Documents/lab8/imem_instr_test.v
// Project Name:  lab8
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mem32bit512
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module imem_instr_test;

	// Inputs
	reg [8:0] addr;
	reg clk;
	reg [31:0] din;
	reg we;

	// Outputs
	wire [31:0] dout;

	// Instantiate the Unit Under Test (UUT)
	mem32bit512 uut (
		.addr(addr), 
		.clk(clk), 
		.din(din), 
		.dout(dout), 
		.we(we)
	);

	always #4 clk = ~clk;
	
	initial begin
		// Initialize Inputs
		addr = 0;
		clk = 0;
		din = 0;
		we = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		addr = 1;
		
		#8
		
		addr = 2;

	end
      
endmodule

