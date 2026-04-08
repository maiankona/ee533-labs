`timescale 1ns/1ps

`define UDP_REG_ADDR_WIDTH 23
`define CPCI_NF2_DATA_WIDTH 32

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


module tb_ids_cpu_gpu;

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

    // --- ARM control ---
    reg         cpu_start;
    reg         arm_write_to_imem;
    reg  [8:0]  arm_addr_imem_host;
    reg  [31:0] arm_data_imem_host;

    // --- DUT ---
    ids dut (
        .in_data              (in_data),
        .in_ctrl              (in_ctrl),
        .in_wr                (in_wr),
        .in_rdy               (in_rdy),
        .out_data             (out_data),
        .out_ctrl             (out_ctrl),
        .out_wr               (out_wr),
        .out_rdy              (out_rdy),
        .reg_req_in           (reg_req_in),
        .reg_ack_in           (reg_ack_in),
        .reg_rd_wr_L_in       (reg_rd_wr_L_in),
        .reg_addr_in          (reg_addr_in),
        .reg_data_in          (reg_data_in),
        .reg_src_in           (reg_src_in),
        .reg_req_out          (reg_req_out),
        .reg_ack_out          (reg_ack_out),
        .reg_rd_wr_L_out      (reg_rd_wr_L_out),
        .reg_addr_out         (reg_addr_out),
        .reg_data_out         (reg_data_out),
        .reg_src_out          (reg_src_out),
        .clk                  (clk),
        .reset                (reset),
        .cpu_start            (cpu_start),
        .arm_write_to_imem    (arm_write_to_imem),
        .arm_addr_imem_host   (arm_addr_imem_host),
        .arm_data_imem_host   (arm_data_imem_host)
    );

    // --- Clock: 125 MHz ---
    initial clk = 0;
    always #4 clk = ~clk;

    integer cycle;
    initial cycle = 0;
    always @(posedge clk) cycle = cycle + 1;

    `define TENSOR_OUT dut.gpu_Unit.tensor_out_intercept
    `define GPU_IRQ    dut.gpu_irq

    // ----------------------------------------------------------------
    // Task: arm_imem_write
    // Loads one ARM instruction into ARM IMEM via host backdoor
    // ----------------------------------------------------------------
    task arm_imem_write;
        input [8:0]  addr;
        input [31:0] instr;
        begin
            @(negedge clk);
            arm_write_to_imem  = 1'b1;
            arm_addr_imem_host = addr;
            arm_data_imem_host = instr;
            @(negedge clk);
            arm_write_to_imem  = 1'b0;
        end
    endtask

    // --- WB monitor ---
    always @(posedge clk) begin
        if (dut.gpu_Unit.wb_wreg_en && dut.gpu_Unit.wb_wreg_addr != 0)
            $display("  Cycle %0d  WB r%-2d <- %h",
                cycle, dut.gpu_Unit.wb_wreg_addr, dut.gpu_Unit.wb_data);
    end

    // ----------------------------------------------------------------
    // ARM program:
    //   MOV R1, #0x00  ; GPU IMEM base addr
    //   MOV R2, #0x2C  ; GPU program length = 44
    //   MOV R3, #0xF0  ; ctrl cfg_base addr
    //   MOV R4, #0xF1  ; ctrl cfg_len addr
    //   MOV R5, #0xF2  ; ctrl dispatch addr
    //   STR R1, [R3]   ; write base -> 0xF0
    //   STR R2, [R4]   ; write len  -> 0xF1
    //   STR R1, [R5]   ; dispatch   -> 0xF2
    //   B .            ; halt
    // ----------------------------------------------------------------
    localparam MOV_R1_0x00 = 32'hE3A01000;
    localparam MOV_R2_0x2C = 32'hE3A0202C;
    localparam MOV_R3_0xF0 = 32'hE3A030F0;
    localparam MOV_R4_0xF1 = 32'hE3A040F1;
    localparam MOV_R5_0xF2 = 32'hE3A050F2;
    localparam STR_R1_R3   = 32'hE5831000;
    localparam STR_R2_R4   = 32'hE5842000;
    localparam STR_R1_R5   = 32'hE5851000;
    localparam B_SELF      = 32'hEAFFFFFE;

    initial begin
        in_data              = 0;
        in_ctrl              = 0;
        in_wr                = 0;
        out_rdy              = 1;
        reg_req_in           = 0;
        reg_ack_in           = 0;
        reg_rd_wr_L_in       = 1;
        reg_addr_in          = 0;
        reg_data_in          = 0;
        reg_src_in           = 0;
        cpu_start            = 1'b0;
        arm_write_to_imem    = 1'b0;
        arm_addr_imem_host   = 9'h0;
        arm_data_imem_host   = 32'h0;

        // Hold GPU DMEM host signals idle
        force dut.write_to_dmem  = 1'b0;
        force dut.read_req_dmem  = 1'b0;
        force dut.addr_dmem_host = 8'h0;
        force dut.data_dmem_host = 64'h0;

        reset = 1;
        repeat(4) @(posedge clk);
        #1; reset = 0;
        $display("  Reset released at cycle %0d", cycle);

        // ================================================================
        // PHASE 1: Load GPU IMEM via force
        // ================================================================
        $display("  Loading GPU IMEM...");
        force dut.gpu_imem_we    = 1'b1;
        force dut.addr_imem_host = 9'h000; force dut.data_imem_host = 32'h48400000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h001; force dut.data_imem_host = 32'h48600004; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h002; force dut.data_imem_host = 32'h48800008; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h003; force dut.data_imem_host = 32'h48A0000C; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h004; force dut.data_imem_host = 32'h00000000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h005; force dut.data_imem_host = 32'h00000000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h006; force dut.data_imem_host = 32'h00000000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h007; force dut.data_imem_host = 32'h00000000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h008; force dut.data_imem_host = 32'h00000000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h009; force dut.data_imem_host = 32'h00000000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h00A; force dut.data_imem_host = 32'h00000000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h00B; force dut.data_imem_host = 32'h18C21800; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h00C; force dut.data_imem_host = 32'h00000000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h00D; force dut.data_imem_host = 32'h00000000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h00E; force dut.data_imem_host = 32'h00000000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h00F; force dut.data_imem_host = 32'h00000000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h010; force dut.data_imem_host = 32'h4CC00006; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h011; force dut.data_imem_host = 32'h1CE21800; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h012; force dut.data_imem_host = 32'h00000000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h013; force dut.data_imem_host = 32'h00000000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h014; force dut.data_imem_host = 32'h00000000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h015; force dut.data_imem_host = 32'h00000000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h016; force dut.data_imem_host = 32'h4CE00007; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h017; force dut.data_imem_host = 32'h21021800; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h018; force dut.data_imem_host = 32'h00000000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h019; force dut.data_imem_host = 32'h00000000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h01A; force dut.data_imem_host = 32'h00000000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h01B; force dut.data_imem_host = 32'h00000000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h01C; force dut.data_imem_host = 32'h4D000008; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h01D; force dut.data_imem_host = 32'h25222000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h01E; force dut.data_imem_host = 32'h00000000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h01F; force dut.data_imem_host = 32'h00000000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h020; force dut.data_imem_host = 32'h00000000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h021; force dut.data_imem_host = 32'h00000000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h022; force dut.data_imem_host = 32'h4D200009; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h023; force dut.data_imem_host = 32'h29450000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h024; force dut.data_imem_host = 32'h00000000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h025; force dut.data_imem_host = 32'h00000000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h026; force dut.data_imem_host = 32'h00000000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h027; force dut.data_imem_host = 32'h00000000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h028; force dut.data_imem_host = 32'h4C600003; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h029; force dut.data_imem_host = 32'h2C000000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h02A; force dut.data_imem_host = 32'h00000000; @(posedge clk); #1;
        force dut.addr_imem_host = 9'h02B; force dut.data_imem_host = 32'h00000000; @(posedge clk); #1;
        force dut.gpu_imem_we    = 1'b0;
        $display("  GPU IMEM loaded at cycle %0d", cycle);

        // ================================================================
        // PHASE 2: Load GPU DMEM via force
        // r1=1.5, r2=4.0, r3=8.0, r4=-3.0
        // ================================================================
        $display("  Loading GPU DMEM...");
        force dut.write_to_dmem  = 1'b1;
        force dut.addr_dmem_host = 8'h00; force dut.data_dmem_host = 64'h3FC03FC03FC03FC0; @(posedge clk); #1;
        force dut.addr_dmem_host = 8'h01; force dut.data_dmem_host = 64'h4080408040804080; @(posedge clk); #1;
        force dut.addr_dmem_host = 8'h02; force dut.data_dmem_host = 64'h4100410041004100; @(posedge clk); #1;
        force dut.addr_dmem_host = 8'h03; force dut.data_dmem_host = 64'hC040C040C040C040; @(posedge clk); #1;
        force dut.addr_dmem_host = 8'h04; force dut.data_dmem_host = 64'h0; @(posedge clk); #1;
        force dut.addr_dmem_host = 8'h05; force dut.data_dmem_host = 64'h0; @(posedge clk); #1;
        force dut.addr_dmem_host = 8'h06; force dut.data_dmem_host = 64'h0; @(posedge clk); #1;
        force dut.addr_dmem_host = 8'h07; force dut.data_dmem_host = 64'h0; @(posedge clk); #1;
        force dut.write_to_dmem  = 1'b0;
        force dut.addr_dmem_host = 8'h0;
        force dut.data_dmem_host = 64'h0;
        $display("  GPU DMEM loaded at cycle %0d", cycle);

        // ================================================================
        // PHASE 3: Load ARM IMEM via backdoor
        // ================================================================
        $display("  Loading ARM IMEM...");
        arm_imem_write(9'h000, MOV_R1_0x00);
        arm_imem_write(9'h001, MOV_R2_0x2C);
        arm_imem_write(9'h002, MOV_R3_0xF0);
        arm_imem_write(9'h003, MOV_R4_0xF1);
        arm_imem_write(9'h004, MOV_R5_0xF2);
        arm_imem_write(9'h005, STR_R1_R3);
        arm_imem_write(9'h006, STR_R2_R4);
        arm_imem_write(9'h007, STR_R1_R5);
        arm_imem_write(9'h008, B_SELF);
        $display("  ARM IMEM loaded at cycle %0d", cycle);

        // ================================================================
        // PHASE 4: Release ARM - executes dispatch sequence autonomously
        // ================================================================
        @(negedge clk);
        cpu_start = 1'b1;
        @(negedge clk);
        cpu_start = 1'b0;
        $display("  cpu_start pulsed at cycle %0d - ARM executing", cycle);

        // ================================================================
        // PHASE 5: Wait for gpu_irq
        // ================================================================
        $display("  Waiting for gpu_irq...");
        while (!`GPU_IRQ) @(posedge clk);
        $display("  gpu_irq raised at cycle %0d", cycle);

        // Wait for all in-flight STs to clear MEM stage
        repeat(50) @(posedge clk); #1;

        // ================================================================
        // PHASE 6: DMEM Readback
        // ================================================================
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
        #500000;
        $display("  [TIMEOUT] simulation exceeded limit at cycle %0d", cycle);
        $stop;
    end

endmodule