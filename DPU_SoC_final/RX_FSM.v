`timescale 1ns/1ps

// NetFPGA-style RX: SOP ctrl==8'hFF; payload ctrl==0. After three payload 64b words,
// require EtherType IPv4 in in_data[31:16]==16'h0800 (same field as rx_DPU_multipleSessions).
// Non-IPv4: enter RX_DROP until EOP (no DMEM[0x00] length commit). Truncated frames
// (<3 payload beats before EOP) are discarded the same way.

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
reg [7:0]  rx_word_ptr_next;
reg        flag_payload_next;
reg        rx_pl_we_next;
reg [7:0]  rx_pl_addr_next;
reg [63:0] rx_pl_wdata_next;

localparam RX_IDLE     = 2'd0;
localparam RX_CAPTURE  = 2'd1;
localparam RX_DONE     = 2'd2;
localparam RX_DROP     = 2'd3;

wire SOP     = in_wr && (in_ctrl == 8'hFF);
wire PAYLOAD = in_wr && (in_ctrl == 8'h00);
wire EOP     = in_wr && (in_ctrl != 8'h00) && flag_payload;

// Third payload beat (index 2): Ethernet EtherType field in this project's beat layout.
wire reject_eth = PAYLOAD && (rx_word_ptr == 8'd2) && (in_data[31:16] != 16'h0800);
wire bad_ipv4   = (state == RX_CAPTURE) && reject_eth;

always @(posedge clk) begin
    if (reset) begin
        state        <= RX_IDLE;
        rx_word_ptr  <= 8'h00;
        flag_payload <= 1'b0;
        rx_pl_we     <= 1'b0;
        rx_pl_addr   <= 8'h00;
        rx_pl_wdata  <= 64'h0;
    end else begin
        state        <= next_state;
        rx_word_ptr  <= rx_word_ptr_next;
        flag_payload <= flag_payload_next;
        rx_pl_we     <= rx_pl_we_next;
        rx_pl_addr   <= rx_pl_addr_next;
        rx_pl_wdata  <= rx_pl_wdata_next;
    end
end

always @(*) begin
    next_state = state;
    case (state)
        RX_IDLE:    if (SOP) next_state = RX_CAPTURE;
        RX_CAPTURE: begin
            if (bad_ipv4)
                next_state = RX_DROP;
            else if (EOP && (rx_word_ptr < 8'd3))
                next_state = RX_IDLE;
            else if (EOP)
                next_state = RX_DONE;
        end
        RX_DROP:    if (EOP) next_state = RX_IDLE;
        RX_DONE:                next_state = RX_IDLE;
        default:                next_state = RX_IDLE;
    endcase
end

always @(*) begin
    rx_pl_we_next     = 1'b0;
    rx_pl_addr_next   = rx_pl_addr;
    rx_pl_wdata_next  = rx_pl_wdata;
    rx_word_ptr_next  = rx_word_ptr;
    flag_payload_next = flag_payload;
    in_rdy            = 1'b1;
    rx_fsm_busy       = 1'b0;

    case (state)
        RX_CAPTURE: begin
            if (reject_eth) begin
                // Abort before committing this beat; absorb rest in RX_DROP.
            end else if (EOP && (rx_word_ptr < 8'd3)) begin
                rx_word_ptr_next  = 8'h00;
                flag_payload_next = 1'b0;
            end else if (PAYLOAD && (rx_word_ptr < 8'd64)) begin
                rx_pl_we_next     = 1'b1;
                rx_pl_addr_next   = 8'h10 + rx_word_ptr;
                rx_pl_wdata_next  = in_data;
                rx_word_ptr_next  = rx_word_ptr + 8'd1;
                flag_payload_next = 1'b1;
            end else if (EOP) begin
                rx_pl_we_next     = 1'b1;
                rx_pl_addr_next   = 8'h00;
                rx_pl_wdata_next  = {56'h0, rx_word_ptr};
                flag_payload_next = 1'b0;
            end
        end

        RX_DROP: begin
            if (EOP) begin
                flag_payload_next = 1'b0;
                rx_word_ptr_next  = 8'h00;
            end
        end

        RX_DONE: begin
            rx_word_ptr_next = 8'h00;
        end
        default: ;
    endcase
end

endmodule
