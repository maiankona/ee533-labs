`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:13:49 02/27/2026 
// Design Name: 
// Module Name:    registerFile64 
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
module registerFile64(
    input clk,
    input clr,
    input [4:0]  r1addr,  // RS1 read address
    input [4:0]  r2addr,  // RS2 read address
    input [4:0]  rdaddr,  // RD read address (3rd port, used by VMAC accumulator)
    input [4:0]  waddr,   // Write address from WB stage
    input [63:0] wdata,   // Write data from WB stage
    input        wena,    // Write enable from WB stage
    output [63:0] r1data,
    output [63:0] r2data,
    output [63:0] rddata  // RD read data for VMAC accumulator
);

    reg [63:0] rf [31:0]; //64-bit data, 32 registers
    integer i;

    // -------- Forwarding Logic (Fixes Read-During-Write) --------
    // r0 is hardwired to 0; forward WB data if addresses match

    assign r1data = (r1addr == 5'd0) ? 64'd0 :
                    (wena && (waddr == r1addr)) ? wdata : rf[r1addr];

    assign r2data = (r2addr == 5'd0) ? 64'd0 :
                    (wena && (waddr == r2addr)) ? wdata : rf[r2addr];

    // 3rd port: same forwarding pattern as r1/r2
    // Used by VMAC to read the accumulator register (rd) alongside r1 and r2
    assign rddata = (rdaddr == 5'd0) ? 64'd0 :
                    (wena && (waddr == rdaddr)) ? wdata : rf[rdaddr];

    // -------- Synchronous Write and Reset --------
    always @(posedge clk or posedge clr) begin
        if (clr) begin
            for (i = 0; i < 32; i = i + 1)
                rf[i] <= 64'b0;
        end
        else if (wena && waddr != 5'd0) begin
            rf[waddr] <= wdata;
        end
    end

endmodule
