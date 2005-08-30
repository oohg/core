/*
 * $Id: h_status.prg,v 1.5 2005-08-30 05:05:55 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG statusbar functions
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
#include "hbclass.ch"
#include "i_windefs.ch"

CLASS TMessageBar FROM TControl
   DATA Type      INIT "MESSAGEBAR" READONLY
   DATA aControls INIT {}

   METHOD SetClock
   METHOD SetKeybrd

   METHOD Define
   METHOD Item
   METHOD Events_Notify
   METHOD Events_Size
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, y, x, w, h, caption, ProcedureName, ;
               fontname, nFontsize, tooltip, clock, date, kbd, nClrF, nClrB, ;
               bold, italic, underline, strikeout, lTop ) CLASS TMessageBar
*-----------------------------------------------------------------------------*
Local ControlHandle

   EMPTY( nClrF )
   EMPTY( nClrB )
   y := x := 0

	if valtype (caption) == 'U'
      caption := ""
	EndIf
	if valtype (w) == 'U'
		w := 50
	EndIf
	if valtype (h) == 'U'
		h := 0
	EndIf

   ::SetForm( ControlName, ParentForm, FontName, nFontSize )
   ::Container := nil

   _OOHG_ActiveMessageBar := Self

//   ControlHandle := InitMessageBar( ::Parent:hWnd, Caption, 0, 0, 0, w , h, '', 0, clock, date, kbd  )
   ControlHandle := InitMessageBar( ::Parent:hWnd, Caption, 0, lTop  )

   ::New( ControlHandle, ControlName, , , ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )
   ::SizePos( y, x, w, h )

   ::OnClick := ProcedureName
   ::Caption := Caption

   // Re-defines first status item
   IF ! Empty( Caption )
      _DefineItemMessage( , , , , Caption, ProcedureName, w, h, , , tooltip )
   Endif

   IF VALTYPE( clock ) == "L" .AND. clock
      ::SetClock()
   ENDIF

   IF VALTYPE( kbd ) == "L" .AND. kbd
      ::SetKeybrd()
   ENDIF

   IF VALTYPE( date ) == "L" .AND. date
*      ::SetDate()
   ENDIF

Return Self
/*
AGREGAR: lTop!!!  acImages!!!
Function _EndStatusBar ( cParentForm, acCaptions, anWidths, acImages, abActions, acToolTips, anStyles, ;
            cFontName, nFontSize, lFontBold, lFontItalic, lFontUnderLine, lFontStrikeOut, lTop )
	nControlhandle := InitStatusBar (	nParentHandle	, ;
						nId		, ;
						acCaptions	, ;
						anWidths	, ;
						acImages	, ;
						acToolTips	, ;
						anStyles	, ;
						lTop		;
					)
*/

*-----------------------------------------------------------------------------*
METHOD SetClock( Width , ToolTip , action ) CLASS TMessageBar
*-----------------------------------------------------------------------------*
local nrItem

	If ValType (Width) == 'U'
		Width := 70
	EndIf
	If ValType (ToolTip) == 'U'
		ToolTip := 'Clock'
	EndIf
	If ValType (Action) == 'U'
		Action := ''
	EndIf

   nrItem := _DefineItemMessage ( "TimerBar",  _OOHG_ActiveMessageBar:Name, 0, 0, Time(), action , Width, 0, "" , ToolTip )

   TTimer():Define( 'StatusTimer' , ::Parent:Name , 1000 , { || ::Item( nrItem , Time() ) } )

Return Nil

*-----------------------------------------------------------------------------*
METHOD SetKeybrd( Width , ToolTip , action ) CLASS TMessageBar
*-----------------------------------------------------------------------------*
local nrItem1 , nrItem2 , nrItem3

	If ValType (Width) == 'U'
      Width := 45
	EndIf
	If ValType (ToolTip) == 'U'
		ToolTip := ''
	EndIf
	If ValType (Action) == 'U'
		Action := ''
	EndIf

