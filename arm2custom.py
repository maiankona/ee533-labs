#!/usr/bin/env python3
import re
import sys

# ============================
# REGISTER MAP (ARM → 3-bit)
# ============================
REG_MAP = {
    'r0': 0, 'r1': 1, 'r2': 2, 'r3': 3,
    'r4': 4, 'r5': 5, 'r6': 6, 'r7': 7,
    'sp': 7, 'fp': 5, 'lr': 6
}

# ============================
# OPCODE MAP (matches pipeline alu_ctrl)
# ============================
OPCODES = {
    'ADD': 0b0000,
    'SUB': 0b0001,
    'AND': 0b0010,
    'OR' : 0b0011,
    'XOR': 0b1010,
    'SLL': 0b0100,
    'CMP': 0b0001,   # reuse SUB
    'RSB': 0b1101,   
    'MVN': 0b1110,
}

# ============================
# Instruction Encoder
# Format:
# [31]   WMemEn
# [30]   WRegEn
# [29:27] Reg1
# [26:24] Reg2
# [23:21] WReg
# [20:17] ALU Op
# [16]   ALUSrc
# [25]   Branch
# [24]   BrType
# [15:0] Imm
# ============================

def encode(WMemEn, WRegEn, Reg1, Reg2, WReg, alu, ALUSrc, Branch, BrType, imm):
    word = 0
    word |= (WMemEn & 1) << 31
    word |= (WRegEn & 1) << 30
    word |= (Reg1  & 0b111) << 27
    word |= (Reg2  & 0b111) << 24
    word |= (WReg  & 0b111) << 21
    word |= (alu   & 0b1111) << 17
    word |= (ALUSrc & 1) << 16
    word |= (Branch & 1) << 25
    word |= (BrType & 1) << 24
    word |= (imm & 0xFFFF)
    return word

# ============================
# Helpers
# ============================
def get_reg(x):
    x = x.lower()
    if x in REG_MAP:
        return REG_MAP[x]
    m = re.match(r"r(\d+)", x)
    if m:
        return int(m.group(1)) & 7
    return 0

def get_imm(x):
    x = x.replace('#','')
    if x.startswith('0x'):
        return int(x,16) & 0xFFFF
    return int(x) & 0xFFFF

# ============================
# ARM Parser
# ============================
def parse_line(line):
    line = line.split('@')[0].strip()
    if not line:
        return None
    if line.startswith('.') or line.endswith(':'):
        return None

    parts = re.split(r'[,\s\[\]]+', line)
    return [p for p in parts if p]

# ============================
# Translator
# ============================
def translate(tokens, current_addr, label_map):
    instr = tokens[0].upper()
    ops = tokens[1:]

    # Defaults
    WMemEn=WRegEn=ALUSrc=Branch=BrType=0
    Reg1=Reg2=WReg=0
    alu=0
    imm=0

    # ---------------- R-TYPE ----------------
    if instr in ['ADD','SUB','AND','ORR','EOR']:
        WRegEn=1
        WReg=get_reg(ops[0])
        Reg1=get_reg(ops[1])
        if ops[2].startswith('#'):
            ALUSrc=1
            imm=get_imm(ops[2])
        else:
            Reg2=get_reg(ops[2])
        alu = OPCODES['ADD' if instr=='ORR' else 'XOR' if instr=='EOR' else instr]

    # ---------------- MOV / MVN ----------------
    elif instr in ['MOV', 'MVN']:
        WRegEn = 1
        WReg = get_reg(ops[0])
        ALUSrc = 1 if ops[1].startswith('#') else 0
        if ALUSrc:
            imm = get_imm(ops[1])
        else:
            Reg1 = get_reg(ops[1])
        alu = OPCODES['ADD'] if instr == 'MOV' else OPCODES['MVN']

    # ---------------- CMP ----------------
    elif instr=='CMP':
        Reg1=get_reg(ops[0])
        if ops[1].startswith('#'):
            ALUSrc=1
            imm=get_imm(ops[1])
        else:
            Reg2=get_reg(ops[1])
        alu=OPCODES['CMP']

    # ---------------- LDR ----------------
    elif instr=='LDR':
        WRegEn=1
        WReg=get_reg(ops[0])
        Reg1=get_reg(ops[1])
        ALUSrc=1
        imm=get_imm(ops[2]) if len(ops)>2 else 0
        alu=OPCODES['ADD']

    # ---------------- STR ----------------
    elif instr=='STR':
        WMemEn=1
        Reg2=get_reg(ops[0])
        Reg1=get_reg(ops[1])
        ALUSrc=1
        imm=get_imm(ops[2]) if len(ops)>2 else 0
        alu=OPCODES['ADD']

    # ---------------- LSL ----------------
    elif instr=='LSL':
        WRegEn=1
        WReg=get_reg(ops[0])
        Reg1=get_reg(ops[1])
        ALUSrc=1
        imm=get_imm(ops[2])
        alu=OPCODES['SLL']
    # ---------------- RSB ----------------
    elif instr == 'RSB':
        WRegEn = 1
        WReg = get_reg(ops[0])
        Reg1 = get_reg(ops[1])
        if ops[2].startswith('#'):
            ALUSrc = 1
            imm = get_imm(ops[2])
        else:
            Reg2 = get_reg(ops[2])
        alu = OPCODES['RSB']

    # ---------------- BRANCH ----------------
    elif instr in ['B','BEQ','BLT','BLE','BGT']:
        Branch = 1
        # 0 for Unconditional/Equal, 1 for Inequalities based on your logic
        BrType = 0 if instr in ['B','BEQ'] else 1
        target_label = ops[0]
        if target_label in label_map:
            # Hardware expects relative offset: Target - (PC + 1)
            imm = (label_map[target_label] - (current_addr + 1)) & 0xFFFF
        else:
            print(f"Error: Label {target_label} not found")
            imm = 0

    else:
        print(f"Warning: Unsupported {instr}")
        return None

    return encode(WMemEn,WRegEn,Reg1,Reg2,WReg,alu,ALUSrc,Branch,BrType,imm)

# ============================
# MAIN
# ============================
def main():
    if len(sys.argv) < 2:
        print("Usage: python3 arm2custom.py file.s")
        sys.exit(1)

    with open(sys.argv[1]) as f:
        lines = f.readlines()

    label_map = {}
    instructions_to_process = []
    
    # PASS 1: Find labels and instructions
    addr = 0
    for line in lines:
        clean = line.split('@')[0].split('#')[0].strip()
        if not clean: continue
        
        if clean.endswith(':'):
            label_map[clean[:-1]] = addr
        elif not clean.startswith('.'):
            instructions_to_process.append(clean)
            addr += 1

    # PASS 2: Translate
    out_file = sys.argv[1].replace(".s", "_custom.txt")
    with open(out_file, 'w') as f:
        for i, raw_line in enumerate(instructions_to_process):
            tokens = parse_line(raw_line)
            word = translate(tokens, i, label_map)
            if word is not None:
                f.write(f"{i:08x}  {word:08x}  # {raw_line}\n")

    print(f"Wrote {len(instructions_to_process)} instructions to {out_file}")

if __name__ == "__main__":
    main()
