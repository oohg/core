/*
 * $Id: h_monthcal.prg,v 1.2 2005-08-11 05:16:06 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG monthcal functions
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
#include "common.ch"
#include "hbclass.ch"

CLASS TMonthCal FROM TControl
   DATA Type      INIT "MONTHCAL" READONLY

   METHOD Value            SETGET
   METHOD Events_Notify
ENDCLASS

#define MCN_FIRST           -750
#define MCN_LAST            -759
#define MCN_SELCHANGE       (MCN_FIRST + 1)
#define MCN_SELECT          (MCN_FIRST + 4)

*-----------------------------------------------------------------------------*
Function _DefineMonthCal ( ControlName, ParentForm, x, y, w, h, value, ;
                           fontname, fontsize, tooltip, notoday, notodaycircle, ;
                           weeknumbers, change, HelpId, invisible, notabstop, ;
                           bold, italic, underline, strikeout )
*-----------------------------------------------------------------------------*
Local Self

// AJ
Local aControlHandle

   DEFAULT value     TO date()
   DEFAULT change    TO ""
   DEFAULT bold      TO FALSE
   DEFAULT italic    TO FALSE
   DEFAULT underline TO FALSE
   DEFAULT strikeout TO FALSE

   Self := TMonthCal():SetForm( ControlName, ParentForm, FontName, FontSize )

	if valtype(fontname) != "U" .and. valtype(fontsize) != "U"
      aControlHandle := InitMonthCal ( ::Parent:hWnd, 0, x, y, w, h , fontname , fontsize , notoday , notodaycircle , weeknumbers, invisible, notabstop, bold, italic, underline, strikeout )
	Else
      aControlHandle := InitMonthCal ( ::Parent:hWnd, 0, x, y, w, h , _OOHG_DefaultFontName , _OOHG_DefaultFontSize , notoday , notodaycircle , weeknumbers, invisible, notabstop, bold, italic, underline, strikeout )
	endif

	w := GetWindowWidth ( aControlHandle[1] )
	h := GetWindowHeight ( aControlHandle[1] )

   ::New( aControlHandle[1], ControlName, HelpId, ! Invisible, ToolTip )
   ::SizePos( y, x, w, h )

   ::OnChange   :=  Change
   ::FontHandle  :=   aControlHandle[2]

   ::Value := value

Return Nil

*-----------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TMonthCal
*-----------------------------------------------------------------------------*
   IF ValType( uValue ) == "D"
      SetMonthCal( ::hWnd, year( uValue ), month( uValue ), day( uValue ) )
   ENDIF
Return SToD( StrZero( GetMonthCalYear( ::hWnd ), 4 ) + StrZero( GetMonthCalMonth( ::hWnd ) , 2 ) + StrZero( GetMonthCalDay( ::hWnd ), 2 ) )

*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TMonthCal
*-----------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam )

   If nNotify == MCN_SELECT

      ::DoEvent( ::OnChange )

      Return nil

   EndIf

Return ::Super:Events_Notify( wParam, lParam )