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
def translate(tokens):
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

    # ---------------- MOV ----------------
    elif instr=='MOV':
        WRegEn=1
        WReg=get_reg(ops[0])
        if ops[1].startswith('#'):
            ALUSrc=1
            imm=get_imm(ops[1])
            Reg1=0
            alu=OPCODES['ADD']
        else:
            Reg1=get_reg(ops[1])
            alu=OPCODES['ADD']

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

    # ---------------- MVN ----------------
    elif instr == 'MVN':
        WRegEn = 1
        WReg = get_reg(ops[0])
        # MVN Rd, Rn usually means Rd = ~Rn. 
        # In our ALU, 'B' is the source for NOT, so we put Rn in Reg2 slot.
        if ops[1].startswith('#'):
            ALUSrc = 1
            imm = get_imm(ops[1])
        else:
            Reg2 = get_reg(ops[1])
            ALUSrc = 0
        alu = OPCODES['MVN']

    # ---------------- BRANCH ----------------
    elif instr in ['B','BEQ','BLT','BLE','BGT']:
        Branch=1
        BrType = 0 if instr in ['B','BEQ'] else 1
        imm=0  # label resolution NOT implemented
        alu=0

    else:
        print(f"Warning: Unsupported {instr}")
        return None

    return encode(WMemEn,WRegEn,Reg1,Reg2,WReg,alu,ALUSrc,Branch,BrType,imm)

# ============================
# MAIN
# ============================
def main():
    if len(sys.argv)<2:
        print("Usage: python3 arm2custom.py file.s")
        exit(1)

    infile=sys.argv[1]
    outfile=infile.replace(".s","_custom.txt")

    with open(infile) as f:
        lines=f.readlines()

    out=[]
    for i,line in enumerate(lines):
        tokens=parse_line(line)
        if not tokens:
            continue
        word=translate(tokens)
        if word is not None:
            out.append((i,word,line.strip()))

    with open(outfile,'w') as f:
        for i,(ln,word,orig) in enumerate(out):
            f.write(f"{i:08x}  {word:08x}  # {orig}\n")

    print(f"Wrote {len(out)} instructions to {outfile}")

if __name__=="__main__":
    main()
