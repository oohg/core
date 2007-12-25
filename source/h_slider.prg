/*
 * $Id: h_slider.prg,v 1.17 2007-12-25 02:47:14 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG slider functions
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

#include "oohg.ch"
#include "common.ch"
#include "hbclass.ch"
#include "i_windefs.ch"


CLASS TSlider FROM TControl
   DATA Type      INIT "SLIDER" READONLY
   DATA nRangeMin   INIT 0
   DATA nRangeMax   INIT 0

   METHOD Define
   METHOD Value               SETGET

   METHOD RangeMin            SETGET
   METHOD RangeMax            SETGET
   METHOD BackColor           SETGET
   METHOD Events_Hscroll
   METHOD Events_Vscroll
ENDCLASS




*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, LO, HI, value, tooltip, ;
               change, vertical, noticks, both, top, left, HelpId, invisible, ;
               notabstop, backcolor, lRtl, lDisabled ) CLASS TSlider
*-----------------------------------------------------------------------------*
Local ControlHandle, nStyle

   ASSIGN ::nCol        VALUE x  TYPE "N"
   ASSIGN ::nRow        VALUE y  TYPE "N"
   ASSIGN ::nWidth      VALUE w  TYPE "N"
   ASSIGN ::nHeight     VALUE h  TYPE "N"
   ASSIGN ::nRangeMin   VALUE Lo TYPE "N"
   ASSIGN ::nRangeMax   VALUE Hi TYPE "N"

   ASSIGN vertical VALUE vertical TYPE "L" DEFAULT .F.
   ASSIGN both     VALUE both     TYPE "L" DEFAULT .F.
   If ::nWidth == 0
      ::nWidth := if( vertical, 35 + if( both, 5, 0 ), 120 )
   Endif
   If ::nHeight == 0
      ::nHeight := if( vertical, 120, 35 + if( both, 5, 0 ) )
   Endif

   ::SetForm( ControlName, ParentForm, , , , BackColor, , lRtl )

    nStyle := ::InitStyle( ,, invisible, notabstop, lDisabled ) + ;
             if( HB_IsLogical( vertical ) .AND. vertical,   TBS_VERT,    0 ) + ;
             if( HB_IsLogical( noticks )     .AND. noticks,    TBS_NOTICKS, TBS_AUTOTICKS ) + ;
             if( HB_IsLogical( both )        .AND. both,       TBS_BOTH,    0 ) + ;
             if( HB_IsLogical( top )         .AND. top,        TBS_TOP,     0 ) + ;
             if( HB_IsLogical( left )       .AND. left,       TBS_LEFT,    0 )

   ControlHandle := InitSlider( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, ::RangeMin, ::RangeMax, nStyle, ::lRtl )

   ::Register( ControlHandle, ControlName, HelpId,, ToolTip )

   If HB_IsNumeric( value )
      ::Value := value
   Else
      ::Value := Int( ( ::RangeMax - ::RangeMin ) / 2 )
   EndIf

   ::OnChange   :=  Change

Return Self

*------------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TSlider
*------------------------------------------------------------------------------*
   IF HB_IsNumeric ( uValue )
      SendMessage( ::hWnd, TBM_SETPOS, 1, uValue )
      //// SendMessage( ::hwnd, WM_HSCROLL, TB_ENDTRACK,0)
      ::DoEvent( ::OnChange, "CHANGE" )
   ENDIF
RETURN SendMessage( ::hWnd, TBM_GETPOS, 0, 0 )

*------------------------------------------------------------------------------*
METHOD RangeMin( uValue ) CLASS TSlider
*------------------------------------------------------------------------------*
   IF HB_IsNumeric ( uValue )
      ::nRangeMin := uValue
      If ValidHandler( ::hWnd )
         SetSliderRange( ::hWnd, uValue, ::nRangeMax )
      EndIf
   ENDIF
RETURN ::nRangeMin

*------------------------------------------------------------------------------*
METHOD RangeMax( uValue ) CLASS TSlider
*------------------------------------------------------------------------------*
   IF HB_IsNumeric( uValue )
      ::nRangeMax := uValue
      If ValidHandler( ::hWnd )
         SetSliderRange( ::hWnd, ::nRangeMin, uValue )
      EndIf
   ENDIF
RETURN ::nRangeMax

*------------------------------------------------------------------------------*
METHOD BackColor( uValue ) CLASS TSlider
*------------------------------------------------------------------------------*
Local f
   IF HB_IsArray( uValue )
      ::Super:BackColor := uValue
      RedrawWindow( ::hWnd )
		f := GetFocus()
      setfocus( ::hWnd )
      setfocus( f )
   ENDIF
RETURN ::Super:BackColor

*------------------------------------------------*
METHOD Events_Hscroll ( wParam )   CLASS TSlider
*------------------------------------------------*
IF loword( wParam ) == TB_ENDTRACK
   ::DoEvent( ::OnChange, "CHANGE" )
ELSE
  Return ::Super:Events_HScroll( wParam )
ENDIF
Return NIL

*-------------------------------------------------*
METHOD Events_Vscroll ( wParam )   CLASS TSlider
*-------------------------------------------------*
IF loword( wParam ) == TB_ENDTRACK
   ::DoEvent( ::OnChange, "CHANGE" )
ELSE
   Return ::Super:Events_VScroll( wParam )
ENDIF
Return NIL

#pragma BEGINDUMP

#ifndef _WIN32_IE
   #define _WIN32_IE 0x0400
#endif
#if ( _WIN32_IE < 0x0400 )
   #undef _WIN32_IE
   #define _WIN32_IE 0x0400
#endif

#include "hbapi.h"
#include <windows.h>
#include <commctrl.h>
#include "../include/oohg.h"

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

HB_FUNC( INITSLIDER )
{
   HWND hwnd, hbutton;
   int Style, StyleEx;

	INITCOMMONCONTROLSEX  i;
   i.dwSize = sizeof( INITCOMMONCONTROLSEX );
	i.dwICC = ICC_DATE_CLASSES;
   InitCommonControlsEx( &i );

   hwnd = HWNDparam( 1 );

   StyleEx = _OOHG_RTL_Status( hb_parl( 10 ) );

   Style = hb_parni( 9 ) | WS_CHILD;

   hbutton = CreateWindowEx( StyleEx, TRACKBAR_CLASS, 0,
      Style,
      hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ),
      hwnd, ( HMENU ) HWNDparam( 2 ), GetModuleHandle( NULL ), NULL );

   SendMessage( hbutton, TBM_SETRANGE, TRUE, MAKELONG( hb_parni( 7 ), hb_parni( 8 ) ) );

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( hbutton, GWL_WNDPROC, ( LONG ) SubClassFunc );

   HWNDret( hbutton );
}

HB_FUNC( SETSLIDERRANGE )
{
   SendMessage( HWNDparam( 1 ), TBM_SETRANGE, TRUE, MAKELONG( hb_parni( 2 ), hb_parni( 3 ) ) );
}

#pragma ENDDUMP
