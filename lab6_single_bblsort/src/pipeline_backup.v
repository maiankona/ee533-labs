`timescale 1ns / 1ps

module pipeline_backup(
    input clk,
    input rst,

    // HOST interactions
    input write_to_imem,
    input write_to_dmem,
    input [8:0]  addr_imem_host,
    input [31:0] data_imem_host,
    input [7:0]  addr_dmem_host,
    input [31:0] data_dmem_host,
    input        read_req_dmem,

    // HOST Expectations
    output        alu_result_detected,
    output [31:0] data_out_dmem,
    output [31:0] alu_out_intercept
);

    // Feedback Paths
    wire [31:0] wb_wdata;      
    wire [2:0]  wb_waddr;      
    wire        wb_wena;       
    wire        ex_take_branch; 
    wire [8:0]  ex_br_target;
    
    wire [8:0]  if_pc; 

    // --- STAGE 1: INSTRUCTION FETCH (IF) ---
    wire [31:0] if_instruction;

    ifetch IF (
        .clk(clk), .rst(rst),
        .write_to_imem(write_to_imem),
        .addr_imem_host(addr_imem_host),
        .imem_data(data_imem_host),
        .take_branch(ex_take_branch),      
        .branch_target(ex_br_target),      
        .instruction_out(if_instruction),
        .pc(if_pc)
    );

    wire [8:0]  id_pc; 
    wire [31:0] id_inst;

    register_generate #(41) if_id_bridge (
        .clk(clk),
        .rst(rst),
        .d_in({if_pc, if_instruction}), // Pack both
        .q_out({id_pc, id_inst})        // Unpack both (lazy)
    );

    // --- STAGE 2: INSTRUCTION DECODE (ID) ---
    wire [31:0] id_r1data, id_r2data;
    wire [2:0]  id_wreg_addr;
    wire        id_wreg_en, id_wmem_en, id_mem_read, id_mem_write, id_mem_to_reg, id_ALUSrc, id_branch;
    wire [11:0] id_immediate;
    wire [4:0]  id_shift;
    wire [3:0]  id_alu_ctrl;
    wire [1:0]  id_br_type;
    wire [8:0]  id_br_addr;

    idecode ID (
        .clk(clk),
        .rst(rst),
        .id_inst(id_inst),

        // Write-back feedback connections
        .wb_waddr(wb_waddr),
        .wb_wdata(wb_wdata),
        .wb_wena(wb_wena),

        // Data and Control Outputs
        .r1data(id_r1data),
        .r2data(id_r2data),
        .wreg_addr_out(id_wreg_addr),
        .wreg_en_out(id_wreg_en),
        .wmem_en_out(id_wmem_en),
        .alu_ctrl_out(id_alu_ctrl),
        .ALUSrc_out(id_ALUSrc),
        .shift_out(id_shift),
        .immediate_out(id_immediate),
        .mem_to_reg_out(id_mem_to_reg),
        .mem_read_out(id_mem_read),
		  .mem_write_out(id_mem_write),
        .branch_out(id_branch),
        .br_type_out(id_br_type),
        .br_addr_out(id_br_addr)
    );

    // BRIDGE 2: ID/EX (106 bits)
    wire [114:0] id_ex_q;
    register_generate #(115) id_ex_bridge (
        .clk(clk), .rst(rst),
        .d_in({
            id_pc,
            id_r1data, id_r2data, id_immediate, id_wreg_addr, id_wreg_en, 
            id_wmem_en, 
            id_mem_to_reg, // [24]
            id_mem_read,   // [23]
			   id_mem_write,  // [22]
            id_ALUSrc,     // [21] 
            id_shift,      // [20:16]
            id_alu_ctrl,   // [15:12]
            id_branch,     // [11]
            id_br_type,    // [10:9]
            id_br_addr     // [8:0]
        }),
        .q_out(id_ex_q)
    );

    // --- STAGE 3: EXECUTE (EX) ---
    wire [8:0]  ex_pc          = id_ex_q[114:106];
    wire [31:0] ex_r1data      = id_ex_q[105:74];
    wire [31:0] ex_r2data      = id_ex_q[73:42];
    wire [11:0] ex_imm12       = id_ex_q[41:30];
    wire [3:0]  ex_alu_ctrl    = id_ex_q[15:12];
    wire [4:0]  ex_shift       = id_ex_q[20:16];
    wire        ex_ALUSrc      = id_ex_q[21];
    wire        ex_branch_inst = id_ex_q[11];
    wire [1:0]  ex_br_type     = id_ex_q[10:9];
    
    assign ex_br_target = id_ex_q[8:0] + ex_pc;
	 wire ex_store = id_ex_q[22]; //dont forget to drop this
	 
    // Use reg2 (ex_r2data) as the address base for LW/SW; otherwise use ex_r1data

    wire [31:0] ex_alu_A = id_ex_q[22] ? ex_r2data : ex_r1data;
    
    // Sign Extend 12-bit immediate
    wire [31:0] ex_imm32 = {{20{ex_imm12[11]}}, ex_imm12};

    // ALU Input Mux
    wire [31:0] alu_b_in = ex_ALUSrc ? ex_imm32 : ex_r2data;

    // ALU Instance
    wire [31:0] ex_alu_out;
    wire        ex_alu_zero;
    wire        ex_alu_negative;
    wire        ex_alu_of;
    wire        ex_alu_c;
    
    alu_32bit ALU (
        .A(ex_alu_A),
        .B(alu_b_in),
        .Op(ex_alu_ctrl),
        .shift(ex_shift),
        .Out(ex_alu_out),
        .zero(ex_alu_zero),
        .negative(ex_alu_negative),
        .overflow(ex_alu_of),
        .carry(ex_alu_c)
    );

    assign alu_out_intercept = ex_alu_out;

    // BRANCH SNIPPET
    assign ex_take_branch = ex_branch_inst && (
        (ex_br_type == 2'b00) ? 1'b1 :            // Always Branch (B)
        (ex_br_type == 2'b10) ? !ex_alu_zero :    // Branch Not Equal (BNE)
        (ex_br_type == 2'b11) ? ex_alu_negative : // Branch Less Than (BLT)
        1'b0
    );

    // BRIDGE 3: EX/ME (71+2 bits)
    wire [72:0] ex_me_q;
    register_generate #(73) ex_me_bridge (
        .clk(clk), .rst(rst),
        .d_in({
            ex_alu_of, ex_alu_c, ex_alu_out, 
            ex_r1data, 
            id_ex_q[29:27], id_ex_q[26], 
            id_ex_q[25], id_ex_q[24], id_ex_q[23]
        }),
        .q_out(ex_me_q)
    );

    // --- STAGE 4: MEMORY (ME) ---
    wire        me_of         = ex_me_q[72];
    wire        me_c          = ex_me_q[71];
    wire [31:0] me_alu_res    = ex_me_q[70:39];
    wire [31:0] me_store_data = ex_me_q[38:7];
    wire        me_wme        = ex_me_q[2];
    wire [31:0] dmem_raw_output;
    

    memory ME (
        .clk(clk),
        .write_to_dmem(write_to_dmem),
        .read_req_dmem(read_req_dmem),
        .addr_dmem_host(addr_dmem_host),
        .data_dmem_host(data_dmem_host),
        .pipeline_addr(me_alu_res),
        .pipeline_data(me_store_data),
        .pipeline_we(me_wme),
        .dmem_out(dmem_raw_output)
    );
	 
	 // BRIDGE 3.5: ME >> ME2
	 wire me_mux_select = ex_me_q[1];
	 wire [36:0] me_me2_q;
	 register_generate # 37 me_me2_bridge (
        .clk(clk), .rst(rst),
        .d_in({
            me_mux_select, me_alu_res, ex_me_q[6:4], ex_me_q[3]
        }),
        .q_out(me_me2_q)
    );

    assign data_out_dmem = dmem_raw_output;
    assign alu_result_detected = me_wme;

    wire [31:0] dmem_reg = dmem_raw_output;
	 
	wire [31:0] me2_alu = me_me2_q[35:4];
	 
	wire [31:0] me_data = me_me2_q[36] ? dmem_reg : me2_alu;


    // BRIDGE 4: ME/WB (36 bits)
    wire [35:0] me_wb_q;
    register_generate #(36) me_wb_bridge (
        .clk(clk), .rst(rst),
        .d_in({
            me_data, me_me2_q[3:0]
        }),
        .q_out(me_wb_q)
    );

    // --- STAGE 5: WRITE BACK (WB) ---
    assign wb_wdata = me_wb_q[35:4];
    assign wb_waddr = me_wb_q[3:1];
    assign wb_wena  = me_wb_q[0];

endmodule
