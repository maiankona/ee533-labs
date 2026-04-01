`timescale 1ns / 1ps


module cosine_distance_tb;

    parameter IMEM_FILE = "cosine_distance_imem.txt";
    parameter DMEM_FILE = "cosine_distance_dmem.txt";

    reg clk;
    reg rst;
    reg write_to_imem;
    reg read_req_imem;
    reg write_to_dmem;
    reg read_req_dmem;
    reg [8:0]  addr_imem_host;
    reg [31:0] data_imem_host;
    reg [7:0]  addr_dmem_host;
    reg [31:0] data_dmem_host;
    reg gpu_mode;

    wire [31:0] data_out_imem;
    wire [63:0] data_out_dmem;
    wire [63:0] tensor_out_intercept;

    pipeline_backup gpu (
        .clk                 (clk),
        .rst                 (rst),
        .write_to_imem       (write_to_imem),
        .read_req_imem       (read_req_imem),
        .addr_imem_host      (addr_imem_host),
        .data_imem_host      (data_imem_host),
        .data_out_imem       (data_out_imem),
        .write_to_dmem       (write_to_dmem),
        .read_req_dmem       (read_req_dmem),
        .addr_dmem_host      (addr_dmem_host),
        .data_dmem_host      (data_dmem_host),
        .gpu_mode            (gpu_mode),
        .data_out_dmem       (data_out_dmem),
        .tensor_out_intercept(tensor_out_intercept)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    // Sequential host writes: one 32-bit opcode per non-empty line
    task load_imem_from_file;
        integer fd;
        integer st;
        integer cnt;
        reg [31:0] word;
        reg [8:0]  idx;
    begin
        fd = $fopen(IMEM_FILE, "r");
        write_to_imem = 1;
        idx = 0;
        cnt = 0;
        st = $fscanf(fd, "%h", word);
        while (st == 1) begin
            addr_imem_host = idx;
            data_imem_host = word;
            @(posedge clk);
            cnt = cnt + 1;
            idx = idx + 9'd1;
            st = $fscanf(fd, "%h", word);
        end
        write_to_imem = 0;
        @(posedge clk);
        $fclose(fd);
    end
    endtask

    // One 32-bit write per line: addr data (hex)
    task load_dmem_from_file;
        integer fd;
        integer st;
        integer cnt;
        reg [7:0] ab;
        reg [31:0] dw;
    begin
        fd = $fopen(DMEM_FILE, "r");
        cnt = 0;
        st = $fscanf(fd, "%h %h", ab, dw);
        while (st == 2) begin
            addr_dmem_host = ab;
            data_dmem_host = dw;
            write_to_dmem = 1;
            @(posedge clk);
            write_to_dmem = 0;
            @(posedge clk);
            cnt = cnt + 1;
            st = $fscanf(fd, "%h %h", ab, dw);
        end
        $fclose(fd);
    end
    endtask
    initial begin
        rst = 1;
        write_to_imem = 0;
        read_req_imem = 0;
        write_to_dmem = 0;
        read_req_dmem = 0;
        addr_imem_host = 0;
        data_imem_host = 0;
        addr_dmem_host = 0;
        data_dmem_host = 0;
        gpu_mode = 0;

        #100;
        rst = 0;

        gpu_mode = 1;
        @(posedge clk);

        load_dmem_from_file;
        load_imem_from_file;

        repeat (3000) @(posedge clk);

        @(posedge clk);
        addr_dmem_host = 8'hC0;
        read_req_dmem = 1;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        read_req_dmem = 0;
        #1;

        // expect ~0x0000000000003F80 = BF16 1.0 lane0
        if (data_out_dmem[15:0] == 16'h3F80 && data_out_dmem[63:16] == 48'h0)
            $display("  PASS");
        else
            $display("  FAIL");

        #100;
        $display("\n========================================\n");
        $stop;
    end

endmodule

