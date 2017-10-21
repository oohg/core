/*
 * $Id: h_xbrowse.prg,v 1.160 2017-10-01 15:52:27 fyurisich Exp $
 */
/*
 * ooHG source code:
 * XBrowse and XBrowseByCell controls
 * ooHGRecord and TVirtualField classes
 *
 * Copyright 2006-2017 Vicente Guerra <vicente@guerra.com.mx>
 * https://sourceforge.net/projects/oohg/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2017, https://harbour.github.io/
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
 * along with this software; see the file COPYING.  If not, write to
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
#include "i_windefs.ch"

#define GO_TOP    -1
#define GO_BOTTOM  1

// TODO: Thread safe ?
STATIC _OOHG_XBrowseFixedBlocks := .T.
STATIC _OOHG_XBrowseFixedControls := .F.

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

   /* HB_SYMBOL_UNUSED( _OOHG_AllVars ) */

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
               rowrefresh, aDefaultValues, editend, lAtFirst, bbeforeditcell ) CLASS TXBrowse

   Local nWidth2, nCol2, oScroll, z

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

   If HB_IsArray( aDefaultValues )
      ::aDefaultValues := aDefaultValues
      ASize( ::aDefaultValues, Len( ::aHeaders ) )
   Else
      ::aDefaultValues := Array( Len( ::aHeaders ) )
       AFill( ::aDefaultValues, aDefaultValues )
   EndIf

   If ValType( columninfo ) == "A" .AND. LEN( columninfo ) > 0
      If ValType( ::aFields ) == "A"
         aSize( ::aFields,  LEN( columninfo ) )
      Else
         ::aFields := ARRAY( LEN( columninfo ) )
      EndIf
      aSize( ::aHeaders, LEN( columninfo ) )
      aSize( ::aWidths,  LEN( columninfo ) )
      aSize( ::aJust,    LEN( columninfo ) )
      FOR z := 1 TO LEN( columninfo )
         If ValType( columninfo[ z ] ) == "A"
            If LEN( columninfo[ z ] ) >= 1 .AND. ValType( columninfo[ z ][ 1 ] ) $ "CMB"
               ::aFields[ z ]  := columninfo[ z ][ 1 ]
            EndIf
            If LEN( columninfo[ z ] ) >= 2 .AND. ValType( columninfo[ z ][ 2 ] ) $ "CM"
               ::aHeaders[ z ] := columninfo[ z ][ 2 ]
            EndIf
            If LEN( columninfo[ z ] ) >= 3 .AND. ValType( columninfo[ z ][ 3 ] ) $ "N"
               ::aWidths[ z ]  := columninfo[ z ][ 3 ]
            EndIf
            If LEN( columninfo[ z ] ) >= 4 .AND. ValType( columninfo[ z ][ 4 ] ) $ "N"
               ::aJust[ z ]    := columninfo[ z ][ 4 ]
            EndIf
         EndIf
      NEXT
   EndIf

   ASSIGN ::WorkArea VALUE WorkArea TYPE "CMO" DEFAULT ALIAS()
   If ValType( ::aFields ) != "A"
      ::aFields := ::oWorkArea:DbStruct()
      aEval( ::aFields, { |x,i| ::aFields[ i ] := ::oWorkArea:cAlias__ + "->" + x[ 1 ] } )
   EndIf

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
              lNoShowAlways, .F., .T., lAtFirst )

   ::FixBlocks( lFixedBlocks )

   ::nWidth := w

   ASSIGN ::Lock          VALUE lock          TYPE "L"
   ASSIGN ::aReplaceField VALUE replacefields TYPE "A"
   ASSIGN ::lRecCount     VALUE lRecCount     TYPE "L"

   If ::lRtl .AND. ! ::Parent:lRtl
      ::nCol := ::nCol + GETVSCROLLBARWIDTH()
      nCol2 := -GETVSCROLLBARWIDTH()
   Else
      nCol2 := nWidth2
   EndIf

   ::ScrollButton := TScrollButton():Define( , Self, nCol2, ::nHeight - GETHSCROLLBARHEIGHT(), GETVSCROLLBARWIDTH() , GETHSCROLLBARHEIGHT() )

   oScroll := TScrollBar()
   oScroll:nWidth := GETVSCROLLBARWIDTH()
   oScroll:SetRange( 1, 100 )
   oScroll:nCol := nCol2

   If IsWindowStyle( ::hWnd, WS_HSCROLL )
      oScroll:nRow := 0
      oScroll:nHeight := ::nHeight - GETHSCROLLBARHEIGHT()
   Else
      oScroll:nRow := 0
      oScroll:nHeight := ::nHeight
      ::ScrollButton:Visible := .F.
   EndIf

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
   If novscroll
      ::VScrollVisible( .F. )
   EndIf

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
              bbeforeditcell )

   Return Self

METHOD Define3( nValue ) CLASS TXBrowse

   Local lLocked

   ASSIGN nValue VALUE nValue TYPE "N" DEFAULT 1
   ASSIGN lLocked VALUE ::lLocked TYPE "L" DEFAULT .F.
   ::lLocked := .F.
   ::Refresh()
   ::Value := nValue
   ::lLocked := lLocked

   Return Self

METHOD Define4( change, dblclick, gotfocus, lostfocus, editcell, onenter, ;
                oncheck, abortedit, click, bbeforecolmove, baftercolmove, ;
                bbeforecolsize, baftercolsize, bbeforeautofit, ondelete, ;
                bDelWhen, onappend, bheadrclick, onrclick, editend, rowrefresh, ;
                bbeforeditcell ) CLASS TXBrowse

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

   Return Self

METHOD ToolTip( cToolTip ) CLASS TXBrowse

   Local uToolTip

   If PCount() > 0
      uToolTip := ::Super:ToolTip( cToolTip )
      If HB_IsObject( ::VScroll )
         ::VScroll:ToolTip := uToolTip
      EndIf
      If HB_IsObject( ::VScrollCopy )
         ::VScrollCopy:ToolTip := uToolTip
      EndIf
   EndIf

   Return ::Super:ToolTip()

METHOD HelpId( nHelpId ) CLASS TXBrowse


   If HB_IsNumeric( nHelpId )
      ::nHelpId := nHelpId
      If HB_IsObject( ::VScroll )
         ::VScroll:HelpId := nHelpId
      EndIf
      If HB_IsObject( ::VScrollCopy )
         ::VScrollCopy:HelpId := nHelpId
      EndIf
   EndIf

   Return ::nHelpId

METHOD FixBlocks( lFix ) CLASS TXBrowse

   If HB_IsLogical( lFix )
      If lFix
         ::aColumnBlocks := ARRAY( Len( ::aFields ) )
         aEval( ::aFields, { |c,i| ::aColumnBlocks[ i ] := ::ColumnBlock( i ), c } )
         ::lFixedBlocks := .T.
      Else
         ::lFixedBlocks := .F.
         ::aColumnBlocks := Nil
      EndIf
   EndIf

   Return ::lFixedBlocks

METHOD FixControls( lFix ) CLASS TXBrowse

   Local i, oEditControl

   If HB_IsLogical( lFix )
      If lFix
         ::lFixedControls := .F.                           // Necessary for ::GetCellType to work properly
         ::aEditControls := Array( Len( ::aHeaders ) )
         For i := 1 To Len( ::aHeaders )
            oEditControl := Nil
            ::GetCellType( i, @oEditControl, , , , .F. )
            ::aEditControls[ i ] := oEditControl
         Next i
         ::lFixedControls := .T.
      Else
         ::lFixedControls := .F.
      Endif
   EndIf

   Return ::lFixedControls

METHOD Refresh( nCurrent, lNoEmptyBottom ) CLASS TXBrowse

   Local nRow, nCount, nSkipped

   If Empty( ::WorkArea ) .OR. ( ValType( ::WorkArea ) $ "CM" .AND. Select( ::WorkArea ) == 0 )
      // No workarea specified...
   ElseIf ! ::lLocked
      If ::Visible
         ::SetRedraw( .F. )
      EndIf

      nCount := ::CountPerPage
      ASSIGN nCurrent       VALUE nCurrent       TYPE "N" DEFAULT ::CurrentRow
      ASSIGN lNoEmptyBottom VALUE lNoEmptyBottom TYPE "L" DEFAULT .F.
      nCurrent := MAX( MIN( nCurrent, nCount ), 1 )
      // Top of screen
      nCurrent := ( - ::DbSkip( - ( nCurrent - 1 ) ) ) + 1

      If ::lNoShowEmptyRow .AND. ::oWorkArea:IsTableEmpty()
         nCurrent := nRow := 0
         ::TopBottom( GO_BOTTOM )
      Else
         // Draw rows
         nRow := 1
         Do While .T.
            ::RefreshRow( nRow )
            If nRow < nCount
               If ::DbSkip( 1 ) == 1
                  nRow ++
               Else
                  If lNoEmptyBottom
                     nSkipped := ( - ::DbSkip( - ( nCount - 1 ) ) ) + 1
                     nCurrent := nCurrent + ( nSkipped - nRow )
                     nRow := 1
                     lNoEmptyBottom := .F.
                  Else
                     ::TopBottom( GO_BOTTOM )
                     Exit
                  EndIf
               EndIf
            Else
               Exit
            EndIf
         EndDo
      EndIf

      // Clear bottom rows
      Do While ::ItemCount > nRow
         ::DeleteItem( ::ItemCount )
      EndDo
      // Return to current row
      If nRow > nCurrent
         ::DbSkip( nCurrent - nRow )
      Else
         nCurrent := nRow
      EndIf
      ::CurrentRow := nCurrent

      If ::Visible
         ::SetRedraw( .T. )
      EndIf
   EndIf

   Return Self

METHOD RefreshRow( nRow ) CLASS TXBrowse

   Local aItem, cWorkArea

   If ! ::lLocked
      cWorkArea := ::WorkArea
      If ValType( cWorkArea ) $ "CM" .AND. ( Empty( cWorkArea ) .OR. Select( cWorkArea ) == 0 )
         cWorkArea := Nil
      EndIf
      aItem := ARRAY( LEN( ::aFields ) )
      If ::FixBlocks()
         aEval( aItem, { |x,i| aItem[ i ] := EVAL( ::aColumnBlocks[ i ], cWorkArea ), x } )
      Else
         aEval( aItem, { |x,i| aItem[ i ] := EVAL( ::ColumnBlock( i ), cWorkArea ), x } )
      EndIf
      aEval( aItem, { |x,i| If( ValType( x ) $ "CM", aItem[ i ] := TRIM( x ),  ) } )

      If ValType( cWorkArea ) $ "CM"
         ( cWorkArea )->( ::SetItemColor( nRow,,, aItem ) )
      Else
         ::SetItemColor( nRow,,, aItem )
      EndIf

      If ::ItemCount < nRow
         AddListViewItems( ::hWnd, aItem )
      Else
         ListViewSetItem( ::hWnd, aItem, nRow )
      EndIf

      ::DoEvent( ::OnRefreshRow, "REFRESHROW", { nRow, aItem } )
   EndIf

   Return Self

METHOD ColumnBlock( nCol, lDirect ) CLASS TXBrowse

   Local oEditControl, cWorkArea, cValue, uPicture, bRet

   ASSIGN lDirect VALUE lDirect TYPE "L" DEFAULT .F.
   If ! ValType( nCol ) == "N" .OR. nCol < 1 .OR. nCol > LEN( ::aFields )
      Return { || "" }
   EndIf
   cWorkArea := ::WorkArea
   If ValType( cWorkArea ) $ "CM" .AND. ( Empty( cWorkArea ) .OR. Select( cWorkArea ) == 0 )
      cWorkArea := Nil
   EndIf
   cValue := ::aFields[ nCol ]
   bRet := Nil
   If ! lDirect
      If ::FixControls()
         oEditControl := ::aEditControls[ nCol ]
      EndIf
      oEditControl := GetEditControlFromArray( oEditControl, ::EditControls, nCol, Self )
      If ValType( oEditControl ) == "O"
         If oEditControl:Type == "TGRIDCONTROLIMAGEDATA" .AND. ValType( cValue ) == "A" .AND. LEN( cValue ) > 1
            If ValType( cWorkArea ) $ "CM"
               If HB_IsBlock( cValue[1] )
                  If HB_IsBlock( cValue[2] )
                     bRet := { |wa| oEditControl:GridValue( { ( cWorkArea ) -> ( EVAL( cValue[1], wa ) ), ( cWorkArea ) -> ( EVAL( cValue[2], wa ) ) } ) }
                  Else
                     bRet := { |wa| oEditControl:GridValue( { ( cWorkArea ) -> ( EVAL( cValue[1], wa ) ), ( cWorkArea ) -> ( &( cValue[2] ) ) } ) }
                  EndIf
               Else
                  If HB_IsBlock( cValue[2] )
                     bRet := { |wa| oEditControl:GridValue( { ( cWorkArea ) -> ( &( cValue[1] ) ), ( cWorkArea ) -> ( EVAL( cValue[2], wa ) ) } ) }
                  Else
                     bRet := { || oEditControl:GridValue( { ( cWorkArea ) -> ( &( cValue[1] ) ), ( cWorkArea ) -> ( &( cValue[2] ) ) } ) }
                  EndIf
               EndIf
            Else
               If HB_IsBlock( cValue[1] )
                  If HB_IsBlock( cValue[2] )
                     bRet := { |wa| oEditControl:GridValue( EVAL( cValue[1], wa ),  EVAL( cValue[2], wa ) ) }
                  Else
                     bRet := { |wa| oEditControl:GridValue(  EVAL( cValue[1], wa ),  &( cValue[2] ) ) }
                  EndIf
               Else
                  If HB_IsBlock( cValue[2] )
                     bRet := { |wa| oEditControl:GridValue( &( cValue[1] ),  EVAL( cValue[2], wa ) ) }
                  Else
                     bRet := { || oEditControl:GridValue(  &( cValue[1] ),  &( cValue[2] ) ) }
                  EndIf
               EndIf
            EndIf
         ElseIf ValType( cWorkArea ) $ "CM"
            If ValType( cValue ) == "B"
               bRet := { |wa| oEditControl:GridValue( ( cWorkArea ) -> ( EVAL( cValue, wa ) ) ) }
            Else
               bRet := { || oEditControl:GridValue( ( cWorkArea ) -> ( &( cValue ) ) ) }
            EndIf
         Else
            If ValType( cValue ) == "B"
               bRet := { |wa| oEditControl:GridValue( EVAL( cValue, wa ) ) }
            Else
               bRet := { || oEditControl:GridValue( &( cValue ) ) }
            EndIf
         EndIf
      Else
         uPicture := ::Picture[ nCol ]
         If ValType( uPicture ) $ "CM"
            // Picture
            If ValType( cWorkArea ) $ "CM"
               If ValType( cValue ) == "B"
                  bRet := { |wa| Trim( Transform( ( cWorkArea ) -> ( EVAL( cValue, wa ) ), uPicture ) ) }
               Else
                  bRet := { || Trim( Transform( ( cWorkArea ) -> ( &( cValue ) ), uPicture ) ) }
               EndIf
            Else
               If ValType( cValue ) == "B"
                  bRet := { |wa| Trim( Transform( EVAL( cValue, wa ), uPicture ) ) }
               Else
                  bRet := { || Trim( Transform( &( cValue ), uPicture ) ) }
               EndIf
            EndIf
         ElseIf ValType( uPicture ) == "L" .AND. uPicture
            // Direct value
         Else
            // Convert
            If ValType( cWorkArea ) $ "CM"
               If ValType( cValue ) == "B"
                  bRet := { |wa| TXBrowse_UpDate_PerType( ( cWorkArea ) -> ( EVAL( cValue, wa ) ) ) }
               Else
                  // bRet := { || TXBrowse_UpDate_PerType( ( cWorkArea ) -> ( &( cValue ) ) ) }
                  bRet := &( " { || TXBrowse_UpDate_PerType( " + cWorkArea + " -> ( " + cValue + " ) ) } " )
               EndIf
            Else
               If ValType( cValue ) == "B"
                  bRet := { |wa| TXBrowse_UpDate_PerType( EVAL( cValue, wa ) ) }
               Else
                  // bRet := { || TXBrowse_UpDate_PerType( &( cValue ) ) }
                  bRet := &( " { || TXBrowse_UpDate_PerType( " + cValue + " ) } " )
               EndIf
            EndIf
         EndIf
      EndIf
   EndIf
   If bRet == Nil
      // Direct value
      If ValType( cWorkArea ) $ "CM"
         If ValType( cValue ) == "A"
            If HB_IsBlock( cValue[1] )
               If HB_IsBlock( cValue[2] )
                  bRet := { |wa| { ( cWorkArea ) -> ( EVAL( cValue[1], wa ) ), ( cWorkArea ) -> ( EVAL( cValue[2], wa ) ) } }
               Else
                  bRet := { |wa| { ( cWorkArea ) -> ( EVAL( cValue[1], wa ) ), ( cWorkArea ) -> ( &( cValue[2] ) ) } }
               EndIf
            Else
               If HB_IsBlock( cValue[2] )
                  bRet := { |wa| { ( cWorkArea ) -> ( &( cValue[1] ) ), ( cWorkArea ) -> ( EVAL( cValue[2], wa ) ) } }
               Else
                  bRet := { || { ( cWorkArea ) -> ( &( cValue[1] ) ), ( cWorkArea ) -> ( &( cValue[2] ) ) } }
               EndIf
            EndIf
         ElseIf ValType( cValue ) == "B"
            bRet := { |wa| ( cWorkArea ) -> ( EVAL( cValue, wa ) ) }
         Else
            // bRet := { || ( cWorkArea ) -> ( &( cValue ) ) }
            bRet := &( " { || " + cWorkArea + " -> ( " + cValue + " ) } " )
         EndIf
      Else
         If ValType( cValue ) == "A"
            bRet := cValue
         ElseIf ValType( cValue ) == "B"
            bRet := cValue
         Else
            // bRet := { || &( cValue ) }
            bRet := &( " { || " + cValue + " } " )
         EndIf
      EndIf
   EndIf

   Return bRet

