#!/usr/bin/perl -w
use lib "/usr/local/netfpga/lib/Perl5";
use strict;

my $IDS_INPUT_TYPE  = 0x2000200;
my $IDS_ADDRESS     = 0x2000204;
my $IDS_IMEM        = 0x2000208;
my $IDS_DMEM        = 0x200020c;
my $IDS_GPU_MODE    = 0x2000210;
my $IDS_DMEM_OUT    = 0x2000214;  # DMEM read [31:0]
my $IDS_DMEM_OUT_HI = 0x2000218;  # DMEM read [63:32]
my $IDS_IMEM_OUT    = 0x200021c;

my $IMEM_WE   = 0x01;
my $DMEM_WE   = 0x02;
my $DMEM_RD   = 0x04;
my $GPU_START = 0x08;
my $IMEM_RD   = 0x10; 

sub regwrite {
   my( $addr, $value ) = @_;
   my $cmd = sprintf("regwrite 0x%08x 0x%08x", $addr, $value);
   my $result = `$cmd`;
   # print "Ran command '$cmd' and got result '$result'\n";
}

sub regread {
    my ($addr) = @_;
    my $cmd = sprintf("regread 0x%08x", $addr);
    my @out = `$cmd`;
    my $result = $out[0];
    if (defined($result) && $result =~ m/Reg (0x[0-9a-f]+) \(\d+\):\s+(0x[0-9a-f]+) \(\d+\)/i) {
        return hex($2);
    }
    my @hex = ($result =~ /0x([0-9a-f]+)/ig) if defined $result;
    return @hex ? hex($hex[-1]) : 0;
}

# Full 64b is latched into dmem_out_lo + dmem_out_hi; pick half like old addr[0] mux.
sub dmem_read32 {
    my ($addr) = @_;
    regwrite($IDS_ADDRESS, $addr);
    sleep(1);
    regwrite($IDS_INPUT_TYPE, $DMEM_RD);  # assert read request
    regwrite($IDS_INPUT_TYPE, $DMEM_RD);
    sleep(1);
    my $lo = regread($IDS_DMEM_OUT);
    my $hi = regread($IDS_DMEM_OUT_HI);
    regwrite($IDS_INPUT_TYPE, 0x00);      # deassert after capture
    sleep(1);
    return ($addr & 1) ? $hi : $lo;
}

sub usage {
    print "Usage: gpu_add2.pl <cmd>\n";
    print "  Commands:\n";
    print "    run      run full GPU ALU add test (default)\n";
    print "    allregs  print all IDS registers\n";
}

sub allregs {
    print "IDS registers:\n";
    print "  INPUT_TYPE: ", sprintf("0x%08x", regread($IDS_INPUT_TYPE)), "\n";
    print "  ADDRESS:    ", sprintf("0x%08x", regread($IDS_ADDRESS)), "\n";
    print "  IMEM:       ", sprintf("0x%08x", regread($IDS_IMEM)), "\n";
    print "  DMEM:       ", sprintf("0x%08x", regread($IDS_DMEM)), "\n";
    print "  GPU_MODE:   ", sprintf("0x%08x", regread($IDS_GPU_MODE)), "\n";
    print "  DMEM_OUT_LO:", sprintf("0x%08x", regread($IDS_DMEM_OUT)), "\n";
    print "  DMEM_OUT_HI:", sprintf("0x%08x", regread($IDS_DMEM_OUT_HI)), "\n";
    print "  IMEM_OUT:   ", sprintf("0x%08x", regread($IDS_IMEM_OUT)), "\n";
}

my $numargs = $#ARGV + 1;
my $cmd = ($numargs >= 1) ? $ARGV[0] : "run";
if ($cmd eq "allregs") {
    allregs();
    exit(0);
}
if ($cmd ne "run") {
    print "Unrecognized command: $cmd\n";
    usage();
    exit(1);
}

print "=" x 70 . "\n";
print "GPU ALU INTEGER ADD TEST\n";
print "=" x 70 . "\n\n";

print "STEP 0: Set gpu_mode (FIFO PROCESSING)...\n";
regwrite($IDS_GPU_MODE, 1);
sleep(1);
print "  ✓ gpu_mode = 1\n\n";

my @program = (
    0x64c001c0,  # [0]  MOVI r6, #0x70
    0x64a001d0,  # [1]  MOVI r5, #0x74
    0x64800300,  # [2]  MOVI r4, #0xC0
    0x00000000,  # [3]  NOP (before first load)
    0x48260000,  # [4]  LDR  r1, [r6]
    0x00000000,  # [5]  NOP (LD latency)
    0x00000000,  # [6]  NOP
    0x00000000,  # [7]  NOP
    0x48450000,  # [8]  LDR  r2, [r5]
    0x00000000,  # [9]  NOP (LD latency)
    0x00000000,  # [10] NOP
    0x00000000,  # [11] NOP
    0x04611000,  # [12] ADD  r3, r1, r2
    0x00000000,  # [13] NOP (ALU latency)
    0x4c640000,  # [14] STR  r3, [r4]
    0x2c000000,  # [15] HALT
);

