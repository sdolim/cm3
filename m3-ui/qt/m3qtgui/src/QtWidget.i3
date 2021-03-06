(*******************************************************************************
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 3.0.10
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
*******************************************************************************)

INTERFACE QtWidget;

FROM QtPoint IMPORT QPoint;
FROM QtNamespace IMPORT WindowTypes, GestureFlags, WindowStates,
                        FocusPolicy, ContextMenuPolicy, WindowType,
                        WidgetAttribute, InputMethodHints, WindowModality,
                        ShortcutContext, GestureType, LayoutDirection,
                        FocusReason;
FROM QtFont IMPORT QFont;
FROM QtBitmap IMPORT QBitmap;
FROM QGuiStubs IMPORT QLocale, QGraphicsEffect, QWindowSurface,
                      QGraphicsProxyWidget;
FROM QtPaintEngine IMPORT QPaintEngine;
FROM QtSize IMPORT QSize;
FROM QtByteArray IMPORT QByteArray;
FROM QtSizePolicy IMPORT Policy, QSizePolicy;
FROM QtMargins IMPORT QMargins;
FROM QtRect IMPORT QRect;
FROM QtCursor IMPORT QCursor;
FROM QtIcon IMPORT QIcon;
FROM QtPalette IMPORT ColorRole, QPalette;
FROM QtStyle IMPORT QStyle;
FROM QtKeySequence IMPORT QKeySequence;
FROM QtRegion IMPORT QRegion;
FROM QtAction IMPORT QAction;
FROM QtFontInfo IMPORT QFontInfo;
FROM QtFontMetrics IMPORT QFontMetrics;


FROM QtObject IMPORT QObject;
TYPE T = QWidget;


CONST                            (* Enum RenderFlag *)
  DrawWindowBackground = 1;
  DrawChildren         = 2;
  IgnoreMask           = 4;

TYPE                             (* Enum RenderFlag *)
  RenderFlag = [1 .. 4];

PROCEDURE SetTabOrder (arg1, arg2: QWidget; );

PROCEDURE MouseGrabber (): QWidget;

PROCEDURE KeyboardGrabber (): QWidget;

PROCEDURE Find (arg1: INTEGER; ): QWidget;


