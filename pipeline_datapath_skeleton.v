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
    
    wire instr_wr_en;
    wire data_wr_en;
	 wire local_WMemEn;
	 wire pc_halt;
	 wire program_mode;
	 wire exec_mode;
	 
    wire [31:0] instr_mem_out;
    wire [31:0] instr_in;
    wire [31:0] data_mem_addr;
    wire [31:0] instr_mem_addr;
    wire [31:0] command_in;
	 wire [31:0] local_mem_data;
	 wire [31:0] local_mem_addr; 
    
    assign command_in = mem_cmd_reg;    // receives command from outside
    assign instr_wr_en = command_in[5]; // writes into instr. mem if bit-5 = 0
    assign data_wr_en = command_in[6]; // writes into data. mem if bit-6 = 1
    assign instr_in = mem_data_write_reg;   // internal instr from user-SW
    
	 assign local_WMemEn = data_wr_en ?  data_wr_en : ex_me_WMemEn; 
	 assign local_mem_data = data_wr_en ? instr_in : ex_me_r2;
	 assign local_mem_addr = data_wr_en ? data_mem_addr : ex_me_r1[7:0];
	 assign instr_mem_addr = (instr_wr_en) ? mem_addr_reg : pc;
	 assign data_mem_addr  = (data_wr_en)  ? mem_addr_reg : pc;
	 assign program_mode = instr_wr_en_latched;
	 assign pc_halt = program_mode;
	 assign exec_mode = ~program_mode;

    always @(posedge clk or posedge rst) begin
        if (rst) 
        begin
            pc <= 32'b0;
            mem_data_read_reg <= 32'b0; // signal goes to HW registers
				instr_wr_en_latched <= 1'b0;
        end
		  else begin
				instr_wr_en_latched <= instr_wr_en;		 
				if (exec_mode) begin
					if (~pc_halt)		// If writing instr, halt PC counter
						pc <= pc + 1;  // PC from cycle 0
					mem_data_read_reg <= instr_mem_out; // pass internal signal from the instruction memory to external reg
				end
		  end	
    end

    // I-MEM CORE (Part 2) placeholder
    mem32bit512Dual imem_blk (        
		.addr(instr_mem_addr),
        .clk(clk),
		.din(instr_in),
        .dout(instr_mem_out),
		.we(instr_wr_en_latched)
		);
    
    //registers for IF/ID
    reg [31:0] if_id;
    always @(posedge clk or posedge rst)
    if (rst)
        if_id <= 0;
    else if (exec_mode)
        if_id <= instr_mem_out;
        
	 // otherwise no assignment → register holds value
    
    //STAGE 2: ID
    //INIT
    wire [31:0] rf_r1, rf_r2;
    wire [3:0]  alu_ctrl;        // ALU uses 4-bit Op
    wire [4:0]  id_shift;        // ALU's 5-bit shift
    wire        WRegEn, WMemEn; 
    wire [2:0]  WR1;
	 wire [2:0] Reg1_addr, Reg2_addr; //additional declaration

    // EXPECTED BIT DISTRIBUTION: the 32-bit instruction into 3-bit parts
    assign WMemEn   = if_id[31];      // Bit 31: WMeEn
    assign WRegEn   = if_id[30];      // Bit 30: WReEn
    assign Reg1_addr= if_id[29:27];   // Bits 29-27: Reg1 (3 bits)
    assign Reg2_addr= if_id[26:24];   // Bits 26-24: Reg2 (3 bits)
    assign WR1      = if_id[23:21];   // Bits 23-21: WReg1 (3 bits)

    //using the unused bits over here
    assign alu_ctrl = if_id[20:17];   // OPCODE
    assign id_shift = if_id[10:6];    // SHIFT

    // Added is_load logic for downstream Mux
    wire id_is_load = (WRegEn == 1'b1 && WMemEn == 1'b0); //SO IS_LOAD IS INTENDED LOGIC FOR THE LOAD INSTRUCTIONS
    wire negEdgeClk;
	 
	 assign negEdgeClk = ~clk;
	 
    // This is the "Reference" to the .v module
    registerFile32 rf_inst (
        .clk    (negEdgeClk),
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
    reg [3:0]  id_ex_alu_ctrl;
    reg [4:0]  id_ex_shift;
    reg        id_ex_WRegEn, id_ex_WMemEn, id_ex_is_load;
    reg [2:0]  id_ex_WR1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            id_ex_WRegEn <= 0; id_ex_WMemEn <= 0; id_ex_is_load <= 0;
        end 
		  
		  else if (exec_mode) begin
            id_ex_r1       <= rf_r1;
            id_ex_r2       <= rf_r2;
            id_ex_alu_ctrl <= alu_ctrl;
            id_ex_shift    <= id_shift;
            id_ex_WRegEn   <= WRegEn;
            id_ex_WMemEn   <= WMemEn;
            id_ex_WR1      <= WR1;
            id_ex_is_load  <= id_is_load; 
        end
				// Freeze
    end
    
	 /*
    //STAGE 3: EX
    wire [31:0] alu_out;
    alu_32bit alu_unit ( //THIS IS CONFIRMED TO CALL APPROPRIATELY
        .clk     (clk),
        .reset   (rst),
        .A       (id_ex_r1),
        .B       (id_ex_r2),
        .Op      (id_ex_alu_ctrl),
        .shift   (id_ex_shift),
        .Out     (alu_out)
    );
    */
	 
    //EX/MEM registers
    //INIT
    reg [31:0] ex_me_r1, ex_me_r2;
    reg        ex_me_WRegEn, ex_me_WMemEn, ex_me_is_load;
    reg [2:0]  ex_me_WR1;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ex_me_WRegEn <= 0; ex_me_WMemEn <= 0;
        end 
		  
		  else if (exec_mode) begin
            //ex_me_result  <= alu_out;
            ex_me_r1		  <= id_ex_r1;
            ex_me_r2      <= id_ex_r2;
            ex_me_WRegEn  <= id_ex_WRegEn;
            ex_me_WMemEn  <= id_ex_WMemEn;
            ex_me_WR1     <= id_ex_WR1;
            ex_me_is_load <= id_ex_is_load;
        end
    end

    //STAGE 4: ME
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

	// Stage registers MEM / WB
	reg mem_wb_WMemEn;
	reg [2:0] mem_wb_WR1;
	reg [63:0] wb_data;
	reg mem_wb_WRegEn;
	
	always@(posedge clk or posedge rst) begin
	if (rst)
		begin
		mem_wb_WMemEn <= 0;
		mem_wb_WR1 <= 0;
		mem_wb_WRegEn <= 0;
		wb_data <= 0;
		end
		else if (exec_mode) begin
			mem_wb_WMemEn <= ex_me_WMemEn;
			mem_wb_WR1 <= ex_me_WR1;
			mem_wb_WRegEn <= ex_me_WRegEn;
			wb_data <= dme_dout[31:0];
		end
	 end
	

endmodule
