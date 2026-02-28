module pipeline_backup(
    input clk,
    input rst,

    //HOST interactions
    input write_to_imem,
    input write_to_dmem,
    input [8:0]  addr_imem_host,
    input [31:0] data_imem_host,
    input [7:0]  addr_dmem_host,
    input [63:0] data_dmem_host,      // 64-bit

    input         read_req_dmem,
    output [63:0] data_out_dmem       // 64-bit
);
    
    wire [31:0] instruction;
    wire [31:0] id_inst;
    reg  [31:0] pc;
    wire [31:0] pc_plus_1 = pc + 1;
    wire        PCSrc;
    wire [31:0] next_pc;

    always @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 32'b0;
        else
            pc <= next_pc;
    end

    // IF Stage
    wire [31:0] branch_target;
    ifetch IF (
        .clk(clk),
        .rst(rst),
        .PCSrc(PCSrc),
        .branch_target(branch_target),
        .write_to_imem(write_to_imem),
        .addr_imem_host(addr_imem_host),
        .imem_data(data_imem_host),
        .instruction_out(instruction)
    );

    // IF/ID Bridge
    register_generate #(32) if_id (
        .clk(clk),
        .rst(rst),
        .d_in(instruction),
        .q_out(id_inst)
    );

    // WB signals (now 64-bit data)
    wire [63:0] wb_data;
    wire [4:0]  wb_wreg_addr;
    wire        wb_wreg_en;

    // --- STAGE 2: DECODE ---
    wire [63:0] id_r1data, id_r2data;     // 64-bit
    wire [63:0] id_sign_ext_imm;          // 64-bit sign extension
    wire [4:0]  id_wreg_addr;
    wire        id_wreg_en, id_wmem_en;
    wire        id_mem_read;
    wire        id_mem_to_reg;
    wire        id_ALUSrc;
    wire [4:0]  id_shift;
    wire [3:0]  id_alu_ctrl;

    decode ID (
        .clk(clk),
        .rst(rst),
        .pc_plus_1(pc_plus_1),
        .id_inst(id_inst),
        .wb_waddr(wb_wreg_addr),
        .wb_wdata(wb_data),               // 64-bit
        .wb_wena(wb_wreg_en),
        .r1data(id_r1data),               // 64-bit
        .r2data(id_r2data),               // 64-bit
        .wreg_addr_out(id_wreg_addr),
        .wreg_en_out(id_wreg_en),
        .wmem_en_out(id_wmem_en),
        .mem_read_out(id_mem_read),
        .sign_ext_imm_out(id_sign_ext_imm), // 64-bit
        .mem_to_reg_out(id_mem_to_reg),
        .ALUSrc_out(id_ALUSrc),
        .shift_out(id_shift),
        .alu_ctrl_out(id_alu_ctrl),
        .PCSrc(PCSrc),           
        .branch_target(branch_target)
    );

    assign next_pc = PCSrc ? branch_target : pc_plus_1;

    // --- ID/EX Bridge ---
    // 64+64+64+5+1+1+1+1+1+5+4 = 211 bits
    wire [210:0] id_ex_q;

    register_generate #(211) id_ex_bridge (
        .clk(clk),
        .rst(rst),
        .d_in({
            id_r1data,          // [210:147]
            id_r2data,          // [146:83]
            id_sign_ext_imm,    // [82:19]
            id_wreg_addr,       // [18:14]
            id_wreg_en,         // [13]
            id_wmem_en,         // [12]
            id_mem_to_reg,      // [11]
            id_mem_read,        // [10]
            id_ALUSrc,          // [9]
            id_shift,           // [8:4]
            id_alu_ctrl         // [3:0]
        }),
        .q_out(id_ex_q)
    );

    // --- STAGE 3: EXEC ---
    wire [63:0] id_ex_r1           = id_ex_q[210:147];
    wire [63:0] id_ex_r2           = id_ex_q[146:83];
    wire [63:0] id_ex_sign_ext_imm = id_ex_q[82:19];
    wire [4:0]  id_ex_wreg         = id_ex_q[18:14];
    wire        id_ex_wreg_en      = id_ex_q[13];
    wire        id_ex_wmem_en      = id_ex_q[12];
    wire        id_ex_mem_to_reg   = id_ex_q[11];
    wire        id_ex_mem_read     = id_ex_q[10];
    wire        id_ex_ALUSrc       = id_ex_q[9];
    wire [4:0]  id_ex_shift        = id_ex_q[8:4];
    wire [3:0]  id_ex_alu_ctrl     = id_ex_q[3:0];

    wire [63:0] alu_B = id_ex_ALUSrc ? id_ex_sign_ext_imm : id_ex_r2;

    wire [63:0] alu_out;

    alu_64bit alu_unit (                  // renamed to alu_64bit
        .A(id_ex_r1),
        .B(alu_B),
        .Op(id_ex_alu_ctrl),
        .shift(id_ex_shift),
        .Out(alu_out)
    );

    // --- EX/ME Bridge ---
    // 64+64+5+1+1+1+1 = 137 bits
    wire [136:0] ex_me_bundle;

    register_generate #(137) ex_me_bridge (
        .clk(clk),
        .rst(rst),
        .d_in({
            alu_out,            // [136:73]
            id_ex_r2,           // [72:9]
            id_ex_wreg,         // [8:4]
            id_ex_wreg_en,      // [3]
            id_ex_wmem_en,      // [2]
            id_ex_mem_to_reg,   // [1]
            id_ex_mem_read      // [0]
        }),
        .q_out(ex_me_bundle)
    );

    // --- STAGE 4: MEMORY ---
    wire [63:0] me_alu_result = ex_me_bundle[136:73];
    wire [63:0] me_store_data = ex_me_bundle[72:9];
    wire [4:0]  me_wreg       = ex_me_bundle[8:4];
    wire        me_wre        = ex_me_bundle[3];
    wire        me_wme        = ex_me_bundle[2];
    wire        me_mem_to_reg = ex_me_bundle[1];
    wire        me_mem_read   = ex_me_bundle[0];

    wire [63:0] dmem_raw_output;

    memory ME (
        .clk(clk),
        .write_to_dmem(write_to_dmem),
        .read_req_dmem(read_req_dmem),
        .addr_dmem_host(addr_dmem_host),
        .data_dmem_host(data_dmem_host),  // 64-bit
        .pipeline_addr(me_alu_result),
        .pipeline_data(me_store_data),    // 64-bit
        .pipeline_we(me_wme),
        .dmem_out(dmem_raw_output)        // 64-bit
    );

    assign data_out_dmem = dmem_raw_output;   // full 64-bit

    // --- ME/WB Bridge ---
    // 64+5+1 = 70 bits
    wire [69:0] me_wb_bundle;

    wire [63:0] wb_result =
        (me_mem_to_reg && me_mem_read)
            ? dmem_raw_output             // load result from memory
            : me_alu_result;              // ALU result

    register_generate #(70) me_wb_bridge (
        .clk(clk),
        .rst(rst),
        .d_in({wb_result, me_wreg, me_wre}),
        .q_out(me_wb_bundle)
    );

    assign wb_data      = me_wb_bundle[69:6];   // 64-bit
    assign wb_wreg_addr = me_wb_bundle[5:1];
    assign wb_wreg_en   = me_wb_bundle[0];

endmodule
