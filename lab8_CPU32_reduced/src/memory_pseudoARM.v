module memory (
    input         clk,
    input  [1:0]  curr_thread,
	 input         write_to_dmem,    // From Host (Write)
    input         read_req_dmem,     // From Host (Read Request)
    input  [7:0]  addr_dmem_host,   
    input  [31:0] data_dmem_host,   
    input  [31:0] pipeline_addr,    
    input  [31:0] pipeline_data,    
    input         pipeline_we,      
    output [31:0] dmem_out //this needs to change according to the type tested         
);

    // Muxing logic: Host gets priority if it is reading OR writing
    wire host_active = write_to_dmem || read_req_dmem;

    // The host gets priority here
    // adjusted_addr is a HARDWARE EDIT! TELLS EACH THREAD THAT IT HAS AN OFFSET PROPORTIONAL TO ITS THREAD ID
	 wire [7:0]  adjusted_addr = {curr_thread, 4'b0000} + pipeline_addr[7:0];
	 
	 wire [7:0]  final_addr = host_active ? addr_dmem_host : adjusted_addr;

    wire [31:0] final_din  = write_to_dmem ? data_dmem_host : pipeline_data;

    // Select Write Enable: High only during a Host Write or a Pipeline Store
    wire        final_we   = write_to_dmem ? 1'b1 : pipeline_we;

    /*mem32bit256 dmem_blk (
        .clka(clk),
		.clkb(clk),
        .addra(final_addr),
		.addrb(final_addr),
        .dina({final_din}),
        .wea(final_we),
        .doutb(dmem_out)
    );*/

    
    wire [63:0] raw_dmem;
    dmem_64W256D dmem_blk (
        .clka(clk),
		.clkb(clk),
        .addra(final_addr),
		.addrb(final_addr),
        .dina({32'b0, final_din}),
        .wea(final_we),
        .doutb(raw_dmem)
    );

    assign dmem_out = raw_dmem;

endmodule
