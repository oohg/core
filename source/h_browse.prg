/*
 * $Id: h_browse.prg,v 1.112 2013-06-20 22:47:55 fyurisich Exp $
 */
/*
 * ooHG source code:
 * PRG browse functions
 *
 * Copyright 2005-2011 Vicente Guerra <vicente@guerra.com.mx>
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

STATIC _OOHG_BrowseSyncStatus := .F.

CLASS TOBrowse FROM TXBrowse
   DATA Type            INIT "BROWSE" READONLY
   DATA aRecMap         INIT {}
   DATA RecCount        INIT 0
   DATA SyncStatus      INIT nil
   /*
    * When .T. the browse behaves as if SET BROWSESYNC is ON.
    * When .F. the browse behaves as if SET BROWSESYNC if OFF.
    * When NIL the browse behaves according to SET BROWESYNC value.
    */
   DATA lUpdateAll      INIT .F.
   DATA lNoDelMsg       INIT .T.

   METHOD Define
   METHOD Refresh
   METHOD Value               SETGET
   METHOD RefreshData
   METHOD DoChange            BLOCK { |Self| ::TGrid:DoChange() }

   METHOD Events
   METHOD Events_Enter
   METHOD Events_Notify

   METHOD EditCell
   METHOD EditItem_B
   METHOD EditAllCells
   METHOD BrowseOnChange
   METHOD FastUpdate
   METHOD ScrollUpdate
   METHOD SetValue
   METHOD Delete
   METHOD UpDate

   METHOD Home
   METHOD End
   METHOD PageUp
   METHOD PageDown
   METHOD Up
   METHOD Down
   METHOD TopBottom
   METHOD DbSkip
   METHOD DbGoTo
   MESSAGE GoTop    METHOD Home
   MESSAGE GoBottom METHOD End
   METHOD SetScrollPos

   MESSAGE EditGrid METHOD EditAllCells
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
               lNoHeaders, onenter, lDisabled, lNoTabStop, lInvisible, ;
               lDescending, bDelWhen, DelMsg, onDelete, aHeaderImage, ;
               aHeaderImageAlign, FullMove, aSelectedColors, aEditKeys, ;
               uRefresh, dblbffr, lFocusRect, lPLM, sync, lFixedCols, ;
               lNoDelMsg, lUpdateAll, abortedit, click, lFixedWidths ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local nWidth2, nCol2, oScroll, z

   ASSIGN ::aFields  VALUE aFields  TYPE "A"
   ASSIGN ::aHeaders VALUE aHeaders TYPE "A" DEFAULT {}
   ASSIGN ::aWidths  VALUE aWidths  TYPE "A" DEFAULT {}
   ASSIGN ::aJust    VALUE aJust    TYPE "A" DEFAULT {}

   ASSIGN ::lDescending VALUE lDescending TYPE "L"
   ASSIGN ::SyncStatus  VALUE sync        TYPE "L" DEFAULT nil
   ASSIGN ::lNoDelMsg   VALUE lNoDelMsg   TYPE "L"
   ASSIGN ::lUpdateAll  VALUE lUpdateAll  TYPE "L"

   IF ValType( uRefresh ) == "N"
      IF uRefresh == 0 .OR. uRefresh == 1
         ::RefreshType := uRefresh
      ENDIF
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
   aEval( ::aHeaders, { |x,i| ::aHeaders[ i ] := iif( ! ValType( x ) $ "CM", if( valtype( ::aFields[ i ] ) $ "CM", ::aFields[ i ], "" ), x ) } )

   aSize( ::aWidths, len( ::aFields ) )
   aEval( ::aWidths, { |x,i| ::aWidths[ i ] := iif( ! ValType( x ) == "N", 100, x ) } )

   // If splitboxed force no vertical scrollbar

   ASSIGN novscroll VALUE novscroll TYPE "L" DEFAULT .F.
   if valtype(x) != "N" .or. valtype(y) != "N"
      novscroll := .T.
   endif

   ASSIGN w         VALUE w         TYPE "N" DEFAULT ::nWidth
   nWidth2 := if( novscroll, w, w - GETVSCROLLBARWIDTH() )

   ::TGrid:Define( ControlName, ParentForm, x, y, nWidth2, h, ::aHeaders, ::aWidths, {}, nil, ;
                   fontname, fontsize, tooltip, , , aHeadClick, , , ;
                   nogrid, aImage, ::aJust, break, HelpId, bold, italic, underline, strikeout, nil, ;
                   nil, nil, edit, backcolor, fontcolor, dynamicbackcolor, dynamicforecolor, aPicture, ;
                   lRtl, InPlace, editcontrols, readonly, valid, validmessages, editcell, ;
                   aWhenFields, lDisabled, lNoTabStop, lInvisible, lNoHeaders,, aHeaderImage, ;
                   aHeaderImageAlign, FullMove, aSelectedColors, aEditKeys, , , dblbffr, lFocusRect, ;
                   lPLM, lFixedCols, abortedit, click, lFixedWidths )

   ::nWidth := w

   IF ValType( Value ) == "N"
      ::nValue := Value
   ENDIF

   ASSIGN ::Lock          VALUE lock          TYPE "L"
   ASSIGN ::AllowDelete   VALUE AllowDelete   TYPE "L"
   ASSIGN ::AllowAppend   VALUE AllowAppend   TYPE "L"
   ASSIGN ::aReplaceField VALUE replacefields TYPE "A"
   ASSIGN ::lRecCount     VALUE lRecCount     TYPE "L"

   ::WorkArea := WorkArea
   ::aRecMap := {}

   ::ScrollButton := TScrollButton():Define( , Self, nCol2, ::nHeight - GETHSCROLLBARHEIGHT(), GETVSCROLLBARWIDTH(), GETHSCROLLBARHEIGHT() )

   oScroll := TScrollBar()
   oScroll:nWidth := GETVSCROLLBARWIDTH()
   oScroll:SetRange( 1, 1000 )

   IF ::lRtl .AND. ! ::Parent:lRtl
      ::nCol := ::nCol + GETVSCROLLBARWIDTH()
      nCol2 := -GETVSCROLLBARWIDTH()
   Else
      nCol2 := nWidth2
   ENDIF
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

   If novscroll
      ::lVScrollVisible := .F.
      ::ScrollButton:Visible := .F.
      ::VScroll := nil
   Else
      ::lVScrollVisible := .T.
   EndIf

   ::SizePos()

   // Must be set after control is initialized
   ASSIGN ::OnLostFocus VALUE lostfocus   TYPE "B"
   ASSIGN ::OnGotFocus  VALUE gotfocus    TYPE "B"
   ASSIGN ::OnChange    VALUE change      TYPE "B"
   ASSIGN ::OnDblClick  VALUE dblclick    TYPE "B"
   ASSIGN ::OnAppend    VALUE onappend    TYPE "B"
   ASSIGN ::OnEnter     value onenter     TYPE "B"
   ASSIGN ::bDelWhen    VALUE bDelWhen    TYPE "B"
   ASSIGN ::DelMsg      VALUE DelMsg      TYPE "C"
   ASSIGN ::OnDelete    VALUE onDelete    TYPE "B"

