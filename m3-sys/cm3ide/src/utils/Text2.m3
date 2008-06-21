(* Copyright 1995-96 Critical Mass, Inc. All rights reserved. *)

(* This interface defines misc. TEXT manipulation routines. *)

MODULE Text2;

IMPORT ASCII, Text, Text8, Word;

PROCEDURE CIEqual (a, b: TEXT): BOOLEAN =
  VAR
    len1 := Text.Length (a);
    len2 := Text.Length (b);
    c1, c2: CHAR;
  BEGIN
    IF (len1 # len2) THEN RETURN FALSE; END;
    FOR i := 0 TO len1 - 1 DO
      c1 := ASCII.Upper [Text.GetChar (a, i)];
      c2 := ASCII.Upper [Text.GetChar (b, i)];
      IF (c1 # c2) THEN RETURN FALSE; END
    END;
    RETURN TRUE;
  END CIEqual;

PROCEDURE EqualSub (a: TEXT;  READONLY b: ARRAY OF CHAR): BOOLEAN =
  VAR
    len1 := Text.Length (a);
    len2 := NUMBER (b);
  BEGIN
    IF (len1 # len2) THEN RETURN FALSE; END;
    FOR i := 0 TO len1 - 1 DO
      IF (Text.GetChar (a, i) # b[i]) THEN RETURN FALSE; END
    END;
    RETURN TRUE;
  END EqualSub;

PROCEDURE PrefixMatch (a, b: TEXT;  len: CARDINAL): BOOLEAN =
  BEGIN
    IF (Text.Length (a) < len)
    OR (Text.Length (b) < len) THEN
      RETURN FALSE;
    END;
    FOR i := 0 TO len-1 DO
      IF (Text.GetChar (a, i) # Text.GetChar (b, i)) THEN RETURN FALSE END;
    END;
    RETURN TRUE;
  END PrefixMatch;

PROCEDURE FindSubstring (a, b: TEXT): INTEGER =
  VAR a_len := Text.Length (a);  b_len := Text.Length (b);  j, k: INTEGER;
  BEGIN
    FOR i := 0 TO a_len - b_len DO
      j := i;  k := 0;
      WHILE (k < b_len) AND (Text.GetChar (a, j) = Text.GetChar (b, k)) DO
        INC (j); INC (k);
      END;
      IF (k >= b_len) THEN  RETURN i;  END;
    END;
    RETURN -1;
  END FindSubstring;

PROCEDURE FindBufSubstring (READONLY a: ARRAY OF CHAR;  b: TEXT): INTEGER =
  VAR a_len := NUMBER (a);  b_len := Text.Length (b);  j, k: INTEGER;
  BEGIN
    FOR i := 0 TO a_len - b_len DO
      j := i;  k := 0;
      WHILE (k < b_len) AND (a[j] = Text.GetChar (b, k)) DO
        INC (j); INC (k);
      END;
      IF (k >= b_len) THEN  RETURN i;  END;
    END;
    RETURN -1;
  END FindBufSubstring;

PROCEDURE Trim (a: TEXT): TEXT =
  VAR start: CARDINAL := 0;  stop: CARDINAL := Text.Length (a);  c: CHAR;
  BEGIN
    WHILE (start < stop) DO
      c := Text.GetChar (a, start);
      IF (c # ' ') AND (c # '\t') AND (c # '\r') AND  (c # '\n') THEN EXIT; END;
      INC (start);
    END;
    WHILE (start < stop) DO
      c := Text.GetChar (a, stop-1);
      IF (c # ' ') AND (c # '\t') AND (c # '\r') AND  (c # '\n') THEN EXIT; END;
      DEC (stop);      
    END;
    RETURN Text.Sub (a, start, stop - start);
  END Trim;

PROCEDURE FixExeName (a: TEXT): TEXT =
  VAR len := Text.Length (a);
  BEGIN
    FOR i := 0 TO len-1 DO
      IF (Text.GetChar (a, i) = ' ') THEN
        RETURN "\"" & a & "\"";
      END;
    END;
    RETURN a;
  END FixExeName;

PROCEDURE Escape (a: TEXT): TEXT =
  VAR len := Text.Length (a);   buf: ARRAY [0..255] OF CHAR;
  BEGIN
    IF (len <= NUMBER (buf))
      THEN RETURN DoEscape (a, len, buf);
      ELSE RETURN DoEscape (a, len, NEW (REF ARRAY OF CHAR, len)^);
    END;
  END Escape;

PROCEDURE DoEscape (a: TEXT;  len: CARDINAL;   VAR buf: ARRAY OF CHAR): TEXT =
  CONST BackSlash = '\134';
  VAR
    n_special := 0;
    c: CHAR;
    b: Text8.T;
    bx, z: INTEGER;
  BEGIN
    Text.SetChars (buf, a);

    FOR i := 0 TO len-1 DO
      c := buf[i];
      IF (c = '\n') OR (c = '\"') OR (c = '\'') OR (c = BackSlash)
        OR (c = '\r') OR (c = '\t') OR (c = '\f') THEN
        INC (n_special);
      ELSIF (c < ' ') OR (c > '~') THEN
        INC (n_special, 3);
      END;
    END;

    IF (n_special <= 0) THEN RETURN a; END;

    b := Text8.Create (len + n_special);  bx := 0;
    FOR i := 0 TO len-1 DO
      c := buf[i];
      IF (c = BackSlash) THEN
        b.contents[bx] := c; INC (bx); b.contents[bx] := c;  INC (bx);
      ELSIF (c = '\n') THEN
        b.contents[bx] := BackSlash; INC (bx); b.contents[bx] := 'n';  INC (bx);
      ELSIF (c = '\"') THEN
        b.contents[bx] := BackSlash; INC (bx); b.contents[bx] := c;  INC (bx);
      ELSIF (c = '\'') THEN
        b.contents[bx] := BackSlash; INC (bx); b.contents[bx] := c;  INC (bx);
      ELSIF (c = '\r') THEN
        b.contents[bx] := BackSlash; INC (bx); b.contents[bx] := 'r'; INC (bx);
      ELSIF (c = '\t') THEN
        b.contents[bx] := BackSlash; INC (bx); b.contents[bx] := 't'; INC (bx);
      ELSIF (c = '\f') THEN
        b.contents[bx] := BackSlash; INC (bx); b.contents[bx] := 'f'; INC (bx);
      ELSIF (c < ' ') OR (c > '~') THEN
        b.contents[bx] := BackSlash;  INC (bx);
        z := Word.RightShift (Word.And (ORD (c), 8_700), 6);
        b.contents[bx] := VAL(z + ORD('0'), CHAR);  INC (bx);
        z := Word.RightShift (Word.And (ORD (c), 8_070), 3);
        b.contents[bx] := VAL(z + ORD('0'), CHAR);  INC (bx);
        z := Word.And (ORD (c), 8_007);
        b.contents[bx] := VAL(z + ORD('0'), CHAR);  INC (bx);
      ELSE
        b.contents[bx] := c;  INC (bx);
      END;
    END;

    RETURN b;
  END DoEscape;

PROCEDURE EscapeHTML (a: TEXT): TEXT =
  VAR len := Text.Length (a);   buf: ARRAY [0..255] OF CHAR;
  BEGIN
    IF (len <= NUMBER (buf))
      THEN RETURN DoEscapeHTML (a, len, buf);
      ELSE RETURN DoEscapeHTML (a, len, NEW (REF ARRAY OF CHAR, len)^);
    END;
  END EscapeHTML;

PROCEDURE DoEscapeHTML (a: TEXT;  len: CARDINAL;  VAR buf: ARRAY OF CHAR): TEXT =
  CONST BackSlash = '\134';
  CONST HexChar = ARRAY [0..15] OF CHAR { '0','1','2','3','4','5','6','7',
                                          '8','9','A','B','C','D','E','F' };
  VAR
    n_special := 0;
    c: CHAR;
    b: Text8.T;
    bx, z: INTEGER;
  BEGIN
    Text.SetChars (buf, a);

    FOR i := 0 TO len-1 DO
      c := buf[i];
      IF (c = '\n') OR (c = '\"') OR (c = '\'') OR (c = BackSlash)
        OR (c = '\r') OR (c = '\t') OR (c = '\f')
        OR (c < ' ') OR (c > '~') THEN
        INC (n_special, 2);
      END;
    END;

    IF (n_special <= 0) THEN RETURN a; END;

    b := Text8.Create (len + n_special);  bx := 0;
    FOR i := 0 TO len-1 DO
      c := buf[i];
      IF   (c = '\n') OR (c = '\"') OR (c = '\'') OR (c = BackSlash)
        OR (c = '\r') OR (c = '\t') OR (c = '\f') OR (c < ' ')
        OR (c > '~') THEN
        b.contents[bx] := '%';  INC (bx);
        z := Word.RightShift (Word.And (ORD (c), 16_f0), 4);
        b.contents[bx] := HexChar [z];  INC (bx);
        z := Word.And (ORD (c), 16_0f);
        b.contents[bx] := HexChar [z];  INC (bx);
      ELSE
        b.contents[bx] := c;  INC (bx);
      END;
    END;

    RETURN b;
  END DoEscapeHTML;

PROCEDURE ConvertNBSP (a: TEXT): TEXT =
  VAR len := Text.Length (a);   buf: ARRAY [0..255] OF CHAR;
  BEGIN
    IF (len <= NUMBER (buf))
      THEN RETURN DoConvertNBSP (a, len, buf);
      ELSE RETURN DoConvertNBSP (a, len, NEW (REF ARRAY OF CHAR, len)^);
    END;
  END ConvertNBSP;

PROCEDURE DoConvertNBSP (a: TEXT;  len: CARDINAL;  VAR buf: ARRAY OF CHAR): TEXT =
  VAR n_blanks := 0;  b: Text8.T;  bx: CARDINAL;
  BEGIN
    Text.SetChars (buf, a);
    FOR i := 0 TO len-1 DO
      IF buf[i] = ' ' THEN INC (n_blanks); END;
    END;
    IF (n_blanks <= 0) THEN RETURN a; END;
    b := Text8.Create (len + n_blanks * 5);  bx := 0;
    FOR i := 0 TO len-1 DO
      IF buf[i] = ' ' THEN
        b.contents[bx] := '&';  INC (bx);
        b.contents[bx] := 'n';  INC (bx);
        b.contents[bx] := 'b';  INC (bx);
        b.contents[bx] := 's';  INC (bx);
        b.contents[bx] := 'p';  INC (bx);
        b.contents[bx] := ';';  INC (bx);
      ELSE
        b.contents[bx] := buf[i];  INC (bx);
      END;
    END;
    RETURN b;
  END DoConvertNBSP;

BEGIN
END Text2.
