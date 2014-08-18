
CCTARGET=./libdsp40.a
CC= gcc
CCFLAGS=-Wall -O3
CODER_INC_DIR=../include
CCINCDIR=-I.
CCOBJS=\
	basic_op40.o

CCINCS=

.c.o:
	${CC} ${CCFLAGS} ${CCINCDIR} -c $*.c

${CCTARGET}: ${CCOBJS}
	ar rv ${CCTARGET} ${CCOBJS}
	ranlib ${CCTARGET}

${CCOBJS}: ${CCINCS}

clean:
	rm -f *.o
clobber:
	rm -f *.o ${CCTARGET}

basic_op40.o: basic_op40.c
