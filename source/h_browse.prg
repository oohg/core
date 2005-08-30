/*
 * $Id: h_browse.prg,v 1.14 2005-08-30 04:59:39 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG browse functions
 *
 * Copyright 2005 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.guerra.com.mx
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

#include 'oohg.ch'
#include "hbclass.ch"
#include "i_windefs.ch"

STATIC _OOHG_BrowseSyncStatus := .F.
STATIC _OOHG_IPE_ROW := 1   // ???
STATIC _OOHG_IPE_CANCELLED := .F.   // ???

memvar aresult

CLASS TBrowse FROM TGrid
   DATA Type      INIT "BROWSE" READONLY
   DATA Lock      INIT .F.
   DATA WorkArea  INIT ""
   DATA VScroll   INIT nil
   DATA nValue    INIT 0
   DATA aRecMap   INIT {}
   DATA AllowAppend     INIT .F.
   DATA readonly        INIT .F.
   DATA valid           INIT .F.
   DATA validmessages   INIT .F.
   DATA AllowDelete     INIT .F.
   DATA InPlace         INIT .F.
   DATA RecCount        INIT 0
   DATA aFields         INIT {}
   DATA lEof            INIT .F.
   DATA aControls       INIT {}
   DATA nButtonActive   INIT 0
   DATA aWhen           INIT {}

   METHOD Define
   METHOD Refresh
   METHOD Release
   METHOD SizePos
   METHOD Value               SETGET
   METHOD Enabled             SETGET
   METHOD Visible             SETGET
   METHOD ForceHide
   METHOD RefreshData

   METHOD IsHandle

   METHOD Events_Enter
   METHOD Events_Notify

   METHOD BrowseOnChange
   METHOD FastUpdate
   METHOD ScrollUpdate
   METHOD EditItem
   METHOD ProcessInPlaceKbdEdit
   METHOD SetValue
   METHOD Delete
   METHOD UpDate
   METHOD InPlaceAppend
   METHOD InPlaceEdit
   METHOD AdjustRightScroll

   METHOD Home
   METHOD End
   METHOD PageUp
   METHOD PageDown
   METHOD Up
   METHOD Down
   METHOD SetScrollPos
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
               aFields, value, fontname, fontsize, tooltip, change, ;
               dblclick, aHeadClick, gotfocus, lostfocus, WorkArea, ;
               AllowDelete, nogrid, aImage, aJust, HelpId, bold, italic, ;
               underline, strikeout, break, backcolor, fontcolor, lock, ;
               inplace, novscroll, AllowAppend, readonly, valid, ;
               validmessages, edit, dynamicbackcolor, aWhenFields, ;
               dynamicforecolor, aPicture, lRtl ) CLASS TBrowse
*-----------------------------------------------------------------------------*
Local ScrollBarHandle, hsum, ScrollBarButtonHandle := 0, nWidth2, nCol2

   IF ! ValType( WorkArea ) $ "CM" .OR. Empty( WorkArea )
      WorkArea := ALIAS()
   ENDIF
   if valtype( aFields ) != "A"
      aFields := ( WorkArea )->( DBSTRUCT() )
      AEVAL( aFields, { |x,i| aFields[ i ] := WorkArea + "->" + x[ 1 ] } )
	endif

   if valtype( aHeaders ) != "A"
      aHeaders := Array( len( aFields ) )
	else
      aSize( aHeaders, len( aFields ) )
	endif
   aEval( aHeaders, { |x,i| aHeaders[ i ] := iif( ! ValType( x ) $ "CM" .OR. Empty( x ), aFields[ i ], x ) } )

	// If splitboxed force no vertical scrollbar

   if valtype(x) != "N" .or. valtype(y) != "N"
		novscroll := .T.
	endif

   IF valtype( w ) != "N"
      w := 240
   ENDIF
   IF novscroll
      nWidth2 := w
   Else
      nWidth2 := w - GETVSCROLLBARWIDTH()
   ENDIF

   ::Super:Define( ControlName, ParentForm, x, y, nWidth2, h, aHeaders, aWidths, {}, nil, ;
                   fontname, fontsize, tooltip, /* change */, /* dblclick */, aHeadClick, /* gotfocus */ , /* lostfocus */, ;
                   nogrid, aImage, aJust, break, HelpId, bold, italic, underline, strikeout, nil, ;
                   nil, nil, edit, backcolor, fontcolor, dynamicbackcolor, dynamicforecolor, aPicture, lRtl )

   ::nWidth := w

   ::nValue := Value
   ::Lock := Lock
   ::InPlace := inplace
   ::WorkArea := WorkArea
   ::AllowDelete := AllowDelete
   ::aFields := aFields
   ::aRecMap :=  {}
   ::AuxHandle := 0
   ::AllowAppend := AllowAppend
   ::readonly := readonly
   ::valid := valid
   ::validmessages := validmessages
   ::aWhen := aWhenFields

   if ! novscroll

      hsum := _OOHG_GridArrayWidths( ::hWnd, ::aWidths )

      nCol2 := x + nWidth2
      IF lRtl .AND. ! ::Parent:lRtl
         ::nCol := x + GETVSCROLLBARWIDTH()
         nCol2 := x
      ENDIF

		if hsum > w - GETVSCROLLBARWIDTH() - 4
         ScrollBarHandle := InitVScrollBar ( ::Parent:hWnd, nCol2, y , GETVSCROLLBARWIDTH() , h - GETHSCROLLBARHEIGHT() )
         ScrollBarButtonHandle := InitVScrollBarButton ( ::Parent:hWnd, nCol2, y + h - GETHSCROLLBARHEIGHT() , GETVSCROLLBARWIDTH() , GETHSCROLLBARHEIGHT() )
         ::nButtonActive := 1
		Else
         ScrollBarHandle := InitVScrollBar ( ::Parent:hWnd, nCol2, y , GETVSCROLLBARWIDTH() , h )
         ScrollBarButtonHandle := InitVScrollBarButton ( ::Parent:hWnd, nCol2, y + h - GETHSCROLLBARHEIGHT() , 0 , 0 )
         ::nButtonActive := 0
		EndIf

      ::VScroll := TScrollBar():SetContainer( Self, "" )
      ::VScroll:New( ScrollBarHandle,, HelpId,, ToolTip, ScrollBarHandle )
      ::VScroll:RangeMin := 1
      ::VScroll:RangeMax := 100
      ::VScroll:OnLineUp   := { || ::SetFocus(), ::Up() }
      ::VScroll:OnLineDown := { || ::SetFocus(), ::Down() }
      ::VScroll:OnPageUp   := { || ::SetFocus(), ::PageUp() }
      ::VScroll:OnPageDown := { || ::SetFocus(), ::PageDown() }
      ::VScroll:OnThumb    := { |VScroll,Pos| empty( VScroll ), ::SetFocus(), ::SetScrollPos( Pos ) }
// cambiar TOOLTIP si cambia el del BROWSE
// Cambiar HelpID si cambia el del BROWSE

	EndIf

	// Add to browselist array to update on window activation

   aAdd ( ::Parent:BrowseList, Self )

   // Add Vertical scrollbar button

   ::AuxHandle := ScrollBarButtonHandle

   ::SizePos()

   // Must be set after control is initialized
   ::OnLostFocus := lostfocus
   ::OnGotFocus :=  gotfocus
   ::OnChange   :=  change
   ::OnDblClick := dblclick

Return Self

