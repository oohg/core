/*
 * $Id: h_browse.prg $
 */
/*
 * ooHG source code:
 * Browse and BrowseByCell controls
 *
 * Copyright 2005-2019 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2019 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2019 Contributors, https://harbour.github.io/
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
 * Boston, MA 02110-1335, USA (or download from http://www.gnu.org/licenses/).
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


#include "hbclass.ch"
#include "oohg.ch"
#include "i_windefs.ch"
#include "i_init.ch"

#define GO_TOP    -1
#define GO_BOTTOM  1

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TOBrowse FROM TXBrowse

   DATA Type                      INIT "BROWSE" READONLY
   DATA aRecMap                   INIT {}
   DATA lUpdateAll                INIT .F.
   DATA nRecLastValue             INIT 0 PROTECTED
   DATA SyncStatus                INIT Nil
   /*
    * When .T. the browse behaves as if SET BROWSESYNC is ON.
    * When .F. the browse behaves as if SET BROWSESYNC if OFF.
    * When NIL the browse behaves according to SET BROWESYNC value.
    */

   METHOD BrowseOnChange
   METHOD CurrentRow              SETGET
   METHOD DbGoTo
   METHOD DbSkip
   METHOD Define
   METHOD Define3
   METHOD Delete
   METHOD DeleteItem
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
   METHOD MoveTo                  BLOCK { || NIL }
   METHOD PageDown
   METHOD PageUp
   METHOD Refresh
   METHOD RefreshData
   METHOD VScrollUpdate
   METHOD SetControlValue         BLOCK { || NIL }
   METHOD SetScrollPos
   METHOD SetValue
   METHOD TopBottom
   METHOD Up
   METHOD Update
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
      DeleteAllItems
      DeleteColumn
      EditItem
      Enabled
      FixBlocks
      FixControls
      GetCellType
      HelpId
      HScrollVisible
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
      EditCell2
      EditItem2
      Events_Enter
      FirstColInOrder
      FirstSelectedItem
      FirstVisibleColumn
      FirstVisibleItem
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
               lInPlace, lNoVSB, lAllowAppend, aReadonly, aValid, ;
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
               bbeforeditcell, bEditCellValue, klc, lLabelTip, lNoHSB, ;
               aHeadDblClick, aHeaderColors ) CLASS TOBrowse

   LOCAL nWidth2, nCol2, z

   ASSIGN ::aFields     VALUE aFields      TYPE "A"
   ASSIGN ::aHeaders    VALUE aHeaders     TYPE "A" DEFAULT {}
   ASSIGN ::aJust       VALUE aJust        TYPE "A" DEFAULT {}
   ASSIGN ::aWidths     VALUE aWidths      TYPE "A" DEFAULT {}
   ASSIGN ::lDescending VALUE lDescending  TYPE "L"
   ASSIGN ::lUpdateAll  VALUE lUpdateAll   TYPE "L"
   ASSIGN ::lUpdCols    VALUE lUpdCols     TYPE "L"
   ASSIGN ::SyncStatus  VALUE lSync        TYPE "L" DEFAULT Nil
   ASSIGN lAltA         VALUE lAltA        TYPE "L" DEFAULT .T.
   ASSIGN lCBE          VALUE lCBE         TYPE "L" DEFAULT .F.
   ASSIGN lFixedBlocks  VALUE lFixedBlocks TYPE "L" DEFAULT _OOHG_BrowseFixedBlocks
   ASSIGN lFixedCtrls   VALUE lFixedCtrls  TYPE "L" DEFAULT _OOHG_BrowseFixedControls
   ASSIGN lNoHSB        VALUE lNoHSB       TYPE "L" DEFAULT .F.
   ASSIGN lNoVSB        VALUE lNoVSB       TYPE "L" DEFAULT ( ValType( nCol ) != "N" .OR. ValType( nRow ) != "N" )   // If splitboxed then force no vertical scrollbar

   IF HB_ISARRAY( aDefaultValues )
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
      ASize( ::aHeaders, Len( aColumnInfo ) )
      ASize( ::aWidths,  Len( aColumnInfo ) )
      ASize( ::aJust,    Len( aColumnInfo ) )
      FOR z := 1 TO Len( aColumnInfo )
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
      AEval( ::aFields, { |x,i| ::aFields[ i ] := cWorkArea + "->" + x[ 1 ] } )
   ENDIF

   ASize( ::aHeaders, Len( ::aFields ) )
   AEval( ::aHeaders, { |x,i| ::aHeaders[ i ] := iif( ! ValType( x ) $ "CM", iif( ValType( ::aFields[ i ] ) $ "CM", ::aFields[ i ], "" ), x ) } )

   ASize( ::aWidths, Len( ::aFields ) )
   AEval( ::aWidths, { |x,i| ::aWidths[ i ] := iif( ! ValType( x ) == "N", 100, x ) } )

   ASSIGN nWidth VALUE nWidth TYPE "N" DEFAULT ::nWidth
   nWidth2 := iif( lNoVSB, nWidth, nWidth - GetVScrollBarWidth() )

   ::Define3( ControlName, ParentForm, nCol, nRow, nWidth2, nHeight, cFontName, nFontSize, ;
              cTooltip, aHeadClick, lNoLines, aImage, lBreak, nHelpId, lBold, ;
              lItalic, lUnderline, lStrikeout, lAllowEdit, uBackColor, uFontColor, ;
              uDynamicBackColor, uDynamicForeColor, aPicture, lRtl, lInPlace, ;
              aEditControls, aReadonly, aValid, aValidMessages, aWhenFields, ;
              NIL, lNoTabStop, lInvisible, lHasHeaders, aHeaderImage, ;
              aHeaderImageAlign, lFullMove, aSelectedColors, aEditKeys, ;
              lDblBffr, lFocusRect, lPLM, lFixedCols, lFixedWidths, ;
              lLikeExcel, lButtons, lAllowDelete, cDelMsg, lNoDelMsg, ;
              lAllowAppend, lNoModal, lFixedCtrls, lExtDbl, nValue, lSilent, ;
              lAltA, lNoShowAlways, lNone, lCBE, lCheckBoxes, lAtFirst, klc, ;
              lLabelTip, aHeadDblClick, aHeaderColors )

   ::FixBlocks( lFixedBlocks )

   ::nWidth := nWidth

   ASSIGN ::Lock          VALUE lLock          TYPE "L"
   ASSIGN ::aReplaceField VALUE aReplaceFields TYPE "A"
   ASSIGN ::lRecCount     VALUE lRecCount      TYPE "L"

   ::aRecMap := {}

   IF ::lRtl .AND. ! ::Parent:lRtl
      ::nCol := ::nCol + GetVScrollBarWidth()
      nCol2 := - GetVScrollBarWidth()
   ELSE
      nCol2 := nWidth2
   ENDIF

   ::ScrollButton := TScrollButton():Define( NIL, Self, nCol2, ::nHeight - GetHScrollBarHeight(), GetVScrollBarWidth(), GetHScrollBarHeight(), NIL )
   IF lNoHSB
      ::ScrollButton:Visible := .F.
   ENDIF

   ::VScroll := TScrollBar():Define( NIL, Self, nCol2, 0, GetVScrollBarWidth(), iif( lNoHSB, ::nHeight, ::nHeight - GetHScrollBarHeight() ) )
   ::VScroll:OnLineUp   := { || ::SetFocus():Up(), 0 }
   ::VScroll:OnLineDown := { || ::SetFocus():Down(), 0 }
   ::VScroll:OnPageUp   := { || ::SetFocus():PageUp(), 0 }
   ::VScroll:OnPageDown := { || ::SetFocus():PageDown(), 0 }
   ::VScroll:OnThumb    := { |VScroll,Pos| ::SetFocus():SetScrollPos( Pos, VScroll ), 0 }
   ::VScroll:ToolTip    := cToolTip
   ::VScroll:HelpId     := nHelpId

   ::VScrollCopy := ::VScroll

   // Hide "additional" controls when it's inside a non-visible TAB page
   ::Visible := ::Visible

   ::SizePos()

   ::Value := nValue

   IF lNoHSB
      ::HScrollVisible( .F. )
   ENDIF
   IF lNoVSB
      ::VScrollVisible( .F. )
   ENDIF

   IF HB_ISLOGICAL( lDisabled )
      ::Enabled := ! lDisabled
   ENDIF

   // Must be set after control is initialized
   ::Define4( bOnChange, bOnDblClick, bOnGotFocus, bOnLostFocus, bOnEditCell, bOnEnter, ;
              bOnCheck, bOnAbortEdit, bOnClick, bBeforeColMove, bAfterColMove, ;
              bBeforeColSize, bAfterColSize, bBeforeAutoFit, bOnDelete, ;
              bDelWhen, bOnAppend, bHeadRClick, bOnRClick, bOnEditEnd, bOnRowRefresh, ;
              bbeforeditcell, bEditCellValue )

   ::ToolTip := cToolTip
   ::HelpId  := nHelpId

   RETURN Self

METHOD Define3( ControlName, ParentForm, x, y, w, h, fontname, fontsize, ;
                cToolTip, aHeadClick, nogrid, aImage, break, nHelpId, bold, ;
                italic, underline, strikeout, edit, backcolor, fontcolor, ;
                dynamicbackcolor, dynamicforecolor, aPicture, lRtl, InPlace, ;
                editcontrols, readonly, valid, validmessages, aWhenFields, ;
                lDisabled, lNoTabStop, lInvisible, lHasHeaders, aHeaderImage, ;
                aHeaderImageAlign, FullMove, aSelectedColors, aEditKeys, ;
                dblbffr, lFocusRect, lPLM, lFixedCols, lFixedWidths, ;
                lLikeExcel, lButtons, AllowDelete, DelMsg, lNoDelMsg, ;
                AllowAppend, lNoModal, lFixedCtrls, lExtDbl, Value, lSilent, ;
                lAltA, lNoShowAlways, lNone, lCBE, lCheckBoxes, lAtFirst, klc, ;
                lLabelTip, aHeadDblClick, aHeaderColors ) CLASS TOBrowse

   HB_SYMBOL_UNUSED( lDisabled )

   ::Define2( ControlName, ParentForm, x, y, w, h, ::aHeaders, ::aWidths, NIL, ;
              NIL, fontname, fontsize, cTooltip, aHeadClick, nogrid, ;
              aImage, ::aJust, break, nHelpId, bold, italic, underline, ;
              strikeout, NIL, NIL, edit, backcolor, ;
              fontcolor, dynamicbackcolor, dynamicforecolor, aPicture, lRtl, ;
              LVS_SINGLESEL, inplace, editcontrols, readonly, valid, validmessages, ;
              aWhenFields, NIL, lNoTabStop, lInvisible, lHasHeaders, ;
              aHeaderImage, aHeaderImageAlign, FullMove, aSelectedColors, ;
              aEditKeys, lCheckBoxes, dblbffr, lFocusRect, lPLM, ;
              lFixedCols, lFixedWidths, lLikeExcel, lButtons, AllowDelete, ;
              DelMsg, lNoDelMsg, AllowAppend, lNoModal, lFixedCtrls, ;
              NIL, NIL, lExtDbl, lSilent, lAltA, ;
              lNoShowAlways, lNone, lCBE, lAtFirst, klc, lLabelTip, NIL, ;
              NIL, aHeadDblClick, aHeaderColors )

   IF ValType( Value ) == "N"
      ::nRecLastValue := Value
   ENDIF

   RETURN Self

