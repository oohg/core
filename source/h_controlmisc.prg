/*
* $Id: h_controlmisc.prg $
*/
/*
* ooHG source code:
* Generic control and miscelaneous related functions
* Copyright 2005-2017 Vicente Guerra <vicente@guerra.com.mx>
* https://oohg.github.io/
* Portions of this project are based upon Harbour MiniGUI library.
* Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
* Portions of this project are based upon Harbour GUI framework for Win32.
* Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
* Copyright 2001 Antonio Linares <alinares@fivetech.com>
* Portions of this project are based upon Harbour Project.
* Copyright 1999-2017, https://harbour.github.io/
*/
/*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2, or (at your option)
* any later version.
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
* You should have received a copy of the GNU General Public License
* along with this software; see the file LICENSE.txt. If not, write to
* the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1335,USA (or download from http://www.gnu.org/licenses/).
* As a special exception, the ooHG Project gives permission for
* additional uses of the text contained in its release of ooHG.
* The exception is that, if you link the ooHG libraries with other
* files to produce an executable, this does not by itself cause the
* resulting executable to be covered by the GNU General Public License.
* Your use of that executable is in no way restricted on account of
* linking the ooHG library code into it.
* This exception does not however invalidate any other reasons why
* the executable file might be covered by the GNU General Public License.
* This exception applies only to the code released by the ooHG
* Project under the name ooHG. If you copy code from other
* ooHG Project or Free Software Foundation releases into a copy of
* ooHG, as the General Public License permits, the exception does
* not apply to the code that you add in this way. To avoid misleading
* anyone as to the status of such modified files, you must delete
* this exception notice from them.
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

FUNCTION _Getvalue( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):Value

FUNCTION _Setvalue( ControlName, ParentForm, Value )

   RETURN ( GetControlObject( ControlName, ParentForm ):Value := Value )

FUNCTION _AddItem( ControlName, ParentForm, Value )

   RETURN GetControlObject( ControlName, ParentForm ):AddItem( Value )

FUNCTION _DeleteItem( ControlName, ParentForm, Value )

   RETURN GetControlObject( ControlName, ParentForm ):DeleteItem( Value )

FUNCTION _DeleteAllItems( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):DeleteAllItems()

FUNCTION GetControlName( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):Name

FUNCTION GetControlHandle( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):hWnd

FUNCTION GetControlContainerHandle( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):Container:hWnd

FUNCTION GetControlParentHandle( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):ContainerhWnd     // :Parent:hWnd

FUNCTION GetControlId( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):Id

FUNCTION GetControlType( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):Type

FUNCTION GetControlValue( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):Value

FUNCTION _IsControlDefined( ControlName, FormName )

   LOCAL mVar

   mVar := '_' + FormName + '_' + ControlName

   RETURN ( Type( mVar ) == "O" .AND. ( &mVar ):hWnd != -1 )

FUNCTION _SetFocus( ControlName, ParentForm )

   RETURN GetControlObject( ControlName , ParentForm ):SetFocus()

FUNCTION _DisableControl( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):Enabled := .F.

FUNCTION _EnableControl( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):Enabled := .T.

FUNCTION _ShowControl( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):Show()

FUNCTION _HideControl( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):Hide()

FUNCTION _SetItem( ControlName, ParentForm, Item, Value )

   RETURN GetControlObject( ControlName, ParentForm ):Item( Item, Value )

FUNCTION _GetItem( ControlName, ParentForm, Item )

   RETURN GetControlObject( Controlname, ParentForm ):Item( Item )

FUNCTION _SetControlSizePos( ControlName, ParentForm, row, col, width, height )

   RETURN GetControlObject( Controlname, ParentForm ):SizePos( row, col, width, height )

FUNCTION _GetItemCount( ControlName, ParentForm )

   RETURN GetControlObject( Controlname, ParentForm ):ItemCount

FUNCTION _GetControlRow( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):Row

FUNCTION _GetControlCol( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):Col

FUNCTION _GetControlWidth( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):Width

FUNCTION _GetControlHeight( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):Height

FUNCTION _SetControlCol( ControlName, ParentForm, Value )

   RETURN GetControlObject( ControlName, ParentForm ):SizePos( , Value )

FUNCTION _SetControlRow( ControlName, ParentForm, Value )

   RETURN GetControlObject( ControlName, ParentForm ):SizePos( Value )

FUNCTION _SetControlWidth( ControlName, ParentForm, Value )

   RETURN GetControlObject( ControlName, ParentForm ):SizePos( , , Value )

FUNCTION _SetControlHeight( ControlName, ParentForm, Value )

   RETURN GetControlObject( ControlName, ParentForm ):SizePos( , , , Value )

FUNCTION _SetPicture( ControlName, ParentForm, FileName )

   RETURN GetControlObject( ControlName, ParentForm ):Picture := FileName

FUNCTION _GetPicture( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):Picture

FUNCTION _GetControlAction( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):OnClick

FUNCTION _GetToolTip( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):ToolTip

FUNCTION _SetToolTip( ControlName, ParentForm, Value  )

   RETURN GetControlObject( ControlName, ParentForm ):ToolTip := Value

FUNCTION _SetRangeMin( ControlName, ParentForm, Value  )

   RETURN ( GetControlObject( ControlName, ParentForm ):RangeMin := Value )

FUNCTION _SetRangeMax( ControlName, ParentForm, Value  )

   RETURN ( GetControlObject( ControlName, ParentForm ):RangeMax := Value )

FUNCTION _GetRangeMin( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):RangeMin

FUNCTION _GetRangeMax( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):RangeMax

FUNCTION _SetMultiCaption( ControlName, ParentForm, Column, Value )

   RETURN GetControlObject( ControlName, ParentForm ):Caption( Column, Value )

FUNCTION _GetMultiCaption( ControlName, ParentForm, Item )

   RETURN GetControlObject( ControlName, ParentForm ):Caption( Item )

FUNCTION InputWindow( Title, aLabels, aValues, aFormats, row, col, aButOKCancelCaptions, nLabelWidth, nControlWidth, nButtonWidth )

   LOCAL i, l, ControlRow, e := 0, LN, CN, r, c, nHeight, diff
   LOCAL oInputWindow, aResult, nWidth, ControlCol, nSep

   IF ! HB_IsArray( aButOKCancelCaptions ) .OR. Len( aButOKCancelCaptions ) < 2
      aButOKCancelCaptions := { _OOHG_Messages( 1, 6 ), _OOHG_Messages( 1, 7 ) }
   ENDIF

   IF ! HB_IsNumeric( nLabelWidth ) .OR. nLabelWidth <= 10
      nLabelWidth := 110
   ENDIF

   IF ! HB_IsNumeric( nControlWidth ) .OR. nControlWidth <= 10
      nControlWidth := 140
   ENDIF

   IF ! HB_IsNumeric( nButtonWidth ) .OR. nButtonWidth <= 30
      nButtonWidth := 100
   ENDIF

   l := Len( aLabels )

   aResult := Array( l )

   FOR i := 1 to l
      IF ValType( aValues[i] ) == 'C'
         IF HB_IsNumeric( aFormats[i] )
            IF aFormats[i] > 32
               e++
            ENDIF
         ENDIF
      ENDIF

      IF HB_IsMemo( aValues[i] )
         e++
      ENDIF
   NEXT i

   IF ! HB_IsNumeric( row ) .or. ! HB_IsNumeric( col )
      r := 0
      c := 0
   ELSE
      r := row
      c := col
      nHeight := ( l * 30 ) + 90 + ( e * 60 )

      IF r + nHeight > GetDeskTopHeight()
         diff :=  r + nHeight - GetDeskTopHeight()
         r := r - diff
      ENDIF
   ENDIF

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

      FOR i := 1 to l
         LN := 'Label_' + Alltrim( Str( i, 2, 0 ) )
         CN := 'Control_' + Alltrim( Str( i, 2, 0 ) )

         @ ControlRow, 10 LABEL &LN OF _InputWindow VALUE aLabels[i] WIDTH nLabelWidth NOWORDWRAP

         DO CASE
         CASE HB_IsLogical( aValues[i] )
            @ ControlRow, ControlCol CHECKBOX &CN OF _InputWindow CAPTION '' VALUE aValues[i] WIDTH nControlWidth
            ControlRow := ControlRow + 30

         CASE HB_IsDate( aValues[i] )
            IF ValType( aFormats[i] ) $ 'CM' .AND. upper( aFormats[i] ) == "SHOWNONE"
               @ ControlRow, ControlCol DATEPICKER &CN  OF _InputWindow VALUE aValues[i] WIDTH nControlWidth SHOWNONE
               ControlRow := ControlRow + 30
            ELSE
               @ ControlRow, ControlCol DATEPICKER &CN  OF _InputWindow VALUE aValues[i] WIDTH nControlWidth
               ControlRow := ControlRow + 30
            ENDIF

         CASE HB_IsNumeric( aValues[i] )
            IF HB_IsArray( aFormats[i] )
               @ ControlRow, ControlCol COMBOBOX &CN  OF _InputWindow ITEMS aFormats[i] VALUE aValues[i] WIDTH nControlWidth  FONT 'Arial' SIZE 10
               ControlRow := ControlRow + 30
            ELSEIF  ValType( aFormats[i] ) $ 'CM'
               IF At( '.', aFormats[i] ) > 0
                  @ ControlRow, ControlCol TEXTBOX &CN  OF _InputWindow VALUE aValues[i] WIDTH nControlWidth FONT 'Arial' SIZE 10 NUMERIC INPUTMASK aFormats[i]
               ELSE
                  @ ControlRow, ControlCol TEXTBOX &CN  OF _InputWindow VALUE aValues[i] WIDTH nControlWidth FONT 'Arial' SIZE 10 MAXLENGTH Len( aFormats[i] ) NUMERIC
               ENDIF
               ControlRow := ControlRow + 30
            ENDIF

         CASE ValType( aValues[i] ) == 'C'
            IF HB_IsNumeric( aFormats[i] )
               IF  aFormats[i] <= 32
                  @ ControlRow, ControlCol TEXTBOX &CN  OF _InputWindow VALUE aValues[i] WIDTH nControlWidth FONT 'Arial' SIZE 10 MAXLENGTH aFormats[i]
                  ControlRow := ControlRow + 30
               ELSE
                  @ ControlRow, ControlCol EDITBOX &CN  OF _InputWindow WIDTH nControlWidth HEIGHT 90 VALUE aValues[i] FONT 'Arial' SIZE 10 MAXLENGTH aFormats[i]
                  ControlRow := ControlRow + 94
               ENDIF
            ENDIF

         CASE HB_IsMemo( aValues[i] )
            @ ControlRow, ControlCol EDITBOX &CN  OF _InputWindow WIDTH nControlWidth HEIGHT 90 VALUE aValues[i] FONT 'Arial' SIZE 10
            ControlRow := ControlRow + 94

         ENDCASE
      NEXT i

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

   IF ! HB_IsNumeric( row ) .or. ! HB_IsNumeric( col )
      oInputWindow:Center()
   ENDIF

   oInputWindow:Activate()

   RETURN aResult

FUNCTION _InputWindowOk( oInputWindow, aResult )

   LOCAL i , l

   l := len( aResult )
   FOR i := 1 to l
      aResult[ i ] := oInputWindow:Control( 'Control_' + Alltrim( Str( i ) ) ):Value
   NEXT i
   oInputWindow:Release()

   RETURN NIL

FUNCTION _InputWindowCancel( oInputWindow, aResult )

   afill( aResult, NIL )
   oInputWindow:Release()

   RETURN NIL

FUNCTION _ReleaseControl( ControlName, ParentForm )

   RETURN GetControlObject( ControlName, ParentForm ):Release()

FUNCTION _IsControlVisibleFromHandle( Handle )

   RETURN GetControlObjectByHandle( Handle ):ContainerVisible

FUNCTION _SetCaretPos( ControlName, FormName, Pos )

   RETURN ( GetControlObject( ControlName, FormName ):CaretPos := Pos )

FUNCTION _GetCaretPos( ControlName, FormName )

   RETURN GetControlObject( ControlName, FormName ):CaretPos

FUNCTION DefineProperty( cProperty, cControlName, cFormName, xValue )

   LOCAL oCtrl

   IF HB_IsObject( cFormName )
      oCtrl := cFormName
   ELSEIF HB_IsString( cControlName )
      oCtrl := GetExistingControlObject( cControlName, cFormName )
   ELSE
      oCtrl := GetExistingFormObject( cFormName )
   ENDIF
   oCtrl:Property( cProperty, xValue )

   RETURN oCtrl:Property( cProperty )

FUNCTION SetProperty( Arg1, Arg2, Arg3, Arg4, Arg5, Arg6 )

   LOCAL oWnd, oCtrl, nPos

   IF Pcount() == 3 // Window

      oWnd := GetExistingFormObject( Arg1 )
      Arg2 := Upper( Arg2 )

      IF Arg2 == "TITLE"
         oWnd:Title := Arg3

      ELSEIF Arg2 == "HEIGHT"
         oWnd:Height := Arg3

      ELSEIF Arg2 == "WIDTH"
         oWnd:Width := Arg3

      ELSEIF Arg2 == "COL"
         oWnd:Col := Arg3

      ELSEIF Arg2 == "ROW"
         oWnd:Row := Arg3

      ELSEIF Arg2 == "NOTIFYICON"
         oWnd:NotifyIcon := Arg3

      ELSEIF Arg2 == "NOTIFYTOOLTIP"
         oWnd:NotifyTooltip := Arg3

      ELSEIF Arg2 == "BACKCOLOR"
         oWnd:BackColor := Arg3

      ELSEIF Arg2 == "CURSOR"
         oWnd:Cursor := Arg3

      ELSEIF Arg2 == "CLOSABLE"
         oWnd:Closeable := Arg3

      ELSE
         // Pseudo-property
         nPos := ASCAN( oWnd:aProperties, { |a| a[ 1 ] == Arg2 } )
         IF nPos > 0
            oWnd:aProperties[ nPos ][ 2 ] := Arg3
         ENDIF

      ENDIF

   ELSEIF Pcount() == 4 // CONTROL

      oCtrl := GetExistingControlObject( Arg2, Arg1 )
      Arg3 := Upper( Arg3 )

      IF     Arg3 == "VALUE"
         oCtrl:Value := Arg4

      ELSEIF Arg3 == "ALLOWEDIT"
         oCtrl:AllowEdit := Arg4

      ELSEIF Arg3 == "ALLOWAPPEND"
         oCtrl:AllowAppend := Arg4

      ELSEIF Arg3 == "ALLOWDELETE"
         oCtrl:AllowDelete := Arg4

      ELSEIF Arg3 == "PICTURE"
         oCtrl:Picture := Arg4

      ELSEIF Arg3 == "TOOLTIP"
         oCtrl:Tooltip := Arg4

      ELSEIF Arg3 == "FONTNAME"
         oCtrl:SetFont( Arg4 )

      ELSEIF Arg3 == "FONTSIZE"
         oCtrl:SetFont( , Arg4 )

      ELSEIF Arg3 == "FONTBOLD"
         oCtrl:SetFont( , , Arg4 )

      ELSEIF Arg3 == "FONTITALIC"
         oCtrl:SetFont( , , , Arg4 )

      ELSEIF Arg3 == "FONTUNDERLINE"
         oCtrl:SetFont( , , , , Arg4 )

      ELSEIF Arg3 == "FONTSTRIKEOUT"
         oCtrl:SetFont( , , , , , Arg4 )

      ELSEIF Arg3 == "CAPTION"
         oCtrl:Caption := Arg4

      ELSEIF Arg3 == "DISPLAYVALUE"
         oCtrl:Caption := Arg4

      ELSEIF Arg3 == "ROW"
         oCtrl:Row := Arg4

      ELSEIF Arg3 == "COL"
         oCtrl:Col := Arg4

      ELSEIF Arg3 == "WIDTH"
         oCtrl:Width := Arg4

      ELSEIF Arg3 == "HEIGHT"
         oCtrl:Height := Arg4

      ELSEIF Arg3 == "VISIBLE"
         oCtrl:Visible := Arg4

      ELSEIF Arg3 == "ENABLED"
         oCtrl:Enabled := Arg4

      ELSEIF Arg3 == "CHECKED"
         oCtrl:Checked := Arg4

      ELSEIF Arg3 == "RANGEMIN"
         oCtrl:RangeMin := Arg4

      ELSEIF Arg3 == "RANGEMAX"
         oCtrl:RangeMax := Arg4

      ELSEIF Arg3 == "REPEAT"
         IF Arg4 == .t.
            oCtrl:RepeatOn()
         ELSE
            oCtrl:RepeatOff()
         ENDIF

      ELSEIF Arg3 == "SPEED"
         oCtrl:Speed( Arg4 )

      ELSEIF Arg3 == "VOLUME"
         oCtrl:Volume( Arg4 )

      ELSEIF Arg3 == "ZOOM"
         oCtrl:Zoom( Arg4 )

      ELSEIF Arg3 == "POSITION"
         IF Arg4 == 0
            oCtrl:PositionHome()
         ELSEIF Arg4 == 1
            oCtrl:PositionEnd()
         ENDIF

      ELSEIF Arg3 == "CARETPOS"
         oCtrl:CaretPos := Arg4

      ELSEIF Arg3 == "BACKCOLOR"
         oCtrl:BackColor := Arg4

      ELSEIF Arg3 == "FONTCOLOR"
         oCtrl:FontColor := Arg4

      ELSEIF Arg3 == "FORECOLOR"
         oCtrl:FontColor := Arg4

      ELSEIF Arg3 == "ADDRESS"
         oCtrl:Address := Arg4

      ELSEIF Arg3 == "READONLY" .OR. Arg3 == "DISABLEEDIT"
         oCtrl:ReadOnly := Arg4

      ELSEIF Arg3 == "ITEMCOUNT"
         ListView_SetItemCount( oCtrl:hWnd, Arg4 )

      ELSEIF Arg3 == "GETPARENT"
         oCtrl:GetParent( Arg4 )

      ELSEIF Arg3 == "GETCHILDREN"
         oCtrl:GetChildren( Arg4 )

      ELSEIF Arg3 == "INDENT"
         oCtrl:Indent( Arg4 )

      ELSEIF Arg3 == "SELCOLOR"
         oCtrl:SelColor( Arg4 )

      ELSEIF Arg3 == "ONCHANGE"
         oCtrl:OnChange := Arg4

      ELSEIF Arg3 == "MAXLENGTH"
         oCtrl:MaxLength := Arg4

      ELSE
         // Pseudo-property
         nPos := ASCAN( oCtrl:aProperties, { |a| a[ 1 ] == Arg3 } )
         IF nPos > 0
            oCtrl:aProperties[ nPos ][ 2 ] := Arg4
         ENDIF

      ENDIF

   ELSEIF Pcount() == 5 // CONTROL (WITH ARGUMENT OR TOOLBAR BUTTON)

      oCtrl := GetExistingControlObject( Arg2, Arg1 )
      Arg3 := Upper( Arg3 )

      IF Arg3 == "CAPTION"
         oCtrl:Caption( Arg4, Arg5 )

      ELSEIF Arg3 == "HEADER"
         oCtrl:Header( Arg4, Arg5 )

      ELSEIF Arg3 == "ITEM"
         oCtrl:Item( Arg4, Arg5 )

      ELSEIF Arg3 == "CHECKITEM"
         oCtrl:CheckItem( Arg4, Arg5 )

      ELSEIF Arg3 == "BOLDITEM"
         oCtrl:BoldItem( Arg4, Arg5 )

      ELSEIF Arg3 == "ITEMREADONLY"
         oCtrl:ItemReadonly( Arg4, Arg5 )

      ELSEIF Arg3 == "ITEMENABLED"
         oCtrl:ItemEnabled( Arg4, Arg5 )

      ELSEIF Arg3 == "ENABLED"
         oCtrl:ItemEnabled( Arg4, Arg5 )

      ELSEIF Arg3 == "ITEMDRAGGABLE"
         oCtrl:ItemDraggable( Arg4, Arg5 )

      ELSEIF Arg3 == "ICON"
         _SetStatusIcon( Arg2, Arg1, Arg4, Arg5 )

      ELSEIF Arg3 == "COLUMNWIDTH"
         oCtrl:ColumnWidth( Arg4, Arg5 )

      ELSEIF Arg3 == "PICTURE"
         oCtrl:Picture( Arg4, Arg5 )

      ELSEIF Arg3 == "IMAGE"
         oCtrl:Picture( Arg4, Arg5 )

      ELSE
         // If Property Not Matched Look For ToolBar Button

         IF oCtrl:Type == "TOOLBAR"

            IF oCtrl:hWnd != GetControlObject( Arg3 , Arg1 ):Container:hWnd
               MsgOOHGError('Control Does Not Belong To Container')
            ENDIF

            SetProperty( Arg1, Arg3, Arg4, Arg5 )
         ENDIF

      ENDIF

   ELSEIF Pcount() == 6 // CONTROL (WITH 2 ARGUMENTS)

      oCtrl := GetExistingControlObject( Arg2, Arg1 )
      Arg3 := Upper( Arg3 )

      IF     Arg3 == "CELL"
         oCtrl:Cell( Arg4 , Arg5 , Arg6 )

      ELSE
         SetProperty( Arg1, Arg4, Arg5, Arg6 )

      ENDIF

   ENDIF

   RETURN NIL

FUNCTION GetProperty( Arg1, Arg2, Arg3, Arg4, Arg5 )

   LOCAL RetVal, oWnd, oCtrl, nPos

   IF Pcount() == 2 // WINDOW

      oWnd := GetExistingFormObject( Arg1 )
      Arg2 := Upper( Arg2 )

      IF Arg2 == 'TITLE'
         RetVal := oWnd:Title

      ELSEIF Arg2 == 'FOCUSEDCONTROL'
         RetVal := oWnd:FocusedControl()

      ELSEIF Arg2 == 'NAME'
         RetVal := oWnd:Name

      ELSEIF Arg2 == 'HEIGHT'
         RetVal := oWnd:Height

      ELSEIF Arg2 == 'WIDTH'
         RetVal := oWnd:Width

      ELSEIF Arg2 == 'CLOSABLE'
         RetVal := oWnd:Closable

      ELSEIF Arg2 == 'COL'
         RetVal := oWnd:Col

      ELSEIF Arg2 == 'ROW'
         RetVal := oWnd:Row

      ELSEIF Arg2 == "NOTIFYICON"
         RetVal := oWnd:NotifyIcon

      ELSEIF Arg2 == "NOTIFYTOOLTIP"
         RetVal := oWnd:NotifyTooltip

      ELSEIF Arg2 == "BACKCOLOR"
         RetVal := oWnd:BackColor

      ELSEIF Arg2 == "HWND"
         RetVal := oWnd:hWnd

      ELSEIF Arg2 == "OBJECT"
         RetVal := oWnd

      ELSE
         // Pseudo-property
         nPos := ASCAN( oWnd:aProperties, { |a| a[ 1 ] == Arg2 } )
         IF nPos > 0
            RetVal := oWnd:aProperties[ nPos ][ 2 ]
         ENDIF

      ENDIF

   ELSEIF Pcount() == 3 // CONTROL

      oCtrl := GetExistingControlObject( Arg2, Arg1 )
      Arg3 := Upper( Arg3 )

      IF     Arg3 == 'VALUE'
         RetVal := oCtrl:Value

      ELSEIF Arg3 == 'NAME'
         RetVal := oCtrl:Name

      ELSEIF Arg3 == 'ALLOWEDIT'
         RetVal := oCtrl:AllowEdit

      ELSEIF Arg3 == 'ALLOWAPPEND'
         RetVal := oCtrl:AllowAppend

      ELSEIF Arg3 == 'ALLOWDELETE'
         RetVal := oCtrl:AllowDelete

      ELSEIF Arg3 == 'PICTURE'
         RetVal := oCtrl:Picture

      ELSEIF Arg3 == 'TOOLTIP'
         RetVal := oCtrl:Tooltip

      ELSEIF Arg3 == 'FONTNAME'
         RetVal := oCtrl:cFontName

      ELSEIF Arg3 == 'FONTSIZE'
         RetVal := oCtrl:nFontSize

      ELSEIF Arg3 == 'FONTBOLD'
         RetVal := oCtrl:Bold

      ELSEIF Arg3 == 'FONTITALIC'
         RetVal := oCtrl:Italic

      ELSEIF Arg3 == 'FONTUNDERLINE'
         RetVal := oCtrl:Underline

      ELSEIF Arg3 == 'FONTSTRIKEOUT'
         RetVal := oCtrl:Strikeout

      ELSEIF Arg3 == 'CAPTION'
         RetVal := oCtrl:Caption

      ELSEIF Arg3 == 'DISPLAYVALUE'
         RetVal := GetWindowText( oCtrl:hWnd )

      ELSEIF Arg3 == 'ROW'
         RetVal := oCtrl:Row

      ELSEIF Arg3 == 'COL'
         RetVal := oCtrl:Col

      ELSEIF Arg3 == 'WIDTH'
         RetVal := oCtrl:Width

      ELSEIF Arg3 == 'HEIGHT'
         RetVal := oCtrl:Height

      ELSEIF Arg3 == 'VISIBLE'
         RetVal := oCtrl:Visible

      ELSEIF Arg3 == 'ENABLED'
         RetVal := oCtrl:Enabled

      ELSEIF Arg3 == 'CHECKED'
         RetVal := oCtrl:Checked

      ELSEIF Arg3 == 'ITEMCOUNT'
         RetVal := oCtrl:ItemCount()

      ELSEIF Arg3 == 'RANGEMIN'
         RetVal := oCtrl:RangeMin

      ELSEIF Arg3 == 'RANGEMAX'
         RetVal := oCtrl:RangeMax

      ELSEIF Arg3 == 'LENGTH'
         RetVal := oCtrl:Length

      ELSEIF Arg3 == 'MAXLENGTH'
         RetVal := oCtrl:MaxLength

      ELSEIF Arg3 == 'POSITION'
         RetVal := oCtrl:Position

      ELSEIF Arg3 == 'CARETPOS'
         RetVal := oCtrl:CaretPos

      ELSEIF Arg3 == 'BACKCOLOR'
         RetVal := oCtrl:BackColor

      ELSEIF Arg3 == 'FONTCOLOR'
         RetVal := oCtrl:FontColor

      ELSEIF Arg3 == 'FORECOLOR'
         RetVal := oCtrl:BackColor

      ELSEIF Arg3 == 'ADDRESS'
         RetVal := oCtrl:Address

      ELSEIF Arg3 == "HWND"
         RetVal := oCtrl:hWnd

      ELSEIF Arg3 == "OBJECT"
         RetVal := oCtrl

      ELSEIF Arg3 == "INDENT"
         RetVal := oCtrl:Indent()

      ELSEIF Arg3 == "SELCOLOR"
         RetVal := oCtrl:SelColor()

      ELSEIF Arg3 == "READONLY" .OR. Arg3 == "DISABLEEDIT"
         RetVal := oCtrl:ReadOnly()

      ELSE
         // Pseudo-property
         nPos := ASCAN( oCtrl:aProperties, { |a| a[ 1 ] == Arg3 } )
         IF nPos > 0
            RetVal := oCtrl:aProperties[ nPos ][ 2 ]
         ENDIF

      ENDIF

   ELSEIF Pcount() == 4 // CONTROL (WITH ARGUMENT OR TOOLBAR BUTTON)

      oCtrl := GetExistingControlObject( Arg2, Arg1 )
      Arg3 := Upper( Arg3 )

      IF     Arg3 == "ITEM"
         RetVal := oCtrl:Item( Arg4 )

      ELSEIF Arg3 == "CAPTION"
         RetVal := oCtrl:Caption( Arg4 )

      ELSEIF Arg3 == "HEADER"
         RetVal := oCtrl:Header( Arg4 )

      ELSEIF Arg3 == "COLUMNWIDTH"
         RetVal := oCtrl:ColumnWidth( Arg4 )

      ELSEIF Arg3 == "PICTURE"
         RetVal := oCtrl:Picture( Arg4 )

      ELSEIF Arg3 == "IMAGE"
         RetVal := oCtrl:Picture( Arg4 )

      ELSEIF Arg3 == "GETPARENT"
         RetVal := oCtrl:GetParent( Arg4 )

      ELSEIF Arg3 == "GETCHILDREN"
         RetVal := oCtrl:GetChildren( Arg4 )

      ELSEIF Arg3 == "CHECKITEM"
         RetVal := oCtrl:CheckItem( Arg4 )

      ELSEIF Arg3 == "BOLDITEM"
         RetVal := oCtrl:BoldItem( Arg4 )

      ELSEIF Arg3 == "ITEMREADONLY"
         RetVal := oCtrl:ItemReadonly( Arg4 )

      ELSEIF Arg3 == "ITEMENABLED"
         RetVal := oCtrl:ItemEnabled( Arg4 )

      ELSEIF Arg3 == "ENABLED"
         RetVal := oCtrl:ItemEnabled( Arg4 )

      ELSEIF Arg3 == "ITEMDRAGGABLE"
         RetVal := oCtrl:ItemDraggable( Arg4 )

      ELSEIF Arg3 == "HANDLETOITEM"
         RetVal := oCtrl:HandleToItem( Arg4 )

      ELSE

         // If Property Not Matched Look For Contained Control
         // With No Arguments (ToolBar Button)

         IF oCtrl:Type == "TOOLBAR"

            IF oCtrl:hWnd != GetControlObject( Arg3 , Arg1 ):Container:hWnd
               MsgOOHGError('Control Does Not Belong To Container')
            ENDIF

            RetVal := GetProperty( Arg1 , Arg3 , Arg4 )

         ENDIF

      ENDIF

   ELSEIF Pcount() == 5 // CONTROL (WITH 2 ARGUMENTS)

      oCtrl := GetExistingControlObject( Arg2, Arg1 )
      Arg3 := Upper( Arg3 )

      IF     Arg3 == "CELL"
         RetVal := oCtrl:Cell( Arg4 , Arg5 )

      ENDIF

   ENDIF

   RETURN RetVal

FUNCTION DoMethod( ... )

   LOCAL RetVal, aPars, cMethod, oWnd, oCtrl

   RetVal := Nil

   IF PCount() == 2 // WINDOW
      aPars := HB_aParams()

      cMethod := Upper( aPars[2] )

      IF cMethod == 'ACTIVATE'
         IF HB_IsArray( aPars[1] )
            RetVal := _ActivateWindow( aPars[1] )
         ELSE
            oWnd := GetExistingFormObject( aPars[1] )
            RetVal := oWnd:Activate()
         ENDIF
      ELSEIF cMethod == 'SETFOCUS'
         IF oWnd:Active
            oWnd := GetExistingFormObject( aPars[1] )
            RetVal := oWnd:SetFocus()
         ENDIF
      ELSE
         oWnd := GetExistingFormObject( aPars[1] )
         IF _OOHG_HasMethod( oWnd, cMethod )
            RetVal := oWnd:&( cMethod )()
         ENDIF
      ENDIF

   ELSEIF PCount() > 2
      aPars := HB_aParams()

      oCtrl := GetExistingControlObject( aPars[2], aPars[1] )
      cMethod := Upper( aPars[3] )

      IF PCount() == 3 // CONTROL WITHOUT ARGUMENTS
         IF cMethod == 'SAVE'
            RetVal := oCtrl:SaveData()
         ELSEIF cMethod == 'ACTION'
            RetVal := oCtrl:DoEvent( oCtrl:OnClick, "CLICK" )
         ELSEIF cMethod == 'ONCLICK'
            RetVal := oCtrl:DoEvent( oCtrl:OnClick, "CLICK" )
         ELSEIF cMethod == 'ONGOTFOCUS'
            RetVal := oCtrl:DoEvent( oCtrl:OnGotFocus, "GOTFOCUS" )
         ELSEIF cMethod == 'ONLOSTFOCUS'
            RetVal := oCtrl:DoEvent( oCtrl:OnLostFocus, "LOSTFOCUS" )
         ELSEIF cMethod == 'ONDBLCLICK'
            RetVal := oCtrl:DoEvent( oCtrl:OnDblClick, "DBLCLICK" )
         ELSEIF cMethod == 'ONCHANGE'
            RetVal := oCtrl:DoEvent( oCtrl:OnChange, "CHANGE" )
         ELSEIF _OOHG_HasMethod( oCtrl, cMethod )
            RetVal := oCtrl:&( cMethod )()
         ENDIF

      ELSE // CONTROL WITH ARGUMENTS
         // Handle exceptions
         IF PCount() == 7
            IF cMethod == 'ADDCONTROL'
               RetVal := oCtrl:AddControl( GetControlObject( aPars[4], aPars[1] ), aPars[5], aPars[6], aPars[7] )

               RETURN RetVal
            ENDIF
         ENDIF

         // Handle other methods
         IF _OOHG_HasMethod( oCtrl, cMethod )
            aDel( aPars, 1 )
            aDel( aPars, 1 )
            aDel( aPars, 1 )
            aSize( aPars, Len( aPars ) - 3 )

            RetVal := HB_ExecFromArray( oCtrl, cMethod, aPars )
         ENDIF
      ENDIF
   ENDIF

   RETURN RetVal

   /*
   * This function returns .T. if msg is a METHOD (with or without SETGET)
   * or an INLINE (even if in the parent class msg is a DATA).
   * Note:
   * __objHasMethod( obj, msg ) doesn't recognizes SETGET methods as METHOD.
   */

