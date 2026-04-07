`timescale 1ns/1ps

// ----------------------------------------------------------------
// Behavioral stub for generic_regs.
// ----------------------------------------------------------------
module generic_regs
#(
    parameter UDP_REG_SRC_WIDTH = 2,
    parameter TAG               = 0,
    parameter REG_ADDR_WIDTH    = 5,
    parameter NUM_COUNTERS      = 0,
    parameter NUM_SOFTWARE_REGS = 1,
    parameter NUM_HARDWARE_REGS = 0
)
(
    input                                          reg_req_in,
    input                                          reg_ack_in,
    input                                          reg_rd_wr_L_in,
    input  [`UDP_REG_ADDR_WIDTH-1:0]               reg_addr_in,
    input  [`CPCI_NF2_DATA_WIDTH-1:0]              reg_data_in,
    input  [UDP_REG_SRC_WIDTH-1:0]                 reg_src_in,
    output                                         reg_req_out,
    output                                         reg_ack_out,
    output                                         reg_rd_wr_L_out,
    output [`UDP_REG_ADDR_WIDTH-1:0]               reg_addr_out,
    output [`CPCI_NF2_DATA_WIDTH-1:0]              reg_data_out,
    output [UDP_REG_SRC_WIDTH-1:0]                 reg_src_out,
    input  [NUM_COUNTERS-1:0]                      counter_updates,
    input  [NUM_COUNTERS-1:0]                      counter_decrement,
    output [NUM_SOFTWARE_REGS*32-1:0]              software_regs,
    input  [NUM_HARDWARE_REGS*32-1:0]              hardware_regs,
    input                                          clk,
    input                                          reset
);
    assign reg_req_out     = reg_req_in;
    assign reg_ack_out     = reg_ack_in;
    assign reg_rd_wr_L_out = reg_rd_wr_L_in;
    assign reg_addr_out    = reg_addr_in;
    assign reg_data_out    = reg_data_in;
    assign reg_src_out     = reg_src_in;

    reg [NUM_SOFTWARE_REGS*32-1:0] sw_regs;
    initial sw_regs = 0;
    assign software_regs = sw_regs;

endmodule


module tb_ids_gpu_gpuctrl;

    // --- ids ports ---
    reg  [63:0] in_data;
    reg  [7:0]  in_ctrl;
    reg         in_wr;
    wire        in_rdy;

    wire [63:0] out_data;
    wire [7:0]  out_ctrl;
    wire        out_wr;
    reg         out_rdy;

    reg         reg_req_in;
    reg         reg_ack_in;
    reg         reg_rd_wr_L_in;
    reg  [`UDP_REG_ADDR_WIDTH-1:0]   reg_addr_in;
    reg  [`CPCI_NF2_DATA_WIDTH-1:0]  reg_data_in;
    reg  [1:0]  reg_src_in;

    wire        reg_req_out;
    wire        reg_ack_out;
    wire        reg_rd_wr_L_out;
    wire [`UDP_REG_ADDR_WIDTH-1:0]   reg_addr_out;
    wire [`CPCI_NF2_DATA_WIDTH-1:0]  reg_data_out;
    wire [1:0]  reg_src_out;

    reg         reset;
    reg         clk;

    // --- DUT ---
    ids dut (
        .in_data         (in_data),
        .in_ctrl         (in_ctrl),
        .in_wr           (in_wr),
        .in_rdy          (in_rdy),
        .out_data        (out_data),
        .out_ctrl        (out_ctrl),
        .out_wr          (out_wr),
        .out_rdy         (out_rdy),
        .reg_req_in      (reg_req_in),
        .reg_ack_in      (reg_ack_in),
        .reg_rd_wr_L_in  (reg_rd_wr_L_in),
        .reg_addr_in     (reg_addr_in),
        .reg_data_in     (reg_data_in),
        .reg_src_in      (reg_src_in),
        .reg_req_out     (reg_req_out),
        .reg_ack_out     (reg_ack_out),
        .reg_rd_wr_L_out (reg_rd_wr_L_out),
        .reg_addr_out    (reg_addr_out),
        .reg_data_out    (reg_data_out),
        .reg_src_out     (reg_src_out),
        .clk             (clk),
        .reset           (reset)
    );

    // --- Clock: 125 MHz ---
    initial clk = 0;
    always #4 clk = ~clk;

    integer cycle;
    initial cycle = 0;
    always @(posedge clk) cycle = cycle + 1;

    `define PIPELINE_DONE dut.pipeline_done
    `define TENSOR_OUT    dut.gpu_Unit.tensor_out_intercept
    `define GPU_IRQ       dut.gpu_irq

    // ----------------------------------------------------------------
    // Task: cpu_str
    // Mimics one ARM STR reaching the MEM stage for one cycle.
    // Forces dut.cpu_mem_* directly since ARM is not yet instantiated.
    // ----------------------------------------------------------------
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

    // ----------------------------------------------------------------
    // Task: dispatch_program
    // Sequences three ARM STRs through the ctrl unit:
    //   0xF0 <- bram_inst_addr  (latch cfg_inst_addr_r)
    //   0xF1 <- bram_length     (latch cfg_length_r)
    //   0xF2 <- don't care      (gpu_dispatch, FSM IDLE->EXECUTING)
    // ----------------------------------------------------------------
    task dispatch_program;
        input [7:0] inst_addr;
        input [7:0] length;
        begin
            cpu_str(8'hF0, {56'h0, inst_addr});
            cpu_str(8'hF1, {56'h0, length});
            cpu_str(8'hF2, 64'hDEAD);          // data ignored by ctrl unit
        end
    endtask

    // ----------------------------------------------------------------
    // Task: wait_and_ack
    // Polls gpu_irq then sends ARM STR to 0xF3 to acknowledge.
    // ----------------------------------------------------------------
    task wait_and_ack;
        begin
            while (!`GPU_IRQ) @(posedge clk);
            $display("  gpu_irq raised at cycle %0d", cycle);
            #8;
            cpu_str(8'hF3, 64'h0);             // ack, FSM DONE->IDLE
            $display("  arm_irq_ack sent at cycle %0d", cycle);
        end
    endtask

    // --- WB monitor ---
    always @(posedge clk) begin
        if (dut.gpu_Unit.wb_wreg_en && dut.gpu_Unit.wb_wreg_addr != 0)
            $display("  Cycle %0d  WB r%-2d <- %h",
                cycle, dut.gpu_Unit.wb_wreg_addr, dut.gpu_Unit.wb_data);
    end

    initial begin
        in_data        = 0;
        in_ctrl        = 0;
        in_wr          = 0;
        out_rdy        = 1;
        reg_req_in     = 0;
        reg_ack_in     = 0;
        reg_rd_wr_L_in = 1;
        reg_addr_in    = 0;
        reg_data_in    = 0;
        reg_src_in     = 0;

        // Hold cpu_mem bus idle until forced by tasks
        force dut.cpu_mem_we   = 1'b0;
        force dut.cpu_mem_addr = 8'h00;
        force dut.cpu_mem_data = 64'h0;

        // Tie off DMEM host signals - prevents Z propagation
        force dut.write_to_dmem  = 1'b0;
        force dut.read_req_dmem  = 1'b0;
        force dut.addr_dmem_host = 8'h0;
        force dut.data_dmem_host = 64'h0;

        reset = 1;
        repeat(4) @(posedge clk);
        #1; reset = 0;
        $display("  Reset released at cycle %0d", cycle);

        // ================================================================
        // PHASE 1: Configure IMEM window in ctrl unit
        // CPU tells ctrl unit where IMEM lives and how long the program is
        // so that subsequent cpu_str writes to those addresses assert imem_we_en
        // ================================================================
        cpu_str(8'hF0, {56'h0, 8'h00});   // cfg_inst_addr_r = 0x00
        cpu_str(8'hF1, {56'h0, 8'h2C});   // cfg_length_r    = 44 instructions
        $display("  IMEM window configured at cycle %0d", cycle);

        // ================================================================
        // PHASE 2: Load IMEM via cpu_str
        // Each write falls within [0x00, 0x2C) so imem_we_en goes high,
        // driving write_to_imem on pipeline_gpu.
        // host_data[63:32] ignored - pipeline_gpu takes data_imem_host[31:0]
        // ================================================================
        cpu_str(8'h00, {32'h0, 32'h48400000}); // LW r1, 0(r0)
        cpu_str(8'h01, {32'h0, 32'h48600004}); // LW r2, 4(r0)
        cpu_str(8'h02, {32'h0, 32'h48800008}); // LW r3, 8(r0)
        cpu_str(8'h03, {32'h0, 32'h48A0000C}); // LW r4, 12(r0)
        cpu_str(8'h04, {32'h0, 32'h00000000}); // NOP
        cpu_str(8'h05, {32'h0, 32'h00000000}); // NOP
        cpu_str(8'h06, {32'h0, 32'h00000000}); // NOP
        cpu_str(8'h07, {32'h0, 32'h00000000}); // NOP
        cpu_str(8'h08, {32'h0, 32'h00000000}); // NOP
        cpu_str(8'h09, {32'h0, 32'h00000000}); // NOP
        cpu_str(8'h0A, {32'h0, 32'h00000000}); // NOP
        cpu_str(8'h0B, {32'h0, 32'h18C21800}); // VADD r6, r1, r2
        cpu_str(8'h0C, {32'h0, 32'h00000000}); // NOP
        cpu_str(8'h0D, {32'h0, 32'h00000000}); // NOP
        cpu_str(8'h0E, {32'h0, 32'h00000000}); // NOP
        cpu_str(8'h0F, {32'h0, 32'h00000000}); // NOP
        cpu_str(8'h10, {32'h0, 32'h4CC00006}); // ST r6, 6(r0)
        cpu_str(8'h11, {32'h0, 32'h1CE21800}); // VSUB r7, r3, r4
        cpu_str(8'h12, {32'h0, 32'h00000000}); // NOP
        cpu_str(8'h13, {32'h0, 32'h00000000}); // NOP
        cpu_str(8'h14, {32'h0, 32'h00000000}); // NOP
        cpu_str(8'h15, {32'h0, 32'h00000000}); // NOP
        cpu_str(8'h16, {32'h0, 32'h4CE00007}); // ST r7, 7(r0)
        cpu_str(8'h17, {32'h0, 32'h21021800}); // VMUL r8, r1, r2
        cpu_str(8'h18, {32'h0, 32'h00000000}); // NOP
        cpu_str(8'h19, {32'h0, 32'h00000000}); // NOP
        cpu_str(8'h1A, {32'h0, 32'h00000000}); // NOP
        cpu_str(8'h1B, {32'h0, 32'h00000000}); // NOP
        cpu_str(8'h1C, {32'h0, 32'h4D000008}); // ST r8, 8(r0)
        cpu_str(8'h1D, {32'h0, 32'h25222000}); // VMAC r9, r2, r4
        cpu_str(8'h1E, {32'h0, 32'h00000000}); // NOP
        cpu_str(8'h1F, {32'h0, 32'h00000000}); // NOP
        cpu_str(8'h20, {32'h0, 32'h00000000}); // NOP
        cpu_str(8'h21, {32'h0, 32'h00000000}); // NOP
        cpu_str(8'h22, {32'h0, 32'h4D200009}); // ST r9, 9(r0)
        cpu_str(8'h23, {32'h0, 32'h29450000}); // VRELU r3, r9
        cpu_str(8'h24, {32'h0, 32'h00000000}); // NOP
        cpu_str(8'h25, {32'h0, 32'h00000000}); // NOP
        cpu_str(8'h26, {32'h0, 32'h00000000}); // NOP
        cpu_str(8'h27, {32'h0, 32'h00000000}); // NOP
        cpu_str(8'h28, {32'h0, 32'h4C600003}); // ST r3, 3(r0)
        cpu_str(8'h29, {32'h0, 32'h2C000000}); // HALT
        cpu_str(8'h2A, {32'h0, 32'h00000000}); // NOP
        cpu_str(8'h2B, {32'h0, 32'h00000000}); // NOP
        $display("  IMEM loaded at cycle %0d", cycle);

        // ================================================================
        // PHASE 3: Load DMEM via forced signals
        // CPU drives write_to_dmem/addr_dmem_host/data_dmem_host directly.
        // r1=1.5 (BF16: 3FC0), r2=4.0 (4080), r3=8.0 (4100), r4=-3.0 (C040)
        // ================================================================
        force dut.write_to_dmem = 1'b1;

        force dut.addr_dmem_host = 8'h00; force dut.data_dmem_host = 64'h3FC03FC03FC03FC0; @(posedge clk); #1; // r1=1.5
        force dut.addr_dmem_host = 8'h01; force dut.data_dmem_host = 64'h4080408040804080; @(posedge clk); #1; // r2=4.0
        force dut.addr_dmem_host = 8'h02; force dut.data_dmem_host = 64'h4100410041004100; @(posedge clk); #1; // r3=8.0
        force dut.addr_dmem_host = 8'h03; force dut.data_dmem_host = 64'hC040C040C040C040; @(posedge clk); #1; // r4=-3.0
        force dut.addr_dmem_host = 8'h04; force dut.data_dmem_host = 64'h0000000000000000; @(posedge clk); #1;
        force dut.addr_dmem_host = 8'h05; force dut.data_dmem_host = 64'h0000000000000000; @(posedge clk); #1;
        force dut.addr_dmem_host = 8'h06; force dut.data_dmem_host = 64'h0000000000000000; @(posedge clk); #1;
        force dut.addr_dmem_host = 8'h07; force dut.data_dmem_host = 64'h0000000000000000; @(posedge clk); #1;

        force dut.write_to_dmem  = 1'b0;
        force dut.addr_dmem_host = 8'h0;
        force dut.data_dmem_host = 64'h0;
        $display("  DMEM loaded at cycle %0d", cycle);

        // ================================================================
        // PHASE 4: DMEM load verify via forced read
        // ================================================================
        $display("");
        $display("  === DMEM LOAD VERIFY ===");

        force dut.read_req_dmem = 1'b1;
        force dut.addr_dmem_host = 8'h00; @(posedge clk); #1;
        force dut.read_req_dmem = 1'b0;
        @(posedge clk); #1;
        $display("  DMEM[0] r1 = %h  (exp 3FC03FC03FC03FC0)", dut.dmem_out);

        force dut.read_req_dmem = 1'b1;
        force dut.addr_dmem_host = 8'h01; @(posedge clk); #1;
        force dut.read_req_dmem = 1'b0;
        @(posedge clk); #1;
        $display("  DMEM[1] r2 = %h  (exp 4080408040804080)", dut.dmem_out);

        force dut.read_req_dmem = 1'b1;
        force dut.addr_dmem_host = 8'h02; @(posedge clk); #1;
        force dut.read_req_dmem = 1'b0;
        @(posedge clk); #1;
        $display("  DMEM[2] r3 = %h  (exp 4100410041004100)", dut.dmem_out);

        force dut.read_req_dmem = 1'b1;
        force dut.addr_dmem_host = 8'h03; @(posedge clk); #1;
        force dut.read_req_dmem = 1'b0;
        @(posedge clk); #1;
        $display("  DMEM[3] r4 = %h  (exp C040C040C040C040)", dut.dmem_out);

        // ---- Dispatch via ctrl unit ----
        // ARM STRs to 0xF0/0xF1/0xF2 flow through gpu_control_interface_2
        // inst_addr=0x00, length=0x2C (44 instructions)
        @(posedge clk); #1;
        $display("");
        $display("  === DISPATCHING VIA CTRL UNIT ===");
        dispatch_program(8'h00, 8'h2C);
        $display("  dispatch sent at cycle %0d", cycle);

        // ---- Wait for gpu_irq then ack via 0xF3 ----
        wait_and_ack;

        // Wait for all in-flight ST instructions to clear MEM stage
        repeat(50) @(posedge clk); #1;

        // ---- DMEM Readback via forced read signals ----
        $display("");
        $display("  === DMEM READBACK ===");

        force dut.read_req_dmem = 1'b1;
        force dut.addr_dmem_host = 8'h06; @(posedge clk); #1;
        force dut.read_req_dmem = 1'b0;
        @(posedge clk); #1;
        $display("  DMEM[6]  VADD  r6 = %h  (exp 40B040B040B040B0)", dut.dmem_out);

        force dut.read_req_dmem = 1'b1;
        force dut.addr_dmem_host = 8'h07; @(posedge clk); #1;
        force dut.read_req_dmem = 1'b0;
        @(posedge clk); #1;
        $display("  DMEM[7]  VSUB  r7 = %h  (exp 4130413041304130)", dut.dmem_out);

        force dut.read_req_dmem = 1'b1;
        force dut.addr_dmem_host = 8'h08; @(posedge clk); #1;
        force dut.read_req_dmem = 1'b0;
        @(posedge clk); #1;
        $display("  DMEM[8]  VMUL  r8 = %h  (exp 40C040C040C040C0)", dut.dmem_out);

        force dut.read_req_dmem = 1'b1;
        force dut.addr_dmem_host = 8'h09; @(posedge clk); #1;
        force dut.read_req_dmem = 1'b0;
        @(posedge clk); #1;
        $display("  DMEM[9]  VMAC  r9 = %h  (exp C140C140C140C140)", dut.dmem_out);

        force dut.read_req_dmem = 1'b1;
        force dut.addr_dmem_host = 8'h03; @(posedge clk); #1;
        force dut.read_req_dmem = 1'b0;
        @(posedge clk); #1;
        $display("  DMEM[3]  VRELU r3 = %h  (exp 0000000000000000)", dut.dmem_out);

        $display("");
        $display("  === TENSOR INTERCEPT ===");
        $display("  tensor_out = %h", `TENSOR_OUT);

        #100;
        $stop;
    end

    // --- Timeout watchdog ---
    initial begin
        #200000;
        $display("  [TIMEOUT] simulation exceeded limit at cycle %0d", cycle);
        $stop;
    end

endmodule