/*
 * $Id: h_label.prg,v 1.13 2006-02-11 06:19:33 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG label functions
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

#include "oohg.ch"
#include "common.ch"
#include "hbclass.ch"
#include "i_windefs.ch"

CLASS TLabel FROM TControl
   DATA Type      INIT "LABEL" READONLY
   DATA lAutoSize INIT .F.
   DATA IconWidth INIT 0

   METHOD SetText( cText )     BLOCK { | Self, cText | ::Caption := cText }
   METHOD GetText()            BLOCK { | Self | ::Caption }

   METHOD Define
   METHOD Value      SETGET
   METHOD Caption    SETGET
   METHOD AutoSize   SETGET
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, Caption, w, h, fontname, ;
               fontsize, bold, BORDER, CLIENTEDGE, HSCROLL, VSCROLL, ;
               lTRANSPARENT, aRGB_bk, aRGB_font, ProcedureName, tooltip, ;
               HelpId, invisible, italic, underline, strikeout, autosize, ;
               rightalign, centeralign, lRtl, lNoWordWrap ) CLASS TLabel
*-----------------------------------------------------------------------------*
Local ControlHandle, nStyle, nStyleEx

   DEFAULT w             TO 120
   DEFAULT h             TO 24
   DEFAULT ProcedureName TO ""
   DEFAULT invisible     TO FALSE
   DEFAULT ltransparent  TO FALSE

   ::SetForm( ControlName, ParentForm, FontName, FontSize, aRGB_font, aRGB_bk, , lRtl )

   nStyle := if( ValType( invisible ) != "L" .OR. ! invisible, WS_VISIBLE, 0 ) + ;
             if( ValType( BORDER ) == "L"    .AND. BORDER,     WS_BORDER,  0 ) + ;
             if( ValType( HSCROLL ) == "L"   .AND. HSCROLL,    WS_HSCROLL, 0 ) + ;
             if( ValType( VSCROLL ) == "L"   .AND. VSCROLL,    WS_VSCROLL, 0 )

   If ValType( lNoWordWrap ) == "L" .AND. lNoWordWrap
      nStyle += SS_LEFTNOWORDWRAP
   ElseIf ValType( centeralign ) == "L" .AND. centeralign
      nStyle += SS_CENTER
   ElseIf ValType( rightalign ) == "L" .AND. rightalign
      nStyle += SS_RIGHT
   EndIf

   nStyleEx := if( ValType( CLIENTEDGE ) == "L"   .AND. CLIENTEDGE,   WS_EX_CLIENTEDGE,  0 ) + ;
               if( ValType( lTRANSPARENT ) == "L" .AND. lTRANSPARENT, WS_EX_TRANSPARENT, 0 )

   Controlhandle := InitLabel( ::ContainerhWnd, Caption, 0, x, y, w, h, '', 0, Nil , nStyle, nStyleEx, ::lRtl )

   ::Register( ControlHandle, ControlName, HelpId, ! Invisible, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )
   ::SizePos( y, x, w, h )

   ::OnClick := ProcedureName
   ::Transparent := ltransparent
   ::AutoSize := autosize

Return Self

*-----------------------------------------------------------------------------*
METHOD Value( cValue ) CLASS TLabel
*-----------------------------------------------------------------------------*
Return ( ::Caption := cValue )

*-----------------------------------------------------------------------------*
METHOD Caption( cValue ) CLASS TLabel
*-----------------------------------------------------------------------------*
   IF VALTYPE( cValue ) $ "CM"
      if ::lAutoSize
         ::SizePos( , , GetTextWidth( nil, cValue , ::FontHandle ) + ::IconWidth, GetTextHeight( nil, cValue , ::FontHandle ) )
		EndIf
      SetWindowText( ::hWnd , cValue )
      If ::Transparent
         RedrawWindowControlRect( ::ContainerhWnd, ::ContainerRow, ::ContainerCol, ::ContainerRow + ::Height, ::ContainerCol + ::Width )
      EndIf
   ELSE
      cValue := GetWindowText( ::hWnd )
   ENDIF
RETURN cValue

*-----------------------------------------------------------------------------*
METHOD AutoSize( lValue ) CLASS TLabel
*-----------------------------------------------------------------------------*
Local cCaption
   If ValType( lValue ) == "L"
      ::lAutoSize := lValue
      If lValue
         cCaption := GetWindowText( ::hWnd )
         ::SizePos( , , GetTextWidth( NIL, cCaption, ::FontHandle ) + ::IconWidth, GetTextHeight( NIL, cCaption, ::FontHandle ) )
         RedrawWindow( ::hWnd )
      EndIf
   EndIf
Return ::lAutoSize