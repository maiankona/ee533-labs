// Verilog test fixture created from schematic C:\Xilinx\10.1\ISE\ISEexamples\ee533-lab5\registerFile32.sch - Thu Feb 12 15:01:37 2026

`timescale 1ns / 1ps

module registerFile32_tb();

// inputs
   reg clk;
	reg clr;
   reg wena;
   reg [1:0] waddr;
   reg [1:0] r0addr;
   reg [1:0] r1addr;
   reg [31:0] wdata;

// outputs
   wire [31:0] r0data;
   wire [31:0] r1data;

// instatiation
   registerFile32 UUT (
		.r0data(r0data), 
		.r1data(r1data), 
		.clk(clk),
		.clr(clr),
		.wena(wena), 
		.waddr(waddr), 
		.r0addr(r0addr), 
		.r1addr(r1addr), 
		.wdata(wdata)
   );

   `ifdef auto_init
       initial begin
		clk = 0;
		clr = 0;
		wena = 0;
		waddr = 0;
		r0addr = 0;
		r1addr = 0;
		wdata = 0;
   `endif
	
// Testing
    
    always #5 clk = ~clk;
    
//    initial begin
//        clk = 0; wena = 0; clr = 1;
//        waddr = 2'b00; r0addr = 2'b00; r1addr = 2'b00; wdata = 0;
//        #10; clr = 0;
//        
//        // write to R0
//        wena = 0; waddr = 2'b00; wdata = 32'hAAAAAAAA;
//        #10;
//        
//        // write to R1
//        waddr = 2'b01; wdata = 32'hBBBBBBBB;
//        #10;
//        
//        // write to R2
//        waddr = 2'b10; wdata = 32'hCCCCCCCC;
//        #10;
//        
//        // write to R3
//        waddr = 2'b11; wdata = 32'hDDDDDDDD;
//        #10;
//        
//        // stop writing
//        wena = 1;
//        #10;
//        
//        // read R0 and R1
//        r0addr = 2'b00; r1addr = 2'b01;
//        #10;
//        
//        // read R2 and R3
//        r0addr = 2'b10; r1addr = 2'b11;
//        #10;
//        
//        $finish;
//    end
initial begin
    clk = 0; clr = 1; wena = 1;
    #10 clr = 0;
    
    // Write 0xFFFFFFFF to R0
    #10;
    wena = 0;
    waddr = 2'b00;
    wdata = 32'hFFFFFFFF;
    #50;  // Hold for 5 clock cycles
    
    wena = 1;
    #20;
    
    // Try to read R0
    r0addr = 2'b00;
    #20;
    
    $finish;
end
endmodule
