GENERIC MODULE PolarFmtLex(P,RF);
(*Copyright (c) 1996, m3na project

Abstract: Complex numbers in polar coordinates

12/13/95  Harry George    Initial version
1/27/96   Harry George    Converted to m3na format
2/3/96    Harry George    Added trancendentals
2/17/96   Harry George    Converted from Objects to ADT's
3/16/96   Warren Smith    Improved routines, and new routines.
                          The ones with beginning caps are wds's
*)
IMPORT Fmt AS F;

<*UNUSED*> CONST Module = "PolarFmtLex.";

(*----------------*)
PROCEDURE Fmt( 
                x:P.T;
                style:F.Style:=F.Style.Fix;
                prec:CARDINAL:=3
                ):TEXT=
VAR
  t:TEXT;
BEGIN
  t:="POLAR{radius:=" & RF.Fmt(x.radius,style,prec) & "D0,"
         & "angle:="  & RF.Fmt(x.angle ,style,prec) & "D0}";
  RETURN t;
END Fmt;

(*==========================*)
BEGIN
END PolarFmtLex.
