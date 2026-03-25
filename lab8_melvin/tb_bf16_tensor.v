`timescale 1ns/1ps

module tb_bf16_tensor;

reg         clk, rst;
reg         cmd_valid;
wire        cmd_ready;

reg  [5:0]  opcode;
reg  [63:0] r1data, r2data, rd_data;
wire [63:0] tensor_out;
wire        tensor_done;

bf16_tensor_2 dut (
    .clk         (clk),
    .rst         (rst),
    .cmd_valid   (cmd_valid),
    .cmd_ready   (cmd_ready),
    .opcode      (opcode),
    .r1data      (r1data),
    .r2data      (r2data),
    .rd_data     (rd_data),
    .tensor_out  (tensor_out),
    .tensor_done (tensor_done)
);

initial clk = 0;
always #5 clk = ~clk;

localparam [15:0] F1P0   = 16'h3F80;
localparam [15:0] F2P0   = 16'h4000;
localparam [15:0] F0P5   = 16'h3F00;
localparam [15:0] FN1P0  = 16'hBF80;
localparam [15:0] F16P0  = 16'h4180;
localparam [15:0] F32P0  = 16'h4200;
localparam [15:0] F128P0 = 16'h4300;
localparam [15:0] F256P0 = 16'h4380;
localparam [15:0] F512P0 = 16'h4400;

task automatic issue_cmd;
    input [5:0]  op;
    input [63:0] a;
    input [63:0] b;
    input [63:0] c;
    begin
        // wait until the unit can accept a command
        while (!cmd_ready) @(posedge clk);

        opcode    = op;
        r1data    = a;
        r2data    = b;
        rd_data   = c;
        cmd_valid = 1'b1;

        @(posedge clk);
        cmd_valid = 1'b0;
    end
endtask

task automatic wait_done;
    begin
        while (!tensor_done) @(posedge clk);
        #1; // allow registered outputs to settle after the clock edge
    end
endtask

task automatic check_result;
    input [256*8-1:0] label;
    input [63:0]      expect;
    begin
        $display("%0s expect=%h got=%h %s",
                 label, expect, tensor_out,
                 (tensor_out == expect) ? "PASS" : "FAIL");
    end
endtask

initial begin
    rst       = 1'b1;
    cmd_valid = 1'b0;
    opcode    = 6'h00;
    r1data    = 64'h0;
    r2data    = 64'h0;
    rd_data   = 64'h0;

    repeat(5) @(posedge clk);
    rst = 1'b0;

    // VADD: 128.0 + 128.0 = 256.0
    issue_cmd(6'h06, {4{F128P0}}, {4{F128P0}}, 64'h0);
    wait_done;
    check_result("VADD 128+128   ", {4{F256P0}});

    // VADD: 256.0 + 256.0 = 512.0
    issue_cmd(6'h06, {4{F256P0}}, {4{F256P0}}, 64'h0);
    wait_done;
    check_result("VADD 256+256   ", {4{F512P0}});

    // VADD: 16.0 + 16.0 = 32.0
    issue_cmd(6'h06, {4{F16P0}}, {4{F16P0}}, 64'h0);
    wait_done;
    check_result("VADD 16+16     ", {4{F32P0}});

    // VADD: 1.0 + 1.0 = 2.0
    issue_cmd(6'h06, {4{F1P0}}, {4{F1P0}}, 64'h0);
    wait_done;
    check_result("VADD 1+1       ", {4{F2P0}});

    // VADD: 1.0 + 0.5 = 1.5
    issue_cmd(6'h06, {4{F1P0}}, {4{F0P5}}, 64'h0);
    wait_done;
    check_result("VADD 1+0.5     ", {4{16'h3FC0}});

    // VADD: 1.0 + (-1.0) = 0.0
    issue_cmd(6'h06, {4{F1P0}}, {4{FN1P0}}, 64'h0);
    wait_done;
    check_result("VADD 1-1       ", 64'h0);

    // VSUB: 1.0 - 0.5 = 0.5
    issue_cmd(6'h07, {4{F1P0}}, {4{F0P5}}, 64'h0);
    wait_done;
    check_result("VSUB 1-0.5     ", {4{F0P5}});

    // VMUL: 2.0 * 2.0 = 4.0
    issue_cmd(6'h08, {4{F2P0}}, {4{F2P0}}, 64'h0);
    wait_done;
    check_result("VMUL 2*2       ", {4{16'h4080}}); // 4.0 in BF16

    // VMAC: 1.0 * 2.0 + 1.0 = 3.0
    issue_cmd(6'h09, {4{F1P0}}, {4{F2P0}}, {4{F1P0}});
    wait_done;
    check_result("VMAC 1*2+1     ", {4{16'h4040}}); // 3.0 in BF16

    // VRELU: ReLU of negative values => 0
    issue_cmd(6'h0A, {4{FN1P0}}, {4{F1P0}}, 64'h0);
    wait_done;
    check_result("VRELU          ", 64'h0);

    $stop;
end

endmodule