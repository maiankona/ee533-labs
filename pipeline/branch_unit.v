module branch_unit(
    input [3:0] cond,         // Condition code from instruction
    input [3:0] flags,        // Current flags: {N, Z, C, V}
    input Branch,             // Branch signal from control
    output reg PCSrc          // Take branch?
);

wire N = flags[3];  // Negative
wire Z = flags[2];  // Zero
wire C = flags[1];  // Carry
wire V = flags[0];  // Overflow

always @(*) begin
    if (Branch) begin
        case (cond)
            4'b0000: PCSrc = Z;              // EQ (equal)
            4'b0001: PCSrc = ~Z;             // NE (not equal)
            4'b0010: PCSrc = C;              // CS/HS (carry set)
            4'b0011: PCSrc = ~C;             // CC/LO (carry clear)
            4'b0100: PCSrc = N;              // MI (minus/negative)
            4'b0101: PCSrc = ~N;             // PL (plus/positive)
            4'b0110: PCSrc = V;              // VS (overflow)
            4'b0111: PCSrc = ~V;             // VC (no overflow)
            4'b1000: PCSrc = C & ~Z;         // HI (unsigned higher)
            4'b1001: PCSrc = ~C | Z;         // LS (unsigned lower/same)
            4'b1010: PCSrc = (N == V);       // GE (signed >=)
            4'b1011: PCSrc = (N != V);       // LT (signed <)
            4'b1100: PCSrc = ~Z & (N == V);  // GT (signed >)
            4'b1101: PCSrc = Z | (N != V);   // LE (signed <=)
            4'b1110: PCSrc = 1;              // AL (always)
            default: PCSrc = 0;
        endcase
    end
    else begin
        PCSrc = 0;
    end
end

endmodule
