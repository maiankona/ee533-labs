`timescale 1ns / 1ps
// inspired and extended from lab 3
module COMP32_MXILINX_comparator(A, 
                                 B, 
                                 EQ);

    input [31:0] A;
    input [31:0] B;
   output EQ;
   
   wire AB0;
   wire AB1;
   wire AB2;
   wire AB3;
   wire AB4;
   wire AB5;
   wire AB6;
   wire AB7;
   wire AB8;
   wire AB9;
   wire AB10;
   wire AB11;
   wire AB12;
   wire AB13;
   wire AB14;
   wire AB15;
   wire AB16;
   wire AB17;
   wire AB18;
   wire AB19;
   wire AB20;
   wire AB21;
   wire AB22;
   wire AB23;
   wire AB24;
   wire AB25;
   wire AB26;
   wire AB27;
   wire AB28;
   wire AB29;
   wire AB30;
   wire AB31;
   wire AB07;
   wire AB815;
   wire AB1623;
   wire AB2431;
   wire AB015;
   wire AB1631;
   
   XNOR2 I_36_00 (.I0(B[0]), .I1(A[0]), .O(AB0));
   XNOR2 I_36_01 (.I0(B[1]), .I1(A[1]), .O(AB1));
   XNOR2 I_36_02 (.I0(B[2]), .I1(A[2]), .O(AB2));
   XNOR2 I_36_03 (.I0(B[3]), .I1(A[3]), .O(AB3));
   XNOR2 I_36_04 (.I0(B[4]), .I1(A[4]), .O(AB4));
   XNOR2 I_36_05 (.I0(B[5]), .I1(A[5]), .O(AB5));
   XNOR2 I_36_06 (.I0(B[6]), .I1(A[6]), .O(AB6));
   XNOR2 I_36_07 (.I0(B[7]), .I1(A[7]), .O(AB7));
   XNOR2 I_36_08 (.I0(B[8]), .I1(A[8]), .O(AB8));
   XNOR2 I_36_09 (.I0(B[9]), .I1(A[9]), .O(AB9));
   XNOR2 I_36_10 (.I0(B[10]), .I1(A[10]), .O(AB10));
   XNOR2 I_36_11 (.I0(B[11]), .I1(A[11]), .O(AB11));
   XNOR2 I_36_12 (.I0(B[12]), .I1(A[12]), .O(AB12));
   XNOR2 I_36_13 (.I0(B[13]), .I1(A[13]), .O(AB13));
   XNOR2 I_36_14 (.I0(B[14]), .I1(A[14]), .O(AB14));
   XNOR2 I_36_15 (.I0(B[15]), .I1(A[15]), .O(AB15));
   XNOR2 I_36_16 (.I0(B[16]), .I1(A[16]), .O(AB16));
   XNOR2 I_36_17 (.I0(B[17]), .I1(A[17]), .O(AB17));
   XNOR2 I_36_18 (.I0(B[18]), .I1(A[18]), .O(AB18));
   XNOR2 I_36_19 (.I0(B[19]), .I1(A[19]), .O(AB19));
   XNOR2 I_36_20 (.I0(B[20]), .I1(A[20]), .O(AB20));
   XNOR2 I_36_21 (.I0(B[21]), .I1(A[21]), .O(AB21));
   XNOR2 I_36_22 (.I0(B[22]), .I1(A[22]), .O(AB22));
   XNOR2 I_36_23 (.I0(B[23]), .I1(A[23]), .O(AB23));
   XNOR2 I_36_24 (.I0(B[24]), .I1(A[24]), .O(AB24));
   XNOR2 I_36_25 (.I0(B[25]), .I1(A[25]), .O(AB25));
   XNOR2 I_36_26 (.I0(B[26]), .I1(A[26]), .O(AB26));
   XNOR2 I_36_27 (.I0(B[27]), .I1(A[27]), .O(AB27));
   XNOR2 I_36_28 (.I0(B[28]), .I1(A[28]), .O(AB28));
   XNOR2 I_36_29 (.I0(B[29]), .I1(A[29]), .O(AB29));
   XNOR2 I_36_30 (.I0(B[30]), .I1(A[30]), .O(AB30));
   XNOR2 I_36_31 (.I0(B[31]), .I1(A[31]), .O(AB31));
   
   AND4 I_36_40 (.I0(AB0), .I1(AB1), .I2(AB2), .I3(AB3), .O(AB07));
   AND4 I_36_41 (.I0(AB4), .I1(AB5), .I2(AB6), .I3(AB7), .O());
   AND4 I_36_42 (.I0(AB8), .I1(AB9), .I2(AB10), .I3(AB11), .O(AB815));
   AND4 I_36_43 (.I0(AB12), .I1(AB13), .I2(AB14), .I3(AB15), .O());
   AND4 I_36_44 (.I0(AB16), .I1(AB17), .I2(AB18), .I3(AB19), .O(AB1623));
   AND4 I_36_45 (.I0(AB20), .I1(AB21), .I2(AB22), .I3(AB23), .O());
   AND4 I_36_46 (.I0(AB24), .I1(AB25), .I2(AB26), .I3(AB27), .O(AB2431));
   AND4 I_36_47 (.I0(AB28), .I1(AB29), .I2(AB30), .I3(AB31), .O());
   
   AND4 I_36_50 (.I0(AB07), .I1(AB07), .I2(AB815), .I3(AB815), .O(AB015));
   AND4 I_36_51 (.I0(AB1623), .I1(AB1623), .I2(AB2431), .I3(AB2431), .O(AB1631));
   
   AND2 I_36_60 (.I0(AB015), .I1(AB1631), .O(EQ));
endmodule
