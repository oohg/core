/*
 * $Id: h_combo.prg,v 1.21 2006-10-24 04:08:31 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG combobox functions
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

#include "oohg.ch"
#include "common.ch"
#include "hbclass.ch"
#include "i_windefs.ch"

CLASS TCombo FROM TLabel
   DATA Type      INIT "COMBO" READONLY
   DATA WorkArea  INIT ""
   DATA Field     INIT ""
   DATA nValue    INIT 0
   DATA ValueSource   INIT ""
   DATA nTextHeight   INIT 0

   METHOD Define
   METHOD Refresh
   METHOD Value               SETGET
   METHOD Visible             SETGET
   METHOD ForceHide           BLOCK { |Self| SendMessage( ::hWnd, 335, 0, 0 ) , ::Super:ForceHide() }
   METHOD RefreshData

   METHOD Events_Command
   METHOD Events_DrawItem
   METHOD Events_MeasureItem

   METHOD AddItem
   METHOD DeleteItem
   METHOD DeleteAllItems
   METHOD Item
   METHOD ItemCount
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, rows, value, fontname, ;
               fontsize, tooltip, changeprocedure, h, gotfocus, lostfocus, ;
               uEnter, HelpId, invisible, notabstop, sort, bold, italic, ;
               underline, strikeout, itemsource, valuesource, displaychange, ;
               ondisplaychangeprocedure, break, GripperText, aImage, lRtl, ;
               TextHeight ) CLASS TCombo
*-----------------------------------------------------------------------------*
Local ControlHandle , rcount := 0 , BackRec , cset := 0 , WorkArea , cField

   DEFAULT w               TO 120
   DEFAULT h               TO 150
   DEFAULT changeprocedure TO ""
   DEFAULT gotfocus     TO ""
   DEFAULT lostfocus    TO ""
   DEFAULT rows         TO {}
   DEFAULT invisible    TO FALSE
   DEFAULT notabstop    TO FALSE
   DEFAULT sort		TO FALSE
   DEFAULT GripperText	TO ""
   ASSIGN ::nTextHeight VALUE TextHeight TYPE "N"

   ::SetForm( ControlName, ParentForm, FontName, FontSize, , , .t. , lRtl )
   ::SetFont( , , bold, italic, underline, strikeout )

	if ValType ( ItemSource ) != 'U' .And. Sort == .T.
      MsgOOHGError ("Sort and ItemSource clauses can't be used simultaneusly. Program Terminated" )
	EndIf

	if ValType ( ValueSource ) != 'U' .And. Sort == .T.
      MsgOOHGError ("Sort and ValueSource clauses can't be used simultaneusly. Program Terminated" )
	EndIf

	if valtype ( itemsource ) != 'U'
		if  at ( '>',ItemSource ) == 0
         MsgOOHGError ("Control: " + ControlName + " Of " + ParentForm + " : You must specify a fully qualified field name. Program Terminated" )
		Else
			WorkArea := Left ( ItemSource , at ( '>', ItemSource ) - 2 )
			cField := Right ( ItemSource , Len (ItemSource) - at ( '>', ItemSource ) )
		EndIf
	EndIf

	if valtype(value) == "U"
		value := 0
	endif

   ::SetSplitBoxInfo( Break, GripperText, w )
   ControlHandle := InitComboBox( ::ContainerhWnd, 0, x, y, w, '', 0, h, invisible, notabstop, sort, displaychange, ( "XP" $ OS() ), ::lRtl )

	if valtype(uEnter) == "U"
		uEnter := ""
	endif

   ::Register( ControlHandle, ControlName, HelpId, ! Invisible, ToolTip )
   ::SetFont()
   ::SizePos( y, x, w, h )

   ::Field :=  cField
   ::nValue   :=  Value
   ::WorkArea := WorkArea
   ::ValueSource :=  valuesource

   if valtype( aImage ) == "A"
      ::AddBitMap( aImage )
   EndIf

	If DisplayChange == .T.
*      _OOHG_acontrolrangemin [k] := FindWindowEx( Controlhandle , 0, "Edit", Nil )
	EndIf

   If  ValType( WorkArea ) $ "CM"

		If Select ( WorkArea ) != 0

			BackRec := (WorkArea)->(RecNo())

			(WorkArea)->(DBGoTop())

			Do While ! (WorkArea)->(Eof())
				rcount++
	        		if value == (WorkArea)->(RecNo())
					cset := rcount
				EndIf
				ComboAddString (ControlHandle, (WorkArea)->&(cField) )
				(WorkArea)->(DBSkip())
			EndDo

			(WorkArea)->(DBGoTo(BackRec))

			ComboSetCurSel (ControlHandle,cset)

		EndIf

	Else

      AEval( rows, { |x| ::AddItem( x ) } )

		if value <> 0
         ComboSetCurSel( ControlHandle, Value )
		endif

	EndIf

	if valtype ( ItemSource ) != 'U'
      aAdd( ::Parent:BrowseList, Self )
	EndIf

   ::OnClick := ondisplaychangeprocedure
   ::OnLostFocus := LostFocus
   ::OnGotFocus :=  GotFocus
   ::OnChange   :=  ChangeProcedure
   ::OnDblClick := uEnter

Return Self

*-----------------------------------------------------------------------------*
METHOD Refresh() CLASS TCombo
*-----------------------------------------------------------------------------*
Local BackRec , WorkArea , cField

   cField := ::Field

   WorkArea := ::WorkArea

	BackRec := (WorkArea)->(RecNo())

	(WorkArea)->(DBGoTop())

   ComboboxReset ( ::hWnd )

	Do While ! (WorkArea)->(Eof())
      ComboAddString ( ::hWnd, (WorkArea)->&(cField) )
		(WorkArea)->(DBSkip())
	EndDo

	(WorkArea)->(DBGoTo(BackRec))

Return nil

*-----------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TCombo
*-----------------------------------------------------------------------------*
Local WorkArea, BackRec, RCount, AuxVal
   IF VALTYPE( uValue ) == "N"

      If ValType ( ::WorkArea ) $ 'CM'
         ::nValue  := uValue
         WorkArea := ::WorkArea
		        rcount := 0
			BackRec := (WorkArea)->(RecNo())
			(WorkArea)->(DBGoTop())
			Do While ! (WorkArea)->(Eof())
				rcount++
               if uValue == (WorkArea)->(RecNo())
					Exit
				EndIf
				(WorkArea)->(DBSkip())
			EndDo
			(WorkArea)->(DBGoTo(BackRec))
         ComboSetCurSel( ::hWnd ,rcount)
		Else
         ComboSetCursel( ::hWnd , uValue )
		EndIf

   ELSEIF PCOUNT() > 0
*      MsgOOHGError('COMBOBOX: Value property wrong type (only numeric allowed). Program terminated')
   ENDIF

      If ValType ( ::WorkArea ) $ 'CM'

         auxval := ComboGetCursel ( ::hWnd )
			rcount := 0

         WorkArea := ::WorkArea

			BackRec := (WorkArea)->(RecNo())
			(WorkArea)->(DBGoTop())

			Do While ! (WorkArea)->(Eof())
				rcount++
            if rcount == auxval

               If Empty ( ::ValueSource )
                  uValue := (WorkArea)->(RecNo())
					Else
                  uValue := &( ::ValueSource )
					EndIf

				EndIf
				(WorkArea)->(DBSkip())
			EndDo

			(WorkArea)->(DBGoTo(BackRec))

		Else
         uValue := ComboGetCursel ( ::hWnd )
		EndIf

RETURN uValue

*-----------------------------------------------------------------------------*
METHOD Visible( lVisible ) CLASS TCombo
*-----------------------------------------------------------------------------*
   IF VALTYPE( lVisible ) == "L"
      ::Super:Visible := lVisible
      IF ! lVisible
         SendMessage( ::hWnd, 335, 0, 0 )
      ENDIF
   ENDIF
RETURN ::lVisible

*-----------------------------------------------------------------------------*
METHOD RefreshData() CLASS TCombo
*-----------------------------------------------------------------------------*
   ::Refresh()
   ::Value := ::nValue
RETURN nil

*-----------------------------------------------------------------------------*
METHOD Events_Command( wParam ) CLASS TCombo
*-----------------------------------------------------------------------------*
Local Hi_wParam := HIWORD( wParam )

   if Hi_wParam == CBN_SELCHANGE
      ::DoEvent( ::OnChange )
      Return nil

   elseif Hi_wParam == CBN_KILLFOCUS
      If ! ::ContainerReleasing
         ::DoEvent( ::OnLostFocus )
      Endif
      Return nil

   elseif Hi_wParam == CBN_SETFOCUS
      ::DoEvent( ::OnGotFocus )
      Return nil

   elseif Hi_wParam == CBN_EDITCHANGE
      ::DoEvent( ::OnClick )
      Return nil

   EndIf

Return ::Super:Events_Command( wParam )

#pragma BEGINDUMP
#include <hbapi.h>
#include <hbvm.h>
#include <hbstack.h>
#include <windows.h>
#include <commctrl.h>
#include <windowsx.h>
#include "../include/oohg.h"
#define s_Super s_TLabel

void TCombo_SetImageBuffer( POCTRL oSelf, struct IMAGE_PARAMETER pStruct, int nItem )
{
   BYTE *cBuffer;
   ULONG ulSize, ulSize2;
   int *pImage;

   if( oSelf->AuxBuffer || pStruct.iImage1 != -1 || pStruct.iImage2 != -1 )
   {
      if( nItem >= ( int ) oSelf->AuxBufferLen )
      {
         ulSize = sizeof( int ) * 2 * ( nItem + 100 );
         cBuffer = hb_xgrab( ulSize );
         memset( cBuffer, -1, ulSize );
         if( oSelf->AuxBuffer )
         {
            memcpy( cBuffer, oSelf->AuxBuffer, ( sizeof( int ) * 2 * oSelf->AuxBufferLen ) );
            hb_xfree( oSelf->AuxBuffer );
         }
         oSelf->AuxBuffer = cBuffer;
         oSelf->AuxBufferLen = nItem + 100;
      }

      pImage = &( ( int * ) oSelf->AuxBuffer )[ nItem * 2 ];
      if( nItem < ComboBox_GetCount( oSelf->hWnd ) )
      {
         ulSize  = sizeof( int ) * 2 * ComboBox_GetCount( oSelf->hWnd );
         ulSize2 = sizeof( int ) * 2 * nItem;
         cBuffer = hb_xgrab( ulSize );
         memcpy( cBuffer, pImage, ulSize - ulSize2 );
         memcpy( &pImage[ 2 ], cBuffer, ulSize - ulSize2 );
         hb_xfree( cBuffer );
      }
      pImage[ 0 ] = pStruct.iImage1;
      pImage[ 1 ] = pStruct.iImage2;
   }
}

HB_FUNC_STATIC( TCOMBO_EVENTS_DRAWITEM )   // METHOD Events_DrawItem( lParam )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   LPDRAWITEMSTRUCT lpdis = ( LPDRAWITEMSTRUCT ) hb_parnl( 1 );
   COLORREF FontColor, BackColor;
   TEXTMETRIC lptm;
   char cBuffer[ 2048 ];
   int x, y, cx, cy, iImage;

   if( lpdis->itemID != -1 )
   {
      // Checks if image defined for current item
      if( oSelf->ImageList && oSelf->AuxBuffer && ( lpdis->itemID + 1 ) <= oSelf->AuxBufferLen )
      {
         iImage = ( ( int * ) oSelf->AuxBuffer )[ ( lpdis->itemID * 2 ) + ( lpdis->itemState & ODS_SELECTED ? 1 : 0 ) ];
         if( iImage >= 0 && iImage < ImageList_GetImageCount( oSelf->ImageList ) )
         {
            ImageList_GetIconSize( oSelf->ImageList, &cx, &cy );
         }
         else
         {
            cx = 0;
            iImage = -1;
         }
      }
      else
      {
         cx = 0;
         iImage = -1;
      }

      // Text color
      if( lpdis->itemState & ODS_SELECTED )
      {
         FontColor = SetTextColor( lpdis->hDC, ( ( oSelf->lFontColorSelected == -1 ) ? GetSysColor( COLOR_HIGHLIGHTTEXT ) : oSelf->lFontColorSelected ) );
         BackColor = SetBkColor(   lpdis->hDC, ( ( oSelf->lBackColorSelected == -1 ) ? GetSysColor( COLOR_HIGHLIGHT )     : oSelf->lBackColorSelected ) );
      }
      else if( lpdis->itemState & ODS_DISABLED )
      {
         FontColor = SetTextColor( lpdis->hDC, GetSysColor( COLOR_GRAYTEXT ) );
         BackColor = SetBkColor(   lpdis->hDC, GetSysColor( COLOR_BTNFACE ) );
      }
      else
      {
         FontColor = SetTextColor( lpdis->hDC, ( ( oSelf->lFontColor == -1 ) ? GetSysColor( COLOR_WINDOWTEXT ) : oSelf->lFontColor ) );
         BackColor = SetBkColor(   lpdis->hDC, ( ( oSelf->lBackColor == -1 ) ? GetSysColor( COLOR_WINDOW )     : oSelf->lBackColor ) );
      }

      // Posición de la ventana...
      GetTextMetrics( lpdis->hDC, &lptm );
      y = ( lpdis->rcItem.bottom + lpdis->rcItem.top - lptm.tmHeight ) / 2;
      x = LOWORD( GetDialogBaseUnits() ) / 2;

      // Text
      SendMessage( lpdis->hwndItem, CB_GETLBTEXT, lpdis->itemID, ( LPARAM ) cBuffer );
      ExtTextOut( lpdis->hDC, cx + x, y, ETO_CLIPPED | ETO_OPAQUE, &lpdis->rcItem, ( LPCSTR ) cBuffer, strlen( cBuffer ), NULL );

      SetTextColor( lpdis->hDC, FontColor );
      SetBkColor( lpdis->hDC, BackColor );

      // Draws image
      if( iImage != -1 )
      {
         ImageList_Draw( oSelf->ImageList, iImage, lpdis->hDC, 0, y, 0 );
      }

      // Focused rectangle
      if( lpdis->itemState & ODS_FOCUS )
      {
         DrawFocusRect( lpdis->hDC, &lpdis->rcItem );
      }
   }
}

HB_FUNC_STATIC( TCOMBO_EVENTS_MEASUREITEM )   // METHOD Events_MeasureItem( lParam )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   LPMEASUREITEMSTRUCT lpmis = ( LPMEASUREITEMSTRUCT ) hb_parnl( 1 );

   HWND hWnd = GetActiveWindow();
   HDC hDC = GetDC( hWnd );
   HFONT hFont, hOldFont;
   SIZE sz;
   int iSize;

   // Checks for a pre-defined text size
   _OOHG_Send( pSelf, s_nTextHeight );
   hb_vmSend( 0 );
   iSize = hb_parni( -1 );
   if( ! iSize )
   {
      hFont = oSelf->hFontHandle;

      hOldFont = ( HFONT ) SelectObject( hDC, hFont );
      GetTextExtentPoint32( hDC, "_", 1, &sz );

      SelectObject( hDC, hOldFont );
      ReleaseDC( hWnd, hDC );

      iSize = sz.cy;
   }

   lpmis->itemHeight = iSize + 2;

   hb_retnl( 1 );
}

HB_FUNC_STATIC( TCOMBO_ADDITEM )   // METHOD AddItem( uValue )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   struct IMAGE_PARAMETER pStruct;
   int nItem = ComboBox_GetCount( oSelf->hWnd );

   ImageFillParameter( &pStruct, hb_param( 1, HB_IT_ANY ) );
   TCombo_SetImageBuffer( oSelf, pStruct, nItem );
   SendMessage( oSelf->hWnd, CB_INSERTSTRING, ( WPARAM ) nItem, ( LPARAM ) pStruct.cString );

   hb_retnl( ComboBox_GetCount( oSelf->hWnd ) );
}

HB_FUNC_STATIC( TCOMBO_DELETEITEM )   // METHOD DeleteItem( nItem )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   hb_retnl( SendMessage( oSelf->hWnd, CB_DELETESTRING, ( WPARAM ) hb_parni( 1 ) - 1, 0 ) );
}

HB_FUNC_STATIC( TCOMBO_DELETEALLITEMS )   // METHOD DeleteAllItems()
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   hb_retnl( SendMessage( oSelf->hWnd, CB_RESETCONTENT, 0, 0 ) );
}

HB_FUNC_STATIC( TCOMBO_ITEM )   // METHOD Item( nItem, uValue )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   PHB_ITEM pValue = hb_param( 2, HB_IT_ANY );
   int nItem = hb_parni( 1 ) - 1;
   char *cBuffer;
   struct IMAGE_PARAMETER pStruct;

   if( pValue && ( HB_IS_STRING( pValue ) || HB_IS_NUMERIC( pValue ) || HB_IS_ARRAY( pValue ) ) )
   {
      SendMessage( oSelf->hWnd, CB_DELETESTRING, ( WPARAM ) nItem, 0 );
      ImageFillParameter( &pStruct, pValue );
      TCombo_SetImageBuffer( oSelf, pStruct, nItem );
      SendMessage( oSelf->hWnd, CB_INSERTSTRING, ( WPARAM ) nItem, ( LPARAM ) pStruct.cString );
   }

   cBuffer = hb_xgrab( 2000 );
   SendMessage( oSelf->hWnd, CB_GETLBTEXT, ( WPARAM ) nItem, ( LPARAM ) cBuffer );
   hb_retc( cBuffer );
   hb_xfree( cBuffer );
}

HB_FUNC_STATIC( TCOMBO_ITEMCOUNT )   // METHOD ItemCount()
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   hb_retnl( SendMessage( oSelf->hWnd, CB_GETCOUNT, 0, 0 ) );
}

#pragma ENDDUMP
