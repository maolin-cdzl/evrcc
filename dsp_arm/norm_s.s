.text
.align 4
.code 32
.global norm_s
.type norm_s, %function

norm_s:
	CMP		r0,#0
	BEQ		END
	MVNLT	r0,r0
	CLZ		r0,r0
	SUB		r0,r0,#17
END:
	BX		lr

