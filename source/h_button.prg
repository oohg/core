/*
 * $Id: h_button.prg,v 1.77 2016-07-23 16:27:16 fyurisich Exp $
 */
/*
 * ooHG source code:
 * Button controls
 *
 * Copyright 2005-2016 Vicente Guerra <vicente@guerra.com.mx>
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
#include "hbclass.ch"
#include "i_windefs.ch"

CLASS TButton FROM TControl
   DATA Type            INIT "BUTTON" READONLY
   DATA lNoTransparent  INIT .F.
   DATA nWidth          INIT 100
   DATA nHeight         INIT 28
   DATA AutoFit         INIT .F.
   DATA nAlign          INIT BUTTON_IMAGELIST_ALIGN_TOP
   DATA cPicture        INIT ""
   DATA Stretch         INIT .F.
   DATA hImage          INIT nil
   DATA ImageSize       INIT .F.
   DATA lThemed         INIT .F.
   DATA aImageMargin    INIT {6, 10, 6, 10}    // top, left, bottom, right
   DATA lNo3DColors     INIT .F.
   DATA lNoDIBSection   INIT .T.
   DATA lNoHotLight     INIT .F.

   METHOD Define
   METHOD DefineImage
   METHOD SetFocus
   METHOD Picture       SETGET
   METHOD HBitMap       SETGET
   METHOD Buffer        SETGET
   METHOD Value         SETGET
   METHOD Events_Notify
   METHOD RePaint
   METHOD SizePos
   METHOD Release
   METHOD ImageMargin   SETGET

   EMPTY( _OOHG_AllVars )
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, Caption, ProcedureName, w, h, ;
               fontname, fontsize, tooltip, GotFocus, LostFocus, flat, ;
               NoTabStop, HelpId, invisible, bold, italic, underline, ;
               strikeout, lRtl, lNoPrefix, lDisabled, cBuffer, hBitMap, ;
               cImage, lNoLoadTrans, lScale, lCancel, cAlign, lMultiLine, ;
               themed, aImageMargin, OnMouseMove, lNo3DColors, lAutoFit, ;
               lNoDIB, backcolor, lNoHotLight ) CLASS TButton
*-----------------------------------------------------------------------------*
Local ControlHandle, nStyle, lBitMap, i

   ASSIGN ::nCol    VALUE x TYPE "N"
   ASSIGN ::nRow    VALUE y TYPE "N"
   ASSIGN ::nWidth  VALUE w TYPE "N"
   ASSIGN ::nHeight VALUE h TYPE "N"
   
   lBitMap := ( ( ValType( cImage ) $ "CM" .AND. ! Empty( cImage ) ) .OR. ;
                ( ValType( cBuffer ) $ "CM" .AND. ! Empty( cBuffer ) ) .OR. ;
                ValidHandler( hBitMap ) ) .AND. ;
              ( ! ValType( Caption ) $ "CM" .OR. Empty( Caption ) )

   If HB_IsArray( aImageMargin )
      For i := 1 to MIN( 4, LEN( aImageMargin ) )
         If HB_IsNumeric( aImageMargin[i] )
            ::aImageMargin[i] := aImageMargin[i]
         EndIf
      Next
   ElseIf HB_IsNumeric( aImageMargin )
      ::aImageMargin := {aImageMargin, aImageMargin, aImageMargin, aImageMargin}
   EndIf

   ::SetForm( ControlName, ParentForm, FontName, FontSize, , backcolor, , lRtl )
   nStyle := ::InitStyle( ,, Invisible, NoTabStop, lDisabled ) + BS_PUSHBUTTON + ;
             if( ValType( flat ) == "L"      .AND. flat,         BS_FLAT, 0 )     + ;
             if( ValType( lNoPrefix ) == "L" .AND. lNoPrefix,    SS_NOPREFIX, 0 ) + ;
             if( lBitMap,                                        BS_BITMAP, 0 ) + ;
             if( ValType( lMultiLine ) == "L" .AND. lMultiLine,  BS_MULTILINE, 0 )

   ControlHandle := InitButton( ::ContainerhWnd, Caption, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, ::lRtl, nStyle )

   ::Register( ControlHandle, ControlName, HelpId,, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   ::Caption := Caption

   ASSIGN ::lNoTransparent VALUE lNoLoadTrans TYPE "L"
   ASSIGN ::Stretch        VALUE lScale       TYPE "L"
   ASSIGN ::lCancel        VALUE lCancel      TYPE "L"
   ASSIGN ::lThemed        VALUE themed       TYPE "L" DEFAULT IsAppThemed()
   ASSIGN ::AutoFit        VALUE lAutoFit     TYPE "L"
   ASSIGN ::lNo3DColors    VALUE lNo3DColors  TYPE "L"
   ASSIGN ::lNoDIBSection  VALUE lNoDIB       TYPE "L"
   ASSIGN ::lNoHotLight    VALUE lNoHotLight  TYPE "L"

   If ( ( ValType( cImage ) $ "CM" .AND. ! Empty( cImage ) ) .OR. ;
        ( ValType( cBuffer ) $ "CM" .AND. ! Empty( cBuffer ) ) .OR. ;
        ValidHandler( hBitMap ) )
      // The button has an image
      If Empty( ::Caption )
         DEFAULT cAlign TO "CENTER"
      Else
         DEFAULT cAlign TO "LEFT"
      EndIf
   EndIf

   IF ValType( cAlign ) $ "CM"
      cAlign := ALLTRIM( UPPER( cAlign ) )
      DO CASE
      CASE EMPTY( cAlign )
         cAlign := BUTTON_IMAGELIST_ALIGN_TOP
      CASE "LEFT" == cAlign
         cAlign := BUTTON_IMAGELIST_ALIGN_LEFT
      CASE "RIGHT" == cAlign
         cAlign := BUTTON_IMAGELIST_ALIGN_RIGHT
      CASE "BOTTOM" == cAlign
         cAlign := BUTTON_IMAGELIST_ALIGN_BOTTOM
      CASE "CENTER" == cAlign
         cAlign := BUTTON_IMAGELIST_ALIGN_CENTER
      OTHERWISE
         cAlign := BUTTON_IMAGELIST_ALIGN_TOP
      ENDCASE
   ENDIF
   IF ValType( cAlign ) == "N"
      ::nAlign := cAlign
   ENDIF

   ::Picture := cImage
   If ! ValidHandler( ::hImage )
      ::Buffer := cBuffer
      If ! ValidHandler( ::hImage )
         ::HBitMap := hBitMap
      EndIf
   EndIf

   ASSIGN ::OnClick     VALUE ProcedureName TYPE "B"
   ASSIGN ::OnLostFocus VALUE LostFocus     TYPE "B"
   ASSIGN ::OnGotFocus  VALUE GotFocus      TYPE "B"
   ASSIGN ::OnMouseMove VALUE OnMouseMove   TYPE "B"

Return Self

*------------------------------------------------------------------------------*
METHOD DefineImage( ControlName, ParentForm, x, y, Caption, ProcedureName, w, h, ;
                    fontname, fontsize, tooltip, gotfocus, lostfocus, flat, ;
                    NoTabStop, HelpId, invisible, bold, italic, underline, ;
                    strikeout, lRtl, lNoPrefix, lDisabled, cBuffer, hBitMap, ;
                    cImage, lNoLoadTrans, lScale, lCancel, cAlign, lMultiLine, ;
                    themed, aImageMargin, OnMouseMove, lNo3DColors, lAutoFit, ;
                    lNoDIB, backcolor, lNoHotLight ) CLASS TButton
*------------------------------------------------------------------------------*
   If Empty( cBuffer )
      cBuffer := ""
   EndIf
Return ::Define( ControlName, ParentForm, x, y, Caption, ProcedureName, w, h, ;
                 fontname, fontsize, tooltip, gotfocus, lostfocus, flat, ;
                 NoTabStop, HelpId, invisible, bold, italic, underline, ;
                 strikeout, lRtl, lNoPrefix, lDisabled, cBuffer, hBitMap, ;
                 cImage, lNoLoadTrans, lScale, lCancel, cAlign, lMultiLine, ;
                 themed, aImageMargin, OnMouseMove, lNo3DColors, lAutoFit, ;
                 lNoDIB, backcolor, lNoHotLight )

*------------------------------------------------------------------------------*
METHOD SetFocus() CLASS TButton
*------------------------------------------------------------------------------*
   SendMessage( ::hWnd , BM_SETSTYLE , LOWORD( BS_DEFPUSHBUTTON ) , 1 )
Return ::Super:SetFocus()

*-----------------------------------------------------------------------------*
METHOD Picture( cPicture ) CLASS TButton
*-----------------------------------------------------------------------------*
LOCAL nAttrib, aPictSize
   IF ValType( cPicture ) $ "CM"
      DeleteObject( ::hImage )
      ::cPicture := cPicture

      IF ::lNoDIBSection
         aPictSize := _OOHG_SizeOfBitmapFromFile( cPicture )      // width, height, depth

         nAttrib := LR_DEFAULTCOLOR
         IF aPictSize[ 3 ] <= 8
           IF ! ::lNo3DColors
              nAttrib += LR_LOADMAP3DCOLORS
           ENDIF
           IF ! ::lNoTransparent
              nAttrib += LR_LOADTRANSPARENT
           ENDIF
         ENDIF
      ELSE
         nAttrib := LR_CREATEDIBSECTION
      ENDIF

      ::hImage := _OOHG_BitmapFromFile( Self, cPicture, nAttrib, ::AutoFit .AND. ! ::ImageSize .AND. ! ::Stretch, .F. )
      IF ::ImageSize
         ::nWidth  := _OOHG_BitMapWidth( ::hImage )
         ::nHeight := _OOHG_BitMapHeight( ::hImage )
      ENDIF
      ::RePaint()
   ENDIF
Return ::cPicture

*-----------------------------------------------------------------------------*
METHOD HBitMap( hBitMap ) CLASS TButton
*-----------------------------------------------------------------------------*
   If ValType( hBitMap ) $ "NP"
      DeleteObject( ::hImage )
      ::hImage := hBitMap
      IF ::ImageSize
         ::nWidth  := _OOHG_BitMapWidth( ::hImage )
         ::nHeight := _OOHG_BitMapHeight( ::hImage )
      ENDIF
      ::RePaint()
      ::cPicture := ""
   EndIf
Return ::hImage

*-----------------------------------------------------------------------------*
METHOD Buffer( cBuffer ) CLASS TButton
*-----------------------------------------------------------------------------*
   If ValType( cBuffer ) $ "CM"
      DeleteObject( ::hImage )
      ::hImage := _OOHG_BitmapFromBuffer( Self, cBuffer, ::AutoFit .AND. ! ::ImageSize .AND. ! ::Stretch )
      IF ::ImageSize
         ::nWidth  := _OOHG_BitMapWidth( ::hImage )
         ::nHeight := _OOHG_BitMapHeight( ::hImage )
      ENDIF
      ::RePaint()
      ::cPicture := ""
   EndIf
Return nil

*------------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TButton
*------------------------------------------------------------------------------*
Return ( ::Caption := uValue )

*-----------------------------------------------------------------------------*
METHOD RePaint() CLASS TButton
*-----------------------------------------------------------------------------*
   IF ValidHandler( ::hImage )
      IF ValidHandler( ::AuxHandle )
         DeleteObject( ::AuxHandle )
      ENDIF
      ::AuxHandle := NIL
      ::TControl:SizePos()
      IF OSisWinXPorLater() .AND. ( LEN( ::Caption ) > 0 .OR. ::lThemed )
         ::ImageList := SetImageXP( ::hWnd, ::hImage, ::nAlign, -1, ::aImageMargin[1], ::aImageMargin[2], ::aImageMargin[3], ::aImageMargin[4], ::Stretch, ::AutoFit )
         ::ReDraw()
      ELSEIF ::Stretch .OR. ::AutoFit
         ::AuxHandle := _OOHG_SetBitmap( Self, ::hImage, BM_SETIMAGE, ::Stretch, ::AutoFit )
      ELSE
         SendMessage( ::hWnd, BM_SETIMAGE, IMAGE_BITMAP, ::hImage )
      ENDIF
   ENDIF
RETURN Self

*-----------------------------------------------------------------------------*
METHOD SizePos( Row, Col, Width, Height ) CLASS TButton
*-----------------------------------------------------------------------------*
LOCAL uRet
   uRet := ::Super:SizePos( Row, Col, Width, Height )
   ::RePaint()
RETURN uRet

*-----------------------------------------------------------------------------*
METHOD Release() CLASS TButton
*-----------------------------------------------------------------------------*
   DeleteObject( ::hImage )
RETURN ::Super:Release()

*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TButton
*-----------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam )

   If nNotify == NM_CUSTOMDRAW
/*
      If IsWindowStyle( ::hWnd, BS_BITMAP ) .AND. ;
         ::lThemed .AND. ;
         IsAppThemed() .AND. ;
         ValidHandler( ::hImage )
*/
      If ::lThemed .AND. IsAppThemed()
         Return TButton_Notify_CustomDraw( lParam, ! ::lNoHotLight )
      EndIf
   EndIf