FUNCTION TXBrowse_UpDate_PerType( uValue )

   Local cType := ValType( uValue )

   If cType == "C"
      uValue := rTrim( uValue )
   ElseIf cType == "N"
      uValue := lTrim( Str( uValue ) )
   ElseIf cType == "L"
      uValue := IIf( uValue, ".T.", ".F." )
   ElseIf cType == "D"
      uValue := Dtoc( uValue )
   ElseIf cType == "T"
      uValue := Ttoc( uValue )
   ElseIf cType == "M"
      uValue := '<Memo>'
   ElseIf cType == "A"
      uValue := "<Array>"
   ElseIf cType == "H"
      uValue := "<Hash>"
   ElseIf cType == "O"
      uValue := "<Object>"
   Else
      uValue := "Nil"
   EndIf

   Return uValue

METHOD MoveTo( nTo, nFrom ) CLASS TXBrowse

   Local lMoved := .F.

   If ! ::lLocked .AND. ! ( ::lNoShowEmptyRow .AND. ::oWorkArea:IsTableEmpty() )
      ASSIGN nTo   VALUE INT( nTo )   TYPE "N" DEFAULT ::CurrentRow
      ASSIGN nFrom VALUE INT( nFrom ) TYPE "N" DEFAULT ::nRowPos
      nFrom := Max( Min( nFrom, ::ItemCount ), 1 )
      nTo   := Max( Min( nTo,   ::CountPerPage ), 1 )
      ::RefreshRow( nFrom )
      Do While nFrom != nTo
         lMoved := .T.
         If nFrom > nTo
            If ::DbSkip( -1 ) != 0
               nFrom --
               ::RefreshRow( nFrom )
            Else
               Exit
            EndIf
         Else
            If ::DbSkip( 1 ) != 0
               nFrom ++
               ::RefreshRow( nFrom )
            Else
               Exit
            EndIf
         EndIf
      EndDo
      ::CurrentRow := nTo
      If lMoved
         ::DoChange()
      EndIf
   EndIf

   Return Self

METHOD CurrentRow( nValue ) CLASS TXBrowse

   Local oVScroll, aPosition

   If ValType( nValue ) == "N" .AND. ! ::lLocked
      oVScroll := ::VScroll
      If ::lVScrollVisible
         If ::lRecCount
            aPosition := { ::oWorkArea:OrdKeyNo(), ::oWorkArea:RecCount() }
         Else
            aPosition := { ::oWorkArea:OrdKeyNo(), ::oWorkArea:OrdKeyCount() }
         EndIf
         If ::lDescending
            aPosition[ 1 ] := aPosition[ 2 ] - aPosition[ 1 ] + 1
         EndIf
         If aPosition[ 2 ] == 0
            oVScroll:RangeMax := oVScroll:RangeMin
            oVScroll:Value := oVScroll:RangeMax
         ElseIf aPosition[ 2 ] < 10000
            oVScroll:RangeMax := aPosition[ 2 ]
            oVScroll:Value := aPosition[ 1 ]
         Else
            oVScroll:RangeMax := 10000
            oVScroll:Value := Int( aPosition[ 1 ] * 10000 / aPosition[ 2 ] )
         EndIf
      EndIf
      ::nRowPos := ( ::Super:Value := nValue )
   EndIf

   Return ::Super:Value

METHOD Value( uValue ) CLASS TXBrowse

   If ::FirstVisibleColumn # 0 .AND. HB_IsNumeric( uValue ) .AND. uValue >= 1 .AND. uValue <= ::ItemCount
      ::Super:Value( uValue )
      If ::lRefreshAfterValue
         ::Refresh()
      EndIf
   EndIf

   Return ::CurrentRow

METHOD SetControlValue( uValue ) CLASS TXBrowse

   If HB_IsNumeric( uValue )
      If ! ::lLocked .AND. ::FirstVisibleColumn # 0 .AND. uValue >= 1
         ::MoveTo( uValue, ::nRowPos )
      Else
         ::CurrentRow := ::nRowPos
      EndIf
   EndIf

   Return ::CurrentRow

METHOD SizePos( Row, Col, Width, Height ) CLASS TXBrowse

   Local uRet, nWidth

   ASSIGN ::nRow    VALUE Row    TYPE "N"
   ASSIGN ::nCol    VALUE Col    TYPE "N"
   ASSIGN ::nWidth  VALUE Width  TYPE "N"
   ASSIGN ::nHeight VALUE Height TYPE "N"

   If ::lVScrollVisible
      nWidth := ::VScroll:Width

      // See below
      ::ScrollButton:Visible := .F.

      If ::lRtl .AND. ! ::Parent:lRtl
         uRet := MoveWindow( ::hWnd, ::ContainerCol + nWidth, ::ContainerRow, ::nWidth - nWidth, ::nHeight, .T. )
         ::VScroll:Col      := - nWidth
         ::ScrollButton:Col := - nWidth
      Else
         uRet := MoveWindow( ::hWnd, ::ContainerCol,          ::ContainerRow, ::nWidth - nWidth, ::nHeight, .T. )
         ::VScroll:Col      := ::Width - ::VScroll:Width
         ::ScrollButton:Col := ::Width - ::VScroll:Width
      EndIf

      If IsWindowStyle( ::hWnd, WS_HSCROLL )
         ::VScroll:Height := ::Height - ::ScrollButton:Height
      Else
         ::VScroll:Height := ::Height
      EndIf
      ::ScrollButton:Row := ::Height - ::ScrollButton:Height
      aEval( ::aControls, { |o| o:SizePos() } )

      /*
       * This two instructions force the redrawn of the control's area
       * that is been overwritten by the scrollbars.
       */
      ::ScrollButton:Visible := .T.
   else
      uRet := MoveWindow( ::hWnd, ::ContainerCol, ::ContainerRow, ::nWidth, ::nHeight , .T. )
   EndIf

   If ! ::AdjustRightScroll()
      ::Refresh()
   EndIf

   Return uRet

METHOD Enabled( lEnabled ) CLASS TXBrowse

   If ValType( lEnabled ) == "L"
      ::Super:Enabled := lEnabled
      aEval( ::aControls, { |o| o:Enabled := o:Enabled } )
   EndIf

   Return ::Super:Enabled

METHOD ToExcel( cTitle, nColFrom, nColTo ) CLASS TXBrowse

   Local oExcel, oSheet, nLin, i, cWorkArea, uValue, aColumnOrder

   If ::lLocked
      Return Self
   EndIf
   If ! ValType( cTitle ) $ "CM"
      cTitle := ""
   EndIf
   If ! ValType( nColFrom ) == "N" .OR. nColFrom < 1 .OR. nColFrom > Len( ::aHeaders )
      // nColFrom is an index in ::ColumnOrder
      nColFrom := 1
   EndIf
   If ! ValType( nColTo ) == "N" .OR. nColTo < 1 .OR. nColTo > Len( ::aHeaders ) .OR. nColTo < nColFrom
      // nColTo is an index in ::ColumnOrder
      nColTo := Len( ::aHeaders )
   EndIf

   #ifndef __XHARBOUR__
      If ( oExcel := win_oleCreateObject( "Excel.Application" ) ) == Nil
         MsgStop( "Error: MS Excel not available. [" + win_oleErrorText()+ "]" )
         Return Self
      EndIf
   #else
      oExcel := TOleAuto():New( "Excel.Application" )
      If Ole2TxtError() != "S_OK"
         MsgStop( "Excel not found", "Error" )
         Return Self
      EndIf
   #EndIf

   oExcel:WorkBooks:Add()
   oSheet := oExcel:ActiveSheet()
   oSheet:Cells:Font:Name := "Arial"
   oSheet:Cells:Font:Size := 10

   aColumnOrder := ::ColumnOrder
   nLin := 4

   For i := nColFrom To nColTo
      oSheet:Cells( nLin, i - nColFrom + 1 ):Value := ::aHeaders[ aColumnOrder[ i ] ]
      oSheet:Cells( nLin, i - nColFrom + 1 ):Font:Bold := .T.
   Next i
   nLin += 2

   cWorkArea := ::WorkArea
   If ValType( cWorkArea ) $ "CM" .AND. ( Empty( cWorkArea ) .OR. Select( cWorkArea ) == 0 )
      cWorkArea := Nil
   EndIf

   ::GoTop()
   Do While ! ::Eof()
      For i := nColFrom To nColTo
         If HB_IsBlock( ::aFields[ aColumnOrder[ i ] ] )
            uValue := ( cWorkArea ) -> ( Eval( ::aFields[ aColumnOrder[ i ] ], cWorkArea ) )
         Else
            uValue := ( cWorkArea ) -> ( &( ::aFields[ aColumnOrder[ i ] ] ) )
         EndIf
         If ValType( uValue ) == "C"
            uValue := "'" + uValue
         EndIf
         If ! HB_IsDate( uValue ) .OR. ! Empty( uValue )
            oSheet:Cells( nLin, i - nColFrom + 1 ):Value := uValue
         EndIf
      Next i
      ::DbSkip()
      nLin ++
   EndDo

   For i := nColFrom To nColTo
      oSheet:Columns( i - nColFrom + 1 ):AutoFit()
   Next i

   oSheet:Cells( 1, 1 ):Value := cTitle
   oSheet:Cells( 1, 1 ):Font:Bold := .T.

   oSheet:Cells( 1, 1 ):Select()
   oExcel:Visible := .T.
   oSheet := Nil
   oExcel := Nil

   Return Self

METHOD ToOpenOffice( cTitle, nColFrom, nColTo ) CLASS TXBrowse

   Local oSerMan, oDesk, oPropVals, oBook, oSheet, nLin, i, uValue, cWorkArea, aColumnOrder

   If ::lLocked
      Return Self
   EndIf
   If ! ValType( cTitle ) $ "CM"
      cTitle := ""
   EndIf
   If ! ValType( nColFrom ) == "N" .OR. nColFrom < 1 .OR. nColTo > Len( ::aHeaders )
      // nColFrom is an index in ::ColumnOrder
      nColFrom := 1
   EndIf
   If ! ValType( nColTo ) == "N" .OR. nColTo > Len( ::aHeaders ) .OR. nColTo < nColFrom
      // nColTo is an index in ::ColumnOrder
      nColTo := Len( ::aHeaders )
   EndIf

   // open service manager
   #ifndef __XHARBOUR__
      If ( oSerMan := win_oleCreateObject( "com.sun.star.ServiceManager" ) ) == Nil
         MsgStop( "Error: OpenOffice not available. [" + win_oleErrorText()+ "]" )
         Return Self
      EndIf
   #else
      oSerMan := TOleAuto():New( "com.sun.star.ServiceManager" )
      If Ole2TxtError() != "S_OK"
         MsgStop( "OpenOffice not found", "Error" )
         Return Self
      EndIf
   #EndIf

   // open desktop service
   If ( oDesk := oSerMan:CreateInstance( "com.sun.star.frame.Desktop" ) ) == Nil
      MsgStop( "Error: OpenOffice Desktop not available." )
      Return Self
   EndIf

   // set properties for new book
   oPropVals := oSerMan:Bridge_GetStruct( "com.sun.star.beans.PropertyValue" )
   oPropVals:Name := "Hidden"
   oPropVals:Value := .T.

   // open new book
   If ( oBook := oDesk:LoadComponentFromURL( "private:factory/scalc", "_blank", 0, {oPropVals} ) ) == Nil
      MsgStop( "Error: OpenOffice Calc not available." )
      oDesk := Nil
      Return Self
   EndIf

   // keep only one sheet
   Do While oBook:Sheets:GetCount() > 1
      oSheet := oBook:Sheets:GetByIndex( oBook:Sheets:GetCount() - 1 )
      oBook:Sheets:RemoveByName( oSheet:Name )
   EndDo

   // select first sheet
   oSheet := oBook:Sheets:GetByIndex( 0 )
   oBook:GetCurrentController:SetActiveSheet( oSheet )

   // set font name and size of all cells
   oSheet:CharFontName := "Arial"
   oSheet:CharHeight := 10

   aColumnOrder := ::ColumnOrder
   nLin := 4

   // put headers using bold style
   For i := nColFrom To nColTo
      oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetString( ::aHeaders[ aColumnOrder[ i ] ] )
      oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetPropertyValue( "CharWeight", 150 )
   Next i
   nLin += 2

   // put rows
   cWorkArea := ::WorkArea
   If ValType( cWorkArea ) $ "CM" .AND. ( Empty( cWorkArea ) .OR. Select( cWorkArea ) == 0 )
      cWorkArea := Nil
   EndIf

   ::GoTop()
   Do While ! ::Eof()
      For i := nColFrom To nColTo
         If HB_IsBlock( ::aFields[ aColumnOrder[ i ] ] )
            uValue := ( cWorkArea ) -> ( Eval( ::aFields[ aColumnOrder[ i ] ], cWorkArea ) )
         Else
            uValue := ( cWorkArea ) -> ( &( ::aFields[ aColumnOrder[ i ] ] ) )
         EndIf

         Do Case
         Case uValue == Nil
         Case ValType( uValue ) == "C"
            If Left( uValue, 1 ) == "'"
               uValue := "'" + uValue
            EndIf
            oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetString( uValue )
         Case ValType( uValue ) == "N"
            oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetValue( uValue )
         Case ValType( uValue ) == "L"
            oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetValue( uValue )
            oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetPropertyValue("NumberFormat", 99 )
         Case ValType( uValue ) == "D"
            oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetValue( uValue )
            oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetPropertyValue( "NumberFormat", 36 )
         Case ValType( uValue ) == "T"
            oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetString( uValue )
         otherwise
            oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetFormula( uValue )
         EndCase
      Next i
      ::DbSkip()
      nLin ++
   EndDo

   // autofit columns
   For i := nColFrom To nColTo
      oSheet:GetColumns:GetByIndex( i - nColFrom ):SetPropertyValue( "OptimalWidth", .T. )
   Next i

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

   Return Self

METHOD Visible( lVisible ) CLASS TXBrowse

   If ValType( lVisible ) == "L"
      ::Super:Visible := lVisible
      aEval( ::aControls, { |o| o:Visible := lVisible } )
   EndIf

   Return ::lVisible

METHOD RefreshData() CLASS TXBrowse

   ::Refresh()

   Return ::Super:RefreshData()

METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TXBrowse

   Local cWorkArea, uGridValue

   If nMsg == WM_CHAR
      If wParam < 32 .OR. ::SearchCol < 1 .OR. ::SearchCol > ::ColumnCount .OR. ::lLocked .OR. aScan( ::aHiddenCols, ::SearchCol ) # 0
         ::cText := ""
         Return 0
      ElseIf Empty( ::cText )
         ::uIniTime := HB_MilliSeconds()
         ::cText := Upper( Chr( wParam ) )
      ElseIf HB_MilliSeconds() > ::uIniTime + ::SearchLapse
         ::uIniTime := HB_MilliSeconds()
         ::cText := Upper( Chr( wParam ) )
      Else
         ::uIniTime := HB_MilliSeconds()
         ::cText += Upper( Chr( wParam ) )
      EndIf

      cWorkArea := ::WorkArea
      If ValType( cWorkArea ) $ "CM" .AND. ( Empty( cWorkArea ) .OR. Select( cWorkArea ) == 0 )
         cWorkArea := Nil
      EndIf

      ::DbSkip()

      Do While ! ::Eof()
         If ::FixBlocks()
            uGridValue := Eval( ::aColumnBlocks[ ::SearchCol ], cWorkArea )
         Else
            uGridValue := Eval( ::ColumnBlock( ::SearchCol ), cWorkArea )
         EndIf
         If ValType( uGridValue ) == "A"      // TGridControlImageData
            uGridValue := uGridValue[ 1 ]
         EndIf

         If Upper( Left( uGridValue, Len( ::cText ) ) ) == ::cText
            Exit
         EndIf

         ::DbSkip()
      EndDo

      If ::Eof() .AND. ::SearchWrap
         ::TopBottom( GO_TOP )

         Do While ! ::Eof()
            If ::FixBlocks()
               uGridValue := Eval( ::aColumnBlocks[ ::SearchCol ], cWorkArea )
            Else
               uGridValue := Eval( ::ColumnBlock( ::SearchCol ), cWorkArea )
            EndIf
            If ValType( uGridValue ) == "A"      // TGridControlImageData
               uGridValue := uGridValue[ 1 ]
            EndIf

            If Upper( Left( uGridValue, Len( ::cText ) ) ) == ::cText
               Exit
            EndIf

            ::DbSkip()
         EndDo
      EndIf

      If ::Eof()
         ::GoBottom()
      Else
         ::Refresh( ::CountPerPage )
         ::DoChange()
      EndIf

      Return 0

   ElseIf nMsg == WM_KEYDOWN
      Do Case
      Case ::FirstVisibleColumn == 0
      Case wParam == VK_HOME
         ::GoTop()
         Return 0
      Case wParam == VK_END
         ::GoBottom()
         Return 0
      Case wParam == VK_PRIOR
         ::PageUp()
         Return 0
      Case wParam == VK_NEXT
         ::PageDown()
         Return 0
      Case wParam == VK_UP
         ::Up()
         Return 0
      Case wParam == VK_DOWN
         ::Down()
         Return 0
      EndCase

   EndIf

   Return ::Super:Events( hWnd, nMsg, wParam, lParam )

METHOD Events_Notify( wParam, lParam ) CLASS TXBrowse

   Local nvKey, lGo, uValue, nNotify := GetNotifyCode( lParam )

   If nNotify == NM_CLICK
      If ::lCheckBoxes
         // detect item
         uValue := ListView_HitOnCheckBox( ::hWnd, GetCursorRow() - GetWindowRow( ::hWnd ), GetCursorCol() - GetWindowCol( ::hWnd ) )
      Else
         uValue := 0
      EndIf

      If ::bPosition == -2 .OR. ::bPosition == 9
         ::nDelayedClick := { ::FirstSelectedItem, 0, uValue, Nil }
         If ::nRowPos > 0
            ListView_SetCursel( ::hWnd, ::nRowPos )
         Else
            ListView_ClearCursel( ::hWnd )
         EndIf
      Else
         If HB_IsBlock( ::OnClick )
            If ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. uValue <= 0
               If ! ::NestedClick
                  ::NestedClick := ! _OOHG_NestedSameEvent()
                  ::DoEventMouseCoords( ::OnClick, "CLICK" )
                  ::NestedClick := .F.
               EndIf
            EndIf
         EndIf

         If uValue > 0
            // change check mark
            ::CheckItem( uValue, ! ::CheckItem( uValue ) )
         Else
            // select item
            If ! ::lLocked .AND. ::FirstVisibleColumn # 0
               ::MoveTo( ::CurrentRow, ::nRowPos )
            Else
               ::Super:Value := ::nRowPos
            EndIf
         EndIf
      EndIf

      // skip default action
      Return 1

   ElseIf nNotify == NM_RCLICK
      If ::lCheckBoxes
         // detect item
         uValue := ListView_HitOnCheckBox( ::hWnd, GetCursorRow() - GetWindowRow( ::hWnd ), GetCursorCol() - GetWindowCol( ::hWnd ) )
      Else
         uValue := 0
      EndIf

      If ::bPosition == -2 .OR. ::bPosition == 9
         ::nDelayedClick := { ::FirstSelectedItem, 0, uValue, _GetGridCellData( Self, ListView_ItemActivate( lParam ) ) }
         If ::nRowPos > 0
            ListView_SetCursel( ::hWnd, ::nRowPos )
         Else
            ListView_ClearCursel( ::hWnd )
         EndIf
      Else
         If HB_IsBlock( ::OnRClick )
            If ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. uValue <= 0
               ::DoEventMouseCoords( ::OnRClick, "RCLICK" )
            EndIf
         EndIf

         If uValue > 0
            // change check mark
            ::CheckItem( uValue, ! ::CheckItem( uValue ) )
         Else
            // select item
            If ! ::lLocked .AND. ::FirstVisibleColumn # 0
               ::MoveTo( ::CurrentRow, ::nRowPos )
            Else
               ::Super:Value := ::nRowPos
            EndIf
         EndIf

         // fire context menu
         If ::ContextMenu != Nil .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. uValue <= 0 )
            ::ContextMenu:Cargo := _GetGridCellData( Self, ListView_ItemActivate( lParam ) )
            ::ContextMenu:Activate()
         EndIf
      EndIf

      // skip default action
      Return 1

   ElseIf nNotify == LVN_BEGINDRAG
      If ::bPosition == -2 .OR. ::bPosition == 9
         ::nDelayedClick := { ::FirstSelectedItem, 0, 0, Nil }
         If ::nRowPos > 0
            ListView_SetCursel( ::hWnd, ::nRowPos )
         Else
            ListView_ClearCursel( ::hWnd )
         EndIf
      Else
         If ! ::lLocked .AND. ::FirstVisibleColumn # 0
            ::MoveTo( ::CurrentRow, ::nRowPos )
         Else
            ::Super:Value := ::nRowPos
         EndIf
      EndIf
      Return Nil

   ElseIf nNotify == LVN_KEYDOWN
      If ::FirstVisibleColumn # 0
         If GetGridvKeyAsChar( lParam ) == 0
            ::cText := ""
         EndIf

         nvKey := GetGridvKey( lParam )
         Do Case
         Case GetKeyFlagState() == MOD_ALT .AND. nvKey == VK_A
            If ::lAppendOnAltA
               ::AppendItem()
            EndIf

         Case nvKey == VK_DELETE
            If ::AllowDelete .AND. ! ::Eof() .AND. ! ::lLocked
               If ValType( ::bDelWhen ) == "B"
                  lGo := _OOHG_Eval( ::bDelWhen )
               Else
                  lGo := .T.
               EndIf

               If lGo
                  If ::lNoDelMsg .OR. MsgYesNo( _OOHG_Messages( 4, 1 ), _OOHG_Messages( 4, 2 ) )
                     ::Delete()
                  EndIf
               ElseIf ! Empty( ::DelMsg )
                  MsgExclamation( ::DelMsg, _OOHG_Messages( 4, 2 ) )
               EndIf
            EndIf
         EndCase
      EndIf
      Return Nil

   ElseIf nNotify == LVN_ITEMCHANGED
      If GetGridOldState( lParam ) == 0 .and. GetGridNewState( lParam ) != 0
         Return Nil
      EndIf

   ElseIf nNotify == NM_CUSTOMDRAW
      ::AdjustRightScroll()
      Return TGrid_Notify_CustomDraw( Self, lParam, .F., , , .F., ::lFocusRect, ::lNoGrid, ::lPLM )

   EndIf

   Return ::Super:Events_Notify( wParam, lParam )

METHOD DbSkip( nRows ) CLASS TXBrowse

   Local nCount, nSign

   nSign := If( ::lDescending, -1, 1 )
   ASSIGN nRows VALUE nRows TYPE "N" DEFAULT 1
   If ValType( ::skipBlock ) == "B"
      nCount := EVAL( ::skipBlock, nRows * nSign, ::WorkArea ) * nSign
   Else
      nCount := ::oWorkArea:Skipper( nRows * nSign ) * nSign
   EndIf
   ::Bof := ::Eof := .F.
   If ! nCount == nRows
      If nRows < 1
         ::Bof := .T.
      Else
         ::Eof := .T.
      EndIf
   EndIf

   Return nCount

METHOD Up() CLASS TXBrowse

   Local nValue

   If ! ::lLocked .AND. ::DbSkip( -1 ) == -1
      nValue := ::CurrentRow
      If nValue <= 1
         If ::ItemCount >= ::CountPerPage
            ::DeleteItem( ::ItemCount )
         EndIf
         ::InsertBlank( 1 )
      Else
         nValue --
      EndIf
      If ::lUpdCols
         ::Refresh( nValue )
      Else
         ::RefreshRow( nValue )
         ::CurrentRow := nValue
      EndIf
      ::DoChange()
   EndIf

   Return Self

METHOD Down( lAppend ) CLASS TXBrowse

   Local nValue, lRet := .F.

   If ! ::lLocked
      If ::DbSkip( 1 ) == 1
         nValue := ::CurrentRow
         If nValue >= ::CountPerPage
            ::DeleteItem( 1 )
         Else
            nValue ++
         EndIf
         If ::lUpdCols
            ::Refresh( nValue )
         Else
            ::RefreshRow( nValue )
            ::CurrentRow := nValue
         EndIf
         ::DoChange()
         lRet := .T.
      Else
         ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT ::AllowAppend
         If lAppend
            lRet := ::AppendItem()
         EndIf
      EndIf
   EndIf

   Return lRet

METHOD AppendItem( lAppend ) CLASS TXBrowse

   Local lRet := .F.

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   If ( lAppend .OR. ::AllowAppend ) .AND. ! ::lLocked .AND. ! ::lNestedEdit
      ::lNestedEdit := .T.
      ::cText := ""
      If ::FullMove
         lRet := ::EditGrid( , , .T.)
      ElseIf ::InPlace
         lRet := ::EditAllCells( , , .T. )
      Else
         lRet := ::EditItem( .T. )
      EndIf
      ::lNestedEdit := .F.
   EndIf

   Return lRet

METHOD PageUp() CLASS TXBrowse

   If ! ::lLocked .AND. ::DbSkip( -::CountPerPage ) != 0
      ::Refresh()
      ::DoChange()
   EndIf

   Return Self

METHOD PageDown( lAppend ) CLASS TXBrowse

   Local nSkip, nCountPerPage

   If ::lLocked
      // Do not move
   Else
      nCountPerPage := ::CountPerPage
      nSkip := ::DbSkip( nCountPerPage )
      If nSkip != nCountPerPage
         ::Refresh( nCountPerPage )
         ::DoChange()
         ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT ::AllowAppend
         If lAppend
            ::AppendItem()
         EndIf
      ElseIf nSkip != 0
         ::Refresh( , .T. )
         ::DoChange()
      EndIf
   EndIf

   Return Self

METHOD TopBottom( nDir ) CLASS TXBrowse

   If ::lDescending
      nDir := - nDir
   EndIf
   If nDir == GO_BOTTOM
      If ValType( ::goBottomBlock ) == "B"
         EVAL( ::goBottomBlock, ::WorkArea )
      Else
         ::oWorkArea:GoBottom()
      EndIf
   Else
      If ValType( ::goTopBlock ) == "B"
         EVAL( ::goTopBlock, ::WorkArea )
      Else
         ::oWorkArea:GoTop()
      EndIf
   EndIf
   ::Bof := ( ::lNoShowEmptyRow .AND. ::oWorkArea:IsTableEmpty() )
   ::Eof := ::oWorkArea:Eof()

   Return Self

METHOD GoTop() CLASS TXBrowse

   If ! ::lLocked
      ::TopBottom( GO_TOP )
      ::Refresh( 1 )
      ::DoChange()
   EndIf

   Return Self

METHOD GoBottom( lAppend ) CLASS TXBrowse

   If ! ::lLocked
      ::TopBottom( GO_BOTTOM )
      ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
      // If it's for APPEND, leaves a blank line ;)
      ::Refresh( ::CountPerPage - If( lAppend, 1, 0 ) )
      ::DoChange()
   EndIf

Return Self

*------------------------------------------------------------------------------*
METHOD SetScrollPos( nPos, VScroll ) CLASS TXBrowse
*------------------------------------------------------------------------------*
Local aPosition

   If ::lLocked
      // Do nothing!
   ElseIf nPos <= VScroll:RangeMin
      ::GoTop()
   ElseIf nPos >= VScroll:RangeMax
      ::GoBottom()
   Else
      If ::lRecCount
         aPosition := { ::oWorkArea:OrdKeyNo(), ::oWorkArea:RecCount() }
      Else
         aPosition := { ::oWorkArea:OrdKeyNo(), ::oWorkArea:OrdKeyCount() }
      EndIf
      nPos := nPos * aPosition[ 2 ] / VScroll:RangeMax
      #ifdef __XHARBOUR__
         If ! ::lDescending
            ::oWorkArea:OrdKeyGoTo( nPos )
         Else
            ::oWorkArea:OrdKeyGoTo( aPosition[ 2 ] + 1 - nPos )
         EndIf
      #else
         If nPos < ( aPosition[ 2 ] / 2 )
            ::TopBottom( GO_TOP )
            ::DbSkip( MAX( nPos - 1, 0 ) )
         Else
            ::TopBottom( GO_BOTTOM )
            ::DbSkip( - MAX( aPosition[ 2 ] - nPos - 1, 0 ) )
         EndIf
      #EndIf
      ::Refresh( , .T. )
      ::DoChange()
   EndIf

Return Self

*------------------------------------------------------------------------------*
METHOD Delete() CLASS TXBrowse
*------------------------------------------------------------------------------*
Local Value

   If ::lLocked
      Return .F.
   EndIf

   Value := ::CurrentRow
   If Value == 0
      Return .F.
   EndIf

   If ::Lock
      If ! ::oWorkArea:Lock()
         MsgExclamation( _OOHG_Messages(3, 9), _OOHG_Messages(4, 2) )
         Return .F.
      EndIf
   EndIf

   ::oWorkArea:Delete()

   // Do before unlocking record or moving record pointer
   // so block can operate on deleted record (e.g. to copy to a log).
   ::DoEvent( ::OnDelete, 'DELETE' )

   If ::Lock
      ::oWorkArea:Commit()
      ::oWorkArea:UnLock()
   EndIf

   If ::DbSkip( 1 ) == 0
      ::GoBottom()
   Else
      ::Refresh()
      ::DoChange()
   EndIf

   Return .T.

METHOD EditItem( lAppend, lOneRow, nItem, lChange ) CLASS TXBrowse

   Local lSomethingEdited := .F.

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   ASSIGN lOneRow VALUE lOneRow TYPE "L" DEFAULT .T.
   // to work properly, nItem and the data source record must be synchronized
   Empty( lChange )

   If ! ::lLocked
      If ::InPlace .AND. ::lForceInPlace
         Return ::EditAllCells( , , lAppend, lOneRow )
      EndIf

      If lAppend
         If ::lAppendMode
            Return .F.
         EndIf
         ::lAppendMode := .T.
         ::GoBottom( .T. )
         ::InsertBlank( ::ItemCount + 1 )
         ::CurrentRow := ::ItemCount
         ::oWorkArea:GoTo( 0 )
      Else
         If ! HB_IsNumeric( nItem )
            nItem := Max( ::CurrentRow, 1 )
         EndIf
         If nItem < 1 .OR. nItem > ::ItemCount
            Return .F.
         EndIf
         ::SetControlValue( nItem )
      EndIf
      If ::lVScrollVisible
         // Kills scrollbar's events...
         ::VScroll:Enabled := .F.
         ::VScroll:Enabled := .T.
      EndIf

      Do While .T.
         If ! ::EditItem_B( lAppend )
            Exit
         EndIf
         if lAppend
            ::DoChange()
         EndIf
         lSomethingEdited := .T.
         If lOneRow
            Exit
         EndIf
         If ! ::Down( .F. )
            Exit
         EndIf
      EndDo
   EndIf

   Return lSomethingEdited

