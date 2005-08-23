/*
 * $Id: c_windows.c,v 1.9 2005-08-23 05:09:34 guerra000 Exp $
 */
/*
 * ooHG source code:
 * Windows handling functions
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


#define WINVER  0x0500
#define _WIN32_IE      0x0500
#define HB_OS_WIN_32_USED

#define _WIN32_WINNT   0x0400

#define WM_TASKBAR     WM_USER+1043
#include <shlobj.h>
#include <windows.h>
#include "richedit.h"
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "winreg.h"
#include "tchar.h"
#include <commctrl.h>
#include "../include/oohg.h"


BOOL Array2Rect(PHB_ITEM aRect, RECT *rc ) ;

static void ChangeNotifyIcon( HWND hWnd, HICON hIcon, LPSTR szText );
static void ShowNotifyIcon( HWND hWnd, BOOL bAdd, HICON hIcon, LPSTR szText );

static PHB_DYNS _ooHG_Symbol_TForm = 0;
static HB_ITEM  _OOHG_aFormhWnd, _OOHG_aFormObjects;

HB_FUNC( _OOHG_INIT_C_VARS_C_SIDE )
{
   _ooHG_Symbol_TForm  = hb_dynsymFind( "TFORM" );
   memcpy( &_OOHG_aFormhWnd,    hb_param( 1, HB_IT_ARRAY ), sizeof( HB_ITEM ) );
   memcpy( &_OOHG_aFormObjects, hb_param( 2, HB_IT_ARRAY ), sizeof( HB_ITEM ) );
}

PHB_ITEM GetFormObjectByHandle( LONG hWnd )
{
   PHB_ITEM pForm;
   ULONG ulCount;

   if( ! _ooHG_Symbol_TForm )
   {
      hb_vmPushSymbol( hb_dynsymFind( "_OOHG_INIT_C_VARS" )->pSymbol );
      hb_vmPushNil();
      hb_vmDo( 0 );
   }

   pForm = 0;
   for( ulCount = 0; ulCount < _OOHG_aFormhWnd.item.asArray.value->ulLen; ulCount++ )
   {
      if( hWnd == hb_itemGetNL( &_OOHG_aFormhWnd.item.asArray.value->pItems[ ulCount ] ) )
      {
         pForm = &_OOHG_aFormObjects.item.asArray.value->pItems[ ulCount ];
         ulCount = _OOHG_aFormhWnd.item.asArray.value->ulLen;
      }
   }
   if( ! pForm )
   {
      hb_vmPushSymbol( _ooHG_Symbol_TForm->pSymbol );
      hb_vmPushNil();
      hb_vmDo( 0 );
      pForm = hb_param( -1, HB_IT_ANY );
   }

   return pForm;
}

HB_FUNC( GETFORMOBJECTBYHANDLE )
{
   HB_ITEM pReturn;

   pReturn.type = HB_IT_NIL;
   hb_itemCopy( &pReturn, GetFormObjectByHandle( hb_parnl( 1 ) ) );

   hb_itemReturn( &pReturn );
   hb_itemClear( &pReturn );
}

LRESULT CALLBACK WndProc( HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam )
{
   long int r;
   PHB_ITEM pResult;

   if( ! _ooHG_Symbol_TForm )
   {
      hb_vmPushSymbol( hb_dynsymFind( "_OOHG_INIT_C_VARS" )->pSymbol );
      hb_vmPushNil();
      hb_vmDo( 0 );
   }

   _OOHG_Send( GetFormObjectByHandle( ( LONG ) hWnd ), s_Events );
   hb_vmPushLong( ( LONG ) hWnd );
   hb_vmPushLong( message );
   hb_vmPushLong( wParam );
   hb_vmPushLong( lParam );
   hb_vmSend( 4 );

   pResult = hb_param( -1, HB_IT_NUMERIC );
   if( pResult )
   {
      return hb_itemGetNL( pResult );
   }
   else
   {
      return DefWindowProc( hWnd, message, wParam, lParam );
   }

/*
#if defined(__XHARBOUR__)

	if ( r != 0 )
	{
		return r ;
	}
	else
	{
		return( DefWindowProc( hWnd, message, wParam, lParam ));
	}

#else

	r = hb_itemGetNL( (PHB_ITEM) &hb_stack.Return ) ;

	if ( r != 0 )
	{
		return r ;
	}
	else
	{
		return( DefWindowProc( hWnd, message, wParam, lParam ));
	}

#endif
*/

}

