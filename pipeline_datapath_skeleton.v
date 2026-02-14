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
    input rst
    );

    //STAGE 1: IF
    //INIT
    reg [31:0] pc;               
    wire [31:0] pc_1;
    wire [31:0] instruction;
    
    assign pc_1 = pc;        // PC+1 according to the image

    always @(posedge clk or posedge rst) begin
        if (rst) pc <= 32'b0;
        else     
			begin
				pc <= pc_1 + 1;
			end
    end
    
    // I-MEM CORE (Part 2) placeholder
    mem32bit512 imem_blk (
        .clk(clk),
        .addr(pc_1[8:0]), 
        .dout(instruction)
    );
    
    //registers for IF/ID
    reg [31:0] if_id;
    always @(posedge clk) begin
        if (rst) if_id <= 32'b0;
        else     if_id <= instruction;
    end
    
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
    
    // This is the "Reference" to the .v module
    registerFile32 rf_inst (
        .clk    (clk),
        .clr    (rst),
        .r0addr (if_id[29:27]),  // Reg1 from instruction 
        .r1addr (if_id[26:24]),  // Reg2 from instruction 
        .waddr  (me_wb_WR1),    // Propagated write address from WB stage
        .wdata  (wb_data),       // Data to be written back
        .wena   (me_wb_WRegEn), // Write enable signal from WB stage
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
    
    always @(posedge clk) begin
        if (rst) begin
            id_ex_WRegEn <= 0; id_ex_WMemEn <= 0; id_ex_is_load <= 0;
        end else begin
            id_ex_r1       <= rf_r1;
            id_ex_r2       <= rf_r2;
            id_ex_alu_ctrl <= alu_ctrl;
            id_ex_shift    <= id_shift;
            id_ex_WRegEn   <= WRegEn;
            id_ex_WMemEn   <= WMemEn;
            id_ex_WR1      <= WR1;
            id_ex_is_load  <= id_is_load; 
        end
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
    reg [31:0] ex_me_result, ex_me_r2;
    reg        ex_me_WRegEn, ex_me_WMemEn, ex_me_is_load;
    reg [2:0]  ex_me_WR1;
    
    always @(posedge clk) begin
        if (rst) begin
            ex_me_WRegEn <= 0; ex_me_WMemEn <= 0;
        end else begin
            //ex_me_result  <= alu_out;
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
        .wea(ex_me_WMemEn),
        .addra(ex_me_result[7:0]),
        .dina({32'b0, ex_me_r2}), // Zero-padding for 32-bit data, AS PER INSTRUCTIONS. 50% DEADSPACE
        .clkb(clk),
        .addrb(8'b0),             // Second port unused for basic CPU
        .doutb(dme_dout)          // 64-bit output [cite: 33]
    );    

	// Stage registers MEM / WB
	reg mem_wb_WMemEn;
	reg mem_wb_WR1;
	reg [63:0] mem_wb_dout;
	
	always@(posedge clk) begin
	if (rst)
		begin
		mem_wb_WMemEn <= 0;
		mem_wb_WR1 <= 0;
		mem_wb_dout <= 0;
		end
		else begin
			mem_wb_WMemEn <= ex_me_WMemEn;
			mem_wb_WR1 <= ex_me_WR1;
			mem_wb_dout <= dme_dout;
		end
	 end
	

endmodule