Return ::Super:Events_Notify( wParam, lParam )

*-----------------------------------------------------------------------------*
METHOD ImageMargin( aMargins ) CLASS TButton
*-----------------------------------------------------------------------------*
LOCAL i

   If HB_IsArray( aMargins )
      For i := 1 to MIN( 4, LEN( aMargins ) )
         If HB_IsNumeric( aMargins[i] )
            ::aImageMargin[i] := aMargins[i]
         EndIf
      Next
      
      ::RePaint()
   ElseIf HB_IsNumeric( aMargins )
      ::aImageMargin := {aMargins, aMargins, aMargins, aMargins}
      
      ::RePaint()
   EndIf
   
Return ::aImageMargin

#pragma BEGINDUMP

#ifndef HB_OS_WIN_32_USED
   #define HB_OS_WIN_32_USED
#endif

#ifndef _WIN32_IE
   #define _WIN32_IE 0x0500
#endif
#if ( _WIN32_IE < 0x0500 )
   #undef _WIN32_IE
   #define _WIN32_IE 0x0500
#endif

#ifndef _WIN32_WINNT
   #define _WIN32_WINNT 0x0501
#endif
#if ( _WIN32_WINNT < 0x0501 )
   #undef _WIN32_WINNT
   #define _WIN32_WINNT 0x0501
