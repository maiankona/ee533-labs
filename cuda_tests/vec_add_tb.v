`timescale 1ns / 1ps

module vec_add_tb;

	// Inputs
	reg clk;
	reg rst;
	reg write_to_imem;
	reg write_to_dmem;
	reg [8:0] addr_imem_host;
	reg [31:0] data_imem_host;
	reg [7:0] addr_dmem_host;
	reg [63:0] data_dmem_host;
	reg read_req_dmem;

	// Outputs
	wire [63:0] data_out_dmem;
	wire [63:0] tensor_result;

	// Instantiate the Unit Under Test (UUT)
	pipeline_backup uut (
		.clk(clk),
		.rst(rst),
		.write_to_imem(write_to_imem),
		.write_to_dmem(write_to_dmem),
		.addr_imem_host(addr_imem_host),
		.data_imem_host(data_imem_host),
		.addr_dmem_host(addr_dmem_host),
		.data_dmem_host(data_dmem_host),
		.read_req_dmem(read_req_dmem),
		.data_out_dmem(data_out_dmem),
		.tensor_result(tensor_result)
	);
	
	always #5 clk = ~clk;   // 10ns clock

// ------------------------------------------------------------
// TASK: Load Instruction into IMEM (with print)
// ------------------------------------------------------------
task load_imem;
input [8:0] addr;
input [31:0] instr;
begin
    @(posedge clk);
    write_to_imem = 1;
    addr_imem_host = addr;
    data_imem_host = instr;
    $display("[IMEM LOAD] addr=0x%03h  instr=0x%08h  time=%0t", addr, instr, $time);
    @(posedge clk);
    write_to_imem = 0;
end
endtask

// ------------------------------------------------------------
// TASK: Load Data into DMEM (with print)
// ------------------------------------------------------------
task load_dmem;
input [7:0] addr;
input [63:0] data;
begin
    @(posedge clk);
    write_to_dmem = 1;
    addr_dmem_host = addr;
    data_dmem_host = data;
    $display("[DMEM LOAD] addr=0x%02h  data=0x%016h (%0d decimal)  time=%0t", 
             addr, data, data, $time);
    @(posedge clk);
    write_to_dmem = 0;
end
endtask

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		write_to_imem = 0;
		write_to_dmem = 0;
		addr_imem_host = 0;
		data_imem_host = 0;
		addr_dmem_host = 0;
		data_dmem_host = 0;
		read_req_dmem = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
// ------------------------------------------------------------
// TEST SEQUENCE
// ------------------------------------------------------------

    $display("\n========================================");
    $display("VECTOR ADD TESTBENCH - STARTING");
    $display("========================================\n");

    clk = 0;
    rst = 1;
    write_to_imem = 0;
    write_to_dmem = 0;
    read_req_dmem = 0;

    #20;
    rst = 0;
    $display("[RESET] Released at time=%0t\n", $time);
	 
	 // =====================================================
    // 2. Load Data into DMEM
    // =====================================================
    $display("========================================");
    $display("LOADING DATA TO DMEM");
    $display("========================================");

    load_dmem(8'h01, 64'd10);   // A[0] = 10
    load_dmem(8'h29, 64'd20);   // B[0] = 20

    $display("\n========================================");
    $display("DATA LOAD COMPLETE");
    $display("A_base = 0x01, value = 10");
    $display("B_base = 0x29, value = 20");
    $display("C_base = 0x51 (result location)");
    $display("========================================\n");

    // =====================================================
    // 1. Load Instructions into IMEM
    // =====================================================
    $display("========================================");
    $display("LOADING INSTRUCTIONS TO IMEM");
    $display("========================================");

    load_imem(9'd0,  32'h64C00006);  // MOVI r6, 1   (A_base = 0x01)
    load_imem(9'd1,  32'h64A000A6);  // MOVI r5, 41  (B_base = 0x29)
    load_imem(9'd2,  32'h64800146);  // MOVI r4, 81  (C_base = 0x51)
    load_imem(9'd3,  32'h64E00006);  // MOVI r7, 1
    load_imem(9'd4,  32'h48260001);  // LD r1, [r6]
    load_imem(9'd5,  32'h00000000);  // NOP
    load_imem(9'd6,  32'h00000000);  // NOP
    load_imem(9'd7,  32'h00000000);  // NOP
    load_imem(9'd8,  32'h48450001);  // LD r2, [r5]
    load_imem(9'd9,  32'h00000000);  // NOP
    load_imem(9'd10, 32'h00000000);  // NOP
    load_imem(9'd11, 32'h00000000);  // NOP
    load_imem(9'd12, 32'h04620801);  // ADD r3, r2, r1
	 load_imem(9'd13, 32'h00000000);  // NOP
    load_imem(9'd14, 32'h4C640001);  // ST [r4], r3
    load_imem(9'd15, 32'h2C000000);  // HALT

    $display("\n========================================");
    $display("INSTRUCTION LOAD COMPLETE");
    $display("Total instructions loaded: 15");
    $display("========================================\n");
		  
    

    // =====================================================
    // 3. Run Pipeline
    // =====================================================
    $display("========================================");
    $display("STARTING PIPELINE EXECUTION");
    $display("========================================\n");

    repeat(40) begin
        @(posedge clk);
        // Print PC and current instruction being fetched
        $display("[CYCLE %0d] PC=%0d  time=%0t", 
                 ($time-120)/10, uut.IF.pc, $time);
    end

    // =====================================================
    // 4. Read Result from DMEM
    // =====================================================
    $display("\n========================================");
    $display("READING RESULT FROM DMEM");
    $display("========================================");

    @(posedge clk);
    read_req_dmem = 1;
    addr_dmem_host = 8'h51;
    $display("[DMEM READ] Requesting addr=0x51  time=%0t", $time);
    
    @(posedge clk);
    read_req_dmem = 0;
    
    @(posedge clk);   // wait for BRAM registered output
    $display("[DMEM READ] Data received: 0x%016h (%0d decimal)  time=%0t", 
             data_out_dmem, data_out_dmem, $time);

    $display("\n========================================");
    $display("RESULT VERIFICATION");
    $display("========================================");
    $display("Expected: 10 + 20 = 30");
    $display("Actual:   %0d", data_out_dmem);
    
    if (data_out_dmem == 64'd30) begin
        $display("? TEST PASSED!");
    end else begin
        $display("? TEST FAILED!");
    end
    $display("========================================\n");

    $display("Simulation complete.");
    $stop;
end

      
endmodule