*-----------------------------------------------------------------------------*
METHOD UpDate() CLASS TBrowse
*-----------------------------------------------------------------------------*
Local PageLength , aTemp := {} , uTemp , _BrowseRecMap := {} , x , j
Local cType, nCurrentLength
Local lColor, aFields, cWorkArea, hWnd, nWidth
MEMVAR __aPicture
PRIVATE __aPicture

   cWorkArea := ::WorkArea

   If Select( cWorkArea ) == 0
      ::RecCount := 0
      Return nil
   EndIf

   lColor := ! ( Empty( ::DynamicForeColor ) .AND. Empty( ::DynamicBackColor ) )
   __aPicture := ::Picture
   nWidth := LEN( ::aFields )
   aFields := ARRAY( nWidth )
   AEVAL( ::aFields, { |c,i| aFields[ i ] := &( "{ || " + ;
                     if( valtype( __aPicture[ i ] ) $ "CM", "TRANSFORM( ", "" ) + ;
                     cWorkArea + "->( " + c + " )" + ;
                     if( valtype( __aPicture[ i ] ) $ "CM", ", __aPicture[ " + LTRIM( STR( i ) ) + " ] )", "" ) + ;
                     " }" ) } )
   hWnd := ::hWnd

   ::lEof := .F.

   PageLength := ListViewGetCountPerPage( hWnd )

   If lColor
      ::GridForeColor := ARRAY( PageLength )
      ::GridBackColor := ARRAY( PageLength )
   Else
      ::GridForeColor := nil
      ::GridBackColor := nil
   EndIf

   x := 1
   nCurrentLength := ::ItemCount()

   Do While x <= PageLength .AND. ! ( cWorkArea )->( Eof() )

      aTemp := ARRAY( nWidth )
      AFILL( aTemp, NIL )

      For j := 1 To nWidth
         uTemp := EVAL( aFields[ j ] )
         cType := ValType( uTemp )

         If     cType == 'C'
            aTemp[ j ] := rTrim( uTemp )
         ElseIf cType == 'N'
            If VALTYPE( __aPicture[ j ] ) == "L" .AND. __aPicture[ j ]
               aTemp[ j ] := uTemp
            Else
               aTemp[ j ] := lTrim( Str( uTemp ) )
            Endif
         ElseIf cType == 'L'
            If VALTYPE( __aPicture[ j ] ) == "L" .AND. __aPicture[ j ]
               aTemp[ j ] := iif( uTemp, 1, 0 )
            Else
               aTemp[ j ] := IIF( uTemp, '.T.', '.F.' )
            Endif
         ElseIf cType == 'D'
            aTemp[ j ] := Dtoc( uTemp )
         ElseIf cType == 'M'
            aTemp[ j ] := '<Memo>'
         ElseIf cType == 'A'
            If VALTYPE( __aPicture[ j ] ) == "L" .AND. __aPicture[ j ]
               aTemp[ j ] := uTemp
            Else
               aTemp[ j ] := "<Array>"
            Endif
         Else
            aTemp[ j ] := 'Nil'
         EndIf
      Next j

      If lColor
         ( cWorkArea )->( ::SetItemColor( x,,, aTemp ) )
      EndIf

      IF nCurrentLength < x
         AddListViewItems( hWnd, aTemp )
         nCurrentLength++
      Else
         ListViewSetItem( hWnd, aTemp, x )
      ENDIF

      aadd( _BrowseRecMap , ( cWorkArea )->( RecNo() ) )

      ( cWorkArea )->( DbSkip() )
      x++
   EndDo

   Do While nCurrentLength > Len( _BrowseRecMap )
      ListViewDeleteString( hWnd, nCurrentLength )
      nCurrentLength--
   EndDo

   IF ( cWorkArea )->( Eof() )
      ::lEof := .T.
   EndIf

   ::aRecMap := _BrowseRecMap

Return nil

*-----------------------------------------------------------------------------*
METHOD PageDown() CLASS TBrowse
*-----------------------------------------------------------------------------*
Local PageLength , _RecNo , _DeltaScroll := { Nil , Nil , Nil , Nil } , s

   _DeltaScroll := ListView_GetSubItemRect ( ::hWnd, 0 , 0 )

   PageLength := LISTVIEWGETCOUNTPERPAGE ( ::hWnd )

   s := LISTVIEW_GETFIRSTITEM ( ::hWnd )

	If  s == PageLength

      If Select( ::WorkArea ) == 0
         ::RecCount := 0
         Return nil
		EndIf

      if ::lEof
         If ::AllowAppend
            ::EditItem( .t. )
         Endif
         Return nil
      EndIf

      _RecNo := ( ::WorkArea )->( RecNo() )

      ( ::WorkArea )->( DbGoTo( ::aRecMap[ Len( ::aRecMap ) ] ) )
      ::Update()
      ( ::WorkArea )->( DbGoTo( ::aRecMap[ Len( ::aRecMap ) ] ) )
      ::scrollUpdate()
      ListView_Scroll( ::hWnd, _DeltaScroll[2] * (-1) , 0 )
      ListView_SetCursel ( ::hWnd, Len( ::aRecMap ) )
      ( ::WorkArea )->( DbGoTo( _RecNo ) )

	Else

      ListView_SetCursel ( ::hWnd, Len( ::aRecMap ) )
      ::FastUpdate( PageLength - s )

	EndIf

   ::BrowseOnChange()

Return nil

*-----------------------------------------------------------------------------*
METHOD PageUp() CLASS TBrowse
*-----------------------------------------------------------------------------*
Local _RecNo , _DeltaScroll := { Nil , Nil , Nil , Nil }

   _DeltaScroll := ListView_GetSubItemRect ( ::hWnd, 0 , 0 )

   If LISTVIEW_GETFIRSTITEM ( ::hWnd ) == 1
      If Select( ::WorkArea ) == 0
         ::RecCount := 0
         Return nil
		EndIf
      _RecNo := ( ::WorkArea )->( RecNo() )
      ( ::WorkArea )->( DbGoTo( ::aRecMap[ 1 ] ) )
      ( ::WorkArea )->( DbSkip( - LISTVIEWGETCOUNTPERPAGE ( ::hWnd ) + 1 ) )
      ::scrollUpdate()
      ::Update()
      ListView_Scroll( ::hWnd, _DeltaScroll[2] * (-1) , 0 )
      ( ::WorkArea )->( DbGoTo( _RecNo ) )

	Else

      ::FastUpdate( 1 - LISTVIEW_GETFIRSTITEM ( ::hWnd ) )

	EndIf

   ListView_SetCursel ( ::hWnd, 1 )

   ::BrowseOnChange()

Return nil

*-----------------------------------------------------------------------------*
METHOD Home() CLASS TBrowse
*-----------------------------------------------------------------------------*
Local _RecNo , _DeltaScroll := { Nil , Nil , Nil , Nil }

   _DeltaScroll := ListView_GetSubItemRect ( ::hWnd, 0 , 0 )

   If Select( ::WorkArea ) == 0
      ::RecCount := 0
      Return nil
	EndIf
   _RecNo := ( ::WorkArea )->( RecNo() )
   ( ::WorkArea )->( DbGoTop() )
   ::scrollUpdate()
   ::Update()
   ListView_Scroll( ::hWnd, _DeltaScroll[2] * (-1) , 0 )
   ( ::WorkArea )->( DbGoTo( _RecNo ) )

   ListView_SetCursel ( ::hWnd, 1 )

   ::BrowseOnChange()

Return nil

*-----------------------------------------------------------------------------*
METHOD End() CLASS TBrowse
*-----------------------------------------------------------------------------*
Local _RecNo , _DeltaScroll , _BottomRec

   _DeltaScroll := ListView_GetSubItemRect ( ::hWnd, 0 , 0 )

   If Select( ::WorkArea ) == 0
      ::RecCount := 0
      Return nil
	EndIf
   _RecNo := ( ::WorkArea )->( RecNo() )
   ( ::WorkArea )->( DbGoBottom() )
   _BottomRec := ( ::WorkArea )->( RecNo() )
   ::scrollUpdate()

   ( ::WorkArea )->( DbSkip( - LISTVIEWGETCOUNTPERPAGE ( ::hWnd ) + 1 ) )
   ::Update()
   ListView_Scroll( ::hWnd, _DeltaScroll[2] * (-1) , 0 )
   ( ::WorkArea )->( DbGoTo( _RecNo ) )

   ListView_SetCursel( ::hWnd, ascan ( ::aRecMap, _BottomRec ) )

   ::BrowseOnChange()

Return nil

*-----------------------------------------------------------------------------*
METHOD Up() CLASS TBrowse
*-----------------------------------------------------------------------------*
Local s  , _RecNo , _DeltaScroll := { Nil , Nil , Nil , Nil }

   _DeltaScroll := ListView_GetSubItemRect ( ::hWnd, 0 , 0 )

   s := LISTVIEW_GETFIRSTITEM ( ::hWnd )

	If s == 1
      If Select( ::WorkArea ) == 0
         ::RecCount := 0
         Return nil
      EndIf
      _RecNo := ( ::WorkArea )->( RecNo() )
      ( ::WorkArea )->( DbGoTo( ::aRecMap[ 1 ] ) )
      ( ::WorkArea )->( DbSkip( -1 ) )
      ::scrollUpdate()
      ::Update()
      ListView_Scroll( ::hWnd, _DeltaScroll[2] * (-1) , 0 )
      ( ::WorkArea )->( DbGoTo( _RecNo ) )
      ListView_SetCursel ( ::hWnd, 1 )

	Else
      ListView_SetCursel ( ::hWnd, s - 1 )
      ::FastUpdate( -1 )
	EndIf

   ::BrowseOnChange()

Return nil

