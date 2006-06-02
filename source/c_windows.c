/*
 * $Id: c_windows.c,v 1.43 2006-06-02 02:05:11 guerra000 Exp $
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

/* Handle to a DIB */
#define HDIB HANDLE

/* DIB constants */
#define PALVERSION   0x300

/* DIB macros */
#define IS_WIN30_DIB(lpbi)  ((*(LPDWORD)(lpbi)) == sizeof(BITMAPINFOHEADER))
#define RECTWIDTH(lpRect)     ((lpRect)->right - (lpRect)->left)
#define RECTHEIGHT(lpRect)    ((lpRect)->bottom - (lpRect)->top)



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

#ifdef HB_ITEM_NIL
   #define hb_dynsymSymbol( pDynSym )        ( ( pDynSym )->pSymbol )
#endif

BOOL Array2Rect(PHB_ITEM aRect, RECT *rc ) ;

static void ChangeNotifyIcon( HWND hWnd, HICON hIcon, LPSTR szText );
static void ShowNotifyIcon( HWND hWnd, BOOL bAdd, HICON hIcon, LPSTR szText );

static PHB_SYMB _ooHG_Symbol_TForm = 0;
static PHB_ITEM _OOHG_aFormhWnd, _OOHG_aFormObjects;

HB_FUNC( _OOHG_INIT_C_VARS_C_SIDE )
{
   _ooHG_Symbol_TForm = hb_dynsymSymbol( hb_dynsymFind( "TFORM" ) );
   _OOHG_aFormhWnd    = hb_itemNew( NULL );
   _OOHG_aFormObjects = hb_itemNew( NULL );
   hb_itemCopy( _OOHG_aFormhWnd,    hb_param( 1, HB_IT_ARRAY ) );
   hb_itemCopy( _OOHG_aFormObjects, hb_param( 2, HB_IT_ARRAY ) );
}

PHB_ITEM GetFormObjectByHandle( LONG hWnd )
{
   PHB_ITEM pForm;
   ULONG ulCount;

   if( ! _ooHG_Symbol_TForm )
   {
      hb_vmPushSymbol( hb_dynsymSymbol( hb_dynsymFind( "_OOHG_INIT_C_VARS" ) ) );
      hb_vmPushNil();
      hb_vmDo( 0 );
   }

   pForm = 0;
   for( ulCount = 1; ulCount <= hb_arrayLen( _OOHG_aFormhWnd ); ulCount++ )
   {
      if( hWnd == hb_arrayGetNL( _OOHG_aFormhWnd, ulCount ) )
      {
         pForm = hb_arrayGetItemPtr( _OOHG_aFormObjects, ulCount );
         ulCount = hb_arrayLen( _OOHG_aFormhWnd );
      }
   }
   if( ! pForm )
   {
      hb_vmPushSymbol( _ooHG_Symbol_TForm );
      hb_vmPushNil();
      hb_vmDo( 0 );
      pForm = hb_param( -1, HB_IT_ANY );
   }

   return pForm;
}

HB_FUNC( GETFORMOBJECTBYHANDLE )
{
   PHB_ITEM pReturn;

   pReturn = hb_itemNew( NULL );
   hb_itemCopy( pReturn, GetFormObjectByHandle( hb_parnl( 1 ) ) );

   hb_itemReturn( pReturn );
   hb_itemRelease( pReturn );
}