HB_FUNC( INITWINDOW )
{
   HWND hwnd;
   int Style = WS_POPUP , ExStyle = 0;

   if ( hb_parl( 17 ) )
   {
      ExStyle |= WS_EX_LAYOUTRTL | WS_EX_RIGHTSCROLLBAR | WS_EX_RTLREADING;
   }

	if ( hb_parl (16) )
	{
            ExStyle |= WS_EX_CONTEXTHELP ;
	}
	else
	{
		if ( ! hb_parl (6) )
		{
			Style = Style | WS_MINIMIZEBOX ;
		}
		if ( ! hb_parl (7) )
		{
			Style = Style | WS_MAXIMIZEBOX ;
		}
	}

	if ( ! hb_parl (8) )
	{
		Style = Style | WS_SIZEBOX ;
	}

	if ( ! hb_parl (9) )
	{
		Style = Style | WS_SYSMENU ;
	}

	if ( ! hb_parl (10) )
	{
		Style = Style | WS_CAPTION ;
	}

	if ( hb_parl (11) )
	{
        ExStyle |= WS_EX_TOPMOST ;
	}

	if ( hb_parl (14) )
	{
		Style = Style | WS_VSCROLL ;
	}

	if ( hb_parl (15) )
	{
		Style = Style | WS_HSCROLL ;
	}

	hwnd = CreateWindowEx( ExStyle , hb_parc(12) ,hb_parc(1),
	Style ,
	hb_parni(2),
	hb_parni(3),
	hb_parni(4),
	hb_parni(5),
	(HWND) hb_parnl (13),(HMENU)NULL, GetModuleHandle( NULL ) ,NULL);

	if(hwnd == NULL)
	{
	MessageBox(0, "Window Creation Failed!", "Error!",
	MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);
	return;
	}

	hb_retnl ((LONG)hwnd);
}

HB_FUNC( INITMODALWINDOW )
{
   HWND parent ;
   HWND hwnd ;
   int Style ;
   int ExStyle = 0;

   if ( hb_parl( 14 ) )
   {
      ExStyle |= WS_EX_LAYOUTRTL | WS_EX_RIGHTSCROLLBAR | WS_EX_RTLREADING;
   }

   if ( hb_parl (13) )
   {
      ExStyle |= WS_EX_CONTEXTHELP;
   }

	parent = (HWND) hb_parnl (6);

	Style = WS_POPUP;

	if ( ! hb_parl (7) )
	{
		Style = Style | WS_SIZEBOX ;
	}

	if ( ! hb_parl (8) )
	{
		Style = Style | WS_SYSMENU ;
	}

	if ( ! hb_parl (9) )
	{
		Style = Style | WS_CAPTION ;
	}

	if ( hb_parl (11) )
	{
		Style = Style | WS_VSCROLL ;
	}

	if ( hb_parl (12) )
	{
		Style = Style | WS_HSCROLL ;
	}

	hwnd = CreateWindowEx( ExStyle ,hb_parc(10),hb_parc(1),
	Style,
	hb_parni(2),
	hb_parni(3),
	hb_parni(4),
	hb_parni(5),
	parent,(HMENU)NULL, GetModuleHandle( NULL ) ,NULL);

	if(hwnd == NULL)
	{
	MessageBox(0, "Window Creation Failed!", "Error!",
	MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);
	return;
	}

	hb_retnl ((LONG)hwnd);
}

HB_FUNC( _DOMESSAGELOOP )
{
   MSG Msg;

   while( GetMessage( &Msg, NULL, 0, 0 ) )
   {
      if( ! IsWindow( GetActiveWindow() ) || ! IsDialogMessage( GetActiveWindow(), &Msg ) )
      {
         TranslateMessage( &Msg );
         DispatchMessage( &Msg );
      }
   }
}

HB_FUNC( SHOWWINDOW )
{
    ShowWindow( ( HWND ) hb_parnl( 1 ), SW_SHOW );
}

HB_FUNC( EXITPROCESS )
{
	ExitProcess(0);
}

HB_FUNC( INITSTATUS )
{

	HWND hwnd;
	HWND hs;

	hwnd = (HWND) hb_parnl (1);

	hs = CreateStatusWindow ( WS_CHILD | WS_BORDER | WS_VISIBLE
		, "" , hwnd, hb_parni(3) );

	SendMessage(hs,SB_SIMPLE, TRUE , 0 );
	SendMessage(hs,SB_SETTEXT,255 , (LPARAM) (LPSTR) hb_parc(2) );
	hb_retnl ( (LONG) hs );

}

HB_FUNC( SETSTATUS )
{

	HWND hwnd;

	hwnd = (HWND) hb_parnl (1);

	SendMessage(hwnd,SB_SIMPLE, TRUE , 0 );
	SendMessage(hwnd,SB_SETTEXT,255 , (LPARAM) (LPSTR) hb_parc(2) );

}

HB_FUNC( MAXIMIZE )
{
    ShowWindow( ( HWND ) hb_parnl( 1 ), SW_MAXIMIZE );
}

HB_FUNC( MINIMIZE )
{
    ShowWindow( ( HWND ) hb_parnl( 1 ), SW_MINIMIZE );
}

