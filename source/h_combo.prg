/*
 * $Id: h_combo.prg,v 1.70 2013-06-10 00:31:30 fyurisich Exp $
 */
/*
 * ooHG source code:
 * PRG combobox functions
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

CLASS TCombo FROM TLabel
   DATA Type                  INIT "COMBO" READONLY
   DATA WorkArea              INIT ""
   DATA Field                 INIT ""
   DATA ValueSource           INIT ""
   DATA nTextHeight           INIT 0
   DATA aValues               INIT {}
   DATA nWidth                INIT 120
   DATA nHeight2              INIT 150
   DATA lAdjustImages         INIT .F.
   DATA ImageListColor        INIT CLR_DEFAULT
   DATA ImageListFlags        INIT LR_LOADTRANSPARENT + LR_DEFAULTCOLOR + LR_LOADMAP3DCOLORS
   DATA OnListDisplay         INIT NIL
   DATA OnListClose           INIT NIL
   DATA ImageSource           INIT NIL
   DATA ItemNumber            INIT NIL
   DATA nLastItem             INIT 0
   DATA lDelayLoad            INIT .F.
   DATA SearchLapse           INIT 1000
   DATA cText                 INIT ""
   DATA uIniTime              INIT 0
   DATA nLastFound            INIT 0
   DATA lIncremental          INIT .F.

   METHOD Define
   METHOD nHeight             SETGET
   METHOD Refresh
   METHOD Value               SETGET
   METHOD Visible             SETGET
   METHOD ForceHide           BLOCK { |Self| SendMessage( ::hWnd, CB_SHOWDROPDOWN, 0, 0 ), ::Super:ForceHide() }
   METHOD RefreshData
   METHOD DisplayValue        SETGET    /// Caption Alias
   METHOD PreRelease
   METHOD Events
   METHOD Events_Command
   METHOD Events_DrawItem
   METHOD Events_MeasureItem
   METHOD AddItem
   METHOD DeleteItem(nPos)    BLOCK { |Self,nPos| ComboboxDeleteString( ::hWnd, nPos ) }
   METHOD DeleteAllItems      BLOCK { |Self| ComboboxReset( ::hWnd ), ::xOldValue := nil }
   METHOD Item                BLOCK { |Self, nItem, uValue| ComboItem( Self, nItem, uValue ) }
   METHOD ItemBySource
   METHOD InsertItem
   METHOD ItemCount           BLOCK { |Self| ComboboxGetItemCount( ::hWnd ) }
   METHOD ShowDropDown
   METHOD SelectFirstItem     BLOCK { |Self| ComboSetCursel( ::hWnd, 1 ) }
   METHOD GetDropDownWidth
   METHOD SetDropDownWidth
   METHOD AutosizeDropDown
   METHOD Autosize            SETGET
   METHOD GetEditSel
   METHOD SetEditSel
   METHOD CaretPos            SETGET
   METHOD ItemHeight
   METHOD VisibleItems

   EMPTY( _OOHG_AllVars )
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, rows, value, fontname, ;
               fontsize, tooltip, changeprocedure, h, gotfocus, lostfocus, ;
               uEnter, HelpId, invisible, notabstop, sort, bold, italic, ;
               underline, strikeout, itemsource, valuesource, displaychange, ;
               ondisplaychangeprocedure, break, GripperText, aImage, lRtl, ;
               TextHeight, lDisabled, lFirstItem, lAdjustImages, backcolor, ;
               fontcolor, listwidth, onListDisplay, onListClose, ImageSource, ;
               ItemNumber, lDelayLoad, lIncremental, lWinSize ) CLASS TCombo
*-----------------------------------------------------------------------------*
Local ControlHandle, WorkArea, cField, nStyle

   ASSIGN ::nCol          VALUE x TYPE "N"
   ASSIGN ::nRow          VALUE y TYPE "N"
   ASSIGN ::nWidth        VALUE w TYPE "N"
   ASSIGN ::nHeight       VALUE h TYPE "N"
   DEFAULT rows           TO {}
   DEFAULT sort           TO FALSE
   DEFAULT GripperText    TO ""
   ASSIGN ::nTextHeight   VALUE TextHeight    TYPE "N"
   ASSIGN displaychange   VALUE displaychange TYPE "L" DEFAULT .F.
   ASSIGN ::lAdjustImages VALUE lAdjustImages TYPE "L"
   ASSIGN ::ImageSource   VALUE ImageSource   TYPE "B"
   ASSIGN ::ItemNumber    VALUE ItemNumber    TYPE "B"
   ASSIGN ::lDelayLoad    VALUE lDelayLoad    TYPE "L" DEFAULT .F.
   ASSIGN ::lIncremental  VALUE lIncremental  TYPE "L" DEFAULT .F.
   ASSIGN lWinSize        VALUE lWinSize      TYPE "L" DEFAULT .F.

   If HB_IsArray( ValueSource )
      ::aValues := ValueSource
      ValueSource := NIL
   EndIf

   ::SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor, .t., lRtl )
   ::SetFont(, , bold, italic, underline, strikeout )

   If ::lDelayLoad .And. Sort
      MsgOOHGError( "Sort and DelayLoad clauses can't be used simultaneously. Program Terminated." )
   EndIf

   If ValType( ItemSource ) != 'U' .And. Sort == .T.
      MsgOOHGError( "Sort and ItemSource clauses can't be used simultaneously. Program Terminated." )
   EndIf

   If ValType( ValueSource ) != 'U' .And. Sort == .T.
      MsgOOHGError( "Sort and ValueSource clauses can't be used simultaneously. Program Terminated." )
   EndIf

   If ValType( ItemSource ) != 'U'
      If ! '->' $ ItemSource
         MsgOOHGError( "Control: " + ControlName + " Of " + ParentForm + " : You must specify a fully qualified field name. Program Terminated." )
      Else
         WorkArea := Left( ItemSource, At( '->', ItemSource ) - 1 )
         cField := Right( ItemSource, Len( ItemSource ) - At( '->', ItemSource ) - 1 )
      EndIf
   EndIf
   
   nStyle := ::InitStyle(, , Invisible, notabstop, lDisabled ) + ;
             if( HB_IsLogical( SORT ) .AND. SORT, CBS_SORT, 0 ) + ;
             if( ! displaychange, CBS_DROPDOWNLIST, CBS_DROPDOWN ) + ;
             if ( HB_IsArray( aImage ) .OR. HB_IsBlock( ItemNumber ), CBS_OWNERDRAWFIXED, 0) + ;
             if( OSisWinXPorLater() .AND. _OOHG_LastFrame() != "SPLITBOX" .AND. ! lWinSize, CBS_NOINTEGRALHEIGHT, 0 )

   ::SetSplitBoxInfo( Break, GripperText, ::nWidth )
   ControlHandle := InitComboBox( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::nWidth, ::nHeight, nStyle, ::lRtl )

   ::Register( ControlHandle, ControlName, HelpId, , ToolTip )
   ::SetFont()

   ::Field := cField
   ::WorkArea := WorkArea
   ::ValueSource := valuesource

   If HB_IsArray( aImage )
      ::AddBitMap( aImage )
   EndIf

   If HB_IsNumeric( ListWidth )
      ::SetDropDownWidth( ListWidth )
   EndIf

   If VALTYPE( WorkArea ) $ "CM"
      ::Refresh()
   Else
      AEval( rows, { |x| ::AddItem( x ) } )
   EndIf

   If HB_IsLogical( lFirstItem ) .AND. lFirstItem .AND. ::ItemCount > 0
      ::SelectFirstItem()
   EndIf
   
   ::Value := Value

   ASSIGN ::OnClick       VALUE ondisplaychangeprocedure TYPE "B"
   ASSIGN ::OnLostFocus   VALUE LostFocus                TYPE "B"
   ASSIGN ::OnGotFocus    VALUE GotFocus                 TYPE "B"
   ASSIGN ::OnChange      VALUE ChangeProcedure          TYPE "B"
   ASSIGN ::OnEnter       VALUE uEnter                   TYPE "B"
   ASSIGN ::onListDisplay VALUE onListDisplay            TYPE "B"
   ASSIGN ::onListClose   VALUE onListClose              TYPE "B"

Return Self

*-----------------------------------------------------------------------------*
METHOD nHeight( nHeight ) CLASS TCombo
*-----------------------------------------------------------------------------*
   If HB_IsNumeric( nHeight ) .AND. ! ValidHandler( ::hWnd )
      ::nHeight2 := nHeight
   EndIf
RETURN ::nHeight2

*-----------------------------------------------------------------------------*
METHOD VisibleItems() CLASS TCombo
*-----------------------------------------------------------------------------*
   Local nRet

   If IsWindowStyle( ::hWnd, CBS_NOINTEGRALHEIGHT )
      nRet := ::nHeight / ::ItemHeight()
      If nRet - int( nRet ) > 0
         nRet := int( nRet ) + 1
      EndIf
   Else
      nRet := SendMessage( ::hWnd, CB_GETMINVISIBLE, 0, 0 ) * 2
   EndIf
RETURN nRet

*-----------------------------------------------------------------------------*
METHOD Refresh() CLASS TCombo
*-----------------------------------------------------------------------------*
Local BackRec, WorkArea, cField, aValues, uValue
Local lRefreshImages, aImages, nMax, nCount

   WorkArea := ::WorkArea
   If Select( WorkArea ) != 0
      If HB_IsBlock( ::ImageSource )
         lRefreshImages := .T.
         aImages := {}
      Else
         lRefreshImages := .F.
      EndIf

      uValue := ::Value
      cField := ::Field
      BackRec := ( WorkArea )->( RecNo() )

      If OSisWinXPorLater() .AND. ::lDelayLoad
         nMax := ::VisibleItems * 2
      Else
         nMax := ( WorkArea )->( LastRec() )
      EndIf

      ( WorkArea )->( DBGoTop() )
      If ( WorkArea )->( Eof() )
         ::nLastItem := 0
      EndIf

      nCount := 0

      ComboboxReset( ::hWnd )
      aValues := {}

      Do While ! ( WorkArea )->( Eof() ) .and. nCount < nMax
//         ComboAddString( ::hWnd, ( WorkArea )-> &( cField ) )
         ::AddItem( { ( WorkArea )-> &( cField ), _OOHG_Eval( ::ItemNumber ) } )
         AADD( aValues, If( Empty( ::ValueSource ), ( WorkArea )->( RecNo() ), &( ::ValueSource ) ) )
         If lRefreshImages
            AADD( aImages, Eval( ::ImageSource ) )
         EndIf
         
         ::nLastItem := ( WorkArea )->( Recno() )
         ( WorkArea )->( DBSkip() )
         nCount ++
      EndDo
      ( WorkArea )->( DBGoTo( BackRec ) )
      
      If lRefreshImages
         If ValidHandler( ::ImageList )
           ImageList_Destroy( ::ImageList )
         EndIf
         ::ImageList := 0

         ::AddBitMap( aImages )
      EndIf

      ::aValues := aValues
      ::Value := uValue
   EndIf

RETURN nil

*------------------------------------------------------------------------------*
METHOD DisplayValue( cValue ) CLASS TCombo
*------------------------------------------------------------------------------*
Return ( ::Caption := cValue )

*-----------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TCombo
*-----------------------------------------------------------------------------*
LOCAL uRet
   IF LEN( ::aValues ) == 0
      IF HB_IsNumeric( uValue )
         ComboSetCursel( ::hWnd, uValue )
         ::DoChange()
      ENDIF
      uRet := ComboGetCursel( ::hWnd )
   ELSE
      IF VALTYPE( ::aValues[ 1 ] ) == VALTYPE( uValue ) .OR. ;
         ( VALTYPE( uValue ) $ "CM" .AND. VALTYPE( ::aValues[ 1 ] ) $ "CM" )
         ComboSetCursel( ::hWnd, ASCAN( ::aValues, uValue ) )
          ::DoChange()
      ENDIF
      uRet := ComboGetCursel( ::hWnd )
      IF uRet >= 1 .AND. uRet <= LEN( ::aValues )
         uRet := ::aValues[ uRet ]
      ELSE
         uRet := 0
      ENDIF
   ENDIF
RETURN uRet

*-----------------------------------------------------------------------------*
METHOD Visible( lVisible ) CLASS TCombo
*-----------------------------------------------------------------------------*
   IF HB_IsLogical( lVisible )
      ::Super:Visible := lVisible
      IF ! lVisible
         SendMessage( ::hWnd, CB_SHOWDROPDOWN, 0, 0 )
      ENDIF
   ENDIF
RETURN ::lVisible

*-----------------------------------------------------------------------------*
METHOD RefreshData() CLASS TCombo
*-----------------------------------------------------------------------------*
   ::Refresh()
RETURN ::Super:RefreshData()

*-----------------------------------------------------------------------------*
METHOD PreRelease() CLASS TCombo
*-----------------------------------------------------------------------------*
   If ! SendMessage( ::hWnd, CB_GETDROPPEDSTATE, 0, 0 ) == 0
      SendMessage( ::hWnd, CB_SHOWDROPDOWN, 0, 0 )
   EndIf
Return ::Super:PreRelease()

*-----------------------------------------------------------------------------*
METHOD ShowDropDown( lShow ) CLASS TCombo
*-----------------------------------------------------------------------------*
   ASSIGN lShow VALUE lShow TYPE "L" DEFAULT .T.
   If lShow
      SendMessage( ::hWnd, CB_SHOWDROPDOWN, 1, 0 )
   Else
      SendMessage( ::hWnd, CB_SHOWDROPDOWN, 0, 0 )
   EndIf
RETURN nil

*-----------------------------------------------------------------------------*
METHOD AutoSizeDropDown( lResizeBox, nMinWidth, nMaxWidth ) CLASS TCombo
*-----------------------------------------------------------------------------*
Local nCounter, nNewWidth, nScrollWidth := GetVScrollBarWidth()

/*
lResizeBox = Resize dropdown list and combobox (.t.) or dropdown list only (.f.)
defaults to .f.
*/
   ASSIGN lResizeBox VALUE lResizeBox TYPE "L" DEFAULT .F.

