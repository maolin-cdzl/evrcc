.text
.align 4
.code 32
.global L_add
.type L_add, %function

L_add:
	QADD	r0, r0, r1
	BX		lr