METHOD EditItem_B( lAppend ) CLASS TXBrowse

   Local oWorkArea, cTitle, z, nOld, nRow
   Local uOldValue, oEditControl, cMemVar, bReplaceField
   Local aItems, aMemVars, aReplaceFields, aEditControls, l

   If ::lLocked .OR. ::FirstVisibleColumn == 0
      Return .F.
   EndIf

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.

   oWorkArea := ::oWorkArea
   If oWorkArea:Eof()
      If ! lAppend .AND. ! ::AllowAppend
         Return .F.
      Else
         lAppend := .T.
      EndIf
   EndIf

   If lAppend
      cTitle := _OOHG_Messages( 2, 1 )
      nOld := oWorkArea:RecNo()
      oWorkArea:GoTo( 0 )
   Else
      cTitle := if( ValType( ::cRowEditTitle ) $ "CM", ::cRowEditTitle, _OOHG_Messages( 2, 2 ) )
   EndIf

   l := Len( ::aHeaders )
   aItems := ARRAY( l )
   If ::FixControls()
      aEditControls := AClone( ::aEditControls )
   Else
      aEditControls := ARRAY( l )
   EndIf
   aMemVars := ARRAY( l )
   aReplaceFields := ARRAY( l )

   For z := 1 To l
      oEditControl := aEditControls[ z ]
      uOldValue := cMemVar := bReplaceField := Nil
      ::GetCellType( z, @oEditControl, @uOldValue, @cMemVar, @bReplaceField, lAppend )
      aEditControls[ z ] := oEditControl
      If ValType( uOldValue ) $ "CM"
         uOldValue := AllTrim( uOldValue )
      EndIf
      aItems[ z ] := uOldValue
      aMemVars[ z ] := cMemVar
      aReplaceFields[ z ] := bReplaceField
   Next z

   If ::Lock .AND. ! lAppend
      If ! oWorkArea:Lock()
         MsgExclamation( _OOHG_Messages( 3, 9 ), _OOHG_Messages( 3, 10 ) )
         Return .F.
      EndIf
   EndIf

   nRow := ::CurrentRow

   If EMPTY( oWorkArea:cAlias__ )
      aItems := ::EditItem2( nRow, aItems, aEditControls, aMemVars, cTitle )
   Else
      aItems := ( oWorkArea:cAlias__ )->( ::EditItem2( nRow, aItems, aEditControls, aMemVars, cTitle ) )
   EndIf

   If Empty( aItems )
      If lAppend
         ::GoBottom()
         ::lAppendMode := .F.
         oWorkArea:GoTo( nOld )
      EndIf
      ::DoEvent( ::OnAbortEdit, "ABORTEDIT", { nRow, 0 } )
   Else
      _SetThisCellInfo( ::hWnd, nRow, 0, Nil )
      ::DoEvent( ::OnEditCellEnd, "EDITCELLEND", { nRow, 0 } )
      _ClearThisCellInfo()

      If lAppend
         oWorkArea:Append()
      EndIf

      For z := 1 To Len( aItems )
         If ::IsColumnReadOnly( z, nRow )
            // Readonly field
         ElseIf ! ::IsColumnWhen( z, nRow )
            // Not a valid when
         ElseIf aScan( ::aHiddenCols, z ) > 0
           // Hidden column
         Else
            _OOHG_Eval( aReplaceFields[ z ], aItems[ z ], oWorkArea )
         EndIf
      Next z

      If lAppend
         ::lAppendMode := .F.
         _SetThisCellInfo( ::hWnd, nRow, 0, Nil )
         If ! EMPTY( oWorkArea:cAlias__ )
            ( oWorkArea:cAlias__ )->( ::DoEvent( ::OnAppend, "APPEND" ) )
         Else
            ::DoEvent( ::OnAppend, "APPEND" )
         EndIf
         _ClearThisCellInfo()
      EndIf

      If ::RefreshType == REFRESH_NO
         ::RefreshRow( nRow )
      Else
         ::Refresh()
      EndIf

      _SetThisCellInfo( ::hWnd, nRow, 0, Nil )
      ::DoEvent( ::OnEditCell, "EDITCELL", { nRow, 0 } )
      _ClearThisCellInfo()
   EndIf

   If ::Lock
      oWorkArea:Commit()
      oWorkArea:Unlock()
   EndIf

   Return ! Empty( aItems )

METHOD EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, nOnFocusPos, lChange, lAppend ) CLASS TXBrowse

   Local lRet, bReplaceField, oWorkArea, i, aItem, aRepl, aVals, oCtr, uVal, bRep, aNewI, lRet2

   If ::lLocked
      Return .F.
   EndIf
   If ::FirstVisibleColumn == 0
      Return .F.
   EndIf
   If ! HB_IsNumeric( nRow )
      nRow := Max( ::CurrentRow, 1 )
   EndIf
   /*
    * lAppend == .T. means that beforehand an empty row was added to the grid
    * at position nRow, and that ::EditCell must edit it, append a new record
    * and save the data into the data source when the edition is confirmed.
    * When the edition is aborted, the caller must deal with the added row
    * (typicaly it's deleted using method GoBottom).
    */
   oWorkArea := ::oWorkArea
   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   If oWorkArea:EOF() .AND. ! lAppend .AND. ! ::AllowAppend
      Return .F.
   EndIf
   If oWorkArea:EOF()
      lAppend := .T.
   EndIf
   If ! HB_IsNumeric( nCol )
      If ::lAppendMode .OR. lAppend .OR. ::lAtFirstCol
         nCol := ::FirstColInOrder
      Else
         nCol := ::FirstVisibleColumn
      EndIf
   EndIf
   If nRow < 1 .OR. nRow > ::ItemCount .OR. nCol < 1 .OR. nCol > Len( ::aHeaders )
      Return .F.
   EndIf
   If aScan( ::aHiddenCols, nCol ) > 0
      Return .F.
   EndIf

   // to work properly, nRow and the data source record must be synchronized
   Empty( lChange )
   ::SetControlValue( nRow, nCol )                                // Second parameter is needed by TXBrowseByCell:EditCell

   If lAppend
      ::lAppendMode := .T.
      aItem := Array( Len( ::aHeaders ) )
      aVals := Array( Len( ::aHeaders ) )
      aRepl := Array( Len( ::aHeaders ) )
      For i := 1 To nCol - 1
         oCtr := uVal := bRep := Nil
         ::GetCellType( i, @oCtr, @uVal, , @bRep, .T. )
         aItem[ i ] := oCtr:GridValue( uVal )
         aVals[ i ] := uVal
         aRepl[ i ] := bRep
      Next i
      ::GetCellType( nCol, @EditControl, @uOldValue, @cMemVar, @bReplaceField, .T. )
      aItem[ nCol ] := EditControl:GridValue( uOldValue )
      aVals[ nCol ] := uOldValue
      aRepl[ nCol ] := bReplaceField
      For i := nCol + 1 To Len( ::aHeaders )
         oCtr := uVal := bRep := Nil
         ::GetCellType( i, @oCtr, @uVal, , @bRep, .T. )
         aItem[ i ] := oCtr:GridValue( uVal )
         aVals[ i ] := uVal
         aRepl[ i ] := bRep
      Next i
      // Show default values in the edit row
      aNewI := ::Item( nRow )
      For i := 1 to Len( ::aHeaders )
         If ! HB_IsNil( ::aDefaultValues[ i ] )
            aNewI[ i ] := aItem[ i ]
         EndIf
      Next i
      ::Item( nRow, aNewI )
   Else
      If ::Lock .AND. ! oWorkArea:Lock()
         MsgExclamation( _OOHG_Messages( 3, 9 ), _OOHG_Messages( 3, 10 ) )
         Return .F.
      EndIf
      ::GetCellType( nCol, @EditControl, @uOldValue, @cMemVar, @bReplaceField, lAppend )
   EndIf

   If HB_IsBlock( ::OnBeforeEditCell )
      _OOHG_ThisItemCellValue := uOldValue
      lRet2 := ::DoEvent( ::OnBeforeEditCell, "BEFOREEDITCELL", { nRow, nCol } )
      _ClearThisCellInfo()
      If ! HB_IsLogical( lRet2 )
         lRet2 := .T.
      EndIf
   Else
      lRet2 := .T.
   EndIf

   If lRet2
      lRet := ::EditCell2( @nRow, @nCol, @EditControl, uOldValue, @uValue, cMemVar, nOnFocusPos )
   Else
      lRet := .F.
   EndIf

   If lRet
      _SetThisCellInfo( ::hWnd, nRow, nCol, uValue )
      ::DoEvent( ::OnEditCellEnd, "EDITCELLEND", { nRow, nCol } )
      _ClearThisCellInfo()
      If lAppend
         oWorkArea:Append()
         // Set edited and default values into the appended record
         aVals[ nCol ] := uValue
         For i := 1 To Len( ::aHeaders )
            _OOHG_Eval( aRepl[ i ], aVals[ i ], oWorkArea )
         Next i
         ::lAppendMode := .F.
         _SetThisCellInfo( ::hWnd, nRow, nCol, uValue )
         If ! EMPTY( oWorkArea:cAlias__ )
            ( oWorkArea:cAlias__ )->( ::DoEvent( ::OnAppend, "APPEND" ) )
         Else
            ::DoEvent( ::OnAppend, "APPEND" )
         EndIf
         _ClearThisCellInfo()
      Else
         _OOHG_Eval( bReplaceField, uValue, oWorkArea )
      EndIf
      ::RefreshRow( nRow )
      _SetThisCellInfo( ::hWnd, nRow, nCol, uValue )
      ::DoEvent( ::OnEditCell, "EDITCELL", { nRow, nCol } )
      _ClearThisCellInfo()
      If ! ::lCalledFromClass .AND. ::bPosition == 9                  // MOUSE EXIT
         // Edition window lost focus
         ::bPosition := 0                   // This restores the processing of click messages
         If ::nDelayedClick[ 1 ] > 0
            // A click message was delayed
            If ::nDelayedClick[ 3 ] <= 0
               ::MoveTo( ::nDelayedClick[ 1 ], ::nRowPos )
            EndIf

            If HB_IsNil( ::nDelayedClick[ 4 ] )
               If HB_IsBlock( ::OnClick )
                  If ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                     If ! ::NestedClick
                        ::NestedClick := ! _OOHG_NestedSameEvent()
                        ::DoEventMouseCoords( ::OnClick, "CLICK" )
                        ::NestedClick := .F.
                     EndIf
                  EndIf
               EndIf
            Else
               If HB_IsBlock( ::OnRClick )
                  If ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                     ::DoEventMouseCoords( ::OnRClick, "RCLICK" )
                  EndIf
               EndIf
            EndIf

            If ::nDelayedClick[ 3 ] > 0
               // change check mark
               ::CheckItem( ::nDelayedClick[ 3 ], ! ::CheckItem( ::nDelayedClick[ 3 ] ) )
            EndIf

            // fire context menu
            If ! HB_IsNil( ::nDelayedClick[ 4 ] ) .AND. ::ContextMenu != Nil .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0 )
               ::ContextMenu:Cargo := ::nDelayedClick[ 4 ]
               ::ContextMenu:Activate()
            EndIf
         EndIf
      EndIf
   ElseIf lAppend
      ::lAppendMode := .F.
      ::DoEvent( ::OnAbortEdit, "ABORTEDIT", { 0, 0 } )
   Else
      ::DoEvent( ::OnAbortEdit, "ABORTEDIT", { nRow, nCol } )
   EndIf
   If ::Lock
      oWorkArea:Commit()
      oWorkArea:UnLock()
   EndIf

   Return lRet

METHOD EditAllCells( nRow, nCol, lAppend, lOneRow, lChange ) CLASS TXBrowse

   Local lRet, lSomethingEdited

   If ::FullMove
      Return ::EditGrid( nRow, nCol, lAppend, lOneRow, lChange )
   EndIf
   If ::lLocked
      Return .F.
   EndIf
   If ::FirstVisibleColumn == 0
      Return .F.
   EndIf
   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   If ! HB_IsNumeric( nCol )
      If ::lAppendMode .OR. lAppend .OR. ::lAtFirstCol
         nCol := ::FirstColInOrder
      Else
         nCol := ::FirstVisibleColumn
      EndIf
   EndIf
   If nCol < 1 .OR. nCol > Len( ::aHeaders )
      Return .F.
   EndIf

   If lAppend
      If ::lAppendMode
         Return .F.
      EndIf
      ::lAppendMode := .T.
      ::GoBottom( .T. )
      ::InsertBlank( ::ItemCount + 1 )
      ::CurrentRow := ::ItemCount
      ::oWorkArea:GoTo( 0 )
   Else
      If ! HB_IsNumeric( nRow )
         nRow := Max( ::CurrentRow, 1 )
      EndIf
      If nRow < 1 .OR. nRow > ::ItemCount
         Return .F.
      EndIf
      // to work properly, nRow and the data source record must be synchronized
      Empty( lChange)
      ::SetControlValue( nRow )
   EndIf

   ASSIGN lOneRow VALUE lOneRow TYPE "L" DEFAULT .T.

   lSomethingEdited := .F.

   Do While nCol >= 1 .AND. nCol <= Len( ::aHeaders )
      _OOHG_ThisItemCellValue := ::Cell( ::nRowPos, nCol )

      If ::IsColumnReadOnly( nCol, ::nRowPos )
        // Read only column
      ElseIf ! ::IsColumnWhen( nCol, ::nRowPos )
        // Not a valid WHEN
      ElseIf aScan( ::aHiddenCols, nCol ) > 0
        // Hidden column
      Else
         ::lCalledFromClass := .T.
         lRet := ::EditCell( ::nRowPos, nCol, , , , , , , ::lAppendMode )
         ::lCalledFromClass := .F.

         If ::lAppendMode
            ::lAppendMode := .F.
            If lRet
               lSomethingEdited := .T.
            Else
               ::GoBottom()
               Exit
            EndIf
         ElseIf lRet
            lSomethingEdited := .T.
         Else
            Exit
         EndIf

         If ::bPosition == 9                     // MOUSE EXIT
            // Edition window lost focus
            ::bPosition := 0                     // This restores the processing of click messages
            If ::nDelayedClick[ 1 ] > 0
               // A click message was delayed
               If ::nDelayedClick[ 3 ] <= 0
                  ::MoveTo( ::nDelayedClick[ 1 ], ::nRowPos )
               EndIf

               If HB_IsNil( ::nDelayedClick[ 4 ] )
                  If HB_IsBlock( ::OnClick )
                     If ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                        If ! ::NestedClick
                           ::NestedClick := ! _OOHG_NestedSameEvent()
                           ::DoEventMouseCoords( ::OnClick, "CLICK" )
                           ::NestedClick := .F.
                        EndIf
                     EndIf
                  EndIf
               Else
                  If HB_IsBlock( ::OnRClick )
                     If ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                        ::DoEventMouseCoords( ::OnRClick, "RCLICK" )
                     EndIf
                  EndIf
               EndIf

               If ::nDelayedClick[ 3 ] > 0
                  // change check mark
                  ::CheckItem( ::nDelayedClick[ 3 ], ! ::CheckItem( ::nDelayedClick[ 3 ] ) )
               EndIf

               // fire context menu
               If ! HB_IsNil( ::nDelayedClick[ 4 ] ) .AND. ::ContextMenu != Nil .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0 )
                  ::ContextMenu:Cargo := ::nDelayedClick[ 4 ]
                  ::ContextMenu:Activate()
               EndIf
            EndIf
            Exit
         EndIf
      EndIf

      nCol := ::NextColInOrder( nCol )
      If nCol == 0
         If lOneRow
            Exit
         EndIf
         nCol := ::FirstColInOrder
         If nCol == 0
            Exit
         EndIf
         If ! ::Down( .F. )
            If ! lAppend .AND. ! ::AllowAppend
               Exit
            EndIf
            ::lAppendMode := .T.
            ::GoBottom( .T. )
            ::InsertBlank( ::ItemCount + 1 )
            ::CurrentRow := ::ItemCount
            ::oWorkArea:GoTo( 0 )
         EndIf
         ::ScrollToLeft()
      EndIf
   Enddo

   ::ScrollToLeft()

   Return lSomethingEdited

