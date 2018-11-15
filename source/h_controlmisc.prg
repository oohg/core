/*
 * $Id: h_controlmisc.prg $
 */
/*
 * ooHG source code:
 * Generic control and miscelaneous related functions
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
#include "hbclass.ch"
#include "common.ch"
#include "i_windefs.ch"

STATIC _OOHG_aControlhWnd := {}, _OOHG_aControlObjects := {}         // TODO: Thread safe?
STATIC _OOHG_aControlIds := {},  _OOHG_aControlNames := {}           // TODO: Thread safe?

STATIC _OOHG_lSettingFocus := .F.     // If there's a ::SetFocus() call inside ON ENTER event.
STATIC _OOHG_lValidating := .F.       // If there's a ::SetFocus() call inside ON ENTER event.

#pragma BEGINDUMP
#include "hbapi.h"
#include "hbapiitm.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windows.h>
#include <commctrl.h>
#include "oohg.h"
#pragma ENDDUMP

Function _Getvalue( ControlName, ParentForm )

   Return GetControlObject( ControlName, ParentForm ):Value

Function _Setvalue( ControlName, ParentForm, Value )

   Return ( GetControlObject( ControlName, ParentForm ):Value := Value )

Function _AddItem( ControlName, ParentForm, Value )

   Return GetControlObject( ControlName, ParentForm ):AddItem( Value )

Function _DeleteItem( ControlName, ParentForm, Value )

   Return GetControlObject( ControlName, ParentForm ):DeleteItem( Value )

Function _DeleteAllItems( ControlName, ParentForm )

   Return GetControlObject( ControlName, ParentForm ):DeleteAllItems()

Function GetControlName( ControlName, ParentForm )

   Return GetControlObject( ControlName, ParentForm ):Name

Function GetControlHandle( ControlName, ParentForm )

   Return GetControlObject( ControlName, ParentForm ):hWnd

Function GetControlContainerHandle( ControlName, ParentForm )

   Return GetControlObject( ControlName, ParentForm ):Container:hWnd

Function GetControlParentHandle( ControlName, ParentForm )

   Return GetControlObject( ControlName, ParentForm ):ContainerhWnd     // :Parent:hWnd

Function GetControlId( ControlName, ParentForm )

   Return GetControlObject( ControlName, ParentForm ):Id

Function GetControlType( ControlName, ParentForm )

   Return GetControlObject( ControlName, ParentForm ):Type

Function GetControlValue( ControlName, ParentForm )

   Return GetControlObject( ControlName, ParentForm ):Value

Function _IsControlDefined( ControlName, FormName )

   Local mVar

   mVar := '_' + FormName + '_' + ControlName

   Return ( Type( mVar ) == "O" .AND. ( &mVar ):hWnd != -1 )

Function _SetFocus( ControlName, ParentForm )

   Return GetControlObject( ControlName , ParentForm ):SetFocus()

Function _DisableControl( ControlName, ParentForm )

   Return GetControlObject( ControlName, ParentForm ):Enabled := .F.

Function _EnableControl( ControlName, ParentForm )

   Return GetControlObject( ControlName, ParentForm ):Enabled := .T.

Function _ShowControl( ControlName, ParentForm )

   Return GetControlObject( ControlName, ParentForm ):Show()

Function _HideControl( ControlName, ParentForm )

   Return GetControlObject( ControlName, ParentForm ):Hide()

Function _SetItem( ControlName, ParentForm, Item, Value )

   Return GetControlObject( ControlName, ParentForm ):Item( Item, Value )

Function _GetItem( ControlName, ParentForm, Item )

   Return GetControlObject( Controlname, ParentForm ):Item( Item )

Function _SetControlSizePos( ControlName, ParentForm, row, col, width, height )

   Return GetControlObject( Controlname, ParentForm ):SizePos( row, col, width, height )

Function _GetItemCount( ControlName, ParentForm )

   Return GetControlObject( Controlname, ParentForm ):ItemCount

Function _GetControlRow( ControlName, ParentForm )

   Return GetControlObject( ControlName, ParentForm ):Row

Function _GetControlCol( ControlName, ParentForm )

   Return GetControlObject( ControlName, ParentForm ):Col

Function _GetControlWidth( ControlName, ParentForm )

   Return GetControlObject( ControlName, ParentForm ):Width

Function _GetControlHeight( ControlName, ParentForm )

   Return GetControlObject( ControlName, ParentForm ):Height

Function _SetControlCol( ControlName, ParentForm, Value )

   Return GetControlObject( ControlName, ParentForm ):SizePos( , Value )

Function _SetControlRow( ControlName, ParentForm, Value )

   Return GetControlObject( ControlName, ParentForm ):SizePos( Value )

Function _SetControlWidth( ControlName, ParentForm, Value )

   Return GetControlObject( ControlName, ParentForm ):SizePos( , , Value )

Function _SetControlHeight( ControlName, ParentForm, Value )

   Return GetControlObject( ControlName, ParentForm ):SizePos( , , , Value )

Function _SetPicture( ControlName, ParentForm, FileName )

   Return GetControlObject( ControlName, ParentForm ):Picture := FileName

Function _GetPicture( ControlName, ParentForm )

   Return GetControlObject( ControlName, ParentForm ):Picture

Function _GetControlAction( ControlName, ParentForm )

   Return GetControlObject( ControlName, ParentForm ):OnClick

Function _GetToolTip( ControlName, ParentForm )

   Return GetControlObject( ControlName, ParentForm ):ToolTip

Function _SetToolTip( ControlName, ParentForm, Value  )

   Return GetControlObject( ControlName, ParentForm ):ToolTip := Value

Function _SetRangeMin( ControlName, ParentForm, Value  )

   Return ( GetControlObject( ControlName, ParentForm ):RangeMin := Value )

Function _SetRangeMax( ControlName, ParentForm, Value  )

   Return ( GetControlObject( ControlName, ParentForm ):RangeMax := Value )

Function _GetRangeMin( ControlName, ParentForm )

   Return GetControlObject( ControlName, ParentForm ):RangeMin

Function _GetRangeMax( ControlName, ParentForm )

   Return GetControlObject( ControlName, ParentForm ):RangeMax

Function _SetMultiCaption( ControlName, ParentForm, Column, Value )

   Return GetControlObject( ControlName, ParentForm ):Caption( Column, Value )

Function _GetMultiCaption( ControlName, ParentForm, Item )

   Return GetControlObject( ControlName, ParentForm ):Caption( Item )

Function InputWindow( Title, aLabels, aValues, aFormats, row, col, aButOKCancelCaptions, nLabelWidth, nControlWidth, nButtonWidth )

   Local i, l, ControlRow, e := 0, LN, CN, r, c, nHeight, diff
   Local oInputWindow, aResult, nWidth, ControlCol, nSep

   If ! HB_IsArray( aButOKCancelCaptions ) .OR. Len( aButOKCancelCaptions ) < 2
      aButOKCancelCaptions := { _OOHG_Messages( 1, 6 ), _OOHG_Messages( 1, 7 ) }
   EndIf

   If ! HB_IsNumeric( nLabelWidth ) .OR. nLabelWidth <= 10
      nLabelWidth := 110
   EndIf

   If ! HB_IsNumeric( nControlWidth ) .OR. nControlWidth <= 10
      nControlWidth := 140
   EndIf

   If ! HB_IsNumeric( nButtonWidth ) .OR. nButtonWidth <= 30
      nButtonWidth := 100
   EndIf

   l := Len( aLabels )

   aResult := Array( l )

   For i := 1 to l
      If ValType( aValues[i] ) == 'C'
         If HB_IsNumeric( aFormats[i] )
            If aFormats[i] > 32
               e++
            Endif
         EndIf
      EndIf

      if HB_IsMemo( aValues[i] )
         e++
      EndIf
   Next i

   If ! HB_IsNumeric( row ) .or. ! HB_IsNumeric( col )
      r := 0
      c := 0
   Else
      r := row
      c := col
      nHeight := ( l * 30 ) + 90 + ( e * 60 )

      If r + nHeight > GetDeskTopHeight()
         diff :=  r + nHeight - GetDeskTopHeight()
         r := r - diff
      EndIf
   EndIf

   nWidth := Max( nLabelWidth + nControlWidth + 30, nButtonWidth * 2 + 30 )

   ControlCol := nLabelWidth + 10

   DEFINE WINDOW _InputWindow OBJ oInputWindow ;
      AT r,c ;
      CLIENTAREA ;
      WIDTH nWidth ;
      HEIGHT ( l * 30 ) + 90 + ( e * 60 ) ;
      TITLE Title ;
      MODAL ;
      NOSIZE ;
      BACKCOLOR ( GetFormObjectByHandle( GetActiveWindow() ):BackColor )

      ControlRow :=  10

      For i := 1 to l
         LN := 'Label_' + Alltrim( Str( i, 2, 0 ) )
         CN := 'Control_' + Alltrim( Str( i, 2, 0 ) )

         @ ControlRow, 10 LABEL &LN OF _InputWindow VALUE aLabels[i] WIDTH nLabelWidth NOWORDWRAP

         Do Case
         Case HB_IsLogical( aValues[i] )
            @ ControlRow, ControlCol CHECKBOX &CN OF _InputWindow CAPTION '' VALUE aValues[i] WIDTH nControlWidth
            ControlRow := ControlRow + 30

         Case HB_IsDate( aValues[i] )
            If ValType( aFormats[i] ) $ 'CM' .AND. upper( aFormats[i] ) == "SHOWNONE"
               @ ControlRow, ControlCol DATEPICKER &CN  OF _InputWindow VALUE aValues[i] WIDTH nControlWidth SHOWNONE
               ControlRow := ControlRow + 30
            Else
               @ ControlRow, ControlCol DATEPICKER &CN  OF _InputWindow VALUE aValues[i] WIDTH nControlWidth
               ControlRow := ControlRow + 30
            EndIf

         Case HB_IsNumeric( aValues[i] )
            If HB_IsArray( aFormats[i] )
               @ ControlRow, ControlCol COMBOBOX &CN  OF _InputWindow ITEMS aFormats[i] VALUE aValues[i] WIDTH nControlWidth  FONT 'Arial' SIZE 10
               ControlRow := ControlRow + 30
            ElseIf  ValType( aFormats[i] ) $ 'CM'
               If At( '.', aFormats[i] ) > 0
                  @ ControlRow, ControlCol TEXTBOX &CN  OF _InputWindow VALUE aValues[i] WIDTH nControlWidth FONT 'Arial' SIZE 10 NUMERIC INPUTMASK aFormats[i]
               Else
                  @ ControlRow, ControlCol TEXTBOX &CN  OF _InputWindow VALUE aValues[i] WIDTH nControlWidth FONT 'Arial' SIZE 10 MAXLENGTH Len( aFormats[i] ) NUMERIC
               EndIf
               ControlRow := ControlRow + 30
            Endif

         Case ValType( aValues[i] ) == 'C'
            If HB_IsNumeric( aFormats[i] )
               If  aFormats[i] <= 32
                  @ ControlRow, ControlCol TEXTBOX &CN  OF _InputWindow VALUE aValues[i] WIDTH nControlWidth FONT 'Arial' SIZE 10 MAXLENGTH aFormats[i]
                  ControlRow := ControlRow + 30
               Else
                  @ ControlRow, ControlCol EDITBOX &CN  OF _InputWindow WIDTH nControlWidth HEIGHT 90 VALUE aValues[i] FONT 'Arial' SIZE 10 MAXLENGTH aFormats[i]
                  ControlRow := ControlRow + 94
               EndIf
            EndIf

         Case HB_IsMemo( aValues[i] )
            @ ControlRow, ControlCol EDITBOX &CN  OF _InputWindow WIDTH nControlWidth HEIGHT 90 VALUE aValues[i] FONT 'Arial' SIZE 10
            ControlRow := ControlRow + 94

         EndCase
      Next i

      nSep := int( ( nWidth - 2 * nButtonWidth ) / 3 )

      @ ControlRow + 10, nSep BUTTON BUTTON_1 ;
         OF _InputWindow ;
         WIDTH nButtonWidth ;
         CAPTION aButOKCancelCaptions[1] ;
         ACTION _InputWindowOk( oInputWindow, aResult )

      @ ControlRow + 10, ( nWidth - nSep - nButtonWidth) BUTTON BUTTON_2 ;
         OF _InputWindow ;
         WIDTH nButtonWidth ;
         CAPTION aButOKCancelCaptions[2] ;
         ACTION _InputWindowCancel( oInputWindow, aResult )

      oInputWindow:ClientHeight := ControlRow + 10 + oInputWindow:BUTTON_1:Height + 10

      oInputWindow:Control_1:SetFocus()
   END WINDOW

   If ! HB_IsNumeric( row ) .or. ! HB_IsNumeric( col )
      oInputWindow:Center()
   EndIf

   oInputWindow:Activate()

   Return aResult

Function _InputWindowOk( oInputWindow, aResult )

   Local i , l

   l := len( aResult )
   For i := 1 to l
      aResult[ i ] := oInputWindow:Control( 'Control_' + Alltrim( Str( i ) ) ):Value
   Next i
   oInputWindow:Release()

   Return Nil

Function _InputWindowCancel( oInputWindow, aResult )

   afill( aResult, NIL )
   oInputWindow:Release()

   Return Nil

Function _ReleaseControl( ControlName, ParentForm )

   Return GetControlObject( ControlName, ParentForm ):Release()

Function _IsControlVisibleFromHandle( Handle )

   Return GetControlObjectByHandle( Handle ):ContainerVisible

Function _SetCaretPos( ControlName, FormName, Pos )

   Return ( GetControlObject( ControlName, FormName ):CaretPos := Pos )

Function _GetCaretPos( ControlName, FormName )

   Return GetControlObject( ControlName, FormName ):CaretPos

Function DefineProperty( cProperty, cControlName, cFormName, xValue )

   Local oCtrl

   If HB_IsObject( cFormName )
      oCtrl := cFormName
   ElseIf HB_IsString( cControlName )
      oCtrl := GetExistingControlObject( cControlName, cFormName )
   Else
      oCtrl := GetExistingFormObject( cFormName )
   EndIf
   oCtrl:Property( cProperty, xValue )

   Return oCtrl:Property( cProperty )

Function SetProperty( Arg1, Arg2, Arg3, Arg4, Arg5, Arg6 )

   Local oWnd, oCtrl, nPos

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

      ElseIf Arg2 == "CLOSABLE"
         oWnd:Closeable := Arg3

      Else
         // Pseudo-property
         nPos := ASCAN( oWnd:aProperties, { |a| a[ 1 ] == Arg2 } )
         If nPos > 0
            oWnd:aProperties[ nPos ][ 2 ] := Arg3
         EndIf

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

      ElseIf Arg3 == "READONLY" .OR. Arg3 == "DISABLEEDIT"
         oCtrl:ReadOnly := Arg4

      ElseIf Arg3 == "ITEMCOUNT"
         ListView_SetItemCount( oCtrl:hWnd, Arg4 )

      ElseIf Arg3 == "GETPARENT"
         oCtrl:GetParent( Arg4 )

      ElseIf Arg3 == "GETCHILDREN"
         oCtrl:GetChildren( Arg4 )

      ElseIf Arg3 == "INDENT"
         oCtrl:Indent( Arg4 )

      ElseIf Arg3 == "SELCOLOR"
         oCtrl:SelColor( Arg4 )

      ElseIf Arg3 == "ONCHANGE"
         oCtrl:OnChange := Arg4

      ElseIf Arg3 == "MAXLENGTH"
         oCtrl:MaxLength := Arg4

      Else
         // Pseudo-property
         nPos := ASCAN( oCtrl:aProperties, { |a| a[ 1 ] == Arg3 } )
         If nPos > 0
            oCtrl:aProperties[ nPos ][ 2 ] := Arg4
         EndIf

      EndIf

   ElseIf Pcount() == 5 // CONTROL (WITH ARGUMENT OR TOOLBAR BUTTON)

      oCtrl := GetExistingControlObject( Arg2, Arg1 )
      Arg3 := Upper( Arg3 )

      If Arg3 == "CAPTION"
         oCtrl:Caption( Arg4, Arg5 )

      ElseIf Arg3 == "HEADER"
         oCtrl:Header( Arg4, Arg5 )

      ElseIf Arg3 == "ITEM"
         oCtrl:Item( Arg4, Arg5 )

      ElseIf Arg3 == "CHECKITEM"
         oCtrl:CheckItem( Arg4, Arg5 )

      ElseIf Arg3 == "BOLDITEM"
         oCtrl:BoldItem( Arg4, Arg5 )

      ElseIf Arg3 == "ITEMREADONLY"
         oCtrl:ItemReadonly( Arg4, Arg5 )

      ElseIf Arg3 == "ITEMENABLED"
         oCtrl:ItemEnabled( Arg4, Arg5 )

      ElseIf Arg3 == "ENABLED"
         oCtrl:ItemEnabled( Arg4, Arg5 )

      ElseIf Arg3 == "ITEMDRAGGABLE"
         oCtrl:ItemDraggable( Arg4, Arg5 )

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
Local RetVal, oWnd, oCtrl, nPos

   If Pcount() == 2 // WINDOW

      oWnd := GetExistingFormObject( Arg1 )
      Arg2 := Upper( Arg2 )

      If Arg2 == 'TITLE'
         RetVal := oWnd:Title

      ElseIf Arg2 == 'FOCUSEDCONTROL'
         RetVal := oWnd:FocusedControl()

      ElseIf Arg2 == 'NAME'
         RetVal := oWnd:Name

      ElseIf Arg2 == 'HEIGHT'
         RetVal := oWnd:Height

      ElseIf Arg2 == 'WIDTH'
         RetVal := oWnd:Width

      ElseIf Arg2 == 'CLOSABLE'
         RetVal := oWnd:Closable

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

      Else
         // Pseudo-property
         nPos := ASCAN( oWnd:aProperties, { |a| a[ 1 ] == Arg2 } )
         If nPos > 0
            RetVal := oWnd:aProperties[ nPos ][ 2 ]
         EndIf

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

      ElseIf Arg3 == 'MAXLENGTH'
         RetVal := oCtrl:MaxLength

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

      ElseIf Arg3 == "INDENT"
         RetVal := oCtrl:Indent()

      ElseIf Arg3 == "SELCOLOR"
         RetVal := oCtrl:SelColor()

      ElseIf Arg3 == "READONLY" .OR. Arg3 == "DISABLEEDIT"
         RetVal := oCtrl:ReadOnly()

      Else
         // Pseudo-property
         nPos := ASCAN( oCtrl:aProperties, { |a| a[ 1 ] == Arg3 } )
         If nPos > 0
            RetVal := oCtrl:aProperties[ nPos ][ 2 ]
         EndIf

      EndIf

   ElseIf Pcount() == 4 // CONTROL (WITH ARGUMENT OR TOOLBAR BUTTON)

      oCtrl := GetExistingControlObject( Arg2, Arg1 )
      Arg3 := Upper( Arg3 )

      If     Arg3 == "ITEM"
         RetVal := oCtrl:Item( Arg4 )

      ElseIf Arg3 == "CAPTION"
         RetVal := oCtrl:Caption( Arg4 )

      ElseIf Arg3 == "HEADER"
         RetVal := oCtrl:Header( Arg4 )

      ElseIf Arg3 == "COLUMNWIDTH"
         RetVal := oCtrl:ColumnWidth( Arg4 )

      ElseIf Arg3 == "PICTURE"
         RetVal := oCtrl:Picture( Arg4 )

      ElseIf Arg3 == "IMAGE"
         RetVal := oCtrl:Picture( Arg4 )

      ElseIf Arg3 == "GETPARENT"
         RetVal := oCtrl:GetParent( Arg4 )

      ElseIf Arg3 == "GETCHILDREN"
         RetVal := oCtrl:GetChildren( Arg4 )

      ElseIf Arg3 == "CHECKITEM"
         RetVal := oCtrl:CheckItem( Arg4 )

      ElseIf Arg3 == "BOLDITEM"
         RetVal := oCtrl:BoldItem( Arg4 )

      ElseIf Arg3 == "ITEMREADONLY"
         RetVal := oCtrl:ItemReadonly( Arg4 )

      ElseIf Arg3 == "ITEMENABLED"
         RetVal := oCtrl:ItemEnabled( Arg4 )

      ElseIf Arg3 == "ENABLED"
         RetVal := oCtrl:ItemEnabled( Arg4 )

      ElseIf Arg3 == "ITEMDRAGGABLE"
         RetVal := oCtrl:ItemDraggable( Arg4 )

      ElseIf Arg3 == "HANDLETOITEM"
         RetVal := oCtrl:HandleToItem( Arg4 )

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

Function DoMethod( ... )

   Local RetVal, aPars, cMethod, oWnd, oCtrl

   RetVal := Nil

   If PCount() == 2 // WINDOW
      aPars := HB_aParams()

      cMethod := Upper( aPars[2] )

      If cMethod == 'ACTIVATE'
         If HB_IsArray( aPars[1] )
            RetVal := _ActivateWindow( aPars[1] )
         Else
            oWnd := GetExistingFormObject( aPars[1] )
            RetVal := oWnd:Activate()
         EndIf
      ElseIf cMethod == 'SETFOCUS'
         If oWnd:Active
            oWnd := GetExistingFormObject( aPars[1] )
            RetVal := oWnd:SetFocus()
         EndIf
      Else
         oWnd := GetExistingFormObject( aPars[1] )
         If _OOHG_HasMethod( oWnd, cMethod )
            RetVal := oWnd:&( cMethod )()
         EndIf
      EndIf

   ElseIf PCount() > 2
      aPars := HB_aParams()

      oCtrl := GetExistingControlObject( aPars[2], aPars[1] )
      cMethod := Upper( aPars[3] )

      If PCount() == 3 // CONTROL WITHOUT ARGUMENTS
         If cMethod == 'SAVE'
            RetVal := oCtrl:SaveData()
         ElseIf cMethod == 'ACTION'
            RetVal := oCtrl:DoEvent( oCtrl:OnClick, "CLICK" )
         ElseIf cMethod == 'ONCLICK'
            RetVal := oCtrl:DoEvent( oCtrl:OnClick, "CLICK" )
         ElseIf cMethod == 'ONGOTFOCUS'
            RetVal := oCtrl:DoEvent( oCtrl:OnGotFocus, "GOTFOCUS" )
         ElseIf cMethod == 'ONLOSTFOCUS'
            RetVal := oCtrl:DoEvent( oCtrl:OnLostFocus, "LOSTFOCUS" )
         ElseIf cMethod == 'ONDBLCLICK'
            RetVal := oCtrl:DoEvent( oCtrl:OnDblClick, "DBLCLICK" )
         ElseIf cMethod == 'ONCHANGE'
            RetVal := oCtrl:DoEvent( oCtrl:OnChange, "CHANGE" )
         ElseIf _OOHG_HasMethod( oCtrl, cMethod )
            RetVal := oCtrl:&( cMethod )()
         EndIf

      Else // CONTROL WITH ARGUMENTS
         // Handle exceptions
         If PCount() == 7
            If cMethod == 'ADDCONTROL'
               RetVal := oCtrl:AddControl( GetControlObject( aPars[4], aPars[1] ), aPars[5], aPars[6], aPars[7] )

               Return RetVal
            EndIf
         EndIf

         // Handle other methods
         If _OOHG_HasMethod( oCtrl, cMethod )
            aDel( aPars, 1 )
            aDel( aPars, 1 )
            aDel( aPars, 1 )
            aSize( aPars, Len( aPars ) - 3 )

            RetVal := HB_ExecFromArray( oCtrl, cMethod, aPars )
         EndIf
      EndIf
   EndIf

   Return RetVal

/*
 * This function returns .T. if msg is a METHOD (with or without SETGET)
 * or an INLINE (even if in the parent class msg is a DATA).
 *
 * Note:
 * __objHasMethod( obj, msg ) doesn't recognizes SETGET methods as METHOD.
 */

