/*
 * $Id: h_tooltip.prg $
 */
/*
 * ooHG source code:
 * Tooltip control
 *
 * Copyright 2008-2017 Vicente Guerra <vicente@guerra.com.mx>
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
 * Copyright 1999-2017, https://harbour.github.io/
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


#include "oohg.ch"
#include "i_windefs.ch"
#include "hbclass.ch"


STATIC _OOHG_ToolTipInitialTime := 0
STATIC _OOHG_ToolTipAutoPopTime := 0
STATIC _OOHG_ToolTipReShowTime := 0
STATIC _OOHG_ToolTipMultiLine := .F.
STATIC _OOHG_ToolTipBalloon := .F.
STATIC _OOHG_ToolTipClose := .F.


CLASS TToolTip FROM TControl

   DATA cIcon                     INIT ''
   DATA cTitle                    INIT ''
   DATA lMultiLine                INIT .F.
   DATA nIcon                     INIT TTI_NONE
   DATA nWindowWidth              INIT -1
   DATA Type                      INIT "TOOLTIP" READONLY

   METHOD AutoPopTime             SETGET
   METHOD Define
   METHOD Events_Notify
   METHOD Icon                    SETGET
   METHOD InitialTime             SETGET
   METHOD Item
   METHOD MultiLine               SETGET
   METHOD ResetDelays
   METHOD ReshowTime              SETGET
   METHOD Title                   SETGET
   METHOD WindowWidth             SETGET

   ENDCLASS

METHOD Define( ControlName, ParentForm, nInitial, nAutoPop, nReShow, lMulti, lBalloon, lClose ) CLASS TToolTip

   LOCAL ControlHandle

   ASSIGN nInitial VALUE nInitial TYPE "N" DEFAULT _OOHG_ToolTipInitialTime
   ASSIGN nAutoPop VALUE nAutoPop TYPE "N" DEFAULT _OOHG_ToolTipAutoPopTime
   ASSIGN nReShow  VALUE nReShow  TYPE "N" DEFAULT _OOHG_ToolTipReshowTime
   ASSIGN lMulti   VALUE lMulti   TYPE "L" DEFAULT _OOHG_ToolTipMultiLine
   ASSIGN lBalloon VALUE lBalloon TYPE "N" DEFAULT _OOHG_ToolTipBalloon
   ASSIGN lClose   VALUE lClose   TYPE "L" DEFAULT _OOHG_ToolTipClose

   ::SetForm( ControlName, ParentForm )
   ControlHandle := InitToolTip( ::ContainerhWnd, lBalloon, lClose )
   ::Register( ControlHandle, ControlName )
   If nInitial > 0
      ::InitialTime := nInitial
   EndIf
   If nAutoPop > 0
      ::AutoPopTime := nAutoPop
   EndIf
   If nReShow > 0
      ::ReshowTime := nReShow
   EndIf
   ::MultiLine := lMulti

   Return Self

METHOD Item( hWnd, cToolTip ) CLASS TToolTip

   If VALTYPE( cToolTip ) $ "CM" .OR. HB_IsBlock( cToolTip )
      SetToolTip( hWnd, cToolTip, ::hWnd )
   EndIf

   RETURN GetToolTip( hWnd, ::hWnd )

METHOD Events_Notify( wParam, lParam ) CLASS TToolTip

   Local nNotify := GetNotifyCode( lParam )
   Local oControl, cToolTip

   HB_SYMBOL_UNUSED( wParam )

   If     nNotify == TTN_GETDISPINFO
      oControl := GetControlObjectByHandle( _GetToolTipGetDispInfoHWnd( lParam ) )
      cToolTip := oControl:cToolTip
      IF HB_IsBlock( cToolTip )
         oControl:DoEvent( { || cToolTip := EVAL( cToolTip, oControl ) }, "TOOLTIP" )
      EndIf
      _SetToolTipGetDispInfo( lParam, cToolTip )

   EndIf

   Return ::Super:Events_Notify( wParam, lParam )

METHOD WindowWidth( nWidth ) CLASS TToolTip

   If HB_IsNumeric( nWidth )
      SendMessage( ::hWnd, TTM_SETMAXTIPWIDTH, 0, nWidth )
      ::nWindowWidth := nWidth
      ::lMultiLine := ( nWidth >= 0 )
   EndIf

   Return ::nWindowWidth

METHOD MultiLine( lMultiLine ) CLASS TToolTip

   If HB_IsLogical( lMultiLine ) .AND. ! lMultiLine == ::lMultiLine
      ::lMultiLine := lMultiLine
      If lMultiLine
         If ::nWindowWidth >= 0
            SendMessage( ::hWnd, TTM_SETMAXTIPWIDTH, 0, ::nWindowWidth )
         Else
            SendMessage( ::hWnd, TTM_SETMAXTIPWIDTH, 0, 200 )   // Any "default" value
         Endif
      Else
         SendMessage( ::hWnd, TTM_SETMAXTIPWIDTH, 0, -1 )
      Endif
   EndIf

   Return ::lMultiLine

Function _SetToolTipBalloon( lNewBalloon )

   Local oReg, lYesNo := Nil, lOldBalloon := _OOHG_ToolTipBalloon

   If HB_IsLogical( lNewBalloon )
      If lNewBalloon
         oReg := TReg32():New( HKEY_CURRENT_USER, "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", .F. )
         oReg:Get( "EnableBalloonTips", lYesNo )
         oReg:Close()
      EndIf
      _OOHG_ToolTipBalloon := lNewBalloon
   Endif

   return lOldBalloon

Function _SetToolTipClose( lNewClose )

   Local lOldClose := _OOHG_ToolTipClose

   If HB_IsLogical( lNewClose )
      _OOHG_ToolTipClose := lNewClose
   Endif

   return lOldClose

Function _SetToolTipInitialTime( nMilliSec )

   Local lOldInitialTime := _OOHG_ToolTipInitialTime

   If HB_IsNumeric( nMilliSec ) .AND. nMilliSec > 0
      _OOHG_ToolTipInitialTime := nMilliSec
   EndIf

   Return lOldInitialTime

Function _SetToolTipAutoPopTime( nMilliSec )

   Local lOldAutoPopTime := _OOHG_ToolTipAutoPopTime

   If HB_IsNumeric( nMilliSec ) .AND. nMilliSec > 0
      _OOHG_ToolTipAutoPopTime := nMilliSec
   EndIf

   Return lOldAutoPopTime

Function _SetToolTipReShowTime( nMilliSec )

   Local lOldReShowTime := _OOHG_ToolTipReShowTime

   If HB_IsNumeric( nMilliSec ) .AND. nMilliSec > 0
      _OOHG_ToolTipReShowTime := nMilliSec
   EndIf

   Return lOldReShowTime

Function _SetToolTipMultiLine( lNewMultiLine )

   Local lOldMultiLine := _OOHG_ToolTipMultiLine

   If HB_IsLogical( lNewMultiLine )
      _OOHG_ToolTipMultiLine := lNewMultiLine
   EndIf

   Return lOldMultiLine

METHOD InitialTime( nMilliSecs ) CLASS TToolTip

   If PCount() > 0
      /* nMilliSec := -1 returns the initial time (amount of time the mouse
         must remain stationary on a control before the tooltip appears) to
         its default value = GetDoubleClickTime()
      */
      SetInitialTime( ::hWnd, nMilliSecs )
   EndIf

   Return GetInitialTime( ::hWnd )

