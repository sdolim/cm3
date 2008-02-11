(* Copyright (C) 1990, Digital Equipment Corporation.         *)
(* All rights reserved.                                       *)
(* See the file COPYRIGHT for a full description.             *)
(*                                                            *)
(* Last modified on Fri Apr 29 14:34:34 PDT 1994 by kalsow    *)
(*      modified on Sat Apr 16 by rrw1000@hermes.cam.ac.uk    *)
(*      modified on Mon Mar 09 19:02:29 PST 1992 by muller    *)

(* $Id: Upwd.i3,v 1.4 2008-02-11 12:18:57 jkrell Exp $ *)

INTERFACE Upwd;

FROM Ctypes IMPORT char_star, int;
FROM Utypes IMPORT uid_t, gid_t;

(*** <pwd.h> ***)

TYPE
  struct_passwd = RECORD
    pw_name:     char_star;
    pw_passwd:   char_star;
    pw_uid:      uid_t;
    pw_gid:      gid_t;
    pw_gecos:    char_star;
    pw_dir:      char_star;
    pw_shell:    char_star;
  END;

  struct_passwd_star = UNTRACED REF struct_passwd;

(*** getpwent, getpwuid, getpwnam, setpwent, endpwent(2) - get
     password file entry ***)

<*EXTERNAL*> PROCEDURE getpwent (): struct_passwd_star;
<*EXTERNAL*> PROCEDURE getpwuid (uid: int): struct_passwd_star;
<*EXTERNAL*> PROCEDURE getpwnam (name: char_star): struct_passwd_star;
<*EXTERNAL*> PROCEDURE setpwent(): int;
<*EXTERNAL*> PROCEDURE endpwent(): int;

END Upwd.
