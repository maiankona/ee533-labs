#!/usr/bin/perl -w
use lib "/usr/local/netfpga/lib/Perl5";
use strict;

# ======================================================
# IDS GPU Register Map
# SW regs (read/write):
#   reg 0: input_type  0x2000200  [1]=dmem_we [2]=dmem_read_req [3]=gpu_imem_we
#   reg 1: address     0x2000204  [7:0]=bram_inst_addr [15:8]=bram_length
#   reg 2: imem        0x2000208  instruction data
#   reg 3: dmem        0x200020C  dmem write data (32-bit, replicated to 64-bit in hw)
#   reg 4: gpu_ctrl    0x2000210  [0]=gpu_start strobe
# HW regs (read only):
#   reg 0: dmem_out    0x2000214  last DMEM read result (32-bit)
#   reg 1: tensor_out  0x2000218  last tensor result [31:0]
# ======================================================

my $IDS_INPUT_TYPE_REG  = 0x2000200;
my $IDS_ADDRESS_REG     = 0x2000204;
my $IDS_IMEM_REG        = 0x2000208;
my $IDS_DMEM_REG        = 0x200020C;
my $IDS_GPU_CTRL_REG    = 0x2000210;
my $IDS_DMEM_OUT_REG    = 0x2000214;
my $IDS_TENSOR_OUT_REG  = 0x2000218;

# input_type bit masks
my $DMEM_WE       = 0x2;
my $DMEM_READ_REQ = 0x4;
my $GPU_IMEM_WE   = 0x8;

# ======================================================
# Low-level register access (same as working script)
# ======================================================
sub regwrite {
    my ($addr, $value) = @_;
    my $cmd = sprintf("regwrite 0x%08x 0x%08x", $addr, $value);
    system($cmd) == 0 or die "Failed: $cmd\n";
}

sub regread {
    my ($addr) = @_;
    my $cmd = sprintf("regread 0x%08x", $addr);
    my @out = `$cmd`;
    if ($out[0] =~ m/Reg (0x[0-9a-f]+).*:\s+(0x[0-9a-f]+)/i) {
        return hex($2);
    }
    die "Unexpected regread output from: $cmd\n";
}

sub clear_input_type {
    regwrite($IDS_INPUT_TYPE_REG, 0x0);
}

# ======================================================
# IMEM write
# input_type[3]=gpu_imem_we, address[8:0]=addr, imem=instr
# ======================================================
sub write_imem {
    my ($addr, $instr) = @_;
    regwrite($IDS_ADDRESS_REG,    $addr);
    regwrite($IDS_IMEM_REG,       $instr);
    regwrite($IDS_INPUT_TYPE_REG, $GPU_IMEM_WE);
    clear_input_type();
}

# ======================================================
# DMEM write: 32-bit data, replicated to 64-bit in memory.v
# input_type[1]=dmem_we, address[7:0]=addr, dmem=data
# ======================================================
sub write_dmem {
    my ($addr, $data32) = @_;
    regwrite($IDS_ADDRESS_REG,    $addr);
    regwrite($IDS_DMEM_REG,       $data32);
    regwrite($IDS_INPUT_TYPE_REG, $DMEM_WE);
    clear_input_type();
}

# ======================================================
# DMEM read
# ======================================================
sub read_dmem {
    my ($addr) = @_;
    regwrite($IDS_ADDRESS_REG,    $addr);
    regwrite($IDS_INPUT_TYPE_REG, $DMEM_READ_REQ);
    clear_input_type();
    my $val = regread($IDS_DMEM_OUT_REG);
    printf("  DMEM[0x%02x] = 0x%08x\n", $addr, $val);
    return $val;
}

# ======================================================
# Dispatch GPU
# ======================================================
sub dispatch_gpu {
    my ($bram_inst_addr, $bram_length) = @_;
    $bram_inst_addr //= 0x00;
    $bram_length    //= 32;
    my $addr_val = ($bram_length << 8) | ($bram_inst_addr & 0xFF);
    regwrite($IDS_ADDRESS_REG,  $addr_val);
    regwrite($IDS_GPU_CTRL_REG, 0x1);
    regwrite($IDS_GPU_CTRL_REG, 0x0);
    printf("  GPU dispatched: bram_inst_addr=0x%02x bram_length=%d\n",
           $bram_inst_addr, $bram_length);
}