METHOD Update( nRow, lComplete ) CLASS TOBrowse

   LOCAL PageLength, aTemp, _BrowseRecMap, x, _RecNo, nCurrentLength
   LOCAL lColor, aFields, cWorkArea, nWidth

   cWorkArea := ::WorkArea
   IF Select( cWorkArea ) == 0
      RETURN NIL
   ENDIF

   PageLength := ::CountPerPage

   IF PageLength < 1
     RETURN NIL
   ENDIF

   nWidth := Len( ::aFields )

   IF ::FixBlocks()
     aFields := AClone( ::aColumnBlocks )
   ELSE
     aFields := Array( nWidth )
     AEval( ::aFields, { |c, i| aFields[ i ] := ::ColumnBlock( i ), c } )
   ENDIF

   lColor := ! ( Empty( ::DynamicForeColor ) .AND. Empty( ::DynamicBackColor ) )

   aTemp := Array( nWidth )

   IF ::Visible
      ::SetRedraw( .F. )
   ENDIF

   nCurrentLength  := ::ItemCount
   ::GridForeColor := NIL
   ::GridBackColor := NIL

   IF ::Eof()
      _BrowseRecMap := {}
      ::DeleteAllItems()
   ELSE
      IF ! HB_ISNUMERIC( nRow ) .OR. nRow < 1 .OR. nRow > PageLength
         nRow := 1
      ENDIF

      _BrowseRecMap := Array( nRow )
      _RecNo := ( cWorkArea )->( RecNo() )
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
      ::DbGoTo( _RecNo )
      ::DbSkip()
      DO WHILE Len( _BrowseRecMap ) < PageLength .AND. ! ::Eof()
         AAdd( _BrowseRecMap, ( cWorkArea )->( RecNo() ) )
         ::DbSkip()
      ENDDO
      IF HB_ISLOGICAL( lComplete ) .AND. lComplete
         DO WHILE Len( _BrowseRecMap ) < PageLength
            ::DbGoTo( _BrowseRecMap[ 1 ] )
            ::DbSkip( -1 )
            IF ::Bof()
               EXIT
            ENDIF
            AAdd( _BrowseRecMap, NIL )
            AIns( _BrowseRecMap, 1 )
            _BrowseRecMap[ 1 ] := ( cWorkArea )->( RecNo() )
         ENDDO
      ENDIF
      FOR x := 1 TO Len( _BrowseRecMap )
         ::DbGoTo( _BrowseRecMap[ x ] )

         AEval( aFields, { |b,i| aTemp[ i ] := _OOHG_Eval( b ) } )

         IF lColor
            ( cWorkArea )->( ::SetItemColor( x, NIL, NIL, aTemp ) )
         ENDIF

         IF nCurrentLength < x
            AddListViewItems( ::hWnd, aTemp )
            nCurrentLength ++
         ELSE
            ListViewSetItem( ::hWnd, aTemp, x )
         ENDIF
      NEXT x
      // Repositions the file as if _BrowseRecMap was builded using successive ::DbSkip() calls
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
         ASize( ::aWidths, nWidth )
      ENDIF
      AEval( ::aWidths, { |x, i| ::ColumnWidth( i, iif( ! HB_ISNUMERIC( x ) .OR. x < 0, 0, x ) ) } )

      IF Len( ::aJust ) != nWidth
         ASize( ::aJust, nWidth )
         AEval( ::aJust, { |x, i| ::aJust[ i ] := iif( ! HB_ISNUMERIC( x ), 0, x ) } )
      ENDIF
      AEval( ::aJust, { |x, i| ::Justify( i, x ) } )

      IF Len( ::aHeaders ) != nWidth
         ASize( ::aHeaders, nWidth )
         AEval( ::aHeaders, { |x, i| ::aHeaders[ i ] := iif( ! ValType( x ) $ "CM", "", x ) } )
      ENDIF
      AEval( ::aHeaders, { |x,i| ::Header( i, x ) } )

      ::LoadHeaderImages( ::aHeaderImage )
   ENDIF

   RETURN NIL

METHOD UpDateColors() CLASS TOBrowse

   LOCAL aTemp, x, aFields, cWorkArea, nWidth, nLen, _RecNo

   ::GridForeColor := NIL
   ::GridBackColor := NIL

   nLen := Len( ::aRecMap )
   IF nLen == 0
      RETURN NIL
   ENDIF

   IF Empty( ::DynamicForeColor ) .AND. Empty( ::DynamicBackColor )
      RETURN NIL
   ENDIF

   cWorkArea := ::WorkArea
   IF Select( cWorkArea ) == 0
      RETURN NIL
   ENDIF

   nWidth := Len( ::aFields )
   aTemp := Array( nWidth )

   IF ::FixBlocks()
     aFields := AClone( ::aColumnBlocks )
   ELSE
     aFields := Array( nWidth )
     AEval( ::aFields, { |c, i| aFields[ i ] := ::ColumnBlock( i ), c } )
   ENDIF

   _RecNo := ( cWorkArea )->( RecNo() )

   IF ::Visible
      ::SetRedraw( .F. )
   ENDIF

   FOR x := 1 TO nLen
      ::DbGoTo( ::aRecMap[ x ] )
      AEval( aFields, { |b, i| aTemp[ i ] := _OOHG_Eval( b ) } )
      ( cWorkArea )->( ::SetItemColor( x, NIL, NIL, aTemp ) )
   NEXT x

   IF ::Visible
      ::SetRedraw( .T. )
   ENDIF

   ::DbGoTo( _RecNo )

   RETURN NIL

METHOD PageDown( lAppend ) CLASS TOBrowse

   LOCAL _RecNo, s, cWorkArea, lRet := .F.

   s := ::CurrentRow

   IF s >= Len( ::aRecMap )
      cWorkArea := ::WorkArea
      IF Select( cWorkArea ) == 0
         RETURN lRet
      ENDIF

      _RecNo := ( cWorkArea )->( RecNo() )

      IF Len( ::aRecMap ) == 0
         ::TopBottom( GO_BOTTOM )
         ::DbSkip( - ::CountPerPage + 1 )
      ELSE
         ::DbGoTo( ::aRecMap[ Len( ::aRecMap ) ] )
         // Check FOR more records
         ::DbSkip()
         IF ::Eof()
            ::DbGoTo( _RecNo )
            ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
            IF lAppend
               lRet := ::AppendItem()
               IF ::VScroll:Enabled
                  // Kill scrollbar's events...
                  ::VScroll:Enabled := .F.
                  ::VScroll:Enabled := .T.
               ENDIF
            ENDIF
            RETURN lRet
         ENDIF
         ::DbSkip( -1 )
      ENDIF
      ::Update()
      ::DbGoTo( _RecNo )
      ::CurrentRow := Len( ::aRecMap )
      IF Len( ::aRecMap ) != 0
         lRet := .T.
      ENDIF
   ELSE
      ::FastUpdate( ::CountPerPage - s, Len( ::aRecMap ) )
      lRet := .T.
   ENDIF

   ::BrowseOnChange()

   RETURN lRet

METHOD PageUp() CLASS TOBrowse

   LOCAL _RecNo, cWorkArea, lRet := .F.

   IF ::CurrentRow == 1
      cWorkArea := ::WorkArea
      IF Select( cWorkArea ) == 0
         RETURN lRet
      ENDIF
      _RecNo := ( cWorkArea )->( RecNo() )
      IF Len( ::aRecMap ) == 0
         ::TopBottom( GO_TOP )
      ELSE
         ::DbGoTo( ::aRecMap[ 1 ] )
      ENDIF
      ::DbSkip( - ::CountPerPage + 1 )
      ::Update()
      ::DbGoTo( _RecNo )
      ::CurrentRow := 1
      IF Len( ::aRecMap ) != 0
         lRet := .T.
      ENDIF
   ELSE
      ::FastUpdate( 1 - ::CurrentRow, 1 )
      lRet := .T.
   ENDIF

   ::BrowseOnChange()

   RETURN lRet

METHOD Home() CLASS TOBrowse                         // METHOD GoTop

   LOCAL _RecNo, cWorkArea, lRet := .F.

   cWorkArea := ::WorkArea
   IF Select( cWorkArea ) == 0
      RETURN lRet
   ENDIF
   _RecNo := ( cWorkArea )->( RecNo() )
   ::TopBottom( GO_TOP )
   ::Update()
   ::DbGoTo( _RecNo )
   ::CurrentRow := 1
   IF Len( ::aRecMap ) != 0
      lRet := .T.
   ENDIF

   ::BrowseOnChange()

   RETURN lRet

METHOD End( lAppend ) CLASS TOBrowse                 // METHOD GoBottom

   LOCAL _RecNo, _BottomRec, cWorkArea

   cWorkArea := ::WorkArea
   IF Select( cWorkArea ) == 0
      RETURN .F.
   ENDIF
   _RecNo := ( cWorkArea )->( RecNo() )
   ::TopBottom( GO_BOTTOM )
   _BottomRec := ( cWorkArea )->( RecNo() )

   // If it's for APPEND, leaves a blank line ;)
   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   ::DbSkip( - ::CountPerPage + IF( lAppend, 2, 1 ) )
   ::Update( 1, .F. )
   ::DbGoTo( _RecNo )
   ::CurrentRow := aScan( ::aRecMap, _BottomRec )

   ::BrowseOnChange()

   RETURN .T.

METHOD Up() CLASS TOBrowse

   LOCAL s, _RecNo, nLen, lRet := .F., cWorkArea

   s := ::CurrentRow

   IF s <= 1
      cWorkArea := ::WorkArea
      IF Select( cWorkArea ) == 0
         RETURN lRet
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
            RETURN lRet
         ENDIF
         // Add one record at the top
         AAdd( ::aRecMap, NIL )
         AIns( ::aRecMap, 1 )
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
            ASize( ::aRecMap, nLen - 1 )
         ENDIF
         IF ::Visible
            ::SetRedraw( .T. )
         ENDIF
      ENDIF

      ::DbGoTo( _RecNo )
      ::CurrentRow := 1
      IF Len( ::aRecMap ) != 0
         lRet := .T.
      ENDIF
   ELSE
      ::FastUpdate( -1, s - 1 )
      lRet := .T.
   ENDIF

   ::BrowseOnChange()

   RETURN lRet

