/*
 * $Id: c_image.c $
 */
/*
 * ooHG source code:
 * Image related functions
 *
 * Copyright 2005-2020 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2020 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2020 Contributors, https://harbour.github.io/
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


#ifndef CINTERFACE
   #define CINTERFACE
#endif

#include "oohg.h"
#include <shlobj.h>
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "winreg.h"
#include "tchar.h"
#include <winuser.h>
#include <wingdi.h>
#include "olectl.h"

static int _OOHG_StretchBltMode = COLORONCOLOR;

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_STRETCHBLTMODE )          /* FUNCTION _OOHG_StretchBltMode( lNewValue ) -> lOldValue */
{
   int OldStretchBltMode;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   OldStretchBltMode = _OOHG_StretchBltMode;
   if( HB_ISNUM( 1 ) )
   {
      _OOHG_StretchBltMode = hb_parni( 1 );
   }
   ReleaseMutex( _OOHG_GlobalMutex() );

   hb_retni( OldStretchBltMode );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HANDLE _OOHG_OleLoadPicture( HGLOBAL hGlobal, HWND hWnd, long lBackColor, long lWidth2, long lHeight2, BOOL bIgnoreBkClr )
{
   HANDLE hImage = 0;
   IStream * iStream;
   IPicture * iPicture;
   IPicture ** iPictureRef = &iPicture;
   long lWidth, lHeight;
   HDC hdc1, hdc2;
   RECT rect;
   HBRUSH hBrush;
   HBITMAP hOld;

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

      if( ! lWidth2 || ! lHeight2 )
      {
         /* Takes "real" image size */
         float fAux;

         iPicture->lpVtbl->get_CurDC( iPicture, &hdc1 );
         hdc1 = CreateCompatibleDC( hdc1 );
         fAux = ( ( lWidth * GetDeviceCaps( hdc1, LOGPIXELSX ) ) / 2540 ) + ( float ) 0.9999f;
         lWidth2 = (long) fAux;
         fAux = ( ( lHeight * GetDeviceCaps( hdc1, LOGPIXELSY ) ) / 2540 ) + ( float ) 0.9999f;
         lHeight2 = (long) fAux;
         DeleteDC( hdc1 );
      }

      SetRect( &rect, 0, 0, lWidth2, lHeight2 );

      hdc1 = GetDC( hWnd );
      hdc2 = CreateCompatibleDC( hdc1 );
      hImage = CreateCompatibleBitmap( hdc1, lWidth2, lHeight2 );
      hOld = (HBITMAP) SelectObject( hdc2, hImage );

      if( ! bIgnoreBkClr )
      {
         if( lBackColor == -1 )
         {
            hBrush = GetSysColorBrush( COLOR_BTNFACE );
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

      ReleaseDC( hWnd, hdc1 );
      SelectObject( hdc2, hOld );
      DeleteDC( hdc2 );
   }

   return hImage;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HBITMAP _OOHG_ScaleImage( HWND hWnd, HBITMAP hImage, long iWidth, long iHeight, BOOL scale, long BackColor, BOOL bIgnoreBkColor, int iHrzMrgn, int iVrtMrgn )
{
   RECT fromRECT, toRECT;
   HBITMAP hOldTo, hOldFrom, hpic = 0;
   BITMAP bm;
   long lWidth, lHeight;
   HDC imgDC, fromDC, toDC;
   HBRUSH hBrush;

   if( hImage )
   {
      imgDC = GetDC( hWnd );
      fromDC = CreateCompatibleDC( imgDC );
      toDC = CreateCompatibleDC( imgDC );

      if( BackColor == -1 )
      {
         hBrush = GetSysColorBrush( COLOR_BTNFACE );
      }
      else
      {
         hBrush = CreateSolidBrush( (COLORREF) BackColor );
      }

      /* FROM parameters */
      GetObject( hImage, sizeof( BITMAP ), &bm );
      lWidth  = bm.bmWidth;
      lHeight = bm.bmHeight;
      SetRect( &fromRECT, 0, 0, lWidth, lHeight );
      if( ! bIgnoreBkColor )
      {
         FillRect( fromDC, &fromRECT, hBrush );
      }
      hOldFrom = (HBITMAP) SelectObject( fromDC, hImage );

      /* TO parameters */
      if( hWnd && ( iWidth == 0 || iHeight == 0 ) )
      {
         GetClientRect( hWnd, &toRECT );
         iWidth  = toRECT.right - toRECT.left - iHrzMrgn;
         iHeight = toRECT.bottom - toRECT.top - iVrtMrgn;
         if( scale )
         {
            if( (int) ( lWidth * iHeight / lHeight ) <= iWidth )
            {
               iWidth  = (int) ( lWidth  * iHeight / lHeight );
            }
            else
            {
               iHeight = (int) ( lHeight * iWidth  / lWidth );
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
      hOldTo = (HBITMAP) SelectObject( toDC, hpic );

      SetStretchBltMode( toDC, _OOHG_StretchBltMode );
      if( _OOHG_StretchBltMode == HALFTONE )
      {
         SetBrushOrgEx( toDC, 0, 0, NULL );
      }
      StretchBlt( toDC, 0, 0, iWidth, iHeight, fromDC, 0, 0, lWidth, lHeight, SRCCOPY );

      ReleaseDC( hWnd, imgDC );
      SelectObject( fromDC, hOldFrom );
      DeleteDC( fromDC);
      SelectObject( toDC, hOldTo );
      DeleteDC( toDC );
      DeleteObject( hBrush );
   }

   return hpic;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HBITMAP _OOHG_RotateImage( HWND hWnd, HBITMAP hImage, long BackColor, int iDegree )
{
   RECT rect;
   POINT point[ 3 ];
   HBITMAP hOld1, hOld2, hpic = 0;
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
         hBrush = GetSysColorBrush( COLOR_BTNFACE );
      }
      else
      {
         hBrush = CreateSolidBrush( BackColor );
      }

      /* FROM parameters */
      GetObject( hImage, sizeof( BITMAP ), &bm );
      iWidth  = bm.bmWidth;
      iHeight = bm.bmHeight;
      SetRect( &rect, 0, 0, iWidth, iHeight );
      FillRect( fromDC, &rect, hBrush );
      hOld1 = (HBITMAP) SelectObject( fromDC, hImage );

      /* TO parameters */
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
      hOld2 = (HBITMAP) SelectObject( toDC, hpic );
      SetStretchBltMode( toDC, _OOHG_StretchBltMode );
      if( _OOHG_StretchBltMode == HALFTONE )
      {
         SetBrushOrgEx( toDC, 0, 0, NULL );
      }
      PlgBlt( toDC, ( POINT * ) &point, fromDC, 0, 0, iWidth, iHeight, NULL, 0, 0 );

      ReleaseDC( hWnd, imgDC );
      SelectObject( fromDC, hOld1 );
      DeleteDC( fromDC);
      SelectObject( toDC, hOld2 );
      DeleteDC( toDC );
      DeleteObject( hBrush );
   }

   return hpic;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HANDLE _OOHG_LoadImage( const char *cImage, int iAttributes, int nWidth, int nHeight, HWND hWnd, long lBackColor, BOOL bIgnoreBkClr )
{
   HANDLE hImage;
   HBRUSH hBrush;
   HINSTANCE hinstance = GetModuleHandle( NULL );

   /* Validate cImage parameter */
   if( ! cImage || ! *cImage )
   {
      return NULL;
   }

   /* Background color, for MENUs use COLOR_MENU (see h_menu.prg) */
   if( lBackColor == -1 )
   {
      lBackColor = GetSysColor( COLOR_BTNFACE );
      hBrush = GetSysColorBrush( COLOR_BTNFACE );
   }
   else
   {
      hBrush = CreateSolidBrush( lBackColor );
   }

   /* Try to load BITMAP from EXE */
   hImage = LoadImage( hinstance, cImage, IMAGE_BITMAP, nWidth, nHeight, iAttributes );
   if( ! hImage )
   {
      /* Try to load BITMAP from FILE */
      hImage = LoadImage( NULL, cImage, IMAGE_BITMAP, nWidth, nHeight, iAttributes | LR_LOADFROMFILE );
   }
   if( ! hImage )
   {
      if( bIgnoreBkClr )
      {
         /* Try to load ICON from EXE */
         hImage = LoadImage( hinstance, cImage, IMAGE_ICON, nWidth, nHeight, iAttributes );
         if( ! hImage )
         {
            /* Try to load ICON from FILE */
            hImage = LoadImage( 0, cImage, IMAGE_ICON, nWidth, nHeight, iAttributes | LR_LOADFROMFILE );
         }
      }
      else
      {
         HICON hIcon;

         /* Try to load ICON from EXE */
         hIcon = (HICON) LoadImage( hinstance, cImage, IMAGE_ICON, nWidth, nHeight, iAttributes );
         if( ! hIcon )
         {
            /* Try to load ICON from FILE */
            hIcon = (HICON) LoadImage( 0, cImage, IMAGE_ICON, nWidth, nHeight, iAttributes | LR_LOADFROMFILE );
         }
         if( hIcon )
         {
            HDC imgDC, toDC;
            ICONINFO IconInfo;
            BITMAP bm ;
            HBITMAP hOldBmp;
            int iWidth, iHeight;

            GetIconInfo( hIcon, &IconInfo );

            if( IconInfo.hbmColor )
            {
               /* color ICON */
               GetObject( IconInfo.hbmColor, sizeof( BITMAP ), &bm );
               iWidth  = bm.bmWidth;
               iHeight = bm.bmHeight;

               imgDC = GetDC( hWnd );
               toDC = CreateCompatibleDC( imgDC );       

               hImage = CreateCompatibleBitmap( imgDC, iWidth, iHeight );      
               hOldBmp = (HBITMAP) SelectObject( toDC, hImage );

               DrawIconEx( toDC, 0, 0, hIcon, iWidth, iHeight, 0, hBrush, DI_NORMAL );

               ReleaseDC( hWnd, imgDC );      
               hImage = SelectObject( toDC, hOldBmp );
               DeleteDC( toDC );      
               DestroyIcon( hIcon );       
               DeleteObject( IconInfo.hbmColor );      
               DeleteObject( IconInfo.hbmMask );     
            }
            else
            {
               /* black and white ICON */
               if( IconInfo.hbmMask )
               {
                  GetObject( IconInfo.hbmMask, sizeof( BITMAP ), &bm );
                  iWidth  = bm.bmWidth;
                  iHeight = bm.bmHeight / 2;

                  imgDC = GetDC( hWnd );
                  toDC = CreateCompatibleDC( imgDC );

                  hImage = CreateBitmap( iWidth, iHeight, 1, 1, NULL );
                  hOldBmp = (HBITMAP) SelectObject( toDC, hImage );
                  DrawIconEx( toDC, 0, 0, hIcon, iWidth, iHeight, 0, hBrush, DI_IMAGE );

                  ReleaseDC( hWnd, imgDC );
                  hImage = (HBITMAP) SelectObject( toDC, hOldBmp );
                  DeleteDC( toDC );
                  DestroyIcon( hIcon );
                  DeleteObject( IconInfo.hbmColor );
                  DeleteObject( IconInfo.hbmMask );
               }
               else
               {
                  DestroyIcon( hIcon );
                  DeleteObject( IconInfo.hbmColor );
                  DeleteObject( IconInfo.hbmMask );
                  DeleteObject( hBrush );
                  return NULL;
               }
            }
         }
      }
   }

   /* Try to create from EXE, using OleLoadPicture */
   if( ! hImage )
   {
      HRSRC hSource;
      HGLOBAL hGlobal, hGlobalres;
      LPVOID lpVoid;
      DWORD nSize;

      hSource = FindResource( hinstance, cImage, "BMP" );
      if( ! hSource )
      {
         hSource = FindResource( hinstance, cImage, "BITMAP" );
      }
      if( ! hSource )
      {
         hSource = FindResource( hinstance, cImage, "GIF" );
      }
      if( ! hSource )
      {
         hSource = FindResource( hinstance, cImage, "JPG" );
      }
      if( ! hSource )
      {
         hSource = FindResource( hinstance, cImage, "JPEG" );
      }
      if( ! hSource )
      {
         hSource = FindResource( hinstance, cImage, "ICO" );
      }
      if( ! hSource )
      {
         hSource = FindResource( hinstance, cImage, "ICON" );
      }
      if( ! hSource )
      {
         hSource = FindResource( hinstance, cImage, "PNG" );
      }
      if( ! hSource )
      {
         hSource = FindResource( hinstance, cImage, "TIFF" );
      }
      if( hSource )
      {
         hGlobalres = LoadResource( hinstance, hSource );
         if( hGlobalres )
         {
            lpVoid = LockResource( hGlobalres );
            if( lpVoid )
            {
               nSize = SizeofResource( hinstance, hSource );
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

   /* Try to create from FILE, using OleLoadPicture */
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

   DeleteObject( hBrush );

   return hImage;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_BITMAPFROMFILE )          /* FUNCTION _OOHG_BitmapFromFile( oSelf, cFile, iAttributes, lAutoSize, lIgnoreBkColor, lColor ) -> hBitmap */
{
   POCTRL oSelf;
   HWND hWnd;
   HBITMAP hBitmap, hBitmap2;
   long lWidth, lHeight, lBackColor;
   BOOL bAutoSize;
   RECT rect;

   if( hb_parclen( 2 ) )
   {
      if( hb_param( 1, HB_IT_OBJECT ) )
      {
         oSelf = _OOHG_GetControlInfo( hb_param( 1, HB_IT_OBJECT ) );
         hWnd = oSelf->hWnd;
         bAutoSize = hb_parl( 4 );
         if( hb_param( 6, HB_IT_NUMERIC ) )
         {
            lBackColor = hb_parnl( 6 );
         }
         else
         {
            lBackColor = oSelf->lBackColor;
         }
      }
      else
      {
         hWnd = NULL;
         bAutoSize = FALSE;
         if( hb_param( 6, HB_IT_NUMERIC ) )
         {
            lBackColor = hb_parnl( 6 );
         }
         else
         {
            lBackColor = -1;
         }
      }
      if( bAutoSize )
      {
         GetClientRect( hWnd, &rect );
         lWidth = rect.right;
         lHeight = rect.bottom;
         hBitmap = (HBITMAP) _OOHG_LoadImage( hb_parc( 2 ), hb_parni( 3 ), lWidth, lHeight, hWnd, lBackColor, hb_parl( 5 ) );
         hBitmap2 = _OOHG_ScaleImage( hWnd, hBitmap, 0, 0, FALSE, lBackColor, hb_parl( 5 ), 0, 0 );
         DeleteObject( hBitmap );
      }
      else
      {
         /* full size */
         hBitmap2 = (HBITMAP) _OOHG_LoadImage( hb_parc( 2 ), hb_parni( 3 ), 0, 0, hWnd, lBackColor, hb_parl( 5 ) );
      }
      HBITMAPret( hBitmap2 );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_SIZEOFBITMAPFROMFILE )          /* FUNCTION _OOHG_SizeOfBitmapFromFile( cFile ) -> { nWidth, nHeight, nDepth } */
{
   HBITMAP hBitmap;
   BITMAP bm;

   memset( &bm, 0, sizeof( bm ) );

   if( hb_parclen( 2 ) )
   {
      hBitmap = (HBITMAP) _OOHG_LoadImage( hb_parc( 1 ), LR_CREATEDIBSECTION, 0, 0, NULL, -1, TRUE );

      if( hBitmap )
      {
         GetObject( hBitmap, sizeof( bm ), &bm );
         DeleteObject( hBitmap );
      }
   }

   hb_reta( 3 );
   HB_STORNI( bm.bmWidth, -1, 1 );
   HB_STORNI( bm.bmHeight, -1, 2 );
   HB_STORNI( bm.bmBitsPixel, -1, 3 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_SIZEOFHBITMAP )           /* FUNCTION _OOHG_SizeOfHBitmap( hBitmap ) -> { nWidth, nHeight, nDepth } */
{
   HBITMAP hBitmap = HBITMAPparam( 1 );
   BITMAP bm;

   memset( &bm, 0, sizeof( bm ) );

   if( ValidHandler( hBitmap ) )
   {
      GetObject( hBitmap, sizeof( bm ), &bm );
   }

   hb_reta( 3 );
   HB_STORNI( bm.bmWidth, -1, 1 );
   HB_STORNI( bm.bmHeight, -1, 2 );
   HB_STORNI( bm.bmBitsPixel, -1, 3 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_BITMAPFROMBUFFER )           /* FUNCTION _OOHG_BitmapFromBuffer( oSelf, cBuffer, lAutoSize, lIgnoreBkColor ) -> hBitmap */
{
   POCTRL oSelf = _OOHG_GetControlInfo( hb_param( 1, HB_IT_OBJECT ) );
   HBITMAP hBitmap = 0;
   HGLOBAL hGlobal;
   long lWidth, lHeight;

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

   HBITMAPret( hBitmap );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_SETBITMAP )           /* FUNCTION _OOHG_SetBitmap( oSelf, hBitmap, iMessage, lStretch, lAutoSize, lIgnoreBkColor ) -> hBitmap */
{
   POCTRL oSelf = _OOHG_GetControlInfo( hb_param( 1, HB_IT_OBJECT ) );
   HBITMAP hBitmap1, hBitmap2 = 0;

   hBitmap1 = HBITMAPparam( 2 );
   if( hBitmap1 )
   {
      if( hb_parl( 4 ) )           /* Stretch */
      {
         hBitmap2 = _OOHG_ScaleImage( oSelf->hWnd, hBitmap1, 0, 0, TRUE, oSelf->lBackColor, hb_parl( 6 ), 0, 0 );
      }
      else if( hb_parl( 5 ) )      /* AutoSize */
      {
         hBitmap2 = _OOHG_ScaleImage( oSelf->hWnd, hBitmap1, 0, 0, FALSE, oSelf->lBackColor, hb_parl( 6 ), 0, 0 );
      }
      else                         /* No scale */
      {
         BITMAP bm;
         GetObject( hBitmap1, sizeof( bm ), &bm );
         hBitmap2 = _OOHG_ScaleImage( oSelf->hWnd, hBitmap1, bm.bmWidth, bm.bmHeight, FALSE, oSelf->lBackColor, hb_parl( 6 ), 0, 0 );
      }
   }
   SendMessage( oSelf->hWnd, hb_parni( 3 ), (WPARAM) IMAGE_BITMAP, (LPARAM) hBitmap2 );

   HBITMAPret( hBitmap2 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_GETBITMAP )           /* FUNCTION _OOHG_GetBitmap( oSelf, iMessage ) -> hBitmap */
{
   POCTRL oSelf = _OOHG_GetControlInfo( hb_param( 1, HB_IT_OBJECT ) );

   HBITMAPret( (HBITMAP) SendMessage( oSelf->hWnd, hb_parni( 2 ), (WPARAM) IMAGE_BITMAP, 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_BITMAPWIDTH )          /* FUNCTION _OOHG_BitmapWidth( hBitmap ) -> nWidth */
{
   BITMAP bm;
   HBITMAP hBmp;

   memset( &bm, 0, sizeof( bm ) );
   hBmp = HBITMAPparam( 1 );
   if( hBmp )
   {
      GetObject( hBmp, sizeof( bm ), &bm );
   }
   hb_retni( bm.bmWidth );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_BITMAPHEIGHT )          /* FUNCTION _OOHG_BitmapHeight( hBitmap ) -> nHeight */
{
   BITMAP bm;
   HBITMAP hBmp;

   memset( &bm, 0, sizeof( bm ) );
   hBmp = HBITMAPparam( 1 );
   if( hBmp )
   {
      GetObject( hBmp, sizeof( bm ), &bm );
   }
   hb_retni( bm.bmHeight );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_ROTATEIMAGE )          /* FUNCTION _OOHG_RotateImage( oSelf, hBitMap, nDegree ) -> hBitmap */
{
   POCTRL oSelf = _OOHG_GetControlInfo( hb_param( 1, HB_IT_OBJECT ) );

   HBITMAPret( _OOHG_RotateImage( oSelf->hWnd, HBITMAPparam( 2 ), oSelf->lBackColor, hb_parni( 3 ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_SCALEIMAGE )          /* FUNCTION _OOHG_ScaleImage( oSelf, hBitMap, nWidth, nHeight, lScale, uBackcolor, lIgnoreBkColor, nHrzMrgn, nVrtMrg ) -> hBitmap */
{
   POCTRL oSelf;
   HWND hWnd = NULL;
   long lColor = -1;

   _OOHG_DetermineColor( hb_param( 6, HB_IT_ANY ), &lColor );

   if( hb_param( 1, HB_IT_OBJECT ) )
   {
      oSelf = _OOHG_GetControlInfo( hb_param( 1, HB_IT_OBJECT ) );
      hWnd = oSelf->hWnd;

      if( lColor == -1 )
      {
         lColor = oSelf->lBackColor;
      }
   }

   HBITMAPret( _OOHG_ScaleImage( hWnd, HBITMAPparam( 2 ), hb_parni( 3 ), hb_parni( 4 ), hb_parl( 5 ), lColor, hb_parl( 7 ), hb_parni( 8 ), hb_parni( 9 ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_BLENDIMAGE )          /* FUNCTION _OOHG_BlendImage( hImage, nImgX, nImgY, nImgW, nImgH, hSprite, aColor, nSprX, nSprY, nSprW, nSprH ) -> lSuccess */
{
   HBITMAP hImage, hSprite;
   int iSprX, iSprY, iSprW, iSprH, iImgX, iImgY, iImgW, iImgH;
   long clrTransp = -1;
   BITMAP bmSprite;
   HDC hdc, hdc_I, hdc_S;
   HBITMAP hOldI, hOldS;
   BOOL bResult = FALSE;

   hImage = HBITMAPparam( 1 );
   hSprite = HBITMAPparam( 6 );

   if( ValidHandler( hImage ) && ValidHandler( hSprite ) )
   {
      /* Put images in DCs */
      hdc = GetDC( NULL );
      hdc_I = CreateCompatibleDC( hdc );
      hOldI = (HBITMAP) SelectObject( hdc_I, hImage );
      hdc_S = CreateCompatibleDC( hdc );
      hOldS = (HBITMAP) SelectObject( hdc_S, hSprite );

      /* Get transparent color */
      _OOHG_DetermineColor( hb_param( 7, HB_IT_ANY ), &clrTransp );
      if( clrTransp == -1 )
      {
         clrTransp = GetPixel( hdc_S, 0, 0 );
      }

      /* Set dimensions */
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

      /* Blend */
      bResult = TransparentBlt( hdc_I, iImgX, iImgY, iImgW, iImgH, hdc_S, iSprX, iSprY, iSprW, iSprH, clrTransp );

      /* Clean */
      SelectObject( hdc_I, hOldI );
      DeleteDC( hdc_I );
      SelectObject( hdc_S, hOldS );
      DeleteDC( hdc_S );
      ReleaseDC( NULL, hdc );
   }
   hb_retl( bResult );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HBITMAP _OOHG_CopyBitmap( HBITMAP hBitmap, int x, int y, int width, int height )
{
   HBITMAP hbmOldSrc, hbmOldDst, hBitmap_New = 0;
   HDC hdcSrc, hdcDst;
   BITMAP bm;

   if( ( hdcSrc = CreateCompatibleDC( NULL ) ) != NULL )
   {
      if( ( hdcDst = CreateCompatibleDC( NULL ) ) != NULL )
      {
         GetObject( hBitmap, sizeof( bm ), &bm );
         hBitmap_New = CreateBitmap( width, height, bm.bmPlanes, bm.bmBitsPixel, NULL );

         hbmOldSrc = (HBITMAP) SelectObject( hdcSrc, hBitmap );
         hbmOldDst = (HBITMAP) SelectObject( hdcDst, hBitmap_New );

         BitBlt( hdcDst, 0, 0, width, height, hdcSrc, x, y, SRCCOPY );

         SelectObject( hdcDst, hbmOldDst);
         DeleteDC( hdcDst );
         SelectObject( hdcSrc, hbmOldSrc );
      }
      DeleteDC( hdcSrc );
   }

   return hBitmap_New;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_COPYBITMAP )          /* FUNCTION _OOHG_CopyBitmap( hBitmap, nCol, nRow, nWidth, nHeight ) -> hBitmap */
{
   HBITMAPret( _OOHG_CopyBitmap( HBITMAPparam( 1 ), hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_COPYIMAGE )          /* FUNCTION _OOHG_CopyImage( hWnd, nType, nWidth, nHeight, nAttributes ) -> handle */
{
   HANDLEret( CopyImage( HANDLEparam( 1 ), (UINT) hb_parni( 2 ), (int) hb_parni( 3 ), (int) hb_parni( 4 ), (UINT) hb_parni( 5 ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HBITMAP _OOHG_ReplaceColor( HBITMAP hBitmap, int x, int y, long lNewColor, long lOldColor )
{
   HDC hdcSrc, hdcDst;
   int nRow, nCol;
   HBITMAP hbmOldSrc, hbmOldDst, hbmNew = 0;
   BITMAP bm;
   COLORREF clrOld, clrNew = (COLORREF) lNewColor;

   if( ( hdcSrc = CreateCompatibleDC( NULL ) ) != NULL )
   {
      if( ( hdcDst = CreateCompatibleDC( NULL ) ) != NULL )
      {
         GetObject( hBitmap, sizeof( bm ), &bm );
         hbmOldSrc = (HBITMAP) SelectObject( hdcSrc, hBitmap );
         hbmNew = CreateBitmap( bm.bmWidth, bm.bmHeight, bm.bmPlanes, bm.bmBitsPixel, NULL );
         hbmOldDst = (HBITMAP) SelectObject( hdcDst, hbmNew );
         BitBlt( hdcDst, 0, 0, bm.bmWidth, bm.bmHeight, hdcSrc, 0, 0, SRCCOPY );

         if( x == -1 || y == -1 )
         {
            clrOld = (COLORREF) lOldColor;
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

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_REPLACECOLOR )          /* FUNCTION _OOHG_ReplaceColor( hBitmap, nCol, nRow, uNewColor, uOldColor ) -> hBitmap */
{
   long lNewColor = -1;
   long lOldColor = -1;

   _OOHG_DetermineColor( hb_param( 4, HB_IT_ANY ), &lNewColor );
   if( lNewColor == -1 )
   {
      lNewColor = GetSysColor( COLOR_BTNFACE );
   }
   _OOHG_DetermineColor( hb_param( 5, HB_IT_ANY ), &lOldColor );

   HBITMAPret( _OOHG_ReplaceColor( HBITMAPparam( 1 ), hb_parni( 2 ), hb_parni( 3 ), lNewColor, lOldColor ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_DRAWBITMAP )          /* FUNCTION _OOHG_DrawBitmap( hBitmap, nRow, nCol, nWidth, nHeight, lImageSize, nMode, lClrOnClr, lTransparent, nColor, hDC ) -> lSuccess */
{
   HBITMAP hBitmap = HBITMAPparam( 1 );
   int rF = hb_parni( 2 );
   int cF = hb_parni( 3 );
   BOOL ImgSize = hb_parl( 6 );
   int Mode = hb_parni( 7 );
   BOOL ClrOnClr = hb_parl( 8 );
   BOOL Transparent = hb_parl( 9 );
   COLORREF color_transp = (COLORREF) hb_parnl( 10 );
   HDC hDC = HDCparam( 11 );
   HDC memDC;
   HBITMAP hOld;
   BITMAP bm;
   POINT Point;
   int Width;
   int Height;
   BOOL bResult;

   memset( &bm, 0, sizeof( bm ) );
   GetObject( hBitmap, sizeof( bm ), &bm );

   if( ImgSize )
   {
      Width = bm.bmWidth;
      Height = bm.bmHeight;
   }
   else
   {
      Width = hb_parni( 4 );
      Height = hb_parni( 5 );
   }

   memDC = CreateCompatibleDC( hDC );
   hOld = (HBITMAP) SelectObject( memDC, hBitmap );

   switch( Mode )
   {
      case 1:   /* STRETCH */
         break;
      case 3:   /* COPY */
         Width = bm.bmWidth = min( Width,  bm.bmWidth );
         Height = bm.bmHeight = min( Height, bm.bmHeight );
         break;
      default:   /* SCALE */
         if( (int) ( bm.bmWidth * Height / bm.bmHeight ) <= Width )
            Width = (int) ( bm.bmWidth * Height / bm.bmHeight );
         else
            Height = (int) ( bm.bmHeight * Width / bm.bmWidth );
         break;
   }

   GetBrushOrgEx( hDC, &Point );
   if( ClrOnClr )
   {
      SetStretchBltMode( hDC, COLORONCOLOR );
   }
   else
   {
      SetStretchBltMode( hDC, HALFTONE );
   }
   SetBrushOrgEx( hDC, Point.x, Point.y, NULL );

   if( Transparent )
   {
      bResult = TransparentBlt( hDC, cF, rF, Width, Height, memDC, 0, 0, bm.bmWidth, bm.bmHeight, color_transp );
   }
   else
   {
      bResult = StretchBlt( hDC, cF, rF, Width, Height, memDC, 0, 0, bm.bmWidth, bm.bmHeight, SRCCOPY );
   }

   SelectObject( memDC, hOld );
   DeleteDC( memDC );

   hb_retl( bResult );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_GETPIXELCOLOR )          /* FUNCTION _OOHG_GetPixelColor( hBitmap, row, col ) -> nColor */
{
   HBITMAP hBmp = HBITMAPparam( 1 );
   HBITMAP hOld;
   int x, y;
   HDC memDC;
   COLORREF color;

   if( hBmp )
   {
      x = hb_parni( 2 );
      y = hb_parni( 3 );
      memDC = CreateCompatibleDC( NULL );
      hOld = (HBITMAP) SelectObject( memDC, hBmp );
      color = GetPixel( memDC, x, y );
      SelectObject( memDC, hOld );
      DeleteDC( memDC );
   }
   else
   {
      color = -1;
   }
   hb_retnl( (long) color );
}
