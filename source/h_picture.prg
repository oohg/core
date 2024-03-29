/*
 * $Id: h_picture.prg $
 */
/*
 * OOHG source code:
 * Picture control
 *
 * Copyright 2009-2022 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2022 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2022 Contributors, https://harbour.github.io/
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
 * Boston, MA 02110-1335, USA (or download from http://www.gnu.org/licenses/).
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

CLASS TPicture FROM TControl

   DATA Type                      INIT "PICTURE" READONLY
   DATA nWidth                    INIT 100
   DATA nHeight                   INIT 100
   DATA cPicture                  INIT ""
   DATA Stretch                   INIT .F.
   DATA AutoFit                   INIT .F.
   DATA hImage                    INIT nil
   DATA ImageSize                 INIT .F.
   DATA nZoom                     INIT 1
   DATA bOnClick                  INIT nil
   DATA lCtrlCoords               INIT .F.
   DATA lNoDIBSection             INIT .F.
   DATA lNo3DColors               INIT .F.
   DATA lNoTransparent            INIT .F.
   DATA aExcludeArea              INIT {}
   DATA aCopies                   INIT {}

   METHOD Define
   METHOD RePaint
   METHOD Release
   METHOD SizePos
   METHOD Picture                 SETGET
   METHOD Buffer                  SETGET
   METHOD HBitMap                 SETGET
   METHOD Zoom                    SETGET
   METHOD Rotate                  SETGET
   METHOD OnClick                 SETGET
   METHOD HorizontalScroll        SETGET
   METHOD VerticalScroll          SETGET
   METHOD Events
   METHOD nDegree                 SETGET
   METHOD Redraw
   METHOD ToolTip                 SETGET
   METHOD OriginalSize
   METHOD CurrentSize
   METHOD Blend
   METHOD Copy

   ENDCLASS

METHOD Define( ControlName, ParentForm, x, y, FileName, w, h, cBuffer, hBitMap, ;
               stretch, autofit, imagesize, border, clientedge, BackColor, ;
               ProcedureName, ToolTip, HelpId, lRtl, invisible, lNoLoadTrans, ;
               lNo3DColors, lNoDIB, lStyleTransp, aArea, lDisabled, cRelativeTo ) CLASS TPicture

   Local ControlHandle, nStyle, nStyleEx, nError

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

   /*
   IF BackColor == NIL
      BackColor := GetSysColor( COLOR_3DFACE )
   ENDIF
   */

   IF HB_ISSTRING( cRelativeTo ) .AND. Upper( AllTrim( cRelativeTo ) ) == "CONTROL"
      ::lCtrlCoords := .T.
   ENDIF

   ::SetForm( ControlName, ParentForm,,,, BackColor, , lRtl )

   nStyle := ::InitStyle( ,, Invisible, .T., lDisabled  ) + ;
             if( ValType( BORDER ) == "L" .AND. BORDER, WS_BORDER, 0 )

   nStyleEx := if( ValType( CLIENTEDGE ) == "L" .AND. CLIENTEDGE, WS_EX_CLIENTEDGE, 0 )
   IF HB_IsLogical( lStyleTransp ) .AND. lStyleTransp
      nStyleEx += WS_EX_TRANSPARENT
   ENDIF

   IF ( nError := _OOHG_PictureControl_Register() ) # 0
      OOHG_MsgError( OOHG_MsgReplace( "TPicture.Define: Registration of _OOHG_PICTURECONTROL class failed with error @1. Program terminated.", { { "@1", hb_ntos( nError ) } } ) )
   ENDIF

   Controlhandle := InitPictureControl( ::ContainerhWnd, ::ContainerCol, ::ContainerRow, ::nWidth, ::nHeight, nStyle, nStyleEx, ::lRtl )

   ::Register( ControlHandle, ControlName, HelpId,, ToolTip )

   ::Picture := FileName
   If ! ValidHandler( ::hImage )
      ::Buffer := cBuffer
      If ! ValidHandler( ::hImage )
         ::HBitMap := hBitMap
      EndIf
   EndIf

   ASSIGN ::OnClick VALUE ProcedureName TYPE "B"

   Return Self

METHOD Picture( cPicture, lNoRepaint ) CLASS TPicture

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
      ::hImage := _OOHG_BitmapFromFile( Self, cPicture, nAttrib, .F., ::lNoTransparent )
      If ! HB_IsLogical( lNoRepaint ) .OR. ! lNoRepaint
         ::RePaint()
      EndIf
   EndIf

   Return ::cPicture

