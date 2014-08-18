.text
.align 4
.code 32
.global divide_s
.type divide_s, %function

divide_s:
	STMFD	sp!,{r4 - r5}
	MOV		r2,#0
	CMP		r0,#0
	BLT		END
	CMP		r0,r1
	BGT		END
	MOVWEQ	r2,#0x7FFF
	BEQ		END

	MOV		r3,r1,LSL #1
	MOV		r4,r1,LSL #2
	MOV		r5,#5
REPEAT:
	CMP		r5,#0
	BEQ		END

	LSL		r2,r2,#3
	LSL		r0,r0,#3
	
	CMP		r0,r4
	SUBGE	r0,r0,r4
	ORRGE	r2,r2,#4

	CMP		r0,r3
	SUBGE	r0,r0,r3
	ORRGE	r2,r2,#2

	CMP		r0,r1
	SUBGE	r0,r0,r1
	ORRGE	r2,r2,#1

	SUB		r5,#1
	B		REPEAT	
END:
	MOV		r0,r2
	LDMFD	sp!,{r4 - r5}
	BX		lr


