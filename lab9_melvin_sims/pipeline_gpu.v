`timescale 1ns / 1ps
module pipeline_gpu (
    input clk,
    input rst,

    input        write_to_imem,
    input        write_to_dmem,
    input [8:0]  addr_imem_host,
    input [31:0] data_imem_host,
    input [7:0]  addr_dmem_host,
    input [31:0] data_dmem_host,
    input        read_req_dmem,

    input        gpu_start,
    input [7:0]  bram_inst_addr,
    input [7:0]  bram_length,

    output [63:0] data_out_dmem,
    output reg [63:0] tensor_out_intercept,
    output        pipeline_done
);

    wire [31:0] instruction;
    wire [31:0] id_inst;
    wire [8:0]  pc_plus_1;
    wire        PCSrc;
    wire [8:0]  branch_target;
    wire        stall_hzd;
    wire        stall;
    wire        fwd_rd_en;

    // =========================================================
    // GPU Execution Lifecycle
    // =========================================================
    reg       loading;
    reg       fetch_active;
    reg       fetch_active_d;
    reg [8:0] pc_end_r;
    reg       gpu_start_r;
    reg [7:0] bram_inst_addr_r;
    reg [7:0] bram_length_r;      // latched on gpu_start_r
	 reg		  tensor_done_r;

    always @(posedge clk) begin
        if (rst) begin
            loading          <= 1'b0;
            fetch_active     <= 1'b0;
            fetch_active_d   <= 1'b0;
            pc_end_r         <= 9'h000;
            gpu_start_r      <= 1'b0;
            bram_inst_addr_r <= 8'h00;
            bram_length_r    <= 8'h00;
        end else begin
            fetch_active_d <= fetch_active;

            if (write_to_imem)
                loading <= 1'b1;
            else if (gpu_start)
                loading <= 1'b0;

            gpu_start_r      <= gpu_start;
            bram_inst_addr_r <= bram_inst_addr;

            if (gpu_start_r) begin
                fetch_active  <= 1'b1;
                bram_length_r <= bram_length;
                pc_end_r      <= {1'b0, bram_inst_addr_r} + {1'b0, bram_length} - 9'd1;
            end else if (fetch_active && (pc_plus_1 > pc_end_r)) begin
                fetch_active <= 1'b0;
            end
        end
    end

    // =========================================================
    // Instruction counter
    // Counts cycles fetch_active is high ? one instruction per cycle.
    // Resets on gpu_start_r so it starts counting from the first fetch.
    // pipeline_done uses this to know all instructions have been issued.
    // =========================================================
    reg [7:0] instr_count;

    always @(posedge clk) begin
        if (rst || gpu_start_r)
            instr_count <= 8'h0;
        else if (fetch_active)
            instr_count <= instr_count + 8'h1;
    end

    // =========================================================
    // IF Stage
    // =========================================================
    wire pc_redirect = PCSrc | gpu_start_r;
    wire [8:0] pc_target = gpu_start_r ? {1'b0, bram_inst_addr_r} : branch_target;

    ifetch_gpu IF (
        .clk            (clk),
        .rst            (rst),
        .stall          (stall),
        .PCSrc          (pc_redirect),
        .branch_target  (pc_target),
        .write_to_imem  (write_to_imem),
        .addr_imem_host (addr_imem_host),
        .imem_data      (data_imem_host),
        .loading        (loading),
        .instruction_out(instruction),
        .pc_plus_1_out  (pc_plus_1)
    );

    wire [31:0] if_id_din = fetch_active_d ? instruction : 32'b0;

    register_generate #(32) if_id (
        .clk   (clk),
        .rst   (rst),
        .stall (stall),
        .d_in  (if_id_din),
        .q_out (id_inst)
    );

    // WB signals
    wire [63:0] wb_data;
    wire [4:0]  wb_wreg_addr;
    wire        wb_wreg_en;

    // =========================================================
    // STAGE 2: DECODE
    // =========================================================
    wire [63:0] id_r1data, id_r2data, id_rddata;
    wire [63:0] id_sign_ext_imm;
    wire [4:0]  id_wreg_addr;
    wire        id_wreg_en, id_wmem_en;
    wire        id_mem_read, id_mem_to_reg;
    wire        id_ALUSrc;
    wire [4:0]  id_shift;
    wire [1:0]  id_width;
    wire [3:0]  id_exec_op;
    wire        id_is_scalar, id_is_vec_int, id_is_tensor, id_is_vmac;

    decode_gpu ID (
        .clk            (clk),
        .rst            (rst),
        .stall          (stall),
        .pc_plus_1      (pc_plus_1),
        .id_inst        (id_inst),
        .wb_waddr       (wb_wreg_addr),
        .wb_wdata       (wb_data),
        .wb_wena        (wb_wreg_en),
        .r1data         (id_r1data),
        .r2data         (id_r2data),
        .rddata         (id_rddata),
        .wreg_addr_out  (id_wreg_addr),
        .wreg_en_out    (id_wreg_en),
        .wmem_en_out    (id_wmem_en),
        .mem_read_out   (id_mem_read),
        .sign_ext_imm_out(id_sign_ext_imm),
        .mem_to_reg_out (id_mem_to_reg),
        .ALUSrc_out     (id_ALUSrc),
        .shift_out      (id_shift),
        .width_out      (id_width),
        .exec_op_out    (id_exec_op),
        .is_scalar_out  (id_is_scalar),
        .is_vec_int_out (id_is_vec_int),
        .is_tensor_out  (id_is_tensor),
        .is_vmac_out    (id_is_vmac),
        .PCSrc          (PCSrc),
        .branch_target  (branch_target)
    );

    // =========================================================
    // ID/EX Bridge (280 bits)
    // =========================================================
    wire [279:0] id_ex_q;
    wire [279:0] id_ex_din = stall ? 280'b0 : {
        id_r1data, id_r2data, id_rddata, id_sign_ext_imm,
        id_wreg_addr, id_wreg_en, id_wmem_en, id_mem_to_reg,
        id_mem_read, id_ALUSrc, id_shift, id_exec_op,
        id_is_scalar, id_is_vec_int, id_is_tensor, id_width
    };

    register_generate #(280) id_ex_bridge (
        .clk   (clk),
        .rst   (rst),
        .stall (1'b0),
        .d_in  (id_ex_din),
        .q_out (id_ex_q)
    );

    wire [63:0] id_ex_r1           = id_ex_q[279:216];
    wire [63:0] id_ex_r2           = id_ex_q[215:152];
    wire [63:0] id_ex_rd           = id_ex_q[151:88];
    wire [63:0] id_ex_sign_ext_imm = id_ex_q[87:24];
    wire [4:0]  id_ex_wreg         = id_ex_q[23:19];
    wire        id_ex_wreg_en      = id_ex_q[18];
    wire        id_ex_wmem_en      = id_ex_q[17];
    wire        id_ex_mem_to_reg   = id_ex_q[16];
    wire        id_ex_mem_read     = id_ex_q[15];
    wire        id_ex_ALUSrc       = id_ex_q[14];
    wire [4:0]  id_ex_shift        = id_ex_q[13:9];
    wire [3:0]  id_ex_exec_op      = id_ex_q[8:5];
    wire        id_ex_is_scalar    = id_ex_q[4];
    wire        id_ex_is_vec_int   = id_ex_q[3];
    wire        id_ex_is_tensor    = id_ex_q[2];
    wire [1:0]  id_ex_width        = id_ex_q[1:0];

    // =========================================================
    // Tensor control
    // =========================================================
    reg        tensor_wb_valid_r;
    reg [63:0] tensor_wb_data_r;
    reg [4:0]  tensor_wb_addr_r;
    reg        tensor_wb_en_r;

    wire tensor_cmd_valid = id_ex_is_tensor;
    wire tensor_cmd_ready;
    wire tensor_cmd_fire  = tensor_cmd_valid & tensor_cmd_ready;

    // =========================================================
    // Hazard Unit
    // =========================================================
    hazard_unit HZD (
        .is_vmac         (id_is_vmac),
        .id_rdaddr       (id_wreg_addr),
        .id_ex_is_tensor (id_ex_is_tensor),
        .id_ex_wreg      (id_ex_wreg),
        .stall           (stall_hzd),
        .fwd_rd_en       (fwd_rd_en)
    );

    assign stall = stall_hzd;

    // =========================================================
    // EX: Scalar ALU
    // =========================================================
    wire [63:0] alu_B      = id_ex_ALUSrc ? id_ex_sign_ext_imm : id_ex_r2;
    wire [63:0] alu_out;
    wire [63:0] ex_result  = alu_out;

    alu_64bit_minimal alu_unit (
        .A   (id_ex_r1),
        .B   (alu_B),
        .Op  (id_ex_exec_op),
        .Out (alu_out)
    );

    // =========================================================
    // EX: Tensor Unit
    // =========================================================
    wire [63:0] tensor_out;
    wire        tensor_done;
    wire [63:0] rd_data_mux = id_ex_rd;

    reg [5:0] tensor_opcode;
    always @(*) begin
        case (id_ex_exec_op)
            4'h5:    tensor_opcode = 6'h06; // VADD_BF16
            4'h6:    tensor_opcode = 6'h07; // VSUB_BF16
            4'h7:    tensor_opcode = 6'h08; // VMUL_BF16
            4'h8:    tensor_opcode = 6'h09; // VMAC_BF16
            4'h9:    tensor_opcode = 6'h0A; // VRELU_BF16
            default: tensor_opcode = 6'h00;
        endcase
    end

    bf16_tensor_2 tensor_unit (
        .clk        (clk),
        .rst        (rst),
        .cmd_valid  (tensor_cmd_valid),
        .cmd_ready  (tensor_cmd_ready),
        .opcode     (tensor_opcode),
        .r1data     (id_ex_r1),
        .r2data     (id_ex_r2),
        .rd_data    (rd_data_mux),
        .tensor_out (tensor_out),
        .tensor_done(tensor_done)
    );

    always @(posedge clk) begin
        if (rst) begin
            tensor_wb_valid_r    <= 1'b0;
            tensor_wb_data_r     <= 64'b0;
            tensor_wb_addr_r     <= 5'b0;
            tensor_wb_en_r       <= 1'b0;
            tensor_out_intercept <= 64'b0;
				tensor_done_r			<= 1'b0;
        end else begin
            tensor_wb_valid_r <= 1'b0;

            if (tensor_cmd_fire) begin
                tensor_wb_addr_r <= id_ex_wreg;
                tensor_wb_en_r   <= id_ex_wreg_en;
            end

            if (tensor_done) begin
                tensor_wb_data_r     <= tensor_out;
                tensor_wb_valid_r    <= 1'b1;
                tensor_out_intercept <= tensor_out;
					 tensor_done_r			 <= tensor_done;
            end
        end
    end

    // =========================================================
    // EX/MEM Bridge (202 bits)
    // Tensor ops are converted into a bubble here.
    // =========================================================
    wire [201:0] ex_me_din = id_ex_is_tensor ? 202'b0 : {
        ex_result,        // [201:138]
        64'b0,            // [137:74] unused
        id_ex_rd,         // [73:10]
        id_ex_wreg,       // [9:5]
        id_ex_wreg_en,    // [4]
        id_ex_wmem_en,    // [3]
        id_ex_mem_to_reg, // [2]
        id_ex_mem_read,   // [1]
        1'b0              // [0]
    };

    wire [201:0] ex_me_bundle;

    register_generate #(202) ex_me_bridge (
        .clk   (clk),
        .rst   (rst),
        .stall (1'b0),
        .d_in  (ex_me_din),
        .q_out (ex_me_bundle)
    );

    // =========================================================
    // STAGE 4: MEMORY
    // =========================================================
    wire [63:0] me_result     = ex_me_bundle[201:138];
    wire [63:0] me_store_data = ex_me_bundle[73:10];
    wire [4:0]  me_wreg       = ex_me_bundle[9:5];
    wire        me_wre        = ex_me_bundle[4];
    wire        me_wme        = ex_me_bundle[3];
    wire        me_mem_to_reg = ex_me_bundle[2];
    wire        me_mem_read   = ex_me_bundle[1];

    wire [63:0] dmem_raw_output;

    memory ME (
        .clk           (clk),
        .write_to_dmem (write_to_dmem),
        .read_req_dmem (read_req_dmem),
        .addr_dmem_host(addr_dmem_host),
        .data_dmem_host(data_dmem_host),
        .pipeline_addr (me_result),
        .pipeline_data (me_store_data),
        .pipeline_we   (me_wme),
        .dmem_out      (dmem_raw_output)
    );

    assign data_out_dmem = dmem_raw_output;

    // =========================================================
    // MEM/WB1 Bridge (72 bits)
    // =========================================================
    wire [71:0] me_wb1_bundle;

    register_generate #(72) me_wb1_bridge (
        .clk   (clk),
        .rst   (rst),
        .stall (1'b0),
        .d_in  ({me_result, me_wreg, me_wre, me_mem_to_reg, me_mem_read}),
        .q_out (me_wb1_bundle)
    );

    wire [63:0] wb1_result     = me_wb1_bundle[71:8];
    wire [4:0]  wb1_wreg       = me_wb1_bundle[7:3];
    wire        wb1_wreg_en    = me_wb1_bundle[2];
    wire        wb1_mem_to_reg = me_wb1_bundle[1];
    wire        wb1_mem_read   = me_wb1_bundle[0];

    // =========================================================
    // WB mux
    // =========================================================
    wire [63:0] wb2_din = (wb1_mem_to_reg && wb1_mem_read)
                          ? dmem_raw_output
                          : wb1_result;

    assign wb_data      = tensor_wb_valid_r ? tensor_wb_data_r : wb2_din;
    assign wb_wreg_addr = tensor_wb_valid_r ? tensor_wb_addr_r : wb1_wreg;
    assign wb_wreg_en   = tensor_wb_valid_r ? tensor_wb_en_r   : wb1_wreg_en;

    // pipeline_done: asserts only when all instructions have been fetched
    // AND the last tensor op has retired. One pulse at end of full program.
    assign pipeline_done = (instr_count >= bram_length_r) && tensor_done_r;

endmodule