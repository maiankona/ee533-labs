`timescale 1ns / 1ps

module alu_64bit_tb;

    // Inputs
    reg [63:0] A;
    reg [63:0] B;
    reg [3:0]  Op;
    reg [5:0]  shift;

    // Output
    wire [63:0] Out;

    // Instantiate DUT
    alu_64bit uut (
        .A(A),
        .B(B),
        .Op(Op),
        .shift(shift),
        .Out(Out)
    );

    // Helper task for checking results
    integer pass_count;
    integer fail_count;

    task check;
        input [63:0] expected;
        input [127:0] test_name; // 16 chars
        begin
            #1; // let combinational logic settle
            if (Out === expected) begin
                $display("PASS | %-16s | A=%h B=%h shift=%0d Op=%b | Out=%h",
                         test_name, A, B, shift, Op, Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL | %-16s | A=%h B=%h shift=%0d Op=%b | Got=%h Expected=%h",
                         test_name, A, B, shift, Op, Out, expected);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        pass_count = 0;
        fail_count = 0;
        A = 0; B = 0; Op = 0; shift = 0;

        $display("============================================================");
        $display("        64-bit SIMD ALU Testbench (4x16-bit lanes)");
        $display("============================================================");

        // -------------------------------------------------------
        // ADD (Op = 0001)
        // -------------------------------------------------------
        $display("\n--- ADD ---");
        Op = 4'b0001; shift = 0;

        // Simple positive addition per lane
        A = {16'd100, 16'd200, 16'd300, 16'd400};
        B = {16'd1,   16'd2,   16'd3,   16'd4  };
        check({16'd101, 16'd202, 16'd303, 16'd404}, "ADD basic");

        // Addition with zero
        A = {16'd0, 16'd0, 16'd0, 16'd0};
        B = {16'd1000, 16'd2000, 16'd3000, 16'd4000};
        check(B, "ADD zero+B");

        // Signed: negative + positive
        A = {16'hFFFF, 16'hFFFE, 16'hFFFD, 16'hFFFC}; // -1, -2, -3, -4
        B = {16'd1,    16'd2,    16'd3,    16'd4   };
        check(64'd0, "ADD neg+pos=0");

        // Overflow per lane (wraps within 16 bits)
        A = {16'h7FFF, 16'h7FFF, 16'h7FFF, 16'h7FFF};
        B = {16'd1,    16'd1,    16'd1,    16'd1   };
        check({16'h8000, 16'h8000, 16'h8000, 16'h8000}, "ADD overflow");

        // -------------------------------------------------------
        // SUB (Op = 0010)
        // -------------------------------------------------------
        $display("\n--- SUB ---");
        Op = 4'b0010;

        A = {16'd500, 16'd400, 16'd300, 16'd200};
        B = {16'd100, 16'd100, 16'd100, 16'd100};
        check({16'd400, 16'd300, 16'd200, 16'd100}, "SUB basic");

        // Result zero
        A = {16'd42, 16'd42, 16'd42, 16'd42};
        B = {16'd42, 16'd42, 16'd42, 16'd42};
        check(64'd0, "SUB A-A=0");

        // Underflow (negative result)
        A = {16'd0,    16'd0,    16'd0,    16'd0   };
        B = {16'd1,    16'd1,    16'd1,    16'd1   };
        check({16'hFFFF, 16'hFFFF, 16'hFFFF, 16'hFFFF}, "SUB underflow");

        // Mixed lanes
        A = {16'd1000, 16'd500, 16'd250, 16'd0};
        B = {16'd999,  16'd500, 16'd251, 16'd1};
        check({16'd1, 16'd0, 16'hFFFF, 16'hFFFF}, "SUB mixed");

        // -------------------------------------------------------
        // SLL (Op = 0011)
        // -------------------------------------------------------
        $display("\n--- SLL ---");
        Op = 4'b0011;

        A = {16'd1, 16'd1, 16'd1, 16'd1};
        shift = 6'd1;
        check({16'd2, 16'd2, 16'd2, 16'd2}, "SLL shift 1");

        shift = 6'd4;
        check({16'd16, 16'd16, 16'd16, 16'd16}, "SLL shift 4");

        A = {16'd1, 16'd2, 16'd4, 16'd8};
        shift = 6'd3;
        check({16'd8, 16'd16, 16'd32, 16'd64}, "SLL diff lanes");

        // Shift out all bits
        A = {16'hFFFF, 16'hFFFF, 16'hFFFF, 16'hFFFF};
        shift = 6'd16;
        check(64'd0, "SLL shift 16=0");

        // -------------------------------------------------------
        // SRL (Op = 0100)
        // -------------------------------------------------------
        $display("\n--- SRL ---");
        Op = 4'b0100;

        A = {16'd256, 16'd128, 16'd64, 16'd32};
        shift = 6'd1;
        check({16'd128, 16'd64, 16'd32, 16'd16}, "SRL shift 1");

        shift = 6'd4;
        A = {16'd256, 16'd256, 16'd256, 16'd256};
        check({16'd16, 16'd16, 16'd16, 16'd16}, "SRL shift 4");

        // Logical right shift: MSB should not replicate (unsigned)
        A = {16'h8000, 16'h8000, 16'h8000, 16'h8000};
        shift = 6'd1;
        check({16'h4000, 16'h4000, 16'h4000, 16'h4000}, "SRL logical");

        // -------------------------------------------------------
        // EQ (Op = 0101)
        // -------------------------------------------------------
        $display("\n--- EQ ---");
        Op = 4'b0101; shift = 0;

        // All equal
        A = {16'd7, 16'd7, 16'd7, 16'd7};
        B = {16'd7, 16'd7, 16'd7, 16'd7};
        check({16'd1, 16'd1, 16'd1, 16'd1}, "EQ all equal");

        // None equal
        A = {16'd1, 16'd2, 16'd3, 16'd4};
        B = {16'd5, 16'd6, 16'd7, 16'd8};
        check(64'd0, "EQ none equal");

        // Mixed equal/not-equal per lane
        A = {16'd10, 16'd20, 16'd30, 16'd40};
        B = {16'd10, 16'd99, 16'd30, 16'd99};
        check({16'd1, 16'd0, 16'd1, 16'd0}, "EQ mixed");

        // -------------------------------------------------------
        // LT (Op = 0110)
        // -------------------------------------------------------
        $display("\n--- LT (signed) ---");
        Op = 4'b0110;

        // All A < B
        A = {16'd1,    16'd2,    16'd3,    16'd4   };
        B = {16'd5,    16'd6,    16'd7,    16'd8   };
        check({16'd1, 16'd1, 16'd1, 16'd1}, "LT all true");

        // All A > B
        A = {16'd9,    16'd9,    16'd9,    16'd9   };
        B = {16'd1,    16'd1,    16'd1,    16'd1   };
        check(64'd0, "LT all false");

        // Signed: -1 < 1
        A = {16'hFFFF, 16'hFFFF, 16'hFFFF, 16'hFFFF}; // -1 signed
        B = {16'd1,    16'd1,    16'd1,    16'd1   };
        check({16'd1, 16'd1, 16'd1, 16'd1}, "LT signed neg<pos");

        // Mixed
        A = {16'd5,    16'd5,    16'd5,    16'd5   };
        B = {16'd5,    16'd6,    16'd4,    16'd5   };
        check({16'd0, 16'd1, 16'd0, 16'd0}, "LT mixed");

        // -------------------------------------------------------
        // GT (Op = 0111)
        // -------------------------------------------------------
        $display("\n--- GT (signed) ---");
        Op = 4'b0111;

        // All A > B
        A = {16'd10, 16'd20, 16'd30, 16'd40};
        B = {16'd1,  16'd2,  16'd3,  16'd4 };
        check({16'd1, 16'd1, 16'd1, 16'd1}, "GT all true");

        // All A < B
        A = {16'd1, 16'd1, 16'd1, 16'd1};
        B = {16'd2, 16'd2, 16'd2, 16'd2};
        check(64'd0, "GT all false");

        // Signed: 1 > -1
        A = {16'd1,    16'd1,    16'd1,    16'd1   };
        B = {16'hFFFF, 16'hFFFF, 16'hFFFF, 16'hFFFF}; // -1
        check({16'd1, 16'd1, 16'd1, 16'd1}, "GT signed pos>neg");

        // Equal lanes should be false
        A = {16'd5, 16'd5, 16'd5, 16'd5};
        B = {16'd5, 16'd5, 16'd5, 16'd5};
        check(64'd0, "GT equal=false");

        // -------------------------------------------------------
        // MULT (Op = 1000)
        // -------------------------------------------------------
        $display("\n--- MULT ---");
        Op = 4'b1000; shift = 0;

        // Simple multiply
        A = {16'd2,  16'd3,  16'd4,  16'd5 };
        B = {16'd10, 16'd10, 16'd10, 16'd10};
        check({16'd20, 16'd30, 16'd40, 16'd50}, "MULT basic");

        // Multiply by zero
        A = {16'd100, 16'd200, 16'd300, 16'd400};
        B = {16'd0,   16'd0,   16'd0,   16'd0  };
        check(64'd0, "MULT by zero");

        // Multiply by one
        A = {16'd777, 16'd888, 16'd999, 16'd111};
        B = {16'd1,   16'd1,   16'd1,   16'd1  };
        check(A, "MULT by one");

        // Signed multiply: (-1) * 1 = -1
        A = {16'hFFFF, 16'hFFFF, 16'hFFFF, 16'hFFFF}; // -1
        B = {16'd1,    16'd1,    16'd1,    16'd1   };
        check({16'hFFFF, 16'hFFFF, 16'hFFFF, 16'hFFFF}, "MULT neg*1");

        // -------------------------------------------------------
        // PASS/MOV (Op = 1001)
        // -------------------------------------------------------
        $display("\n--- PASS (MOV) ---");
        Op = 4'b1001; shift = 0;

        B = {16'hDEAD, 16'hBEEF, 16'hCAFE, 16'hBABE};
        A = {16'h1234, 16'h5678, 16'h9ABC, 16'hDEF0}; // A should be ignored
        check(B, "PASS B passthru");

        B = 64'd0;
        check(64'd0, "PASS B=0");

        B = 64'hFFFFFFFFFFFFFFFF;
        check(64'hFFFFFFFFFFFFFFFF, "PASS B=allones");

        // -------------------------------------------------------
        // DEFAULT (Op = 0000 and 1111 - unassigned)
        // -------------------------------------------------------
        $display("\n--- DEFAULT (unknown Op) ---");

        A = {16'd999, 16'd888, 16'd777, 16'd666};
        B = {16'd111, 16'd222, 16'd333, 16'd444};

        Op = 4'b0000;
        check(64'd0, "DEFAULT Op=0000");

        Op = 4'b1010;
        check(64'd0, "DEFAULT Op=1010");

        Op = 4'b1111;
        check(64'd0, "DEFAULT Op=1111");

        // -------------------------------------------------------
        // Summary
        // -------------------------------------------------------
        $display("\n============================================================");
        $display("  Results: %0d PASSED, %0d FAILED", pass_count, fail_count);
        $display("============================================================\n");

        $finish;
    end

endmodule