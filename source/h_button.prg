/*
 * $Id: h_button.prg,v 1.16 2006-10-28 20:49:15 guerra000 Exp $
 */
/*
 * ooHG source code:
 * Button controls
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

CLASS TButton FROM TControl
   DATA Type      INIT "BUTTON" READONLY
   DATA cPicture  INIT ""
   DATA lNoTransparent INIT .F.
   DATA nWidth    INIT 100
   DATA nHeight   INIT 28

   METHOD Define
   METHOD DefineImage
   METHOD SetFocus
   METHOD Picture     SETGET
   METHOD Value       SETGET
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, Caption, ProcedureName, w, h, ;
               fontname, fontsize, tooltip, gotfocus, lostfocus, flat, ;
               NoTabStop, HelpId, invisible, bold, italic, underline, ;
               strikeout, lRtl, lNoPrefix, lDisabled ) CLASS TButton
*-----------------------------------------------------------------------------*
Local ControlHandle, nStyle

   ASSIGN ::nCol    VALUE x TYPE "N"
   ASSIGN ::nRow    VALUE y TYPE "N"
   ASSIGN ::nWidth  VALUE w TYPE "N"
   ASSIGN ::nHeight VALUE h TYPE "N"

   ::SetForm( ControlName, ParentForm, FontName, FontSize,,,, lRtl )

   nStyle := ::InitStyle( ,, Invisible, NoTabStop, lDisabled ) + ;
             if( ValType( flat ) == "L"      .AND. flat,       BS_FLAT, 0 )    + ;
             if( ValType( lNoPrefix ) == "L" .AND. lNoPrefix,  SS_NOPREFIX, 0 )

   ControlHandle := InitButton( ::ContainerhWnd, Caption, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, ::lRtl, nStyle )

   ::Register( ControlHandle, ControlName, HelpId,, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )
   ::SizePos( y, x, w, h )

   ::OnClick := ProcedureName
   ::OnLostFocus := LostFocus
   ::OnGotFocus :=  GotFocus
   ::Caption := Caption

Return Self

*-----------------------------------------------------------------------------*
METHOD DefineImage( ControlName, ParentForm, x, y, Caption, ProcedureName, ;
                    w, h, image, tooltip, gotfocus, lostfocus, flat, ;
                    notrans, HelpId, invisible, notabstop, lRtl, lDisabled ) CLASS TButton
*-----------------------------------------------------------------------------*
Local ControlHandle, nStyle

   ASSIGN ::nCol    VALUE x TYPE "N"
   ASSIGN ::nRow    VALUE y TYPE "N"
   ASSIGN ::nWidth  VALUE w TYPE "N"
   ASSIGN ::nHeight VALUE h TYPE "N"

   ::SetForm( ControlName, ParentForm,,,,,, lRtl )
   nStyle := ::InitStyle( ,, Invisible, NoTabStop, lDisabled ) + ;
             BS_BITMAP + ;
             if( ValType( flat ) == "L"      .AND. flat,       BS_FLAT, 0 )

   ControlHandle := InitButton( ::ContainerhWnd, Caption, 0, x, y, w, h, ::lRtl, nStyle )

   ::Register( ControlHandle, ControlName, HelpId,, ToolTip )
   ::SizePos( y, x, w, h )

   ::OnClick := ProcedureName
   ::OnLostFocus := LostFocus
   ::OnGotFocus :=  GotFocus
   ::Caption := Caption
   ASSIGN ::lNoTransparent VALUE notrans TYPE "L" DEFAULT .F.
   ::Picture := image

Return Self

*------------------------------------------------------------------------------*
METHOD SetFocus() CLASS TButton
*------------------------------------------------------------------------------*
   SendMessage( ::hWnd , BM_SETSTYLE , LOWORD( BS_DEFPUSHBUTTON ) , 1 )
Return ::Super:SetFocus()

*-----------------------------------------------------------------------------*
METHOD Picture( cPicture ) CLASS TButton
*-----------------------------------------------------------------------------*
   IF VALTYPE( cPicture ) $ "CM"
      DeleteObject( ::AuxHandle )
      ::AuxHandle := _SetBtnPicture( ::hWnd, cPicture, ::lNoTransparent )
      ::cPicture := cPicture
   ENDIF
Return ::cPicture

*------------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TButton
*------------------------------------------------------------------------------*
Return ( ::Caption := uValue )

EXTERN InitButton, _SetBtnPicture

#pragma BEGINDUMP
#include <hbapi.h>
#include <windows.h>
#include <commctrl.h>
#include "../include/oohg.h"

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

HB_FUNC( INITBUTTON )
{
   HWND hbutton;
   int Style, StyleEx;

   Style =  BS_NOTIFY | WS_CHILD | BS_PUSHBUTTON | hb_parni( 9 );

   StyleEx = _OOHG_RTL_Status( hb_parl( 8 ) );

   hbutton = CreateWindowEx(StyleEx, "button" ,
                           hb_parc(2) ,
                           Style ,
                           hb_parni(4) ,
                           hb_parni(5) ,
                           hb_parni(6) ,
                           hb_parni(7) ,
                           HWNDparam( 1 ),
                           (HMENU)hb_parni(3) ,
                           GetModuleHandle(NULL) ,
                           NULL ) ;

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( hbutton, GWL_WNDPROC, ( LONG ) SubClassFunc );

   HWNDret( hbutton );
}

HB_FUNC( _SETBTNPICTURE )
{
	HWND hwnd;
	HWND himage;
   int ImgStyle;

   hwnd = HWNDparam( 1 );

   ImgStyle = LR_LOADMAP3DCOLORS;
   if( ! hb_parl( 3 ) )
   {
      ImgStyle |= LR_LOADTRANSPARENT;
   }

   himage = ( HWND ) _OOHG_LoadImage( hb_parc( 2 ), ImgStyle, 0, 0, hwnd );

   SendMessage( hwnd, ( UINT ) BM_SETIMAGE, ( WPARAM ) IMAGE_BITMAP, ( LPARAM ) himage );

   HWNDret( himage );
}
#pragma ENDDUMP
