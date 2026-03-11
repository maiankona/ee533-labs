`timescale 1ns / 1ps

module pipeline_cpu(
    input clk,
    input rst,

    // HOST interactions
    input write_to_imem,
    input write_to_dmem,
    input [8:0]  addr_imem_host,
    input [31:0] data_imem_host,
    input [7:0]  addr_dmem_host,
    input [63:0] data_dmem_host,
    input        read_req_dmem,

    // HOST Expectations
    output        alu_result_detected,
    output [63:0] data_out_dmem,
    output [63:0] alu_out_intercept,
	 
	 // MEM stage outputs for GPU address decoder
    output [7:0]  mem_addr_out,    // me_alu_res[7:0] ? address being written
    output [63:0] mem_data_out,    // me_store_data ? data being written
    output        mem_we_out       // me_wme ? write enable
);

    // Feedback Paths
    wire [63:0] wb_wdata;      
    wire [3:0]  wb_waddr;      
    wire        wb_wena;
    wire [1:0]  wb_thread;  //for interfacing     
    wire        ex_take_branch; 
    wire [8:0]  ex_br_target;
	 wire [1:0]  ex_branch_thread;
	 wire	[8:0]  ex_br_addr;
    
    wire [8:0]  if_pc; 

    // --- STAGE 1: INSTRUCTION FETCH (IF) ---
    wire [31:0] if_instruction;
    wire [1:0]  if_curr_thread;

    ifetch_pseudoARM IF (
        .clk(clk), .rst(rst),
        .write_to_imem(write_to_imem),
        .addr_imem_host(addr_imem_host),
        .imem_data(data_imem_host),
        .take_branch(ex_take_branch),      
        .branch_target(ex_br_addr),
		  .branch_thread(ex_branch_thread),
        .instruction_out(if_instruction),
        .pc(if_pc),
        .curr_thread(if_curr_thread)
    );

    wire [1:0]  id_curr_thread;
    wire [8:0]  id_pc; 
    wire [31:0] id_inst;

    register_generate #(43) if_id_bridge (
        .clk(clk),
        .rst(rst),
        .d_in({if_curr_thread, if_pc, if_instruction}), // Pack both
        .q_out({id_curr_thread, id_pc, id_inst})        // Unpack all (lazy)
    );

    // --- STAGE 2: INSTRUCTION DECODE (ID) ---
    wire [63:0] id_r1data, id_r2data, id_alu_b;
    wire [3:0]  id_wreg_addr;
    wire        id_wreg_en, id_wmem_en, id_mem_read, id_mem_write, id_mem_to_reg, id_branch;
    wire [11:0] id_immediate;
    //wire [4:0]  id_shift;
    wire [3:0]  id_alu_ctrl;
    wire [3:0]  id_cond;
    wire [8:0]  id_br_addr;

    idecode ID (
        .clk(clk),
        .rst(rst),
        .id_inst(id_inst),
		  .id_pc(id_pc),
		  
		  .curr_thread(id_curr_thread),

        // Write-back feedback connections
        .wb_waddr(wb_waddr),
        .wb_wdata(wb_wdata),
        .wb_wena(wb_wena),
		  .wb_thread(wb_thread),

        // Data and Control Outputs
        .r1data(id_r1data),
        .r2data(id_r2data),
        .wreg_addr_out(id_wreg_addr),
        .wreg_en_out(id_wreg_en),
        .wmem_en_out(id_wmem_en),
        .alu_ctrl_out(id_alu_ctrl),
        .alu_b_out(id_alu_b),
        //.shift_out(id_shift),
        .immediate_out(id_immediate),
        .mem_to_reg_out(id_mem_to_reg),
        .mem_read_out(id_mem_read),
		.mem_write_out(id_mem_write),
        .branch(id_branch),
		  .branch_type(id_cond),
        .br_addr(id_br_addr)
    );

    // BRIDGE 2: ID/EX (107 bits)
    // Carry the Thread ID and the raw R2Data (Store Data) through the pipe
    wire [204:0] id_ex_d = {
        id_curr_thread,    // [204:203] 2 bits
        id_alu_ctrl,    // [202:199] 4 bits
        id_r1data,         // [198:135]  32 bits (Base Addr)
        id_alu_b,      // [134:71]   64 bits (Pre-muxed Offset)
        id_r2data,         // [70:7]    64 bits (RAW DATA FOR STORE)
        id_mem_to_reg, //[6]
        id_wmem_en,    //[5]
        id_wreg_addr,  // [4:1]     4 bits
        id_wreg_en     // [0]       1 bit
    };

    wire [204:0] id_ex_q;
	 //wire [4:0]   ex_shift;
	 wire [3:0]   ex_cond;
	 wire         ex_branch;
    register_generate #(219) id_ex_bridge (
        .clk(clk),
        .rst(rst),
        .d_in({id_br_addr, id_branch, id_cond, //id_shift, 
		  id_ex_d}),
        .q_out({ex_br_addr, ex_branch, ex_cond, //ex_shift, 
		  id_ex_q})
    );

    // --- STAGE 3: EXECUTE (EX) ---
    wire [1:0]  ex_curr_thread = id_ex_q[204:203];
    wire [3:0]  ex_alu_ctrl    = id_ex_q[202:199];
    wire [63:0] ex_r1data      = id_ex_q[198:135];
    wire [63:0] ex_alu_b       = id_ex_q[134:71];
    wire [63:0] ex_r2data      = id_ex_q[70:7];
    wire        ex_mem_to_reg  = id_ex_q[6];   
    wire        ex_wmem_en     = id_ex_q[5];   
    wire [3:0]  ex_waddr       = id_ex_q[4:1];
    wire        ex_wrege       = id_ex_q[0];
	 
	 assign ex_br_target = ex_br_addr;
	 assign ex_branch_thread = ex_curr_thread;
	     
    // ALU Instance
    wire [63:0] ex_alu_out;
    wire        ex_alu_zero;
    wire        ex_alu_negative;
    //wire        ex_alu_of;
    //wire        ex_alu_c;
    
    alu_64bitcpu ALU (
        .A(ex_r1data),
        .B(ex_alu_b),
        .Op(ex_alu_ctrl),
        //.shift(ex_shift),
        .Out(ex_alu_out),
        .zero(ex_alu_zero),
        .negative(ex_alu_negative)//,
        //.overflow(ex_alu_of),
        //.carry(ex_alu_c)
    );

    assign alu_out_intercept = ex_alu_out;

    // BRANCH SNIPPET
	 reg branch;
	 always @(*) begin
	    branch = 1'b0;
		 if (ex_branch) begin
			case (ex_cond)
				4'b0000: branch = ex_alu_zero;
				4'b0001: branch = !ex_alu_zero;
				4'b1010: branch = (ex_alu_negative == 1'b0);
				4'b1011: branch = (ex_alu_negative == 1'b1);
				4'b1110: branch = 1'b1;
				default: branch = 1'b0;
			endcase
		 end
	 end
	 
	 assign ex_take_branch = branch;
		 
	 wire [136:0] ex_me_d = {
        ex_curr_thread,  // [136:135]
        ex_alu_out,         // [134:71] Base + Offset
        ex_r2data,   // [70:7]  Store Data
        ex_wmem_en,      // [6]     
        ex_mem_to_reg,   // [5]     
        ex_waddr,    // [4:1]   
        ex_wrege       // [0]
    };

    // BRIDGE 3: EX/ME
    wire [136:0] ex_me_q;
    register_generate #(137) ex_me_bridge (
        .clk(clk), .rst(rst),
        .d_in(ex_me_d),
        .q_out(ex_me_q)
    );

    // --- STAGE 4: MEMORY (ME) ---
    wire [1:0]  me_curr_thread= ex_me_q[136:135];
    //wire        me_of         = ex_me_q[72];
    //wire        me_c          = ex_me_q[71];
    wire [63:0] me_alu_res    = ex_me_q[134:71];
    wire [63:0] me_store_data = ex_me_q[70:7];
    wire        me_wme        = ex_me_q[6];
    wire [63:0] dmem_raw_output;
	 
	 // At the bottom, wire them out
	 assign mem_addr_out = me_alu_res[7:0];
	 assign mem_data_out = me_store_data;
	 assign mem_we_out   = me_wme;
        
	 memoryCPU	 ME (
        .clk(clk),
		  .curr_thread(me_curr_thread),
        .write_to_dmem(write_to_dmem),
        .read_req_dmem(read_req_dmem),
        .addr_dmem_host(addr_dmem_host),
        .data_dmem_host(data_dmem_host),
        .pipeline_addr(me_alu_res[7:0]),
        .pipeline_data(me_store_data),
        .pipeline_we(me_wme),
        .dmem_out(dmem_raw_output)
    );
	
	// BRIDGE 3.5: ME >> ME2
	wire [72:0] me_me2_d = {
        me_wme,
		  me_curr_thread, // [71:70]
        me_alu_res,     // [69:6]
        ex_me_q[5],  // [5]
        ex_me_q[4:1],   // [4:1]
        ex_me_q[0]      // [0]
    };
     
	wire [72:0] me_me2_q;
	register_generate #(73) me_me2_bridge (
        .clk(clk), .rst(rst),
        .d_in(me_me2_d),
        .q_out(me_me2_q)
    );
	 
	wire [1:0] me2_curr_thread = me_me2_q[71:70];
	 
	assign data_out_dmem = dmem_raw_output;
   assign alu_result_detected = me_me2_q[72];

   wire [3:0] me2_waddr = me_me2_q[4:1];
    
	 // BRIDGE 4: ME >> WB (136 bits)
    wire [135:0] me_wb_d = {
        me2_curr_thread,  // me2_curr_thread [135:134]
        me_me2_q[69:6],   // alu_out, me2; [133:70]
        dmem_raw_output,  // [69:6] OUTPUT Data from BRAM
        me_me2_q[5],      // [5], mem_to_reg
        me_me2_q[4:1],    // [4:1] WADDR
        me_me2_q[0]       // [0] regenable
    };
    
    wire [135:0] me_wb_q;
    register_generate #(136) me_wb_bridge (
        .clk(clk), .rst(rst),
        .d_in(me_wb_d),
        .q_out(me_wb_q)
    );

    // --- STAGE 5: WRITE BACK (WB) ---
    assign wb_wdata = me_wb_q[5] ? me_wb_q[69:6] : me_wb_q[133:70]; //ARM supported mux, so to speak
    assign wb_waddr = me_wb_q[4:1];
    assign wb_wena  = me_wb_q[0];
    assign wb_thread= me_wb_q[135:134];

endmodule