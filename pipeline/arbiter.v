module arbiter (
    input  wire       clk,
    input  wire       rst,          // Active-high reset
    output reg  [1:0] active_thread // 2-bit thread ID (0–3)
);

    // Round-robin thread selector
    always @(posedge clk or posedge rst) begin
        if (rst)
            active_thread <= 2'b00;       // Start from Thread 0
        else
            active_thread <= active_thread + 2'b01;
            // 2-bit overflow naturally wraps:
            // 00 → 01 → 10 → 11 → 00 → ...
    end

endmodule
