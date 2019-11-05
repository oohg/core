/*
 * $Id: h_progressbar.prg $
 */
/*
 * ooHG source code:
 * ProgressBar control
 *
 * Copyright 2005-2019 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2019 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2019 Contributors, https://harbour.github.io/
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
#include "common.ch"
#include "hbclass.ch"
#include "i_windefs.ch"

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TProgressBar FROM TControl

   DATA Type                      INIT "PROGRESSBAR" READONLY
   DATA lRunning                  INIT .F.
   DATA nRangeMax                 INIT 100
   DATA nRangeMin                 INIT 0
   DATA nVelocity                 INIT 30

   METHOD BackColor               SETGET
   METHOD Define
   METHOD FontColor               SETGET
   METHOD IsMarqueeRunning
   METHOD IsStyleMarquee
   METHOD IsStyleNormal
   METHOD RangeMax                SETGET
   METHOD RangeMin                SETGET
   METHOD SetStyleMarquee
   METHOD SetStyleNormal
   METHOD StartMarquee
   METHOD StopMarquee
   METHOD Value                   SETGET

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( cControlName, cParentForm, nCol, nRow, nWidth, nHeight, nMin, nMax, cToolTip, ;
      lVertical, lSmooth, nHelpId, lInvisible, nValue, uBackColor, uBarColor, lRtl, nVelocity ) CLASS TProgressBar

   LOCAL nControlHandle

   ASSIGN lVertical  VALUE lVertical  TYPE "L" DEFAULT .F.
   ASSIGN lSmooth    VALUE lSmooth    TYPE "L" DEFAULT .F.
   ASSIGN nHeight    VALUE nHeight    TYPE "N" DEFAULT iif( lVertical, 120, 25 )
   ASSIGN nWidth     VALUE nWidth     TYPE "N" DEFAULT iif( lVertical, 25, 120 )
   ASSIGN nMin       VALUE nMin       TYPE "N" DEFAULT 0
   ASSIGN nMax       VALUE nMax       TYPE "N" DEFAULT 100
   ASSIGN nValue     VALUE nValue     TYPE "N" DEFAULT 0
   ASSIGN lInvisible VALUE lInvisible TYPE "L" DEFAULT .F.

   ::SetForm( cControlName, cParentForm, , , uBarColor, uBackColor, , lRtl  )

   nControlHandle := InitProgressBar( ::ContainerhWnd, 0, nCol, nRow, nWidth, nHeight, nMin, nMax, lVertical, lSmooth, lInvisible, nValue, ::lRtl )

   ::Register( nControlHandle, cControlName, nHelpId, ! lInvisible, cToolTip )
   ::SizePos( nRow, nCol, nWidth, nHeight )

   ::nRangeMin := nMin
   ::nRangeMax := nMax

   IF ::BackColor <> NIL
      /* BackColor is ignored when visual styles are enabled. Use ::DisableVisualStyle() to disable them. */
      SetProgressBarBkColor( nControlHandle, ::BackColor[1], ::BackColor[2], ::BackColor[3] )
   ENDIF

   IF ::FontColor <> NIL
      /* FontColor is ignored when visual styles are enabled. Use ::DisableVisualStyle() to disable them. */
      SetProgressBarBkColor( nControlHandle, ::FontColor[1], ::FontColor[2], ::FontColor[3] )
   ENDIF

   IF HB_ISNUMERIC( nVelocity )
      ::nVelocity := nVelocity

      ::SetStyleMarquee( nVelocity )
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetStyleMarquee( nVelocity ) CLASS TProgressBar

   IF ! IsWindowStyle( ::hWnd, PBS_MARQUEE )
     ::Style( ::Style() + PBS_MARQUEE )
   ENDIF

   IF HB_ISNUMERIC( nVelocity ) .AND. nVelocity > 0
      ::nVelocity := nVelocity

      ::StartMarquee()
   ELSE
      ::StopMarquee()
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetStyleNormal( uValue ) CLASS TProgressBar

   IF IsWindowStyle( ::hWnd, PBS_MARQUEE )
      ::StopMarquee()

      ::Style( ::Style() - PBS_MARQUEE )

      IF ! HB_ISNUMERIC( uValue ) .OR. uValue < 0
        uValue := 0
      ENDIF

      ::value := uValue
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD IsStyleMarquee() CLASS TProgressBar

   RETURN IsWindowStyle( ::hWnd, PBS_MARQUEE )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD IsStyleNormal() CLASS TProgressBar

   RETURN ! IsWindowStyle( ::hWnd, PBS_MARQUEE )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD StartMarquee() CLASS TProgressBar

   IF IsWindowStyle( ::hWnd, PBS_MARQUEE )
      IF ! ::lRunning
         ::lRunning := .T.

         IF ::nVelocity <= 0
            ::nVelocity := 30
         ENDIF

         // 1 => start
         SendMessage( ::hWnd, PBM_SETMARQUEE, 1, ::nVelocity )
      ENDIF
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD StopMarquee() CLASS TProgressBar

   IF IsWindowStyle( ::hWnd, PBS_MARQUEE )
      IF ::lRunning
        ::lRunning := .F.

         IF ::nVelocity <= 0
            ::nVelocity := 30
         ENDIF

         /* 0 => stop */
         SendMessage( ::hWnd, PBM_SETMARQUEE, 0, ::nVelocity )
      ENDIF
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD IsMarqueeRunning() CLASS TProgressBar

   RETURN ::lRunning

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value( uValue ) CLASS TProgressBar

   IF HB_ISNUMERIC( uValue )
      SendMessage( ::hWnd, PBM_SETPOS, uValue, 0 )
   ENDIF

   RETURN SendMessage( ::hWnd, PBM_GETPOS, 0, 0)

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD RangeMin( uValue ) CLASS TProgressBar

   IF HB_ISNUMERIC( uValue )
      ::nRangeMin := uValue
      SetProgressBarRange( ::hWnd, uValue, ::nRangeMax )
   ENDIF

   RETURN ::nRangeMin

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD RangeMax( uValue ) CLASS TProgressBar

   IF HB_ISNUMERIC( uValue )
      ::nRangeMax := uValue
      SetProgressBarRange( ::hWnd, ::nRangeMin, uValue )
   ENDIF

   RETURN ::nRangeMax

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD FontColor( uValue ) CLASS TProgressBar

   IF HB_ISNUMERIC( uValue )
      ::Super:FontColor := uValue
      SetProgressBarBarColor( ::hWnd, ::FontColor[1], ::FontColor[2], ::FontColor[3] )
   ENDIF

   RETURN ::Super:FontColor

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BackColor( uValue ) CLASS TProgressBar

   IF HB_IsArray( uValue )
      ::Super:BackColor := uValue
      SetProgressBarBkColor( ::hWnd, ::BackColor[1], ::BackColor[2], ::BackColor[3] )
   ENDIF

   RETURN ::Super:BackColor

