/*
 * $Id: h_controlmisc.prg,v 1.37 2005-11-25 05:38:41 guerra000 Exp $
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

STATIC _OOHG_lMultiple := .T.    // Allows the same applicaton runs more one instance at a time

#pragma BEGINDUMP
#include "hbapi.h"
#include "hbapiitm.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windows.h>
#include <commctrl.h>
#include "../include/oohg.h"
#pragma ENDDUMP

*-----------------------------------------------------------------------------*
Function _Getvalue ( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Local Self := GetControlObject( ControlName, ParentForm )

	If Pcount() == 2

		If Upper (ControlName) == 'VSCROLLBAR'

			Return GetScrollPos ( GetFormHandle ( ParentForm )  , 1 )

		EndIf

		If Upper (ControlName) == 'HSCROLLBAR'

			Return GetScrollPos ( GetFormHandle ( ParentForm )  , 0 )

		EndIf

	EndIf

Return ::Value

*-----------------------------------------------------------------------------*
Function _Setvalue( ControlName, ParentForm, Value )
*-----------------------------------------------------------------------------*
Local Self := GetControlObject( ControlName, ParentForm )

	do case

   case ::Type == "STATUS"
         SetStatus( ::hWnd, value )

	endcase

Return ::Value := value

*-----------------------------------------------------------------------------*
Function _AddItem ( ControlName, ParentForm, Value )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):AddItem( Value )

*-----------------------------------------------------------------------------*
Function _DeleteItem ( ControlName, ParentForm, Value )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):DeleteItem( Value )

*-----------------------------------------------------------------------------*
Function _DeleteAllItems ( ControlName, ParentForm )
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
Function GetControlId (ControlName,ParentForm)
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Id

*-----------------------------------------------------------------------------*
Function GetControlType (ControlName,ParentForm)
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Type

*-----------------------------------------------------------------------------*
Function GetControlValue (ControlName,ParentForm)
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Value

*-----------------------------------------------------------------------------*
Function _IsControlDefined ( ControlName , FormName)
*-----------------------------------------------------------------------------*
Local mVar , o

mVar := '_' + FormName + '_' + ControlName

if type ( mVar ) = 'U'
	Return (.F.)
EndIf
if type ( mVar ) = 'O'
   o := &mVar
   if o:hWnd == -1
		Return .f.
	EndIf
   Return .t.
EndIf

Return .F.

*-----------------------------------------------------------------------------*
Function _SetFocus ( ControlName , ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName , ParentForm ):SetFocus()

*-----------------------------------------------------------------------------*
Function _DisableControl ( ControlName , ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Enabled := .F.

*-----------------------------------------------------------------------------*
Function _EnableControl ( ControlName,ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Enabled := .T.

*-----------------------------------------------------------------------------*
Function _ShowControl ( ControlName,ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Visible := .T.

*-----------------------------------------------------------------------------*
Function _HideControl ( ControlName,ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Visible := .F.

*-----------------------------------------------------------------------------*
Function _SetItem ( ControlName, ParentForm, Item , Value )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Item( Item, Value )

*-----------------------------------------------------------------------------*
Function _GetItem ( ControlName, ParentForm, Item )
*-----------------------------------------------------------------------------*
Return GetControlObject( Controlname, ParentForm ):Item( Item )

*-----------------------------------------------------------------------------*
Function _SetControlSizePos ( ControlName, ParentForm, row, col, width, height )
*-----------------------------------------------------------------------------*
Return GetControlObject( Controlname, ParentForm ):SizePos( row, col, width, height )

*-----------------------------------------------------------------------------*
Function _GetItemCount ( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( Controlname, ParentForm ):ItemCount

*-----------------------------------------------------------------------------*
Function _GetControlRow (ControlName,ParentForm)
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Row

*-----------------------------------------------------------------------------*
Function _GetControlCol (ControlName,ParentForm)
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Col

*-----------------------------------------------------------------------------*
Function _GetControlWidth (ControlName,ParentForm)
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Width

*-----------------------------------------------------------------------------*
Function _GetControlHeight (ControlName,ParentForm)
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Height

*-----------------------------------------------------------------------------*
Function _SetControlCol ( ControlName, ParentForm, Value )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):SizePos( , Value )

*-----------------------------------------------------------------------------*
Function _SetControlRow ( ControlName, ParentForm, Value )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):SizePos( Value )

*-----------------------------------------------------------------------------*
Function _SetControlWidth ( ControlName, ParentForm, Value )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):SizePos( , , Value )

*-----------------------------------------------------------------------------*
Function _SetControlHeight ( ControlName, ParentForm, Value )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):SizePos( , , , Value )

*-----------------------------------------------------------------------------*
Function _SetPicture ( ControlName, ParentForm, FileName )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Picture := FileName

*-----------------------------------------------------------------------------*
Function _GetPicture ( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Picture

*-----------------------------------------------------------------------------*
Function _GetControlAction( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):OnClick

*-----------------------------------------------------------------------------*
Function _GetToolTip ( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):ToolTip

*-----------------------------------------------------------------------------*
Function _SetToolTip ( ControlName, ParentForm , Value  )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):ToolTip := Value

*-----------------------------------------------------------------------------*
Function _SetRangeMin ( ControlName, ParentForm , Value  )
*-----------------------------------------------------------------------------*
Return ( GetControlObject( ControlName, ParentForm ):RangeMin := Value )

*-----------------------------------------------------------------------------*
Function _SetRangeMax ( ControlName, ParentForm , Value  )
*-----------------------------------------------------------------------------*
Return ( GetControlObject( ControlName, ParentForm ):RangeMax := Value )

*-----------------------------------------------------------------------------*
Function _GetRangeMin ( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):RangeMin

*-----------------------------------------------------------------------------*
Function _GetRangeMax ( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):RangeMax

*-----------------------------------------------------------------------------*
Function _SetMultiCaption ( ControlName, ParentForm , Column , Value  )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Caption( Column, Value )

*-----------------------------------------------------------------------------*
Function _GetMultiCaption ( ControlName, ParentForm , Item )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Caption( Item )

*-----------------------------------------------------------------------------*
Function InputWindow ( Title , aLabels , aValues , aFormats , row , col )
*-----------------------------------------------------------------------------*
Local i , l , ControlRow , e := 0 ,LN , CN ,r , c , wHeight , diff
Local oInputWindow, aResult

	l := Len ( aLabels )

   aResult := ARRAY( l )

	For i := 1 to l

		if ValType ( aValues[i] ) == 'C'

			if ValType ( aFormats[i] ) == 'N'

				If aFormats[i] > 32
					e++
				Endif

			EndIf

		EndIf

		if ValType ( aValues[i] ) == 'M'
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
		NOSIZE

		ControlRow :=  10

		For i := 1 to l

			LN := 'Label_' + Alltrim(Str(i,2,0))
			CN := 'Control_' + Alltrim(Str(i,2,0))

			@ ControlRow , 10 LABEL &LN OF _InputWindow VALUE aLabels [i] WIDTH 90

			do case
			case ValType ( aValues [i] ) == 'L'

				@ ControlRow , 120 CHECKBOX &CN OF _InputWindow CAPTION '' VALUE aValues[i]
				ControlRow := ControlRow + 30

			case ValType ( aValues [i] ) == 'D'

				@ ControlRow , 120 DATEPICKER &CN  OF _InputWindow VALUE aValues[i] WIDTH 140
				ControlRow := ControlRow + 30

			case ValType ( aValues [i] ) == 'N'

				If ValType ( aFormats [i] ) == 'A'

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

				If ValType ( aFormats [i] ) == 'N'
					If  aFormats [i] <= 32
						@ ControlRow , 120 TEXTBOX &CN  OF _InputWindow VALUE aValues[i] WIDTH 140 FONT 'Arial' SIZE 10 MAXLENGTH aFormats [i]
						ControlRow := ControlRow + 30
					Else
						@ ControlRow , 120 EDITBOX &CN  OF _InputWindow WIDTH 140 HEIGHT 90 VALUE aValues[i] FONT 'Arial' SIZE 10 MAXLENGTH aFormats[i]
						ControlRow := ControlRow + 94
					EndIf
				EndIf

			case ValType ( aValues [i] ) == 'M'

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
Function _ReleaseControl ( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
Return GetControlObject( ControlName, ParentForm ):Release()

*-----------------------------------------------------------------------------*
Function _IsControlVisibleFromHandle (Handle)
*-----------------------------------------------------------------------------*
Return GetControlObjectByHandle( Handle ):ContainerVisible

*-----------------------------------------------------------------------------*
Function _SetCaretPos( ControlName , FormName , Pos )
*-----------------------------------------------------------------------------*
Return SendMessage( GetControlObject( ControlName, FormName ):hWnd, EM_SETSEL , Pos , Pos )

*-----------------------------------------------------------------------------*
Function _GetCaretPos ( ControlName , FormName )
*-----------------------------------------------------------------------------*
Return ( HiWord ( SendMessage( GetControlObject( ControlName, FormName ):hWnd, EM_GETSEL , 0 , 0 ) ) )

*------------------------------------------------------------------------------*
FUNCTION Random( nLimit )
*------------------------------------------------------------------------------*
//  Static snRandom := Nil
//  Local nDecimals, cLimit

//  DEFAULT snRandom TO Seconds() / Exp(1)
  DEFAULT nLimit   TO 65535

//  snRandom  := Log( snRandom + Sqrt(2) ) * Exp(3)
//  snRandom  := Val( Str(snRandom - Int(snRandom), 17, 15 ) )
//  cLimit    := Transform( nLimit, "@N" )

//  nDecimals := At(".", cLimit)

//  if nDecimals > 0
//     nDecimals := Len(cLimit)-nDecimals
//  endif

//Return Round( nLimit * snRandom, nDecimals )
Return hb_random( nLimit )

*------------------------------------------------------------------------------*
Function SetProperty( Arg1 , Arg2 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 )
*------------------------------------------------------------------------------*
Local oWnd, oCtrl

	if Pcount() == 3 // Window

		If .Not. _IsWindowDefined ( Arg1 )
         MsgOOHGError("Window: "+ Arg1 + " is not defined. Program terminated" )
		Endif

      oWnd := GetFormObject( Arg1 )

		Arg2 := Upper (Arg2)

		if Arg2 == 'TITLE'

         oWnd:Title := Arg3

		ELseIf Arg2 == 'HEIGHT'

         oWnd:Height := Arg3

		ElseIf Arg2 == 'WIDTH'

         oWnd:Width := Arg3

		ElseIf Arg2 == 'COL'

         oWnd:Col := Arg3

		ElseIf Arg2 == 'ROW'

         oWnd:Row := Arg3

		ElseIf Arg2 == 'NOTIFYICON'

         oWnd:NotifyIconName := Arg3

		ElseIf Arg2 == 'NOTIFYTOOLTIP'

         oWnd:NotifyIconTooltip := Arg3

      ElseIf Arg2 == "BACKCOLOR"
         oWnd:BackColor := Arg3

		ElseIf Arg2 == 'CURSOR'

         oWnd:Cursor := Arg3

		EndIf

	ElseIf Pcount() == 4 // CONTROL

		If .Not. _IsControlDefined ( Arg2 , Arg1  )
         MsgOOHGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
		endif

      oCtrl := GetControlObject( Arg2, Arg1 )

		Arg3 := Upper (Arg3)

		If     Arg3 == 'VALUE'

         oCtrl:Value := Arg4

      ElseIf Arg3 == 'ALLOWEDIT'

         oCtrl:AllowEdit := Arg4

		ElseIf Arg3 == 'ALLOWAPPEND'

         oCtrl:AllowAppend := Arg4

		ElseIf Arg3 == 'ALLOWDELETE'

         oCtrl:AllowDelete := Arg4

		ElseIf Arg3 == 'PICTURE'

         oCtrl:Picture := Arg4

		ElseIf Arg3 == 'TOOLTIP'

         oCtrl:Tooltip := Arg4

		ElseIf Arg3 == 'FONTNAME'

         oCtrl:SetFont( Arg4 )

		ElseIf Arg3 == 'FONTSIZE'

         oCtrl:SetFont( , Arg4 )

		ElseIf Arg3 == 'FONTBOLD'

         oCtrl:SetFont( , , Arg4 )

		ElseIf Arg3 == 'FONTITALIC'

         oCtrl:SetFont( , , , Arg4 )

		ElseIf Arg3 == 'FONTUNDERLINE'

         oCtrl:SetFont( , , , , Arg4 )

		ElseIf Arg3 == 'FONTSTRIKEOUT'

         oCtrl:SetFont( , , , , , Arg4 )

		ElseIf Arg3 == 'CAPTION'

         SetWindowText( oCtrl:hWnd, Arg4 )

		ElseIf Arg3 == 'DISPLAYVALUE'

         SetWindowText( oCtrl:hWnd, Arg4 )

		ElseIf Arg3 == 'ROW'

         oCtrl:Row := Arg4

		ElseIf Arg3 == 'COL'

         oCtrl:Col := Arg4

		ElseIf Arg3 == 'WIDTH'

         oCtrl:Width := Arg4

		ElseIf Arg3 == 'HEIGHT'

         oCtrl:Height := Arg4

		ElseIf Arg3 == 'VISIBLE'

         oCtrl:Visible := Arg4

		ElseIf Arg3 == 'ENABLED'

         oCtrl:Enabled := Arg4

		ElseIf Arg3 == 'CHECKED'

         oCtrl:Checked := Arg4

		ElseIf Arg3 == 'RANGEMIN'

         oCtrl:RangeMin := Arg4

		ElseIf Arg3 == 'RANGEMAX'

         oCtrl:RangeMax := Arg4

		ElseIf Arg3 == 'REPEAT'

			If Arg4 == .t.
            oCtrl:RepeatOn()
			Else
            oCtrl:RepeatOff()
			EndIf

		ElseIf Arg3 == 'SPEED'

         oCtrl:Speed( Arg4 )

		ElseIf Arg3 == 'VOLUME'

         oCtrl:Volume( Arg4 )

		ElseIf Arg3 == 'ZOOM'

         oCtrl:Zoom( Arg4 )

		ElseIf Arg3 == 'POSITION'

			If Arg4 == 0
            oCtrl:PositionHome()
			ElseIf Arg4 == 1
            oCtrl:PositionEnd()
			EndIf

		ElseIf Arg3 == 'CARETPOS'

			_SetCaretPos ( Arg2 , Arg1 , Arg4 )

		ElseIf Arg3 == 'BACKCOLOR'

         oCtrl:BackColor := Arg4

		ElseIf Arg3 == 'FONTCOLOR'

         oCtrl:FontColor := Arg4

		ElseIf Arg3 == 'FORECOLOR'

         oCtrl:FontColor := Arg4

		ElseIf Arg3 == 'ADDRESS'

         oCtrl:Address := Arg4

		ElseIf Arg3 == 'READONLY'

         SetTextEditReadOnly( oCtrl:hWnd, Arg4 )

		ElseIf Arg3 == 'ITEMCOUNT'

         ListView_SetItemCount( oCtrl:hWnd, Arg4 )

		EndIf

	ElseIf Pcount() == 5 // CONTROL (WITH ARGUMENT OR TOOLBAR BUTTON)

		Arg3 := Upper (Arg3)

      oCtrl := GetControlObject( Arg2, Arg1 )

		If     Arg3 == 'CAPTION'

			If .Not. _IsControlDefined ( Arg2 , Arg1  )
            MsgOOHGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
			endif

         oCtrl:Caption( Arg4 , Arg5 )

		ElseIf Arg3 == 'HEADER'

			If .Not. _IsControlDefined ( Arg2 , Arg1  )
            MsgOOHGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
			endif

         oCtrl:Caption( Arg4 , Arg5 )

		ElseIf Arg3 == 'ITEM'

			If .Not. _IsControlDefined ( Arg2 , Arg1  )
            MsgOOHGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
			endif

         oCtrl:Item( Arg4, Arg5 )

		ElseIf Arg3 == 'ICON'

			If .Not. _IsControlDefined ( Arg2 , Arg1  )
            MsgOOHGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
			endif

			_SetStatusIcon ( Arg2 , Arg1 , Arg4 , Arg5 )

      ElseIf Arg3 == 'COLUMNWIDTH'

			If .Not. _IsControlDefined ( Arg2 , Arg1  )
            MsgOOHGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
			endif

         oCtrl:ColumnWidth( Arg4, Arg5 )

		Else
			// If Property Not Matched Look For ToolBar Button

         If oCtrl:Type == "TOOLBAR"

            If oCtrl:hWnd != GetControlObject( Arg3 , Arg1 ):Container:hWnd
               MsgOOHGError('Control Does Not Belong To Container')
				EndIf

            SetProperty( Arg1 , Arg3 , Arg4 , Arg5 )
			EndIf

		EndIf

	ElseIf Pcount() == 6 // TAB CHILD CONTROL

/*
      If aScan ( GetControlObject( Arg2, Arg1 ):aPages[ Arg3 ], GetControlObject( Arg4 , Arg1 ):hWnd ) == 0
         MsgOOHGError('Control Does Not Belong To Container')
		EndIf
*/

      SetProperty( Arg1 , Arg4 , Arg5 , Arg6 )

	ElseIf Pcount() == 7 // TAB CHILD CONTROL WITH ARGUMENT

