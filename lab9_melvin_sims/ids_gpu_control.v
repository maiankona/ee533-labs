`timescale 1ns/1ps
///////////////////////////////////////////////////////////////////////////////
// tb_ids_gpu_ctrl.v
//
// Drives gpu_control_interface_2 directly.
// Writes 0x50 to host_addr=0xF0 (cfg_inst_addr) then dispatches via 0xF2.
// Checks that gpu_start pulses and bram_inst_addr == 0x50.
///////////////////////////////////////////////////////////////////////////////

module tb_ids_gpu_ctrl;

    reg        clk          = 0;
    reg        rst          = 1;
    reg [7:0]  host_addr    = 0;
    reg [63:0] host_data    = 0;
    reg        host_we      = 0;
    reg        pipeline_done = 0;

    wire       gpu_irq;
    wire       gpu_start;
    wire [7:0] bram_inst_addr;
    wire [7:0] bram_length;
    wire       imem_we_en;

    always #5 clk = ~clk;

    gpu_control_interface_2 dut (
        .clk          (clk),
        .rst          (rst),
        .host_addr    (host_addr),
        .host_data    (host_data),
        .host_we      (host_we),
        .gpu_irq      (gpu_irq),
        .gpu_start    (gpu_start),
        .bram_inst_addr(bram_inst_addr),
        .bram_length  (bram_length),
        .pipeline_done(pipeline_done),
        .imem_we_en   (imem_we_en)
    );

    // Single-cycle write on the host bus
    task host_write;
        input [7:0]  addr;
        input [63:0] data;
        begin
            @(negedge clk);
            host_addr <= addr;
            host_data <= data;
            host_we   <= 1;
            @(negedge clk);
            host_we   <= 0;
        end
    endtask

    initial begin
        $dumpfile("tb_ids_gpu_ctrl.vcd");
        $dumpvars(0, tb_ids_gpu_ctrl);

        // Reset
        rst = 1;
        repeat(4) @(posedge clk);
        @(negedge clk);
        rst = 0;

        // Write base address 0x50 -> cfg_inst_addr_r
        host_write(8'hF0, 64'h50);
        $display("[%0t]  Wrote 0x50 to cfg_inst_addr (0xF0)", $time);

        // Dispatch
        host_write(8'hF2, 64'h1);
        $display("[%0t]  Dispatched (0xF2)", $time);

        // Check on next clock
        @(posedge clk);
        if (gpu_start)
            $display("[PASS]  gpu_start asserted");
        else
            $display("[FAIL]  gpu_start not asserted");

        if (bram_inst_addr == 8'h50)
            $display("[PASS]  bram_inst_addr = 0x%02X", bram_inst_addr);
        else
            $display("[FAIL]  bram_inst_addr = 0x%02X, expected 0x50", bram_inst_addr);

        #50;
        $stop;
    end

endmodule