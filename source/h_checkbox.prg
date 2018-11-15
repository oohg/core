/*
 * $Id: h_checkbox.prg $
 */
/*
 * ooHG source code:
 * CheckBox control
 *
 * Copyright 2005-2018 Vicente Guerra <vicente@guerra.com.mx>
 * https://oohg.github.io/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2018, https://harbour.github.io/
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


#include "oohg.ch"
#include "common.ch"
#include "hbclass.ch"
#include "i_windefs.ch"

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TCheckBox FROM TLabel

   DATA cPicture                  INIT ""
   DATA IconWidth                 INIT 21
   DATA LeftAlign                 INIT .F.
   DATA lLibDraw                  INIT .F.
   DATA lNoFocusRect              INIT .F.
   DATA nHeight                   INIT 28
   DATA nWidth                    INIT 100
   DATA Threestate                INIT .F.
   DATA Type                      INIT "CHECKBOX" READONLY

   METHOD Define
   METHOD Events_Color
   METHOD Events_Command
   METHOD Events_Notify
   METHOD Value                   SETGET

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( cControlName, uParentForm, nCol, nRow, cCaption, uValue, cFontName,  cFontSize, cToolTip, bOnChange, ;
               nWidth, nHeight, bLostFocus, bGotFocus, nHelpId, lInvisible, lNoTabStop, lBold, lItalic, lUnderline, ;
               lStrikeout, cField, uBackColor, uFontColor, lTransparent, lAutoSize,  lRtl, lDisabled, lThreeState, ;
               lLeftAlign, lDrawBy, oBkGrnd, lNoFocusRect ) CLASS TCheckBox

   LOCAL nControlHandle, nStyle, nStyleEx := 0, oTab

   ASSIGN ::nCol         VALUE nCol         TYPE "N"
   ASSIGN ::nRow         VALUE nRow         TYPE "N"
   ASSIGN ::nWidth       VALUE nWidth       TYPE "N"
   ASSIGN ::nHeight      VALUE nHeight      TYPE "N"
   ASSIGN ::Transparent  VALUE lTransparent TYPE "L"
   ASSIGN ::lAutosize    VALUE lAutoSize    TYPE "L"
   ASSIGN ::Threestate   VALUE lThreeState  TYPE "L"
   ASSIGN uValue         VALUE uValue       TYPE "L" DEFAULT ( iif( ::Threestate, NIL, .F. ) )
   ASSIGN ::LeftAlign    VALUE lLeftAlign   TYPE "L"
   ASSIGN ::oBkGrnd      VALUE oBkGrnd      TYPE "O"
   ASSIGN ::lNoFocusRect VALUE lNoFocusRect TYPE "L"

   IF HB_ISLOGICAL( lDrawBy )
      ::lLibDraw := lDrawBy
   ELSEIF ::lNoFocusRect
      ::lLibDraw := .T.
   ENDIF

   ::SetForm( cControlName, uParentForm, cFontName, cFontSize, uFontColor, uBackColor, NIL, lRtl )

   nStyle := ::InitStyle( NIL, NIL, lInvisible, lNoTabStop, lDisabled )
   IF ::Threestate
      nStyle += BS_AUTO3STATE
   ELSE
      nStyle += BS_AUTOCHECKBOX
   ENDIF
   IF ::LeftAlign
      nStyle += BS_LEFTTEXT
   ENDIF
   IF ::Transparent
      nStyleEx += WS_EX_TRANSPARENT
   ENDIF

   nControlhandle := InitCheckBox( ::ContainerhWnd, cCaption, 0, ::ContainerCol, ::ContainerRow, NIL, NIL, ::nWidth, ::nHeight, nStyle, nStyleEx, ::lRtl )

   ::Register( nControlHandle, cControlName, nHelpId, NIL, cToolTip )
   ::SetFont( NIL, NIL, lBold, lItalic, lUnderline, lStrikeout )

   IF _OOHG_LastFrame() == "TABPAGE" .AND. ::IsVisualStyled
      oTab := _OOHG_ActiveFrame
      IF oTab:Parent:hWnd == ::Parent:hWnd
         ::TabHandle := ::Container:Container:hWnd
      ENDIF
   ENDIF

   ::Caption := cCaption

   ::SetVarBlock( cField, uValue )

   ASSIGN ::OnLostFocus VALUE bLostFocus TYPE "B"
   ASSIGN ::OnGotFocus  VALUE bGotFocus  TYPE "B"
   ASSIGN ::OnChange    VALUE bOnChange  TYPE "B"

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value( uValue ) CLASS TCheckBox

   Local uState

   IF HB_ISLOGICAL( uValue )
      SendMessage( ::hWnd, BM_SETCHECK, if( uValue, BST_CHECKED, BST_UNCHECKED ), 0 )
      ::DoChange()
   ELSEIF ::ThreeState .AND. PCount() > 0 .AND. uValue == NIL
      SendMessage( ::hWnd, BM_SETCHECK, BST_INDETERMINATE, 0 )
      ::DoChange()
   ELSE
      uState := SendMessage( ::hWnd, BM_GETCHECK, 0, 0 )

      IF uState == BST_CHECKED
         uValue := .T.
      ELSEIF uState == BST_UNCHECKED
         uValue := .F.
      ELSE
         uValue := NIL
      ENDIF
   ENDIF

   RETURN uValue

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Events_Color( wParam, nDefColor, lDrawBkGrnd ) CLASS TCheckBox

   HB_SYMBOL_UNUSED( lDrawBkGrnd )

   RETURN ::Super:Events_Color( wParam, nDefColor, .T. )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Events_Command( wParam ) CLASS TCheckBox

   LOCAL Hi_wParam := HIWORD( wParam )

   IF Hi_wParam == BN_CLICKED
      ::DoChange()
      RETURN NIL
   ENDIF

   RETURN ::Super:Events_Command( wParam )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Events_Notify( wParam, lParam ) CLASS TCheckBox

   LOCAL nNotify := GetNotifyCode( lParam )

   IF nNotify == NM_CUSTOMDRAW
      IF ::lLibDraw .AND. ::IsVisualStyled
         RETURN TCheckBox_Notify_CustomDraw( Self, lParam, ::Caption, ;
                                             ( HB_ISOBJECT( ::TabHandle ) .OR. HB_ISOBJECT( ::oBkGrnd ) ), ;
                                             ::LeftAlign, ::lNoFocusRect )
      ENDIF
   ENDIF

   RETURN ::Super:Events_Notify( wParam, lParam )

/*--------------------------------------------------------------------------------------------------------------------------------*/
#pragma BEGINDUMP

