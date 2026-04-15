// idecode.v  -- canonical decoder for your pipeline
`timescale 1ns/1ps
module idecode (
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] id_inst,
    input [8:0] id_pc, //okay so it's just better to calculate branch target here

    //thread management
    input [1:0] curr_thread,
    
    // Write-back interface (feedback loop from Stage 5)
    input wire [3:0]  wb_waddr,       
    input wire [31:0] wb_wdata,       
    input wire        wb_wena,
    input wire [1:0]  wb_thread, //to only mess with the instruction's registers        

    // basic register file / writeback control
    output wire [31:0] r1data,
    output wire [31:0] r2data,
    output wire        wmem_en_out,
    output wire        wreg_en_out,
    output wire [3:0]  wreg_addr_out,

    // ALU / immediate controls
    output wire [3:0]  alu_ctrl_out,
    output wire [11:0] immediate_out,
    output wire        alu_src,

    // Memory / load controls
    output wire        mem_to_reg_out,
    output wire        mem_read_out,
    output wire        mem_write_out,

    // Branch controls
    output wire        branch,
    output wire [3:0]  branch_type,
    output wire [8:0]  br_addr
);

    wire [3:0]  cond   = id_inst[31:28];
    wire [1:0]  type   = id_inst[27:26];
    wire        i_bit  = id_inst[25];
    wire [3:0]  opcode = id_inst[24:21];
    wire        s_bit  = id_inst[20];

    wire [3:0]  rs1    = id_inst[19:16];
    wire [3:0]  rd     = id_inst[15:12];
    wire [11:0] imm12  = id_inst[11:0];
    wire [3:0]  rs2    = id_inst[3:0];

    wire is_dp     = (type == 2'b00);
    wire is_mem    = (type == 2'b01);
    wire is_branch = (type == 2'b10);

    wire is_load   = is_mem &&  id_inst[20];
    wire is_store  = is_mem && ~id_inst[20];

    // ARM OPCODES
    localparam ARM_AND = 4'b0000;
    localparam ARM_EOR = 4'b0001;
    localparam ARM_SUB = 4'b0010;
    localparam ARM_RSB = 4'b0011;
    localparam ARM_ADD = 4'b0100;
    localparam ARM_ADC = 4'b0101;
    localparam ARM_SBC = 4'b0110;
    localparam ARM_RSC = 4'b0111;
    localparam ARM_TST = 4'b1000;
    localparam ARM_TEQ = 4'b1001;
    localparam ARM_CMP = 4'b1010; //THIS INSTRUCTION IS MODDED!
    localparam ARM_CMN = 4'b1011;
    localparam ARM_ORR = 4'b1100;
    localparam ARM_MOV = 4'b1101;
    localparam ARM_BIC = 4'b1110;
    localparam ARM_MVN = 4'b1111;

    localparam ALU_AND = 4'd2;
    localparam ALU_EOR = 4'd4;
    localparam ALU_SUB = 4'd1;
    localparam ALU_ADD = 4'd0;
    localparam ALU_ORR = 4'd3;
    localparam ALU_SLT = 4'd5;
    localparam ALU_SLL = 4'd6;
    localparam ALU_SRL = 4'd7;
    localparam ALU_SRA = 4'd8;

    // ----------------------------------------------------------------
    // wreg_en: explicitly whitelist instructions that write to register
    // Excludes: flag-only (TST/TEQ/CMP/CMN), NOPs, STR, branch
    // ----------------------------------------------------------------
    wire is_nop = (id_inst == 32'h00000000) || (id_inst == 32'hE1A00000);

    wire writes_back = is_dp && (
        opcode == ARM_AND ||
        opcode == ARM_EOR ||
        opcode == ARM_SUB ||
        opcode == ARM_RSB ||
        opcode == ARM_ADD ||
        opcode == ARM_ADC ||
        opcode == ARM_SBC ||
        opcode == ARM_RSC ||
        opcode == ARM_ORR ||
        opcode == ARM_MOV ||
        opcode == ARM_BIC ||
        opcode == ARM_MVN
    );

    // Combinational decode signals (based on current id_inst)
    wire wreg_en_comb    = (writes_back || is_load) && !is_nop;
    wire wmem_en_comb    = is_store;
    wire mem_read_comb   = is_load;
    wire mem_write_comb  = is_store;
    wire mem_to_reg_comb = is_load;
    wire alu_src_comb    = (is_dp || (is_branch && s_bit)) ? i_bit : 1'b1;
    wire branch_comb     = is_branch;

    // ARM STYLE: CHOOSE YOUR R2
    // For STR, the data to store is in rd field, not rs2
    wire [3:0] rs2_sw = is_store ? rd : rs2;

    // ALU control (combinational)
    reg [3:0] alu_ctrl_comb;
    always @(*) begin
        case (opcode)
            ARM_AND, ARM_TST: alu_ctrl_comb = ALU_AND;
            ARM_EOR, ARM_TEQ: alu_ctrl_comb = ALU_EOR;
            ARM_SUB, ARM_CMP: alu_ctrl_comb = ALU_SUB;
            ARM_ADD, ARM_CMN, ARM_MOV: alu_ctrl_comb = ALU_ADD;
            ARM_ORR:          alu_ctrl_comb = ALU_ORR;
            ARM_RSB, ARM_BIC, ARM_ADC, ARM_SBC, ARM_RSC, ARM_MVN: alu_ctrl_comb = ALU_ADD;
            default:          alu_ctrl_comb = ALU_ADD;
        endcase
        if (is_mem) alu_ctrl_comb = ALU_ADD;
    end

    // ----------------------------------------------------------------
    // REGISTER FILE INSTANCES
    // BRAM has registered read - data valid one cycle after address
    // Output to intermediate wires so forwarding can override
    // ----------------------------------------------------------------
    wire [31:0] r1data_bram, r2data_bram;

    registerFile64_BRAM rs1_src (
        .clka(clk),
        .addra({curr_thread, rs1}),
        .douta(r1data_bram),
        .clkb(clk),
        .addrb({wb_thread, wb_waddr}),
        .dinb(wb_wdata),
        .web(wb_wena)
    );

    registerFile64_BRAM rs2_src (
        .clka(clk),
        .addra({curr_thread, rs2_sw}),
        .douta(r2data_bram),
        .clkb(clk),
        .addrb({wb_thread, wb_waddr}),
        .dinb(wb_wdata),
        .web(wb_wena)
    );

    // ----------------------------------------------------------------
    // Forwarding: bypass BRAM when WB writes same register being read
    // Prevents X from simultaneous read/write collision on BRAM port
    // ----------------------------------------------------------------
    wire r1_fwd = wb_wena && (wb_waddr == rs1)    && (wb_thread == curr_thread);
    wire r2_fwd = wb_wena && (wb_waddr == rs2_sw) && (wb_thread == curr_thread);

    assign r1data = r1_fwd ? wb_wdata : r1data_bram;
    assign r2data = r2_fwd ? wb_wdata : r2data_bram;

    // ----------------------------------------------------------------
    // Register all control signals one cycle to align with BRAM output
    // BRAM presents data one cycle after address is presented ?
    // all control signals must be delayed to match so that EX sees
    // the correct opcode alongside the correct register data
    // ----------------------------------------------------------------
    reg        wreg_en_r;
    reg        wmem_en_r;
    reg        mem_read_r;
    reg        mem_write_r;
    reg        mem_to_reg_r;
    reg        alu_src_r;
    reg        branch_r;
    reg [3:0]  alu_ctrl_r;
    reg [3:0]  wreg_addr_r;
    reg [11:0] immediate_r;
    reg [3:0]  branch_type_r;
    reg [8:0]  br_addr_r;

    always @(posedge clk) begin
        if (rst) begin
            wreg_en_r     <= 1'b0;
            wmem_en_r     <= 1'b0;
            mem_read_r    <= 1'b0;
            mem_write_r   <= 1'b0;
            mem_to_reg_r  <= 1'b0;
            alu_src_r     <= 1'b0;
            branch_r      <= 1'b0;
            alu_ctrl_r    <= 4'b0;
            wreg_addr_r   <= 4'b0;
            immediate_r   <= 12'b0;
            branch_type_r <= 4'b0;
            br_addr_r     <= 9'b0;
        end else begin
            wreg_en_r     <= wreg_en_comb;
            wmem_en_r     <= wmem_en_comb;
            mem_read_r    <= mem_read_comb;
            mem_write_r   <= mem_write_comb;
            mem_to_reg_r  <= mem_to_reg_comb;
            alu_src_r     <= alu_src_comb;
            branch_r      <= branch_comb;
            alu_ctrl_r    <= alu_ctrl_comb;
            wreg_addr_r   <= rd;
            immediate_r   <= imm12;
            branch_type_r <= cond;
            br_addr_r     <= id_pc + {id_inst[11], id_inst[11:4]};
        end
    end

    // Output registered signals - aligned with BRAM data output
    assign wreg_en_out   = wreg_en_r;
    assign wmem_en_out   = wmem_en_r;
    assign mem_read_out  = mem_read_r;
    assign mem_write_out = mem_write_r;
    assign mem_to_reg_out= mem_to_reg_r;
    assign alu_src       = alu_src_r;
    assign branch        = branch_r;
    assign alu_ctrl_out  = alu_ctrl_r;
    assign wreg_addr_out = wreg_addr_r;
    assign immediate_out = immediate_r;
    assign branch_type   = branch_type_r;
    assign br_addr       = br_addr_r;

endmodule