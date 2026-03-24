`timescale 1ns / 1ps
//
// GPU + FIFO Integration Testbench (Xilinx ISE sim)
// Tests pipeline_backup with gpu_fifo_mem (FIFO inside pipeline).
// Host DMEM: 32-bit writes (even addr=lo, odd=hi of 64b word).
//
// Add to ISE project (in order): dff.v, modular_register_generator.v, mem32bit512.v,
// mem64bit256.v, FIFO_72W256D.v, fifo_states.v, gpu_fifo_mem.v, hazard_unit.v,
// alu_64bit_minimal.v, bf16_add.v, bf16Mul.v, mantMulUnit.v, expAddUnit.v,
// bf16_tensor.v, decode.v, ifetch.v, pipeline_gpu.v, fifo_gpu_tb.v
//
module gpu_fifo_integration_tb;

    // Clock and reset
    reg clk;
    reg clk2x;
    reg rst;

    // GPU control (pipeline_backup interface)
    reg write_to_imem;
    reg read_req_imem;
    reg write_to_dmem;
    reg read_req_dmem;
    reg [8:0]  addr_imem_host;
    reg [31:0] data_imem_host;
    reg [7:0]  addr_dmem_host;
    reg [31:0] data_dmem_host;   // 32-bit: even addr=lo, odd=hi of 64b word
    reg gpu_mode;                // 1 = FIFO in PROCESSING (set after IMEM loaded)

    wire [31:0] data_out_imem;
    wire [63:0] data_out_dmem;
    wire [63:0] tensor_out_intercept;

    // =========================================================================
    // GPU Pipeline (FIFO inside via gpu_fifo_mem)
    // =========================================================================
    pipeline_backup gpu (
        .clk                (clk),
        .clk2x              (clk2x),
        .rst                (rst),
        .write_to_imem      (write_to_imem),
        .read_req_imem      (read_req_imem),
        .addr_imem_host     (addr_imem_host),
        .data_imem_host     (data_imem_host),
        .data_out_imem      (data_out_imem),
        .write_to_dmem      (write_to_dmem),
        .read_req_dmem      (read_req_dmem),
        .addr_dmem_host     (addr_dmem_host),
        .data_dmem_host     (data_dmem_host),
        .gpu_mode           (gpu_mode),
        .data_out_dmem      (data_out_dmem),
        .tensor_out_intercept(tensor_out_intercept)
    );

    // =========================================================================
    // Clock Generation
    // =========================================================================
    initial clk = 0;
    initial clk2x = 0;
    always #5 clk = ~clk;       // 10ns period = 100MHz
    always #2.5 clk2x = ~clk2x; // 5ns period = 200MHz

    // =========================================================================
    // Test Sequence
    // =========================================================================
    initial begin
        clk = 0;
        clk2x = 0;
        rst = 1;
        write_to_imem = 0;
        read_req_imem = 0;
        write_to_dmem = 0;
        read_req_dmem = 0;
        addr_imem_host = 0;
        data_imem_host = 0;
        addr_dmem_host = 0;
        data_dmem_host = 0;
        gpu_mode = 0;

        #100;
        rst = 0;

        $display("\n========================================");
        $display("GPU + FIFO INTEGRATION TEST (pipeline_backup + gpu_fifo_mem)");
        $display("========================================\n");

        // =====================================================================
        // TEST 1: Host DMEM write (32-bit even/odd pairs)
        // =====================================================================
        $display("TEST 1: Host writes 64-bit data to DMEM via FIFO");
        // Write 0xDEADBEEF12345678 at addr 0x10: lo first, then hi
		  gpu_mode = 1;
        @(posedge clk);
        addr_dmem_host = 8'h10;
        data_dmem_host = 32'h12345678;  // lo
        write_to_dmem = 1;
        @(posedge clk);
        write_to_dmem = 0;
        @(posedge clk);
        addr_dmem_host = 8'h11;
        data_dmem_host = 32'hDEADBEEF;  // hi
        write_to_dmem = 1;
        @(posedge clk);
        write_to_dmem = 0;
        $display("  Wrote [0x10] = 0xDEADBEEF12345678\n");

        // Write 0xCAFEBABEABCD1234 at addr 0x12
        @(posedge clk);
        addr_dmem_host = 8'h12;
        data_dmem_host = 32'hABCD1234;
        write_to_dmem = 1;
        @(posedge clk);
        write_to_dmem = 0;
        @(posedge clk);
        addr_dmem_host = 8'h13;
        data_dmem_host = 32'hCAFEBABE;
        write_to_dmem = 1;
        @(posedge clk);
        write_to_dmem = 0;
        $display("  Wrote [0x12] = 0xCAFEBABEABCD1234\n");

        // =====================================================================
        // TEST 2: Host DMEM read (BRAM has output register - need extra cycles)
        // Same fix as convertible_fifo_tb: Present addr, wait for BRAM output reg
        // =====================================================================
        #50;   // Extra delay after writes for BRAM to settle
        $display("TEST 2: Host reads DMEM");
        @(posedge clk);
        addr_dmem_host = 8'h10;
        read_req_dmem = 1;
        @(posedge clk);  // Cycle 1: address presented
        @(posedge clk);  // Cycle 2: wait for BRAM output register
       // @(posedge clk);  // Cycle 3: extra for first read (priming)
        read_req_dmem = 0;
        #1;
        $display("  Read [0x10] = 0x%016h (expect 0xDEADBEEF12345678)", data_out_dmem);
        if (data_out_dmem == 64'hDEADBEEF12345678)
            $display("  PASS");
        else
            $display("  FAIL");
        @(posedge clk);
        addr_dmem_host = 8'h12;
        read_req_dmem = 1;
        @(posedge clk);  // Present address
        @(posedge clk);  // Wait for BRAM output register
        //@(posedge clk);  // Extra cycle
        read_req_dmem = 0;
        #1;
        $display("  Read [0x12] = 0x%016h (expect 0xCAFEBABEABCD1234)", data_out_dmem);
        if (data_out_dmem == 64'hCAFEBABEABCD1234)
            $display("  PASS");
        else
            $display("  FAIL");
        $display("");
		  gpu_mode=0;
        // =====================================================================
        // TEST 3: Load ALU add program and run (same as gpu_alu_add.pl)
        // LDR r1,[r6]; LDR r2,[r5]; ADD r3,r1,r2; STR r3,[r4]; HALT
        // r6=0x70 (A), r5=0x74 (B), r4=0xC0 (Result)
        // =====================================================================
        #50;
        $display("TEST 3: Load program and run GPU ALU add");
        rst = 1;
        gpu_mode = 0;
        @(posedge clk);
        rst = 0;
        gpu_mode = 1;           // FIFO in PROCESSING so host writes land
        @(posedge clk);
        // Load operands A=0x0100_1000, B=0x0020_0200
        addr_dmem_host = 8'h70;
        data_dmem_host = 32'h00001000;  // A lo
        write_to_dmem = 1;
        @(posedge clk);
        write_to_dmem = 0;
        @(posedge clk);
        addr_dmem_host = 8'h71;
        data_dmem_host = 32'h00000100;  // A hi
        write_to_dmem = 1;
        @(posedge clk);
        write_to_dmem = 0;
        @(posedge clk);
        addr_dmem_host = 8'h74;
        data_dmem_host = 32'h00000200;  // B lo
        write_to_dmem = 1;
        @(posedge clk);
        write_to_dmem = 0;
        @(posedge clk);
        addr_dmem_host = 8'h75;
        data_dmem_host = 32'h00000020;  // B hi
        write_to_dmem = 1;
        @(posedge clk);
        write_to_dmem = 0;
        $display("  Loaded A=0x0100_1000, B=0x0020_0200\n");

        // Load IMEM
        write_to_imem = 1;
        addr_imem_host = 9'h000; data_imem_host = 32'h64c001c0; @(posedge clk);  // MOVI r6,#0x70
        addr_imem_host = 9'h001; data_imem_host = 32'h64a001d0; @(posedge clk);  // MOVI r5,#0x74
        addr_imem_host = 9'h002; data_imem_host = 32'h64800300; @(posedge clk);  // MOVI r4,#0xC0
        addr_imem_host = 9'h003; data_imem_host = 32'h00000000; @(posedge clk);  // NOP
        addr_imem_host = 9'h004; data_imem_host = 32'h48260000; @(posedge clk);  // LDR r1,[r6]
        addr_imem_host = 9'h005; data_imem_host = 32'h00000000; @(posedge clk);  // NOP
        addr_imem_host = 9'h006; data_imem_host = 32'h00000000; @(posedge clk);  // NOP
        addr_imem_host = 9'h007; data_imem_host = 32'h00000000; @(posedge clk);  // NOP
        addr_imem_host = 9'h008; data_imem_host = 32'h48450000; @(posedge clk);  // LDR r2,[r5]
        addr_imem_host = 9'h009; data_imem_host = 32'h00000000; @(posedge clk);  // NOP
        addr_imem_host = 9'h00a; data_imem_host = 32'h00000000; @(posedge clk);  // NOP
        addr_imem_host = 9'h00b; data_imem_host = 32'h00000000; @(posedge clk);  // NOP
        addr_imem_host = 9'h00c; data_imem_host = 32'h04611000; @(posedge clk);  // ADD r3,r1,r2
        addr_imem_host = 9'h00d; data_imem_host = 32'h00000000; @(posedge clk);  // NOP
        addr_imem_host = 9'h00e; data_imem_host = 32'h4c640000; @(posedge clk);  // STR r3,[r4]
        addr_imem_host = 9'h00f; data_imem_host = 32'h2c000000; @(posedge clk);  // HALT
        write_to_imem = 0;
        $display("  Loaded 16 instructions\n");

        gpu_mode = 1;   // Keep PROCESSING so pipeline can use DMEM
        $display("  GPU executing...");
        repeat(80) @(posedge clk);  // Wait for HALT + store to complete
        $display("  Done.\n");

        // Read result at 0xC0 (expect 0x0120_1200)
        #20;
        @(posedge clk);
        addr_dmem_host = 8'hC0;
        read_req_dmem = 1;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);  // BRAM latency
        read_req_dmem = 0;
        #1;
        $display("  Result [0xC0] = 0x%016h (expect 0x0000000001201200)", data_out_dmem);
        if (data_out_dmem[31:0] == 32'h01201200)
            $display("  PASS: A+B = 0x0120_1200");
        else
            $display("  FAIL");

        // =====================================================================
        // TEST 4: IMEM readback (verify stored correctly)
        // =====================================================================
        #50;
        $display("\nTEST 4: IMEM readback");
        addr_imem_host = 9'h000;
        read_req_imem = 1;
        @(posedge clk);
        @(posedge clk);  // 1-cycle mem latency
        read_req_imem = 0;
        #1;
        $display("  IMEM[0] = 0x%08h (expect 0x64c001c0)", data_out_imem);
        if (data_out_imem == 32'h64c001c0) $display("  PASS"); else $display("  FAIL");

        // =====================================================================
        // Summary
        // =====================================================================
        #100;
        $display("\n========================================");
        $display("INTEGRATION TEST COMPLETE");
        $display("========================================");
        $display("  - Host DMEM write (32b even/odd)");
        $display("  - Host DMEM read");
        $display("  - GPU program load and execute");
        $display("  - IMEM readback");
        $display("========================================\n");
        $stop;
    end

endmodule
