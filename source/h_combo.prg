/*
* $Id: h_combo.prg $
*/
/*
* ooHG source code:
* ComboBox control
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
#include "i_windefs.ch"

STATIC _OOHG_ComboRefresh := .T.

CLASS TCombo FROM TLabel

   DATA Type                  INIT "COMBO" READONLY
   DATA WorkArea              INIT ""
   DATA uField                INIT NIL
   DATA uValueSource          INIT NIL
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
   DATA oListBox              INIT NIL
   DATA oEditBox              INIT NIL
   DATA lRefresh              INIT NIL
   DATA SourceOrder           INIT NIL
   DATA OnRefresh             INIT NIL
   DATA lFocused              INIT .F.

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
   METHOD DeleteAllItems      BLOCK { |Self| ComboboxReset( ::hWnd ), ::xOldValue := NIL }
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
   METHOD Field               SETGET
   METHOD ValueSource         SETGET

   ENDCLASS

METHOD Define( ControlName, ParentForm, x, y, w, rows, value, fontname, ;
      fontsize, tooltip, changeprocedure, h, gotfocus, lostfocus, ;
      uEnter, HelpId, invisible, notabstop, sort, bold, italic, ;
      underline, strikeout, itemsource, valuesource, displaychange, ;
      ondisplaychangeprocedure, break, GripperText, aImage, lRtl, ;
      TextHeight, lDisabled, lFirstItem, lAdjustImages, backcolor, ;
      fontcolor, listwidth, onListDisplay, onListClose, ImageSource, ;
      ItemNumber, lDelayLoad, lIncremental, lWinSize, lRefresh, ;
      sourceorder, onrefresh, nLapse ) CLASS TCombo

   LOCAL ControlHandle, WorkArea, uField, nStyle

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
   ASSIGN ::lRefresh      VALUE lRefresh      TYPE "L" DEFAULT NIL
   ASSIGN ::SourceOrder   VALUE sourceorder   TYPE "CMNB"
   ASSIGN ::OnRefresh     VALUE onrefresh     TYPE "B"
   IF HB_IsNumeric( nLapse ) .and. nLapse >= 0
      ::SearchLapse := nLapse
   ENDIF

   ::SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor, .t., lRtl )
   ::SetFont(, , bold, italic, underline, strikeout )

   IF ::lDelayLoad .And. Sort
      MsgOOHGError( "SORT and DELAYLOAD clauses can't be used simultaneously. Program terminated." )
   ENDIF

   IF ValType( itemsource ) != 'U' .And. Sort == .T.
      MsgOOHGError( "SORT and ITEMSOURCE clauses can't be used simultaneously. Program terminated." )
   ENDIF

   IF ValType( valuesource ) != 'U' .And. Sort == .T.
      MsgOOHGError( "SORT and VALUESOURCE clauses can't be used simultaneously. Program terminated." )
   ENDIF

   IF ValType( itemsource ) == 'A'
      WorkArea := itemsource[ 1 ]
      uField := itemsource[ 2 ]
      IF Len( itemsource ) > 2
         ASSIGN ::SourceOrder VALUE itemsource[ 3 ] TYPE "CMNB"
      ENDIF
   ELSEIF ValType( itemsource ) != 'U'
      IF ! '->' $ itemsource
         MsgOOHGError( "ITEMSOURCE clause must be a fully qualified field name. Program terminated." )
      ELSE
         WorkArea := Left( itemsource, At( '->', itemsource ) - 1 )
         uField := Right( itemsource, Len( itemsource ) - At( '->', itemsource ) - 1 )
      ENDIF
   ENDIF

   nStyle := ::InitStyle(, , Invisible, notabstop, lDisabled ) + ;
      if( HB_IsLogical( SORT ) .AND. SORT, CBS_SORT, 0 ) + ;
      if( ! displaychange, CBS_DROPDOWNLIST, CBS_DROPDOWN ) + ;
      IF ( HB_IsArray( aImage ) .OR. HB_IsBlock( ItemNumber ), CBS_OWNERDRAWFIXED, 0) + ;
         if( OSisWinXPorLater() .AND. _OOHG_LastFrame() != "SPLITBOX" .AND. ! lWinSize, CBS_NOINTEGRALHEIGHT, 0 )

      ::SetSplitBoxInfo( Break, GripperText, ::nWidth )
      ControlHandle := InitComboBox( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::nWidth, ::nHeight, nStyle, ::lRtl )

      ::Register( ControlHandle, ControlName, HelpId, , ToolTip )
      ::SetFont()

      ::Field := uField
      ::WorkArea := WorkArea
      ::ValueSource := valuesource

      IF HB_IsArray( aImage )
         ::AddBitMap( aImage )
      ENDIF

      IF HB_IsNumeric( ListWidth )
         ::SetDropDownWidth( ListWidth )
      ENDIF

      IF VALTYPE( WorkArea ) $ "CM"
         ::Refresh()
      ELSE
         AEval( rows, { |x| ::AddItem( x ) } )
      ENDIF

      IF HB_IsLogical( lFirstItem ) .AND. lFirstItem .AND. ::ItemCount > 0
         ::SelectFirstItem()
      ENDIF

      ::Value := Value

      ASSIGN ::OnClick       VALUE ondisplaychangeprocedure TYPE "B"
      ASSIGN ::OnLostFocus   VALUE LostFocus                TYPE "B"
      ASSIGN ::OnGotFocus    VALUE GotFocus                 TYPE "B"
      ASSIGN ::OnChange      VALUE ChangeProcedure          TYPE "B"
      ASSIGN ::OnEnter       VALUE uEnter                   TYPE "B"
      ASSIGN ::onListDisplay VALUE onListDisplay            TYPE "B"
      ASSIGN ::onListClose   VALUE onListClose              TYPE "B"

      ::oListBox := TListCombo():Define( Self, ComboBoxGetListhWnd( ::hWnd ) )
      IF displaychange
         ::oEditBox := TEditCombo():Define( Self, GetWindow( ::hWnd, GW_CHILD ) )
      ENDIF

      RETURN Self

METHOD Field( uField ) CLASS TCombo

   IF HB_IsBlock( uField )
      ::uField := uField
   ELSEIF VALTYPE( uField ) $ "CM"
      ::uField := &( "{ || " + uField + " }" )
   ENDIF

   RETURN ::uField

METHOD ValueSource( uValue ) CLASS TCombo

   IF PCOUNT() > 0 .AND. HB_IsNil( uValue )
      ::aValues := {}
      ::uValueSource := NIL
   ELSEIF HB_IsArray( uValue )
      ::aValues := ACLONE( uValue )
      ::uValueSource := NIL
   ELSEIF HB_IsBlock( uValue )
      ::aValues := {}
      ::uValueSource := uValue
   ELSEIF VALTYPE( uValue ) $ "CM"
      ::aValues := {}
      IF EMPTY( uValue )
         ::uValueSource := NIL
      ELSE
         ::uValueSource := &( "{ || " + uValue + " }" )
      ENDIF
   ENDIF

   RETURN ::uValueSource

METHOD nHeight( nHeight ) CLASS TCombo

   IF HB_IsNumeric( nHeight ) .AND. ! ValidHandler( ::hWnd )
      ::nHeight2 := nHeight
   ENDIF

   RETURN ::nHeight2

METHOD VisibleItems() CLASS TCombo

   LOCAL nRet

   IF IsWindowStyle( ::hWnd, CBS_NOINTEGRALHEIGHT )
      nRet := ::nHeight / ::ItemHeight()
      IF nRet - int( nRet ) > 0
         nRet := int( nRet ) + 1
      ENDIF
   ELSE
      nRet := SendMessage( ::hWnd, CB_GETMINVISIBLE, 0, 0 ) * 2
   ENDIF

   RETURN nRet

METHOD Refresh() CLASS TCombo

   LOCAL BackRec, bField, aValues, uValue, bValueSource, lNoEval, BackOrd := NIL
   LOCAL lRefreshImages, aImages, nMax, nCount, nArea

   IF ( nArea := Select( ::WorkArea ) ) != 0
      IF HB_IsBlock( ::ImageSource )
         lRefreshImages := .T.
         aImages := {}
      ELSE
         lRefreshImages := .F.
      ENDIF

      uValue := ::Value
      bField := ::Field
      BackRec := ( nArea )->( RecNo() )
      IF HB_IsBlock( ::SourceOrder )
         BackOrd := ( nArea )->( OrdSetFocus( ( nArea )->( Eval( ::SourceOrder ) ) ) )
      ELSEIF ValType( ::SourceOrder ) $ "CMN"
         BackOrd := ( nArea )->( OrdSetFocus( ::SourceOrder ) )
      ENDIF

      IF OSisWinXPorLater() .AND. ::lDelayLoad
         nMax := ::VisibleItems * 2
      ELSE
         nMax := ( nArea )->( LastRec() )
      ENDIF

      ( nArea )->( DBGoTop() )
      IF ( nArea )->( Eof() )
         ::nLastItem := 0
      ENDIF

      nCount := 0

      ComboboxReset( ::hWnd )
      aValues := {}
      bValueSource := ::ValueSource
      lNoEval := EMPTY( bValueSource )

      DO WHILE ! ( nArea )->( Eof() ) .and. nCount < nMax
         ::AddItem( { ( nArea )->( EVAL( bField ) ), _OOHG_Eval( ::ItemNumber ) } )
         AADD( aValues, If( lNoEval, ( nArea )->( RecNo() ), EVAL( bValueSource ) ) )
         IF lRefreshImages
            AADD( aImages, EVAL( ::ImageSource ) )
         ENDIF

         ::nLastItem := ( nArea )->( Recno() )
         ( nArea )->( DBSkip() )
         nCount ++
      ENDDO

      IF BackOrd != NIL
         ( nArea )->( OrdSetFocus( BackOrd ) )
      ENDIF
      ( nArea )->( DBGoTo( BackRec ) )

      IF lRefreshImages
         IF ValidHandler( ::ImageList )
            ImageList_Destroy( ::ImageList )
         ENDIF
         ::ImageList := 0

         ::AddBitMap( aImages )
      ENDIF

      ::aValues := aValues
      ::Value := uValue

      ::DoEvent( ::OnRefresh, "REFRESH" )
   ENDIF

   RETURN NIL

METHOD DisplayValue( cValue ) CLASS TCombo

   RETURN ( ::Caption := cValue )

METHOD Value( uValue ) CLASS TCombo

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

METHOD Visible( lVisible ) CLASS TCombo

   IF HB_IsLogical( lVisible )
      ::Super:Visible := lVisible
      IF ! lVisible
         SendMessage( ::hWnd, CB_SHOWDROPDOWN, 0, 0 )
      ENDIF
   ENDIF

   RETURN ::lVisible

METHOD RefreshData() CLASS TCombo

   LOCAL lRefresh

   IF HB_IsLogical( ::lRefresh )
      lRefresh := ::lRefresh
   ELSE
      lRefresh := _OOHG_ComboRefresh
   ENDIF
   IF lRefresh
      ::Refresh()
   ENDIF

   RETURN ::Super:RefreshData()

METHOD PreRelease() CLASS TCombo

   IF ! SendMessage( ::hWnd, CB_GETDROPPEDSTATE, 0, 0 ) == 0
      SendMessage( ::hWnd, CB_SHOWDROPDOWN, 0, 0 )
   ENDIF

   RETURN ::Super:PreRelease()

METHOD ShowDropDown( lShow ) CLASS TCombo

   ASSIGN lShow VALUE lShow TYPE "L" DEFAULT .T.
   IF lShow
      SendMessage( ::hWnd, CB_SHOWDROPDOWN, 1, 0 )
   ELSE
      SendMessage( ::hWnd, CB_SHOWDROPDOWN, 0, 0 )
   ENDIF

   RETURN NIL

METHOD AutoSizeDropDown( lResizeBox, nMinWidth, nMaxWidth ) CLASS TCombo

   LOCAL nCounter, nNewWidth, nScrollWidth := GetVScrollBarWidth()

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

   FOR nCounter := 1 to ::ItemCount
      nNewWidth := max( GetTextWidth( NIL, ::Item(nCounter) + "0", ::FontHandle ) + ::IconWidth + nScrollWidth, nNewWidth )
   NEXT

   /*
   nMinWidth = minimum width of dropdown list.
   If ommited or is less than 0, defaults to 0 if lResizeBox == .T. or to combobox width otherwise.
   */
   IF ! HB_IsNumeric( nMinWidth ) .or. nMinWidth < 0
      nMinWidth := if( lResizeBox, 0, ::Width )
   ENDIF

   /*
   If the computed value is less than the minimum, use the minimum.
   */
   nNewWidth := max( nNewWidth, nMinWidth )

   /*
   nMaxWidth = maximum width of dropdown list, if ommited defaults to longest item's width
   If no maximum specified or is less than minimun, use computed value as maximum.
   */
   IF ! HB_IsNumeric( nMaxWidth ) .or. nMaxWidth < nMinWidth
      nMaxWidth := nNewWidth
   ENDIF

   /*
   If the computed value is greater than the maximum, use the maximum.
   */
   nNewWidth := min( nNewWidth, nMaxWidth )

   /*
   Resize combobox.
   Must be done before resizing dropdown list, because dropdown list's width is,
   always, at least equal to combobox width.
   */
   IF lResizeBox
      ::width := nNewWidth
   ENDIF

   /*
   Resize dropdown list
   */
   ::SetDropDownWidth( nNewWidth )

   RETURN NIL

