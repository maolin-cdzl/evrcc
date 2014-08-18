.text
.align 4
.code 32
.global L_abs
.type L_abs, %function


L_abs:
	CMP		r0,#0
	SUBLT	r0,#1
	EOR		r0,r0,r0, ASR #31
	BX		lr

