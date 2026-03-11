`timescale 1ns / 1ps

module convertible_fifo (
    input wire clk,
    input wire rst,

    //NetFPGA RX Interface (Input from Network)
    input  [1:0] cpu_thread, //check which thread is accessing to ONLY let that thread use the FIFO
    input wire [71:0] net_rx_data,
    input wire        net_rx_valid,
    input wire        net_rx_sop,      // Start of Packet
    input wire        net_rx_eop,      // End of Packet
    output reg        fifo_full,       // Stalls the incoming pipeline

    //NetFPGA TX Interface (Output to Network)
    //output wire [71:0] net_tx_data,
    //output reg         net_tx_valid,
    //input wire         net_tx_ready,   // Upstream module is ready to accept data

    // --- CPU Interface (Memory Mapped) ---
    input wire [7:0]  cpu_addr,        // From pipeline ME stage
    input wire [31:0] cpu_data_in,     // 32-bit payload from CPU
    input wire        cpu_we,          // Write Enable from CPU
    input wire        fifo_head,    // Address Decoder: Head Reg
    input wire        fifo_tail,    // Address Decoder: Tail Reg
    input wire        fifo_data,    // Address Decoder: BRAM Payload
    input wire        fifo_ctrl,    // Address Decoder for Control Reg
    
    output wire [31:0] cpu_data_out, //forced to write in 72 but can only see 32 anyways
    output wire [71:0] raw_data_out,
    output reg [7:0]   head_reg,       // Accessible by CPU
    output reg [7:0]   tail_reg        // Accessible by CPU
);

    // FSM States
    localparam IDLE         = 2'b00;
    localparam RECEIVING    = 2'b01;
    localparam PROCESSING   = 2'b10;
    localparam TRANSMITTING = 2'b11;
    reg [1:0] state;

    // Internal Pointers
    reg [7:0] tx_ptr; // Tracks progress when sending packet out

    // BRAM Signals
    wire [7:0]  bram_addr_a;
    wire [71:0] bram_din_a;
    wire bram_we; //cannot support addressability in this ancient tool
    wire [71:0] bram_dout_a;

    // 2. Lock Registers
    reg        is_locked; //this lock will be necessary... can't have the other threads all messing with a FIFO. ugh.
    reg  [1:0] owner_thread; //need the matching template to know who actually owns it. the is_locked allows reset to just set to 0, no problems

    // 3. The "Lie to the Others" Read MUX
    // A thread only sees real data if the FIFO is unlocked, OR if it holds the lock.
    wire thread_has_access = (!is_locked) || (is_locked && (cpu_thread == owner_thread));

    /*always @(*) begin
        if (!thread_has_access) begin
            cpu_data_out = 32'h0; 
            //force a stall here by having other threads read 0'd out garbage. the safety net is to have all threads check
            //whether they picked up 0's (so if the FIFO was storing 0, this could be problematic lol) 
        end else begin
            //Owner's procedure, the standard FIFO FSM
            if (fifo_head)      cpu_data_out = {24'b0, head_reg};
            else if (fifo_tail) cpu_data_out = {24'b0, tail_reg}; 
            else if (fifo_data) cpu_data_out = bram_dout_a[31:0]; // Your 72-to-32 bit slicer
            else                cpu_data_out = 32'h0;
        end
    end*/

    // -------------------------------------------------------------------------
    // 1. ASYMMETRIC MUXING (The 32-bit / 72-bit Bridge)
    
    //KEEP THE MEMORY COMPONENT AT 72b
    //assign net_tx_data = bram_dout_a;

    //address mux. this can be changed to keep the data stable, but otherwise
    assign bram_addr_a = (state == PROCESSING)   ? cpu_addr : 
                         (state == TRANSMITTING) ? tx_ptr : tail_reg;

    // Data MUX: Pad the CPU 32-bit data with 40 zeros. 
    // (The byte-write enables will protect the actual upper 40 bits in memory).
    assign bram_din_a  = (state == PROCESSING) ? {bram_dout_a[71:32], cpu_data_in} : net_rx_data;

    // Byte Write Enable MUX: 
	 //write all 72 at once into the BRAM, but a solution for reading all of it is necessary... might need 3 wb stages at this point
    assign bram_we = (state == PROCESSING && fifo_data && cpu_we) ? 1'b1 :
                     (state == RECEIVING && net_rx_valid)         ? 1'b1 : 
                     (state == IDLE && net_rx_valid && net_rx_sop)? 1'b1 : 1'b0;

    wire cpu_is_authorized = is_locked && (cpu_thread == owner_thread);

    // -------------------------------------------------------------------------
    // 2. FSM & CONTROL LOGIC
    // -------------------------------------------------------------------------
    always @(posedge clk) begin
        if (rst) begin
            state        <= IDLE;
            is_locked <= 1'b0; //reset the lock when necessary
            head_reg     <= 8'h0;
            tail_reg     <= 8'h0;
            tx_ptr       <= 8'h0;
            fifo_full    <= 1'b0;
            //net_tx_valid <= 1'b0;
				owner_thread <= 2'b0;
        end else begin
            // Default registers
            //net_tx_valid <= 1'b0;

            // Handle CPU Writes to Head/Tail Registers (Active only in PROCESSING)
            if (state == PROCESSING && cpu_we && cpu_is_authorized) begin
                if (fifo_head) head_reg <= cpu_data_in[7:0];
                if (fifo_tail) tail_reg <= cpu_data_in[7:0];
            end

            case (state)
                IDLE: begin
                    fifo_full <= 1'b0;
                    if (net_rx_valid && net_rx_sop) begin
                        head_reg <= tail_reg; // Mark the start of the new packet
                        tail_reg <= tail_reg + 1'b1;
                        state    <= RECEIVING;
                    end
                end

                RECEIVING: begin
                    if (net_rx_valid) begin
                        tail_reg <= tail_reg + 1'b1;
                        if (net_rx_eop) begin
                            fifo_full <= 1'b1;  // Stall NetFPGA RX
                            state     <= PROCESSING;
                        end
                    end
                end

                PROCESSING: begin
                    //CLAIM THE LOCK
                    if (!is_locked && !cpu_we && fifo_tail) begin
                        is_locked <= 1'b1;
                        owner_thread <= cpu_thread; // Lock it to whoever just looked!
                    end

                    // RELEASE THE LOCK (and Transmit): 
                    // Only the owner is allowed to trigger the transmission
                    if (is_locked && (cpu_thread == owner_thread) && fifo_ctrl && cpu_we) begin
                        state <= IDLE; //TRANSMITTING;
                        is_locked <= 1'b0; // Unlock so the next thread can grab the next packet
                        tx_ptr <= head_reg;
                    end
                end

                /*TRANSMITTING: begin
                    if (net_tx_ready) begin
                        net_tx_valid <= 1'b1;
                        tx_ptr       <= tx_ptr + 1'b1;
                        
                        // If we've reached the tail, packet is fully sent
                        if (tx_ptr == tail_reg - 1'b1) begin
                            state <= IDLE;
                            head_reg <= 8'd0;
                            tail_reg <= 8'd0;
                            fifo_full <= 1'b0;
                        end
                    end
                end*/
            endcase
        end
    end

    //ACTUAL CALL TO THE FIFO MEMORY
    FIFO_72W256D FIFO_blk (
        .clka(clk),
        .wea(bram_we), 
        .addra(bram_addr_a), //this is basically just the alu_result's bottom bits
        .dina(bram_din_a),
        .douta(bram_dout_a), 

        // Port B remains strictly for the future GPU / N+1 Read requirement
        .clkb(clk),
        .addrb(tail_reg + 1'b1), //intended full packet read for the GPU
        .doutb()         //this is a concern for later     
    );
	 
	assign cpu_data_out = thread_has_access ? {24'b0, bram_dout_a[71:64]} : 32'b0;
    assign raw_data_out = bram_dout_a;

endmodule