.text
.align 4
.code 32
.global mult
.type mult, %function

mult:
	SMULBB	r2,r0,r1
	QADD	r0,r2,r2
	ASR		r0,r0,#16
	BX		lr