*-----------------------------------------------------------------------------*
METHOD Down() CLASS TBrowse
*-----------------------------------------------------------------------------*
Local PageLength , s , _RecNo , _DeltaScroll

   s := LISTVIEW_GETFIRSTITEM( ::hWnd )

   PageLength := LISTVIEWGETCOUNTPERPAGE( ::hWnd )

	If s == PageLength

      _DeltaScroll := ListView_GetSubItemRect( ::hWnd, 0 , 0 )

      If Select( ::WorkArea ) == 0
         ::RecCount := 0
         Return nil
      EndIf

      if ::lEof
         If ::AllowAppend
            ::EditItem( .t. )
         Endif
         Return nil
      EndIf

      _RecNo := ( ::WorkArea )->( RecNo() )

      ( ::WorkArea )->( DbGoTo( ::aRecMap[ 1 ] ) )
      ( ::WorkArea )->( DbSkip() )
      ::scrollUpdate()
      ::Update()
      ListView_Scroll( ::hWnd, _DeltaScroll[2] * (-1) , 0 )
      ( ::WorkArea )->( DbGoTo( _RecNo ) )

      ListView_SetCursel ( ::hWnd, Len( ::aRecMap ) )

	Else

      ListView_SetCursel ( ::hWnd, s+1 )
      ::FastUpdate( 1 )

	EndIf

   ::BrowseOnChange()

Return nil

*-----------------------------------------------------------------------------*
METHOD SetValue( Value, mp ) CLASS TBrowse
*-----------------------------------------------------------------------------*
Local _RecNo , _BrowseRecMap , NewPos := 50, _DeltaScroll := { Nil , Nil , Nil , Nil } , m
// Local cMacroVar

	If Value <= 0
      Return nil
	EndIf

   If _OOHG_ThisEventType == 'BROWSE_ONCHANGE'
      If ::hWnd == _OOHG_ThisControl:hWnd
         MsgOOHGError ("BROWSE: Value property can't be changed inside ONCHANGE event. Program Terminated" )
		EndIf
	EndIf

   If Select( ::WorkArea ) == 0
      ::RecCount := 0
      Return nil
	EndIf

   If Value > ( ::WorkArea )->( RecCount() )
      ::nValue := 0
      ListViewReset ( ::hWnd )
      ::BrowseOnChange()
      Return nil
	EndIf

	If valtype ( mp ) == 'U'
      m := int ( ListViewGetCountPerPage ( ::hWnd ) / 2 )
	else
		m := mp
	endif

   _DeltaScroll := ListView_GetSubItemRect ( ::hWnd, 0 , 0 )
   _BrowseRecMap := ::aRecMap

   _RecNo := ( ::WorkArea )->( RecNo() )

   ( ::WorkArea )->( DbGoTo( Value ) )

   If ( ::WorkArea )->( Eof() )
      ( ::WorkArea )->( DbGoTo( _RecNo ) )
      Return nil
	EndIf

// Sin usar DBFILTER()
   ( ::WorkArea )->( DBSkip() )
   ( ::WorkArea )->( DBSkip( -1 ) )
   IF ( ::WorkArea )->( RecNo() ) != Value
      ( ::WorkArea )->( DbGoTo( _RecNo ) )
      Return nil
   ENDIF
/*
// Usando DBFILTER()
   cMacroVar := ( ::WorkArea )->( dbfilter() )
   If ! Empty( cMacroVar )
      If ! ( ::WorkArea )->( &cMacroVar )
         ( ::WorkArea )->( DbGoTo( _RecNo ) )
         Return nil
		EndIf
	EndIf
*/

   if pcount() < 2
      ::scrollUpdate()
   EndIf
   ( ::WorkArea )->( DbSkip( -m + 1 ) )

   ::nValue := Value
   ( ::WorkArea )->( ::Update() )
   ( ::WorkArea )->( DbGoTo( _RecNo ) )

   ListView_Scroll( ::hWnd, _DeltaScroll[2] * (-1) , 0 )
   ListView_SetCursel ( ::hWnd, ascan ( ::aRecMap, Value ) )

   _OOHG_ThisEventType := 'BROWSE_ONCHANGE'
   ::BrowseOnChange()
   _OOHG_ThisEventType := ''

Return nil

*-----------------------------------------------------------------------------*
METHOD Delete() CLASS TBrowse
*-----------------------------------------------------------------------------*
Local _BrowseRecMap , Value , _Alias , _RecNo , _BrowseArea

   If LISTVIEW_GETFIRSTITEM ( ::hWnd ) == 0
		Return Nil
	EndIf

   _BrowseRecMap := ::aRecMap

   Value := _BrowseRecMap [ LISTVIEW_GETFIRSTITEM ( ::hWnd ) ]

	If Value == 0
		Return Nil
	EndIf

	_Alias := Alias()
   _BrowseArea := ::WorkArea
   If Select( ::WorkArea ) == 0
      ::RecCount := 0
		Return Nil
	EndIf
   DbSelectArea( _BrowseArea )
	_RecNo := RecNo()

	Go Value

   If ::Lock
		If Rlock()
			Delete
			Skip
			if eof()
				Go Bottom
			EndIf

         If Set ( _SET_DELETED )
            ::SetValue( RecNo() , LISTVIEW_GETFIRSTITEM ( ::hWnd ) )
			EndIf

		Else

			MsgStop('Record is being editied by another user. Retry later','Delete Record')

		EndIf

	Else

		Delete
		Skip
		if eof()
			Go Bottom
		EndIf
      If Set ( _SET_DELETED )
         ::SetValue( RecNo() , LISTVIEW_GETFIRSTITEM ( ::hWnd ) )
		EndIf

	EndIf

	Go _RecNo
	if Select( _Alias ) != 0
      DbSelectArea( _Alias )
	Else
      DbSelectArea( 0 )
	Endif

Return Nil

