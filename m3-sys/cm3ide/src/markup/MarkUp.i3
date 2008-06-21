(* Copyright (C) 1992, Digital Equipment Corporation                         *)
(* All rights reserved.                                                      *)
(* See the file COPYRIGHT for a full description.                            *)
(*                                                                           *)
(* Last modified on Thu Dec  8 09:53:21 PST 1994 by kalsow                   *)

INTERFACE MarkUp;

IMPORT Buf, Marker, Wx, Wr, Thread;

PROCEDURE Annotate (buf: Buf.T;  wx: Wx.T;
                    ins: Marker.LineInsertion;
                    target: TEXT)
  RAISES {Wr.Failure, Thread.Alerted};
(* Copy the Modula-3 source in "buf" to "wx" adding HTML annotations
   and inserting any text in "ins".  If "target" is non-NIL, mark its
   declaration with the M3MarkUp.ThisDecl anchor.  *)

END MarkUp.