# ======================================================
# Run full GPU test
# ======================================================
sub run_gpu_test {
    print "\n========================================\n";
    print "GPU BF16 TENSOR TEST\n";
    print "========================================\n\n";

    # ---- IMEM ----
    my @imem = (
        0x48400000,  # 00: LW r1, 0(r0)
        0x48600004,  # 01: LW r2, 4(r0)
        0x48800008,  # 02: LW r3, 8(r0)
        0x48A0000C,  # 03: LW r4, 12(r0)
        0x00000000,  # 04: NOP
        0x00000000,  # 05: NOP
        0x00000000,  # 06: NOP
        0x00000000,  # 07: NOP
        0x00000000,  # 08: NOP
        0x00000000,  # 09: NOP
        0x00000000,  # 0A: NOP
        0x18C21800,  # 0B: VADD  r6, r1, r2  -> DMEM[6]
        0x00000000,  # 0C: NOP
        0x00000000,  # 0D: NOP
        0x00000000,  # 0E: NOP
        0x1CE21800,  # 0F: VSUB  r7, r3, r4  -> DMEM[7]
        0x00000000,  # 10: NOP
        0x00000000,  # 11: NOP
        0x00000000,  # 12: NOP
        0x21021800,  # 13: VMUL  r8, r1, r2  -> DMEM[8]
        0x00000000,  # 14: NOP
        0x00000000,  # 15: NOP
        0x00000000,  # 16: NOP
        0x25222000,  # 17: VMAC  r9, r2, r4  -> DMEM[9]
        0x00000000,  # 18: NOP
        0x00000000,  # 19: NOP
        0x00000000,  # 1A: NOP
        0x29450000,  # 1B: VRELU r3, r9      -> DMEM[3]
        0x2C000000,  # 1C: HALT
        0x00000000,  # 1D: NOP
        0x00000000,  # 1E: NOP
        0x00000000,  # 1F: NOP
    );

    # ---- DMEM operands ----
    # Loaded at both word addresses 0-3 AND byte-offset addresses 4,8,12
    # to cover both possible address mapping schemes.
    # r1=1.5 (3FC0), r2=4.0 (4080), r3=8.0 (4100), r4=-3.0 (C040)
    my @dmem = (
        0x3FC03FC0,  # addr 0:  r1=1.5  (LW r1, 0(r0)  -> addr 0)
        0x40804080,  # addr 1:  r2=4.0  (if pipeline uses word>>2 addressing)
        0x41004100,  # addr 2:  r3=8.0
        0xC040C040,  # addr 3:  r4=-3.0
        0x40804080,  # addr 4:  r2=4.0  (LW r2, 4(r0)  -> addr 4, direct)
        0x00000000,  # addr 5:
        0x00000000,  # addr 6:  VADD r6 result
        0x00000000,  # addr 7:  VSUB r7 result
        0x41004100,  # addr 8:  r3=8.0  (LW r3, 8(r0)  -> addr 8, direct)
        0x00000000,  # addr 9:  VMAC r9 result
        0x00000000,  # addr 10:
        0x00000000,  # addr 11:
        0xC040C040,  # addr 12: r4=-3.0 (LW r4, 12(r0) -> addr 12, direct)
    );

    # Load IMEM
    print "Loading IMEM (" . scalar(@imem) . " instructions)...\n";
    for my $i (0 .. $#imem) {
        write_imem($i, $imem[$i]);
        printf("  IMEM[0x%03x] = 0x%08x\n", $i, $imem[$i]);
    }
    print "IMEM loaded.\n\n";

    # Load DMEM
    print "Loading DMEM (" . scalar(@dmem) . " words)...\n";
    for my $i (0 .. $#dmem) {
        write_dmem($i, $dmem[$i]);
        printf("  DMEM[0x%02x] = 0x%08x\n", $i, $dmem[$i]);
    }
    print "DMEM loaded.\n\n";

    # Dispatch
    print "Dispatching GPU...\n";
    dispatch_gpu(0x00, 32);
    sleep(1);
    print "Done.\n\n";

    # Results
    print "========================================\n";
    print "DMEM RESULTS\n";
    print "Expected (if r2=4.0, r3=8.0, r4=-3.0):\n";
    print "  DMEM[6] VADD  r6 = 0x40b040b0  (5.5)\n";
    print "  DMEM[7] VSUB  r7 = 0x41304130  (11.0)\n";
    print "  DMEM[8] VMUL  r8 = 0x40c040c0  (6.0)\n";
    print "  DMEM[9] VMAC  r9 = 0xc140c140  (-12.0)\n";
    print "  DMEM[3] VRELU r3 = 0x00000000  (0.0)\n";
    print "Actual:\n";
    read_dmem(6);
    read_dmem(7);
    read_dmem(8);
    read_dmem(9);
    read_dmem(3);

    print "\n";
    my $tensor_out = regread($IDS_TENSOR_OUT_REG);
    printf("TENSOR_OUT[31:0] = 0x%08x\n", $tensor_out);
    print "========================================\n\n";
}

