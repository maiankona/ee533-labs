`timescale 1ns / 1ps

module pipeline_tb;
    // 1. Inputs to the Design under Test (DUT)
    reg clk;
    reg rst;

    // 2. Instantiate the Skeleton [cite: 56]
    pipeline_datapath_skeleton uut (
        .clk(clk),
        .rst(rst)
    );

    // 3. Clock Generation (100MHz example)
    always #5 clk = ~clk;

    initial begin
        // 4. Initialize Signals
        clk = 0;
        rst = 1;

        // Hold reset for a few cycles
        #20;
        rst = 0;

        // 5. Run simulation for a set time
        #1000;
        $stop;
    end
endmodule