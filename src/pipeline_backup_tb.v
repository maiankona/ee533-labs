`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:40:57 02/19/2026
// Design Name:   pipeline_backup
// Module Name:   C:/Documents and Settings/Melvin/My Documents/Lab5/Lab5_new/pipeline_backup_tb.v
// Project Name:  Lab5_new
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: pipeline_backup
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module pipeline_backup_tb;

	// Inputs
	reg clk;
	reg rst;
	reg write_to_imem;
	reg write_to_dmem;
	reg [8:0] addr_imem_host;
	reg [31:0] data_imem_host;
	reg [7:0] addr_dmem_host;
	reg [31:0] data_dmem_host;
	reg read_req_dmem;

	// Outputs
	wire [31:0] data_out_dmem;

	// Instantiate the Unit Under Test (UUT)
	pipeline_backup uut (
		.clk(clk), 
		.rst(rst), 
		.write_to_imem(write_to_imem), 
		.write_to_dmem(write_to_dmem), 
		.addr_imem_host(addr_imem_host), 
		.data_imem_host(data_imem_host), 
		.addr_dmem_host(addr_dmem_host), 
		.data_dmem_host(data_dmem_host), 
		.read_req_dmem(read_req_dmem), 
		.data_out_dmem(data_out_dmem)
	);

	initial
	begin
		forever #50 clk = ~clk;
	end

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		write_to_imem = 0;
		write_to_dmem = 0;
		addr_imem_host = 0;
		data_imem_host = 0;
		addr_dmem_host = 0;
		data_dmem_host = 0;
		read_req_dmem = 0;

		// Wait 100 ns for global reset to finish
		#100;
       		 
		// Add stimulus here
		rst = 1;
		
		//
		#100
		rst = 0;
				
//		write_to_dmem	= 1;
//		addr_dmem_host = 32'h00000000;
//		data_dmem_host = 32'hffffffff;
//		
//		#100
//		write_to_dmem	= 0;
//		addr_dmem_host = 32'h00000000;
//		data_dmem_host = 32'h00000000;



	end
      
endmodule