METHOD HBitMap( hBitMap, lNoRepaint ) CLASS TPicture

   If ValType( hBitmap ) $ "NP"
      DeleteObject( ::hImage )
      ::hImage := hBitMap
      If ! HB_IsLogical( lNoRepaint ) .OR. ! lNoRepaint
         ::RePaint()
      EndIf
      ::cPicture := ""
   EndIf

   Return ::hImage

METHOD Buffer( cBuffer, lNoRepaint ) CLASS TPicture

   If VALTYPE( cBuffer ) $ "CM"
      DeleteObject( ::hImage )
      ::hImage := _OOHG_BitmapFromBuffer( Self, cBuffer, .F. )
      If ! HB_IsLogical( lNoRepaint ) .OR. ! lNoRepaint
         ::RePaint()
      EndIf
      ::cPicture := ""
   EndIf

   Return nil

METHOD Zoom( nZoom, lNoRepaint ) CLASS TPicture

   If HB_IsNumeric( nZoom )
      ::nZoom := nZoom
      If ! HB_IsLogical( lNoRepaint ) .OR. ! lNoRepaint
         ::RePaint()
      EndIf
   EndIf

   Return ::nZoom

METHOD Rotate( nDegree, lNoRepaint ) CLASS TPicture

   If HB_IsNumeric( nDegree )
      ::nDegree := nDegree
      If ! HB_IsLogical( lNoRepaint ) .OR. ! lNoRepaint
         ::RePaint()
      EndIf
   EndIf

   Return ::nDegree

METHOD OnClick( bOnClick ) CLASS TPicture

   If PCOUNT() > 0
      ::bOnClick := bOnClick
      TPicture_SetNotify( Self, HB_IsBlock( bOnClick ) )
   EndIf

   Return ::bOnClick

METHOD ToolTip( cToolTip ) CLASS TPicture

   If PCOUNT() > 0
      TPicture_SetToolTip( Self, ( ValType( cToolTip ) $ "CM" .AND. ! Empty( cToolTip ) ) .OR. HB_IsBlock( cToolTip ) )
      ::Super:ToolTip( cToolTip )
   EndIf

   Return ::cToolTip

METHOD RePaint( lMoving ) CLASS TPicture

   LOCAL nWidth, nHeight, nAux

   IF ValidHandler( ::AuxHandle ) .AND. ! ::AuxHandle == ::hImage
      DeleteObject( ::AuxHandle )
   ENDIF
   IF ( ::Stretch .OR. ::AutoFit ) .AND. ! ::ImageSize
      // TO DO: ROTATE
      ::AuxHandle := _OOHG_SetBitmap( Self, ::hImage, 0, ::Stretch, ::AutoFit )
   ELSEIF ! ::nZoom == 1
      ::AuxHandle := _OOHG_ScaleImage( Self, ::hImage, ( _OOHG_BitmapWidth( ::hImage ) * ::nZoom ) + 0.999, ( _OOHG_BitmapHeight( ::hImage ) * ::nZoom ) + 0.999, .F., NIL, .F., 0, 0)
   ELSE
      ::AuxHandle := ::hImage
   ENDIF

   // Rotate size
   nWidth  := _OOHG_BitMapWidth( ::AuxHandle )
   nHeight := _OOHG_BitMapHeight( ::AuxHandle )
   IF ::nDegree == 90 .OR. ::nDegree == 270
      nAux := nWidth
      nWidth := nHeight
      nHeight := nAux
   ENDIF

   IF ::ImageSize .AND. ( ! HB_IsLogical( lMoving ) .OR. ! lMoving )
      ::Super:SizePos( ,, nWidth, nHeight )
   ENDIF
   Scrolls( ::hWnd, nWidth, nHeight )
   TPicture_SetNotify( Self, HB_IsBlock( ::bOnClick ) )
   IF ( ! HB_IsLogical( lMoving ) .OR. ! lMoving )
      ::ReDraw()
   ENDIF

   RETURN Self

METHOD SizePos( Row, Col, Width, Height ) CLASS TPicture

   LOCAL uRet

   uRet := ::Super:SizePos( Row, Col, Width, Height )
   ::RePaint( .T. )

   RETURN uRet

METHOD Release() CLASS TPicture

   LOCAL i

   DeleteObject( ::hImage )
   FOR i := 1 TO Len( ::aCopies )
      DeleteObject( ::aCopies[i] )
   NEXT i

   RETURN ::Super:Release()

