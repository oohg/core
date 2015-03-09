/*
 * $Id: h_checkbox.prg,v 1.38 2015-03-09 02:52:07 fyurisich Exp $
 */
/*
 * ooHG source code:
 * PRG checkbox functions
 *
 * Copyright 2005-2015 Vicente Guerra <vicente@guerra.com.mx>
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
   DATA lThemed    INIT .F.

   METHOD Define
   METHOD Value       SETGET
   METHOD Events_Command
   METHOD Events_Color
   METHOD Events_Notify

   EMPTY( _OOHG_AllVars )
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, Caption, Value, fontname, ;
               fontsize, tooltip, changeprocedure, w, h, lostfocus, gotfocus, ;
               HelpId, invisible, notabstop, bold, italic, underline, ;
               strikeout, field, backcolor, fontcolor, transparent, autosize, ;
               lRtl, lDisabled, threestate, leftalign, themed ) CLASS TCheckBox
*-----------------------------------------------------------------------------*
Local ControlHandle, nStyle, nStyleEx := 0
Local oTab

   ASSIGN ::nCol        VALUE x           TYPE "N"
   ASSIGN ::nRow        VALUE y           TYPE "N"
   ASSIGN ::nWidth      VALUE w           TYPE "N"
   ASSIGN ::nHeight     VALUE h           TYPE "N"
   ASSIGN ::Transparent VALUE transparent TYPE "L"
   ASSIGN ::Threestate  VALUE threestate  TYPE "L"
   ASSIGN ::LeftAlign   VALUE leftalign   TYPE "L"
   ASSIGN ::lThemed     VALUE themed      TYPE "L"

   IF ! ::Threestate .and. ! HB_IsLogical( value )
      value := .F.
   ENDIF
   ASSIGN autosize      VALUE autosize TYPE "L" DEFAULT .F.

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

*------------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TCheckBox
*------------------------------------------------------------------------------*
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

*------------------------------------------------------------------------------*
METHOD Events_Command( wParam ) CLASS TCheckBox
*------------------------------------------------------------------------------*
Local Hi_wParam := HIWORD( wParam )
   If Hi_wParam == BN_CLICKED
      ::DoChange()
      Return nil
   EndIf
Return ::Super:Events_Command( wParam )

*------------------------------------------------------------------------------*
METHOD Events_Color( wParam, nDefColor ) CLASS TCheckBox
*------------------------------------------------------------------------------*

Return Events_Color_InTab( Self, wParam, nDefColor )    // see h_controlmisc.prg

*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TCheckBox
*-----------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam )

   If nNotify == NM_CUSTOMDRAW
      If ::lThemed .AND. IsAppThemed()
         Return TCheckBox_Notify_CustomDraw( Self, lParam, ::Caption, ::LeftAlign )
      EndIf
   EndIf

Return ::Super:Events_Notify( wParam, lParam )





#pragma BEGINDUMP

#ifndef _WIN32_IE
   #define _WIN32_IE      0x0500
#endif

#ifndef HB_OS_WIN_32_USED
   #define HB_OS_WIN_32_USED
#endif

#ifndef _WIN32_WINNT
   #define _WIN32_WINNT   0x0501
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

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( hbutton, GWL_WNDPROC, ( LONG ) SubClassFunc );

   HWNDret( hbutton );
}

/* http://devel.no-ip.org/programming/static/os/ReactOS-0.3.14/dll/win32/comctl32/theme_button.c */

typedef int (CALLBACK *CALL_OPENTHEMEDATA )( HWND, LPCWSTR );
typedef int (CALLBACK *CALL_DRAWTHEMEBACKGROUND )( HTHEME, HDC, int, int, const RECT*, const RECT* );
typedef int (CALLBACK *CALL_GETTHEMEBACKGROUNDCONTENTRECT )( HTHEME, HDC, int, int, const RECT*, RECT* );
typedef int (CALLBACK *CALL_CLOSETHEMEDATA )( HTHEME );
typedef int (CALLBACK *CALL_DRAWTHEMEPARENTBACKGROUND )( HWND, HDC, RECT* );