/*
Compute the space needed to show the longest item in the dropdown list.
The extra character "0" is added to provide room for the margin in the dropdown list.
*/
   nNewWidth := GetTextWidth( NIL, "0", ::FontHandle ) + ::IconWidth + nScrollWidth

   For nCounter := 1 to ::ItemCount
      nNewWidth := max( GetTextWidth( NIL, ::Item(nCounter) + "0", ::FontHandle ) + ::IconWidth + nScrollWidth, nNewWidth )
   Next

/*
nMinWidth = minimum width of dropdown list.
If ommited or is less than 0, defaults to 0 if lResizeBox == .T. or to combobox width otherwise.
*/
   If ! HB_IsNumeric( nMinWidth ) .or. nMinWidth < 0
      nMinWidth := if( lResizeBox, 0, ::Width )
   EndIf
      
/*
If the computed value is less than the minimum, use the minimum.
*/
   nNewWidth := max( nNewWidth, nMinWidth )

/*
nMaxWidth = maximum width of dropdown list, if ommited defaults to longest item's width
If no maximum specified or is less than minimun, use computed value as maximum.
*/
   If ! HB_IsNumeric( nMaxWidth ) .or. nMaxWidth < nMinWidth
      nMaxWidth := nNewWidth
   EndIf

/*
If the computed value is greater than the maximum, use the maximum.
*/
   nNewWidth := min( nNewWidth, nMaxWidth )

