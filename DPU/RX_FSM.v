`timescale 1ns/1ps

module RX_FSM (
    input         clk,
    input         reset,
    input  [63:0] in_data,
    input  [7:0]  in_ctrl,
    input         in_wr,
    input         pipeline_done,
    output reg [7:0]  rx_pl_addr,
    output reg [63:0] rx_pl_wdata,
    output reg        rx_pl_we,
    output reg        rx_fsm_busy,
    output reg        in_rdy
);

reg [1:0] state, next_state;
reg [7:0] rx_word_ptr;
reg       flag_payload;

localparam RX_IDLE    = 2'b00;
localparam RX_CAPTURE = 2'b01;
localparam RX_DONE    = 2'b10;

wire SOP     = in_wr && (in_ctrl != 8'h00);
wire PAYLOAD = in_wr && (in_ctrl == 8'h00);
wire EOP     = in_wr && (in_ctrl != 8'h00) && flag_payload;

always @(posedge clk) begin
    if (reset) begin
        state        <= RX_IDLE;
        rx_word_ptr  <= 8'h00;
        flag_payload <= 1'b0;
        rx_pl_we     <= 1'b0;
        rx_pl_addr   <= 8'h00;
        rx_pl_wdata  <= 64'h0;
        rx_fsm_busy  <= 1'b0;
    end else begin
        state <= next_state;
        rx_pl_we <= 1'b0;   // default off, set below

        case (state)
            RX_CAPTURE: begin
                if (PAYLOAD && rx_word_ptr < 8'd64) begin
                    rx_pl_we     <= 1'b1;
                    rx_pl_addr   <= 8'h10 + rx_word_ptr;
                    rx_pl_wdata  <= in_data;
                    rx_word_ptr  <= rx_word_ptr + 8'd1;
                    flag_payload <= 1'b1;
                end
                if (EOP) begin
                    rx_pl_we     <= 1'b1;
                    rx_pl_addr   <= 8'h00;
                    rx_pl_wdata  <= {56'h0, rx_word_ptr};
                    flag_payload <= 1'b0;
                    rx_fsm_busy  <= 1'b1;
                end
            end
            RX_DONE: begin
                rx_word_ptr <= 8'h00;
                rx_fsm_busy <= 1'b0;
            end
        endcase
    end
end

always @(*) begin
    next_state = state;
    in_rdy     = 1'b1;
    case (state)
        RX_IDLE:    if (SOP) next_state = RX_CAPTURE;
        RX_CAPTURE: if (EOP) next_state = RX_DONE;
        RX_DONE:             next_state = RX_IDLE;
        default:             next_state = RX_IDLE;
    endcase
end

endmodule