HB_FUNC( RESTORE )
{
    ShowWindow( ( HWND ) hb_parnl( 1 ), SW_RESTORE );
}

HB_FUNC( GETACTIVEWINDOW )
{
    hb_retnl( ( LONG ) GetActiveWindow() );
}

HB_FUNC( SETACTIVEWINDOW )
{
    SetActiveWindow( ( HWND ) hb_parnl( 1 ) );
}

HB_FUNC( POSTQUITMESSAGE )
{
	PostQuitMessage( hb_parnl( 1 ) );
}

HB_FUNC ( DESTROYWINDOW )
{
    DestroyWindow( ( HWND ) hb_parnl( 1 ) );
}

HB_FUNC (ISWINDOWENABLED)
{
	HWND hwnd;
	int r;

	hwnd = (HWND) hb_parnl (1);

	r = IsWindowEnabled( hwnd );

	if ( r != 0 )
	{
		hb_retl( TRUE );
	}
	else
	{
		hb_retl( FALSE );
	}

}

HB_FUNC( ENABLEWINDOW )
{
    EnableWindow( ( HWND ) hb_parnl( 1 ), TRUE );
}

HB_FUNC( DISABLEWINDOW )
{
    EnableWindow( ( HWND ) hb_parnl( 1 ), FALSE );
}

HB_FUNC( SETFOREGROUNDWINDOW )
{
    SetForegroundWindow( ( HWND ) hb_parnl( 1 ) );
}
HB_FUNC( BRINGWINDOWTOTOP )
{
    BringWindowToTop( ( HWND ) hb_parnl( 1 ) );
}

HB_FUNC( GETFOREGROUNDWINDOW )
{
    hb_retnl( ( LONG ) GetForegroundWindow() );
}

HB_FUNC( GETNEXTWINDOW )
{
    hb_retnl( ( LONG ) GetWindow( ( HWND ) hb_parnl( 1 ), GW_HWNDNEXT ) );
}

HB_FUNC( GETPREVWINDOW )
{
    hb_retnl( ( LONG ) GetWindow( ( HWND ) hb_parnl( 1 ), GW_HWNDPREV ) );
}

HB_FUNC( SETWINDOWTEXT )
{
   SetWindowText( ( HWND ) hb_parnl( 1 ) , ( LPCTSTR ) hb_parc( 2 ) );
}

HB_FUNC( C_CENTER )
{
   RECT rect;
   HWND hwnd;
   int w, h, x, y;
   hwnd = ( HWND ) hb_parnl( 1 );
   GetWindowRect( hwnd, &rect );
   w = rect.right  - rect.left + 1;
   h = rect.bottom - rect.top  + 1;
   x = GetSystemMetrics( SM_CXSCREEN );
   y = GetSystemMetrics( SM_CYSCREEN );
   SetWindowPos( hwnd, HWND_TOP, ( x - w ) / 2,
                 ( y - h ) / 2, 0, 0, SWP_NOSIZE | SWP_NOACTIVATE );
}

HB_FUNC ( GETWINDOWTEXT )
{
   int iLen = GetWindowTextLength( ( HWND ) hb_parnl( 1 ) ) + 1;
   char *cText = ( char * ) hb_xgrab( iLen );

   GetWindowText( ( HWND ) hb_parnl( 1 ), ( LPTSTR ) cText, iLen );

   hb_retc( cText );
   hb_xfree( cText );
}


HB_FUNC ( SENDMESSAGE )
{
	hb_retnl( (LONG) SendMessage( (HWND) hb_parnl( 1 ), (UINT) hb_parni( 2 ), (WPARAM) hb_parnl( 3 ), (LPARAM) hb_parnl( 4 ) ) );
}

HB_FUNC ( UPDATEWINDOW )
{
	hb_retnl( (LONG) UpdateWindow( (HWND) hb_parnl( 1 ) ) );
}

HB_FUNC ( GETNOTIFYCODE )
{
   hb_retnl( (LONG) (((NMHDR FAR *) hb_parnl(1))->code) );
}

HB_FUNC ( GETHWNDFROM )
{
   hb_retnl( (LONG) (((NMHDR FAR *) hb_parnl(1))->hwndFrom) );
}

HB_FUNC ( GETDRAWITEMHANDLE )
{
   hb_retnl( (LONG) (((DRAWITEMSTRUCT FAR *) hb_parnl(1))->hwndItem) );
}


HB_FUNC ( GETFOCUS )
{
   hb_retnl( (LONG) GetFocus() );
}

HB_FUNC ( GETGRIDCOLUMN )
{
	#define pnm ((NM_LISTVIEW *) hb_parnl(1) )

	hb_retnl ( (LPARAM) (pnm->iSubItem) ) ;

	#undef pnm

}