METHOD GetDropDownWidth() CLASS TCombo

   RETURN ComboGetDroppedWidth( ::hWnd )

METHOD SetDropDownWidth( nWidth ) CLASS TCombo

   LOCAL nNew := ComboSetDroppedWidth( ::hWnd, nWidth )

   IF nNew == -1
      nNew := ComboGetDroppedWidth( ::hWnd )
   ENDIF

   RETURN nNew

METHOD AutoSize( lValue ) CLASS TCombo

   LOCAL cCaption

   IF HB_IsLogical( lValue )
      ::lAutoSize := lValue
      IF lValue
         cCaption := GetWindowText( ::hWnd )
         ::SizePos(, , GetTextWidth( NIL, cCaption + "0", ::FontHandle ) + ::IconWidth + GetVScrollBarWidth(), GetTextHeight( NIL, cCaption, ::FontHandle ) )
      ENDIF
   ENDIF

   RETURN ::lAutoSize

METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TCombo

   LOCAL nArea, BackRec, nMax, i, nStart, bField, bValueSource, lNoEval, BackOrd := NIL

   IF nMsg == WM_CHAR
      IF ::lIncremental
         IF wParam < 32
            ::cText := ""
         ELSE
            IF Empty( ::cText )
               ::uIniTime := HB_MilliSeconds()
               ::cText := Upper( Chr( wParam ) )
               nStart := ComboGetCursel( ::hWnd )
            ELSEIF ::SearchLapse > 0 .AND. HB_MilliSeconds() > ::uIniTime + ::SearchLapse
               ::uIniTime := HB_MilliSeconds()
               ::cText := Upper( Chr( wParam ) )
               nStart := ComboGetCursel( ::hWnd )
            ELSE
               ::uIniTime := HB_MilliSeconds()
               ::cText += Upper( Chr( wParam ) )
               nStart := ::nLastFound
            ENDIF

            ::nLastFound := ComboBoxFindString( ::oListBox:hWnd, nStart - 1, ::cText )
            IF ::nLastFound > 0 .AND. ::nLastFound >= nStart
               // item was found in the rest of the list, select
               ::Value := ::nLastFound
            ELSE
               // if there are more items not already loaded, load them and search again
               IF OSisWinXPorLater() .AND. ::lDelayLoad
                  IF ( nArea := Select( ::WorkArea ) ) != 0
                     nMax := ::VisibleItems
                     bField := ::Field
                     bValueSource := ::ValueSource
                     lNoEval := EMPTY( bValueSource )

                     BackRec := ( nArea )->( Recno() )
                     IF HB_IsBlock( ::SourceOrder )
                        BackOrd := ( nArea )->( OrdSetFocus( ( nArea )->( Eval( ::SourceOrder ) ) ) )
                     ELSEIF ValType( ::SourceOrder ) $ "CMN"
                        BackOrd := ( nArea )->( OrdSetFocus( ::SourceOrder ) )
                     ENDIF

                     ( nArea )->( DBGoto( ::nLastItem ) )
                     ( nArea )->( DBSkip() )
                     DO WHILE ! ( nArea )->( Eof() )
                        // load more items
                        i := 0
                        DO WHILE ! ( nArea )->( Eof() ) .AND. i < nMax
                           ::AddItem( { ( nArea )->( EVAL( bField ) ), _OOHG_Eval( ::ItemNumber ) } )
                           AADD( ::aValues, If( lNoEval, ( nArea )->( RecNo() ), EVAL( bValueSource ) ) )
                           IF ValidHandler( ::ImageList )
                              ::AddBitMap( Eval( ::ImageSource ) )
                           ENDIF

                           ::nLastItem := ( nArea )->( Recno() )
                           ( nArea )->( DBSkip() )
                           i ++
                        ENDDO
                        // search again
                        ::nLastFound := ComboBoxFindString( ::oListBox:hWnd, - 1, ::cText )
                        IF ::nLastFound > 0
                           EXIT
                        ENDIF
                     ENDDO

                     IF BackOrd != NIL
                        ( nArea )->( OrdSetFocus( BackOrd ) )
                     ENDIF
                     ( nArea )->( DBGoTo( BackRec ) )
                  ENDIF
               ENDIF

               IF ::nLastFound > 0
                  ::Value := ::nLastFound
               ELSE
                  ::cText := ""
               ENDIF
            ENDIF

            RETURN 0
         ENDIF
      ELSE
         ::cText := ""
         IF OSisWinXPorLater() .AND. ::lDelayLoad
            IF ( nArea := Select( ::WorkArea ) ) != 0
               // load all remaining items so OS can search
               bField := ::Field
               bValueSource := ::ValueSource
               lNoEval := EMPTY( bValueSource )

               BackRec := ( nArea )->( Recno() )
               IF HB_IsBlock( ::SourceOrder )
                  BackOrd := ( nArea )->( OrdSetFocus( ( nArea )->( Eval( ::SourceOrder ) ) ) )
               ELSEIF ValType( ::SourceOrder ) $ "CMN"
                  BackOrd := ( nArea )->( OrdSetFocus( ::SourceOrder ) )
               ENDIF

               ( nArea )->( DBGoto( ::nLastItem ) )
               ( nArea )->( DBSkip() )
               DO WHILE ! ( nArea )->( Eof() )
                  ::AddItem( { ( nArea )->( EVAL( bField ) ), _OOHG_Eval( ::ItemNumber ) } )
                  AADD( ::aValues, If( lNoEval, ( nArea )->( RecNo() ), EVAL( bValueSource ) ) )
                  IF ValidHandler( ::ImageList )
                     ::AddBitMap( Eval( ::ImageSource ) )
                  ENDIF

                  ::nLastItem := ( nArea )->( Recno() )
                  ( nArea )->( DBSkip() )
               ENDDO

               IF BackOrd != NIL
                  ( nArea )->( OrdSetFocus( BackOrd ) )
               ENDIF
               ( nArea )->( DBGoTo( BackRec ) )
            ENDIF
         ENDIF
      ENDIF

   ELSEIF nMsg == WM_MOUSEWHEEL
      ::cText := ""
      IF OSisWinXPorLater() .AND. ::lDelayLoad
         IF ( nArea := Select( ::WorkArea ) ) != 0
            IF GET_WHEEL_DELTA_WPARAM( wParam ) < 0                // DOWN
               bField := ::Field
               bValueSource := ::ValueSource
               lNoEval := EMPTY( bValueSource )

               BackRec := ( nArea )->( Recno() )
               IF HB_IsBlock( ::SourceOrder )
                  BackOrd := ( nArea )->( OrdSetFocus( ( nArea )->( Eval( ::SourceOrder ) ) ) )
               ELSEIF ValType( ::SourceOrder ) $ "CMN"
                  BackOrd := ( nArea )->( OrdSetFocus( ::SourceOrder ) )
               ENDIF

               ( nArea )->( DBGoto( ::nLastItem ) )
               ( nArea )->( DBSkip() )
               i := 0
               DO WHILE ! ( nArea )->( Eof() ) .and. i < 3
                  ::AddItem( { ( nArea )->( EVAL( bField ) ), _OOHG_Eval( ::ItemNumber ) } )
                  AADD( ::aValues, If( lNoEval, ( nArea )->( RecNo() ), EVAL( bValueSource ) ) )
                  IF ValidHandler( ::ImageList )
                     ::AddBitMap( Eval( ::ImageSource ) )
                  ENDIF

                  ::nLastItem := ( nArea )->( Recno() )
                  ( nArea )->( DBSkip() )
                  i ++
               ENDDO

               IF BackOrd != NIL
                  ( nArea )->( OrdSetFocus( BackOrd ) )
               ENDIF
               ( nArea )->( DBGoTo( BackRec ) )
            ENDIF
         ENDIF
      ENDIF

   ELSEIF nMsg == WM_KEYDOWN
      IF OSisWinXPorLater() .AND. ::lDelayLoad
         IF ( nArea := Select( ::WorkArea ) ) != 0
            DO CASE
            CASE wParam == VK_END
               ::cText := ""

               // load all remaining items
               bField := ::Field
               bValueSource := ::ValueSource
               lNoEval := EMPTY( bValueSource )

               BackRec := ( nArea )->( Recno() )
               IF HB_IsBlock( ::SourceOrder )
                  BackOrd := ( nArea )->( OrdSetFocus( ( nArea )->( Eval( ::SourceOrder ) ) ) )
               ELSEIF ValType( ::SourceOrder ) $ "CMN"
                  BackOrd := ( nArea )->( OrdSetFocus( ::SourceOrder ) )
               ENDIF

               ( nArea )->( DBGoto( ::nLastItem ) )
               ( nArea )->( DBSkip() )
               DO WHILE ! ( nArea )->( Eof() )
                  ::AddItem( { ( nArea )->( EVAL( bField ) ), _OOHG_Eval( ::ItemNumber ) } )
                  AADD( ::aValues, If( lNoEval, ( nArea )->( RecNo() ), EVAL( bValueSource ) ) )
                  IF ValidHandler( ::ImageList )
                     ::AddBitMap( Eval( ::ImageSource ) )
                  ENDIF

                  ::nLastItem := ( nArea )->( Recno() )
                  ( nArea )->( DBSkip() )
               ENDDO

               IF BackOrd != NIL
                  ( nArea )->( OrdSetFocus( BackOrd ) )
               ENDIF
               ( nArea )->( DBGoTo( BackRec ) )

            CASE wParam == VK_NEXT
               ::cText := ""

               // load one more page of items
               nMax := ::VisibleItems
               bField := ::Field
               bValueSource := ::ValueSource
               lNoEval := EMPTY( bValueSource )

               BackRec := ( nArea )->( Recno() )
               IF HB_IsBlock( ::SourceOrder )
                  BackOrd := ( nArea )->( OrdSetFocus( ( nArea )->( Eval( ::SourceOrder ) ) ) )
               ELSEIF ValType( ::SourceOrder ) $ "CMN"
                  BackOrd := ( nArea )->( OrdSetFocus( ::SourceOrder ) )
               ENDIF

               ( nArea )->( DBGoto( ::nLastItem ) )
               ( nArea )->( DBSkip() )
               i := 0
               DO WHILE ! ( nArea )->( Eof() ) .and. i < nMax
                  ::AddItem( { ( nArea )->( EVAL( bField ) ), _OOHG_Eval( ::ItemNumber ) } )
                  AADD( ::aValues, If( lNoEval, ( nArea )->( RecNo() ), EVAL( bValueSource ) ) )
                  IF ValidHandler( ::ImageList )
                     ::AddBitMap( Eval( ::ImageSource ) )
                  ENDIF

                  ::nLastItem := ( nArea )->( Recno() )
                  ( nArea )->( DBSkip() )
                  i ++
               ENDDO

               IF BackOrd != NIL
                  ( nArea )->( OrdSetFocus( BackOrd ) )
               ENDIF
               ( nArea )->( DBGoTo( BackRec ) )

            CASE wParam == VK_DOWN
               ::cText := ""

               // load one more item
               bField := ::Field
               bValueSource := ::ValueSource
               lNoEval := EMPTY( bValueSource )

               BackRec := ( nArea )->( Recno() )
               IF HB_IsBlock( ::SourceOrder )
                  BackOrd := ( nArea )->( OrdSetFocus( ( nArea )->( Eval( ::SourceOrder ) ) ) )
               ELSEIF ValType( ::SourceOrder ) $ "CMN"
                  BackOrd := ( nArea )->( OrdSetFocus( ::SourceOrder ) )
               ENDIF

               ( nArea )->( DBGoto( ::nLastItem ) )
               ( nArea )->( DBSkip() )
               IF ! ( nArea )->( Eof() )
                  ::AddItem( { ( nArea )->( EVAL( bField ) ), _OOHG_Eval( ::ItemNumber ) } )
                  AADD( ::aValues, If( lNoEval, ( nArea )->( RecNo() ), EVAL( bValueSource ) ) )
                  IF ValidHandler( ::ImageList )
                     ::AddBitMap( Eval( ::ImageSource ) )
                  ENDIF

                  ::nLastItem := ( nArea )->( Recno() )
               ENDIF

               IF BackOrd != NIL
                  ( nArea )->( OrdSetFocus( BackOrd ) )
               ENDIF
               ( nArea )->( DBGoTo( BackRec ) )

            CASE wParam == VK_UP .OR. wParam == VK_HOME .OR. wParam == VK_PRIOR
               ::cText := ""

            ENDCASE
         ENDIF
      ENDIF

   ELSEIF nMsg == WM_LBUTTONDOWN
      IF ! ::lFocused
         ::SetFocus()
      ENDIF

   ENDIF

   RETURN ::Super:Events( hWnd, nMsg, wParam, lParam )

