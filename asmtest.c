#include <stdlib.h>
#include <stdio.h>
#include <time.h>

#include "dsp_foo/mathevrc.h"
#include "include/dsp_math.h"


#define LOOP_COUNT			10000
#define BIG_LOOP_COUNT		1000000

static const INT16 s_vars[] = { 0,1,2,15,16,31,32,32766,32767,-1,-2,-15,-16,-31,-32,-32767,-32768};
static const int l_vars[] = { 0,1,2,15,16,31,32,32766,32767,0x7FFFFFFE,0x7FFFFFFF,-1,-2,-15,-16,-31,-32,-32767,-32768,0x80000001,0x80000000 };

static const INT16 us_vars[] = { 0,1,2,15,16,31,32,32766,32767};

static UINT32 gettime_ms() {
	UINT32 ms = 0;
	struct timespec	tv;
	clock_gettime(CLOCK_MONOTONIC,&tv);
	ms = (tv.tv_sec * 1000) + (tv.tv_nsec / 1000000);
	return ms;
}


typedef Shortword (*tfunc_s_s)(Shortword);
typedef Shortword (*tfunc_s_ss)(Shortword,Shortword);
typedef Longword (*tfunc_l_l)(Longword);
typedef Longword (*tfunc_l_ls)(Longword,Shortword);
typedef Longword (*tfunc_l_ll)(Longword,Longword);

typedef Shortword (*tfunc_s_l)(Longword);

static int test_s_s(const char* name,tfunc_s_s f1,tfunc_s_s f2) {
	int i,k;
	UINT32 tv_start;
	INT16 svar1,sres1,sres2;

	printf("testing %s\n",name);
	for(i=0; i < sizeof(s_vars)/sizeof(INT16); ++i) {
		svar1 = s_vars[i];
		sres1 = (*f1)(svar1);
		sres2 = (*f2)(svar1);
		if( sres1 != sres2 ) {
			printf("%s(%hd) func1=%hd, func2=%hd\n",name,svar1,sres1,sres2);
			return -1;
		}
	}

	for(i=0;i < LOOP_COUNT; ++i) {
		svar1 = (INT16)(rand() & 0x0000FFFF);
		sres1 = (*f1)(svar1);
		sres2 = (*f2)(svar1);
		if( sres1 != sres2 ) {
			printf("%s(%hd) func1=%hd, func2=%hd\n",name,svar1,sres1,sres2);
			return -1;
		}
	}

	tv_start = gettime_ms();
	k = BIG_LOOP_COUNT;
	do {
		for(i=sizeof(s_vars)/sizeof(INT16); i && k; --i,--k) {
			sres1 = (*f2)(s_vars[i]);
		}
	} while(k);
	printf("func2 %s cost: %lu ms\n",name,gettime_ms() - tv_start);
	tv_start = gettime_ms();

	k = BIG_LOOP_COUNT;
	do {
		for(i=sizeof(s_vars)/sizeof(INT16); i && k; --i,--k) {
			sres1 = (*f1)(s_vars[i]);
		}
	} while(k);
	printf("func1 %s cost: %lu ms\n",name,gettime_ms() - tv_start);
}

