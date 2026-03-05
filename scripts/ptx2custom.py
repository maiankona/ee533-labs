#!/usr/bin/env python3
"""
PTX to Custom GPU ISA Translator with RAW Hazard Detection
Converts NVIDIA PTX assembly to our custom 32-bit GPU instructions
Automatically inserts NOPs for pipeline hazards
"""

import re
import sys
import os

ARRAY_A_BASE = 0x0001
ARRAY_B_BASE = 0x0029
ARRAY_C_BASE = 0x0051
ARRAY_D_BASE = 0x0079  # For MAC

# Tracks which memory base (A/B/C/D) each PTX address register corresponds to
addr_source = {}

# =========================================================
# INSTRUCTION FORMAT ENCODING
# =========================================================
def encode_R(opcode, rd, rs1, rs2, width=0b00):
    """R-Type: | opcode(6) | rd(5) | rs1(5) | rs2(5) | unused(9) | width(2)"""
    instr = 0
    instr |= (opcode & 0x3F) << 26
    instr |= (rd & 0x1F) << 21
    instr |= (rs1 & 0x1F) << 16
    instr |= (rs2 & 0x1F) << 11
    instr |= (width & 0x3) << 0
    return instr

def encode_I(opcode, rd, rs1, width, imm14):
    """I-Type: | opcode(6) | rd(5) | rs1(5) | imm14(14) | width(2)"""
    instr = 0
    instr |= (opcode & 0x3F) << 26
    instr |= (rd & 0x1F) << 21
    instr |= (rs1 & 0x1F) << 16
    instr |= (imm14 & 0x3FFF) << 2
    instr |= (width & 0x3) << 0
    return instr

def encode_B(opcode, rs1, rs2, offset):
    """B-Type: | opcode(6) | rs1(5) | rs2(5) | branch_offset(16) |"""
    instr = 0
    instr |= (opcode & 0x3F) << 26
    instr |= (rs1 & 0x1F) << 21
    instr |= (rs2 & 0x1F) << 16
    instr |= (offset & 0xFFFF) << 0
    return instr

# =========================================================
# HAZARD DETECTION
# =========================================================
class HazardTracker:
    def __init__(self):
        self.pending_writes = []  # List of (reg, cycles_until_ready)
    
    def tick(self):
        """Advance one cycle, decrement all pending write counters"""
        self.pending_writes = [(reg, cycles-1) for reg, cycles in self.pending_writes if cycles > 1]
    
    def add_write(self, reg, latency):
        """Register that 'reg' will be written in 'latency' cycles"""
        if reg != 0:  # r0 is always 0, ignore
            self.pending_writes.append((reg, latency))
    
    def check_hazard(self, read_regs):
        """Check if any read_regs have pending writes. Return max NOPs needed."""
        max_nops = 0
        for read_reg in read_regs:
            if read_reg == 0:
                continue
            for pending_reg, cycles in self.pending_writes:
                if pending_reg == read_reg:
                    max_nops = max(max_nops, cycles)
        return max_nops
    
    def insert_nops(self, count):
        """Insert NOPs and advance the tracker"""
        nops = []
        for _ in range(count):
            nops.append(encode_I(0x00, 0, 0, 0, 0))  # NOP
            self.tick()
        return nops

# =========================================================
# REGISTER MAPPING
# =========================================================
ADDRESS_REGS = {
    '%rd1': 6, '%rd2': 5, '%rd3': 4, '%rd4': 4,
    '%rd5': 5, '%rd6': 6, '%rd7': 7, '%rd8': 8,
    '%rd9': 9, '%rd10': 6, '%rd11': 5, '%rd12': 4, '%rd13': 4,
}

reg_map = {}
next_reg = 1

def get_reg(ptx_reg):
    global next_reg
    if ptx_reg in ADDRESS_REGS:
        return ADDRESS_REGS[ptx_reg]
    if ptx_reg not in reg_map:
        while next_reg >= 4 and next_reg <= 9:
            next_reg += 1
        if next_reg >= 32:
            reg_map[ptx_reg] = 31
        else:
            reg_map[ptx_reg] = next_reg
            next_reg += 1
    return reg_map[ptx_reg]

def reset_regs():
    global reg_map, next_reg
    reg_map = {}
    next_reg = 1

