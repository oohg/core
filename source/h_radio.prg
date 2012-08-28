/*
 * $Id: h_radio.prg,v 1.31 2012-08-28 01:37:01 fyurisich Exp $
 */
/*
 * ooHG source code:
 * Radio button functions
 *
 * Copyright 2005-2011 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.oohg.org
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

CLASS TRadioGroup FROM TLabel
   DATA Type          INIT "RADIOGROUP" READONLY
   DATA TabStop       INIT .T.
   DATA IconWidth     INIT 19
   DATA nWidth        INIT 120
   DATA nHeight       INIT 25
   DATA aOptions      INIT {}
   DATA TabHandle     INIT 0
   DATA lHorizontal   INIT .F.
   DATA nSpacing      INIT nil

   METHOD RowMargin           BLOCK { |Self| - ::Row }
   METHOD ColMargin           BLOCK { |Self| - ::Col }

   METHOD Define
   METHOD SetFont
   METHOD Value               SETGET
   METHOD Enabled             SETGET
   METHOD SetFocus
   METHOD Visible             SETGET

   METHOD ItemCount           BLOCK { |Self| LEN( ::aOptions ) }
   METHOD AddItem
   METHOD InsertItem
   METHOD DeleteItem

   METHOD Caption
   METHOD AdjustResize

   EMPTY( _OOHG_AllVars )
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, aOptions, Value, fontname, ;
               fontsize, tooltip, change, width, spacing, HelpId, invisible, ;
               notabstop, bold, italic, underline, strikeout, backcolor, ;
               fontcolor, transparent, autosize, horizontal, lDisabled, lRtl, ;
               height ) CLASS TRadioGroup
*-----------------------------------------------------------------------------*
Local i, oItem

   ASSIGN ::nCol    VALUE x      TYPE "N"
   ASSIGN ::nRow    VALUE y      TYPE "N"
   ASSIGN ::nWidth  VALUE width  TYPE "N"
   ASSIGN ::nHeight VALUE height TYPE "N"

   ASSIGN ::lAutoSize   VALUE autosize    TYPE "L"
   ASSIGN ::lHorizontal VALUE horizontal  TYPE "L"
   ASSIGN ::Transparent VALUE transparent TYPE "L"

   ASSIGN ::nSpacing     VALUE Spacing    TYPE "N"
   If HB_IsNumeric( ::nSpacing )
      Spacing := ::nSpacing
   Else
      Spacing := IF( ::lHorizontal, ::nWidth, ::nHeight )
   EndIf

   If VALTYPE( NoTabStop ) == "L"
      ::TabStop := ! NoTabStop
   EndIf

   ::SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor,, lRtl )
   ::InitStyle( ,, Invisible, ! ::TabStop, lDisabled )
   ::Register( 0, , HelpId,, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   ::AutoSize := autosize

   ::aOptions := {}
   
   x := ::Col
   y := ::Row
   For i = 1 to len( aOptions )
      oItem := TRadioItem():Define( , Self, x, y, ::Width, ::Height, ;
               aOptions[ i ], .F., ( i == 1 ), ;
               ::AutoSize, ::Transparent, , , ;
               , , , , , , ;
               ::ToolTip, ::HelpId, , .T., ,  )
      AADD( ::aOptions, oItem )
      If ::lHorizontal
         x += Spacing
      Else
         y += Spacing
      EndIf
   Next

   ::Value := Value
   If ! HB_IsNumeric( Value ) .AND. LEN( ::aOptions ) > 0
      ::aOptions[ 1 ]:TabStop := .T.
   EndIf

   ASSIGN ::OnChange    VALUE Change    TYPE "B"

Return Self

*-----------------------------------------------------------------------------*
METHOD SetFont( FontName, FontSize, Bold, Italic, Underline, Strikeout ) CLASS TRadioGroup
*-----------------------------------------------------------------------------*
   AEVAL( ::aOptions, { |o| o:SetFont( FontName, FontSize, Bold, Italic, Underline, Strikeout ) } )
RETURN ::Super:SetFont( FontName, FontSize, Bold, Italic, Underline, Strikeout )

*-----------------------------------------------------------------------------*
METHOD Value( nValue ) CLASS TRadioGroup
*-----------------------------------------------------------------------------*
LOCAL I, lSetFocus
   If HB_IsNumeric( nValue )
      nValue := INT( nValue )
      lSetFocus := ( ASCAN( ::aOptions, { |o| o:hWnd == GetFocus() } ) > 0 )
      For I := 1 TO LEN( ::aOptions )
         ::aOptions[ I ]:Value := ( I == nValue )
      Next
      nValue := ::Value
      For I := 1 TO LEN( ::aOptions )
         ::aOptions[ I ]:TabStop := ( ::TabStop .AND. I == MAX( nValue, 1 ) )
      Next
      If lSetFocus
         If nValue > 0
            ::aOptions[ nValue ]:SetFocus()
         EndIf
      EndIf
      ::DoChange()
   EndIf
RETURN ASCAN( ::aOptions, { |o| o:Value } )

*-----------------------------------------------------------------------------*
METHOD Enabled( lEnabled ) CLASS TRadioGroup
*-----------------------------------------------------------------------------*
   If HB_IsLogical( lEnabled )
      ::Super:Enabled := lEnabled
      AEVAL( ::aControls, { |o| o:Enabled := o:Enabled } )
   EndIf
RETURN ::Super:Enabled

*-----------------------------------------------------------------------------*
METHOD SetFocus() CLASS TRadioGroup
*-----------------------------------------------------------------------------*
Local nValue
   nValue := ::Value
   If nValue >= 1 .AND. nValue <= Len( ::aOptions )
      ::aOptions[ nValue ]:SetFocus()
   Else
      ::aOptions[ 1 ]:SetFocus()
   EndIf
Return Self

*-----------------------------------------------------------------------------*
METHOD Visible( lVisible ) CLASS TRadioGroup
*-----------------------------------------------------------------------------*
   If HB_IsLogical( lVisible )
      ::Super:Visible := lVisible
      If lVisible
         AEVAL( ::aControls, { |o| o:Visible := o:Visible } )
      Else
         AEVAL( ::aControls, { |o| o:ForceHide() } )
      EndIf
   EndIf
RETURN ::lVisible

*-----------------------------------------------------------------------------*
METHOD AddItem( cCaption ) CLASS TRadioGroup
*-----------------------------------------------------------------------------*
Return ::InsertItem( ::ItemCount + 1, cCaption )

*-----------------------------------------------------------------------------*
METHOD InsertItem( nPosition, cCaption ) CLASS TRadioGroup
*-----------------------------------------------------------------------------*
Local nPos2, Spacing, oItem, x, y, nValue, hWnd
   nValue := ::Value

   If HB_IsNumeric( ::nSpacing )
      Spacing := ::nSpacing
   Else
      Spacing := IF( ::lHorizontal, ::nWidth, ::nHeight )
   EndIf

   nPosition := INT( nPosition )
   If nPosition < 1 .OR. nPosition > LEN( ::aOptions )
      nPosition := LEN( ::aOptions ) + 1
   EndIf

   AADD( ::aOptions, nil )
   AINS( ::aOptions, nPosition )
   nPos2 := LEN( ::aOptions )
   DO WHILE nPos2 > nPosition
      If ::lHorizontal
         ::aOptions[ nPos2 ]:Col += Spacing
      Else
         ::aOptions[ nPos2 ]:Row += Spacing
      EndIf
      nPos2--
   ENDDO

   If nPosition == 1
      x := ::Col
      y := ::Row
      If LEN( ::aOptions ) > 1
         WindowStyleFlag( ::aOptions[ 2 ]:hWnd, WS_GROUP, 0 )
      EndIf
   Else
      x := ::aOptions[ nPosition - 1 ]:Col
      y := ::aOptions[ nPosition - 1 ]:Row
      If ::lHorizontal
         x += Spacing
      Else
         y += Spacing
      EndIf
   EndIf
   oItem := TRadioItem():Define( , Self, x, y, ::Width, ::Height, ;
            cCaption, .F., ( nPosition == 1 ), ;
            ::AutoSize, ::Transparent, , , ;
            , , , , , , ;
            ::ToolTip, ::HelpId, , .T., ,  )
   ::aOptions[ nPosition ] := oItem

   If nPosition > 1
      SetWindowPos( oItem:hWnd, ::aOptions[ nPosition - 1 ]:hWnd, 0, 0, 0, 0, 3 )
   ElseIf LEN( ::aOptions ) >= 2
      hWnd:= GetWindow( ::aOptions[ 2 ]:hWnd, GW_HWNDPREV )
      SetWindowPos( oItem:hWnd, hWnd, 0, 0, 0, 0, 3 )
   Endif

   If nValue >= nPosition
      ::Value := ::Value
   EndIf
Return nil

*-----------------------------------------------------------------------------*
METHOD DeleteItem( nItem ) CLASS TRadioGroup
*-----------------------------------------------------------------------------*
Local nValue
   nItem := INT( nItem )
   If nItem >= 1 .AND. nItem <= LEN( ::aOptions )
      nValue := ::Value
      ::aOptions[ nItem ]:Release()
      _OOHG_DeleteArrayItem( ::aOptions, nItem )
      If nItem == 1 .AND. LEN( ::aOptions ) > 0
         WindowStyleFlag( ::aOptions[ 1 ]:hWnd, WS_GROUP, WS_GROUP )
      EndIf
      If nValue >= nItem
         ::Value := nValue
      EndIf
   EndIf

   If nValue >= nItem
      ::Value := ::Value
   EndIf
Return nil

*-----------------------------------------------------------------------------*
METHOD Caption( nItem, uValue ) CLASS TRadioGroup
*-----------------------------------------------------------------------------*
Return ( ::aOptions[ nItem ]:Caption := uValue )

*------------------------------------------------------------------------------*
METHOD AdjustResize( nDivh, nDivw, lSelfOnly ) CLASS TRadioGroup
*------------------------------------------------------------------------------*
   If HB_IsNumeric( ::nSpacing )
      If ::lHorizontal
         ::nSpacing := ::nSpacing * nDivw
      Else
         ::nSpacing := ::nSpacing * nDivh
      EndIf
   EndIf

Return ::Super:AdjustResize( nDivh, nDivw, lSelfOnly )





CLASS TRadioItem FROM TLabel
   DATA Type          INIT "RADIOITEM" READONLY
   DATA nWidth        INIT 120
   DATA nHeight       INIT 25
   DATA IconWidth     INIT 19
   DATA TabHandle     INIT 0

   METHOD Define
   METHOD Value             SETGET
   METHOD Events
   METHOD Events_Command
   METHOD Events_Color
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, width, height, ;
               caption, value, lFirst, ;
               autosize, transparent, fontcolor, backcolor, ;
               fontname, fontsize, bold, italic, underline, strikeout, ;
               tooltip, HelpId, invisible, notabstop, lDisabled, lRtl ) CLASS TRadioItem
*-----------------------------------------------------------------------------*
Local ControlHandle, nStyle, oContainer

   ASSIGN ::nCol    VALUE x      TYPE "N"
   ASSIGN ::nRow    VALUE y      TYPE "N"
   ASSIGN ::nWidth  VALUE width  TYPE "N"
   ASSIGN ::nHeight VALUE height TYPE "N"

   ::SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor,, lRtl )

   nStyle := ::InitStyle( ,, Invisible, notabstop, lDisabled )

   If HB_IsLogical( lFirst ) .AND. lFirst
      ControlHandle := InitRadioGroup( ::ContainerhWnd, ::ContainerCol, ::ContainerRow, nStyle, ::lRtl, ::Width, ::Height )
   Else
      ControlHandle := InitRadioButton( ::ContainerhWnd, ::ContainerCol, ::ContainerRow, nStyle, ::lRtl, ::Width, ::Height )
   EndIf

   ::Register( ControlHandle,, HelpId,, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   If _OOHG_UsesVisualStyle()
      oContainer := ::Container
      DO WHILE ! oContainer == NIL
         If oContainer:Type == "TAB"
            ::TabHandle := oContainer:hWnd
            EXIT
         EndIf
         oContainer := oContainer:Container
      ENDDO
   EndIf

   ::Transparent := transparent
   ::AutoSize    := autosize
   ::Caption := caption

   ::Value := value
Return Self

*-----------------------------------------------------------------------------*
METHOD Value( lValue ) CLASS TRadioItem
*-----------------------------------------------------------------------------*
LOCAL lOldValue
   If HB_IsLogical( lValue )
      lOldValue := ( SendMessage( ::hWnd, BM_GETCHECK, 0, 0 ) == BST_CHECKED )
      If ! lValue == lOldValue
         SendMessage( ::hWnd, BM_SETCHECK, IF( lValue, BST_CHECKED, BST_UNCHECKED ), 0 )
      EndIf
   EndIf
Return ( SendMessage( ::hWnd, BM_GETCHECK, 0, 0 ) == BST_CHECKED )

*-----------------------------------------------------------------------------*
METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TRadioItem
*-----------------------------------------------------------------------------*
   If nMsg == WM_LBUTTONDBLCLK
      If HB_IsBlock( ::OnDblClick )
         ::DoEvent( ::OnDblClick, "DBLCLICK" )
      ElseIf ! ::Container == NIL
         ::Container:DoEvent( ::Container:OnDblClick, "DBLCLICK" )
      EndIf
      Return nil
   ElseIf nMsg == WM_RBUTTONUP
      If HB_IsBlock( ::OnRClick )
         ::DoEvent( ::OnRClick, "RCLICK" )
      ElseIf ! ::Container == NIL
         ::Container:DoEvent( ::Container:OnRClick, "RCLICK" )
      EndIf
      Return nil
   EndIf
RETURN ::Super:Events( hWnd, nMsg, wParam, lParam )

*-----------------------------------------------------------------------------*
METHOD Events_Command( wParam ) CLASS TRadioItem
*-----------------------------------------------------------------------------*
Local Hi_wParam := HIWORD( wParam )
/*
Local lTab
*/
   If Hi_wParam == BN_CLICKED
      If ! ::Container == NIL
