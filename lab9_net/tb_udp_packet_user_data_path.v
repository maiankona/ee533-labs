`timescale 1ns/1ps
`define UDP_REG_ADDR_WIDTH 23
`define CPCI_NF2_DATA_WIDTH 32
`define IDS_BLOCK_ADDR      19'h00008

// Simulation sources (add to ISE / ISim project alongside this TB):
//   - generic_regs.v (behavioral SW regs for ids; reg_ack_out = reg_req_in)
//   - udp_reg_master.v    (ring handshake: reg_ack_out = reg_ack_in, core_reg_ack = reg_req_in & reg_ack_in)
// If input_type stays 0 in waveform, you are still linking NF2 library generic_regs / udp_reg_master
// instead of these files — remove or exclude the duplicates.
//
// Note: ids.v ARM/CPU control uses top-level pins (cpu_start, arm_write_to_imem, ...).
// user_data_path passes those through; drive them from TB or platform.
//
// Like tb_ann_neuron: this TB only pulses top-level cpu_start. The ARM program must STR
// 0xF0 / 0xF1 / 0xF2 to dispatch the GPU (gpu_ctrl.gpu_start). Do not pulse input_type[3]
// from the TB for GPU — that is a different SW edge path.
//
// After the packet is injected, wait until convertible_fifo is in PROCESSING (state 2'b10)
// so RECEIVING has finished and head/tail reflect the captured packet before the ARM runs
// its FIFO MMIO (LDR tail / lock / STR ctrl).

// ------------------------------------------------------------
// Minimal behavioral NetFPGA datapath stubs for user_data_path
// (keeps this TB self-contained when full NF modules aren't compiled)
// ------------------------------------------------------------
module input_arbiter #(
    parameter DATA_WIDTH = 64,
    parameter CTRL_WIDTH = DATA_WIDTH/8,
    parameter UDP_REG_SRC_WIDTH = 2,
    parameter STAGE_NUMBER = 0
) (
    output [DATA_WIDTH-1:0] out_data,
    output [CTRL_WIDTH-1:0] out_ctrl,
    output                  out_wr,
    input                   out_rdy,
    input  [DATA_WIDTH-1:0] in_data_0, input [CTRL_WIDTH-1:0] in_ctrl_0, input in_wr_0, output in_rdy_0,
    input  [DATA_WIDTH-1:0] in_data_1, input [CTRL_WIDTH-1:0] in_ctrl_1, input in_wr_1, output in_rdy_1,
    input  [DATA_WIDTH-1:0] in_data_2, input [CTRL_WIDTH-1:0] in_ctrl_2, input in_wr_2, output in_rdy_2,
    input  [DATA_WIDTH-1:0] in_data_3, input [CTRL_WIDTH-1:0] in_ctrl_3, input in_wr_3, output in_rdy_3,
    input  [DATA_WIDTH-1:0] in_data_4, input [CTRL_WIDTH-1:0] in_ctrl_4, input in_wr_4, output in_rdy_4,
    input  [DATA_WIDTH-1:0] in_data_5, input [CTRL_WIDTH-1:0] in_ctrl_5, input in_wr_5, output in_rdy_5,
    input  [DATA_WIDTH-1:0] in_data_6, input [CTRL_WIDTH-1:0] in_ctrl_6, input in_wr_6, output in_rdy_6,
    input  [DATA_WIDTH-1:0] in_data_7, input [CTRL_WIDTH-1:0] in_ctrl_7, input in_wr_7, output in_rdy_7,
    input reg_req_in, input reg_ack_in, input reg_rd_wr_L_in,
    input [`UDP_REG_ADDR_WIDTH-1:0] reg_addr_in, input [`CPCI_NF2_DATA_WIDTH-1:0] reg_data_in, input [UDP_REG_SRC_WIDTH-1:0] reg_src_in,
    output reg_req_out, output reg_ack_out, output reg_rd_wr_L_out,
    output [`UDP_REG_ADDR_WIDTH-1:0] reg_addr_out, output [`CPCI_NF2_DATA_WIDTH-1:0] reg_data_out, output [UDP_REG_SRC_WIDTH-1:0] reg_src_out,
    input reset, input clk
);
    assign out_data = in_data_0;
    assign out_ctrl = in_ctrl_0;
    assign out_wr   = in_wr_0;
    assign in_rdy_0 = out_rdy;
    assign in_rdy_1 = 1'b1; assign in_rdy_2 = 1'b1; assign in_rdy_3 = 1'b1; assign in_rdy_4 = 1'b1;
    assign in_rdy_5 = 1'b1; assign in_rdy_6 = 1'b1; assign in_rdy_7 = 1'b1;
    assign reg_req_out = reg_req_in; assign reg_ack_out = reg_ack_in; assign reg_rd_wr_L_out = reg_rd_wr_L_in;
    assign reg_addr_out = reg_addr_in; assign reg_data_out = reg_data_in; assign reg_src_out = reg_src_in;
