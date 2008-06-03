INTERFACE WinListView;

(* 
	Based on commctrl.h version 1.2
	Copyright 1991-1998, Microsoft Corp. All rights reserved.
	Copyright Darko Volaric 2002 darko@peter.com.au
*)

FROM Word IMPORT Or;
FROM WinBaseTypes IMPORT UINT16, UINT32, PSTR, PCSTR, INT32, PCTSTR;
FROM WinDef IMPORT LPARAM, PPOINT, POINT, HBITMAP, COLORREF, HWND, PRECT, HCURSOR;
FROM WinUser IMPORT NMHDR;
FROM WinCommCtrl IMPORT NMCUSTOMDRAW,
 LVN_FIRST, LVM_FIRST, CCM_SETUNICODEFORMAT, CCM_GETUNICODEFORMAT;
FROM WinImageList IMPORT HIMAGELIST;

(* constants *)

CONST
	WC_LISTVIEW = "SysListView";
	WC_LISTVIEW32 = "SysListView32";

	LVS_ICON                = 16_0000;
	LVS_REPORT              = 16_0001;
	LVS_SMALLICON           = 16_0002;
	LVS_LIST                = 16_0003;
	LVS_TYPEMASK            = 16_0003;
	LVS_SINGLESEL           = 16_0004;
	LVS_SHOWSELALWAYS       = 16_0008;
	LVS_SORTASCENDING       = 16_0010;
	LVS_SORTDESCENDING      = 16_0020;
	LVS_SHAREIMAGELISTS     = 16_0040;
	LVS_NOLABELWRAP         = 16_0080;
	LVS_AUTOARRANGE         = 16_0100;
	LVS_EDITLABELS          = 16_0200;
	LVS_OWNERDATA           = 16_1000;
	LVS_NOSCROLL            = 16_2000;

	LVS_TYPESTYLEMASK       = 16_fc00;

	LVS_ALIGNTOP            = 16_0000;
	LVS_ALIGNLEFT           = 16_0800;
	LVS_ALIGNMASK           = 16_0c00;

	LVS_OWNERDRAWFIXED      = 16_0400;
	LVS_NOCOLUMNHEADER      = 16_4000;
	LVS_NOSORTHEADER        = 16_8000;


	LVM_SETUNICODEFORMAT    = CCM_SETUNICODEFORMAT;
	LVM_GETUNICODEFORMAT    = CCM_GETUNICODEFORMAT;

	LVM_GETBKCOLOR          = (LVM_FIRST + 0);
	LVM_SETBKCOLOR          = (LVM_FIRST + 1);
	LVM_GETIMAGELIST        = (LVM_FIRST + 2);

	LVSIL_NORMAL            = 0;
	LVSIL_SMALL             = 1;
	LVSIL_STATE             = 2;

	LVM_SETIMAGELIST        = (LVM_FIRST + 3);
	LVM_GETITEMCOUNT        = (LVM_FIRST + 4);

	LVIF_TEXT               = 16_0001;
	LVIF_IMAGE              = 16_0002;
	LVIF_PARAM              = 16_0004;
	LVIF_STATE              = 16_0008;
	LVIF_INDENT             = 16_0010;
	LVIF_NORECOMPUTE        = 16_0800;

	LVIS_FOCUSED            = 16_0001;
	LVIS_SELECTED           = 16_0002;
	LVIS_CUT                = 16_0004;
	LVIS_DROPHILITED        = 16_0008;
	LVIS_ACTIVATING         = 16_0020;

	LVIS_OVERLAYMASK        = 16_0F00;
	LVIS_STATEIMAGEMASK     = 16_F000;


	I_INDENTCALLBACK        = (-1);

	I_IMAGECALLBACK         = (-1);

	LVM_GETITEMA            = (LVM_FIRST + 5);
	LVM_GETITEMW            = (LVM_FIRST + 75);

	LVM_GETITEM             = LVM_GETITEMA;

	LVM_SETITEMA            = (LVM_FIRST + 6);
	LVM_SETITEMW            = (LVM_FIRST + 76);

	LVM_SETITEM             = LVM_SETITEMA;


	LVM_INSERTITEMA         = (LVM_FIRST + 7);
	LVM_INSERTITEMW         = (LVM_FIRST + 77);

	LVM_INSERTITEM          = LVM_INSERTITEMA;


	LVM_DELETEITEM          = (LVM_FIRST + 8);
	LVM_DELETEALLITEMS      = (LVM_FIRST + 9);
	LVM_GETCALLBACKMASK     = (LVM_FIRST + 10);
	LVM_SETCALLBACKMASK     = (LVM_FIRST + 11);

	LVNI_ALL                = 16_0000;
	LVNI_FOCUSED            = 16_0001;
	LVNI_SELECTED           = 16_0002;
	LVNI_CUT                = 16_0004;
	LVNI_DROPHILITED        = 16_0008;

	LVNI_ABOVE              = 16_0100;
	LVNI_BELOW              = 16_0200;
	LVNI_TOLEFT             = 16_0400;
	LVNI_TORIGHT            = 16_0800;


	LVM_GETNEXTITEM         = (LVM_FIRST + 12);


	LVFI_PARAM              = 16_0001;
	LVFI_STRING             = 16_0002;
	LVFI_PARTIAL            = 16_0008;
	LVFI_WRAP               = 16_0020;
	LVFI_NEARESTXY          = 16_0040;


	LVM_FINDITEMA           = (LVM_FIRST + 13);
	LVM_FINDITEMW           = (LVM_FIRST + 83);

	LVM_FINDITEM           = LVM_FINDITEMA;


	LVIR_BOUNDS             = 0;
	LVIR_ICON               = 1;
	LVIR_LABEL              = 2;
	LVIR_SELECTBOUNDS       = 3;

	LVM_GETITEMRECT         = (LVM_FIRST + 14);
	LVM_SETITEMPOSITION     = (LVM_FIRST + 15);
	LVM_GETITEMPOSITION     = (LVM_FIRST + 16);

	LVM_GETSTRINGWIDTHA     = (LVM_FIRST + 17);
	LVM_GETSTRINGWIDTHW     = (LVM_FIRST + 87);

	LVM_GETSTRINGWIDTH     = LVM_GETSTRINGWIDTHA;



	LVHT_NOWHERE            = 16_0001;
	LVHT_ONITEMICON         = 16_0002;
	LVHT_ONITEMLABEL        = 16_0004;
	LVHT_ONITEMSTATEICON    = 16_0008;
	LVHT_ONITEM             = Or (LVHT_ONITEMICON, Or(LVHT_ONITEMLABEL, LVHT_ONITEMSTATEICON));

	LVHT_ABOVE              = 16_0008;
	LVHT_BELOW              = 16_0010;
	LVHT_TORIGHT            = 16_0020;
	LVHT_TOLEFT             = 16_0040;