Return Self

*-----------------------------------------------------------------------------*
METHOD UpDate() CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local PageLength, aTemp, _BrowseRecMap := {}, x
Local nCurrentLength
Local lColor, aFields, cWorkArea, hWnd, nWidth

   cWorkArea := ::WorkArea

   If Select( cWorkArea ) == 0
      ::RecCount := 0
      Return nil
   EndIf

   lColor := ! ( Empty( ::DynamicForeColor ) .AND. Empty( ::DynamicBackColor ) )
   nWidth := LEN( ::aFields )
   aFields := ARRAY( nWidth )
   AEVAL( ::aFields, { |c,i| aFields[ i ] := ::ColumnBlock( i ), c } )
   hWnd := ::hWnd

   PageLength := ::CountPerPage

   If PageLength < 1
     Return nil
   Endif

   If lColor
      ::GridForeColor := ARRAY( PageLength )
      ::GridBackColor := ARRAY( PageLength )
   Else
      ::GridForeColor := nil
      ::GridBackColor := nil
   EndIf

   // update rows
   x := 0
   nCurrentLength := ::ItemCount()

   Do While x < PageLength .AND. ! ::Eof()

      x++

      aTemp := ARRAY( nWidth )

      AEVAL( aFields, { |b,i| aTemp[ i ] := EVAL( b ) } )

      If lColor
         ( cWorkArea )->( ::SetItemColor( x,,, aTemp ) )
      EndIf

      IF nCurrentLength < x
         AddListViewItems( hWnd, aTemp )
         nCurrentLength++
      Else
         ListViewSetItem( hWnd, aTemp, x )
      ENDIF

      aadd( _BrowseRecMap, ( cWorkArea )->( RecNo() ) )

      ::DbSkip()
   EndDo

   Do While nCurrentLength > Len( _BrowseRecMap )
      ::DeleteItem( nCurrentLength )
      nCurrentLength--
   EndDo

   ::aRecMap := _BrowseRecMap

   // update headers text and images, columns widths and justifications
   If ::lUpdateAll
      If Len( ::aWidths ) != nWidth
         ASIZE( ::aWidths, nWidth )
         AEVAL( ::aWidths, { |x,i| ::aWidths[ i ] := If( ! HB_IsNumeric( x ), 0, x ) } )
      EndIf
      AEVAL( ::aWidths, { |x,i| ::ColumnWidth( i, x ) } )

      If Len( ::aJust ) != nWidth
         ASIZE( ::aJust, nWidth )
         AEVAL( ::aJust, { |x,i| ::aJust[ i ] := If( ! HB_IsNumeric( x ), 0, x ) } )
      EndIf
      AEVAL( ::aJust, { |x,i| ::Justify( i, x ) } )

      If Len( ::aHeaders ) != nWidth
         ASIZE( ::aHeaders, nWidth )
         AEVAL( ::aHeaders, { |x,i| ::aHeaders[ i ] := If( ! ValType( x ) $ "CM", "", x ) } )
      EndIf
      AEVAL( ::aHeaders, { |x,i| ::Header( i, x ) } )

      ::LoadHeaderImages( ::aHeaderImage )
   EndIf

