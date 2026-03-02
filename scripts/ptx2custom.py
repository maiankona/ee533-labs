#!/usr/bin/env python3
"""
PTX to Custom GPU ISA Translator
Converts NVIDIA PTX assembly to custom 32-bit GPU instructions
"""

import re
import sys
import os

ARRAY_A_BASE = 0x0001  # Address where array A starts
ARRAY_B_BASE = 0x0029  # Address where array B starts
ARRAY_C_BASE = 0x0051  # Address where array C starts (output)

# =========================================================
# INSTRUCTION FORMAT ENCODING
# =========================================================
def encode_R(opcode, rd, rs1, rs2, width=0b00):
    """
    R-Type: | opcode(6) | rd(5) | rs1(5) | rs2(5)  | unused(9) | width(2)
    """
    instr = 0
    instr |= (opcode & 0x3F) << 26
    instr |= (rd & 0x1F) << 21
    instr |= (rs1 & 0x1F) << 16
    instr |= (rs2 & 0x1F) << 11
    instr |= (width & 0x3) << 0
    return instr

def encode_I(opcode, rd, rs1, width, imm14):
    """
    I-Type: | opcode(6) | rd(5) | rs1(5)  | imm14(14) | width(2)
    """
    instr = 0
    instr |= (opcode & 0x3F) << 26
    instr |= (rd & 0x1F) << 21
    instr |= (rs1 & 0x1F) << 16
    instr |= (imm14 & 0x3FFF) << 2
    instr |= (width & 0x3) << 0
    return instr

def encode_B(opcode, rs1, rs2, offset):
    """
    B-Type: | opcode(6) | rs1(5) | rs2(5) | branch_offset(16) |
    """
    instr = 0
    instr |= (opcode & 0x3F) << 26
    instr |= (rs1 & 0x1F) << 21
    instr |= (rs2 & 0x1F) << 16
    instr |= (offset & 0xFFFF) << 0
    return instr

# =========================================================
# REGISTER MAPPING
# =========================================================
# PTX address registers → Our hardcoded address registers
# These mappings ensure ld/st use the correct base addresses
ADDRESS_REGS = {
    # Parameter load results (ld.param → these)
    '%rd1': 6, '%rd2': 5, '%rd3': 4,
    # cvta.to.global results (just pass through)
    '%rd4': 4, '%rd5': 5, '%rd6': 6,
    # Address arithmetic results (add.s64 rd10, rd6, ...)
    '%rd7': 7, '%rd8': 8, '%rd9': 9,
    '%rd10': 6, '%rd11': 5, '%rd12': 4, '%rd13': 4,
}

reg_map = {}
next_reg = 1  # Start from r1 for data registers (%rs1, %r1)

def get_reg(ptx_reg):
    """Map PTX virtual register to physical register"""
    global next_reg
    
    # Use hardcoded mapping for address registers
    if ptx_reg in ADDRESS_REGS:
        return ADDRESS_REGS[ptx_reg]
    
    # Allocate data registers dynamically
    if ptx_reg not in reg_map:
        # Skip reserved address registers (r4-r9)
        while next_reg >= 4 and next_reg <= 9:
            next_reg += 1
        
        if next_reg >= 32:
            print(f"Warning: Out of registers! Reusing r31")
            reg_map[ptx_reg] = 31
        else:
            reg_map[ptx_reg] = next_reg
            next_reg += 1
    
    return reg_map[ptx_reg]

def reset_regs():
    """Reset register allocator for new function"""
    global reg_map, next_reg
    reg_map = {}
    next_reg = 1  # Data registers start at r1