METHOD Down( lAppend ) CLASS TOBrowse

   LOCAL s, _RecNo, nLen, lRet := .F., cWorkArea

   s := ::CurrentRow

   IF s >= Len( ::aRecMap )
      cWorkArea := ::WorkArea
      IF Select( cWorkArea ) == 0
         RETURN lRet
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
               lRet := ::AppendItem()
               IF ::VScroll:Enabled
                  // Kill scrollbar's events...
                  ::VScroll:Enabled := .F.
                  ::VScroll:Enabled := .T.
               ENDIF
            ENDIF
            RETURN lRet
         ENDIF
         // Add one record at the bottom
         AAdd( ::aRecMap, ( cWorkArea )->( RecNo() ) )
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

      ::DbGoTo( _RecNo )
      ::CurrentRow := Len( ::aRecMap )
      IF Len( ::aRecMap ) != 0
         lRet := .T.
      ENDIF
   ELSE
      ::FastUpdate( 1, s + 1 )
      lRet := .T.
   ENDIF

   ::BrowseOnChange()

   RETURN lRet

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

   RETURN NIL

METHOD DbSkip( nRows ) CLASS TOBrowse

   LOCAL cWorkArea := ::WorkArea

   ASSIGN nRows VALUE nRows TYPE "N" DEFAULT 1
   IF ! ::lDescending
      ( cWorkArea )->( dbSkip( nRows ) )
      ::Bof := ( cWorkArea )->( Bof() )
      ::Eof := ( cWorkArea )->( Eof() ) .OR. ( ( cWorkArea )->( RecNo() ) > ( cWorkArea )->( RecCount() ) )
   ELSE
      ( cWorkArea )->( dbSkip( - nRows ) )
      IF ( cWorkArea )->( Eof() )
         ( cWorkArea )->( dbGoBottom() )
         ::Bof := .T.
         ::Eof := ( cWorkArea )->( Eof() )
      ELSEIF ( cWorkArea )->( Bof() )
         ::Eof := .T.
         ::DbGoTo( 0 )
      ENDIF
   ENDIF

   RETURN NIL

METHOD DbGoTo( nRecNo ) CLASS TOBrowse

   LOCAL cWorkArea := ::WorkArea

   ( cWorkArea )->( dbGoto( nRecNo ) )
   ::Bof := .F.
   ::Eof := ( cWorkArea )->( Eof() ) .OR. ( ( cWorkArea )->( RecNo() ) > ( cWorkArea )->( RecCount() ) )

   RETURN NIL

METHOD SetValue( Value, mp ) CLASS TOBrowse

   LOCAL _RecNo, m, cWorkArea

   cWorkArea := ::WorkArea
   IF Select( cWorkArea ) == 0
      RETURN NIL
   ENDIF

   IF Value <= 0
      IF ::lNoneUnsels
         ::CurrentRow := 0
         ::BrowseOnChange()
      ENDIF
      RETURN NIL
   ENDIF

   IF _OOHG_ThisEventType == 'BROWSE_ONCHANGE'
      IF ::hWnd == _OOHG_ThisControl:hWnd
         MsgOOHGError( "BROWSE: Value property can't be changed inside ON CHANGE event. Program terminated." )
      ENDIF
   ENDIF

   IF Value > ( cWorkArea )->( RecCount() )
      ::DeleteAllItems()
      ::BrowseOnChange()
      RETURN NIL
   ENDIF

   IF ValType( mp ) != "N" .OR. mp < 1
      m := Int( ::CountPerPage / 2 )
   ELSE
      m := mp
   ENDIF

   _RecNo := ( cWorkArea )->( RecNo() )

   ::DbGoTo( Value )
   IF ::Eof()
      ::DbGoTo( _RecNo )
      RETURN NIL
   ENDIF

   // Enforce filters in use
   ::DbSkip()
   ::DbSkip( -1 )
   IF ( cWorkArea )->( RecNo() ) != Value
      ::DbGoTo( _RecNo )
      RETURN NIL
   ENDIF

   ::DbSkip( 1 - m )
   ::Update()
   ::DbGoTo( _RecNo )
   ::CurrentRow := AScan( ::aRecMap, Value )

   _OOHG_ThisEventType := 'BROWSE_ONCHANGE'
   ::BrowseOnChange()
   _OOHG_ThisEventType := ''

   RETURN NIL

METHOD Delete() CLASS TOBrowse

   LOCAL Value, _RecNo, lSync, cWorkArea

   Value := ::Value

   IF Value == 0
      RETURN NIL
   ENDIF

   cWorkArea := ::WorkArea
   _RecNo := ( cWorkArea )->( RecNo() )

   ::DbGoTo( Value )

   IF ::Lock .AND. ! ( cWorkArea )->( Rlock() )
      MsgExclamation( _OOHG_Messages( MT_BRW_ERR, 9 ), _OOHG_Messages( MT_BRW_MSG, 2 ) )
   ELSE
      ( cWorkArea )->( DbDelete() )

      // Do before unlocking record or moving record pointer
      // so block can operate on deleted record (e.g. TO copy TO a log).
      IF HB_ISBLOCK( ::OnDelete )
         ::DoEvent( ::OnDelete, 'DELETE' )
      ENDIF

      IF ::Lock
         ( cWorkArea )->( dbCommit() )
         ( cWorkArea )->( dbUnlock() )
      ENDIF
      ::DbSkip()
      IF ::Eof()
         ::TopBottom( GO_BOTTOM )
      ENDIF

      IF Set( _SET_DELETED )
         ::SetValue( ( cWorkArea )->( RecNo() ), ::CurrentRow )
      ENDIF
   ENDIF

   IF HB_ISLOGICAL( ::SyncStatus )
      lSync := ::SyncStatus
   ELSE
      lSync := _OOHG_BrowseSyncStatus
   ENDIF

   IF lSync
      IF ( cWorkArea )->( RecNo() ) != ::Value
         ::DbGoTo( ::Value )
      ENDIF
   ELSE
      ::DbGoTo( _RecNo )
   ENDIF

   RETURN NIL

METHOD DeleteItem( nItem ) CLASS TOBrowse

   _OOHG_DeleteArrayItem( ::GridForeColor, nItem )
   _OOHG_DeleteArrayItem( ::GridBackColor, nItem )

   RETURN ListViewDeleteString( ::hWnd, nItem )

METHOD EditItem_B( lAppend ) CLASS TOBrowse

   LOCAL _RecNo, nItem, cWorkArea, lRet, nNewRec

   IF ::FirstVisibleColumn == 0
      RETURN .F.
   ENDIF

   cWorkArea := ::WorkArea
   IF Select( cWorkArea ) == 0
      RETURN .F.
   ENDIF

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.

   nItem := ::CurrentRow
   IF nItem == 0 .AND. ! lAppend
      RETURN .F.
   ENDIF

   _RecNo := ( cWorkArea )->( RecNo() )

   IF ! lAppend
      ::DbGoTo( ::aRecMap[ nItem ] )
   ENDIF

   lRet := ::Super:EditItem_B( lAppend )

   IF lRet .AND. lAppend
      nNewRec := ( cWorkArea )->( RecNo() )
      ::DbGoTo( _RecNo )
      ::Value := nNewRec
   ELSE
      ::DbGoTo( _RecNo )
   ENDIF

   RETURN lRet

