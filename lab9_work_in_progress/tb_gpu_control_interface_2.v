`timescale 1ns / 1ps

module tb_gpu_control_interface_2;

// --- DUT signals ---
reg         clk;
reg         rst;
reg  [7:0]  host_addr;
reg  [63:0] host_data;
reg         host_we;
wire        gpu_irq;
wire        gpu_start;
wire [7:0]  bram_inst_addr;
wire [7:0]  bram_length;
wire        imem_we_en;

// --- Simulated tensor core ---
reg         pipeline_done;
integer     exec_cycles;

// --- DUT instantiation ---
gpu_control_interface_2 dut (
    .clk            (clk),
    .rst            (rst),
    .host_addr      (host_addr),
    .host_data      (host_data),
    .host_we        (host_we),
    .gpu_irq        (gpu_irq),
    .gpu_start      (gpu_start),
    .bram_inst_addr (bram_inst_addr),
    .bram_length    (bram_length),
    .pipeline_done  (pipeline_done),
    .imem_we_en     (imem_we_en)
);

// --- Clock generation: 10ns period ---
initial clk = 0;
always #5 clk = ~clk;

// --- Tensor core simulation ---
// Once gpu_start is seen, count down bram_length cycles then pulse pipeline_done
always @(posedge clk) begin
    if (rst) begin
        pipeline_done <= 1'b0;
        exec_cycles   <= 0;
    end else begin
        pipeline_done <= 1'b0;  // default deasserted

        if (gpu_start) begin
            exec_cycles <= bram_length;
        end else if (exec_cycles > 1) begin
            exec_cycles <= exec_cycles - 1;
        end else if (exec_cycles == 1) begin
            exec_cycles   <= 0;
            pipeline_done <= 1'b1;
        end
    end
end

// --- Task: single MMIO write ---
// Mimics one CPU ST instruction: drives host_addr/host_data/host_we for one cycle
task mmio_write;
    input [7:0]  addr;
    input [63:0] data;
    begin
        @(negedge clk);
        host_addr = addr;
        host_data = data;
        host_we   = 1'b1;
        @(negedge clk);
        host_we   = 1'b0;
        host_addr = 8'h00;
        host_data = 64'h0;
    end
endtask

// --- Task: dispatch a GPU program ---
// Sequences three MMIO writes:
//   0xF0 <- inst_addr   (latch cfg_inst_addr_r)
//   0xF1 <- length      (latch cfg_length_r)
//   0xF2 <- don't care  (gpu_dispatch pulse, FSM IDLE->EXECUTING)
task dispatch_program;
    input [7:0] inst_addr;
    input [7:0] length;
    begin
        mmio_write(8'hF0, {56'h0, inst_addr});
        mmio_write(8'hF1, {56'h0, length});
        mmio_write(8'hF2, 64'hDEAD);       // data ignored by DUT
    end
endtask

// --- Task: ARM IRQ acknowledge ---
// Single MMIO write to 0xF3, FSM DONE->IDLE, gpu_irq clears
task acknowledge_irq;
    begin
        mmio_write(8'hF3, 64'h0);          // data ignored by DUT
    end
endtask

// --- Task: wait for IRQ then acknowledge ---
task wait_and_ack;
    begin
        while (!gpu_irq) @(posedge clk);
        $display("[%0t] gpu_irq raised - ARM enters ISR", $time);
        #10;    // simulate ARM ISR latency
        acknowledge_irq;
        $display("[%0t] arm_irq_ack sent - GPU released, returning to IDLE", $time);
    end
endtask

// --- Main stimulus ---
initial begin
    $dumpfile("tb_gpu_control_interface_2.vcd");
    $dumpvars(0, tb_gpu_control_interface_2);

    // Initialise all inputs
    rst       = 1'b1;
    host_addr = 8'h00;
    host_data = 64'h0;
    host_we   = 1'b0;
    #20;

    // Release reset
    @(negedge clk);
    rst = 1'b0;
    $display("[%0t] Reset released - DUT in IDLE", $time);
    #10;

    // --- Test 1: vector add program (16 instructions at 0x50) ---
    $display("[%0t] TEST 1: dispatching vector add - 16 instructions at 0x50", $time);
    dispatch_program(8'h50, 8'h10);

    @(posedge clk);   // cycle gpu_dispatch was high
    @(posedge clk);   // cycle gpu_start fires (registered FSM output)
    if (gpu_start)
        $display("[%0t] PASS - gpu_start pulsed, bram_inst_addr=0x%02X, bram_length=0x%02X",
                 $time, bram_inst_addr, bram_length);
    else
        $display("[%0t] FAIL - gpu_start did not pulse", $time);

    @(posedge clk);
    if (!gpu_start)
        $display("[%0t] PASS - gpu_start cleared after one cycle", $time);
    else
        $display("[%0t] FAIL - gpu_start held high", $time);

    wait_and_ack;

    @(posedge clk);
    if (!gpu_irq)
        $display("[%0t] PASS - gpu_irq cleared, DUT back in IDLE", $time);
    else
        $display("[%0t] FAIL - gpu_irq still asserted after ack", $time);
    #20;

    // --- Test 2: second program (8 instructions at 0x60) ---
    $display("[%0t] TEST 2: dispatching second program - 8 instructions at 0x60", $time);
    dispatch_program(8'h60, 8'h08);

    @(posedge clk);
    @(posedge clk);
    if (bram_inst_addr == 8'h60 && bram_length == 8'h08)
        $display("[%0t] PASS - correct addresses latched for second program", $time);
    else
        $display("[%0t] FAIL - address mismatch, bram_inst_addr=0x%02X bram_length=0x%02X",
                 $time, bram_inst_addr, bram_length);

    wait_and_ack;
    #20;

    // --- Test 3: back-to-back dispatch while EXECUTING ---
    // FSM stays in EXECUTING on spurious gpu_dispatch - gpu_start must not re-pulse
    $display("[%0t] TEST 3: back-to-back dispatch while EXECUTING", $time);
    dispatch_program(8'h50, 8'h10);

    mmio_write(8'hF2, 64'h0);              // spurious dispatch while EXECUTING
    $display("[%0t] second dispatch attempted while EXECUTING - FSM should ignore", $time);

    @(posedge clk);
    if (!gpu_start)
        $display("[%0t] PASS - gpu_start did not re-pulse on spurious dispatch", $time);
    else
        $display("[%0t] FAIL - gpu_start re-pulsed during EXECUTING", $time);

    wait_and_ack;
    #20;

    // --- Test 4: reset during execution ---
    $display("[%0t] TEST 4: reset asserted mid-execution", $time);
    dispatch_program(8'h50, 8'h10);
    #15;
    rst = 1'b1;
    @(negedge clk);
    rst = 1'b0;
    $display("[%0t] reset released mid-execution - DUT should be in IDLE", $time);

    @(posedge clk);
    @(posedge clk);
    if (!gpu_irq && !gpu_start)
        $display("[%0t] PASS - clean reset, DUT in IDLE", $time);
    else
        $display("[%0t] FAIL - signals not cleared after reset", $time);
    #20;

    // --- Test 5: minimum length program (1 instruction) ---
    $display("[%0t] TEST 5: single instruction dispatch", $time);
    dispatch_program(8'h50, 8'h01);

    wait_and_ack;
    @(posedge clk);
    if (!gpu_irq)
        $display("[%0t] PASS - single instruction program completed and IRQ cleared", $time);
    else
        $display("[%0t] FAIL - gpu_irq not cleared after single instruction program", $time);
    #20;

    // --- Test 6: imem_we_en window check ---
    // Write to address within [cfg_inst_addr_r, cfg_inst_addr_r + cfg_length_r)
    // After Test 5, cfg_inst_addr_r=0x50, cfg_length_r=0x01, so only 0x50 is in window
    $display("[%0t] TEST 6: imem_we_en window", $time);
    mmio_write(8'h50, 64'hABCD);           // inside window -> imem_we_en should be 1
    if (imem_we_en)
        $display("[%0t] PASS - imem_we_en high for addr inside window", $time);
    else
        $display("[%0t] FAIL - imem_we_en low for addr inside window", $time);

    mmio_write(8'h51, 64'hABCD);           // outside window -> imem_we_en should be 0
    if (!imem_we_en)
        $display("[%0t] PASS - imem_we_en low for addr outside window", $time);
    else
        $display("[%0t] FAIL - imem_we_en high for addr outside window", $time);
    #20;

    $display("[%0t] all tests complete", $time);
    $stop;
end

// --- Timeout watchdog ---
initial begin
    #50000;
    $display("[%0t] TIMEOUT - simulation exceeded limit", $time);
    $stop;
end

endmodule