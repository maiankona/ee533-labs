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

    input        read_req_dmem,
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

    // --- STAGE 2: DECODE ---
    wire [31:0] id_r0data, id_r1data;
    wire [2:0]  id_wreg_addr;
    wire        id_wreg_en, id_wmem_en;

    decode ID (
        .clk(clk),
        .rst(rst),
        .id_inst(id_inst),
        .wb_waddr(wb_wreg_addr),
        .wb_wdata(wb_data),
        .wb_wena(wb_wreg_en),
        .r0data(id_r0data),
        .r1data(id_r1data),
        .wreg_addr_out(id_wreg_addr),
        .wreg_en_out(id_wreg_en),
        .wmem_en_out(id_wmem_en)
    );

    // --- BRIDGE 2: ID/EX (69 bits) ---
    wire [68:0] id_ex_q;
    register_generate #(69) id_ex_bridge (
        .clk(clk),
        .rst(rst),
        .d_in({id_r0data, id_r1data, id_wreg_addr, id_wreg_en, id_wmem_en}),
        .q_out(id_ex_q)
    );

    // --- BRIDGE 3: EX/ME (Skeletal Passthrough) ---
    wire [68:0] ex_me_bundle;
    register_generate #(69) ex_me_bridge (
        .clk(clk),
        .rst(rst),
        .d_in(id_ex_q),
        .q_out(ex_me_bundle)
    );

    // --- STAGE 4: MEMORY (ME) ---
    // Corrected slicing for 69-bit bundle {R1[32], R2[32], WReg[3], WRE[1], WME[1]}
    wire [31:0] me_r1data = ex_me_bundle[68:37];
    wire [31:0] me_r2data = ex_me_bundle[36:5];
    wire [2:0]  me_wreg   = ex_me_bundle[4:2];
    wire        me_wre    = ex_me_bundle[1];
    wire        me_wme    = ex_me_bundle[0];

    wire [63:0] dmem_raw_output;

    memory ME (
        .clk(clk),
        .write_to_dmem(write_to_dmem),
        .read_req_dmem(read_req_dmem),   // Connect new signal
        .addr_dmem_host(addr_dmem_host),
        .data_dmem_host(data_dmem_host),
        .pipeline_addr(me_r1data),      // From EX/ME Bridge [cite: 11]
        .pipeline_data(me_r2data),      // From EX/ME Bridge [cite: 12]
        .pipeline_we(me_wme),           // From EX/ME Bridge [cite: 14]
        .dmem_out(dmem_raw_output)
    );

    // Route memory output to top level for host/testbench access
    assign data_out_dmem = dmem_raw_output[31:0];

    // --- BRIDGE 4: ME/WB ---
    // Width: 32 (Data) + 3 (WReg) + 1 (WRegEn) = 36 bits
    wire [35:0] me_wb_bundle;
    register_generate #(36) me_wb_bridge (
        .clk(clk),
        .rst(rst),
        .d_in({dmem_raw_output[31:0], me_wreg, me_wre}),
        .q_out(me_wb_bundle)
    );

    //WB mux, but instead just a bunch of assigns for now
    //wire [31:0] wb_data;
    //wire [2:0]  wb_wreg_addr;
    //wire        wb_wreg_en;
    
    // WB Stage Feedback
    assign wb_data      = me_wb_bundle[35:4];
    assign wb_wreg_addr = me_wb_bundle[3:1];
    assign wb_wreg_en   = me_wb_bundle[0];

endmodule