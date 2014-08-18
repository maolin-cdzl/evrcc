.text
.align 4
.code 32
.global L_mpy_ll
.type L_mpy_ll, %function

@*
@* Longword L_mpy_ll(Longword L_var1, Longword L_var2);
@*

L_mpy_ll:
	STMFD	sp!,{r4 - r11,lr}

	EOR		r3,r3,r3
	MOVW	r3,#0xFFFF

	AND		r4,r3,r0, ASR #16
	AND		r5,r0,r3
	LSR		r5,r5,#1

	AND		r6,r3,r1, ASR #16
	AND		r7,r1,r3
	LSR		r7,r7,#1

	SMULBB	r8,r4,r6
	MOV		r9,#0
	QDADD	r10,r9,r8

	SMULBB	r11,r4,r7
	MOV		r4,r11, ASR #15
	QDADD	r8,r10,r4
	
	SMULBB	r11,r5,r6
	MOV		r5,r11, ASR #15
	QDADD	r10,r8,r5

	MOV		r0,r10

	LDMFD	sp!,{r4 - r11,lr}
	BX		lr



