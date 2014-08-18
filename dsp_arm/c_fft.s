.text
.align 4
.code 32
.global c_fft

/* fft not push/pop any registers,and only use r4-r9,so call it first before any other code*/
.func fft_dit_reorder
fft_dit_reorder:
	/* Rearrange the input array in bit reversed order */
	/* Hard code for evrc */
	LDR		r4,	=fft_64_bit_reorder_tbl
	LDR		r5, =fft_64_bit_reorder_tbl_end
.DIT_Loop:
	LDRD	r6,r7,[r4]
	LDR		r8,[r0,+r6]
	LDR		r9,[r0,+r7]
	STR		r8,[r0,+r7]
	STR		r9,[r0,+r6]
	ADD		r4,#8
	CMP		r4,r5
	BNE		.DIT_Loop

	BX		lr
.endfunc

.macro call_func_r1
	MOV		lr,pc
	MOV		pc,r1
.endm

.macro fft_set_w r0,i0,r1,i1,r2,i2,r3,i3
	PUSH		{ r4,r5 }
	MOVW		r4,\r0
	MOVT		r4,\r1
	MOVW		r5,\r2
	MOVT		r5,\r3
	VMOV		D30,r4,r5

	MOVW		r4,\i0
	MOVT		r4,\i1
	MOVW		r5,\i2
	MOVT		r5,\i3
	VMOV		D31,r4,r5
	POP			{ r4,r5 }
.endm

	/* Q8,Q9 is data to compute,Q0-Q7 unchanged*/
fft_bfly: 
	VTRN.16		D16,D17
	VTRN.16		D18,D19
	VTRN.32		Q8,Q9

	VQDMULL.S16	Q12,D18,D30		@* D30 = phs_tbl[ji]
	VQDMULL.S16 Q13,D19,D31		@* D31 = phs_tbl[ji+1]
	VQSUB.S32	Q10,Q12,Q13			@* Q10 is ftmp_real

	VQDMULL.S16 Q12,D19,D30
	VQDMULL.S16 Q13,D18,D31
	VQADD.S32	Q11,Q12,Q13			@* Q11 is ftmp_imag

	@* round32 real part Q10
	VQADD.S32	Q10,Q14				@* Q14 fill with 0x8000(s32)
	VSHRN.S32	D20,Q10,#16			@* D20 is tmp1

	@* round32 imag part Q11
	VQADD.S32	Q11,Q14
	VSHRN.S32	D22,Q11,#16			@* D22 is tmp2

	VQSUB.S16	D21,D16,D20
	VSHR.S16	D18,D21,#1

	VQSUB.S16	D21,D17,D22
	VSHR.S16	D19,D21,#1

	VQADD.S16	D16,D20
	VSHR.S16	D16,#1

	VQADD.S16	D17,D22
	VSHR.S16	D17,#1

	VTRN.16		D16,D17
	VTRN.16		D18,D19
	VTRN.32		Q8,Q9

	BX			lr

	/* Q8,Q9 is data to compute,Q0-Q7 unchanged*/
ifft_bfly: 
	VTRN.16		D16,D17
	VTRN.16		D18,D19
	VTRN.32		Q8,Q9

	VQDMULL.S16	Q12,D18,D30			@* D30 = phs_tbl[ji]
	VQDMULL.S16 Q13,D19,D31			@* D31 = phs_tbl[ji+1]
	VQADD.S32	Q10,Q12,Q13			@* Q10 is ftmp_real

	VQDMULL.S16 Q12,D19,D30
	VQDMULL.S16 Q13,D18,D31
	VQSUB.S32	Q11,Q12,Q13			@* Q11 is ftmp_imag

	@* round32 real part Q10
	VQADD.S32	Q10,Q14				@* Q14 fill with 0x8000(s32)
	VSHRN.S32	D20,Q10,#16			@* D20 is tmp1

	@* round32 imag part Q11
	VQADD.S32	Q11,Q14
	VSHRN.S32	D22,Q11,#16			@* D22 is tmp2

	VQSUB.S16		D18,D16,D20
	VQSUB.S16		D19,D17,D22
	VQADD.S16		D16,D20
	VQADD.S16		D17,D22

	VTRN.16		D16,D17
	VTRN.16		D18,D19
	VTRN.32		Q8,Q9

	BX			lr


