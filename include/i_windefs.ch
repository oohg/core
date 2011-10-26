/*
 * $Id: i_windefs.ch,v 1.41 2011-10-26 21:20:06 fyurisich Exp $
 */
/*
 * ooHG source code:
 * Windows' definitions
 *
 * Copyright 2005-2008 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.oohg.org
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

#ifndef __I_WINDEFS__
#define __I_WINDEFS__

// WM_* definitions
#define WM_CREATE                     1
#define WM_DESTROY                    2
#define WM_MOVE                       3
#define WM_SIZE                       5
#define WM_ACTIVATE                   6
#define WM_SETFOCUS                   7
#define WM_KILLFOCUS                  8
#define WM_GETTEXT                    13
#define WM_PAINT                      15
#define WM_CLOSE                      16
#define WM_QUIT                       18
#define WM_ERASEBKGND                 20
#define WM_SHOWWINDOW                 24
#define WM_ACTIVATEAPP                28
#define WM_CANCELMODE                 31
#define WM_NEXTDLGCTL                 40
#define WM_DRAWITEM                   43
#define WM_VKEYTOITEM                 46
#define WM_WINDOWPOSCHANGING          70
#define WM_WINDOWPOSCHANGED           71
#define WM_NOTIFY                     78
#define WM_HELP                       83
#define WM_CONTEXTMENU                123
#define WM_NCPAINT                    133
#define WM_NCACTIVATE                 134
#define WM_GETDLGCODE                 135
#define WM_NCLBUTTONUP                162
#define WM_NCLBUTTONDOWN              161
#define WM_KEYDOWN                    256
#define WM_KEYUP                      257
#define WM_CHAR                       258
#define WM_SYSKEYDOWN                 260
#define WM_INITDIALOG                 272
#define WM_COMMAND                    273 // 0x0111
#define WM_SYSCOMMAND                 274
#define WM_TIMER                      275
#define WM_HSCROLL                    276
#define WM_VSCROLL                    277 //0x0115
#define WM_CTLCOLORMSGBOX             306
#define WM_CTLCOLOREDIT               307
#define WM_CTLCOLORLISTBOX            308
#define WM_CTLCOLORBTN                309
#define WM_CTLCOLORDLG                310
#define WM_CTLCOLORSCROLLBAR          311
#define WM_CTLCOLORSTATIC             312
#define WM_MOUSEMOVE                  512 // 0x0200
#define WM_LBUTTONDOWN                513 // 0x0201
#define WM_LBUTTONUP                  514 // 0x0202
#define WM_LBUTTONDBLCLK              515 // 0x0203
#define WM_RBUTTONDOWN                516 // 0x0204
#define WM_RBUTTONUP                  517 // 0x0205
#define WM_RBUTTONDBLCLK              518 // 0x0206
#define WM_MBUTTONDOWN                519 // 0x0207
#define WM_MBUTTONUP                  520 // 0x0208
#define WM_MBUTTONDBLCLK              521 // 0x0209
#define WM_MOUSEWHEEL                 522 // 0x020a
#define WM_MOUSEHOVER                 0x2a1
#define WM_SIZING                     532
#define WM_CAPTURECHANGED             533
#define WM_MOVING                     534
#define WM_ENTERSIZEMOVE              561
#define WM_EXITSIZEMOVE               562
#define WM_PASTE                      770
#define WM_CLEAR                      771
#define WM_UNDO                       772
#define WM_HOTKEY                     786
// User-defined WM_*
#define WM_USER                       0x0400
#define CBEM_SETIMAGELIST             ( WM_USER + 2 )
#define WM_TASKBAR                    ( WM_USER + 1043 )
#define WM_APP                        0x8000

// Generic WM_NOTIFY calls
#define NM_FIRST                      0
#define NM_OUTOFMEMORY                ( NM_FIRST - 1 )
#define NM_CLICK                      ( NM_FIRST - 2 )    // uses NMCLICK struct
#define NM_DBLCLK                     ( NM_FIRST - 3 )    // Working in TControl
#define NM_RETURN                     ( NM_FIRST - 4 )
#define NM_RCLICK                     ( NM_FIRST - 5 )    // uses NMCLICK struct
#define NM_RDBLCLK                    ( NM_FIRST - 6 )
#define NM_SETFOCUS                   ( NM_FIRST - 7 )    // Working in TControl
#define NM_KILLFOCUS                  ( NM_FIRST - 8 )    // Working in TControl
#define NM_CUSTOMDRAW                 ( NM_FIRST - 12 )
#define NM_HOVER                      ( NM_FIRST - 13 )
#define NM_NCHITTEST                  ( NM_FIRST - 14 )   // uses NMMOUSE struct
#define NM_KEYDOWN                    ( NM_FIRST - 15 )   // uses NMKEY struct
#define NM_RELEASEDCAPTURE            ( NM_FIRST - 16 )
#define NM_SETCURSOR                  ( NM_FIRST - 17 )   // uses NMMOUSE struct
#define NM_CHAR                       ( NM_FIRST - 18 )   // uses NMCHAR struct
#define NM_TOOLTIPSCREATED            ( NM_FIRST - 19 )   // notify of when the tooltips window is create
#define NM_LDOWN                      ( NM_FIRST - 20 )
#define NM_RDOWN                      ( NM_FIRST - 21 )

// System Colors
#define COLOR_SCROLLBAR               0
#define COLOR_BACKGROUND              1
#define COLOR_ACTIVECAPTION           2
#define COLOR_INACTIVECAPTION         3
#define COLOR_MENU                    4
#define COLOR_WINDOW                  5
#define COLOR_WINDOWFRAME             6
#define COLOR_MENUTEXT                7
#define COLOR_WINDOWTEXT              8
#define COLOR_CAPTIONTEXT             9
#define COLOR_ACTIVEBORDER            10
#define COLOR_INACTIVEBORDER          11
#define COLOR_APPWORKSPACE            12
#define COLOR_HIGHLIGHT               13
#define COLOR_HIGHLIGHTTEXT           14
#define COLOR_BTNFACE                 15
#define COLOR_BTNSHADOW               16
#define COLOR_GRAYTEXT                17
#define COLOR_BTNTEXT                 18
#define COLOR_INACTIVECAPTIONTEXT     19
#define COLOR_BTNHIGHLIGHT            20
#define COLOR_3DDKSHADOW              21
#define COLOR_3DLIGHT                 22
#define COLOR_INFOTEXT                23
#define COLOR_INFOBK                  24
#define COLOR_HOTLIGHT                26
#define COLOR_GRADIENTACTIVECAPTION   27
#define COLOR_GRADIENTINACTIVECAPTION 28
#define COLOR_DESKTOP                 COLOR_BACKGROUND
#define COLOR_3DFACE                  COLOR_BTNFACE
#define COLOR_3DSHADOW                COLOR_BTNSHADOW
#define COLOR_3DHIGHLIGHT             COLOR_BTNHIGHLIGHT
#define COLOR_3DHILIGHT               COLOR_BTNHIGHLIGHT
#define COLOR_BTNHILIGHT              COLOR_BTNHIGHLIGHT

// Edit Control Styles
#define ES_LEFT                       0     // 0x0000
#define ES_CENTER                     1     // 0x0001
#define ES_RIGHT                      2     // 0x0002
#define ES_MULTILINE                  4     // 0x0004
#define ES_UPPERCASE                  8     // 0x0008
#define ES_LOWERCASE                  16    // 0x0010
#define ES_PASSWORD                   32    // 0x0020
#define ES_AUTOVSCROLL                64    // 0x0040
#define ES_AUTOHSCROLL                128   // 0x0080
#define ES_NOHIDESEL                  256   // 0x0100
#define ES_OEMCONVERT                 1024  // 0x0400
#define ES_READONLY                   2048  // 0x0800
#define ES_WANTRETURN                 4096  // 0x1000
#define ES_NUMBER                     8192  // 0x2000

// Window Styles
#define WS_OVERLAPPED                 0x00000000
#define WS_TABSTOP                    0x00010000
#define WS_GROUP                      0x00020000
#define WS_THICKFRAME                 0x00040000
#define WS_SYSMENU                    0x00080000
#define WS_HSCROLL                    0x00100000
#define WS_VSCROLL                    0x00200000
#define WS_DLGFRAME                   0x00400000
#define WS_BORDER                     0x00800000
#define WS_CAPTION                    0x00C00000   // WS_BORDER + WS_DLGFRAME
#define WS_MAXIMIZE                   0x01000000
#define WS_CLIPCHILDREN               0x02000000
#define WS_CLIPSIBLINGS               0x04000000
#define WS_DISABLED                   0x08000000
#define WS_VISIBLE                    0x10000000
#define WS_MINIMIZE                   0x20000000
#define WS_CHILD                      0x40000000
#define WS_POPUP                      0x80000000
//
#define WS_MAXIMIZEBOX                0x00010000
#define WS_MINIMIZEBOX                0x00020000
#define WS_TILED                      WS_OVERLAPPED
#define WS_ICONIC                     WS_MINIMIZE
#define WS_SIZEBOX                    WS_THICKFRAME
#define WS_TILEDWINDOW                WS_OVERLAPPEDWINDOW

// Extendend Window Styles
#define WS_EX_DLGMODALFRAME           0x00000001
#define WS_EX_NOPARENTNOTIFY          0x00000004
#define WS_EX_TOPMOST                 0x00000008
#define WS_EX_ACCEPTFILES             0x00000010
#define WS_EX_TRANSPARENT             0x00000020
#define WS_EX_MDICHILD                0x00000040
#define WS_EX_TOOLWINDOW              0x00000080
#define WS_EX_WINDOWEDGE              0x00000100
#define WS_EX_CLIENTEDGE              0x00000200
#define WS_EX_CONTEXTHELP             0x00000400
#define WS_EX_RIGHT                   0x00001000
#define WS_EX_LEFT                    0x00000000
#define WS_EX_RTLREADING              0x00002000
#define WS_EX_LTRREADING              0x00000000
#define WS_EX_LEFTSCROLLBAR           0x00004000
#define WS_EX_RIGHTSCROLLBAR          0x00000000
#define WS_EX_CONTROLPARENT           0x00010000
#define WS_EX_STATICEDGE              0x00020000
#define WS_EX_APPWINDOW               0x00040000
#define WS_EX_OVERLAPPEDWINDOW        ( WS_EX_WINDOWEDGE + WS_EX_CLIENTEDGE )
#define WS_EX_PALETTEWINDOW           ( WS_EX_WINDOWEDGE + WS_EX_TOOLWINDOW + WS_EX_TOPMOST )

//
#define RBS_TOOLTIPS                  256
#define RBS_VARHEIGHT                 512
#define RBS_BANDBORDERS               1024
#define RBS_FIXEDORDER                2048
#define RBS_REGISTERDROP              4096
#define RBS_AUTOSIZE                  8192
#define RBS_VERTICALGRIPPER           16384
#define RBS_DBLCLKTOGGLE              32768

// Button Control
#define BM_GETCHECK                   240
#define BM_SETCHECK                   241
#define BM_GETSTATE                   242
#define BM_SETSTATE                   243
#define BM_SETSTYLE                   244
#define BM_CLICK                      245
#define BM_GETIMAGE                   246
#define BM_SETIMAGE                   247
#define BST_UNCHECKED                 0
#define BST_CHECKED                   1
#define BST_INDETERMINATE             2
#define BST_PUSHED                    4
#define BST_FOCUS                     8

// ListView messages
#define LVM_FIRST                     0x1000
#define LVM_GETBKCOLOR                ( LVM_FIRST + 0 )
#define LVM_SETBKCOLOR                ( LVM_FIRST + 1 )
#define LVM_GETIMAGELIST              ( LVM_FIRST + 2 )
#define LVM_SETIMAGELIST              ( LVM_FIRST + 3 )
#define LVM_GETITEMCOUNT              ( LVM_FIRST + 4 )
#define LVSIL_NORMAL                  0
#define LVSIL_SMALL                   1
#define LVSIL_STATE                   2
#define LVSCW_AUTOSIZE                ( -1 )
#define LVSCW_AUTOSIZE_USEHEADER      ( -2 )

// ListView styles
#define LVS_ICON                      0
#define LVS_REPORT                    1
#define LVS_SMALLICON                 2
#define LVS_LIST                      3
#define LVS_TYPEMASK                  3
#define LVS_SINGLESEL                 4
#define LVS_SHOWSELALWAYS             8
#define LVS_SORTASCENDING             16
#define LVS_SORTDESCENDING            32
#define LVS_SHAREIMAGELISTS           64
#define LVS_NOLABELWRAP               128
#define LVS_AUTOARRANGE               256
#define LVS_EDITLABELS                512
#define LVS_OWNERDATA                 0x1000
#define LVS_NOSCROLL                  0x2000
#define LVS_TYPESTYLEMASK             0xfc00
#define LVS_ALIGNTOP                  0
#define LVS_ALIGNLEFT                 0x0800
#define LVS_ALIGNMASK                 0x0c00
#define LVS_OWNERDRAWFIXED            0x0400
#define LVS_NOCOLUMNHEADER            0x4000
#define LVS_NOSORTHEADER              0x8000

// Listbox Styles
#define LBS_NOTIFY                    1
#define LBS_SORT                      2
#define LBS_NOREDRAW                  4
#define LBS_MULTIPLESEL               8
#define LBS_OWNERDRAWFIXED            16
#define LBS_OWNERDRAWVARIABLE         32
#define LBS_HASSTRINGS                64
#define LBS_USETABSTOPS               128
#define LBS_NOINTEGRALHEIGHT          256
#define LBS_MULTICOLUMN               512
#define LBS_WANTKEYBOARDINPUT         1024
#define LBS_EXTENDEDSEL               2048
#define LBS_DISABLENOSCROLL           4096
#define LBS_NODATA                    8192
#define LBS_NOSEL                     16384
#define LBS_STANDARD                  ( LBS_NOTIFY + LBS_SORT + WS_VSCROLL + WS_BORDER )

// TreeView messages
#define TV_FIRST                      0x1100
#define TVM_INSERTITEM                ( TV_FIRST + 0 )  // + 50
#define TVM_DELETEITEM                ( TV_FIRST + 1 )
#define TVM_EXPAND                    ( TV_FIRST + 2 )
#define TVM_GETITEMRECT               ( TV_FIRST + 4 )
#define TVM_GETCOUNT                  ( TV_FIRST + 5 )
#define TVM_GETINDENT                 ( TV_FIRST + 6 )
#define TVM_SETINDENT                 ( TV_FIRST + 7 )
#define TVM_GETIMAGELIST              ( TV_FIRST + 8 )
#define TVM_SETIMAGELIST              ( TV_FIRST + 9 )
#define TVM_GETNEXTITEM               ( TV_FIRST + 10 )
#define TVM_SELECTITEM                ( TV_FIRST + 11 )
#define TVM_GETEDITCONTROL            ( TV_FIRST + 15 )
#define TVSIL_NORMAL                  0
#define TVSIL_STATE                   2
#define TVE_COLLAPSE                  1
#define TVE_EXPAND                    2
//
#define TVS_HASBUTTONS                1
#define TVS_HASLINES                  2
#define TVS_LINESATROOT               4
#define TVS_EDITLABELS                8
#define TVS_DISABLEDRAGDROP           16
#define TVS_SHOWSELALWAYS             32
#define TVS_RTLREADING                64
#define TVS_NOTOOLTIPS                128
#define TVS_CHECKBOXES                256
#define TVS_TRACKSELECT               512
#define TVS_SINGLEEXPAND              1024
#define TVS_INFOTIP                   2048
#define TVS_FULLROWSELECT             4096
#define TVS_NOSCROLL                  8192
#define TVS_NONEVENHEIGHT             16384
#define TVS_NOHSCROLL                 32768

// Tab control messages
#define TCM_FIRST                     0x1300
#define TCM_GETIMAGELIST              ( TCM_FIRST + 2 )
#define TCM_SETIMAGELIST              ( TCM_FIRST + 3 )
#define TCM_GETITEMCOUNT              ( TCM_FIRST + 4 )

// Header messages
#define HDM_FIRST                     0x1200

#define CLR_NONE                      0xFFFFFFFF
#define CLR_DEFAULT                   0xFF000000

#define LR_DEFAULTCOLOR               0
#define LR_MONOCHROME                 1
#define LR_COLOR                      2
#define LR_COPYRETURNORG              4
#define LR_COPYDELETEORG              8
#define LR_LOADFROMFILE               16
#define LR_LOADTRANSPARENT            32
#define LR_DEFAULTSIZE                64
#define LR_VGACOLOR                   128
#define LR_LOADMAP3DCOLORS            0x1000
#define LR_CREATEDIBSECTION           0x2000
#define LR_COPYFROMRESOURCE           0x4000
#define LR_SHARED                     0x8000

// Button styles
#define BS_PUSHBUTTON                 0
#define BS_DEFPUSHBUTTON              1
#define BS_CHECKBOX                   2
#define BS_AUTOCHECKBOX               3
#define BS_RADIOBUTTON                4
#define BS_3STATE                     5
#define BS_AUTO3STATE                 6
#define BS_GROUPBOX                   7
#define BS_USERBUTTON                 8
#define BS_AUTORADIOBUTTON            9
#define BS_OWNERDRAW                  11
#define BS_LEFTTEXT                   32
#define BS_TEXT                       0
#define BS_ICON                       64
#define BS_BITMAP                     128
#define BS_LEFT                       256
#define BS_RIGHT                      512
#define BS_CENTER                     768
#define BS_TOP                        1024
#define BS_BOTTOM                     2048
#define BS_VCENTER                    3072
#define BS_PUSHLIKE                   4096
#define BS_MULTILINE                  8192
#define BS_NOTIFY                     16384
#define BS_FLAT                       32768
#define BS_RIGHTBUTTON                BS_LEFTTEXT

#DEFINE DC_BRUSH                      18
#define LVN_BEGINDRAG                 ( -109 )
#define GWL_STYLE                     ( -16 )
#define CBN_EDITCHANGE                5
#define SIZE_MAXHIDE                  4
#define SIZE_MAXIMIZED                2
#define SIZEFULLSCREEN                2
#define SIZE_MAXSHOW                  3
#define SIZE_MINIMIZED                1
#define SIZEICONIC                    1
#define SIZE_RESTORED                 0
#define SIZENORMAL                    0

#define OPAQUE                        2
#define DKGRAY_BRUSH                  3
#define LVN_GETDISPINFO               ( -150 )
#define EN_MSGFILTER                  1792
#define DLGC_WANTCHARS                128
#define DLGC_WANTMESSAGE              4
#define MCN_FIRST                     ( -750 )
#define MCN_LAST                      ( -759 )
#define MCN_SELCHANGE                 ( MCN_FIRST + 1 )
#define MCN_SELECT                    ( MCN_FIRST + 4 )

#define STN_CLICKED                   0
#define STN_DBLCLK                    1
#define STN_ENABLE                    2
#define STN_DISABLE                   3

#define SB_HORZ                       0
#define SB_CTL                        2
#define SB_VERT                       1
#define SB_LINEUP                     0
#define SB_LINEDOWN                   1
#define SB_LINELEFT                   0
#define SB_LINERIGHT                  1
#define SB_PAGEUP                     2
#define SB_PAGEDOWN                   3
#define SB_PAGELEFT                   2
#define SB_PAGERIGHT                  3
#define SB_THUMBPOSITION              4
#define SB_THUMBTRACK                 5
#define SB_ENDSCROLL                  8
#define SB_LEFT                       6
#define SB_RIGHT                      7
#define SB_BOTTOM                     7
#define SB_TOP                        6

#define TVN_SELCHANGINGA              ( -401 )
#define TVN_SELCHANGINGW              ( -450 )
#define TVN_SELCHANGING               TVN_SELCHANGINGA
#define TVN_SELCHANGEDW               ( -451 )
#define TVN_SELCHANGED                TVN_SELCHANGEDA
#define TVN_SELCHANGEDA               ( -402 )
#define TVN_BEGINLABELEDITW           ( -459 )
#define TVN_BEGINLABELEDIT            TVN_BEGINLABELEDITA
#define TVN_BEGINLABELEDITA           ( -410 )
#define TVN_ENDLABELEDITW             ( -460 )
#define TVN_ENDLABELEDIT              TVN_ENDLABELEDITA
#define TVN_ENDLABELEDITA             ( -411 )
#define TVN_KEYDOWN                   ( -412 )
#define TVN_BEGINDRAGA                ( -407 )
#define TVN_BEGINDRAGW                ( -456 )
#define TVN_BEGINDRAG                 TVN_BEGINDRAGA

//New define for TaskBar
#define ID_TASKBAR                    0

#define TB_AUTOSIZE                   1057
#define GRAY_BRUSH                    2
#define NULL_BRUSH                    5
#define BN_CLICKED                    0
#define LBN_KILLFOCUS                 5
#define LBN_SETFOCUS                  4
#define CBN_KILLFOCUS                 4
#define CBN_SETFOCUS                  3
#define BN_KILLFOCUS                  7
#define BN_SETFOCUS                   6
#define LVN_KEYDOWN                   ( -155 )
#define LVN_COLUMNCLICK               ( -108 )
#define LBN_DBLCLK                    2
#define TCN_SELCHANGE                 ( -551 )
#define TCN_SELCHANGING               ( -552 )
#define DTN_FIRST                     ( -760 )
#define DTN_DATETIMECHANGE            ( DTN_FIRST + 1 )
#define TB_ENDTRACK                   8
#define CBN_SELCHANGE                 1
#define CBN_DROPDOWN                  7
#define CBN_CLOSEUP                   8
#define LVN_ITEMCHANGED               ( -101 )
#define LBN_SELCHANGE                 1
#define EN_SETFOCUS                   256
#define EN_KILLFOCUS                  512
#define EN_CHANGE                     768
#define EN_UPDATE                     1024

#define EM_SCROLLCARET                183
#define EM_SETMODIFY                  185
#define EM_GETLINE                    196
#define EM_SETSEL                     177
#define EM_GETSEL                     176
#define EM_LIMITTEXT                  197
#define EM_UNDO                       199
#define EM_SETREADONLY                207
#define EM_GETLIMITTEXT               213
#define EM_SETBKGNDCOLOR              1091

#define MK_LBUTTON                    1
#define MK_CONTROL                    8
#define PBM_SETPOS                    1026
#define PBM_GETPOS                    1032
#define SC_CLOSE                      61536

// System metrics
#define SM_CXFULLSCREEN               16
#define SM_CYFULLSCREEN               17

// Tootips' definitions
#define TTM_SETTIPBKCOLOR             ( WM_USER + 19 )
#define TTM_SETTIPTEXTCOLOR           ( WM_USER + 20 )
#define TTM_SETMAXTIPWIDTH            ( WM_USER + 24 )
#define TTM_SETTITLE                  ( WM_USER + 32 )
#define TTI_NONE                      0
#define TTI_INFO                      1
#define TTI_WARNING                   2
#define TTI_ERROR                     3
#define TTN_NEEDTEXT                  ( -520 )
#define TTN_GETDISPINFO               ( -520 )

// Static Control Constants
#define SS_LEFT                       0
#define SS_CENTER                     1
#define SS_RIGHT                      2
#define SS_ICON                       3
#define SS_BLACKRECT                  4
#define SS_GRAYRECT                   5
#define SS_WHITERECT                  6
#define SS_BLACKFRAME                 7
#define SS_GRAYFRAME                  8
#define SS_WHITEFRAME                 9
#define SS_USERITEM                   10
#define SS_SIMPLE                     11
#define SS_LEFTNOWORDWRAP             12
#define SS_OWNERDRAW                  13
#define SS_BITMAP                     14
#define SS_ENHMETAFILE                15
#define SS_ETCHEDHORZ                 16
#define SS_ETCHEDVERT                 17
#define SS_ETCHEDFRAME                18
#define SS_TYPEMASK                   31
#define SS_NOPREFIX                   128 // Don't do "&" character translation
#define SS_NOTIFY                     256
#define SS_CENTERIMAGE                512
#define SS_RIGHTJUST                  1024
#define SS_REALSIZEIMAGE              2048
#define SS_SUNKEN                     4096
#define SS_ENDELLIPSIS                16384
#define SS_PATHELLIPSIS               32768
#define SS_WORDELLIPSIS               49152
#define SS_ELLIPSISMASK               49152

// Slider definitions
#define TBM_SETPOS                    1029
#define TBM_GETPOS                    1024
#define TBS_HORZ                      0
#define TBS_AUTOTICKS                 1
#define TBS_VERT                      2
#define TBS_BOTTOM                    0
#define TBS_TOP                       4
#define TBS_RIGHT                     0
#define TBS_LEFT                      4
#define TBS_BOTH                      8
#define TBS_NOTICKS                   16
#define TBS_ENABLESELRANGE            32
#define TBS_FIXEDLENGTH               64
#define TBS_NOTHUMB                   128
#define TBS_TOOLTIPS                  256
#define TBS_REVERSED                  512

// Toolbutton notifications
#define   TBN_FIRST                   ( -700 )
#define TBN_DROPDOWN                  ( TBN_FIRST - 10 )
#define TBN_GETINFOTIPA               ( TBN_FIRST - 18 )
#define TBN_GETINFOTIPW               ( TBN_FIRST - 19 )

#define TBN_GETINFOTIP                TBN_GETINFOTIPA

// Static Control Mesages
#define STM_SETICON                   0x0170
#define STM_GETICON                   0x0171
#define STM_SETIMAGE                  0x0172
#define STM_GETIMAGE                  0x0173
#define STM_MSGMAX                    0x0174

#define IMAGE_BITMAP                  0
#define IMAGE_ICON                    1
#define IMAGE_CURSOR                  2
#define IMAGE_ENHMETAFILE             3

// Menu flags
#define MF_STRING                     0x0000
#define MF_POPUP                      0x0010
#define MF_MENUBARBREAK               0x0020
#define MF_MENUBREAK                  0x0040
#define MF_SEPARATOR                  0x0800
#define MF_SYSMENU                    0x2000
#define MF_RIGHTJUSTIFY               0x4000

// Media
#define MCIWNDF_NOAUTOSIZEWINDOW      1
#define MCIWNDF_NOPLAYBAR             2
#define MCIWNDF_NOAUTOSIZEMOVIE       4
#define MCIWNDF_NOMENU                8
#define MCIWNDF_SHOWNAME              16
#define MCIWNDF_SHOWPOS               32
#define MCIWNDF_SHOWMODE              64
#define MCIWNDF_SHOWALL               112
#define MCIWNDF_NOERRORDLG            0x4000
#define MCIWNDF_NOOPEN                0x8000
#define ACS_CENTER                    1
#define ACS_TRANSPARENT               2
#define ACS_AUTOPLAY                  4
#define ACS_TIMER                     8

// GetWindow
#define GW_HWNDFIRST                  0
#define GW_HWNDLAST                   1
#define GW_HWNDNEXT                   2
#define GW_HWNDPREV                   3
#define GW_OWNER                      4
#define GW_CHILD                      5
#define GW_ENABLEDPOPUP               6

// Combobox
#define CBS_SORT                      0x0100
#define CBS_DROPDOWN                  0x0002
#define CBS_DROPDOWNLIST              0x0003
#define CBS_NOINTEGRALHEIGHT          0x0400
#define CBS_OWNERDRAWFIXED            0x0010

#define CB_GETDROPPEDSTATE            0x0157
#define CB_SHOWDROPDOWN               0x014F
#define CB_GETEDITSEL                 0x0140
#define CB_SETEDITSEL                 0x0142

#define CCS_TOP                       1
#define CCS_NOMOVEY                   2
#define CCS_BOTTOM                    3
#define CCS_NORESIZE                  4
#define CCS_NOPARENTALIGN             8
#define CCS_ADJUSTABLE                16
#define CCS_NODIVIDER                 32
#define CCS_VERT                      128
#define CCS_LEFT                      ( CCS_VERT + CCS_TOP )
#define CCS_RIGHT                     ( CCS_VERT + CCS_BOTTOM )
#define CCS_NOMOVEX                   ( CCS_VERT + CCS_NOMOVEY )

#define HDN_FIRST                     ( -300 )
#define HDN_BEGINDRAG                 ( HDN_FIRST - 10 )
#define HDN_ENDDRAG                   ( HDN_FIRST - 11 )
#define HDN_BEGINTRACK                ( HDN_FIRST - 26 )
#define HDN_ENDTRACK                  ( HDN_FIRST - 27 )
#define HDN_DIVIDERDBLCLICK           ( HDN_FIRST - 25 )

#define TCS_SCROLLOPPOSITE            1
#define TCS_BOTTOM                    2
#define TCS_RIGHT                     2
#define TCS_MULTISELECT               4
#define TCS_FLATBUTTONS               8
#define TCS_FORCEICONLEFT             16
#define TCS_FORCELABELLEFT            32
#define TCS_HOTTRACK                  64
#define TCS_VERTICAL                  128
#define TCS_TABS                      0
#define TCS_BUTTONS                   256
#define TCS_SINGLELINE                0
#define TCS_MULTILINE                 512
#define TCS_RIGHTJUSTIFY              0
#define TCS_FIXEDWIDTH                1024
#define TCS_RAGGEDRIGHT               2048
#define TCS_FOCUSONBUTTONDOWN         4096
#define TCS_OWNERDRAWFIXED            8192
#define TCS_TOOLTIPS                  16384
#define TCS_FOCUSNEVER                32768

// MonthCal
#define MCS_DAYSTATE                  1
#define MCS_MULTISELECT               2
#define MCS_WEEKNUMBERS               4
#define MCS_NOTODAYCIRCLE             8
#define MCS_NOTODAY                   16

// Datetime
#define DTS_UPDOWN                    1
#define DTS_SHOWNONE                  2
#define DTS_RIGHTALIGN                32

// SplitBox
#define RBBS_GRIPPERALWAYS            0x0080
#define RBBS_NOGRIPPER                0x0100
#define RBBS_HIDDEN                   0x0008

#endif