Function _OOHG_HasMethod( obj, msg )

   Local itm, aClsSel

   #ifndef __XHARBOUR__
   aClsSel := obj:ClassSel( HB_MSGLISTPURE, HB_OO_CLSTP_EXPORTED, .T. )
   #else
   aClsSel := obj:ClassFullSel( HB_MSGLISTPURE, HB_OO_CLSTP_EXPORTED )
   #endif

   For EACH itm in aClsSel
      If itm[ HB_OO_DATA_TYPE ] == HB_OO_MSG_METHOD .or. itm[ HB_OO_DATA_TYPE ] == HB_OO_MSG_INLINE
          If itm[ HB_OO_DATA_SYMBOL ] == msg
             Return .T.
          EndIf
      EndIf
   Next

   Return .F.

/*
 * This function returns .T. only if msg is a pure DATA.
 *
 * Note:
 * __objHasData( obj, msg ) recognizes SETGET methods as DATA.
 */

Function _OOHG_HasData( obj, msg )

   Local itm, aClsSel

   #ifndef __XHARBOUR__
   aClsSel := obj:ClassSel( HB_MSGLISTPURE, HB_OO_CLSTP_EXPORTED, .T. )
   #else
   aClsSel := obj:ClassFullSel( HB_MSGLISTPURE, HB_OO_CLSTP_EXPORTED )
   #endif

   For EACH itm in aClsSel
      If itm[ HB_OO_DATA_TYPE ] == HB_OO_MSG_DATA
          If itm[ HB_OO_DATA_SYMBOL ] ==  msg
             Return .T.
          EndIf
      EndIf
   Next

   Return .F.

