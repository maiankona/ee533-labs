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