/*
Resize combobox.
Must be done before resizing dropdown list, because dropdown list's width is,
always, at least equal to combobox width.
*/
   If lResizeBox
     ::width := nNewWidth
   EndIf

/*
Resize dropdown list
*/
   ::SetDropDownWidth( nNewWidth )
   
RETURN nil

*-----------------------------------------------------------------------------*
METHOD GetDropDownWidth() CLASS TCombo
*-----------------------------------------------------------------------------*
Return ComboGetDroppedWidth( ::hWnd )

*-----------------------------------------------------------------------------*
METHOD SetDropDownWidth( nWidth ) CLASS TCombo
*-----------------------------------------------------------------------------*
Local nNew := ComboSetDroppedWidth( ::hWnd, nWidth )

   If nNew == -1
     nNew := ComboGetDroppedWidth( ::hWnd )
   EndIf

RETURN nNew

*-----------------------------------------------------------------------------*
METHOD AutoSize( lValue ) CLASS TCombo
*-----------------------------------------------------------------------------*
Local cCaption

   If HB_IsLogical( lValue )
      ::lAutoSize := lValue
      If lValue
         cCaption := GetWindowText( ::hWnd )
         ::SizePos(, , GetTextWidth( NIL, cCaption + "0", ::FontHandle ) + ::IconWidth + GetVScrollBarWidth(), GetTextHeight( NIL, cCaption, ::FontHandle ) )
      EndIf
   EndIf
RETURN ::lAutoSize

