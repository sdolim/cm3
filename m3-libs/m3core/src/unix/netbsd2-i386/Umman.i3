(* Copyright (C) 1992, Digital Equipment Corporation                         *)
(* All rights reserved.                                                      *)
(* See the file COPYRIGHT for a full description.                            *)
(*                                                                           *)
(* Last modified on Fri Apr 30 14:41:23 PDT 1993 by muller                   *)
(* ow Sat Oct 29 14:10:19 MET 1994 adapted for FreeBSD                       *)
INTERFACE Umman;

FROM Ctypes IMPORT int, void_star;
FROM Utypes IMPORT size_t, off_t;

(*** sys/mman.h ***)

CONST
  PROT_NONE        = 16_0000;
  PROT_READ        = 16_0001;
  PROT_WRITE       = 16_0002;
  PROT_EXEC        = 16_0004;
     
  MAP_FILE         = 16_0000;
  MAP_ANON         = 16_1000;

  MAP_PRIVATE      = 16_0002;
  MAP_SHARED       = 16_0001;
  MAP_COPY         = 16_0004;

  MAP_FIXED        = 16_0010;
  MAP_RENAME       = 16_0020;
  MAP_NORESERVE    = 16_0040;
  MAP_INHERIT      = 16_0080;
  MAP_NOEXTEND     = 16_0100;
  MAP_HASSEMAPHORE = 16_0200;

  MADV_NORMAL      = 0;
  MADV_RANDOM      = 1;
  MADV_SEQUENTIAL  = 2;
  MADV_WILLNEED    = 3;
  MADV_DONTNEED    = 4;
  MADV_SPACEAVAIL  = 5;
  MADV_FREE        = 6;

  MS_ASYNC         = 16_01;
  MS_SYNC          = 16_02;
  MS_INVALIDATE    = 16_04;

<*EXTERNAL "m3_mmap" *>
PROCEDURE mmap (addr: void_star; len: size_t; prot,flags,fd: int; off: off_t)
  : void_star;

<*EXTERNAL*>
PROCEDURE munmap (addr: void_star; len: size_t): int;

<*EXTERNAL*>
PROCEDURE mprotect (addr: void_star; len: size_t; prot: int): int;

<*EXTERNAL "__msync13"*>
PROCEDURE msync (addr: void_star; len: size_t; flags: int): int;

END Umman.
