module registerFile32(
    input clk,
    input clr,
    input [1:0] thread_rd,
    input [1:0] thread_wr,
    input [4:0] r1addr, // Reg1 address
    input [4:0] r2addr, // Reg2 address
    input [4:0] waddr,  // Write address from WB stage
    input [31:0] wdata, // Write data from WB stage
    input wena,         // Write enable from WB stage
    output [31:0] r1data,
    output [31:0] r2data
    );

    // Create an array of 128 registers, each 32 bits wide
    parameter rfDepth = 128;
    reg [31:0] rf [rfDepth-1:0];
    integer i;

    // Assign 32 registers to each thread
    // 2-bit thread ID + 5-bit addr
    wire [6:0] r1_index = {thread_rd, r1addr};
    wire [6:0] r2_index = {thread_rd, r2addr};
    wire [6:0] wr_index = {thread_wr, waddr};

    // Async Read: Pass value through if reading and writing at the same time
    assign r1data = (wena && (r1_index == wr_index)) ? wdata : rf[r1_index];
    assign r2data = (wena && (r2_index == wr_index)) ? wdata : rf[r2_index];

    // Synchronous Write and Reset
    always @(posedge clk or posedge clr) begin
        if (clr) begin
            // Reset all registers to 0
            for (i = 0; i < rfDepth; i = i + 1) rf[i] <= 32'b0;
        end else if (wena) begin
            rf[wr_index] <= wdata;
        end
    end
endmodule
