#!/usr/bin/env python3
import re
import sys

# ============================
# REGISTER MAP (ARM → 3-bit)
# ============================
REG_MAP = {
    'r0': 0, 'r1': 1, 'r2': 2, 'r3': 3,
    'r4': 4, 'r5': 5, 'r6': 6, 'r7': 7,
    'sp': 7, 'fp': 11, # fp is often r11, mapping to 3-bit might need care
    'lr': 14, 'pc': 15
}

# Mapping for 3-bit restricted architecture
def get_reg(x):
    x = x.lower().strip('[]!,')
    if x in REG_MAP:
        return REG_MAP[x] & 0x7
    m = re.search(r"r(\d+)", x)
    if m:
        return int(m.group(1)) & 0x7
    return 0

# ============================
# OPCODE MAP
# ============================
OPCODES = {
    'ADD': 0b0000, 'SUB': 0b0001, 'AND': 0b0010, 'OR': 0b0011,
    'SLL': 0b0100, 'XOR': 0b1010, 'RSB': 0b1101, 'MVN': 0b1110,
    'CMP': 0b0001, 'LSL': 0b0100
}

def encode(WMemEn, WRegEn, Reg1, Reg2, WReg, alu, ALUSrc, Branch, BrType, imm_or_shift):
    """
    imm_or_shift: 
      - If ALUSrc=0: 5-bit shift amount (bits 10:6)
      - If ALUSrc=1: 14-bit immediate (bits 13:0)
    """
    word = 0
    word |= (WMemEn & 1) << 31
    word |= (WRegEn & 1) << 30
    word |= (Reg1  & 0b111) << 27
    word |= (Reg2  & 0b111) << 24
    word |= (WReg  & 0b111) << 21
    word |= (alu   & 0b1111) << 17
    word |= (ALUSrc & 1) << 16
    word |= (Branch & 1) << 15
    word |= (BrType & 1) << 14
    
    if ALUSrc == 0:  # Register mode - use shift
        word |= (imm_or_shift & 0b11111) << 6  # 5-bit shift at bits 10:6
    else:  # Immediate mode
        word |= (imm_or_shift & 0x3FFF)  # 14-bit immediate at bits 13:0
    
    return word

def get_imm(x):
    # Remove ARM immediate prefix and suffixes like '!'
    x = x.replace('#', '').replace('!', '').replace('=', '').strip()
    try:
        if '0x' in x.lower(): return int(x, 16) & 0xFFFF
        # Use regex to find the first integer (handles negative signs)
        match = re.search(r"-?\d+", x)
        if match: return int(match.group(0)) & 0xFFFF
    except:
        pass
    return 0

def parse_line(line):
    # CRITICAL: Do NOT split on '#' because ARM uses it for immediates
    # Only split on '@' for comments
    line = line.split('@')[0].strip()
    if not line or line.startswith('.'):
        # Allow .word for literal pool counting
        if not line.startswith('.word'): return None
    if line.endswith(':'): return None
    
    parts = re.split(r'[,\s\[\]]+', line)
    return [p for p in parts if p]