/*
      If aScan ( GetControlObject( Arg2, Arg1 ):aPages[ Arg3 ], GetControlObject( Arg4 , Arg1 ):hWnd ) == 0
         MsgOOHGError('Control Does Not Belong To Container')
		EndIf
*/

      SetProperty( Arg1 , Arg4 , Arg5 , Arg6 , Arg7 )

	EndIf

Return Nil

*------------------------------------------------------------------------------*
Function GetProperty( Arg1 , Arg2 , Arg3 , Arg4 , Arg5 , Arg6 )
*------------------------------------------------------------------------------*
Local RetVal, oWnd, oCtrl

	if Pcount() == 2 // WINDOW

		If .Not. _IsWindowDefined ( Arg1 )
         MsgOOHGError("Window: "+ Arg1 + " is not defined. Program terminated" )
		Endif

		Arg2 := Upper (Arg2)

      oWnd := GetFormObject( Arg1 )

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

		ElseIf Arg2 == 'NOTIFYICON'
         RetVal := oWnd:NotifyIconName

		ElseIf Arg2 == 'NOTIFYTOOLTIP'
         RetVal := oWnd:NotifyIconTooltip

      ElseIf Arg2 == "BACKCOLOR"
         RetVal := oWnd:BackColor

      ElseIf Arg2 == "HWND"
         RetVal := oWnd:hWnd

		EndIf

	ElseIf Pcount() == 3 // CONTROL

		If ( Upper(Arg2) == 'VSCROLLBAR' .Or. Upper(Arg2) == 'HSCROLLBAR' )

			If .Not. _IsWindowDefined ( Arg1 )
            MsgOOHGError("Window: "+ Arg1 + " is not defined. Program terminated" )
			Endif

		Else

			If .Not. _IsControlDefined ( Arg2 , Arg1  )
            MsgOOHGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
			endif

		EndIf

		Arg3 := Upper (Arg3)

      oCtrl := GetControlObject( Arg2, Arg1 )

		If     Arg3 == 'VALUE'
         // RetVal := oCtrl:Value
         RetVal := _GetValue( Arg2, Arg1 )

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
         RetVal := _GetCaretPos( Arg2 , Arg1 )

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

		EndIf

	ElseIf Pcount() == 4 // CONTROL (WITH ARGUMENT OR TOOLBAR BUTTON)

		Arg3 := Upper (Arg3)

      oCtrl := GetControlObject( Arg2, Arg1 )

		If     Arg3 == 'ITEM'

			If .Not. _IsControlDefined ( Arg2 , Arg1  )
            MsgOOHGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
			endif

         RetVal := oCtrl:Item( Arg4 )

		ElseIf Arg3 == 'CAPTION'

			If .Not. _IsControlDefined ( Arg2 , Arg1  )
            MsgOOHGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
			endif

         RetVal := oCtrl:Caption( Arg4 )

		ElseIf Arg3 == 'HEADER'

			If .Not. _IsControlDefined ( Arg2 , Arg1  )
            MsgOOHGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
			endif

         RetVal := oCtrl:Caption( Arg4 )

      ElseIf Arg3 == 'COLUMNWIDTH'

			If .Not. _IsControlDefined ( Arg2 , Arg1  )
            MsgOOHGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
			endif

         RetVal := oCtrl:ColumnWidth( Arg4 )

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

	ElseIf Pcount() == 5 // TAB CHILD CONTROL (WITHOUT ARGUMENT)

