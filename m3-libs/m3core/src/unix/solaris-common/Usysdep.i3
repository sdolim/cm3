(* Copyright (C) 1990, Digital Equipment Corporation.         *)
(* All rights reserved.                                       *)
(* See the file COPYRIGHT for a full description.             *)

INTERFACE Usysdep;

FROM Cstdint IMPORT int32_t;
FROM Ctypes IMPORT int;

CONST
    (* trick from darwin-generic/Upthread.i3 *)
    X32 = ORD(BITSIZE(INTEGER) = 32);
    X64 = ORD(BITSIZE(INTEGER) = 64);

(* INTERFACE Unix; *)

    MaxPathLen = 1024;
    MAX_FDSET = (X32 * 1024) + (X64 * 65536);

TYPE
(* INTERFACE Usocket; *)

    struct_linger = RECORD
        l_onoff: int32_t;
        l_linger: int32_t;
    END;

(* INTERFACE Utime; *)

    struct_timeval = RECORD
        tv_sec: INTEGER;
        tv_usec: INTEGER;
    END;

    struct_tm = RECORD
        tm_sec:   int;
        tm_min:   int;
        tm_hour:  int;
        tm_mday:  int;
        tm_mon:   int;
        tm_year:  int;
        tm_wday:  int;
        tm_yday:  int;
        tm_isdst: int;
    END;

(* INTERFACE Utypes; *)

    time_t = INTEGER; (* ideally always 64 bits *)

END Usysdep.