METHOD AutoPopTime( nMilliSecs ) CLASS TToolTip

   If PCount() > 0
      /* nMilliSec := -1 returns the autopop time (amount of time a tooltip
         remains visible if the mouse is stationary on the control) to its
         default value = GetDoubleClickTime() * 10
      */
      SetAutoPopTime( ::hWnd, nMilliSecs )
   EndIf

   Return GetAutoPopTime( ::hWnd )

METHOD ReshowTime( nMilliSecs ) CLASS TToolTip

   If PCount() > 0
      /* nMilliSec := -1 returns the reshow time (amount of time it takes for
         subsequent tooltip windows to appear as the mouse moves from one
         control to another) to its default value = GetDoubleClickTime() / 5
      */
      SetReshowTime( ::hWnd, nMilliSecs )
   EndIf

   Return GetReshowTime( ::hWnd )

METHOD ResetDelays( nMilliSecs ) CLASS TToolTip

   /* Sets all three delay times to default proportions. The autopop time will
      be ten times the initial time and the reshow time will be one fifth the
      initial time. Use nMilliSec > 0 to specify a new initial time. Use a
      negative value to return all three delay times to their default values.
      Use 0 to retain the current initial time.
   */
   ASSIGN nMilliSecs VALUE nMilliSecs TYPE "N" DEFAULT -1
   If nMilliSecs == 0
     nMilliSecs := ::InitialTime()
   EndIf
   SetDelayTime( ::hWnd, nMilliSecs )

   Return Nil