/*
      If aScan ( GetControlObject( Arg2, Arg1 ):aPages[ Arg3 ], GetControlObject( Arg4 , Arg1 ):hWnd ) == 0
         MsgOOHGError('Control Does Not Belong To Container')
		EndIf
*/

      RetVal := GetProperty( Arg1 , Arg4 , Arg5 )

	ElseIf Pcount() == 6 // TAB CHILD CONTROL (WITH ARGUMENT)

/*
      If aScan ( GetControlObject( Arg2, Arg1 ):aPages[ Arg3 ], GetControlObject( Arg4 , Arg1 ):hWnd ) == 0
         MsgOOHGError('Control Does Not Belong To Container')
		EndIf
*/

      RetVal := GetProperty( Arg1 , Arg4 , Arg5 , Arg6 )

	EndIf

Return RetVal

*------------------------------------------------------------------------------*
Function DoMethod( Arg1 , Arg2 , Arg3 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 , Arg9 )
*------------------------------------------------------------------------------*
Local oWnd, oCtrl

	if Pcount() == 2 // Window

      If ValType ( Arg1 ) $ 'CM'
			If .Not. _IsWindowDefined ( Arg1 )
            MsgOOHGError("Window: "+ Arg1 + " is not defined. Program terminated" )
			Endif
		EndIf

      oWnd := GetFormObject( Arg1 )

		Arg2 := Upper (Arg2)

		if Arg2 == 'ACTIVATE'

			if ValType ( Arg1 ) == 'A'
            oWnd:Activate()
			Else
            * AEVAL( Arg1, { |c| GetFormObject( c ):Activate() } )
				_ActivateWindow ( { Arg1 } )
			EndIf

		ELseIf Arg2 == 'CENTER'

         oWnd:Center()

		ElseIf Arg2 == 'RELEASE'

			_ReleaseWindow ( Arg1 )

		ElseIf Arg2 == 'MAXIMIZE'

         oWnd:Maximize()

		ElseIf Arg2 == 'MINIMIZE'

         oWnd:Minimize()
			_MinimizeWindow ( Arg1 )

		ElseIf Arg2 == 'RESTORE'

         oWnd:Restore()

		ElseIf Arg2 == 'SHOW'

         oWnd:Show()

		ElseIf Arg2 == 'PRINT'

         oWnd:print()

		ElseIf Arg2 == 'HIDE'

         oWnd:Hide()

		ElseIf Arg2 == 'SETFOCUS'

         If oWnd:Active
            oWnd:SetFocus()
         EndIf

		EndIf

	ElseIf Pcount() == 3 // CONTROL

		If .Not. _IsControlDefined ( Arg2 , Arg1  )
         MsgOOHGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
		endif

      oCtrl := GetControlObject( Arg2, Arg1 )

		Arg3 := Upper (Arg3)

		If     Arg3 == 'REFRESH'

         oCtrl:Refresh()

		ElseIf Arg3 == 'SAVE'

         oCtrl:SaveData()

		ElseIf Arg3 == 'SETFOCUS'

         oCtrl:SetFocus()

		ElseIf Arg3 == 'ACTION'

         _OOHG_Eval( oCtrl:OnClick )

		ElseIf Arg3 == 'ONCLICK'

         _OOHG_Eval( oCtrl:OnClick )

      ElseIf Arg3 == 'COLUMNSAUTOFIT'

         oCtrl:ColumnsAutoFit()

      ElseIf Arg3 == 'COLUMNSAUTOFITH'

         oCtrl:ColumnsAutoFitH()

		ElseIf Arg3 == 'DELETEALLITEMS'

         oCtrl:DeleteAllItems()

		ElseIf Arg3 == 'RELEASE'

         oCtrl:Release()

		ElseIf Arg3 == 'SHOW'

         oCtrl:Visible := .T.

		ElseIf Arg3 == 'HIDE'

         oCtrl:Visible := .F.

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

		If .Not. _IsControlDefined ( Arg2 , Arg1  )
         MsgOOHGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
		endif

		Arg3 := Upper (Arg3)

      oCtrl := GetControlObject( Arg2, Arg1 )

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

   ElseIf Pcount() == 5 .And. ValType (Arg3) $ 'CM'
		 // CONTROL (WITH 2 ARGUMENTS)

		If .Not. _IsControlDefined ( Arg2 , Arg1  )
         MsgOOHGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
		endif

		Arg3 := Upper (Arg3)

      oCtrl := GetControlObject( Arg2, Arg1 )

		If     Arg3 == 'ADDITEM'

         oCtrl:AddItem( Arg4 , Arg5 )

		ElseIf Arg3 == 'ADDPAGE'

         oCtrl:AddPage( Arg4 , Arg5 )

		EndIf

	ElseIf Pcount()=5  .And. ValType (Arg3)=='N'
		// TAB CHILD WITHOUT ARGUMENTS
