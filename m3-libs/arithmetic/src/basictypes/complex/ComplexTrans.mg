GENERIC MODULE ComplexTrans(R, RT, C);
(* Arithmetic for Modula-3, see doc for details

   Abstract: Transcendental functions of complex numbers. *)

IMPORT Arithmetic AS Arith;
IMPORT FloatMode;

<* UNUSED *>
CONST
  Module = "ComplexTrans.";


PROCEDURE Arg (READONLY x: T; ): R.T =
  BEGIN
    RETURN RT.ArcTan2(x.im, x.re);
  END Arg;


PROCEDURE PowR (READONLY x: T; y: R.T; ): T =
  VAR
    arg := Arg(x);
    abs := Abs(x);
  BEGIN
    RETURN C.Scale(Exp(T{R.Zero, R.Mul(arg, y)}), RT.Pow(abs, y));
  END PowR;


PROCEDURE Pow (x, y: T; ): T =
  VAR z := Ln(x);
  BEGIN
    z := C.Mul(y, z);
    z := Exp(z);
    RETURN z;
  END Pow;



(* This function would definitely benefit of an implementation of SinCos *)
PROCEDURE Exp (READONLY x: T; ): T =
  BEGIN
    RETURN C.Scale(T{RT.Cos(x.im), RT.Sin(x.im)}, RT.Exp(x.re));
  END Exp;


(* This function would definitely benefit of an implementation of SinCos *)
PROCEDURE ExpI (x: R.T; ): T =
  BEGIN
    RETURN T{RT.Cos(x), RT.Sin(x)};
  END ExpI;


PROCEDURE Ln (READONLY x: T; ): T =
  VAR z: T;
  BEGIN
    (*z.re:= R.Div(RT.Ln(AbsSqr(x)),R.Two);*)
    z.re := RT.Ln(AbsSqr(x)) / R.Two;
    z.im := Arg(x);
    RETURN z;
  END Ln;


PROCEDURE Cos (READONLY x: T; ): T RAISES {Arith.Error} =
  VAR z: T;
  BEGIN
    IF ABS(x.re) > FLOAT(18.0D0, R.T) OR ABS(x.im) > FLOAT(18.0D0, R.T) THEN
      RAISE Arith.Error(NEW(Arith.ErrorOutOfRange).init());
    END;
    z.re := +RT.Cos(x.re) * RT.CosH(x.im);
    z.im := -RT.Sin(x.re) * RT.SinH(x.im);
    RETURN z;
  END Cos;

PROCEDURE Sin (READONLY x: T; ): T RAISES {Arith.Error} =
  VAR z: T;
  BEGIN
    IF ABS(x.re) > FLOAT(18.0D0, R.T) OR ABS(x.im) > FLOAT(18.0D0, R.T) THEN
      RAISE Arith.Error(NEW(Arith.ErrorOutOfRange).init());
    END;
    z.re := +RT.Sin(x.re) * RT.CosH(x.im);
    z.im := +RT.Cos(x.re) * RT.SinH(x.im);
    RETURN z;
  END Sin;

PROCEDURE Tan (READONLY x: T; ): T RAISES {Arith.Error} =
  BEGIN
    RETURN C.Div(Sin(x), Cos(x));
  END Tan;


PROCEDURE CosH (READONLY x: T; ): T RAISES {Arith.Error} =
  BEGIN
    RETURN Cos(T{re := -x.im, im := +x.re});
  END CosH;

PROCEDURE SinH (READONLY x: T; ): T RAISES {Arith.Error} =
  VAR
    (*z.re = -i*i*z.im = z.im*)
    (*z.im = -i*z.re* = -z.re*)
    z := Sin(T{-x.im, x.re});
  BEGIN
    RETURN T{z.im, -z.re};
  END SinH;

PROCEDURE TanH (READONLY x: T; ): T RAISES {Arith.Error} =
  BEGIN
    RETURN C.Div(SinH(x), CosH(x));
  END TanH;


PROCEDURE Norm1 (READONLY x: T; ): R.T =
  BEGIN
    RETURN ABS(x.re) + ABS(x.im);
  END Norm1;


PROCEDURE NormInf (READONLY x: T; ): R.T =
  BEGIN
    RETURN MAX(ABS(x.re), ABS(x.im));
  END NormInf;

(* Lemming's stuff *)

PROCEDURE ArcSin (READONLY x: T; ): T =
  VAR
    ix := T{R.Neg(x.im), x.re};
    y  := SqRt(C.Add(C.Square(ix), C.One));
  BEGIN
    (* arcsin x = -i ln (ix � sqrt (1-x�)) *)
    (*ix := C.Mul(x,C.I);*)
    RETURN C.Neg(C.Mul(C.I, Ln(C.Add(ix, y))));
  END ArcSin;

PROCEDURE ArcCos (READONLY x: T; ): T =
  VAR y := SqRt(C.Sub(C.Square(x), C.One));
  BEGIN
    (* arccos x = -i ln (x � sqrt (x�-1)) *)
    RETURN C.Neg(C.Mul(C.I, Ln(C.Add(x, y))));
  END ArcCos;

PROCEDURE ArcTan (READONLY x: T; ): T RAISES {Arith.Error} =
  VAR y := C.Div(C.Sub(C.I, x), C.Add(C.I, x));
  BEGIN
    (* arctan x := 1/2i ln ((i-x)/(i+x)) *)
    RETURN C.Mul(Ln(y), T{R.Zero, RT.Half});
  END ArcTan;


PROCEDURE Abs (READONLY x0: T; ): R.T =
  VAR
    x := C.Normalize(x0);
    y := RT.SqRt(AbsSqr(x.val));
  <* FATAL FloatMode.Trap *>
  BEGIN
    (* a workaround to prevent NaNs and Zeros *)
    RETURN R.Scalb(y, x.exp);
  END Abs;

(*
PROCEDURE Abs (READONLY x:T;) : R.T =
BEGIN
  RETURN RT.SqRt(AbsSqr(x));
END Abs;
*)

PROCEDURE AbsSqr (READONLY x: T; ): R.T =
  BEGIN
    (* RETURN C.Mul(x,C.Conj(x)); it's a real number, but the type is still
       T *)
    RETURN x.re * x.re + x.im * x.im;
  END AbsSqr;

PROCEDURE SqRt (READONLY x: T; ): T =
  VAR
    r    := Abs(x);
    z: T;
  BEGIN
    z.re := R.Add(r, x.re);
    IF R.Compare(z.re, R.Zero) < 0 THEN (* mathematically impossible, can
                                           be caused by rounding *)
      z.re := R.Zero;
    ELSE
      z.re := RT.SqRt(R.Mul(z.re, RT.Half));
    END;

    z.im := R.Sub(r, x.re);
    IF R.Compare(z.im, R.Zero) < 0 THEN (* mathematically impossible, can
                                           be caused by rounding *)
      z.im := R.Zero;
    ELSE
      z.im := RT.SqRt(R.Mul(z.im, RT.Half));
      IF R.Compare(x.im, R.Zero) < 0 THEN (* instead of using the Sgn
                                             function *)
        z.im := R.Neg(z.im);
      END;
    END;
    (* Root is on the same side as the radicand with respect to the real
       axis. *)
    RETURN z;
  END SqRt;


BEGIN
END ComplexTrans.
