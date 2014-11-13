#ifndef _EVRC_CODEC_H_
#define _EVRC_CODEC_H_

#include <stddef.h>

#if defined _WIN32
#include "stdint_win32.h"
#else
#include <stdint.h>
#endif

#include "evrcc/evrc_export.h"

#ifdef __cplusplus
extern "C" {
#endif

static const int	EVRC_CODEC_ERROR		= -1;
static const int	EVRC_CODEC_BUFFER_SMALL	= -2;

DLL_PUBLIC int evrc_get_stream_frame_count(const uint8_t* bits,size_t bits_bytes);
DLL_PUBLIC int evrc_packet_to_stream(const uint8_t* packet,size_t packet_size,uint8_t* stream,size_t stream_size);
DLL_PUBLIC int evrc_stream_to_packet(const uint8_t* stream,size_t frame_count,uint8_t* packet,size_t packet_size);


// encoder interface
DLL_PUBLIC void* evrc_encoder_init(int16_t min_rate,int16_t max_rate,int16_t noise_suppression);
DLL_PUBLIC void evrc_encoder_uninit(void* c);
DLL_PUBLIC int evrc_encoder_encode_raw(void* c,int16_t* pcm_frame,uint8_t* bits);
DLL_PUBLIC int evrc_encoder_encode_to_packet(void* c,int16_t* speech,size_t speech_samples,uint8_t* packet,size_t packet_max_bytes);
DLL_PUBLIC int evrc_encoder_encode_to_stream(void* c,int16_t* speech,size_t speech_samples,uint8_t* bits,size_t bits_max_bytes);
DLL_PUBLIC int evrc_encoder_max_encode(void* c,size_t speech_samples);



// decoder interface
DLL_PUBLIC void* evrc_decoder_init();
DLL_PUBLIC void evrc_decoder_uninit(void* c);
DLL_PUBLIC int evrc_decoder_decode_frame_raw(void* c, const uint8_t* bits,size_t bits_bytes,int16_t* speech);
DLL_PUBLIC int evrc_decoder_decode_from_packet(void* c,const uint8_t* packet,size_t packet_bytes,int16_t* speech,size_t speech_max_samples);

DLL_PUBLIC int evrc_decoder_decode_from_stream(void* c,const uint8_t* stream,size_t stream_bytes,int16_t* speech,size_t speech_max_samples);

DLL_PUBLIC int evrc_decoder_decode_stream_frame(void* c, const uint8_t* bits,size_t bits_bytes,int16_t* speech);
DLL_PUBLIC int evrc_decoder_stream_max_sample(const uint8_t* bits,size_t bits_bytes);
DLL_PUBLIC int evrc_decoder_stream_frame_bytes(const uint8_t* bits);
DLL_PUBLIC int evrc_decoder_is_silence_stream_frame(const uint8_t* bits);


#ifdef __cplusplus
}
#endif


#endif

