`timescale 1ns / 1ps

module pipeline_datapath_skeleton(
    input clk,
    input rst,
    input  [31:0] mem_addr_reg,
    input  [31:0] mem_cmd_reg,
    input  [31:0] mem_data_write_reg,
    output reg [31:0] mem_data_read_reg,
    output reg [8:0]  pc_reg_out
    );

    // ======================================================
    // Interface Input Registers (Timing Boundary)
    // ======================================================
    reg [31:0] mem_addr_in;
    reg [31:0] mem_cmd_in;
    reg [31:0] mem_data_write_in;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mem_addr_in       <= 32'b0;
            mem_cmd_in        <= 32'b0;
            mem_data_write_in <= 32'b0;
        end
        else begin
            mem_addr_in       <= mem_addr_reg;
            mem_cmd_in        <= mem_cmd_reg;
            mem_data_write_in <= mem_data_write_reg;
        end
    end

    // ======================================================
    // Internal Output Register
    // ======================================================
    reg [31:0] mem_data_read_internal;

    always @(posedge clk or posedge rst) begin
        if (rst)
            mem_data_read_reg <= 32'b0;
        else
            mem_data_read_reg <= mem_data_read_internal;
    end

    // ======================================================
    // Original Design Below (unchanged except _in usage)
    // ======================================================

    reg [31:0] prog_data_mem_addr;
    reg [31:0] prog_instr_mem_addr;
    reg [31:0] prog_data_mem_in;
    reg [31:0] prog_instr_mem_in;

    reg [31:0] pc;
    reg instr_wr_en_prev;
    reg instr_wr_en_latched;
    reg instr_wr_pulse_if_id;
    reg exec_mode_delay;
    reg cpu_enable;
    reg [31:0] if_id;

    reg [31:0] ex_me_r1, ex_me_r2;
    reg        ex_me_WRegEn, ex_me_WMemEn;
    reg [2:0]  ex_me_WR1;

    reg mem_wb_WMemEn;
    reg [2:0] mem_wb_WR1;
    reg [63:0] wb_data;
    reg mem_wb_WRegEn;

    reg instr_wr_pulse_d;
    reg prog_valid;
    reg instr_wr_we_reg;

    wire instr_wr_en;
    wire data_wr_en;
    wire local_WMemEn;
    wire program_mode;
    wire exec_mode;
    wire instr_wr_pulse;
    wire instr_wr_pulse_enable;
    wire [31:0] imem_addr;
    wire CPU_halt;

    wire [31:0] instr_mem_out;
    wire [31:0] instr_mem_in;
    wire [31:0] data_mem_in;
    wire [31:0] command_in;
    wire [31:0] local_mem_data;
    wire [31:0] local_mem_addr;

    assign command_in   = mem_cmd_in;
    assign instr_wr_en  = command_in[5];
    assign data_wr_en   = command_in[6];
    assign CPU_halt     = ~mem_cmd_in[7];
    assign instr_mem_in = mem_data_write_in;
    assign data_mem_in  = mem_data_write_in;

    assign imem_addr = (instr_wr_we_reg) ? prog_instr_mem_addr : pc;

    assign local_WMemEn = data_wr_en ? data_wr_en : ex_me_WMemEn;
    assign local_mem_data = prog_instr_mem_in;
    assign local_mem_addr = prog_data_mem_addr;

    assign program_mode = instr_wr_pulse_d;
    assign exec_mode = ~program_mode;

    assign instr_wr_pulse = instr_wr_en_latched & ~instr_wr_en_prev;
    assign instr_wr_pulse_enable = instr_wr_pulse;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc <= 32'b0;
            instr_wr_en_latched <= 1'b0;
            instr_wr_en_prev <= 1'b0;
            prog_data_mem_addr <= 32'b0;
            prog_instr_mem_addr <= 32'b0;
            prog_data_mem_in <= 32'b0;
            prog_instr_mem_in <= 32'b0;
            instr_wr_pulse_if_id <= 1'b0;
            exec_mode_delay <= 1'b0;
            instr_wr_pulse_d <= 1'b0;
            cpu_enable <= 1'b0;
            prog_valid <= 1'b0;
            instr_wr_we_reg <= 1'b0;
            mem_data_read_internal <= 32'b0;
        end
        else begin
            if (~CPU_halt)
                cpu_enable <= 1'b1;

            instr_wr_en_latched <= instr_wr_en;
            instr_wr_en_prev <= instr_wr_en_latched;
            exec_mode_delay <= exec_mode;
            instr_wr_pulse_d <= instr_wr_pulse_enable;

            if (instr_wr_en && !cpu_enable) begin
                prog_instr_mem_addr <= mem_addr_in;
                prog_instr_mem_in   <= instr_mem_in;
                prog_valid <= 1'b1;
            end
            else begin
                if (!instr_wr_we_reg)
                    prog_valid <= 1'b0;
            end

            instr_wr_we_reg <= prog_valid;

            if (data_wr_en) begin
                prog_data_mem_addr <= mem_addr_in;
                prog_data_mem_in <= data_mem_in;
            end
            else begin
                prog_data_mem_in <= ex_me_r2;
                prog_data_mem_addr <= ex_me_r1[7:0];
            end

            if (exec_mode) begin
                pc <= pc + 1;
                pc_reg_out <= pc;
                mem_data_read_internal <= if_id;
            end
        end
    end

    mem32bit512Dual imem_blk (
        .addr(imem_addr),
        .clk(clk),
        .din(prog_instr_mem_in),
        .dout(instr_mem_out),
        .we(instr_wr_we_reg)
    );

    always @(posedge clk or posedge rst)
        if (rst)
            if_id <= 0;
        else if (exec_mode_delay)
            if_id <= instr_mem_out;

    wire [31:0] rf_r1, rf_r2;
    wire [3:0]  alu_ctrl;
    wire [4:0]  id_shift;
    wire        WRegEn, WMemEn;
    wire [2:0]  WR1;

    assign WMemEn   = if_id[31];
    assign WRegEn   = if_id[30];
    assign WR1      = if_id[23:21];
    assign alu_ctrl = if_id[20:17];
    assign id_shift = if_id[10:6];

    registerFile32 rf_inst (
        .clk    (clk),
        .clr    (rst),
        .r0addr (if_id[29:27]),
        .r1addr (if_id[26:24]),
        .waddr  (mem_wb_WR1),
        .wdata  (wb_data),
        .wena   (mem_wb_WRegEn),
        .r0data (rf_r1),
        .r1data (rf_r2)
    );

    reg [31:0] id_ex_r1, id_ex_r2;
    reg [3:0]  id_ex_alu_ctrl;
    reg [4:0]  id_ex_shift;
    reg        id_ex_WRegEn, id_ex_WMemEn;
    reg [2:0]  id_ex_WR1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            id_ex_WRegEn <= 0;
            id_ex_WMemEn <= 0;
        end
        else if (exec_mode) begin
            id_ex_r1       <= rf_r1;
            id_ex_r2       <= rf_r2;
            id_ex_alu_ctrl <= alu_ctrl;
            id_ex_shift    <= id_shift;
            id_ex_WRegEn   <= WRegEn;
            id_ex_WMemEn   <= WMemEn;
            id_ex_WR1      <= WR1;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ex_me_WRegEn <= 0;
            ex_me_WMemEn <= 0;
        end
        else if (exec_mode) begin
            ex_me_r1 <= id_ex_r1;
            ex_me_r2 <= id_ex_r2;
            ex_me_WRegEn <= id_ex_WRegEn;
            ex_me_WMemEn <= id_ex_WMemEn;
            ex_me_WR1 <= id_ex_WR1;
        end
    end

    wire [63:0] dme_dout;

    mem64bit256 dmem_blk (
        .clka(clk),
        .wea(local_WMemEn),
        .addra(local_mem_addr),
        .dina({32'b0,local_mem_data}),
        .clkb(clk),
        .addrb(8'b0),
        .doutb(dme_dout)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mem_wb_WMemEn <= 0;
            mem_wb_WR1 <= 0;
            mem_wb_WRegEn <= 0;
            wb_data <= 0;
        end
        else if (exec_mode) begin
            mem_wb_WMemEn <= ex_me_WMemEn;
            mem_wb_WR1 <= ex_me_WR1;
            mem_wb_WRegEn <= ex_me_WRegEn;
            wb_data <= dme_dout[31:0];
        end
    end

endmodule