HB_FUNC ( MOVEWINDOW )
{
  hb_retl( MoveWindow(
                       (HWND) hb_parnl(1),
                       hb_parni(2),
                       hb_parni(3),
                       hb_parni(4),
                       hb_parni(5),
                       (ISNIL(6) ? TRUE : hb_parl(6))
                      ));
}

HB_FUNC ( GETWINDOWRECT )
{
  RECT rect;
  hb_retl( GetWindowRect((HWND) hb_parnl (1), &rect));
  hb_stornl(rect.left,2,1);
  hb_stornl(rect.top,2,2);
  hb_stornl(rect.right,2,3);
  hb_stornl(rect.bottom,2,4);
}

HB_FUNC ( REGISTERWINDOW )
{
	WNDCLASS WndClass;

	HBRUSH hbrush = 0 ;

	WndClass.style         = CS_HREDRAW | CS_VREDRAW | CS_OWNDC ;
//	WndClass.style         = CS_OWNDC ;
	WndClass.lpfnWndProc   = WndProc;
	WndClass.cbClsExtra    = 0;
	WndClass.cbWndExtra    = 0;
	WndClass.hInstance     = GetModuleHandle( NULL );
	WndClass.hIcon         = LoadIcon(GetModuleHandle(NULL),  hb_parc(1) );
	if (WndClass.hIcon==NULL)
	{
		WndClass.hIcon= (HICON) LoadImage( GetModuleHandle(NULL),  hb_parc(1) , IMAGE_ICON, 0, 0, LR_LOADFROMFILE + LR_DEFAULTSIZE ) ;
	}
	if (WndClass.hIcon==NULL)
	{
		WndClass.hIcon= LoadIcon(NULL, IDI_APPLICATION);
	}
	WndClass.hCursor       = LoadCursor(NULL, IDC_ARROW);

	if ( hb_parni(3, 1) == -1 )
	{
		WndClass.hbrBackground = (HBRUSH)( COLOR_BTNFACE + 1 );
	}
	else
	{
		hbrush = CreateSolidBrush( RGB(hb_parni(3, 1), hb_parni(3, 2), hb_parni(3, 3)) );
		WndClass.hbrBackground = hbrush ;
	}

	WndClass.lpszMenuName  = NULL;
	WndClass.lpszClassName = hb_parc(2);

	if(!RegisterClass(&WndClass))
	{
	MessageBox(0, "Window Registration Failed!", "Error!",
	MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);
	ExitProcess(0);
	}
	hb_retnl ( (LONG) hbrush ) ;
}

HB_FUNC ( UNREGISTERWINDOW )
{
	UnregisterClass ( hb_parc(1), GetModuleHandle( NULL ) ) ;
}

HB_FUNC (GETDESKTOPWIDTH)
{
	hb_retni ( GetSystemMetrics(SM_CXSCREEN) ) ;
}

HB_FUNC (GETVSCROLLBARWIDTH)
{
	hb_retni ( GetSystemMetrics(SM_CXVSCROLL) ) ;
}

HB_FUNC (GETHSCROLLBARHEIGHT)
{
	hb_retni ( GetSystemMetrics(SM_CYHSCROLL) ) ;
}

HB_FUNC (GETDESKTOPHEIGHT)
{
   hb_retni ( GetSystemMetrics(SM_CYSCREEN) ) ;
}

HB_FUNC (GETWINDOWROW)
{
	RECT rect;
	int y ;
	GetWindowRect((HWND) hb_parnl (1), &rect) ;
	y = rect.top ;

	hb_retni(y);

}

HB_FUNC (GETWINDOWCOL)
{
	RECT rect;
	int x ;
	GetWindowRect((HWND) hb_parnl (1), &rect) ;
	x = rect.left ;

	hb_retni(x);

}

HB_FUNC (GETWINDOWWIDTH)
{
	RECT rect;
	int w ;
	GetWindowRect((HWND) hb_parnl (1), &rect) ;
	w = rect.right - rect.left ;

	hb_retni(w);

}

HB_FUNC (GETWINDOWHEIGHT)
{
	RECT rect;
	int h ;
	GetWindowRect((HWND) hb_parnl (1), &rect) ;
	h = rect.bottom - rect.top ;

	hb_retni(h);

}

HB_FUNC (GETTITLEHEIGHT)
{
	hb_retni ( GetSystemMetrics( SM_CYCAPTION ) ) ;
}

HB_FUNC (GETBORDERHEIGHT)
{
	hb_retni ( GetSystemMetrics(  SM_CYSIZEFRAME ) ) ;
}

HB_FUNC (GETBORDERWIDTH)
{
	hb_retni ( GetSystemMetrics( SM_CXSIZEFRAME ) ) ;
}

HB_FUNC (GETMENUBARHEIGHT)
{
	hb_retni ( GetSystemMetrics( SM_CYMENU ) ) ;
}

HB_FUNC ( ISWINDOWVISIBLE )
{
   hb_retl( IsWindowVisible( (HWND) hb_parnl( 1 ) ) ) ;
}

