/*
 * $Id: h_image.prg $
 */
/*
 * ooHG source code:
 * Image control
 *
 * Copyright 2005-2019 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2019 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2019 Contributors, https://harbour.github.io/
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
 * along with this software; see the file LICENSE.txt. If not, write to
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

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TImage FROM TControl

   DATA aCopies                   INIT {}
   DATA aExcludeArea              INIT {}
   DATA AutoFit                   INIT .T.
   DATA bOnClick                  INIT ""
   DATA bOnDblClick               INIT ""
   DATA bOnMClick                 INIT ""
   DATA bOnMDblClick              INIT ""
   DATA bOnRClick                 INIT ""
   DATA bOnRDblClick              INIT ""
   DATA cBuffer                   INIT ""
   DATA cPicture                  INIT ""
   DATA hImage                    INIT NIL
   DATA ImageSize                 INIT .F.
   DATA lNoCheckDepth             INIT .F.
   DATA lNo3DColors               INIT .F.
   DATA lNoDIBSection             INIT .F.
   DATA lNoTransparent            INIT .F.
   DATA lParentRedraw             INIT .T.
   DATA nHeight                   INIT 100
   DATA nWidth                    INIT 100
   DATA Stretch                   INIT .F.
   DATA Type                      INIT "IMAGE" READONLY

   METHOD Blend
   METHOD Buffer                  SETGET
   METHOD Copy
   METHOD CurrentSize
   METHOD Define
   METHOD Events
   METHOD HBitMap                 SETGET
   METHOD OnClick                 SETGET
   METHOD OnDblClick              SETGET
   METHOD OnMClick                SETGET
   METHOD OnMDblClick             SETGET
   METHOD OnRClick                SETGET
   METHOD OnRDblClick             SETGET
   METHOD OriginalSize
   METHOD Picture                 SETGET
   METHOD Release
   METHOD RePaint
   METHOD Save
   METHOD SizePos
   METHOD ToolTip                 SETGET

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( cControlName, uParentForm, nCol, nRow, cFileName, nWidth, nHeight, bOnClick, nHelpId, lInvisible, ;
      lStretch, lWhiteBackground, lRtl, uBackColor, cBuffer, hBitMap, lAutofit, lImagesize, cToolTip, lBorder, ;
      lClientEdge, lNoLoadTrans, lNo3DColors, lNoDIB, lStyleTransp, aArea, lDisabled, bOnChange, bOnDblClick, ;
      bOnMClick, bOnMDblClick, bOnRClick, bOnRDblClick, lNoCheckDepth, lNoRedraw ) CLASS TImage

   LOCAL nControlHandle, nStyle, nStyleEx

   ASSIGN ::nCol           VALUE nCol         TYPE "N"
   ASSIGN ::nRow           VALUE nRow         TYPE "N"
   ASSIGN ::nWidth         VALUE nWidth       TYPE "N"
   ASSIGN ::nHeight        VALUE nHeight      TYPE "N"
   ASSIGN ::Stretch        VALUE lStretch     TYPE "L"
   ASSIGN ::AutoFit        VALUE lAutofit     TYPE "L"
   ASSIGN ::ImageSize      VALUE lImagesize   TYPE "L"
   ASSIGN ::lNoTransparent VALUE lNoLoadTrans TYPE "L"
   ASSIGN ::lNo3DColors    VALUE lNo3DColors  TYPE "L"
   ASSIGN ::lNoDIBSection  VALUE lNoDIB       TYPE "L"
   ASSIGN ::aExcludeArea   VALUE aArea        TYPE "A"
   ASSIGN lDisabled        VALUE lDisabled    TYPE "L" DEFAULT .F.

   IF HB_ISLOGICAL( lNoCheckDepth ) .AND. lNoCheckDepth
      ::lNoCheckDepth := .T.
   ENDIF

   IF HB_ISLOGICAL( lNoRedraw ) .AND. lNoRedraw
      ::lParentRedraw := .F.
   ENDIF

   ::SetForm( cControlName, uParentForm, , , , uBackColor, , lRtl )
   IF HB_ISLOGICAL( lWhiteBackground ) .AND. lWhiteBackground
      ::BackColor := WHITE
   ENDIF

   nStyle := ::InitStyle( , , lInvisible, .T., lDisabled ) + ;
                iif( HB_ISLOGICAL( lBorder ) .AND. lBorder, WS_BORDER, 0 )

   nStyleEx := iif( HB_ISLOGICAL( lClientEdge ) .AND. lClientEdge, WS_EX_CLIENTEDGE, 0 )
   IF HB_ISLOGICAL( lStyleTransp ) .AND. lStyleTransp
      nStyleEx += WS_EX_TRANSPARENT
   ENDIF

   nControlHandle := INITIMAGE( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, nStyle, ::lRtl, nStyleEx )

   ::Register( nControlHandle, cControlName, nHelpId, , cToolTip )

   ::Picture := cFileName
   IF ! VALIDHANDLER( ::hImage )
      ::Buffer := cBuffer
      IF ! VALIDHANDLER( ::hImage )
         ::HBitMap := hBitMap
      ENDIF
   ENDIF

   ASSIGN ::OnClick     VALUE bOnClick     TYPE "B"
   ASSIGN ::OnChange    VALUE bOnChange    TYPE "B"
   ASSIGN ::OnDblClick  VALUE bOnDblClick  TYPE "B"
   ASSIGN ::OnMClick    VALUE bOnMClick    TYPE "B"
   ASSIGN ::OnMDblClick VALUE bOnMDblClick TYPE "B"
   ASSIGN ::OnRClick    VALUE bOnRClick    TYPE "B"
   ASSIGN ::OnRDblClick VALUE bOnRDblClick TYPE "B"

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Picture( cPicture ) CLASS TImage

   LOCAL nAttrib, aPictSize, lSet

   IF ValType( cPicture ) $ "CM"
      DeleteObject( ::hImage )
      ::cPicture := cPicture
      ::cBuffer := ""

      IF ::lNoDIBSection
         nAttrib := LR_DEFAULTCOLOR
         IF ! ::lNo3DColors .OR. ! ::lNoTransparent
            IF ::lNoCheckDepth
               lSet := .T.
            ELSE
               aPictSize := _OOHG_SizeOfBitmapFromFile( cPicture )      // {width, height, depth}
               lSet := aPictSize[ 3 ] <= 8
            ENDIF
            IF lSet
              IF ! ::lNo3DColors
                 nAttrib += LR_LOADMAP3DCOLORS
              ENDIF
              IF ! ::lNoTransparent
                 nAttrib += LR_LOADTRANSPARENT
              ENDIF
            ENDIF
         ENDIF
      ELSE
         nAttrib := LR_CREATEDIBSECTION
      ENDIF

      // load image at full size
      ::hImage := _OOHG_BitmapFromFile( Self, cPicture, nAttrib, .F. )
      IF ValidHandler( ::hImage )
         IF ::ImageSize
            ::nWidth  := _OOHG_BitMapWidth( ::hImage )
            ::nHeight := _OOHG_BitMapHeight( ::hImage )
         ENDIF
      ELSE
         ::hImage := NIL
      ENDIF
      ::RePaint()

      ::DoEvent( ::OnChange, "CHANGE" )
   ENDIF

   RETURN ::cPicture

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD HBitMap( hBitMap ) CLASS TImage

   IF ValType( hBitMap ) $ "NP"
      DeleteObject( ::hImage )
      ::cPicture := ""
      ::cBuffer := ""

      IF ValidHandler( hBitMap )
         ::hImage := hBitMap
         IF ::ImageSize
            ::nWidth  := _OOHG_BitMapWidth( ::hImage )
            ::nHeight := _OOHG_BitMapHeight( ::hImage )
         ENDIF
      ELSE
         ::hImage := NIL
      ENDIF
      ::RePaint()

      ::DoEvent( ::OnChange, "CHANGE" )
   ENDIF

   RETURN ::hImage

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Buffer( cBuffer ) CLASS TImage

   IF ValType( cBuffer ) $ "CM"
      DeleteObject( ::hImage )
      ::cPicture := ""
      ::cBuffer := cBuffer

      // load image at full size
      ::hImage := _OOHG_BitMapFromBuffer( Self, cBuffer, .F. )
      IF ValidHandler( ::hImage )
         IF ::ImageSize
            ::nWidth  := _OOHG_BitMapWidth( ::hImage )
            ::nHeight := _OOHG_BitMapHeight( ::hImage )
         ENDIF
      ELSE
         ::hImage := NIL
      ENDIF
      ::RePaint()

      ::DoEvent( ::OnChange, "CHANGE" )
   ENDIF

   RETURN ::cBuffer

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD OnClick( bOnClick ) CLASS TImage

   LOCAL lSet

   IF PCount() > 0
      ::bOnClick := bOnClick

      lSet := HB_ISBLOCK( ::bOnClick ) .OR. ;
              HB_ISBLOCK( ::bOnDblClick ) .OR. ;
              HB_ISBLOCK( ::bOnMClick ) .OR. ;
              HB_ISBLOCK( ::bOnMDblClick ) .OR. ;
              HB_ISBLOCK( ::bOnRClick ) .OR. ;
              HB_ISBLOCK( ::bOnRDblClick )

      WINDOWSTYLEFLAG( ::hWnd, SS_NOTIFY, iif( lSet, SS_NOTIFY, 0 ) )
      TIMAGE_SETNOTIFY( Self, lSet )
   ENDIF

   RETURN ::bOnClick

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD OnDblClick( bOnDblClick ) CLASS TImage

   LOCAL lSet

   IF PCount() > 0
      ::bOnDblClick := bOnDblClick

      lSet := HB_ISBLOCK( ::bOnClick ) .OR. ;
              HB_ISBLOCK( ::bOnDblClick ) .OR. ;
              HB_ISBLOCK( ::bOnMClick ) .OR. ;
              HB_ISBLOCK( ::bOnMDblClick ) .OR. ;
              HB_ISBLOCK( ::bOnRClick ) .OR. ;
              HB_ISBLOCK( ::bOnRDblClick )

      WINDOWSTYLEFLAG( ::hWnd, SS_NOTIFY, iif( lSet, SS_NOTIFY, 0 ) )
      TIMAGE_SETNOTIFY( Self, lSet )
   ENDIF

   RETURN ::bOnDblClick

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD OnMClick( bOnMClick ) CLASS TImage

   LOCAL lSet

   IF PCount() > 0
      ::bOnMClick := bOnMClick

      lSet := HB_ISBLOCK( ::bOnClick ) .OR. ;
              HB_ISBLOCK( ::bOnDblClick ) .OR. ;
              HB_ISBLOCK( ::bOnMClick ) .OR. ;
              HB_ISBLOCK( ::bOnMDblClick ) .OR. ;
              HB_ISBLOCK( ::bOnRClick ) .OR. ;
              HB_ISBLOCK( ::bOnRDblClick )

      WINDOWSTYLEFLAG( ::hWnd, SS_NOTIFY, iif( lSet, SS_NOTIFY, 0 ) )
      TIMAGE_SETNOTIFY( Self, lSet )
   ENDIF

   RETURN ::bOnMClick

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD OnMDblClick( bOnMDblClick ) CLASS TImage

   LOCAL lSet

   IF PCount() > 0
      ::bOnMDblClick := bOnMDblClick

      lSet := HB_ISBLOCK( ::bOnClick ) .OR. ;
              HB_ISBLOCK( ::bOnDblClick ) .OR. ;
              HB_ISBLOCK( ::bOnMClick ) .OR. ;
              HB_ISBLOCK( ::bOnMDblClick ) .OR. ;
              HB_ISBLOCK( ::bOnRClick ) .OR. ;
              HB_ISBLOCK( ::bOnRDblClick )

      WINDOWSTYLEFLAG( ::hWnd, SS_NOTIFY, iif( lSet, SS_NOTIFY, 0 ) )
      TIMAGE_SETNOTIFY( Self, lSet )
   ENDIF

   RETURN ::bOnMDblClick

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD OnRClick( bOnRClick ) CLASS TImage

   LOCAL lSet

   IF PCount() > 0
      ::bOnRClick := bOnRClick

      lSet := HB_ISBLOCK( ::bOnClick ) .OR. ;
              HB_ISBLOCK( ::bOnDblClick ) .OR. ;
              HB_ISBLOCK( ::bOnMClick ) .OR. ;
              HB_ISBLOCK( ::bOnMDblClick ) .OR. ;
              HB_ISBLOCK( ::bOnRClick ) .OR. ;
              HB_ISBLOCK( ::bOnRDblClick )

      WINDOWSTYLEFLAG( ::hWnd, SS_NOTIFY, iif( lSet, SS_NOTIFY, 0 ) )
      TIMAGE_SETNOTIFY( Self, lSet )
   ENDIF

   RETURN ::bOnRClick

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD OnRDblClick( bOnRDblClick ) CLASS TImage

   LOCAL lSet

   IF PCount() > 0
      ::bOnRDblClick := bOnRDblClick

      lSet := HB_ISBLOCK( ::bOnClick ) .OR. ;
              HB_ISBLOCK( ::bOnDblClick ) .OR. ;
              HB_ISBLOCK( ::bOnMClick ) .OR. ;
              HB_ISBLOCK( ::bOnMDblClick ) .OR. ;
              HB_ISBLOCK( ::bOnRClick ) .OR. ;
              HB_ISBLOCK( ::bOnRDblClick )

      WINDOWSTYLEFLAG( ::hWnd, SS_NOTIFY, iif( lSet, SS_NOTIFY, 0 ) )
      TIMAGE_SETNOTIFY( Self, lSet )
   ENDIF

   RETURN ::bOnRDblClick

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ToolTip( uToolTip ) CLASS TImage

   IF PCount() > 0
      TIMAGE_SETTOOLTIP( Self,  ( ValType( uToolTip ) $ "CM" .AND. ! Empty( uToolTip ) ) .OR. HB_ISBLOCK( uToolTip ) )
      ::Super:ToolTip( uToolTip )
   ENDIF

   RETURN ::cToolTip

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SizePos( nRow, nCol, nWidth, nHeight ) CLASS TImage

   LOCAL uRet

   uRet := ::Super:SizePos( nRow, nCol, nWidth, nHeight )
   ::RePaint()

   RETURN uRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD RePaint() CLASS TImage

   IF VALIDHANDLER( ::hImage )
      IF VALIDHANDLER( ::AuxHandle )
         DELETEOBJECT( ::AuxHandle )
      ENDIF
      ::AuxHandle := NIL
      ::Super:SizePos()
      IF ::Stretch .OR. ::AutoFit
         ::AuxHandle := _OOHG_SETBITMAP( Self, ::hImage, STM_SETIMAGE, ::Stretch, ::AutoFit )
      ELSE
         SENDMESSAGE( ::hWnd, STM_SETIMAGE, IMAGE_BITMAP, ::hImage )
      ENDIF
      IF ::lParentRedraw
         ::Parent:Redraw()
      ENDIF
   ELSE
      PAINTBKGND( ::hWnd, ::BackColor )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Release() CLASS TImage

   LOCAL i

   DELETEOBJECT( ::hImage )
   ::hImage := NIL
   ::cPicture := ""
   ::cBuffer := ""
   FOR i := 1 TO Len( ::aCopies )
      DeleteObject( ::aCopies[i] )
   NEXT i

   RETURN ::Super:Release()

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD OriginalSize() CLASS TImage

   LOCAL aRet

   IF VALIDHANDLER( ::hImage )
      aRet := { _OOHG_BITMAPWIDTH( ::hImage ), _OOHG_BITMAPHEIGHT( ::hImage ) }
   ELSE
      aRet := { 0, 0 }
   ENDIF

   RETURN aRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD CurrentSize() CLASS TImage

   LOCAL aRet

   IF VALIDHANDLER( ::AuxHandle )
      aRet := { _OOHG_BITMAPWIDTH( ::AuxHandle ), _OOHG_BITMAPHEIGHT( ::AuxHandle ) }
   ELSEIF VALIDHANDLER( ::hImage )
      aRet := { _OOHG_BITMAPWIDTH( ::hImage ), _OOHG_BITMAPHEIGHT( ::hImage ) }
   ELSE
      aRet := { 0, 0 }
   ENDIF

   RETURN aRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Blend( hSprite, nImgX, nImgY, nImgW, nImgH, aColor, nSprX, nSprY, nSprW, nSprH ) CLASS TImage

   _OOHG_BLENDIMAGE( ::hImage, nImgX, nImgY, nImgW, nImgH, hSprite, aColor, nSprX, nSprY, nSprW, nSprH )
   ::RePaint()

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Copy( lAsDIB ) CLASS TImage

   DEFAULT lAsDIB TO ! ::lNoDIBSection

   AAdd( ::aCopies, _OOHG_CopyBitmap( ::hImage, 0, 0 ) )

   RETURN ATail( ::aCopies )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Save( cFile, cType, uSize, nQuality, nColorDepth ) CLASS TImage

   LOCAL nHeight, nWidth

   IF ! VALIDHANDLER( ::hImage )
      RETURN .F.
   ENDIF

   ASSIGN cType VALUE Upper( cType ) TYPE "CM" DEFAULT "BMP"

   IF HB_ISARRAY( uSize )
      ASSIGN nWidth  VALUE uSize[1] TYPE "N" DEFAULT ::CurrentSize()[1]
      ASSIGN nHeight VALUE uSize[2] TYPE "N" DEFAULT ::CurrentSize()[2]
   ELSEIF HB_ISNUMERIC( uSize )
      IF uSize <= 0
         nWidth  := ::CurrentSize()[1]
         nHeight := ::CurrentSize()[2]
      ELSE
         nWidth  := ::OriginalSize()[1] * uSize
         nHeight := ::OriginalSize()[2] * uSize
      ENDIF
   ELSE
      nWidth  := ::CurrentSize()[1]
      nHeight := ::CurrentSize()[2]
   ENDIF

   IF gPlusInit()
      IF cType == "JPEG" .OR. cType == "JPG" .OR. cType == "IMAGE/JPEG" .OR. cType == "IMAGE/JPG"
         IF ! HB_ISNUMERIC( nQuality ) .OR. nQuality < 0 .OR. nQuality > 100
            nQuality := 100
         ENDIF
         // JPEG images are always saved at 24 bpp color depth.
         gPlusSaveHBitmapToFile( ::hImage, cFile, nWidth, nHeight, "image/jpeg", nQuality, NIL )

      ELSEIF cType == "GIF" .OR. cType == "IMAGE/GIF"
         // GIF images do not support parameters.
         // GIF images are always saved at 8 bpp color depth.
         // GIF images are always compressed using LZW algorithm.
         gPlusSaveHBitmapToFile( ::hImage, cFile, nWidth, nHeight, "image/gif", NIL, NIL )

      ELSEIF cType == "TIFF" .OR. cType == "TIF" .OR. cType == "IMAGE/TIFF" .OR. cType == "IMAGE/TIF"
         IF ! HB_ISNUMERIC( nQuality ) .OR. nQuality < 0 .OR. nQuality > 1
            // This the default value: LZW compression.
            nQuality := 1
         ENDIF
         IF ! HB_ISNUMERIC( nColorDepth ) .OR. ( nColorDepth # 1 .AND. nColorDepth # 4 .AND. nColorDepth # 8 .AND. nColorDepth # 24 .AND. nColorDepth # 32 )
           // This is the default value: 32 bpp.
           nColorDepth := 32
         ENDIF
         gPlusSaveHBitmapToFile( ::hImage, cFile, nWidth, nHeight, "image/tiff", nQuality, nColorDepth )

      ELSEIF cType == "PNG" .OR. cType == "IMAGE/PNG"
         // PNG images do not support parameters.
         // PNG images are always saved at 24 bpp color depth if they don't have transparecy
         // or at 32 bpp if they have it.
         // PNG images are always compressed using ZIP algorithm.
         gPlusSaveHBitmapToFile( ::hImage, cFile, nWidth, nHeight, "image/png", NIL, NIL )

      ELSE
         // BMP images do not support parameters.
         gPlusSaveHBitmapToFile( ::hImage, cFile, nWidth, nHeight, "image/bmp", NIL, NIL )

      ENDIF
      gPlusDeInit()
   ENDIF

   RETURN FILE( cFile )

/*--------------------------------------------------------------------------------------------------------------------------------*/
#pragma BEGINDUMP

