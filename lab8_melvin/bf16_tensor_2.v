module bf16_tensor_2 (
    input  wire        clk,
    input  wire        rst,

    input  wire        cmd_valid,
    output wire        cmd_ready,

    input  wire [5:0]  opcode,
    input  wire [63:0] r1data,
    input  wire [63:0] r2data,
    input  wire [63:0] rd_data,

    output wire [63:0] tensor_out,
    output wire        tensor_done
);

    // -------------------------------------------------------
    // Issue / predecode latch
    // -------------------------------------------------------
    reg [63:0] r1_q, r2_q, rd_q;
    reg [63:0] fma_a_r, fma_b_r, fma_c_r;
    reg        sub_c_r;
    reg        vrelu_r;

    // 4-cycle completion from cmd_fire:
    // wrapper latch + 3-stage FMA
    reg [3:0] valid_pipe;

    assign cmd_ready = ~(|valid_pipe);
    wire cmd_fire = cmd_valid & cmd_ready;

    always @(posedge clk) begin
        if (rst) begin
            r1_q      <= 64'h0;
            r2_q      <= 64'h0;
            rd_q      <= 64'h0;
            fma_a_r   <= 64'h0;
            fma_b_r   <= 64'h0;
            fma_c_r   <= 64'h0;
            sub_c_r   <= 1'b0;
            vrelu_r   <= 1'b0;
            valid_pipe <= 4'h0;
        end else begin
            if (cmd_fire) begin
                r1_q    <= r1data;
                r2_q    <= r2data;
                rd_q    <= rd_data;

                vrelu_r <= (opcode == 6'h0A);
                sub_c_r <= (opcode == 6'h07);

                fma_a_r <= ((opcode == 6'h06) || (opcode == 6'h07)) ? 64'h3F803F803F803F80 :
                           ((opcode == 6'h08) || (opcode == 6'h09)) ? r1data : 64'h0;

                fma_b_r <= ((opcode == 6'h06) || (opcode == 6'h07)) ? r1data :
                           ((opcode == 6'h08) || (opcode == 6'h09)) ? r2data : 64'h0;

                fma_c_r <= (opcode == 6'h09) ? rd_data :
                           ((opcode == 6'h06) || (opcode == 6'h07)) ? r2data : 64'h0;
            end

            valid_pipe <= {valid_pipe[2:0], cmd_fire};
        end
    end

    // -------------------------------------------------------
    // FMA instance
    // -------------------------------------------------------
    wire [63:0] fma_result;
    wire        fma_valid;

    bf16_fma fma_unit (
        .clk       (clk),
        .rst       (rst),
        .sub_c     (sub_c_r),
        .operand_a (fma_a_r),
        .operand_b (fma_b_r),
        .operand_c (fma_c_r),
        .result    (fma_result),
        .valid     (fma_valid)
    );

    assign tensor_done = valid_pipe[3] & fma_valid;

    // -------------------------------------------------------
    // True VRELU bypass
    // -------------------------------------------------------
    wire [63:0] relu_result = {
        r1_q[63] ? 16'h0000 : r1_q[63:48],
        r1_q[47] ? 16'h0000 : r1_q[47:32],
        r1_q[31] ? 16'h0000 : r1_q[31:16],
        r1_q[15] ? 16'h0000 : r1_q[15:0]
    };

    assign tensor_out = vrelu_r ? relu_result : fma_result;

endmodule