FUNCTION _OOHG_HasMethod( obj, msg )

   LOCAL itm, aClsSel

   #ifndef __XHARBOUR__
   aClsSel := obj:ClassSel( HB_MSGLISTPURE, HB_OO_CLSTP_EXPORTED, .T. )
   #else
   aClsSel := obj:ClassFullSel( HB_MSGLISTPURE, HB_OO_CLSTP_EXPORTED )
   #endif

   FOR EACH itm in aClsSel
      IF itm[ HB_OO_DATA_TYPE ] == HB_OO_MSG_METHOD .or. itm[ HB_OO_DATA_TYPE ] == HB_OO_MSG_INLINE
         IF itm[ HB_OO_DATA_SYMBOL ] == msg

            RETURN .T.
         ENDIF
      ENDIF
   NEXT

   RETURN .F.

   /*
   * This function returns .T. only if msg is a pure DATA.
   * Note:
   * __objHasData( obj, msg ) recognizes SETGET methods as DATA.
   */

FUNCTION _OOHG_HasData( obj, msg )

   LOCAL itm, aClsSel

   #ifndef __XHARBOUR__
   aClsSel := obj:ClassSel( HB_MSGLISTPURE, HB_OO_CLSTP_EXPORTED, .T. )
   #else
   aClsSel := obj:ClassFullSel( HB_MSGLISTPURE, HB_OO_CLSTP_EXPORTED )
   #endif

   FOR EACH itm in aClsSel
      IF itm[ HB_OO_DATA_TYPE ] == HB_OO_MSG_DATA
         IF itm[ HB_OO_DATA_SYMBOL ] ==  msg

            RETURN .T.
         ENDIF
      ENDIF
   NEXT

   RETURN .F.

