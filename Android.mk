#LOCAL_PATH := $(shell pwd)/jni
LOCAL_PATH := $(call my-dir)

MY_ARMV7_CFLAGS := -mcpu=cortex-a8 -mfpu=neon -ftree-vectorize -mfloat-abi=softfp -ffast-math -fsingle-precision-constant -D__ARM_ARCH__=7

INCLUDE_DIR := $(LOCAL_PATH)/include
DSP_ARM_DIR := $(LOCAL_PATH)/dsp_arm
DSP_ARM_SRC := \
	dsp_arm/abs_s.s \
	dsp_arm/dsp_math.c \
	dsp_arm/l_add.s \
	dsp_arm/l_sub.s	\
	dsp_arm/l_mac.s	\
	dsp_arm/l_msu.s \
	dsp_arm/l_shr.s \
	dsp_arm/l_shl.s  \
	dsp_arm/divide_s.s \
	dsp_arm/l_abs.s \
	dsp_arm/l_mult.s  \
	dsp_arm/mac_r.s \
	dsp_arm/sub.s \
	dsp_arm/add.s \
	dsp_arm/mult_r.s \
   	dsp_arm/negate.s \
   	dsp_arm/norm_s.s \
	dsp_arm/shr_r.s \
	dsp_arm/shift_r.s \
	dsp_arm/msu_r.s \
	dsp_arm/l_negate.s \
	dsp_arm/l_shr_r.s \
	dsp_arm/l_shift_r.s \
	dsp_arm/norm_l.s \
	dsp_arm/mult.s \
	dsp_arm/round32.s \
	dsp_arm/shl.s \
	dsp_arm/shr.s \
	dsp_arm/saturate.s \
	dsp_arm/l_mpy_ls.s \
	dsp_arm/l_mpy_ll.s \
	dsp_arm/div_32.s \
	dsp_arm/fft_tabs.s \
	dsp_arm/c_fft.s.neon \
	dsp_arm/test.s.neon \


DSP_MATH_DIR := $(LOCAL_PATH)/dspmath
DSP_MATH_SRC := \
	dspmath/mathadv.c\
	dspmath/ehwutl.c\
	dspmath/globdefs.c

CODE_DIR := $(LOCAL_PATH)/code
CODE_SRC := \
	code/globs.c\
	code/d_globs.c\
	code/e_globs.c\
	code/acb_ex.c\
	code/acelp_pf.c\
	code/apf.c\
	code/auto.c\
	code/a2lsp.c\
	code/bitpack.c\
	code/bitupack.c\
	code/bl_intrp.c\
	code/bqiir.c\
	code/c3_10pf.c\
	code/c8_35pf.c\
	code/comacb.c\
	code/convh.c\
	code/cshift.c\
	code/d3_10pf.c\
	code/d8_35pf.c\
	code/decode.c\
	code/d_fer.c\
    code/d_no_fer.c\
    code/d_rate_1.c\
	code/durbin.c\
	code/encode.c\
	code/fcbgq.c\
	code/fer.c\
	code/filter.c\
	code/fndppf.c\
	code/getext1k.c\
	code/getgain.c\
	code/getres.c\
	code/impulser.c\
	code/interpol.c\
	code/intr_cos.c\
    code/inv_sqrt.c\
	code/lpcana.c\
	code/lspmaq.c\
	code/lsp2a.c\
	code/maxeloc.c\
	code/mdfyorig.c\
	code/mod.c\
	code/ns127.c\
	code/pit_shrp.c\
	code/pktoav.c\
	code/pre_enc.c\
	code/putacbc.c\
	code/r_fft.c\
	code/rda.c\
	code/rom.c\
	code/synfltr.c\
	code/weight.c\
	code/w2res.c\
	code/zeroinpt.c
#	main.c\

include $(CLEAR_VARS)
LOCAL_MODULE := evrcc 
LOCAL_ARM_MODE := arm
LOCAL_SRC_FILES :=  $(DSP_MATH_SRC) $(CODE_SRC) evrcc.c evrcpacket.c
LOCAL_C_INCLUDES += $(INCLUDE_DIR) $(CODE_DIR) $(DSP_MATH_DIR)

ifeq ($(TARGET_ARCH_ABI),"armeabi-v7a")
	LOCAL_C_INCLUDES += $(DSP_ARM_DIR)
	LOCAL_SRC_FILES += $(DSP_MATH_DIR)/mathevrc.c $(DSP_MATH_DIR)/mathdp31.c
	LOCAL_CFLAGS += $(MY_ARMV7_CFLAGS)
else
	LOCAL_SRC_FILES += $(DSP_ARM_SRC) 
#LOCAL_ARM_NEON := true   
endif

LOCAL_CFLAGS += -std=c99 -O3
include $(BUILD_SHARED_LIBRARY)

#include $(CLEAR_VARS)
#LOCAL_MODULE := asmtest
#LOCAL_ARM_MODE := arm
#LOCAL_CFLAGS += -std=c99 -O3 $(MY_ARMV7_CFLAGS)
#LOCAL_C_INCLUDES += $(INCLUDE_DIR) $(CODE_DIR) $(DSP_MATH_IR) $(DSP_ARM_DIR)
#LOCAL_SRC_FILES := $(DSP_ARM_SRC) dsp_foo/mathevrc.c asmtest.c
#include $(BUILD_EXECUTABLE)


#include $(CLEAR_VARS)
#LOCAL_MODULE := evrcodec
#LOCAL_ARM_MODE := arm
#LOCAL_SRC_FILES :=  test.cpp

#LOCAL_CFLAGS += -std=c99 -O3
#LOCAL_C_INCLUDES += $(INCLUDE_DIR) $(CODE_DIR) $(DSP_MATH_IR) $(DSP_ARM_DIR)

#LOCAL_CPPFLAGS := -std=gnu++11 -fno-rtti -fno-exceptions 
#LOCAL_SHARED_LIBRARIES += libevrcc
#include $(BUILD_EXECUTABLE)


