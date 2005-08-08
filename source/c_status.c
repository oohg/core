/*
 * $Id: c_status.c,v 1.2 2005-08-08 02:43:49 guerra000 Exp $
 */
/*
 * ooHG source code:
 * C statusbar functions
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

#include <stdlib.h>

#define NUM_OF_PARTS 40

HB_FUNC( INITMESSAGEBAR )
{
    HWND hwnd;
    HWND hWndSB;
    int   ptArray[40];   // Array defining the number of parts/sections
    int  nrOfParts = 1;
    int  iStyle;

    hwnd = (HWND) hb_parnl (1);

    iStyle = WS_CHILD | WS_VISIBLE | WS_BORDER | SBT_TOOLTIPS;
    if( hb_parl( 4 ) )
    {
       iStyle |= CCS_TOP;
    }

    hWndSB = CreateStatusWindow( iStyle, hb_parc(2), hwnd, hb_parni (3));
    if(hWndSB)
    {
	SendMessage(hWndSB, SB_SETPARTS, nrOfParts,  (LPARAM)(LPINT)ptArray);
    }

    hb_retnl ( (LONG) hWndSB );
}
//--------------------------------------------------------

//void InitializeStatusBar(HWND hWndStatusbar, char *cMsg, int nSize, int nMsg)

HB_FUNC (INITITEMBAR)
{
    HWND  hWndSB;
	int   cSpaceInBetween = 8;
	int   ptArray[40];   // Array defining the number of parts/sections
	int   nrOfParts = 0;
    int   n ;
	RECT  rect;
	HDC   hDC;
	WORD  displayFlags;
    HICON hIcon;
	int   cx;
	int   cy;

	hWndSB = (HWND) hb_parnl (1);
      switch(hb_parni(8))
      {
         case  0:  displayFlags = 0 ; break;
         case  1:  displayFlags = SBT_POPOUT ; break;
         case  2:  displayFlags = SBT_NOBORDERS ; break;
         default : displayFlags = 0;
      }


    if ( hb_parnl (5)) {
 	    nrOfParts = SendMessage(hWndSB,SB_GETPARTS,40 , 0);
		SendMessage(hWndSB,SB_GETPARTS, 40 , (LPARAM)(LPINT)ptArray);
	}
    nrOfParts ++ ;


    hDC = GetDC(hWndSB);
    GetClientRect(hWndSB, &rect);

    if (hb_parnl (5) == 0){
	    ptArray[nrOfParts-1] = rect.right;
    	}
    else {

        for ( n = 0 ; n < nrOfParts-1  ; n++)
            {
	        ptArray[n] -=  hb_parni (4) - cSpaceInBetween ;
	        }
	    ptArray[nrOfParts-1] = rect.right;
    }

	ReleaseDC(hWndSB, hDC);

	SendMessage(hWndSB,  SB_SETPARTS, nrOfParts,(LPARAM)(LPINT)ptArray);

	cy = rect.bottom - rect.top-4;
	cx = cy;

	hIcon = (HICON)LoadImage(0, hb_parc(6),IMAGE_ICON ,cx,cy , LR_LOADFROMFILE );

	if (hIcon==NULL)
	{
		hIcon = (HICON)LoadImage(GetModuleHandle(NULL),hb_parc(6),IMAGE_ICON ,cx,cy, 0 );
	}

	if (!(hIcon ==NULL))
	{
		SendMessage(hWndSB,SB_SETICON,(WPARAM)nrOfParts-1, (LPARAM)hIcon );
	}

	SendMessage(hWndSB, SB_SETTEXT, nrOfParts-1 | displayFlags, (LPARAM) hb_parc (2));
	SendMessage(hWndSB, SB_SETTIPTEXT,(WPARAM)nrOfParts-1, (LPARAM) hb_parc (7));

	hb_retni( nrOfParts );

}

HB_FUNC( SETITEMBAR )
{
    SendMessage( ( HWND ) hb_parnl( 1 ), SB_SETTEXT, hb_parni( 3 ) , ( LPARAM ) hb_parc( 2 ) );
}

HB_FUNC( GETITEMBAR )
{
    char cString[ 1024 ] = "";
    SendMessage( ( HWND ) hb_parnl( 1 ), SB_GETTEXT, ( WPARAM ) hb_parni( 2 ) - 1, ( LPARAM ) cString );
    hb_retc( cString );
}

HB_FUNC( GETITEMCOUNT )
{
    hb_retni( SendMessage( ( HWND ) hb_parnl( 1 ), SB_GETPARTS, 40, 0 ) );
}

HB_FUNC( GETITEMWIDTH )
{
   HWND  hWnd;
   int   *piItems;
   unsigned int iItems, iSize, iPos;

   hWnd = ( HWND ) hb_parnl( 1 );
   iPos = hb_parni( 2 );
   iItems = SendMessage( hWnd, SB_GETPARTS, 40, 0 );
   iSize = 0;
   if( iItems != 0 && iPos <= iItems )
   {
      piItems = hb_xgrab( sizeof( int ) * iItems );
      SendMessage( hWnd, SB_GETPARTS, iItems, ( LPARAM ) piItems );
      if( iPos == 1 )
      {
         iSize = piItems[ iPos - 1 ];
      }
      else
      {
         iSize = piItems[ iPos - 1 ] - piItems[ iPos - 2 ];
      }
      hb_xfree( piItems );
   }
   hb_retni( iSize );
}

HB_FUNC( REFRESHITEMBAR )
{
   HWND  hWnd;
   int   *piItems;
   int   iItems, iWidth, iCount, iDiff;
   RECT  rect;

   hWnd = ( HWND ) hb_parnl( 1 );
   iItems = SendMessage( hWnd, SB_GETPARTS, 40, 0 );
   if( iItems != 0 )
   {
      GetWindowRect( ( HWND ) hb_parnl( 2 ), &rect );
      iWidth = rect.right - rect.left /* - ( GetSystemMetrics( SM_CXSIZEFRAME ) * 2 ) */ - 35 ;

      piItems = hb_xgrab( sizeof( int ) * iItems );
      SendMessage( hWnd, SB_GETPARTS, iItems, ( LPARAM ) piItems );
      iDiff = iWidth - piItems[ iItems - 1 ];
      for( iCount = 0; iCount < iItems; iCount++ )
      {
         piItems[ iCount ] = piItems[ iCount ] + iDiff;
      }
      SendMessage( hWnd, SB_SETPARTS, iItems, ( LPARAM ) piItems );
      MoveWindow( hWnd, 0, 0, 0, 0, TRUE );
      hb_xfree( piItems );
   }
   hb_retni( iItems );
}

