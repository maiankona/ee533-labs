`timescale 1ns / 1ps

module convertible_fifo (
    input wire clk,
    input wire rst,

    // --- NetFPGA RX Interface ---
    input wire [71:0] net_rx_data,
    input wire        net_rx_valid,
    output reg        fifo_full,      // 1 = Packet locked and ready for CPU

    // --- CPU Interface ---
    input wire        cpu_rd_en,
    input wire        cpu_wr_en,
    input wire        is_fifo_stream_addr,
    input wire        is_fifo_status_addr,
    input wire        is_fifo_ctrl_addr,
    
    output reg [31:0] CPU_READ_DATA,  
    
    // --- Snoop & Interconnects ---
    output wire [71:0] raw_data_out,
    input wire         fifo_req,
    input wire [7:0]   fifo_addr_req,

    // --- GPU Interface ---
    input wire [7:0]   gpu_read_addr,
    output wire [71:0] gpu_read_data
);
    //THIS IS ONE OF THE ITERATIONS WITH A SMARTNIC IMPLEMENTATION. YOU CAN SEE MMIO INPUTS AND WHATNOT DEPENDING ON CPU POLLING ETC
    
    // SMART FIFO: Shielded Network Capture & 16-bit CPU Streaming    
    //FIFO's FSM States
    localparam STATE_IDLE      = 2'd0;
    localparam STATE_RECORDING = 2'd1;
    localparam STATE_LOCKED    = 2'd2; //ambiguous nomenclature: lock as soon as a packet sent all the data I care about, then we enter post-processing mode

    wire [71:0] bram_dout_a; //THIS IS THE CPU PORT FOR THE FIFO
    
    reg [1:0] state;
    reg [7:0] tail_reg;       // Write pointer (Network -> BRAM)
    reg [7:0] head_reg;       // Read pointer  (BRAM -> CPU)
    reg [1:0] sub_word_cnt;   // 16-bit chunk selector (0 to 3)
    reg       is_processing;  //Flag that triggers against 5FFF >> THIS IS THE CANONICAL ALGORITHM_HALT

    //HARDWARE CODED USING THE INTERNAL COUNTER TO GIVE THE CPU THE CORRECT GPU INSTRUCTION
    reg [15:0] stream_out_16b;
    always @(*) begin
        if (is_fifo_stream_addr) begin 
            case (sub_word_cnt)
                2'd3: stream_out_16b <= bram_dout_a[15:0];
                2'd2: stream_out_16b <= bram_dout_a[31:16];
                2'd1: stream_out_16b <= bram_dout_a[47:32];
                2'd0: stream_out_16b <= bram_dout_a[63:48];
            endcase
        end else begin
            stream_out_16b <= 16'h0;
        end
    end

    reg prev_cpu_read;
    always @(posedge clk) begin
        if (rst) prev_cpu_read <= 1'b0;
        else     prev_cpu_read <= (cpu_rd_en && is_fifo_stream_addr);
    end
    // Pulses HIGH for exactly 1 cycle when the CPU drops the read request
    wire consume_pulse = prev_cpu_read && !(cpu_rd_en && is_fifo_stream_addr);

    // The Bus Sniffer: Detects the End-of-Algorithm Sentinel
    wire hit_sentinel = (stream_out_16b == 16'h5FFF); //IDK why it's called a sentinel but this is the crucial branch breaker for the CPU

    //MAIN STATE MACHINE & POINTERS
    reg locked_request;
    
    always @(posedge clk) begin
        if (rst) begin
            state         <= STATE_IDLE;
            tail_reg      <= 8'd0;
            head_reg      <= 8'd7; // MAGIC: CPU starts reading exactly after the headers!
            sub_word_cnt  <= 2'd0;
            is_processing <= 1'b0;
            fifo_full     <= 1'b0;
            locked_request <= 1'b0;
        end else begin

            case (state)
                STATE_IDLE: begin
                    // Wait for Start of Packet (CTRL == 0xFF)
                    if (net_rx_valid && net_rx_data[71:64] == 8'hFF) begin
                        state    <= STATE_RECORDING;
                        // Note: BRAM_WR_ADDR is combinatorially forced to 0 during IDLE
                        // so we pre-increment tail_reg to 1 for the next clock cycle.
                        tail_reg <= 8'd1;
                    end
                end

                STATE_RECORDING: begin
                    if (net_rx_valid) begin
                        
                        // 1. THE FILTER: At index 2, check the EtherType.
                        // If it is NOT IPv4 (0x0800), ABORT the recording!
                        if (tail_reg == 8'd2 && net_rx_data[31:16] != 16'h0800) begin
                            state <= STATE_IDLE; // Jumping to IDLE ignores the rest of this bad packet
                        end 
                        
                        //nonzero, nonstart of packet means the end just happened
                        else if ((net_rx_data[71:64] != 8'h00) && (net_rx_data[71:64] != 8'hFF)) begin
                            state     <= STATE_LOCKED; // Lock the doors!
                            fifo_full <= 1'b1;
                            tail_reg  <= tail_reg + 1'b1;
                        end 
                        
                        // 3. Otherwise, keep blindly recording
                        else begin
                            tail_reg <= tail_reg + 1'b1; 
                        end   
                    end
                    /*
                    else begin
                        // If net_rx_valid goes LOW, the packet is over, unexpectedly. 
                        state <= STATE_IDLE;
                    end
                    */
                end

                STATE_LOCKED: begin
                    // Wait here. The CPU handles the data, then unlocks us via fifo_ctrl
                    locked_request <= 1'b1;
                    
                    if (cpu_wr_en && is_fifo_ctrl_addr && locked_request) begin
                        state         <= STATE_IDLE;
                        tail_reg      <= 8'd0;
                        head_reg      <= 8'd7; // Reset CPU read pointer to start of payload
                        sub_word_cnt  <= 2'd0; // Reset 16-bit chunk counter
                        is_processing <= 1'b0; // Clear the GPU flag
                        fifo_full     <= 1'b0;
                        locked_request <= 1'b0;
                    end
                    else if (consume_pulse) begin
                        if (hit_sentinel) begin
                            is_processing <= 1'b1;
                        end else begin
                            sub_word_cnt <= sub_word_cnt + 1'b1;
                            // When sub_word_cnt rolls over from 3 to 0, advance BRAM row
                            if (sub_word_cnt == 2'd3) begin
                                head_reg <= head_reg + 1'b1;
                            end
                        end
                    end
                end
            endcase
        end
    end

    // --- 3. HARDWARE WIRING ---
    
    //WE: it looks a little complicated because it includes the edges of the states that ALSO need to write
    wire FIFO_we   = net_rx_valid && (state == STATE_RECORDING || (state == STATE_IDLE && net_rx_data[71:64] == 8'hFF));
    
    // Data and Addresses
    wire [71:0] bram_din_a = net_rx_data;
    // When locked, Port A reads for the CPU. Otherwise, it writes for the Network.
    wire [7:0] bram_addr_a = (state == STATE_LOCKED) ? head_reg :
                             (state == STATE_IDLE)   ? 8'd0 : 
                             tail_reg;

    //GPU preserved stuff (+ inject in this current bitstream)
    wire [7:0] port_b_addr = fifo_req ? fifo_addr_req : gpu_read_addr;
    
    FIFO_72W256D FIFO_blk (
        .clka(clk),
        .wea(FIFO_we), 
        .addra(bram_addr_a), 
        .dina(bram_din_a),
        .douta(bram_dout_a), 

        .clkb(clk),
        .addrb(port_b_addr),
        .doutb(gpu_read_data)   
    );

    //THIS IS THE ILA
    assign raw_data_out = gpu_read_data;
    
    // CPU Read Bus (Zero-extend the 16-bit chunk to 32 bits, or expose the FIFO status)
    // CPU Read Bus (Zero-extend the 16-bit chunk to 32 bits, or expose the FIFO status)
    wire [31:0] external_read = (is_fifo_stream_addr) ? {16'd0, stream_out_16b} :
                           (is_fifo_status_addr) ? {31'd0, locked_request} : 
                           32'd0;

    always @(posedge clk) CPU_READ_DATA <= external_read;

endmodule