LRESULT APIENTRY _OOHG_WndProc( PHB_ITEM pSelf, HWND hWnd, UINT uiMsg, WPARAM wParam, LPARAM lParam, WNDPROC lpfnOldWndProc )
{
   PHB_ITEM pResult;
   LRESULT APIENTRY iReturn;

   _OOHG_Send( pSelf, s_OverWndProc );
   hb_vmSend( 0 );
   pResult = hb_param( -1, HB_IT_BLOCK );
   // ::OverWndProc is a codeblock... execute it
   if( pResult )
   {
      hb_vmPushSymbol( &hb_symEval );
      hb_vmPush( pResult );
      hb_vmPushLong( ( LONG ) hWnd );
      hb_vmPushLong( uiMsg );
      hb_vmPushLong( wParam );
      hb_vmPushLong( lParam );
      hb_vmPush( pSelf );
      hb_vmDo( 5 );
      pResult = hb_param( -1, HB_IT_NUMERIC );
   }

   // ::OverWndProc is NOT a codeblock, or it returns a non-numeric value... execute ::Events()
   if( ! pResult )
   {
      _OOHG_Send( pSelf, s_Events );
      hb_vmPushLong( ( LONG ) hWnd );
      hb_vmPushLong( uiMsg );
      hb_vmPushLong( wParam );
      hb_vmPushLong( lParam );
      hb_vmSend( 4 );
      pResult = hb_param( -1, HB_IT_NUMERIC );
   }

   if( pResult )
   {
      // Return value is numeric... return it to Windows
      iReturn = hb_itemGetNL( pResult );
   }
   else
   {
      // Return value is NOT numeric... execute default WindowProc
      iReturn = CallWindowProc( lpfnOldWndProc, hWnd, uiMsg, wParam, lParam );
   }

   return iReturn;
}

LRESULT APIENTRY _OOHG_WndProcCtrl( HWND hWnd, UINT uiMsg, WPARAM wParam, LPARAM lParam, WNDPROC lpfnOldWndProc )
{
   PHB_ITEM pSave, pSelf;
   LRESULT APIENTRY iReturn;

   pSave = hb_itemNew( NULL );
   pSelf = hb_itemNew( NULL );
   hb_itemCopy( pSave, hb_param( -1, HB_IT_ANY ) );
   hb_itemCopy( pSelf, GetControlObjectByHandle( ( LONG ) hWnd ) );

   iReturn = _OOHG_WndProc( pSelf, hWnd, uiMsg, wParam, lParam, lpfnOldWndProc );

   hb_itemReturn( pSave );
   hb_itemRelease( pSave );
   hb_itemRelease( pSelf );

   return iReturn;
}

LRESULT APIENTRY _OOHG_WndProcForm( HWND hWnd, UINT uiMsg, WPARAM wParam, LPARAM lParam, WNDPROC lpfnOldWndProc )
{
   PHB_ITEM pSave, pSelf;
   LRESULT APIENTRY iReturn;

   pSave = hb_itemNew( NULL );
   pSelf = hb_itemNew( NULL );
   hb_itemCopy( pSave, hb_param( -1, HB_IT_ANY ) );
   hb_itemCopy( pSelf, GetFormObjectByHandle( ( LONG ) hWnd ) );

   iReturn = _OOHG_WndProc( pSelf, hWnd, uiMsg, wParam, lParam, lpfnOldWndProc );

   hb_itemReturn( pSave );
   hb_itemRelease( pSave );
   hb_itemRelease( pSelf );

   return iReturn;
}

LRESULT CALLBACK WndProc( HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcForm( hWnd, message, wParam, lParam, DefWindowProc );
}

LRESULT CALLBACK WndProcMdiChild( HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcForm( hWnd, message, wParam, lParam, DefMDIChildProc );
}

LRESULT CALLBACK _OOHG_DefFrameProc( HWND hWnd, UINT uiMsg, WPARAM wParam, LPARAM lParam )
{
   _OOHG_Send( GetFormObjectByHandle( ( LONG ) hWnd ), s_hWndClient );
   hb_vmSend( 0 );
   return DefFrameProc( hWnd, ( HWND ) hb_parnl( -1 ), uiMsg, wParam, lParam );
}

LRESULT CALLBACK WndProcMdi( HWND hWnd, UINT uiMsg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcForm( hWnd, uiMsg, wParam, lParam, _OOHG_DefFrameProc );
}

