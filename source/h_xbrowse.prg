/*
* $Id: h_xbrowse.prg $
*/
/*
* ooHG source code:
* XBrowse and XBrowseByCell controls
* ooHGRecord and TVirtualField classes
* Copyright 2006-2017 Vicente Guerra <vicente@guerra.com.mx>
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

CLASS TXBrowse FROM TGrid

   DATA aColumnBlocks             INIT Nil
   DATA aDefaultValues            INIT Nil
   DATA aFields                   INIT Nil
   DATA aReplaceField             INIT Nil
   DATA Bof                       INIT .F.
   DATA Eof                       INIT .F.
   DATA goBottomBlock             INIT Nil
   DATA goTopBlock                INIT Nil
   DATA lDescending               INIT .F.
   DATA lForceInPlace             INIT .T.
   DATA lFixedBlocks              INIT .F.
   DATA lLocked                   INIT .F.
   DATA lNoShowEmptyRow           INIT .F.
   DATA Lock                      INIT .F.
   DATA lRecCount                 INIT .F.
   DATA lRefreshAfterValue        INIT .F.
   DATA lScrollBarUsesClientArea  INIT .T.
   DATA lUpdCols                  INIT .F.
   DATA lVscrollVisible           INIT .F.
   DATA nHelpId                   INIT 0
   DATA OnRefreshRow              INIT Nil
   DATA oWorkArea                 INIT Nil
   DATA RefreshType               INIT REFRESH_DEFAULT
   DATA ScrollButton              INIT Nil
   DATA SearchWrap                INIT .F.
   DATA skipBlock                 INIT Nil
   DATA Type                      INIT "XBROWSE" READONLY
   DATA uWorkArea                 INIT Nil
   DATA VScroll                   INIT Nil
   DATA VScrollCopy               INIT Nil

   METHOD AddColumn
   METHOD AddItem                 BLOCK { || Nil }
   METHOD AdjustRightScroll
   METHOD AppendItem
   METHOD ColumnAutoFit
   METHOD ColumnAutoFitH
   METHOD ColumnBlock
   METHOD ColumnsAutoFit
   METHOD ColumnsAutoFitH
   METHOD ColumnWidth
   METHOD CurrentRow              SETGET
   METHOD DbSkip
   METHOD Define
   METHOD Define3
   METHOD Define4
   METHOD Delete
   METHOD DeleteAllItems          BLOCK { | Self | ::nRowPos := 0, ::Super:DeleteAllItems() }
   METHOD DeleteColumn
   METHOD DoChange                BLOCK { | Self | ::DoEvent( ::OnChange, "CHANGE" ) }
   METHOD Down
   METHOD EditAllCells
   METHOD EditCell
   METHOD EditGrid
   METHOD EditItem
   METHOD EditItem_B
   METHOD Enabled                 SETGET
   METHOD Events
   METHOD Events_Notify
   METHOD FixBlocks               SETGET
   METHOD FixControls             SETGET
   METHOD GetCellType
   METHOD GoBottom
   METHOD GoTop
   METHOD HelpId                  SETGET
   METHOD InsertItem              BLOCK { || Nil }
   METHOD Left                    BLOCK { || Nil }
   METHOD MoveTo
   METHOD PageDown
   METHOD PageUp
   METHOD Refresh
   METHOD RefreshData
   METHOD RefreshRow
   METHOD Right                   BLOCK { || Nil }
   METHOD SetColumn
   METHOD SetControlValue         SETGET
   METHOD SetScrollPos
   METHOD SizePos
   METHOD SortColumn              BLOCK { || Nil }
   METHOD SortItems               BLOCK { || Nil }
   METHOD ToExcel
   METHOD ToolTip                 SETGET
   METHOD ToOpenOffice
   METHOD TopBottom
   METHOD Up
   METHOD Value                   SETGET
   METHOD Visible                 SETGET
   METHOD VScrollVisible          SETGET
   METHOD WorkArea                SETGET

   /*
   Available methods from TGrid:
   AddBitMap
   AdjustResize
   Append
   BackColor
   Cell
   CellCaption
   CellImage
   CheckItem
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

METHOD Define( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
      aFields, WorkArea, uValue, AllowDelete, lock, novscroll, ;
      AllowAppend, OnAppend, ReplaceFields, fontname, fontsize, ;
      tooltip, change, dblclick, aHeadClick, gotfocus, lostfocus, ;
      nogrid, aImage, aJust, break, HelpId, bold, italic, underline, ;
      strikeout, editable, backcolor, fontcolor, dynamicbackcolor, ;
      dynamicforecolor, aPicture, lRtl, inplace, editcontrols, ;
      readonly, valid, validmessages, editcell, aWhenFields, ;
      lRecCount, columninfo, lHasHeaders, onenter, lDisabled, ;
      lNoTabStop, lInvisible, lDescending, bDelWhen, DelMsg, ;
      onDelete, aHeaderImage, aHeaderImageAlign, FullMove, ;
      aSelectedColors, aEditKeys, lDblBffr, lFocusRect, lPLM, ;
      lFixedCols, abortedit, click, lFixedWidths, lFixedBlocks, ;
      bBeforeColMove, bAfterColMove, bBeforeColSize, bAfterColSize, ;
      bBeforeAutofit, lLikeExcel, lButtons, lNoDelMsg, lFixedCtrls, ;
      lNoShowEmptyRow, lUpdCols, bHeadRClick, lNoModal, lExtDbl, ;
      lSilent, lAltA, lNoShowAlways, onrclick, lCheckBoxes, oncheck, ;
      rowrefresh, aDefaultValues, editend, lAtFirst, bbeforeditcell, ;
      bEditCellValue, klc ) CLASS TXBrowse

   LOCAL nWidth2, nCol2, oScroll, z

   ASSIGN ::aFields         VALUE aFields         TYPE "A"
   ASSIGN ::aHeaders        VALUE aHeaders        TYPE "A" DEFAULT {}
   ASSIGN ::aWidths         VALUE aWidths         TYPE "A" DEFAULT {}
   ASSIGN ::aJust           VALUE aJust           TYPE "A" DEFAULT {}
   ASSIGN ::lDescending     VALUE lDescending     TYPE "L"
   ASSIGN lFixedBlocks      VALUE lFixedBlocks    TYPE "L" DEFAULT _OOHG_XBrowseFixedBlocks
   ASSIGN lFixedCtrls       VALUE lFixedCtrls     TYPE "L" DEFAULT _OOHG_XBrowseFixedControls
   ASSIGN ::lNoShowEmptyRow VALUE lNoShowEmptyRow TYPE "L"
   ASSIGN ::lUpdCols        VALUE lUpdCols        TYPE "L"
   ASSIGN lAltA             VALUE lAltA           TYPE "L" DEFAULT .T.

   IF HB_IsArray( aDefaultValues )
      ::aDefaultValues := aDefaultValues
      ASize( ::aDefaultValues, Len( ::aHeaders ) )
   ELSE
      ::aDefaultValues := Array( Len( ::aHeaders ) )
      AFill( ::aDefaultValues, aDefaultValues )
   ENDIF

   IF ValType( columninfo ) == "A" .AND. LEN( columninfo ) > 0
      IF ValType( ::aFields ) == "A"
         aSize( ::aFields,  LEN( columninfo ) )
      ELSE
         ::aFields := ARRAY( LEN( columninfo ) )
      ENDIF
      aSize( ::aHeaders, LEN( columninfo ) )
      aSize( ::aWidths,  LEN( columninfo ) )
      aSize( ::aJust,    LEN( columninfo ) )
      FOR z := 1 TO LEN( columninfo )
         IF ValType( columninfo[ z ] ) == "A"
            IF LEN( columninfo[ z ] ) >= 1 .AND. ValType( columninfo[ z ][ 1 ] ) $ "CMB"
               ::aFields[ z ]  := columninfo[ z ][ 1 ]
            ENDIF
            IF LEN( columninfo[ z ] ) >= 2 .AND. ValType( columninfo[ z ][ 2 ] ) $ "CM"
               ::aHeaders[ z ] := columninfo[ z ][ 2 ]
            ENDIF
            IF LEN( columninfo[ z ] ) >= 3 .AND. ValType( columninfo[ z ][ 3 ] ) $ "N"
               ::aWidths[ z ]  := columninfo[ z ][ 3 ]
            ENDIF
            IF LEN( columninfo[ z ] ) >= 4 .AND. ValType( columninfo[ z ][ 4 ] ) $ "N"
               ::aJust[ z ]    := columninfo[ z ][ 4 ]
            ENDIF
         ENDIF
      NEXT
   ENDIF

   ASSIGN ::WorkArea VALUE WorkArea TYPE "CMO" DEFAULT ALIAS()
   IF ValType( ::aFields ) != "A"
      ::aFields := ::oWorkArea:DbStruct()
      aEval( ::aFields, { |x,i| ::aFields[ i ] := ::oWorkArea:cAlias__ + "->" + x[ 1 ] } )
   ENDIF

   aSize( ::aHeaders, Len( ::aFields ) )
   aEval( ::aHeaders, { |x,i| ::aHeaders[ i ] := IIf( ! ValType( x ) $ "CM", if( ValType( ::aFields[ i ] ) $ "CM", ::aFields[ i ], "" ), x ) } )

   aSize( ::aWidths, Len( ::aFields ) )
   aEval( ::aWidths, { |x,i| ::aWidths[ i ] := IIf( ! ValType( x ) == "N", 100, x ) } )

   ASSIGN w         VALUE w         TYPE "N" DEFAULT ::nWidth
   ASSIGN novscroll VALUE novscroll TYPE "L" DEFAULT .F.
   nWidth2 := if( novscroll, w, w - GETVSCROLLBARWIDTH() )

   ::Define2( ControlName, ParentForm, x, y, nWidth2, h, ::aHeaders, aWidths, , ;
      , fontname, fontsize, tooltip, aHeadClick, nogrid, ;
      aImage, ::aJust, break, HelpId, bold, italic, underline, ;
      strikeout, , , editable, backcolor, ;
      fontcolor, dynamicbackcolor, dynamicforecolor, aPicture, lRtl, ;
      LVS_SINGLESEL, inplace, editcontrols, readonly, valid, validmessages, ;
      aWhenFields, lDisabled, lNoTabStop, lInvisible, lHasHeaders, ;
      aHeaderImage, aHeaderImageAlign, FullMove, aSelectedColors, ;
      aEditKeys, lCheckBoxes, lDblBffr, lFocusRect, lPLM, ;
      lFixedCols, lFixedWidths, lLikeExcel, lButtons, AllowDelete, ;
      DelMsg, lNoDelMsg, AllowAppend, lNoModal, lFixedCtrls, ;
      , , lExtDbl, lSilent, lAltA, ;
      lNoShowAlways, .F., .T., lAtFirst, klc )

   ::FixBlocks( lFixedBlocks )

   ::nWidth := w

   ASSIGN ::Lock          VALUE lock          TYPE "L"
   ASSIGN ::aReplaceField VALUE replacefields TYPE "A"
   ASSIGN ::lRecCount     VALUE lRecCount     TYPE "L"

   IF ::lRtl .AND. ! ::Parent:lRtl
      ::nCol := ::nCol + GETVSCROLLBARWIDTH()
      nCol2 := -GETVSCROLLBARWIDTH()
   ELSE
      nCol2 := nWidth2
   ENDIF

   ::ScrollButton := TScrollButton():Define( , Self, nCol2, ::nHeight - GETHSCROLLBARHEIGHT(), GETVSCROLLBARWIDTH() , GETHSCROLLBARHEIGHT() )

   oScroll := TScrollBar()
   oScroll:nWidth := GETVSCROLLBARWIDTH()
   oScroll:SetRange( 1, 100 )
   oScroll:nCol := nCol2

   IF IsWindowStyle( ::hWnd, WS_HSCROLL )
      oScroll:nRow := 0
      oScroll:nHeight := ::nHeight - GETHSCROLLBARHEIGHT()
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
   ::VScroll:ToolTip    := tooltip
   ::VScroll:HelpId     := HelpId

   ::VScrollCopy := oScroll

   // It forces to hide "additional" controls when it's inside a
   // non-visible TAB page.
   ::Visible := ::Visible

   ::lVScrollVisible := .T.
   IF novscroll
      ::VScrollVisible( .F. )
   ENDIF

   // to work properly, nRow and the data source record must be synchronized
   // do not change !!!
   ::lChangeBeforeEdit := .T.
   ::lNoneUnsels := .F.

   // Value
   ::Define3( uValue )

   // Must be set after control is initialized
   ::Define4( change, dblclick, gotfocus, lostfocus, editcell, onenter, ;
      oncheck, abortedit, click, bbeforecolmove, baftercolmove, ;
      bbeforecolsize, baftercolsize, bbeforeautofit, ondelete, ;
      bdelwhen, onappend, bheadrclick, onrclick, editend, rowrefresh, ;
      bbeforeditcell, bEditCellValue )

   RETURN Self

METHOD Define3( nValue ) CLASS TXBrowse

   LOCAL lLocked

   ASSIGN nValue VALUE nValue TYPE "N" DEFAULT 1
   ASSIGN lLocked VALUE ::lLocked TYPE "L" DEFAULT .F.
   ::lLocked := .F.
   ::Refresh()
   ::Value := nValue
   ::lLocked := lLocked

   RETURN Self

METHOD Define4( change, dblclick, gotfocus, lostfocus, editcell, onenter, ;
      oncheck, abortedit, click, bbeforecolmove, baftercolmove, ;
      bbeforecolsize, baftercolsize, bbeforeautofit, ondelete, ;
      bDelWhen, onappend, bheadrclick, onrclick, editend, rowrefresh, ;
      bbeforeditcell, bEditCellValue ) CLASS TXBrowse

   // Must be set after control is initialized
   ASSIGN ::OnChange         VALUE change         TYPE "B"
   ASSIGN ::OnDblClick       VALUE dblclick       TYPE "B"
   ASSIGN ::OnGotFocus       VALUE gotfocus       TYPE "B"
   ASSIGN ::OnLostFocus      VALUE lostfocus      TYPE "B"
   ASSIGN ::OnEditCell       VALUE editcell       TYPE "B"
   ASSIGN ::OnEnter          VALUE onenter        TYPE "B"
   ASSIGN ::OnCheckChange    VALUE oncheck        TYPE "B"
   ASSIGN ::OnAbortEdit      VALUE abortedit      TYPE "B"
   ASSIGN ::OnClick          VALUE click          TYPE "B"
   ASSIGN ::bBeforeColMove   VALUE bbeforecolmove TYPE "B"
   ASSIGN ::bAfterColMove    VALUE baftercolmove  TYPE "B"
   ASSIGN ::bBeforeColSize   VALUE bbeforecolsize TYPE "B"
   ASSIGN ::bAfterColSize    VALUE baftercolsize  TYPE "B"
   ASSIGN ::bBeforeAutofit   VALUE bbeforeautofit TYPE "B"
   ASSIGN ::OnDelete         VALUE ondelete       TYPE "B"
   ASSIGN ::bDelWhen         VALUE bdelwhen       TYPE "B"
   ASSIGN ::OnAppend         VALUE onappend       TYPE "B"
   ASSIGN ::bHeadRClick      VALUE bheadrclick    TYPE "B"
   ASSIGN ::OnRClick         VALUE onrclick       TYPE "B"
   ASSIGN ::OnEditCellEnd    VALUE editend        TYPE "B"
   ASSIGN ::OnRefreshRow     VALUE rowrefresh     TYPE "B"
   ASSIGN ::OnBeforeEditCell VALUE bbeforeditcell TYPE "B"
   ASSIGN ::bEditCellValue   VALUE bEditCellValue TYPE "B"

   RETURN Self

METHOD ToolTip( cToolTip ) CLASS TXBrowse

   LOCAL uToolTip

   IF PCount() > 0
      uToolTip := ::Super:ToolTip( cToolTip )
      IF HB_IsObject( ::VScroll )
         ::VScroll:ToolTip := uToolTip
      ENDIF
      IF HB_IsObject( ::VScrollCopy )
         ::VScrollCopy:ToolTip := uToolTip
      ENDIF
   ENDIF

   RETURN ::Super:ToolTip()

METHOD HelpId( nHelpId ) CLASS TXBrowse

   IF HB_IsNumeric( nHelpId )
      ::nHelpId := nHelpId
      IF HB_IsObject( ::VScroll )
         ::VScroll:HelpId := nHelpId
      ENDIF
      IF HB_IsObject( ::VScrollCopy )
         ::VScrollCopy:HelpId := nHelpId
      ENDIF
   ENDIF

   RETURN ::nHelpId

METHOD FixBlocks( lFix ) CLASS TXBrowse

   IF HB_IsLogical( lFix )
      IF lFix
         ::aColumnBlocks := ARRAY( Len( ::aFields ) )
         aEval( ::aFields, { |c,i| ::aColumnBlocks[ i ] := ::ColumnBlock( i ), c } )
         ::lFixedBlocks := .T.
      ELSE
         ::lFixedBlocks := .F.
         ::aColumnBlocks := Nil
      ENDIF
   ENDIF

   RETURN ::lFixedBlocks

METHOD FixControls( lFix ) CLASS TXBrowse

   LOCAL i, oEditControl

   IF HB_IsLogical( lFix )
      IF lFix
         ::lFixedControls := .F.                           // Necessary for ::GetCellType to work properly
         ::aEditControls := Array( Len( ::aHeaders ) )
         FOR i := 1 To Len( ::aHeaders )
            oEditControl := Nil
            ::GetCellType( i, @oEditControl, , , , .F. )
            ::aEditControls[ i ] := oEditControl
         NEXT i
         ::lFixedControls := .T.
      ELSE
         ::lFixedControls := .F.
      ENDIF
   ENDIF

   RETURN ::lFixedControls

METHOD Refresh( nCurrent, lNoEmptyBottom ) CLASS TXBrowse

   LOCAL nRow, nCount, nSkipped

   IF Empty( ::WorkArea ) .OR. ( ValType( ::WorkArea ) $ "CM" .AND. Select( ::WorkArea ) == 0 )
      // No workarea specified...
   ELSEIF ! ::lLocked
      IF ::Visible
         ::SetRedraw( .F. )
      ENDIF

      nCount := ::CountPerPage
      ASSIGN nCurrent       VALUE nCurrent       TYPE "N" DEFAULT ::CurrentRow
      ASSIGN lNoEmptyBottom VALUE lNoEmptyBottom TYPE "L" DEFAULT .F.
      nCurrent := MAX( MIN( nCurrent, nCount ), 1 )
      // Top of screen
      nCurrent := ( - ::DbSkip( - ( nCurrent - 1 ) ) ) + 1

      IF ::lNoShowEmptyRow .AND. ::oWorkArea:IsTableEmpty()
         nCurrent := nRow := 0
         ::TopBottom( GO_BOTTOM )
      ELSE
         // Draw rows
         nRow := 1
         DO WHILE .T.
            ::RefreshRow( nRow )
            IF nRow < nCount
               IF ::DbSkip( 1 ) == 1
                  nRow ++
               ELSE
                  IF lNoEmptyBottom
                     nSkipped := ( - ::DbSkip( - ( nCount - 1 ) ) ) + 1
                     nCurrent := nCurrent + ( nSkipped - nRow )
                     nRow := 1
                     lNoEmptyBottom := .F.
                  ELSE
                     ::TopBottom( GO_BOTTOM )
                     EXIT
                  ENDIF
               ENDIF
            ELSE
               EXIT
            ENDIF
         ENDDO
      ENDIF

      // Clear bottom rows
      DO WHILE ::ItemCount > nRow
         ::DeleteItem( ::ItemCount )
      ENDDO
      // Return to current row
      IF nRow > nCurrent
         ::DbSkip( nCurrent - nRow )
      ELSE
         nCurrent := nRow
      ENDIF
      ::CurrentRow := nCurrent

      IF ::Visible
         ::SetRedraw( .T. )
      ENDIF
   ENDIF

   RETURN Self

METHOD RefreshRow( nRow ) CLASS TXBrowse

   LOCAL aItem, cWorkArea

   IF ! ::lLocked
      cWorkArea := ::WorkArea
      IF ValType( cWorkArea ) $ "CM" .AND. ( Empty( cWorkArea ) .OR. Select( cWorkArea ) == 0 )
         cWorkArea := Nil
      ENDIF
      aItem := ARRAY( LEN( ::aFields ) )
      IF ::FixBlocks()
         aEval( aItem, { |x,i| aItem[ i ] := EVAL( ::aColumnBlocks[ i ], cWorkArea ), x } )
      ELSE
         aEval( aItem, { |x,i| aItem[ i ] := EVAL( ::ColumnBlock( i ), cWorkArea ), x } )
      ENDIF
      aEval( aItem, { |x,i| If( ValType( x ) $ "CM", aItem[ i ] := TRIM( x ),  ) } )

      IF ValType( cWorkArea ) $ "CM"
         ( cWorkArea )->( ::SetItemColor( nRow,,, aItem ) )
      ELSE
         ::SetItemColor( nRow,,, aItem )
      ENDIF

      IF ::ItemCount < nRow
         AddListViewItems( ::hWnd, aItem )
      ELSE
         ListViewSetItem( ::hWnd, aItem, nRow )
      ENDIF

      ::DoEvent( ::OnRefreshRow, "REFRESHROW", { nRow, aItem } )
   ENDIF

   RETURN Self

METHOD ColumnBlock( nCol, lDirect ) CLASS TXBrowse

   LOCAL oEditControl, cWorkArea, cValue, uPicture, bRet

   ASSIGN lDirect VALUE lDirect TYPE "L" DEFAULT .F.
   IF ! ValType( nCol ) == "N" .OR. nCol < 1 .OR. nCol > LEN( ::aFields )

      RETURN { || "" }
   ENDIF
   cWorkArea := ::WorkArea
   IF ValType( cWorkArea ) $ "CM" .AND. ( Empty( cWorkArea ) .OR. Select( cWorkArea ) == 0 )
      cWorkArea := Nil
   ENDIF
   cValue := ::aFields[ nCol ]
   bRet := Nil
   IF ! lDirect
      IF ::FixControls()
         oEditControl := ::aEditControls[ nCol ]
      ENDIF
      oEditControl := GetEditControlFromArray( oEditControl, ::EditControls, nCol, Self )
      IF ValType( oEditControl ) == "O"
         IF oEditControl:Type == "TGRIDCONTROLIMAGEDATA" .AND. ValType( cValue ) == "A" .AND. LEN( cValue ) > 1
            IF ValType( cWorkArea ) $ "CM"
               IF HB_IsBlock( cValue[1] )
                  IF HB_IsBlock( cValue[2] )
                     bRet := { |wa| oEditControl:GridValue( { ( cWorkArea ) -> ( EVAL( cValue[1], wa ) ), ( cWorkArea ) -> ( EVAL( cValue[2], wa ) ) } ) }
                  ELSE
                     bRet := { |wa| oEditControl:GridValue( { ( cWorkArea ) -> ( EVAL( cValue[1], wa ) ), ( cWorkArea ) -> ( &( cValue[2] ) ) } ) }
                  ENDIF
               ELSE
                  IF HB_IsBlock( cValue[2] )
                     bRet := { |wa| oEditControl:GridValue( { ( cWorkArea ) -> ( &( cValue[1] ) ), ( cWorkArea ) -> ( EVAL( cValue[2], wa ) ) } ) }
                  ELSE
                     bRet := { || oEditControl:GridValue( { ( cWorkArea ) -> ( &( cValue[1] ) ), ( cWorkArea ) -> ( &( cValue[2] ) ) } ) }
                  ENDIF
               ENDIF
            ELSE
               IF HB_IsBlock( cValue[1] )
                  IF HB_IsBlock( cValue[2] )
                     bRet := { |wa| oEditControl:GridValue( EVAL( cValue[1], wa ),  EVAL( cValue[2], wa ) ) }
                  ELSE
                     bRet := { |wa| oEditControl:GridValue(  EVAL( cValue[1], wa ),  &( cValue[2] ) ) }
                  ENDIF
               ELSE
                  IF HB_IsBlock( cValue[2] )
                     bRet := { |wa| oEditControl:GridValue( &( cValue[1] ),  EVAL( cValue[2], wa ) ) }
                  ELSE
                     bRet := { || oEditControl:GridValue(  &( cValue[1] ),  &( cValue[2] ) ) }
                  ENDIF
               ENDIF
            ENDIF
         ELSEIF ValType( cWorkArea ) $ "CM"
            IF ValType( cValue ) == "B"
               bRet := { |wa| oEditControl:GridValue( ( cWorkArea ) -> ( EVAL( cValue, wa ) ) ) }
            ELSE
               bRet := { || oEditControl:GridValue( ( cWorkArea ) -> ( &( cValue ) ) ) }
            ENDIF
         ELSE
            IF ValType( cValue ) == "B"
               bRet := { |wa| oEditControl:GridValue( EVAL( cValue, wa ) ) }
            ELSE
               bRet := { || oEditControl:GridValue( &( cValue ) ) }
            ENDIF
         ENDIF
      ELSE
         uPicture := ::Picture[ nCol ]
         IF ValType( uPicture ) $ "CM"
            // Picture
            IF ValType( cWorkArea ) $ "CM"
               IF ValType( cValue ) == "B"
                  bRet := { |wa| Trim( Transform( ( cWorkArea ) -> ( EVAL( cValue, wa ) ), uPicture ) ) }
               ELSE
                  bRet := { || Trim( Transform( ( cWorkArea ) -> ( &( cValue ) ), uPicture ) ) }
               ENDIF
            ELSE
               IF ValType( cValue ) == "B"
                  bRet := { |wa| Trim( Transform( EVAL( cValue, wa ), uPicture ) ) }
               ELSE
                  bRet := { || Trim( Transform( &( cValue ), uPicture ) ) }
               ENDIF
            ENDIF
         ELSEIF ValType( uPicture ) == "L" .AND. uPicture
            // Direct value
         ELSE
            // Convert
            IF ValType( cWorkArea ) $ "CM"
               IF ValType( cValue ) == "B"
                  bRet := { |wa| TXBrowse_UpDate_PerType( ( cWorkArea ) -> ( EVAL( cValue, wa ) ) ) }
               ELSE
                  // bRet := { || TXBrowse_UpDate_PerType( ( cWorkArea ) -> ( &( cValue ) ) ) }
                  bRet := &( " { || TXBrowse_UpDate_PerType( " + cWorkArea + " -> ( " + cValue + " ) ) } " )
               ENDIF
            ELSE
               IF ValType( cValue ) == "B"
                  bRet := { |wa| TXBrowse_UpDate_PerType( EVAL( cValue, wa ) ) }
               ELSE
                  // bRet := { || TXBrowse_UpDate_PerType( &( cValue ) ) }
                  bRet := &( " { || TXBrowse_UpDate_PerType( " + cValue + " ) } " )
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   IF bRet == Nil
      // Direct value
      IF ValType( cWorkArea ) $ "CM"
         IF ValType( cValue ) == "A"
            IF HB_IsBlock( cValue[1] )
               IF HB_IsBlock( cValue[2] )
                  bRet := { |wa| { ( cWorkArea ) -> ( EVAL( cValue[1], wa ) ), ( cWorkArea ) -> ( EVAL( cValue[2], wa ) ) } }
               ELSE
                  bRet := { |wa| { ( cWorkArea ) -> ( EVAL( cValue[1], wa ) ), ( cWorkArea ) -> ( &( cValue[2] ) ) } }
               ENDIF
            ELSE
               IF HB_IsBlock( cValue[2] )
                  bRet := { |wa| { ( cWorkArea ) -> ( &( cValue[1] ) ), ( cWorkArea ) -> ( EVAL( cValue[2], wa ) ) } }
               ELSE
                  bRet := { || { ( cWorkArea ) -> ( &( cValue[1] ) ), ( cWorkArea ) -> ( &( cValue[2] ) ) } }
               ENDIF
            ENDIF
         ELSEIF ValType( cValue ) == "B"
            bRet := { |wa| ( cWorkArea ) -> ( EVAL( cValue, wa ) ) }
         ELSE
            // bRet := { || ( cWorkArea ) -> ( &( cValue ) ) }
            bRet := &( " { || " + cWorkArea + " -> ( " + cValue + " ) } " )
         ENDIF
      ELSE
         IF ValType( cValue ) == "A"
            bRet := cValue
         ELSEIF ValType( cValue ) == "B"
            bRet := cValue
         ELSE
            // bRet := { || &( cValue ) }
            bRet := &( " { || " + cValue + " } " )
         ENDIF
      ENDIF
   ENDIF

   RETURN bRet

FUNCTION TXBrowse_UpDate_PerType( uValue )

   LOCAL cType := ValType( uValue )

   IF cType == "C"
      uValue := rTrim( uValue )
   ELSEIF cType == "N"
      uValue := lTrim( Str( uValue ) )
   ELSEIF cType == "L"
      uValue := IIf( uValue, ".T.", ".F." )
   ELSEIF cType == "D"
      uValue := Dtoc( uValue )
   ELSEIF cType == "T"
      uValue := Ttoc( uValue )
   ELSEIF cType == "M"
      uValue := '<Memo>'
   ELSEIF cType == "A"
      uValue := "<Array>"
   ELSEIF cType == "H"
      uValue := "<Hash>"
   ELSEIF cType == "O"
      uValue := "<Object>"
   ELSE
      uValue := "Nil"
   ENDIF

   RETURN uValue

METHOD MoveTo( nTo, nFrom ) CLASS TXBrowse

   LOCAL lMoved := .F.

   IF ! ::lLocked .AND. ! ( ::lNoShowEmptyRow .AND. ::oWorkArea:IsTableEmpty() )
      ASSIGN nTo   VALUE INT( nTo )   TYPE "N" DEFAULT ::CurrentRow
      ASSIGN nFrom VALUE INT( nFrom ) TYPE "N" DEFAULT ::nRowPos
      nFrom := Max( Min( nFrom, ::ItemCount ), 1 )
      nTo   := Max( Min( nTo,   ::CountPerPage ), 1 )
      ::RefreshRow( nFrom )
      DO WHILE nFrom != nTo
         lMoved := .T.
         IF nFrom > nTo
            IF ::DbSkip( -1 ) != 0
               nFrom --
               ::RefreshRow( nFrom )
            ELSE
               EXIT
            ENDIF
         ELSE
            IF ::DbSkip( 1 ) != 0
               nFrom ++
               ::RefreshRow( nFrom )
            ELSE
               EXIT
            ENDIF
         ENDIF
      ENDDO
      ::CurrentRow := nTo
      IF lMoved
         ::DoChange()
      ENDIF
   ENDIF

   RETURN Self

METHOD CurrentRow( nValue ) CLASS TXBrowse

   LOCAL oVScroll, aPosition

   IF ValType( nValue ) == "N" .AND. ! ::lLocked
      oVScroll := ::VScroll
      IF ::lVScrollVisible
         IF ::lRecCount
            aPosition := { ::oWorkArea:OrdKeyNo(), ::oWorkArea:RecCount() }
         ELSE
            aPosition := { ::oWorkArea:OrdKeyNo(), ::oWorkArea:OrdKeyCount() }
         ENDIF
         IF ::lDescending
            aPosition[ 1 ] := aPosition[ 2 ] - aPosition[ 1 ] + 1
         ENDIF
         IF aPosition[ 2 ] == 0
            oVScroll:RangeMax := oVScroll:RangeMin
            oVScroll:Value := oVScroll:RangeMax
         ELSEIF aPosition[ 2 ] < 10000
            oVScroll:RangeMax := aPosition[ 2 ]
            oVScroll:Value := aPosition[ 1 ]
         ELSE
            oVScroll:RangeMax := 10000
            oVScroll:Value := Int( aPosition[ 1 ] * 10000 / aPosition[ 2 ] )
         ENDIF
      ENDIF
      ::nRowPos := ( ::Super:Value := nValue )
   ENDIF

   RETURN ::Super:Value

METHOD Value( uValue ) CLASS TXBrowse

   IF ::FirstVisibleColumn # 0 .AND. HB_IsNumeric( uValue ) .AND. uValue >= 1 .AND. uValue <= ::ItemCount
      ::Super:Value( uValue )
      IF ::lRefreshAfterValue
         ::Refresh()
      ENDIF
   ENDIF

   RETURN ::CurrentRow

METHOD SetControlValue( uValue ) CLASS TXBrowse

   IF HB_IsNumeric( uValue )
      IF ! ::lLocked .AND. ::FirstVisibleColumn # 0 .AND. uValue >= 1
         ::MoveTo( uValue, ::nRowPos )
      ELSE
         ::CurrentRow := ::nRowPos
      ENDIF
   ENDIF

   RETURN ::CurrentRow

METHOD SizePos( Row, Col, Width, Height ) CLASS TXBrowse

   LOCAL uRet, nWidth

   ASSIGN ::nRow    VALUE Row    TYPE "N"
   ASSIGN ::nCol    VALUE Col    TYPE "N"
   ASSIGN ::nWidth  VALUE Width  TYPE "N"
   ASSIGN ::nHeight VALUE Height TYPE "N"

   IF ::lVScrollVisible
      nWidth := ::VScroll:Width

      // See below
      ::ScrollButton:Visible := .F.

      IF ::lRtl .AND. ! ::Parent:lRtl
         uRet := MoveWindow( ::hWnd, ::ContainerCol + nWidth, ::ContainerRow, ::nWidth - nWidth, ::nHeight, .T. )
         ::VScroll:Col      := - nWidth
         ::ScrollButton:Col := - nWidth
      ELSE
         uRet := MoveWindow( ::hWnd, ::ContainerCol,          ::ContainerRow, ::nWidth - nWidth, ::nHeight, .T. )
         ::VScroll:Col      := ::Width - ::VScroll:Width
         ::ScrollButton:Col := ::Width - ::VScroll:Width
      ENDIF

      IF IsWindowStyle( ::hWnd, WS_HSCROLL )
         ::VScroll:Height := ::Height - ::ScrollButton:Height
      ELSE
         ::VScroll:Height := ::Height
      ENDIF
      ::ScrollButton:Row := ::Height - ::ScrollButton:Height
      aEval( ::aControls, { |o| o:SizePos() } )

      /*
      * This two instructions force the redrawn of the control's area
      * that is been overwritten by the scrollbars.
      */
      ::ScrollButton:Visible := .T.
   ELSE
      uRet := MoveWindow( ::hWnd, ::ContainerCol, ::ContainerRow, ::nWidth, ::nHeight , .T. )
   ENDIF

   IF ! ::AdjustRightScroll()
      ::Refresh()
   ENDIF

   RETURN uRet

