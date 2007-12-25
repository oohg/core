/*
 * $Id: h_button.prg,v 1.34 2007-12-25 02:47:14 guerra000 Exp $
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
#include "hbclass.ch"
#include "i_windefs.ch"


CLASS TButton FROM TImage
   DATA Type      INIT "BUTTON" READONLY
   DATA lNoTransparent INIT .F.
   DATA nWidth    INIT 100
   DATA nHeight   INIT 28
   DATA AutoSize  INIT .F.
   DATA OnClick   INIT nil
   DATA nAlign    INIT 2

   METHOD Define
   METHOD DefineImage
   METHOD SetFocus
   METHOD Picture     SETGET
   METHOD Value       SETGET

   METHOD RePaint
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, Caption, ProcedureName, w, h, ;
               fontname, fontsize, tooltip, gotfocus, lostfocus, flat, ;
               NoTabStop, HelpId, invisible, bold, italic, underline, ;
               strikeout, lRtl, lNoPrefix, lDisabled, cBuffer, hBitMap, ;
               cImage, lNoTransparent, lScale, lCancel, cAlign ) CLASS TButton
*-----------------------------------------------------------------------------*
Local ControlHandle, nStyle, lBitMap

   ASSIGN ::nCol    VALUE x TYPE "N"
   ASSIGN ::nRow    VALUE y TYPE "N"
   ASSIGN ::nWidth  VALUE w TYPE "N"
   ASSIGN ::nHeight VALUE h TYPE "N"

   lBitMap := ! ValType( caption ) $ "CM" .AND. ;
              ( ValType( cImage ) $ "CM" .OR. ;
                ValType( cBuffer ) $ "CM" .OR. ;
                ValidHandler( hBitMap ) )
   If ! lBitMap .AND. Empty( caption )
      If ( Valtype( cImage ) $ "CM" .AND. ! Empty( cImage ) ) .OR. ;
         ( Valtype( cBuffer ) $ "CM" .AND. ! Empty( cBuffer ) ) .OR. ;
         ValidHandler( hBitMap )
         lBitMap := .T.
      EndIf
   EndIf

   ::SetForm( ControlName, ParentForm, FontName, FontSize,,,, lRtl )
   nStyle := ::InitStyle( ,, Invisible, NoTabStop, lDisabled ) + BS_PUSHBUTTON + ;
             if( ValType( flat ) == "L"      .AND. flat,       BS_FLAT, 0 )     + ;
             if( ValType( lNoPrefix ) == "L" .AND. lNoPrefix,  SS_NOPREFIX, 0 ) + ;
             if( lBitMap,                                      BS_BITMAP, 0 )

   ControlHandle := InitButton( ::ContainerhWnd, Caption, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, ::lRtl, nStyle )

   ::Register( ControlHandle, ControlName, HelpId,, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   ::OnClick := ProcedureName
   ::OnLostFocus := LostFocus
   ::OnGotFocus :=  GotFocus
   ::Caption := Caption

   ASSIGN ::lNoTransparent VALUE lNoTransparent TYPE "L"
   ASSIGN ::AutoSize       VALUE lScale         TYPE "L"
   ASSIGN ::lCancel        VALUE lCancel        TYPE "L"

   IF VALTYPE( cAlign ) $ "CM"
      cAlign := ALLTRIM( UPPER( cAlign ) )
      DO CASE
         CASE EMPTY( cAlign )
            cAlign := 2
         CASE "LEFT" = cAlign
            cAlign := 0
         CASE "RIGHT" = cAlign
            cAlign := 1
         CASE "BOTTOM" = cAlign
            cAlign := 3
         OTHERWISE
            cAlign := 2
      ENDCASE
   ENDIF
   IF VALTYPE( cAlign ) == "N"
      ::nAlign := cAlign
   ENDIF

   ::Picture := cImage
   If ! ValidHandler( ::AuxHandle )
      ::Buffer := cBuffer
      If ! ValidHandler( ::AuxHandle )
         ::HBitMap := hBitMap
      EndIf
   EndIf

Return Self

*------------------------------------------------------------------------------*
METHOD DefineImage( ControlName, ParentForm, x, y, Caption, ProcedureName, w, h, ;
                    fontname, fontsize, tooltip, gotfocus, lostfocus, flat, ;
                    NoTabStop, HelpId, invisible, bold, italic, underline, ;
                    strikeout, lRtl, lNoPrefix, lDisabled, cBuffer, hBitMap, ;
                    cImage, lNoTransparent, lScale, lCancel, cAlign, lMix ) CLASS TButton
*------------------------------------------------------------------------------*
   If Empty( cBuffer )
      cBuffer := ""
   EndIf
Return ::Define( ControlName, ParentForm, x, y, Caption, ProcedureName, w, h, ;
                 fontname, fontsize, tooltip, gotfocus, lostfocus, flat, ;
                 NoTabStop, HelpId, invisible, bold, italic, underline, ;
                 strikeout, lRtl, lNoPrefix, lDisabled, cBuffer, hBitMap, ;
                 cImage, lNoTransparent, lScale, lCancel, cAlign, lMix )

*------------------------------------------------------------------------------*
METHOD SetFocus() CLASS TButton
*------------------------------------------------------------------------------*
   SendMessage( ::hWnd , BM_SETSTYLE , LOWORD( BS_DEFPUSHBUTTON ) , 1 )
Return ::Super:SetFocus()

*-----------------------------------------------------------------------------*
METHOD Picture( cPicture ) CLASS TButton
*-----------------------------------------------------------------------------*
LOCAL nAttrib
   IF VALTYPE( cPicture ) $ "CM"
      DeleteObject( ::AuxHandle )
      ::cPicture := cPicture

      nAttrib := LR_LOADMAP3DCOLORS
      IF ! ::lNoTransparent
         nAttrib += LR_LOADTRANSPARENT
      ENDIF

//      IF ::lNoTransparent
//         nAttrib := LR_LOADMAP3DCOLORS
//      ELSE
//         nAttrib := LR_LOADTRANSPARENT
//      ENDIF

      ::AuxHandle := _OOHG_BitmapFromFile( Self, cPicture, nAttrib, ::AutoSize )
      ::RePaint()
   ENDIF
Return ::cPicture

*------------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TButton
*------------------------------------------------------------------------------*
Return ( ::Caption := uValue )

*-----------------------------------------------------------------------------*
METHOD RePaint() CLASS TButton
*-----------------------------------------------------------------------------*
   IF ValidHandler( ::hImage )
      DeleteObject( ::hImage )
   ENDIF
   ::TControl:SizePos()
   IF ( "XP" $ OS() .OR. "Vista" $ OS() ) .AND. ValidHandler( ::AuxHandle ) .AND. LEN( ::Caption ) > 0
      SetImageXP( ::hWnd, ::AuxHandle, ::nAlign, ::BackColorCode )
      ::redraw()
      ::hImage := NIL
   ELSEIF ::Stretch .OR. ::AutoSize
      ::hImage := _OOHG_SetBitmap( Self, ::AuxHandle, BM_SETIMAGE, ::Stretch, ::AutoSize )
   ELSE
      SendMessage( ::hWnd, BM_SETIMAGE, IMAGE_BITMAP, ::AuxHandle )
      ::hImage := NIL
   ENDIF
RETURN Self

#pragma BEGINDUMP
#include <hbapi.h>
#include <windows.h>
#include <commctrl.h>
#include <oohg.h>

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

HB_FUNC( INITBUTTON )
{
   HWND hbutton;
   int Style, StyleEx;

   Style =  BS_NOTIFY | WS_CHILD | hb_parni( 9 );

   StyleEx = hb_parni( 10 ) | _OOHG_RTL_Status( hb_parl( 8 ) );

   hbutton = CreateWindowEx( StyleEx, "button" ,
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

#ifndef BUTTON_IMAGELIST
   typedef struct {
       HIMAGELIST himl;
       RECT margin;
       UINT uAlign;
   } BUTTON_IMAGELIST, *PBUTTON_IMAGELIST;
#endif

#ifndef BCM_FIRST
   #define BCM_FIRST     0x1600
#endif

#ifndef BCM_SETIMAGELIST
   #define BCM_SETIMAGELIST     ( BCM_FIRST + 2 )
#endif

#ifndef BCM_GETIMAGELIST
   #define BCM_GETIMAGELIST     ( BCM_FIRST + 3 )
#endif

HB_FUNC( SETIMAGEXP )
{
	HIMAGELIST himl;
	BUTTON_IMAGELIST bi ;
   HBITMAP hBmp;
   HBITMAP hBmp2;
   BITMAP bm;
   COLORREF clrColor;
   HWND hWnd;

   hWnd = HWNDparam( 1 );
   hBmp = ( HBITMAP ) HWNDparam( 2 );
   if( hBmp )
   {
      memset( &bm, 0, sizeof( bm ) );
      SendMessage( hWnd, BCM_GETIMAGELIST, 0, ( LPARAM ) &bi );
      himl = bi.himl;
      if( himl )
      {
         memset( &bm, 0, sizeof( bm ) );
         bi.himl = 0;
         bi.uAlign = hb_parni( 3 );
         SendMessage( hWnd, BCM_SETIMAGELIST, 0, ( LPARAM ) &bi );
         ImageList_Destroy( himl );
      }
      clrColor = ( COLORREF ) hb_parnl( 4 );
      if( clrColor == ( COLORREF ) ( ~0 ) )
      {
         clrColor = GetSysColor( COLOR_BTNFACE );
      }
      GetObject( hBmp, sizeof( bm ), &bm );
      hBmp2 = _OOHG_ScaleImage( hWnd, hBmp, bm.bmWidth, bm.bmHeight, 0, clrColor );
      himl = ImageList_Create( bm.bmWidth, bm.bmHeight, ILC_COLOR32 | ILC_MASK, 2, 2 );
      ImageList_AddMasked( himl, hBmp2, clrColor );
      memset( &bm, 0, sizeof( bm ) );
      bi.himl = himl;
      bi.margin.left = 10;
      bi.margin.top = 10;
      bi.margin.bottom = 10;
      bi.margin.right = 10;
      bi.uAlign = hb_parni( 3 );
      SendMessage( hWnd, BCM_SETIMAGELIST, 0, ( LPARAM ) &bi );
      DeleteObject( hBmp2 );
   }
}

#pragma ENDDUMP





CLASS TButtonCheck FROM TButton
   DATA Type      INIT "CHECKBUTTON" READONLY
   DATA nWidth    INIT 100
   DATA nHeight   INIT 28

   METHOD Define
   METHOD DefineImage
   METHOD Value       SETGET
   METHOD Events_Command
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, Caption, Value, fontname, ;
               fontsize, tooltip, changeprocedure, w, h, lostfocus, gotfocus, ;
               HelpId, invisible, notabstop, bold, italic, underline, ;
               strikeout, field, lRtl, BitMap, cBuffer, hBitMap, ;
               lNoTransparent, lScale ) CLASS TButtonCheck
*-----------------------------------------------------------------------------*
Local ControlHandle, nStyle := 0

   ASSIGN ::nCol        VALUE x TYPE "N"
   ASSIGN ::nRow        VALUE y TYPE "N"
   ASSIGN ::nWidth      VALUE w TYPE "N"
   ASSIGN ::nHeight     VALUE h TYPE "N"
   IF VALTYPE( value ) != "L"
      value := .F.
   ENDIF

   ::SetForm( ControlName, ParentForm, FontName, FontSize,,,, lRtl )

   nStyle := ::InitStyle( ,, Invisible, NoTabStop ) + BS_AUTOCHECKBOX + ;
             BS_PUSHLIKE

   IF VALTYPE( BitMap ) $ "CM" .OR. VALTYPE( cBuffer ) $ "CM" .OR. VALTYPE( hBitMap ) $ "NP"
      nStyle += BS_BITMAP
   ENDIF

   ControlHandle := InitButton( ::ContainerhWnd, Caption, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, ::lRtl, nStyle )

   ::Register( ControlHandle, ControlName, HelpId,, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   ::OnLostFocus := LostFocus
   ::OnGotFocus  := GotFocus
   ::Caption     := Caption

   ASSIGN ::lNoTransparent VALUE lNoTransparent TYPE "L"
   ASSIGN ::AutoSize       VALUE lScale         TYPE "L"
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

*-----------------------------------------------------------------------------*
METHOD DefineImage( ControlName, ParentForm, x, y, Caption, Value, fontname, ;
                    fontsize, tooltip, changeprocedure, w, h, lostfocus, gotfocus, ;
                    HelpId, invisible, notabstop, bold, italic, underline, ;
                    strikeout, field, lRtl, BitMap, cBuffer, hBitMap, ;
                    lNoTransparent, lScale ) CLASS TButtonCheck
*-----------------------------------------------------------------------------*
   If Empty( cBuffer )
      cBuffer := ""
   EndIf
Return ::Define( ControlName, ParentForm, x, y, Caption, Value, fontname, ;
                 fontsize, tooltip, changeprocedure, w, h, lostfocus, gotfocus, ;
                 HelpId, invisible, notabstop, bold, italic, underline, ;
                 strikeout, field, lRtl, BitMap, cBuffer, hBitMap, ;
                 lNoTransparent, lScale )

*------------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TButtonCheck
*------------------------------------------------------------------------------*
   IF VALTYPE( uValue ) == "L"
      SendMessage( ::hWnd, BM_SETCHECK, if( uValue, BST_CHECKED, BST_UNCHECKED ), 0 )
   ELSE
      uValue := ( SendMessage( ::hWnd, BM_GETCHECK , 0 , 0 ) == BST_CHECKED )
   ENDIF
RETURN uValue

*------------------------------------------------------------------------------*
METHOD Events_Command( wParam ) CLASS TButtonCheck
*------------------------------------------------------------------------------*
Local Hi_wParam := HIWORD( wParam )
   If Hi_wParam == BN_CLICKED
      ::DoEvent( ::OnChange, "CHANGE" )
      Return nil
   EndIf
Return ::Super:Events_Command( wParam )