METHOD EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, lAppend, nOnFocusPos, lRefresh, lChange ) CLASS TOBrowse

   LOCAL lRet, _RecNo, cWorkArea, lBefore

   ASSIGN lAppend  VALUE lAppend  TYPE "L" DEFAULT .F.
   ASSIGN nRow     VALUE nRow     TYPE "N" DEFAULT ::CurrentRow
   ASSIGN lRefresh VALUE lRefresh TYPE "L" DEFAULT ( ::RefreshType == REFRESH_FORCE )
   ASSIGN lChange  VALUE lChange  TYPE "L" DEFAULT ::lChangeBeforeEdit

   IF nRow < 1 .OR. nRow > ::ItemCount
      RETURN .F.
   ENDIF

   cWorkArea := ::WorkArea
   IF Select( cWorkArea ) == 0
      RETURN .F.
   ENDIF

   IF lAppend
      _RecNo := ( cWorkArea )->( RecNo() )
      ::DbGoTo( 0 )
   ELSE
      IF lChange
         ::Value := ::aRecMap[ nRow ]
      ENDIF
      _RecNo := ( cWorkArea )->( RecNo() )
      ::DbGoTo( ::aRecMap[ nRow ] )
   ENDIF

   lBefore := ::lCalledFromClass
   ::lCalledFromClass := .T.
   lRet := ::Super:EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, nOnFocusPos, .F., lAppend )
   ::lCalledFromClass := lBefore

   IF lRet .AND. lAppend
      AAdd( ::aRecMap, ( cWorkArea )->( RecNo() ) )
   ENDIF

   // ::Super:EditCell refreshes the current row only,
   // so here we must refresh entire grid when ::RefreshType == REFRESH_FORCE

   ::DbGoTo( _RecNo )

   IF lRet
      IF lAppend .AND. lChange
         ::Value := ATail( ::aRecMap )
      ELSE
         IF ! ::lCalledFromClass .AND. ::bPosition == 9                  // MOUSE EXIT
            // Editing window lost focus
            ::bPosition := 0                   // This restores the processing of click messages
            IF ::nDelayedClick[ 1 ] > 0
               // A click message was delayed
               IF ::nDelayedClick[ 3 ] <= 0
                  ::SetValue( ::aRecMap[ ::nDelayedClick[ 1 ] ], ::nDelayedClick[ 1 ] )
               ENDIF

               IF ::nDelayedClick[ 4 ] == NIL
                  IF HB_ISBLOCK( ::OnClick )
                     IF ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                        IF ! ::NestedClick
                           ::NestedClick := ! _OOHG_NestedSameEvent()
                           ::DoEventMouseCoords( ::OnClick, "CLICK" )
                           ::NestedClick := .F.
                        ENDIF
                     ENDIF
                  ENDIF
               ELSE
                  IF HB_ISBLOCK( ::OnRClick )
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
               IF ! ::nDelayedClick[ 4 ] == NIL .AND. ::ContextMenu != NIL .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0 )
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

   LOCAL lRet, lSomethingEdited, lRowAppended, _RecNo, cWorkArea

   ASSIGN lOneRow VALUE lOneRow TYPE "L" DEFAULT .T.
   IF ::FullMove .OR. ! lOneRow
      RETURN ::EditGrid( nRow, nCol, lAppend, lOneRow, lChange, lRefresh )
   ENDIF
   IF ::FirstVisibleColumn == 0
      RETURN .F.
   ENDIF
   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   IF ! HB_ISNUMERIC( nCol )
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
      IF ! HB_ISNUMERIC( nRow )
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
      _RecNo := ( cWorkArea )->( RecNo() )
      IF lAppend
         ::DbGoTo( 0 )
      ELSE
         ::DbGoTo( ::aRecMap[ nRow ] )
      ENDIF

      _OOHG_ThisItemCellValue := ::Cell( nRow, nCol )

      IF ::IsColumnReadOnly( nCol, nRow )
        // Read only column
      ELSEIF ! ::IsColumnWhen( nCol, nRow )
        // WHEN RETURNed .F.
      ELSEIF AScan( ::aHiddenCols, nCol, nRow ) > 0
        // Hidden column
      ELSE
         ::DbGoTo( _RecNo )

         ::lCalledFromClass := .T.
         lRet := ::EditCell( nRow, nCol, NIL, NIL, NIL, NIL, lAppend, NIL, .F., .F. )
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

               IF ::nDelayedClick[ 4 ] == NIL
                  IF HB_ISBLOCK( ::OnClick )
                     IF ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                        IF ! ::NestedClick
                           ::NestedClick := ! _OOHG_NestedSameEvent()
                           ::DoEventMouseCoords( ::OnClick, "CLICK" )
                           ::NestedClick := .F.
                        ENDIF
                     ENDIF
                  ENDIF
               ELSE
                  IF HB_ISBLOCK( ::OnRClick )
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
               IF ! ::nDelayedClick[ 4 ] == NIL .AND. ::ContextMenu != NIL .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0 )
                  ::ContextMenu:Cargo := ::nDelayedClick[ 4 ]
                  ::ContextMenu:Activate()
               ENDIF
            ELSEIF lRowAppended
               // A new row was added and partially edited: set as new value and refresh the control
               ::SetValue( ATail( ::aRecMap ), nRow )
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

   LOCAL lRet := .T., lRowEdited, lSomethingEdited, _RecNo, lRowAppended, nNewRec, nNextRec, cWorkArea

   IF ::FirstVisibleColumn == 0
      RETURN .F.
   ENDIF
   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   IF ! HB_ISNUMERIC( nCol )
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
      IF ! HB_ISNUMERIC( nRow )
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
         _RecNo := ( cWorkArea )->( RecNo() )
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
           // When returned .F., skip
         ELSEIF AScan( ::aHiddenCols, nCol, nRow ) > 0
           // Hidden column, skip
         ELSE
            ::DbGoTo( _RecNo )

            ::lCalledFromClass := .T.
            lRet := ::EditCell( nRow, nCol, NIL, NIL, NIL, NIL, lAppend, NIL, .F., .F. )
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

      // See what TO do NEXT
      IF Select( cWorkArea ) == 0
         EXIT
      ELSEIF ! lRet
         // The last column was not edited
         IF lRowAppended
            // A new row was added and partially edited: set as new value and refresh the control
            ::SetValue( ATail( ::aRecMap ), nRow )
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

            IF ::nDelayedClick[ 4 ] == NIL
               IF HB_ISBLOCK( ::OnClick )
                  IF ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                     IF ! ::NestedClick
                        ::NestedClick := ! _OOHG_NestedSameEvent()
                        ::DoEventMouseCoords( ::OnClick, "CLICK" )
                        ::NestedClick := .F.
                     ENDIF
                  ENDIF
               ENDIF
            ELSE
               IF HB_ISBLOCK( ::OnRClick )
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
            IF ! ::nDelayedClick[ 4 ] == NIL .AND. ::ContextMenu != NIL .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0 )
               ::ContextMenu:Cargo := ::nDelayedClick[ 4 ]
               ::ContextMenu:Activate()
            ENDIF
         ELSEIF lRowAppended
            // A new row was added and partially edited: set as new value and refresh the control
            ::SetValue( ATail( ::aRecMap ), nRow )
         ELSE
            // The user aborted the edition of an existing row: refresh the control without changing it's value
         ENDIF
         IF lRefresh
            ::Refresh()
         ENDIF
         EXIT
      ELSEIF ( HB_ISLOGICAL( lOneRow ) .AND. lOneRow ) .OR. ( ! HB_ISLOGICAL( lOneRow ) .AND. ! ::FullMove ) .OR. ( lRowAppended .AND. ! ::AllowAppend )
         // Stop if it's not fullmove or
         // if caller wants TO edit only one row or
         // if, after appending a new row, appends are not allowed anymore
         IF lRowAppended
            // A new row was added and fully edited: set as new value and refresh the control
            ::SetValue( ATail( ::aRecMap ), nRow )
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
            _RecNo := ( cWorkArea )->( RecNo() )
            nNewRec := ::aRecMap[ nRow + 1 ]
            ::DbGoTo( nNewRec )
            ::Update( nRow + 1 )
            ::DbGoTo( _RecNo )
            nRow := AScan( ::aRecMap, nNewRec )
            ::CurrentRow := nRow
         ELSE
            nRow ++
            ::FastUpdate( 1, nRow )
         ENDIF
         ::BrowseOnChange()
      ELSEIF nRow < ::CountPerPage
         IF ::AllowAppend
            // next visible row is blank, append new record
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
            _RecNo := ( cWorkArea )->( RecNo() )
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
            ::DbGoTo( _RecNo )
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
            _RecNo := ( cWorkArea )->( RecNo() )
            ::DbGoTo( nNextRec )
            IF lRefresh
               ::Update( nRow )
               nRow := AScan( ::aRecMap, nNextRec )
               ::CurrentRow := nRow
            ELSE
               DO WHILE ::ItemCount >= ::CountPerPage
                  ::DeleteItem( 1 )
                  _OOHG_DeleteArrayItem( ::aRecMap, 1 )
               ENDDO
               AAdd( ::aRecMap, nNextRec )
               ::RefreshRow( nRow )
               ::CurrentRow := nRow
            ENDIF
            ::DbGoTo( _RecNo )
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

   IF HB_ISLOGICAL( ::SyncStatus )
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

   RETURN NIL

METHOD DoChange() CLASS TOBrowse

   ::nRecLastValue := ::Value
   ::TGrid:DoChange()

   RETURN NIL

METHOD FastUpdate( d, nRow ) CLASS TOBrowse

   /* This method is intended to be called by the class
    * and must be followed by ::BrowseOnChange before
    * returning to the calling program so the position
    * of the DFB and ::nRecLastValue are updated and
    * the OnChange event is fired.
    */

   IF nRow < 1 .OR. nRow > Len( ::aRecMap )
      ListView_ClearCursel( ::hWnd, 0 )
   ELSE
      ListView_SetCursel( ::hWnd, nRow )
      IF ! ::lNoVSB
         ::VScroll:Value += d
      ENDIF
   ENDIF
   ::nRowPos := ::FirstSelectedItem

   RETURN NIL

METHOD VScrollUpdate() CLASS TOBrowse

   LOCAL cWorkArea, nRecCount, nRecNo, _RecNo, nPos

   IF ! ::lNoVSB .AND. HB_ISOBJECT( ::VScroll ) .AND. ::VScroll:Enabled
      cWorkArea := ::WorkArea
      IF Select( cWorkArea ) == 0
         RETURN NIL
      ENDIF

      IF Len( ::aRecMap ) == 0
         ::VScroll:RangeMax := ::VScroll:RangeMin
         ::VScroll:Value    := ::VScroll:RangeMax
         RETURN NIL
      ENDIF

      IF ::lRecCount
         nRecCount := ( cWorkArea )->( RecCount() )
      ELSE
         nRecCount := ( cWorkArea )->( ordKeyCount() )
         IF nRecCount == 0
            nRecCount := ( cWorkArea )->( RecCount() )
         ENDIF
      ENDIF
      IF nRecCount == 0
         ::VScroll:RangeMax := ::VScroll:RangeMin
         ::VScroll:Value    := ::VScroll:RangeMax
         RETURN NIL
      ENDIF

      _RecNo := ( cWorkArea )->( RecNo() )

      IF ::nRowPos > 0 .AND. ::nRowPos <= Len( ::aRecMap )
         nRecNo := ::aRecMap[ ::nRowPos ]
      ELSEIF ::nRecLastValue > 0 .AND. AScan( ::aRecMap, ::nRecLastValue ) > 0
         nRecNo := ::nRecLastValue
      ELSE
         nRecNo := ::aRecMap[ 1 ]
      ENDIF
      ::DbGoTo( nRecNo )
      nPos := ( cWorkArea )->( ordKeyNo() )

      ::DbGoTo( _RecNo )

      IF ::lDescending
         nPos := nRecCount - nPos + 1
      ENDIF

      IF nRecCount < 1000
         ::VScroll:RangeMax := nRecCount
         ::VScroll:Value := nPos
      ELSE
         ::VScroll:RangeMax := 1000
         ::VScroll:Value := Int( nPos * 1000 / nRecCount )
      ENDIF
   ENDIF

   RETURN NIL

METHOD CurrentRow( nValue ) CLASS TOBrowse

   IF ValType( nValue ) == "N"
      IF nValue < 1 .OR. nValue > ::ItemCount
         ListView_ClearCursel( ::hWnd, 0 )
      ELSE
         ListView_SetCursel( ::hWnd, nValue )
      ENDIF
      ::nRowPos := ::FirstSelectedItem
      ::VScrollUpdate()
      RETURN ::nRowPos
   ENDIF

   RETURN ::FirstSelectedItem

METHOD Refresh() CLASS TOBrowse

   LOCAL s, _RecNo, v, cWorkArea

   cWorkArea := ::WorkArea
   IF Select( cWorkArea ) == 0
      ::DeleteAllItems()
      RETURN NIL
   ENDIF

   _RecNo := ( cWorkArea )->( RecNo() )

   v := ::nRecLastValue
   IF v <= 0
      v := _RecNo
   ENDIF
   ::DbGoTo( v )

   s := ::CurrentRow
   IF s <= 1
      ::DbSkip()
      ::DbSkip( -1 )
      IF ( cWorkArea )->( RecNo() ) != v
         ::DbSkip()
      ENDIF
   ENDIF

   IF s == 0
      IF ( cWorkArea )->( IndexOrd() ) != 0
         IF ( cWorkArea )->( ordKeyVal() ) == NIL
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
      RETURN NIL
   ENDIF

   v := ( cWorkArea )->( RecNo() )

   IF s != 0
      ::DbSkip( - s + 1 )
   ENDIF

   ::Update()

   ::CurrentRow := AScan( ::aRecMap, v )

   ::DbGoTo( _RecNo )

   // Don't call ::BrowseOnChange, the record wasn't changed.

   RETURN NIL

