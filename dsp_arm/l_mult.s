.text
.align 4
.code 32
.global L_mult
.type L_mult, %function

L_mult:
	SMULBB	r2,r0,r1
	QADD	r0,r2,r2
	BX		lr


