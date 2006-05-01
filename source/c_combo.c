/*
 * $Id: c_combo.c,v 1.9 2006-05-01 04:09:47 guerra000 Exp $
 */
/*
 * ooHG source code:
 * C combo functions
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
#include <windowsx.h>
#include "../include/oohg.h"

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

HB_FUNC( INITCOMBOBOX )
{
   HWND hwnd;
   HWND hbutton;
   int Style, StyleEx;

   hwnd = (HWND) hb_parnl (1);

   StyleEx = _OOHG_RTL_Status( hb_parl( 14 ) );

   Style = WS_CHILD | WS_VSCROLL | CBS_HASSTRINGS | CBS_OWNERDRAWFIXED; // CBS_OWNERDRAWVARIABLE;

   if ( ! hb_parl(9) )
   {
      Style |= WS_VISIBLE ;
   }

   if ( ! hb_parl(10) )
   {
      Style |= WS_TABSTOP ;
   }

   if ( hb_parl(11) )
   {
      Style |= CBS_SORT ;
   }

   if ( !hb_parl(12) )
   {
      Style |= CBS_DROPDOWNLIST ;
   }
   else
   {
      Style |= CBS_DROPDOWN ;
   }

   if ( hb_parl(13) )
   {
      Style |= CBS_NOINTEGRALHEIGHT ;
   }

   hbutton = CreateWindowEx( StyleEx, "COMBOBOX",
                           "" ,
                           Style ,
                           hb_parni(3) ,
                           hb_parni(4) ,
                           hb_parni(5) ,
                           hb_parni(8) ,
                           hwnd ,
                           (HMENU)hb_parni(2) ,
                           GetModuleHandle(NULL) ,
                           NULL ) ;

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( ( HWND ) hbutton, GWL_WNDPROC, ( LONG ) SubClassFunc );

   hb_retnl ( (LONG) hbutton );
}

HB_FUNC( COMBOADDSTRING )
{
   HWND hWnd = ( HWND ) hb_parnl( 1 );

   SendMessage( hWnd, CB_INSERTSTRING, ( WPARAM ) ComboBox_GetCount( hWnd ), ( LPARAM ) hb_parc( 2 ) );
}

HB_FUNC( COMBOINSERTSTRING )
{
   SendMessage( ( HWND ) hb_parnl( 1 ), CB_INSERTSTRING, ( WPARAM ) hb_parni( 3 ) - 1, ( LPARAM ) hb_parc( 2 ) );
}

HB_FUNC( COMBOSETCURSEL )
{
   SendMessage( ( HWND ) hb_parnl( 1 ), CB_SETCURSEL, ( WPARAM ) hb_parni( 2 ) - 1, 0 );
}

HB_FUNC( COMBOGETCURSEL )
{
   hb_retni ( SendMessage( (HWND) hb_parnl( 1 ) , CB_GETCURSEL , 0 , 0 )  + 1 );
}

HB_FUNC (COMBOBOXDELETESTRING )
{
	SendMessage( (HWND) hb_parnl( 1 ), CB_DELETESTRING, (WPARAM) hb_parni(2)-1, 0);
}

HB_FUNC ( COMBOBOXRESET )
{
	SendMessage( (HWND) hb_parnl( 1 ), CB_RESETCONTENT, 0, 0 );
}

HB_FUNC ( COMBOGETSTRING )
{
	char cString [1024] = "" ;
	SendMessage( (HWND) hb_parnl( 1 ), CB_GETLBTEXT , (WPARAM) hb_parni(2) - 1, (LPARAM) cString );
	hb_retc(cString) ;
}

HB_FUNC ( COMBOBOXGETITEMCOUNT )
{
   hb_retnl ( SendMessage( (HWND) hb_parnl( 1 ) , CB_GETCOUNT , 0, 0 ) ) ;
}