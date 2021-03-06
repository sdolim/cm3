(* Copyright 2000-2001 Olaf Wagner.
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
 *      This product includes software developed by Olaf Wagner.
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

INTERFACE ClientClass;

IMPORT Logger, Rd, Thread;

EXCEPTION Error(TEXT);

TYPE
  T <: Public;
  (*
    A ClientClass.T represents an entry of the cvsupd.class configuration
    file and defines the access rights of a client that belongs to a specific
    class. The syntax for an entry looks like this:
    |  classname:\
    |    :collection-dirs=path1,path2,...,pathn:\
    |    :collections=coll1,coll2,coll3,...,colln:\
    |    :opaque-collections=coll1,coll2,coll3,...,colln:\
    |    :branches=pat1,pat2,pat3,...,patn:\
    |    :branches/coll=pat1,pat2,...,patn:\
    |    :tags=pat1,pat2,pat3,...,patn:\
    |    :tags/coll=pat1,pat2,...,patn:\
    |    :maxconnections=n:
    I.E. every entry consists of fields separated by colons; empty fields are
    ignored. A \ as the last character in the line indicates that the entry
    continues with the next line. Lines beginning with # are considered
    comments.

    The first field of an entry is the classname, which is used to identity
    and retrieve an entry. All other entries define name->value mappings, with
    an equal sign separating name and value. Names may have additional
    specifiers separated by a slash. Values can be arbitrary strings or
    numbers or lists of these elements. Whitespace in values is significant.

    The current version accepts only the following names for mappings:
    collection-dirs, collections, opaque-collections,
    partially-hidden-collections, branches, tags,
    maxconnections. Branches and tags may be followed by an collection
    name and may occur multiple times for different collections.

    The intended semantics are to allow a client belonging to a specified
    class only to access the collections, branches, and tags which are
    specified in its corresponding cvsupd.class entry. Maxconnections defines
    the maximum simultaneous client connections for one class. The values for
    the other elements are regular expressions and used to match against
    concrete values at runtime.
  *)
  Public = OBJECT
    name: TEXT;
    (* class name for back references without DB*)

    maxConnections: INTEGER;
    (* maximal simultaneous client connections *)

  METHODS
    init(rd: Rd.T): T RAISES {Error, Rd.Failure, Thread.Alerted};
    (* initialize an entry from a stream *)

    initDefaultFree(): T;
    (* initialize a default entry granting free access *)

    inAllowedCollectionDirs(collDir : TEXT): BOOLEAN;
    (* <=> collDir is matched by an element in the allowed collection
       directories *)

    inAllowedCollections(coll : TEXT): BOOLEAN;
    (* <=> coll is matched by an element in allowed collections *)

    inAllowedCollectionBranches(coll, branch : TEXT): BOOLEAN;
    (* <=> branch is matched by an element in the list of allowed branches
           for collection coll *)

    inAllowedCollectionTags(coll, tag : TEXT): BOOLEAN;
    (* <=> tag is matched by an element in the list of allowed tags for
           collection coll *) 

    inPartiallyHiddenCollections(coll : TEXT): BOOLEAN;
    (* <=> coll is matched by an element in partially hidden collections *)

    collectionIsPartiallyHidden(coll : TEXT): BOOLEAN;
    (* <=> This class restricts the access to certain branches and/or
       tags of the given collection, or is explicitly specified
       as an opaque collection. *)
  END;

  (*
    A ClientClass.DB represents a complete cvsupd.class file. It can be
    initialized from a reader or (for convenience) from a
    filename. ClientClass objects can be retrieved by class name.
  *)

  DB <: DBPublic;

  DBPublic = OBJECT
  METHODS
    init(fn: TEXT; logger: Logger.T := NIL): DB
      RAISES {Rd.Failure, Thread.Alerted};
    (* Initialize the DB from file fn, i.e. add all definitions from
       this file. Simply opens the file and calls initFromRd.
       Syntactic and semantic errors are logged to "logger" if it is
       not NIL.
    *)

    initFromRd(rd: Rd.T; logger: Logger.T := NIL): DB
      RAISES {Rd.Failure, Thread.Alerted};
    (* Initialize the DB by reading entries from stream rd until EOF.
       Syntactic and semantic errors are logged to "logger" if it is
       not NIL.
    *)

    getClass(name: TEXT) : T;
    (* Retrieve an object describing the given client class. Returns NIL if
       none is found. *)
  END;

PROCEDURE FreeAccessDB() : DB;
  (* Return a DB with a default entry granting any access. *)

VAR debugLevel := 0; (* emit debug output if > 0 *)

END ClientClass.
