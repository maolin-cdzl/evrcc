.text
.align 4
.code 32
.global L_negate
.type L_negate, %function

L_negate:
	MVN		r0,r0
	MOV		r1,#1
	QADD	r0,r0,r1
	BX		lr
