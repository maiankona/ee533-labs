///////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

module gpu_control_interface_2 (
    input  wire        clk,
    input  wire        rst,

    // --- ARM MEM stage bus (raw, undecoced) ---
    input  wire [7:0]  host_addr,    // cpu_mem_addr
    input  wire [63:0] host_data,    // cpu_mem_data
    input  wire        host_we,      // cpu_mem_we

    // --- Status output to ARM ---
    output reg         gpu_irq,      // raised when pipeline done, cleared on 0xF3 ack

    // --- To GPU pipeline ---
    output reg         gpu_start,    // one-cycle pulse: begin fetching from bram_inst_addr
    output reg  [7:0]  bram_inst_addr,
    output reg  [7:0]  bram_length,
    input  wire        pipeline_done,

    // --- IMEM write enable (to ids.v ? pipeline_gpu) ---
    output wire        imem_we_en
);

    // ?? Address decode ?????????????????????????????????????
    wire is_cfg_base  = host_we && (host_addr == 8'hF0);
    wire is_cfg_len   = host_we && (host_addr == 8'hF1);
    wire gpu_dispatch = host_we && (host_addr == 8'hF2);
    wire arm_irq_ack  = host_we && (host_addr == 8'hF3);

    // ?? cfg registers ??????????????????????????????????????
    reg [7:0] cfg_inst_addr_r;
    reg [7:0] cfg_length_r;

    always @(posedge clk) begin
        if (rst) begin
            cfg_inst_addr_r <= 8'h50;
            cfg_length_r    <= 8'h00;
        end else begin
            if (is_cfg_base) cfg_inst_addr_r <= host_data[7:0];
            if (is_cfg_len)  cfg_length_r    <= host_data[7:0];
        end
    end

    // ?? IMEM write window ??????????????????????????????????
    // Any host write whose address falls within [cfg_inst_addr_r,
    // cfg_inst_addr_r + cfg_length_r) is a GPU IMEM write.
    assign imem_we_en = host_we &&
                        (host_addr >= cfg_inst_addr_r) &&
                        (host_addr <  cfg_inst_addr_r + cfg_length_r);

    // ?? FSM ????????????????????????????????????????????????
    reg [1:0] state, next_state;
    localparam IDLE      = 2'b00,
               EXECUTING = 2'b01,
               DONE      = 2'b10;

    // State register
    always @(posedge clk) begin
        if (rst) state <= IDLE;
        else     state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE:      next_state = gpu_dispatch  ? EXECUTING : IDLE;
            EXECUTING: next_state = pipeline_done ? DONE      : EXECUTING;
            DONE:      next_state = arm_irq_ack   ? IDLE      : DONE;
            default:   next_state = IDLE;
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (rst) begin
            gpu_irq        <= 1'b0;
            gpu_start      <= 1'b0;
            bram_inst_addr <= 8'h50;
            bram_length    <= 8'h00;
        end else begin
            case (state)
                IDLE: begin
                    gpu_irq   <= 1'b0;
                    gpu_start <= 1'b0;
                    if (gpu_dispatch) begin
                        bram_inst_addr <= cfg_inst_addr_r;
                        bram_length    <= cfg_length_r;
                        gpu_start      <= 1'b1;
                    end
                end
                EXECUTING: begin
                    gpu_start <= 1'b0;
                end
                DONE: begin
                    gpu_irq <= arm_irq_ack ? 1'b0 : 1'b1;
                end
                default: begin
                    gpu_irq   <= 1'b0;
                    gpu_start <= 1'b0;
                end
            endcase
        end
    end

endmodule