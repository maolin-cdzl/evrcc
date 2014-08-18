.text
.align 4
.code 32
.global shift_r
.type shift_r, %function

shift_r:
	MOV		r2,r0
	CMP		r0,#0
	BEQ		END
	CMP		r1,#0
	BEQ		END
	BGT		L_SHIFT

R_SHIFT:
	SUB		r1,#1
	EOR		r1,r1,r1, ASR # 31

	CMP		r1,#15
	MOVGT	r0,#0
	BGT		END

	ASRS	r0,r0,r1
	ADDCS	r0,r0,#1
	B		END

L_SHIFT:
	CMP		r1,#15
	BGT		OVERFLOW
	
	ADD		r1,r1,#16
	LSL		r0,r0,r1
	CMP		r2,r0,ASR r1

	BNE		OVERFLOW
	ASR		r0,r0,#16
	B		END
OVERFLOW:
	CMP		r2,#0
	MOVWGT	r0,#0x7FFF
	MOVLT	r0,#0x80000000
	ASRLT	r0,r0,#16
	B		END

END:
	BX		lr