METHOD EditGrid( nRow, nCol, lAppend, lOneRow, lChange ) CLASS TXBrowse

   Local lRet, lSomethingEdited

   If ::lLocked
      Return .F.
   EndIf
   If ::FirstVisibleColumn == 0
      Return .F.
   EndIf
   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   If ! HB_IsNumeric( nCol )
      If ::lAppendMode .OR. lAppend .OR. ::lAtFirstCol
         nCol := ::FirstColInOrder
      Else
         nCol := ::FirstVisibleColumn
      EndIf
   EndIf
   If nCol < 1 .OR. nCol > Len( ::aHeaders )
      Return .F.
   EndIf

   If lAppend
      If ::lAppendMode
         Return .F.
      EndIf
      ::lAppendMode := .T.
      ::GoBottom( .T. )
      ::InsertBlank( ::ItemCount + 1 )
      ::CurrentRow := ::ItemCount
      ::oWorkArea:GoTo( 0 )
   Else
      If ! HB_IsNumeric( nRow )
         nRow := Max( ::CurrentRow, 1 )
      EndIf
      If nRow < 1 .OR. nRow > ::ItemCount
         Return .F.
      EndIf
      // to work properly, nRow and the data source record must be synchronized
      Empty( lChange)
      ::SetControlValue( nRow )
   EndIf

   lSomethingEdited := .F.

   Do While nCol >= 1 .AND. nCol <= Len( ::aHeaders )
      _OOHG_ThisItemCellValue := ::Cell( ::nRowPos, nCol )

      If ::IsColumnReadOnly( nCol, ::nRowPos )
        // Read only column, skip
      ElseIf ! ::IsColumnWhen( nCol, ::nRowPos )
        // Not a valid WHEN, skip
      ElseIf aScan( ::aHiddenCols, nCol ) > 0
        // Hidden column, skip
      Else
         ::lCalledFromClass := .T.
         lRet := ::EditCell( ::nRowPos, nCol, , , , , , , ::lAppendMode )
         ::lCalledFromClass := .F.

         If ::lAppendMode
            ::lAppendMode := .F.
            If lRet
               lSomethingEdited := .T.
            Else
               ::GoBottom()
               Exit
            EndIf
         ElseIf lRet
            lSomethingEdited := .T.
         Else
            Exit
         EndIf

         If ::bPosition == 9                     // MOUSE EXIT
            // Edition window lost focus
            ::bPosition := 0                     // This restores the processing of click messages
            If ::nDelayedClick[ 1 ] > 0
               // A click message was delayed, set the clicked row as new current row
               If ::nDelayedClick[ 3 ] <= 0
                  ::MoveTo( ::nDelayedClick[ 1 ], ::nRowPos )
               EndIf

               If HB_IsNil( ::nDelayedClick[ 4 ] )
                  If HB_IsBlock( ::OnClick )
                     If ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                        If ! ::NestedClick
                           ::NestedClick := ! _OOHG_NestedSameEvent()
                           ::DoEventMouseCoords( ::OnClick, "CLICK" )
                           ::NestedClick := .F.
                        EndIf
                     EndIf
                  EndIf
               Else
                  If HB_IsBlock( ::OnRClick )
                     If ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                        ::DoEventMouseCoords( ::OnRClick, "RCLICK" )
                     EndIf
                  EndIf
               EndIf

               If ::nDelayedClick[ 3 ] > 0
                  // change check mark
                  ::CheckItem( ::nDelayedClick[ 3 ], ! ::CheckItem( ::nDelayedClick[ 3 ] ) )
               EndIf

               // fire context menu
               If ! HB_IsNil( ::nDelayedClick[ 4 ] ) .AND. ::ContextMenu != Nil .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0 )
                  ::ContextMenu:Cargo := ::nDelayedClick[ 4 ]
                  ::ContextMenu:Activate()
               EndIf
            EndIf
            Exit
         EndIf
      EndIf

      nCol := ::NextColInOrder( nCol )
      If nCol == 0
         If HB_IsLogical( lOneRow ) .AND. lOneRow
            Exit
         ElseIf ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove
            Exit
         EndIf
         nCol := ::FirstColInOrder
         If nCol == 0
            Exit
         EndIf
         If ! ::Down( .F. )
            If ! lAppend .AND. ! ::AllowAppend
               Exit
            EndIf
            ::lAppendMode := .T.
            ::GoBottom( .T. )
            ::InsertBlank( ::ItemCount + 1 )
            ::CurrentRow := ::ItemCount
            ::oWorkArea:GoTo( 0 )
         EndIf
         ::ScrollToLeft()
      EndIf
   EndDo

   ::ScrollToLeft()

   Return lSomethingEdited

METHOD GetCellType( nCol, EditControl, uOldValue, cMemVar, bReplaceField, lAppend ) CLASS TXBrowse

   Local cField, cArea, nPos, aStruct

   If ValType( nCol ) != "N"
      nCol := 1
   EndIf
   If nCol < 1 .OR. nCol > Len( ::aHeaders )
      // Cell out of range
      Return .F.
   EndIf

   If ValType( uOldValue ) == "U"
      ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
      If ! lAppend .OR. HB_IsNil( ::aDefaultValues[ nCol ] )
         uOldValue := EVAL( ::ColumnBlock( nCol, .T. ), ::WorkArea )
      ElseIf HB_IsBlock( ::aDefaultValues[ nCol ] )
         uOldValue := EVAL( ::aDefaultValues[ nCol ], nCol )
      Else
         uOldValue := ::aDefaultValues[ nCol ]
      EndIf
   EndIf

   If ValType( ::aReplaceField ) == "A" .AND. Len( ::aReplaceField ) >= nCol
      bReplaceField := ::aReplaceField[ nCol ]
   Else
      bReplaceField := Nil
   EndIf

   // Default cMemVar & bReplaceField
   If ValType( ::aFields[ nCol ] ) $ "CM"
      cField := Upper( AllTrim( ::aFields[ nCol ] ) )
      nPos := At( '->', cField )
      If nPos != 0 .AND. Select( Trim( Left( cField, nPos - 1 ) ) ) != 0
         cArea := Trim( Left( cField, nPos - 1 ) )
         cField := Ltrim( SubStr( cField, nPos + 2 ) )
         aStruct := ( cArea )->( DbStruct() )
         nPos := ( cArea )->( FieldPos( cField ) )
      Else
         cArea := ::oWorkArea:cAlias__
         aStruct := ::oWorkArea:DbStruct()
         nPos := ::oWorkArea:FieldPos( cField )
      EndIf
      If nPos # 0
         If ! ValType( cMemVar ) $ "CM" .OR. Empty( cMemVar )
            cMemVar := "MemVar" + cArea + cField
         EndIf
         If ValType( bReplaceField ) != "B"
            bReplaceField := FieldWBlock( cField, Select( cArea ) )
         EndIf
      EndIf
   Else
      nPos := 0
   EndIf

   // Determines control type
   If ! HB_IsObject( EditControl ) .AND. ::FixControls()
      EditControl := ::aEditControls[ nCol ]
   EndIf
   EditControl := GetEditControlFromArray( EditControl, ::EditControls, nCol, Self )
   If HB_IsObject( EditControl )
      // EditControl specified
   ElseIf ValType( ::Picture[ nCol ] ) $ "CM"
      // Picture-based
      EditControl := TGridControlTextBox():New( ::Picture[ nCol ], , ValType( uOldValue ), , , , Self )
   ElseIf ValType( ::Picture[ nCol ] ) == "L" .AND. ::Picture[ nCol ]
      EditControl := TGridControlImageList():New( Self )
   ElseIf nPos == 0
      EditControl := GridControlObjectByType( uOldValue, Self )
   ElseIf aStruct[ nPos ][ 2 ] == "N"                                         // Use field type
      If aStruct[ nPos ][ 4 ] == 0
         EditControl := TGridControlTextBox():New( Replicate( "9", aStruct[ nPos ][ 3 ] ), , "N", , , , Self )
      Else
         EditControl := TGridControlTextBox():New( Replicate( "9", aStruct[ nPos ][ 3 ] - aStruct[ nPos ][ 4 ] - 1 ) + "." + Replicate( "9", aStruct[ nPos ][ 4 ] ), , "N", , , , Self )
      EndIf
   ElseIf aStruct[ nPos ][ 2 ] == "L"
      // EditControl := TGridControlCheckBox():New( , , , , Self)
      EditControl := TGridControlLComboBox():New( , , , , Self )
   ElseIf aStruct[ nPos ][ 2 ] == "M"
      EditControl := TGridControlMemo():New( , , Self )
   ElseIf aStruct[ nPos ][ 2 ] == "D"
      // EditControl := TGridControlDatePicker():New( .T., , , , Self )
      EditControl := TGridControlTextBox():New( "@D", , "D", , , , Self )
   ElseIf aStruct[ nPos ][ 2 ] == "C"
      EditControl := TGridControlTextBox():New( "@S" + Ltrim( Str( aStruct[ nPos ][ 3 ] ) ), , "C", , , , Self )
   Else
      // Unimplemented field type !!!
      EditControl := GridControlObjectByType( uOldValue, Self )
   EndIf

   Return .T.

METHOD ColumnWidth( nColumn, nWidth ) CLASS TXBrowse

   Local nRet

   nRet := ::Super:ColumnWidth( nColumn, nWidth )
   ::AdjustRightScroll()

   Return nRet

METHOD ColumnAutoFit( nColumn ) CLASS TXBrowse

   Local nRet

   nRet := ::Super:ColumnAutoFit( nColumn )
   ::AdjustRightScroll()

   Return nRet

METHOD ColumnAutoFitH( nColumn ) CLASS TXBrowse

   Local nRet

   nRet := ::Super:ColumnAutoFitH( nColumn )
   ::AdjustRightScroll()

   Return nRet

METHOD ColumnsAutoFit() CLASS TXBrowse

   Local nRet

   nRet := ::Super:ColumnsAutoFit()
   ::AdjustRightScroll()

   Return nRet

METHOD ColumnsAutoFitH() CLASS TXBrowse

   Local nRet

   nRet := ::Super:ColumnsAutoFitH()
   ::AdjustRightScroll()

   Return nRet

METHOD WorkArea( uWorkArea ) CLASS TXBrowse

   If PCOUNT() > 0
      If ValType( uWorkArea ) == "O"
         ::uWorkArea := uWorkArea
         ::oWorkArea := uWorkArea
      ElseIf ValType( uWorkArea ) $ "CM" .AND. ! EMPTY( uWorkArea )
         uWorkArea := ALLTRIM( UPPER( uWorkArea ) )
         ::uWorkArea := uWorkArea
         ::oWorkArea := ooHGRecord():New( uWorkArea )
      Else
         ::uWorkArea := Nil
         ::oWorkArea := Nil
      EndIf
   EndIf

   Return ::uWorkArea

METHOD AddColumn( nColIndex, xField, cHeader, nWidth, nJustify, uForeColor, ;
                  uBackColor, lNoDelete, uPicture, uEditControl, uHeadClick, ;
                  uValid, uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign, ;
                  uReplaceField, lRefresh, uReadOnly, uDefault ) CLASS TXBrowse

   LOCAL nRet, nColumns := Len( ::aHeaders ) + 1

   // Set Default Values
   If ! HB_IsNumeric( nColIndex ) .OR. nColIndex > nColumns
      nColIndex := nColumns
   ElseIf nColIndex < 1
      nColIndex := 1
   EndIf

   aSize( ::aFields, nColumns )
   aIns( ::aFields, nColIndex )
   ::aFields[ nColIndex ] := xField

   // Update before calling ::ColumnBlock
   aSize( ::aDefaultValues, nColumns )
   ::aDefaultValues[ nColIndex ] := uDefault

   If ValType( uEditControl ) != Nil .OR. HB_IsArray( ::EditControls )
      If ! HB_IsArray( ::EditControls )
         ::EditControls := Array( nColumns )
      ElseIf Len( ::EditControls ) < nColumns
         aSize( ::EditControls, nColumns )
      EndIf
      aIns( ::EditControls, nColIndex )
      ::EditControls[ nColIndex ] := uEditControl
      If ::FixControls()
         ::FixControls( .T. )
      EndIf
   EndIf

   // Update after updating ::EditControls
   If ::FixBlocks()
      // Update before calling ::ColumnBlock
      ASize( ::Picture, nColumns )
      AIns( ::Picture, nColIndex )
      ::Picture[ nColIndex ] := Iif( ( ValType( uPicture ) $ "CM" .AND. ! Empty( uPicture ) ) .OR. HB_IsLogical( uPicture ), uPicture, Nil )

      aSize( ::aColumnBlocks, nColumns )
      aIns( ::aColumnBlocks, nColIndex )
      ::aColumnBlocks[ nColIndex ] := ::ColumnBlock( nColIndex )
   EndIf

   If HB_IsArray( ::aReplaceField )
      aSize( ::aReplaceField, nColumns )
      aIns( ::aReplaceField, nColIndex )
   Else
      ::aReplaceField := ARRAY( nColumns )
   EndIf
   ::aReplaceField[ nColIndex ] := uReplaceField

   nRet := ::Super:AddColumn( nColIndex, cHeader, nWidth, nJustify, uForeColor, ;
                              uBackColor, lNoDelete, uPicture, uEditControl, uHeadClick, ;
                              uValid, uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign, ;
                              uReadOnly )
   If nRet # nColIndex
      MsgOOHGError( "XBrowse: Column added in another place. Program terminated." )
   EndIf

   If ! HB_IsLogical( lRefresh ) .OR. lRefresh
      ::Refresh()
   EndIf

   Return nRet

METHOD DeleteColumn( nColIndex, lRefresh ) CLASS TXBrowse

   LOCAL nColumns, nRet

   nColumns := Len( ::aHeaders )
   If nColumns == 0
      Return 0
   EndIf
   If ! HB_IsNumeric( nColIndex ) .OR. nColIndex > nColumns
      nColIndex := nColumns
   ElseIf nColIndex < 1
      nColIndex := 1
   EndIf

   _OOHG_DeleteArrayItem( ::aFields,  nColIndex )
   _OOHG_DeleteArrayItem( ::aColumnBlocks,  nColIndex )
   _OOHG_DeleteArrayItem( ::aReplaceField,  nColIndex )

   nRet := ::Super:DeleteColumn( nColIndex )

   If ! HB_IsLogical( lRefresh ) .OR. lRefresh
      ::Refresh()
   EndIf

   Return nRet

METHOD SetColumn( nColIndex, xField, cHeader, nWidth, nJustify, uForeColor, ;
                  uBackColor, lNoDelete, uPicture, uEditControl, uHeadClick, ;
                  uValid, uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign, ;
                  uReplaceField, lRefresh, uReadOnly ) CLASS TXBrowse

   LOCAL nRet, nColumns := Len( ::aHeaders )

   // Set Default Values
   If ! HB_IsNumeric( nColIndex ) .OR. nColIndex > nColumns
      nColIndex := nColumns
   ElseIf nColIndex < 1
      nColIndex := 1
   EndIf

   ::aFields[ nColIndex ] := xField

   // Update before calling ::ColumnBlock
   If ValType( uEditControl ) != Nil .OR. HB_IsArray( ::EditControls )
      If ! HB_IsArray( ::EditControls )
         ::EditControls := Array( nColumns )
      ElseIf Len( ::EditControls ) < nColumns
         aSize( ::EditControls, nColumns )
      EndIf
      ::EditControls[ nColIndex ] := uEditControl
      If ::FixControls()
         ::FixControls( .T. )
      EndIf
   EndIf

   // Update after updating ::EditControls
   If ::FixBlocks()
      ::aColumnBlocks[ nColIndex ] := ::ColumnBlock( nColIndex )
   EndIf

   If ! HB_IsArray( ::aReplaceField )
      ::aReplaceField := ARRAY( LEN( ::aFields ) )
   EndIf
   ::aReplaceField[ nColIndex ] := uReplaceField

   nRet := ::Super:SetColumn( nColIndex, cHeader, nWidth, nJustify, uForeColor, ;
                              uBackColor, lNoDelete, uPicture, uEditControl, uHeadClick, ;
                              uValid, uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign, ;
                              uReadOnly )

   If ! HB_IsLogical( lRefresh ) .OR. lRefresh
      ::Refresh()
   EndIf

   Return nRet

METHOD VScrollVisible( lState ) CLASS TXBrowse

   If HB_IsLogical( lState ) .AND. lState # ::lVScrollVisible
      If ::lVScrollVisible
         ::VScroll:Visible := .F.
         ::VScroll := Nil
      Else
         ::VScroll := ::VScrollCopy
         ::VScroll:Visible := .T.
      EndIf
      ::lVScrollVisible := lState
      ::ScrollButton:Visible := lState
      ::SizePos()
   EndIf

   Return ::lVScrollVisible


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

   If ::EOF()
      If ::BOF()
         lEmpty := .T.
      Else
         ::Skip( -1 )
         lEmpty := ::BOF()
         ::Skip( 1 )
      EndIf
   Else
      If ::BOF()
         ::GoTop()
         lEmpty := ::EOF()
      Else
        lEmpty := .F.
      EndIf
   EndIf

   Return lEmpty

METHOD FieldAssign( xValue ) CLASS ooHGRecord

   LOCAL nPos, cMessage, uRet, cAlias, lError

   cAlias := ::cAlias__
   cMessage := ALLTRIM( UPPER( __GetMessage() ) )
   lError := .T.
   If PCOUNT() == 0
      nPos := ( cAlias )->( FieldPos( cMessage ) )
      If nPos > 0
         uRet := ( cAlias )->( FieldGet( nPos ) )
         lError := .F.
      EndIf
   ElseIf PCOUNT() == 1
      nPos := ( cAlias )->( FieldPos( SUBSTR( cMessage, 2 ) ) )
      If nPos > 0
         uRet := ( cAlias )->( FieldPut( nPos, xValue ) )
         lError := .F.
      EndIf
   EndIf
   If lError
      uRet := Nil
      ::MsgNotFound( cMessage )
   EndIf

   Return uRet

