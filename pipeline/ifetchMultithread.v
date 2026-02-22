module ifetch (
    input         clk,
    input         rst,

    // Thread select from arbiter
    input  [1:0]  thread_sel,

    input         PCSrc,
    input  [8:0]  branch_target,

    input         write_to_imem,       
    input  [8:0]  addr_imem_host,   
    input  [31:0] imem_data,        

    output [31:0] instruction_out   
);

    // 4 independent PCs
    reg [8:0] PC_bank [3:0];

    wire [8:0] pc_current;
    wire [8:0] pc_next;
    wire [8:0] imem_addr;
    wire [31:0] instruction_raw;

    // Select current thread's PC
    assign pc_current = PC_bank[thread_sel];

    // Host injection MUX
    assign imem_addr = write_to_imem ? addr_imem_host : pc_current;

    // PC increment logic
    assign pc_next =
        PCSrc ? branch_target :
        pc_current + 9'd1;

    // PC update logic
    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Initialize all 4 PCs to 0
            for (i = 0; i < 4; i = i + 1)
                PC_bank[i] <= 9'd0;
        end
        else if (!write_to_imem) begin
            // Only update the currently selected thread's PC
            PC_bank[thread_sel] <= pc_next;
        end
    end

    // Instruction memory
    mem32bit512 imem_blk (
        .addr(imem_addr),
        .clk(clk),
        .din(imem_data),
        .dout(instruction_raw),     
        .we(write_to_imem)      
    );

    assign instruction_out = instruction_raw;

endmodule
