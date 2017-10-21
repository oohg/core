/*
 * $Id: h_image.prg,v 1.50 2017-10-01 15:52:26 fyurisich Exp $
 */
/*
 * ooHG source code:
 * Image control
 *
 * Copyright 2005-2017 Vicente Guerra <vicente@guerra.com.mx>
 * https://sourceforge.net/projects/oohg/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2017, https://harbour.github.io/
 */
/*
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
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1335,USA (or download from http://www.gnu.org/licenses/).
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
 */


#include "oohg.ch"
#include "hbclass.ch"
#include "i_windefs.ch"

CLASS TImage FROM TControl

   DATA Type            INIT "IMAGE" READONLY
   DATA cPicture        INIT ""
   DATA Stretch         INIT .F.
   DATA AutoFit         INIT .T.
   DATA bOnClick        INIT ""
   DATA nWidth          INIT 100
   DATA nHeight         INIT 100
   DATA hImage          INIT nil
   DATA ImageSize       INIT .F.
   DATA lNoDIBSection   INIT .F.
   DATA lNo3DColors     INIT .F.
   DATA lNoTransparent  INIT .F.
   DATA aExcludeArea    INIT {}

   METHOD Define
   METHOD Picture       SETGET
   METHOD HBitMap       SETGET
   METHOD Buffer        SETGET
   METHOD OnClick       SETGET
   METHOD ToolTip       SETGET
   METHOD Events
   METHOD SizePos
   METHOD RePaint
   METHOD Release
   METHOD OriginalSize
   METHOD CurrentSize
   METHOD Blend
   METHOD Copy

   /* HB_SYMBOL_UNUSED( _OOHG_AllVars ) */

   ENDCLASS

METHOD Define( ControlName, ParentForm, x, y, FileName, w, h, ProcedureName, ;
               HelpId, invisible, stretch, lWhiteBackground, lRtl, backcolor, ;
               cBuffer, hBitMap, autofit, imagesize, ToolTip, Border, ClientEdge, ;
               lNoLoadTrans, lNo3DColors, lNoDIB, lStyleTransp, aArea, lDisabled ) CLASS TImage

   Local ControlHandle, nStyle, nStyleEx

   ASSIGN ::nCol           VALUE x            TYPE "N"
   ASSIGN ::nRow           VALUE y            TYPE "N"
   ASSIGN ::nWidth         VALUE w            TYPE "N"
   ASSIGN ::nHeight        VALUE h            TYPE "N"
   ASSIGN ::Stretch        VALUE stretch      TYPE "L"
   ASSIGN ::AutoFit        VALUE autofit      TYPE "L"
   ASSIGN ::ImageSize      VALUE imagesize    TYPE "L"
   ASSIGN ::lNoTransparent VALUE lNoLoadTrans TYPE "L"
   ASSIGN ::lNo3DColors    VALUE lNo3DColors  TYPE "L"
   ASSIGN ::lNoDIBSection  VALUE lNoDIB       TYPE "L"
   ASSIGN ::aExcludeArea   VALUE aArea        TYPE "A"
   ASSIGN lDisabled        VALUE lDisabled    TYPE "L" DEFAULT .F.

   ::SetForm( ControlName, ParentForm,,,, BackColor,, lRtl )
   If HB_IsLogical( lWhiteBackground ) .AND. lWhiteBackground
      ::BackColor := WHITE
   EndIf

   nStyle := ::InitStyle( ,, Invisible, .T., lDisabled ) + ;
             if( ValType( Border ) == "L" .AND. Border, WS_BORDER, 0 )

   nStyleEx := if( ValType( ClientEdge ) == "L" .AND. ClientEdge, WS_EX_CLIENTEDGE, 0 )
   IF HB_IsLogical( lStyleTransp ) .AND. lStyleTransp
      nStyleEx += WS_EX_TRANSPARENT
   ENDIF

   ControlHandle := InitImage( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, nStyle, ::lRtl, nStyleEx )

   ::Register( ControlHandle, ControlName, HelpId, , ToolTip )

   ::Picture := FileName
   If ! ValidHandler( ::hImage )
      ::Buffer := cBuffer
      If ! ValidHandler( ::hImage )
         ::HBitMap := hBitMap
      EndIf
   EndIf

   ASSIGN ::OnClick VALUE ProcedureName TYPE "B"

   Return Self

METHOD Picture( cPicture ) CLASS TImage

   LOCAL nAttrib, aPictSize

   IF VALTYPE( cPicture ) $ "CM"
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

      // load image at full size
      ::hImage := _OOHG_BitmapFromFile( Self, cPicture, nAttrib, .F. )
      IF ::ImageSize
         ::nWidth  := _OOHG_BitMapWidth( ::hImage )
         ::nHeight := _OOHG_BitMapHeight( ::hImage )
      ENDIF
      ::RePaint()
   ENDIF

   Return ::cPicture

