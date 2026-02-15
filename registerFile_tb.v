////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2003 Xilinx, Inc.
// All Right Reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____ 
//  /   /\/   / 
// /___/  \  /    Vendor: Xilinx 
// \   \   \/     Version : 10.1
//  \   \         Application : ISE
//  /   /         Filename : RF32_tb.tfw
// /___/   /\     Timestamp : Sat Feb 14 18:58:14 2026
// \   \  /  \ 
//  \___\/\___\ 
//
//Command: 
//Design Name: RF32_tb
//Device: Xilinx
//
`timescale 1ns/1ps

module RegisterFile32_tb;
    reg clk = 1'b0;
    reg clr = 1'b0;
    reg [2:0] r0addr = 3'b000;
    reg [2:0] r1addr = 3'b000;
    reg [2:0] waddr = 3'b000;
    reg [31:0] wdata = 32'b00000000000000000000000000000000;
    reg wena = 1'b0;
    wire [31:0] r0data;
    wire [31:0] r1data;

    parameter PERIOD = 200;
    parameter real DUTY_CYCLE = 0.5;
    parameter OFFSET = 100;

    initial    // Clock process for clk
    begin
        #OFFSET;
        forever
        begin
            clk = 1'b0;
            #(PERIOD-(PERIOD*DUTY_CYCLE)) clk = 1'b1;
            #(PERIOD*DUTY_CYCLE);
        end
    end

    registerFile32 UUT (
        .clk(clk),
        .clr(clr),
        .r0addr(r0addr),
        .r1addr(r1addr),
        .waddr(waddr),
        .wdata(wdata),
        .wena(wena),
        .r0data(r0data),
        .r1data(r1data));

    initial begin
        // -------------  Current Time:  100ns
        #100;
        clr = 1'b1;
        wdata = 32'b10101010101010101010101010101010;
        r1addr = 3'b001;
        // -------------------------------------
        // -------------  Current Time:  185ns
        #85;
        clr = 1'b0;
        wena = 1'b1;
        // -------------------------------------
        // -------------  Current Time:  585ns
        #400;
        wdata = 32'b10111011101110111011101110111011;
        waddr = 3'b001;
        // -------------------------------------
        // -------------  Current Time:  1185ns
        #600;
        wdata = 32'b11001100110011001100110011001100;
        // -------------------------------------
        // -------------  Current Time:  1585ns
        #400;
        r0addr = 3'b010;
        waddr = 3'b010;
        // -------------------------------------
        // -------------  Current Time:  1785ns
        #200;
        r1addr = 3'b011;
        // -------------------------------------
        // -------------  Current Time:  2185ns
        #400;
        wdata = 32'b11011101110111011101110111011101;
        waddr = 3'b011;
        // -------------------------------------
        // -------------  Current Time:  2585ns
        #400;
        wena = 1'b0;
        // -------------------------------------
    end

endmodule

