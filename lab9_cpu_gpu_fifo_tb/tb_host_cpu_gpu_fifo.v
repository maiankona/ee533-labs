`timescale 1ns/1ps

`define UDP_REG_ADDR_WIDTH 23
`define CPCI_NF2_DATA_WIDTH 32
// Must match ids.v: generic_regs .TAG and reg_addr_in[22:4] decode
`define IDS_BLOCK_ADDR 19'h00008

// ----------------------------------------------------------------
// Behavioral generic_regs: SW image updated only via UDP writes (posedge sample).
// software_regs order matches ids.v: {dmem_in_hi, dmem_in_lo, imem, address, input_type}
// reg_addr[3:0]: 0=dmem_hi, 1=dmem_lo, 2=imem, 3=address, 4=input_type
// ----------------------------------------------------------------
module generic_regs #(
    parameter UDP_REG_SRC_WIDTH = 2,
    parameter TAG               = 0,
    parameter REG_ADDR_WIDTH    = 4,
    parameter NUM_COUNTERS      = 0,
    parameter NUM_SOFTWARE_REGS = 5,
    parameter NUM_HARDWARE_REGS = 4
) (
    input                                          reg_req_in,
    input                                          reg_ack_in,
    input                                          reg_rd_wr_L_in,
    input  [`UDP_REG_ADDR_WIDTH-1:0]               reg_addr_in,
    input  [`CPCI_NF2_DATA_WIDTH-1:0]              reg_data_in,
    input  [UDP_REG_SRC_WIDTH-1:0]                 reg_src_in,
    output                                         reg_req_out,
    output                                         reg_ack_out,
    output                                         reg_rd_wr_L_out,
    output [`UDP_REG_ADDR_WIDTH-1:0]               reg_addr_out,
    output [`CPCI_NF2_DATA_WIDTH-1:0]              reg_data_out,
    output [UDP_REG_SRC_WIDTH-1:0]                 reg_src_out,
    input  [NUM_COUNTERS-1:0]                      counter_updates,
    input  [NUM_COUNTERS-1:0]                      counter_decrement,
    output [NUM_SOFTWARE_REGS*32-1:0]              software_regs,
    input  [NUM_HARDWARE_REGS*32-1:0]              hardware_regs,
    input                                          clk,
    input                                          reset
);
    assign reg_req_out     = reg_req_in;
    assign reg_ack_out     = reg_req_in;
    assign reg_rd_wr_L_out = reg_rd_wr_L_in;
    assign reg_addr_out    = reg_addr_in;
    assign reg_data_out    = reg_data_in;
    assign reg_src_out     = reg_src_in;

    reg [31:0] r_dmem_hi;
    reg [31:0] r_dmem_lo;
    reg [31:0] r_imem;
    reg [31:0] r_address;
    reg [31:0] r_input_type;

    assign software_regs = {r_dmem_hi, r_dmem_lo, r_imem, r_address, r_input_type};

    always @(posedge clk) begin
        if (reset) begin
            r_dmem_hi    <= 32'h0;
            r_dmem_lo    <= 32'h0;
            r_imem       <= 32'h0;
            r_address    <= 32'h0;
            r_input_type <= 32'h0;
        end else if (reg_req_in && !reg_rd_wr_L_in && reg_addr_in[22:4] == TAG) begin
            case (reg_addr_in[3:0])
                4'h0: r_dmem_hi    <= reg_data_in;
                4'h1: r_dmem_lo    <= reg_data_in;
                4'h2: r_imem       <= reg_data_in;
                4'h3: r_address    <= reg_data_in;
                4'h4: r_input_type <= reg_data_in;
                default: ;
            endcase
        end
    end
endmodule

// ----------------------------------------------------------------
// Host/GPU SW: UDP reg_write only (no hierarchical sw_regs ? portable across tools).
// ids.v input_type: [0] write_to_imem, [1] write_to_dmem, [2] read_req_dmem,
// [3] GPU start edge, [4] read_req_imem
// ----------------------------------------------------------------

