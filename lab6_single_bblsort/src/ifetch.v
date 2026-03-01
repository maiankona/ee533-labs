module ifetch (
    input          clk,
    input          rst,
    input          write_to_imem,       
    input  [8:0]  addr_imem_host,   
    input  [31:0] imem_data,        

    input          take_branch,    // HIGH when a branch condition is met
    input  [8:0]  branch_target,  // The address we want to jump to
    output [31:0] instruction_out, 
    output [8:0]  pc              // This is the PC of the instruction currently being output
);
    
    wire [8:0] pc_next;      
    wire [8:0] imem_addr;
    wire [31:0] instruction_raw;

    reg       reg_take_branch;
    reg [8:0] reg_branch_target;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_take_branch   <= 1'b0;
            reg_branch_target <= 9'd0;
        end else begin
            reg_take_branch   <= take_branch;
            reg_branch_target <= branch_target;
        end
    end
    
    assign pc_next = take_branch ? branch_target : (pc + 9'd1);

    // 2. PC Register
    // Only update the PC when the host isn't busy writing instructions.
    wire [8:0] pc_reg_in = write_to_imem ? pc : pc_next;

    register_generate #(9) pc_store (
        .clk(clk),
        .rst(rst),
        .d_in(pc_reg_in),
        .q_out(pc)
    );

    // 3. Memory Addressing (The Critical Fix)
    // To account for the 1-cycle memory latency, we address the memory with 
    // the NEXT PC (pc_reg_in). This ensures that when the clock ticks:
    // - The 'pc' register becomes the new address.
    // - The 'imem' outputs the instruction AT that new address.
    assign imem_addr = rst ? 9'd0 :
							  write_to_imem ? addr_imem_host : 
							  pc_reg_in;

    mem32bit512 imem_blk (
        .addr(imem_addr),
        .clk(clk),
        .din(imem_data),
        .dout(instruction_raw),     
        .we(write_to_imem)      
    );

    assign instruction_out = instruction_raw;

endmodule