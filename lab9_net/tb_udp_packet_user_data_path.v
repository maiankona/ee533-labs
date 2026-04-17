`timescale 1ns/1ps
`define UDP_REG_ADDR_WIDTH 23
`define CPCI_NF2_DATA_WIDTH 32
`define IDS_BLOCK_ADDR      19'h00008

// Standalone behavioral generic_regs for simulation.
// Do not compile this TB together with other TBs that also define generic_regs.
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

    reg [31:0] r_dmem_hi, r_dmem_lo, r_imem, r_address, r_input_type;
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

module udp_reg_master #(
    parameter UDP_REG_SRC_WIDTH = 2
) (
    input core_reg_req, output core_reg_ack, input core_reg_rd_wr_L,
    input [`UDP_REG_ADDR_WIDTH-1:0] core_reg_addr,
    output [`CPCI_NF2_DATA_WIDTH-1:0] core_reg_rd_data,
    input  [`CPCI_NF2_DATA_WIDTH-1:0] core_reg_wr_data,
    output reg_req_out, output reg_ack_out, output reg_rd_wr_L_out,
    output [`UDP_REG_ADDR_WIDTH-1:0] reg_addr_out, output [`CPCI_NF2_DATA_WIDTH-1:0] reg_data_out, output [UDP_REG_SRC_WIDTH-1:0] reg_src_out,
    input reg_req_in, input reg_ack_in, input reg_rd_wr_L_in,
    input [`UDP_REG_ADDR_WIDTH-1:0] reg_addr_in, input [`CPCI_NF2_DATA_WIDTH-1:0] reg_data_in, input [UDP_REG_SRC_WIDTH-1:0] reg_src_in,
    input clk, input reset
);
    assign reg_req_out = core_reg_req;
    assign reg_ack_out = core_reg_req;
    assign reg_rd_wr_L_out = core_reg_rd_wr_L;
    assign reg_addr_out = core_reg_addr;
    assign reg_data_out = core_reg_wr_data;
    assign reg_src_out = {UDP_REG_SRC_WIDTH{1'b0}};
    assign core_reg_ack = reg_ack_in;
    assign core_reg_rd_data = reg_data_in;
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

    localparam [22:0] REG_DMEM_HI    = {`IDS_BLOCK_ADDR, 4'h0};
    localparam [22:0] REG_DMEM_LO    = {`IDS_BLOCK_ADDR, 4'h1};
    localparam [22:0] REG_IMEM       = {`IDS_BLOCK_ADDR, 4'h2};
    localparam [22:0] REG_ADDRESS    = {`IDS_BLOCK_ADDR, 4'h3};
    localparam [22:0] REG_INPUT_TYPE = {`IDS_BLOCK_ADDR, 4'h4};

    localparam [31:0] ITYPE_WRITE_IMEM   = 32'h1;   // bit[0]  GPU IMEM
    localparam [31:0] ITYPE_GPU_START    = 32'h8;   // bit[3]
    localparam [31:0] ITYPE_CPU_START    = 32'h20;  // bit[5]  ARM cpu_start pulse (ids.v)
    localparam [31:0] ITYPE_ARM_IMEM_WE  = 32'h40;  // bit[6]  ARM IMEM write (ids.v)

    // ARM ISA (ARM7TDMI-style, matches tb_ann_neuron.v)
    // FIFO MMIO (pipeline_psuedoARM): base 0x100 => is_fifo_mapped; +0 head, +4 tail, +8 ctrl
    localparam [31:0] ARM_MOV_R3_0     = 32'hE3A03000; // MOV R3, #0
    localparam [31:0] ARM_ADD_R3_64  = 32'hE2833040; // ADD R3, R3, #0x40  (×4 => R3=0x100)
    localparam [31:0] ARM_MOV_R1_1     = 32'hE3A01001; // MOV R1, #1
    localparam [31:0] ARM_NOP          = 32'hE1A00000;
    localparam [31:0] ARM_LDR_R0_R3_4  = 32'hE5930004; // LDR R0, [R3, #4]  (read tail ? claim lock)
    localparam [31:0] ARM_STR_R1_R3_8  = 32'hE5831008; // STR R1, [R3, #8]  (fifo ctrl ? start TX)
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
            reg_write(REG_ADDRESS, {23'h0, addr});
            reg_write(REG_IMEM, instr);
            pulse_input_type(ITYPE_ARM_IMEM_WE);
        end
    endtask

    task pulse_cpu_start_udp;
        begin
            $display("[TB] CPU start pulse requested t=%0t", $time);
            pulse_input_type(ITYPE_CPU_START);
        end
    endtask

    task pulse_gpu_start_udp;
        begin
            $display("[TB] GPU start pulse requested t=%0t", $time);
            pulse_input_type(ITYPE_GPU_START);
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
        if (!reset)
            $display("[TB][tick] input_type=%h gpu_pulse=%0d cpu_pulse=%0d t=%0t",
                dut.ids.input_type, dut.ids.gpu_start_sw_pulse, dut.ids.cpu_start_sw_pulse, $time);

        if (!reset && dut.ids.net_rx_valid)
            $display("[TB] RX word into ids: ctrl=%02h data=%016h t=%0t",
                dut.ids.net_rx_data[71:64], dut.ids.net_rx_data[63:0], $time);

        if (!reset && (dut.ids.input_type[3] || dut.ids.input_type[5] ||
                       dut.ids.gpu_start_sw_pulse || dut.ids.cpu_start_sw_pulse))
            $display("[TB] input_type=%h sw_bits(gpu=%0d cpu=%0d) sw_pulses(gpu=%0d cpu=%0d) t=%0t",
                dut.ids.input_type,
                dut.ids.input_type[3], dut.ids.input_type[5],
                dut.ids.gpu_start_sw_pulse, dut.ids.cpu_start_sw_pulse,
                $time);

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

        reset = 1'b1;
        repeat (5) @(posedge clk);
        reset = 1'b0;
        $display("\n=== tb_udp_packet_user_data_path: reset released @ %0t ===", $time);

        // Minimal GPU touch: load HALT at IMEM[0], pulse GPU start (tensor path smoke).
        $display("[TB] Loading minimal GPU program (HALT) and pulsing GPU start...");
        write_gpu_imem(9'h000, 32'h2C000000);
        reg_write(REG_ADDRESS, 32'h00000100); // length=1, start addr=0 for SW gpu_start mux
        pulse_gpu_start_udp();

        // ARM: build FIFO base 0x100, LDR tail (+4) to claim lock, STR to ctrl (+8) to transmit.
        $display("[TB] Loading ARM IMEM via UDP (input_type[6] arm_write_to_imem)...");
        arm_imem_write_udp(9'h000, ARM_MOV_R3_0);
        arm_imem_write_udp(9'h001, ARM_ADD_R3_64);
        arm_imem_write_udp(9'h002, ARM_ADD_R3_64);
        arm_imem_write_udp(9'h003, ARM_ADD_R3_64);
        arm_imem_write_udp(9'h004, ARM_ADD_R3_64);
        arm_imem_write_udp(9'h005, ARM_MOV_R1_1);
        arm_imem_write_udp(9'h006, ARM_NOP);
        arm_imem_write_udp(9'h007, ARM_NOP);
        arm_imem_write_udp(9'h008, ARM_NOP);
        arm_imem_write_udp(9'h009, ARM_NOP);
        arm_imem_write_udp(9'h00A, ARM_LDR_R0_R3_4);
        arm_imem_write_udp(9'h00B, ARM_NOP);
        arm_imem_write_udp(9'h00C, ARM_STR_R1_R3_8);
        arm_imem_write_udp(9'h00D, ARM_B_SELF);

        // One packet: SOP, body, EOP
        $display("[TB] Injecting single packet on in_0...");
        send_word_in0(8'hFF, 64'h1122334455667788);
        send_word_in0(8'h00, 64'hDEADBEEFCAFEBABE);
        send_word_in0(8'h01, 64'hA5A5A5A55A5A5A5A);

        // Let packet land in convertible_fifo FSM (PROCESSING); allow GPU fifo_gpu_mode to drop.
        repeat (40) @(posedge clk);
        $display("[TB] Pulsing ARM cpu_start (UDP input_type[5])...");
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