*------------------------------------------------------------------------------*
METHOD HBitMap( hBitMap ) CLASS TImage
*------------------------------------------------------------------------------*
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

*------------------------------------------------------------------------------*
METHOD Buffer( cBuffer ) CLASS TImage
*------------------------------------------------------------------------------*
   If VALTYPE( cBuffer ) $ "CM"
      DeleteObject( ::hImage )
      // load image at full size
      ::hImage := _OOHG_BitmapFromBuffer( Self, cBuffer, .F. )
      IF ::ImageSize
         ::nWidth  := _OOHG_BitMapWidth( ::hImage )
         ::nHeight := _OOHG_BitMapHeight( ::hImage )
      ENDIF
      ::RePaint()
      ::cPicture := ""
   EndIf
Return nil

*------------------------------------------------------------------------------*
METHOD OnClick( bOnClick ) CLASS TImage
*------------------------------------------------------------------------------*
   If PCOUNT() > 0
      ::bOnClick := bOnClick
      WindowStyleFlag( ::hWnd, SS_NOTIFY, IF( ValType( bOnClick ) == "B", SS_NOTIFY, 0 ) )
      TImage_SetNotify( Self, HB_IsBlock( bOnClick ) )
   EndIf
Return ::bOnClick

*------------------------------------------------------------------------------*
METHOD ToolTip( cToolTip ) CLASS TImage
*------------------------------------------------------------------------------*
   If PCOUNT() > 0
      TImage_SetToolTip( Self,  ( ValType( cToolTip ) $ "CM" .AND. ! Empty( cToolTip ) ) .OR. HB_IsBlock( cToolTip ) )
   EndIf
Return ::Super:ToolTip( cToolTip )

*------------------------------------------------------------------------------*
METHOD SizePos( Row, Col, Width, Height ) CLASS TImage
*------------------------------------------------------------------------------*
LOCAL uRet
   uRet := ::Super:SizePos( Row, Col, Width, Height )
   ::RePaint()
RETURN uRet

*------------------------------------------------------------------------------*
METHOD RePaint() CLASS TImage
*------------------------------------------------------------------------------*
   IF ValidHandler( ::hImage )
      IF ValidHandler( ::AuxHandle )
         DeleteObject( ::AuxHandle )
      ENDIF
      ::AuxHandle := nil
      ::Super:SizePos()
      IF ::Stretch .OR. ::AutoFit
         ::AuxHandle := _OOHG_SetBitmap( Self, ::hImage, STM_SETIMAGE, ::Stretch, ::AutoFit )
      ELSE
         SendMessage( ::hWnd, STM_SETIMAGE, IMAGE_BITMAP, ::hImage )
      ENDIF
      ::Parent:Redraw()
   ELSE
      PaintBkGnd( ::hWnd, ::BackColor )
   ENDIF
RETURN Self

*------------------------------------------------------------------------------*
METHOD Release() CLASS TImage
*------------------------------------------------------------------------------*
   DeleteObject( ::hImage )
RETURN ::Super:Release()

*------------------------------------------------------------------------------*
METHOD OriginalSize() CLASS TImage
*------------------------------------------------------------------------------*
Local aRet
   IF ValidHandler( ::hImage )
      aRet := { _OOHG_BitMapWidth( ::hImage ), _OOHG_BitMapHeight( ::hImage ) }
   ELSE
      aRet := { 0, 0 }
   ENDIF
RETURN aRet

*------------------------------------------------------------------------------*
METHOD CurrentSize() CLASS TImage
*------------------------------------------------------------------------------*
Local aRet
   IF ValidHandler( ::AuxHandle )
      aRet := { _OOHG_BitMapWidth( ::AuxHandle ), _OOHG_BitMapHeight( ::AuxHandle ) }
   ELSEIF ValidHandler( ::hImage )
      aRet := { _OOHG_BitMapWidth( ::hImage ), _OOHG_BitMapHeight( ::hImage ) }
   ELSE
      aRet := { 0, 0 }
   ENDIF
RETURN aRet

*------------------------------------------------------------------------------*
METHOD Blend( hSprite, nImgX, nImgY, nImgW, nImgH, aColor, nSprX, nSprY, nSprW, nSprH ) CLASS TImage
*------------------------------------------------------------------------------*
   _OOHG_BlendImage( ::hImage, nImgX, nImgY, nImgW, nImgH, hSprite, aColor, nSprX, nSprY, nSprW, nSprH )
   ::RePaint()
RETURN Self

*------------------------------------------------------------------------------*
METHOD Copy( lAsDIB ) CLASS TImage
*------------------------------------------------------------------------------*
   DEFAULT lAsDIB TO ! ::lNoDIBSection
   // Do not forget to call DeleteObject
RETURN _OOHG_CopyBitmap( ::hImage, 0, 0 )


