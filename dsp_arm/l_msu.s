.text
.align 4
.code 32
.global L_msu
.type L_msu, %function

L_msu:
	STMFD	sp!,{r4 - r5}

#	MVN		r4,#0
#	LSL		r4,r4,#15
	MOVT	r4,#0xFFFF
	MOVW	r4,#0x8000
	MOV		r3,#0

	CMN		r1,r4
	BNE		NORMAL
	CMN		r2,r4
	BNE		NORMAL

	MOV		r3,#1
NORMAL:

	SMULBB	r1,r1,r2
	QDSUB	r0,r0,r1
	QSUB	r0,r0,r3

	LDMFD	sp!,{r4 - r5}
	BX		lr

