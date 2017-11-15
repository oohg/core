/*
 * $Id: c_progressbar.c $
 */
/*
 * ooHG source code:
 * C progressbar functions
 *
 * Copyright 2005-2017 Vicente Guerra <vicente@guerra.com.mx>
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

HB_FUNC( INITPROGRESSBAR )
{
   HWND hwnd;
   HWND hbutton;
   int StyleEx;
   int Style = WS_CHILD  | hb_parni( 2 );

   INITCOMMONCONTROLSEX  i;
   i.dwSize = sizeof(INITCOMMONCONTROLSEX);
   i.dwICC = ICC_DATE_CLASSES;
   InitCommonControlsEx(&i);

   hwnd = HWNDparam( 1 );

   StyleEx = WS_EX_CLIENTEDGE | _OOHG_RTL_Status( hb_parl( 13 ) );

   if ( hb_parl (9) )
   {
      Style = Style | PBS_VERTICAL ;
   }

   if ( hb_parl (10) )
   {
      Style = Style | PBS_SMOOTH ;
   }

   if ( ! hb_parl (11) )
   {
      Style = Style | WS_VISIBLE ;
   }

    hbutton = CreateWindowEx( StyleEx,
                             "msctls_progress32" ,
                             0 ,
                             Style ,
                             hb_parni(3) ,
                             hb_parni(4) ,
                             hb_parni(5) ,
                             hb_parni(6) ,
                             hwnd,(HMENU)hb_parni(2) ,
                             GetModuleHandle(NULL) ,
                             NULL ) ;

   SendMessage(hbutton,PBM_SETRANGE,0,MAKELONG(hb_parni(7),hb_parni(8)));
   SendMessage(hbutton,PBM_SETPOS,(WPARAM) hb_parni(12),0);

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( ( HWND ) hbutton, GWL_WNDPROC, ( LONG ) SubClassFunc );

   HWNDret( hbutton );
}

HB_FUNC ( SETPROGRESSBARRANGE )
{
        SendMessage( HWNDparam( 1 ), PBM_SETRANGE,0,MAKELONG(hb_parni(2),hb_parni(3)));
}

HB_FUNC ( SETPROGRESSBARBKCOLOR )
{
        SendMessage( HWNDparam( 1 ), PBM_SETBKCOLOR,0,RGB(hb_parni(2),hb_parni(3),hb_parni(4)));
}

HB_FUNC ( SETPROGRESSBARBARCOLOR )
{
        SendMessage( HWNDparam( 1 ), PBM_SETBARCOLOR,0,RGB(hb_parni(2),hb_parni(3),hb_parni(4)));
}
