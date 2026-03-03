`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// bf16_tensor.v  -  BF16 tensor unit  (optimised, port-matched)
//
// CHANGES FROM ORIGINAL:
//   1. Port signature matches caller: opcode/r1data/r2data/rd_data/tensor_out/tensor_done
//   2. 4x bf16_add collapsed to 1 time-multiplexed instance  (~3x SLICE saving)
//   3. tensor_done registered; fires after result is fully stable
//   4. VMAC support: per-lane  r1*r2 + rd_data  through the shared adder
//
// OPCODE ENCODING  (adjust localparams to match your ISA):
//   OP_IDLE = 0   -- no operation; unit stays idle
//   OP_VADD = 1   -- tensor_out[i] = r1data[i] + r2data[i]
//   OP_VSUB = 2   -- tensor_out[i] = r1data[i] - r2data[i]
//   OP_VMUL = 3   -- tensor_out[i] = r1data[i] * r2data[i]   (2-cycle latency)
//   OP_VMAC = 4   -- tensor_out[i] = r1data[i] * r2data[i] + rd_data[i]
//
// PIPELINE DEPTH:
//   Set PIPE_DEPTH to the latency of your bf16_add CORE Generator core.
//   Check the XCO log or data sheet.  Wrong value → wrong lane→result mapping.
//   Typical range for Xilinx FP v4.0 on Virtex-II: 6-8 cycles.
//
// bf16_add PORT NAMES:
//   Instantiation uses .clk .a .b .operation .result
//   Adjust to your .ngc symbol if they differ.
//
// LATENCY (trigger cycle → tensor_done=1):
//   VMUL :   2 cycles
//   VADD/VSUB/VMAC : PIPE_DEPTH + 6 cycles  (e.g. 13 for PIPE_DEPTH=7)
//
// ASSUMPTION:
//   r1data/r2data/rd_data/opcode are held stable by the caller until
//   tensor_done is observed.  Asserting a new opcode before tensor_done
//   will corrupt the in-flight pipeline.
//////////////////////////////////////////////////////////////////////////////////

module bf16_tensor (
    input         clk,
    input  [5:0]  opcode,

    input  [63:0] r1data,        // 4x BF16: [63:48]=lane3 ... [15:0]=lane0
    input  [63:0] r2data,
    input  [63:0] rd_data,       // accumulator lanes for VMAC

    output reg [63:0] tensor_out,
    output reg        tensor_done
);

    // -----------------------------------------------------------------------
    // Opcode encoding  -- adjust to match your ISA
    // -----------------------------------------------------------------------
    localparam OP_IDLE = 6'd0;
    localparam OP_VADD = 6'd1;
    localparam OP_VSUB = 6'd2;
    localparam OP_VMUL = 6'd3;
    localparam OP_VMAC = 6'd4;   // per-lane fused multiply-accumulate

    // Pipeline depth of bf16_add -- *** VERIFY against your CORE Generator data sheet ***
    parameter PIPE_DEPTH = 7;

    // -----------------------------------------------------------------------
    // Combinational opcode decode (based on live opcode input)
    // -----------------------------------------------------------------------
    wire is_vadd = (opcode == OP_VADD);
    wire is_vsub = (opcode == OP_VSUB);
    wire is_vmul = (opcode == OP_VMUL);
    wire is_vmac = (opcode == OP_VMAC);

    // Operations that route through the bf16_add pipeline
    wire use_add_path = is_vadd || is_vsub || is_vmac;
    // Operations that use only combinational bf16Mul (no adder needed)
    wire use_mul_path = is_vmul;

    // -----------------------------------------------------------------------
    // Busy / trigger
    //   trigger fires on the first cycle a non-idle opcode arrives while idle.
    //   busy prevents re-triggering until tensor_done.
    // -----------------------------------------------------------------------
    reg busy;
    wire trigger = (opcode != OP_IDLE) && !busy;

    always @(posedge clk) begin
        if (trigger)
            busy <= 1'b1;
        else if (tensor_done)
            busy <= 1'b0;
    end

    // -----------------------------------------------------------------------
    // Latch operation type at trigger so it stays stable while pipeline runs.
    // (Caller must hold opcode/r1data/r2data/rd_data stable, but as a safety
    //  net we capture is_vsub and is_vmac here and use the latched versions
    //  inside the pipeline mux.)
    // -----------------------------------------------------------------------
    reg is_vsub_lat;   // latched: current op is VSUB
    reg is_vmac_lat;   // latched: current op is VMAC
    reg use_add_lat;   // latched: current op uses bf16_add path
    reg use_mul_lat;   // latched: current op uses bf16Mul-only path

    always @(posedge clk) begin
        if (trigger) begin
            is_vsub_lat <= is_vsub;
            is_vmac_lat <= is_vmac;
            use_add_lat <= use_add_path;
            use_mul_lat <= use_mul_path;
        end
    end

    // -----------------------------------------------------------------------
    // 4x combinational BF16 multipliers
    //   Used directly for VMUL (output registered 1 cycle later).
    //   For VMAC their outputs feed the bf16_add as the A operand.
    // -----------------------------------------------------------------------
    wire [15:0] mul_out0, mul_out1, mul_out2, mul_out3;

    bf16Mul mul0 (.oprA(r1data[15:0]),  .oprB(r2data[15:0]),  .result(mul_out0));
    bf16Mul mul1 (.oprA(r1data[31:16]), .oprB(r2data[31:16]), .result(mul_out1));
    bf16Mul mul2 (.oprA(r1data[47:32]), .oprB(r2data[47:32]), .result(mul_out2));
    bf16Mul mul3 (.oprA(r1data[63:48]), .oprB(r2data[63:48]), .result(mul_out3));

    // -----------------------------------------------------------------------
    // ADD/SUB/VMAC path: lane input counter
    //   One cycle after trigger (if use_add_path): feeding=1, lane_in=0
    //   Counter advances 0->1->2->3, then feeding falls.
    // -----------------------------------------------------------------------
    reg        feeding;
    reg [1:0]  lane_in;

    always @(posedge clk) begin
        if (trigger && use_add_path) begin
            feeding <= 1'b1;
            lane_in <= 2'd0;
        end else if (feeding) begin
            if (lane_in == 2'd3)
                feeding <= 1'b0;
            else
                lane_in <= lane_in + 2'd1;
        end
    end

    // Lane input mux
    //   VADD/VSUB : adder A = r1data[lane],  adder B = r2data[lane]
    //   VMAC      : adder A = mul_out[lane],  adder B = rd_data[lane]
    //
    // Explicit sensitivity list -- avoids ISE @(*) parser bug near (* *) attrs
    reg [15:0] addA_mux, addB_mux;

    always @(lane_in or is_vmac_lat or
             r1data or r2data or rd_data or
             mul_out0 or mul_out1 or mul_out2 or mul_out3) begin
        case (lane_in)
            2'd0: begin
                addA_mux = is_vmac_lat ? mul_out0        : r1data[15:0];
                addB_mux = is_vmac_lat ? rd_data[15:0]   : r2data[15:0];
            end
            2'd1: begin
                addA_mux = is_vmac_lat ? mul_out1        : r1data[31:16];
                addB_mux = is_vmac_lat ? rd_data[31:16]  : r2data[31:16];
            end
            2'd2: begin
                addA_mux = is_vmac_lat ? mul_out2        : r1data[47:32];
                addB_mux = is_vmac_lat ? rd_data[47:32]  : r2data[47:32];
            end
            2'd3: begin
                addA_mux = is_vmac_lat ? mul_out3        : r1data[63:48];
                addB_mux = is_vmac_lat ? rd_data[63:48]  : r2data[63:48];
            end
            default: begin addA_mux = 16'd0; addB_mux = 16'd0; end
        endcase
    end

    // bf16_add operation input: 0=ADD (used for VADD and VMAC), 1=SUB
    wire [5:0] add_op = is_vsub_lat ? 6'd1 : 6'd0;

    // -----------------------------------------------------------------------
    // Single bf16_add instance  (replaces 4 parallel instances)
    // Adjust port names to match your CORE Generator .ngc wrapper.
    // -----------------------------------------------------------------------
    wire [15:0] add_out;

    bf16_add add_inst (
        .clk      (clk),
        .a        (addA_mux),
        .b        (addB_mux),
        .operation(add_op),
        .result   (add_out)
    );

    // -----------------------------------------------------------------------
    // Pipeline tracking shift register
    //   Shadows (lane_in, feeding) delayed by PIPE_DEPTH cycles so we know
    //   which lane is currently at the bf16_add output.
    // -----------------------------------------------------------------------
    reg [1:0] lane_pipe  [0:PIPE_DEPTH-1];
    reg       valid_pipe [0:PIPE_DEPTH-1];
    integer   k;

    always @(posedge clk) begin
        lane_pipe[0]  <= lane_in;
        valid_pipe[0] <= feeding;
        for (k = 1; k < PIPE_DEPTH; k = k + 1) begin
            lane_pipe[k]  <= lane_pipe[k-1];
            valid_pipe[k] <= valid_pipe[k-1];
        end
    end

    // -----------------------------------------------------------------------
    // Delayed trigger flags for VMUL path (2-cycle combinational result)
    // -----------------------------------------------------------------------
    reg trigger_d1, use_mul_lat_d1;
    reg trigger_d2, use_mul_lat_d2;

    always @(posedge clk) begin
        trigger_d1      <= trigger;
        use_mul_lat_d1  <= use_mul_lat;
        trigger_d2      <= trigger_d1;
        use_mul_lat_d2  <= use_mul_lat_d1;
    end

    // -----------------------------------------------------------------------
    // tensor_out register  (SINGLE always block -- avoids multiple-driver warning)
    //
    //   ADD/SUB/VMAC: write each lane slice as it emerges from bf16_add pipeline.
    //   VMUL:         write all 4 lanes at once, one cycle after trigger
    //                 (bf16Mul is combinational; results stable by then).
    //
    //   The two paths are mutually exclusive (use_add_lat / use_mul_lat_d1).
    // -----------------------------------------------------------------------
    always @(posedge clk) begin
        // ADD/SUB/VMAC: capture lane result as it arrives
        if (valid_pipe[PIPE_DEPTH-1]) begin
            case (lane_pipe[PIPE_DEPTH-1])
                2'd0: tensor_out[15:0]  <= add_out;
                2'd1: tensor_out[31:16] <= add_out;
                2'd2: tensor_out[47:32] <= add_out;
                2'd3: tensor_out[63:48] <= add_out;
            endcase
        end

        // VMUL: register all 4 combinational outputs simultaneously
        if (trigger_d1 && use_mul_lat_d1)
            tensor_out <= {mul_out3, mul_out2, mul_out1, mul_out0};
    end

    // -----------------------------------------------------------------------
    // tensor_done
    //
    //   ADD/SUB/VMAC:
    //     last_lane_flag  -- fires when lane 3 writes tensor_out[63:48] (NBA;
    //                        not stable yet for external reads this cycle).
    //     last_lane_flag_d1 -- one cycle later; tensor_out[63:48] is settled.
    //     tensor_done asserts on last_lane_flag_d1.
    //
    //   VMUL:
    //     tensor_out written at trigger_d1.  tensor_done fires at trigger_d2
    //     (one cycle later) so external logic sees a stable tensor_out.
    // -----------------------------------------------------------------------
    wire last_lane_flag = valid_pipe[PIPE_DEPTH-1] &&
                          (lane_pipe[PIPE_DEPTH-1] == 2'd3);

    reg last_lane_flag_d1;

    always @(posedge clk)
        last_lane_flag_d1 <= last_lane_flag;

    always @(posedge clk) begin
        tensor_done <= 1'b0;

        if (last_lane_flag_d1)                      // ADD/SUB/VMAC complete
            tensor_done <= 1'b1;

        if (trigger_d2 && use_mul_lat_d2)            // VMUL complete
            tensor_done <= 1'b1;
    end

endmodule