TYPE
  QWidget <: QWidgetPublic;
  QWidgetPublic =
    QObject BRANDED OBJECT
    METHODS
      init_0                (parent: QWidget; f: WindowTypes; ): QWidget;
      init_1                (parent: QWidget; ): QWidget;
      init_widget           (): QWidget;
      devType               (): INTEGER; (* virtual *)
      winId                 (): INTEGER;
      createWinId           ();
      effectiveWinId        (): INTEGER;
      style                 (): QStyle;
      setStyle              (arg1: QStyle; );
      isTopLevel            (): BOOLEAN;
      isWindow              (): BOOLEAN;
      isModal               (): BOOLEAN;
      windowModality        (): WindowModality;
      setWindowModality     (windowModality: WindowModality; );
      isEnabled             (): BOOLEAN;
      isEnabledTo           (arg1: QWidget; ): BOOLEAN;
      isEnabledToTLW        (): BOOLEAN;
      setEnabled            (arg1: BOOLEAN; );
      setDisabled           (arg1: BOOLEAN; );
      setWindowModified     (arg1: BOOLEAN; );
      frameGeometry         (): QRect;
      geometry              (): QRect;
      normalGeometry        (): QRect;
      x                     (): INTEGER;
      y                     (): INTEGER;
      pos                   (): QPoint;
      frameSize             (): QSize;
      size                  (): QSize;
      width                 (): INTEGER;
      height                (): INTEGER;
      rect                  (): QRect;
      childrenRect          (): QRect;
      childrenRegion        (): QRegion;
      minimumSize           (): QSize;
      maximumSize           (): QSize;
      minimumWidth          (): INTEGER;
      minimumHeight         (): INTEGER;
      maximumWidth          (): INTEGER;
      maximumHeight         (): INTEGER;
      setMinimumSize        (arg1: QSize; );
      setMinimumSize1       (minw, minh: INTEGER; );
      setMaximumSize        (arg1: QSize; );
      setMaximumSize1       (maxw, maxh: INTEGER; );
      setMinimumWidth       (minw: INTEGER; );
      setMinimumHeight      (minh: INTEGER; );
      setMaximumWidth       (maxw: INTEGER; );
      setMaximumHeight      (maxh: INTEGER; );
      sizeIncrement         (): QSize;
      setSizeIncrement      (arg1: QSize; );
      setSizeIncrement1     (w, h: INTEGER; );
      baseSize              (): QSize;
      setBaseSize           (arg1: QSize; );
      setBaseSize1          (basew, baseh: INTEGER; );
      setFixedSize          (arg1: QSize; );
      setFixedSize1         (w, h: INTEGER; );
      setFixedWidth         (w: INTEGER; );
      setFixedHeight        (h: INTEGER; );
      mapToGlobal           (arg1: QPoint; ): QPoint;
      mapFromGlobal         (arg1: QPoint; ): QPoint;
      mapToParent           (arg1: QPoint; ): QPoint;
      mapFromParent         (arg1: QPoint; ): QPoint;
      mapTo                 (arg1: QWidget; arg2: QPoint; ): QPoint;
      mapFrom               (arg1: QWidget; arg2: QPoint; ): QPoint;
      window                (): QWidget;
      nativeParentWidget    (): QWidget;
      topLevelWidget        (): QWidget;
      palette               (): QPalette;
      setPalette            (arg1: QPalette; );
      setBackgroundRole     (arg1: ColorRole; );
      backgroundRole        (): ColorRole;
      setForegroundRole     (arg1: ColorRole; );
      foregroundRole        (): ColorRole;
      font                  (): QFont;
      setFont               (arg1: QFont; );
      fontMetrics           (): QFontMetrics;
      fontInfo              (): QFontInfo;
      cursor                (): QCursor;
      setCursor             (arg1: QCursor; );
      unsetCursor           ();
      setMouseTracking      (enable: BOOLEAN; );
      hasMouseTracking      (): BOOLEAN;
      underMouse            (): BOOLEAN;
      setMask               (arg1: QBitmap; );
      setMask1              (arg1: QRegion; );
      mask                  (): QRegion;
      clearMask             ();
      graphicsEffect        (): QGraphicsEffect;
      setGraphicsEffect     (effect: QGraphicsEffect; );
      grabGesture           (type: GestureType; flags: GestureFlags; );
      grabGesture1          (type: GestureType; );
      ungrabGesture         (type: GestureType; );
      setWindowTitle        (arg1: TEXT; );
      setStyleSheet         (styleSheet: TEXT; );
      styleSheet            (): TEXT;
      windowTitle           (): TEXT;
      setWindowIcon         (icon: QIcon; );
      setWindowIconText     (arg1: TEXT; );
      windowIconText        (): TEXT;
      setWindowRole         (arg1: TEXT; );
      windowRole            (): TEXT;
      setWindowFilePath     (filePath: TEXT; );
      windowFilePath        (): TEXT;
      setWindowOpacity      (level: LONGREAL; );
      windowOpacity         (): LONGREAL;
      isWindowModified      (): BOOLEAN;
      setToolTip            (arg1: TEXT; );
      toolTip               (): TEXT;
      setStatusTip          (arg1: TEXT; );
      statusTip             (): TEXT;
      setWhatsThis          (arg1: TEXT; );
      whatsThis             (): TEXT;
      accessibleName        (): TEXT;
      setAccessibleName     (name: TEXT; );
      accessibleDescription (): TEXT;
      setAccessibleDescription (description: TEXT; );
      setLayoutDirection       (direction: LayoutDirection; );
      layoutDirection          (): LayoutDirection;
      unsetLayoutDirection     ();
      setLocale                (locale: QLocale; );
      unsetLocale              ();
      isRightToLeft            (): BOOLEAN;
      isLeftToRight            (): BOOLEAN;
      setFocus                 ();
      isActiveWindow           (): BOOLEAN;
      activateWindow           ();
      clearFocus               ();
      setFocus1                (reason: FocusReason; );
      focusPolicy              (): FocusPolicy;
      setFocusPolicy           (policy: FocusPolicy; );
      hasFocus                 (): BOOLEAN;
      setFocusProxy            (arg1: QWidget; );
      focusProxy               (): QWidget;
      contextMenuPolicy        (): ContextMenuPolicy;
      setContextMenuPolicy     (policy: ContextMenuPolicy; );
      grabMouse                ();
      grabMouse1               (arg1: QCursor; );
      releaseMouse             ();
      grabKeyboard             ();
      releaseKeyboard          ();
      grabShortcut (key: QKeySequence; context: ShortcutContext; ):
                    INTEGER;
      grabShortcut1          (key: QKeySequence; ): INTEGER;
      releaseShortcut        (id: INTEGER; );
      setShortcutEnabled     (id: INTEGER; enable: BOOLEAN; );
      setShortcutEnabled1    (id: INTEGER; );
      setShortcutAutoRepeat  (id: INTEGER; enable: BOOLEAN; );
      setShortcutAutoRepeat1 (id: INTEGER; );
      updatesEnabled         (): BOOLEAN;
      setUpdatesEnabled      (enable: BOOLEAN; );
      graphicsProxyWidget    (): QGraphicsProxyWidget;
      update                 ();
      repaint                ();
      update1                (x, y, w, h: INTEGER; );
      update2                (arg1: QRect; );
      update3                (arg1: QRegion; );
      repaint1               (x, y, w, h: INTEGER; );
      repaint2               (arg1: QRect; );
      repaint3               (arg1: QRegion; );
      setVisible             (visible: BOOLEAN; ); (* virtual *)
      setHidden              (hidden: BOOLEAN; );
      show                   ();
      hide                   ();
      setShown               (shown: BOOLEAN; );
      showMinimized          ();
      showMaximized          ();
      showFullScreen         ();
      showNormal             ();
      close                  (): BOOLEAN;
      raise                  ();
      lower                  ();
      stackUnder             (arg1: QWidget; );
      move                   (x, y: INTEGER; );
      move1                  (arg1: QPoint; );
      resize                 (w, h: INTEGER; );
      resize1                (arg1: QSize; );
      setGeometry            (x, y, w, h: INTEGER; );
      setGeometry1           (arg1: QRect; );
      saveGeometry           (): QByteArray;
      restoreGeometry        (geometry: QByteArray; ): BOOLEAN;
      adjustSize             ();
      isVisible              (): BOOLEAN;
      isVisibleTo            (arg1: QWidget; ): BOOLEAN;
      isHidden               (): BOOLEAN;
      isMinimized            (): BOOLEAN;
      isMaximized            (): BOOLEAN;
      isFullScreen           (): BOOLEAN;
      windowState            (): WindowStates;
      setWindowState         (state: WindowStates; );
      overrideWindowState    (state: WindowStates; );
      sizeHint               (): QSize; (* virtual *)
      minimumSizeHint        (): QSize; (* virtual *)
      sizePolicy             (): QSizePolicy;
      setSizePolicy          (arg1: QSizePolicy; );
      setSizePolicy1         (horizontal, vertical: Policy; );
      heightForWidth         (arg1: INTEGER; ): INTEGER; (* virtual *)
      visibleRegion          (): QRegion;
      setContentsMargins     (left, top, right, bottom: INTEGER; );
      setContentsMargins1    (margins: QMargins; );
      getContentsMargins     (VAR left, top, right, bottom: INTEGER; );
      contentsMargins        (): QMargins;
      contentsRect           (): QRect;
      layout                 (): REFANY;
      setLayout              (arg1: REFANY; );
      updateGeometry         ();
      setParent              (parent: QWidget; );
      setParent1             (parent: QWidget; f: WindowTypes; );
      scroll                 (dx, dy: INTEGER; );
      scroll1                (dx, dy: INTEGER; arg3: QRect; );
      focusWidget            (): QWidget;
      nextInFocusChain       (): QWidget;
      previousInFocusChain   (): QWidget;
      acceptDrops            (): BOOLEAN;
      setAcceptDrops         (on: BOOLEAN; );
      addAction              (action: QAction; );
      insertAction           (before, action: QAction; );
      removeAction           (action: QAction; );
      parentWidget           (): QWidget;
      setWindowFlags         (type: WindowTypes; );
      windowFlags            (): WindowTypes;
      overrideWindowFlags    (type: WindowTypes; );
      windowType             (): WindowType;
      childAt                (x, y: INTEGER; ): QWidget;
      childAt1               (p: QPoint; ): QWidget;
      setAttribute           (arg1: WidgetAttribute; on: BOOLEAN; );
      setAttribute1          (arg1: WidgetAttribute; );
      testAttribute          (arg1: WidgetAttribute; ): BOOLEAN;
      paintEngine            (): QPaintEngine; (* virtual *)
      ensurePolished         ();
      inputContext           (): REFANY;
      setInputContext        (arg1: REFANY; );
      isAncestorOf           (child: QWidget; ): BOOLEAN;
      autoFillBackground     (): BOOLEAN;
      setAutoFillBackground  (enabled: BOOLEAN; );
      setWindowSurface       (surface: QWindowSurface; );
      windowSurface          (): QWindowSurface;
      inputMethodHints       (): InputMethodHints;
      setInputMethodHints    (hints: InputMethodHints; );
      destroyCxx             ();
    END;


END QtWidget.
