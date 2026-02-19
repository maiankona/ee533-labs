#!/usr/bin/env python3
import re
import sys

# Our custom instruction format:
# [31]   [30]    [29:27] [26:24] [23:21] [20:17] [16]   [25]    [24]      [15:0]
# WMemEn WRegEn  Reg1    Reg2    WReg    ALU_Op  ALUSrc Branch  BrType    offset/imm

# Register mapping (ARM r0-r7 -> our 3-bit registers)
REG_MAP = {
    'r0': '000', 'r1': '001', 'r2': '010', 'r3': '011',
    'r4': '100', 'r5': '101', 'r6': '110', 'r7': '111',
    'sp': '111', 'lr': '110', 'r11': '101'  # Map ARM regs to yours
}

# ALU operation code
ALU_OPS = {
    'ADD':  '0000', 'SUB':  '0001', 'AND':  '0010', 'OR':   '0011',
    'SLL':  '0100', 'SRL':  '0101', 'XNOR': '0110', 'EQ':   '0111',
    'LT':   '1000', 'GT':   '1001', 'XOR':  '1010', 'STC':  '1011',
    'SCMP': '1100', 'CMP':  '0001'  # CMP uses SUB
}

def parse_arm_instruction(line):
    """Parse ARM assembly line into components"""
    line = line.strip()
    
    # Remove comments
    if '@' in line:
        line = line.split('@')[0].strip()
    if not line:
        return None
    
    # Split instruction and operands
    parts = re.split(r'[\s,\[\]]+', line)
    parts = [p for p in parts if p]  # Remove empty strings
    
    if not parts:
        return None
    
    instr = parts[0].upper()
    operands = parts[1:] if len(parts) > 1 else []
    
    return {'instr': instr, 'operands': operands, 'original': line}

def get_register(reg_str):
    """Convert ARM register to 3-bit code"""
    reg_str = reg_str.lower().strip()
    if reg_str in REG_MAP:
        return REG_MAP[reg_str]
    # Try to extract register number
    match = re.match(r'r(\d+)', reg_str)
    if match:
        num = int(match.group(1))
        if num < 8:
            return format(num, '03b')
    return '000'  # Default to r0

def get_immediate(imm_str):
    """Extract immediate value and convert to 16-bit binary"""
    imm_str = imm_str.strip()
    
    # Handle #123 format
    if imm_str.startswith('#'):
        imm_str = imm_str[1:]
    
    # Handle hex
    if imm_str.startswith('0x'):
        value = int(imm_str, 16)
    else:
        value = int(imm_str)
    
    # Convert to 16-bit two's complement
    if value < 0:
        value = (1 << 16) + value
    
    return format(value & 0xFFFF, '016b')

