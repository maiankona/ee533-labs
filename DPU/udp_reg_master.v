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