#endif

#include <hbapi.h>
#include <windows.h>
#include <commctrl.h>
//#include <uxtheme.h>
//#include <tmschema.h>
#include "oohg.h"

#ifndef BCM_FIRST
   #define BCM_FIRST     0x1600
#endif

#ifndef BCM_SETIMAGELIST
   typedef struct {
       HIMAGELIST himl;
       RECT margin;
       UINT uAlign;
   } BUTTON_IMAGELIST, *PBUTTON_IMAGELIST;

   #define BCM_SETIMAGELIST     ( BCM_FIRST + 2 )
   #define BCM_GETIMAGELIST     ( BCM_FIRST + 3 )
#endif

typedef struct _MARGINS {
	int cxLeftWidth;
	int cxRightWidth;
	int cyTopHeight;
	int cyBottomHeight;
} MARGINS, *PMARGINS;
typedef HANDLE HTHEME;

enum {
	BP_PUSHBUTTON = 1,
	BP_RADIOBUTTON = 2,
	BP_CHECKBOX = 3,
	BP_GROUPBOX = 4,
	BP_USERBUTTON = 5
};

enum {
	PBS_NORMAL = 1,
	PBS_HOT = 2,
	PBS_PRESSED = 3,
	PBS_DISABLED = 4,
	PBS_DEFAULTED = 5
};

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

   hbutton = CreateWindowEx( StyleEx, "button", hb_parc( 2 ), Style,
                             hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ), hb_parni( 7 ),
                             HWNDparam( 1 ), ( HMENU ) hb_parni( 3 ), GetModuleHandle( NULL ), NULL );

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( hbutton, GWL_WNDPROC, ( LONG ) SubClassFunc );

   HWNDret( hbutton );
}

