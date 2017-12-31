/*
* $Id: h_browse.prg $
*/
/*
* ooHG source code:
* Browse and BrowseByCell controls
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

#define GO_TOP    -1
#define GO_BOTTOM  1

CLASS TOBrowse FROM TXBrowse

   DATA Type                      INIT "BROWSE" READONLY
   DATA aRecMap                   INIT {}
   DATA RecCount                  INIT 0
   DATA lUpdateAll                INIT .F.
   DATA nRecLastValue             INIT 0 PROTECTED
   DATA SyncStatus                INIT Nil
   /*
   * When .T. the browse behaves as if SET BROWSESYNC is ON.
   * When .F. the browse behaves as if SET BROWSESYNC if OFF.
   * When Nil the browse behaves according to SET BROWESYNC value.
   */

   METHOD BrowseOnChange
   METHOD CurrentRow              SETGET
   METHOD DbGoTo
   METHOD DbSkip
   METHOD Define
   METHOD Define3
   METHOD Delete
   METHOD DoChange
   METHOD Down
   METHOD EditAllCells
   METHOD EditCell
   METHOD EditGrid
   METHOD EditItem_B
   METHOD End
   METHOD Events
   METHOD Events_Notify
   METHOD FastUpdate
   METHOD Home
   METHOD MoveTo                  BLOCK { || Nil }
   METHOD PageDown
   METHOD PageUp
   METHOD Refresh
   METHOD RefreshData
   METHOD ScrollUpdate
   METHOD SetControlValue         BLOCK { || Nil }
   METHOD SetScrollPos
   METHOD SetValue
   METHOD TopBottom
   METHOD Up
   METHOD UpDate
   METHOD UpdateColors
   METHOD Value                   SETGET

   MESSAGE GoBottom               METHOD End
   MESSAGE GoTop                  METHOD Home

   /*
   Available methods from TXBrowse:
   AddColumn
   AdjustRightScroll
   AppendItem
   ColumnAutoFit
   ColumnAutoFitH
   ColumnBlock
   ColumnsAutoFit
   ColumnsAutoFitH
   ColumnWidth
   CurrentRow
   Define4
   DeleteColumn
   EditItem
   Enabled
   FixBlocks
   GetCellType
   HelpId
   RefreshRow
   SetColumn
   SizePos
   ToExcel
   ToolTip
   ToOpenOffice
   Visible
   VScrollVisible
   WorkArea

   Available methods from TGrid:
   AddBitMap
   AdjustResize
   Append
   BackColor
   Cell
   CellCaption
   CellImage
   ColumnBetterAutoFit
   ColumnCount
   ColumnHide
   ColumnOrder
   ColumnsBetterAutoFit
   ColumnShow
   CompareItems
   CountPerPage
   Define2
   DeleteAllItems
   DeleteItem
   EditCell2
   EditItem2
   Events_Enter
   FirstColInOrder
   FirstSelectedItem
   FirstVisibleColumn
   FirstVisibleItem
   FixControls
   FontColor
   Header
   HeaderHeight
   HeaderImage
   HeaderImageAlign
   HeaderSetFont
   InsertBlank
   IsColumnReadOnly
   IsColumnWhen
   Item
   ItemCount
   ItemHeight
   Justify
   LastColInOrder
   LastVisibleColumn
   LoadHeaderImages
   NextColInOrder
   OnEnter
   PriorColInOrder
   Release
   ScrollToCol
   ScrollToLeft
   ScrollToNext
   ScrollToPrior
   ScrollToRight
   SetItemColor
   SetRangeColor
   SetSelectedColors
   */

   ENDCLASS

METHOD Define( ControlName, ParentForm, nCol, nRow, nWidth, nHeight, aHeaders, aWidths, ;
      aFields, nValue, cFontName, nFontSize, cTooltip, bOnChange, ;
      bOnDblClick, aHeadClick, bOnGotFocus, bOnLostFocus, cWorkArea, ;
      lAllowDelete, lNoLines, aImage, aJust, nHelpId, lBold, lItalic, ;
      lUnderline, lStrikeout, lBreak, uBackColor, uFontColor, lLock, ;
      lInPlace, lNoVScroll, lAllowAppend, aReadonly, aValid, ;
      aValidMessages, lAllowEdit, uDynamicBackColor, aWhenFields, ;
      uDynamicForecolor, aPicture, lRtl, bOnAppend, bOnEditCell, ;
      aEditControls, aReplaceFields, lRecCount, aColumnInfo, ;
      lHasHeaders, bOnEnter, lDisabled, lNoTabStop, lInvisible, ;
      lDescending, bDelWhen, cDelMsg, bOnDelete, aHeaderImage, ;
      aHeaderImageAlign, lFullMove, aSelectedColors, aEditKeys, ;
      uRefresh, lDblBffr, lFocusRect, lPLM, lSync, lFixedCols, ;
      lNoDelMsg, lUpdateAll, bOnAbortedit, bOnClick, lFixedWidths, ;
      lFixedBlocks, bBeforeColMove, bAfterColMove, bBeforeColSize, ;
      bAfterColSize, bBeforeAutofit, lLikeExcel, lButtons, lUpdCols, ;
      lFixedCtrls, bHeadRClick, lExtDbl, lNoModal, lSilent, lAltA, ;
      lNoShowAlways, lNone, lCBE, bOnRClick, lCheckBoxes, bOnCheck, ;
      bOnRowRefresh, aDefaultValues, bOnEditEnd, lAtFirst, ;
      bbeforeditcell, bEditCellValue, klc ) CLASS TOBrowse

   LOCAL nWidth2, nCol2, oScroll, z

   ASSIGN ::aFields     VALUE aFields      TYPE "A"
   ASSIGN ::aHeaders    VALUE aHeaders     TYPE "A" DEFAULT {}
   ASSIGN ::aWidths     VALUE aWidths      TYPE "A" DEFAULT {}
   ASSIGN ::aJust       VALUE aJust        TYPE "A" DEFAULT {}
   ASSIGN ::lDescending VALUE lDescending  TYPE "L"
   ASSIGN ::SyncStatus  VALUE lSync        TYPE "L" DEFAULT Nil
   ASSIGN ::lUpdateAll  VALUE lUpdateAll   TYPE "L"
   ASSIGN ::lUpdCols    VALUE lUpdCols     TYPE "L"
   ASSIGN lFixedBlocks  VALUE lFixedBlocks TYPE "L" DEFAULT _OOHG_BrowseFixedBlocks
   ASSIGN lFixedCtrls   VALUE lFixedCtrls  TYPE "L" DEFAULT _OOHG_BrowseFixedControls
   ASSIGN lAltA         VALUE lAltA        TYPE "L" DEFAULT .T.

   IF HB_IsArray( aDefaultValues )
      ::aDefaultValues := aDefaultValues
      ASize( ::aDefaultValues, Len( ::aHeaders ) )
   ELSE
      ::aDefaultValues := Array( Len( ::aHeaders ) )
      AFill( ::aDefaultValues, aDefaultValues )
   ENDIF

   IF ValType( uRefresh ) == "N"
      IF uRefresh == REFRESH_FORCE .OR. uRefresh == REFRESH_NO .OR. uRefresh == REFRESH_DEFAULT
         ::RefreshType := uRefresh
      ELSE
         ::RefreshType := REFRESH_DEFAULT
      ENDIF
   ELSE
      ::RefreshType := REFRESH_DEFAULT
   ENDIF

   IF ValType( aColumnInfo ) == "A" .AND. Len( aColumnInfo ) > 0
      IF ValType( ::aFields ) == "A"
         aSize( ::aFields,  Len( aColumnInfo ) )
      ELSE
         ::aFields := Array( Len( aColumnInfo ) )
      ENDIF
      aSize( ::aHeaders, Len( aColumnInfo ) )
      aSize( ::aWidths,  Len( aColumnInfo ) )
      aSize( ::aJust,    Len( aColumnInfo ) )
      FOR z := 1 To Len( aColumnInfo )
         IF ValType( aColumnInfo[ z ] ) == "A"
            IF Len( aColumnInfo[ z ] ) >= 1 .AND. ValType( aColumnInfo[ z ][ 1 ] ) $ "CMB"
               ::aFields[ z ]  := aColumnInfo[ z ][ 1 ]
            ENDIF
            IF Len( aColumnInfo[ z ] ) >= 2 .AND. ValType( aColumnInfo[ z ][ 2 ] ) $ "CM"
               ::aHeaders[ z ] := aColumnInfo[ z ][ 2 ]
            ENDIF
            IF Len( aColumnInfo[ z ] ) >= 3 .AND. ValType( aColumnInfo[ z ][ 3 ] ) $ "N"
               ::aWidths[ z ]  := aColumnInfo[ z ][ 3 ]
            ENDIF
            IF Len( aColumnInfo[ z ] ) >= 4 .AND. ValType( aColumnInfo[ z ][ 4 ] ) $ "N"
               ::aJust[ z ]    := aColumnInfo[ z ][ 4 ]
            ENDIF
         ENDIF
      NEXT
   ENDIF

   IF ! ValType( cWorkArea ) $ "CMO" .OR. Empty( cWorkArea )
      cWorkArea := Alias()
   ENDIF
   cWorkArea := ::WorkArea( cWorkArea )

   IF ValType( ::aFields ) != "A"
      ::aFields := ( cWorkArea )->( DbStruct() )
      aEval( ::aFields, { |x,i| ::aFields[ i ] := cWorkArea + "->" + x[ 1 ] } )
   ENDIF

   aSize( ::aHeaders, Len( ::aFields ) )
   aEval( ::aHeaders, { |x,i| ::aHeaders[ i ] := If( ! ValType( x ) $ "CM", If( ValType( ::aFields[ i ] ) $ "CM", ::aFields[ i ], "" ), x ) } )

   aSize( ::aWidths, Len( ::aFields ) )
   aEval( ::aWidths, { |x,i| ::aWidths[ i ] := If( ! ValType( x ) == "N", 100, x ) } )

   // If splitboxed force no vertical scrollbar

   ASSIGN lNoVScroll VALUE lNoVScroll TYPE "L" DEFAULT .F.
   IF ValType( nCol ) != "N" .OR. ValType( nRow ) != "N"
      lNoVScroll := .T.
   ENDIF

   ASSIGN nWidth VALUE nWidth TYPE "N" DEFAULT ::nWidth
   nWidth2 := If( lNoVScroll, nWidth, nWidth - GetVScrollBarWidth() )

   ::Define3( ControlName, ParentForm, nCol, nRow, nWidth2, nHeight, cFontName, nFontSize, ;
      cTooltip, aHeadClick, lNoLines, aImage, lBreak, nHelpId, lBold, ;
      lItalic, lUnderline, lStrikeout, lAllowEdit, uBackColor, uFontColor, ;
      uDynamicBackColor, uDynamicForeColor, aPicture, lRtl, lInPlace, ;
      aEditControls, aReadonly, aValid, aValidMessages, aWhenFields, ;
      lDisabled, lNoTabStop, lInvisible, lHasHeaders, aHeaderImage, ;
      aHeaderImageAlign, lFullMove, aSelectedColors, aEditKeys, ;
      lDblBffr, lFocusRect, lPLM, lFixedCols, lFixedWidths, ;
      lLikeExcel, lButtons, lAllowDelete, cDelMsg, lNoDelMsg, ;
      lAllowAppend, lNoModal, lFixedCtrls, lExtDbl, nValue, lSilent, ;
      lAltA, lNoShowAlways, lNone, lCBE, lCheckBoxes, lAtFirst, klc )

   ::nWidth := nWidth

   ASSIGN ::Lock          VALUE lLock          TYPE "L"
   ASSIGN ::aReplaceField VALUE aReplaceFields TYPE "A"
   ASSIGN ::lRecCount     VALUE lRecCount      TYPE "L"

   ::FixBlocks( lFixedBlocks )

   ::aRecMap := {}

   ::ScrollButton := TScrollButton():Define( , Self, nCol2, ::nHeight - GetHScrollBarHeight(), GetVScrollBarWidth(), GetHScrollBarHeight() )

   oScroll := TScrollBar()
   oScroll:nWidth := GetVScrollBarWidth()
   oScroll:SetRange( 1, 1000 )

   IF ::lRtl .AND. ! ::Parent:lRtl
      ::nCol := ::nCol + GetVScrollBarWidth()
      nCol2 := -GetVScrollBarWidth()
   ELSE
      nCol2 := nWidth2
   ENDIF
   oScroll:nCol := nCol2

   IF IsWindowStyle( ::hWnd, WS_HSCROLL )
      oScroll:nRow := 0
      oScroll:nHeight := ::nHeight - GetHScrollBarHeight()
   ELSE
      oScroll:nRow := 0
      oScroll:nHeight := ::nHeight
      ::ScrollButton:Visible := .F.
   ENDIF

   oScroll:Define( , Self )
   ::VScroll := oScroll
   ::VScroll:OnLineUp   := { || ::SetFocus():Up() }
   ::VScroll:OnLineDown := { || ::SetFocus():Down() }
   ::VScroll:OnPageUp   := { || ::SetFocus():PageUp() }
   ::VScroll:OnPageDown := { || ::SetFocus():PageDown() }
   ::VScroll:OnThumb    := { |VScroll,Pos| ::SetFocus():SetScrollPos( Pos, VScroll ) }
   ::VScroll:ToolTip    := cTooltip
   ::VScroll:HelpId     := nHelpId

   ::VScrollCopy := oScroll

   // Forces to hide "additional" controls when it's inside a non-visible TAB page.
   ::Visible := ::Visible

   ::lVScrollVisible := .T.
   IF lNoVScroll
      ::VScrollVisible( .F. )
   ENDIF

   ::SizePos()

   ::lChangeBeforeEdit := .F.

   // Must be set after control is initialized
   ::Define4( bOnChange, bOnDblClick, bOnGotFocus, bOnLostFocus, bOnEditCell, bOnEnter, ;
      bOnCheck, bOnAbortEdit, bOnClick, bBeforeColMove, bAfterColMove, ;
      bBeforeColSize, bAfterColSize, bBeforeAutoFit, bOnDelete, ;
      bDelWhen, bOnAppend, bHeadRClick, bOnRClick, bOnEditEnd, bOnRowRefresh, ;
      bbeforeditcell, bEditCellValue )

   ::Value := nValue

   RETURN Self

METHOD Define3( ControlName, ParentForm, x, y, w, h, fontname, fontsize, ;
      tooltip, aHeadClick, nogrid, aImage, break, HelpId, bold, ;
      italic, underline, strikeout, edit, backcolor, fontcolor, ;
      dynamicbackcolor, dynamicforecolor, aPicture, lRtl, InPlace, ;
      editcontrols, readonly, valid, validmessages, aWhenFields, ;
      lDisabled, lNoTabStop, lInvisible, lHasHeaders, aHeaderImage, ;
      aHeaderImageAlign, FullMove, aSelectedColors, aEditKeys, ;
      dblbffr, lFocusRect, lPLM, lFixedCols, lFixedWidths, ;
      lLikeExcel, lButtons, AllowDelete, DelMsg, lNoDelMsg, ;
      AllowAppend, lNoModal, lFixedCtrls, lExtDbl, Value, lSilent, ;
      lAltA, lNoShowAlways, lNone, lCBE, lCheckBoxes, lAtFirst, klc ) CLASS TOBrowse

   ::Define2( ControlName, ParentForm, x, y, w, h, ::aHeaders, ::aWidths, {}, ;
      , fontname, fontsize, tooltip, aHeadClick, nogrid, ;
      aImage, ::aJust, break, HelpId, bold, italic, underline, ;
      strikeout, , , edit, backcolor, ;
      fontcolor, dynamicbackcolor, dynamicforecolor, aPicture, lRtl, ;
      LVS_SINGLESEL, inplace, editcontrols, readonly, valid, validmessages, ;
      aWhenFields, lDisabled, lNoTabStop, lInvisible, lHasHeaders, ;
      aHeaderImage, aHeaderImageAlign, FullMove, aSelectedColors, ;
      aEditKeys, lCheckBoxes, dblbffr, lFocusRect, lPLM, ;
      lFixedCols, lFixedWidths, lLikeExcel, lButtons, AllowDelete, ;
      DelMsg, lNoDelMsg, AllowAppend, lNoModal, lFixedCtrls, ;
      , , lExtDbl, lSilent, lAltA, ;
      lNoShowAlways, lNone, lCBE, lAtFirst, klc )

   IF ValType( Value ) == "N"
      ::nRecLastValue := Value
   ENDIF

   RETURN Self

