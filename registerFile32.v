module registerFile32(
    input clk,
    input clr,
    input [2:0] r0addr, // Reg1 address
    input [2:0] r1addr, // Reg2 address
    input [2:0] waddr,  // Write address from WB stage
    input [31:0] wdata, // Write data from WB stage
    input wena,         // Write enable from WB stage
    output [31:0] r0data,
    output [31:0] r1data
    );

    // Create an array of 8 registers, each 32 bits wide
    reg [31:0] rf [7:0];
    integer i;

    // Async Read: Always provides data based on addresses
    assign r0data = rf[r0addr];
    assign r1data = rf[r1addr];

    // Synchronous Write and Reset
    always @(posedge clk) begin
        if (clr) begin
            // Reset all registers to 0
            for (i = 0; i < 8; i = i + 1) rf[i] <= 32'b0;
        end else if (wena) begin
            rf[waddr] <= wdata;
        end
    end
endmodule
