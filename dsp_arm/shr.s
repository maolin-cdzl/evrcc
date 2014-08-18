.text
.align 4
.code 32
.global shr
.type shr, %function

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
	MOV		r2,r0
	LSL		r0,r0,r1
	CMP		r2,r0,ASR r1
	BEQ		end
	MOV		r1,#0x7FFFFFFF
	EOR		r0,r1,r2, ASR #31
end:
	ASR		r0,r0,#16
	BX		lr

	