# =========================================================
# PTX INSTRUCTION TRANSLATION
# =========================================================
def translate_line(line, hazard_tracker):
    line = line.strip()
    
    # Skip inline asm, comments, directives
    if any(x in line for x in ['// begin inline asm', '// end inline asm', '{.reg', '}', 'mov.b16']):
        return []

    # Getting correct destination registers
    if 'ld.param.u64' in line:
    match = re.search(r'ld\.param\.u64\s+(%\w+)', line)
    if match:
        dst = match.group(1)
        # Assign base based on the PTX register
        if dst == '%rd1':
            addr_source[dst] = 'A'
        elif dst == '%rd2':
            addr_source[dst] = 'B'
        elif dst == '%rd3':
            addr_source[dst] = 'C'
        elif dst == '%rd4':
            addr_source[dst] = 'D'
    return []    
    
    if 'cvta.to.global' in line:
    match = re.search(r'cvta\.to\.global\.\w+\s+(%\w+),\s*(%\w+)', line)
    if match:
        dst, src = match.group(1), match.group(2)
        addr_source[dst] = addr_source.get(src, None)
    return []
    
    if 'add.s64' in line:
    match = re.search(r'add\.s64\s+(%\w+),\s*(%\w+),\s*(%\w+)', line)
    if match:
        dst, src1, src2 = match.group(1), match.group(2), match.group(3)
        # Only propagate base if src1 is a memory pointer
        if src1 in addr_source:
            addr_source[dst] = addr_source[src1]
    # fall through to normal ADD handling
    
    # Skip thread-related operations
    skip_keywords = ['ld.param', 'cvta.to.global', 'mov.u32', 'tid.x',
                     'cvt.u64.u32', 'shl.b64', 'shr.s64', 'mul.wide', 'add.s64']
    if any(kw in line for kw in skip_keywords):
        return []
    
    if not line or line.startswith(('//','.','{','}')):
        return []
    
    instructions = []
    
    # ===== LOAD (LD has 3-cycle latency) =====
    if 'ld.global' in line:
        match = re.search(r'ld\.global\.(u\d+)\s+(%\w+),\s*\[(%\w+)\];?', line)
        if match:
            rd = get_reg(match.group(2))
            rs1 = get_reg(match.group(3))
            # For LD
            base = addr_source.get(match.group(3), None)
            if base == 'A':
                rs1 = 6
            elif base == 'B':
                rs1 = 5
            elif base == 'C':
                rs1 = 4
            elif base == 'D':
                rs1 = 7       
            # Check hazard: reading rs1
            nops_needed = hazard_tracker.check_hazard([rs1])
            instructions.extend(hazard_tracker.insert_nops(nops_needed))
            
            # LD instruction (16-bit SIMD for all)
            instructions.append(encode_I(0x12, rd, rs1, 0b00, 0))
            hazard_tracker.tick()
            hazard_tracker.add_write(rd, 3)  # LD has 3-cycle latency
            
            # Insert 3 NOPs for LD latency
            instructions.extend(hazard_tracker.insert_nops(3))
        return instructions
    
    # ===== ADD 16-bit SIMD =====
    if 'add.s16' in line or 'add.s32' in line:
        match = re.search(r'add\.s\d+\s+(%\w+),\s*(%\w+),\s*(%\w+);?', line)
        if match:
            rd = get_reg(match.group(1))
            rs1 = get_reg(match.group(2))
            rs2 = get_reg(match.group(3))
            
            # Check hazard: reading rs1 and rs2
            nops_needed = hazard_tracker.check_hazard([rs1, rs2])
            instructions.extend(hazard_tracker.insert_nops(nops_needed))
            
            # VADD_I16 (16-bit SIMD only)
            instructions.append(encode_R(0x01, rd, rs1, rs2, 0b00))
            hazard_tracker.tick()
            hazard_tracker.add_write(rd, 1)  # ALU has 1-cycle latency
        return instructions
    
    # ===== SUB 16-bit SIMD =====
    if 'sub.s16' in line:
        match = re.search(r'sub\.s16\s+(%\w+),\s*(%\w+),\s*(%\w+)', line)
        if match:
            rd = get_reg(match.group(1))
            rs1 = get_reg(match.group(2))
            rs2 = get_reg(match.group(3))
            
            nops_needed = hazard_tracker.check_hazard([rs1, rs2])
            instructions.extend(hazard_tracker.insert_nops(nops_needed))
            
            instructions.append(encode_R(0x02, rd, rs1, rs2, 0b00))
            hazard_tracker.tick()
            hazard_tracker.add_write(rd, 1)
        return instructions
    
    # ===== FMA BF16 =====
    if 'fma.rn.bf16' in line:
        match = re.search(r'fma\.rn\.bf16\s+(%\w+),\s*(%\w+),\s*(%\w+),\s*(\w+)', line)
        if match:
            rd = get_reg(match.group(1))
            rs1 = get_reg(match.group(2))
            rs2 = get_reg(match.group(3))
            accum_str = match.group(4)
            
            if accum_str.startswith('%'):
                rs3 = get_reg(accum_str)
                
                # Check hazard
                nops_needed = hazard_tracker.check_hazard([rs1, rs2, rs3])
                instructions.extend(hazard_tracker.insert_nops(nops_needed))
                
                # MOV if needed
                if rs3 != rd:
                    instructions.append(encode_I(0x19, rd, rs3, 0, 0b00))
                    hazard_tracker.tick()
                
                # VMAC
                instructions.append(encode_R(0x09, rd, rs1, rs2, 0b00))
                hazard_tracker.tick()
                hazard_tracker.add_write(rd, 10)  # FMA has 10-cycle latency
            else:
                # VMUL only (inline asm with constant)
                nops_needed = hazard_tracker.check_hazard([rs1, rs2])
                instructions.extend(hazard_tracker.insert_nops(nops_needed))
                
                instructions.append(encode_R(0x08, rd, rs1, rs2, 0b00))
                hazard_tracker.tick()
                hazard_tracker.add_write(rd, 5)  # MUL has 5-cycle latency
        return instructions
    
    # ===== ReLU =====
    if 'max.s16' in line:
        match = re.search(r'max\.s16\s+(%\w+),\s*(%\w+)', line)
        if match:
            rd = get_reg(match.group(1))
            rs1 = get_reg(match.group(2))
            
            nops_needed = hazard_tracker.check_hazard([rs1])
            instructions.extend(hazard_tracker.insert_nops(nops_needed))
            
            instructions.append(encode_R(0x0A, rd, rs1, 0, 0b00))
            hazard_tracker.tick()
            hazard_tracker.add_write(rd, 1)  # ReLU has 1-cycle latency
        return instructions
    
    # ===== STORE =====
    if 'st.global' in line:
        match = re.search(r'st\.global\.(u\d+)\s+\[(%\w+)\],\s*(%\w+);?', line)
        if match:
            rs1 = get_reg(match.group(2))  # Address
            rs2 = get_reg(match.group(3))  # Data
            # For ST
            base = addr_source.get(match.group(2), None)
            if base == 'A':
                rs1 = 6
            elif base == 'B':
                rs1 = 5
            elif base == 'C':
                rs1 = 4
            elif base == 'D':
                rs1 = 7            
            # Check hazard: reading rs1 and rs2
            nops_needed = hazard_tracker.check_hazard([rs1, rs2])
            instructions.extend(hazard_tracker.insert_nops(nops_needed))
            
            # ST (16-bit SIMD)
            instructions.append(encode_I(0x13, rs2, rs1, 0b00, 0))
            hazard_tracker.tick()
        return instructions
    
    # ===== HALT =====
    if 'ret' in line:
        instructions.append(encode_R(0x0B, 0, 0, 0, 0))
        hazard_tracker.tick()
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
    hazard_tracker = HazardTracker()
    
    # Initialize address registers (16-bit SIMD for consistency)
    all_instructions.append(encode_I(0x19, 6, 0, 0b10, ARRAY_A_BASE))
    all_instructions.append(encode_I(0x19, 5, 0, 0b10, ARRAY_B_BASE))
    all_instructions.append(encode_I(0x19, 4, 0, 0b10, ARRAY_C_BASE))
    all_instructions.append(encode_I(0x19, 7, 0, 0b10, ARRAY_D_BASE))
    
    for line in lines:
        if '.visible .entry' in line:
            in_function = True
            reset_regs()
            hazard_tracker = HazardTracker()  # Reset for each function
            
            # ===== OPTIONAL: Add per-function initialization =====
            # function_count += 1
            # if function_count > 1:
            #     # Function 2+ gets different base addresses
            #     all_instructions.append(encode_I(0x19, 6, 0, 0b10, ARRAY_A_BASE + 0x10))
            #     all_instructions.append(encode_I(0x19, 5, 0, 0b10, ARRAY_B_BASE + 0x10))
            #     all_instructions.append(encode_I(0x19, 4, 0, 0b10, ARRAY_C_BASE + 0x10))
            continue
        
        if in_function:
            instrs = translate_line(line, hazard_tracker)
            all_instructions.extend(instrs)
            
            if line.strip() == '}':
                in_function = False
    
    # Write hex output
    with open(output_file, 'w') as f:
        for instr in all_instructions:
            f.write(f"{instr:08x}\n")
    
    
    print(f"\nTranslated {len(all_instructions)} instructions")
    print(f"Hex output: {output_file}")

# =========================================================
# ENTRY POINT
# =========================================================
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 ptx2custom.py kernel.ptx [output.txt]")
        sys.exit(1)
    
    input_file = sys.argv[1]
    
    if not os.path.exists(input_file):
        print(f"Error: Input file '{input_file}' not found!")
        sys.exit(1)
    
    if len(sys.argv) > 2:
        output_file = sys.argv[2]
    else:
        base_name = os.path.splitext(input_file)[0]
        output_file = f"{base_name}_custom.txt"
    
    translate_ptx(input_file, output_file)
    print(f"Translation complete!")
