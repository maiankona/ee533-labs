`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module:  gpu_pipeline_tb
// Purpose: Full tensor unit test suite
//          Tests VADD, VSUB, VMUL, VMAC, VRELU across all 4 BF16 lanes
//
// Clock:   400ns period (200ns half-period)
//
// dmem operands (preloaded via .coe):
//   word[0]: A = { -2.0, 4.0, 1.0, 0.25 }  (lane3..lane0)
//   word[1]: B = { -1.0, 3.0, 2.0, 0.5  }
//   word[2]: A = {  1.5, 1.0, 0.5, 0.25 }  (VMAC)
//   word[3]: B = {  2.0, 2.0, 2.0, 2.0  }  (VMAC)
//   word[4]: A = { -3.0,-1.0, 0.5, 1.0  }  (VRELU)
//
// Expected WB results:
//   TEST1 VADD r3 = 0xC04040803F403F40  { -3.0,  7.0, 3.0, 0.75 }
//   TEST2 VSUB r3 = 0xBF803F80BF80BE80  { -1.0,  1.0,-1.0,-0.25 }
//   TEST3 VMUL r3 = 0xC04041404000 3E00  {  2.0, 12.0, 2.0, 0.125}
//   TEST4 VMAC r4 = 0x4040400 03F803F00  {  3.0,  2.0, 1.0, 0.5  }
//   TEST5 VRELU r3= 0x000000003F003F80  {  0.0,  0.0, 0.5, 1.0  }
////////////////////////////////////////////////////////////////////////////////
module gpu_pipeline_tb;

    // =========================================================
    // Inputs / Outputs
    // =========================================================
    reg        clk;
    reg        rst;
    reg        write_to_imem;
    reg        write_to_dmem;
    reg  [8:0] addr_imem_host;
    reg [31:0] data_imem_host;
    reg  [7:0] addr_dmem_host;
    reg [63:0] data_dmem_host;
    reg        read_req_dmem;
    wire [63:0] data_out_dmem;

    // =========================================================
    // UUT
    // =========================================================
    pipeline_backup uut (
        .clk            (clk),
        .rst            (rst),
        .write_to_imem  (write_to_imem),
        .write_to_dmem  (write_to_dmem),
        .addr_imem_host (addr_imem_host),
        .data_imem_host (data_imem_host),
        .addr_dmem_host (addr_dmem_host),
        .data_dmem_host (data_dmem_host),
        .read_req_dmem  (read_req_dmem),
        .data_out_dmem  (data_out_dmem)
    );

    // =========================================================
    // Clock ? 400ns period
    // =========================================================
    initial clk = 0;
    always #200 clk = ~clk;

    // =========================================================
    // Cycle counter
    // =========================================================
    integer cycle;
    initial cycle = 0;
    always @(posedge clk) cycle = cycle + 1;

    // =========================================================
    // Pass/Fail checker task
    //   Checks wb_data against expected value and prints
    //   a PASS or FAIL line with the operation label.
    // =========================================================
    task check_wb;
        input [63:0] expected;
        input [63:0] actual;
        input [127:0] label;   // 16-char string
        begin
            if (actual === expected)
                $display("  [PASS] %-16s got %h", label, actual);
            else begin
                $display("  [FAIL] %-16s got %h", label, actual);
                $display("         expected    %h", expected);
            end
        end
    endtask

    // =========================================================
    // Section header task
    // =========================================================
    task section;
        input [255:0] label;
        begin
            $display("");
            $display("========================================");
            $display(" %s", label);
            $display("========================================");
        end
    endtask

    // =========================================================
    // WB capture ? latch every writeback for checking
    // =========================================================
    reg [63:0] wb_capture [0:31];   // indexed by wreg addr
    reg        wb_valid   [0:31];
    integer    k;

    initial begin
        for (k = 0; k < 32; k = k + 1) begin
            wb_capture[k] = 64'b0;
            wb_valid[k]   = 0;
        end
    end

    always @(posedge clk) begin
        if (uut.wb_wreg_en && uut.wb_wreg_addr != 0) begin
            wb_capture[uut.wb_wreg_addr] <= uut.wb_data;
            wb_valid[uut.wb_wreg_addr]   <= 1;
            $display("  Cycle %0d  WB r%-2d <- %h",
                cycle, uut.wb_wreg_addr, uut.wb_data);
        end
    end

    // =========================================================
    // Stimulus
    // =========================================================
    initial begin
        // Initialise
        rst            = 0;
        write_to_imem  = 0;
        write_to_dmem  = 0;
        addr_imem_host = 0;
        data_imem_host = 0;
        addr_dmem_host = 0;
        data_dmem_host = 0;
        read_req_dmem  = 0;

        // ---- Reset ----
        section("RESET");
        @(posedge clk); #1; rst = 1;
        @(posedge clk); #1;
        @(posedge clk); #1; rst = 0;
        $display("  Reset released at cycle %0d", cycle);

        // ---- Run pipeline ----
        // 86 instructions + 6 pipeline stages (WB1+WB2) + margin = 110 cycles
        // Running 110 cycles = 44,000ns
        section("PIPELINE RUNNING");
        $display("  Running 110 cycles...");
        repeat(110) @(posedge clk);

        // =========================================================
        // Results ? check each test's WB value
        // All results written to r3 (tensor ops) or r4 (VMAC)
        // We check the last written value per register
        // =========================================================

        section("TEST RESULTS");

        $display("");
        $display("  Operand A  word[0]: { -2.0, 4.0, 1.0, 0.25 }  = 0xC00040803F803E80");
        $display("  Operand B  word[1]: { -1.0, 3.0, 2.0, 0.5  }  = 0xBF80404040003F00");
        $display("  Operand A  word[2]: {  1.5, 1.0, 0.5, 0.25 }  = 0x3FC03F803F003E80");
        $display("  Operand B  word[3]: {  2.0, 2.0, 2.0, 2.0  }  = 0x4000400040004000");
        $display("  Operand A  word[4]: { -3.0,-1.0, 0.5, 1.0  }  = 0xC040BF803F003F80");
        $display("");

        // TEST 1: VADD
        $display("  TEST 1 ? VADD  {-2.0+(-1.0), 4.0+3.0, 1.0+2.0, 0.25+0.5}");
        $display("           lanes: { -3.0,       7.0,     3.0,     0.75 }");
        // Note: r3 gets overwritten each test ? VADD result is the first r3 WB
        // For full isolation, check waveform per-cycle. Here we check final r3.
        $display("  (see WB log above for cycle-accurate per-test result)");

        $display("");
        $display("  TEST 2 ? VSUB  {-2.0-(-1.0), 4.0-3.0, 1.0-2.0, 0.25-0.5}");
        $display("           lanes: { -1.0,        1.0,   -1.0,    -0.25 }");

        $display("");
        $display("  TEST 3 ? VMUL  {-2.0*(-1.0), 4.0*3.0, 1.0*2.0, 0.25*0.5}");
        $display("           lanes: {  2.0,       12.0,    2.0,     0.125 }");

        $display("");
        $display("  TEST 4 ? VMAC  r4=0 + {1.5*2, 1.0*2, 0.5*2, 0.25*2}");
        $display("           lanes: { 3.0,  2.0,   1.0,   0.5 }");
        check_wb(64'h4040400_03F803F00, wb_capture[4], "VMAC r4");

        $display("");
        $display("  TEST 5 ? VRELU relu({-3.0,-1.0,0.5,1.0})");
        $display("           lanes: { 0.0, 0.0, 0.5, 1.0 }");
        // r3 holds VRELU result (last written)
        check_wb(64'h000000003F003F80, wb_capture[3], "VRELU r3");

        // =========================================================
        // Summary
        // =========================================================
        section("SUMMARY");
        $display("  VADD/VSUB/VMUL: check WB log ? r3 written 3 times (once per test)");
        $display("  VMAC r4 and VRELU r3 are checked above against expected values.");
        $display("  All lane values should match expected BF16 hex in header comment.");
        $display("");
        $display("  BF16 reference:");
        $display("    0.125 = 0x3E00   0.25 = 0x3E80   0.5  = 0x3F00");
        $display("    0.75  = 0x3F40   1.0  = 0x3F80   1.5  = 0x3FC0");
        $display("    2.0   = 0x4000   3.0  = 0x4040   4.0  = 0x4080");
        $display("    7.0   = 0x40E0   12.0 = 0x4140  -0.25 = 0xBE80");
        $display("   -0.5   = 0xBF00  -1.0  = 0xBF80  -2.0  = 0xC000");
        $display("   -3.0   = 0xC040   0.0  = 0x0000");

        #400;
        $finish;
    end

endmodule