METHOD Value( uValue ) CLASS TOBrowse

   IF ValType( uValue ) == "N"
      ::SetValue( uValue )
   ENDIF
   IF Select( ::WorkArea ) == 0
      uValue := 0
   ELSE
      ::nRowPos := ::CurrentRow
      IF ::nRowPos > 0 .AND. ::nRowPos <= Len( ::aRecMap )
         uValue := ::aRecMap[ ::nRowPos ]
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
         ::uIniTime := hb_MilliSeconds()
         ::cText := Upper( Chr( wParam  ) )
      ELSEIF hb_MilliSeconds() > ::uIniTime + ::SearchLapse
         ::uIniTime := hb_MilliSeconds()
         ::cText := Upper( Chr( wParam  ) )
      ELSE
         ::uIniTime := hb_MilliSeconds()
         ::cText += Upper( Chr( wParam  ) )
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
           uGridValue := _OOHG_Eval( ::aColumnBlocks[ ::SearchCol ], cWorkArea )
         ELSE
           uGridValue := _OOHG_Eval( ::ColumnBlock( ::SearchCol ), cWorkArea )
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
              uGridValue := _OOHG_Eval( ::aColumnBlocks[ ::SearchCol ], cWorkArea )
            ELSE
              uGridValue := _OOHG_Eval( ::ColumnBlock( ::SearchCol ), cWorkArea )
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

      IF ::Eof()
         ::DbGoTo( _RecNo )
      ELSE
         ::Value := ( cWorkArea )->( RecNo() )      
      ENDIF

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
         IF HB_ISBLOCK( ::OnDblClick )
            ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
         ENDIF
      ELSEIF ::IsColumnReadOnly( _OOHG_ThisItemColIndex, _OOHG_ThisItemRowIndex )
         // Cell is readonly
         IF ::lExtendDblClick .and. HB_ISBLOCK( ::OnDblClick )
            ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
         ENDIF
      ELSEIF ! ::IsColumnWhen( _OOHG_ThisItemColIndex, _OOHG_ThisItemRowIndex )
         // Not a valid WHEN
         IF ::lExtendDblClick .and. HB_ISBLOCK( ::OnDblClick )
            ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
         ENDIF
      ELSEIF AScan( ::aHiddenCols, _OOHG_ThisItemColIndex ) > 0
         // Cell is in a hidden column
         IF ::lExtendDblClick .and. HB_ISBLOCK( ::OnDblClick )
            ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
         ENDIF
      ELSEIF ::FullMove
         ::EditGrid( _OOHG_ThisItemRowIndex, _OOHG_ThisItemColIndex )
      ELSE
         ::EditCell( _OOHG_ThisItemRowIndex, _OOHG_ThisItemColIndex, NIL, NIL, NIL, NIL, .F. )
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

   LOCAL nvKey, r, DeltaSelect, lGo, uValue, nNotify := GetNotifyCode( lParam ), aCellData

   IF nNotify == NM_CLICK
      IF ::lCheckBoxes
         // detect item
         uValue := ListView_HitOnCheckBox( ::hWnd, GetCursorRow() - GetWindowRow( ::hWnd ), GetCursorCol() - GetWindowCol( ::hWnd ) )
      ELSE
         uValue := 0
      ENDIF

      IF ::bPosition == -2 .OR. ::bPosition == 9
         ::nDelayedClick := { ::CurrentRow, 0, uValue, NIL }
         ::CurrentRow := ::nEditRow
      ELSE
         IF HB_ISBLOCK( ::OnClick )
            IF ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. uValue <= 0
               IF ! ::NestedClick
                  ::NestedClick := ! _OOHG_NestedSameEvent()
                  IF uValue <= 0
                     aCellData := ListView_ItemActivate( lParam )
                     IF aCellData[ 1 ] > 0 .AND. aCellData[ 1 ] <= Len( ::aRecMap )
                        aCellData[ 1 ] := ::aRecMap[ aCellData[ 1 ] ]
                     ELSE
                        aCellData[ 1 ] := 0
                     ENDIF
                  ELSE
                     aCellData := { uValue, 0 }
                  ENDIF
                  ::DoEventMouseCoords( ::OnClick, "CLICK", aCellData )
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
         IF HB_ISBLOCK( ::OnRClick )
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
         IF ::ContextMenu != NIL .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. uValue <= 0 )
            ::ContextMenu:Cargo := _GetGridCellData( Self, ListView_ItemActivate( lParam ) )
            ::ContextMenu:Activate()
         ENDIF
      ENDIF

      // skip default action
      RETURN 1

   ELSEIF nNotify == LVN_BEGINDRAG
      IF ::bPosition == -2 .OR. ::bPosition == 9
         ::nDelayedClick := { ::CurrentRow, 0, 0, NIL }
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
            IF HB_ISBLOCK( ::bDelWhen )
               lGo := _OOHG_Eval( ::bDelWhen )
            ELSE
               lGo := .T.
            ENDIF

            IF lGo
               IF ::lNoDelMsg
                  ::Delete()
               ELSEIF MsgYesNo( _OOHG_Messages( MT_BRW_MSG, 1 ), _OOHG_Messages( MT_BRW_MSG, 2 ) )
                  ::Delete()
               ENDIF
            ELSEIF ! Empty( ::DelMsg )
               MsgExclamation( ::DelMsg, _OOHG_Messages( MT_BRW_MSG, 2) )
            ENDIF
         ENDIF
      ENDCASE
      RETURN NIL

   ELSEIF nNotify == LVN_ITEMCHANGED
      IF GetGridOldState( lParam ) == 0 .and. GetGridNewState( lParam ) != 0
         RETURN NIL
      ENDIF

   ELSEIF nNotify == NM_CUSTOMDRAW
      IF ::lNeedsAdjust .AND. ::lEndTrack
         // This fires WM_NCCALCSIZE
         SetWindowPos( ::hWnd, 0, 0, 0, 0, 0, SWP_NOACTIVATE + SWP_NOSIZE + SWP_NOMOVE + SWP_NOZORDER + SWP_FRAMECHANGED + SWP_NOCOPYBITS + SWP_NOOWNERZORDER + SWP_NOSENDCHANGING )
      ENDIF
      RETURN TGrid_Notify_CustomDraw( Self, lParam, .F., NIL, NIL, .F., ::lFocusRect, ::lNoGrid, ::lPLM )

   ENDIF

   RETURN ::Super:Events_Notify( wParam, lParam )

METHOD SetScrollPos( nPos, VScroll ) CLASS TOBrowse

   LOCAL cWorkArea, nRecCount, nNewRec

   cWorkArea := ::WorkArea
   IF Select( cWorkArea ) == 0
      // No workarea is selected
   ELSEIF nPos <= VScroll:RangeMin
      ::GoTop()
   ELSEIF nPos >= VScroll:RangeMax
      ::GoBottom()
   ELSE
      IF ::lRecCount
         nRecCount := ( cWorkArea )->( RecCount() )
      ELSE
         nRecCount := ( cWorkArea )->( ordKeyCount() )
      ENDIF
      IF ::lDescending
         nNewRec := nRecCount + 1 - Max( Int( nPos * nRecCount / VScroll:RangeMax ), 1 )
      ELSE
         nNewRec := Max( Int( nPos * nRecCount / VScroll:RangeMax ), 1 )
      ENDIF
      ::VScroll:Value := nPos
      ( cWorkArea )->( ordKeyGoto( nNewRec ) )
      ::Value := ( cWorkArea )->( RecNo() )
   ENDIF

   RETURN NIL


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TOBrowseByCell FROM TOBrowse

   DATA lFocusRect                INIT .F.
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
      CurrentRow
      DbGoTo
      DbSkip
      Define
      DeleteItem
      FastUpdate
      Refresh
      RefreshData
      VScrollUpdate
      TopBottom
      Update
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
      Define4
      EditItem
      Enabled
      FixBlocks
      FixControls
      GetCellType
      HelpId
      HScrollVisible
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
      EditItem2
      Events_Enter
      FirstColInOrder
      FirstSelectedItem
      FirstVisibleColumn
      FirstVisibleItem
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
                lAltA, lNoShowAlways, lNone, lCBE, lCheckBoxes, lAtFirst, klc, ;
                lLabelTip, lNoHSB, aHeadDblClick, aHeaderColors ) CLASS TOBrowseByCell

   LOCAL nAux

   HB_SYMBOL_UNUSED( InPlace )          // Forced to .T., it's needed for edit controls to work properly
   HB_SYMBOL_UNUSED( lNone )
   HB_SYMBOL_UNUSED( lDisabled )

   ASSIGN lFocusRect VALUE lFocusRect TYPE "L"
   ASSIGN lCBE       VALUE lCBE       TYPE "L" DEFAULT .T.

   ::Define2( ControlName, ParentForm, x, y, w, h, ::aHeaders, ::aWidths, {}, ;
              , fontname, fontsize, tooltip, aHeadClick, nogrid, ;
              aImage, ::aJust, break, HelpId, bold, italic, underline, ;
              strikeout, NIL, NIL, edit, backcolor, ;
              fontcolor, dynamicbackcolor, dynamicforecolor, aPicture, lRtl, ;
              LVS_SINGLESEL, .T., editcontrols, readonly, valid, validmessages, ;
              aWhenFields, NIL, lNoTabStop, lInvisible, lHasHeaders, ;
              aHeaderImage, aHeaderImageAlign, FullMove, aSelectedColors, ;
              aEditKeys, lCheckBoxes, dblbffr, lFocusRect, lPLM, ;
              lFixedCols, lFixedWidths, lLikeExcel, lButtons, AllowDelete, ;
              DelMsg, lNoDelMsg, AllowAppend, lNoModal, lFixedCtrls, ;
              , NIL, lExtDbl, lSilent, lAltA, ;
              lNoShowAlways, .T., lCBE, lAtFirst, klc, lLabelTip, lNoHSB, ;
              aHeadDblClick, aHeaderColors )

   // By default, search in the current column
   ::SearchCol := -1

   IF HB_ISARRAY( Value ) .AND. Len( Value ) > 1
      nAux := Value[ 1 ]
      IF HB_ISNUMERIC( nAux ) .AND. nAux >= 0
         ::nRecLastValue := nAux
      ENDIF
      nAux := Value[ 2 ]
      IF HB_ISNUMERIC( nAux ) .AND. nAux >= 0 .AND. nAux <= Len( ::aHeaders )
         ::nColPos := nAux
      ENDIF
   ENDIF

   RETURN Self

