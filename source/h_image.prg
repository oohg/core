/*
 * $Id: h_image.prg,v 1.13 2007-07-01 04:44:56 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG image functions
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


CLASS TImage FROM TControl
   DATA Type            INIT "IMAGE" READONLY
   DATA cPicture        INIT ""
   DATA Stretch         INIT .F.
   DATA AutoSize        INIT .T.
   DATA bOnClick        INIT ""
   DATA nWidth          INIT 100
   DATA nHeight         INIT 100
   DATA hImage          INIT nil

   METHOD Define
   METHOD Picture       SETGET
   METHOD HBitMap       SETGET
   METHOD Buffer        SETGET
   METHOD OnClick       SETGET

   METHOD SizePos
   METHOD RePaint
   METHOD Release
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, FileName, w, h, ProcedureName, ;
               HelpId, invisible, stretch, lWhiteBackground, lRtl, backcolor, ;
               cBuffer, hBitMap, autosize ) CLASS TImage
*-----------------------------------------------------------------------------*
Local ControlHandle, nStyle

   ASSIGN ::nCol    VALUE x TYPE "N"
   ASSIGN ::nRow    VALUE y TYPE "N"
   ASSIGN ::nWidth  VALUE w TYPE "N"
   ASSIGN ::nHeight VALUE h TYPE "N"

   ASSIGN ::Stretch    VALUE stretch  TYPE "L"
   ASSIGN ::AutoSize   VALUE autosize TYPE "L"

   ::SetForm( ControlName, ParentForm,,,, BackColor,, lRtl )
   If ValType( lWhiteBackground ) == "L" .AND. lWhiteBackground
      ::BackColor := WHITE
   EndIf

   nStyle := ::InitStyle( ,, Invisible, .T. )

   ControlHandle := InitImage( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, nStyle, ::lRtl )

   ::Register( ControlHandle, ControlName, HelpId )

   ::OnClick := ProcedureName

   ::Picture := FileName
   If ! ValidHandler( ::AuxHandle )
      ::Buffer := cBuffer
      If ! ValidHandler( ::AuxHandle )
         ::HBitMap := hBitMap
      EndIf
   EndIf

Return Self

*-----------------------------------------------------------------------------*
METHOD Picture( cPicture ) CLASS TImage
*-----------------------------------------------------------------------------*
LOCAL nAttrib
   IF VALTYPE( cPicture ) $ "CM"
      DeleteObject( ::AuxHandle )
      ::cPicture := cPicture
      nAttrib := LR_CREATEDIBSECTION
      // IF ::Transparent
      //    nAttrib += LR_LOADMAP3DCOLORS + LR_LOADTRANSPARENT
      // ENDIF
      ::AuxHandle := _OOHG_BitmapFromFile( Self, cPicture, nAttrib )
      ::RePaint()
   ENDIF
Return ::cPicture

*-----------------------------------------------------------------------------*
METHOD HBitMap( hBitMap ) CLASS TImage
*-----------------------------------------------------------------------------*
   If ValType( hBitMap ) $ "NP"
      DeleteObject( ::AuxHandle )
      ::AuxHandle := hBitMap
      ::RePaint()
   EndIf
Return ::AuxHandle

*-----------------------------------------------------------------------------*
METHOD Buffer( cBuffer ) CLASS TImage
*-----------------------------------------------------------------------------*
   If ValType( cBuffer ) $ "CM"
      DeleteObject( ::AuxHandle )
      ::AuxHandle := _OOHG_BitmapFromBuffer( Self, cBuffer )
      ::RePaint()
   EndIf
Return nil

*-----------------------------------------------------------------------------*
METHOD OnClick( bOnClick ) CLASS TImage
*-----------------------------------------------------------------------------*
   If PCOUNT() > 0
      ::bOnClick := bOnClick
      WindowStyleFlag( ::hWnd, SS_NOTIFY, IF( ValType( bOnClick ) == "B", SS_NOTIFY, 0 ) )
   EndIf
Return ::bOnClick

*-----------------------------------------------------------------------------*
METHOD SizePos( Row, Col, Width, Height ) CLASS TImage
*-----------------------------------------------------------------------------*
LOCAL uRet
   uRet := ::Super:SizePos( Row, Col, Width, Height )
   IF ! ::AutoSize .OR. ! ::Stretch
      SendMessage( ::hWnd, STM_SETIMAGE, IMAGE_BITMAP, ::hImage )
   ENDIF
RETURN uRet

*-----------------------------------------------------------------------------*
METHOD RePaint() CLASS TImage
*-----------------------------------------------------------------------------*
   IF ValidHandler( ::hImage )
      DeleteObject( ::hImage )
   ENDIF
   ::hImage := _OOHG_SetBitmap( Self, ::AuxHandle, STM_SETIMAGE, ::Stretch, ::AutoSize )
RETURN Self

*-----------------------------------------------------------------------------*
METHOD Release() CLASS TImage
*-----------------------------------------------------------------------------*
   IF ValidHandler( ::hImage )
      DeleteObject( ::hImage )
   ENDIF
RETURN ::Super:Release()

#pragma BEGINDUMP

#include "hbapi.h"
#include <windows.h>
#include <commctrl.h>
#include "../include/oohg.h"

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

HB_FUNC( INITIMAGE )   // ( hWnd, hMenu, nCol, nRow, nWidth, nHeight, nStyle, lRtl )
{
   HWND h;
   HWND hwnd;
   int Style, StyleEx;

   hwnd = HWNDparam( 1 );

   StyleEx = _OOHG_RTL_Status( hb_parl( 8 ) );

   Style = hb_parni( 7 ) | WS_CHILD | SS_BITMAP | SS_NOTIFY;

   h = CreateWindowEx( StyleEx, "static", NULL,
        Style,
        hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ),
        hwnd, ( HMENU ) HWNDparam( 2 ), GetModuleHandle( NULL ), NULL ) ;

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( ( HWND ) h, GWL_WNDPROC, ( LONG ) SubClassFunc );

   HWNDret( h );
}

#pragma ENDDUMP
