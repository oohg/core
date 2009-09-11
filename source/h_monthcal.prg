/*
 * $Id: h_monthcal.prg,v 1.11 2009-09-11 02:41:25 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG monthcal functions
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

CLASS TMonthCal FROM TControl
   DATA Type      INIT "MONTHCAL" READONLY

   METHOD Define
   METHOD Value            SETGET
   METHOD SetFont
   METHOD Events_Notify

   EMPTY( _OOHG_AllVars )
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, value, fontname, ;
               fontsize, tooltip, notoday, notodaycircle, weeknumbers, ;
               change, HelpId, invisible, notabstop, bold, italic, ;
               underline, strikeout, lRtl, lDisabled ) CLASS TMonthCal
*-----------------------------------------------------------------------------*
Local ControlHandle, nStyle

   ASSIGN ::nCol        VALUE x TYPE "N"
   ASSIGN ::nRow        VALUE y TYPE "N"
   ASSIGN ::nWidth      VALUE w TYPE "N"
   ASSIGN ::nHeight     VALUE h TYPE "N"

   If ! HB_IsDate( value )
      value := DATE()
   EndIf

   ::SetForm( ControlName, ParentForm, FontName, FontSize,,,, lRtl )

   nStyle := ::InitStyle( ,, Invisible, NoTabStop, lDisabled ) + ;
             IF( HB_IsLogical( notoday )       .AND. notoday,       MCS_NOTODAY,       0 ) + ;
             IF( HB_IsLogical( notodaycircle ) .AND. notodaycircle, MCS_NOTODAYCIRCLE, 0 ) + ;
             IF( HB_IsLogical( weeknumbers )   .AND. weeknumbers,   MCS_WEEKNUMBERS,   0 )

   ControlHandle := InitMonthCal( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::nWidth, ::nHeight, nStyle, ::lRtl )

   ::Register( ControlHandle, ControlName, HelpId,, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   ASSIGN ::OnChange    VALUE Change    TYPE "B"
   ::Value := value

Return Self

*-----------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TMonthCal
*-----------------------------------------------------------------------------*
   IF ValType( uValue ) == "D"
      SetMonthCal( ::hWnd, uValue )
   ENDIF
Return GetMonthCalDate( ::hWnd )

*-----------------------------------------------------------------------------*
METHOD SetFont( FontName, FontSize, Bold, Italic, Underline, Strikeout ) CLASS TMonthCal
*-----------------------------------------------------------------------------*
Local uRet
   uRet := ::Super:SetFont( FontName, FontSize, Bold, Italic, Underline, Strikeout )
   AdjustMonthCalSize( ::hWnd, ::ContainerCol, ::ContainerRow )
   ::nWidth  := GetWindowWidth( ::hWnd )
   ::nHeight := GetWindowHeight( ::hWnd )
Return uRet

*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TMonthCal
*-----------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam )

   If nNotify == MCN_SELECT
      ::DoChange()
      Return nil

   EndIf

Return ::Super:Events_Notify( wParam, lParam )

#pragma BEGINDUMP

#define _WIN32_IE      0x0500
#define HB_OS_WIN_32_USED
#define _WIN32_WINNT   0x0400
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

HB_FUNC( INITMONTHCAL )
{
   HWND hwnd;
   HWND hmonthcal;
   INITCOMMONCONTROLSEX icex;
   int Style, StyleEx;

   icex.dwSize = sizeof( icex );
   icex.dwICC  = ICC_DATE_CLASSES;
   InitCommonControlsEx( &icex );

   hwnd = HWNDparam( 1 );

   StyleEx = _OOHG_RTL_Status( hb_parl( 8 ) );

   Style = hb_parni( 7 ) | WS_BORDER | WS_CHILD;

   hmonthcal = CreateWindowEx( StyleEx, MONTHCAL_CLASS, "", Style,
                               hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ),
                               hwnd, HMENUparam( 2 ), GetModuleHandle( NULL ), NULL ) ;

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( ( HWND ) hmonthcal, GWL_WNDPROC, ( LONG ) SubClassFunc );

   HWNDret( hmonthcal );
}

HB_FUNC( ADJUSTMONTHCALSIZE )
{
   HWND hWnd = HWNDparam( 1 );
   RECT rMin;

   MonthCal_GetMinReqRect( hWnd, &rMin );

   SetWindowPos( hWnd, NULL, hb_parni( 2 ), hb_parni( 3 ), rMin.right, rMin.bottom, SWP_NOZORDER );
}

HB_FUNC( SETMONTHCAL )
{
   SYSTEMTIME sysTime;
   char *cDate = 0;

   if( ISDATE( 2 ) )
   {
      cDate = ( char * ) hb_pards( 2 );
      if( cDate[ 0 ] == ' ' )
      {
         cDate = 0;
      }
      else
      {
         sysTime.wYear  = ( ( cDate[ 0 ] - '0' ) * 1000 ) +
                          ( ( cDate[ 1 ] - '0' ) * 100 )  +
                          ( ( cDate[ 2 ] - '0' ) * 10 ) + ( cDate[ 3 ] - '0' );
         sysTime.wMonth = ( ( cDate[ 4 ] - '0' ) * 10 ) + ( cDate[ 5 ] - '0' );
         sysTime.wDay   = ( ( cDate[ 6 ] - '0' ) * 10 ) + ( cDate[ 7 ] - '0' );
      }
   }

   if( ! cDate )
   {
      sysTime.wYear  = hb_parni( 2 );
      sysTime.wMonth = hb_parni( 3 );
      sysTime.wDay   = hb_parni( 4 );
   }

   sysTime.wDayOfWeek = 0;
   sysTime.wHour = 0;
   sysTime.wMinute = 0;
   sysTime.wSecond = 0;
   sysTime.wMilliseconds = 0;

   MonthCal_SetCurSel( HWNDparam( 1 ), &sysTime );
}

HB_FUNC( GETMONTHCALYEAR )
{
   SYSTEMTIME st;

   SendMessage( HWNDparam( 1 ), MCM_GETCURSEL, 0, ( LPARAM ) &st );
   hb_retni( st.wYear );
}

HB_FUNC( GETMONTHCALMONTH )
{
   SYSTEMTIME st;

   SendMessage( HWNDparam( 1 ), MCM_GETCURSEL, 0, ( LPARAM ) &st );
   hb_retni( st.wMonth );
}

HB_FUNC( GETMONTHCALDAY )
{
   SYSTEMTIME st;

   SendMessage( HWNDparam( 1 ), MCM_GETCURSEL, 0, ( LPARAM ) &st );
   hb_retni( st.wDay );
}

HB_FUNC( GETMONTHCALDATE )
{
   SYSTEMTIME st;
   int iNum;
   char cDate[ 9 ];

   SendMessage( HWNDparam( 1 ), MCM_GETCURSEL, 0, ( LPARAM ) &st );

   cDate[ 8 ] = 0;
   iNum = st.wYear;
   cDate[ 3 ] = ( iNum % 10 ) + '0';
   iNum /= 10;
   cDate[ 2 ] = ( iNum % 10 ) + '0';
   iNum /= 10;
   cDate[ 1 ] = ( iNum % 10 ) + '0';
   iNum /= 10;
   cDate[ 0 ] = ( iNum % 10 ) + '0';
   iNum = st.wMonth;
   cDate[ 5 ] = ( iNum % 10 ) + '0';
   iNum /= 10;
   cDate[ 4 ] = ( iNum % 10 ) + '0';
   iNum = st.wDay;
   cDate[ 7 ] = ( iNum % 10 ) + '0';
   iNum /= 10;
   cDate[ 6 ] = ( iNum % 10 ) + '0';

   hb_retds( cDate );
}


HB_FUNC( GETMONTHCALFIRSTDAYOFWEEK )
{
   hb_retni( LOWORD( SendMessage( HWNDparam( 1 ), MCM_GETFIRSTDAYOFWEEK, 0, 0 ) ) );
}

HB_FUNC( SETMONTHCALFIRSTDAYOFWEEK )
{
   SendMessage( HWNDparam( 1 ), MCM_SETFIRSTDAYOFWEEK, 0, hb_parni( 2 ) );
}

#pragma ENDDUMP
