(* Copyright (C) 1992, Digital Equipment Corporation           *)
(* All rights reserved.                                        *)
(* See the file COPYRIGHT for a full description.              *)

(* File: Expr.m3                                               *)
(* Last Modified On Tue Jun 20 15:44:34 PDT 1995 By kalsow     *)
(*      Modified On Thu Jun 15 13:07:24 PDT 1995 By ericv      *)
(*      Modified On Fri Dec 21 01:21:51 1990 By muller         *)

MODULE Expr EXPORTS Expr, ExprRep;

IMPORT M3, M3ID, M3Buf, CG, Type, Scanner, ExprParse;
IMPORT Target, TInt, ErrType, Error;
IMPORT NamedExpr, ConsExpr, OpenArrayType, ArrayType, Value;
IMPORT Bool, Int;
IMPORT CallExpr;

(********************************************************************)

(* EXPORTED: *)
PROCEDURE Parse (): T =
  BEGIN
    RETURN ExprParse.E0 (FALSE);
  END Parse;

PROCEDURE Init (t: T) =
  BEGIN
    t.origin               := Scanner.offset;
    t.type                 := NIL;
    t.align                := Target.Word.align+1 (* => uncached. *);
    t.checked              := FALSE;
    t.directAssignableType := FALSE;
    t.doDirectAssign       := FALSE;
    t.isNamedConst         := FALSE;
  END Init;

(********************************************************************)

(* EXPORTED: *)
PROCEDURE TypeOf (t: T): Type.T =
  BEGIN
    IF (t = NIL) THEN RETURN ErrType.T END;
    IF (t.type = NIL) THEN t.type := t.typeOf () END;
    RETURN t.type;
  END TypeOf;

(* EXPORTED: *)
PROCEDURE SemTypeOf (t: T): Type.T =
  BEGIN
    RETURN TypeOf (t);
  END SemTypeOf;

(* EXPORTED: *)
PROCEDURE RepTypeOf (t: T): Type.T =
  BEGIN
    IF (t = NIL) THEN RETURN ErrType.T END;
    RETURN t.repTypeOf ();
  END RepTypeOf;

(* EXPORTED: *)
PROCEDURE StaticLength (t: T): lengthTyp =
  BEGIN
    IF (t = NIL) THEN RETURN lengthInvalid END;
    RETURN t.staticLength ();
  END StaticLength;

(* EXPORTED: (ExprRep)*)
PROCEDURE StaticLengthDefault (t: T): lengthTyp =
  VAR exprType: Type.T := RepTypeOf (t);
  BEGIN
    IF exprType = NIL THEN
      RETURN lengthInvalid
    ELSIF OpenArrayType.Is (exprType) THEN
      RETURN lengthNonStatic
    ELSIF NOT ArrayType.Is (exprType) THEN
      RETURN lengthNonArray
    ELSE RETURN lengthInvalid
    END
  END StaticLengthDefault;

(* EXPORTED: *)
PROCEDURE UsesAssignProtocol (rhs: T): BOOLEAN =
BEGIN
    IF rhs = NIL THEN RETURN FALSE END;
    IF CallExpr.IsUserProc (rhs) THEN RETURN rhs.doDirectAssign END;

(* TODO ^This one-liner is an easy temporary way to sidestep having to add
        massive and widely scattered apparatus for two different levels of
        dispatching, using two different mechanisms, just to get
        rhs.usesAssignProtocol to handle this case.  *)
    RETURN rhs.usesAssignProtocol ();
  END UsesAssignProtocol;

(* EXPORTED: (ExprRep)*)
PROCEDURE UsesAssignProtocolDefault (<*UNUSED*>t: T): BOOLEAN =
  BEGIN
    RETURN FALSE
  END UsesAssignProtocolDefault;

(* EXPORTED: (ExprRep)*)
PROCEDURE DefaultUse (<*UNUSED*>e: M3.Expr): BOOLEAN =
  BEGIN
    RETURN TRUE;
  END DefaultUse;