METHOD Enabled( lEnabled ) CLASS TXBrowse

   IF ValType( lEnabled ) == "L"
      ::Super:Enabled := lEnabled
      aEval( ::aControls, { |o| o:Enabled := o:Enabled } )
   ENDIF

   RETURN ::Super:Enabled

METHOD ToExcel( cTitle, nColFrom, nColTo ) CLASS TXBrowse

   LOCAL oExcel, oSheet, nLin, i, cWorkArea, uValue, aColumnOrder

   IF ::lLocked

      RETURN Self
   ENDIF
   IF ! ValType( cTitle ) $ "CM"
      cTitle := ""
   ENDIF
   IF ! ValType( nColFrom ) == "N" .OR. nColFrom < 1 .OR. nColFrom > Len( ::aHeaders )
      // nColFrom is an index in ::ColumnOrder
      nColFrom := 1
   ENDIF
   IF ! ValType( nColTo ) == "N" .OR. nColTo < 1 .OR. nColTo > Len( ::aHeaders ) .OR. nColTo < nColFrom
      // nColTo is an index in ::ColumnOrder
      nColTo := Len( ::aHeaders )
   ENDIF

   #ifndef __XHARBOUR__
   IF ( oExcel := win_oleCreateObject( "Excel.Application" ) ) == Nil
      MsgStop( "Error: MS Excel not available. [" + win_oleErrorText()+ "]" )

      RETURN Self
   ENDIF
   #else
   oExcel := TOleAuto():New( "Excel.Application" )
   IF Ole2TxtError() != "S_OK"
      MsgStop( "Excel not found", "Error" )

      RETURN Self
   ENDIF
   #endif

   oExcel:WorkBooks:Add()
   oSheet := oExcel:ActiveSheet()
   oSheet:Cells:Font:Name := "Arial"
   oSheet:Cells:Font:Size := 10

   aColumnOrder := ::ColumnOrder
   nLin := 4

   FOR i := nColFrom To nColTo
      oSheet:Cells( nLin, i - nColFrom + 1 ):Value := ::aHeaders[ aColumnOrder[ i ] ]
      oSheet:Cells( nLin, i - nColFrom + 1 ):Font:Bold := .T.
   NEXT i
   nLin += 2

   cWorkArea := ::WorkArea
   IF ValType( cWorkArea ) $ "CM" .AND. ( Empty( cWorkArea ) .OR. Select( cWorkArea ) == 0 )
      cWorkArea := Nil
   ENDIF

   ::GoTop()
   DO WHILE ! ::Eof()
      FOR i := nColFrom To nColTo
         IF HB_IsBlock( ::aFields[ aColumnOrder[ i ] ] )
            uValue := ( cWorkArea ) -> ( Eval( ::aFields[ aColumnOrder[ i ] ], cWorkArea ) )
         ELSE
            uValue := ( cWorkArea ) -> ( &( ::aFields[ aColumnOrder[ i ] ] ) )
         ENDIF
         IF ValType( uValue ) == "C"
            uValue := "'" + uValue
         ENDIF
         IF ! HB_IsDate( uValue ) .OR. ! Empty( uValue )
            oSheet:Cells( nLin, i - nColFrom + 1 ):Value := uValue
         ENDIF
      NEXT i
      ::DbSkip()
      nLin ++
   ENDDO

   FOR i := nColFrom To nColTo
      oSheet:Columns( i - nColFrom + 1 ):AutoFit()
   NEXT i

   oSheet:Cells( 1, 1 ):Value := cTitle
   oSheet:Cells( 1, 1 ):Font:Bold := .T.

   oSheet:Cells( 1, 1 ):Select()
   oExcel:Visible := .T.
   oSheet := Nil
   oExcel := Nil

   RETURN Self