METHOD UpDate( nRow, lComplete ) CLASS TOBrowse

   LOCAL PageLength, aTemp, _BrowseRecMap, x, nRecNo, nCurrentLength
   LOCAL lColor, aFields, cWorkArea, nWidth

   cWorkArea := ::WorkArea

   IF Select( cWorkArea ) == 0
      ::RecCount := 0

      RETURN Self
   ENDIF

   PageLength := ::CountPerPage

   IF PageLength < 1

      RETURN Self
   ENDIF

   nWidth := Len( ::aFields )

   IF ::FixBlocks()
      aFields := aClone( ::aColumnBlocks )
   ELSE
      aFields := Array( nWidth )
      aEval( ::aFields, { |c,i| aFields[ i ] := ::ColumnBlock( i ), c } )
   ENDIF

   lColor := ! ( Empty( ::DynamicForeColor ) .AND. Empty( ::DynamicBackColor ) )

   aTemp := Array( nWidth )

   IF ::Visible
      ::SetRedraw( .F. )
   ENDIF

   nCurrentLength  := ::ItemCount
   ::GridForeColor := Nil
   ::GridBackColor := Nil

   IF ::Eof()
      _BrowseRecMap := {}
      ::DeleteAllItems()
   ELSE
      IF ! HB_IsNumeric( nRow ) .OR. nRow < 1 .OR. nRow > PageLength
         nRow := 1
      ENDIF

      _BrowseRecMap := Array( nRow )
      nRecNo := ( cWorkArea )->( RecNo() )
      x := nRow
      DO WHILE x > 0
         _BrowseRecMap[ x ] := ( cWorkArea )->( RecNo() )
         x --
         ::DbSkip( -1 )
         IF ::Bof()
            EXIT
         ENDIF
      ENDDO
      DO WHILE x > 0
         _OOHG_DeleteArrayItem( _BrowseRecMap, x )
         x --
      ENDDO
      ::DbGoTo( nRecNo )
      ::DbSkip()
      DO WHILE Len( _BrowseRecMap ) < PageLength .AND. ! ::Eof()
         aAdd( _BrowseRecMap, ( cWorkArea )->( RecNo() ) )
         ::DbSkip()
      ENDDO
      IF HB_IsLogical( lComplete ) .AND. lComplete
         DO WHILE Len( _BrowseRecMap ) < PageLength
            ::DbGoTo( _BrowseRecMap[ 1 ] )
            ::DbSkip( -1 )
            IF ::Bof()
               EXIT
            ENDIF
            aAdd( _BrowseRecMap, Nil )
            aIns( _BrowseRecMap, 1 )
            _BrowseRecMap[ 1 ] := ( cWorkArea )->( RecNo() )
         ENDDO
      ENDIF
      FOR x := 1 To Len( _BrowseRecMap )
         ::DbGoTo( _BrowseRecMap[ x ] )

         aEval( aFields, { |b,i| aTemp[ i ] := Eval( b ) } )

         IF lColor
            ( cWorkArea )->( ::SetItemColor( x, , , aTemp ) )
         ENDIF

         IF nCurrentLength < x
            AddListViewItems( ::hWnd, aTemp )
            nCurrentLength ++
         ELSE
            ListViewSetItem( ::hWnd, aTemp, x )
         ENDIF
      NEXT x
      // Repositions the file as If _BrowseRecMap was builded using successive ::DbSkip() calls
      ::DbSkip()
      DO WHILE nCurrentLength > Len( _BrowseRecMap )
         ::DeleteItem( nCurrentLength )
         nCurrentLength --
      ENDDO
   ENDIF

   IF ::Visible
      ::SetRedraw( .T. )
   ENDIF

   ::aRecMap := _BrowseRecMap

   // Update headers text and images, columns widths and justifications
   IF ::lUpdateAll
      IF Len( ::aWidths ) != nWidth
         aSize( ::aWidths, nWidth )
      ENDIF
      aEval( ::aWidths, { |x,i| ::ColumnWidth( i, If( ! HB_IsNumeric( x ) .OR. x < 0, 0, x ) ) } )

      IF Len( ::aJust ) != nWidth
         aSize( ::aJust, nWidth )
         aEval( ::aJust, { |x,i| ::aJust[ i ] := If( ! HB_IsNumeric( x ), 0, x ) } )
      ENDIF
      aEval( ::aJust, { |x,i| ::Justify( i, x ) } )

      IF Len( ::aHeaders ) != nWidth
         aSize( ::aHeaders, nWidth )
         aEval( ::aHeaders, { |x,i| ::aHeaders[ i ] := If( ! ValType( x ) $ "CM", "", x ) } )
      ENDIF
      aEval( ::aHeaders, { |x,i| ::Header( i, x ) } )

      ::LoadHeaderImages( ::aHeaderImage )
   ENDIF

   RETURN Self

METHOD UpDateColors() CLASS TOBrowse

   LOCAL aTemp, x, aFields, cWorkArea, nWidth, nLen, _RecNo

   ::GridForeColor := Nil
   ::GridBackColor := Nil

   nLen := Len( ::aRecMap )
   IF nLen == 0

      RETURN Self
   ENDIF

   IF Empty( ::DynamicForeColor ) .AND. Empty( ::DynamicBackColor )

      RETURN Self
   ENDIF

   cWorkArea := ::WorkArea
   IF Select( cWorkArea ) == 0

      RETURN Self
   ENDIF

   nWidth := Len( ::aFields )
   aTemp := Array( nWidth )

   IF ::FixBlocks()
      aFields := aClone( ::aColumnBlocks )
   ELSE
      aFields := Array( nWidth )
      aEval( ::aFields, { |c,i| aFields[ i ] := ::ColumnBlock( i ), c } )
   ENDIF

   _RecNo := ( cWorkArea )->( RecNo() )

   IF ::Visible
      ::SetRedraw( .F. )
   ENDIF

   FOR x := 1 To nLen
      ::DbGoTo( ::aRecMap[ x ] )
      aEval( aFields, { |b,i| aTemp[ i ] := Eval( b ) } )
      ( cWorkArea )->( ::SetItemColor( x, , , aTemp ) )
   NEXT x

   IF ::Visible
      ::SetRedraw( .T. )
   ENDIF

   ::DbGoTo( _RecNo )

   RETURN Self

METHOD PageDown( lAppend ) CLASS TOBrowse

   LOCAL _RecNo, s, cWorkArea

   s := ::CurrentRow

   IF s >= Len( ::aRecMap )
      cWorkArea := ::WorkArea

      IF Select( cWorkArea ) == 0
         ::RecCount := 0

         RETURN Self
      ENDIF

      _RecNo := ( cWorkArea )->( RecNo() )

      IF Len( ::aRecMap ) == 0
         ::TopBottom( GO_BOTTOM )
         ::DbSkip( - ::CountPerPage + 1 )
      ELSE
         ::DbGoTo( ::aRecMap[ Len( ::aRecMap ) ] )
         // Check for more records
         ::DbSkip()
         IF ::Eof()
            ::DbGoTo( _RecNo )
            ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
            IF lAppend
               ::AppendItem()
            ENDIF

            RETURN Self
         ENDIF
         ::DbSkip( -1 )
      ENDIF
      ::Update()
      ::ScrollUpdate()
      ::CurrentRow := Len( ::aRecMap )
      ::DbGoTo( _RecNo )
   ELSE
      ::FastUpdate( ::CountPerPage - s, Len( ::aRecMap ) )
   ENDIF

   ::BrowseOnChange()

   RETURN Self

METHOD PageUp() CLASS TOBrowse

   LOCAL _RecNo, cWorkArea

   IF ::CurrentRow == 1
      cWorkArea := ::WorkArea
      IF Select( cWorkArea ) == 0
         ::RecCount := 0

         RETURN Self
      ENDIF
      _RecNo := ( cWorkArea )->( RecNo() )
      IF Len( ::aRecMap ) == 0
         ::TopBottom( GO_TOP )
      ELSE
         ::DbGoTo( ::aRecMap[ 1 ] )
      ENDIF
      ::DbSkip( - ::CountPerPage + 1 )
      ::ScrollUpdate()
      ::Update()
      ::DbGoTo( _RecNo )
      ::CurrentRow := 1
   ELSE
      ::FastUpdate( 1 - ::CurrentRow, 1 )
   ENDIF

   ::BrowseOnChange()

   RETURN Self

METHOD Home() CLASS TOBrowse                         // METHOD GoTop

   LOCAL _RecNo, cWorkArea

   cWorkArea := ::WorkArea
   IF Select( cWorkArea ) == 0
      ::RecCount := 0

      RETURN Self
   ENDIF
   _RecNo := ( cWorkArea )->( RecNo() )
   ::TopBottom( GO_TOP )
   ::ScrollUpdate()
   ::Update()
   ::DbGoTo( _RecNo )
   ::CurrentRow := 1

   ::BrowseOnChange()

   RETURN Self

METHOD End( lAppend ) CLASS TOBrowse                 // METHOD GoBottom

   LOCAL _RecNo, _BottomRec, cWorkArea

   cWorkArea := ::WorkArea
   IF Select( cWorkArea ) == 0
      ::RecCount := 0

      RETURN Self
   ENDIF
   _RecNo := ( cWorkArea )->( RecNo() )
   ::TopBottom( GO_BOTTOM )
   _BottomRec := ( cWorkArea )->( RecNo() )
   ::ScrollUpdate()

   // If it's for APPEND, leaves a blank line ;)
   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   ::DbSkip( - ::CountPerPage + IF( lAppend, 2, 1 ) )
   ::Update( 1, .F. )
   ::DbGoTo( _RecNo )
   ::CurrentRow := aScan( ::aRecMap, _BottomRec )

   ::BrowseOnChange()

   RETURN Self

METHOD Up() CLASS TOBrowse

   LOCAL s, _RecNo, nLen, lDone := .F., cWorkArea

   s := ::CurrentRow

   IF s <= 1
      cWorkArea := ::WorkArea
      IF Select( cWorkArea ) == 0
         ::RecCount := 0

         RETURN lDone
      ENDIF

      _RecNo := ( cWorkArea )->( RecNo() )

      IF Len( ::aRecMap ) == 0
         ::TopBottom( GO_TOP )
         ::DbSkip( -1 )
         ::Update()
      ELSE
         // Check for more records
         ::DbGoTo( ::aRecMap[ 1 ] )
         ::DbSkip( -1 )
         IF ::Bof()
            ::DbGoTo( _RecNo )

            RETURN lDone
         ENDIF
         // Add one record at the top
         aAdd( ::aRecMap, Nil )
         aIns( ::aRecMap, 1 )
         ::aRecMap[ 1 ] := ( cWorkArea )->( RecNo() )
         IF ::Visible
            ::SetRedraw( .F. )
         ENDIF
         ::InsertBlank( 1 )
         ::RefreshRow( 1 )
         nLen := Len( ::aRecMap )
         // Resize record map
         IF nLen > ::CountPerPage
            ::DeleteItem( nLen )
            aSize( ::aRecMap, nLen - 1 )
         ENDIF
         IF ::Visible
            ::SetRedraw( .T. )
         ENDIF
      ENDIF

      ::ScrollUpdate()
      ::DbGoTo( _RecNo )
      ::CurrentRow := 1
      IF Len( ::aRecMap ) != 0
         lDone := .T.
      ENDIF
   ELSE
      ::FastUpdate( -1, s - 1 )
      lDone := .T.
   ENDIF

   ::BrowseOnChange()

   RETURN lDone

METHOD Down( lAppend ) CLASS TOBrowse

   LOCAL s, _RecNo, nLen, lDone := .F., cWorkArea

   s := ::CurrentRow

   IF s >= Len( ::aRecMap )
      cWorkArea := ::WorkArea
      IF Select( cWorkArea ) == 0
         ::RecCount := 0

         RETURN lDone
      ENDIF

      _RecNo := ( cWorkArea )->( RecNo() )

      IF Len( ::aRecMap ) == 0
         ::TopBottom( GO_TOP )
         ::DbSkip()
         ::Update()
      ELSE
         // Check for more records
         ::DbGoTo( ::aRecMap[ Len( ::aRecMap ) ] )
         ::DbSkip()
         IF ::Eof()
            ::DbGoTo( _RecNo )
            ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT ::AllowAppend
            IF lAppend
               lDone := ::AppendItem()
            ENDIF

            RETURN lDone
         ENDIF
         // Add one record at the bottom
         aAdd( ::aRecMap, ( cWorkArea )->( RecNo() ) )
         nLen := Len( ::aRecMap )
         IF ::Visible
            ::SetRedraw( .F. )
         ENDIF
         ::RefreshRow( nLen )
         // Resize record map
         IF nLen > ::CountPerPage
            ::DeleteItem( 1 )
            _OOHG_DeleteArrayItem( ::aRecMap, 1 )
         ENDIF
         IF ::Visible
            ::SetRedraw( .T. )
         ENDIF
      ENDIF

      ::ScrollUpdate()
      ::DbGoTo( _RecNo )
      ::CurrentRow := Len( ::aRecMap )
      IF Len( ::aRecMap ) != 0
         lDone := .T.
      ENDIF
   ELSE
      ::FastUpdate( 1, s + 1 )
      lDone := .T.
   ENDIF

   ::BrowseOnChange()

   RETURN lDone

METHOD TopBottom( nDir ) CLASS TOBrowse

   LOCAL cWorkArea := ::WorkArea

   IF ::lDescending
      nDir := - nDir
   ENDIF
   IF nDir == GO_BOTTOM
      ( cWorkArea )->( DbGoBottom() )
   ELSE
      ( cWorkArea )->( DbGoTop() )
   ENDIF
   ::Bof := .F.
   ::Eof := ( cWorkArea )->( Eof() )

   RETURN Self

METHOD DbSkip( nRows ) CLASS TOBrowse

   LOCAL cWorkArea := ::WorkArea

   ASSIGN nRows VALUE nRows TYPE "N" DEFAULT 1
   IF ! ::lDescending
      ( cWorkArea )->( DbSkip(   nRows ) )
      ::Bof := ( cWorkArea )->( Bof() )
      ::Eof := ( cWorkArea )->( Eof() ) .OR. ( ( cWorkArea )->( Recno() ) > ( cWorkArea )->( RecCount() ) )
   ELSE
      ( cWorkArea )->( DbSkip( - nRows ) )
      IF ( cWorkArea )->( Eof() )
         ( cWorkArea )->( DbGoBottom() )
         ::Bof := .T.
         ::Eof := ( cWorkArea )->( Eof() )
      ELSEIF ( cWorkArea )->( Bof() )
         ::Eof := .T.
         ::DbGoTo( 0 )
      ENDIF
   ENDIF

   RETURN Self

METHOD DbGoTo( nRecNo ) CLASS TOBrowse

   LOCAL cWorkArea := ::WorkArea

   ( cWorkArea )->( DbGoTo( nRecNo ) )
   ::Bof := .F.
   ::Eof := ( cWorkArea )->( Eof() ) .OR. ( ( cWorkArea )->( Recno() ) > ( cWorkArea )->( RecCount() ) )

   RETURN Self

METHOD SetValue( Value, mp ) CLASS TOBrowse

   LOCAL _RecNo, m, cWorkArea

   cWorkArea := ::WorkArea

   IF Select( cWorkArea ) == 0
      ::RecCount := 0

      RETURN Self
   ENDIF

   IF Value <= 0
      IF ::lNoneUnsels
         ::CurrentRow := 0
         ::BrowseOnChange()
      ENDIF

      RETURN Self
   ENDIF

   IF _OOHG_ThisEventType == 'BROWSE_ONCHANGE'
      IF ::hWnd == _OOHG_ThisControl:hWnd
         MsgOOHGError( "BROWSE: Value property can't be changed inside ON CHANGE event. Program terminated." )
      ENDIF
   ENDIF

   IF Value > ( cWorkArea )->( RecCount() )
      ::DeleteAllItems()
      ::BrowseOnChange()

      RETURN Self
   ENDIF

   IF ValType( mp ) != "N"
      m := Int( ::CountPerPage / 2 )
   ELSE
      m := mp
   ENDIF

   _RecNo := ( cWorkArea )->( RecNo() )

   ::DbGoTo( Value )
   IF ::Eof()
      ::DbGoTo( _RecNo )

      RETURN Self
   ENDIF

   // Enforce filters in use
   ::DbSkip()
   ::DbSkip( -1 )
   IF ( cWorkArea )->( RecNo() ) != Value
      ::DbGoTo( _RecNo )

      RETURN Self
   ENDIF

   IF PCount() < 2                           // TODO: Check
      ::ScrollUpdate()
   ENDIF
   ::DbSkip( -m + 1 )
   ::Update()
   ::DbGoTo( _RecNo )
   ::CurrentRow := aScan( ::aRecMap, Value )

   _OOHG_ThisEventType := 'BROWSE_ONCHANGE'
   ::BrowseOnChange()
   _OOHG_ThisEventType := ''

   RETURN Self

METHOD Delete() CLASS TOBrowse

   LOCAL Value, nRecNo, lSync, cWorkArea

   Value := ::Value

   IF Value == 0

      RETURN Self
   ENDIF

   cWorkArea := ::WorkArea
   nRecNo := ( cWorkArea )->( RecNo() )

   ::DbGoTo( Value )

   IF ::Lock .AND. ! ( cWorkArea )->( Rlock() )
      MsgExclamation( _OOHG_Messages( 3, 9 ), _OOHG_Messages( 4, 2 ) )
   ELSE
      ( cWorkArea )->( DbDelete() )

      // Do before unlocking record or moving record pointer
      // so block can operate on deleted record (e.g. to copy to a log).
      IF HB_IsBlock( ::OnDelete )
         ::DoEvent( ::OnDelete, 'DELETE' )
      ENDIF

      IF ::Lock
         ( cWorkArea )->( DbCommit() )
         ( cWorkArea )->( DbUnlock() )
      ENDIF
      ::DbSkip()
      IF ::Eof()
         ::TopBottom( GO_BOTTOM )
      ENDIF

      IF Set( _SET_DELETED )
         ::SetValue( ( cWorkArea )->( RecNo() ), ::CurrentRow )
      ENDIF
   ENDIF

   IF HB_IsLogical( ::SyncStatus )
      lSync := ::SyncStatus
   ELSE
      lSync := _OOHG_BrowseSyncStatus
   ENDIF

   IF lSync
      IF ( cWorkArea )->( RecNo() ) != ::Value
         ::DbGoTo( ::Value )
      ENDIF
   ELSE
      ::DbGoTo( nRecNo )
   ENDIF

   RETURN Self

METHOD EditItem_B( lAppend ) CLASS TOBrowse

   LOCAL nOldRecNo, nItem, cWorkArea, lRet, nNewRec

   IF ::FirstVisibleColumn == 0

      RETURN .F.
   ENDIF

   cWorkArea := ::WorkArea
   IF Select( cWorkArea ) == 0
      ::RecCount := 0

      RETURN .F.
   ENDIF

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.

   nItem := ::CurrentRow
   IF nItem == 0 .AND. ! lAppend

      RETURN .F.
   ENDIF

   nOldRecNo := ( cWorkArea )->( RecNo() )

   IF ! lAppend
      ::DbGoTo( ::aRecMap[ nItem ] )
   ENDIF

   lRet := ::Super:EditItem_B( lAppend )

   IF lRet .AND. lAppend
      nNewRec := ( cWorkArea )->( RecNo() )
      ::DbGoTo( nOldRecNo )
      ::Value := nNewRec
   ELSE
      ::DbGoTo( nOldRecNo )
   ENDIF

   RETURN lRet