(* EXPORTED: *)
PROCEDURE TypeCheck (t: T;  VAR cs: CheckState) =
  VAR save: INTEGER;
  BEGIN
    IF (t = NIL) THEN RETURN END;
    IF (t.checked) THEN RETURN END;
    save := Scanner.offset;
    Scanner.offset := t.origin;
    t.check (cs);
    Scanner.offset := save;
    t.checked := TRUE;
  END TypeCheck;

(********************************************************************)

(* EXPORTED: *)
PROCEDURE ConstValue (t: T): T =
  VAR new: T;  cs: CheckState;
  BEGIN
    IF (t = NIL) THEN RETURN NIL END;
    (*** NOT necessarily: <* ASSERT t.checked *> ***)
    new := t.evaluate ();
    IF (new # t) THEN
      cs := M3.OuterCheckState; (* OK since constants don't raise exceptions *)
      TypeCheck (new, cs);
    END;
    RETURN new;
  END ConstValue;

(* EXPORTED: *)
PROCEDURE GetBounds (t: T;  VAR min, max: Target.Int) =
  BEGIN
    IF (t = NIL) THEN min := TInt.Zero; max := TInt.MOne; RETURN END;
    <* ASSERT t.checked *>
    t.getBounds (min, max);
  END GetBounds;

(* EXPORTED: *)
PROCEDURE IsDesignator (t: T): BOOLEAN =
  BEGIN
    IF (t = NIL) THEN RETURN TRUE END;
    <* ASSERT t.checked *>
    RETURN t.isDesignator ();
  END IsDesignator;

(* EXPORTED: *)
PROCEDURE IsWritable (t: T;  lhs: BOOLEAN): BOOLEAN =
  BEGIN
    IF (t = NIL) THEN RETURN TRUE END;
    <* ASSERT t.checked *>
    RETURN t.isWritable (lhs)
  END IsWritable;

(* EXPORTED: *)
PROCEDURE IsZeroes (t: T): BOOLEAN =
(* PRE: t is checked. *)
  BEGIN
    IF (t = NIL) THEN RETURN TRUE END;
    <* ASSERT t.checked *>
    RETURN t.isZeroes ()
  END IsZeroes;

(* EXPORTED: *)
PROCEDURE GetSign (t: T): CG.Sign =
  VAR min, max: Target.Int;
  BEGIN
    GetBounds (t, min, max);
    IF    TInt.LE (TInt.Zero, min) THEN  RETURN CG.Sign.Positive;
    ELSIF TInt.LE (max, TInt.Zero) THEN  RETURN CG.Sign.Negative;
    ELSE                                 RETURN CG.Sign.Unknown;
    END;
  END GetSign;

(********************************************************************)

(* EXPORTED: *)
PROCEDURE NeedsAddress (t: T) =
  BEGIN
    IF (t = NIL) THEN RETURN END;
    <*ASSERT t.checked *>
    t.need_addr ();
  END NeedsAddress;

(********************************************************************)

(* EXPORTED: *)
PROCEDURE SupportsDirectAssignment (t: T): BOOLEAN =
  VAR baseExpr: T;
  BEGIN
    IF t = NIL THEN RETURN FALSE END;
    IF ConsExpr.Is (t)
    THEN baseExpr := ConsExpr.Base (t);
    ELSE baseExpr := t;
    END; 

    RETURN baseExpr # NIL AND baseExpr.directAssignableType;
  END SupportsDirectAssignment;

(* EXPORTED: *)
PROCEDURE MarkForDirectAssignment (t: T) =
(* If called, must be before Prep(t). *)
  BEGIN
    <*ASSERT t.directAssignableType*>
    t.doDirectAssign := TRUE;
  END MarkForDirectAssignment;

(* EXPORTED: *)
PROCEDURE IsMarkedForDirectAssignment (t: T): BOOLEAN =
  BEGIN
    RETURN (t # NIL) AND (t.doDirectAssign);
  END IsMarkedForDirectAssignment;

(******************************************** Alignments ************)

(* EXPORTED: *)
PROCEDURE Alignment (t: T): Type.BitAlignT = 
(* A bit alignment that t is guaranteed to have.  Hopefully maximum, or
   nearly so.  Always a true alignment, possibly as small as 1 bit. 
   Expression alignments are more precise than type alignments in that they
   can take into account properties of an expression that the expression's
   type does not necessarily have in general.  Particularly, if a value is
   a field or element, they can depend on its containing record, object,
   or array.  For an open array expression, this is the alignment of the
   elements, not the dope.
   Compare to Type.T.info.alignment. 
*)

  BEGIN
    IF t = NIL THEN RETURN Target.Word.align; END;
    IF t.align > Target.Word.align THEN
      (* Uninitialized. Compute and cache it. *)
      t.align := t.exprAlign()
    END; 
    RETURN t.align;     
  END Alignment;

(* Multi-use overrides for exprAlign, declared in ExprRep:  *)

PROCEDURE ExprAlignDefault (e: T): Type.BitAlignT =
  (* Strips packed. *) 
  VAR type: Type.T;
  VAR info: Type.Info; 
  BEGIN
    type := Type.StripPacked (e.type);
    (* ^Assume we are not in a packing environment. *) 
    IF type # NIL THEN 
      EVAL Type.CheckInfo (type, info);
      RETURN info.alignment;
    END; 
    RETURN Target.Word.align; 
  END ExprAlignDefault;

PROCEDURE ExprAddrAlign (<*UNUSED*> e: T): Type.BitAlignT =
  BEGIN
    RETURN Target.Address.align; 
  END ExprAddrAlign; 

PROCEDURE ExprBoolAlign (<*UNUSED*> e: T): Type.BitAlignT =
  VAR info: Type.Info;
  BEGIN
    EVAL Type.CheckInfo (Bool.T, info);
    RETURN info.alignment; 
  END ExprBoolAlign; 

PROCEDURE ExprIntAlign (<*UNUSED*> e: T): Type.BitAlignT =
  VAR info: Type.Info;
  BEGIN
    EVAL Type.CheckInfo (Int.T, info);
    RETURN info.alignment; 
  END ExprIntAlign; 

PROCEDURE ExprAlignArg0 (e: Ta): Type.BitAlignT =
  BEGIN
    RETURN Alignment(e.a); 
  END ExprAlignArg0; 

(********************************************************************)

(* EXPORTED: *)
PROCEDURE Prep (t: T) =
  BEGIN
    IF (t = NIL) THEN RETURN END;
    <* ASSERT t.checked *>
    t.prep ();
  END Prep;

(* EXPORTED: *)
PROCEDURE Compile (t: T) =
  BEGIN
    IF (t = NIL) THEN RETURN END;
    <* ASSERT t.checked *>
    t.compile ();
  END Compile;

(* EXPORTED: *)
PROCEDURE PrepLValue (t: T; traced: BOOLEAN) =
  BEGIN
    IF (t = NIL) THEN RETURN END;
    Type.Compile (t.type);
    <* ASSERT t.checked *>
    t.prepLV (traced);
  END PrepLValue;

(* EXPORTED: *)
PROCEDURE CompileLValue (t: T; traced: BOOLEAN) =
  BEGIN
    IF (t = NIL) THEN RETURN END;
    <* ASSERT t.checked *>
    t.compileLV (traced);
  END CompileLValue;

(* EXPORTED: *)
PROCEDURE CompileAddress (t: T; traced: BOOLEAN) =
  BEGIN
    IF (t = NIL) THEN RETURN END;
    <* ASSERT t.checked *>
    t.compileLV (traced);
    CG.Check_byte_aligned ();
  END CompileAddress;

(* EXPORTED: *)
PROCEDURE PrepBranch (t: T;  true, false: CG.Label;  freq: CG.Frequency) =
  BEGIN
    IF (t = NIL) THEN RETURN END;
    <* ASSERT t.checked *>
    <* ASSERT (true = CG.No_label) OR (false = CG.No_label) *>
    Type.Compile (t.type);
    t.prepBR (true, false, freq);
  END PrepBranch;

(* EXPORTED: *)
PROCEDURE CompileBranch (t: T;  true, false: CG.Label;  freq: CG.Frequency) =
  BEGIN
    IF (t = NIL) THEN RETURN END;
    <* ASSERT t.checked *>
    <* ASSERT (true = CG.No_label) OR (false = CG.No_label) *>
    t.compileBR (true, false, freq);
  END CompileBranch;

(* EXPORTED: *)
PROCEDURE NoteWrite (t: T) =
  BEGIN
    IF (t = NIL) THEN RETURN END;
    t.note_write ();
  END NoteWrite;

(* EXPORTED: *)
PROCEDURE IsEqual (a, b: T;  x: M3.EqAssumption): BOOLEAN =
  BEGIN
    IF (a = b) THEN RETURN TRUE END;
    IF (a = NIL) OR (b = NIL) THEN RETURN FALSE END;
    RETURN a.isEqual (b, x);
  END IsEqual;

(* EXPORTED: *)
PROCEDURE PrepLiteral (t: T;  type: Type.T;  is_const: BOOLEAN) =
  BEGIN
    IF (t = NIL) THEN RETURN END;
    <* ASSERT t.checked *>
    Type.Compile (t.type);
    t.prepLiteral (type, is_const);
  END PrepLiteral;

(* EXPORTED: *)
PROCEDURE GenLiteral (t: T;  offset: INTEGER;  type: Type.T;  is_const: BOOLEAN) =
  BEGIN
    IF (t = NIL) THEN RETURN END;
    <* ASSERT t.checked *>
    Type.Compile (t.type);
    t.genLiteral (offset, type, is_const);
  END GenLiteral;

(* EXPORTED: *)
PROCEDURE GenFPLiteral (t: T;  mbuf: M3Buf.T) =
  VAR u := ConstValue (t);
  BEGIN
    IF (u = NIL) THEN
      Error.Msg ("INTERNAL ERROR: fingerprint of a non-constant expression");
    END;
    <* ASSERT u.checked *>
    u.genFPLiteral (mbuf);
  END GenFPLiteral;

(* EXPORTED: *)
PROCEDURE BadOperands (op: TEXT;  a, b: M3.Type := NIL): M3.Type =
  BEGIN
    IF (a # ErrType.T) AND (b # ErrType.T) THEN
      Error.Msg ("illegal operand(s) for " & op);
    END;
    RETURN ErrType.T;
  END BadOperands;


(******************** default methods ************************************)

PROCEDURE NoType (<*UNUSED*> t: T): Type.T =
  BEGIN
    <* ASSERT FALSE *>
  END NoType;

PROCEDURE NoCheck (<*UNUSED*> t: T;  <*UNUSED*> VAR cs: CheckState) =
  BEGIN
  END NoCheck;

PROCEDURE NoValue (<*UNUSED*> t: T): T =
  BEGIN
    RETURN NIL;
  END NoValue;

PROCEDURE NoFPLiteral (<*UNUSED*> t: T;  <*UNUSED*>mbuf: M3Buf.T) =
  BEGIN
    <*ASSERT FALSE*>
  END NoFPLiteral;

PROCEDURE Self (t: T): T =
  BEGIN
    RETURN t;
  END Self;

PROCEDURE NoBounds (t: T;  VAR min, max: Target.Int) =
  BEGIN
    EVAL Type.GetBounds (t.type, min, max);
  END NoBounds;

PROCEDURE IsNever (<*UNUSED*> t: T;  <*UNUSED*> lhs: BOOLEAN): BOOLEAN =
  BEGIN
    RETURN FALSE;
  END IsNever;

PROCEDURE IsAlways (<*UNUSED*> t: T;  <*UNUSED*> lhs: BOOLEAN): BOOLEAN =
  BEGIN
    RETURN TRUE;
  END IsAlways;

PROCEDURE NeverEq (<*UNUSED*> a, b: T;
                   <*UNUSED*> x: M3.EqAssumption): BOOLEAN =
  BEGIN
    RETURN FALSE;
  END NeverEq;

PROCEDURE NoPrepLiteral (<*UNUSED*> t: T;
                         <*UNUSED*> type: Type.T;
                         <*UNUSED*> is_const: BOOLEAN) =
  BEGIN
  END NoPrepLiteral;

PROCEDURE NoLiteral (<*UNUSED*> t: T; 
                     <*UNUSED*> offset: INTEGER;
                     <*UNUSED*> type: Type.T;
                     <*UNUSED*> is_const: BOOLEAN) =
  BEGIN
    <* ASSERT FALSE *>
  END NoLiteral;

PROCEDURE NoPrep (<*UNUSED*> t: T) =
  BEGIN
  END NoPrep;

PROCEDURE NoCompile (<*UNUSED*> t: T) =
  BEGIN
    <*ASSERT FALSE*>
  END NoCompile;

PROCEDURE NotLValue (<*UNUSED*> t: T; <*UNUSED*> traced: BOOLEAN) =
  BEGIN
    <* ASSERT FALSE *>
  END NotLValue;

PROCEDURE NotBoolean (<*UNUSED*> t: T;
                      <*UNUSED*> true, false: CG.Label;
                      <*UNUSED*> freq: CG.Frequency) =
  BEGIN
    <* ASSERT FALSE *>
  END NotBoolean;

PROCEDURE PrepNoBranch (t: T;  true, false: CG.Label;  freq: CG.Frequency) =
  BEGIN
    t.prep ();
    t.compile ();
    IF (true = CG.No_label)
      THEN CG.If_false (false, freq);
      ELSE CG.If_true (true, freq);
    END;
  END PrepNoBranch;

PROCEDURE NoBranch (<*UNUSED*> t: T;
                    <*UNUSED*> true, false: CG.Label;
                    <*UNUSED*> freq: CG.Frequency) =
  BEGIN
    (* prep did all the work *)
  END NoBranch;

PROCEDURE NotAddressable (<*UNUSED*> t: T) =
  BEGIN
    <*ASSERT FALSE*>
  END NotAddressable;

PROCEDURE NotWritable (<*UNUSED*> t: T) =
  BEGIN
    (* skip *)
  END NotWritable;

PROCEDURE EqCheckA (a: Ta;  e: T;  x: M3.EqAssumption): BOOLEAN =
  BEGIN
    TYPECASE e OF
    | NULL  => RETURN FALSE;
    | Ta(b) => RETURN (TYPECODE (a) = TYPECODE (e)) AND IsEqual (a.a, b.a, x);
    ELSE       RETURN FALSE;
    END;
  END EqCheckA;

PROCEDURE EqCheckAB (a: Tab;  e: T;  x: M3.EqAssumption): BOOLEAN =
  BEGIN
    TYPECASE e OF
    | NULL   => RETURN FALSE;
    | Tab(b) => RETURN (TYPECODE (a) = TYPECODE (b)) AND
                       IsEqual (a.a, b.a, x) AND IsEqual (a.b, b.b, x);
    ELSE        RETURN FALSE;
    END;
  END EqCheckAB;

PROCEDURE StripNamedCons (expr: T): T =
(* Look through a NamedExpr and then a ConsExpr, for an Expr.T.  NIL if not. *)

  VAR ident: M3ID.T;
  VAR val: Value.T;
  VAR unnamedExpr, resultExpr: T;
  BEGIN
    IF NamedExpr.Split (expr, ident, val) THEN
      IF Value.ClassOf (val) # Value.Class.Expr THEN RETURN NIL END;
      unnamedExpr := Value.ToExpr (val);
    ELSE unnamedExpr := expr
    END;
    ConsExpr.Seal (unnamedExpr);
    (* DO NOT allow ConsExpr to Check unnamedExpr.  That could make a (should be
       top-level) call to ArrayExpr.Check on a nested array constructor.
       But it's OK if ConsExpr previously checked unnamedExpr. *)
    resultExpr := ConsExpr.Base (unnamedExpr);
    IF resultExpr = NIL THEN resultExpr := unnamedExpr END;
    RETURN resultExpr
  END StripNamedCons;

PROCEDURE Use (t: T): BOOLEAN =
(* Generate runtime actions prior to a use of t that does not call Compile.
   Return TRUE IFF following code is reachable. *)
  VAR strippedExpr: T;
  BEGIN
    strippedExpr := StripNamedCons (t);
    IF strippedExpr = NIL THEN RETURN TRUE END;
    <* ASSERT strippedExpr.checked *>
    RETURN strippedExpr.use ();
  END Use;

BEGIN
END Expr.