METHOD Events_Command( wParam ) CLASS TCombo

   LOCAL Hi_wParam := HIWORD( wParam ), nArea, BackRec, i, nMax, bField, bValueSource, lNoEval, BackOrd := NIL

   IF Hi_wParam == CBN_SELCHANGE
      IF ::lAutosize
         ::Autosize(.T.)
      ENDIF

      ::DoChange()

      RETURN NIL

   ELSEIF Hi_wParam == CBN_DROPDOWN
      ::cText := ""
      ::DoEvent( ::OnListDisplay, "LISTDISPLAY" )

      RETURN NIL

   ELSEIF Hi_wParam == CBN_CLOSEUP
      ::cText := ""
      ::DoEvent( ::OnListClose, "LISTCLOSE" )

      RETURN NIL

   ELSEIF Hi_wParam == CBN_KILLFOCUS
      ::cText := ""
      ::lFocused := .F.

      RETURN ::DoLostFocus()

   ELSEIF Hi_wParam == CBN_SETFOCUS .OR. ;
         Hi_wParam == BN_SETFOCUS
      IF ! ::lFocused
         ::cText := ""
         ::lFocused := .T.
         GetFormObjectByHandle( ::ContainerhWnd ):LastFocusedControl := ::hWnd
         ::FocusEffect()
         ::DoEvent( ::OnGotFocus, "GOTFOCUS" )
      ENDIF

      RETURN NIL

   ELSEIF Hi_wParam == EN_CHANGE
      // Avoids incorrect processing

      RETURN NIL

   ELSEIF Hi_wParam == CBN_EDITCHANGE
      IF ::lIncremental
         ::cText := Upper( ::DisplayValue )
         IF ::oEditBox:LastKey == VK_BACK
            nMax := Len( ::cText )
            IF nMax > 0
               ::cText := SubStr( ::cText, 1, nMax - 1 )
            ENDIF
         ENDIF
         ::nLastFound := ComboBoxFindString( ::oListBox:hWnd, -1, ::cText )
         IF ::nLastFound > 0
            ComboSetCurSel( ::hWnd, ::nLastFound )
            ::SetEditSel( LEN( ::cText ), LEN( ::DisplayValue ) )
            ::DoChange()

            RETURN NIL
         ENDIF
         // if there are more items not already loaded, load them and search again
         IF OSisWinXPorLater() .AND. ::lDelayLoad
            IF ( nArea := Select( ::WorkArea ) ) != 0
               nMax := ::VisibleItems
               bField := ::Field
               bValueSource := ::ValueSource
               lNoEval := EMPTY( bValueSource )

               BackRec := ( nArea )->( Recno() )
               IF HB_IsBlock( ::SourceOrder )
                  BackOrd := ( nArea )->( OrdSetFocus( ( nArea )->( Eval( ::SourceOrder ) ) ) )
               ELSEIF ValType( ::SourceOrder ) $ "CMN"
                  BackOrd := ( nArea )->( OrdSetFocus( ::SourceOrder ) )
               ENDIF

               ( nArea )->( DBGoto( ::nLastItem ) )
               ( nArea )->( DBSkip() )
               DO WHILE ! ( nArea )->( Eof() )
                  // load more items
                  i := 0
                  DO WHILE ! ( nArea )->( Eof() ) .AND. i < nMax
                     ::AddItem( { ( nArea )->( EVAL( bField ) ), _OOHG_Eval( ::ItemNumber ) } )
                     AADD( ::aValues, If( lNoEval, ( nArea )->( RecNo() ), EVAL( bValueSource ) ) )
                     IF ValidHandler( ::ImageList )
                        ::AddBitMap( Eval( ::ImageSource ) )
                     ENDIF

                     ::nLastItem := ( nArea )->( Recno() )
                     ( nArea )->( DBSkip() )
                     i ++
                  ENDDO

                  // search again
                  ::nLastFound := ComboBoxFindString( ::oListBox:hWnd, - 1, ::cText )
                  IF ::nLastFound > 0
                     EXIT
                  ENDIF
               ENDDO

               IF BackOrd != NIL
                  ( nArea )->( OrdSetFocus( BackOrd ) )
               ENDIF
               ( nArea )->( DBGoTo( BackRec ) )

               IF ::nLastFound > 0
                  ComboSetCurSel( ::hWnd, ::nLastFound )
                  ::SetEditSel( LEN( ::cText ), LEN( ::DisplayValue ) )
                  ::DoChange()

                  RETURN NIL
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      ::DoEvent( ::OnClick, "DISPLAYCHANGE" )

      RETURN NIL

   ELSEIF Hi_wParam == EN_KILLFOCUS .OR. ;
         Hi_wParam == BN_KILLFOCUS
      // Avoids incorrect processing

      RETURN NIL

   ENDIF

   RETURN ::Super:Events_Command( wParam )

