`timescale 1ns/1ps

// =============================================================================
// tb_ann_neuron.v  (lab9_work_in_progress)
// One-neuron ANN forward pass - adapted from lab9_melvin_working for integrated ids:
//   - SW regs via UDP-style reg_write (same as tb_host_cpu_gpu_fifo.v)
//   - ids.v input_type: [0] write_to_imem, [1] write_to_dmem, [2] read_req_dmem,
//                      [3] GPU start edge, [4] arm_imem_we
//   - ARM IMEM: input_type[4] via SW reg (address + imem regs reused)
//   - ARM run: cpu_ctrl SW reg [0] rising-edge detect in ids.v
//   - gpu_irq: dut.gpu_ctrl.gpu_irq
// Do not compile this file together with another module that defines generic_regs.
// =============================================================================
//   inputs:  x1..x4, weights w1..w4 in GPU DMEM[0..7]
//   GPU: LW, VMACs, VRELU, ST -> DMEM[8]
//   ARM: MOV/STR to 0xF0-0xF2 (gpu_control_interface_2), then cpu_start
//   Expected DMEM[8] / tensor: 0x3F003F003F003F00 (BF16 0.5 x4 lanes)
//
// Simulation footprint: integrated ids is large. This TB avoids per-clock trace
// $display (was flooding logs / simulator memory). Optional: +define+TB_ANN_TRACE_WB
// For waveform OOM: reduce scope in the simulator or disable VCD/WLF dump.
// =============================================================================

`define UDP_REG_ADDR_WIDTH 23
`define CPCI_NF2_DATA_WIDTH 32
`define IDS_BLOCK_ADDR      19'h00008

