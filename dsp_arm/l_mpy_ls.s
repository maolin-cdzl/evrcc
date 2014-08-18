.text
.align 4
.code 32
.global L_mpy_ls
.type L_mpy_ls, %function

@*
@* Longword L_mpy_ls(Longword L_var1, Shortword var2);
@*

@*	register Word32 ra = L_var1_hi;	r4
@*	register Word32 rb = L_var1_lo;	r5
@*	register Word32 rc = var2;		r1
@*	Word32 result;					r6
@*	Word32 L_product;				r7

L_mpy_ls:
	STMFD	sp!,{r4 - r11,lr}
	
	EOR		r3,r3,r3
	MOVW	r3,#0xFFFF

	AND		r4,r3,r0, ASR #16
	AND		r5,r0,r3

	LSR		r5,r5,#1		@ truncated to 31 bits for EVRC

	SMULBB	r7,r4,r1
	MOV		r6,#0
	QDADD	r7,r6,r7
	
	SMULBB	r6,r5,r1
	MOV		r4,r6, ASR #15
	QDADD	r6,r7,r4

	MOV		r0,r6

	LDMFD	sp!,{r4 - r11,lr}
	BX		lr

