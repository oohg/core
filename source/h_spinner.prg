/*
* $Id: h_spinner.prg $
*/
/*
* ooHG source code:
* Spinner control
* Copyright 2005-2017 Vicente Guerra <vicente@guerra.com.mx>
* https://oohg.github.io/
* Portions of this project are based upon Harbour MiniGUI library.
* Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
* Portions of this project are based upon Harbour GUI framework for Win32.
* Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
* Copyright 2001 Antonio Linares <alinares@fivetech.com>
* Portions of this project are based upon Harbour Project.
* Copyright 1999-2017, https://harbour.github.io/
*/
/*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2, or (at your option)
* any later version.
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
* You should have received a copy of the GNU General Public License
* along with this software; see the file LICENSE.txt. If not, write to
* the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1335,USA (or download from http://www.gnu.org/licenses/).
* As a special exception, the ooHG Project gives permission for
* additional uses of the text contained in its release of ooHG.
* The exception is that, if you link the ooHG libraries with other
* files to produce an executable, this does not by itself cause the
* resulting executable to be covered by the GNU General Public License.
* Your use of that executable is in no way restricted on account of
* linking the ooHG library code into it.
* This exception does not however invalidate any other reasons why
* the executable file might be covered by the GNU General Public License.
* This exception applies only to the code released by the ooHG
* Project under the name ooHG. If you copy code from other
* ooHG Project or Free Software Foundation releases into a copy of
* ooHG, as the General Public License permits, the exception does
* not apply to the code that you add in this way. To avoid misleading
* anyone as to the status of such modified files, you must delete
* this exception notice from them.
* If you write modifications of your own for ooHG, it is your choice
* whether to permit this exception to apply to your modifications.
* If you do not wish that, delete this exception notice.
*/

#include "oohg.ch"
#include "common.ch"
#include "hbclass.ch"
#include "i_windefs.ch"

CLASS TSpinner FROM TControl

   DATA Type      INIT "SPINNER" READONLY
   DATA nRangeMin   INIT 1
   DATA nRangeMax   INIT 100
   DATA nWidth      INIT 120
   DATA nHeight     INIT 24
   DATA nIncrement  INIT 1
   DATA lBoundText  INIT .F.

   METHOD Define
   METHOD SizePos
   METHOD Visible             SETGET
   METHOD Value               SETGET
   METHOD Enabled             SETGET
   METHOD ForceHide           BLOCK { |Self| HideWindow( ::AuxHandle ) , ::Super:ForceHide() }
   METHOD Release
   METHOD RangeMin            SETGET
   METHOD RangeMax            SETGET
   METHOD Increment           SETGET
   METHOD Events_Command

   ENDCLASS

