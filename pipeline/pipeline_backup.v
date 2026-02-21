module pipeline_backup(
    input clk,
    input rst,

    //HOST interactions
    input write_to_imem,
    input write_to_dmem,
    input [8:0]  addr_imem_host,
    input [31:0] data_imem_host,
    input [7:0]  addr_dmem_host,
    input [31:0] data_dmem_host,

    input         read_req_dmem,
    output [31:0] data_out_dmem
);
    
    wire [31:0] instruction;
    wire [31:0] id_inst;

    // IF Stage Logic
    ifetch IF (
        .clk(clk),
        .rst(rst),
        .write_to_imem(write_to_imem),
        .addr_imem_host(addr_imem_host),
        .imem_data(data_imem_host),
        .instruction_out(instruction)
    );

    // IF/ID Bridge Register
    register_generate #(32) if_id (
        .clk(clk),
        .rst(rst),
        .d_in(instruction),
        .q_out(id_inst)
    );

    // WB signals
    wire [31:0] wb_data;
    wire [4:0]  wb_wreg_addr;
    wire        wb_wreg_en;

    // --- STAGE 2: DECODE ---
    wire [31:0] id_r1data, id_r2data;
    wire [4:0]  id_wreg_addr;
    wire        id_wreg_en, id_wmem_en;
    wire        id_mem_read;   // Memory read signal from pipeline

    // *** Added missing decode-generated control/immediate signals ***
    wire [31:0] id_sign_ext_imm;
    wire        id_mem_to_reg;
    wire        id_ALUSrc;
    wire [4:0]  id_shift;
    wire [3:0]  id_alu_ctrl;

    decode ID (
        .clk(clk),
        .rst(rst),
        .id_inst(id_inst),
        .wb_waddr(wb_wreg_addr),
        .wb_wdata(wb_data),
        .wb_wena(wb_wreg_en),
        .r1data(id_r1data),
        .r2data(id_r2data),
        .wreg_addr_out(id_wreg_addr),
        .wreg_en_out(id_wreg_en),
        .wmem_en_out(id_wmem_en),
        .mem_read_out(id_mem_read),

        // *** These must be driven by decode ***
        .sign_ext_imm_out(id_sign_ext_imm),
        .mem_to_reg_out(id_mem_to_reg),
        .ALUSrc_out(id_ALUSrc),
        .shift_out(id_shift),
        .alu_ctrl_out(id_alu_ctrl)
    );

    // --- BRIDGE 2: ID/EX ---
    // New: 32+32+32+5+1+1+1+1+1+5+4 = 115 bits (added 2 bits for 5-bit wreg)
    wire [114:0] id_ex_q;

    register_generate #(115) id_ex_bridge (
        .clk(clk),
        .rst(rst),
        .d_in({
        id_r1data,         
        id_r2data,         
        id_sign_ext_imm,   
        id_wreg_addr,      
        id_wreg_en,        
        id_wmem_en,        
        id_mem_to_reg,     
        id_mem_read,       
        id_ALUSrc,         
        id_shift,          
        id_alu_ctrl        
        }),
        .q_out(id_ex_q)
    );


    // --- STAGE 3: EXEC ---
    wire [31:0] id_ex_r1           = id_ex_q[114:83];
    wire [31:0] id_ex_r2           = id_ex_q[82:51];
    wire [31:0] id_ex_sign_ext_imm = id_ex_q[50:19];

    wire [4:0]  id_ex_wreg         = id_ex_q[18:14];
    wire        id_ex_wreg_en      = id_ex_q[13];
    wire        id_ex_wmem_en      = id_ex_q[12];
    wire        id_ex_mem_to_reg   = id_ex_q[11];
    wire        id_ex_mem_read     = id_ex_q[10];
    wire        id_ex_ALUSrc       = id_ex_q[9];

    wire [4:0]  id_ex_shift        = id_ex_q[8:4];
    wire [3:0]  id_ex_alu_ctrl     = id_ex_q[3:0];

    // ALU source MUX
    wire [31:0] alu_B = id_ex_ALUSrc ? id_ex_sign_ext_imm : id_ex_r2;

    // ALU Output
    wire [31:0] alu_out;

    alu_32bit alu_unit (
        .A(id_ex_r1),
        .B(alu_B),
        .Op(id_ex_alu_ctrl),
        .shift(id_ex_shift),
        .Out(alu_out)
    );

    // --- BRIDGE 3: EX/ME 
    //   - ALU result = ADDRESS for data memory   (Corrected comment)
    //   - id_ex_r2    = STORE DATA (from regfile second port)
    // Bundle format (69 bits total):
    // { alu_result[32], store_data[32], WReg[3], WRE[1], WME[1] }
    // New: 32+32+5+1+1+1+1 = 73 bits
    wire [72:0] ex_me_bundle;

    register_generate #(73) ex_me_bridge (   // *** Fixed from #(70) to #(71) ***
        .clk(clk),
        .rst(rst),
        .d_in({
            alu_out,            
            id_ex_r2,           
            id_ex_wreg,         
            id_ex_wreg_en,      
            id_ex_wmem_en,      
            id_ex_mem_to_reg,   
            id_ex_mem_read      
        }),
        .q_out(ex_me_bundle)
    );

    // --- STAGE 4: MEMORY (ME) ---
    // Corrected slicing for 69-bit bundle {R1[32], R2[32], WReg[3], WRE[1], WME[1]}
    //   me_alu_result = MEMORY ADDRESS (corrected meaning)
    //   me_store_data = STORE WRITE DATA (corrected meaning)
    wire [31:0] me_alu_result = ex_me_bundle[72:41];
    wire [31:0] me_store_data = ex_me_bundle[40:9];
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
        .data_dmem_host(data_dmem_host),
        .pipeline_addr(me_alu_result),
        .pipeline_data(me_store_data),
        .pipeline_we(me_wme),
        .dmem_out(dmem_raw_output)
    );

    assign data_out_dmem = dmem_raw_output[31:0];

    // --- BRIDGE 4: ME/WB ---
    // New: 32+5+1 = 38 bits
    wire [37:0] me_wb_bundle;

    assign wb_data      = me_wb_bundle[37:6];
    assign wb_wreg_addr = me_wb_bundle[5:1];
    assign wb_wreg_en   = me_wb_bundle[0];

    // --- STAGE 5: WB
    // Strengthened condition: memory data only selected when both MemToReg AND MemRead are asserted
    wire [31:0] wb_result =
        (me_mem_to_reg && me_mem_read)
            ? dmem_raw_output[31:0]
            : me_alu_result;

    register_generate #(38) me_wb_bridge (
        .clk(clk),
        .rst(rst),
        .d_in({wb_result, me_wreg, me_wre}),
        .q_out(me_wb_bundle)
    );

endmodule