METHOD AddColumn( nColIndex, xField, cHeader, nWidth, nJustify, uForeColor, ;
                  uBackColor, lNoDelete, uPicture, uEditControl, uHeadClick, ;
                  uValid, uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign, ;
                  uReplaceField, lRefresh, uReadOnly, uDefault, uHeadDblClick, ;
                  uHeaderColor ) CLASS TOBrowseByCell

   nColIndex := ::Super:AddColumn( nColIndex, xField, cHeader, nWidth, nJustify, uForeColor, ;
                                   uBackColor, lNoDelete, uPicture, uEditControl, uHeadClick, ;
                                   uValid, uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign, ;
                                   uReplaceField, lRefresh, uReadOnly, uDefault, uHeadDblClick, ;
                                   uHeaderColor )

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

   IF HB_ISARRAY( aSelectedColors )
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

      FOR i := 1 TO 8
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

   LOCAL nItem, nRowPos, nColPos

   IF HB_ISARRAY( uValue ) .AND. Len( uValue ) > 1
      IF HB_ISNUMERIC( uValue[ 1 ] ) .AND. uValue[ 1 ] >= 0
         IF HB_ISNUMERIC( uValue[ 2 ] ) .AND. uValue[ 2 ] >= 0 .AND. uValue[ 2 ] <= Len( ::aHeaders )
            IF ( nItem := AScan( ::aRecMap, uValue[ 1 ] ) ) > 0
               ::SetValue( uValue, nItem )
            ELSE
               ::SetValue( uValue )
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   IF Select( ::WorkArea ) == 0
      uValue := { 0, 0 }
   ELSE
      nRowPos := ::CurrentRow
      nColPos := ::CurrentCol
      IF nRowPos > 0 .AND. nRowPos <= Len( ::aRecMap ) .AND. nColPos >= 1 .AND. nColPos <= Len( ::aHeaders )
         uValue := { ::aRecMap[ nRowPos ], nColPos }
      ELSE
         uValue := { 0, 0 }
      ENDIF
   ENDIF

   RETURN uValue

METHOD MoveToFirstCol CLASS TOBrowseByCell

   LOCAL aBefore, nCol, aAfter, lRet := .F.

   aBefore := ::Value
   nCol := ::FirstColInOrder
   IF nCol # 0
      ::Value := { aBefore[ 1 ], nCol }
      aAfter := ::Value
      lRet := ( aAfter[ 1 ] # aBefore[ 1 ] .OR. aAfter[ 2 ] # aBefore[ 2 ] )
   ENDIF

   RETURN lRet

METHOD MoveToLastCol CLASS TOBrowseByCell

   LOCAL aBefore, nCol, aAfter, lRet := .F.

   aBefore := ::Value
   nCol := ::LastColInOrder
   IF nCol # 0
      ::Value := { aBefore[ 1 ], nCol }
      aAfter := ::Value
      lRet := ( aAfter[ 1 ] # aBefore[ 1 ] .OR. aAfter[ 2 ] # aBefore[ 2 ] )
   ENDIF

   RETURN lRet

METHOD MoveToFirstVisibleCol CLASS TOBrowseByCell

   LOCAL aBefore, nCol, aAfter, lRet := .F.

   aBefore := ::Value
   ::ScrollToPrior()
   nCol := ::FirstVisibleColumn
   IF nCol # 0
      ::Value := { aBefore[ 1 ], nCol }
      aAfter := ::Value
      lRet := ( aAfter[ 1 ] # aBefore[ 1 ] .OR. aAfter[ 2 ] # aBefore[ 2 ] )
   ENDIF

   RETURN lRet

METHOD MoveToLastVisibleCol CLASS TOBrowseByCell

   LOCAL aBefore, nCol, aAfter, lRet := .F.

   aBefore := ::Value
   ::ScrollToPrior()
   nCol := ::LastVisibleColumn
   IF nCol # 0
      ::Value := { aBefore[ 1 ], nCol }
      aAfter := ::Value
      lRet := ( aAfter[ 1 ] # aBefore[ 1 ] .OR. aAfter[ 2 ] # aBefore[ 2 ] )
   ENDIF

   RETURN lRet

METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TOBrowseByCell

   LOCAL cWorkArea, _RecNo, aValue, uGridValue, nRow

   IF nMsg == WM_CHAR
      IF wParam < 32
         ::cText := ""
         RETURN 0
      ELSEIF Empty( ::cText )
         ::uIniTime := HB_MilliSeconds()
         ::cText := Upper( Chr( wParam  ) )
      ELSEIF HB_MilliSeconds() > ::uIniTime + ::SearchLapse
         ::uIniTime := HB_MilliSeconds()
         ::cText := Upper( Chr( wParam  ) )
      ELSE
         ::uIniTime := HB_MilliSeconds()
         ::cText += Upper( Chr( wParam  ) )
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
           uGridValue := _OOHG_Eval( ::aColumnBlocks[ ::SearchCol ], cWorkArea )
         ELSE
           uGridValue := _OOHG_Eval( ::ColumnBlock( ::SearchCol ), cWorkArea )
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
              uGridValue := _OOHG_Eval( ::aColumnBlocks[ ::SearchCol ], cWorkArea )
            ELSE
              uGridValue := _OOHG_Eval( ::ColumnBlock( ::SearchCol ), cWorkArea )
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
         ::nDelayedClick := { aCellData[ 1 ], aCellData[ 2 ], uValue, NIL }
         ::CurrentRow := ::nEditRow
      ELSE
         IF HB_ISBLOCK( ::OnClick )
            IF ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. uValue <= 0
               IF ! ::NestedClick
                  ::NestedClick := ! _OOHG_NestedSameEvent()
                  IF uValue <= 0
                     aCellData := ListView_ItemActivate( lParam )
                     IF aCellData[ 1 ] > 0 .AND. aCellData[ 1 ] <= Len( ::aRecMap )
                        aCellData[ 1 ] := ::aRecMap[ aCellData[ 1 ] ]
                     ELSE
                        aCellData[ 1 ] := 0
                     ENDIF
                  ELSE
                     aCellData := { uValue, 0 }
                  ENDIF
                  ::DoEventMouseCoords( ::OnClick, "CLICK", aCellData )
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
         IF HB_ISBLOCK( ::OnRClick )
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
         IF ::ContextMenu != NIL .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. uValue <= 0 )
            ::ContextMenu:Cargo := _GetGridCellData( Self, ListView_ItemActivate( lParam ) )
            ::ContextMenu:Activate()
         ENDIF
      ENDIF

      // skip default action
      RETURN 1

   ELSEIF nNotify == LVN_BEGINDRAG
      IF ::bPosition == -2 .OR. ::bPosition == 9
         aCellData := _GetGridCellData( Self, ListView_ListView( lParam ) )
         ::nDelayedClick := { aCellData[ 1 ], aCellData[ 2 ], 0, NIL }
         ::CurrentRow := ::nEditRow
      ELSE
         r := ::CurrentRow
         IF r > 0
            DeltaSelect := r - ::nRowPos
            ::FastUpdate( DeltaSelect, r )
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
            IF HB_ISBLOCK( ::bDelWhen )
               lGo := _OOHG_Eval( ::bDelWhen )
            ELSE
               lGo := .t.
            ENDIF

            IF lGo
               IF ::lNoDelMsg .OR. MsgYesNo( _OOHG_Messages( MT_BRW_MSG, 1 ), _OOHG_Messages( MT_BRW_MSG, 2 ) )
                  ::Delete()
               ENDIF
            ELSEIF ! Empty( ::DelMsg )
               MsgExclamation( ::DelMsg, _OOHG_Messages( MT_BRW_MSG, 2 ) )
            ENDIF
         ENDIF
      ENDCASE
      RETURN NIL

   ELSEIF nNotify == LVN_ITEMCHANGED
      RETURN NIL

   ELSEIF nNotify == NM_CUSTOMDRAW
      IF ::lNeedsAdjust .AND. ::lEndTrack
         // This fires WM_NCCALCSIZE
         SetWindowPos( ::hWnd, 0, 0, 0, 0, 0, SWP_NOACTIVATE + SWP_NOSIZE + SWP_NOMOVE + SWP_NOZORDER + SWP_FRAMECHANGED + SWP_NOCOPYBITS + SWP_NOOWNERZORDER + SWP_NOSENDCHANGING )
      ENDIF
      RETURN TGrid_Notify_CustomDraw( Self, lParam, .T., ::nRowPos, ::nColPos, .F., ::lFocusRect, ::lNoGrid, ::lPLM )

   ENDIF

   RETURN ::Super:Events_Notify( wParam, lParam )

METHOD EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, lAppend, nOnFocusPos, lRefresh, lChange, lKeys ) CLASS TOBrowseByCell

   LOCAL lRet, _RecNo, cWorkArea, lBefore

   ASSIGN lAppend  VALUE lAppend  TYPE "L" DEFAULT .F.
   ASSIGN nRow     VALUE nRow     TYPE "N" DEFAULT ::nRowPos
   ASSIGN nCol     VALUE nCol     TYPE "N" DEFAULT ::nColPos
   ASSIGN lRefresh VALUE lRefresh TYPE "L" DEFAULT ( ::RefreshType == REFRESH_FORCE )
   ASSIGN lChange  VALUE lChange  TYPE "L" DEFAULT ::lChangeBeforeEdit
   ASSIGN lKeys    VALUE lKeys    TYPE "L" DEFAULT .T.

   IF nRow < 1 .OR. nRow > ::ItemCount .OR. nCol < 1 .OR. nCol > Len( ::aHeaders ) .OR. AScan( ::aHiddenCols, nCol ) # 0
      RETURN .F.
   ENDIF

   cWorkArea := ::WorkArea
   IF Select( cWorkArea ) == 0
      RETURN .F.
   ENDIF

   IF lAppend
      _RecNo := ( cWorkArea )->( RecNo() )
      ::DbGoTo( 0 )
   ELSE
      IF lChange
         ::Value := { ::aRecMap[ nRow ], nCol }
      ENDIF
      _RecNo := ( cWorkArea )->( RecNo() )
      ::DbGoTo( ::aRecMap[ nRow ] )
   ENDIF

   lBefore := ::lCalledFromClass
   ::lCalledFromClass := .T.
   lRet := ::TXBrowse:EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, lAppend, nOnFocusPos )
   ::lCalledFromClass := lBefore

   IF lRet .AND. lAppend
      AAdd( ::aRecMap, ( cWorkArea )->( RecNo() ) )
   ENDIF

   ::DbGoTo( _RecNo )

   IF lRet
      IF ! ::lCalledFromClass .AND. ::bPosition == 9                  // MOUSE EXIT
      // Editing window lost focus
         ::bPosition := 0                   // This restores the processing of click messages
         IF ::nDelayedClick[ 1 ] > 0
            // A click message was delayed
            IF ::nDelayedClick[ 3 ] <= 0
               ::SetValue( { ::aRecMap[ ::nDelayedClick[ 1 ] ], ::nDelayedClick[ 2 ] }, ::nDelayedClick[ 1 ] )
            ENDIF

            IF ::nDelayedClick[ 4 ] == NIL
               IF HB_ISBLOCK( ::OnClick )
                  IF ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                     IF ! ::NestedClick
                        ::NestedClick := ! _OOHG_NestedSameEvent()
                        ::DoEventMouseCoords( ::OnClick, "CLICK" )
                        ::NestedClick := .F.
                     ENDIF
                  ENDIF
               ENDIF
            ELSE
               IF HB_ISBLOCK( ::OnRClick )
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
            IF ! ::nDelayedClick[ 4 ] == NIL .AND. ::ContextMenu != NIL .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0 )
               ::ContextMenu:Cargo := ::nDelayedClick[ 4 ]
               ::ContextMenu:Activate()
            ENDIF
         ENDIF
      ELSEIF lAppend
         ::Value := { ATail( ::aRecMap ), nCol }
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
      RETURN .F.
   ENDIF

   IF ::nRowPos == 0 .AND. ! lAppend
      RETURN .F.
   ENDIF

   RETURN ::EditAllCells( NIL, NIL, lAppend, lOneRow, .T., ::RefreshType == REFRESH_DEFAULT .OR. ::RefreshType == REFRESH_FORCE )

