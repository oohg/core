/*
 * $Id: h_scroll.prg,v 1.10 2006-05-30 02:25:40 guerra000 Exp $
 */
/*
 * ooHG source code:
 * Scrollbar functions
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
   DATA nRangeMin    INIT 1
   DATA nRangeMax    INIT 100
   DATA OnLineUp     INIT nil
   DATA OnLineDown   INIT nil
   DATA OnPageUp     INIT nil
   DATA OnPageDown   INIT nil
   DATA OnTop        INIT nil
   DATA OnBottom     INIT nil
   DATA OnThumb      INIT nil
   DATA OnTrack      INIT nil
   DATA OnEndTrack   INIT nil
   DATA nFactor      INIT 1
   DATA nLineSkip    INIT 1
   DATA nPageSkip    INIT 20
   DATA nOrient      INIT SB_VERT

   METHOD Define
   METHOD Value               SETGET
   METHOD RangeMin            SETGET
   METHOD RangeMax            SETGET
   METHOD SetRange

   METHOD OnLineLeft          SETGET
   METHOD OnLineRight         SETGET
   METHOD OnPageLeft          SETGET
   METHOD OnPageRight         SETGET
   METHOD OnLeft              SETGET
   METHOD OnRight             SETGET

   METHOD Events_VScroll
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, RangeMin, RangeMax, ;
               change, lineup, linedown, pageup, pagedown, top, bottom, ;
               thumb, track, endtrack, HelpId, invisible, ToolTip, lRtl, ;
               nOrient ) CLASS TScrollBar
*-----------------------------------------------------------------------------*
Local ControlHandle

   If ::nWidth == 0
      ::nWidth := GETVSCROLLBARWIDTH()
   EndIf
   If ::nHeight == 0
      ::nHeight := GETHSCROLLBARHEIGHT()
   EndIf
   ASSIGN ::nWidth    VALUE w         TYPE "N"
   ASSIGN ::nHeight   VALUE h         TYPE "N"
   ASSIGN invisible   VALUE invisible TYPE "L" DEFAULT .F.
   ASSIGN ::nRangeMin VALUE RangeMin  TYPE "N"
   ASSIGN ::nRangeMax VALUE RangeMax  TYPE "N"
   ASSIGN ::nRow      VALUE y         TYPE "N"
   ASSIGN ::nCol      VALUE x         TYPE "N"
   ASSIGN ::nOrient   VALUE nOrient   TYPE "N" DEFAULT SB_VERT

   ::SetForm( ControlName, ParentForm,,,,,, lRtl )

   ControlHandle := InitScrollBar( ::ContainerhWnd, ::ContainerCol, ::ContainerRow, ::nWidth, ::nHeight, ::lRtl, ::nOrient )

   ::Register( ControlHandle, ControlName, HelpId, ! invisible, ToolTip, ControlHandle )

   ::SetRange( ::nRangeMin, ::nRangeMax )
   SetScrollRange( ::hWnd, ::ScrollType, ::nRangeMin, ::nRangeMax, 1 )

   ASSIGN ::OnChange   VALUE change   TYPE "B"
   ASSIGN ::OnLineUp   VALUE lineup   TYPE "B"
   ASSIGN ::OnLineDown VALUE linedown TYPE "B"
   ASSIGN ::OnPageUp   VALUE pageup   TYPE "B"
   ASSIGN ::OnPageDown VALUE pagedown TYPE "B"
   ASSIGN ::OnTop      VALUE top      TYPE "B"
   ASSIGN ::OnBottom   VALUE bottom   TYPE "B"
   ASSIGN ::OnThumb    VALUE thumb    TYPE "B"
   ASSIGN ::OnTrack    VALUE track    TYPE "B"
   ASSIGN ::OnEndTrack VALUE endtrack TYPE "B"

Return Self

*-----------------------------------------------------------------------------*
METHOD Value( nValue ) CLASS TScrollBar
*-----------------------------------------------------------------------------*
   if valtype( nValue ) == "N"
      SetScrollPos( ::hWnd, ::ScrollType, nValue / ::nFactor, 1 )
   endif
Return GetScrollPos( ::hWnd, ::ScrollType ) * ::nFactor

*-----------------------------------------------------------------------------*
METHOD RangeMin( nValue ) CLASS TScrollBar
*-----------------------------------------------------------------------------*
   ::SetRange( nValue, ::nRangeMax )
Return ::nRangeMin

*-----------------------------------------------------------------------------*
METHOD RangeMax( nValue ) CLASS TScrollBar
*-----------------------------------------------------------------------------*
   ::SetRange( ::nRangeMin, nValue )
Return ::nRangeMax

*-----------------------------------------------------------------------------*
METHOD SetRange( nRangeMin, nRangeMax ) CLASS TScrollBar
*-----------------------------------------------------------------------------*
LOCAL nMax
   If ValType( nRangeMin ) == "N" .OR. ValType( nRangeMax ) == "N"
      ASSIGN ::nRangeMin VALUE nRangeMin TYPE "N"
      ASSIGN ::nRangeMax VALUE nRangeMax TYPE "N"
      nMax := MAX( ABS( ::nRangeMin ), ABS( ::nRangeMax ) )
*      If nMax > 32000
*         ::nFactor := INT( nMax / 32000 )
*      Else
*         ::nFactor := 1
*      EndIf
      SetScrollRange( ::hWnd, ::ScrollType, ::nRangeMin / ::nFactor, ::nRangeMax / ::nFactor, 1 )
   EndIf
Return nil

*-----------------------------------------------------------------------------*
METHOD OnLineLeft( bAction ) CLASS TScrollBar
*-----------------------------------------------------------------------------*
   If PCOUNT() > 0
      ::OnLineUp := bAction
   EndIf
Return ::OnLineUp

*-----------------------------------------------------------------------------*
METHOD OnLineRight( bAction ) CLASS TScrollBar
*-----------------------------------------------------------------------------*
   If PCOUNT() > 0
      ::OnLineDown := bAction
   EndIf
Return ::OnLineDown

*-----------------------------------------------------------------------------*
METHOD OnPageLeft( bAction ) CLASS TScrollBar
*-----------------------------------------------------------------------------*
   If PCOUNT() > 0
      ::OnPageUp := bAction
   EndIf
Return ::OnPageUp

*-----------------------------------------------------------------------------*
METHOD OnPageRight( bAction ) CLASS TScrollBar
*-----------------------------------------------------------------------------*
   If PCOUNT() > 0
      ::OnPageDown := bAction
   EndIf
Return ::OnPageDown

*-----------------------------------------------------------------------------*
METHOD OnLeft( bAction ) CLASS TScrollBar
*-----------------------------------------------------------------------------*
   If PCOUNT() > 0
      ::OnTop := bAction
   EndIf
Return ::OnTop

*-----------------------------------------------------------------------------*
METHOD OnRight( bAction ) CLASS TScrollBar
*-----------------------------------------------------------------------------*
   If PCOUNT() > 0
      ::OnBottom := bAction
   EndIf
Return ::OnBottom

*-----------------------------------------------------------------------------*
METHOD Events_VScroll( wParam ) CLASS TScrollBar
*-----------------------------------------------------------------------------*
Local Lo_wParam := LoWord( wParam )

   If Lo_wParam == SB_LINEDOWN         // .OR. Lo_wParam == SB_LINERIGHT
      _OOHG_EVAL( ::OnLineDown, Self )

   elseif Lo_wParam == SB_LINEUP       // .OR. Lo_wParam == SB_LINELEFT
      _OOHG_EVAL( ::OnLineUp, Self )

   elseif Lo_wParam == SB_PAGEUP       // .OR. Lo_wParam == SB_PAGELEFT
      _OOHG_EVAL( ::OnPageUp, Self )

   elseif Lo_wParam == SB_PAGEDOWN     // .OR. Lo_wParam == SB_PAGERIGHT
      _OOHG_EVAL( ::OnPageDown, Self )

   elseif Lo_wParam == SB_TOP          // .OR. Lo_wParam == SB_LEFT
      _OOHG_EVAL( ::OnTop, Self )

   elseif Lo_wParam == SB_BOTTOM       // .OR. Lo_wParam == SB_RIGHT
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

FUNCTION InitVScrollBar( hWnd, nCol, nRow, nWidth, nHeight, lRtl )
RETURN InitScrollBar( hWnd, nCol, nRow, nWidth, nHeight, lRtl, SB_VERT )

FUNCTION InitHScrollBar( hWnd, nCol, nRow, nWidth, nHeight, lRtl )
RETURN InitScrollBar( hWnd, nCol, nRow, nWidth, nHeight, lRtl, SB_HORZ )

EXTERN GetVScrollbarWidth, GetHScrollbarHeight, SetScrollPos, SetScrollPage
EXTERN SetScrollRange, GetScrollPos, IsScrollLockActive, _SetScroll
EXTERN InitScrollbar, SetScrollInfo, GetScrollRangeMax

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
HB_FUNC( INITSCROLLBAR )  // ( hWnd, nCol, nRow, nWidth, nHeight, lRtl, nType )
{
	HWND hwnd;
	HWND hscrollbar;
   int nType = hb_parni( 7 );
   int iStyle, iStyleEx;

	hwnd = (HWND) hb_parnl (1);

   iStyleEx = _OOHG_RTL_Status( hb_parl( 6 ) );

   iStyle = WS_CHILD | WS_VISIBLE;
   switch( nType )
   {
      case SB_HORZ:
         iStyle |= SBS_HORZ;
         break;

      case SB_VERT:
         iStyle |= SBS_VERT;
         break;
   }

   hscrollbar = CreateWindowEx( iStyleEx, "SCROLLBAR", "", iStyle,
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