HB_FUNC( INITWINDOW )
{
   HWND hwnd;
   int Style   = hb_parni( 8 );
   int ExStyle = hb_parni( 9 );

   ExStyle |= _OOHG_RTL_Status( hb_parl( 10 ) );

/*
MDICLIENT:
   + Establecer el menú con los nombres de las ventanas
    icount = GetMenuItemCount(GetMenu(hwndparent));
    ccs.hWindowMenu  = GetSubMenu(GetMenu(hwndparent), icount-2);
    ccs.idFirstChild = 0;
    hwndMDIClient = CreateWindow("mdiclient", NULL, style, 0, 0, 0, 0, hwndparent, (HMENU)0xCAC, GetModuleHandle(NULL), (LPSTR) &ccs);

MDICHILD:
   + "Título" automático de la ventana... rgch[]
	mcs.szClass = "MdiChildWndClass";      // window class name
	mcs.szTitle = rgch;                    // window title
	mcs.hOwner  = GetModuleHandle(NULL);   // owner
	mcs.x       = hb_parni (3);            // x position
	mcs.y       = hb_parni (4);            // y position
	mcs.cx      = hb_parni (5);            // width
	mcs.cy      = hb_parni (6);            // height
	mcs.style   = Style;                   // window style
	mcs.lParam  = 0;                       // lparam
    hwndChild = (HWND) SendMessage((HWND) hb_parnl(1), WM_MDICREATE, 0, (LPARAM)(LPMDICREATESTRUCT) &mcs);
*/
   hwnd = CreateWindowEx( ExStyle, hb_parc( 7 ), hb_parc( 1 ), Style,
                          hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ),
                          ( HWND ) hb_parnl ( 6 ), ( HMENU ) NULL, GetModuleHandle( NULL ), NULL );

   if( ! hwnd )
   {
      char cBuffError[ 1000 ];
      sprintf( cBuffError, "Window %s Creation Failed! Error %i", hb_parc( 7 ), GetLastError() );
      MessageBox( 0, cBuffError, "Error!",
                  MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
      return;
   }

   hb_retnl( ( LONG ) hwnd );
}

HB_FUNC( INITWINDOWMDICLIENT )
{
   HWND hwnd;
   int Style   = hb_parni( 8 );
   int ExStyle = hb_parni( 9 );
   CLIENTCREATESTRUCT ccs;

   ccs.hWindowMenu = NULL;
   ccs.idFirstChild = 0;

   ExStyle |= _OOHG_RTL_Status( hb_parl( 10 ) );

/*
MDICLIENT:
   + Establecer el menú con los nombres de las ventanas
    icount = GetMenuItemCount(GetMenu(hwndparent));
    ccs.hWindowMenu  = GetSubMenu(GetMenu(hwndparent), icount-2);
    ccs.idFirstChild = 0;
    hwndMDIClient = CreateWindow("mdiclient", NULL, style, 0, 0, 0, 0, hwndparent, (HMENU)0xCAC, GetModuleHandle(NULL), (LPSTR) &ccs);

MDICHILD:
   + "Título" automático de la ventana... rgch[]
	mcs.szClass = "MdiChildWndClass";      // window class name
	mcs.szTitle = rgch;                    // window title
	mcs.hOwner  = GetModuleHandle(NULL);   // owner
	mcs.x       = hb_parni (3);            // x position
	mcs.y       = hb_parni (4);            // y position
	mcs.cx      = hb_parni (5);            // width
	mcs.cy      = hb_parni (6);            // height
	mcs.style   = Style;                   // window style
	mcs.lParam  = 0;                       // lparam
    hwndChild = (HWND) SendMessage((HWND) hb_parnl(1), WM_MDICREATE, 0, (LPARAM)(LPMDICREATESTRUCT) &mcs);
*/
   hwnd = CreateWindowEx( ExStyle, "MDICLIENT", hb_parc( 1 ), Style,
                          hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ),
                          ( HWND ) hb_parnl ( 6 ), ( HMENU ) NULL, GetModuleHandle( NULL ), ( LPSTR ) &ccs );

   if( ! hwnd )
   {
      char cBuffError[ 1000 ];
      sprintf( cBuffError, "Window %s Creation Failed! Error %i", hb_parc( 7 ), GetLastError() );
      MessageBox( 0, cBuffError, "Error!",
                  MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
      return;
   }

   hb_retnl( ( LONG ) hwnd );
}

