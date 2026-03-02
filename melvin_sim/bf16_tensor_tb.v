`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   04:28:47 02/27/2026
// Design Name:   bf16_tensor
// Module Name:   C:/Documents and Settings/Melvin/My Documents/bf16_tensor_tb.v
// Project Name:  lab7
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: bf16_tensor
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
module bf16_tensor_tb;
    // inputs
    reg clk;
    reg [5:0] opcode;
    reg [63:0] r1data, r2data;
    
    // register file model - mimics real pipeline writeback
    reg [63:0] regfile [0:31];
    wire [4:0] rd_addr = 5'd3;              // r3 is our accumulator register
    wire [63:0] rd_data = regfile[rd_addr]; // rd_data driven continuously from regfile
    
    // outputs
    wire [63:0] tensor_out;
    wire tensor_done;
    
    // instantiate
    bf16_tensor uut (
        .clk(clk),
        .opcode(opcode),
        .r1data(r1data),
        .r2data(r2data),
        .rd_data(rd_data),
        .tensor_out(tensor_out),
        .tensor_done(tensor_done)
    );
    
    // clock gen
    initial clk = 0;
    always #5 clk = ~clk;
    
    // timeout block
    initial begin
        #5000;
        $display("TIMEOUT at %0t - simulation did not complete", $time);
        $stop;
    end
    
    integer i;
    initial begin
        // clear register file
        for (i = 0; i < 32; i = i + 1)
            regfile[i] = 64'h0;
        
        opcode  = 6'h0;
        r1data  = 64'h0;
        r2data  = 64'h0;
        #10;
        
        // VADD: 1.0 + 2.0 = 3.0 expected (0x4040 per lane)
        opcode = 6'h06;
        r1data = {4{16'h3F80}};  // all lanes = 1.0
        r2data = {4{16'h4000}};  // all lanes = 2.0
        repeat(20) @(posedge clk);
        $display("VADD  result: %h (expected 4040404040404040)", tensor_out);
        
        // VSUB: 1.0 - 2.0 = -1.0 expected (0xBF80 per lane)
        opcode = 6'h07;
        r1data = {4{16'h3F80}};  // all lanes = 1.0
        r2data = {4{16'h4000}};  // all lanes = 2.0
        repeat(20) @(posedge clk);
        $display("VSUB  result: %h (expected bf80bf80bf80bf80)", tensor_out);
        
        // VMUL: 2.0 * 2.0 = 4.0 expected (0x4080 per lane)
        opcode = 6'h08;
        r1data = {4{16'h4000}};  // all lanes = 2.0
        r2data = {4{16'h4000}};  // all lanes = 2.0
        repeat(20) @(posedge clk);
        $display("VMUL  result: %h (expected 4080408040804080)", tensor_out);
        
        // VMAC pass 1: r3 = 0.0 + (2.0 * 2.0) = 4.0 expected (0x4080 per lane)
        regfile[rd_addr] = 64'h0;   // explicitly clear accumulator r3
        opcode  = 6'h09;
        r1data  = {4{16'h4000}};    // all lanes = 2.0
        r2data  = {4{16'h4000}};    // all lanes = 2.0
        repeat(20) @(posedge clk);
        $display("VMAC pass 1: %h (expected 4080408040804080)", tensor_out);  // 4.0
        regfile[rd_addr] <= tensor_out;  // writeback: r3 = 4.0
        @(posedge clk);
        
        // VMAC pass 2: r3 = 4.0 + (2.0 * 2.0) = 8.0 expected (0x4100 per lane)
        opcode  = 6'h09;
        r1data  = {4{16'h4000}};    // all lanes = 2.0
        r2data  = {4{16'h4000}};    // all lanes = 2.0
        repeat(20) @(posedge clk);
        $display("VMAC pass 2: %h (expected 4100410041004100)", tensor_out);  // 8.0
        regfile[rd_addr] <= tensor_out;  // writeback: r3 = 8.0
        @(posedge clk);
        
        // VMAC pass 3: r3 = 8.0 + (2.0 * 2.0) = 12.0 expected (0x4140 per lane)
        opcode  = 6'h09;
        r1data  = {4{16'h4000}};    // all lanes = 2.0
        r2data  = {4{16'h4000}};    // all lanes = 2.0
        repeat(20) @(posedge clk);
        $display("VMAC pass 3: %h (expected 4140414041404140)", tensor_out);  // 12.0
        
        // VRELU: -1.0 -> 0.0 expected (0x0000 per lane, negative clamped to zero)
        opcode  = 6'h0A;
        r1data  = {4{16'hBF80}};    // all lanes = -1.0
        r2data  = 64'h0;
        repeat(20) @(posedge clk);
        $display("VRELU result: %h (expected 0000000000000000)", tensor_out);
        
        $stop;
    end
endmodule
