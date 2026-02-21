#!/usr/bin/env python3
import re
import sys

# ============================
# REGISTER MAP (32 registers)
# ============================
REG_MAP = {f'r{i}': i for i in range(32)}
REG_MAP.update({'sp': 13, 'lr': 14, 'pc': 15, 'fp': 11})

def get_reg(x):
    if not x: return 0
    x = x.lower().strip('[]!, ')
    if x in REG_MAP: return REG_MAP[x]
    m = re.search(r"r(\d+)", x)
    return int(m.group(1)) & 0x1F if m else 0

OPCODES = {
    'ADD': 0b0000, 'SUB': 0b0001, 'AND': 0b0010, 'OR': 0b0011,
    'SLL': 0b0100, 'SRL': 0b0101, 'XOR': 0b1010, 
    'RSB': 0b1101, 'MVN': 0b1110, 'CMP': 0b0001
}

def encode(WMemEn, WRegEn, Reg1, Reg2, WReg, alu, ALUSrc, Branch, BrType, imm):
    """Encode single instruction"""
    word = 0
    word |= (WMemEn & 1) << 31
    word |= (WRegEn & 1) << 30
    word |= (Reg1 & 0x1F) << 25
    word |= (Reg2 & 0x1F) << 20
    word |= (WReg & 0x1F) << 15
    word |= (alu  & 0xF) << 11
    word |= (ALUSrc & 1) << 10
    word |= (Branch & 1) << 9
    word |= (BrType & 1) << 8
    imm_val = int(imm) & 0xFF
    word |= imm_val
    return word

def get_imm(x):
    if not x: return 0
    x = x.replace('#', '').replace('0x', '').strip()
    try:
        val = int(x, 16) if 'x' in x.lower() else int(x)
    except:
        val = 0
    return val

def encode_large_immediate(dest_reg, value, instructions):
    """
    Encode large immediate by breaking into multiple instructions.
    For value > 255, use multiple ADDs or shifts.
    """
    if -128 <= value <= 255:
        # Fits in 8 bits
        if value < 0:
            value = (256 + value) & 0xFF
        instructions.append(encode(0, 1, 0, 0, dest_reg, OPCODES['ADD'], 1, 0, 0, value))
        return
    
    # For values > 255, break down:
    # Strategy: Build up value in steps
    if 0 <= value <= 65535:
        # Use LSL approach: load lower byte, shift, add upper byte
        low_byte = value & 0xFF
        high_byte = (value >> 8) & 0xFF
        
        if high_byte > 0:
            # Load high byte
            instructions.append(encode(0, 1, 0, 0, dest_reg, OPCODES['ADD'], 1, 0, 0, high_byte))
            # Shift left by 8 (using LSL with shift=8)
            instructions.append(encode(0, 1, dest_reg, 0, dest_reg, OPCODES['SLL'], 1, 0, 0, 8))
            # Add low byte
            if low_byte > 0:
                instructions.append(encode(0, 1, dest_reg, 0, dest_reg, OPCODES['ADD'], 1, 0, 0, low_byte))
        else:
            instructions.append(encode(0, 1, 0, 0, dest_reg, OPCODES['ADD'], 1, 0, 0, low_byte))
    else:
        # Fallback: just use modulo 256
        instructions.append(encode(0, 1, 0, 0, dest_reg, OPCODES['ADD'], 1, 0, 0, value & 0xFF))

def parse_line(line):
    line = re.sub(r'@.*', '', line).strip()
    if not line or line.startswith('.') or line.endswith(':'): return None
    tokens = []
    current = ""
    in_brackets = False
    for char in line:
        if char == '[':
            in_brackets = True
            current += char
        elif char == ']':
            in_brackets = False
            current += char
        elif char in ' \t,' and not in_brackets:
            if current:
                tokens.append(current)
                current = ""
        else:
            current += char
    if current:
        tokens.append(current)
    return tokens if tokens else None