(*	LV_HITTESTINFO = LVHITTESTINFO; *)



	LVM_HITTEST             = (LVM_FIRST + 18);
	LVM_ENSUREVISIBLE       = (LVM_FIRST + 19);
	LVM_SCROLL              = (LVM_FIRST + 20);
	LVM_REDRAWITEMS         = (LVM_FIRST + 21);

	LVA_DEFAULT             = 16_0000;
	LVA_ALIGNLEFT           = 16_0001;
	LVA_ALIGNTOP            = 16_0002;
	LVA_SNAPTOGRID          = 16_0005;

	LVM_ARRANGE             = (LVM_FIRST + 22);

	LVM_EDITLABELA          = (LVM_FIRST + 23);
	LVM_EDITLABELW          = (LVM_FIRST + 118);

	LVM_EDITLABEL           = LVM_EDITLABELA;


	LVM_GETEDITCONTROL      = (LVM_FIRST + 24);

	LVCF_FMT                = 16_0001;
	LVCF_WIDTH             = 16_0002;
	LVCF_TEXT               = 16_0004;
	LVCF_SUBITEM            = 16_0008;

	LVCF_IMAGE              = 16_0010;
	LVCF_ORDER              = 16_0020;


	LVCFMT_LEFT             = 16_0000;
	LVCFMT_RIGHT           =  16_0001;
	LVCFMT_CENTER          =  16_0002;
	LVCFMT_JUSTIFYMASK     =  16_0003;

	LVCFMT_IMAGE            = 16_0800;
	LVCFMT_BITMAP_ON_RIGHT  = 16_1000;
	LVCFMT_COL_HAS_IMAGES   = 16_8000;


	LVM_GETCOLUMNA          = (LVM_FIRST + 25);
	LVM_GETCOLUMNW          = (LVM_FIRST + 95);

	 LVM_GETCOLUMN          = LVM_GETCOLUMNA;


	LVM_SETCOLUMNA          = (LVM_FIRST + 26);
	LVM_SETCOLUMNW          = (LVM_FIRST + 96);

	 LVM_SETCOLUMN         =  LVM_SETCOLUMNA;


	LVM_INSERTCOLUMNA       = (LVM_FIRST + 27);
	LVM_INSERTCOLUMNW       = (LVM_FIRST + 97);
	 LVM_INSERTCOLUMN    = LVM_INSERTCOLUMNA;

	LVM_DELETECOLUMN        = (LVM_FIRST + 28);
	LVM_GETCOLUMNWIDTH      = (LVM_FIRST + 29);
	LVSCW_AUTOSIZE           =    -1;
	LVSCW_AUTOSIZE_USEHEADER =    -2;
	LVM_SETCOLUMNWIDTH       =    (LVM_FIRST + 30);
	LVM_GETHEADER            =    (LVM_FIRST + 31);
	LVM_CREATEDRAGIMAGE     = (LVM_FIRST + 33);
	LVM_GETVIEWRECT         = (LVM_FIRST + 34);
	LVM_GETTEXTCOLOR        = (LVM_FIRST + 35);
	LVM_SETTEXTCOLOR        = (LVM_FIRST + 36);
	LVM_GETTEXTBKCOLOR      = (LVM_FIRST + 37);
	LVM_SETTEXTBKCOLOR      = (LVM_FIRST + 38);
	LVM_GETTOPINDEX         = (LVM_FIRST + 39);
	LVM_GETCOUNTPERPAGE     = (LVM_FIRST + 40);
	LVM_GETORIGIN           = (LVM_FIRST + 41);
	LVM_UPDATE              = (LVM_FIRST + 42);
	LVM_SETITEMSTATE        = (LVM_FIRST + 43);
	LVM_GETITEMSTATE        = (LVM_FIRST + 44);

	LVM_GETITEMTEXTA        = (LVM_FIRST + 45);
	LVM_GETITEMTEXTW        = (LVM_FIRST + 115);


	 LVM_GETITEMTEXT        = LVM_GETITEMTEXTA;


	LVM_SETITEMTEXTA        = (LVM_FIRST + 46);
	LVM_SETITEMTEXTW        = (LVM_FIRST + 116);


	 LVM_SETITEMTEXT        = LVM_SETITEMTEXTA;

	


	LVSICF_NOINVALIDATEALL  = 16_00000001;
	LVSICF_NOSCROLL         = 16_00000002;


	LVM_SETITEMCOUNT        = (LVM_FIRST + 47);
	LVM_SORTITEMS           = (LVM_FIRST + 48);
	LVM_SETITEMPOSITION32   = (LVM_FIRST + 49);
	LVM_GETSELECTEDCOUNT    = (LVM_FIRST + 50);
	LVM_GETITEMSPACING      = (LVM_FIRST + 51);

	LVM_GETISEARCHSTRINGA   = (LVM_FIRST + 52);
	LVM_GETISEARCHSTRINGW   = (LVM_FIRST + 117);


	LVM_GETISEARCHSTRING    = LVM_GETISEARCHSTRINGA;


	LVM_SETICONSPACING      = (LVM_FIRST + 53);
	LVM_SETEXTENDEDLISTVIEWSTYLE = (LVM_FIRST + 54);
	LVM_GETEXTENDEDLISTVIEWSTYLE = (LVM_FIRST + 55);

	LVS_EX_GRIDLINES        = 16_00000001;
	LVS_EX_SUBITEMIMAGES    = 16_00000002;
	LVS_EX_CHECKBOXES       = 16_00000004;
	LVS_EX_TRACKSELECT      = 16_00000008;
	LVS_EX_HEADERDRAGDROP   = 16_00000010;
	LVS_EX_FULLROWSELECT    = 16_00000020;
	LVS_EX_ONECLICKACTIVATE = 16_00000040;
	LVS_EX_TWOCLICKACTIVATE = 16_00000080;

	LVS_EX_FLATSB           = 16_00000100;
	LVS_EX_REGIONAL         = 16_00000200;
	LVS_EX_INFOTIP          = 16_00000400;
	LVS_EX_UNDERLINEHOT     = 16_00000800;
	LVS_EX_UNDERLINECOLD   =  16_00001000;
	LVS_EX_MULTIWORKAREAS   = 16_00002000;


	LVM_GETSUBITEMRECT      = (LVM_FIRST + 56);
	LVM_SUBITEMHITTEST      = (LVM_FIRST + 57);
	LVM_SETCOLUMNORDERARRAY = (LVM_FIRST + 58);
	LVM_GETCOLUMNORDERARRAY = (LVM_FIRST + 59);
	LVM_SETHOTITEM  = (LVM_FIRST + 60);
	LVM_GETHOTITEM  = (LVM_FIRST + 61);
	LVM_SETHOTCURSOR  = (LVM_FIRST + 62);
	LVM_GETHOTCURSOR  = (LVM_FIRST + 63);
	LVM_APPROXIMATEVIEWRECT = (LVM_FIRST + 64);
	LV_MAX_WORKAREAS         = 16                  ;        
	LVM_SETWORKAREAS        =  (LVM_FIRST + 65);
	LVM_GETWORKAREAS        = (LVM_FIRST + 70);
	LVM_GETNUMBEROFWORKAREAS =  (LVM_FIRST + 73);
	LVM_GETSELECTIONMARK   =  (LVM_FIRST + 66);
	LVM_SETSELECTIONMARK   =  (LVM_FIRST + 67);
	LVM_SETHOVERTIME       =  (LVM_FIRST + 71);
	LVM_GETHOVERTIME       =  (LVM_FIRST + 72);
	LVM_SETTOOLTIPS      =  (LVM_FIRST + 74);
	LVM_GETTOOLTIPS      =  (LVM_FIRST + 78);
	
	LVM_SORTITEMSEX = (LVM_FIRST + 81);

	LVBKIF_SOURCE_NONE     =  16_00000000;
	LVBKIF_SOURCE_HBITMAP  =  16_00000001;
	LVBKIF_SOURCE_URL      =  16_00000002;
	LVBKIF_SOURCE_MASK     =  16_00000003;
	LVBKIF_STYLE_NORMAL    =  16_00000000;
	LVBKIF_STYLE_TILE      =  16_00000010;
	LVBKIF_STYLE_MASK      =  16_00000010;

	LVM_SETBKIMAGEA         = (LVM_FIRST + 68);
	LVM_SETBKIMAGEW        =  (LVM_FIRST + 138);
	LVM_GETBKIMAGEA        =  (LVM_FIRST + 69);
	LVM_GETBKIMAGEW        =  (LVM_FIRST + 139);


	LVKF_ALT      =  16_0001;
	LVKF_CONTROL  =  16_0002;
	LVKF_SHIFT    =  16_0004;


	LVN_ITEMCHANGING      =   (LVN_FIRST-0);
	LVN_ITEMCHANGED       =   (LVN_FIRST-1);
	LVN_INSERTITEM        =   (LVN_FIRST-2);
	LVN_DELETEITEM        =   (LVN_FIRST-3);
	LVN_DELETEALLITEMS    =   (LVN_FIRST-4);
	LVN_BEGINLABELEDITA   =   (LVN_FIRST-5);
	LVN_BEGINLABELEDITW   =   (LVN_FIRST-75);
	LVN_ENDLABELEDITA    =    (LVN_FIRST-6);
	LVN_ENDLABELEDITW     =   (LVN_FIRST-76);
	LVN_COLUMNCLICK       =   (LVN_FIRST-8);
	LVN_BEGINDRAG         =   (LVN_FIRST-9);
	LVN_BEGINRDRAG        =   (LVN_FIRST-11);


	LVN_ODCACHEHINT       =   (LVN_FIRST-13);
	LVN_ODFINDITEMA       =   (LVN_FIRST-52);
	LVN_ODFINDITEMW       =   (LVN_FIRST-79);

	LVN_ITEMACTIVATE      =   (LVN_FIRST-14);
	LVN_ODSTATECHANGED    =   (LVN_FIRST-15);


	LVN_ODFINDITEM        =   LVN_ODFINDITEMA;




	LVN_HOTTRACK           =  (LVN_FIRST-21);


	LVN_GETDISPINFOA      =   (LVN_FIRST-50);
	LVN_GETDISPINFOW      =   (LVN_FIRST-77);
	LVN_SETDISPINFOA      =   (LVN_FIRST-51);
	LVN_SETDISPINFOW      =   (LVN_FIRST-78);


	LVN_BEGINLABELEDIT    =   LVN_BEGINLABELEDITA;
	LVN_ENDLABELEDIT      =   LVN_ENDLABELEDITA;
	LVN_GETDISPINFO       =   LVN_GETDISPINFOA;
	LVN_SETDISPINFO       =   LVN_SETDISPINFOA;



	LVIF_DI_SETITEM       =   16_1000;


	LVN_KEYDOWN          =    (LVN_FIRST-55);
	LVN_MARQUEEBEGIN     =    (LVN_FIRST-56);

	LVGIT_UNFOLDED =  16_0001;

	LVN_GETINFOTIPA       =    (LVN_FIRST-57);
	LVN_GETINFOTIPW       =    (LVN_FIRST-58);


