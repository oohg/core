/*
 * $Id: h_hotkeybox.prg,v 1.14 2016-10-22 16:23:55 fyurisich Exp $
 */
/*
 * ooHG source code:
 * HotKeyBox control
 *
 * Copyright 2006-2016 Vicente Guerra <vicente@guerra.com.mx>
 * https://sourceforge.net/projects/oohg/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2016, http://www.harbour-project.org/
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
 * along with this software; see the file COPYING.  If not, write to
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

CLASS THotKeyBox FROM TLabel
   DATA Type            INIT "HOTKEYBOX" READONLY
   DATA nWidth          INIT 120
   DATA nHeight         INIT 40
   DATA lForceAlt       INIT .T.

   METHOD Define

   METHOD Value       SETGET

   EMPTY( _OOHG_AllVars )
ENDCLASS

*------------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, uValue, ;
               FontName, FontSize, ToolTip, ;
               uLostFocus, uGotFocus, uChange, uEnter, ;
               HelpId, bold, italic, underline, strikeout, ;
               BackColor, FontColor, invisible, notabstop, lRtl, ;
               lDisabled, lNoAlt ) CLASS THotKeyBox
*------------------------------------------------------------------------------*
Local ControlHandle, nStyle := 0, nStyleEx := 0

   ASSIGN ::nCol      VALUE x TYPE "N"
   ASSIGN ::nRow      VALUE y TYPE "N"
   ASSIGN ::nWidth    VALUE w TYPE "N"
   ASSIGN ::nHeight   VALUE h TYPE "N"
   If ValType( lNoAlt ) == "L"
      ::lForceAlt := ! lNoAlt
   EndIf

   ::SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor, .T., lRtl )

   nStyle += ::InitStyle( ,, Invisible, NoTabStop, lDisabled )

   ControlHandle := InitHotKeyBox( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, nStyle, ::lRtl, nStyleEx )

   ::Register( ControlHandle, ControlName, HelpId,, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   ::Value := uValue

   ASSIGN ::OnLostFocus VALUE uLostFocus TYPE "B"
   ASSIGN ::OnGotFocus  VALUE uGotFocus  TYPE "B"
   ASSIGN ::OnChange    VALUE uChange    TYPE "B"
   ASSIGN ::OnEnter     value uEnter     TYPE "B"

return Self

*------------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS THotKeyBox
*------------------------------------------------------------------------------*
Return HotKeyBoxValue( ::hWnd, uValue, ::lForceAlt )

#pragma BEGINDUMP
#include <hbapi.h>
#include <windows.h>
#include <commctrl.h>
#include <hbapiitm.h>
#include "oohg.h"

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

HB_FUNC( INITHOTKEYBOX )
{
   HWND hedit;        // Handle of the child window/control.
   int StyleEx;

   StyleEx = hb_parni( 9 ) | _OOHG_RTL_Status( hb_parl( 8 ) );

   InitCommonControls();

   // Creates the child control.
   hedit = CreateWindowEx( StyleEx,
                           HOTKEY_CLASS,
                           "",
                           ( WS_CHILD | hb_parni( 7 ) ),
                           hb_parni( 3 ),
                           hb_parni( 4 ),
                           hb_parni( 5 ),
                           hb_parni( 6 ),
                           HWNDparam( 1 ),
                           ( HMENU ) hb_parni( 2 ),
                           GetModuleHandle( NULL ),
                           NULL );

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( hedit, GWL_WNDPROC, ( LONG ) SubClassFunc );

   HWNDret( hedit );
}

HB_FUNC( HOTKEYBOXVALUE )
{
   HWND hWnd;
   PHB_ITEM pItem;
   int iValue, iKey, iMod;

   hWnd = HWNDparam( 1 );
   pItem = hb_param( 2, HB_IT_ANY );

   if( HB_IS_NUMERIC( pItem ) )
   {
      SendMessage( hWnd, HKM_SETHOTKEY, hb_itemGetNI( pItem ), 0 );
   }
   else if( HB_IS_ARRAY( pItem ) )
   {
      iKey = hb_arrayGetNI( pItem, 1 );
      iMod = hb_arrayGetNI( pItem, 2 );
      iMod = ( ( iMod & MOD_SHIFT   ) ? HOTKEYF_SHIFT   : 0 ) |
             ( ( iMod & MOD_CONTROL ) ? HOTKEYF_CONTROL : 0 ) |
             ( ( iMod & MOD_ALT     ) ? HOTKEYF_ALT     : 0 ) ;
      SendMessage( hWnd, HKM_SETHOTKEY, ( ( iKey & 0xFF ) | ( ( iMod & 0xFF ) << 8 ) ), 0 );
   }

   if( hb_parl( 3 ) )   // If force ALT...
   {
      SendMessage( hWnd, HKM_SETRULES, ( WPARAM ) HKCOMB_NONE | HKCOMB_S, ( LPARAM ) HOTKEYF_ALT );
   }

   iValue = SendMessage( hWnd, HKM_GETHOTKEY, 0, 0 );
   iKey = LOBYTE( LOWORD( iValue ) );
   iMod = HIBYTE( LOWORD( iValue ) );
   iMod = ( ( iMod & HOTKEYF_SHIFT   ) ? MOD_SHIFT   : 0 ) |
          ( ( iMod & HOTKEYF_CONTROL ) ? MOD_CONTROL : 0 ) |
          ( ( iMod & HOTKEYF_ALT     ) ? MOD_ALT     : 0 ) ;

   hb_reta( 2 );
   HB_STORNI( iKey, -1, 1 );
   HB_STORNI( iMod, -1, 2 );
}

#pragma ENDDUMP
