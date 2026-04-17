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
    output wire [71:0] net_tx_data,
    output reg         net_tx_valid,
    input wire         net_tx_ready,   // Upstream module is ready to accept data

    // --- CPU/GPU Interface (Memory Mapped) ---
    input wire [7:0]  cpu_addr,        // For head/tail/ctrl decode
    input wire [7:0]  bram_addr,       // BRAM address (muxed host or pipeline from ids)
    input wire [31:0] cpu_data_in,     // 32-bit payload for head/tail regs
    input wire [63:0] data_in_64,      // 64-bit payload for BRAM (host or GPU muxed)
    input wire        cpu_we,          // Write Enable from CPU
    input wire        fifo_head,    // Address Decoder: Head Reg
    input wire        fifo_tail,    // Address Decoder: Tail Reg
    input wire        fifo_data,    // Address Decoder: BRAM Payload
    input wire        fifo_ctrl,    // Address Decoder for Control Reg
    input wire        gpu_mode,     // 1 = GPU-only test: enter PROCESSING without network packet
    input wire [63:0] pipeline_data,// GPU pipeline store data
    input wire        pipeline_we,  // GPU pipeline store to BRAM
    
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
    // GPU mode: always have access (no lock). Otherwise: unlocked or hold lock.
    wire thread_has_access = gpu_mode || (!is_locked) || (is_locked && (cpu_thread == owner_thread));

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
    assign net_tx_data = bram_dout_a;

    // BRAM mux: host/pipeline use bram_addr while FSM is PROCESSING. When IDLE but gpu_mode
    // is already 1 (GPU fetch started), state may not update until the clock edge ? pipeline
    // STR/LDR must still see pipeline_addr, not tail_reg, or stores never hit DMEM.
    wire bram_pipeline_ok = (state == PROCESSING) || (state == IDLE && gpu_mode);

    assign bram_addr_a = (state == TRANSMITTING) ? tx_ptr :
                         bram_pipeline_ok ? bram_addr : tail_reg;

    assign bram_din_a  = bram_pipeline_ok
        ? {bram_dout_a[71:64], (pipeline_we ? pipeline_data : data_in_64)}
        : net_rx_data;

    wire bram_we_cpu = fifo_data && cpu_we;
    wire bram_we_pipeline = pipeline_we;
    assign bram_we = (bram_pipeline_ok && (bram_we_cpu || bram_we_pipeline)) ? 1'b1 :
                     (state == RECEIVING && net_rx_valid)         ? 1'b1 : 
                     (state == IDLE && net_rx_valid && net_rx_sop)? 1'b1 : 1'b0;

    wire cpu_is_authorized = gpu_mode || (is_locked && (cpu_thread == owner_thread));

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
            net_tx_valid <= 1'b0;
				owner_thread <= 2'b0;
        end else begin
            // Default registers
            net_tx_valid <= 1'b0;

            // Handle CPU Writes to Head/Tail Registers (Active only in PROCESSING)
            if (state == PROCESSING && cpu_we && cpu_is_authorized) begin
                if (fifo_head) head_reg <= cpu_data_in[7:0];
                if (fifo_tail) tail_reg <= cpu_data_in[7:0];
            end

            case (state)
                IDLE: begin
                    fifo_full <= 1'b0;
                    if (gpu_mode || (cpu_we && fifo_data)) begin
                        // GPU-only mode: enter PROCESSING on first CPU/GPU access
                        state <= PROCESSING;
                    end else if (net_rx_valid && net_rx_sop) begin
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
                    // CLAIM THE LOCK (skip in GPU mode - flat BRAM access, no packet ownership)
                    if (!gpu_mode && !is_locked && !cpu_we && fifo_tail) begin
                        is_locked <= 1'b1;
                        owner_thread <= cpu_thread;
                    end

                    // RELEASE THE LOCK (and Transmit)
                    if (!gpu_mode && is_locked && (cpu_thread == owner_thread) && fifo_ctrl && cpu_we) begin
                        state <= TRANSMITTING;
                        tx_ptr <= head_reg;
                    end
                end

                TRANSMITTING: begin
                    if (net_tx_ready) begin
                        net_tx_valid <= 1'b1;
                        tx_ptr       <= tx_ptr + 1'b1;
                        
                        // If we've reached the tail, packet is fully sent
                        if (tx_ptr == tail_reg - 1'b1) begin
                            state <= IDLE;
                            is_locked <= 1'b0; // Unlock only once packet is fully transmitted
                            head_reg <= 8'd0;
                            tail_reg <= 8'd0;
                            fifo_full <= 1'b0;
                        end
                    end
                end
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
	 
    // Return lower 32 bits of BRAM for fifo_data; head/tail for fifo_head/fifo_tail
    assign cpu_data_out = thread_has_access
        ? (fifo_head ? {24'b0, head_reg} : (fifo_tail ? {24'b0, tail_reg} : (fifo_data ? bram_dout_a[31:0] : 32'b0)))
        : 32'b0;
    assign raw_data_out = bram_dout_a;

endmodule