endmodule

module output_port_lookup #(
    parameter DATA_WIDTH = 64,
    parameter CTRL_WIDTH = DATA_WIDTH/8,
    parameter UDP_REG_SRC_WIDTH = 2,
    parameter INPUT_ARBITER_STAGE_NUM = 0,
    parameter STAGE_NUM = 0,
    parameter NUM_OUTPUT_QUEUES = 8,
    parameter NUM_IQ_BITS = 3
) (
    output [DATA_WIDTH-1:0] out_data,
    output [CTRL_WIDTH-1:0] out_ctrl,
    output                  out_wr,
    input                   out_rdy,
    input  [DATA_WIDTH-1:0] in_data,
    input  [CTRL_WIDTH-1:0] in_ctrl,
    input                   in_wr,
    output                  in_rdy,
    input reg_req_in, input reg_ack_in, input reg_rd_wr_L_in,
    input [`UDP_REG_ADDR_WIDTH-1:0] reg_addr_in, input [`CPCI_NF2_DATA_WIDTH-1:0] reg_data_in, input [UDP_REG_SRC_WIDTH-1:0] reg_src_in,
    output reg_req_out, output reg_ack_out, output reg_rd_wr_L_out,
    output [`UDP_REG_ADDR_WIDTH-1:0] reg_addr_out, output [`CPCI_NF2_DATA_WIDTH-1:0] reg_data_out, output [UDP_REG_SRC_WIDTH-1:0] reg_src_out,
    input clk, input reset
);
    assign out_data = in_data;
    assign out_ctrl = in_ctrl;
    assign out_wr   = in_wr;
    assign in_rdy   = out_rdy;
    assign reg_req_out = reg_req_in; assign reg_ack_out = reg_ack_in; assign reg_rd_wr_L_out = reg_rd_wr_L_in;
    assign reg_addr_out = reg_addr_in; assign reg_data_out = reg_data_in; assign reg_src_out = reg_src_in;
endmodule