FUNCTION cFileNoPath( cPathMask )

   LOCAL n := RAt( "\", cPathMask )

   RETURN If( n > 0 .and. n < Len( cPathMask ), ;
      Right( cPathMask, Len( cPathMask ) - n ), ;
      If( ( n := At( ":", cPathMask ) ) > 0, ;
      Right( cPathMask, Len( cPathMask ) - n ), cPathMask ) )

FUNCTION cFileNoExt( cPathMask )

   LOCAL cName := AllTrim( cFileNoPath( cPathMask ) )
   LOCAL n     := At( ".", cName )

   RETURN AllTrim( If( n > 0, Left( cName, n - 1 ), cName ) )

FUNCTION NoArray (OldArray)

   LOCAL NewArray := {}
   LOCAL i

   IF ValType ( OldArray ) == 'U'

      RETURN NIL
   ELSE
      aSize( NewArray , Len (OldArray) )
   ENDIF

   FOR i := 1 To Len ( OldArray )

      IF OldArray [i] == .t.
         NewArray [i] := .f.
      ELSE
         NewArray [i] := .t.
      ENDIF

   NEXT i

   RETURN NewArray

FUNCTION _SetFontColor ( ControlName, ParentForm , Value  )

   RETURN ( GetControlObject( ControlName, ParentForm ):FontColor := Value )

FUNCTION _SetBackColor ( ControlName, ParentForm , Value  )

   RETURN ( GetControlObject( ControlName, ParentForm ):BackColor := Value )

FUNCTION _SetStatusIcon( ControlName , ParentForm , Item , Icon )

   RETURN SetStatusItemIcon( GetControlObject( ControlName, ParentForm ):hWnd, Item , Icon )

FUNCTION _GetCaption( ControlName , ParentForm )

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
   DATA OldColor
   DATA OldBackColor

   METHOD Row                SETGET
   METHOD Col                SETGET
   METHOD Width              SETGET
   METHOD Height             SETGET
   METHOD ToolTip            SETGET
   METHOD SetForm
   METHOD InitStyle
   METHOD Register
   METHOD TabIndex           SETGET
   METHOD Refresh            BLOCK { |self| ::ReDraw() }
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
   METHOD FontWidth          SETGET
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

   IF PCount() > 0
      IF ValType( cToolTip ) $ "CMB"
         ::cToolTip := cToolTip
      ELSE
         ::cToolTip := ""
      ENDIF
      IF HB_IsObject( oCtrl := ::oToolTip )
         oCtrl:Item( ::hWnd, cToolTip )
      ENDIF
   ENDIF

   RETURN ::cToolTip

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

   IF HB_IsLogical( lEditBox ) .AND. lEditBox
      // Background Color (edit or listbox):
      IF ValType( BkColor ) $ "ANCM"
         // Specified color
         ::BackColor := BkColor
      ELSEIF ValType( ::BackColor ) $ "ANCM"
         // Pre-registered
      ELSEIF ::Container != nil
         // Active frame
         ::BackColor := ::Container:DefBkColorEdit
      ELSEIF ValType( ::Parent:DefBkColorEdit ) $ "ANCM"
         // Active form
         ::BackColor := ::Parent:DefBkColorEdit
      ELSE
         // Default
      ENDIF
   ELSE
      // Background Color (static):
      IF ValType( BkColor ) $ "ANCM"
         // Specified color
         ::BackColor := BkColor
      ELSEIF ValType( ::BackColor ) $ "ANCM"
         // Pre-registered
      ELSEIF ::Container != nil
         // Active frame
         ::BackColor := ::Container:BackColor
      ELSEIF ValType( ::Parent:BackColor ) $ "ANCM"
         // Active form
         ::BackColor := ::Parent:BackColor
      ELSE
         // Default
      ENDIF
   ENDIF

   ::Name := _OOHG_GetNullName( ControlName )

   IF _IsControlDefined( ::Name, ::Parent:Name )
      MsgOOHGError( _OOHG_Messages( 3, 4 ) + ::Name + _OOHG_Messages( 3, 5 ) + ::Parent:Name + _OOHG_Messages( 3, 6 ) )
   ENDIF

   // Right-to-left
   IF _OOHG_GlobalRTL()
      ::lRtl := .T.
   ELSEIF HB_IsLogical( lRtl )
      ::lRtl := lRtl
   ELSEIF ! Empty( ::Container )
      ::lRtl := ::Container:lRtl
   ELSEIF ! Empty( ::Parent )
      ::lRtl := ::Parent:lRtl
   ELSE
      ::lRtl := .F.
   ENDIF

   // Anchor
   IF ValType( xAnchor ) $ "NCM"
      ::Anchor := xAnchor
   ELSEIF ::Container != nil
      // Active frame
      ::Anchor := ::Container:nDefAnchor
   ELSE
      // Active form
      ::Anchor := ::Parent:nDefAnchor
   ENDIF

   RETURN Self

METHOD InitStyle( nStyle, nStyleEx, lInvisible, lNoTabStop, lDisabled ) CLASS TControl

   IF !HB_IsNumeric( nStyle )
      nStyle := 0
   ENDIF
   IF !HB_IsNumeric( nStyleEx )
      nStyleEx := 0
   ENDIF

   IF HB_IsLogical( lInvisible )
      ::lVisible := ! lInvisible
   ENDIF
   IF ::ContainerVisible
      nStyle += WS_VISIBLE
   ENDIF

   IF !HB_IsLogical( lNoTabStop ) .OR. ! lNoTabStop
      nStyle += WS_TABSTOP
   ENDIF

   IF HB_IsLogical( lDisabled )
      ::lEnabled := ! lDisabled
   ENDIF
   IF ! ::ContainerEnabled
      nStyle += WS_DISABLED
   ENDIF

   RETURN nStyle

METHOD Register( hWnd, cName, HelpId, Visible, ToolTip, Id ) CLASS TControl

   LOCAL mVar

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

   IF HB_IsNumeric( Id )
      ::Id := Id
   ELSE
      ::Id := GetDlgCtrlId( ::hWnd )
   ENDIF

   AADD( _OOHG_aControlhWnd,    hWnd )
   AADD( _OOHG_aControlObjects, Self )
   AADD( _OOHG_aControlIds,     { ::Id, ::Parent:hWnd } )
   AADD( _OOHG_aControlNames,   UPPER( ::Parent:Name + CHR( 255 ) + ::Name ) )

   mVar := "_" + ::Parent:Name + "_" + ::Name
   PUBLIC &mVar. := Self

   RETURN Self

METHOD Release() CLASS TControl

   LOCAL mVar, oCont

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

   IF ValidHandler( ::hWnd )
      ReleaseControl( ::hWnd )
   ENDIF

   DeleteObject( ::FontHandle )
   DeleteObject( ::AuxHandle )

   mVar := '_' + ::Parent:Name + '_' + ::Name
   IF type ( mVar ) != 'U'
      __MVPUT( mVar , 0 )
   ENDIF

   RETURN ::Super:Release()

METHOD SetFont( FontName, FontSize, Bold, Italic, Underline, Strikeout, Angle, Fntwidth ) CLASS TControl

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
   IF ! EMPTY( Angle ) .AND. HB_IsNumeric( Angle )
      ::FntAngle := Angle
   ENDIF
   IF ! EMPTY( FntWidth ) .AND. HB_IsNumeric( FntWidth )
      ::Fntwidth := FntWidth
   ENDIF
   ::FontHandle := _SetFont( ::hWnd, ::cFontName, ::nFontSize, ::Bold, ::Italic, ::Underline, ::Strikeout, ::FntAngle, ::FntWidth )

   RETURN NIL

METHOD FontName( cFontName ) CLASS TControl

   IF ValType( cFontName ) $ "CM"
      ::cFontName:=cFontName
      ::SetFont( cFontName )
   ENDIF

   RETURN ::cFontName

METHOD FontSize( nFontSize ) CLASS TControl

   IF HB_IsNumeric( nFontSize )
      ::nFontSize:=nFontSize
      ::SetFont( , nFontSize )
   ENDIF

   RETURN ::nFontSize

METHOD FontBold( lBold ) CLASS TControl

   IF HB_IsLogical( lBold )
      ::Bold:=lBold
      ::SetFont( ,, lBold )
   ENDIF

   RETURN ::Bold

METHOD FontItalic( lItalic ) CLASS TControl

   IF HB_IsLogical( lItalic )
      ::Italic:=lItalic
      ::SetFont( ,,, lItalic )
   ENDIF

   RETURN ::Italic

METHOD FontUnderline( lUnderline ) CLASS TControl

   IF HB_IsLogical( lUnderline )
      ::Underline:=lUnderline
      ::SetFont( ,,,, lUnderline )
   ENDIF

   RETURN ::Underline

METHOD FontStrikeout( lStrikeout ) CLASS TControl

   IF HB_Islogical( lStrikeout )
      ::StrikeOut:=lStrikeout
      ::SetFont( ,,,,, lStrikeout )
   ENDIF

   RETURN ::Strikeout

METHOD FontAngle( nAngle ) CLASS TControl

   IF HB_IsNumeric( nAngle )
      ::FntAngle:=nAngle
      ::SetFont( ,,,,,, nAngle )
   ENDIF

   RETURN ::FntAngle

METHOD FontWidth( nWidth ) CLASS TControl

   IF HB_IsNumeric( nWidth )
      ::FntWidth:=nWidth
      ::SetFont( ,,,,,,, nWidth )
   ENDIF

   RETURN ::FntWidth

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
   IF nOldWidth != ::nWidth .OR. nOldHeight != ::nHeight
      AEVAL( ::aControls, { |o| o:AdjustAnchor( ::nHeight - nOldHeight, ::nWidth - nOldWidth ) } )
   ENDIF
   AEVAL( ::aControls, { |o| o:SizePos() } )
   AEVAL( ::aControls, { |o| o:Events_Size() } )

   RETURN xRet

METHOD Move( Row, Col, Width, Height ) CLASS TControl

   RETURN ::SizePos( Row, Col, Width, Height )

METHOD ForceHide() CLASS TControl

   ::Super:ForceHide()
   AEVAL( ::aControls, { |o| o:ForceHide() } )

   RETURN NIL

METHOD SetVarBlock( cField, uValue ) CLASS TControl

   IF ValType( cField ) $ "CM" .AND. ! Empty( cField )
      ::VarName := AllTrim( cField )
   ENDIF
   IF ValType( ::VarName ) $ "CM" .AND. ! Empty( ::VarName )
      ::Block := &( "{ | _x_ | if( PCount() == 0, ( " + ::VarName + " ), ( " + ::VarName + " := _x_ ) ) }" )
   ENDIF
   IF HB_IsBlock( ::Block )
      ::Value := EVAL( ::Block )
   ELSEIF PCount() > 1
      ::Value := uValue
   ENDIF

   RETURN NIL

METHOD ClearBitMaps CLASS TControl

   IF ValidHandler( ::ImageList )
      ImageList_Destroy( ::ImageList )
   ENDIF
   ::ImageList := 0

   RETURN NIL

METHOD AddBitMap( uImage ) CLASS TControl

   LOCAL nPos, nCount

   IF ! ValidHandler( ::ImageList )
      IF HB_IsArray( uImage )
         ::ImageList := ImageList_Init( uImage, ::ImageListColor, ::ImageListFlags )[ 1 ]
      ELSE
         ::ImageList := ImageList_Init( { uImage }, ::ImageListColor, ::ImageListFlags )[ 1 ]
      ENDIF
      IF ValidHandler( ::ImageList )
         nPos := 1
         SendMessage( ::hWnd, ::SetImageListCommand, ::SetImageListWParam, ::ImageList )
      ELSE
         nPos := 0
      ENDIF
   ELSE
      nCount := ImageList_GetImageCount( ::ImageList )
      IF HB_IsArray( uImage )
         nPos := ImageList_Add( ::ImageList, uImage[ 1 ], ::ImageListFlags, ::ImageListColor )
         AEVAL( uImage, { |c| ImageList_Add( ::ImageList, c, ::ImageListFlags, ::ImageListColor ) }, 2 )
      ELSE
         nPos := ImageList_Add( ::ImageList, uImage, ::ImageListFlags, ::ImageListColor )
      ENDIF
      IF nCount == ImageList_GetImageCount( ::ImageList )
         nPos := 0
      ENDIF
      SendMessage( ::hWnd, ::SetImageListCommand, ::SetImageListWParam, ::ImageList )
   ENDIF

   RETURN nPos

METHOD DoEvent( bBlock, cEventType, aParams ) CLASS TControl

   LOCAL lRetVal

   IF ! ::Parent == nil .AND. ::Parent:lReleasing
      lRetVal := .F.
   ELSEIF HB_IsBlock( bBlock )
      _PushEventInfo()
      _OOHG_ThisForm      := ::Parent
      _OOHG_ThisType      := "C"
      ASSIGN _OOHG_ThisEventType VALUE cEventType TYPE "CM" DEFAULT ""
      _OOHG_ThisControl   := Self
      _OOHG_ThisObject    := Self
      lRetVal := _OOHG_Eval_Array( bBlock, aParams )
      _PopEventInfo()
   ELSE
      lRetVal := .F.
   ENDIF

   RETURN lRetVal

METHOD DoEventMouseCoords( bBlock, cEventType ) CLASS TControl

   LOCAL aPos := GetCursorPos()

   // TODO: Use GetClientRect instead
   aPos[ 1 ] -= GetWindowRow( ::hWnd )
   aPos[ 2 ] -= GetWindowCol( ::hWnd )

   RETURN ::DoEvent( bBlock, cEventType, aPos )

METHOD DoLostFocus() CLASS TControl

   LOCAL uRet := Nil, nFocus, oFocus

   IF ! ::ContainerReleasing
      nFocus := GetFocus()
      IF nFocus > 0
         oFocus := GetControlObjectByHandle( nFocus )
         IF ! oFocus:lCancel
            IF _OOHG_lValidating

               RETURN NIL
            ENDIF
            _OOHG_lValidating := .T.
            uRet := _OOHG_Eval( ::postBlock, Self )
            IF HB_IsLogical( uRet ) .AND. ! uRet
               ::SetFocus()
               _OOHG_lValidating := .F.

               RETURN 1
            ENDIF
            _OOHG_lValidating := .F.
            uRet := Nil
         ENDIF
      ENDIF
      IF ! ( Empty( ::cFocusFontName ) .AND. Empty( ::nFocusFontSize ) .AND. Empty( ::FocusBold ) .AND. ;
            Empty( ::FocusItalic ) .AND. Empty( ::FocusUnderline ) .AND. Empty( ::FocusStrikeout ) )
         ::SetFont( ::cFontName, ::nFontSize, ::Bold, ::Italic, ::Underline, ::Strikeout )
         ::Refresh()
      ENDIF
      IF ! Empty( ::FocusColor )
         ::FontColor := ::OldColor
      ENDIF
      IF ! Empty( ::FocusBackColor )
         ::BackColor:=::OldBackColor
      ENDIF

      ::DoEvent( ::OnLostFocus, "LOSTFOCUS" )
   ENDIF

   RETURN uRet

METHOD DoChange() CLASS TControl

   LOCAL xValue, cType, cOldType

   xValue   := ::Value
   cType    := VALTYPE( xValue )
   cOldType := VALTYPE( ::xOldValue )
   cType    := IF( cType    == "M", "C", cType )
   cOldType := IF( cOldType == "M", "C", cOldType )
   IF cOldType == "U" .OR. ! cType == cOldType .OR. ! xValue == ::xOldValue
      ::xOldValue := xValue
      ::DoEvent( ::OnChange, "CHANGE" )
   ENDIF

   RETURN NIL

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
         hb_vmPushLong( ( LONG ) hWnd );
         hb_vmPushLong( message );
         hb_vmPushLong( wParam );
         hb_vmPushLong( lParam );
         hb_vmSend( 4 );
         break;
   }
}