def translate(tokens, current_addr, label_map):
    instr = tokens[0].upper()
    ops = tokens[1:]

    WMemEn=WRegEn=ALUSrc=Branch=BrType=0
    Reg1=Reg2=WReg=alu=imm=0

    # Safety check for empty operands
    if not ops and instr not in ['B']: return None

    # ---------------- ALU / R-TYPE ----------------
    if instr in ['ADD','SUB','AND','ORR','EOR','RSB']:
        WRegEn = 1
        WReg = get_reg(ops[0])
        # Handle 2-operand vs 3-operand: ADD r1, #4 vs ADD r1, r2, #4
        if len(ops) == 3:
            Reg1 = get_reg(ops[1])
            src_op = ops[2]
        else:
            Reg1 = WReg
            src_op = ops[1]
            
        if src_op.startswith('#'):
            ALUSrc = 1
            imm = get_imm(src_op)
        else:
            Reg2 = get_reg(src_op)
        
        op_key = 'OR' if instr=='ORR' else 'SLL' if instr=='LSL' else instr
        alu = OPCODES.get(op_key, 0)


    # ---------------- MOV / MVN ----------------
    elif instr in ['MOV', 'MVN']:
        WRegEn = 1
        WReg = get_reg(ops[0])
        if len(ops) > 1:
            if ops[1].startswith('#'):
                ALUSrc = 1
                imm = get_imm(ops[1])
            else:
                Reg1 = get_reg(ops[1])
        alu = OPCODES['ADD'] if instr == 'MOV' else OPCODES['MVN']

    # ---------------- LDR / STR ----------------
    elif instr in ['LDR', 'STR']:
        WRegEn = 1 if instr == 'LDR' else 0
        WMemEn = 1 if instr == 'STR' else 0
        WReg = get_reg(ops[0]) if instr == 'LDR' else 0
        Reg2 = get_reg(ops[0]) if instr == 'STR' else 0
        
        # Handle LDR r2, .L8 (Literal pool load)
        if len(ops) == 2 and ops[1] in label_map:
            ALUSrc = 1
            Reg1 = 0 # Assuming PC-relative or Absolute if your HW supports it
            imm = label_map[ops[1]] 
            alu = OPCODES['ADD']
        else:
            Reg1 = get_reg(ops[1]) if len(ops) > 1 else 0
            ALUSrc = 1
            imm = get_imm(ops[2]) if len(ops) > 2 else 0
            alu = OPCODES['ADD']

    # ---------------- CMP ----------------
    elif instr == 'CMP':
        Reg1 = get_reg(ops[0])
        if ops[1].startswith('#'):
            ALUSrc = 1
            imm = get_imm(ops[1])
        else:
            Reg2 = get_reg(ops[1])
        alu = OPCODES['CMP']
# LSL
    elif instr == 'LSL':
        WRegEn = 1
        WReg = get_reg(ops[0])
        Reg1 = get_reg(ops[1])
        ALUSrc = 0  # Register mode (shift uses bits 10:6)
        shift_amt = get_imm(ops[2]) & 0b11111  # 5 bits
        imm = shift_amt << 6  # Place shift in bits 10:6 of the immediate field
        alu = OPCODES['SLL']

    # ---------------- BRANCH ----------------
    elif instr in ['B','BEQ','BLT','BLE','BGT']:
        Branch = 1
        BrType = 0 if instr in ['B','BEQ'] else 1
        target = ops[0]
        if target in label_map:
            imm = (label_map[target] - (current_addr + 1)) & 0xFFFF
        else:
            imm = get_imm(target) # Fallback for absolute

    return encode(WMemEn, WRegEn, Reg1, Reg2, WReg, alu, ALUSrc, Branch, BrType, imm)

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 arm2custom.py file.s")
        sys.exit(1)

    with open(sys.argv[1]) as f:
        lines = f.readlines()

    label_map = {}
    instructions = []
    
    # PASS 1: Calculate addresses including literal pool words
    addr = 0
    for line in lines:
        clean = line.split('@')[0].strip()
        if not clean: continue
        if clean.endswith(':'):
            label_map[clean[:-1]] = addr
        elif not clean.startswith('.') or clean.startswith('.word'):
            instructions.append(clean)
            addr += 1

    # PASS 2: Translate
    out_name = sys.argv[1].replace(".s", "_custom.txt")
    with open(out_name, 'w') as f:
        for i, raw in enumerate(instructions):
            if raw.startswith('.word'):
                val = get_imm(raw.split('.word')[1])
                f.write(f"{i:08x}  {val:08x}  # {raw}\n")
                continue
            
            tokens = parse_line(raw)
            word = translate(tokens, i, label_map)
            if word is not None:
                f.write(f"{i:08x}  {word:08x}  # {raw}\n")

    print(f"Success: Wrote {len(instructions)} words to {out_name}")

if __name__ == "__main__":
    main()
