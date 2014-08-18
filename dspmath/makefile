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
CCTARGET=libdmath.a
CC=gcc
CCFLAGS=-O3

#Uncomment the following line to use alternate double precision multiplies
#CCAUXFLAGS=-DUSE_ALT_DP31
#& comment the folloing line out
CCAUXFLAGS=

#CCFLAGS=-O4
CCOBJS= mathevrc.o \
	mathadv.o\
	ehwutl.o\
	globdefs.o\
	mathdp31.o

.c.o:
	${CC} ${CCFLAGS} ${CCAUXFLAGS} -c $*.c

${CCTARGET}: ${CCOBJS}
	ar cr ${CCTARGET} $(CCOBJS)
	ranlib ${CCTARGET}

clean:
	rm -f *.o ${CCTARGET} core
clobber:
	rm -f *.o ${CCTARGET} core
