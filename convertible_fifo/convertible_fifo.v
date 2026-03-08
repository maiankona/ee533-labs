`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:39:25 03/06/2026 
// Design Name: 
// Module Name:    convertible_fifo 
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
module convertible_fifo(
    input clk,
    input rst,
    
    input ctrl_from_cpu,    // control from CPU
    input ctrl_from_nf,       // control from network
    
    input mode,               // 0=SRAM mode, 1=FIFO mode
    
    input [7:0]   tail_addr,       // FIFO write pointer
    input [7:0]   sram_addr_write, // SRAM direct write address
    input [71:0]  fifo_input,      // data input
    input [71:0]  sram_data_in,    // SRAM write data
    input         fifo_write_en,   // FIFO write enable
    input         sram_write_en,   // SRAM write enable
    
    input [7:0]   head_addr,       // FIFO read pointer
    input [7:0]   sram_addr_read,  // SRAM direct read address
    input         fifo_read_en,    // FIFO read enable
    output [71:0] sram_data_out,   // SRAM primary read output
    output [71:0] fifo_output,     // FIFO read output
    
    input [7:0]   sram_addr_read2,    // optional 2nd read and writes below
    input         sram_read2_en,      
    output [71:0] sram_data_out2,     
    
    input [7:0]   sram_addr_write2,   
    input [71:0]  sram_data_in2,      
    input         sram_write2_en,     
    
    output        fifo_empty,
    output        fifo_full,
    output [8:0]  fifo_depth
);

    reg [8:0] write;              // write pointer (tail)
    reg [8:0] read;              // read pointer (head)
    //reg [8:0] count;               // count words in FIFO
	 
    
    always @(posedge clk) begin
        if (rst) begin
            write <= 9'h00;
            read <= 9'h00;
            //depth  <= 9'h000;
        end else if (mode) begin
            // FIFO mode
            case ({fifo_write_en, fifo_read_en})
                2'b10: begin  // write only
                    if (!fifo_full) begin
                        write <= write + 1'b1;
                        //count  <= count + 1'b1;
                    end
                end
                2'b01: begin  // read only
                    if (!fifo_empty) begin
                        read <= read + 1'b1;
                        //count  <= count - 1'b1;
                    end
                end
                
                2'b11: begin  // simultaneous read+write
                    if (!fifo_full) begin
                        write <= write + 1'b1;
                    end
                    if (!fifo_empty) begin
                        read <= read + 1'b1;
                    end
                    // count unchanged +1-1=0
                end
                
                default: ;  // NOP
            endcase
        end
        // no pointer logic in SRAM mode
    end
    
    // FIFO Status
	 wire [8:0] depth = write - read;
	 assign fifo_depth = depth;
    assign fifo_empty = (depth == 9'h000);
    assign fifo_full  = (depth == 9'h100);  // 255 max for 256-deep shared BRAM
    //assign fifo_count = count[7:0];
    
    // port A mux (write)
    wire [7:0]  port_a_addr = mode ? write[7:0] : 
                              sram_write2_en ? sram_addr_write2 :
                              sram_addr_write; // if fifo then just write if sram then use 2nd optional write or normal write
    
    wire [71:0] port_a_din  = mode ? fifo_input :
                              sram_write2_en ? sram_data_in2 :
                              sram_data_in;
    
    wire        port_a_we   = mode ? (fifo_write_en & ~fifo_full) : // dont write when fifo full
                              (sram_write_en | sram_write2_en); 
    
    // port B mux (read)
 
    wire [7:0]  port_b_addr = mode ? read[7:0] :
                              sram_read2_en ? sram_addr_read2 :
                              sram_addr_read; 
    wire [71:0] port_b_dout;
    
    assign fifo_output = port_b_dout;
    assign sram_data_out = port_b_dout;
    assign sram_data_out2 = port_b_dout;  
    

    // dual-port BRAM from lab 3
 
    dualPortBram bram_inst (
        .addra(port_a_addr),
        .addrb(port_b_addr),
		  .clka(clk),
        .clkb(clk),
        .dina(port_a_din),
        .doutb(port_b_dout),
		  .wea(port_a_we)
    );
endmodule
