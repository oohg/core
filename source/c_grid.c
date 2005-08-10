/*
 * $Id: c_grid.c,v 1.2 2005-08-10 04:56:26 guerra000 Exp $
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

HB_FUNC (INITLISTVIEW)
{
	HWND hwnd;
	HWND hbutton;
	int style ;

	INITCOMMONCONTROLSEX  i;

	i.dwSize = sizeof(INITCOMMONCONTROLSEX);
	i.dwICC = ICC_DATE_CLASSES;
	InitCommonControlsEx(&i);

	hwnd = (HWND) hb_parnl (1);

	if ( hb_parl (12) )
	{
		style = LVS_SHOWSELALWAYS | WS_CHILD | WS_TABSTOP | WS_VISIBLE | LVS_REPORT ;
	}
	else
	{
		style = LVS_SHOWSELALWAYS | WS_CHILD | WS_TABSTOP | WS_VISIBLE | LVS_REPORT | LVS_SINGLESEL ;
	}

	if ( hb_parl (10) )
	{
	        style = style | LVS_OWNERDATA ;
	}

	hbutton = CreateWindowEx(WS_EX_CLIENTEDGE,"SysListView32","",
	style ,
	hb_parni(3), hb_parni(4) , hb_parni(5), hb_parni(6) ,
	hwnd,(HMENU)hb_parni(2) , GetModuleHandle(NULL) , NULL ) ;

	SendMessage(hbutton,LVM_SETEXTENDEDLISTVIEWSTYLE, 0, hb_parni(9) | LVS_EX_FULLROWSELECT | LVS_EX_HEADERDRAGDROP );

	if ( hb_parl (10) )
	{
		ListView_SetItemCount ( hbutton , hb_parni (11) ) ;
	}

	hb_retnl ( (LONG) hbutton );

}

HB_FUNC( LISTVIEW_SETITEMCOUNT )
{
	ListView_SetItemCount ( (HWND) hb_parnl (1) , hb_parni (2) ) ;
}

HB_FUNC (ADDLISTVIEWBITMAP)// Grid+
{
	HWND hbutton;
	HIMAGELIST himl;
	HBITMAP hbmp;
	PHB_ITEM hArray;
	char *caption;
	int l9;
	int s;
	int cx;
	int cy;

	hbutton = (HWND) hb_parnl (1);
	l9 = hb_parinfa( 2, 0 ) - 1 ;
	hArray = hb_param( 2, HB_IT_ARRAY );

		cx = 0;
	if ( l9 != 0 )
		{
			caption	= hb_itemGetCPtr ( hArray->item.asArray.value->pItems );

	 		himl = ImageList_LoadImage( GetModuleHandle(NULL), caption, 0, l9, CLR_NONE, IMAGE_BITMAP, LR_LOADTRANSPARENT );

			if ( himl == NULL )
			{
		 		himl = ImageList_LoadImage( GetModuleHandle(NULL), caption, 0, l9, CLR_NONE, IMAGE_BITMAP, LR_LOADTRANSPARENT | LR_LOADFROMFILE );
			}

	 		ImageList_GetIconSize( himl, &cx, &cy );

			for (s = 1 ; s<=l9 ; s=s+1 )
			{

				caption	= hb_itemGetCPtr ( hArray->item.asArray.value->pItems + s );

	 			hbmp = (HBITMAP) LoadImage(GetModuleHandle(NULL),caption,IMAGE_BITMAP , cx, cy, LR_LOADTRANSPARENT );
				if ( hbmp == NULL)
				{
		 			hbmp = (HBITMAP) LoadImage(GetModuleHandle(NULL),caption,IMAGE_BITMAP , cx, cy, LR_LOADTRANSPARENT | LR_LOADFROMFILE );
				}

	 			ImageList_Add( himl, hbmp, NULL ) 						;
				DeleteObject( hbmp ) ;

			}


			if ( himl != NULL )
			{
				SendMessage(hbutton,LVM_SETIMAGELIST, (WPARAM) LVSIL_SMALL, (LPARAM) himl );
			}

		}

		hb_retni( (INT) cx );

}


HB_FUNC ( LISTVIEW_GETFIRSTITEM )
{
	hb_retni ( ListView_GetNextItem( (HWND) hb_parnl( 1 )  , -1 ,LVNI_ALL | LVNI_SELECTED) + 1);
}


HB_FUNC ( INITLISTVIEWCOLUMNS )
{
	PHB_ITEM wArray;
	PHB_ITEM hArray;
	PHB_ITEM jArray;

	char *caption;
	HWND hc;
	LV_COLUMN COL;
	int l9;
	int s;
	int vi;

	hc = (HWND) hb_parnl( 1 ) ;

	l9 = hb_parinfa( 2, 0 ) - 1 ;
	hArray = hb_param( 2, HB_IT_ARRAY );
	wArray = hb_param( 3, HB_IT_ARRAY );
	jArray = hb_param( 4, HB_IT_ARRAY );


	COL.mask=LVCF_FMT | LVCF_WIDTH | LVCF_TEXT |LVCF_SUBITEM;
	//COL.fmt=LVCFMT_LEFT; // Browse+

	for (s = 0 ; s<=l9 ; s=s+1 )
		{

		caption	= hb_itemGetCPtr ( hArray->item.asArray.value->pItems + s );
		vi = hb_itemGetNI   ( wArray->item.asArray.value->pItems + s );
		COL.fmt= hb_itemGetNI   ( jArray->item.asArray.value->pItems + s );	// Browse+

		COL.cx=vi;
		COL.pszText=caption;
		COL.iSubItem=s;
		ListView_InsertColumn(hc,s,&COL);

		}

}


HB_FUNC ( ADDLISTVIEWITEMS )
{
	PHB_ITEM hArray;
	char *caption;
	LV_ITEM LI;
	HWND h;
	int l;
	int s;
	int c;

	h = (HWND) hb_parnl( 1 ) ;
	l = hb_parinfa( 2, 0 ) - 1 ;
	hArray = hb_param( 2, HB_IT_ARRAY );
	c = ListView_GetItemCount (h);
	caption	= hb_itemGetCPtr ( hArray->item.asArray.value->pItems );

	LI.mask=LVIF_TEXT | LVIF_IMAGE ;	// Browse+
	LI.state=0;
	LI.stateMask=0;
        LI.iImage=hb_parni( 3 );	// Browse+
        LI.iSubItem=0;
	LI.iItem=c;
	LI.pszText=caption;
	ListView_InsertItem(h,&LI);

	for (s = 1 ; s<=l ; s=s+1 )
	{
		caption	= hb_itemGetCPtr ( hArray->item.asArray.value->pItems + s );
		ListView_SetItemText(h,c,s,caption);
	}

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

HB_FUNC ( LISTVIEWSETITEM )
{
	PHB_ITEM hArray;
	char *caption;
	HWND h;
	int l;
	int s;
	int c;

	h = (HWND) hb_parnl( 1 ) ;
	l = hb_parinfa( 2, 0 ) - 1 ;
	hArray = hb_param( 2, HB_IT_ARRAY );
	c = hb_parni(3) - 1 ;

	for (s = 0 ; s<=l ; s=s+1 )
	{
		caption	= hb_itemGetCPtr ( hArray->item.asArray.value->pItems + s );
		ListView_SetItemText(h,c,s,caption);
	}
}

HB_FUNC ( LISTVIEWGETITEM )
{
	char string [1024] = "" ;
	HWND h;
	int s;
	int c;
	int l ;

	h = (HWND) hb_parnl( 1 ) ;

	c = hb_parni(2) - 1 ;

	l =  hb_parni(3) ;

	hb_reta ( l ) ;

	for (s = 0 ; s <= l-1 ; s++ )
	{
		ListView_GetItemText(h,c,s,string,1024) ;
		hb_storc( string , -1 , s+1 ) ;
	}

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

HB_FUNC ( SETIMAGELISTVIEWITEMS )
{
	LV_ITEM LI;
	HWND h;

	h = (HWND) hb_parnl( 1 ) ;

	LI.mask= LVIF_IMAGE ;	// Browse+
	LI.state=0;
	LI.stateMask=0;
        LI.iImage= hb_parni( 3 );	// Browse+
        LI.iSubItem=0;
	LI.iItem=hb_parni(2) - 1 ;

    ListView_SetItem(h,&LI);
}

HB_FUNC ( GETIMAGELISTVIEWITEMS )
{
	LV_ITEM LI;
	HWND h;
        int i;

	h = (HWND) hb_parnl( 1 ) ;

	LI.mask= LVIF_IMAGE ;	// Browse+
	LI.state=0;
	LI.stateMask=0;
        LI.iSubItem=0;
	LI.iItem=hb_parni(2) - 1 ;

        ListView_GetItem(h,&LI);
        i =  LI.iImage;

	hb_retni (i);
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

HB_FUNC ( LISTVIEW_GETBKCOLOR )
{
	hb_retnl ( ListView_GetBkColor ( (HWND) hb_parnl (1) ) ) ;
}

HB_FUNC ( LISTVIEW_GETCOLUMNWIDTH )
{
	hb_retni ( ListView_GetColumnWidth ( (HWND) hb_parnl (1) , hb_parni(2) ) ) ;
}

HB_FUNC ( LISTVIEW_ADDCOLUMN )
{

	LV_COLUMN COL;

	PHB_ITEM pValue = hb_itemNew( NULL );
	hb_itemCopy( pValue, hb_param( 4, HB_IT_STRING ));

	COL.mask= LVCF_WIDTH | LVCF_TEXT | LVCF_FMT | LVCF_SUBITEM ;
	COL.cx= hb_parni(3);
	COL.pszText = pValue->item.asString.value;
	COL.iSubItem=hb_parni(2)-1;
	COL.fmt = hb_parni(5) ;

	ListView_InsertColumn( (HWND) hb_parnl( 1 ) , hb_parni(2)-1 , &COL );

	SendMessage ( (HWND) hb_parnl( 1 ) , LVM_DELETEALLITEMS , 0 , 0 );

	RedrawWindow ( (HWND) hb_parnl( 1 ), NULL , NULL , RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW ) ;

}

HB_FUNC ( LISTVIEW_DELETECOLUMN )
{
    ListView_DeleteColumn( (HWND) hb_parnl (1) , hb_parni( 2 ) - 1 ) ;
	SendMessage ( (HWND) hb_parnl( 1 ) , LVM_DELETEALLITEMS , 0 , 0 );
	RedrawWindow ( (HWND) hb_parnl( 1 ), NULL , NULL , RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW ) ;
}

HB_FUNC ( GETGRIDVKEY )
{

   hb_retnl( ( LPARAM ) ( ( ( LV_KEYDOWN * ) hb_parnl( 1 ) ) -> wVKey ) );

}

static PHB_DYNS s_GridForeColor = 0, s_GridBackColor = 0;
static PHB_DYNS s_aFontColor = 0,    s_DefBkColorEdit = 0;
static PHB_DYNS s_Container = 0,     s_Parent = 0;

static int TGrid_Notify_CustomDraw( PHB_ITEM pSelf, unsigned int x, unsigned int y, PHB_DYNS sGridColor, PHB_DYNS sObjColor, int iDefaultColor )
{
   PHB_ITEM pColor;
   HB_ITEM pRet;
   int iColor, sw;

   hb_vmPushSymbol( sGridColor->pSymbol );
   hb_vmPush( pSelf );
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
   sw = 1;
   while( iColor < 0 && sw )
   {
      if( pColor && HB_IS_NUMERIC( pColor ) )
      {
         iColor = hb_itemGetNL( pColor );
      }
      else if( pColor && HB_IS_ARRAY( pColor ) )
      {
         if( pColor->item.asArray.value->ulLen >= 3 )
         {
            pColor = pColor->item.asArray.value->pItems;
            if( HB_IS_NUMERIC( pColor ) && HB_IS_NUMERIC( &pColor[ 1 ] ) && HB_IS_NUMERIC( &pColor[ 2 ] ) )
            {
               iColor =   ( hb_itemGetNL( pColor       ) & 0x0000FF )         |
                        ( ( hb_itemGetNL( &pColor[ 1 ] ) & 0x0000FF ) <<  8 ) |
                        ( ( hb_itemGetNL( &pColor[ 2 ] ) & 0x0000FF ) << 16 ) ;
            }
         }
      }
      else if( ! pSelf || ! HB_IS_OBJECT( pSelf ) )
      {
         iColor = GetSysColor( iDefaultColor );
         sw = 0;
      }
      else
      {
         hb_vmPushSymbol( sObjColor->pSymbol );
         hb_vmPush( pSelf );

         // oObj := IF( ValType( oObj:Container ) == "O", oObj:Container, oObj:Parent )
         hb_vmPushSymbol( s_Container->pSymbol );
         hb_vmPush( pSelf );
         hb_vmSend( 0 );
         pColor = hb_param( -1, HB_IT_OBJECT );
         if( ! pColor )
         {
            hb_vmPushSymbol( s_Parent->pSymbol );
            hb_vmPush( pSelf );
            hb_vmSend( 0 );
            pColor = hb_param( -1, HB_IT_OBJECT );
         }
         if( pColor )
         {
            memcpy( &pRet, pColor, sizeof( HB_ITEM ) );
            pSelf = &pRet;
         }
         else
         {
            pSelf = NULL;
         }

         // nColor := oObj:aFontColor
         hb_vmSend( 0 );
         pColor = hb_param( -1, HB_IT_ANY );
      }
   }

   return iColor;
}

HB_FUNC( TGRID_NOTIFY_CUSTOMDRAW )
{
   PHB_ITEM pSelf;
   LPNMLVCUSTOMDRAW lplvcd;
   int x, y;

   pSelf = hb_param( 1, HB_IT_OBJECT );
   lplvcd = ( LPNMLVCUSTOMDRAW ) ( LPARAM ) hb_parnl( 2 );

   if( lplvcd->nmcd.dwDrawStage == CDDS_PREPAINT )
	{
      hb_retni( CDRF_NOTIFYITEMDRAW ) ;
      return;
	}
   else if( lplvcd->nmcd.dwDrawStage == CDDS_ITEMPREPAINT )
	{
      hb_retni( CDRF_NOTIFYSUBITEMDRAW ) ;
      return;
	}
   else if( ! ( lplvcd->nmcd.dwDrawStage == CDDS_SUBITEM | CDDS_ITEMPREPAINT ) )
	{
      hb_retni( CDRF_DODEFAULT ) ;
      return;
	}

   if( ! s_GridForeColor )
   {
      s_GridForeColor  = hb_dynsymFindName( "GRIDFORECOLOR" );
      s_GridBackColor  = hb_dynsymFindName( "GRIDBACKCOLOR" );
      s_aFontColor     = hb_dynsymFindName( "AFONTCOLOR" );
      s_DefBkColorEdit = hb_dynsymFindName( "DEFBKCOLOREDIT" );
      s_Container      = hb_dynsymFindName( "CONTAINER" );
      s_Parent         = hb_dynsymFindName( "PARENT" );
   }

   x = lplvcd->iSubItem + 1;
   y = lplvcd->nmcd.dwItemSpec + 1;

   lplvcd->clrText   = TGrid_Notify_CustomDraw( pSelf, x, y, s_GridForeColor, s_aFontColor,     COLOR_WINDOWTEXT );
   lplvcd->clrTextBk = TGrid_Notify_CustomDraw( pSelf, x, y, s_GridBackColor, s_DefBkColorEdit, COLOR_WINDOW );

   hb_retni( CDRF_NEWFONT );
}