/*
 * $Id: h_xbrowse.prg,v 1.71 2012-09-17 00:29:58 fyurisich Exp $
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

CLASS TXBROWSE FROM TGrid
   DATA Type              INIT "XBROWSE" READONLY
   DATA aFields           INIT nil
   DATA oWorkArea         INIT nil
   DATA uWorkArea         INIT nil
   DATA VScroll           INIT nil
   DATA ScrollButton      INIT nil
   DATA nValue            INIT 0
   DATA AllowAppend       INIT .F.
   DATA AllowDelete       INIT .F.
   DATA aReplaceField     INIT nil
   DATA Lock              INIT .F.
   DATA skipBlock         INIT nil
   DATA goTopBlock        INIT nil
   DATA goBottomBlock     INIT nil
   DATA lLocked           INIT .F.
   DATA lRecCount         INIT .F.
   DATA lDescending       INIT .F.
   DATA Eof               INIT .F.
   DATA Bof               INIT .F.
   DATA bDelWhen          INIT nil
   DATA DelMsg            INIT nil
   DATA onDelete          INIT nil
   DATA RefreshType       INIT nil
   DATA SearchWrap        INIT .F.

   METHOD Define
   METHOD Refresh
   METHOD RefreshRow
   METHOD ColumnBlock
   METHOD MoveTo
   METHOD CurrentRow       SETGET
   METHOD DoChange         BLOCK { |Self| ::DoEvent( ::OnChange, "CHANGE" ) }

   METHOD SizePos
   METHOD Enabled          SETGET
   METHOD Visible          SETGET
   METHOD RefreshData

   METHOD Events
   METHOD Events_Notify

   METHOD DbSkip
   METHOD Up
   METHOD Down
   METHOD TopBottom
   METHOD GoTop
   METHOD GoBottom
   METHOD PageUp
   METHOD PageDown
   METHOD SetScrollPos

   METHOD Delete
   METHOD EditItem
   METHOD EditItem_B
   METHOD EditCell
   METHOD EditAllCells
   METHOD GetCellType

   METHOD AdjustRightScroll

   METHOD ColumnWidth
   METHOD ColumnAutoFit
   METHOD ColumnAutoFitH
   METHOD ColumnsAutoFit
   METHOD ColumnsAutoFitH

   METHOD WorkArea         SETGET

   METHOD ToExcel

   METHOD AddColumn
   METHOD DeleteColumn
/* from grid:
   METHOD AddItem
   METHOD InsertItem
   METHOD DeleteItem
   METHOD DeleteAllItems      BLOCK { | Self | ListViewReset( ::hWnd ), ::GridForeColor := nil, ::GridBackColor := nil }
   METHOD Item
   METHOD ItemCount           BLOCK { | Self | ListViewGetItemCount( ::hWnd ) }
*/
/* tbrowse:
   METHOD SetColumn( nColumn, oCol )      // Replaces one TBColumn object with another
*/
   MESSAGE EditGrid METHOD EditAllCells

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
               lRecCount, columninfo, lNoHeaders, onenter, lDisabled, ;
               lNoTabStop, lInvisible, lDescending, bDelWhen, DelMsg, ;
               onDelete, aHeaderImage, aHeaderImageAlign, FullMove, ;
               aSelectedColors, aEditKeys, lDblBffr, lFocusRect, lPLM, ;
               lFixedCols, abortedit, click ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local nWidth2, nCol2, lLocked, oScroll, z

   ASSIGN ::aFields  VALUE aFields  TYPE "A"
   ASSIGN ::aHeaders VALUE aHeaders TYPE "A" DEFAULT {}
   ASSIGN ::aWidths  VALUE aWidths  TYPE "A" DEFAULT {}
   ASSIGN ::aJust    VALUE aJust    TYPE "A" DEFAULT {}

   ASSIGN ::lDescending VALUE lDescending TYPE "L"

   If ValType( columninfo ) == "A" .AND. LEN( columninfo ) > 0
      If ValType( ::aFields ) == "A"
         ASIZE( ::aFields,  LEN( columninfo ) )
      Else
         ::aFields := ARRAY( LEN( columninfo ) )
      Endif
      ASIZE( ::aHeaders, LEN( columninfo ) )
      ASIZE( ::aWidths,  LEN( columninfo ) )
      ASIZE( ::aJust,    LEN( columninfo ) )
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
      AEVAL( ::aFields, { |x,i| ::aFields[ i ] := ::oWorkArea:cAlias__ + "->" + x[ 1 ] } )
   EndIf

   aSize( ::aHeaders, len( ::aFields ) )
   aEval( ::aHeaders, { |x,i| ::aHeaders[ i ] := iif( ! ValType( x ) $ "CM", if( valtype( ::aFields[ i ] ) $ "CM", ::aFields[ i ], "" ), x ) } )

   aSize( ::aWidths, len( ::aFields ) )
   aEval( ::aWidths, { |x,i| ::aWidths[ i ] := iif( ! ValType( x ) == "N", 100, x ) } )

   ASSIGN w         VALUE w         TYPE "N" DEFAULT ::nWidth
   ASSIGN novscroll VALUE novscroll TYPE "L" DEFAULT .F.
   nWidth2 := if( novscroll, w, w - GETVSCROLLBARWIDTH() )

   ::Define2( ControlName, ParentForm, x, y, nWidth2, h, ::aHeaders, aWidths, ;
              ,, fontname, fontsize, tooltip,,, ;
              aHeadClick,,, nogrid, aImage, ::aJust, ;
              break, HelpId, bold, italic, underline, strikeout,, ;
              ,, editable, backcolor, fontcolor, dynamicbackcolor, ;
              dynamicforecolor, aPicture, lRtl, LVS_SINGLESEL, ;
              inplace, editcontrols, readonly, valid, validmessages, ;
              editcell, aWhenFields, lDisabled, lNoTabStop, lInvisible, ;
              lNoHeaders,, aHeaderImage, aHeaderImageAlign, FullMove, ;
              aSelectedColors, aEditKeys, , , lDblBffr, lFocusRect, lPLM, ;
              lFixedCols, abortedit, click )

   ::nWidth := w

   ASSIGN ::Lock          VALUE lock          TYPE "L"
   ASSIGN ::AllowDelete   VALUE AllowDelete   TYPE "L"
   ASSIGN ::AllowAppend   VALUE AllowAppend   TYPE "L"
   ASSIGN ::aReplaceField VALUE replacefields TYPE "A"
   ASSIGN ::lRecCount     VALUE lRecCount     TYPE "L"

   If ! novscroll

      IF ::lRtl .AND. ! ::Parent:lRtl
         ::nCol := ::nCol + GETVSCROLLBARWIDTH()
         nCol2 := -GETVSCROLLBARWIDTH()
      Else
         nCol2 := nWidth2
      ENDIF

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

      // It forces to hide "additional" controls when it's inside a
      // non-visible TAB page.
      ::Visible := ::Visible
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
   ASSIGN ::DelMsg      VALUE DelMsg      TYPE "C"
   ASSIGN ::OnDelete    VALUE onDelete    TYPE "B"

