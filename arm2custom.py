#!/usr/bin/env python3
"""
ARM Assembly to Hex Translator with Custom BLT
Flow: ARM assembly → ARM hex → Parse & handle BLT → Output hex
"""

import subprocess
import struct
import re
import os
import sys
import tempfile

# Custom BLT Encoding
def encode_custom_blt(rs1, rs2, offset):
    """
    Encode custom BLT instruction
    Format: [31:28]=1011 [27:26]=10 [19:16]=rs1 [11:4]=offset [3:0]=rs2
    """
    cond = 0xB       # BLT condition
    typ = 0x2        # Branch type
    
    instr = (cond << 28) | (typ << 26) | (rs1 << 16) | ((offset & 0xFF) << 4) | rs2
    return instr

def is_blt_instruction(instr):
    """Check if instruction is BLT (condition code = 1011, branch format)"""
    cond = (instr >> 28) & 0xF
    opcode = (instr >> 24) & 0xF
    
    # Standard ARM BLT: cond=1011 (B), opcode=1010 (branch)
    # Or check if it's branch instruction with LT condition
    return cond == 0xB and ((instr >> 25) & 0x7) == 0x5  # Branch instruction

def extract_blt_info(instr):
    """Extract rs1, rs2, offset from standard ARM BLT instruction"""
    # Standard ARM branch: [23:0] = signed offset
    branch_offset = instr & 0xFFFFFF
    
    # Sign extend 24-bit to 32-bit
    if branch_offset & 0x800000:
        branch_offset |= 0xFF000000
    
    # For your custom encoding, you'll need rs1, rs2
    # Standard ARM BLT doesn't encode these - they come from previous CMP
    # So we'll need to track CMP instructions
    
    return branch_offset

# ARM Assembly to Hex Conversion
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
        # Assemble to object file
        result = subprocess.run(
            ['arm-none-eabi-gcc', '-c', asm_file, '-o', obj_file],
            capture_output=True, text=True
        )
        
        if result.returncode != 0:
            print("Assembly errors:")
            print(result.stderr)
            return None
        
        # Disassemble to get hex opcodes
        result = subprocess.run(
            ['arm-none-eabi-objdump', '-d', obj_file],
            capture_output=True, text=True
        )
        
        if result.returncode != 0:
            print("Objdump errors:")
            print(result.stderr)
            return None
        
        # Write objdump output
        with open(dump_file, 'w') as f:
            f.write(result.stdout)
        
        # Parse objdump output
        instructions = []
        
        # objdump format:
        #    0:   e3a0100a        mov     r1, #10
        #    4:   e3a02014        mov     r2, #20
        
        for line in result.stdout.split('\n'):
            line = line.strip()
            if not line or ':' not in line:
                continue
            
            # Parse line: "  4:   e3a02014        mov     r2, #20"
            match = re.match(r'^\s*([0-9a-f]+):\s+([0-9a-f]+)\s+(.*)$', line)
            if match:
                addr = int(match.group(1), 16)
                hex_instr = match.group(2)
                disasm = match.group(3).strip()
                
                # Convert hex string to integer (handle endianness)
                instr_int = int(hex_instr, 16)
                
                instructions.append((addr, instr_int, disasm))
        
        return instructions
    
    finally:
        # Cleanup
        for f in [obj_file, dump_file]:
            if os.path.exists(f):
                os.remove(f)

# Parse and Handle BLT
def process_instructions(instructions):
    """
    Process instruction list:
    - Pass through non-BLT instructions unchanged
    - Re-encode BLT instructions with custom format
    """
    
    output_instructions = []
    prev_cmp_rs1 = None
    prev_cmp_rs2 = None
    
    for i, instr in enumerate(instructions):
        # Decode instruction
        cond = (instr >> 28) & 0xF
        typ = (instr >> 26) & 0x3
        opcode = (instr >> 21) & 0xF
        
        # Track CMP instructions (for BLT register operands)
        # CMP is: type=00 (data processing), opcode=1010, S-bit=1
        if typ == 0 and opcode == 0xA and (instr & (1 << 20)):
            # CMP instruction
            prev_cmp_rs1 = (instr >> 16) & 0xF  # Rn
            prev_cmp_rs2 = instr & 0xF          # Rm (if not immediate)
            
            # Pass through unchanged
            output_instructions.append(instr)
            print(f"[{i:03d}] 0x{instr:08X}  @ CMP r{prev_cmp_rs1}, r{prev_cmp_rs2}")
        
        # Handle BLT Instruction
        elif cond == 0xB and ((instr >> 25) & 0x7) == 0x5:
            # This is a BLT (branch with LT condition)
            
            # Extract branch offset (24-bit signed)
            offset_24bit = instr & 0xFFFFFF
            if offset_24bit & 0x800000:
                offset_24bit |= 0xFF000000
            
            # Convert word offset to byte offset, then adjust
            # ARM branches are PC+8 relative, in words
            offset = (offset_24bit & 0xFF)  # Truncate to 8-bit for your encoding
            
            # Use registers from previous CMP (if available)
            rs1 = prev_cmp_rs1 if prev_cmp_rs1 is not None else 0
            rs2 = prev_cmp_rs2 if prev_cmp_rs2 is not None else 0
            
            # Re-encode with custom format
            custom_instr = encode_custom_blt(rs1, rs2, offset)
            
            output_instructions.append(custom_instr)
            print(f"[{i:03d}] 0x{instr:08X}  → 0x{custom_instr:08X}  @ BLT r{rs1}, r{rs2}, offset={offset} (CUSTOM!)")
        
        # Pass Through All Other Instructions
        else:
            output_instructions.append(instr)
            
            # Decode for display
            if typ == 0:
                type_str = "ALU"
            elif typ == 1:
                type_str = "MEM"
            elif typ == 2:
                type_str = "BRANCH"
            else:
                type_str = "OTHER"
            
            print(f"[{i:03d}] 0x{instr:08X}  @ {type_str}")
    
    return output_instructions

# Output Generation
def write_hex_output(instructions, hex_file, verilog_file):
    """Write hex and Verilog output files"""
    
    # Write plain hex
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
    
    # Step 1: Convert ARM assembly to hex using toolchain
    print("Step 1: Assembling ARM code")
    instructions = arm_asm_to_hex(input_asm)
    
    if instructions is None:
        print("Assembly failed!")
        sys.exit(1)
    
    print(f"Generated {len(instructions)} instructions\n")
    
    # Step 2: Process instructions (handle BLT)
    print("Step 2: Processing instructions...")
    output_instructions = process_instructions(instructions)
    print()
    
    # Step 3: Write output
    write_hex_output(output_instructions, output_hex, output_verilog)
    
    print("\n Translation complete!\n")

if __name__ == "__main__":
    main()
