/*
 * $Id: h_tooltip.prg $
 */
/*
 * OOHG source code:
 * Tooltip control
 *
 * Copyright 2008-2022 Vicente Guerra <vicente@guerra.com.mx> and contributors of
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
#include "i_windefs.ch"
#include "hbclass.ch"

STATIC _OOHG_ToolTipInitialTime := 0
STATIC _OOHG_ToolTipAutoPopTime := 0
STATIC _OOHG_ToolTipReShowTime  := 0
STATIC _OOHG_ToolTipMultiLine   := .F.
STATIC _OOHG_ToolTipBalloon     := .F.
STATIC _OOHG_ToolTipClose       := .F.

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TToolTip FROM TControl

   DATA cIcon                     INIT ''
   DATA cTitle                    INIT ''
   DATA lActive                   INIT .F.
   DATA lMultiLine                INIT .F.
   DATA nIcon                     INIT TTI_NONE
   DATA nWindowWidth              INIT -1
   DATA Type                      INIT "TOOLTIP" READONLY

   METHOD Activate                SETGET
   METHOD AutoPopTime             SETGET
   METHOD Define
   METHOD Events_Notify
   METHOD Icon                    SETGET
   METHOD InitialTime             SETGET
   METHOD Item
   METHOD MultiLine               SETGET
   METHOD ResetDelays             SETGET
   METHOD ReshowTime              SETGET
   METHOD Title                   SETGET
   METHOD WindowWidth             SETGET

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Activate( lOnOff ) CLASS TToolTip

   IF HB_ISLOGICAL( lOnOff )
      TTM_Activate( ::hWnd, lOnOff )
      ::lActive := lOnOff
   ENDIF

   RETURN ::lActive

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( ControlName, ParentForm, nInitial, nAutoPop, nReShow, lMulti, lBalloon, lClose, nMaxWidth ) CLASS TToolTip

   LOCAL ControlHandle

   ASSIGN nInitial  VALUE nInitial  TYPE "N" DEFAULT _OOHG_ToolTipInitialTime
   ASSIGN nAutoPop  VALUE nAutoPop  TYPE "N" DEFAULT _OOHG_ToolTipAutoPopTime
   ASSIGN nReShow   VALUE nReShow   TYPE "N" DEFAULT _OOHG_ToolTipReshowTime
   ASSIGN lMulti    VALUE lMulti    TYPE "L" DEFAULT _OOHG_ToolTipMultiLine
   ASSIGN lBalloon  VALUE lBalloon  TYPE "N" DEFAULT _OOHG_ToolTipBalloon
   ASSIGN lClose    VALUE lClose    TYPE "L" DEFAULT _OOHG_ToolTipClose
   ASSIGN nMaxWidth VALUE nMaxWidth TYPE "L" DEFAULT _SetToolTipMaxWidth()

   ::SetForm( ControlName, ParentForm )
   ControlHandle := InitToolTip( ::ContainerhWnd, lBalloon, lClose )
   ::Register( ControlHandle, ControlName )
   IF nInitial > 0
      ::InitialTime := nInitial
   ENDIF
   IF nAutoPop > 0
      ::AutoPopTime := nAutoPop
   ENDIF
   IF nReShow > 0
      ::ReshowTime := nReShow
   ENDIF
   ::WindowWidth := nMaxWidth
   ::MultiLine := lMulti

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Item( hWnd, cToolTip ) CLASS TToolTip

   IF ValType( cToolTip ) $ "CM" .OR. HB_ISBLOCK( cToolTip )
      SetToolTip( hWnd, cToolTip, ::hWnd )
   ENDIF

   RETURN GetToolTip( hWnd, ::hWnd )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Events_Notify( wParam, lParam ) CLASS TToolTip

   LOCAL nNotify := GetNotifyCode( lParam )
   LOCAL oControl, cToolTip

   HB_SYMBOL_UNUSED( wParam  )

   IF nNotify == TTN_GETDISPINFO
      oControl := GetControlObjectByHandle( _GetToolTipGetDispInfoHWnd( lParam ) )
      cToolTip := oControl:cToolTip
      IF HB_ISBLOCK( cToolTip )
         oControl:DoEvent( { || cToolTip := Eval( cToolTip, oControl ) }, "TOOLTIP" )
      ENDIF
      _SetToolTipGetDispInfo( lParam, cToolTip )
   ENDIF

   RETURN ::Super:Events_Notify( wParam, lParam )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD WindowWidth( nWidth ) CLASS TToolTip

   IF HB_ISNUMERIC( nWidth )
      SendMessage( ::hWnd, TTM_SETMAXTIPWIDTH, 0, nWidth )
      ::nWindowWidth := nWidth
      ::lMultiLine := ( nWidth >= 0 )
   ENDIF

   RETURN ::nWindowWidth

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD MultiLine( lMultiLine ) CLASS TToolTip

   IF HB_ISLOGICAL( lMultiLine ) .AND. ! lMultiLine == ::lMultiLine
      ::lMultiLine := lMultiLine
      IF lMultiLine
         IF ::nWindowWidth >= 0
            SendMessage( ::hWnd, TTM_SETMAXTIPWIDTH, 0, ::nWindowWidth )
         ELSE
            SendMessage( ::hWnd, TTM_SETMAXTIPWIDTH, 0, 200 )   // Any "default" value
         ENDIF
      ELSE
         SendMessage( ::hWnd, TTM_SETMAXTIPWIDTH, 0, -1 )
      ENDIF
   ENDIF

   RETURN ::lMultiLine

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _SetToolTipBalloon( lNewBalloon )

   LOCAL oReg, lYesNo := NIL, lOldBalloon

   App.MutexLock

   lOldBalloon := _OOHG_ToolTipBalloon

   IF HB_ISLOGICAL( lNewBalloon )
      IF lNewBalloon
         oReg := TReg32():New( HKEY_CURRENT_USER, "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", .F. )
         oReg:Get( "EnableBalloonTips", lYesNo )
         oReg:Close()
      ENDIF
      _OOHG_ToolTipBalloon := lNewBalloon
   ENDIF

   App.MutexUnlock

   RETURN lOldBalloon

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _SetToolTipClose( lNewClose )

   LOCAL lOldClose

   App.MutexLock

   lOldClose := _OOHG_ToolTipClose
   IF HB_ISLOGICAL( lNewClose )
      _OOHG_ToolTipClose := lNewClose
   ENDIF

   App.MutexUnlock

   RETURN lOldClose

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _SetToolTipInitialTime( nMilliSec )

   LOCAL lOldInitialTime

   App.MutexLock

   lOldInitialTime := _OOHG_ToolTipInitialTime
   IF HB_ISNUMERIC( nMilliSec ) .AND. nMilliSec > 0
      _OOHG_ToolTipInitialTime := nMilliSec
   ENDIF

   App.MutexUnlock

   RETURN lOldInitialTime

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _SetToolTipAutoPopTime( nMilliSec )

   LOCAL lOldAutoPopTime

   App.MutexLock

   lOldAutoPopTime := _OOHG_ToolTipAutoPopTime
   IF HB_ISNUMERIC( nMilliSec ) .AND. nMilliSec > 0
      _OOHG_ToolTipAutoPopTime := nMilliSec
   ENDIF

   App.MutexUnlock

   RETURN lOldAutoPopTime

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _SetToolTipReshowTime( nMilliSec )

   LOCAL lOldReShowTime

   App.MutexLock

   lOldReShowTime := _OOHG_ToolTipReShowTime
   IF HB_ISNUMERIC( nMilliSec ) .AND. nMilliSec > 0
      _OOHG_ToolTipReShowTime := nMilliSec
   ENDIF

   App.MutexUnlock

   RETURN lOldReShowTime

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _SetToolTipMultiLine( lNewMultiLine )

   LOCAL lOldMultiLine

   App.MutexLock

   lOldMultiLine := _OOHG_ToolTipMultiLine
   IF HB_ISLOGICAL( lNewMultiLine )
      _OOHG_ToolTipMultiLine := lNewMultiLine
   ENDIF

   App.MutexUnlock

   RETURN lOldMultiLine

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InitialTime( nMilliSecs ) CLASS TToolTip

   IF PCount() > 0
      /* nMilliSec := -1 returns the initial time (amount of time the mouse
         must remain stationary on a control before the tooltip appears) to
         its default value = GetDoubleClickTime()
      */
      SetInitialTime( ::hWnd, nMilliSecs )
   ENDIF

   RETURN GetInitialTime( ::hWnd )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD AutoPopTime( nMilliSecs ) CLASS TToolTip

   IF PCount() > 0
      /* nMilliSec := -1 returns the autopop time (amount of time a tooltip
         remains visible if the mouse is stationary on the control) to its
         default value = GetDoubleClickTime() * 10
      */
      SetAutoPopTime( ::hWnd, nMilliSecs )
   ENDIF

   RETURN GetAutoPopTime( ::hWnd )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ReshowTime( nMilliSecs ) CLASS TToolTip

   IF PCount() > 0
      /* nMilliSec := -1 returns the reshow time (amount of time it takes for
         subsequent tooltip windows to appear as the mouse moves from one
         control to another) to its default value = GetDoubleClickTime() / 5
      */
      SetReshowTime( ::hWnd, nMilliSecs )
   ENDIF

   RETURN GetReshowTime( ::hWnd )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ResetDelays( nMilliSecs ) CLASS TToolTip

   /* Sets all three delay times to default proportions. The autopop time will
      be ten times the initial time and the reshow time will be one fifth the
      initial time. Use nMilliSec > 0 to specify a new initial time. Use a
      negative value to return all three delay times to their default values.
      Use 0 to retain the current initial time.
   */
   ASSIGN nMilliSecs VALUE nMilliSecs TYPE "N" DEFAULT -1
   IF nMilliSecs == 0
     nMilliSecs := ::InitialTime()
   ENDIF
   SetDelayTime( ::hWnd, nMilliSecs )

   RETURN nMilliSecs

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Icon( uIcon ) CLASS TToolTip

   /*
    * uIcon valid values are:
    * TTI_NONE    - no icon
    * TTI_INFO    - info icon
    * TTI_WARNING - warning icon
    * a handle to an icon
    * a resource name
    * a filename
    */
   IF PCount() > 0
      IF Empty( uIcon )
         uIcon := TTI_NONE
      ENDIF
      IF HB_ISNUMERIC( uIcon )
         IF ::nIcon > TTI_ERROR .AND. ValidHandler( ::nIcon )
            DeleteObject( ::nIcon )
         ENDIF
         ::cIcon := ''
         ::nIcon := uIcon
         TToolTip_SetIconAndTitle( ::hWnd, ::nIcon, Left( ::cTitle, 99 ) )
      ELSEIF ValType( uIcon ) $ "CM"
         IF ::nIcon > TTI_ERROR .AND. ValidHandler( ::nIcon )
            DeleteObject( ::nIcon )
         ENDIF
         ::cIcon := uIcon
         ::nIcon := LoadIcon( GetInstance(), uIcon )
         TToolTip_SetIconAndTitle( ::hWnd, ::nIcon, Left( ::cTitle, 99 ) )
      ENDIF
   ENDIF

   RETURN TToolTip_GetIcon( ::hWnd )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Title( cTitle ) CLASS TToolTip

   IF ValType( cTitle ) $ "CM"
      ::cTitle := cTitle
      TToolTip_SetIconAndTitle( ::hWnd, ::nIcon, Left( ::cTitle, 99 ) )
   ENDIF

   RETURN ::cTitle

