.text
.align 4
.code 32
.global negate
.type negate, %function

negate:
	MVN		r0,r0
	ADD		r0,#1
	CMP		r0,#0x8000
	SUBEQ	r0,#1
	BX		lr

#	MVN		r0,r0
#	ADD		r0,#1
#	CMP		r0,#(1 << 16)
#	ASREQ	r0,r0,#1

#	SXTAH	r0,r1,r0
#	QADD	r0,r0,r1
#	SSAT	r0,#16,r0
#	BX		lr

