`timescale 1ns/1ps
module tb_mant_mul;

reg        clk = 0;
reg        rst = 0;
reg  [7:0] a, b;
wire [15:0] p;

mant_mul_test dut (
    .clk     (clk),
    .rst     (rst),
    .mant_a  (a),
    .mant_b  (b),
    .product (p)
);

always #4 clk = ~clk;  // 100 MHz

initial begin
    $display("--- mant_mul latency test ---");
    rst = 1; #30; rst = 0;   // hold reset longer
    #10;                      // wait one full cycle after reset

    // test 1: 0xFF * 0xFF = 0xFE01
    a = 8'hFF; b = 8'hFF;
    #1; $display("t=%0t: inputs applied, p=%h (expect not yet valid)", $time, p);
    @(posedge clk); #1;
    $display("t=%0t: 1 cycle after, p=%h (expect FE01)", $time, p);

	#200

    // test 2: 0x80 * 0x80 = 0x4000
    a = 8'h80; b = 8'h80;
    @(posedge clk); #1;
    $display("t=%0t: 1 cycle after, p=%h (expect 4000)", $time, p);

	#200

    // test 3: 0x80 * 0x81
    a = 8'h80; b = 8'h81;
    @(posedge clk); #1;
    $display("t=%0t: 1 cycle after, p=%h (expect 4080)", $time, p);

    #200; $stop;
end

endmodule