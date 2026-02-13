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

module D2_4E_MXILINX_registerFile32(A0, 
                                    A1, 
                                    E, 
                                    D0, 
                                    D1, 
                                    D2, 
                                    D3);

    input A0;
    input A1;
    input E;
   output D0;
   output D1;
   output D2;
   output D3;
   
   
   AND3 I_36_30 (.I0(A1), 
                 .I1(A0), 
                 .I2(E), 
                 .O(D3));
   AND3B1 I_36_31 (.I0(A0), 
                   .I1(A1), 
                   .I2(E), 
                   .O(D2));
   AND3B1 I_36_32 (.I0(A1), 
                   .I1(A0), 
                   .I2(E), 
                   .O(D1));
   AND3B2 I_36_33 (.I0(A0), 
                   .I1(A1), 
                   .I2(E), 
                   .O(D0));
endmodule
`timescale 1ns / 1ps

module registerFile32(clk, 
                      clr, 
                      r0addr, 
                      r1addr, 
                      waddr, 
                      wdata, 
                      wena, 
                      r0data, 
                      r1data);

    input clk;
    input clr;
    input [1:0] r0addr;
    input [1:0] r1addr;
    input [1:0] waddr;
    input [31:0] wdata;
    input wena;
   output [31:0] r0data;
   output [31:0] r1data;
   
   wire XLXN_5;
   wire XLXN_6;
   wire XLXN_7;
   wire XLXN_8;
   wire XLXN_9;
   wire XLXN_10;
   wire XLXN_11;
   wire XLXN_12;
   wire [31:0] XLXN_20;
   wire [31:0] XLXN_21;
   wire [31:0] XLXN_22;
   wire [31:0] XLXN_23;
   
   D2_4E_MXILINX_registerFile32 XLXI_1 (.A0(waddr[0]), 
                                        .A1(waddr[1]), 
                                        .E(wena), 
                                        .D0(XLXN_5), 
                                        .D1(XLXN_6), 
                                        .D2(XLXN_7), 
                                        .D3(XLXN_8));
   // synthesis attribute HU_SET of XLXI_1 is "XLXI_1_0"
   FD32 XLXI_2 (.ce(XLXN_9), 
                .clk(clk), 
                .clr(clr), 
                .D(wdata[31:0]), 
                .Q(XLXN_20[31:0]));
   FD32 XLXI_3 (.ce(XLXN_10), 
                .clk(clk), 
                .clr(clr), 
                .D(wdata[31:0]), 
                .Q(XLXN_21[31:0]));
   FD32 XLXI_4 (.ce(XLXN_11), 
                .clk(clk), 
                .clr(clr), 
                .D(wdata[31:0]), 
                .Q(XLXN_22[31:0]));
   FD32 XLXI_5 (.ce(XLXN_12), 
                .clk(clk), 
                .clr(clr), 
                .D(wdata[31:0]), 
                .Q(XLXN_23[31:0]));
   AND2 XLXI_6 (.I0(XLXN_5), 
                .I1(wena), 
                .O(XLXN_9));
   AND2 XLXI_7 (.I0(XLXN_6), 
                .I1(wena), 
                .O(XLXN_10));
   AND2 XLXI_8 (.I0(XLXN_7), 
                .I1(wena), 
                .O(XLXN_11));
   AND2 XLXI_9 (.I0(XLXN_8), 
                .I1(wena), 
                .O(XLXN_12));
   mux4_32 XLXI_10 (.R0(XLXN_20[31:0]), 
                    .R1(XLXN_21[31:0]), 
                    .R2(XLXN_22[31:0]), 
                    .R3(XLXN_23[31:0]), 
                    .sel(r0addr[1:0]), 
                    .Y(r0data[31:0]));
   mux4_32 XLXI_11 (.R0(XLXN_20[31:0]), 
                    .R1(XLXN_21[31:0]), 
                    .R2(XLXN_22[31:0]), 
                    .R3(XLXN_23[31:0]), 
                    .sel(r1addr[1:0]), 
                    .Y(r1data[31:0]));
endmodule
