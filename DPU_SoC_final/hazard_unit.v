`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:12:23 02/27/2026 
// Design Name: 
// Module Name:    hazard_unit 
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
module hazard_unit (
    // From decode (incoming instruction)
    input        is_vmac,       // incoming instruction is VMAC
    input [4:0]  id_rdaddr,     // rd address of incoming VMAC (accumulator register)

    // From ID/EX pipeline register (instruction currently in EX)
    input        id_ex_is_tensor, // instruction in EX is a tensor op
    input [4:0]  id_ex_wreg,      // destination register of instruction in EX

    // Stall and forwarding outputs
    output       stall,         // freeze PC and IF/ID, insert bubble into ID/EX
    output       fwd_rd_en      // mux select: use tensor_out instead of RF rddata
);

    // =========================================================
    // RAW Hazard Detection ? VMAC accumulator dependency
    //
    // A stall is needed when:
    //   1. The incoming instruction is VMAC (needs rd_data)
    //   2. The instruction currently in EX is also a tensor op
    //      (its result hasn't been written to RF yet)
    //   3. The EX instruction writes to the same register that
    //      the incoming VMAC wants to accumulate into (id_rdaddr)
    //
    // When detected, fwd_rd_en tells the bypass mux in the EX
    // stage to use tensor_out directly instead of RF rddata,
    // and stall holds the pipeline for one cycle while the
    // forwarded value settles.
    // =========================================================

    wire raw_hazard = is_vmac &
                      id_ex_is_tensor &
                      (id_ex_wreg == id_rdaddr) &
                      (id_rdaddr != 5'd0);   // r0 never stalls ? it's always 0

    assign stall    = raw_hazard;
    assign fwd_rd_en = raw_hazard;

endmodule
