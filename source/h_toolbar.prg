/*
 * $Id: h_toolbar.prg,v 1.12 2005-11-09 05:56:43 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG toolbar functions
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

STATIC _OOHG_ActiveToolBar := NIL    // Active toolbar

CLASS TToolBar FROM TControl
   DATA Type      INIT "TOOLBAR" READONLY
   DATA Break     INIT .F.

   METHOD Define
   METHOD Events_Size
   METHOD Events_Notify
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, caption, ProcedureName, ;
               fontname, fontsize, tooltip, flat, bottom, righttext, break, ;
               bold, italic, underline, strikeout, border, lRtl ) CLASS TToolBar
*-----------------------------------------------------------------------------*
Local ControlHandle
Local id

	if valtype (caption) == 'U'
		caption := ""
	EndIf

	if valtype (w) == 'U'
		w := 0
	EndIf

	if valtype (h) == 'U'
		h := 0
	EndIf

	If valtype (break) == 'U'
      break := iif(_OOHG_ActiveSplitBox , .f. , .t. )
   Endif

   ::SetForm( ControlName, ParentForm, FontName, FontSize,,,, lRtl )

   If ::Parent:Type == "X"
      MsgOOHGError("ToolBars Can't Be Defined Inside SplitChild Windows. Program terminated" )
	Endif

   _OOHG_ActiveToolBar := Self

   ::Break := break

	Id := _GetId()

   if _OOHG_ActiveSplitBox == .T.
      _OOHG_SplitForceBreak := .T.
	EndIf

   ControlHandle := InitToolBar( ::Parent:hWnd, Caption, id, 0, 0 ,w ,h, "" , 0 , flat , bottom , righttext , _OOHG_ActiveSplitBox , border , ::lRtl )

/*
Default nImageWidth	To -1
Default nImageHeight	To -1

	* Create Control
   aTemp := InitToolBar ( nParentWindowHandle , nId , w, h , lBorder , lFlat , lBottom , lRightText , _HMG_ActiveSplitBox , nImageWidth , nImageHeight , lStrictWidth )

	nControlHandle := atemp[1]
*/
   ::New( ControlHandle, ControlName, , , ToolTip, Id )
   ::SetFont( , , bold, italic, underline, strikeout )
   ::SizePos( y, x, w, h )

   ::OnClick := ProcedureName
   ::Caption := Caption

Return Self

*-----------------------------------------------------------------------------*
Function _EndToolBar()
*-----------------------------------------------------------------------------*
Local wBtn, hBtn, c  , ParentForm
Local Self

   Self := _OOHG_ActiveToolBar
   ParentForm := ::Parent:Name

   if _OOHG_ActiveSplitBox == .T.
      _AddToolBarToSpliBox ( ::Name , ::Break , ::Caption )
	else
      wBtn := _GetControlWidth (::Name, ParentForm )
      hBtn := _GetControlHeight (::Name, ParentForm )
      c    := GetControlHandle (::Name , ParentForm )
		MaxTextBtnToolBar( c, wBtn, hBtn)
	EndIf

   _OOHG_ActiveToolBar := nil

Return Nil

*-----------------------------------------------------------------------------*
METHOD Events_Size() CLASS TToolBar
*-----------------------------------------------------------------------------*

   SendMessage( ::hWnd, TB_AUTOSIZE , 0 , 0 )

RETURN ::Super:Events_Size()

*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TToolBar
*-----------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam )
Local ws, x, aPos

   If nNotify == TBN_DROPDOWN

      ws := GetButtonPos( lParam )

      x  := Ascan ( ::aControls, { |o| o:Id == ws } )

      IF x  > 0

         aPos:= {0,0,0,0}

         GetWindowRect( ::hWnd, aPos )

         ws := GetButtonBarRect( ::hWnd, ::aControls[ x ]:Position - 1 )

         TrackPopupMenu ( ::aControls[ x ]:ContextMenu:hWnd , aPos[1]+LoWord(ws) ,aPos[2]+HiWord(ws)+(aPos[4]-aPos[2]-HiWord(ws))/2 , ::hWnd )

      ENDIF

      Return nil

   ElseIf nNotify == TTN_NEEDTEXT

*msginfo("si")
      ws := GetButtonPos( lParam )

      x  := Ascan ( ::aControls, { |o| o:Id == ws } )

      IF x  > 0

         If VALTYPE( ::aControls[ x ]:ToolTip ) $ "CM"

            ShowToolButtonTip ( lParam , ::aControls[ x ]:ToolTip )

         Endif

      ENDIF

      Return nil

   EndIf

Return ::Super:Events_Notify( wParam, lParam )





CLASS TToolButton FROM TControl
   DATA Type      INIT "TOOLBUTTON" READONLY
   DATA Position  INIT 0
   DATA ContextMenu  INIT 0

   METHOD Define
   METHOD Value      SETGET
   METHOD Enabled    SETGET

   METHOD Events_Notify
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, x, y, Caption, ProcedureName, w, h, image, ;
               tooltip, gotfocus, lostfocus, flat, separator, autosize, ;
               check, group, dropdown, WHOLEDROPDOWN ) CLASS TToolButton
*-----------------------------------------------------------------------------*
Local i, nKey, ControlHandle, id, nPos