/*
   nrItem1 := _DefineItemMessage( "TimerNum", _OOHG_ActiveMessageBar:Name, 0, 0, "Num", If ( empty (Action), {|| KeyToggle( VK_NUMLOCK ) }, Action ), Width + 20, 0, ;
                     if ( IsNumLockActive() , "zzz_led_on" , "zzz_led_off" ), "", ToolTip)

   nrItem2 := _DefineItemMessage( "TimerCaps", _OOHG_ActiveMessageBar:Name, 0, 0, "Caps", If ( empty (Action), {|| KeyToggle( VK_CAPITAL ) }, Action ), Width + 25, 0,;
                     if ( IsCapsLockActive() , "zzz_led_on" , "zzz_led_off" ), "", ToolTip)

   nrItem3 := _DefineItemMessage( "TimerInsert", _OOHG_ActiveMessageBar:Name, 0, 0, "Ins", If ( empty (Action), {|| KeyToggle( VK_INSERT ) }, Action ), Width + 10, 0,;
                     if ( IsInsertActive() , "zzz_led_on" , "zzz_led_off" ), "", ToolTip)
*/
   nrItem1 := _DefineItemMessage( "TimerNum", _OOHG_ActiveMessageBar:Name, 0, 0, "Num", If ( empty (Action), {|| KeyToggle( VK_NUMLOCK ) }, Action ), GetTextWidth( NIL, "Num", ::FontHandle ) + 36, 0, ;
                     if ( IsNumLockActive() , "zzz_led_on" , "zzz_led_off" ), "", ToolTip)

   nrItem2 := _DefineItemMessage( "TimerCaps", _OOHG_ActiveMessageBar:Name, 0, 0, "Caps", If ( empty (Action), {|| KeyToggle( VK_CAPITAL ) }, Action ), GetTextWidth( NIL, "Caps", ::FontHandle ) + 36, 0,;
                     if ( IsCapsLockActive() , "zzz_led_on" , "zzz_led_off" ), "", ToolTip)

   nrItem3 := _DefineItemMessage( "TimerInsert", _OOHG_ActiveMessageBar:Name, 0, 0, "Ins", If ( empty (Action), {|| KeyToggle( VK_INSERT ) }, Action ), GetTextWidth( NIL, "Ins", ::FontHandle ) + 36, 0,;
                     if ( IsInsertActive() , "zzz_led_on" , "zzz_led_off" ), "", ToolTip)

   TTimer():Define( 'StatusKeyBrd' , ::Parent:Name , 400 , ;
      {|| SetStatusItemIcon( ::hWnd, nrItem1 , if ( IsNumLockActive() , "zzz_led_on" , "zzz_led_off" ) ), ;
          SetStatusItemIcon( ::hWnd, nrItem2 , if ( IsCapsLockActive() , "zzz_led_on" , "zzz_led_off" ) ), ;
          SetStatusItemIcon( ::hWnd, nrItem3 , if ( IsInsertActive() , "zzz_led_on" , "zzz_led_off" ) ) } )

Return Nil

*-----------------------------------------------------------------------------*
METHOD Item( nItem, uValue ) CLASS TMessageBar
*-----------------------------------------------------------------------------*
   IF VALTYPE( uValue  ) $ "CM"
      ::aControls[ nItem ]:Caption := uValue
      SetItemBar( ::hWnd, uValue, nItem - 1 )
   ENDIF
RETURN ::aControls[ nItem ]:Caption

*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TMessageBar
*-----------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam )
Local x

   If nNotify == NM_CLICK

      DefWindowProc( ::hWnd, NM_CLICK, wParam, lParam )

      x := GetItemPos( lParam )

      x := ASCAN( ::aControls, { |o| o:hWnd == x + 1 } )

      if x != 0

         if ::aControls[ x ]:DoEvent( ::aControls[ x ]:OnClick )

            Return nil

         EndIf

      EndIf

   EndIf

