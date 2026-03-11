module ifetch (
    input         clk,
    input         rst,
    input         write_to_imem,       
    input  [8:0]  addr_imem_host,   
    input  [31:0] imem_data,        

    input         take_branch,
    input  [8:0]  branch_target,  
    input  [1:0]  branch_thread,
    
    output [31:0] instruction_out, 
    output [8:0]  pc,
    output [1:0]  curr_thread
);
    //TWO IF STAGES ARE NECESSARY FOR THE MULTITHREADED APPROACH!
    // >>>> IMEM BLOCK CANNOT EASILY "THREAD SWITCH" AND REQUIRES A 1-CYCLE LATENCY
    
    //introduce buffer for BRANCH DELAY SLOT. this was the critical path in the  single thread
    reg        buf_take_branch; 
    reg [8:0]  buf_target;
    reg [1:0]  buf_thread;

    always @(posedge clk) begin
        if (rst) begin
            buf_take_branch <= 1'b0;
            buf_target      <= 9'b0;
            buf_thread      <= 2'b00;
        end else begin
            // EX --> BRANCH REGISTER IN IF1
            buf_take_branch <= take_branch;
            buf_target      <= branch_target;
            buf_thread      <= branch_thread;
        end
    end    
    
    reg [8:0] pc_array [3:0]; 
    reg [1:0] if1_thread;     // The thread currently being fetched (IF1)

    // Thread Rotation Counter
    always @(posedge clk) begin
        if (rst) begin
            if1_thread <= 2'b00;
				pc_array[0] <= 9'b0; pc_array[1] <= 9'b0;
            pc_array[2] <= 9'b0; pc_array[3] <= 9'b0;
        end 
        else if (!write_to_imem) begin
            if1_thread <= if1_thread + 1;
				
            pc_array[if1_thread] <= pc_array[if1_thread] + 1;

            // Apply branch update from the BUFFER (1 cycle late, but still early enough!)
            if (buf_take_branch) begin
                pc_array[buf_thread] <= buf_target;
            end
        end
    end

    // Instruction Memory Access (Sync Read starts here)
    wire [8:0] imem_addr = write_to_imem ? addr_imem_host : pc_array[if1_thread];
    wire [31:0] instruction_raw;

    mem32bit512 imem_blk (
        .addr(imem_addr),
        .clk(clk),
        .din(imem_data),
        .dout(instruction_raw),     
        .we(write_to_imem)      
    );

    // IF2. NO STAGE REGISTER: WE'RE ALL JUST WAITING FOR THE SLOW ASS IMEM TO FINISH UPDATING ITSELF
    reg [1:0] if2_thread;
    reg [8:0] if2_pc;

    always @(posedge clk) begin
        if (rst) begin
            if2_thread <= 2'b00;
            if2_pc     <= 9'b0;
        end else begin
            if2_thread <= if1_thread;
            if2_pc     <= pc_array[if1_thread];
        end
    end

    // housekeeping for pipeline_pseudoARM
    assign instruction_out = instruction_raw;
    assign pc          = if2_pc;
    assign curr_thread = if2_thread;

endmodule