METHOD EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, lAppend, nOnFocusPos, lRefresh, lChange ) CLASS TOBrowse

   LOCAL lRet, BackRec, cWorkArea, lBefore

   ASSIGN lAppend  VALUE lAppend  TYPE "L" DEFAULT .F.
   ASSIGN nRow     VALUE nRow     TYPE "N" DEFAULT ::CurrentRow
   ASSIGN lRefresh VALUE lRefresh TYPE "L" DEFAULT ( ::RefreshType == REFRESH_FORCE )
   ASSIGN lChange  VALUE lChange  TYPE "L" DEFAULT ::lChangeBeforeEdit

   IF nRow < 1 .OR. nRow > ::ItemCount

      RETURN .F.
   ENDIF

   cWorkArea := ::WorkArea
   IF Select( cWorkArea ) == 0
      ::RecCount := 0

      RETURN .F.
   ENDIF

   IF lAppend
      BackRec := ( cWorkArea )->( RecNo() )
      ::DbGoTo( 0 )
   ELSE
      IF lChange
         ::Value := ::aRecMap[ nRow ]
      ENDIF
      BackRec := ( cWorkArea )->( RecNo() )
      ::DbGoTo( ::aRecMap[ nRow ] )
   ENDIF

   lBefore := ::lCalledFromClass
   ::lCalledFromClass := .T.
   lRet := ::Super:EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, nOnFocusPos, .F., lAppend )
   ::lCalledFromClass := lBefore

   IF lRet .AND. lAppend
      aAdd( ::aRecMap, ( cWorkArea )->( RecNo() ) )
   ENDIF

   // ::Super:EditCell refreshes the current row only,
   // so here we must refresh entire grid when ::RefreshType == REFRESH_FORCE

   ::DbGoTo( BackRec )

   IF lRet
      IF lAppend .AND. lChange
         ::Value := aTail( ::aRecMap )
      ELSE
         IF ! ::lCalledFromClass .AND. ::bPosition == 9                  // MOUSE EXIT
            // Editing window lost focus
            ::bPosition := 0                   // This restores the processing of click messages
            IF ::nDelayedClick[ 1 ] > 0
               // A click message was delayed
               IF ::nDelayedClick[ 3 ] <= 0
                  ::SetValue( ::aRecMap[ ::nDelayedClick[ 1 ] ], ::nDelayedClick[ 1 ] )
               ENDIF

               IF HB_IsNil( ::nDelayedClick[ 4 ] )
                  IF HB_IsBlock( ::OnClick )
                     IF ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                        IF ! ::NestedClick
                           ::NestedClick := ! _OOHG_NestedSameEvent()
                           ::DoEventMouseCoords( ::OnClick, "CLICK" )
                           ::NestedClick := .F.
                        ENDIF
                     ENDIF
                  ENDIF
               ELSE
                  IF HB_IsBlock( ::OnRClick )
                     IF ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                        ::DoEventMouseCoords( ::OnRClick, "RCLICK" )
                     ENDIF
                  ENDIF
               ENDIF

               IF ::nDelayedClick[ 3 ] > 0
                  // change check mark
                  ::CheckItem( ::nDelayedClick[ 3 ], ! ::CheckItem( ::nDelayedClick[ 3 ] ) )
               ENDIF

               // fire context menu
               IF ! HB_IsNil( ::nDelayedClick[ 4 ] ) .AND. ::ContextMenu != Nil .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0 )
                  ::ContextMenu:Cargo := ::nDelayedClick[ 4 ]
                  ::ContextMenu:Activate()
               ENDIF
            ENDIF
         ENDIF
         IF lRefresh
            ::Refresh()
         ENDIF
      ENDIF
   ENDIF

   RETURN lRet

METHOD EditAllCells( nRow, nCol, lAppend, lOneRow, lChange, lRefresh ) CLASS TOBrowse

   LOCAL lRet, lSomethingEdited, lRowAppended, nRecNo, cWorkArea

   ASSIGN lOneRow VALUE lOneRow TYPE "L" DEFAULT .T.
   IF ::FullMove .OR. ! lOneRow

      RETURN ::EditGrid( nRow, nCol, lAppend, lOneRow, lChange, lRefresh )
   ENDIF
   IF ::FirstVisibleColumn == 0

      RETURN .F.
   ENDIF
   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   IF ! HB_IsNumeric( nCol )
      IF ::lAppendMode .OR. lAppend .OR. ::lAtFirstCol
         nCol := ::FirstColInOrder
      ELSE
         nCol := ::FirstVisibleColumn
      ENDIF
   ENDIF
   IF nCol < 1 .OR. nCol > Len( ::aHeaders )

      RETURN .F.
   ENDIF

   IF lAppend
      ::GoBottom( .T. )
      ::InsertBlank( ::ItemCount + 1 )
      nRow := ::CurrentRow := ::ItemCount
      ::lAppendMode := .T.
   ELSE
      IF ! HB_IsNumeric( nRow )
         nRow := Max( ::CurrentRow, 1 )
      ENDIF
      IF nRow < 1 .OR. nRow > ::ItemCount

         RETURN .F.
      ENDIF
      ASSIGN lChange VALUE lChange TYPE "L" DEFAULT ::lChangeBeforeEdit
      IF lChange
         ::Value := { ::aRecMap[ nRow ], nCol }
      ENDIF
   ENDIF

   ASSIGN lRefresh VALUE lRefresh TYPE "L" DEFAULT ( ::RefreshType == REFRESH_DEFAULT .OR. ::RefreshType == REFRESH_FORCE )

   cWorkArea := ::WorkArea

   lSomethingEdited := .F.

   DO WHILE nCol >= 1 .AND. nCol <= Len( ::aHeaders ) .AND. Select( cWorkArea ) # 0
      nRecNo := ( cWorkArea )->( RecNo() )
      IF lAppend
         ::DbGoTo( 0 )
      ELSE
         ::DbGoTo( ::aRecMap[ nRow ] )
      ENDIF

      _OOHG_ThisItemCellValue := ::Cell( nRow, nCol )

      IF ::IsColumnReadOnly( nCol, nRow )
         // Read only column
      ELSEIF ! ::IsColumnWhen( nCol, nRow )
         // WHEN returned .F.
      ELSEIF aScan( ::aHiddenCols, nCol, nRow ) > 0
         // Hidden column
      ELSE
         ::DbGoTo( nRecNo )

         ::lCalledFromClass := .T.
         lRet := ::EditCell( nRow, nCol, , , , , lAppend, , .F., .F. )
         ::lCalledFromClass := .F.

         IF ! lRet
            IF lAppend
               ::lAppendMode := .F.
               ::GoBottom()
            ENDIF
            EXIT
         ENDIF

         lSomethingEdited := .T.
         IF lAppend
            lRowAppended := .T.
            lAppend := .F.
         ENDIF

         IF ::bPosition == 9                  // MOUSE EXIT
            // Editing window lost focus
            ::bPosition := 0                   // This restores the processing of click messages
            IF ::nDelayedClick[ 1 ] > 0
               // A click message was delayed
               IF ::nDelayedClick[ 3 ] <= 0
                  ::SetValue( ::aRecMap[ ::nDelayedClick[ 1 ] ], ::nDelayedClick[ 1 ] )
               ENDIF

               IF HB_IsNil( ::nDelayedClick[ 4 ] )
                  IF HB_IsBlock( ::OnClick )
                     IF ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                        IF ! ::NestedClick
                           ::NestedClick := ! _OOHG_NestedSameEvent()
                           ::DoEventMouseCoords( ::OnClick, "CLICK" )
                           ::NestedClick := .F.
                        ENDIF
                     ENDIF
                  ENDIF
               ELSE
                  IF HB_IsBlock( ::OnRClick )
                     IF ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                        ::DoEventMouseCoords( ::OnRClick, "RCLICK" )
                     ENDIF
                  ENDIF
               ENDIF

               IF ::nDelayedClick[ 3 ] > 0
                  // change check mark
                  ::CheckItem( ::nDelayedClick[ 3 ], ! ::CheckItem( ::nDelayedClick[ 3 ] ) )
               ENDIF

               // fire context menu
               IF ! HB_IsNil( ::nDelayedClick[ 4 ] ) .AND. ::ContextMenu != Nil .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0 )
                  ::ContextMenu:Cargo := ::nDelayedClick[ 4 ]
                  ::ContextMenu:Activate()
               ENDIF
            ELSEIF lRowAppended
               // A new row was added and partially edited: set as new value and refresh the control
               ::SetValue( aTail( ::aRecMap ), nRow )
            ELSE
               // The user aborted the edition of an existing row: refresh the control without changing it's value
            ENDIF
            IF lRefresh
               ::Refresh()
            ENDIF
            EXIT
         ENDIF
      ENDIF

      nCol := ::NextColInOrder( nCol )
   ENDDO

   ::ScrollToLeft()

   RETURN lSomethingEdited

METHOD EditGrid( nRow, nCol, lAppend, lOneRow, lChange, lRefresh ) CLASS TOBrowse

   LOCAL lRet := .T., lRowEdited, lSomethingEdited, nRecNo, lRowAppended, nNewRec, nNextRec, cWorkArea

   IF ::FirstVisibleColumn == 0

      RETURN .F.
   ENDIF
   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   IF ! HB_IsNumeric( nCol )
      IF ::lAppendMode .OR. lAppend .OR. ::lAtFirstCol
         nCol := ::FirstColInOrder
      ELSE
         nCol := ::FirstVisibleColumn
      ENDIF
   ENDIF
   IF nCol < 1 .OR. nCol > Len( ::aHeaders )

      RETURN .F.
   ENDIF

   cWorkArea := ::WorkArea

   IF lAppend
      IF ::lAppendMode

         RETURN .F.
      ENDIF
      ::lAppendMode := .T.
      ::GoBottom( .T. )
      ::InsertBlank( ::ItemCount + 1 )
      nRow := ::CurrentRow := ::ItemCount
   ELSE
      IF ! HB_IsNumeric( nRow )
         nRow := Max( ::CurrentRow, 1 )
      ENDIF
      IF nRow < 1 .OR. nRow > ::ItemCount

         RETURN .F.
      ENDIF
      ASSIGN lChange VALUE lChange TYPE "L" DEFAULT ::lChangeBeforeEdit
      IF lChange
         ::Value := ::aRecMap[ nRow ]
      ENDIF
   ENDIF

   lSomethingEdited := .F.

   ASSIGN lRefresh VALUE lRefresh TYPE "L" DEFAULT ( ::RefreshType == REFRESH_FORCE )

   DO WHILE .t.
      lRowEdited := .F.
      lRowAppended := .F.

      DO WHILE nCol >= 1 .AND. nCol <= Len( ::aHeaders ) .AND. Select( cWorkArea ) # 0
         nRecNo := ( cWorkArea )->( RecNo() )
         IF lAppend
            ::DbGoTo( 0 )
         ELSE
            ::DbGoTo( ::aRecMap[ nRow ] )
            IF nRow == ::ItemCount
               ::DbSkip()
               IF ::Eof()
                  nNextRec := 0
               ELSE
                  nNextRec := ( cWorkArea )->( RecNo() )
               ENDIF
               ::DbGoTo( ::aRecMap[ nRow ] )
            ENDIF
         ENDIF

         _OOHG_ThisItemCellValue := ::Cell( nRow, nCol )

         IF ::IsColumnReadOnly( nCol, nRow )
            // Read only column, skip
         ELSEIF ! ::IsColumnWhen( nCol, nRow )
            // WHEN returned .F., skip
         ELSEIF aScan( ::aHiddenCols, nCol, nRow ) > 0
            // Hidden column, skip
         ELSE
            ::DbGoTo( nRecNo )

            ::lCalledFromClass := .T.
            lRet := ::EditCell( nRow, nCol, , , , , lAppend, , .F., .F. )
            ::lCalledFromClass := .F.

            IF ! lRet
               EXIT
            ENDIF

            lRowEdited := .T.
            lSomethingEdited := .T.
            IF lAppend
               lRowAppended := .T.
               lAppend := .F.
            ENDIF
         ENDIF

         IF ::bPosition == 9                     // MOUSE EXIT
            EXIT
         ENDIF

         nCol := ::NextColInOrder( nCol )
      ENDDO

      // See what to do next
      IF Select( cWorkArea ) == 0
         ::RecCount := 0
         EXIT
      ELSEIF ! lRet
         // The last column was not edited
         IF lRowAppended
            // A new row was added and partially edited: set as new value and refresh the control
            ::SetValue( aTail( ::aRecMap ), nRow )
            ::Refresh()
         ELSEIF lAppend
            // The user aborted the append of a new row in the first column: refresh and set last record as new value
            ::GoBottom()
         ELSEIF lSomethingEdited
            // The user aborted the edition of an existing row: refresh the control without changing it's value
            ::Refresh()  // TODO: RefreshType
         ENDIF
         EXIT
      ELSEIF ::bPosition == 9
         // Editing window lost focus
         ::bPosition := 0                   // This restores the processing of click messages
         IF ::nDelayedClick[ 1 ] > 0
            // A click message was delayed
            IF ::nDelayedClick[ 3 ] <= 0
               ::SetValue( ::aRecMap[ ::nDelayedClick[ 1 ] ], ::nDelayedClick[ 1 ] )
            ENDIF

            IF HB_IsNil( ::nDelayedClick[ 4 ] )
               IF HB_IsBlock( ::OnClick )
                  IF ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                     IF ! ::NestedClick
                        ::NestedClick := ! _OOHG_NestedSameEvent()
                        ::DoEventMouseCoords( ::OnClick, "CLICK" )
                        ::NestedClick := .F.
                     ENDIF
                  ENDIF
               ENDIF
            ELSE
               IF HB_IsBlock( ::OnRClick )
                  IF ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                     ::DoEventMouseCoords( ::OnRClick, "RCLICK" )
                  ENDIF
               ENDIF
            ENDIF

            IF ::nDelayedClick[ 3 ] > 0
               // change check mark
               ::CheckItem( ::nDelayedClick[ 3 ], ! ::CheckItem( ::nDelayedClick[ 3 ] ) )
            ENDIF

            // fire context menu
            IF ! HB_IsNil( ::nDelayedClick[ 4 ] ) .AND. ::ContextMenu != Nil .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0 )
               ::ContextMenu:Cargo := ::nDelayedClick[ 4 ]
               ::ContextMenu:Activate()
            ENDIF
         ELSEIF lRowAppended
            // A new row was added and partially edited: set as new value and refresh the control
            ::SetValue( aTail( ::aRecMap ), nRow )
         ELSE
            // The user aborted the edition of an existing row: refresh the control without changing it's value
         ENDIF
         IF lRefresh
            ::Refresh()
         ENDIF
         EXIT
      ELSEIF ( HB_IsLogical( lOneRow ) .AND. lOneRow ) .OR. ( ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove ) .OR. ( lRowAppended .AND. ! ::AllowAppend )
         // Stop if it's not fullmove or
         // If caller wants to edit only one row or
         // if, after appending a new row, appends are not allowed anymore
         IF lRowAppended
            // A new row was added and fully edited: set as new value and refresh the control
            ::SetValue( aTail( ::aRecMap ), nRow )
            ::Refresh()
         ELSEIF lRowEdited
            // An existing row was fully edited: refresh the control without changing it's value
            ::Refresh()
         ENDIF
         EXIT
      ELSEIF lRowAppended
         // A row was appended: refresh and/or add a new one
         IF lRefresh
            ::GoBottom( .T. )
         ELSE
            DO WHILE ::ItemCount >= ::CountPerPage
               ::DeleteItem( 1 )
               _OOHG_DeleteArrayItem( ::aRecMap, 1 )
            ENDDO
         ENDIF
         ::InsertBlank( ::ItemCount + 1 )
         nRow := ::CurrentRow := ::ItemCount
         lAppend := .T.
         ::lAppendMode := .T.
      ELSEIF nRow < ::ItemCount
         // Edit next row
         IF lRowEdited .AND. lRefresh
            nRecNo := ( cWorkArea )->( RecNo() )
            nNewRec := ::aRecMap[ nRow + 1 ]
            ::DbGoTo( nNewRec )
            ::Update( nRow + 1 )
            ::ScrollUpdate()
            ::DbGoTo( nRecNo )
            nRow := aScan( ::aRecMap, nNewRec )
            ::CurrentRow := nRow
         ELSE
            nRow ++
            ::FastUpdate( 1, nRow )
         ENDIF
         ::BrowseOnChange()
      ELSEIF nRow < ::CountPerPage
         IF ::AllowAppend
            // Next visible row is blank, append new record
            IF lRefresh
               ::GoBottom( .T. )
            ENDIF
            ::InsertBlank( ::ItemCount + 1 )
            nRow := ::CurrentRow := ::ItemCount
            lAppend := .T.
            ::lAppendMode := .T.
         ELSE
            IF lRowEdited
               // An existing row was fully edited: refresh the control without changing it's value
               ::Refresh()
            ENDIF
            EXIT
         ENDIF
      ELSE
         // The last visible row was fully edited
         IF nNextRec # 0
            // Find next record
            nRecNo := ( cWorkArea )->( RecNo() )
            ::DbGoTo( nNextRec )
            ::DbSkip()
            ::DbSkip(-1)
            IF ( cWorkArea )->( RecNo() ) # nNextRec
               ::DbGoTo( nNextRec )
               ::DbSkip()
               IF ::Eof()
                  nNextRec := 0
               ELSE
                  nNextRec := ( cWorkArea )->( RecNo() )
               ENDIF
            ENDIF
            ::DbGoTo( nRecNo )
         ENDIF
         IF nNextRec == 0
            // No more records
            IF ::AllowAppend
               // Add new row
               IF lRefresh
                  ::GoBottom( .T. )
               ELSE
                  DO WHILE ::ItemCount >= ::CountPerPage
                     ::DeleteItem( 1 )
                     _OOHG_DeleteArrayItem( ::aRecMap, 1 )
                  ENDDO
               ENDIF
               ::InsertBlank( ::ItemCount + 1 )
               nRow := ::CurrentRow := ::ItemCount
               lAppend := .T.
               ::lAppendMode := .T.
            ELSE
               // Stop
               EXIT
            ENDIF
         ELSE
            // Edit next record
            nRecNo := ( cWorkArea )->( RecNo() )
            ::DbGoTo( nNextRec )
            IF lRefresh
               ::Update( nRow )
               ::ScrollUpdate()
            ELSE
               DO WHILE ::ItemCount >= ::CountPerPage
                  ::DeleteItem( 1 )
                  _OOHG_DeleteArrayItem( ::aRecMap, 1 )
               ENDDO
               aAdd( ::aRecMap, nNextRec )
               ::RefreshRow( nRow )
               ::CurrentRow := nRow
            ENDIF
            ::DbGoTo( nRecNo )
            ::BrowseOnChange()
         ENDIF
      ENDIF
      nCol := ::FirstColInOrder
   ENDDO

   ::ScrollToLeft()

   RETURN lSomethingEdited