print "STEP 1: Load program into IMEM...\n";
for my $i (0 .. $#program) {
    regwrite($IDS_ADDRESS, $i);
    sleep(1);
    regwrite($IDS_IMEM, $program[$i]);
    sleep(1);
    regwrite($IDS_INPUT_TYPE, $IMEM_WE);
    regwrite($IDS_INPUT_TYPE, 0x00);
    printf("  IMEM[%d] = 0x%08X\n", $i, $program[$i]);
}
print "  ✓ Loaded " . scalar(@program) . " instructions\n\n";

print "  Verify IMEM readback:\n";
for my $i (0 .. 2) {  # spot-check first 3 instructions
    regwrite($IDS_ADDRESS, $i);
    sleep(1);
    regwrite($IDS_INPUT_TYPE, $IMEM_RD);
    regwrite($IDS_INPUT_TYPE, $IMEM_RD);
    regwrite($IDS_INPUT_TYPE, 0x00);
    sleep(1);
    my $readback = regread($IDS_IMEM_OUT);
    printf("    IMEM[%d] = 0x%08X (expect 0x%08X) %s\n", $i, $readback, $program[$i],
           $readback == $program[$i] ? "✓" : "✗");
}
print "\n";


print "STEP 1: Load test data into DMEM...\n";
regwrite($IDS_ADDRESS, 0x70);
sleep(1);
regwrite($IDS_DMEM, 0x00001000);
sleep(1);
regwrite($IDS_INPUT_TYPE, $DMEM_WE);
sleep(1);
regwrite($IDS_INPUT_TYPE, 0x00);
print "  DMEM[0x70] = 0x00001000 (A lo)\n";

regwrite($IDS_ADDRESS, 0x71);
sleep(1);
regwrite($IDS_DMEM, 0x00000100);
sleep(1);
regwrite($IDS_INPUT_TYPE, $DMEM_WE);
sleep(1);
regwrite($IDS_INPUT_TYPE, 0x00);
print "  DMEM[0x71] = 0x00000100 (A hi)\n";

regwrite($IDS_ADDRESS, 0x74);
sleep(1);
regwrite($IDS_DMEM, 0x00000200);
sleep(1);
regwrite($IDS_INPUT_TYPE, $DMEM_WE);
sleep(1);
regwrite($IDS_INPUT_TYPE, 0x00);
print "  DMEM[0x74] = 0x00000200 (B lo)\n";

regwrite($IDS_ADDRESS, 0x75);
sleep(1);
regwrite($IDS_DMEM, 0x00000020);
sleep(1);
regwrite($IDS_INPUT_TYPE, $DMEM_WE);
sleep(1);
regwrite($IDS_INPUT_TYPE, 0x00);
print "  DMEM[0x75] = 0x00000020 (B hi)\n";

print "\n  Verify DMEM readback:\n";
my $verify_a_lo = dmem_read32(0x70);
my $verify_a_hi = dmem_read32(0x71);
printf("    A[0x70] = 0x%08X %08X (expect 0x00000100 0x00001000)\n", $verify_a_hi, $verify_a_lo);
my $verify_b_lo = dmem_read32(0x74);
my $verify_b_hi = dmem_read32(0x75);
printf("    B[0x74] = 0x%08X %08X (expect 0x00000020 0x00000200)\n", $verify_b_hi, $verify_b_lo);
if ($verify_a_lo != 0x00001000 || $verify_a_hi != 0x00000100 || $verify_b_lo != 0x00000200 || $verify_b_hi != 0x00000020) {
    print "  WARNING: DMEM readback mismatch! Fix host write address (addr & 0xFE) before debugging pipeline.\n";
}
print "\n";
sleep(1);

print "STEP 3: Start GPU...\n";
regwrite($IDS_INPUT_TYPE, $GPU_START);
sleep(1);
regwrite($IDS_INPUT_TYPE, 0x00);
sleep(2);
print "  ✓ GPU run complete\n\n";

print "STEP 4: Read result from DMEM[0xC0]...\n";
my $result_lo = dmem_read32(0xC0);
my $result_hi = dmem_read32(0xC1);

printf("  DMEM[0xC0] = 0x%08X (lo)\n", $result_lo);
printf("  DMEM[0xC1] = 0x%08X (hi)\n", $result_hi);

my $expected_lo = 0x00001200;
my $expected_hi = 0x00000120;

print "\nSTEP 5: Verify\n";
if ($result_lo == $expected_lo && $result_hi == $expected_hi) {
    print "  ✓ PASS! 0x0100_1000 + 0x0020_0200 = 0x0120_1200\n";
} else {
    print "  ✗ FAIL!\n";
    printf("    Expected: 0x%08X %08X\n", $expected_hi, $expected_lo);
    printf("    Got:      0x%08X %08X\n", $result_hi, $result_lo);
}

print "\n" . "=" x 70 . "\n";
