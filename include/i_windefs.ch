/*
 * $Id: i_windefs.ch $
 */
/*
 * ooHG source code:
 * Windows' definitions
 *
 * Copyright 2005-2020 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2020 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2020 Contributors, https://harbour.github.io/
 */
/*
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
 * along with this software; see the file LICENSE.txt. If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1335, USA (or download from http://www.gnu.org/licenses/).
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
 */


#ifndef __I_WINDEFS__
#define __I_WINDEFS__

/*---------------------------------------------------------------------------
WINDOWS MESSAGES
---------------------------------------------------------------------------*/

#define WM_CREATE                     1
#define WM_DESTROY                    2
#define WM_MOVE                       3
#define WM_SIZE                       5
#define WM_ACTIVATE                   6
#define WM_SETFOCUS                   7
#define WM_KILLFOCUS                  8
#define WM_SETREDRAW                  11
#define WM_GETTEXT                    13
#define WM_PAINT                      15
#define WM_CLOSE                      16
#define WM_QUIT                       18
#define WM_ERASEBKGND                 20
#define WM_SHOWWINDOW                 24
#define WM_ACTIVATEAPP                28
#define WM_CANCELMODE                 31
#define WM_MOUSEACTIVATE              33
#define WM_NEXTDLGCTL                 40
#define WM_DRAWITEM                   43
#define WM_VKEYTOITEM                 46
#define WM_WINDOWPOSCHANGING          70
#define WM_WINDOWPOSCHANGED           71
#define WM_NOTIFY                     78
#define WM_HELP                       83
#define WM_CONTEXTMENU                123
#define WM_NCCALCSIZE                 131
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
#define WM_COMMAND                    273   // 0x0111
#define WM_SYSCOMMAND                 274
#define WM_TIMER                      275
#define WM_HSCROLL                    276
#define WM_VSCROLL                    277   // 0x0115
#define WM_MENUSELECT                 287   // 0x011F
#define WM_CTLCOLORMSGBOX             306
#define WM_CTLCOLOREDIT               307
#define WM_CTLCOLORLISTBOX            308
#define WM_CTLCOLORBTN                309
#define WM_CTLCOLORDLG                310
#define WM_CTLCOLORSCROLLBAR          311
#define WM_CTLCOLORSTATIC             312
#define WM_MOUSEMOVE                  512   // 0x0200
#define WM_LBUTTONDOWN                513   // 0x0201
#define WM_LBUTTONUP                  514   // 0x0202
#define WM_LBUTTONDBLCLK              515   // 0x0203
#define WM_RBUTTONDOWN                516   // 0x0204
#define WM_RBUTTONUP                  517   // 0x0205
#define WM_RBUTTONDBLCLK              518   // 0x0206
#define WM_MBUTTONDOWN                519   // 0x0207
#define WM_MBUTTONUP                  520   // 0x0208
#define WM_MBUTTONDBLCLK              521   // 0x0209
#define WM_MOUSEWHEEL                 522   // 0x020a
#define WM_MOUSEHWHEEL                526   // 0x020e
#define WM_MDIACTIVATE                546
#define WM_MDITILE                    550
#define WM_MDICASCADE                 551
#define WM_MDIICONARRANGE             552
#define WM_MDIGETACTIVE               553
#define WM_MOUSEHOVER                 673   // 0x02a1
#define WM_SIZING                     532
#define WM_CAPTURECHANGED             533
#define WM_MOVING                     534
#define WM_ENTERSIZEMOVE              561
#define WM_EXITSIZEMOVE               562
#define WM_CUT                        768
#define WM_COPY                       769
#define WM_PASTE                      770
#define WM_CLEAR                      771
#define WM_UNDO                       772
#define WM_HOTKEY                     786

/*---------------------------------------------------------------------------
PRIVATE MESSAGES
---------------------------------------------------------------------------*/

#define WM_USER                       0x0400
#define CBEM_SETIMAGELIST             ( WM_USER + 2 )
#define WM_TASKBAR                    ( WM_USER + 1043 )
#define WM_APP                        0x8000

/*---------------------------------------------------------------------------
GENERIC WM_NOTIFY CALLS
---------------------------------------------------------------------------*/

