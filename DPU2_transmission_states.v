`timescale 1ns / 1ps

module tx_packet_sender (
    input wire clk,
    input wire rst,

    // TPU INTERFACE (Data Plane)
    input wire        tpu_wr_en, 
    input wire [63:0] tpu_transmission_data,

    //TPU transmission INTERFACE (Control Plane)
    input wire        tx_done_trigger,

    // NETWORK INTERFACE
    output reg [63:0] net_tx_data,
    output reg [7:0]  net_tx_ctrl,
    output reg        net_tx_wr,

    //ILA's
    output [71:0] fifo_tx_intercept,
    input [7:0] host_location,
    input host_req
);

    // ==========================================
    // HARDWARE ENCAPSULATION SETTINGS
    // ==========================================
    // Assume indices 0-6 contain your pre-compiled UDP/MAC headers.
    // The TPU payload must start at index 7.
    localparam HEADER_WORDS = 8'd7; 

    reg [7:0] read_ptr;
    reg [7:0] write_ptr; 
    reg [7:0] words_remaining;
    reg state;
    
    localparam STATE_IDLE         = 1'b0;
    localparam STATE_TRANSMITTING = 1'b1;

    //WRITE POINTER (SO TPU CAN STUPIDLY STORE HERE)
    always @(posedge clk) begin
        if (rst) begin
            write_ptr <= HEADER_WORDS; // Start safely after the headers!
        end else if (state == STATE_TRANSMITTING && words_remaining == 8'd1) begin
            // When the packet finishes sending, reset the pointer back to 7
            // so the NEXT packet doesn't corrupt the headers either!
            write_ptr <= HEADER_WORDS; 
        end else if (tpu_wr_en) begin
            //Stack the TPU payload sequentially
            write_ptr <= write_ptr + 1'b1;
        end
    end

    reg is_reading_bram; 
    wire [71:0] bram_doutb;
    //PORT A: TPU MANAGES THIS, THEN JUST ASSERTS WHEN IT'S DONE
    wire [7:0]  bram_addra = write_ptr; // Driven 100% by the safe hardware counter

    // ==========================================
    // DYNAMIC HEADER CALCULATIONS
    // ==========================================
    reg [15:0] dyn_ip_len;
    reg [15:0] dyn_udp_len;
    reg [15:0] dyn_ip_chk;
    
    // Combinational calculation of payload bytes (Words * 8)
    wire [15:0] payload_bytes = {(write_ptr - HEADER_WORDS), 3'b000};

    always @(posedge clk) begin
        if (rst) begin
            dyn_ip_len  <= 16'd0;
            dyn_udp_len <= 16'd0;
            dyn_ip_chk  <= 16'd0;
        end else if (tx_done_trigger) begin
            // Calculate headers dynamically in 1 cycle
            dyn_udp_len <= payload_bytes + 16'd8;
            dyn_ip_len  <= payload_bytes + 16'd28; // 8 UDP + 20 IP
            
            // The zero-BRAM 1's complement subtraction trick
            dyn_ip_chk  <= 16'h2D20 - (payload_bytes + 16'd28);        
        end
    end

    // ==========================================
    // STATE MACHINE
    // ==========================================
    always @(posedge clk) begin
        if (rst) begin
            state           <= STATE_IDLE;
            read_ptr        <= 8'd0;
            words_remaining <= 8'd0;
            is_reading_bram <= 1'b0;
        end else begin
            case (state)
                STATE_IDLE: begin
                    read_ptr        <= 8'd0; // ALWAYS start reading from index 0 (the headers)
                    is_reading_bram <= 1'b0;
                    
                    //ADDING APPEND TAIL AS A REACTION TO TRANSMISSION STORE FROM THE DPU
                    if (tx_done_trigger) begin
                        words_remaining <= write_ptr + 8'd1; //increment how far to send
                        is_reading_bram <= 1'b1;
                        state           <= STATE_TRANSMITTING;
                    end
                end

                STATE_TRANSMITTING: begin
                    read_ptr        <= read_ptr + 1'b1;
                    words_remaining <= words_remaining - 1'b1;

                    if (words_remaining == 8'd1) begin
                        is_reading_bram <= 1'b0;
                        state           <= STATE_IDLE;
                    end
                end
            endcase
        end
    end

    // ==========================================
    // TIMING ALIGNMENT & HARDWARE TAIL INJECTION
    // ==========================================
    reg delay_valid;
    reg was_last_word;
    reg [7:0] fetching_idx; // TRACKS THE TRUE BRAM INDEX

    always @(posedge clk) begin
        if (rst) begin
            delay_valid   <= 1'b0;
            net_tx_wr     <= 1'b0;
            was_last_word <= 1'b0;
            fetching_idx  <= 8'd0;
            net_tx_data   <= 64'd0;
            net_tx_ctrl   <= 8'd0;
        end else begin
            // 1-cycle pipeline delay to match BRAM read latency
            delay_valid   <= is_reading_bram;
            net_tx_wr     <= delay_valid; 
            fetching_idx  <= read_ptr; // Delays the pointer by 1 cycle to align with BRAM

            // This goes HIGH on the exact cycle the state machine hits the end
            was_last_word <= (state == STATE_TRANSMITTING && words_remaining == 8'd1);
            
            //MULTIPLEXER: Normal Data vs. Hardcoded Tail vs. Dynamic Headers
            if (was_last_word) begin
                // Intercept the final cycle and force the EOP tail
                net_tx_data <= 64'h0000_0000_0000_0000;
                net_tx_ctrl <= 8'd1;
            end else begin
                // Pass the control bit through unchanged
                net_tx_ctrl <= bram_doutb[71:64]; 
                
                case (fetching_idx)
                    // Patch Word 0 (NetFPGA Module Header)
                    // [47:32] is Word Length, [15:0] is Byte Length
                    8'd0: net_tx_data <= {bram_doutb[63:48], 8'b0, write_ptr, bram_doutb[31:16], payload_bytes + 16'd42};
                    
                    8'd3: net_tx_data <= {dyn_ip_len, bram_doutb[47:0]};   // Patch top 16 bits
                    8'd4: net_tx_data <= {dyn_ip_chk, bram_doutb[47:0]};   // Patch top 16 bits
                    8'd5: net_tx_data <= {bram_doutb[63:16], dyn_udp_len}; // Patch bottom 16 bits
                    default: net_tx_data <= bram_doutb[63:0];              // Normal payload/static headers
                endcase
            end
        end
    end
    
    wire [7:0] port_b_addr = host_req ? host_location : read_ptr;
    
    //Transmission FIFO Call
    transmissionFIFO_72W256D tx_bram_inst (
        .clka(clk),
        .wea(tpu_wr_en),
        .addra(bram_addra),
        .dina({8'd0, tpu_transmission_data}),
		  
        //stuffing host request reads over here. transmission is only during runtime anyways
        .clkb(clk),
        .addrb(port_b_addr), // NOTE: Read pointer is 1 cycle ahead of fetching_idx
        .doutb(bram_doutb)
    );

    //ILA housekeeping
    assign fifo_tx_intercept = bram_doutb;

endmodule