METHOD New( cAlias ) CLASS ooHGRecord

   If ! ValType( cAlias ) $ "CM" .OR. EMPTY( cAlias )
      ::cAlias__ := ALIAS()
   Else
      ::cAlias__ := UPPER( ALLTRIM( cAlias ) )
   EndIf

   Return Self

METHOD Use( cFile, cAlias, cRDD, lShared, lReadOnly ) CLASS ooHGRecord

   DbUseArea( .T., cRDD, cFile, cAlias, lShared, lReadOnly )
   ::cAlias__ := ALIAS()

   Return Self

METHOD Skipper( nSkip ) CLASS ooHGRecord

   LOCAL nCount

   nCount := 0
   nSkip := If( ValType( nSkip ) == "N", INT( nSkip ), 1 )
   If nSkip == 0
      ::Skip( 0 )
   Else
      DO WHILE nSkip != 0
         If nSkip > 0
            ::Skip( 1 )
            If ::EOF()
               ::Skip( -1 )
               EXIT
            Else
               nCount ++
               nSkip --
            EndIf
         Else
            ::Skip( -1 )
            If ::BOF()
               EXIT
            Else
               nCount --
               nSkip ++
            EndIf
         EndIf
      ENDDO
   EndIf

   Return nCount

METHOD OrdScope( uFrom, uTo ) CLASS ooHGRecord

   If PCOUNT() == 0
      ( ::cAlias )->( ORDSCOPE( 0, Nil ) )
      ( ::cAlias )->( ORDSCOPE( 1, Nil ) )
   ElseIf PCOUNT() == 1
      ( ::cAlias )->( ORDSCOPE( 0, uFrom ) )
      ( ::cAlias )->( ORDSCOPE( 1, uFrom ) )
   Else
      ( ::cAlias )->( ORDSCOPE( 0, uFrom ) )
      ( ::cAlias )->( ORDSCOPE( 1, uTo ) )
   EndIf

   Return Self

METHOD Filter( cFilter ) CLASS ooHGRecord

   If EMPTY( cFilter )
      ( ::cAlias__ )->( DbClearFilter() )
   Else
      ( ::cAlias__ )->( DbSetFilter( { || &( cFilter ) } , cFilter ) )
   EndIf

   Return Self


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
   If     HB_IsBlock( xSource )
      ::bRecordId := xSource
   ElseIf HB_IsObject( xSource ) .OR. HB_IsString( xSource )
      ::xArea := xSource
   EndIf
   If PCOUNT() >= 2
      ::xDefault := xDefault
   EndIf

   Return Self

METHOD Value( xValue ) CLASS TVirtualField

   LOCAL xRecordId

   xRecordId := ::RecordId()
   If     PCOUNT() >= 1
      ::hValues[ xRecordId ] := xValue
   ElseIf ! xRecordId $ ::hValues
      If HB_IsBlock( ::xDefault )
         ::hValues[ xRecordId ] := EVAL( ::xDefault )
      Else
         ::hValues[ xRecordId ] := ::xDefault
      EndIf
   EndIf

   Return ::hValues[ xRecordId ]

METHOD RecordId() CLASS TVirtualField

   LOCAL xId

   If     HB_IsBlock( ::bRecordId )
      xId := EVAL( ::bRecordId )
   ElseIf HB_IsObject( ::xArea )
      xId := ::xArea:RecNo()
   ElseIf HB_IsString( ::xArea )
      xId := ( ::xArea )->( RecNo() )
   Else
      xId := RecNo()
   EndIf

   Return xId


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
   METHOD Events
   METHOD Events_Notify
   METHOD GoBottom
   METHOD GoTop
   METHOD Left
   METHOD MoveTo
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

   /* HB_SYMBOL_UNUSED( _OOHG_AllVars ) */

   ENDCLASS

METHOD Define3( aValue ) CLASS TXBrowseByCell

   Local lLocked

   If ! HB_IsArray( aValue ) .OR. ;
      Len( aValue ) < 2 .OR. ;
      ! HB_IsNumeric( aValue[ 1 ] ) .OR. ! HB_IsNumeric( aValue[ 2 ] ) .OR.  ;
      aValue[ 1 ] < 1 .OR. aValue[ 1 ] > ::CountPerPage .OR. ;
      aValue[ 2 ] < 1 .OR. aValue[ 2 ] > Len( ::aFields )
      aValue := {1, 1}
   EndIf
   ASSIGN lLocked VALUE ::lLocked TYPE "L" DEFAULT .F.
   ::lLocked := .F.
   ::Refresh()
   ::Value := aValue
   ::lLocked := lLocked

   Return Self

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
                lNoShowAlways, lNone, lCBE, lAtFirst ) CLASS TXBrowseByCell

   Empty( nStyle )
   ASSIGN lFocusRect VALUE lFocusRect TYPE "L" DEFAULT .F.
   Empty( lNone )
   Empty( lCBE )

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
                    lNoShowAlways, .F., .T., lAtFirst )

   // By default, search in the current column
   ::SearchCol := -1

   Return Self

METHOD AddColumn( nColIndex, xField, cHeader, nWidth, nJustify, uForeColor, ;
                  uBackColor, lNoDelete, uPicture, uEditControl, uHeadClick, ;
                  uValid, uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign, ;
                  uReplaceField, lRefresh, uReadOnly, uDefault ) CLASS TXBrowseByCell

   nColIndex := ::Super:AddColumn( nColIndex, xField, cHeader, nWidth, nJustify, uForeColor, ;
                                   uBackColor, lNoDelete, uPicture, uEditControl, uHeadClick, ;
                                   uValid, uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign, ;
                                   uReplaceField, lRefresh, uReadOnly, uDefault )

   If nColIndex <= ::nColPos
      ::CurrentCol := ::nColPos + 1
      ::DoChange()
   EndIf

   Return nColIndex

METHOD DeleteColumn( nColIndex, lNoDelete ) CLASS TXBrowseByCell

   nColIndex := ::Super:DeleteColumn( nColIndex, lNoDelete )
   If nColIndex > 0
      If nColIndex == ::nColPos
         ::CurrentCol := ::FirstColInOrder
         ::DoChange()
      ElseIf nColIndex < ::nColPos
         ::CurrentCol := ::nColPos - 1
         ::DoChange()
      EndIf
   EndIf

   Return nColIndex

METHOD EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, nOnFocusPos, lChange, lAppend ) CLASS TXBrowseByCell

   Local lRet, lBefore

   If ! HB_IsNumeric( nCol )
      If ::nColPos >= 1
         nCol := ::nColPos
      Else
         nCol := ::FirstColInOrder
      EndIf
   EndIf

   // ::Value change is done in ::Super:EditCell, after aditional validations
   Empty( lChange )

   lBefore := ::lCalledFromClass
   ::lCalledFromClass := .T.
   lRet := ::Super:EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, nOnFocusPos, .T., lAppend )
   ::lCalledFromClass := lBefore

   If lRet
      // ::bPosition is set by TGridControl()
      If ::bPosition == 1                                         // UP
         ::Up()
      ElseIf ::bPosition == 2                                     // RIGHT
         ::Right( .F. )
      ElseIf ::bPosition == 3                                     // LEFT
         ::Left()
      ElseIf ::bPosition == 4                                     // HOME
         ::GoTop()
      ElseIf ::bPosition == 5                                     // END
         ::GoBottom( .F. )
      ElseIf ::bPosition == 6                                     // DOWN
         ::Down( .F. )
      ElseIf ::bPosition == 7                                     // PRIOR
         ::PageUp()
      ElseIf ::bPosition == 8                                     // NEXT
         ::PageDown( .F. )
      ElseIf ! ::lCalledFromClass .AND. ::bPosition == 9          // MOUSE EXIT
         // Edition window lost focus
         ::bPosition := 0                   // This restores the processing of click messages
         If ::nDelayedClick[ 1 ] > 0
            // A click message was delayed
            If ::nDelayedClick[ 3 ] <= 0
               ::MoveTo( { ::nDelayedClick[ 1 ], ::nDelayedClick[ 2 ] }, { ::nRowPos, ::nColPos } )
            EndIf

            If HB_IsNil( ::nDelayedClick[ 4 ] )
               If HB_IsBlock( ::OnClick )
                  If ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                     If ! ::NestedClick
                        ::NestedClick := ! _OOHG_NestedSameEvent()
                        ::DoEventMouseCoords( ::OnClick, "CLICK" )
                        ::NestedClick := .F.
                     EndIf
                  EndIf
               EndIf
            Else
               If HB_IsBlock( ::OnRClick )
                  If ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                     ::DoEventMouseCoords( ::OnRClick, "RCLICK" )
                  EndIf
               EndIf
            EndIf

            If ::nDelayedClick[ 3 ] > 0
               // change check mark
               ::CheckItem( ::nDelayedClick[ 3 ], ! ::CheckItem( ::nDelayedClick[ 3 ] ) )
            EndIf

            // fire context menu
            If ! HB_IsNil( ::nDelayedClick[ 4 ] ) .AND. ::ContextMenu != Nil .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0 )
               ::ContextMenu:Cargo := ::nDelayedClick[ 4 ]
               ::ContextMenu:Activate()
            EndIf
         EndIf
      EndIf
   EndIf

   Return lRet

METHOD EditGrid( nRow, nCol, lAppend, lOneRow, lChange ) CLASS TXBrowseByCell

   Local lRet, lSomethingEdited

   If ::lLocked
      Return .F.
   EndIf
   If ::FirstVisibleColumn == 0
      Return .F.
   EndIf
   If ! HB_IsNumeric( nCol )
      If ::nColPos >= 1
         nCol := ::nColPos
      Else
         nCol := ::FirstColInOrder
      EndIf
   EndIf
   If nCol < 1 .OR. nCol > Len( ::aHeaders )
      Return .F.
   EndIf

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.

   If lAppend
      If ::lAppendMode
         Return .F.
      EndIf
      ::lAppendMode := .T.
      ::GoBottom( .T. )
      ::InsertBlank( ::ItemCount + 1 )
      ::CurrentRow := ::ItemCount
      ::CurrentCol := nCol
      ::oWorkArea:GoTo( 0 )
   Else
      If ! HB_IsNumeric( nRow )
         nRow := Max( ::CurrentRow, 1 )
      EndIf
      If nRow < 1 .OR. nRow > ::ItemCount
         Return .F.
      EndIf
      // to work properly, nRow and the data source record must be synchronized
      Empty( lChange)
      ::SetControlValue( nRow, nCol )
   EndIf

   lSomethingEdited := .F.

   Do While ::nRowPos >= 1 .AND. ::nRowPos <= ::ItemCount .AND. ::nColPos >= 1 .AND. ::nColPos <= Len( ::aHeaders )
      _OOHG_ThisItemCellValue := ::Cell( ::nRowPos, ::nColPos )

      If ::IsColumnReadOnly( ::nColPos, ::nRowPos )
         // Read only column
      ElseIf ! ::IsColumnWhen( ::nColPos, ::nRowPos )
         // Not a valid WHEN
      ElseIf aScan( ::aHiddenCols, ::nColPos ) > 0
         // Hidden column
      Else
         ::lCalledFromClass := .T.
         lRet := ::Super:EditCell( ::nRowPos, ::nColPos, , , , , , .F., ::lAppendMode )
         ::lCalledFromClass := .F.

         If ::lAppendMode
            ::lAppendMode := .F.
            If lRet
               lSomethingEdited := .T.
            Else
               ::GoBottom()
               Exit
            EndIf
         ElseIf lRet
            lSomethingEdited := .T.
         Else
            Exit
         EndIf
      EndIf

      // ::bPosition is set by TGridControl()
      If ::bPosition == 1                            // UP
         If HB_IsLogical( lOneRow ) .AND. lOneRow
            Exit
         ElseIf ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove
            Exit
         EndIf
         ::Up()
      ElseIf ::bPosition == 2                        // RIGHT
         If ::nColPos # ::LastColInOrder
            ::Right( .F. )
         ElseIf HB_IsLogical( lOneRow ) .AND. lOneRow
            Exit
         ElseIf ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove
            Exit
         Else
            ::Right( .F. )
            ::lAppendMode := ::Eof() .AND. ( lAppend .OR. ::AllowAppend )
         EndIf
      ElseIf ::bPosition == 3                        // LEFT
         If ::nColPos # ::FirstColInOrder
            ::Left()
         ElseIf HB_IsLogical( lOneRow ) .AND. lOneRow
            Exit
         ElseIf ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove
            Exit
         Else
            ::Left()
         EndIf
      ElseIf ::bPosition == 4                        // HOME
         If HB_IsLogical( lOneRow ) .AND. lOneRow
            Exit
         ElseIf ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove
            Exit
         EndIf
         ::GoTop()
      ElseIf ::bPosition == 5                        // END
         If HB_IsLogical( lOneRow ) .AND. lOneRow
            Exit
         ElseIf ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove
            Exit
         EndIf
         ::GoBottom( .F. )
      ElseIf ::bPosition == 6                        // DOWN
         If HB_IsLogical( lOneRow ) .AND. lOneRow
            Exit
         EndIf
         ::Down( .F. )
         If ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove
            Exit
         EndIf
         ::lAppendMode := ::Eof() .AND. ( lAppend .OR. ::AllowAppend )
      ElseIf ::bPosition == 7                        // PRIOR
         If HB_IsLogical( lOneRow ) .AND. lOneRow
            Exit
         ElseIf ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove
            Exit
         EndIf
         ::PageUp()
      ElseIf ::bPosition == 8                        // NEXT
         If HB_IsLogical( lOneRow ) .AND. lOneRow
            Exit
         ElseIf ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove
            Exit
         EndIf
         ::PageDown( .F. )
         ::lAppendMode := ::Eof() .AND. ( lAppend .OR. ::AllowAppend )
      ElseIf ::bPosition == 9                        // MOUSE EXIT
         // Edition window lost focus
         ::bPosition := 0                   // This restores the processing of click messages
         If ::nDelayedClick[ 1 ] > 0
            // A click message was delayed
            If ::nDelayedClick[ 3 ] <= 0
               ::MoveTo( { ::nDelayedClick[ 1 ], ::nDelayedClick[ 2 ] }, { ::nRowPos, ::nColPos } )
            EndIf

            If HB_IsNil( ::nDelayedClick[ 4 ] )
               If HB_IsBlock( ::OnClick )
                  If ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                     If ! ::NestedClick
                        ::NestedClick := ! _OOHG_NestedSameEvent()
                        ::DoEventMouseCoords( ::OnClick, "CLICK" )
                        ::NestedClick := .F.
                     EndIf
                  EndIf
               EndIf
            Else
               If HB_IsBlock( ::OnRClick )
                  If ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                     ::DoEventMouseCoords( ::OnRClick, "RCLICK" )
                  EndIf
               EndIf
            EndIf

            If ::nDelayedClick[ 3 ] > 0
               // change check mark
               ::CheckItem( ::nDelayedClick[ 3 ], ! ::CheckItem( ::nDelayedClick[ 3 ] ) )
            EndIf

            // fire context menu
            If ! HB_IsNil( ::nDelayedClick[ 4 ] ) .AND. ::ContextMenu != Nil .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0 )
               ::ContextMenu:Cargo := ::nDelayedClick[ 4 ]
               ::ContextMenu:Activate()
            EndIf
         EndIf
         Exit
      Else                                           // OK
         If ::nColPos # ::LastColInOrder
            ::Right( .F. )
         ElseIf HB_IsLogical( lOneRow ) .AND. lOneRow
            Exit
         ElseIf ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove
            Exit
         Else
            ::Right( .F. )
            ::lAppendMode := ::Eof() .AND. ( lAppend .OR. ::AllowAppend )
         EndIf
      EndIf

      If ::lAppendMode
         // Insert new row
         ::GoBottom( .T. )
         ::InsertBlank( ::ItemCount + 1 )
         ::CurrentRow := ::ItemCount
         ::CurrentCol := ::FirstColInOrder
         ::oWorkArea:GoTo( 0 )
      EndIf
   EndDo

   Return lSomethingEdited

