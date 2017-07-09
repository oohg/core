/*
 * $Id: h_notify.prg,v 1.1 2017-07-09 20:08:04 guerra000 Exp $
 */
/*
 * ooHG source code:
 * Notify icon control
 *
 * Copyright 2009-2017 Vicente Guerra <vicente@guerra.com.mx>
 * https://sourceforge.net/projects/oohg/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2016, http://www.harbour-project.org/
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
 * along with this software; see the file COPYING.  If not, write to
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


#include "oohg.ch"
#include "hbclass.ch"
#include "i_windefs.ch"

CLASS TNotifyIcon FROM TControl
   DATA Type               INIT "NOTIFYICON" READONLY
   DATA cPicture           INIT ""
   DATA hImage             INIT nil
   DATA lCreated           INIT .F.
   DATA nTrayId            INIT 0

   METHOD Define
   METHOD Release
   METHOD Picture          SETGET
   METHOD Buffer           SETGET
   METHOD HIcon            SETGET
   METHOD HBitMap          SETGET
   METHOD ToolTip          SETGET
   METHOD Events_TaskBar

   //
//   METHOD Enabled
//   METHOD Visible

   EMPTY( _OOHG_AllVars )
ENDCLASS

*------------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, cPicture, cToolTip, ProcedureName, invisible ) CLASS TNotifyIcon
*------------------------------------------------------------------------------*
LOCAL nTrayId
   ::SetForm( ControlName, ParentForm )
   ::InitStyle( ,, Invisible )
   ::Register( 0, ControlName )

   nTrayId := 1
   ::nTrayId := -1
   DO WHILE ASCAN( ::Parent:aNotifyIcons, { |o| o:nTrayId == nTrayId } ) > 0
      nTrayId++
   ENDDO
   ::nTrayId := nTrayId
   AADD( ::Parent:aNotifyIcons, Self )

   ::Picture := cPicture
   *If ! ValidHandler( ::hImage )
   *   ::Buffer := cBuffer
   *   If ! ValidHandler( ::hImage )
   *      ::HIcon := hIcon
   *   EndIf
   *EndIf

   ASSIGN ::ToolTip VALUE cToolTip      TYPE "C"
   ASSIGN ::OnClick VALUE ProcedureName TYPE "B"

Return Self

*------------------------------------------------------------------------------*
METHOD Release() CLASS TNotifyIcon
*------------------------------------------------------------------------------*
LOCAL nItem
   DeleteObject( ::hImage )
   IF ::lCreated
      RemoveNotifyIcon( ::Parent:hWnd, ::nTrayId )
   ENDIF
   nItem := ASCAN( ::Parent:aNotifyIcons, { |o| o:nTrayId == ::nTrayId } )
   IF nItem > 0
      _OOHG_DeleteArrayItem( ::Parent:aNotifyIcons, nItem )
   ENDIF
RETURN ::Super:Release()

*------------------------------------------------------------------------------*
METHOD Picture( cPicture ) CLASS TNotifyIcon
*------------------------------------------------------------------------------*
   IF VALTYPE( cPicture ) $ "CM"
      DeleteObject( ::hImage )
      ::cPicture := cPicture
      ::hImage := LoadTrayIcon( GETINSTANCE(), cPicture )
      // If ! ValidHandler( ::hImage )
      //    ::hImage := _OOHG_BitmapFromFile( Self, cPicture, 0, .F., .T. )
      //    If ! ValidHandler( ::hImage )
      //       *** Convert from BMP to ICO
      //    EndIf
      // EndIf
      If ValidHandler( ::hImage )
         SetNotifyIconData( ::Parent:hWnd, ::nTrayId, ::lCreated, ::hImage )
         ::lCreated := .T.   // This value can be set "any" time...
      EndIf
   EndIf
Return ::cPicture

*------------------------------------------------------------------------------*
METHOD Buffer( cBuffer ) CLASS TNotifyIcon
*------------------------------------------------------------------------------*
   If VALTYPE( cBuffer ) $ "CM"
      DeleteObject( ::hImage )
      ::cPicture := ""
      ::hImage := _OOHG_BitmapFromBuffer( Self, cBuffer, 0, .F., .T. )
      // If ! ValidHandler( ::hImage )
      //    *** Convert from BMP to ICO
      // EndIf
      If ValidHandler( ::hImage )
         SetNotifyIconData( ::Parent:hWnd, ::nTrayId, ::lCreated, ::hImage )
         ::lCreated := .T.   // This value can be set "any" time...
      EndIf
   EndIf
Return nil

*------------------------------------------------------------------------------*
METHOD HIcon( hIcon ) CLASS TNotifyIcon
*------------------------------------------------------------------------------*
   If ValType( hIcon ) $ "NP"
      DeleteObject( ::hImage )
      ::hImage := hIcon
      ::cPicture := ""
      // If ! ValidHandler( ::hImage )
      //    *** Convert from BMP to ICO
      // EndIf
      If ValidHandler( ::hImage )
         SetNotifyIconData( ::Parent:hWnd, ::nTrayId, ::lCreated, ::hImage )
         ::lCreated := .T.   // This value can be set "any" time...
      EndIf
   EndIf
Return ::hImage

*------------------------------------------------------------------------------*
METHOD HBitMap( hBitMap ) CLASS TNotifyIcon
*------------------------------------------------------------------------------*
   If ValType( hBitMap ) $ "NP"
      ::HIcon := hBitMap
   EndIf
Return ::hImage

*------------------------------------------------------------------------------*
METHOD ToolTip( cToolTip ) CLASS TNotifyIcon
*------------------------------------------------------------------------------*
   If PCOUNT() > 0
      If ! HB_IsString( cToolTip )
         cToolTip := ""
      EndIf
      ::cToolTip := cToolTip
      If ::lCreated .OR. ! EMPTY( ::cToolTip )
         SetNotifyIconData( ::Parent:hWnd, ::nTrayId, ::lCreated, , ::cToolTip )
         ::lCreated := .T.   // This value can be set "any" time...
      EndIf
   EndIf
Return ::cToolTip

*------------------------------------------------------------------------------*
METHOD Events_TaskBar( lParam ) CLASS TNotifyIcon
*------------------------------------------------------------------------------*

   Do Case
      Case lParam == WM_LBUTTONDOWN
         ::DoEvent( ::OnClick, "WINDOW_NOTIFYLEFTCLICK" )

      Case lParam == WM_RBUTTONDOWN .OR. lParam == WM_CONTEXTMENU
         If ::ContextMenu != nil
            If _OOHG_ShowContextMenus()
               ::ContextMenu:Activate()
            Endif
         Else
            ::DoEvent( ::OnRClick, "WINDOW_NOTIFYDBLCLICK" )
         EndIf

      Case lParam == WM_LBUTTONDBLCLK
         ::DoEvent( ::OnDblClick, "WINDOW_NOTIFYDBLCLICK" )

      Case lParam == WM_RBUTTONDBLCLK
         ::DoEvent( ::OnRDblClick, "WINDOW_NOTIFYRDBLCLICK" )

      Case lParam == WM_MBUTTONDOWN
         ::DoEvent( ::OnMClick, "WINDOW_NOTIFYMIDCLICK" )

      Case lParam == WM_MBUTTONDBLCLK
         ::DoEvent( ::OnMDblClick, "WINDOW_NOTIFYMDBLCLICK" )

   EndCase

Return nil

#pragma BEGINDUMP

#ifndef HB_OS_WIN_32_USED
   #define HB_OS_WIN_32_USED
#endif

#ifndef _WIN32_WINNT
   #define _WIN32_WINNT 0x0500
#endif
#if ( _WIN32_WINNT < 0x0500 )
   #undef _WIN32_WINNT
   #define _WIN32_WINNT 0x0500
#endif

#include "hbapi.h"
#include <windows.h>
#include <windowsx.h>
#include <commctrl.h>
#include "oohg.h"

#define WM_TASKBAR WM_USER+1043

HB_FUNC( LOADTRAYICON )
{
   HICON hImage;
   HINSTANCE hInstance  = ( HINSTANCE ) hb_parnl( 1 );  // handle to application instance
   LPCTSTR   lpIconName = ( LPCTSTR )   hb_parc( 2 );   // name string or resource identifier

   hImage = LoadIcon( hInstance, lpIconName );

   if( hImage == NULL )
   {
      hImage = ( HICON ) LoadImage( hInstance, lpIconName, IMAGE_ICON, 0, 0, LR_LOADFROMFILE + LR_DEFAULTSIZE );
   }

   HWNDret( ( HWND ) hImage );
}

HB_FUNC( CHANGENOTIFYICON )
{
   NOTIFYICONDATA nid;
   ZeroMemory( &nid, sizeof( nid ) );
   nid.cbSize = sizeof( NOTIFYICONDATA );
   nid.hWnd = HWNDparam( 1 );
   nid.uID = 0;
   nid.uFlags = NIF_ICON | NIF_MESSAGE | NIF_TIP;
   nid.uCallbackMessage = WM_TASKBAR;
   nid.hIcon = ( HICON ) HWNDparam( 2 );
   lstrcpy( nid.szTip, TEXT( ( LPSTR ) hb_parc( 3 ) ) );

   Shell_NotifyIcon( NIM_MODIFY, &nid );
}

HB_FUNC( SHOWNOTIFYICON )
{
   NOTIFYICONDATA nid;
   ZeroMemory( &nid, sizeof( nid ) );
   nid.cbSize = sizeof( NOTIFYICONDATA );
   nid.hWnd = HWNDparam( 1 );
   nid.uID = 0;
   nid.uFlags = NIF_ICON | NIF_MESSAGE | NIF_TIP;
   nid.uCallbackMessage = WM_TASKBAR;
   nid.hIcon = ( HICON ) HWNDparam( 3 );
   lstrcpy( nid.szTip, TEXT( ( LPSTR ) hb_parc( 4 ) ) );

   if( hb_parl( 2 ) )
      Shell_NotifyIcon( NIM_ADD, &nid );
   else
      Shell_NotifyIcon( NIM_DELETE, &nid );
}

HB_FUNC( SETNOTIFYICONDATA )     // ( hWnd, nId, lAlreadyCreated, hIcon, cTooltip )
{
   NOTIFYICONDATA nid;
   ZeroMemory( &nid, sizeof( nid ) );
   nid.cbSize = sizeof( NOTIFYICONDATA );
   nid.hWnd = HWNDparam( 1 );
   nid.uID = hb_parni( 2 );
   nid.uFlags = 0;
   if( ! ISNIL( 4 ) )
   {
      nid.uFlags |= NIF_ICON;
      nid.hIcon = ( HICON ) HWNDparam( 4 );
   }
   if( ISCHAR( 5 ) )
   {
      nid.uFlags |= NIF_TIP;
      lstrcpy( nid.szTip, TEXT( ( LPSTR ) hb_parc( 5 ) ) );
   }

   if( hb_parl( 3 ) )
   {
      if( nid.uFlags )
      {
         Shell_NotifyIcon( NIM_MODIFY, &nid );
      }
   }
   else
   {
      nid.uFlags |= NIF_MESSAGE;
      nid.uCallbackMessage = WM_TASKBAR;
      Shell_NotifyIcon( NIM_ADD, &nid );
   }
}

HB_FUNC( REMOVENOTIFYICON )
{
   NOTIFYICONDATA nid;
   ZeroMemory( &nid, sizeof( nid ) );
   nid.cbSize = sizeof( NOTIFYICONDATA );
   nid.hWnd = HWNDparam( 1 );
   nid.uID = hb_parni( 2 );
   nid.uFlags = 0;
   Shell_NotifyIcon( NIM_DELETE, &nid );
}

#pragma ENDDUMP