METHOD Icon( uIcon ) CLASS TToolTip

   /*
    * uIcon valid values are:
    * TTI_NONE    - no icon
    * TTI_INFO    - info icon
    * TTI_WARNING - warning icon
    * a handle to icon
    * a resource name
    * a filename
    */
   If HB_IsNumeric( uIcon )
      If ::nIcon > TTI_ERROR .AND. ValidHandler( ::nIcon )
         DeleteObject( ::nIcon )
      EndIf
      ::cIcon := ''
      ::nIcon := uIcon
      TToolTip_SetIconAndTitle( ::hWnd, ::nIcon, Left( ::cTitle, 99 ) )
   ElseIf ValType( uIcon ) $ "CM"
      If ::nIcon > TTI_ERROR .AND. ValidHandler( ::nIcon )
         DeleteObject( ::nIcon )
      EndIf
      ::cIcon := uIcon
      ::nIcon := LoadIcon( GetInstance(), uIcon )
      TToolTip_SetIconAndTitle( ::hWnd, ::nIcon, Left( ::cTitle, 99 ) )
   EndIf

   RETURN TToolTip_GetIcon( ::hWnd )

METHOD Title( cTitle ) CLASS TToolTip

   If ValType( cTitle ) $ "CM"
      ::cTitle := cTitle
      TToolTip_SetIconAndTitle( ::hWnd, ::nIcon, Left( ::cTitle, 99 ) )
   EndIf

   RETURN TToolTip_GetTitle( ::hWnd )


#pragma BEGINDUMP

#ifndef HB_OS_WIN_32_USED
   #define HB_OS_WIN_32_USED
#endif

#ifndef _WIN32_IE
   #define _WIN32_IE 0x0500
#endif
#if ( _WIN32_IE < 0x0500 )
   #undef _WIN32_IE
   #define _WIN32_IE 0x0500
#endif

#ifndef _WIN32_WINNT
   #define _WIN32_WINNT 0x0400
#endif
#if ( _WIN32_WINNT < 0x0400 )
   #undef _WIN32_WINNT
   #define _WIN32_WINNT 0x0400
#endif

#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"
#include "oohg.h"

LONG _OOHG_TooltipBackcolor = -1;     // Tooltip's backcolor
LONG _OOHG_TooltipForecolor = -1;     // Tooltip's forecolor

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

typedef int (CALLBACK *CALL_SETWINDOWTHEME )( HWND, LPCWSTR, LPCWSTR );

#ifndef TTS_CLOSE
   #define TTS_CLOSE 0x80
#endif

HB_FUNC( INITTOOLTIP )
{
   CALL_SETWINDOWTHEME dwSetWindowTheme;
   HMODULE hInstDLL;
   HWND htooltip;
   int Style = TTS_ALWAYSTIP;

   if( hb_parl( 2 ) )
   {
      Style |= TTS_BALLOON;

      if( hb_parl( 3 ) )
      {
         Style |= TTS_CLOSE;
      }
   }

   InitCommonControls();

   htooltip = CreateWindowEx( 0, "tooltips_class32", "", Style,
                              0, 0, 0, 0, HWNDparam( 1 ),
                              NULL, GetModuleHandle( NULL ), NULL );

   if( ( _OOHG_TooltipBackcolor != -1 ) || ( _OOHG_TooltipForecolor != -1 ) )
   {
      hInstDLL = LoadLibrary( "UXTHEME.DLL" );
      if( hInstDLL )
      {
         dwSetWindowTheme = (CALL_SETWINDOWTHEME) GetProcAddress( hInstDLL, "SetWindowTheme" );
         if( dwSetWindowTheme )
         {
            if( ( dwSetWindowTheme )( htooltip, L" ", L" " ) == S_OK )
            {
               if( _OOHG_TooltipBackcolor != -1 )
               {
                  SendMessage( htooltip, TTM_SETTIPBKCOLOR, _OOHG_TooltipBackcolor, 0 );
               }

               if( _OOHG_TooltipForecolor != -1 )
               {
                  SendMessage( htooltip, TTM_SETTIPTEXTCOLOR, _OOHG_TooltipForecolor, 0 );
               }
            }
         }
         FreeLibrary( hInstDLL );
      }
   }

   if( htooltip )
   {
      lpfnOldWndProc = ( WNDPROC ) SetWindowLong( ( HWND ) htooltip, GWL_WNDPROC, ( LONG ) SubClassFunc );
   }

   HWNDret( htooltip );
}