*-----------------------------------------------------------------------------*
METHOD EditItem( append ) CLASS TBrowse
*-----------------------------------------------------------------------------*
Local g,a,l,actpos:={0,0,0,0},GRow,GCol,GWidth,Col,IRow, item
Local Title , aLabels , aInitValues := {} , aFormats := {} , aResults , z , tvar , BackRec , aStru , y , svar , q , BackArea , BrowseArea , TmpNames := {} , NewRec := 0 , MixedFields := .f.

   If LISTVIEW_GETFIRSTITEM ( ::hWnd ) == 0
      If Valtype (append) == 'L'
         If ! append
				Return Nil
			EndIf
		EndIf
	EndIf

   If ::InPlace
      ::InPlaceEdit( append )
		Return Nil
	EndIf

   a := ::aHeaders

   item := ::Value

	l := Len(a)

   g := ::Item( Item )

   IRow := ListViewGetItemRow( ::hWnd, LISTVIEW_GETFIRSTITEM( ::hWnd ) )

   GetWindowRect( ::hWnd, actpos )

	GRow 	:= actpos [2]
	GCol 	:= actpos [1]
	GWidth 	:= actpos [3] - actpos [1]

	Col := GCol + ( ( GWidth - 310 ) / 2 )

   If Valtype (append) == 'L'
      If append
         Title := _OOHG_BRWLangButton[1]
		Else
         Title := _OOHG_BRWLangButton[2]
		EndIf
	ELse
      Title := _OOHG_BRWLangButton[2]
	EndIf

   aLabels  := ::aHeaders

   BrowseArea := ::WorkArea

   BackRec := ( ::WorkArea )->( RecNo() )

   If Valtype (append) == 'L'
      If append
         ( ::WorkArea )->( DbGoTo( 0 ) )
		Else
         ( ::WorkArea )->( DbGoTo( item ) )
		EndIf
   Else
      ( ::WorkArea )->( DbGoTo( item ) )
	EndIf

   For z := 1 To Len ( ::aFields )

      tvar := ( ::WorkArea )->( &( ::aFields[ z ] ) )

      if valtype( tvar ) $ 'CM'
         Aadd ( aInitValues , Alltrim(tvar) )
		Else
         Aadd ( aInitValues , tvar )
		EndIf

      tvar := Upper ( ::aFields [z] )
		q := at ( '>' , tvar )
		if q == 0
         aStru := ( BrowseArea )->( DbStruct() )
			aAdd ( TmpNames , 'MemVar' + BrowseArea + tvar )
		Else
         svar := Left( tvar , q - 2 )
         aStru := ( svar )->( DbStruct() )
         tvar := SubStr( tvar , q + 1 )
			aAdd ( TmpNames , 'MemVar' + svar + tvar )
         If Upper( svar ) != Upper( BrowseArea )
				MixedFields := .t.
			EndIf
		EndIf
      If Valtype (append) == 'L'
         If append
            If MixedFields
               MsgOOHGError(_OOHG_BRWLangError[8],_OOHG_BRWLangError[3])
				EndIf
			EndIf
		EndIf

      y := ASCAN( aStru, { |a| Upper( a[ 1 ] ) == tvar } )
      If y == 0   // Field not found!!!
         Aadd ( aFormats , Nil )
      ElseIf aStru [y] [2] == 'N' .And. aStru [y] [4] == 0
         Aadd ( aFormats , Replicate('9', aStru [y] [3] ) )
      ElseIf aStru [y] [2] == 'N' .And. aStru [y] [4] > 0
         Aadd ( aFormats , Replicate('9', (aStru [y] [3] - aStru [y] [4] - 1) ) +'.'+Replicate('9', aStru [y] [4]) )
      ElseIf aStru [y] [2] == 'C'
         Aadd ( aFormats , aStru [y] [3] )
      ElseIf aStru [y] [2] == 'D'
         Aadd ( aFormats , Nil )
      ElseIf aStru [y] [2] == 'L'
         Aadd ( aFormats , Nil )
      ElseIf aStru [y] [2] == 'M'
         Aadd ( aFormats , "M" )
      Else   // Unknow type!!!   Must be fixed for "extended" types (VFP types)
         Aadd ( aFormats , Nil )
      EndIf

	Next z

   If ::lock
      If ! ( ::WorkArea )->( Rlock() )
         MsgExclamation(_OOHG_BRWLangError[9],_OOHG_BRWLangError[10])
         ( ::WorkArea )->( DbGoTo( BackRec ) )
         ::SetFocus()
			Return Nil
		EndIf
	EndIf

	BackArea := Alias()
   DbSelectArea( BrowseArea )

   aResults := _EditRecord( Title , aLabels , aInitValues , aFormats , GRow , Col , ::Valid , TmpNames , ::ValidMessages , ::ReadOnly , actpos [4] - actpos [2] )
	tvar := aResults [1]
	If ValType ( tvar ) != 'U'

      If Valtype (append) == 'L'
         If append
            ( ::WorkArea )->( DBAppend() )
            NewRec := ( ::WorkArea )->( RecNo() )
			EndIf
		EndIf

		For z := 1 To Len ( aResults )

         tvar := ::aFields [z]

         If ValType (::ReadOnly) == 'U'

				Replace &tvar With aResults [z]

			Else

            If ::ReadOnly [z] == .F.

					Replace &tvar With aResults [z]

				EndIf

			EndIf

		Next z

      ::Refresh()

	EndIf

   If ::lock
      ( ::WorkArea )->( DbUnlock() )
	EndIf

   ( ::WorkArea )->( DbGoTo( BackRec ) )

   If Select( BackArea ) != 0
      DbSelectArea( BackArea )
	Else
      DbSelectArea( 0 )
	EndIf

   ::SetFocus()

   If Valtype (append) == 'L'
      If append
			If NewRec != 0
            ::Value := NewRec
			EndIf
		EndIf
	EndIf

Return Nil

*-----------------------------------------------------------------------------*
Function _EditRecord( Title , aLabels , aValues , aFormats , row , col , aValid , TmpNames , aValidMessages , aReadOnly , h , aWhen )
*-----------------------------------------------------------------------------*
Local i , l , ControlRow , e := 0 ,LN , CN , th, oWnd, oControl, aControls

	l := Len ( aLabels )

   Private aResult := ARRAY( l )

   aControls := ARRAY( l )

	For i := 1 to l

      if ValType ( aValues[i] ) $ 'CM'

			if ValType ( aFormats[i] ) == 'N'

				If aFormats[i] > 32
					e++
				Endif

         ElseIf ValType ( aFormats[i] ) == 'C' .AND. aFormats[i] == "M"

            e++

			EndIf

		EndIf

	Next i

	th := (l*30) + (e*60) + 30

	IF TH < H
		TH := H + 1
	ENDIF

   DEFINE WINDOW _EditRecord;
		AT row,col ;
		WIDTH 310 ;
		HEIGHT h - 19 + GetTitleHeight() ;
		TITLE Title ;
      MODAL NOSIZE ;
      ON INIT oWnd:Control_1:SetFocus() ;

      ON KEY ALT+O ACTION _EditRecordOk( aValid , TmpNames , aValidMessages )
      ON KEY ALT+C ACTION _EditRecordCancel()

		DEFINE SPLITBOX

         DEFINE WINDOW _Split_1 OBJ oWnd;
				WIDTH 310 ;
				HEIGHT H - 90 ;
				VIRTUAL HEIGHT TH ;
				SPLITCHILD NOCAPTION FONT 'Arial' SIZE 10 BREAK FOCUSED

            ON KEY ALT+O ACTION _EditRecordOk( aValid , TmpNames , aValidMessages )
            ON KEY ALT+C ACTION _EditRecordCancel()

				ControlRow :=  10

				For i := 1 to l

					LN := 'Label_' + Alltrim(Str(i))
					CN := 'Control_' + Alltrim(Str(i))

					@ ControlRow , 10 LABEL &LN OF _Split_1 VALUE aLabels [i] WIDTH 90

					do case
					case ValType ( aValues [i] ) == 'L'

						@ ControlRow , 120 CHECKBOX &CN OF _Split_1 CAPTION '' VALUE aValues[i]
						ControlRow := ControlRow + 30

					case ValType ( aValues [i] ) == 'D'

                  @ ControlRow , 120 TEXTBOX &CN  OF _Split_1 VALUE aValues[i] WIDTH 140 DATE
						ControlRow := ControlRow + 30

					case ValType ( aValues [i] ) == 'N'

						If ValType ( aFormats [i] ) == 'A'
							@ ControlRow , 120 COMBOBOX &CN  OF _Split_1 ITEMS aFormats[i] VALUE aValues[i] WIDTH 140  FONT 'Arial' SIZE 10
							ControlRow := ControlRow + 30

                  ElseIf  ValType ( aFormats [i] ) $ 'CM'

							If AT ( '.' , aFormats [i] ) > 0
								@ ControlRow , 120 TEXTBOX &CN  OF _Split_1 VALUE aValues[i] WIDTH 140 FONT 'Arial' SIZE 10 NUMERIC INPUTMASK aFormats [i]
							Else
								@ ControlRow , 120 TEXTBOX &CN  OF _Split_1 VALUE aValues[i] WIDTH 140 FONT 'Arial' SIZE 10 MAXLENGTH Len(aFormats [i]) NUMERIC
							EndIf

							ControlRow := ControlRow + 30
						Endif

					case ValType ( aValues [i] ) == 'C'

						If ValType ( aFormats [i] ) == 'N'
							If  aFormats [i] <= 32
								@ ControlRow , 120 TEXTBOX &CN  OF _Split_1 VALUE aValues[i] WIDTH 140 FONT 'Arial' SIZE 10 MAXLENGTH aFormats [i]
								ControlRow := ControlRow + 30
							Else
								@ ControlRow , 120 EDITBOX &CN  OF _Split_1 WIDTH 140 HEIGHT 90 VALUE aValues[i] FONT 'Arial' SIZE 10 MAXLENGTH aFormats[i]
								ControlRow := ControlRow + 94
							EndIf
                  ElseIf ValType ( aFormats [i] ) == 'C' .AND. aFormats [i] == "M"
                     @ ControlRow , 120 EDITBOX &CN  OF _Split_1 WIDTH 140 HEIGHT 90 VALUE aValues[i] FONT 'Arial' SIZE 10 MAXLENGTH aFormats[i]
                     ControlRow := ControlRow + 94
						EndIf

					case ValType ( aValues [i] ) == 'M'

						@ ControlRow , 120 EDITBOX &CN  OF _Split_1 WIDTH 140 HEIGHT 90 VALUE aValues[i] FONT 'Arial' SIZE 10
						ControlRow := ControlRow + 94

					endcase

               oControl := oWnd:Control( CN )
               oControl:OnLostFocus := { || _WHENEVAL( aControls ) }
               oControl:Block := &( "{ |x| IF( PCOUNT() == 1, " + TmpNames[ i ] + " :=  x, " + TmpNames[ i ] + " ) }" )
               IF ValType( aWhen ) == "A" .AND. Len( aWhen ) >= i
                  oControl:Cargo := aWhen[ i ]
               ENDIF
               aControls[ i ] := oControl

               If ValType ( aReadOnly ) == 'A'

                  If aReadOnly[ i ]

                       oWnd:Control( CN ):Disabled()

						EndIf

					EndIf

				Next i

			END WINDOW

			DEFINE WINDOW _Split_2 ;
				WIDTH 300 ;
				HEIGHT 50 ;
				SPLITCHILD NOCAPTION FONT 'Arial' SIZE 10 BREAK

				@ 10 , 40 BUTTON BUTTON_1 ;
				OF _Split_2 ;
            CAPTION _OOHG_BRWLangButton[4] ;
            ACTION _EditRecordOk( aValid , TmpNames , aValidMessages )

				@ 10 , 150 BUTTON BUTTON_2 ;
				OF _Split_2 ;
            CAPTION _OOHG_BRWLangButton[3] ;
				ACTION _EditRecordCancel()

			END WINDOW

		END SPLITBOX

	END WINDOW

	ACTIVATE WINDOW _EditRecord