Function cFileNoPath( cPathMask )

   local n := RAt( "\", cPathMask )

   Return If( n > 0 .and. n < Len( cPathMask ), ;
          Right( cPathMask, Len( cPathMask ) - n ), ;
          If( ( n := At( ":", cPathMask ) ) > 0, ;
          Right( cPathMask, Len( cPathMask ) - n ), cPathMask ) )

Function cFileNoExt( cPathMask )

   local cName := AllTrim( cFileNoPath( cPathMask ) )
   local n     := At( ".", cName )

   Return AllTrim( If( n > 0, Left( cName, n - 1 ), cName ) )

Function NoArray( OldArray )

   Local NewArray := {}
   Local i

   If ValType ( OldArray ) == 'U'
      Return Nil
   Else
      aSize( NewArray , Len (OldArray) )
   EndIf

   For i := 1 To Len ( OldArray )

      If OldArray [i] == .t.
         NewArray [i] := .f.
      Else
         NewArray [i] := .t.
      EndIf

   Next i

   Return NewArray

FUNCTION _GetFontName( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):cFontName

FUNCTION _GetFontSize( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):nFontSize

FUNCTION _GetFontBold( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):Bold

FUNCTION _GetFontItalic( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):Italic

FUNCTION _GetFontUnderline( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):Underline

FUNCTION _GetFontStrikeOut( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):Strikeout

FUNCTION _GetFontAngle( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):FntAngle

FUNCTION _GetFontCharset( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):FntCharset

FUNCTION _GetFontWidth( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):FntWidth

FUNCTION _GetFontOrientation( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):FntOrientation

FUNCTION _GetFontAdvancedGM( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):FntAdvancedGM

FUNCTION _SetFontName( ControlName, ParentForm, Value )

   RETURN GetControlObject( ControlName, ParentForm ):SetFont( Value )

FUNCTION _SetFontSize( ControlName, ParentForm, Value )

   RETURN GetControlObject( ControlName, ParentForm ):SetFont( , Value )

FUNCTION _SetFontBold( ControlName, ParentForm, Value )

   RETURN GetControlObject( ControlName, ParentForm ):SetFont( , , Value )

FUNCTION _SetFontItalic( ControlName, ParentForm, Value )

   RETURN GetControlObject( ControlName, ParentForm ):SetFont( , , , Value )

FUNCTION _SetFontUnderline( ControlName, ParentForm, Value ) 

   RETURN GetControlObject( ControlName, ParentForm ):SetFont( , , , , Value )

FUNCTION _SetFontStrikeOut( ControlName, ParentForm, Value )

   RETURN GetControlObject( ControlName, ParentForm ):SetFont( , , , , , Value )

FUNCTION _SetFontAngle( ControlName, ParentForm, Value )

   RETURN GetControlObject( ControlName, ParentForm ):SetFont( , , , , , , Value )

FUNCTION _SetFontCharset( ControlName, ParentForm, Value )

   RETURN GetControlObject( ControlName, ParentForm ):SetFont( , , , , , , , Value )

FUNCTION _SetFontWidth( ControlName, ParentForm, Value )

   RETURN GetControlObject( ControlName, ParentForm ):SetFont( , , , , , , , , Value )

FUNCTION _SetFontOrientation( ControlName, ParentForm, Value )

   RETURN GetControlObject( ControlName, ParentForm ):SetFont( , , , , , , , , , Value )

FUNCTION _SetFontAdvancedGM( ControlName, ParentForm, Value )

   RETURN GetControlObject( ControlName, ParentForm ):SetFont( , , , , , , , , , , Value )

FUNCTION _SetFontColor( ControlName, ParentForm, Value )

   RETURN ( GetControlObject( ControlName, ParentForm ):FontColor := Value )

FUNCTION _SetBackColor( ControlName, ParentForm, Value )

   RETURN ( GetControlObject( ControlName, ParentForm ):BackColor := Value )

FUNCTION _SetStatusIcon( ControlName, ParentForm, Item, Icon )

   RETURN SetStatusItemIcon( GetControlObject( ControlName, ParentForm ):hWnd, Item, Icon )

FUNCTION _GetCaption( ControlName, ParentForm )

   RETURN GetWindowText( GetControlObject( ControlName, ParentForm ):hWnd )


CLASS TControl FROM TWindow

   DATA oToolTipCtrl         INIT Nil
   DATA cToolTip             INIT ""
   DATA AuxHandle            INIT 0
   DATA Transparent          INIT .F.
   DATA HelpId               INIT 0
   DATA OnChange             INIT nil
   DATA Id                   INIT 0
   DATA ImageListColor       INIT CLR_NONE
   DATA ImageListFlags       INIT LR_LOADTRANSPARENT
   DATA SetImageListCommand  INIT 0   // Must be explicit for each control
   DATA SetImageListWParam   INIT TVSIL_NORMAL
   DATA hCursor              INIT 0
   DATA postBlock            INIT nil
   DATA lCancel              INIT .F.
   DATA OnEnter              INIT nil
   DATA xOldValue            INIT nil
   DATA OldValue             INIT nil
   DATA OldColor
   DATA OldBackColor
   DATA oBkGrnd              INIT NIL

   METHOD Row                SETGET
   METHOD Col                SETGET
   METHOD Width              SETGET
   METHOD Height             SETGET
   METHOD ToolTip            SETGET
   METHOD SetForm
   METHOD InitStyle
   METHOD Register
   METHOD AddToCtrlsArrays
   METHOD DelFromCtrlsArrays
   METHOD TabIndex           SETGET
   METHOD Refresh            BLOCK { |Self| ::ReDraw() }
   METHOD Release
   METHOD SetFont
   METHOD FocusEffect
   METHOD ContainerRow       BLOCK { |Self| IF( ::Container != NIL, IF( ValidHandler( ::Container:ContainerhWndValue ), 0, ::Container:ContainerRow ) + ::Container:RowMargin, ::Parent:RowMargin ) + ::Row }
   METHOD ContainerCol       BLOCK { |Self| IF( ::Container != NIL, IF( ValidHandler( ::Container:ContainerhWndValue ), 0, ::Container:ContainerCol ) + ::Container:ColMargin, ::Parent:ColMargin ) + ::Col }
   METHOD ContainerhWnd      BLOCK { |Self| IF( ::Container == NIL, ::Parent:hWnd, if( ValidHandler( ::Container:ContainerhWndValue ), ::Container:ContainerhWndValue, ::Container:ContainerhWnd ) ) }
   METHOD FontName           SETGET
   METHOD FontSize           SETGET
   METHOD FontBold           SETGET
   METHOD FontItalic         SETGET
   METHOD FontUnderline      SETGET
   METHOD FontStrikeout      SETGET
   METHOD FontAngle          SETGET
   METHOD FontCharset        SETGET
   METHOD FontWidth          SETGET
   METHOD FontOrientation    SETGET
   METHOD FontAdvancedGM     SETGET
   METHOD SizePos
   METHOD Move
   METHOD ForceHide
   METHOD SetFocus           BLOCK { |Self| _OOHG_lSettingFocus := .T., GetFormObjectByHandle( ::ContainerhWnd ):LastFocusedControl := ::hWnd, ::Super:SetFocus() }
   METHOD SetVarBlock
   METHOD AddBitMap
   METHOD ClearBitMaps
   METHOD DoEvent
   METHOD DoEventMouseCoords
   METHOD DoLostFocus
   METHOD DoChange
   METHOD oToolTip           SETGET
   METHOD Events
   METHOD Events_Color
   METHOD Events_Enter
   METHOD Events_Command
   METHOD Events_Notify
   METHOD Events_DrawItem    BLOCK { || nil }
   METHOD Events_MeasureItem BLOCK { || nil }
   METHOD Cursor             SETGET


   ENDCLASS

METHOD Cursor( hCursor ) CLASS TControl

   IF PCOUNT() > 0
      IF VALTYPE( hCursor ) == "N"
        ::hCursor := LoadCursor( NIL, hCursor )
        IF ::hCursor == 0 .AND. hCursor == IDC_HAND
           ::hCursor := LoadCursor( GetInstance(), 'MINIGUI_FINGER' )
        ENDIF
      ELSEIF VALTYPE( hCursor ) $ "CM"
        ::hCursor := LoadCursor( GetInstance(), hCursor )
        IF ::hCursor == 0
           ::hCursor := LoadCursorFromFile( hCursor )
        ENDIF
      ENDIF
   ENDIF

   RETURN ::hCursor

METHOD Row( nRow ) CLASS TControl

   IF PCOUNT() > 0
      ::SizePos( nRow )
   ENDIF

   RETURN ::nRow

METHOD Col( nCol ) CLASS TControl

   IF PCOUNT() > 0
      ::SizePos( , nCol )
   ENDIF

   RETURN ::nCol

METHOD Width( nWidth ) CLASS TControl

   IF PCOUNT() > 0
      ::SizePos( , , nWidth )
   ENDIF

   RETURN ::nWidth

METHOD Height( nHeight ) CLASS TControl

   IF PCOUNT() > 0
      ::SizePos( , , , nHeight )
   ENDIF

   RETURN ::nHeight

METHOD oToolTip( oCtrl ) CLASS TControl

   IF HB_IsObject( oCtrl )
      ::oToolTipCtrl := oCtrl
   ELSEIF HB_IsObject( ::oToolTipCtrl )
      oCtrl := ::oToolTipCtrl
   ELSEIF HB_IsObject( ::Parent:oToolTip )
      oCtrl := ::Parent:oToolTip
   ELSE
      oCtrl := Nil
   ENDIF

   RETURN oCtrl

METHOD ToolTip( cToolTip ) CLASS TControl

   LOCAL oCtrl

   If PCount() > 0
      If ValType( cToolTip ) $ "CMB"
         ::cToolTip := cToolTip
      Else
         ::cToolTip := ""
      EndIf
      If HB_IsObject( oCtrl := ::oToolTip )
         oCtrl:Item( ::hWnd, cToolTip )
      EndIf
   EndIf

   Return ::cToolTip

FUNCTION _OOHG_GetNullName( cName )

   STATIC nCtrl := 0

   cName := IF( VALTYPE( cName ) $ "CM", UPPER( ALLTRIM( cName ) ), "0" )
   IF EMPTY( cName ) .OR. cName == "0" .OR. cName == "NONAME" .OR. cName == "NIL" .OR. cName == "NULL" .OR. cName == "NONE"
      // Caller must verify this name doesn't exists
      cName := "NULL" + STRZERO( nCtrl, 10 )
      nCtrl++
      IF nCtrl > 9999999999
          nCtrl := 0
      ENDIF
   ENDIF

   RETURN cName

METHOD SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, ;
                BkColor, lEditBox, lRtl, xAnchor, lNoProc ) CLASS TControl

   ::StartInfo( -1 )
   ::SearchParent( ParentForm )

   ::ParentDefaults( FontName, FontSize, FontColor, lNoProc )

   If HB_IsLogical( lEditBox ) .AND. lEditBox
      /* Background color for browse, combobox, datepicker, editbox, grid, hotkeybox,
         ipaddress, listbox, richeditbox, spinner, textbox, tree and xbrowse controls */
      If ValType( BkColor ) $ "ANCM"
         // Specified color
         ::BackColor := BkColor
      ElseIf ValType( ::BackColor ) $ "ANCM"
         // Pre-registered
      ElseIf ::Container != nil
         // Active frame
         ::BackColor := ::Container:DefBkColorEdit
      ElseIf ValType( ::Parent:DefBkColorEdit ) $ "ANCM"
         // Active form
         ::BackColor := ::Parent:DefBkColorEdit
      Else
          // Default
      EndIf
   Else
      /* Background color for activex, animatebox, button, checkbox, frame, hotkey, image,
         internal, label, menu, menuitem, monthcal, multipage, notifyicon, picture, player,
         progressbar, progressmeter, radiogroup, radioitem, scrollbar, scrollbutton, slider,
         splitbox, messagebar, tab, textarray, timer, toolbar, toolbutton and tooltip controls */
      If ValType( BkColor ) $ "ANCM"
         // Specified color
         ::BackColor := BkColor
      ElseIf ValType( ::BackColor ) $ "ANCM"
         // Pre-registered
      ElseIf ::Container != nil
         // Active frame
         ::BackColor := ::Container:BackColor
      ElseIf ValType( ::Parent:BackColor ) $ "ANCM"
         // Active form
         ::BackColor := ::Parent:BackColor
      Else
          // Default
      EndIf
   EndIf

   ::Name := _OOHG_GetNullName( ControlName )

   If _IsControlDefined( ::Name, ::Parent:Name )
      MsgOOHGError( _OOHG_Messages( 3, 4 ) + ::Name + _OOHG_Messages( 3, 5 ) + ::Parent:Name + _OOHG_Messages( 3, 6 ) )
   EndIf

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

   // Anchor
   If ValType( xAnchor ) $ "NCM"
      ::Anchor := xAnchor
   ElseIf ::Container != nil
      // Active frame
      ::Anchor := ::Container:nDefAnchor
   Else
      // Active form
      ::Anchor := ::Parent:nDefAnchor
   EndIf

   RETURN Self