#define NM_FIRST                      0
#define NM_OUTOFMEMORY                ( NM_FIRST - 1 )
#define NM_CLICK                      ( NM_FIRST - 2 )    // Uses NMCLICK struct
#define NM_DBLCLK                     ( NM_FIRST - 3 )    // Working in TControl
#define NM_RETURN                     ( NM_FIRST - 4 )
#define NM_RCLICK                     ( NM_FIRST - 5 )    // Uses NMCLICK struct
#define NM_RDBLCLK                    ( NM_FIRST - 6 )
#define NM_SETFOCUS                   ( NM_FIRST - 7 )    // Working in TControl
#define NM_KILLFOCUS                  ( NM_FIRST - 8 )    // Working in TControl
#define NM_CUSTOMDRAW                 ( NM_FIRST - 12 )
#define NM_HOVER                      ( NM_FIRST - 13 )
#define NM_NCHITTEST                  ( NM_FIRST - 14 )   // Uses NMMOUSE struct
#define NM_KEYDOWN                    ( NM_FIRST - 15 )   // Uses NMKEY struct
#define NM_RELEASEDCAPTURE            ( NM_FIRST - 16 )
#define NM_SETCURSOR                  ( NM_FIRST - 17 )   // Uses NMMOUSE struct
#define NM_CHAR                       ( NM_FIRST - 18 )   // Uses NMCHAR struct
#define NM_TOOLTIPSCREATED            ( NM_FIRST - 19 )
#define NM_LDOWN                      ( NM_FIRST - 20 )
#define NM_RDOWN                      ( NM_FIRST - 21 )

/*---------------------------------------------------------------------------
SYSTEM COLORS
---------------------------------------------------------------------------*/

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
#define COLOR_MENUHILIGHT             29
#define COLOR_MENUBAR                 30

#define COLOR_DESKTOP                 COLOR_BACKGROUND
#define COLOR_3DFACE                  COLOR_BTNFACE
#define COLOR_3DSHADOW                COLOR_BTNSHADOW
#define COLOR_3DHIGHLIGHT             COLOR_BTNHIGHLIGHT
#define COLOR_3DHILIGHT               COLOR_BTNHIGHLIGHT
#define COLOR_BTNHILIGHT              COLOR_BTNHIGHLIGHT

/*---------------------------------------------------------------------------
WINDOW STYLES
---------------------------------------------------------------------------*/

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
#define WS_MAXIMIZEBOX                0x00010000
#define WS_MINIMIZEBOX                0x00020000
#define WS_TILED                      WS_OVERLAPPED
#define WS_ICONIC                     WS_MINIMIZE
#define WS_SIZEBOX                    WS_THICKFRAME
#define WS_OVERLAPPEDWINDOW           ( WS_OVERLAPPED + WS_CAPTION + WS_SYSMENU + WS_THICKFRAME +  WS_MINIMIZEBOX + WS_MAXIMIZEBOX )
#define WS_TILEDWINDOW                WS_OVERLAPPEDWINDOW
#define WS_CHILDWINDOW                WS_CHILD
#define WS_POPUPWINDOW                ( WS_POPUP + WS_BORDER + WS_SYSMENU )

/*---------------------------------------------------------------------------
EXTENDED WINDOW STYLES
---------------------------------------------------------------------------*/

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
#define WS_EX_LAYERED                 0x00080000
#define WS_EX_COMPOSITED              0x02000000
#define WS_EX_OVERLAPPEDWINDOW        ( WS_EX_WINDOWEDGE + WS_EX_CLIENTEDGE )
#define WS_EX_PALETTEWINDOW           ( WS_EX_WINDOWEDGE + WS_EX_TOOLWINDOW + WS_EX_TOPMOST )

/*---------------------------------------------------------------------------
LAYERED WINDOW FLAGS
---------------------------------------------------------------------------*/

#define LWA_COLORKEY                  0x01
#define LWA_ALPHA                     0x02

/*---------------------------------------------------------------------------
FLASH WINDOW FLAGS
---------------------------------------------------------------------------*/

#define FLASHW_STOP                   0x00000000
#define FLASHW_CAPTION                0x00000001
#define FLASHW_TRAY                   0x00000002
#define FLASHW_ALL                    0x00000003
#define FLASHW_TIMER                  0x00000004
#define FLASHW_TIMERNOFG              0x0000000C

