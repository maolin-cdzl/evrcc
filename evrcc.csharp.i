%module evrcc
%include <windows.i>
%include <csharp/typemaps.i>
%include <csharp/arrays_csharp.i>

%{
#include "evrcc.h"
%}

%apply unsigned char { uint8_t }
%apply signed char { int8_t }
%apply unsigned short { uint16_t }
%apply signed short { int16_t }
%apply unsigned int { size_t }

%apply unsigned char OUTPUT[] { uint8_t* }
%apply unsigned char INPUT[] { const uint8_t* }
%apply signed short OUTPUT[] { int16_t* }
%apply signed short INPUT[] { const int16_t* }

%apply void *VOID_INT_PTR { void* }


%include "evrcc.h"