HB_FUNC( SETTOOLTIP )   // ( hWnd, cToolTip, hWndToolTip )
{
   TOOLINFO  ti;

   HWND hWnd;
   HWND hWnd_ToolTip;

   hWnd = HWNDparam( 1 );
   hWnd_ToolTip = HWNDparam( 3 );

   memset( &ti, 0, sizeof( ti ) );

   ti.cbSize = sizeof( ti );
// TODO: TTF_CENTERTIP, TTF_PARSELINKS, TTF_RTLREADING, TTF_TRACK
   ti.uFlags = TTF_SUBCLASS | TTF_IDISHWND;
   ti.hwnd = GetParent( hWnd );
   ti.uId = ( UINT ) hWnd;

   if( SendMessage( hWnd_ToolTip, ( UINT ) TTM_GETTOOLINFO, (WPARAM) 0, (LPARAM) &ti ) )
   {
      SendMessage( hWnd_ToolTip, ( UINT ) TTM_DELTOOL, (WPARAM) 0, (LPARAM) &ti );
   }

   ti.cbSize = sizeof( ti );
   ti.uFlags = TTF_SUBCLASS | TTF_IDISHWND;
   ti.hwnd = GetParent( hWnd );
   ti.uId = ( UINT ) hWnd;
   if( HB_ISBLOCK( 2 ) )
   {
      ti.lpszText = LPSTR_TEXTCALLBACK;
   }
   else
   {
      ti.lpszText = (LPSTR) hb_parc( 2 );
   }

   SendMessage( hWnd_ToolTip, (UINT) TTM_ADDTOOL, (WPARAM) 0, (LPARAM) &ti );

   hb_retni( 0 );
}

HB_FUNC( GETTOOLTIP )   // ( hWnd, hWndToolTip )
{
   TOOLINFO ti;
   HWND hWnd_ToolTip;
   char cText[ 1024 ];
   HWND hWnd;

   hWnd = HWNDparam( 1 );
   hWnd_ToolTip = HWNDparam( 2 );

   memset( &ti, 0, sizeof( ti ) );
   ti.cbSize = sizeof( ti );
   ti.uFlags = TTF_IDISHWND;
   ti.hwnd = GetParent( hWnd );
   ti.uId = ( UINT ) hWnd;
   ti.lpszText = ( LPTSTR ) &cText;
   cText[ 0 ] = 0;

   SendMessage( hWnd_ToolTip, TTM_GETTOOLINFO, 0, (LPARAM) &ti );

   hb_retc( ( char * ) &cText );
}

HB_FUNC( _SETTOOLTIPBACKCOLOR )
{
   _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &_OOHG_TooltipBackcolor, ( hb_pcount() >= 1 ) );
}

HB_FUNC( _SETTOOLTIPFORECOLOR )
{
   _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &_OOHG_TooltipForecolor, ( hb_pcount() >= 1 ) );
}

HB_FUNC( _GETTOOLTIPGETDISPINFOHWND )     // ( lParam )
{
   NMTTDISPINFO *notify;
   notify = ( NMTTDISPINFO * ) hb_parnl( 1 );
   HWNDret( notify->hdr.idFrom );
}

static char _OOHG_ToolTipBuffer[ 10001 ];             // TODO: Thread safe ?

HB_FUNC( _SETTOOLTIPGETDISPINFO )     // ( lParam, cToolTip )
{
   NMTTDISPINFO *notify;
   int iLen;

   iLen = hb_parclen( 2 );
   if( iLen > 10000 )
   {
      iLen = 10000;
   }
   if( iLen )
   {
      memcpy( _OOHG_ToolTipBuffer, hb_parc( 2 ), iLen );
   }
   _OOHG_ToolTipBuffer[ iLen ] = 0;

   notify = ( NMTTDISPINFO * ) hb_parnl( 1 );
   notify->lpszText = ( LPSTR ) _OOHG_ToolTipBuffer;
   notify->szText[ 0 ] = 0;
   notify->hinst = NULL;
}

