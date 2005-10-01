/*
 * $Id: h_combo.prg,v 1.7 2005-10-01 15:35:10 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG combobox functions
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

CLASS TCombo FROM TLabel
   DATA Type      INIT "COMBO" READONLY
   DATA WorkArea  INIT ""
   DATA Field     INIT ""
   DATA nValue    INIT 0
   DATA ValueSource   INIT ""
   DATA SetImageListCommand INIT CBEM_SETIMAGELIST
   DATA SetImageListWParam  INIT 0

   METHOD Define
   METHOD Refresh
   METHOD Value               SETGET
   METHOD Visible             SETGET
   METHOD ForceHide           BLOCK { |Self| SendMessage( ::hWnd, 335 , 0 , 0 ) , ::Super:ForceHide() }
   METHOD RefreshData

   METHOD Events_Command

   METHOD AddItem(cValue)     BLOCK { |Self,uValue| ComboAddString( ::hWnd, uValue ) }
   METHOD DeleteItem(nItem)   BLOCK { |Self,nItem| ComboBoxDeleteString( ::hWnd, nItem ) }
   METHOD DeleteAllItems      BLOCK { | Self | ComboBoxReset( ::hWnd ) }
   METHOD Item
   METHOD ItemCount           BLOCK { | Self | ComboBoxGetItemCount( ::hWnd ) }
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, rows, value, fontname, ;
               fontsize, tooltip, changeprocedure, h, gotfocus, lostfocus, ;
               uEnter, HelpId, invisible, notabstop, sort, bold, italic, ;
               underline, strikeout, itemsource, valuesource, displaychange, ;
               ondisplaychangeprocedure, break, GripperText, aImage, lRtl ) CLASS TCombo
*-----------------------------------------------------------------------------*
Local ControlHandle , rcount := 0 , BackRec , cset := 0 , WorkArea , cField

   DEFAULT w               TO 120
   DEFAULT h               TO 150
   DEFAULT changeprocedure TO ""
   DEFAULT gotfocus     TO ""
   DEFAULT lostfocus    TO ""
   DEFAULT rows         TO {}
   DEFAULT invisible    TO FALSE
   DEFAULT notabstop    TO FALSE
   DEFAULT sort		TO FALSE
   DEFAULT GripperText	TO ""

   ::SetForm( ControlName, ParentForm, FontName, FontSize, , , .t. , lRtl )

	if ValType ( ItemSource ) != 'U' .And. Sort == .T.
      MsgOOHGError ("Sort and ItemSource clauses can't be used simultaneusly. Program Terminated" )
	EndIf

	if ValType ( ValueSource ) != 'U' .And. Sort == .T.
      MsgOOHGError ("Sort and ValueSource clauses can't be used simultaneusly. Program Terminated" )
	EndIf

	if valtype ( itemsource ) != 'U'
		if  at ( '>',ItemSource ) == 0
         MsgOOHGError ("Control: " + ControlName + " Of " + ParentForm + " : You must specify a fully qualified field name. Program Terminated" )
		Else
			WorkArea := Left ( ItemSource , at ( '>', ItemSource ) - 2 )
			cField := Right ( ItemSource , Len (ItemSource) - at ( '>', ItemSource ) )
		EndIf
	EndIf

	if valtype(value) == "U"
		value := 0
	endif

	if valtype(x) == "U" .or. valtype(y) == "U"

      if _OOHG_SplitForceBreak
         Break := .T.
      endif
      _OOHG_SplitForceBreak := .F.

      ControlHandle := InitComboBox ( ::Parent:ReBarHandle, 0, x, y, w, '', 0 , h, invisible, notabstop, sort, displaychange , _OOHG_IsXP , ::lRtl )

      AddSplitBoxItem ( Controlhandle , ::Parent:ReBarHandle, w , break , GripperText , w , , _OOHG_ActiveSplitBoxInverted )

	else

      ControlHandle := InitComboBox ( ::ContainerhWnd, 0, x, y, w, '', 0 , h, invisible, notabstop, sort , displaychange , _OOHG_IsXP , ::lRtl )

	endif

	if valtype(uEnter) == "U"
		uEnter := ""
	endif

   ::New( ControlHandle, ControlName, HelpId, ! Invisible, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )
   ::SizePos( y, x, w, h )

   ::OnClick := ondisplaychangeprocedure
   ::Field :=  cField
   ::nValue   :=  Value
   ::OnLostFocus := LostFocus
   ::OnGotFocus :=  GotFocus
   ::OnChange   :=  ChangeProcedure
   ::OnDblClick := uEnter
   ::WorkArea := WorkArea
   ::ValueSource :=  valuesource

   if valtype( aImage ) == "A"
      ::AddBitMap( aImage )
   EndIf

	If DisplayChange == .T.
*      _OOHG_acontrolrangemin [k] := FindWindowEx( Controlhandle , 0, "Edit", Nil )
	EndIf

   If  ValType( WorkArea ) $ "CM"

		If Select ( WorkArea ) != 0

			BackRec := (WorkArea)->(RecNo())

			(WorkArea)->(DBGoTop())

			Do While ! (WorkArea)->(Eof())
				rcount++
	        		if value == (WorkArea)->(RecNo())
					cset := rcount
				EndIf
				ComboAddString (ControlHandle, (WorkArea)->&(cField) )
				(WorkArea)->(DBSkip())
			EndDo

			(WorkArea)->(DBGoTo(BackRec))

			ComboSetCurSel (ControlHandle,cset)

		EndIf

	Else

      AEval( rows, { |x| ComboAddString( ControlHandle, x ) } )

		if value <> 0
         ComboSetCurSel( ControlHandle, Value )
		endif

	EndIf

	if valtype ( ItemSource ) != 'U'
      aAdd( ::Parent:BrowseList, Self )
	EndIf

Return Self

*-----------------------------------------------------------------------------*
METHOD Refresh() CLASS TCombo
*-----------------------------------------------------------------------------*
Local BackRec , WorkArea , cField

   cField := ::Field

   WorkArea := ::WorkArea

	BackRec := (WorkArea)->(RecNo())

	(WorkArea)->(DBGoTop())

   ComboboxReset ( ::hWnd )

	Do While ! (WorkArea)->(Eof())
      ComboAddString ( ::hWnd, (WorkArea)->&(cField) )
		(WorkArea)->(DBSkip())
	EndDo

	(WorkArea)->(DBGoTo(BackRec))

Return nil

*-----------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TCombo
*-----------------------------------------------------------------------------*
Local WorkArea, BackRec, RCount, AuxVal
   IF VALTYPE( uValue ) == "N"

      If ValType ( ::WorkArea ) $ 'CM'
         ::nValue  := uValue
         WorkArea := ::WorkArea
		        rcount := 0
			BackRec := (WorkArea)->(RecNo())
			(WorkArea)->(DBGoTop())
			Do While ! (WorkArea)->(Eof())
				rcount++
               if uValue == (WorkArea)->(RecNo())
					Exit
				EndIf
				(WorkArea)->(DBSkip())
			EndDo
			(WorkArea)->(DBGoTo(BackRec))
         ComboSetCurSel( ::hWnd ,rcount)
		Else
         ComboSetCursel( ::hWnd , uValue )
		EndIf

   ELSEIF PCOUNT() > 0
*      MsgOOHGError('COMBOBOX: Value property wrong type (only numeric allowed). Program terminated')
   ENDIF

      If ValType ( ::WorkArea ) $ 'CM'

         auxval := ComboGetCursel ( ::hWnd )
			rcount := 0

         WorkArea := ::WorkArea

			BackRec := (WorkArea)->(RecNo())
			(WorkArea)->(DBGoTop())

			Do While ! (WorkArea)->(Eof())
				rcount++
            if rcount == auxval

               If Empty ( ::ValueSource )
                  uValue := (WorkArea)->(RecNo())
					Else
                  uValue := &( ::ValueSource )
					EndIf

				EndIf
				(WorkArea)->(DBSkip())
			EndDo

			(WorkArea)->(DBGoTo(BackRec))

		Else
         uValue := ComboGetCursel ( ::hWnd )
		EndIf

RETURN uValue

*-----------------------------------------------------------------------------*
METHOD Visible( lVisible ) CLASS TCombo
*-----------------------------------------------------------------------------*
   IF VALTYPE( lVisible ) == "L"
      ::Super:Visible := lVisible
      IF ! lVisible
         SendMessage( ::hWnd, 335 , 0 , 0 )
         HideWindow( ::hWnd )
      ENDIF
   ENDIF
RETURN ::Super:Visible

*-----------------------------------------------------------------------------*
METHOD RefreshData() CLASS TCombo
*-----------------------------------------------------------------------------*
   ::Refresh()
   ::Value := ::nValue
RETURN nil

*-----------------------------------------------------------------------------*
METHOD Events_Command( wParam ) CLASS TCombo
*-----------------------------------------------------------------------------*
Local Hi_wParam := HIWORD( wParam )

   if Hi_wParam == CBN_SELCHANGE

      ::DoEvent ( ::OnChange )

      Return nil

   elseif Hi_wParam == CBN_KILLFOCUS

      ::DoEvent( ::OnLostFocus )

      Return nil

   elseif Hi_wParam == CBN_SETFOCUS

      ::DoEvent( ::OnGotFocus )

      Return nil

   elseif Hi_wParam == CBN_EDITCHANGE

      ::DoEvent( ::OnClick )

      Return nil

   EndIf

Return ::Super:Events_Command( wParam )

*-----------------------------------------------------------------------------*
METHOD Item( nItem, uValue ) CLASS TCombo
*-----------------------------------------------------------------------------*
   IF VALTYPE( uValue ) $ "CMNA"
      ComboBoxDeleteString( ::hWnd, nItem )
      ComboInsertString( ::hWnd, uValue, nItem )
   ENDIF
RETURN ComboGetString( ::hWnd, nItem )