/*
      If aScan ( GetControlObject( Arg2, Arg1 ):aPages[ Arg3 ], GetControlObject( Arg4 , Arg1 ):hWnd ) == 0
         MsgOOHGError('Control Does Not Belong To Container')
		EndIf
*/

		DoMethod ( Arg1 , Arg4 , Arg5 )

   ElseIf Pcount() == 6 .And. ValType (Arg3) $ 'CM'
		// CONTROL (WITH 3 ARGUMENTS)

		If .Not. _IsControlDefined ( Arg2 , Arg1  )
         MsgOOHGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
		endif

      oCtrl := GetControlObject( Arg2, Arg1 )

		Arg3 := Upper (Arg3)

		If     Arg3 == 'ADDITEM'

         oCtrl:AddItem( Arg4 , Arg5 , Arg6 )

		ElseIf Arg3 == 'ADDPAGE'

         oCtrl:AddPage( Arg4 , Arg5 , Arg6 )

		EndIf

	ElseIf Pcount() == 6 .And. ValType (Arg3) == 'N'
		// TAB CHILD WITH 1 ARGUMENT
/*
      If aScan ( GetControlObject( Arg2, Arg1 ):aPages[ Arg3 ], GetControlObject( Arg4 , Arg1 ):hWnd ) == 0
         MsgOOHGError('Control Does Not Belong To Container')
		EndIf
*/
		DoMethod ( Arg1 , Arg4 , Arg5 , Arg6 )

   ElseIf Pcount() == 7 .And. ValType (Arg3) $ 'CM'
		// CONTROL (WITH 4 ARGUMENTS)

		If .Not. _IsControlDefined ( Arg2 , Arg1  )
         MsgOOHGError ("Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
		endif

      oCtrl := GetControlObject( Arg2, Arg1 )

		Arg3 := Upper (Arg3)

		If     Arg3 == 'ADDCONTROL'

         oCtrl:AddControl( GetControlObject( Arg4, Arg1 ), Arg5 , Arg6 , Arg7 )

		ElseIf     Arg3 == 'ADDCOLUMN'

         oCtrl:AddColumn( Arg4 , Arg5 , Arg6 , Arg7 )

		ElseIf     Arg3 == 'ADDITEM'

         oCtrl:AddItem( Arg4 , Arg5 , Arg6 , Arg7 )

		EndIf

	ElseIf Pcount() == 7 .And. ValType (Arg3) == 'N'
		// TAB CHILD WITH 2 ARGUMENTS
/*
      If aScan ( GetControlObject( Arg2, Arg1 ):aPages[ Arg3 ], GetControlObject( Arg4 , Arg1 ):hWnd ) == 0
         MsgOOHGError('Control Does Not Belong To Container')
		EndIf
*/
		DoMethod ( Arg1 , Arg4 , Arg5 , Arg6 , Arg7 )

	ElseIf Pcount() == 8
		// TAB CHILD WITH 3 ARGUMENTS
/*
      If aScan ( GetControlObject( Arg2, Arg1 ):aPages[ Arg3 ], GetControlObject( Arg4 , Arg1 ):hWnd ) == 0
         MsgOOHGError('Control Does Not Belong To Container')
		EndIf
*/
		DoMethod ( Arg1 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 )

	ElseIf Pcount() == 9
		// TAB CHILD WITH 4 ARGUMENTS
/*
      If aScan ( GetControlObject( Arg2, Arg1 ):aPages[ Arg3 ], GetControlObject( Arg4 , Arg1 ):hWnd ) == 0
         MsgOOHGError('Control Does Not Belong To Container')
		EndIf
*/
		DoMethod ( Arg1 , Arg4 , Arg5 , Arg6 , Arg7 , Arg8 , Arg9 )

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
   DATA lVisible    INIT .T.
   DATA cToolTip    INIT ""
   DATA FontHandle  INIT 0
   DATA AuxHandle   INIT 0
   DATA Transparent INIT .F.
   DATA Visible     INIT .T.
   DATA HelpId      INIT 0
   DATA OnChange    INIT nil
   DATA OnDblClick  INIT nil
   DATA Block       INIT nil
   DATA VarName     INIT ""
   DATA Caption     INIT ""
   DATA Id          INIT 0
   DATA ImageListColor      INIT CLR_NONE
   DATA ImageListFlags      INIT LR_LOADTRANSPARENT
   DATA SetImageListCommand INIT 0   // Must be explicit for each control
   DATA SetImageListWParam  INIT TVSIL_NORMAL
   DATA hCursor     INIT 0

   METHOD Row       SETGET
   METHOD Col       SETGET
   METHOD Width     SETGET
   METHOD Height    SETGET
   METHOD ToolTip   SETGET
   METHOD SetForm
   METHOD SetInfo
   METHOD New
   METHOD Refresh             BLOCK { || nil }
   METHOD Release
   METHOD ContainerRow        BLOCK { |Self| IF( ::Container != NIL, ::Container:ContainerRow + ::Container:RowMargin, ::Parent:RowMargin ) + ::Row }
   METHOD ContainerCol        BLOCK { |Self| IF( ::Container != NIL, ::Container:ContainerCol + ::Container:ColMargin, ::Parent:ColMargin ) + ::Col }
   METHOD ContainerVisible    BLOCK { |Self| ::lVisible .AND. IF( ::Container != NIL, ::Container:ContainerVisible, .T. ) }
   METHOD ContainerhWnd       BLOCK { |Self| IF( ::Container != NIL, ::Container:ContainerhWnd, ::Parent:hWnd ) }
   METHOD SetFont
   METHOD FontName            SETGET
   METHOD FontSize            SETGET
   METHOD FontBold            SETGET
   METHOD FontItalic          SETGET
   METHOD FontUnderline       SETGET
   METHOD FontStrikeout       SETGET
   METHOD SizePos
   METHOD Move
   METHOD Value               BLOCK { || nil }
   METHOD Visible             SETGET
   METHOD ForceHide           BLOCK { |Self| HideWindow( ::hWnd ) }
   METHOD SaveData
   METHOD RefreshData
   METHOD AddBitMap

   METHOD IsHandle( hWnd )    BLOCK { | Self, hWnd | ( ::hWnd == hWnd ) }
//   METHOD MainControl         BLOCK { | Self | Self }
   METHOD DoEvent

   METHOD Events
   METHOD Events_Color
   METHOD Events_Enter
   METHOD Events_Command
   METHOD Events_Notify
   METHOD Events_VScroll      BLOCK { || nil }
   METHOD Events_Size         BLOCK { || nil }
   METHOD Events_DrawItem     BLOCK { || nil }
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
      SetToolTip( ::hWnd, cToolTip, ::Parent:ToolTipHandle )
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
LOCAL nPos

   ::StartInfo( -1 )

   // If PARENTFORM is a control
   If ValType( ParentForm ) == "O"
      If ParentForm:ClassName == "TFORM"
         ::Parent := ParentForm
         Return ::SetInfo( ControlName, FontName, FontSize, FontColor, BkColor, lEditBox, lRtl )
      Else
         ::Container := ParentForm
         ::Parent := ::Container:Parent
         Return ::SetInfo( ControlName, FontName, FontSize, FontColor, BkColor, lEditBox, lRtl )
      EndIf
   EndIf

   // Parent form:
   if ! empty( ParentForm )
      // Specified form
      If ! _IsWindowDefined( ParentForm )
         MsgOOHGError( "Window: "+ ParentForm + " is not defined. Program terminated." )
      Endif
      ::Parent := GetFormObject( ParentForm )
   elseif len( _OOHG_ActiveFrame ) > 0
      // Active frame
      ::Container := ATAIL( _OOHG_ActiveFrame )
      ::Parent := ::Container:Parent
   elseif LEN( _OOHG_ActiveForm ) > 0
      // Active form
      ::Parent := ATAIL( _OOHG_ActiveForm )
   else
      MsgOOHGError( "Window: No window name specified. Program terminated.")
   endif

   // Checks for an open "control container" structure in the specified parent form
   IF Empty( ::Container )
      nPos := 0
      ASCAN( _OOHG_ActiveFrame, { |o,i| IF( o:Parent:hWnd == ::Parent:hWnd, nPos := i, ) } )
      IF nPos > 0
         ::Container := _OOHG_ActiveFrame[ nPos ]
      ENDIF
   ENDIF

Return ::SetInfo( ControlName, FontName, FontSize, FontColor, BkColor, lEditBox, lRtl )

*------------------------------------------------------------------------------*
METHOD SetInfo( ControlName, FontName, FontSize, FontColor, BkColor, lEditBox, lRtl ) CLASS TControl
*------------------------------------------------------------------------------*
   // Font Name:
   if ! empty( FontName )
      // Specified font
      ::cFontName := FontName
   elseif ::Container != nil .AND. ! empty( ::Container:cFontName )
      // Container
      ::cFontName := ::Container:cFontName
   elseif ! empty( ::Parent:cFontName )
      // Parent form
      ::cFontName := ::Parent:cFontName
   else
       // Default
      ::cFontName := _OOHG_DefaultFontName
   endif

   // Font Size:
   if ! empty( FontSize )
      // Specified size
      ::nFontSize := FontSize
   elseif ::Container != nil .AND. ! empty( ::Container:nFontSize )
      // Container
      ::nFontSize := ::Container:nFontSize
   elseif ! empty( ::Parent:nFontSize )
      // Parent form
      ::nFontSize := ::Parent:nFontSize
   else
       // Default
      ::nFontSize := _OOHG_DefaultFontSize
   endif

   // Font Color:
   if ! empty( FontColor )
      // Specified color
      ::FontColor := FontColor
   elseif ::Container != nil .AND. ! empty( ::Container:FontColor )
      // Container
      ::FontColor := ::Container:FontColor
   elseif ! empty( ::Parent:FontColor )
      // Parent form
      ::FontColor := ::Parent:FontColor
   else
       // Default
   endif

   IF valtype( lEditBox ) == "L" .AND. lEditBox
      // Background Color (edit or listbox):
      if ! empty( BkColor )
         // Specified color
         ::BackColor := BkColor
      elseif ::Container != nil
         // Active frame
         ::BackColor := ::Container:DefBkColorEdit
      elseif ! Empty( ::Parent:DefBkColorEdit )
         // Active form
         ::BackColor := ::Parent:DefBkColorEdit
      else
          // Default
      endif
   ELSE
      // Background Color (static):
      if ! empty( BkColor )
         // Specified color
         ::BackColor := BkColor
      elseif ::Container != nil
         // Active frame
         ::BackColor := ::Container:BackColor
      elseif ! Empty( ::Parent:BackColor )
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
   ElseIf ValType( lRtl ) == "L"
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
METHOD New( hWnd, cName, HelpId, Visible, ToolTip, Id ) CLASS TControl
*------------------------------------------------------------------------------*
Local mVar

   // cName NO debe recibirse!!! Ya debe estar desde :SetForm()!!!!
*   ::Name   := _OOHG_GetNullName( ControlName )
EMPTY(cName)

   ::hWnd := hWnd
   ::SethWnd( hWnd )

   ::Parent:AddControl( Self )

   IF ::Container != nil
      ::Container:AddControl( Self )
   ENDIF

   IF VALTYPE( HelpId ) == "N"
      ::HelpId := HelpId
   ENDIF

   IF VALTYPE( Visible ) == "L"
      ::Visible := Visible
   ENDIF

   ::ToolTip := ToolTip

   IF VALTYPE( Id ) == "N"
      ::Id := Id
   ENDIF

   AADD( _OOHG_aControlhWnd,    hWnd )
   AADD( _OOHG_aControlObjects, Self )
   AADD( _OOHG_aControlIds,     ::Id )
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

   // Removes from container
   IF ::Container != nil
      ::Container:DeleteControl( Self )
   ENDIF

   // Attached controls
   DO WHILE LEN( ::aControls ) > 0
      ::aControls[ 1 ]:Release()
   ENDDO

   // Delete it from arrays
   mVar := aScan( _OOHG_aControlNames, { |c| c == UPPER( ::Parent:Name + CHR( 255 ) + ::Name ) } )
   IF mVar > 0
      _OOHG_DeleteArrayItem( _OOHG_aControlhWnd,    mVar )
      _OOHG_DeleteArrayItem( _OOHG_aControlObjects, mVar )
      _OOHG_DeleteArrayItem( _OOHG_aControlIds,     mVar )
      _OOHG_DeleteArrayItem( _OOHG_aControlNames,   mVar )
   ENDIF

   ::Parent:DeleteControl( Self )

   ReleaseControl( ::hWnd )

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
   IF ! EMPTY( FontSize ) .AND. VALTYPE( FontSize ) == "N"
      ::nFontSize := FontSize
   ENDIF
   IF VALTYPE( Bold ) == "L"
      ::Bold := Bold
   ENDIF
   IF VALTYPE( Italic ) == "L"
      ::Italic := Italic
   ENDIF
   IF VALTYPE( Underline ) == "L"
      ::Underline := Underline
   ENDIF
   IF VALTYPE( Strikeout ) == "L"
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
   If ValType( nFontSize ) == "N"
      ::SetFont( , nFontSize )
   EndIf
Return ::nFontSize

*-----------------------------------------------------------------------------*
METHOD FontBold( lBold ) CLASS TControl
*-----------------------------------------------------------------------------*
   If ValType( lBold ) == "L"
      ::SetFont( ,, lBold )
   EndIf
Return ::Bold

*-----------------------------------------------------------------------------*
METHOD FontItalic( lItalic ) CLASS TControl
*-----------------------------------------------------------------------------*
   If ValType( lItalic ) == "L"
      ::SetFont( ,,, lItalic )
   EndIf
Return ::Italic

*-----------------------------------------------------------------------------*
METHOD FontUnderline( lUnderline ) CLASS TControl
*-----------------------------------------------------------------------------*
   If ValType( lUnderline ) == "L"
      ::SetFont( ,,,, lUnderline )
   EndIf
Return ::Underline

*-----------------------------------------------------------------------------*
METHOD FontStrikeout( lStrikeout ) CLASS TControl
*-----------------------------------------------------------------------------*
   If ValType( lStrikeout ) == "L"
      ::SetFont( ,,,,, lStrikeout )
   EndIf
Return ::Strikeout

*-----------------------------------------------------------------------------*
METHOD SizePos( Row, Col, Width, Height ) CLASS TControl
*-----------------------------------------------------------------------------*
   IF VALTYPE( Row ) == "N"
      ::nRow := Row
   ENDIF
   IF VALTYPE( Col ) == "N"
      ::nCol := Col
   ENDIF
   IF VALTYPE( Width ) == "N"
      ::nWidth := Width
   ENDIF
   IF VALTYPE( Height ) == "N"
      ::nHeight := Height
   ENDIF
Return MoveWindow( ::hWnd, ::ContainerCol, ::ContainerRow, ::nWidth, ::nHeight , .T. )

*-----------------------------------------------------------------------------*
METHOD Move( Row, Col, Width, Height ) CLASS TControl
*-----------------------------------------------------------------------------*
Return ::SizePos( Row, Col, Width, Height )

*------------------------------------------------------------------------------*
METHOD Visible( lVisible ) CLASS TControl
*------------------------------------------------------------------------------*
   IF VALTYPE( lVisible ) == "L"
      ::lVisible := lVisible
      IF lVisible .AND. ::ContainerVisible
         CShowControl( ::hWnd )
      ELSE
         HideWindow( ::hWnd )
      ENDIF
      ProcessMessages()
   ENDIF
RETURN ::lVisible

*-----------------------------------------------------------------------------*
METHOD SaveData() CLASS TControl
*-----------------------------------------------------------------------------*
Return _OOHG_EVAL( ::Block, ::Value )

*-----------------------------------------------------------------------------*
METHOD RefreshData() CLASS TControl
*-----------------------------------------------------------------------------*
   ::Value := _OOHG_EVAL( ::Block )
   ::Refresh()
Return nil

*-----------------------------------------------------------------------------*
METHOD AddBitMap( uImage ) CLASS TControl
*-----------------------------------------------------------------------------*
Local nPos
   If ::ImageList == 0
      If ValType( uImage ) == "A"
         ::ImageList := ImageList_Init( uImage, ::ImageListColor, ::ImageListFlags )[ 1 ]
      Else
         ::ImageList := ImageList_Init( { uImage }, ::ImageListColor, ::ImageListFlags )[ 1 ]
      EndIf
      nPos := 1
   Else
      If ValType( uImage ) == "A"
         nPos := ImageList_Add( ::ImageList, uImage[ 1 ], ::ImageListFlags )
         AEVAL( ::ImageList, { |c| ImageList_Add( ::ImageList, c, ::ImageListFlags ) }, 2 )
      Else
         nPos := ImageList_Add( ::ImageList, uImage, ::ImageListFlags )
      EndIf
   Endif
   SendMessage( ::hWnd, ::SetImageListCommand, ::SetImageListWParam, ::ImageList )
Return nPos

*-----------------------------------------------------------------------------*
METHOD DoEvent( bBlock ) CLASS TControl
*-----------------------------------------------------------------------------*
Local lRetVal
	if valtype( bBlock )=='B'
		_PushEventInfo()
      _OOHG_ThisForm := ::Parent
      _OOHG_ThisType := 'C'
      _OOHG_ThisControl := Self
		Eval( bBlock )
		_PopEventInfo()

		lRetVal := .T.

	Else
		lRetVal := .F.
	EndIf

Return lRetVal

#pragma BEGINDUMP
#define s_Super s_Window

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

         // _OOHG_MouseRow := HIWORD( lParam ) - ::RowMargin
         // _OOHG_MouseCol := LOWORD( lParam ) - ::ColMargin
         if( wParam == MK_LBUTTON )
         {
            _OOHG_Send( pSelf, s_OnMouseDrag );
         }
         else
         {
            _OOHG_Send( pSelf, s_OnMouseMove );
         }
         hb_vmSend( 0 );
         if( hb_param( -1, HB_IT_BLOCK ) )
         {
            _OOHG_Send( pSelf, s_DoEvent );
            hb_vmPush( hb_param( -1, HB_IT_BLOCK ) );
            hb_vmPushString( "", 0 );
            hb_vmSend( 2 );
         }

         hb_ret();
         break;

      case WM_CONTEXTMENU:
//         if( _OOHG_ShowContextMenus )
         {
            SetFocus( hWnd );

            _OOHG_Send( pSelf, s_ContextMenu );
            hb_vmSend( 0 );
            if( hb_param( -1, HB_IT_OBJECT ) )
            {
               HWND hParent;
               HB_ITEM pContext;
               memcpy( &pContext, hb_param( -1, HB_IT_OBJECT ), sizeof( HB_ITEM ) );
               _OOHG_Send( pSelf, s_Parent );
               hb_vmSend( 0 );
               _OOHG_Send( hb_param( -1, HB_IT_OBJECT ), s_hWnd );
               hb_vmSend( 0 );
               hParent = ( HWND ) hb_parnl( -1 );

/*
               int iRow, iCol;

               // _OOHG_MouseRow := HIWORD(lParam) - ::RowMargin
               _OOHG_Send( pParent, s_RowMargin );
               hb_vmSend( 0 );
               iRow = HIWORD( lParam ) - hb_parni( -1 );
               // _OOHG_MouseCol := LOWORD(lParam) - ::ColMargin
               _OOHG_Send( pParent, s_ColMargin );
               hb_vmSend( 0 );
               iCol = LOWORD( lParam ) - hb_parni( -1 );
*/
               // HMENU
               _OOHG_Send( &pContext, s_hWnd );
               hb_vmSend( 0 );
               TrackPopupMenu( ( HMENU ) hb_parnl( -1 ), 0, ( int ) LOWORD( lParam ), ( int ) HIWORD( lParam ), 0, hParent, 0 );
               PostMessage( hParent, WM_NULL, 0, 0 );
               hb_ret();
            }
            else
            {
               hb_ret();
            }
         }
//         else
//         {
//            hb_ret();
//         }
         break;

      default:
         hb_ret();
         break;
   }
}

