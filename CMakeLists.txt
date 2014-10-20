CMAKE_MINIMUM_REQUIRED(VERSION 2.8.11)
project(evrcc)

include(CMakeStdOpt)

set(DSP_MATH_DIR dspmath)

if( ANDROID )
	enable_language(ASM)
	set(CMAKE_ASM_FLAGS "-marm -march=armv7-a -mcpu=generic-armv7-a -mthumb-interwork -mlittle-endian -mfpu=neon -mfloat-abi=softfp")
	set(DSP_MATH_SRC
		dsp_arm/abs_s.s 
		dsp_arm/dsp_math.c 
		dsp_arm/l_add.s 
		dsp_arm/l_sub.s	
		dsp_arm/l_mac.s	
		dsp_arm/l_msu.s 
		dsp_arm/l_shr.s 
		dsp_arm/l_shl.s  
		dsp_arm/divide_s.s 
		dsp_arm/l_abs.s 
		dsp_arm/l_mult.s  
		dsp_arm/mac_r.s 
		dsp_arm/sub.s 
		dsp_arm/add.s 
		dsp_arm/mult_r.s 
		dsp_arm/negate.s 
		dsp_arm/norm_s.s 
		dsp_arm/shr_r.s 
		dsp_arm/shift_r.s 
		dsp_arm/msu_r.s 
		dsp_arm/l_negate.s 
		dsp_arm/l_shr_r.s 
		dsp_arm/l_shift_r.s 
		dsp_arm/norm_l.s 
		dsp_arm/mult.s 
		dsp_arm/round32.s 
		dsp_arm/shl.s 
		dsp_arm/shr.s 
		dsp_arm/saturate.s 
		dsp_arm/l_mpy_ls.s 
		dsp_arm/l_mpy_ll.s 
		dsp_arm/div_32.s 
		dsp_arm/fft_tabs.s 
		dsp_arm/c_fft.s
		dspmath/mathadv.c
		dspmath/ehwutl.c
		dspmath/globdefs.c
	)
else()
	set(DSP_MATH_SRC
		${DSP_MATH_DIR}/mathevrc.c 
		${DSP_MATH_DIR}/mathadv.c
		${DSP_MATH_DIR}/ehwutl.c
		${DSP_MATH_DIR}/globdefs.c
		${DSP_MATH_DIR}/mathdp31.c)
endif()


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

add_library(evrcc SHARED ${EVRCC_SRC} ${EVRCC_HEADER})
target_compile_options(evrcc PRIVATE "-fvisibility=hidden")
target_include_directories(evrcc 
	PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include
	PRIVATE ${DSP_MATH_DIR}
	PRIVATE ${CODE_DIR}
	)

install(TARGETS evrcc DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)

target_link_libraries(evrcc m)

if( BUILD_CODER )
	add_executable(evrc_codec evrc_codec.cpp)
	target_link_libraries(evrc_codec evrcc)
	target_link_libraries(evrc_codec m tcmalloc_and_profiler) 
	install(TARGETS evrc_codec DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)
endif()

if( HAS_BREAKPAD )
	include(CMakeSymbols)
	add_symbols(evrcc)
endif()