METHOD BrowseOnChange() CLASS TOBrowse

   LOCAL cWorkArea, lSync

   IF ::lUpdCols
      ::UpdateColors()
   ENDIF

   IF HB_IsLogical( ::SyncStatus )
      lSync := ::SyncStatus
   ELSE
      lSync := _OOHG_BrowseSyncStatus
   ENDIF

   IF lSync
      cWorkArea := ::WorkArea
      IF Select( cWorkArea ) != 0 .AND. ( cWorkArea )->( RecNo() ) != ::Value
         ::DbGoTo( ::Value )
      ENDIF
   ENDIF

   ::DoChange()

   RETURN Self

METHOD DoChange() CLASS TOBrowse

   ::nRecLastValue := ::Value
   ::TGrid:DoChange()

   RETURN Self

METHOD FastUpdate( d, nRow ) CLASS TOBrowse

   LOCAL ActualRecord, RecordCount

   // If vertical scrollbar is used it must be updated
   IF ::lVScrollVisible
      RecordCount := ::RecCount

      IF RecordCount == 0

         RETURN Self
      ENDIF

      IF RecordCount < 1000
         ActualRecord := ::VScroll:Value + d
         ::VScroll:Value := ActualRecord
      ENDIF
   ENDIF

   IF nRow < 1 .OR. nRow > Len( ::aRecMap )
      ::nRecLastValue := 0
      ::CurrentRow := 0
   ELSE
      ::nRecLastValue := ::aRecMap[ nRow ]
      ::CurrentRow := nRow
   ENDIF

   RETURN Self

METHOD ScrollUpdate() CLASS TOBrowse

   LOCAL ActualRecord, RecordCount, cWorkArea

   // If vertical scrollbar is used it must be updated
   IF ::lVScrollVisible
      cWorkArea := ::WorkArea
      IF Select( cWorkArea ) == 0
         ::RecCount := 0

         RETURN Self
      ENDIF
      RecordCount := ( cWorkArea )->( OrdKeyCount() )
      IF RecordCount > 0
         ActualRecord := ( cWorkArea )->( OrdKeyNo() )
      ELSE
         ActualRecord := ( cWorkArea )->( RecNo() )
         RecordCount := ( cWorkArea )->( RecCount() )
      ENDIF
      IF ::lRecCount
         RecordCount := ( cWorkArea )->( RecCount() )
      ENDIF

      ::RecCount := RecordCount

      IF ::lDescending
         ActualRecord := RecordCount - ActualRecord + 1
      ENDIF

      IF RecordCount < 1000
         ::VScroll:RangeMax := RecordCount
         ::VScroll:Value := ActualRecord
      ELSE
         ::VScroll:RangeMax := 1000
         ::VScroll:Value := INT( ActualRecord * 1000 / RecordCount )
      ENDIF
   ENDIF

   RETURN Self

METHOD CurrentRow( nValue ) CLASS TOBrowse

   IF ValType( nValue ) == "N"
      IF nValue < 1 .OR. nValue > ::ItemCount
         IF ::CurrentRow # 0
            ListView_ClearCursel( ::hWnd, 0 )
         ENDIF
      ELSE
         ListView_SetCursel( ::hWnd, nValue )
      ENDIF
      ::nRowPos := ::FirstSelectedItem
   ENDIF

   RETURN ::FirstSelectedItem

METHOD Refresh() CLASS TOBrowse

   LOCAL s, _RecNo, v, cWorkArea

   cWorkArea := ::WorkArea
   IF Select( cWorkArea ) == 0
      ::DeleteAllItems()

      RETURN Self
   ENDIF

   v := ::nRecLastValue

   s := ::CurrentRow

   _RecNo := ( cWorkArea )->( RecNo() )

   IF v <= 0
      v := _RecNo
   ENDIF

   ::DbGoTo( v )

   IF s <= 1
      ::DbSkip()
      ::DbSkip( -1 )
      IF ( cWorkArea )->( RecNo() ) != v
         ::DbSkip()
      ENDIF
   ENDIF

   IF s == 0
      IF ( cWorkArea )->( IndexOrd() ) != 0
         IF ( cWorkArea )->( OrdKeyVal() ) == Nil
            ::TopBottom( GO_TOP )
         ENDIF
      ENDIF

      IF Set( _SET_DELETED )
         IF ( cWorkArea )->( Deleted() )
            ::TopBottom( GO_TOP )
         ENDIF
      ENDIF
   ENDIF

   IF ::Eof()
      ::DeleteAllItems()
      ::DbGoTo( _RecNo )

      RETURN Self
   ENDIF

   ::ScrollUpdate()

   IF s != 0
      ::DbSkip( - s + 1 )
   ENDIF

   ::Update()

   ::CurrentRow := aScan( ::aRecMap, v )
   ::nRecLastValue := v

   ::DbGoTo( _RecNo )

   RETURN Self

METHOD Value( uValue ) CLASS TOBrowse

   LOCAL nItem

   IF ValType( uValue ) == "N"
      ::SetValue( uValue )
   ENDIF
   IF Select( ::WorkArea ) == 0
      ::RecCount := 0
      uValue := 0
   ELSE
      nItem := ::CurrentRow
      IF nItem > 0 .AND. nItem <= Len( ::aRecMap )
         uValue := ::aRecMap[ nItem ]
      ELSE
         uValue := 0
      ENDIF
   ENDIF

   RETURN uValue

METHOD RefreshData() CLASS TOBrowse

   ::Refresh()

   RETURN ::TGrid:RefreshData()

METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TOBrowse

   LOCAL cWorkArea, _RecNo, nRow, uGridValue, aCellData, aPos

   IF nMsg == WM_CHAR
      IF wParam < 32
         ::cText := ""

         RETURN 0
      ELSEIF Empty( ::cText )
         ::uIniTime := HB_MilliSeconds()
         ::cText := Upper( Chr( wParam ) )
      ELSEIF HB_MilliSeconds() > ::uIniTime + ::SearchLapse
         ::uIniTime := HB_MilliSeconds()
         ::cText := Upper( Chr( wParam ) )
      ELSE
         ::uIniTime := HB_MilliSeconds()
         ::cText += Upper( Chr( wParam ) )
      ENDIF

      IF ::SearchCol < 1 .OR. ::SearchCol > ::ColumnCount

         RETURN 0
      ENDIF

      cWorkArea := ::WorkArea
      IF Select( cWorkArea ) == 0

         RETURN 0
      ENDIF

      _RecNo := ( cWorkArea )->( RecNo() )

      nRow := ::Value
      IF nRow == 0
         IF Len( ::aRecMap ) == 0
            ::TopBottom( GO_TOP )
         ELSE
            ::DbGoTo( ::aRecMap[ 1 ] )
         ENDIF

         IF ::Eof()
            ::DbGoTo( _RecNo )

            RETURN 0
         ENDIF

         nRow := ( cWorkArea )->( RecNo() )
      ENDIF
      ::DbGoTo( nRow )
      ::DbSkip()

      DO WHILE ! ::Eof()
         IF ::FixBlocks()
            uGridValue := Eval( ::aColumnBlocks[ ::SearchCol ], cWorkArea )
         ELSE
            uGridValue := Eval( ::ColumnBlock( ::SearchCol ), cWorkArea )
         ENDIF
         IF ValType( uGridValue ) == "A"      // TGridControlImageData
            uGridValue := uGridValue[ 1 ]
         ENDIF

         IF Upper( Left( uGridValue, Len( ::cText ) ) ) == ::cText
            EXIT
         ENDIF

         ::DbSkip()
      ENDDO

      IF ::Eof() .AND. ::SearchWrap
         ::TopBottom( GO_TOP )
         DO WHILE ! ::Eof() .AND. ( cWorkArea )->( RecNo() ) != nRow
            IF ::FixBlocks()
               uGridValue := Eval( ::aColumnBlocks[ ::SearchCol ], cWorkArea )
            ELSE
               uGridValue := Eval( ::ColumnBlock( ::SearchCol ), cWorkArea )
            ENDIF
            IF ValType( uGridValue ) == "A"      // TGridControlImageData
               uGridValue := uGridValue[ 1 ]
            ENDIF

            IF Upper( Left( uGridValue, Len( ::cText ) ) ) == ::cText
               EXIT
            ENDIF

            ::DbSkip()
         ENDDO
      ENDIF

      IF ! ::Eof()
         ::nRow := ( cWorkArea )->( RecNo() )
      ENDIF

      ::DbGoTo( _RecNo )

      RETURN 0

   ELSEIF nMsg == WM_KEYDOWN
      DO CASE
      CASE Select( ::WorkArea ) == 0
         // No database open
      CASE wParam == VK_HOME
         ::Home()

         RETURN 0
      CASE wParam == VK_END
         ::End()

         RETURN 0
      CASE wParam == VK_PRIOR
         ::PageUp()

         RETURN 0
      CASE wParam == VK_NEXT
         ::PageDown()

         RETURN 0
      CASE wParam == VK_UP
         ::Up()

         RETURN 0
      CASE wParam == VK_DOWN
         ::Down()

         RETURN 0
      ENDCASE

   ELSEIF nMsg == WM_LBUTTONDBLCLK
      _PushEventInfo()
      _OOHG_ThisForm := ::Parent
      _OOHG_ThisType := 'C'
      _OOHG_ThisControl := Self

      // Identify item & subitem hitted
      aPos := Get_XY_LPARAM( lParam )
      aPos := ListView_HitTest( ::hWnd, aPos[ 1 ], aPos[ 2 ] )

      aCellData := _GetGridCellData( Self, aPos )
      _OOHG_ThisItemRowIndex   := aCellData[ 1 ]
      _OOHG_ThisItemColIndex   := aCellData[ 2 ]
      _OOHG_ThisItemCellRow    := aCellData[ 3 ]
      _OOHG_ThisItemCellCol    := aCellData[ 4 ]
      _OOHG_ThisItemCellWidth  := aCellData[ 5 ]
      _OOHG_ThisItemCellHeight := aCellData[ 6 ]
      _OOHG_ThisItemCellValue  := ::Cell( _OOHG_ThisItemRowIndex, _OOHG_ThisItemColIndex )

      IF ! ::AllowEdit .OR. _OOHG_ThisItemRowIndex < 1 .OR. _OOHG_ThisItemRowIndex > ::ItemCount .OR. _OOHG_ThisItemColIndex < 1 .OR. _OOHG_ThisItemColIndex > Len( ::aHeaders )
         IF HB_IsBlock( ::OnDblClick )
            ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
         ENDIF
      ELSEIF ::IsColumnReadOnly( _OOHG_ThisItemColIndex, _OOHG_ThisItemRowIndex )
         // Cell is readonly
         IF ::lExtendDblClick .and. HB_IsBlock( ::OnDblClick )
            ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
         ENDIF
      ELSEIF ! ::IsColumnWhen( _OOHG_ThisItemColIndex, _OOHG_ThisItemRowIndex )
         // Not a valid WHEN
         IF ::lExtendDblClick .and. HB_IsBlock( ::OnDblClick )
            ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
         ENDIF
      ELSEIF aScan( ::aHiddenCols, _OOHG_ThisItemColIndex ) > 0
         // Cell is in a hidden column
         IF ::lExtendDblClick .and. HB_IsBlock( ::OnDblClick )
            ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
         ENDIF
      ELSEIF ::FullMove
         ::EditGrid( _OOHG_ThisItemRowIndex, _OOHG_ThisItemColIndex )
      ELSE
         ::EditCell( _OOHG_ThisItemRowIndex, _OOHG_ThisItemColIndex, , , , , .F. )
      ENDIF

      _ClearThisCellInfo()
      _PopEventInfo()

      RETURN 0

   ELSEIF nMsg == WM_MOUSEWHEEL
      IF GET_WHEEL_DELTA_WPARAM( wParam ) > 0
         ::Up()
      ELSE
         ::Down()
      ENDIF

      RETURN 0

   ENDIF

   RETURN ::Super:Events( hWnd, nMsg, wParam, lParam )

METHOD Events_Notify( wParam, lParam ) CLASS TOBrowse

   LOCAL nvKey, r, DeltaSelect, lGo, uValue, nNotify := GetNotifyCode( lParam )

   IF nNotify == NM_CLICK
      IF ::lCheckBoxes
         // detect item
         uValue := ListView_HitOnCheckBox( ::hWnd, GetCursorRow() - GetWindowRow( ::hWnd ), GetCursorCol() - GetWindowCol( ::hWnd ) )
      ELSE
         uValue := 0
      ENDIF

      IF ::bPosition == -2 .OR. ::bPosition == 9
         ::nDelayedClick := { ::CurrentRow, 0, uValue, Nil }
         ::CurrentRow := ::nEditRow
      ELSE
         IF HB_IsBlock( ::OnClick )
            IF ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. uValue <= 0
               IF ! ::NestedClick
                  ::NestedClick := ! _OOHG_NestedSameEvent()
                  ::DoEventMouseCoords( ::OnClick, "CLICK" )
                  ::NestedClick := .F.
               ENDIF
            ENDIF
         ENDIF

         IF uValue > 0
            // change check mark
            ::CheckItem( uValue, ! ::CheckItem( uValue ) )
         ELSE
            // select item
            r := ::CurrentRow
            IF r > 0
               DeltaSelect := r - ::nRowPos
               ::FastUpdate( DeltaSelect, r )
               ::BrowseOnChange()
            ELSEIF ::lNoneUnsels
               ::CurrentRow := 0
               ::BrowseOnChange()
            ELSE
               ::CurrentRow := ::nRowPos
            ENDIF
         ENDIF
      ENDIF

      // skip default action

      RETURN 1

   ELSEIF nNotify == NM_RCLICK
      IF ::lCheckBoxes
         // detect item
         uValue := ListView_HitOnCheckBox( ::hWnd, GetCursorRow() - GetWindowRow( ::hWnd ), GetCursorCol() - GetWindowCol( ::hWnd ) )
      ELSE
         uValue := 0
      ENDIF

      IF ::bPosition == -2 .OR. ::bPosition == 9
         ::nDelayedClick := { ::CurrentRow, 0, uValue, _GetGridCellData( Self, ListView_ItemActivate( lParam ) ) }
         ::CurrentRow := ::nEditRow
      ELSE
         IF HB_IsBlock( ::OnRClick )
            IF ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. uValue <= 0
               ::DoEventMouseCoords( ::OnRClick, "RCLICK" )
            ENDIF
         ENDIF

         IF uValue > 0
            // change check mark
            ::CheckItem( uValue, ! ::CheckItem( uValue ) )
         ELSE
            // select item
            r := ::CurrentRow
            IF r > 0
               DeltaSelect := r - ::nRowPos
               ::FastUpdate( DeltaSelect, r )
               ::BrowseOnChange()
            ELSEIF ::lNoneUnsels
               ::CurrentRow := 0
               ::BrowseOnChange()
            ELSE
               ::CurrentRow := ::nRowPos
            ENDIF
         ENDIF

         // fire context menu
         IF ::ContextMenu != Nil .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. uValue <= 0 )
            ::ContextMenu:Cargo := _GetGridCellData( Self, ListView_ItemActivate( lParam ) )
            ::ContextMenu:Activate()
         ENDIF
      ENDIF

      // skip default action

      RETURN 1

   ELSEIF nNotify == LVN_BEGINDRAG
      IF ::bPosition == -2 .OR. ::bPosition == 9
         ::nDelayedClick := { ::CurrentRow, 0, 0, Nil }
         ::CurrentRow := ::nEditRow
      ELSE
         r := ::CurrentRow
         IF r > 0
            DeltaSelect := r - ::nRowPos
            ::FastUpdate( DeltaSelect, r )
            ::BrowseOnChange()
         ELSEIF ::lNoneUnsels
            ::CurrentRow := 0
            ::BrowseOnChange()
         ELSE
            ::CurrentRow := ::nRowPos
         ENDIF
      ENDIF

      RETURN NIL

   ELSEIF nNotify == LVN_KEYDOWN
      IF GetGridvKeyAsChar( lParam ) == 0
         ::cText := ""
      ENDIF

      nvKey := GetGridvKey( lParam )

      DO CASE
      CASE Select( ::WorkArea ) == 0
         // No database open
      CASE nvKey == VK_A .AND. GetKeyFlagState() == MOD_ALT
         IF ::lAppendOnAltA
            ::AppendItem()
         ENDIF
      CASE nvKey == VK_DELETE
         IF ::AllowDelete .AND. ! ::Eof()
            IF HB_IsBlock( ::bDelWhen )
               lGo := Eval( ::bDelWhen )
            ELSE
               lGo := .T.
            ENDIF

            IF lGo
               IF ::lNoDelMsg
                  ::Delete()
               ELSEIF MsgYesNo( _OOHG_Messages(4, 1), _OOHG_Messages(4, 2) )
                  ::Delete()
               ENDIF
            ELSEIF ! Empty( ::DelMsg )
               MsgExclamation( ::DelMsg, _OOHG_Messages(4, 2) )
            ENDIF
         ENDIF
      ENDCASE

      RETURN NIL

   ELSEIF nNotify == LVN_ITEMCHANGED
      IF GetGridOldState( lParam ) == 0 .and. GetGridNewState( lParam ) != 0

         RETURN NIL
      ENDIF

   ELSEIF nNotify == NM_CUSTOMDRAW
      ::AdjustRightScroll()

      RETURN TGrid_Notify_CustomDraw( Self, lParam, .F., , , .F., ::lFocusRect, ::lNoGrid, ::lPLM )

   ENDIF

   RETURN ::Super:Events_Notify( wParam, lParam )

