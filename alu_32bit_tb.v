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
        
        // ADD
        A = 32'd15; B = 32'd10; Op = 4'b0000; shift = 0;
        #10;
        
        // SUB
        A = 32'd15; B = 32'd10; Op = 4'b0001; shift = 0;
        #10;
        
        // AND
        A = 32'hF0F0F0F0; B = 32'h0F0F0F0F; Op = 4'b0010; shift = 0;
        #10;
        
        // OR
        A = 32'hAAAA0000; B = 32'h5555FFFF; Op = 4'b0011; shift = 0;
        #10;
        
        // SHIFT LEFT
        A = 32'd16; B = 32'd0; Op = 4'b0100; shift = 5'd3;
        #10;
        
        // SHIFT RIGHT
        A = 32'd128; B = 32'd0; Op = 4'b0101; shift = 5'd2;
        #10;
        
        // XNOR
        A = 32'hF0F0F0F0; B = 32'hF0F0F0F0; Op = 4'b0110; shift = 0;
        #10;
        
        // EQUAL
        A = 32'd100; B = 32'd100; Op = 4'b0111; shift = 0;
        #10;
        
        // LESS THAN
        A = 32'd50; B = 32'd100; Op = 4'b1000; shift = 0;
        #10;
        
        // GREATER THAN
        A = 32'd150; B = 32'd100; Op = 4'b1001; shift = 0;
        #10;
        
        // XOR
        A = 32'hAAAAAAAA; B = 32'h55555555; Op = 4'b1010; shift = 0;
        #10;
        
        // SHIFT-THEN-COMPARE returns 1
        A = 32'd8; B = 32'd64; Op = 4'b1011; shift = 5'd3;
        #10;
        
        // SHIFT-THEN-COMPARE returns 0
        A = 32'd8; B = 32'd65; Op = 4'b1011; shift = 5'd3;
        #10;
        
        // SUBSTRING COMPARE returns 1
        A = 32'hABCD1234; B = 32'h56781234; Op = 4'b1100; shift = 0;
        #10;
        
        // SUBSTRING COMPARE returns 0
        A = 32'hABCD1234; B = 32'h567812FF; Op = 4'b1100; shift = 0;
        #10;
        
        $finish;
    end
endmodule
