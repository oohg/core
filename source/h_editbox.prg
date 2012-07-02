/*
 * $Id: h_editbox.prg,v 1.20 2012-07-02 18:13:21 fyurisich Exp $
 */
/*
 * ooHG source code:
 * PRG editbox functions
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
#include "i_windefs.ch"
#include "hbclass.ch"

CLASS TEdit FROM TText
   DATA Type            INIT "EDIT" READONLY
   DATA nOnFocusPos     INIT -3

   METHOD Define
   METHOD LookForKey
   METHOD Events_Enter  BLOCK { || nil }
   METHOD Events

   EMPTY( _OOHG_AllVars )
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, value, fontname, ;
               fontsize, tooltip, maxlenght, gotfocus, change, lostfocus, ;
               readonly, break, HelpId, invisible, notabstop, bold, italic, ;
               underline, strikeout, field, backcolor, fontcolor, novscroll, ;
               nohscroll, lRtl, lNoBorder, OnFocusPos ) CLASS TEdit
*-----------------------------------------------------------------------------*
Local nStyle := ES_MULTILINE + ES_WANTRETURN, nStyleEx := 0

   DEFAULT h   TO 240
//   DEFAULT Maxlenght TO 64738

   nStyle += IF( HB_IsLogical( novscroll ) .AND. novscroll, ES_AUTOVSCROLL, WS_VSCROLL ) + ;
             IF( HB_IsLogical( nohscroll ) .AND. nohscroll, 0,              WS_HSCROLL )

   ::SetSplitBoxInfo( Break )

   ::Define2( ControlName, ParentForm, x, y, w, h, value, ;
              fontname, fontsize, tooltip, maxlenght, .f., ;
              lostfocus, gotfocus, change, nil, .f., HelpId, ;
              readonly, bold, italic, underline, strikeout, field, ;
              backcolor, fontcolor, invisible, notabstop, nStyle, lRtl, .F., ;
              nStyleEx, lNoBorder, OnFocusPos )
Return Self

*-----------------------------------------------------------------------------*
METHOD LookForKey( nKey, nFlags ) CLASS TEdit
*-----------------------------------------------------------------------------*
Local lDone
   lDone := ::Super:LookForKey( nKey, nFlags )
   If nKey == VK_ESCAPE .and. nFlags == 0
      lDone := .T.
   EndIf
Return lDone

#pragma BEGINDUMP

#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windows.h>
#include <commctrl.h>
#include "oohg.h"

#define s_Super s_TText

// oSelf->lAux[ 0 ] -> Client's area (width used by attached controls)

// -----------------------------------------------------------------------------
HB_FUNC_STATIC( TEDIT_EVENTS )   // METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TEdit
// -----------------------------------------------------------------------------
{
   HWND hWnd      = HWNDparam( 1 );
   UINT message   = ( UINT )   hb_parni( 2 );
   WPARAM wParam  = ( WPARAM ) hb_parni( 3 );
   LPARAM lParam  = ( LPARAM ) hb_parnl( 4 );
   PHB_ITEM pSelf = hb_stackSelfItem();

   switch( message )
   {
      case WM_KEYDOWN:
      case WM_UNDO:
         if( ( GetWindowLong( hWnd, GWL_STYLE ) & ES_READONLY ) == 0 )
         {
            HB_FUNCNAME( TEDIT_EVENTS2 )();
            break;
         }

      default:
         _OOHG_Send( pSelf, s_Super );
         hb_vmSend( 0 );
         _OOHG_Send( hb_param( -1, HB_IT_OBJECT ), s_Events );
         hb_vmPushLong( ( LONG ) hWnd );
         hb_vmPushLong( message );
         hb_vmPushLong( wParam );
         hb_vmPushLong( lParam );
         hb_vmSend( 4 );
         break;
   }
}

#pragma ENDDUMP

*------------------------------------------------------------------------------*
FUNCTION TEdit_Events2( hWnd, nMsg, wParam, lParam )
*------------------------------------------------------------------------------*
Local Self := QSelf()
Local cText

   // For multiline edit controls, CTRL+Z fires a WM_UNDO message,
   // but not for single line edit controls.

   If nMsg == WM_UNDO
      cText := ::Value
      ::Value := ::xUndo
      ::xUndo := cText
      Return 1
      
   ElseIf nMsg == WM_KEYDOWN .AND. wParam == VK_Z .AND. ;
          ( GetKeyFlagState() == MOD_CONTROL .OR. GetKeyFlagState() == MOD_CONTROL + MOD_SHIFT )
      Return 1

   Endif

Return ::Super:Events( hWnd, nMsg, wParam, lParam )