*-----------------------------------------------------------------------------*
METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TCombo
*-----------------------------------------------------------------------------*
Local WorkArea, BackRec, nMax, i, nStart

   If nMsg == WM_CHAR
      If ::lIncremental
         If wParam < 32
            ::cText := ""
         Else
            If Empty( ::cText )
               ::uIniTime := HB_MilliSeconds()
               ::cText := Upper( Chr( wParam ) )
               nStart := ComboGetCursel( ::hWnd )
            ElseIf HB_MilliSeconds() > ::uIniTime + ::SearchLapse
               ::uIniTime := HB_MilliSeconds()
               ::cText := Upper( Chr( wParam ) )
               nStart := ComboGetCursel( ::hWnd )
            Else
               ::uIniTime := HB_MilliSeconds()
               ::cText += Upper( Chr( wParam ) )
               nStart := ::nLastFound
            EndIf

            ::nLastFound := ComboBoxFindString( ComboBoxGetListhWnd( ::hWnd ), nStart - 1, ::cText )
            If ::nLastFound > 0 .AND. ::nLastFound >= nStart
               // item was found in the rest of the list, select
               ComboSetCurSel( ::hWnd, ::nLastFound )
            Else
               // if there are more items load, load them and search again
               If OSisWinXPorLater() .AND. ::lDelayLoad
                  If ! Select( WorkArea := ::WorkArea ) == 0
                     BackRec := ( WorkArea )->( Recno() )
                     ( WorkArea )->( DBGoto( ::nLastItem ) )
                     ( WorkArea )->( DBSkip() )
                     If ! ( WorkArea )->( Eof() )
                        // load remaining items
                        Do While ! ( WorkArea )->( Eof() )
                           ::AddItem( { ( WorkArea )-> &( ::Field ), _OOHG_Eval( ::ItemNumber ) } )
                           AADD( ::aValues, If( Empty( ::ValueSource ), ( WorkArea )->( RecNo() ), &( ::ValueSource ) ) )
                           If ValidHandler( ::ImageList )
                              ::AddBitMap( Eval( ::ImageSource ) )
                           EndIf
                           ::nLastItem := ( WorkArea )->( Recno() )
                           ( WorkArea )->( DBSkip() )
                        EndDo
                        // search again
                        ::nLastFound := ComboBoxFindString( ComboBoxGetListhWnd( ::hWnd ), nStart - 1, ::cText )
                     EndIf
                     ( WorkArea )->( DBGoTo( BackRec ) )
                  EndIf
               EndIf

               If ::nLastFound > 0
                  ComboSetCurSel( ::hWnd, ::nLastFound )
               Else
                  ::cText := ""
               EndIf
            EndIf

            Return 0
         EndIf
      Else
         If OSisWinXPorLater() .AND. ::lDelayLoad
            If ! Select( WorkArea := ::WorkArea ) == 0
               BackRec := ( WorkArea )->( Recno() )
               ( WorkArea )->( DBGoto( ::nLastItem ) )
               ( WorkArea )->( DBSkip() )
               If ! ( WorkArea )->( Eof() )
                  // load remaining items
                  Do While ! ( WorkArea )->( Eof() )
                     ::AddItem( { ( WorkArea )-> &( ::Field ), _OOHG_Eval( ::ItemNumber ) } )
                     AADD( ::aValues, If( Empty( ::ValueSource ), ( WorkArea )->( RecNo() ), &( ::ValueSource ) ) )
                     If ValidHandler( ::ImageList )
                        ::AddBitMap( Eval( ::ImageSource ) )
                     EndIf
                     ::nLastItem := ( WorkArea )->( Recno() )
                     ( WorkArea )->( DBSkip() )
                  EndDo
               EndIf
               ( WorkArea )->( DBGoTo( BackRec ) )
            EndIf
         EndIf
      EndIf

   ElseIf nMsg == WM_MOUSEWHEEL
      If OSisWinXPorLater() .AND. ::lDelayLoad
         If ! Select( WorkArea := ::WorkArea ) == 0
            If GET_WHEEL_DELTA_WPARAM( wParam ) < 0                // DOWN
               BackRec := ( WorkArea )->( Recno() )
               ( WorkArea )->( DBGoto( ::nLastItem ) )
               ( WorkArea )->( DBSkip() )
               i := 0
               Do While ! ( WorkArea )->( Eof() ) .and. i < 3
                  ::AddItem( { ( WorkArea )-> &( ::Field ), _OOHG_Eval( ::ItemNumber ) } )
                  AADD( ::aValues, If( Empty( ::ValueSource ), ( WorkArea )->( RecNo() ), &( ::ValueSource ) ) )
                  If ValidHandler( ::ImageList )
                     ::AddBitMap( Eval( ::ImageSource ) )
                  EndIf
                  ::nLastItem := ( WorkArea )->( Recno() )
                  ( WorkArea )->( DBSkip() )
                  i ++
               EndDo
               ( WorkArea )->( DBGoTo( BackRec ) )
            EndIf
         EndIf
      EndIf

   ElseIf nMsg == WM_KEYDOWN
      If OSisWinXPorLater() .AND. ::lDelayLoad
         If ! Select( WorkArea := ::WorkArea ) == 0
            Do Case
            Case wParam == 35 // END
               BackRec := ( WorkArea )->( Recno() )
               ( WorkArea )->( DBGoto( ::nLastItem ) )
               ( WorkArea )->( DBSkip() )
               Do While ! ( WorkArea )->( Eof() )
                  ::AddItem( { ( WorkArea )-> &( ::Field ), _OOHG_Eval( ::ItemNumber ) } )
                  AADD( ::aValues, If( Empty( ::ValueSource ), ( WorkArea )->( RecNo() ), &( ::ValueSource ) ) )
                  If ValidHandler( ::ImageList )
                     ::AddBitMap( Eval( ::ImageSource ) )
                  EndIf
                  ::nLastItem := ( WorkArea )->( Recno() )
                  ( WorkArea )->( DBSkip() )
               EndDo
               ( WorkArea )->( DBGoTo( BackRec ) )

            Case wParam == 34 // PGDN
               nMax := ::VisibleItems
               BackRec := ( WorkArea )->( Recno() )
               ( WorkArea )->( DBGoto( ::nLastItem ) )
               ( WorkArea )->( DBSkip() )
               i := 0
               Do While ! ( WorkArea )->( Eof() ) .and. i < nMax
                  ::AddItem( { ( WorkArea )-> &( ::Field ), _OOHG_Eval( ::ItemNumber ) } )
                  AADD( ::aValues, If( Empty( ::ValueSource ), ( WorkArea )->( RecNo() ), &( ::ValueSource ) ) )
                  If ValidHandler( ::ImageList )
                     ::AddBitMap( Eval( ::ImageSource ) )
                  EndIf
                  ::nLastItem := ( WorkArea )->( Recno() )
                  ( WorkArea )->( DBSkip() )
                  i ++
               EndDo
               ( WorkArea )->( DBGoTo( BackRec ) )

            Case wParam == 40 // DOWN
               BackRec := ( WorkArea )->( Recno() )
               ( WorkArea )->( DBGoto( ::nLastItem ) )
               ( WorkArea )->( DBSkip() )
               If ! ( WorkArea )->( Eof() )
                  ::AddItem( { ( WorkArea )-> &( ::Field ), _OOHG_Eval( ::ItemNumber ) } )
                  AADD( ::aValues, If( Empty( ::ValueSource ), ( WorkArea )->( RecNo() ), &( ::ValueSource ) ) )
                  If ValidHandler( ::ImageList )
                     ::AddBitMap( Eval( ::ImageSource ) )
                  EndIf
                  ::nLastItem := ( WorkArea )->( Recno() )
               EndIf
               ( WorkArea )->( DBGoTo( BackRec ) )

            EndCase
         EndIf
      Endif

   EndIf

