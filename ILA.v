module fifo_reg_array_sc (
    clk, 
    reset, 
    data_in, 
    wen, 
    ren, 
    data_out, 
    depth, 
    empty, 
    full
);

parameter DATA_WIDTH = 64;
parameter ADDR_WIDTH = 8;

input clk, reset;
input wen, ren;
input [DATA_WIDTH-1:0] data_in;

output [ADDR_WIDTH:0] depth;
output [DATA_WIDTH-1:0] data_out;
output empty, full;

reg [ADDR_WIDTH:0] rdptr, wrptr;
wire [ADDR_WIDTH:0] depth;
wire wenq, renq;
reg full, empty;

reg [DATA_WIDTH-1:0] Reg_Array [(2**ADDR_WIDTH)-1:0];

// NEW: registered output
reg [DATA_WIDTH-1:0] data_out_reg;
assign data_out = data_out_reg;

wire [ADDR_WIDTH:0] N_Plus_1_zeros = {(ADDR_WIDTH+1){1'b0}};
wire [ADDR_WIDTH-1:0] N_zeros = {(ADDR_WIDTH){1'b0}};
wire [ADDR_WIDTH:0] A_1_and_N_zeros = {1'b1, N_zeros};

assign depth = wrptr - rdptr;

always @(*) begin
    empty = 1'b0;
    full  = 1'b0;

    if (depth == N_Plus_1_zeros)
        empty = 1'b1;

    if (depth == A_1_and_N_zeros)
        full = 1'b1;
end

assign wenq = (~full)  & wen;
assign renq = (~empty) & ren;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        wrptr <= N_Plus_1_zeros;
        rdptr <= N_Plus_1_zeros;
        data_out_reg <= {DATA_WIDTH{1'b0}};
    end
    else begin
        // WRITE
        if (wenq) begin
            Reg_Array[wrptr[ADDR_WIDTH-1:0]] <= data_in;
            wrptr <= wrptr + 1'b1;
        end

        // READ
        if (renq) begin
            data_out_reg <= Reg_Array[rdptr[ADDR_WIDTH-1:0]];
            rdptr <= rdptr + 1'b1;
        end
    end
end

endmodule
