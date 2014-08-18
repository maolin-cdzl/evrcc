.text
.align 4
.code 32
.global round32
.type round32, %function

round32:
	MOV		r1,#0x8000
	QADD	r0,r0,r1
	ASR		r0,r0,#16
	BX		lr