METHOD EditAllCells( nRow, nCol, lAppend, lOneRow, lChange ) CLASS TXBrowseByCell

   Local lRet, lSomethingEdited

   If ::FullMove
      Return ::EditGrid( nRow, nCol, lAppend, lOneRow, lChange )
   EndIf
   If ::lLocked
      Return .F.
   EndIf
   If ::FirstVisibleColumn == 0
      Return .F.
   EndIf
   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   If ! HB_IsNumeric( nCol )
      If ::lAppendMode .OR. lAppend .OR. ::lAtFirstCol
         nCol := ::FirstColInOrder
      Else
         nCol := ::FirstVisibleColumn
      EndIf
   EndIf
   If nCol < 1 .OR. nCol > Len( ::aHeaders )
      Return .F.
   EndIf

   If lAppend
      If ::lAppendMode
         Return .F.
      EndIf
      ::lAppendMode := .T.
      ::GoBottom( .T. )
      ::InsertBlank( ::ItemCount + 1 )
      ::CurrentRow := ::ItemCount
      ::CurrentCol := nCol
      ::oWorkArea:GoTo( 0 )
   Else
      If ! HB_IsNumeric( nRow )
         nRow := Max( ::CurrentRow, 1 )
      EndIf
      If nRow < 1 .OR. nRow > ::ItemCount
         Return .F.
      EndIf
      // to work properly, nRow and the data source record must be synchronized
      Empty( lChange)
      ::SetControlValue( nRow, nCol )
   EndIf

   ASSIGN lOneRow VALUE lOneRow TYPE "L" DEFAULT .T.

   lSomethingEdited := .F.

   Do While ::nRowPos >= 1 .AND. ::nRowPos <= ::ItemCount .AND. ::nColPos >= 1 .AND. ::nColPos <= Len( ::aHeaders )
      _OOHG_ThisItemCellValue := ::Cell( ::nRowPos, ::nColPos )

      If ::IsColumnReadOnly( ::nColPos, ::nRowPos )
        // Read only column
      ElseIf ! ::IsColumnWhen( ::nColPos, ::nRowPos )
        // Not a valid WHEN
      ElseIf aScan( ::aHiddenCols, ::nColPos ) > 0
        // Hidden column
      Else
         ::lCalledFromClass := .T.
         lRet := ::Super:EditCell( ::nRowPos, ::nColPos, , , , , , .F., ::lAppendMode )
         ::lCalledFromClass := .F.

         If ::lAppendMode
            ::lAppendMode := .F.
            If lRet
               lSomethingEdited := .T.
            Else
               ::GoBottom()
               Exit
            EndIf
         ElseIf lRet
            lSomethingEdited := .T.
         Else
            Exit
         EndIf
      EndIf

      // ::bPosition is set by TGridControl()
      If ::bPosition == 1                            // UP
         If lOneRow
            Exit
         EndIf
         ::Up()
      ElseIf ::bPosition == 2                        // RIGHT
         If ::nColPos # ::LastColInOrder
            ::Right( .F. )
         ElseIf lOneRow
            Exit
         Else
            ::Right( .F. )
            ::lAppendMode := ::Eof() .AND. ( lAppend .OR. ::AllowAppend )
         EndIf
      ElseIf ::bPosition == 3                        // LEFT
         If ::nColPos # ::FirstColInOrder
            ::Left()
         ElseIf lOneRow
            Exit
         Else
            ::Left()
         EndIf
      ElseIf ::bPosition == 4                        // HOME
         If lOneRow
            Exit
         EndIf
         ::GoTop()
      ElseIf ::bPosition == 5                        // END
         If lOneRow
            Exit
         EndIf
         ::GoBottom( .F. )
      ElseIf ::bPosition == 6                        // DOWN
         If lOneRow
            Exit
         EndIf
         ::Down( .F. )
         ::lAppendMode := ::Eof() .AND. ( lAppend .OR. ::AllowAppend )
      ElseIf ::bPosition == 7                        // PRIOR
         If lOneRow
            Exit
         EndIf
         ::PageUp()
      ElseIf ::bPosition == 8                        // NEXT
         If lOneRow
            Exit
         EndIf
         ::PageDown( .F. )
         ::lAppendMode := ::Eof() .AND. ( lAppend .OR. ::AllowAppend )
      ElseIf ::bPosition == 9                        // MOUSE EXIT
         // Edition window lost focus
         ::bPosition := 0                   // This restores the processing of click messages
         If ::nDelayedClick[ 1 ] > 0
            // A click message was delayed
            If ::nDelayedClick[ 3 ] <= 0
               ::MoveTo( { ::nDelayedClick[ 1 ], ::nDelayedClick[ 2 ] }, { ::nRowPos, ::nColPos } )
            EndIf

            If HB_IsNil( ::nDelayedClick[ 4 ] )
               If HB_IsBlock( ::OnClick )
                  If ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                     If ! ::NestedClick
                        ::NestedClick := ! _OOHG_NestedSameEvent()
                        ::DoEventMouseCoords( ::OnClick, "CLICK" )
                        ::NestedClick := .F.
                     EndIf
                  EndIf
               EndIf
            Else
               If HB_IsBlock( ::OnRClick )
                  If ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                     ::DoEventMouseCoords( ::OnRClick, "RCLICK" )
                  EndIf
               EndIf
            EndIf

            If ::nDelayedClick[ 3 ] > 0
               // change check mark
               ::CheckItem( ::nDelayedClick[ 3 ], ! ::CheckItem( ::nDelayedClick[ 3 ] ) )
            EndIf

            // fire context menu
            If ! HB_IsNil( ::nDelayedClick[ 4 ] ) .AND. ::ContextMenu != Nil .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0 )
               ::ContextMenu:Cargo := ::nDelayedClick[ 4 ]
               ::ContextMenu:Activate()
            EndIf
         EndIf
         Exit
      Else                                           // OK
         If ::nColPos # ::LastColInOrder
            ::Right( .F. )
         ElseIf lOneRow
            Exit
         Else
            ::Right( .F. )
            ::lAppendMode := ::Eof() .AND. ( lAppend .OR. ::AllowAppend )
         EndIf
      EndIf

      If ::lAppendMode
         // Insert new row
         ::GoBottom( .T. )
         ::InsertBlank( ::ItemCount + 1 )
         ::CurrentRow := ::ItemCount
         ::CurrentCol := ::FirstColInOrder
         ::oWorkArea:GoTo( 0 )
         ::ScrollToLeft()
      EndIf
   EndDo

   Return lSomethingEdited

METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TXBrowseByCell

   Local aCellData, cWorkArea, uGridValue, nSearchCol, nRow, nCol, aPos

   If nMsg == WM_CHAR
      _OOHG_ThisItemCellValue := ::Cell( nRow := ::CurrentRow, ( nCol := ::CurrentCol ) )

      If ( ! ::lLocked .AND. ::AllowEdit .AND. ( ::lLikeExcel .OR. EditControlLikeExcel( Self, nCol ) ) .AND. ;
           ! ::IsColumnReadOnly( nCol, nRow ) .AND. ::IsColumnWhen( nCol, nRow ) .AND. aScan( ::aHiddenCols, nCol ) == 0 )
         ::EditCell( , , , Chr( wParam ), , , , , .F. )

      Else
         If wParam < 32
            ::cText := ""
            Return 0
         ElseIf Empty( ::cText )
            ::uIniTime := HB_MilliSeconds()
            ::cText := Upper( Chr( wParam ) )
         ElseIf HB_MilliSeconds() > ::uIniTime + ::SearchLapse
            ::uIniTime := HB_MilliSeconds()
            ::cText := Upper( Chr( wParam ) )
         Else
            ::uIniTime := HB_MilliSeconds()
            ::cText += Upper( Chr( wParam ) )
         EndIf

         If ::SearchCol <= 0
            // Current column
            nSearchCol := nCol
            If nSearchCol < 1 .OR. nSearchCol > ::ColumnCount .OR. aScan( ::aHiddenCols, nSearchCol ) # 0
               Return 0
            EndIf
         ElseIf ::SearchCol > ::ColumnCount
            Return 0
         ElseIf aScan( ::aHiddenCols, ::SearchCol ) # 0
            Return 0
         Else
            nSearchCol := ::SearchCol
         EndIf

         cWorkArea := ::WorkArea
         If ValType( cWorkArea ) $ "CM" .AND. ( Empty( cWorkArea ) .OR. Select( cWorkArea ) == 0 )
            cWorkArea := Nil
         EndIf

         ::DbSkip()

         Do While ! ::Eof()
            If ::FixBlocks()
               uGridValue := Eval( ::aColumnBlocks[ nSearchCol ], cWorkArea )
            Else
               uGridValue := Eval( ::ColumnBlock( nSearchCol ), cWorkArea )
            EndIf
            If ValType( uGridValue ) == "A"      // TGridControlImageData
               uGridValue := uGridValue[ 1 ]
            EndIf

            If Upper( Left( uGridValue, Len( ::cText ) ) ) == ::cText
               Exit
            EndIf

            ::DbSkip()
         EndDo

         If ::Eof() .AND. ::SearchWrap
            ::TopBottom( GO_TOP )

            Do While ! ::Eof()
               If ::FixBlocks()
                  uGridValue := Eval( ::aColumnBlocks[ nSearchCol ], cWorkArea )
               Else
                  uGridValue := Eval( ::ColumnBlock( nSearchCol ), cWorkArea )
               EndIf
               If ValType( uGridValue ) == "A"      // TGridControlImageData
                  uGridValue := uGridValue[ 1 ]
               EndIf

               If Upper( Left( uGridValue, Len( ::cText ) ) ) == ::cText
                  Exit
               EndIf

               ::DbSkip()
            EndDo
         EndIf

         If ::Eof()
            ::TopBottom( GO_BOTTOM )
            ::Refresh( { ::CountPerPage, nCol } )
         Else
            ::Refresh( { ::CountPerPage, nCol } )
         EndIf
         ::DoChange()

      EndIf
      Return 0

   ElseIf nMsg == WM_KEYDOWN
      Do Case
      Case ::FirstVisibleColumn == 0
      Case wParam == VK_HOME
         ::GoTop()
         Return 0
      Case wParam == VK_END
         ::GoBottom()
         Return 0
      Case wParam == VK_PRIOR
         ::PageUp()
         Return 0
      Case wParam == VK_NEXT
         ::PageDown()
         Return 0
      Case wParam == VK_UP
         If GetKeyFlagState() == MOD_CONTROL
            If ! ::lLocked
               ::TopBottom( GO_TOP )
               ::Refresh( { 1, ::CurrentCol } )
               ::DoChange()
            EndIf
         Else
            ::Up()
         EndIf
         Return 0
      Case wParam == VK_DOWN
         If GetKeyFlagState() == MOD_CONTROL
            If ! ::lLocked
               ::TopBottom( GO_BOTTOM )
               ::Refresh( { ::CountPerPage, ::CurrentCol } )
               ::DoChange()
            EndIf
         Else
            ::Down()
         EndIf
         Return 0
      Case wParam == VK_LEFT
         If GetKeyFlagState() == MOD_CONTROL
            nCol := ::FirstColInOrder
            If nCol # 0
               ::CurrentCol := nCol
               ::DoChange()
            EndIf
         Else
            ::Left()
         EndIf
         Return 0
      Case wParam == VK_RIGHT
         If GetKeyFlagState() == MOD_CONTROL
            nCol := ::LastColInOrder
            If nCol # 0
               ::CurrentCol := nCol
               ::DoChange()
            EndIf
         Else
            ::Right()
         EndIf
         Return 0
      EndCase

   ElseIf nMsg == WM_LBUTTONDBLCLK
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

      If ! ::AllowEdit .OR. _OOHG_ThisItemRowIndex < 1 .OR. _OOHG_ThisItemRowIndex > ::ItemCount .OR. _OOHG_ThisItemColIndex < 1 .OR. _OOHG_ThisItemColIndex > Len( ::aHeaders )
         If HB_IsBlock( ::OnDblClick )
            ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
         EndIf
      ElseIf ::IsColumnReadOnly( _OOHG_ThisItemColIndex, _OOHG_ThisItemRowIndex )
         // Cell is readonly
         If ::lExtendDblClick .and. HB_IsBlock( ::OnDblClick )
            ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
         EndIf
      ElseIf ! ::IsColumnWhen( _OOHG_ThisItemColIndex, _OOHG_ThisItemRowIndex )
         // Not a valid WHEN
         If ::lExtendDblClick .and. HB_IsBlock( ::OnDblClick )
            ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
         EndIf
      ElseIf aScan( ::aHiddenCols, _OOHG_ThisItemColIndex ) > 0
         // Cell is in a hidden column
         If ::lExtendDblClick .and. HB_IsBlock( ::OnDblClick )
            ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
         EndIf
      ElseIf ::FullMove
         ::EditGrid( _OOHG_ThisItemRowIndex, _OOHG_ThisItemColIndex )
      Else
         ::EditCell( _OOHG_ThisItemRowIndex, _OOHG_ThisItemColIndex, , , , , , , .F. )

      EndIf

      _ClearThisCellInfo()
      _PopEventInfo()
      Return 0

   ElseIf nMsg == WM_MOUSEWHEEL
      If GET_WHEEL_DELTA_WPARAM( wParam ) > 0
         ::Up()
      Else
         ::Down()
      EndIf
      Return 0

   EndIf

   Return ::Super:Events( hWnd, nMsg, wParam, lParam )