//----------------------------------------------------------------------------//
HB_FUNC ( SHOWNOTIFYICON )
{
   ShowNotifyIcon( (HWND) hb_parnl(1), (BOOL) hb_parl(2), (HICON) hb_parnl(3), (LPSTR) hb_parc(4) );
}
//----------------------------------------------------------------------------//
static void ShowNotifyIcon(HWND hWnd, BOOL bAdd, HICON hIcon, LPSTR szText)

{
  NOTIFYICONDATA nid;
  ZeroMemory(&nid,sizeof(nid));
  nid.cbSize=sizeof(NOTIFYICONDATA);
  nid.hWnd=hWnd;
  nid.uID=0;
  nid.uFlags=NIF_ICON | NIF_MESSAGE | NIF_TIP;
  nid.uCallbackMessage=WM_TASKBAR;
  nid.hIcon=hIcon;
  lstrcpy(nid.szTip,TEXT(szText));

  if(bAdd)
    Shell_NotifyIcon(NIM_ADD,&nid);
  else
    Shell_NotifyIcon(NIM_DELETE,&nid);
}

HB_FUNC ( GETINSTANCE )

{
   hb_retnl( ( LONG ) GetModuleHandle( NULL ) );
}

HB_FUNC ( GETCURSORPOS )
{
   POINT pt;

   GetCursorPos( &pt );

   hb_reta( 2 );

   hb_storni( pt.y, -1, 1 );
   hb_storni( pt.x, -1, 2 );
}

HB_FUNC (LOADTRAYICON)
{

	HICON himage;
	HINSTANCE hInstance  = (HINSTANCE) hb_parnl(1);  // handle to application instance
	LPCTSTR   lpIconName = (LPCTSTR)   hb_parc(2);   // name string or resource identifier

        himage = LoadIcon( hInstance ,  lpIconName );

	if (himage==NULL)
	{
		himage = (HICON) LoadImage( hInstance ,  lpIconName , IMAGE_ICON, 0, 0, LR_LOADFROMFILE + LR_DEFAULTSIZE ) ;
	}

	hb_retnl ( (LONG) himage );

}

HB_FUNC ( CHANGENOTIFYICON )
{
   ChangeNotifyIcon( (HWND) hb_parnl(1), (HICON) hb_parnl(2), (LPSTR) hb_parc(3) );
}

static void ChangeNotifyIcon(HWND hWnd, HICON hIcon, LPSTR szText)

{
  NOTIFYICONDATA nid;
  ZeroMemory(&nid,sizeof(nid));
  nid.cbSize=sizeof(NOTIFYICONDATA);
  nid.hWnd=hWnd;
  nid.uID=0;
  nid.uFlags=NIF_ICON | NIF_MESSAGE | NIF_TIP;
  nid.uCallbackMessage=WM_TASKBAR;
  nid.hIcon=hIcon;
  lstrcpy(nid.szTip,TEXT(szText));

  Shell_NotifyIcon(NIM_MODIFY,&nid);
}

HB_FUNC( INITSPLITBOX )
{
   HWND hwndOwner = (HWND) hb_parnl ( 1 ) ;
   REBARINFO     rbi;
   HWND   hwndRB;
   INITCOMMONCONTROLSEX icex;
   int ExStyle = 0;
   int Style;

   if ( hb_parl( 4 ) )
   {
      ExStyle |= WS_EX_LAYOUTRTL | WS_EX_RIGHTSCROLLBAR | WS_EX_RTLREADING;
   }

   Style = WS_CHILD |
           WS_VISIBLE |
           WS_CLIPSIBLINGS |
           WS_CLIPCHILDREN |
           RBS_BANDBORDERS |
           RBS_VARHEIGHT |
           RBS_FIXEDORDER;

   if ( hb_parl (2) )
   {
      Style |= CCS_BOTTOM;
   }

   if ( hb_parl (3) )
   {
      Style |= CCS_VERT;
   }

   icex.dwSize = sizeof( INITCOMMONCONTROLSEX );
   icex.dwICC  = ICC_COOL_CLASSES | ICC_BAR_CLASSES;
   InitCommonControlsEx( &icex );

   hwndRB = CreateWindowEx( ExStyle | WS_EX_TOOLWINDOW | WS_EX_DLGMODALFRAME,
                            REBARCLASSNAME,
                            NULL,
                            Style,
                            0,0,0,0,
                            hwndOwner,
                            NULL,
                            GetModuleHandle( NULL ),
                            NULL );

   // Initialize and send the REBARINFO structure.
   rbi.cbSize = sizeof( REBARINFO );  // Required when using this struct.
   rbi.fMask  = 0;
   rbi.himl   = ( HIMAGELIST ) NULL;
   SendMessage( hwndRB, RB_SETBARINFO, 0, ( LPARAM ) &rbi );

   hb_retnl ( ( LONG ) hwndRB );
}

