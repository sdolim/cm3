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
 *)

UNSAFE MODULE RsyncFile;

IMPORT
  FileAttr, MD5, MD5Digest, OSError, Pathname, RsyncBlock,
  RsyncBlockArraySort, Thread, UnixMisc, Ustat, Word, Wr;

REVEAL
  T = Public BRANDED OBJECT
    buf: ADDRESS := NIL;
    size: CARDINAL := 0;
    start: UNTRACED REF CHAR := NIL;
    limit: UNTRACED REF CHAR := NIL;
    md5: TEXT := NIL;
  END;

CONST
  CharOffset = 3;
(* "CharOffset" is an arbitrary non-zero value which improves the quality
   of the rolling checksum a little bit.  It must be the same on the client
   and the server. *)


PROCEDURE ChooseBlockSize(fileSize: CARDINAL): CARDINAL =
(* Choose a good block size for the given file size. *)

(*
   We choose a block size based on several considerations.  First,
   we want to keep the network pipeline full as well as we can.
   The server cannot do anything with a file until it has all the
   block information from the client.  We would like to have all
   the block information for a file sitting in the server's receive
   buffer before the server finishes with the previous file.
   Otherwise the server will have to stop sending until it has read
   all of the block information from the network.  To avoid this,
   we try to choose a block size such that all of the block
   information will fit into the network receive buffer on the
   server machine.

   We clamp the block size within a range that we consider
   "reasonable".

   We would also like to have the final "remainder" block be as
   small as possible, since it will always have to be sent verbatim
   by the server.  After we have chosen a target block size, we
   search in its neighborhood for a block size that will minimize
   the remainder.
*)

  CONST
    MinBlockSize = 1024;
    MaxBlockSize = 16 * 1024;
    ReceiveBufferSize = 15 * 1024;  (* A guess. *)
    BlockInfoSize = 26;  (* It's 42 chars, but we assume decent compression. *)
    SearchRegion = 10;  (* On each side of the first choice. *)
    MaxBlocks = ReceiveBufferSize DIV BlockInfoSize;
  VAR
    bestRemainder: CARDINAL;
    blockSize := fileSize DIV MaxBlocks;
    loSearch := blockSize - SearchRegion;
    hiSearch := blockSize + SearchRegion;
  BEGIN
    IF loSearch < MinBlockSize THEN
      loSearch := MinBlockSize;
      hiSearch := loSearch + 2*SearchRegion;
    ELSIF hiSearch > MaxBlockSize THEN
      hiSearch := MaxBlockSize;
      loSearch := hiSearch - 2*SearchRegion;
    END;

    bestRemainder := MaxBlockSize;  (* Effectively infinity. *)
    FOR bs := loSearch TO hiSearch DO
      WITH rem = fileSize MOD bs DO
	IF rem < bestRemainder THEN
	  bestRemainder := rem;
	  blockSize := bs;
	END;
      END;
    END;

    RETURN blockSize;
  END ChooseBlockSize;

PROCEDURE Close(rf: T)
  RAISES {OSError.E} =
  BEGIN
    IF rf.buf # NIL THEN
      UnixMisc.Unmap(rf.buf, rf.size);
      rf.buf := NIL;
    END;
    rf.size := 0;
    rf.start := NIL;
    rf.limit := NIL;
  END Close;

PROCEDURE GetMD5(rf: T): TEXT =
  VAR
    md5 := MD5.New();
  BEGIN
    TRY
      md5.updateRaw(rf.start, rf.size);
    FINALLY
      RETURN md5.finish();
    END;
  END GetMD5;

PROCEDURE Open(p: Pathname.T;
               blockSize: CARDINAL := 0): T
  RAISES {OSError.E} =
  VAR
    rf: T;
    statbuf: Ustat.struct_stat;
  BEGIN
    rf := NEW(T);
    rf.buf := UnixMisc.MapFile(p, statbuf);
    rf.attr := FileAttr.FromStat(statbuf);
    rf.size := VAL(statbuf.st_size, INTEGER);
    rf.start := rf.buf;
    rf.limit := rf.start + rf.size;

    IF blockSize = 0 THEN
      blockSize := ChooseBlockSize(rf.size);
    END;
    rf.blockSize := blockSize;
    RETURN rf;
  END Open;

(*****************************************************************************)

TYPE
  BlockIteratorRep = BlockIterator OBJECT
    rf: T;
    ptr: UNTRACED REF CHAR;
    blockNum: CARDINAL := 0;
  OVERRIDES
    next := BlockIteratorNext;
  END;

PROCEDURE IterateBlocks(rf: T): BlockIterator =
  BEGIN
    RETURN NEW(BlockIteratorRep, rf := rf, ptr := rf.start);
  END IterateBlocks;

PROCEDURE BlockIteratorNext(bi: BlockIteratorRep;
                            VAR block: RsyncBlock.T): BOOLEAN =
  VAR
    blockSize: CARDINAL;
  BEGIN
    IF bi.ptr >= bi.rf.limit THEN  (* All done. *)
      RETURN FALSE;
    END;

    blockSize := MIN(bi.rf.limit - bi.ptr, bi.rf.blockSize);

    block.num := bi.blockNum;
    block.md5 := BlockMD5(bi.ptr, blockSize);
    block.rsum := BlockRsum(bi.ptr, blockSize);

    INC(bi.blockNum);
    INC(bi.ptr, blockSize);
    RETURN TRUE;
  END BlockIteratorNext;

(*****************************************************************************)

PROCEDURE BlockMD5(ptr: UNTRACED REF CHAR; count: CARDINAL): MD5Digest.T =
  VAR
    digest: MD5Digest.T;
    md5 := MD5.New();
  BEGIN
    TRY
      md5.updateRaw(ptr, count);
    FINALLY
      md5.finishRaw(digest);
      RETURN digest;
    END;
  END BlockMD5;

PROCEDURE BlockRsum(ptr: UNTRACED REF CHAR; count: CARDINAL): Word.T =
  VAR
    limit := ptr + count;
    a, b: Word.T := 0;
  BEGIN
    (* This first loop is just an unrolled version of the second loop. *)
    WHILE ptr <= limit - 4 DO
      b :=
	Word.Plus(
	  b,
	  Word.Plus(
	    Word.Times(4, Word.Plus(a, ORD(ptr^))),
	    Word.Plus(
	      Word.Times(3, ORD(LOOPHOLE(ptr+1, UNTRACED REF CHAR)^)),
	      Word.Plus(
		Word.Times(2, ORD(LOOPHOLE(ptr+2, UNTRACED REF CHAR)^)),
		Word.Plus(
		  ORD(LOOPHOLE(ptr+3, UNTRACED REF CHAR)^),
		  10*CharOffset)))));
      a :=
	Word.Plus(
	  a,
	  Word.Plus(
	    ORD(ptr^),
	    Word.Plus(
	      ORD(LOOPHOLE(ptr+1, UNTRACED REF CHAR)^),
	      Word.Plus(
		ORD(LOOPHOLE(ptr+2, UNTRACED REF CHAR)^),
		Word.Plus(
		  ORD(LOOPHOLE(ptr+3, UNTRACED REF CHAR)^),
		  4*CharOffset)))));

      INC(ptr, 4);
    END;

    WHILE ptr < limit DO
      a := Word.Plus(a, ORD(ptr^)+CharOffset);
      b := Word.Plus(b, a);
      INC(ptr);
    END;
    RETURN Word.Or(Word.Shift(Word.And(b, 16_ffff), 16), Word.And(a, 16_ffff));
  END BlockRsum;

(*****************************************************************************)

CONST
  HashBits = 14;
  HashMask = Word.Not(Word.Shift(Word.Not(0), HashBits));
  HashShift = (Word.Size - HashBits) DIV 2;

(* To hash a rolling checksum, we take its middle "HashBits" bits. *)

TYPE
  HashTab = ARRAY [0..HashMask] OF INTEGER;

  DiffIteratorRep = DiffIterator OBJECT
    rf: T;
    ptr: UNTRACED REF CHAR;		(* Start of checksummed block. *)
    rsum: Word.T;
    blocks: REF ARRAY OF RsyncBlock.T;
    seqVec: REF ARRAY OF CARDINAL := NIL; (* Block # => "blocks" index. *)
    hashTab: REF HashTab := NIL;
  OVERRIDES
    next := DiffIteratorNext;
  END;

PROCEDURE DiffIteratorNext(di: DiffIteratorRep;
                           wr: Wr.T;
			   VAR blocks: BlockRange): BOOLEAN
  RAISES {Thread.Alerted, Wr.Failure} =
  VAR
    hash: Word.T;
    blockIndex := -1;
    blockNum: CARDINAL;
    a, b: Word.T;
    buff: ARRAY [0..8191] OF CHAR;
    buffCt: CARDINAL := 0;
  BEGIN
    IF di.ptr >= di.rf.limit THEN  (* We have already sent everything. *)
      (* NIL out some pointers in an attempt to get their large
	 amounts of memory collected earlier. *)
      di.blocks := NIL;
      di.seqVec := NIL;
      di.hashTab := NIL;
      RETURN FALSE;
    END;

    (* Scan forward, copying characters, until we find a matching block
       or we reach the end of the file. *)
    VAR
      limit := di.rf.limit;
      blockSize := di.rf.blockSize;
      hashTab := di.hashTab;
      rsum := di.rsum;
      ptr := di.ptr;
    BEGIN
      REPEAT
	(* See whether the client has a block matching our current one. *)
	IF limit - ptr >= blockSize AND hashTab # NIL THEN
	  (* It's worth looking for a matching block. *)
	  hash := Word.Extract(rsum, HashShift, HashBits);
	  blockIndex := hashTab[hash];
	  IF blockIndex >= 0 THEN  (* A block matches the hash. *)
	    di.ptr := ptr;
	    di.rsum := rsum;
	    blockIndex := FindMatch(di, hash, blockIndex);
	    IF blockIndex >= 0 THEN EXIT END;  (* Found a match. *)
	  END;
	END;

	(* No matching block at this position; output the character. *)
	IF buffCt >= NUMBER(buff) THEN  (* Flush buffer. *)
	  Wr.PutString(wr, buff);
	  buffCt := 0;
	END;
	buff[buffCt] := ptr^;
	INC(buffCt);

	(* Update the checksum, if we're going to use it. *)
	IF limit - (ptr+1) >= blockSize
	AND hashTab # NIL THEN
	  a := Word.And(rsum, 16_ffff);
	  b := Word.And(Word.RightShift(rsum, 16), 16_ffff);

	  (* Unchecksum the first character of the block. *)
	  WITH ch = ORD(ptr^) + CharOffset DO
	    a := Word.Minus(a, ch);
	    b := Word.Minus(b, Word.Times(blockSize, ch));
	  END;

	  (* Checksum the character just entering the block. *)
	  WITH ch = ORD(LOOPHOLE(ptr+blockSize, UNTRACED REF CHAR)^)
	  + CharOffset DO
	    a := Word.Plus(a, ch);
	    b := Word.Plus(b, a);
	  END;

	  rsum := Word.Or(Word.Shift(Word.And(b, 16_ffff), 16),
	    Word.And(a, 16_ffff));
	END;

	INC(ptr);  (* Advance the block. *)
      UNTIL ptr >= limit;

      IF buffCt > 0 THEN  (* Write out the remaining buffered characters. *)
	Wr.PutString(wr, SUBARRAY(buff, 0, buffCt));
	buffCt := 0;
      END;

      IF blockIndex >= 0 THEN  (* Found a matching block. *)
	blocks.start := di.blocks[blockIndex].num;
	blockNum := blocks.start;

	(* Scan forward through consecutive blocks until we find one that
	   doesn't match. *)
	REPEAT
	  (* Advance past the matching block. *)
	  INC(blockNum);
	  INC(ptr, blockSize);

	  (* Bail out if there are no more complete blocks, or if we've
	     just matched the last block of the client's file. *)
	  IF limit - ptr < blockSize OR blockNum > LAST(di.seqVec^) THEN
	    EXIT;
	  END;

	  blockIndex := di.seqVec[blockNum];
	UNTIL NOT MD5Digest.Equal(di.blocks[blockIndex].md5,
	  BlockMD5(ptr, blockSize));

	IF limit - ptr >= blockSize THEN  (* Compute rolling checksum. *)
	  rsum := BlockRsum(ptr, blockSize);
	END;

	blocks.count := blockNum - blocks.start;
      ELSE
	blocks.start := 0;
	blocks.count := 0;
      END;

      di.ptr := ptr;
      di.rsum := rsum;
      RETURN TRUE;
    END;
  END DiffIteratorNext;

PROCEDURE FindMatch(di: DiffIteratorRep;
                    hash: Word.T;
		    blockIndex: INTEGER): INTEGER =
(* Returns index of matching block, or -1 if no match. *)
  VAR
    md5: MD5Digest.T;
    needMD5 := TRUE;
  BEGIN
    IF blockIndex >= 0 THEN
      REPEAT
	IF di.blocks[blockIndex].rsum = di.rsum THEN
	  (* The full 32-bit checksums match too.  Check the MD5s. *)
	  IF needMD5 THEN
	    md5 := BlockMD5(di.ptr, di.rf.blockSize);
	    needMD5 := FALSE;
	  END;
	  IF MD5Digest.Equal(di.blocks[blockIndex].md5, md5) THEN  (* Found. *)
	    RETURN blockIndex;
	  END;
	END;
	INC(blockIndex);
      UNTIL blockIndex > LAST(di.blocks^)
      OR Word.Extract(di.blocks[blockIndex].rsum, HashShift, HashBits) # hash;
    END;
    RETURN -1;
  END FindMatch;

PROCEDURE HashCompare(READONLY a, b: RsyncBlock.T): [-1..1] =
  VAR
    aHash := Word.Extract(a.rsum, HashShift, HashBits);
    bHash := Word.Extract(b.rsum, HashShift, HashBits);
  BEGIN
    IF aHash < bHash THEN RETURN -1 END;
    IF aHash > bHash THEN RETURN 1 END;
    RETURN 0;
  END HashCompare;

PROCEDURE IterateDiffs(rf: T;
                       blocks: REF ARRAY OF RsyncBlock.T): DiffIterator =
  VAR
    di: DiffIteratorRep;
    hashTabIndex: CARDINAL;
    hash: Word.T;
  BEGIN
    di := NEW(DiffIteratorRep,
      rf := rf,
      ptr := rf.start,
      blocks := blocks);

    IF NUMBER(blocks^) > 0 AND rf.size >= rf.blockSize THEN
      RsyncBlockArraySort.Sort(di.blocks^, HashCompare);

      di.seqVec := NEW(REF ARRAY OF CARDINAL, NUMBER(di.blocks^));
      di.hashTab := NEW(REF HashTab);

      hashTabIndex := 0;
      FOR blockIndex := FIRST(di.blocks^) TO LAST(di.blocks^) DO
	di.seqVec[di.blocks[blockIndex].num] := blockIndex;

	hash := Word.Extract(di.blocks[blockIndex].rsum, HashShift, HashBits);
	IF hash >= hashTabIndex THEN  (* Not a repeat of previous hash *)
	  FOR hti := hashTabIndex TO hash-1 DO
	    di.hashTab[hti] := -1;
	  END;
	  di.hashTab[hash] := blockIndex;
	  hashTabIndex := hash + 1;
	END;
      END;
      FOR hti := hashTabIndex TO LAST(di.hashTab^) DO
	di.hashTab[hti] := -1;
      END;

      di.rsum := BlockRsum(di.ptr, rf.blockSize);
    END;

    RETURN di;
  END IterateDiffs;

BEGIN
END RsyncFile.
