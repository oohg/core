/*
 * $Id: h_tab.prg,v 1.2 2005-08-09 04:18:31 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG tab functions
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

#define TCN_SELCHANGE	(-551)

CLASS TTab FROM TControl
   DATA Type      INIT "TAB" READONLY
   DATA aPages    INIT {}
   DATA ImageList INIT 0

   METHOD Refresh
   METHOD Release
   METHOD SizePos
   METHOD Value               SETGET
   METHOD Enabled             SETGET
   METHOD Visible             SETGET

   METHOD Events_Notify

   METHOD AddPage
   METHOD AddControl
   METHOD DeleteControl
   METHOD DeletePage
   METHOD Caption
ENDCLASS

*-----------------------------------------------------------------------------*
Function _DefineTab ( ControlName, ParentForm, x, y, w, h, aCaptions, aPageMap, value, fontname, fontsize , tooltip , change , Buttons , Flat , HotTrack , Vertical , notabstop , aMnemonic , bold, italic, underline, strikeout , Images )
*-----------------------------------------------------------------------------*
*Local imageFlag := .F.
Local z
Local Self
Local Caption, Page, Image, Mnemonic

// AJ
Local ControlHandle

   Self := TTab():SetForm( ControlName, ParentForm, FontName, FontSize )

   IF VALTYPE( aCaptions ) != "A"
      aCaptions := {}
   ENDIF
   IF VALTYPE( aPageMap ) != "A"
      aPageMap := {}
   ENDIF
   IF VALTYPE( Images ) != "A"
      Images := {}
   ENDIF

/*
	For z := 1 To Len (Images)
		If ValType (Images[z]) == "C"
			ImageFlag := .T.
			Exit
		EndIf
	Next z

	If ImageFlag == .T. .And. IsXPThemeActive() == .T.

		For z := 1 To Len (aCaptions)

			If at ( '&' , aCaptions[z] ) != 0
				aCaptions[z] := Space(3) + aCaptions[z]
			EndIf

		Next z

	EndIf

   ControlHandle = InitTabControl( ::Parent:hWnd, 0, x, y, w, h , aCaptions, value, '', 0 , Buttons , Flat , HotTrack , Vertical , notabstop )

	If ImageFlag == .T.
      ::ImageList := AddtabBitMap ( ControlHandle , Images )
	EndIf
*/

   ControlHandle = InitTabControl( ::Parent:hWnd, 0, x, y, w, h , {}, value, '', 0 , Buttons , Flat , HotTrack , Vertical , notabstop )
   SetWindowPos( ControlHandle, 0, 0, 0, 0, 0, 3 )

   // Add page by page
   z := 1
   DO WHILE z <= LEN( aCaptions ) .AND. z <= LEN( aPageMap ) .AND. z <= LEN( Images )
      IF z <= LEN( Images ) .AND. VALTYPE( Images[ z ] ) == "C"
         Image := Images[ z ]
      ELSE
         Image := ""
      ENDIF
      IF z <= LEN( aCaptions ) .AND. VALTYPE( aCaptions[ z ] ) == "C"
         Caption := aCaptions[ z ]
      ELSE
         Caption := ""
      ENDIF
      IF z <= LEN( aPageMap ) .AND. VALTYPE( aPageMap[ z ] ) == "A"
         Page := aPageMap[ z ]
      ELSE
         Page := {}
      ENDIF
      IF z <= LEN( aMnemonic ) .AND. VALTYPE( aMnemonic[ z ] ) == "B"
         Mnemonic := aMnemonic[ z ]
      ELSE
         Mnemonic := nil
      ENDIF
      ::AddPage( z, Caption , Image, Page, Mnemonic )
      z++
   ENDDO

	if valtype(change) == "U"
		change := ""
	endif

   ::New( ControlHandle, ControlName, , , ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )
   ::SizePos( y, x, w, h )

   ::OnChange   :=  Change

   IF VALTYPE( value ) == "N"
      ::Value := value
   ELSE
      ::Value := 1
   ENDIF

Return Self

