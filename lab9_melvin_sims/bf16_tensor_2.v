`timescale 1ns / 1ps

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
    // Issue latch
    // -------------------------------------------------------
    reg        issue_valid_q;
    reg [5:0]  opcode_q;
    reg [63:0] r1_q, r2_q, rd_q;

    // -------------------------------------------------------
    // FMA operand registers
    // -------------------------------------------------------
    reg [63:0] fma_a_r, fma_b_r, fma_c_r;
    reg        sub_c_r;

    // -------------------------------------------------------
    // 4-cycle completion tracking from the accepted command
    // -------------------------------------------------------
    reg [3:0]  valid_pipe;

    // -------------------------------------------------------
    // fma_pending: armed on valid_pipe[3] for FMA ops,
    // cleared when fma_valid arrives one cycle later
    // -------------------------------------------------------
    reg        fma_pending;

    // -------------------------------------------------------
    // Output hold registers
    // -------------------------------------------------------
    reg [63:0] tensor_out_r;
    reg        tensor_done_r;

    // cmd_ready: block while an op is in-flight OR pending fma result
	 assign cmd_ready = ~issue_valid_q && ~fma_pending;
    wire cmd_fire = cmd_valid & cmd_ready;

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

    // -------------------------------------------------------
    // VRELU result from the latched operand
    // -------------------------------------------------------
    wire [63:0] relu_result = {
        r1_q[63] ? 16'h0000 : r1_q[63:48],
        r1_q[47] ? 16'h0000 : r1_q[47:32],
        r1_q[31] ? 16'h0000 : r1_q[31:16],
        r1_q[15] ? 16'h0000 : r1_q[15:0]
    };

    // -------------------------------------------------------
    // Combinational FMA operand select from latched command
    // -------------------------------------------------------
    always @(*) begin
        fma_a_r = 64'h0;
        fma_b_r = 64'h0;
        fma_c_r = 64'h0;
        sub_c_r = 1'b0;

        if (issue_valid_q || (|valid_pipe)) begin
            case (opcode_q)
                6'h06, 6'h07: begin // VADD_BF16 / VSUB_BF16
                    fma_a_r = 64'h3F803F803F803F80; // +1.0
                    fma_b_r = r1_q;
                    fma_c_r = r2_q;
                    sub_c_r = (opcode_q == 6'h07);
                end

                6'h08: begin // VMUL_BF16
                    fma_a_r = r1_q;
                    fma_b_r = r2_q;
                    fma_c_r = 64'h0;
                    sub_c_r = 1'b0;
                end

                6'h09: begin // VMAC_BF16
                    fma_a_r = r1_q;
                    fma_b_r = r2_q;
                    fma_c_r = rd_q;   // captured accumulator
                    sub_c_r = 1'b0;
                end

                default: begin
                    fma_a_r = 64'h0;
                    fma_b_r = 64'h0;
                    fma_c_r = 64'h0;
                    sub_c_r = 1'b0;
                end
            endcase
        end
    end

    // -------------------------------------------------------
    // Sequential control
    // -------------------------------------------------------
    always @(posedge clk) begin
        if (rst) begin
            issue_valid_q <= 1'b0;
            opcode_q      <= 6'h00;
            r1_q          <= 64'h0;
            r2_q          <= 64'h0;
            rd_q          <= 64'h0;
            valid_pipe    <= 4'h0;
            fma_pending   <= 1'b0;
            tensor_out_r  <= 64'h0;
            tensor_done_r <= 1'b0;
        end else begin
            tensor_done_r <= 1'b0;

            // --------------------------------------------------
            // Accept a command and capture its full operand bundle
            // --------------------------------------------------
            if (cmd_fire	) begin
                issue_valid_q <= 1'b1;
                opcode_q      <= opcode;
                r1_q          <= r1data;
                r2_q          <= r2data;
                rd_q          <= rd_data;
            end else if (issue_valid_q) begin
                // One cycle later the command is launched into
                // the 4-cycle pipe; clear the issue latch.
                issue_valid_q <= 1'b0;
            end

            // --------------------------------------------------
            // Advance the 4-cycle completion shift register
            // --------------------------------------------------	
				valid_pipe <= {valid_pipe[2:0], cmd_valid};

            // --------------------------------------------------
            // VRELU completes at valid_pipe[3] (no FMA needed)
            // --------------------------------------------------
            if (valid_pipe[3] && opcode_q == 6'h0A) begin
                tensor_out_r  <= relu_result;
                tensor_done_r <= 1'b1;
            end

            // --------------------------------------------------
            // FMA-based ops (VADD/VSUB/VMUL/VMAC):
            //   valid_pipe[3] fires one cycle BEFORE fma_valid,
            //   so arm fma_pending here and commit on fma_valid.
            // --------------------------------------------------
            if (valid_pipe[3] && opcode_q != 6'h0A)
                fma_pending <= 1'b1;

            if (fma_pending && fma_valid) begin
                fma_pending   <= 1'b0;
                tensor_out_r  <= fma_result;
                tensor_done_r <= 1'b1;
            end
        end
    end

    assign tensor_out  = tensor_out_r;
    assign tensor_done = tensor_done_r;

endmodule