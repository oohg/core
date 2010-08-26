/*
 * $Id: h_radio.prg,v 1.25 2010-08-26 20:00:55 guerra000 Exp $
 */
/*
 * ooHG source code:
 * Radio button functions
 *
 * Copyright 2005-2010 Vicente Guerra <vicente@guerra.com.mx>
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

CLASS TRadioGroup FROM TLabel
   DATA Type          INIT "RADIOGROUP" READONLY
   DATA TabStop       INIT .T.
   DATA IconWidth     INIT 19
   DATA nWidth        INIT 120
   DATA nHeight       INIT 25
   DATA aOptions      INIT {}

   METHOD RowMargin   BLOCK { |Self| - ::Row }
   METHOD ColMargin   BLOCK { |Self| - ::Col }

   METHOD Define
   METHOD SetFont
   METHOD SizePos
   METHOD Value               SETGET
   METHOD Enabled             SETGET
   METHOD SetFocus
   METHOD Visible             SETGET

   METHOD Caption

   METHOD Events
   METHOD Events_Command

   EMPTY( _OOHG_AllVars )
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, aOptions, Value, fontname, ;
               fontsize, tooltip, change, width, spacing, HelpId, invisible, ;
               notabstop, bold, italic, underline, strikeout, backcolor, ;
               fontcolor, transparent, autosize, horizontal, lDisabled, lRtl, ;
               height ) CLASS TRadioGroup
*-----------------------------------------------------------------------------*
Local ControlHandle, i, oItem, nStyle

   ASSIGN ::nCol    VALUE x      TYPE "N"
   ASSIGN ::nRow    VALUE y      TYPE "N"
   ASSIGN ::nWidth  VALUE width  TYPE "N"
   ASSIGN ::nHeight VALUE height TYPE "N"

   ASSIGN ::lAutoSize VALUE autosize   TYPE "L"
   ASSIGN horizontal  VALUE horizontal TYPE "L" DEFAULT .F.

   default invisible to .F.
   default notabstop to .F.

   IF horizontal
      ASSIGN Spacing     VALUE Spacing    TYPE "N" DEFAULT ::nWidth
   ELSE
      ASSIGN Spacing     VALUE Spacing    TYPE "N" DEFAULT ::nHeight
   ENDIF

   IF VALTYPE( NoTabStop ) == "L"
      ::TabStop := ! NoTabStop
   ENDIF

   ::SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor,, lRtl )

   nStyle := ::InitStyle( ,, Invisible, .T., lDisabled )

   ControlHandle := InitRadioGroup( ::ContainerhWnd, ::ContainerCol, ::ContainerRow, nStyle, ::lRtl )

   ::Register( ControlHandle, ControlName, HelpId,, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   ::Transparent := transparent
   ::AutoSize    := autosize

   // First item
   oItem := TRadioItem():SetForm( , Self )
   oItem:Register( ControlHandle, , HelpId, !Invisible, ToolTip )
   oItem:SetFont( , , bold, italic, underline, strikeout )
   oItem:SizePos( ::Row, ::Col, ::Width, ::Height )
   oItem:AutoSize := autosize
   oItem:Caption := aOptions[ 1 ]
   ::aOptions := { oItem }

   x := ::Col
   y := ::Row

   For i = 2 to len( aOptions )

      If horizontal
         x += Spacing
      Else
         y += Spacing
      EndIf

      ControlHandle := InitRadioButton( ::ContainerhWnd, x, y, nStyle, ::lRtl )

      oItem := TRadioItem():SetForm( , Self )
      oItem:Register( ControlHandle, , HelpId,, ToolTip )
      oItem:SetFont( , , bold, italic, underline, strikeout )
      oItem:SizePos( y, x, ::Width, ::Height )
      oItem:AutoSize := autosize
      oItem:Caption := aOptions[ i ]
      AADD( ::aOptions, oItem )
   Next

   If HB_IsNumeric( Value ) .AND. Value >= 1 .AND. Value <= Len( ::aOptions )
      SendMessage( ::aOptions[ value ]:hWnd, BM_SETCHECK , BST_CHECKED , 0 )
      If ! notabstop
         ::aOptions[ Value ]:TabStop := .T.
      EndIf
   Else
      If ! notabstop
         ::aOptions[ 1 ]:TabStop := .T.
      EndIf
 EndIf

   ASSIGN ::OnChange    VALUE Change    TYPE "B"

Return Self

*-----------------------------------------------------------------------------*
METHOD SetFont( FontName, FontSize, Bold, Italic, Underline, Strikeout ) CLASS TRadioGroup
*-----------------------------------------------------------------------------*
   AEVAL( ::aOptions, { |o| o:SetFont( FontName, FontSize, Bold, Italic, Underline, Strikeout ) } )
RETURN ::Super:SetFont( FontName, FontSize, Bold, Italic, Underline, Strikeout )

*-----------------------------------------------------------------------------*
METHOD SizePos( Row, Col, Width, Height ) CLASS TRadioGroup
*-----------------------------------------------------------------------------*
Local nDeltaRow, nDeltaCol, uRet
   nDeltaRow := ::Row
   nDeltaCol := ::Col
   uRet := ::Super:SizePos( Row, Col, Width, Height )
   nDeltaRow := ::Row - nDeltaRow
   nDeltaCol := ::Col - nDeltaCol
   AEVAL( ::aControls, { |o| o:SizePos( o:Row + nDeltaRow, o:Col + nDeltaCol ) } )
Return uRet

*-----------------------------------------------------------------------------*
METHOD Value( nValue ) CLASS TRadioGroup
*-----------------------------------------------------------------------------*
LOCAL nOldValue, aNewValue, I, oItem, nLen
   If HB_IsNumeric( nValue )
      nValue := INT( nValue )
      nLen := LEN( ::aOptions )
      aNewValue := AFILL( ARRAY( nLen ), BST_UNCHECKED )
      If nValue >= 1 .AND. nValue <= nLen
         nOldValue := nValue
         aNewValue[ nValue ] := BST_CHECKED
         If ::TabStop .and. ::aOptions[ nValue ]:TabStop
            ::aOptions[ nValue ]:TabStop := .F.
         EndIf
      Else
         nOldValue := 0
      EndIf
      For I := 1 TO nLen
         oItem := ::aOptions[ I ]
         If SendMessage( oItem:hWnd, BM_GETCHECK, 0, 0 ) != aNewValue[ I ]
            SendMessage( oItem:hWnd, BM_SETCHECK, aNewValue[ I ], 0 )
            //////// ojo aqui en esta linea de abajo
            ::DoChange()
         EndIf
         If ! ( ::TabStop .AND. MAX( nValue, 1 ) == I ) == ::aOptions[ I ]:TabStop
            ::aOptions[ I ]:TabStop := ( MAX( nValue, 1 ) == I )
         EndIf
      Next
   Else
      nOldValue := ASCAN( ::aOptions, { |o| SendMessage( o:hWnd, BM_GETCHECK, 0, 0 ) == BST_CHECKED } )
   EndIf
RETURN nOldValue

*-----------------------------------------------------------------------------*
METHOD Enabled( lEnabled ) CLASS TRadioGroup
*-----------------------------------------------------------------------------*
   If HB_IsLogical( lEnabled )
      ::Super:Enabled := lEnabled
      AEVAL( ::aControls, { |o| o:Enabled := o:Enabled } )
   EndIf
RETURN ::Super:Enabled

*-----------------------------------------------------------------------------*
METHOD SetFocus() CLASS TRadioGroup
*-----------------------------------------------------------------------------*
Local nValue
   nValue := ::Value
   If nValue >= 1 .AND. nValue <= Len( ::aOptions )
      ::aOptions[ nValue ]:SetFocus()
   Else
      ::aOptions[ 1 ]:SetFocus()
   EndIf
Return Self

*-----------------------------------------------------------------------------*
METHOD Visible( lVisible ) CLASS TRadioGroup
*-----------------------------------------------------------------------------*
   If HB_IsLogical( lVisible )
      ::Super:Visible := lVisible
      If lVisible
         AEVAL( ::aControls, { |o| o:Visible := o:Visible } )
      Else
         AEVAL( ::aControls, { |o| o:ForceHide() } )
      EndIf
   EndIf
RETURN ::lVisible

*-----------------------------------------------------------------------------*
METHOD Caption( nItem, uValue ) CLASS TRadioGroup
*-----------------------------------------------------------------------------*
Return ( ::aOptions[ nItem ]:Caption := uValue )

*-----------------------------------------------------------------------------*
METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TRadioGroup
*-----------------------------------------------------------------------------*
   If nMsg == WM_LBUTTONDBLCLK
      If HB_IsBlock( ::aControls[ 1 ]:OnDblClick )
         ::aControls[ 1 ]:DoEvent( ::aControls[ 1 ]:OnDblClick, "DBLCLICK" )
      Else
         ::DoEvent( ::OnDblClick, "DBLCLICK" )
      EndIf
      Return nil
   ElseIf nMsg == WM_RBUTTONUP
      If HB_IsBlock( ::aControls[ 1 ]:OnRClick )
         ::aControls[ 1 ]:DoEvent( ::aControls[ 1 ]:OnRClick, "RCLICK" )
      Else
         ::DoEvent( ::OnRClick, "RCLICK" )
      EndIf
      Return nil
   EndIf
RETURN ::Super:Events( hWnd, nMsg, wParam, lParam )

*-----------------------------------------------------------------------------*
METHOD Events_Command( wParam ) CLASS TRadioGroup
*-----------------------------------------------------------------------------*
Local Hi_wParam := HIWORD( wParam )
Local lTab
   If Hi_wParam == BN_CLICKED
      lTab := ::TabStop .AND. ::Value <= 1
      If ! lTab == ::aOptions[ 1 ]:TabStop
         ::aOptions[ 1 ]:TabStop := lTab
      EndIf
      ::DoChange()
      Return nil
   EndIf
Return ::Super:Events_Command( wParam )





CLASS TRadioItem FROM TLabel
   DATA Type          INIT "RADIOITEM" READONLY
   DATA IconWidth     INIT 19

   METHOD Events
   METHOD Events_Command
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TRadioItem
*-----------------------------------------------------------------------------*
   If nMsg == WM_LBUTTONDBLCLK
      If HB_IsBlock( ::OnDblClick )
         ::DoEvent( ::OnDblClick, "DBLCLICK" )
      Else
         ::Container:DoEvent( ::Container:OnDblClick, "DBLCLICK" )
      EndIf
      Return nil
   ElseIf nMsg == WM_RBUTTONUP
      If HB_IsBlock( ::OnRClick )
         ::DoEvent( ::OnRClick, "RCLICK" )
      Else
         ::Container:DoEvent( ::Container:OnRClick, "RCLICK" )
      EndIf
      Return nil
   EndIf
RETURN ::Super:Events( hWnd, nMsg, wParam, lParam )

*-----------------------------------------------------------------------------*
METHOD Events_Command( wParam ) CLASS TRadioItem
*-----------------------------------------------------------------------------*
Local Hi_wParam := HIWORD( wParam )
Local lTab
   If Hi_wParam == BN_CLICKED
      lTab := ::Container:TabStop .AND. ( SendMessage( ::hWnd, BM_GETCHECK, 0, 0 ) == BST_CHECKED )
      If ! lTab == ::TabStop
         ::TabStop := lTab
      EndIf
      ::Container:DoChange()
      Return nil
   EndIf
Return ::Super:Events_Command( wParam )





EXTERN InitRadioGroup, InitRadioButton

#pragma BEGINDUMP
// #define s_Super s_TLabel
#include "hbapi.h"
#include <windows.h>
#include <commctrl.h>
#include "oohg.h"

static WNDPROC lpfnOldWndProcA = 0, lpfnOldWndProcB = 0;

static LRESULT APIENTRY SubClassFuncA( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProcA );
}

static LRESULT APIENTRY SubClassFuncB( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProcB );
}

HB_FUNC( INITRADIOGROUP )
{
 HWND hbutton;
   int Style   = hb_parni( 4 ) | BS_NOTIFY | WS_CHILD | BS_AUTORADIOBUTTON | WS_GROUP;
   int StyleEx = _OOHG_RTL_Status( hb_parl( 5 ) );

   hbutton = CreateWindowEx( StyleEx, "button", "", Style,
                             hb_parni( 2 ), hb_parni( 3 ), 0, 0,
                             HWNDparam( 1 ), ( HMENU ) NULL, GetModuleHandle( NULL ), NULL );

   lpfnOldWndProcA = ( WNDPROC ) SetWindowLong( ( HWND ) hbutton, GWL_WNDPROC, ( LONG ) SubClassFuncA );

   HWNDret( hbutton );
}

HB_FUNC( INITRADIOBUTTON )
{
 HWND hbutton;
   int Style   = hb_parni( 4 ) | BS_NOTIFY | WS_CHILD | BS_AUTORADIOBUTTON;
   int StyleEx = _OOHG_RTL_Status( hb_parl( 5 ) );

   hbutton = CreateWindowEx( StyleEx, "button", "", Style,
                             hb_parni( 2 ), hb_parni( 3 ), 0, 0,
                             HWNDparam( 1 ), ( HMENU ) NULL, GetModuleHandle( NULL ), NULL );

   lpfnOldWndProcB = ( WNDPROC ) SetWindowLong( ( HWND ) hbutton, GWL_WNDPROC, ( LONG ) SubClassFuncB );

   HWNDret( hbutton );
}

#pragma ENDDUMP
