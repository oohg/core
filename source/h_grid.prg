/*
 * $Id: h_grid.prg,v 1.13 2005-09-02 05:53:45 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG grid functions
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
#include 'hbclass.ch'
#include "i_windefs.ch"

CLASS TGrid FROM TControl
   DATA Type             INIT "GRID" READONLY
   DATA aWidths          INIT {}
   DATA aHeaders         INIT ""
   DATA aHeadClick       INIT {}
   DATA AllowEdit        INIT .F.
   DATA GridForeColor    INIT {}
   DATA GridBackColor    INIT {}
   DATA DynamicForeColor INIT {}
   DATA DynamicBackColor INIT {}
   DATA Picture          INIT {}
   DATA OnDispInfo       INIT nil
   DATA SetImageListCommand INIT LVM_SETIMAGELIST
   DATA SetImageListWParam  INIT LVSIL_SMALL

   METHOD Define
   METHOD Define2
   METHOD Value            SETGET

   METHOD Events
   METHOD Events_Enter
   METHOD Events_Notify

   METHOD EditItem
   METHOD AddColumn
   METHOD DeleteColumn

   METHOD AddItem
   METHOD DeleteItem
   METHOD DeleteAllItems      BLOCK { | Self | ListViewReset( ::hWnd ), ::GridForeColor := nil, ::GridBackColor := nil }
   METHOD Item
   METHOD SetItemColor
   METHOD ItemCount           BLOCK { | Self | ListViewGetItemCount( ::hWnd ) }
   METHOD Header
   METHOD FontColor      SETGET
   METHOD BkColor        SETGET
   METHOD SetRangeColor
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
               aRows, value, fontname, fontsize, tooltip, change, dblclick, ;
               aHeadClick, gotfocus, lostfocus, nogrid, aImage, aJust, ;
               break, HelpId, bold, italic, underline, strikeout, ownerdata, ;
               ondispinfo, itemcount, editable, backcolor, fontcolor, ;
               dynamicbackcolor, dynamicforecolor, aPicture, lRtl ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local nStyle := LVS_SINGLESEL

   ::Define2( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
              aRows, value, fontname, fontsize, tooltip, change, dblclick, ;
              aHeadClick, gotfocus, lostfocus, nogrid, aImage, aJust, ;
              break, HelpId, bold, italic, underline, strikeout, ownerdata, ;
              ondispinfo, itemcount, editable, backcolor, fontcolor, ;
              dynamicbackcolor, dynamicforecolor, aPicture, lRtl, nStyle )
Return Self

*-----------------------------------------------------------------------------*
METHOD Define2( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
                aRows, value, fontname, fontsize, tooltip, change, dblclick, ;
                aHeadClick, gotfocus, lostfocus, nogrid, aImage, aJust, ;
                break, HelpId, bold, italic, underline, strikeout, ownerdata, ;
                ondispinfo, itemcount, editable, backcolor, fontcolor, ;
                dynamicbackcolor, dynamicforecolor, aPicture, lRtl, nStyle ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local ControlHandle, aImageList

   ::SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor, .t., lRtl )

   if ValType ( aHeaders ) != 'A'
      MsgOOHGError ("Grid: HEADERS not defined .Program Terminated")
	EndIf
   if ValType ( aWidths ) != 'A'
      MsgOOHGError ("Grid: WIDTHS not defined. Program Terminated")
	EndIf
	if Len ( aHeaders ) != Len ( aWidths )
      MsgOOHGError ("Browse/Grid: FIELDS/HEADERS/WIDTHS array size mismatch .Program Terminated")
	EndIf
   if ValType( aRows ) == 'A'
		if Len (aRows) > 0
			if Len (aRows[1]) != Len ( aHeaders )
            MsgOOHGError ("Grid: ITEMS length mismatch. Program Terminated")
			EndIf
		EndIf
   Else
		aRows := {}
	EndIf

   if valtype( w ) != "N"
		w := 240
	endif
   if valtype( h ) != "N"
		h := 120
	endif
   if valtype(aJust) != "A"
		aJust := Array( len( aHeaders ) )
		aFill( aJust, 0 )
	else
		aSize( aJust, len( aHeaders ) )
      aEval( aJust, { |x| x := iif( ValType( x ) != "N", 0, x ) } )
	endif

   if valtype( aPicture ) != "A"
      aPicture := Array( len( aHeaders ) )
	else
      aSize( aPicture, len( aHeaders ) )
	endif
   aEval( aPicture, { |x,i| aPicture[ i ] := iif( ( ValType( x ) $ "CM" .AND. ! Empty( x ) ) .OR. ValType( x ) == "L", x, nil ) } )

   if valtype( x ) != "N" .OR. valtype( y ) != "N"

      If _OOHG_SplitLastControl == 'TOOLBAR'
			Break := .T.
		EndIf

      _OOHG_SplitLastControl   := "GRID"

         ControlHandle := InitListView ( ::Parent:ReBarHandle, 0, 0, 0, w, h ,'',0,iif( nogrid, 0, 1 ) , ownerdata , itemcount , nStyle, ::lRtl )

         x := GetWindowCol( Controlhandle )
         y := GetWindowRow( Controlhandle )

         AddSplitBoxItem( Controlhandle, ::Parent:ReBarHandle, w , break , , , , _OOHG_ActiveSplitBoxInverted )

	Else

      ControlHandle := InitListView ( ::Parent:hWnd, 0, x, y, w, h ,'',0, iif( nogrid, 0, 1 ) , ownerdata  , itemcount  , nStyle, ::lRtl )

	endif

   if valtype( aImage ) == "A"
      aImageList := ImageList_Init( aImage, CLR_NONE, LR_LOADTRANSPARENT )
      SendMessage( ControlHandle, ::SetImageListCommand, ::SetImageListWParam, aImageList[ 1 ] )
      ::ImageList := aImageList[ 1 ]
      If ASCAN( aPicture, .T. ) == 0
         aPicture[ 1 ] := .T.
         aWidths[ 1 ] := max( aWidths[ 1 ], aImageList[ 2 ] + 2 ) // Set Column 1 width to Bitmap width
      EndIf
   EndIf

   InitListViewColumns( ControlHandle, aHeaders , aWidths, aJust )

   ::New( ControlHandle, ControlName, HelpId, , ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )
   ::SizePos( y, x, w, h )

   ::FontColor := ::aFontColor
   ::BkColor := ::aBkColor

   if valtype(aHeadClick) != "A"
		aHeadClick := {}
	endif

   ::OnDispInfo := ondispinfo
   ::aWidths := aWidths
   ::aHeaders :=  aHeaders
   ::OnLostFocus := LostFocus
   ::OnGotFocus :=  GotFocus
   ::OnChange   :=  Change
   ::OnDblClick := dblclick
   ::aHeadClick :=  aHeadClick
   ::AllowEdit :=  Editable
   ::DynamicForeColor := dynamicforecolor
   ::DynamicBackColor := dynamicbackcolor
   ::Picture := aPicture

   AEVAL( aRows, { |u| ::AddItem( u ) } )

   ::Value := value

Return Self

*-----------------------------------------------------------------------------*
METHOD EditItem() CLASS TGrid
*-----------------------------------------------------------------------------*
Local a,l,g,actpos:={0,0,0,0},GRow,GCol,GWidth,Col,IRow,LN , TN , item,i, oWnd, aSave
Local aNum, oCtrl

   a := ::aHeaders

   item := ::Value
   IF item == 0
      return nil
   ENDIF

	l := Len(a)

   g := ::Item( Item )

   IRow := ListViewGetItemRow ( ::hWnd, Item )

   GetWindowRect( ::hWnd, actpos )

	GRow 	:= actpos [2]
	GCol 	:= actpos [1]
	GWidth 	:= actpos [3] - actpos [1]
   aSave := {}

	Col := GCol + ( ( GWidth - 260 ) / 2 )

	DEFINE WINDOW _EditItem ;
      OBJ oWnd ;
		AT IRow,Col ;
		WIDTH 260 ;
		HEIGHT (l*30) + 70 + GetTitleHeight() ;
      TITLE _OOHG_MESSAGE [5] ;
		MODAL ;
      NOSIZE

		For i := 1 to l
			LN := 'Label_' + Alltrim(Str(i,2,0))
			TN := 'Text_' + Alltrim(Str(i,2,0))
			@ (i*30) - 17 , 10 LABEL &LN OF _EditItem VALUE Alltrim(a[i]) +":"
         If ValType( g[ i ] ) == "N"
            @ (i*30) - 20 , 120 COMBOBOX &TN OF _EditItem ITEMS {} VALUE 0
            oCtrl := oWnd:Control( TN )
            aNum := ARRAY( ImageList_GetImageCount( ::ImageList ) )
            SendMessage( oCtrl:hWnd, oCtrl:SetImageListCommand, oCtrl:SetImageListWParam, ::ImageList )
            AEVAL( aNum, { |x,i| ComboAddString( oCtrl:hWnd, i - 1 ), x } )
            oCtrl:Value := g[ i ] + 1
            AADD( aSave, TGrid_EditItemBlock2( g, i, oWnd:Control( TN ) ) )
         ElseIf ValType( ::Picture ) == "A" .AND. Len( ::Picture ) >= i .AND. ValType( ::Picture[ i ] ) $ "CM"
            @ (i*30) - 20 , 120 TEXTBOX  &TN OF _EditItem VALUE g[i] PICTURE ::Picture[ i ]
            AADD( aSave, TGrid_EditItemBlock1( g, i, oWnd:Control( TN ) ) )
         Else
            @ (i*30) - 20 , 120 TEXTBOX  &TN OF _EditItem VALUE g[i]
            AADD( aSave, TGrid_EditItemBlock1( g, i, oWnd:Control( TN ) ) )
         ENDIF
		Next i

		@ (l*30) + 20 , 20 BUTTON BUTTON_1 ;
		OF _EDITITEM ;
      CAPTION _OOHG_MESSAGE [6] ;
      ACTION { || AEVAL( aSave, { |b| _OOHG_EVAL( b ) } ), ::Item( Item , g ), oWnd:Release() }

		@ (l*30) + 20 , 130 BUTTON BUTTON_2 ;
		OF _EDITITEM ;
      CAPTION _OOHG_MESSAGE [7] ;
      ACTION oWnd:Release()

	END WINDOW

   oWnd:Text_1:SetFocus()

   oWnd:Activate()

   ::SetFocus()

Return Nil

STATIC FUNCTION TGrid_EditItemBlock1( aItems, nItem, oControl )
Return { || aItems[ nItem ] := oControl:Value }

STATIC FUNCTION TGrid_EditItemBlock2( aItems, nItem, oControl )
Return { || aItems[ nItem ] := oControl:Value - 1 }

*-----------------------------------------------------------------------------*
METHOD AddColumn( nColIndex, cCaption, nWidth, nJustify, uForeColor, uBackColor, lNoDelete, uPicture ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local nColumns, uGridColor, uDynamicColor

	// Set Default Values
   nColumns := Len( ::aHeaders ) + 1

   If ValType( nColIndex ) != 'N' .OR. nColIndex > nColumns
      nColIndex := nColumns
   ElseIf nColIndex < 1
      nColIndex := 1
	EndIf

   If ! ValType( cCaption ) $ 'CM'
		cCaption := ''
	EndIf

   If ValType( nWidth ) != 'N'
		nWidth := 120
	EndIf

   If ValType( nJustify ) != 'N'
		nJustify := 0
	EndIf

   // Update Headers
   ASIZE( ::aHeaders, nColumns )
   AINS( ::aHeaders, nColIndex )
   ::aHeaders[ nColIndex ] := cCaption

   // Update Pictures
   ASIZE( ::Picture, nColumns )
   AINS( ::Picture, nColIndex )
   ::Picture[ nColIndex ] := iif( ( ValType( uPicture ) $ "CM" .AND. ! Empty( uPicture ) ) .OR. ValType( uPicture ) == "L", uPicture, nil )

   IF ValType( lNoDelete ) != "L"
      lNoDelete := .F.
   ENDIF

   // Update Foreground Color
   uGridColor := ::GridForeColor
   uDynamicColor := ::DynamicForeColor
   TGrid_AddColumnColor( @uGridColor, nColIndex, uForeColor, @uDynamicColor, nColumns, ::ItemCount(), lNoDelete )
   ::GridForeColor := uGridColor
   ::DynamicForeColor := uDynamicColor

   // Update Background Color
   uGridColor := ::GridBackColor
   uDynamicColor := ::DynamicBackColor
   TGrid_AddColumnColor( @uGridColor, nColIndex, uBackColor, @uDynamicColor, nColumns, ::ItemCount(), lNoDelete )
   ::GridBackColor := uGridColor
   ::DynamicBackColor := uDynamicColor

	// Call C-Level Routine
   ListView_AddColumn( ::hWnd, nColIndex, nWidth, cCaption, nJustify, lNoDelete )

Return nil

STATIC Function TGrid_AddColumnColor( aGrid, nColumn, uColor, uDynamicColor, nWidth, nItemCount, lNoDelete )
Local uTemp, x
   IF ValType( uDynamicColor ) == "A"
      IF Len( uDynamicColor ) < nWidth
         ASIZE( uDynamicColor, nWidth )
      ENDIF
      AINS( uDynamicColor, nColumn )
      uDynamicColor[ nColumn ] := uColor
   ElseIf ValType( uColor ) $ "ANB"
      uTemp := uDynamicColor
      uDynamicColor := ARRAY( nWidth )
      AFILL( uDynamicColor, uTemp )
      uDynamicColor[ nColumn ] := uColor
   ENDIF
   IF ! lNoDelete
      uDynamicColor := nil
   ElseIf ValType( aGrid ) == "A" .OR. ValType( uColor ) $ "ANB" .OR. ValType( uDynamicColor ) $ "ANB"
      IF ValType( aGrid ) == "A"
         IF Len( aGrid ) < nItemCount
            ASIZE( aGrid, nItemCount )
         Else
            nItemCount := Len( aGrid )
         ENDIF
      Else
         aGrid := ARRAY( nItemCount )
      ENDIF
      FOR x := 1 TO nItemCount
         IF ValType( aGrid[ x ] ) == "A"
            IF LEN( aGrid[ x ] ) < nWidth
                ASIZE( aGrid[ x ], nWidth )
            ENDIF
            AINS( aGrid[ x ], nColumn )
         Else
            aGrid[ x ] := ARRAY( nWidth )
         ENDIF
         aGrid[ x ][ nColumn ] := _OOHG_GetArrayItem( uDynamicColor, nColumn, x )
      NEXT
   ENDIF
Return NIL

*-----------------------------------------------------------------------------*
METHOD DeleteColumn( nColIndex, lNoDelete ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local nColumns

   // Update Headers
   nColumns := Len( ::aHeaders )
   IF nColumns == 0
      Return nil
   ENDIF

   If ValType( nColIndex ) != 'N' .OR. nColIndex > nColumns
      nColIndex := nColumns
   ElseIf nColIndex < 1
      nColIndex := 1
	EndIf

   _OOHG_DeleteArrayItem( ::aHeaders, nColIndex )
   _OOHG_DeleteArrayItem( ::Picture,  nColIndex )

   _OOHG_DeleteArrayItem( ::DynamicForeColor, nColIndex )
   _OOHG_DeleteArrayItem( ::DynamicBackColor, nColIndex )

   If ValType( lNoDelete ) == "L" .AND. lNoDelete
      IF ValType( ::GridForeColor ) == "A"
         AEVAL( ::GridForeColor, { |a| _OOHG_DeleteArrayItem( a, nColIndex ) } )
      ENDIF
      IF ValType( ::GridBackColor ) == "A"
         AEVAL( ::GridBackColor, { |a| _OOHG_DeleteArrayItem( a, nColIndex ) } )
      ENDIF
   Else
      ::GridForeColor := nil
      ::GridBackColor := nil
   EndIf

	// Call C-Level Routine
   ListView_DeleteColumn( ::hWnd, nColIndex, lNoDelete )

Return nil

*-----------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TGrid
*-----------------------------------------------------------------------------*
   IF VALTYPE( uValue ) == "N"
      ListView_SetCursel( ::hWnd, uValue )
      ListView_EnsureVisible( ::hWnd, uValue )
   ELSE
      uValue := LISTVIEW_GETFIRSTITEM( ::hWnd )
   ENDIF
RETURN uValue

#pragma BEGINDUMP
#define s_Super s_TControl
#include "hbapi.h"
#include "hbvm.h"
#include <windows.h>
#include "../include/oohg.h"

// -----------------------------------------------------------------------------
HB_FUNC_STATIC( TGRID_EVENTS )   // METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TGrid
// -----------------------------------------------------------------------------
{
// int TGrid_Notify_CustomDraw( PHB_ITEM pSelf, LPARAM lParam );
   HWND hWnd      = ( HWND )   hb_parnl( 1 );
   UINT message   = ( UINT )   hb_parni( 2 );
   WPARAM wParam  = ( WPARAM ) hb_parni( 3 );
   LPARAM lParam  = ( LPARAM ) hb_parnl( 4 );
   PHB_ITEM pSelf = hb_stackSelfItem();

   if ( message == WM_MOUSEWHEEL )
	{

      if ( ( short ) HIWORD ( wParam ) > 0 )
		{

			keybd_event(
			VK_UP	,	// virtual-key code
			0,		// hardware scan code
			0,		// flags specifying various function options
			0		// additional data associated with keystroke
			);

		}
		else
		{

			keybd_event(
			VK_DOWN	,	// virtual-key code
			0,		// hardware scan code
			0,		// flags specifying various function options
			0		// additional data associated with keystroke
			);

		}

      hb_retni( 1 );
	}
	else
	{
      _OOHG_Send( pSelf, s_Super );
      hb_vmSend( 0 );
      _OOHG_Send( hb_param( -1, HB_IT_OBJECT ), s_Events );
      hb_vmPushLong( ( LONG ) hWnd );
      hb_vmPushLong( message );
      hb_vmPushLong( wParam );
      hb_vmPushLong( lParam );
      hb_vmSend( 4 );
	}
}
#pragma ENDDUMP

*-----------------------------------------------------------------------------*
METHOD Events_Enter() CLASS TGrid
*-----------------------------------------------------------------------------*

   if ::AllowEdit

      ::EditItem()

   Else

      ::DoEvent( ::OnDblClick )

   EndIf

Return nil

*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam )
Local lvc, aCellData, _ThisQueryTemp

   If nNotify == NM_CUSTOMDRAW

      Return TGRID_NOTIFY_CUSTOMDRAW( Self, lParam )

   ElseIf nNotify == LVN_GETDISPINFO

      * Grid OnQueryData ............................

      if valtype( ::OnDispInfo ) == 'B'

         _PushEventInfo()
         _OOHG_ThisForm := ::Parent
         _OOHG_ThisType := 'C'
         _OOHG_ThisControl := Self
         _ThisQueryTemp  := GETGRIDDISPINFOINDEX ( lParam )
         _OOHG_ThisQueryRowIndex  := _ThisQueryTemp [1]
         _OOHG_ThisQueryColIndex  := _ThisQueryTemp [2]
         Eval( ::OnDispInfo )
         IF ValType( _OOHG_ThisQueryData ) == "N"
            SetGridQueryImage ( lParam , _OOHG_ThisQueryData )
         ElseIf ValType( _OOHG_ThisQueryData ) $ "CM"
            SetGridQueryData ( lParam , _OOHG_ThisQueryData )
         EndIf
         _OOHG_ThisQueryRowIndex  := 0
         _OOHG_ThisQueryColIndex  := 0
         _OOHG_ThisQueryData := ""
         _PopEventInfo()

      EndIf

   elseif nNotify == LVN_ITEMCHANGED

      * Grid Change .................................

      If GetGridOldState(lParam) == 0 .and. GetGridNewState(lParam) != 0
         ::DoEvent( ::OnChange )
         Return nil
      EndIf

   elseif nNotify == LVN_COLUMNCLICK

      * Grid Header Click ..........................

      if ValType ( ::aHeadClick ) == 'A'
         lvc := GetGridColumn(lParam) + 1
         if len ( ::aHeadClick ) >= lvc
            ::DoEvent ( ::aHeadClick [lvc] )
            Return nil
         EndIf
      EndIf

   elseif nNotify == NM_DBLCLK

      * Grid Double Click ...........................

      if ::AllowEdit

         ::EditItem()

      Else

         if valtype( ::OnDblClick ) == 'B'

            _PushEventInfo()
            _OOHG_ThisForm := ::Parent
            _OOHG_ThisType := 'C'
            _OOHG_ThisControl := Self

            aCellData := _GetGridCellData( Self )

            _OOHG_ThisItemRowIndex := aCellData [1]
            _OOHG_ThisItemColIndex := aCellData [2]
            _OOHG_ThisItemCellRow := aCellData [3]
            _OOHG_ThisItemCellCol := aCellData [4]
            _OOHG_ThisItemCellWidth := aCellData [5]
            _OOHG_ThisItemCellHeight := aCellData [6]

            Eval( ::OnDblClick )
            _PopEventInfo()

            _OOHG_ThisItemRowIndex := 0
            _OOHG_ThisItemColIndex := 0
            _OOHG_ThisItemCellRow := 0
            _OOHG_ThisItemCellCol := 0
            _OOHG_ThisItemCellWidth := 0
            _OOHG_ThisItemCellHeight := 0

         EndIf

      EndIf

      Return nil

* ¿Qué es -181?
   elseif nNotify == -181  // ???????

      redrawwindow( ::hWnd )

   EndIf

Return ::Super:Events_Notify( wParam, lParam )

*-----------------------------------------------------------------------------*
METHOD AddItem( aRow, uForeColor, uBackColor ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local iIm := 0

   if Len( ::aHeaders ) != Len( aRow )
      MsgOOHGError( "Grid.AddItem: Item size mismatch. Program Terminated" )
	EndIf

   aRow := ACLONE( aRow )
   AEVAL( ::Picture, { |x,i| if( ValType( x ) $ "CM", aRow[ i ] := Transform( aRow[ i ], x ), ) } )

   ::SetItemColor( ::ItemCount() + 1, uForeColor, uBackColor, aRow )

   AddListViewItems( ::hWnd , aRow )

Return Nil

*-----------------------------------------------------------------------------*
METHOD DeleteItem( nItem ) CLASS TGrid
*-----------------------------------------------------------------------------*
   _OOHG_DeleteArrayItem( ::GridForeColor, nItem )
   _OOHG_DeleteArrayItem( ::GridBackColor, nItem )
Return ListViewDeleteString( ::hWnd, nItem )

*-----------------------------------------------------------------------------*
METHOD Item( nItem, uValue, uForeColor, uBackColor ) CLASS TGrid
*-----------------------------------------------------------------------------*
   IF PCOUNT() > 1
      uValue := ACLONE( uValue )
      AEVAL( ::Picture, { |x,i| if( ValType( x ) $ "CM", uValue[ i ] := Transform( uValue[ i ], x ), ) } )
      ::SetItemColor( nItem, uForeColor, uBackColor, uValue )
      ListViewSetItem( ::hWnd, uValue, nItem )
   ENDIF
   uValue := ListViewGetItem( ::hWnd, nItem , Len( ::aHeaders ) )
Return uValue

*-----------------------------------------------------------------------------*
METHOD SetItemColor( nItem, uForeColor, uBackColor, uExtra ) CLASS TGrid
*-----------------------------------------------------------------------------*
   ::GridForeColor := TGrid_CreateColorArray( ::GridForeColor, nItem, uForeColor, ::DynamicForeColor, LEN( ::aHeaders ), uExtra )
   ::GridBackColor := TGrid_CreateColorArray( ::GridBackColor, nItem, uBackColor, ::DynamicBackColor, LEN( ::aHeaders ), uExtra )
Return Nil

STATIC Function TGrid_CreateColorArray( aGrid, nItem, uColor, uDynamicColor, nWidth, uExtra )
Local aTemp, nLen
   IF ! ValType( uColor ) $ "ANB" .AND. ValType( uDynamicColor ) $ "ANB"
      uColor := uDynamicColor
   ENDIF
   IF ValType( uColor ) $ "ANB"
      IF ValType( aGrid ) == "A"
         IF Len( aGrid ) < nItem
            ASIZE( aGrid, nItem )
         ENDIF
      ELSE
         aGrid := ARRAY( nItem )
      ENDIF
      aTemp := ARRAY( nWidth )
      IF ValType( uColor ) == "A" .AND. LEN( uColor ) < nWidth
         nLen := LEN( uColor )
         uColor := ACLONE( uColor )
         IF VALTYPE( uDynamicColor ) $ "NB"
            ASIZE( uColor, nWidth )
            AFILL( uColor, uDynamicColor, nLen + 1 )
         ELSEIF VALTYPE( uDynamicColor ) == "A" .AND. LEN( uDynamicColor ) > nLen
            ASIZE( uColor, MIN( nWidth, LEN( uDynamicColor ) ) )
            AEVAL( uColor, { |x,i| uColor[ i ] := uDynamicColor[ i ], x }, nLen + 1 )
         ENDIF
      ENDIF
      AEVAL( aTemp, { |x,i| aTemp[ i ] := _OOHG_GetArrayItem( uColor, i, nItem, uExtra ), x } )
      aGrid[ nItem ] := aTemp
   ENDIF
Return aGrid

*-----------------------------------------------------------------------------*
METHOD Header( nColumn, uValue ) CLASS TGrid
*-----------------------------------------------------------------------------*
   IF VALTYPE( uValue ) $ "CM"
      ::aHeaders[ nColumn ] := uValue
      SETGRIDCOLOMNHEADER( ::hWnd, nColumn, uValue )
   ENDIF
Return ::aHeaders[ nColumn ]

*-----------------------------------------------------------------------------*
METHOD FontColor( uValue ) CLASS TGrid
*-----------------------------------------------------------------------------*
LOCAL nTmp
   IF VALTYPE( uValue ) == "A"
      ::Super:FontColor := uValue
      IF ::hWnd > 0
         ListView_SetTextColor( ::hWnd, ::aFontColor[1] , ::aFontColor[2] , ::aFontColor[3] )
         RedrawWindow( ::hWnd )
      ENDIF
   ENDIF
   IF ::hWnd > 0
      nTmp := ListView_GetTextColor( ::hWnd )
      ::aFontColor := { GetRed( nTmp ), GetGreen( nTmp ), GetBlue( nTmp ) }
   ENDIF
Return ::aFontColor

*-----------------------------------------------------------------------------*
METHOD BkColor( uValue ) CLASS TGrid
*-----------------------------------------------------------------------------*
LOCAL nTmp
   IF VALTYPE( uValue ) == "A"
      ::Super:BkColor := uValue
      IF ::hWnd > 0
         ListView_SetBkColor( ::hWnd, ::aBkColor[1] , ::aBkColor[2] , ::aBkColor[3] )
         ListView_SetTextBkColor( ::hWnd, ::aBkColor[1] , ::aBkColor[2] , ::aBkColor[3] )
         RedrawWindow( ::hWnd )
      ENDIF
   ENDIF
   IF ::hWnd > 0
      nTmp := ListView_GetBkColor( ::hWnd )
      ::aBkColor := { GetRed( nTmp ), GetGreen( nTmp ), GetBlue( nTmp ) }
   ENDIF
Return ::aBkColor

*-----------------------------------------------------------------------------*
METHOD SetRangeColor( uForeColor, uBackColor, nTop, nLeft, nBottom, nRight ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local nAux, nLong := ::ItemCount()
   IF ValType( nBottom ) != "N"
      nBottom := nTop
   ENDIF
   IF ValType( nRight ) != "N"
      nRight := nLeft
   ENDIF
   IF nTop > nBottom
      nAux := nBottom
      nBottom := nTop
      nTop := nAux
   ENDIF
   IF nLeft > nRight
      nAux := nRight
      nRight := nLeft
      nLeft := nAux
   ENDIF
   IF nBottom > nLong
      nBottom := nLong
   ENDIF
   IF nRight > Len( ::aHeaders )
      nRight := Len( ::aHeaders )
   ENDIF
   IF nTop <= nLong .AND. nLeft <= Len( ::aHeaders ) .AND. nTop >= 1 .AND. nLeft >= 1
      ::GridForeColor := TGrid_FillColorArea( ::GridForeColor, uForeColor, nTop, nLeft, nBottom, nRight )
      ::GridBackColor := TGrid_FillColorArea( ::GridBackColor, uBackColor, nTop, nLeft, nBottom, nRight )
   ENDIF
Return nil

STATIC Function TGrid_FillColorArea( aGrid, uColor, nTop, nLeft, nBottom, nRight )
Local nAux
   IF ValType( uColor ) $ "ANB"
      IF ValType( aGrid ) != "A"
         aGrid := ARRAY( nBottom )
      ELSEIF LEN( aGrid ) < nBottom
         ASIZE( aGrid, nBottom )
      ENDIF
      FOR nAux := nTop TO nBottom
         IF ValType( aGrid[ nAux ] ) != "A"
            aGrid[ nAux ] := ARRAY( nRight )
         ELSEIF LEN( aGrid[ nAux ] ) < nRight
            ASIZE( aGrid[ nAux ], nRight )
         ENDIF
         AEVAL( aGrid[ nAux ], { |x,i| aGrid[ nAux ][ i ] := _OOHG_GetArrayItem( uColor, i, nAux ), x }, nLeft, ( nRight - nLeft + 1 ) )
      NEXT
   ENDIF
Return aGrid





CLASS TGridMulti FROM TGrid
   DATA Type      INIT "MULTIGRID" READONLY

   METHOD Define
   METHOD Value
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
               aRows, value, fontname, fontsize, tooltip, change, dblclick, ;
               aHeadClick, gotfocus, lostfocus, nogrid, aImage, aJust, ;
               break, HelpId, bold, italic, underline, strikeout, ownerdata, ;
               ondispinfo, itemcount, editable, backcolor, fontcolor, ;
               dynamicbackcolor, dynamicforecolor, aPicture, lRtl ) CLASS TGridMulti
*-----------------------------------------------------------------------------*
Local nStyle := 0
   ::Define2( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
              aRows, value, fontname, fontsize, tooltip, change, dblclick, ;
              aHeadClick, gotfocus, lostfocus, nogrid, aImage, aJust, ;
              break, HelpId, bold, italic, underline, strikeout, ownerdata, ;
              ondispinfo, itemcount, editable, backcolor, fontcolor, ;
              dynamicbackcolor, dynamicforecolor, aPicture, lRtl, nStyle )
Return Self

*-----------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TGridMulti
*-----------------------------------------------------------------------------*
   IF VALTYPE( uValue ) == "A"
      LISTVIEWSETMULTISEL( ::hWnd, uValue )
      If Len( uValue ) > 0
         ListView_EnsureVisible( ::hWnd, uValue[ 1 ] )
		EndIf
   ENDIF
RETURN ListViewGetMultiSel( ::hWnd )