/*
 * $Id: h_scroll.prg,v 1.8 2006-04-07 05:47:41 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG scrollbars functions
 *
 * Copyright 2005 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.guerra.com.mx
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

#include "oohg.ch"
#include "hbclass.ch"
#include "common.ch"
#include "i_windefs.ch"

CLASS TScrollBar FROM TControl
   DATA Type         INIT "SCROLLBAR" READONLY
   DATA ScrollType   INIT SB_CTL
   DATA nRangeMin    INIT 0
   DATA nRangeMax    INIT 0
   DATA OnLineUp     INIT nil
   DATA OnLineDown   INIT nil
   DATA OnPageUp     INIT nil
   DATA OnPageDown   INIT nil
   DATA OnTop        INIT nil
   DATA OnBottom     INIT nil
   DATA OnThumb      INIT nil
   DATA OnTrack      INIT nil
   DATA OnEndTrack   INIT nil

   METHOD Define
   METHOD Value               SETGET
   METHOD RangeMin            SETGET
   METHOD RangeMax            SETGET

   METHOD Events_VScroll
ENDCLASS

// VScrollbar!!!!
*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, RangeMin, RangeMax, ;
               change, lineup, linedown, pageup, pagedown, top, bottom, ;
               thumb, track, endtrack, HelpId, invisible, ToolTip, lRtl ) CLASS TScrollBar
*-----------------------------------------------------------------------------*
Local ControlHandle

   DEFAULT w         TO GETVSCROLLBARWIDTH()
   DEFAULT h         TO GETHSCROLLBARHEIGHT()
   DEFAULT invisible TO .F.
   DEFAULT RangeMin  TO 1
   DEFAULT RangeMax  TO 100

   ::SetForm( ControlName, ParentForm,,,,,, lRtl )

   ControlHandle := InitVScrollBar( ::ContainerhWnd, x, y, w, h )

   ::Register( ControlHandle, ControlName, HelpId, ! invisible, ToolTip, ControlHandle )
   ::SizePos( y, x, w, h )

   ::VScroll:RangeMin := RangeMin
   ::VScroll:RangeMax := RangeMax

   SetScrollRange( ::hWnd, ::ScrollType, RangeMin, RangeMax, 1 )

   ::OnChange   := change
   ::OnLineUp   := lineup
   ::OnLineDown := linedown
   ::OnPageUp   := pageup
   ::OnPageDown := pagedown
   ::OnTop      := top
   ::OnBottom   := bottom
   ::OnThumb    := thumb
   ::OnTrack    := track
   ::OnEndTrack := endtrack

Return Self

*-----------------------------------------------------------------------------*
METHOD Value( nValue ) CLASS TScrollBar
*-----------------------------------------------------------------------------*
   if valtype( nValue ) == "N"
      SetScrollPos( ::hWnd, ::ScrollType, nValue, 1 )
   endif
Return GetScrollPos( ::hWnd, ::ScrollType )

*-----------------------------------------------------------------------------*
METHOD RangeMin( nValue ) CLASS TScrollBar
*-----------------------------------------------------------------------------*
   if valtype( nValue ) == "N"
      ::nRangeMin := nValue
      SetScrollRange( ::hWnd, ::ScrollType, nValue, ::nRangeMax, 1 )
   endif
Return ::nRangeMin

*-----------------------------------------------------------------------------*
METHOD RangeMax( nValue ) CLASS TScrollBar
*-----------------------------------------------------------------------------*
   if valtype( nValue ) == "N"
      ::nRangeMax := nValue
      SetScrollRange( ::hWnd, ::ScrollType, ::nRangeMin, nValue, 1 )
   endif
Return ::nRangeMax

*-----------------------------------------------------------------------------*
METHOD Events_VScroll( wParam ) CLASS TScrollBar
*-----------------------------------------------------------------------------*
Local Lo_wParam := LoWord( wParam )

   If Lo_wParam == SB_LINEDOWN

      _OOHG_EVAL( ::OnLineDown, Self )

   elseif Lo_wParam == SB_LINEUP

      _OOHG_EVAL( ::OnLineUp, Self )

   elseif Lo_wParam == SB_PAGEUP

      _OOHG_EVAL( ::OnPageUp, Self )

   elseif Lo_wParam == SB_PAGEDOWN

      _OOHG_EVAL( ::OnPageDown, Self )

   elseif Lo_wParam == SB_TOP

      _OOHG_EVAL( ::OnTop, Self )

   elseif Lo_wParam == SB_BOTTOM

      _OOHG_EVAL( ::OnBottom, Self )

   elseif Lo_wParam == SB_THUMBPOSITION

      _OOHG_EVAL( ::OnThumb, Self, HiWord( wParam ) )

   elseif Lo_wParam == SB_THUMBTRACK

      _OOHG_EVAL( ::OnTrack, Self, HiWord( wParam ) )

   elseif Lo_wParam == TB_ENDTRACK

      _OOHG_EVAL( ::OnEndTrack, Self, HiWord( wParam ) )

   else

      Return ::Super:Events_VScroll( wParam )

   EndIf

   ::DoEvent( ::OnChange )

Return ::Super:Events_VScroll( wParam )

EXTERN GetVScrollbarWidth, GetHScrollbarHeight, SetScrollPos, SetScrollPage
EXTERN SetScrollRange, GetScrollPos, IsScrollLockActive, _SetScroll
EXTERN InitVScrollbar, SetScrollInfo, GetScrollRangeMax

#pragma BEGINDUMP

#include <hbapi.h>
#include <windows.h>
#include <commctrl.h>
#include "../include/oohg.h"

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

// this MUST be a INITSCROLLBAR instead only a VERTICAL scroll bar!!!
HB_FUNC( INITVSCROLLBAR )
{
	HWND hwnd;
	HWND hscrollbar;

	hwnd = (HWND) hb_parnl (1);

	hscrollbar = CreateWindowEx(0 ,"SCROLLBAR","",
	WS_CHILD | WS_VISIBLE | SBS_VERT ,
	hb_parni(2) , hb_parni(3) , hb_parni(4) , hb_parni(5),
	hwnd,(HMENU) 0 , GetModuleHandle(NULL) , NULL ) ;

   SetScrollRange( hscrollbar, // handle of window with scroll bar
                   SB_CTL,     // scroll bar flag
                   1,    // minimum scrolling position
                   100,     // maximum scrolling position
                   1     // redraw flag
	);

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( ( HWND ) hscrollbar, GWL_WNDPROC, ( LONG ) SubClassFunc );

   hb_retnl( (LONG) hscrollbar );
}

HB_FUNC( GETVSCROLLBARWIDTH )
{
   hb_retni( GetSystemMetrics( SM_CXVSCROLL ) );
}

HB_FUNC( GETHSCROLLBARHEIGHT )
{
   hb_retni( GetSystemMetrics( SM_CYHSCROLL ) );
}

HB_FUNC( SETSCROLLPOS ) // ( hWnd, fnBar, nPos, lRedraw )
{
   hb_retni( SetScrollPos( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ), hb_parni( 3 ), hb_parl( 4 ) ) );
}

HB_FUNC( SETSCROLLRANGE ) // ( hWnd, fnBar, nRangeMin, nRangeMax, lRedraw )
{
   hb_retl( SetScrollRange( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ), hb_parl( 5 ) ) );
}

HB_FUNC( GETSCROLLPOS ) // ( hWnd, fnBar )
{
   hb_retni( GetScrollPos( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ) ) );
}

HB_FUNC( ISSCROLLLOCKACTIVE )
{
   hb_retl( GetKeyState( VK_SCROLL ) );
}

HB_FUNC( _SETSCROLL )
{
   HWND hWnd = ( HWND ) hb_parnl( 1 );
   LONG nStyle;
   BOOL bChange = 0;

   nStyle = GetWindowLong( hWnd, GWL_STYLE );

   if( ISLOG( 2 ) )
   {
      if( hb_parl( 2 ) )
      {
         if( ! ( nStyle & WS_HSCROLL ) )
         {
            nStyle |= WS_HSCROLL;
            bChange = 1;
         }
      }
      else
      {
         if( nStyle & WS_HSCROLL )
         {
            nStyle = nStyle &~ WS_HSCROLL;
            bChange = 1;
            // Clears scroll range
            SetScrollRange( hWnd, SB_HORZ, 0, 0, 1 );
         }
      }
   }

   if( ISLOG( 3 ) )
   {
      if( hb_parl( 3 ) )
      {
         if( ! ( nStyle & WS_VSCROLL ) )
         {
            nStyle |= WS_VSCROLL;
            bChange = 1;
         }
      }
      else
      {
         if( nStyle & WS_VSCROLL )
         {
            nStyle = nStyle &~ WS_VSCROLL;
            bChange = 1;
            // Clears scroll range
            SetScrollRange( hWnd, SB_VERT, 0, 0, 1 );
         }
      }
   }

   if( bChange )
   {
      SetWindowLong( hWnd, GWL_STYLE, nStyle );
      SetWindowPos( hWnd, 0, 0, 0, 0, 0, SWP_NOSIZE | SWP_NOMOVE | SWP_NOZORDER | SWP_FRAMECHANGED | SWP_NOCOPYBITS | SWP_NOOWNERZORDER | SWP_NOSENDCHANGING );
   }

   hb_retni( nStyle );
}

HB_FUNC( SETSCROLLPAGE ) // ( hWnd, fnBar [ , size ] )
{
   HWND hWnd = ( HWND ) hb_parnl( 1 );
   int iType = hb_parni( 2 );
   SCROLLINFO pScrollInfo;
   int iPage;

   pScrollInfo.cbSize = sizeof( SCROLLINFO );
   pScrollInfo.fMask = SIF_PAGE | SIF_POS | SIF_RANGE | SIF_TRACKPOS;
   GetScrollInfo( hWnd, iType, &pScrollInfo );
   iPage = pScrollInfo.nPage;
   if( ISNUM( 3 ) )
   {
      pScrollInfo.fMask = SIF_PAGE;
      pScrollInfo.nPage = hb_parni( 3 );
      SetScrollInfo( hWnd, iType, &pScrollInfo, 1 );
   }

   hb_retni( iPage );
}

HB_FUNC( GETSCROLLRANGEMAX ) // ( hWnd, fnBar )
{
   int MinPos, MaxPos;

   GetScrollRange( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ), &MinPos, &MaxPos );
   hb_retni( MaxPos );
}

HB_FUNC( SETSCROLLINFO ) // ( hWnd, nMax, nPos, nPage, nMin )
{
	SCROLLINFO lpsi;
   lpsi.cbSize = sizeof( SCROLLINFO );
   lpsi.fMask = 0;
   if( ISNUM( 2 ) )
   {
      lpsi.fMask |= SIF_RANGE;
      lpsi.nMax = hb_parni( 2 );
   }
   if( ISNUM( 3 ) )
   {
      lpsi.fMask |= SIF_POS;
      lpsi.nPos = hb_parni( 3 );
   }
   if( ISNUM( 4 ) )
   {
      lpsi.fMask |= SIF_PAGE;
      lpsi.nPage = hb_parni( 4 );
   }
   if( ISNUM( 5 ) )
   {
      lpsi.fMask |= SIF_RANGE;
      lpsi.nMin = hb_parni( 5 );
   }
   if( lpsi.fMask )
   {
      hb_retni( SetScrollInfo( ( HWND ) hb_parnl( 1 ), SB_CTL, ( LPSCROLLINFO ) &lpsi, 1 ) );
   }
   else
   {
      hb_retni( 0 );
   }
}

#pragma ENDDUMP