METHOD ToOpenOffice( cTitle, nColFrom, nColTo ) CLASS TXBrowse

   LOCAL oSerMan, oDesk, oPropVals, oBook, oSheet, nLin, i, uValue, cWorkArea, aColumnOrder

   IF ::lLocked

      RETURN Self
   ENDIF
   IF ! ValType( cTitle ) $ "CM"
      cTitle := ""
   ENDIF
   IF ! ValType( nColFrom ) == "N" .OR. nColFrom < 1 .OR. nColTo > Len( ::aHeaders )
      // nColFrom is an index in ::ColumnOrder
      nColFrom := 1
   ENDIF
   IF ! ValType( nColTo ) == "N" .OR. nColTo > Len( ::aHeaders ) .OR. nColTo < nColFrom
      // nColTo is an index in ::ColumnOrder
      nColTo := Len( ::aHeaders )
   ENDIF

   // open service manager
   #ifndef __XHARBOUR__
   IF ( oSerMan := win_oleCreateObject( "com.sun.star.ServiceManager" ) ) == Nil
      MsgStop( "Error: OpenOffice not available. [" + win_oleErrorText()+ "]" )

      RETURN Self
   ENDIF
   #else
   oSerMan := TOleAuto():New( "com.sun.star.ServiceManager" )
   IF Ole2TxtError() != "S_OK"
      MsgStop( "OpenOffice not found", "Error" )

      RETURN Self
   ENDIF
   #endif

   // open desktop service
   IF ( oDesk := oSerMan:CreateInstance( "com.sun.star.frame.Desktop" ) ) == Nil
      MsgStop( "Error: OpenOffice Desktop not available." )

      RETURN Self
   ENDIF

   // set properties for new book
   oPropVals := oSerMan:Bridge_GetStruct( "com.sun.star.beans.PropertyValue" )
   oPropVals:Name := "Hidden"
   oPropVals:Value := .T.

   // open new book
   IF ( oBook := oDesk:LoadComponentFromURL( "private:factory/scalc", "_blank", 0, {oPropVals} ) ) == Nil
      MsgStop( "Error: OpenOffice Calc not available." )
      oDesk := Nil

      RETURN Self
   ENDIF

   // keep only one sheet
   DO WHILE oBook:Sheets:GetCount() > 1
      oSheet := oBook:Sheets:GetByIndex( oBook:Sheets:GetCount() - 1 )
      oBook:Sheets:RemoveByName( oSheet:Name )
   ENDDO

   // select first sheet
   oSheet := oBook:Sheets:GetByIndex( 0 )
   oBook:GetCurrentController:SetActiveSheet( oSheet )

   // set font name and size of all cells
   oSheet:CharFontName := "Arial"
   oSheet:CharHeight := 10

   aColumnOrder := ::ColumnOrder
   nLin := 4

   // put headers using bold style
   FOR i := nColFrom To nColTo
      oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetString( ::aHeaders[ aColumnOrder[ i ] ] )
      oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetPropertyValue( "CharWeight", 150 )
   NEXT i
   nLin += 2

   // put rows
   cWorkArea := ::WorkArea
   IF ValType( cWorkArea ) $ "CM" .AND. ( Empty( cWorkArea ) .OR. Select( cWorkArea ) == 0 )
      cWorkArea := Nil
   ENDIF

   ::GoTop()
   DO WHILE ! ::Eof()
      FOR i := nColFrom To nColTo
         IF HB_IsBlock( ::aFields[ aColumnOrder[ i ] ] )
            uValue := ( cWorkArea ) -> ( Eval( ::aFields[ aColumnOrder[ i ] ], cWorkArea ) )
         ELSE
            uValue := ( cWorkArea ) -> ( &( ::aFields[ aColumnOrder[ i ] ] ) )
         ENDIF

         DO CASE
         CASE uValue == Nil
         CASE ValType( uValue ) == "C"
            IF Left( uValue, 1 ) == "'"
               uValue := "'" + uValue
            ENDIF
            oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetString( uValue )
         CASE ValType( uValue ) == "N"
            oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetValue( uValue )
         CASE ValType( uValue ) == "L"
            oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetValue( uValue )
            oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetPropertyValue("NumberFormat", 99 )
         CASE ValType( uValue ) == "D"
            oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetValue( uValue )
            oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetPropertyValue( "NumberFormat", 36 )
         CASE ValType( uValue ) == "T"
            oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetString( uValue )
         OTHERWISE
            oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetFormula( uValue )
         ENDCASE
      NEXT i
      ::DbSkip()
      nLin ++
   ENDDO

   // autofit columns
   FOR i := nColFrom To nColTo
      oSheet:GetColumns:GetByIndex( i - nColFrom ):SetPropertyValue( "OptimalWidth", .T. )
   NEXT i

   // put title using bold style
   oSheet:GetCellByPosition( 0, 0 ):SetString( cTitle )
   oSheet:GetCellByPosition( 0, 0 ):SetPropertyValue( "CharWeight", 150 )

   // show
   oSheet:GetCellRangeByName( "A1:A1" )
   oSheet:IsVisible := .T.
   oBook:GetCurrentController():GetFrame():GetContainerWindow():SetVisible( .T. )
   oBook:GetCurrentController():GetFrame():GetContainerWindow():ToFront()

   // cleanup
   oSheet    := Nil
   oBook     := Nil
   oPropVals := Nil
   oDesk     := Nil
   oSerMan   := Nil

   RETURN Self

METHOD Visible( lVisible ) CLASS TXBrowse

   IF ValType( lVisible ) == "L"
      ::Super:Visible := lVisible
      aEval( ::aControls, { |o| o:Visible := lVisible } )
   ENDIF

   RETURN ::lVisible

METHOD RefreshData() CLASS TXBrowse

   ::Refresh()

   RETURN ::Super:RefreshData()

METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TXBrowse

   LOCAL cWorkArea, uGridValue

   IF nMsg == WM_CHAR
      IF wParam < 32 .OR. ::SearchCol < 1 .OR. ::SearchCol > ::ColumnCount .OR. ::lLocked .OR. aScan( ::aHiddenCols, ::SearchCol ) # 0
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

      cWorkArea := ::WorkArea
      IF ValType( cWorkArea ) $ "CM" .AND. ( Empty( cWorkArea ) .OR. Select( cWorkArea ) == 0 )
         cWorkArea := Nil
      ENDIF

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
      ENDIF

      IF ::Eof()
         ::GoBottom()
      ELSE
         ::Refresh( ::CountPerPage )
         ::DoChange()
      ENDIF

      RETURN 0

   ELSEIF nMsg == WM_KEYDOWN
      DO CASE
      CASE ::FirstVisibleColumn == 0
      CASE wParam == VK_HOME
         ::GoTop()

         RETURN 0
      CASE wParam == VK_END
         ::GoBottom()

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

   ENDIF

   RETURN ::Super:Events( hWnd, nMsg, wParam, lParam )

METHOD Events_Notify( wParam, lParam ) CLASS TXBrowse

   LOCAL nvKey, lGo, uValue, nNotify := GetNotifyCode( lParam )

   IF nNotify == NM_CLICK
      IF ::lCheckBoxes
         // detect item
         uValue := ListView_HitOnCheckBox( ::hWnd, GetCursorRow() - GetWindowRow( ::hWnd ), GetCursorCol() - GetWindowCol( ::hWnd ) )
      ELSE
         uValue := 0
      ENDIF

      IF ::bPosition == -2 .OR. ::bPosition == 9
         ::nDelayedClick := { ::FirstSelectedItem, 0, uValue, Nil }
         IF ::nRowPos > 0
            ListView_SetCursel( ::hWnd, ::nRowPos )
         ELSE
            ListView_ClearCursel( ::hWnd )
         ENDIF
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
            IF ! ::lLocked .AND. ::FirstVisibleColumn # 0
               ::MoveTo( ::CurrentRow, ::nRowPos )
            ELSE
               ::Super:Value := ::nRowPos
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
         ::nDelayedClick := { ::FirstSelectedItem, 0, uValue, _GetGridCellData( Self, ListView_ItemActivate( lParam ) ) }
         IF ::nRowPos > 0
            ListView_SetCursel( ::hWnd, ::nRowPos )
         ELSE
            ListView_ClearCursel( ::hWnd )
         ENDIF
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
            IF ! ::lLocked .AND. ::FirstVisibleColumn # 0
               ::MoveTo( ::CurrentRow, ::nRowPos )
            ELSE
               ::Super:Value := ::nRowPos
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
         ::nDelayedClick := { ::FirstSelectedItem, 0, 0, Nil }
         IF ::nRowPos > 0
            ListView_SetCursel( ::hWnd, ::nRowPos )
         ELSE
            ListView_ClearCursel( ::hWnd )
         ENDIF
      ELSE
         IF ! ::lLocked .AND. ::FirstVisibleColumn # 0
            ::MoveTo( ::CurrentRow, ::nRowPos )
         ELSE
            ::Super:Value := ::nRowPos
         ENDIF
      ENDIF

      RETURN NIL

   ELSEIF nNotify == LVN_KEYDOWN
      IF ::FirstVisibleColumn # 0
         IF GetGridvKeyAsChar( lParam ) == 0
            ::cText := ""
         ENDIF

         nvKey := GetGridvKey( lParam )
         DO CASE
         CASE GetKeyFlagState() == MOD_ALT .AND. nvKey == VK_A
            IF ::lAppendOnAltA
               ::AppendItem()
            ENDIF

         CASE nvKey == VK_DELETE
            IF ::AllowDelete .AND. ! ::Eof() .AND. ! ::lLocked
               IF ValType( ::bDelWhen ) == "B"
                  lGo := _OOHG_Eval( ::bDelWhen )
               ELSE
                  lGo := .T.
               ENDIF

               IF lGo
                  IF ::lNoDelMsg .OR. MsgYesNo( _OOHG_Messages( 4, 1 ), _OOHG_Messages( 4, 2 ) )
                     ::Delete()
                  ENDIF
               ELSEIF ! Empty( ::DelMsg )
                  MsgExclamation( ::DelMsg, _OOHG_Messages( 4, 2 ) )
               ENDIF
            ENDIF
         ENDCASE
      ENDIF

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

METHOD DbSkip( nRows ) CLASS TXBrowse

   LOCAL nCount, nSign

   nSign := If( ::lDescending, -1, 1 )
   ASSIGN nRows VALUE nRows TYPE "N" DEFAULT 1
   IF ValType( ::skipBlock ) == "B"
      nCount := EVAL( ::skipBlock, nRows * nSign, ::WorkArea ) * nSign
   ELSE
      nCount := ::oWorkArea:Skipper( nRows * nSign ) * nSign
   ENDIF
   ::Bof := ::Eof := .F.
   IF ! nCount == nRows
      IF nRows < 1
         ::Bof := .T.
      ELSE
         ::Eof := .T.
      ENDIF
   ENDIF

   RETURN nCount

METHOD Up() CLASS TXBrowse

   LOCAL nValue

   IF ! ::lLocked .AND. ::DbSkip( -1 ) == -1
      nValue := ::CurrentRow
      IF nValue <= 1
         IF ::ItemCount >= ::CountPerPage
            ::DeleteItem( ::ItemCount )
         ENDIF
         ::InsertBlank( 1 )
      ELSE
         nValue --
      ENDIF
      IF ::lUpdCols
         ::Refresh( nValue )
      ELSE
         ::RefreshRow( nValue )
         ::CurrentRow := nValue
      ENDIF
      ::DoChange()
   ENDIF

   RETURN Self

METHOD Down( lAppend ) CLASS TXBrowse

   LOCAL nValue, lRet := .F.

   IF ! ::lLocked
      IF ::DbSkip( 1 ) == 1
         nValue := ::CurrentRow
         IF nValue >= ::CountPerPage
            ::DeleteItem( 1 )
         ELSE
            nValue ++
         ENDIF
         IF ::lUpdCols
            ::Refresh( nValue )
         ELSE
            ::RefreshRow( nValue )
            ::CurrentRow := nValue
         ENDIF
         ::DoChange()
         lRet := .T.
      ELSE
         ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT ::AllowAppend
         IF lAppend
            lRet := ::AppendItem()
         ENDIF
      ENDIF
   ENDIF

   RETURN lRet

METHOD AppendItem( lAppend ) CLASS TXBrowse

   LOCAL lRet := .F.

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   IF ( lAppend .OR. ::AllowAppend ) .AND. ! ::lLocked .AND. ! ::lNestedEdit
      ::lNestedEdit := .T.
      ::cText := ""
      IF ::FullMove
         lRet := ::EditGrid( , , .T.)
      ELSEIF ::InPlace
         lRet := ::EditAllCells( , , .T. )
      ELSE
         lRet := ::EditItem( .T. )
      ENDIF
      ::lNestedEdit := .F.
   ENDIF

   RETURN lRet

METHOD PageUp() CLASS TXBrowse

   IF ! ::lLocked .AND. ::DbSkip( -::CountPerPage ) != 0
      ::Refresh()
      ::DoChange()
   ENDIF

   RETURN Self

METHOD PageDown( lAppend ) CLASS TXBrowse

   LOCAL nSkip, nCountPerPage

   IF ::lLocked
      // Do not move
   ELSE
      nCountPerPage := ::CountPerPage
      nSkip := ::DbSkip( nCountPerPage )
      IF nSkip != nCountPerPage
         ::Refresh( nCountPerPage )
         ::DoChange()
         ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT ::AllowAppend
         IF lAppend
            ::AppendItem()
         ENDIF
      ELSEIF nSkip != 0
         ::Refresh( , .T. )
         ::DoChange()
      ENDIF
   ENDIF

   RETURN Self

METHOD TopBottom( nDir ) CLASS TXBrowse

   IF ::lDescending
      nDir := - nDir
   ENDIF
   IF nDir == GO_BOTTOM
      IF ValType( ::goBottomBlock ) == "B"
         EVAL( ::goBottomBlock, ::WorkArea )
      ELSE
         ::oWorkArea:GoBottom()
      ENDIF
   ELSE
      IF ValType( ::goTopBlock ) == "B"
         EVAL( ::goTopBlock, ::WorkArea )
      ELSE
         ::oWorkArea:GoTop()
      ENDIF
   ENDIF
   ::Bof := ( ::lNoShowEmptyRow .AND. ::oWorkArea:IsTableEmpty() )
   ::Eof := ::oWorkArea:Eof()

   RETURN Self

