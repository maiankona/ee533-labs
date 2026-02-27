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

module alu_64bit(
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
            4'b0000: begin  // ADD
                Out0 = A0 + B0;
                Out1 = A1 + B1;
                Out2 = A2 + B2;
                Out3 = A3 + B3;
            end
            
            4'b0001: begin  // SUB
                Out0 = A0 - B0;
                Out1 = A1 - B1;
                Out2 = A2 - B2;
                Out3 = A3 - B3;
            end
            
            4'b0100: begin  // SLL (shift left)
                Out0 = A0 << shift;
                Out1 = A1 << shift;
                Out2 = A2 << shift;
                Out3 = A3 << shift;
            end
            
            4'b0101: begin  // SRL (shift right)
                Out0 = A0 >> shift;
                Out1 = A1 >> shift;
                Out2 = A2 >> shift;
                Out3 = A3 >> shift;
            end
            
            4'b0111: begin  // EQ (equal)
                Out0 = (A0 == B0) ? 16'd1 : 16'd0;
                Out1 = (A1 == B1) ? 16'd1 : 16'd0;
                Out2 = (A2 == B2) ? 16'd1 : 16'd0;
                Out3 = (A3 == B3) ? 16'd1 : 16'd0;
            end
            
            4'b1000: begin  // LT (less than)
                Out0 = (A0 < B0) ? 16'd1 : 16'd0;
                Out1 = (A1 < B1) ? 16'd1 : 16'd0;
                Out2 = (A2 < B2) ? 16'd1 : 16'd0;
                Out3 = (A3 < B3) ? 16'd1 : 16'd0;
            end
            
            4'b1001: begin  // GT (greater than)
                Out0 = (A0 > B0) ? 16'd1 : 16'd0;
                Out1 = (A1 > B1) ? 16'd1 : 16'd0;
                Out2 = (A2 > B2) ? 16'd1 : 16'd0;
                Out3 = (A3 > B3) ? 16'd1 : 16'd0;
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
    end

endmodule
