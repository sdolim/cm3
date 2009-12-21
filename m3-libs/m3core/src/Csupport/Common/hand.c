/* Copyright (C) 1992, Digital Equipment Corporation        */
/* All rights reserved.                                     */
/* See the file COPYRIGHT for a full description.           */
/*                                                          */
/* Last modified on Thu Feb  1 09:36:52 PST 1996 by heydon  */
/*      modified on Tue Jan 10 15:48:28 PST 1995 by kalsow  */
/*      modified on Tue Feb 11 15:18:40 PST 1992 by muller  */

#include <limits.h>
#include <string.h>

#ifdef __cplusplus
extern "C"
{           
#endif

#if !defined(_MSC_VER) && !defined(__cdecl)
#define __cdecl /* nothing */
#endif

typedef unsigned char uchar;
typedef signed char schar;
typedef unsigned short ushort;
typedef unsigned int uint;
typedef unsigned long ulong;

#if UCHAR_MAX == 0xffffffff
typedef unsigned char uint32;
typedef signed char int32;
#elif USHRT_MAX == 0xffffffff
typedef ushort uint32;
typedef short int32;
#elif UINT_MAX == 0xffffffff
typedef uint uint32;
typedef int int32;
#elif ULONG_MAX == 0xffffffff
typedef ulong uint32;
typedef long int32;
#else
#error no 32 bit integer type
#endif

#ifdef _MSC_VER
#pragma warning(disable:4131) /* old style */
    #if _MSC_VER < 900
        #error __int64 support is required.
        /* avoid cascade */
        typedef long int64;
        typedef ulong uint64;
    #else
        typedef __int64 int64;
        typedef unsigned __int64 uint64;
    #endif
#else
    typedef long long int64;
    typedef unsigned long long uint64;
#endif

#ifdef __cplusplus
#define ANSI(x) x
#define KR(x)
#else
#define ANSI(x)
#define KR(x) x
#endif

long __cdecl m3_div
    ANSI((      long b, long a))
      KR((b, a) long b; long a;)
{
  register long c;
  if ((a == 0) && (b != 0))  {  c = 0;
  } else if (a > 0)  {  c = (b >= 0) ? (a) / (b) : -1 - (a-1) / (-b);
  } else /* a < 0 */ {  c = (b >= 0) ? -1 - (-1-a) / (b) : (-a) / (-b);
  }
  return c;
}

int64 __cdecl m3_divL
    ANSI((      int64 b, int64 a))
      KR((b, a) int64 b; int64 a;)
{
  register int64 c;
  if ((a == 0) && (b != 0))  {  c = 0;
  } else if (a > 0)  {  c = (b >= 0) ? (a) / (b) : -1 - (a-1) / (-b);
  } else /* a < 0 */ {  c = (b >= 0) ? -1 - (-1-a) / (b) : (-a) / (-b);
  }
  return c;
}

long __cdecl m3_mod
    ANSI((      long b, long a))
      KR((b, a) long b; long a;)
{
  register long c;
  if ((a == 0) && (b != 0)) {  c = 0;
  } else if (a > 0)  {  c = (b >= 0) ? a % b : b + 1 + (a-1) % (-b);
  } else /* a < 0 */ {  c = (b >= 0) ? b - 1 - (-1-a) % (b) : - ((-a) % (-b));
  }
  return c;
}

int64 __cdecl m3_modL
    ANSI((      int64 b, int64 a))
      KR((b, a) int64 b; int64 a;)
{
  register int64 c;
  if ((a == 0) && (b != 0)) {  c = 0;
  } else if (a > 0)  {  c = (b >= 0) ? a % b : b + 1 + (a-1) % (-b);
  } else /* a < 0 */ {  c = (b >= 0) ? b - 1 - (-1-a) % (b) : - ((-a) % (-b));
  }
  return c;
}

#define SET_GRAIN (sizeof (long) * 8)

long __cdecl set_member
    ANSI((          long elt, ulong* set))
      KR((elt, set) long elt; ulong* set;)
{
  register long word = elt / SET_GRAIN;
  register long bit  = elt % SET_GRAIN;
  return (set[word] & (1UL << bit)) != 0;
}

void __cdecl set_union
    ANSI((                 long n_bits, ulong* c, ulong* b, ulong* a))
      KR((n_bits, c, b, a) long n_bits; ulong* c; ulong* b; ulong* a;)
{
  register long n_words = n_bits / SET_GRAIN;
  register long i;
  for (i = 0; i < n_words; i++) {
    a[i] = b[i] | c[i];
  }
}

void __cdecl set_intersection
    ANSI((                 long n_bits, ulong* c, ulong* b, ulong* a))
      KR((n_bits, c, b, a) long n_bits; ulong* c; ulong* b; ulong* a;)
{
  register long n_words = n_bits / SET_GRAIN;
  register long i;
  for (i = 0; i < n_words; i++) {
    a[i] = b[i] & c[i];
  }
}

void __cdecl set_difference
    ANSI((                 long n_bits, ulong* c, ulong* b, ulong* a))
      KR((n_bits, c, b, a) long n_bits; ulong* c; ulong* b; ulong* a;)
{
  register long n_words = n_bits / SET_GRAIN;
  register long i;
  for (i = 0; i < n_words; i++) {
    a[i] = b[i] & (~ c[i]);
  }
}

void __cdecl set_sym_difference
    ANSI((                 long n_bits, ulong* c, ulong* b, ulong* a))
      KR((n_bits, c, b, a) long n_bits; ulong* c; ulong* b; ulong* a;)
{
  register long n_words = n_bits / SET_GRAIN;
  register long i;
  for (i = 0; i < n_words; i++) {
    a[i] = b[i] ^ c[i];
  }
}

long __cdecl set_eq
    ANSI((              long n_bits, ulong* b, ulong* a))
      KR((n_bits, b, a) long n_bits; ulong* b; ulong* a;)
/* The integrated back end calls memcmp directly; the gcc
   backend does not. */
{
  return (memcmp(a, b, n_bits / 8) == 0);
}

long __cdecl set_ne
    ANSI((              long n_bits, ulong* b, ulong* a))
      KR((n_bits, b, a) long n_bits; ulong* b; ulong* a;)
/* The integrated back end calls memcmp directly; the gcc
   backend does not. */
{
  return (memcmp(a, b, n_bits / 8) != 0);
}

long __cdecl set_ge
    ANSI((              long n_bits, ulong* b, ulong* a))
      KR((n_bits, b, a) long n_bits; ulong* b; ulong* a;)
{
  register long n_words = n_bits / SET_GRAIN;
  register long i;
  for (i = 0; i < n_words; i++) {
    if ((~ a[i]) & b[i]) return 0;
  }
  return 1;
}

long __cdecl set_gt
    ANSI((              long n_bits, ulong* b, ulong* a))
      KR((n_bits, b, a) long n_bits; ulong* b; ulong* a;)
{
  register long n_words = n_bits / SET_GRAIN;
  register long i;
  register long eq = 0;
  for (i = 0; i < n_words; i++) {
    if ((~ a[i]) & b[i]) return 0;
    eq |=  (a[i] ^ b[i]);
  }
  return (eq != 0);
}

long __cdecl set_le
    ANSI((              long n_bits, ulong* b, ulong* a))
      KR((n_bits, b, a) long n_bits; ulong* b; ulong* a;)
{
  register long n_words = n_bits / SET_GRAIN;
  register long i;
  for (i = 0; i < n_words; i++) {
    if (a[i] & (~ b[i])) return 0;
  }
  return 1;
}

long __cdecl set_lt
    ANSI((              long n_bits, ulong* b, ulong* a))
      KR((n_bits, b, a) long n_bits; ulong* b; ulong* a;)
{
  register long n_words = n_bits / SET_GRAIN;
  register long i;
  register long eq = 0;
  for (i = 0; i < n_words; i++) {
    if (a[i] & (~ b[i])) return 0;
    eq |= (a[i] ^ b[i]);
  }
  return (eq != 0);
}

/* _lowbits[i] = bits{(i-1)..0} for 32-bit integer masks */
#ifdef __cplusplus
extern
#endif
const uint _lowbits [33] = {
  0x0,
  0x1, 0x3, 0x7, 0xf,
  0x1f, 0x3f, 0x7f, 0xff,
  0x1ff, 0x3ff, 0x7ff, 0xfff,
  0x1fff, 0x3fff, 0x7fff, 0xffff,
  0x1ffff, 0x3ffff, 0x7ffff, 0xfffff,
  0x1fffff, 0x3fffff, 0x7fffff, 0xffffff,
  0x1ffffff, 0x3ffffff, 0x7ffffff, 0xfffffff,
  0x1fffffff, 0x3fffffff, 0x7fffffff, 0xffffffff };

/* _highbits[i] = bits{31..i} for 32-bit integer masks */
#ifdef __cplusplus
extern
#endif
const uint _highbits [33] = {
  0xffffffff, 0xfffffffe, 0xfffffffc, 0xfffffff8,
  0xfffffff0, 0xffffffe0, 0xffffffc0, 0xffffff80,
  0xffffff00, 0xfffffe00, 0xfffffc00, 0xfffff800,
  0xfffff000, 0xffffe000, 0xffffc000, 0xffff8000,
  0xffff0000, 0xfffe0000, 0xfffc0000, 0xfff80000,
  0xfff00000, 0xffe00000, 0xffc00000, 0xff800000,
  0xff000000, 0xfe000000, 0xfc000000, 0xf8000000,
  0xf0000000, 0xe0000000, 0xc0000000, 0x80000000,
  0x0 };

#define LOW_BITS_ADJUST 0

#if ULONG_MAX == 0xffffffff

#if 1 /* UINT == 0xffffffff */

/* If possible, combine tables.
   If unsigned long and unsigned int are both 32 bit integers, then
    LoBits and _lowbits are the same except that _lowbits has 0 inserted in the first entry,
    HiBits and _highbits are the same except _highbits has 0 added at the end.
	That is, LoBits can be replaced with _lowbits if you add one to the index.
	HiBits can be replaced by _highbits directly.

  Now, a) it does not matter if unsigned int is exactly 32 bits, it need only be
  at least 32 bits b) it can't be larger than unsigned long anyway. So drop the condition
  and always combine these tables, for 32 bit unsigned long.
*/
#undef LOW_BITS_ADJUST 
#define LOW_BITS_ADJUST 1
#define LoBits _lowbits
#define HiBits _highbits

#else

static const ulong LoBits[] = {
0x00000001,0x00000003,0x00000007,0x0000000f,
0x0000001f,0x0000003f,0x0000007f,0x000000ff,
0x000001ff,0x000003ff,0x000007ff,0x00000fff,
0x00001fff,0x00003fff,0x00007fff,0x0000ffff,
0x0001ffff,0x0003ffff,0x0007ffff,0x000fffff,
0x001fffff,0x003fffff,0x007fffff,0x00ffffff,
0x01ffffff,0x03ffffff,0x07ffffff,0x0fffffff,
0x1fffffff,0x3fffffff,0x7fffffff,0xffffffff
};

static const ulong HiBits[] = {
0xffffffff,0xfffffffe,0xfffffffc,0xfffffff8,
0xfffffff0,0xffffffe0,0xffffffc0,0xffffff80,
0xffffff00,0xfffffe00,0xfffffc00,0xfffff800,
0xfffff000,0xffffe000,0xffffc000,0xffff8000,
0xffff0000,0xfffe0000,0xfffc0000,0xfff80000,
0xfff00000,0xffe00000,0xffc00000,0xff800000,
0xff000000,0xfe000000,0xfc000000,0xf8000000,
0xf0000000,0xe0000000,0xc0000000,0x80000000
};

#endif

#elif ULONG_MAX == 0xffffffffffffffff

static const ulong LoBits[] = {
0x0000000000000001,0x0000000000000003,0x0000000000000007,0x000000000000000f,
0x000000000000001f,0x000000000000003f,0x000000000000007f,0x00000000000000ff,
0x00000000000001ff,0x00000000000003ff,0x00000000000007ff,0x0000000000000fff,
0x0000000000001fff,0x0000000000003fff,0x0000000000007fff,0x000000000000ffff,
0x000000000001ffff,0x000000000003ffff,0x000000000007ffff,0x00000000000fffff,
0x00000000001fffff,0x00000000003fffff,0x00000000007fffff,0x0000000000ffffff,
0x0000000001ffffff,0x0000000003ffffff,0x0000000007ffffff,0x000000000fffffff,
0x000000001fffffff,0x000000003fffffff,0x000000007fffffff,0x00000000ffffffff,
0x00000001ffffffff,0x00000003ffffffff,0x00000007ffffffff,0x0000000fffffffff,
0x0000001fffffffff,0x0000003fffffffff,0x0000007fffffffff,0x000000ffffffffff,
0x000001ffffffffff,0x000003ffffffffff,0x000007ffffffffff,0x00000fffffffffff,
0x00001fffffffffff,0x00003fffffffffff,0x00007fffffffffff,0x0000ffffffffffff,
0x0001ffffffffffff,0x0003ffffffffffff,0x0007ffffffffffff,0x000fffffffffffff,
0x001fffffffffffff,0x003fffffffffffff,0x007fffffffffffff,0x00ffffffffffffff,
0x01ffffffffffffff,0x03ffffffffffffff,0x07ffffffffffffff,0x0fffffffffffffff,
0x1fffffffffffffff,0x3fffffffffffffff,0x7fffffffffffffff,0xffffffffffffffff
};

static const ulong HiBits[] = {
0xffffffffffffffff,0xfffffffffffffffe,0xfffffffffffffffc,0xfffffffffffffff8,
0xfffffffffffffff0,0xffffffffffffffe0,0xffffffffffffffc0,0xffffffffffffff80,
0xffffffffffffff00,0xfffffffffffffe00,0xfffffffffffffc00,0xfffffffffffff800,
0xfffffffffffff000,0xffffffffffffe000,0xffffffffffffc000,0xffffffffffff8000,
0xffffffffffff0000,0xfffffffffffe0000,0xfffffffffffc0000,0xfffffffffff80000,
0xfffffffffff00000,0xffffffffffe00000,0xffffffffffc00000,0xffffffffff800000,
0xffffffffff000000,0xfffffffffe000000,0xfffffffffc000000,0xfffffffff8000000,
0xfffffffff0000000,0xffffffffe0000000,0xffffffffc0000000,0xffffffff80000000,
0xffffffff00000000,0xfffffffe00000000,0xfffffffc00000000,0xfffffff800000000,
0xfffffff000000000,0xffffffe000000000,0xffffffc000000000,0xffffff8000000000,
0xffffff0000000000,0xfffffe0000000000,0xfffffc0000000000,0xfffff80000000000,
0xfffff00000000000,0xffffe00000000000,0xffffc00000000000,0xffff800000000000,
0xffff000000000000,0xfffe000000000000,0xfffc000000000000,0xfff8000000000000,
0xfff0000000000000,0xffe0000000000000,0xffc0000000000000,0xff80000000000000,
0xff00000000000000,0xfe00000000000000,0xfc00000000000000,0xf800000000000000,
0xf000000000000000,0xe000000000000000,0xc000000000000000,0x8000000000000000
};

#else
#error unknown size of ulong
#endif

void __cdecl set_range
    ANSI((       long b, long a, ulong* s))
    KR((b, a, s) long b; long a; ulong* s;)
{
  if (b < a) {
      /* no bits to set */
  } else {
      long a_word = a / SET_GRAIN;
      long a_bit  = a % SET_GRAIN;
      long b_word = b / SET_GRAIN;
      long b_bit  = b % SET_GRAIN;
      long i;

      if (a_word == b_word) {
          s [a_word] |= (HiBits [a_bit] & LoBits [b_bit + LOW_BITS_ADJUST]);
      } else {
          s [a_word] |= HiBits [a_bit];
          for (i = a_word+1; i < b_word; i++)  s[i] = ~0UL;
          s [b_word] |= LoBits [b_bit + LOW_BITS_ADJUST];
      }
    }
}

void __cdecl set_singleton
    ANSI((      long a, ulong* s))
      KR((a, s) long a; ulong* s;)
{
  long a_word = a / SET_GRAIN;
  long a_bit  = a % SET_GRAIN;
  s[a_word] |= (1UL << a_bit);
}

/************************************************************************

#include <stdio.h>

static _crash (msg)
char *msg;
{
  fprintf (stderr, "\n**** UNIMPLEMENTED: %s ***\n", msg);
  fflush (stderr);

  *((long*)0L) = 1L;    /  * bad memory reference => crash! *  /
  while (1L);           /  * if not, loop forever           *  /
}

_xx0 () { _crash ("_xx0 (runtime fault)"); }

**************************************************************************/

#if 0 /* change this to 1 and compile and run the program to generate the above tables */

#include <assert.h>
#include <limits.h>
typedef unsigned long ulong;

void BuildTables ()
{
	unsigned i;
	ulong LoBits[SET_GRAIN] = { 0 };  /* LoBits32[i] = SET { 0..i } */
	ulong HiBits[SET_GRAIN] = { 0 };  /* HiBits32[i] = SET { i..31 } */
	uint32 LoBits32[32] = { 0 };  /* LoBits32[i] = SET { 0..i } */
	uint32 HiBits32[32] = { 0 };  /* HiBits32[i] = SET { i..31 } */
	uint64 LoBits64[64] = { 0 };  /* LoBits64[i] = SET { 0..i } */
	uint64 HiBits64[64] = { 0 };  /* HiBits64[i] = SET { i..63 } */

	{
		uint32 j;

		/* LoBits [i] = SET { 0..i } */
		j = 0;  /* == SET { } */
		for (i = 0; i != 32; i++) {
			j = (j << 1) + 1;
			LoBits32[i] = j;
		}

		/* HiBits [i] = SET { i..GRAIN-1 } */
		j = ~ (uint32) 0; /* == SET { 0..GRAIN-1 } */
		for (i = 0; i != 32; i++) {
			HiBits32[i] = j;
			j = (j << 1);
		}
	}

	{
		uint64 j;

		/* LoBits [i] = SET { 0..i } */
		j = 0;  /* == SET { } */
		for (i = 0; i != 64; i++) {
			j = (j << 1) + 1;
			LoBits64[i] = j;
		}

		/* HiBits [i] = SET { i..GRAIN-1 } */
		j = ~ (uint64) 0; /* == SET { 0..GRAIN-1 } */
		for (i = 0; i != 64; i++) {
			HiBits64[i] = j;
			j = (j << 1);
		}
	}

	{
		ulong j;

		/* LoBits [i] = SET { 0..i } */
		j = 0;  /* == SET { } */
		for (i = 0; i != SET_GRAIN; i++) {
			j = (j << 1) + 1;
			LoBits[i] = j;
		}

		/* HiBits [i] = SET { i..GRAIN-1 } */
		j = ~ (ulong) 0; /* == SET { 0..GRAIN-1 } */
		for (i = 0; i != SET_GRAIN; i++) {
			HiBits[i] = j;
			j = (j << 1);
		}

		for (i = 0; i != SET_GRAIN; i++) {
#ifdef _WIN32
			assert(LoBits[i] == LoBits32[i]);
			assert(HiBits[i] == HiBits32[i]);
			assert(LoBits[i] == _lowbits[i + 1]);
			assert(HiBits[i] == _highbits[i]);
#else
			assert((LoBits[i] == LoBits32[i]) || (LoBits[i] == LoBits64[i]));
			assert((HiBits[i] == HiBits32[i]) || (HiBits[i] == HiBits64[i]));
#endif
		}
	}

	printf("#include <limits.h>\n\n");

	printf("typedef unsigned long ulong;\n\n");

	printf("#if ULONG_MAX == 0xffffffff\n\n");

	printf("static const ulong LoBits[] = {\n");

	for (i = 0; i != 32; i++)
		printf("0x%08lx%s%s", (ulong) LoBits32[i], &","[i == 31], &"\n"[!!((i + 1) % 4)]);

	printf("};\n\nstatic const ulong HiBits[] = {\n");

	for (i = 0; i != 32; i++)
		printf("0x%08lx%s%s", (ulong) HiBits32[i], &","[i == 31], &"\n"[!!((i + 1) % 4)]);

	printf("};\n\n");
	printf("#elif ULONG_MAX == 0xffffffffffffffff\n\n");

	printf("static const ulong LoBits[] = {\n");

	for (i = 0; i != 64; i++)
		printf("0x%08lx%08lx%s%s", (ulong) (LoBits64[i] >> 32), (ulong) LoBits64[i], &","[i == 63], &"\n"[!!((i + 1) % 4)]);

	printf("};\n\nstatic const ulong HiBits[] = {\n");

	for (i = 0; i != 64; i++)
		printf("0x%08lx%08lx%s%s", (ulong) (HiBits64[i] >> 32), (ulong) HiBits64[i], &","[i == 63], &"\n"[!!((i + 1) % 4)]);

	printf("\n#else\n#error unknown size of ulong\n#endif\n\n");
}

#include <assert.h>

int main()
{
    BuildTables();
    return 0;
}

#endif

#ifdef __cplusplus
} /* extern "C" */
#endif