*-----------------------------------------------------------------------------*
METHOD Refresh() CLASS TTab
*-----------------------------------------------------------------------------*

   * Hide All Pages, except the selected one

   AEVAL( ::aPages, { |p| AEVAL( p:aControls, { |o| o:Visible := o:Visible } ) } )

Return Nil

*-----------------------------------------------------------------------------*
METHOD Release() CLASS TTab
*-----------------------------------------------------------------------------*
Local i

   IF ::ImageList != 0

      IMAGELIST_DESTROY ( ::ImageList )

   endif

   // Delete controls inside TAB
   FOR i := 1 TO LEN( ::aPages )
      do while LEN( ::aPages[ i ]:aControls ) != 0
         ::aPages[ i ]:aControls[ 1 ]:Release()
      enddo
   NEXT

Return ::Super:Release()

*-----------------------------------------------------------------------------*
METHOD SizePos( Row, Col, Width, Height ) CLASS TTab
*-----------------------------------------------------------------------------*

   ::Super:SizePos( Row, Col, Width, Height )

   AEVAL( ::aPages, { |p| AEVAL( p:aControls, { |o| o:SizePos() } ) } )

Return Nil

*-----------------------------------------------------------------------------*
METHOD Value( nValue ) CLASS TTab
*-----------------------------------------------------------------------------*
   IF VALTYPE( nValue ) == "N"

      TABCTRL_SETCURSEL( ::hWnd, nValue )

      ::Refresh()

   ENDIF

RETURN TABCTRL_GETCURSEL( ::hWnd )

*-----------------------------------------------------------------------------*
METHOD Enabled( lEnabled ) CLASS TTab
*-----------------------------------------------------------------------------*
LOCAL nPos
   IF VALTYPE( lEnabled ) == "L"
      ::Super:Enabled := lEnabled
      nPos := TabCtrl_GetCurSel( ::hWnd )
      IF nPos <= LEN( ::aPages ) .AND. nPos >= 1
         AEVAL( ::aPages[ nPos ]:aControls, { |o| o:Enabled := o:Enabled } )
      ENDIF
   ENDIF
RETURN ::Super:Enabled

*-----------------------------------------------------------------------------*
METHOD Visible( lVisible ) CLASS TTab
*-----------------------------------------------------------------------------*
LOCAL nPos
   IF VALTYPE( lVisible ) == "L"
      ::Super:Visible := lVisible
      nPos := TabCtrl_GetCurSel( ::hWnd )
      IF nPos <= LEN( ::aPages ) .AND. nPos >= 1
         AEVAL( ::aPages[ nPos ]:aControls, { |o| o:Visible := o:Visible } )
      ENDIF
   ENDIF
RETURN ::Super:Visible

*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TTab
*-----------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam )

   If nNotify == TCN_SELCHANGE

      ::Refresh()

      ::DoEvent( ::OnChange )

      Return 0

   EndIf

Return ::Super:Events_Notify( wParam, lParam )

*-----------------------------------------------------------------------------*
METHOD AddPage( Position , Caption , Image, aControls, Mnemonic ) CLASS TTab
*-----------------------------------------------------------------------------*
Local aImages, oPage, nPos, nKey

   IF VALTYPE( Position ) != "N" .OR. Position < 1 .OR. Position > LEN( ::aPages )
      Position := LEN( ::aPages ) + 1
   ENDIF

   If ValType( Image ) != 'C'
		Image := ''
	EndIf

   If ValType( Caption ) != 'C'
		Caption := ''
   Else
      IF ! EMPTY( Image ) .AND. IsXPThemeActive() .AND. At( '&' , Caption ) != 0
         Caption := Space( 3 ) + Caption
      ENDIF
	EndIf

   If ValType( aControls ) != 'A'
      aControls := {}
	EndIf

   If ValType( aControls ) != "A"
      aControls := {}
	EndIf

   oPage := TTabPage():SetContainer( Self )

   TABCTRL_INSERTITEM ( ::hWnd, Position - 1 , Caption )

   oPage:Caption   := Caption
   oPage:Picture   := Image
   oPage:aControls := aControls

   AADD( ::aPages, nil )
   AINS( ::aPages, Position )
   ::aPages[ Position ] := oPage

   aImages := {}
   AEVAL( ::aPages, { |o,i| AADD( aImages, o:Picture ), o:Position := i } )

   ::ImageList := AddtabBitMap( ::hWnd, aImages )

   nPos := At( '&' , Caption )

   IF nPos > 0 .AND. nPos < LEN( Caption )
      nPos := AT( Upper( SubStr( Caption, nPos + 1, 1 ) ), "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" )
      IF nPos > 0
         nKey := { VK_A, VK_B, VK_C, VK_D, VK_E, VK_F, VK_G, VK_H, ;
                   VK_I, VK_J, VK_K, VK_L, VK_M, VK_N, VK_O, VK_P, ;
                   VK_Q, VK_R, VK_S, VK_T, VK_U, VK_V, VK_W, VK_X, ;
                   VK_Y, VK_Z, VK_0, VK_1, VK_2, VK_3, VK_4, VK_5, ;
                   VK_6, VK_7, VK_8, VK_9 }[ nPos ]
         IF VALTYPE( Mnemonic ) != "B"
