.text
.align 4
.code 32
.global L_shl
.type L_shl, %function

#L_shl:
#	CMP		r0,#0
#	BEQ		.END
#	CMP		r1,#0
#	BEQ		.END
#
#	@* right shift
#	SUBLT	r1,#1
#	EORLT	r1,r1,r1, ASR #31
#	ASRLT	r0,r0,r1
#	BLT		.END
#
#	@* left shift
#	CMP		r0,#0
#	MVNLT	r2,r0
#	CLZ		r2,r2
#	SUB		r2,r2,#1
#
#	CMP		r1,r2
#	LSLLE	r0,r0,r1
#	BLE		.END
#
#	@* Overflow
#	CMP		r0,#0
#	MOVGT	r0,#0x7FFFFFFF
#	MOVLT	r0,#0x8000000
#.END:
#	BX		lr

L_shl:
	MOV		r2,r0
	CMP		r0,#0
	BEQ		END
	CMP		r1,#0
	BEQ		END
	BLT		R_SHIFT
L_SHIFT:
	CMP		r1,#31
	BGT		OVERFLOW

	LSL		r0,r0,r1
	CMP		r2,r0,ASR r1
	BEQ		END
	B		OVERFLOW
R_SHIFT:
	SUB		r1,#1
	EOR		r1,r1,r1, ASR # 31

	CMP		r1,#31
	BGT		UNDERFLOW
	ASR		r0,r0,r1
	B		END

OVERFLOW:
	CMP		r2,#0
	MOVGT	r0,#0x7FFFFFFF
	MOVLT	r0,#0x80000000
	B		END

UNDERFLOW:
	CMP		r2,#0
	MOVGT	r0,#0
	MVNLT	r0,#0
	B		END
END:
	BX		lr