static int test_s_ss(const char* name,tfunc_s_ss f1,tfunc_s_ss f2) {
	int i,j,k;
	INT16 svar1,svar2,sres1,sres2;
	UINT32 tv_start;

	printf("testing %s\n",name);
	for(i=0; i < sizeof(s_vars)/sizeof(INT16); ++i) {
		svar1 = s_vars[i];
		for(j=0; j < sizeof(s_vars)/sizeof(INT16); ++j) {
			svar2 = s_vars[j];

			sres1 = (*f1)(svar1,svar2);
			sres2 = (*f2)(svar1,svar2);
			if( sres1 != sres2 ) {
				printf("%s(%hd,%hd) func1=%hd, func2=%hd\n",name,svar1,svar2,sres1,sres2);
				return -1;
			}
		}
	}

	for(i=0;i < LOOP_COUNT; ++i) {
		svar1 = (INT16)(rand() & 0x0000FFFF);
		svar2 = (INT16)(rand() & 0x0000FFFF);

		sres1 = (*f1)(svar1,svar2);
		sres2 = (*f2)(svar1,svar2);
		if( sres1 != sres2 ) {
			printf("%s(%hd,%hd) func1=%hd, func2=%hd\n",name,svar1,svar2,sres1,sres2);
			return -1;
		}
	}


	tv_start = gettime_ms();
	k = BIG_LOOP_COUNT;
	do {
		for(i=sizeof(s_vars)/sizeof(INT16); i && k ; --i) {
			svar1 = s_vars[i];
			for(j=sizeof(s_vars)/sizeof(INT16); j && k ; --j,--k) {
				svar2 = s_vars[j];
				sres1 = (*f2)(svar1,svar2);
			}
		}
	} while( k != 0);
	printf("func2 %s cost: %lu ms\n",name,gettime_ms() - tv_start);

	tv_start = gettime_ms();
	k = BIG_LOOP_COUNT;
	do {
		for(i=sizeof(s_vars)/sizeof(INT16); i && k ; --i) {
			svar1 = s_vars[i];
			for(j=sizeof(s_vars)/sizeof(INT16); j && k ; --j,--k) {
				svar2 = s_vars[j];
				sres1 = (*f1)(svar1,svar2);
			}
		}
	} while( k != 0);
	printf("func1 %s cost: %lu ms\n",name,gettime_ms() - tv_start);
}

static int test_l_l(const char* name,tfunc_l_l f1,tfunc_l_l f2) {
	int i,k;
	UINT32 tv_start;
	int lvar1,lres1,lres2;

	printf("testing %s\n",name);
	for(i=0; i < sizeof(l_vars)/sizeof(int); ++i) {
		lvar1 = l_vars[i];
		lres1 = (*f1)(lvar1);
		lres2 = (*f2)(lvar1);
		if( lres1 != lres2 ) {
			printf("%s(%d) func1=%d, func2=%d\n",name,lvar1,lres1,lres2);
			return -1;
		}
	}

	for(i=0;i < LOOP_COUNT; ++i) {
		lvar1 = rand();
		lres1 = (*f1)(lvar1);
		lres2 = (*f2)(lvar1);
		if( lres1 != lres2 ) {
			printf("%s(%d) func1=%d, func2=%d\n",name,lvar1,lres1,lres2);
			return -1;
		}
	}

	tv_start = gettime_ms();
	k = BIG_LOOP_COUNT;
	do {
		for(i=sizeof(l_vars)/sizeof(int); i && k ; --i,--k) {
			lvar1 = l_vars[i];
			lres1 = (*f2)(lvar1);
		}
	} while( k );
	printf("func2 %s cost: %lu ms\n",name,gettime_ms() - tv_start);

	tv_start = gettime_ms();
	k = BIG_LOOP_COUNT;
	do {
		for(i=sizeof(l_vars)/sizeof(int); i && k ; --i,--k) {
			lvar1 = l_vars[i];
			lres1 = (*f1)(lvar1);
		}
	} while( k );
	printf("func1 %s cost: %lu ms\n",name,gettime_ms() - tv_start);
}


