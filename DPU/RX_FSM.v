module RX_FSM (
    input clk,
    input reset,
    input [63:0] in_data,           // Data from Network
    input [7:0] in_ctrl,            // Ctrls from Network
    input in_wr,                    // Write enable from Network
    input pipeline_done,
    output reg [7:0] rx_pl_addr,    // Payload address to FIFO
    output reg [63:0] rx_pl_wdata,  // Payload data to FIFO
    output reg rx_pl_we,             // Payload write enable
    output reg rx_fsm_busy,
    output reg in_rdy
);

reg [1:0] state, next_state;
reg [7:0] rx_word_ptr;          // 0x00 by default. Gets updated to base 0x10 when in Capture state
reg flag_payload;
reg [7:0] rx_word_ptr_next;
reg flag_payload_next;
reg rx_pl_we_next;
reg [7:0] rx_pl_addr_next;
reg [63:0] rx_pl_wdata_next;


// FSM States
// NOTE: We intentionally do NOT gate capture on pipeline_done. The RX path must
// be able to accept and write packets at any time.
//
// RX_DONE exists as a single-cycle "packet captured" marker so other logic /
// testbenches can observe completion without waiting on GPU.
localparam RX_IDLE = 2'b00, RX_CAPTURE = 2'b01, RX_DONE = 2'b10; 

// NetFPGA stream framing convention:
// - SOP word: in_ctrl == 8'hFF
// - payload words: in_ctrl == 8'h00
// - EOP word: in_ctrl != 8'h00 and in_ctrl != 8'hFF (ctrl encodes valid bytes)
wire SOP     = in_wr && (in_ctrl == 8'hFF);
wire PAYLOAD = in_wr && (in_ctrl == 8'h00);
wire EOP     = in_wr && (in_ctrl != 8'h00) && (in_ctrl != 8'hFF) && flag_payload;

// State Memory
always @(posedge clk) begin
    if (reset) begin
        state         <= RX_IDLE;
        rx_word_ptr   <= 8'h00;
        flag_payload  <= 1'b0;
        rx_pl_we      <= 1'b0;
        rx_pl_addr    <= 8'h00;
        rx_pl_wdata   <= 64'h0;
    end else begin
        state         <= next_state;
        rx_word_ptr   <= rx_word_ptr_next;
        flag_payload  <= flag_payload_next;
        rx_pl_we      <= rx_pl_we_next;
        rx_pl_addr    <= rx_pl_addr_next;
        rx_pl_wdata   <= rx_pl_wdata_next;                      // Buffer incoming network traffic
    end
end

// NSL
always @(*) begin
    next_state = state;
    case (state)
        RX_IDLE:     if (SOP) next_state = RX_CAPTURE;
        RX_CAPTURE:  if (EOP) next_state = RX_DONE;
        RX_DONE:     next_state = RX_IDLE;
    endcase
end

// Output Logic
always @(*) begin
    // defaults to prevent latches
    rx_pl_we_next    = 1'b0;
    rx_pl_addr_next  = rx_pl_addr;
    rx_pl_wdata_next = rx_pl_wdata;
    rx_word_ptr_next = rx_word_ptr;
    flag_payload_next = flag_payload;
    in_rdy           = 1'b1;   // never apply backpressure based on pipeline_done
    rx_fsm_busy      = 1'b0;  

    case (state)
        RX_IDLE: begin
            // nothing to drive
        end

        RX_CAPTURE: begin
            if (PAYLOAD && rx_word_ptr < 8'd64) begin      // Only write payloads when there is room
                rx_pl_we_next     = 1'b1;
                rx_pl_addr_next   = 8'h10 + rx_word_ptr;
                rx_pl_wdata_next  = in_data;              // Assign incoming traffic from Network
                rx_word_ptr_next  = rx_word_ptr + 1'b1;   // Track number of words in payload
                flag_payload_next = 1'b1;                 // Set flag for payload while payload is present
            end
            if (EOP) begin
                rx_pl_we_next     = 1'b1;                 // Set enable to write packet count into FIFO
                rx_pl_addr_next   = 8'h00;
                rx_pl_wdata_next  = {56'h0, rx_word_ptr}; // Place packet_word_count into addr 0x00 at BRAM
                flag_payload_next = 1'b0;                 // Reset payload flag
                rx_word_ptr_next  = 8'h00;                // Ready for next packet immediately
            end
        end

        RX_DONE: begin
            // Single-cycle completion marker. No backpressure, no additional writes.
        end

        default: ;
    endcase
end

endmodule
