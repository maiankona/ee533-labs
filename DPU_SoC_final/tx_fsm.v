`timescale 1ns/1ps

module tx_fsm (
    input         clk,
    input         reset,
    input         pipeline_done,
    input         net_tx_ready,
    input  [71:0] port_b_dout,
    input  [7:0]  tx_word_count_cfg,

    output reg [7:0]  port_b_addr,
    output reg        tx_net_tx_valid,
    output reg [71:0] tx_net_tx_data,
    output wire       tx_fsm_active,

    output reg [7:0]  tx_cl_addr,
    output reg [63:0] tx_cl_wdata,
    output reg        tx_cl_we
);
    localparam [1:0] TX_IDLE  = 2'b00;
    localparam [1:0] TX_READ  = 2'b01;
    localparam [1:0] TX_SEND  = 2'b10;
    localparam [1:0] TX_CLEAR = 2'b11;
    localparam [7:0] TX_OUT_BASE = 8'hD0;

    reg [1:0] tx_state;
    reg [7:0] tx_ptr;
    reg [7:0] tx_word_count;
    reg [7:0] tx_words_sent;
    reg       tx_header_sent;

    assign tx_fsm_active = (tx_state != TX_IDLE);
    // warning: be careful of hex vs decimal vs binary

    always @(posedge clk) begin
        if (reset) begin
            tx_state        <= TX_IDLE;
            tx_ptr          <= TX_OUT_BASE;
            tx_word_count   <= 8'd0;
            tx_words_sent   <= 8'd0;
            tx_header_sent  <= 1'b0;
            port_b_addr     <= TX_OUT_BASE;
            tx_net_tx_valid <= 1'b0;
            tx_net_tx_data  <= 72'h0;
            tx_cl_addr      <= 8'h00;
            tx_cl_wdata     <= 64'h0;
            tx_cl_we        <= 1'b0;
        end else begin
            tx_net_tx_valid <= 1'b0;
            tx_cl_we        <= 1'b0;

            case (tx_state)
                TX_IDLE: begin
                    tx_cl_we       <= 1'b0; 
                    tx_header_sent <= 1'b0;
                    tx_words_sent  <= 8'd0;
                    tx_ptr         <= TX_OUT_BASE;
                    port_b_addr    <= TX_OUT_BASE;
                    if (pipeline_done) begin // wait for GPU to assert pipeline_done
                        // programmed payload word count from ids
                        tx_word_count <= (tx_word_count_cfg == 8'd0) ? 8'd1 : tx_word_count_cfg;
                        tx_state      <= TX_READ;
                    end
                end

                TX_READ: begin
                    port_b_addr <= tx_ptr; 
                    tx_state    <= TX_SEND;
                end

                TX_SEND: begin
                    if (net_tx_ready) begin
                        tx_net_tx_valid <= 1'b1;
                        // SOP = FF, body = 00, last payload word = 80
                        if (!tx_header_sent) begin
                            tx_net_tx_data <= {8'hFF, 64'h0}; 
                            tx_header_sent <= 1'b1;
                            tx_state       <= TX_READ;
                        end else begin
                            tx_net_tx_data <= {(tx_words_sent + 8'd1 >= tx_word_count) ? 8'h80 : 8'h00, port_b_dout[63:0]};
                            tx_words_sent  <= tx_words_sent + 8'd1;
                            if (tx_ptr < 8'hEF) tx_ptr         <= tx_ptr + 8'd1; //increment address by 1 (but shouldnt surpass 0xEF)
                            if (tx_words_sent + 8'd1 >= tx_word_count)
                                tx_state <= TX_CLEAR;
                            else
                                tx_state <= TX_READ;
                        end
                    end
                end

                TX_CLEAR: begin
                    tx_cl_addr  <= 8'h00;
                    tx_cl_wdata <= 64'h0;
                    tx_cl_we    <= 1'b1; // writes 0 to 0x00 to clear the FIFO
                    tx_state    <= TX_IDLE;
                end

                default: tx_state <= TX_IDLE;
            endcase
        end
    end

endmodule