Return ( aResult )

*-----------------------------------------------------------------------------*
PROCEDURE _WHENEVAL( aControls )
*-----------------------------------------------------------------------------*

   AEVAL( aControls, { |o| o:SaveData() } )

   AEVAL( aControls, { |o| IF( VALTYPE( o:Cargo ) == "B", o:Enabled := EVAL( o:Cargo ),  ) } )

RETURN

*-----------------------------------------------------------------------------*
Function _EditRecordOk( aValid , TmpNames , aValidMessages )
*-----------------------------------------------------------------------------*
Local i , ControlName , l , b , mVar

	l := len (aResult)

	For i := 1 to l

		ControlName := 'Control_' + Alltrim ( Str ( i ) )
		aResult [i] := _GetValue ( ControlName , '_Split_1' )

		If ValType (aValid) != 'U'

			mVar := TmpNames [i]
			&mVar := aResult [i]

		EndIf

	Next i

   If ValType (aValid) == 'A'

		For i := 1 to l

         b := _OOHG_Eval( aValid[ i ] )

         If ValType ( b ) == 'L'

            If ! b

				        If ValType ( aValidMessages ) != 'U'

						If ValType ( aValidMessages [i] ) != 'U'

							MsgExclamation ( aValidMessages[i] )

						Else

                     MsgExclamation (_OOHG_BRWLangError[11])

						EndIf

					Else

                  MsgExclamation (_OOHG_BRWLangError[11])

					EndIf


               GetControlObject( 'Control_' + Alltrim(Str(i)) , '_Split_1' ):SetFocus()

					Return Nil

				EndIf

			EndIf

		Next i

	EndIf

	RELEASE WINDOW _EditRecord

Return Nil

*-----------------------------------------------------------------------------*
Function _EditRecordCancel
*-----------------------------------------------------------------------------*
Local i , l

	l := len (aResult)

	For i := 1 to l

		aResult [i] := Nil

	Next i

	RELEASE WINDOW _EditRecord

Return Nil

*------------------------------------------------------------------------------*
METHOD InPlaceEdit( append ) CLASS TBrowse
*------------------------------------------------------------------------------*
Local GridCol , GridRow , nrec , BackArea , BackRec , _GridFields , FieldName , CellData  := '' , CellColIndex , x
Local aFieldNames
Local aTypes
Local aWidths
Local aDecimals
Local Type
Local Width
Local Decimals
Local sFieldname
Local r
Local ControlType
Local Ldelta := 0

	If append

      ::InPlaceAppend()

		Return Nil

	EndIf

   If This.CellRowIndex != LISTVIEW_GETFIRSTITEM( ::hWnd )
		Return Nil
	EndIf

   _GridFields := ::aFields

	CellColIndex := This.CellColIndex

	If CellColIndex < 1 .or. CellColIndex > Len (_GridFields)
		Return Nil
	EndIf

   If VALTYPE( ::Picture[ CellColIndex ] ) == "L" .AND. ::Picture[ CellColIndex ]
		PlayHand()
		Return Nil
	EndIf

   If ValType ( ::ReadOnly ) == 'A'
      If Len ( ::ReadOnly ) >= CellColIndex
         If ::ReadOnly [ CellColIndex ] != Nil
            If ::ReadOnly [ CellColIndex ] == .T.
*					PlayHand()
               _OOHG_IPE_CANCELLED := .F.
*
					Return Nil
				EndIf
			EndIf
		EndIf
	EndIf

	FieldName := _GridFields [  CellColIndex ]

	// It the specified area does not exists, set recorcount to 0 and
	// return

   If Select( ::WorkArea ) == 0
      ::RecCount := 0
		Return Nil
	EndIf

	// Save Original WorkArea
	BackArea := Alias()

	// Save Original Record Pointer
	BackRec := RecNo()

	// Selects Grid's WorkArea

   DbSelectArea( ::WorkArea )

   nRec := ::Value
	Go nRec

	// If LOCK clause is present, try to lock.

   If ::lock == .T.
		If Rlock() == .F.
         MsgExclamation(_OOHG_BRWLangError[9],_OOHG_BRWLangError[10])
			// Restore Original Record Pointer
			Go BackRec
			// Restore Original WorkArea
         If Select( BackArea ) != 0
            DbSelectArea( BackArea )
			Else
            DbSelectArea( 0 )
			EndIf
			Return Nil
		EndIf
	EndIf

	CellData := &FieldName

        aFieldNames	:= ARRAY(FCOUNT())
        aTypes		:= ARRAY(FCOUNT())
        aWidths		:= ARRAY(FCOUNT())
        aDecimals	:= ARRAY(FCOUNT())

        AFIELDS(aFieldNames, aTypes, aWidths, aDecimals)

	r := at ('>',FieldName)

	if r != 0
		sFieldName := Right ( FieldName, Len(Fieldname) - r )
	Else
		sFieldName := FieldName
	EndIf

	x := FieldPos ( sFieldName )

	If x > 0
        	Type		:= aTypes [x]
	        Width		:= aWidths [x]
        	Decimals	:= aDecimals [x]
	EndIf

   GridRow := GetWindowRow( ::hWnd )
   GridCol := GetWindowCol( ::hWnd )

	If Type (FieldName) == 'C'
		ControlType := 'C'
	ElseIf Type (FieldName) == 'D'
		ControlType := 'D'
	ElseIf Type (FieldName) == 'L'
		ControlType := 'L'
		Ldelta := 1
	ElseIf Type (FieldName) == 'M'
		ControlType := 'M'
	ElseIf Type (FieldName) == 'N'
		If Decimals == 0
			ControlType := 'I'
		Else
			ControlType := 'F'
		EndIf
	EndIf

	If ControlType == 'M'

// JK
		r := InputBox ( '' , 'Edit Memo' , STRTRAN(CellData,chr(141),' ') , , , .T. )

      If _OOHG_DialogCancelled == .F.
			Replace &FieldName With r
         _OOHG_IPE_CANCELLED := .F.
		Else
         _OOHG_IPE_CANCELLED := .T.
		EndIf

	Else

		DEFINE WINDOW _InPlaceEdit ;
         AT This.CellRow + GridRow - ::ContainerRow - 1 , This.CellCol + GridCol - ::ContainerCol + 2 ;
			WIDTH This.CellWidth ;
			HEIGHT This.CellHeight + 6 + Ldelta ;
			MODAL ;
			NOCAPTION ;
			NOSIZE

         ON KEY RETURN ACTION TBrowse_InPlaceEditOk( Self, Fieldname , _InPlaceEdit.Control_1.Value , ControlType , CellColIndex , sFieldName )
         ON KEY ESCAPE ACTION ( _OOHG_IPE_CANCELLED := .T. , dbrunlock() , _InPlaceEdit.Release , ::setfocus() )

			If ControlType == 'C'
				CellData := rtrim ( CellData )

				DEFINE TEXTBOX Control_1
					ROW 0
					COL 0
					WIDTH This.CellWidth
					HEIGHT This.CellHeight + 6
					VALUE CellData
					MAXLENGTH Width
				END TEXTBOX

			ElseIf ControlType == 'D'

            DEFINE TEXTBOX Control_1         // DEFINE DATEPICKER Control_1
					ROW 0
					COL 0
					HEIGHT This.CellHeight + 6
					WIDTH This.CellWidth
					VALUE CellData
               DATE .T.                      // UPDOWN .T.
            END TEXTBOX                      // END DATEPICKER

			ElseIf ControlType == 'L'

				DEFINE COMBOBOX Control_1
					ROW 0
					COL 0
					ITEMS { '.T.','.F.' }
					WIDTH This.CellWidth
					VALUE If ( CellData , 1 , 2 )
				END COMBOBOX

			ElseIf ControlType == 'I'

				DEFINE TEXTBOX Control_1
					ROW 0
					COL 0
					NUMERIC	.T.
					WIDTH This.CellWidth
					HEIGHT This.CellHeight + 6
					VALUE CellData
					MAXLENGTH Width
				END TEXTBOX

			ElseIf ControlType == 'F'

				DEFINE TEXTBOX Control_1
					ROW 0
					COL 0
					NUMERIC	.T.
					INPUTMASK Replicate ( '9', Width - Decimals - 1 ) + '.' + Replicate ( '9', Decimals )
					WIDTH This.CellWidth
					HEIGHT This.CellHeight + 6
					VALUE CellData
				END TEXTBOX

			EndIf

		END WINDOW

		ACTIVATE WINDOW _InPlaceEdit

	EndIf

	// Restore Original Record Pointer
	Go BackRec

	// Restore Original WorkArea
   If Select( BackArea ) != 0
      DbSelectArea( BackArea )
	Else
      DbSelectArea( 0 )
	EndIf

