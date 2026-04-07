`timescale 1ns/1ps

`define UDP_REG_ADDR_WIDTH 23
`define CPCI_NF2_DATA_WIDTH 32

// ----------------------------------------------------------------
// Behavioral stub for generic_regs
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


// ================================================================
// tb_arm_bubblesort.v
// Tests ARM pipeline executing bubble sort on 10-element array.
//
// Array loaded into ARM DMEM: [9,3,7,1,5,8,2,6,4,0]
// Expected sorted:            [0,1,2,3,4,5,6,7,8,9]
//
// Program uses R7=0 as base address, R1=outer counter, R2=inner index
// ================================================================
module tb_cpu_load_store;

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
    reg  [`UDP_REG_ADDR_WIDTH-1:0]  reg_addr_in;
    reg  [`CPCI_NF2_DATA_WIDTH-1:0] reg_data_in;
    reg  [1:0]  reg_src_in;
    wire        reg_req_out;
    wire        reg_ack_out;
    wire        reg_rd_wr_L_out;
    wire [`UDP_REG_ADDR_WIDTH-1:0]  reg_addr_out;
    wire [`CPCI_NF2_DATA_WIDTH-1:0] reg_data_out;
    wire [1:0]  reg_src_out;

    reg  reset;
    reg  clk;

    // --- SW reg aliases ---
    `define SW_INPUT_TYPE dut.module_regs.sw_regs[31:0]
    `define SW_ADDRESS    dut.module_regs.sw_regs[63:32]
    `define SW_IMEM       dut.module_regs.sw_regs[95:64]
    `define SW_DMEM       dut.module_regs.sw_regs[127:96]
    `define SW_CPU_CTRL   dut.module_regs.sw_regs[159:128]

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

    // ----------------------------------------------------------------
    // Task: write_arm_imem
    // input_type[4] = 0x10 -> arm_write_to_imem
    // ----------------------------------------------------------------
    task write_arm_imem;
        input [8:0]  addr;
        input [31:0] instr;
        begin
            @(negedge clk);
            `SW_ADDRESS    = {23'h0, addr};
            `SW_IMEM       = instr;
            `SW_INPUT_TYPE = 32'h10;
            @(posedge clk); #1;
            `SW_INPUT_TYPE = 32'h0;
        end
    endtask

    // ----------------------------------------------------------------
    // Task: write_arm_dmem
    // Directly forces ARM DMEM via pipeline_pseudoARM memory ports
    // On FPGA this would go through ARM DMEM SW regs (future work)
    // ----------------------------------------------------------------
    task write_arm_dmem;
        input [7:0]  addr;
        input [31:0] data;
        begin
            force dut.arm_cpu.ME.pipeline_addr = {24'h0, addr};
            force dut.arm_cpu.ME.pipeline_data = data;
            force dut.arm_cpu.ME.pipeline_we   = 1'b1;
            @(posedge clk); #1;
            force dut.arm_cpu.ME.pipeline_we   = 1'b0;
        end
    endtask

    // ----------------------------------------------------------------
    // Task: read_arm_dmem
    // Reads ARM DMEM result via pipeline_pseudoARM memory ports
    // ----------------------------------------------------------------
    task read_arm_dmem;
        input  [7:0]  addr;
        output [31:0] data;
        begin
            force dut.arm_cpu.ME.pipeline_addr = {24'h0, addr};
            @(posedge clk); #1;
            data = dut.arm_cpu.ME.dmem_out;
            release dut.arm_cpu.ME.pipeline_addr;
        end
    endtask

    // ----------------------------------------------------------------
    // Monitor: watch ARM MEM stage stores
    // ----------------------------------------------------------------
    always @(posedge clk) begin
        if (dut.arm_cpu.me_wme)
            $display("  Cycle %0d  ARM STR -> addr=0x%02X  data=0x%08X",
                     cycle, dut.arm_cpu.me_alu_res[7:0],
                     dut.arm_cpu.me_store_data);
    end

    integer i;
    reg [31:0] result;

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

        reset = 1;
        repeat(4) @(posedge clk);
        #1; reset = 0;
        $display("  Reset released at cycle %0d", cycle);

        // ============================================================
        // PHASE 1: Load ARM IMEM with bubble sort program
        // R7 = 0 (base address, initialized to 0 by reset)
        // ============================================================
        $display("  Loading Load / Store Program...");
        write_arm_imem(9'h000, 32'hE5934000); // LDR R4, [R3]     R4 = arr[i]
        write_arm_imem(9'h001, 32'hE1A00000); // NOP
        write_arm_imem(9'h002, 32'hE1A00000); // NOP
        write_arm_imem(9'h003, 32'hE5834000); // STR R4, [R3]     arr[i] = R6
        $display("  ARM IMEM loaded at cycle %0d", cycle);

        // ============================================================
        // PHASE 2: Load unsorted array into ARM DMEM
        // Array: [9,3,7,1,5,8,2,6,4,0] at addresses 0x00-0x09
        // Expected sorted: [0,1,2,3,4,5,6,7,8,9]
        // ============================================================
        $display("  Loading ARM DMEM with unsorted array...");
        write_arm_dmem(8'h03, 32'hCAFEBABE);
        $display("  ARM DMEM loaded: CAFEBABE");

        // ============================================================
        // PHASE 3: Release ARM CPU
        // ============================================================
        @(negedge clk);
        `SW_CPU_CTRL = 32'h1;
        @(posedge clk); #1;
        `SW_CPU_CTRL = 32'h0;
        $display("  cpu_ctrl[0] pulsed at cycle %0d - ARM executing", cycle);

        // ============================================================
        // PHASE 4: Wait for program to complete
        // ============================================================
        $display("  Waiting for completion...");
        repeat(10) @(posedge clk);
        $display("  Done waiting at cycle %0d", cycle);

        // ============================================================
        // PHASE 5: Read back sorted array from ARM DMEM
        // ============================================================
        $display("");
        $display("  === SORTED ARRAY READBACK ===");
        for (i = 0; i < 10; i = i + 1) begin
            read_arm_dmem(i, result);
            $display("  arr[%0d] = %0d  (exp %0d)  %s",
                i, result, i,
                (result == i) ? "PASS" : "FAIL");
        end

        #100;
        $stop;
    end

    // --- Timeout watchdog ---
    initial begin
        #2000000;
        $display("  [TIMEOUT] at cycle %0d", cycle);
        $stop;
    end

endmodule