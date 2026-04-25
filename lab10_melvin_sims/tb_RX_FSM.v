`timescale 1ns / 1ps
module tb_RX_FSM;

// Inputs
reg clk;
reg reset;
reg [63:0] in_data;
reg [7:0] in_ctrl;
reg in_wr;
reg pipeline_done;

// Outputs
wire [7:0] rx_pl_addr;
wire [63:0] rx_pl_wdata;
wire rx_pl_we;
wire rx_fsm_busy;
wire in_rdy;

RX_FSM uut (
   .clk(clk),
   .reset(reset),
   .in_data(in_data),    
   .in_ctrl(in_ctrl),      
   .in_wr(in_wr),        
   .pipeline_done(pipeline_done),

   .rx_pl_addr(rx_pl_addr),   
   .rx_pl_wdata(rx_pl_wdata),  
   .rx_pl_we(rx_pl_we),      
   .rx_fsm_busy(rx_fsm_busy),
   .in_rdy(in_rdy)
);

task send_packet;
    begin
        @(posedge clk);
        // Start of Packet (SOP)
        in_ctrl = 8'hFF;
        in_data = 64'hDEAD_DEAD_DEAD_DEAD;

        // 4-Word Payload
        @(posedge clk);
        in_ctrl = 8'h00;
        in_data = 64'h1111_1111_1111_1111;
        @(posedge clk);
        in_ctrl = 8'h00;
        in_data = 64'h2222_2222_2222_2222;
        @(posedge clk);
        in_ctrl = 8'h00;
        in_data = 64'h3333_3333_3333_3333;
        @(posedge clk);
        in_ctrl = 8'h00;
        in_data = 64'h4444_4444_4444_4444;
        @(posedge clk);
        // End of Packet (EOP)
        in_ctrl = 8'hFF;
        in_data = 64'hDEAD_DEAD_DEAD_DEAD;
    end
endtask

initial clk = 1'b0;
always #8 clk = ~clk;

initial begin
    // Reset
    reset = 1'b1;
    in_wr = 1'b1;
    pipeline_done = 1;
    repeat (5) @(posedge clk);
    reset = 1'b0;

    // Send packet 1
    send_packet;
    pipeline_done = 1;
    repeat (5) @(posedge clk);

    // Send packet 2
    send_packet;
    pipeline_done = 0;
    repeat (5) @(posedge clk);


    // Send packet 3 -- Pipeline is not done. Should stall
    send_packet;
    repeat (5) @(posedge clk);
    pipeline_done = 1;  // Pipeline is done. Should proceed

    // Send packet 4
    send_packet;
    repeat (5) @(posedge clk);

    // Send packet 5
    send_packet;
    repeat (5) @(posedge clk);
    $stop;


end

endmodule