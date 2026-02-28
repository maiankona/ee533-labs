# this gon be long... take inspo from arm2custom
# PTX → Your ISA Translation Rules

if "add.s16" in line:
    opcode = 0x01  # VADD_I16
    
elif "sub.s16" in line:
    opcode = 0x02  # VSUB_I16
    
elif "mul.wide" in line:
    opcode = 0x08  # VMUL_I16
    
elif "shl.b64" in line:
    opcode = 0x03  # Use SLL in ALU
    
elif "shr.s64" in line:
    opcode = 0x04  # Use SRL in ALU
    
elif "mov.u32" in line and "tid.x" in line:
    opcode = 0x19  # MOVI (load thread ID)
    
elif "cvt.u64.u32" in line:
    opcode = 0x1A  # CVT (sign extend)
    
elif "ld.global" in line or "ld.param" in line:
    opcode = 0x11  # LD
    
elif "st.global" in line:
    opcode = 0x12  # ST
    
elif "fma.rn.bf16" in line:
    opcode = 0x09  # VMAC_BF16 (tensor)
    
elif "max.s16" in line:
    opcode = 0x0A  # VRELU_BF16 (tensor)
    
elif "ret" in line:
    opcode = 0x0B  # HALT
    
elif "cvta.to.global" in line:
    opcode = 0x19  # PASS (no actual address translation)
