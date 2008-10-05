/*
 * $Id: h_controlmisc.prg,v 1.100 2008-10-05 15:37:27 guerra000 Exp $
 */
/*
 * ooHG source code:
 * Miscelaneous PRG controls functions
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

#include 'oohg.ch'
#include "hbclass.ch"
#include 'common.ch'
#include 'i_windefs.ch'

STATIC _OOHG_aControlhWnd := {}, _OOHG_aControlObjects := {}
STATIC _OOHG_aControlIds := {},  _OOHG_aControlNames := {}

STATIC _OOHG_lMultiple := .T.         // Allows the same applicaton runs more one instance at a time
STATIC _OOHG_lSettingFocus := .F.     // If there's a ::SetFocus() call inside ON ENTER event.

#pragma BEGINDUMP
#include "hbapi.h"
#include "hbapiitm.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windows.h>
#include <commctrl.h>
#include "oohg.h"
#pragma ENDDUMP

*-----------------------------------------------------------------------------*
Function _Getvalue( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Value

*-----------------------------------------------------------------------------*
Function _Setvalue( ControlName, ParentForm, Value )
*-----------------------------------------------------------------------------*
Return ( GetControlObject( ControlName, ParentForm ):Value := Value )

*-----------------------------------------------------------------------------*
Function _AddItem( ControlName, ParentForm, Value )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):AddItem( Value )

*-----------------------------------------------------------------------------*
Function _DeleteItem( ControlName, ParentForm, Value )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):DeleteItem( Value )

*-----------------------------------------------------------------------------*
Function _DeleteAllItems( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):DeleteAllItems()

*-----------------------------------------------------------------------------*
Function GetControlName( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Name

*-----------------------------------------------------------------------------*
Function GetControlHandle( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):hWnd

*-----------------------------------------------------------------------------*
Function GetControlContainerHandle( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Container:hWnd

*-----------------------------------------------------------------------------*
Function GetControlParentHandle( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):ContainerhWnd     // :Parent:hWnd

*-----------------------------------------------------------------------------*
Function GetControlId( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Id

*-----------------------------------------------------------------------------*
Function GetControlType( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Type

*-----------------------------------------------------------------------------*
Function GetControlValue( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Value

*-----------------------------------------------------------------------------*
Function _IsControlDefined( ControlName, FormName )
*-----------------------------------------------------------------------------*
Local mVar
   mVar := '_' + FormName + '_' + ControlName
Return ( Type( mVar ) == "O" .AND. ( &mVar ):hWnd != -1 )

*-----------------------------------------------------------------------------*
Function _SetFocus( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName , ParentForm ):SetFocus()

*-----------------------------------------------------------------------------*
Function _DisableControl( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Enabled := .F.

*-----------------------------------------------------------------------------*
Function _EnableControl( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Enabled := .T.

*-----------------------------------------------------------------------------*
Function _ShowControl( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Show()

*-----------------------------------------------------------------------------*
Function _HideControl( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Hide()

*-----------------------------------------------------------------------------*
Function _SetItem( ControlName, ParentForm, Item, Value )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Item( Item, Value )

*-----------------------------------------------------------------------------*
Function _GetItem( ControlName, ParentForm, Item )
*-----------------------------------------------------------------------------*
Return GetControlObject( Controlname, ParentForm ):Item( Item )

*-----------------------------------------------------------------------------*
Function _SetControlSizePos( ControlName, ParentForm, row, col, width, height )
*-----------------------------------------------------------------------------*
Return GetControlObject( Controlname, ParentForm ):SizePos( row, col, width, height )

*-----------------------------------------------------------------------------*
Function _GetItemCount( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( Controlname, ParentForm ):ItemCount

*-----------------------------------------------------------------------------*
Function _GetControlRow( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Row

*-----------------------------------------------------------------------------*
Function _GetControlCol( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Col

*-----------------------------------------------------------------------------*
Function _GetControlWidth( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Width

*-----------------------------------------------------------------------------*
Function _GetControlHeight( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Height

*-----------------------------------------------------------------------------*
Function _SetControlCol( ControlName, ParentForm, Value )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):SizePos( , Value )

*-----------------------------------------------------------------------------*
Function _SetControlRow( ControlName, ParentForm, Value )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):SizePos( Value )

*-----------------------------------------------------------------------------*
Function _SetControlWidth( ControlName, ParentForm, Value )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):SizePos( , , Value )

*-----------------------------------------------------------------------------*
Function _SetControlHeight( ControlName, ParentForm, Value )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):SizePos( , , , Value )

*-----------------------------------------------------------------------------*
Function _SetPicture( ControlName, ParentForm, FileName )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Picture := FileName

*-----------------------------------------------------------------------------*
Function _GetPicture( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Picture

*-----------------------------------------------------------------------------*
Function _GetControlAction( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):OnClick

*-----------------------------------------------------------------------------*
Function _GetToolTip( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):ToolTip

*-----------------------------------------------------------------------------*
Function _SetToolTip( ControlName, ParentForm, Value  )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):ToolTip := Value

*-----------------------------------------------------------------------------*
Function _SetRangeMin( ControlName, ParentForm, Value  )
*-----------------------------------------------------------------------------*
Return ( GetControlObject( ControlName, ParentForm ):RangeMin := Value )

*-----------------------------------------------------------------------------*
Function _SetRangeMax( ControlName, ParentForm, Value  )
*-----------------------------------------------------------------------------*
Return ( GetControlObject( ControlName, ParentForm ):RangeMax := Value )

*-----------------------------------------------------------------------------*
Function _GetRangeMin( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):RangeMin

*-----------------------------------------------------------------------------*
Function _GetRangeMax( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):RangeMax

*-----------------------------------------------------------------------------*
Function _SetMultiCaption( ControlName, ParentForm, Column, Value )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Caption( Column, Value )

*-----------------------------------------------------------------------------*
Function _GetMultiCaption( ControlName, ParentForm, Item )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Caption( Item )

*-----------------------------------------------------------------------------*
Function InputWindow( Title, aLabels, aValues, aFormats, row, col )
*-----------------------------------------------------------------------------*
Local i , l , ControlRow , e := 0 ,LN , CN ,r , c , wHeight , diff
Local oInputWindow, aResult

	l := Len ( aLabels )

   aResult := ARRAY( l )

	For i := 1 to l

		if ValType ( aValues[i] ) == 'C'

			if HB_IsNumeric ( aFormats[i] )

				If aFormats[i] > 32
					e++
				Endif

			EndIf

		EndIf

		if HB_IsMemo ( aValues[i] )
			e++
		EndIf

	Next i


	if pcount() == 4
		r := 0
		c := 0
	Else
		r := row
		c := col
		wHeight :=  (l*30) + 90 + (e*60)

		if r + wHeight > GetDeskTopHeight()

			diff :=  r + wHeight - GetDeskTopHeight()
			r := r - diff

		EndIf

	EndIf

   DEFINE WINDOW _InputWindow OBJ oInputWindow ;
		AT r,c ;
		WIDTH 280 ;
		HEIGHT (l*30) + 90 + (e*60) ;
		TITLE Title ;
		MODAL ;
		NOSIZE ;
      BACKCOLOR ( GetFormObjectByHandle( GetActiveWindow() ):BackColor )

		ControlRow :=  10

		For i := 1 to l

			LN := 'Label_' + Alltrim(Str(i,2,0))
			CN := 'Control_' + Alltrim(Str(i,2,0))

         @ ControlRow , 10 LABEL &LN OF _InputWindow VALUE aLabels [i] WIDTH 110 NOWORDWRAP

			do case
			case HB_IsLogical ( aValues [i] )

				@ ControlRow , 120 CHECKBOX &CN OF _InputWindow CAPTION '' VALUE aValues[i]
				ControlRow := ControlRow + 30

			case HB_IsDate ( aValues [i] )

				@ ControlRow , 120 DATEPICKER &CN  OF _InputWindow VALUE aValues[i] WIDTH 140
				ControlRow := ControlRow + 30

			case HB_IsNumeric ( aValues [i] )

				If HB_Isarray ( aFormats [i] )

					@ ControlRow , 120 COMBOBOX &CN  OF _InputWindow ITEMS aFormats[i] VALUE aValues[i] WIDTH 140  FONT 'Arial' SIZE 10
					ControlRow := ControlRow + 30

            ElseIf  ValType ( aFormats [i] ) $ 'CM'

					If AT ( '.' , aFormats [i] ) > 0
						@ ControlRow , 120 TEXTBOX &CN  OF _InputWindow VALUE aValues[i] WIDTH 140 FONT 'Arial' SIZE 10 NUMERIC INPUTMASK aFormats [i]
					Else
						@ ControlRow , 120 TEXTBOX &CN  OF _InputWindow VALUE aValues[i] WIDTH 140 FONT 'Arial' SIZE 10 MAXLENGTH Len(aFormats [i]) NUMERIC
					EndIf

					ControlRow := ControlRow + 30
				Endif

			case ValType ( aValues [i] ) == 'C'

				If HB_IsNumeric ( aFormats [i] )
					If  aFormats [i] <= 32
						@ ControlRow , 120 TEXTBOX &CN  OF _InputWindow VALUE aValues[i] WIDTH 140 FONT 'Arial' SIZE 10 MAXLENGTH aFormats [i]
						ControlRow := ControlRow + 30
					Else
						@ ControlRow , 120 EDITBOX &CN  OF _InputWindow WIDTH 140 HEIGHT 90 VALUE aValues[i] FONT 'Arial' SIZE 10 MAXLENGTH aFormats[i]
						ControlRow := ControlRow + 94
					EndIf
				EndIf

			case HB_IsMemo ( aValues [i] )

				@ ControlRow , 120 EDITBOX &CN  OF _InputWindow WIDTH 140 HEIGHT 90 VALUE aValues[i] FONT 'Arial' SIZE 10
				ControlRow := ControlRow + 94

			endcase

		Next i

		@ ControlRow + 10 , 30 BUTTON BUTTON_1 ;
		OF _InputWindow ;
      CAPTION _OOHG_Messages( 1, 6 ) ;
      ACTION _InputWindowOk( oInputWindow, aResult )

		@ ControlRow + 10 , 140 BUTTON BUTTON_2 ;
		OF _InputWindow ;
      CAPTION _OOHG_Messages( 1, 7 ) ;
      ACTION _InputWindowCancel( oInputWindow, aResult )

      oInputWindow:Control_1:SetFocus()

	END WINDOW

	if pcount() == 4
      oInputWindow:Center()
	EndIf

   oInputWindow:Activate()

Return ( aResult )

*-----------------------------------------------------------------------------*
Function _InputWindowOk( oInputWindow, aResult )
*-----------------------------------------------------------------------------*
Local i , l
   l := len( aResult )
   For i := 1 to l
      aResult[ i ] := oInputWindow:Control( 'Control_' + Alltrim( Str( i ) ) ):Value
	Next i
   oInputWindow:Release()
Return Nil

*-----------------------------------------------------------------------------*
Function _InputWindowCancel( oInputWindow, aResult )
*-----------------------------------------------------------------------------*
   afill( aResult, NIL )
   oInputWindow:Release()
Return Nil

*-----------------------------------------------------------------------------*
Function _ReleaseControl( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Release()

*-----------------------------------------------------------------------------*
Function _IsControlVisibleFromHandle( Handle )
*-----------------------------------------------------------------------------*
Return GetControlObjectByHandle( Handle ):ContainerVisible

*-----------------------------------------------------------------------------*
Function _SetCaretPos( ControlName, FormName, Pos )
*-----------------------------------------------------------------------------*
Return ( GetControlObject( ControlName, FormName ):CaretPos := Pos )

*-----------------------------------------------------------------------------*
Function _GetCaretPos( ControlName, FormName )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, FormName ):CaretPos

*------------------------------------------------------------------------------*
FUNCTION Random( nLimit )
*------------------------------------------------------------------------------*
  DEFAULT nLimit   TO 65535
Return hb_random( nLimit )

*------------------------------------------------------------------------------*
Function SetProperty( Arg1, Arg2, Arg3, Arg4, Arg5, Arg6 )
*------------------------------------------------------------------------------*
Local oWnd, oCtrl

	if Pcount() == 3 // Window

      oWnd := GetExistingFormObject( Arg1 )
      Arg2 := Upper( Arg2 )

      If Arg2 == "TITLE"
         oWnd:Title := Arg3

      ELseIf Arg2 == "HEIGHT"
         oWnd:Height := Arg3

      ElseIf Arg2 == "WIDTH"
         oWnd:Width := Arg3

      ElseIf Arg2 == "COL"
         oWnd:Col := Arg3

      ElseIf Arg2 == "ROW"
         oWnd:Row := Arg3

      ElseIf Arg2 == "NOTIFYICON"
         oWnd:NotifyIcon := Arg3

      ElseIf Arg2 == "NOTIFYTOOLTIP"
         oWnd:NotifyTooltip := Arg3

      ElseIf Arg2 == "BACKCOLOR"
         oWnd:BackColor := Arg3

      ElseIf Arg2 == "CURSOR"
         oWnd:Cursor := Arg3

		EndIf

	ElseIf Pcount() == 4 // CONTROL

      oCtrl := GetExistingControlObject( Arg2, Arg1 )
      Arg3 := Upper( Arg3 )

      If     Arg3 == "VALUE"
         oCtrl:Value := Arg4

      ElseIf Arg3 == "ALLOWEDIT"
         oCtrl:AllowEdit := Arg4

      ElseIf Arg3 == "ALLOWAPPEND"
         oCtrl:AllowAppend := Arg4

      ElseIf Arg3 == "ALLOWDELETE"
         oCtrl:AllowDelete := Arg4

      ElseIf Arg3 == "PICTURE"
         oCtrl:Picture := Arg4

      ElseIf Arg3 == "TOOLTIP"
         oCtrl:Tooltip := Arg4

      ElseIf Arg3 == "FONTNAME"
         oCtrl:SetFont( Arg4 )

      ElseIf Arg3 == "FONTSIZE"
         oCtrl:SetFont( , Arg4 )

      ElseIf Arg3 == "FONTBOLD"
         oCtrl:SetFont( , , Arg4 )

      ElseIf Arg3 == "FONTITALIC"
         oCtrl:SetFont( , , , Arg4 )

      ElseIf Arg3 == "FONTUNDERLINE"
         oCtrl:SetFont( , , , , Arg4 )

      ElseIf Arg3 == "FONTSTRIKEOUT"
         oCtrl:SetFont( , , , , , Arg4 )

      ElseIf Arg3 == "CAPTION"
         oCtrl:Caption := Arg4

      ElseIf Arg3 == "DISPLAYVALUE"
         oCtrl:Caption := Arg4

      ElseIf Arg3 == "ROW"
         oCtrl:Row := Arg4

      ElseIf Arg3 == "COL"
         oCtrl:Col := Arg4

      ElseIf Arg3 == "WIDTH"
         oCtrl:Width := Arg4

      ElseIf Arg3 == "HEIGHT"
         oCtrl:Height := Arg4

      ElseIf Arg3 == "VISIBLE"
         oCtrl:Visible := Arg4

      ElseIf Arg3 == "ENABLED"
         oCtrl:Enabled := Arg4

      ElseIf Arg3 == "CHECKED"
         oCtrl:Checked := Arg4

      ElseIf Arg3 == "RANGEMIN"
         oCtrl:RangeMin := Arg4

      ElseIf Arg3 == "RANGEMAX"
         oCtrl:RangeMax := Arg4

      ElseIf Arg3 == "REPEAT"
			If Arg4 == .t.
            oCtrl:RepeatOn()
			Else
            oCtrl:RepeatOff()
			EndIf

      ElseIf Arg3 == "SPEED"
         oCtrl:Speed( Arg4 )

      ElseIf Arg3 == "VOLUME"
         oCtrl:Volume( Arg4 )

      ElseIf Arg3 == "ZOOM"
         oCtrl:Zoom( Arg4 )

      ElseIf Arg3 == "POSITION"
			If Arg4 == 0
            oCtrl:PositionHome()
			ElseIf Arg4 == 1
            oCtrl:PositionEnd()
			EndIf

      ElseIf Arg3 == "CARETPOS"
         oCtrl:CaretPos := Arg4

      ElseIf Arg3 == "BACKCOLOR"
         oCtrl:BackColor := Arg4

      ElseIf Arg3 == "FONTCOLOR"
         oCtrl:FontColor := Arg4

      ElseIf Arg3 == "FORECOLOR"
         oCtrl:FontColor := Arg4

      ElseIf Arg3 == "ADDRESS"
         oCtrl:Address := Arg4

      ElseIf Arg3 == "READONLY"
         oCtrl:ReadOnly := Arg4

      ElseIf Arg3 == "ITEMCOUNT"
         ListView_SetItemCount( oCtrl:hWnd, Arg4 )

		EndIf

	ElseIf Pcount() == 5 // CONTROL (WITH ARGUMENT OR TOOLBAR BUTTON)

      oCtrl := GetExistingControlObject( Arg2, Arg1 )
      Arg3 := Upper( Arg3 )

      If     Arg3 == "CAPTION"
         oCtrl:Caption( Arg4, Arg5 )

      ElseIf Arg3 == "HEADER"
         oCtrl:header( Arg4, Arg5 )   ////20071011 Ciro /////en vez de oCtrl:Caption()

      ElseIf Arg3 == "ITEM"
         oCtrl:Item( Arg4, Arg5 )

      ElseIf Arg3 == "ICON"
         _SetStatusIcon( Arg2, Arg1, Arg4, Arg5 )

      ElseIf Arg3 == "COLUMNWIDTH"
         oCtrl:ColumnWidth( Arg4, Arg5 )

      ElseIf Arg3 == "PICTURE"
         oCtrl:Picture( Arg4, Arg5 )

      ElseIf Arg3 == "IMAGE"
         oCtrl:Picture( Arg4, Arg5 )

		Else
			// If Property Not Matched Look For ToolBar Button

         If oCtrl:Type == "TOOLBAR"

            If oCtrl:hWnd != GetControlObject( Arg3 , Arg1 ):Container:hWnd
               MsgOOHGError('Control Does Not Belong To Container')
				EndIf

            SetProperty( Arg1, Arg3, Arg4, Arg5 )
			EndIf

		EndIf

   ElseIf Pcount() == 6 // CONTROL (WITH 2 ARGUMENTS)

      oCtrl := GetExistingControlObject( Arg2, Arg1 )
      Arg3 := Upper( Arg3 )

      If     Arg3 == "CELL"
         oCtrl:Cell( Arg4 , Arg5 , Arg6 )

      Else
         SetProperty( Arg1, Arg4, Arg5, Arg6 )

      EndIf

	EndIf

Return Nil

*------------------------------------------------------------------------------*
Function GetProperty( Arg1, Arg2, Arg3, Arg4, Arg5 )
*------------------------------------------------------------------------------*
Local RetVal, oWnd, oCtrl

	if Pcount() == 2 // WINDOW

      oWnd := GetExistingFormObject( Arg1 )
      Arg2 := Upper( Arg2 )

		if Arg2 == 'TITLE'
         RetVal := oWnd:Title

		ELseIf Arg2 == 'FOCUSEDCONTROL'
         RetVal := oWnd:FocusedControl()

		ELseIf Arg2 == 'NAME'
         RetVal := oWnd:Name

		ELseIf Arg2 == 'HEIGHT'
         RetVal := oWnd:Height

		ElseIf Arg2 == 'WIDTH'
         RetVal := oWnd:Width

		ElseIf Arg2 == 'COL'
         RetVal := oWnd:Col

		ElseIf Arg2 == 'ROW'
         RetVal := oWnd:Row

      ElseIf Arg2 == "NOTIFYICON"
         RetVal := oWnd:NotifyIcon

      ElseIf Arg2 == "NOTIFYTOOLTIP"
         RetVal := oWnd:NotifyTooltip

      ElseIf Arg2 == "BACKCOLOR"
         RetVal := oWnd:BackColor

      ElseIf Arg2 == "HWND"
         RetVal := oWnd:hWnd

      ElseIf Arg2 == "OBJECT"
         RetVal := oWnd

		EndIf

	ElseIf Pcount() == 3 // CONTROL

      oCtrl := GetExistingControlObject( Arg2, Arg1 )
      Arg3 := Upper( Arg3 )

		If     Arg3 == 'VALUE'
         RetVal := oCtrl:Value

		ElseIf Arg3 == 'NAME'
         RetVal := oCtrl:Name

      ElseIf Arg3 == 'ALLOWEDIT'
         RetVal := oCtrl:AllowEdit

		ElseIf Arg3 == 'ALLOWAPPEND'
         RetVal := oCtrl:AllowAppend

		ElseIf Arg3 == 'ALLOWDELETE'
         RetVal := oCtrl:AllowDelete

		ElseIf Arg3 == 'PICTURE'
         RetVal := oCtrl:Picture

		ElseIf Arg3 == 'TOOLTIP'
         RetVal := oCtrl:Tooltip

		ElseIf Arg3 == 'FONTNAME'
         RetVal := oCtrl:cFontName

		ElseIf Arg3 == 'FONTSIZE'
         RetVal := oCtrl:nFontSize

		ElseIf Arg3 == 'FONTBOLD'
         RetVal := oCtrl:Bold

		ElseIf Arg3 == 'FONTITALIC'
         RetVal := oCtrl:Italic

		ElseIf Arg3 == 'FONTUNDERLINE'
         RetVal := oCtrl:Underline

		ElseIf Arg3 == 'FONTSTRIKEOUT'
         RetVal := oCtrl:Strikeout

		ElseIf Arg3 == 'CAPTION'
         RetVal := oCtrl:Caption

		ElseIf Arg3 == 'DISPLAYVALUE'
         RetVal := GetWindowText( oCtrl:hWnd )

		ElseIf Arg3 == 'ROW'
         RetVal := oCtrl:Row

		ElseIf Arg3 == 'COL'
         RetVal := oCtrl:Col

		ElseIf Arg3 == 'WIDTH'
         RetVal := oCtrl:Width

		ElseIf Arg3 == 'HEIGHT'
         RetVal := oCtrl:Height

		ElseIf Arg3 == 'VISIBLE'
         RetVal := oCtrl:Visible

		ElseIf Arg3 == 'ENABLED'
         RetVal := oCtrl:Enabled

		ElseIf Arg3 == 'CHECKED'
         RetVal := oCtrl:Checked

		ElseIf Arg3 == 'ITEMCOUNT'
         RetVal := oCtrl:ItemCount()

		ElseIf Arg3 == 'RANGEMIN'
         RetVal := oCtrl:RangeMin

		ElseIf Arg3 == 'RANGEMAX'
         RetVal := oCtrl:RangeMax

		ElseIf Arg3 == 'LENGTH'
         RetVal := oCtrl:Length

		ElseIf Arg3 == 'POSITION'
         RetVal := oCtrl:Position

		ElseIf Arg3 == 'CARETPOS'
         RetVal := oCtrl:CaretPos

		ElseIf Arg3 == 'BACKCOLOR'
         RetVal := oCtrl:BackColor

		ElseIf Arg3 == 'FONTCOLOR'
         RetVal := oCtrl:FontColor

		ElseIf Arg3 == 'FORECOLOR'
         RetVal := oCtrl:BackColor

		ElseIf Arg3 == 'ADDRESS'
         RetVal := oCtrl:Address

      ElseIf Arg3 == "HWND"
         RetVal := oCtrl:hWnd

      ElseIf Arg3 == "OBJECT"
         RetVal := oCtrl

		EndIf

	ElseIf Pcount() == 4 // CONTROL (WITH ARGUMENT OR TOOLBAR BUTTON)

      oCtrl := GetExistingControlObject( Arg2, Arg1 )
      Arg3 := Upper( Arg3 )

      If     Arg3 == "ITEM"
         RetVal := oCtrl:Item( Arg4 )

      ElseIf Arg3 == "CAPTION"
         RetVal := oCtrl:Caption( Arg4 )

      ElseIf Arg3 == "HEADER"
         RetVal := oCtrl:Caption( Arg4 )

      ElseIf Arg3 == "COLUMNWIDTH"
         RetVal := oCtrl:ColumnWidth( Arg4 )

      ElseIf Arg3 == "PICTURE"
         oCtrl:Picture( Arg4 )

      ElseIf Arg3 == "IMAGE"
         oCtrl:Picture( Arg4 )

		Else

			// If Property Not Matched Look For Contained Control
			// With No Arguments (ToolBar Button)

         If oCtrl:Type == "TOOLBAR"

            If oCtrl:hWnd != GetControlObject( Arg3 , Arg1 ):Container:hWnd
               MsgOOHGError('Control Does Not Belong To Container')
				EndIf

            RetVal := GetProperty( Arg1 , Arg3 , Arg4 )

			EndIf

		EndIf

   ElseIf Pcount() == 5 // CONTROL (WITH 2 ARGUMENTS)

      oCtrl := GetExistingControlObject( Arg2, Arg1 )
      Arg3 := Upper( Arg3 )

      If     Arg3 == "CELL"
         RetVal := oCtrl:Cell( Arg4 , Arg5 )

      EndIf

	EndIf

Return RetVal

*------------------------------------------------------------------------------*
Function DoMethod( Arg1 , Arg2 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 )
*------------------------------------------------------------------------------*
Local oWnd, oCtrl

	if Pcount() == 2 // Window

      oWnd := GetExistingFormObject( Arg1 )
      Arg2 := Upper( Arg2 )

		if Arg2 == 'ACTIVATE'
         if HB_IsArray( Arg1 )
            _ActivateWindow( Arg1 )
			Else
            oWnd:Activate()
			EndIf

		ELseIf Arg2 == 'CENTER'
         oWnd:Center()

		ElseIf Arg2 == 'RELEASE'
         oWnd:Release()

		ElseIf Arg2 == 'MAXIMIZE'
         oWnd:Maximize()

		ElseIf Arg2 == 'MINIMIZE'
         oWnd:Minimize()

		ElseIf Arg2 == 'RESTORE'
         oWnd:Restore()

		ElseIf Arg2 == 'SHOW'
         oWnd:Show()

		ElseIf Arg2 == 'PRINT'
         oWnd:Print()

		ElseIf Arg2 == 'HIDE'
         oWnd:Hide()

		ElseIf Arg2 == 'SETFOCUS'
         If oWnd:Active
            oWnd:SetFocus()
         EndIf

		EndIf

	ElseIf Pcount() == 3 // CONTROL

      oCtrl := GetExistingControlObject( Arg2, Arg1 )
      Arg3 := Upper( Arg3 )

		If     Arg3 == 'REFRESH'
         oCtrl:Refresh()

		ElseIf Arg3 == 'SAVE'
         oCtrl:SaveData()

		ElseIf Arg3 == 'SETFOCUS'
         oCtrl:SetFocus()

		ElseIf Arg3 == 'ACTION'
         oCtrl:DoEvent( oCtrl:OnClick, "CLICK" )

		ElseIf Arg3 == 'ONCLICK'
         oCtrl:DoEvent( oCtrl:OnClick, "CLICK" )

      ElseIf Arg3 == 'COLUMNSAUTOFIT'
         oCtrl:ColumnsAutoFit()

      ElseIf Arg3 == 'COLUMNSAUTOFITH'
         oCtrl:ColumnsAutoFitH()

		ElseIf Arg3 == 'DELETEALLITEMS'
         oCtrl:DeleteAllItems()

		ElseIf Arg3 == 'RELEASE'
         oCtrl:Release()

		ElseIf Arg3 == 'SHOW'
         oCtrl:Show()

		ElseIf Arg3 == 'HIDE'
         oCtrl:Hide()

		ElseIf Arg3 == 'PLAY'
         oCtrl:Play()

		ElseIf Arg3 == 'STOP'
         oCtrl:Stop()

		ElseIf Arg3 == 'CLOSE'
         oCtrl:Close()

		ElseIf Arg3 == 'PLAYREVERSE'
         oCtrl:PlayReverse()

		ElseIf Arg3 == 'PAUSE'
         oCtrl:Pause()

		ElseIf Arg3 == 'EJECT'
         oCtrl:Eject()

		ElseIf Arg3 == 'OPENDIALOG'
         oCtrl:OpenDialog()

		ElseIf Arg3 == 'RESUME'
         oCtrl:Resume()

		EndIf

	ElseIf Pcount() == 4 // CONTROL (WITH 1 ARGUMENT)

      oCtrl := GetExistingControlObject( Arg2, Arg1 )
      Arg3 := Upper( Arg3 )

		If     Arg3 == 'DELETEITEM'
         oCtrl:DeleteItem( Arg4 )

		ElseIf Arg3 == 'DELETEPAGE'
         oCtrl:DeletePage( Arg4 )

		ElseIf Arg3 == 'OPEN'
         oCtrl:Open( Arg4 )

		ElseIf Arg3 == 'SEEK'
         oCtrl:Seek( Arg4 )

		ElseIf Arg3 == 'ADDITEM'
         oCtrl:AddItem( Arg4 )

		ElseIf Arg3 == 'EXPAND'
         oCtrl:Expand( Arg4 )

		ElseIf Arg3 == 'COLLAPSE'
         oCtrl:Collapse( Arg4 )

		ElseIf Arg3 == 'DELETECOLUMN'
         oCtrl:DeleteColumn( Arg4 )

      ElseIf Arg3 == 'COLUMNAUTOFIT'
         oCtrl:ColumnAutoFit( Arg4 )

      ElseIf Arg3 == 'COLUMNAUTOFITH'
         oCtrl:ColumnAutoFitH( Arg4 )

		EndIf

   ElseIf Pcount() == 5 // CONTROL (WITH 2 ARGUMENTS)

      oCtrl := GetExistingControlObject( Arg2, Arg1 )
      Arg3 := Upper( Arg3 )

		If     Arg3 == 'ADDITEM'
         oCtrl:AddItem( Arg4 , Arg5 )

		ElseIf Arg3 == 'ADDPAGE'
         oCtrl:AddPage( Arg4 , Arg5 )

		EndIf

   ElseIf Pcount() == 6 // CONTROL (WITH 3 ARGUMENTS)

      oCtrl := GetExistingControlObject( Arg2, Arg1 )
      Arg3 := Upper( Arg3 )

		If     Arg3 == 'ADDITEM'
         oCtrl:AddItem( Arg4 , Arg5 , Arg6 )

		ElseIf Arg3 == 'ADDPAGE'
         oCtrl:AddPage( Arg4 , Arg5 , Arg6 )

		EndIf

   ElseIf Pcount() == 7 // CONTROL (WITH 4 ARGUMENTS)

      oCtrl := GetExistingControlObject( Arg2, Arg1 )
      Arg3 := Upper( Arg3 )

		If     Arg3 == 'ADDCONTROL'
         oCtrl:AddControl( GetControlObject( Arg4, Arg1 ), Arg5 , Arg6 , Arg7 )

		ElseIf     Arg3 == 'ADDCOLUMN'
         oCtrl:AddColumn( Arg4 , Arg5 , Arg6 , Arg7 )

		ElseIf     Arg3 == 'ADDITEM'
         oCtrl:AddItem( Arg4 , Arg5 , Arg6 , Arg7 )

		EndIf

	EndIf

Return Nil

Function _dummy()
return nil

*--------------------------------------------------------*
Function cFileNoPath( cPathMask )
*--------------------------------------------------------*
local n := RAt( "\", cPathMask )
Return If( n > 0 .and. n < Len( cPathMask ), ;
	Right( cPathMask, Len( cPathMask ) - n ), ;
	If( ( n := At( ":", cPathMask ) ) > 0, ;
	Right( cPathMask, Len( cPathMask ) - n ), cPathMask ) )

*--------------------------------------------------------*
Function cFileNoExt( cPathMask )
*--------------------------------------------------------*
local cName := AllTrim( cFileNoPath( cPathMask ) )
local n     := At( ".", cName )
Return AllTrim( If( n > 0, Left( cName, n - 1 ), cName ) )

*-----------------------------------------------------------------------------*
Function NoArray (OldArray)
*-----------------------------------------------------------------------------*
Local NewArray := {}
Local i

	If ValType ( OldArray ) == 'U'
		Return Nil
	ELse
		Asize ( NewArray , Len (OldArray) )
	EndIf

	For i := 1 To Len ( OldArray )

		If OldArray [i] == .t.
			NewArray [i] := .f.
		Else
			NewArray [i] := .t.
		EndIf

	Next i

Return NewArray

*-----------------------------------------------------------------------------*
Function _SetFontColor ( ControlName, ParentForm , Value  )
*-----------------------------------------------------------------------------*
Return ( GetControlObject( ControlName, ParentForm ):FontColor := Value )

*-----------------------------------------------------------------------------*
Function _SetBackColor ( ControlName, ParentForm , Value  )
*-----------------------------------------------------------------------------*
Return ( GetControlObject( ControlName, ParentForm ):BackColor := Value )

*-----------------------------------------------------------------------------*
Function _SetStatusIcon( ControlName , ParentForm , Item , Icon )
*-----------------------------------------------------------------------------*
Return SetStatusItemIcon( GetControlObject( ControlName, ParentForm ):hWnd, Item , Icon )

*-----------------------------------------------------------------------------*
Function _GetCaption( ControlName , ParentForm )
*-----------------------------------------------------------------------------*
Return GetWindowText( GetControlObject( ControlName, ParentForm ):hWnd )





*------------------------------------------------------------------------------*
CLASS TControl FROM TWindow
*------------------------------------------------------------------------------*
   DATA cToolTip    INIT ""
   DATA AuxHandle   INIT 0
   DATA Transparent INIT .F.
   DATA HelpId      INIT 0
   DATA OnChange    INIT nil
   DATA Id          INIT 0
   DATA ImageListColor      INIT CLR_NONE
   DATA ImageListFlags      INIT LR_LOADTRANSPARENT
   DATA SetImageListCommand INIT 0   // Must be explicit for each control
   DATA SetImageListWParam  INIT TVSIL_NORMAL
   DATA hCursor     INIT 0
   DATA postBlock   INIT nil
   DATA lCancel     INIT .F.
   DATA OnEnter     INIT nil

   METHOD Row       SETGET
   METHOD Col       SETGET
   METHOD Width     SETGET
   METHOD Height    SETGET
   METHOD ToolTip   SETGET
   METHOD SetForm
   METHOD InitStyle
   METHOD Register
   METHOD Refresh             BLOCK { || nil }
   METHOD Release
   METHOD SetFont
   METHOD ContainerRow        BLOCK { |Self| IF( ::Container != NIL, IF( ValidHandler( ::Container:ContainerhWndValue ), 0, ::Container:ContainerRow ) + ::Container:RowMargin, ::Parent:RowMargin ) + ::Row }
   METHOD ContainerCol        BLOCK { |Self| IF( ::Container != NIL, IF( ValidHandler( ::Container:ContainerhWndValue ), 0, ::Container:ContainerCol ) + ::Container:ColMargin, ::Parent:ColMargin ) + ::Col }
   METHOD ContainerhWnd       BLOCK { |Self| IF( ::Container == NIL, ::Parent:hWnd, if( ValidHandler( ::Container:ContainerhWndValue ), ::Container:ContainerhWndValue, ::Container:ContainerhWnd ) ) }
   METHOD FontName            SETGET
   METHOD FontSize            SETGET
   METHOD FontBold            SETGET
   METHOD FontItalic          SETGET
   METHOD FontUnderline       SETGET
   METHOD FontStrikeout       SETGET
   METHOD SizePos
   METHOD Move
   METHOD SetFocus            BLOCK { |Self| _OOHG_lSettingFocus := .T., GetFormObjectByHandle( ::ContainerhWnd ):LastFocusedControl := ::hWnd, ::Super:SetFocus() }
   METHOD SetVarBlock
   METHOD AddBitMap

   METHOD DoEvent
   METHOD DoLostFocus

   METHOD Events
   METHOD Events_Color
   METHOD Events_Enter
   METHOD Events_Command
   METHOD Events_Notify
   METHOD Events_DrawItem     BLOCK { || nil }
   METHOD Events_MeasureItem  BLOCK { || nil }
ENDCLASS

*------------------------------------------------------------------------------*
METHOD Row( nRow ) CLASS TControl
*------------------------------------------------------------------------------*
   IF PCOUNT() > 0
      ::SizePos( nRow )
   ENDIF
RETURN ::nRow

*------------------------------------------------------------------------------*
METHOD Col( nCol ) CLASS TControl
*------------------------------------------------------------------------------*
   IF PCOUNT() > 0
      ::SizePos( , nCol )
   ENDIF
RETURN ::nCol

*------------------------------------------------------------------------------*
METHOD Width( nWidth ) CLASS TControl
*------------------------------------------------------------------------------*
   IF PCOUNT() > 0
      ::SizePos( , , nWidth )
   ENDIF
RETURN ::nWidth

*------------------------------------------------------------------------------*
METHOD Height( nHeight ) CLASS TControl
*------------------------------------------------------------------------------*
   IF PCOUNT() > 0
      ::SizePos( , , , nHeight )
   ENDIF
RETURN ::nHeight

*------------------------------------------------------------------------------*
METHOD ToolTip( cToolTip ) CLASS TControl
*------------------------------------------------------------------------------*
   IF PCOUNT() > 0
      IF valtype( cToolTip ) $ "CM"
         ::cToolTip := cToolTip
      ELSE
         ::cToolTip := ""
      ENDIF
      If HB_IsObject( ::Parent:oToolTip )
         ::Parent:oToolTip:Item( ::hWnd, cToolTip )
      EndIf
   ENDIF
RETURN ::cToolTip

FUNCTION _OOHG_GetNullName( cName )
STATIC nCtrl := 0
   cName := IF( VALTYPE( cName ) $ "CM", UPPER( ALLTRIM( cName ) ), "0" )
   IF EMPTY( cName ) .OR. cName == "0" .OR. cName == "NONAME" .OR. cName == "NIL" .OR. cName == "NULL" .OR. cName == "NONE"
      // TODO: Verify this name doesn't exists
      cName := "NULL" + STRZERO( nCtrl, 10 )
      nCtrl++
      IF nCtrl > 9999999999
          nCtrl := 0
      ENDIF
   ENDIF
RETURN cName

*------------------------------------------------------------------------------*
METHOD SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BkColor, lEditBox, lRtl ) CLASS TControl
*------------------------------------------------------------------------------*

   ::StartInfo( -1 )
   ::SearchParent( ParentForm )

   ::ParentDefaults( FontName, FontSize, FontColor )

   IF HB_IsLogical( lEditBox ) .AND. lEditBox
      // Background Color (edit or listbox):
      if ValType( BkColor ) $ "ANCM"
         // Specified color
         ::BackColor := BkColor
      ElseIf ValType( ::BackColor ) $ "ANCM"
         // Pre-registered
      elseif ::Container != nil
         // Active frame
         ::BackColor := ::Container:DefBkColorEdit
      elseif ValType( ::Parent:DefBkColorEdit ) $ "ANCM"
         // Active form
         ::BackColor := ::Parent:DefBkColorEdit
      else
          // Default
      endif
   ELSE
      // Background Color (static):
      if ValType( BkColor ) $ "ANCM"
         // Specified color
         ::BackColor := BkColor
      ElseIf ValType( ::BackColor ) $ "ANCM"
         // Pre-registered
      elseif ::Container != nil
         // Active frame
         ::BackColor := ::Container:BackColor
      elseif ValType( ::Parent:BackColor ) $ "ANCM"
         // Active form
         ::BackColor := ::Parent:BackColor
      else
          // Default
      endif
   ENDIF

   ::Name := _OOHG_GetNullName( ControlName )

   If _IsControlDefined( ::Name, ::Parent:Name )
      MsgOOHGError( _OOHG_Messages( 3, 4 ) + ::Name + _OOHG_Messages( 3, 5 ) + ::Parent:Name + _OOHG_Messages( 3, 6 ) )
	endif

   // Right-to-left
   If _OOHG_GlobalRTL()
      ::lRtl := .T.
   ElseIf HB_IsLogical( lRtl )
      ::lRtl := lRtl
   ElseIf ! Empty( ::Container )
      ::lRtl := ::Container:lRtl
   ElseIf ! Empty( ::Parent )
      ::lRtl := ::Parent:lRtl
   Else
      ::lRtl := .F.
   EndIf

RETURN Self

*------------------------------------------------------------------------------*
METHOD InitStyle( nStyle, nStyleEx, lInvisible, lNoTabStop, lDisabled ) CLASS TControl
*------------------------------------------------------------------------------*
   If !HB_IsNumeric( nStyle )
      nStyle := 0
   EndIf
   If !HB_IsNumeric( nStyleEx )
      nStyleEx := 0
   EndIf

   If HB_IsLogical( lInvisible )
      ::lVisible := ! lInvisible
   EndIf
   If ::ContainerVisible
      nStyle += WS_VISIBLE
   EndIf

   If !HB_IsLogical( lNoTabStop ) .OR. ! lNoTabStop
      nStyle += WS_TABSTOP
   EndIf

   If HB_IsLogical( lDisabled )
      ::lEnabled := ! lDisabled
   EndIf
   If ! ::ContainerEnabled
      nStyle += WS_DISABLED
   EndIf

Return nStyle

*------------------------------------------------------------------------------*
METHOD Register( hWnd, cName, HelpId, Visible, ToolTip, Id ) CLASS TControl
*------------------------------------------------------------------------------*
Local mVar

   // cName NO debe recibirse!!! Ya debe estar desde :SetForm()!!!!
*   ::Name   := _OOHG_GetNullName( ControlName )
EMPTY(cName)

   ::hWnd := hWnd
   ::SethWnd( hWnd )
   ::Active := .T.


   ::Parent:AddControl( Self )


   IF ::Container != nil
      ::Container:AddControl( Self )
   ENDIF

   IF HB_IsNumeric( HelpId )
      ::HelpId := HelpId
   ENDIF

   IF HB_IsLogical( Visible )
      ::Visible := Visible
   ENDIF

   ::ToolTip := ToolTip

   If HB_IsNumeric( Id )
      ::Id := Id
   Else
      ::Id := GetDlgCtrlId( ::hWnd )
   EndIf

   AADD( _OOHG_aControlhWnd,    hWnd )
   AADD( _OOHG_aControlObjects, Self )
   AADD( _OOHG_aControlIds,     { ::Id, ::Parent:hWnd } ) // ::Id )
   AADD( _OOHG_aControlNames,   UPPER( ::Parent:Name + CHR( 255 ) + ::Name ) )

   mVar := "_" + ::Parent:Name + "_" + ::Name
   Public &mVar. := Self
RETURN Self

*-----------------------------------------------------------------------------*
METHOD Release() CLASS TControl
*-----------------------------------------------------------------------------*
Local mVar

   // Erases events (for avoid wrong re-usage)
   ::OnClick        := nil
   ::OnGotFocus     := nil
   ::OnLostFocus    := nil
   ::OnMouseDrag    := nil
   ::OnMouseMove    := nil
   ::OnChange       := nil
   ::OnDblClick     := nil
   ::OnRClick       := nil
   ::OnMClick       := nil
   ::OnRDblClick    := nil
   ::OnMDblClick    := nil
   ::OnEnter        := nil

   ::ReleaseAttached()

   // Removes from container
   IF ::Container != nil
      ::Container:DeleteControl( Self )
   ENDIF

   // Delete it from arrays
   mVar := aScan( _OOHG_aControlNames, { |c| c == UPPER( ::Parent:Name + CHR( 255 ) + ::Name ) } )
   IF mVar > 0
      _OOHG_DeleteArrayItem( _OOHG_aControlhWnd,    mVar )
      _OOHG_DeleteArrayItem( _OOHG_aControlObjects, mVar )
      _OOHG_DeleteArrayItem( _OOHG_aControlIds,     mVar )
      _OOHG_DeleteArrayItem( _OOHG_aControlNames,   mVar )
   ENDIF

   ::Parent:DeleteControl( Self )

   If ValidHandler( ::hWnd )
      ReleaseControl( ::hWnd )
   EndIf

   DeleteObject( ::FontHandle )
   DeleteObject( ::AuxHandle )

   mVar := '_' + ::Parent:Name + '_' + ::Name
	if type ( mVar ) != 'U'
      __MVPUT( mVar , 0 )
	EndIf

Return ::Super:Release()

*-----------------------------------------------------------------------------*
METHOD SetFont( FontName, FontSize, Bold, Italic, Underline, Strikeout ) CLASS TControl
*-----------------------------------------------------------------------------*
   IF ::FontHandle > 0
      DeleteObject( ::FontHandle )
   ENDIF
   IF ! EMPTY( FontName ) .AND. VALTYPE( FontName ) $ "CM"
      ::cFontName := FontName
   ENDIF
   IF ! EMPTY( FontSize ) .AND. HB_IsNumeric( FontSize )
      ::nFontSize := FontSize
   ENDIF
   IF HB_Islogical( Bold )
      ::Bold := Bold
   ENDIF
   IF HB_IsLogical( Italic )
      ::Italic := Italic
   ENDIF
   IF HB_IsLogical( Underline )
      ::Underline := Underline
   ENDIF
   IF HB_IsLogical( Strikeout )
      ::Strikeout := Strikeout
   ENDIF
   ::FontHandle := _SetFont( ::hWnd, ::cFontName, ::nFontSize, ::Bold, ::Italic, ::Underline, ::Strikeout )
Return Nil

*-----------------------------------------------------------------------------*
METHOD FontName( cFontName ) CLASS TControl
*-----------------------------------------------------------------------------*
   If ValType( cFontName ) $ "CM"
      ::SetFont( cFontName )
   EndIf
Return ::cFontName

*-----------------------------------------------------------------------------*
METHOD FontSize( nFontSize ) CLASS TControl
*-----------------------------------------------------------------------------*
   If HB_IsNumeric( nFontSize )
      ::SetFont( , nFontSize )
   EndIf
Return ::nFontSize

*-----------------------------------------------------------------------------*
METHOD FontBold( lBold ) CLASS TControl
*-----------------------------------------------------------------------------*
   If HB_IsLogical( lBold )
      ::SetFont( ,, lBold )
   EndIf
Return ::Bold

*-----------------------------------------------------------------------------*
METHOD FontItalic( lItalic ) CLASS TControl
*-----------------------------------------------------------------------------*
   If HB_IsLogical( lItalic )
      ::SetFont( ,,, lItalic )
   EndIf
Return ::Italic

*-----------------------------------------------------------------------------*
METHOD FontUnderline( lUnderline ) CLASS TControl
*-----------------------------------------------------------------------------*
   If HB_IsLogical( lUnderline )
      ::SetFont( ,,,, lUnderline )
   EndIf
Return ::Underline

*-----------------------------------------------------------------------------*
METHOD FontStrikeout( lStrikeout ) CLASS TControl
*-----------------------------------------------------------------------------*
   If HB_Islogical( lStrikeout )
      ::SetFont( ,,,,, lStrikeout )
   EndIf
Return ::Strikeout

*-----------------------------------------------------------------------------*
METHOD SizePos( Row, Col, Width, Height ) CLASS TControl
*-----------------------------------------------------------------------------*
   IF HB_IsNumeric( Row )
      ::nRow := Row
   ENDIF
   IF HB_IsNumeric( Col )
      ::nCol := Col
   ENDIF
   IF HB_IsNumeric( Width )
      ::nWidth := Width
   ENDIF
   IF HB_IsNumeric( Height )
      ::nHeight := Height
   ENDIF
Return MoveWindow( ::hWnd, ::ContainerCol, ::ContainerRow, ::nWidth, ::nHeight , .T. )

*-----------------------------------------------------------------------------*
METHOD Move( Row, Col, Width, Height ) CLASS TControl
*-----------------------------------------------------------------------------*
Return ::SizePos( Row, Col, Width, Height )

*-----------------------------------------------------------------------------*
METHOD SetVarBlock( cField, uValue ) CLASS TControl
*-----------------------------------------------------------------------------*
   If ValType( cField ) $ "CM" .AND. ! Empty( cField )
      ::VarName := AllTrim( cField )
	EndIf
   If ValType( ::VarName ) $ "CM" .AND. ! Empty( ::VarName )
      ::Block := &( "{ | _x_ | if( PCount() == 0, ( " + ::VarName + " ), ( " + ::VarName + " := _x_ ) ) }" )
	EndIf
   If HB_IsBlock( ::Block )
      ::Value := EVAL( ::Block )
   ElseIf PCount() > 1
      ::Value := uValue
   EndIf
Return nil

*-----------------------------------------------------------------------------*
METHOD AddBitMap( uImage ) CLASS TControl
*-----------------------------------------------------------------------------*
Local nPos, nCount
   If ! ValidHandler( ::ImageList )
      If HB_IsArray( uImage )
         ::ImageList := ImageList_Init( uImage, ::ImageListColor, ::ImageListFlags )[ 1 ]
      Else
         ::ImageList := ImageList_Init( { uImage }, ::ImageListColor, ::ImageListFlags )[ 1 ]
      EndIf
      If ValidHandler( ::ImageList )
         nPos := 1
         SendMessage( ::hWnd, ::SetImageListCommand, ::SetImageListWParam, ::ImageList )
      Else
         nPos := 0
      EndIf
   Else
      nCount := ImageList_GetImageCount( ::ImageList )
      If HB_IsArray( uImage )
         nPos := ImageList_Add( ::ImageList, uImage[ 1 ], ::ImageListFlags, ::ImageListColor )
         AEVAL( ::ImageList, { |c| ImageList_Add( ::ImageList, c, ::ImageListFlags, ::ImageListColor ) }, 2 )
      Else
         nPos := ImageList_Add( ::ImageList, uImage, ::ImageListFlags, ::ImageListColor )
      EndIf
      If nCount == ImageList_GetImageCount( ::ImageList )
         nPos := 0
      EndIf
      SendMessage( ::hWnd, ::SetImageListCommand, ::SetImageListWParam, ::ImageList )
   Endif
Return nPos


*-----------------------------------------------------------------------------*
METHOD DoEvent( bBlock, cEventType, aParams ) CLASS TControl
*-----------------------------------------------------------------------------*
Local lRetVal
   If ! ::Parent == nil .AND. ::Parent:lReleasing
      lRetVal := .F.
   ElseIf HB_IsBlock( bBlock )
      _PushEventInfo()
      _OOHG_ThisForm      := ::Parent
      _OOHG_ThisType      := "C"
      ASSIGN _OOHG_ThisEventType VALUE cEventType TYPE "CM" DEFAULT ""
      _OOHG_ThisControl   := Self
      _OOHG_ThisObject    := Self
      _OOHG_Eval_Array( bBlock, aParams )
      _PopEventInfo()
      lRetVal := .T.
   Else
      lRetVal := .F.
   EndIf
Return lRetVal

*-----------------------------------------------------------------------------*
METHOD DoLostFocus() CLASS TControl
*-----------------------------------------------------------------------------*
Local uRet := nil, nFocus, oFocus
   If ! ::ContainerReleasing
      nFocus := GetFocus()
      If nFocus > 0
         oFocus := GetControlObjectByHandle( nFocus )
         If ! oFocus:lCancel
            uRet := _OOHG_Eval( ::postBlock, Self )
            If HB_IsLogical( uRet ) .AND. ! uRet
               ::SetFocus()
               Return 1
            EndIf
            uRet := nil
         EndIf
      EndIf

      ::DoEvent( ::OnLostFocus, "LOSTFOCUS" )
   EndIf
Return uRet

#pragma BEGINDUMP
#define s_Super s_TWindow

// -----------------------------------------------------------------------------
HB_FUNC_STATIC( TCONTROL_EVENTS )   // METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TControl
// -----------------------------------------------------------------------------
{
   HWND hWnd      = ( HWND )   hb_parnl( 1 );
   UINT message   = ( UINT )   hb_parni( 2 );
   WPARAM wParam  = ( WPARAM ) hb_parni( 3 );
   LPARAM lParam  = ( LPARAM ) hb_parnl( 4 );
   PHB_ITEM pSelf = hb_stackSelfItem();
   ULONG lData;

   switch( message )
   {
      case WM_MOUSEMOVE:
         _OOHG_Send( pSelf, s_hCursor );
         hb_vmSend( 0 );
         lData = hb_parnl( -1 );
         if( lData )
         {
            SetCursor( ( HCURSOR ) lData );
         }
         if( wParam == MK_LBUTTON )
         {
            _OOHG_DoEvent( pSelf, s_OnMouseDrag, "MOUSEDRAG", NULL );
         }
         else
         {
            _OOHG_DoEvent( pSelf, s_OnMouseMove, "MOUSEMOVE", NULL );
         }
         hb_ret();
         break;

      // *** Commented for use current behaviour.
      // case WM_LBUTTONUP:
      //    _OOHG_DoEvent( pSelf, s_OnClick, "CLICK", NULL );
      //    hb_ret();
      //    break;

      case WM_LBUTTONDBLCLK:
         _OOHG_DoEvent( pSelf, s_OnDblClick, "DBLCLICK", NULL );
         hb_ret();
         break;

      case WM_RBUTTONUP:
         _OOHG_DoEvent( pSelf, s_OnRClick, "RCLICK", NULL );
         hb_ret();
         break;

      case WM_RBUTTONDBLCLK:
         _OOHG_DoEvent( pSelf, s_OnRDblClick, "RDBLCLICK", NULL );
         hb_ret();
         break;

      case WM_MBUTTONUP:
         _OOHG_DoEvent( pSelf, s_OnMClick, "MCLICK", NULL );
         hb_ret();
         break;

      case WM_MBUTTONDBLCLK:
         _OOHG_DoEvent( pSelf, s_OnMDblClick, "MDBLCLICK", NULL );
         hb_ret();
         break;

      default:
         _OOHG_Send( pSelf, s_Super );
         hb_vmSend( 0 );
         _OOHG_Send( hb_param( -1, HB_IT_OBJECT ), s_Events );
         hb_vmPushLong( ( LONG ) hWnd );
         hb_vmPushLong( message );
         hb_vmPushLong( wParam );
         hb_vmPushLong( lParam );
         hb_vmSend( 4 );
         break;
   }
}

HB_FUNC_STATIC( TCONTROL_EVENTS_COLOR )   // METHOD Events_Color( wParam, nDefColor ) CLASS TControl
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   HDC hdc = ( HDC ) hb_parnl( 1 );
   LONG lBackColor;

   if( oSelf->lFontColor != -1 )
   {
      SetTextColor( hdc, ( COLORREF ) oSelf->lFontColor );
   }

   _OOHG_Send( pSelf, s_Transparent );
   hb_vmSend( 0 );
   if( hb_parl( -1 ) )
   {
      SetBkMode( hdc, ( COLORREF ) TRANSPARENT );
      hb_retnl( ( LONG ) GetStockObject( NULL_BRUSH ) );
      return;
   }

   lBackColor = ( oSelf->lUseBackColor != -1 ) ? oSelf->lUseBackColor : oSelf->lBackColor;
   if( lBackColor == -1 )
   {
      lBackColor = hb_parnl( 2 );
   }
   SetBkColor( hdc, ( COLORREF ) lBackColor );
   if( lBackColor != oSelf->lOldBackColor )
   {
      oSelf->lOldBackColor = lBackColor;
      DeleteObject( oSelf->BrushHandle );
      oSelf->BrushHandle = CreateSolidBrush( lBackColor );
   }
   hb_retnl( ( LONG ) oSelf->BrushHandle );

}

#pragma ENDDUMP

*-----------------------------------------------------------------------------*
METHOD Events_Command( wParam ) CLASS TControl
*-----------------------------------------------------------------------------*
Local Hi_wParam := HIWORD( wParam )

   If Hi_wParam == BN_CLICKED .OR. Hi_wParam == STN_CLICKED  // Same value.....
      If ! ::NestedClick
         ::NestedClick := ! _OOHG_NestedSameEvent()
         ::DoEvent( ::OnClick, "CLICK" )
         ::NestedClick := .F.
      EndIf

   elseif Hi_wParam == EN_CHANGE
      ::DoEvent( ::OnChange, "CHANGE" )

   elseif Hi_wParam == EN_KILLFOCUS
      Return ::DoLostFocus()

   elseif Hi_wParam == EN_SETFOCUS
      ::DoEvent( ::OnGotFocus, "GOTFOCUS" )

   elseif Hi_wParam == BN_KILLFOCUS
      Return ::DoLostFocus()

   elseif Hi_wParam == BN_SETFOCUS
      ::DoEvent( ::OnGotFocus, "GOTFOCUS" )

   EndIf

Return nil

*-----------------------------------------------------------------------------*
METHOD Events_Enter() CLASS TControl
*-----------------------------------------------------------------------------*
   _OOHG_lSettingFocus := .F.
   ::DoEvent( ::OnEnter, "ENTER" )
   If ! _OOHG_lSettingFocus
      If _OOHG_ExtendedNavigation
         _SetNextFocus()
      EndIf
   Else
      _OOHG_lSettingFocus := .F.
   EndIf
Return nil

*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TControl
*-----------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam )

   Empty( wParam ) // DUMMY...

   If nNotify == NM_KILLFOCUS
      Return ::DoLostFocus()

   elseif nNotify == NM_SETFOCUS
      ::DoEvent( ::OnGotFocus, "GOTFOCUS" )

   elseif nNotify == TVN_SELCHANGED
      ::DoEvent( ::OnChange, "CHANGE" )

   EndIf

Return nil

*-----------------------------------------------------------------------------*
Function GetControlObject( ControlName, FormName )
*-----------------------------------------------------------------------------*
Local mVar
   mVar := '_' + FormName + '_' + ControlName
Return IF( Type( mVar ) == "O", &mVar, TControl() )

*-----------------------------------------------------------------------------*
Function GetExistingControlObject( ControlName, FormName )
*-----------------------------------------------------------------------------*
Local mVar
   mVar := '_' + FormName + '_' + ControlName
   If ! Type( mVar ) == "O"
      MsgOOHGError( "Control: " + ControlName + " of " + FormName + " not defined. Program Terminated." )
   EndIf
Return &mVar

*-----------------------------------------------------------------------------*
Function _GetId()
*-----------------------------------------------------------------------------*
Local RetVal
   Do While .T.
      RetVal := Int( random( 63000 ) ) + 2001
      If aScan( _OOHG_aControlIds , { |a| a[ 1 ] == RetVal } ) == 0
         Exit
		EndIf
	EndDo
Return RetVal

*------------------------------------------------------------------------------*
Function _KillAllTimers()
*------------------------------------------------------------------------------*
Local nIndex
   // Since ::Release() removes the control from array, it can't be an AEVAL()
   nIndex := 1
   do while nIndex <= LEN( _OOHG_aControlObjects )
      if _OOHG_aControlObjects[ nIndex ]:Type == "TIMER"
         _OOHG_aControlObjects[ nIndex ]:Release()
      else
          nIndex++
      endif
   enddo
Return nil

*------------------------------------------------------------------------------*
Function GetStartUpFolder()
*------------------------------------------------------------------------------*
Local StartUpFolder := GetProgramFileName()
Return Left ( StartUpFolder , Rat ( '\' , StartUpFolder ) - 1 )

*------------------------------------------------------------------------------*
Function _OOHG_SetMultiple( lMultiple, lWarning )
*------------------------------------------------------------------------------*
Local lRet := _OOHG_lMultiple
   If HB_IsLogical( lMultiple )
      _OOHG_lMultiple := lMultiple
   ElseIf HB_IsNumeric( lMultiple )
      _OOHG_lMultiple := ( lMultiple != 0 )
   ElseIf VALTYPE( lMultiple ) $ "CM"
      If UPPER( ALLTRIM( lMultiple ) ) == "ON"
         _OOHG_lMultiple := .T.
      ElseIf UPPER( ALLTRIM( lMultiple ) ) == "OFF"
         _OOHG_lMultiple := .F.
      EndIf
   EndIf
   If ! _OOHG_lMultiple .AND. ;
      ( EMPTY( CreateMutex( , .T., strtran(GetModuleFileName(),'\','_') ) ) .OR. (GetLastError() > 0) )
      If HB_IsLogical( lWarning ) .AND. lWarning
         InitMessages()
         MsgStop( _OOHG_Messages( 1, 4 ) )
      Endif
      ExitProcess(0)
   ENDIF
Return lRet

// Initializes C variables
*-----------------------------------------------------------------------------*
Procedure _OOHG_Init_C_Vars_Controls()
*-----------------------------------------------------------------------------*
   TControl()
   _OOHG_Init_C_Vars_Controls_C_Side( _OOHG_aControlhWnd, _OOHG_aControlObjects, _OOHG_aControlIds )
Return

EXTERN _OOHG_UnTransform

#pragma BEGINDUMP

HB_FUNC( _OOHG_UNTRANSFORM )
{
   char *cText, *cPicture, *cReturn, cType;
   ULONG iText, iPicture, iReturn, iMax;
   BOOL lSign, bIgnoreMasks;

   iText = hb_parclen( 1 );
   iPicture = hb_parclen( 2 );
   iMax = ( iText > iPicture ) ? iText : iPicture ;
   if( iText && iPicture )
   {
      cText = hb_parc( 1 );
      cPicture = hb_parc( 2 );
      cReturn = hb_xgrab( iMax );
      iReturn = 0;

      if( hb_parclen( 3 ) > 0 )
      {
         cType = hb_parc( 3 )[ 0 ];
         if( cType >= 'a' && cType <= 'z' )
         {
            cType = ( char ) ( cType - 32 );
         }
      }
      else
      {
         cType = 'C';
      }

      lSign = 0;
      bIgnoreMasks = ( cType == 'N' || cType == 'L' );

      // Picture function
      if( iPicture && *cPicture == '@' )
      {
         cPicture++;
         while( iPicture && *cPicture != ' ' )
         {
            iPicture--;
            switch( *cPicture++ )
            {
               case 'R':
               case 'r':
                  bIgnoreMasks = 1;
                  break;

               case '(':
               case ')':
                  if( cType == 'N' && cText[ iText - 1 ] == ')' )
                  {
                     lSign = 1;
                     iText--;
                     cReturn[ iReturn++ ] = '-';
                  }
                  break;

               case 'X':
               case 'x':
                  if( cType == 'N' && iText > 2 && cText[ iText - 3 ] == ' ' && cText[ iText - 2 ] == 'D' && cText[ iText - 1 ] == 'B' )
                  {
                     lSign = 1;
                     iText -= 3;
                     cReturn[ iReturn++ ] = '-';
                  }
                  break;

            }
         }
         if( iPicture && *cPicture == ' ' )
         {
            iPicture--;
            cPicture++;
         }
      }

      while( iPicture && iText )
      {
         iPicture--;
         switch( *cPicture++ )
         {
            case 'A':
            case 'N':
            case 'X':
            case '9':
            case '#':
            case 'L':
            case 'Y':
            case '!':
            case 'a':
            case 'n':
            case 'x':
            case 'l':
            case 'y':
            case '$':
            case '*':
               if( cType == 'N' )
               {
                  switch( *cText )
                  {
                     case '$':
                     case '*':
                     case '(':
                        cReturn[ iReturn++ ] = ' ';
                        break;

                     default:
                        cReturn[ iReturn++ ] = *cText;
                        break;
                  }
               }
               else
               {
                  cReturn[ iReturn++ ] = *cText;
               }
               break;

            case '.':
               if( cType == 'N' )
               {
                  cReturn[ iReturn++ ] = '.';
               }
               else if( ! bIgnoreMasks )
               {
                  cReturn[ iReturn++ ] = *cText;
               }
               break;

            case ',':
               if( cType == 'N' && *cText == '-' )
               {
                  lSign = 1;
               }
               else if( ! bIgnoreMasks )
               {
                  cReturn[ iReturn++ ] = *cText;
               }
               break;

            default:
               if( ! bIgnoreMasks )
               {
                  cReturn[ iReturn++ ] = *cText;
               }

         }
         iText--;
         cText++;
      }

      while( iText )
      {
         cReturn[ iReturn++ ] = *cText++;
         iText--;
      }

      if( cType == 'N' && lSign )
      {
         iPicture = 0;
         for( iText = 0; iText < iReturn; iText++ )
         {
            if( cReturn[ iText ] == ' ' )
            {
               iPicture = iText;
            }
            else
            {
               iText = iReturn;
            }
         }
         cReturn[ iPicture ] = '-';
      }

      hb_retclen( cReturn, iReturn );
      hb_xfree( cReturn );
   }
   else
   {
      hb_retc( "" );
   }
}

#pragma ENDDUMP
