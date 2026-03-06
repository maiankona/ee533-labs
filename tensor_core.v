module tensor_core(
    input clk,
    input rst,
    
    // Control interface from CPU
    input        start,
    input [5:0]  opcode,
    input [7:0]  src_a_addr,
    input [7:0]  src_b_addr,
    input [7:0]  dst_addr,
    input [7:0]  accum_addr,
    output reg   done,
    
    // Shared memory interface (to FIFO/BRAM)
    output reg [7:0]  mem_addr,
    input  [63:0]     mem_rdata,
    output reg [63:0] mem_wdata,
    output reg        mem_we
);

    // State machine
    localparam IDLE       = 3'd0;
    localparam LOAD_A     = 3'd1;
    localparam LOAD_B     = 3'd2;
    localparam LOAD_ACCUM = 3'd3;
    localparam EXECUTE    = 3'd4;
    localparam STORE      = 3'd5;
    
    reg [2:0] state;
    reg [3:0] cycle_count;
    
    reg [63:0] operand_a, operand_b, operand_accum;
    reg [63:0] result;
    
    // Instantiate your tensor unit
    wire [63:0] tensor_out;
    bf16_tensor tensor_unit(
        .clk(clk),
        .opcode(opcode),
        .r1data(operand_a),
        .r2data(operand_b),
        .rd_data(operand_accum),
        .tensor_out(tensor_out),
        .tensor_done()  
    );
    
    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            done <= 0;
            mem_we <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    mem_we <= 0;
                    if (start) begin
                        state <= LOAD_A;
                        mem_addr <= src_a_addr;
                    end
                end
                
                LOAD_A: begin
                    operand_a <= mem_rdata;
                    mem_addr <= src_b_addr;
                    state <= LOAD_B;
                end
                
                LOAD_B: begin
                    operand_b <= mem_rdata;
                    // If VMAC, need to load accumulator
                    if (opcode == 6'h09) begin
                        mem_addr <= accum_addr;
                        state <= LOAD_ACCUM;
                    end else begin
                        operand_accum <= 64'h0;
                        state <= EXECUTE;
                        cycle_count <= 0;
                    end
                end
                
                LOAD_ACCUM: begin
                    operand_accum <= mem_rdata;
                    state <= EXECUTE;
                    cycle_count <= 0;
                end
                
                EXECUTE: begin
                    // Wait for tensor operation to complete
                    // (adjust cycle_count based on operation latency)
                    cycle_count <= cycle_count + 1;
                    
                  if (cycle_count >= 4'd9) begin  // Max latency
                        result <= tensor_out;
                        mem_addr <= dst_addr;
                        mem_wdata <= tensor_out;
                        mem_we <= 1;
                        state <= STORE;
                    end
                end
                
                STORE: begin
                    mem_we <= 0;
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
