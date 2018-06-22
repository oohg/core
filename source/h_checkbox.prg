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


CLASS TCheckBox FROM TLabel

   DATA Type       INIT "CHECKBOX" READONLY
   DATA cPicture   INIT ""
   DATA IconWidth  INIT 19
   DATA nWidth     INIT 100
   DATA nHeight    INIT 28
   DATA TabHandle  INIT 0
   DATA Threestate INIT .F.
   DATA LeftAlign  INIT .F.
   DATA lLibDraw   INIT .F.

   METHOD Define
   METHOD Value       SETGET
   METHOD Events_Command
   METHOD Events_Color
   METHOD Events_Notify

   ENDCLASS

METHOD Define( ControlName, ParentForm, x, y, Caption, Value, fontname, ;
               fontsize, tooltip, changeprocedure, w, h, lostfocus, gotfocus, ;
               HelpId, invisible, notabstop, bold, italic, underline, ;
               strikeout, field, backcolor, fontcolor, transparent, autosize, ;
               lRtl, lDisabled, threestate, leftalign, drawby ) CLASS TCheckBox

   Local ControlHandle, nStyle, nStyleEx := 0
   Local oTab

   ASSIGN ::lLibDraw    VALUE drawby      TYPE "L" DEFAULT _OOHG_UsesVisualStyle()
   ASSIGN ::nCol        VALUE x           TYPE "N"
   ASSIGN ::nRow        VALUE y           TYPE "N"
   ASSIGN ::nWidth      VALUE w           TYPE "N"
   ASSIGN ::nHeight     VALUE h           TYPE "N"
   ASSIGN ::Transparent VALUE transparent TYPE "L"
   ASSIGN ::Threestate  VALUE threestate  TYPE "L"
   ASSIGN ::LeftAlign   VALUE leftalign   TYPE "L"
   ASSIGN autosize      VALUE autosize    TYPE "L" DEFAULT .F.

   IF ! ::Threestate .and. ! HB_IsLogical( value )
      value := .F.
   ENDIF

   IF ::Transparent .AND. _OOHG_UsesVisualStyle()
      ::Transparent := .F.
   ENDIF

   ::SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor,, lRtl )

   nStyle := ::InitStyle( ,, Invisible, NoTabStop, lDisabled )
   If ::Threestate
      nStyle += BS_AUTO3STATE
   Else
      nStyle += BS_AUTOCHECKBOX
   Endif
   If ::LeftAlign
      nStyle += BS_LEFTTEXT
   Endif
   If ::Transparent
      nStyleEx += WS_EX_TRANSPARENT
   EndIf

   Controlhandle := InitCheckBox( ::ContainerhWnd, Caption, 0, ::ContainerCol, ::ContainerRow, '', 0 , ::nWidth, ::nHeight, nStyle, nStyleEx, ::lRtl )

   ::Register( ControlHandle, ControlName, HelpId,, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   IF _OOHG_LastFrame() == "TABPAGE" .AND. _OOHG_UsesVisualStyle()
      oTab := ATAIL( _OOHG_ActiveFrame )

      IF oTab:Parent:hWnd == ::Parent:hWnd
         ::TabHandle := ::Container:Container:hWnd
      ENDIF
   ENDIF

   ::Autosize    := autosize
   ::Caption     := Caption

   ::SetVarBlock( Field, Value )

   ASSIGN ::OnLostFocus VALUE lostfocus TYPE "B"
   ASSIGN ::OnGotFocus  VALUE gotfocus  TYPE "B"
   ASSIGN ::OnChange    VALUE ChangeProcedure TYPE "B"

   Return Self

METHOD Value( uValue ) CLASS TCheckBox

   Local uState

   IF HB_IsLogical( uValue )
      SendMessage( ::hWnd, BM_SETCHECK, if( uValue, BST_CHECKED, BST_UNCHECKED ), 0 )
      ::DoChange()
   ELSEIF ::ThreeState .AND. pcount() > 0 .AND. uValue == NIL
      SendMessage( ::hWnd, BM_SETCHECK, BST_INDETERMINATE, 0 )
      ::DoChange()
   ELSE
      uState := SendMessage( ::hWnd, BM_GETCHECK , 0 , 0 )

      IF uState == BST_CHECKED
         uValue := .T.
      ELSEIF uState == BST_UNCHECKED
         uValue := .F.
      ELSE
         uValue := Nil
      ENDIF
   ENDIF

   RETURN uValue

METHOD Events_Command( wParam ) CLASS TCheckBox

   Local Hi_wParam := HIWORD( wParam )

   If Hi_wParam == BN_CLICKED
      ::DoChange()
      Return nil
   EndIf

   Return ::Super:Events_Command( wParam )

METHOD Events_Color( wParam, nDefColor ) CLASS TCheckBox

   Return Events_Color_InTab( Self, wParam, nDefColor )    // see h_controlmisc.prg

METHOD Events_Notify( wParam, lParam ) CLASS TCheckBox

   Local nNotify := GetNotifyCode( lParam )

   If nNotify == NM_CUSTOMDRAW
      If ::lLibDraw .AND. ::IsVisualStyled .AND. _OOHG_UsesVisualStyle()
         Return TCheckBox_Notify_CustomDraw( Self, lParam, ::Caption, ::LeftAlign )
      EndIf
   EndIf

   Return ::Super:Events_Notify( wParam, lParam )


#pragma BEGINDUMP

#ifndef HB_OS_WIN_32_USED
   #define HB_OS_WIN_32_USED
#endif

#ifndef _WIN32_IE
   #define _WIN32_IE 0x0500
#endif
#if ( _WIN32_IE < 0x0500 )
   #undef _WIN32_IE
   #define _WIN32_IE 0x0500
#endif

#ifndef _WIN32_WINNT
   #define _WIN32_WINNT 0x0501
#endif
#if ( _WIN32_WINNT < 0x0501 )
   #undef _WIN32_WINNT
   #define _WIN32_WINNT 0x0501
#endif

#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include <windows.h>
#include <commctrl.h>
#include "oohg.h"

#ifndef BST_HOT
   #define BST_HOT        0x0200
#endif

/*
This files are not present in BCC 551
#include <uxtheme.h>
#include <tmschema.h>
*/

typedef struct _MARGINS {
   int cxLeftWidth;
   int cxRightWidth;
   int cyTopHeight;
   int cyBottomHeight;
} MARGINS, *PMARGINS;

typedef HANDLE HTHEME;

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

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

HB_FUNC( INITCHECKBOX )
{
   HWND hwnd;
   HWND hbutton;
   int Style, StyleEx;

   hwnd = HWNDparam( 1 );

   Style = BS_NOTIFY | WS_CHILD | hb_parni( 10 );

   StyleEx = hb_parni( 11 ) | _OOHG_RTL_Status( hb_parl( 12 ) );

   hbutton = CreateWindowEx( StyleEx, "button" , hb_parc(2) ,
   Style ,
   hb_parni(4), hb_parni(5) , hb_parni(8), hb_parni(9) ,
   hwnd,(HMENU)hb_parni(3) , GetModuleHandle(NULL) , NULL ) ;

   lpfnOldWndProc = (WNDPROC) SetWindowLongPtr( hbutton, GWL_WNDPROC, (LONG_PTR) SubClassFunc );

   HWNDret( hbutton );
}

/* http://devel.no-ip.org/programming/static/os/ReactOS-0.3.14/dll/win32/comctl32/theme_button.c */

typedef int (CALLBACK *CALL_OPENTHEMEDATA )( HWND, LPCWSTR );
typedef int (CALLBACK *CALL_DRAWTHEMEBACKGROUND )( HTHEME, HDC, int, int, const RECT*, const RECT* );
typedef int (CALLBACK *CALL_GETTHEMEBACKGROUNDCONTENTRECT )( HTHEME, HDC, int, int, const RECT*, RECT* );
typedef int (CALLBACK *CALL_CLOSETHEMEDATA )( HTHEME );
typedef int (CALLBACK *CALL_DRAWTHEMEPARENTBACKGROUND )( HWND, HDC, RECT* );
typedef int (CALLBACK *CALL_ISTHEMEBACKGROUNDPARTIALLYTRANSPARENT )( HTHEME, int, int );

int TCheckBox_Notify_CustomDraw( PHB_ITEM pSelf, LPARAM lParam, LPCSTR cCaption, BOOL bLeftAlign )
{
   HMODULE hInstDLL;
   LPNMCUSTOMDRAW pCustomDraw = (LPNMCUSTOMDRAW) lParam;
   CALL_DRAWTHEMEPARENTBACKGROUND dwProcDrawThemeParentBackground;
   CALL_OPENTHEMEDATA dwProcOpenThemeData;
   HTHEME hTheme;
   LONG_PTR style, state;
   int state_id, checkState, drawState, iNeeded;
   CALL_DRAWTHEMEBACKGROUND dwProcDrawThemeBackground;
   CALL_GETTHEMEBACKGROUNDCONTENTRECT dwProcGetThemeBackgroundContentRect;
   RECT content_rect, aux_rect;
   CALL_CLOSETHEMEDATA dwProcCloseThemeData;
   CALL_ISTHEMEBACKGROUNDPARTIALLYTRANSPARENT dwProcIsThemeBackgroundPartiallyTransparent;
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   static const int cb_states[3][5] =
   {
      { CBS_UNCHECKEDNORMAL, CBS_UNCHECKEDHOT, CBS_UNCHECKEDPRESSED, CBS_UNCHECKEDDISABLED, CBS_UNCHECKEDNORMAL },
      { CBS_CHECKEDNORMAL,   CBS_CHECKEDHOT,   CBS_CHECKEDPRESSED,   CBS_CHECKEDDISABLED,   CBS_CHECKEDNORMAL },
      { CBS_MIXEDNORMAL,     CBS_MIXEDHOT,     CBS_MIXEDPRESSED,     CBS_MIXEDDISABLED,     CBS_MIXEDNORMAL }
   };

    if( pCustomDraw->dwDrawStage == CDDS_PREERASE || pCustomDraw->dwDrawStage == CDDS_PREPAINT )
   {
      hInstDLL = LoadLibrary( "UXTHEME.DLL" );
      if( ! hInstDLL )
      {
         return CDRF_DODEFAULT;
      }

      dwProcOpenThemeData = (CALL_OPENTHEMEDATA) GetProcAddress( hInstDLL, "OpenThemeData" );
      dwProcCloseThemeData = (CALL_CLOSETHEMEDATA) GetProcAddress( hInstDLL, "CloseThemeData" );
      dwProcIsThemeBackgroundPartiallyTransparent = (CALL_ISTHEMEBACKGROUNDPARTIALLYTRANSPARENT) GetProcAddress( hInstDLL, "IsThemeBackgroundPartiallyTransparent" );
      dwProcDrawThemeParentBackground = (CALL_DRAWTHEMEPARENTBACKGROUND) GetProcAddress( hInstDLL, "DrawThemeParentBackground" );
      dwProcGetThemeBackgroundContentRect = (CALL_GETTHEMEBACKGROUNDCONTENTRECT) GetProcAddress( hInstDLL, "GetThemeBackgroundContentRect" );
      dwProcDrawThemeBackground = (CALL_DRAWTHEMEBACKGROUND) GetProcAddress( hInstDLL, "DrawThemeBackground" );

      if( ! ( dwProcOpenThemeData && dwProcCloseThemeData && dwProcIsThemeBackgroundPartiallyTransparent && dwProcDrawThemeParentBackground && dwProcGetThemeBackgroundContentRect && dwProcDrawThemeBackground ) )
      {
         FreeLibrary( hInstDLL );
         return CDRF_DODEFAULT;
      }

      hTheme = (HTHEME) ( dwProcOpenThemeData )( pCustomDraw->hdr.hwndFrom, L"BUTTON" );
      if( ! hTheme )
      {
         FreeLibrary( hInstDLL );
         return CDRF_DODEFAULT;
      }

      /* determine state for DrawThemeBackground()
         note: order of these tests is significant */
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

      state_id = cb_states[checkState][drawState];

      /* draw parent background
      if( pCustomDraw->dwDrawStage == CDDS_PREERASE )
      {
         if( ( dwProcIsThemeBackgroundPartiallyTransparent )( hTheme, BP_CHECKBOX, state_id ) )
         {
            ( dwProcDrawThemeParentBackground )( pCustomDraw->hdr.hwndFrom, pCustomDraw->hdc, &pCustomDraw->rc );
         }
      } */

      /* draw background appropriate to control state */
      ( dwProcGetThemeBackgroundContentRect )( hTheme, pCustomDraw->hdc, BP_CHECKBOX, state_id, &pCustomDraw->rc, &content_rect );

      aux_rect = pCustomDraw->rc;
      aux_rect.top = aux_rect.top + (content_rect.bottom - content_rect.top - 13) / 2;
      aux_rect.bottom = aux_rect.top + 13;
      if( bLeftAlign )
      {
        aux_rect.left = aux_rect.right - 13;
        content_rect.right = aux_rect.left - 6;
        content_rect.left += 2;
      }
      else
      {
        aux_rect.right = aux_rect.left + 13;
        content_rect.left = aux_rect.right + 6;
        content_rect.right -= 2;
      }
      ( dwProcDrawThemeBackground )( hTheme, pCustomDraw->hdc, BP_CHECKBOX, state_id, &aux_rect, NULL );

      if( strlen( cCaption ) > 0 )
      {
         /* paint caption */
         SetTextColor( pCustomDraw->hdc, ( oSelf->lFontColor == -1 ) ? GetSysColor( COLOR_BTNTEXT ) : (COLORREF) oSelf->lFontColor );
         DrawText( pCustomDraw->hdc, cCaption, -1, &content_rect, DT_VCENTER | DT_LEFT | DT_SINGLELINE );        // DrawThemeText

         /* paint focus rectangle */
         if( state & BST_FOCUS )
         {
            aux_rect = content_rect;
            iNeeded = DrawText( pCustomDraw->hdc, cCaption, -1, &aux_rect, DT_VCENTER | DT_LEFT | DT_SINGLELINE | DT_CALCRECT );

            aux_rect.left -= 1;
            aux_rect.right += 1;
            aux_rect.top = content_rect.top + ( ( content_rect.bottom - content_rect.top - iNeeded ) / 2 ) + 2;
            aux_rect.bottom = aux_rect.top + iNeeded - 4;

            DrawFocusRect( pCustomDraw->hdc, &aux_rect );         // Windows draws a rounded rectangle
         }
      }

      /* cleanup */
     ( dwProcCloseThemeData )( hTheme );
      FreeLibrary( hInstDLL );

      return CDRF_SKIPDEFAULT;
   }

   return CDRF_SKIPDEFAULT;
}

HB_FUNC( TCHECKBOX_NOTIFY_CUSTOMDRAW )
{
   hb_retni( TCheckBox_Notify_CustomDraw( hb_param( 1, HB_IT_OBJECT ), (LPARAM) hb_parnl( 2 ), (LPCSTR) hb_parc( 3 ), hb_parl( 4 ) ) );
}

#pragma ENDDUMP
