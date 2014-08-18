.arm
.section .rodata
.global fft_stage5_phs_tbl,fft_64_bit_reorder_tbl,fft_64_bit_reorder_tbl_end

.align 2
fft_stage5_phs_tbl:
	.short 32767, 0, 32610, -3212
	.short 32138, -6393, 31357, -9512
	.short 30274, -12540, 28899, -15447
	.short 27246, -18205, 25330, -20788
	.short 23170, -23170, 20788, -25330
	.short 18205, -27246, 15447, -28899
	.short 12540, -30274, 9512, -31357 
	.short 6393, -32138,  3212, -32610
	.short 0, -32768, -3212, -32610
	.short -6393, -32138, -9512, -31357
	.short -12540, -30274, -15447, -28899
	.short -18205, -27246, -20788, -25330
	.short -23170, -23170, -25330, -20788
	.short -27246, -18205, -28899, -15447
	.short -30274, -12540, -31357, -9512 
	.short -32138, -6393, -32610, -3212  



.align 4
	/* bit-reveserd order switch index table for 64 signal array*/
fft_64_bit_reorder_tbl:
	.word 4,128
	.word 8,64
	.word 12,192
	.word 16,32
	.word 20,160
	.word 24,96
	.word 28,224
	.word 36,144
	.word 40,80
	.word 44,208
	.word 52,176
	.word 56,112
	.word 60,240
	.word 68,136
	.word 76,200
	.word 84,168
	.word 88,104
	.word 92,232
	.word 100,152
	.word 108,216
	.word 116,184
	.word 124,248
	.word 140,196
	.word 148,164
	.word 156,228
	.word 172,212
	.word 188,244
	.word 220,236
fft_64_bit_reorder_tbl_end:
