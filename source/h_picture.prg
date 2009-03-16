/*
 * $Id: h_picture.prg,v 1.5 2009-03-16 00:48:34 guerra000 Exp $
 */
/*
 * ooHG source code:
 * TPicture control source code
 *
 * Copyright 2009 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.oohg.org
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

#include "oohg.ch"
#include "hbclass.ch"
#include "i_windefs.ch"

CLASS TPicture FROM TControl
   DATA Type            INIT "PICTURE" READONLY
   DATA nWidth          INIT 100
   DATA nHeight         INIT 100
   DATA cPicture        INIT ""
   DATA Stretch         INIT .F.
   DATA AutoFit         INIT .F.
   DATA hImage          INIT nil
   DATA ImageSize       INIT .F.
   DATA nZoom           INIT 1
   DATA bOnClick        INIT nil

   METHOD Define
   METHOD RePaint
   METHOD Release
   METHOD SizePos

   METHOD Picture       SETGET
   METHOD Buffer        SETGET
   METHOD HBitMap       SETGET
   METHOD Zoom          SETGET
   METHOD OnClick       SETGET

   METHOD Events

   EMPTY( _OOHG_AllVars )
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, FileName, w, h, cBuffer, hBitMap, ;
               stretch, autofit, imagesize, BORDER, CLIENTEDGE, BackColor, ;
               ProcedureName, ToolTip, HelpId, lRtl, invisible ) CLASS TPicture
*-----------------------------------------------------------------------------*
Local ControlHandle, nStyle, nStyleEx

   ASSIGN ::nCol        VALUE x TYPE "N"
   ASSIGN ::nRow        VALUE y TYPE "N"
   ASSIGN ::nWidth      VALUE w TYPE "N"
   ASSIGN ::nHeight     VALUE h TYPE "N"

   ASSIGN ::Stretch    VALUE stretch   TYPE "L"
   ASSIGN ::AutoFit    VALUE autofit   TYPE "L"
   ASSIGN ::ImageSize  VALUE imagesize TYPE "L"

   IF BackColor == NIL
      BackColor := GetSysColor( COLOR_3DFACE )
   ENDIF

   ::SetForm( ControlName, ParentForm,,,, BackColor, , lRtl )

   nStyle := ::InitStyle( ,, Invisible, .T.,  ) + ;
             if( ValType( BORDER ) == "L"    .AND. BORDER,     WS_BORDER,   0 )

   nStyleEx := if( ValType( CLIENTEDGE ) == "L"   .AND. CLIENTEDGE,   WS_EX_CLIENTEDGE,  0 )

   Controlhandle := InitPictureControl( ::ContainerhWnd, ::ContainerCol, ::ContainerRow, ::nWidth, ::nHeight, nStyle, nStyleEx, ::lRtl )

   ::Register( ControlHandle, ControlName, HelpId,, ToolTip )

   ::Picture := FileName
   If ! ValidHandler( ::hImage )
      ::Buffer := cBuffer
      If ! ValidHandler( ::hImage )
         ::HBitMap := hBitMap
      EndIf
   EndIf

   ASSIGN ::OnClick     VALUE ProcedureName TYPE "B"

Return Self

*-----------------------------------------------------------------------------*
METHOD Picture( cPicture ) CLASS TPicture
*-----------------------------------------------------------------------------*
LOCAL nAttrib
   IF VALTYPE( cPicture ) $ "CM"
      DeleteObject( ::hImage )
      ::cPicture := cPicture
      nAttrib := LR_CREATEDIBSECTION
      // IF ::Transparent
      //    nAttrib += LR_LOADMAP3DCOLORS + LR_LOADTRANSPARENT
      // ENDIF
      ::hImage := _OOHG_BitmapFromFile( Self, cPicture, nAttrib, .F. )
      IF ::ImageSize
         ::nWidth  := _BitMapWidth( ::hImage )
         ::nHeight := _BitMapHeight( ::hImage )
      ENDIF
      ::RePaint()
   ENDIF
Return ::cPicture

*-----------------------------------------------------------------------------*
METHOD HBitMap( hBitMap ) CLASS TPicture
*-----------------------------------------------------------------------------*
   If ValType( hBitMap ) $ "NP"
      DeleteObject( ::hImage )
      ::hImage := hBitMap
      IF ::ImageSize
         ::nWidth  := _BitMapWidth( ::hImage )
         ::nHeight := _BitMapHeight( ::hImage )
      ENDIF
      ::RePaint()
   EndIf
Return ::hImage

*-----------------------------------------------------------------------------*
METHOD Buffer( cBuffer ) CLASS TPicture
*-----------------------------------------------------------------------------*
   If VALTYPE( cBuffer ) $ "CM"
      DeleteObject( ::hImage )
      ::hImage := _OOHG_BitmapFromBuffer( Self, cBuffer, .F. )
      IF ::ImageSize
         ::nWidth  := _BitMapWidth( ::hImage )
         ::nHeight := _BitMapHeight( ::hImage )
      ENDIF
      ::RePaint()
   EndIf
Return nil

*-----------------------------------------------------------------------------*
METHOD Zoom( nZoom ) CLASS TPicture
*-----------------------------------------------------------------------------*
   If HB_IsNumeric( nZoom )
      ::nZoom := nZoom
      ::RePaint()
   EndIf
Return ::nZoom

*-----------------------------------------------------------------------------*
METHOD OnClick( bOnClick ) CLASS TPicture
*-----------------------------------------------------------------------------*
   If PCOUNT() > 0
      ::bOnClick := bOnClick
      TPicture_SetNotify( Self, HB_IsBlock( bOnClick ) )
   EndIf
Return ::bOnClick

*-----------------------------------------------------------------------------*
METHOD RePaint() CLASS TPicture
*-----------------------------------------------------------------------------*
   IF ValidHandler( ::AuxHandle )
      DeleteObject( ::AuxHandle )
   ENDIF
   ::Super:SizePos( ,, ::nWidth, ::nHeight )
   IF ::Stretch .OR. ::AutoFit
      ::AuxHandle := _OOHG_SetBitmap( Self, ::hImage, 0, ::Stretch, ::AutoFit )
   ELSE
      ::AuxHandle := _OOHG_ScaleImage( Self, ::hImage, ( _BitmapWidth( ::hImage ) * ::nZoom ) + 0.999, ( _BitmapHeight( ::hImage ) * ::nZoom ) + 0.999 )
   ENDIF
   IF SCROLLS( ::hWnd, _BitmapWidth( ::AuxHandle ), _BitmapHeight( ::AuxHandle ) )
*      ::ReDraw()
   ENDIF
RETURN Self

*-----------------------------------------------------------------------------*
METHOD SizePos( Row, Col, Width, Height ) CLASS TPicture
*-----------------------------------------------------------------------------*
LOCAL uRet
   uRet := ::Super:SizePos( Row, Col, Width, Height )
   ::RePaint()
RETURN uRet

*-----------------------------------------------------------------------------*
METHOD Release() CLASS TPicture
*-----------------------------------------------------------------------------*
   IF ValidHandler( ::hImage )
      DeleteObject( ::hImage )
   ENDIF
RETURN ::Super:Release()

#pragma BEGINDUMP

#define s_Super s_TControl

#ifndef _WIN32_WINNT
   #define _WIN32_WINNT 0x0500
#endif
#if ( _WIN32_WINNT < 0x0500 )
   #undef _WIN32_WINNT
   #define _WIN32_WINNT 0x0500
#endif

#include "hbapi.h"
#include "hbapiitm.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windows.h>
#include <commctrl.h>
#include "oohg.h"

static WNDPROC lpfnOldWndProc = 0;
static BOOL bRegistered = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

static LRESULT CALLBACK _OOHG_PictureControl_WndProc( HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam )
{
   return DefWindowProc( hWnd, message, wParam, lParam );
}

void _OOHG_PictureControl_Register( void )
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
      char cBuffError[ 1000 ];
      sprintf( cBuffError, "_OOHG_PICTURECONTROL Registration Failed! Error %i", ( int ) GetLastError() );
      MessageBox( 0, cBuffError, "Error!", MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
      ExitProcess( 0 );
   }

   bRegistered = 1;
}

HB_FUNC( INITPICTURECONTROL )
{
   HWND hwnd;
   HWND hbutton;

   int Style, ExStyle;

   if( ! bRegistered )
   {
      _OOHG_PictureControl_Register();
   }

   hwnd = HWNDparam( 1 );
   Style = hb_parni( 6 ) | WS_CHILD;
   ExStyle = hb_parni( 7 ) | _OOHG_RTL_Status( hb_parl( 8 ) );

   hbutton = CreateWindowEx( ExStyle, "_OOHG_PICTURECONTROL", "", Style,
             hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ),
             hwnd, NULL, GetModuleHandle( NULL ), NULL );

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( hbutton, GWL_WNDPROC, ( LONG ) SubClassFunc );

   HWNDret( hbutton );
}

void _OOHG_PictureControl_RePaint( HWND hWnd, PHB_ITEM pSelf, RECT *rect, HDC hdc )
{
   BITMAP bm;
   HBITMAP hBmp;
   SCROLLINFO ScrollInfo;
   int iWidth = 0, iHeight = 0, iAux;
   int iScrollHorz = 0, iScrollVert = 0;
   HDC hDCAux;
   HBRUSH hBrush;
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( ! hWnd )
   {
      return;
   }

   // NOTE: It affects RETURN value on stack!!!!!
   _OOHG_Send( pSelf, s_AuxHandle );
   hb_vmSend( 0 );
   hBmp = ( HBITMAP ) HWNDparam( -1 );
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
      hBrush = CreateSolidBrush( GetSysColor( COLOR_BTNFACE ) );
   }
   else
   {
      hBrush = CreateSolidBrush( oSelf->lBackColor );
   }
   hDCAux = CreateCompatibleDC( hdc );
   if( hBmp )
   {
      SelectObject( hDCAux, hBmp );
   }

   SetStretchBltMode( hdc, COLORONCOLOR );
   BitBlt( hdc, rect->left, rect->top, rect->right - rect->left, rect->bottom - rect->top, hDCAux, rect->left + iScrollHorz, rect->top + iScrollVert, SRCCOPY );
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

   DeleteDC( hDCAux );
   DeleteObject( hBrush );
}

#define _ScrollSkip 20

HB_FUNC_STATIC( TPICTURE_EVENTS )
{
   HWND hWnd      = ( HWND )   hb_parnl( 1 );
   UINT message   = ( UINT )   hb_parni( 2 );
   WPARAM wParam  = ( WPARAM ) hb_parni( 3 );
   LPARAM lParam  = ( LPARAM ) hb_parnl( 4 );
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   switch( message )
   {
      case WM_ERASEBKGND:
         {
            RECT rect;
            GetClientRect( hWnd, &rect );
            _OOHG_PictureControl_RePaint( hWnd, pSelf, &rect, ( HDC ) wParam );
            hb_retni( 1 );
         }
         break;

      case WM_PAINT:
         {
            PAINTSTRUCT ps;
            HDC         hdc;
            RECT        rect;

            if ( ! GetUpdateRect( hWnd, &rect, FALSE ) )
            {
               hb_retni( 0 );
            }
            else
            {
               hdc = BeginPaint( hWnd, &ps );
               _OOHG_PictureControl_RePaint( hWnd, pSelf, &rect, hdc );
               EndPaint( hWnd, &ps );
               hb_retni( 1 );
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
            if( ! ( GetWindowLong( hWnd, GWL_STYLE ) & WS_HSCROLL ) || ! GetScrollInfo( oSelf->hWnd, SB_HORZ, &ScrollInfo ) )
            {
               memset( &ScrollInfo, 0, sizeof( ScrollInfo ) );
               wParam = 0;
            }
            iOldPos = ScrollInfo.nPos;
            iNewPos = ScrollInfo.nPos;
            switch( LOWORD( wParam ) )
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
                  iNewPos = HIWORD( wParam );
                  break;

               case SB_THUMBTRACK:
                  iNewPos = HIWORD( wParam );
                  break;

            }
            iNewPos = ( iNewPos > ScrollInfo.nMax ) ? ScrollInfo.nMax : iNewPos;
            iNewPos = ( iNewPos < ScrollInfo.nMin ) ? ScrollInfo.nMin : iNewPos;
            if( iOldPos != iNewPos )
            {
               SetScrollPos( oSelf->hWnd, SB_HORZ, iNewPos, 1 );
               GetClientRect( hWnd, &rect );
               hdc = GetDC( hWnd );
               _OOHG_PictureControl_RePaint( hWnd, pSelf, &rect, hdc );
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
            if( ! ( GetWindowLong( hWnd, GWL_STYLE ) & WS_VSCROLL ) || ! GetScrollInfo( oSelf->hWnd, SB_VERT, &ScrollInfo ) )
            {
               memset( &ScrollInfo, 0, sizeof( ScrollInfo ) );
               wParam = 0;
            }
            iOldPos = ScrollInfo.nPos;
            iNewPos = ScrollInfo.nPos;
            switch( LOWORD( wParam ) )
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
                  iNewPos = HIWORD( wParam );
                  break;

               case SB_THUMBTRACK:
                  iNewPos = HIWORD( wParam );
                  break;

            }
            iNewPos = ( iNewPos > ScrollInfo.nMax ) ? ScrollInfo.nMax : iNewPos;
            iNewPos = ( iNewPos < ScrollInfo.nMin ) ? ScrollInfo.nMin : iNewPos;
            if( iOldPos != iNewPos )
            {
               SetScrollPos( oSelf->hWnd, SB_VERT, iNewPos, 1 );
               GetClientRect( hWnd, &rect );
               hdc = GetDC( hWnd );
               _OOHG_PictureControl_RePaint( hWnd, pSelf, &rect, hdc );
               DeleteDC( hdc );
               hb_ret();
            }
         }
         break;

      case WM_MOUSEWHEEL:
         _OOHG_Send( pSelf, s_Events_VScroll );
         hb_vmPushLong( ( HIWORD( wParam ) == WHEEL_DELTA ) ? SB_LINEUP : SB_LINEDOWN );
         hb_vmSend( 1 );
         hb_ret();
         break;

      case WM_LBUTTONUP:
         SendMessage( GetParent( hWnd ), WM_COMMAND, MAKEWORD( STN_CLICKED, 0 ), ( LPARAM ) hWnd );
         break;

      case WM_NCHITTEST:
         if( oSelf->lAux[ 0 ] )
         {
            hb_retni( DefWindowProc( hWnd, message, wParam, lParam ) );
         }
         else
         {
            hb_retni( -1 );
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

HB_FUNC( TPICTURE_SETNOTIFY )   // ( oSelf, lHit )
{
   PHB_ITEM pSelf = hb_param( 1, HB_IT_ANY );
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   oSelf->lAux[ 0 ] = hb_parnl( 2 );
   hb_ret();
}

HB_FUNC( SCROLLS )   // ( hWnd, nWidth, nHeight )
{
   HWND hWnd;
   long lStyle, lOldStyle;
   int iWidth, iHeight, iClientWidth, iClientHeight;
   int iScrollWidth, iScrollHeight;
   int iRangeHorz, iRangeVert, iPosHorz, iPosVert, iPageHorz, iPageVert;
   int bChanged, iRange, iPos, iPage;
   RECT rect;
   SCROLLINFO ScrollInfo;

   // Can it be processed?
   hWnd = HWNDparam( 1 );
   if( ! ValidHandler( hWnd ) )
   {
      hb_retl( 0 );
      return;
   }

   iWidth  = hb_parni( 2 );
   iHeight = hb_parni( 3 );
   iScrollWidth  = GetSystemMetrics( SM_CXVSCROLL );
   iScrollHeight = GetSystemMetrics( SM_CXHSCROLL );

   lOldStyle = lStyle = GetWindowLong( hWnd, GWL_STYLE );
   GetClientRect( hWnd, &rect );
   iClientWidth  = rect.right  - rect.left + ( ( lStyle & WS_VSCROLL ) ? iScrollWidth  : 0 );
   iClientHeight = rect.bottom - rect.top  + ( ( lStyle & WS_HSCROLL ) ? iScrollHeight : 0 );

   bChanged = 0;
   if( iWidth > iClientWidth )
   {
      iClientHeight -= iScrollHeight;
      bChanged = 1;
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

   bChanged = 0;
   lStyle = lStyle & ( ~ ( WS_HSCROLL | WS_VSCROLL ) );

   iRange = iPos = iPage = 0;
   if( iWidth > iClientWidth )
   {
      iRange = iWidth - iClientWidth;
      iPos   = ( iRange > iPosHorz ) ? iPosHorz : iRange;
      lStyle = lStyle | WS_HSCROLL;
      iRange = iWidth - 1;
   }
   if( iRange != iRangeHorz || iPos != iPosHorz || iClientWidth != iPageHorz )
   {
      bChanged = 1;
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
      bChanged = 1;
   }
   iRangeVert = iRange;
   iPosVert   = iPos;

   if( bChanged )
   {
      SetWindowLong( hWnd, GWL_STYLE, lStyle );
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
