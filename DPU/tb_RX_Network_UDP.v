`timescale 1ns/1ps
`define UDP_REG_ADDR_WIDTH 23
`define CPCI_NF2_DATA_WIDTH 32
`define IDS_BLOCK_ADDR      19'h00008
`define IDS_REG_ADDR_WIDTH  4

// ----------------------------------------------------------------
// Behavioral stubs (same as tb_RX_Network_UDP)
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
    assign reg_req_out=reg_req_in; assign reg_ack_out=reg_req_in;
    assign reg_rd_wr_L_out=reg_rd_wr_L_in; assign reg_addr_out=reg_addr_in;
    assign reg_data_out=reg_data_in; assign reg_src_out=reg_src_in;

    reg [31:0] r_cpu_ctrl, r_dmem_hi, r_dmem_lo, r_imem, r_address, r_input_type;
    assign software_regs = {r_cpu_ctrl, r_dmem_hi, r_dmem_lo, r_imem, r_address, r_input_type};

    always @(posedge clk) begin
        if (reset) begin
            r_cpu_ctrl<=0; r_dmem_hi<=0; r_dmem_lo<=0;
            r_imem<=0; r_address<=0; r_input_type<=0;
        end else if (reg_req_in && !reg_rd_wr_L_in && reg_addr_in[22:4]==TAG) begin
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

module input_arbiter #(
    parameter DATA_WIDTH=64, parameter CTRL_WIDTH=DATA_WIDTH/8,
    parameter UDP_REG_SRC_WIDTH=2, parameter STAGE_NUMBER=0
) (
    output [DATA_WIDTH-1:0] out_data, output [CTRL_WIDTH-1:0] out_ctrl, output out_wr, input out_rdy,
    input [DATA_WIDTH-1:0] in_data_0, input [CTRL_WIDTH-1:0] in_ctrl_0, input in_wr_0, output in_rdy_0,
    input [DATA_WIDTH-1:0] in_data_1, input [CTRL_WIDTH-1:0] in_ctrl_1, input in_wr_1, output in_rdy_1,
    input [DATA_WIDTH-1:0] in_data_2, input [CTRL_WIDTH-1:0] in_ctrl_2, input in_wr_2, output in_rdy_2,
    input [DATA_WIDTH-1:0] in_data_3, input [CTRL_WIDTH-1:0] in_ctrl_3, input in_wr_3, output in_rdy_3,
    input [DATA_WIDTH-1:0] in_data_4, input [CTRL_WIDTH-1:0] in_ctrl_4, input in_wr_4, output in_rdy_4,
    input [DATA_WIDTH-1:0] in_data_5, input [CTRL_WIDTH-1:0] in_ctrl_5, input in_wr_5, output in_rdy_5,
    input [DATA_WIDTH-1:0] in_data_6, input [CTRL_WIDTH-1:0] in_ctrl_6, input in_wr_6, output in_rdy_6,
    input [DATA_WIDTH-1:0] in_data_7, input [CTRL_WIDTH-1:0] in_ctrl_7, input in_wr_7, output in_rdy_7,
    input reg_req_in, input reg_ack_in, input reg_rd_wr_L_in,
    input [`UDP_REG_ADDR_WIDTH-1:0] reg_addr_in, input [`CPCI_NF2_DATA_WIDTH-1:0] reg_data_in,
    input [UDP_REG_SRC_WIDTH-1:0] reg_src_in,
    output reg_req_out, output reg_ack_out, output reg_rd_wr_L_out,
    output [`UDP_REG_ADDR_WIDTH-1:0] reg_addr_out, output [`CPCI_NF2_DATA_WIDTH-1:0] reg_data_out,
    output [UDP_REG_SRC_WIDTH-1:0] reg_src_out,
    input reset, input clk
);
    assign out_data=in_data_0; assign out_ctrl=in_ctrl_0; assign out_wr=in_wr_0;
    assign in_rdy_0=out_rdy;
    assign in_rdy_1=1'b1; assign in_rdy_2=1'b1; assign in_rdy_3=1'b1; assign in_rdy_4=1'b1;
    assign in_rdy_5=1'b1; assign in_rdy_6=1'b1; assign in_rdy_7=1'b1;
    assign reg_req_out=reg_req_in; assign reg_ack_out=reg_ack_in;
    assign reg_rd_wr_L_out=reg_rd_wr_L_in; assign reg_addr_out=reg_addr_in;
    assign reg_data_out=reg_data_in; assign reg_src_out=reg_src_in;
endmodule

module output_port_lookup #(
    parameter DATA_WIDTH=64, parameter CTRL_WIDTH=DATA_WIDTH/8,
    parameter UDP_REG_SRC_WIDTH=2, parameter INPUT_ARBITER_STAGE_NUM=0,
    parameter STAGE_NUM=0, parameter NUM_OUTPUT_QUEUES=8, parameter NUM_IQ_BITS=3
) (
    output [DATA_WIDTH-1:0] out_data, output [CTRL_WIDTH-1:0] out_ctrl, output out_wr, input out_rdy,
    input  [DATA_WIDTH-1:0] in_data,  input  [CTRL_WIDTH-1:0] in_ctrl,  input in_wr, output in_rdy,
    input reg_req_in, input reg_ack_in, input reg_rd_wr_L_in,
    input [`UDP_REG_ADDR_WIDTH-1:0] reg_addr_in, input [`CPCI_NF2_DATA_WIDTH-1:0] reg_data_in,
    input [UDP_REG_SRC_WIDTH-1:0] reg_src_in,
    output reg_req_out, output reg_ack_out, output reg_rd_wr_L_out,
    output [`UDP_REG_ADDR_WIDTH-1:0] reg_addr_out, output [`CPCI_NF2_DATA_WIDTH-1:0] reg_data_out,
    output [UDP_REG_SRC_WIDTH-1:0] reg_src_out,
    input clk, input reset
);
    assign out_data=in_data; assign out_ctrl=in_ctrl; assign out_wr=in_wr; assign in_rdy=out_rdy;
    assign reg_req_out=reg_req_in; assign reg_ack_out=reg_ack_in;
    assign reg_rd_wr_L_out=reg_rd_wr_L_in; assign reg_addr_out=reg_addr_in;
    assign reg_data_out=reg_data_in; assign reg_src_out=reg_src_in;
endmodule

module output_queues #(
    parameter DATA_WIDTH=64, parameter CTRL_WIDTH=DATA_WIDTH/8,
    parameter UDP_REG_SRC_WIDTH=2, parameter OP_LUT_STAGE_NUM=0,
    parameter NUM_OUTPUT_QUEUES=8, parameter STAGE_NUM=0, parameter SRAM_ADDR_WIDTH=19
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
    input [`UDP_REG_ADDR_WIDTH-1:0] reg_addr_in, input [`CPCI_NF2_DATA_WIDTH-1:0] reg_data_in,
    input [UDP_REG_SRC_WIDTH-1:0] reg_src_in,
    output reg_req_out, output reg_ack_out, output reg_rd_wr_L_out,
    output [`UDP_REG_ADDR_WIDTH-1:0] reg_addr_out, output [`CPCI_NF2_DATA_WIDTH-1:0] reg_data_out,
    output [UDP_REG_SRC_WIDTH-1:0] reg_src_out,
    output [SRAM_ADDR_WIDTH-1:0] wr_0_addr, output wr_0_req, input wr_0_ack,
    output [DATA_WIDTH+CTRL_WIDTH-1:0] wr_0_data,
    input rd_0_ack, input [DATA_WIDTH+CTRL_WIDTH-1:0] rd_0_data, input rd_0_vld,
    output [SRAM_ADDR_WIDTH-1:0] rd_0_addr, output rd_0_req,
    input clk, input reset
);
    assign out_data_0=in_data; assign out_ctrl_0=in_ctrl; assign out_wr_0=in_wr & out_rdy_0;
    assign out_data_1=0; assign out_ctrl_1=0; assign out_wr_1=0;
    assign out_data_2=0; assign out_ctrl_2=0; assign out_wr_2=0;
    assign out_data_3=0; assign out_ctrl_3=0; assign out_wr_3=0;
    assign out_data_4=0; assign out_ctrl_4=0; assign out_wr_4=0;
    assign out_data_5=0; assign out_ctrl_5=0; assign out_wr_5=0;
    assign out_data_6=0; assign out_ctrl_6=0; assign out_wr_6=0;
    assign out_data_7=0; assign out_ctrl_7=0; assign out_wr_7=0;
    assign in_rdy=out_rdy_0;
    assign reg_req_out=reg_req_in; assign reg_ack_out=reg_ack_in;
    assign reg_rd_wr_L_out=reg_rd_wr_L_in; assign reg_addr_out=reg_addr_in;
    assign reg_data_out=reg_data_in; assign reg_src_out=reg_src_in;
    assign wr_0_addr=0; assign wr_0_req=0; assign wr_0_data=0;
    assign rd_0_addr=0; assign rd_0_req=0;
endmodule

module udp_reg_master #(parameter UDP_REG_SRC_WIDTH=2) (
    input core_reg_req, output core_reg_ack, input core_reg_rd_wr_L,
    input  [`UDP_REG_ADDR_WIDTH-1:0]  core_reg_addr,
    output [`CPCI_NF2_DATA_WIDTH-1:0] core_reg_rd_data,
    input  [`CPCI_NF2_DATA_WIDTH-1:0] core_reg_wr_data,
    output reg_req_out, output reg_ack_out, output reg_rd_wr_L_out,
    output [`UDP_REG_ADDR_WIDTH-1:0]  reg_addr_out,
    output [`CPCI_NF2_DATA_WIDTH-1:0] reg_data_out,
    output [UDP_REG_SRC_WIDTH-1:0]    reg_src_out,
    input  reg_req_in,  input  reg_ack_in,  input  reg_rd_wr_L_in,
    input  [`UDP_REG_ADDR_WIDTH-1:0]  reg_addr_in,
    input  [`CPCI_NF2_DATA_WIDTH-1:0] reg_data_in,
    input  [UDP_REG_SRC_WIDTH-1:0]    reg_src_in,
    input clk, input reset
);
    assign reg_req_out=core_reg_req; assign reg_ack_out=core_reg_req;
    assign reg_rd_wr_L_out=core_reg_rd_wr_L; assign reg_addr_out=core_reg_addr;
    assign reg_data_out=core_reg_wr_data; assign reg_src_out=0;
    assign core_reg_ack=reg_ack_in; assign core_reg_rd_data=reg_data_in;
