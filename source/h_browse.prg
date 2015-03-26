/*
 * $Id: h_browse.prg,v 1.149 2015-03-26 23:59:39 fyurisich Exp $
 */
/*
 * ooHG source code:
 * PRG browse functions
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
   DATA Type            INIT "BROWSE" READONLY
   DATA aRecMap         INIT {}
   DATA RecCount        INIT 0
   DATA lUpdateAll      INIT .F.
   DATA nRecLastValue   INIT 0 PROTECTED
   DATA SyncStatus      INIT nil
   /*
    * When .T. the browse behaves as if SET BROWSESYNC is ON.
    * When .F. the browse behaves as if SET BROWSESYNC if OFF.
    * When NIL the browse behaves according to SET BROWESYNC value.
    */

   METHOD BrowseOnChange
   METHOD DbGoTo
   METHOD DbSkip
   METHOD Define
   METHOD Define3
   METHOD Delete
   METHOD DoChange
   METHOD Down
   METHOD EditAllCells
   METHOD EditCell
   METHOD EditItem_B
   METHOD End
   METHOD Events
   METHOD Events_Enter
   METHOD Events_Notify
   METHOD FastUpdate
   METHOD Home
   METHOD PageDown
   METHOD PageUp
   METHOD Refresh
   METHOD RefreshData
   METHOD ScrollUpdate
   METHOD SetScrollPos
   METHOD SetValue
   METHOD TopBottom
   METHOD Up
   METHOD UpDate
   METHOD UpdateColors
   METHOD Value         SETGET

   MESSAGE EditGrid     METHOD EditAllCells
   MESSAGE GoBottom     METHOD End
   MESSAGE GoTop        METHOD Home
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
               lFixedCtrls, bHeadRClick, lExtDbl, lNoModal ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local nWidth2, nCol2, oScroll, z

   ASSIGN ::aFields     VALUE aFields      TYPE "A"
   ASSIGN ::aHeaders    VALUE aHeaders     TYPE "A" DEFAULT {}
   ASSIGN ::aWidths     VALUE aWidths      TYPE "A" DEFAULT {}
   ASSIGN ::aJust       VALUE aJust        TYPE "A" DEFAULT {}
   ASSIGN ::lDescending VALUE lDescending  TYPE "L"
   ASSIGN ::SyncStatus  VALUE sync         TYPE "L" DEFAULT nil
   ASSIGN ::lUpdateAll  VALUE lUpdateAll   TYPE "L"
   ASSIGN ::lUpdCols    VALUE lUpdCols     TYPE "L"
   ASSIGN lFixedBlocks  VALUE lFixedBlocks TYPE "L" DEFAULT _OOHG_BrowseFixedBlocks
   ASSIGN lFixedCtrls   VALUE lFixedCtrls  TYPE "L" DEFAULT _OOHG_BrowseFixedControls

   IF ValType( uRefresh ) == "N"
      IF uRefresh == REFRESH_FORCE .OR. uRefresh == REFRESH_NO .OR. uRefresh == REFRESH_DEFAULT
         ::RefreshType := uRefresh
      ELSE
         ::RefreshType := REFRESH_DEFAULT
      ENDIF
   ELSE
      ::RefreshType := REFRESH_DEFAULT
   ENDIF

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

   IF ! ValType( WorkArea ) $ "CM" .OR. Empty( WorkArea )
      WorkArea := ALIAS()
   ENDIF

   If ValType( ::aFields ) != "A"
      ::aFields := ( WorkArea )->( DBSTRUCT() )
      AEVAL( ::aFields, { |x,i| ::aFields[ i ] := WorkArea + "->" + x[ 1 ] } )
   EndIf

   aSize( ::aHeaders, len( ::aFields ) )
   aEval( ::aHeaders, { |x,i| ::aHeaders[ i ] := iif( ! ValType( x ) $ "CM", iif( valtype( ::aFields[ i ] ) $ "CM", ::aFields[ i ], "" ), x ) } )

   aSize( ::aWidths, len( ::aFields ) )
   aEval( ::aWidths, { |x,i| ::aWidths[ i ] := iif( ! ValType( x ) == "N", 100, x ) } )

   // If splitboxed force no vertical scrollbar

   ASSIGN novscroll VALUE novscroll TYPE "L" DEFAULT .F.
   if valtype(x) != "N" .or. valtype(y) != "N"
      novscroll := .T.
   endif

   ASSIGN w VALUE w TYPE "N" DEFAULT ::nWidth
   nWidth2 := iif( novscroll, w, w - GETVSCROLLBARWIDTH() )

   ::Define3( ControlName, ParentForm, x, y, nWidth2, h, fontname, fontsize, ;
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
              lNoModal, lFixedCtrls, bHeadRClick, lExtDbl, Value )

   ::nWidth := w

   ASSIGN ::Lock          VALUE lock          TYPE "L"
   ASSIGN ::aReplaceField VALUE replacefields TYPE "A"
   ASSIGN ::lRecCount     VALUE lRecCount     TYPE "L"

   ::WorkArea := WorkArea

   ::FixBlocks( lFixedBlocks )

   ::aRecMap := {}

   ::ScrollButton := TScrollButton():Define( , Self, nCol2, ::nHeight - GETHSCROLLBARHEIGHT(), GETVSCROLLBARWIDTH(), GETHSCROLLBARHEIGHT() )

   oScroll := TScrollBar()
   oScroll:nWidth := GETVSCROLLBARWIDTH()
   oScroll:SetRange( 1, 1000 )

   If ::lRtl .AND. ! ::Parent:lRtl
      ::nCol := ::nCol + GETVSCROLLBARWIDTH()
      nCol2 := -GETVSCROLLBARWIDTH()
   Else
      nCol2 := nWidth2
   EndIf
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

   ::SizePos()

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
                lNoModal, lFixedCtrls, bHeadRClick, lExtDbl, Value ) CLASS TOBrowse
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
                   Nil, Nil, dblbffr, lFocusRect, lPLM, lFixedCols, abortedit, ;
                   click, lFixedWidths, bBeforeColMove, bAfterColMove, ;
                   bBeforeColSize, bAfterColSize, bBeforeAutofit, lLikeExcel, ;
                   lButtons, AllowDelete, Nil, Nil, DelMsg, lNoDelMsg, ;
                   AllowAppend, Nil, lNoModal, lFixedCtrls, bHeadRClick, Nil, ;
                   Nil, lExtDbl )

   If ValType( Value ) == "N"
      ::nRecLastValue := Value
   EndIf

Return Nil

