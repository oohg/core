/*
 * $Id: h_richeditbox.prg,v 1.14 2008-01-13 22:51:39 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG rich edit functions
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

CLASS TEditRich FROM TEdit
   DATA Type      INIT "RICHEDIT" READONLY
   DATA nWidth    INIT 120
   DATA nHeight   INIT 240

   METHOD Define
   METHOD BackColor   SETGET
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, value, fontname, ;
               fontsize, tooltip, maxlenght, gotfocus, change, lostfocus, ;
               readonly, break, HelpId, invisible, notabstop, bold, italic, ;
               underline, strikeout, field, backcolor, lRtl, lDisabled ) CLASS TEditRich
*-----------------------------------------------------------------------------*
Local ControlHandle, nStyle

   ASSIGN ::nWidth  VALUE w TYPE "N"
   ASSIGN ::nHeight VALUE h TYPE "N"
   ASSIGN ::nRow    VALUE y TYPE "N"
   ASSIGN ::nCol    VALUE x TYPE "N"

   // DEFAULT Maxlenght TO 64738

   ::SetForm( ControlName, ParentForm, FontName, FontSize, , BackColor, .T., lRtl )

   nStyle := ::InitStyle( ,, Invisible, NoTabStop, lDisabled ) + ;
             if( ValType( readonly ) == "L"  .AND. readonly,   ES_READONLY, 0 )

   ::SetSplitBoxInfo( Break, )
   ControlHandle := InitRichEditBox( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, nStyle, maxlenght, ::lRtl )

   ::Register( ControlHandle, ControlName, HelpId,, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   ::Value := ::SetVarBlock( Field, Value )

   ::BackColor := ::BackColor

   ::OnLostFocus := LostFocus
   ::OnGotFocus :=  GotFocus
   ::OnChange   :=  Change

Return Self

#pragma BEGINDUMP
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windows.h>
#include <commctrl.h>
#include <richedit.h>
#include "../include/oohg.h"

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

HB_FUNC( INITRICHEDITBOX )
{
   HWND hwnd;
   HWND hwndRE = 0;
   int Style, StyleEx ;

   StyleEx = WS_EX_CLIENTEDGE | _OOHG_RTL_Status( hb_parl( 9 ) );

   hwnd = HWNDparam( 1 );

   Style = ES_MULTILINE | ES_WANTRETURN | WS_CHILD | WS_VSCROLL | WS_HSCROLL | hb_parni( 7 );

   InitCommonControls();
   if ( LoadLibrary( "RichEd20.dll" ) )
   {
      hwndRE = CreateWindowEx( StyleEx, RICHEDIT_CLASS , (LPSTR) NULL,
              Style, hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ),
              hwnd, (HMENU) HWNDparam( 2 ), GetModuleHandle( NULL ), NULL );

      lpfnOldWndProc = ( WNDPROC ) SetWindowLong( hwndRE, GWL_WNDPROC, ( LONG ) SubClassFunc );
      SendMessage( hwndRE, EM_LIMITTEXT, ( WPARAM ) hb_parni( 8 ), 0 );
      SendMessage( hwndRE, EM_SETEVENTMASK, 0, ( LPARAM ) ENM_CHANGE );
   }

   HWNDret( hwndRE );
}

HB_FUNC_STATIC( TEDITRICH_BACKCOLOR )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &oSelf->lBackColor, ( hb_pcount() >= 1 ) ) )
   {
      if( ValidHandler( oSelf->hWnd ) )
      {
         if( oSelf->lBackColor != -1 )
         {
            SendMessage( oSelf->hWnd, EM_SETBKGNDCOLOR, 0, oSelf->lBackColor );
         }
         else
         {
            SendMessage( oSelf->hWnd, EM_SETBKGNDCOLOR, 0, GetSysColor( COLOR_WINDOW ) );
         }
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   // Return value was set in _OOHG_DetermineColorReturn()
}
#pragma ENDDUMP
