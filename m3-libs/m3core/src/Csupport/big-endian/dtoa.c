/* Copyright (C) 1992, Digital Equipment Corporation                         */
/* All rights reserved.                                                      */
/* See the file COPYRIGHT for a full description.                            */

#include "m3core.h"

#ifndef __cplusplus
#define KR_headers
#endif
#define IEEE_MC68k
#undef IEEE_8087

#define MULTIPLE_THREADS
#define ACQUIRE_DTOA_LOCK(n) CConvert__Acquire(n)
#define FREE_DTOA_LOCK(n) CConvert__Release(n)

#if defined(__STDC__) || defined(__cplusplus)

#ifdef __cplusplus
extern "C" {
#endif

void CConvert__Acquire(WORD_T);
void CConvert__Release(WORD_T);

#ifdef __cplusplus
} /* extern C */
#endif

#endif /* STDC || C++ */

#include "dtoa.h"
