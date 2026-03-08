#!/usr/bin/perl -w
use lib "/usr/local/netfpga/lib/Perl5";
use strict;

# ==============================
# NETWORK PROCESSOR REGISTER MAP
# ==============================
my $NP_INPUT_TYPE_REG   = 0x2000200;  # IDS_INPUT_TYPE
my $NP_ADDRESS_REG      = 0x2000204;  # IDS_ADDRESS
my $NP_IMEM_REG         = 0x2000208;  # IDS_IMEM
my $NP_DMEM_WRITE_REG   = 0x200020C;  # IDS_DMEM (FIFO/SRAM data in)
my $NP_DMEM_READ_REG    = 0x2000210;  # IDS_DMEM_OUT (FIFO/SRAM data out)
my $NP_FIFO_CTRL_REG    = 0x2000214;  # FIFO control register
my $NP_FIFO_STATUS_REG  = 0x2000218;  # FIFO status (empty/full/count)

# Command codes (INPUT_TYPE register bits)
my $CMD_WRITE_IMEM  = 0x01;  # Bit 0: write to IMEM
my $CMD_WRITE_DMEM  = 0x02;  # Bit 1: write to DMEM/FIFO
my $CMD_READ_DMEM   = 0x04;  # Bit 2: read from DMEM/FIFO
my $CMD_PIPELINE_RUN = 0x08; # Bit 3: pipeline running
my $CMD_PIPELINE_RST = 0x10; # Bit 4: reset pipeline (pulse)

# FIFO control codes
my $FIFO_MODE_SRAM  = 0x00;  # SRAM mode
my $FIFO_MODE_READ  = 0x01;  # FIFO read mode
my $FIFO_MODE_WRITE = 0x02;  # FIFO write mode

# Memory locations
my $STATS_BASE      = 0x200; # Statistics base address
my $RESULTS_BASE    = 0x300; # Results base address

# ==============================
# Low-Level Register Access
# ==============================
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
        return $2;
    }
    die "Unexpected regread output from: $cmd\n";
}

sub clear_cmd {
    regwrite($NP_INPUT_TYPE_REG, 0x0);
}

# ==============================
# IMEM / DMEM Operations
# ==============================
sub write_imem {
    my ($addr, $instr) = @_;
    regwrite($NP_ADDRESS_REG, $addr);
    regwrite($NP_IMEM_REG, $instr);
    regwrite($NP_INPUT_TYPE_REG, $CMD_WRITE_IMEM);
    clear_cmd();
}

sub write_dmem {
    my ($addr, $data) = @_;
    regwrite($NP_ADDRESS_REG, $addr);
    regwrite($NP_DMEM_WRITE_REG, $data);
    regwrite($NP_INPUT_TYPE_REG, $CMD_WRITE_DMEM);
    clear_cmd();
}

sub read_dmem {
    my ($addr) = @_;
    regwrite($NP_ADDRESS_REG, $addr);
    regwrite($NP_INPUT_TYPE_REG, $CMD_READ_DMEM);
    clear_cmd();
    my $val = regread($NP_DMEM_READ_REG);
    printf("DMEM[0x%02x] = %s\n", $addr, $val);
    return $val;
}

# ==============================
# FIFO Operations
# ==============================
sub set_fifo_mode {
    my ($mode) = @_;
    regwrite($NP_FIFO_CTRL_REG, $mode);
    
    my $mode_str = $mode == $FIFO_MODE_SRAM ? "SRAM" :
                   $mode == $FIFO_MODE_READ ? "FIFO READ" :
                   $mode == $FIFO_MODE_WRITE ? "FIFO WRITE" : "UNKNOWN";
    print "FIFO mode set to: $mode_str\n";
}

sub write_fifo {
    my ($data) = @_;
    set_fifo_mode($FIFO_MODE_WRITE);
    regwrite($NP_DMEM_WRITE_REG, $data);
    regwrite($NP_INPUT_TYPE_REG, $CMD_WRITE_DMEM);
    clear_cmd();
}

sub read_fifo {
    set_fifo_mode($FIFO_MODE_READ);
    regwrite($NP_INPUT_TYPE_REG, $CMD_READ_DMEM);
    clear_cmd();
    my $val = regread($NP_DMEM_READ_REG);
    return $val;
}

