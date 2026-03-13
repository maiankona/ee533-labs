module bf16_tensor_2 (
    input  wire        clk,
    input  wire        rst,
    input  wire [5:0]  opcode,
    input  wire [63:0] r1data,
    input  wire [63:0] r2data,
    input  wire [63:0] rd_data,
    output wire [63:0] tensor_out,
    output wire        tensor_done
);

// --- opcodes ---
wire is_vadd  = (opcode == 6'h06);
wire is_vsub  = (opcode == 6'h07);
wire is_vmul  = (opcode == 6'h08);
wire is_vmac  = (opcode == 6'h09);
wire is_vrelu = (opcode == 6'h0A);
wire is_active = is_vadd | is_vsub | is_vmul | is_vmac | is_vrelu;

// --- fma opcode mapping ---
localparam FMA  = 2'b00;
localparam VMUL = 2'b01;
localparam VADD = 2'b10;

reg [1:0] fma_opcode;
always @(*) begin
    case (1'b1)
        is_vmac:            fma_opcode = FMA;
        is_vmul:            fma_opcode = VMUL;
        is_vadd | is_vsub:  fma_opcode = VADD;
        default:            fma_opcode = VMUL; // NOP ? VMUL with zero operands
    endcase
end

// --- vsub: flip sign of B by inverting bit 15 of each lane ---
wire [63:0] r2_for_fma = is_vsub ?
    {r2data[63] ^ 1'b1, r2data[62:48],
     r2data[47] ^ 1'b1, r2data[46:32],
     r2data[31] ^ 1'b1, r2data[30:16],
     r2data[15] ^ 1'b1, r2data[14:0]}
    : r2data;

// --- fma operand routing ---
// VADD:  fma sees A=r1, B=r2 (or r2_negated for vsub), C=don't care (forced internally)
// VMUL:  fma sees A=r1, B=r2, C=0 (forced internally)
// VMAC:  fma sees A=r1, B=r2, C=rd (accumulator)
// NOP:   zero operands, result ignored
wire [63:0] fma_a = is_active ? r1data  : 64'h0;
wire [63:0] fma_b = is_active ? r2_for_fma : 64'h0;
wire [63:0] fma_c = is_vmac   ? rd_data : 64'h0;

// --- fma instance ---
wire [63:0] fma_result;
wire        fma_valid;

bf16_fma fma_unit (
    .clk       (clk),
    .rst       (rst),
    .operand_a (fma_a),
    .operand_b (fma_b),
    .operand_c (fma_c),
    .opcode    (fma_opcode),
    .result    (fma_result),
    .valid     (fma_valid)
);

// --- vrelu: applied after fma result, combinational ---
// relu is pass-through if positive, zero if negative (check sign bit of each lane)
wire [63:0] relu_result = {
    fma_result[63] ? 16'h0000 : fma_result[63:48],
    fma_result[47] ? 16'h0000 : fma_result[47:32],
    fma_result[31] ? 16'h0000 : fma_result[31:16],
    fma_result[15] ? 16'h0000 : fma_result[15:0]
};

// --- tensor_done: 4-cycle shift register tracking is_active ---
// fires one cycle after fma_valid for the corresponding instruction
reg [3:0] active_pipe;
always @(posedge clk) begin
    if (rst)
        active_pipe <= 4'h0;
    else
        active_pipe <= {active_pipe[2:0], is_active & ~is_vrelu};
end

// vrelu is combinational ? done in 0 extra cycles after fma
// but fma still takes 4 cycles, so vrelu done follows same pipe
reg [3:0] vrelu_pipe;
always @(posedge clk) begin
    if (rst)
        vrelu_pipe <= 4'h0;
    else
        vrelu_pipe <= {vrelu_pipe[2:0], is_vrelu};
end

assign tensor_done = active_pipe[3] | vrelu_pipe[3];

// --- output mux ---
// select relu output if vrelu instruction just completed
assign tensor_out = vrelu_pipe[3] ? relu_result : fma_result;

endmodule