/*---------------------------------------------------------------------------
EDIT AND RICHEDIT CONTROLS
---------------------------------------------------------------------------*/

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
#define EM_SCROLLCARET                183
#define EM_SETMODIFY                  185
#define EM_GETLINECOUNT               186
#define EM_LINEINDEX                  187
#define EM_LINELENGTH                 193
#define EM_LINEFROMCHAR               201
#define EM_GETLINE                    196
#define EM_SETSEL                     177
#define EM_GETSEL                     176
#define EM_LIMITTEXT                  197
#define EM_CANUNDO                    198
#define EM_UNDO                       199
#define EM_SETPASSWORDCHAR            204
#define EM_SETREADONLY                207
#define EM_GETPASSWORDCHAR            210
#define EM_GETLIMITTEXT               213
#define EM_SETBKGNDCOLOR              1091
#define EM_GETFIRSTVISIBLELINE        206
#define EM_LINESCROLL                 182
#define EM_CANPASTE                   1074
#define EM_EXLIMITTEXT                ( WM_USER + 53 )
#define EM_EXLINEFROMCHAR             ( WM_USER + 54 )
#define EM_REDO                       1108
#define EM_CANREDO                    1109
#define EM_AUTOURLDETECT              1115
#define EM_SETCUEBANNER	              0x1501
#define EN_MSGFILTER                  1792
#define EN_SETFOCUS                   256
#define EN_KILLFOCUS                  512
#define EN_CHANGE                     768
#define EN_UPDATE                     1024
#define EN_SELCHANGE                  0x0702
#define EN_HSCROLL                    1537
#define EN_VSCROLL                    1538

#define ECO_AUTOWORDSELECTION         0x00000001
#define ECO_AUTOVSCROLL               0x00000040
#define ECO_AUTOHSCROLL               0x00000080
#define ECO_NOHIDESEL                 0x00000100
#define ECO_READONLY                  0x00000800
#define ECO_WANTRETURN                0x00001000
#define ECO_SAVESEL                   0x00008000
#define ECO_SELECTIONBAR              0x01000000
#define ECO_VERTICAL                  0x00400000   

/*---------------------------------------------------------------------------
REBAR CONTROL
---------------------------------------------------------------------------*/

#define RBS_TOOLTIPS                  256
#define RBS_VARHEIGHT                 512
#define RBS_BANDBORDERS               1024
#define RBS_FIXEDORDER                2048
#define RBS_REGISTERDROP              4096
#define RBS_AUTOSIZE                  8192
#define RBS_VERTICALGRIPPER           16384
#define RBS_DBLCLKTOGGLE              32768

/*---------------------------------------------------------------------------
BUTTON CONTROL
---------------------------------------------------------------------------*/

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
#define BN_CLICKED                    0
#define BN_KILLFOCUS                  7
#define BN_SETFOCUS                   6
#define BUTTON_IMAGELIST_ALIGN_LEFT   0
#define BUTTON_IMAGELIST_ALIGN_RIGHT  1
#define BUTTON_IMAGELIST_ALIGN_TOP    2
#define BUTTON_IMAGELIST_ALIGN_BOTTOM 3
#define BUTTON_IMAGELIST_ALIGN_CENTER 4

/*---------------------------------------------------------------------------
LISTVIEW CONTROL
---------------------------------------------------------------------------*/

#define LVKF_ALT                      0x0001
#define LVKF_CONTROL                  0x0002
#define LVKF_SHIFT                    0x0004
#define LVM_FIRST                     0x1000
#define LVM_GETBKCOLOR                ( LVM_FIRST + 0 )
#define LVM_SETBKCOLOR                ( LVM_FIRST + 1 )
#define LVM_GETIMAGELIST              ( LVM_FIRST + 2 )
#define LVM_SETIMAGELIST              ( LVM_FIRST + 3 )
#define LVM_GETITEMCOUNT              ( LVM_FIRST + 4 )
#define LVM_GETHEADER                 ( LVM_FIRST + 31 )
#define LVSIL_NORMAL                  0
#define LVSIL_SMALL                   1
#define LVSIL_STATE                   2
#define LVSCW_AUTOSIZE                ( -1 )
#define LVSCW_AUTOSIZE_USEHEADER      ( -2 )
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
#define LVN_ENDSCROLL                 ( -181 )
#define LVN_BEGINDRAG                 ( -109 )
#define LVN_GETDISPINFO               ( -150 )
#define LVN_KEYDOWN                   ( -155 )
#define LVN_COLUMNCLICK               ( -108 )
#define LVN_ITEMCHANGED               ( -101 )
#define LVN_INSERTITEM                ( -102 )
#define LVS_EX_GRIDLINES              1
#define LVS_EX_NOGRIDLINES            0

/*---------------------------------------------------------------------------
LISTBOX CONTROL
---------------------------------------------------------------------------*/

#define DL_BEGINDRAG                  ( WM_USER + 133 )
#define DL_DRAGGING                   ( WM_USER + 134 )
#define DL_DROPPED                    ( WM_USER + 135 )
#define DL_CANCELDRAG                 ( WM_USER + 136 )
#define DL_CURSORSET                  0
#define DL_STOPCURSOR                 1
#define DL_COPYCURSOR                 2
#define DL_MOVECURSOR                 3
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
#define LBN_KILLFOCUS                 5
#define LBN_SETFOCUS                  4
#define LBN_DBLCLK                    2
#define LBN_SELCHANGE                 1

