/*
 * $Id: oohg.h,v 1.75 2017-08-25 19:26:28 fyurisich Exp $
 */
/*
 * ooHG source code:
 * C level definitions
 *
 * Copyright 2005-2017 Vicente Guerra <vicente@guerra.com.mx>
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2017, https://harbour.github.io/
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
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1335,USA (or download from http://www.gnu.org/licenses/).
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


#ifdef OOHG_HWND_POINTER
   #define HWNDparam( pos )          ( ( HWND ) hb_parptr( pos ) )
   #define HWNDret( hWnd )           ( hb_retptr( hWnd ) )
   #define HWNDpush( hWnd )          ( hb_vmPushPointer( hWnd ) )
#else
   #define HWNDparam( pos )          ( ( HWND ) hb_parnl( pos ) )
   #define HWNDret( hWnd )           ( hb_retnl( ( long ) hWnd ) )
   #define HWNDpush( hWnd )          ( hb_vmPushLong( ( long ) hWnd ) )
#endif

#define ValidHandler( hWnd )         ( ( hWnd ) != 0 && ( HWND )( hWnd ) != ( HWND )( ~0 ) )

#define HMENUparam( pos )            ( ( HMENU ) HWNDparam( pos ) )
#define HMENUret( hMenu )            ( HWNDret( ( HWND ) hMenu ) )

struct IMAGE_PARAMETER {
   char *cString;
   int iImage1, iImage2;
};

#define _OOHG_Struct_Size    ( sizeof( OCTRL ) + 100 )

typedef struct OOHG_Window {
   HWND       hWnd;
   HIMAGELIST ImageList;
   BYTE      *AuxBuffer;
   ULONG      AuxBufferLen;
   LONG       lFontColor, lBackColor;
   HBRUSH     BrushHandle;
   LONG       lFontColorSelected, lBackColorSelected;
   LONG       lAux[ 10 ];
   HFONT      hFontHandle;
   LONG       lOldBackColor, lUseBackColor;

/*
   int        iRow, iCol, iWidth, iHeight;
   HB_ITEM    oParent;
   HB_ITEM    oContainer;
   BYTE       *cFontName;
   int        iFontSize;
   BOOL       bBold, bItalic, bUnderline, bStrikeout;
   int        iRowMargin, iColMargin;
   BOOL       bRtl;
   HWND       hContextMenu;
   BOOL       bEnabled;

   DATA aControls      INIT {}
   DATA aControlsNames INIT {}
   DATA lInternal      INIT .T.
   DATA OnClick        INIT nil
   DATA OnGotFocus     INIT nil
   DATA OnLostFocus    INIT nil
   DATA OnMouseDrag    INIT nil
   DATA OnMouseMove    INIT nil
   DATA aKeys          INIT {}  // { Id, Mod, Key, Action }   Application-controlled hotkeys
   DATA aHotKeys       INIT {}  // { Id, Mod, Key, Action }   OperatingSystem-controlled hotkeys
   DATA DefBkColorEdit  INIT nil
*/
} OCTRL, *POCTRL;