/*
 * METHOD Events_Color( wParam, nDefColor ) CLASS TControl
 */
HB_FUNC_STATIC( TCONTROL_EVENTS_COLOR )
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
      SetBkMode( hdc, (COLORREF) TRANSPARENT );
      DeleteObject( oSelf->BrushHandle );
      oSelf->BrushHandle = GetStockObject( NULL_BRUSH );
      oSelf->lOldBackColor = -1;
      hb_retnl( (LONG) oSelf->BrushHandle );

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

/*
 * METHOD Events_Color( wParam, nDefColor ) CLASS TFRAME
 * METHOD Events_Color( wParam, nDefColor ) CLASS TCHECKBOX
 * METHOD Events_Color( wParam, nDefColor ) CLASS TRADIOGROUP
 * METHOD Events_Color( wParam, nDefColor ) CLASS TRADIOITEM
 */
HB_FUNC( EVENTS_COLOR_INTAB )
{
   PHB_ITEM pSelf = hb_param( 1, HB_IT_ANY );
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   HDC hdc = (HDC) hb_parnl( 2 );
   LONG lBackColor;
   RECT rc;
   LPRECT lprc;
   BOOL bTransparent;
   BOOL bDefault;
   HWND hwnd;
   LONG style;

   if( oSelf->lFontColor != -1 )
   {
      SetTextColor( hdc, (COLORREF) oSelf->lFontColor );
   }

   _OOHG_Send( pSelf, s_TabHandle );
   hb_vmSend( 0 );
   hwnd = HWNDparam( -1 );

   if( ValidHandler( hwnd ) )
   {
      _OOHG_Send( pSelf, s_Transparent );
      hb_vmSend( 0 );
      bTransparent = hb_parl( -1 );

      lBackColor = ( oSelf->lUseBackColor != -1 ) ? oSelf->lUseBackColor : oSelf->lBackColor;
      bDefault = ( lBackColor == -1 );

      if( bTransparent || bDefault )
      {
         style = GetWindowLong( hwnd, GWL_STYLE );

         if( style & TCS_BUTTONS )
         {
            _OOHG_Send( pSelf, s_Transparent );
            hb_vmSend( 0 );
            if( hb_parl( -1 ) )
            {
               SetBkMode( hdc, (COLORREF) TRANSPARENT );
               DeleteObject( oSelf->BrushHandle );
               oSelf->BrushHandle = GetStockObject( NULL_BRUSH );
               oSelf->lOldBackColor = -1;
               hb_retnl( (LONG) oSelf->BrushHandle );

               return;
            }

            lBackColor = ( oSelf->lUseBackColor != -1 ) ? oSelf->lUseBackColor : oSelf->lBackColor;
            if( lBackColor == -1 )
            {
               lBackColor = hb_parnl( 3 );           // nDefColor
            }
         }
         else
         {
            SetBkMode( hdc, (COLORREF) TRANSPARENT );
            DeleteObject( oSelf->BrushHandle );
            oSelf->BrushHandle = GetTabBrush( hwnd );
            oSelf->lOldBackColor = -1;

            GetWindowRect( oSelf->hWnd, &rc );
            lprc = &rc;
            MapWindowPoints( HWND_DESKTOP, hwnd, (LPPOINT) lprc, 2 );
            SetBrushOrgEx( hdc, -rc.left, -rc.top, NULL );

            hb_retnl( (LONG) oSelf->BrushHandle );

            return;
         }
      }
   }
   else
   {
      _OOHG_Send( pSelf, s_Type );
      hb_vmSend( 0 );
      if( strcmp( hb_parc( -1 ), "RADIOITEM" ) == 0 )
//      if( ( strcmp( hb_parc( -1 ), "RADIOITEM" ) == 0 ) || ( strcmp( hb_parc( -1 ), "CHECKBOX" ) == 0 ) || ( strcmp( hb_parc( -1 ), "FRAME" ) == 0 ) )
      {
         _OOHG_Send( pSelf, s_oBkGrnd );
         hb_vmSend( 0 );
         if( hb_param( -1, HB_IT_OBJECT ) )
         {
            _OOHG_Send( hb_param( -1, HB_IT_OBJECT ), s_hWnd );
            hb_vmSend( 0 );
            hwnd = HWNDparam( -1 );

            if( ValidHandler( hwnd ) )
            {
               SetBkMode( hdc, (COLORREF) TRANSPARENT );
               DeleteObject( oSelf->BrushHandle );
               oSelf->BrushHandle = GetTabBrush( hwnd );
               oSelf->lOldBackColor = -1;

               GetWindowRect( oSelf->hWnd, &rc );
               lprc = &rc;
               MapWindowPoints( HWND_DESKTOP, hwnd, (LPPOINT) lprc, 2 );
               SetBrushOrgEx( hdc, -rc.left, -rc.top, NULL );

               hb_retnl( (LONG) oSelf->BrushHandle );

               return;
            }
         }
      }

      _OOHG_Send( pSelf, s_Transparent );
      hb_vmSend( 0 );
      if( hb_parl( -1 ) )
      {
         SetBkMode( hdc, (COLORREF) TRANSPARENT );
         DeleteObject( oSelf->BrushHandle );
         oSelf->BrushHandle = GetStockObject( NULL_BRUSH );
         oSelf->lOldBackColor = -1;
         hb_retnl( (LONG) oSelf->BrushHandle );

         return;
      }

      lBackColor = ( oSelf->lUseBackColor != -1 ) ? oSelf->lUseBackColor : oSelf->lBackColor;
      if( lBackColor == -1 )
      {
         lBackColor = hb_parnl( 3 );           // nDefColor
      }
   }

   SetBkColor( hdc, (COLORREF) lBackColor );
   if( lBackColor != oSelf->lOldBackColor )
   {
      oSelf->lOldBackColor = lBackColor;
      DeleteObject( oSelf->BrushHandle );
      oSelf->BrushHandle = CreateSolidBrush( lBackColor );
   }

   hb_retnl( (LONG) oSelf->BrushHandle );
}

