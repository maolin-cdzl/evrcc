.text
.align 4
.code 32
.global L_sub
.type L_sub, %function

L_sub:

	QSUB	r0, r0, r1
	BX		lr

