`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module: tensor_unit
// Description: BFloat16 SIMD tensor operations (4-wide)
// Operations: ADD, SUB, MUL, FMA (C + A*B), ReLU
//////////////////////////////////////////////////////////////////////////////////

module tensor_unit(
    input clk,
    input rst,
    input [63:0] A,        // 4×BF16 packed
    input [63:0] B,        // 4×BF16 packed
    input [63:0] C,        // 4×BF16 packed (for FMA accumulator)
    input [2:0] Op,        // 3 bits for 5 operations
    input op_start,        // Start operation
    output reg [63:0] Out,
    output reg out_valid   // Result ready
);

    // ========================================
    // UNPACK 4×BF16 elements
    // ========================================
    wire [15:0] A0 = A[15:0];
    wire [15:0] A1 = A[31:16];
    wire [15:0] A2 = A[47:32];
    wire [15:0] A3 = A[63:48];
    
    wire [15:0] B0 = B[15:0];
    wire [15:0] B1 = B[31:16];
    wire [15:0] B2 = B[47:32];
    wire [15:0] B3 = B[63:48];
    
    wire [15:0] C0 = C[15:0];
    wire [15:0] C1 = C[31:16];
    wire [15:0] C2 = C[47:32];
    wire [15:0] C3 = C[63:48];
    
    // ========================================
    // IP CORE OUTPUTS (4 parallel lanes)
    // ========================================
    wire [15:0] add_out0, add_out1, add_out2, add_out3;
    wire [15:0] sub_out0, sub_out1, sub_out2, sub_out3;
    wire [15:0] mul_out0, mul_out1, mul_out2, mul_out3;
    wire [15:0] fma_out0, fma_out1, fma_out2, fma_out3;
    
    wire add_sub_sel;
    
    // ========================================
    // LANE 0: ADD/SUB (operation=0 for ADD, 1 for SUB)
    // ========================================
    assign add_sub_sel = (Op == 3'b001);  // SUB if Op=001, else ADD
    
    bf16_adder lane0_addsub (
        .a(A0),
        .b(B0),
        .operation(add_sub_sel),
        .clk(clk),
        .result(add_out0)  // Also serves as sub_out0
    );
    
    bf16_adder lane1_addsub (
        .a(A1),
        .b(B1),
        .operation(add_sub_sel),
        .clk(clk),
        .result(add_out1)
    );
    
    bf16_adder lane2_addsub (
        .a(A2),
        .b(B2),
        .operation(add_sub_sel),
        .clk(clk),
        .result(add_out2)
    );
    
    bf16_adder lane3_addsub (
        .a(A3),
        .b(B3),
        .operation(add_sub_sel),
        .clk(clk),
        .result(add_out3)
    );
    
    // ========================================
    // LANE 0-3: MULTIPLY need to create this still
    // ========================================
    bf16_mul lane0_mul (
        .a(A0),
        .b(B0),
        .clk(clk),
        .result(mul_out0)
    );
    
    bf16_mul lane1_mul (
        .a(A1),
        .b(B1),
        .clk(clk),
        .result(mul_out1)
    );
    
    bf16_mul lane2_mul (
        .a(A2),
        .b(B2),
        .clk(clk),
        .result(mul_out2)
    );
    
    bf16_mul lane3_mul (
        .a(A3),
        .b(B3),
        .clk(clk),
        .result(mul_out3)
    );
    
    // ========================================
    // LANE 0-3: MAC (C + A*B) - Two-stage
    // Stage 1: Multiply A*B
    // Stage 2: Add result to C
    // ========================================
    wire [15:0] mul_temp0, mul_temp1, mul_temp2, mul_temp3;
    
    // First multiply A*B
    bf16_mul lane0_fma_mul (
        .a(A0),
        .b(B0),
        .clk(clk),
        .result(mul_temp0)
    );
    
    bf16_mul lane1_fma_mul (
        .a(A1),
        .b(B1),
        .clk(clk),
        .result(mul_temp1)
    );
    
    bf16_mul lane2_fma_mul (
        .a(A2),
        .b(B2),
        .clk(clk),
        .result(mul_temp2)
    );
    
    bf16_mul lane3_fma_mul (
        .a(A3),
        .b(B3),
        .clk(clk),
        .result(mul_temp3)
    );
    
    // Then add C + (A*B)
    bf16_adder lane0_fma_add (
        .a(C0),
        .b(mul_temp0),
        .operation(1'b0),  // ADD
        .clk(clk),
        .result(fma_out0)
    );
    
    bf16_adder lane1_fma_add (
        .a(C1),
        .b(mul_temp1),
        .operation(1'b0),
        .clk(clk),
        .result(fma_out1)
    );
    
    bf16_adder lane2_fma_add (
        .a(C2),
        .b(mul_temp2),
        .operation(1'b0),
        .clk(clk),
        .result(fma_out2)
    );
    
    bf16_adder lane3_fma_add (
        .a(C3),
        .b(mul_temp3),
        .operation(1'b0),
        .clk(clk),
        .result(fma_out3)
    );
    
    // ========================================
    // PIPELINE DELAY TRACKING
    // ========================================
	reg [2:0] op_pipe[0:11];  // Track up to 12 cycles (MAC needs ~9-10)
    integer i;
    
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 12; i = i + 1)
                op_pipe[i] <= 3'b111;
            out_valid <= 0;
            Out <= 64'h0;
        end
        else begin
            // Shift operation through pipeline
            op_pipe[0] <= op_start ? Op : 3'b111;
            for (i = 1; i < 12; i = i + 1)
                op_pipe[i] <= op_pipe[i-1];
            
            // Output MUX based on operation latency
            if (op_pipe[4] == 3'b000 || op_pipe[4] == 3'b001) begin
                // ADD/SUB (latency ~4)
                Out <= {add_out3, add_out2, add_out1, add_out0};
                out_valid <= 1;
            end
            else if (op_pipe[5] == 3'b010) begin
                // MUL (latency ~5)
                Out <= {mul_out3, mul_out2, mul_out1, mul_out0};
                out_valid <= 1;
            end
            else if (op_pipe[10] == 3'b011) begin
                // MAC (latency ~9-10: MUL + ADD)
                Out <= {fma_out3, fma_out2, fma_out1, fma_out0};
                out_valid <= 1;
            end
            else if (op_start && Op == 3'b100) begin
                // ReLU (latency 0 - just check sign bit)
                Out <= {
                    A3[15] ? 16'h0 : A3,  // Negative? → 0
                    A2[15] ? 16'h0 : A2,
                    A1[15] ? 16'h0 : A1,
                    A0[15] ? 16'h0 : A0
                };
                out_valid <= 1;
            end
            else begin
                out_valid <= 0;
            end
        end
    end

endmodule