*            Mnemonic := {|| ( ::Value := Position , iif ( valtype( ::OnChange ) =='B' , Eval( ::OnChange ) , Nil ) ) }
            Mnemonic := {|| ( oPage:SetFocus() , iif ( valtype( ::OnChange ) =='B' , Eval( ::OnChange ) , Nil ) ) }
         ENDIF
         _DefineHotKey( ::Parent:Name, MOD_ALT , nKey , Mnemonic )
      ENDIF
   ENDIF

   ::Refresh()

Return Nil

*------------------------------------------------------------------------------*
Function _BeginTab( name , parent , row , col , w , h , value , f , s , tooltip , change , buttons , flat , hottrack , vertical , notabstop , bold, italic, underline, strikeout )
*------------------------------------------------------------------------------*
Local Self

	if valtype (value) == 'U'
		value := 1
	EndIf

   Self := _DefineTab ( name , parent , row , col , w , h , {}, {}, value, f, s , tooltip , change , buttons , flat , hottrack , vertical , notabstop , , bold, italic, underline, strikeout , {} )

   AADD( _OOHG_ActiveFrame, Self )

Return Self

*------------------------------------------------------------------------------*
Function _BeginTabPage ( caption , image )
*------------------------------------------------------------------------------*
Local oCtrl

   DO WHILE .T.
      IF LEN( _OOHG_ActiveFrame ) == 0
         EXIT
         // ERROR: No TAB started
      ENDIF
      oCtrl := ATAIL( _OOHG_ActiveFrame )
      IF oCtrl:Type == "TABPAGE"
         _EndTabPage()
         // ERROR: Last page not finished
         LOOP
      ELSEIF oCtrl:Type == "TAB"
         oCtrl:AddPage( /* Position */ , Caption , Image )
         AADD( _OOHG_ActiveFrame, ATAIL( oCtrl:aPages ) )
      ELSE
         // ERROR: No TAB started
      ENDIF
      exit
   ENDDO

Return Nil
*------------------------------------------------------------------------------*
Function _EndTabPage()
*------------------------------------------------------------------------------*
Local oCtrl

   IF LEN( _OOHG_ActiveFrame ) == 0
      Return nil
      // ERROR: No TAB started
   ENDIF
   oCtrl := ATAIL( _OOHG_ActiveFrame )
   IF oCtrl:Type == "TABPAGE"
      ASIZE( _OOHG_ActiveFrame, LEN( _OOHG_ActiveFrame ) - 1 )
   ELSE
      // ERROR: No TABPAGE started
   ENDIF

Return Nil

*------------------------------------------------------------------------------*
Function _EndTab()
*------------------------------------------------------------------------------*
Local oCtrl

   DO WHILE .T.
      IF LEN( _OOHG_ActiveFrame ) == 0
         EXIT
         // ERROR: No TAB started
      ENDIF
      oCtrl := ATAIL( _OOHG_ActiveFrame )
      IF oCtrl:Type == "TAB"
         ASIZE( _OOHG_ActiveFrame, LEN( _OOHG_ActiveFrame ) - 1 )
      ELSEIF oCtrl:Type == "TABPAGE"
         ASIZE( _OOHG_ActiveFrame, LEN( _OOHG_ActiveFrame ) - 1 )
         LOOP
         // ERROR: No TABPAGE finished
      ELSE
         // ERROR: No TAB started
      ENDIF
      exit
   ENDDO