HB_FUNC( GETINITIALTIME )
{
   hb_retni( SendMessage( HWNDparam( 1 ), TTM_GETDELAYTIME, (WPARAM) TTDT_INITIAL, 0 ) );
}

HB_FUNC( GETAUTOPOPTIME )
{
   hb_retni( SendMessage( HWNDparam( 1 ), TTM_GETDELAYTIME, (WPARAM) TTDT_AUTOPOP, 0 ) );
}

HB_FUNC( GETRESHOWTIME )
{
   hb_retni( SendMessage( HWNDparam( 1 ), TTM_GETDELAYTIME, (WPARAM) TTDT_RESHOW, 0 ) );
}

HB_FUNC( SETINITIALTIME )
{
   SendMessage( HWNDparam( 1 ), TTM_SETDELAYTIME, (WPARAM) TTDT_INITIAL, (LPARAM) MAKELONG( hb_parni( 2 ), 0 ) );
}

HB_FUNC( SETAUTOPOPTIME )
{
   SendMessage( HWNDparam( 1 ), TTM_SETDELAYTIME, (WPARAM) TTDT_AUTOPOP, (LPARAM) MAKELONG( hb_parni( 2 ), 0 ) );
}

HB_FUNC( SETRESHOWTIME )
{
   SendMessage( HWNDparam( 1 ), TTM_SETDELAYTIME, (WPARAM) TTDT_RESHOW, (LPARAM) MAKELONG( hb_parni( 2 ), 0 ) );
}

HB_FUNC( SETDELAYTIME )
{
   SendMessage( HWNDparam( 1 ), TTM_SETDELAYTIME, (WPARAM) TTDT_AUTOMATIC, (LPARAM) MAKELONG( hb_parni( 2 ), 0 ) );
}

HB_FUNC( GETDOUBLECLICKTIME )
{
   hb_retni( GetDoubleClickTime() );
}

#ifndef TTM_GETTITLE
   #define TTM_GETTITLE ( WM_USER + 35 ) // wParam = 0, lParam = TTGETTITLE*

   typedef struct _TTGETTITLE
   {
       DWORD dwSize;
       UINT uTitleBitmap;
       UINT cch;
       WCHAR *pszTitle;
   } TTGETTITLE, *PTTGETTITLE;
#endif

HB_FUNC( TTOOLTIP_GETICON )   // ( hWnd )
{
   TTGETTITLE gt;

   memset( &gt, 0, sizeof( gt ) );
   gt.dwSize = sizeof( gt );

   SendMessage( HWNDparam( 1 ), TTM_GETTITLE, (WPARAM) 0, (LPARAM) &gt );

   hb_retni( (int) gt.uTitleBitmap );
}

HB_FUNC( TTOOLTIP_GETTITLE )   // ( hWnd )
{
   TTGETTITLE gt;
   char *cBuffer;

   memset( &gt, 0, sizeof( gt ) );
   gt.dwSize = sizeof( gt );

   SendMessage( HWNDparam( 1 ), TTM_GETTITLE, (WPARAM) 0, (LPARAM) &gt );

   if( gt.cch > 0 )
   {
      cBuffer = (char *) hb_xgrab( gt.cch );
      WideCharToMultiByte( CP_ACP, 0, gt.pszTitle, -1, cBuffer, gt.cch, NULL, NULL );
      hb_retc( cBuffer );
      hb_xfree( cBuffer );
   }
   else
   {
      hb_retc( "" );
   }
}

#ifndef TTM_SETTITLE
   #define TTM_SETTITLE ( WM_USER + 32 )
#endif

HB_FUNC( TTOOLTIP_SETICONANDTITLE )   // ( hWnd, nIcon, cTitle )
{
   hb_retl( SendMessage( HWNDparam( 1 ), TTM_SETTITLE, (WPARAM) hb_parni( 2 ), (LPARAM) hb_parc( 3 ) ) );

}

#pragma ENDDUMP
