/*
 * $Id: h_checkbox.prg,v 1.1 2005-08-07 00:06:08 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG checkbox functions
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

#define BM_GETCHECK	240
#define BST_UNCHECKED	0
#define BST_CHECKED	1
#define BM_SETCHECK	241
#define BN_CLICKED 0
#include "minigui.ch"
#include "common.ch"
#include "hbclass.ch"

CLASS TCheckBox FROM TLabel
   DATA Type      INIT "CHECKBOX" READONLY
   DATA Picture   INIT ""

   METHOD Value       SETGET
   METHOD Events_Command
ENDCLASS
*-----------------------------------------------------------------------------*
Function _DefineCheckBox ( ControlName, ParentForm, x, y, Caption, Value, ;
                           fontname, fontsize, tooltip, changeprocedure, w, h,;
                           lostfocus, gotfocus, HelpId, invisible, notabstop , bold, italic, underline, strikeout , field  , backcolor , fontcolor , transparent )
*-----------------------------------------------------------------------------*
Local Self

// AJ
Local ControlHandle

   DEFAULT value           TO FALSE
   DEFAULT w               TO 100
   DEFAULT h               TO 28
   DEFAULT lostfocus       TO ""
   DEFAULT gotfocus        TO ""
   DEFAULT changeprocedure TO ""
   DEFAULT invisible       TO FALSE
   DEFAULT notabstop       TO FALSE

   Self := TCheckBox():SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor )

   Controlhandle := InitCheckBox ( ::Parent:hWnd, Caption, 0, x, y, '', 0 , w , h, invisible, notabstop )

   ::New( ControlHandle, ControlName, HelpId, ! Invisible, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )
   ::SizePos( y, x, w, h )

   ::Transparent :=   transparent
   ::OnLostFocus := LostFocus
   ::OnGotFocus :=  GotFocus
   ::OnChange   :=  ChangeProcedure
   ::Caption := Caption

   If ValType( Field ) == 'C' .AND. ! empty( Field )
      ::VarName := alltrim( Field )
      ::Block := &( "{ |x| if( PCount() == 0, " + Field + ", " + Field + " := x ) }" )
      Value := EVAL( ::Block )
	EndIf

   ::Value := value

	if valtype ( Field ) != 'U'
      aAdd ( ::Parent:BrowseList, Self )
	EndIf

Return Nil
*-----------------------------------------------------------------------------*
Function _DefineCheckButton ( ControlName, ParentForm, x, y, Caption, Value, ;
                              fontname, fontsize, tooltip, changeprocedure, ;
                              w, h, lostfocus, gotfocus, HelpId, invisible, ;
                              notabstop , bold, italic, underline, strikeout )
*-----------------------------------------------------------------------------*
Local Self

// AJ
Local ControlHandle

   DEFAULT value           TO FALSE
   DEFAULT w               TO 100
   DEFAULT h               TO 28
   DEFAULT lostfocus       TO ""
   DEFAULT gotfocus        TO ""
   DEFAULT changeprocedure TO ""
   DEFAULT invisible       TO FALSE
   DEFAULT notabstop       TO FALSE

   Self := TCheckBox():SetForm( ControlName, ParentForm, FontName, FontSize )

   Controlhandle := InitCheckButton ( ::Parent:hWnd, Caption, 0, x, y, '', 0 , w , h, invisible, notabstop )

   ::New( ControlHandle, ControlName, HelpId, ! Invisible, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )
   ::SizePos( y, x, w, h )

   ::OnLostFocus := LostFocus
   ::OnGotFocus :=  GotFocus
   ::OnChange   :=  ChangeProcedure
   ::Caption := Caption

   ::Value := value

Return Nil
*-----------------------------------------------------------------------------*
Function _DefineImageCheckButton ( ControlName, ParentForm, x, y, BitMap, ;
                                   Value, fontname, fontsize, tooltip, ;
                                   changeprocedure, w, h, lostfocus, gotfocus,;
                                   HelpId, invisible, notabstop )
*-----------------------------------------------------------------------------*
Local Self

// AJ
Local ControlHandle

   DEFAULT value           TO FALSE
   DEFAULT w               TO 100
   DEFAULT h               TO 28
   DEFAULT lostfocus       TO ""
   DEFAULT gotfocus        TO ""
   DEFAULT changeprocedure TO ""
   DEFAULT invisible       TO FALSE
   DEFAULT notabstop       TO FALSE

   Self := TCheckBox():SetForm( ControlName, ParentForm, FontName, FontSize )

   Controlhandle := InitImageCheckButton ( ::Parent:hWnd, "", 0, x, y, '', 0 , bitmap , w , h, invisible, notabstop )

   ::New( ControlHandle, ControlName, HelpId, ! Invisible, ToolTip )
   ::SetFont()
   ::SizePos( y, x, w, h )

   ::OnLostFocus := LostFocus
   ::OnGotFocus :=  GotFocus
   ::OnChange   :=  ChangeProcedure
   ::Picture  :=  BitMap

   ::Value := value

Return Nil

*------------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TCheckBox
*------------------------------------------------------------------------------*
   IF VALTYPE( uValue ) == "L"
      SendMessage( ::hWnd, BM_SETCHECK, if( uValue, BST_CHECKED, BST_UNCHECKED ), 0 )
   ELSE
      uValue := ( SendMessage( ::hWnd, BM_GETCHECK , 0 , 0 ) == BST_CHECKED )
   ENDIF
RETURN uValue

*------------------------------------------------------------------------------*
METHOD Events_Command( wParam ) CLASS TCheckBox
*------------------------------------------------------------------------------*
Local Hi_wParam := HIWORD( wParam )

   If Hi_wParam == BN_CLICKED

      ::DoEvent( ::OnChange )

      Return 0

   EndIf

Return ::Super:Events_Command( wParam )