#include "hbapi.h"
#include "hbapiitm.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windows.h>
#include <windowsx.h>
#include <commctrl.h>
#include "oohg.h"

#define s_Super s_TControl

/*--------------------------------------------------------------------------------------------------------------------------------*/
static WNDPROC _OOHG_TImage_lpfnOldWndProc( WNDPROC lp )
{
   static WNDPROC lpfnOldWndProc = 0;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( ! lpfnOldWndProc )
   {
      lpfnOldWndProc = lp;
   }
   ReleaseMutex( _OOHG_GlobalMutex() );

   return lpfnOldWndProc;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, _OOHG_TImage_lpfnOldWndProc( 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( INITIMAGE )          /* FUNCTION InitImage( hWnd, hMenu, nCol, nRow, nWidth, nHeight, nStyle, lRtl, nStyleEx ) -> hWnd */
{
   HWND hCtrl;
   INT Style, StyleEx;

   Style = hb_parni( 7 ) | WS_CHILD | SS_BITMAP | SS_NOTIFY;
   StyleEx = hb_parni( 9 ) | _OOHG_RTL_Status( hb_parl( 8 ) );

   hCtrl = CreateWindowEx( StyleEx, "static", NULL, Style,
                           hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ),
                           HWNDparam( 1 ), HMENUparam( 2 ), GetModuleHandle( NULL ), NULL ) ;

   _OOHG_TImage_lpfnOldWndProc( ( WNDPROC ) SetWindowLongPtr( hCtrl, GWL_WNDPROC, ( LONG_PTR ) SubClassFunc ) );

   HWNDret( hCtrl );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
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
                  if( ( HB_ARRAYGETNL( pSector, 1 ) <= x ) &&
                      ( x < HB_ARRAYGETNL( pSector, 3 ) ) &&
                      ( HB_ARRAYGETNL( pSector, 2 ) <= y ) &&
                      ( y < HB_ARRAYGETNL( pSector, 4 ) ) )
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

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TIMAGE_EVENTS )          /* METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TImage -> uRetVal */
{
   HWND hWnd      = HWNDparam( 1 );
   UINT message   = (UINT)   hb_parni( 2 );
   WPARAM wParam  = (WPARAM) HB_PARNL( 3 );
   LPARAM lParam  = (LPARAM) HB_PARNL( 4 );
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf   = _OOHG_GetControlInfo( pSelf );
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
         hb_vmPushNumInt( wParam );
         hb_vmPushNumInt( lParam );
         hb_vmSend( 4 );
         break;
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TIMAGE_SETNOTIFY )          /* FUNCTION TImage_SetNotify( Self, lHit ) -> NIL */
{
   PHB_ITEM pSelf = hb_param( 1, HB_IT_ANY );
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   oSelf->lAux[ 0 ] = hb_parl( 2 );
   hb_ret();
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TIMAGE_SETTOOLTIP )          /* FUNCTION TImage_SetToolTip( Self, lShow ) -> NIL */
{
   PHB_ITEM pSelf = hb_param( 1, HB_IT_ANY );
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   oSelf->lAux[ 1 ] = hb_parl( 2 );
   hb_ret();
}

#pragma ENDDUMP
