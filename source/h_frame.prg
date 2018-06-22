/*
 * $Id: h_frame.prg $
 */
/*
 * ooHG source code:
 * Frame control
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

CLASS TFrame FROM TControl

   DATA Type      INIT "FRAME" READONLY
   DATA nWidth    INIT 140
   DATA nHeight   INIT 140
   DATA TabHandle INIT 0

   METHOD Caption SETGET
   METHOD Define
   METHOD Events_Color

   ENDCLASS

METHOD Define( ControlName, ParentForm, y, x, w, h, caption, fontname, ;
               fontsize, opaque, bold, italic, underline, strikeout, ;
               backcolor, fontcolor, transparent, lRtl, invisible, lDisabled ) CLASS TFrame

   Local ControlHandle, nStyle
   Local oTab

   ASSIGN ::nCol      VALUE x           TYPE "N"
   ASSIGN ::nRow      VALUE y           TYPE "N"
   ASSIGN ::nWidth    VALUE w           TYPE "N"
   ASSIGN ::nHeight   VALUE h           TYPE "N"
   ASSIGN caption     VALUE caption     TYPE "CM" DEFAULT ""
   ASSIGN opaque      VALUE opaque      TYPE "L"  DEFAULT .F.
   ASSIGN transparent VALUE transparent TYPE "L"  DEFAULT .T.

   If opaque .AND. transparent
      MsgOOHGError( "OPAQUE and TRANSPARENT clauses can't be used simultaneously. Program terminated." )
   EndIf

   If valtype( caption ) == 'U'
      caption := ""
      fontname := "Arial"
      fontsize := 1
   EndIf

   ::SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor, , lRtl )

   nStyle := ::InitStyle( ,, Invisible, .T., lDisabled )

   Controlhandle := InitFrame( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, caption, opaque, ::lRtl, nStyle )

   ::Register( ControlHandle, ControlName )
   ::SetFont( , , bold, italic, underline, strikeout )

   IF _OOHG_LastFrame() == "TABPAGE" .AND. _OOHG_UsesVisualStyle()
      oTab := ATAIL( _OOHG_ActiveFrame )

      IF oTab:Parent:hWnd == ::Parent:hWnd
         ::TabHandle := ::Container:Container:hWnd
      ENDIF
   ENDIF

   ::Transparent := transparent
   ::Caption := Caption

   Return Self

METHOD Caption( cCaption ) CLASS TFrame

   Local cRet

   // Under XP, when caption is changed, part of the old text remains visible.
   cRet := ::Super:Caption( cCaption )
   If ::lVisible
      ::Visible := .F.
      ::Visible := .T.
   EndIf

   Return cRet

METHOD Events_Color( wParam, nDefColor ) CLASS TFrame

   Return Events_Color_InTab( Self, wParam, nDefColor )    // see h_controlmisc.prg


#pragma BEGINDUMP

#ifndef HB_OS_WIN_32_USED
   #define HB_OS_WIN_32_USED
#endif

#ifndef _WIN32_IE
   #define _WIN32_IE 0x0500
#endif
#if ( _WIN32_IE < 0x0500 )
   #undef _WIN32_IE
   #define _WIN32_IE 0x0500
#endif

#ifndef _WIN32_WINNT
   #define _WIN32_WINNT 0x0400
#endif
#if ( _WIN32_WINNT < 0x0400 )
   #undef _WIN32_WINNT
   #define _WIN32_WINNT 0x0400
#endif

#include <shlobj.h>
#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "winreg.h"
#include "tchar.h"
#include "oohg.h"

static WNDPROC lpfnOldWndProcA = 0;

static LRESULT APIENTRY SubClassFuncA( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProcA );
}

HB_FUNC( INITFRAME )
{
   HWND hwnd;
   HWND hbutton;
   int Style, StyleEx;

   hwnd = HWNDparam( 1 );

   Style = hb_parni( 10 ) | WS_CHILD | BS_GROUPBOX | BS_NOTIFY;
   StyleEx = _OOHG_RTL_Status( hb_parl( 9 ) );

   if ( ! hb_parl( 8 ) )   /* opaque */
   {
      StyleEx = StyleEx | WS_EX_TRANSPARENT;
   }

   hbutton = CreateWindowEx( StyleEx, "BUTTON", hb_parc( 7 ), Style,
             hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ),
             hwnd, ( HMENU ) hb_parni( 2 ), GetModuleHandle( NULL ), NULL );
   lpfnOldWndProcA = (WNDPROC) SetWindowLongPtr( hbutton, GWL_WNDPROC, (LONG_PTR) SubClassFuncA );

   HWNDret( hbutton );
}

#pragma ENDDUMP
