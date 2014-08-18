.text
.align 4
.code 32
.global msu_r
.type msu_r, %function

msu_r:
	SMULBB	r3,r1,r2
	QDSUB	r0,r0,r3
	MOV		r1,#0x8000
	QADD	r0,r0,r1
	ASR		r0,r0,#16
	BX		lr