sub get_fifo_status {
    my $status = regread($NP_FIFO_STATUS_REG);
    my $status_int = hex($status);
    
    my $empty = ($status_int & 0x01) ? 1 : 0;
    my $full  = ($status_int & 0x02) ? 1 : 0;
    my $count = ($status_int >> 8) & 0xFF;
    
    return ($empty, $full, $count);
}

sub show_fifo_status {
    my ($empty, $full, $count) = get_fifo_status();
    
    print "FIFO Status:\n";
    print "  Empty: $empty\n";
    print "  Full:  $full\n";
    print "  Count: $count\n";
}

# ==============================
# Pipeline Control
# ==============================
sub start_pipeline {
    print "Starting pipeline execution...\n";
    regwrite($NP_INPUT_TYPE_REG, $CMD_PIPELINE_RUN);
    # Don't clear - pipeline needs to stay running!
}

sub stop_pipeline {
    print "Stopping pipeline execution...\n";
    clear_cmd();
}

sub reset_pipeline {
    print "Resetting pipeline (PC -> 0)...\n";
    regwrite($NP_INPUT_TYPE_REG, $CMD_PIPELINE_RST);
    clear_cmd();
}

# ==============================
# Bulk Loading
# ==============================
sub load_program {
    my ($file) = @_;
    open(my $fh, '<', $file) or die "Cannot open $file: $!";
    my $addr = 0;
    
    print "Loading program from $file...\n";
    
    while (my $line = <$fh>) {
        chomp($line);
        $line =~ s/#.*//;         # Remove comments
        $line =~ s/^\s+|\s+$//g;  # Trim whitespace
        next if $line eq '';
        
        # Expect format: 0xHHHHHHHH (8 hex digits for 32-bit instruction)
        my $instr;
        if ($line =~ /^0x([0-9a-fA-F]{8})$/) {
            $instr = hex($1);
        } elsif ($line =~ /^([0-9a-fA-F]{8})$/) {
            $instr = hex($1);
        } else {
            print "  Warning: Skipping invalid line: $line\n";
            next;
        }
        
        write_imem($addr, $instr);
        printf("  IMEM[0x%03x] = 0x%08x\n", $addr, $instr);
        $addr++;
    }
    
    close($fh);
    print "Loaded $addr instructions into IMEM\n";
}

# ==============================
# Packet Generation
# ==============================
sub generate_test_packet {
    my ($packet_id, $payload_value) = @_;
    my @packet = ();
    
    # Header: 4 words (16 bytes)
    push @packet, 0xDEAD0000 + $packet_id;  # Header word 0
    push @packet, 0xBEEF0000 + $packet_id;  # Header word 1
    push @packet, 0xCAFE0000 + $packet_id;  # Header word 2
    push @packet, 0xFACE0000 + $packet_id;  # Header word 3
    
    # Payload: 12 words (48 bytes)
    for (my $i = 0; $i < 12; $i++) {
        push @packet, $payload_value + $i;
    }
    
    return @packet;
}

sub load_test_packets {
    my ($num_packets) = @_;
    
    print "Loading $num_packets test packets into FIFO...\n";
    
    set_fifo_mode($FIFO_MODE_WRITE);
    
    for (my $i = 0; $i < $num_packets; $i++) {
        my @packet = generate_test_packet($i, $i * 100);
        
        foreach my $word (@packet) {
            write_fifo($word);
        }
        
        printf("  Loaded packet %d (payload base: %d)\n", $i, $i * 100);
    }
    
    show_fifo_status();
    print "Loaded $num_packets packets\n";
}

# ==============================
# Read Output Packets
# ==============================
sub read_output_packets {
    my ($num_packets) = @_;
    
    print "\n========================================\n";
    print "Reading $num_packets modified packets...\n";
    print "========================================\n";
    
    set_fifo_mode($FIFO_MODE_READ);
    
    for (my $i = 0; $i < $num_packets; $i++) {
        print "\n--- Packet $i ---\n";
        
        # Read 16 words (64 bytes per packet)
        for (my $j = 0; $j < 16; $j++) {
            my $word = read_fifo();
            
            printf("  Word[%2d]: %s", $j, $word);
            
            # Check if this is payload (words 4-15)
            if ($j >= 4 && $j < 6) {
                my $expected = ($i * 100 + ($j - 4)) + 42;  # +42 is MAGIC_CONSTANT
                printf(" (PAYLOAD - expected 0x%08X)", $expected);
            }
            print "\n";
        }
    }
}

