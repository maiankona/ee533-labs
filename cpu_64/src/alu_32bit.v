module alu_64bit(
    input [63:0] A,
    input [63:0] B,
    input [3:0]  Op,
    //input [4:0]  shift, TEMPORARILY REMOVING SUPPORT FOR THIS
    output[63:0] Out,
    output   zero,
    output   negative//,
    //output   overflow,
    //output   carry
);
	assign negative = Out[31]; //for negative results

    // inside ALU combinational block
    reg [63:0] alu_out;
    //reg       nflag, //oflag, cflag;

    always @(*) begin
    // default
    alu_out = 64'b0;
    //oflag = 1'b0;
    //cflag = 1'b0;

    case (Op)
        4'b0000: begin // ADD
        alu_out = A + B;
		  //{cflag, alu_out_r} = {1'b0, A} + {1'b0, B}; // capture carry in cflag
        // compute overflow for signed add:
        //oflag = (~A[31] & ~B[31] & alu_out_r[31]) | (A[31] & B[31] & ~alu_out_r[31]);
        end

        4'b0001: begin // SUB = A - B
        alu_out = A - B;
		  //{cflag, alu_out_r} = {1'b0, A} - {1'b0, B};
        // signed overflow for subtraction:
        //oflag = (A[31] & ~B[31] & ~alu_out_r[31]) | (~A[31] & B[31] & alu_out_r[31]);
        end

        //4'b0010: alu_out = A & B;
        //4'b0011: alu_out = A | B;
        //4'b0100: alu_out = A ^ B;

        4'b0101: begin // SLT (signed)
        // set to 1 if a < b (signed)
        // one robust way: signed compare using subtraction overflow behavior:
        // compute (a - b) and check sign XOR overflow
        // but simpler: convert to signed and compare
        alu_out = ($signed(A) < $signed(B)) ? 64'd1 : 64'd0;
        end

        //4'b0110: alu_out = A << B[4:0]; // SLL
        //4'b0111: alu_out = A >> B[4:0]; // SRL (logical)
        //4'b1000: alu_out = $signed(A) >>> B[4:0]; // SRA (arith)

        default: alu_out = 64'b0;
    endcase

    end

    // assign outputs
    assign Out = alu_out;
	 assign zero = (alu_out == 64'b0); // High if result is 0
    //assign overflow = oflag;
    //assign carry = cflag;
endmodule