*-----------------------------------------------------------------------------*
METHOD UpDate( nRow ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local PageLength, aTemp, _BrowseRecMap, x, nRecNo, nCurrentLength
Local lColor, aFields, cWorkArea, hWnd, nWidth

   cWorkArea := ::WorkArea

   If Select( cWorkArea ) == 0
      ::RecCount := 0
      Return nil
   EndIf

   PageLength := ::CountPerPage

   If PageLength < 1
     Return nil
   Endif

   nWidth := LEN( ::aFields )

   If ::FixBlocks()
     aFields := ACLONE( ::aColumnBlocks )
   Else
     aFields := ARRAY( nWidth )
     AEVAL( ::aFields, { |c,i| aFields[ i ] := ::ColumnBlock( i ), c } )
   EndIf

   hWnd := ::hWnd

   lColor := ! ( Empty( ::DynamicForeColor ) .AND. Empty( ::DynamicBackColor ) )

   aTemp := ARRAY( nWidth )

   If ::Visible
      ::SetRedraw( .F. )
   EndIf

   nCurrentLength  := ::ItemCount()
   ::GridForeColor := nil
   ::GridBackColor := nil

   If ::Eof()
      _BrowseRecMap := {}
   Else
      If ! HB_IsNumeric( nRow ) .OR. nRow < 1 .OR. nRow > PageLength
         nRow := 1
      EndIf

      _BrowseRecMap := ARRAY( nRow )
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
         AADD( _BrowseRecMap, ( cWorkArea )->( RecNo() ) )
         ::DbSkip()
      EndDo
      For x := 1 To Len( _BrowseRecMap )
         ::DbGoTo( _BrowseRecMap[ x ] )

         AEVAL( aFields, { |b,i| aTemp[ i ] := EVAL( b ) } )

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
      // Repositions the file as if _BrowseRecMap was builded using successive ::DbSkip() calls
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

   // update headers text and images, columns widths and justifications
   If ::lUpdateAll
      If Len( ::aWidths ) != nWidth
         ASIZE( ::aWidths, nWidth )
      EndIf
      AEVAL( ::aWidths, { |x,i| ::ColumnWidth( i, iif( ! HB_IsNumeric( x ) .OR. x < 0, 0, x ) ) } )

      If Len( ::aJust ) != nWidth
         ASIZE( ::aJust, nWidth )
         AEVAL( ::aJust, { |x,i| ::aJust[ i ] := iif( ! HB_IsNumeric( x ), 0, x ) } )
      EndIf
      AEVAL( ::aJust, { |x,i| ::Justify( i, x ) } )

      If Len( ::aHeaders ) != nWidth
         ASIZE( ::aHeaders, nWidth )
         AEVAL( ::aHeaders, { |x,i| ::aHeaders[ i ] := iif( ! ValType( x ) $ "CM", "", x ) } )
      EndIf
      AEVAL( ::aHeaders, { |x,i| ::Header( i, x ) } )

      ::LoadHeaderImages( ::aHeaderImage )
   EndIf

Return nil

*-----------------------------------------------------------------------------*
METHOD UpDateColors() CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local aTemp, x, aFields, cWorkArea, nWidth, nLen, _RecNo

   ::GridForeColor := nil
   ::GridBackColor := nil

   nLen := Len( ::aRecMap )
   If nLen == 0
      Return Nil
   EndIf

   If Empty( ::DynamicForeColor ) .AND. Empty( ::DynamicBackColor )
      Return Nil
   EndIf

   cWorkArea := ::WorkArea
   If Select( cWorkArea ) == 0
      Return Nil
   EndIf

   nWidth := LEN( ::aFields )
   aTemp := ARRAY( nWidth )

   If ::FixBlocks()
     aFields := ACLONE( ::aColumnBlocks )
   Else
     aFields := ARRAY( nWidth )
     AEVAL( ::aFields, { |c,i| aFields[ i ] := ::ColumnBlock( i ), c } )
   EndIf

   _RecNo := ( ::WorkArea )->( RecNo() )

   If ::Visible
      ::SetRedraw( .F. )
   EndIf

   For x := 1 to nLen
      ::DbGoTo( ::aRecMap[ x ] )
      AEVAL( aFields, { |b,i| aTemp[ i ] := EVAL( b ) } )
      ( cWorkArea )->( ::SetItemColor( x,,, aTemp ) )
   Next x

   If ::Visible
      ::SetRedraw( .T. )
   EndIf

   ::DbGoTo( _RecNo )

Return Nil

*-----------------------------------------------------------------------------*
METHOD PageDown() CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local _RecNo, s

   s := LISTVIEW_GETFIRSTITEM( ::hWnd )

   If  s >= Len( ::aRecMap )
      If Select( ::WorkArea ) == 0
         ::RecCount := 0
         Return Nil
      EndIf

      _RecNo := ( ::WorkArea )->( RecNo() )

      If Len( ::aRecMap ) == 0
         ::TopBottom( GO_BOTTOM )
         ::DbSkip( - ::CountPerPage + 1 )
      Else
         ::DbGoTo( ::aRecMap[ Len( ::aRecMap ) ] )
         // Check for more records
         ::DbSkip()
         If ::Eof()
            ::DbGoTo( _RecNo )
            If ::AllowAppend
               ::EditItem( .T., ! ( ::Inplace .AND. ::FullMove ) )
            Endif
            Return Nil
         EndIf
         ::DbSkip( -1 )
      EndIf
      ::Update()
      If Len( ::aRecMap ) == 0
         ::DbGoTo( 0 )
      Else
         ::DbGoTo( ::aRecMap[ Len( ::aRecMap ) ] )
      EndIf
      ::ScrollUpdate()
      ListView_SetCursel ( ::hWnd, Len( ::aRecMap ) )
      ::DbGoTo( _RecNo )
   Else
      ::FastUpdate( ::CountPerPage - s, Len( ::aRecMap ) )
   EndIf

   ::BrowseOnChange()

Return Nil

*-----------------------------------------------------------------------------*
METHOD PageUp() CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local _RecNo

   If LISTVIEW_GETFIRSTITEM( ::hWnd ) == 1
      If Select( ::WorkArea ) == 0
         ::RecCount := 0
         Return Nil
      EndIf
      _RecNo := ( ::WorkArea )->( RecNo() )
      If Len( ::aRecMap ) == 0
         ::TopBottom( GO_TOP )
      Else
         ::DbGoTo( ::aRecMap[ 1 ] )
      EndIf
      ::DbSkip( - ::CountPerPage + 1 )
      ::ScrollUpdate()
      ::Update()
      ::DbGoTo( _RecNo )
      ListView_SetCursel ( ::hWnd, 1 )
   Else
      ::FastUpdate( 1 - LISTVIEW_GETFIRSTITEM ( ::hWnd ), 1 )
   EndIf

   ::BrowseOnChange()

Return Nil

*-----------------------------------------------------------------------------*
METHOD Home() CLASS TOBrowse                         // METHOD GoTop
*-----------------------------------------------------------------------------*
Local _RecNo

   If Select( ::WorkArea ) == 0
      ::RecCount := 0
      Return Nil
   EndIf
   _RecNo := ( ::WorkArea )->( RecNo() )
   ::TopBottom( GO_TOP )
   ::ScrollUpdate()
   ::Update()
   ::DbGoTo( _RecNo )
   ListView_SetCursel( ::hWnd, 1 )

   ::BrowseOnChange()

Return Nil

*-----------------------------------------------------------------------------*
METHOD End( lAppend ) CLASS TOBrowse                 // METHOD GoBottom
*-----------------------------------------------------------------------------*
Local _RecNo, _BottomRec
   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.

   If Select( ::WorkArea ) == 0
      ::RecCount := 0
      Return Nil
   EndIf
   _RecNo := ( ::WorkArea )->( RecNo() )
   ::TopBottom( GO_BOTTOM )
   _BottomRec := ( ::WorkArea )->( RecNo() )
   ::ScrollUpdate()

   // If it's for APPEND, leaves a blank line ;)
   ::DbSkip( - ::CountPerPage + IF( lAppend, 2, 1 ) )
   ::Update()
   ::DbGoTo( _RecNo )
   ListView_SetCursel( ::hWnd, ASCAN ( ::aRecMap, _BottomRec ) )

   ::BrowseOnChange()

Return Nil

*-----------------------------------------------------------------------------*
METHOD Up() CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local s, _RecNo, nLen, lDone := .F.

   s := LISTVIEW_GETFIRSTITEM ( ::hWnd )

   If s <= 1
      If Select( ::WorkArea ) == 0
         ::RecCount := 0
         Return lDone
      EndIf

      _RecNo := ( ::WorkArea )->( RecNo() )

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
         AADD( ::aRecMap, nil )
         AINS( ::aRecMap, 1 )
         ::aRecMap[ 1 ] := ( ::WorkArea )->( RecNo() )
         If ::Visible
            ::SetRedraw( .F. )
         EndIf
         ::InsertBlank( 1 )
         ::RefreshRow( 1 )
         nLen := Len( ::aRecMap )
         // Resize record map
         If nLen > ::CountPerPage
            ::DeleteItem( nLen )
            ASIZE( ::aRecMap, nLen - 1 )
         EndIf
         If ::Visible
            ::SetRedraw( .T. )
         EndIf
      EndIf

      ::ScrollUpdate()
      ::DbGoTo( _RecNo )
      If Len( ::aRecMap ) != 0
         ListView_SetCursel( ::hWnd, 1 )
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
Local s, _RecNo, nLen, lDone := .F.

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .T.

   s := LISTVIEW_GETFIRSTITEM( ::hWnd )

   If s >= Len( ::aRecMap )
      If Select( ::WorkArea ) == 0
         ::RecCount := 0
         Return lDone
      EndIf

      _RecNo := ( ::WorkArea )->( RecNo() )

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
            If ::AllowAppend .AND. lAppend
               lDone := ::EditItem( .T., ! ( ::Inplace .AND. ::FullMove ) )
            Endif
            Return lDone
         EndIf
         // Add one record at the bottom
         AADD( ::aRecMap, ( ::WorkArea )->( RecNo() ) )
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

      If Len( ::aRecMap ) != 0
         ::DbGoTo( ATail( ::aRecMap ) )
         lDone := .T.
      EndIf
      ::ScrollUpdate()
      ::DbGoTo( _RecNo )
      ListView_SetCursel( ::hWnd, Len( ::aRecMap ) )
   Else
      ::FastUpdate( 1, s + 1 )
      lDone := .T.
   EndIf

   ::BrowseOnChange()

Return lDone

*-----------------------------------------------------------------------------*
METHOD TopBottom( nDir ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
   If ::lDescending
      nDir := - nDir
   EndIf
   If nDir == GO_BOTTOM
      ( ::WorkArea )->( DbGoBottom() )
   Else
      ( ::WorkArea )->( DbGoTop() )
   EndIf
   ::Bof := .F.
   ::Eof := ( ::WorkArea )->( Eof() )

Return Nil

*-----------------------------------------------------------------------------*
METHOD DbSkip( nRows ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
   ASSIGN nRows VALUE nRows TYPE "N" DEFAULT 1

   If ! ::lDescending
      ( ::WorkArea )->( DbSkip(   nRows ) )
      ::Bof := ( ::WorkArea )->( Bof() )
      ::Eof := ( ::WorkArea )->( Eof() ) .OR. ( ( ::WorkArea )->( Recno() ) > ( ::WorkArea )->( RecCount() ) )
   Else
      ( ::WorkArea )->( DbSkip( - nRows ) )
      If ( ::WorkArea )->( Eof() )
         ( ::WorkArea )->( DbGoBottom() )
         ::Bof := .T.
         ::Eof := ( ::WorkArea )->( Eof() )
      ElseIf ( ::WorkArea )->( Bof() )
         ::Eof := .T.
         ::DbGoTo( 0 )
      EndIf
   EndIf

Return Nil

*-----------------------------------------------------------------------------*
METHOD DbGoTo( nRecNo ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
   ( ::WorkArea )->( DbGoTo( nRecNo ) )
   ::Bof := .F.
   ::Eof := ( ::WorkArea )->( Eof() )

Return Nil

*-----------------------------------------------------------------------------*
METHOD SetValue( Value, mp ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local _RecNo, m, hWnd, cWorkArea

   cWorkArea := ::WorkArea

   If Select( cWorkArea ) == 0
      ::RecCount := 0
      Return Nil
   EndIf

   If Value <= 0
      Return Nil
   EndIf

   hWnd := ::hWnd

   If _OOHG_ThisEventType == 'BROWSE_ONCHANGE'
      If hWnd == _OOHG_ThisControl:hWnd
         MsgOOHGError( "BROWSE: Value property can't be changed inside ONCHANGE event. Program Terminated." )
      EndIf
   EndIf

   If Value > ( cWorkArea )->( RecCount() )
      ::DeleteAllItems()
      ::BrowseOnChange()
      Return Nil
   EndIf

   If valtype ( mp ) != "N"
      m := int( ::CountPerPage / 2 )
   else
      m := mp
   endif

   _RecNo := ( cWorkArea )->( RecNo() )

   ::DbGoTo( Value )
   If ::Eof()
      ::DbGoTo( _RecNo )
      Return Nil
   EndIf

   // Avoid using DBFILTER()
   ::DbSkip()
   ::DbSkip( -1 )
   IF ( cWorkArea )->( RecNo() ) != Value
      ::DbGoTo( _RecNo )
      Return Nil
   ENDIF

   if pcount() < 2
      ::ScrollUpdate()
   EndIf
   ::DbSkip( -m + 1 )

   ::Update()
   ::DbGoTo( _RecNo )
   ListView_SetCursel ( hWnd, ASCAN( ::aRecMap, Value ) )

   _OOHG_ThisEventType := 'BROWSE_ONCHANGE'
   ::BrowseOnChange()
   _OOHG_ThisEventType := ''

Return Nil

*-----------------------------------------------------------------------------*
METHOD Delete() CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local Value, nRecNo, lSync

   Value := ::Value

   If Value == 0
      Return Nil
   EndIf

   nRecNo := ( ::WorkArea )->( RecNo() )

   ::DbGoTo( Value )

   If ::Lock .AND. ! ( ::WorkArea )->( Rlock() )
      MsgExclamation( _OOHG_Messages( 3, 9 ), _OOHG_Messages( 4, 2 ) )
   Else
      ( ::WorkArea )->( DbDelete() )

      // Do before unlocking record or moving record pointer
      // so block can operate on deleted record (e.g. to copy to a log).
      If HB_IsBlock( ::OnDelete )
         ::DoEvent( ::OnDelete, 'DELETE' )
      EndIf

      If ::Lock
         ( ::WorkArea )->( DbCommit() )
         ( ::WorkArea )->( DbUnlock() )
      EndIf
      ::DbSkip()
      If ::Eof()
         ::TopBottom( GO_BOTTOM )
      EndIf

      If Set( _SET_DELETED )
         ::SetValue( ( ::WorkArea )->( RecNo() ), LISTVIEW_GETFIRSTITEM( ::hWnd ) )
      EndIf
   EndIf

   If HB_IsLogical( ::SyncStatus )
      lSync := ::SyncStatus
   Else
      lSync := _OOHG_BrowseSyncStatus
   EndIf

   If lSync
      If ( ::WorkArea )->( RecNo() ) != ::Value
         ::DbGoTo( ::Value )
      EndIf
   Else
      ::DbGoTo( nRecNo )
   EndIf

Return Nil

*-----------------------------------------------------------------------------*
METHOD EditItem_B( lAppend, lOneRow ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local nOldRecNo, nItem, cWorkArea, lRet, nNewRec

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   ASSIGN lOneRow VALUE lOneRow TYPE "L" DEFAULT .T.

   If lAppend .AND. ! ::AllowAppend
      Return .F.
   EndIf

   cWorkArea := ::WorkArea
   If Select( cWorkArea ) == 0
      ::RecCount := 0
      Return .F.
   EndIf

   nItem := LISTVIEW_GETFIRSTITEM( ::hWnd )

   If nItem == 0 .AND. ! lAppend
      Return .F.
   EndIf

   IF ! lAppend
      ::DbGoTo( ::aRecMap[ nItem ] )
   EndIf

   If ::InPlace
      If lAppend
         ::GoBottom( .T. )
         ::InsertBlank( ::ItemCount + 1 )
         ::CurrentRow := ::ItemCount
         ::lAppendMode := .T.
      EndIf

      lRet := ::EditAllCells( , , lAppend, lOneRow, ::RefreshType == REFRESH_DEFAULT .OR. ::RefreshType == REFRESH_FORCE )
   Else
      nOldRecNo := ( cWorkArea )->( RecNo() )

      lRet := ::Super:EditItem_B( lAppend, .T. )

      If lRet .AND. lAppend
         nNewRec := ( cWorkArea )->( RecNo() )
         ::DbGoTo( nOldRecNo )
         ::Value := nNewRec
      Else
         ::DbGoTo( nOldRecNo )
      EndIf
   EndIf

Return lRet

*-----------------------------------------------------------------------------*
METHOD EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, lAppend, nOnFocusPos, lRefresh, lChange ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local lRet, BackRec

   ASSIGN lAppend  VALUE lAppend  TYPE "L" DEFAULT .F.
   ASSIGN nRow     VALUE nRow     TYPE "N" DEFAULT ::CurrentRow
   ASSIGN lRefresh VALUE lRefresh TYPE "L" DEFAULT ( ::RefreshType == REFRESH_FORCE )
   ASSIGN lChange  VALUE lChange  TYPE "L" DEFAULT .F.

   If nRow < 1 .OR. nRow > ::ItemCount()
      // Cell out of range
      lRet := .F.
   ElseIf Select( ::WorkArea ) == 0
      // It the specified area does not exists, set recordcount to 0 and Return
      ::RecCount := 0
      lRet := .F.
   Else
      BackRec := ( ::WorkArea )->( RecNo() )

      IF lAppend
         ::DbGoTo( 0 )
      Else
         ::DbGoTo( ::aRecMap[ nRow ] )
      EndIf

      lRet := ::Super:EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, lAppend, nOnFocusPos )

      If lRet .AND. lAppend
         aAdd( ::aRecMap, ( ::WorkArea )->( RecNo() ) )
      EndIf

      ::DbGoTo( BackRec )

      If lRet
         If lChange
            ::Value := aTail( ::aRecMap )
         ElseIf lRefresh
           ::Refresh()
         EndIf
      EndIf
   Endif

Return lRet

*-----------------------------------------------------------------------------*
METHOD EditAllCells( nRow, nCol, lAppend, lOneRow, lRefresh ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local lRet, lRowEdited, lSomethingEdited, nRecNo, lRowAppended, nNewRec, nNextRec

   ASSIGN lAppend  VALUE lAppend  TYPE "L" DEFAULT .F.
   ASSIGN nRow     VALUE nRow     TYPE "N" DEFAULT ::CurrentRow
   ASSIGN nCol     VALUE nCol     TYPE "N" DEFAULT 1
   ASSIGN lOneRow  VALUE lOneRow  TYPE "L" DEFAULT .F.
   ASSIGN lRefresh VALUE lRefresh TYPE "L" DEFAULT ( ::RefreshType == REFRESH_FORCE )

   If nRow < 1 .OR. nRow > ::ItemCount() .OR. nCol < 1 .OR. nCol > Len( ::aHeaders )
      // Cell out of range
      Return .F.
   ElseIf lAppend .AND. ! ::AllowAppend
      Return .F.
   EndIf

   // TODO: agregar un evento para validar el registro, y no permitir la edición si retorna .f.

   lSomethingEdited := .F.

   Do While .t.
      lRet := .T.
      lRowEdited := .F.
      lRowAppended := .F.

      Do While nCol <= Len( ::aHeaders ) .AND. lRet .AND. Select( ::WorkArea ) # 0
         nRecNo := ( ::WorkArea )->( RecNo() )
         IF lAppend
            ::DbGoTo( 0 )
         Else
            ::DbGoTo( ::aRecMap[ nRow ] )
            If nRow == ::ItemCount
               ::DbSkip()
               IF ::Eof()
                  nNextRec := 0
               Else
                  nNextRec := ( ::WorkArea )->( RecNo() )
               EndIf
               ::DbGoTo( ::aRecMap[ nRow ] )
            EndIf
         EndIf

         If ::IsColumnReadOnly( nCol )
           // Read only column, skip
         ElseIf ! ::IsColumnWhen( nCol )
           // Not a valid WHEN, skip column and continue editing
         ElseIf ASCAN( ::aHiddenCols, nCol ) > 0
           // Is a hidden column, skip
         Else
            ::DbGoTo( nRecNo )

            lRet := ::EditCell( nRow, nCol, , , , , lAppend, , .F., .F. )

            If lRet
               lRowEdited := .T.
               lSomethingEdited := .T.
               If lAppend
                  lRowAppended := .T.
                  lAppend := .F.
               EndIf
            EndIf
         EndIf

         nCol++
      EndDo

      If lRowEdited
         // If a column was edited, scroll to the left
         ListView_Scroll( ::hWnd, - _OOHG_GridArrayWidths( ::hWnd, ::aWidths ), 0 )
      EndIf

      // See what to do next
      If ! lRet
         // Stop if the last column was not edited
         If lRowAppended
            // A new row was added and partially edited: set as new value and refresh the control
            ::SetValue( aTail( ::aRecMap ), nRow )
            ::Refresh()
         ElseIf lAppend
            // The user aborted the append of a new row in the first column: refresh and set last record as new value
            ::GoBottom()
         ElseIf lSomethingEdited
            // The user aborted the edition of an existing row: refresh the control without changing it's value
            ::Refresh()
         EndIf
         // TODO: agregar evento AFTEREDIT, parámetros: ultimo registro agregado o editado
         Exit
      ElseIf lOneRow .OR. ! ::FullMove .OR. ( lRowAppended .AND. ! ::AllowAppend )
         // Stop if it's not fullmove editing or
         // if caller wants to edit only one row or
         // if, after appending a new row, appends are not allowed anymore
         If lRowAppended
            // A new row was added and fully edited: set as new value and refresh the control
            ::SetValue( aTail( ::aRecMap ), nRow )
            ::Refresh()
         ElseIf lRowEdited
            // An existing row was fully edited: refresh the control without changing it's value
            ::Refresh()
         EndIf
         // TODO: agregar evento AFTEREDIT, parámetros: ultimo registro agregado o editado
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
      ElseIf nRow < ::ItemCount()
         // Edit next row
         If lRowEdited .AND. lRefresh
            nRecNo := ( ::WorkArea )->( RecNo() )
            nNewRec := ::aRecMap[ nRow + 1 ]
            ::DbGoTo( nNewRec )
            ::Update( nRow + 1 )
            ::ScrollUpdate()
            ::DbGoTo( nRecNo )
            nRow := aScan( ::aRecMap, nNewRec )
            ListView_SetCursel ( ::hWnd, nRow )
         Else
            nRow ++
            ::FastUpdate( 1, nRow )
         EndIf
         ::BrowseOnChange()
      ElseIf nRow < ::CountPerPage
         // Next visible row is blank, append new record
         If lRefresh
            ::GoBottom( .T. )
         EndIf
         ::InsertBlank( ::ItemCount + 1 )
         nRow := ::CurrentRow := ::ItemCount
         lAppend := .T.
         ::lAppendMode := .T.
      Else
         // The last visible row was fully edited
         If nNextRec # 0
            // Find next record
            nRecNo := ( ::WorkArea )->( RecNo() )
            ::DbGoTo( nNextRec )
            ::DbSkip()
            ::DbSkip(-1)
            If ( ::WorkArea )->( RecNo() ) # nNextRec
               ::DbGoTo( nNextRec )
               ::DbSkip()
               If ::Eof()
                  nNextRec := 0
               Else
                  nNextRec := ( ::WorkArea )->( RecNo() )
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
            nRecNo := ( ::WorkArea )->( RecNo() )
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
      nCol := 1
   EndDo

Return lSomethingEdited

*-----------------------------------------------------------------------------*
METHOD BrowseOnChange() CLASS TOBrowse
*-----------------------------------------------------------------------------*
LOCAL cWorkArea, lSync

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

Return Nil

*-----------------------------------------------------------------------------*
METHOD DoChange() CLASS TOBrowse
*-----------------------------------------------------------------------------*
   ::nRecLastValue := ::Value
   ::TGrid:DoChange()
Return Nil

*-----------------------------------------------------------------------------*
METHOD FastUpdate( d, nRow ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local ActualRecord, RecordCount

   // If vertical scrollbar is used it must be updated
   If ::lVScrollVisible
      RecordCount := ::RecCount

      If RecordCount == 0
         Return Nil
      EndIf

      If RecordCount < 1000
         ActualRecord := ::VScroll:Value + d
         ::VScroll:Value := ActualRecord
      EndIf
   EndIf

   If Len( ::aRecMap ) < nRow .OR. nRow == 0
      ::nRecLastValue := 0
   Else
      ::nRecLastValue := ::aRecMap[ nRow ]
   EndIf

   ListView_SetCursel( ::hWnd, nRow )

Return Nil

*-----------------------------------------------------------------------------*
METHOD ScrollUpdate() CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local ActualRecord, RecordCount
Local cWorkArea

   // If vertical scrollbar is used it must be updated
   If ::lVScrollVisible

      cWorkArea := ::WorkArea
      IF Select( cWorkArea ) == 0
         ::RecCount := 0
         Return Nil
      ENDIF
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

Return Nil

*-----------------------------------------------------------------------------*
METHOD Refresh() CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local s, _RecNo, v
Local cWorkArea, hWnd

   cWorkArea := ::WorkArea
   hWnd := ::hWnd

   If Select( cWorkArea ) == 0
      ::DeleteAllItems()
      Return Nil
   EndIf

   v := ::Value         // This is a record number

   s := LISTVIEW_GETFIRSTITEM( hWnd )          // This is a row

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
      If ( cWorkArea )->( INDEXORD() ) != 0
         If ( cWorkArea )->( ORDKEYVAL() ) == Nil
            ::TopBottom( GO_TOP )
         EndIf
      EndIf

      If Set( _SET_DELETED )
         If ( cWorkArea )->( Deleted() )
            ::TopBottom( GO_TOP )
         EndIf
      EndIf
   Endif

   If ::Eof()
      ::DeleteAllItems()
      ::DbGoTo( _RecNo )
      Return Nil
   EndIf

   ::ScrollUpdate()

   If s != 0
      ::DbSkip( - s + 1 )
   EndIf

   ::Update()

   ListView_SetCursel( hWnd, ASCAN( ::aRecMap, v ) )
   ::nRecLastValue := v

   ::DbGoTo( _RecNo )

Return Nil

*-----------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local nItem

   IF VALTYPE( uValue ) == "N"
      ::SetValue( uValue )
   ENDIF
   If SELECT( ::WorkArea ) == 0
      ::RecCount := 0
      uValue := 0
   Else
      nItem := LISTVIEW_GETFIRSTITEM( ::hWnd )
      If nItem > 0 .AND. nItem <= Len( ::aRecMap )
         uValue := ::aRecMap[ nItem ]
      Else
         uValue := 0
      Endif
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
Local cWorkArea, _RecNo, Value, uGridValue

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

      Value := ::Value
      If Value == 0
         If Len( ::aRecMap ) == 0
            ::TopBottom( GO_TOP )
         Else
            ::DbGoTo( ::aRecMap[ 1 ] )
         EndIf

         If ::Eof()
            ::DbGoTo( _RecNo )
            Return 0
         EndIf

         Value := ( cWorkArea )->( RecNo() )
      EndIf
      ::DbGoTo( Value )
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
         Do While ! ::Eof() .AND. ( cWorkArea )->( RecNo() ) != Value
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
         ::Value := ( cWorkArea )->( RecNo() )
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

   EndIf

Return ::Super:Events( hWnd, nMsg, wParam, lParam )

*-----------------------------------------------------------------------------*
METHOD Events_Enter() CLASS TOBrowse
*-----------------------------------------------------------------------------*
   If ! ::lNestedEdit
      ::lNestedEdit := .T.
      ::cText := ""
      If Select( ::WorkArea ) != 0
         If ! ::AllowEdit
            ::DoEvent( ::OnEnter, "ENTER" )
         ElseIf ::FullMove .OR. ::InPlace
            ::EditAllCells()
         ElseIf ! ::lNestedEdit
            ::EditItem()
         EndIf
      Endif
      ::lNestedEdit := .F.
   EndIf

Return Nil

*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam )
Local nvKey, r, DeltaSelect, lGo

   If nNotify == NM_CLICK
      If HB_IsBlock( ::OnClick )
         If ! ::NestedClick
            ::NestedClick := ! _OOHG_NestedSameEvent()
            ::DoEventMouseCoords( ::OnClick, "CLICK" )
            ::NestedClick := .F.
         EndIf
      EndIf

      r := LISTVIEW_GETFIRSTITEM( ::hWnd )
      If r > 0
         DeltaSelect := r - ASCAN ( ::aRecMap, ::nRecLastValue )
         ::FastUpdate( DeltaSelect, r )
         ::BrowseOnChange()
      EndIf

      Return Nil

   ElseIf nNotify == LVN_BEGINDRAG .or. nNotify == NM_RCLICK
      r := LISTVIEW_GETFIRSTITEM( ::hWnd )
      If r > 0
         DeltaSelect := r - ASCAN ( ::aRecMap, ::nRecLastValue )
         ::FastUpdate( DeltaSelect, r )
         ::BrowseOnChange()
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

      Case nvKey == VK_A
         if GetAltState() == -127 ;
            .or.;
            GetAltState() == -128   // ALT

            If ::AllowAppend
               ::EditItem( .T., ! ( ::Inplace .AND. ::FullMove ) )
            EndIf

         EndIf

      Case nvKey == VK_DELETE
         If ::AllowDelete .and. ! ::Eof()
            If HB_IsBlock( ::bDelWhen )
               lGo := EVAL( ::bDelWhen )
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

      Return Nil

   ElseIf nNotify == LVN_ITEMCHANGED
      Return Nil

   ElseIf nNotify == NM_CUSTOMDRAW
      ::AdjustRightScroll()

   EndIf

Return ::TGrid:Events_Notify( wParam, lParam )

*-----------------------------------------------------------------------------*
METHOD SetScrollPos( nPos, VScroll ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local BackRec
   If Select( ::WorkArea ) == 0
      // Not workarea selected
   ElseIf nPos <= VScroll:RangeMin
      ::GoTop()
   ElseIf nPos >= VScroll:RangeMax
      ::GoBottom()
   Else
      BackRec := ( ::WorkArea )->( RecNo() )
      ::Super:SetScrollPos( nPos, VScroll )
      ::Value := ( ::WorkArea )->( RecNo() )
      ::DbGoTo( BackRec )
      ::BrowseOnChange()
   EndIf

Return Nil

*-----------------------------------------------------------------------------*
FUNCTION SetBrowseSync( lValue )
*-----------------------------------------------------------------------------*
   IF valtype( lValue ) == "L"
      _OOHG_BrowseSyncStatus := lValue
   ENDIF

Return _OOHG_BrowseSyncStatus

*-----------------------------------------------------------------------------*
FUNCTION SetBrowseFixedBlocks( lValue )
*-----------------------------------------------------------------------------*
   IF valtype( lValue ) == "L"
      _OOHG_BrowseFixedBlocks := lValue
   ENDIF

Return _OOHG_BrowseFixedBlocks

*-----------------------------------------------------------------------------*
FUNCTION SetBrowseFixedControls( lValue )
*-----------------------------------------------------------------------------*
   IF valtype( lValue ) == "L"
      _OOHG_BrowseFixedControls := lValue
   ENDIF

Return _OOHG_BrowseFixedControls




CLASS TOBrowseByCell FROM TXBrowseByCell, TOBrowse
   DATA Type            INIT "BROWSEBYCELL" READONLY
   DATA aRecMap         INIT {}
   DATA RecCount        INIT 0
   DATA lUpdateAll      INIT .F.
   DATA SyncStatus      INIT nil
   /*
    * When .T. the browse behaves as if SET BROWSESYNC is ON.
    * When .F. the browse behaves as if SET BROWSESYNC if OFF.
    * When NIL the browse behaves according to SET BROWESYNC value.
    */

   METHOD BrowseOnChange
   METHOD CurrentCol    SETGET
   METHOD CurrentRow    SETGET
   METHOD DbGoTo
   METHOD DbSkip
   METHOD Define
   METHOD Define3
   METHOD Delete
   METHOD DoChange
   METHOD Down
   METHOD EditCell
   METHOD EditGrid
   METHOD EditItem_B
   METHOD End
   METHOD Events
   METHOD Events_Enter
   METHOD Events_Notify
   METHOD FastUpdate
   METHOD Home
   METHOD Left
   METHOD PageDown
   METHOD PageUp
   METHOD Refresh
   METHOD RefreshData
   METHOD Right
   METHOD ScrollUpdate
   METHOD SetScrollPos
   METHOD SetValue
   METHOD TopBottom
   METHOD Up
   METHOD UpDate
   METHOD UpdateColors
   METHOD Value         SETGET

   MESSAGE EditAllCells METHOD EditGrid
   MESSAGE GoBottom     METHOD End
   MESSAGE GoTop        METHOD Home
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
               lFixedCtrls, bHeadRClick, lExtDbl, lNoModal ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Return ::TOBrowse:Define( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
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
               lFixedCtrls, bHeadRClick, lExtDbl, lNoModal )

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
                lNoModal, lFixedCtrls, bHeadRClick, lExtDbl, Value ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local nAux

   Empty( InPlace )
   // Inplace is forced to .T. by ::Define2

   ::TGrid:Define( ControlName, ParentForm, x, y, w, h, ::aHeaders, ::aWidths, ;
                   {}, Nil, fontname, fontsize, tooltip, Nil, Nil, aHeadClick, ;
                   Nil, Nil, nogrid, aImage, ::aJust, break, HelpId, bold, ;
                   italic, underline, strikeout, Nil, Nil, Nil, edit, ;
                   backcolor, fontcolor, dynamicbackcolor, dynamicforecolor, ;
                   aPicture, lRtl, LVS_SINGLESEL, editcontrols, readonly, valid, ;
                   validmessages, editcell, aWhenFields, lDisabled, ;
                   lNoTabStop, lInvisible, lHasHeaders, Nil, aHeaderImage, ;
                   aHeaderImageAlign, FullMove, aSelectedColors, aEditKeys, ;
                   Nil, Nil, dblbffr, lFocusRect, lPLM, lFixedCols, abortedit, ;
                   click, lFixedWidths, bBeforeColMove, bAfterColMove, ;
                   bBeforeColSize, bAfterColSize, bBeforeAutofit, lLikeExcel, ;
                   lButtons, AllowDelete, Nil, Nil, DelMsg, lNoDelMsg, ;
                   AllowAppend, Nil, lNoModal, lFixedCtrls, bHeadRClick, Nil, ;
                   Nil, lExtDbl )

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

Return Nil

*-----------------------------------------------------------------------------*
METHOD Refresh() CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local s, _RecNo, v, cWorkArea, hWnd

   cWorkArea := ::WorkArea
   hWnd := ::hWnd

   If Select( cWorkArea ) == 0
      ::DeleteAllItems()
      Return Nil
   EndIf

   v := ::Value[ 1 ]         // This is a record number

   s := LISTVIEW_GETFIRSTITEM( hWnd )          // This is a row

   _RecNo := ( cWorkArea )->( RecNo() )

   if v <= 0
      v := _RecNo
   EndIf

   ::DbGoTo( v )

   if s <= 1
      ::DbSkip()
      ::DbSkip( -1 )
      IF ( cWorkArea )->( RecNo() ) != v
         ::DbSkip()
      ENDIF
   EndIf

   If s == 0
      If ( cWorkArea )->( INDEXORD() ) != 0
         If ( cWorkArea )->( ORDKEYVAL() ) == Nil
            ::TopBottom( GO_TOP )
         EndIf
      EndIf

      If Set( _SET_DELETED )
         If ( cWorkArea )->( Deleted() )
            ::TopBottom( GO_TOP )
         EndIf
      EndIf
   Endif

   If ::Eof()
      ::DeleteAllItems()
      ::DbGoTo( _RecNo )
      Return Nil
   EndIf

   ::ScrollUpdate()

   If s != 0
      ::DbSkip( - s + 1 )
   EndIf

   ::Update()

   ListView_SetCursel( hWnd, ASCAN( ::aRecMap, v ) )
   ::nRecLastValue := v

   ::DbGoTo( _RecNo )

Return Nil

*-----------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local nItem

   If HB_IsArray( uValue ) .AND. Len( uValue ) > 1
      If HB_IsNumeric( uValue[ 1 ] ) .AND. uValue[ 1 ] >= 0
         If HB_IsNumeric( uValue[ 2 ] ) .AND. uValue[ 2 ] >= 0 .AND. uValue[ 2 ] <= Len( ::aHeaders )
            If ( nItem := ASCAN( ::aRecMap, uValue[ 1 ] ) ) > 0
               ::SetValue( uValue, nItem )
            Else
               ::SetValue( uValue )
            EndIf
         EndIf
      EndIf
   EndIf

   If Select( ::WorkArea ) == 0
      ::RecCount := 0
      uValue := { 0, 0 }
   Else
      nItem := LISTVIEW_GETFIRSTITEM( ::hWnd )
      If nItem > 0 .AND. nItem <= Len( ::aRecMap )
         uValue := { ::aRecMap[ nItem ], ::CurrentCol }
      Else
         uValue := { 0, 0 }
      Endif
   EndIf

Return uValue

*-----------------------------------------------------------------------------*
METHOD RefreshData() CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Return ::TOBrowse:RefreshData()

*-----------------------------------------------------------------------------*
METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local cWorkArea, _RecNo, Value, uGridValue, nRow, aCellData

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
         ::SearchCol := ::CurrentCol
         If ::SearchCol < 1 .OR. ::SearchCol > ::ColumnCount
            Return 0
         EndIf
      EndIf

      cWorkArea := ::WorkArea
      If Select( cWorkArea ) == 0
         Return 0
      EndIf

      _RecNo := ( cWorkArea )->( RecNo() )

      Value := ::Value
      nRow := Value[ 1 ]
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
         Do While ! ::Eof() .AND. ( cWorkArea )->( RecNo() ) != Value
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
         ::Value := { ( cWorkArea )->( RecNo() ), ::CurrentCol }
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

   ElseIf nMsg == WM_LBUTTONDOWN .OR. nMsg == WM_RBUTTONDOWN
      If ListView_HitOnCheckBox( hWnd, GetCursorRow() - GetWindowRow( hWnd ), GetCursorCol() - GetWindowCol( hWnd ) ) <= 0
         aCellData := _GetGridCellData( Self )
         nRow := aCellData[ 1 ]
         If  nRow >= 1 .AND.  nRow <= Len( ::aRecMap )
            ::Value := { ::aRecMap[ nRow ], aCellData[ 2 ] }
         EndIf
      EndIf

   EndIf

Return ::Super:Events( hWnd, nMsg, wParam, lParam )

*-----------------------------------------------------------------------------*
METHOD Events_Enter() CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
   If ! ::lNestedEdit
      ::lNestedEdit := .T.
      ::cText := ""
      If Select( ::WorkArea ) != 0
         If ! ::AllowEdit
            ::DoEvent( ::OnEnter, "ENTER" )
         Else
           ::EditGrid()
         EndIf
      Endif
      ::lNestedEdit := .F.
   EndIf

Return Nil

*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam )
Local nvKey, r, DeltaSelect, lGo

   If nNotify == NM_CLICK
      If HB_IsBlock( ::OnClick )
         If ! ::NestedClick
            ::NestedClick := ! _OOHG_NestedSameEvent()
            ::DoEventMouseCoords( ::OnClick, "CLICK" )
            ::NestedClick := .F.
         EndIf
      EndIf

      r := LISTVIEW_GETFIRSTITEM( ::hWnd )
      If r > 0
         DeltaSelect := r - ASCAN ( ::aRecMap, ::nRecLastValue )
         ::FastUpdate( DeltaSelect, r )
         ::BrowseOnChange()
      EndIf

      Return Nil

   ElseIf nNotify == LVN_BEGINDRAG .or. nNotify == NM_RCLICK
      r := LISTVIEW_GETFIRSTITEM( ::hWnd )
      If r > 0
         DeltaSelect := r - ASCAN ( ::aRecMap, ::nRecLastValue )
         ::FastUpdate( DeltaSelect, r )
         ::BrowseOnChange()
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

      Case nvKey == VK_A
         if GetAltState() == -127 ;
            .or.;
            GetAltState() == -128   // ALT

            If ::AllowAppend
               ::EditItem( .T., ! ::FullMove )
            EndIf

         EndIf

      Case nvKey == VK_DELETE
         If ::AllowDelete .and. ! ::Eof()
            If HB_IsBlock( ::bDelWhen )
               lGo := EVAL( ::bDelWhen )
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

      Return Nil

   ElseIf nNotify == LVN_ITEMCHANGED
      Return Nil

   EndIf

Return ::Super:Events_Notify( wParam, lParam )

*-----------------------------------------------------------------------------*
METHOD EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, lAppend, nOnFocusPos, lRefresh, lChange ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local lRet, BackRec

   Empty( lRefresh )

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   ASSIGN nRow    VALUE nRow    TYPE "N" DEFAULT ::CurrentRow
   ASSIGN nCol    VALUE nCol    TYPE "N" DEFAULT ::CurrentCol
   ASSIGN lChange VALUE lChange TYPE "L" DEFAULT .F.

   If nRow < 1 .OR. nRow > ::ItemCount()
      // Cell out of range
      lRet := .F.
   ElseIf Select( ::WorkArea ) == 0
      // It the specified area does not exists, set recordcount to 0 and Return
      ::RecCount := 0
      lRet := .F.
   Else
      BackRec := ( ::WorkArea )->( RecNo() )

      IF lAppend
         ::DbGoTo( 0 )
      Else
         ::DbGoTo( ::aRecMap[ nRow ] )
      EndIf

      lRet := ::TXBrowse:EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, lAppend, nOnFocusPos )

      If lRet .AND. lAppend
         aAdd( ::aRecMap, ( ::WorkArea )->( RecNo() ) )
      EndIf

      ::DbGoTo( BackRec )

      If lRet
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
   Endif
Return lRet

*-----------------------------------------------------------------------------*
METHOD EditItem_B( lAppend, lOneRow ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local nItem, cWorkArea //, nCol

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   ASSIGN lOneRow VALUE lOneRow TYPE "L" DEFAULT .T.

   cWorkArea := ::WorkArea
   If Select( cWorkArea ) == 0
      ::RecCount := 0
      Return .F.
   EndIf

   nItem := LISTVIEW_GETFIRSTITEM( ::hWnd )

   If nItem == 0 .AND. ! lAppend
      Return .F.
   EndIf

   IF ! lAppend
      ::DbGoTo( ::aRecMap[ nItem ] )
   EndIf

   If lAppend
      ::CurrentCol := 1       // TODO: Agregar un flag para omitir esto
      // Insert new row
      ::GoBottom( .T. )
      ::InsertBlank( ::ItemCount + 1 )
      ::CurrentRow := ::ItemCount
      ::lAppendMode := .T.
   EndIf

Return ::EditGrid( , , lAppend, lOneRow, ::RefreshType == REFRESH_DEFAULT .OR. ::RefreshType == REFRESH_FORCE )

*-----------------------------------------------------------------------------*
METHOD EditGrid( nRow, nCol, lAppend, lOneRow, lRefresh ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local lSomethingEdited, nRecNo, nNextRec

   Empty( lRefresh )          // TODO: implement

   If ::FirstVisibleColumn == 0
      Return .F.
   EndIf

   ASSIGN nRow    VALUE nRow    TYPE "N" DEFAULT ::CurrentRow
   ASSIGN nCol    VALUE nCol    TYPE "N" DEFAULT ::CurrentCol
   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   ASSIGN lOneRow VALUE lOneRow TYPE "L" DEFAULT .F.

   If nRow < 1 .OR. nRow > ::ItemCount .OR. nCol < 1 .OR. nCol > Len( ::aHeaders )
      // Cell out of range
      Return .F.
   ElseIf lAppend .AND. ! ::AllowAppend
      Return .F.
   EndIf

   lSomethingEdited := .F.

   Do While nCol <= Len( ::aHeaders ) .AND. nRow <= ::ItemCount .AND. Select( ::WorkArea ) # 0
      nRecNo := ( ::WorkArea )->( RecNo() )
      IF lAppend
         ::DbGoTo( 0 )
      Else
         ::DbGoTo( ::aRecMap[ nRow ] )
         If nRow == ::ItemCount
            ::DbSkip()
            IF ::Eof()
               nNextRec := 0
            Else
               nNextRec := ( ::WorkArea )->( RecNo() )
            EndIf
            ::DbGoTo( ::aRecMap[ nRow ] )
         EndIf
      EndIf

Empty(nNextRec)                                         // TODO: check
      If ::IsColumnReadOnly( nCol )
         // Read only column
      ElseIf ! ::IsColumnWhen( nCol )
         // Not a valid WHEN
      ElseIf aScan( ::aHiddenCols, nCol ) > 0
         // Hidden column
      Else
         ::DbGoTo( nRecNo )

         // Edit one cell
         If ! ::EditCell( nRow, nCol, Nil, Nil, Nil, Nil, lAppend, Nil, .F., .F. )
            If lAppend
               ::lAppendMode := .F.
               lAppend := .F.
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
         IF ! ::PageUp() .OR. ! ::FullMove .OR. lOneRow
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
         ::CurrentCol := 1       // TODO: Agregar un flag para omitir esto
         // Insert new row
         ::GoBottom( .T. )
         ::InsertBlank( ::ItemCount + 1 )
         ::CurrentRow := ::ItemCount
         ::lAppendMode := .T.
      EndIf

      nRow := ::CurrentRow
      nCol := ::CurrentCol
   EndDo
   ::bPosition := 0

Return lSomethingEdited

*-----------------------------------------------------------------------------*
METHOD BrowseOnChange() CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
LOCAL cWorkArea, lSync, nRec

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

Return Nil

*-----------------------------------------------------------------------------*
METHOD DoChange() CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
   ::nRecLastValue := ::Value[ 1 ]
   ::TGridByCell:DoChange()
Return Nil

*-----------------------------------------------------------------------------*
METHOD FastUpdate( d, nRow ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Return ::TOBrowse:FastUpdate( d, nRow )

*-----------------------------------------------------------------------------*
METHOD ScrollUpdate() CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Return ::TOBrowse:ScrollUpdate()

*-----------------------------------------------------------------------------*
METHOD SetValue( Value, mp ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local nRow, nCol

   If HB_IsArray( Value ) .AND. Len( Value ) > 1
      nRow := Value[ 1 ]
      nCol := Value[ 2 ]
      If HB_IsNumeric( nRow ) .AND. nRow > 0 .AND. HB_IsNumeric( nCol ) .AND. nCol >= 1 .AND. nCol <= Len( ::aHeaders )
         ::CurrentCol := nCol
         ::TOBrowse:SetValue( nRow, mp )
      EndIf
   EndIf

Return Nil

*-----------------------------------------------------------------------------*
METHOD Delete() CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local Value, nRow, nRecNo, lSync

   Value := ::Value
   nRow  := Value[ 1 ]

   If nRow == 0
      Return Nil
   EndIf

   nRecNo := ( ::WorkArea )->( RecNo() )

   ::DbGoTo( nRow )

   If ::Lock .AND. ! ( ::WorkArea )->( Rlock() )
      MsgExclamation( _OOHG_Messages( 3, 9 ), _OOHG_Messages( 4, 2 ) )
   Else
      ( ::WorkArea )->( DbDelete() )

      // Do before unlocking record or moving record pointer
      // so block can operate on deleted record (e.g. to copy to a log).
      If HB_IsBlock( ::OnDelete )
         ::DoEvent( ::OnDelete, 'DELETE' )
      EndIf

      If ::Lock
         ( ::WorkArea )->( DbCommit() )
         ( ::WorkArea )->( DbUnlock() )
      EndIf
      ::DbSkip()
      If ::Eof()
         ::TopBottom( GO_BOTTOM )
      EndIf

      If Set( _SET_DELETED )
         ::SetValue( { ( ::WorkArea )->( RecNo() ), 1 }, LISTVIEW_GETFIRSTITEM( ::hWnd ) )
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

      If ( ::WorkArea )->( RecNo() ) != nRow
         ::DbGoTo( nRow )
      EndIf
   Else
      ::DbGoTo( nRecNo )
   EndIf

Return Nil

*-----------------------------------------------------------------------------*
METHOD UpDate( nRow ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Return ::TOBrowse:UpDate( nRow )

*-----------------------------------------------------------------------------*
METHOD UpDateColors() CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Return ::TOBrowse:UpDateColors()

*-----------------------------------------------------------------------------*
METHOD Home() CLASS TOBrowseByCell                   // METHOD GoTop
*-----------------------------------------------------------------------------*
Local _RecNo, aBefore, lDone := .F.

   If Select( ::WorkArea ) == 0
      ::RecCount := 0
      Return lDone
   EndIf
   aBefore := ::Value
   _RecNo := ( ::WorkArea )->( RecNo() )
   ::TopBottom( GO_TOP )
   ::ScrollUpdate()
   ::Update()
   ::DbGoTo( _RecNo )
   ListView_SetCursel( ::hWnd, 1 )
   ::CurrentCol := 1
   lDone := ( aBefore[ 1 ] # ::Value[ 1 ] .OR. aBefore[ 2 ] # ::Value[ 2 ] )
   ::BrowseOnChange()

Return lDone

*-----------------------------------------------------------------------------*
METHOD End( lAppend ) CLASS TOBrowseByCell     // METHOD GoBottom
*-----------------------------------------------------------------------------*
Local lDone := .F., aBefore, _Recno

   If Select( ::WorkArea ) == 0
      ::RecCount := 0
      Return lDone
   EndIf
   aBefore := ::Value
   _RecNo := ( ::WorkArea )->( RecNo() )
   ::TopBottom( GO_BOTTOM )
   ::ScrollUpdate()
   // If it's for APPEND, leaves a blank line ;)
   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   ::DbSkip( - ::CountPerPage + IIf( lAppend, 2, 1 ) )
   ::Update()
   ::DbGoTo( _RecNo )
   ListView_SetCursel( ::hWnd, Len( ::aRecMap ) )
   ::CurrentCol := IIf( lAppend, 1, Len( ::aHeaders ) )
   lDone := ( aBefore[ 1 ] # ::Value[ 1 ] .OR. aBefore[ 2 ] # ::Value[ 2 ] )
   ::BrowseOnChange()

Return lDone

*-----------------------------------------------------------------------------*
METHOD PageUp() CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local _RecNo, aBefore, lDone := .F.

   If LISTVIEW_GETFIRSTITEM( ::hWnd ) == 1
      If Select( ::WorkArea ) == 0
         ::RecCount := 0
         Return lDone
      EndIf
      aBefore := ::Value
      _RecNo := ( ::WorkArea )->( RecNo() )
      If Len( ::aRecMap ) == 0
         ::TopBottom( GO_TOP )
      Else
         ::DbGoTo( ::aRecMap[ 1 ] )
      EndIf
      ::DbSkip( - ::CountPerPage + 1 )
      ::ScrollUpdate()
      ::Update()
      ::DbGoTo( _RecNo )
      ListView_SetCursel ( ::hWnd, 1 )
      lDone := ( aBefore[ 1 ] # ::Value[ 1 ] .OR. aBefore[ 2 ] # ::Value[ 2 ] )
   Else
      ::FastUpdate( 1 - LISTVIEW_GETFIRSTITEM ( ::hWnd ), 1 )
      lDone := .T.
   EndIf

   ::BrowseOnChange()

Return lDone

*-----------------------------------------------------------------------------*
METHOD PageDown( lAppend ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local _RecNo, s, lDone := .F.

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .T.

   s := LISTVIEW_GETFIRSTITEM( ::hWnd )

   If  s >= Len( ::aRecMap )
      If Select( ::WorkArea ) == 0
         ::RecCount := 0
         Return lDone
      EndIf

      _RecNo := ( ::WorkArea )->( RecNo() )

      If Len( ::aRecMap ) == 0
         ::TopBottom( GO_BOTTOM )
         ::DbSkip( - ::CountPerPage + 1 )
      Else
         ::DbGoTo( ::aRecMap[ Len( ::aRecMap ) ] )
         // Check for more records
         ::DbSkip()
         If ::Eof()
            ::DbGoTo( _RecNo )
            If ::AllowAppend .AND. lAppend
               lDone := ::EditItem( .T., ! ( ::Inplace .AND. ::FullMove ) )
            Endif
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
      ListView_SetCursel ( ::hWnd, Len( ::aRecMap ) )
   Else
      ::FastUpdate( ::CountPerPage - s, Len( ::aRecMap ) )
      lDone := .T.
   EndIf

   ::BrowseOnChange()

Return lDone

*-----------------------------------------------------------------------------*
METHOD Up( lLast ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local s, _RecNo, nLen, lDone := .F.

   s := LISTVIEW_GETFIRSTITEM ( ::hWnd )

   If s <= 1
      If Select( ::WorkArea ) == 0
         ::RecCount := 0
         Return lDone
      EndIf

      _RecNo := ( ::WorkArea )->( RecNo() )

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
         AADD( ::aRecMap, nil )
         AINS( ::aRecMap, 1 )
         ::aRecMap[ 1 ] := ( ::WorkArea )->( RecNo() )
         If ::Visible
            ::SetRedraw( .F. )
         EndIf
         ::InsertBlank( 1 )
         ::RefreshRow( 1 )
         nLen := Len( ::aRecMap )
         // Resize record map
         If nLen > ::CountPerPage
            ::DeleteItem( nLen )
            ASIZE( ::aRecMap, nLen - 1 )
         EndIf
         If ::Visible
            ::SetRedraw( .T. )
         EndIf
      EndIf

      ::ScrollUpdate()
      ::DbGoTo( _RecNo )
      If Len( ::aRecMap ) != 0
         ListView_SetCursel( ::hWnd, 1 )
         If HB_IsLogical( lLast ) .and. lLast
            ::CurrentCol := Len( ::aHeaders )
         EndIf
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
Local s, _RecNo, nLen, lDone := .F.

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .T.

   s := LISTVIEW_GETFIRSTITEM( ::hWnd )

   If s >= Len( ::aRecMap )
      If Select( ::WorkArea ) == 0
         ::RecCount := 0
         Return lDone
      EndIf

      _RecNo := ( ::WorkArea )->( RecNo() )

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
            If ::AllowAppend .AND. lAppend
               lDone := ::EditItem( .T., ! ::FullMove )
            Endif
            Return lDone
         EndIf
         // Add one record at the bottom
         AADD( ::aRecMap, ( ::WorkArea )->( RecNo() ) )
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
      ListView_SetCursel( ::hWnd, Len( ::aRecMap ) )
      If HB_IsLogical( lFirst ) .and. lFirst
         ::CurrentCol := 1
      EndIf
   Else
      ::FastUpdate( 1, s + 1 )
      lDone := .T.
   EndIf

   ::BrowseOnChange()

Return lDone

*-----------------------------------------------------------------------------*
METHOD TopBottom( nDir ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Return ::TOBrowse:TopBottom( nDir )

*-----------------------------------------------------------------------------*
METHOD DbSkip( nRows ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Return ::TOBrowse:DbSkip( nRows )

*-----------------------------------------------------------------------------*
METHOD DbGoTo( nRecNo ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Return ::TOBrowse:DbGoTo( nRecNo )

*-----------------------------------------------------------------------------*
METHOD SetScrollPos( nPos, VScroll ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local BackRec

   If Select( ::WorkArea ) == 0
      // Not workarea selected
   ElseIf nPos <= VScroll:RangeMin
      ::GoTop()
   ElseIf nPos >= VScroll:RangeMax
      ::GoBottom()
   Else
      BackRec := ( ::WorkArea )->( RecNo() )
      ::TXBrowse:SetScrollPos( nPos, VScroll )
      ::Value := { ( ::WorkArea )->( RecNo() ), ::CurrentCol }
      ::DbGoTo( BackRec )
      ::BrowseOnChange()
   EndIf

Return Nil

*-----------------------------------------------------------------------------*
METHOD CurrentCol( nCol ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Local nItem, r, nClientWidth, nScrollWidth

   If HB_IsNumeric( nCol ) .AND. nCol >= 0 .AND. nCol <= Len( ::aHeaders )
      ::nColPos := nCol

      nItem := LISTVIEW_GETFIRSTITEM( ::hWnd )
      If nItem > 0 .AND. nItem <= Len( ::aRecMap )
         // Ensure cell is visible
         r := { 0, 0, 0, 0 }                                        // left, top, right, bottom
         GetClientRect( ::hWnd, r )
         nClientWidth := r[ 3 ] - r[ 1 ]
         r := ListView_GetSubitemRect( ::hWnd, nItem - 1, nCol - 1 ) // top, left, width, height
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
         ListView_RedrawItems( ::hWnd, nItem, nItem )
      EndIf
   EndIf
Return ::nColPos

*-----------------------------------------------------------------------------*
METHOD CurrentRow( nRow ) CLASS TOBrowseByCell
*-----------------------------------------------------------------------------*
Return ::TXBrowse:CurrentRow( nRow )

*--------------------------------------------------------------------------*
METHOD Left() CLASS TOBrowseByCell
*--------------------------------------------------------------------------*
Local aValue, nRec, nCol, lDone := .F.

   aValue := ::Value
   nRec := aValue[ 1 ]
   nCol := aValue[ 2 ]
   If nRec > 0 .AND. nCol >= 1 .AND. nCol <= Len( ::aHeaders )
      If nCol > 1
         ::Value := { nRec, nCol - 1 }
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

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT ::AllowAppend

   aValue := ::Value
   nRec := aValue[ 1 ]
   nCol := aValue[ 2 ]
   If nRec > 0 .AND. nCol >= 1 .AND. nCol <= Len( ::aHeaders )
      If nCol < Len( ::aHeaders )
         ::Value := { nRec, nCol + 1 }
         lDone := .T.
      ElseIf ::FullMove
         If ::Down( .F., .T. )
            lDone := .T.
         Else
            If ::AllowAppend .AND. lAppend
               lDone := ::EditItem( .T., ! ::FullMove )
            EndIf
         EndIf
      EndIf
   EndIf
Return lDone

/*
TODO: CONTROLAR QUE LAS COLUMNAS NO ESTEN OCULTAS
TODO: VER TAMBIÉN EN XBROWSE Y GRID

*/
