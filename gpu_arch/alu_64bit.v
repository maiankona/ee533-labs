`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:29:37 02/20/2026 
// Design Name: 
// Module Name:    alu_32bit 
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

// NEED 4 bfloat 16 parallel operations for SIMD
// [15]    [14:7]  [6:0]
// Sign    Exp(8)  Mantissa(7)

module alu_64bit(
	input [63:0] A,
    input [63:0] B,
	input [63:0] C,
    input [3:0] Op,
    input [4:0] shift,
    output reg [63:0] Out
);
	// unpack bfloat16 inputs for A B and C
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

	// simd outputs for 4 threads
	reg [15:0] out0, out1, out2, out3;

	// IP cores for bfloat16 operations
    wire [15:0] addsub_out0, addsub_out1, addsub_out2, addsub_out3;
    wire [15:0] mul_out0, mul_out1, mul_out2, mul_out3;
    wire addsub_rdy, mul_rdy;
    
    // Operation select for add/sub
    wire add_sub_sel = (Op == 3'b001);  // 0=ADD, 1=SUB
    
    // ========================================
    // 4 ADD/SUB units (one per lane)
    // ========================================
    bf16_addsub addsub0 (
        .a(A0),
        .b(B0),
        .operation(add_sub_sel), 
        .clk(clk),
        .result(addsub_out0),
        .rdy(addsub_rdy)
    );
    
    bf16_addsub addsub1 (
        .a(A1),
        .b(B1),
        .operation(add_sub_sel),
        .clk(clk),
        .result(addsub_out1)
    );
    
    bf16_addsub addsub2 (
        .a(A2),
        .b(B2),
        .operation(add_sub_sel),
        .clk(clk),
        .result(addsub_out2)
    );
    
    bf16_addsub addsub3 (
        .a(A3),
        .b(B3),
        .operation(add_sub_sel),
        .clk(clk),
        .result(addsub_out3)
    );
    
    // ========================================
    // 4 MULTIPLY units
    // ========================================
    bf16_mul mul0 (
        .a(A0),
        .b(B0),
        .clk(clk),
        .result(mul_out0),
        .rdy(mul_rdy)
    );
    
    bf16_mul mul1 (
        .a(A1),
        .b(B1),
        .clk(clk),
        .result(mul_out1)
    );
    
    bf16_mul mul2 (
        .a(A2),
        .b(B2),
        .clk(clk),
        .result(mul_out2)
    );
    
    bf16_mul mul3 (
        .a(A3),
        .b(B3),
        .clk(clk),
        .result(mul_out3)
    );
    
    // ========================================
    // PIPELINE DELAY TRACKING
    // ========================================
    reg [2:0] op_pipe[0:7];  // Track operation through pipeline
    integer i;
    
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 8; i = i + 1)
                op_pipe[i] <= 3'b111;
            out_valid <= 0;
            Out <= 64'h0;
        end
        else begin
            // Shift operation code through pipeline
            op_pipe[0] <= op_start ? Op : 3'b111;
            for (i = 1; i < 8; i = i + 1)
                op_pipe[i] <= op_pipe[i-1];
            
            // Default
            out_valid <= 0;
            
            // ADD/SUB result (assume 4-cycle latency)
            if (op_pipe[4] == 3'b000 || op_pipe[4] == 3'b001) begin
                Out <= {addsub_out3, addsub_out2, addsub_out1, addsub_out0};
                out_valid <= 1;
            end
            
            // MUL result (assume 5-cycle latency)
            if (op_pipe[5] == 3'b010) begin
                Out <= {mul_out3, mul_out2, mul_out1, mul_out0};
                out_valid <= 1;
            end
            
            // ========================================
            // SIMPLE OPS (No latency - combinational)
            // ========================================
            if (op_start) begin
                case (Op)
                    3'b011: begin  // ReLU: max(0, A)
                        Out <= {
                            A3[15] ? 16'h0 : A3,  // Negative? → 0
                            A2[15] ? 16'h0 : A2,
                            A1[15] ? 16'h0 : A1,
                            A0[15] ? 16'h0 : A0
                        };
                        out_valid <= 1;
                    end
                    
                    3'b100: begin  // ABS: clear sign bit
                        Out <= {
                            {1'b0, A3[14:0]},
                            {1'b0, A2[14:0]},
                            {1'b0, A1[14:0]},
                            {1'b0, A0[14:0]}
                        };
                        out_valid <= 1;
                    end
                    
                    3'b101: begin  // NEG: flip sign bit
                        Out <= {
                            {~A3[15], A3[14:0]},
                            {~A2[15], A2[14:0]},
                            {~A1[15], A1[14:0]},
                            {~A0[15], A0[14:0]}
                        };
                        out_valid <= 1;
                    end
                endcase
            end
        end
    end

endmodule
	
   /* always @(*) begin
        case (Op)
            4'b0000: Out = A + B; 
            4'b0001: Out = A - B; 
            4'b0010: Out = A & B; 
            4'b0011: Out = A | B; 
            4'b0100: Out = A << shift; 
            4'b0101: Out = A >> shift; 
            4'b0110: Out = ~(A ^ B); 
			4'b0111: Out = (A == B) ? 64'h1 : 64'h0; 
			4'b1000: Out = (A < B) ? 64'h1 : 64'h0; 
			4'b1001: Out = (A > B) ? 64'h1 : 64'h0; 
            4'b1010: Out = A ^ B; 
			4'b1011: Out = ((A << shift) == B) ? 64'h1 : 64'h0; 
			4'b1100: Out = (A[7:0] == B[7:0]) ? 64'h1 : 64'h0; 
			4'b1101: Out = B - A; 
			4'b1110: Out = ~B; 
            default: Out = 64'b0;
        endcase
    end

endmodule */
