`timescale 1ns / 1ps

module ifetch (
    input         clk,
    input         rst,
    input         cpu_start,        // one-cycle pulse: releases PC from idle
    input         write_to_imem,
    input  [8:0]  addr_imem_host,
    input  [31:0] imem_data,
    input         take_branch,
    input  [8:0]  branch_target,
    input  [1:0]  branch_thread,    // unused in single-thread mode

    output [31:0] instruction_out,
    output [8:0]  pc,
    output [1:0]  curr_thread       // always 0 in single-thread mode
);

    // cpu_running: set on cpu_start pulse, holds high until rst
    // PC does not advance until this is set
    reg cpu_running = 0;
    always @(posedge clk) begin
        if (rst)
            cpu_running <= 1'b0;
        else if (cpu_start)
            cpu_running <= 1'b1;
    end

    // Branch delay slot buffer
    reg        buf_take_branch;
    reg [8:0]  buf_target;
    always @(posedge clk) begin
        if (rst) begin
            buf_take_branch <= 1'b0;
            buf_target      <= 9'b0;
        end else begin
            buf_take_branch <= take_branch;
            buf_target      <= branch_target;
        end
    end

    // Single PC register
    reg [8:0] pc_reg;
    always @(posedge clk) begin
        if (rst) begin
            pc_reg <= 9'b0;
        end else if (cpu_running) begin
            if (buf_take_branch)
                pc_reg <= buf_target;
            else
                pc_reg <= pc_reg + 1;
        end
    end

    // Instruction Memory
    wire [8:0]  imem_addr = write_to_imem ? addr_imem_host : pc_reg;
    wire [31:0] instruction_raw;

    mem32bit512 imem_blk (
        .addr(imem_addr),
        .clk(clk),
        .din(imem_data),
        .dout(instruction_raw),
        .we(write_to_imem)
    );

    // IF2 - one cycle delay for BRAM registered read
    reg [8:0] if2_pc;
    always @(posedge clk) begin
        if (rst)
            if2_pc <= 9'b0;
        else
            if2_pc <= pc_reg;
    end

    assign instruction_out = instruction_raw;
    assign pc              = if2_pc;
    assign curr_thread     = 2'b00;   // always thread 0

endmodule