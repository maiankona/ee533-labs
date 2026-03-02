`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:11:02 02/27/2026 
// Design Name: 
// Module Name:    memory 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module memory (
    input         clk,
    input         write_to_dmem,    // From Host (Write)
    input         read_req_dmem,     // From Host (Read Request)
    input  [7:0]  addr_dmem_host,   
	input  [63:0] data_dmem_host,   
    input  [31:0] pipeline_addr,    
	input  [63:0] pipeline_data,    
    input         pipeline_we,      
    output [63:0] dmem_out          
);

    // Muxing logic: Host gets priority if it is reading OR writing
    wire host_active = write_to_dmem || read_req_dmem;

    // Select Address: Use host address if host is active, otherwise pipeline address
    wire [7:0]  final_addr = host_active ? addr_dmem_host : pipeline_addr[7:0];

    // Select Data In: removed padding 
	wire [63:0] final_din = write_to_dmem ? data_dmem_host : pipeline_data;

    // Select Write Enable: High only during a Host Write or a Pipeline Store
    wire        final_we   = write_to_dmem ? 1'b1 : pipeline_we;

    mem64bit256 dmem_blk (
        .clka(clk),
		  .clkb(clk),
        .addra(final_addr),
		  .addrb(final_addr),
        .dina(final_din),
        .wea(final_we),
        .doutb(dmem_out)
    );

endmodule