* Unused Parameters
Flat := NIL

   ::SetForm( ControlName, _OOHG_ActiveToolBar )

   If ValType( WHOLEDROPDOWN ) != "L"
      WHOLEDROPDOWN := .F.
   EndIf

   If valtype( ProcedureName ) == "B" .and. WHOLEDROPDOWN
      MsgOOHGError( "Action and WholeDropDown clauses can't be used simultaneously. Program terminated" )
	endif

	id := _GetId()

	if valtype(Caption) == "U"
		Caption := ""
	endif
	if valtype(w) == "U"
		w := 0
	endif
	if valtype(h) == "U"
		h := 0
	endif
	if valtype(lostfocus) == "U"
		lostfocus := ""
	endif
	if valtype(gotfocus) == "U"
      gotfocus := ""
	endif

	if valtype(caption) == "U"
		caption := ""
	endif

   ControlHandle := InitToolButton ( ::Container:hWnd, Caption, id , 0, 0, 0, 0, image , 0 , separator , autosize , check , group , dropdown , WHOLEDROPDOWN )

/*
   if valtype(image) $ "CM"
      if ControlHandle == 0
         MsgOOHGError ('ToolBar Button Image: ' + chr(34) + Image + chr(34) + ' Not Available. Program terminated' )
      EndIf
   EndIf
*/

   nPos := GetButtonBarCount ( ::Container:hWnd ) - if(separator,1,0)

   ::New( ControlHandle, ControlName, , , ToolTip, Id )
   ::SizePos( y, x, w, h )

   ::OnClick := ProcedureName
   ::Position  :=  nPos
   ::OnLostFocus := LostFocus
   ::OnGotFocus :=  GotFocus
   ::Caption := Caption

	Caption := Upper ( Caption )

	i := at ( '&' , Caption )

   If i > 0 .AND. i < LEN( Caption )

      i := AT( Upper( SubStr( Caption, i + 1, 1 ) ), "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" )
      IF i > 0
         nKey := { VK_A, VK_B, VK_C, VK_D, VK_E, VK_F, VK_G, VK_H, ;
                   VK_I, VK_J, VK_K, VK_L, VK_M, VK_N, VK_O, VK_P, ;
                   VK_Q, VK_R, VK_S, VK_T, VK_U, VK_V, VK_W, VK_X, ;
                   VK_Y, VK_Z, VK_0, VK_1, VK_2, VK_3, VK_4, VK_5, ;
                   VK_6, VK_7, VK_8, VK_9 }[ i ]
*         IF VALTYPE( Mnemonic ) != "B"
**            ProcedureName := {|| ( ::Value := Position , iif ( valtype( ::OnChange ) =='B' , Eval( ::OnChange ) , Nil ) ) }
*            ProcedureName := {|| ( oPage:SetFocus() , iif ( valtype( ::OnChange ) =='B' , Eval( ::OnChange ) , Nil ) ) }
*         ENDIF
         ::Parent:HotKey( nKey, MOD_ALT, ProcedureName )
      EndIf

	EndIf

Return Self

*-----------------------------------------------------------------------------*
Function _AddToolBarToSpliBox ( ControlName , break , Caption )
*-----------------------------------------------------------------------------*
Local c, w , wbtn , hbtn , MinWidth , MinHeight, oWnd

   oWnd := GetFormObject( _OOHG_ActiveSplitBoxParentFormName )

   c = GetControlHandle (ControlName , _OOHG_ActiveSplitBoxParentFormName )

   wBtn := _GetControlWidth (ControlName,ATail(_OOHG_ActiveForm):Name)
   hBtn := _GetControlHeight (ControlName,ATail(_OOHG_ActiveForm):Name)

	MaxTextBtnToolBar( c, wBtn, hBtn)

	w := GetSizeToolBar(c)

	MinWidth  := HiWord(w)
	MinHeight := LoWord(w)

	w := GetWindowWidth (c)

   AddSplitBoxItem ( c , oWnd:ReBarHandle, w , break , Caption, MinWidth, MinHeight , _OOHG_ActiveSplitBoxInverted )

Return Nil

*-----------------------------------------------------------------------------*
METHOD Value( lValue ) CLASS TToolButton
*-----------------------------------------------------------------------------*
   IF VALTYPE( lValue ) == "L"
      CheckButtonBar( ::Container:hWnd, ::Position - 1 , lValue )
   ENDIF
RETURN IsButtonBarChecked( ::Container:hWnd, ::Position - 1 )

*-----------------------------------------------------------------------------*
METHOD Enabled( lEnabled ) CLASS TToolButton
*-----------------------------------------------------------------------------*
   IF VALTYPE( lEnabled ) == "L"
      ::Super:Enabled := lEnabled
      IF lEnabled
         cEnableToolbarButton( ::Container:hWnd, ::Id )
      ELSE
         cDisableToolbarButton( ::Container:hWnd, ::Id )
      ENDIF
   ENDIF
RETURN ::Super:Enabled




*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TToolButton
*-----------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam )

   If nNotify == TTN_NEEDTEXT

         If VALTYPE( ::ToolTip ) $ "CM"

            ShowToolButtonTip ( lParam , ::ToolTip )

         Endif

      Return nil

   EndIf

Return ::Super:Events_Notify( wParam, lParam )