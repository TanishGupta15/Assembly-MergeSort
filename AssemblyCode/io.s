.global fgets, prints

.text

fgets:	stmfd	sp!, {r1-r4,lr}
	ldr	r3, =operands
	str	r2, [r3]	@ specify input stream
	mov	r2, r0
	mov	r4, r1
	mov	r0, #1
	str	r0, [r3,#8]	@ to read one character
	mov	r1, r3
	mov	r3, r2
1:	subs	r4, r4, #1
	ble	3f		@ jump if buffer has been filled
	str	r3, [r1,#4]
2:	mov	r0, #0x06	@ read operation
	swi	0x123456
	cmp	r0, #0
	bne	4f		@ branch if read failed
	ldrb	r0, [r3]
	@ cmp	r0, #'\r'	@ ignore \r char (result is a Unix line)
	@ beq	2b
	add	r3, r3, #1
	cmp	r0, #'\r'
	bne	1b
3:	mov	r0, #0
	strb	r0, [r3]
	mov	r0, r2		@ set success result
	ldmfd	sp!, {r1-r4,pc}
4:	cmp	r4, r2
	bne	3b		@ some chars were read, so return them
	mov	r0, #0		@ set failure code
	strb	r0, [r2]	@ put empty string in the buffer
	ldmfd	sp!, {r1-r4,pc}


prints:
	stmfd	sp!, {r0,r1,lr}
	ldr	r1, =operands
	str	r0, [r1,#4]
	bl	strlen
	str	r0, [r1,#8]
	mov	r0, #0x0
	str	r0, [r1]
	mov	r0, #0x05
	swi	0x123456
	ldmfd	sp!, {r0,r1,pc}

.data
	operands:
	.word	0, 0, 0
.end