@* void c_fft_stageX(short* data)
.func c_fft_stage0			
c_fft_stage0:
	STMFD	sp!,{r4,r5,lr}
	MOV			r4,r0
	ADD			r5,r4,#256
.STAGE0_LOOP:
	VLDMIA		r4,{Q0,Q1,Q2,Q3}
	
	VMOV		Q8,Q0
	VMOV		Q9,Q1
	fft_set_w	#32767,#0,#32767,#0,#32767,#0,#32767,#0
	call_func_r1
	VMOV		Q0,Q8
	VMOV		Q1,Q9

	VMOV		Q8,Q2
	VMOV		Q9,Q3
	fft_set_w	#32767,#0,#32767,#0,#32767,#0,#32767,#0
	call_func_r1
	VMOV		Q2,Q8
	VMOV		Q3,Q9

	VSTMIA		r4!,{Q0,Q1,Q2,Q3}
	
	CMP			r4,r5
	BNE			.STAGE0_LOOP
	
	LDMFD		sp!,{r4,r5,pc}
.endfunc

.func c_fft_stage1
c_fft_stage1:
	STMFD	sp!,{r4 - r11,lr}

	MOV		r4,r0
	ADD		r5,r4,#256
.STAGE1_LOOP:
	VLDMIA		r4,{Q0,Q1,Q2,Q3}

	VTRN.32		D0,D1
	VTRN.32		D2,D3
	VMOV		Q8,Q0
	VMOV		Q9,Q1
	fft_set_w	#32767,#0,#0,#0x8000,#32767,#0,#0,#0x8000
	call_func_r1
	VMOV		Q0,Q8
	VMOV		Q1,Q9
	VTRN.32		D0,D1
	VTRN.32		D2,D3


	VTRN.32		D4,D5
	VTRN.32		D6,D7
	VMOV		Q8,Q2
	VMOV		Q9,Q3
	fft_set_w	#32767,#0,#0,#0x8000,#32767,#0,#0,#0x8000
	call_func_r1
	VMOV		Q2,Q8
	VMOV		Q3,Q9
	VTRN.32		D4,D5
	VTRN.32		D6,D7

	VSTMIA		r4!,{Q0,Q1,Q2,Q3}

	CMP			r4,r5
	BNE			.STAGE1_LOOP

	LDMFD	sp!,{r4 - r11,pc}
.endfunc

.func c_fft_stage2
c_fft_stage2:
	STMFD	sp!,{r4 - r11,lr}

	MOV		r4,r0
	ADD		r5,r4,#256
.STAGE2_LOOP:
	VLD4.32		{D16,D17,D18,D19}, [r4]
	fft_set_w	#0x7fff,#0,#0x5a82,#0xa57e,#0,#0x8000,#0xa57e,#0xa57e
	call_func_r1
	VST4.32		{D16,D17,D18,D19}, [r4]!

	CMP			r4,r5
	BNE			.STAGE2_LOOP
	LDMFD	sp!,{r4 - r11,pc}
.endfunc

.func c_fft_stage3
c_fft_stage3:
	STMFD	sp!,{r4 - r11,lr}

	MOV		r4,r0
	ADD		r5,r4,#256
.STAGE3_LOOP:
	VLDMIA		r4,{Q0,Q1,Q2,Q3}
	VZIP.32		Q0,Q2
	VZIP.32		Q1,Q3

	VMOV		Q8,Q0
	VMOV		Q9,Q1
	fft_set_w	#0x7fff,#0,#0x7642,#0xcf04,#0,#0x8000,#0xcf04,#0x89be
	call_func_r1
	VMOV		Q0,Q8
	VMOV		Q1,Q9

	VMOV		Q8,Q2
	VMOV		Q9,Q3
	fft_set_w	#0x5a82,#0xa57e,#0x30fc,#0x89be,#0xa57e,#0xa57e,#0x89be,#0xcf04
	call_func_r1
	VMOV		Q2,Q8
	VMOV		Q3,Q9

	VUZP.32	Q0,Q2
	VUZP.32	Q1,Q3

	VSTMIA		r4!,{Q0,Q1,Q2,Q3}

	CMP			r4,r5
	BNE			.STAGE3_LOOP
	LDMFD	sp!,{r4 - r11,pc}
