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

    // --- gpu_control_interface_2 host bus ---
    reg  [7:0]  host_addr;
    reg  [63:0] host_data;
    reg         host_we;

    // --- ctrl unit outputs wired into ids ---
    wire        gpu_start_ctrl;
    wire [7:0]  bram_inst_addr_ctrl;
    wire [7:0]  bram_length_ctrl;
    wire        gpu_irq;
    wire        imem_we_en;         // not connected to ids (ids uses SW_INPUT_TYPE[3])

    // --- pipeline_done from ids back to ctrl unit ---
    wire        pipeline_done;
    assign pipeline_done = dut.pipeline_done;

    // ----------------------------------------------------------------
    // ids instantiation
    // gpu_start, bram_inst_addr, bram_length now driven by ctrl unit
    // but ids.v still derives them from SW regs internally.
    // We override by forcing the SW regs to match ctrl outputs,
    // OR: keep IMEM/DMEM loading via SW regs as before,
    // and only override gpu_ctrl[0]/address via the ctrl unit signals.
    // Since ids wires gpu_start = gpu_ctrl[0] and bram* = address[15:0],
    // we backdoor-force those SW regs from ctrl outputs below.
    // ----------------------------------------------------------------
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

    // ----------------------------------------------------------------
    // gpu_control_interface_2 instantiation (Option B: beside ids)
    // Taps host_addr/host_data/host_we from TB.
    // Outputs gpu_start, bram_inst_addr, bram_length override ids SW regs.
    // pipeline_done tapped from ids internal wire.
    // ----------------------------------------------------------------
    gpu_control_interface_2 ctrl (
        .clk            (clk),
        .rst            (reset),
        .host_addr      (host_addr),
        .host_data      (host_data),
        .host_we        (host_we),
        .gpu_irq        (gpu_irq),
        .gpu_start      (gpu_start_ctrl),
        .bram_inst_addr (bram_inst_addr_ctrl),
        .bram_length    (bram_length_ctrl),
        .pipeline_done  (pipeline_done),
        .imem_we_en     (imem_we_en)
    );

    // ----------------------------------------------------------------
    // Override ids SW regs from ctrl unit outputs.
    // ids derives:
    //   gpu_start      = gpu_ctrl[0]         -> SW_GPU_CTRL[0]
    //   bram_inst_addr = address[7:0]         -> SW_ADDRESS[7:0]
    //   bram_length    = address[15:8]        -> SW_ADDRESS[15:8]
    // We force these whenever the ctrl unit drives them.
    // ----------------------------------------------------------------
    always @(*) begin
        dut.module_regs.sw_regs[159:128] = {31'b0, gpu_start_ctrl};        // SW_GPU_CTRL
        dut.module_regs.sw_regs[63:48]   = {bram_length_ctrl,              // address[15:8]
                                             bram_inst_addr_ctrl};          // address[7:0]
    end

    // --- Clock: 125 MHz ---
    initial clk = 0;
    always #4 clk = ~clk;

    integer cycle;
    initial cycle = 0;
    always @(posedge clk) cycle = cycle + 1;

    // --- SW reg aliases (IMEM/DMEM loading unchanged) ---
    `define SW_INPUT_TYPE dut.module_regs.sw_regs[31:0]
    `define SW_ADDRESS    dut.module_regs.sw_regs[63:32]
    `define SW_IMEM       dut.module_regs.sw_regs[95:64]
    `define SW_DMEM       dut.module_regs.sw_regs[127:96]

    `define PIPELINE_DONE dut.pipeline_done
    `define TENSOR_OUT    dut.gpu_Unit.tensor_out_intercept

    // --- Task: single MMIO write to ctrl unit ---
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

    // --- Task: dispatch GPU program via ctrl unit ---
    //   0xF0 <- bram_inst_addr
    //   0xF1 <- bram_length
    //   0xF2 <- dispatch (data ignored)
    task dispatch_program;
        input [7:0] inst_addr;
        input [7:0] length;
        begin
            mmio_write(8'hF0, {56'h0, inst_addr});
            mmio_write(8'hF1, {56'h0, length});
            mmio_write(8'hF2, 64'hDEAD);
        end
    endtask

    // --- Task: wait for gpu_irq then ack ---
    task wait_and_ack;
        begin
            while (!gpu_irq) @(posedge clk);
            $display("  gpu_irq raised at cycle %0d", cycle);
            #8;
            mmio_write(8'hF3, 64'h0);
            $display("  arm_irq_ack sent at cycle %0d", cycle);
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
        host_addr      = 8'h00;
        host_data      = 64'h0;
        host_we        = 1'b0;

        reset = 1;
        repeat(2) @(posedge clk);
        #1; reset = 0;
        $display("  Reset released at cycle %0d", cycle);

        // ---- Load IMEM via SW regs (unchanged) ----
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
        `SW_ADDRESS = 32'h010; `SW_IMEM = 32'h4CC00006; @(posedge clk); #1; // ST r6, 6(r0)
        `SW_ADDRESS = 32'h011; `SW_IMEM = 32'h1CE21800; @(posedge clk); #1; // VSUB r7, r3, r4
        `SW_ADDRESS = 32'h012; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h013; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h014; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h015; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h016; `SW_IMEM = 32'h4CE00007; @(posedge clk); #1; // ST r7, 7(r0)
        `SW_ADDRESS = 32'h017; `SW_IMEM = 32'h21021800; @(posedge clk); #1; // VMUL r8, r1, r2
        `SW_ADDRESS = 32'h018; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h019; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h01A; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h01B; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h01C; `SW_IMEM = 32'h4D000008; @(posedge clk); #1; // ST r8, 8(r0)
        `SW_ADDRESS = 32'h01D; `SW_IMEM = 32'h25222000; @(posedge clk); #1; // VMAC r9, r2, r4
        `SW_ADDRESS = 32'h01E; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h01F; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h020; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h021; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h022; `SW_IMEM = 32'h4D200009; @(posedge clk); #1; // ST r9, 9(r0)
        `SW_ADDRESS = 32'h023; `SW_IMEM = 32'h29450000; @(posedge clk); #1; // VRELU r3, r9
        `SW_ADDRESS = 32'h024; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h025; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h026; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h027; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h028; `SW_IMEM = 32'h4C600003; @(posedge clk); #1; // ST r3, 3(r0)
        `SW_ADDRESS = 32'h029; `SW_IMEM = 32'h2C000000; @(posedge clk); #1; // HALT
        `SW_ADDRESS = 32'h02A; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_ADDRESS = 32'h02B; `SW_IMEM = 32'h00000000; @(posedge clk); #1; // NOP
        `SW_INPUT_TYPE = 32'h0;
        $display("  IMEM loaded at cycle %0d", cycle);

        // ---- Load DMEM via SW regs (unchanged) ----
        `SW_ADDRESS = 32'h00; `SW_DMEM = 32'h3FC03FC0;
        `SW_INPUT_TYPE = 32'h2; @(posedge clk); #1; `SW_INPUT_TYPE = 32'h0;
        `SW_ADDRESS = 32'h01; `SW_DMEM = 32'h40804080;
        `SW_INPUT_TYPE = 32'h2; @(posedge clk); #1; `SW_INPUT_TYPE = 32'h0;
        `SW_ADDRESS = 32'h02; `SW_DMEM = 32'h41004100;
        `SW_INPUT_TYPE = 32'h2; @(posedge clk); #1; `SW_INPUT_TYPE = 32'h0;
        `SW_ADDRESS = 32'h03; `SW_DMEM = 32'hC040C040;
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

        // ---- DMEM load verify ----
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

        // ---- Dispatch via ctrl unit (replaces direct SW_GPU_CTRL writes) ----
        // inst_addr=0x00, length=0x2C (44 instructions)
        @(posedge clk); #1;
        $display("");
        $display("  === DISPATCHING VIA CTRL UNIT ===");
        dispatch_program(8'h00, 8'h2C);
        $display("  dispatch_program sent at cycle %0d", cycle);

        // ---- Wait for pipeline_done via gpu_irq ----
        wait_and_ack;

        // Wait for all in-flight ST instructions to clear MEM stage
        repeat(50) @(posedge clk); #1;

        // ---- DMEM Readback (unchanged) ----
        $display("");
        $display("  === DMEM READBACK ===");

        `SW_ADDRESS = 32'h06; `SW_INPUT_TYPE = 32'h4;
        @(posedge clk); #1; `SW_INPUT_TYPE = 32'h0;
        @(posedge clk); #1;
        $display("  DMEM[6]  VADD  r6 = %h  (exp 40B040B040B040B0)", dut.dmem_out);

        `SW_ADDRESS = 32'h07; `SW_INPUT_TYPE = 32'h4;
        @(posedge clk); #1; `SW_INPUT_TYPE = 32'h0;
        @(posedge clk); #1;
        $display("  DMEM[7]  VSUB  r7 = %h  (exp 4130413041304130)", dut.dmem_out);

        `SW_ADDRESS = 32'h08; `SW_INPUT_TYPE = 32'h4;
        @(posedge clk); #1; `SW_INPUT_TYPE = 32'h0;
        @(posedge clk); #1;
        $display("  DMEM[8]  VMUL  r8 = %h  (exp 40C040C040C040C0)", dut.dmem_out);

        `SW_ADDRESS = 32'h09; `SW_INPUT_TYPE = 32'h4;
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

    // --- Timeout watchdog ---
    initial begin
        #200000;
        $display("  [TIMEOUT] simulation exceeded limit at cycle %0d", cycle);
        $stop;
    end

endmodule