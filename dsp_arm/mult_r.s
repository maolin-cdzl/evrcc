.text
.align 4
.code 32
.global mult_r
.type mult_r, %function

mult_r:
	SMULBB	r2,r0,r1
	QADD	r0,r2,r2
	MOV		r2,#0x8000
	QADD	r0,r0,r2
	ASR		r0,r0,#16
	BX		lr