/*---------------------------------------------------------------------------
TREEVIEW CONTROL
---------------------------------------------------------------------------*/

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
#define TVM_SETTOOLTIPS               ( TV_FIRST + 24 )
#define TVSIL_NORMAL                  0
#define TVSIL_STATE                   2
#define TVE_COLLAPSE                  1
#define TVE_EXPAND                    2
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
#define TVN_ITEMEXPANDINGA           ( - 405 )
#define TVN_ITEMEXPANDING             TVN_ITEMEXPANDINGA
#define TVN_SELCHANGINGA              ( -401 )
#define TVN_SELCHANGING               TVN_SELCHANGINGA
#define TVN_SELCHANGED                TVN_SELCHANGEDA
#define TVN_SELCHANGEDA               ( -402 )
#define TVN_BEGINLABELEDIT            TVN_BEGINLABELEDITA
#define TVN_BEGINLABELEDITA           ( -410 )
#define TVN_ENDLABELEDIT              TVN_ENDLABELEDITA
#define TVN_ENDLABELEDITA             ( -411 )
#define TVN_BEGINDRAGA                ( -407 )
#define TVN_BEGINDRAG                 TVN_BEGINDRAGA
#define DLGC_WANTCHARS                128
#define DLGC_WANTMESSAGE              4

/*---------------------------------------------------------------------------
TAB CONTROL
---------------------------------------------------------------------------*/

#define TCM_FIRST                     0x1300
#define TCM_GETIMAGELIST              ( TCM_FIRST + 2 )
#define TCM_SETIMAGELIST              ( TCM_FIRST + 3 )
#define TCM_GETITEMCOUNT              ( TCM_FIRST + 4 )
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
#define TCN_SELCHANGE                 ( -551 )
#define TCN_SELCHANGING               ( -552 )

/*---------------------------------------------------------------------------
BACKGROUND COLORS USED TO LOAD IMAGES INTO IMAGELISTS
---------------------------------------------------------------------------*/

#define CLR_NONE                      0xFFFFFFFF
#define CLR_DEFAULT                   0xFF000000

/*---------------------------------------------------------------------------
LOADIMAGE FUNCTION PARAMETERS
---------------------------------------------------------------------------*/

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

/*---------------------------------------------------------------------------
STOCK BRUSHES
---------------------------------------------------------------------------*/

#define WHITE_BRUSH                   0
#define LTGRAY_BRUSH                  1
#define GRAY_BRUSH                    2
#define DKGRAY_BRUSH                  3
#define BLACK_BRUSH                   4
#define NULL_BRUSH                    5
#define HOLLOW_BRUSH                  NULL_BRUSH
#define WHITE_PEN                     6
#define BLACK_PEN                     7
#define NULL_PEN                      8
#define OEM_FIXED_FONT                10
#define ANSI_FIXED_FONT               11
#define ANSI_VAR_FONT                 12
#define SYSTEM_FONT                   13
#define DEVICE_DEFAULT_FONT           14
#define DEFAULT_PALETTE               15
#define SYSTEM_FIXED_FONT             16

/*---------------------------------------------------------------------------
WM_SIZE PARAMETERS
---------------------------------------------------------------------------*/

#define SIZE_MAXHIDE                  4
#define SIZE_MAXIMIZED                2
#define SIZEFULLSCREEN                2
#define SIZE_MAXSHOW                  3
#define SIZE_MINIMIZED                1
#define SIZEICONIC                    1
#define SIZE_RESTORED                 0
#define SIZENORMAL                    0

/*---------------------------------------------------------------------------
SCROLLBAR CONTROL
---------------------------------------------------------------------------*/

#define SB_HORZ                       0
#define SB_VERT                       1
#define SB_CTL                        2
#define SB_BOTH                       3
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

/*---------------------------------------------------------------------------
WM_LBUTTONDOWN PARAMETERS
---------------------------------------------------------------------------*/

#define MK_CONTROL                    0x0008
#define MK_LBUTTON                    0x0001
#define MK_MBUTTON                    0x0010
#define MK_RBUTTON                    0x0002
#define MK_SHIFT                      0x0004
#define MK_XBUTTON1                   0x0020
#define MK_XBUTTON2                   0x0040

/*---------------------------------------------------------------------------
WM_SYSCOMMAND PARAMETERS
---------------------------------------------------------------------------*/