HB_FUNC( INITSPLITCHILDWINDOW )
{
   HWND hwnd;
   int Style;
   int ExStyle = 0;

   if ( hb_parl( 9 ) )
   {
      ExStyle |= WS_EX_LAYOUTRTL | WS_EX_RIGHTSCROLLBAR | WS_EX_RTLREADING;
   }

   Style = WS_POPUP ;

	if ( !hb_parl(4) )
	{
		Style = Style | WS_CAPTION ;
	}

	if ( hb_parl (7) )
	{
		Style = Style | WS_VSCROLL ;
	}

	if ( hb_parl (8) )
	{
		Style = Style | WS_HSCROLL ;
	}

    hwnd = CreateWindowEx( ExStyle | WS_EX_STATICEDGE | WS_EX_TOOLWINDOW ,hb_parc(3),hb_parc(5),
	Style,
	0,
	0,
	hb_parni(1),
	hb_parni(2),
	0,(HMENU)NULL, GetModuleHandle( NULL ) ,NULL);

	if(hwnd == NULL)
	{
	MessageBox(0, "Window Creation Failed!", "Error!",
	MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);
	return;
	}

	hb_retnl ((LONG)hwnd);
}

HB_FUNC (SIZEREBAR)
{

	SendMessage(  (HWND) hb_parnl (1)  , RB_SHOWBAND , (WPARAM)(INT) 0 , (LPARAM)(BOOL) 0 );
	SendMessage(  (HWND) hb_parnl (1)  , RB_SHOWBAND , (WPARAM)(INT) 0 , (LPARAM)(BOOL) 1 );

}


HB_FUNC ( GETITEMPOS )
{
   hb_retnl( (LONG) (((NMMOUSE FAR *) hb_parnl(1))->dwItemSpec) );
}


HB_FUNC( SETSCROLLRANGE )
{
   hb_retl( SetScrollRange( (HWND) hb_parnl( 1 ),
                            hb_parni( 2 )       ,
                            hb_parni( 3 )       ,
                            hb_parni( 4 )       ,
                            hb_parl( 5 )
                          ) ) ;
}

HB_FUNC( GETSCROLLPOS )
{
   hb_retni( GetScrollPos( (HWND) hb_parnl( 1 ), hb_parni( 2 ) ) ) ;
}

HB_FUNC( GETWINDOWSTATE )
{
	WINDOWPLACEMENT wp ;

	wp.length = sizeof(WINDOWPLACEMENT) ;

	GetWindowPlacement( (HWND) hb_parnl( 1 ) , &wp );

	hb_retni ( wp.showCmd ) ;

}

HB_FUNC ( REDRAWWINDOW )
{
   RedrawWindow(
    (HWND) hb_parnl( 1 ),
    NULL,
    NULL,
    RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW	 | RDW_UPDATENOW
   );
}

HB_FUNC ( REDRAWWINDOWCONTROLRECT )
{

	RECT r;

	r.top 	= hb_parni(2) ;
	r.left 	= hb_parni(3) ;
	r.bottom= hb_parni(4) ;
	r.right	= hb_parni(5) ;

	RedrawWindow(
		(HWND) hb_parnl( 1 ),
		&r,
		NULL,
		RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW	 | RDW_UPDATENOW
	);

}

HB_FUNC ( ADDSPLITBOXITEM )
{

	REBARBANDINFO rbBand;
	RECT          rc;
	int Style = RBBS_CHILDEDGE | RBBS_GRIPPERALWAYS ;

	if ( hb_parl (4) )
	{
		Style = Style | RBBS_BREAK ;
	}

	GetWindowRect ( (HWND) hb_parnl ( 1 ) , &rc ) ;

	rbBand.cbSize = sizeof(REBARBANDINFO);
	rbBand.fMask  = RBBIM_TEXT | RBBIM_STYLE | RBBIM_CHILD | RBBIM_CHILDSIZE | RBBIM_SIZE ;
	rbBand.fStyle = Style ;
	rbBand.hbmBack= 0;

	rbBand.lpText     = hb_parc(5);
	rbBand.hwndChild  = (HWND)hb_parnl( 1 );


	if ( !hb_parl (8) )
	{
		// Not Horizontal
		rbBand.cxMinChild = hb_parni(6) ? hb_parni(6) : 0 ;       //0 ; JP 61
		rbBand.cyMinChild = hb_parni(7) ? hb_parni(7) : rc.bottom - rc.top ; // JP 61
		rbBand.cx         = hb_parni(3) ;
	}
	else
	{
		// Horizontal
		if ( hb_parni(6) == 0 && hb_parni(7) == 0 )
		{
			// Not ToolBar
			rbBand.cxMinChild = 0 ;
			rbBand.cyMinChild = rc.right - rc.left ;
			rbBand.cx         = rc.bottom - rc.top ;
		}
		else
		{
			// ToolBar
			rbBand.cxMinChild = hb_parni(7) ? hb_parni(7) : rc.bottom - rc.top ; // JP 61
			rbBand.cyMinChild = hb_parni(6) ? hb_parni(6) : 0 ;
			rbBand.cx         = hb_parni(7) ? hb_parni(7) : rc.bottom - rc.top ;

		}
	}

	SendMessage( (HWND) hb_parnl( 2 ) , RB_INSERTBAND , (WPARAM)-1 , (LPARAM) &rbBand ) ;

}