METHOD GoTop() CLASS TXBrowse

   IF ! ::lLocked
      ::TopBottom( GO_TOP )
      ::Refresh( 1 )
      ::DoChange()
   ENDIF

   RETURN Self

METHOD GoBottom( lAppend ) CLASS TXBrowse

   IF ! ::lLocked
      ::TopBottom( GO_BOTTOM )
      ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
      // If it's for APPEND, leaves a blank line ;)
      ::Refresh( ::CountPerPage - If( lAppend, 1, 0 ) )
      ::DoChange()
   ENDIF

   RETURN Self

METHOD SetScrollPos( nPos, VScroll ) CLASS TXBrowse

   LOCAL aPosition

   IF ::lLocked
      // Do nothing!
   ELSEIF nPos <= VScroll:RangeMin
      ::GoTop()
   ELSEIF nPos >= VScroll:RangeMax
      ::GoBottom()
   ELSE
      IF ::lRecCount
         aPosition := { ::oWorkArea:OrdKeyNo(), ::oWorkArea:RecCount() }
      ELSE
         aPosition := { ::oWorkArea:OrdKeyNo(), ::oWorkArea:OrdKeyCount() }
      ENDIF
      nPos := nPos * aPosition[ 2 ] / VScroll:RangeMax
      #ifdef __XHARBOUR__
      IF ! ::lDescending
         ::oWorkArea:OrdKeyGoTo( nPos )
      ELSE
         ::oWorkArea:OrdKeyGoTo( aPosition[ 2 ] + 1 - nPos )
      ENDIF
      #else
      IF nPos < ( aPosition[ 2 ] / 2 )
         ::TopBottom( GO_TOP )
         ::DbSkip( MAX( nPos - 1, 0 ) )
      ELSE
         ::TopBottom( GO_BOTTOM )
         ::DbSkip( - MAX( aPosition[ 2 ] - nPos - 1, 0 ) )
      ENDIF
      #endif
      ::Refresh( , .T. )
      ::DoChange()
   ENDIF

   RETURN Self

METHOD Delete() CLASS TXBrowse

   LOCAL Value

   IF ::lLocked

      RETURN .F.
   ENDIF

   Value := ::CurrentRow
   IF Value == 0

      RETURN .F.
   ENDIF

   IF ::Lock
      IF ! ::oWorkArea:Lock()
         MsgExclamation( _OOHG_Messages(3, 9), _OOHG_Messages(4, 2) )

         RETURN .F.
      ENDIF
   ENDIF

   ::oWorkArea:Delete()

   // Do before unlocking record or moving record pointer
   // so block can operate on deleted record (e.g. to copy to a log).
   ::DoEvent( ::OnDelete, 'DELETE' )

   IF ::Lock
      ::oWorkArea:Commit()
      ::oWorkArea:UnLock()
   ENDIF

   IF ::DbSkip( 1 ) == 0
      ::GoBottom()
   ELSE
      ::Refresh()
      ::DoChange()
   ENDIF

   RETURN .T.

METHOD EditItem( lAppend, lOneRow, nItem, lChange ) CLASS TXBrowse

   LOCAL lSomethingEdited := .F.

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   ASSIGN lOneRow VALUE lOneRow TYPE "L" DEFAULT .T.
   // to work properly, nItem and the data source record must be synchronized
   HB_SYMBOL_UNUSED( lChange )

   IF ! ::lLocked
      IF ::InPlace .AND. ::lForceInPlace

         RETURN ::EditAllCells( , , lAppend, lOneRow )
      ENDIF

      IF lAppend
         IF ::lAppendMode

            RETURN .F.
         ENDIF
         ::lAppendMode := .T.
         ::GoBottom( .T. )
         ::InsertBlank( ::ItemCount + 1 )
         ::CurrentRow := ::ItemCount
         ::oWorkArea:GoTo( 0 )
      ELSE
         IF ! HB_IsNumeric( nItem )
            nItem := Max( ::CurrentRow, 1 )
         ENDIF
         IF nItem < 1 .OR. nItem > ::ItemCount

            RETURN .F.
         ENDIF
         ::SetControlValue( nItem )
      ENDIF
      IF ::lVScrollVisible
         // Kills scrollbar's events...
         ::VScroll:Enabled := .F.
         ::VScroll:Enabled := .T.
      ENDIF

      DO WHILE .T.
         IF ! ::EditItem_B( lAppend )
            EXIT
         ENDIF
         IF lAppend
            ::DoChange()
         ENDIF
         lSomethingEdited := .T.
         IF lOneRow
            EXIT
         ENDIF
         IF ! ::Down( .F. )
            EXIT
         ENDIF
      ENDDO
   ENDIF

   RETURN lSomethingEdited

METHOD EditItem_B( lAppend ) CLASS TXBrowse

   LOCAL oWorkArea, cTitle, z, nOld, nRow
   LOCAL uOldValue, oEditControl, cMemVar, bReplaceField
   LOCAL aItems, aMemVars, aReplaceFields, aEditControls, l

   IF ::lLocked .OR. ::FirstVisibleColumn == 0

      RETURN .F.
   ENDIF

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.

   oWorkArea := ::oWorkArea
   IF oWorkArea:Eof()
      IF ! lAppend .AND. ! ::AllowAppend

         RETURN .F.
      ELSE
         lAppend := .T.
      ENDIF
   ENDIF

   IF lAppend
      cTitle := _OOHG_Messages( 2, 1 )
      nOld := oWorkArea:RecNo()
      oWorkArea:GoTo( 0 )
   ELSE
      cTitle := if( ValType( ::cRowEditTitle ) $ "CM", ::cRowEditTitle, _OOHG_Messages( 2, 2 ) )
   ENDIF

   l := Len( ::aHeaders )
   aItems := ARRAY( l )
   IF ::FixControls()
      aEditControls := AClone( ::aEditControls )
   ELSE
      aEditControls := ARRAY( l )
   ENDIF
   aMemVars := ARRAY( l )
   aReplaceFields := ARRAY( l )

   FOR z := 1 To l
      oEditControl := aEditControls[ z ]
      uOldValue := cMemVar := bReplaceField := Nil
      ::GetCellType( z, @oEditControl, @uOldValue, @cMemVar, @bReplaceField, lAppend )
      aEditControls[ z ] := oEditControl
      IF ValType( uOldValue ) $ "CM"
         uOldValue := AllTrim( uOldValue )
      ENDIF
      aItems[ z ] := uOldValue
      aMemVars[ z ] := cMemVar
      aReplaceFields[ z ] := bReplaceField
   NEXT z

   IF ::Lock .AND. ! lAppend
      IF ! oWorkArea:Lock()
         MsgExclamation( _OOHG_Messages( 3, 9 ), _OOHG_Messages( 3, 10 ) )

         RETURN .F.
      ENDIF
   ENDIF

   nRow := ::CurrentRow

   IF EMPTY( oWorkArea:cAlias__ )
      aItems := ::EditItem2( nRow, aItems, aEditControls, aMemVars, cTitle )
   ELSE
      aItems := ( oWorkArea:cAlias__ )->( ::EditItem2( nRow, aItems, aEditControls, aMemVars, cTitle ) )
   ENDIF

   IF Empty( aItems )
      IF lAppend
         ::GoBottom()
         ::lAppendMode := .F.
         oWorkArea:GoTo( nOld )
      ENDIF
      ::DoEvent( ::OnAbortEdit, "ABORTEDIT", { nRow, 0 } )
   ELSE
      _SetThisCellInfo( ::hWnd, nRow, 0, Nil )
      ::DoEvent( ::OnEditCellEnd, "EDITCELLEND", { nRow, 0 } )
      _ClearThisCellInfo()

      IF lAppend
         oWorkArea:Append()
      ENDIF

      FOR z := 1 To Len( aItems )
         IF ::IsColumnReadOnly( z, nRow )
            // Readonly field
         ELSEIF ! ::IsColumnWhen( z, nRow )
            // Not a valid when
         ELSEIF aScan( ::aHiddenCols, z ) > 0
            // Hidden column
         ELSE
            _OOHG_Eval( aReplaceFields[ z ], aItems[ z ], oWorkArea )
         ENDIF
      NEXT z

      IF lAppend
         ::lAppendMode := .F.
         _SetThisCellInfo( ::hWnd, nRow, 0, Nil )
         IF ! EMPTY( oWorkArea:cAlias__ )
            ( oWorkArea:cAlias__ )->( ::DoEvent( ::OnAppend, "APPEND" ) )
         ELSE
            ::DoEvent( ::OnAppend, "APPEND" )
         ENDIF
         _ClearThisCellInfo()
      ENDIF

      IF ::RefreshType == REFRESH_NO
         ::RefreshRow( nRow )
      ELSE
         ::Refresh()
      ENDIF

      _SetThisCellInfo( ::hWnd, nRow, 0, Nil )
      ::DoEvent( ::OnEditCell, "EDITCELL", { nRow, 0 } )
      _ClearThisCellInfo()
   ENDIF

   IF ::Lock
      oWorkArea:Commit()
      oWorkArea:Unlock()
   ENDIF

   RETURN ! Empty( aItems )

METHOD EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, nOnFocusPos, lChange, lAppend ) CLASS TXBrowse

   LOCAL lRet, bReplaceField, oWorkArea, i, aItem, aRepl, aVals, oCtr, uVal, bRep, aNewI, lRet2

   IF ::lLocked

      RETURN .F.
   ENDIF
   IF ::FirstVisibleColumn == 0

      RETURN .F.
   ENDIF
   IF ! HB_IsNumeric( nRow )
      nRow := Max( ::CurrentRow, 1 )
   ENDIF
   /*
   * lAppend == .T. means that beforehand an empty row was added to the grid
   * at position nRow, and that ::EditCell must edit it, append a new record
   * and save the data into the data source when the edition is confirmed.
   * When the edition is aborted, the caller must deal with the added row
   * (typicaly it's deleted using method GoBottom).
   */
   oWorkArea := ::oWorkArea
   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   IF oWorkArea:EOF() .AND. ! lAppend .AND. ! ::AllowAppend

      RETURN .F.
   ENDIF
   IF oWorkArea:EOF()
      lAppend := .T.
   ENDIF
   IF ! HB_IsNumeric( nCol )
      IF ::lAppendMode .OR. lAppend .OR. ::lAtFirstCol
         nCol := ::FirstColInOrder
      ELSE
         nCol := ::FirstVisibleColumn
      ENDIF
   ENDIF
   IF nRow < 1 .OR. nRow > ::ItemCount .OR. nCol < 1 .OR. nCol > Len( ::aHeaders )

      RETURN .F.
   ENDIF
   IF aScan( ::aHiddenCols, nCol ) > 0

      RETURN .F.
   ENDIF

   // to work properly, nRow and the data source record must be synchronized
   HB_SYMBOL_UNUSED( lChange )
   ::SetControlValue( nRow, nCol )                                // Second parameter is needed by TXBrowseByCell:EditCell

   IF lAppend
      ::lAppendMode := .T.
      aItem := Array( Len( ::aHeaders ) )
      aVals := Array( Len( ::aHeaders ) )
      aRepl := Array( Len( ::aHeaders ) )
      FOR i := 1 To nCol - 1
         oCtr := uVal := bRep := Nil
         ::GetCellType( i, @oCtr, @uVal, , @bRep, .T. )
         aItem[ i ] := oCtr:GridValue( uVal )
         aVals[ i ] := uVal
         aRepl[ i ] := bRep
      NEXT i
      ::GetCellType( nCol, @EditControl, @uOldValue, @cMemVar, @bReplaceField, .T. )
      aItem[ nCol ] := EditControl:GridValue( uOldValue )
      aVals[ nCol ] := uOldValue
      aRepl[ nCol ] := bReplaceField
      FOR i := nCol + 1 To Len( ::aHeaders )
         oCtr := uVal := bRep := Nil
         ::GetCellType( i, @oCtr, @uVal, , @bRep, .T. )
         aItem[ i ] := oCtr:GridValue( uVal )
         aVals[ i ] := uVal
         aRepl[ i ] := bRep
      NEXT i
      // Show default values in the edit row
      aNewI := ::Item( nRow )
      FOR i := 1 to Len( ::aHeaders )
         IF ! HB_IsNil( ::aDefaultValues[ i ] )
            aNewI[ i ] := aItem[ i ]
         ENDIF
      NEXT i
      ::Item( nRow, aNewI )
   ELSE
      IF ::Lock .AND. ! oWorkArea:Lock()
         MsgExclamation( _OOHG_Messages( 3, 9 ), _OOHG_Messages( 3, 10 ) )

         RETURN .F.
      ENDIF
      ::GetCellType( nCol, @EditControl, @uOldValue, @cMemVar, @bReplaceField, lAppend )
   ENDIF

   IF HB_IsBlock( ::OnBeforeEditCell )
      _OOHG_ThisItemCellValue := uOldValue
      lRet2 := ::DoEvent( ::OnBeforeEditCell, "BEFOREEDITCELL", { nRow, nCol } )
      _ClearThisCellInfo()
      IF ! HB_IsLogical( lRet2 )
         lRet2 := .T.
      ENDIF
   ELSE
      lRet2 := .T.
   ENDIF

   IF lRet2
      lRet := ::EditCell2( @nRow, @nCol, @EditControl, uOldValue, @uValue, cMemVar, nOnFocusPos )
   ELSE
      lRet := .F.
   ENDIF

   IF lRet
      _SetThisCellInfo( ::hWnd, nRow, nCol, uValue )
      ::DoEvent( ::OnEditCellEnd, "EDITCELLEND", { nRow, nCol } )
      _ClearThisCellInfo()
      IF lAppend
         oWorkArea:Append()
         // Set edited and default values into the appended record
         aVals[ nCol ] := uValue
         FOR i := 1 To Len( ::aHeaders )
            _OOHG_Eval( aRepl[ i ], aVals[ i ], oWorkArea )
         NEXT i
         ::lAppendMode := .F.
         _SetThisCellInfo( ::hWnd, nRow, nCol, uValue )
         IF ! EMPTY( oWorkArea:cAlias__ )
            ( oWorkArea:cAlias__ )->( ::DoEvent( ::OnAppend, "APPEND" ) )
         ELSE
            ::DoEvent( ::OnAppend, "APPEND" )
         ENDIF
         _ClearThisCellInfo()
      ELSE
         _OOHG_Eval( bReplaceField, uValue, oWorkArea )
      ENDIF
      ::RefreshRow( nRow )
      _SetThisCellInfo( ::hWnd, nRow, nCol, uValue )
      ::DoEvent( ::OnEditCell, "EDITCELL", { nRow, nCol } )
      _ClearThisCellInfo()
      IF ! ::lCalledFromClass .AND. ::bPosition == 9                  // MOUSE EXIT
         // Edition window lost focus
         ::bPosition := 0                   // This restores the processing of click messages
         IF ::nDelayedClick[ 1 ] > 0
            // A click message was delayed
            IF ::nDelayedClick[ 3 ] <= 0
               ::MoveTo( ::nDelayedClick[ 1 ], ::nRowPos )
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
   ELSEIF lAppend
      ::lAppendMode := .F.
      ::DoEvent( ::OnAbortEdit, "ABORTEDIT", { 0, 0 } )
   ELSE
      ::DoEvent( ::OnAbortEdit, "ABORTEDIT", { nRow, nCol } )
   ENDIF
   IF ::Lock
      oWorkArea:Commit()
      oWorkArea:UnLock()
   ENDIF

   RETURN lRet

METHOD EditAllCells( nRow, nCol, lAppend, lOneRow, lChange ) CLASS TXBrowse

   LOCAL lRet, lSomethingEdited

   HB_SYMBOL_UNUSED( lChange)

   IF ::FullMove

      RETURN ::EditGrid( nRow, nCol, lAppend, lOneRow, lChange )
   ENDIF
   IF ::lLocked

      RETURN .F.
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
      IF ::lAppendMode

         RETURN .F.
      ENDIF
      ::lAppendMode := .T.
      ::GoBottom( .T. )
      ::InsertBlank( ::ItemCount + 1 )
      ::CurrentRow := ::ItemCount
      ::oWorkArea:GoTo( 0 )
   ELSE
      IF ! HB_IsNumeric( nRow )
         nRow := Max( ::CurrentRow, 1 )
      ENDIF
      IF nRow < 1 .OR. nRow > ::ItemCount

         RETURN .F.
      ENDIF
      // to work properly, nRow and the data source record must be synchronized
      ::SetControlValue( nRow )
   ENDIF

   ASSIGN lOneRow VALUE lOneRow TYPE "L" DEFAULT .T.

   lSomethingEdited := .F.

   DO WHILE nCol >= 1 .AND. nCol <= Len( ::aHeaders )
      _OOHG_ThisItemCellValue := ::Cell( ::nRowPos, nCol )

      IF ::IsColumnReadOnly( nCol, ::nRowPos )
         // Read only column
      ELSEIF ! ::IsColumnWhen( nCol, ::nRowPos )
         // Not a valid WHEN
      ELSEIF aScan( ::aHiddenCols, nCol ) > 0
         // Hidden column
      ELSE
         ::lCalledFromClass := .T.
         lRet := ::EditCell( ::nRowPos, nCol, , , , , , , ::lAppendMode )
         ::lCalledFromClass := .F.

         IF ::lAppendMode
            ::lAppendMode := .F.
            IF lRet
               lSomethingEdited := .T.
            ELSE
               ::GoBottom()
               EXIT
            ENDIF
         ELSEIF lRet
            lSomethingEdited := .T.
         ELSE
            EXIT
         ENDIF

         IF ::bPosition == 9                     // MOUSE EXIT
            // Edition window lost focus
            ::bPosition := 0                     // This restores the processing of click messages
            IF ::nDelayedClick[ 1 ] > 0
               // A click message was delayed
               IF ::nDelayedClick[ 3 ] <= 0
                  ::MoveTo( ::nDelayedClick[ 1 ], ::nRowPos )
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
            EXIT
         ENDIF
      ENDIF

      nCol := ::NextColInOrder( nCol )
      IF nCol == 0
         IF lOneRow
            EXIT
         ENDIF
         nCol := ::FirstColInOrder
         IF nCol == 0
            EXIT
         ENDIF
         IF ! ::Down( .F. )
            IF ! lAppend .AND. ! ::AllowAppend
               EXIT
            ENDIF
            ::lAppendMode := .T.
            ::GoBottom( .T. )
            ::InsertBlank( ::ItemCount + 1 )
            ::CurrentRow := ::ItemCount
            ::oWorkArea:GoTo( 0 )
         ENDIF
         ::ScrollToLeft()
      ENDIF
   ENDDO

   ::ScrollToLeft()

   RETURN lSomethingEdited

