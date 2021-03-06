(* Copyright (c) 2000 California Institute of Technology *)
(* All rights reserved. See the file COPYRIGHT for a full description. *)
(* $Id: TextBounder.i3,v 1.2 2001-09-19 15:30:31 wagner Exp $ *)

INTERFACE TextBounder;
IMPORT LinoText;
IMPORT Rect;
TYPE
  T = OBJECT METHODS
    bound(t: LinoText.T): Rect.T;
    (* Can assume t.attach = LinoText.Attach.West. *)
  END;
END TextBounder.