Return nil

*-----------------------------------------------------------------------------*
METHOD PageDown() CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local _RecNo, s, i

   s := LISTVIEW_GETFIRSTITEM( ::hWnd )

   If  s >= Len( ::aRecMap )

      If Select( ::WorkArea ) == 0
         ::RecCount := 0
         Return nil
      EndIf

      _RecNo := ( ::WorkArea )->( RecNo() )

      If Len( ::aRecMap ) == 0
         ::TopBottom( 1 )
         ::DbSkip( - ::CountPerPage + 1 )
      Else
         ::DbGoTo( ::aRecMap[ Len( ::aRecMap ) ] )
         // Checks for more records
         ::DbSkip()
         If ::Eof()
            ::DbGoTo( _RecNo )
            If ::AllowAppend
               ::EditItem( .t. )
            Endif
            Return nil
         EndIf
         ::DbSkip( -1 )
      EndIf
      ::Update()
      If Len( ::aRecMap ) == 0
         ::DbGoTo( 0 )
      Else
         ::DbGoTo( ::aRecMap[ Len( ::aRecMap ) ] )
      EndIf
      ::scrollUpdate()
      ::DbGoTo( _RecNo )

      i := Len( ::aRecMap )
      If s != i
         ListView_SetCursel ( ::hWnd, i )
      EndIf

   Else

      ::FastUpdate( ::CountPerPage - s, Len( ::aRecMap ) )

   EndIf

   ::BrowseOnChange()

Return nil

*-----------------------------------------------------------------------------*
METHOD PageUp() CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local _RecNo

   If LISTVIEW_GETFIRSTITEM( ::hWnd ) == 1
      If Select( ::WorkArea ) == 0
         ::RecCount := 0
         Return nil
      EndIf
      _RecNo := ( ::WorkArea )->( RecNo() )
      If Len( ::aRecMap ) == 0
         ::TopBottom( -1 )
      Else
         ::DbGoTo( ::aRecMap[ 1 ] )
      EndIf
      ::DbSkip( - ::CountPerPage + 1 )
      ::scrollUpdate()
      ::Update()
      ::DbGoTo( _RecNo )

   Else

      ::FastUpdate( 1 - LISTVIEW_GETFIRSTITEM ( ::hWnd ), 1 )

   EndIf

   ::BrowseOnChange()

Return nil