#ifndef _WIN32_IE
   #define _WIN32_IE  0x0500
#endif
#if ( _WIN32_IE < 0x0500 )
   #undef _WIN32_IE
   #define _WIN32_IE  0x0500
#endif

#ifndef _WIN32_WINNT
   #define _WIN32_WINNT  0x0501
#endif
#if ( _WIN32_WINNT < 0x0501 )
   #undef _WIN32_WINNT
   #define _WIN32_WINNT  0x0501
#endif

#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windows.h>
#include <commctrl.h>
#include "oohg.h"

#ifndef BST_HOT
   #define BST_HOT  0x0200
#endif

/*
This files are not present in BCC 551
#include <uxtheme.h>
#include <tmschema.h>
*/

typedef struct _MARGINS {
   INT cxLeftWidth;
   INT cxRightWidth;
   INT cyTopHeight;
   INT cyBottomHeight;
} MARGINS, *PMARGINS;

typedef HANDLE HTHEME;

typedef enum THEMESIZE {
   TS_MIN,
   TS_TRUE,
   TS_DRAW
} THEMESIZE;

#ifndef __MSABI_LONG
#  ifndef __LP64__
#    define __MSABI_LONG( x )  ( x ## l )
#  else
#    define __MSABI_LONG( x )  ( x )
#  endif
#endif

