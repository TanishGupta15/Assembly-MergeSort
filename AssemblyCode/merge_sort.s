.extern merge, merge_func
.global exi, merge_sort, pop_done
.text

merge_sort:
	@Assume r3 contains the begin of list and r5 contains the pointer to the end of list.
	
recurse:
	str	lr, [sp, #-4]!		@Since we'll recurse, store the lr pointer in stack
	add	r3, r3, #4		
	cmp	r3, r5			
	beq	base_case		@If r3 + #4 equals r5, means there's one element in the list
	sub	r3, r3, #4		@Else go back to the start of the string
	sub	r4, r5, r3		@r4 = r5 - r3 = 4*no of strings
	mov	r0, r4			
	mov	r1, #2
	bl	div			
	mov	r4, r0			@r4 now holds (r5 - r3)/2
	mov	r1, #4
	bl	div
	cmp	r1, #2			@if r4 does'nt point to a starting address (i.e. multiple of 4)
	bne	safe
	add	r4, r4, #2
safe:	add	r4, r4, r3
	mov	r6, r5
	mov	r5, r4
	stmfd	sp!, {r3-r6}
	bl	recurse			@recurse on left half
	ldmfd	sp!, {r3-r6}
	mov	r5, r6
	mov	r6, r3
	mov	r3, r4
	stmfd	sp!, {r3-r6}
	bl	recurse			@recurse on right half
	ldmfd	sp!, {r3-r6}
	mov	r3, r6
	mov	r10, r4
	mov	r12, r5
	stmfd	sp!, {r3, r4, r5, r6, lr}
	b	merge_func			@merge the sorted halves
base_case:
	ldr	pc, [sp], #4

pop_done:	
	ldmfd	sp!, {r3, r4, r5, r6, lr}
	mov 	r0, #0
l:	cmp	r5, r8
	beq	e
	sub	r5, r5, #4
	str	r0, [r5]
	b	l
e:	ldr	pc, [sp], #4


.data

.end





