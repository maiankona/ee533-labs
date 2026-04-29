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


localparam RX_IDLE = 2'b00, RX_CAPTURE = 2'b01, RX_WAIT_GPU = 2'b10, RX_DONE = 2'b11; // FSM States

wire SOP = in_wr && in_ctrl != 8'b00;                   // Start of Packet
wire PAYLOAD = in_wr && in_ctrl == 8'b00;               // Denotes window of time when the payload is present
wire EOP = in_wr && in_ctrl != 8'b00 && flag_payload;   // EOP

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
        RX_CAPTURE:  if (EOP) next_state = RX_WAIT_GPU;
        RX_WAIT_GPU: if (pipeline_done) next_state = RX_DONE;
        RX_DONE:     next_state = RX_IDLE;                      // Stay in this state for 1x cycle, then go to idle
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
    in_rdy           = 1'b1;
    rx_fsm_busy = 1'b0;  

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
            end
        end

        RX_WAIT_GPU: begin
            in_rdy = 1'b0;                                // Send backpressure while GPU is processing
            rx_fsm_busy = 1'b1;                           // Set BUSY flag high
        end

        RX_DONE: begin                                    // Clear CPU's status register 0x00 to siganl ready for next MAC sequence
            rx_pl_we_next    = 1'b1;
            rx_pl_addr_next  = 8'h00;
            rx_pl_wdata_next = 64'h0;
            rx_word_ptr_next = 8'h00;
        end

        default: ;
    endcase
end

endmodule