METHOD EditAllCells( nRow, nCol, lAppend, lOneRow, lChange, lRefresh ) CLASS TOBrowseByCell

   LOCAL lRet, lSomethingEdited, lRowAppended, _RecNo, cWorkArea, nNextCol

   ASSIGN lOneRow VALUE lOneRow TYPE "L" DEFAULT .T.
   IF ::FullMove .OR. ! lOneRow
      RETURN ::EditGrid( nRow, nCol, lAppend, lOneRow, lChange, lRefresh )
   ENDIF
   IF ::FirstVisibleColumn == 0
      RETURN .F.
   ENDIF
   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   IF ! HB_ISNUMERIC( nCol )
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
      IF ! HB_ISNUMERIC( nRow )
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
      _RecNo := ( cWorkArea )->( RecNo() )
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
      ELSEIF AScan( ::aHiddenCols, ::nColPos, ::nRowPos ) > 0
        // Hidden column
      ELSE
         ::DbGoTo( _RecNo )

         ::lCalledFromClass := .T.
         lRet := ::EditCell( ::nRowPos, ::nColPos, NIL, NIL, NIL, NIL, lAppend, NIL, .F., .F., .F. )
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

               IF ::nDelayedClick[ 4 ] == NIL
                  IF HB_ISBLOCK( ::OnClick )
                     IF ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                        IF ! ::NestedClick
                           ::NestedClick := ! _OOHG_NestedSameEvent()
                           ::DoEventMouseCoords( ::OnClick, "CLICK" )
                           ::NestedClick := .F.
                        ENDIF
                     ENDIF
                  ENDIF
               ELSE
                  IF HB_ISBLOCK( ::OnRClick )
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
               IF ! ::nDelayedClick[ 4 ] == NIL .AND. ::ContextMenu != NIL .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0 )
                  ::ContextMenu:Cargo := ::nDelayedClick[ 4 ]
                  ::ContextMenu:Activate()
               ENDIF
            ELSEIF lRowAppended
               // A new row was added and partially edited: set as new value and refresh the control
               ::SetValue( { ATail( ::aRecMap ), ::nColPos }, ::nRowPos )
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

   LOCAL lSomethingEdited, _RecNo, lRet, lRowAppended, cWorkArea

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
      _RecNo := ( cWorkArea )->( RecNo() )
      IF lAppend
         ::DbGoTo( 0 )
      ELSE
         ::DbGoTo( ::aRecMap[ nRow ] )
      ENDIF

      _OOHG_ThisItemCellValue := ::Cell( nRow, nCol )

      IF ::IsColumnReadOnly( nCol, nRow )
         // Read only column
         ::bPosition := ::NextPosToEdit()
      ELSEIF ! ::IsColumnWhen( nCol, nRow )
         // Not a valid WHEN
         ::bPosition := ::NextPosToEdit()
      ELSEIF AScan( ::aHiddenCols, nCol ) > 0
         // Hidden column
         ::bPosition := ::NextPosToEdit()
      ELSE
         ::DbGoTo( _RecNo )

         lRowAppended := .F.
         ::lCalledFromClass := .T.
         lRet := ::EditCell( nRow, nCol, NIL, NIL, NIL, NIL, lAppend, NIL, lRefresh, .F., .F. )
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

            IF ::nDelayedClick[ 4 ] == NIL
               IF HB_ISBLOCK( ::OnClick )
                  IF ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                     IF ! ::NestedClick
                        ::NestedClick := ! _OOHG_NestedSameEvent()
                        ::DoEventMouseCoords( ::OnClick, "CLICK" )
                        ::NestedClick := .F.
                     ENDIF
                  ENDIF
               ENDIF
            ELSE
               IF HB_ISBLOCK( ::OnRClick )
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
            IF ! ::nDelayedClick[ 4 ] == NIL .AND. ::ContextMenu != NIL .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0 )
               ::ContextMenu:Cargo := ::nDelayedClick[ 4 ]
               ::ContextMenu:Activate()
            ENDIF

            IF lRefresh
               ::Refresh()
            ENDIF
         ELSE
            IF lRowAppended
               // A new row was added and partially edited: set as new value and refresh the control
               ::SetValue( { ATail( ::aRecMap ), nCol }, nRow )
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

   IF HB_ISLOGICAL( ::SyncStatus )
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

   RETURN NIL

METHOD DoChange() CLASS TOBrowseByCell

   LOCAL xValue, cType, cOldType

   xValue   := ::Value
   cType    := ValType( xValue )
   cOldType := ValType( ::xOldValue )
   cType    := If( cType == "M", "C", cType )
   cOldType := If( cOldType == "M", "C", cOldType )

   IF ( cOldType == "U" .OR. ! cType == cOldType .OR. ;
        ( HB_ISARRAY( xValue ) .AND. ! HB_ISARRAY( ::xOldValue ) ) .OR. ;
        ( ! HB_ISARRAY( xValue ) .AND. HB_ISARRAY( ::xOldValue ) ) .OR. ;
        ! AEqual( xValue, ::xOldValue ) )
      ::OldValue  := ::xOldValue
      ::xOldValue := xValue
      ::DoEvent( ::OnChange, "CHANGE" )
   ENDIF

   ::nRecLastValue := xValue[ 1 ]

   RETURN NIL

METHOD SetValue( Value, mp ) CLASS TOBrowseByCell

   LOCAL nRow, nCol, _RecNo, m, cWorkArea

   cWorkArea := ::WorkArea
   IF Select( cWorkArea ) == 0
      RETURN NIL
   ENDIF

   IF _OOHG_ThisEventType == 'BROWSE_ONCHANGE'
      IF ::hWnd == _OOHG_ThisControl:hWnd
         MsgOOHGError( "BROWSEBYCELL: Value property can't be changed inside ONCHANGE event. Program terminated." )
      ENDIF
   ENDIF

   IF HB_ISARRAY( Value ) .AND. Len( Value ) > 1
      nRow := Value[ 1 ]
      nCol := Value[ 2 ]
      IF HB_ISNUMERIC( nRow ) .AND. nRow > 0 .AND. HB_ISNUMERIC( nCol ) .AND. nCol >= 1 .AND. nCol <= Len( ::aHeaders )
         IF nRow > ( cWorkArea )->( RecCount() )
            ::DeleteAllItems()
            ::BrowseOnChange()
            RETURN NIL
         ENDIF

         IF ValType( mp ) != "N" .OR. mp < 1
            m := Int( ::CountPerPage / 2 )
         ELSE
            m := mp
         ENDIF

         _RecNo := ( cWorkArea )->( RecNo() )

         ::DbGoTo( nRow )
         IF ::Eof()
            ::DbGoTo( _RecNo )
            RETURN NIL
         ENDIF

         // Enforce filters in use
         ::DbSkip()
         ::DbSkip( -1 )
         IF ( cWorkArea )->( RecNo() ) != nRow
            ::DbGoTo( _RecNo )
            RETURN NIL
         ENDIF

         ::DbSkip( -m + 1 )
         ::Update()
         ::DbGoTo( _RecNo )
         ::CurrentRow := AScan( ::aRecMap, nRow )
         ::CurrentCol := nCol

         _OOHG_ThisEventType := 'BROWSE_ONCHANGE'
         ::BrowseOnChange()
         _OOHG_ThisEventType := ''
      ELSE
         IF ::lNoneUnsels
            ::CurrentRow := 0
            ::CurrentCol := 0
            ::BrowseOnChange()
         ENDIF
      ENDIF
   ELSE
      IF ::lNoneUnsels
         ::CurrentRow := 0
         ::CurrentCol := 0
         ::BrowseOnChange()
      ENDIF
   ENDIF

   RETURN NIL

METHOD Delete() CLASS TOBrowseByCell

   LOCAL Value, nRow, _RecNo, lSync, cWorkArea

   Value := ::Value
   nRow  := Value[ 1 ]

   IF nRow == 0
      RETURN NIL
   ENDIF

   cWorkArea := ::WorkArea
   _RecNo := ( cWorkArea )->( RecNo() )

   ::DbGoTo( nRow )

   IF ::Lock .AND. ! ( cWorkArea )->( Rlock() )
      MsgExclamation( _OOHG_Messages( MT_BRW_ERR, 9 ), _OOHG_Messages( MT_BRW_MSG, 2 ) )
   ELSE
      ( cWorkArea )->( DbDelete() )

      // Do before unlocking record or moving record pointer
      // so block can operate on deleted record (e.g. to copy to a log).
      IF HB_ISBLOCK( ::OnDelete )
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

   IF HB_ISLOGICAL( ::SyncStatus )
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
      ::DbGoTo( _RecNo )
   ENDIF

   RETURN NIL

METHOD Home() CLASS TOBrowseByCell

   LOCAL lRet

   IF ::lKeysLikeClipper
      lRet := ::MoveToFirstVisibleCol()
   ELSE
      lRet := ::GoTop( ::FirstColInOrder )
   ENDIF

   RETURN lRet

