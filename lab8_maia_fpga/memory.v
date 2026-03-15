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

    // Host writes use 32-bit halves: addr 0x70 = lower 32 of word 0x70,
    // addr 0x71 = upper 32 of word 0x70. Physical word = addr & ~1.
    wire [7:0] host_phys_addr = addr_dmem_host & 8'hFE;
    wire host_write_even = write_to_dmem && !addr_dmem_host[0];
    wire host_write_odd  = write_to_dmem && addr_dmem_host[0];

    // Pending register: when host writes to even addr, store lower 32 for next odd write
    reg [31:0] pending_lo;
    reg [7:0]  pending_addr;
    always @(posedge clk) begin
        if (host_write_even) begin
            pending_lo   <= data_dmem_host[31:0];
            pending_addr <= addr_dmem_host;
        end
    end

    // Select Address: Host uses physical word for writes; pipeline uses pipeline_addr
    wire [7:0]  final_addr = host_active ? (write_to_dmem ? host_phys_addr : addr_dmem_host)
                                         : pipeline_addr[7:0];

    // Select Data In: For odd addr, merge with pending from previous even write
    wire [63:0] final_din = write_to_dmem
        ? (host_write_odd ? {data_dmem_host[31:0], pending_lo} : data_dmem_host)
        : pipeline_data;

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