/*--------------------------------------------------------------------------------------------------------------------------------*/
#pragma BEGINDUMP

#include "oohg.h"
#include <shlobj.h>
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "winreg.h"
#include "tchar.h"

/*--------------------------------------------------------------------------------------------------------------------------------*/
static WNDPROC _OOHG_TProgressBar_lpfnOldWndProc( WNDPROC lp )
{
   static WNDPROC lpfnOldWndProc = 0;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( ! lpfnOldWndProc )
   {
      lpfnOldWndProc = lp;
   }
   ReleaseMutex( _OOHG_GlobalMutex() );

   return lpfnOldWndProc;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, _OOHG_TProgressBar_lpfnOldWndProc( 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( INITPROGRESSBAR )          /* FUNCTION InitProgressBar( ContainerhWnd, nStyle, nCol, nRow, nWidth, nHeight, nMin, nMax, lVertical, lSmooth, lInvisible, nValue, lRtl ) -> hWnd */
{
   HWND hCtrl;
   INT Style, StyleEx;
   INITCOMMONCONTROLSEX i;

   i.dwSize = sizeof( INITCOMMONCONTROLSEX );
   i.dwICC  = ICC_PROGRESS_CLASS;
   InitCommonControlsEx( &i );

   Style = WS_CHILD | hb_parni( 2 );
   if ( hb_parl( 9 ) )
   {
      Style = Style | PBS_VERTICAL;
   }
   if ( hb_parl( 10 ) )
   {
      Style = Style | PBS_SMOOTH;
   }
   if ( ! hb_parl( 11 ) )
   {
      Style = Style | WS_VISIBLE;
   }
   StyleEx = WS_EX_CLIENTEDGE | _OOHG_RTL_Status( hb_parl( 13 ) );

   hCtrl = CreateWindowEx( StyleEx, "msctls_progress32", 0, Style,
                           hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ),
                           HWNDparam( 1 ), HMENUparam( 2 ), GetModuleHandle( NULL ), NULL );

   SendMessage( hCtrl, PBM_SETRANGE, 0, ( WPARAM ) MAKELONG( hb_parni( 7 ), hb_parni( 8 ) ) );
   SendMessage( hCtrl, PBM_SETPOS, ( WPARAM ) hb_parni( 12 ), 0 );

   _OOHG_TProgressBar_lpfnOldWndProc( ( WNDPROC ) SetWindowLongPtr( hCtrl, GWL_WNDPROC, ( LONG_PTR ) SubClassFunc ) );

   HWNDret( hCtrl );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( SETPROGRESSBARRANGE )          /* FUNCTION SetProgressbarRange( hWnd, nMin, nMax ) -> NIL */
{
   SendMessage( HWNDparam( 1 ), PBM_SETRANGE, 0, MAKELONG( hb_parni( 2 ), hb_parni( 3 ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( SETPROGRESSBARBKCOLOR )          /* FUNCTION SetProgressbarBkColor( hWnd, nRed, nGreen, nBlue ) -> NIL */
{
   /* When visual styles are enabled this message has no effect */
   SendMessage( HWNDparam( 1 ), PBM_SETBKCOLOR, 0, RGB( hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( SETPROGRESSBARBARCOLOR )          /* FUNCTION SetProgressbarBarColor( hWnd, nRed, nGreen, nBlue ) -> NIL */
{
   /* When visual styles are enabled this message has no effect */
   SendMessage( HWNDparam( 1 ), PBM_SETBARCOLOR, 0, RGB( hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ) ) );
}

#pragma ENDDUMP