Return Nil

STATIC Function TBrowse_InPlaceEditOk( Self, Fieldname , r , ControlType , CellColIndex , sFieldName )
Local b , Result , mVar , TmpName

   If ValType ( ::Valid ) == 'A'
      If Len ( ::Valid ) >= CellColIndex
         If ::Valid [ CellColIndex ] != Nil

				Result := _GetValue ( 'Control_1' , '_InPlaceEdit' )

				If ControlType == 'L'
					Result := if ( Result == 0 .or. Result == 2 , .F. , .T. )
				EndIf

            TmpName := 'MemVar' + ::WorkArea + sFieldname

				mVar := TmpName
				&mVar := Result

            b := _OOHG_Eval ( ::Valid [ CellColIndex ] )
				If b == .f.

               If ValType ( ::ValidMessages ) == 'A'

                  If Len ( ::ValidMessages ) >= CellColIndex

                     If ::ValidMessages [CellColIndex] != Nil

                        MsgExclamation ( ::ValidMessages [CellColIndex] )

							Else

                        MsgExclamation (_OOHG_BRWLangError[11])

							EndIf

						Else

                     MsgExclamation (_OOHG_BRWLangError[11])

						EndIf

					Else

                  MsgExclamation (_OOHG_BRWLangError[11])

					EndIf

				Else

					If ControlType == 'L'
						r := if ( r == 0 .or. r == 2 , .F. , .T. )
					EndIf

               If ::lock == .t.
						Replace &FieldName With r
						Unlock

                  ::Refresh()

						_InPlaceEdit.Release
					Else
						Replace &FieldName With r

                  ::Refresh()

						_InPlaceEdit.Release
					EndIf

				EndIf

			Else

				If ControlType == 'L'
					r := if ( r == 0 .or. r == 2 , .F. , .T. )
				EndIf

            If ::lock == .t.

					Replace &FieldName With r
					Unlock

               ::Refresh()

					_InPlaceEdit.Release

				Else

					Replace &FieldName With r

               ::Refresh()

					_InPlaceEdit.Release

				EndIf

			EndIf

		EndIf

	Else

		If ControlType == 'L'
			r := if ( r == 0 .or. r == 2 , .F. , .T. )
		EndIf

      If ::lock == .t.

			Replace &FieldName With r
			Unlock

         ::Refresh()

			_InPlaceEdit.Release

		Else

			Replace &FieldName With r

         ::Refresh()

			_InPlaceEdit.Release

		EndIf

	EndIf

   _OOHG_IPE_CANCELLED := .F.

   ::SetFocus()

Return NIL

*-----------------------------------------------------------------------------*
METHOD AdjustRightScroll() CLASS TBrowse
*-----------------------------------------------------------------------------*
Local hws, lRet, nButton, nCol
   lRet := .F.
   If ::VScroll != nil
      hws := _OOHG_GridArrayWidths( ::hWnd, ::aWidths )
      nButton := IF( ( hws > ::Width - GETVSCROLLBARWIDTH() - 4 ), 1, 0 )
      IF ::nButtonActive != nButton
         ::nButtonActive := nButton
*         ::Refresh()
         nCol := if( ::lRtl .AND. ! ::Parent:lRtl, 0, ::Width - GETVSCROLLBARWIDTH() )
         if nButton == 1
            ::VScroll:SizePos( 0, nCol, GETVSCROLLBARWIDTH() , ::Height - GETHSCROLLBARHEIGHT() )
            MoveWindow( ::AuxHandle, ::ContainerCol + nCol, ::ContainerRow + ::Height - GETHSCROLLBARHEIGHT() , GETVSCROLLBARWIDTH() , GETHSCROLLBARHEIGHT() , .t. )
         Else
            ::VScroll:SizePos( 0, nCol, GETVSCROLLBARWIDTH() , ::Height )
            MoveWindow( ::AuxHandle, ::ContainerCol + nCol, ::ContainerRow + ::Height - GETHSCROLLBARHEIGHT() , 0 , 0 , .t. )
         EndIf
*         ReDrawWindow( ::VScroll:hWnd )
*         ReDrawWindow( ::AuxHandle )
         lRet := .T.
      ENDIF
   EndIf
Return lRet

*-----------------------------------------------------------------------------*
METHOD ProcessInPlaceKbdEdit() CLASS TBrowse
*-----------------------------------------------------------------------------*
Local r
Local IPE_MAXCOL
Local TmpRow
Local xs,xd
Local _OOHG_IPE_COL := ASCAN( ::Picture, { |x| ValType( x ) != "L" .OR. ! x } )

   If ! ::InPlace .OR. _OOHG_IPE_COL == 0
      Return nil
	EndIf

   if LISTVIEW_GETFIRSTITEM ( ::hWnd ) == 0
      Return nil
	EndIf

   IPE_MAXCOL := Len ( ::aFields )

	Do While .T.

      TmpRow := LISTVIEW_GETFIRSTITEM ( ::hWnd )

      If TmpRow != _OOHG_IPE_ROW

         _OOHG_IPE_ROW := TmpRow

         _OOHG_IPE_COL := ASCAN( ::Picture, { |x| ValType( x ) != "L" .OR. ! x } )

		EndIf

      _OOHG_ThisItemRowIndex := _OOHG_IPE_ROW
      _OOHG_ThisItemColIndex := _OOHG_IPE_COL

      If _OOHG_IPE_COL == 1
         r := LISTVIEW_GETITEMRECT ( ::hWnd, _OOHG_IPE_ROW - 1 )
		Else
         r := LISTVIEW_GETSUBITEMRECT ( ::hWnd, _OOHG_IPE_ROW - 1 , _OOHG_IPE_COL - 1 )
		EndIf

      xs := ( ( ::ContainerCol + r [2] ) +( r[3] ))  -  ( ::ContainerCol + ::Width )

		xd := 20

		If xs > -xd
         ListView_Scroll( ::hWnd,  xs + xd , 0 )
		Else

         If r [2] < 0
            ListView_Scroll( ::hWnd, r[2] , 0 )
         EndIf

		endIf

      If _OOHG_IPE_COL == 1
         r := LISTVIEW_GETITEMRECT ( ::hWnd, _OOHG_IPE_ROW - 1 )
		Else
         r := LISTVIEW_GETSUBITEMRECT ( ::hWnd, _OOHG_IPE_ROW - 1 , _OOHG_IPE_COL - 1 )
		EndIf

      _OOHG_ThisItemCellRow := ::ContainerRow + r [1]
      _OOHG_ThisItemCellCol := ::ContainerCol + r [2]
      _OOHG_ThisItemCellWidth := r[3]
      _OOHG_ThisItemCellHeight := r[4]
      ::EditItem( .f. )
      _OOHG_ThisType := ''

      _OOHG_ThisItemRowIndex := 0
      _OOHG_ThisItemColIndex := 0
      _OOHG_ThisItemCellRow := 0
      _OOHG_ThisItemCellCol := 0
      _OOHG_ThisItemCellWidth := 0
      _OOHG_ThisItemCellHeight := 0

      If _OOHG_IPE_CANCELLED == .T.

         If _OOHG_IPE_COL == IPE_MAXCOL

            _OOHG_IPE_COL := ASCAN( ::Picture, { |x| ValType( x ) != "L" .OR. ! x } )

            ListView_Scroll( ::hWnd,  -10000  , 0 )
			EndIf

			Exit

		Else

         _OOHG_IPE_COL := ASCAN( ::Picture, { |x| ValType( x ) != "L" .OR. ! x }, _OOHG_IPE_COL + 1 )

         If _OOHG_IPE_COL > IPE_MAXCOL .OR. _OOHG_IPE_COL == 0

            _OOHG_IPE_COL := ASCAN( ::Picture, { |x| ValType( x ) != "L" .OR. ! x } )

            ListView_Scroll( ::hWnd,  -10000  , 0 )
				Exit
			EndIf

		EndIf

	EndDo