static int test_l_ls(const char* name,tfunc_l_ls f1,tfunc_l_ls f2) {
	int i,j,k;
	int lvar1,lres1,lres2;
	INT16 svar2;
	UINT32 tv_start;

	printf("testing %s\n",name);
	for(i=0; i < sizeof(l_vars)/sizeof(int); ++i) {
		lvar1 = l_vars[i];
		for(j=0; j < sizeof(s_vars)/sizeof(INT16); ++j) {
			svar2 = s_vars[j];

			lres1 = (*f1)(lvar1,svar2);
			lres2 = (*f2)(lvar1,svar2);
			if( lres1 != lres2 ) {
				printf("%s(%d,%hd) func1=%d, func2=%d\n",name,lvar1,svar2,lres1,lres2);
				return -1;
			}
		}
	}

	for(i=0;i < LOOP_COUNT; ++i) {
		lvar1 = rand();
		svar2 = (INT16)(rand() & 0x0000FFFF);

		lres1 = (*f1)(lvar1,svar2);
		lres2 = (*f2)(lvar1,svar2);
		if( lres1 != lres2 ) {
			printf("%s(%d,%hd) func1=%d, func2=%d\n",name,lvar1,svar2,lres1,lres2);
			return -1;
		}
	}

	tv_start = gettime_ms();
	k = BIG_LOOP_COUNT;
	do {
		for(i=sizeof(l_vars)/sizeof(int); i && k ; --i) {
			lvar1 = l_vars[i];
			for(j=sizeof(s_vars)/sizeof(INT16); j && k ; --j,--k) {
				svar2 = s_vars[j];
				lres1 = (*f2)(lvar1,svar2);
			}
		}
	} while( k );
	printf("func2 %s cost: %lu ms\n",name,gettime_ms() - tv_start);

	tv_start = gettime_ms();
	k = BIG_LOOP_COUNT;
	do {
		for(i=sizeof(l_vars)/sizeof(int); i && k ; --i) {
			lvar1 = l_vars[i];
			for(j=sizeof(s_vars)/sizeof(INT16); j && k ; --j,--k) {
				svar2 = s_vars[j];
				lres1 = (*f1)(lvar1,svar2);
			}
		}
	} while( k );
	printf("func1 %s cost: %lu ms\n",name,gettime_ms() - tv_start);
}

static int test_l_ll(const char* name,tfunc_l_ll f1,tfunc_l_ll f2) {
	int i,j,k;
	int lvar1,lvar2,lres1,lres2;
	UINT32 tv_start;

	printf("testing %s\n",name);
	for(i=0; i < sizeof(l_vars)/sizeof(int); ++i) {
		lvar1 = l_vars[i];
		for(j=0; j < sizeof(l_vars)/sizeof(int); ++j) {
			lvar2 = l_vars[j];

			lres1 = (*f1)(lvar1,lvar2);
			lres2 = (*f2)(lvar1,lvar2);
			if( lres1 != lres2 ) {
				printf("%s(%d,%d) func1=%d, func2=%d\n",name,lvar1,lvar2,lres1,lres2);
				return -1;
			}
		}
	}

	for(i=0;i < LOOP_COUNT; ++i) {
		lvar1 = rand();
		lvar2 = rand();

		lres1 = (*f1)(lvar1,lvar2);
		lres2 = (*f2)(lvar1,lvar2);
		if( lres1 != lres2 ) {
			printf("%s(%d,%d) func1=%d, func2=%d\n",name,lvar1,lvar2,lres1,lres2);
			return -1;
		}
	}

	tv_start = gettime_ms();
	k = BIG_LOOP_COUNT;
	do {
		for(i=sizeof(l_vars)/sizeof(int); i && k ; --i) {
			lvar1 = l_vars[i];
			for(j=sizeof(l_vars)/sizeof(int); j && k ; --j,--k) {
				lvar2 = l_vars[j];
				lres1 = (*f2)(lvar1,lvar2);
			}
		}
	} while( k );
	printf("func2 %s cost: %lu ms\n",name,gettime_ms() - tv_start);

	tv_start = gettime_ms();
	k = BIG_LOOP_COUNT;
	do {
		for(i=sizeof(l_vars)/sizeof(int); i && k ; --i) {
			lvar1 = l_vars[i];
			for(j=sizeof(l_vars)/sizeof(int); j && k ; --j,--k) {
				lvar2 = l_vars[j];
				lres1 = (*f1)(lvar1,lvar2);
			}
		}
	} while( k );
	printf("func1 %s cost: %lu ms\n",name,gettime_ms() - tv_start);
}



