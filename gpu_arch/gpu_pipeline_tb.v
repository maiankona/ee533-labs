`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name:   gpu_pipeline_tb
// Description:   Tests MOVI ? ST ? LD ? VMAC sequence
//                Instructions preloaded via .coe into mem32bit512.
//
// Clock: 400ns period (200ns half) ? covers BF16 adder combinational latency
//
// Operands:
//   r1 = 0x3F80 (1.0 BF16)
//   r2 = 0x3F00 (0.5 BF16)
//
// Expected writeback sequence:
//   wreg=1 wdata=0x0000000000003F80  MOVI r1
//   wreg=2 wdata=0x0000000000003F00  MOVI r2
//   wreg=3 wdata=0x0000000000000000  MOVI r3
//   wreg=4 wdata=0x0000000000000000  MOVI r4 (seed)
//   wreg=5 wdata=0x0000000000003F80  LD r5
//   wreg=6 wdata=0x0000000000003F00  LD r6
//   wreg=4 wdata=0x0000000000003F00  VMAC r4 = 0 + 1.0*0.5 = 0.5
//
// dmem after ST:
//   dmem[0] = 0x0000000000003F80
//   dmem[1] = 0x0000000000003F00
////////////////////////////////////////////////////////////////////////////////
module gpu_pipeline_tb;

    // ---- Inputs ----
    reg        clk;
    reg        rst;
    reg        write_to_imem;
    reg        write_to_dmem;
    reg  [8:0] addr_imem_host;
    reg [31:0] data_imem_host;
    reg  [7:0] addr_dmem_host;
    reg [63:0] data_dmem_host;
    reg        read_req_dmem;

    // ---- Outputs ----
    wire [63:0] data_out_dmem;

    // ---- UUT ----
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

    // ---- Clock: 400ns period ----
    initial clk = 0;
    always #200 clk = ~clk;

    // ---- Cycle counter ----
    integer cycle;
    initial cycle = 0;
    always @(posedge clk) cycle = cycle + 1;

    // ---- Monitor: print every WB event ----
    always @(posedge clk) begin
        if (uut.wb_wreg_en)
            $display("Cycle %0d | WB: wreg=r%0d wdata=%h",
                cycle, uut.wb_wreg_addr, uut.wb_data);
    end

    // ---- Stimulus ----
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

        // ---- Reset: two full clock cycles ----
        @(posedge clk); #1;
        rst = 1;
        @(posedge clk); #1;
        @(posedge clk); #1;
        rst = 0;

        $display("--- Reset released, pipeline starting ---");
        $display("--- Expecting 7 WB events then dmem readback ---");

        // ---- Run 30 cycles ----
        // 9 instructions + 4 stages = 13 cycles minimum
        // 30 cycles gives margin for all WB events to complete
        repeat(30) @(posedge clk);

        // ---- dmem readback: word 0 (operand A) ----
        $display("--- Host dmem read: word 0 ---");
        addr_dmem_host = 8'd0;
        read_req_dmem  = 1;
        @(posedge clk); #1;
        @(posedge clk); #1;
        $display("dmem[0] = %h  (expect 0x0000000000003F80 = 1.0 BF16)", data_out_dmem);

        // ---- dmem readback: word 1 (operand B) ----
        $display("--- Host dmem read: word 1 ---");
        addr_dmem_host = 8'd1;
        @(posedge clk); #1;
        @(posedge clk); #1;
        $display("dmem[1] = %h  (expect 0x0000000000003F00 = 0.5 BF16)", data_out_dmem);

        read_req_dmem = 0;

        // ---- Pass/fail summary ----
        $display("--- Complete. Check WB log above for: ---");
        $display("  r1 <- 0x0000000000003F80  (MOVI 1.0)");
        $display("  r2 <- 0x0000000000003F00  (MOVI 0.5)");
        $display("  r3 <- 0x0000000000000000  (MOVI 0)");
        $display("  r4 <- 0x0000000000000000  (MOVI seed)");
        $display("  r5 <- 0x0000000000003F80  (LD operand A)");
        $display("  r6 <- 0x0000000000003F00  (LD operand B)");
        $display("  r4 <- 0x0000000000003F00  (VMAC 0+1.0*0.5=0.5)");

        #400;
        $finish;
    end

endmodule