METHOD InitStyle( nStyle, nStyleEx, lInvisible, lNoTabStop, lDisabled ) CLASS TControl

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

METHOD Register( hWnd, cName, HelpId, Visible, ToolTip, Id ) CLASS TControl

   Local mVar

   // cName NO debe recibirse!!! Ya debe estar desde :SetForm()!!!!
   // ::Name   := _OOHG_GetNullName( ControlName )
   HB_SYMBOL_UNUSED( cName )

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

   ::AddToCtrlsArrays()

   mVar := "_" + ::Parent:Name + "_" + ::Name
   Public &mVar. := Self

   RETURN Self

METHOD AddToCtrlsArrays() CLASS TControl

   AAdd( _OOHG_aControlhWnd, ::hWnd )
   AAdd( _OOHG_aControlObjects, Self )
   AAdd( _OOHG_aControlIds, { ::Id, ::Parent:hWnd } )
   AAdd( _OOHG_aControlNames, Upper( ::Parent:Name + Chr( 255 ) + ::Name ) )

   RETURN NIL

METHOD DelFromCtrlsArrays() CLASS TControl

   LOCAL nPos

   nPos := aScan( _OOHG_aControlNames, { |c| c == Upper( ::Parent:Name + Chr( 255 ) + ::Name ) } )

   IF nPos > 0
      _OOHG_DeleteArrayItem( _OOHG_aControlhWnd, nPos )
      _OOHG_DeleteArrayItem( _OOHG_aControlObjects, nPos )
      _OOHG_DeleteArrayItem( _OOHG_aControlIds, nPos )
      _OOHG_DeleteArrayItem( _OOHG_aControlNames, nPos )
   ENDIF

   RETURN NIL