#pragma ENDDUMP

METHOD Events_Command( wParam ) CLASS TControl

   LOCAL Hi_wParam := HIWORD( wParam )

   IF Hi_wParam == BN_CLICKED .OR. Hi_wParam == STN_CLICKED  // Same value.....
      IF ! ::NestedClick
         ::NestedClick := ! _OOHG_NestedSameEvent()
         ::DoEventMouseCoords( ::OnClick, "CLICK" )
         ::NestedClick := .F.
      ENDIF

   ELSEIF Hi_wParam == EN_CHANGE
      ::DoChange()

   ELSEIF Hi_wParam == EN_KILLFOCUS

      RETURN ::DoLostFocus()

   ELSEIF Hi_wParam == EN_SETFOCUS
      GetFormObjectByHandle( ::ContainerhWnd ):LastFocusedControl := ::hWnd
      ::FocusEffect()
      ::DoEvent( ::OnGotFocus, "GOTFOCUS" )

   ELSEIF Hi_wParam == BN_KILLFOCUS

      RETURN ::DoLostFocus()

   ELSEIF Hi_wParam == BN_SETFOCUS
      GetFormObjectByHandle( ::ContainerhWnd ):LastFocusedControl := ::hWnd
      ::FocusEffect()
      ::DoEvent( ::OnGotFocus, "GOTFOCUS" )

   ENDIF

   RETURN NIL

