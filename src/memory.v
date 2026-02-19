module memory (
    input         clk,
    input         write_to_dmem,    // From Host (Write)
    input         read_req_dmem,     // From Host (Read Request)
    input  [7:0]  addr_dmem_host,   
    input  [31:0] data_dmem_host,   
    input  [31:0] pipeline_addr,    
    input  [31:0] pipeline_data,    
    input         pipeline_we,      
    output [63:0] dmem_out          
);

    // Muxing logic: Host gets priority if it is reading OR writing
    wire host_active = write_to_dmem || read_req_dmem;

    // Select Address: Use host address if host is active, otherwise pipeline address
    wire [7:0]  final_addr = host_active ? addr_dmem_host : pipeline_addr[7:0];

    // Select Data In: Host data is padded to 64-bit for the memory block
    wire [63:0] final_din  = write_to_dmem ? {32'b0, data_dmem_host} : {32'b0, pipeline_data};

    // Select Write Enable: High only during a Host Write or a Pipeline Store
    wire        final_we   = write_to_dmem ? 1'b1 : pipeline_we;

    mem64bit256 dmem_blk (
        .clka(clk),
		  .clkb(clk),
        .addra(final_addr),
		  .addrb(8'b0),
        .dina(final_din),
        .wea(final_we),
        .doutb(dmem_out)
    );

endmodule