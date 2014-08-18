CMAKE_MINIMUM_REQUIRED(VERSION 2.6)
project(evrcc)

#file(GLOB_RECURSE EVRCC_HEADER "*.h")



set(DSP_MATH_DIR dspmath)
set(DSP_MATH_SRC
	${DSP_MATH_DIR}/mathevrc.c 
	${DSP_MATH_DIR}/mathadv.c
	${DSP_MATH_DIR}/ehwutl.c
	${DSP_MATH_DIR}/globdefs.c
	${DSP_MATH_DIR}/mathdp31.c)

set(CODE_DIR code)
set(CODE_SRC 
	${CODE_DIR}/acb_ex.c
	${CODE_DIR}/acelp_pf.c
	${CODE_DIR}/apf.c
	${CODE_DIR}/auto.c
	${CODE_DIR}/a2lsp.c
	${CODE_DIR}/bitpack.c
	${CODE_DIR}/bitupack.c
	${CODE_DIR}/bl_intrp.c
	${CODE_DIR}/bqiir.c
	${CODE_DIR}/c3_10pf.c
	${CODE_DIR}/c8_35pf.c
	${CODE_DIR}/comacb.c
	${CODE_DIR}/convh.c
	${CODE_DIR}/cshift.c
	${CODE_DIR}/d3_10pf.c
	${CODE_DIR}/d8_35pf.c
	${CODE_DIR}/decode.c
	${CODE_DIR}/d_fer.c
    ${CODE_DIR}/d_no_fer.c
    ${CODE_DIR}/d_rate_1.c
	${CODE_DIR}/durbin.c
	${CODE_DIR}/encode.c
	${CODE_DIR}/fcbgq.c
	${CODE_DIR}/fer.c
	${CODE_DIR}/filter.c
	${CODE_DIR}/fndppf.c
	${CODE_DIR}/getext1k.c
	${CODE_DIR}/getgain.c
	${CODE_DIR}/getres.c
	${CODE_DIR}/impulser.c
	${CODE_DIR}/interpol.c
	${CODE_DIR}/intr_cos.c
    ${CODE_DIR}/inv_sqrt.c
	${CODE_DIR}/lpcana.c
	${CODE_DIR}/lspmaq.c
	${CODE_DIR}/lsp2a.c
	${CODE_DIR}/maxeloc.c
	${CODE_DIR}/mdfyorig.c
	${CODE_DIR}/mod.c
	${CODE_DIR}/ns127.c
	${CODE_DIR}/pit_shrp.c
	${CODE_DIR}/pktoav.c
	${CODE_DIR}/pre_enc.c
	${CODE_DIR}/putacbc.c
	${CODE_DIR}/r_fft.c
	${CODE_DIR}/rda.c
	${CODE_DIR}/rom.c
	${CODE_DIR}/synfltr.c
	${CODE_DIR}/weight.c
	${CODE_DIR}/w2res.c
	${CODE_DIR}/zeroinpt.c
	${CODE_DIR}/globs.c
	${CODE_DIR}/e_globs.c
	${CODE_DIR}/d_globs.c
	)

set(EVRCC_SRC ${DSP_MATH_SRC} ${CODE_SRC} evrcc.c evrcpacket.c)

if( NOT WIN32)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fvisibility=hidden -g")
set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} -g")
endif()

include_directories(include ${CODE_DIR} ${DSP_MATH_DIR})

add_library(evrcc SHARED ${EVRCC_SRC} ${EVRCC_HEADER})
install(TARGETS evrcc DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)

if( NOT WIN32)
target_link_libraries(evrcc m)
endif()

add_executable(evrc_codec evrc_codec.cpp)
target_link_libraries(evrc_codec evrcc)

if( NOT WIN32)
target_link_libraries(evrc_codec m tcmalloc_and_profiler) 
endif()

install(TARGETS evrc_codec DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)

#add_symbols(evrcc)
