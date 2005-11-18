/*
 * $Id: c_grid.c,v 1.12 2005-11-18 03:49:04 guerra000 Exp $
 */
/*
 * ooHG source code:
 * C grid functions
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

#define _WIN32_IE      0x0500
#define HB_OS_WIN_32_USED
#define _WIN32_WINNT   0x0400
#include <shlobj.h>

#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "winreg.h"
#include "tchar.h"
#include "../include/oohg.h"

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProc( GetControlObjectByHandle( ( LONG ) hWnd ), hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

HB_FUNC( INITLISTVIEW )
{
   HWND hwnd;
   HWND hbutton;
   int style, StyleEx;

   INITCOMMONCONTROLSEX  i;

   i.dwSize = sizeof( INITCOMMONCONTROLSEX );
   i.dwICC = ICC_DATE_CLASSES;
   InitCommonControlsEx( &i );

   hwnd = ( HWND ) hb_parnl( 1 );

   StyleEx = WS_EX_CLIENTEDGE;
   if ( hb_parl( 13 ) )
   {
      StyleEx |= WS_EX_LAYOUTRTL | WS_EX_RIGHTSCROLLBAR | WS_EX_RTLREADING;
   }

   style = LVS_SHOWSELALWAYS | WS_CHILD | WS_TABSTOP | WS_VISIBLE | LVS_REPORT;
   if ( hb_parl( 10 ) )
   {
      style = style | LVS_OWNERDATA;
   }

   hbutton = CreateWindowEx(StyleEx,"SysListView32","",
   ( style | hb_parni( 12 ) ),
   hb_parni(3), hb_parni(4) , hb_parni(5), hb_parni(6) ,
   hwnd,(HMENU)hb_parni(2) , GetModuleHandle(NULL) , NULL ) ;

   SendMessage(hbutton,LVM_SETEXTENDEDLISTVIEWSTYLE, 0, hb_parni(9) | LVS_EX_FULLROWSELECT | LVS_EX_HEADERDRAGDROP | LVS_EX_SUBITEMIMAGES );

   if ( hb_parl( 10 ) )
   {
      ListView_SetItemCount( hbutton , hb_parni( 11 ) ) ;
   }

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( ( HWND ) hbutton, GWL_WNDPROC, ( LONG ) SubClassFunc );

   hb_retnl ( (LONG) hbutton );

}

HB_FUNC( LISTVIEW_SETITEMCOUNT )
{
	ListView_SetItemCount ( (HWND) hb_parnl (1) , hb_parni (2) ) ;
}

HB_FUNC( LISTVIEW_GETFIRSTITEM )
{
   hb_retni( ListView_GetNextItem( ( HWND ) hb_parnl( 1 ), -1 , LVNI_ALL | LVNI_SELECTED ) + 1 );
}

HB_FUNC( INITLISTVIEWCOLUMNS )
{
   PHB_ITEM wArray;
   PHB_ITEM hArray;
   PHB_ITEM jArray;

   HWND hc;
   LV_COLUMN COL;
   int iLen;
   int s;
   int iColumn;

   hc = ( HWND ) hb_parnl( 1 );

   iLen = hb_parinfa( 2, 0 ) - 1;
   hArray = hb_param( 2, HB_IT_ARRAY );
   wArray = hb_param( 3, HB_IT_ARRAY );
   jArray = hb_param( 4, HB_IT_ARRAY );

   COL.mask = LVCF_FMT | LVCF_WIDTH | LVCF_TEXT | LVCF_SUBITEM;

   iColumn = 0;
   for( s = 0; s <= iLen; s++ )
   {
      COL.fmt = hb_itemGetNI( jArray->item.asArray.value->pItems + s );
      COL.cx = hb_itemGetNI( wArray->item.asArray.value->pItems + s );
      COL.pszText = hb_itemGetCPtr( hArray->item.asArray.value->pItems + s );
      COL.iSubItem = iColumn;
      ListView_InsertColumn( hc, iColumn, &COL );
      if( iColumn == 0 && COL.fmt != LVCFMT_LEFT )
      {
         iColumn++;
         COL.iSubItem = iColumn;
         ListView_InsertColumn( hc, iColumn, &COL );
      }
      iColumn++;
   }

   if( iColumn != s )
   {
      ListView_DeleteColumn( hc, 0 );
   }
}

static void _OOHG_ListView_FillItem( HWND hWnd, int nItem, PHB_ITEM pItems )
{
   LV_ITEM LI;
   ULONG s, ulLen;
   struct IMAGE_PARAMETER pStruct;

   ulLen = pItems->item.asArray.value->ulLen;
   pItems = pItems->item.asArray.value->pItems;

   for( s = 0; s < ulLen; s++ )
   {
      LI.mask = LVIF_TEXT | LVIF_IMAGE;
      LI.state = 0;
      LI.stateMask = 0;
      LI.iItem = nItem;
      LI.iSubItem = s;
      ImageFillParameter( &pStruct, pItems );
      LI.pszText = pStruct.cString;
      LI.iImage = pStruct.iImage1;
      ListView_SetItem( hWnd, &LI );
      pItems++;
   }
}

HB_FUNC( ADDLISTVIEWITEMS )
{
   PHB_ITEM hArray;
   LV_ITEM LI;
   HWND h;
   int l;
   int c;

   hArray = hb_param( 2, HB_IT_ARRAY );
   if( ! hArray || hArray->item.asArray.value->ulLen == 0 )
   {
      return;
   }
   h = ( HWND ) hb_parnl( 1 );
   c = ListView_GetItemCount( h );

   // First "default" item
   LI.mask = LVIF_TEXT | LVIF_IMAGE;
   LI.state = 0;
   LI.stateMask = 0;
   LI.iItem = c;
   LI.iSubItem = 0;
   LI.pszText = "";
   LI.iImage = -1;
   ListView_InsertItem( h, &LI );

   _OOHG_ListView_FillItem( h, c, hArray );
}

HB_FUNC (LISTVIEW_SETCURSEL)
{
	ListView_SetItemState((HWND) hb_parnl (1), (WPARAM) hb_parni(2)-1 ,LVIS_FOCUSED | LVIS_SELECTED , LVIS_FOCUSED | LVIS_SELECTED );
}

HB_FUNC ( LISTVIEWDELETESTRING )
{
	SendMessage( (HWND) hb_parnl( 1 ),LVM_DELETEITEM , (WPARAM) hb_parni(2)-1, 0);
}

HB_FUNC ( LISTVIEWRESET )
{
	SendMessage( (HWND) hb_parnl( 1 ), LVM_DELETEALLITEMS , 0, 0 );
}

HB_FUNC ( LISTVIEWGETMULTISEL )
{

	HWND hwnd = (HWND) hb_parnl(1) ;
	int i ;
	int n ;
	int j ;

	n = SendMessage( hwnd, LVM_GETSELECTEDCOUNT , 0, 0);

	hb_reta( n );

	i = -1 ;
	j = 0 ;

	while (1)
	{

		i = ListView_GetNextItem( (HWND) hb_parnl( 1 )  , i ,LVNI_ALL | LVNI_SELECTED) ;

		if ( i == -1 )
		{
			break ;
		}
		else
		{
			j++ ;
		}

		hb_storni( i + 1 , -1 , j );

	}

}

HB_FUNC ( LISTVIEWSETMULTISEL )
{

	PHB_ITEM wArray;

	HWND hwnd = (HWND) hb_parnl(1) ;

	int i ;
	int l ;
	int n ;

	wArray = hb_param( 2, HB_IT_ARRAY );

	l = hb_parinfa( 2, 0 ) - 1 ;

	n = SendMessage( hwnd , LVM_GETITEMCOUNT , 0 , 0 );

	// CLEAR CURRENT SELECTIONS

	for( i=0 ; i<n ; i++ )
	{
		ListView_SetItemState((HWND) hb_parnl (1), (WPARAM) i ,0 , LVIS_FOCUSED | LVIS_SELECTED );
	}

	// SET NEW SELECTIONS

	for ( i=0 ; i <= l ; i++ )
	{
		ListView_SetItemState( (HWND) hb_parnl (1), hb_itemGetNI ( wArray->item.asArray.value->pItems + i ) - 1  ,LVIS_FOCUSED | LVIS_SELECTED , LVIS_FOCUSED | LVIS_SELECTED ) ;
	}

}

HB_FUNC( LISTVIEWSETITEM )
{
   _OOHG_ListView_FillItem( ( HWND ) hb_parnl( 1 ), hb_parni( 3 ) - 1, hb_param( 2, HB_IT_ARRAY ) );
}

HB_FUNC ( LISTVIEWGETITEM )
{
   char buffer[ 1024 ];
   HWND h;
   int s, c, l;
   LV_ITEM LI;
   PHB_ITEM pArray, pString;

   h = ( HWND ) hb_parnl( 1 );

   c = hb_parni( 2 ) - 1;

   l = hb_parni( 3 );

   pArray = hb_itemArrayNew( l );
   pString = hb_itemNew( NULL );

   for( s = 0; s < l; s++ )
   {
      LI.mask = LVIF_TEXT | LVIF_IMAGE;
      LI.state = 0;
      LI.stateMask = 0;
      LI.iSubItem = s;
      LI.cchTextMax = 1022;
      LI.pszText = buffer;
      LI.iItem = c;
      buffer[ 0 ] = 0;
      buffer[ 1023 ] = 0;
      ListView_GetItem( h, &LI );
      buffer[ 1023 ] = 0;

      if( LI.iImage == -1 )
      {
         hb_itemPutC( pString, buffer );
      }
      else
      {
         hb_itemPutNI( pString, LI.iImage );
      }
      hb_itemArrayPut( pArray, s + 1, pString );
   }

   hb_itemReturn( pArray );
   hb_itemRelease( pArray );
   hb_itemRelease( pString );
}

HB_FUNC ( LISTVIEWGETITEMROW )
{
	POINT point;

	ListView_GetItemPosition ( (HWND) hb_parnl (1) , hb_parni (2) , &point ) ;

	hb_retnl ( point.y ) ;
}

HB_FUNC ( LISTVIEWGETITEMCOUNT )
{
	hb_retnl ( ListView_GetItemCount ( (HWND) hb_parnl (1) ) ) ;
}

HB_FUNC ( SETGRIDCOLOMNHEADER )
{

	LV_COLUMN COL;

	COL.mask = LVCF_FMT | LVCF_TEXT ;
	COL.fmt=LVCFMT_LEFT;
	COL.pszText=hb_parc(3) ;

	ListView_SetColumn ( (HWND) hb_parnl( 1 ) , hb_parni ( 2 ) - 1 , &COL );

}

HB_FUNC ( LISTVIEWGETCOUNTPERPAGE )
{
	hb_retnl ( ListView_GetCountPerPage ( (HWND) hb_parnl (1) ) ) ;
}

HB_FUNC (LISTVIEW_ENSUREVISIBLE)
{
	ListView_EnsureVisible( (HWND) hb_parnl (1) , hb_parni(2)-1 , 1 ) ;
}

HB_FUNC ( LISTVIEW_GETTOPINDEX )
{
	hb_retnl ( ListView_GetTopIndex ( (HWND) hb_parnl(1) ) ) ;
}

HB_FUNC ( LISTVIEW_REDRAWITEMS )
{
	hb_retnl ( ListView_RedrawItems ( (HWND) hb_parnl(1) , hb_parni(2) , hb_parni(3) ) ) ;
}

HB_FUNC ( LISTVIEW_HITTEST )
{

	POINT point ;
	LVHITTESTINFO lvhti;

	point.y = hb_parni(2) ;
	point.x = hb_parni(3) ;

	lvhti.pt = point;

	ListView_SubItemHitTest ( (HWND) hb_parnl (1) , &lvhti ) ;

	if(lvhti.flags & LVHT_ONITEM)
	{
		hb_reta( 2 );
		hb_storni( lvhti.iItem + 1 , -1, 1 );
		hb_storni( lvhti.iSubItem + 1 , -1, 2 );
	}
	else
	{
		hb_reta( 2 );
		hb_storni( 0 , -1, 1 );
		hb_storni( 0 , -1, 2 );
	}
}

HB_FUNC ( LISTVIEW_GETSUBITEMRECT )
{

	RECT Rect ;

	ListView_GetSubItemRect ( (HWND) hb_parnl (1) , hb_parni(2) , hb_parni(3) , LVIR_BOUNDS , &Rect ) ;

	hb_reta( 4 );
	hb_storni( Rect.top  , -1, 1 );
	hb_storni( Rect.left  , -1, 2 );
	hb_storni( Rect.right - Rect.left , -1, 3 );
	hb_storni( Rect.bottom - Rect.top  , -1, 4 );

}


HB_FUNC ( LISTVIEW_GETITEMRECT )
{

	RECT Rect ;

	ListView_GetItemRect ( (HWND) hb_parnl (1) , hb_parni(2) , &Rect , LVIR_LABEL ) ;

	hb_reta( 4 );
	hb_storni( Rect.top  , -1, 1 );
	hb_storni( Rect.left  , -1, 2 );
	hb_storni( Rect.right - Rect.left , -1, 3 );
	hb_storni( Rect.bottom - Rect.top  , -1, 4 );

}

HB_FUNC ( LISTVIEW_UPDATE )
{
	ListView_Update ( (HWND) hb_parnl (1) , hb_parni(2) - 1 );

}

HB_FUNC ( LISTVIEW_SCROLL )
{
	ListView_Scroll( (HWND) hb_parnl (1) , 	hb_parni(2)  , hb_parni(3) ) ;
}

HB_FUNC ( LISTVIEW_SETBKCOLOR )
{
	ListView_SetBkColor ( (HWND) hb_parnl (1) , (COLORREF) RGB(hb_parni(2), hb_parni(3), hb_parni(4)) ) ;
}

HB_FUNC ( LISTVIEW_SETTEXTBKCOLOR )
{
	ListView_SetTextBkColor ( (HWND) hb_parnl (1) , (COLORREF) RGB(hb_parni(2), hb_parni(3), hb_parni(4)) ) ;
}

HB_FUNC ( LISTVIEW_SETTEXTCOLOR )
{
	ListView_SetTextColor ( (HWND) hb_parnl (1) , (COLORREF) RGB(hb_parni(2), hb_parni(3), hb_parni(4)) ) ;
}

HB_FUNC ( LISTVIEW_GETTEXTCOLOR )
{
	hb_retnl ( ListView_GetTextColor ( (HWND) hb_parnl (1) ) ) ;
}

HB_FUNC( LISTVIEW_GETBKCOLOR )
{
    hb_retnl( ListView_GetBkColor ( ( HWND ) hb_parnl( 1 ) ) ) ;
}

HB_FUNC( LISTVIEW_GETCOLUMNWIDTH )
{
    hb_retni( ListView_GetColumnWidth( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ) ) );
}

HB_FUNC( LISTVIEW_SETCOLUMNWIDTH )
{
    HWND hWnd = ( HWND ) hb_parnl( 1 );
    int iColumn = hb_parni( 2 );

    ListView_SetColumnWidth( hWnd, iColumn, hb_parni( 3 ) );
    hb_retni( ListView_GetColumnWidth( hWnd, iColumn ) );
}

HB_FUNC( _OOHG_GRIDARRAYWIDTHS )
{
   HWND hWnd = ( HWND ) hb_parnl( 1 );
   PHB_ITEM pArray = hb_param( 2, HB_IT_ARRAY );
   ULONG iSum = 0, iCount, iSize;

   if( pArray )
   {
      for( iCount = 0; iCount < pArray->item.asArray.value->ulLen; iCount++ )
      {
         iSize = ListView_GetColumnWidth( hWnd, iCount );
         iSum += iSize;
         hb_storni( iSize, 2, iCount + 1 );
      }
   }

   hb_retni( iSum );
}

HB_FUNC( LISTVIEW_ADDCOLUMN )
{
   LV_COLUMN COL;
   int iColumn = hb_parni( 2 ) - 1;
   HWND hwnd = ( HWND ) hb_parnl( 1 );

   if( iColumn < 0 )
   {
      return;
   }

   COL.mask = LVCF_WIDTH | LVCF_TEXT | LVCF_FMT | LVCF_SUBITEM | LVCF_IMAGE;
   COL.cx = hb_parni( 3 );
   COL.pszText = hb_parc( 4 );
   COL.iSubItem = iColumn;
   COL.fmt = hb_parni( 5 ); // | LVCFMT_IMAGE;

   ListView_InsertColumn( hwnd, iColumn, &COL );
   if( iColumn == 0 && COL.fmt != LVCFMT_LEFT )
   {
      COL.iSubItem = 1;
      ListView_InsertColumn( hwnd, 1, &COL );
      ListView_DeleteColumn( hwnd, 0 );
   }

   if( ! hb_parl( 6 ) )
   {
      SendMessage( hwnd, LVM_DELETEALLITEMS , 0 , 0 );
      RedrawWindow( hwnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
   }
}

HB_FUNC( LISTVIEW_DELETECOLUMN )
{
   HWND hwnd = ( HWND ) hb_parnl( 1 );
   int iColumn = hb_parni( 2 ) - 1;

   if( iColumn < 0 )
   {
      return;
   }

   ListView_DeleteColumn( hwnd, iColumn );

   if( ! hb_parl( 3 ) )
   {
      SendMessage( hwnd, LVM_DELETEALLITEMS , 0 , 0 );
      RedrawWindow( hwnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
   }
}

HB_FUNC( GETGRIDVKEY )
{
   hb_retnl( ( LPARAM ) ( ( ( LV_KEYDOWN * ) hb_parnl( 1 ) ) -> wVKey ) );
}

static int TGrid_Notify_CustomDraw_GetColor( PHB_ITEM pSelf, unsigned int x, unsigned int y, int sGridColor, int sObjColor, int iDefaultColor )
{
   PHB_ITEM pColor;
   HB_ITEM pRet;
   LONG iColor;

   _OOHG_Send( pSelf, sGridColor );
   hb_vmSend( 0 );

   pColor = hb_param( -1, HB_IT_ARRAY );
   if( pColor &&                                                 // ValType( aColor ) == "A"
       pColor->item.asArray.value->ulLen >= y &&                       // Len( aColor ) >= y
       HB_IS_ARRAY( &pColor->item.asArray.value->pItems[ y - 1 ] ) &&   // ValType( aColor[ y ] ) == "A"
       pColor->item.asArray.value->pItems[ y - 1 ].item.asArray.value->ulLen >= x )   // Len( aColor[ y ] ) >= x
   {
      pColor = &pColor->item.asArray.value->pItems[ y - 1 ].item.asArray.value->pItems[ x - 1 ];
   }
   else
   {
      pColor = NULL;
   }

   iColor = -1;

   if( ! _OOHG_DetermineColor( pColor, &iColor ) || iColor == -1 )
   {
      _OOHG_Send( pSelf, sObjColor );
      hb_vmSend( 0 );
      if( ! _OOHG_DetermineColor( hb_param( -1, HB_IT_ANY ), &iColor ) || iColor == -1 )
      {
         iColor = GetSysColor( iDefaultColor );
      }
   }

   return iColor;
}

int TGrid_Notify_CustomDraw( PHB_ITEM pSelf, LPARAM lParam )
{
   LPNMLVCUSTOMDRAW lplvcd;
   int x, y;

   lplvcd = ( LPNMLVCUSTOMDRAW ) lParam;

   if( lplvcd->nmcd.dwDrawStage == CDDS_PREPAINT )
   {
      return CDRF_NOTIFYITEMDRAW;
   }
   else if( lplvcd->nmcd.dwDrawStage == CDDS_ITEMPREPAINT )
   {
      return CDRF_NOTIFYSUBITEMDRAW;
   }
   else if( ! ( lplvcd->nmcd.dwDrawStage == CDDS_SUBITEM | CDDS_ITEMPREPAINT ) )
   {
      return CDRF_DODEFAULT;
   }

   x = lplvcd->iSubItem + 1;
   y = lplvcd->nmcd.dwItemSpec + 1;

   lplvcd->clrText   = TGrid_Notify_CustomDraw_GetColor( pSelf, x, y, s_GridForeColor, s_FontColor, COLOR_WINDOWTEXT );
   lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetColor( pSelf, x, y, s_GridBackColor, s_BackColor, COLOR_WINDOW );

   return CDRF_NEWFONT;
}

HB_FUNC( TGRID_NOTIFY_CUSTOMDRAW )
{
   hb_retni( TGrid_Notify_CustomDraw( hb_param( 1, HB_IT_OBJECT ), ( LPARAM ) hb_parnl( 2 ) ) );
}

HB_FUNC( FILLGRIDFROMARRAY )
{
   HWND hWnd = ( HWND ) hb_parnl( 1 );
   ULONG iCount = ListView_GetItemCount( hWnd );
   PHB_ITEM pScreen = hb_param( 2, HB_IT_ARRAY );
   ULONG iLen = pScreen->item.asArray.value->ulLen;
   LV_ITEM LI;

   while( iCount > iLen )
   {
      iCount--;
      SendMessage( hWnd, LVM_DELETEITEM, ( WPARAM ) iCount, 0 );
   }
   while( iCount < iLen )
   {
      LI.mask = LVIF_TEXT | LVIF_IMAGE;
      LI.state = 0;
      LI.stateMask = 0;
      LI.iItem = iCount;
      LI.iSubItem = 0;
      LI.pszText = "";
      LI.iImage = -1;
      ListView_InsertItem( hWnd, &LI );
      iCount++;
   }

   pScreen = pScreen->item.asArray.value->pItems;
   for( iCount = 0; iCount < iLen; iCount++ )
   {
      _OOHG_ListView_FillItem( hWnd, iCount, pScreen );
      pScreen++;
   }
}