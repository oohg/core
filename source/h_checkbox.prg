/*
 * $Id: h_checkbox.prg $
 */
/*
 * ooHG source code:
 * CheckBox control
 *
 * Copyright 2005-2019 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2019 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2019 Contributors, https://harbour.github.io/
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
                                             ( HB_ISOBJECT( ::TabHandle ) .AND. ! HB_ISOBJECT( ::oBkGrnd ) ), ;
                                             ::LeftAlign, ::lNoFocusRect )
      ENDIF
   ENDIF

   RETURN ::Super:Events_Notify( wParam, lParam )

/*--------------------------------------------------------------------------------------------------------------------------------*/
#pragma BEGINDUMP

#include "oohg.h"
#include "hbvm.h"
#include "hbstack.h"

#ifndef BST_HOT
   #define BST_HOT  0x0200
#endif

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

/*--------------------------------------------------------------------------------------------------------------------------------*/
static WNDPROC _OOHG_TCheckBox_lpfnOldWndProc( LONG_PTR lp )
{
   static LONG_PTR lpfnOldWndProc = 0;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( ! lpfnOldWndProc )
   {
      lpfnOldWndProc = lp;
   }
   ReleaseMutex( _OOHG_GlobalMutex() );

   return (WNDPROC) lpfnOldWndProc;
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

   _OOHG_TCheckBox_lpfnOldWndProc( SetWindowLongPtr( hChkBox, GWLP_WNDPROC, (LONG_PTR) SubClassFunc ) );

   HWNDret( hChkBox );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
int TCheckBox_Notify_CustomDraw( PHB_ITEM pSelf, LPARAM lParam, LPCSTR cCaption, BOOL bDrawBkGrnd, BOOL bLeftAlign, BOOL bNoFocusRect )
{
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   LPNMCUSTOMDRAW pCustomDraw = ( LPNMCUSTOMDRAW ) lParam;
   DTTOPTS pOptions;
   HTHEME hTheme;
   int state_id, checkState, drawState;
   LONG_PTR style, state;
   RECT content_rect, aux_rect;
   SIZE s;
   OSVERSIONINFO osvi;
   static const int cb_states[ 3 ][ 5 ] =
   {
      { CBS_UNCHECKEDNORMAL, CBS_UNCHECKEDHOT, CBS_UNCHECKEDPRESSED, CBS_UNCHECKEDDISABLED, CBS_UNCHECKEDNORMAL },
      { CBS_CHECKEDNORMAL,   CBS_CHECKEDHOT,   CBS_CHECKEDPRESSED,   CBS_CHECKEDDISABLED,   CBS_CHECKEDNORMAL },
      { CBS_MIXEDNORMAL,     CBS_MIXEDHOT,     CBS_MIXEDPRESSED,     CBS_MIXEDDISABLED,     CBS_MIXEDNORMAL }
   };

   if( pCustomDraw->dwDrawStage == CDDS_PREERASE )
   {
      if( ! _UxTheme_Init() )
      {
         return CDRF_DODEFAULT;
      }

      hTheme = ( HTHEME ) ProcOpenThemeData( pCustomDraw->hdr.hwndFrom, L"BUTTON" );
      if( ! hTheme )
      {
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
      if( bDrawBkGrnd )
      {
         if( ProcIsThemeBackgroundPartiallyTransparent( hTheme, BP_CHECKBOX, state_id ) )
         {
            /* pCustomDraw->rc is the item´s client area */
            ProcDrawThemeParentBackground( pCustomDraw->hdr.hwndFrom, pCustomDraw->hdc, &pCustomDraw->rc );
         }
      }

      /* get button size */
      ProcGetThemePartSize( hTheme, pCustomDraw->hdc, BP_CHECKBOX, state_id, NULL, TS_TRUE, &s );

      /* get content rectangle */
      ProcGetThemeBackgroundContentRect( hTheme, pCustomDraw->hdc, BP_CHECKBOX, state_id, &pCustomDraw->rc, &content_rect );

      aux_rect.top = content_rect.top + ( content_rect.bottom - content_rect.top - s.cy ) / 2;
      aux_rect.bottom = aux_rect.top + s.cy;
      if( bLeftAlign )
      {
         aux_rect.right = content_rect.right;
         aux_rect.left = aux_rect.right - s.cx;
         content_rect.right = aux_rect.left - 3;      /* Arbitrary margin between text and button */
      }
      else
      {
         aux_rect.left = content_rect.left;
         aux_rect.right = aux_rect.left + s.cx;
         content_rect.left = aux_rect.right + 3;      /* Arbitrary margin between text and button */
      }

      /* aux_rect is the rect of the item's button area */
      ProcDrawThemeBackground( hTheme, pCustomDraw->hdc, BP_CHECKBOX, state_id, &aux_rect, NULL );

      if( strlen( cCaption ) > 0 )
      {
         getwinver( &osvi );
         if( osvi.dwMajorVersion >= 6 )
         {
            /* paint caption */
            memset( &pOptions, 0, sizeof( DTTOPTS ) );
            pOptions.dwSize = sizeof( DTTOPTS );
            if( oSelf->lFontColor != -1 )
            {
               pOptions.dwFlags |= DTT_TEXTCOLOR;
               pOptions.crText = (COLORREF) oSelf->lFontColor;
            }
            ProcDrawThemeTextEx( hTheme, pCustomDraw->hdc, BP_CHECKBOX, state_id, AnsiToWide( cCaption ), -1, DT_VCENTER | DT_LEFT | DT_SINGLELINE, &content_rect, &pOptions );

            /* paint focus rectangle */
            if( ( state & BST_FOCUS ) && ( ! bNoFocusRect ) )
            {
               aux_rect = content_rect;
               pOptions.dwFlags = DTT_CALCRECT;
               ProcDrawThemeTextEx( hTheme, pCustomDraw->hdc, BP_CHECKBOX, state_id, AnsiToWide( cCaption ), -1, DT_VCENTER | DT_LEFT | DT_SINGLELINE | DT_CALCRECT, &aux_rect, &pOptions );
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
            ProcDrawThemeText( hTheme, pCustomDraw->hdc, BP_CHECKBOX, state_id, AnsiToWide( cCaption ), -1, DT_VCENTER | DT_LEFT | DT_SINGLELINE, 0, &content_rect );

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
     ProcCloseThemeData( hTheme );
   }

   return CDRF_SKIPDEFAULT;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TCHECKBOX_NOTIFY_CUSTOMDRAW )          /* FUNCTION TCheckBox_Notify_CustomDraw( hWnd, lParam, cCaption, lDrawBkGrnd, lLeftAlign, lNoFocusRect ) -> nRet */
{
   hb_retni( TCheckBox_Notify_CustomDraw( hb_param( 1, HB_IT_OBJECT ), (LPARAM) hb_parnl( 2 ), (LPCSTR) hb_parc( 3 ),
                                          (BOOL) hb_parl( 4 ), (BOOL) hb_parl( 5 ), (BOOL) hb_parl( 6 ) ) );
}

#pragma ENDDUMP
