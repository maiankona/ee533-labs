`timescale 1ns / 1ps

module bf16_tensor (
    input clk,
    input [5:0] opcode,

    // packed 64-bit operands (4x BF16 lanes each)
    input [63:0] r1data,
    input [63:0] r2data,
    input [63:0] rd_data,   // for VMAC accumulate

    output [63:0] tensor_out,
    output tensor_done
);

// unpack 64-bit data from r1 and r2 outputs into BF16 segments
wire [15:0] r1_lane0 = r1data[15:0];
wire [15:0] r1_lane1 = r1data[31:16];
wire [15:0] r1_lane2 = r1data[47:32];
wire [15:0] r1_lane3 = r1data[63:48];

wire [15:0] r2_lane0 = r2data[15:0];
wire [15:0] r2_lane1 = r2data[31:16];
wire [15:0] r2_lane2 = r2data[47:32];
wire [15:0] r2_lane3 = r2data[63:48];

wire [15:0] rd_lane0 = rd_data[15:0];
wire [15:0] rd_lane1 = rd_data[31:16];
wire [15:0] rd_lane2 = rd_data[47:32];
wire [15:0] rd_lane3 = rd_data[63:48];

// multiplied outputs
wire [15:0] mul_lane0, mul_lane1, mul_lane2, mul_lane3;

bf16Mul mul_lane0_unit (.oprA(r1_lane0), .oprB(r2_lane0), .result(mul_lane0));
bf16Mul mul_lane1_unit (.oprA(r1_lane1), .oprB(r2_lane1), .result(mul_lane1));
bf16Mul mul_lane2_unit (.oprA(r1_lane2), .oprB(r2_lane2), .result(mul_lane2));
bf16Mul mul_lane3_unit (.oprA(r1_lane3), .oprB(r2_lane3), .result(mul_lane3));

wire is_vadd  = (opcode == 6'h06);
wire is_vsub  = (opcode == 6'h07);
wire is_vmul  = (opcode == 6'h08);
wire is_vmac  = (opcode == 6'h09);
wire is_vrelu = (opcode == 6'h0A);

wire [5:0] add_sub_op = is_vsub ? 6'b000001 : 6'b000000;

// a_lane: r1 for VADD/VSUB, multiply result for VMUL/VMAC, zero otherwise (NOP/bubble)
wire [15:0] a_lane0 = (is_vadd | is_vsub) ? r1_lane0 : (is_vmul | is_vmac) ? mul_lane0 : 16'h0000;
wire [15:0] a_lane1 = (is_vadd | is_vsub) ? r1_lane1 : (is_vmul | is_vmac) ? mul_lane1 : 16'h0000;
wire [15:0] a_lane2 = (is_vadd | is_vsub) ? r1_lane2 : (is_vmul | is_vmac) ? mul_lane2 : 16'h0000;
wire [15:0] a_lane3 = (is_vadd | is_vsub) ? r1_lane3 : (is_vmul | is_vmac) ? mul_lane3 : 16'h0000;

// b_lane: accumulator for VMAC, r2 for VADD/VSUB, zero for VMUL and default (NOP/bubble)
wire [15:0] b_lane0 = is_vmac ? rd_lane0 : (is_vadd | is_vsub) ? r2_lane0 : 16'h0000;
wire [15:0] b_lane1 = is_vmac ? rd_lane1 : (is_vadd | is_vsub) ? r2_lane1 : 16'h0000;
wire [15:0] b_lane2 = is_vmac ? rd_lane2 : (is_vadd | is_vsub) ? r2_lane2 : 16'h0000;
wire [15:0] b_lane3 = is_vmac ? rd_lane3 : (is_vadd | is_vsub) ? r2_lane3 : 16'h0000;

// Adder / Subtractor - clk connection required (lab7 working version)
wire [15:0] add_out0, add_out1, add_out2, add_out3;
bf16_add add_lane0 (.clk(clk), .operation(add_sub_op), .a(a_lane0), .b(b_lane0), .result(add_out0));
bf16_add add_lane1 (.clk(clk), .operation(add_sub_op), .a(a_lane1), .b(b_lane1), .result(add_out1));
bf16_add add_lane2 (.clk(clk), .operation(add_sub_op), .a(a_lane2), .b(b_lane2), .result(add_out2));
bf16_add add_lane3 (.clk(clk), .operation(add_sub_op), .a(a_lane3), .b(b_lane3), .result(add_out3));

// RELU
wire [15:0] relu_l0 = r1_lane0[15] ? 16'h0000 : r1_lane0;
wire [15:0] relu_l1 = r1_lane1[15] ? 16'h0000 : r1_lane1;
wire [15:0] relu_l2 = r1_lane2[15] ? 16'h0000 : r1_lane2;
wire [15:0] relu_l3 = r1_lane3[15] ? 16'h0000 : r1_lane3;

// Output mux - VMUL bypasses add (mul is combinational); VADD/VSUB/VMAC/VRELU use add
wire [15:0] out_l0 = is_vrelu ? relu_l0 : (is_vmul ? mul_lane0 : add_out0);
wire [15:0] out_l1 = is_vrelu ? relu_l1 : (is_vmul ? mul_lane1 : add_out1);
wire [15:0] out_l2 = is_vrelu ? relu_l2 : (is_vmul ? mul_lane2 : add_out2);
wire [15:0] out_l3 = is_vrelu ? relu_l3 : (is_vmul ? mul_lane3 : add_out3);

assign tensor_done = (is_vadd | is_vsub | is_vmul | is_vmac | is_vrelu);
assign tensor_out  = {out_l3, out_l2, out_l1, out_l0};

endmodule
