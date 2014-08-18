.text
.align 4
.code 32
.global norm_l
.type norm_l, %function


norm_l:
	CMP		r0,#0
	BEQ		END
	MVNLT	r0,r0
	CLZ		r0,r0
	SUB		r0,r0,#1
END:
	BX		lr

