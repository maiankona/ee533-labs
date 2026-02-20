#!/usr/bin/env python3
import re
import sys

# ============================
# REGISTER MAP
# ============================
REG_MAP = {'r0':0, 'r1':1, 'r2':2, 'r3':3, 'r4':4, 'r5':5, 'r6':6, 'r7':7, 'sp':7, 'fp':3, 'pc':5}

def get_reg(x):
    if not x: return 0
    x = x.lower().strip('[]!, ')
    if x in REG_MAP: return REG_MAP[x]
    m = re.search(r"r(\d+)", x)
    return int(m.group(1)) & 0x7 if m else 0

OPCODES = {
    'ADD': 0b0000, 'SUB': 0b0001, 'AND': 0b0010, 'OR': 0b0011,
    'SLL': 0b0100, 'XOR': 0b1010, 'RSB': 0b1101, 'MVN': 0b1110,
    'CMP': 0b0001, 'LSL': 0b0100
}

def encode(WMemEn, WRegEn, Reg1, Reg2, WReg, alu, ALUSrc, Branch, BrType, imm):
    word = 0
    word |= (WMemEn & 1) << 31
    word |= (WRegEn & 1) << 30
    word |= (Reg1 & 0x7) << 27
    word |= (Reg2 & 0x7) << 24
    word |= (WReg & 0x7) << 21
    word |= (alu  & 0xF) << 17
    word |= (ALUSrc & 1) << 16
    word |= (Branch & 1) << 15
    word |= (BrType & 1) << 14
    word |= (int(imm) & 0x3FFF)
    return word

def get_imm(x):
    if not x: return 0
    match = re.search(r"-?\d+", x.replace('#', ''))
    return int(match.group(0)) if match else 0

def parse_line(line):
    line = re.sub(r'@.*', '', line).split('#')[0].strip()
    if not line or line.startswith('.') or line.endswith(':'): return None
    # Keep brackets and hashes for LDR/STR parsing
    return re.findall(r"[^\s,]+", line)

def translate(tokens, current_addr, label_map):
    instr = tokens[0].upper()
    # Clean tokens for easier matching, but keep original for side-by-side
    ops = [t.strip('!,') for t in tokens[1:]]
    
    WMemEn=WRegEn=ALUSrc=Branch=BrType=0
    Reg1=Reg2=WReg=alu=imm=0

    # Data Processing
    if instr in ['ADD','SUB','AND','ORR','EOR','RSB']:
        WRegEn, WReg = 1, get_reg(ops[0])
        Reg1 = get_reg(ops[1]) if len(ops) > 1 else WReg
        src = ops[-1]
        if '#' in src: ALUSrc, imm = 1, get_imm(src)
        else: Reg2 = get_reg(src)
        alu = OPCODES.get('OR' if instr=='ORR' else instr, 0)

    elif instr in ['MOV', 'MVN']:
        WRegEn, WReg = 1, get_reg(ops[0])
        alu = OPCODES['ADD'] if instr=='MOV' else OPCODES['MVN']
        if len(ops) > 1:
            if '#' in ops[1]: ALUSrc, imm = 1, get_imm(ops[1])
            else: Reg1 = get_reg(ops[1])

    elif instr == 'CMP':
        Reg1, alu = get_reg(ops[0]), OPCODES['CMP']
        if len(ops) > 1:
            if '#' in ops[1]: ALUSrc, imm = 1, get_imm(ops[1])
            else: Reg2 = get_reg(ops[1])

    # Memory Access
    elif instr in ['LDR', 'STR', 'PUSH']:
        if instr == 'PUSH': 
            WMemEn, Reg2, Reg1, ALUSrc, alu, imm = 1, get_reg('fp'), get_reg('sp'), 1, 1, -4
        else:
            is_ldr = (instr == 'LDR')
            WRegEn, WMemEn = (1, 0) if is_ldr else (0, 1)
            WReg = get_reg(ops[0]) if is_ldr else 0
            Reg2 = get_reg(ops[0]) if not is_ldr else 0
            
            # Handle LDR r3, [fp, #-16]
            if len(ops) > 1:
                Reg1 = get_reg(ops[1])
                ALUSrc, alu = 1, OPCODES['ADD']
                imm = get_imm(ops[2]) if len(ops) > 2 else 0
            # Handle LDR r2, .L8 (PC Relative)
            elif ops[0].startswith('.'):
                Reg1, ALUSrc, alu = 5, 1, 0
                imm = label_map.get(ops[0], 0)

    # Shifts
    elif instr == 'LSL':
        WRegEn, WReg = 1, get_reg(ops[0])
        Reg1 = get_reg(ops[1]) if len(ops) > 2 else WReg
        ALUSrc, alu = 1, OPCODES['SLL']
        imm = (get_imm(ops[-1]) & 0x1F) << 6

    # Branches
    elif instr in ['B','BEQ','BLT','BLE','BGT','BNE']:
        Branch, ALUSrc = 1, 1
        # BrType 0 for BEQ/BNE/B, 1 for signed comps
        BrType = 0 if instr in ['B','BEQ','BNE'] else 1
        target_label = ops[0]
        if target_label in label_map:
            imm = (label_map[target_label] - (current_addr + 1))

    return encode(WMemEn, WRegEn, Reg1, Reg2, WReg, alu, ALUSrc, Branch, BrType, imm)

def main():
    if len(sys.argv) < 2: return
    infile = sys.argv[1]
    with open(infile, 'r') as f: lines = f.readlines()

    label_map, addr = {}, 0
    # Pass 1: Address labels
    for line in lines:
        raw = line.strip()
        if not raw or raw.startswith(('@', '.')) and not raw.endswith(':'): continue
        if raw.endswith(':'): label_map[raw[:-1]] = addr
        else: addr += 1
    
    # Pass 2: Translate and print
    addr = 0
    with open(infile.replace(".s", "_custom.txt"), "w") as out_f:
        for line in lines:
            tokens = parse_line(line)
            if tokens:
                code = translate(tokens, addr, label_map)
                # FORCED SIDE-BY-SIDE OUTPUT
                output_str = f"{addr:03x}: {code:08x}  |  {' '.join(tokens)}"
                print(output_str)
                out_f.write(f"{code:08x}\n")
                addr += 1

if __name__ == "__main__":
    main()