Return ::Super:Events( hWnd, nMsg, wParam, lParam )

*-----------------------------------------------------------------------------*
METHOD Events_Command( wParam ) CLASS TCombo
*-----------------------------------------------------------------------------*
Local Hi_wParam := HIWORD( wParam )

   if Hi_wParam == CBN_SELCHANGE
      IF ::lAutosize
         ::Autosize(.T.)
      EndIf

      ::DoChange()
      Return nil

   elseif Hi_wParam == CBN_DROPDOWN
      ::DoEvent( ::OnListDisplay, "LISTDISPLAY" )
      Return nil

   elseif Hi_wParam == CBN_CLOSEUP
      ::DoEvent( ::OnListClose, "LISTCLOSE" )
      Return nil

   elseif Hi_wParam == CBN_KILLFOCUS
      Return ::DoLostFocus()

   elseif Hi_wParam == CBN_SETFOCUS
      ::DoEvent( ::OnGotFocus, "GOTFOCUS" )
      Return nil

   elseif Hi_wParam == EN_CHANGE
      // Avoids incorrect processing
      Return nil

   elseif Hi_wParam == CBN_EDITCHANGE
      ::DoEvent( ::OnClick, "CLICK" )
      Return nil

   elseif Hi_wParam == EN_KILLFOCUS .OR. ;
          Hi_wParam == BN_KILLFOCUS
      // Avoids incorrect processing
      Return nil

   EndIf

RETURN ::Super:Events_Command( wParam )

*-----------------------------------------------------------------------------*
METHOD SetEditSel( nStart, nEnd ) CLASS TCombo
*-----------------------------------------------------------------------------*
/*
   start:
      -1 the selection, if any, is removed.
       0 is first character.
   end:
       -1 all text from the start to the last character is selected.

   The first character after the last selected character is in the ending
   position. For example, to select the first four characters, use a
   starting position of 0 and an ending position of 4.
   
   This method is meaningfull only when de combo is in edit state.
   When combo looses focus, it gets out of edit state.
   When combo gots focus, all the text is selected.
*/
Local lRet

   IF HB_IsNumeric( nStart ) .and. nStart >= -1 .and. HB_IsNumeric( nEnd ) .and. nEnd >= -1
      lRet := SendMessage( ::hWnd, CB_SETEDITSEL, 0, MakeLParam( nStart, nEnd ) )
   ELSE
      lRet := .F.
   ENDIF

RETURN lRet

*-----------------------------------------------------------------------------*
METHOD GetEditSel() CLASS TCombo
*-----------------------------------------------------------------------------*
/*
   Returns an array with 2 items:
   1st. the starting position of the selection (zero-based value).
   2nd. the ending position of the selection (position of the first character
   after the last selected character). This value is the caret position.

   This method is meaningfull only when de combo is in edit state.
   When combo looses focus, it gets out of edit state.
   When combo gots focus, all the text is selected.
*/
Local rRange := SendMessage( ::hWnd, CB_GETEDITSEL, 0, 0 )

RETURN { LoWord( rRange ), HiWord( rRange ) }

*-----------------------------------------------------------------------------*
METHOD CaretPos( nPos ) CLASS TCombo
*-----------------------------------------------------------------------------*
/*
   Returns the ending position of the selection (position of the first character
   after the last selected character). This value is the caret position.

   This method is meaningfull only when de combo is in edit state.
   When combo looses focus, it gets out of edit state, and this method returns 0.
   When combo gots focus, all the text is selected.
*/
   IF HB_IsNumeric( nPos )
      SendMessage( ::hWnd, CB_SETEDITSEL, 0, MakeLParam( nPos, nPos ) )
   ENDIF
RETURN HiWord( SendMessage( ::hWnd, CB_GETEDITSEL, nil, nil ) )

