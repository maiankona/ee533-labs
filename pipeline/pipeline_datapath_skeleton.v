`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:42:36 02/12/2026 
// Design Name: 
// Module Name:    pipeline_datapath_skeleton 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////


module pipeline_datapath_skeleton(
    input clk,
    input rst,
	 input  [31:0] mem_addr_reg,
	 input  [31:0] mem_cmd_reg,
	 input  [31:0] mem_data_write_reg,
	 output reg [31:0] mem_data_read_reg
    );

    //STAGE 1: IF
    //INIT
    reg [31:0] pc;
	 reg instr_wr_en_latched;
	 reg instr_wr_en_prev;
	 reg instr_wr_pulse_if_id;
	 reg [31:0] prog_data_mem_addr;  // registered data memory address
	 reg [31:0] prog_instr_mem_addr;	// registered instr memory address
	 reg [31:0] prog_data_mem_in;  // registered data memory address
	 reg [31:0] prog_instr_mem_in;	// registered instr memory address
	 reg exec_mode_delay;
	 reg pc_halt_delay;
	 reg [31:0] if_id;
	 reg [31:0] if_id_pc_plus_1;   // PC+1 from IF stage (for branch target in ID)

	 // Stage registers MEM / WB
	 reg mem_wb_WMemEn;
	 reg [2:0] mem_wb_WR1;
	 reg [31:0] mem_wb_alu_result, mem_wb_mem_data;
	 reg        mem_to_reg;
	 reg mem_wb_WRegEn;
	 // Write-back Mux output (combinational): ALU result or memory read data (P&H style)
	 wire [31:0] wb_data = mem_to_reg? mem_wb_mem_data : mem_wb_alu_result;
	 
	 //EX/MEM registers
    reg [31:0] ex_me_r1, ex_me_r2;
    reg        ex_me_WRegEn, ex_me_WMemEn, ex_me_is_load;
    reg [2:0]  ex_me_WR1;

    // NEW: delayed pulse used for program_mode (freeze) control
    reg instr_wr_pulse_d;

    // NEW: two-stage capture + write-enable registers to ensure address/data stable when we asserted
    reg prog_valid;             // set when we capture user addr/data
    reg instr_wr_we_reg;        // single-cycle write enable to IMEM (registered)
    
    wire instr_wr_en;
    wire data_wr_en;
	 wire local_WMemEn;
	 wire pc_halt;
	 wire program_mode;
	 wire exec_mode;
	 wire instr_wr_pulse;           // original edge detect (kept for compatibility)
	 wire instr_wr_pulse_enable;    // gated pulse (unused for final .we, but preserved)
	 wire data_wr_pulse;
	 wire [31:0] imem_addr;
	 wire cpu_enable;
	 
    wire [31:0] instr_mem_out;
    wire [31:0] instr_mem_in;
	 wire [31:0] data_mem_in;
    wire [31:0] data_mem_addr;
    wire [31:0] instr_mem_addr;
    wire [31:0] command_in;
	 wire [31:0] local_mem_data;
	 wire [31:0] local_mem_addr; 
    
    assign command_in = mem_cmd_reg;    // receives command from outside
    assign instr_wr_en = command_in[5]; // writes into instr. mem if bit-5 = 0
    assign data_wr_en = command_in[6]; // writes into data. mem if bit-6 = 1
    assign cpu_enable = mem_cmd_reg[7]; // If low, halt CPU
    assign instr_mem_in = mem_data_write_reg;   // internal instr from user-SW
	 assign data_mem_in = mem_data_write_reg;
	 /* imem_addr selects program address while the delayed program-mode pulse is active,
	    otherwise normal PC fetch address. For writes we use the registered write-enable
	    and the captured prog_instr_mem_addr so address/data are stable when the core sees .we. */
	 assign imem_addr = (instr_wr_we_reg) ? prog_instr_mem_addr : pc;

	 // PC Mux (P&H style): next PC = PC+4 or branch target
	 wire [31:0] pc_plus_1 = pc + 1;
	 wire [31:0] branch_target = if_id_pc_plus_1 + sign_ext_imm; 
	 wire [31:0] next_pc = PCSrc ? branch_target : pc_plus_1;
    
	 assign local_WMemEn = data_wr_en ?  data_wr_en : ex_me_WMemEn; 
	 assign local_mem_data = prog_instr_mem_in;
	 assign local_mem_addr = prog_data_mem_addr;

	 assign program_mode = instr_wr_pulse_d;   // <-- use delayed pulse here
	 assign exec_mode = ~program_mode;
	 /* edge detect: instr_wr_pulse is 1 clock when SW asserted instr_wr_en.
	    instr_wr_pulse_enable gates that pulse until reset_cnt has reached 2. */
	 assign instr_wr_pulse = instr_wr_en_latched & ~instr_wr_en_prev; // Toggles write for once cycle upon software input
	 assign instr_wr_pulse_enable = instr_wr_pulse;

    always @(posedge clk or posedge rst) begin
        if (rst) 
        begin
            pc <= 32'b0;
            mem_data_read_reg <= 32'b0; // signal goes to HW registers
				instr_wr_en_latched <= 1'b0;
				instr_wr_en_prev <= 1'b0;
				prog_data_mem_addr <= 32'b0;	
				prog_instr_mem_addr <= 32'b0;
				prog_data_mem_in <= 32'b0;
		      prog_instr_mem_in <= 32'b0;
				instr_wr_pulse_if_id <= 1'b0;
				exec_mode_delay <= 1'b0;
            instr_wr_pulse_d <= 1'b0;
//				pc_halt_delay <= 1'b0;
            // new regs init:
            prog_valid <= 1'b0;
            instr_wr_we_reg <= 1'b0;
		  end
		  else begin

				// synchronization of incoming SW control bit
				instr_wr_en_latched <= instr_wr_en;
				instr_wr_en_prev <= instr_wr_en_latched;
				exec_mode_delay <= exec_mode;
                
            // update delayed pulse (one-cycle delay) from the ENABLED pulse
            instr_wr_pulse_d <= instr_wr_pulse_enable;
//				pc_halt_delay <= pc_halt;
				
				if (instr_wr_en && !cpu_enable) begin
				    prog_instr_mem_addr <= mem_addr_reg;
				    prog_instr_mem_in   <= instr_mem_in;
				    prog_valid <= 1'b1;    // indicates captured and pending write
				end
				else begin
				    // if prog_valid was set last cycle, it will be consumed below by instr_wr_we_reg
				    // if not, keep prog_valid low
				    if (!instr_wr_we_reg)
				        prog_valid <= 1'b0;
				end

				// instr_wr_we_reg pulses for one cycle when prog_valid was set the previous cycle.
				// This ensures prog_instr_mem_addr/prog_instr_mem_in were written in the prior clock
				// and are stable for the actual memory write here.
				instr_wr_we_reg <= prog_valid;

				// keep IF/ID signal for observation (unchanged semantics)
				if (instr_wr_pulse_enable && !cpu_enable) begin
					instr_wr_pulse_if_id <= 1'b1;
				end
				else begin
					instr_wr_pulse_if_id <= 1'b0;
				end
				// ---------------------------------------------------------

				if (data_wr_en) begin
					// For data writes we capture SW address/data when SW asserts data_wr_en.
					// Note: if you want a pulse-per-write model for data mem too, apply similar gating.
					prog_data_mem_addr <= mem_addr_reg;
					prog_data_mem_in <= data_mem_in;
				end
				else begin
					prog_data_mem_in <= ex_me_r2;
					prog_data_mem_addr <= ex_me_alu_result[7:0];  // ALU result = effective address for load/store
				end
				
				
				if (exec_mode) begin
					// freeze PC during program_mode; PC Mux selects next_pc (PC+4 or branch target)
					if (cpu_enable)
						pc <= next_pc;
					mem_data_read_reg <= if_id; // pass internal signal from the instruction memory to external reg
				end
		  end	
    end

    // I-MEM CORE (Part 2) placeholder
    mem32bit512Dual imem_blk (        
		.addr(imem_addr),
        .clk(clk),
		.din(prog_instr_mem_in),
        .dout(instr_mem_out),
		.we(instr_wr_we_reg)    // assert the actual write only when the registered we is high
		);
    
    //registers for IF/ID
    always @(posedge clk or posedge rst)
    if (rst) begin
        if_id <= 0;
        if_id_pc_plus_1 <= 0;
    end
    else if (exec_mode_delay) begin
        if_id <= instr_mem_out;
        if_id_pc_plus_1 <= pc_plus_1;
    end
	 // otherwise no assignment: register holds value
    
    //STAGE 2: ID
    //INIT
    wire [31:0] rf_r1, rf_r2;
    wire [3:0]  alu_ctrl;        // ALU uses 4-bit Op
    wire [4:0]  id_shift;        // ALU's 5-bit shift
    wire        WRegEn, WMemEn, ALUSrc; 
    wire [2:0]  WR1;
	 wire [2:0] Reg1_addr, Reg2_addr; //additional declaration

    // EXPECTED BIT DISTRIBUTION: the 32-bit instruction into 3-bit parts
    assign WMemEn   = if_id[31];      // Bit 31: WMeEn
    assign WRegEn   = if_id[30];      // Bit 30: WReEn
    assign Reg1_addr= if_id[29:27];   // Bits 29-27: Reg1 (3 bits)
    assign Reg2_addr= if_id[26:24];   // Bits 26-24: Reg2 (3 bits)
    assign WR1      = if_id[23:21];   // Bits 23-21: WReg1 (3 bits)
	// ALUSrc: select second ALU operand (0 = Read data 2, 1 = sign-extended immediate)
    assign ALUSrc = if_id[16];

    //using the unused bits over here
    assign alu_ctrl = if_id[20:17];   // OPCODE
    assign id_shift = if_id[10:6];    // SHIFT
	
	// NEW: Branch decoding
	wire branch     = if_id[25];
	wire brType     = if_id[24];
	
	// 16-bit immediate (IR[15:0]) -> 32-bit sign-extended (P&H style)
	wire [15:0] imm_16 = if_id[15:0];
	wire [31:0] sign_ext_imm = {{16{imm_16[15]}}, imm_16};
	
	// Branch condition evaluation
	wire zero = (rf_r1 == rf_r2);
	wire less_than = ($signed(rf_r1) < $signed(rf_r2));
	
	// Branch decision logic
	wire branch_taken = branch & ((brType == 1'b0 & zero) |        // BEQ/B
								  (brType == 1'b1 & less_than));   // BLT
	
	wire PCSrc = branch_taken;
	
	// Branch target: PC + sign_ext_imm
	wire [31:0] branch_target = if_id_pc_plus_1 + sign_ext_imm; 
	
    // Added is_load logic for downstream Mux
    wire id_is_load = (WRegEn == 1'b1 && WMemEn == 1'b0); //SO IS_LOAD IS INTENDED LOGIC FOR THE LOAD INSTRUCTIONS
    wire negEdgeClk;
	 
	 assign negEdgeClk = ~clk;
	 
    // This is the "Reference" to the .v module
    registerFile32 rf_inst (
        .clk    (clk),
        .clr    (rst),
        .r0addr (if_id[29:27]),  // Reg1 from instruction 
        .r1addr (if_id[26:24]),  // Reg2 from instruction 
        .waddr  (mem_wb_WR1),    // Propagated write address from WB stage
        .wdata  (wb_data),       // Data to be written back
        .wena   (mem_wb_WRegEn), // Write enable signal from mem / WB stage register
        .r0data (rf_r1),         // Output to ID/EX register
        .r1data (rf_r2)          // Output to ID/EX register
    );
    
    //registers for ID/EX
    //INIT
    reg [31:0] id_ex_r1, id_ex_r2;
    reg [31:0] id_ex_sign_ext_imm;
    reg        id_ex_ALUSrc;
    reg [3:0]  id_ex_alu_ctrl;
    reg [4:0]  id_ex_shift;
    reg        id_ex_WRegEn, id_ex_WMemEn, id_ex_is_load;
    reg [2:0]  id_ex_WR1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            id_ex_WRegEn <= 0; id_ex_WMemEn <= 0; id_ex_is_load <= 0;
        end 
		  
		  else if (exec_mode) begin
            id_ex_r1            <= rf_r1;
            id_ex_r2            <= rf_r2;
            id_ex_sign_ext_imm  <= sign_ext_imm;
            id_ex_ALUSrc        <= ALUSrc;
            id_ex_alu_ctrl      <= alu_ctrl;
            id_ex_shift         <= id_shift;
            id_ex_WRegEn        <= WRegEn;
            id_ex_WMemEn        <= WMemEn;
            id_ex_WR1           <= WR1;
            id_ex_is_load       <= id_is_load; 
        end
				// Freeze
    end
    
    //STAGE 3: EX
    // ALU second operand Mux: B = register (id_ex_r2) or sign-extended immediate (P&H style)
    wire [31:0] alu_B = id_ex_ALUSrc ? id_ex_sign_ext_imm : id_ex_r2;

    wire [31:0] alu_out;
    alu_32bit alu_unit (
        .clk     (clk),
        .reset   (rst),
        .A       (id_ex_r1),
        .B       (alu_B),
        .Op      (id_ex_alu_ctrl),
        .shift   (id_ex_shift),
        .Out     (alu_out)
    );

    // EX/MEM pipeline register: add ALU result (for WB mux and for data memory address)
    reg [31:0] ex_me_alu_result;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ex_me_WRegEn <= 0; ex_me_WMemEn <= 0;
        end 
		  
		  else if (exec_mode) begin
            ex_me_alu_result <= alu_out;
            ex_me_r1         <= id_ex_r1;
            ex_me_r2         <= id_ex_r2;
            ex_me_WRegEn     <= id_ex_WRegEn;
            ex_me_WMemEn     <= id_ex_WMemEn;
            ex_me_WR1        <= id_ex_WR1;
            ex_me_is_load    <= id_ex_is_load;
        end
    end

    //STAGE 4: MEM
    wire [63:0] dme_dout;
    // D-MEM IP CORE (Part 2) placeholder
    mem64bit256 dmem_blk (
        .clka(clk),
        .wea(local_WMemEn),
        .addra(local_mem_addr),
        .dina({32'b0,local_mem_data}), // Zero-padding for 32-bit data, AS PER INSTRUCTIONS. 50% DEADSPACE
        .clkb(clk),
        .addrb(8'b0),             // Second port unused for basic CPU
        .doutb(dme_dout)          // 64-bit output [cite: 33]
    );    
	
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			mem_wb_WMemEn <= 0;
			mem_wb_WR1 <= 0;
			mem_wb_WRegEn <= 0;
			mem_wb_alu_result <= 0;
			mem_wb_mem_data <= 0;
			mem_to_reg <= 0;
		end
		else if (exec_mode) begin
			mem_wb_WMemEn      <= ex_me_WMemEn;
			mem_wb_WR1         <= ex_me_WR1;
			mem_wb_WRegEn      <= ex_me_WRegEn;
			mem_wb_alu_result  <= ex_me_alu_result;
			mem_wb_mem_data    <= dme_dout[31:0];
			mem_to_reg     <= ex_me_is_load;
		end
	end
	

endmodule