static int test_s_l(const char* name,tfunc_s_l f1,tfunc_s_l f2) {
	int i,k;
	UINT32 tv_start;
	int lvar1;
	INT16 sres1,sres2;

	printf("testing %s\n",name);
	for(i=0; i < sizeof(l_vars)/sizeof(int); ++i) {
		lvar1 = l_vars[i];
		sres1 = (*f1)(lvar1);
		sres2 = (*f2)(lvar1);
		if( sres1 != sres2 ) {
			printf("%s(%d) func1=%hd, func2=%hd\n",name,lvar1,sres1,sres2);
			return -1;
		}
	}

	for(i=0;i < LOOP_COUNT; ++i) {
		lvar1 = rand();
		sres1 = (*f1)(lvar1);
		sres2 = (*f2)(lvar1);
		if( sres1 != sres2 ) {
			printf("%s(%d) func1=%hd, func2=%hd\n",name,lvar1,sres1,sres2);
			return -1;
		}
	}

	tv_start = gettime_ms();
	k = BIG_LOOP_COUNT;
	do {
		for(i=sizeof(l_vars)/sizeof(int); i && k; --i,--k) {
			sres1 = (*f2)(l_vars[i]);
		}
	} while(k);
	printf("func2 %s cost: %lu ms\n",name,gettime_ms() - tv_start);
	tv_start = gettime_ms();

	k = BIG_LOOP_COUNT;
	do {
		for(i=sizeof(l_vars)/sizeof(int); i && k; --i,--k) {
			sres1 = (*f1)(l_vars[i]);
		}
	} while(k);
	printf("func1 %s cost: %lu ms\n",name,gettime_ms() - tv_start);
}



int asm_test();

void c_fft_foo(Shortword * farray_ptr, Shortword isign);

int main(int argc,char** argv) {
	int i,j;
	UINT32 tv_start;
	short data[128];
	short seed[128];

	srand(time(NULL));
	for(i=0; i < 128; ++i) {
		seed[i] = (INT16)(rand() & 0x0000FFFF);
	}

	for(i=0; i < 128; ++i) {
		data[i] = seed[i];
	}
	i = 100000;
	tv_start = gettime_ms();
	do {
		c_fft_foo(data,0);
		--i;
	} while(i);
	printf("c fft cost: %lu ms\n",gettime_ms() - tv_start);
	printf("c fft:\n");
	for(i=0; i < 128; ++i) {
		printf("%hd\t",data[i]);
	}
	printf("\n");

	for(i=0; i < 128; ++i) {
		data[i] = seed[i];
	}
	i = 100000;
	tv_start = gettime_ms();
	do {
		c_fft(data,0);
		--i;
	} while(i);
	printf("neon fft cost: %lu ms\n",gettime_ms() - tv_start);

	printf("neon fft:\n");
	for(i=0; i < 128; ++i) {
		printf("%hd\t",data[i]);
	}
	printf("\n");

	return 0;

	test_s_s("abs_s",&foo_abs_s,&abs_s);
	test_s_s("negate",&foo_negate,&negate);
	test_s_s("norm_s",&foo_norm_s,&norm_s);

	test_l_l("L_abs",&foo_L_abs,&L_abs);
	test_l_l("L_negate",&foo_L_negate,&L_negate);

	test_s_l("round32",&foo_round32,&round32);
	test_s_l("norm_l",&foo_norm_l,&norm_l);

	test_s_ss("add",&foo_add,&add);
	test_s_ss("sub",&foo_sub,&sub);
	test_s_ss("mult",&foo_mult,&mult);
	test_s_ss("shr",&foo_shr,&shr);
	test_s_ss("shl",&foo_shl,&shl);
	test_s_ss("mult_r",&foo_mult_r,&mult_r);
	test_s_ss("divide_s",&foo_divide_s,&divide_s);
	test_s_ss("shift_r",&foo_shift_r,&shift_r);

	test_l_ls("L_shr",&foo_L_shr,&L_shr);
	test_l_ls("L_shl",&foo_L_shl,&L_shl);
	test_l_ls("L_shift_r",&foo_L_shift_r,&L_shift_r);
	test_l_ls("L_mpy_ls",&foo_L_mpy_ls,&L_mpy_ls);

	test_l_ll("L_add",&foo_L_add,&L_add);
	test_l_ll("L_sub",&foo_L_sub,&L_sub);
	test_l_ll("L_mpy_ll",&foo_L_mpy_ll,&L_mpy_ll);

	/*
	test_s_lss("msu_r",&foo_msu_r,&msu_r);
	test_s_lss("mac_r",&foo_mac_r,&mac_r);

	test_l_lss("L_mac",&foo_L_mac,&L_mac);
	test_l_lss("L_msu",&foo_L_msu,&L_msu);

	test_l_ss("L_mult",&foo_L_mult,L_mult);
	*/

	printf("Test done!\n");
	return 0;
}