Return Self

*-----------------------------------------------------------------------------*
METHOD Refresh( nCurrent, lNoEmptyBottom ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local nRow, nCount, nSkipped
   If Empty( ::WorkArea ) .OR. ( ValType( ::WorkArea ) $ "CM" .AND. Select( ::WorkArea ) == 0 )
      // No workarea specified...
   ElseIf ! ::lLocked
      nCount := ::CountPerPage
      ASSIGN nCurrent       VALUE nCurrent       TYPE "N" DEFAULT ::CurrentRow
      ASSIGN lNoEmptyBottom VALUE lNoEmptyBottom TYPE "L" DEFAULT .F.
      nCurrent := MAX( MIN( nCurrent, nCount ), 1 )
      // Top of screen
      nCurrent := ( - ::DbSkip( - ( nCurrent - 1 ) ) ) + 1
      // Draws rows
      nRow := 1
      Do While .T.
         ::RefreshRow( nRow )
         If nRow < nCount
            If ::DbSkip( 1 ) == 1
               nRow++
            Else
               If lNoEmptyBottom
                  nSkipped := ( - ::DbSkip( - ( nCount - 1 ) ) ) + 1
                  nCurrent := nCurrent + ( nSkipped - nRow )
                  nRow := 1
                  lNoEmptyBottom := .F.
               Else
                  Exit
               EndIf
            EndIf
         Else
            Exit
         EndIf
      EndDo
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
   EndIf
Return Self

*-----------------------------------------------------------------------------*
METHOD RefreshRow( nRow ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local aItem, cWorkArea
   If ! ::lLocked
      cWorkArea := ::WorkArea
      If ValType( cWorkArea ) $ "CM" .AND. Empty( cWorkArea )
         cWorkArea := nil
      EndIf
      aItem := ARRAY( LEN( ::aFields ) )
      AEVAL( aItem, { |x,i| aItem[ i ] := EVAL( ::ColumnBlock( i ), cWorkArea ), x } )
      AEVAL( aItem, { |x,i| IF( VALTYPE( x ) $ "CM", aItem[ i ] := TRIM( x ),  ) } )

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
   IF ! VALTYPE( nCol ) == "N" .OR. nCol < 1 .OR. nCol > LEN( ::aFields )
      RETURN { || "" }
   ENDIF
   cWorkArea := ::WorkArea
   If ValType( cWorkArea ) $ "CM" .AND. Empty( cWorkArea )
      cWorkArea := nil
   EndIf
   cValue := ::aFields[ nCol ]
   bRet := nil
   If ! lDirect
      oEditControl := GetEditControlFromArray( NIL, ::EditControls, nCol, Self )
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
         uPicture := IF( Len( uPicture ) < nCol, nil, uPicture[ nCol ] )
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
   If bRet == nil
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

Function TXBrowse_UpDate_PerType( uValue )
Local cType := ValType( uValue )
   If     cType == "C"
      uValue := rTrim( uValue )
   ElseIf cType == "N"
      uValue := lTrim( Str( uValue ) )
   ElseIf cType == "L"
      uValue := IIF( uValue, ".T.", ".F." )
   ElseIf cType == "D"
      uValue := Dtoc( uValue )
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
   If ! ::lLocked
      ASSIGN nTo   VALUE nTo   TYPE "N" DEFAULT ::CurrentRow
      ASSIGN nFrom VALUE nFrom TYPE "N" DEFAULT ::nValue
      nFrom := Max( Min( nFrom, ::ItemCount ), 1 )
      nTo   := Max( Min( nTo,   ::CountPerPage ), 1 )
      ::RefreshRow( nFrom )
      Do While nFrom != nTo
         If nFrom > nTo
            If ::DbSkip( -1 ) != 0
               nFrom--
               ::RefreshRow( nFrom )
            Else
               Exit
            EndIf
         Else
            If ::DbSkip( 1 ) != 0
               nFrom++
               ::RefreshRow( nFrom )
            Else
               Exit
            EndIf
         EndIf
      EndDo
      ::CurrentRow := nFrom
      ::DoChange()
   EndIf
Return Self

*-----------------------------------------------------------------------------*
METHOD CurrentRow( nValue ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local oVScroll, aPosition
   If ValType( nValue ) == "N" .AND. ! ::lLocked
      ::nValue := nValue
      oVScroll := ::VScroll
      If oVScroll != NIL
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

   If ::VScroll != nil
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
      AEVAL( ::aControls, { |o| o:SizePos() } )

      /* This two instructions force the redrawn of the control's area
       * that is been overwritten by the scrollbars.
       */
      ::ScrollButton:Visible := .T.
   else
      uRet := MoveWindow( ::hWnd, ::ContainerCol, ::ContainerRow, ::nWidth, ::nHeight , .T. )
   EndIf

   IF ! ::AdjustRightScroll()
      ::Refresh()
   ENDIF
Return uRet

*------------------------------------------------------------------------------*
METHOD Enabled( lEnabled ) CLASS TXBrowse
*------------------------------------------------------------------------------*
   IF VALTYPE( lEnabled ) == "L"
      ::Super:Enabled := lEnabled
      AEVAL( ::aControls, { |o| o:Enabled := o:Enabled } )
   ENDIF
RETURN ::Super:Enabled

*------------------------------------------------------------------------------*
METHOD ToExcel( cTitle ) CLASS TXBrowse
*------------------------------------------------------------------------------*
Local LIN := 4
LOCAL oExcel, oHoja, i

   default ctitle to ""
   ///oExcel := CreateObject( "Excel.Application" )
   oExcel := TOleAuto():New( "Excel.Application" )
   IF Ole2TxtError() != 'S_OK'
      MsgStop('Excel not found','error')
      RETURN Nil
   ENDIF
   oExcel:WorkBooks:Add()
   oHoja := oExcel:ActiveSheet()
   ////oHoja := oExcel:Get( "ActiveSheet" )
   oHoja:Cells:Font:Name := "Arial"
   oHoja:Cells:Font:Size := 10

   oHoja:Cells( 1, 1 ):Value := upper( cTitle )
   oHoja:Cells( 1, 1 ):font:bold := .T.

   for i:= 1 to len( ::aHeaders )
      oHoja:Cells( LIN, i ):Value := upper( ::aHeaders[i] )
      oHoja:Cells( LIN, i ):font:bold:= .T.
   next i
   LIN++
   LIN++
   ::GoTop()
   Do While ! ::Eof()
      for i:= 1 to len ( ::aFields )
         oHoja:Cells( LIN, i ):Value := &( ::aFields[i] )
      next i
      ::DbSkip()
      LIN++
   Enddo

   FOR i := 1 TO LEN( ::aHeaders )
      oHoja:Columns( i ):AutoFit()
   NEXT

   oHoja:Cells( 1, 1 ):Select()
   oExcel:Visible := .T.

   oHoja  := NIL
   oExcel := NIL

RETURN nil

*------------------------------------------------------------------------------*
METHOD Visible( lVisible ) CLASS TXBrowse
*------------------------------------------------------------------------------*
   IF VALTYPE( lVisible ) == "L"
      ::Super:Visible := lVisible
      AEVAL( ::aControls, { |o| o:Visible := lVisible } )
      ProcessMessages()
   ENDIF
RETURN ::lVisible

*-----------------------------------------------------------------------------*
METHOD RefreshData() CLASS TXBrowse
*-----------------------------------------------------------------------------*
   ::Refresh()
RETURN ::Super:RefreshData()

*-----------------------------------------------------------------------------*
METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
   If nMsg == WM_CHAR
      Return 0
   EndIf
Return ::Super:Events( hWnd, nMsg, wParam, lParam )

*-----------------------------------------------------------------------------*
FUNCTION TXBrowse_Events_Notify2( wParam, lParam )
*-----------------------------------------------------------------------------*
Local Self := QSelf()
Local nNotify := GetNotifyCode( lParam )
Local nvKey, lGo

   If nNotify == NM_CLICK  .or. nNotify == LVN_BEGINDRAG
      If ! ::lLocked
         ::MoveTo( ::CurrentRow, ::nValue )
      Else
         ::Super:Value := ::nValue
      EndIf
      Return nil

   ElseIf nNotify == LVN_KEYDOWN
      If GetGridvKeyAsChar( lParam ) == 0
         ::cText := ""
      EndIf

      nvKey := GetGridvKey( lParam )
      Do Case
         Case GetKeyFlagState() == MOD_ALT .AND. nvKey == 65 // A
            If ::AllowAppend .AND. ! ::lLocked
               ::EditItem( .T. )
            EndIf

         Case nvKey == 46 // DEL
            If ::AllowDelete .and. ! ::Eof() .AND. ! ::lLocked
               If valtype(::bDelWhen) == "B"
                  lGo := _OOHG_EVAL(::bDelWhen)
               Else
                  lGo := .t.
               EndIf

               If lGo
                  If MsgYesNo(_OOHG_Messages(4, 1), _OOHG_Messages(4, 2))
                     ::Delete()
                  EndIf
               ElseIf ! Empty( ::DelMsg )
                  MsgExclamation(::DelMsg, _OOHG_Messages(4, 2))
               EndIf
            EndIf

         Case nvKey == 36 // HOME
            ::GoTop()
            Return 1

         Case nvKey == 35 // END
            ::GoBottom()
            Return 1

         Case nvKey == 33 // PGUP
            ::PageUp()
            Return 1

         Case nvKey == 34 // PGDN
            ::PageDown()
            Return 1

         Case nvKey == 38 // UP
            ::Up()
            Return 1

         Case nvKey == 40 // DOWN
            ::Down()
            Return 1

      EndCase
      Return nil

   ElseIf nNotify == LVN_ITEMCHANGED
      If GetGridOldState( lParam ) == 0 .and. GetGridNewState( lParam ) != 0
         Return nil
      EndIf

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
            DO EVENTS
         EndIf
         ::InsertBlank( 1 )
      Else
         nValue--
      EndIf
      ::RefreshRow( nValue )
      ::CurrentRow := nValue
      ::DoChange()
   EndIf
Return Self

*-----------------------------------------------------------------------------*
METHOD Down() CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local nValue
   If ::lNestedEdit .OR. ::lLocked
      // Do not move
   ElseIf ::DbSkip( 1 ) == 1
      nValue := ::CurrentRow
      If nValue >= ::CountPerPage
         ::DeleteItem( 1 )
      Else
         nValue++
      EndIf
      ::RefreshRow( nValue )
      ::CurrentRow := nValue
      ::DoChange()
   ElseIf ::AllowAppend
      ::EditItem( .T. )
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
METHOD PageDown() CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local nSkip, nCountPerPage
   If ::lNestedEdit .OR. ::lLocked
      // Do not move
   Else
      nCountPerPage := ::CountPerPage
      nSkip := ::DbSkip( nCountPerPage )
      If nSkip != nCountPerPage
         ::Refresh( nCountPerPage )
         ::DoChange()
         If ::AllowAppend
            ::EditItem( .T. )
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
   If nDir == 1
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
   Endif
   ::Bof := .F.
   ::Eof := ::oWorkArea:Eof()
Return nil

*-----------------------------------------------------------------------------*
METHOD GoTop() CLASS TXBrowse
*-----------------------------------------------------------------------------*
   If ! ::lLocked
      ::TopBottom( -1 )
      ::Refresh( 1 )
      ::DoChange()
   EndIf
Return Self

*-----------------------------------------------------------------------------*
METHOD GoBottom( lAppend ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   If ! ::lLocked
      ::TopBottom( 1 )
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
            ::TopBottom( -1 )
            ::DbSkip( MAX( nPos - 1, 0 ) )
         Else
            ::TopBottom( 1 )
            ::DbSkip( - MAX( aPosition[ 2 ] - nPos - 1, 0 ) )
         EndIf
      #endif
      ::Refresh( , .T. )
      ::DoChange()
   EndIf
Return Self

*-----------------------------------------------------------------------------*
METHOD Delete() CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local Value

   Value := ::CurrentRow
   If Value == 0
      Return .F.
   EndIf

   If ::Lock
      If ! ::oWorkArea:Lock()
         MsgExclamation( _OOHG_Messages(3, 9), _OOHG_Messages(4, 2) )
         Return .F.
      Endif
   EndIf

   ::oWorkArea:Delete()

   // Do before unlocking record or moving record pointer
   // so block can operate on deleted record (e.g. to copy to a log).
   _OOHG_Eval(::OnDelete)

   If ::Lock
      ::oWorkArea:Commit()
      ::oWorkArea:UnLock()
   EndIf

   If ::DbSkip( 1 ) == 0
      ::GoBottom()
   Else
      ::Refresh()
   EndIf
   ::DoChange()
Return .T.

*-----------------------------------------------------------------------------*
METHOD EditItem( lAppend ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local uRet
   uRet := nil
   If ! ::lNestedEdit
      ::lNestedEdit := .T.
      If ::VScroll != nil
         // Kills scrollbar's events...
         ::VScroll:Enabled := .F.
         ::VScroll:Enabled := .T.
      EndIf
      uRet := ::EditItem_B( lAppend )
      ::lNestedEdit := .F.
   EndIf
Return uRet

*-----------------------------------------------------------------------------*
METHOD EditItem_B( lAppend ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local oWorkArea, cTitle, z, nOld
Local uOldValue, oEditControl, cMemVar, bReplaceField
Local aItems, aEditControls, aMemVars, aReplaceFields

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.

   oWorkArea := ::oWorkArea
   If oWorkArea:Eof()
      If ! lAppend .AND. ! ::AllowAppend
         Return .F.
      Else
         lAppend := .T.
      Endif
   EndIf

   If ::InPlace
      If lAppend
         ::GoBottom( .T. )
         ::InsertBlank( ::ItemCount + 1 )
         ::CurrentRow := ::ItemCount
         oWorkArea:GoTo( 0 )
      EndIf
      Return ::EditAllCells( ,, lAppend )
   EndIf

   If lAppend
      cTitle := _OOHG_Messages( 2, 1 )
      nOld := oWorkArea:RecNo()
      oWorkArea:GoTo( 0 )
   Else
      cTitle := if( ValType( ::cRowEditTitle ) $ "CM", ::cRowEditTitle, _OOHG_Messages( 2, 2 ) )
   EndIf

   aItems := ARRAY( Len( ::aHeaders ) )
   aEditControls := ARRAY( Len( aItems ) )
   aMemVars := ARRAY( Len( aItems ) )
   aReplaceFields := ARRAY( Len( aItems ) )
   For z := 1 To Len( aItems )
      oEditControl := uOldValue := cMemVar := bReplaceField := nil
      ::GetCellType( z, @oEditControl, @uOldValue, @cMemVar, @bReplaceField )
      If ValType( uOldValue ) $ "CM"
         uOldValue := AllTrim( uOldValue )
      EndIf
      // MixedFields??? If field is from other workarea...
      aEditControls[ z ] := oEditControl
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
         ::SetFocus()
         Return .F.
      EndIf
   EndIf

   If ! EMPTY( oWorkArea:cAlias__ )
      aItems := ( oWorkArea:cAlias__ )->( ::EditItem2( ::CurrentRow, aItems, aEditControls, aMemVars, cTitle ) )
   Else
      aItems := ::EditItem2( ::CurrentRow, aItems, aEditControls, aMemVars, cTitle )
   EndIf

   If ! Empty( aItems )

      If lAppend
         oWorkArea:Append()
      EndIf

      For z := 1 To Len( aItems )

         If ::IsColumnReadOnly( z )
            // Readonly field
         Else
            _OOHG_EVAL( aReplaceFields[ z ], aItems[ z ], oWorkArea )
         EndIf

      Next z

      If lAppend
         If ! EMPTY( oWorkArea:cAlias__ )
            ( oWorkArea:cAlias__ )->( ::DoEvent( ::OnAppend, "APPEND" ) )
         Else
            ::DoEvent( ::OnAppend, "APPEND" )
         EndIf
      EndIf

      If ::RefreshType # 1
         ::Refresh()
      Else
         ::RefreshRow( ::CurrentRow )
      EndIf
      _SetThisCellInfo( ::hWnd, 0, 0, nil )
      _OOHG_Eval( ::OnEditCell, ::CurrentRow, 0 )
      _ClearThisCellInfo()

   Else
      If lAppend
         oWorkArea:GoTo( nOld )
      EndIf
      _OOHG_Eval( ::OnAbortEdit, ::CurrentRow, 0 )
   EndIf

   If ::Lock
      oWorkArea:Commit()
      oWorkArea:Unlock()
   EndIf

   ::SetFocus()
Return .T.

*-----------------------------------------------------------------------------*
METHOD EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, lAppend ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local lRet, bReplaceField, oWorkArea
   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   ASSIGN nRow    VALUE nRow    TYPE "N" DEFAULT ::CurrentRow
   ASSIGN nCol    VALUE nCol    TYPE "N" DEFAULT 1
   If nRow < 1 .OR. nRow > ::ItemCount() .OR. nCol < 1 .OR. nCol > Len( ::aHeaders )
      // Cell out of range
      lRet := .F.
   ElseIf ::IsColumnReadOnly( nCol )
      // Read only column
      PlayHand()
      lRet := .F.
   ElseIf ::oWorkArea:EOF() .AND. ! lAppend .AND. ! ::AllowAppend
      // "fake" record, and don't allows append
      lRet := .F.
   Else
      oWorkArea := ::oWorkArea
      If oWorkArea:EOF()
         lAppend := .T.
      Endif

      // If LOCK clause is present, try to lock.
      If lAppend
         //

      ElseIf ::Lock .AND. ! oWorkArea:Lock()
         MsgExclamation( _OOHG_Messages( 3, 9 ), _OOHG_Messages( 3, 10 ) )
         Return .F.
      EndIf

      ::GetCellType( nCol, @EditControl, @uOldValue, @cMemVar, @bReplaceField )

      lRet := ::EditCell2( @nRow, @nCol, EditControl, uOldValue, @uValue, cMemVar )
      If lRet
         If lAppend
            oWorkArea:Append()
         EndIf
         _OOHG_EVAL( bReplaceField, uValue, oWorkArea )
         If lAppend
            If ! EMPTY( oWorkArea:cAlias__ )
               ( oWorkArea:cAlias__ )->( ::DoEvent( ::OnAppend, "APPEND" ) )
            Else
               ::DoEvent( ::OnAppend, "APPEND" )
            EndIf
         EndIf
         ::RefreshRow( nRow )
         _SetThisCellInfo( ::hWnd, nRow, nCol, uValue )
         _OOHG_EVAL( ::OnEditCell, nRow, nCol )
         _ClearThisCellInfo()
      Else
         _OOHG_EVAL( ::OnAbortEdit, nRow, nCol )
      EndIf
      If ::Lock
         oWorkArea:Commit()
         oWorkArea:UnLock()
      EndIf
   Endif
Return lRet

*-----------------------------------------------------------------------------*
METHOD EditAllCells( nRow, nCol, lAppend ) CLASS TXBrowse
*-----------------------------------------------------------------------------*
Local lRet, lRowEdited, lSomethingEdited

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   ASSIGN nRow    VALUE nRow    TYPE "N" DEFAULT ::CurrentRow
   ASSIGN nCol    VALUE nCol    TYPE "N" DEFAULT 1

   If nRow < 1 .or. nRow > ::ItemCount() .or. nCol < 1 .or. nCol > Len( ::aHeaders )
      // Cell out of range
      Return .F.
   EndIf

   lSomethingEdited := .F.

   Do While .t.
      lRet := .T.
      lRowEdited := .F.

      Do While nCol <= Len( ::aHeaders ) .AND. lRet
         If ::IsColumnReadOnly( nCol )
           // Read only column, skip
         ElseIf ! ::IsColumnWhen( nCol )
           // Not a valid WHEN, skip column and continue editing
         Else
            lRet := ::EditCell( nRow, nCol,,,,, lAppend )

            If lRet
               lRowEdited := .T.
               lSomethingEdited := .T.
            ElseIf lAppend
               ::GoBottom()
            EndIf

            lAppend := .F.
         EndIf

         nCol++
      EndDo

      // If a column was edited, scroll to the left
      If lRowEdited
         ListView_Scroll( ::hWnd, - _OOHG_GridArrayWidths( ::hWnd, ::aWidths ), 0 )
      EndIf

      If ! lRet .or. ! ::FullMove
         // Stop if the last column was not edited
         // or it's not fullmove editing
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
      // uOldValue := &( ::WorkArea + "->( " + ::aFields[ nCol ] + " )" )
      uOldValue := EVAL( ::ColumnBlock( nCol, .T. ), ::WorkArea )
   EndIf

   If ValType( ::aReplaceField ) == "A" .AND. Len( ::aReplaceField ) >= nCol
      bReplaceField := ::aReplaceField[ nCol ]
   Else
      bReplaceField := nil
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
   EditControl := GetEditControlFromArray( EditControl, ::EditControls, nCol, Self )
   If ValType( EditControl ) != "O"
      If ValType( ::Picture ) == "A" .AND. Len( ::Picture ) >= nCol
         If ValType( ::Picture[ nCol ] ) $ "CM"
            EditControl := TGridControlTextBox():New( ::Picture[ nCol ],, ValType( uOldValue ) )
         ElseIf ValType( ::Picture[ nCol ] ) == "L" .AND. ::Picture[ nCol ]
            EditControl := TGridControlImageList():New( Self )
         EndIf
      EndIf
      If ValType( EditControl ) != "O" .AND. nPos != 0
         // Checks according to field type
         Do Case
            Case aStruct[ nPos ][ 2 ] == "N"
               If aStruct[ nPos ][ 4 ] == 0
                  EditControl := TGridControlTextBox():New( Replicate( "9", aStruct[ nPos ][ 3 ] ),, "N" )
               Else
                  EditControl := TGridControlTextBox():New( Replicate( "9", aStruct[ nPos ][ 3 ] - aStruct[ nPos ][ 4 ] - 1 ) + "." + Replicate( "9", aStruct[ nPos ][ 4 ] ),, "N" )
               EndIf
            Case aStruct[ nPos ][ 2 ] == "L"
               // EditControl := TGridControlCheckBox():New()
               EditControl := TGridControlLComboBox():New()
            Case aStruct[ nPos ][ 2 ] == "M"
               EditControl := TGridControlMemo():New()
            Case aStruct[ nPos ][ 2 ] == "D"
               // EditControl := TGridControlDatePicker():New( .T. )
               EditControl := TGridControlTextBox():New( "@D",, "D" )
            Case aStruct[ nPos ][ 2 ] == "C"
               EditControl := TGridControlTextBox():New( "@S" + Ltrim( Str( aStruct[ nPos ][ 3 ] ) ),, "C" )
            OtherWise
               // Non-implemented field type!!!
         EndCase
      EndIf
      If ValType( EditControl ) != "O"
         EditControl := GridControlObjectByType( uOldValue )
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
      IF VALTYPE( uWorkArea ) == "O"
         ::uWorkArea := uWorkArea
         ::oWorkArea := uWorkArea
      ELSEIF VALTYPE( uWorkArea ) $ "CM" .AND. ! EMPTY( uWorkArea )
         uWorkArea := ALLTRIM( UPPER( uWorkArea ) )
         ::uWorkArea := uWorkArea
         ::oWorkArea := ooHGRecord():New( uWorkArea )
      ELSE
         ::uWorkArea := nil
         ::oWorkArea := nil
      ENDIF
   ENDIF
RETURN ::uWorkArea

*-----------------------------------------------------------------------------*
METHOD AddColumn( nColIndex, xField, cHeader, nWidth, nJustify, uForeColor, ;
                  uBackColor, lNoDelete, uPicture, uEditControl, uHeadClick, ;
                  uValid, uValidMessage, uWhen, cHeaderImage, nHeaderImageAlign ) CLASS TXBrowse
*-----------------------------------------------------------------------------*

   // Set Default Values
   If ! HB_IsNumeric( nColIndex ) .OR. nColIndex > Len( ::aHeaders ) + 1
      nColIndex := Len( ::aHeaders ) + 1
   ElseIf nColIndex < 1
      nColIndex := 1
   EndIf

   ASIZE( ::aFields, LEN( ::aFields ) + 1 )
   AINS( ::aFields, nColIndex )
   ::aFields[ nColIndex ] := xField

   If HB_IsArray( ::aReplaceField )
      ASIZE( ::aReplaceField, LEN( ::aReplaceField ) + 1 )
      AINS( ::aReplaceField, nColIndex )
   EndIf

   ::Super:AddColumn( nColIndex, cHeader, nWidth, nJustify, uForeColor, ;
                      uBackColor, lNoDelete, uPicture, uEditControl, uHeadClick, ;
                      uValid, uValidMessage, uWhen, cHeaderImage, nHeaderImageAlign )
   ::Refresh()
RETURN nil

*-----------------------------------------------------------------------------*
METHOD DeleteColumn( nColIndex ) CLASS TXBrowse
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
   If HB_IsArray( ::aReplaceField )
      _OOHG_DeleteArrayItem( ::aReplaceField,  nColIndex )
   EndIf
   nRet := ::Super:DeleteColumn( nColIndex )
   ::Refresh()
RETURN nRet





*-----------------------------------------------------------------------------*
CLASS ooHGRecord
*-----------------------------------------------------------------------------*
   DATA cAlias__

   METHOD New
   METHOD Use
   METHOD Skipper
   METHOD OrdScope
   METHOD Filter

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
   #endif

   ERROR HANDLER FieldAssign
ENDCLASS

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
      ENDIF
   ELSEIF PCOUNT() == 1
      nPos := ( cAlias )->( FieldPos( SUBSTR( cMessage, 2 ) ) )
      IF nPos > 0
         uRet := ( cAlias )->( FieldPut( nPos, xValue ) )
         lError := .F.
      ENDIF
   ENDIF
   IF lError
      uRet := NIL
      ::MsgNotFound( cMessage )
   ENDIF
RETURN uRet

*-----------------------------------------------------------------------------*
METHOD New( cAlias ) CLASS ooHGRecord
*-----------------------------------------------------------------------------*
   IF ! VALTYPE( cAlias ) $ "CM" .OR. EMPTY( cAlias )
      ::cAlias__ := ALIAS()
   ELSE
      ::cAlias__ := UPPER( ALLTRIM( cAlias ) )
   ENDIF
RETURN Self

*-----------------------------------------------------------------------------*
METHOD Use( cFile, cAlias, cRDD, lShared, lReadOnly ) CLASS ooHGRecord
*-----------------------------------------------------------------------------*
   DbUseArea( .T., cRDD, cFile, cAlias, lShared, lReadOnly )
   ::cAlias__ := ALIAS()
RETURN Self

*-----------------------------------------------------------------------------*
METHOD Skipper( nSkip ) CLASS ooHGRecord
*-----------------------------------------------------------------------------*
LOCAL nCount
   nCount := 0
   nSkip := IF( VALTYPE( nSkip ) == "N", INT( nSkip ), 1 )
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
               nCount++
               nSkip--
            ENDIF
         ELSE
            ::Skip( -1 )
            IF ::BOF()
               EXIT
            ELSE
               nCount--
               nSkip++
            ENDIF
         ENDIF
      ENDDO
   ENDIF
RETURN nCount

*-----------------------------------------------------------------------------*
METHOD OrdScope( uFrom, uTo ) CLASS ooHGRecord
*-----------------------------------------------------------------------------*
   IF PCOUNT() == 0
      ( ::cAlias )->( ORDSCOPE( 0, nil ) )
      ( ::cAlias )->( ORDSCOPE( 1, nil ) )
   ELSEIF PCOUNT() == 1
      ( ::cAlias )->( ORDSCOPE( 0, uFrom ) )
      ( ::cAlias )->( ORDSCOPE( 1, uFrom ) )
   ELSE
      ( ::cAlias )->( ORDSCOPE( 0, uFrom ) )
      ( ::cAlias )->( ORDSCOPE( 1, uTo ) )
   ENDIF
RETURN nil

*-----------------------------------------------------------------------------*
METHOD Filter( cFilter ) CLASS ooHGRecord
*-----------------------------------------------------------------------------*
   If EMPTY( cFilter )
      ( ::cAlias__ )->( DbClearFilter() )
   Else
      ( ::cAlias__ )->( DbSetFilter( { || &( cFilter ) } , cFilter ) )
   EndIf
RETURN nil

#pragma BEGINDUMP
#define s_Super s_TGrid

#include "hbapi.h"
#include "hbapiitm.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windows.h>
#include <commctrl.h>
#include "oohg.h"

// -----------------------------------------------------------------------------
// METHOD Events_Notify( wParam, lParam ) CLASS TXBrowse
HB_FUNC_STATIC( TXBROWSE_EVENTS_NOTIFY )
// -----------------------------------------------------------------------------
{
   LONG wParam = hb_parnl( 1 );
   LONG lParam = hb_parnl( 2 );
   PHB_ITEM pSelf;

   switch( ( ( NMHDR FAR * ) lParam )->code )
   {
      case NM_CLICK:
      case LVN_BEGINDRAG:
      case LVN_KEYDOWN:
      case LVN_ITEMCHANGED:
         HB_FUNCNAME( TXBROWSE_EVENTS_NOTIFY2 )();
         break;

      case NM_CUSTOMDRAW:
      {
         pSelf = hb_stackSelfItem();
         _OOHG_Send( pSelf, s_AdjustRightScroll );
         hb_vmSend( 0 );
         // don't break, continue in TGrid class
      }

      default:
         _OOHG_Send( hb_stackSelfItem(), s_Super );
         hb_vmSend( 0 );
         _OOHG_Send( hb_param( -1, HB_IT_OBJECT ), s_Events_Notify );
         hb_vmPushLong( wParam );
         hb_vmPushLong( lParam );
         hb_vmSend( 2 );
         break;
   }
}

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

#ifndef VK_A
   #define   VK_A   65
#endif

HB_FUNC( INSERT_ALT_A )
{
	keybd_event(VK_MENU,	       // virtual-key code
              0,    		       // hardware scan code
		          0,		           // flags specifying various function options
		          0		             // additional data associated with keystroke
	           ) ;

	keybd_event(VK_A,	           // virtual-key code
		          0,		           // hardware scan code
		          0,		           // flags specifying various function options
		          0		             // additional data associated with keystroke
	           ) ;

	keybd_event(VK_MENU,	       // virtual-key code
		          0,		           // hardware scan code
		          KEYEVENTF_KEYUP, // flags specifying various function options
		          0		             // additional data associated with keystroke
	           );
}

#pragma ENDDUMP
