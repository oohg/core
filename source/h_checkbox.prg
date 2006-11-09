/*
 * $Id: h_checkbox.prg,v 1.13 2006-11-09 19:37:16 declan2005 Exp $
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

#include "oohg.ch"
#include "common.ch"
#include "hbclass.ch"
#include "i_windefs.ch"


CLASS TCheckBox FROM TLabel
   DATA Type      INIT "CHECKBOX" READONLY
   DATA cPicture  INIT ""
   DATA IconWidth INIT 19
   DATA nWidth    INIT 100
   DATA nHeight   INIT 28
   DATA lNoTransparent INIT .F.
   DATA lScale    INIT .F.

   METHOD Define
   METHOD Value       SETGET
   METHOD Picture     SETGET
   METHOD Buffer      SETGET
   METHOD hBitMap     SETGET
   METHOD Events_Command
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, Caption, Value, fontname, ;
               fontsize, tooltip, changeprocedure, w, h, lostfocus, gotfocus, ;
               HelpId, invisible, notabstop, bold, italic, underline, ;
               strikeout, field, backcolor, fontcolor, transparent, autosize, ;
               lRtl, lButton, BitMap, cBuffer, hBitMap, lNoTransparent, ;
               lScale ) CLASS TCheckBox
*-----------------------------------------------------------------------------*
Local ControlHandle, nStyle := 0, nStyleEx := 0

   ASSIGN ::nCol        VALUE x TYPE "N"
   ASSIGN ::nRow        VALUE y TYPE "N"
   ASSIGN ::nWidth      VALUE w TYPE "N"
   ASSIGN ::nHeight     VALUE h TYPE "N"
   ASSIGN ::Transparent VALUE transparent  TYPE "L"
   DEFAULT value           TO FALSE
   DEFAULT notabstop       TO FALSE
   DEFAULT autosize        TO FALSE
   DEFAULT lButton         TO FALSE

   ::SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor,, lRtl )

   nStyle := ::InitStyle( ,, Invisible, NoTabStop )

   IF lButton
      nStyle += BS_PUSHLIKE
      autosize := .F.
   ELSE
      nStyleEx += WS_EX_TRANSPARENT
   ENDIF

   IF VALTYPE( BitMap ) $ "CM" .OR. VALTYPE( cBuffer ) $ "CM" .OR. VALTYPE( hBitMap ) $ "NP"
      nStyle += BS_BITMAP
   ENDIF

   Controlhandle := InitCheckBox( ::ContainerhWnd, Caption, 0, ::ContainerCol, ::ContainerRow, '', 0 , ::nWidth, ::nHeight, nStyle, nStyleEx, ::lRtl )

   ::Register( ControlHandle, ControlName, HelpId,, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   ::OnLostFocus := LostFocus
   ::OnGotFocus  := GotFocus
   ::Autosize    := autosize
   ::Caption     := Caption

   ASSIGN ::lNoTransparent VALUE lNoTransparent TYPE "L"
   ASSIGN ::lScale         VALUE lScale         TYPE "L"
   ::Picture := BitMap
   If ! ValidHandler( ::AuxHandle )
      ::Buffer := cBuffer
      If ! ValidHandler( ::AuxHandle )
         ::HBitMap := hBitMap
      EndIf
   EndIf

   If ValType( Field ) $ 'CM' .AND. ! empty( Field )
      ::VarName := alltrim( Field )
      ::Block := &( "{ |x| if( PCount() == 0, " + Field + ", " + Field + " := x ) }" )
      Value := EVAL( ::Block )
	EndIf

   ::Value := value

	if valtype ( Field ) != 'U'
      aAdd ( ::Parent:BrowseList, Self )
	EndIf

   ::OnChange    := ChangeProcedure

Return Self

*------------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TCheckBox
*------------------------------------------------------------------------------*
   IF VALTYPE( uValue ) == "L"
      SendMessage( ::hWnd, BM_SETCHECK, if( uValue, BST_CHECKED, BST_UNCHECKED ), 0 )
   ELSE
      uValue := ( SendMessage( ::hWnd, BM_GETCHECK , 0 , 0 ) == BST_CHECKED )
   ENDIF
RETURN uValue

*-----------------------------------------------------------------------------*
METHOD Picture( cPicture ) CLASS TCheckBox
*-----------------------------------------------------------------------------*
   IF VALTYPE( cPicture ) $ "CM"
      DeleteObject( ::AuxHandle )
      ::cPicture := cPicture
      ::AuxHandle := TButton_SetPicture( Self, cPicture, ::lNoTransparent, ::lScale )
   ENDIF
Return ::cPicture

*-----------------------------------------------------------------------------*
METHOD HBitMap( hBitMap ) CLASS TCheckBox
*-----------------------------------------------------------------------------*
   If ValType( hBitMap ) $ "NP"
      DeleteObject( ::AuxHandle )
      ::AuxHandle := hBitMap
      SendMessage( ::hWnd, BM_SETIMAGE, IMAGE_BITMAP, hBitMap )
   EndIf
Return ::AuxHandle

*-----------------------------------------------------------------------------*
METHOD Buffer( cBuffer ) CLASS TCheckBox
*-----------------------------------------------------------------------------*
   If ValType( cBuffer ) $ "CM"
      DeleteObject( ::AuxHandle )
      ::AuxHandle := TButton_SetBuffer( Self, cBuffer, ::lScale )
   EndIf
Return nil

*------------------------------------------------------------------------------*
METHOD Events_Command( wParam ) CLASS TCheckBox
*------------------------------------------------------------------------------*
Local Hi_wParam := HIWORD( wParam )
   If Hi_wParam == BN_CLICKED
      ::DoEvent( ::OnChange )
      Return nil
   EndIf
Return ::Super:Events_Command( wParam )





EXTERN InitCheckBox

#pragma BEGINDUMP

#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include <windows.h>
#include <commctrl.h>
#include "../include/oohg.h"

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

HB_FUNC( INITCHECKBOX )
{
	HWND hwnd;
	HWND hbutton;
   int Style, StyleEx;

   hwnd = HWNDparam( 1 );

   Style = BS_NOTIFY | WS_CHILD | BS_AUTOCHECKBOX | hb_parni( 10 );

   StyleEx = hb_parni( 11 ) | _OOHG_RTL_Status( hb_parl( 12 ) );

   hbutton = CreateWindowEx( StyleEx, "button" , hb_parc(2) ,
	Style ,
	hb_parni(4), hb_parni(5) , hb_parni(8), hb_parni(9) ,
	hwnd,(HMENU)hb_parni(3) , GetModuleHandle(NULL) , NULL ) ;

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( hbutton, GWL_WNDPROC, ( LONG ) SubClassFunc );

   HWNDret( hbutton );
}

#pragma ENDDUMP
