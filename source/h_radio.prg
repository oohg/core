/*
 * $Id: h_radio.prg,v 1.11 2006-04-21 05:34:26 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG radio button functions
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

CLASS TRadioGroup FROM TLabel
   DATA Type          INIT "RADIOGROUP" READONLY
   DATA TabStop       INIT .T.
   DATA IconWidth     INIT 19

   METHOD RowMargin   BLOCK { |Self| - ::Row }
   METHOD ColMargin   BLOCK { |Self| - ::Col }

   METHOD Define
   METHOD SetFont
   METHOD SizePos
   METHOD Value               SETGET
   METHOD Enabled             SETGET
   METHOD ForceHide           BLOCK { |Self| AEVAL( ::aControls, { |o| o:ForceHide() } ) }
   METHOD SetFocus
   METHOD Show
   METHOD Hide

   METHOD IsHandle
   METHOD Caption

   METHOD Events_Command
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, aOptions, Value, fontname, ;
               fontsize, tooltip, change, width, spacing, HelpId, invisible, ;
               notabstop, bold, italic, underline, strikeout, backcolor, ;
               fontcolor, transparent, autosize, horizontal ) CLASS TRadioGroup
*-----------------------------------------------------------------------------*
Local i
Local oItem
Local ControlHandle

   DEFAULT Width      TO 120
   DEFAULT Spacing    TO 25
   DEFAULT change     TO ""
   DEFAULT invisible  TO FALSE
   DEFAULT notabstop  TO FALSE
   DEFAULT autosize   TO FALSE
   DEFAULT horizontal TO FALSE

   ::SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor )

   ControlHandle := InitRadioGroup( ::ContainerhWnd, aOptions[1], 0, x, y , '' , 0 , width, invisible, .T. )

   ::Register( ControlHandle, ControlName, HelpId, ! Invisible, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )
   ::SizePos( y, x, Width, Spacing * len( aOptions ) )

   ::Transparent :=  transparent
   ::OnChange   :=  Change
   ::TabStop := NoTabStop
   ::AutoSize := autosize

   // First item
   oItem := TRadioItem():SetForm( , Self )
   oItem:Register( ControlHandle, , HelpId, ! Invisible, ToolTip )
   oItem:SetFont( , , bold, italic, underline, strikeout )
   oItem:SizePos( ::Row, ::Col, ::Width, Spacing )
   oItem:AutoSize := autosize
   oItem:Caption := aOptions[ 1 ]

   x := ::Col
   y := ::Row

   for i = 2 to len( aOptions )

      If horizontal
         x += width
      Else
         y += Spacing
      EndIf

      ControlHandle := InitRadioButton( ::ContainerhWnd, aOptions[i], 0, x, y , '' , 0 , width, invisible )

      oItem := TRadioItem():SetForm( , Self )
      oItem:Register( ControlHandle, , HelpId, ! Invisible, ToolTip )
      oItem:SetFont( , , bold, italic, underline, strikeout )
      oItem:SizePos( y, x, Width, Spacing )
      oItem:AutoSize := autosize
      oItem:Caption := aOptions[ i ]
	next i

   if valtype( Value ) == "N" .AND. Value >= 1 .AND. Value <= Len( ::aControls )
      SendMessage( ::aControls[ value ]:hWnd, BM_SETCHECK , BST_CHECKED , 0 )
      if notabstop .and. IsTabStop( ::aControls[ value ]:hWnd )
         SetTabStop( ::aControls[ value ]:hWnd, .f. )
		endif
   Else
      if ! notabstop .and. ! IsTabStop( ::hWnd )
         SetTabStop( ::hWnd, .T. )
		endif
	EndIf

Return Self

*-----------------------------------------------------------------------------*
METHOD SetFont( FontName, FontSize, Bold, Italic, Underline, Strikeout ) CLASS TRadioGroup
*-----------------------------------------------------------------------------*
   AEVAL( ::aControls, { |o| o:SetFont( FontName, FontSize, Bold, Italic, Underline, Strikeout ) } )
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
   IF VALTYPE( nValue ) == "N"
      ASCAN( ::aControls, { |o| SendMessage( o:hWnd, BM_GETCHECK, BST_UNCHECKED, 0 ) } )
      SendMessage( ::aControls[ nValue ]:hWnd, BM_SETCHECK, BST_CHECKED, 0 )
      if ::TabStop .and. IsTabStop( ::aControls[ nValue ]:hWnd )
         SetTabStop( ::aControls[ nValue ]:hWnd, .f. )
		endif
   ENDIF
   nValue := ASCAN( ::aControls, { |o| SendMessage( o:hWnd, BM_GETCHECK, 0, 0 ) == BST_CHECKED } )
RETURN nValue

*-----------------------------------------------------------------------------*
METHOD Enabled( lEnabled ) CLASS TRadioGroup
*-----------------------------------------------------------------------------*
   IF VALTYPE( lEnabled ) == "L"
      ::Super:Enabled := lEnabled
      AEVAL( ::aControls, { |o| o:Enabled := o:Enabled } )
   ENDIF
RETURN ::Super:Enabled

*-----------------------------------------------------------------------------*
METHOD SetFocus() CLASS TRadioGroup
*-----------------------------------------------------------------------------*
Local nValue
   nValue := ::Value
   If nValue >= 1 .AND. nValue <= Len( ::aControls )
      ::aControls[ nValue ]:SetFocus()
   EndIf
Return Self

*-----------------------------------------------------------------------------*
METHOD Show() CLASS TRadioGroup
*-----------------------------------------------------------------------------*
   ::Super:Show()
   AEVAL( ::aControls, { |o| o:Visible := o:Visible } )
RETURN nil

*-----------------------------------------------------------------------------*
METHOD Hide() CLASS TRadioGroup
*-----------------------------------------------------------------------------*
   ::Super:Hide()
   AEVAL( ::aControls, { |o| o:ForceHide() } )
RETURN nil

*-----------------------------------------------------------------------------*
METHOD IsHandle( hWnd ) CLASS TRadioGroup
*-----------------------------------------------------------------------------*
Return ( ASCAN( ::aControls, { |o| o:hWnd == hWnd } ) != 0 )

*-----------------------------------------------------------------------------*
METHOD Caption( nItem, uValue ) CLASS TRadioGroup
*-----------------------------------------------------------------------------*
Return ( ::aControls[ nItem ]:Caption := uValue )

*-----------------------------------------------------------------------------*
METHOD Events_Command( wParam ) CLASS TRadioGroup
*-----------------------------------------------------------------------------*
Local Hi_wParam := HIWORD( wParam )
   If Hi_wParam == BN_CLICKED
      ::DoEvent( ::OnChange )
      If ::TabStop .AND. IsTabStop( ::hWnd )
         SetTabStop( ::hWnd, .F. )
      EndIf
      Return nil
   EndIf
Return ::Super:Events_Command( wParam )





CLASS TRadioItem FROM TLabel
   DATA Type          INIT "RADIOITEM" READONLY
   DATA IconWidth     INIT 19

   METHOD Events_Command
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Events_Command( wParam ) CLASS TRadioItem
*-----------------------------------------------------------------------------*
Local Hi_wParam := HIWORD( wParam )
   If Hi_wParam == BN_CLICKED
      ::Container:DoEvent( ::Container:OnChange )
      If ::Container:TabStop .AND. IsTabStop( ::hWnd )
         SetTabStop( ::hWnd, .F. )
      EndIf
      Return nil
   EndIf
Return ::Super:Events_Command( wParam )