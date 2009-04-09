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

MODULE BackoffTimer;

IMPORT Random, Thread, Time;

REVEAL
  T = BRANDED OBJECT
    min, max: Time.T;
    backoff: REAL;
    jitter: REAL;
    random: Random.T;
    interval: Time.T;
  END;

PROCEDURE New(min, max: Time.T;
              backoff: REAL;
	      jitter: REAL): T =
  VAR
    bt: T;
  BEGIN
    bt := NEW(T,
      min := min,
      max := max,
      backoff := backoff,
      jitter := jitter,
      random := NEW(Random.Default).init(),
      interval := min);
    AddJitter(bt);
    RETURN bt;
  END New;

PROCEDURE Pause(bt: T) =
  BEGIN
    Thread.Pause(bt.interval);
    Update(bt);
  END Pause;

PROCEDURE AlertPause(bt: T)
  RAISES {Thread.Alerted} =
  BEGIN
    Thread.AlertPause(bt.interval);
    Update(bt);
  END AlertPause;

PROCEDURE Get(bt: T): Time.T =
  BEGIN
    RETURN bt.interval;
  END Get;

PROCEDURE AddJitter(bt: T) =
  BEGIN
    WITH mag = FLOAT(bt.jitter, LONGREAL) * bt.interval DO
      bt.interval := bt.interval + bt.random.longreal(-mag, mag);
    END;
  END AddJitter;

PROCEDURE Update(bt: T) =
  BEGIN
    bt.interval := MIN(bt.interval * FLOAT(bt.backoff, LONGREAL), bt.max);
    AddJitter(bt);
  END Update;

BEGIN
END BackoffTimer.