////////////////////////////////
// c_fft
//
#define			SIZE			128
#define			SIZE_BY_TWO		64
#define			NUM_STAGE		6
#define			TRUE			1
#define			FALSE			0

static Shortword phs_tbl[] =
{

	32767, 0, 32729, -1608, 32610, -3212, 32413, -4808,
	32138, -6393, 31786, -7962, 31357, -9512, 30853, -11039,
	30274, -12540, 29622, -14010, 28899, -15447, 28106, -16846,
	27246, -18205, 26320, -19520, 25330, -20788, 24279, -22006,
	23170, -23170, 22006, -24279, 20788, -25330, 19520, -26320,
	18205, -27246, 16846, -28106, 15447, -28899, 14010, -29622,
	12540, -30274, 11039, -30853, 9512, -31357, 7962, -31786,
	6393, -32138, 4808, -32413, 3212, -32610, 1608, -32729,
	0, -32768, -1608, -32729, -3212, -32610, -4808, -32413,
	-6393, -32138, -7962, -31786, -9512, -31357, -11039, -30853,
	-12540, -30274, -14010, -29622, -15447, -28899, -16846, -28106,
	-18205, -27246, -19520, -26320, -20788, -25330, -22006, -24279,
	-23170, -23170, -24279, -22006, -25330, -20788, -26320, -19520,
	-27246, -18205, -28106, -16846, -28899, -15447, -29622, -14010,
	-30274, -12540, -30853, -11039, -31357, -9512, -31786, -7962,
	-32138, -6393, -32413, -4808, -32610, -3212, -32729, -1608

};

static Shortword ii_table[] =
{SIZE / 2, SIZE / 4, SIZE / 8, SIZE / 16, SIZE / 32, SIZE / 64};

/* FFT/IFFT function for complex sequences */

/*
 * The decimation-in-time complex FFT/IFFT is implemented below.
 * The input complex numbers are presented as real part followed by
 * imaginary part for each sample.  The counters are therefore
 * incremented by two to access the complex valued samples.
 */