# =========================================================
# PTX INSTRUCTION TRANSLATION
# =========================================================
def translate_line(line):
    line = line.strip()
    
    # ===== SKIP INLINE ASSEMBLY BLOCKS =====
    if any(x in line for x in ['// begin inline asm', '// end inline asm', '{.reg', '}', 'mov.b16']):
        return []
    
    # ===== IGNORE THREAD-RELATED STUFF =====
    skip_keywords = [
        'ld.param', 'cvta.to.global', 'mov.u32', 'tid.x',
        'cvt.u64.u32', 'shl.b64', 'shr.s64', 'mul.wide', 'add.s64'
    ]
    
    if any(kw in line for kw in skip_keywords):
        return []
        
    # Skip comments, labels, directives
    if not line or line.startswith(('//','.','{','}')):
        return []
    
    instructions = []
    
    # ===== LOAD GLOBAL =====
    if 'ld.global' in line:
        match = re.search(r'ld\.global\.(u\d+)\s+(%\w+),\s*\[(%\w+)\];?', line)
        if match:
            width = 0b00 if 'u16' in match.group(1) else 0b01 if 'u32' in match.group(1) else 0b10
            rd = get_reg(match.group(2))
            rs1 = get_reg(match.group(3))
            instructions.append(encode_I(0x12, rd, rs1, width, 0))
            instructions.append(encode_I(0x00, 0, 0, 0, 0)) # NOP 
            instructions.append(encode_I(0x00, 0, 0, 0, 0)) # NOP
            instructions.append(encode_I(0x00, 0, 0, 0, 0)) # NOP
        return instructions
    
    # ===== ADD =====
    # ADD 32-bit SIMD
    if 'add.s32' in line:
        match = re.search(r'add\.s32\s+(%\w+),\s*(%\w+),\s*(%\w+);?', line)
        if match:
            instructions.append(encode_R(0x01, get_reg(match.group(1)), 
                                        get_reg(match.group(2)), 
                                        get_reg(match.group(3)), 0b01))
        return instructions
    
    # ADD 16-bit SIMD
    if 'add.s16' in line:
        match = re.search(r'add\.s16\s+(%\w+),\s*(%\w+),\s*(%\w+);?', line)
        if match:
            instructions.append(encode_R(0x04, get_reg(match.group(1)), 
                                        get_reg(match.group(2)), 
                                        get_reg(match.group(3)), 0b00))
        return instructions
    
    # ===== SUB 16-bit SIMD =====
    if 'sub.s16' in line:
        match = re.search(r'sub\.s16\s+(%\w+),\s*(%\w+),\s*(%\w+)', line)
        if match:
            rd = get_reg(match.group(1))
            rs1 = get_reg(match.group(2))
            rs2 = get_reg(match.group(3))
            instructions.append(encode_R(0x05, rd, rs1, rs2, 0b00))  # VSUB_I16
        return instructions
    
    # ===== FMA BF16 (with flexible accumulator matching) =====
    if 'fma.rn.bf16' in line:
        # Match both %rsX and local registers like 'c'
        match = re.search(r'fma\.rn\.bf16\s+(%\w+),\s*(%\w+),\s*(%\w+),\s*(\w+)', line)
        if match:
            rd = get_reg(match.group(1))
            rs1 = get_reg(match.group(2))
            rs2 = get_reg(match.group(3))
            accum_str = match.group(4)
            
            # Check if accumulator is a PTX register or inline asm local
            if accum_str.startswith('%'):
                # Real accumulator register
                rs3 = get_reg(accum_str)
                if rs3 != rd:
                    instructions.append(encode_R(0x01, rd, rs3, 0, 0b00))  # MOV
                instructions.append(encode_R(0x09, rd, rs1, rs2, 0b00))  # VMAC
            else:
                # Inline asm local register (like 'c') - treat as zero/multiply only
                # This is rs1 * rs2 + 0, which is just multiply
                instructions.append(encode_R(0x08, rd, rs1, rs2, 0b00))  # VMUL_BF16
        return instructions
    
    # ===== MAX (ReLU) =====
    if 'max.s16' in line:
        match = re.search(r'max\.s16\s+(%\w+),\s*(%\w+)', line)
        if match:
            rd = get_reg(match.group(1))
            rs1 = get_reg(match.group(2))
            instructions.append(encode_R(0x0A, rd, rs1, 0, 0b00))  # VRELU_BF16
        return instructions
    
    # ===== STORE GLOBAL =====
    if 'st.global' in line:
        match = re.search(r'st\.global\.(u\d+)\s+\[(%\w+)\],\s*(%\w+);?', line)
        if match:
            width = 0b00 if 'u16' in match.group(1) else 0b01 if 'u32' in match.group(1) else 0b10
            rs1 = get_reg(match.group(2))
            rs2 = get_reg(match.group(3))
            instructions.append(encode_I(0x13, rs2, rs1, width, 0))
        return instructions
    
    # ===== HALT =====
    if 'ret' in line:
        instructions.append(encode_R(0x0B, 0, 0, 0, 0))  # HALT
        return instructions
    
    return instructions

# =========================================================
# MAIN TRANSLATOR
# =========================================================
def translate_ptx(input_file, output_file):
    with open(input_file, 'r') as f:
        lines = f.readlines()
    
    all_instructions = []
    in_function = False
    
    # ===== HARDCODE ADDRESS REGISTERS =====
    # Instead of dynamic allocation, use fixed registers for addresses
    # This matches what you preload in memory
    address_regs = {
        'param_0': 6,  # r6 = address of array A (0x00)
        'param_1': 5,  # r5 = address of array B (0x0A)
        'param_2': 4,  # r4 = address of array C (0x14)
    }
    
    # ===== ADD INITIALIZATION CODE =====
    # These load the base addresses (like your Lab 6 setup)
    all_instructions.append(encode_I(0x19, 6, 0, 0b01, ARRAY_A_BASE))   # MOVI r6, A_base
    all_instructions.append(encode_I(0x19, 5, 0, 0b01, ARRAY_B_BASE))   # MOVI r5, B_base
    all_instructions.append(encode_I(0x19, 4, 0, 0b01, ARRAY_C_BASE))   # MOVI r4, C_base
    all_instructions.append(encode_I(0x19, 7, 0, 0b01, 0x0001))         # MOVI r7, threadIdx
    
    for line in lines:
        if '.visible .entry' in line:
            in_function = True
            reset_regs()
            continue
        
        if in_function:
            instrs = translate_line(line)
            all_instructions.extend(instrs)
            
            if line.strip() == '}':
                in_function = False

    # debugging registers
    print(f"\nRegister Allocation:")
    print(f"  Address registers (fixed):")
    for ptx_reg, phys_reg in sorted(ADDRESS_REGS.items()):
        print(f"    {ptx_reg} → r{phys_reg}")
    print(f"  Data registers (dynamic):")
    for ptx_reg, phys_reg in sorted(reg_map.items(), key=lambda x: x[1]):
        print(f"    {ptx_reg} → r{phys_reg}")
   
    # Write output
    with open(output_file, 'w') as f:
        for i, instr in enumerate(all_instructions):
            f.write(f"{instr:08x}\n")
    
    print(f"Translated {len(all_instructions)} instructions")

# =========================================================
# ENTRY POINT
# =========================================================
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 ptx2custom.py kernel.ptx [output.txt]")
        sys.exit(1)
    
    input_file = sys.argv[1]
    
    # Check if input file exists
    if not os.path.exists(input_file):
        print(f"Error: Input file '{input_file}' not found!")
        sys.exit(1)
    
    # Generate output filename automatically
    if len(sys.argv) > 2:
        output_file = sys.argv[2]
    else:
        # Remove .ptx extension and add _custom.txt
        base_name = os.path.splitext(input_file)[0]
        output_file = f"{base_name}_custom.txt"
    
    translate_ptx(input_file, output_file)
    print(f"Translation complete!")
