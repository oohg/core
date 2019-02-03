/*
 * $Id: c_windows.c $
 */
/*
 * ooHG source code:
 * Windows handling functions
 *
 * Copyright 2005-2018 Vicente Guerra <vicente@guerra.com.mx>
 * https://oohg.github.io/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2018, https://harbour.github.io/
 */
/*
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
 * along with this software; see the file LICENSE.txt. If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1335,USA (or download from http://www.gnu.org/licenses/).
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
 */


#ifndef WINVER
   #define WINVER 0x0500
#endif
#if ( WINVER < 0x0500 )
   #undef WINVER
   #define WINVER 0x0500
#endif

#ifndef _WIN32_IE
   #define _WIN32_IE 0x0500
#endif
#if ( _WIN32_IE < 0x0500 )
   #undef _WIN32_IE
   #define _WIN32_IE 0x0500
#endif

#ifndef _WIN32_WINNT
   #define _WIN32_WINNT 0x0500
#endif
#if ( _WIN32_WINNT < 0x0500 )
   #undef _WIN32_WINNT
   #define _WIN32_WINNT 0x0500
#endif

/* Handle to a DIB */
#define HDIB HANDLE

/* DIB constants */
#define PALVERSION   0x300

/* DIB macros */
#define IS_WIN30_DIB( lpbi ) ( (* (LPDWORD) (lpbi) ) == sizeof( BITMAPINFOHEADER ) )
#define RECTWIDTH( lpRect ) ( (lpRect)->right - (lpRect)->left )
#define RECTHEIGHT( lpRect ) ( (lpRect)->bottom - (lpRect)->top )

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
#include "oohg.h"

BOOL Array2Rect( PHB_ITEM aRect, RECT *rc );

PHB_ITEM _OOHG_GetExistingObject( HWND hWnd, BOOL bForm, BOOL bForceAny )
{
   PHB_ITEM pItem = NULL;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );

   while( hWnd && ! pItem )
   {
      if( _OOHG_SearchControlHandleInArray( hWnd ) )
      {
         pItem = GetControlObjectByHandle( hWnd, FALSE );
      }
      else if( bForm && _OOHG_SearchFormHandleInArray( hWnd ) )
      {
         pItem = GetFormObjectByHandle( hWnd, FALSE );
      }
      else
      {
         hWnd = GetParent( hWnd );
      }
   }

   if( ! pItem && bForceAny )
   {
      pItem = GetControlObjectByHandle( hWnd, FALSE );
   }

   ReleaseMutex( _OOHG_GlobalMutex() );

   return pItem;
}

#define _MDI_Limit 64

int _MDI_Count = 0;
HWND _MDI_Items[ _MDI_Limit ][ 2 ];

HB_FUNC( _OOHG_ADDMDI )
{
   if( _MDI_Count < _MDI_Limit )
   {
      _MDI_Items[ _MDI_Count ][ 0 ] = HWNDparam( 1 );   // MDI Client (work area)
      _MDI_Items[ _MDI_Count ][ 1 ] = HWNDparam( 2 );   // MDI Frame (main window)
      _MDI_Count++;
   }
}

HB_FUNC( _OOHG_REMOVEMDI )
{
   int iPos;
   HWND hWndClient;

   hWndClient = HWNDparam( 1 );
   iPos = _MDI_Count;
   while( iPos )
   {
      iPos--;
      if( _MDI_Items[ iPos ][ 0 ] == hWndClient )
      {
         _MDI_Count--;
         if( iPos != _MDI_Count )
         {
            _MDI_Items[ iPos ][ 0 ] = _MDI_Items[ _MDI_Count ][ 0 ];
            _MDI_Items[ iPos ][ 1 ] = _MDI_Items[ _MDI_Count ][ 1 ];
         }
      }
   }
}