HB_FUNC( C_SETWINDOWRGN )
{
   HRGN hrgn;
   if ( hb_parni(6)==0)
          SetWindowRgn(GetActiveWindow(),NULL,TRUE);
   else
     {
     if ( hb_parni(6)==1 )
        hrgn=CreateRectRgn(hb_parni(2),hb_parni(3),hb_parni(4),hb_parni(5));
     else
        hrgn=CreateEllipticRgn(hb_parni(2),hb_parni(3),hb_parni(4),hb_parni(5));
     SetWindowRgn(GetActiveWindow(),hrgn,TRUE);
     // Should be hb_parnl(1) instead of GetActiveWindow()
     }
}

HB_FUNC( C_IHAVETODO )
{
   HRGN hrgn1,hrgn2;
   hrgn1=CreateRectRgn(0,0,300,300);
   hrgn2=CreateEllipticRgn(0,0,80,80);
   CombineRgn(hrgn1,hrgn1,hrgn2,RGN_XOR);
   DeleteObject(hrgn2);
   hrgn2=CreateEllipticRgn(0,220,80,300);
   CombineRgn(hrgn1,hrgn1,hrgn2,RGN_XOR);
   DeleteObject(hrgn2);
   SetWindowRgn(GetActiveWindow(),hrgn1,TRUE);
}

HB_FUNC( C_2IHAVETODO )
{
 HRGN hrgn;
 POINT lppt[10];
 int xp[3]={3,3,4};
// int nPoly = 3;
 int fnPolyFillMode=WINDING;

  lppt[0].x=0;
  lppt[0].y=84;
  lppt[1].x=300;
  lppt[1].y=84;
  lppt[2].x=150;
  lppt[2].y=276;

  lppt[3].x=150;
  lppt[3].y=24;
  lppt[4].x=300;
  lppt[4].y=216;
  lppt[5].x=0;
  lppt[5].y=216;

  lppt[6].x=0;
  lppt[6].y=0;
  lppt[7].x=400;
  lppt[7].y=0;
  lppt[8].x=400;
  lppt[8].y=24;
  lppt[9].x=0;
  lppt[9].y=24;

  hrgn=CreatePolyPolygonRgn(lppt,xp,3,fnPolyFillMode);
  SetWindowRgn(GetActiveWindow(),hrgn,TRUE);
//ALTERNATE
//WINDING
}

HB_FUNC( C_SETPOLYWINDOWRGN )
{
 HRGN hrgn;
 POINT lppt[512];
 int i,fnPolyFillMode;
 int cPoints = hb_parinfa(2,0);

 if(hb_parni(4)==1)
         fnPolyFillMode=WINDING;
 else
         fnPolyFillMode=ALTERNATE;

 for(i = 0; i <= cPoints-1; i++)
  {
   lppt[i].x=hb_parni(2,i+1);
   lppt[i].y=hb_parni(3,i+1);
  }
  hrgn=CreatePolygonRgn(lppt,cPoints,fnPolyFillMode);
  SetWindowRgn(GetActiveWindow(),hrgn,TRUE);
}

HB_FUNC( GETHELPDATA )
{
   hb_retnl( (LONG) (((HELPINFO FAR *) hb_parnl(1))->hItemHandle) );
}

HB_FUNC( GETMSKTEXTMESSAGE )
{
   hb_retnl( (LONG) (((MSGFILTER FAR *) hb_parnl(1))->msg) );
}
HB_FUNC( GETMSKTEXTWPARAM )
{
   hb_retnl( (LONG) (((MSGFILTER FAR *) hb_parnl(1))->wParam) );
}
HB_FUNC( GETMSKTEXTLPARAM )
{
   hb_retnl( (LONG) (((MSGFILTER FAR *) hb_parnl(1))->lParam) );
}

HB_FUNC( GETWINDOW )
{
   hb_retnl( ( LONG ) GetWindow( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ) ) );
}


HB_FUNC( GETGRIDOLDSTATE )
{
	#define pnm ((NM_LISTVIEW *) hb_parnl(1) )

	hb_retnl ( (LPARAM) (pnm->uOldState) ) ;

	#undef pnm

}

HB_FUNC( GETGRIDNEWSTATE )
{
	#define pnm ((NM_LISTVIEW *) hb_parnl(1) )

	hb_retnl ( (LPARAM) (pnm->uNewState) ) ;

	#undef pnm

}

