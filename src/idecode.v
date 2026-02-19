module decode (
    input clk,
    input rst,
    input [31:0] id_inst,           // From IF/ID bridge 
    
    // Write-back interface (feedback loop from WB stage) 
    input [2:0]  wb_waddr,          // WReg1 from WB stage
    input [31:0] wb_wdata,          // Data from WB stage
    input        wb_wena,           // WRegEn from WB stage
    
    // Outputs to ID/EX bridge 
    output [31:0] r0data,           // Data from Reg1
    output [31:0] r1data,           // Data from Reg2
    output [2:0]  wreg_addr_out,    // Propagated destination address
    output        wreg_en_out,      // Propagated WRegEn
    output        wmem_en_out       // Propagated WMemEn
);

    // 1. Instruction Parsing (Part 3 Format) 
    wire       wmem_en = id_inst[31];
    wire       wreg_en = id_inst[30];
    wire [2:0] reg1    = id_inst[29:27];
    wire [2:0] reg2    = id_inst[26:24];
    wire [2:0] wreg1   = id_inst[23:21];

    // 2. Register File Instance
    registerFile32 rf_inst (
        .clk(clk),
        .clr(rst),                  // Connected to global reset 
        .r0addr(reg1),
        .r1addr(reg2),
        .waddr(wb_waddr),
        .wdata(wb_wdata),
        .wena(wb_wena),
        .r0data(r0data),
        .r1data(r1data)
    );

    // 3. Drive Outputs for the next stage bridge 
    assign wreg_addr_out = wreg1;
    assign wreg_en_out   = wreg_en;
    assign wmem_en_out   = wmem_en;

endmodule