METHOD SetEditSel( nStart, nEnd ) CLASS TCombo

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
   When the combo loses the focus, it gets out of edit state.
   When the combo gets the focus, all the text is selected.
   */

   LOCAL lRet

   IF HB_IsNumeric( nStart ) .and. nStart >= -1 .and. HB_IsNumeric( nEnd ) .and. nEnd >= -1
      lRet := SendMessage( ::hWnd, CB_SETEDITSEL, 0, MakeLParam( nStart, nEnd ) )
   ELSE
      lRet := .F.
   ENDIF

   RETURN lRet

METHOD GetEditSel() CLASS TCombo

   /*

   Returns an array with 2 items:
   1st. the starting position of the selection (zero-based value).
   2nd. the ending position of the selection (position of the first character
   after the last selected character). This value is the caret position.

   This method is meaningfull only when de combo is in edit state.
   When the combo loses the focus, it gets out of edit state.
   When the combo gets the focus, all the text is selected.
   */

   LOCAL rRange := SendMessage( ::hWnd, CB_GETEDITSEL, 0, 0 )

   RETURN { LoWord( rRange ), HiWord( rRange ) }

METHOD CaretPos( nPos ) CLASS TCombo

   /*

   Returns the ending position of the selection (position of the first character
   after the last selected character). This value is the caret position.

   This method is meaningfull only when de combo is in edit state.
   When the combo loses the focus, it gets out of edit state, and this method returns 0.
   When the combo gets the focus, all the text is selected.
   */

   IF HB_IsNumeric( nPos )
      SendMessage( ::hWnd, CB_SETEDITSEL, 0, MakeLParam( nPos, nPos ) )
   ENDIF

   RETURN HiWord( SendMessage( ::hWnd, CB_GETEDITSEL, NIL, NIL ) )

