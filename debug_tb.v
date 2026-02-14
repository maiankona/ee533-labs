`timescale 1ns/1ps
module pipeline_datapath_tb;
    reg clk;
    reg rst;

    // instantiate DUT (your skeleton)
    pipeline_datapath_skeleton uut (
        .clk(clk),
        .rst(rst)
    );

    // clock gen (10 ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // reset / runtime control
    initial begin
        rst = 1;
        #20;
        rst = 0;
        // run for 1000 ns (100 cycles)
        #980;
        $display("Sim end");
        $finish;
    end

    // VCD dump (if supported)
    initial begin
        $dumpfile("pipeline_sim.vcd");
        $dumpvars(0, pipeline_datapath_tb);
    end

    // monitor internal signals via hierarchical names in the skeleton
    initial begin
        $timeformat(-9, 1, " ns", 7);
        $display("time rst clk pc instruction rf_r1 rf_r2 ex_me_result me_wb_WRegEn wb_data dmem_low32");
        $monitor("%0t   %b   %b   %h   %h   %h   %h    %b    %h    %h",
                 $time,
                 rst,
                 clk,
                 uut.pc,
                 uut.instruction,
                 uut.rf_r1,
                 uut.rf_r2,
                 uut.ex_me_result,
                 uut.me_wb_WRegEn,
                 uut.wb_data,
                 uut.dme_dout[31:0] // lower 32 bits of D-MEM read (adjust if names differ)
                 );
    end
endmodule