module output_queues #(
    parameter DATA_WIDTH = 64,
    parameter CTRL_WIDTH = DATA_WIDTH/8,
    parameter UDP_REG_SRC_WIDTH = 2,
    parameter OP_LUT_STAGE_NUM = 0,
    parameter NUM_OUTPUT_QUEUES = 8,
    parameter STAGE_NUM = 0,
    parameter SRAM_ADDR_WIDTH = 19
) (
    output [DATA_WIDTH-1:0] out_data_0, output [CTRL_WIDTH-1:0] out_ctrl_0, output out_wr_0, input out_rdy_0,
    output [DATA_WIDTH-1:0] out_data_1, output [CTRL_WIDTH-1:0] out_ctrl_1, output out_wr_1, input out_rdy_1,
    output [DATA_WIDTH-1:0] out_data_2, output [CTRL_WIDTH-1:0] out_ctrl_2, output out_wr_2, input out_rdy_2,
    output [DATA_WIDTH-1:0] out_data_3, output [CTRL_WIDTH-1:0] out_ctrl_3, output out_wr_3, input out_rdy_3,
    output [DATA_WIDTH-1:0] out_data_4, output [CTRL_WIDTH-1:0] out_ctrl_4, output out_wr_4, input out_rdy_4,
    output [DATA_WIDTH-1:0] out_data_5, output [CTRL_WIDTH-1:0] out_ctrl_5, output out_wr_5, input out_rdy_5,
    output [DATA_WIDTH-1:0] out_data_6, output [CTRL_WIDTH-1:0] out_ctrl_6, output out_wr_6, input out_rdy_6,
    output [DATA_WIDTH-1:0] out_data_7, output [CTRL_WIDTH-1:0] out_ctrl_7, output out_wr_7, input out_rdy_7,
    input [DATA_WIDTH-1:0] in_data, input [CTRL_WIDTH-1:0] in_ctrl, output in_rdy, input in_wr,
    input reg_req_in, input reg_ack_in, input reg_rd_wr_L_in,
    input [`UDP_REG_ADDR_WIDTH-1:0] reg_addr_in, input [`CPCI_NF2_DATA_WIDTH-1:0] reg_data_in, input [UDP_REG_SRC_WIDTH-1:0] reg_src_in,
    output reg_req_out, output reg_ack_out, output reg_rd_wr_L_out,
    output [`UDP_REG_ADDR_WIDTH-1:0] reg_addr_out, output [`CPCI_NF2_DATA_WIDTH-1:0] reg_data_out, output [UDP_REG_SRC_WIDTH-1:0] reg_src_out,
    output [SRAM_ADDR_WIDTH-1:0] wr_0_addr, output wr_0_req, input wr_0_ack, output [DATA_WIDTH+CTRL_WIDTH-1:0] wr_0_data,
    input rd_0_ack, input [DATA_WIDTH+CTRL_WIDTH-1:0] rd_0_data, input rd_0_vld, output [SRAM_ADDR_WIDTH-1:0] rd_0_addr, output rd_0_req,
    input clk, input reset
);
    assign out_data_0 = in_data; assign out_ctrl_0 = in_ctrl; assign out_wr_0 = in_wr & out_rdy_0;
    assign out_data_1 = {DATA_WIDTH{1'b0}}; assign out_ctrl_1 = {CTRL_WIDTH{1'b0}}; assign out_wr_1 = 1'b0;
    assign out_data_2 = {DATA_WIDTH{1'b0}}; assign out_ctrl_2 = {CTRL_WIDTH{1'b0}}; assign out_wr_2 = 1'b0;
    assign out_data_3 = {DATA_WIDTH{1'b0}}; assign out_ctrl_3 = {CTRL_WIDTH{1'b0}}; assign out_wr_3 = 1'b0;
    assign out_data_4 = {DATA_WIDTH{1'b0}}; assign out_ctrl_4 = {CTRL_WIDTH{1'b0}}; assign out_wr_4 = 1'b0;
    assign out_data_5 = {DATA_WIDTH{1'b0}}; assign out_ctrl_5 = {CTRL_WIDTH{1'b0}}; assign out_wr_5 = 1'b0;
    assign out_data_6 = {DATA_WIDTH{1'b0}}; assign out_ctrl_6 = {CTRL_WIDTH{1'b0}}; assign out_wr_6 = 1'b0;
    assign out_data_7 = {DATA_WIDTH{1'b0}}; assign out_ctrl_7 = {CTRL_WIDTH{1'b0}}; assign out_wr_7 = 1'b0;
    assign in_rdy = out_rdy_0;
    assign reg_req_out = reg_req_in; assign reg_ack_out = reg_ack_in; assign reg_rd_wr_L_out = reg_rd_wr_L_in;
    assign reg_addr_out = reg_addr_in; assign reg_data_out = reg_data_in; assign reg_src_out = reg_src_in;
    assign wr_0_addr = {SRAM_ADDR_WIDTH{1'b0}}; assign wr_0_req = 1'b0; assign wr_0_data = {(DATA_WIDTH+CTRL_WIDTH){1'b0}};
    assign rd_0_addr = {SRAM_ADDR_WIDTH{1'b0}}; assign rd_0_req = 1'b0;
endmodule

module tb_udp_packet_user_data_path;
    reg clk, reset;

    // 8 input queues
    reg  [63:0] in_data_0, in_data_1, in_data_2, in_data_3, in_data_4, in_data_5, in_data_6, in_data_7;
    reg  [7:0]  in_ctrl_0, in_ctrl_1, in_ctrl_2, in_ctrl_3, in_ctrl_4, in_ctrl_5, in_ctrl_6, in_ctrl_7;
    reg         in_wr_0, in_wr_1, in_wr_2, in_wr_3, in_wr_4, in_wr_5, in_wr_6, in_wr_7;
    wire        in_rdy_0, in_rdy_1, in_rdy_2, in_rdy_3, in_rdy_4, in_rdy_5, in_rdy_6, in_rdy_7;

    // 8 output queues
    wire [63:0] out_data_0, out_data_1, out_data_2, out_data_3, out_data_4, out_data_5, out_data_6, out_data_7;
    wire [7:0]  out_ctrl_0, out_ctrl_1, out_ctrl_2, out_ctrl_3, out_ctrl_4, out_ctrl_5, out_ctrl_6, out_ctrl_7;
    wire        out_wr_0, out_wr_1, out_wr_2, out_wr_3, out_wr_4, out_wr_5, out_wr_6, out_wr_7;
    reg         out_rdy_0, out_rdy_1, out_rdy_2, out_rdy_3, out_rdy_4, out_rdy_5, out_rdy_6, out_rdy_7;

    // SRAM stubs
    wire [18:0] wr_0_addr;
    wire        wr_0_req;
    reg         wr_0_ack;
    wire [71:0] wr_0_data;
    reg         rd_0_ack;
    reg  [71:0] rd_0_data;
    reg         rd_0_vld;
    wire [18:0] rd_0_addr;
    wire        rd_0_req;

    // UDP reg interface (top-level)
    reg                              reg_req;
    wire                             reg_ack;
    reg                              reg_rd_wr_L;
    reg  [`UDP_REG_ADDR_WIDTH-1:0]   reg_addr;
    wire [`CPCI_NF2_DATA_WIDTH-1:0]  reg_rd_data;
    reg  [`CPCI_NF2_DATA_WIDTH-1:0]  reg_wr_data;
    reg                              cpu_start;
    reg                              arm_write_to_imem;
    reg  [8:0]                       arm_addr_imem_host;
    reg  [31:0]                      arm_data_imem_host;

    localparam [22:0] REG_DMEM_HI    = {`IDS_BLOCK_ADDR, 4'h0};
    localparam [22:0] REG_DMEM_LO    = {`IDS_BLOCK_ADDR, 4'h1};
    localparam [22:0] REG_IMEM       = {`IDS_BLOCK_ADDR, 4'h2};
    localparam [22:0] REG_ADDRESS    = {`IDS_BLOCK_ADDR, 4'h3};
    localparam [22:0] REG_INPUT_TYPE = {`IDS_BLOCK_ADDR, 4'h4};

    localparam [31:0] ITYPE_WRITE_IMEM   = 32'h1;   // bit[0]  GPU IMEM (host preload only)

    // ARM ISA (ARM7TDMI-style, matches tb_ann_neuron.v)
    // gpu_control_interface_2: STR to 0xF0 / 0xF1 / 0xF2 then pipeline sees gpu_start (tb_ann_neuron Phase 3).
    localparam [31:0] ARM_MOV_R1_0     = 32'hE3A01000; // MOV R1, #0  (cfg base for GPU IMEM)
    localparam [31:0] ARM_MOV_R2_1     = 32'hE3A02001; // MOV R2, #1  (bram_length: 1 instr = HALT)
    localparam [31:0] ARM_MOV_R3_F0    = 32'hE3A030F0; // MOV R3, #0xF0
    localparam [31:0] ARM_MOV_R4_F1    = 32'hE3A040F1; // MOV R4, #0xF1
    localparam [31:0] ARM_MOV_R5_F2    = 32'hE3A050F2; // MOV R5, #0xF2
    localparam [31:0] ARM_STR_R1_R3    = 32'hE5831000; // STR R1, [R3]
    localparam [31:0] ARM_STR_R2_R4    = 32'hE5842000; // STR R2, [R4]
    localparam [31:0] ARM_STR_R1_R5    = 32'hE5851000; // STR R1, [R5]  -> gpu_dispatch / gpu_start
    // FIFO MMIO (pipeline_psuedoARM): base 0x100 => is_fifo_mapped; +0 head, +4 tail, +8 ctrl
    localparam [31:0] ARM_MOV_R3_0     = 32'hE3A03000; // MOV R3, #0
    localparam [31:0] ARM_ADD_R3_64   = 32'hE2833040; // ADD R3, R3, #0x40  (×4 => R3=0x100)
    localparam [31:0] ARM_MOV_R1_1     = 32'hE3A01001; // MOV R1, #1
    localparam [31:0] ARM_NOP          = 32'hE1A00000;
    localparam [31:0] ARM_LDR_R0_R3_4  = 32'hE5930004; // LDR R0, [R3, #4]  (read tail → claim lock)
    localparam [31:0] ARM_STR_R1_R3_8  = 32'hE5831008; // STR R1, [R3, #8]  (fifo ctrl → start TX)
    localparam [31:0] ARM_B_SELF       = 32'hEAFFFFFE; // B .

    user_data_path dut (
        .in_data_0(in_data_0), .in_ctrl_0(in_ctrl_0), .in_wr_0(in_wr_0), .in_rdy_0(in_rdy_0),
        .in_data_1(in_data_1), .in_ctrl_1(in_ctrl_1), .in_wr_1(in_wr_1), .in_rdy_1(in_rdy_1),
        .in_data_2(in_data_2), .in_ctrl_2(in_ctrl_2), .in_wr_2(in_wr_2), .in_rdy_2(in_rdy_2),
        .in_data_3(in_data_3), .in_ctrl_3(in_ctrl_3), .in_wr_3(in_wr_3), .in_rdy_3(in_rdy_3),
        .in_data_4(in_data_4), .in_ctrl_4(in_ctrl_4), .in_wr_4(in_wr_4), .in_rdy_4(in_rdy_4),
        .in_data_5(in_data_5), .in_ctrl_5(in_ctrl_5), .in_wr_5(in_wr_5), .in_rdy_5(in_rdy_5),
        .in_data_6(in_data_6), .in_ctrl_6(in_ctrl_6), .in_wr_6(in_wr_6), .in_rdy_6(in_rdy_6),
        .in_data_7(in_data_7), .in_ctrl_7(in_ctrl_7), .in_wr_7(in_wr_7), .in_rdy_7(in_rdy_7),
        .out_data_0(out_data_0), .out_ctrl_0(out_ctrl_0), .out_wr_0(out_wr_0), .out_rdy_0(out_rdy_0),
        .out_data_1(out_data_1), .out_ctrl_1(out_ctrl_1), .out_wr_1(out_wr_1), .out_rdy_1(out_rdy_1),
        .out_data_2(out_data_2), .out_ctrl_2(out_ctrl_2), .out_wr_2(out_wr_2), .out_rdy_2(out_rdy_2),
        .out_data_3(out_data_3), .out_ctrl_3(out_ctrl_3), .out_wr_3(out_wr_3), .out_rdy_3(out_rdy_3),
        .out_data_4(out_data_4), .out_ctrl_4(out_ctrl_4), .out_wr_4(out_wr_4), .out_rdy_4(out_rdy_4),
        .out_data_5(out_data_5), .out_ctrl_5(out_ctrl_5), .out_wr_5(out_wr_5), .out_rdy_5(out_rdy_5),
        .out_data_6(out_data_6), .out_ctrl_6(out_ctrl_6), .out_wr_6(out_wr_6), .out_rdy_6(out_rdy_6),
        .out_data_7(out_data_7), .out_ctrl_7(out_ctrl_7), .out_wr_7(out_wr_7), .out_rdy_7(out_rdy_7),
        .wr_0_addr(wr_0_addr), .wr_0_req(wr_0_req), .wr_0_ack(wr_0_ack), .wr_0_data(wr_0_data),
        .rd_0_ack(rd_0_ack), .rd_0_data(rd_0_data), .rd_0_vld(rd_0_vld), .rd_0_addr(rd_0_addr), .rd_0_req(rd_0_req),
        .reg_req(reg_req), .reg_ack(reg_ack), .reg_rd_wr_L(reg_rd_wr_L), .reg_addr(reg_addr),
        .reg_rd_data(reg_rd_data), .reg_wr_data(reg_wr_data),
        .cpu_start(cpu_start),
        .arm_write_to_imem(arm_write_to_imem),
        .arm_addr_imem_host(arm_addr_imem_host),
        .arm_data_imem_host(arm_data_imem_host),
        .reset(reset), .clk(clk)
    );

    initial clk = 1'b0;
    always #4 clk = ~clk;

    task reg_write;
        input [22:0] addr;
        input [31:0] data;
        begin
            $display("[TB][reg_write] addr=%h data=%h t=%0t", addr, data, $time);
            @(negedge clk);
            reg_addr    = addr;
            reg_wr_data = data;
            reg_rd_wr_L = 1'b0;
            reg_req     = 1'b1;
            @(posedge clk);
            @(negedge clk);
            reg_req     = 1'b0;
            reg_rd_wr_L = 1'b1;
        end
    endtask

    task pulse_input_type;
        input [31:0] mask_one_cycle;
        begin
            $display("[TB][pulse_input_type] set mask=%h t=%0t", mask_one_cycle, $time);
            reg_write(REG_INPUT_TYPE, mask_one_cycle);
            reg_write(REG_INPUT_TYPE, 32'h0);
            $display("[TB][pulse_input_type] clear mask t=%0t", $time);
        end
    endtask

    task write_gpu_imem;
        input [8:0]  addr;
        input [31:0] instr;
        begin
            reg_write(REG_ADDRESS, {23'h0, addr});
            reg_write(REG_IMEM, instr);
            pulse_input_type(ITYPE_WRITE_IMEM);
        end
    endtask

    task arm_imem_write_udp;
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

    task pulse_cpu_start_udp;
        begin
            $display("[TB] CPU start pulse requested t=%0t", $time);
            @(negedge clk);
            cpu_start = 1'b1;
            @(negedge clk);
            cpu_start = 1'b0;
        end
    endtask

    task send_word_in0;
        input [7:0]  ctrl;
        input [63:0] data;
        begin
            @(negedge clk);
            while (!in_rdy_0) @(negedge clk);
            in_ctrl_0 = ctrl;
            in_data_0 = data;
            in_wr_0   = 1'b1;
            @(negedge clk);
            in_wr_0   = 1'b0;
            in_ctrl_0 = 8'h0;
            in_data_0 = 64'h0;
        end
    endtask

    always @(posedge clk) begin
`ifdef TB_UDP_VERBOSE
        if (!reset)
            $display("[TB][tick] input_type=%h gpu_start_sw_pulse=%0d cpu_start=%0d t=%0t",
                dut.ids.input_type, dut.ids.gpu_start_sw_pulse, cpu_start, $time);
`endif

        if (!reset && dut.ids_in_reg_req)
            $display("[TB][reg-ring] ids_in_reg_req=1 rd_wr_L=%0d addr=%h data=%h t=%0t",
                dut.ids_in_reg_rd_wr_L, dut.ids_in_reg_addr, dut.ids_in_reg_data, $time);

        if (!reset && dut.ids.net_rx_valid)
            $display("[TB] RX word into ids: ctrl=%02h data=%016h t=%0t",
                dut.ids.net_rx_data[71:64], dut.ids.net_rx_data[63:0], $time);

        if (!reset && (dut.ids.gpu_start_sw_pulse || cpu_start))
            $display("[TB] input_type=%h gpu_start_sw_pulse=%0d cpu_start=%0d t=%0t",
                dut.ids.input_type, dut.ids.gpu_start_sw_pulse, cpu_start, $time);

        if (!reset && (out_wr_0 || out_wr_1 || out_wr_2 || out_wr_3 || out_wr_4 || out_wr_5 || out_wr_6 || out_wr_7))
            $display("[TB] TX word from user_data_path: out_wr=%b%b%b%b%b%b%b%b ctrl0=%02h data0=%016h t=%0t",
                out_wr_7, out_wr_6, out_wr_5, out_wr_4, out_wr_3, out_wr_2, out_wr_1, out_wr_0,
                out_ctrl_0, out_data_0, $time);
    end

    initial begin
        in_data_0=0; in_data_1=0; in_data_2=0; in_data_3=0; in_data_4=0; in_data_5=0; in_data_6=0; in_data_7=0;
        in_ctrl_0=0; in_ctrl_1=0; in_ctrl_2=0; in_ctrl_3=0; in_ctrl_4=0; in_ctrl_5=0; in_ctrl_6=0; in_ctrl_7=0;
        in_wr_0=0; in_wr_1=0; in_wr_2=0; in_wr_3=0; in_wr_4=0; in_wr_5=0; in_wr_6=0; in_wr_7=0;
        out_rdy_0=1; out_rdy_1=1; out_rdy_2=1; out_rdy_3=1; out_rdy_4=1; out_rdy_5=1; out_rdy_6=1; out_rdy_7=1;
        wr_0_ack=1; rd_0_ack=1; rd_0_data=72'h0; rd_0_vld=1'b0;
        reg_req=0; reg_rd_wr_L=1'b1; reg_addr=0; reg_wr_data=0;
        cpu_start=0; arm_write_to_imem=0; arm_addr_imem_host=0; arm_data_imem_host=0;

        reset = 1'b1;
        repeat (5) @(posedge clk);
        reset = 1'b0;
        $display("\n=== tb_udp_packet_user_data_path: reset released @ %0t ===", $time);

        // GPU IMEM[0] = HALT; ARM program below dispatches GPU via MMIO 0xF0–0xF2 (tb_ann_neuron style).
        $display("[TB] Loading GPU IMEM (HALT at word 0)...");
        write_gpu_imem(9'h000, 32'h2C000000);

        // ARM IMEM: GPU kick (STR F0/F1/F2) then FIFO MMIO (0x100+) — no separate TB GPU pulse.
        $display("[TB] Loading ARM IMEM (host arm_write_to_imem)...");
        arm_imem_write_udp(9'h000, ARM_MOV_R1_0);
        arm_imem_write_udp(9'h001, ARM_MOV_R2_1);
        arm_imem_write_udp(9'h002, ARM_MOV_R3_F0);
        arm_imem_write_udp(9'h003, ARM_MOV_R4_F1);
        arm_imem_write_udp(9'h004, ARM_MOV_R5_F2);
        arm_imem_write_udp(9'h005, ARM_STR_R1_R3);
        arm_imem_write_udp(9'h006, ARM_STR_R2_R4);
        arm_imem_write_udp(9'h007, ARM_STR_R1_R5);
        arm_imem_write_udp(9'h008, ARM_MOV_R3_0);
        arm_imem_write_udp(9'h009, ARM_ADD_R3_64);
        arm_imem_write_udp(9'h00A, ARM_ADD_R3_64);
        arm_imem_write_udp(9'h00B, ARM_ADD_R3_64);
        arm_imem_write_udp(9'h00C, ARM_ADD_R3_64);
        arm_imem_write_udp(9'h00D, ARM_MOV_R1_1);
        arm_imem_write_udp(9'h00E, ARM_NOP);
        arm_imem_write_udp(9'h00F, ARM_NOP);
        arm_imem_write_udp(9'h010, ARM_NOP);
        arm_imem_write_udp(9'h011, ARM_NOP);
        arm_imem_write_udp(9'h012, ARM_LDR_R0_R3_4);
        arm_imem_write_udp(9'h013, ARM_NOP);
        arm_imem_write_udp(9'h014, ARM_STR_R1_R3_8);
        arm_imem_write_udp(9'h015, ARM_B_SELF);

        // Packet in (SOP, body, EOP) — convertible_fifo must reach PROCESSING before ARM runs
        // or PROCESSING branch conditions (fifo_tail / lock) never line up with real packet state.
        $display("[TB] Injecting single packet on in_0...");
        send_word_in0(8'hFF, 64'h1122334455667788);
        send_word_in0(8'h00, 64'hDEADBEEFCAFEBABE);
        send_word_in0(8'h01, 64'hA5A5A5A55A5A5A5A);

        begin: UH
            integer nf;
            nf = 0;
            while (dut.ids.shared_fifo.fifo_inst.state != 2'b10 && nf < 10000) begin
                @(posedge clk);
                nf = nf + 1;
            end
            if (nf >= 10000)
                $display("[TB] WARNING: timeout waiting for fifo_inst.state==PROCESSING (2'b10)");
            else
                $display("[TB] fifo_inst.state=PROCESSING after %0d cycles; settling...", nf);
        end
        repeat (8) @(posedge clk);

        $display("[TB] Pulsing cpu_start (ARM runs GPU MMIO then FIFO path; no TB GPU pulse)...");
        pulse_cpu_start_udp();

        repeat (120) @(posedge clk);
        $display("=== tb_udp_packet_user_data_path done @ %0t ===\n", $time);
        $finish;
    end

    initial begin
        #400000;
        $display("[TB] TIMEOUT @ %0t", $time);
        $finish;
    end
endmodule
