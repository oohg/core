/*
 * $Id: h_ipaddress.prg $
 */
/*
 * ooHG source code:
 * IPAddress control
 *
 * Copyright 2005-2018 Vicente Guerra <vicente@guerra.com.mx>
 * https://oohg.github.io/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2018, https://harbour.github.io/
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


#include "oohg.ch"
#include "common.ch"
#include "hbclass.ch"

CLASS TIpAddress FROM TLabel

   DATA Type          INIT "IPADDRESS" READONLY
   DATA nWidth        INIT 120
   DATA nHeight       INIT 24

   METHOD Define
   METHOD Value       SETGET
   METHOD String      SETGET

   ENDCLASS

METHOD Define( ControlName, ParentForm, x, y, w, h, aValue, fontname, ;
               fontsize, tooltip, lostfocus, gotfocus, change, HelpId, ;
               invisible, notabstop, bold, italic, underline, strikeout, lRtl, ;
               lDisabled, FontColor, BackColor ) CLASS TIpAddress

   Local ControlHandle, nStyle

   // Assign STANDARD values to optional params.
   ASSIGN ::nCol    VALUE x TYPE "N"
   ASSIGN ::nRow    VALUE y TYPE "N"
   ASSIGN ::nWidth  VALUE w TYPE "N"
   ASSIGN ::nHeight VALUE h TYPE "N"

   ::SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor, .T., lRtl )

   nStyle := ::InitStyle( ,, Invisible, NoTabStop, lDisabled )

   ControlHandle := InitIPAddress( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, nStyle, ::lRtl )

   If aValue <> Nil
      If HB_IsArray( aValue )
         SetIPAddress( ControlHandle, aValue[ 1 ], aValue[ 2 ], aValue[ 3 ], aValue[ 4 ] )
      Elseif HB_IsString( aValue )
         SetIPAddress( ControlHandle, aValue )
      EndIf
   EndIf

   ::Register( ControlHandle, ControlName, HelpId,, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   ASSIGN ::OnLostFocus VALUE lostfocus TYPE "B"
   ASSIGN ::OnGotFocus  VALUE gotfocus  TYPE "B"
   ASSIGN ::OnChange    VALUE Change    TYPE "B"

   Return Self

METHOD Value( uValue ) CLASS TIpAddress

   IF pcount() > 0
      If Len( uValue ) == 0
         ClearIpAddress( ::hWnd )
      Elseif HB_IsArray( uValue )
         SetIPAddress( ::hWnd, uValue[1], uValue[2], uValue[3], uValue[4] )
      Elseif HB_IsString( uValue )
         SetIPAddress( ::hWnd, uValue )
      EndIf
   ENDIF

   RETURN GetIPAddress( ::hWnd )

METHOD String( uValue ) CLASS TIpAddress

   IF pcount() > 0
      ::Value := uValue
   ENDIF

   RETURN GetIPAddressString( ::hWnd )


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

HB_FUNC( INITIPADDRESS )
{
 HWND hWnd;
 HWND hIpAddress;
   int Style;
   int StyleEx;

   INITCOMMONCONTROLSEX i;
   i.dwSize = sizeof( INITCOMMONCONTROLSEX );
 i.dwICC = ICC_INTERNET_CLASSES;
   InitCommonControlsEx( &i );

   hWnd = HWNDparam( 1 );

   Style = WS_CHILD | hb_parni( 7 );

   StyleEx = WS_EX_CLIENTEDGE | _OOHG_RTL_Status( hb_parl( 8 ) );

   hIpAddress = CreateWindowEx( StyleEx, WC_IPADDRESS, "", Style,
                hb_parni( 3 ), hb_parni( 4 ) ,hb_parni( 5 ), hb_parni( 6 ),
                hWnd, HMENUparam( 2 ), GetModuleHandle( NULL ), NULL );

   lpfnOldWndProc = (WNDPROC) SetWindowLongPtr( hIpAddress, GWL_WNDPROC, (LONG_PTR) SubClassFunc );

   HWNDret( hIpAddress );
}

HB_FUNC( SETIPADDRESS )
{
   BYTE v1, v2, v3, v4, *v;

   if( HB_ISCHAR( 2 ) )
   {
      v = ( BYTE * ) hb_parc( 2 );
      v1 = v[ 0 ];
      v2 = v[ 1 ];
      v3 = v[ 2 ];
      v4 = v[ 3 ];
   }
   else
   {
      v1 = ( BYTE ) hb_parni( 2 );
      v2 = ( BYTE ) hb_parni( 3 );
      v3 = ( BYTE ) hb_parni( 4 );
      v4 = ( BYTE ) hb_parni( 5 );
   }

   SendMessage( HWNDparam( 1 ), IPM_SETADDRESS, 0, MAKEIPADDRESS( v1, v2, v3, v4 ) );
}

HB_FUNC( GETIPADDRESS )
{
   DWORD pdwAddr;
   BYTE v1, v2, v3, v4;

   SendMessage( HWNDparam( 1 ), IPM_GETADDRESS, 0, ( LPARAM )( LPDWORD ) &pdwAddr );

   v1 = ( BYTE ) ( unsigned int ) FIRST_IPADDRESS( pdwAddr );
   v2 = ( BYTE ) ( unsigned int ) SECOND_IPADDRESS( pdwAddr );
   v3 = ( BYTE ) ( unsigned int ) THIRD_IPADDRESS( pdwAddr );
   v4 = ( BYTE ) ( unsigned int ) FOURTH_IPADDRESS( pdwAddr );

   hb_reta( 4 );
   HB_STORNI( ( int ) v1, -1, 1 );
   HB_STORNI( ( int ) v2, -1, 2 );
   HB_STORNI( ( int ) v3, -1, 3 );
   HB_STORNI( ( int ) v4, -1, 4 );
}

HB_FUNC( GETIPADDRESSSTRING )
{
   DWORD pdwAddr;
   BYTE v[ 4 ];

   SendMessage( HWNDparam( 1 ), IPM_GETADDRESS, 0, ( LPARAM )( LPDWORD ) &pdwAddr );

   v[ 0 ] = ( BYTE ) ( unsigned int ) FIRST_IPADDRESS( pdwAddr );
   v[ 1 ] = ( BYTE ) ( unsigned int ) SECOND_IPADDRESS( pdwAddr );
   v[ 2 ] = ( BYTE ) ( unsigned int ) THIRD_IPADDRESS( pdwAddr );
   v[ 3 ] = ( BYTE ) ( unsigned int ) FOURTH_IPADDRESS( pdwAddr );

   hb_retclen( ( char * ) &v[ 0 ], 4 );
}

HB_FUNC( CLEARIPADDRESS )
{
   SendMessage( HWNDparam( 1 ), IPM_CLEARADDRESS, 0, 0 );
}

#pragma ENDDUMP
