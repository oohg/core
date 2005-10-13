/*
 * $Id: h_datepicker.prg,v 1.6 2005-10-13 22:55:14 declan2005 Exp $
 */
/*
 * ooHG source code:
 * PRG date picker functions
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

CLASS TDatePick FROM TControl
   DATA Type      INIT "DATEPICK" READONLY

   METHOD Define
   METHOD Value            SETGET
   METHOD Events_Enter
   METHOD Events_Notify
ENDCLASS


*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, value, fontname, ;
               fontsize, tooltip, change, lostfocus, gotfocus, shownone, ;
               updown, rightalign, HelpId, invisible, notabstop, bold, ;
               italic, underline, strikeout, Field, Enter, lRtl ) CLASS TDatePick
*-----------------------------------------------------------------------------*
Local ControlHandle

   DEFAULT value     TO ctod ('  /  /  ')
   DEFAULT w         TO 120
   DEFAULT h         TO 24
   DEFAULT change    TO ""
   DEFAULT lostfocus TO ""
   DEFAULT gotfocus  TO ""
   DEFAULT invisible TO FALSE
   DEFAULT notabstop TO FALSE

   ::SetForm( ControlName, ParentForm, FontName, FontSize, , , .t. , lRtl )

   If ValType( Field ) $ 'CM' .AND. ! empty( Field )
      ::VarName := alltrim( Field )
      ::Block := &( "{ |x| if( PCount() == 0, " + Field + ", " + Field + " := x ) }" )
      Value := EVAL( ::Block )
	EndIf

   ControlHandle := InitDatePick ( ::ContainerhWnd, 0, x, y, w, h , '' , 0 , shownone , updown , rightalign, invisible, notabstop , ::lRtl )

	If Empty (Value)
		SetDatePickNull (ControlHandle)
	Else
		SetDatePick( ControlHandle ,year(value), month(value), day(value) )
	EndIf

   ::New( ControlHandle, ControlName, HelpId, ! Invisible, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )
   ::SizePos( y, x, w, h )

   ::OnClick := Enter
   ::OnLostFocus := LostFocus
   ::OnGotFocus :=  GotFocus
   ::OnChange   :=  Change

Return Self


*-----------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TDatePick
*-----------------------------------------------------------------------------*
   IF ValType( uValue ) == "D"
      SetDatePick( ::hWnd, year( uValue ), month( uValue ), day( uValue ) )
   ELSEIF PCOUNT() > 0
      SetDatePickNull( ::hWnd )
   ENDIF
Return SToD( StrZero( GetDatePickYear( ::hWnd ), 4 ) + StrZero( GetDatePickMonth( ::hWnd ), 2 ) + StrZero( GetDatePickDay( ::hWnd ), 2 ) )

*-----------------------------------------------------------------------------*
METHOD Events_Enter() CLASS TDatePick
*-----------------------------------------------------------------------------*

   ::DoEvent( ::OnClick )

   If _OOHG_ExtendedNavigation == .T.

      _SetNextFocus()

   EndIf

Return nil


*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TDatePick
*-----------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam )

   If nNotify == DTN_DATETIMECHANGE

      ::DoEvent( ::OnChange )

      Return nil

   EndIf

Return ::Super:Events_Notify( wParam, lParam )




CLASS TtimePick FROM TControl
   DATA Type      INIT "TIMEPICK" READONLY

      METHOD Define
      METHOD Value            SETGET
      METHOD Events_Enter
      METHOD Events_Notify
ENDCLASS


METHOD Define( ControlName, ParentForm, x, y, w, h, value, fontname, ;
               fontsize, tooltip, change, lostfocus, gotfocus, shownone, ;
               updown, rightalign, HelpId, invisible, notabstop, bold, ;
               italic, underline, strikeout, Field, Enter, lRtl ) CLASS TTimePick
*-----------------------------------------------------------------------------*
Local ControlHandle

   DEFAULT value     TO time()
   DEFAULT w         TO 120
   DEFAULT h         TO 24
   DEFAULT change    TO ""
   DEFAULT lostfocus TO ""
   DEFAULT gotfocus  TO ""
   DEFAULT invisible TO FALSE
   DEFAULT notabstop TO FALSE
////   DEFAULT cTimeFormat  TO "HH:mm:ss"

   ::SetForm( ControlName, ParentForm, FontName, FontSize, , , .t. , lRtl )

   If ValType( Field ) $ 'CM' .AND. ! empty( Field )
      ::VarName := alltrim( Field )
      ::Block := &( "{ |x| if( PCount() == 0, " + Field + ", " + Field + " := x ) }" )
      Value := EVAL( ::Block )
	EndIf

   ControlHandle := InitTimePick ( ::ContainerhWnd, 0, x, y, w, h , '' , 0 , shownone , updown , rightalign, invisible, notabstop , ::lRtl )

	If Empty (Value)
             SettimePick (ControlHandle,,VAL(left(TIME(),2)),VAL(SUBSTR(TIME(),4,2)),VAL( SUBSTR(TIME(),7,2) ))
	Else
             SetTimePick( ControlHandle ,VAL(left(Value,2)),VAL(SUBSTR(Value,4,2)),VAL( SUBSTR(Value,7,2 )) )
	EndIf

   ::New( ControlHandle, ControlName, HelpId, ! Invisible, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )
   ::SizePos( y, x, w, h )

   ::OnClick := Enter
   ::OnLostFocus := LostFocus
   ::OnGotFocus :=  GotFocus
   ::OnChange   :=  Change

Return Self


*-----------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TTimePick
*-----------------------------------------------------------------------------*
   IF ValType( uValue ) == "C"
      SetTimePick( ::hWnd ,VAL(left(uValue,2)),VAL(SUBSTR(uValue,4,2)),VAL( SUBSTR(uValue,7,2 )) )
   ELSEIF PCOUNT() > 0
      SettimePick (::hWnd,,VAL(left(TIME(),2)),VAL(SUBSTR(TIME(),4,2)),VAL( SUBSTR(TIME(),7,2) ))      
   ENDIF
Return StrZero(GetDatePickHour ( ::hWnd ), 2 ) + ":" + StrZero ( GetDatePickMinute ( ::hWnd ), 2 ) + ":" + StrZero ( GetDatePickSecond (::hWnd ), 2 )


*-----------------------------------------------------------------------------*
METHOD Events_Enter() CLASS TTimePick
*-----------------------------------------------------------------------------*

   ::DoEvent( ::OnClick )

   If _OOHG_ExtendedNavigation == .T.

      _SetNextFocus()

   EndIf

Return nil

*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TTimePick
*-----------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam )

   If nNotify == DTN_DATETIMECHANGE

      ::DoEvent( ::OnChange )

      Return nil

   EndIf

Return ::Super:Events_Notify( wParam, lParam )