#define SC_CLOSE                      61536

/*---------------------------------------------------------------------------
SYSTEM METRICS
---------------------------------------------------------------------------*/

#define SM_CXFULLSCREEN               16
#define SM_CYFULLSCREEN               17

/*---------------------------------------------------------------------------
TOOLTIP CONTROL
---------------------------------------------------------------------------*/

#define TTM_SETTIPBKCOLOR             ( WM_USER + 19 )
#define TTM_SETTIPTEXTCOLOR           ( WM_USER + 20 )
#define TTM_SETMAXTIPWIDTH            ( WM_USER + 24 )
#define TTM_SETTITLE                  ( WM_USER + 32 )
#define TTI_NONE                      0
#define TTI_INFO                      1
#define TTI_WARNING                   2
#define TTI_ERROR                     3
#define TTI_INFO_LARGE                4
#define TTI_WARNING_LARGE             5
#define TTI_ERROR_LARGE               6
#define TTN_NEEDTEXT                  ( -520 )
#define TTN_GETDISPINFO               ( -520 )

/*---------------------------------------------------------------------------
LABEL, IMAGE, INTERNAL, PICTURE, BUTTON AND SCROLLBUTTON CONTROLS
---------------------------------------------------------------------------*/

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
#define STM_SETICON                   0x0170
#define STM_GETICON                   0x0171
#define STM_SETIMAGE                  0x0172
#define STM_GETIMAGE                  0x0173
#define STM_MSGMAX                    0x0174
#define STN_CLICKED                   0
#define STN_DBLCLK                    1
#define STN_ENABLE                    2
#define STN_DISABLE                   3

/*---------------------------------------------------------------------------
SLIDER CONTROL
---------------------------------------------------------------------------*/

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
#define TB_ENDTRACK                   8

/*---------------------------------------------------------------------------
TOOLBUTTON CONTROL
---------------------------------------------------------------------------*/

#define TBN_FIRST                     ( -700 )
#define TBN_DROPDOWN                  ( TBN_FIRST - 10 )
#define TBN_GETINFOTIPA               ( TBN_FIRST - 18 )
#define TBN_GETINFOTIPW               ( TBN_FIRST - 19 )
#define TBN_GETINFOTIP                TBN_GETINFOTIPA
#define TB_DELETEBUTTON               ( WM_USER + 22 )

/*---------------------------------------------------------------------------
LOADIMAGE/COPYIMAGE FUNCTIONS, BM_SETIMAGE/STM_SETIMAGE MESSAGES PARAMETERS
---------------------------------------------------------------------------*/

#define IMAGE_BITMAP                  0
#define IMAGE_ICON                    1
#define IMAGE_CURSOR                  2
#define IMAGE_ENHMETAFILE             3

/*---------------------------------------------------------------------------
MENU FLAGS
---------------------------------------------------------------------------*/

#define MF_STRING                     0x0000
#define MF_POPUP                      0x0010
#define MF_MENUBARBREAK               0x0020
#define MF_MENUBREAK                  0x0040
#define MF_HILITE                     0x0080
#define MF_OWNERDRAW                  0x0100
#define MF_SEPARATOR                  0x0800
#define MF_SYSMENU                    0x2000
#define MF_RIGHTJUSTIFY               0x4000
#define MF_BYPOSITION                 0x0400
#define MF_BYCOMMAND                  0x0000

/*---------------------------------------------------------------------------
ANIMATEBOX, PLAYER AND PLAY WAVE CONTROLS
---------------------------------------------------------------------------*/

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

/*---------------------------------------------------------------------------
GETWINDOW FUNCTION PARAMETERS
---------------------------------------------------------------------------*/

#define GW_HWNDFIRST                  0
#define GW_HWNDLAST                   1
#define GW_HWNDNEXT                   2
#define GW_HWNDPREV                   3
#define GW_OWNER                      4
#define GW_CHILD                      5
#define GW_ENABLEDPOPUP               6

/*---------------------------------------------------------------------------
COMBOBOX CONTROL
---------------------------------------------------------------------------*/