int TCheckBox_Notify_CustomDraw( PHB_ITEM pSelf, LPARAM lParam, LPCSTR cCaption, BOOL bLeftAlign )
{
   HMODULE hInstDLL;
   LPNMCUSTOMDRAW pCustomDraw = (LPNMCUSTOMDRAW) lParam;
   CALL_DRAWTHEMEPARENTBACKGROUND dwProcDrawThemeParentBackground;
   CALL_OPENTHEMEDATA dwProcOpenThemeData;
   HTHEME hTheme;
   LONG style, state;
   int state_id, checkState, drawState;
   CALL_DRAWTHEMEBACKGROUND dwProcDrawThemeBackground;
   CALL_GETTHEMEBACKGROUNDCONTENTRECT dwProcGetThemeBackgroundContentRect;
   RECT content_rect, aux_rect;
   CALL_CLOSETHEMEDATA dwProcCloseThemeData;
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   static const int cb_states[3][5] =
   {
      { CBS_UNCHECKEDNORMAL, CBS_UNCHECKEDHOT, CBS_UNCHECKEDPRESSED, CBS_UNCHECKEDDISABLED, CBS_UNCHECKEDNORMAL },
      { CBS_CHECKEDNORMAL,   CBS_CHECKEDHOT,   CBS_CHECKEDPRESSED,   CBS_CHECKEDDISABLED,   CBS_CHECKEDNORMAL },
      { CBS_MIXEDNORMAL,     CBS_MIXEDHOT,     CBS_MIXEDPRESSED,     CBS_MIXEDDISABLED,     CBS_MIXEDNORMAL }
   };

   hInstDLL = LoadLibrary( "UXTHEME.DLL" );
   if( ! hInstDLL )
   {
      return CDRF_DODEFAULT;
   }

   if( pCustomDraw->dwDrawStage == CDDS_PREERASE )
   {
      /* erase background (according to parent window's themed background) */
      dwProcDrawThemeParentBackground = (CALL_DRAWTHEMEPARENTBACKGROUND) GetProcAddress( hInstDLL, "DrawThemeParentBackground" );
      if( ! dwProcDrawThemeParentBackground )
      {
         FreeLibrary( hInstDLL );
         return CDRF_DODEFAULT;
      }
      ( dwProcDrawThemeParentBackground )( pCustomDraw->hdr.hwndFrom, pCustomDraw->hdc, &pCustomDraw->rc );
   }

 	if (pCustomDraw->dwDrawStage == CDDS_PREERASE || pCustomDraw->dwDrawStage == CDDS_PREPAINT)
   {
      /* get theme handle */
      dwProcOpenThemeData = (CALL_OPENTHEMEDATA) GetProcAddress( hInstDLL, "OpenThemeData" );
      if( ! dwProcOpenThemeData )
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
      style = GetWindowLong( pCustomDraw->hdr.hwndFrom, GWL_STYLE );
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

      /* get content rectangle */
      dwProcGetThemeBackgroundContentRect = (CALL_GETTHEMEBACKGROUNDCONTENTRECT) GetProcAddress( hInstDLL, "GetThemeBackgroundContentRect" );
      if( ! dwProcGetThemeBackgroundContentRect )
      {
         FreeLibrary( hInstDLL );
         return CDRF_DODEFAULT;
      }
      ( dwProcGetThemeBackgroundContentRect )( hTheme, pCustomDraw->hdc, BP_CHECKBOX, state_id, &pCustomDraw->rc, &content_rect );

      /* draw themed button background appropriate to control state */
      dwProcDrawThemeBackground = (CALL_DRAWTHEMEBACKGROUND) GetProcAddress( hInstDLL, "DrawThemeBackground" );
      if( ! dwProcDrawThemeBackground )
      {
         FreeLibrary( hInstDLL );
         return CDRF_DODEFAULT;
      }
      aux_rect = pCustomDraw->rc;
      aux_rect.top = aux_rect.top + (content_rect.bottom - content_rect.top - 13) / 2;
      aux_rect.bottom = aux_rect.top + 13;
      if( bLeftAlign )
      {
        aux_rect.left = aux_rect.right - 13;
        content_rect.right = aux_rect.left - 6;
      }
      else
      {
        aux_rect.right = aux_rect.left + 13;
        content_rect.left = aux_rect.right + 6;
      }
      ( dwProcDrawThemeBackground )( hTheme, pCustomDraw->hdc, BP_CHECKBOX, state_id, &aux_rect, NULL );

      // paint caption
      SetTextColor( pCustomDraw->hdc, ( oSelf->lFontColor == -1 ) ? GetSysColor( COLOR_BTNTEXT ) : (COLORREF) oSelf->lFontColor );
      DrawText( pCustomDraw->hdc, cCaption, -1, &content_rect, DT_VCENTER | DT_LEFT | DT_SINGLELINE );

      /* close theme */
      dwProcCloseThemeData = (CALL_CLOSETHEMEDATA) GetProcAddress( hInstDLL, "CloseThemeData" );
      if( dwProcCloseThemeData )
      {
         ( dwProcCloseThemeData )( hTheme );
      }

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