# ======================================================
# Register dump
# ======================================================
sub dump_regs {
    print "\n========================================\n";
    print "IDS REGISTER DUMP\n";
    print "========================================\n";
    printf("INPUT_TYPE  (0x%08x) = 0x%08x\n", $IDS_INPUT_TYPE_REG, regread($IDS_INPUT_TYPE_REG));
    printf("ADDRESS     (0x%08x) = 0x%08x\n", $IDS_ADDRESS_REG,    regread($IDS_ADDRESS_REG));
    printf("IMEM        (0x%08x) = 0x%08x\n", $IDS_IMEM_REG,       regread($IDS_IMEM_REG));
    printf("DMEM        (0x%08x) = 0x%08x\n", $IDS_DMEM_REG,       regread($IDS_DMEM_REG));
    printf("GPU_CTRL    (0x%08x) = 0x%08x\n", $IDS_GPU_CTRL_REG,   regread($IDS_GPU_CTRL_REG));
    printf("DMEM_OUT    (0x%08x) = 0x%08x\n", $IDS_DMEM_OUT_REG,   regread($IDS_DMEM_OUT_REG));
    printf("TENSOR_OUT  (0x%08x) = 0x%08x\n", $IDS_TENSOR_OUT_REG, regread($IDS_TENSOR_OUT_REG));
    print "========================================\n\n";
}

# ======================================================
# CLI
# ======================================================
sub usage {
    print "Usage:\n";
    print "  gpu_test.pl test              - Run full BF16 tensor test\n";
    print "  gpu_test.pl regs              - Dump all IDS registers\n";
    print "  gpu_test.pl imem <addr> <hex> - Write single IMEM instruction\n";
    print "  gpu_test.pl dmem <addr> <hex> - Write single DMEM word (32-bit)\n";
    print "  gpu_test.pl dmemr <addr>      - Read single DMEM word\n";
    print "  gpu_test.pl dispatch          - Dispatch GPU (bram_addr=0, length=32)\n";
    print "\n";
}

my $cmd = $ARGV[0] or do { usage(); exit(1); };

if    ($cmd eq "test")    { run_gpu_test(); }
elsif ($cmd eq "regs")    { dump_regs(); }
elsif ($cmd eq "dispatch"){ dispatch_gpu(0x00, 32); }
elsif ($cmd eq "imem")    { write_imem(hex($ARGV[1]), hex($ARGV[2])); }
elsif ($cmd eq "dmem")    { write_dmem(hex($ARGV[1]), hex($ARGV[2])); }
elsif ($cmd eq "dmemr")   { read_dmem(hex($ARGV[1])); }
else                      { print "Unknown command: $cmd\n"; usage(); }