#define CBS_SORT                      0x0100
#define CBS_DROPDOWN                  0x0002
#define CBS_DROPDOWNLIST              0x0003
#define CBS_AUTOHSCROLL               0x0040
#define CBS_NOINTEGRALHEIGHT          0x0400
#define CBS_OWNERDRAWFIXED            0x0010
#define CB_GETDROPPEDSTATE            0x0157
#define CB_SHOWDROPDOWN               0x014F
#define CB_GETEDITSEL                 0x0140
#define CB_SETEDITSEL                 0x0142
#define CB_SETITEMHEIGHT              0x0153
#define CB_GETITEMHEIGHT              0x0154
#define CB_GETMINVISIBLE              0x1702
#define CB_SETCUEBANNER               0x1703
#define CBN_EDITCHANGE                5
#define CBN_KILLFOCUS                 4
#define CBN_SETFOCUS                  3
#define CBN_SELCHANGE                 1
#define CBN_DROPDOWN                  7
#define CBN_CLOSEUP                   8
#define CBN_SELENDCANCEL              10

/*---------------------------------------------------------------------------
SPLITBOX, STATUSBAR AND TOOLBAR CONTROLS
---------------------------------------------------------------------------*/

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

/*---------------------------------------------------------------------------
HEADER CONTROL
---------------------------------------------------------------------------*/

#define HDN_FIRST                     ( -300 )
#define HDN_BEGINDRAG                 ( HDN_FIRST - 10 )
#define HDN_ENDDRAG                   ( HDN_FIRST - 11 )
#define HDN_ITEMCHANGING              ( HDN_FIRST - 20 )
#define HDN_ITEMCHANGED               ( HDN_FIRST - 21 )
#define HDN_ITEMDBLCLICK              ( HDN_FIRST - 23 )
#define HDN_DIVIDERDBLCLICK           ( HDN_FIRST - 25 )
#define HDN_BEGINTRACK                ( HDN_FIRST - 26 )
#define HDN_ENDTRACK                  ( HDN_FIRST - 27 )
#define HDN_TRACK                     ( HDN_FIRST - 28 )

/*---------------------------------------------------------------------------
MONTHCALENDAR CONTROL
---------------------------------------------------------------------------*/

#define MCS_DAYSTATE                  1
#define MCS_MULTISELECT               2
#define MCS_WEEKNUMBERS               4
#define MCS_NOTODAYCIRCLE             8
#define MCS_NOTODAY                   16

/*---------------------------------------------------------------------------
DATEPICKER CONTROL
---------------------------------------------------------------------------*/

#define DTS_UPDOWN                    1
#define DTS_SHOWNONE                  2
#define DTS_RIGHTALIGN                32
#define DTN_FIRST                     ( -760 )
#define DTN_DATETIMECHANGE            ( DTN_FIRST + 1 )

/*---------------------------------------------------------------------------
SPLITBOX CONTROL
---------------------------------------------------------------------------*/

#define RBBS_GRIPPERALWAYS            0x0080
#define RBBS_NOGRIPPER                0x0100
#define RBBS_HIDDEN                   0x0008

/*---------------------------------------------------------------------------
PROGRESSBAR CONTROL
---------------------------------------------------------------------------*/

#define PBS_VERTICAL                  0x04
#define PBS_MARQUEE                   0x08
#define PBM_SETMARQUEE                ( WM_USER + 10 )
#define PBM_SETPOS                    1026
#define PBM_GETPOS                    1032

/*---------------------------------------------------------------------------
MESSAGEBOX FUNCTIONS PARAMETERS
---------------------------------------------------------------------------*/

#define MB_APPLMODAL                  0
#define MB_SYSTEMMODAL                4096
#define MB_TASKMODAL                  8192
#define MB_TOPMOST                    262144

/*---------------------------------------------------------------------------
STATUSBAR CONTROL
---------------------------------------------------------------------------*/

#define SB_SETMINHEIGHT               ( WM_USER + 8 )

/*---------------------------------------------------------------------------
SETWINDOWPOS FUNCTION PARAMETERS
---------------------------------------------------------------------------*/

#define SWP_NOSIZE                    0x0001
#define SWP_NOMOVE                    0x0002
#define SWP_NOZORDER                  0x0004
#define SWP_NOACTIVATE                0x0010
#define SWP_FRAMECHANGED              0x0020
#define SWP_NOCOPYBITS                0x0100
#define SWP_NOOWNERZORDER             0x0200
#define SWP_NOSENDCHANGING            0x0400

/*---------------------------------------------------------------------------
WM_TASKBAR PARAMETER
---------------------------------------------------------------------------*/

#define ID_TASKBAR                    0

/*---------------------------------------------------------------------------
MONTHCALENDAR CONTROL
---------------------------------------------------------------------------*/

