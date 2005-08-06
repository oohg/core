/*
 * $Id: i_windefs.ch,v 1.1 2005-08-06 23:53:54 guerra000 Exp $
 */
/*
 * ooHG source code:
 * Windows' definitions
 *
 * Copyright 2005 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.guerra.com.mx
 *
 * Portions of this code are copyrighted by the Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the ooHG Project gives permission for
 * additional uses of the text contained in its release of ooHG.
 *
 * The exception is that, if you link the ooHG libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the ooHG library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the ooHG
 * Project under the name ooHG. If you copy code from other
 * ooHG Project or Free Software Foundation releases into a copy of
 * ooHG, as the General Public License permits, the exception does
 * not apply to the code that you add in this way. To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for ooHG, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */
/*----------------------------------------------------------------------------
 MINIGUI - Harbour Win32 GUI library source code

 Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 http://www.geocities.com/harbour_minigui/

 This program is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later
 version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along with
 this software; see the file COPYING. If not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or
 visit the web site http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text
 contained in this release of Harbour Minigui.

 The exception is that, if you link the Harbour Minigui library with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the
 Harbour-Minigui library code into it.

 Parts of this project are based upon:

        "Harbour GUI framework for Win32"
        Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
        Copyright 2001 Antonio Linares <alinares@fivetech.com>
        www - http://www.harbour-project.org

        "Harbour Project"
        Copyright 1999-2003, http://www.harbour-project.org/
---------------------------------------------------------------------------*/

// WM_* definitions
#define WM_CREATE	1
#define WM_DESTROY      2
#define WM_MOVE         3
#define WM_SIZE		5
#define WM_ACTIVATE	6
#define WM_SETFOCUS	7
#define WM_KILLFOCUS	8
#define WM_PAINT	15
#define WM_CLOSE        16
#define WM_QUIT		18
#define WM_ERASEBKGND   20
#define WM_SHOWWINDOW	24
#define WM_ACTIVATEAPP	28
#define WM_NEXTDLGCTL	40
#define WM_DRAWITEM     43
#define WM_VKEYTOITEM	46
#define WM_NOTIFY	78
#define WM_HELP         83
#define WM_CONTEXTMENU	123
#define WM_GETDLGCODE	135
#define WM_KEYDOWN	256
#define WM_KEYUP        257
#define WM_CHAR         258
#define WM_SYSKEYDOWN	260
#define WM_INITDIALOG	272
#define WM_COMMAND      273 // 0x0111
#define WM_SYSCOMMAND	274
#define WM_TIMER	275
#define WM_HSCROLL	276
#define WM_VSCROLL      277 //0x0115
#define WM_CTLCOLOREDIT	307
#define WM_CTLCOLORLISTBOX	308
#define WM_CTLCOLORBTN	309
#define WM_CTLCOLORDLG	310
#define WM_CTLCOLORSTATIC 312
#define WM_MOUSEMOVE    512 // 0x0200
#define WM_LBUTTONDOWN  513 // 0x0201
#define WM_LBUTTONUP    514 // 0x0202
#define WM_LBUTTONDBLCLK 515 // 0x0203
#define WM_RBUTTONDOWN  516 // 0x0204
#define WM_RBUTTONUP    517 // 0x0205
#define WM_MOUSEWHEEL	0x20A
#define WM_MOUSEHOVER	0x2a1
#define WM_SIZING	532
#define WM_MOVING	534
#define WM_ENTERSIZEMOVE 561
#define WM_EXITSIZEMOVE	562

#define WM_PASTE	770
#define WM_CLEAR	771
#define WM_UNDO         772
#define WM_HOTKEY	786
// User-defined WM_*
#define WM_USER         0x0400
#define WM_TASKBAR      WM_USER+1043

// Generic WM_NOTIFY calls
#define NM_FIRST        0
#define NM_OUTOFMEMORY  (NM_FIRST-1)
#define NM_CLICK        (NM_FIRST-2)    // uses NMCLICK struct
#define NM_DBLCLK       (NM_FIRST-3)                                              // Working in TControl
#define NM_RETURN       (NM_FIRST-4)
#define NM_RCLICK       (NM_FIRST-5)    // uses NMCLICK struct
#define NM_RDBLCLK      (NM_FIRST-6)
#define NM_SETFOCUS     (NM_FIRST-7)                                              // Working in TControl
#define NM_KILLFOCUS    (NM_FIRST-8)                                              // Working in TControl
#define NM_CUSTOMDRAW   (NM_FIRST-12)
#define NM_HOVER        (NM_FIRST-13)
#define NM_NCHITTEST    (NM_FIRST-14)   // uses NMMOUSE struct
#define NM_KEYDOWN      (NM_FIRST-15)   // uses NMKEY struct
#define NM_RELEASEDCAPTURE (NM_FIRST-16)
#define NM_SETCURSOR    (NM_FIRST-17)   // uses NMMOUSE struct
#define NM_CHAR         (NM_FIRST-18)   // uses NMCHAR struct
// #define NM_TOOLTIPSCREATED (NM_FIRST-19)   // notify of when the tooltips window is create
// #define NM_LDOWN        (NM_FIRST-20)
// #define NM_RDOWN        (NM_FIRST-21)

