(*******************************************************************************
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 3.0.10
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
*******************************************************************************)

UNSAFE MODULE QtLayout;


FROM QtLayoutItem IMPORT QLayoutItem;
FROM QtSize IMPORT QSize;
FROM QtMargins IMPORT QMargins;
IMPORT QtLayoutRaw;
FROM QtWidget IMPORT QWidget;
FROM QtRect IMPORT QRect;
FROM QtNamespace IMPORT AlignmentFlag, Orientations;


IMPORT WeakRef;
IMPORT Ctypes AS C;

PROCEDURE Delete_QLayout (self: QLayout; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtLayoutRaw.Delete_QLayout(selfAdr);
  END Delete_QLayout;

PROCEDURE QLayout_margin (self: QLayout; ): INTEGER =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtLayoutRaw.QLayout_margin(selfAdr);
  END QLayout_margin;

PROCEDURE QLayout_spacing (self: QLayout; ): INTEGER =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtLayoutRaw.QLayout_spacing(selfAdr);
  END QLayout_spacing;

PROCEDURE QLayout_setMargin (self: QLayout; arg2: INTEGER; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtLayoutRaw.QLayout_setMargin(selfAdr, arg2);
  END QLayout_setMargin;

PROCEDURE QLayout_setSpacing (self: QLayout; arg2: INTEGER; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtLayoutRaw.QLayout_setSpacing(selfAdr, arg2);
  END QLayout_setSpacing;

PROCEDURE QLayout_setContentsMargins
  (self: QLayout; left, top, right, bottom: INTEGER; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtLayoutRaw.QLayout_setContentsMargins(
      selfAdr, left, top, right, bottom);
  END QLayout_setContentsMargins;

PROCEDURE QLayout_setContentsMargins1
  (self: QLayout; margins: QMargins; ) =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(margins.cxxObj, ADDRESS);
  BEGIN
    QtLayoutRaw.QLayout_setContentsMargins1(selfAdr, arg2tmp);
  END QLayout_setContentsMargins1;

PROCEDURE QLayout_getContentsMargins
  (self: QLayout; VAR left, top, right, bottom: INTEGER; ) =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp: C.int;
    arg3tmp: C.int;
    arg4tmp: C.int;
    arg5tmp: C.int;
  BEGIN
    arg2tmp := left;
    arg3tmp := top;
    arg4tmp := right;
    arg5tmp := bottom;
    QtLayoutRaw.QLayout_getContentsMargins(
      selfAdr, arg2tmp, arg3tmp, arg4tmp, arg5tmp);
    left := arg2tmp;
    top := arg3tmp;
    right := arg4tmp;
    bottom := arg5tmp;
  END QLayout_getContentsMargins;

PROCEDURE QLayout_contentsMargins (self: QLayout; ): QMargins =
  VAR
    ret    : ADDRESS;
    result : QMargins;
    selfAdr: ADDRESS  := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtLayoutRaw.QLayout_contentsMargins(selfAdr);

    result := NEW(QMargins);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QLayout_contentsMargins;

PROCEDURE QLayout_contentsRect (self: QLayout; ): QRect =
  VAR
    ret    : ADDRESS;
    result : QRect;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtLayoutRaw.QLayout_contentsRect(selfAdr);

    result := NEW(QRect);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QLayout_contentsRect;

PROCEDURE QLayout_setAlignment
  (self: QLayout; w: QWidget; alignment: AlignmentFlag; ): BOOLEAN =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(w.cxxObj, ADDRESS);
  BEGIN
    RETURN
      QtLayoutRaw.QLayout_setAlignment(selfAdr, arg2tmp, ORD(alignment));
  END QLayout_setAlignment;

PROCEDURE QLayout_setAlignment1
  (self, l: QLayout; alignment: AlignmentFlag; ): BOOLEAN =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(l.cxxObj, ADDRESS);
  BEGIN
    RETURN
      QtLayoutRaw.QLayout_setAlignment1(selfAdr, arg2tmp, ORD(alignment));
  END QLayout_setAlignment1;

PROCEDURE QLayout_setAlignment2_0 (self: QLayout; a: AlignmentFlag; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtLayoutRaw.QLayout_setAlignment2_0(selfAdr, ORD(a));
  END QLayout_setAlignment2_0;

PROCEDURE QLayout_setSizeConstraint
  (self: QLayout; arg2: SizeConstraint; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtLayoutRaw.QLayout_setSizeConstraint(selfAdr, ORD(arg2));
  END QLayout_setSizeConstraint;

PROCEDURE QLayout_sizeConstraint (self: QLayout; ): SizeConstraint =
  VAR
    ret    : INTEGER;
    result : SizeConstraint;
    selfAdr: ADDRESS        := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtLayoutRaw.QLayout_sizeConstraint(selfAdr);
    result := VAL(ret, SizeConstraint);
    RETURN result;
  END QLayout_sizeConstraint;

PROCEDURE QLayout_setMenuBar (self: QLayout; w: QWidget; ) =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(w.cxxObj, ADDRESS);
  BEGIN
    QtLayoutRaw.QLayout_setMenuBar(selfAdr, arg2tmp);
  END QLayout_setMenuBar;

PROCEDURE QLayout_menuBar (self: QLayout; ): QWidget =
  VAR
    ret    : ADDRESS;
    result : QWidget;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtLayoutRaw.QLayout_menuBar(selfAdr);

    result := NEW(QWidget);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QLayout_menuBar;

PROCEDURE QLayout_parentWidget (self: QLayout; ): QWidget =
  VAR
    ret    : ADDRESS;
    result : QWidget;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtLayoutRaw.QLayout_parentWidget(selfAdr);

    result := NEW(QWidget);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QLayout_parentWidget;

PROCEDURE QLayout_invalidate (self: QLayout; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtLayoutRaw.QLayout_invalidate(selfAdr);
  END QLayout_invalidate;

PROCEDURE QLayout_geometry (self: QLayout; ): QRect =
  VAR
    ret    : ADDRESS;
    result : QRect;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtLayoutRaw.QLayout_geometry(selfAdr);

    result := NEW(QRect);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QLayout_geometry;

PROCEDURE QLayout_activate (self: QLayout; ): BOOLEAN =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtLayoutRaw.QLayout_activate(selfAdr);
  END QLayout_activate;

PROCEDURE QLayout_update (self: QLayout; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtLayoutRaw.QLayout_update(selfAdr);
  END QLayout_update;

PROCEDURE QLayout_addWidget (self: QLayout; w: QWidget; ) =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(w.cxxObj, ADDRESS);
  BEGIN
    QtLayoutRaw.QLayout_addWidget(selfAdr, arg2tmp);
  END QLayout_addWidget;

PROCEDURE QLayout_removeWidget (self: QLayout; w: QWidget; ) =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(w.cxxObj, ADDRESS);
  BEGIN
    QtLayoutRaw.QLayout_removeWidget(selfAdr, arg2tmp);
  END QLayout_removeWidget;

PROCEDURE QLayout_removeItem (self: QLayout; arg2: QLayoutItem; ) =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(arg2.cxxObj, ADDRESS);
  BEGIN
    QtLayoutRaw.QLayout_removeItem(selfAdr, arg2tmp);
  END QLayout_removeItem;

PROCEDURE QLayout_expandingDirections (self: QLayout; ): Orientations =
  VAR
    ret    : INTEGER;
    result : Orientations;
    selfAdr: ADDRESS      := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtLayoutRaw.QLayout_expandingDirections(selfAdr);
    result := VAL(ret, Orientations);
    RETURN result;
  END QLayout_expandingDirections;

PROCEDURE QLayout_minimumSize (self: QLayout; ): QSize =
  VAR
    ret    : ADDRESS;
    result : QSize;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtLayoutRaw.QLayout_minimumSize(selfAdr);

    result := NEW(QSize);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QLayout_minimumSize;

PROCEDURE QLayout_maximumSize (self: QLayout; ): QSize =
  VAR
    ret    : ADDRESS;
    result : QSize;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtLayoutRaw.QLayout_maximumSize(selfAdr);

    result := NEW(QSize);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QLayout_maximumSize;

PROCEDURE QLayout_setGeometry (self: QLayout; arg2: QRect; ) =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(arg2.cxxObj, ADDRESS);
  BEGIN
    QtLayoutRaw.QLayout_setGeometry(selfAdr, arg2tmp);
  END QLayout_setGeometry;

PROCEDURE QLayout_indexOf (self: QLayout; arg2: QWidget; ): INTEGER =
  VAR
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(arg2.cxxObj, ADDRESS);
  BEGIN
    RETURN QtLayoutRaw.QLayout_indexOf(selfAdr, arg2tmp);
  END QLayout_indexOf;

PROCEDURE QLayout_isEmpty (self: QLayout; ): BOOLEAN =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtLayoutRaw.QLayout_isEmpty(selfAdr);
  END QLayout_isEmpty;

PROCEDURE QLayout_totalHeightForWidth (self: QLayout; w: INTEGER; ):
  INTEGER =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtLayoutRaw.QLayout_totalHeightForWidth(selfAdr, w);
  END QLayout_totalHeightForWidth;

PROCEDURE QLayout_totalMinimumSize (self: QLayout; ): QSize =
  VAR
    ret    : ADDRESS;
    result : QSize;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtLayoutRaw.QLayout_totalMinimumSize(selfAdr);

    result := NEW(QSize);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QLayout_totalMinimumSize;

PROCEDURE QLayout_totalMaximumSize (self: QLayout; ): QSize =
  VAR
    ret    : ADDRESS;
    result : QSize;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtLayoutRaw.QLayout_totalMaximumSize(selfAdr);

    result := NEW(QSize);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QLayout_totalMaximumSize;

PROCEDURE QLayout_totalSizeHint (self: QLayout; ): QSize =
  VAR
    ret    : ADDRESS;
    result : QSize;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtLayoutRaw.QLayout_totalSizeHint(selfAdr);

    result := NEW(QSize);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QLayout_totalSizeHint;

PROCEDURE QLayout_layout (self: QLayout; ): REFANY =
  VAR
    ret    : ADDRESS;
    result : QLayout;
    selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    ret := QtLayoutRaw.QLayout_layout(selfAdr);

    result := NEW(QLayout);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END QLayout_layout;

PROCEDURE QLayout_setEnabled (self: QLayout; arg2: BOOLEAN; ) =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    QtLayoutRaw.QLayout_setEnabled(selfAdr, arg2);
  END QLayout_setEnabled;

PROCEDURE QLayout_isEnabled (self: QLayout; ): BOOLEAN =
  VAR selfAdr: ADDRESS := LOOPHOLE(self.cxxObj, ADDRESS);
  BEGIN
    RETURN QtLayoutRaw.QLayout_isEnabled(selfAdr);
  END QLayout_isEnabled;

PROCEDURE ClosestAcceptableSize (w: QWidget; s: QSize; ): QSize =
  VAR
    ret    : ADDRESS;
    result : QSize;
    arg1tmp          := LOOPHOLE(w.cxxObj, ADDRESS);
    arg2tmp          := LOOPHOLE(s.cxxObj, ADDRESS);
  BEGIN
    ret := QtLayoutRaw.ClosestAcceptableSize(arg1tmp, arg2tmp);

    result := NEW(QSize);
    result.cxxObj := ret;
    result.destroyCxx();

    RETURN result;
  END ClosestAcceptableSize;

PROCEDURE Cleanup_QLayout
  (<* UNUSED *> READONLY self: WeakRef.T; ref: REFANY) =
  VAR obj: QLayout := ref;
  BEGIN
    Delete_QLayout(obj);
  END Cleanup_QLayout;

PROCEDURE Destroy_QLayout (self: QLayout) =
  BEGIN
    EVAL WeakRef.FromRef(self, Cleanup_QLayout);
  END Destroy_QLayout;

REVEAL
  QLayout = QLayoutPublic BRANDED OBJECT
            OVERRIDES
              margin              := QLayout_margin;
              spacing             := QLayout_spacing;
              setMargin           := QLayout_setMargin;
              setSpacing          := QLayout_setSpacing;
              setContentsMargins  := QLayout_setContentsMargins;
              setContentsMargins1 := QLayout_setContentsMargins1;
              getContentsMargins  := QLayout_getContentsMargins;
              contentsMargins     := QLayout_contentsMargins;
              contentsRect        := QLayout_contentsRect;
              setAlignment        := QLayout_setAlignment;
              setAlignment1       := QLayout_setAlignment1;
              setAlignment2_0     := QLayout_setAlignment2_0;
              setSizeConstraint   := QLayout_setSizeConstraint;
              sizeConstraint      := QLayout_sizeConstraint;
              setMenuBar          := QLayout_setMenuBar;
              menuBar             := QLayout_menuBar;
              parentWidget        := QLayout_parentWidget;
              invalidate          := QLayout_invalidate;
              geometry            := QLayout_geometry;
              activate            := QLayout_activate;
              update              := QLayout_update;
              addWidget           := QLayout_addWidget;
              removeWidget        := QLayout_removeWidget;
              removeItem          := QLayout_removeItem;
              expandingDirections := QLayout_expandingDirections;
              minimumSize         := QLayout_minimumSize;
              maximumSize         := QLayout_maximumSize;
              setGeometry         := QLayout_setGeometry;
              indexOf             := QLayout_indexOf;
              isEmpty             := QLayout_isEmpty;
              totalHeightForWidth := QLayout_totalHeightForWidth;
              totalMinimumSize    := QLayout_totalMinimumSize;
              totalMaximumSize    := QLayout_totalMaximumSize;
              totalSizeHint       := QLayout_totalSizeHint;
              layout              := QLayout_layout;
              setEnabled          := QLayout_setEnabled;
              isEnabled           := QLayout_isEnabled;
              destroyCxx          := Destroy_QLayout;
            END;


BEGIN
END QtLayout.