METHOD Define( ControlName, ParentForm, x, y, w, value, fontname, fontsize, ;
      rl, rh, tooltip, change, lostfocus, gotfocus, h, HelpId, ;
      invisible, notabstop, bold, italic, underline, strikeout, ;
      wrap, readonly, increment, backcolor, fontcolor, lRtl, ;
      lNoBorder, lDisabled, lBndTxt ) CLASS TSpinner

   LOCAL nStyle := ES_NUMBER + ES_AUTOHSCROLL, nStyleEx := 0
   LOCAL ControlHandle

   ASSIGN ::nWidth       VALUE w         TYPE "N"
   ASSIGN ::nHeight      VALUE h         TYPE "N"
   ASSIGN ::nRow         VALUE y         TYPE "N"
   ASSIGN ::nCol         VALUE x         TYPE "N"
   ASSIGN ::nRangeMin    VALUE rl        TYPE "N"
   ASSIGN ::nRangeMax    VALUE rh        TYPE "N"
   ASSIGN ::nIncrement   VALUE increment TYPE "N"
   ASSIGN ::lBoundText   VALUE lBndTxt   TYPE "L"
   ASSIGN wrap           VALUE wrap      TYPE "L" DEFAULT .F.
   ASSIGN readonly       VALUE readonly  TYPE "L" DEFAULT .F.
   ASSIGN invisible      VALUE invisible TYPE "L" DEFAULT .F.
   DEFAULT value TO rl

   ::SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor, .T., lRtl )

   nStyle += ::InitStyle( ,, Invisible, NoTabStop, lDisabled ) + ;
      if(  HB_IsLogical ( readonly )  .AND.  readonly,  ES_READONLY, 0 )

   nStyleEx += IF( !HB_IsLogical( lNoBorder ) .OR. ! lNoBorder, WS_EX_CLIENTEDGE, 0 )

   ControlHandle := InitTextBox( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::nWidth, ::nHeight, nStyle, 0, ::lRtl, nStyleEx )

   ::AuxHandle := InitSpinner( ::ContainerhWnd, 0, ::ContainerCol + ::nWidth, ::ContainerRow, 15, ::nHeight, ::nRangeMin, ::nRangeMax, invisible, wrap, ControlHandle, ::lRtl )

   ::Register( ControlHandle, ControlName, HelpId,, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   ::Value := value

   IF ::nIncrement <> 1
      ::Increment := ::nIncrement
   ENDIF

   ASSIGN ::OnLostFocus VALUE lostfocus TYPE "B"
   ASSIGN ::OnGotFocus  VALUE gotfocus  TYPE "B"
   ASSIGN ::OnChange    VALUE Change    TYPE "B"

   RETURN Self

METHOD Release CLASS TSpinner

   DestroyWindow( ::AuxHandle )

   RETURN ::Super:Release()

METHOD SizePos( Row, Col, Width, Height ) CLASS TSpinner

   LOCAL uRet

   uRet := ::Super:SizePos( Row, Col, Width, Height )
   MoveWindow( ::hWnd, ::ContainerCol, ::ContainerRow, ::Width - 15, ::Height , .T. )
   MoveWindow( ::AuxHandle, ::ContainerCol + ::Width - 15, ::ContainerRow, 15, ::Height , .T. )

   RETURN uRet

METHOD Visible( lVisible ) CLASS TSpinner

   IF HB_IsLogical( lVisible )
      ::Super:Visible := lVisible
      IF lVisible .AND. ::ContainerVisible
         CShowControl( ::AuxHandle )
      ELSE
         HideWindow( ::AuxHandle )
      ENDIF
   ENDIF

   RETURN ::lVisible

METHOD Value( uValue ) CLASS TSpinner

   IF HB_IsNumeric ( uValue )
      SetSpinnerValue( ::AuxHandle, uValue )
      ::DoChange()
   ENDIF

   RETURN GetSpinnerValue( ::AuxHandle )

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

METHOD Enabled( lEnabled ) CLASS TSpinner

   IF HB_IsLogical( lEnabled )
      ::Super:Enabled := lEnabled
      IF ::Super:Enabled
         EnableWindow( ::AuxHandle )
      ELSE
         DisableWindow( ::AuxHandle )
      ENDIF
   ENDIF

   RETURN ::Super:Enabled

METHOD RangeMin( nValue ) CLASS TSpinner

   IF HB_IsNumeric( nValue )
      ::nRangeMin := nValue
      SetSpinnerRange( ::AuxHandle, ::nRangeMin, ::nRangeMax )
   ENDIF

   RETURN ::nRangeMin

METHOD RangeMax( nValue ) CLASS TSpinner

   IF HB_IsNumeric( nValue )
      ::nRangeMax := nValue
      SetSpinnerRange( ::AuxHandle, ::nRangeMin, ::nRangeMax )
   ENDIF

   RETURN ::nRangeMax

METHOD Increment( nValue ) CLASS TSpinner

   IF HB_IsNumeric( nValue )
      ::nIncrement := nValue
      SetSpinnerIncrement( ::AuxHandle, nValue )
   ENDIF

   RETURN ::nIncrement

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

#include <shlobj.h>
#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "winreg.h"
#include "tchar.h"
#include "oohg.h"

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{

   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

HB_FUNC( INITSPINNER )
{
   HWND hwnd;
   HWND hupdown;
   int Style2 = WS_CHILD | WS_BORDER | UDS_ARROWKEYS | UDS_ALIGNRIGHT | UDS_SETBUDDYINT | UDS_NOTHOUSANDS;
   INITCOMMONCONTROLSEX  i;
   int StyleEx;

   StyleEx = WS_EX_CLIENTEDGE | _OOHG_RTL_Status( hb_parl( 12 ) );

   i.dwSize = sizeof(INITCOMMONCONTROLSEX);
   InitCommonControlsEx(&i);

   hwnd = HWNDparam( 1 );

   if( ! hb_parl( 9 ) )
   {
      Style2 = Style2 | WS_VISIBLE;
   }

   if( hb_parl( 10 ) )
   {
      Style2 = Style2 | UDS_WRAP;
   }

   hupdown = CreateWindowEx( StyleEx, UPDOWN_CLASS, "", Style2,
                             hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ),
                             hwnd, ( HMENU ) 0, GetModuleHandle( NULL ), NULL );

   SendMessage ( hupdown, UDM_SETBUDDY, ( WPARAM ) hb_parnl( 11 ), ( LPARAM ) NULL );
   SendMessage ( hupdown, UDM_SETRANGE32, (WPARAM) hb_parni( 7 ), ( LPARAM ) hb_parni( 8 ) );

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( ( HWND ) hupdown, GWL_WNDPROC, ( LONG ) SubClassFunc );

   HWNDret( hupdown );
}

HB_FUNC( SETSPINNERRANGE )
{
   SendMessage( HWNDparam( 1 ), UDM_SETRANGE32, ( WPARAM ) hb_parni( 2 ), ( LPARAM ) hb_parni( 3 ) ) ;
}

HB_FUNC( SETSPINNERINCREMENT )
{
   UDACCEL inc ;
   inc.nSec = 0;
   inc.nInc = hb_parnl(2);
   SendMessage ( HWNDparam( 1 ), UDM_SETACCEL, (WPARAM) 1 , (LPARAM) &inc ) ;
}

#pragma ENDDUMP
