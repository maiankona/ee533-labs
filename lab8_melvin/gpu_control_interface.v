module gpu_control_interface (
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] arm_instruction,
    input  wire        gpu_dispatch, // asserted by address decoder when ARM STRs to GPU_DISPATCH_ADDR
    output reg         gpu_ready,
    output reg         gpu_done,
    output reg         gpu_irq,
    input  wire        arm_irq_ack,
    output reg  [31:0] inst_out,
    output reg         inst_out_valid,
    input  wire        pipeline_done
);

reg [1:0] state, next_state;
parameter IDLE = 2'b00, EXECUTING = 2'b01, DONE = 2'b10;

// State Memory
always @(posedge clk) begin
    if (rst) state <= IDLE;
    else     state <= next_state;
end

// Next State Logic
always @(*) begin
    next_state = state;
    case (state)
        IDLE:
            next_state = gpu_dispatch ? EXECUTING : IDLE; // ARM STR to GPU_DISPATCH_ADDR triggers execution
        EXECUTING:
            next_state = pipeline_done ? DONE : EXECUTING;     // When the pipeline (Tensor core) is done
        DONE:
            next_state = arm_irq_ack ? IDLE : DONE;            // If CPU acknowledges interrupt, go to IDLE and ready for next instr.
        default: next_state = IDLE;
    endcase
end

// Output
always @(posedge clk) begin
    // Default values to prevent latches
    if (rst) begin
        gpu_ready      <= 1'b1;
        gpu_done       <= 1'b0;
        gpu_irq        <= 1'b0;
        inst_out       <= 32'b0;
        inst_out_valid <= 1'b0;
    end 
    else begin

        case(state)
            IDLE: begin
                gpu_ready      <= 1'b1;
                gpu_done       <= 1'b0;
                gpu_irq        <= 1'b0;
                inst_out_valid <= 1'b0;
                if (gpu_dispatch) begin
                    gpu_ready      <= 1'b0;       // drop ready immediately so ARM cannot issue a second instr. this cycle
                    inst_out       <= arm_instruction;  // capture dispatch data (opcode/config) from ARM data bus
                    inst_out_valid <= 1'b1;
                end
            end
            EXECUTING: begin
                gpu_ready      <= 1'b0;
                inst_out_valid <= 1'b0; // clear validity, as instr. is already under operation
            end

            DONE: begin
                gpu_done       <= 1'b1;
                gpu_irq        <= arm_irq_ack ? 1'b0 : 1'b1;  // clear same cycle as ack
                inst_out_valid <= 1'b0;
            end

        default: begin
                gpu_ready      <= 1'b1;
                gpu_done       <= 1'b0;
                gpu_irq        <= 1'b0;
                inst_out_valid <= 1'b0;
            end
        endcase
    end
end

endmodule