METHOD MoveTo( nTo, nFrom ) CLASS TXBrowseByCell

   Local lMoved

   If ! ::lLocked .AND. ! ( ::lNoShowEmptyRow .AND. ::oWorkArea:IsTableEmpty() )
      If ! HB_IsArray( nTo ) .OR. Len( nTo ) < 2 .OR. ! HB_IsNumeric( nTo[ 1 ] ) .OR. ! HB_IsNumeric( nTo[ 2 ] )
         nTo := { ::nRowPos, ::nColPos }
      EndIf
      If ! HB_IsArray( nFrom ) .OR. Len( nFrom ) < 2 .OR. ! HB_IsNumeric( nFrom[ 1 ] ) .OR. ! HB_IsNumeric( nFrom[ 2 ] )
         nFrom := { ::nRowPos, ::nColPos }
      EndIf
      nFrom[ 1 ] := Max( Min( nFrom[ 1 ], ::ItemCount ), 1 )
      nTo[ 1 ]   := Max( Min( nTo[ 1 ],   ::CountPerPage ), 1 )
      nFrom[ 2 ] := Max( Min( nFrom[ 2 ], Len( ::aHeaders ) ), 1 )
      nTo[ 2 ]   := Max( Min( nTo[ 2 ],   Len( ::aHeaders ) ), 1 )
      lMoved     := ( nTo[ 1 ] # nFrom[ 1 ] .OR. nTo[ 2 ] # nFrom[ 2 ] )
      ::RefreshRow( nFrom[ 1 ] )
      Do While nFrom[ 1 ] != nTo[ 1 ]
         If nFrom[ 1 ] > nTo[ 1 ]
            If ::DbSkip( -1 ) != 0
               nFrom[ 1 ] --
               ::RefreshRow( nFrom[ 1 ] )
            Else
               Exit
            EndIf
         Else
            If ::DbSkip( 1 ) != 0
               nFrom[ 1 ] ++
               ::RefreshRow( nFrom[ 1 ] )
            Else
               Exit
            EndIf
         EndIf
      EndDo
      ::CurrentRow := nTo[ 1 ]
      ::CurrentCol := nTo[ 2 ]
      If lMoved
         ::DoChange()
      EndIf
   EndIf

   Return Self

METHOD Events_Notify( wParam, lParam ) CLASS TXBrowseByCell

   Local nNotify := GetNotifyCode( lParam ), aCellData, nvKey, lGo, uValue

   If nNotify == NM_CLICK
      If ::lCheckBoxes
         // detect item
         uValue := ListView_HitOnCheckBox( ::hWnd, GetCursorRow() - GetWindowRow( ::hWnd ), GetCursorCol() - GetWindowCol( ::hWnd ) )
      Else
         uValue := 0
      EndIf

      If ::bPosition == -2 .OR. ::bPosition == 9
         aCellData := _GetGridCellData( Self, ListView_ItemActivate( lParam ) )
         ::nDelayedClick := { aCellData[ 1 ], aCellData[ 2 ], uValue, Nil }
         If ::nRowPos > 0
            ListView_SetCursel( ::hWnd, ::nRowPos )
         Else
            ListView_ClearCursel( ::hWnd )
         EndIf
      Else
         If HB_IsBlock( ::OnClick )
            If ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. uValue <= 0
               If ! ::NestedClick
                  ::NestedClick := ! _OOHG_NestedSameEvent()
                  ::DoEventMouseCoords( ::OnClick, "CLICK" )
                  ::NestedClick := .F.
               EndIf
            EndIf
         EndIf

         If uValue > 0
            // change check mark
            ::CheckItem( uValue, ! ::CheckItem( uValue ) )
         Else
            // select item
            If ! ::lLocked .AND. ::FirstVisibleColumn # 0
               aCellData := _GetGridCellData( Self, ListView_ItemActivate( lParam ) )
               ::MoveTo( { aCellData[ 1 ], aCellData[ 2 ] }, { ::nRowPos, ::nColPos } )
            Else
               ::CurrentRow := ::nRowPos
               ::CurrentCol := ::nColPos
            EndIf
         EndIf
      EndIf

      // Skip default action
      Return 1

   ElseIf nNotify == NM_RCLICK
      If ::lCheckBoxes
         // detect item
         uValue := ListView_HitOnCheckBox( ::hWnd, GetCursorRow() - GetWindowRow( ::hWnd ), GetCursorCol() - GetWindowCol( ::hWnd ) )
      Else
         uValue := 0
      EndIf

      If ::bPosition == -2 .OR. ::bPosition == 9
         aCellData := _GetGridCellData( Self, ListView_ItemActivate( lParam ) )
         ::nDelayedClick := { aCellData[ 1 ], aCellData[ 2 ], uValue, aCellData }
         If ::nRowPos > 0
            ListView_SetCursel( ::hWnd, ::nRowPos )
         Else
            ListView_ClearCursel( ::hWnd )
         EndIf
      Else
         If HB_IsBlock( ::OnRClick )
            If ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. uValue <= 0
               ::DoEventMouseCoords( ::OnRClick, "RCLICK" )
            EndIf
         EndIf

         If uValue > 0
            // change check mark
            ::CheckItem( uValue, ! ::CheckItem( uValue ) )
         Else
            // select item
            If ! ::lLocked .AND. ::FirstVisibleColumn # 0
               aCellData := _GetGridCellData( Self, ListView_ItemActivate( lParam ) )
               ::MoveTo( { aCellData[ 1 ], aCellData[ 2 ] }, { ::nRowPos, ::nColPos } )
            Else
               ::CurrentRow := ::nRowPos
               ::CurrentCol := ::nColPos
            EndIf
         EndIf

         // Fire context menu
         If ::ContextMenu != Nil .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. uValue <= 0 )
            ::ContextMenu:Cargo := _GetGridCellData( Self, ListView_ItemActivate( lParam ) )
            ::ContextMenu:Activate()
         EndIf
      EndIf

      // Skip default action
      Return 1

   ElseIf nNotify == LVN_BEGINDRAG
      If ::bPosition == -2 .OR. ::bPosition == 9
         aCellData := _GetGridCellData( Self, ListView_ListView( lParam ) )
         ::nDelayedClick := { aCellData[ 1 ], aCellData[ 2 ], uValue, Nil }
         If ::nRowPos > 0
            ListView_SetCursel( ::hWnd, ::nRowPos )
         Else
            ListView_ClearCursel( ::hWnd )
         EndIf
      Else
         If ! ::lLocked .AND. ::FirstVisibleColumn # 0
            aCellData := _GetGridCellData( Self, ListView_ListView( lParam ) )
            ::MoveTo( { aCellData[ 1 ], aCellData[ 2 ] }, { ::nRowPos, ::nColPos } )
         Else
            ::CurrentRow := ::nRowPos
            ::CurrentCol := ::nColPos
         EndIf
      EndIf
      Return Nil

   ElseIf nNotify == LVN_KEYDOWN
      If ::FirstVisibleColumn # 0
         If GetGridvKeyAsChar( lParam ) == 0
            ::cText := ""
         EndIf

         nvKey := GetGridvKey( lParam )
         Do Case
         Case GetKeyFlagState() == MOD_ALT .AND. nvKey == VK_A
            If ::lAppendOnAltA
               ::AppendItem()
            EndIf

         Case nvKey == VK_DELETE
            If ::AllowDelete .and. ! ::Eof() .AND. ! ::lLocked
               If ValType(::bDelWhen) == "B"
                  lGo := _OOHG_Eval( ::bDelWhen )
               Else
                  lGo := .t.
               EndIf

               If lGo
                  If ::lNoDelMsg .OR. MsgYesNo( _OOHG_Messages(4, 1), _OOHG_Messages(4, 2) )
                     ::Delete()
                  EndIf
               ElseIf ! Empty( ::DelMsg )
                  MsgExclamation( ::DelMsg, _OOHG_Messages(4, 2) )
               EndIf
            EndIf

         EndCase
      EndIf
      Return Nil

   ElseIf nNotify == LVN_ITEMCHANGED
      If GetGridOldState( lParam ) == 0 .and. GetGridNewState( lParam ) != 0
         Return Nil
      EndIf

   ElseIf nNotify == NM_CUSTOMDRAW
      ::AdjustRightScroll()
      Return TGrid_Notify_CustomDraw( Self, lParam, .T., ::nRowPos, ::nColPos, .F., ::lFocusRect, ::lNoGrid, ::lPLM )

   EndIf

   Return ::TGrid:Events_Notify( wParam, lParam )

METHOD GoBottom( lAppend ) CLASS TXBrowseByCell

   If ! ::lLocked
      ::TopBottom( GO_BOTTOM )
      ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
      // If it's for APPEND, leaves a blank line ;)
      ::Refresh( { ::CountPerPage - IIf( lAppend, 1, 0 ), IIf( lAppend, ::FirstColInOrder, ::LastColInOrder ) } )
      ::DoChange()
   EndIf

   Return Self

METHOD GoTop() CLASS TXBrowseByCell

   If ! ::lLocked
      ::TopBottom( GO_TOP )
      ::Refresh( { 1, ::FirstColInOrder } )
      ::DoChange()
   EndIf

   Return Self

METHOD Left() CLASS TXBrowseByCell

   Local nRow, nCol, lRet := .F.

   If ! ::lLocked .AND. ::nRowPos >= 1 .AND. ::nRowPos <= ::ItemCount .AND. ::nColPos >= 1 .AND. ::nColPos <= Len( ::aHeaders )
      nCol := ::PriorColInOrder( ::nColPos )
      If nCol # 0
         ::CurrentCol := nCol
         ::DoChange()
         lRet := .T.
      ElseIf ::FullMove
         nCol := ::LastColInOrder
         If nCol # 0
            // Up
            If ::DbSkip( -1 ) == -1
               nRow := ::nRowPos
               If nRow <= 1
                  If ::ItemCount >= ::CountPerPage
                     ::DeleteItem( ::ItemCount )
                  EndIf
                  ::InsertBlank( 1 )
               Else
                  nRow --
               EndIf
               If ::lUpdCols
                  ::Refresh( { nRow, nCol } )
               Else
                  ::RefreshRow( nRow )
                  ::CurrentRow := nRow
                  ::CurrentCol := nCol
               EndIf
               ::DoChange()
               lRet := .T.
            EndIf
         Endif
      EndIf
   EndIf

   Return lRet

METHOD Refresh( aCurrent, lNoEmptyBottom ) CLASS TXBrowseByCell

   Local nRow, nCol

   If HB_IsArray( aCurrent )
      If Len( aCurrent ) > 0
         nRow := aCurrent[ 1 ]
      EndIf
      If Len( aCurrent ) > 1
         nCol := aCurrent[ 2 ]
      EndIf
   EndIf
   If ! HB_IsNumeric( nCol ) .OR. nCol < 1 .OR. nCol > Len( ::aHeaders )
      nCol := ::nColPos
   EndIf
   ::Super:Refresh( nRow, lNoEmptyBottom )
   ::CurrentRow := ::nRowPos
   ::CurrentCol := nCol

   Return Self

METHOD Right( lAppend ) CLASS TXBrowseByCell

   Local nRow, nCol, lRet := .F.

   If ! ::lLocked .AND. ::nRowPos >= 1 .AND. ::nRowPos <= ::ItemCount .AND. ::nColPos >= 1 .AND. ::nColPos <= Len( ::aHeaders )
      nCol := ::NextColInOrder( ::nColPos )
      If nCol # 0
         ::CurrentCol := nCol
         ::DoChange()
         lRet := .T.
      ElseIf ::FullMove
         nCol := ::FirstColInOrder
         If nCol # 0
            // Down
            If ::DbSkip( 1 ) == 1
               nRow := ::nRowPos
               If nRow >= ::CountPerPage
                  ::DeleteItem( 1 )
               Else
                  nRow ++
               EndIf
               If ::lUpdCols
                  ::Refresh( { nRow, nCol } )
               Else
                  ::RefreshRow( nRow )
                  ::CurrentRow := nRow
                  ::CurrentCol := nCol
               EndIf
               ::DoChange()
               lRet := .T.
            Else
               ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT ::AllowAppend
               If lAppend
                  lRet := ::AppendItem()
               EndIf
            EndIf
         EndIf
      EndIf
   EndIf

   Return lRet

METHOD Up() CLASS TXBrowseByCell

   Local nValue, lRet := .F.

   If ! ::lLocked .AND. ::DbSkip( -1 ) == -1
      nValue := ::nRowPos
      If nValue <= 1
         If ::ItemCount >= ::CountPerPage
            ::DeleteItem( ::ItemCount )
         EndIf
         ::InsertBlank( 1 )
      Else
         nValue --
      EndIf
      If ::lUpdCols
         ::Refresh( { nValue, ::nColPos } )
      Else
         ::RefreshRow( nValue )
         ::CurrentRow := nValue
         ::CurrentCol := ::nColPos
      EndIf
      ::DoChange()
      lRet := .T.
   EndIf

   Return lRet

METHOD Down( lAppend ) CLASS TXBrowseByCell

   Local nValue, lRet := .F.

   If ! ::lLocked .AND. ::DbSkip( 1 ) == 1
      nValue := ::nRowPos
      If nValue >= ::CountPerPage
         ::DeleteItem( 1 )
      Else
         nValue ++
      EndIf
      If ::lUpdCols
         ::Refresh( { nValue, ::nColPos } )
      Else
         ::RefreshRow( nValue )
         ::CurrentRow := nValue
         ::CurrentCol := ::nColPos
      EndIf
      ::DoChange()
      lRet := .T.
   Else
      ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT ::AllowAppend
      If lAppend
         lRet := ::AppendItem()
      EndIf
   EndIf

   Return lRet

METHOD SetSelectedColors( aSelectedColors, lRedraw ) CLASS TXBrowseByCell

   Local i, aColors[ 8 ]

   If HB_IsArray( aSelectedColors )
      aSelectedColors := AClone( aSelectedColors )
      ASize( aSelectedColors, 8 )

      // For text of selected cell when grid has the focus
      If ! ValType( aSelectedColors[ 1 ] ) $ "ANB"
         aSelectedColors[ 1 ] := GetSysColor( COLOR_HIGHLIGHTTEXT )
      EndIf
      // For background of selected cell when grid has the focus
      If ! ValType( aSelectedColors[ 2 ] ) $ "ANB"
         aSelectedColors[ 2 ] := GetSysColor( COLOR_HIGHLIGHT )
      EndIf
      // For text of selected cell when grid doesn't has the focus
      If ! ValType( aSelectedColors[ 3 ] ) $ "ANB"
         aSelectedColors[ 3 ] := GetSysColor( COLOR_WINDOWTEXT )
      EndIf
      // For background of selected cell when grid doesn't has the focus
      If ! ValType( aSelectedColors[ 4 ] ) $ "ANB"
         aSelectedColors[ 4 ] := GetSysColor( COLOR_3DFACE )
      EndIf

      // For text of other cells in the selected row when grid has the focus
      If ! ValType( aSelectedColors[ 5 ] ) $ "ANB"
         aSelectedColors[ 5 ] := -1                    // defaults to DYNAMICFORECOLOR, or FONTCOLOR or COLOR_WINDOWTEXT
      EndIf
      // For background of other cells in the selected row when grid has the focus
      If ! ValType( aSelectedColors[ 6 ] ) $ "ANB"
         aSelectedColors[ 6 ] := -1                    // defaults to DYNAMICBACKCOLOR, or BACKCOLOR or COLOR_WINDOW
      EndIf
      // For text of other cells in the selected row when grid doesn't has the focus
      If ! ValType( aSelectedColors[ 7 ] ) $ "ANB"
         aSelectedColors[ 7 ] := -1                    // defaults to DYNAMICFORECOLOR, or FONTCOLOR or COLOR_WINDOWTEXT
      EndIf
      // For background of other cells in the selected row when grid doesn't has the focus
      If ! ValType( aSelectedColors[ 8 ] ) $ "ANB"
         aSelectedColors[ 8 ] := -1                    // defaults to DYNAMICBACKCOLOR, or BACKCOLOR or COLOR_WINDOW
      EndIf

      ::aSelectedColors := aSelectedColors

      For i := 1 To 8
         aColors[ i ] := _OOHG_GetArrayItem( aSelectedColors, i )
      Next i

      ::GridSelectedColors := aColors

      If lRedraw
         RedrawWindow( ::hWnd )
      EndIf
   Else
      aSelectedColors := AClone( ::aSelectedColors )
   EndIf

   Return aSelectedColors

METHOD SetControlValue( uValue ) CLASS TXBrowseByCell

   Local nRow := 0, nCol := 0

   If ! ::lLocked .AND. ::FirstVisibleColumn # 0
      If HB_IsArray( uValue )
         If Len( uValue ) == 1
            If HB_IsNumeric( uValue[ 1 ] ) .AND. uValue[ 1 ] >= 1 .AND. uValue[ 1 ] <= ::ItemCount
               nRow := uValue[ 1 ]
               nCol := 1
            EndIf
         ElseIf Len( uValue ) >= 2
            If ( HB_IsNumeric( uValue[ 1 ] ) .AND. HB_IsNumeric( uValue[ 2 ] ) .AND. ;
                 uValue[ 1 ] >= 1 .AND. uValue[ 1 ] <= ::ItemCount .AND. ;
                 uValue[ 2 ] >= 1 .AND. uValue[ 2 ] <= Len( ::aHeaders ) )
               nRow := uValue[ 1 ]
               nCol := uValue[ 2 ]
            EndIf
         EndIf
      ElseIf HB_IsNumeric( uValue ) .AND. uValue >= 1 .AND. uValue <= ::ItemCount
         nRow := uValue
         nCol := 1
      EndIf
   EndIf

   If nRow # 0 .AND. nCol # 0
      ::MoveTo( { nRow, nCol }, { ::nRowPos, ::nColPos } )
   Else
      ::CurrentRow := ::nRowPos
      ::CurrentCol := ::nColPos
   EndIf

   Return { ::nRowPos, ::nColPos }

METHOD Value( uValue ) CLASS TXBrowseByCell

   If ( ::FirstVisibleColumn # 0 .AND. ;
        HB_IsArray( uValue ) .AND. Len( uValue ) > 1 .AND. ;
        HB_IsNumeric( uValue[ 1 ] ) .AND. uValue[ 1 ] >= 1 .AND. uValue[ 1 ] <= ::ItemCount .AND. ;
        HB_IsNumeric( uValue[ 2 ] ) .AND. uValue[ 2 ] >= 1 .AND. uValue[ 2 ] <= Len( ::aHeaders ) )
      ::Super:Value( uValue[ 1 ] )
      ::CurrentCol := uValue[ 2 ]
   EndIf

   Return { ::nRowPos, ::nColPos }

METHOD CurrentCol( nValue ) CLASS TXBrowseByCell

   Local r, nClientWidth, nScrollWidth, lColChanged

   If HB_IsNumeric( nValue ) .AND. nValue >= 1 .AND. nValue <= Len( ::aHeaders )
      lColChanged := ( ::nColPos # nValue )
      ::nColPos := nValue

      // Ensure that the column is inside the client area
      If lColChanged
         r := { 0, 0, 0, 0 }                                                              // left, top, right, bottom
         GetClientRect( ::hWnd, r )
         nClientWidth := r[ 3 ] - r[ 1 ]
         r := ListView_GetSubitemRect( ::hWnd, ::nRowPos - 1, ::nColPos - 1 )             // top, left, width, height
         If ::lScrollBarUsesClientArea .AND. ::ItemCount > ::CountPerPage
            nScrollWidth := GetVScrollBarWidth()
         Else
            nScrollWidth := 0
         EndIf
         If r[ 2 ] + r[ 3 ] + nScrollWidth > nClientWidth
            // Move right side into client area
            ListView_Scroll( ::hWnd, ( r[ 2 ] + r[ 3 ] + nScrollWidth - nClientWidth ), 0 )
            // Get new position
            r := ListView_GetSubitemRect( ::hWnd, ::nRowPos - 1, ::nColPos - 1 )          // top, left, width, height
         EndIf
         If r[ 2 ] < 0
            // Move left side into client area
            ListView_Scroll( ::hWnd, r[ 2 ], 0 )
         EndIf
      EndIf

      // Ensure cell is visible
      ListView_RedrawItems( ::hWnd, ::nRowPos, ::ItemCount )
   EndIf

   Return ::nColPos


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


FUNCTION SetXBrowseFixedBlocks( lValue )

   If ValType( lValue ) == "L"
      _OOHG_XBrowseFixedBlocks := lValue
   EndIf

   Return _OOHG_XBrowseFixedBlocks

FUNCTION SetXBrowseFixedControls( lValue )

   If ValType( lValue ) == "L"
      _OOHG_XBrowseFixedControls := lValue
   EndIf

   Return _OOHG_XBrowseFixedControls
