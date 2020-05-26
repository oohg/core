/*
 * $Id: h_ipaddress.prg $
 */
/*
 * ooHG source code:
 * IPAddress control
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

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TIpAddress FROM TLabel

   DATA nHeight                   INIT 24
   DATA nWidth                    INIT 120
   DATA Type                      INIT "IPADDRESS" READONLY

   METHOD Define
   METHOD IsBlank
   METHOD String                  SETGET
   METHOD Value                   SETGET

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( cControlName, uParentForm, nCol, nRow, nWidth, nHeight, uValue, cFontName, nFontSize, cToolTip, ;
               bLostFocus, bGotFocus, bChange, nHelpId, lInvisible, lNoTabStop, lBold, lItalic, lUnderline, ;
               lStrikeout, lRtl, lDisabled, uFontColor, uBackColor ) CLASS TIpAddress

   LOCAL nControlHandle, nStyle

   ASSIGN ::nCol    VALUE nCol TYPE "N"
   ASSIGN ::nRow    VALUE nRow TYPE "N"
   ASSIGN ::nWidth  VALUE nWidth TYPE "N"
   ASSIGN ::nHeight VALUE nHeight TYPE "N"

   ::SetForm( cControlName, uParentForm, cFontName, nFontSize, uFontColor, uBackColor, .T., lRtl )

   nStyle := ::InitStyle( ,, lInvisible, lNoTabStop, lDisabled )

   nControlHandle := InitIPAddress( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, nStyle, ::lRtl )

   IF uValue # NIL
      IF HB_ISARRAY( uValue )
         SetIPAddress( nControlHandle, uValue[ 1 ], uValue[ 2 ], uValue[ 3 ], uValue[ 4 ] )
      ELSEIF HB_ISSTRING( uValue )
         SetIPAddress( nControlHandle, uValue )
      ENDIF
   ENDIF

   ::Register( nControlHandle, cControlName, nHelpId,, cToolTip )
   ::SetFont( , , lBold, lItalic, lUnderline, lStrikeout )

   ASSIGN ::OnLostFocus VALUE bLostFocus TYPE "B"
   ASSIGN ::OnGotFocus  VALUE bGotFocus  TYPE "B"
   ASSIGN ::OnChange    VALUE bChange    TYPE "B"

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value( uValue ) CLASS TIpAddress

   IF PCount() > 0
      IF Len( uValue ) == 0
         ClearIpAddress( ::hWnd )
      ELSEIF HB_ISARRAY( uValue )
         SetIPAddress( ::hWnd, uValue[ 1 ], uValue[ 2 ], uValue[ 3 ], uValue[ 4 ] )
      ELSEIF HB_ISSTRING( uValue )
         SetIPAddress( ::hWnd, uValue )
      ENDIF
   ENDIF

   RETURN GetIPAddress( ::hWnd )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD String( uValue ) CLASS TIpAddress

   IF PCount() > 0
      ::Value := uValue
   ENDIF

   RETURN GetIPAddressString( ::hWnd )

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
static WNDPROC _OOHG_TIPAddress_lpfnOldWndProc( LONG_PTR lp )
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
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, _OOHG_TIPAddress_lpfnOldWndProc( 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( INITIPADDRESS )          /* FUNCTION InitIPAddress( hWnd, hMenu, nCol, nRow, nWidth, nHeight, nStyle, lRtl ) -> hWnd */
{
   int Style, StyleEx;
   HWND hCtrl;

   INITCOMMONCONTROLSEX i;
   i.dwSize = sizeof( INITCOMMONCONTROLSEX );
   i.dwICC = ICC_INTERNET_CLASSES;
   InitCommonControlsEx( &i );

   Style = WS_CHILD | hb_parni( 7 );
   StyleEx = WS_EX_CLIENTEDGE | _OOHG_RTL_Status( hb_parl( 8 ) );

   hCtrl = CreateWindowEx( StyleEx, WC_IPADDRESS, "", Style, hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ),
                           HWNDparam( 1 ), HMENUparam( 2 ), GetModuleHandle( NULL ), NULL );

   _OOHG_TIPAddress_lpfnOldWndProc( SetWindowLongPtr( hCtrl, GWLP_WNDPROC, (LONG_PTR) SubClassFunc ) );

   HWNDret( hCtrl );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( SETIPADDRESS )          /* FUNCTION SetIPAddress( hWnd, cIP or nF1, NIL or nF2, NIL or nF3, NIL or nF4 ) -> NIL */
{
   BYTE v1, v2, v3, v4, *v;

   if( HB_ISCHAR( 2 ) )
   {
      v = (BYTE *) HB_UNCONST( hb_parc( 2 ) );
      v1 = v[ 0 ];
      v2 = v[ 1 ];
      v3 = v[ 2 ];
      v4 = v[ 3 ];
   }
   else
   {
      v1 = (BYTE) hb_parni( 2 );
      v2 = (BYTE) hb_parni( 3 );
      v3 = (BYTE) hb_parni( 4 );
      v4 = (BYTE) hb_parni( 5 );
   }

   SendMessage( HWNDparam( 1 ), IPM_SETADDRESS, 0, MAKEIPADDRESS( v1, v2, v3, v4 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TIPADDRESS_ISBLANK )          /* METHOD IsBlank() CLASS TIpAddress -> lBlank */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf   = _OOHG_GetControlInfo( pSelf );

   hb_retl( SendMessage( oSelf->hWnd, IPM_ISBLANK, 0, 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GETIPADDRESS )          /* FUNCTION GetIPAddress( hWnd ) -> { nF1, nF2, nF3, nF4 } */
{
   DWORD pdwAddr;
   BYTE v1, v2, v3, v4;

   SendMessage( HWNDparam( 1 ), IPM_GETADDRESS, 0, (LPARAM)( LPDWORD ) &pdwAddr );

   v1 = (BYTE) (UINT) FIRST_IPADDRESS( pdwAddr );
   v2 = (BYTE) (UINT) SECOND_IPADDRESS( pdwAddr );
   v3 = (BYTE) (UINT) THIRD_IPADDRESS( pdwAddr );
   v4 = (BYTE) (UINT) FOURTH_IPADDRESS( pdwAddr );

   hb_reta( 4 );
   HB_STORNI( (int) v1, -1, 1 );
   HB_STORNI( (int) v2, -1, 2 );
   HB_STORNI( (int) v3, -1, 3 );
   HB_STORNI( (int) v4, -1, 4 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GETIPADDRESSSTRING )          /* FUNCTION GetIPAddressString( hWnd ) -> cIP */
{
   DWORD pdwAddr;
   BYTE v[ 4 ];

   SendMessage( HWNDparam( 1 ), IPM_GETADDRESS, 0, (LPARAM)( LPDWORD ) &pdwAddr );

   v[ 0 ] = (BYTE) (UINT) FIRST_IPADDRESS( pdwAddr );
   v[ 1 ] = (BYTE) (UINT) SECOND_IPADDRESS( pdwAddr );
   v[ 2 ] = (BYTE) (UINT) THIRD_IPADDRESS( pdwAddr );
   v[ 3 ] = (BYTE) (UINT) FOURTH_IPADDRESS( pdwAddr );

   hb_retclen( (char *) &v[ 0 ], 4 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( CLEARIPADDRESS )          /* FUNCTION ClearIPAddress() -> NIL */
{
   SendMessage( HWNDparam( 1 ), IPM_CLEARADDRESS, 0, 0 );
}

#pragma ENDDUMP
