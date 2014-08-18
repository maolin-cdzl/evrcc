.text
.align 4
.code 32
.global L_mac
.type L_mac, %function

@*  int L_mac(int L_var3,short var1,short var2);

L_mac:
	STMFD	sp!,{r4 - r5}

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
	QDADD	r0,r0,r1
	QADD	r0,r0,r3

	LDMFD	sp!,{r4 - r5}
	BX		lr

