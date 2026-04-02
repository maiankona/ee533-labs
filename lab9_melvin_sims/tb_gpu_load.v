`timescale 1ns/1ps

// =========================================================
// tb_ids_gpu.v
//
// generic_regs is unavailable in ISim ? all software register
// signals are driven directly via force statements on the
// derived wires inside ids.v, bypassing input_type entirely.
//
// Signal mapping:
//   dut.cpu_imem_we    = input_type[0] ? pipeline_cpu write_to_imem
//   dut.gpu_imem_we    = input_type[3] ? pipeline_gpu write_to_imem
//   dut.addr_imem_host = address[8:0]  ? both pipelines
//   dut.data_imem_host = imem[31:0]    ? both pipelines
//
// Load sequence:
//   1. Hold reset
//   2. Host loads GPU program ? GPU IMEM (force gpu_imem_we)
//   3. Host loads ARM program ? ARM IMEM (force cpu_imem_we)
//   4. Release reset ? ARM runs autonomously
//   5. ARM executes MOVs, NOPs, STRs to 0xF0/0xF1/0xF2, wait, 0xF3
//
// ARM register hazard: BRAM register file has 1-cycle read latency.
// MOV?WB takes 4 pipeline stages. Need 4 NOPs between last MOV
// and first STR to ensure all base address registers are valid.
// =========================================================

module tb_gpu_load;

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

   // ?? Program arrays ?????????????????????????????????????
   parameter GPU_PROG_LEN = 40;
   parameter ARM_PROG_LEN = 24;
   reg [31:0] gpu_program [0:GPU_PROG_LEN-1];
   reg [31:0] arm_program [0:ARM_PROG_LEN-1];

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
   initial begin clk = 0; clk2x = 0; end
   always #4 clk   = ~clk;
   always #2 clk2x = ~clk2x;

   // ==========================================================
   // Task: host_write_gpu_imem
   // ==========================================================
   task host_write_gpu_imem;
      input [8:0]  addr;
      input [31:0] data;
      begin
         force dut.addr_imem_host = addr;
         force dut.data_imem_host = data;
         force dut.gpu_imem_we    = 1'b1;
         @(posedge clk); #1;
         force dut.gpu_imem_we    = 1'b0;
      end
   endtask

   // ==========================================================
   // Task: host_write_arm_imem
   // ==========================================================
   task host_write_arm_imem;
      input [8:0]  addr;
      input [31:0] data;
      begin
         force dut.addr_imem_host = addr;
         force dut.data_imem_host = data;
         force dut.cpu_imem_we    = 1'b1;
         @(posedge clk); #1;
         force dut.cpu_imem_we    = 1'b0;
      end
   endtask

   // ==========================================================
   // Task: host_load_gpu_program
   // ==========================================================
   task host_load_gpu_program;
      integer k;
      begin
         $display("[%0t] Host loading GPU program into GPU IMEM...", $time);
         for (k = 0; k < GPU_PROG_LEN; k = k + 1)
            host_write_gpu_imem(9'h050 + k, gpu_program[k]);
         force dut.gpu_imem_we    = 1'b0;
         force dut.addr_imem_host = 9'h0;
         force dut.data_imem_host = 32'h0;
         $display("[%0t] GPU IMEM load complete.", $time);
      end
   endtask

   // ==========================================================
   // Task: host_load_arm_program
   // ==========================================================
   task host_load_arm_program;
      integer k;
      begin
         $display("[%0t] Host loading ARM program into ARM IMEM...", $time);
         for (k = 0; k < ARM_PROG_LEN; k = k + 1)
            host_write_arm_imem(k, arm_program[k]);
         force dut.cpu_imem_we    = 1'b0;
         force dut.addr_imem_host = 9'h0;
         force dut.data_imem_host = 32'h0;
         $display("[%0t] ARM IMEM load complete.", $time);
      end
   endtask

   // ==========================================================
   // Task: wait_for_irq
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

      // ?? GPU program (VMAC kernel, 40 words) ???????????????
      gpu_program[0]  = 32'h64c00002; gpu_program[1]  = 32'h00000000;
      gpu_program[2]  = 32'h00000000; gpu_program[3]  = 32'h00000000;
      gpu_program[4]  = 32'h64a000a6; gpu_program[5]  = 32'h00000000;
      gpu_program[6]  = 32'h00000000; gpu_program[7]  = 32'h00000000;
      gpu_program[8]  = 32'h64800146; gpu_program[9]  = 32'h00000000;
      gpu_program[10] = 32'h00000000; gpu_program[11] = 32'h00000000;
      gpu_program[12] = 32'h64e001e6; gpu_program[13] = 32'h00000000;
      gpu_program[14] = 32'h00000000; gpu_program[15] = 32'h00000000;
      gpu_program[16] = 32'h48260000; gpu_program[17] = 32'h00000000;
      gpu_program[18] = 32'h00000000; gpu_program[19] = 32'h00000000;
      gpu_program[20] = 32'h48450000; gpu_program[21] = 32'h00000000;
      gpu_program[22] = 32'h00000000; gpu_program[23] = 32'h00000000;
      gpu_program[24] = 32'h48640000; gpu_program[25] = 32'h00000000;
      gpu_program[26] = 32'h00000000; gpu_program[27] = 32'h00000000;
      gpu_program[28] = 32'h24611000; gpu_program[29] = 32'h00000000;
      gpu_program[30] = 32'h00000000; gpu_program[31] = 32'h00000000;
      gpu_program[32] = 32'h4c670000; gpu_program[33] = 32'h00000000;
      gpu_program[34] = 32'h00000000; gpu_program[35] = 32'h00000000;
      gpu_program[36] = 32'h2c000000; gpu_program[37] = 32'h00000000;
      gpu_program[38] = 32'h00000000; gpu_program[39] = 32'h00000000;

      // ?? ARM program ???????????????????????????????????????
      // Load all base address registers first, then 4 NOPs to
      // allow all MOVs to complete WB before any STR reads them.
      //
      //  0: MOV R0, #0x50  cfg_inst_addr value
      //  1: MOV R1, #0x28  cfg_length value (40)
      //  2: MOV R2, #0xF0  control base address
      //  3: MOV R3, #0x01  strobe value
      //  4: MOV R5, #0xF2  dispatch address
      //  5: MOV R6, #0xF3  ack address
      //  6: NOP  \
      //  7: NOP   | pipeline drain ? wait for all MOVs to WB
      //  8: NOP   |
      //  9: NOP  /
      // 10: STR R0, [R2, #0]  ? 0xF0 = cfg_inst_addr
      // 11: STR R1, [R2, #1]  ? 0xF1 = cfg_length
      // 12: STR R3, [R5, #0]  ? 0xF2 = dispatch
      // 13: MOV R4, #200
      // 14: SUB R4, R4, #1
      // 15: BNE -2            ? loop back to 14
      // 16: STR R3, [R6, #0]  ? 0xF3 = ack
      // 17-23: NOP
      arm_program[0]  = 32'hE3A00050; // MOV R0, #0x50
      arm_program[1]  = 32'hE3A01028; // MOV R1, #0x28
      arm_program[2]  = 32'hE3A020F0; // MOV R2, #0xF0
      arm_program[3]  = 32'hE3A03001; // MOV R3, #0x01
      arm_program[4]  = 32'hE3A050F2; // MOV R5, #0xF2
      arm_program[5]  = 32'hE3A060F3; // MOV R6, #0xF3
      arm_program[6]  = 32'h00000000; // NOP
      arm_program[7]  = 32'h00000000; // NOP
      arm_program[8]  = 32'h00000000; // NOP
      arm_program[9]  = 32'h00000000; // NOP
      arm_program[10] = 32'hE4020000; // STR R0, [R2, #0]  ? 0xF0
      arm_program[11] = 32'hE4021001; // STR R1, [R2, #1]  ? 0xF1
      arm_program[12] = 32'hE4053000; // STR R3, [R5, #0]  ? 0xF2 dispatch
      arm_program[13] = 32'hE3A040C8; // MOV R4, #200
      arm_program[14] = 32'hE2444001; // SUB R4, R4, #1
      arm_program[15] = 32'h18000FE0; // BNE -2
      arm_program[16] = 32'hE4063000; // STR R3, [R6, #0]  ? 0xF3 ack
      arm_program[17] = 32'h00000000; // NOP
      arm_program[18] = 32'h00000000; // NOP
      arm_program[19] = 32'h00000000; // NOP
      arm_program[20] = 32'h00000000; // NOP
      arm_program[21] = 32'h00000000; // NOP
      arm_program[22] = 32'h00000000; // NOP
      arm_program[23] = 32'h00000000; // NOP

      // ?? Init ??????????????????????????????????????????????
      in_data=0; in_ctrl=0; in_wr=0; out_rdy=1;
      reg_req_in=0; reg_ack_in=0; reg_rd_wr_L_in=1;
      reg_addr_in=0; reg_data_in=0; reg_src_in=0;
      fail_count=0;

      // Pre-force all derived host signals to 0
      force dut.cpu_imem_we    = 1'b0;
      force dut.gpu_imem_we    = 1'b0;
      force dut.addr_imem_host = 9'h0;
      force dut.data_imem_host = 32'h0;

      // ?? Hold reset while loading both IMEMs ???????????????
      reset = 1;
      repeat(2) @(posedge clk); #1;

      // ?? Step 1: host loads GPU program into GPU IMEM ??????
      host_load_gpu_program;

      // ?? Step 2: host loads ARM program into ARM IMEM ??????
      host_load_arm_program;

      // ?? Step 3: release reset ? ARM runs autonomously ?????
      repeat(2) @(posedge clk);
      reset = 0;
      @(posedge clk); #1;
      $display("=== RESET released ? ARM running ===");

      // ?? Step 4: wait for GPU IRQ ??????????????????????????
      $display("[%0t] Waiting for gpu_irq...", $time);
      wait_for_irq(5000, got_irq);

      if (!got_irq) begin
         $display("FAIL: gpu_irq timeout");
         fail_count = fail_count + 1;
      end else begin
         $display("[%0t] gpu_irq received", $time);
         $display("tensor_out_intercept = 0x%016h", dut.tensor_out_intercept);
      end

      repeat(50) @(posedge clk);
      $display("=== DONE: %0d failure(s) ===", fail_count);
      $stop;
   end

   // ?? Watchdog ???????????????????????????????????????????
   initial begin
      #2000;
      $display("WATCHDOG: simulation timed out");
      $stop;
   end

endmodule