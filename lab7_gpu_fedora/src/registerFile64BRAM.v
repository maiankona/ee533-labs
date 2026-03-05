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
module registerFile64BRAM(
    input clk,
    input clr,
    input [4:0]  r1addr,  // RS1 read address
    input [4:0]  r2addr,  // RS2 read address
    input [4:0]  rdaddr,  // RD read address (3rd port, used by VMAC accumulator)
    input [4:0]  waddr,   // Write address from WB stage
    input [63:0] wdata,   // Write data from WB stage
    input        wena,    // Write enable from WB stage
    output reg [63:0] r1data,
    output reg [63:0] r2data,
    output reg [63:0] rddata  // RD read data for VMAC accumulator
);
    (* ram_style = "block" *) reg [63:0] rf [31:0]; //64-bit data, 32 registers
    integer i;

    // -------- Forwarding Logic (Fixes Read-During-Write) --------
    // NOTE: Forwarding is now handled externally (in EX stage) due to
    // synchronous read requirement for BRAM inference.
    // r0 is hardwired to 0 and handled here at read time.

    // -------- Synchronous Write (BRAM write port) --------
    always @(posedge clk) begin
        if (wena && waddr != 5'd0)
            rf[waddr] <= wdata;
    end

    // -------- Synchronous Reads (required for BRAM inference) --------
    always @(posedge clk) begin
        if (clr) begin // Clear the registers, not the BRAM (rf[]) itse;f
            r1data <= 64'd0;
            r2data <= 64'd0;
            rddata <= 64'd0;
        end else begin
            r1data <= (r1addr == 5'd0) ? 64'd0 : rf[r1addr];
            r2data <= (r2addr == 5'd0) ? 64'd0 : rf[r2addr];
            rddata <= (rdaddr == 5'd0) ? 64'd0 : rf[rdaddr];
        end
    end
endmodule