# ==============================
# Read Statistics
# ==============================
sub read_statistics {
    print "\n========================================\n";
    print "STATISTICS\n";
    print "========================================\n";
    
    set_fifo_mode($FIFO_MODE_SRAM);
    
    my $packets_processed = read_dmem($STATS_BASE + 0);
    my $bytes_processed   = read_dmem($STATS_BASE + 4);
    my $errors            = read_dmem($STATS_BASE + 8);
    
    printf("Packets processed: %d\n", hex($packets_processed));
    printf("Bytes processed:   %d\n", hex($bytes_processed));
    printf("Errors:            %d\n", hex($errors));
    
    # Read final results
    print "\n--- Final Results ---\n";
    my $result_packets = read_dmem($RESULTS_BASE + 0);
    my $result_bytes   = read_dmem($RESULTS_BASE + 4);
    my $result_errors  = read_dmem($RESULTS_BASE + 8);
    
    printf("Result packets: %d\n", hex($result_packets));
    printf("Result bytes:   %d\n", hex($result_bytes));
    printf("Result errors:  %d\n", hex($result_errors));
}

# ==============================
# Full Test Sequence
# ==============================
sub run_test {
    my ($prog_file, $num_packets) = @_;
    
    $num_packets = $num_packets || 10;  # Default to 10 packets
    
    print "\n========================================\n";
    print "NETWORK PROCESSOR TEST\n";
    print "========================================\n\n";
    
    # Step 1: Reset pipeline
    reset_pipeline();
    
    # Step 2: Load program
    load_program($prog_file);
    
    # Step 3: Load test packets into FIFO
    load_test_packets($num_packets);
    
    # Step 4: Start processor
    start_pipeline();
    
    print "\nProcessing packets...\n";
    sleep(2);  # Give it time to process
    
    # Step 5: Stop processor
    stop_pipeline();
    
    # Step 6: Read statistics
    read_statistics();
    
    # Step 7: Read modified packets
    read_output_packets($num_packets);
    
    print "\n========================================\n";
    print "TEST COMPLETE\n";
    print "========================================\n";
}

# ==============================
# Throughput Test
# ==============================
sub throughput_test {
    my ($prog_file) = @_;
    
    print "\n========================================\n";
    print "THROUGHPUT TEST\n";
    print "========================================\n\n";
    
    my $num_packets = 1000;
    
    # Load program
    load_program($prog_file);
    
    # Load packets
    print "Loading $num_packets packets...\n";
    load_test_packets($num_packets);
    
    # Measure time
    my $start_time = time();
    
    start_pipeline();
    
    # Wait for completion (check FIFO empty)
    print "Processing...\n";
    my $timeout = 60;  # 60 second timeout
    my $elapsed = 0;
    
    while ($elapsed < $timeout) {
        my ($empty, $full, $count) = get_fifo_status();
        if ($empty) {
            print "FIFO empty - processing complete!\n";
            last;
        }
        sleep(1);
        $elapsed++;
    }
    
    my $end_time = time();
    my $duration = $end_time - $start_time;
    
    stop_pipeline();
    
    # Calculate throughput
    my $packets_per_sec = $num_packets / $duration;
    my $bytes_per_sec = ($num_packets * 64) / $duration;
    my $mbps = ($bytes_per_sec * 8) / (1024 * 1024);
    
    print "\n--- Throughput Results ---\n";
    printf("Packets:       %d\n", $num_packets);
    printf("Duration:      %d seconds\n", $duration);
    printf("Packets/sec:   %.2f\n", $packets_per_sec);
    printf("Bytes/sec:     %.2f\n", $bytes_per_sec);
    printf("Throughput:    %.2f Mbps\n", $mbps);
}