.endfunc

.func c_fft_stage4
c_fft_stage4:
	STMFD	sp!,{r4 - r11,lr}

	MOV		r4,r0
	ADD		r5,r4,#256
	ADD		r6,r4,#64
.STAGE4_LOOP:
	VLDMIA		r4,{Q0,Q1,Q2,Q3}
	VLDMIA		r6,{Q4,Q5,Q6,Q7}

	VZIP.32		Q0,Q4
	VMOV		Q8,Q0
	VMOV		Q9,Q4
	fft_set_w	#0x7fff,#0,#0x7d8a,#0xe707,#0x7642,#0xcf04,#0x6a6e,#0xb8e3
	call_func_r1
	VMOV		Q0,Q8
	VMOV		Q4,Q9
	VUZP.32		Q0,Q4

	VZIP.32		Q1,Q5
	VMOV		Q8,Q1
	VMOV		Q9,Q5
	fft_set_w	#0x5a82,#0xa57e,#0x471d,#0x9592,#0x30fc,#0x89be,#0x18f9,#0x8276
	call_func_r1
	VMOV		Q1,Q8
	VMOV		Q5,Q9
	VUZP.32		Q1,Q5

	VZIP.32		Q2,Q6
	VMOV		Q8,Q2
	VMOV		Q9,Q6
	fft_set_w	#0x0,#0x8000,#0xe707,#0x8276,#0xcf04,#0x89be,#0xb8e3,#0x9592
	call_func_r1
	VMOV		Q2,Q8
	VMOV		Q6,Q9
	VUZP.32		Q2,Q6

	VZIP.32		Q3,Q7
	VMOV		Q8,Q3
	VMOV		Q9,Q7
	fft_set_w	#0xa57e,#0xa57e,#0x9592,#0xb8e3,#0x89be,#0xcf04,#0x8276,#0xe707
	call_func_r1
	VMOV		Q3,Q8
	VMOV		Q7,Q9
	VUZP.32		Q3,Q7

	VSTMIA		r4!,{Q0,Q1,Q2,Q3}
	VSTMIA		r6!,{Q4,Q5,Q6,Q7}

	CMP			r6,r5
	ADDNE		r4,#64
	ADDNE		r6,#64
	BNE			.STAGE4_LOOP

	LDMFD	sp!,{r4 - r11,pc}
.endfunc

.func c_fft_stage5
c_fft_stage5:
	STMFD	sp!,{r4 - r11,lr}
	MOV		r4,r0
	ADD		r5,r0,#128
	ADD		r6,r0,#256
	LDR		r7,=fft_stage5_phs_tbl

.STAGE5_LOOP:
	VLDMIA	r4,{Q8}
	VLDMIA	r5,{Q9}

	VZIP.32		Q8,Q9

	VLD2.16		{D30,D31},[r7]!
	call_func_r1

	VUZP.32		Q8,Q9
	VSTMIA		r4!,{Q8}
	VSTMIA		r5!,{Q9}

	CMP		r5,r6
	BNE		.STAGE5_LOOP

	LDMFD	sp!,{r4 - r11,pc}
.endfunc

.func c_fft
c_fft:
	STMFD	sp!,{r4 - r11,lr}
	
	BL		fft_dit_reorder

	MOV			r4,#0x8000
	VDUP.32		Q14,r4

	CMP		r1,#1
	LDREQ	r1,=fft_bfly
	LDRNE	r1,=ifft_bfly

	BL		c_fft_stage0
	BL		c_fft_stage1
	BL		c_fft_stage2
	BL		c_fft_stage3
	BL		c_fft_stage4
	BL		c_fft_stage5

	LDMFD	sp!,{r4 - r11,lr}
	BX		lr
.endfunc
