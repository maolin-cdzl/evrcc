/*

int L_saturate(double dVar1) {
	if( dVar1 > (double)0x7FFFFFFF ) {
		return 0x7FFFFFFF;
	} else if( dVar1 < (double)0x80000000){
		return (int)0x80000000;
	} else {
		return (int)dVar1;
	}
}

int L_deposit_l(short var1) {
	return (int)var1;
}

int L_deposit_h(short var1) {
	int lvar;
    lvar = (int ) var1 << 16;
	return lvar;
}

short extract_l(short L_var1) {
	return (short) (0x0000ffffL & L_var1);
}

short extract_h(int L_var1) {
	return (short) (0x0000ffffL & (L_var1 >> 16));
}
*/