METHOD SetScrollPos( nPos, VScroll ) CLASS TOBrowse

   LOCAL BackRec, cWorkArea := ::WorkArea

   IF Select( cWorkArea ) == 0
      // Not workarea selected
   ELSEIF nPos <= VScroll:RangeMin
      ::GoTop()
   ELSEIF nPos >= VScroll:RangeMax
      ::GoBottom()
   ELSE
      BackRec := ( cWorkArea )->( RecNo() )
      ::Super:SetScrollPos( nPos, VScroll )
      ::Value := ( cWorkArea )->( RecNo() )
      ::DbGoTo( BackRec )
      ::BrowseOnChange()
   ENDIF

   RETURN Self

CLASS TOBrowseByCell FROM TOBrowse

   DATA Type                      INIT "BROWSEBYCELL" READONLY

   METHOD AddColumn
   METHOD BrowseOnChange
   METHOD CurrentCol              SETGET
   METHOD Define3
   METHOD Delete
   METHOD DeleteAllItems
   METHOD DeleteColumn
   METHOD DoChange
   METHOD Down
   METHOD EditAllCells
   METHOD EditCell
   METHOD EditCell2
   METHOD EditGrid
   METHOD EditItem_B
   METHOD End
   METHOD Events
   METHOD Events_Notify
   METHOD GoBottom
   METHOD GoTop
   METHOD Home
   METHOD Left
   METHOD MoveToFirstCol
   METHOD MoveToFirstVisibleCol
   METHOD MoveToLastCol
   METHOD MoveToLastVisibleCol
   METHOD PageDown
   METHOD PageUp
   METHOD Right
   METHOD SetScrollPos
   METHOD SetSelectedColors
   METHOD SetValue
   METHOD Up
   METHOD Value                   SETGET

   /*
   Available methods from TOBrowse:
   DbGoTo
   DbSkip
   Define
   FastUpdate
   Refresh
   RefreshData
   ScrollUpdate
   TopBottom
   UpDate
   UpdateColors

   Available methods from TXBrowse:
   AdjustRightScroll
   AppendItem
   ColumnAutoFit
   ColumnAutoFitH
   ColumnBlock
   ColumnsAutoFit
   ColumnsAutoFitH
   ColumnWidth
   CurrentRow
   Define4
   EditItem
   Enabled
   FixBlocks
   GetCellType
   HelpId
   RefreshRow
   SetColumn
   SizePos
   ToExcel
   ToolTip
   ToOpenOffice
   Visible
   VScrollVisible
   WorkArea

   Available methods from TGrid:
   AddBitMap
   AdjustResize
   Append
   BackColor
   Cell
   CellCaption
   CellImage
   ColumnBetterAutoFit
   ColumnCount
   ColumnHide
   ColumnOrder
   ColumnsBetterAutoFit
   ColumnShow
   CompareItems
   CountPerPage
   Define2
   DeleteItem
   EditItem2
   Events_Enter
   FirstColInOrder
   FirstSelectedItem
   FirstVisibleColumn
   FirstVisibleItem
   FixControls
   FontColor
   Header
   HeaderHeight
   HeaderImage
   HeaderImageAlign
   HeaderSetFont
   InsertBlank
   IsColumnReadOnly
   IsColumnWhen
   Item
   ItemCount
   ItemHeight
   Justify
   LastColInOrder
   LastVisibleColumn
   LoadHeaderImages
   NextColInOrder
   OnEnter
   PanToLeft
   PanToRight
   PriorColInOrder
   Release
   ScrollToCol
   ScrollToLeft
   ScrollToNext
   ScrollToPrior
   ScrollToRight
   SetItemColor
   SetRangeColor
   */

   ENDCLASS

METHOD Define3( ControlName, ParentForm, x, y, w, h, fontname, fontsize, ;
      tooltip, aHeadClick, nogrid, aImage, break, HelpId, bold, ;
      italic, underline, strikeout, edit, backcolor, fontcolor, ;
      dynamicbackcolor, dynamicforecolor, aPicture, lRtl, InPlace, ;
      editcontrols, readonly, valid, validmessages, aWhenFields, ;
      lDisabled, lNoTabStop, lInvisible, lHasHeaders, aHeaderImage, ;
      aHeaderImageAlign, FullMove, aSelectedColors, aEditKeys, ;
      dblbffr, lFocusRect, lPLM, lFixedCols, lFixedWidths, ;
      lLikeExcel, lButtons, AllowDelete, DelMsg, lNoDelMsg, ;
      AllowAppend, lNoModal, lFixedCtrls, lExtDbl, Value, lSilent, ;
      lAltA, lNoShowAlways, lNone, lCBE, lCheckBoxes, lAtFirst, klc ) CLASS TOBrowseByCell

   LOCAL nAux

   HB_SYMBOL_UNUSED( InPlace )          // Forced to .T., it's needed for edit controls to work properly
   HB_SYMBOL_UNUSED( lNone )

   ASSIGN lFocusRect VALUE lFocusRect TYPE "L" DEFAULT .F.
   ASSIGN lCBE       VALUE lCBE       TYPE "L" DEFAULT .T.

   ::Define2( ControlName, ParentForm, x, y, w, h, ::aHeaders, ::aWidths, {}, ;
      , fontname, fontsize, tooltip, aHeadClick, nogrid, ;
      aImage, ::aJust, break, HelpId, bold, italic, underline, ;
      strikeout, , , edit, backcolor, ;
      fontcolor, dynamicbackcolor, dynamicforecolor, aPicture, lRtl, ;
      LVS_SINGLESEL, .T., editcontrols, readonly, valid, validmessages, ;
      aWhenFields, lDisabled, lNoTabStop, lInvisible, lHasHeaders, ;
      aHeaderImage, aHeaderImageAlign, FullMove, aSelectedColors, ;
      aEditKeys, lCheckBoxes, dblbffr, lFocusRect, lPLM, ;
      lFixedCols, lFixedWidths, lLikeExcel, lButtons, AllowDelete, ;
      DelMsg, lNoDelMsg, AllowAppend, lNoModal, lFixedCtrls, ;
      , , lExtDbl, lSilent, lAltA, ;
      lNoShowAlways, .T., lCBE, lAtFirst, klc )

   // By default, search in the current column
   ::SearchCol := -1

   IF HB_IsArray( Value ) .AND. Len( Value ) > 1
      nAux := Value[ 1 ]
      IF HB_IsNumeric( nAux ) .AND. nAux >= 0
         ::nRecLastValue := nAux
      ENDIF
      nAux := Value[ 2 ]
      IF HB_IsNumeric( nAux ) .AND. nAux >= 0 .AND. nAux <= Len( ::aHeaders )
         ::nColPos := nAux
      ENDIF
   ENDIF

   RETURN Self

METHOD AddColumn( nColIndex, xField, cHeader, nWidth, nJustify, uForeColor, ;
      uBackColor, lNoDelete, uPicture, uEditControl, uHeadClick, ;
      uValid, uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign, ;
      uReplaceField, lRefresh, uReadOnly, uDefault ) CLASS TOBrowseByCell

   nColIndex := ::Super:AddColumn( nColIndex, xField, cHeader, nWidth, nJustify, uForeColor, ;
      uBackColor, lNoDelete, uPicture, uEditControl, uHeadClick, ;
      uValid, uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign, ;
      uReplaceField, lRefresh, uReadOnly, uDefault )

   IF nColIndex <= ::nColPos
      ::CurrentCol := ::nColPos + 1
      ::DoChange()
   ENDIF

   RETURN nColIndex

METHOD DeleteAllItems() CLASS TOBrowseByCell

   ::nRowPos := 0
   ::nColPos := 0

   RETURN ::Super:DeleteAllItems()

METHOD DeleteColumn( nColIndex, lNoDelete ) CLASS TOBrowseByCell

   nColIndex := ::Super:DeleteColumn( nColIndex, lNoDelete )
   IF nColIndex > 0
      IF nColIndex == ::nColPos
         ::CurrentCol := ::FirstColInOrder
         ::DoChange()
      ELSEIF nColIndex < ::nColPos
         ::CurrentCol := ::nColPos - 1
         ::DoChange()
      ENDIF
   ENDIF

   RETURN nColIndex

METHOD SetSelectedColors( aSelectedColors, lRedraw ) CLASS TOBrowseByCell

   LOCAL i, aColors[ 8 ]

   IF HB_IsArray( aSelectedColors )
      aSelectedColors := AClone( aSelectedColors )
      ASize( aSelectedColors, 8 )

      // For text of selected cell when grid has the focus
      IF ! ValType( aSelectedColors[ 1 ] ) $ "ANB"
         aSelectedColors[ 1 ] := GetSysColor( COLOR_HIGHLIGHTTEXT )
      ENDIF
      // For background of selected cell when grid has the focus
      IF ! ValType( aSelectedColors[ 2 ] ) $ "ANB"
         aSelectedColors[ 2 ] := GetSysColor( COLOR_HIGHLIGHT )
      ENDIF
      // For text of selected cell when grid doesn't has the focus
      IF ! ValType( aSelectedColors[ 3 ] ) $ "ANB"
         aSelectedColors[ 3 ] := GetSysColor( COLOR_WINDOWTEXT )
      ENDIF
      // For background of selected cell when grid doesn't has the focus
      IF ! ValType( aSelectedColors[ 4 ] ) $ "ANB"
         aSelectedColors[ 4 ] := GetSysColor( COLOR_3DFACE )
      ENDIF

      // For text of other cells in the selected row when grid has the focus
      IF ! ValType( aSelectedColors[ 5 ] ) $ "ANB"
         aSelectedColors[ 5 ] := -1                    // defaults to DYNAMICFORECOLOR, or FONTCOLOR or COLOR_WINDOWTEXT
      ENDIF
      // For background of other cells in the selected row when grid has the focus
      IF ! ValType( aSelectedColors[ 6 ] ) $ "ANB"
         aSelectedColors[ 6 ] := -1                    // defaults to DYNAMICBACKCOLOR, or BACKCOLOR or COLOR_WINDOW
      ENDIF
      // For text of other cells in the selected row when grid doesn't has the focus
      IF ! ValType( aSelectedColors[ 7 ] ) $ "ANB"
         aSelectedColors[ 7 ] := -1                    // defaults to DYNAMICFORECOLOR, or FONTCOLOR or COLOR_WINDOWTEXT
      ENDIF
      // For background of other cells in the selected row when grid doesn't has the focus
      IF ! ValType( aSelectedColors[ 8 ] ) $ "ANB"
         aSelectedColors[ 8 ] := -1                    // defaults to DYNAMICBACKCOLOR, or BACKCOLOR or COLOR_WINDOW
      ENDIF

      ::aSelectedColors := aSelectedColors

      FOR i := 1 To 8
         aColors[ i ] := _OOHG_GetArrayItem( aSelectedColors, i )
      NEXT i

      ::GridSelectedColors := aColors

      IF lRedraw
         RedrawWindow( ::hWnd )
      ENDIF
   ELSE
      aSelectedColors := AClone( ::aSelectedColors )
   ENDIF

   RETURN aSelectedColors

METHOD Value( uValue ) CLASS TOBrowseByCell

   LOCAL nItem

   IF HB_IsArray( uValue ) .AND. Len( uValue ) > 1
      IF HB_IsNumeric( uValue[ 1 ] ) .AND. uValue[ 1 ] >= 0
         IF HB_IsNumeric( uValue[ 2 ] ) .AND. uValue[ 2 ] >= 0 .AND. uValue[ 2 ] <= Len( ::aHeaders )
            IF ( nItem := aScan( ::aRecMap, uValue[ 1 ] ) ) > 0
               ::SetValue( uValue, nItem )
            ELSE
               ::SetValue( uValue )
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   IF Select( ::WorkArea ) == 0
      ::RecCount := 0
      ::CurrentRow := 0
      ::nColPos := 0
      ::nRecLastValue := 0
      uValue := { 0, 0 }
   ELSEIF ::ItemCount == 0
      ::CurrentRow := 0
      ::nColPos := 0
      ::nRecLastValue := 0
      uValue := { 0, 0 }
   ELSE
      ::nRowPos := ::CurrentRow
      IF ::nRowPos > 0 .AND. ::nRowPos <= Len( ::aRecMap ) .AND. ::nColPos >= 1 .AND. ::nColPos <= Len( ::aHeaders )
         uValue := { ::aRecMap[ ::nRowPos ], ::nColPos }
      ELSE
         ::CurrentRow := 0
         ::nColPos := 0
         ::nRecLastValue := 0
         uValue := { 0, 0 }
      ENDIF
   ENDIF

   RETURN uValue

