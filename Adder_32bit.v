////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2008 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____ 
//  /   /\/   / 
// /___/  \  /    Vendor: Xilinx 
// \   \   \/     Version : 10.1
//  \   \         Application : sch2verilog
//  /   /         Filename : Adder_32bit.vf
// /___/   /\     Timestamp : 02/11/2026 20:42:07
// \   \  /  \ 
//  \___\/\___\ 
//
//Command: C:\Xilinx\10.1\ISE\bin\nt\unwrapped\sch2verilog.exe -intstyle ise -family virtex2p -w C:/Xilinx/10.1/ISE/ISEexamples/ee533-lab5/Adder_32bit.sch Adder_32bit.vf
//Design Name: Adder_32bit
//Device: virtex2p
//Purpose:
//    This verilog netlist is translated from an ECS schematic.It can be 
//    synthesized and simulated, but it should not be modified. 
//
`timescale 1ns / 1ps

module Adder_32bit(A, 
                   B, 
                   Ci, 
                   Co, 
                   S);

    input [31:0] A;
    input [31:0] B;
    input Ci;
   output Co;
   output [31:0] S;
   
   wire XLXN_92;
   wire XLXN_93;
   wire XLXN_94;
   
   Adder_8bit XLXI_1 (.A(A[7:0]), 
                      .B(B[7:0]), 
                      .Ci(Ci), 
                      .Co(XLXN_93), 
                      .S(S[7:0]));
   Adder_8bit XLXI_17 (.A(A[15:8]), 
                       .B(B[15:8]), 
                       .Ci(XLXN_93), 
                       .Co(XLXN_92), 
                       .S(S[15:8]));
   Adder_8bit XLXI_18 (.A(A[23:16]), 
                       .B(B[23:16]), 
                       .Ci(XLXN_92), 
                       .Co(XLXN_94), 
                       .S(S[23:16]));
   Adder_8bit XLXI_19 (.A(A[31:24]), 
                       .B(B[31:24]), 
                       .Ci(XLXN_94), 
                       .Co(Co), 
                       .S(S[31:24]));
endmodule
