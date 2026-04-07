`timescale 1ns/1ps

// ================================================================
// tb_ann_neuron.v
// One-neuron ANN forward pass test:
//   inputs:  x1=1.5, x2=2.0, x3=0.5, x4=-1.0  -> DMEM[0x00-0x03]
//   weights: w1=0.5, w2=1.0, w3=-0.5, w4=2.0   -> DMEM[0x04-0x07]
//   GPU program: LW x1-x4, LW w1-w4, VMAC x4, VRELU, ST result
//   ARM program: configure ctrl unit, dispatch GPU
//   Expected: relu(1.5*0.5 + 2.0*1.0 + 0.5*(-0.5) + (-1.0)*2.0)
//           = relu(0.75 + 2.0 - 0.25 - 2.0) = relu(0.5) = 0.5
//           = BF16 0x3F00 across 4 lanes = 0x3F003F003F003F00
//
// Loading flow mirrors FPGA Perl script exactly:
//   input_type[1] = GPU DMEM write  (0x02)
//   input_type[2] = GPU DMEM read   (0x04)
//   input_type[3] = GPU IMEM write  (0x08)
//   input_type[4] = ARM IMEM write  (0x10)
//   cpu_ctrl[0]   = cpu_start       (SW reg 4)
// ================================================================

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


module tb_ann_neuron;

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

    // --- SW reg aliases (mirrors FPGA register map) ---
    // SW reg bundle: {cpu_ctrl, dmem, imem, address, input_type}
    `define SW_INPUT_TYPE dut.module_regs.sw_regs[31:0]    // reg 0
    `define SW_ADDRESS    dut.module_regs.sw_regs[63:32]   // reg 1
    `define SW_IMEM       dut.module_regs.sw_regs[95:64]   // reg 2
    `define SW_DMEM       dut.module_regs.sw_regs[127:96]  // reg 3
    `define SW_CPU_CTRL   dut.module_regs.sw_regs[159:128] // reg 4

    `define GPU_IRQ       dut.gpu_irq
    `define TENSOR_OUT    dut.tensor_out
    `define DMEM_OUT      dut.dmem_out

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
    // Task: sw_write
    // Mimics one Perl regwrite call - sets SW regs directly
    // On FPGA this is done by the NetFPGA host bus
    // Holds value for one full clock cycle before returning
    // ----------------------------------------------------------------
    task sw_write;
        input [2:0]  reg_sel;   // 0=input_type 1=address 2=imem 3=dmem 4=cpu_ctrl
        input [31:0] val;
        begin
            @(negedge clk);
            case (reg_sel)
                3'd0: `SW_INPUT_TYPE = val;
                3'd1: `SW_ADDRESS    = val;
                3'd2: `SW_IMEM       = val;
                3'd3: `SW_DMEM       = val;
                3'd4: `SW_CPU_CTRL   = val;
                default: ;
            endcase
            @(posedge clk); // hold for one full cycle
            #1;
        end
    endtask

    // ----------------------------------------------------------------
    // Task: write_gpu_imem
    // Mirrors Perl: write_gpu_imem(addr, instr)
    // input_type[3] = 0x8 -> gpu_imem_we
    // ----------------------------------------------------------------
    task write_gpu_imem;
        input [8:0]  addr;
        input [31:0] instr;
        begin
            sw_write(1, {23'h0, addr});   // SW_ADDRESS
            sw_write(2, instr);            // SW_IMEM
            sw_write(0, 32'h8);            // input_type[3] = gpu_imem_sw - holds one cycle
            sw_write(0, 32'h0);            // clear
        end
    endtask

    // ----------------------------------------------------------------
    // Task: write_gpu_dmem
    // Mirrors Perl: write_dmem(addr, data)
    // input_type[1] = 0x2 -> dmem_we
    // ----------------------------------------------------------------
    task write_gpu_dmem;
        input [7:0]  addr;
        input [63:0] data;
        begin
            sw_write(1, {24'h0, addr});    // SW_ADDRESS
            sw_write(3, data[31:0]);        // SW_DMEM (lower 32)
            sw_write(0, 32'h2);             // input_type[1] = dmem_we - holds one cycle
            sw_write(0, 32'h0);             // clear
        end
    endtask

    // ----------------------------------------------------------------
    // Task: read_gpu_dmem
    // Mirrors Perl: read_dmem(addr)
    // input_type[2] = 0x4 -> dmem_read_req
    // ----------------------------------------------------------------
    task read_gpu_dmem;
        input [7:0] addr;
        begin
            sw_write(1, {24'h0, addr});
            sw_write(0, 32'h4);             // input_type[2] = dmem_read_req - holds one cycle
            sw_write(0, 32'h0);             // clear
            @(posedge clk); #1;             // extra cycle for dmem_out latch
        end
    endtask

    // ----------------------------------------------------------------
    // Task: write_arm_imem
    // Mirrors Perl: write_arm_imem(addr, instr)
    // input_type[4] = 0x10 -> arm_write_to_imem
    // ----------------------------------------------------------------
    task write_arm_imem;
        input [8:0]  addr;
        input [31:0] instr;
        begin
            sw_write(1, {23'h0, addr});    // SW_ADDRESS
            sw_write(2, instr);             // SW_IMEM (shared with GPU IMEM data)
            sw_write(0, 32'h10);            // input_type[4] = arm_imem_we - holds one cycle
            sw_write(0, 32'h0);             // clear
        end
    endtask

    // ----------------------------------------------------------------
    // Task: release_cpu
    // Mirrors Perl: cpu_start() - write 1 then 0 to cpu_ctrl[0]
    // Rising edge detect in ids.v fires cpu_start one cycle
    // ----------------------------------------------------------------
    task release_cpu;
        begin
            sw_write(4, 32'h1);             // cpu_ctrl[0] = 1
            @(posedge clk); #1;
            sw_write(4, 32'h0);             // cpu_ctrl[0] = 0 -> rising edge fires
            $display("  cpu_ctrl[0] pulsed at cycle %0d - ARM executing", cycle);
        end
    endtask

    // --- WB monitor ---
    always @(posedge clk) begin
        if (dut.gpu_Unit.wb_wreg_en && dut.gpu_Unit.wb_wreg_addr != 0)
            $display("  Cycle %0d  WB r%-2d <- %h",
                cycle, dut.gpu_Unit.wb_wreg_addr, dut.gpu_Unit.wb_data);
    end

    // ----------------------------------------------------------------
    // GPU program: one neuron forward pass
    // VMAC accumulates: acc = x1*w1 + x2*w2 + x3*w3 + x4*w4
    // VRELU: result = relu(acc)
    // Store result to DMEM[0x08]
    //
    // Instruction encodings (from GPU ISA):
    //   LW  rd, imm(r0): opcode=0x12(I), rd, rs1=r0, imm=offset
    //                    [31:26]=010010, [25:21]=rd, [20:16]=00000, [15:0]=imm
    //   VMAC rd,rs1,rs2: opcode=0x09(R)
    //                    [31:26]=001001, [25:21]=rd, [20:16]=rs1, [15:11]=rs2
    //   VRELU rd,rs1:    opcode=0x0A(R)
    //                    [31:26]=001010, [25:21]=rd, [20:16]=rs1
    //   ST  rs2,imm(r0): opcode=0x13(I)
    //                    [31:26]=010011, [25:21]=rs2, [20:16]=r0, [15:0]=imm
    //   HALT:            opcode=0x0B(R) = 0x2C000000
    //   NOP:             0x00000000
    //
    // Register allocation:
    //   r1 = x1 (input 1)
    //   r2 = x2 (input 2)
    //   r3 = x3 (input 3)
    //   r4 = x4 (input 4)
    //   r5 = w1 (weight 1)
    //   r6 = w2 (weight 2)
    //   r7 = w3 (weight 3)
    //   r8 = w4 (weight 4)
    //   r9 = accumulator
    //   r10 = relu output
    //
    // LW r1, 0(r0)  : 010010_00001_00000_0000000000000000 = 0x48200000
    // LW r2, 1(r0)  : 010010_00010_00000_0000000000000001 = 0x48400001
    // LW r3, 2(r0)  : 010010_00011_00000_0000000000000010 = 0x48600002
    // LW r4, 3(r0)  : 010010_00100_00000_0000000000000011 = 0x48800003
    // LW r5, 4(r0)  : 010010_00101_00000_0000000000000100 = 0x48A00004
    // LW r6, 5(r0)  : 010010_00110_00000_0000000000000101 = 0x48C00005
    // LW r7, 6(r0)  : 010010_00111_00000_0000000000000110 = 0x48E00006
    // LW r8, 7(r0)  : 010010_01000_00000_0000000000000111 = 0x49000007
    // VMAC r9,r1,r5 : 001001_01001_00001_00101_00000000000 = 0x24A08800
    //                 wait - need to check rd field carefully
    // ----------------------------------------------------------------

    // LW encoding: [31:26]=6'h12, [25:21]=rd, [20:16]=rs1(r0=0), [15:0]=imm
    // 6'h12 = 6'b010010
    localparam LW_R1_0  = 32'h48200000; // LW r1, 0(r0)
    localparam LW_R2_1  = 32'h48400001; // LW r2, 1(r0)
    localparam LW_R3_2  = 32'h48600002; // LW r3, 2(r0)
    localparam LW_R4_3  = 32'h48800003; // LW r4, 3(r0)
    localparam LW_R5_4  = 32'h48A00004; // LW r5, 4(r0)
    localparam LW_R6_5  = 32'h48C00005; // LW r6, 5(r0)
    localparam LW_R7_6  = 32'h48E00006; // LW r7, 6(r0)
    localparam LW_R8_7  = 32'h49000007; // LW r8, 7(r0)

    // VMAC encoding: [31:26]=6'h09=001001, [25:21]=rd, [20:16]=rs1, [15:11]=rs2, [10:0]=0
    // VMAC r9,r1,r5: rd=01001, rs1=00001, rs2=00101
    //   001001_01001_00001_00101_00000000000 = 0x25208800 -- let me recalc
    //   [31:26]=001001, [25:21]=01001, [20:16]=00001, [15:11]=00101, [10:0]=00000000000
    //   = 0010 0101 0010 0000 1010 0000 0000 0000 = 0x25 20 A0 00
    // Hmm, let me be more careful:
    // bits: 31..26=001001, 25..21=01001, 20..16=00001, 15..11=00101, 10..0=00000000000
    //       001001 01001 00001 00101 00000000000
    //   = 0010 0101 0010 0000 1010 0000 0000 0000
    //   bit31=0,30=0,29=1,28=0,27=0,26=1 = 0x25...
    //   bit25=0,24=1,23=0,22=0,21=1 ...
    // Let me just construct it properly:
    // {6'h09, 5'd9, 5'd1, 5'd5, 11'd0} = {001001, 01001, 00001, 00101, 00000000000}
    // = 32'b00100101001000010010100000000000 = 0x25212800... let me recalc
    // 0010 0101 0010 0001 0010 1000 0000 0000 -- nope
    // Let me just concatenate:
    // 001001 01001 00001 00101 00000000000
    // 0010 0101 0010 0000 1001 0000 0000 0000 -- still not right
    // Breaking it down bit by bit:
    // [31]=0,[30]=0,[29]=1,[28]=0,[27]=0,[26]=1  -> 001001
    // [25]=0,[24]=1,[23]=0,[22]=0,[21]=1          -> 01001
    // [20]=0,[19]=0,[18]=0,[17]=0,[16]=1          -> 00001
    // [15]=0,[14]=0,[13]=1,[12]=0,[11]=1          -> 00101
    // [10:0]=00000000000
    // = 0010 0101 0010 0000 1000 1010 0000 0000... wait
    // [15]=0,[14]=0,[13]=1,[12]=0,[11]=1 -> that's bits 15 down to 11
    // full 32 bits:
    // 0010_0101_0010_0000_1000_1000_0000_0000... i keep getting confused
    // Let me just use the known working encoding from the TB history:
    // VMAC r9, r2, r4 = 0x25222000 (from previous working TB)
    // That was: rd=r9=01001, rs1=r2=00010, rs2=r4=00100
    // 001001_01001_00010_00100_00000000000
    // Let me verify: 0x25222000
    // 0x25 = 0010 0101, 0x22 = 0010 0010, 0x20 = 0010 0000, 0x00 = 0000 0000
    // = 0010 0101 0010 0010 0010 0000 0000 0000
    // [31:26] = 001001 = 0x09 = VMAC ✓
    // [25:21] = 01001  = 9 = r9 ✓
    // [20:16] = 00010  = 2 = r2 ✓
    // [15:11] = 00100  = 4 = r4 ✓
    // Great, formula confirmed: {6'h09, rd[4:0], rs1[4:0], rs2[4:0], 11'b0}

    // VMAC r9, r1, r5: {001001, 01001, 00001, 00101, 00000000000}
    //   = 0010 0101 0010 0000 1001 0000 0000 0000... nope let me just do it:
    // bit concat: 001001_01001_00001_00101_00000000000
    // group into nibbles from MSB:
    // 0010 | 0101 | 0010 | 0000 | 1001 | 0100 | 0000 | 0000 -- hmm
    // Let me just do it as a number:
    // 001001 = 9 in 6 bits
    // 01001  = 9 in 5 bits  (rd=r9)
    // 00001  = 1 in 5 bits  (rs1=r1)
    // 00101  = 5 in 5 bits  (rs2=r5)
    // 00000000000 = 0 in 11 bits
    // value = (9<<26)|(9<<21)|(1<<16)|(5<<11)|0
    //       = 0x24000000 | 0x01200000 | 0x00010000 | 0x00002800
    //       = 0x25212800
    localparam VMAC_R9_R1_R5 = 32'h25212800; // VMAC r9, r1, r5  acc=x1*w1
    // VMAC r9, r2, r6: (9<<26)|(9<<21)|(2<<16)|(6<<11)
    //       = 0x24000000|0x01200000|0x00020000|0x00003000 = 0x25223000
    localparam VMAC_R9_R2_R6 = 32'h25223000; // VMAC r9, r2, r6  acc+=x2*w2
    // VMAC r9, r3, r7: (9<<26)|(9<<21)|(3<<16)|(7<<11)
    //       = 0x24000000|0x01200000|0x00030000|0x00003800 = 0x25233800
    localparam VMAC_R9_R3_R7 = 32'h25233800; // VMAC r9, r3, r7  acc+=x3*w3
    // VMAC r9, r4, r8: (9<<26)|(9<<21)|(4<<16)|(8<<11)
    //       = 0x24000000|0x01200000|0x00040000|0x00004000 = 0x25244000
    localparam VMAC_R9_R4_R8 = 32'h25244000; // VMAC r9, r4, r8  acc+=x4*w4

    // VRELU r10, r9: opcode=0x0A=001010, rd=r10=01010, rs1=r9=01001
    // (0x0A<<26)|(10<<21)|(9<<16) = 0x28000000|0x01400000|0x00090000 = 0x29490000
    localparam VRELU_R10_R9 = 32'h29490000; // VRELU r10, r9

    // ST r10, 8(r0): opcode=0x13=010011, rs2=r10=01010, rs1=r0=00000, imm=8
    // (0x13<<26)|(10<<21)|(0<<16)|8 = 0x4C000000|0x01400000|0x00000008 = 0x4D400008
    localparam ST_R10_8    = 32'h4D400008; // ST r10, 8(r0) -> DMEM[8]

    localparam NOP         = 32'h00000000;
    localparam HALT        = 32'h2C000000;

    // ----------------------------------------------------------------
    // ARM program encoding (ARMv4, AL condition = 4'b1110):
    //   MOV R1, #0x00  ; GPU IMEM base = 0x00
    //   MOV R2, #0x1E  ; GPU program length = 30 instructions
    //   MOV R3, #0xF0  ; ctrl cfg_base
    //   MOV R4, #0xF1  ; ctrl cfg_len
    //   MOV R5, #0xF2  ; ctrl dispatch
    //   STR R1, [R3]   ; -> 0xF0
    //   STR R2, [R4]   ; -> 0xF1
    //   STR R1, [R5]   ; -> 0xF2 dispatch
    //   B .            ; halt
    // ----------------------------------------------------------------
    localparam ARM_MOV_R1_0x00 = 32'hE3A01000;
    localparam ARM_MOV_R2_0x2A = 32'hE3A0202A; // GPU program length = 42 instructions
    localparam ARM_MOV_R3_0xF0 = 32'hE3A030F0;
    localparam ARM_MOV_R4_0xF1 = 32'hE3A040F1;
    localparam ARM_MOV_R5_0xF2 = 32'hE3A050F2;
    localparam ARM_STR_R1_R3   = 32'hE5831000;
    localparam ARM_STR_R2_R4   = 32'hE5842000;
    localparam ARM_STR_R1_R5   = 32'hE5851000;
    localparam ARM_NOP         = 32'hE1A00000; // MOV R0, R0 (ARM canonical NOP)
    localparam ARM_B_SELF      = 32'hEAFFFFFE;

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
        // PHASE 1: Load GPU IMEM via input_type[3]
        // Mirrors Perl: load_gpu_program("ann_neuron.txt")
        // Program: 8 LWs, 4 VMACs each with 4 NOPs, VRELU, NOP, ST, HALT
        // ============================================================
        $display("  Loading GPU IMEM...");
        write_gpu_imem(9'h000, LW_R1_0);        // LW r1, 0(r0) - x1
        write_gpu_imem(9'h001, LW_R2_1);        // LW r2, 1(r0) - x2
        write_gpu_imem(9'h002, LW_R3_2);        // LW r3, 2(r0) - x3
        write_gpu_imem(9'h003, LW_R4_3);        // LW r4, 3(r0) - x4
        write_gpu_imem(9'h004, LW_R5_4);        // LW r5, 4(r0) - w1
        write_gpu_imem(9'h005, LW_R6_5);        // LW r6, 5(r0) - w2
        write_gpu_imem(9'h006, LW_R7_6);        // LW r7, 6(r0) - w3
        write_gpu_imem(9'h007, LW_R8_7);        // LW r8, 7(r0) - w4
        write_gpu_imem(9'h008, NOP);
        write_gpu_imem(9'h009, NOP);
        write_gpu_imem(9'h00A, NOP);
        write_gpu_imem(9'h00B, NOP);
        write_gpu_imem(9'h00C, VMAC_R9_R1_R5);  // r9 = x1*w1
        write_gpu_imem(9'h00D, NOP);
        write_gpu_imem(9'h00E, NOP);
        write_gpu_imem(9'h00F, NOP);
        write_gpu_imem(9'h010, NOP);
        write_gpu_imem(9'h011, VMAC_R9_R2_R6);  // r9 += x2*w2
        write_gpu_imem(9'h012, NOP);
        write_gpu_imem(9'h013, NOP);
        write_gpu_imem(9'h014, NOP);
        write_gpu_imem(9'h015, NOP);
        write_gpu_imem(9'h016, VMAC_R9_R3_R7);  // r9 += x3*w3
        write_gpu_imem(9'h017, NOP);
        write_gpu_imem(9'h018, NOP);
        write_gpu_imem(9'h019, NOP);
        write_gpu_imem(9'h01A, NOP);
        write_gpu_imem(9'h01B, VMAC_R9_R4_R8);  // r9 += x4*w4
        write_gpu_imem(9'h01C, NOP);
        write_gpu_imem(9'h01D, NOP);
        write_gpu_imem(9'h01E, NOP);
        write_gpu_imem(9'h01F, NOP);
        write_gpu_imem(9'h020, VRELU_R10_R9);   // r10 = relu(r9)
        write_gpu_imem(9'h021, NOP);
        write_gpu_imem(9'h022, NOP);
        write_gpu_imem(9'h023, NOP);
        write_gpu_imem(9'h024, NOP);
        write_gpu_imem(9'h025, ST_R10_8);        // DMEM[8] = r10
        write_gpu_imem(9'h026, NOP);
        write_gpu_imem(9'h027, NOP);
        write_gpu_imem(9'h028, NOP);
        write_gpu_imem(9'h029, HALT);
        $display("  GPU IMEM loaded at cycle %0d (%0d instructions)", cycle, 42);

        // ============================================================
        // PHASE 2: Load GPU DMEM via input_type[1]
        // Mirrors Perl: load_gpu_data("ann_inputs.txt")
        // BF16 values packed as 64-bit (4 lanes, same value repeated):
        //   x1=1.5  -> BF16 0x3FC0 -> 64'h3FC03FC03FC03FC0
        //   x2=2.0  -> BF16 0x4000 -> 64'h4000400040004000
        //   x3=0.5  -> BF16 0x3F00 -> 64'h3F003F003F003F00
        //   x4=-1.0 -> BF16 0xBF80 -> 64'hBF80BF80BF80BF80
        //   w1=0.5  -> BF16 0x3F00 -> 64'h3F003F003F003F00
        //   w2=1.0  -> BF16 0x3F80 -> 64'h3F803F803F803F80
        //   w3=-0.5 -> BF16 0xBF00 -> 64'hBF00BF00BF00BF00
        //   w4=2.0  -> BF16 0x4000 -> 64'h4000400040004000
        // ============================================================
        $display("  Loading GPU DMEM...");
        write_gpu_dmem(8'h00, 64'h3FC03FC03FC03FC0); // x1 = 1.5
        write_gpu_dmem(8'h01, 64'h4000400040004000); // x2 = 2.0
        write_gpu_dmem(8'h02, 64'h3F003F003F003F00); // x3 = 0.5
        write_gpu_dmem(8'h03, 64'hBF80BF80BF80BF80); // x4 = -1.0
        write_gpu_dmem(8'h04, 64'h3F003F003F003F00); // w1 = 0.5
        write_gpu_dmem(8'h05, 64'h3F803F803F803F80); // w2 = 1.0
        write_gpu_dmem(8'h06, 64'hBF00BF00BF00BF00); // w3 = -0.5
        write_gpu_dmem(8'h07, 64'h4000400040004000); // w4 = 2.0
        $display("  GPU DMEM loaded at cycle %0d", cycle);

        // ============================================================
        // PHASE 3: Load ARM IMEM via input_type[4]
        // Mirrors Perl: load_arm_program("arm_dispatch.txt")
        // ARM program configures ctrl unit and dispatches GPU
        // ============================================================
        $display("  Loading ARM IMEM...");
        write_arm_imem(9'h000, ARM_MOV_R1_0x00); // MOV R1, #0x00 (base)
        write_arm_imem(9'h001, ARM_MOV_R2_0x2A); // MOV R2, #0x2A (GPU len=42)
        write_arm_imem(9'h002, ARM_MOV_R3_0xF0); // MOV R3, #0xF0
        write_arm_imem(9'h003, ARM_MOV_R4_0xF1); // MOV R4, #0xF1
        write_arm_imem(9'h004, ARM_MOV_R5_0xF2); // MOV R5, #0xF2
        // 3 NOPs: wait for R3/R4/R5 to complete WB before STRs read them
        // BRAM register file requires MOV->WB before dependent instruction ID
        write_arm_imem(9'h005, ARM_NOP);          // NOP - pipeline fill
        write_arm_imem(9'h006, ARM_NOP);          // NOP - pipeline fill
        write_arm_imem(9'h007, ARM_NOP);          // NOP - pipeline fill
        write_arm_imem(9'h008, ARM_STR_R1_R3);   // STR R1,[R3] -> 0xF0  R3 valid
        // 3 NOPs: wait for STR R1,[R3] to clear, R4 still valid from WB
        write_arm_imem(9'h009, ARM_NOP);          // NOP - pipeline fill
        write_arm_imem(9'h00A, ARM_NOP);          // NOP - pipeline fill
        write_arm_imem(9'h00B, ARM_NOP);          // NOP - pipeline fill
        write_arm_imem(9'h00C, ARM_STR_R2_R4);   // STR R2,[R4] -> 0xF1  R4 valid
        // 3 NOPs: wait for STR R2,[R4] to clear, R5 still valid from WB
        write_arm_imem(9'h00D, ARM_NOP);          // NOP - pipeline fill
        write_arm_imem(9'h00E, ARM_NOP);          // NOP - pipeline fill
        write_arm_imem(9'h00F, ARM_NOP);          // NOP - pipeline fill
        write_arm_imem(9'h010, ARM_STR_R1_R5);   // STR R1,[R5] -> 0xF2  R5 valid - dispatch!
        write_arm_imem(9'h011, ARM_B_SELF);       // B . (halt)
        $display("  ARM IMEM loaded at cycle %0d", cycle);

        // ============================================================
        // PHASE 4: Release ARM CPU via cpu_ctrl SW reg
        // Mirrors Perl: cpu_start()
        // ============================================================
        release_cpu();

        // ============================================================
        // PHASE 5: Wait for gpu_irq
        // ARM executes: MOV x5, STR x3 -> ctrl unit fires gpu_start
        // GPU runs ANN forward pass
        // pipeline_done fires -> gpu_irq asserts
        // ============================================================
        $display("  Waiting for gpu_irq...");
        while (!`GPU_IRQ) @(posedge clk);
        $display("  gpu_irq raised at cycle %0d", cycle);

        // Wait for pipeline to fully drain
        repeat(20) @(posedge clk); #1;

        // ============================================================
        // PHASE 6: Read results
        // Mirrors Perl: read_dmem(0x08) and regread(TENSOR_OUT)
        // Expected: relu(0.75+2.0-0.25-2.0) = relu(0.5) = 0.5
        //           BF16 0x3F00 x4 lanes = 0x3F003F003F003F00
        // ============================================================
        $display("");
        $display("  === ANN NEURON RESULTS ===");

        read_gpu_dmem(8'h08);
        $display("  DMEM[8] result = %h  (exp 0x3F003F003F003F00)", `DMEM_OUT);

        $display("  tensor_out     = %h  (exp 0x3F003F003F003F00)", `TENSOR_OUT);

        $display("");
        $display("  === COMPUTATION ===");
        $display("  relu(1.5*0.5 + 2.0*1.0 + 0.5*(-0.5) + (-1.0)*2.0)");
        $display("  = relu(0.75 + 2.0 - 0.25 - 2.0)");
        $display("  = relu(0.5) = 0.5 -> BF16 0x3F00");

        #100;
        $stop;
    end

    // --- Timeout watchdog ---
    initial begin
        #1000000;
        $display("  [TIMEOUT] at cycle %0d", cycle);
        $stop;
    end

endmodule