METHOD ItemBySource( nItem, uValue ) CLASS TCombo

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

METHOD AddItem( uValue, uSource ) CLASS TCombo

   IF PCOUNT() > 1 .AND. LEN( ::aValues ) > 0
      AADD( ::aValues, uSource )
   ENDIF

   RETURN TCombo_Add_Item( Self, uValue )

METHOD InsertItem( nItem, uValue, uSource ) CLASS TCombo

   IF PCOUNT() > 2 .AND. LEN( ::aValues ) > 0
      AADD( ::aValues, NIL )
      AINS( ::aValues, nItem )
      ::aValues[ nItem ] := uSource
   ENDIF

   RETURN TCombo_Insert_Item( Self, nItem, uValue )

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
   HWND hcombo;
   int Style, StyleEx;

   hwnd = HWNDparam( 1 );

   StyleEx = _OOHG_RTL_Status( hb_parl( 8 ) );

   Style = hb_parni( 7 ) | WS_CHILD | WS_VSCROLL | CBS_HASSTRINGS  ;

   ///// | CBS_OWNERDRAWFIXED; // CBS_OWNERDRAWVARIABLE;  si se coloca ownerdrawfixed el alto del combo no cambia cuando se cambia el font

   hcombo = CreateWindowEx( StyleEx, "COMBOBOX",
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

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( ( HWND ) hcombo, GWL_WNDPROC, ( LONG ) SubClassFunc );

   HWNDret( hcombo );
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

HB_FUNC( TCOMBO_ADD_ITEM )   // Called from METHOD AddItem with ( Self, uValue )
{
   PHB_ITEM pSelf = (PHB_ITEM) hb_param( 1, HB_IT_ANY );
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   struct IMAGE_PARAMETER pStruct;
   int nItem = ComboBox_GetCount( oSelf->hWnd );

   ImageFillParameter( &pStruct, hb_param( 2, HB_IT_ANY ) );
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

HB_FUNC( TCOMBO_INSERT_ITEM )   // Called from METHOD InsertItem( Self, nItem, uValue )
{
   PHB_ITEM pSelf = (PHB_ITEM) hb_param( 1, HB_IT_ANY );
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   PHB_ITEM pValue = hb_param( 3, HB_IT_ANY );
   int nItem = hb_parni( 2 ) - 1;
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

CLASS TListCombo FROM TControl STATIC

   METHOD Define
   METHOD Events_VScroll

   ENDCLASS

METHOD Define( Container, hWnd ) CLASS TListCombo

   ::SetForm( , Container )
   InitListCombo( hWnd )
   ::Register( hWnd )

   RETURN Self

METHOD Events_VScroll( wParam ) CLASS TListCombo

   LOCAL Lo_wParam := LoWord( wParam ), nArea, bField, bValueSource, lNoEval, BackRec, nLoad, i, BackOrd := NIL

   IF Lo_wParam == SB_LINEDOWN
      IF ( nArea := Select( ::Container:WorkArea ) ) != 0
         // load one more item
         bField := ::Container:Field
         bValueSource := ::Container:ValueSource
         lNoEval := EMPTY( bValueSource )

         BackRec := ( nArea )->( Recno() )
         IF ValType( ::Container:SourceOrder ) == "B"
            BackOrd := ( nArea )->( OrdSetFocus( ( nArea )->( Eval( ::Container:SourceOrder ) ) ) )
         ELSEIF ValType( ::Container:SourceOrder ) $ "CMN"
            BackOrd := ( nArea )->( OrdSetFocus( ::Container:SourceOrder ) )
         ENDIF

         ( nArea )->( DBGoto( ::Container:nLastItem ) )
         ( nArea )->( DBSkip() )
         IF ! ( nArea )->( Eof() )
            ::Container:AddItem( { ( nArea )->( EVAL( bField ) ), _OOHG_Eval( ::Container:ItemNumber ) } )
            AADD( ::Container:aValues, If( lNoEval, ( nArea )->( RecNo() ), EVAL( bValueSource ) ) )
            IF ValidHandler( ::Container:ImageList )
               ::Container:AddBitMap( Eval( ::Container:ImageSource ) )
            ENDIF

            ::Container:nLastItem := ( nArea )->( Recno() )
         ENDIF

         IF BackOrd != NIL
            ( nArea )->( OrdSetFocus( BackOrd ) )
         ENDIF
         ( nArea )->( DBGoTo( BackRec ) )
      ENDIF

   ELSEIF Lo_wParam == SB_PAGEDOWN .OR. Lo_wParam == SB_THUMBPOSITION
      IF ( nArea := Select( ::Container:WorkArea ) ) != 0
         // load one more page of items
         nLoad := ::Container:VisibleItems
         bField := ::Container:Field
         bValueSource := ::Container:ValueSource
         lNoEval := EMPTY( bValueSource )

         BackRec := ( nArea )->( Recno() )
         IF ValType( ::Container:SourceOrder ) == "B"
            BackOrd := ( nArea )->( OrdSetFocus( ( nArea )->( Eval( ::Container:SourceOrder ) ) ) )
         ELSEIF ValType( ::Container:SourceOrder ) $ "CMN"
            BackOrd := ( nArea )->( OrdSetFocus( ::Container:SourceOrder ) )
         ENDIF

         ( nArea )->( DBGoto( ::Container:nLastItem ) )
         ( nArea )->( DBSkip() )
         i := 0
         DO WHILE ! ( nArea )->( Eof() ) .and. i < nLoad
            ::Container:AddItem( { ( nArea )->( EVAL( bField ) ), _OOHG_Eval( ::Container:ItemNumber ) } )
            AADD( ::Container:aValues, If( lNoEval, ( nArea )->( RecNo() ), EVAL( bValueSource ) ) )
            IF ValidHandler( ::Container:ImageList )
               ::Container:AddBitMap( Eval( ::Container:ImageSource ) )
            ENDIF

            ::Container:nLastItem := ( nArea )->( Recno() )
            ( nArea )->( DBSkip() )
            i ++
         ENDDO

         IF BackOrd != NIL
            ( nArea )->( OrdSetFocus( BackOrd ) )
         ENDIF
         ( nArea )->( DBGoTo( BackRec ) )
      ENDIF

   ELSEIF Lo_wParam == SB_BOTTOM
      IF ( nArea := Select( ::Container:WorkArea ) ) != 0
         // load all remaining items
         bField := ::Container:Field
         bValueSource := ::Container:ValueSource
         lNoEval := EMPTY( bValueSource )

         BackRec := ( nArea )->( Recno() )
         IF ValType( ::Container:SourceOrder ) == "B"
            BackOrd := ( nArea )->( OrdSetFocus( ( nArea )->( Eval( ::Container:SourceOrder ) ) ) )
         ELSEIF ValType( ::Container:SourceOrder ) $ "CMN"
            BackOrd := ( nArea )->( OrdSetFocus( ::Container:SourceOrder ) )
         ENDIF

         ( nArea )->( DBGoto( ::Container:nLastItem ) )
         ( nArea )->( DBSkip() )
         DO WHILE ! ( nArea )->( Eof() )
            ::Container:AddItem( { ( nArea )->( EVAL( bField ) ), _OOHG_Eval( ::Container:ItemNumber ) } )
            AADD( ::Container:aValues, If( lNoEval, ( nArea )->( RecNo() ), EVAL( bValueSource ) ) )
            IF ValidHandler( ::Container:ImageList )
               ::Container:AddBitMap( Eval( ::Container:ImageSource ) )
            ENDIF

            ::Container:nLastItem := ( nArea )->( Recno() )
            ( nArea )->( DBSkip() )
         ENDDO

         IF BackOrd != NIL
            ( nArea )->( OrdSetFocus( BackOrd ) )
         ENDIF
         ( nArea )->( DBGoTo( BackRec ) )
      ENDIF

   ELSEIF Lo_wParam == SB_THUMBTRACK
      IF ( nArea := Select( ::Container:WorkArea ) ) != 0
         bField := ::Container:Field
         bValueSource := ::Container:ValueSource
         lNoEval := EMPTY( bValueSource )

         BackRec := ( nArea )->( Recno() )
         IF ValType( ::Container:SourceOrder ) == "B"
            BackOrd := ( nArea )->( OrdSetFocus( ( nArea )->( Eval( ::Container:SourceOrder ) ) ) )
         ELSEIF ValType( ::Container:SourceOrder ) $ "CMN"
            BackOrd := ( nArea )->( OrdSetFocus( ::Container:SourceOrder ) )
         ENDIF

         ( nArea )->( DBGoto( ::Container:nLastItem ) )
         ( nArea )->( DBSkip() )
         i := 0
         DO WHILE ! ( nArea )->( Eof() ) .and. i < 3
            ::Container:AddItem( { ( nArea )->( EVAL( bField ) ), _OOHG_Eval( ::Container:ItemNumber ) } )
            AADD( ::Container:aValues, If( lNoEval, ( nArea )->( RecNo() ), EVAL( bValueSource ) ) )
            IF ValidHandler( ::Container:ImageList )
               ::Container:AddBitMap( Eval( ::Container:ImageSource ) )
            ENDIF

            ::Container:nLastItem := ( nArea )->( Recno() )
            ( nArea )->( DBSkip() )
            i ++
         ENDDO

         IF BackOrd != NIL
            ( nArea )->( OrdSetFocus( BackOrd ) )
         ENDIF
         ( nArea )->( DBGoTo( BackRec ) )
         SetWindowPos( ::hWnd, 0, 0, 0, 0, 0, SWP_NOACTIVATE + SWP_FRAMECHANGED + SWP_NOSIZE + SWP_NOMOVE )
      ENDIF

   ELSE

      RETURN ::Super:Events_VScroll( wParam )

   ENDIF

   RETURN NIL

#pragma BEGINDUMP

static WNDPROC lpfnOldWndProcCL = 0;

static LRESULT APIENTRY SubClassFuncCL( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{

   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProcCL );
}

HB_FUNC( INITLISTCOMBO )
{
   lpfnOldWndProcCL = ( WNDPROC ) SetWindowLong( HWNDparam( 1 ), GWL_WNDPROC, ( LONG ) SubClassFuncCL );
}

#pragma ENDDUMP

FUNCTION SetComboRefresh( lValue )

   IF HB_IsLogical( lValue )
      _OOHG_ComboRefresh := lValue
   ENDIF

   RETURN _OOHG_ComboRefresh

CLASS TEditCombo FROM TControl STATIC

   DATA LastKey INIT 0

   METHOD Define
   METHOD Events

   ENDCLASS

METHOD Define( Container, hWnd ) CLASS TEditCombo

   ::SetForm( , Container )
   InitEditCombo( hWnd )
   ::Register( hWnd )

   RETURN Self

METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TEditCombo

   IF nMsg == WM_KEYDOWN
      ::LastKey := wParam
   ENDIF

   RETURN ::Super:Events( hWnd, nMsg, wParam, lParam )

#pragma BEGINDUMP

static WNDPROC lpfnOldWndProcCE = 0;

static LRESULT APIENTRY SubClassFuncCE( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{

   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProcCE );
}

HB_FUNC( INITEDITCOMBO )
{
   lpfnOldWndProcCE = ( WNDPROC ) SetWindowLong( HWNDparam( 1 ), GWL_WNDPROC, ( LONG ) SubClassFuncCE );
}

#pragma ENDDUMP