(* strtuctures *)

TYPE

	LPLVITEM = UNTRACED REF LVITEM;
	LVITEM = RECORD
		mask: UINT32;
		iItem: INT32;
		iSubItem: INT32;
		state: UINT32;
		stateMask: UINT32;
		pszText: PSTR;  (* possible unicode *)
		cchTextMax: INT32;
		iImage: INT32;
		lParam: LPARAM;
		iIndent: INT32;
	END;

	LPFINDINFO = UNTRACED REF LVFINDINFO;
	LVFINDINFO = RECORD
		flags: UINT32;
		psz: PCSTR;  (* possible unicode *)
		lParam: LPARAM;
		pt: POINT;
		vkDirection: UINT32;
	END;

	LPLVHITTESTINFO = UNTRACED REF LVHITTESTINFO;
	LVHITTESTINFO = RECORD
		pt: POINT;
		flags: UINT32;
		iItem: INT32;
		iSubItem: INT32;
	END;

	LPLVCOLUMN = UNTRACED REF LVCOLUMN;
	LVCOLUMN = RECORD
		mask: UINT32;
		fmt: INT32;
		cx: INT32;
		pszText: PSTR;  (* possible unicode *)
		cchTextMax: INT32;
		iSubItem: INT32;
		iImage: INT32;
		iOrder: INT32;
	END;


	LPLVBKIMAGE = UNTRACED REF LVBKIMAGE;
	LVBKIMAGE = RECORD
		ulFlags: UINT32;
		hbm: HBITMAP;
		pszImage: PSTR;  (* possible unicode *)
		cchImageMax: UINT32;
		xOffsetPercent: INT32;
		yOffsetPercent: INT32;
	END;



	LPNMLISTVIEW = UNTRACED REF NMLISTVIEW;
	NMLISTVIEW = RECORD
		hdr: NMHDR;
		iItem: INT32;
		iSubItem: INT32;
		uNewState: UINT32;
		uOldState: UINT32;
		uChanged: UINT32;
		ptAction: POINT;
		lParam: LPARAM;
	END;


	LPNMITEMACTIVATE = UNTRACED REF NMITEMACTIVATE;
	NMITEMACTIVATE = RECORD
		hdr: NMHDR;
		iItem: INT32;
		iSubItem: INT32;
		uNewState: UINT32;
		uOldState: UINT32;
		uChanged: UINT32;
		ptAction: POINT;
		lParam: LPARAM;
		uKeyFlags: UINT32;
	END;



	LPNMLVCUSTOMDRAW = UNTRACED REF NMLVCUSTOMDRAW;
	NMLVCUSTOMDRAW = RECORD
		nmcd: NMCUSTOMDRAW;
		clrText: COLORREF;
		clrTextBk: COLORREF;
		iSubItem: INT32;
	END;


	LPNMLVCACHEHINT = UNTRACED REF NMLVCACHEHINT;
	NMLVCACHEHINT = RECORD
		hdr: NMHDR;
		iFrom: INT32;
		iTo: INT32;
	END;

	LPNM_CACHEHINT = LPNMLVCACHEHINT;
	PNM_CACHEHINT  = LPNMLVCACHEHINT;
	NM_CACHEHINT   = NMLVCACHEHINT;


	LPNMLVFINDITEM = UNTRACED REF NMLVFINDITEM;
	NMLVFINDITEM = RECORD
		hdr: NMHDR;
		iStart: INT32;
		lvfi: LVFINDINFO;
	END;

	PNM_FINDITEM   = LPNMLVFINDITEM;
	LPNM_FINDITEM  = LPNMLVFINDITEM;
	NM_FINDITEM    = NMLVFINDITEM;


	LPNMLVODSTATECHANGE = UNTRACED REF NMLVODSTATECHANGE;
	NMLVODSTATECHANGE = RECORD
		hdr: NMHDR;
		iFrom: INT32;
		iTo: INT32;
		uNewState: UINT32;
		uOldState: UINT32;
	END;

	PNM_ODSTATECHANGE  = LPNMLVODSTATECHANGE;
	LPNM_ODSTATECHANGE = LPNMLVODSTATECHANGE;
	NM_ODSTATECHANGE   = NMLVODSTATECHANGE;


	LPNMLVDISPINFO = UNTRACED REF NMLVDISPINFO;
	NMLVDISPINFO = RECORD
		hdr: NMHDR;
		item: LVITEM;
	END;


	LPNMLVKEYDOWN = UNTRACED REF NMLVKEYDOWN;
	NMLVKEYDOWN = RECORD
		hdr: NMHDR;
		wVKey: UINT16;
		(*flags: UINT32;*)
        unaligned_flags: ARRAY [0..1] OF UINT16;
	END;


	LPNMLVGETINFOTIP = UNTRACED REF NMLVGETINFOTIP;
	NMLVGETINFOTIP = RECORD
		hdr: NMHDR;
		dwFlags: UINT32;
		pszText: PSTR;
		cchTextMax: INT32;
		iItem: INT32;
		iSubItem: INT32;
		lParam: LPARAM;
	END;

