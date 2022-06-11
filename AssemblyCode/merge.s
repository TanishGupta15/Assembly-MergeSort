.global merge, ret1, ret2, reteq, merge_func
.extern func, exi, RemoveDuplicateChoice, pop_done

.text

merge_func: 	
	mov	r8, r12
	mov	r0, r3
	@Assume r3 and r4 contain pointers to 2 lists of pointers
	@r10 contains the address of end of list1 and r12 contains the end of list2.
	@r13 is a pointer to the stack, we will push the results onto the stack.

merge:
	cmp	r3, r10		@If first list is finished
	beq	copyr4		@Copy the remaining element of list2.
	cmp	r4, r12		@If second list is finished
	beq	copyr3		@Copy the remaining element of list2.
	ldr	r1, [r3]	
	ldr	r2, [r4]
	cmp	r1, #0
	beq	null1
	cmp	r2, #0
	beq	null2
	stmfd	sp!, {r0, r3, r4}
	b	func	
ret1:	ldmfd	sp!, {r0, r3, r4}
	str	r2, [sp, #-4]!	@Push result pointer onto stack
	add	r4, r4, #4	@Move 2nd list pointer by 4 (address is 4 bytes)
	b	merge		@Move onto next element
ret2:	ldmfd	sp!, {r0, r3, r4}	
	str	r1, [sp, #-4]!
	add	r3, r3, #4
	b	merge
reteq:  ldmfd	sp!, {r0, r3, r4}
	ldr	r9, =RemoveDuplicateChoice
	ldrb	r9, [r9]
	cmp 	r9, #0x30	@If remove duplicate choice is 0, we do not need to remove duplicates.
	bne 	removeDuplicate
	str	r1, [sp, #-4]!
	str	r2, [sp, #-4]!
	add	r3, r3, #4
	add 	r4, r4, #4
	b	merge
	
removeDuplicate:	
	str	r1, [sp, #-4]!	
	add	r3, r3, #4
	add 	r4, r4, #4
	sub	r8, r8, #4
	b	merge

copyr3: 
	cmp 	r3, r10
	beq	exi		@if equal then exit
	ldr	r1, [r3]
	str	r1, [sp, #-4]!
	add	r3, r3, #4
	b	copyr3

copyr4:
	cmp	r4, r12
	beq 	exi	
	ldr	r2, [r4]
	str	r2, [sp, #-4]!
	add	r4, r4, #4
	b	copyr4

exi:	
	mov	r12, r8

exi2:
	cmp	r12, r0
	beq	pop_done
	ldr	r3, [sp], #4
	str	r3, [r12, #-4]!
	b	exi2
	
null1:
	sub	r3, r10, r3
	sub	r8, r8, r3
	b	copyr4

null2:
	sub	r4, r12, r4
	sub	r8, r8, r4
	b 	copyr3
		 
.data
	

.end