*-----------------------------------------------------------------------------*
METHOD Home() CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local _RecNo

   If Select( ::WorkArea ) == 0
      ::RecCount := 0
      Return nil
   EndIf
   _RecNo := ( ::WorkArea )->( RecNo() )
   ::TopBottom( -1 )
   ::scrollUpdate()
   ::Update()
   ::DbGoTo( _RecNo )

   ListView_SetCursel( ::hWnd, 1 )

   ::BrowseOnChange()

Return nil

*-----------------------------------------------------------------------------*
METHOD End( lAppend ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local _RecNo, _BottomRec
   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.

   If Select( ::WorkArea ) == 0
      ::RecCount := 0
      Return nil
   EndIf
   _RecNo := ( ::WorkArea )->( RecNo() )
   ::TopBottom( 1 )
   _BottomRec := ( ::WorkArea )->( RecNo() )
   ::ScrollUpdate()

   // If it's for APPEND, leaves a blank line ;)
   ::DbSkip( - ::CountPerPage + IF( lAppend, 2, 1 ) )
   ::Update()
   ::DbGoTo( _RecNo )

   ListView_SetCursel( ::hWnd, ascan ( ::aRecMap, _BottomRec ) )

   ::BrowseOnChange()

Return nil

*-----------------------------------------------------------------------------*
METHOD Up() CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local s, _RecNo

   s := LISTVIEW_GETFIRSTITEM ( ::hWnd )

   If s <= 1
      If Select( ::WorkArea ) == 0
         ::RecCount := 0
         Return nil
      EndIf
      _RecNo := ( ::WorkArea )->( RecNo() )
      If Len( ::aRecMap ) == 0
         ::TopBottom( -1 )
      Else
         ::DbGoTo( ::aRecMap[ 1 ] )
      EndIf
      ::DbSkip( -1 )
      ::scrollUpdate()
      ::Update()
      ::DbGoTo( _RecNo )

      If Len( ::aRecMap ) != 0 .and. s != 1
         ListView_SetCursel( ::hWnd, 1 )
      EndIf

   Else

      ::FastUpdate( -1, s - 1 )

   EndIf

   ::BrowseOnChange()

Return nil

*-----------------------------------------------------------------------------*
METHOD Down() CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local s, _RecNo, i

   s := LISTVIEW_GETFIRSTITEM( ::hWnd )

   If s >= Len( ::aRecMap )

      If Select( ::WorkArea ) == 0
         ::RecCount := 0
         Return nil
      EndIf

      _RecNo := ( ::WorkArea )->( RecNo() )

      If Len( ::aRecMap ) == 0
         ::TopBottom( -1 )
      Else
         // Checks for more records
         ::DbGoTo( ::aRecMap[ Len( ::aRecMap ) ] )
         ::DbSkip()
         If ::Eof()
            ::DbGoTo( _RecNo )
            If ::AllowAppend
               ::EditItem( .t. )
            Endif
            Return nil
         EndIf
         ::DbSkip( -1 )

         ::DbGoTo( ::aRecMap[ 1 ] )
      EndIf
      ::DbSkip()
      ::Update()
      If Len( ::aRecMap ) != 0
         ::DbGoTo( ATail( ::aRecMap ) )
      EndIf
      ::scrollUpdate()
      ::DbGoTo( _RecNo )

      i := Len( ::aRecMap )
      If s != i
         ListView_SetCursel( ::hWnd, i )
      EndIf

   Else

      ::FastUpdate( 1, s + 1 )

   EndIf

   ::BrowseOnChange()

Return nil

*-----------------------------------------------------------------------------*
METHOD TopBottom( nDir ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
   If ::lDescending
      nDir := - nDir
   EndIf
   If nDir == 1
      ( ::WorkArea )->( DbGoBottom() )
   Else
      ( ::WorkArea )->( DbGoTop() )
   EndIf
   ::Bof := .F.
   ::Eof := ( ::WorkArea )->( Eof() )
Return nil

*-----------------------------------------------------------------------------*
METHOD DbSkip( nRows ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
   ASSIGN nRows VALUE nRows TYPE "N" DEFAULT 1
   IF ! ::lDescending
      ( ::WorkArea )->( DbSkip(   nRows ) )
      ::Bof := ( ::WorkArea )->( Bof() )
      ::Eof := ( ::WorkArea )->( Eof() ) .OR. ( ( ::WorkArea )->( Recno() ) > ( ::WorkArea )->( RecCount() ) )
   ELSE
      ( ::WorkArea )->( DbSkip( - nRows ) )
      If ( ::WorkArea )->( Eof() )
         ( ::WorkArea )->( DbGoBottom() )
         ::Bof := .T.
         ::Eof := ( ::WorkArea )->( Eof() )
      ElseIf ( ::WorkArea )->( Bof() )
         ::Eof := .T.
         ::DbGoTo( 0 )
      EndIf
   ENDIF
RETURN NIL

*-----------------------------------------------------------------------------*
METHOD DbGoTo( nRecNo ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
   ( ::WorkArea )->( DbGoTo( nRecNo ) )
   ::Bof := .F.
   ::Eof := ( ::WorkArea )->( Eof() )
RETURN NIL

*-----------------------------------------------------------------------------*
METHOD SetValue( Value, mp ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local _RecNo, m, hWnd, cWorkArea

   cWorkArea := ::WorkArea

   If Select( cWorkArea ) == 0
      ::RecCount := 0
      Return nil
   EndIf

   If Value <= 0
      Return nil
   EndIf

   hWnd := ::hWnd

   If _OOHG_ThisEventType == 'BROWSE_ONCHANGE'
      If hWnd == _OOHG_ThisControl:hWnd
         MsgOOHGError( "BROWSE: Value property can't be changed inside ONCHANGE event. Program Terminated." )
      EndIf
   EndIf

   If Value > ( cWorkArea )->( RecCount() )
      ::nValue := 0
      ::DeleteAllItems()
      ::BrowseOnChange()
      Return nil
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
      Return nil
   EndIf

   // Avoid to use DBFILTER()
   ::DbSkip()
   ::DbSkip( -1 )
   IF ( cWorkArea )->( RecNo() ) != Value
      ::DbGoTo( _RecNo )
      Return nil
   ENDIF

   if pcount() < 2
      ::ScrollUpdate()
   EndIf
   ::DbSkip( -m + 1 )

   ::nValue := Value
   ::Update()
   ::DbGoTo( _RecNo )

   ListView_SetCursel ( hWnd, ascan( ::aRecMap, Value ) )

   _OOHG_ThisEventType := 'BROWSE_ONCHANGE'
   ::BrowseOnChange()
   _OOHG_ThisEventType := ''

Return nil

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
         Eval( ::OnDelete )
      EndIf

      If ::Lock
         ( ::WorkArea )->( DbCommit() )
         ( ::WorkArea )->( DbUnlock() )
      EndIf
      ::DbSkip()
      If ::Eof()
         ::TopBottom( 1 )
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
METHOD EditItem_B( append ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local nOldRecNo, nItem, cWorkArea, lRet

   ASSIGN append VALUE append TYPE "L" DEFAULT .F.

   cWorkArea := ::WorkArea
   If Select( cWorkArea ) == 0
      ::RecCount := 0
      Return .F.
   EndIf

   nItem := LISTVIEW_GETFIRSTITEM( ::hWnd )

   If nItem == 0 .AND. ! append
      Return .F.
   EndIf

   nOldRecNo := ( cWorkArea )->( RecNo() )

   If ! append
      ::DbGoTo( ::aRecMap[ nItem ] )
   EndIf

   lRet := ::Super:EditItem_B( append )

   If lRet .AND. append
      nOldRecNo := ( cWorkArea )->( RecNo() )
      ::Value := nOldRecNo
   EndIf

   ::DbGoTo( nOldRecNo )

Return lRet

*-----------------------------------------------------------------------------*
METHOD EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, lAppend ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local lRet, BackRec
   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   ASSIGN nRow    VALUE nRow    TYPE "N" DEFAULT ::CurrentRow
   If nRow < 1 .OR. nRow > ::ItemCount()
      // Cell out of range
      lRet := .F.
   ElseIf Select( ::WorkArea ) == 0
      // It the specified area does not exists, set recordcount to 0 and return
      ::RecCount := 0
      lRet := .F.
   Else
      BackRec := ( ::WorkArea )->( RecNo() )
      IF lAppend
         ::DbGoTo( 0 )
      Else
         ::DbGoTo( ::aRecMap[ nRow ] )
      EndIf
      lRet := ::Super:EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, lAppend )
      If lRet .AND. lAppend
         AADD( ::aRecMap, ( ::WorkArea )->( RecNo() ) )
      EndIf
      ::DbGoTo( BackRec )
   Endif
Return lRet

*-----------------------------------------------------------------------------*
METHOD EditAllCells( nRow, nCol, lAppend ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local lRet, lRowEdited, lSomethingEdited, _RecNo, lRowAppended, lMoreRecs

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
      lRowAppended := .F.

      // This is needed in case the database has an active index
      // and the record's key is changed during editing
      If ! ::FullMove .OR. lAppend .OR. nRow > Len( ::aRecMap )
         lMoreRecs := .F.
      Else
         _RecNo := ( ::WorkArea )->( RecNo() )
         //NOTE: in certain, not so clear, circumstances cancels here
         //      with "Index out of bounds" error
         //      Just happened once with a FULLMOVE INPLACE APPEND EDIT DELETE
         //      browse of an indexed database.
         //      I can't undertand why and I can't replicate the error.
         ::DbGoTo( ::aRecMap[ nRow ] )
         ::DbSkip()
         If ::Eof()
            lMoreRecs := .F.
         Else
            ::DbSkip(-1)
            lMoreRecs := .T.
         EndIf
         ::DbGoTo( _RecNo )
      EndIf

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
               If lAppend
                  lRowAppended := .T.
               EndIf
            ElseIf lAppend
               ::GoBottom()
            EndIf

            lAppend := .F.
         EndIf

         nCol++
      EndDo

      If lRowEdited
         // If a column was edited, scroll to the left
         ListView_Scroll( ::hWnd, - _OOHG_GridArrayWidths( ::hWnd, ::aWidths ), 0 )
      EndIf

      // See what to do next
      If ! lRet .or. ! ::FullMove
         If lRowAppended
            // This is needed in case EditAllCells was called from EditItem_B
            ::DbGoTo( aTail( ::aRecMap ) )
         EndIf

         If ::RefreshType == 0
            ::Refresh()
         EndIf

         // Stop if the last column was not edited or it's not fullmove editing
         Exit
      ElseIf lRowAppended
         If ! ::AllowAppend
            // Stop
            Exit
         EndIf

         // Add new row
         ::GoBottom( .T. )
         ::InsertBlank( ::ItemCount + 1 )
         nRow := ::CurrentRow := ::ItemCount
         lAppend := .T.
         ::lAppendMode := .T.
      ElseIf nRow < ::ItemCount()
         // Edit next row
         nRow ++
         nCol := 1
         ::FastUpdate( 1, nRow )
         ::BrowseOnChange()
      ElseIf Select( ::WorkArea ) == 0
         // Stop if no database is selected
         ::RecCount := 0
         Exit
      ElseIf lMoreRecs
         // Scroll down 1 row
         _RecNo := ( ::WorkArea )->( RecNo() )
         ::DbGoTo( ::aRecMap[ 1 ] )
         ::DbSkip()
         ::Update()
         If Len( ::aRecMap ) != 0
            ::DbGoTo( ATail( ::aRecMap ) )
         EndIf
         ::ScrollUpdate()
         ::DbGoTo( _RecNo )

         ListView_SetCursel( ::hWnd, Len( ::aRecMap ) )
         ::BrowseOnChange()
         nCol := 1
       ElseIf ::AllowAppend
         // Add new row
         ::GoBottom( .T. )
         ::InsertBlank( ::ItemCount + 1 )
         nRow := ::CurrentRow := ::ItemCount
         lAppend := .T.
         ::lAppendMode := .T.
         nCol := 1
      Else
         // Stop because last row was edited
         Exit
      EndIf
   EndDo

Return lSomethingEdited

#pragma BEGINDUMP
#define s_Super s_TGrid

#include "hbapi.h"
#include "hbapiitm.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windows.h>
#include <commctrl.h>
#include "oohg.h"
#pragma ENDDUMP

*-----------------------------------------------------------------------------*
METHOD BrowseOnChange() CLASS TOBrowse
*-----------------------------------------------------------------------------*
LOCAL cWorkArea, lSync

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

Return nil

*-----------------------------------------------------------------------------*
METHOD FastUpdate( d, nRow ) CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local ActualRecord, RecordCount

   // If vertical scrollbar is used it must be updated
   If ::lVScrollVisible

      RecordCount := ::RecCount

      If RecordCount == 0
         Return nil
      EndIf

      If RecordCount < 1000
         ActualRecord := ::VScroll:Value + d
         * ::VScroll:RangeMax := RecordCount
         ::VScroll:Value := ActualRecord

      EndIf

   EndIf

   If Len( ::aRecMap ) < nRow .OR. nRow == 0
      ::nValue := 0
   Else
      ::nValue := ::aRecMap[ nRow ]
   EndIf

   ListView_SetCursel( ::hWnd, nRow )

Return nil

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
         Return NIL
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

      ::nValue := ( cWorkArea )->( RecNo() )
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

Return NIL

*-----------------------------------------------------------------------------*
METHOD Refresh() CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local s, _RecNo, v
Local cWorkArea, hWnd

   cWorkArea := ::WorkArea
   hWnd := ::hWnd

   If Select( cWorkArea ) == 0
      ::DeleteAllItems()
      Return nil
   EndIf

   v := ::Value

   s := LISTVIEW_GETFIRSTITEM( hWnd )

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
            ::TopBottom( -1 )
         EndIf
      EndIf

      If Set( _SET_DELETED )
         If ( cWorkArea )->( Deleted() )
            ::TopBottom( -1 )
         EndIf
      EndIf
   Endif

   If ::Eof()
      ::DeleteAllItems()
      ::DbGoTo( _RecNo )
      Return nil
   EndIf

   ::ScrollUpdate()

   If s != 0
      ::DbSkip( - s + 1 )
   EndIf

   ::Update()

   ::DbGoTo( _RecNo )

   ListView_SetCursel( hWnd, ascan( ::aRecMap, v ) )

Return nil

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
         uValue := 0 // ::nValue
      Endif
   EndIf
RETURN uValue

*-----------------------------------------------------------------------------*
METHOD RefreshData() CLASS TOBrowse
*-----------------------------------------------------------------------------*
Local nValue := ::nValue
   IF ValType( nValue ) != "N" .OR. nValue == 0
      ::Refresh()
      ::nValue := ::Value
   Else
      ::Refresh()
   ENDIF
RETURN ::Super:RefreshData()

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
            ::TopBottom( -1 )
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
         uGridValue := Eval( ::ColumnBlock( ::SearchCol ), cWorkArea )
         If ValType( uGridValue ) == "A"      // TGridControlImageData
            uGridValue := uGridValue[ 1 ]
         EndIf

         If Upper( Left( uGridValue, Len( ::cText ) ) ) == ::cText
            Exit
         EndIf

         ::DbSkip()
      EndDo

      If ::Eof() .AND. ::SearchWrap
         ::TopBottom( -1 )
         Do While ! ::Eof() .AND. ( cWorkArea )->( RecNo() ) != Value
            uGridValue := Eval( ::ColumnBlock( ::SearchCol ), cWorkArea )
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
      Case wParam == 36 // HOME
         ::Home()
         Return 0
      Case wParam == 35 // END
         ::End()
         Return 0
      Case wParam == 33 // PGUP
         ::PageUp()
         Return 0
      Case wParam == 34 // PGDN
         ::PageDown()
         Return 0
      Case wParam == 38 // UP
         ::Up()
         Return 0
      Case wParam == 40 // DOWN
         ::Down()
         Return 0
      EndCase

   EndIf

Return ::Super:Events( hWnd, nMsg, wParam, lParam )

*-----------------------------------------------------------------------------*
METHOD Events_Enter() CLASS TOBrowse
*-----------------------------------------------------------------------------*
   ::cText := ""
   If Select( ::WorkArea ) != 0
      If ! ::AllowEdit
         ::DoEvent( ::OnEnter, "ENTER" )
      ElseIf ::FullMove .OR. ::InPlace
         If ! ::lNestedEdit
            ::lNestedEdit := .T.
            ::EditAllCells()
            ::lNestedEdit := .F.
         EndIf
      ElseIf ! ::lNestedEdit
            ::lNestedEdit := .T.
            ::EditItem()
            ::lNestedEdit := .F.
      EndIf
   Endif
Return nil

#pragma BEGINDUMP
// -----------------------------------------------------------------------------
// METHOD Events_Notify( wParam, lParam ) CLASS TOBrowse
HB_FUNC_STATIC( TOBROWSE_EVENTS_NOTIFY )
// -----------------------------------------------------------------------------
{
   LONG wParam = hb_parnl( 1 );
   LONG lParam = hb_parnl( 2 );
   PHB_ITEM pSelf;

   switch( ( ( NMHDR FAR * ) lParam )->code )
   {
      case NM_CLICK:
      case NM_RCLICK:
      case LVN_BEGINDRAG:
      case LVN_KEYDOWN:
      case LVN_ITEMCHANGED:
         HB_FUNCNAME( TOBROWSE_EVENTS_NOTIFY2 )();
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
#pragma ENDDUMP

FUNCTION TOBrowse_Events_Notify2( wParam, lParam )
Local Self := QSelf()
Local nNotify := GetNotifyCode( lParam )
Local nvKey, r, DeltaSelect, lGo

   If nNotify == NM_CLICK  .or. nNotify == LVN_BEGINDRAG .or. nNotify == NM_RCLICK
      r := LISTVIEW_GETFIRSTITEM( ::hWnd )
      If r > 0
         DeltaSelect := r - ascan ( ::aRecMap, ::nValue )
         ::FastUpdate( DeltaSelect, r )
         ::BrowseOnChange()
      EndIf
      Return nil

   ElseIf nNotify == LVN_KEYDOWN
      If GetGridvKeyAsChar( lParam ) == 0
         ::cText := ""
      EndIf

      nvKey := GetGridvKey( lParam )

      Do Case

      Case Select( ::WorkArea ) == 0
         // No database open

      Case nvKey == 65 // A
         if GetAltState() == -127 ;
            .or.;
            GetAltState() == -128   // ALT

            If ::AllowAppend
               ::EditItem( .t. )
            EndIf

         EndIf

      Case nvKey == 46 // DEL
         If ::AllowDelete .and. ! ::Eof()
            If HB_IsBlock( ::bDelWhen )
               lGo := EVAL( ::bDelWhen )
            Else
               lGo := .t.
            EndIf

            If lGo
               If ::lNoDelMsg
                  ::Delete()
               ElseIf MsgYesNo(_OOHG_Messages(4, 1), _OOHG_Messages(4, 2))
                  ::Delete()
               EndIf
            ElseIf ! Empty( ::DelMsg )
               MsgExclamation(::DelMsg, _OOHG_Messages(4, 2))
            EndIf
         EndIf

      EndCase

      Return nil

   ElseIf nNotify == LVN_ITEMCHANGED
      If GetGridOldState( lParam ) == 0 .and. GetGridNewState( lParam ) != 0
         Return nil
      EndIf

   EndIf

Return ::Super:Events_Notify( wParam, lParam )

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
Return nil

EXTERN INSERTUP, INSERTDOWN, INSERTPRIOR, INSERTNEXT

#pragma BEGINDUMP
HB_FUNC( INSERTUP )
{
   keybd_event(
                VK_UP,          // virtual-key code
                0,              // hardware scan code
                0,              // flags specifying various function options
                0               // additional data associated with keystroke
              );
}

HB_FUNC( INSERTDOWN )
{
   keybd_event(
                VK_DOWN,        // virtual-key code
                0,              // hardware scan code
                0,              // flags specifying various function options
                0               // additional data associated with keystroke
              );
}

HB_FUNC( INSERTPRIOR )
{
   keybd_event(
                VK_PRIOR,       // virtual-key code
                0,              // hardware scan code
                0,              // flags specifying various function options
                0               // additional data associated with keystroke
              );
}

HB_FUNC( INSERTNEXT )
{
   keybd_event(
                VK_NEXT,        // virtual-key code
                0,              // hardware scan code
                0,              // flags specifying various function options
                0               // additional data associated with keystroke
              );
}

#pragma ENDDUMP

Function SetBrowseSync( lValue )
   IF valtype( lValue ) == "L"
      _OOHG_BrowseSyncStatus := lValue
   ENDIF
Return _OOHG_BrowseSyncStatus
