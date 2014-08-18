.text
.align 4
.code 32
.global abs_s
.type abs_s, %function


abs_s:
	LSL		r0,r0,#16
	CMP		r0,#0
	SUBLT	r1,r0,#1
	EORLT	r0,r1,r1, ASR #31
	ASR		r0,r0,#16
	BX		lr