Return ::Super:Events_Notify( wParam, lParam )

*-----------------------------------------------------------------------------*
METHOD Events_Size() CLASS TMessageBar
*-----------------------------------------------------------------------------*
   RefreshItemBar( ::hWnd, ::Parent:hWnd )
   IF LEN( ::aControls ) > 0
      ::aControls[ 1 ]:Width := GetItemWidth( ::hWnd, 1 )
   ENDIF
Return Super:Events_Size()

*-----------------------------------------------------------------------------*
Function _EndMessageBar()
*-----------------------------------------------------------------------------*

   _OOHG_ActiveMessageBar := nil

Return Nil

CLASS TItemMessage FROM TControl
   DATA Type      INIT "ITEMMESSAGE" READONLY

   METHOD SizePos
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD SizePos( Row, Col, Width, Height ) CLASS TItemMessage
*-----------------------------------------------------------------------------*
   IF VALTYPE( Row ) == "N"
      ::nRow := Row
   ENDIF
   IF VALTYPE( Col ) == "N"
      ::nCol := Col
   ENDIF
   IF VALTYPE( Width ) == "N"
      ::nWidth := Width
   ENDIF
   IF VALTYPE( Height ) == "N"
      ::nHeight := Height
   ENDIF
Return 0

*-----------------------------------------------------------------------------*
Function _DefineItemMessage ( ControlName, ParentControl, x, y, Caption, ProcedureName, w, h, icon, cstyl, tooltip )
*-----------------------------------------------------------------------------*
Local i , styl , nKey

Local ControlHandle
Local Self

*   if valtype (ParentControl) == 'U'
*      ParentControl := _OOHG_ActiveMessageBarName
*   EndIf
empty( parentcontrol )

   Self := TItemMessage():SetContainer( _OOHG_ActiveMessageBar, "" )
   IF VALTYPE( ControlName ) $ "CM" .AND. upper( alltrim( ControlName ) ) == "STATUSITEM" .AND. ::Parent:Control( "STATUSITEM" ) == nil
      ::Name := "STATUSITEM"
   ENDIF

	do case
	case valtype(cStyl) == "U"
           	styl := 0
	case Upper(cStyl) == "RAISED"
           	styl := 1
	case Upper(cStyl) == "FLAT"
           	styl := 2
	otherwise
		styl := 0
 	endcase

	if valtype(w) == "U"
		w := 70
	endif

	if valtype(h) == "U"
		h := 0
	endif

   If LEN( ::Container:aControls ) == 0
      ControlHandle := InitItemBar ( ::Container:hWnd, Caption, 0, 0, 0, Icon , ToolTip, styl )
	Else
      ControlHandle := InitItemBar ( ::Container:hWnd, Caption, 0, w, 1, Icon , ToolTip, styl )
	EndIf

   ::New( ControlHandle, ControlName, , , ToolTip )
   ::SizePos( y, x, w, h )

   ::OnClick := ProcedureName
   ::Caption := Caption

	Caption := Upper ( Caption )

   i := At( "&", Caption )

   IF i > 0 .AND. i < LEN( Caption )
      i := AT( Upper( SubStr( Caption, i + 1, 1 ) ), "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" )
      IF i > 0
         nKey := { VK_A, VK_B, VK_C, VK_D, VK_E, VK_F, VK_G, VK_H, ;
                   VK_I, VK_J, VK_K, VK_L, VK_M, VK_N, VK_O, VK_P, ;
                   VK_Q, VK_R, VK_S, VK_T, VK_U, VK_V, VK_W, VK_X, ;
                   VK_Y, VK_Z, VK_0, VK_1, VK_2, VK_3, VK_4, VK_5, ;
                   VK_6, VK_7, VK_8, VK_9 }[ i ]
         _DefineHotKey( ::Parent:Name, MOD_ALT, nKey , ProcedureName )
      ENDIF
   ENDIF

Return ControlHandle