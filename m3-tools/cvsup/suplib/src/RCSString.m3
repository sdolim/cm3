(* Copyright 1996-2003 John D. Polstra.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgment:
 *      This product includes software developed by John D. Polstra.
 * 4. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * $Id$ *)

MODULE RCSString;

IMPORT Text;

TYPE
  String = T OBJECT
    text: TEXT;
  OVERRIDES
    toText := ToText;
    numLines := NumLines;
    iterate := Iterate;
  END;

  StringIter = Iterator OBJECT
    text: TEXT;
    pos: CARDINAL;
    len: CARDINAL;
  OVERRIDES
    next := Next;
  END;

PROCEDURE FromText(text: TEXT): T =
  BEGIN
    RETURN NEW(String, text := text);
  END FromText;

PROCEDURE NumLines(s: String): CARDINAL =
  VAR
    len := Text.Length(s.text);
    pos: INTEGER := 0;
    numLines: CARDINAL := 0;
  BEGIN
    WHILE pos < len DO
      INC(numLines);
      pos := Text.FindChar(s.text, '\n', pos);
      IF pos = -1 THEN EXIT END;
      INC(pos);
    END;
    RETURN numLines;
  END NumLines;

PROCEDURE ToText(s: String): TEXT =
  BEGIN
    RETURN s.text;
  END ToText;

PROCEDURE Iterate(s: String): Iterator =
  BEGIN
    RETURN NEW(StringIter, text := s.text,
      pos := 0, len := Text.Length(s.text));
  END Iterate;

PROCEDURE Next(iter: StringIter; VAR line: T): BOOLEAN =
  VAR
    end: INTEGER;
  BEGIN
    IF iter.pos >= iter.len THEN
      RETURN FALSE;
    END;

    end := Text.FindChar(iter.text, '\n', iter.pos);
    IF end = -1 THEN
      end := iter.len;
    ELSE
      INC(end);		(* Include the newline too. *)
    END;
    line := NEW(String, text := Text.Sub(iter.text, iter.pos, end-iter.pos));
    iter.pos := end;
    RETURN TRUE;
  END Next;

BEGIN
END RCSString.
