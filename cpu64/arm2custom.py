#!/usr/bin/env python3
"""
ARM Assembly to Hex Translator with Custom BLT
Flow: ARM assembly → objdump hex → Parse & handle BLT → Output hex
"""

import subprocess
import re
import os
import sys
import tempfile

# custom BLT encoding
def encode_custom_blt(rs1, rs2, offset):
    """
    Encode custom BLT instruction
    Format: [31:28]=1011 [27:26]=10 [19:16]=rs1 [11:4]=offset [3:0]=rs2
    """
    cond = 0xB       # BLT condition
    typ = 0x2        # Branch type
    
    instr = (cond << 28) | (typ << 26) | (rs1 << 16) | ((offset & 0xFF) << 4) | rs2
    return instr

# ARM assembly to hex via objdump
def arm_asm_to_hex(asm_file):
    """
    Convert ARM assembly to hex using objdump
    Returns list of (address, hex_instruction, disassembly) tuples
    """
    
    with tempfile.NamedTemporaryFile(suffix='.o', delete=False) as tmp_obj:
        obj_file = tmp_obj.name
    
    with tempfile.NamedTemporaryFile(suffix='_opcodes.txt', delete=False) as tmp_dump:
        dump_file = tmp_dump.name
    
    try:
        # assemble to object file
        result = subprocess.run(
            ['arm-none-eabi-gcc', '-c', asm_file, '-o', obj_file],
            capture_output=True, text=True
        )
        
        if result.returncode != 0:
            print("Assembly errors:")
            print(result.stderr)
            return None
        
        # disassemble to get hex opcodes
        result = subprocess.run(
            ['arm-none-eabi-objdump', '-d', obj_file],
            capture_output=True, text=True
        )
        
        if result.returncode != 0:
            print("Objdump errors:")
            print(result.stderr)
            return None
        
        # write objdump output
        with open(dump_file, 'w') as f:
            f.write(result.stdout)
        
        # parse objdump output
        instructions = []
        
        # objdump format:
        #    0:   e3a0100a        mov     r1, #10
        #    4:   e3a02014        mov     r2, #20
        
        for line in result.stdout.split('\n'):
            line = line.strip()
            if not line or ':' not in line:
                continue
            
            # parse line: "  4:   e3a02014        mov     r2, #20"
            match = re.match(r'^\s*([0-9a-f]+):\s+([0-9a-f]+)\s+(.*)$', line)
            if match:
                addr = int(match.group(1), 16)
                hex_instr = match.group(2)
                disasm = match.group(3).strip()
                
                # convert hex string to integer (handle endianness)
                instr_int = int(hex_instr, 16)
                
                instructions.append((addr, instr_int, disasm))
        
        return instructions
    
    finally:
        for f in [obj_file, dump_file]:
            if os.path.exists(f):
                os.remove(f)

# parse and handle BLT
def process_instructions(instructions):
    """
    Process instruction list:
    - Pass through non-BLT instructions unchanged
    - Re-encode BLT instructions with custom format
    """
    
    output_instructions = []
    prev_cmp_rs1 = None
    prev_cmp_rs2 = None
    
    for addr, instr, disasm in instructions:
        # decode instruction
        cond = (instr >> 28) & 0xF
        typ = (instr >> 26) & 0x3
        opcode = (instr >> 21) & 0xF
        
        if 'cmp' in disasm.lower():
            # parse CMP r1, r2 from disassembly
            match = re.search(r'cmp\s+r(\d+),\s*r(\d+)', disasm.lower())
            if match:
                prev_cmp_rs1 = int(match.group(1))
                prev_cmp_rs2 = int(match.group(2))
            
            # pass through unchanged
            output_instructions.append(instr)
            print(f"[{len(output_instructions)-1:03d}] 0x{instr:08X}  @ {disasm}")
        
        elif 'blt' in disasm.lower():
            # extract branch offset from instruction
            offset_24bit = instr & 0xFFFFFF
            if offset_24bit & 0x800000:  # sign extend
                offset_24bit |= 0xFF000000
            
            # ARM branch offset is in words, adjust to byte offset then divide by 4 to get instruction offset
            offset = (offset_24bit >> 2) & 0xFF
            
            # use registers from previous CMP
            rs1 = prev_cmp_rs1 if prev_cmp_rs1 is not None else 0
            rs2 = prev_cmp_rs2 if prev_cmp_rs2 is not None else 0
            
            # re-encode with custom format
            custom_instr = encode_custom_blt(rs1, rs2, offset)
            
            output_instructions.append(custom_instr)
            print(f"[{len(output_instructions)-1:03d}] 0x{instr:08X} → 0x{custom_instr:08X}  @ {disasm} (CUSTOM BLT r{rs1}, r{rs2})")
        
        else:
            output_instructions.append(instr)
            print(f"[{len(output_instructions)-1:03d}] 0x{instr:08X}  @ {disasm}")
    
    return output_instructions

def write_hex_output(instructions, hex_file, verilog_file):
    """Write hex and Verilog output files"""
    
    # write plain hex
    with open(hex_file, 'w') as f:
        for instr in instructions:
            f.write(f"0x{instr:08X}\n")
    
    
    print(f"\n{'='*60}")
    print(f"Output generated:")
    print(f"  Hex file:     {hex_file}")
    print(f"  Instructions: {len(instructions)}")
    print(f"{'='*60}")

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 arm2custom.py <input.s> [output.hex]")
        sys.exit(1)
    
    input_asm = sys.argv[1]
    output_hex = sys.argv[2] if len(sys.argv) > 2 else "output.hex"
    output_verilog = output_hex.replace('.hex', '_verilog.txt')
    
    print(f"{'='*60}")
    print(f"ARM to Hex Translator with Custom BLT")
    print(f"{'='*60}\n")
    
    # Step 1: Convert ARM assembly to hex using objdump
    print("Step 1: Assembling and extracting hex opcodes")
    instructions = arm_asm_to_hex(input_asm)
    
    if instructions is None:
        print("Assembly failed!")
        sys.exit(1)
    
    print(f"Extracted {len(instructions)} instructions\n")
    
    # Step 2: Process instructions (handle BLT)
    print("Step 2: Processing instructions")
    instruction_values = process_instructions(instructions)
    print()
    
    # Step 3: Write output
    print("Step 3: Writing output files")
    write_hex_output(instruction_values, output_hex, output_verilog)
    
    print("\n Translation complete!\n")

if __name__ == "__main__":
    main()