#pragma BEGINDUMP

#define s_Super s_TControl

#include "hbapi.h"
#include "hbapiitm.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windows.h>
#include <windowsx.h>
#include <commctrl.h>
#include "oohg.h"

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

HB_FUNC( INITIMAGE )   // ( hWnd, hMenu, nCol, nRow, nWidth, nHeight, nStyle, lRtl, nStyleEx )
{
   HWND h;
   int Style, StyleEx;

   StyleEx = hb_parni( 9 ) | _OOHG_RTL_Status( hb_parl( 8 ) );

   Style = hb_parni( 7 ) | WS_CHILD | SS_BITMAP | SS_NOTIFY;

   h = CreateWindowEx( StyleEx, "static", NULL, Style,
                       hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ),
                       HWNDparam( 1 ), HMENUparam( 2 ), GetModuleHandle( NULL ), NULL ) ;

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( h, GWL_WNDPROC, ( LONG ) SubClassFunc );

   HWNDret( h );
}

BOOL PtInExcludeArea( PHB_ITEM pArea, int x, int y )
{
   PHB_ITEM pSector;
   ULONG ulCount;

   if( pArea )
   {
      for( ulCount = 1; ulCount <= hb_arrayLen( pArea ); ulCount++ )
      {
         if( HB_IS_ARRAY( hb_arrayGetItemPtr( pArea, ulCount ) ) )
         {
            if( hb_arrayLen( hb_arrayGetItemPtr( pArea, ulCount ) ) >= 4 )
            {
               pSector = hb_arrayGetItemPtr( pArea, ulCount );

               if( HB_IS_NUMERIC( hb_arrayGetItemPtr( pSector, 1 ) ) &&
                   HB_IS_NUMERIC( hb_arrayGetItemPtr( pSector, 2 ) ) &&
                   HB_IS_NUMERIC( hb_arrayGetItemPtr( pSector, 3 ) ) &&
                   HB_IS_NUMERIC( hb_arrayGetItemPtr( pSector, 4 ) ) )
               {
                  if( ( hb_arrayGetNL( pSector, 1 ) <= x ) &&
                      ( x < hb_arrayGetNL( pSector, 3 ) ) &&
                      ( hb_arrayGetNL( pSector, 2 ) <= y ) &&
                      ( y < hb_arrayGetNL( pSector, 4 ) ) )
                  {
                     return TRUE;
                  }
               }
            }
         }
      }
   }

   return FALSE;
}

HB_FUNC_STATIC( TIMAGE_EVENTS )   // METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TImage
{
   HWND hWnd      = ( HWND )   hb_parnl( 1 );
   UINT message   = ( UINT )   hb_parni( 2 );
   WPARAM wParam  = ( WPARAM ) hb_parni( 3 );
   LPARAM lParam  = ( LPARAM ) hb_parnl( 4 );
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   POINT pt;
   PHB_ITEM pArea;
   BOOL bPtInExcludeArea;

   switch( message )
   {
      case WM_NCHITTEST:
         _OOHG_Send( pSelf, s_aExcludeArea );
         hb_vmSend( 0 );
         pArea = hb_param( -1, HB_IT_ARRAY );
         pt.x = GET_X_LPARAM( lParam );
         pt.y = GET_Y_LPARAM( lParam );
         MapWindowPoints( HWND_DESKTOP, hWnd, &pt, 1 );
         bPtInExcludeArea = PtInExcludeArea( pArea, pt.x, pt.y );

         if( oSelf->lAux[ 0 ] && ! bPtInExcludeArea )
         {
            hb_retni( DefWindowProc( hWnd, message, wParam, lParam ) );
         }
         else if( oSelf->lAux[ 1 ] && ! bPtInExcludeArea )
         {
            hb_retni( HTCLIENT );
         }
         else
         {
            hb_retni( HTTRANSPARENT );
         }
         break;

      default:
         _OOHG_Send( pSelf, s_Super );
         hb_vmSend( 0 );
         _OOHG_Send( hb_param( -1, HB_IT_OBJECT ), s_Events );
         HWNDpush( hWnd );
         hb_vmPushLong( message );
         hb_vmPushLong( wParam );
         hb_vmPushLong( lParam );
         hb_vmSend( 4 );
         break;
   }
}

HB_FUNC( TIMAGE_SETNOTIFY )   // ( oSelf, lHit )
{
   PHB_ITEM pSelf = hb_param( 1, HB_IT_ANY );
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   oSelf->lAux[ 0 ] = hb_parl( 2 );
   hb_ret();
}

HB_FUNC( TIMAGE_SETTOOLTIP )   // ( oSelf, lShow )
{
   PHB_ITEM pSelf = hb_param( 1, HB_IT_ANY );
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   oSelf->lAux[ 1 ] = hb_parl( 2 );
   hb_ret();
}

#pragma ENDDUMP
