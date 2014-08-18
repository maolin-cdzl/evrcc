all:
	make -C dspmath
	make -C dsp_fx
	make -C ttylib
	make -C code

clean:
	make -C dspmath clean
	make -C dsp_fx clean
	make -C ttylib clean
	make -C code clean

clobber:
	make -C dspmath clobber
	make -C dsp_fx clobber
	make -C ttylib clobber
	make -C code clobber
