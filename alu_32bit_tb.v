module alu_32bit_tb;
    reg clk, reset;
    reg [31:0] A, B;
    reg [3:0] Op;
    reg [4:0] shift;
    wire [31:0] Out;
    
    alu_32bit uut (
        .clk(clk),
        .reset(reset),
        .A(A),
        .B(B),
        .Op(Op),
        .shift(shift),
        .Out(Out)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        reset = 1;
        A = 0; B = 0; Op = 0; shift = 0;
        #15 reset = 0;
        
        A = 32'd15; B = 32'd10; Op = 4'b0000; shift = 0;
        #10;
        
        A = 32'd15; B = 32'd10; Op = 4'b0001; shift = 0;
        #10;
        
        A = 32'hF0F0F0F0; B = 32'h0F0F0F0F; Op = 4'b0010; shift = 0;
        #10;
        
        A = 32'hAAAA0000; B = 32'h5555FFFF; Op = 4'b0011; shift = 0;
        #20;
        
        A = 32'd16; B = 32'd0; Op = 4'b0100; shift = 5'd3;
        #20;
        
        A = 32'd128; B = 32'd0; Op = 4'b0101; shift = 5'd2;
        #20;
        
        A = 32'hF0F0F0F0; B = 32'hF0F0F0F0; Op = 4'b0110; shift = 0;
        #10;
        
        A = 32'd100; B = 32'd100; Op = 4'b0111; shift = 0;
        #10;
        
        A = 32'd50; B = 32'd100; Op = 4'b1000; shift = 0;
        #10;
        
        A = 32'd150; B = 32'd100; Op = 4'b1001; shift = 0;
        #10;
        
        $finish;
    end
endmodule