HB_FUNC( SETIMAGEXP )
{
   HIMAGELIST himl;
   BUTTON_IMAGELIST bi ;
   HBITMAP hBmp;
   HBITMAP hBmp2;
   BITMAP bm;
   COLORREF clrColor;
   HWND hWnd;
   int iHrzMrg = 0, iVrtMrg = 0;

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
      if( hb_parnl( 4 ) == -1 )
      {
         clrColor = GetSysColor( COLOR_BTNFACE );
      }
      else
      {
         clrColor = ( COLORREF ) hb_parnl( 4 );
      }
      GetObject( hBmp, sizeof( bm ), &bm );
      if( hb_parl( 9 ) )            // Stretch
      {
         hBmp2 = _OOHG_ScaleImage( hWnd, hBmp, 0, 0, TRUE, hb_parnl( 4 ), FALSE, iHrzMrg, iVrtMrg );
      }
      else if( hb_parl( 10 ) )      // AutoSize
      {
         hBmp2 = _OOHG_ScaleImage( hWnd, hBmp, 0, 0, FALSE, hb_parnl( 4 ), FALSE, iHrzMrg, iVrtMrg );
      }
      else                          // No scale
      {
         hBmp2 = _OOHG_ScaleImage( hWnd, hBmp, bm.bmWidth, bm.bmHeight, FALSE, hb_parnl( 4 ), FALSE, iHrzMrg, iVrtMrg );
      }
      GetObject( hBmp2, sizeof( bm ), &bm );
      himl = ImageList_Create( bm.bmWidth, bm.bmHeight, ILC_COLOR32 | ILC_MASK, 2, 2 );
      ImageList_AddMasked( himl, hBmp2, clrColor );
      memset( &bm, 0, sizeof( bm ) );
      bi.himl = himl;
      bi.margin.top = hb_parni( 5 );
      bi.margin.left = hb_parni( 6 );
      bi.margin.bottom = hb_parni( 7 );
      bi.margin.right = hb_parni( 8 );
      bi.uAlign = hb_parni( 3 );
      SendMessage( hWnd, BCM_SETIMAGELIST, 0, ( LPARAM ) &bi );
      DeleteObject( hBmp2 );
      // This handle must be explicitly released !!!
      hb_retnl( (LONG) himl );
   }
}