extern void SetDragCursorARROW( BOOL isCtrlKeyDown );
extern void ImageFillParameter( struct IMAGE_PARAMETER *pResult, PHB_ITEM pString );
extern PHB_ITEM GetFormObjectByHandle( HWND hWnd );
extern PHB_ITEM GetControlObjectByHandle( HWND hWnd );
extern PHB_ITEM GetControlObjectById( LONG lId, HWND hWnd );
extern void _OOHG_Send( PHB_ITEM pSelf, int iSymbol );
void _OOHG_DoEvent( PHB_ITEM pSelf, int iSymbol, char* cType, PHB_ITEM pArray );
void _OOHG_DoEventMouseCoords( PHB_ITEM pSelf, int iSymbol, char* cType, LPARAM lParam );
LRESULT APIENTRY _OOHG_WndProcCtrl( HWND hWnd, UINT uiMsg, WPARAM wParam, LPARAM lParam, WNDPROC lpfnOldWndProc );
extern int GetKeyFlagState( void );
POCTRL _OOHG_GetControlInfo( PHB_ITEM pSelf );
BOOL _OOHG_DetermineColor( PHB_ITEM pColor, LONG *lColor );
BOOL _OOHG_DetermineColorReturn( PHB_ITEM pColor, LONG *lColor, BOOL fUpdate );
HANDLE _OOHG_LoadImage( char *cImage, int iAttributes, int nWidth, int nHeight, HWND hWnd, LONG BackColor, BOOL bIgnoreBkClr );
HANDLE _OOHG_OleLoadPicture( HGLOBAL hGlobal, HWND hWnd, LONG BackColor, long lWidth2, long lHeight2, BOOL bIgnoreBkClr );
HBITMAP _OOHG_ScaleImage( HWND hWnd, HBITMAP hImage, int iWidth, int iHeight, BOOL scalestrech, LONG BackColor, BOOL bIgnoreBkClr, int iHrzMrgn, int iVrtMrgn );
BOOL _OOHG_UseGDIP( void );
HANDLE _OOHG_GDIPLoadPicture( HGLOBAL hGlobal, HWND hWnd, LONG lBackColor, long lWidth2, long lHeight2, BOOL bIgnoreBkClr );
DWORD _OOHG_RTL_Status( BOOL bRtl );
int _OOHG_SearchFormHandleInArray( HWND hWnd );
int _OOHG_SearchControlHandleInArray( HWND hWnd );
PHB_ITEM _OOHG_GetExistingObject( HWND hWnd, BOOL bForm, BOOL bForceAny );
HBRUSH GetTabBrush( HWND hWnd );
HFONT PrepareFont( char *Fontname, int FontSize, int Weight, int Italic, int Underline, int StrikeOut, int Angle, int Width );
BOOL SaveHBitmapToFile( void *, const char *, UINT, UINT, const char *, ULONG, ULONG );
HBITMAP _OOHG_ReplaceColor( HBITMAP hBitmap, int x, int y, LONG lNewColor );
wchar_t * AnsiToWide( const char * szString );

// Symbols table
#define s_Events_Notify        0
#define s_GridForeColor        1
#define s_GridBackColor        2
#define s_FontColor            3
#define s_BackColor            4
#define s_Container            5
#define s_Parent               6
#define s_hCursor              7
#define s_Events               8
#define s_Events_Color         9
#define s_Name                 10
#define s_Type                 11
#define s_TControl             12
#define s_TLabel               13
#define s_TGrid                14
#define s_ContextMenu          15
#define s_RowMargin            16
#define s_ColMargin            17
#define s_hWnd                 18
#define s_TText                19
#define s_AdjustRightScroll    20
#define s_OnMouseMove          21
#define s_OnMouseDrag          22
#define s_DoEvent              23
#define s_LookForKey           24
#define s_aControlInfo         25
#define s__aControlInfo        26
#define s_Events_DrawItem      27
#define s__hWnd                28
#define s_Events_Command       29
#define s_OnChange             30
#define s_OnGotFocus           31
#define s_OnLostFocus          32
#define s_OnClick              33
#define s_Transparent          34
#define s_Events_MeasureItem   35
#define s_FontHandle           36
#define s_TWindow              37
#define s_WndProc              38
#define s_OverWndProc          39
#define s_hWndClient           40
#define s_Refresh              41
#define s_AuxHandle            42
#define s_ContainerCol         43
#define s_ContainerRow         44
#define s_lRtl                 45
#define s_Width                46
#define s_Height               47
#define s_VScroll              48
#define s_ScrollButton         49
#define s_Visible              50
#define s_Events_HScroll       51
#define s_Events_VScroll       52
#define s_nTextHeight          53
#define s_Events_Enter         54
#define s_Id                   55
#define s_NestedClick          56
#define s__NestedClick         57
#define s_TInternal            58
#define s__ContextMenu         59
#define s_Release              60
#define s_Activate             61
#define s_oOle                 62
#define s_RangeHeight          63
#define s_OnRClick             64
#define s_OnMClick             65
#define s_OnDblClick           66
#define s_OnRDblClick          67
#define s_OnMDblClick          68
#define s_OnDropFiles          69
#define s_lAdjustImages        70
#define s_aSelColor            71
#define s_TabHandle            72
#define s_ItemEnabled          73
#define s_HandleToItem         74
#define s_GridSelectedColors   75
#define s_TEdit                76
#define s_oBkGrnd              77
#define s_Events_NCDestroy     78
#define s_aExcludeArea         79
#define s_CompareItems         80
#define s_Events_Drag          81
#define s_LastSymbol           82

