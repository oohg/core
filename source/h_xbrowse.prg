/*
 * $Id: h_xbrowse.prg,v 1.118 2014-11-04 01:56:39 fyurisich Exp $
 */
/*
 * ooHG source code:
 * eXtended Browse code
 *
 * Copyright 2005-2011 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.oohg.org
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

#include "oohg.ch"
#include "hbclass.ch"
#include "i_windefs.ch"

#define GO_TOP    -1
#define GO_BOTTOM  1

STATIC _OOHG_XBrowseFixedBlocks := .T.
STATIC _OOHG_XBrowseFixedControls := .F.

CLASS TXBROWSE FROM TGrid
   DATA Type                      INIT "XBROWSE" READONLY
   DATA aFields                   INIT Nil
   DATA oWorkArea                 INIT Nil
   DATA uWorkArea                 INIT Nil
   DATA VScroll                   INIT Nil
   DATA ScrollButton              INIT Nil
   DATA aReplaceField             INIT Nil
   DATA Lock                      INIT .F.
   DATA skipBlock                 INIT Nil
   DATA goTopBlock                INIT Nil
   DATA goBottomBlock             INIT Nil
   DATA lLocked                   INIT .F.
   DATA lRecCount                 INIT .F.
   DATA lDescending               INIT .F.
   DATA Eof                       INIT .F.
   DATA Bof                       INIT .F.
   DATA RefreshType               INIT REFRESH_DEFAULT
   DATA SearchWrap                INIT .F.
   DATA VScrollCopy               INIT Nil
   DATA lVscrollVisible           INIT .F.
   DATA aColumnBlocks             INIT Nil
   DATA lFixedBlocks              INIT .F.
   DATA lNoShowEmptyRow           INIT .F.
   DATA lUpdCols                  INIT .F.

   METHOD AddColumn
   METHOD AdjustRightScroll
   METHOD CheckItem               BLOCK { || Nil }
   METHOD ColumnAutoFit
   METHOD ColumnAutoFitH
   METHOD ColumnBlock
   METHOD ColumnsAutoFit
   METHOD ColumnsAutoFitH
   METHOD ColumnWidth
   METHOD CurrentRow              SETGET
   METHOD DbSkip
   METHOD Define
   METHOD Delete
   METHOD DeleteColumn
   METHOD DoChange                BLOCK { | Self | ::DoEvent( ::OnChange, "CHANGE" ) }
   METHOD Down
   METHOD EditAllCells
   METHOD EditCell
   METHOD EditItem
   METHOD EditItem_B
   METHOD Enabled                 SETGET
   METHOD Events
   METHOD Events_Notify
   METHOD FixBlocks               SETGET
   METHOD GetCellType
   METHOD GoBottom
   METHOD GoTop
   METHOD Left                    BLOCK { || Nil }
   METHOD MoveTo
   METHOD PageDown
   METHOD PageUp
   METHOD Refresh
   METHOD RefreshData
   METHOD RefreshRow
   METHOD Right                   BLOCK { || Nil }
   METHOD SetColumn
   METHOD SetScrollPos
   METHOD SizePos
   METHOD ToExcel
   METHOD ToOpenOffice
   METHOD TopBottom
   METHOD Up
   METHOD Visible                 SETGET
   METHOD VScrollVisible          SETGET
   METHOD WorkArea                SETGET

   MESSAGE EditGrid               METHOD EditAllCells

/*
   Available methods from TGrid:
      AddItem
      AppendItem
      ColumnBetterAutoFit
      ColumnCount
      ColumnHide
      ColumnOrder
      ColumnsBetterAutoFit
      ColumnShow
      CountPerPage
      Define2
      DeleteAllItems
      DeleteItem
      ItemCount
      EditCell2
      Events_Enter
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
      InsertItem
      IsColumnReadOnly
      IsColumnWhen
      Item
      ItemCount
      ItemHeight
      Justify
      LoadHeaderImages
      OnEnter
      Release
      ScrollToCol
      ScrollToLeft
      ScrollToNext
      ScrollToPrior
      ScrollToRight
      SetItemColor
      SetRangeColor
      SetSelectedColors
      SortColumn
      Value            it's used for painting the grid, it doesn't trigger on change event
*/

   EMPTY( _OOHG_AllVars )
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
               aFields, WorkArea, value, AllowDelete, lock, novscroll, ;
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
               lNoShowEmptyRow, lUpdCols, bHeadRClick, lNoModal, lExtDbl ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local nWidth2, nCol2, lLocked, oScroll, z

   ASSIGN ::aFields         VALUE aFields         TYPE "A"
   ASSIGN ::aHeaders        VALUE aHeaders        TYPE "A" DEFAULT {}
   ASSIGN ::aWidths         VALUE aWidths         TYPE "A" DEFAULT {}
   ASSIGN ::aJust           VALUE aJust           TYPE "A" DEFAULT {}
   ASSIGN ::lDescending     VALUE lDescending     TYPE "L"
   ASSIGN lFixedBlocks      VALUE lFixedBlocks    TYPE "L" DEFAULT _OOHG_XBrowseFixedBlocks
   ASSIGN lFixedCtrls       VALUE lFixedCtrls     TYPE "L" DEFAULT _OOHG_XBrowseFixedControls
   ASSIGN ::lNoShowEmptyRow VALUE lNoShowEmptyRow TYPE "L"
   ASSIGN ::lUpdCols        VALUE lUpdCols        TYPE "L"

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

   aSize( ::aHeaders, len( ::aFields ) )
   aEval( ::aHeaders, { |x,i| ::aHeaders[ i ] := iif( ! ValType( x ) $ "CM", if( ValType( ::aFields[ i ] ) $ "CM", ::aFields[ i ], "" ), x ) } )

   aSize( ::aWidths, len( ::aFields ) )
   aEval( ::aWidths, { |x,i| ::aWidths[ i ] := iif( ! ValType( x ) == "N", 100, x ) } )

   ASSIGN w         VALUE w         TYPE "N" DEFAULT ::nWidth
   ASSIGN novscroll VALUE novscroll TYPE "L" DEFAULT .F.
   nWidth2 := if( novscroll, w, w - GETVSCROLLBARWIDTH() )

   ::Define2( ControlName, ParentForm, x, y, nWidth2, h, ::aHeaders, aWidths, ;
              , , fontname, fontsize, tooltip, , , ;
              aHeadClick, , , nogrid, aImage, ::aJust, ;
              break, HelpId, bold, italic, underline, strikeout, , ;
              , , editable, backcolor, fontcolor, dynamicbackcolor, ;
              dynamicforecolor, aPicture, lRtl, LVS_SINGLESEL, ;
              inplace, editcontrols, readonly, valid, validmessages, ;
              editcell, aWhenFields, lDisabled, lNoTabStop, lInvisible, ;
              lHasHeaders, , aHeaderImage, aHeaderImageAlign, FullMove, ;
              aSelectedColors, aEditKeys, , , lDblBffr, lFocusRect, lPLM, ;
              lFixedCols, abortedit, click, lFixedWidths, bBeforeColMove, ;
              bAfterColMove, bBeforeColSize, bAfterColSize, bBeforeAutofit, ;
              lLikeExcel, lButtons, AllowDelete, , , DelMsg, lNoDelMsg, ;
              AllowAppend, , lNoModal, lFixedCtrls, bHeadRClick, , , lExtDbl )

   ::FixBlocks( lFixedBlocks )

   ::nWidth := w

   ASSIGN ::Lock          VALUE lock          TYPE "L"
   ASSIGN ::aReplaceField VALUE replacefields TYPE "A"
   ASSIGN ::lRecCount     VALUE lRecCount     TYPE "L"

   IF ::lRtl .AND. ! ::Parent:lRtl
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
   // cambiar TOOLTIP si cambia el del BROWSE
   // Cambiar HelpID si cambia el del BROWSE

   ::VScrollCopy := oScroll

   // It forces to hide "additional" controls when it's inside a
   // non-visible TAB page.
   ::Visible := ::Visible

   ::lVScrollVisible := .T.
   If novscroll
      ::VScrollVisible( .F. )
   EndIf

   ASSIGN lLocked VALUE ::lLocked TYPE "L" DEFAULT .F.
   ::lLocked := .F.
   ::Refresh( value )
   ::lLocked := lLocked

   // Must be set after control is initialized
   ASSIGN ::OnLostFocus VALUE lostfocus   TYPE "B"
   ASSIGN ::OnGotFocus  VALUE gotfocus    TYPE "B"
   ASSIGN ::OnChange    VALUE change      TYPE "B"
   ASSIGN ::OnDblClick  VALUE dblclick    TYPE "B"
   ASSIGN ::OnAppend    VALUE onappend    TYPE "B"
   ASSIGN ::OnEnter     VALUE onenter     TYPE "B"
   ASSIGN ::bDelWhen    VALUE bDelWhen    TYPE "B"
   ASSIGN ::OnDelete    VALUE onDelete    TYPE "B"

Return Self