HB_FUNC( GETGRIDDISPINFOINDEX )
{

	LV_DISPINFO* pDispInfo = (LV_DISPINFO*)hb_parnl(1);

	int iItem = pDispInfo->item.iItem;

	int iSubItem = pDispInfo->item.iSubItem;

	hb_reta( 2 );
	hb_storni( iItem + 1 , -1, 1 );
	hb_storni( iSubItem + 1 , -1, 2 );

}

HB_FUNC( SETGRIDQUERYDATA )
{
//	LV_DISPINFO* pDispInfo = (LV_DISPINFO*)hb_parnl(1);
//	pDispInfo->item.pszText = hb_parc(2) ;

	PHB_ITEM pValue = hb_itemNew( NULL );
	LV_DISPINFO* pDispInfo = (LV_DISPINFO*)hb_parnl(1);
	hb_itemCopy( pValue, hb_param( 2, HB_IT_STRING ));
	pDispInfo->item.pszText = pValue->item.asString.value;

}

HB_FUNC( SETGRIDQUERYIMAGE )
{
    LV_DISPINFO* pDispInfo = ( LV_DISPINFO * ) hb_parnl( 1 );
    pDispInfo->item.iImage = hb_parni( 2 );
}

HB_FUNC( GETESCAPESTATE )
{
     hb_retni ( GetKeyState( VK_ESCAPE ) );
}

HB_FUNC( GETALTSTATE )
{
     hb_retni ( GetKeyState( VK_MENU ) );
}

HB_FUNC( GETCURSORROW )
{
   POINT pt;
   GetCursorPos( &pt );
   hb_retni( pt.y );
}

HB_FUNC( GETCURSORCOL )
{
   POINT pt;
   GetCursorPos( &pt );
   hb_retni( pt.x );
}

HB_FUNC( ISINSERTACTIVE )
{
   hb_retl( GetKeyState( VK_INSERT ) );
}

HB_FUNC( ISCAPSLOCKACTIVE )
{
   hb_retl( GetKeyState( VK_CAPITAL ) );
}

HB_FUNC( ISNUMLOCKACTIVE )
{
   hb_retl( GetKeyState( VK_NUMLOCK ) );
}

HB_FUNC( ISSCROLLLOCKACTIVE )
{
   hb_retl( GetKeyState( VK_SCROLL ) );
}

HB_FUNC( FINDWINDOWEX )
{
   hb_retnl( (LONG) FindWindowEx( (HWND) hb_parnl( 1 ) ,
                                  (HWND) hb_parnl( 2 ) ,
                                  (LPCSTR) hb_parc( 3 ),
                                  (LPCSTR) hb_parc( 4 )
                                ) ) ;
}

HB_FUNC( INITDUMMY )
{

	CreateWindowEx( 0 , "static" , "" ,
	WS_CHILD ,
	0, 0 , 0, 0,
	(HWND) hb_parnl (1),(HMENU)0 , GetModuleHandle(NULL) , NULL ) ;

}

HB_FUNC( REGISTERSPLITCHILDWINDOW )
{
	WNDCLASS WndClass;

	HBRUSH hbrush = 0 ;

	WndClass.style         = CS_OWNDC ;
	WndClass.lpfnWndProc   = WndProc;
	WndClass.cbClsExtra    = 0;
	WndClass.cbWndExtra    = 0;
	WndClass.hInstance     = GetModuleHandle( NULL );
	WndClass.hIcon         = LoadIcon(GetModuleHandle(NULL),  hb_parc(1) );
	if (WndClass.hIcon==NULL)
	{
		WndClass.hIcon= (HICON) LoadImage( GetModuleHandle(NULL),  hb_parc(1) , IMAGE_ICON, 0, 0, LR_LOADFROMFILE + LR_DEFAULTSIZE ) ;
	}
	if (WndClass.hIcon==NULL)
	{
		WndClass.hIcon= LoadIcon(NULL, IDI_APPLICATION);
	}
	WndClass.hCursor       = LoadCursor(NULL, IDC_ARROW);

	if ( hb_parni(3, 1) == -1 )
	{
		WndClass.hbrBackground = (HBRUSH)( COLOR_BTNFACE + 1 );
	}
	else
	{
		hbrush = CreateSolidBrush( RGB(hb_parni(3, 1), hb_parni(3, 2), hb_parni(3, 3)) );
		WndClass.hbrBackground = hbrush ;
	}

	WndClass.lpszMenuName  = NULL;
	WndClass.lpszClassName = hb_parc(2);

	if(!RegisterClass(&WndClass))
	{
	MessageBox(0, "Window Registration Failed!", "Error!",
	MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);
	ExitProcess(0);
	}
	hb_retnl ( (LONG) hbrush ) ;
}