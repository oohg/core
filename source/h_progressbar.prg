/*
 * $Id: h_progressbar.prg $
 */
/*
 * ooHG source code:
 * ProgressBar control
 *
 * Copyright 2005-2021 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2021 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2021 Contributors, https://harbour.github.io/
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
   DATA Smooth                    INIT .F.
   DATA Vertical                  INIT .F.

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

   MESSAGE ForeColor              METHOD FontColor
   MESSAGE BarColor               METHOD FontColor

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( cControlName, cParentForm, nCol, nRow, nWidth, nHeight, nMin, nMax, cToolTip, ;
      lVertical, lSmooth, nHelpId, lInvisible, nValue, uBackColor, uBarColor, lRtl, nVelocity ) CLASS TProgressBar

   LOCAL nControlHandle

   ASSIGN ::Vertical VALUE lVertical  TYPE "L" DEFAULT .F.
   ASSIGN ::Smooth   VALUE lSmooth    TYPE "L" DEFAULT .F.
   ASSIGN nHeight    VALUE nHeight    TYPE "N" DEFAULT iif( lVertical, 120, 25 )
   ASSIGN nWidth     VALUE nWidth     TYPE "N" DEFAULT iif( lVertical, 25, 120 )
   ASSIGN nMin       VALUE nMin       TYPE "N" DEFAULT 0
   ASSIGN nMax       VALUE nMax       TYPE "N" DEFAULT 100
   ASSIGN nValue     VALUE nValue     TYPE "N" DEFAULT 0
   ASSIGN lInvisible VALUE lInvisible TYPE "L" DEFAULT .F.

   ::SetForm( cControlName, cParentForm, NIL, NIL, NIL, NIL, NIL, lRtl  )

   nControlHandle := InitProgressBar( ::ContainerhWnd, 0, nCol, nRow, nWidth, nHeight, nMin, nMax, lVertical, lSmooth, lInvisible, nValue, ::lRtl )

   ::Register( nControlHandle, cControlName, nHelpId, ! lInvisible, cToolTip )
   ::SizePos( nRow, nCol, nWidth, nHeight )

   ::nRangeMin := nMin
   ::nRangeMax := nMax

   IF uBackColor <> NIL
      ::BackColor := uBackColor
   ENDIF

   IF uBarColor <> NIL
      ::FontColor := uBarColor
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

   LOCAL nColor

   IF PCount() > 0
      nColor := ::Super:FontColor( uValue )
      IF nColor # NIL
         /* To change FontColor we must disable control's visual style.
          * Change can't be reverted.
          * You must release the control and recreate it.
          * See FUNCTION TProgressBar_EnableVisualStyle.
          */
         ::DisableVisualStyle()
         SetProgressBarBarColor( ::hWnd, nColor[1], nColor[2], nColor[3] )
      ENDIF
   ELSE
      nColor := ::Super:FontColor()
   ENDIF

   RETURN nColor

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BackColor( uValue ) CLASS TProgressBar

   LOCAL nColor

   IF PCount() > 0
      nColor := ::Super:BackColor( uValue )
      IF nColor # NIL
         /* To change BackColor we must disable control's visual style.
          * Change can't be reverted.
          * You must release the control and recreate it.
          * See FUNCTION TProgressBar_EnableVisualStyle.
          */
         ::DisableVisualStyle()
         SetProgressBarBkColor( ::hWnd, nColor[1], nColor[2], nColor[3] )
      ENDIF
   ELSE
      nColor := ::Super:BackColor()
   ENDIF

   RETURN nColor

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION TProgressBar_EnableVisualStyle( oCtrl )

   LOCAL aData

   WITH OBJECT oCtrl
      aData := { :Name, :Parent:Name, :Col, :Row, :Width, :Height, :nRangeMin, :nRangeMax, ;
         { :ToolTip, :ToolTipTitle, :ToolTipIcon }, :Vertical, :Smooth, :HelpId, ! :Visible, :Value, :Rtl, :nVelocity }
      :Release()
   END WITH
   oCtrl := NIL

   RETURN TProgressBar():Define( aData[01], aData[02], aData[03], aData[04], aData[05], aData[06], aData[07], aData[08], ;
      aData[09], aData[10], aData[11], aData[12], aData[13], aData[14], NIL, NIL, aData[15], aData[16] )

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
static WNDPROC _OOHG_TProgressBar_lpfnOldWndProc( LONG_PTR lp )
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
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, _OOHG_TProgressBar_lpfnOldWndProc( 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( INITPROGRESSBAR )          /* FUNCTION InitProgressBar( ContainerhWnd, nStyle, nCol, nRow, nWidth, nHeight, nMin, nMax, lVertical, lSmooth, lInvisible, nValue, lRtl ) -> hWnd */
{
   HWND hCtrl;
   int Style, StyleEx;
   INITCOMMONCONTROLSEX i;

   i.dwSize = sizeof( INITCOMMONCONTROLSEX );
   i.dwICC  = ICC_PROGRESS_CLASS;
   InitCommonControlsEx( &i );

   Style = WS_CHILD | hb_parni( 2 );
   if( hb_parl( 9 ) )
   {
      Style = Style | PBS_VERTICAL;
   }
   if( hb_parl( 10 ) )
   {
      Style = Style | PBS_SMOOTH;
   }
   if( ! hb_parl( 11 ) )
   {
      Style = Style | WS_VISIBLE;
   }
   StyleEx = WS_EX_CLIENTEDGE | _OOHG_RTL_Status( hb_parl( 13 ) );

   hCtrl = CreateWindowEx( StyleEx, "msctls_progress32", 0, Style,
                           hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ),
                           HWNDparam( 1 ), HMENUparam( 2 ), GetModuleHandle( NULL ), NULL );

   SendMessage( hCtrl, PBM_SETRANGE, 0, (WPARAM) MAKELONG( hb_parni( 7 ), hb_parni( 8 ) ) );
   SendMessage( hCtrl, PBM_SETPOS, (WPARAM) hb_parni( 12 ), 0 );

   _OOHG_TProgressBar_lpfnOldWndProc( SetWindowLongPtr( hCtrl, GWLP_WNDPROC, (LONG_PTR) SubClassFunc ) );

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

