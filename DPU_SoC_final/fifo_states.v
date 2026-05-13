`timescale 1ns / 1ps

// Single-CPU thread (lab9): one master for FIFO MMIO + packet path. No owner_thread /
// cpu_thread compare — lock is binary (packet captured vs software servicing).

module convertible_fifo (
    input wire clk,
    input wire rst,

    // NetFPGA RX Interface (Input from Network)
    input wire [71:0] net_rx_data,
    input wire        net_rx_valid,
    input wire        net_rx_sop,      // Start of Packet
    input wire        net_rx_eop,      // End of Packet
    output reg        fifo_full,       // Stalls the incoming pipeline

    // NetFPGA TX Interface (Output to Network)
    output wire [71:0] net_tx_data,
    output reg         net_tx_valid,
    input wire         net_tx_ready,   // Upstream module is ready to accept data

    // --- CPU/GPU Interface (Memory Mapped) ---
    input wire [7:0]  cpu_addr,        // For head/tail/ctrl decode
    input wire [7:0]  bram_addr,       // BRAM address (muxed host or pipeline from ids)
    input wire [31:0] cpu_data_in,     // 32-bit payload for head/tail regs
    input wire [63:0] data_in_64,      // 64-bit payload for BRAM (host or GPU muxed)
    input wire        cpu_we,          // Write Enable from CPU
    input wire        fifo_head,       // Address Decoder: Head Reg
    input wire        fifo_tail,       // Address Decoder: Tail Reg
    input wire        fifo_data,       // Address Decoder: BRAM Payload
    input wire        fifo_ctrl,       // Address Decoder for Control Reg
    input wire        gpu_mode,        // 1 = GPU-only / flat BRAM (no packet lock semantics)
    input wire [63:0] pipeline_data,   // GPU pipeline store data
    input wire        pipeline_we,     // GPU pipeline store to BRAM
    input wire [7:0]  port_b_addr,     // TX FSM read address (BRAM Port B)

    output wire [31:0] cpu_data_out,
    output wire [71:0] raw_data_out,
    output wire [71:0] port_b_dout,
    output reg [7:0]   head_reg,
    output reg [7:0]   tail_reg
);

    localparam IDLE         = 2'b00;
    localparam RECEIVING    = 2'b01;
    localparam PROCESSING   = 2'b10;
    localparam TRANSMITTING = 2'b11;
    reg [1:0] state;

    reg [7:0] tx_ptr;

    wire [7:0]  bram_addr_a;
    wire [71:0] bram_din_a;
    wire        bram_we;
    wire [71:0] bram_dout_a;

    reg is_locked;

    assign net_tx_data = bram_dout_a;

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
                     (state == IDLE && net_rx_valid && net_rx_sop) ? 1'b1 : 1'b0;

    always @(posedge clk) begin
        if (rst) begin
            state        <= IDLE;
            is_locked    <= 1'b0;
            head_reg     <= 8'h0;
            tail_reg     <= 8'h0;
            tx_ptr       <= 8'h0;
            fifo_full    <= 1'b0;
            net_tx_valid <= 1'b0;
        end else begin
            net_tx_valid <= 1'b0;

            if (state == PROCESSING && cpu_we) begin
                if (fifo_head) head_reg <= cpu_data_in[7:0];
                if (fifo_tail) tail_reg <= cpu_data_in[7:0];
            end

            case (state)
                IDLE: begin
                    fifo_full <= 1'b0;
                    if (gpu_mode || (cpu_we && fifo_data)) begin
                        state <= PROCESSING;
                    end else if (net_rx_valid && net_rx_sop) begin
                        head_reg <= tail_reg;
                        tail_reg <= tail_reg + 1'b1;
                        state    <= RECEIVING;
                    end
                end

                RECEIVING: begin
                    if (net_rx_valid) begin
                        tail_reg <= tail_reg + 1'b1;
                        if (net_rx_eop) begin
                            fifo_full <= 1'b1;
                            state     <= PROCESSING;
                        end
                    end
                end

                PROCESSING: begin
                    if (!gpu_mode && !is_locked && !cpu_we && fifo_tail) begin
                        is_locked <= 1'b1;
                    end

                    if (!gpu_mode && is_locked && fifo_ctrl && cpu_we) begin
                        state  <= TRANSMITTING;
                        tx_ptr <= head_reg;
                    end
                end

                TRANSMITTING: begin
                    if (net_tx_ready) begin
                        net_tx_valid <= 1'b1;
                        tx_ptr       <= tx_ptr + 1'b1;
                        if (tx_ptr == tail_reg - 1'b1) begin
                            state     <= IDLE;
                            is_locked <= 1'b0;
                            head_reg  <= 8'd0;
                            tail_reg  <= 8'd0;
                            fifo_full <= 1'b0;
                        end
                    end
                end
            endcase
        end
    end

    FIFO_72W256D FIFO_blk (
        .clka(clk),
        .wea(bram_we),
        .addra(bram_addr_a),
        .dina(bram_din_a),
        .douta(bram_dout_a),
        .clkb(clk),
        .addrb(port_b_addr),
        .doutb(port_b_dout)
    );

    assign cpu_data_out = fifo_head ? {24'b0, head_reg}
        : (fifo_tail ? {24'b0, tail_reg} : (fifo_data ? bram_dout_a[31:0] : 32'b0));
    assign raw_data_out = bram_dout_a;

endmodule
