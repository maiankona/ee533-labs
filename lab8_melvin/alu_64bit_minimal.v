`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:31:27 03/04/2026 
// Design Name: 
// Module Name:    alu_64bit_minimal 
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
module alu_64bit_minimal (
    input  [63:0] A,      // 4×16-bit packed data
    input  [63:0] B,      // 4×16-bit packed data
    input  [3:0]  Op,
    output reg [63:0] Out
);
    // Unpack 4×16-bit lanes
    wire [15:0] A0 = A[15:0];
    wire [15:0] A1 = A[31:16];
    wire [15:0] A2 = A[47:32];
    wire [15:0] A3 = A[63:48];
    
    wire [15:0] B0 = B[15:0];
    wire [15:0] B1 = B[31:16];
    wire [15:0] B2 = B[47:32];
    wire [15:0] B3 = B[63:48];
    
    // Result registers
    reg [15:0] R0, R1, R2, R3;
    
    always @(*) begin
        case (Op)
            4'b0001: begin  // ADD (VADD_I16)
                R0 = A0 + B0;
                R1 = A1 + B1;
                R2 = A2 + B2;
                R3 = A3 + B3;
            end
            
            4'b0010: begin  // SUB (VSUB_I16)
                R0 = A0 - B0;
                R1 = A1 - B1;
                R2 = A2 - B2;
                R3 = A3 - B3;
            end
            
            4'b1000: begin  // MULT (VMUL_I16)
                R0 = A0 * B0;
                R1 = A1 * B1;
                R2 = A2 * B2;
                R3 = A3 * B3;
            end
            
            4'b1001: begin  // PASS
                R0 = B0;
                R1 = B1;
                R2 = B2;
                R3 = B3;
            end
            
            default: begin
                R0 = 16'd0;
                R1 = 16'd0;
                R2 = 16'd0;
                R3 = 16'd0;
            end
        endcase
        
        Out = {R3, R2, R1, R0};
    end
endmodule
