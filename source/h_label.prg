/*
 * $Id: h_label.prg $
 */
/*
 * ooHG source code:
 * Label control
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


#include "oohg.ch"
#include "common.ch"
#include "hbclass.ch"
#include "i_windefs.ch"

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TLabel FROM TControl

   DATA Type                      INIT "LABEL" READONLY
   DATA lAutoSize                 INIT .F.
   DATA IconWidth                 INIT 0
   DATA nWidth                    INIT 120
   DATA nHeight                   INIT 24
   DATA Picture                   INIT nil

   METHOD SetText( cText )        BLOCK {| Self, cText | ::Caption := cText }
   METHOD GetText()               BLOCK {| Self | ::Caption }

   METHOD Define
   METHOD Value                   SETGET
   METHOD Caption                 SETGET
   METHOD AutoSize                SETGET
   METHOD Align                   SETGET
   METHOD SetFont
   METHOD LeftAlign               BLOCK {| Self | ::Align( SS_LEFT ) }
   METHOD RightAlign              BLOCK {| Self | ::Align( SS_RIGHT ) }
   METHOD CenterAlign             BLOCK {| Self | ::Align( SS_CENTER ) }
   METHOD SizePos

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( cControlName, uParentForm, nCol, nRow, cCaption, nWidth, nHeight, cFontName, nFontSize, lBold, lBorder, ;
               lClientEdge, lHScroll, lVScroll, lTransparent, uBackColor, uFontColor, bOnClick, cToolTip, nHelpId, lInvisible, ;
               lItalic, lUnderline, lStrikeout, lAutoSize, lRightAlign, lHorzCenter, lRtl, lNoWordWrap, lNoPrefix, cPicture, ;
               lDisabled, lVertCenter, bOnDblClk, bOnMove, bOnLeave, uCursor ) CLASS TLabel

   LOCAL nControlHandle, nStyle, nStyleEx

   ASSIGN ::nCol        VALUE nCol         TYPE "N"
   ASSIGN ::nRow        VALUE nRow         TYPE "N"
   ASSIGN ::nWidth      VALUE nWidth       TYPE "N"
   ASSIGN ::nHeight     VALUE nHeight      TYPE "N"
   ASSIGN ::Transparent VALUE lTransparent TYPE "L" DEFAULT .F.
   ASSIGN ::Picture     VALUE cPicture     TYPE "CM"
   ASSIGN lDisabled     VALUE lDisabled    TYPE "L" DEFAULT .F.
   ASSIGN ::lAutosize   VALUE lAutoSize    TYPE "L"

   ::SetForm( cControlName, uParentForm, cFontName, nFontSize, uFontColor, uBackColor, NIL, lRtl )

   nStyle := ::InitStyle( NIL, NIL, lInvisible, .T., lDisabled ) + ;
             iif( HB_ISLOGICAL( lBorder ) .AND. lBorder, WS_BORDER, 0 ) + ;
             iif( HB_ISLOGICAL( lHScroll ) .AND. lHScroll, WS_HSCROLL, 0 ) + ;
             iif( HB_ISLOGICAL( lVScroll ) .AND. lVScroll, WS_VSCROLL, 0 ) + ;
             iif( HB_ISLOGICAL( lNoPrefix ) .AND. lNoPrefix, SS_NOPREFIX, 0 ) + ;
             iif( HB_ISLOGICAL( lVertCenter ) .AND. lVertCenter, SS_CENTERIMAGE, 0 )

   IF HB_ISLOGICAL( lNoWordWrap ) .AND. lNoWordWrap
      nStyle += SS_LEFTNOWORDWRAP
   ELSEIF HB_ISLOGICAL( lHorzCenter ) .AND. lHorzCenter
      nStyle += SS_CENTER
   ELSEIF HB_ISLOGICAL( lRightAlign ) .AND. lRightAlign
      nStyle += SS_RIGHT
   ENDIF

   nStyleEx := iif( HB_ISLOGICAL( lClientEdge ) .AND. lClientEdge, WS_EX_CLIENTEDGE, 0 ) + ;
               iif( ::Transparent, WS_EX_TRANSPARENT, 0 )

   nControlhandle := InitLabel( ::ContainerhWnd, "", 0, ::ContainerCol, ::ContainerRow, ::nWidth, ::nHeight, nStyle, nStyleEx, ::lRtl )

   ::Register( nControlHandle, cControlName, nHelpId, NIL, cToolTip )
   ::SetFont( NIL, NIL, lBold, lItalic, lUnderline, lStrikeout )

   ::Value := cCaption

   ::Cursor := uCursor

   IF ::Transparent
      RedrawWindowControlRect( ::ContainerhWnd, ::ContainerRow, ::ContainerCol, ::ContainerRow + ::Height, ::ContainerCol + ::Width )
   ENDIF

   // OnClick takes precedence over OnDblClick
   ASSIGN ::OnClick      VALUE bOnClick   TYPE "B"
   ASSIGN ::OnDblClick   VALUE bOnDblClk  TYPE "B"
   ASSIGN ::OnMouseMove  VALUE bOnMove    TYPE "B"
   ASSIGN ::OnMouseLeave VALUE bOnLeave   TYPE "B"

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value( cValue ) CLASS TLabel

   IF HB_ISBLOCK( cValue )
      cValue := Eval( cValue )
   ENDIF

   IF ValType( cValue ) $ "CFLN"
      IF ValType( ::Picture ) $ "CM"
         ::Caption := Transform( cValue, ::Picture )
      ELSE
         ::Caption := cValue
      ENDIF
   ENDIF

   RETURN ::Caption

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Caption( cValue ) CLASS TLabel

   LOCAL nLines

   IF ValType( cValue ) $ "CM"
      IF ::lAutoSize
         nLines := hb_tokenCount( StrTran( StrTran( cValue, Chr( 13 ), CRLF ), CRLF + Chr( 10 ), CRLF ), CRLF )
         ::SizePos( NIL, NIL, GetTextWidth( NIL, cValue, ::FontHandle ) + ::IconWidth, GetTextHeight( NIL, cValue, ::FontHandle ) * nLines )
      ENDIF
      SetWindowText( ::hWnd, cValue )
      IF ::Transparent
         RedrawWindowControlRect( ::ContainerhWnd, ::ContainerRow, ::ContainerCol, ::ContainerRow + ::Height, ::ContainerCol + ::Width )
      ENDIF
   ENDIF

   RETURN GetWindowText( ::hWnd )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetFont( cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout, nAngle, nCharset, nWidth, nOrientation, lAdvanced ) CLASS Tlabel

   ::Super:SetFont( cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout, nAngle, nCharset, nWidth, nOrientation, lAdvanced )
   IF ::lAutosize
      ::AutoSize( .T. )
   ELSEIF ::Transparent .AND. ::lVisible
      ::Visible := .F.
      ::Visible := .T.
   ENDIF

   RETURN ::FontHandle

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD AutoSize( lValue ) CLASS TLabel

   LOCAL cCaption

   IF HB_ISLOGICAL( lValue )
      ::lAutoSize := lValue
      IF lValue
         cCaption := GetWindowText( ::hWnd )
         ::SizePos( NIL, NIL, GetTextWidth( NIL, cCaption, ::FontHandle ) + ::IconWidth, GetTextHeight( NIL, cCaption, ::FontHandle ) )
      ENDIF
   ENDIF

   RETURN ::lAutoSize

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SizePos( nRow, nCol, nWidth, nHeight ) CLASS TLabel

   LOCAL uRet := ::Super:SizePos( nRow, nCol, nWidth, nHeight )

   SetWindowPos( ::hWnd, 0, 0, 0, 0, 0, SWP_NOACTIVATE + SWP_NOSIZE + SWP_NOMOVE + SWP_NOZORDER + SWP_FRAMECHANGED + SWP_NOCOPYBITS + SWP_NOOWNERZORDER + SWP_NOSENDCHANGING )

   RETURN uRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Align( nAlign ) CLASS TLabel

   LOCAL cAlign

   IF ValType( nAlign ) $ "CM"
      cAlign := Left( nAlign, 1 )
      IF cAlign == "L"
         nAlign := SS_LEFT
      ELSEIF cAlign == "C"
         nAlign := SS_CENTER
      ELSEIF cAlign == "R"
         nAlign := SS_RIGHT
      ENDIF
   ENDIF

   RETURN WindowStyleFlag( ::hWnd, 0x3F, nAlign )

/*--------------------------------------------------------------------------------------------------------------------------------*/
#pragma BEGINDUMP

#include "oohg.h"

/*--------------------------------------------------------------------------------------------------------------------------------*/
static WNDPROC _OOHG_TLabel_lpfnOldWndProc( LONG_PTR lp )
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
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, _OOHG_TLabel_lpfnOldWndProc( 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( INITLABEL )          /* FUNCTION InitLabel( hWnd, cCaption, hMenu, nCol, nRow, nWidth, nHeight, nStyle, nStyleEx, lRtl ) -> hWnd */
{
   HWND hlabel;
   int Style, StyleEx;

   Style = hb_parni( 8 ) | WS_CHILD | SS_NOTIFY | WS_GROUP;

   StyleEx = hb_parni( 9 ) | _OOHG_RTL_Status( hb_parl( 10 ) );

   hlabel = CreateWindowEx( StyleEx, "STATIC", hb_parc( 2 ), Style,
                             hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ), hb_parni( 7 ),
                             HWNDparam( 1 ), HMENUparam( 3 ), GetModuleHandle( NULL ), NULL );

   _OOHG_TLabel_lpfnOldWndProc( SetWindowLongPtr( hlabel, GWLP_WNDPROC, (LONG_PTR) SubClassFunc ) );

   HWNDret( hlabel );
}

#pragma ENDDUMP
