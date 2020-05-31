/*
 * $Id: c_graph.c $
 */
/*
 * ooHG source code:
 * Graphics related functions
 *
 * Copyright 2005-2020 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2020 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2020 Contributors, https://harbour.github.io/
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


#include "oohg.h"
#include "hbapiitm.h"
#include <wingdi.h>
#include <winuser.h>

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( LINEDRAW )          /* FUNCTION LineDraw( hwnd, xfrom, yfrom, xto, yto, pencolor, penwidth ) -> NIL */
{
   HWND hwnd1;
   HDC hdc1;
   HGDIOBJ hgdiobj1;
   HPEN hpen;

   hwnd1 = HWNDparam( 1 );
   hdc1 = GetDC( hwnd1 );
   hpen = CreatePen( (int) PS_SOLID, (int) hb_parni( 7 ), RGB( (int) HB_PARNI( 6, 1 ), (int) HB_PARNI( 6, 2 ), (int) HB_PARNI( 6, 3 ) ) );
   hgdiobj1 = SelectObject( hdc1, hpen );
   MoveToEx( hdc1, (int) hb_parni( 3 ), (int) hb_parni( 2 ), NULL );
   LineTo( hdc1, (int) hb_parni( 5 ), (int) hb_parni( 4 ) );
   SelectObject( hdc1, hgdiobj1 );
   DeleteObject( hpen );
   ReleaseDC( hwnd1, hdc1 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RECTDRAW )          /* FUNCTION RectDraw( hwnd, top, left, bottom, right, pencolor, penwidth, brushcolor, usebrush ) -> NIL */
{
   HWND hWnd1;
   HDC hdc1;
   HGDIOBJ hgdiobj1, hgdiobj2;
   HPEN hpen;
   HBRUSH hbrush;

   hWnd1 = HWNDparam( 1 );
   hdc1 = GetDC( hWnd1 );
   hpen = CreatePen( (int) PS_SOLID, (int) hb_parni( 7 ), RGB( (int) HB_PARNI( 6, 1 ), (int) HB_PARNI( 6, 2 ), (int) HB_PARNI( 6, 3 ) ) );
   hgdiobj1 = SelectObject( hdc1, hpen );
   if( hb_parl( 9 ) )
   {
      hbrush = CreateSolidBrush( RGB( (int) HB_PARNI( 8, 1 ), (int) HB_PARNI( 8, 2 ), (int) HB_PARNI( 8, 3 ) ) );
      hgdiobj2 = SelectObject( hdc1, hbrush );
   }
   else
   {
      hbrush = GetSysColorBrush( COLOR_WINDOW );
      hgdiobj2 = SelectObject( hdc1, hbrush );
   }
   Rectangle( hdc1, (int) hb_parni( 3 ), (int) hb_parni( 2 ), (int) hb_parni( 5 ), (int) hb_parni( 4 ) );
   SelectObject( hdc1, hgdiobj1 );
   SelectObject( hdc1, hgdiobj2 );
   DeleteObject( hpen );
   DeleteObject( hbrush );
   ReleaseDC( hWnd1, hdc1 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( ROUNDRECTDRAW )          /* FUNCTION RoundRectDraw( hwnd, top, left, bottom, right, pencolor, penwidth, brushcolor, usebrush ) -> NIL */
{
   HWND hWnd1;
   HDC hdc1;
   HGDIOBJ hgdiobj1, hgdiobj2;
   HPEN hpen;
   HBRUSH hbrush;

   hWnd1 = HWNDparam( 1 );
   hdc1 = GetDC( hWnd1 );
   hpen = CreatePen( (int) PS_SOLID, (int) hb_parni( 9 ), RGB( (int) HB_PARNI( 8, 1 ), (int) HB_PARNI( 8, 2 ), (int) HB_PARNI( 8, 3 ) ) );
   hgdiobj1 = SelectObject( hdc1, hpen );
   if( hb_parl( 11 ) )
   {
      hbrush = CreateSolidBrush( RGB( (int) HB_PARNI( 10, 1 ), (int) HB_PARNI( 10, 2 ), (int) HB_PARNI( 10, 3 ) ) ) ;
      hgdiobj2 = SelectObject( hdc1, hbrush );
   }
   else
   {
      hbrush = GetSysColorBrush( COLOR_WINDOW );
      hgdiobj2 = SelectObject( hdc1, hbrush );
   }
   RoundRect( hdc1, (int) hb_parni( 3 ), (int) hb_parni( 2 ), (int) hb_parni( 5 ), (int) hb_parni( 4 ), (int) hb_parni( 6 ), (int) hb_parni( 7 ) );
   SelectObject( hdc1, hgdiobj1 );
   SelectObject( hdc1, hgdiobj2 );
   DeleteObject( hpen );
   DeleteObject( hbrush );
   ReleaseDC( hWnd1, hdc1 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( ELLIPSEDRAW )          /* FUNCTION EllipseDraw( hwnd, top, left, bottom, right, pencolor, penwidth, brushcolor, usebrush ) -> NIL */
{
   HWND hWnd1;
   HDC hdc1;
   HGDIOBJ hgdiobj1, hgdiobj2;
   HPEN hpen;
   HBRUSH hbrush;

   hWnd1 = HWNDparam( 1 );
   hdc1 = GetDC( hWnd1 );
   hpen = CreatePen( (int) PS_SOLID, (int) hb_parni( 7 ), RGB( (int) HB_PARNI( 6, 1 ), (int) HB_PARNI( 6, 2 ), (int) HB_PARNI( 6, 3 ) ) );
   hgdiobj1 = SelectObject( hdc1, hpen );
   if( hb_parl( 9 ) )
   {
      hbrush = CreateSolidBrush( RGB( (int) HB_PARNI( 8, 1 ), (int) HB_PARNI( 8, 2 ), (int) HB_PARNI( 8, 3 ) ) );
      hgdiobj2 = SelectObject( hdc1, hbrush );
   }
   else
   {
      hbrush = GetSysColorBrush( COLOR_WINDOW );
      hgdiobj2 = SelectObject( hdc1, hbrush );
   }
   Ellipse( hdc1, (int) hb_parni( 3 ), (int) hb_parni( 2 ), (int) hb_parni( 5 ), (int) hb_parni( 4 ) );
   SelectObject( hdc1, hgdiobj1 );
   SelectObject( hdc1, hgdiobj2 );
   DeleteObject( hpen );
   DeleteObject( hbrush );
   ReleaseDC( hWnd1, hdc1 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( ARCDRAW )          /* FUNCTION EllipseDraw( hwnd, ul_row, ul_col, lb_row, lb_col, sp_row, sp_col, ep_row, ep_col, pencolor, penwidth ) -> NIL */
{
   HWND hWnd1;
   HDC hdc1;
   HGDIOBJ hgdiobj1;
   HPEN hpen;

   hWnd1 = HWNDparam( 1 );
   hdc1 = GetDC( hWnd1 );
   hpen = CreatePen( (int) PS_SOLID, (int) hb_parni( 11 ), RGB( (int) HB_PARNI( 10, 1 ), (int) HB_PARNI( 10, 2 ), (int) HB_PARNI( 10, 3 ) ) );
   hgdiobj1 = SelectObject( hdc1, hpen );
   Arc( hdc1, (int) hb_parni( 3 ), (int) hb_parni( 2 ), (int) hb_parni( 5 ), (int) hb_parni( 4 ), (int) hb_parni( 7 ), (int) hb_parni( 6 ), (int) hb_parni( 9 ), (int) hb_parni( 8 ) );
   SelectObject( hdc1, hgdiobj1 );
   DeleteObject( hpen );
   ReleaseDC( hWnd1, hdc1 );
}
/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( PIEDRAW )          /* FUNCTION PieDraw( hwnd, top, left, bottom, right, r1_row, r1_col, r2_row, r2_col, pencolor, penwidth, brushcolor, usebrush ) -> NIL */
{
   HWND hWnd1;
   HDC hdc1;
   HGDIOBJ hgdiobj1, hgdiobj2;
   HPEN hpen;
   HBRUSH hbrush;

   hWnd1 = HWNDparam( 1 );
   hdc1 = GetDC( hWnd1 );
   hpen = CreatePen( (int) PS_SOLID, (int) hb_parni( 11 ), RGB( (int) HB_PARNI( 10, 1 ), (int) HB_PARNI( 10, 2 ), (int) HB_PARNI( 10, 3 ) ) );
   hgdiobj1 = SelectObject( hdc1, hpen);
   if( hb_parl( 13 ) )
   {
      hbrush = CreateSolidBrush( RGB( (int) HB_PARNI( 12, 1 ), (int) HB_PARNI( 12, 2 ), (int) HB_PARNI( 12, 3 ) ) );
      hgdiobj2 = SelectObject( hdc1, hbrush );
   }
   else
   {
      hbrush = GetSysColorBrush( COLOR_WINDOW );
      hgdiobj2 = SelectObject( hdc1, hbrush );
   }
   Pie( hdc1, (int) hb_parni( 3 ), (int) hb_parni( 2 ), (int) hb_parni( 5 ), (int) hb_parni( 4 ), (int) hb_parni( 7 ), (int) hb_parni( 6 ), (int) hb_parni( 9 ), (int) hb_parni( 8 ) );
   SelectObject( hdc1, hgdiobj1 );
   SelectObject( hdc1, hgdiobj2 );
   DeleteObject( hpen );
   DeleteObject( hbrush );
   ReleaseDC( hWnd1, hdc1 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( POLYGONDRAW )          /* FUNCTION PolygonDraw( hwnd, aCols, aRows, pencolor, penwidth, brushcolor, usebrush ) -> NIL */
{
   HWND hWnd1;
   HDC hdc1;
   HGDIOBJ hgdiobj1, hgdiobj2;
   HPEN hpen;
   HBRUSH hbrush;
   POINT apoints[1024];
   int number = (int) hb_parinfa( 2, 0 );
   int i;

   hWnd1 = HWNDparam( 1 );
   hdc1 = GetDC( hWnd1 );
   hpen = CreatePen( (int) PS_SOLID, (int) hb_parni( 5 ), RGB( (int) HB_PARNI( 4, 1 ), (int) HB_PARNI( 4, 2 ), (int) HB_PARNI( 4, 3 ) ) );
   hgdiobj1 = SelectObject( hdc1, hpen );
   if( hb_parl( 7 ) )
   {
      hbrush = CreateSolidBrush( RGB( (int) HB_PARNI( 6, 1 ), (int) HB_PARNI( 6, 2 ), (int) HB_PARNI( 6, 3 ) ) );
      hgdiobj2 = SelectObject( hdc1, hbrush );
   }
   else
   {
      hbrush = GetSysColorBrush( COLOR_WINDOW );
      hgdiobj2 = SelectObject( hdc1, hbrush );
   }
   for( i = 0; i <= number-1; i++ )
   {
      apoints[i].x = HB_PARNI( 2, i + 1 );
      apoints[i].y = HB_PARNI( 3, i + 1 );
   }
   Polygon( hdc1, apoints, number );
   SelectObject( hdc1, hgdiobj1 );
   SelectObject( hdc1, hgdiobj2 );
   DeleteObject( hpen );
   DeleteObject( hbrush );
   ReleaseDC( hWnd1, hdc1 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( POLYBEZIERDRAW )          /* FUNCTION PolyBezierDraw( hwnd, aCols, aRows, pencolor, penwidth, brushcolor, usebrush ) -> NIL */
{
   HWND hWnd1;
   HDC hdc1;
   HGDIOBJ hgdiobj1;
   HPEN hpen;
   POINT apoints[1024];
   DWORD number = (DWORD) hb_parinfa( 2, 0 );
   DWORD i;

   hWnd1 = HWNDparam( 1 );
   hdc1 = GetDC( hWnd1 );
   hpen = CreatePen( (int) PS_SOLID, (int) hb_parni( 5 ), RGB( (int) HB_PARNI( 4, 1 ), (int) HB_PARNI( 4, 2 ), (int) HB_PARNI( 4, 3 ) ) );
   hgdiobj1 = SelectObject( hdc1, hpen );
   for( i = 0; i <= number-1; i++ )
   {
      apoints[i].x = HB_PARNI( 2, i + 1 );
      apoints[i].y = HB_PARNI( 3, i + 1 );
   }
   PolyBezier( hdc1, apoints, number );
   SelectObject( hdc1, hgdiobj1 );
   DeleteObject( hpen );
   ReleaseDC( hWnd1, hdc1 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
void WndDrawBox( HDC hDC, RECT *rct, HPEN hPUpperLeft, HPEN hPBottomRight )
{
   HGDIOBJ hOldPen = SelectObject( hDC, hPUpperLeft );
   POINT pt;

   MoveToEx( hDC, rct->left, rct->bottom, &pt );

   LineTo( hDC, rct->left, rct->top );
   LineTo( hDC, rct->right, rct->top );

   MoveToEx( hDC, (int) rct->left, (int) rct->bottom, &pt );

   SelectObject( hDC, hPBottomRight );
   LineTo( hDC, (int) rct->right, (int) rct->bottom );
   LineTo( hDC, (int) rct->right, (int) rct->top - 1 );

   SelectObject( hDC, hOldPen );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
void WindowBoxIn( HDC hDC, RECT *pRect )
{
   HPEN hWhite = CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNHIGHLIGHT ) );
   HPEN hGray = CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNSHADOW ) );

   WndDrawBox( hDC, pRect, hGray, hWhite );

   DeleteObject( hGray );
   DeleteObject( hWhite );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( WNDBOXIN )          /* FUNCTION WndBoxIn( hdc, top, left, bottom, right ) -> NIL */
{
   RECT rct;

   rct.top    = hb_parni( 2 );
   rct.left   = hb_parni( 3 );
   rct.bottom = hb_parni( 4 );
   rct.right  = hb_parni( 5 );

   WindowBoxIn( HDCparam( 1 ), &rct );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( WNDBOXINDRAW )          /* FUNCTION WndBoxInDraw( hwnd, top, left, bottom, right ) -> NIL */
{
   RECT rct;
   HDC hDC;
   HWND hWnd;

   hWnd = HWNDparam( 1 );
   hDC = GetDC( hWnd );

   rct.top    = hb_parni( 2 );
   rct.left   = hb_parni( 3 );
   rct.bottom = hb_parni( 4 );
   rct.right  = hb_parni( 5 );

   WindowBoxIn( hDC, &rct );

   ReleaseDC( hWnd, hDC );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
void WindowRaised( HDC hDC, RECT *pRect )
{
   HPEN hGray  = CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNSHADOW ) );
   HPEN hWhite = CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNHIGHLIGHT ) );

   WndDrawBox( hDC, pRect, hWhite, hGray );

   DeleteObject( hGray );
   DeleteObject( hWhite );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( WNDBOXRAISED )          /* FUNCTION WndBoxRaised( hdc, top, left, bottom, right ) -> NIL */
{
   RECT rct;

   rct.top    = hb_parni( 2 );
   rct.left   = hb_parni( 3 );
   rct.bottom = hb_parni( 4 );
   rct.right  = hb_parni( 5 );

   WindowRaised( HDCparam( 1 ), &rct );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( WNDBOXRAISEDDRAW )          /* FUNCTION WndBoxRaisedDraw( hwnd, top, left, bottom, right ) -> NIL */
{
   RECT rct;
   HDC hDC;
   HWND hWnd;

   hWnd = HWNDparam( 1 );
   hDC = GetDC( hWnd );

   rct.top    = hb_parni( 2 );
   rct.left   = hb_parni( 3 );
   rct.bottom = hb_parni( 4 );
   rct.right  = hb_parni( 5 );

   WindowRaised( hDC, &rct );

   ReleaseDC( hWnd, hDC );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GETDC )          /* FUNCTION GetDC( hwnd ) -> hdc */
{
   HDCret( GetDC( HWNDparam( 1 ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RELEASEDC )          /* FUNCTION ReleaseDC( hwnd, hdc ) -> lSuccess */
{
   hb_retl( ReleaseDC( HWNDparam( 1 ), HDCparam(2) ) ) ;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
struct _OOHG_GraphData {
   int type;
   int top;
   int left;
   int bottom;
   int right;
   COLORREF penrgb;
   int penwidth;
   COLORREF fillrgb;
   BOOL fill;
   BOOL usenull;
   int top2;
   int left2;
   int bottom2;
   int right2;
   int width;
   int height;
   int pointcount;
   char points;
};

/*--------------------------------------------------------------------------------------------------------------------------------*/
void _OOHG_GraphCommand( HDC hDC, struct _OOHG_GraphData *pData )
{
   HGDIOBJ hgdiobj, hgdiobj2;
   HPEN hpen;
   HBRUSH hbrush;

   switch( pData->type )
   {
      case  1:      /* LineTo  */
         hpen = CreatePen( PS_SOLID, pData->penwidth, pData->penrgb );
         hgdiobj = SelectObject( hDC, hpen );
         MoveToEx( hDC, pData->left, pData->top, NULL );
         LineTo( hDC, pData->right, pData->bottom );
         SelectObject( hDC, hgdiobj );
         DeleteObject( hpen );
         break;

      case  2:      /* Rectangle */
         hpen = CreatePen( PS_SOLID, pData->penwidth, pData->penrgb );
         hgdiobj = SelectObject( hDC, hpen );
         if( pData->fill )
         {
            hbrush = CreateSolidBrush( pData->fillrgb );
         }
         else if( pData->usenull )
         {
            hbrush = (HBRUSH) GetStockObject( NULL_BRUSH );
         }
         else
         {
            hbrush = GetSysColorBrush( COLOR_WINDOW );
         }
         hgdiobj2 = SelectObject( hDC, hbrush );
         Rectangle( hDC, pData->left, pData->top, pData->right, pData->bottom );
         SelectObject( hDC, hgdiobj );
         SelectObject( hDC, hgdiobj2 );
         DeleteObject( hpen );
         DeleteObject( hbrush );
         break;

      case  3:      /* RoundRect */
         hpen = CreatePen( PS_SOLID, pData->penwidth, pData->penrgb );
         hgdiobj = SelectObject( hDC, hpen );
         if( pData->fill )
         {
            hbrush = CreateSolidBrush( pData->fillrgb );
         }
         else if( pData->usenull )
         {
            hbrush = (HBRUSH) GetStockObject( NULL_BRUSH );
         }
         else
         {
            hbrush = GetSysColorBrush( COLOR_WINDOW );
         }
         hgdiobj2 = SelectObject( hDC, hbrush );
         RoundRect( hDC, pData->left, pData->top, pData->right, pData->bottom, pData->width, pData->height );
         SelectObject( hDC, hgdiobj );
         SelectObject( hDC, hgdiobj2 );
         DeleteObject( hpen );
         DeleteObject( hbrush );
         break;

      case  4:      /* Ellipse */
         hpen = CreatePen( PS_SOLID, pData->penwidth, pData->penrgb );
         hgdiobj = SelectObject( hDC, hpen );
         if( pData->fill )
         {
            hbrush = (HBRUSH) CreateSolidBrush( pData->fillrgb );
         }
         else if( pData->usenull )
         {
            hbrush = (HBRUSH) GetStockObject( NULL_BRUSH );
         }
         else
         {
            hbrush = GetSysColorBrush( COLOR_WINDOW );
         }
         hgdiobj2 = SelectObject( hDC, hbrush );
         Ellipse( hDC, pData->left, pData->top, pData->right, pData->bottom );
         SelectObject( hDC, hgdiobj );
         SelectObject( hDC, hgdiobj2 );
         DeleteObject( hpen );
         DeleteObject( hbrush );
         break;

      case  5:      /* Arc */
         hpen = CreatePen( PS_SOLID, pData->penwidth, pData->penrgb );
         hgdiobj = SelectObject( hDC, hpen );
         Arc( hDC, pData->left, pData->top, pData->right, pData->bottom, pData->left2, pData->top2, pData->right2, pData->bottom2 );
         SelectObject( hDC, hgdiobj );
         DeleteObject( hpen );
         break;

      case  6:      /* Pie */
         hpen = CreatePen( PS_SOLID, pData->penwidth, pData->penrgb );
         hgdiobj = SelectObject( hDC, hpen );
         if( pData->fill )
         {
            hbrush = CreateSolidBrush( pData->fillrgb );
         }
         else if( pData->usenull )
         {
            hbrush = (HBRUSH) GetStockObject( NULL_BRUSH );
         }
         else
         {
            hbrush = GetSysColorBrush( COLOR_WINDOW );
         }
         hgdiobj2 = SelectObject( hDC, hbrush );
         Pie( hDC, pData->left, pData->top, pData->right, pData->bottom, pData->left2, pData->top2, pData->right2, pData->bottom2 );
         SelectObject( hDC, hgdiobj );
         SelectObject( hDC, hgdiobj2 );
         DeleteObject( hpen );
         DeleteObject( hbrush );
         break;

      case  7:      /* WindowBoxIn */
         {
            RECT rct;
            rct.top    = pData->top;
            rct.left   = pData->left;
            rct.bottom = pData->bottom;
            rct.right  = pData->right;
            WindowBoxIn( hDC, &rct );
         }
         break;

      case  8:      /* Polygon */
         hpen = CreatePen( PS_SOLID, pData->penwidth, pData->penrgb );
         hgdiobj = SelectObject( hDC, hpen );
         if( pData->fill )
         {
            hbrush = CreateSolidBrush( pData->fillrgb );
         }
         else if( pData->usenull )
         {
            hbrush = (HBRUSH) GetStockObject( NULL_BRUSH );
         }
         else
         {
            hbrush = GetSysColorBrush( COLOR_WINDOW );
         }
         hgdiobj2 = SelectObject( hDC, hbrush );
         Polygon( hDC, (POINT *) &pData->points, pData->pointcount );  
         SelectObject( hDC, hgdiobj );
         SelectObject( hDC, hgdiobj2 );
         DeleteObject( hpen );
         DeleteObject( hbrush );
         break;

      case  9:      /* PolyBezier */
         hpen = CreatePen( PS_SOLID, pData->penwidth, pData->penrgb );
         hgdiobj = SelectObject( hDC, hpen );
         PolyBezier( hDC, (POINT *) &pData->points, (DWORD) pData->pointcount );
         SelectObject( hDC, hgdiobj );
         DeleteObject( hpen );
         break;

      case 10:      /* TextOut */
         {
            COLORREF FontColor, BackColor;
            HFONT hOldFont, hFont;
            RECT rct;
            char *cBuffer;

            /* Content of pData:
               pData->top      = row
               pData->left     = col
               pData->bottom   = row1
               pData->right    = col1
               pData->penrgb   = fontcolor
               pData->penwidth = LEN( fontname )
               pData->fillrgb  = backcolor
               pData->fill     = transparent
               pData->top2     = bold
               pData->left2    = italic
               pData->bottom2  = underline
               pData->right2   = strikeOut
               pData->width    = fontsize
               pData->height   = LEN( string )
               pData->points   = fontname + string
            */

            FontColor = SetTextColor( hDC, pData->penrgb );
            BackColor = SetBkColor( hDC, pData->fillrgb );
            if( pData->fill )
            {
                SetBkMode( hDC, TRANSPARENT );
            }
            rct.top    = pData->top;
            rct.left   = pData->left;
            rct.bottom = pData->bottom;
            rct.right  = pData->right;

            /*
              HFONT PrepareFont( const char *FontName, int FontSize, int Weight, int Italic, int Underline, int StrikeOut, int Escapement, int Charset, int Width, int Orientation, bool Advanced )
            */
            hFont = PrepareFont( (const char *) &pData->points, pData->width, pData->top2, pData->left2, pData->bottom2, pData->right2, 0, DEFAULT_CHARSET, 0, 0, FALSE );
            hOldFont = (HFONT) SelectObject( hDC, hFont );

            /* Draw string */
            cBuffer = &pData->points;
            cBuffer += pData->penwidth + 1;
            if( pData->fill )
            {
               ExtTextOut( hDC, pData->left, pData->top, ETO_CLIPPED, &rct, cBuffer, (UINT) pData->height, NULL );
            }
            else
            {
               ExtTextOut( hDC, pData->left, pData->top, ETO_CLIPPED | ETO_OPAQUE, &rct, cBuffer, (UINT) pData->height, NULL );
            }

            /* Cleanup */
            SelectObject( hDC, hOldFont );
            SetTextColor( hDC, FontColor );
            SetBkColor( hDC, BackColor );
         }
         break;

      case 11:      /* WindowRaised */
         {
            RECT rct;
            rct.top    = pData->top;
            rct.left   = pData->left;
            rct.bottom = pData->bottom;
            rct.right  = pData->right;
            WindowRaised( hDC, &rct );
         }
         break;

      default:
         break;
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_GRAPHCOMMAND )          /* FUNCTION _OOHG_GraphCommand( hwnd, aGraphData ) -> NIL */
{
   HWND hWnd;
   HDC hDC;
   PHB_ITEM pArray, pItem;
   ULONG ulCount, ulPos;

   pArray = hb_param( 2, HB_IT_ARRAY );
   if( pArray )
   {
      ulCount = hb_arrayLen( pArray );
      if( ulCount )
      {
         hWnd = HWNDparam( 1 );
         hDC = GetDC( hWnd );
         for( ulPos = 1; ulPos <= ulCount; ulPos++ )
         {
            pItem = hb_arrayGetItemPtr( pArray, ulPos );
            if( HB_IS_STRING( pItem ) )
            {
               _OOHG_GraphCommand( hDC, (struct _OOHG_GraphData *) HB_UNCONST( hb_itemGetCPtr( pItem ) ) );
            }
         }
         ReleaseDC( hWnd, hDC );
      }
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_NEWGRAPHCOMMAND )          /* FUNCTION _OOHG_NewGraphCommand( hWnd, nType, top, left, bottom, right, penrgb, penwidth, fillrgb, lFill, top2, left2, bottom2, right2, width, height, usenull ) -> aGraphData */
{
   struct _OOHG_GraphData pStruct, *pData;
   HWND hWnd;
   HDC hDC;
   long lColor, lSize;
   UINT lItems;
   BOOL bBuffer;
   int iType;
   POINT *pPoint;

   iType = hb_parni(  2 );
   if( iType == 8 || iType == 9 )
   {
      lItems = (UINT) hb_parinfa( 3, 0 );
      lSize = (long) ( sizeof( pStruct ) + ( lItems * sizeof( POINT ) ) );
      pData = (struct _OOHG_GraphData *) hb_xgrab( (HB_SIZE) lSize );
      bBuffer = 1;
      pPoint = (POINT *) &pData->points;
      pData->pointcount = (int) lItems;
      while( lItems )
      {
         lItems--;
         pPoint[ lItems ].x = HB_PARNI( 4, lItems + 1 );
         pPoint[ lItems ].y = HB_PARNI( 3, lItems + 1 );
      }
   }
   else
   {
      lSize = sizeof( pStruct );
      pData = &pStruct;
      bBuffer = 0;
   }

   pData->type     = iType;
   pData->top      = hb_parni(  3 );
   pData->left     = hb_parni(  4 );
   pData->bottom   = hb_parni(  5 );
   pData->right    = hb_parni(  6 );
   lColor = -1;
   _OOHG_DetermineColor( hb_param( 7, HB_IT_ANY ), &lColor );
   pData->penrgb   = (COLORREF) lColor;
   pData->penwidth = max( hb_parni(  8 ), 1 );
   lColor = -1;
   _OOHG_DetermineColor( hb_param( 9, HB_IT_ANY ), &lColor );
   pData->fillrgb  = (COLORREF) lColor;
   pData->fill     = hb_parl( 10 );
   pData->top2     = hb_parni( 11 );
   pData->left2    = hb_parni( 12 );
   pData->bottom2  = hb_parni( 13 );
   pData->right2   = hb_parni( 14 );
   pData->width    = hb_parni( 15 );
   pData->height   = hb_parni( 16 );
   pData->usenull  = hb_parl( 17 );

   hWnd = HWNDparam( 1 );
   if( ValidHandler( hWnd ) )
   {
      hDC = GetDC( hWnd );
      _OOHG_GraphCommand( hDC, pData );
      ReleaseDC( hWnd, hDC );
   }

   hb_retclen( (char *) pData, (HB_SIZE) lSize );
   if( bBuffer )
   {
      hb_xfree( pData );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_NEWGRAPHCOMMAND_TEXT )          /* FUNCTION _OOHG_NewGraphCommand_Text( hwnd, unused, top, left, bottom, right, pencolor, txt, brushcolor, transp, bold, italic, underline, strikeout, fontname, fontsize ) -> aGraphData */
{
   struct _OOHG_GraphData *pData;
   HWND hWnd;
   HDC hDC;
   long lColor, lSize;
   char *cBuffer;

   lSize = (long) ( sizeof( struct _OOHG_GraphData ) + hb_parclen( 8 ) + hb_parclen( 15 ) + 5 );
   pData = (struct _OOHG_GraphData *) hb_xgrab( (HB_SIZE) lSize );

   pData->type   = 10;
   pData->top    = hb_parni( 3 );
   pData->left   = hb_parni( 4 );
   pData->bottom = hb_parni( 5 );
   pData->right  = hb_parni( 6 );
   lColor = -1;
   _OOHG_DetermineColor( hb_param( 7, HB_IT_ANY ), &lColor );
   pData->penrgb   = (COLORREF) lColor;
   pData->penwidth = (int) hb_parclen( 15 );                  /* LEN( fontname ) */
   cBuffer = &pData->points;
   memcpy( cBuffer, hb_parc( 15 ), (size_t) ( pData->penwidth + 1 ) );
   cBuffer += hb_parclen( 15 ) + 1;
   lColor = -1;
   _OOHG_DetermineColor( hb_param( 9, HB_IT_ANY ), &lColor );
   pData->fillrgb = (COLORREF) lColor;
   pData->fill    = hb_parl( 10 );                            /* Transparent */
   pData->top2    = hb_parl( 11 ) ? FW_BOLD : FW_NORMAL;      /* Bold */
   pData->left2   = hb_parl( 12 ) ? 1 : 0;                    /* Italic */
   pData->bottom2 = hb_parl( 13 ) ? 1 : 0;                    /* Underline */
   pData->right2  = hb_parl( 14 ) ? 1 : 0;                    /* StrikeOut */
   pData->width   = hb_parni( 16 );                           /* FontSize */
   pData->height  = (int) hb_parclen( 8 );                    /* LEN( String ) */
   memcpy( cBuffer, hb_parc( 8 ), (size_t) ( pData->height + 1 ) );

   hWnd = HWNDparam( 1 );
   if( ValidHandler( hWnd ) )
   {
      hDC = GetDC( hWnd );
      _OOHG_GraphCommand( hDC, pData );
      ReleaseDC( hWnd, hDC );
   }

   hb_retclen( (char *) pData, (HB_SIZE) lSize );
   hb_xfree( pData );
}