/*
The following function was derived from CImageButtonWithStyle Class by Stephen C. Steel
http://www.codeproject.com/KB/buttons/imagebuttonwithstyle.aspx
*/

typedef int (CALLBACK *CALL_OPENTHEMEDATA )( HWND, LPCWSTR );
typedef int (CALLBACK *CALL_DRAWTHEMEBACKGROUND )( HTHEME, HDC, int, int, const RECT*, const RECT* );
typedef int (CALLBACK *CALL_GETTHEMEBACKGROUNDCONTENTRECT )( HTHEME, HDC, int, int, const RECT*, RECT* );
typedef int (CALLBACK *CALL_CLOSETHEMEDATA )( HTHEME );
typedef int (CALLBACK *CALL_DRAWTHEMEPARENTBACKGROUND )( HWND, HDC, RECT* );

int TButton_Notify_CustomDraw( LPARAM lParam, BOOL bHotLight )
{
   HMODULE hInstDLL;
   LPNMCUSTOMDRAW pCustomDraw = (LPNMCUSTOMDRAW) lParam;
   CALL_DRAWTHEMEPARENTBACKGROUND dwProcDrawThemeParentBackground;
   CALL_OPENTHEMEDATA dwProcOpenThemeData;
   HTHEME hTheme;
   LONG style;
   int state_id;
   CALL_DRAWTHEMEBACKGROUND dwProcDrawThemeBackground;
   CALL_GETTHEMEBACKGROUNDCONTENTRECT dwProcGetThemeBackgroundContentRect;
   RECT content_rect;
   CALL_CLOSETHEMEDATA dwProcCloseThemeData;

   hInstDLL = LoadLibrary( "UXTHEME.DLL" );
   if( ! hInstDLL )
   {
      return CDRF_DODEFAULT;
   }

   if( pCustomDraw->dwDrawStage == CDDS_PREERASE )
   {
      /* erase background (according to parent window's themed background) */
      dwProcDrawThemeParentBackground = ( CALL_DRAWTHEMEPARENTBACKGROUND ) GetProcAddress( hInstDLL, "DrawThemeParentBackground" );
      if( ! dwProcDrawThemeParentBackground )
      {
         FreeLibrary( hInstDLL );
         return CDRF_DODEFAULT;
      }
      ( dwProcDrawThemeParentBackground )( pCustomDraw->hdr.hwndFrom, pCustomDraw->hdc, &pCustomDraw->rc );
   }

   if (pCustomDraw->dwDrawStage == CDDS_PREERASE || pCustomDraw->dwDrawStage == CDDS_PREPAINT)
   {
      /* get theme handle */
      dwProcOpenThemeData = ( CALL_OPENTHEMEDATA ) GetProcAddress( hInstDLL, "OpenThemeData" );
      if( ! dwProcOpenThemeData )
      {
         FreeLibrary( hInstDLL );
         return CDRF_DODEFAULT;
      }

      hTheme = (HTHEME) ( dwProcOpenThemeData )( pCustomDraw->hdr.hwndFrom, L"BUTTON" );
      if( ! hTheme )
      {
         FreeLibrary( hInstDLL );
         return CDRF_DODEFAULT;
      }

      /* determine state for DrawThemeBackground()
         note: order of these tests is significant */
      style = GetWindowLong( pCustomDraw->hdr.hwndFrom, GWL_STYLE );

      state_id = PBS_NORMAL;
      
      if( style & WS_DISABLED )
      {
         state_id = PBS_DISABLED;
      }
      else if( pCustomDraw->uItemState & CDIS_SELECTED )
      {
         state_id = PBS_PRESSED;
      }
      else if( ( pCustomDraw->uItemState & CDIS_HOT ) && bHotLight )
      {
         state_id = PBS_HOT;
      }
      else if( style & BS_DEFPUSHBUTTON )
      {
         state_id = PBS_DEFAULTED;
      }

      /* draw themed button background appropriate to button state */
      dwProcDrawThemeBackground = ( CALL_DRAWTHEMEBACKGROUND ) GetProcAddress( hInstDLL, "DrawThemeBackground" );
      if( ! dwProcDrawThemeBackground )
      {
         FreeLibrary( hInstDLL );
         return CDRF_DODEFAULT;
      }
      ( dwProcDrawThemeBackground )( hTheme, pCustomDraw->hdc, BP_PUSHBUTTON, state_id, &pCustomDraw->rc, NULL );

      /* get content rectangle (space inside button for image) */
      dwProcGetThemeBackgroundContentRect = ( CALL_GETTHEMEBACKGROUNDCONTENTRECT ) GetProcAddress( hInstDLL, "GetThemeBackgroundContentRect" );
      if( ! dwProcGetThemeBackgroundContentRect )
      {
         FreeLibrary( hInstDLL );
         return CDRF_DODEFAULT;
      }
      ( dwProcGetThemeBackgroundContentRect )( hTheme, pCustomDraw->hdc, BP_PUSHBUTTON, state_id, &pCustomDraw->rc, &content_rect );

      /* close theme */
      dwProcCloseThemeData = ( CALL_CLOSETHEMEDATA ) GetProcAddress( hInstDLL, "CloseThemeData" );
      if( dwProcCloseThemeData )
      {
         ( dwProcCloseThemeData )( hTheme );
      }

      FreeLibrary( hInstDLL );
   }

   return CDRF_DODEFAULT;
}