/*
         lTab := ( ::Container:TabStop .AND. ::Value )
         If ! lTab == ::TabStop
            ::TabStop := lTab
         EndIf
*/
         ::Container:DoChange()
      EndIf
      Return nil
   EndIf
Return ::Super:Events_Command( wParam )

*------------------------------------------------------------------------------*
METHOD Events_Color( wParam, nDefColor ) CLASS TRadioItem
*------------------------------------------------------------------------------*
Return Events_Color_InTab( Self, wParam, nDefColor )    // see h_controlmisc.prg





EXTERN InitRadioGroup, InitRadioButton

#pragma BEGINDUMP
// #define s_Super s_TLabel
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windows.h>
#include <commctrl.h>
#include "oohg.h"

static WNDPROC lpfnOldWndProcA = 0, lpfnOldWndProcB = 0;

static LRESULT APIENTRY SubClassFuncA( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProcA );
}

static LRESULT APIENTRY SubClassFuncB( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProcB );
}

HB_FUNC( INITRADIOGROUP )
{
   HWND hbutton;
   int Style   = hb_parni( 4 ) | BS_NOTIFY | WS_CHILD | BS_AUTORADIOBUTTON | WS_GROUP;
   int StyleEx = _OOHG_RTL_Status( hb_parl( 5 ) );

   hbutton = CreateWindowEx( StyleEx, "button", "", Style,
                             hb_parni( 2 ), hb_parni( 3 ), hb_parni( 6 ), hb_parni( 7 ),
                             HWNDparam( 1 ), ( HMENU ) NULL, GetModuleHandle( NULL ), NULL );

   lpfnOldWndProcA = ( WNDPROC ) SetWindowLong( ( HWND ) hbutton, GWL_WNDPROC, ( LONG ) SubClassFuncA );

   HWNDret( hbutton );
}

HB_FUNC( INITRADIOBUTTON )
{
   HWND hbutton;
   int Style   = hb_parni( 4 ) | BS_NOTIFY | WS_CHILD | BS_AUTORADIOBUTTON;
   int StyleEx = _OOHG_RTL_Status( hb_parl( 5 ) );

   hbutton = CreateWindowEx( StyleEx, "button", "", Style,
                             hb_parni( 2 ), hb_parni( 3 ), hb_parni( 6 ), hb_parni( 7 ),
                             HWNDparam( 1 ), ( HMENU ) NULL, GetModuleHandle( NULL ), NULL );

   lpfnOldWndProcB = ( WNDPROC ) SetWindowLong( ( HWND ) hbutton, GWL_WNDPROC, ( LONG ) SubClassFuncB );

   HWNDret( hbutton );
}

#pragma ENDDUMP
