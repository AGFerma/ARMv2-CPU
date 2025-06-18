/*----------------------------------------------------------------
//           test logic                                         //
----------------------------------------------------------------*/
	.text
	.globl	_start 
_start:               
	/* 0x00 Reset Interrupt vector address */
	b	startup
	
	/* 0x04 Undefined Instruction Interrupt vector address */
	b	_bad

startup:
	ldr r6, data
	mov r7, #data
	ldr r8, [r7]
	cmp r6,r8
	bne _bad
	ldrb r8, [r7]
	cmp r8, #0x11
	bne _bad
	ldrb r8, [r7, #1]
	cmp r8, #0x22
	bne _bad
	ldrb r8, [r7, #2]
	cmp r8, #0x33
	bne _bad
	ldrb r8, [r7, #3]
	cmp r8, #0x44
	bne _bad

	mov r8, #0x55
	strb r8, [r7]
	ldr r8, data2
	ldr r9, [r7]
	cmp r9,r8
	bne _bad

	mov r8, #0x66
	strb r8, [r7, #1]
	ldr r8, data3
	ldr r9, [r7]
	cmp r9,r8
	bne _bad

	mov r8, #0x77
	strb r8, [r7, #2]
	ldr r8, data4
	ldr r9, [r7]
	cmp r9,r8
	bne _bad

	mov r8, #0x88
	strb r8, [r7, #3]
	ldr r8, data5
	ldr r9, [r7]
	cmp r9,r8
	bne _bad

	str r8, [r7, #4]
	ldr r8, data5
	ldr r9, [r7, #4]
	cmp r9,r8
	bne _bad

	mov r8, r7
	mov r6, #0
	str r6, [r8], #4
	add r6, r6, #1
	str r6, [r8]
	add r6, r6, #1
	str r6, [r8, #4]!
	add r6, r6, #1
	str r6, [r8, #4]
	ldrb r8, [r7], #4
	cmp r8, #0
	bne _bad
	ldrb r8, [r7], #4
	cmp r8, #1
	bne _bad
	ldrb r8, [r7]
	cmp r8, #2
	bne _bad
	ldrb r8, [r7, #4]
	cmp r8, #3
	bne _bad

	b _good

_bad :
	nop
	nop
_good :
	nop
	nop
data:  .word 0x44332211
data2:  .word 0x44332255
data3:  .word 0x44336655
data4:  .word 0x44776655
data5:  .word 0x88776655