METHOD FocusEffect CLASS TControl

   LOCAL lMod

   IF     ! Empty( ::cFocusFontName )
      lMod := .T.
   ELSEIF ! Empty( ::nFocusFontSize )
      lMod := .T.
   ELSEIF ! Empty( ::FocusBold )
      lMod := .T.
   ELSEIF ! Empty( ::FocusItalic )
      lMod := .T.
   ELSEIF ! Empty( ::FocusUnderline )
      lMod := .T.
   ELSEIF ! Empty( ::FocusStrikeout )
      lMod := .T.
   ELSEIF ::Parent == Nil
      lMod := .F.
   ELSEIF ( _OOHG_HasData( ::Parent, "CFOCUSFONTNAME" ) .OR. _OOHG_HasMethod( ::Parent, "CFOCUSFONTNAME" ) ) .AND. ! Empty( ::Parent:cFocusFontName )
      lMod := .T.
   ELSEIF ( _OOHG_HasData( ::Parent, "NFOCUSFONTSIZE" ) .OR. _OOHG_HasMethod( ::Parent, "NFOCUSFONTSIZE" ) ) .AND. ! Empty( ::Parent:nFocusFontSize )
      lMod := .T.
   ELSEIF ( _OOHG_HasData( ::Parent, "FOCUSBOLD" )      .OR. _OOHG_HasMethod( ::Parent, "FOCUSBOLD" ) )      .AND. ! Empty( ::Parent:FocusBold )
      lMod := .T.
   ELSEIF ( _OOHG_HasData( ::Parent, "FOCUSITALIC" )    .OR. _OOHG_HasMethod( ::Parent, "FOCUSITALIC" ) )    .AND. ! Empty( ::Parent:FocusItalic )
      lMod := .T.
   ELSEIF ( _OOHG_HasData( ::Parent, "FOCUSUNDERLINE" ) .OR. _OOHG_HasMethod( ::Parent, "FOCUSUNDERLINE" ) ) .AND. ! Empty( ::Parent:FocusUnderline )
      lMod := .T.
   ELSEIF ( _OOHG_HasData( ::Parent, "FOCUSSTRIKEOUT" ) .OR. _OOHG_HasMethod( ::Parent, "FOCUSSTRIKEOUT" ) ) .AND. ! Empty( ::Parent:FocusStrikeout )
      lMod := .T.
   ELSE
      lMod := .F.
   ENDIF

   IF lMod
      IF Empty( ::cFocusFontName )
         IF ::Parent != Nil .AND. ( _OOHG_HasData( ::Parent, "CFOCUSFONTNAME" ) .OR. _OOHG_HasMethod( ::Parent, "CFOCUSFONTNAME" ) ) .AND. ! Empty( ::Parent:cFocusFontName )
            ::cFocusFontName := ::Parent:cFocusFontName
         ENDIF
      ENDIF
      IF Empty( ::cFocusFontName )
         ::cFocusFontName := ::cFontName
      ENDIF

      IF Empty( ::nFocusFontSize )
         IF ::Parent != Nil .AND. ( _OOHG_HasData( ::Parent, "NFOCUSFONTSIZE" ) .OR. _OOHG_HasMethod( ::Parent, "NFOCUSFONTSIZE" ) ) .AND. ! Empty( ::Parent:nFocusFontSize )
            ::nFocusFontSize := ::Parent:nFocusFontSize
         ENDIF
      ENDIF
      IF Empty( ::nFocusFontSize )
         ::nFocusFontSize := ::nFontSize
      ENDIF

      IF Empty( ::FocusBold )
         IF ::Parent != Nil .AND. ( _OOHG_HasData( ::Parent, "FOCUSBOLD" ) .OR. _OOHG_HasMethod( ::Parent, "FOCUSBOLD" ) ) .AND. ! Empty( ::Parent:FocusBold )
            ::FocusBold := ::Parent:FocusBold
         ENDIF
      ENDIF
      IF Empty( ::FocusBold )
         ::FocusBold := ::Bold
      ENDIF

      IF Empty( ::FocusItalic )
         IF ::Parent != Nil .AND. ( _OOHG_HasData( ::Parent, "FOCUSITALIC" ) .OR. _OOHG_HasMethod( ::Parent, "FOCUSITALIC" ) ) .AND. ! Empty( ::Parent:FocusItalic )
            ::FocusItalic := ::Parent:FocusItalic
         ENDIF
      ENDIF
      IF Empty( ::FocusItalic )
         ::FocusItalic := ::Italic
      ENDIF

      IF Empty( ::FocusUnderline )
         IF ::Parent != Nil .AND. ( _OOHG_HasData( ::Parent, "FOCUSUNDERLINE" ) .OR. _OOHG_HasMethod( ::Parent, "FOCUSUNDERLINE" ) ) .AND. ! Empty( ::Parent:FocusUnderline )
            ::FocusUnderline := ::Parent:FocusUnderline
         ENDIF
      ENDIF
      IF Empty( ::FocusUnderline )
         ::FocusUnderline := ::Underline
      ENDIF

      IF Empty( ::FocusStrikeout )
         IF ::Parent != Nil .AND. ( _OOHG_HasData( ::Parent, "FOCUSSTRIKEOUT" ) .OR. _OOHG_HasMethod( ::Parent, "FOCUSSTRIKEOUT" ) ) .AND. ! Empty( ::Parent:FocusStrikeout )
            ::FocusStrikeout := ::Parent:FocusStrikeout
         ENDIF
      ENDIF
      IF Empty( ::FocusStrikeout )
         ::FocusStrikeout := ::Strikeout
      ENDIF

      ::FontHandle := _SetFont( ::hWnd, ::cFocusFontName, ::nFocusFontSize, ::FocusBold, ::FocusItalic, ::FocusUnderline, ::FocusStrikeout, ::FntAngle, ::FntWidth )
   ENDIF

   IF ! Empty( ::FocusColor )
      ::OldColor := ::FontColor
      ::FontColor := ::FocusColor
      lMod := .T.
   ELSEIF ::Parent != Nil .AND. ( _OOHG_HasData( ::Parent, "FOCUSCOLOR" ) .OR. _OOHG_HasMethod( ::Parent, "FOCUSCOLOR" ) ) .AND. ! Empty( ::Parent:FocusColor )
      ::OldColor := ::FontColor
      ::FocusColor := ::Parent:FocusColor
      ::FontColor := ::FocusColor
      lMod := .T.
   ENDIF

   IF ! Empty( ::FocusBackColor )
      ::OldBackColor := ::BackColor
      ::BackColor := ::FocusBackColor
      lMod := .T.
   ELSEIF ::Parent != Nil .AND. ( _OOHG_HasData( ::Parent, "FOCUSBACKCOLOR" ) .OR. _OOHG_HasMethod( ::Parent, "FOCUSBACKCOLOR" ) ) .AND. ! Empty( ::Parent:FocusBackColor )
      ::OldBackColor := ::BackColor
      ::FocusBackColor := ::Parent:FocusBackColor
      ::BackColor  := ::FocusBackColor
      lMod := .T.
   ENDIF

   IF lMod
      ::ReDraw()
   ENDIF

   RETURN NIL

