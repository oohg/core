/*
 * $Id: h_browse.prg,v 1.167 2015-11-08 00:00:18 fyurisich Exp $
 */
/*
 * ooHG source code:
 * Browse controls
 *
 * Copyright 2005-2015 Vicente Guerra <vicente@guerra.com.mx>
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
#include "hbclass.ch"
#include "i_windefs.ch"

#define GO_TOP    -1
#define GO_BOTTOM  1

STATIC _OOHG_BrowseSyncStatus := .F.
STATIC _OOHG_BrowseFixedBlocks := .T.
STATIC _OOHG_BrowseFixedControls := .F.

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

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
               aFields, value, fontname, fontsize, tooltip, change, ;
               dblclick, aHeadClick, gotfocus, lostfocus, WorkArea, ;
               AllowDelete, nogrid, aImage, aJust, HelpId, bold, italic, ;
               underline, strikeout, break, backcolor, fontcolor, lock, ;
               inplace, novscroll, AllowAppend, readonly, valid, ;
               validmessages, edit, dynamicbackcolor, aWhenFields, ;
               dynamicforecolor, aPicture, lRtl, onappend, editcell, ;
               editcontrols, replacefields, lRecCount, columninfo, ;
               lHasHeaders, onenter, lDisabled, lNoTabStop, lInvisible, ;
               lDescending, bDelWhen, DelMsg, onDelete, aHeaderImage, ;
               aHeaderImageAlign, FullMove, aSelectedColors, aEditKeys, ;
               uRefresh, dblbffr, lFocusRect, lPLM, sync, lFixedCols, ;
               lNoDelMsg, lUpdateAll, abortedit, click, lFixedWidths, ;
               lFixedBlocks, bBeforeColMove, bAfterColMove, bBeforeColSize, ;
               bAfterColSize, bBeforeAutofit, lLikeExcel, lButtons, lUpdCols, ;
               lFixedCtrls, bHeadRClick, lExtDbl, lNoModal, lSilent, lAltA, ;
               lNoShowAlways, lNone, lCBE, onrclick, lCheckBoxes, oncheck, ;
               rowrefresh, aDefaultValues, editend ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local nWidth2, nCol2, oScroll, z

   ASSIGN ::aFields     VALUE aFields      TYPE "A"
   ASSIGN ::aHeaders    VALUE aHeaders     TYPE "A" DEFAULT {}
   ASSIGN ::aWidths     VALUE aWidths      TYPE "A" DEFAULT {}
   ASSIGN ::aJust       VALUE aJust        TYPE "A" DEFAULT {}
   ASSIGN ::lDescending VALUE lDescending  TYPE "L"
   ASSIGN ::SyncStatus  VALUE sync         TYPE "L" DEFAULT Nil
   ASSIGN ::lUpdateAll  VALUE lUpdateAll   TYPE "L"
   ASSIGN ::lUpdCols    VALUE lUpdCols     TYPE "L"
   ASSIGN lFixedBlocks  VALUE lFixedBlocks TYPE "L" DEFAULT _OOHG_BrowseFixedBlocks
   ASSIGN lFixedCtrls   VALUE lFixedCtrls  TYPE "L" DEFAULT _OOHG_BrowseFixedControls
   ASSIGN lAltA         VALUE lAltA        TYPE "L" DEFAULT .T.

   If HB_IsArray( aDefaultValues )
      ::aDefaultValues := aDefaultValues
      ASize( ::aDefaultValues, Len( ::aHeaders ) )
   Else
      ::aDefaultValues := Array( Len( ::aHeaders ) )
       AFill( ::aDefaultValues, aDefaultValues )
   EndIf

   If ValType( uRefresh ) == "N"
      If uRefresh == REFRESH_FORCE .OR. uRefresh == REFRESH_NO .OR. uRefresh == REFRESH_DEFAULT
         ::RefreshType := uRefresh
      Else
         ::RefreshType := REFRESH_DEFAULT
      EndIf
   Else
      ::RefreshType := REFRESH_DEFAULT
   EndIf

   If ValType( columninfo ) == "A" .AND. Len( columninfo ) > 0
      If ValType( ::aFields ) == "A"
         aSize( ::aFields,  Len( columninfo ) )
      Else
         ::aFields := Array( Len( columninfo ) )
      EndIf
      aSize( ::aHeaders, Len( columninfo ) )
      aSize( ::aWidths,  Len( columninfo ) )
      aSize( ::aJust,    Len( columninfo ) )
      For z := 1 To Len( columninfo )
         If ValType( columninfo[ z ] ) == "A"
            If Len( columninfo[ z ] ) >= 1 .AND. ValType( columninfo[ z ][ 1 ] ) $ "CMB"
               ::aFields[ z ]  := columninfo[ z ][ 1 ]
            EndIf
            If Len( columninfo[ z ] ) >= 2 .AND. ValType( columninfo[ z ][ 2 ] ) $ "CM"
               ::aHeaders[ z ] := columninfo[ z ][ 2 ]
            EndIf
            If Len( columninfo[ z ] ) >= 3 .AND. ValType( columninfo[ z ][ 3 ] ) $ "N"
               ::aWidths[ z ]  := columninfo[ z ][ 3 ]
            EndIf
            If Len( columninfo[ z ] ) >= 4 .AND. ValType( columninfo[ z ][ 4 ] ) $ "N"
               ::aJust[ z ]    := columninfo[ z ][ 4 ]
            EndIf
         EndIf
      Next
   EndIf

   If ! ValType( WorkArea ) $ "CM" .OR. Empty( WorkArea )
      WorkArea := Alias()
   EndIf

   If ValType( ::aFields ) != "A"
      ::aFields := ( WorkArea )->( DbStruct() )
      aEval( ::aFields, { |x,i| ::aFields[ i ] := WorkArea + "->" + x[ 1 ] } )
   EndIf

   aSize( ::aHeaders, Len( ::aFields ) )
   aEval( ::aHeaders, { |x,i| ::aHeaders[ i ] := If( ! ValType( x ) $ "CM", If( ValType( ::aFields[ i ] ) $ "CM", ::aFields[ i ], "" ), x ) } )

   aSize( ::aWidths, Len( ::aFields ) )
   aEval( ::aWidths, { |x,i| ::aWidths[ i ] := If( ! ValType( x ) == "N", 100, x ) } )

   // If splitboxed force no vertical scrollbar

   ASSIGN novscroll VALUE novscroll TYPE "L" DEFAULT .F.
   If ValType(x) != "N" .OR. ValType(y) != "N"
      novscroll := .T.
   EndIf

   ASSIGN w VALUE w TYPE "N" DEFAULT ::nWidth
   nWidth2 := If( novscroll, w, w - GetVScrollBarWidth() )

   ::Define3( ControlName, ParentForm, x, y, nWidth2, h, fontname, fontsize, ;
              tooltip, aHeadClick, nogrid, aImage, break, HelpId, bold, ;
              italic, underline, strikeout, edit, backcolor, fontcolor, ;
              dynamicbackcolor, dynamicforecolor, aPicture, lRtl, InPlace, ;
              editcontrols, readonly, valid, validmessages, , ;
              aWhenFields, lDisabled, lNoTabStop, lInvisible, lHasHeaders, ;
              aHeaderImage, aHeaderImageAlign, FullMove, aSelectedColors, ;
              aEditKeys, dblbffr, lFocusRect, lPLM, lFixedCols, , ;
              , lFixedWidths, , , ;
              , , , lLikeExcel, ;
              lButtons, AllowDelete, DelMsg, lNoDelMsg, AllowAppend, ;
              lNoModal, lFixedCtrls, , lExtDbl, Value, lSilent, ;
              lAltA, lNoShowAlways, lNone, lCBE, , lCheckBoxes, ;
               )

   ::nWidth := w

   ASSIGN ::Lock          VALUE lock          TYPE "L"
   ASSIGN ::aReplaceField VALUE replacefields TYPE "A"
   ASSIGN ::lRecCount     VALUE lRecCount     TYPE "L"

   ::WorkArea := WorkArea

   ::FixBlocks( lFixedBlocks )

   ::aRecMap := {}

   ::ScrollButton := TScrollButton():Define( , Self, nCol2, ::nHeight - GetHScrollBarHeight(), GetVScrollBarWidth(), GetHScrollBarHeight() )

   oScroll := TScrollBar()
   oScroll:nWidth := GetVScrollBarWidth()
   oScroll:SetRange( 1, 1000 )

   If ::lRtl .AND. ! ::Parent:lRtl
      ::nCol := ::nCol + GetVScrollBarWidth()
      nCol2 := -GetVScrollBarWidth()
   Else
      nCol2 := nWidth2
   EndIf
   oScroll:nCol := nCol2

   If IsWindowStyle( ::hWnd, WS_HSCROLL )
      oScroll:nRow := 0
      oScroll:nHeight := ::nHeight - GetHScrollBarHeight()
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

   // Forces to hide "additional" controls when it's inside a non-visible TAB page.
   ::Visible := ::Visible

   ::lVScrollVisible := .T.
   If novscroll
      ::VScrollVisible( .F. )
   EndIf

   ::SizePos()

   ::lChangeBeforeEdit := .F.

   // Must be set after control is initialized
   ASSIGN ::OnLostFocus    VALUE lostfocus      TYPE "B"
   ASSIGN ::OnGotFocus     VALUE gotfocus       TYPE "B"
   ASSIGN ::OnChange       VALUE Change         TYPE "B"
   ASSIGN ::OnDblClick     VALUE dblclick       TYPE "B"
   ASSIGN ::OnClick        VALUE click          TYPE "B"
   ASSIGN ::OnEnter        VALUE onenter        TYPE "B"
   ASSIGN ::OnCheckChange  VALUE oncheck        TYPE "B"
   ASSIGN ::bBeforeColMove VALUE bBeforeColMove TYPE "B"
   ASSIGN ::bAfterColMove  VALUE bAfterColMove  TYPE "B"
   ASSIGN ::bBeforeColSize VALUE bBeforeColSize TYPE "B"
   ASSIGN ::bAfterColSize  VALUE bAfterColSize  TYPE "B"
   ASSIGN ::bBeforeAutofit VALUE bBeforeAutofit TYPE "B"
   ASSIGN ::OnDelete       VALUE onDelete       TYPE "B"
   ASSIGN ::bDelWhen       VALUE bDelWhen       TYPE "B"
   ASSIGN ::OnAppend       VALUE onappend       TYPE "B"
   ASSIGN ::bHeadRClick    VALUE bHeadRClick    TYPE "B"
   ASSIGN ::OnEditCell     VALUE editcell       TYPE "B"
   ASSIGN ::OnEditCellEnd  VALUE editend        TYPE "B"
   ASSIGN ::OnAbortEdit    VALUE abortedit      TYPE "B"
   ASSIGN ::OnRClick       VALUE onrclick       TYPE "B"
   ASSIGN ::OnRefreshRow   VALUE rowrefresh     TYPE "B"

Return Self

*-----------------------------------------------------------------------------*
METHOD Define3( ControlName, ParentForm, x, y, w, h, fontname, fontsize, ;
                tooltip, aHeadClick, nogrid, aImage, break, HelpId, bold, ;
                italic, underline, strikeout, edit, backcolor, fontcolor, ;
                dynamicbackcolor, dynamicforecolor, aPicture, lRtl, InPlace, ;
                editcontrols, readonly, valid, validmessages, editcell, ;
                aWhenFields, lDisabled, lNoTabStop, lInvisible, lHasHeaders, ;
                aHeaderImage, aHeaderImageAlign, FullMove, aSelectedColors, ;
                aEditKeys, dblbffr, lFocusRect, lPLM, lFixedCols, abortedit, ;
                click, lFixedWidths, bBeforeColMove, bAfterColMove, ;
                bBeforeColSize, bAfterColSize, bBeforeAutofit, lLikeExcel, ;
                lButtons, AllowDelete, DelMsg, lNoDelMsg, AllowAppend, ;
                lNoModal, lFixedCtrls, bHeadRClick, lExtDbl, Value, lSilent, ;
                lAltA, lNoShowAlways, lNone, lCBE, onrclick, lCheckBoxes, ;
                editend ) CLASS TOBrowse
*-----------------------------------------------------------------------------*

   ::TGrid:Define( ControlName, ParentForm, x, y, w, h, ::aHeaders, ::aWidths, ;
                   {}, Nil, fontname, fontsize, tooltip, Nil, Nil, aHeadClick, ;
                   Nil, Nil, nogrid, aImage, ::aJust, break, HelpId, bold, ;
                   italic, underline, strikeout, Nil, Nil, Nil, edit, ;
                   backcolor, fontcolor, dynamicbackcolor, dynamicforecolor, ;
                   aPicture, lRtl, InPlace, editcontrols, readonly, valid, ;
                   validmessages, editcell, aWhenFields, lDisabled, ;
                   lNoTabStop, lInvisible, lHasHeaders, Nil, aHeaderImage, ;
                   aHeaderImageAlign, FullMove, aSelectedColors, aEditKeys, ;
                   lCheckBoxes, Nil, dblbffr, lFocusRect, lPLM, lFixedCols, abortedit, ;
                   click, lFixedWidths, bBeforeColMove, bAfterColMove, ;
                   bBeforeColSize, bAfterColSize, bBeforeAutofit, lLikeExcel, ;
                   lButtons, AllowDelete, Nil, Nil, DelMsg, lNoDelMsg, ;
                   AllowAppend, Nil, lNoModal, lFixedCtrls, bHeadRClick, Nil, ;
                   Nil, lExtDbl, lSilent, lAltA, lNoShowAlways, lNone, lCBE, ;
                   onrclick, Nil, editend )

   If ValType( Value ) == "N"
      ::nRecLastValue := Value
   EndIf

Return Self

*-----------------------------------------------------------------------------*
METHOD UpDate( nRow ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local PageLength, aTemp, _BrowseRecMap, x, nRecNo, nCurrentLength
Local lColor, aFields, cWorkArea, hWnd, nWidth

   cWorkArea := ::WorkArea

   If Select( cWorkArea ) == 0
      ::RecCount := 0
      Return Self
   EndIf

   PageLength := ::CountPerPage

   If PageLength < 1
     Return Self
   EndIf

   nWidth := Len( ::aFields )

   If ::FixBlocks()
     aFields := aClone( ::aColumnBlocks )
   Else
     aFields := Array( nWidth )
     aEval( ::aFields, { |c,i| aFields[ i ] := ::ColumnBlock( i ), c } )
   EndIf

   hWnd := ::hWnd

   lColor := ! ( Empty( ::DynamicForeColor ) .AND. Empty( ::DynamicBackColor ) )

   aTemp := Array( nWidth )

   If ::Visible
      ::SetRedraw( .F. )
   EndIf

   nCurrentLength  := ::ItemCount
   ::GridForeColor := Nil
   ::GridBackColor := Nil

   If ::Eof()
      _BrowseRecMap := {}
   Else
      If ! HB_IsNumeric( nRow ) .OR. nRow < 1 .OR. nRow > PageLength
         nRow := 1
      EndIf

      _BrowseRecMap := Array( nRow )
      nRecNo := ( cWorkArea )->( RecNo() )
      x := nRow
      Do While x > 0
         _BrowseRecMap[ x ] := ( cWorkArea )->( RecNo() )
         x --
         ::DbSkip( -1 )
         If ::Bof()
            Exit
         EndIf
      EndDo
      Do While x > 0
         _OOHG_DeleteArrayItem( _BrowseRecMap, x )
         x --
      EndDo
      ::DbGoTo( nRecNo )
      ::DbSkip()
      Do While Len( _BrowseRecMap ) < PageLength .AND. ! ::Eof()
         aAdd( _BrowseRecMap, ( cWorkArea )->( RecNo() ) )
         ::DbSkip()
      EndDo
      For x := 1 To Len( _BrowseRecMap )
         ::DbGoTo( _BrowseRecMap[ x ] )

         aEval( aFields, { |b,i| aTemp[ i ] := Eval( b ) } )

         If lColor
            ( cWorkArea )->( ::SetItemColor( x, , , aTemp ) )
         EndIf

         If nCurrentLength < x
            AddListViewItems( hWnd, aTemp )
            nCurrentLength ++
         Else
            ListViewSetItem( hWnd, aTemp, x )
         EndIf
      Next x
      // Repositions the file as If _BrowseRecMap was builded using successive ::DbSkip() calls
      ::DbSkip()
   EndIf

   Do While nCurrentLength > Len( _BrowseRecMap )
      ::DeleteItem( nCurrentLength )
      nCurrentLength --
   EndDo

   If ::Visible
      ::SetRedraw( .T. )
   EndIf

   ::aRecMap := _BrowseRecMap

   // Update headers text and images, columns widths and justifications
   If ::lUpdateAll
      If Len( ::aWidths ) != nWidth
         aSize( ::aWidths, nWidth )
      EndIf
      aEval( ::aWidths, { |x,i| ::ColumnWidth( i, If( ! HB_IsNumeric( x ) .OR. x < 0, 0, x ) ) } )

      If Len( ::aJust ) != nWidth
         aSize( ::aJust, nWidth )
         aEval( ::aJust, { |x,i| ::aJust[ i ] := If( ! HB_IsNumeric( x ), 0, x ) } )
      EndIf
      aEval( ::aJust, { |x,i| ::Justify( i, x ) } )

      If Len( ::aHeaders ) != nWidth
         aSize( ::aHeaders, nWidth )
         aEval( ::aHeaders, { |x,i| ::aHeaders[ i ] := If( ! ValType( x ) $ "CM", "", x ) } )
      EndIf
      aEval( ::aHeaders, { |x,i| ::Header( i, x ) } )

      ::LoadHeaderImages( ::aHeaderImage )
   EndIf

Return Self

*-----------------------------------------------------------------------------*
METHOD UpDateColors() CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local aTemp, x, aFields, cWorkArea, nWidth, nLen, _RecNo

   ::GridForeColor := Nil
   ::GridBackColor := Nil

   nLen := Len( ::aRecMap )
   If nLen == 0
      Return Self
   EndIf

   If Empty( ::DynamicForeColor ) .AND. Empty( ::DynamicBackColor )
      Return Self
   EndIf

   cWorkArea := ::WorkArea
   If Select( cWorkArea ) == 0
      Return Self
   EndIf

   nWidth := Len( ::aFields )
   aTemp := Array( nWidth )

   If ::FixBlocks()
     aFields := aClone( ::aColumnBlocks )
   Else
     aFields := Array( nWidth )
     aEval( ::aFields, { |c,i| aFields[ i ] := ::ColumnBlock( i ), c } )
   EndIf

   _RecNo := ( cWorkArea )->( RecNo() )

   If ::Visible
      ::SetRedraw( .F. )
   EndIf

   For x := 1 To nLen
      ::DbGoTo( ::aRecMap[ x ] )
      aEval( aFields, { |b,i| aTemp[ i ] := Eval( b ) } )
      ( cWorkArea )->( ::SetItemColor( x,,, aTemp ) )
   Next x

   If ::Visible
      ::SetRedraw( .T. )
   EndIf

   ::DbGoTo( _RecNo )

Return Self

*-----------------------------------------------------------------------------*
METHOD PageDown( lAppend ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local _RecNo, s, cWorkArea

   s := ::CurrentRow

   If s >= Len( ::aRecMap )
      cWorkArea := ::WorkArea

      If Select( cWorkArea ) == 0
         ::RecCount := 0
         Return Self
      EndIf

      _RecNo := ( cWorkArea )->( RecNo() )

      If Len( ::aRecMap ) == 0
         ::TopBottom( GO_BOTTOM )
         ::DbSkip( - ::CountPerPage + 1 )
      Else
         ::DbGoTo( ::aRecMap[ Len( ::aRecMap ) ] )
         // Check for more records
         ::DbSkip()
         If ::Eof()
            ::DbGoTo( _RecNo )
            ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
            If lAppend
               ::AppendItem()
            EndIf
            Return Self
         EndIf
         ::DbSkip( -1 )
      EndIf
      ::Update()
      ::ScrollUpdate()
      ::CurrentRow := Len( ::aRecMap )
      ::DbGoTo( _RecNo )
   Else
      ::FastUpdate( ::CountPerPage - s, Len( ::aRecMap ) )
   EndIf

   ::BrowseOnChange()

Return Self

*-----------------------------------------------------------------------------*
METHOD PageUp() CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local _RecNo, cWorkArea

   If ::CurrentRow == 1
      cWorkArea := ::WorkArea
      If Select( cWorkArea ) == 0
         ::RecCount := 0
         Return Self
      EndIf
      _RecNo := ( cWorkArea )->( RecNo() )
      If Len( ::aRecMap ) == 0
         ::TopBottom( GO_TOP )
      Else
         ::DbGoTo( ::aRecMap[ 1 ] )
      EndIf
      ::DbSkip( - ::CountPerPage + 1 )
      ::ScrollUpdate()
      ::Update()
      ::DbGoTo( _RecNo )
      ::CurrentRow := 1
   Else
      ::FastUpdate( 1 - ::CurrentRow, 1 )
   EndIf

   ::BrowseOnChange()

Return Self

*-----------------------------------------------------------------------------*
METHOD Home() CLASS TOBrowse                         // METHOD GoTop
*-----------------------------------------------------------------------------*
Local _RecNo, cWorkArea

   cWorkArea := ::WorkArea
   If Select( cWorkArea ) == 0
      ::RecCount := 0
      Return Self
   EndIf
   _RecNo := ( cWorkArea )->( RecNo() )
   ::TopBottom( GO_TOP )
   ::ScrollUpdate()
   ::Update()
   ::DbGoTo( _RecNo )
   ::CurrentRow := 1

   ::BrowseOnChange()

Return Self

*-----------------------------------------------------------------------------*
METHOD End( lAppend ) CLASS TOBrowse                 // METHOD GoBottom
*-----------------------------------------------------------------------------*
Local _RecNo, _BottomRec, cWorkArea

   cWorkArea := ::WorkArea
   If Select( cWorkArea ) == 0
      ::RecCount := 0
      Return Self
   EndIf
   _RecNo := ( cWorkArea )->( RecNo() )
   ::TopBottom( GO_BOTTOM )
   _BottomRec := ( cWorkArea )->( RecNo() )
   ::ScrollUpdate()

   // If it's for APPEND, leaves a blank line ;)
   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   ::DbSkip( - ::CountPerPage + IF( lAppend, 2, 1 ) )
   ::Update()
   ::DbGoTo( _RecNo )
   ::CurrentRow := aScan( ::aRecMap, _BottomRec )

   ::BrowseOnChange()

Return Self

*-----------------------------------------------------------------------------*
METHOD Up() CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local s, _RecNo, nLen, lDone := .F., cWorkArea

   s := ::CurrentRow

   If s <= 1
      cWorkArea := ::WorkArea
      If Select( cWorkArea ) == 0
         ::RecCount := 0
         Return lDone
      EndIf

      _RecNo := ( cWorkArea )->( RecNo() )

      If Len( ::aRecMap ) == 0
         ::TopBottom( GO_TOP )
         ::DbSkip( -1 )
         ::Update()
      Else
         // Check for more records
         ::DbGoTo( ::aRecMap[ 1 ] )
         ::DbSkip( -1 )
         If ::Bof()
            ::DbGoTo( _RecNo )
            Return lDone
         EndIf
         // Add one record at the top
         aAdd( ::aRecMap, Nil )
         aIns( ::aRecMap, 1 )
         ::aRecMap[ 1 ] := ( cWorkArea )->( RecNo() )
         If ::Visible
            ::SetRedraw( .F. )
         EndIf
         ::InsertBlank( 1 )
         ::RefreshRow( 1 )
         nLen := Len( ::aRecMap )
         // Resize record map
         If nLen > ::CountPerPage
            ::DeleteItem( nLen )
            aSize( ::aRecMap, nLen - 1 )
         EndIf
         If ::Visible
            ::SetRedraw( .T. )
         EndIf
      EndIf

      ::ScrollUpdate()
      ::DbGoTo( _RecNo )
      ::CurrentRow := 1
      If Len( ::aRecMap ) != 0
         lDone := .T.
      EndIf
   Else
      ::FastUpdate( -1, s - 1 )
      lDone := .T.
   EndIf

   ::BrowseOnChange()

Return lDone

*-----------------------------------------------------------------------------*
METHOD Down( lAppend ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local s, _RecNo, nLen, lDone := .F., cWorkArea

   s := ::CurrentRow

   If s >= Len( ::aRecMap )
      cWorkArea := ::WorkArea
      If Select( cWorkArea ) == 0
         ::RecCount := 0
         Return lDone
      EndIf

      _RecNo := ( cWorkArea )->( RecNo() )

      If Len( ::aRecMap ) == 0
         ::TopBottom( GO_TOP )
         ::DbSkip()
         ::Update()
      Else
         // Check for more records
         ::DbGoTo( ::aRecMap[ Len( ::aRecMap ) ] )
         ::DbSkip()
         If ::Eof()
            ::DbGoTo( _RecNo )
            ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT ::AllowAppend
            If lAppend
               lDone := ::AppendItem()
            EndIf
            Return lDone
         EndIf
         // Add one record at the bottom
         aAdd( ::aRecMap, ( cWorkArea )->( RecNo() ) )
         nLen := Len( ::aRecMap )
         If ::Visible
            ::SetRedraw( .F. )
         EndIf
         ::RefreshRow( nLen )
         // Resize record map
         If nLen > ::CountPerPage
            ::DeleteItem( 1 )
             _OOHG_DeleteArrayItem( ::aRecMap, 1 )
         EndIf
         If ::Visible
            ::SetRedraw( .T. )
         EndIf
      EndIf

      ::ScrollUpdate()
      ::DbGoTo( _RecNo )
      ::CurrentRow := Len( ::aRecMap )
      If Len( ::aRecMap ) != 0
         lDone := .T.
      EndIf
   Else
      ::FastUpdate( 1, s + 1 )
      lDone := .T.
   EndIf

   ::BrowseOnChange()

Return lDone

*-----------------------------------------------------------------------------*
METHOD TopBottom( nDir ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local cWorkArea := ::WorkArea

   If ::lDescending
      nDir := - nDir
   EndIf
   If nDir == GO_BOTTOM
      ( cWorkArea )->( DbGoBottom() )
   Else
      ( cWorkArea )->( DbGoTop() )
   EndIf
   ::Bof := .F.
   ::Eof := ( cWorkArea )->( Eof() )

Return Self

*-----------------------------------------------------------------------------*
METHOD DbSkip( nRows ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local cWorkArea := ::WorkArea

   ASSIGN nRows VALUE nRows TYPE "N" DEFAULT 1
   If ! ::lDescending
      ( cWorkArea )->( DbSkip(   nRows ) )
      ::Bof := ( cWorkArea )->( Bof() )
      ::Eof := ( cWorkArea )->( Eof() ) .OR. ( ( cWorkArea )->( Recno() ) > ( cWorkArea )->( RecCount() ) )
   Else
      ( cWorkArea )->( DbSkip( - nRows ) )
      If ( cWorkArea )->( Eof() )
         ( cWorkArea )->( DbGoBottom() )
         ::Bof := .T.
         ::Eof := ( cWorkArea )->( Eof() )
      ElseIf ( cWorkArea )->( Bof() )
         ::Eof := .T.
         ::DbGoTo( 0 )
      EndIf
   EndIf

Return Self

*-----------------------------------------------------------------------------*
METHOD DbGoTo( nRecNo ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local cWorkArea := ::WorkArea

   ( cWorkArea )->( DbGoTo( nRecNo ) )
   ::Bof := .F.
   ::Eof := ( cWorkArea )->( Eof() ) .OR. ( ( cWorkArea )->( Recno() ) > ( cWorkArea )->( RecCount() ) )

Return Self

*-----------------------------------------------------------------------------*
METHOD SetValue( Value, mp ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local _RecNo, m, hWnd, cWorkArea

   cWorkArea := ::WorkArea

   If Select( cWorkArea ) == 0
      ::RecCount := 0
      Return Self
   EndIf

   If Value <= 0
      If ::lNoneUnsels
         ::CurrentRow := 0
         ::BrowseOnChange()
      EndIf
      Return Self
   EndIf

   hWnd := ::hWnd

   If _OOHG_ThisEventType == 'BROWSE_ONCHANGE'
      If hWnd == _OOHG_ThisControl:hWnd
         MsgOOHGError( "BROWSE: Value property can't be changed inside ON CHANGE event. Program Terminated." )
      EndIf
   EndIf

   If Value > ( cWorkArea )->( RecCount() )
      ::DeleteAllItems()
      ::BrowseOnChange()
      Return Self
   EndIf

   If ValType( mp ) != "N"
      m := Int( ::CountPerPage / 2 )
   Else
      m := mp
   EndIf

   _RecNo := ( cWorkArea )->( RecNo() )

   ::DbGoTo( Value )
   If ::Eof()
      ::DbGoTo( _RecNo )
      Return Self
   EndIf

   // Enforce filters in use
   ::DbSkip()
   ::DbSkip( -1 )
   If ( cWorkArea )->( RecNo() ) != Value
      ::DbGoTo( _RecNo )
      Return Self
   EndIf

   If PCount() < 2                           // TODO: Check
      ::ScrollUpdate()
   EndIf
   ::DbSkip( -m + 1 )
   ::Update()
   ::DbGoTo( _RecNo )
   ::CurrentRow := aScan( ::aRecMap, Value )

   _OOHG_ThisEventType := 'BROWSE_ONCHANGE'
   ::BrowseOnChange()
   _OOHG_ThisEventType := ''

Return Self

*-----------------------------------------------------------------------------*
METHOD Delete() CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local Value, nRecNo, lSync, cWorkArea

   Value := ::Value

   If Value == 0
      Return Self
   EndIf

   cWorkArea := ::WorkArea
   nRecNo := ( cWorkArea )->( RecNo() )

   ::DbGoTo( Value )

   If ::Lock .AND. ! ( cWorkArea )->( Rlock() )
      MsgExclamation( _OOHG_Messages( 3, 9 ), _OOHG_Messages( 4, 2 ) )
   Else
      ( cWorkArea )->( DbDelete() )

      // Do before unlocking record or moving record pointer
      // so block can operate on deleted record (e.g. to copy to a log).
      If HB_IsBlock( ::OnDelete )
         ::DoEvent( ::OnDelete, 'DELETE' )
      EndIf

      If ::Lock
         ( cWorkArea )->( DbCommit() )
         ( cWorkArea )->( DbUnlock() )
      EndIf
      ::DbSkip()
      If ::Eof()
         ::TopBottom( GO_BOTTOM )
      EndIf

      If Set( _SET_DELETED )
         ::SetValue( ( cWorkArea )->( RecNo() ), ::CurrentRow )
      EndIf
   EndIf

   If HB_IsLogical( ::SyncStatus )
      lSync := ::SyncStatus
   Else
      lSync := _OOHG_BrowseSyncStatus
   EndIf

   If lSync
      If ( cWorkArea )->( RecNo() ) != ::Value
         ::DbGoTo( ::Value )
      EndIf
   Else
      ::DbGoTo( nRecNo )
   EndIf

Return Self

*-----------------------------------------------------------------------------*
METHOD EditItem_B( lAppend ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local nOldRecNo, nItem, cWorkArea, lRet, nNewRec

   If ::FirstVisibleColumn == 0
      Return .F.
   EndIf

   cWorkArea := ::WorkArea
   If Select( cWorkArea ) == 0
      ::RecCount := 0
      Return .F.
   EndIf

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.

   nItem := ::CurrentRow
   If nItem == 0 .AND. ! lAppend
      Return .F.
   EndIf

   nOldRecNo := ( cWorkArea )->( RecNo() )

   If ! lAppend
      ::DbGoTo( ::aRecMap[ nItem ] )
   EndIf

   lRet := ::Super:EditItem_B( lAppend )

   If lRet .AND. lAppend
      nNewRec := ( cWorkArea )->( RecNo() )
      ::DbGoTo( nOldRecNo )
      ::Value := nNewRec
   Else
      ::DbGoTo( nOldRecNo )
   EndIf

Return lRet

*-----------------------------------------------------------------------------*
METHOD EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, lAppend, nOnFocusPos, lRefresh, lChange ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local lRet, BackRec, cWorkArea, lBefore

   ASSIGN lAppend  VALUE lAppend  TYPE "L" DEFAULT .F.
   ASSIGN nRow     VALUE nRow     TYPE "N" DEFAULT ::CurrentRow
   ASSIGN lRefresh VALUE lRefresh TYPE "L" DEFAULT ( ::RefreshType == REFRESH_FORCE )
   ASSIGN lChange  VALUE lChange  TYPE "L" DEFAULT ::lChangeBeforeEdit

   If nRow < 1 .OR. nRow > ::ItemCount
      Return .F.
   EndIf

   cWorkArea := ::WorkArea
   If Select( cWorkArea ) == 0
      ::RecCount := 0
      Return .F.
   EndIf

   If lAppend
      BackRec := ( cWorkArea )->( RecNo() )
      ::DbGoTo( 0 )
   Else
      If lChange
         ::Value := ::aRecMap[ nRow ]
      EndIf
      BackRec := ( cWorkArea )->( RecNo() )
      ::DbGoTo( ::aRecMap[ nRow ] )
   EndIf

   lBefore := ::lCalledFromClass
   ::lCalledFromClass := .T.
   lRet := ::Super:EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, nOnFocusPos, .F., lAppend )
   ::lCalledFromClass := lBefore

   If lRet .AND. lAppend
      aAdd( ::aRecMap, ( cWorkArea )->( RecNo() ) )
   EndIf

// xxx ::Super:EditCell refreshes the current row only, so here we must refresh entire grid when ::RefreshType == REFRESH_FORCE

   ::DbGoTo( BackRec )

   If lRet
      If lAppend .AND. lChange
         ::Value := aTail( ::aRecMap )
      Else
         If ! ::lCalledFromClass .AND. ::bPosition == 9                  // MOUSE EXIT
            // Edition window lost focus
            ::bPosition := 0                   // This restores the processing of click messages
            If ::nDelayedClick[ 1 ] > 0
               // A click message was delayed
               If ::nDelayedClick[ 3 ] <= 0
                  ::SetValue( ::aRecMap[ ::nDelayedClick[ 1 ] ], ::nDelayedClick[ 1 ] )
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
         If lRefresh
            ::Refresh()
         EndIf
      EndIf
   EndIf

Return lRet

*-----------------------------------------------------------------------------*
METHOD EditAllCells( nRow, nCol, lAppend, lOneRow, lChange, lRefresh ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local lRet, lSomethingEdited, lRowAppended, nRecNo, cWorkArea

   ASSIGN lOneRow VALUE lOneRow TYPE "L" DEFAULT .T.
   If ::FullMove .OR. ! lOneRow
      Return ::EditGrid( nRow, nCol, lAppend, lOneRow, lChange, lRefresh )
   EndIf
   If ::FirstVisibleColumn == 0
      Return .F.
   EndIf
   If ! HB_IsNumeric( nCol )
      nCol := ::FirstColInOrder
   EndIf
   If nCol < 1 .OR. nCol > Len( ::aHeaders )
      Return .F.
   EndIf

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   If lAppend
      ::GoBottom( .T. )
      ::InsertBlank( ::ItemCount + 1 )
      nRow := ::CurrentRow := ::ItemCount
      ::lAppendMode := .T.
   Else
      If ! HB_IsNumeric( nRow )
         nRow := Max( ::CurrentRow, 1 )
      EndIf
      If nRow < 1 .OR. nRow > ::ItemCount
         Return .F.
      EndIf

      ASSIGN lChange VALUE lChange TYPE "L" DEFAULT ::lChangeBeforeEdit
      If lChange
         ::Value := { ::aRecMap[ nRow ], nCol }
      EndIf
   EndIf

   ASSIGN lRefresh VALUE lRefresh TYPE "L" DEFAULT ( ::RefreshType == REFRESH_DEFAULT .OR. ::RefreshType == REFRESH_FORCE )

   cWorkArea := ::WorkArea

   lSomethingEdited := .F.

   Do While nCol >= 1 .AND. nCol <= Len( ::aHeaders ) .AND. Select( cWorkArea ) # 0
      nRecNo := ( cWorkArea )->( RecNo() )
      If lAppend
         ::DbGoTo( 0 )
      Else
         ::DbGoTo( ::aRecMap[ nRow ] )
      EndIf

      _OOHG_ThisItemCellValue := ::Cell( nRow, nCol )

      If ::IsColumnReadOnly( nCol, nRow )
        // Read only column
      ElseIf ! ::IsColumnWhen( nCol, nRow )
        // WHEN returned .F.
      ElseIf aScan( ::aHiddenCols, nCol,nRow ) > 0
        // Hidden column
      Else
         ::DbGoTo( nRecNo )

         ::lCalledFromClass := .T.
         lRet := ::EditCell( nRow, nCol, , , , , lAppend, , .F., .F. )
         ::lCalledFromClass := .F.

         If ! lRet
            If lAppend
               ::lAppendMode := .F.
               ::GoBottom()
            EndIf
            Exit
         EndIf

         lSomethingEdited := .T.
         If lAppend
            lRowAppended := .T.
            lAppend := .F.
         EndIf

         If ::bPosition == 9                  // MOUSE EXIT
            // Edition window lost focus
            ::bPosition := 0                   // This restores the processing of click messages
            If ::nDelayedClick[ 1 ] > 0
               // A click message was delayed
               If ::nDelayedClick[ 3 ] <= 0
                  ::SetValue( ::aRecMap[ ::nDelayedClick[ 1 ] ], ::nDelayedClick[ 1 ] )
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
            ElseIf lRowAppended
               // A new row was added and partially edited: set as new value and refresh the control
               ::SetValue( aTail( ::aRecMap ), nRow )
            Else
               // The user aborted the edition of an existing row: refresh the control without changing it's value
            EndIf
            If lRefresh
               ::Refresh()
            EndIf
            Exit
         EndIf
      EndIf

      nCol := ::NextColInOrder( nCol )
   EndDo

   ::ScrollToLeft()

Return lSomethingEdited

*-----------------------------------------------------------------------------*
METHOD EditGrid( nRow, nCol, lAppend, lOneRow, lChange, lRefresh ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local lRet := .T., lRowEdited, lSomethingEdited, nRecNo, lRowAppended, nNewRec, nNextRec, cWorkArea

   If ::FirstVisibleColumn == 0
      Return .F.
   EndIf
   If ! HB_IsNumeric( nCol )
      nCol := ::FirstColInOrder
   EndIf
   If nCol < 1 .OR. nCol > Len( ::aHeaders )
      Return .F.
   EndIf

   cWorkArea := ::WorkArea

   ASSIGN lAppend  VALUE lAppend  TYPE "L" DEFAULT .F.

   If lAppend
      If ::lAppendMode
         Return .F.
      EndIf
      ::lAppendMode := .T.
      ::GoBottom( .T. )
      ::InsertBlank( ::ItemCount + 1 )
      nRow := ::CurrentRow := ::ItemCount
   Else
      If ! HB_IsNumeric( nRow )
         nRow := Max( ::CurrentRow, 1 )
      EndIf
      If nRow < 1 .OR. nRow > ::ItemCount
         Return .F.
      EndIf
      ASSIGN lChange VALUE lChange TYPE "L" DEFAULT ::lChangeBeforeEdit
      If lChange
         ::Value := ::aRecMap[ nRow ]
      EndIf
   EndIf

   lSomethingEdited := .F.

   ASSIGN lRefresh VALUE lRefresh TYPE "L" DEFAULT ( ::RefreshType == REFRESH_FORCE )

   Do While .t.
      lRowEdited := .F.
      lRowAppended := .F.

      Do While nCol >= 1 .AND. nCol <= Len( ::aHeaders ) .AND. Select( cWorkArea ) # 0
         nRecNo := ( cWorkArea )->( RecNo() )
         If lAppend
            ::DbGoTo( 0 )
         Else
            ::DbGoTo( ::aRecMap[ nRow ] )
            If nRow == ::ItemCount
               ::DbSkip()
               If ::Eof()
                  nNextRec := 0
               Else
                  nNextRec := ( cWorkArea )->( RecNo() )
               EndIf
               ::DbGoTo( ::aRecMap[ nRow ] )
            EndIf
         EndIf

         _OOHG_ThisItemCellValue := ::Cell( nRow, nCol )

         If ::IsColumnReadOnly( nCol, nRow )
           // Read only column, skip
         ElseIf ! ::IsColumnWhen( nCol, nRow )
           // WHEN returned .F., skip
         ElseIf aScan( ::aHiddenCols, nCol, nRow ) > 0
           // Hidden column, skip
         Else
            ::DbGoTo( nRecNo )

            ::lCalledFromClass := .T.
            lRet := ::EditCell( nRow, nCol, , , , , lAppend, , .F., .F. )
            ::lCalledFromClass := .F.

            If ! lRet
               Exit
            EndIf

            lRowEdited := .T.
            lSomethingEdited := .T.
            If lAppend
               lRowAppended := .T.
               lAppend := .F.
            EndIf
         EndIf

         If ::bPosition == 9                     // MOUSE EXIT
            Exit
         EndIf

         nCol := ::NextColInOrder( nCol )
      EndDo

      // See what to do next
      If Select( cWorkArea ) == 0
         ::RecCount := 0
         Exit
      ElseIf ! lRet
         // The last column was not edited
         If lRowAppended
            // A new row was added and partially edited: set as new value and refresh the control
            ::SetValue( aTail( ::aRecMap ), nRow )
            ::Refresh()
         ElseIf lAppend
            // The user aborted the append of a new row in the first column: refresh and set last record as new value
            ::GoBottom()
         ElseIf lSomethingEdited
            // The user aborted the edition of an existing row: refresh the control without changing it's value
            ::Refresh()  // TODO: RefreshType
         EndIf
         Exit
      ElseIf ::bPosition == 9
         // Edition window lost focus
         ::bPosition := 0                   // This restores the processing of click messages
         If ::nDelayedClick[ 1 ] > 0
            // A click message was delayed
            If ::nDelayedClick[ 3 ] <= 0
               ::SetValue( ::aRecMap[ ::nDelayedClick[ 1 ] ], ::nDelayedClick[ 1 ] )
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
         ElseIf lRowAppended
            // A new row was added and partially edited: set as new value and refresh the control
            ::SetValue( aTail( ::aRecMap ), nRow )
         Else
            // The user aborted the edition of an existing row: refresh the control without changing it's value
         EndIf
         If lRefresh
            ::Refresh()
         EndIf
         Exit
      ElseIf ( HB_IsLogical( lOneRow ) .AND. lOneRow ) .OR. ( ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove ) .OR. ( lRowAppended .AND. ! ::AllowAppend )
         // Stop If it's not fullmove editing or
         // If caller wants to edit only one row or
         // if, after appending a new row, appends are not allowed anymore
         If lRowAppended
            // A new row was added and fully edited: set as new value and refresh the control
            ::SetValue( aTail( ::aRecMap ), nRow )
            ::Refresh()
        ElseIf lRowEdited
            // An existing row was fully edited: refresh the control without changing it's value
            ::Refresh()
         EndIf
         Exit
      ElseIf lRowAppended
         // A row was appended: refresh and/or add a new one
         If lRefresh
            ::GoBottom( .T. )
         Else
            Do While ::ItemCount >= ::CountPerPage
               ::DeleteItem( 1 )
               _OOHG_DeleteArrayItem( ::aRecMap, 1 )
            EndDo
         EndIf
         ::InsertBlank( ::ItemCount + 1 )
         nRow := ::CurrentRow := ::ItemCount
         lAppend := .T.
         ::lAppendMode := .T.
      ElseIf nRow < ::ItemCount
         // Edit next row
         If lRowEdited .AND. lRefresh
            nRecNo := ( cWorkArea )->( RecNo() )
            nNewRec := ::aRecMap[ nRow + 1 ]
            ::DbGoTo( nNewRec )
            ::Update( nRow + 1 )
            ::ScrollUpdate()
            ::DbGoTo( nRecNo )
            nRow := aScan( ::aRecMap, nNewRec )
            ::CurrentRow := nRow
         Else
            nRow ++
            ::FastUpdate( 1, nRow )
         EndIf
         ::BrowseOnChange()
      ElseIf nRow < ::CountPerPage
         If ::AllowAppend
            // Next visible row is blank, append new record
            If lRefresh
               ::GoBottom( .T. )
            EndIf
            ::InsertBlank( ::ItemCount + 1 )
            nRow := ::CurrentRow := ::ItemCount
            lAppend := .T.
            ::lAppendMode := .T.
         Else
            If lRowEdited
               // An existing row was fully edited: refresh the control without changing it's value
               ::Refresh()
            EndIf
            Exit
         EndIf
      Else
         // The last visible row was fully edited
         If nNextRec # 0
            // Find next record
            nRecNo := ( cWorkArea )->( RecNo() )
            ::DbGoTo( nNextRec )
            ::DbSkip()
            ::DbSkip(-1)
            If ( cWorkArea )->( RecNo() ) # nNextRec
               ::DbGoTo( nNextRec )
               ::DbSkip()
               If ::Eof()
                  nNextRec := 0
               Else
                  nNextRec := ( cWorkArea )->( RecNo() )
               EndIf
            EndIf
            ::DbGoTo( nRecNo )
         EndIf
         If nNextRec == 0
            // No more records
            If ::AllowAppend
               // Add new row
               If lRefresh
                  ::GoBottom( .T. )
               Else
                  Do While ::ItemCount >= ::CountPerPage
                     ::DeleteItem( 1 )
                     _OOHG_DeleteArrayItem( ::aRecMap, 1 )
                  EndDo
               EndIf
               ::InsertBlank( ::ItemCount + 1 )
               nRow := ::CurrentRow := ::ItemCount
               lAppend := .T.
               ::lAppendMode := .T.
            Else
               // Stop
               Exit
            EndIf
         Else
            // Edit next record
            nRecNo := ( cWorkArea )->( RecNo() )
            ::DbGoTo( nNextRec )
            If lRefresh
               ::Update( nRow )
               ::ScrollUpdate()
            Else
               Do While ::ItemCount >= ::CountPerPage
                  ::DeleteItem( 1 )
                  _OOHG_DeleteArrayItem( ::aRecMap, 1 )
               EndDo
               aAdd( ::aRecMap, nNextRec )
               ::RefreshRow( nRow )
               ::CurrentRow := nRow
            EndIf
            ::DbGoTo( nRecNo )
            ::BrowseOnChange()
         EndIf
      EndIf
      nCol := ::FirstColInOrder
   EndDo

   ::ScrollToLeft()

Return lSomethingEdited

*-----------------------------------------------------------------------------*
METHOD BrowseOnChange() CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local cWorkArea, lSync

   If ::lUpdCols
      ::UpdateColors()
   EndIf

   If HB_IsLogical( ::SyncStatus )
      lSync := ::SyncStatus
   Else
      lSync := _OOHG_BrowseSyncStatus
   EndIf

   If lSync
      cWorkArea := ::WorkArea
      If Select( cWorkArea ) != 0 .AND. ( cWorkArea )->( RecNo() ) != ::Value
         ::DbGoTo( ::Value )
      EndIf
   EndIf

   ::DoChange()

Return Self

*-----------------------------------------------------------------------------*
METHOD DoChange() CLASS TOBrowse
*-----------------------------------------------------------------------------*

   ::nRecLastValue := ::Value
   ::TGrid:DoChange()

Return Self

*-----------------------------------------------------------------------------*
METHOD FastUpdate( d, nRow ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local ActualRecord, RecordCount

   // If vertical scrollbar is used it must be updated
   If ::lVScrollVisible
      RecordCount := ::RecCount

      If RecordCount == 0
         Return Self
      EndIf

      If RecordCount < 1000
         ActualRecord := ::VScroll:Value + d
         ::VScroll:Value := ActualRecord
      EndIf
   EndIf

   If nRow < 1 .OR. nRow > Len( ::aRecMap )
      ::nRecLastValue := 0
      ::CurrentRow := 0
   Else
      ::nRecLastValue := ::aRecMap[ nRow ]
      ::CurrentRow := nRow
   EndIf

Return Self

*-----------------------------------------------------------------------------*
METHOD ScrollUpdate() CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local ActualRecord, RecordCount, cWorkArea

   // If vertical scrollbar is used it must be updated
   If ::lVScrollVisible
      cWorkArea := ::WorkArea
      If Select( cWorkArea ) == 0
         ::RecCount := 0
         Return Self
      EndIf
      RecordCount := ( cWorkArea )->( OrdKeyCount() )
      If RecordCount > 0
         ActualRecord := ( cWorkArea )->( OrdKeyNo() )
      Else
         ActualRecord := ( cWorkArea )->( RecNo() )
         RecordCount := ( cWorkArea )->( RecCount() )
      EndIf
      If ::lRecCount
         RecordCount := ( cWorkArea )->( RecCount() )
      EndIf

      ::RecCount := RecordCount

      If ::lDescending
         ActualRecord := RecordCount - ActualRecord + 1
      EndIf

      If RecordCount < 1000
         ::VScroll:RangeMax := RecordCount
         ::VScroll:Value := ActualRecord
      Else
         ::VScroll:RangeMax := 1000
         ::VScroll:Value := INT( ActualRecord * 1000 / RecordCount )
      EndIf
   EndIf

Return Self

*-----------------------------------------------------------------------------*
METHOD CurrentRow( nValue ) CLASS TOBrowse
*-----------------------------------------------------------------------------*

   If ValType( nValue ) == "N"
      If nValue < 1 .OR. nValue > ::ItemCount
         If ::CurrentRow # 0
            ListView_ClearCursel( ::hWnd, 0 )
         EndIf
      Else
         ListView_SetCursel( ::hWnd, nValue )
      EndIf
      ::nRowPos := ::FirstSelectedItem
   EndIf

Return ::FirstSelectedItem

*-----------------------------------------------------------------------------*
METHOD Refresh() CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local s, _RecNo, v, cWorkArea

   cWorkArea := ::WorkArea
   If Select( cWorkArea ) == 0
      ::DeleteAllItems()
      Return Self
   EndIf

   v := ::nRecLastValue       

   s := ::CurrentRow       

   _RecNo := ( cWorkArea )->( RecNo() )

   If v <= 0
      v := _RecNo
   EndIf

   ::DbGoTo( v )

   If s <= 1
      ::DbSkip()
      ::DbSkip( -1 )
      If ( cWorkArea )->( RecNo() ) != v
         ::DbSkip()
      EndIf
   EndIf

   If s == 0
      If ( cWorkArea )->( IndexOrd() ) != 0
         If ( cWorkArea )->( OrdKeyVal() ) == Nil
            ::TopBottom( GO_TOP )
         EndIf
      EndIf

      If Set( _SET_DELETED )
         If ( cWorkArea )->( Deleted() )
            ::TopBottom( GO_TOP )
         EndIf
      EndIf
   EndIf

   If ::Eof()
      ::DeleteAllItems()
      ::DbGoTo( _RecNo )
      Return Self
   EndIf

   ::ScrollUpdate()

   If s != 0
      ::DbSkip( - s + 1 )
   EndIf

   ::Update()

   ::CurrentRow := aScan( ::aRecMap, v )
   ::nRecLastValue := v

   ::DbGoTo( _RecNo )

Return Self

*-----------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local nItem

   If ValType( uValue ) == "N"
      ::SetValue( uValue )
   EndIf
   If Select( ::WorkArea ) == 0
      ::RecCount := 0
      uValue := 0
   Else
      nItem := ::CurrentRow
      If nItem > 0 .AND. nItem <= Len( ::aRecMap )
         uValue := ::aRecMap[ nItem ]
      Else
         uValue := 0
      EndIf
   EndIf

Return uValue

*-----------------------------------------------------------------------------*
METHOD RefreshData() CLASS TOBrowse
*-----------------------------------------------------------------------------*

   ::Refresh()

Return ::TGrid:RefreshData()

*-----------------------------------------------------------------------------*
METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local cWorkArea, _RecNo, nRow, uGridValue, aCellData, aPos

   If nMsg == WM_CHAR
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

      If ::SearchCol < 1 .OR. ::SearchCol > ::ColumnCount
         Return 0
      EndIf

      cWorkArea := ::WorkArea
      If Select( cWorkArea ) == 0
         Return 0
      EndIf

      _RecNo := ( cWorkArea )->( RecNo() )

      nRow := ::Value
      If nRow == 0
         If Len( ::aRecMap ) == 0
            ::TopBottom( GO_TOP )
         Else
            ::DbGoTo( ::aRecMap[ 1 ] )
         EndIf

         If ::Eof()
            ::DbGoTo( _RecNo )
            Return 0
         EndIf

         nRow := ( cWorkArea )->( RecNo() )
      EndIf
      ::DbGoTo( nRow )
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
         Do While ! ::Eof() .AND. ( cWorkArea )->( RecNo() ) != nRow
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

      If ! ::Eof()
         ::nRow := ( cWorkArea )->( RecNo() )
      EndIf

      ::DbGoTo( _RecNo )
      Return 0

   ElseIf nMsg == WM_KEYDOWN
      Do Case
      Case Select( ::WorkArea ) == 0
         // No database open
      Case wParam == VK_HOME
         ::Home()
         Return 0
      Case wParam == VK_END
         ::End()
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
         ::EditCell( _OOHG_ThisItemRowIndex, _OOHG_ThisItemColIndex, , , , , .F. )
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

*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local nvKey, r, DeltaSelect, lGo, uValue, nNotify := GetNotifyCode( lParam )

   If nNotify == NM_CLICK
      If ::lCheckBoxes
         // detect item
         uValue := ListView_HitOnCheckBox( ::hWnd, GetCursorRow() - GetWindowRow( ::hWnd ), GetCursorCol() - GetWindowCol( ::hWnd ) )
      Else
         uValue := 0
      EndIf

      If ::bPosition == -2 .OR. ::bPosition == 9
         ::nDelayedClick := { ::CurrentRow, 0, uValue, Nil }
         ::CurrentRow := ::nEditRow
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
            r := ::CurrentRow
            If r > 0
               DeltaSelect := r - ::nEditRow
               ::FastUpdate( DeltaSelect, r )
               ::BrowseOnChange()
            ElseIf ::lNoneUnsels
               ::CurrentRow := 0
               ::BrowseOnChange()
            Else
               ::CurrentRow := ::nEditRow
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
         ::nDelayedClick := { ::CurrentRow, 0, uValue, _GetGridCellData( Self, ListView_ItemActivate( lParam ) ) }
         ::CurrentRow := ::nEditRow
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
            r := ::CurrentRow
            If r > 0
               DeltaSelect := r - ::nEditRow
               ::FastUpdate( DeltaSelect, r )
               ::BrowseOnChange()
            ElseIf ::lNoneUnsels
               ::CurrentRow := 0
               ::BrowseOnChange()
            Else
               ::CurrentRow := ::nEditRow
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
         ::nDelayedClick := { ::CurrentRow, 0, 0, Nil }
         ::CurrentRow := ::nEditRow
      Else
         r := ::CurrentRow
         If r > 0
            DeltaSelect := r - ::nEditRow
            ::FastUpdate( DeltaSelect, r )
            ::BrowseOnChange()
         ElseIf ::lNoneUnsels
            ::CurrentRow := 0
            ::BrowseOnChange()
         Else
            ::CurrentRow := ::nEditRow
         EndIf
      EndIf
      Return Nil

   ElseIf nNotify == LVN_KEYDOWN
      If GetGridvKeyAsChar( lParam ) == 0
         ::cText := ""
      EndIf

      nvKey := GetGridvKey( lParam )

      Do Case
      Case Select( ::WorkArea ) == 0
         // No database open
      Case nvKey == VK_A .AND. GetKeyFlagState() == MOD_ALT
         If ::lAppendOnAltA
            ::AppendItem()
         EndIf
      Case nvKey == VK_DELETE
         If ::AllowDelete .AND. ! ::Eof()
            If HB_IsBlock( ::bDelWhen )
               lGo := Eval( ::bDelWhen )
            Else
               lGo := .T.
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

*-----------------------------------------------------------------------------*
METHOD SetScrollPos( nPos, VScroll ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local BackRec, cWorkArea := ::WorkArea

   If Select( cWorkArea ) == 0
      // Not workarea selected
   ElseIf nPos <= VScroll:RangeMin
      ::GoTop()
   ElseIf nPos >= VScroll:RangeMax
      ::GoBottom()
   Else
      BackRec := ( cWorkArea )->( RecNo() )
      ::Super:SetScrollPos( nPos, VScroll )
      ::Value := ( cWorkArea )->( RecNo() )
      ::DbGoTo( BackRec )
      ::BrowseOnChange()
   EndIf

Return Self

*-----------------------------------------------------------------------------*
FUNCTION SetBrowseSync( lValue )
*-----------------------------------------------------------------------------*

   If ValType( lValue ) == "L"
      _OOHG_BrowseSyncStatus := lValue
   EndIf

Return _OOHG_BrowseSyncStatus

*-----------------------------------------------------------------------------*
FUNCTION SetBrowseFixedBlocks( lValue )
*-----------------------------------------------------------------------------*

   If ValType( lValue ) == "L"
      _OOHG_BrowseFixedBlocks := lValue
   EndIf

Return _OOHG_BrowseFixedBlocks

*-----------------------------------------------------------------------------*
FUNCTION SetBrowseFixedControls( lValue )
*-----------------------------------------------------------------------------*

   If ValType( lValue ) == "L"
      _OOHG_BrowseFixedControls := lValue
   EndIf

Return _OOHG_BrowseFixedControls





CLASS TOBrowseByCell FROM TOBrowse
   DATA Type                      INIT "BROWSEBYCELL" READONLY

   METHOD AddColumn
   METHOD BrowseOnChange
   METHOD CurrentCol              SETGET
   METHOD Define2
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
   METHOD Home
   METHOD Left
   METHOD PageDown
   METHOD PageUp
   METHOD Right
   METHOD SetScrollPos
   METHOD SetSelectedColors
   METHOD SetValue
   METHOD Up
   METHOD Value                   SETGET

   MESSAGE GoBottom               METHOD End
   MESSAGE GoTop                  METHOD Home

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

*-----------------------------------------------------------------------------*
METHOD Define3( ControlName, ParentForm, x, y, w, h, fontname, fontsize, ;
                tooltip, aHeadClick, nogrid, aImage, break, HelpId, bold, ;
                italic, underline, strikeout, edit, backcolor, fontcolor, ;
                dynamicbackcolor, dynamicforecolor, aPicture, lRtl, InPlace, ;
                editcontrols, readonly, valid, validmessages, editcell, ;
                aWhenFields, lDisabled, lNoTabStop, lInvisible, lHasHeaders, ;
                aHeaderImage, aHeaderImageAlign, FullMove, aSelectedColors, ;
                aEditKeys, dblbffr, lFocusRect, lPLM, lFixedCols, abortedit, ;
                click, lFixedWidths, bBeforeColMove, bAfterColMove, ;
                bBeforeColSize, bAfterColSize, bBeforeAutofit, lLikeExcel, ;
                lButtons, AllowDelete, DelMsg, lNoDelMsg, AllowAppend, ;
                lNoModal, lFixedCtrls, bHeadRClick, lExtDbl, Value, lSilent, ;
                lAltA, lNoShowAlways, lNone, lCBE, onrclick, editend ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local nAux

   Empty( lNone )

   ::TGrid:Define( ControlName, ParentForm, x, y, w, h, ::aHeaders, ::aWidths, ;
                   {}, Nil, fontname, fontsize, tooltip, Nil, Nil, aHeadClick, ;
                   Nil, Nil, nogrid, aImage, ::aJust, break, HelpId, bold, ;
                   italic, underline, strikeout, Nil, Nil, Nil, edit, ;
                   backcolor, fontcolor, dynamicbackcolor, dynamicforecolor, ;
                   aPicture, lRtl, InPlace, editcontrols, readonly, valid, ;
                   validmessages, editcell, aWhenFields, lDisabled, ;
                   lNoTabStop, lInvisible, lHasHeaders, Nil, aHeaderImage, ;
                   aHeaderImageAlign, FullMove, aSelectedColors, aEditKeys, ;
                   Nil, Nil, dblbffr, lFocusRect, lPLM, lFixedCols, abortedit, ;
                   click, lFixedWidths, bBeforeColMove, bAfterColMove, ;
                   bBeforeColSize, bAfterColSize, bBeforeAutofit, lLikeExcel, ;
                   lButtons, AllowDelete, Nil, Nil, DelMsg, lNoDelMsg, ;
                   AllowAppend, Nil, lNoModal, lFixedCtrls, bHeadRClick, Nil, ;
                   Nil, lExtDbl, lSilent, lAltA, lNoShowAlways, .T., lCBE, ;
                   onrclick, Nil, editend )

   If HB_IsArray( Value ) .AND. Len( Value ) > 1
      nAux := Value[ 1 ]
      If HB_IsNumeric( nAux ) .AND. nAux >= 0
         ::nRecLastValue := nAux
      EndIf
      nAux := Value[ 2 ]
      If HB_IsNumeric( nAux ) .AND. nAux >= 0 .AND. nAux <= Len( ::aHeaders )
         ::nColPos := nAux
      EndIf
   EndIf

Return Self

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
                lExtDbl, lSilent, lAltA, lNoShowAlways, lNone, lCBE, onrclick, ;
                oninsert, editend ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*

   Empty( nStyle )
   Empty( InPlace )          // Forced to .T., it's needed for edit controls to work properly
   Empty( oninsert )
   ASSIGN lFocusRect VALUE lFocusRect TYPE "L" DEFAULT .F.

   ::Super:Define2( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
                    aRows, value, fontname, fontsize, tooltip, change, dblclick, ;
                    aHeadClick, gotfocus, lostfocus, nogrid, aImage, aJust, ;
                    break, HelpId, bold, italic, underline, strikeout, ownerdata, ;
                    ondispinfo, itemcount, editable, backcolor, fontcolor, ;
                    dynamicbackcolor, dynamicforecolor, aPicture, lRtl, LVS_SINGLESEL, ;
                    .T., editcontrols, readonly, valid, validmessages, ;
                    editcell, aWhenFields, lDisabled, lNoTabStop, lInvisible, ;
                    lHasHeaders, onenter, aHeaderImage, aHeaderImageAlign, FullMove, ;
                    aSelectedColors, aEditKeys, lCheckBoxes, oncheck, lDblBffr, ;
                    lFocusRect, lPLM, lFixedCols, abortedit, click, lFixedWidths, ;
                    bBeforeColMove, bAfterColMove, bBeforeColSize, bAfterColSize, ;
                    bBeforeAutofit, lLikeExcel, lButtons, AllowDelete, onDelete, ;
                    bDelWhen, DelMsg, lNoDelMsg, AllowAppend, onappend, lNoModal, ;
                    lFixedCtrls, bHeadRClick, lClickOnCheckbox, lRClickOnCheckbox, ;
                    lExtDbl, lSilent, lAltA, lNoShowAlways, lNone, lCBE, onrclick, ;
                    Nil, editend)

   // By default, search in the current column
   ::SearchCol := -1

Return Self

*-----------------------------------------------------------------------------*
METHOD AddColumn( nColIndex, xField, cHeader, nWidth, nJustify, uForeColor, ;
                  uBackColor, lNoDelete, uPicture, uEditControl, uHeadClick, ;
                  uValid, uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign, ;
                  uReplaceField, lRefresh, uReadOnly ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*

   nColIndex := ::Super:AddColumn( nColIndex, xField, cHeader, nWidth, nJustify, uForeColor, ;
                                   uBackColor, lNoDelete, uPicture, uEditControl, uHeadClick, ;
                                   uValid, uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign, ;
                                   uReplaceField, lRefresh, uReadOnly )

   If nColIndex <= ::nColPos
      ::CurrentCol := ::nColPos + 1
      ::DoChange()
   EndIf

Return nColIndex

*-----------------------------------------------------------------------------*
METHOD DeleteAllItems() CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*

   ::nRowPos := 0
   ::nColPos := 0

Return ::Super:DeleteAllItems()

*-----------------------------------------------------------------------------*
METHOD DeleteColumn( nColIndex, lNoDelete ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*

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

*-----------------------------------------------------------------------------*
METHOD SetSelectedColors( aSelectedColors, lRedraw ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
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

*-----------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local nItem

   If HB_IsArray( uValue ) .AND. Len( uValue ) > 1
      If HB_IsNumeric( uValue[ 1 ] ) .AND. uValue[ 1 ] >= 0
         If HB_IsNumeric( uValue[ 2 ] ) .AND. uValue[ 2 ] >= 0 .AND. uValue[ 2 ] <= Len( ::aHeaders )
            If ( nItem := aScan( ::aRecMap, uValue[ 1 ] ) ) > 0
               ::SetValue( uValue, nItem )
            Else
               ::SetValue( uValue )
            EndIf
         EndIf
      EndIf
   EndIf

   If Select( ::WorkArea ) == 0
      ::RecCount := 0
      ::CurrentRow := 0
      ::nColPos := 0
      ::nRecLastValue := 0
      uValue := { 0, 0 }
   ElseIf ::ItemCount == 0
      ::CurrentRow := 0
      ::nColPos := 0
      ::nRecLastValue := 0
      uValue := { 0, 0 }
   Else
      ::nRowPos := ::CurrentRow
      If ::nRowPos > 0 .AND. ::nRowPos <= Len( ::aRecMap ) .AND. ::nColPos >= 1 .AND. ::nColPos <= Len( ::aHeaders )
         uValue := { ::aRecMap[ ::nRowPos ], ::nColPos }
      Else
         ::CurrentRow := 0
         ::nColPos := 0
         ::nRecLastValue := 0
         uValue := { 0, 0 }
      EndIf
   EndIf

Return uValue

*-----------------------------------------------------------------------------*
METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local cWorkArea, _RecNo, aValue, uGridValue, nRow, nCol

   If nMsg == WM_CHAR
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

      If ::SearchCol < 1 .OR. ::SearchCol > ::ColumnCount
         ::SearchCol := ::nColPos
         If ::SearchCol < 1 .OR. ::SearchCol > ::ColumnCount
            Return 0
         EndIf
      EndIf

      cWorkArea := ::WorkArea
      If Select( cWorkArea ) == 0
         Return 0
      EndIf

      _RecNo := ( cWorkArea )->( RecNo() )

      aValue := ::Value
      nRow := aValue[ 1 ]
      If nRow == 0
         If Len( ::aRecMap ) == 0
            ::TopBottom( GO_TOP )
         Else
            ::DbGoTo( ::aRecMap[ 1 ] )
         EndIf

         If ::Eof()
            ::DbGoTo( _RecNo )
            Return 0
         EndIf

         nRow := ( cWorkArea )->( RecNo() )
      EndIf
      ::DbGoTo( nRow )
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
         Do While ! ::Eof() .AND. ( cWorkArea )->( RecNo() ) != nRow
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

      If ! ::Eof()
         ::Value := { ( cWorkArea )->( RecNo() ), ::nColPos }
      EndIf

      ::DbGoTo( _RecNo )
      Return 0

   ElseIf nMsg == WM_KEYDOWN
      Do Case
      Case Select( ::WorkArea ) == 0
         // No database open
      Case wParam == VK_HOME
         ::Home()
         Return 0
      Case wParam == VK_END
         ::End()
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
         If GetKeyFlagState() == MOD_CONTROL
            nCol := ::FirstColInOrder
            If nCol # 0
               ::Value := { ::nRowPos, nCol }
            EndIf
         Else
            ::Left()
         EndIf
         Return 0
      Case wParam == VK_RIGHT
         If GetKeyFlagState() == MOD_CONTROL
            nCol := ::LastColInOrder
            If nCol # 0
               ::Value := { ::nRowPos, nCol }
            EndIf
         Else
            ::Right()
         EndIf
         Return 0
      EndCase

   EndIf

Return ::Super:Events( hWnd, nMsg, wParam, lParam )

*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local nvKey, r, DeltaSelect, lGo, aCellData, uValue, nNotify := GetNotifyCode( lParam )

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
         ::CurrentRow := ::nEditRow
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
            r := ::CurrentRow
            If r > 0
               DeltaSelect := r - ::nEditRow
               ::FastUpdate( DeltaSelect, r )
               ::BrowseOnChange()
            ElseIf ::lNoneUnsels
               ::CurrentRow := 0
               ::BrowseOnChange()
            Else
               ::CurrentRow := ::nEditRow
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
         aCellData := _GetGridCellData( Self, ListView_ItemActivate( lParam ) )
         ::nDelayedClick := { aCellData[ 1 ], aCellData[ 2 ], uValue, aCellData }
         ::CurrentRow := ::nEditRow
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
            r := ::CurrentRow
            If r > 0
               DeltaSelect := r - ::nEditRow
               ::FastUpdate( DeltaSelect, r )
               ::BrowseOnChange()
            ElseIf ::lNoneUnsels
               ::CurrentRow := 0
               ::BrowseOnChange()
            Else
               ::CurrentRow := ::nEditRow
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
         aCellData := _GetGridCellData( Self, ListView_ListView( lParam ) )
         ::nDelayedClick := { aCellData[ 1 ], aCellData[ 2 ], 0, Nil }
         ::CurrentRow := ::nEditRow
      Else
         r := ::CurrentRow
         If r > 0
            DeltaSelect := r - ::nEditRow
            ::FastUpdate( DeltaSelect, r )
            ::BrowseOnChange()
         ElseIf ::lNoneUnsels
            ::CurrentRow := 0
            ::BrowseOnChange()
         Else
            ::CurrentRow := ::nEditRow
         EndIf
      EndIf
      Return Nil

   ElseIf nNotify == LVN_KEYDOWN
      If GetGridvKeyAsChar( lParam ) == 0
         ::cText := ""
      EndIf

      nvKey := GetGridvKey( lParam )

      Do Case
      Case Select( ::WorkArea ) == 0
         // No database open
      Case nvKey == VK_A .AND. GetKeyFlagState() == MOD_ALT
         If ::lAppendOnAltA
            ::AppendItem()
         EndIf
      Case nvKey == VK_DELETE
         If ::AllowDelete .AND. ! ::Eof()
            If HB_IsBlock( ::bDelWhen )
               lGo := Eval( ::bDelWhen )
            Else
               lGo := .t.
            EndIf

            If lGo
               If ::lNoDelMsg.OR.  MsgYesNo( _OOHG_Messages(4, 1), _OOHG_Messages(4, 2) )
                  ::Delete()
               EndIf
            ElseIf ! Empty( ::DelMsg )
               MsgExclamation( ::DelMsg, _OOHG_Messages(4, 2) )
            EndIf
         EndIf
      EndCase
      Return Nil

   ElseIf nNotify == LVN_ITEMCHANGED
      Return Nil

   ElseIf nNotify == NM_CUSTOMDRAW
      ::AdjustRightScroll()
      Return TGrid_Notify_CustomDraw( Self, lParam, .T., ::nRowPos, ::nColPos, .F., ::lFocusRect, ::lNoGrid, ::lPLM )

   EndIf

Return ::Super:Events_Notify( wParam, lParam )

*-----------------------------------------------------------------------------*
METHOD EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, lAppend, nOnFocusPos, lRefresh, lChange ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local lRet, BackRec, cWorkArea

   ASSIGN lAppend  VALUE lAppend  TYPE "L" DEFAULT .F.
   ASSIGN nRow     VALUE nRow     TYPE "N" DEFAULT ::nRowPos
   ASSIGN nCol     VALUE nCol     TYPE "N" DEFAULT ::nColPos
   ASSIGN lRefresh VALUE lRefresh TYPE "L" DEFAULT ( ::RefreshType == REFRESH_FORCE )
   ASSIGN lChange  VALUE lChange  TYPE "L" DEFAULT ::lChangeBeforeEdit

   If nRow < 1 .OR. nRow > ::ItemCount .OR. nCol < 1 .OR. nCol > Len( ::aHeaders ) .OR. aScan( ::aHiddenCols, nCol ) # 0
      Return .F.
   EndIf

   cWorkArea := ::WorkArea
   If Select( cWorkArea ) == 0
      ::RecCount := 0
      Return .F.
   EndIf

   If lAppend
      BackRec := ( cWorkArea )->( RecNo() )
      ::DbGoTo( 0 )
   Else
      If lChange
         ::Value := { ::aRecMap[ nRow ], nCol }
      EndIf
      BackRec := ( cWorkArea )->( RecNo() )
      ::DbGoTo( ::aRecMap[ nRow ] )
   EndIf

   ::lCalledFromClass := .T.
   lRet := ::TXBrowse:EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, lAppend, nOnFocusPos )
   ::lCalledFromClass := .F.

   If lRet .AND. lAppend
      aAdd( ::aRecMap, ( cWorkArea )->( RecNo() ) )
   EndIf

   ::DbGoTo( BackRec )

   If lRet
      If lAppend .AND. lChange
         ::Value := { aTail( ::aRecMap ), nCol }
      Else
         If ! ::lCalledFromClass .AND. ::bPosition == 9                  // MOUSE EXIT
            // Edition window lost focus
            ::bPosition := 0                   // This restores the processing of click messages
            If ::nDelayedClick[ 1 ] > 0
               // A click message was delayed
               If ::nDelayedClick[ 3 ] <= 0
                  ::SetValue( { ::aRecMap[ ::nDelayedClick[ 1 ] ], ::nDelayedClick[ 2 ] }, ::nDelayedClick[ 1 ] )
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
         If lRefresh
            ::Refresh()
         EndIf
      EndIf

      // ::bPosition is set by TGridControl()
      If ::bPosition == 1                            // UP
         ::Up()
      ElseIf ::bPosition == 2                        // RIGHT
         ::Right( .F. )
      ElseIf ::bPosition == 3                        // LEFT
         ::Left()
      ElseIf ::bPosition == 4                        // HOME
         ::GoTop()
      ElseIf ::bPosition == 5                        // END
         ::GoBottom( .F. )
      ElseIf ::bPosition == 6                        // DOWN
         ::Down( .F. )
      ElseIf ::bPosition == 7                        // PRIOR
         ::PageUp()
      ElseIf ::bPosition == 8                        // NEXT
         ::PageDown( .F. )
      ElseIf ::bPosition == 9                        // MOUSE EXIT
      Else                                           // OK
      EndIf
   EndIf

Return lRet

*-----------------------------------------------------------------------------*
METHOD EditCell2( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, nOnFocusPos ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*

   ASSIGN nRow VALUE nRow TYPE "N" DEFAULT ::nRowPos
   ASSIGN nCol VALUE nCol TYPE "N" DEFAULT ::nColPos

Return ::Super:EditCell2( @nRow, @nCol, EditControl, uOldValue, @uValue, cMemVar, nOnFocusPos )

*-----------------------------------------------------------------------------*
METHOD EditItem_B( lAppend, lOneRow ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   ASSIGN lOneRow VALUE lOneRow TYPE "L" DEFAULT .T.

   If lAppend .AND. ! ::AllowAppend
      Return .F.
   EndIf

   If Select( ::WorkArea ) == 0
      ::RecCount := 0
      Return .F.
   EndIf

   If ::nRowPos == 0 .AND. ! lAppend
      Return .F.
   EndIf

Return ::EditAllCells( , , lAppend, lOneRow, .T., ::RefreshType == REFRESH_DEFAULT .OR. ::RefreshType == REFRESH_FORCE )

*-----------------------------------------------------------------------------*
METHOD EditAllCells( nRow, nCol, lAppend, lOneRow, lChange, lRefresh ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local lRet, lSomethingEdited, lRowAppended, nRecNo, cWorkArea, nNextCol

   ASSIGN lOneRow VALUE lOneRow TYPE "L" DEFAULT .T.
   If ::FullMove .OR. ! lOneRow
      Return ::EditGrid( nRow, nCol, lAppend, lOneRow, lChange, lRefresh )
   EndIf
   If ::FirstVisibleColumn == 0
      Return .F.
   EndIf
   If ! HB_IsNumeric( nCol )
      nCol := ::FirstColInOrder
   EndIf
   If nCol < 1 .OR. nCol > Len( ::aHeaders )
      Return .F.
   EndIf

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   If lAppend
      ::GoBottom( .T. )
      ::InsertBlank( ::ItemCount + 1 )
      ::CurrentRow := ::ItemCount
      ::CurrentCol := nCol
      ::lAppendMode := .T.
   Else
      If ! HB_IsNumeric( nRow )
         nRow := Max( ::nRowPos, 1 )
      EndIf
      If nRow < 1 .OR. nRow > ::ItemCount
         Return .F.
      EndIf

      ASSIGN lChange VALUE lChange TYPE "L" DEFAULT ::lChangeBeforeEdit
      If lChange
         ::Value := { ::aRecMap[ nRow ], nCol }
      EndIf
   EndIf

   ASSIGN lRefresh VALUE lRefresh TYPE "L" DEFAULT ( ::RefreshType == REFRESH_DEFAULT .OR. ::RefreshType == REFRESH_FORCE )

   cWorkArea := ::WorkArea

   lSomethingEdited := .F.

   Do While ::nRowPos >= 1 .AND. ::nRowPos <= ::ItemCount .AND. ::nColPos >= 1 .AND. ::nColPos <= Len( ::aHeaders ) .AND. Select( cWorkArea ) # 0
      nRecNo := ( cWorkArea )->( RecNo() )
      If lAppend
         ::DbGoTo( 0 )
      Else
         ::DbGoTo( ::aRecMap[ ::nRowPos ] )
      EndIf

      _OOHG_ThisItemCellValue := ::Cell( ::nRowPos, ::nColPos )

      If ::IsColumnReadOnly( ::nColPos, ::nRowPos )
        // Read only column
      ElseIf ! ::IsColumnWhen( ::nColPos, ::nRowPos )
        // WHEN returned .F.
      ElseIf aScan( ::aHiddenCols, ::nColPos, ::nRowPos ) > 0
        // Hidden column
      Else
         ::DbGoTo( nRecNo )

         ::lCalledFromClass := .T.
         lRet := ::EditCell( ::nRowPos, ::nColPos, , , , , lAppend, , .F., .F. )
         ::lCalledFromClass := .F.

         If ! lRet
            If lAppend
               ::lAppendMode := .F.
               ::GoBottom()
            EndIf
            Exit
         EndIf

         lSomethingEdited := .T.
         If lAppend
            lRowAppended := .T.
            lAppend := .F.
         EndIf

         If ::bPosition == 9                     // MOUSE EXIT
            // Edition window lost focus
            ::bPosition := 0                   // This restores click messages processing
            If ::nDelayedClick[ 1 ] > 0
               // A click message was delayed
               If ::nDelayedClick[ 3 ] <= 0
                  ::SetValue( { ::aRecMap[ ::nDelayedClick[ 1 ] ], ::nDelayedClick[ 2 ] }, ::nDelayedClick[ 1 ] )
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
            ElseIf lRowAppended
               // A new row was added and partially edited: set as new value and refresh the control
               ::SetValue( { aTail( ::aRecMap ), ::nColPos }, ::nRowPos )
            Else
               // The user aborted the edition of an existing row: refresh the control without changing it's value
            EndIf
            If lRefresh
               ::Refresh()
            EndIf
            Exit
         EndIf
      EndIf

      nNextCol := ::NextColInOrder( ::nColPos )
      If nNextCol == 0
         Exit
      EndIf
      ::CurrentCol := nNextCol
   EndDo

   ::ScrollToLeft()

Return lSomethingEdited


*-----------------------------------------------------------------------------*
METHOD EditGrid( nRow, nCol, lAppend, lOneRow, lChange, lRefresh ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local lSomethingEdited, nRecNo, lRet, lRowAppended, cWorkArea

   If ::FirstVisibleColumn == 0
      Return .F.
   EndIf

   ASSIGN nRow     VALUE nRow     TYPE "N" DEFAULT ::nRowPos
   ASSIGN nCol     VALUE nCol     TYPE "N" DEFAULT ::nColPos
   ASSIGN lAppend  VALUE lAppend  TYPE "L" DEFAULT .F.
   ASSIGN lOneRow  VALUE lOneRow  TYPE "L" DEFAULT .F.
   ASSIGN lChange  VALUE lChange  TYPE "L" DEFAULT ::lChangeBeforeEdit
   ASSIGN lRefresh VALUE lRefresh TYPE "L" DEFAULT ( ::RefreshType == REFRESH_FORCE )

   If nRow < 1 .OR. nRow > ::ItemCount .OR. nCol < 1 .OR. nCol > Len( ::aHeaders )
      Return .F.
   EndIf

   cWorkArea := ::WorkArea

   If lChange
      ::Value := { ::aRecMap[ nRow ], nCol }
   EndIf

   lSomethingEdited := .F.

   Do While nCol >= 1 .AND. nCol <= Len( ::aHeaders ) .AND. nRow >= 1 .AND. nRow <= ::ItemCount .AND. Select( cWorkArea ) # 0
      nRecNo := ( cWorkArea )->( RecNo() )
      If lAppend
         ::DbGoTo( 0 )
      Else
         ::DbGoTo( ::aRecMap[ nRow ] )
      EndIf

      _OOHG_ThisItemCellValue := ::Cell( nRow, nCol )

      If ::IsColumnReadOnly( nCol, nRow )
         // Read only column
      ElseIf ! ::IsColumnWhen( nCol, nRow )
         // Not a valid WHEN
      ElseIf aScan( ::aHiddenCols, nCol ) > 0
         // Hidden column
      Else
         ::DbGoTo( nRecNo )

         lRowAppended := .F.
         ::lCalledFromClass := .T.
         lRet := ::EditCell( nRow, nCol, , , , , lAppend, , lRefresh, .F. )
         ::lCalledFromClass := .F.

         If ! lRet
            If lAppend
               ::lAppendMode := .F.
               lAppend := .F.
               ::GoBottom()
            EndIf
            Exit
         EndIf

         lSomethingEdited := .T.
         If lAppend
            lRowAppended := .T.
            ::lAppendMode := .F.
            lAppend := .F.
            ::DoEvent( ::OnAppend, "APPEND" )
         EndIf
      EndIf

      /*
       * ::OnEditCell() may change ::nRowPos and/or ::nColPos
       * using ::Up(), ::Down(), ::Left(), ::Right(), ::PageUp(),
       * ::PageDown(), ::GoTop() and/or ::GoBottom()
       */

      // ::bPosition is set by TGridControl()
      If ::bPosition == 1                            // UP
         If ! ::Up() .OR. ! ::FullMove .OR. lOneRow
            Exit
         EndIf
      ElseIf ::bPosition == 2                        // RIGHT
         If ::Right( .F. )
            If lOneRow .AND. ::Value[ 1 ] # ::aRecMap[ nRow ]
               Exit
            EndIf
         Else
           If ::FullMove .AND. ::AllowAppend .AND. ! lOneRow
              lAppend := .T.
           Else
              Exit
           EndIf
         EndIf
      ElseIf ::bPosition == 3                        // LEFT
         If ! ::Left() .OR. ( lOneRow .AND. ::Value[ 1 ] # ::aRecMap[ nRow ] )
            Exit
         EndIf
      ElseIf ::bPosition == 4                        // HOME
         If ! ::GoTop() .OR. ! ::FullMove .OR. ( lOneRow .AND. ::Value[ 1 ] # ::aRecMap[ nRow ] )
            Exit
         EndIf
      ElseIf ::bPosition == 5                        // END
         ::GoBottom()
         If ! ::FullMove .OR. ( lOneRow .AND. ::Value[ 1 ] # ::aRecMap[ nRow ] )
            Exit
         EndIf
      ElseIf ::bPosition == 6                        // DOWN
         If ::Down( .F. )
            If ! ::FullMove .OR. ( lOneRow .AND. ::Value[ 1 ] # ::aRecMap[ nRow ] )
               Exit
            EndIf
         Else
            If ::FullMove .AND. ::AllowAppend .AND. ! lOneRow
               lAppend := .T.
           Else
              Exit
           EndIf
         EndIf
      ElseIf ::bPosition == 7                        // PRIOR
         If ! ::PageUp() .OR. ! ::FullMove .OR. lOneRow
            Exit
         EndIf
      ElseIf ::bPosition == 8                        // NEXT
         If ::PageDown( .F. )
            If ! ::FullMove .OR. ( lOneRow .AND. ::Value[ 1 ] # ::aRecMap[ nRow ] )
               Exit
            EndIf
         Else
            If ::FullMove .AND. ::AllowAppend .AND. ! lOneRow
               lAppend := .T.
           Else
              Exit
           EndIf
         EndIf
      ElseIf ::bPosition == 9                        // MOUSE EXIT
         // Edition window lost focus
         ::bPosition := 0                   // This restores click messages processing
         If ::nDelayedClick[ 1 ] > 0
            // A click message was delayed
            If ::nDelayedClick[ 3 ] <= 0
               ::SetValue( { ::aRecMap[ ::nDelayedClick[ 1 ] ], ::nDelayedClick[ 2 ] }, ::nDelayedClick[ 1 ] )
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
         ElseIf lRowAppended
            // A new row was added and partially edited: set as new value and refresh the control
            ::SetValue( { aTail( ::aRecMap ), nCol }, nRow )
         Else
            // The user aborted the edition of an existing row: refresh the control without changing it's value
         EndIf
         If lRefresh
            ::Refresh()
         EndIf
         Exit
      Else                                           // OK
         If ::FullMove
            ::Right( .F. )
            lAppend := ::Eof() .AND. ::AllowAppend
         ElseIf ::nColPos # ::LastColInOrder
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
         ::CurrentCol := ::FirstColInOrder
         ::lAppendMode := .T.
      EndIf

      nRow := ::nRowPos
      nCol := ::nColPos
   EndDo

Return lSomethingEdited

*-----------------------------------------------------------------------------*
METHOD BrowseOnChange() CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local cWorkArea, lSync, nRec

   If ::lUpdCols
      ::UpdateColors()
   EndIf

   If HB_IsLogical( ::SyncStatus )
      lSync := ::SyncStatus
   Else
      lSync := _OOHG_BrowseSyncStatus
   EndIf

   If lSync
      cWorkArea := ::WorkArea
      nRec := ::Value[ 1 ]
      If Select( cWorkArea ) != 0 .AND. ( cWorkArea )->( RecNo() ) != nRec
         ::DbGoTo( nRec )
      EndIf
   EndIf

   ::DoChange()

Return Self

*-----------------------------------------------------------------------------*
METHOD DoChange() CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local xValue, cType, cOldType

   xValue   := ::Value
   cType    := ValType( xValue )
   cOldType := ValType( ::xOldValue )
   cType    := If( cType == "M", "C", cType )
   cOldType := If( cOldType == "M", "C", cOldType )

   If ( cOldType == "U" .OR. ! cType == cOldType .OR. ;
        ( HB_IsArray( xValue ) .AND. ! HB_IsArray( ::xOldValue ) ) .OR. ;
        ( ! HB_IsArray( xValue ) .AND. HB_IsArray( ::xOldValue ) ) .OR. ;
        ! AEqual( xValue, ::xOldValue ) )
      ::xOldValue := xValue
      ::DoEvent( ::OnChange, "CHANGE" )
   EndIf

   ::nRecLastValue := xValue[ 1 ]

Return Self

*-----------------------------------------------------------------------------*
METHOD SetValue( Value, mp ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local nRow, nCol, _RecNo, m, hWnd, cWorkArea

   cWorkArea := ::WorkArea
   If Select( cWorkArea ) == 0
      ::RecCount := 0
      Return Self
   EndIf

   hWnd := ::hWnd
   If _OOHG_ThisEventType == 'BROWSE_ONCHANGE'
      If hWnd == _OOHG_ThisControl:hWnd
         MsgOOHGError( "BROWSEBYCELL: Value property can't be changed inside ONCHANGE event. Program Terminated." )
      EndIf
   EndIf

   If HB_IsArray( Value ) .AND. Len( Value ) > 1
      nRow := Value[ 1 ]
      nCol := Value[ 2 ]
      If HB_IsNumeric( nRow ) .AND. nRow > 0 .AND. HB_IsNumeric( nCol ) .AND. nCol >= 1 .AND. nCol <= Len( ::aHeaders )
         If nRow > ( cWorkArea )->( RecCount() )
            ::DeleteAllItems()
            ::BrowseOnChange()
            Return Self
         EndIf

         If ValType( mp ) != "N"
            m := Int( ::CountPerPage / 2 )
         Else
            m := mp
         EndIf

         _RecNo := ( cWorkArea )->( RecNo() )

         ::DbGoTo( nRow )
         If ::Eof()
            ::DbGoTo( _RecNo )
            Return Self
         EndIf

         // Enforce filters in use
         ::DbSkip()
         ::DbSkip( -1 )
         If ( cWorkArea )->( RecNo() ) != nRow
            ::DbGoTo( _RecNo )
            Return Self
         EndIf

         If PCount() < 2
            ::ScrollUpdate()
         EndIf
         ::DbSkip( -m + 1 )
         ::Update()
         ::DbGoTo( _RecNo )
         ::CurrentRow := aScan( ::aRecMap, nRow )
         ::CurrentCol := nCol

         _OOHG_ThisEventType := 'BROWSE_ONCHANGE'
         ::BrowseOnChange()
         _OOHG_ThisEventType := ''
      Else
         If ::lNoneUnsels
            ::CurrentRow := 0
            ::BrowseOnChange()
         EndIf
      EndIf
   Else
      If ::lNoneUnsels
         ::CurrentRow := 0
         ::BrowseOnChange()
      EndIf
   EndIf

Return Self

*-----------------------------------------------------------------------------*
METHOD Delete() CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local Value, nRow, nRecNo, lSync, cWorkArea

   Value := ::Value
   nRow  := Value[ 1 ]

   If nRow == 0
      Return Self
   EndIf

   cWorkArea := ::WorkArea
   nRecNo := ( cWorkArea )->( RecNo() )

   ::DbGoTo( nRow )

   If ::Lock .AND. ! ( cWorkArea )->( Rlock() )
      MsgExclamation( _OOHG_Messages( 3, 9 ), _OOHG_Messages( 4, 2 ) )
   Else
      ( cWorkArea )->( DbDelete() )

      // Do before unlocking record or moving record pointer
      // so block can operate on deleted record (e.g. to copy to a log).
      If HB_IsBlock( ::OnDelete )
         ::DoEvent( ::OnDelete, 'DELETE' )
      EndIf

      If ::Lock
         ( cWorkArea )->( DbCommit() )
         ( cWorkArea )->( DbUnlock() )
      EndIf
      ::DbSkip()
      If ::Eof()
         ::TopBottom( GO_BOTTOM )
      EndIf

      If Set( _SET_DELETED )
         ::SetValue( { ( cWorkArea )->( RecNo() ), 1 }, ::nRowPos )
      EndIf
   EndIf

   If HB_IsLogical( ::SyncStatus )
      lSync := ::SyncStatus
   Else
      lSync := _OOHG_BrowseSyncStatus
   EndIf

   If lSync
      Value := ::Value
      nRow  := Value[ 1 ]

      If ( cWorkArea )->( RecNo() ) != nRow
         ::DbGoTo( nRow )
      EndIf
   Else
      ::DbGoTo( nRecNo )
   EndIf

Return Self

*-----------------------------------------------------------------------------*
METHOD Home() CLASS TOBrowseByCell                   // METHOD GoTop
*-----------------------------------------------------------------------------*
Local _RecNo, aBefore, aAfter, lDone := .F., cWorkArea

   cWorkArea := ::WorkArea
   If Select( cWorkArea ) == 0
      ::RecCount := 0
      Return lDone
   EndIf
   aBefore := ::Value
   _RecNo := ( cWorkArea )->( RecNo() )
   ::TopBottom( GO_TOP )
   ::ScrollUpdate()
   ::Update()
   ::DbGoTo( _RecNo )
   ::CurrentRow := 1
   ::CurrentCol := ::FirstColInOrder
   aAfter := ::Value
   lDone := ( aBefore[ 1 ] # aAfter[ 1 ] .OR. aBefore[ 2 ] # aAfter[ 2 ] )
   ::BrowseOnChange()

Return lDone

*-----------------------------------------------------------------------------*
METHOD End( lAppend ) CLASS TOBrowseByCell     // METHOD GoBottom
*-----------------------------------------------------------------------------*
Local lDone := .F., aBefore, _Recno, cWorkArea

   cWorkArea := ::WorkArea
   If Select( cWorkArea ) == 0
      ::RecCount := 0
      Return lDone
   EndIf
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
   ::CurrentCol := If( lAppend, ::FirstColInOrder, ::LastColInOrder )
   lDone := ( aBefore[ 1 ] # ::Value[ 1 ] .OR. aBefore[ 2 ] # ::Value[ 2 ] )
   ::BrowseOnChange()

Return lDone

//TODO: revisar desde aca
*-----------------------------------------------------------------------------*
METHOD PageUp() CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local _RecNo, aBefore, lDone := .F., cWorkArea

   cWorkArea := ::WorkArea
   If ::nRowPos == 1
      If Select( cWorkArea ) == 0
         ::RecCount := 0
         Return lDone
      EndIf
      aBefore := ::Value
      _RecNo := ( cWorkArea )->( RecNo() )
      If Len( ::aRecMap ) == 0
         ::TopBottom( GO_TOP )
      Else
         ::DbGoTo( ::aRecMap[ 1 ] )
      EndIf
      ::DbSkip( - ::CountPerPage + 1 )
      ::ScrollUpdate()
      ::Update()
      ::DbGoTo( _RecNo )
      ::CurrentRow := 1
      lDone := ( aBefore[ 1 ] # ::Value[ 1 ] .OR. aBefore[ 2 ] # ::Value[ 2 ] )
   Else
      ::FastUpdate( 1 - ::nRowPos, 1 )
      lDone := .T.
   EndIf

   ::BrowseOnChange()

Return lDone

*-----------------------------------------------------------------------------*
METHOD PageDown( lAppend ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local _RecNo, s, lDone := .F., cWorkArea

   s := ::nRowPos

   If  s >= Len( ::aRecMap )
      cWorkArea := ::WorkArea
      If Select( cWorkArea ) == 0
         ::RecCount := 0
         Return lDone
      EndIf

      _RecNo := ( cWorkArea )->( RecNo() )

      If Len( ::aRecMap ) == 0
         ::TopBottom( GO_BOTTOM )
         ::DbSkip( - ::CountPerPage + 1 )
      Else
         ::DbGoTo( ::aRecMap[ Len( ::aRecMap ) ] )
         // Check for more records
         ::DbSkip()
         If ::Eof()
            ::DbGoTo( _RecNo )
            ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
            If lAppend
               lDone := ::AppendItem()
            EndIf
            Return lDone
         EndIf
         ::DbSkip( -1 )
      EndIf
      ::Update()
      If Len( ::aRecMap ) == 0
         ::DbGoTo( 0 )
      Else
         ::DbGoTo( ::aRecMap[ Len( ::aRecMap ) ] )
         lDone := .T.
      EndIf
      ::ScrollUpdate()
      ::DbGoTo( _RecNo )
      ::CurrentRow := Len( ::aRecMap )
   Else
      ::FastUpdate( ::CountPerPage - s, Len( ::aRecMap ) )
      lDone := .T.
   EndIf

   ::BrowseOnChange()

Return lDone

*-----------------------------------------------------------------------------*
METHOD Up( lLast ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local s, _RecNo, nLen, lDone := .F., cWorkArea

   s := ::nRowPos

   If s <= 1
      cWorkArea := ::WorkArea
      If Select( cWorkArea ) == 0
         ::RecCount := 0
         Return lDone
      EndIf

      _RecNo := ( cWorkArea )->( RecNo() )

      If Len( ::aRecMap ) == 0
         ::TopBottom( GO_TOP )
         ::DbSkip( -1 )
         ::Update()
      Else
         // Check for more records
         ::DbGoTo( ::aRecMap[ 1 ] )
         ::DbSkip( -1 )
         If ::Bof()
            ::DbGoTo( _RecNo )
            Return lDone
         EndIf
         // Add one record at the top
         aAdd( ::aRecMap, Nil )
         aIns( ::aRecMap, 1 )
         ::aRecMap[ 1 ] := ( cWorkArea )->( RecNo() )
         If ::Visible
            ::SetRedraw( .F. )
         EndIf
         ::InsertBlank( 1 )
         ::RefreshRow( 1 )
         nLen := Len( ::aRecMap )
         // Resize record map
         If nLen > ::CountPerPage
            ::DeleteItem( nLen )
            aSize( ::aRecMap, nLen - 1 )
         EndIf
         If ::Visible
            ::SetRedraw( .T. )
         EndIf
      EndIf

      ::ScrollUpdate()
      ::DbGoTo( _RecNo )
      ::CurrentRow := 1
      If HB_IsLogical( lLast ) .AND. lLast
         ::CurrentCol := ::LastColInOrder
      EndIf
      If Len( ::aRecMap ) != 0
         lDone := .T.
      EndIf
   Else
      ::FastUpdate( -1, s - 1 )
      lDone := .T.
   EndIf

   ::BrowseOnChange()

Return lDone

*-----------------------------------------------------------------------------*
METHOD Down( lAppend, lFirst ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local s, _RecNo, nLen, lDone := .F., cWorkArea

   s := ::nRowPos

   If s >= Len( ::aRecMap )
      cWorkArea := ::WorkArea
      If Select( cWorkArea ) == 0
         ::RecCount := 0
         Return lDone
      EndIf

      _RecNo := ( cWorkArea )->( RecNo() )

      If Len( ::aRecMap ) == 0
         ::TopBottom( GO_TOP )
         ::DbSkip()
         ::Update()
      Else
         // Check for more records
         ::DbGoTo( ::aRecMap[ Len( ::aRecMap ) ] )
         ::DbSkip()
         If ::Eof()
            ::DbGoTo( _RecNo )
            ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT ::AllowAppend
            If lAppend
               lDone := ::AppendItem()
            EndIf
            Return lDone
         EndIf
         // Add one record at the bottom
         aAdd( ::aRecMap, ( cWorkArea )->( RecNo() ) )
         nLen := Len( ::aRecMap )
         If ::Visible
            ::SetRedraw( .F. )
         EndIf
         ::RefreshRow( nLen )
         // Resize record map
         If nLen > ::CountPerPage
            ::DeleteItem( 1 )
             _OOHG_DeleteArrayItem( ::aRecMap, 1 )
         EndIf
         If ::Visible
            ::SetRedraw( .T. )
         EndIf
      EndIf

      If Len( ::aRecMap ) == 0
         ::DbGoTo( 0 )
      Else
         ::DbGoTo( ATail( ::aRecMap ) )
         lDone := .T.
      EndIf
      ::ScrollUpdate()
      ::DbGoTo( _RecNo )
      ::CurrentRow := Len( ::aRecMap )
      If HB_IsLogical( lFirst ) .AND. lFirst
         ::CurrentCol := ::FirstColInOrder
      EndIf
   Else
      ::FastUpdate( 1, s + 1 )
      lDone := .T.
   EndIf

   ::BrowseOnChange()

Return lDone

*-----------------------------------------------------------------------------*
METHOD SetScrollPos( nPos, VScroll ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local BackRec, cWorkArea

   cWorkArea := ::WorkArea
   If Select( cWorkArea ) == 0
      // Not workarea selected
   ElseIf nPos <= VScroll:RangeMin
      ::GoTop()
   ElseIf nPos >= VScroll:RangeMax
      ::GoBottom()
   Else
      BackRec := ( cWorkArea )->( RecNo() )
      ::Super:SetScrollPos( nPos, VScroll )
      ::Value := { ( cWorkArea )->( RecNo() ), ::nColPos }
      ::DbGoTo( BackRec )
      ::BrowseOnChange()
   EndIf

Return Self

*-----------------------------------------------------------------------------*
METHOD CurrentCol( nCol ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local r, nClientWidth, nScrollWidth, lColChanged

   If HB_IsNumeric( nCol ) .AND. nCol >= 0 .AND. nCol <= Len( ::aHeaders )
      If  nCol < 1 .OR. nCol > Len( ::aHeaders )
         ::nRowPos := 0
         ::nColPos := 0
         ::CurrentRow := 0
      Else
         lColChanged := ( ::nColPos # nCol )
         ::nColPos := nCol

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

         // Ensure cell is visible
            ListView_RedrawItems( ::hWnd, ::nRowPos, ::ItemCount )
         EndIf
      EndIf
   Else
      ::nRowPos := ::CurrentRow  
      If ::nRowPos == 0
         ::nColPos := 0
      EndIf
   EndIf

Return ::nColPos

*--------------------------------------------------------------------------*
METHOD Left() CLASS TOBrowseByCell
*--------------------------------------------------------------------------*
Local aValue, nRec, nCol, lDone := .F.

   aValue := ::Value
   nRec := aValue[ 1 ]
   nCol := aValue[ 2 ]
   If nRec > 0 .AND. nCol >= 1 .AND. nCol <= Len( ::aHeaders )
      If nCol # ::FirstColInOrder
         ::Value := { nRec, ::PriorColInOrder( nCol ) }
         lDone := .T.
      ElseIf ::FullMove
         lDone := ::Up( .T. )
      EndIf
   EndIf
Return lDone

*--------------------------------------------------------------------------*
METHOD Right( lAppend ) CLASS TOBrowseByCell
*--------------------------------------------------------------------------*
Local aValue, nRec, nCol, lDone := .F.

   aValue := ::Value
   nRec := aValue[ 1 ]
   nCol := aValue[ 2 ]
   If nRec > 0 .AND. nCol >= 1 .AND. nCol <= Len( ::aHeaders )
      If nCol # ::LastColInOrder
         ::Value := { nRec, ::NextColInOrder( nCol ) }
         lDone := .T.
      ElseIf ::FullMove
         If ::Down( .F., .T. )
            lDone := .T.
         Else
            ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
            If lAppend
               lDone := ::AppendItem()
            EndIf
         EndIf
      EndIf
   EndIf
Return lDone