#define DTT_TEXTCOLOR     ( __MSABI_LONG( 1U ) << 0 )
#define DTT_BORDERCOLOR   ( __MSABI_LONG( 1U ) << 1 )
#define DTT_SHADOWCOLOR   ( __MSABI_LONG( 1U ) << 2 )
#define DTT_SHADOWTYPE    ( __MSABI_LONG( 1U ) << 3 )
#define DTT_SHADOWOFFSET  ( __MSABI_LONG( 1U ) << 4 )
#define DTT_BORDERSIZE    ( __MSABI_LONG( 1U ) << 5 )
#define DTT_FONTPROP      ( __MSABI_LONG( 1U ) << 6 )
#define DTT_COLORPROP     ( __MSABI_LONG( 1U ) << 7 )
#define DTT_STATEID       ( __MSABI_LONG( 1U ) << 8 )
#define DTT_CALCRECT      ( __MSABI_LONG( 1U ) << 9 )
#define DTT_APPLYOVERLAY  ( __MSABI_LONG( 1U ) << 10 )
#define DTT_GLOWSIZE      ( __MSABI_LONG( 1U ) << 11 )
#define DTT_CALLBACK      ( __MSABI_LONG( 1U ) << 12 )
#define DTT_COMPOSITED    ( __MSABI_LONG( 1U ) << 13 )
#define DTT_VALIDBITS     ( DTT_TEXTCOLOR | DTT_BORDERCOLOR | DTT_SHADOWCOLOR | DTT_SHADOWTYPE | DTT_SHADOWOFFSET | DTT_BORDERSIZE | \
                            DTT_FONTPROP | DTT_COLORPROP | DTT_STATEID | DTT_CALCRECT | DTT_APPLYOVERLAY | DTT_GLOWSIZE | DTT_COMPOSITED )

typedef int ( WINAPI * DTT_CALLBACK_PROC )( HDC hdc, LPWSTR pszText, INT cchText, LPRECT prc, UINT dwFlags, LPARAM lParam );

#ifdef __BORLANDC__
typedef BOOL WINBOOL;
#endif

typedef struct _DTTOPTS {
   DWORD dwSize;
   DWORD dwFlags;
   COLORREF crText;
   COLORREF crBorder;
   COLORREF crShadow;
   INT iTextShadowType;
   POINT ptShadowOffset;
   INT iBorderSize;
   INT iFontPropId;
   INT iColorPropId;
   INT iStateId;
   WINBOOL fApplyOverlay;
   INT iGlowSize;
   DTT_CALLBACK_PROC pfnDrawTextCallback;
   LPARAM lParam;
} DTTOPTS, *PDTTOPTS;

enum {
   BP_PUSHBUTTON = 1,
   BP_RADIOBUTTON = 2,
   BP_CHECKBOX = 3,
   BP_GROUPBOX = 4,
   BP_USERBUTTON = 5
};

enum {
   CBS_UNCHECKEDNORMAL = 1,
   CBS_UNCHECKEDHOT = 2,
   CBS_UNCHECKEDPRESSED = 3,
   CBS_UNCHECKEDDISABLED = 4,
   CBS_CHECKEDNORMAL = 5,
   CBS_CHECKEDHOT = 6,
   CBS_CHECKEDPRESSED = 7,
   CBS_CHECKEDDISABLED = 8,
   CBS_MIXEDNORMAL = 9,
   CBS_MIXEDHOT = 10,
   CBS_MIXEDPRESSED = 11,
   CBS_MIXEDDISABLED = 12
};

typedef INT ( CALLBACK * CALL_CLOSETHEMEDATA ) ( HTHEME );
typedef INT ( CALLBACK * CALL_DRAWTHEMEBACKGROUND ) ( HTHEME, HDC, INT, INT, const RECT *, const RECT * );
typedef INT ( CALLBACK * CALL_DRAWTHEMEPARENTBACKGROUND ) ( HWND, HDC, RECT * );
typedef INT ( CALLBACK * CALL_DRAWTHEMETEXTEX ) ( HTHEME, HDC, INT, INT, LPCWSTR, INT, DWORD, const RECT *, const DTTOPTS * pOptions );
typedef INT ( CALLBACK * CALL_DRAWTHEMETEXT ) ( HTHEME, HDC, INT, INT, LPCWSTR, INT, DWORD, DWORD, const RECT * );
typedef INT ( CALLBACK * CALL_GETTHEMEBACKGROUNDCONTENTRECT ) ( HTHEME, HDC, INT, INT, const RECT *, RECT * );
typedef INT ( CALLBACK * CALL_GETTHEMEPARTSIZE ) ( HTHEME, HDC, INT, INT, const RECT *, THEMESIZE, SIZE * );
typedef INT ( CALLBACK * CALL_ISTHEMEBACKGROUNDPARTIALLYTRANSPARENT ) ( HTHEME, INT, INT );
typedef INT ( CALLBACK * CALL_OPENTHEMEDATA ) ( HWND, LPCWSTR );

