/*
 * $Id: c_monthcal.c,v 1.5 2007-01-01 20:52:13 guerra000 Exp $
 */
/*
 * ooHG source code:
 * C monthcal functions
 *
 * Copyright 2005 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.guerra.com.mx
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
#include "../include/oohg.h"

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

HB_FUNC ( INITMONTHCAL )
{
	HWND hwnd;
	HWND hmonthcal;
	INITCOMMONCONTROLSEX icex;
    int Style, StyleEx;

	icex.dwSize = sizeof(icex);
	icex.dwICC  = ICC_DATE_CLASSES;
	InitCommonControlsEx(&icex);

   hwnd = HWNDparam( 1 );

   StyleEx = _OOHG_RTL_Status( hb_parl( 12 ) );

	Style = WS_BORDER | WS_CHILD ;

    if ( hb_parl(7) )
	{
		Style = Style | MCS_NOTODAY ;
	}

    if ( hb_parl(8) )
	{
		Style = Style | MCS_NOTODAYCIRCLE ;
	}

    if ( hb_parl(9) )
	{
		Style = Style | MCS_WEEKNUMBERS ;
	}

    if ( !hb_parl(10) )
	{
		Style = Style | WS_VISIBLE ;
	}

    if ( !hb_parl(11) )
	{
		Style = Style | WS_TABSTOP ;
	}

    hmonthcal = CreateWindowEx(StyleEx,
                     MONTHCAL_CLASS,
                     "",
                     Style,
                     0,0,0,0,
                     hwnd,
                     (HMENU)hb_parni(2),
                     GetModuleHandle(NULL),
                     NULL ) ;

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( ( HWND ) hmonthcal, GWL_WNDPROC, ( LONG ) SubClassFunc );

   HWNDret( hmonthcal );

}

HB_FUNC( ADJUSTMONTHCALSIZE )
{
   HWND hWnd = HWNDparam( 1 );
   // RECT rOld;
   RECT rMin;

   // GetWindowRect( hWnd, &rOld );

   MonthCal_GetMinReqRect( hWnd, &rMin );

   SetWindowPos( hWnd, NULL, hb_parni( 2 ), hb_parni( 3 ), // rOld.left, rOld.top,
                 rMin.right, rMin.bottom, SWP_NOZORDER );
}

HB_FUNC( SETMONTHCAL )
{
	HWND hwnd;
	SYSTEMTIME sysTime;
    char *cDate = 0;

   hwnd = HWNDparam( 1 );

    if( ISDATE( 2 ) )
    {
       cDate = hb_pards( 2 );
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
       sysTime.wYear = hb_parni(2);
       sysTime.wMonth = hb_parni(3);
       sysTime.wDay = hb_parni(4);
    }

	sysTime.wDayOfWeek = 0;
	sysTime.wHour = 0;
	sysTime.wMinute = 0;
	sysTime.wSecond = 0;
	sysTime.wMilliseconds = 0;

	MonthCal_SetCurSel(hwnd, &sysTime);
}

HB_FUNC ( GETMONTHCALYEAR )
{
	HWND hwnd;
	SYSTEMTIME st;
   hwnd = HWNDparam( 1 );

	SendMessage(hwnd, MCM_GETCURSEL, 0, (LPARAM) &st);
	hb_retni(st.wYear);
}

HB_FUNC ( GETMONTHCALMONTH )
{
	HWND hwnd;
	SYSTEMTIME st;
   hwnd = HWNDparam( 1 );

	SendMessage(hwnd, MCM_GETCURSEL, 0, (LPARAM) &st);
	hb_retni(st.wMonth);
}

HB_FUNC ( GETMONTHCALDAY )
{
	HWND hwnd;
	SYSTEMTIME st;
   hwnd = HWNDparam( 1 );

	SendMessage(hwnd, MCM_GETCURSEL, 0, (LPARAM) &st);
	hb_retni(st.wDay);
}

HB_FUNC ( GETMONTHCALDATE )
{
	HWND hwnd;
	SYSTEMTIME st;
    int iNum;
    char cDate[ 9 ];

   hwnd = HWNDparam( 1 );
	SendMessage(hwnd, MCM_GETCURSEL, 0, (LPARAM) &st);

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