/*--------------------------------------------------------------------------------------------------------------------------------*/
#pragma BEGINDUMP

#include "oohg.h"
#include "hbapiitm.h"
#include "hbapicdp.h"

#ifndef TTS_CLOSE
   #define TTS_CLOSE 0x80
#endif

#ifndef TTM_GETTITLE
   #define TTM_GETTITLE ( WM_USER + 35 )

   typedef struct _TTGETTITLE
   {
       DWORD dwSize;
       UINT uTitleBitmap;
       UINT cch;
       WCHAR *pszTitle;
   } TTGETTITLE, *PTTGETTITLE;
#endif

#ifndef TTI_ERROR
   #define TTI_ERROR 3
#endif

#ifndef TTI_NONE
   #define TTI_NONE 0
#endif

#ifndef TTM_SETTITLE
   #define TTM_SETTITLE ( WM_USER + 32 )
#endif

static long _OOHG_TooltipBackcolor = -1;
static long _OOHG_TooltipForecolor = -1;
static long _OOHG_ToolTipMaxWidth  = -1;
static BOOL _OOHG_ToolTipActivate  = TRUE;
static char _OOHG_ToolTipBuffer[ 10001 ];

#ifndef ECM_FIRST
#define ECM_FIRST 0x1500
#endif

#ifndef EM_SHOWBALLOONTIP
#define EM_SHOWBALLOONTIP ( ECM_FIRST + 3 )
typedef struct _tagEDITBALLOONTIP
{
    DWORD   cbStruct;
    LPCWSTR pszTitle;
    LPCWSTR pszText;
    INT     ttiIcon; // From TTI_*
} EDITBALLOONTIP, *PEDITBALLOONTIP;
#define Edit_ShowBalloonTip( hwnd, peditballoontip ) \
        (BOOL) SNDMSG( (hwnd), EM_SHOWBALLOONTIP, 0, (LPARAM) (peditballoontip) )
