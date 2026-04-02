`timescale 1ns/1ps

// ================================================================
// tb_arm_gpu_dispatch.v
// Standalone TB: ARM pipeline executes a program that STRs to
// 0xF0 (base addr), 0xF1 (length), 0xF2 (dispatch).
// Verifies that cpu_mem_addr/data/we appear correctly on the
// MEM stage outputs, ready to drive gpu_control_interface_2.
// ================================================================

`define UDP_REG_ADDR_WIDTH 23
`define CPCI_NF2_DATA_WIDTH 32

module tb_cpu_gpu_dispatch;

    reg         clk;
    reg         rst;
    reg         cpu_start;

    // --- ARM host loading ports ---
    reg         write_to_imem;
    reg  [8:0]  addr_imem_host;
    reg  [31:0] data_imem_host;

    // --- ARM MEM stage outputs ---
    wire [7:0]  cpu_mem_addr;
    wire [63:0] cpu_mem_data;
    wire        cpu_mem_we;

    // --- Misc ARM outputs (not the focus here) ---
    wire        alu_result_detected;
    wire [31:0] data_out_dmem;
    wire [31:0] alu_out_intercept;

    // --- DUT: ARM pipeline ---
    pipeline_pseudoARM arm (
        .clk               (clk),
        .rst               (rst),
        .cpu_start         (cpu_start),
        .write_to_imem     (write_to_imem),
        .write_to_dmem     (1'b0),
        .addr_imem_host    (addr_imem_host),
        .data_imem_host    (data_imem_host),
        .addr_dmem_host    (8'h0),
        .data_dmem_host    (32'h0),
        .read_req_dmem     (1'b0),
        .alu_result_detected(alu_result_detected),
        .data_out_dmem     (data_out_dmem),
        .alu_out_intercept (alu_out_intercept),
        .cpu_mem_addr      (cpu_mem_addr),
        .cpu_mem_data      (cpu_mem_data),
        .cpu_mem_we        (cpu_mem_we)
    );

    // --- Clock: 125 MHz ---
    initial clk = 0;
    always #4 clk = ~clk;

    integer cycle;
    initial cycle = 0;
    always @(posedge clk) cycle = cycle + 1;

    // ----------------------------------------------------------------
    // Task: load one ARM instruction into IMEM
    // ----------------------------------------------------------------
    task imem_write;
        input [8:0]  addr;
        input [31:0] instr;
        begin
            @(negedge clk);
            write_to_imem  = 1'b1;
            addr_imem_host = addr;
            data_imem_host = instr;
            @(negedge clk);
            write_to_imem  = 1'b0;
        end
    endtask

    // ----------------------------------------------------------------
    // Monitor: print whenever ARM store hits MEM stage
    // ----------------------------------------------------------------
    always @(posedge clk) begin
        if (cpu_mem_we)
            $display("  Cycle %0d  STR -> addr=0x%02X  data=0x%016X",
                     cycle, cpu_mem_addr, cpu_mem_data);
    end

    // ================================================================
    // ARM program to dispatch GPU:
    //
    //   MOV R1, #0x50      ; base address (IMEM starts at 0x50)
    //   MOV R2, #0x2C      ; length = 44 instructions
    //   MOV R3, #0xF0      ; cfg_base register address
    //   MOV R4, #0xF1      ; cfg_len register address
    //   MOV R5, #0xF2      ; dispatch register address
    //   STR R1, [R3]       ; write base addr to 0xF0
    //   STR R2, [R4]       ; write length  to 0xF1
    //   STR R1, [R5]       ; write anything to 0xF2 - dispatch!
    //   B   .              ; halt (infinite loop)
    //
    // ARM encoding used (ARMv4 bare-metal, condition = AL = 4'b1110):
    //   MOV Rd, #imm8  -> 1110 00 1 1101 0 0000 Rd 0000 imm8
    //                   = 0xE3A0_0000 | (rd<<12) | imm8
    //   STR Rn, [Rb]   -> 1110 01 0 0000 0 Rb Rn 000000000000
    //                   = 0xE580_0000 | (rb<<16) | (rn<<12)
    //   B offset        -> 1110 1010 offset (offset=-2 for infinite loop)
    //                   = 0xEAFFFFFE
    // ================================================================

    // MOV encoding: E3A0_0000 | (rd<<12) | imm8
    // STR encoding: E580_0000 | (rb<<16) | (rd<<12) -- STR rd,[rb]
    // (L=0, P=1, U=1, B=0, W=0 -> bits[24:20]=01000 -> 0xE580_0000 base)

    localparam MOV_R1_0x50 = 32'hE3A01050; // MOV R1, #0x50
    localparam MOV_R2_0x2C = 32'hE3A0202C; // MOV R2, #0x2C
    localparam MOV_R3_0xF0 = 32'hE3A030F0; // MOV R3, #0xF0
    localparam MOV_R4_0xF1 = 32'hE3A040F1; // MOV R4, #0xF1
    localparam MOV_R5_0xF2 = 32'hE3A050F2; // MOV R5, #0xF2
    // STR R1, [R3] -> store R1 to address in R3
    localparam STR_R1_R3   = 32'hE5831000; // STR R1, [R3]
    // STR R2, [R4] -> store R2 to address in R4
    localparam STR_R2_R4   = 32'hE5842000; // STR R2, [R4]
    // STR R1, [R5] -> store R1 to address in R5 (data ignored by ctrl unit)
    localparam STR_R1_R5   = 32'hE5851000; // STR R1, [R5]
    // B . (infinite loop, branch to self)
    localparam B_SELF       = 32'hEAFFFFFE;

    initial begin
        write_to_imem  = 1'b0;
        addr_imem_host = 9'h0;
        data_imem_host = 32'h0;
        cpu_start      = 1'b0;

        rst = 1'b1;
        repeat(4) @(posedge clk);
        #1; rst = 1'b0;
        $display("  Reset released at cycle %0d", cycle);

        // ---- Load ARM program into IMEM ----
        imem_write(9'h000, MOV_R1_0x50);
        imem_write(9'h001, MOV_R2_0x2C);
        imem_write(9'h002, MOV_R3_0xF0);
        imem_write(9'h003, MOV_R4_0xF1);
        imem_write(9'h004, MOV_R5_0xF2);
        imem_write(9'h005, STR_R1_R3);
        imem_write(9'h006, STR_R2_R4);
        imem_write(9'h007, STR_R1_R5);
        imem_write(9'h008, B_SELF);
        $display("  ARM program loaded at cycle %0d", cycle);

        // ---- Release ARM CPU ----
        @(negedge clk);
        cpu_start = 1'b1;
        @(negedge clk);
        cpu_start = 1'b0;
        $display("  cpu_start pulsed at cycle %0d", cycle);

        // ---- Let ARM pipeline run ----
        // Pipeline depth ~5 cycles per instruction + IMEM latency
        // Wait long enough for all STRs to reach MEM stage
        repeat(100) @(posedge clk);

        // ---- Check results ----
        $display("");
        $display("  === EXPECTED STR SEQUENCE ===");
        $display("  STR -> addr=0xF0  data=0x50  (cfg_inst_addr)");
        $display("  STR -> addr=0xF1  data=0x2C  (cfg_length)");
        $display("  STR -> addr=0xF2  data=0x50  (dispatch)");

        #100;
        $stop;
    end

    // --- Timeout watchdog ---
    initial begin
        #50000;
        $display("  [TIMEOUT] at cycle %0d", cycle);
        $stop;
    end

endmodule