*-----------------------------------------------------------------------------*
METHOD ItemBySource( nItem, uValue ) CLASS TCombo
*-----------------------------------------------------------------------------*
LOCAL cRet, nPos
   IF LEN( ::aValues ) == 0
      cRet := ComboItem( Self, nItem, uValue )
   ELSE
      IF VALTYPE( ::aValues[ 1 ] ) == VALTYPE( nItem ) .OR. ;
         ( VALTYPE( nItem ) $ "CM" .AND. VALTYPE( ::aValues[ 1 ] ) $ "CM" )
         nPos := ASCAN( ::aValues, nItem )
         IF nPos > 0
            cRet := ComboItem( Self, nPos, uValue )
         ELSE
            cRet := ""
         ENDIF
      ENDIF
   ENDIF
RETURN cRet

#pragma BEGINDUMP
#include <hbapi.h>
#include <hbvm.h>
#include <hbstack.h>
#include <windows.h>
#include <commctrl.h>
#include <windowsx.h>
#include "oohg.h"
#define s_Super s_TLabel

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

HB_FUNC( INITCOMBOBOX )
{
   HWND hwnd;
   HWND hbutton;
   int Style, StyleEx;

   hwnd = HWNDparam( 1 );

   StyleEx = _OOHG_RTL_Status( hb_parl( 8 ) );

   Style = hb_parni( 7 ) | WS_CHILD | WS_VSCROLL | CBS_HASSTRINGS  ;

   ///// | CBS_OWNERDRAWFIXED; // CBS_OWNERDRAWVARIABLE;  si se coloca ownerdrawfixed el alto del combo no cambia cuando se cambia el font

   hbutton = CreateWindowEx( StyleEx, "COMBOBOX",
                           "",
                           Style,
                           hb_parni(3),
                           hb_parni(4),
                           hb_parni(5),
                           hb_parni(6),
                           hwnd,
                           (HMENU)hb_parni(2),
                           GetModuleHandle(NULL),
                           NULL ) ;

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( ( HWND ) hbutton, GWL_WNDPROC, ( LONG ) SubClassFunc );

   HWNDret( hbutton );
}

HB_FUNC( COMBOADDSTRING )
{
   SendMessage( HWNDparam( 1 ), CB_ADDSTRING, 0, ( LPARAM ) hb_parc( 2 ) );
}

HB_FUNC( COMBOINSERTSTRING )
{
   SendMessage( HWNDparam( 1 ), CB_INSERTSTRING, ( WPARAM ) hb_parni( 3 ) - 1, ( LPARAM ) hb_parc( 2 ) );
}

HB_FUNC( COMBOSETCURSEL )
{
   SendMessage( HWNDparam( 1 ), CB_SETCURSEL, ( WPARAM ) hb_parni( 2 ) - 1, 0 );
}

HB_FUNC( COMBOGETCURSEL )
{
   hb_retni( SendMessage( HWNDparam( 1 ), CB_GETCURSEL, 0, 0 ) + 1 );
}

HB_FUNC( COMBOGETDROPPEDWIDTH )
{
   hb_retni( SendMessage( HWNDparam( 1 ), CB_GETDROPPEDWIDTH, 0, 0 ) );
}

HB_FUNC( COMBOSETDROPPEDWIDTH )
{
   hb_retni( SendMessage( HWNDparam( 1 ), CB_SETDROPPEDWIDTH, ( WPARAM ) hb_parni( 2 ), 0 ) );
}

HB_FUNC( COMBOBOXDELETESTRING )
{
   SendMessage( HWNDparam( 1 ), CB_DELETESTRING, (WPARAM) hb_parni( 2 ) - 1, 0 );
}

HB_FUNC( COMBOBOXRESET )
{
   SendMessage( HWNDparam( 1 ), CB_RESETCONTENT, 0, 0 );
}

HB_FUNC( COMBOGETSTRING )
{
   char cString [1024] = "" ;
   SendMessage( HWNDparam( 1 ), CB_GETLBTEXT, ( WPARAM ) hb_parni( 2 ) - 1, ( LPARAM ) cString );
   hb_retc( cString );
}

HB_FUNC( COMBOBOXGETITEMCOUNT )
{
   hb_retnl( SendMessage( HWNDparam( 1 ), CB_GETCOUNT, 0, 0 ) );
}

void TCombo_SetImageBuffer( POCTRL oSelf, struct IMAGE_PARAMETER pStruct, int nItem )
{
   BYTE *cBuffer;
   ULONG ulSize, ulSize2;
   int *pImage;

   if( oSelf->AuxBuffer || pStruct.iImage1 != -1 || pStruct.iImage2 != -1 )
   {
      if( nItem >= ( int ) oSelf->AuxBufferLen )
      {
         ulSize = sizeof( int ) * 2 * ( nItem + 100 );
         cBuffer = (BYTE *) hb_xgrab( ulSize );
         memset( cBuffer, -1, ulSize );
         if( oSelf->AuxBuffer )
         {
            memcpy( cBuffer, oSelf->AuxBuffer, ( sizeof( int ) * 2 * oSelf->AuxBufferLen ) );
            hb_xfree( oSelf->AuxBuffer );
         }
         oSelf->AuxBuffer = cBuffer;
         oSelf->AuxBufferLen = nItem + 100;
      }

      pImage = &( ( int * ) oSelf->AuxBuffer )[ nItem * 2 ];
      if( nItem < ComboBox_GetCount( oSelf->hWnd ) )
      {
         ulSize  = sizeof( int ) * 2 * ComboBox_GetCount( oSelf->hWnd );
         ulSize2 = sizeof( int ) * 2 * nItem;
         cBuffer = (BYTE *) hb_xgrab( ulSize );
         memcpy( cBuffer, pImage, ulSize - ulSize2 );
         memcpy( &pImage[ 2 ], cBuffer, ulSize - ulSize2 );
         hb_xfree( cBuffer );
      }
      pImage[ 0 ] = pStruct.iImage1;
      pImage[ 1 ] = pStruct.iImage2;
   }
}

