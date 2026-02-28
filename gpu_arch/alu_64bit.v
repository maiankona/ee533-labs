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

/*module alu_64bit(
	input [63:0] A,
    input [63:0] B,
	input [3:0] Op,
	input [5:0] shift,
    output reg [63:0] Out
);
	// updated w/ minimum arithmetic/logical operators for GPU
	wire signed [15:0] A0, A1, A2, A3, B0, B1, B2, B3;
	reg signed [15:0] Out0, Out1, Out2, Out3;
	
	assign A0 = A[15:0];
	assign A1 = A[31:16];
	assign A2 = A[47:32];
	assign A3 = A[63:48];
	assign B0 = B[15:0];
	assign B1 = B[31:16];
	assign B2 = B[47:32];
	assign B3 = B[63:48];
	
   always @(*) begin
        case (Op)
            4'b0001: begin  // ADD
                Out0 = A0 + B0;
                Out1 = A1 + B1;
                Out2 = A2 + B2;
                Out3 = A3 + B3;
            end
            
            4'b0010: begin  // SUB
                Out0 = A0 - B0;
                Out1 = A1 - B1;
                Out2 = A2 - B2;
                Out3 = A3 - B3;
            end
            
            4'b0011: begin  // SLL (shift left)
                Out0 = A0 << shift;
                Out1 = A1 << shift;
                Out2 = A2 << shift;
                Out3 = A3 << shift;
            end
            
            4'b0100: begin  // SRL (shift right)
                Out0 = A0 >> shift;
                Out1 = A1 >> shift;
                Out2 = A2 >> shift;
                Out3 = A3 >> shift;
            end
            
            4'b0101: begin  // EQ (equal)
                Out0 = (A0 == B0) ? 16'd1 : 16'd0;
                Out1 = (A1 == B1) ? 16'd1 : 16'd0;
                Out2 = (A2 == B2) ? 16'd1 : 16'd0;
                Out3 = (A3 == B3) ? 16'd1 : 16'd0;
            end
            
            4'b0110: begin  // LT (less than)
                Out0 = (A0 < B0) ? 16'd1 : 16'd0;
                Out1 = (A1 < B1) ? 16'd1 : 16'd0;
                Out2 = (A2 < B2) ? 16'd1 : 16'd0;
                Out3 = (A3 < B3) ? 16'd1 : 16'd0;
            end
            
            4'b0111: begin  // GT (greater than)
                Out0 = (A0 > B0) ? 16'd1 : 16'd0;
                Out1 = (A1 > B1) ? 16'd1 : 16'd0;
                Out2 = (A2 > B2) ? 16'd1 : 16'd0;
                Out3 = (A3 > B3) ? 16'd1 : 16'd0;
            end

            4'b1000: begin  // MULT
                Out0 = A0 * B0;
                Out1 = A1 * B1;
                Out2 = A2 * B2;
                Out3 = A3 * B3;
            end

            4'b1001: begin  // PASS (for MOV)
                Out0 = B0;
                Out1 = B1;
                Out2 = B2;
                Out3 = B3;
            end
            
            default: begin
                Out0 = 16'd0;
                Out1 = 16'd0;
                Out2 = 16'd0;
                Out3 = 16'd0;
            end
        endcase
        
        // Pack back to 64 bits
        Out = {Out3, Out2, Out1, Out0};
    end */
	module alu_64bit (
    input  [63:0] A,
    input  [63:0] B,
    input  [3:0]  Op,
	input [5:0] shift,
	input  [1:0]  width,   // 00=16, 01=32, 10=64
    output reg [63:0] Out
);

    // ----------------------------------------
    // 16-bit lanes (4x16 SIMD)
    // ----------------------------------------
    wire signed [15:0] A16 [3:0];
    wire signed [15:0] B16 [3:0];

    assign A16[0] = A[15:0];
    assign A16[1] = A[31:16];
    assign A16[2] = A[47:32];
    assign A16[3] = A[63:48];

    assign B16[0] = B[15:0];
    assign B16[1] = B[31:16];
    assign B16[2] = B[47:32];
    assign B16[3] = B[63:48];

    // ----------------------------------------
    // 32-bit lanes (2x32 SIMD)
    // ----------------------------------------
    wire signed [31:0] A32_lo = A[31:0];
    wire signed [31:0] A32_hi = A[63:32];
    wire signed [31:0] B32_lo = B[31:0];
    wire signed [31:0] B32_hi = B[63:32];

    // ----------------------------------------
    // 64-bit scalar
    // ----------------------------------------
    wire signed [63:0] A64 = A;
    wire signed [63:0] B64 = B;

    integer i;
    reg signed [15:0] result16 [3:0];
    reg signed [31:0] result32_lo, result32_hi;
    reg signed [63:0] result64;

    always @(*) begin

        // defaults
        Out = 64'd0;

        case (width)

        // ================================
        // 16-bit SIMD
        // ================================
        2'b00: begin
            for (i=0; i<4; i=i+1) begin
                case (Op)
                    4'b0001: result16[i] = A16[i] + B16[i]; // ADD
                    4'b0010: result16[i] = A16[i] - B16[i]; // SUB
					4'b0011: result16[i] = A16[i] << shift; // SHL
					4'b0100: result16[i] = A16[i] >> shift; // SHR
					4'b0101: result16[i] = (A16[i] == B16[i]) ? 16'd1 : 16'd0; // EQ
					4'b0110: result16[i] = (A16[i] < B16[i]) ? 16'd1 : 16'd0; // LT
					4'b0111: result16[i] = (A16[i] > B16[i]) ? 16'd1 : 16'd0; // GT
					4'b1000: result16[i] = A16[i] * B16[i]; // MULT
					4'b1001: result16[i] = B16[i]; // PASS
                    default: result16[i] = 16'd0;
                endcase
            end

            Out = {result16[3], result16[2], result16[1], result16[0]};
        end

        // ================================
        // 32-bit SIMD
        // ================================
        2'b01: begin
            case (Op)
                4'b0001: begin // ADD
                    result32_lo = A32_lo + B32_lo;
                    result32_hi = A32_hi + B32_hi;
                end
                4'b0010: begin // SUB
                    result32_lo = A32_lo - B32_lo;
                    result32_hi = A32_hi - B32_hi;
                end
                4'b0011: begin // SHL
                    result32_lo = A32_lo <<< shift;
                    result32_hi = A32_hi <<< shift;
                end
				4'b0100: begin // SHR
                    result32_lo = A32_lo >>> shift;
                    result32_hi = A32_hi >>> shift;
                end

				4'b0101: begin // EQ
					result32_lo = (A32_lo == B32_lo) ? 32'd1 : 32'd0;
					result32_hi = (A32_hi == B32_hi) ? 32'd1 : 32'd0;
				end
				4'b0110: begin // LT 
					result32_lo = (A32_lo < B32_lo) ? 32'd1 : 32'd0;
					result32_hi = (A32_hi < B32_hi) ? 32'd1 : 32'd0;
				end
				4'b0111: begin // GT
					result32_lo = (A32_lo > B32_lo) ? 32'd1 : 32'd0;
					result32_hi = (A32_hi > B32_hi) ? 32'd1 : 32'd0;
				end
				4'b1000: begin // MULT
					result32_lo = A32_lo * B32_lo;
					result32_hi = A32_hi * B32_hi;
				end
				4'b1001: begin // PASS
					result32_lo = B32_lo;
					result32_hi = B32_hi;
				end
				4'b1010: begin // CVT (extend 32 to 64)
					result32_lo = A32_lo;
					result32_hi = {32{A32_lo[31]}};
				default: begin
                    result32_lo = 32'd0;
                    result32_hi = 32'd0;
                end
            endcase

            Out = {result32_hi, result32_lo};
        end

        // ================================
        // 64-bit scalar
        // ================================
        2'b10: begin
            case (Op)
                4'b0001: result64 = A64 + B64;  // ADD (address)
                4'b0010: result64 = A64 - B64;  // SUB
                4'b0011: result64 = A64 <<< shift; // SHL
                4'b0100: result64 = A64 >>> shift; // SHR
				4'b0101: result64 = (A64 == B64) ? 64'd1 : 64'd0; // EQ
				4'b0110: result64 = (A64 < B64) ? 64'd1 : 64'd0; // LT
				4'b0111: result64 = (A64 > B64) ? 64'd1 : 64'd0; // GT
				4'b1000: result64 = A64 * B64; // MULT
				4'b1001: result64 = B64; // PASS
                default: result64 = 64'd0;
            endcase

            Out = result64;
        end

        default: Out = 64'd0;

        endcase
    end
endmodule
