module registerFile32(
    input clk,
    input clr,
    input [4:0] r1addr, // Reg1 address
    input [4:0] r2addr, // Reg2 address
    input [4:0] waddr,  // Write address from WB stage
    input [31:0] wdata, // Write data from WB stage
    input wena,         // Write enable from WB stage
    output [31:0] r1data,
    output [31:0] r2data
    );

    // Create an array of 8 registers, each 32 bits wide
    reg [31:0] rf [31:0];
    integer i;

    // -------- Forwarding Logic (Fixes Read-During-Write) --------
    assign r1data = (wena && (waddr == r1addr)) ? wdata : rf[r1addr];
    assign r2data = (wena && (waddr == r2addr)) ? wdata : rf[r2addr];

    // -------- Synchronous Write and Reset --------
    always @(posedge clk or posedge clr) begin
        if (clr) begin
            // Reset all registers to 0
            for (i = 0; i < 32; i = i + 1)
                rf[i] <= 32'b0;
        end 
        else if (wena) begin
            rf[waddr] <= wdata;
        end
    end

endmodule
