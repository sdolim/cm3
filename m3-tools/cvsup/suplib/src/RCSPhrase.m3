(* Copyright 1999-2003 John D. Polstra.
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
 *)

MODULE RCSPhrase;

TYPE
  RCSWord = REF RECORD
    next: RCSWord := NIL;
    word: TEXT;
    isString: BOOLEAN;
  END;

REVEAL
  T = BRANDED Brand REF RECORD
    key: TEXT;
    values: RCSWord := NIL;
    tail: RCSWord := NIL;
  END;

  WordIterator = WordIterPublic BRANDED OBJECT
    cur: RCSWord;
  OVERRIDES
    next := WordIterNext;
  END;

PROCEDURE New(key: TEXT): T =
  BEGIN
    RETURN NEW(T, key := key);
  END New;

PROCEDURE Append(np: T; word: TEXT; isString: BOOLEAN) =
  VAR
    tok := NEW(RCSWord, word := word, isString := isString);
  BEGIN
    IF np.tail = NIL THEN
      np.values := tok;
    ELSE
      np.tail.next := tok;
    END;
    np.tail := tok;
  END Append;

PROCEDURE GetKey(np: T): TEXT =
  BEGIN
    RETURN np.key;
  END GetKey;

PROCEDURE IterateWords(np: T): WordIterator =
  BEGIN
    RETURN NEW(WordIterator, cur := np.values);
  END IterateWords;

PROCEDURE WordIterNext(self: WordIterator;
                       VAR word: TEXT;
		       VAR isString: BOOLEAN): BOOLEAN =
  BEGIN
    IF self.cur # NIL THEN
      word := self.cur.word;
      isString := self.cur.isString;
      self.cur := self.cur.next;
      RETURN TRUE;
    END;
    RETURN FALSE;
  END WordIterNext;

BEGIN
END RCSPhrase.