void _OOHG_ProcessMessage( PMSG Msg )
{
   PHB_ITEM pSelf, pSave;
   LONG hWnd;

   // Saves current result
   pSave = hb_itemNew( NULL );
   hb_itemCopy( pSave, hb_param( -1, HB_IT_ANY ) );

   switch( Msg->message )
   {
      case WM_KEYDOWN:
      case WM_SYSKEYDOWN:
         hWnd = ( LONG ) Msg->hwnd;
         pSelf = hb_itemNew( NULL );
         while( hWnd && ! HB_IS_OBJECT( pSelf ) )
         {
            hb_itemCopy( pSelf, GetFormObjectByHandle( hWnd ) );
            _OOHG_Send( pSelf, s_hWnd );
            hb_vmSend( 0 );
            if( hb_parnl( -1 ) != hWnd )
            {
               hb_itemCopy( pSelf, GetControlObjectByHandle( hWnd ) );
               _OOHG_Send( pSelf, s_hWnd );
               hb_vmSend( 0 );
               if( hb_parnl( -1 ) != hWnd )
               {
                  hWnd = ( LONG ) GetParent( ( HWND ) hWnd );
                  hb_itemClear( pSelf );
               }
            }
         }
         if( hWnd && HB_IS_OBJECT( pSelf ) )
         {
            _OOHG_Send( pSelf, s_LookForKey );
            hb_vmPushInteger( Msg->wParam );
            hb_vmPushInteger( GetKeyFlagState() );
            hb_vmSend( 2 );
            if( hb_parl( -1 ) )
            {
               hb_itemRelease( pSelf );
               break;
            }
         }
         hb_itemRelease( pSelf );

      default:
         if( ! IsWindow( GetActiveWindow() ) || ! IsDialogMessage( GetActiveWindow(), Msg ) )
         {
            TranslateMessage( Msg );
            DispatchMessage( Msg );
         }
         break;
   }

   // Restores result
   hb_itemReturn( pSave );
   hb_itemRelease( pSave );
}