Return Nil

*-----------------------------------------------------------------------------*
METHOD AddControl( oCtrl , PageNumber , Row , Col ) CLASS TTab
*-----------------------------------------------------------------------------*

   IF valtype( PageNumber ) != "N" .OR. PageNumber > LEN( ::aPages )
      PageNumber := LEN( ::aPages )
   ENDIF

   IF PageNumber < 1
      PageNumber := 1
   ENDIF

   IF valtype( Row ) != "N"
      Row := oCtrl:ContainerRow - ::ContainerRow
   ENDIF

   IF valtype( Col ) != "N"
      Col := oCtrl:ContainerCol - ::ContainerCol
   ENDIF

   ::aPages[ PageNumber ]:AddControl( oCtrl, Row, Col )

Return Nil

*-----------------------------------------------------------------------------*
METHOD DeletePage( Position ) CLASS TTab
*-----------------------------------------------------------------------------*
Local aImages, NewValue

   IF VALTYPE( Position ) != "N" .OR. Position < 1 .OR. Position > LEN( ::aPages )
      Position := LEN( ::aPages )
   ENDIF

   // Control Map

   ::aPages[ Position ]:Release()

   _OOHG_DeleteArrayItem( ::aPages, Position )

   // Images

   aImages := {}

   AEVAL( ::aPages, { |o,i| AADD( aImages, o:Picture ), o:Position := i } )

   ::ImageList := AddTabBitMap( ::hWnd, aImages )

   TabCtrl_DeleteItem( ::hWnd, Position - 1 )

   NewValue := Position - 1

   If NewValue == 0
      NewValue := 1
   EndIf

   TABCTRL_SETCURSEL ( ::hWnd, NewValue )

   ::Refresh()

Return Nil

*-----------------------------------------------------------------------------*
METHOD Caption( nColumn, uValue ) CLASS TTab
*-----------------------------------------------------------------------------*
   IF VALTYPE( uValue ) == "C"
      ::aPages[ nColumn ]:Caption := uValue
      SETTABCAPTION( ::hWnd, nColumn, uValue )
   ENDIF
Return ::aPages[ nColumn ]:Caption

*-----------------------------------------------------------------------------*
METHOD DeleteControl( oCtrl ) CLASS TTab
*-----------------------------------------------------------------------------*
Return AEVAL( ::aPages, { |o| o:DeleteControl( oCtrl ) } )






CLASS TTabPage FROM TControl
   DATA Type      INIT "TABPAGE" READONLY
   DATA Picture   INIT ""
   DATA aControls INIT {}
   DATA Position  INIT 0

   METHOD ContainerVisible

   METHOD AddControl
   METHOD Release
   METHOD SetFocus            BLOCK { |Self| ::Container:SetFocus() , ::Container:Value := ::Position , Self }
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD ContainerVisible() CLASS TTabPage
*-----------------------------------------------------------------------------*
Local lRet := .F.
   IF ::Super:ContainerVisible
      lRet := ( TabCtrl_GetCurSel( ::Container:hWnd ) == ::Position )
   ENDIF
RETURN lRet

*-----------------------------------------------------------------------------*
METHOD AddControl( oCtrl , Row , Col ) CLASS TTabPage
*-----------------------------------------------------------------------------*

   oCtrl:Visible := oCtrl:Visible

   AADD( ::aControls, oCtrl )

   oCtrl:Container := Self

   oCtrl:SizePos( Row, Col )

   oCtrl:Visible := oCtrl:Visible

Return Nil

*-----------------------------------------------------------------------------*
METHOD Release() CLASS TTabPage
*-----------------------------------------------------------------------------*

   AEVAL( ::aControls, { |o| o:Release() } )

RETURN nil