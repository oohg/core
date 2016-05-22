/*
 * $Id: h_scroll.prg,v 1.26 2016-05-22 23:53:23 fyurisich Exp $
 */
/*
 * ooHG source code:
 * Scrollbar functions
 *
 * Copyright 2005-2016 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.oohg.org
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
   DATA FromhWnd     INIT 0
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
   DATA nLineSkip    INIT 0
   DATA nPageSkip    INIT 0
   DATA nOrient      INIT SB_VERT
   DATA lAutoMove    INIT .F.

   DATA ladjust  INIT .F.

   METHOD Define
   METHOD Value               SETGET
   METHOD RangeMin            SETGET
   METHOD RangeMax            SETGET
   METHOD SetRange
   METHOD Page                SETGET

   METHOD LineUp
   METHOD LineDown
   METHOD PageUp
   METHOD PageDown
   METHOD Top
   METHOD Bottom
   METHOD Thumb
   METHOD Track

   MESSAGE LineLeft  METHOD LineUp
   MESSAGE LineRight METHOD LineDown
   MESSAGE PageLeft  METHOD PageUp
   MESSAGE PageRight METHOD PageDown
   MESSAGE Left      METHOD Top
   MESSAGE Right     METHOD Bottom

   METHOD OnLineLeft          SETGET
   METHOD OnLineRight         SETGET
   METHOD OnPageLeft          SETGET
   METHOD OnPageRight         SETGET
   METHOD OnLeft              SETGET
   METHOD OnRight             SETGET

   METHOD Events_VScroll
   MESSAGE Events_HScroll METHOD Events_VScroll

   EMPTY( _OOHG_AllVars )
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, RangeMin, RangeMax, ;
               change, lineup, linedown, pageup, pagedown, top, bottom, ;
               thumb, track, endtrack, HelpId, invisible, ToolTip, lRtl, ;
               nOrient, lSubControl, value, lDisabled, nLineSkip, nPageSkip, ;
               lAutoMove ) CLASS TScrollBar
*-----------------------------------------------------------------------------*
Local ControlHandle, nStyle

   If ::nWidth == 0
      ::nWidth := GETVSCROLLBARWIDTH()
   EndIf
   If ::nHeight == 0
      ::nHeight := GETHSCROLLBARHEIGHT()
   EndIf
   ASSIGN ::nWidth    VALUE w         TYPE "N"
   ASSIGN ::nHeight   VALUE h         TYPE "N"
   ASSIGN ::nRangeMin VALUE RangeMin  TYPE "N"
   ASSIGN ::nRangeMax VALUE RangeMax  TYPE "N"
   ASSIGN ::nRow      VALUE y         TYPE "N"
   ASSIGN ::nCol      VALUE x         TYPE "N"
   ASSIGN ::nOrient   VALUE nOrient   TYPE "N" DEFAULT SB_VERT
   ASSIGN ::nLineSkip VALUE nLineSkip TYPE "N"
   ASSIGN ::nPageSkip VALUE nPageSkip TYPE "N"
   ASSIGN ::lAutoMove VALUE lAutoMove TYPE "L"

   ::SetForm( ControlName, ParentForm,,,,,, lRtl )

   nStyle := ::InitStyle( ,, Invisible, .T., lDisabled )

   If HB_IsLogical( lSubControl ) .AND. lSubControl
      ::ScrollType := ::nOrient
      ::Register( 0,             ControlName, HelpId,, ToolTip, 0 )
      ::FromhWnd := IF( ::Container != nil, ::Container:hWnd, ::ContainerhWnd )
   Else
      ::ScrollType := SB_CTL
      ControlHandle := InitScrollBar( ::ContainerhWnd, ::ContainerCol, ::ContainerRow, ::Width, ::Height, ::lRtl, ::nOrient, nStyle )
      ::Register( ControlHandle, ControlName, HelpId,, ToolTip, ControlHandle )
      ::FromhWnd := ControlHandle
   EndIf

   ::SetRange( ::nRangeMin, ::nRangeMax )
   SetScrollRange( ::FromhWnd, ::ScrollType, ::nRangeMin, ::nRangeMax, .T. )

   ::Value := value

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
   if HB_IsNumeric( nValue )
      SetScrollPos( ::FromhWnd, ::ScrollType, nValue / ::nFactor, .T. )
   endif
Return GetScrollPos( ::FromhWnd, ::ScrollType ) * ::nFactor

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
*LOCAL nMax
   If HB_IsNumeric( nRangeMin ) .OR. HB_IsNumeric( nRangeMax )
      ASSIGN ::nRangeMin VALUE nRangeMin TYPE "N"
      ASSIGN ::nRangeMax VALUE nRangeMax TYPE "N"
*      nMax := MAX( ABS( ::nRangeMin ), ABS( ::nRangeMax ) )
*      If nMax > 32000
*         ::nFactor := INT( nMax / 32000 )
*      Else
*         ::nFactor := 1
*      EndIf
      SetScrollRange( ::FromhWnd, ::ScrollType, ::nRangeMin / ::nFactor, ::nRangeMax / ::nFactor, .T. )
   EndIf
Return nil

*-----------------------------------------------------------------------------*
METHOD Page( nValue ) CLASS TScrollBar
*-----------------------------------------------------------------------------*
   if HB_IsNumeric( nValue )
      SetScrollPage( ::FromhWnd, ::ScrollType, nValue / ::nFactor )
   endif
Return SetScrollPage( ::FromhWnd, ::ScrollType ) * ::nFactor

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
METHOD LineUp() CLASS TScrollBar
*-----------------------------------------------------------------------------*
   If ::lAutoMove
      ::Value := ::Value - ::nLineSkip
   EndIf
   _OOHG_EVAL( ::OnLineUp, Self )
   ::DoChange()
Return Self

*-----------------------------------------------------------------------------*
METHOD LineDown() CLASS TScrollBar
*-----------------------------------------------------------------------------*
   If ::lAutoMove
      ::Value := ::Value + ::nLineSkip
   EndIf
   _OOHG_EVAL( ::OnLineDown, Self )
   ::DoChange()
Return Self

*-----------------------------------------------------------------------------*
METHOD PageUp() CLASS TScrollBar
*-----------------------------------------------------------------------------*
   If ::lAutoMove
      ::Value := ::Value - ::nPageSkip
   EndIf
   _OOHG_EVAL( ::OnPageUp, Self )
   ::DoChange()
Return Self

*-----------------------------------------------------------------------------*
METHOD PageDown() CLASS TScrollBar
*-----------------------------------------------------------------------------*
   If ::lAutoMove
      ::Value := ::Value + ::nPageSkip
   EndIf
   _OOHG_EVAL( ::OnPageDown, Self )
   ::DoChange()
Return Self

*-----------------------------------------------------------------------------*
METHOD Top() CLASS TScrollBar
*-----------------------------------------------------------------------------*
   If ::lAutoMove
      ::Value := ::nRangeMin
   EndIf
   _OOHG_EVAL( ::OnTop, Self )
   ::DoChange()
Return Self

*-----------------------------------------------------------------------------*
METHOD Bottom() CLASS TScrollBar
*-----------------------------------------------------------------------------*
   If ::lAutoMove
      ::Value := ::nRangeMax
   EndIf
   _OOHG_EVAL( ::OnBottom, Self )
   ::DoChange()
Return Self

*-----------------------------------------------------------------------------*
METHOD Thumb( nPos ) CLASS TScrollBar
*-----------------------------------------------------------------------------*
   If ::lAutoMove
      ::Value := nPos
   EndIf
   _OOHG_EVAL( ::OnThumb, Self, nPos )
   ::DoChange()
Return Self

*-----------------------------------------------------------------------------*
METHOD Track( nPos ) CLASS TScrollBar
*-----------------------------------------------------------------------------*
   If ::lAutoMove
      ::Value := nPos
   EndIf
   _OOHG_EVAL( ::OnTrack, Self, nPos )
   ::DoChange()
Return Self

*-----------------------------------------------------------------------------*
METHOD Events_VScroll( wParam ) CLASS TScrollBar
*-----------------------------------------------------------------------------*
Local Lo_wParam := LoWord( wParam )

   If Lo_wParam == SB_LINEDOWN         // .OR. Lo_wParam == SB_LINERIGHT

      ::LineDown()

   elseif Lo_wParam == SB_LINEUP       // .OR. Lo_wParam == SB_LINELEFT
      ::LineUp()

   elseif Lo_wParam == SB_PAGEUP       // .OR. Lo_wParam == SB_PAGELEFT

      ::PageUp()

   elseif Lo_wParam == SB_PAGEDOWN     // .OR. Lo_wParam == SB_PAGERIGHT
      ::PageDown()

   elseif Lo_wParam == SB_TOP          // .OR. Lo_wParam == SB_LEFT
      ::Top()

   elseif Lo_wParam == SB_BOTTOM       // .OR. Lo_wParam == SB_RIGHT
      ::Bottom()

   elseif Lo_wParam == SB_THUMBPOSITION
      ::Thumb( HiWord( wParam ) )

   elseif Lo_wParam == SB_THUMBTRACK
      ::Track( HiWord( wParam ) )

   elseif Lo_wParam == TB_ENDTRACK
      _OOHG_EVAL( ::OnEndTrack, Self, HiWord( wParam ) )
      ::DoChange()

   else
      Return ::Super:Events_VScroll( wParam )

   EndIf

Return nil

FUNCTION InitVScrollBar( hWnd, nCol, nRow, nWidth, nHeight, lRtl )
RETURN InitScrollBar( hWnd, nCol, nRow, nWidth, nHeight, lRtl, SB_VERT )

FUNCTION InitHScrollBar( hWnd, nCol, nRow, nWidth, nHeight, lRtl )
RETURN InitScrollBar( hWnd, nCol, nRow, nWidth, nHeight, lRtl, SB_HORZ )

EXTERN GetVScrollbarWidth, GetHScrollbarHeight, SetScrollPos, SetScrollPage
EXTERN SetScrollRange, GetScrollPos, IsScrollLockActive, _SetScroll
EXTERN InitScrollbar, SetScrollInfo, GetScrollRangeMin, GetScrollRangeMax

#pragma BEGINDUMP

#include <hbapi.h>
#include <windows.h>
#include <commctrl.h>
#include "oohg.h"

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

   hwnd = HWNDparam( 1 );

   iStyleEx = _OOHG_RTL_Status( hb_parl( 6 ) );

   iStyle = hb_parni( 8 ) | WS_CHILD;
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

   HWNDret( hscrollbar );
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
   hb_retni( SetScrollPos( HWNDparam( 1 ), hb_parni( 2 ), hb_parni( 3 ),
             hb_parl( 4 ) ) );
   #ifdef __MINGW32__                  // Macro correspondiente a MinGW... agregar con un or el de 64
      RedrawWindow( HWNDparam( 1 ), NULL, NULL,
         RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN |
         RDW_ERASENOW | RDW_UPDATENOW | RDW_FRAME
      );
   #endif
}

HB_FUNC( SETSCROLLRANGE ) // ( hWnd, fnBar, nRangeMin, nRangeMax, lRedraw )
{
   hb_retl( SetScrollRange( HWNDparam( 1 ), hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ), hb_parl( 5 ) ) );
}

HB_FUNC( GETSCROLLPOS ) // ( hWnd, fnBar )
{
   hb_retni( GetScrollPos( HWNDparam( 1 ), hb_parni( 2 ) ) );
}

HB_FUNC( ISSCROLLLOCKACTIVE )
{
   hb_retl( GetKeyState( VK_SCROLL ) );
}

HB_FUNC( _SETSCROLL )
{
   HWND hWnd = HWNDparam( 1 );
   LONG nStyle;
   BOOL bChange = 0;

   nStyle = GetWindowLong( hWnd, GWL_STYLE );

   if( HB_ISLOG( 2 ) )
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

   if( HB_ISLOG( 3 ) )
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
      SetWindowPos( hWnd, 0, 0, 0, 0, 0, SWP_NOACTIVATE | SWP_NOSIZE | SWP_NOMOVE | SWP_NOZORDER | SWP_FRAMECHANGED | SWP_NOCOPYBITS | SWP_NOOWNERZORDER | SWP_NOSENDCHANGING );
   }

   hb_retni( nStyle );
}

HB_FUNC( SETSCROLLPAGE ) // ( hWnd, fnBar [ , size ] )
{
   HWND hWnd = HWNDparam( 1 );
   int iType = hb_parni( 2 );
   SCROLLINFO pScrollInfo;
   int iPage;

   pScrollInfo.cbSize = sizeof( SCROLLINFO );
   pScrollInfo.fMask = SIF_PAGE | SIF_POS | SIF_RANGE | SIF_TRACKPOS;
   GetScrollInfo( hWnd, iType, &pScrollInfo );
   iPage = pScrollInfo.nPage;
   if( HB_ISNUM( 3 ) )
   {
      pScrollInfo.fMask = SIF_PAGE;
      pScrollInfo.nPage = hb_parni( 3 );
      SetScrollInfo( hWnd, iType, &pScrollInfo, 1 );
   }

   hb_retni( iPage );
}

HB_FUNC( GETSCROLLRANGEMIN ) // ( hWnd, fnBar )
{
   int MinPos, MaxPos;

   GetScrollRange( HWNDparam( 1 ), hb_parni( 2 ), &MinPos, &MaxPos );
   hb_retni( MinPos );
}

HB_FUNC( GETSCROLLRANGEMAX ) // ( hWnd, fnBar )
{
   int MinPos, MaxPos;

   GetScrollRange( HWNDparam( 1 ), hb_parni( 2 ), &MinPos, &MaxPos );
   hb_retni( MaxPos );
}

HB_FUNC( SETSCROLLINFO ) // ( hWnd, nMax, nPos, nPage, nMin )
{
   SCROLLINFO lpsi;

   lpsi.cbSize = sizeof( SCROLLINFO );
   lpsi.fMask = 0;
   if( HB_ISNUM( 2 ) )
   {
      lpsi.fMask |= SIF_RANGE;
      lpsi.nMax = hb_parni( 2 );
   }
   if( HB_ISNUM( 3 ) )
   {
      lpsi.fMask |= SIF_POS;
      lpsi.nPos = hb_parni( 3 );
   }
   if( HB_ISNUM( 4 ) )
   {
      lpsi.fMask |= SIF_PAGE;
      lpsi.nPage = hb_parni( 4 );
   }
   if( HB_ISNUM( 5 ) )
   {
      lpsi.fMask |= SIF_RANGE;
      lpsi.nMin = hb_parni( 5 );
   }
   if( lpsi.fMask )
   {
      hb_retni( SetScrollInfo( HWNDparam( 1 ), SB_VERT, ( LPSCROLLINFO ) &lpsi, TRUE ) );
   }
   else
   {
      hb_retni( 0 );
   }
}

#pragma ENDDUMP