// ----------------------------------------------------------------
// Behavioral generic_regs (must match ids.v software_regs pack)
// software_regs = {cpu_ctrl, dmem_hi, dmem_lo, imem, address, input_type}
//   reg 0 = input_type  ids.v reg_addr[3:0] == 4'h0
//   reg 1 = address
//   reg 2 = imem
//   reg 3 = dmem_lo
//   reg 4 = dmem_hi
//   reg 5 = cpu_ctrl    [0] = cpu_start rising-edge detect
// ----------------------------------------------------------------
module generic_regs #(
    parameter UDP_REG_SRC_WIDTH = 2,
    parameter TAG               = 0,
    parameter REG_ADDR_WIDTH    = 4,
    parameter NUM_COUNTERS      = 0,
    parameter NUM_SOFTWARE_REGS = 6,
    parameter NUM_HARDWARE_REGS = 4
) (
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
    assign reg_ack_out     = reg_req_in;
    assign reg_rd_wr_L_out = reg_rd_wr_L_in;
    assign reg_addr_out    = reg_addr_in;
    assign reg_data_out    = reg_data_in;
    assign reg_src_out     = reg_src_in;

    reg [31:0] r_cpu_ctrl;
    reg [31:0] r_dmem_hi;
    reg [31:0] r_dmem_lo;
    reg [31:0] r_imem;
    reg [31:0] r_address;
    reg [31:0] r_input_type;

    // Pack order must match ids.v software_regs assignment:
    // {cpu_ctrl, dmem_in_hi, dmem_in_lo, imem, address, input_type}
    assign software_regs = {r_cpu_ctrl, r_dmem_hi, r_dmem_lo,
                            r_imem, r_address, r_input_type};

    always @(posedge clk) begin
        if (reset) begin
            r_cpu_ctrl   <= 32'h0;
            r_dmem_hi    <= 32'h0;
            r_dmem_lo    <= 32'h0;
            r_imem       <= 32'h0;
            r_address    <= 32'h0;
            r_input_type <= 32'h0;
        end else if (reg_req_in && !reg_rd_wr_L_in && reg_addr_in[22:4] == TAG) begin
            case (reg_addr_in[3:0])
                4'h0: r_input_type <= reg_data_in;
                4'h1: r_address    <= reg_data_in;
                4'h2: r_imem       <= reg_data_in;
                4'h3: r_dmem_lo    <= reg_data_in;
                4'h4: r_dmem_hi    <= reg_data_in;
                4'h5: r_cpu_ctrl   <= reg_data_in;
                default: ;
            endcase
        end
    end
endmodule

// =============================================================================
module tb_ann_neuron;

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

    reg         clk;
    reg         reset;

    // SW register address map (matches ids.v generic_regs pack order)
    localparam [22:0] REG_INPUT_TYPE = {`IDS_BLOCK_ADDR, 4'h0};
    localparam [22:0] REG_ADDRESS    = {`IDS_BLOCK_ADDR, 4'h1};
    localparam [22:0] REG_IMEM       = {`IDS_BLOCK_ADDR, 4'h2};
    localparam [22:0] REG_DMEM_LO    = {`IDS_BLOCK_ADDR, 4'h3};
    localparam [22:0] REG_DMEM_HI    = {`IDS_BLOCK_ADDR, 4'h4};
    localparam [22:0] REG_CPU_CTRL   = {`IDS_BLOCK_ADDR, 4'h5}; // [0]=cpu_start

    localparam [31:0] ITYPE_WRITE_IMEM     = 32'h1;  // input_type[0] = write_to_imem (GPU)
    localparam [31:0] ITYPE_WRITE_DMEM     = 32'h2;  // input_type[1] = write_to_dmem
    localparam [31:0] ITYPE_READ_DMEM      = 32'h4;  // input_type[2] = read_req_dmem
    localparam [31:0] ITYPE_WRITE_ARM_IMEM = 32'h10; // input_type[4] = arm_imem_we

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

    initial clk = 0;
    always #4 clk = ~clk;

    // ----------------------------------------------------------------
    // Task: reg_write
    // ----------------------------------------------------------------
    task reg_write;
        input [22:0] addr;
        input [31:0] data;
        begin
            @(negedge clk);
            reg_addr_in    = addr;
            reg_data_in    = data;
            reg_rd_wr_L_in = 1'b0;
            reg_req_in     = 1'b1;
            @(posedge clk);
            @(negedge clk);
            reg_req_in     = 1'b0;
            reg_rd_wr_L_in = 1'b1;
            @(negedge clk);
        end
    endtask

    // ----------------------------------------------------------------
    // Task: pulse_input_type
    // ----------------------------------------------------------------
    task pulse_input_type;
        input [31:0] mask_one_cycle;
        begin
            reg_write(REG_INPUT_TYPE, mask_one_cycle);
            reg_write(REG_INPUT_TYPE, 32'h0);
        end
    endtask

    // ----------------------------------------------------------------
    // Task: host_dmem_write64
    // Writes 64-bit BF16 value to shared DMEM and displays result
    // ----------------------------------------------------------------
    task host_dmem_write64;
        input [7:0]  byte_addr;
        input [31:0] lo;
        input [31:0] hi;
        begin
            reg_write(REG_ADDRESS, {24'h0, byte_addr});
            reg_write(REG_DMEM_LO, lo);
            reg_write(REG_DMEM_HI, hi);
            pulse_input_type(ITYPE_WRITE_DMEM);
            $display("  [GPU DMEM wr] addr=0x%02X  data=0x%08X_%08X",
                byte_addr, hi, lo);
        end
    endtask

    // ----------------------------------------------------------------
    // Task: host_dmem_read_req
    // ----------------------------------------------------------------
    task host_dmem_read_req;
        input [7:0] byte_addr;
        begin
            reg_write(REG_ADDRESS, {24'h0, byte_addr});
            pulse_input_type(ITYPE_READ_DMEM);
            repeat (6) @(posedge clk);
        end
    endtask

    // ----------------------------------------------------------------
    // Task: write_gpu_imem
    // Writes one instruction to GPU IMEM and displays result
    // ----------------------------------------------------------------
    task write_gpu_imem;
        input [8:0]  addr;
        input [31:0] instr;
        begin
            reg_write(REG_ADDRESS, {23'h0, addr});
            reg_write(REG_IMEM, instr);
            pulse_input_type(ITYPE_WRITE_IMEM);
            $display("  [GPU IMEM wr] addr=0x%03X  instr=0x%08X", addr, instr);
        end
    endtask

    // ----------------------------------------------------------------
    // Task: arm_imem_write
    // Writes one instruction to ARM IMEM via input_type[4] SW reg path
    // Reuses address and imem SW regs (same bus, different enable bit)
    // ----------------------------------------------------------------
    task arm_imem_write;
        input [8:0]  addr;
        input [31:0] instr;
        begin
            reg_write(REG_ADDRESS, {23'h0, addr});
            reg_write(REG_IMEM, instr);
            pulse_input_type(ITYPE_WRITE_ARM_IMEM);
            $display("  [ARM IMEM wr] addr=0x%03X  instr=0x%08X", addr, instr);
        end
    endtask

    // ----------------------------------------------------------------
    // Task: pulse_cpu_start
    // Writes 1 then 0 to cpu_ctrl SW reg
    // Rising edge detector in ids.v fires cpu_start one cycle
    // ----------------------------------------------------------------
    task pulse_cpu_start;
        begin
            reg_write(REG_CPU_CTRL, 32'h1);  // cpu_ctrl[0] = 1
            reg_write(REG_CPU_CTRL, 32'h0);  // cpu_ctrl[0] = 0 -> rising edge fires
        end
    endtask

`ifdef TB_ANN_TRACE_WB
    always @(posedge clk) begin
        if (!reset && dut.gpu_Unit.wb_wreg_en && dut.gpu_Unit.wb_wreg_addr != 0)
            $display("  [GPU WB] time=%0t  r%-2d <- %h",
                $time, dut.gpu_Unit.wb_wreg_addr, dut.gpu_Unit.wb_data);
    end
`endif

    // ----------------------------------------------------------------
    // Monitor: ARM MEM stage stores -> shows ctrl unit dispatch traffic
    // ----------------------------------------------------------------
    always @(posedge clk) begin
        if (!reset && dut.arm_cpu.me_wme)
            $display("  [ARM STR] addr=0x%02X  data=0x%08X",
                dut.arm_cpu.me_alu_res[7:0], dut.arm_cpu.me_store_data);
    end

    // ----------------------------------------------------------------
    // GPU ISA constants
    // LW/ST effective address = r0 + imm, imm14 = insn[15:2]
    // Byte address n -> encode as insn[15:0] = n << 2
    // ----------------------------------------------------------------
    localparam LW_R1_0       = 32'h48200000; // n=0 -> 0<<2
    localparam LW_R2_1       = 32'h48400004; // n=1 -> 1<<2
    localparam LW_R3_2       = 32'h48600008; // n=2 -> 2<<2
    localparam LW_R4_3       = 32'h4880000C; // n=3 -> 3<<2
    localparam LW_R5_4       = 32'h48A00010; // n=4 -> 4<<2
    localparam LW_R6_5       = 32'h48C00014; // n=5 -> 5<<2
    localparam LW_R7_6       = 32'h48E00018; // n=6 -> 6<<2
    localparam LW_R8_7       = 32'h4900001C; // n=7 -> 7<<2
    localparam VMAC_R9_R1_R5 = 32'h25212800;
    localparam VMAC_R9_R2_R6 = 32'h25223000;
    localparam VMAC_R9_R3_R7 = 32'h25233800;
    localparam VMAC_R9_R4_R8 = 32'h25244000;
    localparam VRELU_R10_R9  = 32'h29490000;
    localparam ST_R10_8      = 32'h4D400020; // n=8 -> 8<<2
    localparam NOP           = 32'h00000000;
    localparam HALT          = 32'h2C000000;

    // ARM instruction encodings
    localparam ARM_MOV_R1_0x00    = 32'hE3A01000;
    localparam ARM_MOV_R2_BRAM_LEN = 32'hE3A02038; // #56 (IMEM 0x000..0x037)
    localparam ARM_MOV_R3_0xF0    = 32'hE3A030F0;
    localparam ARM_MOV_R4_0xF1    = 32'hE3A040F1;
    localparam ARM_MOV_R5_0xF2    = 32'hE3A050F2;
    localparam ARM_STR_R1_R3      = 32'hE5831000;
    localparam ARM_STR_R2_R4      = 32'hE5842000;
    localparam ARM_STR_R1_R5      = 32'hE5851000;
    localparam ARM_NOP            = 32'hE1A00000;
    localparam ARM_B_SELF         = 32'hEAFFFFFE;

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
        repeat (4) @(posedge clk);
        #1 reset = 0;
        $display("");
        $display("=== tb_ann_neuron: reset released at time %0t ===", $time);

        // ============================================================
        // PHASE 1: Load GPU IMEM
        // input_type[0] = write_to_imem
        // 7 NOPs between each VMAC for tensor WB latency
        // ============================================================
        $display("");
        $display("  Phase 1: GPU IMEM load (input_type[0] = write_to_imem)");
        $display("  ---------------------------------------------------------");
        write_gpu_imem(9'h000, LW_R1_0);
        write_gpu_imem(9'h001, LW_R2_1);
        write_gpu_imem(9'h002, LW_R3_2);
        write_gpu_imem(9'h003, LW_R4_3);
        write_gpu_imem(9'h004, LW_R5_4);
        write_gpu_imem(9'h005, LW_R6_5);
        write_gpu_imem(9'h006, LW_R7_6);
        write_gpu_imem(9'h007, LW_R8_7);
        write_gpu_imem(9'h008, NOP);             // NOP x4: wait for LW pipeline
        write_gpu_imem(9'h009, NOP);
        write_gpu_imem(9'h00A, NOP);
        write_gpu_imem(9'h00B, NOP);
        write_gpu_imem(9'h00C, VMAC_R9_R1_R5);  // r9 = x1*w1
        write_gpu_imem(9'h00D, NOP);             // NOP x7: tensor WB latency
        write_gpu_imem(9'h00E, NOP);
        write_gpu_imem(9'h00F, NOP);
        write_gpu_imem(9'h010, NOP);
        write_gpu_imem(9'h011, NOP);
        write_gpu_imem(9'h012, NOP);
        write_gpu_imem(9'h013, NOP);
        write_gpu_imem(9'h014, VMAC_R9_R2_R6);  // r9 += x2*w2
        write_gpu_imem(9'h015, NOP);             // NOP x7: tensor WB latency
        write_gpu_imem(9'h016, NOP);
        write_gpu_imem(9'h017, NOP);
        write_gpu_imem(9'h018, NOP);
        write_gpu_imem(9'h019, NOP);
        write_gpu_imem(9'h01A, NOP);
        write_gpu_imem(9'h01B, NOP);
        write_gpu_imem(9'h01C, VMAC_R9_R3_R7);  // r9 += x3*w3
        write_gpu_imem(9'h01D, NOP);             // NOP x7: tensor WB latency
        write_gpu_imem(9'h01E, NOP);
        write_gpu_imem(9'h01F, NOP);
        write_gpu_imem(9'h020, NOP);
        write_gpu_imem(9'h021, NOP);
        write_gpu_imem(9'h022, NOP);
        write_gpu_imem(9'h023, NOP);
        write_gpu_imem(9'h024, VMAC_R9_R4_R8);  // r9 += x4*w4
        write_gpu_imem(9'h025, NOP);             // NOP x7: tensor WB latency
        write_gpu_imem(9'h026, NOP);
        write_gpu_imem(9'h027, NOP);
        write_gpu_imem(9'h028, NOP);
        write_gpu_imem(9'h029, NOP);
        write_gpu_imem(9'h02A, NOP);
        write_gpu_imem(9'h02B, NOP);
        write_gpu_imem(9'h02C, VRELU_R10_R9);   // r10 = relu(r9)
        write_gpu_imem(9'h02D, NOP);             // NOP x4: VRELU latency
        write_gpu_imem(9'h02E, NOP);
        write_gpu_imem(9'h02F, NOP);
        write_gpu_imem(9'h030, NOP);
        write_gpu_imem(9'h031, NOP);
        write_gpu_imem(9'h032, NOP);
        write_gpu_imem(9'h033, ST_R10_8);        // DMEM[8] = r10
        write_gpu_imem(9'h034, NOP);
        write_gpu_imem(9'h035, NOP);
        write_gpu_imem(9'h036, NOP);
        write_gpu_imem(9'h037, HALT);
        $display("  GPU IMEM: 56 words loaded at time %0t", $time);

        // ============================================================
        // PHASE 2: Load GPU DMEM
        // input_type[1] = write_to_dmem, 64-bit BF16 4-lane values
        // ============================================================
        $display("");
        $display("  Phase 2: GPU DMEM load (input_type[1] = write_to_dmem)");
        $display("  ----------------------------------------------------------");
        $display("  64-bit BF16: 4 identical lanes per word");
        host_dmem_write64(8'h00, 32'h3FC03FC0, 32'h3FC03FC0); // x1 =  1.5
        host_dmem_write64(8'h01, 32'h40004000, 32'h40004000); // x2 =  2.0
        host_dmem_write64(8'h02, 32'h3F003F00, 32'h3F003F00); // x3 =  0.5
        host_dmem_write64(8'h03, 32'hBF80BF80, 32'hBF80BF80); // x4 = -1.0
        host_dmem_write64(8'h04, 32'h3F003F00, 32'h3F003F00); // w1 =  0.5
        host_dmem_write64(8'h05, 32'h3F803F80, 32'h3F803F80); // w2 =  1.0
        host_dmem_write64(8'h06, 32'hBF00BF00, 32'hBF00BF00); // w3 = -0.5
        host_dmem_write64(8'h07, 32'h40004000, 32'h40004000); // w4 =  2.0
        $display("  GPU DMEM: 8 words loaded at time %0t", $time);

        // ============================================================
        // PHASE 3: Load ARM IMEM
        // input_type[4] = arm_imem_we, reuses address + imem SW regs
        // 5 NOPs between MOVs and STRs: pipeline depth(4) + BRAM latency(1)
        // ============================================================
        $display("");
        $display("  Phase 3: ARM IMEM load (input_type[4] = arm_imem_we)");
        $display("  --------------------------------------------------------");
        arm_imem_write(9'h000, ARM_MOV_R1_0x00);    // MOV R1, #0x00  cfg_base
        arm_imem_write(9'h001, ARM_MOV_R2_BRAM_LEN);// MOV R2, #56    GPU len
        arm_imem_write(9'h002, ARM_MOV_R3_0xF0);    // MOV R3, #0xF0
        arm_imem_write(9'h003, ARM_MOV_R4_0xF1);    // MOV R4, #0xF1
        arm_imem_write(9'h004, ARM_MOV_R5_0xF2);    // MOV R5, #0xF2
        arm_imem_write(9'h005, ARM_NOP);             // NOP x5: pipeline fill
        arm_imem_write(9'h006, ARM_NOP);
        arm_imem_write(9'h007, ARM_NOP);
        arm_imem_write(9'h008, ARM_NOP);
        arm_imem_write(9'h009, ARM_NOP);
        arm_imem_write(9'h00A, ARM_STR_R1_R3);      // STR R1,[R3] -> 0xF0
        arm_imem_write(9'h00B, ARM_NOP);             // NOP x5: pipeline fill
        arm_imem_write(9'h00C, ARM_NOP);
        arm_imem_write(9'h00D, ARM_NOP);
        arm_imem_write(9'h00E, ARM_NOP);
        arm_imem_write(9'h00F, ARM_NOP);
        arm_imem_write(9'h010, ARM_STR_R2_R4);      // STR R2,[R4] -> 0xF1
        arm_imem_write(9'h011, ARM_NOP);             // NOP x5: pipeline fill
        arm_imem_write(9'h012, ARM_NOP);
        arm_imem_write(9'h013, ARM_NOP);
        arm_imem_write(9'h014, ARM_NOP);
        arm_imem_write(9'h015, ARM_NOP);
        arm_imem_write(9'h016, ARM_STR_R1_R5);      // STR R1,[R5] -> 0xF2 dispatch
        arm_imem_write(9'h017, ARM_B_SELF);          // B . (halt)
        $display("  ARM IMEM: 24 words loaded at time %0t", $time);

        // ============================================================
        // Snapshot before cpu_start
        // ============================================================
        $display("");
        $display("  -------- snapshot before cpu_start (time %0t) --------", $time);
        $display("  gpu_irq    = %0d  (expect 0)", dut.gpu_ctrl.gpu_irq);
        $display("  tensor_out = %h", dut.tensor_out);
        $display("  dmem_out   = %h", dut.dmem_out);

        // ============================================================
        // PHASE 4: Release ARM CPU via cpu_ctrl SW reg
        // ids.v detects rising edge on cpu_ctrl[0] -> one-cycle cpu_start pulse
        // ============================================================
        pulse_cpu_start();
        $display("");
        $display("  cpu_ctrl[0] pulsed at time %0t - ARM executing", $time);
        $display("  waiting for gpu_irq...");

        // ============================================================
        // PHASE 5: Wait for GPU done
        // ARM executes: MOV x5, STR x3 -> ctrl unit fires gpu_start
        // GPU runs ANN forward pass -> pipeline_done -> gpu_irq
        // ============================================================
        while (!dut.gpu_ctrl.gpu_irq)
            @(posedge clk);
        $display("");
        $display("  gpu_irq asserted at time %0t", $time);

        repeat (20) @(posedge clk);
        #1;

        // ============================================================
        // PHASE 6: Readback
        // Expected: relu(0.75+2.0-0.25-2.0) = relu(0.5) = 0.5
        //           BF16 0x3F00 x4 lanes = 0x3F003F003F003F00
        // ============================================================
        $display("");
        $display("  -------- results (time %0t) --------", $time);
        host_dmem_read_req(8'h08);
        $display("  DMEM[8]    = %h  (expect 3F003F003F003F00)", dut.dmem_out);
        $display("  tensor_out = %h  (expect 3F003F003F003F00)", dut.tensor_out);

        $display("");
        $display("=== tb_ann_neuron done ===");
        $stop;
    end

    initial begin
        #500000;
        $display("[tb_ann_neuron] TIMEOUT at time %0t", $time);
        $finish;
    end

endmodule