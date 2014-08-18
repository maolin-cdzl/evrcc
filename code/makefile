#======================================================================*/
#     Enhanced Variable Rate Codec - Bit-Exact C Specification         */
#     Copyright (C) 1997-1998 Telecommunications Industry Association. */
#     All rights reserved.                                             */
#----------------------------------------------------------------------*/
# Note:  Reproduction and use of this software for the design and      */
#     development of North American Wideband CDMA Digital              */
#     Cellular Telephony Standards is authorized by the TIA.           */
#     The TIA does not authorize the use of this software for any      */
#     other purpose.                                                   */
#                                                                      */
#     The availability of this software does not provide any license   */
#     by implication, estoppel, or otherwise under any patent rights   */
#     of TIA member companies or others covering any use of the        */
#     contents herein.                                                 */
#                                                                      */
#     Any copies of this software or derivative works must include     */
#     this and all other proprietary notices.                          */
#======================================================================*/
CC=gcc
CCEXEDIR=../bin
TTYDIR=../ttylib
CCFLAGS=-O3 -Wall
CCINCDIR=-I../include -I../dspmath -I$(TTYDIR) -I../dsp_fx
CCLIBDIR=-L../dspmath -L$(TTYDIR) -L../dsp_fx
CCLIBS=-ltty -ldmath -ldsp40 -lm
CCOBJS=\
	acb_ex.o\
	acelp_pf.o\
	apf.o\
	auto.o\
	a2lsp.o\
	bitpack.o\
	bitupack.o\
	bl_intrp.o\
	bqiir.o\
	c3_10pf.o\
	c8_35pf.o\
	comacb.o\
	convh.o\
	cshift.o\
	d3_10pf.o\
	d8_35pf.o\
	decode.o\
	d_fer.o\
    d_no_fer.o\
    d_rate_1.o\
	durbin.o\
	d_globs.o\
	e_globs.o\
	encode.o\
	fcbgq.o\
	fer.o\
	filter.o\
	fndppf.o\
	getext1k.o\
	getgain.o\
	getres.o\
	globs.o\
	impulser.o\
	interpol.o\
	intr_cos.o\
    inv_sqrt.o\
	lpcana.o\
	lspmaq.o\
	lsp2a.o\
	main.o\
	maxeloc.o\
	mdfyorig.o\
	mod.o\
	ns127.o\
	pit_shrp.o\
	pktoav.o\
	pre_enc.o\
	putacbc.o\
	r_fft.o\
	rda.o\
	rom.o\
	synfltr.o\
	weight.o\
	w2res.o\
	zeroinpt.o

DMATHLIB=../dspmath/libdmath.a

.c.o:
	${CC} ${CCFLAGS} ${CCINCDIR} -c $*.c

${CCEXEDIR}/EvrcFix: ${CCOBJS} ${DMATHLIB} $(TTYDIR)/libtty.a ../dsp_fx/libdsp40.a
	${CC} -o ${CCEXEDIR}/EvrcFix ${CCFLAGS} ${CCLIBDIR} ${CCOBJS} ${CCLIBS}

clean:
	rm -f *.o core
clobber:
	rm -f *.o core ${CCEXEDIR}/EvrcFix ${CCEXEDIR}/EvrcFix.exe

cshift.o: ../include/ansi.h
d_fer.o: ../include/ansi.h
d_no_fer.o: ../include/ansi.h
d_rate_1.o: ../include/ansi.h
fer.o: ../include/ansi.h
d_globs.o: ../include/ansi.h