METHOD EditGrid( nRow, nCol, lAppend, lOneRow, lChange ) CLASS TXBrowse

   LOCAL lRet, lSomethingEdited

   HB_SYMBOL_UNUSED( lChange)

   IF ::lLocked

      RETURN .F.
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
      IF ::lAppendMode

         RETURN .F.
      ENDIF
      ::lAppendMode := .T.
      ::GoBottom( .T. )
      ::InsertBlank( ::ItemCount + 1 )
      ::CurrentRow := ::ItemCount
      ::oWorkArea:GoTo( 0 )
   ELSE
      IF ! HB_IsNumeric( nRow )
         nRow := Max( ::CurrentRow, 1 )
      ENDIF
      IF nRow < 1 .OR. nRow > ::ItemCount

         RETURN .F.
      ENDIF
      // to work properly, nRow and the data source record must be synchronized
      ::SetControlValue( nRow )
   ENDIF

   lSomethingEdited := .F.

   DO WHILE nCol >= 1 .AND. nCol <= Len( ::aHeaders )
      _OOHG_ThisItemCellValue := ::Cell( ::nRowPos, nCol )

      IF ::IsColumnReadOnly( nCol, ::nRowPos )
         // Read only column, skip
      ELSEIF ! ::IsColumnWhen( nCol, ::nRowPos )
         // Not a valid WHEN, skip
      ELSEIF aScan( ::aHiddenCols, nCol ) > 0
         // Hidden column, skip
      ELSE
         ::lCalledFromClass := .T.
         lRet := ::EditCell( ::nRowPos, nCol, , , , , , , ::lAppendMode )
         ::lCalledFromClass := .F.

         IF ::lAppendMode
            ::lAppendMode := .F.
            IF lRet
               lSomethingEdited := .T.
            ELSE
               ::GoBottom()
               EXIT
            ENDIF
         ELSEIF lRet
            lSomethingEdited := .T.
         ELSE
            EXIT
         ENDIF

         IF ::bPosition == 9                     // MOUSE EXIT
            // Edition window lost focus
            ::bPosition := 0                     // This restores the processing of click messages
            IF ::nDelayedClick[ 1 ] > 0
               // A click message was delayed, set the clicked row as new current row
               IF ::nDelayedClick[ 3 ] <= 0
                  ::MoveTo( ::nDelayedClick[ 1 ], ::nRowPos )
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
            EXIT
         ENDIF
      ENDIF

      nCol := ::NextColInOrder( nCol )
      IF nCol == 0
         IF HB_IsLogical( lOneRow ) .AND. lOneRow
            EXIT
         ELSEIF ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove
            EXIT
         ENDIF
         nCol := ::FirstColInOrder
         IF nCol == 0
            EXIT
         ENDIF
         IF ! ::Down( .F. )
            IF ! lAppend .AND. ! ::AllowAppend
               EXIT
            ENDIF
            ::lAppendMode := .T.
            ::GoBottom( .T. )
            ::InsertBlank( ::ItemCount + 1 )
            ::CurrentRow := ::ItemCount
            ::oWorkArea:GoTo( 0 )
         ENDIF
         ::ScrollToLeft()
      ENDIF
   ENDDO

   ::ScrollToLeft()

   RETURN lSomethingEdited

METHOD GetCellType( nCol, EditControl, uOldValue, cMemVar, bReplaceField, lAppend ) CLASS TXBrowse

   LOCAL cField, cArea, nPos, aStruct

   IF ValType( nCol ) != "N"
      nCol := 1
   ENDIF
   IF nCol < 1 .OR. nCol > Len( ::aHeaders )
      // Cell out of range

      RETURN .F.
   ENDIF

   IF ValType( uOldValue ) == "U"
      ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
      IF ! lAppend .OR. HB_IsNil( ::aDefaultValues[ nCol ] )
         uOldValue := EVAL( ::ColumnBlock( nCol, .T. ), ::WorkArea )
      ELSEIF HB_IsBlock( ::aDefaultValues[ nCol ] )
         uOldValue := EVAL( ::aDefaultValues[ nCol ], nCol )
      ELSE
         uOldValue := ::aDefaultValues[ nCol ]
      ENDIF
   ENDIF

   IF ValType( ::aReplaceField ) == "A" .AND. Len( ::aReplaceField ) >= nCol
      bReplaceField := ::aReplaceField[ nCol ]
   ELSE
      bReplaceField := Nil
   ENDIF

   // Default cMemVar & bReplaceField
   IF ValType( ::aFields[ nCol ] ) $ "CM"
      cField := Upper( AllTrim( ::aFields[ nCol ] ) )
      nPos := At( '->', cField )
      IF nPos != 0 .AND. Select( Trim( Left( cField, nPos - 1 ) ) ) != 0
         cArea := Trim( Left( cField, nPos - 1 ) )
         cField := Ltrim( SubStr( cField, nPos + 2 ) )
         aStruct := ( cArea )->( DbStruct() )
         nPos := ( cArea )->( FieldPos( cField ) )
      ELSE
         cArea := ::oWorkArea:cAlias__
         aStruct := ::oWorkArea:DbStruct()
         nPos := ::oWorkArea:FieldPos( cField )
      ENDIF
      IF nPos # 0
         IF ! ValType( cMemVar ) $ "CM" .OR. Empty( cMemVar )
            cMemVar := "MemVar" + cArea + cField
         ENDIF
         IF ValType( bReplaceField ) != "B"
            bReplaceField := FieldWBlock( cField, Select( cArea ) )
         ENDIF
      ENDIF
   ELSE
      nPos := 0
   ENDIF

   // Determines control type
   IF ! HB_IsObject( EditControl ) .AND. ::FixControls()
      EditControl := ::aEditControls[ nCol ]
   ENDIF
   EditControl := GetEditControlFromArray( EditControl, ::EditControls, nCol, Self )
   IF HB_IsObject( EditControl )
      // EditControl specified
   ELSEIF ValType( ::Picture[ nCol ] ) $ "CM"
      // Picture-based
      EditControl := TGridControlTextBox():New( ::Picture[ nCol ], , ValType( uOldValue ), , , , Self )
   ELSEIF ValType( ::Picture[ nCol ] ) == "L" .AND. ::Picture[ nCol ]
      EditControl := TGridControlImageList():New( Self )
   ELSEIF nPos == 0
      EditControl := GridControlObjectByType( uOldValue, Self )
   ELSEIF aStruct[ nPos ][ 2 ] == "N"                                         // Use field type
      IF aStruct[ nPos ][ 4 ] == 0
         EditControl := TGridControlTextBox():New( Replicate( "9", aStruct[ nPos ][ 3 ] ), , "N", , , , Self )
      ELSE
         EditControl := TGridControlTextBox():New( Replicate( "9", aStruct[ nPos ][ 3 ] - aStruct[ nPos ][ 4 ] - 1 ) + "." + Replicate( "9", aStruct[ nPos ][ 4 ] ), , "N", , , , Self )
      ENDIF
   ELSEIF aStruct[ nPos ][ 2 ] == "L"
      // EditControl := TGridControlCheckBox():New( , , , , Self)
      EditControl := TGridControlLComboBox():New( , , , , Self )
   ELSEIF aStruct[ nPos ][ 2 ] == "M"
      EditControl := TGridControlMemo():New( , , Self )
   ELSEIF aStruct[ nPos ][ 2 ] == "D"
      // EditControl := TGridControlDatePicker():New( .T., , , , Self )
      EditControl := TGridControlTextBox():New( "@D", , "D", , , , Self )
   ELSEIF aStruct[ nPos ][ 2 ] == "C"
      EditControl := TGridControlTextBox():New( "@S" + Ltrim( Str( aStruct[ nPos ][ 3 ] ) ), , "C", , , , Self )
   ELSE
      // Unimplemented field type !!!
      EditControl := GridControlObjectByType( uOldValue, Self )
   ENDIF

   RETURN .T.

METHOD ColumnWidth( nColumn, nWidth ) CLASS TXBrowse

   LOCAL nRet

   nRet := ::Super:ColumnWidth( nColumn, nWidth )
   ::AdjustRightScroll()

   RETURN nRet

METHOD ColumnAutoFit( nColumn ) CLASS TXBrowse

   LOCAL nRet

   nRet := ::Super:ColumnAutoFit( nColumn )
   ::AdjustRightScroll()

   RETURN nRet

METHOD ColumnAutoFitH( nColumn ) CLASS TXBrowse

   LOCAL nRet

   nRet := ::Super:ColumnAutoFitH( nColumn )
   ::AdjustRightScroll()

   RETURN nRet

METHOD ColumnsAutoFit() CLASS TXBrowse

   LOCAL nRet

   nRet := ::Super:ColumnsAutoFit()
   ::AdjustRightScroll()

   RETURN nRet

METHOD ColumnsAutoFitH() CLASS TXBrowse

   LOCAL nRet

   nRet := ::Super:ColumnsAutoFitH()
   ::AdjustRightScroll()

   RETURN nRet

METHOD WorkArea( uWorkArea ) CLASS TXBrowse

   IF PCOUNT() > 0
      IF ValType( uWorkArea ) == "O"
         ::uWorkArea := uWorkArea
         ::oWorkArea := uWorkArea
      ELSEIF ValType( uWorkArea ) $ "CM" .AND. ! EMPTY( uWorkArea )
         uWorkArea := ALLTRIM( UPPER( uWorkArea ) )
         ::uWorkArea := uWorkArea
         ::oWorkArea := ooHGRecord():New( uWorkArea )
      ELSE
         ::uWorkArea := Nil
         ::oWorkArea := Nil
      ENDIF
   ENDIF

   RETURN ::uWorkArea

METHOD AddColumn( nColIndex, xField, cHeader, nWidth, nJustify, uForeColor, ;
      uBackColor, lNoDelete, uPicture, uEditControl, uHeadClick, ;
      uValid, uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign, ;
      uReplaceField, lRefresh, uReadOnly, uDefault ) CLASS TXBrowse

   LOCAL nRet, nColumns := Len( ::aHeaders ) + 1

   // Set Default Values
   IF ! HB_IsNumeric( nColIndex ) .OR. nColIndex > nColumns
      nColIndex := nColumns
   ELSEIF nColIndex < 1
      nColIndex := 1
   ENDIF

   aSize( ::aFields, nColumns )
   aIns( ::aFields, nColIndex )
   ::aFields[ nColIndex ] := xField

   // Update before calling ::ColumnBlock
   aSize( ::aDefaultValues, nColumns )
   ::aDefaultValues[ nColIndex ] := uDefault

   IF ValType( uEditControl ) != Nil .OR. HB_IsArray( ::EditControls )
      IF ! HB_IsArray( ::EditControls )
         ::EditControls := Array( nColumns )
      ELSEIF Len( ::EditControls ) < nColumns
         aSize( ::EditControls, nColumns )
      ENDIF
      aIns( ::EditControls, nColIndex )
      ::EditControls[ nColIndex ] := uEditControl
      IF ::FixControls()
         ::FixControls( .T. )
      ENDIF
   ENDIF

   // Update after updating ::EditControls
   IF ::FixBlocks()
      // Update before calling ::ColumnBlock
      ASize( ::Picture, nColumns )
      AIns( ::Picture, nColIndex )
      ::Picture[ nColIndex ] := Iif( ( ValType( uPicture ) $ "CM" .AND. ! Empty( uPicture ) ) .OR. HB_IsLogical( uPicture ), uPicture, Nil )

      aSize( ::aColumnBlocks, nColumns )
      aIns( ::aColumnBlocks, nColIndex )
      ::aColumnBlocks[ nColIndex ] := ::ColumnBlock( nColIndex )
   ENDIF

   IF HB_IsArray( ::aReplaceField )
      aSize( ::aReplaceField, nColumns )
      aIns( ::aReplaceField, nColIndex )
   ELSE
      ::aReplaceField := ARRAY( nColumns )
   ENDIF
   ::aReplaceField[ nColIndex ] := uReplaceField

   nRet := ::Super:AddColumn( nColIndex, cHeader, nWidth, nJustify, uForeColor, ;
      uBackColor, lNoDelete, uPicture, uEditControl, uHeadClick, ;
      uValid, uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign, ;
      uReadOnly )
   IF nRet # nColIndex
      MsgOOHGError( "XBrowse: Column added in another place. Program terminated." )
   ENDIF

   IF ! HB_IsLogical( lRefresh ) .OR. lRefresh
      ::Refresh()
   ENDIF

   RETURN nRet

METHOD DeleteColumn( nColIndex, lRefresh ) CLASS TXBrowse

   LOCAL nColumns, nRet

   nColumns := Len( ::aHeaders )
   IF nColumns == 0

      RETURN 0
   ENDIF
   IF ! HB_IsNumeric( nColIndex ) .OR. nColIndex > nColumns
      nColIndex := nColumns
   ELSEIF nColIndex < 1
      nColIndex := 1
   ENDIF

   _OOHG_DeleteArrayItem( ::aFields,  nColIndex )
   _OOHG_DeleteArrayItem( ::aColumnBlocks,  nColIndex )
   _OOHG_DeleteArrayItem( ::aReplaceField,  nColIndex )

   nRet := ::Super:DeleteColumn( nColIndex )

   IF ! HB_IsLogical( lRefresh ) .OR. lRefresh
      ::Refresh()
   ENDIF

   RETURN nRet

METHOD SetColumn( nColIndex, xField, cHeader, nWidth, nJustify, uForeColor, ;
      uBackColor, lNoDelete, uPicture, uEditControl, uHeadClick, ;
      uValid, uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign, ;
      uReplaceField, lRefresh, uReadOnly ) CLASS TXBrowse

   LOCAL nRet, nColumns := Len( ::aHeaders )

   // Set Default Values
   IF ! HB_IsNumeric( nColIndex ) .OR. nColIndex > nColumns
      nColIndex := nColumns
   ELSEIF nColIndex < 1
      nColIndex := 1
   ENDIF

   ::aFields[ nColIndex ] := xField

   // Update before calling ::ColumnBlock
   IF ValType( uEditControl ) != Nil .OR. HB_IsArray( ::EditControls )
      IF ! HB_IsArray( ::EditControls )
         ::EditControls := Array( nColumns )
      ELSEIF Len( ::EditControls ) < nColumns
         aSize( ::EditControls, nColumns )
      ENDIF
      ::EditControls[ nColIndex ] := uEditControl
      IF ::FixControls()
         ::FixControls( .T. )
      ENDIF
   ENDIF

   // Update after updating ::EditControls
   IF ::FixBlocks()
      ::aColumnBlocks[ nColIndex ] := ::ColumnBlock( nColIndex )
   ENDIF

   IF ! HB_IsArray( ::aReplaceField )
      ::aReplaceField := ARRAY( LEN( ::aFields ) )
   ENDIF
   ::aReplaceField[ nColIndex ] := uReplaceField

   nRet := ::Super:SetColumn( nColIndex, cHeader, nWidth, nJustify, uForeColor, ;
      uBackColor, lNoDelete, uPicture, uEditControl, uHeadClick, ;
      uValid, uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign, ;
      uReadOnly )

   IF ! HB_IsLogical( lRefresh ) .OR. lRefresh
      ::Refresh()
   ENDIF

   RETURN nRet

METHOD VScrollVisible( lState ) CLASS TXBrowse

   IF HB_IsLogical( lState ) .AND. lState # ::lVScrollVisible
      IF ::lVScrollVisible
         ::VScroll:Visible := .F.
         ::VScroll := Nil
      ELSE
         ::VScroll := ::VScrollCopy
         ::VScroll:Visible := .T.
      ENDIF
      ::lVScrollVisible := lState
      ::ScrollButton:Visible := lState
      ::SizePos()
   ENDIF

   RETURN ::lVScrollVisible

