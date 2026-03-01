#!/usr/bin/env python3
"""
Create data memory COE file for vector add test
"""

def create_data_coe():
    # Test data
    A = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]      # Array A at 0x00
    B = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]  # Array B at 0x0A
    C = [0] * 10                              # Array C at 0x14 (output)
    
    with open('vector_add_data.coe', 'w') as f:
        f.write("memory_initialization_radix=16;\n")
        f.write("memory_initialization_vector=\n")
        
        # Write A
        for val in A:
            f.write(f"{val:08x},\n")
        
        # Write B
        for val in B:
            f.write(f"{val:08x},\n")
        
        # Write C (zeros)
        for i, val in enumerate(C):
            if i == len(C) - 1:
                f.write(f"{val:08x};\n")  # Last one with semicolon
            else:
                f.write(f"{val:08x},\n")
    
    print("Created vector_add_data.coe")
    print("  Array A (0x00-0x09): 1, 2, 3, ..., 10")
    print("  Array B (0x0A-0x13): 10, 20, 30, ..., 100")
    print("  Array C (0x14-0x1D): [output space]")

if __name__ == "__main__":
    create_data_coe()