# ==============================
# Show All Registers
# ==============================
sub show_all_regs {
    print "\n========================================\n";
    print "NETWORK PROCESSOR REGISTER DUMP\n";
    print "========================================\n";
    
    printf("INPUT_TYPE:   %s\n", regread($NP_INPUT_TYPE_REG));
    printf("ADDRESS:      %s\n", regread($NP_ADDRESS_REG));
    printf("IMEM:         %s\n", regread($NP_IMEM_REG));
    printf("DMEM_WRITE:   %s\n", regread($NP_DMEM_WRITE_REG));
    printf("DMEM_READ:    %s\n", regread($NP_DMEM_READ_REG));
    printf("FIFO_CTRL:    %s\n", regread($NP_FIFO_CTRL_REG));
    printf("FIFO_STATUS:  %s\n", regread($NP_FIFO_STATUS_REG));
    
    print "\n--- FIFO Status ---\n";
    show_fifo_status();
    
    print "\n--- Key DMEM Locations ---\n";
    set_fifo_mode($FIFO_MODE_SRAM);
    read_dmem(0x100);  # Packet buffer
    read_dmem(0x200);  # Statistics
    read_dmem(0x300);  # Results
}

# ==============================
# CLI
# ==============================
sub usage {
    print "Usage:\n";
    print "  netproc imem <addr> <hex_instr>      - Write single instruction\n";
    print "  netproc dmemw <addr> <hex32>         - Write 32-bit data to SRAM\n";
    print "  netproc dmemr <addr>                 - Read DMEM location\n";
    print "  netproc fifow <hex32>                - Write word to FIFO\n";
    print "  netproc fifor                        - Read word from FIFO\n";
    print "  netproc fifo_status                  - Show FIFO status\n";
    print "  netproc load_program <file>          - Load program from file\n";
    print "  netproc load_packets <num>           - Load N test packets\n";
    print "  netproc read_packets <num>           - Read N packets from FIFO\n";
    print "  netproc start                        - Start pipeline\n";
    print "  netproc stop                         - Stop pipeline\n";
    print "  netproc reset                        - Reset pipeline\n";
    print "  netproc test <prog> [num_packets]    - Run full test\n";
    print "  netproc throughput <prog>            - Run throughput test\n";
    print "  netproc stats                        - Read statistics\n";
    print "  netproc allregs                      - Show all registers\n";
    print "\n";
    print "Example:\n";
    print "  netproc test network_test.hex 10\n";
    print "  netproc throughput network_test.hex\n";
}

my $cmd = $ARGV[0] or usage() and exit(1);

if ($cmd eq "imem") {
    write_imem($ARGV[1], hex($ARGV[2]));
}
elsif ($cmd eq "dmemw") {
    write_dmem($ARGV[1], hex($ARGV[2]));
}
elsif ($cmd eq "dmemr") {
    read_dmem($ARGV[1]);
}
elsif ($cmd eq "fifow") {
    write_fifo(hex($ARGV[1]));
}
elsif ($cmd eq "fifor") {
    my $val = read_fifo();
    print "FIFO read: $val\n";
}
elsif ($cmd eq "fifo_status") {
    show_fifo_status();
}
elsif ($cmd eq "load_program") {
    load_program($ARGV[1] || "network_test.hex");
}
elsif ($cmd eq "load_packets") {
    load_test_packets($ARGV[1] || 10);
}
elsif ($cmd eq "read_packets") {
    read_output_packets($ARGV[1] || 10);
}
elsif ($cmd eq "start") {
    start_pipeline();
}
elsif ($cmd eq "stop") {
    stop_pipeline();
}
elsif ($cmd eq "reset") {
    reset_pipeline();
}
elsif ($cmd eq "test") {
    my $prog = $ARGV[1] || "network_test.hex";
    my $num = $ARGV[2] || 10;
    run_test($prog, $num);
}
elsif ($cmd eq "throughput") {
    throughput_test($ARGV[1] || "network_test.hex");
}
elsif ($cmd eq "stats") {
    read_statistics();
}
elsif ($cmd eq "allregs") {
    show_all_regs();
}
else {
    print "Unknown command: $cmd\n";
    usage();
}
