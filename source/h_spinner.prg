/*
 * $Id: h_spinner.prg,v 1.18 2013-08-01 01:27:11 fyurisich Exp $
 */
/*
 * ooHG source code:
 * PRG spinner functions
 *
 * Copyright 2005-2009 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.oohg.org
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

   METHOD Define
   METHOD SizePos
   METHOD Visible             SETGET
   METHOD Value               SETGET
   METHOD Enabled             SETGET
   METHOD ForceHide           BLOCK { |Self| HideWindow( ::AuxHandle ) , ::Super:ForceHide() }

   METHOD RangeMin            SETGET
   METHOD RangeMax            SETGET
   METHOD Increment           SETGET

   EMPTY( _OOHG_AllVars )
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, value, fontname, fontsize, ;
               rl, rh, tooltip, change, lostfocus, gotfocus, h, HelpId, ;
               invisible, notabstop, bold, italic, underline, strikeout, ;
               wrap, readonly, increment, backcolor, fontcolor, lRtl, ;
               lNoBorder ) CLASS TSpinner
*-----------------------------------------------------------------------------*
Local nStyle := ES_NUMBER + ES_AUTOHSCROLL, nStyleEx := 0
Local ControlHandle

   ASSIGN ::nWidth       VALUE w         TYPE "N"
   ASSIGN ::nHeight      VALUE h         TYPE "N"
   ASSIGN ::nRow         VALUE y         TYPE "N"
   ASSIGN ::nCol         VALUE x         TYPE "N"
   ASSIGN ::nRangeMin    VALUE rl        TYPE "N"
   ASSIGN ::nRangeMax    VALUE rh        TYPE "N"
   ASSIGN ::nIncrement   VALUE increment TYPE "N"
   ASSIGN wrap           VALUE wrap      TYPE "L" DEFAULT .F.
   ASSIGN readonly       VALUE readonly  TYPE "L" DEFAULT .F.
   ASSIGN invisible      VALUE invisible TYPE "L" DEFAULT .F.
   DEFAULT value TO rl

   ::SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor, .T., lRtl )

   nStyle += ::InitStyle( ,, Invisible, NoTabStop ) + ;
             if(  HB_IsLogical ( readonly )  .AND.  readonly,  ES_READONLY, 0 )

   nStyleEx += IF( !HB_IsLogical( lNoBorder ) .OR. ! lNoBorder, WS_EX_CLIENTEDGE, 0 )

   ControlHandle := InitTextBox( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::nWidth, ::nHeight, nStyle, 0, ::lRtl, nStyleEx )

   ::AuxHandle := InitSpinner( ::ContainerhWnd, 0, ::ContainerCol + ::nWidth, ::ContainerRow, 15, ::nHeight, ::nRangeMin, ::nRangeMax, invisible, wrap, ControlHandle, ::lRtl )

   ::Register( ControlHandle, ControlName, HelpId,, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   ::Value := value

   If ::nIncrement <> 1
      ::Increment := ::nIncrement
   EndIf

   ASSIGN ::OnLostFocus VALUE lostfocus TYPE "B"
   ASSIGN ::OnGotFocus  VALUE gotfocus  TYPE "B"
   ASSIGN ::OnChange    VALUE Change    TYPE "B"

Return Self

*-----------------------------------------------------------------------------*
METHOD SizePos( Row, Col, Width, Height ) CLASS TSpinner
*-----------------------------------------------------------------------------*
Local uRet
   uRet := ::Super:SizePos( Row, Col, Width, Height )
   MoveWindow( ::hWnd, ::ContainerCol, ::ContainerRow, ::Width - 15, ::Height , .T. )
   MoveWindow( ::AuxHandle, ::ContainerCol + ::Width - 15, ::ContainerRow, 15, ::Height , .T. )
Return uRet

*-----------------------------------------------------------------------------*
METHOD Visible( lVisible ) CLASS TSpinner
*-----------------------------------------------------------------------------*
   IF HB_IsLogical( lVisible )
      ::Super:Visible := lVisible
      IF lVisible .AND. ::ContainerVisible
         CShowControl( ::AuxHandle )
      ELSE
         HideWindow( ::AuxHandle )
      ENDIF
   ENDIF
Return ::lVisible

*-----------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TSpinner
*-----------------------------------------------------------------------------*
   IF HB_IsNumeric ( uValue )
      SetSpinnerValue( ::AuxHandle, uValue )
      ::DoChange()
   ENDIF
Return GetSpinnerValue( ::AuxHandle )

*-----------------------------------------------------------------------------*
METHOD Enabled( lEnabled ) CLASS TSpinner
*-----------------------------------------------------------------------------*
   IF HB_IsLogical( lEnabled )
      ::Super:Enabled := lEnabled
      IF ::Super:Enabled
         EnableWindow( ::AuxHandle )
      ELSE
         DisableWindow( ::AuxHandle )
      ENDIF
   ENDIF
Return ::Super:Enabled

*-----------------------------------------------------------------------------*
METHOD RangeMin( nValue ) CLASS TSpinner
*-----------------------------------------------------------------------------*
   IF HB_IsNumeric( nValue )
      ::nRangeMin := nValue
      SetSpinnerRange( ::AuxHandle, ::nRangeMin, ::nRangeMax )
   ENDIF
Return ::nRangeMin

*-----------------------------------------------------------------------------*
METHOD RangeMax( nValue ) CLASS TSpinner
*-----------------------------------------------------------------------------*
   IF HB_IsNumeric( nValue )
      ::nRangeMax := nValue
      SetSpinnerRange( ::AuxHandle, ::nRangeMin, ::nRangeMax )
   ENDIF
Return ::nRangeMax

*-----------------------------------------------------------------------------*
METHOD Increment( nValue ) CLASS TSpinner
*-----------------------------------------------------------------------------*
   IF HB_IsNumeric( nValue )
      ::nIncrement := nValue
      SetSpinnerIncrement( ::AuxHandle, nValue )
   ENDIF
Return ::nIncrement

#pragma BEGINDUMP

#ifndef _WIN32_IE
   #define _WIN32_IE      0x0500
#endif
#define HB_OS_WIN_32_USED
#ifndef _WIN32_WINNT
   #define _WIN32_WINNT   0x0400
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
