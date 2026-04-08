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


module gpu_sw_reg_tb;

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

    // ---- Clock: 125 MHz ----
    initial clk = 0;
    always #4 clk = ~clk;

    integer cycle;
    initial cycle = 0;
    always @(posedge clk) cycle = cycle + 1;

    // ---- SW reg aliases ----
    `define SW_INPUT_TYPE dut.module_regs.sw_regs[31:0]
    `define SW_ADDRESS    dut.module_regs.sw_regs[63:32]
    `define SW_IMEM       dut.module_regs.sw_regs[95:64]
    `define SW_DMEM       dut.module_regs.sw_regs[127:96]
    `define SW_GPU_CTRL   dut.module_regs.sw_regs[159:128]

    `define PIPELINE_DONE dut.pipeline_done
    `define TENSOR_OUT    dut.gpu_Unit.tensor_out_intercept

    task check;
        input [63:0] expected;
        input [63:0] actual;
        input [127:0] label;
        begin
            if (actual === expected)
                $display("  [PASS] %-20s got %h", label, actual);
            else begin
                $display("  [FAIL] %-20s got %h", label, actual);
                $display("         expected        %h", expected);
            end
        end
    endtask

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

        reset = 1;
        repeat(2) @(posedge clk);
        #1; reset = 0;
        $display("  Reset released at cycle %0d", cycle);

        // ---- Load IMEM ----
        // Tensor ops followed by 4 NOPs then ST to write result to DMEM
        `SW_INPUT_TYPE = 32'h8;
        `SW_ADDRESS = 32'h000; `SW_IMEM = 32'h48400000; @(posedge clk); #1; // LW r1, 0(r0)
        `SW_ADDRESS = 32'h001; `SW_IMEM = 32'h48600004; @(posedge clk); #1; // LW r2, 4(r0)
        `SW_ADDRESS = 32'h002; `SW_IMEM = 32'h48800008; @(posedge clk); #1; // LW r3, 8(r0)
        `SW_ADDRESS = 32'h003; `SW_IMEM = 32'h48A0000C; @(posedge clk); #1; // LW r4, 12(r0)
        `SW_ADDRESS = 32'h004; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h005; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h006; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h007; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h008; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h009; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h00A; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h00B; `SW_IMEM = 32'h18C21800; @(posedge clk); #1; // VADD r6, r1, r2
        `SW_ADDRESS = 32'h00C; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h00D; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h00E; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h00F; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h010; `SW_IMEM = 32'h4CC00006; @(posedge clk); #1; // ST r6, 6(r0) -> DMEM[6]
        `SW_ADDRESS = 32'h011; `SW_IMEM = 32'h1CE21800; @(posedge clk); #1; // VSUB r7, r3, r4
        `SW_ADDRESS = 32'h012; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h013; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h014; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h015; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h016; `SW_IMEM = 32'h4CE00007; @(posedge clk); #1; // ST r7, 7(r0) -> DMEM[7]
        `SW_ADDRESS = 32'h017; `SW_IMEM = 32'h21021800; @(posedge clk); #1; // VMUL r8, r1, r2
        `SW_ADDRESS = 32'h018; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h019; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h01A; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h01B; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h01C; `SW_IMEM = 32'h4D000008; @(posedge clk); #1; // ST r8, 8(r0) -> DMEM[8]
        `SW_ADDRESS = 32'h01D; `SW_IMEM = 32'h25222000; @(posedge clk); #1; // VMAC r9, r2, r4
        `SW_ADDRESS = 32'h01E; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h01F; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h020; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h021; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h022; `SW_IMEM = 32'h4D200009; @(posedge clk); #1; // ST r9, 9(r0) -> DMEM[9]
        `SW_ADDRESS = 32'h023; `SW_IMEM = 32'h29450000; @(posedge clk); #1; // VRELU r3, r9
        `SW_ADDRESS = 32'h024; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h025; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h026; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h027; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h028; `SW_IMEM = 32'h4C600003; @(posedge clk); #1; // ST r3, 3(r0) -> DMEM[3]
        `SW_ADDRESS = 32'h029; `SW_IMEM = 32'h2C000000; @(posedge clk); #1; // HALT
        `SW_ADDRESS = 32'h02A; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h02B; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_INPUT_TYPE = 32'h0;
        $display("  IMEM loaded at cycle %0d", cycle);

        // ---- Load DMEM ----
        // r1=1.5 (3FC0), r2=4.0 (4080), r3=8.0 (4100), r4=-3.0 (C040)
        // Expected results:
        //   VADD r6 = 1.5+4.0  =  5.5  -> 40B040B040B040B0
        //   VSUB r7 = 8.0-(-3) = 11.0  -> 4130413041304130
        //   VMUL r8 = 1.5*4.0  =  6.0  -> 40C040C040C040C0
        //   VMAC r9 = 4.0*(-3) = -12.0 -> C140C140C140C140
        //   VRELU r3= relu(-12) =  0.0  -> 0000000000000000
        `SW_ADDRESS = 32'h00; `SW_DMEM = 32'h3FC03FC0;  // r1 = 1.5
        `SW_INPUT_TYPE = 32'h2; @(posedge clk); #1; `SW_INPUT_TYPE = 32'h0;
        `SW_ADDRESS = 32'h01; `SW_DMEM = 32'h40804080;  // r2 = 4.0
        `SW_INPUT_TYPE = 32'h2; @(posedge clk); #1; `SW_INPUT_TYPE = 32'h0;
        `SW_ADDRESS = 32'h02; `SW_DMEM = 32'h41004100;  // r3 = 8.0
        `SW_INPUT_TYPE = 32'h2; @(posedge clk); #1; `SW_INPUT_TYPE = 32'h0;
        `SW_ADDRESS = 32'h03; `SW_DMEM = 32'hC040C040;  // r4 = -3.0
        `SW_INPUT_TYPE = 32'h2; @(posedge clk); #1; `SW_INPUT_TYPE = 32'h0;
        `SW_ADDRESS = 32'h04; `SW_DMEM = 32'h00000000;
        `SW_INPUT_TYPE = 32'h2; @(posedge clk); #1; `SW_INPUT_TYPE = 32'h0;
        `SW_ADDRESS = 32'h05; `SW_DMEM = 32'h00000000;
        `SW_INPUT_TYPE = 32'h2; @(posedge clk); #1; `SW_INPUT_TYPE = 32'h0;
        `SW_ADDRESS = 32'h06; `SW_DMEM = 32'h00000000;
        `SW_INPUT_TYPE = 32'h2; @(posedge clk); #1; `SW_INPUT_TYPE = 32'h0;
        `SW_ADDRESS = 32'h07; `SW_DMEM = 32'h00000000;
        `SW_INPUT_TYPE = 32'h2; @(posedge clk); #1; `SW_INPUT_TYPE = 32'h0;
        $display("  DMEM loaded at cycle %0d", cycle);

        // ---- Verify DMEM load ----
        $display("");
        $display("  === DMEM LOAD VERIFY ===");
        `SW_ADDRESS = 32'h00; `SW_INPUT_TYPE = 32'h4;
        @(posedge clk); #1; `SW_INPUT_TYPE = 32'h0;
        @(posedge clk); #1;
        $display("  DMEM[0] r1 = %h  (exp 3FC03FC03FC03FC0)", dut.dmem_out);

        `SW_ADDRESS = 32'h01; `SW_INPUT_TYPE = 32'h4;
        @(posedge clk); #1; `SW_INPUT_TYPE = 32'h0;
        @(posedge clk); #1;
        $display("  DMEM[1] r2 = %h  (exp 4080408040804080)", dut.dmem_out);

        `SW_ADDRESS = 32'h02; `SW_INPUT_TYPE = 32'h4;
        @(posedge clk); #1; `SW_INPUT_TYPE = 32'h0;
        @(posedge clk); #1;
        $display("  DMEM[2] r3 = %h  (exp 4100410041004100)", dut.dmem_out);

        `SW_ADDRESS = 32'h03; `SW_INPUT_TYPE = 32'h4;
        @(posedge clk); #1; `SW_INPUT_TYPE = 32'h0;
        @(posedge clk); #1;
        $display("  DMEM[3] r4 = %h  (exp C040C040C040C040)", dut.dmem_out);

        // ---- Set bram params: bram_length=44, bram_inst_addr=0 ----
        @(posedge clk); #1;
        `SW_ADDRESS = 32'h00002C00;  // [15:8]=44=0x2C, [7:0]=0

        // ---- Dispatch: one-cycle gpu_start pulse ----
        @(posedge clk); #1;
        `SW_GPU_CTRL = 32'h1;
        $display("  gpu_start=1 at cycle %0d", cycle);
        @(posedge clk); #1;
        `SW_GPU_CTRL = 32'h0;
        $display("  gpu_start cleared at cycle %0d", cycle);

        // ---- Wait for pipeline_done ----
        begin : wait_done
            integer timeout;
            timeout = 0;
            while (!`PIPELINE_DONE && timeout < 500) begin
                @(posedge clk);
                timeout = timeout + 1;
            end
            if (`PIPELINE_DONE)
                $display("  pipeline_done at cycle %0d", cycle);
            else
                $display("  [FAIL] pipeline_done timeout after 500 cycles");
        end

        // Wait for all in-flight ST instructions to fully clear MEM stage
        // Last ST needs EX->MEM->WB to complete after pipeline_done
        repeat(50) @(posedge clk); #1;

        // ---- DMEM Readback ----
        $display("");
        $display("  === DMEM READBACK ===");

        `SW_ADDRESS = 32'h00; `SW_INPUT_TYPE = 32'h4;
        @(posedge clk); #1; `SW_INPUT_TYPE = 32'h0;
        @(posedge clk); #1;
        $display("  DMEM[6]  VADD  r6 = %h  (exp 40B040B040B040B0)", dut.dmem_out);

        `SW_ADDRESS = 32'h01; `SW_INPUT_TYPE = 32'h4;
        @(posedge clk); #1; `SW_INPUT_TYPE = 32'h0;
        @(posedge clk); #1;
        $display("  DMEM[7]  VSUB  r7 = %h  (exp 4130413041304130)", dut.dmem_out);

        `SW_ADDRESS = 32'h02; `SW_INPUT_TYPE = 32'h4;
        @(posedge clk); #1; `SW_INPUT_TYPE = 32'h0;
        @(posedge clk); #1;
        $display("  DMEM[8]  VMUL  r8 = %h  (exp 40C040C040C040C0)", dut.dmem_out);

        `SW_ADDRESS = 32'h03; `SW_INPUT_TYPE = 32'h4;
        @(posedge clk); #1; `SW_INPUT_TYPE = 32'h0;
        @(posedge clk); #1;
        $display("  DMEM[9]  VMAC  r9 = %h  (exp C140C140C140C140)", dut.dmem_out);

        `SW_ADDRESS = 32'h03; `SW_INPUT_TYPE = 32'h4;
        @(posedge clk); #1; `SW_INPUT_TYPE = 32'h0;
        @(posedge clk); #1;
        $display("  DMEM[3]  VRELU r3 = %h  (exp 0000000000000000)", dut.dmem_out);

        $display("");
        $display("  === TENSOR INTERCEPT ===");
        $display("  tensor_out = %h", `TENSOR_OUT);

        #100;
        $stop;
    end

endmodule