METHOD HorizontalScroll( nPosition ) CLASS TPicture

   Local nRangeMin, nRangeMax, nPos

   nPos := GetScrollPos( ::hWnd, SB_HORZ )
   If HB_IsNumeric( nPosition )
      nRangeMin := GetScrollRangeMin( ::hWnd, SB_HORZ )
      nRangeMax := GetScrollRangeMax( ::hWnd, SB_HORZ )
      If nRangeMin != nRangeMax
         nPos := MIN( nRangeMax, MAX( nRangeMin, nPosition ) )
         SetScrollPos( ::hWnd, SB_HORZ, nPos, .T. )
      EndIf
   EndIf

   Return nPos

METHOD VerticalScroll( nPosition ) CLASS TPicture

   Local nRangeMin, nRangeMax, nPos

   nPos := GetScrollPos( ::hWnd, SB_VERT )
   If HB_IsNumeric( nPosition )
      nRangeMin := GetScrollRangeMin( ::hWnd, SB_VERT )
      nRangeMax := GetScrollRangeMax( ::hWnd, SB_VERT )
      If nRangeMin != nRangeMax
         nPos := MIN( nRangeMax, MAX( nRangeMin, nPosition ) )
         SetScrollPos( ::hWnd, SB_VERT, nPos, .T. )
      EndIf
   EndIf

   Return nPos

METHOD OriginalSize() CLASS TPicture

   Local aRet

   IF ValidHandler( ::hImage )
      aRet := { _OOHG_BitMapWidth( ::hImage ), _OOHG_BitMapHeight( ::hImage ) }
   ELSE
      aRet := { 0, 0 }
   ENDIF

   RETURN aRet

METHOD CurrentSize() CLASS TPicture

   Local aRet

   IF ValidHandler( ::AuxHandle )
      aRet := { _OOHG_BitMapWidth( ::AuxHandle ), _OOHG_BitMapHeight( ::AuxHandle ) }
   ELSEIF ValidHandler( ::hImage )
      aRet := { _OOHG_BitMapWidth( ::hImage ), _OOHG_BitMapHeight( ::hImage ) }
   ELSE
      aRet := { 0, 0 }
   ENDIF

   RETURN aRet

METHOD Blend( hSprite, nImgX, nImgY, nImgW, nImgH, aColor, nSprX, nSprY, nSprW, nSprH ) CLASS TPicture

   _OOHG_BlendImage( ::hImage, nImgX, nImgY, nImgW, nImgH, hSprite, aColor, nSprX, nSprY, nSprW, nSprH )
   ::RePaint()

   RETURN Self

METHOD Copy( lAsDIB ) CLASS TPicture

   DEFAULT lAsDIB TO ! ::lNoDIBSection
   // Do not forget to call DeleteObject

   AAdd( ::aCopies, _OOHG_CopyImage( ::hImage, IMAGE_BITMAP, 0, 0, iif( lAsDib, LR_CREATEDIBSECTION, 0 ) ) )

   RETURN ATail( ::aCopies )


#pragma BEGINDUMP

#include "oohg.h"
#include "hbapiitm.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windowsx.h>

#define s_Super s_TControl

/*
   lAux[ 0 ] = lSetNotify
   lAux[ 1 ] = nDegree
   lAux[ 2 ] = cToolTip
*/

