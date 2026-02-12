// File name: 	: ila
// Design       : fifo_reg_array_sc 
// Author       : Melvin Houston
// Date			: 2/12/2026
// n+1 bit pointers.

//`timescale 1 ns/100 ps

module ila (clk, reset, data_in, wen, ren, data_out, depth, empty, full);

parameter DATA_WIDTH = 64;
parameter ADDR_WIDTH = 8;

input clk, reset;
input wen, ren; // the read or write request for CPU
input [DATA_WIDTH-1:0] data_in;

output [ADDR_WIDTH:0] depth;
output [DATA_WIDTH-1:0] data_out;
output empty, full;

reg [ADDR_WIDTH:0] rdptr, wrptr; //read pointer and write pointer of FIFO
wire [ADDR_WIDTH:0] depth;
wire wenq, renq;// read and write enable for FIFO
reg full, empty;

reg [DATA_WIDTH-1:0] Reg_Array [(2**ADDR_WIDTH)-1:0];// FIFO array

// Registered output to avoid combinational race condition
reg [DATA_WIDTH-1:0] data_out_reg;
assign data_out = data_out_reg;

wire [ADDR_WIDTH:0] N_Plus_1_zeros = {(ADDR_WIDTH+1){1'b0}};    // Used to create 9-bits worth of zeros: 5'b00000
wire [ADDR_WIDTH-1:0] N_zeros = {(ADDR_WIDTH){1'b0}};           // Used to create 8-bits worth of zeros: 4'b0000
wire [ADDR_WIDTH:0] A_1_and_N_zeros = {1'b1, N_zeros};          // Used to concatenate 1-bit to the 8-bits of zeros: 5'b10000

assign depth = wrptr - rdptr;

always@(*)                          // Logic block for reporting status (combinational due to * sensitivity
begin
	empty  = 1'b0;
	full   = 1'b0;
	if (depth == N_Plus_1_zeros)    // if n_pointer worth of zeros, it is empty
		empty  = 1'b1;              // Blocking statements used, as it is a combo block
	if (depth ==  A_1_and_N_zeros) // if 1+8_bit worth of zeros, it is full 
		full  = 1'b1;
end

assign wenq = (~full) & wen;// only if the FIFO is not full and there is write request from CPU, we enable the write to FIFO.
assign renq = (~empty)& ren;// only if the FIFO is not empty and there is read request from CPU, we enable the read to FIFO.
// assign data_out = Reg_Array[rdptr[ADDR_WIDTH-1:0]]; // we use the lower N bits of the (N+1)-bit pointer as index to the 2**N array.

always@(posedge clk, posedge reset)
begin
    if (reset)
		begin
			wrptr <= N_Plus_1_zeros;    // Assign the zeros for reset
			rdptr <= N_Plus_1_zeros;    // Assign the zeros for reset
			data_out_reg <= {DATA_WIDTH{1'b0}};
		end
	else
		begin
			if (wenq) 
				begin
					Reg_Array[wrptr[ADDR_WIDTH-1:0]] <= data_in;  // we use the lower N bits of the (N+1)-bit pointer as index to the 2**N array.
					wrptr <= wrptr + 1;
				end
			if (renq)
				begin
					data_out_reg <= Reg_Array[rdptr[ADDR_WIDTH-1:0]]; // registered read output
					rdptr <= rdptr + 1;
				end
		end
end

endmodule // fifo_reg_array_sc