TYPE
	RefIntArray = UNTRACED REF ARRAY [0..0] OF INTEGER;


(* functions (macros) *)

PROCEDURE GetItem(hwnd: HWND; pitem: LPLVITEM): BOOLEAN;
PROCEDURE SetItem(hwnd: HWND; pitem: LPLVITEM): BOOLEAN;
PROCEDURE InsertItem(hwnd: HWND; pitem: LPLVITEM): INTEGER;
PROCEDURE DeleteItem(hwnd: HWND; i: INTEGER): BOOLEAN;
PROCEDURE DeleteAllItems(hwnd: HWND): BOOLEAN;
PROCEDURE GetItemCount(hwnd: HWND): INTEGER;
PROCEDURE EditLabel(hwnd: HWND; iItem: INTEGER): HWND;
PROCEDURE GetEditControl(hwnd: HWND): HWND;
PROCEDURE GetColumn(hwnd: HWND; iCol: INTEGER; pcol: LPLVCOLUMN): BOOLEAN;
PROCEDURE SetColumn(hwnd: HWND; iCol: INTEGER; pcol: LPLVCOLUMN): BOOLEAN;
PROCEDURE InsertColumn(hwnd: HWND; iCol: INTEGER; pcol: LPLVCOLUMN): INTEGER;
PROCEDURE DeleteColumn(hwnd: HWND; iCol: INTEGER): BOOLEAN;
PROCEDURE SetItemText(hwnd: HWND; i, iSubItem: INTEGER; text: TEXT);
PROCEDURE SetExtendedListViewStyle(hwnd: HWND; dw: UINT32);
PROCEDURE GetNextItem(hwnd: HWND; iStart: INTEGER; flags: UINT32): INTEGER;
PROCEDURE SetItemState(hwnd: HWND; i: INTEGER; state, mask: UINT32): BOOLEAN;
PROCEDURE GetItemText(hwnd: HWND; i, iSubItem: INTEGER): TEXT;
PROCEDURE CreateDragImage(hwnd: HWND; i: INTEGER; lpptUpLeft: PPOINT): HIMAGELIST;
PROCEDURE HitTest(hwnd: HWND; pinfo: LPLVHITTESTINFO): INTEGER;
PROCEDURE Scroll(hwnd: HWND; dx, dy: INTEGER): BOOLEAN;
PROCEDURE GetSelectedCount(hwnd: HWND): INTEGER;
PROCEDURE SortItems(
	hwnd: HWND; 
	callback: <*CALLBACK*> PROCEDURE(p1, p2: ADDRESS; param: ADDRESS): INTEGER; 
	param: ADDRESS
): BOOLEAN;
PROCEDURE SortItemsEx(
	hwnd: HWND; 
	callback: <*CALLBACK*> PROCEDURE(p1, p2: INTEGER; param: ADDRESS): INTEGER; 
	param: ADDRESS
): BOOLEAN;
PROCEDURE GetColumnWidth(hwnd: HWND; iCol: INTEGER): INTEGER;
PROCEDURE SetColumnWidth(hwnd: HWND; iCol, cx: INTEGER): BOOLEAN;
PROCEDURE GetHeader(hwnd: HWND): HWND;
PROCEDURE GetBkColor(hwnd: HWND): COLORREF;
PROCEDURE SetBkColor(hwnd: HWND; clrBk: COLORREF): BOOLEAN;
PROCEDURE GetImageList(hwnd: HWND; iImageList: INTEGER): HIMAGELIST;
PROCEDURE SetImageList(hwnd: HWND; himl: HIMAGELIST; iImageList: INTEGER): HIMAGELIST;
PROCEDURE GetCallbackMask(hwnd: HWND): UINT32;
PROCEDURE SetCallbackMask(hwnd: HWND; mask: UINT32): BOOLEAN;
PROCEDURE FindItem(hwnd: HWND; iStart: INTEGER; plvfi: LPFINDINFO): INTEGER;
PROCEDURE GetItemRect(hwnd: HWND; i: INTEGER; prc: PRECT; code: INTEGER): BOOLEAN;
PROCEDURE SetItemPosition(hwnd: HWND; i: INTEGER; x, y: UINT16): BOOLEAN;
PROCEDURE GetItemPosition(hwnd: HWND; i: INTEGER; ppt: PPOINT): BOOLEAN;
PROCEDURE GetStringWidth(hwnd: HWND; psz: PCTSTR): INTEGER;
PROCEDURE EnsureVisible(hwnd: HWND; i: INTEGER; fPartialOK: BOOLEAN): BOOLEAN;
PROCEDURE RedrawItems(hwnd: HWND; iFirst, iLast: INTEGER): BOOLEAN;
PROCEDURE Arrange(hwnd: HWND; code: UINT32): BOOLEAN;
PROCEDURE GetViewRect(hwnd: HWND; prc: PRECT): BOOLEAN;
PROCEDURE GetTextColor(hwnd: HWND): COLORREF;
PROCEDURE SetTextColor(hwnd: HWND; clrText: COLORREF): BOOLEAN;
PROCEDURE GetTextBkColor(hwnd: HWND): COLORREF;
PROCEDURE SetTextBkColor(hwnd: HWND; clrTextBk: COLORREF): BOOLEAN;
PROCEDURE GetTopIndex(hwnd: HWND): INTEGER;
PROCEDURE GetCountPerPage(hwnd: HWND): INTEGER;
PROCEDURE GetOrigin(hwnd: HWND; ppt: PPOINT): BOOLEAN;
PROCEDURE Update(hwnd: HWND; i: INTEGER): BOOLEAN;
PROCEDURE SetUnicodeFormat(hwnd: HWND; fUnicode: BOOLEAN): BOOLEAN;
PROCEDURE GetUnicodeFormat(hwnd: HWND): BOOLEAN;
PROCEDURE GetItemState(hwnd: HWND; i: INTEGER; mask: UINT32): UINT32;
PROCEDURE SetItemCount(hwnd: HWND; cItems: INTEGER);
PROCEDURE SetItemCountEx(hwnd: HWND; cItems: INTEGER; dwFlags: UINT32);
PROCEDURE GetItemSpacing(hwnd: HWND; fSmall: BOOLEAN): UINT32;
PROCEDURE GetISearchString(hwnd: HWND; lpsz: PSTR): BOOLEAN;
PROCEDURE SetIconSpacing(hwnd: HWND; cx, cy: UINT16): UINT32;
PROCEDURE SetExtendedListViewStyleEx(hwnd: HWND; dwMask, dw: UINT32): UINT32;
PROCEDURE GetExtendedListViewStyle(hwnd: HWND): UINT32;
PROCEDURE SubItemHitTest(hwnd: HWND; plvhti: LPLVHITTESTINFO): INTEGER;
PROCEDURE SetColumnOrderArray(hwnd: HWND; iCount: INTEGER; pi: RefIntArray): BOOLEAN;
PROCEDURE GetColumnOrderArray(hwnd: HWND; iCount: INTEGER; pi: RefIntArray): BOOLEAN;
PROCEDURE SetHotItem(hwnd: HWND; i: INTEGER): INTEGER;
PROCEDURE GetHotItem(hwnd: HWND): INTEGER;
PROCEDURE SetHotCursor(hwnd: HWND; hcur: HCURSOR): HCURSOR;
PROCEDURE GetHotCursor(hwnd: HWND): HCURSOR;
PROCEDURE ApproximateViewRect(hwnd: HWND; iWidth, iHeight: UINT16; iCount: INTEGER): UINT32;
PROCEDURE SetWorkAreas(hwnd: HWND; nWorkAreas: INTEGER; prc: PRECT): BOOLEAN;
PROCEDURE GetWorkAreas(hwnd: HWND; nWorkAreas: INTEGER; prc: PRECT): BOOLEAN;
PROCEDURE GetNumberOfWorkAreas(hwnd: HWND; pnWorkAreas: UNTRACED REF UINT32): BOOLEAN;
PROCEDURE GetSelectionMark(hwnd: HWND): INTEGER;
PROCEDURE SetSelectionMark(hwnd: HWND; i: INTEGER): INTEGER;
PROCEDURE SetHoverTime(hwnd: HWND; dwHoverTimeMs: UINT32): UINT32;
PROCEDURE GetHoverTime(hwnd: HWND): UINT32;
PROCEDURE SetToolTips(hwnd: HWND; hwndNewHwnd: HWND): HWND;
PROCEDURE GetToolTips(hwnd: HWND): HWND;
PROCEDURE SetBkImage(hwnd: HWND; plvbki: LPLVBKIMAGE): BOOLEAN;
PROCEDURE GetBkImage(hwnd: HWND; plvbki: LPLVBKIMAGE): BOOLEAN;
PROCEDURE GetCheckState(hwnd: HWND; i: UINT32): UINT32;
PROCEDURE SetItemPosition32(hwnd: HWND; i, x, y: INTEGER);
PROCEDURE GetSubItemRect(hwnd: HWND; iItem, iSubItem, code: INTEGER; prc: PRECT): BOOLEAN;


END WinListView.
