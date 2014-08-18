.text
.align 4
.code 32
.global add
.type add, %function

add:
	QADD	r0,r0,r1
	SSAT	r0,#16,r0
	BX		lr