HB_FUNC( _DOMESSAGELOOP )
{
   MSG Msg;

   while( GetMessage( &Msg, NULL, 0, 0 ) )
   {
      _OOHG_ProcessMessage( &Msg );
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

HB_FUNC( GETGRIDCOLUMN )
{
   hb_retnl ( ( LPARAM ) ( ( ( NM_LISTVIEW * ) hb_parnl( 1 ) )->iSubItem ) ) ;
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

HB_FUNC( GETWINDOWRECT )
{
   RECT rect;
   hb_retl( GetWindowRect( ( HWND ) hb_parnl( 1 ), &rect ) );
   hb_stornl( rect.left, 2, 1 );
   hb_stornl( rect.top, 2, 2 );
   hb_stornl( rect.right, 2, 3 );
   hb_stornl( rect.bottom, 2, 4 );
}

HB_FUNC( GETCLIENTRECT )
{
   RECT rect;
   hb_retl( GetClientRect( ( HWND ) hb_parnl( 1 ), &rect ) );
   hb_stornl( rect.left, 2, 1 );
   hb_stornl( rect.top, 2, 2 );
   hb_stornl( rect.right, 2, 3 );
   hb_stornl( rect.bottom, 2, 4 );
}

HB_FUNC( REGISTERWINDOW )
{
   WNDCLASS WndClass;
   HBRUSH hbrush = 0;
   int iWindowType = hb_parni( 4 );
   LONG lColor;

   WndClass.style         = CS_HREDRAW | CS_VREDRAW | CS_OWNDC;
   WndClass.lpfnWndProc   = WndProc;
   WndClass.lpszClassName = hb_parc( 2 );

   switch( iWindowType )
   {
      case 1:                           // Splitchild
         WndClass.style         = CS_OWNDC;
         break;

      case 2:                           // MDI client
         WndClass.style         = CS_HREDRAW | CS_VREDRAW /* | CS_OWNDC */ | CS_DBLCLKS;
         WndClass.lpfnWndProc   = WndProcMdiChild;
         WndClass.lpszClassName = "MDICLIENT";
         break;

      case 3:                           // MDI child
         WndClass.style         = 0;
         WndClass.lpfnWndProc   = WndProcMdiChild;
         break;

      case 4:                           // MDI frame
         WndClass.style         = CS_HREDRAW | CS_VREDRAW /* | CS_OWNDC */ | CS_DBLCLKS;
         WndClass.lpfnWndProc   = WndProcMdi;
         break;
   }
   WndClass.cbClsExtra    = 0;
   WndClass.cbWndExtra    = 0;
//    WndClass.cbWndExtra    = 20;   MDICHILD!
   WndClass.hInstance     = GetModuleHandle( NULL );
   WndClass.hIcon         = LoadIcon( GetModuleHandle(NULL), hb_parc( 1 ) );
   if (WndClass.hIcon==NULL)
   {
      WndClass.hIcon= (HICON) LoadImage( GetModuleHandle(NULL),  hb_parc(1) , IMAGE_ICON, 0, 0, LR_LOADFROMFILE + LR_DEFAULTSIZE ) ;
   }
   if (WndClass.hIcon==NULL)
   {
       WndClass.hIcon= LoadIcon(NULL, IDI_APPLICATION);
   }
   WndClass.hCursor       = LoadCursor( NULL, IDC_ARROW );

   lColor = -1;
   _OOHG_DetermineColor( hb_param( 3, HB_IT_ANY ), &lColor );
   if( lColor == -1 )
   {
      WndClass.hbrBackground = ( HBRUSH )( COLOR_BTNFACE + 1 );
   }
   else
   {
      hbrush = CreateSolidBrush( lColor );
      WndClass.hbrBackground = hbrush;
   }

   WndClass.lpszMenuName  = NULL;
   if( ! RegisterClass( &WndClass ) )
   {
      char cBuffError[ 1000 ];
      sprintf( cBuffError, "Window %s Registration Failed! Error %i", hb_parc( 2 ), GetLastError() );
      MessageBox( 0, cBuffError, "Error!",
                  MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
      ExitProcess( 0 );
   }

   hb_retnl ( (LONG) hbrush ) ;
}

HB_FUNC ( UNREGISTERWINDOW )
{
	UnregisterClass ( hb_parc(1), GetModuleHandle( NULL ) ) ;
}

HB_FUNC( SETWINDOWBACKCOLOR )
{
   HWND hWnd = ( HWND ) hb_parnl( 1 );
   HBRUSH hBrush, color;

   if( hb_param( 2, HB_IT_ARRAY ) == 0 || hb_parni( 3, 1 ) == -1 )
   {
      hBrush = 0;
      color = ( HBRUSH )( COLOR_BTNFACE + 1 );
   }
   else
   {
      hBrush = CreateSolidBrush( RGB( hb_parni( 2, 1 ), hb_parni( 2, 2 ), hb_parni( 2, 3 ) ) );
      color = hBrush;
   }

   SetClassLong( hWnd, GCL_HBRBACKGROUND, ( LONG ) color );

   RedrawWindow( hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );

   hb_retnl( ( ULONG ) hBrush );
}

HB_FUNC (GETDESKTOPWIDTH)
{
	hb_retni ( GetSystemMetrics(SM_CXSCREEN) ) ;
}

HB_FUNC (GETDESKTOPHEIGHT)
{
   hb_retni ( GetSystemMetrics(SM_CYSCREEN) ) ;
}

HB_FUNC (GETWINDOWROW)
{
   RECT rect;
   hb_xmemset( &rect, 0, sizeof( rect ) );
   GetWindowRect( ( HWND ) hb_parnl( 1 ), &rect );
   hb_retni( rect.top );
}

HB_FUNC (GETWINDOWCOL)
{
   RECT rect;
   hb_xmemset( &rect, 0, sizeof( rect ) );
   GetWindowRect( ( HWND ) hb_parnl( 1 ), &rect );
   hb_retni( rect.left );
}

HB_FUNC (GETWINDOWWIDTH)
{
   RECT rect;
   hb_xmemset( &rect, 0, sizeof( rect ) );
   GetWindowRect( ( HWND ) hb_parnl( 1 ), &rect );
   hb_retni( rect.right - rect.left );
}

HB_FUNC (GETWINDOWHEIGHT)
{
   RECT rect;
   hb_xmemset( &rect, 0, sizeof( rect ) );
   GetWindowRect( ( HWND ) hb_parnl( 1 ), &rect );
   hb_retni( rect.bottom - rect.top );
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

HB_FUNC ( GETITEMPOS )
{
   hb_retnl( (LONG) (((NMMOUSE FAR *) hb_parnl(1))->dwItemSpec) );
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
    pDispInfo->item.pszText = hb_itemGetCPtr( pValue );

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

WORD DIBNumColors(LPSTR);
WORD PaletteSize(LPSTR);
WORD SaveDIB(HDIB , LPSTR);
HANDLE DDBToDIB(HBITMAP , HPALETTE );

HB_FUNC( WNDCOPY  )  //  hWnd        Copies any Window to the Clipboard!
{
   HWND hWnd = ( HWND ) hb_parnl( 1 );
   BOOL bAll = hb_parl( 2 );
   HDC  hDC  = GetDC( hWnd );
   HDC  hMemDC;
   RECT rct;
   HBITMAP hBitmap, hOldBmp;
   HPALETTE  hPal = NULL;
   LPSTR myFile =  hb_parc( 3 ) ;
   HANDLE hDIB;
   if( bAll )
      GetWindowRect( hWnd, &rct );
   else
      GetClientRect( hWnd, &rct );

      hMemDC  = CreateCompatibleDC( hDC );
      hBitmap = CreateCompatibleBitmap( hDC, rct.right-rct.left, rct.bottom-rct.top );
      hOldBmp = ( HBITMAP ) SelectObject( hMemDC, hBitmap );

      BitBlt( hMemDC, 0, 0, rct.right-rct.left, rct.bottom-rct.top, hDC, 0, 0, SRCCOPY );


      SelectObject( hMemDC, hOldBmp );

      hDIB = DDBToDIB(hBitmap ,hPal);

      SaveDIB(hDIB , myFile);

      DeleteDC( hMemDC );

      GlobalFree (hDIB);
   ReleaseDC( hWnd, hDC );
}

WORD PaletteSize(LPSTR lpDIB)
{
    // calculate the size required by the palette
    if (IS_WIN30_DIB (lpDIB))
        return (WORD) (DIBNumColors(lpDIB) * sizeof(RGBQUAD));
    else
        return (WORD) (DIBNumColors(lpDIB) * sizeof(RGBTRIPLE));
}


WORD DIBNumColors(LPSTR lpDIB)
{
    WORD wBitCount;  // DIB bit count

    // If this is a Windows-style DIB, the number of colors in the
    // color table can be less than the number of bits per pixel
    // allows for (i.e. lpbi->biClrUsed can be set to some value).
    // If this is the case, return the appropriate value.


    if (IS_WIN30_DIB(lpDIB))
    {
        DWORD dwClrUsed;

        dwClrUsed = ((LPBITMAPINFOHEADER)lpDIB)->biClrUsed;
        if (dwClrUsed)

        return (WORD)dwClrUsed;
    }

    // Calculate the number of colors in the color table based on
    // the number of bits per pixel for the DIB.

    if (IS_WIN30_DIB(lpDIB))
        wBitCount = ((LPBITMAPINFOHEADER)lpDIB)->biBitCount;
    else
        wBitCount = ((LPBITMAPCOREHEADER)lpDIB)->bcBitCount;

    // return number of colors based on bits per pixel

    switch (wBitCount)
    {
        case 1:
            return 2;

        case 4:
            return 16;

        case 8:
            return 256;

        default:
            return 0;
    }
}

HANDLE DDBToDIB(HBITMAP hBitmap, HPALETTE hPal)
{
    BITMAP              bm;         // bitmap structure
    BITMAPINFOHEADER    bi;         // bitmap header
    LPBITMAPINFOHEADER  lpbi;       // pointer to BITMAPINFOHEADER
    DWORD               dwLen;      // size of memory block
    HANDLE              hDIB, h;    // handle to DIB, temp handle
    HDC                 hDC;        // handle to DC
    WORD                biBits;     // bits per pixel

    // check if bitmap handle is valid

    if (!hBitmap)
        return NULL;

    // fill in BITMAP structure, return NULL if it didn't work

    if (!GetObject(hBitmap, sizeof(bm), (LPSTR)&bm))
        return NULL;

    // if no palette is specified, use default palette

    if (hPal == NULL)
        hPal = GetStockObject(DEFAULT_PALETTE);

    // calculate bits per pixel

    biBits = ( WORD ) ( bm.bmPlanes * bm.bmBitsPixel );

    // make sure bits per pixel is valid

    if (biBits <= 1)
        biBits = 1;
    else if (biBits <= 4)
        biBits = 4;
    else if (biBits <= 8)
        biBits = 8;
    else // if greater than 8-bit, force to 24-bit
        biBits = 24;

    // initialize BITMAPINFOHEADER

    bi.biSize = sizeof(BITMAPINFOHEADER);
    bi.biWidth = bm.bmWidth;
    bi.biHeight = bm.bmHeight;
    bi.biPlanes = 1;
    bi.biBitCount = biBits;
    bi.biCompression = BI_RGB;
    bi.biSizeImage = 0;
    bi.biXPelsPerMeter = 0;
    bi.biYPelsPerMeter = 0;
    bi.biClrUsed = 0;
    bi.biClrImportant = 0;

    // calculate size of memory block required to store BITMAPINFO

    dwLen = bi.biSize + PaletteSize((LPSTR)&bi);

    // get a DC

    hDC = GetDC(NULL);

    // select and realize our palette

    hPal = SelectPalette(hDC, hPal, FALSE);
    RealizePalette(hDC);

    // alloc memory block to store our bitmap

    hDIB = GlobalAlloc(GHND, dwLen);

    // if we couldn't get memory block

    if (!hDIB)
    {
      // clean up and return NULL

      SelectPalette(hDC, hPal, TRUE);
      RealizePalette(hDC);
      ReleaseDC(NULL, hDC);
      return NULL;
    }

    // lock memory and get pointer to it

    lpbi = (LPBITMAPINFOHEADER)GlobalLock(hDIB);

    /// use our bitmap info. to fill BITMAPINFOHEADER

    *lpbi = bi;

    // call GetDIBits with a NULL lpBits param, so it will calculate the
    // biSizeImage field for us

    GetDIBits(hDC, hBitmap, 0, (UINT)bi.biHeight, NULL, (LPBITMAPINFO)lpbi,
        DIB_RGB_COLORS);

    // get the info. returned by GetDIBits and unlock memory block

    bi = *lpbi;
    GlobalUnlock(hDIB);

    // if the driver did not fill in the biSizeImage field, make one up
    if (bi.biSizeImage == 0)
        bi.biSizeImage = ((((DWORD)bm.bmWidth * biBits)+ 31) / 32 * 4) * bm.bmHeight;
    // realloc the buffer big enough to hold all the bits

    dwLen = bi.biSize + PaletteSize((LPSTR)&bi) + bi.biSizeImage;

    h = GlobalReAlloc(hDIB, dwLen, 0);
    if ( h )
    {
        hDIB = h;
    }
    else
    {
        // clean up and return NULL

        GlobalFree(hDIB);
///        hDIB = NULL;
        SelectPalette(hDC, hPal, TRUE);
        RealizePalette(hDC);
        ReleaseDC(NULL, hDC);
        return NULL;
    }

    // lock memory block and get pointer to it */

    lpbi = (LPBITMAPINFOHEADER)GlobalLock(hDIB);

    // call GetDIBits with a NON-NULL lpBits param, and actualy get the
    // bits this time

    if (GetDIBits(hDC, hBitmap, 0, (UINT)bi.biHeight, (LPSTR)lpbi +
            (WORD)lpbi->biSize + PaletteSize((LPSTR)lpbi), (LPBITMAPINFO)lpbi,
            DIB_RGB_COLORS) == 0)
    {
        // clean up and return NULL

        GlobalFree(hDIB);

///////        hDIB = NULL;

        SelectPalette(hDC, hPal, TRUE);
        RealizePalette(hDC);
        ReleaseDC(NULL, hDC);
        return NULL;
    }

    bi = *lpbi;

    // clean up
    GlobalUnlock(hDIB);
    SelectPalette(hDC, hPal, TRUE);
    RealizePalette(hDC);
    ReleaseDC(NULL, hDC);

    // return handle to the DIB
    return hDIB;
}

WORD SaveDIB(HDIB hDib, LPSTR lpFileName)
{
    BITMAPFILEHEADER    bmfHdr;     // Header for Bitmap file
    LPBITMAPINFOHEADER  lpBI;       // Pointer to DIB info structure
    HANDLE              fh;         // file handle for opened file
    DWORD               dwDIBSize;
    DWORD               dwWritten;
    DWORD               dwBmBitsSize;

    fh = CreateFile(lpFileName, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS,
            FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN, NULL);


    // Get a pointer to the DIB memory, the first of which contains
    // a BITMAPINFO structure

    lpBI = (LPBITMAPINFOHEADER)GlobalLock(hDib);
    if (!lpBI)
    {
        CloseHandle(fh);
        return 1;
    }

    if (lpBI->biSize != sizeof(BITMAPINFOHEADER))
    {
        GlobalUnlock(hDib);
        CloseHandle(fh);
        return 1;
    }


    bmfHdr.bfType = ((WORD) ('M' << 8) | 'B'); // is always "BM"

    dwDIBSize = *(LPDWORD)lpBI + PaletteSize((LPSTR)lpBI);


    dwBmBitsSize = ((((lpBI->biWidth)*((DWORD)lpBI->biBitCount))+ 31) / 32 * 4) *  lpBI->biHeight;
    dwDIBSize += dwBmBitsSize;
    lpBI->biSizeImage = dwBmBitsSize;


    bmfHdr.bfSize = dwDIBSize + sizeof(BITMAPFILEHEADER);
    bmfHdr.bfReserved1 = 0;
    bmfHdr.bfReserved2 = 0;

    // Now, calculate the offset the actual bitmap bits will be in
    // the file -- It's the Bitmap file header plus the DIB header,
    // plus the size of the color table.

    bmfHdr.bfOffBits = (DWORD)sizeof(BITMAPFILEHEADER) + lpBI->biSize +
            PaletteSize((LPSTR)lpBI);

    // Write the file header

    WriteFile(fh, (LPSTR)&bmfHdr, sizeof(BITMAPFILEHEADER), &dwWritten, NULL);

    // Write the DIB header and the bits -- use local version of
    // MyWrite, so we can write more than 32767 bytes of data

    WriteFile(fh, (LPSTR)lpBI, dwDIBSize, &dwWritten, NULL);

    GlobalUnlock(hDib);
    CloseHandle(fh);

    if (dwWritten == 0)
        return 1; // oops, something happened in the write
    else
        return 0; // Success code
}

HB_FUNC( _UPDATERTL )
{
   HWND hwnd;
   LONG myret;
   hwnd = ( HWND ) hb_parnl (1);
   myret = GetWindowLong( hwnd, GWL_EXSTYLE );
   if( hb_parnl( 2 ) )
   {
      myret = myret |  WS_EX_LTRREADING |  WS_EX_LEFT |  WS_EX_LEFTSCROLLBAR;
//      myret = myret                    &~ WS_EX_LTRREADING &~ WS_EX_LEFT;
//      myret = myret |  WS_EX_LAYOUTRTL |  WS_EX_RTLREADING |  WS_EX_RIGHT;
   }
   else
   {
      myret = myret &~ WS_EX_LTRREADING &~ WS_EX_LEFT &~ WS_EX_LEFTSCROLLBAR;
//      myret = myret                    |  WS_EX_LTRREADING |  WS_EX_LEFT;
//      myret = myret &~ WS_EX_LAYOUTRTL &~ WS_EX_RTLREADING &~ WS_EX_RIGHT;
   }
   SetWindowLong( hwnd, GWL_EXSTYLE, myret );

   hb_retni( myret );
}

DWORD _OOHG_RTL_Status( BOOL bRtl )
{
   DWORD dwStyle;

   if( bRtl )
   {
      #ifdef WS_EX_LAYOUTRTL
         dwStyle = WS_EX_LAYOUTRTL | WS_EX_RIGHTSCROLLBAR | WS_EX_RTLREADING;
      #else
         dwStyle =                   WS_EX_RIGHTSCROLLBAR | WS_EX_RTLREADING;
      #endif
   }
   else
   {
      dwStyle = 0;
   }

   return dwStyle;
}

HB_FUNC( GETSYSTEMMETRICS )
{
    hb_retni( GetSystemMetrics( hb_parni( 1 ) ) );
}