METHOD MoveToFirstCol CLASS TOBrowseByCell

   LOCAL aBefore, nCol, aAfter, lDone := .F.

   aBefore := ::Value
   nCol := ::FirstColInOrder
   IF nCol # 0
      ::Value := { aBefore[ 1 ], nCol }
      aAfter := ::Value
      lDone := ( aAfter[ 1 ] # aBefore[ 1 ] .OR. aAfter[ 2 ] # aBefore[ 2 ] )
   ENDIF

   RETURN lDone

METHOD MoveToLastCol CLASS TOBrowseByCell

   LOCAL aBefore, nCol, aAfter, lDone := .F.

   aBefore := ::Value
   nCol := ::LastColInOrder
   IF nCol # 0
      ::Value := { aBefore[ 1 ], nCol }
      aAfter := ::Value
      lDone := ( aAfter[ 1 ] # aBefore[ 1 ] .OR. aAfter[ 2 ] # aBefore[ 2 ] )
   ENDIF

   RETURN lDone

METHOD MoveToFirstVisibleCol CLASS TOBrowseByCell

   LOCAL aBefore, nCol, aAfter, lDone := .F.

   aBefore := ::Value
   ::ScrollToPrior()
   nCol := ::FirstVisibleColumn
   IF nCol # 0
      ::Value := { aBefore[ 1 ], nCol }
      aAfter := ::Value
      lDone := ( aAfter[ 1 ] # aBefore[ 1 ] .OR. aAfter[ 2 ] # aBefore[ 2 ] )
   ENDIF

   RETURN lDone

METHOD MoveToLastVisibleCol CLASS TOBrowseByCell

   LOCAL aBefore, nCol, aAfter, lDone := .F.

   aBefore := ::Value
   ::ScrollToPrior()
   nCol := ::LastVisibleColumn
   IF nCol # 0
      ::Value := { aBefore[ 1 ], nCol }
      aAfter := ::Value
      lDone := ( aAfter[ 1 ] # aBefore[ 1 ] .OR. aAfter[ 2 ] # aBefore[ 2 ] )
   ENDIF

   RETURN lDone

METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TOBrowseByCell

   LOCAL cWorkArea, _RecNo, aValue, uGridValue, nRow

   IF nMsg == WM_CHAR
      IF wParam < 32
         ::cText := ""

         RETURN 0
      ELSEIF Empty( ::cText )
         ::uIniTime := HB_MilliSeconds()
         ::cText := Upper( Chr( wParam ) )
      ELSEIF HB_MilliSeconds() > ::uIniTime + ::SearchLapse
         ::uIniTime := HB_MilliSeconds()
         ::cText := Upper( Chr( wParam ) )
      ELSE
         ::uIniTime := HB_MilliSeconds()
         ::cText += Upper( Chr( wParam ) )
      ENDIF

      IF ::SearchCol < 1 .OR. ::SearchCol > ::ColumnCount
         ::SearchCol := ::nColPos
         IF ::SearchCol < 1 .OR. ::SearchCol > ::ColumnCount

            RETURN 0
         ENDIF
      ENDIF

      cWorkArea := ::WorkArea
      IF Select( cWorkArea ) == 0

         RETURN 0
      ENDIF

      _RecNo := ( cWorkArea )->( RecNo() )

      aValue := ::Value
      nRow := aValue[ 1 ]
      IF nRow == 0
         IF Len( ::aRecMap ) == 0
            ::TopBottom( GO_TOP )
         ELSE
            ::DbGoTo( ::aRecMap[ 1 ] )
         ENDIF

         IF ::Eof()
            ::DbGoTo( _RecNo )

            RETURN 0
         ENDIF

         nRow := ( cWorkArea )->( RecNo() )
      ENDIF
      ::DbGoTo( nRow )
      ::DbSkip()

      DO WHILE ! ::Eof()
         IF ::FixBlocks()
            uGridValue := Eval( ::aColumnBlocks[ ::SearchCol ], cWorkArea )
         ELSE
            uGridValue := Eval( ::ColumnBlock( ::SearchCol ), cWorkArea )
         ENDIF
         IF ValType( uGridValue ) == "A"      // TGridControlImageData
            uGridValue := uGridValue[ 1 ]
         ENDIF

         IF Upper( Left( uGridValue, Len( ::cText ) ) ) == ::cText
            EXIT
         ENDIF

         ::DbSkip()
      ENDDO

      IF ::Eof() .AND. ::SearchWrap
         ::TopBottom( GO_TOP )
         DO WHILE ! ::Eof() .AND. ( cWorkArea )->( RecNo() ) != nRow
            IF ::FixBlocks()
               uGridValue := Eval( ::aColumnBlocks[ ::SearchCol ], cWorkArea )
            ELSE
               uGridValue := Eval( ::ColumnBlock( ::SearchCol ), cWorkArea )
            ENDIF
            IF ValType( uGridValue ) == "A"      // TGridControlImageData
               uGridValue := uGridValue[ 1 ]
            ENDIF

            IF Upper( Left( uGridValue, Len( ::cText ) ) ) == ::cText
               EXIT
            ENDIF

            ::DbSkip()
         ENDDO
      ENDIF

      IF ! ::Eof()
         ::Value := { ( cWorkArea )->( RecNo() ), ::nColPos }
      ENDIF

      ::DbGoTo( _RecNo )

      RETURN 0

   ELSEIF nMsg == WM_KEYDOWN
      DO CASE
      CASE Select( ::WorkArea ) == 0
         // No database open
      CASE wParam == VK_UP
         IF GetKeyFlagState() == MOD_CONTROL
            IF ! ::lKeysLikeClipper
               ::GoTop( ::nColPos )
            ENDIF
         ELSE
            ::Up()
         ENDIF

         RETURN 0
      CASE wParam == VK_DOWN
         IF GetKeyFlagState() == MOD_CONTROL
            IF ! ::lKeysLikeClipper
               ::GoBottom( .F., ::nColPos )
            ENDIF
         ELSE
            ::Down()
         ENDIF

         RETURN 0
      CASE wParam == VK_PRIOR
         IF ::lKeysLikeClipper .AND. GetKeyFlagState() == MOD_CONTROL
            ::GoTop()
         ELSE
            ::PageUp()
         ENDIF

         RETURN 0
      CASE wParam == VK_NEXT
         IF ::lKeysLikeClipper .AND. GetKeyFlagState() == MOD_CONTROL
            ::GoBottom()
         ELSE
            ::PageDown()
         ENDIF

         RETURN 0
      CASE wParam == VK_HOME
         IF ::lKeysLikeClipper
            IF GetKeyFlagState() == MOD_CONTROL
               ::MoveToFirstCol()
            ELSE
               ::MoveToFirstVisibleCol()
            ENDIF
         ELSE
            ::GoTop()
         ENDIF

         RETURN 0
      CASE wParam == VK_END
         IF ::lKeysLikeClipper
            IF GetKeyFlagState() == MOD_CONTROL
               ::MoveToLastCol()
            ELSE
               ::MoveToLastVisibleCol()
            ENDIF
         ELSE
            ::GoBottom()
         ENDIF

         RETURN 0
      CASE wParam == VK_LEFT
         IF GetKeyFlagState() == MOD_CONTROL
            IF ::lKeysLikeClipper
               ::PanToLeft()
            ELSE
               ::MoveToFirstCol()
            ENDIF
         ELSE
            ::Left()
         ENDIF

         RETURN 0
      CASE wParam == VK_RIGHT
         IF GetKeyFlagState() == MOD_CONTROL
            IF ::lKeysLikeClipper
               ::PanToRight()
            ELSE
               ::MoveToLastCol()
            ENDIF
         ELSE
            ::Right()
         ENDIF

         RETURN 0
      ENDCASE

   ENDIF

   RETURN ::Super:Events( hWnd, nMsg, wParam, lParam )

METHOD Events_Notify( wParam, lParam ) CLASS TOBrowseByCell

   LOCAL nvKey, r, DeltaSelect, lGo, aCellData, uValue, nNotify := GetNotifyCode( lParam )

   IF nNotify == NM_CLICK
      IF ::lCheckBoxes
         // detect item
         uValue := ListView_HitOnCheckBox( ::hWnd, GetCursorRow() - GetWindowRow( ::hWnd ), GetCursorCol() - GetWindowCol( ::hWnd ) )
      ELSE
         uValue := 0
      ENDIF

      IF ::bPosition == -2 .OR. ::bPosition == 9
         aCellData := _GetGridCellData( Self, ListView_ItemActivate( lParam ) )
         ::nDelayedClick := { aCellData[ 1 ], aCellData[ 2 ], uValue, Nil }
         ::CurrentRow := ::nEditRow
      ELSE
         IF HB_IsBlock( ::OnClick )
            IF ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. uValue <= 0
               IF ! ::NestedClick
                  ::NestedClick := ! _OOHG_NestedSameEvent()
                  ::DoEventMouseCoords( ::OnClick, "CLICK" )
                  ::NestedClick := .F.
               ENDIF
            ENDIF
         ENDIF

         IF uValue > 0
            // change check mark
            ::CheckItem( uValue, ! ::CheckItem( uValue ) )
         ELSE
            // select item
            aCellData := _GetGridCellData( Self, ListView_ItemActivate( lParam ) )
            r := aCellData[ 1 ]      // ::CurrentRow
            IF r > 0
               DeltaSelect := r - ::nRowPos
               ::FastUpdate( DeltaSelect, r )
               ::CurrentCol := aCellData[ 2 ]
               ::BrowseOnChange()
            ELSEIF ::lNoneUnsels
               ::CurrentRow := 0
               ::CurrentCol := 0
               ::BrowseOnChange()
            ELSE
               ::CurrentRow := ::nRowPos
               ::CurrentCol := ::nColPos
            ENDIF
         ENDIF
      ENDIF

      // skip default action

      RETURN 1

   ELSEIF nNotify == NM_RCLICK
      IF ::lCheckBoxes
         // detect item
         uValue := ListView_HitOnCheckBox( ::hWnd, GetCursorRow() - GetWindowRow( ::hWnd ), GetCursorCol() - GetWindowCol( ::hWnd ) )
      ELSE
         uValue := 0
      ENDIF

      IF ::bPosition == -2 .OR. ::bPosition == 9
         aCellData := _GetGridCellData( Self, ListView_ItemActivate( lParam ) )
         ::nDelayedClick := { aCellData[ 1 ], aCellData[ 2 ], uValue, aCellData }
         ::CurrentRow := ::nEditRow
      ELSE
         IF HB_IsBlock( ::OnRClick )
            IF ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. uValue <= 0
               ::DoEventMouseCoords( ::OnRClick, "RCLICK" )
            ENDIF
         ENDIF

         IF uValue > 0
            // change check mark
            ::CheckItem( uValue, ! ::CheckItem( uValue ) )
         ELSE
            // select item
            aCellData := _GetGridCellData( Self, ListView_ItemActivate( lParam ) )
            r := aCellData[ 1 ]      // ::CurrentRow
            IF r > 0
               DeltaSelect := r - ::nRowPos
               ::FastUpdate( DeltaSelect, r )
               ::CurrentCol := aCellData[ 2 ]
               ::BrowseOnChange()
            ELSEIF ::lNoneUnsels
               ::CurrentRow := 0
               ::CurrentCol := 0
               ::BrowseOnChange()
            ELSE
               ::CurrentRow := ::nRowPos
               ::CurrentCol := ::nColPos
            ENDIF
         ENDIF

         // fire context menu
         IF ::ContextMenu != Nil .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. uValue <= 0 )
            ::ContextMenu:Cargo := _GetGridCellData( Self, ListView_ItemActivate( lParam ) )
            ::ContextMenu:Activate()
         ENDIF
      ENDIF

      // skip default action

      RETURN 1

   ELSEIF nNotify == LVN_BEGINDRAG
      IF ::bPosition == -2 .OR. ::bPosition == 9
         aCellData := _GetGridCellData( Self, ListView_ListView( lParam ) )
         ::nDelayedClick := { aCellData[ 1 ], aCellData[ 2 ], 0, Nil }
         ::CurrentRow := ::nEditRow
      ELSE
         r := ::CurrentRow
         IF r > 0
            DeltaSelect := r - ::nRowPos
            ::FastUpdate( DeltaSelect, r )
            ::BrowseOnChange()
         ELSEIF ::lNoneUnsels
            ::CurrentRow := 0
            ::BrowseOnChange()
         ELSE
            ::CurrentRow := ::nRowPos
         ENDIF
      ENDIF

      RETURN NIL

   ELSEIF nNotify == LVN_KEYDOWN
      IF GetGridvKeyAsChar( lParam ) == 0
         ::cText := ""
      ENDIF

      nvKey := GetGridvKey( lParam )

      DO CASE
      CASE Select( ::WorkArea ) == 0
         // No database open
      CASE nvKey == VK_A .AND. GetKeyFlagState() == MOD_ALT
         IF ::lAppendOnAltA
            ::AppendItem()
         ENDIF
      CASE nvKey == VK_DELETE
         IF ::AllowDelete .AND. ! ::Eof()
            IF HB_IsBlock( ::bDelWhen )
               lGo := Eval( ::bDelWhen )
            ELSE
               lGo := .t.
            ENDIF

            IF lGo
               IF ::lNoDelMsg.OR.  MsgYesNo( _OOHG_Messages(4, 1), _OOHG_Messages(4, 2) )
                  ::Delete()
               ENDIF
            ELSEIF ! Empty( ::DelMsg )
               MsgExclamation( ::DelMsg, _OOHG_Messages(4, 2) )
            ENDIF
         ENDIF
      ENDCASE

      RETURN NIL

   ELSEIF nNotify == LVN_ITEMCHANGED

      RETURN NIL

   ELSEIF nNotify == NM_CUSTOMDRAW
      ::AdjustRightScroll()

      RETURN TGrid_Notify_CustomDraw( Self, lParam, .T., ::nRowPos, ::nColPos, .F., ::lFocusRect, ::lNoGrid, ::lPLM )

   ENDIF

   RETURN ::Super:Events_Notify( wParam, lParam )

METHOD EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, lAppend, nOnFocusPos, lRefresh, lChange, lKeys ) CLASS TOBrowseByCell

   LOCAL lRet, BackRec, cWorkArea, lBefore

   ASSIGN lAppend  VALUE lAppend  TYPE "L" DEFAULT .F.
   ASSIGN nRow     VALUE nRow     TYPE "N" DEFAULT ::nRowPos
   ASSIGN nCol     VALUE nCol     TYPE "N" DEFAULT ::nColPos
   ASSIGN lRefresh VALUE lRefresh TYPE "L" DEFAULT ( ::RefreshType == REFRESH_FORCE )
   ASSIGN lChange  VALUE lChange  TYPE "L" DEFAULT ::lChangeBeforeEdit
   ASSIGN lKeys    VALUE lKeys    TYPE "L" DEFAULT .T.

   IF nRow < 1 .OR. nRow > ::ItemCount .OR. nCol < 1 .OR. nCol > Len( ::aHeaders ) .OR. aScan( ::aHiddenCols, nCol ) # 0

      RETURN .F.
   ENDIF

   cWorkArea := ::WorkArea
   IF Select( cWorkArea ) == 0
      ::RecCount := 0

      RETURN .F.
   ENDIF

   IF lAppend
      BackRec := ( cWorkArea )->( RecNo() )
      ::DbGoTo( 0 )
   ELSE
      IF lChange
         ::Value := { ::aRecMap[ nRow ], nCol }
      ENDIF
      BackRec := ( cWorkArea )->( RecNo() )
      ::DbGoTo( ::aRecMap[ nRow ] )
   ENDIF

   lBefore := ::lCalledFromClass
   ::lCalledFromClass := .T.
   lRet := ::TXBrowse:EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, lAppend, nOnFocusPos )
   ::lCalledFromClass := lBefore

   IF lRet .AND. lAppend
      aAdd( ::aRecMap, ( cWorkArea )->( RecNo() ) )
   ENDIF

   ::DbGoTo( BackRec )

   IF lRet
      IF ! ::lCalledFromClass .AND. ::bPosition == 9                  // MOUSE EXIT
         // Editing window lost focus
         ::bPosition := 0                   // This restores the processing of click messages
         IF ::nDelayedClick[ 1 ] > 0
            // A click message was delayed
            IF ::nDelayedClick[ 3 ] <= 0
               ::SetValue( { ::aRecMap[ ::nDelayedClick[ 1 ] ], ::nDelayedClick[ 2 ] }, ::nDelayedClick[ 1 ] )
            ENDIF

            IF HB_IsNil( ::nDelayedClick[ 4 ] )
               IF HB_IsBlock( ::OnClick )
                  IF ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                     IF ! ::NestedClick
                        ::NestedClick := ! _OOHG_NestedSameEvent()
                        ::DoEventMouseCoords( ::OnClick, "CLICK" )
                        ::NestedClick := .F.
                     ENDIF
                  ENDIF
               ENDIF
            ELSE
               IF HB_IsBlock( ::OnRClick )
                  IF ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                     ::DoEventMouseCoords( ::OnRClick, "RCLICK" )
                  ENDIF
               ENDIF
            ENDIF

            IF ::nDelayedClick[ 3 ] > 0
               // change check mark
               ::CheckItem( ::nDelayedClick[ 3 ], ! ::CheckItem( ::nDelayedClick[ 3 ] ) )
            ENDIF

            // fire context menu
            IF ! HB_IsNil( ::nDelayedClick[ 4 ] ) .AND. ::ContextMenu != Nil .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0 )
               ::ContextMenu:Cargo := ::nDelayedClick[ 4 ]
               ::ContextMenu:Activate()
            ENDIF
         ENDIF
      ELSEIF lAppend
         ::Value := { aTail( ::aRecMap ), nCol }
      ENDIF

      IF lRefresh
         ::Refresh()
      ENDIF

      IF ! ::lCalledFromClass .AND. lKeys
         // ::bPosition is set by TGridControl()
         IF ::bPosition == 1                            // UP
            ::Up()
         ELSEIF ::bPosition == 2                        // RIGHT
            ::Right( .F. )
         ELSEIF ::bPosition == 12                       // CTRL+RIGHT
            IF ::lKeysLikeClipper
               // Should never happen
            ELSE
               ::MoveToLastCol()
            ENDIF
         ELSEIF ::bPosition == 3                        // LEFT
            ::Left()
         ELSEIF ::bPosition == 13                       // CTRL+LEFT
            IF ::lKeysLikeClipper
               // Should never happen
            ELSE
               ::MoveToFirstCol()
            ENDIF
         ELSEIF ::bPosition == 4                        // HOME
            ::Home()
         ELSEIF ::bPosition == 14                       // CTRL+HOME
            IF ::lKeysLikeClipper
               ::MoveToFirstCol()
            ELSE
               // Should never happen
            ENDIF
         ELSEIF ::bPosition == 5                        // END
            ::End( .F. )
         ELSEIF ::bPosition == 15                       // CTRL+END
            IF ::lKeysLikeClipper
               ::MoveToLastCol()
            ELSE
               // Should never happen
            ENDIF
         ELSEIF ::bPosition == 6                        // DOWN
            ::Down( .F. )
         ELSEIF ::bPosition == 7                        // PRIOR
            ::PageUp()
         ELSEIF ::bPosition == 17                       // CTRL+PRIOR
            IF ::lKeysLikeClipper
               ::GoTop()
            ELSE
               // Should never happen
            ENDIF
         ELSEIF ::bPosition == 8                        // NEXT
            ::PageDown( .F. )
         ELSEIF ::bPosition == 18                       // CTRL+NEXT
            IF ::lKeysLikeClipper
               ::GoBottom()
            ELSE
               // Should never happen
            ENDIF
         ELSEIF ::bPosition == 9                        // MOUSE EXIT
         ELSE                                           // OK
         ENDIF
      ENDIF
   ENDIF

   RETURN lRet

METHOD EditCell2( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, nOnFocusPos ) CLASS TOBrowseByCell

   ASSIGN nRow VALUE nRow TYPE "N" DEFAULT ::nRowPos
   ASSIGN nCol VALUE nCol TYPE "N" DEFAULT ::nColPos

   RETURN ::Super:EditCell2( @nRow, @nCol, @EditControl, uOldValue, @uValue, cMemVar, nOnFocusPos )

METHOD EditItem_B( lAppend, lOneRow ) CLASS TOBrowseByCell

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   ASSIGN lOneRow VALUE lOneRow TYPE "L" DEFAULT .T.

   IF lAppend .AND. ! ::AllowAppend

      RETURN .F.
   ENDIF

   IF Select( ::WorkArea ) == 0
      ::RecCount := 0

      RETURN .F.
   ENDIF

   IF ::nRowPos == 0 .AND. ! lAppend

      RETURN .F.
   ENDIF

   RETURN ::EditAllCells( , , lAppend, lOneRow, .T., ::RefreshType == REFRESH_DEFAULT .OR. ::RefreshType == REFRESH_FORCE )

