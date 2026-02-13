////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2008 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____ 
//  /   /\/   / 
// /___/  \  /    Vendor: Xilinx 
// \   \   \/     Version : 10.1
//  \   \         Application : sch2verilog
//  /   /         Filename : registerFile32.vf
// /___/   /\     Timestamp : 02/12/2026 19:01:57
// \   \  /  \ 
//  \___\/\___\ 
//
//Command: C:\Xilinx\10.1\ISE\bin\nt\unwrapped\sch2verilog.exe -intstyle ise -family virtex2p -w C:/Xilinx/10.1/ISE/ISEexamples/ee533-lab5/registerFile32.sch registerFile32.vf
//Design Name: registerFile32
//Device: virtex2p
//Purpose:
//    This verilog netlist is translated from an ECS schematic.It can be 
//    synthesized and simulated, but it should not be modified. 
//
`timescale 1ns / 1ps

module registerFile32 (
    clk, 
    clr, 
    r0addr, 
    r1addr, 
    waddr, 
    wdata, 
    wena, 
    r0data, 
    r1data
);

    input clk;
    input clr;
    input [1:0] r0addr;
    input [1:0] r1addr;
    input [1:0] waddr;
    input [31:0] wdata;
    input wena;
    output [31:0] r0data;
    output [31:0] r1data;

    wire D0, D1, D2, D3;
    wire [31:0] R0, R1, R2, R3;

    // 2-to-4 decoder with enable
    D2_4E_MXILINX_registerFile32 decoder (
        .A0(waddr[0]), 
        .A1(waddr[1]), 
        .E(wena), 
        .D0(D0), 
        .D1(D1), 
        .D2(D2), 
        .D3(D3)
    );

    // Four instances of 32-bit registers
    FD32 reg0 (.ce(D0), .clk(clk), .clr(clr), .D(wdata), .Q(R0));
    FD32 reg1 (.ce(D1), .clk(clk), .clr(clr), .D(wdata), .Q(R1));
    FD32 reg2 (.ce(D2), .clk(clk), .clr(clr), .D(wdata), .Q(R2));
    FD32 reg3 (.ce(D3), .clk(clk), .clr(clr), .D(wdata), .Q(R3));

    // Read port 0
    mux4_32 mux_r0 (
        .R0(R0),
        .R1(R1),
        .R2(R2),
        .R3(R3),
        .sel(r0addr),
        .Y(r0data)
    );

    // Read port 1
    mux4_32 mux_r1 (
        .R0(R0),
        .R1(R1),
        .R2(R2),
        .R3(R3),
        .sel(r1addr),
        .Y(r1data)
    );

endmodule