#define EM_HIDEBALLOONTIP ( ECM_FIRST + 4 )
#define Edit_HideBalloonTip( hwnd ) \
        (BOOL) SNDMSG( (hwnd), EM_HIDEBALLOONTIP, 0, 0 )
#endif

#ifndef TTM_POPUP
#define TTM_POPUP ( WM_USER + 34 )
#endif

#ifndef EM_GETCUEBANNER
#define EM_GETCUEBANNER ( ECM_FIRST + 2 )
#endif

/*--------------------------------------------------------------------------------------------------------------------------------*/
static WNDPROC _OOHG_TToolTip_lpfnOldWndProc( LONG_PTR lp )
{
   static LONG_PTR lpfnOldWndProc = 0;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( ! lpfnOldWndProc )
   {
      lpfnOldWndProc = lp;
   }
   ReleaseMutex( _OOHG_GlobalMutex() );

   return (WNDPROC) lpfnOldWndProc;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, _OOHG_TToolTip_lpfnOldWndProc( 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( INITTOOLTIP )          /* FUNCTION InitToolTip( hWnd, lBalloon, lClose ) -> hWnd */
{
   INITCOMMONCONTROLSEX i;
   HWND hwndToolTip;
   int Style = TTS_ALWAYSTIP;

   if( hb_parl( 2 ) )
   {
      Style |= TTS_BALLOON;

      if( hb_parl( 3 ) )
      {
         Style |= TTS_CLOSE;
      }
   }

   i.dwSize = sizeof( INITCOMMONCONTROLSEX );
   i.dwICC = ICC_BAR_CLASSES;
   InitCommonControlsEx( &i );

   hwndToolTip = CreateWindowEx( 0, TOOLTIPS_CLASS, "", Style,
                                 0, 0, 0, 0,
                                 HWNDparam( 1 ), NULL, GetModuleHandle( NULL ), NULL );

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );

   if( ( _OOHG_TooltipBackcolor != -1 ) || ( _OOHG_TooltipForecolor != -1 ) )
   {
      if( _UxTheme_Init() )
      {
         if( ProcSetWindowTheme( hwndToolTip, L" ", L" " ) == S_OK )
         {
            if( _OOHG_TooltipBackcolor != -1 )
            {
               SendMessage( hwndToolTip, TTM_SETTIPBKCOLOR, (WPARAM) _OOHG_TooltipBackcolor, 0 );
            }

            if( _OOHG_TooltipForecolor != -1 )
            {
               SendMessage( hwndToolTip, TTM_SETTIPTEXTCOLOR, (WPARAM) _OOHG_TooltipForecolor, 0 );
            }
         }
      }
   }

   ReleaseMutex( _OOHG_GlobalMutex() );

   _OOHG_TToolTip_lpfnOldWndProc( SetWindowLongPtr( hwndToolTip, GWLP_WNDPROC, (LONG_PTR) SubClassFunc ) );

   HWNDret( hwndToolTip );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _SETTOOLTIPACTIVATE )          /* FUNCTION _SetToolTipActivate( lOnOf ) -> lOnOff */
{
   BOOL bOldActivate;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );

   bOldActivate = _OOHG_ToolTipActivate;
   if( HB_ISLOG( 1 ) )
   {
      _OOHG_ToolTipActivate = hb_parl( 1 );
   }

   ReleaseMutex( _OOHG_GlobalMutex() );

   hb_retl( bOldActivate );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( SETTOOLTIP )          /* FUNCTION SetToolTip( hWnd, cToolTip, hWndToolTip ) -> 0 */
{
   TOOLINFO ti;
   HWND hWnd;
   HWND hWndToolTip;

   hWnd = HWNDparam( 1 );
   hWndToolTip = HWNDparam( 3 );

   memset( &ti, 0, sizeof( ti ) );

   ti.cbSize = sizeof( ti );
/* TODO: TTF_CENTERTIP, TTF_PARSELINKS, TTF_RTLREADING, TTF_TRACK */
   ti.uFlags = TTF_SUBCLASS | TTF_IDISHWND;
   ti.hwnd = GetParent( hWnd );
   ti.uId = (UINT_PTR) hWnd;

   if( SendMessage( hWndToolTip, (UINT) TTM_GETTOOLINFO, (WPARAM) 0, (LPARAM) &ti ) )
   {
      SendMessage( hWndToolTip, (UINT) TTM_DELTOOL, (WPARAM) 0, (LPARAM) &ti );
   }

   if( HB_ISBLOCK( 2 ) )
   {
      ti.lpszText = LPSTR_TEXTCALLBACK;
   }
   else
   {
      ti.lpszText = (LPTSTR) HB_UNCONST( hb_parc( 2 ) );
   }

   hb_retl( SendMessage( hWndToolTip, TTM_ADDTOOL, (WPARAM) 0, (LPARAM) &ti ) ? HB_TRUE : HB_FALSE );

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );

   SendMessage( hWndToolTip, TTM_ACTIVATE, (WPARAM) _OOHG_ToolTipActivate, 0 );

   ReleaseMutex( _OOHG_GlobalMutex() );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TTM_ACTIVATE )          /* FUNCTION TTM_Activate( hWnd, lOnOff ) -> NIL */
{
   SendMessage( HWNDparam( 1 ), TTM_ACTIVATE, (WPARAM) hb_parl( 2 ), 0 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GETTOOLTIP )          /* FUNCTION GetToolTip( hWnd, hWndToolTip ) -> cText */
{
   TOOLINFO ti;
   HWND hWndToolTip;
   char cText[ 1024 ];
   HWND hWnd;

   hWnd = HWNDparam( 1 );
   hWndToolTip = HWNDparam( 2 );

   memset( &ti, 0, sizeof( ti ) );
   ti.cbSize = sizeof( ti );
   ti.uFlags = TTF_IDISHWND;
   ti.hwnd = GetParent( hWnd );
   ti.uId = (UINT_PTR) hWnd;
   ti.lpszText = (LPTSTR) &cText;
   cText[ 0 ] = 0;

   SendMessage( hWndToolTip, TTM_GETTOOLINFO, 0, (LPARAM) &ti );

   hb_retc( (char *) &cText );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _SETTOOLTIPBACKCOLOR )          /* FUNCTION _SetToolTipBackColor( uColor ) -> uColor */
{
   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &_OOHG_TooltipBackcolor, ( hb_pcount() >= 1 ) );
   ReleaseMutex( _OOHG_GlobalMutex() );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _SETTOOLTIPFORECOLOR )          /* FUNCTION _SetToolTipForeColor( uColor ) -> uColor */
{
   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &_OOHG_TooltipForecolor, ( hb_pcount() >= 1 ) );
   ReleaseMutex( _OOHG_GlobalMutex() );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _GETTOOLTIPGETDISPINFOHWND )          /* FUNCTION _GetToolTipGetDispInfoHWND( lParam ) -> hWnd */
{
   NMTTDISPINFO *notify;
   notify = NMTTDISPINFOparam( 1 );
   HWNDret( notify->hdr.idFrom );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _SETTOOLTIPGETDISPINFO )          /* FUNCTION _SetToolTipGetDispInfo( lParam, cToolTip ) -> NIL */
{
   NMTTDISPINFO *notify;
   int iLen;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );

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

   notify = NMTTDISPINFOparam( 1 );
   notify->lpszText = (LPSTR) _OOHG_ToolTipBuffer;
   notify->szText[ 0 ] = 0;
   notify->hinst = NULL;

   ReleaseMutex( _OOHG_GlobalMutex() );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TTM_GETDELAYTIME )          /* FUNCTION TTM_GetDelayTime( hWnd, nFlag ) -> nDuration */
{
   hb_retni( SendMessage( HWNDparam( 1 ), TTM_GETDELAYTIME, (WPARAM) ( HB_ISNUM( 2 ) ? hb_parni( 2 ) : TTDT_AUTOPOP ), 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GETINITIALTIME )          /* FUNCTION GetInitialTime( hWnd ) -> nDuration */
{
   hb_retni( SendMessage( HWNDparam( 1 ), TTM_GETDELAYTIME, (WPARAM) TTDT_INITIAL, 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GETAUTOPOPTIME )          /* FUNCTION GetAutoPopTime( hWnd ) -> nDuration */
{
   hb_retni( SendMessage( HWNDparam( 1 ), TTM_GETDELAYTIME, (WPARAM) TTDT_AUTOPOP, 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GETRESHOWTIME )          /* FUNCTION GetShowTime( hWnd ) -> nDuration */
{
   hb_retni( SendMessage( HWNDparam( 1 ), TTM_GETDELAYTIME, (WPARAM) TTDT_RESHOW, 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( SETINITIALTIME )          /* FUNCTION SetInitialTime( hWnd, nDuration ) -> NIL */
{
   SendMessage( HWNDparam( 1 ), TTM_SETDELAYTIME, (WPARAM) TTDT_INITIAL, (LPARAM) MAKELONG( hb_parni( 2 ), 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( SETAUTOPOPTIME )          /* FUNCTION SetAutoPopTime( hWnd, nDuration ) -> NIL */
{
   SendMessage( HWNDparam( 1 ), TTM_SETDELAYTIME, (WPARAM) TTDT_AUTOPOP, (LPARAM) MAKELONG( hb_parni( 2 ), 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( SETRESHOWTIME )          /* FUNCTION SetReshowTime( hWnd, nDuration ) -> NIL */
{
   SendMessage( HWNDparam( 1 ), TTM_SETDELAYTIME, (WPARAM) TTDT_RESHOW, (LPARAM) MAKELONG( hb_parni( 2 ), 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( SETDELAYTIME )          /* FUNCTION SetDelayTime( hWnd, nDuration ) -> NIL */
{
   SendMessage( HWNDparam( 1 ), TTM_SETDELAYTIME, (WPARAM) TTDT_AUTOMATIC, (LPARAM) MAKELONG( hb_parni( 2 ), 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GETDOUBLECLICKTIME )          /* FUNCTION GetDoubleClickTime() -> nTime */
{
   hb_retni( GetDoubleClickTime() );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TTOOLTIP_GETICON )          /* FUNCTION TToolTip_GetIcon( hWnd ) -> nIcon */
{
   TTGETTITLE gt;

   memset( &gt, 0, sizeof( gt ) );
   gt.dwSize = sizeof( gt );

   SendMessage( HWNDparam( 1 ), TTM_GETTITLE, (WPARAM) 0, (LPARAM) &gt );

   hb_retni( (int) gt.uTitleBitmap );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TTOOLTIP_SETICONANDTITLE )          /* FUNCTION TToolTip_SetIconAndTitle( hWnd, nIcon, cTitle ) -> lSuccess */
{
   if( HB_PARNL( 2 ) > TTI_ERROR )
   {
      hb_retl( SendMessage( HWNDparam( 1 ), TTM_SETTITLE, (WPARAM) HICONparam( 2 ), (LPARAM) HB_UNCONST( hb_parc( 3 ) ) ) );
   }
   else
   {
      hb_retl( SendMessage( HWNDparam( 1 ), TTM_SETTITLE, (WPARAM) HB_PARNL( 2 ), (LPARAM) HB_UNCONST( hb_parc( 3 ) ) ) );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( SHOWBALLOONTIP )          /* FUNCTION ShowBalloonTip( hWnd, cText, cTitle, nTypeIcon ) -> NIL */
{
   WCHAR Text[ 512 ];
   WCHAR Title[ 512 ];
   EDITBALLOONTIP bl;
   const char * s;
   int i, k;

#ifdef __XHARBOUR__
   PHB_CODEPAGE s_cdpHost = hb_cdppage();
#else
   PHB_CODEPAGE s_cdpHost = hb_vmCDP();
#endif

   HWND hWnd = HWNDparam( 1 );

   bl.cbStruct = sizeof( EDITBALLOONTIP );
   bl.pszTitle = NULL;
   bl.pszText  = NULL;
   bl.ttiIcon  = HB_ISNUM( 4 ) ? hb_parni( 4 ) : TTI_NONE;

   if( HB_ISCHAR( 2 ) )
   {
      ZeroMemory( Text, sizeof( Text ) );
      k = (int) hb_parclen( 2 );
      s = (const char *) hb_parc( 2 );
#ifdef __XHARBOUR__
      for( i = 0; i < k; i++ )
         Text[ i ] = hb_cdpGetU16( s_cdpHost, TRUE, s[ i ] );
#else
      for( i = 0; i < k; i++ )
         Text[ i ] = hb_cdpGetU16( s_cdpHost, s[ i ] );
#endif
      bl.pszText = Text;
   }

   if( HB_ISCHAR( 3 ) )
   {
      ZeroMemory( Title, sizeof( Title ) );
      k = (int) hb_parclen( 3 );
      s = (const char *) hb_parc( 3 );
#ifdef __XHARBOUR__
      for( i = 0; i < k; i++ )
         Title[ i ] = hb_cdpGetU16( s_cdpHost, TRUE, s[ i ] );
#else
      for( i = 0; i < k; i++ )
         Title[ i ] = hb_cdpGetU16( s_cdpHost, s[ i ] );
#endif
      bl.pszTitle = Title;
   }

   Edit_ShowBalloonTip( hWnd, &bl );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( HIDEBALLOONTIP )          /* FUNCTION HideBalloonTip( hWnd ) -> NIL */
{
   Edit_HideBalloonTip( HWNDparam( 1 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _SETTOOLTIPMAXWIDTH )          /* FUNCTION _SetToolTipMaxWidth( nWidth ) -> nWidth */
{
   int nOldMaxWidth;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );

   nOldMaxWidth = _OOHG_ToolTipMaxWidth;
   if( HB_ISNUM( 1 ) )
   {
      _OOHG_ToolTipMaxWidth = hb_parni( 1 );
   }

   ReleaseMutex( _OOHG_GlobalMutex() );

   hb_retni( nOldMaxWidth );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
BOOL Array2Rect( PHB_ITEM aRect, RECT *rc )
{
   if( HB_IS_ARRAY( aRect ) && hb_arrayLen( aRect ) == 4 )
   {
      rc->left   = hb_arrayGetNI( aRect, 1 );
      rc->top    = hb_arrayGetNI( aRect, 2 );
      rc->right  = hb_arrayGetNI( aRect, 3 );
      rc->bottom = hb_arrayGetNI( aRect, 4 );

      return TRUE;
   }

   return FALSE;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
BOOL Array2Point( PHB_ITEM aPoint, POINT *pt )
{
   if( HB_IS_ARRAY( aPoint ) && hb_arrayLen( aPoint ) == 2 )
   {
      pt->x = hb_arrayGetNI( aPoint, 1 );
      pt->y = hb_arrayGetNI( aPoint, 2 );

      return TRUE;
   }

   return FALSE;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_EXPORT PHB_ITEM Rect2Array( RECT *rc )
{
   PHB_ITEM aRect = hb_itemArrayNew( 4 );

   HB_ARRAYSETNL( aRect, 1, rc->left );
   HB_ARRAYSETNL( aRect, 2, rc->top );
   HB_ARRAYSETNL( aRect, 3, rc->right );
   HB_ARRAYSETNL( aRect, 4, rc->bottom );

   return aRect;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_EXPORT PHB_ITEM Point2Array( POINT *pt )
{
   PHB_ITEM aPoint = hb_itemArrayNew( 2 );

   HB_ARRAYSETNL( aPoint, 1, pt->x );
   HB_ARRAYSETNL( aPoint, 2, pt->y );

   return aPoint;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
BOOL Array2ColorRef( PHB_ITEM aCRef, COLORREF *cr )
{
   if( HB_IS_ARRAY( aCRef ) && hb_arrayLen( aCRef ) == 3 )
   {
      USHORT r, g, b;

      r = (USHORT) HB_ARRAYGETNL( aCRef, 1 );
      g = (USHORT) HB_ARRAYGETNL( aCRef, 2 );
      b = (USHORT) HB_ARRAYGETNL( aCRef, 3 );

      *cr = RGB( r, g, b );

      return TRUE;
   }

   return FALSE;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( INITTOOLTIPEX )          /* FUNCTION InitToolTipEx( hWnd, aRect, cToolTip, cTitle, nIcon, nStyle, nFlags ) -> hWnd */
{
   HWND hwndParent = HWNDparam( 1 );
   PHB_ITEM aRect = hb_param( 2, HB_IT_ANY );
   RECT rect;
   LPTSTR lpszText = (LPTSTR) NULL;
   LPTSTR lpszTitle = (LPTSTR) ( HB_ISCHAR( 4 ) ? HB_UNCONST( hb_parc( 4 ) ) : NULL );
   int nIcon = HB_ISNUM( 5 ) ? hb_parni( 5 ) : TTI_NONE;
   DWORD dwStyle = WS_POPUP;
   HWND hwndToolTip;
   TOOLINFO ti;
   UINT uFlags = 0;
   INITCOMMONCONTROLSEX i;

   i.dwSize = sizeof( INITCOMMONCONTROLSEX );
   i.dwICC = ICC_BAR_CLASSES;
   InitCommonControlsEx( &i );

   if( ! Array2Rect( aRect, &rect ) )
   {
      GetClientRect( hwndParent, &rect );
   }

   if( hb_parclen( 3 ) > 0 )
   {
      lpszText = (LPTSTR) HB_UNCONST( hb_parc( 3 ) );
   }
   else if( HB_ISNUM( 3 ) )
   {
      lpszText = (LPTSTR) MAKEINTRESOURCE( hb_parni( 3 ) );
   }

   if( HB_ISNUM( 6 ) )
   {
      dwStyle |= (DWORD) hb_parnl( 6 );
   }

   if( HB_ISNUM( 7 ) )
   {
      uFlags = (UINT) hb_parni( 7 );
   }

   /* Create a tooltip */
   hwndToolTip = CreateWindowEx( WS_EX_TOPMOST, TOOLTIPS_CLASS, "", dwStyle,
                                 0, 0, 0, 0,
                                 hwndParent, NULL, GetModuleHandle( NULL ), NULL );

   SetWindowPos( hwndToolTip, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE | SWP_NOACTIVATE );

   /* Set up "tool" information. In this case, the "tool" is the entire parent window. */
   memset( &ti, 0, sizeof( ti ) );
   ti.cbSize   = sizeof( ti );
   ti.uFlags   = uFlags;
   ti.hwnd     = hwndParent;
   ti.uId      = (UINT_PTR) hwndParent;
   ti.rect     = rect;
   ti.hinst    = GetModuleHandle( NULL );
   ti.lpszText = lpszText;

   // Associate the tooltip with the "tool" window.
   SendMessage( hwndToolTip, TTM_ADDTOOL, 0, (LPARAM) (LPTOOLINFO) &ti );

   if( NULL != lpszTitle )
   {
      SendMessage( hwndToolTip, TTM_SETTITLE, nIcon, (LPARAM) lpszTitle );
   }

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );

   if( _OOHG_ToolTipMaxWidth != -1 )
   {
      SendMessage( hwndToolTip, TTM_SETMAXTIPWIDTH, 0, (LPARAM) _OOHG_ToolTipMaxWidth );
   }

   SendMessage( hwndToolTip, TTM_ACTIVATE, (WPARAM) _OOHG_ToolTipActivate, 0 );

   ReleaseMutex( _OOHG_GlobalMutex() );

   _OOHG_TToolTip_lpfnOldWndProc( SetWindowLongPtr( hwndToolTip, GWLP_WNDPROC, (LONG_PTR) SubClassFunc ) );


   HWNDret( hwndToolTip );
}

/*
 * Retrieves  the  top,  left,  bottom, and right margins set for a tooltip
 * window.  A margin is the distance, in pixels, between the tooltip window
 * border and the text contained within the tooltip window.
 */
/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TTM_GETMARGIN )          /* FUNCTION TTM_GetMargin( hWnd ) -> aRect */
{
   RECT rect;

   SendMessage( HWNDparam( 1 ), TTM_GETMARGIN, 0, (LPARAM) &rect );

   hb_itemReturnRelease( Rect2Array( &rect ) );
}

/*
 * Retrieves the maximum width for a tooltip window.
 */
/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TTM_GETMAXTIPWIDTH )          /* FUNCTION TTM_GetMaxTipWidth( hWnd ) -> nWidth */
{
   hb_retni( (int) SendMessage( HWNDparam( 1 ), TTM_GETMAXTIPWIDTH, 0, 0 ) );
}

/*
 * Retrieves the background color in a tooltip window.
 */
/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TTM_GETTIPBKCOLOR )          /* FUNCTION TTM_GetTipBkColor( hWnd ) -> nColor */
{
   hb_retni( (int) SendMessage( HWNDparam( 1 ), TTM_GETTIPBKCOLOR, 0, 0 ) );
}

/*
 * Retrieves the text color in a tooltip window.
 */
/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TTM_GETTIPTEXTCOLOR )          /* FUNCTION TTM_GetTipTextColor( hWnd ) -> nColor */
{
   hb_retni( (int) SendMessage( HWNDparam( 1 ), TTM_GETTIPTEXTCOLOR, 0, 0 ) );
}

/*
 * Retrieves a count of the tools maintained by a tooltip control.
 */
/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TTM_GETTOOLCOUNT )          /* FUNCTION TTM_GetToolCount( hWnd ) -> nCount */
{
   hb_retni( (int) SendMessage( HWNDparam( 1 ), TTM_GETTOOLCOUNT, 0, 0 ) );
}

/*
 * Removes a displayed tooltip window from view.
 */
/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TTM_POP )          /* FUNCTION TTM_Pop( hWnd ) -> NIL */
{
   SendMessage( HWNDparam( 1 ), TTM_POP, (WPARAM) 0, (LPARAM) 0 );
}

/*
 * Causes the tooltip to display at the coordinates of the last mouse message.
 */
/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TTM_POPUP )          /* FUNCTION TTM_PopUp( hWnd ) -> NIL */
{
   SendMessage( HWNDparam( 1 ), TTM_POPUP, 0, 0 );
}

/*
 * Sets the initial, pop-up, and reshow durations for a tooltip control.
 */
/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TTM_SETDELAYTIME )          /* FUNCTION TTM_SetDelayTime( hWnd, nFlag, nTime ) -> NIL */
{
   int nMilliSec;

   if( ! HB_ISNUM( 3 ) )
   {
      nMilliSec = -1;
   }
   else if( hb_parni( 3 ) < 0 )
   {
      nMilliSec = -1;
   }
   else
   {
      nMilliSec = hb_parni( 3 );
   }

   SendMessage( HWNDparam( 1 ), TTM_SETDELAYTIME, ( HB_ISNUM( 2 ) ? hb_parni( 2 ) : TTDT_AUTOPOP ), (LPARAM) (DWORD) nMilliSec );
}

/*
 * Sets  the  top,  left, bottom, and right margins for a tooltip window.
 * A margin is the distance, in pixels, between the tooltip window border
 * and the text contained within the tooltip window.
 */
/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TTM_SETMARGIN )          /* FUNCTION TTM_SetMargin( hWnd, aRect ) -> NIL */
{
   RECT rect;

   if( Array2Rect( hb_param( 2, HB_IT_ANY ), &rect ) )
   {
      SendMessage( HWNDparam( 1 ), TTM_SETMARGIN, 0, (LPARAM) &rect );
   }
}

/*
 * Sets the maximum width for a tooltip window.
 */
/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TTM_SETMAXTIPWIDTH )          /* FUNCTION TTM_SetMaxTipWidth( hWnd, nWidth ) -> nWidth */
{
   hb_retni( (int) SendMessage( HWNDparam( 1 ), TTM_SETMAXTIPWIDTH, 0, (LPARAM) ( HB_ISNUM( 2 ) ? hb_parni( 2 ) : _OOHG_ToolTipMaxWidth ) ) );
}

/*
 * Sets the background color in a tooltip window.
 */
/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TTM_SETTIPBKCOLOR )          /* FUNCTION TTM_SetTipBkColor( hWnd, uColor ) -> NIL */
{
   COLORREF cr = (COLORREF) 0;

   if( HB_ISNUM( 2 ) || Array2ColorRef( hb_param( 2, HB_IT_ARRAY ), &cr ) )
   {
      if( HB_ISNUM( 2 ) )
      {
         cr = (COLORREF) HB_PARNL( 2 );
      }

      SendMessage( HWNDparam( 1 ), TTM_SETTIPBKCOLOR, (WPARAM) cr, 0 );
   }
}

/*
 * Sets the text color in a tooltip window.
 */
/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TTM_SETTIPTEXTCOLOR )          /* FUNCTION TTM_SetTipTextColor( hWnd, uColor ) -> NIL */
{
   COLORREF cr = (COLORREF) 0;

   if( HB_ISNUM( 2 ) || Array2ColorRef( hb_param( 2, HB_IT_ANY ), &cr ) )
   {
      if( HB_ISNUM( 2 ) )
      {
         cr = (COLORREF) HB_PARNL( 2 );
      }

      SendMessage( HWNDparam( 1 ), TTM_SETTIPTEXTCOLOR, (WPARAM) cr, 0 );
   }
}

/*
 * Activates or deactivates a tracking tooltip.
 */
/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TTM_TRACKACTIVATE )          /* FUNCTION TTM_TrackActivate( hWnd, hWnd ) -> NIL */
{
   HWND hwndTool = HWNDparam( 2 );
   TOOLINFO ti;

   memset( &ti, 0, sizeof( ti ) );
   ti.cbSize = sizeof( ti );
   ti.hwnd   = hwndTool;
   ti.uId    = (UINT_PTR) hwndTool;

   SendMessage( HWNDparam( 1 ), TTM_TRACKACTIVATE, (WPARAM) hb_parl( 3 ), (LPARAM) (LPTOOLINFO) &ti );
}

/*
 * Sets the position of a tracking tooltip.
 */
/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TTM_TRACKPOSITION )          /* FUNCTION TTM_TrackPosition( hWnd, hWnd, aPoint ) -> NIL */
{
   POINT point;

   if( Array2Point( hb_param( 3, HB_IT_ARRAY ), &point ) )
   {
      ClientToScreen( HWNDparam( 2 ), &point );

      SendMessage( HWNDparam( 1 ), TTM_TRACKPOSITION, 0, (LPARAM) MAKELONG( point.x, point.y ) );
   }
}

/*
 * Forces the current tooltip to be redrawn.
 */
/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TTM_UPDATE )          /* FUNCTION TTM_Update( hWnd ) -> NIL */
{
   SendMessage( HWNDparam( 1 ), TTM_UPDATE, 0, 0 );
}

/*
 * Sets the tooltip text for a tool.
 */
/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TTM_UPDATETIPTEXT )          /* FUNCTION TTM_UpdateTipText( hWnd, hWnd, cText ) -> NIL */
{
   HWND hwndTool = HWNDparam( 2 );
   TOOLINFO ti;

   if( hb_parclen( 3 ) > 0 )
   {
      memset( &ti, 0, sizeof( ti ) );
      ti.cbSize   = sizeof( ti );
      ti.hinst    = (HINSTANCE) 0;
      ti.hwnd     = hwndTool;
      ti.uId      = (UINT_PTR) hwndTool;
      ti.lpszText = (LPTSTR) HB_UNCONST( hb_parc( 3 ) );

      SendMessage( HWNDparam( 1 ), TTM_UPDATETIPTEXT, 0, (LPARAM) (LPTOOLINFO) &ti );
   }
}

/*
 * Allows a subclass procedure to cause a tooltip to display text for a
   window other than the one beneath the mouse cursor.
 */
/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TTM_WINDOWFROMPOINT )          /* FUNCTION TTM_WindowFromPoint( hWnd, hWnd, aPoint ) -> hWnd */
{
   POINT point;

   if( Array2Point( hb_param( 3, HB_IT_ARRAY ), &point ) )
   {
      ClientToScreen( HWNDparam( 2 ), &point );

      HWNDret( SendMessage( HWNDparam( 1 ), TTM_WINDOWFROMPOINT, 0, (LPARAM) MAKELONG( point.x, point.y  ) ) );
   }
}

#ifndef __XHARBOUR__
#include "hbwinuni.h"
#else
typedef wchar_t HB_WCHAR;
#endif

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GETCUEBANNERTEXT )
{
   HB_WCHAR *lpWCStr = (HB_WCHAR *) hb_xgrab( 256 * sizeof( HB_WCHAR ) );

   if( SendMessage( HWNDparam( 1 ), EM_GETCUEBANNER, (WPARAM) (LPWSTR) lpWCStr, (LPARAM) 256 ) )
   {
   #ifdef __XHARBOUR__
      hb_retc( (const char *) hb_wctomb( lpWCStr ) );
   #else
      hb_retstrlen_u16( HB_CDP_ENDIAN_NATIVE, lpWCStr, 256 );
   #endif
   }
   else
   {
      hb_retc_null();
   }

   hb_xfree( lpWCStr );
}

/* TODO:

   TTM_GETTEXT
   retrieves the information a tooltip control maintains about a tool

   TTM_HITTEST
   tests  a  point to determine whether it is within the bounding rectangle
   of  the  specified  tool  and, if it is, retrieves information about the
   tool

   TTM_NEWTOOLRECT
   sets a new bounding rectangle for a tool

   TTM_RELAYEVENT
   passes a mouse message to a tooltip control for processing

   TTM_ADDTOOL
   registers a tool with a tooltip control

   TTM_ADJUSTRECT
   calculates   a   tooltip  control's  text  display  rectangle  from  its
   window  rectangle,    or   the   tooltip   window  rectangle  needed  to
   display a specified text display rectangle.

   TTM_DELTOOL
   removes a tool from a tooltip control

   TTM_ENUMTOOLS
   retrieves  the  information  that  a tooltip control maintains about the
   current  tool—that  is,  the  tool  for  which  the tooltip is currently
   displaying text.

   TTM_GETBUBBLESIZE
   returns the width and height of a tooltip control

   TTM_GETCURRENTTOOL
   retrieves the information for the current tool in a tooltip control

   TTM_SETTOOLINFO
   sets the information that a tooltip control maintains for a tool

   TTM_SETWINDOWTHEME
   sets the visual style of a tooltip control
 */

#pragma ENDDUMP