METHOD Release() CLASS TControl

   Local mVar, oCont

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

   oCont := GetFormObjectByHandle( ::ContainerhWnd )
   IF oCont:LastFocusedControl == ::hWnd
      oCont:LastFocusedControl := 0
   ENDIF

   // Remove from container
   IF ::Container != nil
      ::Container:DeleteControl( Self )
   ENDIF

   ::DelFromCtrlsArrays()

   ::Parent:DeleteControl( Self )

   If ValidHandler( ::hWnd )
      ReleaseControl( ::hWnd )
   EndIf

   DeleteObject( ::FontHandle )
   DeleteObject( ::AuxHandle )

   mVar := '_' + ::Parent:Name + '_' + ::Name
   If type ( mVar ) != 'U'
      __MVPUT( mVar , 0 )
   EndIf

   Return ::Super:Release()

METHOD SetFont( cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout, nAngle, nCharset, nWidth, nOrientation, lAdvanced ) CLASS TControl

   IF ! Empty( cFontName ) .AND. ValType( cFontName ) $ "CM"
      ::cFontName := cFontName
   ENDIF
   IF ! Empty( nFontSize ) .AND. HB_ISNUMERIC( nFontSize )
      ::nFontSize := nFontSize
   ENDIF
   IF HB_ISLOGICAL( lBold )
      ::Bold := lBold
   ENDIF
   IF HB_ISLOGICAL( lItalic )
      ::Italic := lItalic
   ENDIF
   IF HB_ISLOGICAL( lUnderline )
      ::Underline := lUnderline
   ENDIF
   IF HB_ISLOGICAL( lStrikeout )
      ::Strikeout := lStrikeout
   ENDIF
   IF ! Empty( nAngle ) .AND. HB_ISNUMERIC( nAngle )
      ::FntAngle := nAngle
   ENDIF
   IF ! Empty( nCharset ) .AND. HB_ISNUMERIC( nCharset )
      ::FntCharset := nCharset
   ENDIF
   IF ! Empty( nWidth ) .AND. HB_ISNUMERIC( nWidth )
      ::FntWidth := nWidth
   ENDIF
   IF HB_ISLOGICAL( lAdvanced )
      ::FntAdvancedGM := lAdvanced
   ENDIF
   IF ::FntAdvancedGM
      IF ! Empty( nOrientation ) .AND. HB_ISNUMERIC( nOrientation )
         ::FntOrientation := nOrientation
      ENDIF
   ELSE
      ::FntOrientation := ::FntAngle
   ENDIF
   ::FontHandle := _SetFont( ::hWnd, ::cFontName, ::nFontSize, ::Bold, ::Italic, ::Underline, ::Strikeout, ::FntAngle, ::FntCharset, ::FntWidth, ::FntOrientation, ::FntAdvancedGM )

   RETURN NIL

METHOD FontName( cFontName ) CLASS TControl

   IF ValType( cFontName ) $ "CM"
      ::cFontName := cFontName
      ::SetFont( cFontName )
   ENDIF

   RETURN ::cFontName

METHOD FontSize( nFontSize ) CLASS TControl

   IF HB_ISNUMERIC( nFontSize )
      ::nFontSize := nFontSize
      ::SetFont( , nFontSize )
   ENDIF

   RETURN ::nFontSize

METHOD FontBold( lBold ) CLASS TControl

   IF HB_ISLOGICAL( lBold )
      ::Bold := lBold
      ::SetFont( , , lBold )
   ENDIF

   RETURN ::Bold

METHOD FontItalic( lItalic ) CLASS TControl

   IF HB_ISLOGICAL( lItalic )
      ::Italic := lItalic
      ::SetFont( , , , lItalic )
   ENDIF

   RETURN ::Italic

METHOD FontUnderline( lUnderline ) CLASS TControl

   IF HB_ISLOGICAL( lUnderline )
      ::Underline := lUnderline
      ::SetFont( , , , , lUnderline )
   ENDIF

   RETURN ::Underline

METHOD FontStrikeout( lStrikeout ) CLASS TControl

   IF HB_ISLOGICAL( lStrikeout )
      ::StrikeOut := lStrikeout
      ::SetFont( , , , , , lStrikeout )
   ENDIF

   RETURN ::Strikeout

METHOD FontAngle( nAngle ) CLASS TControl

   IF HB_ISNUMERIC( nAngle )
     ::FntAngle := nAngle
      ::SetFont( , , , , , , nAngle )
   ENDIF

   RETURN ::FntAngle

METHOD FontCharset( nCharset ) CLASS TControl

   IF HB_ISNUMERIC( nCharset )
     ::FntCharset := nCharset
      ::SetFont( , , , , , , , nCharset )
   ENDIF

   RETURN ::FntCharset

METHOD FontWidth( nWidth ) CLASS TControl

   IF HB_ISNUMERIC( nWidth )
     ::FntWidth := nWidth
      ::SetFont( , , , , , , , , nWidth )
   ENDIF

   RETURN ::FntWidth

METHOD FontOrientation( nOrientation ) CLASS TControl

   IF HB_ISNUMERIC( nOrientation ) .AND. ::FntAdvancedGM
     ::FntOrientation := nOrientation
      ::SetFont( , , , , , , , , , nOrientation )
   ENDIF

   RETURN ::FntOrientation

METHOD FontAdvancedGM( lAdvanced ) CLASS TControl

   IF HB_ISLOGICAL( lAdvanced )
      ::SetFont( , , , , , , , , , , lAdvanced )
   ENDIF

   RETURN ::FntAdvancedGM

