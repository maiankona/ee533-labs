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
    // Command latch / issue control
    // -------------------------------------------------------
    reg [5:0]  opcode_q;
    reg [63:0] r1_q, r2_q, rd_q;

    reg [3:0] valid_pipe;

    assign cmd_ready = ~(|valid_pipe);
    wire cmd_fire = cmd_valid & cmd_ready;

    always @(posedge clk) begin
        if (rst) begin
            opcode_q   <= 6'h00;
            r1_q       <= 64'h0;
            r2_q       <= 64'h0;
            rd_q       <= 64'h0;
            valid_pipe <= 4'h0;
        end else begin
            if (cmd_fire) begin
                opcode_q <= opcode;
                r1_q     <= r1data;
                r2_q     <= r2data;
                rd_q     <= rd_data;
            end

            valid_pipe <= {valid_pipe[2:0], cmd_fire};
        end
    end

    assign tensor_done = valid_pipe[3];

    // -------------------------------------------------------
    // Opcode decode from latched command
    // -------------------------------------------------------
    wire is_vadd  = (opcode_q == 6'h06);
    wire is_vsub  = (opcode_q == 6'h07);
    wire is_vmul  = (opcode_q == 6'h08);
    wire is_vmac  = (opcode_q == 6'h09);
    wire is_vrelu = (opcode_q == 6'h0A);
    wire is_active = is_vadd | is_vsub | is_vmul | is_vmac | is_vrelu;

    // subtraction control into bf16_fma
    wire sub_c = is_vsub;

    // -------------------------------------------------------
    // FMA operand routing
    // -------------------------------------------------------
    // VADD:  1.0 * r1 + r2
    // VSUB:  1.0 * r1 - r2   (handled inside bf16_fma via sub_c)
    // VMUL:  r1 * r2 + 0
    // VMAC:  r1 * r2 + rd
    // VRELU: bypass FMA entirely
    wire [63:0] fma_a = (is_vadd | is_vsub) ? 64'h3F803F803F803F80 :
                        (is_vmul | is_vmac) ? r1_q :
                        64'h0;

    wire [63:0] fma_b = (is_vadd | is_vsub) ? r1_q :
                        (is_vmul | is_vmac) ? r2_q :
                        64'h0;

    wire [63:0] fma_c = is_vmac ? rd_q :
                        (is_vadd | is_vsub) ? r2_q :
                        64'h0;

    // -------------------------------------------------------
    // FMA instance
    // -------------------------------------------------------
    wire [63:0] fma_result;
    wire        fma_valid;

    bf16_fma fma_unit (
        .clk       (clk),
        .rst       (rst),
        .sub_c     (sub_c),
        .operand_a (fma_a),
        .operand_b (fma_b),
        .operand_c (fma_c),
        .result    (fma_result),
        .valid     (fma_valid)
    );

    // -------------------------------------------------------
    // True VRELU: clamp r1_q directly, bypassing FMA
    // -------------------------------------------------------
    wire [63:0] relu_result = {
        r1_q[63] ? 16'h0000 : r1_q[63:48],
        r1_q[47] ? 16'h0000 : r1_q[47:32],
        r1_q[31] ? 16'h0000 : r1_q[31:16],
        r1_q[15] ? 16'h0000 : r1_q[15:0]
    };

    // -------------------------------------------------------
    // Output select
    // -------------------------------------------------------
    assign tensor_out = is_vrelu ? relu_result : fma_result;

endmodule