`timescale 1ns/1ps

// =========================================================
// tb_ids_gpu.v  ?  minimal VMAC kernel test
//
// Loads 40-word VMAC program into GPU IMEM, dispatches once,
// waits for gpu_irq, checks tensor_out_intercept.
// No back-to-back or repeated dispatches ? one clean run.
// =========================================================

module tb_ids_gpu;

   parameter DATA_WIDTH = 64;
   parameter CTRL_WIDTH = DATA_WIDTH / 8;

   // ?? DUT ports ??????????????????????????????????????????
   reg  [DATA_WIDTH-1:0]           in_data;
   reg  [CTRL_WIDTH-1:0]           in_ctrl;
   reg                             in_wr;
   wire                            in_rdy;
   wire [DATA_WIDTH-1:0]           out_data;
   wire [CTRL_WIDTH-1:0]           out_ctrl;
   wire                            out_wr;
   reg                             out_rdy;

   reg                             reg_req_in;
   reg                             reg_ack_in;
   reg                             reg_rd_wr_L_in;
   reg  [`UDP_REG_ADDR_WIDTH-1:0]  reg_addr_in;
   reg  [`CPCI_NF2_DATA_WIDTH-1:0] reg_data_in;
   reg  [1:0]                      reg_src_in;
   wire                            reg_req_out;
   wire                            reg_ack_out;
   wire                            reg_rd_wr_L_out;
   wire [`UDP_REG_ADDR_WIDTH-1:0]  reg_addr_out;
   wire [`CPCI_NF2_DATA_WIDTH-1:0] reg_data_out;
   wire [1:0]                      reg_src_out;

   reg  reset;
   reg  clk;
   reg  clk2x;

   // ?? VMAC kernel ? 40 words (active instructions + NOP padding) ??
   parameter PROG_LEN = 40;
   reg [31:0] vmac_program [0:PROG_LEN-1];

   // ?? Address map ????????????????????????????????????????
   parameter GPU_IMEM_BASE = 8'h50;
   parameter ADDR_CFG_BASE = 8'hF0;
   parameter ADDR_CFG_LEN  = 8'hF1;
   parameter ADDR_DISPATCH = 8'hF2;
   parameter ADDR_IRQ_ACK  = 8'hF3;

   // ?? DUT ????????????????????????????????????????????????
   ids dut (
      .in_data        (in_data),       .in_ctrl        (in_ctrl),
      .in_wr          (in_wr),         .in_rdy         (in_rdy),
      .out_data       (out_data),      .out_ctrl       (out_ctrl),
      .out_wr         (out_wr),        .out_rdy        (out_rdy),
      .reg_req_in     (reg_req_in),    .reg_ack_in     (reg_ack_in),
      .reg_rd_wr_L_in (reg_rd_wr_L_in),
      .reg_addr_in    (reg_addr_in),   .reg_data_in    (reg_data_in),
      .reg_src_in     (reg_src_in),    .reg_req_out    (reg_req_out),
      .reg_ack_out    (reg_ack_out),   .reg_rd_wr_L_out(reg_rd_wr_L_out),
      .reg_addr_out   (reg_addr_out),  .reg_data_out   (reg_data_out),
      .reg_src_out    (reg_src_out),
      .reset          (reset),         .clk            (clk)
   );

   // ?? Clocks ?????????????????????????????????????????????
   initial begin
      clk   = 0;
      clk2x = 0;
   end
   always #4 clk   = ~clk;    // 125 MHz
   always #2 clk2x = ~clk2x;  // 250 MHz

   // ==========================================================
   // Task: cpu_str
   //   Mimics one ARM STR reaching the MEM stage for one cycle.
   // ==========================================================
   task cpu_str;
      input [7:0]  addr;
      input [63:0] data;
      begin
         force dut.cpu_mem_addr = addr;
         force dut.cpu_mem_data = data;
         force dut.cpu_mem_we   = 1'b1;
         @(posedge clk); #1;
         force dut.cpu_mem_we   = 1'b0;
         force dut.cpu_mem_addr = 8'h00;
         force dut.cpu_mem_data = 64'h0;
      end
   endtask

   // ==========================================================
   // Task: gpu_load_program
   //   Burst-writes all PROG_LEN words into GPU IMEM.
   //   No other STRs follow until gpu_dispatch is called ?
   //   prevents loading from reasserting after dispatch.
   // ==========================================================
   task gpu_load_program;
      integer k;
      begin
         for (k = 0; k < PROG_LEN; k = k + 1)
            cpu_str(GPU_IMEM_BASE + k, {32'b0, vmac_program[k]});
      end
   endtask

   // ==========================================================
   // Task: wait_for_irq
   //   Polls gpu_irq for up to timeout_cycles clocks.
   // ==========================================================
   task wait_for_irq;
      input  integer timeout_cycles;
      output         got_irq;
      integer        j;
      begin
         got_irq = 0;
         j = 0;
         while (!dut.gpu_irq && j < timeout_cycles) begin
            @(posedge clk); #1;
            j = j + 1;
         end
         if (dut.gpu_irq) got_irq = 1;
      end
   endtask

   integer fail_count;
   reg     got_irq;

   // ==========================================================
   // Main test sequence
   // ==========================================================
   initial begin
      // ?? Program array ?????????????????????????????????????
      vmac_program[0]  = 32'h64c00002;
      vmac_program[1]  = 32'h00000000;
      vmac_program[2]  = 32'h00000000;
      vmac_program[3]  = 32'h00000000;
      vmac_program[4]  = 32'h64a000a6;
      vmac_program[5]  = 32'h00000000;
      vmac_program[6]  = 32'h00000000;
      vmac_program[7]  = 32'h00000000;
      vmac_program[8]  = 32'h64800146;
      vmac_program[9]  = 32'h00000000;
      vmac_program[10] = 32'h00000000;
      vmac_program[11] = 32'h00000000;
      vmac_program[12] = 32'h64e001e6;
      vmac_program[13] = 32'h00000000;
      vmac_program[14] = 32'h00000000;
      vmac_program[15] = 32'h00000000;
      vmac_program[16] = 32'h48260000;
      vmac_program[17] = 32'h00000000;
      vmac_program[18] = 32'h00000000;
      vmac_program[19] = 32'h00000000;
      vmac_program[20] = 32'h48450000;
      vmac_program[21] = 32'h00000000;
      vmac_program[22] = 32'h00000000;
      vmac_program[23] = 32'h00000000;
      vmac_program[24] = 32'h48640000;
      vmac_program[25] = 32'h00000000;
      vmac_program[26] = 32'h00000000;
      vmac_program[27] = 32'h00000000;
      vmac_program[28] = 32'h24611000;
      vmac_program[29] = 32'h00000000;
      vmac_program[30] = 32'h00000000;
      vmac_program[31] = 32'h00000000;
      vmac_program[32] = 32'h4c670000;
      vmac_program[33] = 32'h00000000;
      vmac_program[34] = 32'h00000000;
      vmac_program[35] = 32'h00000000;
      vmac_program[36] = 32'h2c000000;
      vmac_program[37] = 32'h00000000;
      vmac_program[38] = 32'h00000000;
      vmac_program[39] = 32'h00000000;

      in_data=0; in_ctrl=0; in_wr=0; out_rdy=1;
      reg_req_in=0; reg_ack_in=0; reg_rd_wr_L_in=1;
      reg_addr_in=0; reg_data_in=0; reg_src_in=0;
      fail_count=0;

      // Hold MEM-stage outputs idle
      force dut.cpu_mem_we   = 1'b0;
      force dut.cpu_mem_addr = 8'h00;
      force dut.cpu_mem_data = 64'h0;

      // Tie off DMEM host signals ? prevents Z propagation
      force dut.write_to_dmem  = 1'b0;
      force dut.read_req_dmem  = 1'b0;
      force dut.addr_dmem_host = 8'h0;
      force dut.data_dmem_host = 64'h0;

      // ?? Reset ?????????????????????????????????????????????
      reset = 1;
      repeat(4) @(posedge clk);
      reset = 0;
      @(posedge clk); #1;
      $display("=== RESET complete ===");

      // ?? Step 1: configure ?????????????????????????????????
      // STR #0x50, [0xF0] ? base address
      // STR #40,   [0xF1] ? instruction count
      cpu_str(ADDR_CFG_BASE, {56'b0, 8'h50});
      cpu_str(ADDR_CFG_LEN,  {56'b0, 8'd40});

      // ?? Step 2: burst-load all 40 instructions ????????????
      // No other STRs between here and dispatch ? loading stays
      // asserted only during this window and clears on gpu_start
      gpu_load_program;

      // ?? Step 3: dispatch ??????????????????????????????????
      // STR #1, [0xF2] ? triggers FSM IDLE?EXECUTING
      cpu_str(ADDR_DISPATCH, 64'h1);

      // ?? Step 4: wait for completion ???????????????????????
      $display("[%0t] dispatch sent ? waiting for gpu_irq", $time);
      wait_for_irq(500, got_irq);

      if (!got_irq) begin
         $display("FAIL: gpu_irq timeout");
         fail_count = fail_count + 1;
      end else begin
         $display("[%0t] gpu_irq received", $time);
         $display("tensor_out_intercept = 0x%016h", dut.tensor_out_intercept);
      end

      // ?? Step 5: ack IRQ ???????????????????????????????????
      cpu_str(ADDR_IRQ_ACK, 64'h1);
      @(posedge clk); #1;

      $display("=== DONE: %0d failure(s) ===", fail_count);
      //$stop;
   end

   // ?? Watchdog ???????????????????????????????????????????
   initial begin
      #2000;
      $display("WATCHDOG: simulation timed out");
      $stop;
   end

endmodule