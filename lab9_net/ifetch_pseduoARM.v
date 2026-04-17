`timescale 1ns / 1ps

module ifetch_arm (
    input         clk,
    input         rst,
    input         cpu_start,          // one-cycle pulse: releases PC from idle
    input         stall,              // freeze PC / IF2 when MEM arbiter holds the core
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

    // IF2 gives a 1-cycle IMEM read latency. Multithread round-robin is disabled: only
    // thread 0 is used (if1_thread tied to 2'b00).

    // cpu_running: set on cpu_start pulse, holds high until rst
    // PC does not advance until this is set
    reg cpu_running;

    always @(posedge clk) begin
        if (rst)
            cpu_running <= 1'b0;
        else if (cpu_start)
            cpu_running <= 1'b1;
    end

    // Branch delay slot buffer
    reg        buf_take_branch; 
    reg [8:0]  buf_target;
    reg [1:0]  buf_thread;

    always @(posedge clk) begin
        if (rst) begin
            buf_take_branch <= 1'b0;
            buf_target      <= 9'b0;
            buf_thread      <= 2'b00;
        end else begin
            buf_take_branch <= take_branch;
            buf_target      <= branch_target;
            buf_thread      <= branch_thread;
        end
    end    
    
    reg [8:0] pc_array [3:0]; 
    reg [1:0] if1_thread;

    always @(posedge clk) begin
        if (rst) begin
            if1_thread    <= 2'b00;
            pc_array[0]   <= 9'b0;
            pc_array[1]   <= 9'b0;
            pc_array[2]   <= 9'b0;
            pc_array[3]   <= 9'b0;
        end else if (!write_to_imem && cpu_running && !stall) begin
            // if1_thread <= if1_thread + 1; // enable for multithreading
            if1_thread <= 2'b00;

            pc_array[if1_thread] <= pc_array[if1_thread] + 1;

            // Apply branch update from buffer (1 cycle late, still early enough)
            if (buf_take_branch) begin
                pc_array[buf_thread] <= buf_target;
            end
        end
    end

    // Instruction Memory Access
    wire [8:0] imem_addr = write_to_imem ? addr_imem_host : pc_array[if1_thread];
    wire [31:0] instruction_raw;

    mem32bit512 imem_blk (
        .addr(imem_addr),
        .clk(clk),
        .din(imem_data),
        .dout(instruction_raw),     
        .we(write_to_imem)      
    );

    // IF2
    reg [1:0] if2_thread;
    reg [8:0] if2_pc;

    always @(posedge clk) begin
        if (rst) begin
            if2_thread <= 2'b00;
            if2_pc     <= 9'b0;
        end else if (stall) begin
            if2_thread <= if2_thread;
            if2_pc     <= if2_pc;
        end else begin
            if2_thread <= if1_thread;
            if2_pc     <= pc_array[if1_thread];
        end
    end

    assign instruction_out = instruction_raw;
    assign pc              = if2_pc;
    assign curr_thread     = if2_thread;

endmodule