Return nil

*-----------------------------------------------------------------------------*
METHOD BrowseOnChange() CLASS TBrowse
*-----------------------------------------------------------------------------*
LOCAL cWorkArea

   If _OOHG_BrowseSyncStatus

      cWorkArea := ::WorkArea

      If Select( cWorkArea ) != 0 .AND. ( cWorkArea )->( RecNo() ) != ::Value

         ( cWorkArea )->( DbGoTo( ::Value ) )

		EndIf

	EndIf

   ::DoEvent( ::OnChange )

Return nil

*-----------------------------------------------------------------------------*
METHOD FastUpdate( d ) CLASS TBrowse
*-----------------------------------------------------------------------------*
Local ActualRecord , RecordCount

	// If vertical scrollbar is used it must be updated
   If ::VScroll != nil

      RecordCount := ::RecCount

		If RecordCount == 0
         Return nil
		EndIf

		If RecordCount < 100
         ActualRecord := ::VScroll:Value + d
         * ::VScroll:RangeMax := RecordCount
         ::VScroll:Value := ActualRecord
		EndIf

	EndIf

Return nil

*-----------------------------------------------------------------------------*
METHOD InPlaceAppend() CLASS TBrowse
*-----------------------------------------------------------------------------*
Local _Alias , _RecNo , _BrowseArea , _BrowseRecMap   , _DeltaScroll := { Nil , Nil , Nil , Nil } , _NewRec , aTemp

   _BrowseRecMap := ::aRecMap

	_Alias := Alias()
   _BrowseArea := ::WorkArea
   If Select( _BrowseArea ) == 0
      ::RecCount := 0
      Return nil
	EndIf
   DbSelectArea( _BrowseArea )
	_RecNo := RecNo()
	Go Bottom

	_NewRec := RecCount() + 1

   if LISTVIEWGETITEMCOUNT( ::hWnd ) != 0
      ::scrollUpdate()
      Skip - LISTVIEWGETCOUNTPERPAGE ( ::hWnd ) + 2
      ::Update()
	endif

	append blank

	Go _RecNo
	if Select( _Alias ) != 0
      DbSelectArea( _Alias )
	Else
      DbSelectArea( 0 )
	Endif

   aTemp := array ( Len ( ::aFields ) )
	afill ( aTemp , '' )
   aadd ( ::aRecMap, _NewRec )

   AddListViewItems( ::hWnd, aTemp )

   ListView_SetCursel ( ::hWnd, Len ( ::aRecMap ) )

   ::BrowseOnChange()

   _OOHG_IPE_ROW := 1

Return nil

*-----------------------------------------------------------------------------*
METHOD ScrollUpdate() CLASS TBrowse
*-----------------------------------------------------------------------------*
Local ActualRecord , RecordCount
Local oVScroll, cWorkArea

   oVScroll := ::VScroll

	// If vertical scrollbar is used it must be updated
   If oVScroll != nil

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

      ::RecCount := RecordCount

		If RecordCount < 100
         oVScroll:RangeMax := RecordCount
         oVScroll:Value := ActualRecord
		Else
         oVScroll:RangeMax := 100
         oVScroll:Value := Int ( ActualRecord * 100 / RecordCount )
		EndIf

	EndIf

Return NIL





*-----------------------------------------------------------------------------*
METHOD Refresh() CLASS TBrowse
*-----------------------------------------------------------------------------*
Local s , _RecNo , _DeltaScroll, v
Local cWorkArea, hWnd

   cWorkArea := ::WorkArea
   hWnd := ::hWnd

   If Select( cWorkArea ) == 0
      ListViewReset( hWnd )
      Return nil
	EndIf

   v := ::Value

   _DeltaScroll := ListView_GetSubItemRect ( hWnd, 0 , 0 )

   s := LISTVIEW_GETFIRSTITEM ( hWnd )

   _RecNo := ( cWorkArea )->( RecNo() )

   if v <= 0
		v := _RecNo
	EndIf

   ( cWorkArea )->( DbGoTo( v ) )

***************************

	if s == 1 .or. s == 0
// Sin usar DBFILTER()
      ( cWorkArea )->( DBSkip() )
      ( cWorkArea )->( DBSkip( -1 ) )
      IF ( cWorkArea )->( RecNo() ) != v
         ( cWorkArea )->( DbSkip() )
      ENDIF
/*
// Usando DBFILTER()
      cMacroVar := ( c::WorkArea )->( dbfilter() )
      If ! Empty( cMacroVar )
         If ! ( cWorkArea )->( &cMacroVar )
            ( cWorkArea )->( DbSkip() )
         EndIf
      EndIf
*/
	EndIf

***************************

	if s == 0
      if ( cWorkArea )->( INDEXORD() ) != 0
         if ( cWorkArea )->( ORDKEYVAL() ) == Nil
            ( cWorkArea )->( DbGoTop() )
			endif
		EndIf

      if Set( _SET_DELETED )
         if ( cWorkArea )->( Deleted() )
            ( cWorkArea )->( DbGoTop() )
			endif
		EndIf
	endif

   If ( cWorkArea )->( Eof() )

      ListViewReset ( hWnd )

      ( cWorkArea )->( DbGoTo( _RecNo ) )

      Return nil

	EndIf

   ::scrollUpdate()

	if s != 0
      ( cWorkArea )->( DbSkip( -s+1 ) )
	EndIf

   ::Update()

   ListView_Scroll( hWnd, _DeltaScroll[2] * (-1) , 0 )
   ListView_SetCursel ( hWnd, ascan ( ::aRecMap, v ) )

   ( cWorkArea )->( DbGoTo( _RecNo ) )

Return nil

*-----------------------------------------------------------------------------*
METHOD Release() CLASS TBrowse
*-----------------------------------------------------------------------------*
   if ::VScroll != nil
      ::VScroll:Release()
   endif
Return ::Super:Release()

*-----------------------------------------------------------------------------*
METHOD SizePos( Row, Col, Width, Height ) CLASS TBrowse
*-----------------------------------------------------------------------------*
Local uRet

   IF VALTYPE( Row ) == "N"
      ::nRow := Row
   ENDIF
   IF VALTYPE( Col ) == "N"
      ::nCol := Col
   ENDIF
   IF VALTYPE( Width ) == "N"
      ::nWidth := Width
   ENDIF
   IF VALTYPE( Height ) == "N"
      ::nHeight := Height
   ENDIF

   If ::VScroll != nil
      uRet := MoveWindow( ::hWnd, ::ContainerCol + if( ::lRtl .AND. ! ::Parent:lRtl, GETVSCROLLBARWIDTH(), 0 ), ::ContainerRow, ::Width - GETVSCROLLBARWIDTH(), ::Height , .t. )

      // Force button move/resize and browse refresh
      ::nButtonActive := 2
      ::AdjustRightScroll()

   else

      uRet := MoveWindow( ::hWnd, ::ContainerCol + if( ::lRtl .AND. ! ::Parent:lRtl, GETVSCROLLBARWIDTH(), 0 ), ::ContainerRow, ::nWidth, ::nHeight , .T. )

   EndIf
*   ReDrawWindow( ::hWnd )
   ::Refresh()
Return uRet

*-----------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TBrowse
*-----------------------------------------------------------------------------*
   IF VALTYPE( uValue ) == "N"
      ::SetValue( uValue )
   ENDIF
   If SELECT( ::WorkArea ) == 0 .OR. LISTVIEW_GETFIRSTITEM( ::hWnd ) == 0
      uValue := 0
	Else
      uValue := ::aRecMap[ LISTVIEW_GETFIRSTITEM( ::hWnd ) ]
	EndIf
RETURN uValue

*------------------------------------------------------------------------------*
METHOD Enabled( lEnabled ) CLASS TBrowse
*------------------------------------------------------------------------------*
   IF VALTYPE( lEnabled ) == "L"
      ::Super:Enabled := lEnabled
      If ::VScroll != nil
         ::VScroll:Enabled := lEnabled
      ENDIF
      If ::AuxHandle != 0
         IF ::Super:Enabled
            EnableWindow( ::AuxHandle )
         ELSE
            DisableWindow( ::AuxHandle )
         EndIf
      ENDIF
   ENDIF
RETURN ::Super:Enabled

