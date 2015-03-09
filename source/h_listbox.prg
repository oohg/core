/*
 * $Id: h_listbox.prg,v 1.31 2015-03-09 02:52:08 fyurisich Exp $
 */
/*
 * ooHG source code:
 * PRG listbox functions
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
#include "common.ch"
#include "hbclass.ch"
#include "i_windefs.ch"

CLASS TList FROM TControl
   DATA Type                  INIT "LIST" READONLY
   DATA nWidth                INIT 120
   DATA nHeight               INIT 120
   DATA nTextHeight           INIT 0
   DATA bOnEnter              INIT nil
   DATA lAdjustImages         INIT .F.
   DATA ImageListColor        INIT CLR_DEFAULT
   DATA ImageListFlags        INIT LR_LOADTRANSPARENT + LR_DEFAULTCOLOR + LR_LOADMAP3DCOLORS

   METHOD Define
   METHOD Define2
   METHOD Value               SETGET
   METHOD OnEnter             SETGET
   METHOD Events
   METHOD Events_Command
   METHOD Events_DrawItem
   METHOD Events_MeasureItem
   METHOD AddItem(uValue)     BLOCK { |Self,uValue| ListBoxAddstring2( Self, uValue ) }
   METHOD DeleteItem(nItem)   BLOCK { |Self,nItem| ListBoxDeleteString( ::hWnd, nItem ) }
   METHOD DeleteAllItems      BLOCK { | Self | ListBoxReset( ::hWnd ) }
   METHOD Item
   METHOD InsertItem
   METHOD ItemCount           BLOCK { | Self | ListBoxGetItemCount( ::hWnd ) }
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, rows, value, fontname, ;
               fontsize, tooltip, changeprocedure, dblclick, gotfocus, ;
               lostfocus, break, HelpId, invisible, notabstop, sort, bold, ;
               italic, underline, strikeout, backcolor, fontcolor, lRtl, ;
               lDisabled, onenter, aImage, TextHeight, lAdjustImages, ;
               novscroll ) CLASS TList
*-----------------------------------------------------------------------------*
Local nStyle := 0
   ::Define2( ControlName, ParentForm, x, y, w, h, rows, value, fontname, ;
              fontsize, tooltip, changeprocedure, dblclick, gotfocus, ;
              lostfocus, break, HelpId, invisible, notabstop, sort, bold, ;
              italic, underline, strikeout, backcolor, fontcolor, nStyle, ;
              lRtl, lDisabled, onenter, aImage, TextHeight, lAdjustImages, ;
              novscroll )
Return Self

*-----------------------------------------------------------------------------*
METHOD Define2( ControlName, ParentForm, x, y, w, h, rows, value, fontname, ;
                fontsize, tooltip, changeprocedure, dblclick, gotfocus, ;
                lostfocus, break, HelpId, invisible, notabstop, sort, bold, ;
                italic, underline, strikeout, backcolor, fontcolor, nStyle, ;
                lRtl, lDisabled, onenter, aImage, TextHeight, lAdjustImages, ;
                novscroll ) CLASS TList
*-----------------------------------------------------------------------------*
Local ControlHandle

   ASSIGN ::nWidth        VALUE w             TYPE "N"
   ASSIGN ::nHeight       VALUE h             TYPE "N"
   ASSIGN ::nRow          VALUE y             TYPE "N"
   ASSIGN ::nCol          VALUE x             TYPE "N"
   ASSIGN ::nTextHeight   VALUE TextHeight    TYPE "N"
   ASSIGN ::lAdjustImages VALUE lAdjustImages TYPE "L"

   ::SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor, .T., lRtl )

   nStyle := ::InitStyle( nStyle,, invisible, notabstop, lDisabled ) + ;
             If( HB_ISLOGICAL( novscroll ) .AND. novscroll, 0, WS_VSCROLL + LBS_DISABLENOSCROLL ) + ;
             If( HB_ISLOGICAL( sort ) .AND. sort, LBS_SORT, 0 ) + ;
             If( HB_IsArray( aImage ),  LBS_OWNERDRAWFIXED, 0)

   ::SetSplitBoxInfo( Break )
   ControlHandle := InitListBox( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, nStyle, ::lRtl )

   ::Register( ControlHandle, ControlName, HelpId, , ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   If HB_IsArray( aImage )
      ::AddBitMap( aImage )
   EndIf

   If HB_IsArray( rows )
      AEVAL( rows, { |c| ListboxAddString2( Self, c ) } )
   EndIf

   ::Value := Value

   ASSIGN ::OnLostFocus VALUE lostfocus  TYPE "B"
   ASSIGN ::OnGotFocus  VALUE gotfocus   TYPE "B"
   ASSIGN ::OnChange    VALUE ChangeProcedure TYPE "B"
   ASSIGN ::OnDblClick  VALUE dblclick   TYPE "B"
   ASSIGN ::OnEnter     value onenter    TYPE "B"

Return Self

*------------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TList
*------------------------------------------------------------------------------*
   IF VALTYPE( uValue ) == "N"
      ListBoxSetCursel( ::hWnd, uValue )
      ::DoChange()
   ENDIF
RETURN ListBoxGetCursel( ::hWnd )

*-----------------------------------------------------------------------------*
METHOD OnEnter( bEnter ) CLASS TList
*-----------------------------------------------------------------------------*
LOCAL bRet
   IF HB_IsBlock( bEnter )
      IF _OOHG_SameEnterDblClick
         ::OnDblClick := bEnter
      ELSE
         ::bOnEnter := bEnter
      ENDIF
      bRet := bEnter
   ELSE
      bRet := IF( _OOHG_SameEnterDblClick, ::OnDblClick, ::bOnEnter )
   ENDIF
RETURN bRet

*-----------------------------------------------------------------------------*
METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TList
*-----------------------------------------------------------------------------*
   If nMsg == WM_LBUTTONDBLCLK
      Return nil
   EndIf
RETURN ::Super:Events( hWnd, nMsg, wParam, lParam )

*-----------------------------------------------------------------------------*
METHOD Events_Command( wParam ) CLASS TList
*-----------------------------------------------------------------------------*
Local Hi_wParam := HIWORD( wParam )

   if Hi_wParam == LBN_SELCHANGE
      ::DoChange()
      Return nil

   elseif Hi_wParam == LBN_KILLFOCUS
      Return ::DoLostFocus()

   elseif Hi_wParam == LBN_SETFOCUS
      ::DoEvent( ::OnGotFocus, "GOTFOCUS" )
      Return nil

   elseif Hi_wParam == LBN_DBLCLK
      ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
      Return nil

   EndIf

Return ::Super:Events_Command( wParam )

*-----------------------------------------------------------------------------*
METHOD Item( nItem, uValue ) CLASS TList
*-----------------------------------------------------------------------------*
   IF VALTYPE( uValue ) $ "CM"
      ListBoxDeleteString( ::hWnd, nItem )
      ListBoxInsertString2( Self, uValue, nItem )
   ENDIF
Return ListBoxGetString( ::hWnd, nItem )

*-----------------------------------------------------------------------------*
METHOD InsertItem( nItem, uValue ) CLASS TList
*-----------------------------------------------------------------------------*
   IF VALTYPE( uValue ) $ "CM"
      ListBoxInsertString2( Self, uValue, nItem )
   ENDIF
Return ListBoxGetString( ::hWnd, nItem )





CLASS TListMulti FROM TList
   DATA Type      INIT "MULTILIST" READONLY

   METHOD Define
   METHOD Value   SETGET
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, rows, value, fontname, ;
               fontsize, tooltip, changeprocedure, dblclick, gotfocus, ;
               lostfocus, break, HelpId, invisible, notabstop, sort, bold, ;
               italic, underline, strikeout, backcolor, fontcolor, lRtl, ;
               lDisabled, onenter, aImage, TextHeight, lAdjustImages, ;
               novscroll ) CLASS TListMulti
*-----------------------------------------------------------------------------*
Local nStyle := LBS_EXTENDEDSEL + LBS_MULTIPLESEL

   ::Define2( ControlName, ParentForm, x, y, w, h, rows, value, fontname, ;
              fontsize, tooltip, changeprocedure, dblclick, gotfocus, ;
              lostfocus, break, HelpId, invisible, notabstop, sort, bold, ;
              italic, underline, strikeout, backcolor, fontcolor, nStyle, ;
              lRtl, lDisabled, onenter, aImage, TextHeight, lAdjustImages, ;
              novscroll )
Return Self

*------------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TListMulti
*------------------------------------------------------------------------------*
   IF VALTYPE( uValue ) == "A"
      LISTBOXSETMULTISEL( ::hWnd, uValue )
   ELSEIF VALTYPE( uValue ) == "N"
      LISTBOXSETMULTISEL( ::hWnd, { uValue } )
   ENDIF
RETURN ListBoxGetMultiSel( ::hWnd )

#pragma BEGINDUMP
#include <windows.h>
#include <commctrl.h>
#include <hbapi.h>
#include <hbvm.h>
#include <hbstack.h>
#include <windowsx.h>
#include "oohg.h"

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

HB_FUNC( INITLISTBOX )
{
 HWND hwnd;
 HWND hbutton;
   int Style = WS_CHILD | LBS_NOTIFY | LBS_NOINTEGRALHEIGHT | LBS_HASSTRINGS | hb_parni( 7 );
   int StyleEx;

   hwnd = HWNDparam( 1 );

   StyleEx = WS_EX_CLIENTEDGE | _OOHG_RTL_Status( hb_parl( 8 ) );

   hbutton = CreateWindowEx( StyleEx, "LISTBOX", "", Style,
                             hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ),
                             hwnd, ( HMENU ) hb_parni( 2 ), GetModuleHandle( NULL ), NULL );

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( ( HWND ) hbutton, GWL_WNDPROC, ( LONG ) SubClassFunc );

   HWNDret( hbutton );
}

void TList_SetImageBuffer( POCTRL oSelf, struct IMAGE_PARAMETER pStruct, int nItem )
{
   BYTE *cBuffer;
   ULONG ulSize, ulSize2;
   int *pImage;

   if( oSelf->AuxBuffer || pStruct.iImage1 != -1 || pStruct.iImage2 != -1 )
   {
      if( nItem >= ( int ) oSelf->AuxBufferLen )
      {
         ulSize = sizeof( int ) * 2 * ( nItem + 100 );
         cBuffer = (BYTE *) hb_xgrab( ulSize );
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
      if( nItem < ListBox_GetCount( oSelf->hWnd ) )
      {
         ulSize  = sizeof( int ) * 2 * ListBox_GetCount( oSelf->hWnd );
         ulSize2 = sizeof( int ) * 2 * nItem;
         cBuffer = (BYTE *) hb_xgrab( ulSize );
         memcpy( cBuffer, pImage, ulSize - ulSize2 );
         memcpy( &pImage[ 2 ], cBuffer, ulSize - ulSize2 );
         hb_xfree( cBuffer );
      }
      pImage[ 0 ] = pStruct.iImage1;
      pImage[ 1 ] = pStruct.iImage2;
   }
}

HB_FUNC( LISTBOXADDSTRING )
{
   char *cString = ( char * ) hb_parc( 2 );
   SendMessage( HWNDparam( 1 ), LB_ADDSTRING, 0, (LPARAM) cString );
}

HB_FUNC( LISTBOXADDSTRING2 )
{
   PHB_ITEM pSelf = (PHB_ITEM) hb_param( 1, HB_IT_ANY );
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   struct IMAGE_PARAMETER pStruct;
   int nItem = ListBox_GetCount( oSelf->hWnd );

   ImageFillParameter( &pStruct, hb_param( 2, HB_IT_ANY ) );
   TList_SetImageBuffer( oSelf, pStruct, nItem );
   SendMessage( oSelf->hWnd, LB_ADDSTRING, 0, ( LPARAM ) pStruct.cString );
}

HB_FUNC( LISTBOXGETSTRING )
{
   char cString [1024] = "" ;
   SendMessage( HWNDparam( 1 ), LB_GETTEXT, (WPARAM) hb_parni(2) - 1, (LPARAM) cString );
   hb_retc(cString);
}

HB_FUNC( LISTBOXINSERTSTRING )
{
   char *cString = ( char * ) hb_parc( 2 );
   SendMessage( HWNDparam( 1 ), LB_INSERTSTRING, (WPARAM) hb_parni(3) - 1 , (LPARAM) cString );
}

HB_FUNC( LISTBOXINSERTSTRING2 )
{
   PHB_ITEM pSelf = (PHB_ITEM) hb_param( 1, HB_IT_ANY );
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   PHB_ITEM pValue = hb_param( 2, HB_IT_ANY );
   int nItem = hb_parni( 3 ) - 1;
   struct IMAGE_PARAMETER pStruct;

   ImageFillParameter( &pStruct, pValue );
   TList_SetImageBuffer( oSelf, pStruct, nItem );
   SendMessage( oSelf->hWnd, LB_INSERTSTRING, ( WPARAM ) nItem, ( LPARAM ) pStruct.cString );
}

HB_FUNC( LISTBOXSETCURSEL )
{
   SendMessage( HWNDparam( 1 ), LB_SETCURSEL, (WPARAM) hb_parni(2)-1, 0);
}

HB_FUNC( LISTBOXGETCURSEL )
{
   hb_retni( SendMessage( HWNDparam( 1 ), LB_GETCURSEL, 0, 0 )  + 1 );
}

HB_FUNC( LISTBOXDELETESTRING )
{
   SendMessage( HWNDparam( 1 ), LB_DELETESTRING, ( WPARAM ) hb_parni( 2 ) - 1, 0);
}

HB_FUNC( LISTBOXRESET )
{
   SendMessage( HWNDparam( 1 ), LB_RESETCONTENT, 0, 0 );
}

HB_FUNC( LISTBOXGETMULTISEL )
{
   HWND hwnd = HWNDparam( 1 );
   int i;
   int *buffer;
   int n;

 n = SendMessage( hwnd, LB_GETSELCOUNT, 0, 0);

   if( n > 0 )
 {
      hb_reta( n );
      buffer = (int *) hb_xgrab( ( n + 1 ) * sizeof( int ) );

      SendMessage( hwnd, LB_GETSELITEMS, ( WPARAM ) n, ( LPARAM ) buffer );

      for( i = 0; i < n; i++ )
      {
       HB_STORNI( (buffer[ i ] + 1), -1, (i + 1));
      }

      hb_xfree( buffer );
 }
   else
   {
      hb_reta( 0 );
   }
}

HB_FUNC( LISTBOXSETMULTISEL )
{
 PHB_ITEM wArray;
   HWND hwnd = HWNDparam( 1 );
   int i;
   int n;
   int l;

 wArray = hb_param( 2, HB_IT_ARRAY );

   l = hb_parinfa( 2, 0 );

 n = SendMessage( hwnd , LB_GETCOUNT , 0 , 0 );

 // CLEAR CURRENT SELECTIONS

 for( i=0 ; i<n ; i++ )
 {
  SendMessage(hwnd, LB_SETSEL, (WPARAM)(0), (LPARAM) i );
 }

   // SET NEW SELECTIONS

   for( i = 1; i <= l ; i++ )
   {
      SendMessage( hwnd, LB_SETSEL, ( WPARAM ) 1, ( LPARAM ) ( hb_arrayGetNI( wArray, i ) ) - 1 );
   }
}

HB_FUNC( LISTBOXGETITEMCOUNT )
{
   hb_retnl( SendMessage( HWNDparam( 1 ), LB_GETCOUNT, 0, 0 ) );
}

HB_FUNC_STATIC( TLIST_EVENTS_DRAWITEM )   // METHOD Events_DrawItem( lParam )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   LPDRAWITEMSTRUCT lpdis = ( LPDRAWITEMSTRUCT ) hb_parnl( 1 );
   COLORREF FontColor, BackColor;
   TEXTMETRIC lptm;
   char cBuffer[ 2048 ];
   int x, y, cx, cy, iImage, dy;

   if( lpdis->itemID != (UINT) -1 )
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
            cy = 0;
            iImage = -1;
         }
      }
      else
      {
         cx = 0;
         cy = 0;
         iImage = -1;
      }

      // Text color
      if( lpdis->itemState & ODS_SELECTED )
      {
         FontColor = SetTextColor( lpdis->hDC, ( ( oSelf->lFontColorSelected == -1 ) ? GetSysColor( COLOR_HIGHLIGHTTEXT ) : (COLORREF) oSelf->lFontColorSelected ) );
         BackColor = SetBkColor(   lpdis->hDC, ( ( oSelf->lBackColorSelected == -1 ) ? GetSysColor( COLOR_HIGHLIGHT )     : (COLORREF) oSelf->lBackColorSelected ) );
      }
      else if( lpdis->itemState & ODS_DISABLED )
      {
         FontColor = SetTextColor( lpdis->hDC, GetSysColor( COLOR_GRAYTEXT ) );
         BackColor = SetBkColor(   lpdis->hDC, GetSysColor( COLOR_BTNFACE ) );
      }
      else
      {
         FontColor = SetTextColor( lpdis->hDC, ( ( oSelf->lFontColor == -1 ) ? GetSysColor( COLOR_WINDOWTEXT ) : (COLORREF) oSelf->lFontColor ) );
         BackColor = SetBkColor(   lpdis->hDC, ( ( oSelf->lBackColor == -1 ) ? GetSysColor( COLOR_WINDOW )     : (COLORREF) oSelf->lBackColor ) );
      }

      // Window position
      GetTextMetrics( lpdis->hDC, &lptm );
      y = ( lpdis->rcItem.bottom + lpdis->rcItem.top - lptm.tmHeight ) / 2;
      x = LOWORD( GetDialogBaseUnits() ) / 2;

      // Text
      SendMessage( lpdis->hwndItem, LB_GETTEXT, lpdis->itemID, ( LPARAM ) cBuffer );
      ExtTextOut( lpdis->hDC, cx + x, y, ETO_CLIPPED | ETO_OPAQUE, &lpdis->rcItem, ( LPCSTR ) cBuffer, strlen( cBuffer ), NULL );

      SetTextColor( lpdis->hDC, FontColor );
      SetBkColor( lpdis->hDC, BackColor );

      // Draws image vertically centered
      if( iImage != -1 )
      {
         if( cy < lpdis->rcItem.bottom - lpdis->rcItem.top )                   // there is spare space
         {
            y = ( lpdis->rcItem.bottom + lpdis->rcItem.top - cy ) / 2;         // center image
            dy = cy;                                                           // use real size
         }
         else
         {
            y = lpdis->rcItem.top;                                             // place image at top

            _OOHG_Send( pSelf, s_lAdjustImages );
            hb_vmSend( 0 );

            if( hb_parl( -1 ) )
            {
               dy = ( lpdis->rcItem.bottom - lpdis->rcItem.top );              // clip exceeding pixels or stretch image
            }
            else
            {
               dy = cy;                                                        // use real size
            }
         }

         ImageList_DrawEx( oSelf->ImageList, iImage, lpdis->hDC, 0, y, cx, dy, CLR_DEFAULT, CLR_NONE, ILD_NORMAL );
      }

      // Focused rectangle
      if( lpdis->itemState & ODS_FOCUS )
      {
         DrawFocusRect( lpdis->hDC, &lpdis->rcItem );
      }
   }
}

HB_FUNC_STATIC( TLIST_EVENTS_MEASUREITEM )   // METHOD Events_MeasureItem( lParam )
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

   hFont = oSelf->hFontHandle;

   hOldFont = ( HFONT ) SelectObject( hDC, hFont );
   GetTextExtentPoint32( hDC, "_", 1, &sz );

   SelectObject( hDC, hOldFont );
   ReleaseDC( hWnd, hDC );

   if( iSize < sz.cy + 2 )
   {
      iSize = sz.cy + 2;
   }

   lpmis->itemHeight = iSize;

   hb_retnl( 1 );
}

#pragma ENDDUMP