def translate_instruction(parsed):
    """Translate ARM instruction to custom format"""
    if not parsed:
        return None
    
    instr = parsed['instr']
    ops = parsed['operands']
    
    # Default values
    WMemEn = '0'
    WRegEn = '0'
    Reg1 = '000'
    Reg2 = '000'
    WReg = '000'
    ALU_Op = '0000'
    ALUSrc = '0'
    Branch = '0'
    BrType = '0'
    Imm = '0000000000000000'
    
    # R-type: ADD, SUB, AND, OR, etc.
    if instr in ['ADD', 'SUB', 'AND', 'ORR', 'EOR', 'RSB']:
        WRegEn = '1'
        WReg = get_register(ops[0])      # Rd
        Reg1 = get_register(ops[1])      # Rn
        
        if ops[2].startswith('#'):  # Immediate
            ALUSrc = '1'
            Imm = get_immediate(ops[2])
        else:  # Register
            Reg2 = get_register(ops[2])
        
        alu_map = {'ADD': 'ADD', 'SUB': 'SUB', 'AND': 'AND', 
                   'ORR': 'OR', 'EOR': 'XOR', 'RSB': 'SUB'}
        ALU_Op = ALU_OPS.get(alu_map.get(instr, 'ADD'), '0000')
    
    # MOV: Move/copy register or immediate
    elif instr == 'MOV':
        WRegEn = '1'
        WReg = get_register(ops[0])
        
        if ops[1].startswith('#'):  # MOV rd, #imm
            ALUSrc = '1'
            Imm = get_immediate(ops[1])
            ALU_Op = ALU_OPS['ADD']  # ADD 0 + imm
            Reg1 = '000'  # r0 (assume 0)
        else:  # MOV rd, rs
            Reg1 = get_register(ops[1])
            ALU_Op = ALU_OPS['ADD']  # ADD rs + 0
            Reg2 = '000'
    
    # CMP: Compare (SUB without writing result)
    elif instr == 'CMP':
        WRegEn = '0'  # Don't write result
        Reg1 = get_register(ops[0])
        
        if ops[1].startswith('#'):
            ALUSrc = '1'
            Imm = get_immediate(ops[1])
        else:
            Reg2 = get_register(ops[1])
        
        ALU_Op = ALU_OPS['CMP']
    
    # LDR: Load from memory
    elif instr == 'LDR':
        WRegEn = '1'
        WReg = get_register(ops[0])
        
        # Parse [Rn, #offset] format
        base_reg = get_register(ops[1]) if len(ops) > 1 else '000'
        offset = ops[2] if len(ops) > 2 else '#0'
        
        Reg1 = base_reg
        ALUSrc = '1'
        Imm = get_immediate(offset)
        ALU_Op = ALU_OPS['ADD']  # Calculate address: base + offset
        # Note: You'll need to add MemRead signal to your format
    
    # STR: Store to memory
    elif instr == 'STR':
        WMemEn = '1'
        
        # Source register (value to store)
        Reg2 = get_register(ops[0])
        
        # Parse [Rn, #offset]
        base_reg = get_register(ops[1]) if len(ops) > 1 else '000'
        offset = ops[2] if len(ops) > 2 else '#0'
        
        Reg1 = base_reg
        ALUSrc = '1'
        Imm = get_immediate(offset)
        ALU_Op = ALU_OPS['ADD']
    
    # LSL: Logical shift left
    elif instr == 'LSL':
        WRegEn = '1'
        WReg = get_register(ops[0])
        Reg1 = get_register(ops[1])
        
        if ops[2].startswith('#'):
            # Shift amount goes in immediate field
            shift_amt = int(ops[2][1:])
            Imm = format(shift_amt, '016b')
            ALUSrc = '1'
        
        ALU_Op = ALU_OPS['SLL']
    
    # Branch instructions
    elif instr in ['B', 'BEQ', 'BNE', 'BLT', 'BLE', 'BGT', 'BGE']:
        Branch = '1'
        
        # Branch type
        branch_map = {
            'B':   '00',   # Unconditional (always branch)
            'BEQ': '00',   # Equal (zero flag set)
            'BNE': '01',   # Not equal
            'BLT': '10',   # Less than
            'BLE': '10',   # Less than or equal (use LT check)
            'BGT': '11',   # Greater than
            'BGE': '11'    # Greater or equal
        }
        BrType = branch_map.get(instr, '00')[0]  # Just use first bit for now
        
        # Branch target (label or offset)
        # For now, just store as immediate
        target = ops[0] if ops else '0'
        if target.startswith('#'):
            Imm = get_immediate(target)
        else:
            # Label - will need to resolve in second pass
            Imm = '0000000000000000'  # Placeholder
    
    else:
        print(f"Warning: Unsupported instruction '{instr}'")
        return None
    
    # Construct 32-bit instruction
    # [31]   [30]    [29:27] [26:24] [23:21] [20:17] [16]   [25]    [24]    [15:0]
    # WMemEn WRegEn  Reg1    Reg2    WReg    ALU_Op  ALUSrc Branch  BrType  Imm
    
    instruction = (WMemEn + WRegEn + Reg1 + Reg2 + WReg + 
                   ALU_Op + ALUSrc + Branch + BrType + Imm)
    
    # Convert to hex
    instr_int = int(instruction, 2)
    hex_instr = format(instr_int, '08x')
    
    return {
        'binary': instruction,
        'hex': hex_instr,
        'original': parsed['original']
    }

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 arm_to_custom.py <arm_assembly_file>")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = input_file.replace('.s', '_custom.txt')
    
    print(f"Translating {input_file} to custom format...")
    
    with open(input_file, 'r') as f:
        lines = f.readlines()
    
    translated = []
    for i, line in enumerate(lines):
        parsed = parse_arm_instruction(line)
        result = translate_instruction(parsed)
        
        if result:
            translated.append(result)
            print(f"{i:3d}: {result['hex']} | {result['original']}")
    
    # Write to output file
    with open(output_file, 'w') as f:
        f.write("# Custom instruction format\n")
        f.write("# Address | Hex      | Original ARM\n")
        f.write("#" + "-"*60 + "\n")
        for i, instr in enumerate(translated):
            f.write(f"{i:08x}  {instr['hex']}  # {instr['original']}\n")
    
    print(f"\nWrote {len(translated)} instructions to {output_file}")

if __name__ == '__main__':
    main()
