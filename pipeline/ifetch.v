module ifetch (
    input         clk,
    input         rst,
    input  		   PCSrc,
    input  [8:0]  branch_target,
    input         write_to_imem,       
    input  [8:0]  addr_imem_host,   
    input  [31:0] imem_data,        
    output [31:0] instruction_out   
);
    wire [8:0] pc;        // Internal current PC
    wire [8:0] pc_1;      // Internal next PC
    wire [8:0] imem_addr;
    wire [31:0] instruction_raw;

    // Host injection MUX
    assign imem_addr = write_to_imem ? addr_imem_host : pc;

    // PC Increment Logic w/ branching
    assign pc_1 = write_to_imem ? pc : 
                  PCSrc ? branch_target : 
                  pc + 9'd1;
 
    register_generate #(9) pc_store (
        .clk(clk),
        .rst(rst),
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

endmodule