// System Colors
#define COLOR_SCROLLBAR         0
#define COLOR_BACKGROUND        1
#define COLOR_ACTIVECAPTION     2
#define COLOR_INACTIVECAPTION   3
#define COLOR_MENU              4
#define COLOR_WINDOW            5
#define COLOR_WINDOWFRAME       6
#define COLOR_MENUTEXT          7
#define COLOR_WINDOWTEXT        8
#define COLOR_CAPTIONTEXT       9
#define COLOR_ACTIVEBORDER      10
#define COLOR_INACTIVEBORDER    11
#define COLOR_APPWORKSPACE      12
#define COLOR_HIGHLIGHT         13
#define COLOR_HIGHLIGHTTEXT     14
#define COLOR_BTNFACE           15
#define COLOR_BTNSHADOW         16
#define COLOR_GRAYTEXT          17
#define COLOR_BTNTEXT           18
#define COLOR_INACTIVECAPTIONTEXT 19
#define COLOR_BTNHIGHLIGHT      20
#define COLOR_3DDKSHADOW        21
#define COLOR_3DLIGHT           22
#define COLOR_INFOTEXT          23
#define COLOR_INFOBK            24
// #define COLOR_HOTLIGHT          26
// #define COLOR_GRADIENTACTIVECAPTION 27
// #define COLOR_GRADIENTINACTIVECAPTION 28
#define COLOR_DESKTOP           COLOR_BACKGROUND
#define COLOR_3DFACE            COLOR_BTNFACE
#define COLOR_3DSHADOW          COLOR_BTNSHADOW
#define COLOR_3DHIGHLIGHT       COLOR_BTNHIGHLIGHT
#define COLOR_3DHILIGHT         COLOR_BTNHIGHLIGHT
#define COLOR_BTNHILIGHT        COLOR_BTNHIGHLIGHT

#DEFINE DC_BRUSH 18
#define LVN_BEGINDRAG	(-109)
#define WS_VISIBLE	0x10000000
#define WS_GROUP	0x20000
#define BS_AUTORADIOBUTTON	9
#define WS_CHILD	0x40000000
#define BS_NOTIFY	0x4000
#define GWL_STYLE	(-16)
#define CBN_EDITCHANGE	5
#define SIZE_MAXHIDE	4
#define SIZE_MAXIMIZED	2
#define SIZEFULLSCREEN	2
#define SIZE_MAXSHOW	3
#define SIZE_MINIMIZED	1
#define SIZEICONIC	1
#define SIZE_RESTORED	0
#define SIZENORMAL	0
#define	TBN_FIRST	(-700)
#define TBN_DROPDOWN	(TBN_FIRST-10)

#define OPAQUE	2
#define DKGRAY_BRUSH	3
#define LVN_GETDISPINFO        (-150)
#define EN_MSGFILTER	1792
#define DLGC_WANTCHARS	128
#define DLGC_WANTMESSAGE	4
#define MCN_FIRST           -750
#define MCN_LAST            -759
#define MCN_SELCHANGE       (MCN_FIRST + 1)
#define MCN_SELECT          (MCN_FIRST + 4)

#define STN_CLICKED         0
#define STN_DBLCLK          1
#define STN_ENABLE          2
#define STN_DISABLE         3

#define SB_HORZ	0
#define BS_DEFPUSHBUTTON	1
#define BM_SETSTYLE	244
#define SB_CTL	2
#define SB_VERT	1
#define SB_LINEUP	0
#define SB_LINEDOWN	1
#define SB_LINELEFT	0
#define SB_LINERIGHT	1
#define SB_PAGEUP	2
#define SB_PAGEDOWN	3
#define SB_PAGELEFT	2
#define SB_PAGERIGHT	3
#define SB_THUMBPOSITION	4
#define SB_THUMBTRACK	5
#define SB_ENDSCROLL	8
#define SB_LEFT	6
#define SB_RIGHT	7
#define SB_BOTTOM	7
#define SB_TOP	6

#define TVN_SELCHANGEDW	(-451)
#define TVN_SELCHANGED TVN_SELCHANGEDA
#define TVN_SELCHANGEDA	(-402)

//New define for TaskBar
#define ID_TASKBAR      0

#define TB_AUTOSIZE	1057
#define TRANSPARENT	1
#define GRAY_BRUSH	2
#define NULL_BRUSH	  5
#define BN_CLICKED	0
#define LBN_KILLFOCUS	5
#define LBN_SETFOCUS	4
#define CBN_KILLFOCUS	4
#define CBN_SETFOCUS	3
#define BN_KILLFOCUS	7
#define BN_SETFOCUS	6
#define LVN_KEYDOWN	(-155)
#define LVN_COLUMNCLICK	(-108)
#define LBN_DBLCLK	2
#define TCN_SELCHANGE	(-551)
#define TCN_SELCHANGING	(-552)
#define DTN_FIRST	(-760)
#define DTN_DATETIMECHANGE (DTN_FIRST+1)
#define TB_ENDTRACK	8
#define CBN_SELCHANGE	1
#define LVN_ITEMCHANGED	(-101)
#define LBN_SELCHANGE	1
#define EN_SETFOCUS	256
#define EN_KILLFOCUS	512
#define EM_SETMODIFY	185
#define EM_GETLINE	196
#define EM_SETSEL	177
#define EM_GETSEL	176
#define EM_UNDO		199
#define EN_CHANGE       768
#define EN_UPDATE       1024
#define MK_LBUTTON	1
#define TBM_SETPOS	1029
#define TBM_GETPOS	1024
#define PBM_SETPOS	1026
#define PBM_GETPOS   1032
#define SC_CLOSE	61536
#define TTN_NEEDTEXT    (-520)