void c_fft_foo(Shortword * farray_ptr, Shortword isign)
{
	int idx;
	Shortword i, j, k, ii, jj, kk, ji, kj;
	Longword ftmp, ftmp_real, ftmp_imag;
	Shortword tmp, tmp1, tmp2;

/* Rearrange the input array in bit reversed order */
	for (i = 0, j = 0; i < SIZE - 2; i = i + 2)
	{
		if (j > i)
		{
			ftmp = *(farray_ptr + i);
			*(farray_ptr + i) = *(farray_ptr + j);
			*(farray_ptr + j) = ftmp;

			ftmp = *(farray_ptr + i + 1);
			*(farray_ptr + i + 1) = *(farray_ptr + j + 1);
			*(farray_ptr + j + 1) = ftmp;
		}

		k = SIZE_BY_TWO;
		while (j >= k)
		{
			j = sub(j, k);
			k = shr(k, 1);
		}
		j += k;
	}

/* The FFT part */
	if (isign == 1)
	{
		for (i = 0; i <  NUM_STAGE; i++)
		{						/* i is stage counter */
			jj = shl(2, i);		/* FFT size */
			kk = shl(jj, 1);	/* 2 * FFT size */
			ii = ii_table[i];	/* 2 * number of FFT's */

			//printf("Stage[%hd],jj=%hd kk=%hd ii=%hd\n",i,jj,kk,ii);
			for (j = 0; j < jj; j = j + 2)
			{					/* j is sample counter */
				ji = j * ii;	/* ji is phase table index */
				/*
				 *if( i == 5 ) {
				 *printf("j=%hd,ji=%hd(phs_tab=(%hd,%hd))\n",j,ji,phs_tbl[ji],phs_tbl[ji+1]);
				 *}
				 */

				for (k = j; k < SIZE; k = k + kk)
				{				/* k is butterfly top */
					kj = add(k, jj);	/* kj is butterfly bottom */
					//printf("bfly(%hd,%hd)\n",k,kj);

					/* Butterfly computations */
					ftmp_real = L_sub(L_mult(*(farray_ptr + kj), phs_tbl[ji]),
									  L_mult(*(farray_ptr + kj + 1), phs_tbl[ji + 1]));
					ftmp_imag = L_add(L_mult(*(farray_ptr + kj + 1), phs_tbl[ji]),
									  L_mult(*(farray_ptr + kj), phs_tbl[ji + 1]));

					tmp1 = round32(ftmp_real);
					tmp2 = round32(ftmp_imag);

					tmp = sub(*(farray_ptr + k), tmp1);
					*(farray_ptr + kj) = shr(tmp, 1);

					tmp = sub(*(farray_ptr + k + 1), tmp2);
					*(farray_ptr + kj + 1) = shr(tmp, 1);

					tmp = add(*(farray_ptr + k), tmp1);
					*(farray_ptr + k) = shr(tmp, 1);

					tmp = add(*(farray_ptr + k + 1), tmp2);
					*(farray_ptr + k + 1) = shr(tmp, 1);
				}
			}
		}

/* The IFFT part */
	}
	else
	{
		for (i = 0; i < NUM_STAGE; i++)
		{						/* i is stage counter */
			jj = shl(2, i);		/* FFT size */
			kk = shl(jj, 1);	/* 2 * FFT size */
			ii = ii_table[i];	/* 2 * number of FFT's */

			for (j = 0; j < jj; j = j + 2)
			{					/* j is sample counter */
				ji = j * ii;	/* ji is phase table index */

				for (k = j; k < SIZE; k = k + kk)
				{				/* k is butterfly top */
					kj = add(k, jj);	/* kj is butterfly bottom */

					/* Butterfly computations */
					ftmp_real = L_add(L_mult(*(farray_ptr + kj), phs_tbl[ji]),
									  L_mult(*(farray_ptr + kj + 1), phs_tbl[ji + 1]));
					ftmp_imag = L_sub(L_mult(*(farray_ptr + kj + 1), phs_tbl[ji]),
									  L_mult(*(farray_ptr + kj), phs_tbl[ji + 1]));

					tmp1 = round32(ftmp_real);
					tmp2 = round32(ftmp_imag);

					*(farray_ptr + kj) = sub(*(farray_ptr + k), tmp1);
					*(farray_ptr + kj + 1) = sub(*(farray_ptr + k + 1), tmp2);
					*(farray_ptr + k) = add(*(farray_ptr + k), tmp1);
					*(farray_ptr + k + 1) = add(*(farray_ptr + k + 1), tmp2);
				}
			}
		}
	}

}								/* end of c_fft () */


