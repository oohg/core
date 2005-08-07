/*
 * $Id: h_menu.prg,v 1.2 2005-08-07 05:14:37 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG menu functions
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

#include "minigui.ch"
#include "hbclass.ch"

STATIC _OOHG_xMenuActive := {}

CLASS TMenu FROM TControl
   DATA Type      INIT "MENU" READONLY
   DATA aItems    INIT {}
   DATA xId       INIT 0

   METHOD DefineMain
   METHOD DefinePopUp
   METHOD DefineContext
   METHOD DefineNotify
   METHOD DefineDropDown
   METHOD DefineItem

   METHOD AddControl(oCtrl)       BLOCK { |Self,oCtrl| AADD( ::aItems, oCtrl ) }
   METHOD DeleteControl(oCtrl)    BLOCK { |Self,oCtrl| ::Super:DeleteControl( oCtrl, ::aItems ) }
   METHOD Enabled     SETGET
   METHOD Checked     SETGET

   METHOD DefaultItem( nItem )    BLOCK { |Self,nItem| SetMenuDefaultItem( ::Container:hWnd, nItem ) }
ENDCLASS

*------------------------------------------------------------------------------*
METHOD Enabled( lEnabled ) CLASS TMenu
*------------------------------------------------------------------------------*
   IF VALTYPE( lEnabled ) == "L"
      IF lEnabled
         xEnableMenuItem( ::Container:hWnd, ::xId )
      ELSE
         xDisableMenuItem( ::Container:hWnd, ::xId )
      ENDIF
   ENDIF
RETURN ( xGetMenuEnabledState( ::Container:hWnd, ::xId ) == 1 )

*------------------------------------------------------------------------------*
METHOD Checked( lChecked ) CLASS TMenu
*------------------------------------------------------------------------------*
   IF VALTYPE( lChecked ) == "L"
      IF lChecked
         xCheckMenuItem( ::Container:hWnd, ::xId )
      ELSE
         xUncheckMenuItem( ::Container:hWnd, ::xId )
      ENDIF
   ENDIF
RETURN ( xGetMenuCheckState( ::Container:hWnd, ::xId ) == 1 )

*------------------------------------------------------------------------------*
METHOD DefineMain( Parent ) CLASS TMenu
*------------------------------------------------------------------------------*

   ::SetForm( , Parent )
   ::New( CreateMenu() )
   ::Type := "MAIN"

   SetMenu( ::Parent:hWnd, ::hWnd )

   // _OOHG_xMainMenu := Self

   AADD( _OOHG_xMenuActive, Self )

Return Self

*------------------------------------------------------------------------------*
METHOD DefinePopUp( Caption , Name ) CLASS TMenu
*------------------------------------------------------------------------------*

   ::SetContainer( ATAIL( _OOHG_xMenuActive ), Name )

   ::New( CreatePopupMenu(), Name )

   ::Type := "POPUP"

   ::xId := ::hWnd

   ::Caption := Caption

   AADD( _OOHG_xMenuActive, Self )

   AppendMenuPopup( ::Container:hWnd, ::hWnd, ::Caption )

Return Self

*------------------------------------------------------------------------------*
Function _EndMenuPopup()
*------------------------------------------------------------------------------*

   ASIZE( _OOHG_xMenuActive, LEN( _OOHG_xMenuActive ) - 1 )

Return Nil

*------------------------------------------------------------------------------*
METHOD DefineItem( caption , action , name , Image , checked ) CLASS TMenu
*------------------------------------------------------------------------------*
Local Controlhandle
Local id

   Id := _GetId()

   Controlhandle := AppendMenuString( ATAIL( _OOHG_xMenuActive ):hWnd, id, caption )

   if Valtype ( image ) != 'U'
      MenuItem_SetBitMaps( ATAIL( _OOHG_xMenuActive ):hWnd, Id, image, '' )
   EndIf

   ::SetContainer( ATAIL( _OOHG_xMenuActive ), Name )

   ::New( ControlHandle, Name, , , , Id )

   ::Type := "MENU"

   ::xId := ::Id

   ::OnClick := action

   ::Caption := Caption

   if checked == .t.
      xCheckMenuItem( ::Parent:hWnd, id )
   EndIf

Return Self

*------------------------------------------------------------------------------*
Function _DefineSeparator()
*------------------------------------------------------------------------------*

   AppendMenuSeparator( ATAIL( _OOHG_xMenuActive ):hWnd )

Return Nil

*------------------------------------------------------------------------------*
Function _EndMenu()
*------------------------------------------------------------------------------*
Local oMenu

   IF LEN( _OOHG_xMenuActive ) > 0
      oMenu := ATAIL( _OOHG_xMenuActive )
      IF oMenu:Type == "MAIN"
         SetMenu( oMenu:Parent:hWnd, oMenu:hWnd )
      ENDIF
      ASIZE( _OOHG_xMenuActive, LEN( _OOHG_xMenuActive ) - 1 )
   ENDIF

Return Nil

*------------------------------------------------------------------------------*
METHOD DefineContext( Parent ) CLASS TMenu
*------------------------------------------------------------------------------*

   ::SetForm( , Parent )

   ::New( CreatePopupMenu() )

   ::Type := "CONTEXT"

   ::Parent:ContextMenu := Self

   AADD( _OOHG_xMenuActive, Self )

Return Self

*------------------------------------------------------------------------------*
METHOD DefineNotify( Parent ) CLASS TMenu
*------------------------------------------------------------------------------*

   ::SetForm( , Parent )

   ::New( CreatePopupMenu() )

   ::Type := "CONTEXT"

   ::Parent:NotifyMenuHandle := ::hWnd

   AADD( _OOHG_xMenuActive, Self )

Return Self

*------------------------------------------------------------------------------*
METHOD DefineDropDown( Button , Parent ) CLASS TMenu
*------------------------------------------------------------------------------*

   ::SetForm( , Parent )

   ::New( CreatePopupMenu() )

   ::Type := "DROPDOWN"

   GetControlObject( Button, ::Parent:Name ):ContextMenu := Self

   AADD( _OOHG_xMenuActive, Self )

Return Self