HB_FUNC_STATIC( TCONTROL_EVENTS_COLOR )   // METHOD Events_Color( wParam, ColorDefault ) CLASS TControl
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   HDC hdc = ( HDC ) hb_parnl( 1 );

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

   if( oSelf->lBackColor != -1 )
   {
      SetBkColor( hdc, ( COLORREF ) oSelf->lBackColor );
      DeleteObject( oSelf->BrushHandle );
      oSelf->BrushHandle = CreateSolidBrush( oSelf->lBackColor );
   }
   else
   {
      DeleteObject( oSelf->BrushHandle );
      oSelf->BrushHandle = CreateSolidBrush( GetSysColor( hb_parnl( 2 ) ) );
      SetBkColor( hdc, ( COLORREF ) GetSysColor( hb_parnl( 2 ) ) );
   }

   hb_retnl( ( LONG ) oSelf->BrushHandle );
}

#pragma ENDDUMP

/*
*-----------------------------------------------------------------------------*
METHOD Events_Color( wParam, ColorDefault ) CLASS TControl
*-----------------------------------------------------------------------------*
   // case nMsg == WM_CTLCOLORSTATIC
   // If ::Type == "LABEL" .Or. ::Type == "CHECKBOX" .Or. ::Type == "RADIOGROUP" .Or. ::Type == "FRAME" .Or. ::Type == "SLIDER"
   // ColorDefault := COLOR_3DFACE

   // case nMsg == WM_CTLCOLOREDIT .Or. nMsg == WM_CTLCOLORLISTBOX
   // If ::Type == "TEXT" .or. ::Type == "LIST" .or. ::Type == "SPINNER"
   // ColorDefault := COLOR_WINDOW

   If ::FontColor != Nil
      SetTextColor( wParam, ::FontColor[ 1 ], ::FontColor[ 2 ], ::FontColor[ 3 ] )
   EndIf

   If ::Transparent
      SetBkMode( wParam , TRANSPARENT )
      Return ( GetStockObject( NULL_BRUSH ) )
   EndIf

   If ! empty( ::BackColor )

      SetBkColor( wParam, ::BackColor[ 1 ], ::BackColor[ 2 ], ::BackColor[ 3 ] )
      DeleteObject( ::BrushHandle )
      ::BrushHandle := CreateSolidBrush( ::BackColor[ 1 ], ::BackColor[ 2 ], ::BackColor[ 3 ] )

   Else

      DeleteObject( ::BrushHandle )
      ::BrushHandle := CreateSolidBrush( GetRed ( GetSysColor ( ColorDefault ) ) , GetGreen ( GetSysColor ( ColorDefault ) ) , GetBlue ( GetSysColor ( ColorDefault ) ) )
      SetBkColor( wParam, GetRed ( GetSysColor( ColorDefault ) ) , GetGreen ( GetSysColor ( ColorDefault ) ) , GetBlue ( GetSysColor ( ColorDefault ) ) )

   EndIf

Return ::BrushHandle
*/

