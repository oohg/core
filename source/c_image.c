/*
 * $Id: c_image.c $
 */
/*
 * ooHG source code:
 * C image functions
 *
 * Copyright 2005-2018 Vicente Guerra <vicente@guerra.com.mx>
 * https://oohg.github.io/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2018, https://harbour.github.io/
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


#ifndef CINTERFACE
   #define CINTERFACE
#endif
#ifndef WINVER
   #define WINVER 0x0500
#endif
#if ( WINVER < 0x0500 )
   #undef WINVER
   #define WINVER 0x0500
#endif
#define _WIN32_IE      0x0500
#define _WIN32_WINNT   0x0400
#include <shlobj.h>

#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "winreg.h"
#include "tchar.h"
#include <winuser.h>
#include <wingdi.h>
#include "olectl.h"
#include "oohg.h"

int _OOHG_StretchBltMode = COLORONCOLOR;

HB_FUNC( _OOHG_STRETCHBLTMODE )
{
   int OldStretchBltMode;
   OldStretchBltMode = _OOHG_StretchBltMode;
   if( HB_ISNUM( 1 ) )
   {
      _OOHG_StretchBltMode = hb_parni( 1 );
   }
   hb_retni( OldStretchBltMode );
}

HANDLE _OOHG_OleLoadPicture( HGLOBAL hGlobal, HWND hWnd, LONG lBackColor, LONG lWidth2, LONG lHeight2, BOOL bIgnoreBkClr )
{
   HANDLE hImage = 0;
   IStream * iStream;
   IPicture * iPicture;
   IPicture ** iPictureRef = &iPicture;
   LONG lWidth, lHeight;
   HDC hdc1, hdc2;
   RECT rect;
   HBRUSH hBrush;

   if( _OOHG_UseGDIP() )
   {
      return _OOHG_GDIPLoadPicture( hGlobal, hWnd, lBackColor, lWidth2, lHeight2, bIgnoreBkClr );
   }

   CreateStreamOnHGlobal( hGlobal, FALSE, &iStream );
   OleLoadPicture( iStream, 0, TRUE, &IID_IPicture, ( LPVOID * ) iPictureRef );
   iStream->lpVtbl->Release( iStream );
   if( iPicture )
   {
      iPicture->lpVtbl->get_Width( iPicture, &lWidth );
      iPicture->lpVtbl->get_Height( iPicture, &lHeight );

      if( lWidth2 && lHeight2 )
      {
         // GetClientRect( hWnd, &rect );
         // lWidth2 = rect.right;
         // lHeight2 = rect.bottom;
      }
      else
      {
         // Takes "real" image size
         float fAux;

         iPicture->lpVtbl->get_CurDC( iPicture, &hdc1 );
         hdc1 = CreateCompatibleDC( hdc1 );
         fAux = ( ( lWidth * GetDeviceCaps( hdc1, LOGPIXELSX ) ) / 2540 ) + ( float ) 0.9999;
         lWidth2 = ( LONG ) fAux;
         fAux = ( ( lHeight * GetDeviceCaps( hdc1, LOGPIXELSY ) ) / 2540 ) + ( float ) 0.9999;
         lHeight2 = ( LONG ) fAux;
         DeleteDC( hdc1 );
      }

      SetRect( &rect, 0, 0, lWidth2, lHeight2 );

      hdc1 = GetDC( hWnd );
      hdc2 = CreateCompatibleDC( hdc1 );
      hImage = CreateCompatibleBitmap( hdc1, lWidth2, lHeight2 );
      SelectObject( hdc2, hImage );

      if( ! bIgnoreBkClr )
      {
         if( lBackColor == -1 )
         {
            hBrush = CreateSolidBrush( GetSysColor( COLOR_BTNFACE ) );
         }
         else
         {
            hBrush = CreateSolidBrush( lBackColor );
         }
         FillRect( hdc2, &rect, hBrush );
         DeleteObject( hBrush );
      }

      iPicture->lpVtbl->Render( iPicture, hdc2, 0, 0, lWidth2, lHeight2, 0, lHeight, lWidth, -lHeight, NULL );
      iPicture->lpVtbl->Release( iPicture );

      DeleteDC( hdc1 );
      DeleteDC( hdc2 );
   }

   return hImage;
}

HBITMAP _OOHG_ScaleImage( HWND hWnd, HBITMAP hImage, LONG iWidth, LONG iHeight, BOOL scalestrech, LONG BackColor, BOOL bIgnoreBkColor, INT iHrzMrgn, INT iVrtMrgn )
{
   RECT fromRECT, toRECT;
   HBITMAP hOldTo, hOldFrom, hpic = 0;
   BITMAP bm;
   LONG lWidth, lHeight;
   HDC imgDC, fromDC, toDC;
   HBRUSH hBrush;

   if( hImage )
   {
      imgDC = GetDC( hWnd );
      fromDC = CreateCompatibleDC( imgDC );
      toDC = CreateCompatibleDC( imgDC );

      if( BackColor == -1 )
      {
         hBrush = CreateSolidBrush( GetSysColor( COLOR_BTNFACE ) );
      }
      else
      {
         hBrush = CreateSolidBrush( (COLORREF) BackColor );
      }

      // FROM parameters
      GetObject( hImage, sizeof( BITMAP ), &bm );
      lWidth  = bm.bmWidth;
      lHeight = bm.bmHeight;
      SetRect( &fromRECT, 0, 0, lWidth, lHeight );
      if( ! bIgnoreBkColor )
      {
         FillRect( fromDC, &fromRECT, hBrush );
      }
      hOldFrom = SelectObject( fromDC, hImage );

      // TO parameters
      if( hWnd && ( iWidth == 0 || iHeight == 0 ) )
      {
         GetClientRect( hWnd, &toRECT );
         iWidth  = toRECT.right - toRECT.left - iHrzMrgn;
         iHeight = toRECT.bottom - toRECT.top - iVrtMrgn;
         if( scalestrech )
         {
            if( (int) ( lWidth * iHeight / lHeight ) <= iWidth )
            {
               iWidth  = ( int ) ( lWidth  * iHeight / lHeight );
            }
            else
            {
               iHeight = ( int ) ( lHeight * iWidth  / lWidth );
            }
         }
      }
      else
      {
         iWidth  -= iHrzMrgn;
         iHeight -= iVrtMrgn;
      }
      SetRect( &toRECT, 0, 0, iWidth, iHeight );
      hpic = CreateCompatibleBitmap( imgDC, iWidth, iHeight );
      if( ! bIgnoreBkColor )
      {
         FillRect( toDC, &toRECT, hBrush );
      }
      hOldTo = SelectObject( toDC, hpic );

      SetStretchBltMode( toDC, _OOHG_StretchBltMode );
      if( _OOHG_StretchBltMode == HALFTONE )
      {
         SetBrushOrgEx( toDC, 0, 0, NULL );
      }
      StretchBlt( toDC, 0, 0, iWidth, iHeight, fromDC, 0, 0, lWidth, lHeight, SRCCOPY );

      DeleteDC( imgDC );
      SelectObject( fromDC, hOldFrom );
      DeleteDC( fromDC);
      SelectObject( toDC, hOldTo );
      DeleteDC( toDC );
      DeleteObject( hBrush );
   }

   return hpic;
}

HBITMAP _OOHG_RotateImage( HWND hWnd, HBITMAP hImage, LONG BackColor, int iDegree )
{
   RECT rect;
   POINT point[ 3 ];
   HBITMAP hpic = 0;
   BITMAP bm;
   int iWidth, iHeight;
   HDC imgDC, fromDC, toDC;
   HBRUSH hBrush;

   if( hWnd && hImage )
   {
      imgDC = GetDC( hWnd );
      fromDC = CreateCompatibleDC( imgDC );
      toDC = CreateCompatibleDC( imgDC );

      if( BackColor == -1 )
      {
         hBrush = CreateSolidBrush( GetSysColor( COLOR_BTNFACE ) );
      }
      else
      {
         hBrush = CreateSolidBrush( BackColor );
      }

      // FROM parameters
      GetObject( hImage, sizeof( BITMAP ), &bm );
      iWidth  = bm.bmWidth;
      iHeight = bm.bmHeight;
      SetRect( &rect, 0, 0, iWidth, iHeight );
      FillRect( fromDC, &rect, hBrush );
      SelectObject( fromDC, hImage );

      // TO parameters
      iDegree = iDegree % 360;
      if( iDegree == 90 )
      {
         point[ 0 ].x = iHeight;
         point[ 0 ].y = 0;
         point[ 1 ].x = iHeight;
         point[ 1 ].y = iWidth;
         point[ 2 ].x = 0;
         point[ 2 ].y = 0;
         SetRect( &rect, 0, 0, iHeight, iWidth );
      }
      else if( iDegree == 180 )
      {
         point[ 0 ].x = iWidth - 1;
         point[ 0 ].y = iHeight - 1;
         point[ 1 ].x = -1;
         point[ 1 ].y = iHeight - 1;
         point[ 2 ].x = iWidth - 1;
         point[ 2 ].y = -1;
         SetRect( &rect, 0, 0, iWidth, iHeight );
      }
      else if( iDegree == 270 )
      {
         point[ 0 ].x = 0;
         point[ 0 ].y = iWidth;
         point[ 1 ].x = 0;
         point[ 1 ].y = 0;
         point[ 2 ].x = iHeight;
         point[ 2 ].y = iWidth;
         SetRect( &rect, 0, 0, iHeight, iWidth );
      }
      else
      {
         point[ 0 ].x = 0;
         point[ 0 ].y = 0;
         point[ 1 ].x = iWidth;
         point[ 1 ].y = 0;
         point[ 2 ].x = 0;
         point[ 2 ].y = iHeight;
         SetRect( &rect, 0, 0, iWidth, iHeight );
      }
      hpic = CreateCompatibleBitmap( imgDC, rect.right, rect.bottom );
      FillRect( toDC, &rect, hBrush );
      SelectObject( toDC, hpic );
      // coordenadas!! angulo!!

      SetStretchBltMode( toDC, _OOHG_StretchBltMode );
      if( _OOHG_StretchBltMode == HALFTONE )
      {
         SetBrushOrgEx( toDC, 0, 0, NULL );
      }
      PlgBlt( toDC, ( POINT * ) &point, fromDC, 0, 0, iWidth, iHeight, NULL, 0, 0 );

      DeleteDC( imgDC );
      DeleteDC( fromDC);
      DeleteDC( toDC );
      DeleteObject( hBrush );
   }

   return hpic;
}

HANDLE _OOHG_LoadImage( char *cImage, int iAttributes, int nWidth, int nHeight, HWND hWnd, LONG lBackColor, BOOL bIgnoreBkClr )
{
   HANDLE hImage;

   // Validate cImage parameter
   if( ! cImage || ! *cImage )
   {
      return NULL;
   }

   // Background color, for MENUs use COLOR_MENU (see h_menu.prg)
   if( lBackColor == -1 )
   {
      lBackColor = GetSysColor( COLOR_BTNFACE );
   }

   // Try to load BITMAP from EXE
   hImage = LoadImage( GetModuleHandle( NULL ), cImage, IMAGE_BITMAP, nWidth, nHeight, iAttributes );
   if( ! hImage )
   {
      // Try to load BITMAP from FILE
      hImage = LoadImage( NULL, cImage, IMAGE_BITMAP, nWidth, nHeight, iAttributes | LR_LOADFROMFILE );
   }
   if( ! hImage )
   {
      if( bIgnoreBkClr )
      {
         // Try to load ICON from EXE
         hImage = LoadImage( GetModuleHandle( NULL ), cImage, IMAGE_ICON, nWidth, nHeight, iAttributes );
         if( ! hImage )
         {
            // Try to load ICON from FILE
            hImage = LoadImage( 0, cImage, IMAGE_ICON, nWidth, nHeight, iAttributes | LR_LOADFROMFILE );
         }
      }
      else
      {
         HICON hIcon;

         // Try to load ICON from EXE
         hIcon = LoadImage( GetModuleHandle( NULL ), cImage, IMAGE_ICON, nWidth, nHeight, iAttributes );
         if( ! hIcon )
         {
            // Try to load ICON from FILE
            hIcon = LoadImage( 0, cImage, IMAGE_ICON, nWidth, nHeight, iAttributes | LR_LOADFROMFILE );
         }
         if( hIcon )
         {
            HDC imgDC, toDC;
            HBRUSH hBrush;
            ICONINFO IconInfo;
            BITMAP bm ;
            HBITMAP hOldBmp;
            int iWidth, iHeight;

            GetIconInfo( hIcon, &IconInfo );

            if( IconInfo.hbmColor )
            {
               // color ICON
               GetObject( IconInfo.hbmColor, sizeof( BITMAP ), &bm );
               iWidth  = bm.bmWidth;
               iHeight = bm.bmHeight;

               imgDC = GetDC( hWnd );
               toDC = CreateCompatibleDC( imgDC );

               hBrush = CreateSolidBrush( lBackColor );

               hImage = CreateCompatibleBitmap( imgDC, iWidth, iHeight );
               hOldBmp = SelectObject( toDC, hImage );

               DrawIconEx( toDC, 0, 0, hIcon, iWidth, iHeight, 0, hBrush, DI_NORMAL );

               DeleteDC( imgDC );
               hImage = SelectObject( toDC, hOldBmp );
               DeleteDC( toDC );
               DeleteObject( hBrush );
               DeleteObject( hIcon );
            }
            else
            {
               // black and white ICON
               if (IconInfo.hbmMask)
               {
                  GetObject( IconInfo.hbmMask, sizeof( BITMAP ), &bm );
                  iWidth  = bm.bmWidth;
                  iHeight = bm.bmHeight / 2;

                  imgDC = GetDC( hWnd );
                  toDC = CreateCompatibleDC( imgDC );

                  hBrush = CreateSolidBrush( lBackColor );

                  hImage = CreateBitmap( iWidth, iHeight, 1, 1, NULL );
                  hOldBmp = SelectObject( toDC, hImage );
                  DrawIconEx( toDC, 0, 0, hIcon, iWidth, iHeight, 0, hBrush, DI_IMAGE );

                  DeleteDC( imgDC );
                  hImage = SelectObject( toDC, hOldBmp );
                  DeleteDC( toDC );
                  DeleteObject( hBrush );
                  DeleteObject( hIcon );
               }
               else
               {
                  DeleteObject( hIcon );
                  return NULL;
               }
            }
         }
      }
   }

   // Try to create from EXE, using OleLoadPicture
   if( ! hImage )
   {
      HRSRC hSource;
      HGLOBAL hGlobal, hGlobalres;
      LPVOID lpVoid;
      DWORD nSize;

      hSource = FindResource( GetModuleHandle( NULL ), cImage, "BMP" );
      if( ! hSource )
      {
         hSource = FindResource( GetModuleHandle( NULL ), cImage, "BITMAP" );
      }
      if( ! hSource )
      {
         hSource = FindResource( GetModuleHandle( NULL ), cImage, "GIF" );
      }
      if( ! hSource )
      {
         hSource = FindResource( GetModuleHandle( NULL ), cImage, "JPG" );
      }
      if( ! hSource )
      {
         hSource = FindResource( GetModuleHandle( NULL ), cImage, "JPEG" );
      }
      if( ! hSource )
      {
         hSource = FindResource( GetModuleHandle( NULL ), cImage, "ICO" );
      }
      if( ! hSource )
      {
         hSource = FindResource( GetModuleHandle( NULL ), cImage, "ICON" );
      }
      if( ! hSource )
      {
         hSource = FindResource( GetModuleHandle( NULL ), cImage, "PNG" );
      }
      if( ! hSource )
      {
         hSource = FindResource( GetModuleHandle( NULL ), cImage, "TIFF" );
      }
      if( hSource )
      {
         hGlobalres = LoadResource( GetModuleHandle( NULL ), hSource );
         if( hGlobalres )
         {
            lpVoid = LockResource( hGlobalres );
            if( lpVoid )
            {
               nSize = SizeofResource( GetModuleHandle( NULL ), hSource );
               hGlobal = GlobalAlloc( GPTR, nSize );
               if( hGlobal )
               {
                  memcpy( hGlobal, lpVoid, nSize );
                  hImage = _OOHG_OleLoadPicture( hGlobal, hWnd, lBackColor, nWidth, nHeight, bIgnoreBkClr );
                  GlobalFree( hGlobal );
               }
            }
            FreeResource( hGlobalres );
         }
      }
   }

   // Try to create from FILE, using OleLoadPicture
   if( ! hImage )
   {
      HANDLE hFile;
      DWORD nSize, nReadByte;
      HGLOBAL hGlobal;

      hFile = CreateFile( cImage, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL );
      if( hFile != INVALID_HANDLE_VALUE )
      {
         nSize = GetFileSize( hFile, NULL );
         hGlobal = GlobalAlloc( GPTR, nSize );
         if( hGlobal )
         {
            ReadFile( hFile, hGlobal, nSize, &nReadByte, NULL );
            hImage = _OOHG_OleLoadPicture( hGlobal, hWnd, lBackColor, nWidth, nHeight, bIgnoreBkClr );
            GlobalFree( hGlobal );
         }
         CloseHandle( hFile );
      }
   }

   return hImage;
}

HB_FUNC( _OOHG_BITMAPFROMFILE )   // ( oSelf, cFile, iAttributes, lAutoSize, lIgnoreBkColor )
{
   POCTRL oSelf = _OOHG_GetControlInfo( hb_param( 1, HB_IT_OBJECT ) );
   HBITMAP hBitmap, hBitmap2;
   int iAttributes;
   LONG lWidth, lHeight;

   iAttributes = hb_parni( 3 );
   if( hb_parl( 4 ) )
   {
      RECT rect;
      GetClientRect( oSelf->hWnd, &rect );
      lWidth = rect.right;
      lHeight = rect.bottom;
   }
   else
   {
      lWidth = lHeight = 0;
   }
   hBitmap = (HBITMAP) _OOHG_LoadImage( ( char * ) hb_parc( 2 ), iAttributes, lWidth, lHeight, oSelf->hWnd, oSelf->lBackColor, hb_parl( 5 ) );
   if( hb_parl( 4 ) )
   {
      hBitmap2 = _OOHG_ScaleImage( oSelf->hWnd, hBitmap, 0, 0, FALSE, oSelf->lBackColor, hb_parl( 5 ), 0, 0 );
      DeleteObject( hBitmap );
      HWNDret( hBitmap2 );
   }
   else
   {
      HWNDret( hBitmap );
   }
}

HB_FUNC( _OOHG_SIZEOFBITMAPFROMFILE )   // ( cFile )
{
   HBITMAP hBitmap;
   BITMAP bm;

   hBitmap = (HBITMAP) _OOHG_LoadImage( ( char * ) hb_parc( 1 ), LR_CREATEDIBSECTION, 0, 0, NULL, 0, TRUE );

   memset( &bm, 0, sizeof( bm ) );

   if( hBitmap )
   {
      GetObject( hBitmap, sizeof( bm ), &bm );
      DeleteObject( hBitmap );
   }

   hb_reta( 3 );
   HB_STORNI( bm.bmWidth, -1, 1 );
   HB_STORNI( bm.bmHeight, -1, 2 );
   HB_STORNI( bm.bmBitsPixel, -1, 3 );
}

HB_FUNC( _OOHG_SIZEOFHBITMAP )   // ( hBitmap )
{
   HBITMAP hBitmap = ( HBITMAP ) HWNDparam( 1 );
   BITMAP bm;

   memset( &bm, 0, sizeof( bm ) );

   if( hBitmap )
   {
      GetObject( hBitmap, sizeof( bm ), &bm );
   }

   hb_reta( 3 );
   HB_STORNI( bm.bmWidth, -1, 1 );
   HB_STORNI( bm.bmHeight, -1, 2 );
   HB_STORNI( bm.bmBitsPixel, -1, 3 );
}

HB_FUNC( _OOHG_BITMAPFROMBUFFER )   // ( oSelf, cBuffer, lAutoSize, lIgnoreBkColor )
{
   POCTRL oSelf = _OOHG_GetControlInfo( hb_param( 1, HB_IT_OBJECT ) );
   HBITMAP hBitmap = 0;
   HGLOBAL hGlobal;
   LONG lWidth, lHeight;

   if( hb_parclen( 2 ) )
   {
      hGlobal = GlobalAlloc( GPTR, hb_parclen( 2 ) );
      if( hGlobal )
      {
         if( hb_parl( 3 ) )
         {
            RECT rect;
            GetClientRect( oSelf->hWnd, &rect );
            lWidth = rect.right;
            lHeight = rect.bottom;
         }
         else
         {
            lWidth = lHeight = 0;
         }
         memcpy( hGlobal, hb_parc( 2 ), hb_parclen( 2 ) );
         hBitmap = (HBITMAP) _OOHG_OleLoadPicture( hGlobal, oSelf->hWnd, oSelf->lBackColor, lWidth, lHeight, hb_parl( 4 ) );
         GlobalFree( hGlobal );
      }
   }

   HWNDret( hBitmap );
}

HB_FUNC( _OOHG_SETBITMAP )   // ( oSelf, hBitmap, iMessage, lScaleStretch, lAutoSize, lIgnoreBkColor )
{
   POCTRL oSelf = _OOHG_GetControlInfo( hb_param( 1, HB_IT_OBJECT ) );
   HBITMAP hBitmap1, hBitmap2 = 0;

   hBitmap1 = ( HBITMAP ) HWNDparam( 2 );
   if( hBitmap1 )
   {
      if( hb_parl( 4 ) )           // Stretch
      {
         hBitmap2 = _OOHG_ScaleImage( oSelf->hWnd, hBitmap1, 0, 0, TRUE, oSelf->lBackColor, hb_parl( 6 ), 0, 0 );
      }
      else if( hb_parl( 5 ) )      // AutoSize
      {
         hBitmap2 = _OOHG_ScaleImage( oSelf->hWnd, hBitmap1, 0, 0, FALSE, oSelf->lBackColor, hb_parl( 6 ), 0, 0 );
      }
      else                         // No scale
      {
         BITMAP bm;
         GetObject( hBitmap1, sizeof( bm ), &bm );
         hBitmap2 = _OOHG_ScaleImage( oSelf->hWnd, hBitmap1, bm.bmWidth, bm.bmHeight, FALSE, oSelf->lBackColor, hb_parl( 6 ), 0, 0 );
      }
   }
   SendMessage( oSelf->hWnd, hb_parni( 3 ), ( WPARAM ) IMAGE_BITMAP, ( LPARAM ) hBitmap2 );

   HWNDret( hBitmap2 );
}

HB_FUNC( _OOHG_BITMAPWIDTH )
{
   BITMAP bm;
   HBITMAP hBmp;

   memset( &bm, 0, sizeof( bm ) );
   hBmp = ( HBITMAP ) HWNDparam( 1 );
   if( hBmp )
   {
      GetObject( hBmp, sizeof( bm ), &bm );
   }
   hb_retni( bm.bmWidth );
}

HB_FUNC( _OOHG_BITMAPHEIGHT )
{
   BITMAP bm;
   HBITMAP hBmp;

   memset( &bm, 0, sizeof( bm ) );
   hBmp = ( HBITMAP ) HWNDparam( 1 );
   if( hBmp )
   {
      GetObject( hBmp, sizeof( bm ), &bm );
   }
   hb_retni( bm.bmHeight );
}

HB_FUNC( _OOHG_ROTATEIMAGE )            // ( oSelf, hBitMap, nDegree )
{
   POCTRL oSelf = _OOHG_GetControlInfo( hb_param( 1, HB_IT_OBJECT ) );
   HBITMAP hBitmap;

   hBitmap = _OOHG_RotateImage( oSelf->hWnd, ( HBITMAP ) HWNDparam( 2 ), oSelf->lBackColor, hb_parni( 3 ) );

   HWNDret( hBitmap );
}

HB_FUNC( _OOHG_SCALEIMAGE )            // ( oSelf, hBitMap, nWidth, nHeight, lScalestrech, uBackcolor, lIgnoreBkColor, nHrzMrgn, nVrtMrg )
{
   POCTRL oSelf = _OOHG_GetControlInfo( hb_param( 1, HB_IT_OBJECT ) );
   HBITMAP hBitmap;
   LONG lColor = -1;

   _OOHG_DetermineColor( hb_param( 6, HB_IT_ANY ), &lColor );
   if( lColor == -1 )
   {
      lColor = oSelf->lBackColor;
   }

   hBitmap = _OOHG_ScaleImage( oSelf->hWnd, (HBITMAP) HWNDparam( 2 ), hb_parni( 3 ), hb_parni( 4 ), hb_parl( 5 ), lColor, hb_parl( 7 ), hb_parni( 8 ), hb_parni( 9 ) );

   HWNDret( hBitmap );
}

HB_FUNC( _OOHG_BLENDIMAGE )            // ( hImage, nImgX, nImgY, nImgW, nImgH, hSprite, aColor, nSprX, nSprY, nSprW, nSprH )
{
   HBITMAP hImage, hSprite;
   int iSprX, iSprY, iSprW, iSprH, iImgX, iImgY, iImgW, iImgH;
   LONG clrTransp = -1;
   BITMAP bmSprite;
   HDC hdc, hdc_I, hdc_S;
   HBITMAP hOldI, hOldS;

   hImage = (HBITMAP) HWNDparam( 1 );
   hSprite = (HBITMAP) HWNDparam( 6 );

   if( ValidHandler( hImage ) && ValidHandler( hSprite ) )
   {
      // Put images in DCs
      hdc = GetDC( NULL );
      hdc_I = CreateCompatibleDC( hdc );
      hOldI = SelectObject( hdc_I, hImage );
      hdc_S = CreateCompatibleDC( hdc );
      hOldS = SelectObject( hdc_S, hSprite );

      // Get transparent color
      _OOHG_DetermineColor( hb_param( 7, HB_IT_ANY ), &clrTransp );
      if( clrTransp == -1 )
      {
         clrTransp = GetPixel( hdc_S, 0, 0 );
      }

      // Set dimensions
      GetObject( hSprite, sizeof( BITMAP ), &bmSprite );
      iImgX = HB_ISNIL( 2 ) ? 0 : hb_parni( 2 );
      iImgY = HB_ISNIL( 3 ) ? 0 : hb_parni( 3 );
      iImgW = hb_parni( 4 );
      if( iImgW <= 0 )
      {
         iImgW = bmSprite.bmWidth;
      }
      iImgH = hb_parni( 5 );
      if( iImgH <= 0 )
      {
         iImgH = bmSprite.bmHeight;
      }
      iSprX = HB_ISNIL( 8 ) ? 0 : hb_parni( 8 );
      iSprY = HB_ISNIL( 9 ) ? 0 : hb_parni( 9 );
      iSprW = hb_parni( 10 );
      if( iSprW <= 0 )
      {
         iSprW = bmSprite.bmWidth;
      }
      iSprH = hb_parni( 11 );
      if( iSprH <= 0 )
      {
         iSprH = bmSprite.bmHeight;
      }

      // Blend
      TransparentBlt( hdc_I, iImgX, iImgY, iImgW, iImgH, hdc_S, iSprX, iSprY, iSprW, iSprH, clrTransp );

      // Clean
      SelectObject( hdc_I, hOldI );
      DeleteDC( hdc_I );
      SelectObject( hdc_S, hOldS );
      DeleteDC( hdc_S );
      DeleteDC( hdc );
   }
}

HB_FUNC( _OOHG_COPYBITMAP )            // ( hBitmap, nWidth, nHeight, iAttributes )
{
   HBITMAP hCopy;

   hCopy = CopyImage( ( HBITMAP ) HWNDparam( 1 ), IMAGE_BITMAP, hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ) );

   HWNDret( hCopy );
}

HBITMAP _OOHG_ReplaceColor( HBITMAP hBitmap, INT x, INT y, LONG lNewColor, LONG lOldColor )
{
   HDC hdcSrc, hdcDst;
   INT nRow, nCol;
   HBITMAP hbmOldSrc, hbmOldDst, hbmNew = 0;
   BITMAP bm;
   COLORREF clrOld, clrNew = ( COLORREF ) lNewColor;

   if( ( hdcSrc = CreateCompatibleDC( NULL ) ) != NULL )
   {
      if( ( hdcDst = CreateCompatibleDC( NULL ) ) != NULL )
      {
         GetObject( hBitmap, sizeof( bm ), &bm );
         hbmOldSrc = SelectObject( hdcSrc, hBitmap );
         hbmNew = CreateBitmap( bm.bmWidth, bm.bmHeight, bm.bmPlanes, bm.bmBitsPixel, NULL );
         hbmOldDst = SelectObject( hdcDst, hbmNew );
         BitBlt( hdcDst, 0, 0, bm.bmWidth, bm.bmHeight, hdcSrc, 0, 0, SRCCOPY );

         if( x == -1 || y == -1 )
         {
            clrOld = ( COLORREF ) lOldColor;
         }
         else
         {
            clrOld = GetPixel( hdcDst, x, y );
         }

         if( clrOld != CLR_INVALID )
         {
            for( nRow = 0; nRow < bm.bmHeight; nRow ++ )
            {
               for( nCol = 0; nCol < bm.bmWidth; nCol ++ )
               {
                  if( GetPixel( hdcDst, nCol, nRow ) == clrOld )
                  {
                     SetPixel( hdcDst, nCol, nRow, clrNew );
                  }
               }
            }
         }

         SelectObject( hdcSrc, hbmOldSrc );
         SelectObject( hdcDst, hbmOldDst );
         DeleteDC( hdcDst );
      }
      DeleteDC( hdcSrc );
   }

   return hbmNew;
}

HB_FUNC( _OOHG_REPLACECOLOR )          /* FUNCTION _OOHG_ReplaceColor( hBitmap, nCol, nRow, uNewColor, uOldColor ) -> hBitmap */
{
   LONG lNewColor = -1;
   LONG lOldColor = -1;

   _OOHG_DetermineColor( hb_param( 4, HB_IT_ANY ), &lNewColor );
   if( lNewColor == -1 )
   {
      lNewColor = GetSysColor( COLOR_BTNFACE );
   }
   _OOHG_DetermineColor( hb_param( 5, HB_IT_ANY ), &lOldColor );

   HWNDret( _OOHG_ReplaceColor( ( HBITMAP ) HWNDparam( 1 ), hb_parni( 2 ), hb_parni( 3 ), lNewColor, lOldColor ) );
}
