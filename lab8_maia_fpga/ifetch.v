module ifetch (
    input         clk,
    input         rst,
    input         stall,            // from hazard unit — freeze PC during RAW stall
    input         PCSrc,
    input  [8:0]  branch_target,
    input         write_to_imem,
    input         read_req_imem,    // host read: use addr_imem_host, output to data_out_imem
    input  [8:0]  addr_imem_host,
    input  [31:0] imem_data,        // FIX: was 64-bit, mem32bit512 din is 32-bit
    output [31:0] instruction_out,
    output [31:0] data_out_imem,    // IMEM read data for host (1-cycle latency)
    output [8:0]  pc_plus_1_out     // exposed for decode branch target calculation
);
    wire [8:0] pc;        // Internal current PC
    wire [8:0] pc_1;      // Internal next PC
    wire [8:0] imem_addr;
    wire [31:0] instruction_raw;

    // Host injection MUX: write, read, or PC
    assign imem_addr = (write_to_imem || read_req_imem) ? addr_imem_host : pc;

    // PC Increment Logic w/ branching
    // Priority: host write/read → stall → branch → increment
    assign pc_1 = (write_to_imem || read_req_imem) ? pc :
                  stall          ? pc :          // hold PC during hazard stall
                  PCSrc          ? branch_target :
                  pc + 9'd1;

    // pc_plus_1 always reflects pc+1 regardless of mux state
    // decode uses this for branch target calculation (branch_target = pc+1 + offset)
    assign pc_plus_1_out = pc + 9'd1;

    // FIX: stall tied to 1'b0 — PC stall is already handled by the pc_1 mux above
    // using register_generate stall here would double-stall and corrupt the PC
    register_generate #(9) pc_store (
        .clk(clk),
        .rst(rst),
        .stall(1'b0),
        .d_in(pc_1),
        .q_out(pc)
    );

    mem32bit512 imem_blk (
        .addr(imem_addr),
        .clk(clk),
        .din(imem_data),
        .dout(instruction_raw),     
        .we(write_to_imem)      
    );

    assign instruction_out = instruction_raw;
    assign data_out_imem   = instruction_raw;  // same port; valid 1 cycle after addr set

endmodule