METHOD GoTop( nCol ) CLASS TOBrowseByCell

   LOCAL _RecNo, aBefore, aAfter, lRet := .F., cWorkArea

   cWorkArea := ::WorkArea
   IF Select( cWorkArea ) == 0
      RETURN lRet
   ENDIF
   IF ! HB_ISNUMERIC( nCol )
      IF ::lKeysLikeClipper
         nCol := ::CurrentCol
      ELSE
         nCol := ::FirstColInOrder
      ENDIF
   ENDIF
   aBefore := ::Value
   _RecNo := ( cWorkArea )->( RecNo() )
   ::TopBottom( GO_TOP )
   ::Update()
   ::DbGoTo( _RecNo )
   ::CurrentRow := 1
   ::CurrentCol := nCol
   aAfter := ::Value
   lRet := ( aBefore[ 1 ] # aAfter[ 1 ] .OR. aBefore[ 2 ] # aAfter[ 2 ] )
   ::BrowseOnChange()

   RETURN lRet

METHOD End( lAppend ) CLASS TOBrowseByCell

   LOCAL lRet

   IF ::lKeysLikeClipper
      lRet := ::MoveToLastVisibleCol()
   ELSE
      lRet := ::GoBottom( lAppend, ::LastColInOrder )
   ENDIF

   RETURN lRet

METHOD GoBottom( lAppend, nCol ) CLASS TOBrowseByCell

   LOCAL lRet := .F., aBefore, _Recno, cWorkArea, aAfter

   cWorkArea := ::WorkArea
   IF Select( cWorkArea ) == 0
      RETURN lRet
   ENDIF
   IF ! HB_ISNUMERIC( nCol )
      IF ::lKeysLikeClipper
         nCol := ::CurrentCol
      ELSE
         nCol := ::LastColInOrder
      ENDIF
   ENDIF
   aBefore := ::Value
   _RecNo := ( cWorkArea )->( RecNo() )
   ::TopBottom( GO_BOTTOM )

   // If it's for APPEND, leaves a blank line ;)
   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   ::DbSkip( - ::CountPerPage + If( lAppend, 2, 1 ) )
   ::Update()
   ::DbGoTo( _RecNo )
   ::CurrentRow := Len( ::aRecMap )
   ::CurrentCol := If( lAppend, ::FirstColInOrder, nCol )
   aAfter := ::Value
   lRet := ( aAfter[ 1 ] # aBefore[ 1 ] .OR. aAfter[ 2 ] # aBefore[ 2 ] )
   ::BrowseOnChange()

   RETURN lRet

METHOD PageUp() CLASS TOBrowseByCell

   LOCAL _RecNo, s, aBefore, lRet := .F., cWorkArea, aAfter

   s := ::nRowPos

   IF s == 1 .OR. ::lKeysLikeClipper
      cWorkArea := ::WorkArea
      IF Select( cWorkArea ) == 0
         RETURN lRet
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
      ::Update()
      ::DbGoTo( _RecNo )
      IF ! ::lKeysLikeClipper .OR. s > Len( ::aRecMap )
         s := 1
      ENDIF
      ::CurrentRow := s
      aAfter := ::Value
      lRet := ( aAfter[ 1 ] # aBefore[ 1 ] .OR. aAfter[ 2 ] # aBefore[ 2 ] )
   ELSE
      ::FastUpdate( 1 - ::nRowPos, 1 )
      lRet := .T.
   ENDIF

   ::BrowseOnChange()

   RETURN lRet

METHOD PageDown( lAppend ) CLASS TOBrowseByCell

   LOCAL _RecNo, s, lRet := .F., cWorkArea, aBefore, aAfter

   s := ::nRowPos
   IF ! s > 0
      s := ::FirstVisibleItem
   ENDIF

   IF  s >= Len( ::aRecMap ) .OR. ::lKeysLikeClipper
      cWorkArea := ::WorkArea
      IF Select( cWorkArea ) == 0
         RETURN lRet
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
               lRet := ::AppendItem()
               IF ::VScroll:Enabled
                  // Kill scrollbar's events...
                  ::VScroll:Enabled := .F.
                  ::VScroll:Enabled := .T.
               ENDIF
            ELSEIF s < Len( ::aRecMap )
               ::CurrentRow := Len( ::aRecMap )
               lRet := .T.
               ::BrowseOnChange()
            ENDIF
            RETURN lRet
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
         lRet := ( aAfter[ 1 ] # aBefore[ 1 ] .OR. aAfter[ 2 ] # aBefore[ 2 ] )
      ENDIF
      ::DbGoTo( _RecNo )
      IF ::lKeysLikeClipper .AND. s <= Len( ::aRecMap )
         ::CurrentRow := s
      ELSE
         ::CurrentRow := Len( ::aRecMap )
         ::CurrentCol := aBefore[ 2 ]
      ENDIF
   ELSE
      ::FastUpdate( ::CountPerPage - s, Len( ::aRecMap ) )
      lRet := .T.
   ENDIF

   ::BrowseOnChange()

   RETURN lRet

METHOD Up( lLast ) CLASS TOBrowseByCell

   LOCAL s, _RecNo, nLen, lRet := .F., cWorkArea, aBefore, aAfter

   s := ::nRowPos

   IF s <= 1
      cWorkArea := ::WorkArea
      IF Select( cWorkArea ) == 0
         RETURN lRet
      ENDIF

      aBefore := ::Value
      _RecNo := ( cWorkArea )->( RecNo() )
      IF Len( ::aRecMap ) == 0
         ::TopBottom( GO_TOP )
         ::DbSkip( -1 )
         ::Update()
      ELSE
         // Check FOR more records
         ::DbGoTo( ::aRecMap[ 1 ] )
         ::DbSkip( -1 )
         IF ::Bof()
            ::DbGoTo( _RecNo )
            RETURN lRet
         ENDIF
         // Add one record at the top
         AAdd( ::aRecMap, NIL )
         AIns( ::aRecMap, 1 )
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
            ASize( ::aRecMap, nLen - 1 )
         ENDIF
         IF ::Visible
            ::SetRedraw( .T. )
         ENDIF
      ENDIF
      ::DbGoTo( _RecNo )
      ::CurrentRow := 1
      IF HB_ISLOGICAL( lLast ) .AND. lLast
         ::CurrentCol := ::LastColInOrder
      ENDIF
      IF Len( ::aRecMap ) != 0
         aAfter := ::Value
         lRet := ( aAfter[ 1 ] # aBefore[ 1 ] .OR. aAfter[ 2 ] # aBefore[ 2 ] )
      ENDIF
   ELSE
      ::FastUpdate( -1, s - 1 )
      IF HB_ISLOGICAL( lLast ) .AND. lLast
         ::CurrentCol := ::LastColInOrder
      ENDIF
      lRet := .T.
   ENDIF

   ::BrowseOnChange()

   RETURN lRet

METHOD Down( lAppend, lFirst ) CLASS TOBrowseByCell

   LOCAL s, _RecNo, nLen, lRet := .F., cWorkArea, aBefore, aAfter

   s := ::nRowPos

   IF s >= Len( ::aRecMap )
      cWorkArea := ::WorkArea
      IF Select( cWorkArea ) == 0
         RETURN lRet
      ENDIF

      aBefore := ::Value
      _RecNo := ( cWorkArea )->( RecNo() )
      IF Len( ::aRecMap ) == 0
         ::TopBottom( GO_TOP )
         ::DbSkip()
         ::Update()
      ELSE
         // Check FOR more records
         ::DbGoTo( ::aRecMap[ Len( ::aRecMap ) ] )
         ::DbSkip()
         IF ::Eof()
            ::DbGoTo( _RecNo )
            ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT ::AllowAppend
            IF lAppend
               lRet := ::AppendItem()
               IF ::VScroll:Enabled
                  // Kill scrollbar's events...
                  ::VScroll:Enabled := .F.
                  ::VScroll:Enabled := .T.
               ENDIF
            ENDIF
            RETURN lRet
         ENDIF
         // Add one record at the bottom
         AAdd( ::aRecMap, ( cWorkArea )->( RecNo() ) )
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
         lRet := ( aAfter[ 1 ] # aBefore[ 1 ] .OR. aAfter[ 2 ] # aBefore[ 2 ] )
      ENDIF
      ::DbGoTo( _RecNo )
      ::CurrentRow := Len( ::aRecMap )
   ELSE
      ::FastUpdate( 1, s + 1 )
      lRet := .T.
   ENDIF
   IF HB_ISLOGICAL( lFirst ) .AND. lFirst
      ::CurrentCol := ::FirstColInOrder
   ENDIF

   ::BrowseOnChange()

   RETURN lRet

METHOD SetScrollPos( nPos, VScroll ) CLASS TOBrowseByCell

   LOCAL cWorkArea, nRecCount, nNewRec

   cWorkArea := ::WorkArea
   IF Select( cWorkArea ) == 0
      // No workarea is selected
   ELSEIF nPos <= VScroll:RangeMin
      ::GoTop()
   ELSEIF nPos >= VScroll:RangeMax
      ::GoBottom()
   ELSE
      IF ::lRecCount
         nRecCount := ( cWorkArea )->( RecCount() )
      ELSE
         nRecCount := ( cWorkArea )->( ordKeyCount() )
      ENDIF
      IF ::lDescending
         nNewRec := nRecCount + 1 - Max( Int( nPos * nRecCount / VScroll:RangeMax ), 1 )
      ELSE
         nNewRec := Max( Int( nPos * nRecCount / VScroll:RangeMax ), 1 )
      ENDIF
      ::VScroll:Value := nPos
      ( cWorkArea )->( ordKeyGoto( nNewRec ) )
      ::Value := { ( cWorkArea )->( RecNo() ), ::nColPos }
   ENDIF

   RETURN NIL

METHOD CurrentCol( nCol ) CLASS TOBrowseByCell

   LOCAL r, nClientWidth, nScrollWidth, lColChanged

   IF HB_ISNUMERIC( nCol ) .AND. nCol >= 0 .AND. nCol <= Len( ::aHeaders )
      IF nCol < 1
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
            IF IsWindowStyle( ::hWnd, WS_VSCROLL ) .AND. ::lScrollBarUsesClientArea .AND. ::ItemCount > ::CountPerPage
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

   LOCAL aBefore, nRec, nCol, lRet := .F., aAfter

   aBefore := ::Value
   nRec := aBefore[ 1 ]
   nCol := aBefore[ 2 ]
   IF nRec > 0 .AND. nCol >= 1 .AND. nCol <= Len( ::aHeaders )
      IF nCol # ::FirstColInOrder
         aAfter := ( ::Value := { nRec, ::PriorColInOrder( nCol ) } )
         lRet := ( aAfter[ 1 ] # nRec .OR. aAfter[ 2 ] # nCol )
      ELSEIF ::FullMove
         lRet := ::Up( .T. )
      ENDIF
   ENDIF

   RETURN lRet

METHOD Right( lAppend ) CLASS TOBrowseByCell

   LOCAL aBefore, nRec, nCol, lRet := .F., aAfter

   aBefore := ::Value
   nRec := aBefore[ 1 ]
   nCol := aBefore[ 2 ]
   IF nRec > 0 .AND. nCol >= 1 .AND. nCol <= Len( ::aHeaders )
      IF nCol # ::LastColInOrder
         aAfter := ( ::Value := { nRec, ::NextColInOrder( nCol ) } )
         lRet := ( aAfter[ 1 ] # nRec .OR. aAfter[ 2 ] # nCol )
      ELSEIF ::FullMove
         IF ::Down( .F., .T. )
            lRet := .T.
         ELSE
            ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
            IF lAppend
               lRet := ::AppendItem()
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   RETURN lRet
