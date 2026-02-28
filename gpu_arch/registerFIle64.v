module registerFile64(
    input clk,
    input clr,
    input [4:0] r1addr, // Reg1 address
    input [4:0] r2addr, // Reg2 address
    input [4:0] waddr,  // Write address from WB stage
    input [63:0] wdata, // Write data from WB stage
    input wena,         // Write enable from WB stage
    output [63:0] r1data,
    output [63:0] r2data
    );

    // Create an array of 8 registers, each 32 bits wide
    reg [63:0] rf [31:0];
    integer i;

    // -------- Forwarding Logic (Fixes Read-During-Write) --------
    // force r0 to be 0
    assign r1data = (r1addr == 5'd0) ? 64'd0 :
                    (wena && (waddr == r1addr)) ? wdata : rf[r1addr];
    
    assign r2data = (r2addr == 5'd0) ? 64'd0 :
                    (wena && (waddr == r2addr)) ? wdata : rf[r2addr];

    // -------- Synchronous Write and Reset --------
    always @(posedge clk or posedge clr) begin
        if (clr) begin
            // Reset all registers to 0
            for (i = 0; i < 32; i = i + 1)
                rf[i] <= 64'b0;
        end 
        else if (wena && waddr != 5'd0) begin // dont write to r0
            rf[waddr] <= wdata;
        end
    end

endmodule
