/*
 * $Id: h_listbox.prg,v 1.3 2005-08-18 04:07:28 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG listbox functions
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

CLASS TList FROM TControl
   DATA Type      INIT "LIST" READONLY

   METHOD Value             SETGET
   METHOD Events_Command

   METHOD AddItem(uValue)     BLOCK { |Self,uValue| ListBoxAddstring( ::hWnd, uValue ) }
   METHOD DeleteItem(nItem)   BLOCK { |Self,nItem| ListBoxDeleteString( ::hWnd, nItem ) }
   METHOD DeleteAllItems      BLOCK { | Self | ListBoxReset( ::hWnd ) }
   METHOD Item
   METHOD ItemCount           BLOCK { | Self | ListBoxGetItemCount( ::hWnd ) }
/*
   METHOD FontColor      SETGET
   METHOD BkColor        SETGET

*/

ENDCLASS

#define LBN_KILLFOCUS	5
#define LBN_SETFOCUS	4
#define LBN_DBLCLK	2
#define LBN_SELCHANGE	1

*-----------------------------------------------------------------------------*
Function _DefineListbox ( ControlName, ParentForm, x, y, w, h, rows, value, ;
			fontname, fontsize, tooltip, changeprocedure, ;
			dblclick, gotfocus, lostfocus, break, HelpId, ;
			invisible, notabstop, sort , bold, italic, ;
			underline, strikeout , backcolor , fontcolor , ;
			multiselect )
*-----------------------------------------------------------------------------*
Local ControlHandle
Local Self

   DEFAULT w               TO 120
   DEFAULT h               TO 120
   DEFAULT gotfocus        TO ""
   DEFAULT lostfocus       TO ""
   DEFAULT rows            TO {}
   DEFAULT value           TO 0
   DEFAULT changeprocedure TO ""
   DEFAULT dblclick        TO ""
   DEFAULT invisible       TO FALSE
   DEFAULT notabstop       TO FALSE
   DEFAULT sort            TO FALSE

   Self := if( multiselect, TListMulti(), TList() )

   ::SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor, .T. )

	if valtype(x) == "U" .or. valtype(y) == "U"

      If _OOHG_SplitLastControl == "TOOLBAR"
			Break := TRUE
		EndIf

			if multiselect == .t.
            ControlHandle := InitMultiListBox ( ::Parent:ReBarHandle, 0, x, y, w, h, fontname, fontsize, invisible, notabstop, sort )
			else
            ControlHandle := InitListBox ( ::Parent:ReBarHandle, 0 , 0 , 0 , w , h , '' , 0 , invisible , notabstop, sort )
			endif

         AddSplitBoxItem ( Controlhandle , ::Parent:ReBarHandle, w , break , , , , _OOHG_ActiveSplitBoxInverted )

         _OOHG_SplitLastControl   := "LISTBOX"

	Else

		if multiselect == .t.
         ControlHandle := InitMultiListBox ( ::Parent:hWnd, 0, x, y, w, h, fontname, fontsize, invisible, notabstop, sort )
		else
         ControlHandle := InitListBox ( ::Parent:hWnd , 0 , x , y , w , h , '' , 0 , invisible , notabstop, sort )
		endif

	endif

   ::New( ControlHandle, ControlName, HelpId, ! Invisible, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )
   ::SizePos( y, x, w, h )

   ::OnLostFocus := LostFocus
   ::OnGotFocus :=  GotFocus
   ::OnChange   :=  ChangeProcedure
   ::OnDblClick := dblclick

   AEVAL( rows, { |c| ListboxAddString( ControlHandle, c ) } )

	if multiselect == .t.
		if value <> Nil
			LISTBOXSETMULTISEL (ControlHandle,Value)
		endif
	else
		if value <> 0
			ListboxSetCurSel (ControlHandle,Value)
		endif
	endif

Return Nil

*------------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TList
*------------------------------------------------------------------------------*
   IF VALTYPE( uValue ) == "N"
      ListBoxSetCursel( ::hWnd, uValue )
   ENDIF
RETURN ListBoxGetCursel( ::hWnd )

*-----------------------------------------------------------------------------*
METHOD Events_Command( wParam ) CLASS TList
*-----------------------------------------------------------------------------*
Local Hi_wParam := HIWORD( wParam )

   if Hi_wParam == LBN_SELCHANGE

      ::DoEvent( ::OnChange )

      Return nil

   elseif Hi_wParam == LBN_DBLCLK

      ::DoEvent( ::OnDblClick )

      Return nil

   elseif Hi_wParam == LBN_KILLFOCUS

      ::DoEvent( ::OnLostFocus )

      Return nil

   elseif Hi_wParam == LBN_SETFOCUS

      ::DoEvent( ::OnGotFocus )

      Return nil

   EndIf

Return ::Super:Events_Command( wParam )

*-----------------------------------------------------------------------------*
METHOD Item( nItem, uValue ) CLASS TList
*-----------------------------------------------------------------------------*
   IF VALTYPE( uValue ) $ "CM"
      ListBoxDeleteString( ::hWnd, nItem )
      ListBoxInsertString( ::hWnd, uValue, nItem )
   ENDIF
Return ListBoxGetString( ::hWnd, nItem )





CLASS TListMulti FROM TList
   DATA Type      INIT "MULTILIST" READONLY

   METHOD Value   SETGET
ENDCLASS

*------------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TListMulti
*------------------------------------------------------------------------------*
   IF VALTYPE( uValue ) == "A"
      LISTBOXSETMULTISEL( ::hWnd, uValue )
   ELSEIF VALTYPE( uValue ) == "N"
      LISTBOXSETMULTISEL( ::hWnd, { uValue } )
   ENDIF
RETURN ListBoxGetMultiSel( ::hWnd )