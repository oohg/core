/*
 * $Id: h_notify.prg $
 */
/*
 * OOHG source code:
 * Notify icon control
 *
 * Copyright 2009-2022 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2022 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2022 Contributors, https://harbour.github.io/
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
 * Boston, MA 02110-1335, USA (or download from http://www.gnu.org/licenses/).
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

   ENDCLASS

METHOD Define( ControlName, ParentForm, cPicture, cToolTip, ProcedureName, invisible ) CLASS TNotifyIcon

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

METHOD Release() CLASS TNotifyIcon

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

METHOD Picture( cPicture ) CLASS TNotifyIcon

   IF VALTYPE( cPicture ) $ "CM"
      DeleteObject( ::hImage )
      ::cPicture := cPicture
      ::hImage := LoadTrayIcon( GetInstance(), cPicture )
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

METHOD Buffer( cBuffer ) CLASS TNotifyIcon

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

METHOD HIcon( hIcon ) CLASS TNotifyIcon

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

METHOD HBitMap( hBitmap ) CLASS TNotifyIcon

   If ValType( hBitmap ) $ "NP"
      ::HIcon := hBitMap
   EndIf

   Return ::hImage

METHOD ToolTip( cToolTip ) CLASS TNotifyIcon

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

METHOD Events_TaskBar( lParam ) CLASS TNotifyIcon

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

#include "oohg.h"
#include <windowsx.h>

#ifndef WM_TASKBAR
   #define WM_TASKBAR ( WM_USER + 1043 )
#endif

HB_FUNC( LOADTRAYICON )          /* FUNCTION LoadTrayIcon( hInstance, cIcon ) -> hIcon */
{
   HINSTANCE hInstance = HINSTANCEparam( 1 );   /* handle to application instance */
#ifndef UNICODE
   TCHAR* lpIconName = (TCHAR *) ( HB_ISCHAR( 2 ) ? hb_parc( 2 ) : MAKEINTRESOURCE( hb_parni( 2 ) ) );
#else
   TCHAR* lpIconName = (TCHAR *) ( HB_ISCHAR( 2 ) ? AnsiToWide( (char *) hb_parc( 2 ) ) : MAKEINTRESOURCE( hb_parni( 2 ) ) );
#endif

   HICON hIcon = LoadIcon( hInstance, lpIconName );

   if( hIcon == NULL )
   {
      hIcon = (HICON) LoadImage( hInstance, lpIconName, IMAGE_ICON, 0, 0, LR_LOADFROMFILE + LR_DEFAULTSIZE );
   }

   HICONret( hIcon );

#ifdef UNICODE
   if( HB_ISCHAR( 2 ) )
   {
      hb_xfree( (TCHAR *) lpIconName );
   }
#endif
}

HB_FUNC( CHANGENOTIFYICON )          /* FUNCTION ChangeNotifyIcon( hWnd, hIcon, cTooltip ) -> NIL */
{
   char *pText;
   NOTIFYICONDATA nid;
   ZeroMemory( &nid, sizeof( nid ) );
   nid.cbSize = sizeof( NOTIFYICONDATA );
   nid.hWnd = HWNDparam( 1 );
   nid.uID = 0;
   nid.uFlags = NIF_ICON | NIF_MESSAGE | NIF_TIP;
   nid.uCallbackMessage = WM_TASKBAR;
   nid.hIcon = HICONparam( 2 );
   pText = hb_strndup( hb_parc( 3 ), sizeof( nid.szTip ) );
   lstrcpy( nid.szTip, TEXT( pText ) );
   hb_xfree( pText );
   Shell_NotifyIcon( NIM_MODIFY, &nid );
}

HB_FUNC( SHOWNOTIFYICON )          /* FUNCTION ShowNotifyIcon( hWnd, lAdd, hIcon, cTooltip ) -> NIL */
{
   char *pText;
   NOTIFYICONDATA nid;
   ZeroMemory( &nid, sizeof( nid ) );
   nid.cbSize = sizeof( NOTIFYICONDATA );
   nid.hWnd = HWNDparam( 1 );
   nid.uID = 0;
   nid.uFlags = NIF_ICON | NIF_MESSAGE | NIF_TIP;
   nid.uCallbackMessage = WM_TASKBAR;
   nid.hIcon = (HICON) HWNDparam( 3 );
   pText = hb_strndup( hb_parc( 4 ), sizeof( nid.szTip ) );
   lstrcpy( nid.szTip, pText );
   hb_xfree( pText );
   if( hb_parl( 2 ) )
      Shell_NotifyIcon( NIM_ADD, &nid );
   else
      Shell_NotifyIcon( NIM_DELETE, &nid );
}

HB_FUNC( SETNOTIFYICONDATA )          /* FUNCTION SetNotifyIconData( hWnd, nId, lAlreadyCreated, hIcon, cTooltip ) -> NIL */
{
   char *pText;
   NOTIFYICONDATA nid;
   ZeroMemory( &nid, sizeof( nid ) );
   nid.cbSize = sizeof( NOTIFYICONDATA );
   nid.hWnd = HWNDparam( 1 );
   nid.uID = hb_parni( 2 );
   nid.uFlags = 0;
   if( ! HB_ISNIL( 4 ) )
   {
      nid.uFlags |= NIF_ICON;
      nid.hIcon = HICONparam( 4 );
   }
   if( HB_ISCHAR( 5 ) )
   {
      nid.uFlags |= NIF_TIP;
      pText = hb_strndup( hb_parc( 5 ), sizeof( nid.szTip ) );
      lstrcpy( nid.szTip, TEXT( pText ) );
      hb_xfree( pText );
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
