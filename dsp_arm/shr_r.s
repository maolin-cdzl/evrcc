.text
.align 4
.code 32
.global shr_r 
.type shr_r, %function

shr_r:
	CMP		r1,#15
	MOVGT	r0,#0
	BGT		end_r
	MOV		r2,r0
	MOV		r3,r1
shr:
	LSL		r0,r0,#16
	CMP		r0,#0
	BEQ		end
	CMP		r1,#0
	BEQ		end
	BLT		lshift	
rshift:
	CMP		r1,#16
	MOVGT	r1,#16
	ASR		r0,r0,r1
	B		end
lshift:
	RSB		r1,r1,#0
	CMP		r1,#16
	MOVGT	r1,#16
	LSL		r0,r0,r1
	CMP		r2,r0,ASR r1
	BEQ		end
	MOV		r1,#0x7FFFFFFF
	EOR		r0,r1,r2, ASR #31
end:
	ASR		r0,r0,#16
	CMP		r2,#0
	BLT		end_r
	MOV		r1,#1
	SUB		r3,#1
	TST		r2,r1,LSL r3
	ADDNE	r0,#1
end_r:
	BX		lr
