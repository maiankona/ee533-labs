.syntax unified
.arm
.section .text
.global _start

@==============================================================================
@ Network Packet Processor Test Program
@ Tests: FIFO mode, SRAM mode, packet modification, throughput
@==============================================================================

@ Memory Map
.equ FIFO_BASE,        0x000      @ FIFO starts at 0x000
.equ PACKET_BUF,       0x100      @ Packet buffer in SRAM (256 bytes)
.equ STATS_BASE,       0x200      @ Statistics area
.equ SCRATCH_BASE,     0x250      @ Scratch space

@ Packet structure (assuming 72-bit width = 64-bit data + 8-bit control)
@ We'll work with 64-bit data portion
.equ PKT_HEADER_LEN,   16         @ Header bytes
.equ PKT_PAYLOAD_OFF,  16         @ Payload starts at offset 16

@ Constants
.equ MAGIC_CONSTANT,   42         @ Value to add to payload
.equ MAX_PACKETS,      100        @ Number of packets to process

_start:
    @ Initialize registers
    MOV r0, #0
    MOV r1, #0
    MOV r2, #0
    MOV r3, #0
    
    @ Setup base addresses
    MOV r10, #PACKET_BUF       @ r10 = packet buffer base
    MOV r11, #STATS_BASE       @ r11 = stats base
    MOV r12, #0                @ r12 = packet counter
    
    @ Initialize statistics
    MOV r0, #0
    STR r0, [r11, #0]          @ packets_processed = 0
    STR r0, [r11, #4]          @ bytes_processed = 0
    STR r0, [r11, #8]          @ errors = 0
    
    B main_loop

@==============================================================================
@ Main Packet Processing Loop
@==============================================================================
main_loop:
    @ Check if we've processed MAX_PACKETS
    MOV r0, #MAX_PACKETS
    CMP r12, r0
    BGE test_complete
    
    @ Step 1: Read packet from FIFO
    BL read_packet_from_fifo
    
    @ Step 2: Modify packet payload
    BL modify_packet_payload
    
    @ Step 3: Write packet back to FIFO
    BL write_packet_to_fifo
    
    @ Step 4: Update statistics
    ADD r12, r12, #1           @ packet_counter++
    STR r12, [r11, #0]         @ Store packets_processed
    
    @ Loop back
    B main_loop

@==============================================================================
@ Function: read_packet_from_fifo
@ Reads a packet from FIFO into SRAM buffer
@ Uses: r0, r1, r2, r10
@==============================================================================
read_packet_from_fifo:
    @ Save return address
    MOV r9, lr
    
    @ Switch to FIFO mode (mode=1)
    @ In real hardware, you'd write to a control register
    @ For simulation, we assume FIFO is already in read mode
    
    MOV r0, #FIFO_BASE         @ FIFO read address
    MOV r1, #0                 @ Offset into packet buffer
    MOV r2, #16                @ Read 16 words (full packet)
    
read_fifo_loop:
    CMP r2, #0
    BLE read_fifo_done
    
    @ Read from FIFO
    LDR r3, [r0]               @ Read from FIFO
    
    @ Write to packet buffer
    ADD r4, r10, r1            @ r4 = packet_buf + offset
    STR r3, [r4]               @ Store to packet buffer
    
    @ Increment offset, decrement counter
    ADD r1, r1, #4             @ offset += 4 bytes
    SUB r2, r2, #1             @ words--
    
    B read_fifo_loop
    
read_fifo_done:
    @ Return
    MOV lr, r9
    MOV pc, lr

@==============================================================================
@ Function: modify_packet_payload
@ Reads integer at payload offset, adds constant, writes back
@ Uses: r0, r1, r2, r3, r10
@==============================================================================
modify_packet_payload:
    @ Save return address
    MOV r9, lr
    
    @ Calculate payload address
    @ Payload offset = PKT_PAYLOAD_OFF (16 bytes = offset 4 words)
    MOV r0, #PKT_PAYLOAD_OFF
    ADD r1, r10, r0            @ r1 = packet_buf + payload_offset
    
    @ Read current value from payload
    LDR r2, [r1]               @ r2 = current payload value
    
    @ Add magic constant
    MOV r3, #MAGIC_CONSTANT
    ADD r2, r2, r3             @ r2 = value + MAGIC_CONSTANT
    
    @ Write modified value back
    STR r2, [r1]
    
    @ Also modify second payload word (for testing)
    ADD r1, r1, #4             @ Next word
    LDR r2, [r1]
    ADD r2, r2, r3
    STR r2, [r1]
    
    @ Update bytes_processed counter
    LDR r0, [r11, #4]          @ Load bytes_processed
    ADD r0, r0, #64            @ Add 64 bytes (1 packet)
    STR r0, [r11, #4]          @ Store back
    
    @ Return
    MOV lr, r9
    MOV pc, lr

@==============================================================================
@ Function: write_packet_to_fifo
@ Writes modified packet from SRAM buffer back to FIFO
@ Uses: r0, r1, r2, r10
@==============================================================================
write_packet_to_fifo:
    @ Save return address
    MOV r9, lr
    
    @ Switch to FIFO mode for writing
    MOV r0, #FIFO_BASE         @ FIFO write address
    MOV r1, #0                 @ Offset into packet buffer
    MOV r2, #16                @ Write 16 words
    
write_fifo_loop:
    CMP r2, #0
    BLE write_fifo_done
    
    @ Read from packet buffer
    ADD r4, r10, r1            @ r4 = packet_buf + offset
    LDR r3, [r4]               @ Load from buffer
    
    @ Write to FIFO
    STR r3, [r0]               @ Write to FIFO
    
    @ Increment offset, decrement counter
    ADD r1, r1, #4
    SUB r2, r2, #1
    
    B write_fifo_loop
    
write_fifo_done:
    @ Return
    MOV lr, r9
    MOV pc, lr

@==============================================================================
@ Test Complete - Report Statistics
@==============================================================================
test_complete:
    @ Load final statistics
    LDR r0, [r11, #0]          @ packets_processed
    LDR r1, [r11, #4]          @ bytes_processed
    LDR r2, [r11, #8]          @ errors
    
    @ Store results in known memory locations for inspection
    MOV r3, #0x300             @ Results base
    STR r0, [r3, #0]           @ Store packets
    STR r1, [r3, #4]           @ Store bytes
    STR r2, [r3, #8]           @ Store errors
    
    @ Calculate throughput (simplified)
    @ throughput = bytes_processed / packets_processed
    @ Avoid divide, just store raw values
    
    B end_loop

@==============================================================================
@ Throughput Test - Measure Maximum Processing Rate
@==============================================================================
throughput_test:
    @ Initialize cycle counter
    MOV r0, #0                 @ Cycle counter
    MOV r1, #1000              @ Process 1000 packets
    
throughput_loop:
    CMP r1, #0
    BLE throughput_done
    
    @ Minimal packet processing
    BL read_packet_from_fifo
    BL write_packet_to_fifo
    
    ADD r0, r0, #1             @ Cycle count (approximate)
    SUB r1, r1, #1
    
    B throughput_loop
    
throughput_done:
    @ Store cycle count
    MOV r2, #0x310
    STR r0, [r2]
    
    B end_loop

@==============================================================================
@ End Loop
@==============================================================================
end_loop:
    @ Halt or loop forever
    B end_loop

@==============================================================================
@ Error Handler
@==============================================================================
error_handler:
    @ Increment error counter
    LDR r0, [r11, #8]
    ADD r0, r0, #1
    STR r0, [r11, #8]
    
    @ Continue processing
    B main_loop
