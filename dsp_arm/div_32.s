.text
.align 4
.code 32
.global div_32
.type div_32, %function

div_32:
	STMFD	sp!,{r4 - r5}

	MOV		R2,R1
	MOV		R1,R0

	@*check for divide by zero!
	CMP     R2, #0
	BEQ		divide_end

	MOV      R0,#0		@*clear R0 to accumulate result
	MOV      R3,#1		@*set bit 0 in R3, which will be
						@*shifted left then right
start:
	CMP      R2,R1
	MOVLS    R2,R2,LSL#1
	MOVLS    R3,R3,LSL#1
	BLS      start
	@*shift R2 left until it is about to
	@*be bigger than R1
	@*shift R3 left in parallel in order
	@*to flag how far we have to go

next:
	CMP       R1,R2			@*carry set if R1>R2 (don't ask why)
	SUBCS     R1,R1,R2		@*subtract R2 from R1 if this would
							@*give a positive answer
	ADDCS     R0,R0,R3		@*and add the current bit in R3 to
							@*the accumulating answer in R0

	MOVS      R3,R3,LSR#1		@*Shift R3 right into carry flag
	MOVCC     R2,R2,LSR#1		@*and if bit 0 of R3 was zero, also
								@*shift R2 right
	BCC       next				@*If carry not clear, R3 has shifted
								@*back to where it started, and we
								@*can end

divide_end:
	@*At the end of the routine, R1 holds the remainder, 
	@*if any, R2 has returned to the value it held on entry to the routine, 
	@*R0 holds the result and R3 holds zero. 
	@*Both zero and carry flags are set

	LDMFD	sp!,{r4 - r5}
	BX		lr


@ clz_divide:
@ 	MOV		r2,#0
@ 	CMP		r0,#0
@ 	BLT		.END
@ 	CMP		r0,r1
@ 	BGT		.END
@ 	MOVWEQ	r2,#0x7FFF
@ 	BEQ		.END
@ 
@ 	LSL		r0,r0,#15
@ 
@     clz  r3, r0                /* r3 ← CLZ(r0) Count leading zeroes of N */
@     clz  r2, r1                /* r2 ← CLZ(r1) Count leading zeroes of D */
@     sub  r3, r2, r3            /* r3 ← r2 - r3. 
@                                  This is the difference of zeroes
@                                  between D and N. 
@                                  Note that N >= D implies CLZ(N) <= CLZ(D)*/
@     add r3, r3, #1             /* Loop below needs an extra iteration count */
@  
@     mov r2, #0                 /* r2 ← 0 */
@     b .Lloop_check4
@ .Lloop4:
@       cmp r0, r1, lsl r3       /* Compute r0 - (r1 << r3) and update cpsr */
@       adc r2, r2, r2           /* r2 ← r2 + r2 + C.
@                                   Note that if r0 >= (r1 << r3) then C=1, C=0 otherwise */
@       subcs r0, r0, r1, lsl r3 /* r0 ← r0 - (r1 << r3) if C = 1 (this is, only if r0 >= (r1 << r3) ) */
@ .Lloop_check4:
@       subs r3, r3, #1          /* r3 ← r3 - 1 */
@       bpl .Lloop4              /* if r3 >= 0 (N=0) then branch to .Lloop1 */
@ .END: 
@     mov r0, r2
@     bx lr

