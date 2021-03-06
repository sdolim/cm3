MODULE RandomDECSRC;
(* Arithmetic for Modula-3, see doc for details *)
IMPORT LongRealBasic AS R, Word AS W;
IMPORT Random;

FROM RandomBasic IMPORT Min, Max;
IMPORT RandomRep, RandomBasic;

<* UNUSED *>
CONST
  Module = "RandomDECSRC.";

REVEAL
  T = TPublic BRANDED OBJECT
        rand: Random.T;
      OVERRIDES
        init            := Init;
        generateBoolean := GenerateBoolean;
        generateWord    := GenerateWord;
        generateReal    := GenerateReal;
      END;

PROCEDURE Init (t: T; ): T =
  BEGIN
    t.rand := NEW(Random.Default).init();
    RETURN t;
  END Init;

PROCEDURE GenerateBoolean (SELF: T; ): BOOLEAN =
  BEGIN
    RETURN SELF.rand.boolean();
  END GenerateBoolean;

PROCEDURE GenerateWord (SELF: T; ): W.T =
  BEGIN
    RETURN VAL(SELF.rand.integer(), W.T);
  END GenerateWord;

PROCEDURE GenerateReal (SELF: T; ): R.T =
  BEGIN
    RETURN MIN(Max, MAX(Min, SELF.rand.longreal()));
  END GenerateReal;

BEGIN
END RandomDECSRC.
