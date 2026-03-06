#!/usr/bin/env python3
"""
ARM to Custom ISA Translator
Supports 3-bit register fields (r0-r7) and custom BLT logic.
Usage: python3 arm2custom.py program.s [output.txt]
"""

import re
import sys
import os

# =========================================================
# CUSTOM ISA CONFIGURATION (Matches your Verilog)
# =========================================================
OPCODES = {
    'ADD':  0b0000, 'ADDI': 0b0001, 'LW':   0b0010, 
    'SW':   0b0011, 'AND':  0b0100, 'OR':   0b0101, 
    'XOR':  0b0110, 'SUB':  0b0111, 'SLT':  0b1000, 
    'BR':   0b1010
}

BR_TYPE = {
    'B':   0b00,
    'BNE': 0b01,
    'BLT': 0b10,  # Your custom comparison logic
    'BEQ': 0b11
}

def encode_custom(wmem=0, wreg=0, rs1=0, rs2=0, rd=0, opcode=0, alusrc=0, shift=0, imm12=0):
    """
    Packs bits into the 32-bit format defined in your Verilog:
    | wmem(1) | wreg(1) | rs1(3) | rs2(3) | rd(3) | opcode(4) | ALUSrc(1) | shift(4) | imm12(12) |
    """
    instr = 0
    instr |= (wmem & 0x1)   << 31
    instr |= (wreg & 0x1)   << 30
    instr |= (rs1 & 0x7)    << 27
    instr |= (rs2 & 0x7)    << 24
    instr |= (rd & 0x7)     << 21
    instr |= (opcode & 0xF) << 17
    instr |= (alusrc & 0x1) << 16
    instr |= (shift & 0xF)  << 12
    instr |= (imm12 & 0xFFF) << 0
    return instr

# =========================================================
# PARSING UTILITIES
# =========================================================
def get_reg_num(reg_str):
    """Converts 'r0' -> 0, 'r7' -> 7. Errors if > 7."""
    try:
        num = int(re.search(r'\d+', reg_str).group())
        if num > 7:
            print(f"Error: Register r{num} out of bounds for 3-bit field!")
            sys.exit(1)
        return num
    except:
        return 0

def translate_file(input_path, output_path):
    with open(input_path, 'r') as f:
        lines = f.readlines()

    labels = {}
    instructions_asm = []
    
    # --- Pass 1: Find Labels and clean code ---
    pc = 0
    for line in lines:
        line = line.strip().split('//')[0].split(';')[0] # Remove comments
        if not line: continue
        
        if ':' in line:
            label, rest = line.split(':')
            labels[label.strip()] = pc
            line = rest.strip()
            
        if line:
            instructions_asm.append(line)
            pc += 1

    # --- Pass 2: Encoding ---
    hex_output = []
    for current_pc, line in enumerate(instructions_asm):
        parts = re.split(r'[,\s]+', line)
        op = parts[0].upper()
        instr_hex = 0

        try:
            # ALU R-TYPE (ADD r1, r2, r3)
            if op in ['ADD', 'SUB', 'AND', 'OR', 'XOR', 'SLT']:
                rd, rs1, rs2 = get_reg_num(parts[1]), get_reg_num(parts[2]), get_reg_num(parts[3])
                instr_hex = encode_custom(wreg=1, rs1=rs1, rs2=rs2, rd=rd, opcode=OPCODES[op], alusrc=0)

            # ADDI (ADDI r1, r2, #5) or MOV (MOV r1, #10)
            elif op == 'ADDI' or (op == 'MOV' and '#' in parts[2]):
                rd = get_reg_num(parts[1])
                rs1 = get_reg_num(parts[2]) if op == 'ADDI' else 0
                imm = int(parts[-1].replace('#', ''), 0)
                instr_hex = encode_custom(wreg=1, rs1=rs1, rd=rd, opcode=OPCODES['ADDI'], alusrc=1, imm12=imm)

            # LOAD / STORE (LDR r1, [r2, #4])
            elif op in ['LDR', 'STR']:
                rd = get_reg_num(parts[1])
                addr_match = re.search(r'\[(r\d+)(?:,\s*#?(-?\d+))?\]', line)
                rs1 = get_reg_num(addr_match.group(1))
                imm = int(addr_match.group(2)) if addr_match.group(2) else 0
                
                if op == 'LDR':
                    instr_hex = encode_custom(wreg=1, rs1=rs1, rd=rd, opcode=OPCODES['LW'], alusrc=1, imm12=imm)
                else: # STR
                    instr_hex = encode_custom(wmem=1, rs1=rs1, rs2=rd, opcode=OPCODES['SW'], alusrc=1, imm12=imm)

            # BRANCHES (B, BNE, BLT)
            elif op in ['B', 'BNE', 'BLT']:
                b_type = BR_TYPE[op]
                if op in ['BLT', 'BNE']:
                    rs1, rs2 = get_reg_num(parts[1]), get_reg_num(parts[2])
                    target = parts[3]
                else: # Unconditional Branch
                    rs1, rs2, target = 0, 0, parts[1]
                
                offset = (labels[target] - current_pc) & 0x1FF
                imm_val = (b_type << 9) | offset
                instr_hex = encode_custom(rs1=rs1, rs2=rs2, opcode=OPCODES['BR'], imm12=imm_val)

            else:
                print(f"Warning: Unknown instruction '{op}' at PC {current_pc}")
                instr_hex = 0

            hex_output.append(instr_hex)

        except Exception as e:
            print(f"Error parsing line {current_pc}: {line}\n{e}")
            sys.exit(1)

    # Write output
    with open(output_path, 'w') as f:
        for val in hex_output:
            f.write(f"{val:08x}\n")
    
    print(f"Successfully translated {len(hex_output)} lines to {output_path}")

# =========================================================
# ENTRY POINT
# =========================================================
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 arm2custom.py input.s [output.txt]")
        sys.exit(1)
        
    in_file = sys.argv[1]
    out_file = sys.argv[2] if len(sys.argv) > 2 else "program_hex.txt"
    
    if os.path.exists(in_file):
        translate_file(in_file, out_file)
    else:
        print(f"Error: File {in_file} not found.")
