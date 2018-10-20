/*
 * $Id: h_label.prg $
 */
/*
 * ooHG source code:
 * Label control
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

CLASS TLabel FROM TControl

   DATA Type      INIT "LABEL" READONLY
   DATA lAutoSize INIT .F.
   DATA IconWidth INIT 0
   DATA nWidth    INIT 120
   DATA nHeight   INIT 24
   DATA Picture   INIT nil

   METHOD SetText( cText )     BLOCK { | Self, cText | ::Caption := cText }
   METHOD GetText()            BLOCK { | Self | ::Caption }

   METHOD Define
   METHOD Value      SETGET
   METHOD Caption    SETGET
   METHOD AutoSize   SETGET
   METHOD Align      SETGET
   METHOD SetFont
   METHOD LeftAlign   BLOCK { |Self| ::Align( SS_LEFT ) }
   METHOD RightAlign  BLOCK { |Self| ::Align( SS_RIGHT ) }
   METHOD CenterAlign BLOCK { |Self| ::Align( SS_CENTER ) }
   METHOD SizePos

   ENDCLASS

METHOD Define( ControlName, ParentForm, x, y, Caption, w, h, fontname, ;
               fontsize, bold, BORDER, CLIENTEDGE, HSCROLL, VSCROLL, ;
               lTRANSPARENT, aRGB_bk, aRGB_font, ProcedureName, tooltip, ;
               HelpId, invisible, italic, underline, strikeout, autosize, ;
               rightalign, centeralign, lRtl, lNoWordWrap, lNoPrefix, ;
               cPicture, lDisabled, lCenterAlign, bDblClk ) CLASS TLabel

   Local ControlHandle, nStyle, nStyleEx

   ASSIGN ::nCol        VALUE x TYPE "N"
   ASSIGN ::nRow        VALUE y TYPE "N"
   ASSIGN ::nWidth      VALUE w TYPE "N"
   ASSIGN ::nHeight     VALUE h TYPE "N"
   ASSIGN ::Transparent VALUE ltransparent TYPE "L" DEFAULT .F.
   ASSIGN ::Picture     VALUE cPicture     TYPE "CM"
   ASSIGN lDisabled     VALUE lDisabled    TYPE "L" DEFAULT .F.

   ::SetForm( ControlName, ParentForm, FontName, FontSize, aRGB_font, aRGB_bk, , lRtl )

   nStyle := ::InitStyle( ,, Invisible, .T., lDisabled ) + ;
             if( HB_IsLogical( BORDER )       .AND. BORDER,        WS_BORDER,      0 ) + ;
             if( HB_IsLogical( HSCROLL )      .AND. HSCROLL,       WS_HSCROLL,     0 ) + ;
             if( HB_IsLogical( VSCROLL )      .AND. VSCROLL,       WS_VSCROLL,     0 ) + ;
             if( HB_IsLogical( lNoPrefix )    .AND. lNoPrefix,     SS_NOPREFIX,    0 ) + ;
             if( HB_IsLogical( lCenterAlign ) .AND. lCenterAlign,  SS_CENTERIMAGE, 0 )

   If HB_IsLogical( lNoWordWrap )  .AND. lNoWordWrap
      nStyle += SS_LEFTNOWORDWRAP
   ElseIf HB_IsLogical( centeralign ) .AND. centeralign
      nStyle += SS_CENTER
   ElseIf HB_IsLogical( rightalign ) .AND. rightalign
      nStyle += SS_RIGHT
   EndIf

   nStyleEx := if( HB_IsLogical( CLIENTEDGE )  .AND. CLIENTEDGE,   WS_EX_CLIENTEDGE,  0 ) + ;
               if( ::Transparent, WS_EX_TRANSPARENT, 0 )

   Controlhandle := InitLabel( ::ContainerhWnd, "", 0, ::ContainerCol, ::ContainerRow, ::nWidth, ::nHeight, nStyle, nStyleEx, ::lRtl )

   ::Register( ControlHandle, ControlName, HelpId,, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   ::Value := Caption

   If ::Transparent
      RedrawWindowControlRect( ::ContainerhWnd, ::ContainerRow, ::ContainerCol, ::ContainerRow + ::Height, ::ContainerCol + ::Width )
   EndIf

   ASSIGN ::AutoSize VALUE autosize TYPE "L" DEFAULT ::AutoSize

   // OnClick takes precedence over OnDblClick
   ASSIGN ::OnClick    VALUE ProcedureName TYPE "B"
   ASSIGN ::OnDblClick VALUE bDblClk       TYPE "B"

   Return Self

METHOD Value( cValue ) CLASS TLabel

   IF ValType( cValue ) $ "CFLN"
      IF ValType( ::Picture ) $ "CM"
         ::Caption := Transform( cValue, ::Picture )
      ELSE
         ::Caption := cValue
      ENDIF
   ENDIF

   RETURN ::Caption

METHOD Caption( cValue ) CLASS TLabel

   IF ValType( cValue ) $ "CM"
      IF ::lAutoSize
         ::SizePos( , , GetTextWidth( NIL, cValue , ::FontHandle ) + ::IconWidth, GetTextHeight( NIL, cValue , ::FontHandle ) )
      ENDIF
      SetWindowText( ::hWnd , cValue )
      IF ::Transparent
         RedrawWindowControlRect( ::ContainerhWnd, ::ContainerRow, ::ContainerCol, ::ContainerRow + ::Height, ::ContainerCol + ::Width )
      ENDIF
   ELSE
      cValue := GetWindowText( ::hWnd )
   ENDIF

   RETURN cValue

METHOD SetFont( cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout, nAngle, nCharset, nWidth, nOrientation, lAdvanced ) CLASS Tlabel

   ::Super:SetFont( cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout, nAngle, nCharset, nWidth, nOrientation, lAdvanced )
   IF ::lAutosize
      ::AutoSize( .T. )
   ELSEIF ::Transparent .AND. ::lVisible
      ::Visible := .F.
      ::Visible := .T.
   ENDIF

   RETURN NIL

METHOD AutoSize( lValue ) CLASS TLabel

   Local cCaption

   If HB_IsLogical( lValue )
      ::lAutoSize := lValue
      If lValue
         cCaption := GetWindowText( ::hWnd )
         ::SizePos( , , GetTextWidth( Nil, cCaption, ::FontHandle ) + ::IconWidth, GetTextHeight( Nil, cCaption, ::FontHandle ) )
      EndIf
   EndIf

   RETURN ::lAutoSize

METHOD SizePos( Row, Col, Width, Height ) CLASS TLabel

   LOCAL uRet := ::Super:SizePos( Row, Col, Width, Height )

   SetWindowPos( ::hWnd, 0, 0, 0, 0, 0, SWP_NOACTIVATE + SWP_NOSIZE + SWP_NOMOVE + SWP_NOZORDER + SWP_FRAMECHANGED + SWP_NOCOPYBITS + SWP_NOOWNERZORDER + SWP_NOSENDCHANGING )

   RETURN uRet

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


EXTERN InitLabel

#pragma BEGINDUMP

#include <hbapi.h>
#include <windows.h>
#include <commctrl.h>
#include "oohg.h"

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

HB_FUNC( INITLABEL )
{
   HWND hbutton;

   int Style, ExStyle;

   Style = hb_parni( 8 ) | WS_CHILD | SS_NOTIFY | WS_GROUP;
   ExStyle = hb_parni( 9 ) | _OOHG_RTL_Status( hb_parl( 10 ) );

   hbutton = CreateWindowEx( ExStyle, "static", hb_parc( 2 ), Style,
                             hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ), hb_parni( 7 ),
                             HWNDparam( 1 ), ( HMENU ) hb_parni( 3 ), GetModuleHandle( NULL ), NULL );

   lpfnOldWndProc = (WNDPROC) SetWindowLongPtr( hbutton, GWL_WNDPROC, (LONG_PTR) SubClassFunc );

   HWNDret( hbutton );
}

#pragma ENDDUMP
