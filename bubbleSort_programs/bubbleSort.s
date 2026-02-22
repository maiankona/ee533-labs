	.cpu arm7tdmi
	.arch armv4t
	.fpu softvfp
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 6
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"bubbleSort.c"
	.text
	.align	2
	.global	main
	.syntax unified
	.arm
	.type	main, %function
main:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	sub	sp, sp, #20
	mov	r3, #256
	str	r3, [fp, #-16]
	ldr	r3, [fp, #-16]
	mov	r2, #223
	str	r2, [r3]
	ldr	r3, [fp, #-16]
	add	r3, r3, #4
	mov	r2, #123
	str	r2, [r3]
	ldr	r3, [fp, #-16]
	add	r3, r3, #8
	mvn	r2, #54
	str	r2, [r3]
	ldr	r3, [fp, #-16]
	add	r3, r3, #12
	mov	r2, #2
	str	r2, [r3]
	ldr	r3, [fp, #-16]
	add	r3, r3, #16
	mov	r2, #98
	str	r2, [r3]
	ldr	r3, [fp, #-16]
	add	r3, r3, #20
	mov	r2, #125
	str	r2, [r3]
	ldr	r3, [fp, #-16]
	add	r3, r3, #24
	mov	r2, #10
	str	r2, [r3]
	ldr	r3, [fp, #-16]
	add	r3, r3, #28
	mov	r2, #65
	str	r2, [r3]
	ldr	r3, [fp, #-16]
	add	r3, r3, #32
	mvn	r2, #55
	str	r2, [r3]
	ldr	r3, [fp, #-16]
	add	r3, r3, #36
	mov	r2, #0
	str	r2, [r3]
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.L2
.L6:
	mov	r3, #0
	str	r3, [fp, #-12]
	b	.L3
.L5:
	ldr	r3, [fp, #-12]
	lsl	r3, r3, #2
	ldr	r2, [fp, #-16]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-12]
	add	r3, r3, #1
	lsl	r3, r3, #2
	ldr	r1, [fp, #-16]
	add	r3, r1, r3
	ldr	r3, [r3]
	cmp	r2, r3
	ble	.L4
	ldr	r3, [fp, #-12]
	lsl	r3, r3, #2
	ldr	r2, [fp, #-16]
	add	r3, r2, r3
	ldr	r3, [r3]
	str	r3, [fp, #-20]
	ldr	r3, [fp, #-12]
	add	r3, r3, #1
	lsl	r3, r3, #2
	ldr	r2, [fp, #-16]
	add	r2, r2, r3
	ldr	r3, [fp, #-12]
	lsl	r3, r3, #2
	ldr	r1, [fp, #-16]
	add	r3, r1, r3
	ldr	r2, [r2]
	str	r2, [r3]
	ldr	r3, [fp, #-12]
	add	r3, r3, #1
	lsl	r3, r3, #2
	ldr	r2, [fp, #-16]
	add	r3, r2, r3
	ldr	r2, [fp, #-20]
	str	r2, [r3]
.L4:
	ldr	r3, [fp, #-12]
	add	r3, r3, #1
	str	r3, [fp, #-12]
.L3:
	ldr	r3, [fp, #-8]
	rsb	r3, r3, #9
	ldr	r2, [fp, #-12]
	cmp	r2, r3
	blt	.L5
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
.L2:
	ldr	r3, [fp, #-8]
	cmp	r3, #8
	ble	.L6
.L7:
	b	.L7
	.size	main, .-main
	.ident	"GCC: (Arm GNU Toolchain 14.2.Rel1 (Build arm-14.52)) 14.2.1 20241119"