METHOD SizePos( Row, Col, Width, Height ) CLASS TControl

   LOCAL xRet, nOldWidth, nOldHeight

   nOldWidth := ::nWidth
   nOldHeight := ::nHeight
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
   xRet := MoveWindow( ::hWnd, ::ContainerCol, ::ContainerRow, ::nWidth, ::nHeight , .T. )
   ::CheckClientsPos()

   // Anchor
   If nOldWidth != ::nWidth .OR. nOldHeight != ::nHeight
      AEVAL( ::aControls, { |o| o:AdjustAnchor( ::nHeight - nOldHeight, ::nWidth - nOldWidth ) } )
   EndIf
   AEVAL( ::aControls, { |o| o:SizePos() } )
   AEVAL( ::aControls, { |o| o:Events_Size() } )

   Return xRet

METHOD Move( Row, Col, Width, Height ) CLASS TControl

   Return ::SizePos( Row, Col, Width, Height )

METHOD ForceHide() CLASS TControl

   ::Super:ForceHide()
   AEVAL( ::aControls, { |o| o:ForceHide() } )

   Return nil

METHOD SetVarBlock( cField, uValue ) CLASS TControl

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

METHOD ClearBitMaps CLASS TControl

   ::ImageList := 0

   RETURN NIL

METHOD AddBitMap( uImage ) CLASS TControl

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
         AEVAL( uImage, { |c| ImageList_Add( ::ImageList, c, ::ImageListFlags, ::ImageListColor ) }, 2 )
      Else
         nPos := ImageList_Add( ::ImageList, uImage, ::ImageListFlags, ::ImageListColor )
      EndIf
      If nCount == ImageList_GetImageCount( ::ImageList )
         nPos := 0
      EndIf
      SendMessage( ::hWnd, ::SetImageListCommand, ::SetImageListWParam, ::ImageList )
   Endif

   Return nPos

METHOD DoEvent( bBlock, cEventType, aParams ) CLASS TControl

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
      lRetVal := _OOHG_Eval_Array( bBlock, aParams )
      _PopEventInfo()
   Else
      lRetVal := .F.
   EndIf

   Return lRetVal

METHOD DoEventMouseCoords( bBlock, cEventType ) CLASS TControl

   Local aPos := GetCursorPos()

   // TODO: Use GetClientRect instead
   aPos[ 1 ] -= GetWindowRow( ::hWnd )
   aPos[ 2 ] -= GetWindowCol( ::hWnd )

   Return ::DoEvent( bBlock, cEventType, aPos )

METHOD DoLostFocus() CLASS TControl

   Local uRet := Nil, nFocus, oFocus

   If ! ::ContainerReleasing
      nFocus := GetFocus()
      If nFocus > 0
         oFocus := GetControlObjectByHandle( nFocus )
         If ! oFocus:lCancel
            If _OOHG_lValidating
               Return Nil
            EndIf
            _OOHG_lValidating := .T.
            uRet := _OOHG_Eval( ::postBlock, Self )
            If HB_IsLogical( uRet ) .AND. ! uRet
               ::SetFocus()
               _OOHG_lValidating := .F.
               Return 1
            EndIf
            _OOHG_lValidating := .F.
            uRet := Nil
         EndIf
      EndIf
      If ! ( Empty( ::cFocusFontName ) .AND. Empty( ::nFocusFontSize ) .AND. Empty( ::FocusBold ) .AND. ;
             Empty( ::FocusItalic ) .AND. Empty( ::FocusUnderline ) .AND. Empty( ::FocusStrikeout ) )
         ::SetFont( ::cFontName, ::nFontSize, ::Bold, ::Italic, ::Underline, ::Strikeout )
         ::Refresh()
      EndIF
      If ! Empty( ::FocusColor )
         ::FontColor := ::OldColor
      EndIf
      If ! Empty( ::FocusBackColor )
         ::BackColor:=::OldBackColor
      EndIf

      ::DoEvent( ::OnLostFocus, "LOSTFOCUS" )
   EndIf

   Return uRet

METHOD DoChange() CLASS TControl

   Local xValue, cType, cOldType

   xValue   := ::Value
   cType    := VALTYPE( xValue )
   cOldType := VALTYPE( ::xOldValue )
   cType    := IF( cType    == "M", "C", cType )
   cOldType := IF( cOldType == "M", "C", cOldType )
   IF cOldType == "U" .OR. ! cType == cOldType .OR. ! xValue == ::xOldValue
      ::OldValue  := ::xOldValue
      ::xOldValue := xValue
      ::DoEvent( ::OnChange, "CHANGE" )
   ENDIF

   Return nil


#pragma BEGINDUMP

#define s_Super s_TWindow

// -----------------------------------------------------------------------------
HB_FUNC_STATIC( TCONTROL_EVENTS )   // METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TControl
// -----------------------------------------------------------------------------
{
   HWND hWnd      = HWNDparam( 1 );
   UINT message   = ( UINT )   hb_parni( 2 );
   WPARAM wParam  = ( WPARAM ) HB_PARNL( 3 );
   LPARAM lParam  = ( LPARAM ) HB_PARNL( 4 );
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
            _OOHG_DoEventMouseCoords( pSelf, s_OnMouseDrag, "MOUSEDRAG", lParam );
         }
         else
         {
            _OOHG_DoEventMouseCoords( pSelf, s_OnMouseMove, "MOUSEMOVE", lParam );
         }
         hb_ret();
         break;

      // *** Commented for use current behaviour.
      // case WM_LBUTTONUP:
      //    _OOHG_DoEventMouseCoords( pSelf, s_OnClick, "CLICK", lParam );
      //    hb_ret();
      //    break;

      case WM_LBUTTONDBLCLK:
         _OOHG_DoEventMouseCoords( pSelf, s_OnDblClick, "DBLCLICK", lParam );
         hb_ret();
         break;

      case WM_RBUTTONUP:
         _OOHG_DoEventMouseCoords( pSelf, s_OnRClick, "RCLICK", lParam );
         hb_ret();
         break;

      case WM_RBUTTONDBLCLK:
         _OOHG_DoEventMouseCoords( pSelf, s_OnRDblClick, "RDBLCLICK", lParam );
         hb_ret();
         break;

      case WM_MBUTTONUP:
         _OOHG_DoEventMouseCoords( pSelf, s_OnMClick, "MCLICK", lParam );
         hb_ret();
         break;

      case WM_MBUTTONDBLCLK:
         _OOHG_DoEventMouseCoords( pSelf, s_OnMDblClick, "MDBLCLICK", lParam );
         hb_ret();
         break;

      default:
         _OOHG_Send( pSelf, s_Super );
         hb_vmSend( 0 );
         _OOHG_Send( hb_param( -1, HB_IT_OBJECT ), s_Events );
         HWNDpush( hWnd );
         hb_vmPushLong( message );
         hb_vmPushNumInt( wParam );
         hb_vmPushNumInt( lParam );
         hb_vmSend( 4 );
         break;
   }
}

typedef INT ( CALLBACK * CALL_DRAWTHEMEPARENTBACKGROUND )( HWND, HDC, RECT * );

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TCONTROL_EVENTS_COLOR )          /* METHOD Events_Color( wParam, nDefColor, lDrawBkGrnd ) CLASS TControl -> hBrush */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   HDC hdc = ( HDC ) HB_PARNL( 1 );
   HBRUSH OldBrush;
   LONG lBackColor;
   HMODULE hInstDLL;
   CALL_DRAWTHEMEPARENTBACKGROUND dwProcDrawThemeParentBackground = 0;
   RECT rc;
   BOOL lDrawBkGrnd = ( HB_ISLOG( 3 ) ? hb_parl( 3 ) : FALSE );
   HWND hwnd = 0;
   PHB_ITEM pBkGrnd;
   POCTRL oBkGrnd;
   POINT pt;
   BOOL bPaint = FALSE;

   if( oSelf->lFontColor != -1 )
   {
      SetTextColor( hdc, ( COLORREF ) oSelf->lFontColor );
   }

   /* Check if the control has a valid BACKGROUND object */
   _OOHG_Send( pSelf, s_oBkGrnd );
   hb_vmSend( 0 );
   pBkGrnd = hb_param( -1, HB_IT_OBJECT );
   if( pBkGrnd )
   {
      oBkGrnd = _OOHG_GetControlInfo( pBkGrnd );
      hwnd = oBkGrnd->hWnd;
   }
   if( ValidHandler( hwnd ) )
   {
      bPaint = TRUE;
   }
   else
   {
      /* If not, check if it's inside a TAB and has TRANSPARENT clause */
      _OOHG_Send( pSelf, s_TabHandle );
      hb_vmSend( 0 );
      hwnd = HWNDparam( -1 );
      if( ValidHandler( hwnd ) )
      {
         _OOHG_Send( pSelf, s_Transparent );
         hb_vmSend( 0 );
         bPaint = hb_parl( -1 );
      }
   }
   if( bPaint )
   {
      /* Paint using a brush derived from the BACKGROUND object or the TAB */
      SetBkMode( hdc, TRANSPARENT );
      DeleteObject( oSelf->BrushHandle );
      oSelf->BrushHandle = GetTabBrush( hwnd );
      oSelf->lOldBackColor = -1;
      pt.x = 0; pt.y = 0;
      MapWindowPoints( oSelf->hWnd, hwnd, &pt, 1 );
      SetBrushOrgEx( hdc, -pt.x, -pt.y, NULL );
      OldBrush = SelectObject( hdc, oSelf->BrushHandle );
      DeleteObject( OldBrush );
      HB_RETNL( ( INT_PTR ) oSelf->BrushHandle );
      return;
   }

   /* Check if the control has TRANSPARENT clause */
   _OOHG_Send( pSelf, s_Transparent );
   hb_vmSend( 0 );
   if( hb_parl( -1 ) )
   {
      /* Paint using a NULL brush */
      SetBkMode( hdc, TRANSPARENT );
      DeleteObject( oSelf->BrushHandle );
      oSelf->BrushHandle = GetStockObject( NULL_BRUSH );
      oSelf->lOldBackColor = -1;
      OldBrush = SelectObject( hdc, oSelf->BrushHandle );
      DeleteObject( OldBrush );

      /* FRAME, CHECKBOX, BUTTON, RADIOITEM */
      if( lDrawBkGrnd )
      {
         hInstDLL = LoadLibrary( "UXTHEME.DLL" );
         if( hInstDLL )
         {
            dwProcDrawThemeParentBackground = ( CALL_DRAWTHEMEPARENTBACKGROUND ) GetProcAddress( hInstDLL, "DrawThemeParentBackground" );
         }
         if( dwProcDrawThemeParentBackground )
         {
            GetClientRect( oSelf->hWnd, &rc );
            ( dwProcDrawThemeParentBackground )( oSelf->hWnd, hdc, &rc );
         }
         FreeLibrary( hInstDLL );
      }
   }
   else
   {
      /* Paint using BACKCOLOR */
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
         OldBrush = SelectObject( hdc, oSelf->BrushHandle );
         DeleteObject( OldBrush );
      }
   }

   HB_RETNL( ( INT_PTR ) oSelf->BrushHandle );
}

