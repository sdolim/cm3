
MODULE HTML;

IMPORT IntArraySort, Text, Thread, Wr;
IMPORT ConfigItem, Default, ID, M3MarkUp, Node, Text2, Wx;
IMPORT ErrLog, Fmt;

VAR
  viewID := ID.Add ("view");

PROCEDURE PutImg (name: TEXT;  wx: Wx.T)
  RAISES {Wr.Failure, Thread.Alerted} =
  BEGIN
    IF (wx # NIL) THEN
      wx.put ("<IMG src=\"/rsrc/", name,
              ".gif\" height=20 width=20 align=\"bottom\" border=0>");
    END;
  END PutImg;

PROCEDURE PutSmallImg (name: TEXT;  wx: Wx.T)
  RAISES {Wr.Failure, Thread.Alerted} =
  BEGIN
    IF (wx # NIL) THEN
      wx.put ("<IMG src=\"/rsrc/", name,
              ".gif\" height=16 width=16 align=\"bottom\" border=0>");
    END;
  END PutSmallImg;

PROCEDURE ImgRef (name: TEXT): TEXT =
  BEGIN
    RETURN "<IMG src=\"/rsrc/" & name
           & ".gif\" height=24 width=24 align=\"bottom\" border=0>";
  END ImgRef;

PROCEDURE ViewOnly (act: ID.T;  data: Node.FormData;  wx: Wx.T)
  RAISES {Wr.Failure, Thread.Alerted} =
  BEGIN
    IF (act # viewID) THEN NoAction (act, wx); END;
    IF (data # NIL) THEN NoData (data, wx); END;
  END ViewOnly;

PROCEDURE NoAction (act: ID.T;  wx: Wx.T)
  RAISES {Wr.Failure, Thread.Alerted} =
  BEGIN
    wx.put ("\n<P>\n<STRONG>Action [", ID.ToText (act),
                 "] is not supported here.</STRONG>\n");
  END NoAction;

PROCEDURE NoData (data: Node.FormData;  wx: Wx.T)
  RAISES {Wr.Failure, Thread.Alerted} =
  BEGIN
    IF (data # NIL) THEN
      wx.put ("\n<P>\n",
              "<STRONG>This node does not support HTTP FORM data.</STRONG>\n");
    END;
  END NoData;

PROCEDURE MakeURL (a, b, c, d: TEXT := NIL): TEXT =
  CONST SLASH = "/";
  VAR path := a;
  BEGIN
    IF (b # NIL) THEN path := path & SLASH & b END;
    IF (c # NIL) THEN path := path & SLASH & c END;
    IF (d # NIL) THEN path := path & SLASH & d END;
    RETURN path;
  END MakeURL;

PROCEDURE Begin (n: Node.T;  wx: Wx.T)
  RAISES {Wr.Failure, Thread.Alerted} =
  VAR
    c     := n.class ();
    title := Node.ClassName [c];
    name  := n.printname ();
    icon  := Node.ClassIcon [c];
  BEGIN
(** IF (icon = NIL) THEN icon := "unknown"; END;  **)
    BeginYY (n, wx, title, ": ", name);
    wx.put ("<H3>");
    IF (icon # NIL) THEN PutImg (icon, wx); wx.put (" "); END;
    wx.put (title, ": ", name);
    wx.put ("</H3>\n");
    GenPathFinder (n, wx);
  END Begin;

PROCEDURE BeginXX (n: Node.T;  wx: Wx.T;  t1, t2, t3, icon: TEXT := NIL)
  RAISES {Wr.Failure, Thread.Alerted} =
  BEGIN
(** IF (icon = NIL) THEN icon := "unknown"; END;  **)
    BeginYY (n, wx, t1, t2, t3);
    wx.put ("<H3>");
    IF (icon # NIL) THEN PutImg (icon, wx); wx.put (" "); END;
    wx.put (t1, t2, t3);
    wx.put ("</H3>\n");
    GenPathFinder (n, wx);
  END BeginXX;

PROCEDURE BeginYY (n: Node.T;  wx: Wx.T;  t1, t2, t3: TEXT := NIL)
  RAISES {Wr.Failure, Thread.Alerted} =
  VAR window: TEXT;
  BEGIN
    wx.put ("Content-type: text/html\n");
    (*** IF (n # NIL) THEN GenLocation (n, wx); END;  **)
    IF (n # NIL) AND ConfigItem.X[ConfigItem.T.Use_multiple_windows].bool THEN
      window:= Node.ClassWindow [n.class ()];
      IF (window # NIL) THEN wx.put ("Window-target: ", window, "\n"); END;
    END;
    wx.put ("\n<HTML>\n<HEAD>\n");
    IF (n # NIL) THEN GenBase (n, wx); END;
    wx.put ("<TITLE>", t1, t2, t3);
    wx.put ("</TITLE>\n</HEAD>\n<BODY BGCOLOR=\"#ffffff\">\n");
  END BeginYY;

PROCEDURE End (wx: Wx.T)
  RAISES {Wr.Failure, Thread.Alerted} =
  BEGIN
    GenCopyright (wx);
    wx.put ("</BODY>\n</HTML>\n");
  END End;

PROCEDURE GenCopyright (wx: Wx.T)
  RAISES {Wr.Failure, Thread.Alerted} =
  (* Write the copyright legend on "wx".  
  For the open-source release, Farshad Nayeri requires that this legend appear on all pages served by CM3-IDE. *)
  BEGIN
    wx.put ("<center>\n<p>\n<hr>\n<font size=\"-3\">\n");
    wx.put ("&copy;1996-1999 <a href=\"http://www.igencorp.com/cmass/\">Critical Mass, Inc.</a>, \n");
    wx.put ("&copy;1998-2008 <a href=http://www.igencorp.com/cmass/reactor/>IGEN Corporation</a>.&nbsp;&nbsp;\n");
    wx.put ("All Rights Reserved.&nbsp;&nbsp;\n");
    wx.put ("<a href=\"/rsrc/license.html\">License</a> | <a href=\"/rsrc/about.html\">About</a>");
    wx.put (" | <a href=\"/\">Home</a>\n");
    wx.put ("<hr/>\n</font>\n</p>\n</center>\n");
  END GenCopyright;

PROCEDURE GenPathFinder (n: Node.T;  wx: Wx.T)
  RAISES {Wr.Failure, Thread.Alerted} =
  VAR arcs : ARRAY [0..19] OF Node.T;    len: CARDINAL := 0;  nc: Node.Class;
  BEGIN
    IF (n # NIL) THEN  len := Node.FindArcs (n, arcs);  END;
    wx.put ("<H5>&nbsp;&nbsp;");
    wx.put ("<A HREF=\"/\">");
    PutSmallImg ("unknown", wx);
    wx.put ("</A>&nbsp;<A HREF=\"/\">CM3-IDE</A>");
    FOR i := 0 TO len-1 DO
      n := arcs[i];
      IF (n # NIL) THEN
        wx.put ("&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;");
        nc := n.class ();
        IF Node.ClassIcon[nc] # NIL THEN
          GenRef (n, wx);
          PutSmallImg (Node.ClassIcon[nc], wx);
          wx.put ("</A>&nbsp;");
        END;
        GenRef (n, wx); wx.put (n.printname(), "</A>");
      END;
    END;
    wx.put ("</H5>\n");
  END GenPathFinder;

(*****
PROCEDURE GenLocation (n: Node.T;  wx: Wx.T)
  RAISES {Wr.Failure, Thread.Alerted} =
  VAR
    arcs : ARRAY [0..19] OF Node.T;
    len  := Node.FindArcs (n, arcs);
  BEGIN
    wx.put ("Location: ", Default.server_href);
    FOR i := 0 TO len-1 DO
      wx.put (ID.ToText (arcs[i].arcname()), "/");
    END;
    wx.put ("\n");
  END GenLocation;
*****)

PROCEDURE GenBase (n: Node.T;  wx: Wx.T;  leaf := FALSE)
  RAISES {Wr.Failure, Thread.Alerted} =
  VAR
    arcs : ARRAY [0..19] OF Node.T;
    len  := Node.FindArcs (n, arcs);
  BEGIN
    wx.put ("<BASE HREF=\"", Default.server_href);
    FOR i := 0 TO len-1 DO
      wx.put (ID.ToText (arcs[i].arcname()));
      IF (NOT leaf) OR (i < len-1) THEN wx.put ("/"); END;
    END;
    wx.put ("\">\n");
  END GenBase;

PROCEDURE GenFileRef (path: TEXT;  wx: Wx.T)
  RAISES {Wr.Failure, Thread.Alerted} =
  CONST BackSlash = '\134';
  VAR start, len: INTEGER;  ch: CHAR;
  BEGIN
    IF (path = NIL) THEN RETURN END;
    wx.put ("<A HREF=\"file:");
    start := 0;
    len := Text.Length (path);
    IF NOT Default.on_unix AND (len > 2) AND Text.GetChar (path, 1) = ':' THEN
      (* Windows-style  "Volume:path"  ==>  "/Volume|/" *)
      wx.put ("/");
      wx.putChar (Text.GetChar (path, 0));
      wx.put ("|");
      start := 2;
      IF (len < 3) OR Text.GetChar (path, 2) # BackSlash THEN
        wx.put ("/");
      END;
    END;
    WHILE (start < len) DO
      ch := Text.GetChar (path, start);
      IF (ch = BackSlash) THEN ch := '/'; END;
      wx.putChar (ch);
      INC (start);
    END;
    wx.put ("\">");
  END GenFileRef;

PROCEDURE GenRef (n: Node.T;  wx: Wx.T;  tag: TEXT := NIL)
  RAISES {Wr.Failure, Thread.Alerted} =
  BEGIN
    wx.put ("<A HREF=\"");
    GenURL (n, wx);
    IF (tag # NIL) THEN
      wx.put ("#", tag);
    ELSIF Node.ClassHasDecl [n.class()] THEN
      wx.put ("#", M3MarkUp.ThisDecl);
    END;
    wx.put ("\">");
  END GenRef;

PROCEDURE GenActionRef (n: Node.T;  wx: Wx.T;  action: TEXT;  tag: TEXT := NIL)
  RAISES {Wr.Failure, Thread.Alerted} =
  BEGIN
    wx.put ("<A HREF=\"");
    GenURL (n, wx);
    wx.put ("[", action, "]");
    IF (tag # NIL) THEN
      wx.put ("#", tag);
    ELSIF Node.ClassHasDecl [n.class()] THEN
      wx.put ("#", M3MarkUp.ThisDecl);
    END;
    wx.put ("\">");
  END GenActionRef;

PROCEDURE GenURL (n: Node.T;  wx: Wx.T)
  RAISES {Wr.Failure, Thread.Alerted} =
  VAR
    arcs : ARRAY [0..19] OF Node.T;
    len  := Node.FindArcs (n, arcs);
  BEGIN
    FOR i := 0 TO len-1 DO
      wx.put ("/", ID.ToText (arcs[i].arcname()));
    END;
    wx.put ("/"); (* make every node look like a directory to the browsers *)
  END GenURL;

PROCEDURE NodeURL (n: Node.T): TEXT =
  VAR
    arcs : ARRAY [0..19] OF Node.T;
    len  := Node.FindArcs (n, arcs);
    url  : TEXT := Default.server_href;
  BEGIN
    FOR i := 0 TO len-1 DO
      url := url & ID.ToText (arcs[i].arcname()) & "/";
    END;
    IF Node.ClassHasDecl [n.class()] THEN
      url := url & "#" & M3MarkUp.ThisDecl;
    END;
    RETURN url;
  END NodeURL;

(*-------------------------------------------------- choice generation ---*)

TYPE
  NodeInfo = REF ARRAY OF NodeDesc;
  NodeDesc = RECORD
    node    : Node.T;
    full_nm : NameDesc;
    cur_nm  : NameDesc;
    chopped : BOOLEAN; (* => name chopped & represents more than one node *)
    multi   : BOOLEAN; (* => represents more than one node *)
  END;

  NameDesc = RECORD start, len: CARDINAL; END;

  Presentation = RECORD
    names         : TextVec;
    map           : IntVec;
    n_mapped      : CARDINAL;  (* # of valid entries in the map[] array *)
    prefix_skip   : CARDINAL;  (* # of arcs to skip in the common prefix *)
    suffix_skip   : CARDINAL;  (* # of arcs to skip in the common suffix *)
    max_name      : CARDINAL;  (* # of arcs in longest name w/o prefix or suffix*)
    display_limit : INTEGER;
    max_items     : INTEGER;
    max_width     : INTEGER;
    max_columns   : INTEGER;
    verbose       : BOOLEAN;
  END;

PROCEDURE GenChoices (VAR results: Node.Set;  wx: Wx.T)
  RAISES {Wr.Failure, Thread.Alerted} =
  VAR
    n_classes     := 0;
    cc            : Node.Class;
    cnts          : ARRAY Node.Class OF INTEGER;
    limit         : INTEGER;
    start         : INTEGER;
    tag           : TEXT;
    nodes         : NodeInfo;
    pres          : Presentation;
    n_small_items : INTEGER;
    n_big_classes : INTEGER;
  BEGIN
    IF (results.cnt <= 0) THEN
      wx.put ("<P><STRONG>No results</STRONG>\n");
      RETURN;
    END;

    Node.Squash (results);

    (* count the choices in each node class *)
    FOR c := FIRST (cnts) TO LAST (cnts) DO cnts[c] := 0; END;
    FOR i := 0 TO results.cnt - 1 DO  INC (cnts [results.elts[i].class()]);  END;
    FOR c := FIRST (cnts) TO LAST (cnts) DO
      IF (cnts[c] > 0) THEN INC (n_classes);  cc := c;  END;
    END;

    GetNameInfo (SUBARRAY (results.elts^, 0, results.cnt), nodes, pres);

    IF n_classes = 1 THEN
      wx.put ("<P><STRONG>");
      PutImg (Node.ClassIcon [cc], wx);
      wx.put (" ", Node.ClassPlural [cc], ":</STRONG>\n");
      WITH nn = SUBARRAY (nodes^, 0, results.cnt) DO
        pres.display_limit := pres.max_items;
        SelectPresentation (nn, pres);
        PrintSuffix (wx, nn, pres);
        GenDir (wx, nn, pres, NIL, FALSE);
      END;
    ELSE
      IF (results.cnt <= pres.max_items) THEN
        (* the total number of nodes to display is not too
           big, don't bother limiting any of the per-class displays *)
        limit := pres.max_items;
      ELSE
        (* we need to split up the total number of display items
           between several different node classes.  First, find
           "small" classes and remove them from the pool. *)
        limit := MAX (10, pres.max_items DIV n_classes);
        n_small_items := 0;  n_big_classes := 0;
        FOR c := FIRST (cnts) TO LAST (cnts) DO
          IF (cnts[c] <= limit)
            THEN INC (n_small_items, cnts[c]);
            ELSE INC (n_big_classes);
          END;
        END;
        IF (n_big_classes > 0) THEN
          (* Then, divide up the remaining space among the remaining classes. *)
          limit := MAX (limit, (pres.max_items - n_small_items)
                                DIV n_big_classes);
        END;
      END;
      start := 0;
      FOR c := FIRST (cnts) TO LAST (cnts) DO
        IF (cnts[c] > 0) THEN
          tag := Node.ClassTag [c];
          wx.put ("<P><STRONG>");
          IF (tag # NIL) THEN  wx.put ("<A HREF=\"./", tag, "/\">");  END;
          PutImg (Node.ClassIcon [c], wx);
          wx.put (" ", Node.ClassPlural [c], ":");
          IF (tag # NIL) THEN  wx.put ("</A>");  END;
          wx.put ("</STRONG>");
          WITH nn = SUBARRAY (nodes^, start, cnts[c]) DO
            pres.display_limit := limit;
            SelectPresentation (nn, pres);
            PrintSuffix (wx, nn, pres);
            GenDir (wx, nn, pres, tag, TRUE);
          END;
          INC (start, cnts[c]);
        END;
      END;
    END;
    wx.put ("<ISINDEX prompt=\"Find \">\n");
  END GenChoices;

PROCEDURE PrintSuffix (wx    : Wx.T;
              READONLY nodes : ARRAY OF NodeDesc; 
              READONLY pres  : Presentation)
  RAISES {Wr.Failure, Thread.Alerted} =
  BEGIN
    IF (pres.suffix_skip > 0) THEN
      wx.put ("&nbsp;&nbsp<TT>...");
      WITH z = nodes[0].full_nm DO
        FOR i := - pres.suffix_skip TO -1 DO
          wx.put ("/", pres.names [z.start + z.len + i]);
        END;
      END;
      wx.put ("</TT>");
    END;
    wx.put ("\n");
  END PrintSuffix;

PROCEDURE GetNameInfo (READONLY nodes: ARRAY OF Node.T;
                       VAR(*OUT*) info: NodeInfo;
                       VAR(*OUT*) pres: Presentation) =
  VAR
    n := NUMBER (nodes);
    n_nms := 0;
    arcs: ARRAY [0..19] OF Node.T;
  BEGIN
    info := NEW (NodeInfo, n);

    pres.names         := NEW (TextVec, 10 * n);
    pres.map           := NEW (IntVec, n);
    pres.n_mapped      := 0;
    pres.prefix_skip   := 0;
    pres.suffix_skip   := 0;
    pres.max_name      := 0;
    pres.verbose       := ConfigItem.X[ConfigItem.T.Verbose_display].bool;
    pres.max_items     := ConfigItem.X[ConfigItem.T.Max_display_items].int;
    pres.max_width     := ConfigItem.X[ConfigItem.T.Max_display_width].int;
    pres.max_columns   := ConfigItem.X[ConfigItem.T.Max_display_columns].int;
    pres.display_limit := pres.max_items;

    (* extract each node's full name *)
    FOR i := 0 TO n-1 DO
      WITH z = info[i] DO
        z.node          := nodes[i];
        z.full_nm.start := n_nms;
        z.full_nm.len   := Node.FindArcs (z.node, arcs);
        z.cur_nm.start  := z.full_nm.start;
        z.cur_nm.len    := z.full_nm.len;
        z.chopped       := FALSE;
        z.multi         := FALSE;
        FOR j := 0 TO z.full_nm.len-1 DO
          pres.names[j + n_nms] := arcs[j].printname ();
        END;
        INC (n_nms, z.full_nm.len);
      END;
    END;
  END GetNameInfo;

PROCEDURE SelectPresentation (VAR x     : ARRAY OF NodeDesc; 
                              VAR pres  : Presentation) =
  VAR best_len, best_cnt: CARDINAL;
  BEGIN
    IF pres.verbose THEN
      ErrLog.Msg ("-------- ", Fmt.Int (NUMBER (x)), " nodes -----------");
    END;
    IF NUMBER (x) = 1 THEN
      (* don't bother with the rest of the machinations... *)
      WITH z = x[0] DO
        pres.map[0]      := 0;
        pres.n_mapped    := 1;
        pres.prefix_skip := MAX (0, z.full_nm.len - 1);
        pres.suffix_skip := 0;
        pres.max_name    := 1;
        z.cur_nm.len     := 1;
        z.cur_nm.start   := z.full_nm.start + pres.prefix_skip;
        z.multi          := FALSE;
        z.chopped        := FALSE;
      END;
      RETURN;
    END;

    (* find and ignore the common prefixes and suffixes *)
    FindCommon (x, pres);

    (* is the last arc enough to produce a decent list? *)
    SortByName (x, pres, 1);

    IF (pres.n_mapped > pres.display_limit) THEN
      (* yep, there's lots of unique names, lets see if we can
         reduce the size of the set by chopping any of the names *)
      IF pres.verbose THEN
        ErrLog.Msg ("display limit: ", Fmt.Int (pres.display_limit),
                    " => reducing...");
      END;
      FindPrefixClasses (x, pres);

    ELSE (* pres.n_mapped <= pres.display_limit *)
      IF pres.verbose THEN
        ErrLog.Msg ("display limit: ", Fmt.Int (pres.display_limit),
                    " => expanding...");
      END;
      (* the list doesn't seem too big yet.  Lets see if we can
         increase the number of unique names by adding arcs and
         yet stay near the display limit *)
      best_len := 1;  best_cnt := pres.n_mapped;
      FOR len := 2 TO pres.max_name DO
        IF (pres.n_mapped >= NUMBER (x))
        OR (pres.n_mapped >= pres.display_limit) THEN
          (* don't bother trying to expand the list any further *)
          IF (best_len # len-1) THEN
            (* the last sort wasn't the best one... *)
            SortByName (x, pres, best_len);
          END;
          EXIT;
        END;
        SortByName (x, pres, len);
        IF ABS (pres.display_limit - pres.n_mapped)
            < ABS (pres.display_limit - best_cnt) THEN
          (* we found a better candidate *)
          best_len := len;
          best_cnt := pres.n_mapped;
        END;
      END;
    END;
  END SelectPresentation;

PROCEDURE FindCommon (READONLY x   : ARRAY OF NodeDesc;
                           VAR pres: Presentation) =
  (* find the longest common prefix and suffix in the names of "x" *) 
  VAR cur_len, shortest, j: CARDINAL;
  BEGIN
    (* find the shortest name *)
    shortest := LAST (INTEGER);
    FOR i := 0 TO LAST (x) DO
      shortest := MIN (shortest, x[i].full_nm.len);
    END;

    (* find the longest common prefix *)
    WITH nm0 = x[0].full_nm DO
      cur_len := shortest;
      FOR i := 1 TO LAST (x) DO
        WITH nm1 = x[i].full_nm DO
          cur_len := MIN (cur_len, nm1.len);
          j := 0;
          WHILE (j < cur_len) AND Text.Equal (pres.names [nm0.start + j],
                                              pres.names [nm1.start + j]) DO
            INC (j);
          END;
          cur_len := j;
        END;
        IF (cur_len <= 0) THEN EXIT; END;
      END;
    END;
    pres.prefix_skip := cur_len;

    (* find the longest common suffix *)
    WITH nm0 = x[0].full_nm, z0 = nm0.start + nm0.len - 1 DO
      cur_len := shortest;
      FOR i := 1 TO LAST (x) DO
        WITH nm1 = x[i].full_nm, z1 = nm1.start + nm1.len - 1 DO
          cur_len := MIN (cur_len, nm1.len);
          j := 0;
          WHILE (j < cur_len) AND Text.Equal (pres.names [z0 - j],
                                              pres.names [z1 - j]) DO
            INC (j);
          END;
          cur_len := j;
        END;
        IF (cur_len <= 0) THEN EXIT; END;
      END;
    END;
    pres.suffix_skip := cur_len;

    (* find the longest name after removing the common prefixes and suffixes *)
    pres.max_name := 1;
    FOR i := 0 TO LAST (x) DO
      pres.max_name := MAX (pres.max_name, x[i].full_nm.len);
    END;
    pres.max_name := MAX (1, pres.max_name - pres.prefix_skip - pres.suffix_skip);

    IF pres.verbose THEN
      ErrLog.Msg ("common prefix: ", Fmt.Int (pres.prefix_skip)
                & "  suffix: ", Fmt.Int (pres.suffix_skip)
                & "  remaining: ", Fmt.Int (pres.max_name));
    END;
  END FindCommon;

PROCEDURE SortByName (VAR x      : ARRAY OF NodeDesc;
                      VAR pres   : Presentation;
                          n_arcs : CARDINAL) =

  PROCEDURE Cmp (a, b: INTEGER): [-1 .. +1] =
    VAR len_a, len_b: INTEGER;  cmp: [-1..+1];
    BEGIN
      WITH za = x[a], zb = x[b] DO
        len_a := za.cur_nm.len;
        len_b := zb.cur_nm.len;
        FOR i := 0 TO MIN (len_a, len_b) - 1 DO
          cmp := Text.Compare (pres.names [za.cur_nm.start + i],
                               pres.names [zb.cur_nm.start + i]);
          IF (cmp # 0) THEN RETURN cmp; END;
        END;
        IF    len_a < len_b THEN RETURN -1;
        ELSIF len_a > len_b THEN RETURN +1;
        ELSE                     RETURN 0;
        END;
      END;
    END Cmp;

  BEGIN
    (* set the current names *)
    FOR i := 0 TO LAST (x) DO
      pres.map[i] := i;
      WITH z = x[i] DO
        z.cur_nm.len   := MAX (1, MIN (n_arcs, z.full_nm.len - pres.prefix_skip
                                                             - pres.suffix_skip));
        z.cur_nm.start := z.full_nm.start + z.full_nm.len
                           - MIN (pres.suffix_skip + z.cur_nm.len,
                                  z.full_nm.len);
      END;
    END;
    IntArraySort.Sort (SUBARRAY (pres.map^, 0, NUMBER (x)), Cmp);
    CountUnique (x, pres);
    IF (pres.verbose) THEN
      ErrLog.Msg ("sorting ", Fmt.Int (n_arcs), " arcs => ",
                  Fmt.Int (pres.n_mapped) & " mapped nodes");
    END;
  END SortByName;

PROCEDURE CountUnique (VAR x    : ARRAY OF NodeDesc;
                       VAR pres : Presentation) =
  VAR
    last_node    := pres.map[0];
    this_node    := 1;
    cur_set_size := 1;
    n_sets       := 1;
  BEGIN
    FOR i := 1 TO LAST (x) DO
      this_node := pres.map[i];
      IF NameEQ (x[last_node].cur_nm, x[this_node].cur_nm, pres) THEN
        (* add this name to the current set *)
        INC (cur_set_size);
      ELSE
        (* we found a unique name, finish the last set and start a new one *)
        x[last_node].multi := (cur_set_size > 1);
        last_node := this_node;
        pres.map[n_sets] := this_node;
        INC (n_sets);
        cur_set_size := 1;
      END;
    END;
    x[last_node].multi := (cur_set_size > 1);

    pres.n_mapped := n_sets;
  END CountUnique;

PROCEDURE NameEQ (READONLY a, b: NameDesc;  READONLY pres: Presentation): BOOLEAN =
  BEGIN
    IF a.len # b.len THEN RETURN FALSE; END;
    FOR i := 0 TO a.len - 1 DO
      IF NOT Text.Equal (pres.names[a.start+i], pres.names[b.start+i]) THEN
        RETURN FALSE;
      END;
    END;
    RETURN TRUE;
  END NameEQ;

(*--------------------------------------------------- find prefix classes ---*)

PROCEDURE FindPrefixClasses (VAR nodes : ARRAY OF NodeDesc;
                             VAR pres  : Presentation) =
  VAR
    len, n, n0, max_len: INTEGER;
    n_names := pres.n_mapped;
    names := NEW (TextVec, n_names);
    cnts := NEW (IntVec, n_names);
    cnts0 := NEW (IntVec, n_names);
    tmp: IntVec;
  BEGIN
    (* extract the names *)
    max_len := 0;
    FOR i := 0 TO n_names-1 DO
      WITH nm = nodes[ pres.map[i] ].cur_nm DO
        <*ASSERT nm.len = 1 *>
        names [i] := pres.names [nm.start];
        max_len := MAX (max_len, Text.Length (names[i]));
      END;
    END;

    (* find a prefix that generates a non-trivial choice *)
    n := 0;  len := 0;
    WHILE (len <= max_len) AND (n < 2) DO
      INC (len);
      n := CntPrefixes (names, cnts, len);
    END;

    (* find the largest prefix that's got fewer than pres.display_limit classes *)
    REPEAT
      n0 := n;
      tmp := cnts0;  cnts0 := cnts;  cnts := tmp;
      INC (len);
      n := CntPrefixes (names, cnts, len);
    UNTIL (len >= max_len) OR ((n # n0) AND (n > pres.display_limit));

    (* pick the best size *)
    IF (pres.display_limit - n0 < n - pres.display_limit) THEN
      (* use the shorter prefix *)
      DEC (len);
      cnts := cnts0;
    END;

    (* finalize the presentation *)
    n0 := 0;
    FOR i := 0 TO n_names-1 DO
      WITH z = nodes[ pres.map[i] ] DO
        pres.map[n0] := pres.map[i];
        IF cnts[i] = 1 THEN
          (* we're keeping this name & it's a singleton *)
          z.chopped := FALSE;
          INC (n0);
        ELSIF cnts[i] > 0 THEN
          (* we're keeping this name, but it represents a prefix-class set *)
          pres.names[z.cur_nm.start] := Text.Sub (names[i], 0, len);
          z.chopped := TRUE;
          INC (n0);
        ELSE
          (* we're discarding this one *)
        END;
      END;
    END;
    pres.n_mapped := n0;
  END FindPrefixClasses;

PROCEDURE CntPrefixes (names: TextVec; VAR cnts: IntVec; len: INTEGER): INTEGER =
  VAR n_classes := 1;  last_class := 0;  short: BOOLEAN;  class_id, xx: TEXT;
  BEGIN
    class_id := names[0];
    short := Text.Length (class_id) < len;
    cnts [0] := 1;
    FOR i := 1 TO LAST (names^) DO
      xx := names[i];
      IF Text2.PrefixMatch (xx, class_id, len) THEN
        INC (cnts[last_class]);
        cnts[i] := 0;
        IF (short) AND (Text.Length (class_id) < Text.Length (xx)) THEN
          (* use 'i' as the class representitive *)
          cnts[i] := cnts[last_class];
          cnts[last_class] := 0;
          class_id := xx;
          short := Text.Length (class_id) < len;
        END;
      ELSE
        class_id := xx;
        short := Text.Length (class_id) < len;
        cnts[i] := 1;
        last_class := i;
        INC (n_classes);
      END;
    END;
    RETURN n_classes;
  END CntPrefixes;

(*---------------------------------------------------- Directory listing ---*)
(* In principle an HTML front-end will do a good job rendering
   a list of names in <DIR></DIR> brackets.  In practice most browsers
   don't.  The following code is intended to compensate. *)

TYPE
  TextVec = REF ARRAY OF TEXT;
  IntVec  = REF ARRAY OF INTEGER;

PROCEDURE GenDir (wx          : Wx.T;
         READONLY nodes       : ARRAY OF NodeDesc;
         READONLY pres        : Presentation;
                  class_tag   : TEXT;
                  multi_class : BOOLEAN)
  RAISES {Wr.Failure, Thread.Alerted} =
  CONST Gap       = 2;  (* inter-column gap *)
  CONST Gap_text  = "  ";
  CONST Indent    = "    ";
  VAR
    Dir_width  : CARDINAL := pres.max_width;
    Max_cols   : CARDINAL := pres.max_columns;
    max_len    := 0;
    n_cols     := 1;
    n_rows     := 1;
    width, j   : CARDINAL;
    nm         : TEXT;
    nm_len     : INTEGER;
  BEGIN
    IF pres.n_mapped <= 0 THEN RETURN END;

    (* find the longest name *)
    max_len := 5;
    FOR i := 0 TO pres.n_mapped - 1 DO
      WITH z = nodes[ pres.map[i] ] DO
        nm_len := z.cur_nm.len - 1; (* separators *)
        IF (z.chopped) OR (z.multi) THEN INC (nm_len, 3); END;
        FOR j := 0 TO z.cur_nm.len - 1 DO
          INC (nm_len, Text.Length (pres.names[z.cur_nm.start + j]));
        END;
      END;
      max_len := MAX (max_len, nm_len);
    END;

    (* compute an approriate layout *)
    INC (max_len, Gap);
    n_cols := MAX (1, MIN (Dir_width DIV max_len, Max_cols));
    n_rows := (pres.n_mapped + n_cols - 1) DIV n_cols;
    width  := Dir_width DIV n_cols - Gap;

    IF (n_rows > 1) OR (NOT multi_class) OR (pres.suffix_skip > 0)
      THEN wx.put ("<PRE>\n");
      ELSE wx.put (" <TT>&nbsp;&nbsp; ");
    END;
    TRY
      FOR row := 0 TO n_rows-1 DO
        wx.put (Indent);
        FOR col := 0 TO n_cols-1 DO
          j := col * n_rows + row;
          IF (j < pres.n_mapped) THEN
            WITH z = nodes[ pres.map [j]] DO
              IF z.chopped THEN
                 <*ASSERT z.cur_nm.len = 1*>
                nm := pres.names [z.cur_nm.start];
                wx.put ("<A HREF=\"./");
                IF (class_tag # NIL) THEN  wx.put (class_tag, "/");  END;
                wx.put (nm, "*\">", nm, "...</A>");
                nm_len := 3 + Text.Length (nm);
              ELSIF z.multi THEN
                wx.put ("<A HREF=\"./");
                FOR i := 0 TO z.cur_nm.len - 1 DO
                  IF (i # 0) THEN wx.put ("/"); END;
                  nm := pres.names [z.cur_nm.start + i];
                  wx.put (nm);
                END;
                wx.put ("\">");
                nm_len := 3; (* for the trailing "..." *)
                FOR i := 0 TO z.cur_nm.len - 1 DO
                  IF (i # 0) THEN wx.put ("/"); INC (nm_len); END;
                  nm := pres.names [z.cur_nm.start + i];
                  wx.put (nm);  INC (nm_len, Text.Length (nm));
                END;
                wx.put ("...</A>");
              ELSE (* singleton node *)
                GenRef (z.node, wx);
                nm_len := 0;
                FOR i := 0 TO z.cur_nm.len - 1 DO
                  IF (i # 0) THEN wx.put ("/"); INC (nm_len); END;
                  nm := pres.names [z.cur_nm.start + i];
                  wx.put (nm);  INC (nm_len, Text.Length (nm));
                END;
                wx.put ("</A>");
              END;
            END;
            IF (col # n_cols-1) THEN
              (* pad to the next column *)
              FOR x := 1 TO width - nm_len DO wx.putChar (' '); END;
              wx.put (Gap_text);
            END;
          END;
        END;
        wx.put ("\n");
      END;
    FINALLY
      IF (n_rows > 1) OR (NOT multi_class) OR (pres.suffix_skip > 0)
        THEN wx.put ("</PRE>\n");
        ELSE wx.put ("</TT>");
      END;
    END;
  END GenDir;


BEGIN
END HTML.
