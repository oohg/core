/*
 * $Id: c_graph.c,v 1.1 2005-08-07 00:02:34 guerra000 Exp $
 */
/*
 * ooHG source code:
 * C graphic functions
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

#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"
#include <wingdi.h>
#include <winuser.h>

HB_FUNC ( LINEDRAW )
{
   HWND hWnd1;
   HDC hdc1;
   HGDIOBJ hgdiobj1;
   HPEN hpen;
   hWnd1 = (HWND) hb_parnl(1);
   hdc1 = GetDC( (HWND) hWnd1 );
   hpen = CreatePen( (int) PS_SOLID, (int) hb_parni(7), (COLORREF) RGB( (int) hb_parni(6,1), (int) hb_parni(6,2), (int) hb_parni(6,3) ) );
   hgdiobj1 = SelectObject( (HDC) hdc1, hpen );
   MoveToEx( (HDC) hdc1, (int) hb_parni(3), (int) hb_parni(2), NULL );
   LineTo( (HDC) hdc1, (int) hb_parni(5), (int) hb_parni(4) );
   SelectObject( (HDC) hdc1, (HGDIOBJ) hgdiobj1 );
   DeleteObject( hpen );
   ReleaseDC( hWnd1, hdc1 );
}

HB_FUNC ( RECTDRAW )
{
   HWND hWnd1;
   HDC hdc1;
   HGDIOBJ hgdiobj1,hgdiobj2;
   HPEN hpen;
   HBRUSH hbrush;
   hWnd1 = (HWND) hb_parnl (1);
   hdc1 = GetDC((HWND) hWnd1);
   hpen = CreatePen( (int) PS_SOLID, (int) hb_parni(7), (COLORREF) RGB( (int) hb_parni(6,1), (int) hb_parni(6,2), (int) hb_parni(6,3) ) );

   hgdiobj1 = SelectObject((HDC) hdc1, hpen);
   if (hb_parl(9))
   {
      hbrush = CreateSolidBrush((COLORREF) RGB((int) hb_parni(8,1),(int) hb_parni(8,2),(int) hb_parni(8,3)));
      hgdiobj2 = SelectObject((HDC) hdc1, hbrush);
   }
   else
   {
      hbrush = GetSysColorBrush((int) COLOR_WINDOW);
      hgdiobj2 = SelectObject((HDC) hdc1, hbrush);
   }
   Rectangle((HDC) hdc1,(int) hb_parni(3),(int) hb_parni(2),(int) hb_parni(5),(int) hb_parni(4));
   SelectObject((HDC) hdc1,(HGDIOBJ) hgdiobj1);
   SelectObject((HDC) hdc1,(HGDIOBJ) hgdiobj2);
   DeleteObject( hpen );
   DeleteObject( hbrush );
   ReleaseDC( hWnd1, hdc1 );
}

HB_FUNC ( ROUNDRECTDRAW )
{
   HWND hWnd1;
   HDC hdc1;
   HGDIOBJ hgdiobj1,hgdiobj2;
   HPEN hpen;
   HBRUSH hbrush;
   hWnd1 = (HWND) hb_parnl (1);
   hdc1 = GetDC((HWND) hWnd1);
   hpen = CreatePen( (int) PS_SOLID, (int) hb_parni(9), (COLORREF) RGB( (int) hb_parni(8,1), (int) hb_parni(8,2), (int) hb_parni(8,3) ) );
   hgdiobj1 = SelectObject((HDC) hdc1, hpen);
   if (hb_parl(11))
   {
      hbrush = CreateSolidBrush((COLORREF) RGB((int) hb_parni(10,1),(int) hb_parni(10,2),(int) hb_parni(10,3)));
      hgdiobj2 = SelectObject((HDC) hdc1, hbrush);
   }
   else
   {
      hbrush = GetSysColorBrush((int) COLOR_WINDOW);
      hgdiobj2 = SelectObject((HDC) hdc1, hbrush);
   }
   RoundRect((HDC) hdc1,(int) hb_parni(3),(int) hb_parni(2),(int) hb_parni(5),(int) hb_parni(4),(int) hb_parni(6),(int) hb_parni(7));
   SelectObject((HDC) hdc1,(HGDIOBJ) hgdiobj1);
   SelectObject((HDC) hdc1,(HGDIOBJ) hgdiobj2);
   DeleteObject( hpen );
   DeleteObject( hbrush );
   ReleaseDC( hWnd1, hdc1 );
}

HB_FUNC ( ELLIPSEDRAW )
{
   HWND hWnd1;
   HDC hdc1;
   HGDIOBJ hgdiobj1,hgdiobj2;
   HPEN hpen;
   HBRUSH hbrush;
   hWnd1 = (HWND) hb_parnl (1);
   hdc1 = GetDC((HWND) hWnd1);
   hpen = CreatePen( (int) PS_SOLID, (int) hb_parni(7), (COLORREF) RGB( (int) hb_parni(6,1), (int) hb_parni(6,2), (int) hb_parni(6,3) ) );
   hgdiobj1 = SelectObject((HDC) hdc1, hpen);
   if (hb_parl(9))
   {
      hbrush = CreateSolidBrush((COLORREF) RGB((int) hb_parni(8,1),(int) hb_parni(8,2),(int) hb_parni(8,3)));
      hgdiobj2 = SelectObject((HDC) hdc1, hbrush);
   }
   else
   {
      hbrush = GetSysColorBrush((int) COLOR_WINDOW);
      hgdiobj2 = SelectObject((HDC) hdc1, hbrush);
   }
   Ellipse((HDC) hdc1,(int) hb_parni(3),(int) hb_parni(2),(int) hb_parni(5),(int) hb_parni(4));
   SelectObject((HDC) hdc1,(HGDIOBJ) hgdiobj1);
   SelectObject((HDC) hdc1,(HGDIOBJ) hgdiobj2);
   DeleteObject( hpen );
   DeleteObject( hbrush );
   ReleaseDC( hWnd1, hdc1 );
}

HB_FUNC ( ARCDRAW )
{
   HWND hWnd1;
   HDC hdc1;
   HGDIOBJ hgdiobj1;
   HPEN hpen;
   hWnd1 = (HWND) hb_parnl (1);
   hdc1 = GetDC((HWND) hWnd1);
   hpen = CreatePen( (int) PS_SOLID, (int) hb_parni(11), (COLORREF) RGB( (int) hb_parni(10,1), (int) hb_parni(10,2), (int) hb_parni(10,3) ) );
   hgdiobj1 = SelectObject( (HDC) hdc1, hpen );
   Arc((HDC) hdc1,(int) hb_parni(3),(int) hb_parni(2),(int) hb_parni(5),(int) hb_parni(4),(int) hb_parni(7),(int) hb_parni(6),(int) hb_parni(9),(int) hb_parni(8));
   SelectObject((HDC) hdc1,(HGDIOBJ) hgdiobj1);
   DeleteObject( hpen );
   ReleaseDC( hWnd1, hdc1 );
}

HB_FUNC ( PIEDRAW )
{
   HWND hWnd1;
   HDC hdc1;
   HGDIOBJ hgdiobj1,hgdiobj2;
   HPEN hpen;
   HBRUSH hbrush;
   hWnd1 = (HWND) hb_parnl (1);
   hdc1 = GetDC((HWND) hWnd1);
   hpen = CreatePen( (int) PS_SOLID, (int) hb_parni(11), (COLORREF) RGB( (int) hb_parni(10,1), (int) hb_parni(10,2), (int) hb_parni(10,3) ) );
   hgdiobj1 = SelectObject((HDC) hdc1, hpen);
   if (hb_parl(13))
   {
      hbrush = CreateSolidBrush((COLORREF) RGB((int) hb_parni(12,1),(int) hb_parni(12,2),(int) hb_parni(12,3)));
      hgdiobj2 = SelectObject((HDC) hdc1, hbrush);
   }
   else
   {
      hbrush = GetSysColorBrush((int) COLOR_WINDOW);
      hgdiobj2 = SelectObject((HDC) hdc1, hbrush);
   }
   Pie((HDC) hdc1,(int) hb_parni(3),(int) hb_parni(2),(int) hb_parni(5),(int) hb_parni(4),(int) hb_parni(7),(int) hb_parni(6),(int) hb_parni(9),(int) hb_parni(8));
   SelectObject((HDC) hdc1,(HGDIOBJ) hgdiobj1);
   SelectObject((HDC) hdc1,(HGDIOBJ) hgdiobj2);
   DeleteObject( hpen );
   DeleteObject( hbrush );
   ReleaseDC( hWnd1, hdc1 );
}

HB_FUNC( POLYGONDRAW )
{
   HWND hWnd1;
   HDC hdc1;
   HGDIOBJ hgdiobj1,hgdiobj2;
   HPEN hpen;
   HBRUSH hbrush;
   POINT apoints[1024];
   int number=hb_parinfa(2,0);
   int i;
   hWnd1 = (HWND) hb_parnl (1);
   hdc1 = GetDC((HWND) hWnd1);
   hpen = CreatePen( (int) PS_SOLID, (int) hb_parni(5), (COLORREF) RGB( (int) hb_parni(4,1), (int) hb_parni(4,2), (int) hb_parni(4,3) ) );
   hgdiobj1 = SelectObject((HDC) hdc1, hpen);
   if (hb_parl(7))
   {
      hbrush = CreateSolidBrush((COLORREF) RGB((int) hb_parni(6,1),(int) hb_parni(6,2),(int) hb_parni(6,3)));
      hgdiobj2 = SelectObject((HDC) hdc1, hbrush);
   }
   else
   {
      hbrush = GetSysColorBrush((int) COLOR_WINDOW);
      hgdiobj2 = SelectObject((HDC) hdc1, hbrush);
   }
   for(i = 0; i <= number-1; i++)
   {
   apoints[i].x=hb_parni(2,i+1);
   apoints[i].y=hb_parni(3,i+1);
   }
   Polygon((HDC) hdc1,apoints,number);
   SelectObject((HDC) hdc1,(HGDIOBJ) hgdiobj1);
   SelectObject((HDC) hdc1,(HGDIOBJ) hgdiobj2);
   DeleteObject( hpen );
   DeleteObject( hbrush );
   ReleaseDC( hWnd1, hdc1 );
}

HB_FUNC( POLYBEZIERDRAW )
{
   HWND hWnd1;
   HDC hdc1;
   HGDIOBJ hgdiobj1;
   HPEN hpen;
   POINT apoints[1024];
   DWORD number=(DWORD) hb_parinfa(2,0);
   DWORD i;
   hWnd1 = (HWND) hb_parnl (1);
   hdc1 = GetDC((HWND) hWnd1);
   hpen = CreatePen( (int) PS_SOLID, (int) hb_parni(5), (COLORREF) RGB( (int) hb_parni(4,1), (int) hb_parni(4,2), (int) hb_parni(4,3) ) );
   hgdiobj1 = SelectObject((HDC) hdc1, hpen);
   for(i = 0; i <= number-1; i++)
   {
   apoints[i].x=hb_parni(2,i+1);
   apoints[i].y=hb_parni(3,i+1);
   }
   PolyBezier((HDC) hdc1,apoints,number);
   SelectObject((HDC) hdc1,(HGDIOBJ) hgdiobj1);
   DeleteObject( hpen );
   ReleaseDC( hWnd1, hdc1 );
}

void WndDrawBox( HDC hDC, RECT * rct, HPEN hPUpLeft, HPEN hPBotRit )
{
   HPEN hOldPen = ( HPEN ) SelectObject( hDC, hPUpLeft );
   POINT pt;

   MoveToEx( hDC, rct->left, rct->bottom, &pt );

   LineTo( hDC, rct->left, rct->top );
   LineTo( hDC, rct->right, rct->top );
   SelectObject( hDC, hPBotRit );

   MoveToEx( hDC, rct->left, rct->bottom, &pt );

   LineTo( hDC, rct->right, rct->bottom );
   LineTo( hDC, rct->right, rct->top - 1 );
   SelectObject( hDC, hOldPen );
}

void WindowBoxIn( HDC hDC, RECT * pRect )
{
   HPEN hWhite = CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNHIGHLIGHT ) );
   HPEN hGray = CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNSHADOW ) );

   WndDrawBox( hDC, pRect, hGray, hWhite );

   DeleteObject( hGray );
   DeleteObject( hWhite );
}

HB_FUNC( WNDBOXIN )
{
   RECT rct;

   rct.top    = hb_parni( 2 );
   rct.left   = hb_parni( 3 );
   rct.bottom = hb_parni( 4 );
   rct.right  = hb_parni( 5 );

   WindowBoxIn( ( HDC ) hb_parnl( 1 ), &rct );
}

HB_FUNC ( GETDC )
{
   hb_retnl( (ULONG) GetDC( (HWND) hb_parnl(1) ) ) ;
}

HB_FUNC ( RELEASEDC )
{
   hb_retl( ReleaseDC( (HWND) hb_parnl(1), (HDC) hb_parnl(2) ) ) ;
}