METHOD Events_Enter() CLASS TControl

   _OOHG_lSettingFocus := .F.
   ::DoEvent( ::OnEnter, "ENTER" )
   IF ! _OOHG_lSettingFocus
      IF _OOHG_ExtendedNavigation
         _SetNextFocus()
      ENDIF
   ELSE
      _OOHG_lSettingFocus := .F.
   ENDIF

   RETURN NIL

METHOD Events_Notify( wParam, lParam ) CLASS TControl

   LOCAL nNotify := GetNotifyCode( lParam )

   HB_SYMBOL_UNUSED( wParam )

   IF     nNotify == NM_KILLFOCUS

      RETURN ::DoLostFocus()

   ELSEIF nNotify == NM_SETFOCUS
      GetFormObjectByHandle( ::ContainerhWnd ):LastFocusedControl := ::hWnd
      ::FocusEffect()
      ::DoEvent( ::OnGotFocus, "GOTFOCUS" )

   ELSEIF nNotify == TVN_SELCHANGED
      ::DoChange()

   ENDIF

   RETURN NIL

METHOD TabIndex( nNewIndex ) CLASS TControl

   LOCAL nCurIndex, i, nLen, j, aAux

   IF ::Parent == NIL
      nCurIndex := 0
   ELSE
      i := aScan( ::Parent:aControlsNames, Upper( AllTrim( ::Name ) ) + Chr( 255 ) )
      IF i > 0
         nCurIndex := ::Parent:aCtrlsTabIndxs[ i ]
         IF HB_IsNumeric( nNewIndex ) .AND. nNewIndex != nCurIndex
            nLen := LEN( ::Parent:aControls )
            // update indexes in array
            FOR j := 1 TO nLen
               IF nCurIndex > nNewIndex
                  // control is moved upward in the tab order
                  IF ::Parent:aCtrlsTabIndxs[ j ] < nCurIndex .AND. ::Parent:aCtrlsTabIndxs[ j ] >= nNewIndex
                     ::Parent:aCtrlsTabIndxs[ j ] ++
                  ENDIF
               ELSE
                  // control is moved downward in the tab order
                  IF ::Parent:aCtrlsTabIndxs[ j ] > nCurIndex .AND. ::Parent:aCtrlsTabIndxs[ j ] <= nNewIndex
                     ::Parent:aCtrlsTabIndxs[ j ] --
                  ENDIF
               ENDIF
            NEXT
            ::Parent:aCtrlsTabIndxs[ i ] := nCurIndex := nNewIndex
            // change tab order
            aAux := {}
            FOR j := 1 to nLen
               AADD( aAux, { ::Parent:aControls[ j ], ::Parent:aCtrlsTabIndxs[ j ] } )
            NEXT j
            ASORT( aAux, nil, nil, { | x, y | x[ 2 ] < y[ 2 ] } )
            FOR j := 2 to nLen
               SetTabAfter( aAux[ j, 1 ]:hWnd, aAux[ j - 1, 1 ]:hWnd )
            NEXT j
            // renumber tab indexes so they remain 1-based
            FOR j := 1 to nLen
               i := aScan( ::Parent:aControlsNames, Upper( AllTrim( aAux[ j, 1 ]:Name ) ) + Chr( 255 ) )
               ::Parent:aCtrlsTabIndxs[ i ] := j
            NEXT j
         ENDIF
      ELSE
         nCurIndex := 0
      ENDIF
   ENDIF

   RETURN nCurIndex