HB_FUNC_STATIC( TCOMBO_EVENTS_DRAWITEM )   // METHOD Events_DrawItem( lParam )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   LPDRAWITEMSTRUCT lpdis = ( LPDRAWITEMSTRUCT ) hb_parnl( 1 );
   COLORREF FontColor, BackColor;
   TEXTMETRIC lptm;
   char cBuffer[ 2048 ];
   int x, y, cx, cy, iImage, dy;

   if( lpdis->itemID != (UINT) -1 )
   {
      // Checks if image defined for current item
      if( oSelf->ImageList && oSelf->AuxBuffer && ( lpdis->itemID + 1 ) <= oSelf->AuxBufferLen )
      {
         iImage = ( ( int * ) oSelf->AuxBuffer )[ ( lpdis->itemID * 2 ) + ( lpdis->itemState & ODS_SELECTED ? 1 : 0 ) ];
         if( iImage >= 0 && iImage < ImageList_GetImageCount( oSelf->ImageList ) )
         {
            ImageList_GetIconSize( oSelf->ImageList, &cx, &cy );
         }
         else
         {
            cx = 0;
            cy = 0;
            iImage = -1;
         }
      }
      else
      {
         cx = 0;
         cy = 0;
         iImage = -1;
      }

      // Text color
      if( lpdis->itemState & ODS_SELECTED )
      {
         FontColor = SetTextColor( lpdis->hDC, ( ( oSelf->lFontColorSelected == -1 ) ? GetSysColor( COLOR_HIGHLIGHTTEXT ) : (COLORREF) oSelf->lFontColorSelected ) );
         BackColor = SetBkColor(   lpdis->hDC, ( ( oSelf->lBackColorSelected == -1 ) ? GetSysColor( COLOR_HIGHLIGHT )     : (COLORREF) oSelf->lBackColorSelected ) );
      }
      else if( lpdis->itemState & ODS_DISABLED )
      {
         FontColor = SetTextColor( lpdis->hDC, GetSysColor( COLOR_GRAYTEXT ) );
         BackColor = SetBkColor(   lpdis->hDC, GetSysColor( COLOR_BTNFACE ) );
      }
      else
      {
         FontColor = SetTextColor( lpdis->hDC, ( ( oSelf->lFontColor == -1 ) ? GetSysColor( COLOR_WINDOWTEXT ) : (COLORREF) oSelf->lFontColor ) );
         BackColor = SetBkColor(   lpdis->hDC, ( ( oSelf->lBackColor == -1 ) ? GetSysColor( COLOR_WINDOW )     : (COLORREF) oSelf->lBackColor ) );
      }

      // Window position
      GetTextMetrics( lpdis->hDC, &lptm );
      y = ( lpdis->rcItem.bottom + lpdis->rcItem.top - lptm.tmHeight ) / 2;
      x = LOWORD( GetDialogBaseUnits() ) / 2;

      // Text
      SendMessage( lpdis->hwndItem, CB_GETLBTEXT, lpdis->itemID, ( LPARAM ) cBuffer );
      ExtTextOut( lpdis->hDC, cx + x * 2, y, ETO_CLIPPED | ETO_OPAQUE, &lpdis->rcItem, ( LPCSTR ) cBuffer, strlen( cBuffer ), NULL );

      SetTextColor( lpdis->hDC, FontColor );
      SetBkColor( lpdis->hDC, BackColor );

      // Draws image vertically centered
      if( iImage != -1 )
      {
         if( cy < lpdis->rcItem.bottom - lpdis->rcItem.top )                   // there is spare space
         {
            y = ( lpdis->rcItem.bottom + lpdis->rcItem.top - cy ) / 2;         // center image
            dy = cy;                                                           
         }
         else
         {
            y = lpdis->rcItem.top;                                             // place image at top

            _OOHG_Send( pSelf, s_lAdjustImages );
            hb_vmSend( 0 );

            if( hb_parl( -1 ) )
            {
               dy = ( lpdis->rcItem.bottom - lpdis->rcItem.top );              // clip exceeding pixels or stretch image
            }
            else
            {
               dy = cy;                                                        // use real size
            }
         }
         
         ImageList_DrawEx( oSelf->ImageList, iImage, lpdis->hDC, x, y, cx, dy, CLR_DEFAULT, CLR_NONE, ILD_TRANSPARENT );
      }

      // Focused rectangle
      if( lpdis->itemState & ODS_FOCUS )
      {
         DrawFocusRect( lpdis->hDC, &lpdis->rcItem );
      }
   }
}

HB_FUNC_STATIC( TCOMBO_EVENTS_MEASUREITEM )   // METHOD Events_MeasureItem( lParam )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   LPMEASUREITEMSTRUCT lpmis = ( LPMEASUREITEMSTRUCT ) hb_parnl( 1 );

   HWND hWnd = GetActiveWindow();
   HDC hDC = GetDC( hWnd );
   HFONT hFont, hOldFont;
   SIZE sz;
   int iSize;

   // Checks for a pre-defined text size
   _OOHG_Send( pSelf, s_nTextHeight );
   hb_vmSend( 0 );
   iSize = hb_parni( -1 );

   hFont = oSelf->hFontHandle;

   hOldFont = ( HFONT ) SelectObject( hDC, hFont );
   GetTextExtentPoint32( hDC, "_", 1, &sz );

   SelectObject( hDC, hOldFont );
   ReleaseDC( hWnd, hDC );

   if( iSize < sz.cy + 2 )
   {
      iSize = sz.cy + 2;
   }

   lpmis->itemHeight = iSize;

   hb_retnl( 1 );
}

