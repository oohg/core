/*
 * $Id: h_scrollbutton.prg $
 */
/*
 * ooHG source code:
 * ScrollButton control
 *
 * Copyright 2006-2018 Vicente Guerra <vicente@guerra.com.mx>
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
#include "hbclass.ch"
#include "i_windefs.ch"

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TScrollButton FROM TControl

   DATA lAdjust                                   INIT .F.
   DATA Type                                      INIT "SCROLLBUTTON" READONLY

   METHOD Define

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( cControlName, uParentForm, nCol, nRow, nWidth, nHeight, lSunken ) CLASS TScrollButton

   LOCAL nControlHandle

   ::SetForm( cControlName, uParentForm )

   ASSIGN ::nRow    VALUE nRow    TYPE "N"
   ASSIGN ::nCol    VALUE nCol    TYPE "N"
   ASSIGN ::nWidth  VALUE nWidth  TYPE "N"
   ASSIGN ::nHeight VALUE nHeight TYPE "N"
   ASSIGN lSunken   VALUE lSunken TYPE "L" DEFAULT ! ::IsVisualStyled

   nControlHandle := InitVScrollBarButton( ::ContainerhWnd, ::ContainerCol, ::ContainerRow, ::Width, ::Height, iif( lSunken, SS_SUNKEN, 0 ) )

   ::Register( nControlHandle, cControlName )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
#pragma BEGINDUMP

#include "hbapi.h"
#include <windows.h>
#include <commctrl.h>
#include "oohg.h"

/*--------------------------------------------------------------------------------------------------------------------------------*/
static WNDPROC _OOHG_TScrollButton_lpfnOldWndProc( WNDPROC lp )
{
   static WNDPROC lpfnOldWndProc = 0;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( ! lpfnOldWndProc )
   {
      lpfnOldWndProc = lp;
   }
   ReleaseMutex( _OOHG_GlobalMutex() );

   return lpfnOldWndProc;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, _OOHG_TScrollButton_lpfnOldWndProc( 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( INITVSCROLLBARBUTTON )          /* FUNCTION InitVScrollBarButton( hWnd, nCol, nRow, nWidth, nHeight, nStyle ) -> hWnd */
{
   HWND hCtrl;
   INT Style;

   Style = WS_CHILD | WS_VISIBLE | hb_parni( 6 );

   hCtrl = CreateWindow( "static", "", Style,
                         hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ),
                         HWNDparam( 1 ), NULL, GetModuleHandle( NULL ), NULL );

   _OOHG_TScrollButton_lpfnOldWndProc( ( WNDPROC ) SetWindowLongPtr( hCtrl, GWL_WNDPROC, ( LONG_PTR ) SubClassFunc ) );

   HWNDret( hCtrl );
}

#pragma ENDDUMP
