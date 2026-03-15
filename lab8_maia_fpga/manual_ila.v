`timescale 1ns/1ps
//
// Manual ILA: captures 16 samples when triggered by pipeline_we or pipeline_mem_read.
// Each sample: 64 bits (fifo_raw_data_out - key signal to see if expected value appears).
// Read out via index: write index to set, read lo/hi to get sample.
//
module manual_ila #(
    parameter DEPTH = 16,
    parameter WIDTH = 64
) (
    input              clk,
    input              rst,

    // Trigger: capture on store or load
    input              trigger_store,
    input              trigger_load,

    // Probe signals (captured when trigger fires)
    input  [WIDTH-1:0] probe_data,

    // Host interface: set index, read sample
    input  [3:0]       host_index,
    input              host_index_we,
    output [31:0]      sample_lo,
    output [31:0]      sample_hi
);

    reg [WIDTH-1:0] buffer [0:DEPTH-1];
    reg [3:0]       write_ptr;
    reg [3:0]       read_index;
    reg             capturing;
    reg [3:0]       capture_count;

    wire trigger = trigger_store | trigger_load;

    // Capture logic: when trigger fires, capture DEPTH samples (including trigger cycle)
    always @(posedge clk) begin
        if (rst) begin
            capturing     <= 1'b0;
            capture_count <= 4'd0;
            write_ptr     <= 4'd0;
        end else begin
            if (trigger && !capturing) begin
                capturing     <= 1'b1;
                capture_count <= 4'd1;
                write_ptr     <= 4'd1;
                buffer[0]     <= probe_data;
            end else if (capturing) begin
                buffer[write_ptr] <= probe_data;
                write_ptr        <= write_ptr + 1'b1;
                capture_count    <= capture_count + 1'b1;
                if (capture_count == DEPTH - 1)
                    capturing <= 1'b0;
            end
        end
    end

    // Host index register
    always @(posedge clk) begin
        if (rst)
            read_index <= 4'd0;
        else if (host_index_we)
            read_index <= host_index;
    end

    // Read output
    assign sample_lo = buffer[read_index][31:0];
    assign sample_hi = buffer[read_index][63:32];

endmodule
