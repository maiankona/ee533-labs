module alu_32bit(
    input [31:0] A,
    input [31:0] B,
    input [3:0]  Op,
    input [4:0]  shift,
    output[31:0] Out,
    output   zero,
    output   negative,
    output   overflow,
    output   carry
);
	assign negative = Out[31]; //for negative results

    // inside ALU combinational block
    reg [31:0] alu_out_r;
    reg       nflag, oflag, cflag;

    always @(*) begin
    // default
    alu_out_r = 32'b0;
    oflag = 1'b0;
    cflag = 1'b0;

    case (Op)
        4'b0000: begin // ADD
        {cflag, alu_out_r} = {1'b0, A} + {1'b0, B}; // capture carry in cflag
        // compute overflow for signed add:
        oflag = (~A[31] & ~B[31] & alu_out_r[31]) | (A[31] & B[31] & ~alu_out_r[31]);
        end

        4'b0001: begin // SUB = A - B
        {cflag, alu_out_r} = {1'b0, A} - {1'b0, B};
        // signed overflow for subtraction:
        oflag = (A[31] & ~B[31] & ~alu_out_r[31]) | (~A[31] & B[31] & alu_out_r[31]);
        end

        4'b0010: alu_out_r = A & B;
        4'b0011: alu_out_r = A | B;
        4'b0100: alu_out_r = A ^ B;

        4'b0101: begin // SLT (signed)
        // set to 1 if a < b (signed)
        // one robust way: signed compare using subtraction overflow behavior:
        // compute (a - b) and check sign XOR overflow
        // but simpler: convert to signed and compare
        alu_out_r = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;
        end

        4'b0110: alu_out_r = A << B[4:0]; // SLL
        4'b0111: alu_out_r = A >> B[4:0]; // SRL (logical)
        4'b1000: alu_out_r = $signed(A) >>> B[4:0]; // SRA (arith)

        default: alu_out_r = 32'b0;
    endcase

    end

    // assign outputs
    assign Out = alu_out_r;
	 assign zero = (alu_out_r == 32'b0); // High if result is 0
    assign overflow = oflag;
    assign carry = cflag;
endmodule
