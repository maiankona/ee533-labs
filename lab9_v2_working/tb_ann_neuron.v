`timescale 1ns/1ps

// =============================================================================
// tb_ann_neuron.v  (lab9_work_in_progress)
// One-neuron ANN forward pass ? adapted from lab9_melvin_working for integrated ids:
//   - SW regs via UDP-style reg_write (same as tb_host_cpu_gpu_fifo.v)
//   - ids.v input_type: [0] write_to_imem, [1] write_to_dmem, [2] read_req_dmem,
//                      [3] GPU start edge, [4] read_req_imem
//   - ARM IMEM: top-level arm_write_to_imem / arm_addr_imem_host / arm_data_imem_host
//   - ARM run: top-level cpu_start pulse (ARM must not run until this asserts)
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
// ----------------------------------------------------------------
module generic_regs #(
    parameter UDP_REG_SRC_WIDTH = 2,
    parameter TAG               = 0,
    parameter REG_ADDR_WIDTH    = 4,
    parameter NUM_COUNTERS      = 0,
    parameter NUM_SOFTWARE_REGS = 5,
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

    reg [31:0] r_dmem_hi;
    reg [31:0] r_dmem_lo;
    reg [31:0] r_imem;
    reg [31:0] r_address;
    reg [31:0] r_input_type;

    assign software_regs = {r_dmem_hi, r_dmem_lo, r_imem, r_address, r_input_type};

    always @(posedge clk) begin
        if (reset) begin
            r_dmem_hi    <= 32'h0;
            r_dmem_lo    <= 32'h0;
            r_imem       <= 32'h0;
            r_address    <= 32'h0;
            r_input_type <= 32'h0;
        end else if (reg_req_in && !reg_rd_wr_L_in && reg_addr_in[22:4] == TAG) begin
            case (reg_addr_in[3:0])
                4'h0: r_dmem_hi    <= reg_data_in;
                4'h1: r_dmem_lo    <= reg_data_in;
                4'h2: r_imem       <= reg_data_in;
                4'h3: r_address    <= reg_data_in;
                4'h4: r_input_type <= reg_data_in;
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
    reg         cpu_start;
    reg         arm_write_to_imem;
    reg  [8:0]  arm_addr_imem_host;
    reg  [31:0] arm_data_imem_host;

    localparam [22:0] REG_DMEM_HI    = {`IDS_BLOCK_ADDR, 4'h0};
    localparam [22:0] REG_DMEM_LO    = {`IDS_BLOCK_ADDR, 4'h1};
    localparam [22:0] REG_IMEM       = {`IDS_BLOCK_ADDR, 4'h2};
    localparam [22:0] REG_ADDRESS    = {`IDS_BLOCK_ADDR, 4'h3};
    localparam [22:0] REG_INPUT_TYPE = {`IDS_BLOCK_ADDR, 4'h4};

    localparam [31:0] ITYPE_WRITE_IMEM = 32'h1;  // input_type[0]
    localparam [31:0] ITYPE_WRITE_DMEM = 32'h2;  // [1]
    localparam [31:0] ITYPE_READ_DMEM  = 32'h4;  // [2]

    ids dut (
        .in_data            (in_data),
        .in_ctrl            (in_ctrl),
        .in_wr              (in_wr),
        .in_rdy             (in_rdy),
        .out_data           (out_data),
        .out_ctrl           (out_ctrl),
        .out_wr             (out_wr),
        .out_rdy            (out_rdy),
        .reg_req_in         (reg_req_in),
        .reg_ack_in         (reg_ack_in),
        .reg_rd_wr_L_in     (reg_rd_wr_L_in),
        .reg_addr_in        (reg_addr_in),
        .reg_data_in        (reg_data_in),
        .reg_src_in         (reg_src_in),
        .reg_req_out        (reg_req_out),
        .reg_ack_out        (reg_ack_out),
        .reg_rd_wr_L_out    (reg_rd_wr_L_out),
        .reg_addr_out       (reg_addr_out),
        .reg_data_out       (reg_data_out),
        .reg_src_out        (reg_src_out),
        .clk                (clk),
        .reset              (reset),
        .cpu_start          (cpu_start),
        .arm_write_to_imem  (arm_write_to_imem),
        .arm_addr_imem_host (arm_addr_imem_host),
        .arm_data_imem_host (arm_data_imem_host)
    );

    initial clk = 0;
    always #4 clk = ~clk;

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

    task pulse_input_type;
        input [31:0] mask_one_cycle;
        begin
            reg_write(REG_INPUT_TYPE, mask_one_cycle);
            reg_write(REG_INPUT_TYPE, 32'h0);
        end
    endtask

    task host_dmem_write64;
        input [7:0]  byte_addr;
        input [31:0] lo;
        input [31:0] hi;
        begin
            reg_write(REG_ADDRESS, {24'h0, byte_addr});
            reg_write(REG_DMEM_LO, lo);
            reg_write(REG_DMEM_HI, hi);
            pulse_input_type(ITYPE_WRITE_DMEM);
        end
    endtask

    task host_dmem_read_req;
        input [7:0] byte_addr;
        begin
            reg_write(REG_ADDRESS, {24'h0, byte_addr});
            pulse_input_type(ITYPE_READ_DMEM);
            repeat (6) @(posedge clk);
        end
    endtask

    // GPU IMEM: input_type[0] = write_to_imem (not bit[3] ? that is GPU_START edge)
    task write_gpu_imem;
        input [8:0]  addr;
        input [31:0] instr;
        begin
            reg_write(REG_ADDRESS, {23'h0, addr});
            reg_write(REG_IMEM, instr);
            pulse_input_type(ITYPE_WRITE_IMEM);
        end
    endtask

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

    task pulse_cpu_start;
        begin
            @(negedge clk);
            cpu_start = 1'b1;
            @(negedge clk);
            cpu_start = 1'b0;
        end
    endtask

`ifdef TB_ANN_TRACE_WB
    // Off by default: fires often during GPU run and can exhaust log / host memory.
    always @(posedge clk) begin
        if (!reset && dut.gpu_Unit.wb_wreg_en && dut.gpu_Unit.wb_wreg_addr != 0)
            $display("  [tb_ann_neuron] time %0t  GPU WB r%-2d <- %h",
                $time, dut.gpu_Unit.wb_wreg_addr, dut.gpu_Unit.wb_data);
    end
`endif

    // ----------------------------------------------------------------
    // GPU ISA constants
    // LD/ST effective address = r0 + imm14, where imm14 = insn[15:2] (see decode_gpu.v).
    // insn[1:0] is width, NOT part of the byte address ? do not put the DMEM index only in [1:0]
    // (old encodings like 32'h48400001 made imm14==0 so every LW hit DMEM[0]; only indices with
    //  bit 2 set appeared as imm14==1, hence waveforms showing only addrs 0 and 1).
    // Encode byte index n as insn[15:0] = { imm14[13:0], 2'b00 } with imm14 = n.
    // ----------------------------------------------------------------
    localparam LW_R1_0       = 32'h48200000; // n=0 -> 0<<2
    localparam LW_R2_1       = 32'h48400004; //1<<2
    localparam LW_R3_2       = 32'h48600008; // 2<<2
    localparam LW_R4_3       = 32'h4880000C; // 3<<2
    localparam LW_R5_4       = 32'h48A00010; // 4<<2
    localparam LW_R6_5       = 32'h48C00014; // 5<<2
    localparam LW_R7_6       = 32'h48E00018; // 6<<2
    localparam LW_R8_7       = 32'h4900001C; // 7<<2
    localparam VMAC_R9_R1_R5 = 32'h25212800;
    localparam VMAC_R9_R2_R6 = 32'h25223000;
    localparam VMAC_R9_R3_R7 = 32'h25233800;
    localparam VMAC_R9_R4_R8 = 32'h25244000;
    localparam VRELU_R10_R9  = 32'h29490000;
    localparam ST_R10_8      = 32'h4D400020; // 8<<2 (was 0x...08 -> imm14=2, DMEM[2])
    localparam NOP           = 32'h00000000;
    localparam HALT          = 32'h2C000000;

    localparam ARM_MOV_R1_0x00 = 32'hE3A01000;
    // Written to MMIO 0xF1 as GPU bram_length = # of instruction fetches (must match IMEM program size).
    localparam ARM_MOV_R2_BRAM_LEN = 32'hE3A02038; // #56 (IMEM 0x000..0x037)
    localparam ARM_MOV_R3_0xF0 = 32'hE3A030F0;
    localparam ARM_MOV_R4_0xF1 = 32'hE3A040F1;
    localparam ARM_MOV_R5_0xF2 = 32'hE3A050F2;
    localparam ARM_STR_R1_R3   = 32'hE5831000;
    localparam ARM_STR_R2_R4   = 32'hE5842000;
    localparam ARM_STR_R1_R5   = 32'hE5851000;
    localparam ARM_NOP         = 32'hE1A00000;
    localparam ARM_B_SELF      = 32'hEAFFFFFE;

    initial begin
        in_data            = 0;
        in_ctrl            = 0;
        in_wr              = 0;
        out_rdy            = 1;
        reg_req_in         = 0;
        reg_ack_in         = 0;
        reg_rd_wr_L_in     = 1;
        reg_addr_in        = 0;
        reg_data_in        = 0;
        reg_src_in         = 0;
        cpu_start          = 0;
        arm_write_to_imem  = 0;
        arm_addr_imem_host = 0;
        arm_data_imem_host = 0;

        reset = 1;
        repeat (4) @(posedge clk);
        #1 reset = 0;
        $display("");
        $display("=== tb_ann_neuron (lab9_work_in_progress): reset released at time %0t ===",
            $time);

        // ---------------- GPU IMEM ----------------
        $display("  Phase 1: load GPU IMEM (SW write_to_imem = input_type[0])...");
        write_gpu_imem(9'h000, LW_R1_0);
        write_gpu_imem(9'h001, LW_R2_1);
        write_gpu_imem(9'h002, LW_R3_2);
        write_gpu_imem(9'h003, LW_R4_3);
        write_gpu_imem(9'h004, LW_R5_4);
        write_gpu_imem(9'h005, LW_R6_5);
        write_gpu_imem(9'h006, LW_R7_6);
        write_gpu_imem(9'h007, LW_R8_7);
        write_gpu_imem(9'h008, NOP);
        write_gpu_imem(9'h009, NOP);
        write_gpu_imem(9'h00A, NOP);
        write_gpu_imem(9'h00B, NOP);
        write_gpu_imem(9'h00C, VMAC_R9_R1_R5);
        write_gpu_imem(9'h00D, NOP);
        write_gpu_imem(9'h00E, NOP);
        write_gpu_imem(9'h00F, NOP);
        write_gpu_imem(9'h010, NOP);
        write_gpu_imem(9'h011, NOP); // extra spacing between VMACs
        write_gpu_imem(9'h012, NOP);
        write_gpu_imem(9'h013, NOP);
        write_gpu_imem(9'h014, VMAC_R9_R2_R6);
        write_gpu_imem(9'h015, NOP);
        write_gpu_imem(9'h016, NOP);
        write_gpu_imem(9'h017, NOP);
        write_gpu_imem(9'h018, NOP);
        write_gpu_imem(9'h019, NOP); // extra spacing between VMACs
        write_gpu_imem(9'h01A, NOP);
        write_gpu_imem(9'h01B, NOP);
        write_gpu_imem(9'h01C, VMAC_R9_R3_R7);
        write_gpu_imem(9'h01D, NOP);
        write_gpu_imem(9'h01E, NOP);
        write_gpu_imem(9'h01F, NOP);
        write_gpu_imem(9'h020, NOP);
        write_gpu_imem(9'h021, NOP); // extra spacing between VMACs
        write_gpu_imem(9'h022, NOP);
        write_gpu_imem(9'h023, NOP);
        write_gpu_imem(9'h024, VMAC_R9_R4_R8);
        write_gpu_imem(9'h025, NOP); // spacing after last VMAC before VRELU
        write_gpu_imem(9'h026, NOP);
        write_gpu_imem(9'h027, NOP);
        write_gpu_imem(9'h028, NOP);
        write_gpu_imem(9'h029, NOP);
        write_gpu_imem(9'h02A, NOP);
        write_gpu_imem(9'h02B, NOP);
        write_gpu_imem(9'h02C, VRELU_R10_R9);
        write_gpu_imem(9'h02D, NOP);
        write_gpu_imem(9'h02E, NOP);
        write_gpu_imem(9'h02F, NOP);
        write_gpu_imem(9'h030, NOP);
        write_gpu_imem(9'h031, NOP);
		  write_gpu_imem(9'h032, NOP);
        write_gpu_imem(9'h033, ST_R10_8);
        write_gpu_imem(9'h034, NOP);
        write_gpu_imem(9'h035, NOP);
        write_gpu_imem(9'h036, NOP);
        write_gpu_imem(9'h037, HALT);
        $display("  GPU IMEM loaded (56 words) at time %0t", $time);

        // ---------------- GPU DMEM (64b hi+lo) ----------------
        $display("  Phase 2: load GPU DMEM...");
        host_dmem_write64(8'h00, 32'h3FC03FC0, 32'h3FC03FC0);
        host_dmem_write64(8'h01, 32'h40004000, 32'h40004000);
        host_dmem_write64(8'h02, 32'h3F003F00, 32'h3F003F00);
        host_dmem_write64(8'h03, 32'hBF80BF80, 32'hBF80BF80);
        host_dmem_write64(8'h04, 32'h3F003F00, 32'h3F003F00);
        host_dmem_write64(8'h05, 32'h3F803F80, 32'h3F803F80);
        host_dmem_write64(8'h06, 32'hBF00BF00, 32'hBF00BF00);
        host_dmem_write64(8'h07, 32'h40004000, 32'h40004000);
        $display("  GPU DMEM loaded at time %0t", $time);

        // ---------------- ARM IMEM (host port) ----------------
        $display("  Phase 3: load ARM IMEM (arm_write_to_imem)...");
        arm_imem_write(9'h000, ARM_MOV_R1_0x00);
        arm_imem_write(9'h001, ARM_MOV_R2_BRAM_LEN);
        arm_imem_write(9'h002, ARM_MOV_R3_0xF0);
        arm_imem_write(9'h003, ARM_MOV_R4_0xF1);
        arm_imem_write(9'h004, ARM_MOV_R5_0xF2);
        arm_imem_write(9'h005, ARM_NOP);
        arm_imem_write(9'h006, ARM_NOP);
        arm_imem_write(9'h007, ARM_NOP);
        arm_imem_write(9'h008, ARM_NOP);
        arm_imem_write(9'h009, ARM_NOP);
        arm_imem_write(9'h00A, ARM_STR_R1_R3);
        arm_imem_write(9'h00B, ARM_NOP);
        arm_imem_write(9'h00C, ARM_NOP);
        arm_imem_write(9'h00D, ARM_NOP);
        arm_imem_write(9'h00E, ARM_NOP);
        arm_imem_write(9'h00F, ARM_NOP);
        arm_imem_write(9'h010, ARM_STR_R2_R4);
        arm_imem_write(9'h011, ARM_NOP);
        arm_imem_write(9'h012, ARM_NOP);
        arm_imem_write(9'h013, ARM_NOP);
        arm_imem_write(9'h014, ARM_NOP);
        arm_imem_write(9'h015, ARM_NOP);
        arm_imem_write(9'h016, ARM_STR_R1_R5);
        arm_imem_write(9'h017, ARM_B_SELF);
        $display("  ARM IMEM loaded at time %0t", $time);

        // ---------------- cpu_start: before / after visibility ----------------
        $display("");
        $display("[tb_ann_neuron] -------- SNAPSHOT BEFORE cpu_start (time %0t) --------", $time);
        $display("  ARM must not have run yet; gpu_irq should be 0; results not final.");
        $display("  dut.gpu_ctrl.gpu_irq = %0d", dut.gpu_ctrl.gpu_irq);
        $display("  dut.tensor_out       = %h", dut.tensor_out);
        $display("  dut.dmem_out         = %h", dut.dmem_out);
        $display("[tb_ann_neuron] ----------------------------------------------------------------");

        pulse_cpu_start();
        $display("");
        $display("[tb_ann_neuron] -------- SNAPSHOT RIGHT AFTER cpu_start pulse (time %0t) --------",
            $time);
        $display("  ARM should begin fetch; still wait gpu_irq for GPU completion.");
        $display("  dut.gpu_ctrl.gpu_irq = %0d", dut.gpu_ctrl.gpu_irq);
        $display("  dut.tensor_out       = %h", dut.tensor_out);
        $display("  dut.dmem_out         = %h", dut.dmem_out);
        $display("[tb_ann_neuron] ----------------------------------------------------------------");

        // ---------------- Wait for GPU done ----------------
        $display("");
        $display("  Phase 4: waiting for dut.gpu_ctrl.gpu_irq ...");
        while (!dut.gpu_ctrl.gpu_irq)
            @(posedge clk);
        $display("  gpu_irq asserted at time %0t (valid end-of-GPU-run marker)", $time);

        repeat (20) @(posedge clk);
        #1;

        // ---------------- Readback (meaningful after run + host read) ----------------
        $display("");
        $display("[tb_ann_neuron] -------- SNAPSHOT AFTER gpu_irq (valid result phase, time %0t) --------",
            $time);
        host_dmem_read_req(8'h08);
        $display("  DMEM[8] readback dmem_out = %h  (expect 3F003F003F003F00)", dut.dmem_out);
        $display("  tensor_out (32b SW view)  = %h  (low 32b of tensor; see dmem_out for 64b)",
            dut.tensor_out);
        $display("[tb_ann_neuron] ----------------------------------------------------------------");

        $display("");
        $display("=== tb_ann_neuron done ===");
        $finish;
    end

    initial begin
        // Bail out sooner if stuck (matches tb_host_cpu_gpu_fifo scale; saves long hangs)
        #500000;
        $display("[tb_ann_neuron] TIMEOUT at time %0t", $time);
        $finish;
    end

endmodule