METHOD EditAllCells( nRow, nCol, lAppend, lOneRow, lChange, lRefresh ) CLASS TOBrowseByCell

   LOCAL lRet, lSomethingEdited, lRowAppended, nRecNo, cWorkArea, nNextCol

   ASSIGN lOneRow VALUE lOneRow TYPE "L" DEFAULT .T.
   IF ::FullMove .OR. ! lOneRow

      RETURN ::EditGrid( nRow, nCol, lAppend, lOneRow, lChange, lRefresh )
   ENDIF
   IF ::FirstVisibleColumn == 0

      RETURN .F.
   ENDIF
   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   IF ! HB_IsNumeric( nCol )
      IF ::lAppendMode .OR. lAppend .OR. ::lAtFirstCol
         nCol := ::FirstColInOrder
      ELSE
         nCol := ::FirstVisibleColumn
      ENDIF
   ENDIF
   IF nCol < 1 .OR. nCol > Len( ::aHeaders )

      RETURN .F.
   ENDIF

   IF lAppend
      ::GoBottom( .T. )
      ::InsertBlank( ::ItemCount + 1 )
      ::CurrentRow := ::ItemCount
      ::CurrentCol := nCol
      ::lAppendMode := .T.
   ELSE
      IF ! HB_IsNumeric( nRow )
         nRow := Max( ::nRowPos, 1 )
      ENDIF
      IF nRow < 1 .OR. nRow > ::ItemCount

         RETURN .F.
      ENDIF
      ASSIGN lChange VALUE lChange TYPE "L" DEFAULT ::lChangeBeforeEdit
      IF lChange
         ::Value := { ::aRecMap[ nRow ], nCol }
      ENDIF
   ENDIF

   ASSIGN lRefresh VALUE lRefresh TYPE "L" DEFAULT ( ::RefreshType == REFRESH_DEFAULT .OR. ::RefreshType == REFRESH_FORCE )

   cWorkArea := ::WorkArea

   lSomethingEdited := .F.

   DO WHILE ::nRowPos >= 1 .AND. ::nRowPos <= ::ItemCount .AND. ::nColPos >= 1 .AND. ::nColPos <= Len( ::aHeaders ) .AND. Select( cWorkArea ) # 0
      nRecNo := ( cWorkArea )->( RecNo() )
      IF lAppend
         ::DbGoTo( 0 )
      ELSE
         ::DbGoTo( ::aRecMap[ ::nRowPos ] )
      ENDIF

      _OOHG_ThisItemCellValue := ::Cell( ::nRowPos, ::nColPos )

      IF ::IsColumnReadOnly( ::nColPos, ::nRowPos )
         // Read only column
      ELSEIF ! ::IsColumnWhen( ::nColPos, ::nRowPos )
         // WHEN returned .F.
      ELSEIF aScan( ::aHiddenCols, ::nColPos, ::nRowPos ) > 0
         // Hidden column
      ELSE
         ::DbGoTo( nRecNo )

         ::lCalledFromClass := .T.
         lRet := ::EditCell( ::nRowPos, ::nColPos, , , , , lAppend, , .F., .F., .F. )
         ::lCalledFromClass := .F.

         IF ! lRet
            IF lAppend
               ::lAppendMode := .F.
               ::GoBottom( .T. )
            ENDIF
            EXIT
         ENDIF

         lSomethingEdited := .T.
         IF lAppend
            lRowAppended := .T.
            lAppend := .F.
         ENDIF

         IF ::bPosition == 9                     // MOUSE EXIT
            // Editing window lost focus
            ::bPosition := 0                   // This restores click messages processing
            IF ::nDelayedClick[ 1 ] > 0
               // A click message was delayed
               IF ::nDelayedClick[ 3 ] <= 0
                  ::SetValue( { ::aRecMap[ ::nDelayedClick[ 1 ] ], ::nDelayedClick[ 2 ] }, ::nDelayedClick[ 1 ] )
               ENDIF

               IF HB_IsNil( ::nDelayedClick[ 4 ] )
                  IF HB_IsBlock( ::OnClick )
                     IF ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                        IF ! ::NestedClick
                           ::NestedClick := ! _OOHG_NestedSameEvent()
                           ::DoEventMouseCoords( ::OnClick, "CLICK" )
                           ::NestedClick := .F.
                        ENDIF
                     ENDIF
                  ENDIF
               ELSE
                  IF HB_IsBlock( ::OnRClick )
                     IF ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                        ::DoEventMouseCoords( ::OnRClick, "RCLICK" )
                     ENDIF
                  ENDIF
               ENDIF

               IF ::nDelayedClick[ 3 ] > 0
                  // change check mark
                  ::CheckItem( ::nDelayedClick[ 3 ], ! ::CheckItem( ::nDelayedClick[ 3 ] ) )
               ENDIF

               // fire context menu
               IF ! HB_IsNil( ::nDelayedClick[ 4 ] ) .AND. ::ContextMenu != Nil .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0 )
                  ::ContextMenu:Cargo := ::nDelayedClick[ 4 ]
                  ::ContextMenu:Activate()
               ENDIF
            ELSEIF lRowAppended
               // A new row was added and partially edited: set as new value and refresh the control
               ::SetValue( { aTail( ::aRecMap ), ::nColPos }, ::nRowPos )
            ELSE
               // The user aborted the edition of an existing row: refresh the control without changing it's value
            ENDIF
            IF lRefresh
               ::Refresh()
            ENDIF
            EXIT
         ENDIF
      ENDIF

      nNextCol := ::NextColInOrder( ::nColPos )
      IF nNextCol == 0
         EXIT
      ENDIF
      ::CurrentCol := nNextCol
   ENDDO

   RETURN lSomethingEdited