void _OOHG_ProcessMessage( PMSG Msg )
{
   PHB_ITEM pSelf, pSave;
   HWND hWnd;
   int bCheck = 1;

   // Saves current result
   pSave = hb_itemNew( NULL );
   hb_itemCopy( pSave, hb_param( -1, HB_IT_ANY ) );

   switch( Msg->message )
   {
      case WM_KEYDOWN:
      case WM_SYSKEYDOWN:
         hWnd = Msg->hwnd;
         pSelf = _OOHG_GetExistingObject( hWnd, TRUE, FALSE );
         if( pSelf )
         {
            _OOHG_Send( pSelf, s_LookForKey );
            hb_vmPushNumInt( Msg->wParam );
            hb_vmPushInteger( GetKeyFlagState() );
            hb_vmSend( 2 );
            if( hb_parl( -1 ) )
            {
               break;
            }
         }
         /* FALLTHRU */

      default:
         if( _MDI_Count )
         {
            int iPos;
            int bLoop = 1;
            HWND hWnd;
            hWnd = Msg->hwnd;
            while( bLoop )
            {
               iPos = _MDI_Count;
               while( iPos )
               {
                  iPos--;
                  if( _MDI_Items[ iPos ][ 0 ] == hWnd || _MDI_Items[ iPos ][ 1 ] == hWnd )
                  {
                     bLoop = 0;
                     bCheck = ! TranslateMDISysAccel( _MDI_Items[ iPos ][ 0 ], Msg ) && ! TranslateAccelerator( _MDI_Items[ iPos ][ 1 ], NULL, Msg );
                     iPos = 0;
                  }
               }
               if( bLoop )
               {
                  hWnd = GetParent( hWnd );
                  if( ! hWnd )
                  {
                     bLoop = 0;
                  }
               }
            }
         }
         if( bCheck && ( ! IsWindow( GetActiveWindow() ) || ! IsDialogMessage( GetActiveWindow(), Msg ) ) )
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

HB_FUNC( _OOHG_DOMESSAGELOOP )
{
   MSG Msg;
   int iSwitch;

   if( HB_ISARRAY( 1 ) && hb_parinfa( 1, 0 ) >= 2 )
   {
      HB_STORPTR( ( void * ) &iSwitch , 1, 2 );     // ::ActivateCount[2]
   }

   iSwitch = 1;
   while( iSwitch )
   {
      if( GetMessage( &Msg, NULL, 0, 0 ) )
      {
         _OOHG_ProcessMessage( &Msg );
      }
      else
      {
         iSwitch = 0;
      }
   }
}

HB_FUNC( _MESSAGELOOPEND )
{
   int *pSwitch;
   pSwitch = (int *) hb_parptr( 1 );              // ::ActivateCount[2]

   if( pSwitch )
   {
      *pSwitch = 0;
   }
}

HB_FUNC( _PROCESSMESS )
{
   MSG Msg;

   if( PeekMessage( ( LPMSG ) &Msg, 0, 0, 0, PM_REMOVE ) )
   {
      _OOHG_ProcessMessage( &Msg );
      hb_retl( 1 );
   }
   else
   {
      hb_retl( 0 );
   }
}

HB_FUNC( SHOWWINDOW )
{
   ShowWindow( HWNDparam( 1 ), SW_SHOW );
}

HB_FUNC( _EXITPROCESS )
{
   ExitProcess( ( UINT ) hb_parni( 1 ) );
}

HB_FUNC( _EXITPROCESS2 )
{

   /*  NOTE: This duplicated/useless OLE initialization/release is
    *  used to patch a strange system lock under Windows Vista.
    *  Please don't remove.
    */
   OleInitialize( NULL );
   OleUninitialize();
   OleUninitialize();
   ExitProcess( ( UINT ) hb_parni( 1 ) );
}

HB_FUNC( INITSTATUS )
{
   HWND hs;

   hs = CreateStatusWindow( WS_CHILD | WS_BORDER | WS_VISIBLE, "", HWNDparam( 1 ), ( UINT ) hb_parni( 3 ) );

   SendMessage( hs, SB_SIMPLE, TRUE, 0 );
   SendMessage( hs, SB_SETTEXT, 255, (LPARAM) (LPSTR) hb_parc( 2 ) );
   HWNDret( hs );
}

HB_FUNC( SETSTATUS )
{
   HWND hwnd = HWNDparam( 1 );

   SendMessage( hwnd, SB_SIMPLE, TRUE, 0 );
   SendMessage( hwnd, SB_SETTEXT, 255, (LPARAM) (LPSTR) hb_parc( 2 ) );
}

HB_FUNC( MAXIMIZE )
{
   ShowWindow( HWNDparam( 1 ), SW_MAXIMIZE );
}

HB_FUNC( MINIMIZE )
{
   ShowWindow( HWNDparam( 1 ), SW_MINIMIZE );
}

HB_FUNC( RESTORE )
{
   ShowWindow( HWNDparam( 1 ), SW_RESTORE );
}

HB_FUNC( GETACTIVEWINDOW )
{
   HWNDret( GetActiveWindow() );
}

HB_FUNC( SETACTIVEWINDOW )
{
   SetActiveWindow( HWNDparam( 1 ) );
}

HB_FUNC( POSTQUITMESSAGE )
{
   PostQuitMessage( hb_parni( 1 ) );
}

HB_FUNC( DESTROYWINDOW )
{
   DestroyWindow( HWNDparam( 1 ) );
}

HB_FUNC( ISWINDOWENABLED )
{
   hb_retl( IsWindowEnabled( HWNDparam( 1 ) ) );
}

HB_FUNC( ENABLEWINDOW )
{
   EnableWindow( HWNDparam( 1 ), TRUE );
}

HB_FUNC( DISABLEWINDOW )
{
   EnableWindow( HWNDparam( 1 ), FALSE );
}

HB_FUNC( SETFOREGROUNDWINDOW )
{
   SetForegroundWindow( HWNDparam( 1 ) );
}

HB_FUNC( BRINGWINDOWTOTOP )
{
   BringWindowToTop( HWNDparam( 1 ) );
}

HB_FUNC( GETFOREGROUNDWINDOW )
{
   HWNDret( GetForegroundWindow() );
}

HB_FUNC( GETNEXTWINDOW )
{
   HWNDret( GetWindow( HWNDparam( 1 ), GW_HWNDNEXT ) );
}

HB_FUNC( GETPREVWINDOW )
{
   HWNDret( GetWindow( HWNDparam( 1 ), GW_HWNDPREV ) );
}

HB_FUNC( SETWINDOWTEXT )
{
   SetWindowText( HWNDparam( 1 ), ( LPCTSTR ) hb_parc( 2 ) );
}

HB_FUNC( C_CENTER )
{
   RECT rect;
   HWND hwnd;
   int w, h, x, y;
   hwnd = HWNDparam( 1 );
   GetWindowRect( hwnd, &rect );
   w = rect.right  - rect.left + 1;
   h = rect.bottom - rect.top  + 1;
   x = GetSystemMetrics( SM_CXSCREEN );
   y = GetSystemMetrics( SM_CYSCREEN );
   SetWindowPos( hwnd, HWND_TOP, ( x - w ) / 2, ( y - h ) / 2, 0, 0, SWP_NOSIZE | SWP_NOACTIVATE );
}

HB_FUNC( GETWINDOWTEXT )
{
   int iLen = GetWindowTextLength( HWNDparam( 1 ) ) + 1;
   char *cText = (char *) hb_xgrab( ( HB_SIZE ) iLen );

   GetWindowText( HWNDparam( 1 ), (LPTSTR) cText, iLen );

   hb_retc( cText );
   hb_xfree( cText );
}

HB_FUNC( SENDMESSAGE )
{
    HB_RETNL( (LONG_PTR) SendMessage( HWNDparam( 1 ), (UINT) hb_parni( 2 ), (WPARAM) HB_PARNL( 3 ), (LPARAM) HB_PARNL( 4 ) ) );
}

HB_FUNC( UPDATEWINDOW )
{
   hb_retl( UpdateWindow( HWNDparam( 1 ) ) );
}

HB_FUNC( GETNOTIFYCODE )
{
   hb_retni( ( INT ) ( (NMHDR FAR *) HB_PARNL( 1 ) )->code );
}

HB_FUNC( GETHWNDFROM )
{
   HWNDret( ( (NMHDR FAR *) HB_PARNL( 1 ) )->hwndFrom );
}

HB_FUNC( GETDRAWITEMHANDLE )
{
   HWNDret( ( (DRAWITEMSTRUCT FAR *) HB_PARNL( 1 ) )->hwndItem );
}

HB_FUNC( GETFOCUS )
{
   HWNDret( GetFocus() );
}

HB_FUNC( MOVEWINDOW )
{
   hb_retl( MoveWindow( HWNDparam( 1 ), hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), ( HB_ISNIL( 6 ) ? TRUE : hb_parl( 6 ) ) ) );
}

HB_FUNC( GETWINDOWRECT )
{
   RECT rect;
   hb_retl( GetWindowRect( HWNDparam( 1 ), &rect ) );
   HB_STORNL3( rect.left, 2, 1 );
   HB_STORNL3( rect.top, 2, 2 );
   HB_STORNL3( rect.right, 2, 3 );
   HB_STORNL3( rect.bottom, 2, 4 );
}

HB_FUNC( GETCLIENTRECT )
{
   RECT rect;
   hb_retl( GetClientRect( HWNDparam( 1 ), &rect ) );
   HB_STORNL3( rect.left, 2, 1 );
   HB_STORNL3( rect.top, 2, 2 );
   HB_STORNL3( rect.right, 2, 3 );
   HB_STORNL3( rect.bottom, 2, 4 );
}

HB_FUNC( SETWINDOWBACKCOLOR )
{
   HWND hWnd = HWNDparam( 1 );
   HBRUSH hBrush, color;

   if( hb_param( 2, HB_IT_ARRAY ) == 0 || HB_PARNI( 3, 1 ) == -1 )
   {
      hBrush = 0;
      color = (HBRUSH)( COLOR_BTNFACE + 1 );
   }
   else
   {
      hBrush = CreateSolidBrush( RGB( HB_PARNI( 2, 1 ), HB_PARNI( 2, 2 ), HB_PARNI( 2, 3 ) ) );
      color = hBrush;
   }

   SetClassLongPtr( hWnd, GCL_HBRBACKGROUND, (LONG_PTR) color );

   RedrawWindow( hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );

   HB_RETNL( (LONG_PTR) hBrush );
}

HB_FUNC( GETDESKTOPWIDTH )
{
   hb_retni( GetSystemMetrics( SM_CXSCREEN ) );
}

HB_FUNC( GETDESKTOPHEIGHT )
{
   hb_retni( GetSystemMetrics( SM_CYSCREEN ) );
}

HB_FUNC( GETDESKTOPREALHEIGHT )
//  Returns the height of the free part of the desktop
{
   RECT rect;
   int h;

   SystemParametersInfo( SPI_GETWORKAREA, 1, &rect, 0 );
   h = rect.bottom - rect.top;

   hb_retni( h );
}

HB_FUNC( GETDESKTOPREALWIDTH )
//  Returns the width of the free part of the desktop
{
   RECT rect;
   int w;

   SystemParametersInfo( SPI_GETWORKAREA, 1, &rect, 0 );
   w = rect.right - rect.left;

   hb_retni( w );
}

HB_FUNC( GETDESKTOPREALTOP )
{
   RECT rect;
   SystemParametersInfo ( SPI_GETWORKAREA, 0, &rect, 0 );
   hb_retni( rect.top );
}

HB_FUNC( GETDESKTOPREALLEFT )
{
   RECT rect;
   SystemParametersInfo ( SPI_GETWORKAREA, 0, &rect, 0 );
   hb_retni( rect.left );
}

HB_FUNC( GETWINDOWROW )
{
   RECT rect;
   hb_xmemset( &rect, 0, sizeof( rect ) );
   GetWindowRect( HWNDparam( 1 ), &rect );
   hb_retni( rect.top );
}

HB_FUNC( GETWINDOWCOL )
{
   RECT rect;
   hb_xmemset( &rect, 0, sizeof( rect ) );
   GetWindowRect( HWNDparam( 1 ), &rect );
   hb_retni( rect.left );
}

HB_FUNC( GETWINDOWWIDTH )
{
   RECT rect;
   hb_xmemset( &rect, 0, sizeof( rect ) );
   GetWindowRect( HWNDparam( 1 ), &rect );
   hb_retni( rect.right - rect.left );
}

HB_FUNC( GETWINDOWHEIGHT )
{
   RECT rect;
   hb_xmemset( &rect, 0, sizeof( rect ) );
   GetWindowRect( HWNDparam( 1 ), &rect );
   hb_retni( rect.bottom - rect.top );
}

HB_FUNC( GETTITLEHEIGHT )
{
   hb_retni( GetSystemMetrics( SM_CYCAPTION ) );
}

HB_FUNC( GETEDGEHEIGHT )
{
   hb_retni( GetSystemMetrics(  SM_CYEDGE ) );
}

HB_FUNC( GETBORDERHEIGHT )
{
   hb_retni( GetSystemMetrics(  SM_CYSIZEFRAME ) );
}

HB_FUNC( GETBORDERWIDTH )
{
   hb_retni( GetSystemMetrics( SM_CXSIZEFRAME ) );
}

HB_FUNC( ISWINDOWVISIBLE )
{
   hb_retl( IsWindowVisible( HWNDparam( 1 ) ) );
}

HB_FUNC( ISWINDOWMAXIMIZED )
{
   hb_retl( IsZoomed( HWNDparam( 1 ) ) );
  }

HB_FUNC( ISWINDOWMINIMIZED )
{
   hb_retl( IsIconic( HWNDparam( 1 ) ) );
}

HB_FUNC( GETINSTANCE )
{
   HWNDret( GetModuleHandle( NULL ) );
}

HB_FUNC( GETCURSORPOS )
{
   POINT pt;

   GetCursorPos( &pt );

   hb_reta( 2 );

   HB_STORNI( pt.y, -1, 1 );
   HB_STORNI( pt.x, -1, 2 );
}

HB_FUNC( GETITEMPOS )
{
   hb_retnl( ( LONG ) ( ( ( NMMOUSE FAR * ) HB_PARNL( 1 ) )->dwItemSpec ) );
}

HB_FUNC( GETWINDOWSTATE )
{
   WINDOWPLACEMENT wp;

   wp.length = sizeof( WINDOWPLACEMENT );

   GetWindowPlacement( HWNDparam( 1 ) , &wp );

   hb_retni( ( INT ) wp.showCmd );
}

HB_FUNC( REDRAWWINDOW )
{
   RedrawWindow( HWNDparam( 1 ), NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
}

HB_FUNC( REDRAWWINDOWCONTROLRECT )
{
   RECT r;

   r.top   = hb_parni( 2 );
   r.left  = hb_parni( 3 );
   r.bottom= hb_parni( 4 );
   r.right = hb_parni( 5 );

   RedrawWindow( HWNDparam( 1 ), &r, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
}

HB_FUNC( C_SETWINDOWRGN )
{
   HRGN hrgn;

   if( hb_parni( 6 ) == 0 )
   {
      SetWindowRgn( GetActiveWindow(), NULL, TRUE );
   }
   else
   {
      if( hb_parni( 6 ) == 1 )
      {
         hrgn = CreateRectRgn( hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ) );
      }
      else
      {
         hrgn = CreateEllipticRgn( hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ) );
      }
      SetWindowRgn( GetActiveWindow(), hrgn, TRUE );
      // Should be HWNDparam( 1 ) instead of GetActiveWindow()
   }
}

HB_FUNC( C_SETPOLYWINDOWRGN )
{
   HRGN hrgn;
   POINT lppt[512];
   int i, fnPolyFillMode;
   int cPoints = ( INT ) hb_parinfa( 2, 0 );

   if( hb_parni( 4 ) == 1 )
      fnPolyFillMode = WINDING;
   else
      fnPolyFillMode = ALTERNATE;

   for( i = 0; i <= cPoints - 1; i++ )
   {
      lppt[i].x = HB_PARNI( 2, i + 1 );
      lppt[i].y = HB_PARNI( 3, i + 1 );
   }
   hrgn = CreatePolygonRgn( lppt, cPoints, fnPolyFillMode );
   SetWindowRgn( GetActiveWindow(), hrgn, TRUE );
}

HB_FUNC( GETHELPDATA )
{
   HB_RETNL( (LONG_PTR) ( ( (HELPINFO FAR *) HB_PARNL( 1 ) )->hItemHandle ) );
}

HB_FUNC( GETMSKTEXTMESSAGE )
{
   HB_RETNL( (LONG_PTR) ( ( (MSGFILTER FAR *) HB_PARNL( 1 ) )->msg ) );
}

HB_FUNC( GETMSKTEXTWPARAM )
{
   HB_RETNL( (LONG_PTR) ( ( (MSGFILTER FAR *) HB_PARNL( 1 ) )->wParam) );
}

HB_FUNC( GETMSKTEXTLPARAM )
{
   HB_RETNL( (LONG_PTR) ( ( (MSGFILTER FAR *) HB_PARNL( 1 ) )->lParam) );
}

HB_FUNC( GETWINDOW )
{
   HWNDret( GetWindow( HWNDparam( 1 ), (UINT) hb_parni( 2 ) ) );
}

HB_FUNC( GETESCAPESTATE )
{
   hb_retni( GetKeyState( VK_ESCAPE ) );
}

HB_FUNC( GETCONTROLSTATE )
{
   hb_retni( GetKeyState( VK_CONTROL ) );
}

HB_FUNC( GETALTSTATE )
{
   hb_retni( GetKeyState( VK_MENU ) );
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
   HWNDret( FindWindowEx( HWNDparam( 1 ), HWNDparam( 2 ), (LPCSTR) hb_parc( 3 ), (LPCSTR) hb_parc( 4 ) ) );
}

WORD DIBNumColors( LPSTR );
WORD PaletteSize( LPSTR );
WORD SaveDIB( HDIB, LPSTR );
HANDLE DDBToDIB( HBITMAP, HPALETTE );

#ifndef DWMWA_EXTENDED_FRAME_BOUNDS
   #define DWMWA_EXTENDED_FRAME_BOUNDS 9
#endif

#ifndef DWMGETWINDOWATTRIBUTE
   typedef HRESULT ( WINAPI * DWMGETWINDOWATTRIBUTE ) ( HWND, DWORD, PVOID, DWORD );
#endif

#ifndef DWMISCOMPOSITIONENABLED
   typedef HRESULT ( WINAPI * DWMISCOMPOSITIONENABLED ) ( BOOL * );
#endif

void getwinver( OSVERSIONINFO * pOSvi )
{
   pOSvi->dwOSVersionInfoSize = sizeof( OSVERSIONINFO );
   GetVersionEx( pOSvi );
}

HB_FUNC( _GETBITMAP )                   // hWnd, bAll
{
   HWND hWnd = HWNDparam( 1 );
   BOOL bAll = hb_parl( 2 );
   HDC hDC, hMemDC;
   RECT rct;
   HBITMAP hBitmap, hOldBmp;
   int iTop, iLeft;
   OSVERSIONINFO osvi;
   HMODULE Library;
   DWMGETWINDOWATTRIBUTE DwmGetWindowAttribute;
   HRESULT Ret;
   BOOL isEnabled;
   DWMISCOMPOSITIONENABLED DwmIsCompositionEnabled;

   if( bAll )
   {
      hDC = GetDC( HWND_DESKTOP );

      if( ( Library = LoadLibrary( "dwmapi.dll") ) == NULL )
      {
         GetWindowRect( hWnd, &rct );
      }
      else
      {
         if( ( DwmIsCompositionEnabled = (DWMISCOMPOSITIONENABLED) GetProcAddress( Library, "DwmIsCompositionEnabled" ) ) == NULL )
         {
            GetWindowRect( hWnd, &rct );
         }
         else
         {
            Ret = ( DwmIsCompositionEnabled )( &isEnabled);

            if( ( Ret == S_OK ) && isEnabled )
            {
               if( ( DwmGetWindowAttribute = (DWMGETWINDOWATTRIBUTE) GetProcAddress( Library, "DwmGetWindowAttribute" ) ) == NULL )
               {
                  GetWindowRect( hWnd, &rct );
               }
               else
               {
                  getwinver( &osvi );

                  if( osvi.dwMajorVersion < 6 )
                  {
                     GetWindowRect( hWnd, &rct );
                  }
                  else
                  {
                     Ret = ( DwmGetWindowAttribute )( hWnd, DWMWA_EXTENDED_FRAME_BOUNDS, &rct, sizeof( RECT ) );

                     if( Ret != S_OK )
                     {
                        GetWindowRect( hWnd, &rct );
                     }
                  }
               }
            }
            else
            {
               GetWindowRect( hWnd, &rct );
            }
         }

         FreeLibrary( Library );
      }

      iTop = rct.top;
      iLeft = rct.left;

   }
   else
   {
      hDC = GetDC( hWnd );
      GetClientRect( hWnd, &rct );
      iTop = 0;
      iLeft = 0;
   }

   hMemDC = CreateCompatibleDC( hDC );
   hBitmap = CreateCompatibleBitmap( hDC, rct.right - rct.left, rct.bottom - rct.top );

   hOldBmp = (HBITMAP) SelectObject( hMemDC, hBitmap );
   BitBlt( hMemDC, 0, 0, rct.right - rct.left, rct.bottom - rct.top, hDC, iLeft, iTop, SRCCOPY );
   SelectObject( hMemDC, hOldBmp );

   DeleteDC( hMemDC );
   if( bAll )
   {
      ReleaseDC( HWND_DESKTOP, hDC );
   }
   else
   {
      ReleaseDC( hWnd, hDC );
   }
   HB_RETNL( ( LONG_PTR ) hBitmap );
}

HB_FUNC( _SAVEBITMAP )                   // hBitmap, cFile
{
   HANDLE hDIB;

   hDIB = DDBToDIB( (HBITMAP) HWNDparam( 1 ), NULL );
   SaveDIB( hDIB, (LPSTR) hb_parc( 2 ) );
   GlobalFree( hDIB );
}

HB_FUNC( WNDCOPY )  //  hWnd, bAll, cFile        Copies any Window to the Clipboard!
{
   HWND hWnd = HWNDparam( 1 );
   BOOL bAll = hb_parl( 2 );
   HDC hDC, hMemDC;
   RECT rct;
   HBITMAP hBitmap, hOldBmp;
   HPALETTE hPal = NULL;
   LPSTR myFile = (char *) hb_parc( 3 );
   HANDLE hDIB;
   int iTop, iLeft;

   if( bAll )
   {
      hDC = GetDC( HWND_DESKTOP );
      GetWindowRect( hWnd, &rct );
      iTop = rct.top;
      iLeft = rct.left;
   }
   else
   {
      hDC = GetDC( hWnd );
      GetClientRect( hWnd, &rct );
      iTop = 0;
      iLeft = 0;
   }

   hMemDC = CreateCompatibleDC( hDC );
   hBitmap = CreateCompatibleBitmap( hDC, rct.right - rct.left, rct.bottom - rct.top );

   hOldBmp = (HBITMAP) SelectObject( hMemDC, hBitmap );
   BitBlt( hMemDC, 0, 0, rct.right - rct.left, rct.bottom - rct.top, hDC, iTop, iLeft, SRCCOPY );
   SelectObject( hMemDC, hOldBmp );

   hDIB = DDBToDIB( hBitmap, hPal );
   SaveDIB( hDIB, myFile );

   DeleteDC( hMemDC );
   GlobalFree( hDIB );
   if( bAll )
   {
      ReleaseDC( HWND_DESKTOP, hDC );
   }
   else
   {
      ReleaseDC( hWnd, hDC );
   }
}

WORD PaletteSize( LPSTR lpDIB )
{
   // calculate the size required by the palette
   if( IS_WIN30_DIB( lpDIB ) )
      return (WORD) ( DIBNumColors( lpDIB ) * sizeof( RGBQUAD ) );
   else
      return (WORD) ( DIBNumColors( lpDIB ) * sizeof( RGBTRIPLE ) );
}

WORD DIBNumColors( LPSTR lpDIB )
{
   WORD wBitCount;  // DIB bit count

   // If this is a Windows-style DIB, the number of colors in the
   // color table can be less than the number of bits per pixel
   // allows for (i.e. lpbi->biClrUsed can be set to some value).
   // If this is the case, return the appropriate value.

   if( IS_WIN30_DIB( lpDIB ) )
   {
      DWORD dwClrUsed;

      dwClrUsed = ( (LPBITMAPINFOHEADER) lpDIB )->biClrUsed;
      if( dwClrUsed )
         return (WORD) dwClrUsed;
   }

   // Calculate the number of colors in the color table based on
   // the number of bits per pixel for the DIB.

   if( IS_WIN30_DIB( lpDIB ) )
      wBitCount = ( (LPBITMAPINFOHEADER) lpDIB )->biBitCount;
   else
      wBitCount = ( (LPBITMAPCOREHEADER) lpDIB )->bcBitCount;

   // return number of colors based on bits per pixel

   switch( wBitCount )
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

HANDLE DDBToDIB( HBITMAP hBitmap, HPALETTE hPal )
{
   BITMAP bm;                     // bitmap structure
   BITMAPINFOHEADER bi;           // bitmap header
   LPBITMAPINFOHEADER lpbi;       // pointer to BITMAPINFOHEADER
   DWORD dwLen;                   // size of memory block
   HANDLE hDIB, h;                // handle to DIB, temp handle
   HDC hDC;                       // handle to DC
   WORD biBits;                   // bits per pixel

   // check if bitmap handle is valid
   if( ! hBitmap )
      return NULL;

   // fill in BITMAP structure, return NULL if it didn't work
   if( ! GetObject( hBitmap, sizeof( bm ), (LPSTR) &bm ) )
      return NULL;

   // if no palette is specified, use default palette
   if( hPal == NULL )
   {
      hPal = (HPALETTE) GetStockObject( DEFAULT_PALETTE );
   }

   // calculate bits per pixel
   biBits = (WORD) ( bm.bmPlanes * bm.bmBitsPixel );

   // make sure bits per pixel is valid
   if( biBits <= 1 )
      biBits = 1;
   else if( biBits <= 4 )
      biBits = 4;
   else if( biBits <= 8 )
      biBits = 8;
   else // if greater than 8-bit, force to 24-bit
      biBits = 24;

   // initialize BITMAPINFOHEADER
   bi.biSize = sizeof( BITMAPINFOHEADER );
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
   dwLen = bi.biSize + PaletteSize( (LPSTR) &bi );

   // get a DC
   hDC = GetDC( NULL );

   // select and realize our palette
   hPal = SelectPalette( hDC, hPal, FALSE );
   RealizePalette( hDC );

   // alloc memory block to store our bitmap
   hDIB = GlobalAlloc( GHND, dwLen );

   // if we couldn't get memory block
   if( ! hDIB )
   {
      // clean up and return NULL
      SelectPalette( hDC, hPal, TRUE );
      RealizePalette( hDC );
      ReleaseDC( NULL, hDC );
      return NULL;
   }

   // lock memory and get pointer to it
   lpbi = (LPBITMAPINFOHEADER) GlobalLock( hDIB );

   /// use our bitmap info to fill BITMAPINFOHEADER
   *lpbi = bi;

   // call GetDIBits with a NULL lpBits param, so it will calculate the biSizeImage field for us
   GetDIBits( hDC, hBitmap, 0, (UINT) bi.biHeight, NULL, (LPBITMAPINFO) lpbi, DIB_RGB_COLORS );

   // get the info. returned by GetDIBits and unlock memory block
   bi = *lpbi;
   GlobalUnlock( hDIB );

   // if the driver did not fill in the biSizeImage field, make one up
   if( bi.biSizeImage == 0 )
      bi.biSizeImage = ( DWORD ) ( ( ( ( bm.bmWidth * biBits ) + 31 ) / 32 * 4 ) * bm.bmHeight );

   // realloc the buffer big enough to hold all the bits
   dwLen = bi.biSize + PaletteSize( (LPSTR) &bi ) + bi.biSizeImage;

   h = GlobalReAlloc( hDIB, dwLen, 0 );
   if( h )
   {
      hDIB = h;
   }
   else
   {
      // clean up and return NULL
      GlobalFree( hDIB );
      SelectPalette( hDC, hPal, TRUE );
      RealizePalette( hDC );
      ReleaseDC( NULL, hDC );
      return NULL;
   }

   // lock memory block and get pointer to it */
   lpbi = (LPBITMAPINFOHEADER) GlobalLock( hDIB );

   // call GetDIBits with a NON-NULL lpBits param, and actualy get the bits this time
   if( GetDIBits( hDC, hBitmap, 0, (UINT) bi.biHeight, (LPSTR) lpbi + (WORD) lpbi->biSize + PaletteSize( (LPSTR) lpbi ), (LPBITMAPINFO) lpbi, DIB_RGB_COLORS ) == 0 )
   {
      // clean up and return NULL
      GlobalFree( hDIB );
      SelectPalette( hDC, hPal, TRUE );
      RealizePalette( hDC );
      ReleaseDC( NULL, hDC );
      return NULL;
   }

   bi = *lpbi;

   // clean up
   GlobalUnlock( hDIB );
   SelectPalette( hDC, hPal, TRUE );
   RealizePalette( hDC );
   ReleaseDC( NULL, hDC );

   // return handle to the DIB
   return hDIB;
}

WORD SaveDIB( HDIB hDib, LPSTR lpFileName )
{
   BITMAPFILEHEADER bmfHdr;       // Header for Bitmap file
   LPBITMAPINFOHEADER lpBI;       // Pointer to DIB info structure
   HANDLE fh;                     // file handle for opened file
   DWORD dwDIBSize, dwWritten, dwBmBitsSize;

   fh = CreateFile( lpFileName, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN, NULL );

   // Get a pointer to the DIB memory, the first of which contains
   // a BITMAPINFO structure

   lpBI = (LPBITMAPINFOHEADER) GlobalLock( hDib );
   if( ! lpBI )
   {
      CloseHandle( fh );
      return 1;
   }

   if( lpBI->biSize != sizeof( BITMAPINFOHEADER ) )
   {
      GlobalUnlock( hDib );
      CloseHandle( fh );
      return 1;
   }

   bmfHdr.bfType = ( (WORD) ( 'M' << 8 ) | 'B' ); // is always "BM"

   dwDIBSize = ( * (LPDWORD) lpBI ) + PaletteSize( (LPSTR) lpBI );

   dwBmBitsSize = ( DWORD ) ( ( ( ( lpBI->biWidth * lpBI->biBitCount ) + 31 ) / 32 * 4 ) * lpBI->biHeight );
   dwDIBSize += dwBmBitsSize;
   lpBI->biSizeImage = dwBmBitsSize;

   bmfHdr.bfSize = dwDIBSize + sizeof( BITMAPFILEHEADER );
   bmfHdr.bfReserved1 = 0;
   bmfHdr.bfReserved2 = 0;

   // Now, calculate the offset the actual bitmap bits will be in
   // the file -- It's the Bitmap file header plus the DIB header,
   // plus the size of the color table.
   bmfHdr.bfOffBits = (DWORD) sizeof( BITMAPFILEHEADER ) + lpBI->biSize + PaletteSize( (LPSTR) lpBI );

   // Write the file header
   WriteFile( fh, (LPSTR) &bmfHdr, sizeof( BITMAPFILEHEADER ), &dwWritten, NULL );

   // Write the DIB header and the bits -- use local version of
   // MyWrite, so we can write more than 32767 bytes of data
   WriteFile( fh, (LPSTR) lpBI, dwDIBSize, &dwWritten, NULL );

   GlobalUnlock( hDib );
   CloseHandle( fh );

   if( dwWritten == 0 )
       return 1; // oops, something happened in the write
   else
       return 0; // Success code
}

HB_FUNC( _UPDATERTL )
{
   HWND hwnd;
   LONG_PTR myret;

   hwnd = HWNDparam( 1 );
   myret = GetWindowLongPtr( hwnd, GWL_EXSTYLE );
   if( hb_parl( 2 ) )
   {
      myret = myret |  WS_EX_LTRREADING |  WS_EX_LEFT |  WS_EX_LEFTSCROLLBAR;
//    myret = myret                    &~ WS_EX_LTRREADING &~ WS_EX_LEFT;
//    myret = myret |  WS_EX_LAYOUTRTL |  WS_EX_RTLREADING |  WS_EX_RIGHT;
   }
   else
   {
      myret = myret &~ WS_EX_LTRREADING &~ WS_EX_LEFT &~ WS_EX_LEFTSCROLLBAR;
//    myret = myret                    |  WS_EX_LTRREADING |  WS_EX_LEFT;
//    myret = myret &~ WS_EX_LAYOUTRTL &~ WS_EX_RTLREADING &~ WS_EX_RIGHT;
   }
   SetWindowLongPtr( hwnd, GWL_EXSTYLE, myret );

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
         dwStyle = WS_EX_RIGHTSCROLLBAR | WS_EX_RTLREADING;
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

HB_FUNC( GETWINDOWEXSTYLE )
{
   HB_RETNL( GetWindowLongPtr( HWNDparam( 1 ), GWL_EXSTYLE ) );
}

HB_FUNC( GETWINDOWSTYLE )
{
   HB_RETNL( GetWindowLongPtr( HWNDparam( 1 ), GWL_STYLE ) );
}

HB_FUNC( SETWINDOWEXSTYLE )
{
   HB_RETNL( SetWindowLongPtr( HWNDparam( 1 ), GWL_EXSTYLE, HB_PARNL( 2 ) ) );
}

HB_FUNC( SETWINDOWSTYLE )
{
   HB_RETNL( SetWindowLongPtr( HWNDparam( 1 ), GWL_STYLE, HB_PARNL( 2 ) ) );
}

HB_FUNC( ISWINDOWSTYLE )
{
   LONG_PTR ulRequest = HB_PARNL( 2 );

   hb_retl( ( GetWindowLongPtr( HWNDparam( 1 ), GWL_STYLE ) & ulRequest ) == ulRequest );
}

HB_FUNC( ISWINDOWEXSTYLE )
{
   LONG_PTR ulRequest = HB_PARNL( 2 );

   hb_retl( ( GetWindowLongPtr( HWNDparam( 1 ), GWL_EXSTYLE ) & ulRequest ) == ulRequest );
}

HB_FUNC( WINDOWSTYLEFLAG )
{
   HWND hWnd;
   LONG_PTR lMask;

   hWnd = HWNDparam( 1 );
   lMask = HB_PARNL( 2 );
   if( HB_ISNUM( 3 ) )
   {
      SetWindowLongPtr( hWnd, GWL_STYLE, ( ( GetWindowLongPtr( hWnd, GWL_STYLE ) & ( ~ lMask ) ) | ( HB_PARNL( 3 ) & lMask ) ) );
      RedrawWindow( hWnd, 0, 0, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
   }

   HB_RETNL( GetWindowLongPtr( HWNDparam( 1 ), GWL_STYLE ) & HB_PARNL( 2 ) );
}

HB_FUNC( WINDOWEXSTYLEFLAG )
{
   HWND hWnd;
   LONG_PTR lMask;

   hWnd = HWNDparam( 1 );
   lMask = HB_PARNL( 2 );
   if( HB_ISNUM( 3 ) )
   {
      SetWindowLongPtr( hWnd, GWL_EXSTYLE, ( ( GetWindowLongPtr( hWnd, GWL_EXSTYLE ) & ( ~ lMask ) ) | ( HB_PARNL( 3 ) & lMask ) ) );
      RedrawWindow( hWnd, 0, 0, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
   }

   HB_RETNL( GetWindowLongPtr( HWNDparam( 1 ), GWL_EXSTYLE ) & HB_PARNL( 2 ) );
}

HB_FUNC( ANIMATEWINDOW )                // hWnd, nTime, nFlags, lHide
{
#ifdef __MINGW32__
   ShowWindow( HWNDparam( 1 ), ( hb_parl( 4 ) ? SW_HIDE : SW_SHOW ) );
#else
   int iType;

   iType = ( hb_parl( 4 ) ? AW_HIDE : AW_ACTIVATE ) | hb_parl( 3 );

   AnimateWindow( HWNDparam( 1 ), hb_parni( 2 ), iType );
#endif
}

HB_FUNC( SHOWWINDOWNA )
{
   ShowWindow( HWNDparam( 1 ), SW_SHOWNA );
}

HB_FUNC( OSISWINXPORLATER )
{
   OSVERSIONINFO osvi;
   getwinver( &osvi );
   hb_retl( osvi.dwMajorVersion > 5 || ( osvi.dwMajorVersion == 5 && osvi.dwMinorVersion >= 1 ) );
}

HB_FUNC( OSISWINVISTAORLATER )
{
   OSVERSIONINFO osvi;
   getwinver( &osvi );
   hb_retl( osvi.dwMajorVersion >= 6 );
}

HBRUSH GetTabBrush( HWND hWnd )
{
   HBRUSH hBrush;
   RECT rc;
   HDC hDC;
   HDC hDCMem;
   HBITMAP hBmp;
   HBITMAP hOldBmp;

   GetWindowRect( hWnd, &rc );
   hDC = GetDC( hWnd );
   hDCMem = CreateCompatibleDC( hDC );

   hBmp = CreateCompatibleBitmap( hDC, rc.right - rc.left, rc.bottom - rc.top );

   hOldBmp = (HBITMAP) SelectObject( hDCMem, hBmp );

   SendMessage( hWnd, WM_PRINT, (WPARAM) hDCMem, (LPARAM) ( PRF_ERASEBKGND | PRF_CLIENT | PRF_NONCLIENT ) );

   hBrush = CreatePatternBrush( hBmp );

   SelectObject( hDCMem, hOldBmp );

   DeleteObject( hBmp );
   DeleteDC( hDCMem );
   ReleaseDC( hWnd, hDC );

   return hBrush;
}

HB_FUNC( SETLAYEREDWINDOWATTRIBUTES )   // hWnd, color, opacity, flag (LWA_COLORKEY or LWA_ALPHA)
{
   HWND hWnd = HWNDparam( 1 );
   COLORREF crKey = (COLORREF) hb_parnl( 2 );
   BYTE bAlpha = (BYTE) hb_parni( 3 );
   DWORD dwFlags = (DWORD) hb_parnl( 4 );

#if defined ( __MINGW32__ ) && ! defined ( __MINGW32_VERSION )
   if( ! ( GetWindowLongPtr( hWnd, GWL_EXSTYLE ) & WS_EX_LAYERED ) )
   {
      SetWindowLongPtr( hWnd, GWL_EXSTYLE, ( GetWindowLongPtr( hWnd, GWL_EXSTYLE ) | WS_EX_LAYERED ) );
   }

   hb_retl( SetLayeredWindowAttributes( hWnd, crKey, bAlpha, dwFlags ) );
#else
   typedef BOOL (__stdcall * PFN_SETLAYEREDWINDOWATTRIBUTES)( HWND, COLORREF, BYTE, DWORD );
   PFN_SETLAYEREDWINDOWATTRIBUTES pfnSetLayeredWindowAttributes;
   BOOL bRet;

   HINSTANCE hLib = LoadLibrary( "user32.dll" );
   if( hLib == NULL )
   {
      hb_retl( FALSE );
   }

   pfnSetLayeredWindowAttributes = (PFN_SETLAYEREDWINDOWATTRIBUTES) GetProcAddress( hLib, "SetLayeredWindowAttributes" );
   if( pfnSetLayeredWindowAttributes == NULL )
   {
      hb_retl( FALSE );
   }

   SetWindowLongPtr( hWnd, GWL_EXSTYLE, GetWindowLongPtr( hWnd, GWL_EXSTYLE ) | WS_EX_LAYERED );
   bRet = ( pfnSetLayeredWindowAttributes )( hWnd, crKey, bAlpha, dwFlags );

   FreeLibrary( hLib );
   hb_retl( bRet );
#endif
}

HB_FUNC( FLASHWINDOWEX )   // hWnd, dwFlags, uCount, dwTimeout
{
   FLASHWINFO FlashWinInfo;

   FlashWinInfo.cbSize    = sizeof( FLASHWINFO );
   FlashWinInfo.hwnd      = HWNDparam( 1 );
   FlashWinInfo.dwFlags   = (DWORD) hb_parnl( 2 );
   FlashWinInfo.uCount    = (UINT) hb_parnl( 3 );
   FlashWinInfo.dwTimeout = (DWORD) hb_parnl( 4 );

   hb_retl( FlashWindowEx( &FlashWinInfo ) );
}

VOID ShowLastError( CHAR * caption )
{
   LPVOID lpMsgBuf;
   DWORD dwError = GetLastError();
   FormatMessage( FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM, NULL, dwError,
                  MAKELANGID( LANG_NEUTRAL, SUBLANG_DEFAULT ), ( LPTSTR ) &lpMsgBuf, 0, NULL );
   MessageBox( NULL, ( LPCSTR ) lpMsgBuf, caption, MB_OK | MB_ICONEXCLAMATION );
   LocalFree( lpMsgBuf );
}
