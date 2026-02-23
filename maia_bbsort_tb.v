`timescale 1ns / 1ps

module bubbleSort_tb;
    // Inputs
    reg clk;
    reg rst;
    reg write_to_imem;
    reg write_to_dmem;
    reg [8:0] addr_imem_host;
    reg [31:0] data_imem_host;
    reg [7:0] addr_dmem_host;
    reg [31:0] data_dmem_host;
    reg read_req_dmem;
    
    // Outputs
    wire [31:0] data_out_dmem;
    
    // Instantiate the Unit Under Test (UUT)
    pipeline_backup uut (
        .clk(clk), 
        .rst(rst), 
        .write_to_imem(write_to_imem), 
        .write_to_dmem(write_to_dmem), 
        .addr_imem_host(addr_imem_host), 
        .data_imem_host(data_imem_host), 
        .addr_dmem_host(addr_dmem_host), 
        .data_dmem_host(data_dmem_host), 
        .read_req_dmem(read_req_dmem), 
        .data_out_dmem(data_out_dmem)
    );
	 
    // ✅ Clock generation (separate always block)
    always #5 clk = ~clk;
    
    // ✅ Memory arrays (moved outside initial block)
    integer i;
    reg [31:0] prog_mem [0:511];
    reg [31:0] data_mem [0:15];
    
    // ✅ Single initial block for test sequence
    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;  // ✅ Start with reset HIGH
        write_to_imem = 0;
        write_to_dmem = 0;
        addr_imem_host = 0;
        data_imem_host = 0;
        addr_dmem_host = 0;
        data_dmem_host = 0;
        read_req_dmem = 0;
        
        // Load hex files into testbench arrays
      $readmemh("bubbleSort_custom.txt", prog_mem); 
      $readmemh("bubbleSort_data2.txt", data_mem); // CHANGE THE DATA TO HEX
        
        // Wait for reset
        //#20 rst = 0;  // ✅ Release reset after 20ns
        
        // ==============================
        // LOAD INSTRUCTION MEMORY
        // ==============================
        $display("Loading instruction memory...");
        for (i = 0; i < 107; i = i+1) begin
            @(posedge clk);
            write_to_imem   = 1;
            addr_imem_host  = i;
            data_imem_host  = prog_mem[i];
        end
        @(posedge clk);
        write_to_imem = 0;
        $display("Instruction memory loaded.");
        
        // ==============================
        // LOAD DATA MEMORY
        // ==============================
        $display("Loading data memory...");
        for (i = 0; i < 10; i = i+1) begin
            @(posedge clk);
            write_to_dmem  = 1;
            addr_dmem_host = 8'd256 + i;
            data_dmem_host = data_mem[i];
            $display("  dmem[%0d] = %0d", i, $signed(data_mem[i]));
        end
        @(posedge clk);
        write_to_dmem = 0;
        $display("Data memory loaded.");
        
        // ==============================
        // RUN CPU
        // ==============================
		  @(posedge clk);
			rst = 0;   // START CPU
			@(posedge clk) begin
    $display("PC=%0d instr=%h ALU=%h r1=%h r2=%h wb_en=%b wb_reg=%d wb_data=%h",
        uut.pc,
        uut.instruction,
        uut.alu_out,
        uut.id_r1data,
        uut.id_r2data,
        uut.wb_wreg_en,
        uut.wb_wreg_addr,
        uut.wb_data
    );
end
        $display("Running CPU...");
        #2000;
        
        // ==============================
        // READ BACK SORTED DATA
        // ==============================
        $display("==== SORTED ARRAY ====");
        for (i = 0; i < 10; i = i+1) begin
            @(posedge clk);
            read_req_dmem = 1;
            addr_dmem_host = i;
            @(posedge clk);
            $display("mem[%0d] = %0d", i, $signed(data_out_dmem));
        end
        read_req_dmem = 0;
        
        $display("Test complete!");
        $stop;
		  
    end
      
endmodule
