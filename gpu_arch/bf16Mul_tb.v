`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:27:39 02/26/2026
// Design Name:   bf16Mul
// Module Name:   C:/Documents and Settings/Melvin/My Documents/bf16Mult_tb.v
// Project Name:  lab7
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: bf16Mul
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
module bf16Mult_tb;
    // Inputs
    reg [15:0] oprA;
    reg [15:0] oprB;
    // Outputs
    wire [15:0] result;
    
    // Instantiate the Unit Under Test (UUT)
    bf16Mul uut (
        .oprA(oprA), 
        .oprB(oprB), 
        .result(result)
    );
    
    initial begin
        $monitor("time=%0t | oprA=%h oprB=%h | result=%h", $time, oprA, oprB, result);
        
        // 0 * 0 = 0
        oprA = 16'h0000; oprB = 16'h0000; #100;
        
        // 1.0 * 1.0 = 1.0
        oprA = 16'h3F80; oprB = 16'h3F80; #100;
        
        // 2.0 * 2.0 = 4.0
        oprA = 16'h4000; oprB = 16'h4000; #100;
        
        // 2.0 * 3.0 = 6.0
        oprA = 16'h4000; oprB = 16'h4040; #100;
        
        // -1.0 * 1.0 = -1.0
        oprA = 16'hBF80; oprB = 16'h3F80; #100;
        
        // -2.0 * -2.0 = 4.0
        oprA = 16'hC000; oprB = 16'hC000; #100;
        
        $stop;
    end
endmodule

/*
## BF16 Reference for the Test Cases

| Value | BF16 Hex | Breakdown |
|-------|----------|-----------|
| 1.0   | `3F80`   | 0 01111111 0000000 |
| 2.0   | `4000`   | 0 10000000 0000000 |
| 3.0   | `4040`   | 0 10000000 1000000 |
| 4.0   | `4080`   | 0 10000001 0000000 |
| 6.0   | `40C0`   | 0 10000001 1000000 |
| -1.0  | `BF80`   | 1 01111111 0000000 |
| -4.0  | `C080`   | 1 10000001 0000000 |

---

## Expected Output
```
time=0   | oprA=0000 oprB=0000 | result=????  // edge case, not handled
time=100 | oprA=3F80 oprB=3F80 | result=3F80  // 1.0
time=200 | oprA=4000 oprB=4000 | result=4080  // 4.0
time=300 | oprA=4000 oprB=4040 | result=40C0  // 6.0
time=400 | oprA=BF80 oprB=3F80 | result=BF80  // -1.0
time=500 | oprA=C000 oprB=C000 | result=4080  // 4.0

*/