.text
.align 4
.code 32
.global saturate
.type saturate, %function

saturate:
	SSAT	r0,#16,r0
	BX		lr