#define MCN_VIEWCHANGE                ( -750 )
#define MCN_SELCHANGE                 ( -749 )
#define MCN_GETDAYSTATE               ( -747 )
#define MCN_SELECT                    ( -746 )
#define MCM_GETMAXSELCOUNT            0x1003
#define MCM_SETMAXSELCOUNT            0x1004
#define MCM_GETCURRENTVIEW            0x1016
#define MCM_SETCURRENTVIEW            0x1020
#define MCMV_MONTH                    0         // days in a month
#define MCMV_YEAR                     1         // month in a year
#define MCMV_DECADE                   2         // years in a decade
#define MCMV_CENTURY                  3         // decades in a century

/*---------------------------------------------------------------------------
TOOLBAR CONTROL
---------------------------------------------------------------------------*/

#define TB_AUTOSIZE                   1057
#define TB_SETTOOLTIPS                ( WM_USER + 36 )
#define TB_GETHOTITEM                 ( WM_USER + 71 )

/*---------------------------------------------------------------------------
DRAWTEXT PARAMETERS
---------------------------------------------------------------------------*/

#define DT_LEFT                       0
#define DT_CENTER                     1
#define DT_RIGHT                      2
#define DT_TOP                        0
#define DT_VCENTER                    4
#define DT_BOTTOM                     8

/*---------------------------------------------------------------------------
INTERNET EXPLORER EVENTS
---------------------------------------------------------------------------*/

#define AX_SE2_STATUSTEXTCHANGE           102
#define AX_SE2_PROGRESSCHANGE             108
#define AX_SE2_COMMANDSTATECHANGE         105
#define AX_SE2_DOWNLOADBEGIN              106
#define AX_SE2_DOWNLOADCOMPLETE           104
#define AX_SE2_TITLECHANGE                113
#define AX_SE2_PROPERTYCHANGE             112
#define AX_SE2_BEFORENAVIGATE2            250
#define AX_SE2_NEWWINDOW2                 251
#define AX_SE2_NAVIGATECOMPLETE2          252
#define AX_SE2_DOCUMENTCOMPLETE           259
#define AX_SE2_ONQUIT                     253
#define AX_SE2_ONVISIBLE                  254
#define AX_SE2_ONTOOLBAR                  255
#define AX_SE2_ONMENUBAR                  256
#define AX_SE2_ONSTATUSBAR                257
#define AX_SE2_ONFULLSCREEN               258
#define AX_SE2_ONTHEATERMODE              260
#define AX_SE2_WINDOWSETRESIZABLE         262
#define AX_SE2_WINDOWSETLEFT              264
#define AX_SE2_WINDOWSETTOP               265
#define AX_SE2_WINDOWSETWIDTH             266
#define AX_SE2_WINDOWSETHEIGHT            267
#define AX_SE2_WINDOWCLOSING              263
#define AX_SE2_CLIENTTOHOSTWINDOW         268
#define AX_SE2_SETSECURELOCKICON          269
#define AX_SE2_FILEDOWNLOAD               270
#define AX_SE2_NAVIGATEERROR              271
#define AX_SE2_PRINTTEMPLATEINSTANTIATION 225
#define AX_SE2_PRINTTEMPLATETEARDOWN      226
#define AX_SE2_UPDATEPAGESTATUS           227
#define AX_SE2_PRIVACYIMPACTEDSTATECHANGE 272
#define AX_SE2_NEWWINDOW3                 273
#define AX_SE2_SETPHISHINGFILTERSTATUS    282
#define AX_SE2_WINDOWSTATECHANGED         283

/*---------------------------------------------------------------------------
STANDARD ICONS
---------------------------------------------------------------------------*/

#define IDI_APPLICATION                   32512
#define IDI_HAND                          32513
#define IDI_QUESTION                      32514
#define IDI_EXCLAMATION                   32515
#define IDI_ASTERISK                      32516
#define IDI_WINLOGO                       32517
#define IDI_SHIELD                        32518
#define IDI_WARNING                       IDI_EXCLAMATION
#define IDI_ERROR                         IDI_HAND
#define IDI_INFORMATION                   IDI_ASTERISK

/*---------------------------------------------------------------------------
KNOWN FOLDERS
---------------------------------------------------------------------------*/

