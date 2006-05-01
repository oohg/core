/*
 * $Id: c_tree.c,v 1.5 2006-05-01 04:09:47 guerra000 Exp $
 */
/*
 * ooHG source code:
 * C tree functions
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

#ifndef HB_OS_WIN_32_USED
   #define HB_OS_WIN_32_USED
#endif

#define _WIN32_WINNT   0x0400

#define WM_TASKBAR     WM_USER+1043

#include <shlobj.h>
#include <windows.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "winreg.h"
#include "tchar.h"
#include <commctrl.h>
#include "../include/oohg.h"

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

HB_FUNC( INITTREE )
{

	INITCOMMONCONTROLSEX icex;

	HWND hWndTV ;
	UINT mask;
   int StyleEx;

   StyleEx = WS_EX_CLIENTEDGE | _OOHG_RTL_Status( hb_parl( 10 ) );

	if( hb_parni(9) != 0 )  //Tree+
	{
		mask = 0x0000;
	}
	else
	{
		mask = TVS_LINESATROOT;
	}

	icex.dwSize = sizeof(INITCOMMONCONTROLSEX);
	icex.dwICC   = ICC_TREEVIEW_CLASSES ;
	InitCommonControlsEx(&icex);

    hWndTV = CreateWindowEx( StyleEx,
			WC_TREEVIEW, "",
			WS_VISIBLE |
			WS_TABSTOP |
			WS_CHILD |
			TVS_HASLINES |
			TVS_HASBUTTONS |
			mask |
			TVS_SHOWSELALWAYS ,
                            hb_parni(2),
                            hb_parni(3),
                            hb_parni(4),
                            hb_parni(5),
                            (HWND) hb_parnl(1) ,
                            (HMENU) hb_parni(6) ,
                            GetModuleHandle(NULL),
                            NULL);

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( ( HWND ) hWndTV, GWL_WNDPROC, ( LONG ) SubClassFunc );

   hb_retnl( (LONG) hWndTV ) ;

}

HB_FUNC (ADDTREEITEM)
{

	HWND hWndTV = (HWND) hb_parnl(1)  ;

	HTREEITEM hPrev = (HTREEITEM) hb_parnl(2) ;
	HTREEITEM hRet ;

	TV_ITEM tvi;
	TV_INSERTSTRUCT is ;

	tvi.mask       = TVIF_TEXT | TVIF_IMAGE | TVIF_SELECTEDIMAGE | TVIF_PARAM ;

	tvi.pszText		= hb_parc(3) ;
	tvi.cchTextMax		= 1024 ;
	tvi.iImage 	   	= hb_parni(4) ;
	tvi.iSelectedImage	= hb_parni(5) ;
	tvi.lParam		= hb_parni(6) ;

#ifdef __BORLANDC__
     is.DUMMYUNIONNAME.item = tvi;
#else
     is.item   = tvi;
#endif

	if ( hPrev == 0 )
	{
		is.hInsertAfter = hPrev;
		is.hParent      = NULL;
	}
	else
	{
		is.hInsertAfter = TVI_LAST;
		is.hParent      = hPrev;
	}

	hRet = TreeView_InsertItem(hWndTV, &is);

	hb_retnl ( (LONG) hRet ) ;

}

HB_FUNC (TREEVIEW_GETSELECTION)
{

	HWND TreeHandle ;
	HTREEITEM ItemHandle ;

	TreeHandle = (HWND) hb_parnl (1) ;

	ItemHandle = TreeView_GetSelection( TreeHandle );

	hb_retnl ( (LONG) ItemHandle ) ;

}

HB_FUNC (TREEVIEW_SELECTITEM)
{

	HWND		TreeHandle ;
	HTREEITEM	ItemHandle ;

	TreeHandle = (HWND) hb_parnl (1) ;
	ItemHandle = (HTREEITEM) hb_parnl (2) ;

	TreeView_SelectItem ( TreeHandle , ItemHandle ) ;

}

HB_FUNC (TREEVIEW_DELETEITEM)
{

	HWND		TreeHandle ;
	HTREEITEM	ItemHandle ;

	TreeHandle = (HWND) hb_parnl (1) ;
	ItemHandle = (HTREEITEM) hb_parnl (2) ;

	TreeView_DeleteItem ( TreeHandle , ItemHandle ) ;

}

HB_FUNC (TREEVIEW_DELETEALLITEMS)
{

	HWND		TreeHandle ;

	TreeHandle = (HWND) hb_parnl (1) ;

	TreeView_DeleteAllItems ( TreeHandle ) ;

}

HB_FUNC (TREEVIEW_GETCOUNT)
{

	HWND		TreeHandle ;

	TreeHandle = (HWND) hb_parnl (1) ;

	hb_retni ( TreeView_GetCount ( TreeHandle ) ) ;

}

HB_FUNC (TREEVIEW_GETPREVSIBLING)
{

	HWND		TreeHandle ;
	HTREEITEM	ItemHandle ;
	HTREEITEM	PrevItemHandle ;

	TreeHandle = (HWND) hb_parnl (1) ;
	ItemHandle = (HTREEITEM) hb_parnl (2) ;

	PrevItemHandle = TreeView_GetPrevSibling ( TreeHandle , ItemHandle ) ;

	hb_retnl ( (LONG) PrevItemHandle ) ;

}

HB_FUNC (TREEVIEW_GETITEM)
{

	HWND		TreeHandle ;
	HTREEITEM	TreeItemHandle ;
	TV_ITEM		TreeItem ;
	char		ItemText [256] ;

	memset(&TreeItem, 0, sizeof(TV_ITEM)) ;

	TreeHandle = (HWND) hb_parnl (1) ;
	TreeItemHandle = (HTREEITEM) hb_parnl (2) ;

	TreeItem.mask = TVIF_HANDLE | TVIF_TEXT ;
	TreeItem.hItem	= TreeItemHandle ;

	TreeItem.pszText = ItemText ;
	TreeItem.cchTextMax = 256 ;

	TreeView_GetItem ( (HWND)TreeHandle , &TreeItem ) ;

	hb_retc ( ItemText ) ;

}
HB_FUNC (TREEVIEW_SETITEM)
{

	HWND		TreeHandle ;
	HTREEITEM	TreeItemHandle ;
	TV_ITEM		TreeItem ;
	char		ItemText [256] ;

	memset(&TreeItem, 0, sizeof(TV_ITEM)) ;

	TreeHandle = (HWND) hb_parnl (1) ;
	TreeItemHandle = (HTREEITEM) hb_parnl (2) ;
	strcpy ( ItemText , hb_parc(3) ) ;

	TreeItem.mask = TVIF_HANDLE | TVIF_TEXT ;
	TreeItem.hItem	= TreeItemHandle ;

	TreeItem.pszText = ItemText ;
	TreeItem.cchTextMax = 256 ;

	TreeView_SetItem ( (HWND)TreeHandle , &TreeItem ) ;

}

HB_FUNC (TREEVIEW_GETSELECTIONID)
{

	HWND TreeHandle ;
	HTREEITEM ItemHandle ;

	TV_ITEM		TreeItem ;
	LPARAM		lParam ;

	TreeHandle = (HWND) hb_parnl (1) ;
	ItemHandle = TreeView_GetSelection( TreeHandle );

	memset(&TreeItem, 0, sizeof(TV_ITEM)) ;

	TreeItem.mask = TVIF_HANDLE | TVIF_PARAM ;
	TreeItem.hItem	= ItemHandle ;

	TreeItem.lParam = lParam ;

	TreeView_GetItem ( (HWND)TreeHandle , &TreeItem ) ;

	hb_retnl ( TreeItem.lParam ) ;

}


HB_FUNC (TREEVIEW_GETNEXTSIBLING)
{

	HWND		TreeHandle ;
	HTREEITEM	ItemHandle ;
	HTREEITEM	PrevItemHandle ;

	TreeHandle = (HWND) hb_parnl (1) ;
	ItemHandle = (HTREEITEM) hb_parnl (2) ;

	PrevItemHandle = TreeView_GetNextSibling ( TreeHandle , ItemHandle ) ;

	hb_retnl ( (LONG) PrevItemHandle ) ;

}

HB_FUNC (TREEVIEW_GETCHILD)
{

	HWND		TreeHandle ;
	HTREEITEM	ItemHandle ;
	HTREEITEM	PrevItemHandle ;

	TreeHandle = (HWND) hb_parnl (1) ;
	ItemHandle = (HTREEITEM) hb_parnl (2) ;

	PrevItemHandle = TreeView_GetChild ( TreeHandle , ItemHandle ) ;

	hb_retnl ( (LONG) PrevItemHandle ) ;

}

HB_FUNC (TREEVIEW_GETPARENT)
{

	HWND		TreeHandle ;
	HTREEITEM	ItemHandle ;
	HTREEITEM	PrevItemHandle ;

	TreeHandle = (HWND) hb_parnl (1) ;
	ItemHandle = (HTREEITEM) hb_parnl (2) ;

	PrevItemHandle = TreeView_GetParent ( TreeHandle , ItemHandle ) ;

	hb_retnl ( (LONG) PrevItemHandle ) ;

}