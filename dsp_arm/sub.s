.text
.align 4
.code 32
.global sub
.type sub, %function

sub:
	QSUB	r0,r0,r1
	SSAT	r0,#16,r0
	BX		lr