#define FOLDERID_AccountPictures        1
#define FOLDERID_AddNewPrograms         2
#define FOLDERID_AdminTools             3
#define FOLDERID_AppsFolder             4
#define FOLDERID_ApplicationShortcuts   5
#define FOLDERID_AppUpdates             6
#define FOLDERID_CDBurning              7
#define FOLDERID_ChangeRemovePrograms   8
#define FOLDERID_CommonAdminTools       9
#define FOLDERID_CommonOEMLinks         10
#define FOLDERID_CommonPrograms         11
#define FOLDERID_CommonStartMenu        12
#define FOLDERID_CommonStartup          13
#define FOLDERID_CommonTemplates        14
#define FOLDERID_ComputerFolder         15
#define FOLDERID_ConflictFolder         16
#define FOLDERID_ConnectionsFolder      17
#define FOLDERID_Contacts               18
#define FOLDERID_ControlPanelFolder     19
#define FOLDERID_Cookies                20
#define FOLDERID_Desktop                21
#define FOLDERID_DeviceMetadataStore    22
#define FOLDERID_Documents              23
#define FOLDERID_DocumentsLibrary       24
#define FOLDERID_Downloads              25
#define FOLDERID_Favorites              26
#define FOLDERID_Fonts                  27
#define FOLDERID_Games                  28
#define FOLDERID_GameTasks              29
#define FOLDERID_History                30
#define FOLDERID_HomeGroup              31
#define FOLDERID_HomeGroupCurrentUser   32
#define FOLDERID_ImplicitAppShortcuts   33
#define FOLDERID_InternetCache          34
#define FOLDERID_InternetFolder         35
#define FOLDERID_Libraries              36
#define FOLDERID_Links                  37
#define FOLDERID_LocalAppData           38
#define FOLDERID_LocalAppDataLow        39
#define FOLDERID_LocalizedResourcesDir  40
#define FOLDERID_Music                  41
#define FOLDERID_MusicLibrary           42
#define FOLDERID_NetHood                43
#define FOLDERID_NetworkFolder          44
#define FOLDERID_OriginalImages         45
#define FOLDERID_PhotoAlbums            46
#define FOLDERID_Pictures               47
#define FOLDERID_PicturesLibrary        48
#define FOLDERID_Playlists              49
#define FOLDERID_PrintHood              50
#define FOLDERID_PrintersFolder         51
#define FOLDERID_Profile                52
#define FOLDERID_ProgramData            53
#define FOLDERID_ProgramFiles           54
#define FOLDERID_ProgramFilesX64        55
#define FOLDERID_ProgramFilesX86        56
#define FOLDERID_ProgramFilesCommon     57
#define FOLDERID_ProgramFilesCommonX64  58
#define FOLDERID_ProgramFilesCommonX86  59
#define FOLDERID_Programs               60
#define FOLDERID_Public                 61
#define FOLDERID_PublicDesktop          62
#define FOLDERID_PublicDocuments        63
#define FOLDERID_PublicDownloads        64
#define FOLDERID_PublicGameTasks        65
#define FOLDERID_PublicLibraries        66
#define FOLDERID_PublicMusic            67
#define FOLDERID_PublicPictures         68
#define FOLDERID_PublicRingtones        69
#define FOLDERID_PublicUserTiles        70
#define FOLDERID_PublicVideos           71
#define FOLDERID_QuickLaunch            72
#define FOLDERID_Recent                 73
#define FOLDERID_RecordedTVLibrary      74
#define FOLDERID_RecycleBinFolder       75
#define FOLDERID_ResourceDir            76
#define FOLDERID_Ringtones              77
#define FOLDERID_RoamingAppData         78
#define FOLDERID_RoamingTiles           79
#define FOLDERID_RoamedTileImages       80
#define FOLDERID_SampleMusic            81
#define FOLDERID_SamplePictures         82
#define FOLDERID_SamplePlaylists        83
#define FOLDERID_SampleVideos           84
#define FOLDERID_SavedGames             85
#define FOLDERID_SavedSearches          86
#define FOLDERID_Screenshots            87
#define FOLDERID_SEARCH_MAPI            88
#define FOLDERID_SEARCH_CSC             89
#define FOLDERID_SearchHome             90
#define FOLDERID_SendTo                 91
#define FOLDERID_SidebarDefaultParts    92
#define FOLDERID_SidebarParts           93
#define FOLDERID_StartMenu              94
#define FOLDERID_Startup                95
#define FOLDERID_SyncManagerFolder      96
#define FOLDERID_SyncResultsFolder      97
#define FOLDERID_SyncSetupFolder        98
#define FOLDERID_System                 99
#define FOLDERID_SystemX86              100
#define FOLDERID_Templates              101
#define FOLDERID_UserPinned             102
#define FOLDERID_UserProfiles           103
#define FOLDERID_UserProgramFiles       104
#define FOLDERID_UserProgramFilesCommon 105
#define FOLDERID_UsersFiles             106
#define FOLDERID_UsersLibraries         107
#define FOLDERID_Videos                 108
#define FOLDERID_VideosLibrary          109
#define FOLDERID_Windows                110
#define KNOWN_FOLDERS_COUNT             110

#endif
