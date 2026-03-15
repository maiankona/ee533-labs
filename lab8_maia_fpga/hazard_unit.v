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
    // RAW Hazard Detection - VMAC accumulator dependency
    // =========================================================
    wire raw_hazard = is_vmac &
                      id_ex_is_tensor &
                      (id_ex_wreg == id_rdaddr) &
                      (id_rdaddr != 5'd0);

    assign stall    = raw_hazard;
    assign fwd_rd_en = raw_hazard;

endmodule
