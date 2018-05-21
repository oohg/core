/*
 * $Id: h_scroll.prg $
 */
/*
 * ooHG source code:
 * Scrollbar control
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
#include "hbclass.ch"
#include "common.ch"
#include "i_windefs.ch"

CLASS TScrollBar FROM TControl

   DATA FromhWnd                  INIT 0
   DATA lAdjust                   INIT .F.
   DATA lAutoMove                 INIT .F.
   DATA nFactor                   INIT 1
   DATA nLineSkip                 INIT 0
   DATA nOrient                   INIT SB_VERT
   DATA nPageSkip                 INIT 0
   DATA nRangeMax                 INIT 100
   DATA nRangeMin                 INIT 1
   DATA OnBottom                  INIT NIL
   DATA OnEndTrack                INIT NIL
   DATA OnLineDown                INIT NIL
   DATA OnLineUp                  INIT NIL
   DATA OnPageDown                INIT NIL
   DATA OnPageUp                  INIT NIL
   DATA OnThumb                   INIT NIL
   DATA OnTop                     INIT NIL
   DATA OnTrack                   INIT NIL
   DATA ScrollType                INIT SB_CTL
   DATA Type                      INIT "SCROLLBAR" READONLY

   METHOD Bottom
   METHOD Define
   METHOD Events_VScroll
   METHOD LineDown
   METHOD LineUp
   METHOD OnLeft                  SETGET
   METHOD OnLineLeft              SETGET
   METHOD OnLineRight             SETGET
   METHOD OnPageLeft              SETGET
   METHOD OnPageRight             SETGET
   METHOD OnRight                 SETGET
   METHOD Page                    SETGET
   METHOD PageDown
   METHOD PageUp
   METHOD RangeMax                SETGET
   METHOD RangeMin                SETGET
   METHOD SetRange
   METHOD Thumb
   METHOD Top
   METHOD Track
   METHOD Value                   SETGET

   MESSAGE Events_HScroll         METHOD Events_VScroll
   MESSAGE Left                   METHOD Top
   MESSAGE LineLeft               METHOD LineUp
   MESSAGE LineRight              METHOD LineDown
   MESSAGE PageLeft               METHOD PageUp
   MESSAGE PageRight              METHOD PageDown
   MESSAGE Right                  METHOD Bottom

   ENDCLASS

METHOD Define( ControlName, ParentForm, x, y, w, h, RangeMin, RangeMax, ;
               change, lineup, linedown, pageup, pagedown, top, bottom, ;
               thumb, track, endtrack, HelpId, invisible, ToolTip, lRtl, ;
               nOrient, lSubControl, value, lDisabled, nLineSkip, nPageSkip, ;
               lAutoMove ) CLASS TScrollBar

   LOCAL ControlHandle, nStyle

   IF ::nWidth == 0
      ::nWidth := GETVSCROLLBARWIDTH()
   ENDIF
   IF ::nHeight == 0
      ::nHeight := GETHSCROLLBARHEIGHT()
   ENDIF
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

   IF HB_ISLOGICAL( lSubControl ) .AND. lSubControl
      ::ScrollType := ::nOrient
      ::Register( 0, ControlName, HelpId,, ToolTip, 0 )
      ::FromhWnd := IF( ::Container != NIL, ::Container:hWnd, ::ContainerhWnd )
   ELSE
      ::ScrollType := SB_CTL
      ControlHandle := InitScrollBar( ::ContainerhWnd, ::ContainerCol, ::ContainerRow, ::Width, ::Height, ::lRtl, ::nOrient, nStyle )
      ::Register( ControlHandle, ControlName, HelpId,, ToolTip, ControlHandle )
      ::FromhWnd := ControlHandle
   ENDIF

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

   RETURN Self

METHOD Value( nValue ) CLASS TScrollBar

   IF HB_ISNUMERIC( nValue )
      SetScrollPos( ::FromhWnd, ::ScrollType, nValue / ::nFactor, .T. )
   ENDIF

   RETURN GetScrollPos( ::FromhWnd, ::ScrollType ) * ::nFactor

METHOD RangeMin( nValue ) CLASS TScrollBar

   ::SetRange( nValue, ::nRangeMax )

   RETURN ::nRangeMin

METHOD RangeMax( nValue ) CLASS TScrollBar

   ::SetRange( ::nRangeMin, nValue )

   RETURN ::nRangeMax

METHOD SetRange( nRangeMin, nRangeMax ) CLASS TScrollBar

   *LOCAL nMax
   IF HB_ISNUMERIC( nRangeMin ) .OR. HB_ISNUMERIC( nRangeMax )
      ASSIGN ::nRangeMin VALUE nRangeMin TYPE "N"
      ASSIGN ::nRangeMax VALUE nRangeMax TYPE "N"
      * nMax := MAX( ABS( ::nRangeMin ), ABS( ::nRangeMax ) )
      * IF nMax > 32000
      *    ::nFactor := INT( nMax / 32000 )
      * ELSE
      *    ::nFactor := 1
      * ENDIF
      SetScrollRange( ::FromhWnd, ::ScrollType, ::nRangeMin / ::nFactor, ::nRangeMax / ::nFactor, .T. )
   ENDIF

   RETURN NIL

METHOD Page( nValue ) CLASS TScrollBar

   IF HB_ISNUMERIC( nValue )
      SetScrollPage( ::FromhWnd, ::ScrollType, nValue / ::nFactor )
   ENDIF

   RETURN SetScrollPage( ::FromhWnd, ::ScrollType ) * ::nFactor

METHOD OnLineLeft( bAction ) CLASS TScrollBar

   IF PCount() > 0
      ::OnLineUp := bAction
   ENDIF

   RETURN ::OnLineUp

METHOD OnLineRight( bAction ) CLASS TScrollBar

   IF PCount() > 0
      ::OnLineDown := bAction
   ENDIF

   RETURN ::OnLineDown

METHOD OnPageLeft( bAction ) CLASS TScrollBar

   IF PCount() > 0
      ::OnPageUp := bAction
   ENDIF

   RETURN ::OnPageUp

METHOD OnPageRight( bAction ) CLASS TScrollBar

   IF PCount() > 0
      ::OnPageDown := bAction
   ENDIF

   RETURN ::OnPageDown

METHOD OnLeft( bAction ) CLASS TScrollBar

   IF PCount() > 0
      ::OnTop := bAction
   ENDIF

   RETURN ::OnTop

METHOD OnRight( bAction ) CLASS TScrollBar

   IF PCount() > 0
      ::OnBottom := bAction
   ENDIF

   RETURN ::OnBottom

METHOD LineUp() CLASS TScrollBar

   LOCAL uRet

   IF ::lAutoMove
      ::Value := ::Value - ::nLineSkip
   ENDIF
   uRet := _OOHG_EVAL( ::OnLineUp, Self )
   ::DoChange()

   RETURN uRet

METHOD LineDown() CLASS TScrollBar

   LOCAL uRet

   IF ::lAutoMove
      ::Value := ::Value + ::nLineSkip
   ENDIF
   uRet := _OOHG_EVAL( ::OnLineDown, Self )
   ::DoChange()

   RETURN uRet

METHOD PageUp() CLASS TScrollBar

   LOCAL uRet

   IF ::lAutoMove
      ::Value := ::Value - ::nPageSkip
   ENDIF
   uRet := _OOHG_EVAL( ::OnPageUp, Self )
   ::DoChange()

   RETURN uRet

METHOD PageDown() CLASS TScrollBar

   LOCAL uRet

   IF ::lAutoMove
      ::Value := ::Value + ::nPageSkip
   ENDIF
   uRet := _OOHG_EVAL( ::OnPageDown, Self )
   ::DoChange()

   RETURN uRet

METHOD Top() CLASS TScrollBar

   LOCAL uRet

   IF ::lAutoMove
      ::Value := ::nRangeMin
   ENDIF
   uRet := _OOHG_EVAL( ::OnTop, Self )
   ::DoChange()

   RETURN uRet

METHOD Bottom() CLASS TScrollBar

   LOCAL uRet

   IF ::lAutoMove
      ::Value := ::nRangeMax
   ENDIF
   uRet := _OOHG_EVAL( ::OnBottom, Self )
   ::DoChange()

   RETURN uRet

METHOD Thumb( nPos ) CLASS TScrollBar

   LOCAL uRet

   IF ::lAutoMove
      ::Value := nPos
   ENDIF
   uRet := _OOHG_EVAL( ::OnThumb, Self, nPos )
   ::DoChange()

   RETURN uRet

METHOD Track( nPos ) CLASS TScrollBar

   LOCAL uRet

   IF ::lAutoMove
      ::Value := nPos
   ENDIF
   uRet := _OOHG_EVAL( ::OnTrack, Self, nPos )
   ::DoChange()

   RETURN uRet

METHOD Events_VScroll( wParam ) CLASS TScrollBar

   LOCAL Lo_wParam := LoWord( wParam )
   LOCAL uRet

   IF Lo_wParam == SB_LINEDOWN         // .OR. Lo_wParam == SB_LINERIGHT
      uRet := ::LineDown()

   ELSEIF Lo_wParam == SB_LINEUP       // .OR. Lo_wParam == SB_LINELEFT
      uRet := ::LineUp()

   ELSEIF Lo_wParam == SB_PAGEUP       // .OR. Lo_wParam == SB_PAGELEFT
      uRet := ::PageUp()

   ELSEIF Lo_wParam == SB_PAGEDOWN     // .OR. Lo_wParam == SB_PAGERIGHT
      uRet := ::PageDown()

   ELSEIF Lo_wParam == SB_TOP          // .OR. Lo_wParam == SB_LEFT
      uRet := ::Top()

   ELSEIF Lo_wParam == SB_BOTTOM       // .OR. Lo_wParam == SB_RIGHT
      uRet := ::Bottom()

   ELSEIF Lo_wParam == SB_THUMBPOSITION
      uRet := ::Thumb( HiWord( wParam ) )

   ELSEIF Lo_wParam == SB_THUMBTRACK
      uRet := ::Track( HiWord( wParam ) )

   ELSEIF Lo_wParam == TB_ENDTRACK
      uRet := _OOHG_EVAL( ::OnEndTrack, Self, HiWord( wParam ) )
      ::DoChange()

   ELSE
      RETURN ::Super:Events_VScroll( wParam )

   ENDIF

   RETURN uRet

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