METHOD EditGrid( nRow, nCol, lAppend, lOneRow, lChange, lRefresh ) CLASS TOBrowseByCell

   LOCAL lSomethingEdited, nRecNo, lRet, lRowAppended, cWorkArea

   IF ::FirstVisibleColumn == 0

      RETURN .F.
   ENDIF

   ASSIGN nRow     VALUE nRow     TYPE "N" DEFAULT ::nRowPos
   ASSIGN nCol     VALUE nCol     TYPE "N" DEFAULT ::nColPos
   ASSIGN lAppend  VALUE lAppend  TYPE "L" DEFAULT .F.
   ASSIGN lOneRow  VALUE lOneRow  TYPE "L" DEFAULT .F.
   ASSIGN lChange  VALUE lChange  TYPE "L" DEFAULT ::lChangeBeforeEdit
   ASSIGN lRefresh VALUE lRefresh TYPE "L" DEFAULT ( ::RefreshType == REFRESH_FORCE )

   IF nRow < 1 .OR. nRow > ::ItemCount .OR. nCol < 1 .OR. nCol > Len( ::aHeaders )

      RETURN .F.
   ENDIF

   cWorkArea := ::WorkArea

   IF lChange
      ::Value := { ::aRecMap[ nRow ], nCol }
   ENDIF

   lSomethingEdited := .F.

   DO WHILE nCol >= 1 .AND. nCol <= Len( ::aHeaders ) .AND. nRow >= 1 .AND. nRow <= ::ItemCount .AND. Select( cWorkArea ) # 0
      nRecNo := ( cWorkArea )->( RecNo() )
      IF lAppend
         ::DbGoTo( 0 )
      ELSE
         ::DbGoTo( ::aRecMap[ nRow ] )
      ENDIF

      _OOHG_ThisItemCellValue := ::Cell( nRow, nCol )

      IF ::IsColumnReadOnly( nCol, nRow )
         // Read only column
      ELSEIF ! ::IsColumnWhen( nCol, nRow )
         // Not a valid WHEN
      ELSEIF aScan( ::aHiddenCols, nCol ) > 0
         // Hidden column
      ELSE
         ::DbGoTo( nRecNo )

         lRowAppended := .F.
         ::lCalledFromClass := .T.
         lRet := ::EditCell( nRow, nCol, , , , , lAppend, , lRefresh, .F., .F. )
         ::lCalledFromClass := .F.

         IF ! lRet
            IF lAppend
               ::lAppendMode := .F.
               lAppend := .F.
               ::GoBottom( .T. )
            ENDIF
            EXIT
         ENDIF

         lSomethingEdited := .T.
         IF lAppend
            lRowAppended := .T.
            ::lAppendMode := .F.
            lAppend := .F.
            ::DoEvent( ::OnAppend, "APPEND" )
         ENDIF
      ENDIF

      /*
      * ::OnEditCell may change ::nRowPos and/or ::nColPos
      * using ::Up(), ::Down(), ::Left(), ::Right(), ::PageUp(),
      * ::Home(), ::End(), ::PageDown(), ::GoTop() and/or ::GoBottom()
      */

      // ::bPosition is set by TGridControl()
      IF ::bPosition == 1                            // UP
         IF ! ::Up() .OR. ! ::FullMove .OR. lOneRow
            EXIT
         ENDIF
      ELSEIF ::bPosition == 2                        // RIGHT
         IF ::Right( .F. )
            IF lOneRow .AND. ::Value[ 1 ] # ::aRecMap[ nRow ]
               EXIT
            ENDIF
         ELSE
            IF ::FullMove .AND. ::AllowAppend .AND. ! lOneRow
               lAppend := .T.
            ELSE
               EXIT
            ENDIF
         ENDIF
      ELSEIF ::bPosition == 3                        // LEFT
         IF ! ::Left() .OR. ( lOneRow .AND. ::Value[ 1 ] # ::aRecMap[ nRow ] )
            EXIT
         ENDIF
      ELSEIF ::bPosition == 4                        // HOME
         IF ::lKeysLikeClipper
            IF ! ::MoveToFirstVisibleCol() .OR. ! ::FullMove .OR. ( lOneRow .AND. ::Value[ 1 ] # ::aRecMap[ nRow ] )
               EXIT
            ENDIF
         ELSE
            IF ! ::Home() .OR. ! ::FullMove .OR. ( lOneRow .AND. ::Value[ 1 ] # ::aRecMap[ nRow ] )
               EXIT
            ENDIF
         ENDIF
      ELSEIF ::bPosition == 5                        // END
         IF ! ::End() .OR. ! ::FullMove .OR. ( lOneRow .AND. ::Value[ 1 ] # ::aRecMap[ nRow ] )
            EXIT
         ENDIF
      ELSEIF ::bPosition == 6                        // DOWN
         IF ::Down( .F. )
            IF ! ::FullMove .OR. ( lOneRow .AND. ::Value[ 1 ] # ::aRecMap[ nRow ] )
               EXIT
            ENDIF
         ELSE
            IF ::FullMove .AND. ::AllowAppend .AND. ! lOneRow
               lAppend := .T.
            ELSE
               EXIT
            ENDIF
         ENDIF
      ELSEIF ::bPosition == 7                        // PRIOR
         IF ! ::PageUp() .OR. ! ::FullMove .OR. lOneRow
            EXIT
         ENDIF
      ELSEIF ::bPosition == 8                        // NEXT
         IF ::PageDown( .F. )
            IF ! ::FullMove .OR. ( lOneRow .AND. ::Value[ 1 ] # ::aRecMap[ nRow ] )
               EXIT
            ENDIF
         ELSE
            IF ::FullMove .AND. ::AllowAppend .AND. ! lOneRow
               lAppend := .T.
            ELSE
               EXIT
            ENDIF
         ENDIF
      ELSEIF ::bPosition == 12                       // CTRL+RIGHT
         IF ::lKeysLikeClipper
            // Should never happen
            EXIT
         ELSE
            IF ! ::MoveToLastCol() .OR. ( lOneRow .AND. ::Value[ 1 ] # ::aRecMap[ nRow ] )
               EXIT
            ENDIF
         ENDIF
      ELSEIF ::bPosition == 13                       // CTRL+LEFT
         IF ::lKeysLikeClipper
            // Should never happen
            EXIT
         ELSE
            IF ! ::MoveToFirstCol() .OR. ( lOneRow .AND. ::Value[ 1 ] # ::aRecMap[ nRow ] )
               EXIT
            ENDIF
         ENDIF
      ELSEIF ::bPosition == 14                       // CTRL+HOME
         IF ::lKeysLikeClipper
            IF ! ::MoveToFirstCol() .OR. ( lOneRow .AND. ::Value[ 1 ] # ::aRecMap[ nRow ] )
               EXIT
            ENDIF
         ELSE
            // Should never happen
            EXIT
         ENDIF
      ELSEIF ::bPosition == 15                       // CTRL+END
         IF ::lKeysLikeClipper
            IF ! ::MoveToLastCol() .OR. ( lOneRow .AND. ::Value[ 1 ] # ::aRecMap[ nRow ] )
               EXIT
            ENDIF
         ELSE
            // Should never happen
            EXIT
         ENDIF
      ELSEIF ::bPosition == 17                       // CTRL+PRIOR
         IF ::lKeysLikeClipper
            IF ! ::GoTop() .OR. ! ::FullMove .OR. ( lOneRow .AND. ::Value[ 1 ] # ::aRecMap[ nRow ] )
               EXIT
            ENDIF
         ELSE
            // Should never happen
         ENDIF
      ELSEIF ::bPosition == 18                       // CTRL+NEXT
         IF ::lKeysLikeClipper
            IF ! ::GoBottom() .OR. ! ::FullMove .OR. ( lOneRow .AND. ::Value[ 1 ] # ::aRecMap[ nRow ] )
               EXIT
            ENDIF
         ELSE
            // Should never happen
         ENDIF
      ELSEIF ::bPosition == 9                        // MOUSE EXIT
         // Editing window lost focus
         ::bPosition := 0                   // This restores click messages processing
         IF ::nDelayedClick[ 1 ] > 0
            // A click message was delayed
            IF ::nDelayedClick[ 3 ] <= 0
               ::SetValue( { ::aRecMap[ ::nDelayedClick[ 1 ] ], ::nDelayedClick[ 2 ] }, ::nDelayedClick[ 1 ] )
            ENDIF

            IF HB_IsNil( ::nDelayedClick[ 4 ] )
               IF HB_IsBlock( ::OnClick )
                  IF ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                     IF ! ::NestedClick
                        ::NestedClick := ! _OOHG_NestedSameEvent()
                        ::DoEventMouseCoords( ::OnClick, "CLICK" )
                        ::NestedClick := .F.
                     ENDIF
                  ENDIF
               ENDIF
            ELSE
               IF HB_IsBlock( ::OnRClick )
                  IF ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                     ::DoEventMouseCoords( ::OnRClick, "RCLICK" )
                  ENDIF
               ENDIF
            ENDIF

            IF ::nDelayedClick[ 3 ] > 0
               // change check mark
               ::CheckItem( ::nDelayedClick[ 3 ], ! ::CheckItem( ::nDelayedClick[ 3 ] ) )
            ENDIF

            // fire context menu
            IF ! HB_IsNil( ::nDelayedClick[ 4 ] ) .AND. ::ContextMenu != Nil .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0 )
               ::ContextMenu:Cargo := ::nDelayedClick[ 4 ]
               ::ContextMenu:Activate()
            ENDIF

            IF lRefresh
               ::Refresh()
            ENDIF
         ELSE
            IF lRowAppended
               // A new row was added and partially edited: set as new value and refresh the control
               ::SetValue( { aTail( ::aRecMap ), nCol }, nRow )
            ELSE
               // The user aborted the edition of an existing row: refresh the control without changing it's value
            ENDIF

            IF lRefresh
               ::Refresh()
            ENDIF
            EXIT
         ENDIF
      ELSE                                           // OK
         IF ::FullMove
            ::Right( .F. )
            lAppend := ::Eof() .AND. ::AllowAppend
         ELSEIF ::nColPos # ::LastColInOrder
            ::Right( .F. )
         ELSE
            EXIT
         ENDIF
      ENDIF

      IF lAppend
         // Insert new row
         ::GoBottom( .T. )
         ::InsertBlank( ::ItemCount + 1 )
         ::CurrentRow := ::ItemCount
         ::CurrentCol := ::FirstColInOrder
         ::lAppendMode := .T.
      ENDIF

      nRow := ::nRowPos
      nCol := ::nColPos
   ENDDO

   RETURN lSomethingEdited

METHOD BrowseOnChange() CLASS TOBrowseByCell

   LOCAL cWorkArea, lSync, nRec

   IF ::lUpdCols
      ::UpdateColors()
   ENDIF

   IF HB_IsLogical( ::SyncStatus )
      lSync := ::SyncStatus
   ELSE
      lSync := _OOHG_BrowseSyncStatus
   ENDIF

   IF lSync
      cWorkArea := ::WorkArea
      nRec := ::Value[ 1 ]
      IF Select( cWorkArea ) != 0 .AND. ( cWorkArea )->( RecNo() ) != nRec
         ::DbGoTo( nRec )
      ENDIF
   ENDIF

   ::DoChange()

   RETURN Self

METHOD DoChange() CLASS TOBrowseByCell

   LOCAL xValue, cType, cOldType

   xValue   := ::Value
   cType    := ValType( xValue )
   cOldType := ValType( ::xOldValue )
   cType    := If( cType == "M", "C", cType )
   cOldType := If( cOldType == "M", "C", cOldType )

   IF ( cOldType == "U" .OR. ! cType == cOldType .OR. ;
         ( HB_IsArray( xValue ) .AND. ! HB_IsArray( ::xOldValue ) ) .OR. ;
         ( ! HB_IsArray( xValue ) .AND. HB_IsArray( ::xOldValue ) ) .OR. ;
         ! AEqual( xValue, ::xOldValue ) )
      ::xOldValue := xValue
      ::DoEvent( ::OnChange, "CHANGE" )
   ENDIF

   ::nRecLastValue := xValue[ 1 ]

   RETURN Self

METHOD SetValue( Value, mp ) CLASS TOBrowseByCell

   LOCAL nRow, nCol, _RecNo, m, cWorkArea

   cWorkArea := ::WorkArea
   IF Select( cWorkArea ) == 0
      ::RecCount := 0

      RETURN Self
   ENDIF

   IF _OOHG_ThisEventType == 'BROWSE_ONCHANGE'
      IF ::hWnd == _OOHG_ThisControl:hWnd
         MsgOOHGError( "BROWSEBYCELL: Value property can't be changed inside ONCHANGE event. Program terminated." )
      ENDIF
   ENDIF

   IF HB_IsArray( Value ) .AND. Len( Value ) > 1
      nRow := Value[ 1 ]
      nCol := Value[ 2 ]
      IF HB_IsNumeric( nRow ) .AND. nRow > 0 .AND. HB_IsNumeric( nCol ) .AND. nCol >= 1 .AND. nCol <= Len( ::aHeaders )
         IF nRow > ( cWorkArea )->( RecCount() )
            ::DeleteAllItems()
            ::BrowseOnChange()

            RETURN Self
         ENDIF

         IF ValType( mp ) != "N"
            m := Int( ::CountPerPage / 2 )
         ELSE
            m := mp
         ENDIF

         _RecNo := ( cWorkArea )->( RecNo() )

         ::DbGoTo( nRow )
         IF ::Eof()
            ::DbGoTo( _RecNo )

            RETURN Self
         ENDIF

         // Enforce filters in use
         ::DbSkip()
         ::DbSkip( -1 )
         IF ( cWorkArea )->( RecNo() ) != nRow
            ::DbGoTo( _RecNo )

            RETURN Self
         ENDIF

         IF PCount() < 2
            ::ScrollUpdate()
         ENDIF
         ::DbSkip( -m + 1 )
         ::Update()
         ::DbGoTo( _RecNo )
         ::CurrentRow := aScan( ::aRecMap, nRow )
         ::CurrentCol := nCol

         _OOHG_ThisEventType := 'BROWSE_ONCHANGE'
         ::BrowseOnChange()
         _OOHG_ThisEventType := ''
      ELSE
         IF ::lNoneUnsels
            ::CurrentRow := 0
            ::BrowseOnChange()
         ENDIF
      ENDIF
   ELSE
      IF ::lNoneUnsels
         ::CurrentRow := 0
         ::BrowseOnChange()
      ENDIF
   ENDIF

   RETURN Self

METHOD Delete() CLASS TOBrowseByCell

   LOCAL Value, nRow, nRecNo, lSync, cWorkArea

   Value := ::Value
   nRow  := Value[ 1 ]

   IF nRow == 0

      RETURN Self
   ENDIF

   cWorkArea := ::WorkArea
   nRecNo := ( cWorkArea )->( RecNo() )

   ::DbGoTo( nRow )

   IF ::Lock .AND. ! ( cWorkArea )->( Rlock() )
      MsgExclamation( _OOHG_Messages( 3, 9 ), _OOHG_Messages( 4, 2 ) )
   ELSE
      ( cWorkArea )->( DbDelete() )

      // Do before unlocking record or moving record pointer
      // so block can operate on deleted record (e.g. to copy to a log).
      IF HB_IsBlock( ::OnDelete )
         ::DoEvent( ::OnDelete, 'DELETE' )
      ENDIF

      IF ::Lock
         ( cWorkArea )->( DbCommit() )
         ( cWorkArea )->( DbUnlock() )
      ENDIF
      ::DbSkip()
      IF ::Eof()
         ::TopBottom( GO_BOTTOM )
      ENDIF

      IF Set( _SET_DELETED )
         ::SetValue( { ( cWorkArea )->( RecNo() ), 1 }, ::nRowPos )
      ENDIF
   ENDIF

   IF HB_IsLogical( ::SyncStatus )
      lSync := ::SyncStatus
   ELSE
      lSync := _OOHG_BrowseSyncStatus
   ENDIF

   IF lSync
      Value := ::Value
      nRow  := Value[ 1 ]

      IF ( cWorkArea )->( RecNo() ) != nRow
         ::DbGoTo( nRow )
      ENDIF
   ELSE
      ::DbGoTo( nRecNo )
   ENDIF

   RETURN Self

METHOD Home() CLASS TOBrowseByCell

   LOCAL lDone

   IF ::lKeysLikeClipper
      lDone := ::MoveToFirstVisibleCol()
   ELSE
      lDone := ::GoTop( ::FirstColInOrder )
   ENDIF

   RETURN lDone

METHOD GoTop( nCol ) CLASS TOBrowseByCell

   LOCAL _RecNo, aBefore, aAfter, lDone := .F., cWorkArea

   cWorkArea := ::WorkArea
   IF Select( cWorkArea ) == 0
      ::RecCount := 0

      RETURN lDone
   ENDIF
   IF ! HB_IsNumeric( nCol )
      IF ::lKeysLikeClipper
         nCol := ::CurrentCol
      ELSE
         nCol := ::FirstColInOrder
      ENDIF
   ENDIF
   aBefore := ::Value
   _RecNo := ( cWorkArea )->( RecNo() )
   ::TopBottom( GO_TOP )
   ::ScrollUpdate()
   ::Update()
   ::DbGoTo( _RecNo )
   ::CurrentRow := 1
   ::CurrentCol := nCol
   aAfter := ::Value
   lDone := ( aBefore[ 1 ] # aAfter[ 1 ] .OR. aBefore[ 2 ] # aAfter[ 2 ] )
   ::BrowseOnChange()

   RETURN lDone

METHOD End( lAppend ) CLASS TOBrowseByCell

   LOCAL lDone

   IF ::lKeysLikeClipper
      lDone := ::MoveToLastVisibleCol()
   ELSE
      lDone := ::GoBottom( lAppend, ::LastColInOrder )
   ENDIF

   RETURN lDone

METHOD GoBottom( lAppend, nCol ) CLASS TOBrowseByCell

   LOCAL lDone := .F., aBefore, _Recno, cWorkArea, aAfter

   cWorkArea := ::WorkArea
   IF Select( cWorkArea ) == 0
      ::RecCount := 0

      RETURN lDone
   ENDIF
   IF ! HB_IsNumeric( nCol )
      IF ::lKeysLikeClipper
         nCol := ::CurrentCol
      ELSE
         nCol := ::LastColInOrder
      ENDIF
   ENDIF
   aBefore := ::Value
   _RecNo := ( cWorkArea )->( RecNo() )
   ::TopBottom( GO_BOTTOM )
   ::ScrollUpdate()

   // If it's for APPEND, leaves a blank line ;)
   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   ::DbSkip( - ::CountPerPage + If( lAppend, 2, 1 ) )
   ::Update()
   ::DbGoTo( _RecNo )
   ::CurrentRow := Len( ::aRecMap )
   ::CurrentCol := If( lAppend, ::FirstColInOrder, nCol )
   aAfter := ::Value
   lDone := ( aAfter[ 1 ] # aBefore[ 1 ] .OR. aAfter[ 2 ] # aBefore[ 2 ] )
   ::BrowseOnChange()

   RETURN lDone

METHOD PageUp() CLASS TOBrowseByCell

   LOCAL _RecNo, s, aBefore, lDone := .F., cWorkArea, aAfter

   s := ::nRowPos

   IF s == 1 .OR. ::lKeysLikeClipper
      cWorkArea := ::WorkArea
      IF Select( cWorkArea ) == 0
         ::RecCount := 0

         RETURN lDone
      ENDIF

      aBefore := ::Value
      _RecNo := ( cWorkArea )->( RecNo() )
      IF Len( ::aRecMap ) == 0
         ::TopBottom( GO_TOP )
      ELSE
         ::DbGoTo( ::aRecMap[ 1 ] )
      ENDIF
      ::DbSkip( - ::CountPerPage + 1 )
      IF ::Bof()
         s := 1
      ENDIF
      ::ScrollUpdate()
      ::Update()
      ::DbGoTo( _RecNo )
      IF ! ::lKeysLikeClipper .OR. s > Len( ::aRecMap )
         s := 1
      ENDIF
      ::CurrentRow := s
      aAfter := ::Value
      lDone := ( aAfter[ 1 ] # aBefore[ 1 ] .OR. aAfter[ 2 ] # aBefore[ 2 ] )
   ELSE
      ::FastUpdate( 1 - ::nRowPos, 1 )
      lDone := .T.
   ENDIF

   ::BrowseOnChange()

   RETURN lDone

METHOD PageDown( lAppend ) CLASS TOBrowseByCell

   LOCAL _RecNo, s, lDone := .F., cWorkArea, aBefore, aAfter

   s := ::nRowPos

   IF  s >= Len( ::aRecMap ) .OR. ::lKeysLikeClipper
      cWorkArea := ::WorkArea
      IF Select( cWorkArea ) == 0
         ::RecCount := 0

         RETURN lDone
      ENDIF

      aBefore := ::Value
      _RecNo := ( cWorkArea )->( RecNo() )
      IF Len( ::aRecMap ) == 0
         ::TopBottom( GO_BOTTOM )
         ::DbSkip( - ::CountPerPage + 1 )
      ELSE
         ::DbGoTo( ::aRecMap[ Len( ::aRecMap ) ] )
         // Check for more records
         ::DbSkip()
         IF ::Eof()
            ::DbGoTo( _RecNo )
            ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
            IF lAppend
               lDone := ::AppendItem()
            ELSEIF s < Len( ::aRecMap )
               ::CurrentRow := Len( ::aRecMap )
               lDone := .T.
               ::BrowseOnChange()
            ENDIF

            RETURN lDone
         ENDIF
         ::DbSkip( -1 )
      ENDIF
      ::Update()
      IF Len( ::aRecMap ) == 0
         ::DbGoTo( 0 )
      ELSE
         IF ::lKeysLikeClipper .AND. s <= Len( ::aRecMap )
            ::DbGoTo( ::aRecMap[ s ] )
         ELSE
            ::DbGoTo( ::aRecMap[ Len( ::aRecMap ) ] )
         ENDIF
         aAfter := ::Value
         lDone := ( aAfter[ 1 ] # aBefore[ 1 ] .OR. aAfter[ 2 ] # aBefore[ 2 ] )
      ENDIF
      ::ScrollUpdate()
      ::DbGoTo( _RecNo )
      IF ::lKeysLikeClipper .AND. s <= Len( ::aRecMap )
         ::CurrentRow := s
      ELSE
         ::CurrentRow := Len( ::aRecMap )
      ENDIF
   ELSE
      ::FastUpdate( ::CountPerPage - s, Len( ::aRecMap ) )
      lDone := .T.
   ENDIF

   ::BrowseOnChange()

   RETURN lDone

METHOD Up( lLast ) CLASS TOBrowseByCell

   LOCAL s, _RecNo, nLen, lDone := .F., cWorkArea, aBefore, aAfter

   s := ::nRowPos

   IF s <= 1
      cWorkArea := ::WorkArea
      IF Select( cWorkArea ) == 0
         ::RecCount := 0

         RETURN lDone
      ENDIF

      aBefore := ::Value
      _RecNo := ( cWorkArea )->( RecNo() )
      IF Len( ::aRecMap ) == 0
         ::TopBottom( GO_TOP )
         ::DbSkip( -1 )
         ::Update()
      ELSE
         // Check for more records
         ::DbGoTo( ::aRecMap[ 1 ] )
         ::DbSkip( -1 )
         IF ::Bof()
            ::DbGoTo( _RecNo )

            RETURN lDone
         ENDIF
         // Add one record at the top
         aAdd( ::aRecMap, Nil )
         aIns( ::aRecMap, 1 )
         ::aRecMap[ 1 ] := ( cWorkArea )->( RecNo() )
         IF ::Visible
            ::SetRedraw( .F. )
         ENDIF
         ::InsertBlank( 1 )
         ::RefreshRow( 1 )
         nLen := Len( ::aRecMap )
         // Resize record map
         IF nLen > ::CountPerPage
            ::DeleteItem( nLen )
            aSize( ::aRecMap, nLen - 1 )
         ENDIF
         IF ::Visible
            ::SetRedraw( .T. )
         ENDIF
      ENDIF
      ::ScrollUpdate()
      ::DbGoTo( _RecNo )
      ::CurrentRow := 1
      IF HB_IsLogical( lLast ) .AND. lLast
         ::CurrentCol := ::LastColInOrder
      ENDIF
      IF Len( ::aRecMap ) != 0
         aAfter := ::Value
         lDone := ( aAfter[ 1 ] # aBefore[ 1 ] .OR. aAfter[ 2 ] # aBefore[ 2 ] )
      ENDIF
   ELSE
      ::FastUpdate( -1, s - 1 )
      IF HB_IsLogical( lLast ) .AND. lLast
         ::CurrentCol := ::LastColInOrder
      ENDIF
      lDone := .T.
   ENDIF

   ::BrowseOnChange()

   RETURN lDone

METHOD Down( lAppend, lFirst ) CLASS TOBrowseByCell

   LOCAL s, _RecNo, nLen, lDone := .F., cWorkArea, aBefore, aAfter

   s := ::nRowPos

   IF s >= Len( ::aRecMap )
      cWorkArea := ::WorkArea
      IF Select( cWorkArea ) == 0
         ::RecCount := 0

         RETURN lDone
      ENDIF

      aBefore := ::Value
      _RecNo := ( cWorkArea )->( RecNo() )
      IF Len( ::aRecMap ) == 0
         ::TopBottom( GO_TOP )
         ::DbSkip()
         ::Update()
      ELSE
         // Check for more records
         ::DbGoTo( ::aRecMap[ Len( ::aRecMap ) ] )
         ::DbSkip()
         IF ::Eof()
            ::DbGoTo( _RecNo )
            ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT ::AllowAppend
            IF lAppend
               lDone := ::AppendItem()
            ENDIF

            RETURN lDone
         ENDIF
         // Add one record at the bottom
         aAdd( ::aRecMap, ( cWorkArea )->( RecNo() ) )
         nLen := Len( ::aRecMap )
         IF ::Visible
            ::SetRedraw( .F. )
         ENDIF
         ::RefreshRow( nLen )
         // Resize record map
         IF nLen > ::CountPerPage
            ::DeleteItem( 1 )
            _OOHG_DeleteArrayItem( ::aRecMap, 1 )
         ENDIF
         IF ::Visible
            ::SetRedraw( .T. )
         ENDIF
      ENDIF

      IF Len( ::aRecMap ) == 0
         ::DbGoTo( 0 )
      ELSE
         ::DbGoTo( ATail( ::aRecMap ) )
         aAfter := ::Value
         lDone := ( aAfter[ 1 ] # aBefore[ 1 ] .OR. aAfter[ 2 ] # aBefore[ 2 ] )
      ENDIF
      ::ScrollUpdate()
      ::DbGoTo( _RecNo )
      ::CurrentRow := Len( ::aRecMap )
   ELSE
      ::FastUpdate( 1, s + 1 )
      lDone := .T.
   ENDIF
   IF HB_IsLogical( lFirst ) .AND. lFirst
      ::CurrentCol := ::FirstColInOrder
   ENDIF

   ::BrowseOnChange()

   RETURN lDone

METHOD SetScrollPos( nPos, VScroll ) CLASS TOBrowseByCell

   LOCAL BackRec, cWorkArea

   cWorkArea := ::WorkArea
   IF Select( cWorkArea ) == 0
      // Not workarea selected
   ELSEIF nPos <= VScroll:RangeMin
      ::GoTop()
   ELSEIF nPos >= VScroll:RangeMax
      ::GoBottom()
   ELSE
      BackRec := ( cWorkArea )->( RecNo() )
      ::Super:SetScrollPos( nPos, VScroll )
      ::Value := { ( cWorkArea )->( RecNo() ), ::nColPos }
      ::DbGoTo( BackRec )
      ::BrowseOnChange()
   ENDIF

   RETURN Self

METHOD CurrentCol( nCol ) CLASS TOBrowseByCell

   LOCAL r, nClientWidth, nScrollWidth, lColChanged

   IF HB_IsNumeric( nCol ) .AND. nCol >= 0 .AND. nCol <= Len( ::aHeaders )
      IF  nCol < 1 .OR. nCol > Len( ::aHeaders )
         ::nRowPos := 0
         ::nColPos := 0
         ::CurrentRow := 0
      ELSE
         lColChanged := ( ::nColPos # nCol )
         ::nColPos := nCol

         // Ensure that the column is inside the client area
         IF lColChanged
            r := { 0, 0, 0, 0 }                                                              // left, top, right, bottom
            GetClientRect( ::hWnd, r )
            nClientWidth := r[ 3 ] - r[ 1 ]
            r := ListView_GetSubitemRect( ::hWnd, ::nRowPos - 1, ::nColPos - 1 )             // top, left, width, height
            IF ::lScrollBarUsesClientArea .AND. ::ItemCount > ::CountPerPage
               nScrollWidth := GetVScrollBarWidth()
            ELSE
               nScrollWidth := 0
            ENDIF
            IF r[ 2 ] + r[ 3 ] + nScrollWidth > nClientWidth
               // Move right side into client area
               ListView_Scroll( ::hWnd, ( r[ 2 ] + r[ 3 ] + nScrollWidth - nClientWidth ), 0 )
               // Get new position
               r := ListView_GetSubitemRect( ::hWnd, ::nRowPos - 1, ::nColPos - 1 )          // top, left, width, height
            ENDIF
            IF r[ 2 ] < 0
               // Move left side into client area
               ListView_Scroll( ::hWnd, r[ 2 ], 0 )
            ENDIF
         ENDIF

         // Ensure cell is visible
         ListView_RedrawItems( ::hWnd, ::nRowPos, ::ItemCount )
      ENDIF
   ELSE
      ::nRowPos := ::CurrentRow
      IF ::nRowPos == 0
         ::nColPos := 0
      ENDIF
   ENDIF

   RETURN ::nColPos

METHOD Left() CLASS TOBrowseByCell

   LOCAL aBefore, nRec, nCol, lDone := .F., aAfter

   aBefore := ::Value
   nRec := aBefore[ 1 ]
   nCol := aBefore[ 2 ]
   IF nRec > 0 .AND. nCol >= 1 .AND. nCol <= Len( ::aHeaders )
      IF nCol # ::FirstColInOrder
         aAfter := ( ::Value := { nRec, ::PriorColInOrder( nCol ) } )
         lDone := ( aAfter[ 1 ] # nRec .OR. aAfter[ 2 ] # nCol )
      ELSEIF ::FullMove
         lDone := ::Up( .T. )
      ENDIF
   ENDIF

   RETURN lDone

METHOD Right( lAppend ) CLASS TOBrowseByCell

   LOCAL aBefore, nRec, nCol, lDone := .F., aAfter

   aBefore := ::Value
   nRec := aBefore[ 1 ]
   nCol := aBefore[ 2 ]
   IF nRec > 0 .AND. nCol >= 1 .AND. nCol <= Len( ::aHeaders )
      IF nCol # ::LastColInOrder
         aAfter := ( ::Value := { nRec, ::NextColInOrder( nCol ) } )
         lDone := ( aAfter[ 1 ] # nRec .OR. aAfter[ 2 ] # nCol )
      ELSEIF ::FullMove
         IF ::Down( .F., .T. )
            lDone := .T.
         ELSE
            ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
            IF lAppend
               lDone := ::AppendItem()
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   RETURN lDone