*-----------------------------------------------------------------------------*
METHOD FixBlocks( lFix ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
   If HB_IsLogical( lFix )
      If lFix
         ::aColumnBlocks := ARRAY( len( ::aFields ) )
         aEval( ::aFields, { |c,i| ::aColumnBlocks[ i ] := ::ColumnBlock( i ), c } )
         ::lFixedBlocks := .T.
      Else
         ::lFixedBlocks := .F.
         ::aColumnBlocks := Nil
      EndIf
   EndIf
Return ::lFixedBlocks

*-----------------------------------------------------------------------------*
METHOD Refresh( nCurrent, lNoEmptyBottom ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
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
         // Draws rows
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

      // Clears bottom rows
      Do While ::ItemCount > nRow
         ::DeleteItem( ::ItemCount )
      EndDo
      // Returns to current row
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

*-----------------------------------------------------------------------------*
METHOD RefreshRow( nRow ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local aItem, cWorkArea

   If ! ::lLocked
      cWorkArea := ::WorkArea
      If ValType( cWorkArea ) $ "CM" .AND. Empty( cWorkArea )
         cWorkArea := Nil
      EndIf
      aItem := ARRAY( LEN( ::aFields ) )
      If ::FixBlocks()
         aEval( aItem, { |x,i| aItem[ i ] := EVAL( ::aColumnBlocks[ i ], cWorkArea ), x } )
      Else
         aEval( aItem, { |x,i| aItem[ i ] := EVAL( ::ColumnBlock( i ), cWorkArea ), x } )
      EndIf
      aEval( aItem, { |x,i| IF( ValType( x ) $ "CM", aItem[ i ] := TRIM( x ),  ) } )

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
   EndIf
Return Self

*-----------------------------------------------------------------------------*
METHOD ColumnBlock( nCol, lDirect ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local oEditControl, cWorkArea, cValue, uPicture
Local bRet

   ASSIGN lDirect VALUE lDirect TYPE "L" DEFAULT .F.
   IF ! ValType( nCol ) == "N" .OR. nCol < 1 .OR. nCol > LEN( ::aFields )
      Return { || "" }
   EndIf
   cWorkArea := ::WorkArea
   If ValType( cWorkArea ) $ "CM" .AND. Empty( cWorkArea )
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
         ASSIGN uPicture VALUE ::Picture TYPE "A" DEFAULT {}
         uPicture := IF( Len( uPicture ) < nCol, Nil, uPicture[ nCol ] )
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

*-----------------------------------------------------------------------------*
FUNCTION TXBrowse_UpDate_PerType( uValue )
*-----------------------------------------------------------------------------*
Local cType := ValType( uValue )

   If     cType == "C"
      uValue := rTrim( uValue )
   ElseIf cType == "N"
      uValue := lTrim( Str( uValue ) )
   ElseIf cType == "L"
      uValue := IIF( uValue, ".T.", ".F." )
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

*-----------------------------------------------------------------------------*
METHOD MoveTo( nTo, nFrom ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
   If ! ::lLocked .AND. ! ( ::lNoShowEmptyRow .AND. ::oWorkArea:IsTableEmpty() )
      ASSIGN nTo   VALUE nTo   TYPE "N" DEFAULT ::CurrentRow
      ASSIGN nFrom VALUE nFrom TYPE "N" DEFAULT ::nRowPos
      nFrom := Max( Min( nFrom, ::ItemCount ), 1 )
      nTo   := Max( Min( nTo,   ::CountPerPage ), 1 )
      ::RefreshRow( nFrom )
      Do While nFrom != nTo
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
      ::DoChange()
   EndIf
Return Self

*-----------------------------------------------------------------------------*
METHOD CurrentRow( nValue ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local oVScroll, aPosition

   If ValType( nValue ) == "N" .AND. ! ::lLocked
      ::nRowPos := nValue
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
      ::Super:Value := nValue
   EndIf
Return ::Super:Value

*-----------------------------------------------------------------------------*
METHOD SizePos( Row, Col, Width, Height ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
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

   IF ! ::AdjustRightScroll()
      ::Refresh()
   EndIf
Return uRet

*------------------------------------------------------------------------------*
METHOD Enabled( lEnabled ) CLASS TXBrowse
*------------------------------------------------------------------------------*
   IF ValType( lEnabled ) == "L"
      ::Super:Enabled := lEnabled
      aEval( ::aControls, { |o| o:Enabled := o:Enabled } )
   EndIf
Return ::Super:Enabled

*------------------------------------------------------------------------------*
METHOD ToExcel( cTitle, nColFrom, nColTo ) CLASS TXBrowse
*------------------------------------------------------------------------------*
Local oExcel, oSheet, nLin, i, cWorkArea, uValue

   If ::lLocked
      Return Nil
   EndIf

   If ! ValType( cTitle ) $ "CM"
      cTitle := ""
   EndIf
   If ! ValType( nColFrom ) == "N" .OR. nColFrom < 1
      nColFrom := 1
   EndIf
   If ! ValType( nColTo ) == "N" .OR. nColTo > Len( ::aHeaders )
      nColTo := Len( ::aHeaders )
   EndIf

   #ifndef __XHARBOUR__
      If ( oExcel := win_oleCreateObject( "Excel.Application" ) ) == Nil
         MsgStop( "Error: MS Excel not available. [" + win_oleErrorText()+ "]" )
         Return Nil
      EndIf
   #else
      oExcel := TOleAuto():New( "Excel.Application" )
      If Ole2TxtError() != "S_OK"
         MsgStop( "Excel not found", "Error" )
         Return Nil
      EndIf
   #EndIf

   oExcel:WorkBooks:Add()
   oSheet := oExcel:ActiveSheet()
   oSheet:Cells:Font:Name := "Arial"
   oSheet:Cells:Font:Size := 10

   nLin := 4

   For i := nColFrom To nColTo
      oSheet:Cells( nLin, i - nColFrom + 1 ):Value := ::aHeaders[ i ]
      oSheet:Cells( nLin, i - nColFrom + 1 ):Font:Bold := .T.
   Next i
   nLin += 2

   cWorkArea := ::WorkArea
   If ValType( cWorkArea ) $ "CM" .AND. Empty( cWorkArea )
      cWorkArea := Nil
   EndIf

   ::GoTop()
   Do While ! ::Eof()
      For i := nColFrom To nColTo
         If HB_IsBlock( ::aFields[ i ] )
            uValue := ( cWorkArea ) -> ( Eval( ::aFields[ i ], cWorkArea ) )
         Else
            uValue := ( cWorkArea ) -> ( &( ::aFields[ i ] ) )
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

Return Nil

*-----------------------------------------------------------------------------*
METHOD ToOpenOffice( cTitle, nColFrom, nColTo ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local oSerMan, oDesk, oPropVals, oBook, oSheet, nLin, i, uValue, cWorkArea

   If ::lLocked
      Return Nil
   EndIf

   If ! ValType( cTitle ) $ "CM"
      cTitle := ""
   EndIf
   If ! ValType( nColFrom ) == "N" .OR. nColFrom < 1
      nColFrom := 1
   EndIf
   If ! ValType( nColTo ) == "N" .OR. nColTo > Len( ::aHeaders )
      nColTo := Len( ::aHeaders )
   EndIf

   // open service manager
   #ifndef __XHARBOUR__
      If ( oSerMan := win_oleCreateObject( "com.sun.star.ServiceManager" ) ) == Nil
         MsgStop( "Error: OpenOffice not available. [" + win_oleErrorText()+ "]" )
         Return Nil
      EndIf
   #else
      oSerMan := TOleAuto():New( "com.sun.star.ServiceManager" )
      If Ole2TxtError() != "S_OK"
         MsgStop( "OpenOffice not found", "Error" )
         Return Nil
      EndIf
   #EndIf

   // open desktop service
   If ( oDesk := oSerMan:CreateInstance( "com.sun.star.frame.Desktop" ) ) == Nil
      MsgStop( "Error: OpenOffice Desktop not available." )
      Return Nil
   EndIf

   // set properties for new book
   oPropVals := oSerMan:Bridge_GetStruct( "com.sun.star.beans.PropertyValue" )
   oPropVals:Name := "Hidden"
   oPropVals:Value := .T.

   // open new book
   If ( oBook := oDesk:LoadComponentFromURL( "private:factory/scalc", "_blank", 0, {oPropVals} ) ) == Nil
      MsgStop( "Error: OpenOffice Calc not available." )
      oDesk := Nil
      Return Nil
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

   nLin := 4

   // put headers using bold style
   For i := nColFrom To nColTo
      oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetString( ::aHeaders[ i ] )
      oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetPropertyValue( "CharWeight", 150 )
   Next i
   nLin += 2

   // put rows
   cWorkArea := ::WorkArea
   If ValType( cWorkArea ) $ "CM" .AND. Empty( cWorkArea )
      cWorkArea := Nil
   EndIf

   ::GoTop()
   Do While ! ::Eof()
      For i := nColFrom To nColTo
         If HB_IsBlock( ::aFields[ i ] )
            uValue := ( cWorkArea ) -> ( Eval( ::aFields[ i ], cWorkArea ) )
         Else
            uValue := ( cWorkArea ) -> &( ::aFields[ i ] )
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

Return Nil

*------------------------------------------------------------------------------*
METHOD Visible( lVisible ) CLASS TXBrowse
*------------------------------------------------------------------------------*
   IF ValType( lVisible ) == "L"
      ::Super:Visible := lVisible
      aEval( ::aControls, { |o| o:Visible := lVisible } )
      ProcessMessages()
   EndIf
Return ::lVisible

*-----------------------------------------------------------------------------*
METHOD RefreshData() CLASS TXBrowse
*-----------------------------------------------------------------------------*
   ::Refresh()
Return ::Super:RefreshData()

*-----------------------------------------------------------------------------*
METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local cWorkArea, uGridValue

   If nMsg == WM_CHAR
      If wParam < 32 .OR. ::SearchCol < 1 .OR. ::SearchCol > ::ColumnCount .OR. ::lLocked .OR. ::aScan( ::aHiddenCols, ::SearchCol ) # 0
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
      If ValType( cWorkArea ) $ "CM" .AND. Empty( cWorkArea )
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

*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam )
Local nvKey, lGo

   If nNotify == NM_CLICK
      If ! ::lLocked .AND. ::FirstVisibleColumn # 0
         ::MoveTo( ::CurrentRow, ::nRowPos )
      Else
         ::Super:Value := ::nRowPos
      EndIf
      // Continue in ::Super

   ElseIf nNotify == NM_RCLICK
      If ! ::lLocked .AND. ::FirstVisibleColumn # 0
         ::MoveTo( ::CurrentRow, ::nRowPos )
      Else
         ::Super:Value := ::nRowPos
      EndIf
      // Continue in ::Super

   ElseIf nNotify == LVN_BEGINDRAG
      If ! ::lLocked .AND. ::FirstVisibleColumn # 0
         ::MoveTo( ::CurrentRow, ::nRowPos )
      Else
         ::Super:Value := ::nRowPos
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
            If ::AllowAppend .AND. ! ::lLocked
               ::EditItem( .T., ! ( ::Inplace .AND. ::FullMove ) )
            EndIf

         Case nvKey == VK_DELETE
            If ::AllowDelete .AND. ! ::Eof() .AND. ! ::lLocked
               If ValType( ::bDelWhen ) == "B"
                  lGo := _OOHG_Eval( ::bDelWhen )
               Else
                  lGo := .T.
               EndIf

               If lGo
                  If ::lNoDelMsg
                     ::Delete()
                  ElseIf MsgYesNo( _OOHG_Messages( 4, 1 ), _OOHG_Messages( 4, 2 ) )
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
      // Continue in ::Super

   EndIf
Return ::Super:Events_Notify( wParam, lParam )

*-----------------------------------------------------------------------------*
METHOD DbSkip( nRows ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local nCount, nSign

   nSign := IF( ::lDescending, -1, 1 )
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

*-----------------------------------------------------------------------------*
METHOD Up() CLASS TXBrowse
*-----------------------------------------------------------------------------*
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

*-----------------------------------------------------------------------------*
METHOD Down( lAppend ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local nValue

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT ::AllowAppend
   If ::lLocked
      // Do not move
   ElseIf ::DbSkip( 1 ) == 1
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
   ElseIf ! ::lNestedEdit .AND. lAppend
      ::EditItem( .T., ! ( ::Inplace .AND. ::FullMove ) )
   EndIf
Return Self

*-----------------------------------------------------------------------------*
METHOD PageUp() CLASS TXBrowse
*-----------------------------------------------------------------------------*
   If ! ::lLocked .AND. ::DbSkip( -::CountPerPage ) != 0
      ::Refresh()
      ::DoChange()
   EndIf
Return Self

*-----------------------------------------------------------------------------*
METHOD PageDown( lAppend ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local nSkip, nCountPerPage

   If ::lLocked
      // Do not move
   Else
      ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT ::AllowAppend
      nCountPerPage := ::CountPerPage
      nSkip := ::DbSkip( nCountPerPage )
      If nSkip != nCountPerPage
         ::Refresh( nCountPerPage )
         ::DoChange()
         If ! ::lNestedEdit .AND. lAppend
            ::EditItem( .T., ! ( ::Inplace .AND. ::FullMove ) )
         EndIf
      ElseIf nSkip != 0
         ::Refresh( , .T. )
         ::DoChange()
      EndIf
   EndIf
Return Self

*-----------------------------------------------------------------------------*
METHOD TopBottom( nDir ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
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
Return Nil

*-----------------------------------------------------------------------------*
METHOD GoTop() CLASS TXBrowse
*-----------------------------------------------------------------------------*
   If ! ::lLocked
      ::TopBottom( GO_TOP )
      ::Refresh( 1 )
      ::DoChange()
   EndIf
Return Self

*-----------------------------------------------------------------------------*
METHOD GoBottom( lAppend ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   If ! ::lLocked
      ::TopBottom( GO_BOTTOM )
      // If it's for APPEND, leaves a blank line ;)
      ::Refresh( ::CountPerPage - IF( lAppend, 1, 0 ) )
      ::DoChange()
   EndIf
Return Self

*-----------------------------------------------------------------------------*
METHOD SetScrollPos( nPos, VScroll ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
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

*-----------------------------------------------------------------------------*
METHOD Delete() CLASS TXBrowse
*-----------------------------------------------------------------------------*
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

*-----------------------------------------------------------------------------*
METHOD EditItem( lAppend, lOneRow ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local uRet := .F.

   If ! ::lNestedEdit .AND. ! ::lLocked
      ::lNestedEdit := .T.
      If ::lVScrollVisible
         // Kills scrollbar's events...
         ::VScroll:Enabled := .F.
         ::VScroll:Enabled := .T.
      EndIf
      uRet := ::EditItem_B( lAppend, lOneRow )
      ::lNestedEdit := .F.
   EndIf
Return uRet

*-----------------------------------------------------------------------------*
METHOD EditItem_B( lAppend, lOneRow ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local oWorkArea, cTitle, z, nOld
Local uOldValue, oEditControl, cMemVar, bReplaceField
Local aItems, aMemVars, aReplaceFields

   If ::lLocked .OR. ::FirstVisibleColumn == 0
      Return .F.
   EndIf

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   ASSIGN lOneRow VALUE lOneRow TYPE "L" DEFAULT .T.

   oWorkArea := ::oWorkArea
   If oWorkArea:Eof()
      If ! lAppend .AND. ! ::AllowAppend
         Return .F.
      Else
         lAppend := .T.
      EndIf
   EndIf

   If lAppend
      ::lAppendMode := .T.
   EndIf

   If ::InPlace
      If lAppend
         ::GoBottom( .T. )
         ::InsertBlank( ::ItemCount + 1 )
         ::CurrentRow := ::ItemCount
         oWorkArea:GoTo( 0 )
      EndIf
      Return ::EditAllCells( , , lAppend, lOneRow )
   EndIf

   If lAppend
      cTitle := _OOHG_Messages( 2, 1 )
      nOld := oWorkArea:RecNo()
      oWorkArea:GoTo( 0 )
   Else
      cTitle := if( ValType( ::cRowEditTitle ) $ "CM", ::cRowEditTitle, _OOHG_Messages( 2, 2 ) )
   EndIf

   aItems := ARRAY( Len( ::aHeaders ) )
   If ! ::FixControls()
      ::aEditControls := ARRAY( Len( aItems ) )
   EndIf
   aMemVars := ARRAY( Len( aItems ) )
   aReplaceFields := ARRAY( Len( aItems ) )
   For z := 1 To Len( aItems )
      oEditControl := uOldValue := cMemVar := bReplaceField := Nil
      ::GetCellType( z, @oEditControl, @uOldValue, @cMemVar, @bReplaceField )
      If ValType( uOldValue ) $ "CM"
         uOldValue := AllTrim( uOldValue )
      EndIf
      // MixedFields??? If field is from other workarea...
      If ! ::FixControls()
         ::aEditControls[ z ] := oEditControl
      EndIf
      aItems[ z ] := uOldValue
      aMemVars[ z ] := cMemVar
      aReplaceFields[ z ] := bReplaceField

// MIXEDFIELDS!!!!
//      If append .AND. MixedFields
//         MsgOOHGError( _OOHG_Messages( 3, 8 ), _OOHG_Messages( 3, 3 ) )
//      EndIf
   Next z

   If ::Lock .AND. ! lAppend
      If ! oWorkArea:Lock()
         MsgExclamation( _OOHG_Messages( 3, 9 ), _OOHG_Messages( 3, 10 ) )
         Return .F.
      EndIf
   EndIf

   If ! EMPTY( oWorkArea:cAlias__ )
      aItems := ( oWorkArea:cAlias__ )->( ::EditItem2( ::CurrentRow, aItems, ::aEditControls, aMemVars, cTitle ) )
   Else
      aItems := ::EditItem2( ::CurrentRow, aItems, ::aEditControls, aMemVars, cTitle )
   EndIf

   If ! Empty( aItems )
      If lAppend
         oWorkArea:Append()
      EndIf

      For z := 1 To Len( aItems )
         If ::IsColumnReadOnly( z )
            // Readonly field
         ElseIf aScan( ::aHiddenCols, z ) > 0
           // Hidden column
         Else
            _OOHG_Eval( aReplaceFields[ z ], aItems[ z ], oWorkArea )
         EndIf
      Next z

      If lAppend
         ::lAppendMode := .F.
         If ! EMPTY( oWorkArea:cAlias__ )
            ( oWorkArea:cAlias__ )->( ::DoEvent( ::OnAppend, "APPEND" ) )
         Else
            ::DoEvent( ::OnAppend, "APPEND" )
         EndIf
      EndIf

      If ::RefreshType == REFRESH_NO
         ::RefreshRow( ::CurrentRow )
      Else
         ::Refresh()
      EndIf
      _SetThisCellInfo( ::hWnd, ::CurrentRow, 0, Nil )
      _OOHG_Eval( ::OnEditCell, ::CurrentRow, 0 )
      _ClearThisCellInfo()
   Else
      If lAppend
         ::lAppendMode := .F.
         oWorkArea:GoTo( nOld )
      EndIf
      _OOHG_Eval( ::OnAbortEdit, ::CurrentRow, 0 )
   EndIf

   If ::Lock
      oWorkArea:Commit()
      oWorkArea:Unlock()
   EndIf
Return ! Empty( aItems )

*-----------------------------------------------------------------------------*
METHOD EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, lAppend, nOnFocusPos ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local lRet, bReplaceField, oWorkArea

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   ASSIGN nRow    VALUE nRow    TYPE "N" DEFAULT ::CurrentRow
   ASSIGN nCol    VALUE nCol    TYPE "N" DEFAULT 1
   If nRow < 1 .OR. nRow > ::ItemCount() .OR. nCol < 1 .OR. nCol > Len( ::aHeaders ) .OR. ::lLocked
      // Cell out of range
      lRet := .F.
   ElseIf ::IsColumnReadOnly( nCol )
      // Read only column
      PlayHand()
      lRet := .F.
   ElseIf aScan( ::aHiddenCols, nCol ) > 0
     // Hidden column
      lRet := .F.
   ElseIf ::oWorkArea:EOF() .AND. ! lAppend .AND. ! ::AllowAppend
      // "fake" record, and don't allows append
      lRet := .F.
   Else
      oWorkArea := ::oWorkArea
      If oWorkArea:EOF()
         ::lAppendMode := .T.
         lAppend := .T.
      EndIf

      // If LOCK clause is present, try to lock.
      If lAppend
         //

      ElseIf ::Lock .AND. ! oWorkArea:Lock()
         MsgExclamation( _OOHG_Messages( 3, 9 ), _OOHG_Messages( 3, 10 ) )
         Return .F.
      EndIf

      ::GetCellType( nCol, @EditControl, @uOldValue, @cMemVar, @bReplaceField )

      lRet := ::EditCell2( @nRow, @nCol, EditControl, uOldValue, @uValue, cMemVar, nOnFocusPos )
      If lRet
         If lAppend
            oWorkArea:Append()
         EndIf
         _OOHG_Eval( bReplaceField, uValue, oWorkArea )
         If lAppend
            ::lAppendMode := .F.
            If ! EMPTY( oWorkArea:cAlias__ )
               ( oWorkArea:cAlias__ )->( ::DoEvent( ::OnAppend, "APPEND" ) )
            Else
               ::DoEvent( ::OnAppend, "APPEND" )
            EndIf
         EndIf
         ::RefreshRow( nRow )
         _SetThisCellInfo( ::hWnd, nRow, nCol, uValue )
         _OOHG_Eval( ::OnEditCell, nRow, nCol )
         _ClearThisCellInfo()
      ElseIf lAppend
         ::lAppendMode := .F.
         _OOHG_Eval( ::OnAbortEdit, 0, 0 )
      Else
         _OOHG_Eval( ::OnAbortEdit, nRow, nCol )
      EndIf
      If ::Lock
         oWorkArea:Commit()
         oWorkArea:UnLock()
      EndIf
   EndIf
Return lRet

*-----------------------------------------------------------------------------*
METHOD EditAllCells( nRow, nCol, lAppend, lOneRow ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local lRet, lRowEdited, lSomethingEdited

   ASSIGN lOneRow VALUE lOneRow TYPE "L" DEFAULT .F.
   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   ASSIGN nRow    VALUE nRow    TYPE "N" DEFAULT ::CurrentRow
   ASSIGN nCol    VALUE nCol    TYPE "N" DEFAULT 1

   If nRow < 1 .OR. nRow > ::ItemCount() .OR. nCol < 1 .OR. nCol > Len( ::aHeaders ) .OR. ::lLocked .OR. ::FirstVisibleColumn == 0
      // Cell out of range
      Return .F.
   EndIf

   lSomethingEdited := .F.

   Do While .T.
      lRet := .T.
      lRowEdited := .F.

      Do While nCol <= Len( ::aHeaders ) .AND. lRet
         If ::IsColumnReadOnly( nCol )
           // Read only column, skip
         ElseIf ! ::IsColumnWhen( nCol )
           // Not a valid WHEN, skip column and continue editing
         ElseIf aScan( ::aHiddenCols, nCol ) > 0
           // Hidden column, skip
         Else
            lRet := ::EditCell( nRow, nCol, , , , , lAppend )

            If lRet
               lRowEdited := .T.
               lSomethingEdited := .T.
            ElseIf lAppend
               ::GoBottom()
            EndIf

            lAppend := .F.
         EndIf

         nCol ++
      EndDo

      // If a column was edited, scroll to the left
      If lRowEdited
         ListView_Scroll( ::hWnd, - _OOHG_GridArrayWidths( ::hWnd, ::aWidths ), 0 )
      EndIf

      If ! lRet .OR. ! ::FullMove .OR. lOneRow
         // Stop if the last column was not edited
         // or it's not fullmove editing
         // or caller wants to edit only one row
         Exit
      ElseIf nRow < ::ItemCount()
         // Edit next row
         ::Down()

         nRow ++
         nCol := 1
      ElseIf ::AllowAppend
         // Insert new row
         ::GoBottom( .T. )
         ::InsertBlank( ::ItemCount + 1 )
         nRow := ::CurrentRow := ::ItemCount
         nCol := 1
         lAppend := .T.
         ::lAppendMode := .T.
         ::oWorkArea:GoTo( 0 )
      Else
         Exit
      EndIf
   EndDo

Return lSomethingEdited

*-----------------------------------------------------------------------------*
METHOD GetCellType( nCol, EditControl, uOldValue, cMemVar, bReplaceField ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local cField, cArea, nPos, aStruct

   If ValType( nCol ) != "N"
      nCol := 1
   EndIf
   If nCol < 1 .OR. nCol > Len( ::aHeaders )
      // Cell out of range
      Return .F.
   EndIf

   If ValType( uOldValue ) == "U"
      uOldValue := EVAL( ::ColumnBlock( nCol, .T. ), ::WorkArea )
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
      If nPos == 0
//         cArea := cField := ""
      Else
         If ! ValType( cMemVar ) $ "CM" .OR. Empty( cMemVar )
            cMemVar := "MemVar" + cArea + cField
         EndIf
         If ValType( bReplaceField ) != "B"
            bReplaceField := FieldWBlock( cField, Select( cArea ) )
         EndIf
      EndIf
   Else
//      cArea := cField := ""
      nPos := 0
   EndIf

   // Determines control type
   If ! HB_IsObject( EditControl ) .AND. ::FixControls()
      EditControl := ::aEditControls[ nCol ]
   EndIf
   EditControl := GetEditControlFromArray( EditControl, ::EditControls, nCol, Self )
   If ValType( EditControl ) != "O"
      If ValType( ::Picture ) == "A" .AND. Len( ::Picture ) >= nCol
         If ValType( ::Picture[ nCol ] ) $ "CM"
            EditControl := TGridControlTextBox():New( ::Picture[ nCol ], , ValType( uOldValue ), , , , Self )
         ElseIf ValType( ::Picture[ nCol ] ) == "L" .AND. ::Picture[ nCol ]
            EditControl := TGridControlImageList():New( Self )
         EndIf
      EndIf
      If ValType( EditControl ) != "O" .AND. nPos != 0
         // Checks according to field type
         Do Case
            Case aStruct[ nPos ][ 2 ] == "N"
               If aStruct[ nPos ][ 4 ] == 0
                  EditControl := TGridControlTextBox():New( Replicate( "9", aStruct[ nPos ][ 3 ] ), , "N", , , , Self )
               Else
                  EditControl := TGridControlTextBox():New( Replicate( "9", aStruct[ nPos ][ 3 ] - aStruct[ nPos ][ 4 ] - 1 ) + "." + Replicate( "9", aStruct[ nPos ][ 4 ] ), , "N", , , , Self )
               EndIf
            Case aStruct[ nPos ][ 2 ] == "L"
               // EditControl := TGridControlCheckBox():New( , , , , Self)
               EditControl := TGridControlLComboBox():New( , , , , Self )
            Case aStruct[ nPos ][ 2 ] == "M"
               EditControl := TGridControlMemo():New( , , Self )
            Case aStruct[ nPos ][ 2 ] == "D"
               // EditControl := TGridControlDatePicker():New( .T., , , , Self )
               EditControl := TGridControlTextBox():New( "@D", , "D", , , , Self )
            Case aStruct[ nPos ][ 2 ] == "C"
               EditControl := TGridControlTextBox():New( "@S" + Ltrim( Str( aStruct[ nPos ][ 3 ] ) ), , "C", , , , Self )
            OtherWise
               // Non-implemented field type!!!
         EndCase
      EndIf
      If ValType( EditControl ) != "O"
         EditControl := GridControlObjectByType( uOldValue, Self )
      EndIf
   EndIf
Return .T.

*-----------------------------------------------------------------------------*
METHOD ColumnWidth( nColumn, nWidth ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local nRet

   nRet := ::Super:ColumnWidth( nColumn, nWidth )
   ::AdjustRightScroll()
Return nRet

*-----------------------------------------------------------------------------*
METHOD ColumnAutoFit( nColumn ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local nRet

   nRet := ::Super:ColumnAutoFit( nColumn )
   ::AdjustRightScroll()
Return nRet

*-----------------------------------------------------------------------------*
METHOD ColumnAutoFitH( nColumn ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local nRet

   nRet := ::Super:ColumnAutoFitH( nColumn )
   ::AdjustRightScroll()
Return nRet

*-----------------------------------------------------------------------------*
METHOD ColumnsAutoFit() CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local nRet

   nRet := ::Super:ColumnsAutoFit()
   ::AdjustRightScroll()
Return nRet

*-----------------------------------------------------------------------------*
METHOD ColumnsAutoFitH() CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local nRet

   nRet := ::Super:ColumnsAutoFitH()
   ::AdjustRightScroll()
Return nRet

*-----------------------------------------------------------------------------*
METHOD WorkArea( uWorkArea ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
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
      EndIf
   EndIf
Return ::uWorkArea

*-----------------------------------------------------------------------------*
METHOD AddColumn( nColIndex, xField, cHeader, nWidth, nJustify, uForeColor, ;
                  uBackColor, lNoDelete, uPicture, uEditControl, uHeadClick, ;
                  uValid, uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign, ;
                  uReplaceField, lRefresh ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
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
   If ValType( uEditControl ) != Nil .OR. HB_IsArray( ::EditControls )
      If ! HB_IsArray( ::EditControls )
         ::EditControls := Array( nColumns )
      ElseIf Len( ::EditControls ) < nColumns
         aSize( ::EditControls, nColumns )
      EndIf
      aIns( ::EditControls, nColIndex )
      ::EditControls[ nColIndex ] := uEditControl
   EndIf

   // Update after updating ::EditControls
   If ::FixBlocks()
      aSize( ::aColumnBlocks, nColumns )
      aIns( ::aColumnBlocks, nColIndex )
      ::aColumnBlocks[ nColIndex ] := ::ColumnBlock( nColIndex )
   EndIf

   If HB_IsArray( ::aReplaceField )
      aSize( ::aReplaceField, nColumns )
      aIns( ::aReplaceField, nColIndex )
   ELSE
      ::aReplaceField := ARRAY( nColumns )
   EndIf
   ::aReplaceField[ nColIndex ] := uReplaceField

   nRet := ::Super:AddColumn( nColIndex, cHeader, nWidth, nJustify, uForeColor, ;
                              uBackColor, lNoDelete, uPicture, uEditControl, uHeadClick, ;
                              uValid, uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign )

   If ! HB_IsLogical( lRefresh ) .OR. lRefresh
      ::Refresh()
   EndIf
Return nRet

*-----------------------------------------------------------------------------*
METHOD DeleteColumn( nColIndex, lRefresh ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
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
   If ::FixBlocks()
      _OOHG_DeleteArrayItem( ::aColumnBlocks,  nColIndex )
   EndIf
   If HB_IsArray( ::aReplaceField )
      _OOHG_DeleteArrayItem( ::aReplaceField,  nColIndex )
   EndIf
   nRet := ::Super:DeleteColumn( nColIndex )

   If ! HB_IsLogical( lRefresh ) .OR. lRefresh
      ::Refresh()
   EndIf
Return nRet

*-----------------------------------------------------------------------------*
METHOD SetColumn( nColIndex, xField, cHeader, nWidth, nJustify, uForeColor, ;
                  uBackColor, lNoDelete, uPicture, uEditControl, uHeadClick, ;
                  uValid, uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign, ;
                  uReplaceField, lRefresh ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
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
                              uValid, uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign )

   If ! HB_IsLogical( lRefresh ) .OR. lRefresh
      ::Refresh()
   EndIf
Return nRet

*-----------------------------------------------------------------------------*
METHOD VScrollVisible( lState ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
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





*-----------------------------------------------------------------------------*
CLASS ooHGRecord
*-----------------------------------------------------------------------------*
   DATA cAlias__

   METHOD New
   METHOD Use
   METHOD Skipper
   METHOD OrdScope
   METHOD Filter
   METHOD IsTableEmpty

   METHOD Field      BLOCK { | Self, nPos |                   ( ::cAlias__ )->( Field( nPos ) ) }
   METHOD FieldBlock BLOCK { | Self, cField |                 ( ::cAlias__ )->( FieldBlock( cField ) ) }
   METHOD FieldGet   BLOCK { | Self, nPos |                   ( ::cAlias__ )->( FieldGet( nPos ) ) }
   METHOD FieldName  BLOCK { | Self, nPos |                   ( ::cAlias__ )->( FieldName( nPos ) ) }
   METHOD FieldPos   BLOCK { | Self, cField |                 ( ::cAlias__ )->( FieldPos( cField ) ) }
   METHOD FieldPut   BLOCK { | Self, nPos, uValue |           ( ::cAlias__ )->( FieldPut( nPos, uValue ) ) }
   METHOD Locate     BLOCK { | Self, bFor, bWhile, nNext, nRec, lRest | ( ::cAlias__ )->( __dbLocate( bFor, bWhile, nNext, nRec, lRest ) ) }
   METHOD Seek       BLOCK { | Self, uKey, lSoftSeek, lLast | ( ::cAlias__ )->( DbSeek( uKey, lSoftSeek, lLast ) ) }
   METHOD Skip       BLOCK { | Self, nCount |                 ( ::cAlias__ )->( DbSkip( nCount ) ) }
   METHOD GoTo       BLOCK { | Self, nRecord |                ( ::cAlias__ )->( DbGoTo( nRecord ) ) }
   METHOD GoTop      BLOCK { | Self |                         ( ::cAlias__ )->( DbGoTop() ) }
   METHOD GoBottom   BLOCK { | Self |                         ( ::cAlias__ )->( DbGoBottom() ) }
   METHOD Commit     BLOCK { | Self |                         ( ::cAlias__ )->( DbCommit() ) }
   METHOD Unlock     BLOCK { | Self |                         ( ::cAlias__ )->( DbUnlock() ) }
   METHOD Delete     BLOCK { | Self |                         ( ::cAlias__ )->( DbDelete() ) }
   METHOD Close      BLOCK { | Self |                         ( ::cAlias__ )->( DbCloseArea() ) }
   METHOD BOF        BLOCK { | Self |                         ( ::cAlias__ )->( BOF() ) }
   METHOD EOF        BLOCK { | Self |                         ( ::cAlias__ )->( EOF() ) }
   METHOD RecNo      BLOCK { | Self |                         ( ::cAlias__ )->( RecNo() ) }
   METHOD RecCount   BLOCK { | Self |                         ( ::cAlias__ )->( RecCount() ) }
   METHOD Found      BLOCK { | Self |                         ( ::cAlias__ )->( Found() ) }
   METHOD SetOrder   BLOCK { | Self, uOrder |                 ( ::cAlias__ )->( ORDSETFOCUS( uOrder ) ) }
   METHOD SetIndex   BLOCK { | Self, cFile, lAdditive |       IF( EMPTY( lAdditive ), ( ::cAlias__ )->( ordListClear() ), ) , ( ::cAlias__ )->( ordListAdd( cFile ) ) }
   METHOD Append     BLOCK { | Self |                         ( ::cAlias__ )->( DbAppend() ) }
   METHOD Lock       BLOCK { | Self |                         ( ::cAlias__ )->( RLock() ) }
   METHOD DbStruct   BLOCK { | Self |                         ( ::cAlias__ )->( DbStruct() ) }
   METHOD OrdKeyNo   BLOCK { | Self |                         IF( ( ::cAlias__ )->( OrdKeyCount() ) > 0, ( ::cAlias__ )->( OrdKeyNo() ), ( ::cAlias__ )->( RecNo() ) ) }
   METHOD OrdKeyCount BLOCK { | Self |                        IF( ( ::cAlias__ )->( OrdKeyCount() ) > 0, ( ::cAlias__ )->( OrdKeyCount() ), ( ::cAlias__ )->( RecCount() ) ) }
   #ifdef __XHARBOUR__
   METHOD OrdKeyGoTo BLOCK { | Self, nRecord |                ( ::cAlias__ )->( OrdKeyGoTo( nRecord ) ) }
   #EndIf

   ERROR HANDLER FieldAssign
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD IsTableEmpty CLASS ooHGRecord
*-----------------------------------------------------------------------------*
LOCAL lEmpty

   IF ::EOF()
      IF ::BOF()
         lEmpty := .T.
      ELSE
         ::Skip( -1 )
         lEmpty := ::BOF()
         ::Skip( 1 )
      EndIf
   ELSE
      IF ::BOF()
         ::GoTop()
         lEmpty := ::EOF()
      ELSE
        lEmpty := .F.
      EndIf
   EndIf
Return lEmpty

*-----------------------------------------------------------------------------*
METHOD FieldAssign( xValue ) CLASS ooHGRecord
*-----------------------------------------------------------------------------*
LOCAL nPos, cMessage, uRet, cAlias, lError

   cAlias := ::cAlias__
   cMessage := ALLTRIM( UPPER( __GetMessage() ) )
   lError := .T.
   IF PCOUNT() == 0
      nPos := ( cAlias )->( FieldPos( cMessage ) )
      IF nPos > 0
         uRet := ( cAlias )->( FieldGet( nPos ) )
         lError := .F.
      EndIf
   ELSEIF PCOUNT() == 1
      nPos := ( cAlias )->( FieldPos( SUBSTR( cMessage, 2 ) ) )
      IF nPos > 0
         uRet := ( cAlias )->( FieldPut( nPos, xValue ) )
         lError := .F.
      EndIf
   EndIf
   IF lError
      uRet := Nil
      ::MsgNotFound( cMessage )
   EndIf
Return uRet

*-----------------------------------------------------------------------------*
METHOD New( cAlias ) CLASS ooHGRecord
*-----------------------------------------------------------------------------*
   IF ! ValType( cAlias ) $ "CM" .OR. EMPTY( cAlias )
      ::cAlias__ := ALIAS()
   ELSE
      ::cAlias__ := UPPER( ALLTRIM( cAlias ) )
   EndIf
Return Self

*-----------------------------------------------------------------------------*
METHOD Use( cFile, cAlias, cRDD, lShared, lReadOnly ) CLASS ooHGRecord
*-----------------------------------------------------------------------------*
   DbUseArea( .T., cRDD, cFile, cAlias, lShared, lReadOnly )
   ::cAlias__ := ALIAS()
Return Self

*-----------------------------------------------------------------------------*
METHOD Skipper( nSkip ) CLASS ooHGRecord
*-----------------------------------------------------------------------------*
LOCAL nCount

   nCount := 0
   nSkip := IF( ValType( nSkip ) == "N", INT( nSkip ), 1 )
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
            EndIf
         ELSE
            ::Skip( -1 )
            IF ::BOF()
               EXIT
            ELSE
               nCount --
               nSkip ++
            EndIf
         EndIf
      ENDDO
   EndIf
Return nCount

*-----------------------------------------------------------------------------*
METHOD OrdScope( uFrom, uTo ) CLASS ooHGRecord
*-----------------------------------------------------------------------------*
   IF PCOUNT() == 0
      ( ::cAlias )->( ORDSCOPE( 0, Nil ) )
      ( ::cAlias )->( ORDSCOPE( 1, Nil ) )
   ELSEIF PCOUNT() == 1
      ( ::cAlias )->( ORDSCOPE( 0, uFrom ) )
      ( ::cAlias )->( ORDSCOPE( 1, uFrom ) )
   ELSE
      ( ::cAlias )->( ORDSCOPE( 0, uFrom ) )
      ( ::cAlias )->( ORDSCOPE( 1, uTo ) )
   EndIf
Return Nil

*-----------------------------------------------------------------------------*
METHOD Filter( cFilter ) CLASS ooHGRecord
*-----------------------------------------------------------------------------*
   If EMPTY( cFilter )
      ( ::cAlias__ )->( DbClearFilter() )
   Else
      ( ::cAlias__ )->( DbSetFilter( { || &( cFilter ) } , cFilter ) )
   EndIf
Return Nil





CLASS TXBROWSEBYCELL FROM TXBrowse, TGridByCell
   DATA Type                INIT "XBROWSEBYCELL" READONLY

   METHOD AddColumn
   METHOD AppendItem
   METHOD CurrentCol        SETGET
   METHOD CurrentRow        SETGET
   METHOD Define2
   METHOD DeleteColumn
   METHOD DeleteItem
   METHOD EditCell
   METHOD EditCell2
   METHOD EditGrid                                   
   METHOD Events
   METHOD Events_Enter
   METHOD Events_Notify
   METHOD GoBottom
   METHOD GoTop
   METHOD IsColumnReadonly
   METHOD IsColumnWhen
   METHOD Left
   METHOD Refresh
   METHOD Right
   METHOD SetSelectedColors
   METHOD Value             SETGET     // it's used for painting the grid, it doesn't trigger on change event

   MESSAGE EditAllCells     METHOD EditGrid

/*
   Available methods from TGrid:
      AddItem
      ColumnBetterAutoFit
      ColumnCount
      ColumnOrder
      ColumnsBetterAutoFit
      ColumnShow
      CountPerPage
      DeleteAllItems
      ItemCount
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
      InsertItem
      Item
      ItemCount
      ItemHeight
      Justify
      LoadHeaderImages
      OnEnter
      Release
      ScrollToCol
      ScrollToLeft
      ScrollToNext
      ScrollToPrior
      ScrollToRight
      SetItemColor
      SetRangeColor
      SortColumn

   Available methods from TXBrowse:
      AdjustRightScroll
      CheckItem
      ColumnAutoFit
      ColumnAutoFitH
      ColumnBlock
      ColumnsAutoFit
      ColumnsAutoFitH
      ColumnWidth
      DbSkip
      Define
      Delete
      DoChange
      Down
      EditItem
      EditItem_B
      EditItem2
      Enabled
      FixBlocks
      GetCellType
      MoveTo
      PageDown
      PageUp
      RefreshData
      RefreshRow
      SetColumn
      SetScrollPos
      SizePos
      ToExcel
      ToOpenOffice
      TopBottom
      Up
      Visible
      VScrollVisible
      WorkArea
*/

   EMPTY( _OOHG_AllVars )
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD AddColumn( nColIndex, cCaption, nWidth, nJustify, uForeColor, uBackColor, ;
                  lNoDelete, uPicture, uEditControl, uHeadClick, uValid, ;
                  uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign ) CLASS TXBrowseByCell
*-----------------------------------------------------------------------------*
Local nCol

   nCol := ::CurrentCol
   nColIndex := ::Super:AddColumn( nColIndex, cCaption, nWidth, nJustify, uForeColor, uBackColor, ;
                                   lNoDelete, uPicture, uEditControl, uHeadClick, uValid, ;
                                   uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign )
   If nColIndex > 0
      If nCol == 0
         ::CurrentCol := nColIndex
      ElseIf nColIndex < nCol
         ::CurrentCol := nCol + 1
      EndIf
   EndIf
Return nColIndex

*-----------------------------------------------------------------------------*
METHOD AppendItem() CLASS TXBrowseByCell
*-----------------------------------------------------------------------------*
Return ::TGridByCell:AppendItem()

*-----------------------------------------------------------------------------*
METHOD CurrentCol( nValue ) CLASS TXBrowseByCell
*-----------------------------------------------------------------------------*
   If ! ::lLocked .AND. HB_IsNumeric( nValue ) .AND. nValue >= 0 .AND. nValue <= Len( ::aHeaders )
      ::nColPos := nValue
      ::Value := { ::CurrentRow, nValue }
   EndIf
Return ::nColPos

*-----------------------------------------------------------------------------*
METHOD CurrentRow( nValue ) CLASS TXBrowseByCell
*-----------------------------------------------------------------------------*
   If HB_IsNumeric( nValue ) .AND. ! ::lLocked
      nValue := ::Super:CurrentRow( nValue )

      ::Value := { nValue, ::CurrentCol }
   EndIf
Return ::Super:CurrentRow()

*-----------------------------------------------------------------------------*
METHOD Define2( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
                aRows, value, fontname, fontsize, tooltip, change, dblclick, ;
                aHeadClick, gotfocus, lostfocus, nogrid, aImage, aJust, ;
                break, HelpId, bold, italic, underline, strikeout, ownerdata, ;
                ondispinfo, itemcount, editable, backcolor, fontcolor, ;
                dynamicbackcolor, dynamicforecolor, aPicture, lRtl, nStyle, ;
                inplace, editcontrols, readonly, valid, validmessages, ;
                editcell, aWhenFields, lDisabled, lNoTabStop, lInvisible, ;
                lHasHeaders, onenter, aHeaderImage, aHeaderImageAlign, FullMove, ;
                aSelectedColors, aEditKeys, lCheckBoxes, oncheck, lDblBffr, ;
                lFocusRect, lPLM, lFixedCols, abortedit, click, lFixedWidths, ;
                bBeforeColMove, bAfterColMove, bBeforeColSize, bAfterColSize, ;
                bBeforeAutofit, lLikeExcel, lButtons, AllowDelete, onDelete, ;
                bDelWhen, DelMsg, lNoDelMsg, AllowAppend, onappend, lNoModal, ;
                lFixedCtrls, bHeadRClick, lClickOnCheckbox, lRClickOnCheckbox, ;
                lExtDbl ) CLASS TXBrowseByCell
*-----------------------------------------------------------------------------*
   Empty( nStyle )
   ASSIGN lFocusRect VALUE lFocusRect TYPE "L" DEFAULT .F.

   ::Super:Define2( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
                    aRows, value, fontname, fontsize, tooltip, change, dblclick, ;
                    aHeadClick, gotfocus, lostfocus, nogrid, aImage, aJust, ;
                    break, HelpId, bold, italic, underline, strikeout, ownerdata, ;
                    ondispinfo, itemcount, editable, backcolor, fontcolor, ;
                    dynamicbackcolor, dynamicforecolor, aPicture, lRtl, LVS_SINGLESEL, ;
                    InPlace, editcontrols, readonly, valid, validmessages, ;
                    editcell, aWhenFields, lDisabled, lNoTabStop, lInvisible, ;
                    lHasHeaders, onenter, aHeaderImage, aHeaderImageAlign, FullMove, ;
                    aSelectedColors, aEditKeys, lCheckBoxes, oncheck, lDblBffr, ;
                    lFocusRect, lPLM, lFixedCols, abortedit, click, lFixedWidths, ;
                    bBeforeColMove, bAfterColMove, bBeforeColSize, bAfterColSize, ;
                    bBeforeAutofit, lLikeExcel, lButtons, AllowDelete, onDelete, ;
                    bDelWhen, DelMsg, lNoDelMsg, AllowAppend, onappend, lNoModal, ;
                    lFixedCtrls, bHeadRClick, lClickOnCheckbox, lRClickOnCheckbox, ;
                    lExtDbl )

   // By default, search in the current column
   ::SearchCol := -1

   // This is not really needed because TGridByCell ignores it
   ::InPlace := .T.

Return Self

*-----------------------------------------------------------------------------*
METHOD DeleteColumn( nColIndex, lNoDelete ) CLASS TXBrowseByCell
*-----------------------------------------------------------------------------*
Local nCol, nLen

   nCol := ::CurrentCol
   nColIndex := ::Super:DeleteColumn( nColIndex, lNoDelete )
   If nColIndex > 0
      If nCol > nColIndex
         ::CurrentCol := nCol - 1
      ElseIf nCol == nColIndex
         nLen := Len( ::aHeaders )
         If nColIndex <= nLen
            ::CurrentCol := nCol
         ElseIf nLen == 0
            ::CurrentCol := 0
         Else
            ::CurrentCol := nLen
         EndIf
      Else
         ::CurrentCol := nCol
      EndIf
   EndIf
Return nColIndex

*-----------------------------------------------------------------------------*
METHOD DeleteItem( nItem )  CLASS TXBrowseByCell
*-----------------------------------------------------------------------------*
Local nRow, lRet

   nRow := ::CurrentRow
   lRet := ::Super:DeleteItem( nItem )
   If lRet
      If nRow == nItem
         ::CurrentRow := 0
         ::CurrentCol := 0
      EndIf
   EndIf
Return lRet

*-----------------------------------------------------------------------------*
METHOD EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, lAppend, nOnFocusPos ) CLASS TXBrowseByCell
*-----------------------------------------------------------------------------*
Local lRet := .F.

   ASSIGN nRow VALUE nRow TYPE "N" DEFAULT ::CurrentRow
   ASSIGN nCol VALUE nCol TYPE "N" DEFAULT ::CurrentCol
   If aScan( ::aHiddenCols, nCol ) == 0
      ::bPosition := 0
      If ::Super:EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, lAppend, nOnFocusPos )
         lRet := .T.
         // ::bPosition is set by TGridControl()
         If ::bPosition == 1                            // UP
            ::bPosition := 0
            ::Up()
         ElseIf ::bPosition == 2                        // RIGHT
            ::bPosition := 0
            ::Right( .F. )
            Do While ! ::Eof() .AND. aScan( ::aHiddenCols, ::CurrentCol ) # 0
               ::Right( .F. )
            EndDo
         ElseIf ::bPosition == 3                        // LEFT
            ::bPosition := 0
            ::Left()
            Do While ! ::Bof() .AND. aScan( ::aHiddenCols, ::CurrentCol ) # 0
               ::Left()
            EndDo
         ElseIf ::bPosition == 4                        // HOME
            ::bPosition := 0
            ::GoTop()
         ElseIf ::bPosition == 5                        // END
            ::bPosition := 0
            ::GoBottom( .F. )
         ElseIf ::bPosition == 6                        // DOWN
            ::bPosition := 0
            ::Down( .F. )
         ElseIf ::bPosition == 7                        // PRIOR
            ::bPosition := 0
            ::PageUp()
         ElseIf ::bPosition == 8                        // NEXT
            ::bPosition := 0
            ::PageDown( .F. )
         ElseIf ::bPosition == 9                        // MOUSE EXIT
            ::bPosition := 0
         Else
            ::bPosition := 0
         EndIf
      EndIf
   EndIf
Return lRet

*-----------------------------------------------------------------------------*
METHOD EditCell2( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, nOnFocusPos ) CLASS TXBrowseByCell
*-----------------------------------------------------------------------------*
   ASSIGN nRow VALUE nRow TYPE "N" DEFAULT ::CurrentRow
   ASSIGN nCol VALUE nCol TYPE "N" DEFAULT ::CurrentCol
Return ::Super:EditCell2( @nRow, @nCol, EditControl, uOldValue, @uValue, cMemVar, nOnFocusPos )

*-----------------------------------------------------------------------------*
METHOD EditGrid( nRow, nCol, lAppend, lOneRow ) CLASS TXBrowseByCell
*-----------------------------------------------------------------------------*
Local lSomethingEdited := .F.

   Empty( lOneRow )

   If ::lLocked .OR. ::FirstVisibleColumn == 0
      Return .F.
   EndIf

   ASSIGN nRow    VALUE nRow    TYPE "N" DEFAULT ::CurrentRow
   ASSIGN nCol    VALUE nCol    TYPE "N" DEFAULT ::CurrentCol
   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   ASSIGN lOneRow VALUE lOneRow TYPE "L" DEFAULT .F.

   If nRow < 1 .OR. nRow > ::ItemCount .OR. nCol < 1 .OR. nCol > Len( ::aHeaders )
      // Cell out of range
      Return .F.
   EndIf

   Do While nCol <= Len( ::aHeaders ) .AND. nRow <= ::ItemCount
      If ::IsColumnReadOnly( nCol )
         // Read only column
      ElseIf ! ::IsColumnWhen( nCol )
         // Not a valid WHEN
      ElseIf aScan( ::aHiddenCols, nCol ) > 0
         // Hidden column
      Else
         // Edit one cell
         If ! ::Super:EditCell( nRow, nCol, Nil, Nil, Nil, Nil, lAppend, Nil )
            If lAppend
               ::lAppendMode := .F.
               ::GoBottom()
            EndIf
            Exit
         EndIf

         lSomethingEdited := .T.
         If lAppend
            ::lAppendMode := .F.
            lAppend := .F.
            ::DoEvent( ::OnAppend, "APPEND" )
         EndIf
      EndIf

      /*
       * ::OnEditCell() may change ::CurrentRow and/or ::CurrentCol
       * using ::Up(), ::Down(), ::Left(), ::Right(), ::PageUp(),
       * ::PageDown(), ::GoTop() and/or ::GoBottom()
       */

      // ::bPosition is set by TGridControl()
      If ::bPosition == 1                            // UP
         ::Up()
         If ! ::FullMove
            Exit
         EndIf
      ElseIf ::bPosition == 2                        // RIGHT
         If ::FullMove
            ::Right( .F. )
            lAppend := ::Eof() .AND. ::AllowAppend
         ElseIf ::CurrentCol < Len( ::aHeaders )
            ::Right( .F. )
         Else
            Exit
         EndIf
      ElseIf ::bPosition == 3                        // LEFT
         If ::FullMove .OR. ::CurrentCol > 1
            ::Left()
         Else
            Exit
         EndIf
      ElseIf ::bPosition == 4                        // HOME
         ::GoTop()
         If ! ::FullMove
            Exit
         EndIf
      ElseIf ::bPosition == 5                        // END
         ::GoBottom( .F. )  
         If ! ::FullMove
            Exit
         EndIf
      ElseIf ::bPosition == 6                        // DOWN
         ::Down( .F. )
         If ::FullMove
            lAppend := ::Eof() .AND. ::AllowAppend
         Else
            Exit
         EndIf
      ElseIf ::bPosition == 7                        // PRIOR
         ::PageUp()
         If ! ::FullMove
            Exit
         EndIf
      ElseIf ::bPosition == 8                        // NEXT
         ::PageDown( .F. )
         If ::FullMove
            lAppend := ::Eof() .AND. ::AllowAppend
         Else
            Exit
         EndIf
      ElseIf ::bPosition == 9                        // MOUSE EXIT
         Exit
      Else                                           // OK
         If ::FullMove
            ::Right( .F. )
            lAppend := ::Eof() .AND. ::AllowAppend
         ElseIf ::CurrentCol < Len( ::aHeaders )
            ::Right( .F. )
         Else
            Exit
         EndIf
      EndIf

      If lAppend
         // Insert new row
         ::GoBottom( .T. )
         ::InsertBlank( ::ItemCount + 1 )
         ::CurrentRow := ::ItemCount
         ::CurrentCol := 1
         ::lAppendMode := .T.
         ::oWorkArea:GoTo( 0 )
      EndIf

      nRow := ::CurrentRow
      nCol := ::CurrentCol
   EndDo
   ::bPosition := 0

Return lSomethingEdited

*-----------------------------------------------------------------------------*
FUNCTION _OOHG_TXBrowseByCell_Events2( Self, hWnd, nMsg, wParam, lParam ) // CLASS TGridByCell
*-----------------------------------------------------------------------------*
Local aCellData, cWorkArea, uGridValue, nSearchCol

   Empty( hWnd )
   Empty( lParam )

   If nMsg == WM_CHAR
      If ! ::lLocked .AND. ::AllowEdit .AND. ( ::lLikeExcel .OR. EditControlLikeExcel( Self, ::CurrentCol ) ) .AND. ! ::IsColumnReadOnly( ::CurrentCol ) .AND. aScan( ::aHiddenCols, ::CurrentCol ) == 0
         ::EditCell( Nil, Nil, Nil, Chr( wParam ), Nil, Nil, .F., Nil )

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
            nSearchCol := ::CurrentCol
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
         If ValType( cWorkArea ) $ "CM" .AND. Empty( cWorkArea )
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
            ::GoBottom()
         Else
            ::Refresh( ::CountPerPage )
            ::DoChange()
         EndIf

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
      Case wParam == VK_LEFT
         ::Left()
         Return 0
      Case wParam == VK_RIGHT
         ::Right()
         Return 0
      EndCase

   ElseIf nMsg == WM_LBUTTONDBLCLK
      _PushEventInfo()
      _OOHG_ThisForm := ::Parent
      _OOHG_ThisType := 'C'
      _OOHG_ThisControl := Self

      aCellData := _GetGridCellData( Self )
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
      ElseIf ::IsColumnReadOnly( _OOHG_ThisItemColIndex )
         // Cell is readonly
         If ::lExtendDblClick .and. HB_IsBlock( ::OnDblClick )
            ::DoEvent( ::OnDblClick, "DBLCLICK" )
         EndIf
      ElseIf ! ::IsColumnWhen( _OOHG_ThisItemColIndex )
         // Not a valid WHEN
         If ::lExtendDblClick .and. HB_IsBlock( ::OnDblClick )
            ::DoEvent( ::OnDblClick, "DBLCLICK" )
         EndIf
      ElseIf aScan( ::aHiddenCols, _OOHG_ThisItemColIndex ) > 0
         // Cell is in a hidden column
         If ::lExtendDblClick .and. HB_IsBlock( ::OnDblClick )
            ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
         EndIf
      Else
         ::EditCell( _OOHG_ThisItemRowIndex, _OOHG_ThisItemColIndex, Nil, Nil, Nil, Nil, .F., Nil )
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

Return Nil

*-----------------------------------------------------------------------------*
METHOD Events_Enter() CLASS TXBrowseByCell
*-----------------------------------------------------------------------------*
Return ::TGridByCell:Events_Enter()

*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TXBrowseByCell
*-----------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam ), aCellData
Local nvKey, lGo, uRet

   If nNotify == NM_CLICK
      If ! ::lLocked .AND. ::FirstVisibleColumn # 0
         aCellData := _GetGridCellData( Self )
         ::MoveTo( aCellData[ 1 ], ::nRowPos )
         ::CurrentCol := aCellData[ 2 ]
      EndIf
      ::Value := { ::CurrentRow, ::CurrentCol }

      If HB_IsBlock( ::OnClick )
         If ! ::NestedClick
            ::NestedClick := ! _OOHG_NestedSameEvent()
            ::DoEventMouseCoords( ::OnClick, "CLICK" )
            ::NestedClick := .F.
         EndIf
      EndIf

      // Skip default action
      Return 1

   ElseIf nNotify == NM_RCLICK
      If ! ::lLocked .AND. ::FirstVisibleColumn # 0
         aCellData := _GetGridCellData( Self )
         ::MoveTo( aCellData[ 1 ], ::nRowPos )
         ::CurrentCol := aCellData[ 2 ]
      EndIf
      ::Value := { ::CurrentRow, ::CurrentCol }

      If HB_IsBlock( ::OnRClick )
         ::DoEventMouseCoords( ::OnRClick, "RCLICK" )
      EndIf

      // Fire context menu
      If ::ContextMenu != Nil
         ::ContextMenu:Cargo := _GetGridCellData( Self )
         ::ContextMenu:Activate()
      EndIf

      // Skip default action
      Return 1

   ElseIf nNotify == LVN_BEGINDRAG
      If ! ::lLocked .AND. ::FirstVisibleColumn # 0
         aCellData := _GetGridCellData( Self )
         ::MoveTo( aCellData[ 1 ], ::nRowPos )
      EndIf
      ::Value := { ::CurrentRow, ::CurrentCol }
      Return Nil

   ElseIf nNotify == LVN_KEYDOWN
      If ::FirstVisibleColumn # 0
         If GetGridvKeyAsChar( lParam ) == 0
            ::cText := ""
         EndIf

         nvKey := GetGridvKey( lParam )
         Do Case
         Case GetKeyFlagState() == MOD_ALT .AND. nvKey == VK_A
            If ::AllowAppend .AND. ! ::lLocked
               ::EditItem( .T., ! ::FullMove )
            EndIf

         Case nvKey == VK_DELETE
            If ::AllowDelete .and. ! ::Eof() .AND. ! ::lLocked
               If ValType(::bDelWhen) == "B"
                  lGo := _OOHG_Eval( ::bDelWhen )
               Else
                  lGo := .t.
               EndIf

               If lGo
                  If ::lNoDelMsg
                     ::Delete()
                  ElseIf MsgYesNo( _OOHG_Messages(4, 1), _OOHG_Messages(4, 2) )
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
      Return Nil

   ElseIf nNotify == NM_CUSTOMDRAW
      ::AdjustRightScroll()
      uRet := TGrid_Notify_CustomDraw( Self, lParam, .T., ::CurrentRow, ::CurrentCol, .F., ::lFocusRect, ::lNoGrid, ::lPLM )
      ListView_SetCursel( ::hWnd, ::CurrentRow )
      Return uRet

   EndIf
Return ::TGridByCell:Events_Notify( wParam, lParam )

*---------------------------------------------------------------------------*
METHOD GoBottom( lAppend ) CLASS TXBrowseByCell
*---------------------------------------------------------------------------*
   If ! ::lLocked
      ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
      ::Super:GoBottom( lAppend )
      If lAppend
         ::CurrentCol := 1
      Else
         ::CurrentCol := Len( ::aHeaders )
      EndIf
   EndIf
Return Self

*---------------------------------------------------------------------------*
METHOD GoTop() CLASS TXBrowseByCell
*---------------------------------------------------------------------------*
   If ! ::lLocked
      ::Super:GoTop()
      ::CurrentCol := 1
   EndIf
Return Self

*-----------------------------------------------------------------------------*
METHOD IsColumnReadOnly( nCol ) CLASS TXBrowseByCell
*-----------------------------------------------------------------------------*
Local uReadOnly

   uReadOnly := _OOHG_GetArrayItem( ::ReadOnly, nCol, ::Item( ::CurrentRow ) )
Return ( HB_IsLogical( uReadOnly ) .AND. uReadOnly )

*-----------------------------------------------------------------------------*
METHOD IsColumnWhen( nCol ) CLASS TXBrowseByCell
*-----------------------------------------------------------------------------*
Local uWhen

   uWhen := _OOHG_GetArrayItem( ::aWhen, nCol, ::Item( ::CurrentRow ) )
Return ( ! HB_IsLogical( uWhen ) .OR. uWhen )

*--------------------------------------------------------------------------*
METHOD Left() CLASS TXBrowseByCell
*--------------------------------------------------------------------------*
Local nRow, nCol

   nRow := ::CurrentRow
   nCol := ::CurrentCol
   If nRow >= 1 .AND. nRow <= ::ItemCount .AND. nCol >= 1 .AND. nCol <= Len( ::aHeaders )
      If nCol > 1
         ::CurrentCol := nCol - 1
      ElseIf ! ::lLocked .AND. ::FullMove
         ::Up()
         If ! ::Bof()
            ::CurrentCol := Len( ::aHeaders )
         EndIf
      EndIf
   EndIf
Return Self

*-----------------------------------------------------------------------------*
METHOD Refresh( nCurrent, lNoEmptyBottom ) CLASS TXBrowseByCell
*-----------------------------------------------------------------------------*
   ::Super:Refresh( nCurrent, lNoEmptyBottom )
   ::Value := { ::CurrentRow, ::CurrentCol }
Return Self

*--------------------------------------------------------------------------*
METHOD Right( lAppend ) CLASS TXBrowseByCell
*--------------------------------------------------------------------------*
Local nRow, nCol

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT ::AllowAppend
   nRow := ::CurrentRow
   nCol := ::CurrentCol
   If nRow >= 1 .AND. nRow <= ::ItemCount .AND. nCol >= 1 .AND. nCol <= Len( ::aHeaders )
      If nCol < Len( ::aHeaders )
         ::CurrentCol := nCol + 1
      ElseIf ! ::lLocked .AND. ::FullMove
         ::Down( .F. )
         If ::Eof()
            If lAppend
               ::EditItem( .T., ! ::FullMove )
            EndIf
         Else
            ::CurrentCol := 1
         EndIf
      EndIf
   EndIf
Return Self

*-----------------------------------------------------------------------------*
METHOD SetSelectedColors( aSelectedColors, lRedraw ) CLASS TXBrowseByCell
*-----------------------------------------------------------------------------*
Return ::TGridByCell:SetSelectedColors( aSelectedColors, lRedraw )

*-----------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TXBrowseByCell
*-----------------------------------------------------------------------------*
Local r, nClientWidth, nScrollWidth, nRow, nCol

   If HB_IsArray( uValue ) .AND. Len( uValue ) > 1 .AND. HB_IsNumeric( uValue[ 1 ] ) .AND. uValue[ 1 ] <= ::ItemCount .AND. HB_IsNumeric( uValue[ 2 ] ) .AND. uValue[ 2 ] >= 1 .AND. uValue[ 2 ] <= Len( ::aHeaders )
      nRow := ::Super:Value( uValue[ 1 ] )
      nCol := uValue[ 2 ]
      If nRow > 0
         // Ensure cell is visible
         r := { 0, 0, 0, 0 }                                        // left, top, right, bottom
         GetClientRect( ::hWnd, r )
         nClientWidth := r[ 3 ] - r[ 1 ]
         r := ListView_GetSubitemRect( ::hWnd, nRow - 1, nCol - 1 ) // top, left, width, height
         If ListViewGetItemCount( ::hWnd ) >  ListViewGetCountPerPage( ::hWnd )
            nScrollWidth := GetVScrollBarWidth()
         Else
            nScrollWidth := 0
         EndIf
         If r[ 2 ] + r[ 3 ] + nScrollWidth > nClientWidth
            ListView_Scroll( ::hWnd, ( r[ 2 ] + r[ 3 ] + nScrollWidth - nClientWidth ), 0 )
         EndIf
         If r[ 2 ] < 0
            ListView_Scroll( ::hWnd, r[ 2 ], 0 )
         EndIf
         ListView_RedrawItems( ::hWnd, nRow, nRow )
      EndIf
   Else
      nRow := ::CurrentRow
      nCol := ::CurrentCol
   EndIf
Return { nRow, nCol }

#pragma BEGINDUMP

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

// -----------------------------------------------------------------------------
HB_FUNC_STATIC( TXBROWSEBYCELL_EVENTS )   // METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TXBrowseByCell
// -----------------------------------------------------------------------------
{
   HWND hWnd      = HWNDparam( 1 );
   UINT message   = ( UINT )   hb_parni( 2 );
   WPARAM wParam  = ( WPARAM ) hb_parni( 3 );
   LPARAM lParam  = ( LPARAM ) hb_parnl( 4 );
   PHB_ITEM pSelf = hb_stackSelfItem();
   static PHB_SYMB s_Events2 = 0;
   static PHB_SYMB s_Notify2 = 0;
   BOOL bDefault = TRUE;

   switch( message )
   {
      case WM_CHAR:
      case WM_KEYDOWN:
      case WM_LBUTTONDOWN:
      case WM_RBUTTONDOWN:
      case WM_LBUTTONDBLCLK:
      case WM_MOUSEWHEEL:
         if( ! s_Events2 )
         {
            s_Events2 = hb_dynsymSymbol( hb_dynsymFind( "_OOHG_TXBROWSEBYCELL_EVENTS2" ) );
         }
         hb_vmPushSymbol( s_Events2 );
         hb_vmPushNil();
         hb_vmPush( pSelf );
         HWNDpush( hWnd );
         hb_vmPushLong( message );
         hb_vmPushLong( wParam );
         hb_vmPushLong( lParam );
         hb_vmDo( 5 );
         if( HB_ISNUM( -1 ) )
         {
            bDefault = FALSE;
         }
         break;

      case WM_NOTIFY:
         if( ( ( NMHDR FAR * ) lParam )->hwndFrom == ( HWND ) SendMessage( hWnd, LVM_GETHEADER, 0, 0 ) )
         {
            if( ! s_Notify2 )
            {
               s_Notify2 = hb_dynsymSymbol( hb_dynsymFind( "_OOHG_TGRID_NOTIFY2" ) );
            }
            hb_vmPushSymbol( s_Notify2 );
            hb_vmPushNil();
            hb_vmPush( pSelf );
            hb_vmPushLong( wParam );
            hb_vmPushLong( lParam );
            hb_vmDo( 3 );
            if( HB_ISNUM( -1 ) )
            {
               bDefault = FALSE;
            }
         }
         break;
   }

   if( bDefault )
   {
      _OOHG_Send( pSelf, s_Super );
      hb_vmSend( 0 );
      _OOHG_Send( hb_param( -1, HB_IT_OBJECT ), s_Events );
      HWNDpush( hWnd );
      hb_vmPushLong( message );
      hb_vmPushLong( wParam );
      hb_vmPushLong( lParam );
      hb_vmSend( 4 );
   }
}

#pragma ENDDUMP

*-----------------------------------------------------------------------------*
FUNCTION SetXBrowseFixedBlocks( lValue )
*-----------------------------------------------------------------------------*
   IF ValType( lValue ) == "L"
      _OOHG_XBrowseFixedBlocks := lValue
   EndIf
Return _OOHG_XBrowseFixedBlocks

*-----------------------------------------------------------------------------*
FUNCTION SetXBrowseFixedControls( lValue )
*-----------------------------------------------------------------------------*
   IF ValType( lValue ) == "L"
      _OOHG_XBrowseFixedControls := lValue
   EndIf
Return _OOHG_XBrowseFixedControls
