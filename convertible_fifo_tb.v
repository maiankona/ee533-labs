`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:12:07 03/06/2026
// Design Name:   convertible_fifo
// Module Name:   C:/Xilinx/10.1/ISE/ISEexamples/lab7_tb_updated/convertible_fifo_tb.v
// Project Name:  lab7_tb_updated
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: convertible_fifo
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module convertible_fifo_tb;

	// Inputs
	reg clk;
	reg rst;
	reg ctrl_from_cpu;
	reg ctrl_from_nf;
	reg mode;
	reg [7:0] tail_addr;
	reg [7:0] sram_addr_write;
	reg [71:0] fifo_input;
	reg [71:0] sram_data_in;
	reg fifo_write_en;
	reg sram_write_en;
	reg [7:0] head_addr;
	reg [7:0] sram_addr_read;
	reg fifo_read_en;
	reg [7:0] sram_addr_read2;
	reg sram_read2_en;
	reg [7:0] sram_addr_write2;
	reg [71:0] sram_data_in2;
	reg sram_write2_en;

	// Outputs
	wire [71:0] sram_data_out;
	wire [71:0] fifo_output;
	wire [71:0] sram_data_out2;
	wire fifo_empty;
	wire fifo_full;
	wire [7:0] fifo_count;

	// Instantiate the Unit Under Test (UUT)
	convertible_fifo uut (
		.clk(clk), 
		.rst(rst), 
		.ctrl_from_cpu(ctrl_from_cpu), 
		.ctrl_from_nf(ctrl_from_nf), 
		.mode(mode), 
		.tail_addr(tail_addr), 
		.sram_addr_write(sram_addr_write), 
		.fifo_input(fifo_input), 
		.sram_data_in(sram_data_in), 
		.fifo_write_en(fifo_write_en), 
		.sram_write_en(sram_write_en), 
		.head_addr(head_addr), 
		.sram_addr_read(sram_addr_read), 
		.fifo_read_en(fifo_read_en), 
		.sram_data_out(sram_data_out), 
		.fifo_output(fifo_output), 
		.sram_addr_read2(sram_addr_read2), 
		.sram_read2_en(sram_read2_en), 
		.sram_data_out2(sram_data_out2), 
		.sram_addr_write2(sram_addr_write2), 
		.sram_data_in2(sram_data_in2), 
		.sram_write2_en(sram_write2_en), 
		.fifo_empty(fifo_empty), 
		.fifo_full(fifo_full), 
		.fifo_count(fifo_count)
	);

always #5 clk = ~clk;
	initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;  // ? FIX 1: Start with reset HIGH
        ctrl_from_cpu = 0;
        ctrl_from_nf = 0;
        mode = 0;
        tail_addr = 0;
        sram_addr_write = 0;
        fifo_input = 0;
        sram_data_in = 0;
        fifo_write_en = 0;
        sram_write_en = 0;
        head_addr = 0;
        sram_addr_read = 0;
        fifo_read_en = 0;
        sram_addr_read2 = 0;
        sram_read2_en = 0;
        sram_addr_write2 = 0;
        sram_data_in2 = 0;
        sram_write2_en = 0;

        // Wait 100 ns for global reset
        #100;
        rst = 0;  // ? FIX 2: Release reset
        
        $display("\n========================================");
        $display("CONVERTIBLE FIFO TESTBENCH");
        $display("========================================\n");
        
        // =====================================================
        // TEST 1: FIFO Mode
        // =====================================================
        $display("TEST 1: FIFO Mode");
        mode = 1;
        ctrl_from_cpu = 1;
        
        // Write to FIFO
        repeat(3) begin
            @(posedge clk);
            fifo_input = $random;
            fifo_write_en = 1;
            $display("  FIFO Write: 0x%h, count=%d", fifo_input, fifo_count);
        end
        
        @(posedge clk);
        fifo_write_en = 0;
        $display("  FIFO count: %d, empty=%b, full=%b\n", fifo_count, fifo_empty, fifo_full);
        
        // Read from FIFO - FIX 3: Add extra cycle for BRAM latency
        #20;
        fifo_read_en = 1;
        repeat(3) begin
            @(posedge clk);
            @(posedge clk);  // ? Wait for BRAM output register
            #1;
            $display("  FIFO Read: 0x%h, count=%d", fifo_output, fifo_count);
        end
        
        @(posedge clk);
        fifo_read_en = 0;
        $display("  FIFO empty: %b\n", fifo_empty);
        
        // =====================================================
        // TEST 2: SRAM Mode - Single Port
        // =====================================================
        #50;
        $display("TEST 2: SRAM Mode - Single Port Access");
        mode = 0;
        
        // Write to SRAM
        @(posedge clk);
        sram_addr_write = 8'h01;
        sram_data_in = 72'h0_40A0_40A0_40A0_40A0;  // 5.0 in BF16
        sram_write_en = 1;
        $display("  SRAM Write [0x%02h] = 0x%h", sram_addr_write, sram_data_in);
        
        @(posedge clk);
        sram_addr_write = 8'h29;
        sram_data_in = 72'h0_4000_4000_4000_4000;  // 2.0 in BF16
        $display("  SRAM Write [0x%02h] = 0x%h", sram_addr_write, sram_data_in);
        
        @(posedge clk);
        sram_write_en = 0;
        
        // Read from SRAM - FIX 4: Extra cycle for BRAM latency
        #20;
        sram_addr_read = 8'h01;
        @(posedge clk);  // Present address
        @(posedge clk);  // ? Wait for BRAM output register
        #1;
        $display("  SRAM Read [0x%02h] = 0x%h", sram_addr_read, sram_data_out);
        
        sram_addr_read = 8'h29;
        @(posedge clk);  // Present address
        @(posedge clk);  // ? Wait for BRAM output register
        #1;
        $display("  SRAM Read [0x%02h] = 0x%h\n", sram_addr_read, sram_data_out);
        
        // =====================================================
        // TEST 3: SRAM Mode - Dual Port (2nd address)
        // =====================================================
        #50;
        $display("TEST 3: SRAM Mode - Dual Port Access");
        
        // Read from 2nd port
        sram_addr_read2 = 8'h01;
        sram_read2_en = 1;
        @(posedge clk);
        @(posedge clk);  // ? Wait for BRAM output register
        #1;
        $display("  SRAM Read2 [0x%02h] = 0x%h", sram_addr_read2, sram_data_out2);
        
        sram_read2_en = 0;
        
        // =====================================================
        // TEST 4: SRAM Mode - Dual Write
        // =====================================================
        #50;
        $display("TEST 4: SRAM Mode - Dual Write Port");
        
        @(posedge clk);
        sram_addr_write2 = 8'h51;
        sram_data_in2 = 72'h0_4120_4120_4120_4120;  // 10.0 in BF16
        sram_write2_en = 1;
        $display("  SRAM Write2 [0x%02h] = 0x%h", sram_addr_write2, sram_data_in2);
        
        @(posedge clk);
        sram_write2_en = 0;
        
        // Verify - FIX 5: Extra cycle for BRAM latency
        #20;
        sram_addr_read = 8'h51;
        @(posedge clk);  // Present address
        @(posedge clk);  // ? Wait for BRAM output register
        #1;
        $display("  SRAM Read [0x%02h] = 0x%h", sram_addr_read, sram_data_out);
        
        #100;
        $display("\n========================================");
        $display("ALL TESTS COMPLETE");
        $display("========================================\n");
        
        $stop;	end
      
endmodule