def translate(tokens, current_addr, label_map, instructions):
    """
    Translate one ARM instruction into one or more custom instructions.
    Returns number of instructions generated.
    """
    instr = tokens[0].upper()
    ops = tokens[1:] if len(tokens) > 1 else []
    
    count = 0
    
    # ============ PUSH {fp} ============
    if instr == 'PUSH':
        # str fp, [sp, #-4]
        instructions.append(encode(1, 0, 13, 11, 0, OPCODES['SUB'], 1, 0, 0, 4))
        count += 1
        return count

    # ============ DATA PROCESSING ============
    if instr in ['ADD', 'SUB', 'AND', 'ORR', 'EOR', 'RSB']:
        WReg = get_reg(ops[0])
        
        if len(ops) == 2:
            Reg1 = WReg
            src = ops[1]
        else:
            Reg1 = get_reg(ops[1])
            src = ops[2] if len(ops) > 2 else ops[1]
        
        op_map = {'ORR': 'OR', 'EOR': 'XOR'}
        alu = OPCODES.get(op_map.get(instr, instr), 0)
        
        if '#' in src:
            imm_val = get_imm(src)
            if -128 <= imm_val <= 255:
                imm = imm_val & 0xFF
                instructions.append(encode(0, 1, Reg1, 0, WReg, alu, 1, 0, 0, imm))
                count += 1
            else:
                # Large immediate - use temp register r10
                encode_large_immediate(10, imm_val, instructions)
                count += len(instructions) - len(instructions[:-3])
                # Now do operation with temp register
                instructions.append(encode(0, 1, Reg1, 10, WReg, alu, 0, 0, 0, 0))
                count += 1
        else:
            Reg2 = get_reg(src)
            instructions.append(encode(0, 1, Reg1, Reg2, WReg, alu, 0, 0, 0, 0))
            count += 1
        return count

    # ============ MOV / MVN ============
    elif instr in ['MOV', 'MVN']:
        WReg = get_reg(ops[0])
        alu = OPCODES['ADD'] if instr == 'MOV' else OPCODES['MVN']
        
        if len(ops) > 1:
            src = ops[1]
            if '#' in src:
                imm_val = get_imm(src)
                if -128 <= imm_val <= 255:
                    imm = imm_val & 0xFF
                    instructions.append(encode(0, 1, 0, 0, WReg, alu, 1, 0, 0, imm))
                    count += 1
                else:
                    # Large immediate
                    encode_large_immediate(WReg, imm_val, instructions)
                    count += len(instructions) - count
            else:
                Reg1 = get_reg(src)
                instructions.append(encode(0, 1, Reg1, 0, WReg, alu, 0, 0, 0, 0))
                count += 1
        return count

    # ============ CMP ============
    elif instr == 'CMP':
        Reg1 = get_reg(ops[0])
        if len(ops) > 1:
            src = ops[1]
            if '#' in src:
                imm = get_imm(src) & 0xFF
                instructions.append(encode(0, 0, Reg1, 0, 0, OPCODES['CMP'], 1, 0, 0, imm))
            else:
                Reg2 = get_reg(src)
                instructions.append(encode(0, 0, Reg1, Reg2, 0, OPCODES['CMP'], 0, 0, 0, 0))
        count += 1
        return count

    # ============ LDR ============
    elif instr == 'LDR':
        WReg = get_reg(ops[0])
        
        # LDR r3, [fp, #-16]
        if '[' in ops[1]:
            base_match = re.search(r'\[([^\],]+)', ops[1])
            if base_match:
                Reg1 = get_reg(base_match.group(1))
            
            offset = 0
            offset_match = re.search(r'#(-?\d+)', ops[1])
            if offset_match:
                offset = get_imm(offset_match.group(1))
            elif len(ops) > 2:
                offset_match = re.search(r'#(-?\d+)', ops[2])
                if offset_match:
                    offset = get_imm(offset_match.group(1))
            
            # Handle signed offset
            if offset < 0:
                offset = (256 + offset) & 0xFF
            
            if offset <= 255:
                instructions.append(encode(0, 1, Reg1, 0, WReg, OPCODES['ADD'], 1, 0, 0, offset))
                count += 1
            else:
                # Large offset - compute address in temp register
                encode_large_immediate(10, offset, instructions)
                count += len(instructions) - count
                instructions.append(encode(0, 1, Reg1, 10, 10, OPCODES['ADD'], 0, 0, 0, 0))
                instructions.append(encode(0, 1, 10, 0, WReg, OPCODES['ADD'], 1, 0, 0, 0))
                count += 2
        
        # LDR r2, .L8 - literal pool (ignore, use immediate data instead)
        else:
            # Skip literal pool loads - they need to be handled specially
            # For now, load 0
            instructions.append(encode(0, 1, 0, 0, WReg, OPCODES['ADD'], 1, 0, 0, 0))
            count += 1
        
        return count

    # ============ STR ============
    elif instr == 'STR':
        Reg2 = get_reg(ops[0])
        
        if '[' in ops[1]:
            base_match = re.search(r'\[([^\],]+)', ops[1])
            if base_match:
                Reg1 = get_reg(base_match.group(1))
            
            offset = 0
            offset_match = re.search(r'#(-?\d+)', ops[1])
            if offset_match:
                offset = get_imm(offset_match.group(1))
            elif len(ops) > 2:
                offset_match = re.search(r'#(-?\d+)', ops[2])
                if offset_match:
                    offset = get_imm(offset_match.group(1))
            
            if offset < 0:
                offset = (256 + offset) & 0xFF
            
            instructions.append(encode(1, 0, Reg1, Reg2, 0, OPCODES['ADD'], 1, 0, 0, offset))
            count += 1
        
        return count

    # ============ LSL ============
    elif instr == 'LSL':
        WReg = get_reg(ops[0])
        Reg1 = get_reg(ops[1]) if len(ops) > 1 else WReg
        shift_amt = get_imm(ops[-1]) & 0x1F
        
        instructions.append(encode(0, 1, Reg1, 0, WReg, OPCODES['SLL'], 1, 0, 0, shift_amt))
        count += 1
        return count

    # ============ BRANCHES ============
    elif instr in ['B', 'BEQ', 'BNE', 'BLT', 'BLE', 'BGT', 'BGE']:
        BrType = 0 if instr in ['B', 'BEQ', 'BNE'] else 1
        
        target_label = ops[0]
        if target_label in label_map:
            offset = label_map[target_label] - (current_addr + 1)
            imm = offset & 0xFF
        else:
            imm = 0
        
        instructions.append(encode(0, 0, 0, 0, 0, 0, 1, 1, BrType, imm))
        count += 1
        return count

    # Unknown instruction - skip
    return 0

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 arm2custom_smart.py <file.s>")
        return
    
    infile = sys.argv[1]
    with open(infile, 'r') as f:
        lines = f.readlines()

    # Pass 1: Build label map (need to account for multi-instruction expansions)
    label_map = {}
    addr = 0
    for line in lines:
        raw = line.strip()
        if not raw or raw.startswith('@'):
            continue
        if raw.startswith('.') and not raw.endswith(':'):
            continue
        if raw.endswith(':'):
            label_map[raw[:-1]] = addr
        else:
            tokens = parse_line(raw)
            if tokens:
                # Estimate instruction count (most are 1, MOV with large imm is 3)
                if tokens[0].upper() == 'MOV' and len(tokens) > 1 and '#' in tokens[-1]:
                    val = get_imm(tokens[-1])
                    if val > 255:
                        addr += 3  # Will expand to multiple instructions
                    else:
                        addr += 1
                else:
                    addr += 1
    
    print(f"Label map: {label_map}")
    
    # Pass 2: Translate with multi-instruction support
    all_instructions = []
    addr = 0
    assembly_lines = []
    
    for line in lines:
        tokens = parse_line(line)
        if tokens:
            count = translate(tokens, addr, label_map, all_instructions)
            for i in range(count):
                assembly_lines.append((' '.join(tokens), addr + i))
            addr += count
    
    # Write output
    outfile = infile.replace('.s', '_custom.txt')
    with open(outfile, 'w') as out_f:
        for i, code in enumerate(all_instructions):
            asm_line = ""
            for line, line_addr in assembly_lines:
                if line_addr == i:
                    asm_line = line
                    break
            output_str = f"{i:03x}: {code:08x}  |  {asm_line}"
            print(output_str)
            out_f.write(f"{code:08x}\n")
    
    print(f"\nWrote {len(all_instructions)} instructions to {outfile}")

if __name__ == "__main__":
    main()
