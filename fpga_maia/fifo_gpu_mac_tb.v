`timescale 1ns / 1ps
//
// GPU + FIFO integration TB (Xilinx ISE / iverilog)
// Matches pipeline_backup + gpu_fifo_mem: 64b host DMEM (lo+hi, one dmem_we edge),
// gpu_start + bram_inst_addr + bram_length (no software gpu_mode).
//
// Add to project (typical order): dff.v, modular_register_generator.v, mem32bit512.v,
// FIFO_72W256D.v, fifo_states.v, gpu_fifo_mem.v, hazard_unit.v, alu_64bit_minimal.v,
// bf16_*.v, bf16_tensor_2.v, decode.v, ifetch.v, pipeline_gpu.v, fifo_gpu_tb.v
//
module gpu_fifo_integration_tb;

    reg clk;
    reg rst;

    // Host (matches ids-style paths into pipeline_backup)
    reg        write_to_imem;
    reg        read_req_imem;
    reg        write_to_dmem;
    reg        read_req_dmem;
    reg [8:0]  addr_imem_host;
    reg [31:0] data_imem_host;
    reg [7:0]  addr_dmem_host;
    reg [31:0] data_dmem_host_lo;
    reg [31:0] data_dmem_host_hi;
    // GPU bounded fetch (same semantics as ADDRESS=(len<<8)|start_pc then GPU_START pulse)
    reg        gpu_start;
    reg [7:0]  bram_inst_addr;
    reg [7:0]  bram_length;

    wire [31:0] data_out_imem;
    wire [63:0] data_out_dmem;
    wire [63:0] tensor_out_intercept;

    // -------------------------------------------------------------------------
    pipeline_backup gpu (
        .clk                  (clk),
        .rst                  (rst),
        .write_to_imem        (write_to_imem),
        .read_req_imem        (read_req_imem),
        .addr_imem_host       (addr_imem_host),
        .data_imem_host       (data_imem_host),
        .data_out_imem        (data_out_imem),
        .write_to_dmem        (write_to_dmem),
        .read_req_dmem        (read_req_dmem),
        .addr_dmem_host       (addr_dmem_host),
        .data_dmem_host_lo    (data_dmem_host_lo),
        .data_dmem_host_hi    (data_dmem_host_hi),
        .gpu_start            (gpu_start),
        .bram_inst_addr       (bram_inst_addr),
        .bram_length          (bram_length),
        .data_out_dmem        (data_out_dmem),
        .tensor_out_intercept (tensor_out_intercept)
    );

    // -------------------------------------------------------------------------
    // One 64b line: set addr (&FE), lo/hi, then pulse write_to_dmem 0->1->0
    // -------------------------------------------------------------------------
    task write_dmem64;
        input [7:0] base;
        input [31:0] lo32;
        input [31:0] hi32;
        begin
            addr_dmem_host    = base & 8'hFE;
            data_dmem_host_lo = lo32;
            data_dmem_host_hi = hi32;
            write_to_dmem     = 1'b0;
            @(posedge clk);
            write_to_dmem     = 1'b1;
            @(posedge clk);
            write_to_dmem     = 1'b0;
            @(posedge clk);
        end
    endtask

    task write_imem;
        input [8:0] a;
        input [31:0] instr;
        begin
            addr_imem_host = a;
            data_imem_host = instr;
            @(posedge clk);
            write_to_imem  = 1'b1;
            @(posedge clk);
            write_to_imem  = 1'b0;
            @(posedge clk);
        end
    endtask

    // ADDRESS=(N<<8)|PC0 then pulse gpu_start (same cycle bram_* must be stable)
    task run_gpu;
        input [7:0] start_pc;
        input [7:0] num_instr;
        begin
            bram_inst_addr = start_pc;
            bram_length    = num_instr;
            gpu_start      = 1'b0;
            @(posedge clk);
            gpu_start      = 1'b1;
            @(posedge clk);
            gpu_start      = 1'b0;
            @(posedge clk);
        end
    endtask

    // -------------------------------------------------------------------------
    initial clk = 0;
    always #5 clk = ~clk; // 100MHz

    // -------------------------------------------------------------------------
    initial begin
        rst              = 1'b1;
        write_to_imem    = 1'b0;
        read_req_imem    = 1'b0;
        write_to_dmem    = 1'b0;
        read_req_dmem    = 1'b0;
        addr_imem_host   = 9'h000;
        data_imem_host   = 32'h0;
        addr_dmem_host   = 8'h00;
        data_dmem_host_lo = 32'h0;
        data_dmem_host_hi = 32'h0;
        gpu_start        = 1'b0;
        bram_inst_addr   = 8'h00;
        bram_length      = 8'h00;

        #100;
        rst = 1'b0;

        $display("\n========================================");
        $display("GPU + FIFO TB (pipeline_backup + gpu_fifo_mem)");
        $display("========================================\n");

        // =====================================================================
        // TEST 1: Host 64b DMEM writes (FIFO should enter PROCESSING)
        // =====================================================================
        $display("TEST 1: Host DMEM 64b writes");
        write_dmem64(8'h10, 32'h12345678, 32'hDEADBEEF);
        $display("  Wrote line 0x10 = 0xDEADBEEF12345678");
        write_dmem64(8'h12, 32'hABCD1234, 32'hCAFEBABE);
        $display("  Wrote line 0x12 = 0xCAFEBABEABCD1234\n");

        // =====================================================================
        // TEST 2: Host DMEM read
        // =====================================================================
        #50;
        $display("TEST 2: Host DMEM read");
        addr_dmem_host = 8'h10;
        read_req_dmem  = 1'b1;
        @(posedge clk);
        @(posedge clk);
        read_req_dmem  = 1'b0;
        #1;
        $display("  Read [0x10] = 0x%016h (expect 0xDEADBEEF12345678)", data_out_dmem);
        if (data_out_dmem == 64'hDEADBEEF12345678)
            $display("  PASS");
        else
            $display("  FAIL");

        @(posedge clk);
        addr_dmem_host = 8'h12;
        read_req_dmem  = 1'b1;
        @(posedge clk);
        @(posedge clk);
        read_req_dmem  = 1'b0;
        #1;
        $display("  Read [0x12] = 0x%016h (expect 0xCAFEBABEABCD1234)", data_out_dmem);
        if (data_out_dmem == 64'hCAFEBABEABCD1234)
            $display("  PASS");
        else
            $display("  FAIL");
        $display("");

        // =====================================================================
        // TEST 3: Tensor VRELU program
        // MOVI r6,#0x70; MOVI r4,#0xC0; NOP; LDR r1,[r6]; NOPs; VRELU r3,r1; NOPs;
        // STR r3,[r4]; HALT => 14 instructions, start PC 0
        // =====================================================================
        #50;
        $display("TEST 3: IMEM load + GPU_START (VRELU, len=14, start=0)");
        rst = 1'b1;
        @(posedge clk);
        rst = 1'b0;
        @(posedge clk);

        // Input tensor at 0x70 with mixed signs (BF16 lanes):
        // lane0=-2.0 (0xC000), lane1=+3.0 (0x4040),
        // lane2=-0.5 (0xBF00), lane3=+4.0 (0x4080)
        // lo=0x4040C000, hi=0x4080BF00
        write_dmem64(8'h70, 32'h4040C000, 32'h4080BF00);
        $display("  Loaded mixed-sign input tensor at DMEM[0x70]\n");

        write_imem(9'h000, 32'h64c001c0); // MOVI r6,#0x70
        write_imem(9'h001, 32'h64800300); // MOVI r4,#0xC0
        write_imem(9'h002, 32'h00000000); // NOP
        write_imem(9'h003, 32'h48260000); // LDR r1,[r6]
        write_imem(9'h004, 32'h00000000); // NOP
        write_imem(9'h005, 32'h00000000); // NOP
        write_imem(9'h006, 32'h00000000); // NOP
        write_imem(9'h007, 32'h28610000); // VRELU r3,r1
        write_imem(9'h008, 32'h00000000); // NOP
        write_imem(9'h009, 32'h00000000); // NOP
        write_imem(9'h00a, 32'h00000000); // NOP
        write_imem(9'h00b, 32'h00000000); // NOP
        write_imem(9'h00c, 32'h4c640000); // STR r3,[r4]
        write_imem(9'h00d, 32'h2c000000); // HALT
        $display("  Loaded 14 instructions\n");

        run_gpu(8'h00, 8'd14);
        $display("  Pulsed GPU_START (bram_length=14, start_pc=0)\n");

        $display("  Waiting for pipeline...");
        repeat (200) @(posedge clk);
        $display("  tensor_out_intercept = 0x%016h\n", tensor_out_intercept);

        // Read result at 0xC0
        #20;
        @(posedge clk);
        addr_dmem_host = 8'hC0;
        read_req_dmem  = 1'b1;
        @(posedge clk);
        @(posedge clk);
        read_req_dmem  = 1'b0;
        #1;
        $display("  Result [0xC0] = 0x%016h (expect 0x4080000040400000)", data_out_dmem);
        if (data_out_dmem == 64'h4080000040400000)
            $display("  PASS: ReLU zeroed negative lanes");
        else
            $display("  FAIL");

        // =====================================================================
        // TEST 4: IMEM readback
        // =====================================================================
        #50;
        $display("\nTEST 4: IMEM readback");
        addr_imem_host = 9'h000;
        read_req_imem  = 1'b1;
        @(posedge clk);
        @(posedge clk);
        read_req_imem  = 1'b0;
        #1;
        $display("  IMEM[0] = 0x%08h (expect 0x64c001c0)", data_out_imem);
        if (data_out_imem == 32'h64c001c0)
            $display("  PASS");
        else
            $display("  FAIL");

        #100;
        $display("\n========================================");
        $display("INTEGRATION TEST COMPLETE");
        $display("========================================\n");
        $stop;
    end

endmodule