#ifdef __XHARBOUR__
   #define HB_STORNI( n, x, y )   hb_storni( n, x, y )
   #define HB_STORNL( n, x, y )   hb_stornl( n, x, y )
   #define HB_STORL( n, x, y )    hb_storl( n, x, y )
   #define HB_STORC( n, x, y )    hb_storc( n, x, y )
   #define HB_PARNI( n, x )       hb_parni( n, x )
   #define HB_PARNL( n, x )       hb_parnl( n, x )
   #define HB_STORPTR( n, x, y )  hb_storptr( n, x, y )
   #define HB_PARC( n, x )        hb_parc( n, x )
   #define HB_PARCLEN( n, x )     hb_parclen( n, x )
   #define HB_PARNL3( n, x, y )   hb_parnl( n, x, y )
   #define HB_STORNI2( n, x )     hb_storni( n, x )
   #define HB_STORND( n, x, y )   hb_stornd( n, x, y )
   #define HB_PARND( n, x )       hb_parnd( n, x )
   #define HB_STORDL( n, x, y )   hb_stordl( n, x, y )
#else
   #define HB_STORNI( n, x, y )   hb_storvni( n, x, y )
   #define HB_STORNL( n, x, y )   hb_storvnl( n, x, y )
   #define HB_STORL( n, x, y )    hb_storvl( n, x, y )
   #define HB_STORC( n, x, y )    hb_storvc( n, x, y )
   #define HB_PARNI( n, x )       hb_parvni( n, x )
   #define HB_PARNL( n, x )       hb_parvnl( n, x )
   #define HB_STORPTR( n, x, y )  hb_storvptr( n, x, y )
   #define HB_PARC( n, x )        hb_parvc( n, x )
   #define HB_PARCLEN( n, x )     hb_parvclen( n, x )
   #define HB_PARNL3( n, x, y )   hb_parvnl( n, x, y )
   #define HB_STORNI2( n, x )     hb_storvni( n, x )
   #define HB_STORND( n, x, y )   hb_storvnd( n, x, y )
   #define HB_PARND( n, x )       hb_parvnd( n, x )
   #define HB_STORDL( n, x, y )   hb_storvdl( n, x, y )
#endif

#ifdef __XHARBOUR__
   #ifndef HB_ISDATE
      #define HB_ISDATE( n )     ISDATE( n )
   #endif
   #ifndef HB_ISCHAR
      #define HB_ISCHAR( n )     ISCHAR( n )
   #endif
   #ifndef HB_ISNUM
      #define HB_ISNUM( n )      ISNUM( n )
   #endif
   #ifndef HB_ISNIL
      #define HB_ISNIL( n )      ISNIL( n )
   #endif
   #ifndef HB_ISARRAY
      #define HB_ISARRAY( n )    ISARRAY( n )
   #endif
   #ifndef HB_ISLOG
      #define HB_ISLOG( n )      ISLOG( n )
   #endif
   #ifndef HB_ISBLOCK
      #define HB_ISBLOCK( n )    ISBLOCK( n )
   #endif
#endif

// Hack for MinGW and static functions (object's methods)
#ifdef __MINGW32__
   #undef  HB_FUNC_STATIC
   #define HB_FUNC_STATIC( x )   HB_FUNC( x )
#endif

#ifdef _MSC_VER
   #define ultoa _ultoa
   #define itoa  _itoa
   #define ltoa  _ltoa
#endif

#if defined( HB_ARCH_64BIT )
   #if !defined( GCL_HBRBACKGROUND )
       #define GCL_HBRBACKGROUND (-10)
       #define GWL_USERDATA (-21)
       #define GWL_WNDPROC (-4)
       #define DWL_MSGRESULT (0)
       #define GCL_HCURSOR (-12)
   #endif
#endif

#ifdef MAKEWORD
   #undef MAKEWORD
#endif
#define MAKEWORD(a, b)   ((WORD)(((BYTE)((DWORD_PTR)(a) & 0xff)) | (((WORD)((BYTE)((DWORD_PTR)(b) & 0xff))) << 8)))

#ifdef MAKELONG
   #undef MAKELONG
#endif
#define MAKELONG(a, b)  ((LONG)(((WORD)((DWORD_PTR)(a) & 0xffff)) | (((DWORD)((WORD)((DWORD_PTR)(b) & 0xffff))) << 16)))

