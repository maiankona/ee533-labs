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
reg [7:0]  rx_word_ptr_next;
reg        flag_payload_next;
reg        rx_pl_we_next;
reg [7:0]  rx_pl_addr_next;
reg [63:0] rx_pl_wdata_next;

// ----------------------------------------------------------------
// EtherType filter
// Word 1 (second 64-bit word after SOP) contains:
//   bits [15:0] = EtherType (big-endian in network order)
// We check this on word_ptr == 1 to decide whether to keep the packet.
//
// EtherType 0x0800 = IPv4  → accept
// EtherType 0x0806 = ARP   → drop
// All others                → drop
// ----------------------------------------------------------------
reg        pkt_accepted;        // 1 = this packet passed the filter
reg        pkt_accepted_next;
reg [7:0]  header_word_cnt;     // counts words from SOP (including IOQ hdr)
reg [7:0]  header_word_cnt_next;

localparam ETHERTYPE_IPv4 = 16'h0800;

localparam RX_IDLE     = 2'b00;
localparam RX_CAPTURE  = 2'b01;
localparam RX_DONE     = 2'b10;
localparam RX_DROP     = 2'b11;   // new: drain unwanted packet

wire SOP     = in_wr && (in_ctrl != 8'h00);
wire PAYLOAD = in_wr && (in_ctrl == 8'h00);
wire EOP     = in_wr && (in_ctrl != 8'h00) && flag_payload;

always @(posedge clk) begin
    if (reset) begin
        state            <= RX_IDLE;
        rx_word_ptr      <= 8'h00;
        flag_payload     <= 1'b0;
        rx_pl_we         <= 1'b0;
        rx_pl_addr       <= 8'h00;
        rx_pl_wdata      <= 64'h0;
        pkt_accepted     <= 1'b0;
        header_word_cnt  <= 8'h00;
    end else begin
        state            <= next_state;
        rx_word_ptr      <= rx_word_ptr_next;
        flag_payload     <= flag_payload_next;
        rx_pl_we         <= rx_pl_we_next;
        rx_pl_addr       <= rx_pl_addr_next;
        rx_pl_wdata      <= rx_pl_wdata_next;
        pkt_accepted     <= pkt_accepted_next;
        header_word_cnt  <= header_word_cnt_next;
    end
end

always @(*) begin
    next_state = state;
    case (state)
        RX_IDLE:    if (SOP)                    next_state = RX_CAPTURE;
        RX_CAPTURE: begin
                    if (EOP && pkt_accepted)    next_state = RX_DONE;
                    else if (EOP)               next_state = RX_IDLE;  // drop complete
                    // if filter rejected mid-capture, drain
                    else if (PAYLOAD && !pkt_accepted && header_word_cnt > 8'd1)
                                                next_state = RX_DROP;
                    end
        RX_DONE:                                next_state = RX_IDLE;
        RX_DROP:    if (EOP)                    next_state = RX_IDLE;  // drain until EOP
        default:                                next_state = RX_IDLE;
    endcase
end

always @(*) begin
    rx_pl_we_next         = 1'b0;
    rx_pl_addr_next       = rx_pl_addr;
    rx_pl_wdata_next      = rx_pl_wdata;
    rx_word_ptr_next      = rx_word_ptr;
    flag_payload_next     = flag_payload;
    pkt_accepted_next     = pkt_accepted;
    header_word_cnt_next  = header_word_cnt;
    in_rdy                = 1'b1;
    rx_fsm_busy           = 1'b0;

    case (state)
        RX_CAPTURE: begin
            if (PAYLOAD) begin
                header_word_cnt_next = header_word_cnt + 8'd1;

                // ------------------------------------------------
                // Word 1 (header_word_cnt == 0, first payload word
                // after the IOQ SOP ctrl word):
                //   in_data[15:0] = EtherType (big-endian)
                //   Accept only IPv4 (0x0800)
                // ------------------------------------------------
                if (header_word_cnt == 8'd1) begin
                    // EtherType is in bits [15:0] of word 1
                    if (in_data[15:0] == ETHERTYPE_IPv4)
                        pkt_accepted_next = 1'b1;
                    else
                        pkt_accepted_next = 1'b0;
                end

                // Write to BRAM only if packet accepted AND
                // we are past the Ethernet+IP+UDP headers (7 words)
                if (pkt_accepted && (rx_word_ptr < 8'd64)) begin
                    rx_pl_we_next     = 1'b1;
                    rx_pl_addr_next   = 8'h10 + rx_word_ptr;
                    rx_pl_wdata_next  = in_data;
                    rx_word_ptr_next  = rx_word_ptr + 8'd1;
                    flag_payload_next = 1'b1;
                end
            end

            if (EOP && pkt_accepted) begin
                // Write word count to BRAM[0x00]
                rx_pl_we_next     = 1'b1;
                rx_pl_addr_next   = 8'h00;
                rx_pl_wdata_next  = {56'h0, rx_word_ptr};
                flag_payload_next = 1'b0;
            end

            if (EOP && !pkt_accepted) begin
                // Quietly drop — reset for next packet
                flag_payload_next    = 1'b0;
                rx_word_ptr_next     = 8'h00;
                header_word_cnt_next = 8'h00;
                pkt_accepted_next    = 1'b0;
            end
        end

        RX_DONE: begin
            rx_word_ptr_next     = 8'h00;
            header_word_cnt_next = 8'h00;
            pkt_accepted_next    = 1'b0;
        end

        RX_DROP: begin
            // Drain — do nothing until EOP
            if (EOP) begin
                flag_payload_next    = 1'b0;
                rx_word_ptr_next     = 8'h00;
                header_word_cnt_next = 8'h00;
                pkt_accepted_next    = 1'b0;
            end
        end

        default: ;
    endcase
end

endmodule