*-----------------------------------------------------------------------------*
METHOD Events_Command( wParam ) CLASS TControl
*-----------------------------------------------------------------------------*
Local Hi_wParam := HIWORD( wParam )

   If Hi_wParam == BN_CLICKED .OR. Hi_wParam == STN_CLICKED  // Same value.....

      // Default: ::OnClick
      // If ::Type == "LABEL" .Or. ::Type = "IMAGE" .OR. ::Type = "BUTTON"

      ::DoEvent( ::OnClick )

   elseif Hi_wParam == EN_CHANGE

      ::DoEvent( ::OnChange )

   elseif Hi_wParam == EN_KILLFOCUS

      If _OOHG_InteractiveCloseStarted != .T.
         ::DoEvent( ::OnLostFocus )
      EndIf

   elseif Hi_wParam == EN_SETFOCUS

      ::DoEvent( ::OnGotFocus )

   elseif Hi_wParam == BN_KILLFOCUS

      ::DoEvent( ::OnLostFocus )

   elseif Hi_wParam == BN_SETFOCUS

      ::DoEvent( ::OnGotFocus )

   EndIf

Return nil

*-----------------------------------------------------------------------------*
METHOD Events_Enter() CLASS TControl
*-----------------------------------------------------------------------------*

   // Default:
   // If ::Type == "COMBO"
   ::DoEvent( ::OnDblClick )

   If _OOHG_ExtendedNavigation == .T.

      _SetNextFocus()

   EndIf