HB_FUNC ( KEYTOGGLE )
{
   BYTE pBuffer[ 256 ];
   WORD wKey = hb_parni( 1 );

   GetKeyboardState( pBuffer );

   if( pBuffer[ wKey ] & 0x01 )
      pBuffer[ wKey ] &= 0xFE;
   else
      pBuffer[ wKey ] |= 0x01;

   SetKeyboardState( pBuffer );
}

HB_FUNC ( SETSTATUSITEMICON )
{

	HWND  hwnd;
	RECT  rect;
	HICON hIcon ;
	int   cx;
	int   cy;

	hwnd = (HWND) hb_parnl (1);

	// Unloads from memory current icon

	DestroyIcon ( (HICON) SendMessage(hwnd,SB_GETICON,(WPARAM) hb_parni(2)-1, (LPARAM) 0 ) ) ;

	//

	GetClientRect(hwnd, &rect);

	cy = rect.bottom - rect.top-4;
	cx = cy;

	hIcon = (HICON)LoadImage(GetModuleHandle(NULL),hb_parc(3),IMAGE_ICON ,cx,cy, 0 );

	if (hIcon==NULL)
	{
		hIcon = (HICON)LoadImage(0, hb_parc(3),IMAGE_ICON ,cx,cy, LR_LOADFROMFILE );
	}

	SendMessage(hwnd,SB_SETICON,(WPARAM) hb_parni(2)-1, (LPARAM)hIcon );

}