HB_FUNC_STATIC( TCOMBO_ADDITEM )   // METHOD AddItem( uValue )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   struct IMAGE_PARAMETER pStruct;
   int nItem = ComboBox_GetCount( oSelf->hWnd );

   ImageFillParameter( &pStruct, hb_param( 1, HB_IT_ANY ) );
   TCombo_SetImageBuffer( oSelf, pStruct, nItem );
   SendMessage( oSelf->hWnd, CB_ADDSTRING, 0, ( LPARAM ) pStruct.cString );

   hb_retnl( ComboBox_GetCount( oSelf->hWnd ) );
}

HB_FUNC( COMBOITEM )   // Called from METHOD Item with ( Self, nItem, uValue )
{
   PHB_ITEM pSelf = (PHB_ITEM) hb_param( 1, HB_IT_ANY );
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   PHB_ITEM pValue = hb_param( 3, HB_IT_ANY );
   int nItem = hb_parni( 2 ) - 1;
   char *cBuffer;
   struct IMAGE_PARAMETER pStruct;
   int nItemSel, nItemNew;

   if( pValue && ( HB_IS_STRING( pValue ) || HB_IS_NUMERIC( pValue ) || HB_IS_ARRAY( pValue ) ) )
   {
      nItemSel = SendMessage( oSelf->hWnd, CB_GETCURSEL, 0, 0 );

      if( ( GetWindowLong( oSelf->hWnd, GWL_STYLE ) & CBS_SORT ) == CBS_SORT )
      {
         SendMessage( oSelf->hWnd, CB_DELETESTRING, ( WPARAM ) nItem, 0 );
         ImageFillParameter( &pStruct, pValue );
         TCombo_SetImageBuffer( oSelf, pStruct, nItem );
         nItemNew = SendMessage( oSelf->hWnd, CB_ADDSTRING, 0, ( LPARAM ) pStruct.cString );
      }
      else
      {
        SendMessage( oSelf->hWnd, CB_DELETESTRING, ( WPARAM ) nItem, 0 );
        ImageFillParameter( &pStruct, pValue );
        TCombo_SetImageBuffer( oSelf, pStruct, nItem );
        nItemNew = SendMessage( oSelf->hWnd, CB_INSERTSTRING, ( WPARAM ) nItem, ( LPARAM ) pStruct.cString );
      }

      if( nItem == nItemSel )
      {
        SendMessage( oSelf->hWnd, CB_SETCURSEL, ( WPARAM ) nItemNew, 0 );
      }
   }

   cBuffer = (char *) hb_xgrab( 2000 );
   SendMessage( oSelf->hWnd, CB_GETLBTEXT, ( WPARAM ) nItem, ( LPARAM ) cBuffer );
   hb_retc( cBuffer );
   hb_xfree( cBuffer );
}

HB_FUNC_STATIC( TCOMBO_INSERTITEM )   // METHOD InsertItem( nItem, uValue )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   PHB_ITEM pValue = hb_param( 2, HB_IT_ANY );
   int nItem = hb_parni( 1 ) - 1;
   struct IMAGE_PARAMETER pStruct;

   if( pValue && ( HB_IS_STRING( pValue ) || HB_IS_NUMERIC( pValue ) || HB_IS_ARRAY( pValue ) ) )
   {
      ImageFillParameter( &pStruct, pValue );
      TCombo_SetImageBuffer( oSelf, pStruct, nItem );
      if( ( GetWindowLong( oSelf->hWnd, GWL_STYLE ) & CBS_SORT ) == CBS_SORT )
      {
         SendMessage( oSelf->hWnd, CB_ADDSTRING, 0, ( LPARAM ) pStruct.cString );
      }
      else
      {
         SendMessage( oSelf->hWnd, CB_INSERTSTRING, ( WPARAM ) nItem, ( LPARAM ) pStruct.cString );
      }
   }

   hb_ret();
}

HB_FUNC( COMBOBOXFINDSTRING )
{
   hb_retni( SendMessage( HWNDparam( 1 ), LB_FINDSTRING, ( WPARAM ) hb_parni( 2 ), ( LPARAM ) hb_parc( 3 ) ) + 1 );
}

#ifndef CB_GETCOMBOBOXINFO
   #define CB_GETCOMBOBOXINFO 0x0164
#endif

HB_FUNC( COMBOBOXGETLISTHWND )
{
   COMBOBOXINFO info;

   info.cbSize = sizeof( COMBOBOXINFO );
   info.hwndList = 0;

   SendMessage( HWNDparam( 1 ), CB_GETCOMBOBOXINFO, 0, ( LPARAM ) &info );

   HWNDret( info.hwndList );
}

HB_FUNC_STATIC( TCOMBO_ITEMHEIGHT )   // METHOD ItemHeight()
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   HDC hDC;
   COMBOBOXINFO info;
   HFONT hFont, hOldFont;
   SIZE sz;
   int iSize;

   info.cbSize = sizeof( COMBOBOXINFO );
   info.hwndList = 0;
   SendMessage( oSelf->hWnd, CB_GETCOMBOBOXINFO, 0, ( LPARAM ) &info );
   hDC = GetDC( info.hwndList );

   _OOHG_Send( pSelf, s_nTextHeight );
   hb_vmSend( 0 );
   iSize = hb_parni( -1 );

   hFont = oSelf->hFontHandle;
   hOldFont = ( HFONT ) SelectObject( hDC, hFont );
   GetTextExtentPoint32( hDC, "_", 1, &sz );

   SelectObject( hDC, hOldFont );
   ReleaseDC( info.hwndList, hDC );

   if( iSize < sz.cy + 2 )
   {
      iSize = sz.cy + 2;
   }

   hb_retni( iSize );
}

#pragma ENDDUMP