module tb_host_cpu_gpu_fifo;

    reg  [63:0] in_data;
    reg  [7:0]  in_ctrl;
    reg         in_wr;
    wire        in_rdy;
    wire [63:0] out_data;
    wire [7:0]  out_ctrl;
    wire        out_wr;
    reg         out_rdy;

    reg         reg_req_in;
    reg         reg_ack_in;
    reg         reg_rd_wr_L_in;
    reg  [`UDP_REG_ADDR_WIDTH-1:0]   reg_addr_in;
    reg  [`CPCI_NF2_DATA_WIDTH-1:0]  reg_data_in;
    reg  [1:0]  reg_src_in;
    wire        reg_req_out;
    wire        reg_ack_out;
    wire        reg_rd_wr_L_out;
    wire [`UDP_REG_ADDR_WIDTH-1:0]   reg_addr_out;
    wire [`CPCI_NF2_DATA_WIDTH-1:0]  reg_data_out;
    wire [1:0]  reg_src_out;

    reg         clk;
    reg         reset;
    reg         cpu_start;
    reg         arm_write_to_imem;
    reg  [8:0]  arm_addr_imem_host;
    reg  [31:0] arm_data_imem_host;

    localparam [22:0] REG_DMEM_HI    = {`IDS_BLOCK_ADDR, 4'h0};
    localparam [22:0] REG_DMEM_LO    = {`IDS_BLOCK_ADDR, 4'h1};
    localparam [22:0] REG_IMEM       = {`IDS_BLOCK_ADDR, 4'h2};
    localparam [22:0] REG_ADDRESS    = {`IDS_BLOCK_ADDR, 4'h3};
    localparam [22:0] REG_INPUT_TYPE = {`IDS_BLOCK_ADDR, 4'h4};

    localparam [31:0] ITYPE_WRITE_IMEM = 32'h1;
    localparam [31:0] ITYPE_WRITE_DMEM = 32'h2;
    localparam [31:0] ITYPE_READ_DMEM  = 32'h4;
    localparam [31:0] ITYPE_GPU_START  = 32'h8;

    ids dut (
        .in_data(in_data),
        .in_ctrl(in_ctrl),
        .in_wr(in_wr),
        .in_rdy(in_rdy),
        .out_data(out_data),
        .out_ctrl(out_ctrl),
        .out_wr(out_wr),
        .out_rdy(out_rdy),
        .reg_req_in(reg_req_in),
        .reg_ack_in(reg_ack_in),
        .reg_rd_wr_L_in(reg_rd_wr_L_in),
        .reg_addr_in(reg_addr_in),
        .reg_data_in(reg_data_in),
        .reg_src_in(reg_src_in),
        .reg_req_out(reg_req_out),
        .reg_ack_out(reg_ack_out),
        .reg_rd_wr_L_out(reg_rd_wr_L_out),
        .reg_addr_out(reg_addr_out),
        .reg_data_out(reg_data_out),
        .reg_src_out(reg_src_out),
        .clk(clk),
        .reset(reset),
        .cpu_start(cpu_start),
        .arm_write_to_imem(arm_write_to_imem),
        .arm_addr_imem_host(arm_addr_imem_host),
        .arm_data_imem_host(arm_data_imem_host)
    );

    initial clk = 0;
    always #4 clk = ~clk;

    integer cyc;
    initial cyc = 0;
    always @(posedge clk) cyc = cyc + 1;

    // NF2-style UDP write (reg_rd_wr_L_in = 0 for write); holds reg_req through one posedge
    task reg_write;
        input [22:0] addr;
        input [31:0] data;
        begin
            @(negedge clk);
            reg_addr_in    = addr;
            reg_data_in    = data;
            reg_rd_wr_L_in = 1'b0;
            reg_req_in     = 1'b1;
            @(posedge clk);
            @(negedge clk);
            reg_req_in     = 1'b0;
            reg_rd_wr_L_in = 1'b1;
            @(negedge clk);
        end
    endtask

    // One cycle assert then clear ? enough for host_we_edge (0->1) and read_req_dmem
    task pulse_input_type;
        input [31:0] mask_one_cycle;
        begin
            reg_write(REG_INPUT_TYPE, mask_one_cycle);
            reg_write(REG_INPUT_TYPE, 32'h0);
        end
    endtask

    task host_dmem_write;
        input [7:0]  byte_addr;
        input [31:0] lo;
        input [31:0] hi;
        begin
            reg_write(REG_ADDRESS, {24'h0, byte_addr});
            reg_write(REG_DMEM_LO, lo);
            reg_write(REG_DMEM_HI, hi);
            pulse_input_type(ITYPE_WRITE_DMEM);
        end
    endtask

    task host_dmem_read_req;
        input [7:0] byte_addr;
        begin
            reg_write(REG_ADDRESS, {24'h0, byte_addr});
            pulse_input_type(ITYPE_READ_DMEM);
            repeat (6) @(posedge clk);
        end
    endtask

    task gpu_host_imem_word;
        input [31:0] addr_word;
        input [31:0] instr;
        begin
            reg_write(REG_ADDRESS, addr_word);
            reg_write(REG_IMEM, instr);
            pulse_input_type(ITYPE_WRITE_IMEM);
        end
    endtask

    task gpu_host_start_pulse;
        input [31:0] address_for_bram;
        begin
            reg_write(REG_ADDRESS, address_for_bram);
            pulse_input_type(ITYPE_GPU_START);
        end
    endtask

    task arm_imem_write;
        input [8:0]  addr;
        input [31:0] instr;
        begin
            @(negedge clk);
            arm_write_to_imem  = 1'b1;
            arm_addr_imem_host = addr;
            arm_data_imem_host = instr;
            @(negedge clk);
            arm_write_to_imem  = 1'b0;
        end
    endtask

    task cpu_start_pulse;
        begin
            @(negedge clk);
            cpu_start = 1'b1;
            @(negedge clk);
            cpu_start = 1'b0;
        end
    endtask

    localparam [31:0] B_SELF = 32'hEAFFFFFE;

    initial begin
        in_data              = 0;
        in_ctrl              = 0;
        in_wr                = 0;
        out_rdy              = 1;
        reg_req_in           = 0;
        reg_ack_in           = 0;
        reg_rd_wr_L_in       = 1;
        reg_addr_in          = 0;
        reg_data_in          = 0;
        reg_src_in           = 0;
        cpu_start            = 0;
        arm_write_to_imem    = 0;
        arm_addr_imem_host   = 0;
        arm_data_imem_host   = 0;

        reset = 1;
        repeat (4) @(posedge clk);
        #1 reset = 0;
        $display("=== tb_host_cpu_gpu_fifo: reset at cycle %0d ===", cyc);

        // ----------------------------------------------------------
        // 1) Host DMEM write/read via SW regs (same path as GPU host)
        // ----------------------------------------------------------
        $display("--- Host DMEM write @0x00 (64b) ---");
        host_dmem_write(8'h00, 32'hAABBCCDD, 32'h11223344);
        repeat (2) @(posedge clk);

        $display("--- Host DMEM read @0x00 ---");
        host_dmem_read_req(8'h00);
        $display("    dmem_out (64b) = %h  (expect 11223344AABBCCDD if aligned read matches write)",
                 dut.dmem_out);

        // ----------------------------------------------------------
        // 2) GPU: one IMEM word + SW GPU_START (address holds len/PC map)
        // ----------------------------------------------------------
        $display("--- GPU: IMEM[0]=0, address=32'h00000100 (len=1, PC=0), GPU_START ---");
        gpu_host_imem_word(32'h00000100, 32'h00000000);
        gpu_host_start_pulse(32'h00000100);

        repeat (80) @(posedge clk);
        $display("    After GPU window: tensor_out (hw) = %h", dut.tensor_out);

        host_dmem_read_req(8'h00);
        $display("    Host readback dmem_out = %h", dut.dmem_out);

        // ----------------------------------------------------------
        // 3) ARM: load IMEM via host ports, then cpu_start (like tb_ids_cpu_gpu)
        // ----------------------------------------------------------
        $display("--- ARM: IMEM[0] = B self, cpu_start pulse ---");
        arm_imem_write(9'h000, B_SELF);
        cpu_start_pulse();
        repeat (20) @(posedge clk);

        $display("=== tb_host_cpu_gpu_fifo done ===");
        $display("    (ids) arm_mem_stall=%0d at end ? 1 means ARM still waiting on GPU/host SRAM",
                 dut.arm_mem_stall);
        $finish;
    end

    initial begin
        #500000;
        $display("TIMEOUT");
        $finish;
    end
endmodule
