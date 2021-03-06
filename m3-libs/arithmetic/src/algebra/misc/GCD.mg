GENERIC MODULE GCD(R);
(* Arithmetic for Modula-3, see doc for details *)

IMPORT Arithmetic AS Arith;

<* UNUSED *>
CONST
  Module = "GCD.";

PROCEDURE GCD (u, v: T; ): T =
  (* returns the greatest common denominator for u and v. *)
  (* use Euclid's algorithm *)
  (* Arith.ErrorDivisionByZero cannot occur *)
  <* FATAL Arith.Error *>
  BEGIN
    WHILE NOT R.IsZero(v) DO
      WITH w = R.Mod(u, v) DO u := v; v := w; END;
    END;
    (*
      WHILE v#0 DO
        w:=u MOD v;
        u:=v;
        v:=w;
      END;
    *)
    RETURN u;
  END GCD;

PROCEDURE LCM (u, v: T; ): T =
  BEGIN
    TRY
      RETURN R.Mul(R.Div(u, GCD(u, v)), v);
    EXCEPT
      Arith.Error (err) =>
        <* ASSERT NOT ISTYPE(err, Arith.ErrorIndivisible) *>
        RETURN R.Zero;
    END;
  END LCM;

PROCEDURE BezoutGCD
  (u, v: T; VAR (*OUT*) c: ARRAY [0 .. 1], [0 .. 1] OF T; ): T =
  (*
  / u \ - / q0 1 \ / q1 1 \ ... / gcd(u,v) \
  \ v / - \ 1  0 / \ 1  0 /     \    0     /

  ... / 0  1  \ / 0  1  \ / u \ - / gcd(u,v) \
      \ 1 -q1 / \ 1 -q0 / \ v / - \    0     /

  / a 1 \ / 0  1 \ - / 1 0 \
  \ 1 0 / \ 1 -a / - \ 0 1 /
  *)

  (* Arith.ErrorDivisionByZero cannot occur *)
  <* FATAL Arith.Error *>
  VAR
    next: ARRAY [0 .. 1] OF T;
  BEGIN
    c[0, 0] := R.One;
    c[0, 1] := R.Zero;
    c[1, 0] := R.Zero;
    c[1, 1] := R.One;
    WHILE NOT R.IsZero(v) DO
      WITH qr = R.DivMod(u, v) DO
        u := v;
        v := qr.rem;
        next[0] := R.Sub(c[0, 0], R.Mul(c[0, 0], qr.quot));
        next[1] := R.Sub(c[0, 1], R.Mul(c[0, 1], qr.quot));
        c[0] := c[1];
        c[1] := next;
      END;
    END;
    RETURN u;
  END BezoutGCD;

PROCEDURE Bezout (u, v, w: T; VAR (*OUT*) c: ARRAY [0 .. 1], [0 .. 1] OF T)
  RAISES {Arith.Error} =
  (*
  The former routine gives us c00, c01, c10, c11 for each u,v with
    c00*u + c01*v = gcd(u,v)
    c10*u + c11*v = 0
  Now let
    k = w / gcd(u,v)  (if this is indivisible the Bezout equation is not solvable)
  then a solution is
    k*c00*u + k*c01*v  = w
  but the coefficients k*c00 and k*c01 are to large and can be reduced:
    (k*c00-f*c10)*u + (k*c01-f*c11)*v = w
  By dividing k*c00 by c10 with remainder one obtains the smallest possible coefficient for u and the coefficent for v cannot not to large since it is limitted by w and u and its coefficient.
  *)
  VAR
    gcd            := BezoutGCD(u, v, c);
    k              := R.Div(w, gcd);
    fr : R.QuotRem;
  BEGIN
    c[0, 0] := R.Mul(c[0, 0], k);
    c[0, 1] := R.Mul(c[0, 1], k);
    (* reduce c[0,0] and c[0,1]*)
    fr := R.DivMod(c[0, 0], c[1, 0]);
    c[0, 0] := fr.rem;
    c[0, 1] := R.Sub(c[0, 1], R.Mul(fr.quot, c[1, 1]));
  END Bezout;

PROCEDURE MACDecompose (u, v: T; VAR (*OUT*) mac: MAC; ): T =
  (* Arith.ErrorDivisionByZero cannot occur *)
  <* FATAL Arith.Error *>
  BEGIN
    mac := NIL;
    WHILE NOT R.IsZero(v) DO
      WITH qr     = R.DivMod(u, v),
           newmac = NEW(MAC, factor := qr.quot, next := mac) DO
        mac := newmac;
        u := v;
        v := qr.rem;
      END;
    END;
    RETURN u;
  END MACDecompose;

BEGIN
END GCD.