HB_FUNC( TBUTTON_NOTIFY_CUSTOMDRAW )
{
   hb_retni( TButton_Notify_CustomDraw( (LPARAM) hb_parnl( 1 ), hb_parl( 2 ) ) );
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
               strikeout, field, lRtl, cImage, cBuffer, hBitMap, ;
               lNoLoadTrans, lScale, lNo3DColors, lAutoFit, lNoDIB, backcolor, ;
               lDisabled, themed, aImageMargin, OnMouseMove, cAlign, lMultiLine, ;
               flat, lNoHotLight ) CLASS TButtonCheck
*-----------------------------------------------------------------------------*
Local ControlHandle, nStyle, lBitMap, i

   ASSIGN ::nCol    VALUE x TYPE "N"
   ASSIGN ::nRow    VALUE y TYPE "N"
   ASSIGN ::nWidth  VALUE w TYPE "N"
   ASSIGN ::nHeight VALUE h TYPE "N"

   lBitMap := ( ( ValType( cImage ) $ "CM" .AND. ! Empty( cImage ) ) .OR. ;
                ( ValType( cBuffer ) $ "CM" .AND. ! Empty( cBuffer ) ) .OR. ;
                ValidHandler( hBitMap ) ) .AND. ;
              ( ! ValType( Caption ) $ "CM" .OR. Empty( Caption ) )

   If HB_IsArray( aImageMargin )
      For i := 1 to MIN( 4, LEN( aImageMargin ) )
         If HB_IsNumeric( aImageMargin[i] )
            ::aImageMargin[i] := aImageMargin[i]
         EndIf
      Next
   ElseIf HB_IsNumeric( aImageMargin )
      ::aImageMargin := {aImageMargin, aImageMargin, aImageMargin, aImageMargin}
   EndIf

   ::SetForm( ControlName, ParentForm, FontName, FontSize, , backcolor, , lRtl )

   nStyle := ::InitStyle( ,, Invisible, NoTabStop, lDisabled ) + ;
             BS_AUTOCHECKBOX + ;
             BS_PUSHLIKE + ;
             if( ValType( flat ) == "L"      .AND. flat,         BS_FLAT, 0 )     + ;
             if( lBitMap,                                        BS_BITMAP, 0 ) + ;
             if( ValType( lMultiLine ) == "L" .AND. lMultiLine,  BS_MULTILINE, 0 )

   ControlHandle := InitButton( ::ContainerhWnd, Caption, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, ::lRtl, nStyle )

   ::Register( ControlHandle, ControlName, HelpId,, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   ::Caption := Caption

   ASSIGN ::lNoTransparent VALUE lNoLoadTrans TYPE "L"
   ASSIGN ::Stretch        VALUE lScale       TYPE "L"
   ASSIGN ::lThemed        VALUE themed       TYPE "L" DEFAULT IsAppThemed()
   ASSIGN ::AutoFit        VALUE lAutoFit     TYPE "L"
   ASSIGN ::lNo3DColors    VALUE lNo3DColors  TYPE "L"
   ASSIGN ::lNoDIBSection  VALUE lNoDIB       TYPE "L"
   ASSIGN ::lNoHotLight    VALUE lNoHotLight  TYPE "L"

   If ( ( ValType( cImage ) $ "CM" .AND. ! Empty( cImage ) ) .OR. ;
        ( ValType( cBuffer ) $ "CM" .AND. ! Empty( cBuffer ) ) .OR. ;
        ValidHandler( hBitMap ) )
      // The button has an image
      If Empty( ::Caption )
         DEFAULT cAlign TO "CENTER"
      Else
         DEFAULT cAlign TO "LEFT"
      EndIf
   EndIf

   IF ValType( cAlign ) $ "CM"
      cAlign := ALLTRIM( UPPER( cAlign ) )
      DO CASE
      CASE EMPTY( cAlign )
         cAlign := BUTTON_IMAGELIST_ALIGN_TOP
      CASE "LEFT" == cAlign
         cAlign := BUTTON_IMAGELIST_ALIGN_LEFT
      CASE "RIGHT" == cAlign
         cAlign := BUTTON_IMAGELIST_ALIGN_RIGHT
      CASE "BOTTOM" == cAlign
         cAlign := BUTTON_IMAGELIST_ALIGN_BOTTOM
      CASE "CENTER" == cAlign
         cAlign := BUTTON_IMAGELIST_ALIGN_CENTER
      OTHERWISE
         cAlign := BUTTON_IMAGELIST_ALIGN_TOP
      ENDCASE
   ENDIF
   IF ValType( cAlign ) == "N"
      ::nAlign := cAlign
   ENDIF

   ::Picture := cImage
   If ! ValidHandler( ::hImage )
      ::Buffer := cBuffer
      If ! ValidHandler( ::hImage )
         ::HBitMap := hBitMap
      EndIf
   EndIf

   If ! HB_IsLogical( Value )
      Value := .F.
   EndIf
   ::SetVarBlock( Field, Value )

   ASSIGN ::OnLostFocus VALUE lostfocus       TYPE "B"
   ASSIGN ::OnGotFocus  VALUE gotfocus        TYPE "B"
   ASSIGN ::OnChange    VALUE ChangeProcedure TYPE "B"
   ASSIGN ::OnMouseMove VALUE OnMouseMove     TYPE "B"

Return Self

*-----------------------------------------------------------------------------*
METHOD DefineImage( ControlName, ParentForm, x, y, Caption, Value, fontname, ;
                    fontsize, tooltip, changeprocedure, w, h, lostfocus, gotfocus, ;
                    HelpId, invisible, notabstop, bold, italic, underline, ;
                    strikeout, field, lRtl, cImage, cBuffer, hBitMap, ;
                    lNoLoadTrans, lScale, lNo3DColors, lAutoFit, lNoDIB, backcolor, ;
                    lDisabled, themed, aImageMargin, OnMouseMove, cAlign, lMultiLine, ;
                    flat, lNoHotLight ) CLASS TButtonCheck
*-----------------------------------------------------------------------------*
   If Empty( cBuffer )
      cBuffer := ""
   EndIf
Return ::Define( ControlName, ParentForm, x, y, Caption, Value, fontname, ;
                 fontsize, tooltip, changeprocedure, w, h, lostfocus, gotfocus, ;
                 HelpId, invisible, notabstop, bold, italic, underline, ;
                 strikeout, field, lRtl, cImage, cBuffer, hBitMap, ;
                 lNoLoadTrans, lScale, lNo3DColors, lAutoFit, lNoDIB, backcolor, ;
                 lDisabled, themed, aImageMargin, OnMouseMove, cAlign, lMultiLine, ;
                 flat, lNoHotLight )

*------------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TButtonCheck
*------------------------------------------------------------------------------*
   IF ValType( uValue ) == "L"
      SendMessage( ::hWnd, BM_SETCHECK, if( uValue, BST_CHECKED, BST_UNCHECKED ), 0 )
      ::DoChange()
   ELSE
      uValue := ( SendMessage( ::hWnd, BM_GETCHECK , 0 , 0 ) == BST_CHECKED )
   ENDIF
RETURN uValue

*------------------------------------------------------------------------------*
METHOD Events_Command( wParam ) CLASS TButtonCheck
*------------------------------------------------------------------------------*
Local Hi_wParam := HIWORD( wParam )
   If Hi_wParam == BN_CLICKED
      ::DoChange()
   EndIf
Return ::Super:Events_Command( wParam )