*------------------------------------------------------------------------------*
METHOD Visible( lVisible ) CLASS TBrowse
*------------------------------------------------------------------------------*
   IF VALTYPE( lVisible ) == "L"
      ::Super:Visible := lVisible
      If ::VScroll != nil
         ::VScroll:Visible := ::VScroll:Visible
		EndIf
      If ::AuxHandle != 0
         IF ::ContainerVisible
            CShowControl( ::AuxHandle )
         ELSE
            HideWindow( ::AuxHandle )
         ENDIF
		EndIf
      ProcessMessages()
   ENDIF
RETURN ::Super:Visible

*------------------------------------------------------------------------------*
METHOD ForceHide() CLASS TBrowse
*------------------------------------------------------------------------------*
   If ::VScroll != nil
      ::VScroll:ForceHide()
   EndIf
   If ::AuxHandle != 0
      HideWindow( ::AuxHandle )
   EndIf
RETURN ::Super:ForceHide()

*-----------------------------------------------------------------------------*
METHOD RefreshData() CLASS TBrowse
*-----------------------------------------------------------------------------*
   ::Refresh()
   ::Value := ::nValue
RETURN nil

*-----------------------------------------------------------------------------*
METHOD IsHandle( hWnd ) CLASS TBrowse
*-----------------------------------------------------------------------------*
RETURN ( hWnd == ::hWnd ) .OR. ;
       ( ::VScroll != nil .AND. hWnd == ::VScroll:hWnd ) .OR. ;
       ( ::AuxHandle != 0 .AND. hWnd == ::AuxHandle )

*-----------------------------------------------------------------------------*
METHOD Events_Enter() CLASS TBrowse
*-----------------------------------------------------------------------------*

   if ::AllowEdit .AND. Select( ::WorkArea ) != 0
      if ::InPlace
         ::ProcessInPlaceKbdEdit()
      Else
         ::EditItem( .f. )
      EndIf
   Else

      ::DoEvent( ::OnDblClick )

   Endif

Return nil

#pragma BEGINDUMP
#define s_Super s_TGrid
#include "hbapi.h"
#include "hbvm.h"
#include <windows.h>
#include <commctrl.h>
#include "../include/oohg.h"

// -----------------------------------------------------------------------------
// METHOD Events_Notify( wParam, lParam ) CLASS TBrowse
HB_FUNC_STATIC( TBROWSE_EVENTS_NOTIFY )
// -----------------------------------------------------------------------------
{
   LONG wParam = hb_parnl( 1 );
   LONG lParam = hb_parnl( 2 );

   switch( ( ( NMHDR FAR * ) lParam )->code )
   {
      case NM_CUSTOMDRAW:
      case NM_CLICK:
      case LVN_BEGINDRAG:
      case LVN_KEYDOWN:
      case NM_DBLCLK:
         HB_FUNCNAME( TBROWSE_EVENTS_NOTIFY2 )();
         break;

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

FUNCTION TBrowse_Events_Notify2( wParam, lParam )
Local Self := QSelf()
Local nNotify := GetNotifyCode( lParam )
Local xs , xd, nvKey
Local r, DeltaSelect

   If nNotify == NM_CUSTOMDRAW

      ::AdjustRightScroll()
      Return TGRID_NOTIFY_CUSTOMDRAW( Self, lParam )

   elseIf nNotify == NM_CLICK  .or. nNotify == LVN_BEGINDRAG

      r := LISTVIEW_GETFIRSTITEM( ::hWnd )
      If r > 0
         DeltaSelect := r - ascan ( ::aRecMap, ::nValue )
         ::nValue := ::aRecMap[ r ]
         ::FastUpdate( DeltaSelect )
         ::BrowseOnChange()
      EndIf

      Return nil

   elseIf nNotify == LVN_KEYDOWN

      nvKey := GetGridvKey( lParam )

      Do Case

      Case Select( ::WorkArea ) == 0

         // No database open

      Case nvKey == 65 // A

         if GetAltState() == -127 ;
            .or.;
            GetAltState() == -128   // ALT

            if ::AllowAppend
               ::EditItem( .t. )
            EndIf

         EndIf

      Case nvKey == 46 // DEL

         If ::AllowDelete
            If MsgYesNo( _OOHG_BRWLangMessage [1] , _OOHG_BRWLangMessage [2] )
               ::Delete()
            EndIf
         EndIf

      Case nvKey == 36 // HOME

         ::Home()
         Return 1

      Case nvKey == 35 // END

         ::End()
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

   elseIf nNotify == NM_DBLCLK

      _PushEventInfo()
      _OOHG_ThisForm := ::Parent
      _OOHG_ThisType := 'C'
      _OOHG_ThisControl := Self

      r := ListView_HitTest ( ::hWnd, GetCursorRow() - GetWindowRow ( ::hWnd )  , GetCursorCol() - GetWindowCol ( ::hWnd ) )
      If r [2] == 1
         ListView_Scroll( ::hWnd,  -10000  , 0 )
         r := ListView_HitTest ( ::hWnd, GetCursorRow() - GetWindowRow ( ::hWnd )  , GetCursorCol() - GetWindowCol ( ::hWnd ) )
      Else
         r := LISTVIEW_GETSUBITEMRECT ( ::hWnd, r[1] - 1 , r[2] - 1 )

                                           *  CellCol           CellWidth
         xs := ( ( ::ContainerCol + r [2] ) +( r[3] ))  -  ( ::ContainerCol + ::Width )
         xd := 20
         If xs > -xd
            ListView_Scroll( ::hWnd,  xs + xd , 0 )
         Else
            If r [2] < 0
               ListView_Scroll( ::hWnd, r[2]   , 0 )
            EndIf
         EndIf
         r := ListView_HitTest ( ::hWnd, GetCursorRow() - GetWindowRow ( ::hWnd )  , GetCursorCol() - GetWindowCol ( ::hWnd ) )
      EndIf

      _OOHG_ThisItemRowIndex := r[1]
      _OOHG_ThisItemColIndex := r[2]
      If r [2] == 1
         r := LISTVIEW_GETITEMRECT ( ::hWnd, r[1] - 1 )
      Else
         r := LISTVIEW_GETSUBITEMRECT ( ::hWnd, r[1] - 1 , r[2] - 1 )
      EndIf
      _OOHG_ThisItemCellRow := ::ContainerRow + r [1]
      _OOHG_ThisItemCellCol := ::ContainerCol + r [2]
      _OOHG_ThisItemCellWidth := r[3]
      _OOHG_ThisItemCellHeight := r[4]

      if ::AllowEdit
         ::EditItem( .f. )
      Else
         _OOHG_Eval( ::OnDblClick )
      Endif

      _PopEventInfo()
      _OOHG_ThisItemRowIndex := 0
      _OOHG_ThisItemColIndex := 0
      _OOHG_ThisItemCellRow := 0
      _OOHG_ThisItemCellCol := 0
      _OOHG_ThisItemCellWidth := 0
      _OOHG_ThisItemCellHeight := 0

      Return nil

   EndIf

Return ::Super:Events_Notify( wParam, lParam )

*-----------------------------------------------------------------------------*
METHOD SetScrollPos( nPos ) CLASS TBrowse
*-----------------------------------------------------------------------------*
Local nr , RecordCount , SkipCount , BackRec

   If Select( ::WorkArea ) != 0

      BackRec := ( ::WorkArea )->( RecNo() )

      If ( ::WorkArea )->( OrdKeyCount() ) > 0
         RecordCount := ( ::WorkArea )->( OrdKeyCount() )
      Else
         RecordCount := ( ::WorkArea )->( RecCount() )
      EndIf

      SkipCount := Int ( nPos * RecordCount / ::VScroll:RangeMax )

      ( ::WorkArea )->( OrdKeyGoTo( SkipCount ) )
/*
      If SkipCount > ( RecordCount / 2 )
         ( ::WorkArea )->( DbGoBottom() )
         ( ::WorkArea )->( DbSkip( - ( RecordCount - SkipCount ) ) )
      Else
         ( ::WorkArea )->( DbGoTop() )
         ( ::WorkArea )->( DbSkip( SkipCount ) )
      EndIf
*/

      If ( ::WorkArea )->( Eof() )
         ( ::WorkArea )->( DbSkip( -1 ) )
      EndIf

      nr := ( ::WorkArea )->( RecNo() )

      ::VScroll:Value := nPos

      ( ::WorkArea )->( DbGoTo( BackRec ) )

      ::Value := nr

   EndIf

Return nr

Function SetBrowseSync( lValue )
   IF valtype( lValue ) == "L"
      _OOHG_BrowseSyncStatus := lValue
   ENDIF
Return _OOHG_BrowseSyncStatus












/// TEMP!!! CLASE SCROLLBARBUTTON!!!