CLASS ooHGRecord

   DATA cAlias__

   METHOD New
   METHOD Use
   METHOD Skipper
   METHOD OrdScope
   METHOD Filter
   METHOD IsTableEmpty

   METHOD Field       BLOCK { | Self, nPos |                   ( ::cAlias__ )->( Field( nPos ) ) }
   METHOD FieldBlock  BLOCK { | Self, cField |                 ( ::cAlias__ )->( FieldBlock( cField ) ) }
   METHOD FieldGet    BLOCK { | Self, nPos |                   ( ::cAlias__ )->( FieldGet( nPos ) ) }
   METHOD FieldName   BLOCK { | Self, nPos |                   ( ::cAlias__ )->( FieldName( nPos ) ) }
   METHOD FieldPos    BLOCK { | Self, cField |                 ( ::cAlias__ )->( FieldPos( cField ) ) }
   METHOD FieldPut    BLOCK { | Self, nPos, uValue |           ( ::cAlias__ )->( FieldPut( nPos, uValue ) ) }
   METHOD Locate      BLOCK { | Self, bFor, bWhile, nNext, nRec, lRest | ( ::cAlias__ )->( __dbLocate( bFor, bWhile, nNext, nRec, lRest ) ) }
   METHOD Seek        BLOCK { | Self, uKey, lSoftSeek, lLast | ( ::cAlias__ )->( DbSeek( uKey, lSoftSeek, lLast ) ) }
   METHOD Skip        BLOCK { | Self, nCount |                 ( ::cAlias__ )->( DbSkip( nCount ) ) }
   METHOD GoTo        BLOCK { | Self, nRecord |                ( ::cAlias__ )->( DbGoTo( nRecord ) ) }
   METHOD GoTop       BLOCK { | Self |                         ( ::cAlias__ )->( DbGoTop() ) }
   METHOD GoBottom    BLOCK { | Self |                         ( ::cAlias__ )->( DbGoBottom() ) }
   METHOD Commit      BLOCK { | Self |                         ( ::cAlias__ )->( DbCommit() ) }
   METHOD Unlock      BLOCK { | Self |                         ( ::cAlias__ )->( DbUnlock() ) }
   METHOD Delete      BLOCK { | Self |                         ( ::cAlias__ )->( DbDelete() ) }
   METHOD Close       BLOCK { | Self |                         ( ::cAlias__ )->( DbCloseArea() ) }
   METHOD BOF         BLOCK { | Self |                         ( ::cAlias__ )->( BOF() ) }
   METHOD EOF         BLOCK { | Self |                         ( ::cAlias__ )->( EOF() ) }
   METHOD RecNo       BLOCK { | Self |                         ( ::cAlias__ )->( RecNo() ) }
   METHOD RecCount    BLOCK { | Self |                         ( ::cAlias__ )->( RecCount() ) }
   METHOD Found       BLOCK { | Self |                         ( ::cAlias__ )->( Found() ) }
   METHOD SetOrder    BLOCK { | Self, uOrder |                 ( ::cAlias__ )->( ORDSETFOCUS( uOrder ) ) }
   METHOD SetIndex    BLOCK { | Self, cFile, lAdditive |       If( EMPTY( lAdditive ), ( ::cAlias__ )->( ordListClear() ), ) , ( ::cAlias__ )->( ordListAdd( cFile ) ) }
   METHOD Append      BLOCK { | Self |                         ( ::cAlias__ )->( DbAppend() ) }
   METHOD Lock        BLOCK { | Self |                         ( ::cAlias__ )->( RLock() ) }
   METHOD DbStruct    BLOCK { | Self |                         ( ::cAlias__ )->( DbStruct() ) }
   METHOD OrdKeyNo    BLOCK { | Self |                         If( ( ::cAlias__ )->( OrdKeyCount() ) > 0, ( ::cAlias__ )->( OrdKeyNo() ), ( ::cAlias__ )->( RecNo() ) ) }
   METHOD OrdKeyCount BLOCK { | Self |                         If( ( ::cAlias__ )->( OrdKeyCount() ) > 0, ( ::cAlias__ )->( OrdKeyCount() ), ( ::cAlias__ )->( RecCount() ) ) }
   METHOD OrdKeyGoTo  BLOCK { | Self, nRecord |                ( ::cAlias__ )->( OrdKeyGoTo( nRecord ) ) }

   ERROR HANDLER FieldAssign

   ENDCLASS

METHOD IsTableEmpty CLASS ooHGRecord

   LOCAL lEmpty

   IF ::EOF()
      IF ::BOF()
         lEmpty := .T.
      ELSE
         ::Skip( -1 )
         lEmpty := ::BOF()
         ::Skip( 1 )
      ENDIF
   ELSE
      IF ::BOF()
         ::GoTop()
         lEmpty := ::EOF()
      ELSE
         lEmpty := .F.
      ENDIF
   ENDIF

   RETURN lEmpty

METHOD FieldAssign( xValue ) CLASS ooHGRecord

   LOCAL nPos, cMessage, uRet, cAlias, lError

   cAlias := ::cAlias__
   cMessage := ALLTRIM( UPPER( __GetMessage() ) )
   lError := .T.
   IF PCOUNT() == 0
      nPos := ( cAlias )->( FieldPos( cMessage ) )
      IF nPos > 0
         uRet := ( cAlias )->( FieldGet( nPos ) )
         lError := .F.
      ENDIF
   ELSEIF PCOUNT() == 1
      nPos := ( cAlias )->( FieldPos( SUBSTR( cMessage, 2 ) ) )
      IF nPos > 0
         uRet := ( cAlias )->( FieldPut( nPos, xValue ) )
         lError := .F.
      ENDIF
   ENDIF
   IF lError
      uRet := Nil
      ::MsgNotFound( cMessage )
   ENDIF

   RETURN uRet

METHOD New( cAlias ) CLASS ooHGRecord

   IF ! ValType( cAlias ) $ "CM" .OR. EMPTY( cAlias )
      ::cAlias__ := ALIAS()
   ELSE
      ::cAlias__ := UPPER( ALLTRIM( cAlias ) )
   ENDIF

   RETURN Self

METHOD Use( cFile, cAlias, cRDD, lShared, lReadOnly ) CLASS ooHGRecord

   DbUseArea( .T., cRDD, cFile, cAlias, lShared, lReadOnly )
   ::cAlias__ := ALIAS()

   RETURN Self

METHOD Skipper( nSkip ) CLASS ooHGRecord

   LOCAL nCount

   nCount := 0
   nSkip := If( ValType( nSkip ) == "N", INT( nSkip ), 1 )
   IF nSkip == 0
      ::Skip( 0 )
   ELSE
      DO WHILE nSkip != 0
         IF nSkip > 0
            ::Skip( 1 )
            IF ::EOF()
               ::Skip( -1 )
               EXIT
            ELSE
               nCount ++
               nSkip --
            ENDIF
         ELSE
            ::Skip( -1 )
            IF ::BOF()
               EXIT
            ELSE
               nCount --
               nSkip ++
            ENDIF
         ENDIF
      ENDDO
   ENDIF

   RETURN nCount

METHOD OrdScope( uFrom, uTo ) CLASS ooHGRecord

   IF PCOUNT() == 0
      ( ::cAlias )->( ORDSCOPE( 0, Nil ) )
      ( ::cAlias )->( ORDSCOPE( 1, Nil ) )
   ELSEIF PCOUNT() == 1
      ( ::cAlias )->( ORDSCOPE( 0, uFrom ) )
      ( ::cAlias )->( ORDSCOPE( 1, uFrom ) )
   ELSE
      ( ::cAlias )->( ORDSCOPE( 0, uFrom ) )
      ( ::cAlias )->( ORDSCOPE( 1, uTo ) )
   ENDIF

   RETURN Self

METHOD Filter( cFilter ) CLASS ooHGRecord

   IF EMPTY( cFilter )
      ( ::cAlias__ )->( DbClearFilter() )
   ELSE
      ( ::cAlias__ )->( DbSetFilter( { || &( cFilter ) } , cFilter ) )
   ENDIF

   RETURN Self

CLASS TVirtualField

   DATA bRecordId                 INIT Nil
   DATA hValues                   INIT Nil
   DATA xArea                     INIT Nil
   DATA xDefault                  INIT Nil

   METHOD New
   METHOD RecordId
   METHOD Value                   SETGET

   ENDCLASS

METHOD New( xSource, xDefault ) CLASS TVirtualField

   ::hValues := { => }
   IF     HB_IsBlock( xSource )
      ::bRecordId := xSource
   ELSEIF HB_IsObject( xSource ) .OR. HB_IsString( xSource )
      ::xArea := xSource
   ENDIF
   IF PCOUNT() >= 2
      ::xDefault := xDefault
   ENDIF

   RETURN Self

METHOD Value( xValue ) CLASS TVirtualField

   LOCAL xRecordId

   xRecordId := ::RecordId()
   IF     PCOUNT() >= 1
      ::hValues[ xRecordId ] := xValue
   ELSEIF ! xRecordId $ ::hValues
      IF HB_IsBlock( ::xDefault )
         ::hValues[ xRecordId ] := EVAL( ::xDefault )
      ELSE
         ::hValues[ xRecordId ] := ::xDefault
      ENDIF
   ENDIF

   RETURN ::hValues[ xRecordId ]

METHOD RecordId() CLASS TVirtualField

   LOCAL xId

   IF     HB_IsBlock( ::bRecordId )
      xId := EVAL( ::bRecordId )
   ELSEIF HB_IsObject( ::xArea )
      xId := ::xArea:RecNo()
   ELSEIF HB_IsString( ::xArea )
      xId := ( ::xArea )->( RecNo() )
   ELSE
      xId := RecNo()
   ENDIF

   RETURN xId