FUNCTION GetControlObject( ControlName, FormName )

   LOCAL mVar

   mVar := '_' + FormName + '_' + ControlName

   RETURN IF( Type( mVar ) == "O", &mVar, TControl() )

FUNCTION GetExistingControlObject( ControlName, FormName )

   LOCAL mVar

   mVar := '_' + FormName + '_' + ControlName
   IF ! Type( mVar ) == "O"
      MsgOOHGError( "Control: " + ControlName + " of " + FormName + " not defined. Program terminated." )
   ENDIF

   RETURN &mVar

FUNCTION _GetId()

   LOCAL RetVal

   DO WHILE .T.
      RetVal := Int( hb_random( 59000 ) ) + 2001   // Lower than 0xF000
      IF RetVal < 61440 .AND. aScan( _OOHG_aControlIds , { |a| a[ 1 ] == RetVal } ) == 0          // TODO: thread safe, move to h_application.prg
         EXIT
      ENDIF
   ENDDO

   RETURN RetVal

FUNCTION _KillAllTimers()

   LOCAL nIndex

   // Since ::Release() removes the control from array, it can't be an AEVAL()
   nIndex := 1
   DO WHILE nIndex <= LEN( _OOHG_aControlObjects )
      IF _OOHG_aControlObjects[ nIndex ]:Type == "TIMER"
         _OOHG_aControlObjects[ nIndex ]:Release()
      ELSE
         nIndex++
      ENDIF
   ENDDO

   RETURN NIL

FUNCTION GetStartUpFolder()

   LOCAL StartUpFolder := GetProgramFileName()

   RETURN Left ( StartUpFolder , Rat ( '\' , StartUpFolder ) - 1 )

   // Initializes C variables

PROCEDURE _OOHG_Init_C_Vars_Controls()

   TControl()
   _OOHG_Init_C_Vars_Controls_C_Side( _OOHG_aControlhWnd, _OOHG_aControlObjects, _OOHG_aControlIds )

   RETURN

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

   RETURN Self

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

   RETURN NIL
