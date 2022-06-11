@ Author: Ramanuj Goel, 2020CS50437

	.global input_string
	.global output_string
	.global output_new_line
	.global input_number
	.global output_number
	.extern div
	.text
input_string:
					@ r0 has address where we will store input
					@ the function will read till \n
					@ and then end the string with a \0
					@ returns the position of the next empty position in the memory
	mov r2, r0
	ldr r1, =ReadParams
input_rec:
	str r2, [r1, #4]		@ r2 = next empty position in memory
	mov r0, #0x06
	swi 0x123456
	ldrb r3, [r2]
	cmp r3, #0x0D			@ check for '\n' character
	beq terminate
	cmp r3, #0x0A
	beq terminate
	cmp r3, #0x08			@ check for backspace, and remove character if found
	subeq r2, r2, #1
	addne r2, r2, #1
	b input_rec
terminate:
	mov r1, #0			@ end with a \0 null character
	strb r1, [r2]
	add r2, r2, #1
	mov r0, r2
	mov pc, lr
output_string:
					@ r0 has the address of the output
					@ prints till it encounters a \0
					@ returns the next address for easy daisy chaining
	mov r3, r0
output_rec:				@ basically to count the length of the string
	ldrb r2, [r3]
	cmp r2, #0
	beq output_string_of_length
	add r3, r3, #1
	b output_rec
output_string_of_length:
					@ r0 has the start address
					@ r3 has the end address
	sub r2, r3, r0
	ldr r1, =WriteParams
	str r0, [r1, #4]
	str r2, [r1, #8] 		@ r2 is the length
	mov r0, #0x05
	swi 0x123456
	add r3, r3, #1
	mov r0, r3
	mov pc, lr
output_new_line:
	mov r0, #0x05
	ldr r1, =WriteNewLine
	swi 0x123456
	mov pc, lr
input_number:
					@ maximum size is 32 bits
					@ number will be returned at r0
	ldr r0, =buffer
	str r6, [sp, $-4]!
	str lr, [sp, #-4]!
	str r4, [sp, #-4]!
	str r5, [sp, $-4]!
	bl input_string
					@ convert string to number at r0
	ldr r1, =buffer
	ldrb r6, [r1]
	cmp r6, #45 			@ check for '-' sign
	beq   error
	moveq r6, #1
	movne r6, #0
	cmpne r6, #43 			@ check for '+' sign
	addeq r1, r1, #1 		@ if '-' or '+' then increase start position
	mov r2, r0
	sub r2, r2, #1
	mov r0, #0
	mov r5, #10
string_to_int:
	ldrb r3, [r1]
	cmp r3, #48
	blt error
	cmp r3, #57
	bgt error
	sub r3, r3, #48
	mla r4, r5, r0, r3
	mov r0, r4
	add r1, r1, #1
	cmp r1, r2
	bne string_to_int
	cmp r6, #1			@ if the number is negative
	rsbeq r0, r0, #0
	ldr r5, [sp]
	ldr r4, [sp, #4]
	ldr lr, [sp, #8]
	ldr r6, [sp, #12]
	add sp, #16
	mov pc, lr
output_number:
					@ number in r0
	str lr, [sp, #-4]!
	str r4, [sp, #-4]!
	str r5, [sp, $-4]!
	str r6, [sp, $-4]!
	ldr r4, =buffer
	add r4, r4, #10
	mov r6, #0
	strb r6, [r4], #-1
	mov r5, #45			@ - sign
	tst r0, #0x80000000		@ and with last bit and test
					@ will set Z set if result is 0, ei positive
	@ strne r5, [r4]			
	@ addne r4, r4, #1
	rsbne r0, r0, #0
	movne r6, #1			@ r6 stores if number was negative
int_to_string:
	mov r1, #10
	bl div
	add r1, r1, #48
	strb r1, [r4], #-1
	cmp r0, #0
	bne int_to_string

	cmp r6, #1
	streqb r5, [r4]
	addne r4, r4, #1
	mov r0, r4
	ldr r6, [sp]
	ldr r5, [sp, #4]
	ldr r4, [sp, #8]
	ldr lr, [sp, #12]
	add sp, sp, #16
	b output_string

error:
	ldr	r0, =ErrorMsg
	bl	prints
	mov	r0, #0x18
	mov	r1, #0
	swi	0x123456	

	.data
ReadParams:
	.word 0
	.word 0
	.word 1
WriteParams:
	.word 1
	.word 0
	.word 0
ErrorMsg: 
	.asciz "Please input a number only. Execution halted! Please restart! \n"
newLine:
	.ascii "\n\n\n\n"
WriteNewLine:
	.word 1
	.word newLine
	.word 1
buffer:
	.space 10
