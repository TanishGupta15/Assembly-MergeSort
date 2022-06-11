.extern prints
.extern ret1, ret2, reteq
.global func, strlen
.text

func: 
	mov 	r0, r1				@Temporarily move string 1 to r0 to compute the length
	bl	strlen				@Function to compute the length of string 1
	mov	r4, r0				@r4 contains the length of string 1
	mov	r0, r2			
	bl	strlen
	mov	r5, r0				@r5 comtains the length of string 2
	cmn	r1, r1
	cmp	r11, #0x30			@Checking the comparison mode	
	add	r6, pc, #8			@This is done to store the address of current instructions in lr, so that we can come back here
	mov	lr, r6
	beq	caseInsensitive			@if the comparison mode is 0, i.e. comparison is case insensitive, then we transform the input
	@for(int i = 0 ; i < min(r4,r5); i++)
	mov 	r6, #0 				@r6 contains i
	bl 	minimum 			@r7 contains the min(r4, r5)
	@if(s1[i]>s2[i]) then s1 
loop:	cmp	r6, r7
	beq	loop2
	ldrb 	r3, [r1, r6] 			@r3 contains s1[i]
	ldrb	r0, [r2, r6] 			@r0 contains s2[i]
	cmp	r3, r0
	blt	t2				@string 2 is greater
	cmp 	r3, r0
	bgt	t1				@string 1 is greater
	add	r6, r6, #1
	b	loop

t2:
	b	ret2

t1:
	b 	ret1

teq:
	b	reteq

caseInsensitive:
	mov	r6, #0
	bl	minimum
loo:	cmp	r6, r7
	beq	loop2
	ldrb	r3, [r1, r6]
	ldrb	r0, [r2, r6]
	cmp	r3, #97
	blt	chill1
	cmp	r3, #122
	bgt	chill1
	sub	r3, r3, #32
chill1:	cmp	r0, #97
	blt	chill
	cmp	r0, #122
	bgt	chill
	sub	r0, r0, #32
chill:	cmp	r3, r0
	blt	ret2				@string 2 is greater
	cmp 	r3, r0
	bgt	ret1				@string 1 is greater
	add	r6, r6, #1
	b	loo
	
loop2: 	
	cmp	r4, r5		@reaches here if the first min(length(s1), length(s2)) characters of the strings are same
	beq	teq		@if the lengths of both strings are same, and all their characters are same, then the strings are equal	
	cmp 	r4, r5		
	blt	t2		@if length(s1)<length(s2) then string 2 is greater
	b	t1		@else string 1 is greater

minimum:			@function to compute the minimum of 2 values
	cmp 	r4, r5		
	blt	ltl
	mov	r7, r5
	mov	pc, lr	
ltl:	mov 	r7, r4
	mov 	pc, lr

strlen:
	stmfd	sp!, {r1-r2, lr}
	mov	r2, r0
1:	ldrb	r1, [r0], #1
	cmp	r1, #0
	beq	here
	cmp	r1, #0x0D
	bne	1b
here:	sub	r0, r0, r2
	sub	r0, r0, #1
	ldmfd	sp!, {r1-r2, pc}

.data

.end