Return nil

*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TControl
*-----------------------------------------------------------------------------*
static last := 0, cant := 0
Local nNotify := GetNotifyCode( lParam )
*Local aKeys
wParam++ // DUMMY...

   If nNotify == NM_KILLFOCUS
      ::DoEvent( ::OnLostFocus )

   elseif nNotify == NM_SETFOCUS
      ::DoEvent( ::OnGotFocus )

   elseif nNotify == NM_DBLCLK
      ::DoEvent( ::OnDblClick )

   elseif nNotify == TVN_SELCHANGED
      ::DoEvent( ::OnChange )

   EndIf

Return nil





*-----------------------------------------------------------------------------*
Function GetControlObject(ControlName,FormName)
*-----------------------------------------------------------------------------*
Local mVar
mVar := '_' + FormName + '_' + ControlName
Return IF( ( type( mVar ) != 'U' .AND. VALTYPE( &mVar ) == "O" ), &mVar, TControl() )

*-----------------------------------------------------------------------------*
Function GetControlObjectById( Id )
*-----------------------------------------------------------------------------*
Local i
   i := aScan( _OOHG_aControlIds, Id )
Return IF( i == 0, TControl(), _OOHG_aControlObjects[ i ] )

*-----------------------------------------------------------------------------*
Function _GetId()
*-----------------------------------------------------------------------------*
Local RetVal , i

	do while .t.

      RetVal := Int( random( 65000 ) )

      i := ascan ( _OOHG_aControlIds , retval )

		if i == 0 .and. retval != 0
			exit
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
   _OOHG_lMultiple := lMultiple
   If ! _OOHG_lMultiple .AND. ;
      ( EMPTY( CreateMutex( , .T., strtran(GetModuleFileName(),'\','_') ) ) .OR. (GetLastError() > 0) )
      If ValType( lWarning ) == "L" .AND. lWarning
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
   _OOHG_Init_C_Vars_Controls_C_Side( _OOHG_aControlhWnd, _OOHG_aControlObjects )
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