/*--------------------------------------------------------------------------------------------------------------------------------*/
static WNDPROC _OOHG_TCheckBox_lpfnOldWndProc( WNDPROC lp )
{
   static WNDPROC lpfnOldWndProc = 0;

   if( ! lpfnOldWndProc )
   {
      lpfnOldWndProc = lp;
   }

   return lpfnOldWndProc;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, _OOHG_TCheckBox_lpfnOldWndProc( 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( INITCHECKBOX )          /* FUNCTION InitCheckBox( hWnd, cCaption, hMenu, nCol, nRow, NIL, NIL, nWidth, nHeight, nStyle, nStyleEx, lRtl ) -> hWnd */
{
   HWND hChkBox;
   int Style, StyleEx;

   Style = hb_parni( 10 ) | BS_NOTIFY | WS_CHILD;
   StyleEx = hb_parni( 11 ) | _OOHG_RTL_Status( hb_parl( 12 ) );

   hChkBox = CreateWindowEx( StyleEx, "BUTTON", hb_parc( 2 ), Style,
                             hb_parni( 4 ), hb_parni( 5 ), hb_parni( 8 ), hb_parni( 9 ),
                             HWNDparam( 1 ), HMENUparam( 3 ), GetModuleHandle( NULL ), NULL ) ;

   _OOHG_TCheckBox_lpfnOldWndProc( ( WNDPROC ) SetWindowLongPtr( hChkBox, GWL_WNDPROC, ( LONG_PTR ) SubClassFunc ) );

   HWNDret( hChkBox );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
INT TCheckBox_Notify_CustomDraw( PHB_ITEM pSelf, LPARAM lParam, LPCSTR cCaption, BOOL bDrawBkGrnd, BOOL bLeftAlign, BOOL bNoFocusRect )
{
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   LPNMCUSTOMDRAW pCustomDraw = ( LPNMCUSTOMDRAW ) lParam;
   CALL_CLOSETHEMEDATA dwProcCloseThemeData;
   CALL_DRAWTHEMEBACKGROUND dwProcDrawThemeBackground;
   CALL_DRAWTHEMEPARENTBACKGROUND dwProcDrawThemeParentBackground;
   CALL_DRAWTHEMETEXT dwProcDrawThemeText;
   CALL_DRAWTHEMETEXTEX dwProcDrawThemeTextEx;
   CALL_GETTHEMEBACKGROUNDCONTENTRECT dwProcGetThemeBackgroundContentRect;
   CALL_GETTHEMEPARTSIZE dwProcGetThemePartSize;
   CALL_ISTHEMEBACKGROUNDPARTIALLYTRANSPARENT dwProcIsThemeBackgroundPartiallyTransparent;
   CALL_OPENTHEMEDATA dwProcOpenThemeData;
   DTTOPTS pOptions;
   HMODULE hInstDLL;
   HTHEME hTheme;
   INT state_id, checkState, drawState;
   LONG_PTR style, state;
   RECT content_rect, aux_rect;
   SIZE s;
   static const INT cb_states[ 3 ][ 5 ] =
   {
      { CBS_UNCHECKEDNORMAL, CBS_UNCHECKEDHOT, CBS_UNCHECKEDPRESSED, CBS_UNCHECKEDDISABLED, CBS_UNCHECKEDNORMAL },
      { CBS_CHECKEDNORMAL,   CBS_CHECKEDHOT,   CBS_CHECKEDPRESSED,   CBS_CHECKEDDISABLED,   CBS_CHECKEDNORMAL },
      { CBS_MIXEDNORMAL,     CBS_MIXEDHOT,     CBS_MIXEDPRESSED,     CBS_MIXEDDISABLED,     CBS_MIXEDNORMAL }
   };

   if( pCustomDraw->dwDrawStage == CDDS_PREERASE )
   {
      hInstDLL = LoadLibrary( "UXTHEME.DLL" );
      if( ! hInstDLL )
      {
         return CDRF_DODEFAULT;
      }

      dwProcCloseThemeData = ( CALL_CLOSETHEMEDATA ) GetProcAddress( hInstDLL, "CloseThemeData" );
      dwProcDrawThemeBackground = ( CALL_DRAWTHEMEBACKGROUND ) GetProcAddress( hInstDLL, "DrawThemeBackground" );
      dwProcDrawThemeParentBackground = ( CALL_DRAWTHEMEPARENTBACKGROUND ) GetProcAddress( hInstDLL, "DrawThemeParentBackground" );
      dwProcDrawThemeText = ( CALL_DRAWTHEMETEXT ) GetProcAddress( hInstDLL, "DrawThemeText" );
      dwProcDrawThemeTextEx = ( CALL_DRAWTHEMETEXTEX ) GetProcAddress( hInstDLL, "DrawThemeTextEx" );
      dwProcGetThemeBackgroundContentRect = ( CALL_GETTHEMEBACKGROUNDCONTENTRECT ) GetProcAddress( hInstDLL, "GetThemeBackgroundContentRect" );
      dwProcGetThemePartSize = ( CALL_GETTHEMEPARTSIZE ) GetProcAddress( hInstDLL, "GetThemePartSize" );
      dwProcIsThemeBackgroundPartiallyTransparent = ( CALL_ISTHEMEBACKGROUNDPARTIALLYTRANSPARENT ) GetProcAddress( hInstDLL, "IsThemeBackgroundPartiallyTransparent" );
      dwProcOpenThemeData = ( CALL_OPENTHEMEDATA ) GetProcAddress( hInstDLL, "OpenThemeData" );

      if( ! ( dwProcCloseThemeData &&
              dwProcDrawThemeBackground &&
              dwProcDrawThemeParentBackground &&
              dwProcGetThemeBackgroundContentRect &&
              dwProcGetThemePartSize &&
              dwProcIsThemeBackgroundPartiallyTransparent &&
              dwProcOpenThemeData &&
              ( dwProcDrawThemeText || dwProcDrawThemeTextEx ) ) )
      {
         FreeLibrary( hInstDLL );
         return CDRF_DODEFAULT;
      }

      hTheme = ( HTHEME ) ( dwProcOpenThemeData ) ( pCustomDraw->hdr.hwndFrom, L"BUTTON" );
      if( ! hTheme )
      {
         FreeLibrary( hInstDLL );
         return CDRF_DODEFAULT;
      }

      /* determine control's state, note that the order of these tests is significant */
      style = GetWindowLongPtr( pCustomDraw->hdr.hwndFrom, GWL_STYLE );
      state = SendMessage( pCustomDraw->hdr.hwndFrom, BM_GETSTATE, 0, 0 );

      if( state & BST_INDETERMINATE )
      {
         checkState = 2;
      }
      else if( state & BST_CHECKED )
      {
         checkState = 1;
      }
      else
      {
         checkState = 0;
      }
      if( style & WS_DISABLED )
      {
         drawState = 3;
      }
      else if( state & BST_HOT )
      {
         drawState = 1;
      }
      else if( state & BST_FOCUS )
      {
         drawState = 4;
      }
      else if( state & BST_PUSHED )
      {
         drawState = 2;
      }
      else
      {
         drawState = 0;
      }
      state_id = cb_states[ checkState ][ drawState ];

      /* draw parent background */
      if( bDrawBkGrnd || TRUE )
      {
         if( ( dwProcIsThemeBackgroundPartiallyTransparent ) ( hTheme, BP_CHECKBOX, state_id ) )
         {
            /* pCustomDraw->rc is the item´s client area */
            ( dwProcDrawThemeParentBackground ) ( pCustomDraw->hdr.hwndFrom, pCustomDraw->hdc, &pCustomDraw->rc );
         }
      }

      /* get button size */
      ( dwProcGetThemePartSize ) ( hTheme, pCustomDraw->hdc, BP_CHECKBOX, state_id, NULL, TS_TRUE, &s );

      /* get content rectangle */
      ( dwProcGetThemeBackgroundContentRect ) ( hTheme, pCustomDraw->hdc, BP_CHECKBOX, state_id, &pCustomDraw->rc, &content_rect );

      aux_rect.top = content_rect.top + ( content_rect.bottom - content_rect.top - s.cy ) / 2;
      aux_rect.bottom = aux_rect.top + s.cy;
      if( bLeftAlign )
      {
         aux_rect.right = content_rect.right;
         aux_rect.left = aux_rect.right - s.cx;
         content_rect.right = aux_rect.left - 3;      // Arbitrary margin between text and button
      }
      else
      {
         aux_rect.left = content_rect.left;
         aux_rect.right = aux_rect.left + s.cx;
         content_rect.left = aux_rect.right + 3;      // Arbitrary margin between text and button
      }

      /* aux_rect is the rect of the item's button area */
      ( dwProcDrawThemeBackground ) ( hTheme, pCustomDraw->hdc, BP_CHECKBOX, state_id, &aux_rect, NULL );

      if( strlen( cCaption ) > 0 )
      {
         if( dwProcDrawThemeTextEx )
         {
            /* paint caption */
            memset( &pOptions, 0, sizeof( DTTOPTS ) );
            pOptions.dwSize = sizeof( DTTOPTS );
            if( oSelf->lFontColor != -1 )
            {
               pOptions.dwFlags |= DTT_TEXTCOLOR;
               pOptions.crText = (COLORREF) oSelf->lFontColor;
            }
            ( dwProcDrawThemeTextEx ) ( hTheme, pCustomDraw->hdc, BP_CHECKBOX, state_id, AnsiToWide( cCaption ), -1, DT_VCENTER | DT_LEFT | DT_SINGLELINE, &content_rect, &pOptions );

            /* paint focus rectangle */
            if( ( state & BST_FOCUS ) && ( ! bNoFocusRect ) )
            {
               aux_rect = content_rect;
               pOptions.dwFlags = DTT_CALCRECT;
               ( dwProcDrawThemeTextEx ) ( hTheme, pCustomDraw->hdc, BP_CHECKBOX, state_id, AnsiToWide( cCaption ), -1, DT_VCENTER | DT_LEFT | DT_SINGLELINE | DT_CALCRECT, &aux_rect, &pOptions );
               aux_rect.top += 5;
               aux_rect.bottom += 1;
               aux_rect.right += 1;
               if( ! bLeftAlign )
               {
                  aux_rect.left -= 1;
               }
               DrawFocusRect( pCustomDraw->hdc, &aux_rect );
            }
         }
         else
         {
            /* paint caption */
            ( dwProcDrawThemeText ) ( hTheme, pCustomDraw->hdc, BP_CHECKBOX, state_id, AnsiToWide( cCaption ), -1, DT_VCENTER | DT_LEFT | DT_SINGLELINE, 0, &content_rect );

            /* paint focus rectangle */
            if( ( state & BST_FOCUS ) && ( ! bNoFocusRect ) )
            {
               aux_rect = content_rect;
               aux_rect.top += 5;
               aux_rect.bottom -= 5;
               aux_rect.right += 1;
               if( ! bLeftAlign )
               {
                  aux_rect.left -= 1;
               }
               DrawFocusRect( pCustomDraw->hdc, &aux_rect );
            }
         }
      }

      /* cleanup */
     ( dwProcCloseThemeData ) ( hTheme );
      FreeLibrary( hInstDLL );
   }

   return CDRF_SKIPDEFAULT;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TCHECKBOX_NOTIFY_CUSTOMDRAW )          /* FUNCTION TCheckBox_Notify_CustomDraw( hWnd, lParam, cCaption, lDrawBkGrnd, lLeftAlign, lNoFocusRect ) -> nRet */
{
   hb_retni( TCheckBox_Notify_CustomDraw( hb_param( 1, HB_IT_OBJECT ), ( LPARAM ) hb_parnl( 2 ), ( LPCSTR ) hb_parc( 3 ),
                                          ( BOOL ) hb_parl( 4 ), ( BOOL ) hb_parl( 5 ), ( BOOL ) hb_parl( 6 ) ) );
}

#pragma ENDDUMP
