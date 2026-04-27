`timescale 1ns / 1ps

module tx_packet_sender (
    input wire clk,
    input wire rst,

    // GPU INTERFACE (Data Plane)
    input wire        gpu_wr_en, 
    input wire [63:0] gpu_transmission_data,

    // CPU INTERFACE (Control Plane)
    input wire        cpu_tx_trigger,

    // NETWORK INTERFACE
    output reg [63:0] net_tx_data,
    output reg [7:0]  net_tx_ctrl,
    output reg        net_tx_wr
);

    //OKAY SO THIS ONE IS TRIGGERED BY THE CPU, BUT THE GPU IS THE ONLY ONE THAT CAN STORE INTO THE TX FIFO
    
    // ==========================================
    // HARDWARE ENCAPSULATION SETTINGS
    // ==========================================
    // Assume indices 0-6 contain your pre-compiled UDP/MAC headers.
    // The GPU payload must start at index 7.
    localparam HEADER_WORDS = 8'd7; 

    reg [7:0] read_ptr;
    reg [7:0] write_ptr; 
    reg [7:0] words_remaining;
    reg state;
    
    localparam STATE_IDLE         = 1'b0;
    localparam STATE_TRANSMITTING = 1'b1;

    // ==========================================
    // THE SAFE AUTO-INCREMENTING WRITE POINTER
    // ==========================================
    always @(posedge clk) begin
        if (rst) begin
            write_ptr <= HEADER_WORDS; // Start safely after the headers!
        end else if (state == STATE_TRANSMITTING && words_remaining == 8'd1) begin
            // When the packet finishes sending, reset the pointer back to 7
            // so the NEXT packet doesn't corrupt the headers either!
            write_ptr <= HEADER_WORDS; 
        end else if (gpu_wr_en) begin
            // Stack the GPU payload sequentially
            write_ptr <= write_ptr + 1'b1; 
        end
    end

    reg is_reading_bram; 
    wire [71:0] bram_doutb;

    // ==========================================
    // PORT A: GPU DATA OWNERSHIP
    // ==========================================
    wire        bram_wea   = gpu_wr_en;
    wire [7:0]  bram_addra = write_ptr; // Driven 100% by the safe hardware counter
    wire [71:0] bram_dina  = {8'h00, gpu_transmission_data}; 

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
                    if (cpu_tx_trigger) begin
                        words_remaining <= write_ptr + 8'd1; //incremement how far to send
                        
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

    always @(posedge clk) begin
        if (rst) begin
            delay_valid   <= 1'b0;
            net_tx_wr     <= 1'b0;
            was_last_word <= 1'b0;
            net_tx_data   <= 64'd0;
            net_tx_ctrl   <= 8'd0;
        end else begin
            // 1-cycle pipeline delay to match BRAM read latency
            delay_valid <= is_reading_bram;
            net_tx_wr   <= delay_valid; 

            // This goes HIGH on the exact cycle the state machine hits the end
            was_last_word <= (state == STATE_TRANSMITTING && words_remaining == 8'd1);
            
            // MULTIPLEXER: Normal Data vs. Hardcoded Tail
            if (was_last_word) begin
                // Intercept the final cycle and force the EOP tail
                net_tx_data <= 64'h0000_0000_0000_0000;
                net_tx_ctrl <= 8'd1;
            end else begin
                // Pass the normal BRAM data through
                net_tx_data <= bram_doutb[63:0];
                net_tx_ctrl <= bram_doutb[71:64]; 
            end
        end
    end
	 
	//Transmission FIFO Call
    transmissionFIFO_72W256D tx_bram_inst (
        .clka(clk),
        .wea(bram_wea),
        .addra(bram_addra),
        .dina(bram_dina),
        .clkb(clk),
        .addrb(read_ptr),
        .doutb(bram_doutb)
    );

endmodule