/*--------------------------------------------------------------------------------------------------------------------------------*/
static WNDPROC _OOHG_PictureControl_lpfnOldWndProc( LONG_PTR lp )
{
   static LONG_PTR lpfnOldWndProc = 0;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( ! lpfnOldWndProc )
   {
      lpfnOldWndProc = lp;
   }
   ReleaseMutex( _OOHG_GlobalMutex() );

   return (WNDPROC) lpfnOldWndProc;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, _OOHG_PictureControl_lpfnOldWndProc( 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static LRESULT CALLBACK _OOHG_PictureControl_WndProc( HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam )
{
   return DefWindowProc( hWnd, message, wParam, lParam );
}

static BOOL bRegistered = FALSE;

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_PICTURECONTROL_UNREGISTER )          /* FUNCTION _OOHG_PictureControl_UnRegister() -> lRegisteredStatus */
{
   if( bRegistered )
   {
      if( UnregisterClass( "_OOHG_PICTURECONTROL", GetModuleHandle( NULL ) ) )
      {
         bRegistered = FALSE;
      }
   }

   hb_retl( bRegistered );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_PICTURECONTROL_REGISTER )          /* FUNCTION _OOHG_PictureControl_Register() -> nError */
{
   if( ! bRegistered )
   {
      WNDCLASS WndClass;
      memset( &WndClass, 0, sizeof( WndClass ) );
      WndClass.style         = CS_HREDRAW | CS_VREDRAW | CS_OWNDC | CS_DBLCLKS;
      WndClass.lpfnWndProc   = _OOHG_PictureControl_WndProc;
      WndClass.lpszClassName = "_OOHG_PICTURECONTROL";
      WndClass.hInstance     = GetModuleHandle( NULL );
      WndClass.hbrBackground = ( HBRUSH )( COLOR_BTNFACE + 1 );

      if( ! RegisterClass( &WndClass ) )
      {
         hb_retni( (int) GetLastError() );
      }

      bRegistered = TRUE;
   }

   hb_retni( 0 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( INITPICTURECONTROL )
{
   int Style = hb_parni( 6 ) | WS_CHILD | SS_NOTIFY;
   int StyleEx = hb_parni( 7 ) | _OOHG_RTL_Status( hb_parl( 8 ) );

   HWND hCtrl = CreateWindowEx( StyleEx, "_OOHG_PICTURECONTROL", "", Style, hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ),
                                hb_parni( 5 ), HWNDparam( 1 ), NULL, GetModuleHandle( NULL ), NULL );

   _OOHG_PictureControl_lpfnOldWndProc( SetWindowLongPtr( hCtrl, GWLP_WNDPROC, (LONG_PTR) SubClassFunc ) );

   HWNDret( hCtrl );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
void _OOHG_PictureControl_RePaint( PHB_ITEM pSelf, RECT * rect, HDC hdc )
{
   BITMAP bm;
   HBITMAP hBmp, hBmpOld = NULL;
   SCROLLINFO ScrollInfo;
   int iWidth = 0, iHeight = 0, iAux;
   int iScrollHorz = 0, iScrollVert = 0;
   HDC hDCAux;
   HBRUSH hBrush;
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   POINT point[ 3 ];
   int row, col, width, height;
   HWND hWnd;

   hWnd = oSelf->hWnd;
   if( ! ValidHandler( hWnd ) )
   {
      return;
   }

   /* NOTE: It affects RETURN value on stack!!!!! */
   _OOHG_Send( pSelf, s_AuxHandle );
   hb_vmSend( 0 );
   hBmp = (HBITMAP) HWNDparam( -1 );
   if( hBmp )
   {
      memset( &bm, 0, sizeof( bm ) );
      GetObject( hBmp, sizeof( bm ), &bm );
      iWidth  = bm.bmWidth;
      iHeight = bm.bmHeight;
   }

   ScrollInfo.cbSize = sizeof( SCROLLINFO );
   ScrollInfo.fMask = SIF_PAGE | SIF_POS | SIF_RANGE | SIF_TRACKPOS;
   if( GetScrollInfo( hWnd, SB_HORZ, &ScrollInfo ) )
   {
      iScrollHorz = ScrollInfo.nPos;
   }

   ScrollInfo.cbSize = sizeof( SCROLLINFO );
   ScrollInfo.fMask = SIF_PAGE | SIF_POS | SIF_RANGE | SIF_TRACKPOS;
   if( GetScrollInfo( hWnd, SB_VERT, &ScrollInfo ) )
   {
      iScrollVert = ScrollInfo.nPos;
   }

   if( oSelf->lBackColor == -1 )
   {
      hBrush = GetSysColorBrush( COLOR_BTNFACE );
   }
   else
   {
      hBrush = CreateSolidBrush( oSelf->lBackColor );
   }
   hDCAux = CreateCompatibleDC( hdc );
   if( hBmp )
   {
      hBmpOld = (HBITMAP) SelectObject( hDCAux, hBmp );
   }

   SetStretchBltMode( hdc, COLORONCOLOR );
/*
   BitBlt( hdc, rect->left, rect->top, rect->right - rect->left, rect->bottom - rect->top, hDCAux, rect->left + iScrollHorz, rect->top + iScrollVert, SRCCOPY );
*/
   if( oSelf->lAux[ 1 ] == 90 )
   {
      point[ 0 ].x = rect->right;
      point[ 0 ].y = rect->top;
      point[ 1 ].x = rect->right;
      point[ 1 ].y = rect->bottom;
      point[ 2 ].x = rect->left;
      point[ 2 ].y = rect->top;
      col = rect->top + iScrollVert;
      row = iHeight - rect->right - iScrollHorz;
      height = rect->right - rect->left;
      width = rect->bottom - rect->top;
   }
   else if( oSelf->lAux[ 1 ] == 180 )
   {
      point[ 0 ].x = rect->right - 1;
      point[ 0 ].y = rect->bottom - 1;
      point[ 1 ].x = rect->left - 1;
      point[ 1 ].y = rect->bottom - 1;
      point[ 2 ].x = rect->right - 1;
      point[ 2 ].y = rect->top - 1;
      row = iHeight - rect->bottom - iScrollVert;
      col = iWidth - rect->right - iScrollHorz;
      width = rect->right - rect->left;
      height = rect->bottom - rect->top;
   }
   else if( oSelf->lAux[ 1 ] == 270 )
   {
      point[ 0 ].x = rect->left;
      point[ 0 ].y = rect->bottom;
      point[ 1 ].x = rect->left;
      point[ 1 ].y = rect->top;
      point[ 2 ].x = rect->right;
      point[ 2 ].y = rect->bottom;
      row = rect->left + iScrollHorz;
      col = iWidth - rect->bottom - iScrollVert;
      height = rect->right - rect->left;
      width = rect->bottom - rect->top;
   }
   else
   {
      point[ 0 ].x = rect->left;
      point[ 0 ].y = rect->top;
      point[ 1 ].x = rect->right;
      point[ 1 ].y = rect->top;
      point[ 2 ].x = rect->left;
      point[ 2 ].y = rect->bottom;
      col = rect->left + iScrollHorz;
      row = rect->top + iScrollVert;
      width = rect->right - rect->left;
      height = rect->bottom - rect->top;
   }

   PlgBlt( hdc, ( POINT * ) &point, hDCAux, col, row, width, height, NULL, 0, 0 );

   if( oSelf->lAux[ 1 ] == 90 || oSelf->lAux[ 1 ] == 270 )
   {
      iAux = iWidth;
      iWidth = iHeight;
      iHeight = iAux;
   }
   iWidth  -= iScrollHorz;
   iHeight -= iScrollVert;
   if( rect->right > iWidth )
   {
      iAux = rect->left;
      if( rect->left < iWidth )
      {
         rect->left = iWidth;
      }
      FillRect( hdc, rect, hBrush );
      rect->left = iAux;
   }
   if( rect->bottom > iHeight )
   {
      iAux = rect->top;
      if( rect->top < iHeight )
      {
         rect->top = iHeight;
      }
      FillRect( hdc, rect, hBrush );
      rect->top = iAux;
   }

   if( hBmp )
   {
      SelectObject( hDCAux, hBmpOld );
   }
   DeleteDC( hDCAux );
   DeleteObject( hBrush );
}

#define _ScrollSkip 20

BOOL PtInExcludeArea( PHB_ITEM pArea, int x, int y );

HB_FUNC_STATIC( TPICTURE_EVENTS )          /* METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TPicture */
{
   HWND hWnd      = HWNDparam( 1 );
   UINT message   = (UINT)   hb_parni( 2 );
   WPARAM wParam  = WPARAMparam( 3 );
   LPARAM lParam  = LPARAMparam( 4 );
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf   = _OOHG_GetControlInfo( pSelf );

   switch( message )
   {
      case WM_ERASEBKGND:
         {
            RECT rect;
            GetClientRect( hWnd, &rect );
            _OOHG_PictureControl_RePaint( pSelf, &rect, (HDC) wParam );
            hb_retni( 1 );
         }
         break;

      case WM_PAINT:
         {
            PAINTSTRUCT ps;
            HDC         hdc;
            RECT        rect;

            if( ! GetUpdateRect( hWnd, &rect, FALSE ) )
            {
               hb_retni( 0 );
            }
            else
            {
               hdc = BeginPaint( hWnd, &ps );
               if( hdc )
               {
                  _OOHG_PictureControl_RePaint( pSelf, &rect, hdc );
               }
               EndPaint( hWnd, &ps );
               hb_retni( 0 );                 /* TODO: Check if retval is OK or must be 1 */
            }
         }
         break;

      case WM_HSCROLL:
         {
            int iOldPos, iNewPos;
            SCROLLINFO ScrollInfo;
            RECT rect;
            HDC hdc;

            ScrollInfo.cbSize = sizeof( SCROLLINFO );
            ScrollInfo.fMask = SIF_PAGE | SIF_POS | SIF_RANGE | SIF_TRACKPOS;
            if( ! ( GetWindowLongPtr( hWnd, GWL_STYLE ) & WS_HSCROLL ) || ! GetScrollInfo( oSelf->hWnd, SB_HORZ, &ScrollInfo ) )
            {
               memset( &ScrollInfo, 0, sizeof( ScrollInfo ) );
               wParam = 0;
            }
            iOldPos = ScrollInfo.nPos;
            iNewPos = ScrollInfo.nPos;
            switch( LOWORD( wParam  ) )
            {
               case SB_LINERIGHT:
                  iNewPos += _ScrollSkip;
                  break;

               case SB_LINELEFT:
                  iNewPos -= _ScrollSkip;
                  break;

               case SB_PAGELEFT:
                  iNewPos -= ScrollInfo.nPage;
                  break;

               case SB_PAGERIGHT:
                  iNewPos += ScrollInfo.nPage;
                  break;

               case SB_LEFT:
                  iNewPos = ScrollInfo.nMin;
                  break;

               case SB_RIGHT:
                  iNewPos = ScrollInfo.nMax;
                  break;

               case SB_THUMBPOSITION:
                  iNewPos = HIWORD( wParam  );
                  break;

               case SB_THUMBTRACK:
                  iNewPos = HIWORD( wParam  );
                  break;

               default:
                  break;
            }
            iNewPos = ( iNewPos > ScrollInfo.nMax ) ? ScrollInfo.nMax : iNewPos;
            iNewPos = ( iNewPos < ScrollInfo.nMin ) ? ScrollInfo.nMin : iNewPos;
            if( iOldPos != iNewPos )
            {
               SetScrollPos( oSelf->hWnd, SB_HORZ, iNewPos, TRUE );
               GetClientRect( hWnd, &rect );
               hdc = GetDC( hWnd );
               _OOHG_PictureControl_RePaint( pSelf, &rect, hdc );
               DeleteDC( hdc );
               hb_ret();
            }
         }
         break;

      case WM_VSCROLL:
         {
            int iOldPos, iNewPos;
            SCROLLINFO ScrollInfo;
            RECT rect;
            HDC hdc;

            ScrollInfo.cbSize = sizeof( SCROLLINFO );
            ScrollInfo.fMask = SIF_PAGE | SIF_POS | SIF_RANGE | SIF_TRACKPOS;
            if( ! ( GetWindowLongPtr( hWnd, GWL_STYLE ) & WS_VSCROLL ) || ! GetScrollInfo( oSelf->hWnd, SB_VERT, &ScrollInfo ) )
            {
               memset( &ScrollInfo, 0, sizeof( ScrollInfo ) );
               wParam = 0;
            }
            iOldPos = ScrollInfo.nPos;
            iNewPos = ScrollInfo.nPos;
            switch( LOWORD( wParam  ) )
            {
               case SB_LINEDOWN:
                  iNewPos += _ScrollSkip;
                  break;

               case SB_LINEUP:
                  iNewPos -= _ScrollSkip;
                  break;

               case SB_PAGEUP:
                  iNewPos -= ScrollInfo.nPage;
                  break;

               case SB_PAGEDOWN:
                  iNewPos += ScrollInfo.nPage;
                  break;

               case SB_TOP:
                  iNewPos = ScrollInfo.nMin;
                  break;

               case SB_BOTTOM:
                  iNewPos = ScrollInfo.nMax;
                  break;

               case SB_THUMBPOSITION:
                  iNewPos = HIWORD( wParam  );
                  break;

               case SB_THUMBTRACK:
                  iNewPos = HIWORD( wParam  );
                  break;

               default:
                  break;
            }
            iNewPos = ( iNewPos > ScrollInfo.nMax ) ? ScrollInfo.nMax : iNewPos;
            iNewPos = ( iNewPos < ScrollInfo.nMin ) ? ScrollInfo.nMin : iNewPos;
            if( iOldPos != iNewPos )
            {
               SetScrollPos( oSelf->hWnd, SB_VERT, iNewPos, TRUE );
               GetClientRect( hWnd, &rect );
               hdc = GetDC( hWnd );
               _OOHG_PictureControl_RePaint( pSelf, &rect, hdc );
               DeleteDC( hdc );
               hb_ret();
            }
         }
         break;

      case WM_MOUSEWHEEL:
         {
            _OOHG_Send( pSelf, s_Events_VScroll );
            hb_vmPushLong( ( GET_WHEEL_DELTA_WPARAM( wParam  ) > 0 ) ? SB_LINEUP : SB_LINEDOWN );
            hb_vmSend( 1 );
            hb_ret();
         }
         break;

      case WM_LBUTTONUP:
         {
            SendMessage( GetParent( hWnd ), WM_COMMAND, MAKEWORD( STN_CLICKED, 0 ), (LPARAM) hWnd );
         }
         break;

      case WM_NCHITTEST:
         {
            POINT pt;
            PHB_ITEM pArea;
            BOOL bPtInExcludeArea;
            BOOL blCtrlCoords;

            _OOHG_Send( pSelf, s_lCtrlCoords );
            hb_vmSend( 0 );
            blCtrlCoords = hb_parl( -1 );
            _OOHG_Send( pSelf, s_aExcludeArea );
            hb_vmSend( 0 );
            pArea = hb_param( -1, HB_IT_ARRAY );
            pt.x = GET_X_LPARAM( lParam );   // screen coordinates
            pt.y = GET_Y_LPARAM( lParam );
            if( blCtrlCoords )
            {
               MapWindowPoints( HWND_DESKTOP, hWnd, &pt, 1 );   // control coordinates
            }
            else
            {
               MapWindowPoints( HWND_DESKTOP, GetParent( hWnd ), &pt, 1 );   // form coordinates
            }
            bPtInExcludeArea = PtInExcludeArea( pArea, pt.x, pt.y );   // form coordinates

            if( oSelf->lAux[ 0 ] && ! bPtInExcludeArea )
            {
               hb_retni( DefWindowProc( hWnd, message, wParam, lParam ) );
            }
            else if( oSelf->lAux[ 2 ] && ! bPtInExcludeArea )
            {
               hb_retni( HTCLIENT );
            }
            else
            {
               hb_retni( HTTRANSPARENT );
            }
         }
         break;

      default:
         {
            _OOHG_Send( pSelf, s_Super );
            hb_vmSend( 0 );
            _OOHG_Send( hb_param( -1, HB_IT_OBJECT ), s_Events );
            HWNDpush( hWnd );
            hb_vmPushLong( message );
            hb_vmPushNumInt( wParam  );
            hb_vmPushNumInt( lParam );
            hb_vmSend( 4 );
         }
         break;
   }
}

HB_FUNC_STATIC( TPICTURE_NDEGREE )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( HB_ISNUM( 1 ) )
   {
      oSelf->lAux[ 1 ] = hb_parnl( 1 ) % 360;
   }

   hb_retnl( oSelf->lAux[ 1 ] );
}

HB_FUNC_STATIC( TPICTURE_REDRAW )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   HWND hWnd;
   HDC hdc;
   RECT rect;

   hWnd = oSelf->hWnd;
   if( ValidHandler( hWnd ) )
   {
      GetClientRect( hWnd, &rect );
      hdc = GetDC( hWnd );
      _OOHG_PictureControl_RePaint( pSelf, &rect, hdc );
      DeleteDC( hdc );
   }

   hb_ret();
}

HB_FUNC( TPICTURE_SETNOTIFY )          /* FUNCTION TPicture_SetNotify( oSelf, lHit ) -> NIL */
{
   PHB_ITEM pSelf = hb_param( 1, HB_IT_ANY );
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   oSelf->lAux[ 0 ] = ( hb_parl( 2 ) || ( GetWindowLongPtr( oSelf->hWnd, GWL_STYLE ) & ( WS_HSCROLL | WS_VSCROLL ) ) );
}

HB_FUNC( TPICTURE_SETTOOLTIP )          /* FUNCTION TPicture_SetToolTip( oSelf, lShow ) -> NIL */
{
   PHB_ITEM pSelf = hb_param( 1, HB_IT_ANY );
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   oSelf->lAux[ 2 ] = hb_parl( 2 );
}

HB_FUNC( SCROLLS )          /* FUNCTION Scrolls( hWnd, nWidth, nHeight )-> lChanged */
{
   HWND hWnd;
   LONG_PTR lStyle, lOldStyle;
   int iWidth, iHeight, iClientWidth, iClientHeight;
   int iScrollWidth, iScrollHeight;
   int iRangeHorz, iRangeVert, iPosHorz, iPosVert, iPageHorz, iPageVert;
   BOOL bChanged = FALSE;
   int iRange, iPos;
   RECT rect;
   SCROLLINFO ScrollInfo;

   /* Can it be processed? */
   hWnd = HWNDparam( 1 );
   if( ! ValidHandler( hWnd ) )
   {
      hb_retl( FALSE );
      return;
   }

   iWidth  = hb_parni( 2 );
   iHeight = hb_parni( 3 );
   iScrollWidth  = GetSystemMetrics( SM_CXVSCROLL );
   iScrollHeight = GetSystemMetrics( SM_CXHSCROLL );

   lOldStyle = lStyle = GetWindowLongPtr( hWnd, GWL_STYLE );
   GetClientRect( hWnd, &rect );
   iClientWidth  = rect.right  - rect.left + ( ( lStyle & WS_VSCROLL ) ? iScrollWidth  : 0 );
   iClientHeight = rect.bottom - rect.top  + ( ( lStyle & WS_HSCROLL ) ? iScrollHeight : 0 );

   if( iWidth > iClientWidth )
   {
      iClientHeight -= iScrollHeight;
      bChanged = TRUE;
   }
   if( iHeight > iClientHeight )
   {
      iClientWidth  -= iScrollWidth;
   }
   if( iWidth > iClientWidth && ! bChanged )
   {
      iClientHeight -= iScrollHeight;
   }

   iRangeHorz = iRangeVert = iPosHorz = iPosVert = iPageHorz = iPageVert = 0;
   ScrollInfo.cbSize = sizeof( SCROLLINFO );
   ScrollInfo.fMask = SIF_PAGE | SIF_POS | SIF_RANGE | SIF_TRACKPOS;
   if( GetScrollInfo( hWnd, SB_HORZ, &ScrollInfo ) )
   {
      iPosHorz   = ScrollInfo.nPos;
      iRangeHorz = ScrollInfo.nMax;
      iPageHorz  = ScrollInfo.nPage;
   }
   ScrollInfo.cbSize = sizeof( SCROLLINFO );
   ScrollInfo.fMask = SIF_PAGE | SIF_POS | SIF_RANGE | SIF_TRACKPOS;
   if( GetScrollInfo( hWnd, SB_VERT, &ScrollInfo ) )
   {
      iPosVert   = ScrollInfo.nPos;
      iRangeVert = ScrollInfo.nMax;
      iPageVert  = ScrollInfo.nPage;
   }

   bChanged = FALSE;
   lStyle = lStyle & ( ~ ( WS_HSCROLL | WS_VSCROLL ) );

   iRange = iPos = 0;
   if( iWidth > iClientWidth )
   {
      iRange = iWidth - iClientWidth;
      iPos   = ( iRange > iPosHorz ) ? iPosHorz : iRange;
      lStyle = lStyle | WS_HSCROLL;
      iRange = iWidth - 1;
   }
   if( iRange != iRangeHorz || iPos != iPosHorz || iClientWidth != iPageHorz )
   {
      bChanged = TRUE;
   }
   iRangeHorz = iRange;
   iPosHorz   = iPos;

   iRange = iPos = 0;
   if( iHeight > iClientHeight )
   {
      iRange = iHeight - iClientHeight;
      iPos   = ( iRange > iPosVert ) ? iPosVert : iRange;
      lStyle = lStyle | WS_VSCROLL;
      iRange = iHeight - 1;
   }
   if( iRange != iRangeVert || iPos != iPosVert || iClientHeight != iPageVert )
   {
      bChanged = TRUE;
   }
   iRangeVert = iRange;
   iPosVert   = iPos;

   if( bChanged )
   {
      SetWindowLongPtr( hWnd, GWL_STYLE, lStyle );
      if( iRangeHorz || ( lOldStyle & WS_HSCROLL ) )
      {
         ScrollInfo.cbSize = sizeof( SCROLLINFO );
         memset( &ScrollInfo, 0, sizeof( SCROLLINFO ) );
         ScrollInfo.fMask = SIF_PAGE | SIF_POS | SIF_RANGE;
         ScrollInfo.nMin = 0;
         ScrollInfo.nMax = iRangeHorz;
         ScrollInfo.nPos = iPosHorz;
         ScrollInfo.nPage = iClientWidth;
         SetScrollInfo( hWnd, SB_HORZ, ( LPSCROLLINFO ) &ScrollInfo, 1 );
      }
      if( iRangeVert || ( lOldStyle & WS_VSCROLL ) )
      {
         ScrollInfo.cbSize = sizeof( SCROLLINFO );
         memset( &ScrollInfo, 0, sizeof( SCROLLINFO ) );
         ScrollInfo.fMask = SIF_PAGE | SIF_POS | SIF_RANGE;
         ScrollInfo.nMin = 0;
         ScrollInfo.nMax = iRangeVert;
         ScrollInfo.nPos = iPosVert;
         ScrollInfo.nPage = iClientHeight;
         SetScrollInfo( hWnd, SB_VERT, ( LPSCROLLINFO ) &ScrollInfo, 1 );
      }
      SetWindowPos( hWnd, 0, 0, 0, 0, 0, SWP_NOACTIVATE | SWP_NOSIZE | SWP_NOMOVE | SWP_NOZORDER | SWP_FRAMECHANGED | SWP_NOCOPYBITS | SWP_NOOWNERZORDER | SWP_NOSENDCHANGING );
   }

   hb_retl( bChanged );
}

#pragma ENDDUMP
