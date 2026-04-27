`timescale 1ns / 1ps

module dpu_dma_engine ( //it was previously sliding. it's not sliding anymore lol
    input wire clk,
    input wire rst,

    //NetFPGA RX Interface
    input wire [71:0] net_rx_data,
    input wire        net_rx_valid,

    //DMA Bus to TPU Activation BRAM AND THE HASHER
    output wire        dpu_to_tpu_we,
    output wire [9:0]  dpu_to_tpu_addr,
    output wire [63:0] dpu_to_tpu_data, //this one has fanout to the hasher
    
    //2-tiered handshake
    input  wire        system_busy, //this is the wait condition. the hasher AND the TPU need to be idle for streaming to start  
    output reg         rx_dpu_active, //Mutex Lock flag for the BRAM
    
    //ILA and an actual request
    input wire         fifo_req,
    input wire [7:0]   fifo_addr_req,
    output wire [71:0] tpu_read_ILA, //for the fifor call
    
    output reg [15:0] packets_streamed, //this is HALF ILA, half actually needed
    output reg dpu_phase //boundary knowledge for the SoC
);

    //FSM States
    localparam STATE_IDLE        = 3'd0;
    localparam STATE_RECORDING   = 3'd1;
    localparam STATE_WAIT_LOCK   = 3'd2; //necessary barrier for dense comparison scenarios
    localparam STATE_FORWARD_TPU = 3'd3;

    reg [2:0] state;

    // Internal BRAM Pointers (Store-and-Forward packet isolation)
    reg [7:0] tail_reg;      //WP (Network -> Internal BRAM)
    reg [7:0] head_reg;      //RP  (Internal BRAM -> TPU DMA)
    reg [7:0] packet_length; //Total words in the current captured packet

    // Global Accumulator Pointer (Across multiple packets)
    reg [9:0] dma_write_ptr;

    //Safely catches the packet before it ever touches the TPU math pipeline
    wire        bram_we_a   = net_rx_valid && (state == STATE_RECORDING || (state == STATE_IDLE && net_rx_data[71:64] == 8'hFF));
    wire [7:0]  bram_addr_a = (state == STATE_IDLE) ? 8'd0 : tail_reg;
    wire [71:0] bram_dout_b;
    wire [7:0]  port_b_addr = fifo_req ? fifo_addr_req : head_reg; //fifo_req is from the host. i don't think it's humanly possible for me to request at the same time as a packet lol
    
    //register housekeeping
    reg dma_we_pipeline;
    reg [7:0] dma_addr_pipeline;

    localparam STREAM_TO_DIAGNOSIS = 16'd5;
    
    assign dpu_to_tpu_we = dma_we_pipeline;
	assign dpu_to_tpu_addr = dma_addr_pipeline;
	assign dpu_to_tpu_data = bram_dout_b[63:0];
    
    FIFO_72W256D PacketBuffer (
        .clka(clk),
        .wea(bram_we_a), 
        .addra(bram_addr_a), 
        .dina(net_rx_data),
        .clkb(clk),
        .addrb(port_b_addr), 
        .doutb(bram_dout_b)    
    );

    assign tpu_read_ILA = bram_dout_b;

    //DPU/FIFO STATE MACHINE
    always @(posedge clk) begin
        if (rst) begin
            state             <= STATE_IDLE;
            tail_reg          <= 8'd0;
            head_reg          <= 8'd7; //hardcoded to start at index 7. header garbage before this. 
            packet_length     <= 8'd0;
            dma_write_ptr     <= 10'd0;
            
            dma_we_pipeline   <= 1'b0;
            dma_addr_pipeline <= 10'd0;
            rx_dpu_active     <= 1'b0; //Default lock to open
            packets_streamed <= 16'b0;
            dpu_phase <= 1'b0;
        end else begin
            
            //Clear pipeline registers by default to prevent accidental BRAM writes
            dma_we_pipeline <= 1'b0;
				
				
				if (packets_streamed == STREAM_TO_DIAGNOSIS && system_busy == 1'b0) begin
					  packets_streamed <= 16'd0;
					  dpu_phase        <= ~dpu_phase; 
					  //"I'm on the next bin. if you're on the previous, don't use this hash YET" (towards the TPU)
				end

            case (state)
                STATE_IDLE: begin
                    head_reg <= 8'd7; 
                    rx_dpu_active <= 1'b0; 
                    
                    //SOP to record, ctrl == 0xFF
                    if (net_rx_valid && net_rx_data[71:64] == 8'hFF) begin
                        state    <= STATE_RECORDING;
                        tail_reg <= 8'd1;
                    end
                end

                STATE_RECORDING: begin
                    if (net_rx_valid) begin
                        //SECURITY FILTER >> Check EtherType at index 2
                        if (tail_reg == 8'd2 && net_rx_data[31:16] != 16'h0800) begin
                            // Not IPv4? Abort! Network garbage dropped.
                            state <= STATE_IDLE; 
                        end 
                        //EOP: Non-zero, non-FF ctrl
                        else if ((net_rx_data[71:64] != 8'h00) && (net_rx_data[71:64] != 8'hFF)) begin
                            packet_length <= tail_reg + 1'b1; 
                            state         <= STATE_WAIT_LOCK; //I'M DONE BUT MY COMPUTATION UNIT ISN'T
                        end 
                        //CONTINUOUS RECORDING
                        else begin
                            tail_reg <= tail_reg + 1'b1;
                        end   
                    end
                end

                STATE_WAIT_LOCK: begin
                    //GATE 1: HASHER/TPU System Barrier
                    //Do not stream into the BRAM if the TPU or Hasher are busy
                    if (system_busy == 1'b0) begin //NEW SIGNAL FOR THE TPU X HASHER activity. NO STREAMING ALLOWED
                        rx_dpu_active <= 1'b1; // Lock the BRAM
                        state         <= STATE_FORWARD_TPU;
                    end
                end

                STATE_FORWARD_TPU: begin
                    if (head_reg < packet_length) begin
                        // Stage 1 of Pipeline: Address the next word
                        dma_we_pipeline   <= 1'b1;
                        dma_addr_pipeline <= dma_write_ptr;
                        
                        // Increment pointers
                        head_reg      <= head_reg + 1'b1;
                        dma_write_ptr <= dma_write_ptr + 1'b1;
                    end else begin
                        //GATE 2: UNLOCK THE DPU SIDE LOCK
                        //Packet finished streaming. Hasher already caught any triggers.
                        rx_dpu_active   <= 1'b0; //Release the BRAM lock
                        state           <= STATE_IDLE;
                        if (packets_streamed == STREAM_TO_DIAGNOSIS - 1'b1)  dma_write_ptr   <= 10'd0;
                        packets_streamed <= packets_streamed + 1'b1; //count the packets received so we can forward it to the TPU as well
                    end
                end
                
            endcase
        end
    end

endmodule