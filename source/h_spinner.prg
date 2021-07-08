/*
 * $Id: h_spinner.prg $
 */
/*
 * ooHG source code:
 * Spinner control
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

CLASS TSpinner FROM TControl

   DATA cCue                      INIT ""
   DATA lBoundText                INIT .F.
   DATA nHeight                   INIT 24
   DATA nIncrement                INIT 1
   DATA nRangeMax                 INIT 100
   DATA nRangeMin                 INIT 1
   DATA nWidth                    INIT 120
   DATA Type                      INIT "SPINNER" READONLY

   METHOD CueBanner               SETGET
   METHOD Define
   METHOD Enabled                 SETGET
   METHOD Events_Command
   METHOD ForceHide               BLOCK { |Self| HideWindow( ::AuxHandle ) , ::Super:ForceHide() }
   METHOD Increment               SETGET
   METHOD RangeMax                SETGET
   METHOD RangeMin                SETGET
   METHOD Release
   METHOD SizePos
   METHOD Value                   SETGET
   METHOD Visible                 SETGET

   ENDCLASS

METHOD Define( cControlName, uParentForm, nCol, nRow, nWidth, nValue, cFontname, nFontsize, ;
               nMin, nMax, cTooltip, bChange, bLostFocus, bGotFocus, nHeight, nHelpId, ;
               lInvisible, lNoTabStop, lBold, lItalic, lUnderline, lStrikeout, ;
               lWrap, lReadonly, nIncrement, uBackColor, uFontColor, lRtl, ;
               lNoBorder, lDisabled, lBndTxt, cCue ) CLASS TSpinner

   LOCAL nStyle, nStyleEx, nControlHandle

   ASSIGN ::nWidth       VALUE nWidth     TYPE "N"
   ASSIGN ::nHeight      VALUE nHeight    TYPE "N"
   ASSIGN ::nRow         VALUE nRow       TYPE "N"
   ASSIGN ::nCol         VALUE nCol       TYPE "N"
   ASSIGN ::nRangeMin    VALUE nMin       TYPE "N"
   ASSIGN ::nRangeMax    VALUE nMax       TYPE "N"
   ASSIGN ::nIncrement   VALUE nIncrement TYPE "N"
   ASSIGN cCue           VALUE cCue       TYPE "C" DEFAULT ""
   ASSIGN ::lBoundText   VALUE lBndTxt    TYPE "L"
   ASSIGN lWrap          VALUE lWrap      TYPE "L" DEFAULT .F.
   ASSIGN lReadonly      VALUE lReadonly  TYPE "L" DEFAULT .F.
   ASSIGN lNoBorder      VALUE lNoborder  TYPE "L" DEFAULT .F.
   ASSIGN lInvisible     VALUE lInvisible TYPE "L" DEFAULT .F.
   ASSIGN nValue         VALUE nValue     TYPE "N" DEFAULT ::nRangeMin

   ::SetForm( cControlName, uParentForm, cFontName, nFontSize, uFontColor, uBackColor, .T., lRtl )

   nStyle := ::InitStyle( NIL, NIL, lInvisible, lNoTabStop, lDisabled ) + ;
             iif( lReadonly, ES_READONLY, 0 ) + ES_NUMBER + ES_AUTOHSCROLL

   nStyleEx := iif( lNoBorder, 0, WS_EX_CLIENTEDGE )

   nControlHandle := InitTextBox( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::nWidth, ::nHeight, nStyle, 0, ::lRtl, nStyleEx )

   ::AuxHandle := InitSpinner( ::ContainerhWnd, 0, ::ContainerCol + ::nWidth, ::ContainerRow, 15, ::nHeight, ::nRangeMin, ::nRangeMax, lInvisible, lWrap, nControlHandle, ::lRtl )

   ::Register( nControlHandle, cControlName, nHelpId, NIL, cToolTip )
   ::SetFont( NIL, NIL, lBold, lItalic, lUnderline, lStrikeout )

   IF ::nIncrement <> 1
      ::Increment := ::nIncrement
   ENDIF

   IF ! Empty( cCue )
      ::CueBanner := cCue
   ENDIF

   ::Value := nValue

   ASSIGN ::OnLostFocus VALUE bLostFocus TYPE "B"
   ASSIGN ::OnGotFocus  VALUE bGotFocus  TYPE "B"
   ASSIGN ::OnChange    VALUE bChange    TYPE "B"

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD CueBanner( cCue ) CLASS TSpinner

   IF HB_ISSTRING( cCue )
      SendMessageWideString( ::hWnd, EM_SETCUEBANNER, .T., cCue )
      ::cCue := cCue
   ENDIF

   RETURN ::cCue

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Release CLASS TSpinner

   DestroyWindow( ::AuxHandle )

   RETURN ::Super:Release()

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SizePos( nRow, nCol, nWidth, nHeight ) CLASS TSpinner

   LOCAL uRet

   uRet := ::Super:SizePos( nRow, nCol, nWidth, nHeight )
   MoveWindow( ::hWnd, ::ContainerCol, ::ContainerRow, ::Width - 15, ::Height , .T. )
   MoveWindow( ::AuxHandle, ::ContainerCol + ::Width - 15, ::ContainerRow, 15, ::Height , .T. )

   RETURN uRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Visible( lVisible ) CLASS TSpinner

   IF HB_ISLOGICAL( lVisible )
      ::Super:Visible := lVisible
      IF lVisible .AND. ::ContainerVisible
         CShowControl( ::AuxHandle )
      ELSE
         HideWindow( ::AuxHandle )
      ENDIF
   ENDIF

   RETURN ::lVisible

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value( nValue ) CLASS TSpinner

   IF HB_ISNUMERIC( nValue )
      SetSpinnerValue( ::AuxHandle, nValue )
      ::DoChange()
   ENDIF

   RETURN GetSpinnerValue( ::AuxHandle )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Events_Command( wParam ) CLASS TSpinner

   LOCAL Hi_wParam := HIWORD( wParam ), cValue

   IF Hi_wParam == EN_CHANGE
      IF ::lBoundText .AND. Val( ::Caption ) # ::Value
         cValue := LTrim( Str( ::Value ) )
         ::Caption := cValue
         SendMessage( ::hWnd, EM_SETSEL, Len( cValue ), Len( cValue ) )
      ENDIF
      ::DoChange()
      RETURN NIL
   ENDIF

   RETURN ::Super:Events_Command( wParam )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Enabled( lEnabled ) CLASS TSpinner

   IF HB_ISLOGICAL( lEnabled )
      ::Super:Enabled := lEnabled
      IF ::Super:Enabled
         EnableWindow( ::AuxHandle )
      ELSE
         DisableWindow( ::AuxHandle )
      ENDIF
   ENDIF

   RETURN ::Super:Enabled

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD RangeMin( nValue ) CLASS TSpinner

   IF HB_ISNUMERIC( nValue )
      ::nRangeMin := nValue
      SetSpinnerRange( ::AuxHandle, ::nRangeMin, ::nRangeMax )
   ENDIF

   RETURN ::nRangeMin

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD RangeMax( nValue ) CLASS TSpinner

   IF HB_ISNUMERIC( nValue )
      ::nRangeMax := nValue
      SetSpinnerRange( ::AuxHandle, ::nRangeMin, ::nRangeMax )
   ENDIF

   RETURN ::nRangeMax

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Increment( nValue ) CLASS TSpinner

   IF HB_ISNUMERIC( nValue )
      ::nIncrement := nValue
      SetSpinnerIncrement( ::AuxHandle, nValue )
   ENDIF

   RETURN ::nIncrement

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
static WNDPROC _OOHG_TSpinner_lpfnOldWndProc( LONG_PTR lp )
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
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, _OOHG_TSpinner_lpfnOldWndProc( 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( INITSPINNER )          /* FUNCTION InitSpinner( hWnd, hMenu, nCol, nRow, nWidth, nHeight, nMin, nMax, lInvisible, lWrap, hWndTextBox, lRtl ) -> hWnd */
{
   HWND hUpDown;
   int Style, StyleEx;
   INITCOMMONCONTROLSEX i;

   i.dwSize = sizeof( INITCOMMONCONTROLSEX );
   i.dwICC  = ICC_BAR_CLASSES;
   InitCommonControlsEx( &i );

   Style = WS_CHILD | WS_BORDER | UDS_ARROWKEYS | UDS_ALIGNRIGHT | UDS_SETBUDDYINT | UDS_NOTHOUSANDS;
   if( ! hb_parl( 9 ) )
   {
      Style = Style | WS_VISIBLE;
   }
   if( hb_parl( 10 ) )
   {
      Style = Style | UDS_WRAP;
   }
   StyleEx = WS_EX_CLIENTEDGE | _OOHG_RTL_Status( hb_parl( 12 ) );

   hUpDown = CreateWindowEx( StyleEx, UPDOWN_CLASS, "", Style,
                             hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ),
                             HWNDparam( 1 ), HMENUparam( 2 ), GetModuleHandle( NULL ), NULL );

   SendMessage( hUpDown, UDM_SETBUDDY, (WPARAM) HWNDparam( 11 ), (LPARAM) NULL );
   SendMessage( hUpDown, UDM_SETRANGE32, (WPARAM) hb_parni( 7 ), (LPARAM) hb_parni( 8 ) );

   _OOHG_TSpinner_lpfnOldWndProc( SetWindowLongPtr( hUpDown, GWLP_WNDPROC, (LONG_PTR) SubClassFunc ) );

   HWNDret( hUpDown );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( SETSPINNERRANGE )          /* FUNCTION SetSpinnerRange( hWndUpDown, nMin, nMax ) -> NIL */
{
   SendMessage( HWNDparam( 1 ), UDM_SETRANGE32, (WPARAM) hb_parni( 2 ), (LPARAM) hb_parni( 3 ) ) ;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( SETSPINNERINCREMENT )          /* FUNCTION SetSpinnerIncrement( hWndUpDown, nValue ) -> NIL */
{
   UDACCEL inc ;

   inc.nSec = 0;
   inc.nInc = hb_parnl( 2 );
   SendMessage ( HWNDparam( 1 ), UDM_SETACCEL, (WPARAM) 1 , (LPARAM) &inc ) ;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( SETSPINNERVALUE )          /* FUNCTION SetSpinnerValue( hWndUpDown, nValue ) -> NIL */
{
   SendMessage( HWNDparam( 1 ), (UINT) UDM_SETPOS32, (WPARAM) 0, (LPARAM) hb_parni( 2 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GETSPINNERVALUE )          /* FUNCTION GetSpinnerValue( hWndUpDown ) -> nValue */
{
   hb_retnl( SendMessage( HWNDparam( 1 ), (UINT) UDM_GETPOS32, (WPARAM) 0, (LPARAM) 0 ) );
}

#pragma ENDDUMP
