.extern fgets, prints, input_number, strlen, merge_sort, output_number

.global RemoveDuplicateChoice

.text

._Start:
	ldr	r0, =WelcomeMessage
	bl	prints			@Print the welcome message
	cmn	r0, r1
	ldr	r0, =NumMsg
	bl	prints			@Print the msg to get input the number of strings
	cmn	r0, r1
	ldr	r0, =Num
	mov	r1, #12
	mov	r2, #0
	bl	input_number		@input the number of strings
	cmn	r1, r1
	ldr	r1, =Num
	str	r0, [r1]
	ldr	r0, =ListInputMsg	@Print message to get input the strings
	bl 	prints
	cmn	r0, r1
	ldr	r5, =List
	mov	r6, #0
	mov	r7, #16000
	ldr	r3, =Pointers
	ldr	r9, =Num
	ldr	r10, [r9]
	@for(int i=0; i< Num1; i++) cin>>str
inp:	cmp	r6, r10
	beq	inp_done
	mov	r0, r5
	mov	r1, r7
	mov	r2, #0
	bl	fgets
	cmn	r1, r1
	str	r5, [r3]
	add	r3, r3, #4
	bl	strlen
	mov	r2, #0
	strb	r2, [r5, r0]
	add	r5, r5, r0
	sub	r7, r7, r0
	sub	r7, r7, #1
	add	r5, r5, #1
	add	r6, r6, #1
	b	inp

inp_done:
	mov	r5, r3
	ldr	r0, =MessageToInputComparisonMode
	bl	prints
	cmn	r0, r1
	ldr	r0, =ComparisonMode
	mov	r1, #4
	mov	r2, #0
	bl	fgets
	cmn	r1, r1
	ldr	r0, =MessageToInputRemoveDuplicateChoice
	bl	prints
	cmn	r0, r1
	ldr	r0, =RemoveDuplicateChoice
	mov	r1, #4
	mov	r2, #0
	bl	fgets
	ldr	r0, =ComparisonMode
	ldrb	r11, [r0]
	ldr	r3, =Pointers
	mov	r8, #0			@count no of duplicates
	add	lr, lr, #24
	b	merge_sort

correct:
	ldr	r4, [r5, #-4]
	cmp	r4, #0
	bne	done
	sub	r5, r5, #4
	b	correct
	
done:	ldr	r0, =OutNum
	bl 	prints
	sub	r0, r5, r3
	mov	r1, #4
	bl	div
	bl	output_number
	ldr	r0, =LineBreak
	bl	prints
	ldr	r0, =OutputMsg
	bl	prints	
	ldr	r3, =Pointers
out:	cmp	r3, r5
	beq	rety	
	ldr	r0, [r3]
	bl	prints
	ldr	r0, =LineBreak
	bl	prints
	add	r3, r3, #4
	b	out

rety:
	mov	r0, #0x18
	mov	r1, #0
	swi	0x123456

.data

	WelcomeMessage: .asciz "This is stage 3 of Assignment 1.\nHere we will sort a given list of strings using functions from stage 1 and stage 2.\n"
	NumMsg : .asciz "Please enter the number of elements in the list: \n"
	ListInputMsg: .asciz "Now please enter each string of the list one by one. Please remember to press the RETURN/ENTER key after entering each string..\n"
	LineBreak: .asciz "\n"
	Num: .space 12
	List:	.space 16000
	Pointers:	.space 1000
	RemoveDuplicateChoice: .word 0
	ComparisonMode : .word 0
	MessageToInputComparisonMode : .asciz "\nPlease enter comparison mode: Press 0 for case insensitive and 1 for case sensitive: \n"
	MessageToInputRemoveDuplicateChoice : .asciz "Please input the choice for duplicate removal: Press 0 for non-duplicate removal and 1 for duplicate removal:\n"
	OutputMsg: .asciz "Your sorted strings are: \n"
	OutNum: .asciz "The number of strings in the sorted list are: "

.end