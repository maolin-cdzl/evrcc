.text
.align 4
.code 32
.global asm_test


.func asm_test
asm_test:
	STMFD	sp!,{r4,r5,r6}

	LDMFD		sp!,{r4,r5,r6}
	BX			lr
.endfunc