endmodule

// ----------------------------------------------------------------
// Testbench: tb_ids_rx_network
// Tests RX_FSM packet capture through full user_data_path:
//   - Packet 1: pipeline_done=1 before packet → normal capture
//   - Packet 2: pipeline_done=1 during wait   → normal capture
//   - Packet 3: pipeline_done=0 during wait   → STALL (in_rdy=0)
//   - Packet 4: pipeline_done=1 asserted      → unstall, capture
//   - Packet 5: back-to-back after unstall    → normal capture
// Monitors: RX_FSM state, rx_pl_addr, rx_pl_wdata, rx_pl_we, in_rdy
// ----------------------------------------------------------------
module tb_RX_Network_UDP;

    reg clk, reset;

    // Input queues (only port 0 used for packet injection)
    reg  [63:0] in_data_0; reg [7:0] in_ctrl_0; reg in_wr_0; wire in_rdy_0;
    reg  [63:0] in_data_1; reg [7:0] in_ctrl_1; reg in_wr_1; wire in_rdy_1;
    reg  [63:0] in_data_2; reg [7:0] in_ctrl_2; reg in_wr_2; wire in_rdy_2;
    reg  [63:0] in_data_3; reg [7:0] in_ctrl_3; reg in_wr_3; wire in_rdy_3;
    reg  [63:0] in_data_4; reg [7:0] in_ctrl_4; reg in_wr_4; wire in_rdy_4;
    reg  [63:0] in_data_5; reg [7:0] in_ctrl_5; reg in_wr_5; wire in_rdy_5;
    reg  [63:0] in_data_6; reg [7:0] in_ctrl_6; reg in_wr_6; wire in_rdy_6;
    reg  [63:0] in_data_7; reg [7:0] in_ctrl_7; reg in_wr_7; wire in_rdy_7;

    // Output queues
    wire [63:0] out_data_0; wire [7:0] out_ctrl_0; wire out_wr_0; reg out_rdy_0;
    wire [63:0] out_data_1; wire [7:0] out_ctrl_1; wire out_wr_1; reg out_rdy_1;
    wire [63:0] out_data_2; wire [7:0] out_ctrl_2; wire out_wr_2; reg out_rdy_2;
    wire [63:0] out_data_3; wire [7:0] out_ctrl_3; wire out_wr_3; reg out_rdy_3;
    wire [63:0] out_data_4; wire [7:0] out_ctrl_4; wire out_wr_4; reg out_rdy_4;
    wire [63:0] out_data_5; wire [7:0] out_ctrl_5; wire out_wr_5; reg out_rdy_5;
    wire [63:0] out_data_6; wire [7:0] out_ctrl_6; wire out_wr_6; reg out_rdy_6;
    wire [63:0] out_data_7; wire [7:0] out_ctrl_7; wire out_wr_7; reg out_rdy_7;

    // SRAM stubs
    wire [18:0] wr_0_addr; wire wr_0_req; reg wr_0_ack; wire [71:0] wr_0_data;
    reg rd_0_ack; reg [71:0] rd_0_data; reg rd_0_vld;
    wire [18:0] rd_0_addr; wire rd_0_req;

    // Register interface
    reg                             reg_req;
    wire                            reg_ack;
    reg                             reg_rd_wr_L;
    reg  [`UDP_REG_ADDR_WIDTH-1:0]  reg_addr;
    wire [`CPCI_NF2_DATA_WIDTH-1:0] reg_rd_data;
    reg  [`CPCI_NF2_DATA_WIDTH-1:0] reg_wr_data;

    // SW register addresses
    localparam [22:0] REG_INPUT_TYPE = {`IDS_BLOCK_ADDR, 4'h0};
    localparam [22:0] REG_CPU_CTRL   = {`IDS_BLOCK_ADDR, 4'h5};

    // ----------------------------------------------------------------
    // DUT
    // ----------------------------------------------------------------
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
        .rd_0_ack(rd_0_ack), .rd_0_data(rd_0_data), .rd_0_vld(rd_0_vld),
        .rd_0_addr(rd_0_addr), .rd_0_req(rd_0_req),
        .reg_req(reg_req), .reg_ack(reg_ack), .reg_rd_wr_L(reg_rd_wr_L),
        .reg_addr(reg_addr), .reg_rd_data(reg_rd_data), .reg_wr_data(reg_wr_data),
        .reset(reset), .clk(clk)
    );

    // ----------------------------------------------------------------
    // Clock
    // ----------------------------------------------------------------
    initial clk = 1'b0;
    always #4 clk = ~clk;   // 125 MHz

    // ----------------------------------------------------------------
    // Task: send_packet
    // Drives a 3-word NF2.1 packet (IOQ header + 4 payload words + EOP)
    // on port 0. Waits for in_rdy_0 before each word.
    // ----------------------------------------------------------------
    task send_packet;
        input [63:0] p0, p1, p2, p3;   // 4 payload words
        input [7:0]  pkt_id;            // for display only
        integer i;
        begin
            $display("[PKT%0d] Sending packet @ %0t", pkt_id, $time);

            // IOQ header word (ctrl=0xFF)
            @(negedge clk);
            wait (in_rdy_0 === 1'b1);
            in_ctrl_0 = 8'hFF;
            in_data_0 = 64'h0008_0003_0008_0028;  // IOQ: dst=nf2c3, 3 words, 40 bytes
            in_wr_0   = 1'b1;
            @(negedge clk);

            // Payload word 0
            wait (in_rdy_0 === 1'b1);
            in_ctrl_0 = 8'h00; in_data_0 = p0; @(negedge clk);

            // Payload word 1
            wait (in_rdy_0 === 1'b1);
            in_ctrl_0 = 8'h00; in_data_0 = p1; @(negedge clk);

            // Payload word 2
            wait (in_rdy_0 === 1'b1);
            in_ctrl_0 = 8'h00; in_data_0 = p2; @(negedge clk);

            // Payload word 3
            wait (in_rdy_0 === 1'b1);
            in_ctrl_0 = 8'h00; in_data_0 = p3; @(negedge clk);

            // EOP (ctrl=0x80)
            wait (in_rdy_0 === 1'b1);
            in_ctrl_0 = 8'h80;
            in_data_0 = 64'h0;
            @(negedge clk);

            // Deassert
            in_wr_0   = 1'b0;
            in_ctrl_0 = 8'h00;
            in_data_0 = 64'h0;
            $display("[PKT%0d] Done @ %0t", pkt_id, $time);
        end
    endtask

    // ----------------------------------------------------------------
    // Monitor: fires every clock, prints RX_FSM state transitions
    // and BRAM writes
    // ----------------------------------------------------------------
    reg [1:0] prev_rx_state;
    always @(posedge clk) begin
        if (!reset) begin
            // State transition
            if (dut.ids.RX_FSM.state !== prev_rx_state) begin
                $display("[MON] RX_FSM state %0d → %0d  in_rdy=%0d rx_fsm_busy=%0d  t=%0t",
                    prev_rx_state,
                    dut.ids.RX_FSM.state,
                    dut.ids.rx_in_rdy,
                    dut.ids.rx_fsm_busy,
                    $time);
                prev_rx_state <= dut.ids.RX_FSM.state;
            end

            // BRAM write
            if (dut.ids.rx_pl_we) begin
                $display("[MON] BRAM WRITE  addr=0x%02h  data=0x%016h  t=%0t",
                    dut.ids.rx_pl_addr,
                    dut.ids.rx_pl_wdata,
                    $time);
            end

            // in_rdy transitions
            if (dut.ids.in_rdy !== dut.ids.rx_in_rdy) begin
                $display("[MON] in_rdy=%0d (rx_in_rdy=%0d gpu_busy=%0d)  t=%0t",
                    dut.ids.in_rdy,
                    dut.ids.rx_in_rdy,
                    dut.ids.gpu_mem_busy,
                    $time);
            end
        end else begin
            prev_rx_state <= 2'b00;
        end
    end

    // ----------------------------------------------------------------
    // Main sequence — mirrors tb_RX_FSM but at user_data_path level
    // ----------------------------------------------------------------
    initial begin
        // Initialise all inputs
        {in_data_0,in_data_1,in_data_2,in_data_3,
         in_data_4,in_data_5,in_data_6,in_data_7} = 0;
        {in_ctrl_0,in_ctrl_1,in_ctrl_2,in_ctrl_3,
         in_ctrl_4,in_ctrl_5,in_ctrl_6,in_ctrl_7} = 0;
        {in_wr_0,in_wr_1,in_wr_2,in_wr_3,
         in_wr_4,in_wr_5,in_wr_6,in_wr_7} = 0;
        {out_rdy_0,out_rdy_1,out_rdy_2,out_rdy_3,
         out_rdy_4,out_rdy_5,out_rdy_6,out_rdy_7} = 8'hFF;
        wr_0_ack=1; rd_0_ack=1; rd_0_data=0; rd_0_vld=0;
        reg_req=0; reg_rd_wr_L=1; reg_addr=0; reg_wr_data=0;

        // Reset
        reset = 1'b1;
        repeat (6) @(posedge clk);
        reset = 1'b0;
        $display("\n=== tb_ids_rx_network: reset released @ %0t ===\n", $time);
        repeat (2) @(posedge clk);

        // --------------------------------------------------------
        // PKT 1: pipeline_done already high → IDLE→CAPTURE→WAIT→DONE→IDLE
        // --------------------------------------------------------
        $display("\n--- PKT 1: normal (pipeline_done=1 pre-asserted) ---");
        // pipeline_done is driven by gpu_Unit inside DUT.
        // For standalone RX_FSM test we force it via a direct force.
        // In the integrated path, once RX_DONE fires, gpu_Unit's pipeline_done
        // would normally clear. Here we force it high for the first two packets.
        force dut.ids.pipeline_done = 1'b1;
        send_packet(64'h1111_1111_1111_1111,
                    64'h2222_2222_2222_2222,
                    64'h3333_3333_3333_3333,
                    64'h4444_4444_4444_4444, 8'd1);
        repeat (5) @(posedge clk);

        // --------------------------------------------------------
        // PKT 2: pipeline_done=1, back-to-back normal
        // --------------------------------------------------------
        $display("\n--- PKT 2: back-to-back (pipeline_done=1) ---");
        send_packet(64'hAAAA_AAAA_AAAA_AAAA,
                    64'hBBBB_BBBB_BBBB_BBBB,
                    64'hCCCC_CCCC_CCCC_CCCC,
                    64'hDDDD_DDDD_DDDD_DDDD, 8'd2);
        repeat (5) @(posedge clk);

        // --------------------------------------------------------
        // PKT 3: pipeline_done=0 → RX_FSM should stall in RX_WAIT_GPU
        //   Step 1: force pipeline_done=0 BEFORE sending packet
        //   Step 2: send packet — FSM captures payload, hits EOP, writes
        //           word_count to 0x00, transitions to RX_WAIT_GPU
        //   Step 3: FSM asserts in_rdy=0 (backpressure), rx_fsm_busy=1
        //   Step 4: wait 10 cycles so stall is visible in waveform
        //   Step 5: release pipeline_done=1 → FSM exits WAIT, clears 0x00
        // --------------------------------------------------------
        $display("\n--- PKT 3: STALL test (pipeline_done=0 pre-asserted) ---");
        force dut.ids.pipeline_done = 1'b0;   // deassert BEFORE packet
        repeat (2) @(posedge clk);            // let force settle

        // Send the packet — FSM will complete CAPTURE and enter WAIT_GPU
        send_packet(64'hDEAD_BEEF_CAFE_BABE,
                    64'h1234_5678_9ABC_DEF0,
                    64'hFEED_FACE_C0DE_CAFE,
                    64'h0BAD_F00D_1234_5678, 8'd3);

        // At this point FSM is in RX_WAIT_GPU: in_rdy=0, rx_fsm_busy=1
        $display("[TB] PKT3 sent — FSM should be stalled in RX_WAIT_GPU @ %0t", $time);
        repeat (10) @(posedge clk);           // hold stall visible in waveform

        $display("[TB] Releasing pipeline_done to unstall @ %0t", $time);
        force dut.ids.pipeline_done = 1'b1;
        repeat (5) @(posedge clk);            // let FSM cycle through DONE→IDLE

        // --------------------------------------------------------
        // PKT 4: after stall released, normal
        // --------------------------------------------------------
        $display("\n--- PKT 4: post-stall normal ---");
        send_packet(64'hCAFE_CAFE_CAFE_CAFE,
                    64'h1234_1234_1234_1234,
                    64'hABCD_ABCD_ABCD_ABCD,
                    64'hDEAD_DEAD_DEAD_DEAD, 8'd4);
        repeat (5) @(posedge clk);

        // --------------------------------------------------------
        // PKT 5: back-to-back after stall
        // --------------------------------------------------------
        $display("\n--- PKT 5: final back-to-back ---");
        send_packet(64'hFFFF_FFFF_FFFF_FFFF,
                    64'h0000_0000_0000_0001,
                    64'h0000_0000_0000_0002,
                    64'h0000_0000_0000_0003, 8'd5);
        repeat (10) @(posedge clk);

        release dut.ids.pipeline_done;

        $display("\n=== tb_ids_rx_network DONE @ %0t ===\n", $time);
        $stop;
    end

    // Timeout
    initial begin
        #500000;
        $display("[TB] TIMEOUT @ %0t", $time);
        $finish;
    end

endmodule