#pragma ENDDUMP


METHOD Events_Command( wParam ) CLASS TControl

   Local Hi_wParam := HIWORD( wParam )

   If Hi_wParam == BN_CLICKED .OR. Hi_wParam == STN_CLICKED  // Same value.....
      If ! ::NestedClick
         ::NestedClick := ! _OOHG_NestedSameEvent()
         ::DoEventMouseCoords( ::OnClick, "CLICK" )
         ::NestedClick := .F.
      EndIf

   elseif Hi_wParam == EN_CHANGE
      ::DoChange()

   elseif Hi_wParam == EN_KILLFOCUS
      Return ::DoLostFocus()

   elseif Hi_wParam == EN_SETFOCUS
      GetFormObjectByHandle( ::ContainerhWnd ):LastFocusedControl := ::hWnd
      ::FocusEffect()
      ::DoEvent( ::OnGotFocus, "GOTFOCUS" )

   elseif Hi_wParam == BN_KILLFOCUS
      Return ::DoLostFocus()

   elseif Hi_wParam == BN_SETFOCUS
      GetFormObjectByHandle( ::ContainerhWnd ):LastFocusedControl := ::hWnd
      ::FocusEffect()
      ::DoEvent( ::OnGotFocus, "GOTFOCUS" )

   EndIf

   Return nil

METHOD FocusEffect CLASS TControl

   Local lMod

   If     ! Empty( ::cFocusFontName )
      lMod := .T.
   ElseIf ! Empty( ::nFocusFontSize )
      lMod := .T.
   ElseIf ! Empty( ::FocusBold )
      lMod := .T.
   ElseIf ! Empty( ::FocusItalic )
      lMod := .T.
   ElseIf ! Empty( ::FocusUnderline )
      lMod := .T.
   ElseIf ! Empty( ::FocusStrikeout )
      lMod := .T.
   ElseIf ::Parent == Nil
      lMod := .F.
   ElseIf ( _OOHG_HasData( ::Parent, "CFOCUSFONTNAME" ) .OR. _OOHG_HasMethod( ::Parent, "CFOCUSFONTNAME" ) ) .AND. ! Empty( ::Parent:cFocusFontName )
      lMod := .T.
   ElseIf ( _OOHG_HasData( ::Parent, "NFOCUSFONTSIZE" ) .OR. _OOHG_HasMethod( ::Parent, "NFOCUSFONTSIZE" ) ) .AND. ! Empty( ::Parent:nFocusFontSize )
      lMod := .T.
   ElseIf ( _OOHG_HasData( ::Parent, "FOCUSBOLD" )      .OR. _OOHG_HasMethod( ::Parent, "FOCUSBOLD" ) )      .AND. ! Empty( ::Parent:FocusBold )
      lMod := .T.
   ElseIf ( _OOHG_HasData( ::Parent, "FOCUSITALIC" )    .OR. _OOHG_HasMethod( ::Parent, "FOCUSITALIC" ) )    .AND. ! Empty( ::Parent:FocusItalic )
      lMod := .T.
   ElseIf ( _OOHG_HasData( ::Parent, "FOCUSUNDERLINE" ) .OR. _OOHG_HasMethod( ::Parent, "FOCUSUNDERLINE" ) ) .AND. ! Empty( ::Parent:FocusUnderline )
      lMod := .T.
   ElseIf ( _OOHG_HasData( ::Parent, "FOCUSSTRIKEOUT" ) .OR. _OOHG_HasMethod( ::Parent, "FOCUSSTRIKEOUT" ) ) .AND. ! Empty( ::Parent:FocusStrikeout )
      lMod := .T.
   Else
      lMod := .F.
   EndIf

   If lMod
      If Empty( ::cFocusFontName )
         If ::Parent != Nil .AND. ( _OOHG_HasData( ::Parent, "CFOCUSFONTNAME" ) .OR. _OOHG_HasMethod( ::Parent, "CFOCUSFONTNAME" ) ) .AND. ! Empty( ::Parent:cFocusFontName )
            ::cFocusFontName := ::Parent:cFocusFontName
         EndIf
      EndIf
      If Empty( ::cFocusFontName )
         ::cFocusFontName := ::cFontName
      EndIf

      If Empty( ::nFocusFontSize )
         If ::Parent != Nil .AND. ( _OOHG_HasData( ::Parent, "NFOCUSFONTSIZE" ) .OR. _OOHG_HasMethod( ::Parent, "NFOCUSFONTSIZE" ) ) .AND. ! Empty( ::Parent:nFocusFontSize )
            ::nFocusFontSize := ::Parent:nFocusFontSize
         EndIf
      EndIf
      If Empty( ::nFocusFontSize )
         ::nFocusFontSize := ::nFontSize
      EndIf

      If Empty( ::FocusBold )
         If ::Parent != Nil .AND. ( _OOHG_HasData( ::Parent, "FOCUSBOLD" ) .OR. _OOHG_HasMethod( ::Parent, "FOCUSBOLD" ) ) .AND. ! Empty( ::Parent:FocusBold )
            ::FocusBold := ::Parent:FocusBold
         EndIf
      EndIf
      If Empty( ::FocusBold )
         ::FocusBold := ::Bold
      EndIf

      If Empty( ::FocusItalic )
         If ::Parent != Nil .AND. ( _OOHG_HasData( ::Parent, "FOCUSITALIC" ) .OR. _OOHG_HasMethod( ::Parent, "FOCUSITALIC" ) ) .AND. ! Empty( ::Parent:FocusItalic )
            ::FocusItalic := ::Parent:FocusItalic
         EndIf
      EndIf
      If Empty( ::FocusItalic )
         ::FocusItalic := ::Italic
      EndIf

      If Empty( ::FocusUnderline )
         If ::Parent != Nil .AND. ( _OOHG_HasData( ::Parent, "FOCUSUNDERLINE" ) .OR. _OOHG_HasMethod( ::Parent, "FOCUSUNDERLINE" ) ) .AND. ! Empty( ::Parent:FocusUnderline )
            ::FocusUnderline := ::Parent:FocusUnderline
         EndIf
      EndIf
      If Empty( ::FocusUnderline )
         ::FocusUnderline := ::Underline
      EndIf

      If Empty( ::FocusStrikeout )
         If ::Parent != Nil .AND. ( _OOHG_HasData( ::Parent, "FOCUSSTRIKEOUT" ) .OR. _OOHG_HasMethod( ::Parent, "FOCUSSTRIKEOUT" ) ) .AND. ! Empty( ::Parent:FocusStrikeout )
            ::FocusStrikeout := ::Parent:FocusStrikeout
         EndIf
      EndIf
      If Empty( ::FocusStrikeout )
         ::FocusStrikeout := ::Strikeout
      EndIf

      ::FontHandle := _SetFont( ::hWnd, ::cFocusFontName, ::nFocusFontSize, ::FocusBold, ::FocusItalic, ::FocusUnderline, ::FocusStrikeout, ::FntAngle, ::FntCharset, ::FntWidth, ::FntOrientation, ::FntAdvancedGM )
   EndIf

   If ! Empty( ::FocusColor )
      ::OldColor := ::FontColor
      ::FontColor := ::FocusColor
      lMod := .T.
   ElseIf ::Parent != Nil .AND. ( _OOHG_HasData( ::Parent, "FOCUSCOLOR" ) .OR. _OOHG_HasMethod( ::Parent, "FOCUSCOLOR" ) ) .AND. ! Empty( ::Parent:FocusColor )
      ::OldColor := ::FontColor
      ::FocusColor := ::Parent:FocusColor
      ::FontColor := ::FocusColor
      lMod := .T.
   EndIf

   If ! Empty( ::FocusBackColor )
      ::OldBackColor := ::BackColor
      ::BackColor := ::FocusBackColor
      lMod := .T.
   ElseIf ::Parent != Nil .AND. ( _OOHG_HasData( ::Parent, "FOCUSBACKCOLOR" ) .OR. _OOHG_HasMethod( ::Parent, "FOCUSBACKCOLOR" ) ) .AND. ! Empty( ::Parent:FocusBackColor )
      ::OldBackColor := ::BackColor
      ::FocusBackColor := ::Parent:FocusBackColor
      ::BackColor  := ::FocusBackColor
      lMod := .T.
   EndIf

   If lMod
      ::ReDraw()
   EndIf

   Return Nil