CLASS TXBrowseByCell FROM TXBrowse

   DATA Type                      INIT "XBROWSEBYCELL" READONLY

   METHOD AddColumn
   METHOD CurrentCol              SETGET
   METHOD Define2
   METHOD Define3
   METHOD DeleteAllItems          BLOCK { | Self | ::nColPos := 0, ::Super:DeleteAllItems() }
   METHOD DeleteColumn
   METHOD Down
   METHOD EditAllCells
   METHOD EditCell
   METHOD EditGrid
   METHOD End
   METHOD Events
   METHOD Events_Notify
   METHOD GoBottom
   METHOD GoTop
   METHOD Home
   METHOD Left
   METHOD MoveTo
   METHOD MoveToFirstCol
   METHOD MoveToFirstVisibleCol
   METHOD MoveToLastCol
   METHOD MoveToLastVisibleCol
   METHOD Refresh
   METHOD Right
   METHOD SetControlValue         SETGET
   METHOD SetSelectedColors
   METHOD Up
   METHOD Value                   SETGET

   /*
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
   DbSkip
   Define
   Define4
   Delete
   DoChange
   EditItem
   EditItem_B
   Enabled
   FixBlocks
   FixControls
   GetCellType
   HelpId
   PageDown
   PageUp
   RefreshData
   RefreshRow
   SetColumn
   SetScrollPos
   SizePos
   ToExcel
   ToolTip
   ToOpenOffice
   TopBottom
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
   CheckItem
   ColumnBetterAutoFit
   ColumnCount
   ColumnHide
   ColumnOrder
   ColumnsBetterAutoFit
   ColumnShow
   CompareItems
   CountPerPage
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

METHOD Define3( aValue ) CLASS TXBrowseByCell

   LOCAL lLocked

   IF ! HB_IsArray( aValue ) .OR. ;
         Len( aValue ) < 2 .OR. ;
         ! HB_IsNumeric( aValue[ 1 ] ) .OR. ! HB_IsNumeric( aValue[ 2 ] ) .OR.  ;
         aValue[ 1 ] < 1 .OR. aValue[ 1 ] > ::CountPerPage .OR. ;
         aValue[ 2 ] < 1 .OR. aValue[ 2 ] > Len( ::aFields )
      aValue := {1, 1}
   ENDIF
   ASSIGN lLocked VALUE ::lLocked TYPE "L" DEFAULT .F.
   ::lLocked := .F.
   ::Refresh()
   ::Value := aValue
   ::lLocked := lLocked

   RETURN Self

METHOD Define2( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, aRows, ;
      value, fontname, fontsize, tooltip, aHeadClick, nogrid, ;
      aImage, aJust, break, HelpId, bold, italic, underline, ;
      strikeout, ownerdata, itemcount, editable, backcolor, ;
      fontcolor, dynamicbackcolor, dynamicforecolor, aPicture, lRtl, ;
      nStyle, InPlace, editcontrols, readonly, valid, validmessages, ;
      aWhenFields, lDisabled, lNoTabStop, lInvisible, lHasHeaders, ;
      aHeaderImage, aHeaderImageAlign, FullMove, aSelectedColors, ;
      aEditKeys, lCheckBoxes, lDblBffr, lFocusRect, lPLM, ;
      lFixedCols, lFixedWidths, lLikeExcel, lButtons, AllowDelete, ;
      DelMsg, lNoDelMsg, AllowAppend, lNoModal, lFixedCtrls, ;
      lClickOnCheckbox, lRClickOnCheckbox, lExtDbl, lSilent, lAltA, ;
      lNoShowAlways, lNone, lCBE, lAtFirst, klc ) CLASS TXBrowseByCell

   HB_SYMBOL_UNUSED( nStyle )
   HB_SYMBOL_UNUSED( lNone )
   HB_SYMBOL_UNUSED( lCBE )

   ASSIGN lFocusRect VALUE lFocusRect TYPE "L" DEFAULT .F.

   ::Super:Define2( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, aRows, ;
      value, fontname, fontsize, tooltip, aHeadClick, nogrid, ;
      aImage, aJust, break, HelpId, bold, italic, underline, ;
      strikeout, ownerdata, itemcount, editable, backcolor, ;
      fontcolor, dynamicbackcolor, dynamicforecolor, aPicture, lRtl, ;
      LVS_SINGLESEL, InPlace, editcontrols, readonly, valid, validmessages, ;
      aWhenFields, lDisabled, lNoTabStop, lInvisible, lHasHeaders, ;
      aHeaderImage, aHeaderImageAlign, FullMove, aSelectedColors, ;
      aEditKeys, lCheckBoxes, lDblBffr, lFocusRect, lPLM, ;
      lFixedCols, lFixedWidths, lLikeExcel, lButtons, AllowDelete, ;
      DelMsg, lNoDelMsg, AllowAppend, lNoModal, lFixedCtrls, ;
      lClickOnCheckbox, lRClickOnCheckbox, lExtDbl, lSilent, lAltA, ;
      lNoShowAlways, .F., .T., lAtFirst, klc )

   // By default, search in the current column
   ::SearchCol := -1

   RETURN Self

METHOD AddColumn( nColIndex, xField, cHeader, nWidth, nJustify, uForeColor, ;
      uBackColor, lNoDelete, uPicture, uEditControl, uHeadClick, ;
      uValid, uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign, ;
      uReplaceField, lRefresh, uReadOnly, uDefault ) CLASS TXBrowseByCell

   nColIndex := ::Super:AddColumn( nColIndex, xField, cHeader, nWidth, nJustify, uForeColor, ;
      uBackColor, lNoDelete, uPicture, uEditControl, uHeadClick, ;
      uValid, uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign, ;
      uReplaceField, lRefresh, uReadOnly, uDefault )

   IF nColIndex <= ::nColPos
      ::CurrentCol := ::nColPos + 1
      ::DoChange()
   ENDIF

   RETURN nColIndex

METHOD DeleteColumn( nColIndex, lNoDelete ) CLASS TXBrowseByCell

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

METHOD EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, nOnFocusPos, lChange, lAppend ) CLASS TXBrowseByCell

   LOCAL lRet, lBefore

   IF ! HB_IsNumeric( nCol )
      IF ::nColPos >= 1
         nCol := ::nColPos
      ELSE
         nCol := ::FirstColInOrder
      ENDIF
   ENDIF

   // ::Value change is done in ::Super:EditCell, after aditional validations
   HB_SYMBOL_UNUSED( lChange)

   lBefore := ::lCalledFromClass
   ::lCalledFromClass := .T.
   lRet := ::Super:EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, nOnFocusPos, .T., lAppend )
   ::lCalledFromClass := lBefore

   IF lRet
      // ::bPosition is set by TGridControl()
      IF ::bPosition == 1                                         // UP
         ::Up()
      ELSEIF ::bPosition == 2                                     // RIGHT
         ::Right( .F. )
      ELSEIF ::bPosition == 3                                     // LEFT
         ::Left()
      ELSEIF ::bPosition == 4                                     // HOME
         ::GoTop()
      ELSEIF ::bPosition == 5                                     // END
         ::GoBottom( .F. )
      ELSEIF ::bPosition == 6                                     // DOWN
         ::Down( .F. )
      ELSEIF ::bPosition == 7                                     // PRIOR
         ::PageUp()
      ELSEIF ::bPosition == 8                                     // NEXT
         ::PageDown( .F. )
      ELSEIF ! ::lCalledFromClass .AND. ::bPosition == 9          // MOUSE EXIT
         // Edition window lost focus
         ::bPosition := 0                   // This restores the processing of click messages
         IF ::nDelayedClick[ 1 ] > 0
            // A click message was delayed
            IF ::nDelayedClick[ 3 ] <= 0
               ::MoveTo( { ::nDelayedClick[ 1 ], ::nDelayedClick[ 2 ] }, { ::nRowPos, ::nColPos } )
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
   ENDIF

   RETURN lRet

METHOD EditGrid( nRow, nCol, lAppend, lOneRow, lChange ) CLASS TXBrowseByCell

   LOCAL lRet, lSomethingEdited

   HB_SYMBOL_UNUSED( lChange)

   IF ::lLocked

      RETURN .F.
   ENDIF
   IF ::FirstVisibleColumn == 0

      RETURN .F.
   ENDIF
   IF ! HB_IsNumeric( nCol )
      IF ::nColPos >= 1
         nCol := ::nColPos
      ELSE
         nCol := ::FirstColInOrder
      ENDIF
   ENDIF
   IF nCol < 1 .OR. nCol > Len( ::aHeaders )

      RETURN .F.
   ENDIF

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.

   IF lAppend
      IF ::lAppendMode

         RETURN .F.
      ENDIF
      ::lAppendMode := .T.
      ::GoBottom( .T. )
      ::InsertBlank( ::ItemCount + 1 )
      ::CurrentRow := ::ItemCount
      ::CurrentCol := nCol
      ::oWorkArea:GoTo( 0 )
   ELSE
      IF ! HB_IsNumeric( nRow )
         nRow := Max( ::CurrentRow, 1 )
      ENDIF
      IF nRow < 1 .OR. nRow > ::ItemCount

         RETURN .F.
      ENDIF
      // to work properly, nRow and the data source record must be synchronized
      ::SetControlValue( nRow, nCol )
   ENDIF

   lSomethingEdited := .F.

   DO WHILE ::nRowPos >= 1 .AND. ::nRowPos <= ::ItemCount .AND. ::nColPos >= 1 .AND. ::nColPos <= Len( ::aHeaders )
      _OOHG_ThisItemCellValue := ::Cell( ::nRowPos, ::nColPos )

      IF ::IsColumnReadOnly( ::nColPos, ::nRowPos )
         // Read only column
      ELSEIF ! ::IsColumnWhen( ::nColPos, ::nRowPos )
         // Not a valid WHEN
      ELSEIF aScan( ::aHiddenCols, ::nColPos ) > 0
         // Hidden column
      ELSE
         ::lCalledFromClass := .T.
         lRet := ::Super:EditCell( ::nRowPos, ::nColPos, , , , , , .F., ::lAppendMode )
         ::lCalledFromClass := .F.

         IF ::lAppendMode
            ::lAppendMode := .F.
            IF lRet
               lSomethingEdited := .T.
            ELSE
               ::GoBottom()
               EXIT
            ENDIF
         ELSEIF lRet
            lSomethingEdited := .T.
         ELSE
            EXIT
         ENDIF
      ENDIF

      // ::bPosition is set by TGridControl()
      IF ::bPosition == 1                            // UP
         IF HB_IsLogical( lOneRow ) .AND. lOneRow
            EXIT
         ELSEIF ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove
            EXIT
         ENDIF
         ::Up()
      ELSEIF ::bPosition == 2                        // RIGHT
         IF ::nColPos # ::LastColInOrder
            ::Right( .F. )
         ELSEIF HB_IsLogical( lOneRow ) .AND. lOneRow
            EXIT
         ELSEIF ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove
            EXIT
         ELSE
            ::Right( .F. )
            ::lAppendMode := ::Eof() .AND. ( lAppend .OR. ::AllowAppend )
         ENDIF
      ELSEIF ::bPosition == 3                        // LEFT
         IF ::nColPos # ::FirstColInOrder
            ::Left()
         ELSEIF HB_IsLogical( lOneRow ) .AND. lOneRow
            EXIT
         ELSEIF ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove
            EXIT
         ELSE
            ::Left()
         ENDIF
      ELSEIF ::bPosition == 4                        // HOME
         IF HB_IsLogical( lOneRow ) .AND. lOneRow
            EXIT
         ELSEIF ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove
            EXIT
         ENDIF
         ::GoTop()
      ELSEIF ::bPosition == 5                        // END
         IF HB_IsLogical( lOneRow ) .AND. lOneRow
            EXIT
         ELSEIF ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove
            EXIT
         ENDIF
         ::GoBottom( .F. )
      ELSEIF ::bPosition == 6                        // DOWN
         IF HB_IsLogical( lOneRow ) .AND. lOneRow
            EXIT
         ENDIF
         ::Down( .F. )
         IF ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove
            EXIT
         ENDIF
         ::lAppendMode := ::Eof() .AND. ( lAppend .OR. ::AllowAppend )
      ELSEIF ::bPosition == 7                        // PRIOR
         IF HB_IsLogical( lOneRow ) .AND. lOneRow
            EXIT
         ELSEIF ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove
            EXIT
         ENDIF
         ::PageUp()
      ELSEIF ::bPosition == 8                        // NEXT
         IF HB_IsLogical( lOneRow ) .AND. lOneRow
            EXIT
         ELSEIF ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove
            EXIT
         ENDIF
         ::PageDown( .F. )
         ::lAppendMode := ::Eof() .AND. ( lAppend .OR. ::AllowAppend )
      ELSEIF ::bPosition == 9                        // MOUSE EXIT
         // Edition window lost focus
         ::bPosition := 0                   // This restores the processing of click messages
         IF ::nDelayedClick[ 1 ] > 0
            // A click message was delayed
            IF ::nDelayedClick[ 3 ] <= 0
               ::MoveTo( { ::nDelayedClick[ 1 ], ::nDelayedClick[ 2 ] }, { ::nRowPos, ::nColPos } )
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
         EXIT
      ELSE                                           // OK
         IF ::nColPos # ::LastColInOrder
            ::Right( .F. )
         ELSEIF HB_IsLogical( lOneRow ) .AND. lOneRow
            EXIT
         ELSEIF ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove
            EXIT
         ELSE
            ::Right( .F. )
            ::lAppendMode := ::Eof() .AND. ( lAppend .OR. ::AllowAppend )
         ENDIF
      ENDIF

      IF ::lAppendMode
         // Insert new row
         ::GoBottom( .T. )
         ::InsertBlank( ::ItemCount + 1 )
         ::CurrentRow := ::ItemCount
         ::CurrentCol := ::FirstColInOrder
         ::oWorkArea:GoTo( 0 )
      ENDIF
   ENDDO

   RETURN lSomethingEdited

METHOD EditAllCells( nRow, nCol, lAppend, lOneRow, lChange ) CLASS TXBrowseByCell

   LOCAL lRet, lSomethingEdited

   HB_SYMBOL_UNUSED( lChange)

   IF ::FullMove

      RETURN ::EditGrid( nRow, nCol, lAppend, lOneRow, lChange )
   ENDIF
   IF ::lLocked

      RETURN .F.
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
      IF ::lAppendMode

         RETURN .F.
      ENDIF
      ::lAppendMode := .T.
      ::GoBottom( .T. )
      ::InsertBlank( ::ItemCount + 1 )
      ::CurrentRow := ::ItemCount
      ::CurrentCol := nCol
      ::oWorkArea:GoTo( 0 )
   ELSE
      IF ! HB_IsNumeric( nRow )
         nRow := Max( ::CurrentRow, 1 )
      ENDIF
      IF nRow < 1 .OR. nRow > ::ItemCount

         RETURN .F.
      ENDIF
      // to work properly, nRow and the data source record must be synchronized
      ::SetControlValue( nRow, nCol )
   ENDIF

   ASSIGN lOneRow VALUE lOneRow TYPE "L" DEFAULT .T.

   lSomethingEdited := .F.

   DO WHILE ::nRowPos >= 1 .AND. ::nRowPos <= ::ItemCount .AND. ::nColPos >= 1 .AND. ::nColPos <= Len( ::aHeaders )
      _OOHG_ThisItemCellValue := ::Cell( ::nRowPos, ::nColPos )

      IF ::IsColumnReadOnly( ::nColPos, ::nRowPos )
         // Read only column
      ELSEIF ! ::IsColumnWhen( ::nColPos, ::nRowPos )
         // Not a valid WHEN
      ELSEIF aScan( ::aHiddenCols, ::nColPos ) > 0
         // Hidden column
      ELSE
         ::lCalledFromClass := .T.
         lRet := ::Super:EditCell( ::nRowPos, ::nColPos, , , , , , .F., ::lAppendMode )
         ::lCalledFromClass := .F.

         IF ::lAppendMode
            ::lAppendMode := .F.
            IF lRet
               lSomethingEdited := .T.
            ELSE
               ::GoBottom()
               EXIT
            ENDIF
         ELSEIF lRet
            lSomethingEdited := .T.
         ELSE
            EXIT
         ENDIF
      ENDIF

      // ::bPosition is set by TGridControl()
      IF ::bPosition == 1                            // UP
         IF lOneRow
            EXIT
         ENDIF
         ::Up()
      ELSEIF ::bPosition == 2                        // RIGHT
         IF ::nColPos # ::LastColInOrder
            ::Right( .F. )
         ELSEIF lOneRow
            EXIT
         ELSE
            ::Right( .F. )
            ::lAppendMode := ::Eof() .AND. ( lAppend .OR. ::AllowAppend )
         ENDIF
      ELSEIF ::bPosition == 3                        // LEFT
         IF ::nColPos # ::FirstColInOrder
            ::Left()
         ELSEIF lOneRow
            EXIT
         ELSE
            ::Left()
         ENDIF
      ELSEIF ::bPosition == 4                        // HOME
         IF lOneRow
            EXIT
         ENDIF
         ::GoTop()
      ELSEIF ::bPosition == 5                        // END
         IF lOneRow
            EXIT
         ENDIF
         ::GoBottom( .F. )
      ELSEIF ::bPosition == 6                        // DOWN
         IF lOneRow
            EXIT
         ENDIF
         ::Down( .F. )
         ::lAppendMode := ::Eof() .AND. ( lAppend .OR. ::AllowAppend )
      ELSEIF ::bPosition == 7                        // PRIOR
         IF lOneRow
            EXIT
         ENDIF
         ::PageUp()
      ELSEIF ::bPosition == 8                        // NEXT
         IF lOneRow
            EXIT
         ENDIF
         ::PageDown( .F. )
         ::lAppendMode := ::Eof() .AND. ( lAppend .OR. ::AllowAppend )
      ELSEIF ::bPosition == 9                        // MOUSE EXIT
         // Edition window lost focus
         ::bPosition := 0                   // This restores the processing of click messages
         IF ::nDelayedClick[ 1 ] > 0
            // A click message was delayed
            IF ::nDelayedClick[ 3 ] <= 0
               ::MoveTo( { ::nDelayedClick[ 1 ], ::nDelayedClick[ 2 ] }, { ::nRowPos, ::nColPos } )
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
         EXIT
      ELSE                                           // OK
         IF ::nColPos # ::LastColInOrder
            ::Right( .F. )
         ELSEIF lOneRow
            EXIT
         ELSE
            ::Right( .F. )
            ::lAppendMode := ::Eof() .AND. ( lAppend .OR. ::AllowAppend )
         ENDIF
      ENDIF

      IF ::lAppendMode
         // Insert new row
         ::GoBottom( .T. )
         ::InsertBlank( ::ItemCount + 1 )
         ::CurrentRow := ::ItemCount
         ::CurrentCol := ::FirstColInOrder
         ::oWorkArea:GoTo( 0 )
         ::ScrollToLeft()
      ENDIF
   ENDDO

   RETURN lSomethingEdited

METHOD MoveToFirstCol CLASS TXBrowseByCell

   LOCAL aBefore, nCol, aAfter, lDone := .F.

   aBefore := ::Value
   nCol := ::FirstColInOrder
   IF nCol # 0
      ::Value := { aBefore[ 1 ], nCol }
      aAfter := ::Value
      lDone := ( aAfter[ 1 ] # aBefore[ 1 ] .OR. aAfter[ 2 ] # aBefore[ 2 ] )
      IF lDone
         ::DoChange()
      ENDIF
   ENDIF

   RETURN lDone

METHOD MoveToLastCol CLASS TXBrowseByCell

   LOCAL aBefore, nCol, aAfter, lDone := .F.

   aBefore := ::Value
   nCol := ::LastColInOrder
   IF nCol # 0
      ::Value := { aBefore[ 1 ], nCol }
      aAfter := ::Value
      lDone := ( aAfter[ 1 ] # aBefore[ 1 ] .OR. aAfter[ 2 ] # aBefore[ 2 ] )
      IF lDone
         ::DoChange()
      ENDIF
   ENDIF

   RETURN lDone

METHOD MoveToFirstVisibleCol CLASS TXBrowseByCell

   LOCAL aBefore, nCol, aAfter, lDone := .F.

   aBefore := ::Value
   ::ScrollToPrior()
   nCol := ::FirstVisibleColumn
   IF nCol # 0
      ::Value := { aBefore[ 1 ], nCol }
      aAfter := ::Value
      lDone := ( aAfter[ 1 ] # aBefore[ 1 ] .OR. aAfter[ 2 ] # aBefore[ 2 ] )
      IF lDone
         ::DoChange()
      ENDIF
   ENDIF

   RETURN lDone

METHOD MoveToLastVisibleCol CLASS TXBrowseByCell

   LOCAL aBefore, nCol, aAfter, lDone := .F.

   aBefore := ::Value
   ::ScrollToPrior()
   nCol := ::LastVisibleColumn
   IF nCol # 0
      ::Value := { aBefore[ 1 ], nCol }
      aAfter := ::Value
      lDone := ( aAfter[ 1 ] # aBefore[ 1 ] .OR. aAfter[ 2 ] # aBefore[ 2 ] )
      IF lDone
         ::DoChange()
      ENDIF
   ENDIF

   RETURN lDone

METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TXBrowseByCell

   LOCAL aCellData, cWorkArea, uGridValue, nSearchCol, nRow, nCol, aPos

   IF nMsg == WM_CHAR
      _OOHG_ThisItemCellValue := ::Cell( nRow := ::CurrentRow, ( nCol := ::CurrentCol ) )

      IF ( ! ::lLocked .AND. ::AllowEdit .AND. ( ::lLikeExcel .OR. EditControlLikeExcel( Self, nCol ) ) .AND. ;
            ! ::IsColumnReadOnly( nCol, nRow ) .AND. ::IsColumnWhen( nCol, nRow ) .AND. aScan( ::aHiddenCols, nCol ) == 0 )
         ::EditCell( , , , Chr( wParam ), , , , , .F. )

      ELSE
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

         IF ::SearchCol <= 0
            // Current column
            nSearchCol := nCol
            IF nSearchCol < 1 .OR. nSearchCol > ::ColumnCount .OR. aScan( ::aHiddenCols, nSearchCol ) # 0

               RETURN 0
            ENDIF
         ELSEIF ::SearchCol > ::ColumnCount

            RETURN 0
         ELSEIF aScan( ::aHiddenCols, ::SearchCol ) # 0

            RETURN 0
         ELSE
            nSearchCol := ::SearchCol
         ENDIF

         cWorkArea := ::WorkArea
         IF ValType( cWorkArea ) $ "CM" .AND. ( Empty( cWorkArea ) .OR. Select( cWorkArea ) == 0 )
            cWorkArea := Nil
         ENDIF

         ::DbSkip()

         DO WHILE ! ::Eof()
            IF ::FixBlocks()
               uGridValue := Eval( ::aColumnBlocks[ nSearchCol ], cWorkArea )
            ELSE
               uGridValue := Eval( ::ColumnBlock( nSearchCol ), cWorkArea )
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

            DO WHILE ! ::Eof()
               IF ::FixBlocks()
                  uGridValue := Eval( ::aColumnBlocks[ nSearchCol ], cWorkArea )
               ELSE
                  uGridValue := Eval( ::ColumnBlock( nSearchCol ), cWorkArea )
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
            ::TopBottom( GO_BOTTOM )
            ::Refresh( { ::CountPerPage, nCol } )
         ELSE
            ::Refresh( { ::CountPerPage, nCol } )
         ENDIF
         ::DoChange()

      ENDIF

      RETURN 0

   ELSEIF nMsg == WM_KEYDOWN
      DO CASE
      CASE ::FirstVisibleColumn == 0
         // Do nothing
      CASE wParam == VK_DOWN
         IF GetKeyFlagState() == MOD_CONTROL
            IF ! ::lKeysLikeClipper
               ::GoBottom( .F., ::nColPos )
            ENDIF
         ELSE
            ::Down()
         ENDIF

         RETURN 0
      CASE wParam == VK_UP
         IF GetKeyFlagState() == MOD_CONTROL
            IF ! ::lKeysLikeClipper
               ::GoTop( ::nColPos )
            ENDIF
         ELSE
            ::Up()
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
         ::EditCell( _OOHG_ThisItemRowIndex, _OOHG_ThisItemColIndex, , , , , , , .F. )

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

METHOD MoveTo( nTo, nFrom ) CLASS TXBrowseByCell

   LOCAL lMoved

   IF ! ::lLocked .AND. ! ( ::lNoShowEmptyRow .AND. ::oWorkArea:IsTableEmpty() )
      IF ! HB_IsArray( nTo ) .OR. Len( nTo ) < 2 .OR. ! HB_IsNumeric( nTo[ 1 ] ) .OR. ! HB_IsNumeric( nTo[ 2 ] )
         nTo := { ::nRowPos, ::nColPos }
      ENDIF
      IF ! HB_IsArray( nFrom ) .OR. Len( nFrom ) < 2 .OR. ! HB_IsNumeric( nFrom[ 1 ] ) .OR. ! HB_IsNumeric( nFrom[ 2 ] )
         nFrom := { ::nRowPos, ::nColPos }
      ENDIF
      nFrom[ 1 ] := Max( Min( nFrom[ 1 ], ::ItemCount ), 1 )
      nTo[ 1 ]   := Max( Min( nTo[ 1 ],   ::CountPerPage ), 1 )
      nFrom[ 2 ] := Max( Min( nFrom[ 2 ], Len( ::aHeaders ) ), 1 )
      nTo[ 2 ]   := Max( Min( nTo[ 2 ],   Len( ::aHeaders ) ), 1 )
      lMoved     := ( nTo[ 1 ] # nFrom[ 1 ] .OR. nTo[ 2 ] # nFrom[ 2 ] )
      ::RefreshRow( nFrom[ 1 ] )
      DO WHILE nFrom[ 1 ] != nTo[ 1 ]
         IF nFrom[ 1 ] > nTo[ 1 ]
            IF ::DbSkip( -1 ) != 0
               nFrom[ 1 ] --
               ::RefreshRow( nFrom[ 1 ] )
            ELSE
               EXIT
            ENDIF
         ELSE
            IF ::DbSkip( 1 ) != 0
               nFrom[ 1 ] ++
               ::RefreshRow( nFrom[ 1 ] )
            ELSE
               EXIT
            ENDIF
         ENDIF
      ENDDO
      ::CurrentRow := nTo[ 1 ]
      ::CurrentCol := nTo[ 2 ]
      IF lMoved
         ::DoChange()
      ENDIF
   ENDIF

   RETURN Self

METHOD Events_Notify( wParam, lParam ) CLASS TXBrowseByCell

   LOCAL nNotify := GetNotifyCode( lParam ), aCellData, nvKey, lGo, uValue

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
         IF ::nRowPos > 0
            ListView_SetCursel( ::hWnd, ::nRowPos )
         ELSE
            ListView_ClearCursel( ::hWnd )
         ENDIF
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
            IF ! ::lLocked .AND. ::FirstVisibleColumn # 0
               aCellData := _GetGridCellData( Self, ListView_ItemActivate( lParam ) )
               ::MoveTo( { aCellData[ 1 ], aCellData[ 2 ] }, { ::nRowPos, ::nColPos } )
            ELSE
               ::CurrentRow := ::nRowPos
               ::CurrentCol := ::nColPos
            ENDIF
         ENDIF
      ENDIF

      // Skip default action

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
         IF ::nRowPos > 0
            ListView_SetCursel( ::hWnd, ::nRowPos )
         ELSE
            ListView_ClearCursel( ::hWnd )
         ENDIF
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
            IF ! ::lLocked .AND. ::FirstVisibleColumn # 0
               aCellData := _GetGridCellData( Self, ListView_ItemActivate( lParam ) )
               ::MoveTo( { aCellData[ 1 ], aCellData[ 2 ] }, { ::nRowPos, ::nColPos } )
            ELSE
               ::CurrentRow := ::nRowPos
               ::CurrentCol := ::nColPos
            ENDIF
         ENDIF

         // Fire context menu
         IF ::ContextMenu != Nil .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. uValue <= 0 )
            ::ContextMenu:Cargo := _GetGridCellData( Self, ListView_ItemActivate( lParam ) )
            ::ContextMenu:Activate()
         ENDIF
      ENDIF

      // Skip default action

      RETURN 1

   ELSEIF nNotify == LVN_BEGINDRAG
      IF ::bPosition == -2 .OR. ::bPosition == 9
         aCellData := _GetGridCellData( Self, ListView_ListView( lParam ) )
         ::nDelayedClick := { aCellData[ 1 ], aCellData[ 2 ], uValue, Nil }
         IF ::nRowPos > 0
            ListView_SetCursel( ::hWnd, ::nRowPos )
         ELSE
            ListView_ClearCursel( ::hWnd )
         ENDIF
      ELSE
         IF ! ::lLocked .AND. ::FirstVisibleColumn # 0
            aCellData := _GetGridCellData( Self, ListView_ListView( lParam ) )
            ::MoveTo( { aCellData[ 1 ], aCellData[ 2 ] }, { ::nRowPos, ::nColPos } )
         ELSE
            ::CurrentRow := ::nRowPos
            ::CurrentCol := ::nColPos
         ENDIF
      ENDIF

      RETURN NIL

   ELSEIF nNotify == LVN_KEYDOWN
      IF ::FirstVisibleColumn # 0
         IF GetGridvKeyAsChar( lParam ) == 0
            ::cText := ""
         ENDIF

         nvKey := GetGridvKey( lParam )
         DO CASE
         CASE GetKeyFlagState() == MOD_ALT .AND. nvKey == VK_A
            IF ::lAppendOnAltA
               ::AppendItem()
            ENDIF

         CASE nvKey == VK_DELETE
            IF ::AllowDelete .and. ! ::Eof() .AND. ! ::lLocked
               IF ValType(::bDelWhen) == "B"
                  lGo := _OOHG_Eval( ::bDelWhen )
               ELSE
                  lGo := .t.
               ENDIF

               IF lGo
                  IF ::lNoDelMsg .OR. MsgYesNo( _OOHG_Messages(4, 1), _OOHG_Messages(4, 2) )
                     ::Delete()
                  ENDIF
               ELSEIF ! Empty( ::DelMsg )
                  MsgExclamation( ::DelMsg, _OOHG_Messages(4, 2) )
               ENDIF
            ENDIF

         ENDCASE
      ENDIF

      RETURN NIL

   ELSEIF nNotify == LVN_ITEMCHANGED
      IF GetGridOldState( lParam ) == 0 .and. GetGridNewState( lParam ) != 0

         RETURN NIL
      ENDIF

   ELSEIF nNotify == NM_CUSTOMDRAW
      ::AdjustRightScroll()

      RETURN TGrid_Notify_CustomDraw( Self, lParam, .T., ::nRowPos, ::nColPos, .F., ::lFocusRect, ::lNoGrid, ::lPLM )

   ENDIF

   RETURN ::TGrid:Events_Notify( wParam, lParam )

METHOD GoBottom( lAppend, nCol ) CLASS TXBrowseByCell

   LOCAL lRet := .F.

   IF ! ::lLocked
      IF ! HB_IsNumeric( nCol )
         IF ::lKeysLikeClipper
            nCol := ::nColPos
         ELSE
            nCol := ::LastColInOrder
         ENDIF
      ENDIF
      IF nCol # 0
         ::TopBottom( GO_BOTTOM )
         // If it's for APPEND, leaves a blank line ;)
         ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
         ::Refresh( { ::CountPerPage - IIf( lAppend, 1, 0 ), IIf( lAppend, ::FirstColInOrder, nCol ) } )
         ::DoChange()
         lRet := .T.
      ENDIF
   ENDIF

   RETURN lRet

METHOD End( lAppend ) CLASS TXBrowseByCell

   LOCAL lDone

   IF ::lKeysLikeClipper
      lDone := ::MoveToLastVisibleCol()
   ELSE
      lDone := ::GoBottom( lAppend, ::LastColInOrder )
   ENDIF

   RETURN lDone

METHOD GoTop( nCol ) CLASS TXBrowseByCell

   LOCAL lRet := .F.

   IF ! ::lLocked
      IF ! HB_IsNumeric( nCol )
         IF ::lKeysLikeClipper
            nCol := ::nColPos
         ELSE
            nCol := ::FirstColInOrder
         ENDIF
      ENDIF
      IF nCol # 0
         ::TopBottom( GO_TOP )
         ::Refresh( { 1, nCol } )
         ::DoChange()
         lRet := .T.
      ENDIF
   ENDIF

   RETURN lRet

METHOD Home() CLASS TXBrowseByCell

   LOCAL lDone

   IF ::lKeysLikeClipper
      lDone := ::MoveToFirstVisibleCol()
   ELSE
      lDone := ::GoTop( ::FirstColInOrder )
   ENDIF

   RETURN lDone

METHOD Left() CLASS TXBrowseByCell

   LOCAL nRow, nCol, lRet := .F.

   IF ! ::lLocked .AND. ::nRowPos >= 1 .AND. ::nRowPos <= ::ItemCount .AND. ::nColPos >= 1 .AND. ::nColPos <= Len( ::aHeaders )
      nCol := ::PriorColInOrder( ::nColPos )
      IF nCol # 0
         ::CurrentCol := nCol
         ::DoChange()
         lRet := .T.
      ELSEIF ::FullMove
         nCol := ::LastColInOrder
         IF nCol # 0
            // Up
            IF ::DbSkip( -1 ) == -1
               nRow := ::nRowPos
               IF nRow <= 1
                  IF ::ItemCount >= ::CountPerPage
                     ::DeleteItem( ::ItemCount )
                  ENDIF
                  ::InsertBlank( 1 )
               ELSE
                  nRow --
               ENDIF
               IF ::lUpdCols
                  ::Refresh( { nRow, nCol } )
               ELSE
                  ::RefreshRow( nRow )
                  ::CurrentRow := nRow
                  ::CurrentCol := nCol
               ENDIF
               ::DoChange()
               lRet := .T.
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   RETURN lRet

METHOD Refresh( aCurrent, lNoEmptyBottom ) CLASS TXBrowseByCell

   LOCAL nRow, nCol

   IF HB_IsArray( aCurrent )
      IF Len( aCurrent ) > 0
         nRow := aCurrent[ 1 ]
      ENDIF
      IF Len( aCurrent ) > 1
         nCol := aCurrent[ 2 ]
      ENDIF
   ENDIF
   IF ! HB_IsNumeric( nCol ) .OR. nCol < 1 .OR. nCol > Len( ::aHeaders )
      nCol := ::nColPos
   ENDIF
   ::Super:Refresh( nRow, lNoEmptyBottom )
   ::CurrentRow := ::nRowPos
   ::CurrentCol := nCol

   RETURN Self

METHOD Right( lAppend ) CLASS TXBrowseByCell

   LOCAL nRow, nCol, lRet := .F.

   IF ! ::lLocked .AND. ::nRowPos >= 1 .AND. ::nRowPos <= ::ItemCount .AND. ::nColPos >= 1 .AND. ::nColPos <= Len( ::aHeaders )
      nCol := ::NextColInOrder( ::nColPos )
      IF nCol # 0
         ::CurrentCol := nCol
         ::DoChange()
         lRet := .T.
      ELSEIF ::FullMove
         nCol := ::FirstColInOrder
         IF nCol # 0
            // Down
            IF ::DbSkip( 1 ) == 1
               nRow := ::nRowPos
               IF nRow >= ::CountPerPage
                  ::DeleteItem( 1 )
               ELSE
                  nRow ++
               ENDIF
               IF ::lUpdCols
                  ::Refresh( { nRow, nCol } )
               ELSE
                  ::RefreshRow( nRow )
                  ::CurrentRow := nRow
                  ::CurrentCol := nCol
               ENDIF
               ::DoChange()
               lRet := .T.
            ELSE
               ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT ::AllowAppend
               IF lAppend
                  lRet := ::AppendItem()
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   RETURN lRet

METHOD Up() CLASS TXBrowseByCell

   LOCAL nValue, lRet := .F.

   IF ! ::lLocked .AND. ::DbSkip( -1 ) == -1
      nValue := ::nRowPos
      IF nValue <= 1
         IF ::ItemCount >= ::CountPerPage
            ::DeleteItem( ::ItemCount )
         ENDIF
         ::InsertBlank( 1 )
      ELSE
         nValue --
      ENDIF
      IF ::lUpdCols
         ::Refresh( { nValue, ::nColPos } )
      ELSE
         ::RefreshRow( nValue )
         ::CurrentRow := nValue
         ::CurrentCol := ::nColPos
      ENDIF
      ::DoChange()
      lRet := .T.
   ENDIF

   RETURN lRet

METHOD Down( lAppend ) CLASS TXBrowseByCell

   LOCAL nValue, lRet := .F.

   IF ! ::lLocked .AND. ::DbSkip( 1 ) == 1
      nValue := ::nRowPos
      IF nValue >= ::CountPerPage
         ::DeleteItem( 1 )
      ELSE
         nValue ++
      ENDIF
      IF ::lUpdCols
         ::Refresh( { nValue, ::nColPos } )
      ELSE
         ::RefreshRow( nValue )
         ::CurrentRow := nValue
         ::CurrentCol := ::nColPos
      ENDIF
      ::DoChange()
      lRet := .T.
   ELSE
      ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT ::AllowAppend
      IF lAppend
         lRet := ::AppendItem()
      ENDIF
   ENDIF

   RETURN lRet

METHOD SetSelectedColors( aSelectedColors, lRedraw ) CLASS TXBrowseByCell

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

METHOD SetControlValue( uValue ) CLASS TXBrowseByCell

   LOCAL nRow := 0, nCol := 0

   IF ! ::lLocked .AND. ::FirstVisibleColumn # 0
      IF HB_IsArray( uValue )
         IF Len( uValue ) == 1
            IF HB_IsNumeric( uValue[ 1 ] ) .AND. uValue[ 1 ] >= 1 .AND. uValue[ 1 ] <= ::ItemCount
               nRow := uValue[ 1 ]
               nCol := 1
            ENDIF
         ELSEIF Len( uValue ) >= 2
            IF ( HB_IsNumeric( uValue[ 1 ] ) .AND. HB_IsNumeric( uValue[ 2 ] ) .AND. ;
                  uValue[ 1 ] >= 1 .AND. uValue[ 1 ] <= ::ItemCount .AND. ;
                  uValue[ 2 ] >= 1 .AND. uValue[ 2 ] <= Len( ::aHeaders ) )
               nRow := uValue[ 1 ]
               nCol := uValue[ 2 ]
            ENDIF
         ENDIF
      ELSEIF HB_IsNumeric( uValue ) .AND. uValue >= 1 .AND. uValue <= ::ItemCount
         nRow := uValue
         nCol := 1
      ENDIF
   ENDIF

   IF nRow # 0 .AND. nCol # 0
      ::MoveTo( { nRow, nCol }, { ::nRowPos, ::nColPos } )
   ELSE
      ::CurrentRow := ::nRowPos
      ::CurrentCol := ::nColPos
   ENDIF

   RETURN { ::nRowPos, ::nColPos }

METHOD Value( uValue ) CLASS TXBrowseByCell

   IF ( ::FirstVisibleColumn # 0 .AND. ;
         HB_IsArray( uValue ) .AND. Len( uValue ) > 1 .AND. ;
         HB_IsNumeric( uValue[ 1 ] ) .AND. uValue[ 1 ] >= 1 .AND. uValue[ 1 ] <= ::ItemCount .AND. ;
         HB_IsNumeric( uValue[ 2 ] ) .AND. uValue[ 2 ] >= 1 .AND. uValue[ 2 ] <= Len( ::aHeaders ) )
      ::Super:Value( uValue[ 1 ] )
      ::CurrentCol := uValue[ 2 ]
   ENDIF

   RETURN { ::nRowPos, ::nColPos }

METHOD CurrentCol( nValue ) CLASS TXBrowseByCell

   LOCAL r, nClientWidth, nScrollWidth, lColChanged

   IF HB_IsNumeric( nValue ) .AND. nValue >= 1 .AND. nValue <= Len( ::aHeaders )
      lColChanged := ( ::nColPos # nValue )
      ::nColPos := nValue

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

   RETURN ::nColPos

#pragma BEGINDUMP

#ifndef HB_OS_WIN_32_USED
   #define HB_OS_WIN_32_USED
#endif

#ifndef WINVER
   #define WINVER 0x0500
#endif
#if ( WINVER < 0x0500 )
   #undef WINVER
   #define WINVER 0x0500
#endif

#ifndef _WIN32_IE
   #define _WIN32_IE 0x0400
#endif
#if ( _WIN32_IE < 0x0400 )
   #undef _WIN32_IE
   #define _WIN32_IE 0x0400
#endif

#ifndef _WIN32_WINNT
   #define _WIN32_WINNT 0x0500
#endif
#if ( _WIN32_WINNT < 0x0500 )
   #undef _WIN32_WINNT
   #define _WIN32_WINNT 0x0500
#endif

#include "hbapi.h"
#include "hbapiitm.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windows.h>
#include <commctrl.h>
#include "oohg.h"

#define s_Super s_TControl

HB_FUNC_STATIC( TXBROWSE_ADJUSTRIGHTSCROLL )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   LONG lStyle;
   BOOL bChanged = 0;
   PHB_ITEM pVScroll, pRet;

   lStyle = GetWindowLong( oSelf->hWnd, GWL_STYLE );
   if( lStyle & WS_VSCROLL )
   {
      lStyle = ( lStyle & WS_HSCROLL ) ? 1 : 0;
      if( lStyle != oSelf->lAux[ 0 ] )
      {
         oSelf->lAux[ 0 ] = lStyle;

         _OOHG_Send( pSelf, s_VScroll );
         hb_vmSend( 0 );
         pRet = hb_param( -1, HB_IT_OBJECT );
         if( pRet )
         {
            int iHeight;

            pVScroll = hb_itemNew( NULL );
            hb_itemCopy( pVScroll, pRet );

            _OOHG_Send( pSelf, s_Height );
            hb_vmSend( 0 );
            iHeight = hb_parni( -1 );

            if( lStyle )
            {
               _OOHG_Send( pVScroll, s_Height );
               hb_vmPushInteger( iHeight - GetSystemMetrics( SM_CYHSCROLL ) );
               hb_vmSend( 1 );
            }
            else
            {
               _OOHG_Send( pVScroll, s_Height );
               hb_vmPushInteger( iHeight );
               hb_vmSend( 1 );
            }

            _OOHG_Send( pSelf, s_ScrollButton );
            hb_vmSend( 0 );
            _OOHG_Send( hb_param( -1, HB_IT_OBJECT ), s_Visible );
            hb_vmPushLogical( lStyle );
            hb_vmSend( 1 );

            hb_itemRelease( pVScroll );
         }

         bChanged = 1;
      }
   }

   if( bChanged )
   {
      _OOHG_Send( pSelf, s_Refresh );
      hb_vmSend( 0 );
   }
   hb_retl( bChanged );
}

#pragma ENDDUMP