METHOD Events_Enter() CLASS TControl

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

METHOD Events_Notify( wParam, lParam ) CLASS TControl

   Local nNotify := GetNotifyCode( lParam )

   HB_SYMBOL_UNUSED( wParam )

   If     nNotify == NM_KILLFOCUS
      Return ::DoLostFocus()

   ElseIf nNotify == NM_SETFOCUS
      GetFormObjectByHandle( ::ContainerhWnd ):LastFocusedControl := ::hWnd
      ::FocusEffect()
      ::DoEvent( ::OnGotFocus, "GOTFOCUS" )

   ElseIf nNotify == TVN_SELCHANGED
      ::DoChange()

   EndIf

   Return nil

METHOD TabIndex( nNewIndex ) CLASS TControl

   Local nCurIndex, i, nLen, j, aAux

   If ::Parent == NIL
      nCurIndex := 0
   Else
      i := aScan( ::Parent:aControlsNames, Upper( AllTrim( ::Name ) ) + Chr( 255 ) )
      If i > 0
         nCurIndex := ::Parent:aCtrlsTabIndxs[ i ]
         If HB_IsNumeric( nNewIndex ) .AND. nNewIndex != nCurIndex
            nLen := LEN( ::Parent:aControls )
            // update indexes in array
            For j := 1 TO nLen
               IF nCurIndex > nNewIndex
                  // control is moved upward in the tab order
                  IF ::Parent:aCtrlsTabIndxs[ j ] < nCurIndex .AND. ::Parent:aCtrlsTabIndxs[ j ] >= nNewIndex
                     ::Parent:aCtrlsTabIndxs[ j ] ++
                  EndIf
               Else
                  // control is moved downward in the tab order
                  IF ::Parent:aCtrlsTabIndxs[ j ] > nCurIndex .AND. ::Parent:aCtrlsTabIndxs[ j ] <= nNewIndex
                     ::Parent:aCtrlsTabIndxs[ j ] --
                  EndIf
               EndIf
            Next
            ::Parent:aCtrlsTabIndxs[ i ] := nCurIndex := nNewIndex
            // change tab order
            aAux := {}
            For j := 1 to nLen
               AADD( aAux, { ::Parent:aControls[ j ], ::Parent:aCtrlsTabIndxs[ j ] } )
            Next j
            ASORT( aAux, nil, nil, { | x, y | x[ 2 ] < y[ 2 ] } )
            For j := 2 to nLen
               SetTabAfter( aAux[ j, 1 ]:hWnd, aAux[ j - 1, 1 ]:hWnd )
            Next j
            // renumber tab indexes so they remain 1-based
            For j := 1 to nLen
               i := aScan( ::Parent:aControlsNames, Upper( AllTrim( aAux[ j, 1 ]:Name ) ) + Chr( 255 ) )
               ::Parent:aCtrlsTabIndxs[ i ] := j
            Next j
         EndIf
      ELSE
         nCurIndex := 0
      EndIf
   EndIf

   Return nCurIndex

Function GetControlObject( ControlName, FormName )

   Local mVar

   mVar := '_' + FormName + '_' + ControlName

   Return IF( Type( mVar ) == "O", &mVar, TControl() )

Function GetExistingControlObject( ControlName, FormName )

   Local mVar

   mVar := '_' + FormName + '_' + ControlName
   If ! Type( mVar ) == "O"
      MsgOOHGError( "Control: " + ControlName + " of " + FormName + " not defined. Program terminated." )
   EndIf

   Return &mVar

Function _GetId()

   Local RetVal

   Do While .T.
      RetVal := Int( hb_random( 59000 ) ) + 2001   // Lower than 0xF000
      If RetVal < 61440 .AND. aScan( _OOHG_aControlIds , { |a| a[ 1 ] == RetVal } ) == 0          // TODO: thread safe, move to h_application.prg
         Exit
      EndIf
   EndDo

   Return RetVal

Function _KillAllTimers()

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

Function GetStartUpFolder()

   Local StartUpFolder := GetProgramFileName()

   Return Left ( StartUpFolder , Rat ( '\' , StartUpFolder ) - 1 )

   // Initializes C variables

Procedure _OOHG_Init_C_Vars_Controls()

   TControl()
   _OOHG_Init_C_Vars_Controls_C_Side( _OOHG_aControlhWnd, _OOHG_aControlObjects, _OOHG_aControlIds )

   Return


EXTERN _OOHG_UnTransform

#pragma BEGINDUMP

HB_FUNC( _OOHG_UNTRANSFORM )
{
   char *cText, *cPicture, *cReturn, cType;
   ULONG iText, iPicture, iReturn, iMax;
   BOOL bSign, bIgnoreMasks, bPadLeft;

   iText = hb_parclen( 1 );
   iPicture = hb_parclen( 2 );
   iMax = ( iText > iPicture ) ? iText : iPicture ;
   if( ! iPicture )
   {
      hb_retclen( hb_parc( 1 ), iText );
   }
   else if( iText )
   {
      cText = ( char * ) hb_parc( 1 );
      cPicture = ( char * ) hb_parc( 2 );
      cReturn = ( char * ) hb_xgrab( iMax );
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

      bSign = 0;
      bIgnoreMasks = ( cType == 'N' || cType == 'L' );
      bPadLeft = 0;

      // Picture function
      if( iPicture && *cPicture == '@' )
      {
         iPicture--;
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
                     bSign = 1;
                     iText--;
                     cReturn[ iReturn++ ] = '-';
                  }
                  break;

               case 'X':
               case 'x':
                  if( cType == 'N' && iText > 2 && cText[ iText - 3 ] == ' ' && cText[ iText - 2 ] == 'D' && cText[ iText - 1 ] == 'B' )
                  {
                     bSign = 1;
                     iText -= 3;
                     cReturn[ iReturn++ ] = '-';
                  }
                  break;

               case 'B':
               case 'b':
                  if( cType == 'N' )
                  {
                     bPadLeft = 1;
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

      if( bPadLeft )
      {
         while( iPicture > iText )
         {
            iPicture--;
            cPicture++;
            // TODO:
            // - Must fill cReturn[] left?
            // - Must bIgnoreMasks ?
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
                  bSign = 1;
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

      if( cType == 'N' && bSign )
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

HB_FUNC( SETTABAFTER )
{
   hb_retl( SetWindowPos( HWNDparam( 1 ), HWNDparam( 2 ), 0, 0, 0, 0, SWP_NOACTIVATE | SWP_NOCOPYBITS | SWP_NOMOVE | SWP_NOOWNERZORDER | SWP_NOREDRAW | SWP_NOSENDCHANGING | SWP_NOSIZE ) );
}

#pragma ENDDUMP


CLASS TControlGroup FROM TControl

   DATA Type      INIT "CONTROLGROUP" READONLY
   DATA lHidden   INIT .F.

   METHOD Define
   METHOD Enabled             SETGET
   METHOD Visible             SETGET

   METHOD AddControl

   ENDCLASS

METHOD Define( ControlName, ParentForm, x, y, w, h, Invisible, lDisabled ) CLASS TControlGroup

   ASSIGN ::nCol    VALUE x TYPE "N"
   ASSIGN ::nRow    VALUE y TYPE "N"
   ASSIGN ::nWidth  VALUE w TYPE "N"
   ASSIGN ::nHeight VALUE h TYPE "N"

   ::SetForm( ControlName, ParentForm )

   ::InitStyle( ,, Invisible,, lDisabled )

   Return Self

METHOD Enabled( lEnabled ) CLASS TControlGroup

   IF HB_IsLogical( lEnabled )
      ::Super:Enabled := lEnabled
      AEVAL( ::aControls, { |o| o:Enabled := o:Enabled } )
   ENDIF

   RETURN ::Super:Enabled

METHOD Visible( lVisible ) CLASS TControlGroup

   IF HB_IsLogical( lVisible )
      ::Super:Visible := lVisible
      AEVAL( ::aControls, { |o| o:Visible := o:Visible } )
   ENDIF

   RETURN ::lVisible

METHOD AddControl( oCtrl, Row, Col ) CLASS TControlGroup

   oCtrl:Visible := oCtrl:Visible
   ::Super:AddControl( oCtrl )
   oCtrl:Container := Self
   oCtrl:SizePos( Row, Col )
   oCtrl:Visible := oCtrl:Visible

   Return Nil
