/*
 * $Id: c_gdiplus.c,v 1.21 2016-05-22 23:53:21 fyurisich Exp $
 */
/*
 * ooHG source code:
 * C GDI+ functions
 *
 * Copyright 2013-2016 Vicente Guerra <vicente@guerra.com.mx>
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
/*
 * This source file is based on the hbGdiPlus library source
 * Copyright 2007 P.Chornyj <myorg63@mail.ru>
 *
 */

#include <windows.h>
#include "hbapi.h"
#include "hbapiitm.h"
#include <commctrl.h>
#include "oohg.h"

typedef void(__stdcall* DEBUGEVENTPROC) ( void*, char* );
typedef int(__stdcall* GET_THUMBNAIL_IMAGE_ABORT) ( void* );

typedef struct
{
   UINT GdiPlusVersion;
   DEBUGEVENTPROC DebugEventCallback;
   int SuppressBackgroundThread;
   int SuppressExternalCodecs;
} GDIPLUS_STARTUP_INPUT;

typedef struct
{
   CLSID Clsid;
   GUID FormatID;
   const unsigned short *CodecName;
   const unsigned short *DllName;
   const unsigned short *FormatDescription;
   const unsigned short *FilenameExtension;
   const unsigned short *MimeType;
   ULONG Flags;
   ULONG Version;
   ULONG SigCount;
   ULONG SigSize;
   const unsigned char *SigPattern;
   const unsigned char *SigMask;
} IMAGE_CODEC_INFO;

typedef struct
{
   GUID Guid;
   ULONG NumberOfValues;
   ULONG Type;
   void *Value;
} ENCODER_PARAMETER;

typedef struct
{
   unsigned int Count;
   ENCODER_PARAMETER Parameter[];
} ENCODER_PARAMETERS;

enum EncoderValue
{
   EncoderValueColorTypeCMYK,
   EncoderValueColorTypeYCCK,
   EncoderValueCompressionLZW,
   EncoderValueCompressionCCITT3,
   EncoderValueCompressionCCITT4,
   EncoderValueCompressionRle,
   EncoderValueCompressionNone,
   EncoderValueScanMethodInterlaced,
   EncoderValueScanMethodNonInterlaced,
   EncoderValueVersionGif87,
   EncoderValueVersionGif89,
   EncoderValueRenderProgressive,
   EncoderValueRenderNonProgressive,
   EncoderValueTransformRotate90,
   EncoderValueTransformRotate180,
   EncoderValueTransformRotate270,
   EncoderValueTransformFlipHorizontal,
   EncoderValueTransformFlipVertical,
   EncoderValueMultiFrame,
   EncoderValueLastFrame,
   EncoderValueFlush,
   EncoderValueFrameDimensionTime,
   EncoderValueFrameDimensionResolution,
   EncoderValueFrameDimensionPage
};

typedef DWORD ARGB;

#define ARGB(a,r,g,b) ((ARGB)(((DWORD)(a)<<24)|((DWORD)(r)<<16)|((DWORD)(g)<<8)|((DWORD)(b))))

#define COLORREFtoARGB(rgb) (ARGB(0xFF,GetRValue(rgb),GetGValue(rgb),GetBValue(rgb)))

typedef void* gPlusImage;
typedef gPlusImage * gPlusImagePtr;

typedef LONG(__stdcall* GDIPLUSSTARTUP) ( ULONG*, const GDIPLUS_STARTUP_INPUT*, void* );
typedef void(__stdcall* GDIPLUSSHUTDOWN) ( ULONG );

typedef LONG(__stdcall* GDIPCREATEBITMAPFROMHBITMAP) ( void*, void*, void** );
typedef LONG(__stdcall* GDIPGETIMAGEENCODERSSIZE) ( unsigned int*, unsigned int* );
typedef LONG(__stdcall* GDIPGETIMAGEENCODERS) ( UINT, UINT, IMAGE_CODEC_INFO* );
typedef LONG(__stdcall* GDIPSAVEIMAGETOFILE) ( void*, const unsigned short*, const CLSID*, const ENCODER_PARAMETERS* );
typedef LONG(__stdcall* GDIPLOADIMAGEFROMSTREAM) ( IStream*, void** );
typedef LONG(__stdcall* GDIPCREATEBITMAPFROMSTREAM) ( IStream*, void** );
typedef LONG(__stdcall* GDIPCREATEHBITMAPFROMBITMAP) ( void*, void*, ARGB );
typedef LONG(__stdcall* GDIPDISPOSEIMAGE) ( void* );
typedef LONG(__stdcall* GDIPGETIMAGETHUMBNAIL) ( void*, UINT, UINT, void**, GET_THUMBNAIL_IMAGE_ABORT, void* );

typedef LONG(__stdcall* GDIPLOADIMAGEFROMFILE) ( const unsigned short*, void** );
typedef LONG(__stdcall* GDIPGETIMAGEWIDTH) ( void*, UINT* );
typedef LONG(__stdcall* GDIPGETIMAGEHEIGHT) ( void*, UINT* );

BOOL InitDeinitGdiPlus( BOOL );
BOOL LoadGdiPlusDll( void );
BOOL GetEnCodecClsid( const char *, CLSID * );
LONG LoadImageFromFile( const char *, void** );

void *GdiPlusHandle = NULL;
ULONG GdiPlusToken = 0;
unsigned char *MimeTypeOld;

GDIPLUS_STARTUP_INPUT GdiPlusStartupInput;
GDIPLUSSTARTUP GdiPlusStartup;
GDIPLUSSHUTDOWN GdiPlusShutdown;
GDIPCREATEBITMAPFROMHBITMAP GdipCreateBitmapFromHBITMAP;
GDIPGETIMAGEENCODERSSIZE GdipGetImageEncodersSize;
GDIPGETIMAGEENCODERS GdipGetImageEncoders;
GDIPSAVEIMAGETOFILE GdipSaveImageToFile;
GDIPLOADIMAGEFROMSTREAM GdipLoadImageFromStream;
GDIPCREATEBITMAPFROMSTREAM GdipCreateBitmapFromStream;
GDIPCREATEHBITMAPFROMBITMAP GdipCreateHBITMAPFromBitmap;
GDIPDISPOSEIMAGE GdipDisposeImage;
GDIPGETIMAGETHUMBNAIL GdipGetImageThumbnail;
GDIPLOADIMAGEFROMFILE GdipLoadImageFromFile;
GDIPGETIMAGEWIDTH GdipGetImageWidth;
GDIPGETIMAGEHEIGHT GdipGetImageHeight;

static gPlusImagePtr hb_pargPlusImage( int );
static void hb_retgPlusImage( gPlusImagePtr );

static HB_GARBAGE_FUNC( hb_gPlusImage_Destructor )
{
   /* Retrieve image pointer holder */
   gPlusImagePtr * imPtr = ( gPlusImagePtr * ) Cargo;

   /* Check if pointer is not NULL to avoid multiple freeing */
   if( * imPtr )
   {
      GdipDisposeImage( * imPtr );
      * imPtr = NULL;
   }
}

#ifdef __XHARBOUR__

static gPlusImagePtr hb_pargPlusImage( int iParam )
{
   gPlusImagePtr * imPtr =
   ( gPlusImagePtr * ) hb_parptrGC( hb_gPlusImage_Destructor, iParam );

   if( imPtr )
      return * imPtr;
   else
      return NULL;
}

static void hb_retgPlusImage( gPlusImagePtr image )
{
   gPlusImagePtr * imPtr;

   imPtr = ( gPlusImagePtr * ) hb_gcAlloc( sizeof( gPlusImagePtr ), hb_gPlusImage_Destructor );
   * imPtr = image;
   hb_retptrGC( ( void * ) imPtr );
}

#else

static const HB_GC_FUNCS s_gcPlusImageFuncs =
{
   hb_gPlusImage_Destructor,
   hb_gcDummyMark
};

static gPlusImagePtr hb_pargPlusImage( int iParam )
{
   gPlusImagePtr * imPtr =
   ( gPlusImagePtr * ) hb_parptrGC( &s_gcPlusImageFuncs, iParam );

   if( imPtr )
      return * imPtr;
   else
      return NULL;
}

static void hb_retgPlusImage( gPlusImagePtr image )
{
   gPlusImagePtr * imPtr;

   imPtr = ( gPlusImagePtr * ) hb_gcAllocate( sizeof( gPlusImagePtr ),
   &s_gcPlusImageFuncs );
   * imPtr = image;
   hb_retptrGC( ( void * ) imPtr );
}

#endif

/*
Load and unload library
*/
HB_FUNC( GPLUSINIT )
{
   hb_retl( InitDeinitGdiPlus( TRUE ) );
}

HB_FUNC( GPLUSDEINIT )
{
   hb_retl( InitDeinitGdiPlus( FALSE ) );
}

static BOOL GDIP_InitOK;

BOOL InitDeinitGdiPlus( BOOL OnOff )
{

   if( ! OnOff )
   {
      if( ( GdiPlusShutdown != NULL ) && ( GdiPlusToken != 0 ) )
         GdiPlusShutdown( GdiPlusToken );

      if( GdiPlusHandle != NULL )
         FreeLibrary( GdiPlusHandle );

      GDIP_InitOK = FALSE;
      GdiPlusToken = 0;
      GdiPlusHandle = NULL;

      return TRUE;
   }
   if( GDIP_InitOK )
      return TRUE;

   if( ! LoadGdiPlusDll() )
      return FALSE;

   GdiPlusStartupInput.GdiPlusVersion           = 1;
   GdiPlusStartupInput.DebugEventCallback       = NULL;
   GdiPlusStartupInput.SuppressBackgroundThread = FALSE;
   GdiPlusStartupInput.SuppressExternalCodecs   = FALSE;

   if( GdiPlusStartup( &GdiPlusToken, &GdiPlusStartupInput, NULL ) )
   {
      FreeLibrary( GdiPlusHandle );
      GdiPlusHandle = NULL;

      return FALSE;
   }

   GDIP_InitOK = TRUE;

   return TRUE;
}

BOOL LoadGdiPlusDll( void )
{
   void *GdiPlusHandle_pre;

   if( ( GdiPlusHandle_pre = LoadLibrary( "GdiPlus.dll") ) == NULL )
      return FALSE;

   if( ( GdiPlusStartup = (GDIPLUSSTARTUP) GetProcAddress( GdiPlusHandle_pre, "GdiplusStartup" ) ) == NULL )
   {
      FreeLibrary(GdiPlusHandle_pre);
      return FALSE;
   }

   if( ( GdiPlusShutdown = (GDIPLUSSHUTDOWN) GetProcAddress( GdiPlusHandle_pre, "GdiplusShutdown" ) ) == NULL )
   {
      FreeLibrary( GdiPlusHandle_pre );
      return FALSE;
   }

   if( ( GdipLoadImageFromStream = (GDIPLOADIMAGEFROMSTREAM) GetProcAddress( GdiPlusHandle_pre, "GdipLoadImageFromStream" ) ) == NULL )
   {
      FreeLibrary( GdiPlusHandle_pre );
      return FALSE;
   }

   if( ( GdipCreateBitmapFromStream = (GDIPCREATEBITMAPFROMSTREAM) GetProcAddress( GdiPlusHandle_pre, "GdipCreateBitmapFromStream" ) ) == NULL )
   {
      FreeLibrary( GdiPlusHandle_pre );
      return FALSE;
   }

   if( ( GdipCreateHBITMAPFromBitmap = (GDIPCREATEHBITMAPFROMBITMAP) GetProcAddress( GdiPlusHandle_pre, "GdipCreateHBITMAPFromBitmap" ) ) == NULL )
   {
      FreeLibrary( GdiPlusHandle_pre );
      return FALSE;
   }

   if( ( GdipCreateBitmapFromHBITMAP = (GDIPCREATEBITMAPFROMHBITMAP) GetProcAddress( GdiPlusHandle_pre, "GdipCreateBitmapFromHBITMAP" ) ) == NULL )
   {
      FreeLibrary( GdiPlusHandle_pre );
      return FALSE;
   }

   if( ( GdipGetImageEncodersSize = (GDIPGETIMAGEENCODERSSIZE) GetProcAddress( GdiPlusHandle_pre, "GdipGetImageEncodersSize" ) ) == NULL )
   {
      FreeLibrary( GdiPlusHandle_pre );
      return FALSE;
   }

   if( ( GdipGetImageEncoders = (GDIPGETIMAGEENCODERS) GetProcAddress( GdiPlusHandle_pre, "GdipGetImageEncoders" ) ) == NULL )
   {
      FreeLibrary( GdiPlusHandle_pre );
      return FALSE;
   }

   if( ( GdipSaveImageToFile = (GDIPSAVEIMAGETOFILE) GetProcAddress( GdiPlusHandle_pre, "GdipSaveImageToFile" ) ) == NULL )
   {
      FreeLibrary( GdiPlusHandle_pre );
      return FALSE;
   }

   if( ( GdipDisposeImage = (GDIPDISPOSEIMAGE) GetProcAddress( GdiPlusHandle_pre, "GdipDisposeImage" ) ) == NULL )
   {
      FreeLibrary( GdiPlusHandle_pre );
      return FALSE;
   }

   if( ( GdipGetImageThumbnail = (GDIPGETIMAGETHUMBNAIL) GetProcAddress( GdiPlusHandle_pre, "GdipGetImageThumbnail" ) ) == NULL )
   {
      FreeLibrary( GdiPlusHandle_pre );
      return FALSE;
   }

   if( ( GdipLoadImageFromFile = (GDIPLOADIMAGEFROMFILE) GetProcAddress( GdiPlusHandle_pre, "GdipLoadImageFromFile" ) ) == NULL )
   {
      FreeLibrary( GdiPlusHandle_pre );
      return FALSE;
   }

   if( ( GdipGetImageWidth = (GDIPGETIMAGEWIDTH) GetProcAddress( GdiPlusHandle_pre, "GdipGetImageWidth" ) ) == NULL )
   {
      FreeLibrary( GdiPlusHandle_pre );
      return FALSE;
   }

   if( ( GdipGetImageHeight = (GDIPGETIMAGEHEIGHT) GetProcAddress( GdiPlusHandle_pre, "GdipGetImageHeight" ) ) == NULL )
   {
      FreeLibrary( GdiPlusHandle_pre );
      return FALSE;
   }

   GdiPlusHandle = GdiPlusHandle_pre;

   return TRUE;
}

/*
Encoders (mime types)
*/
HB_FUNC( GPLUSGETENCODERSNUM )
{
   UINT  num  = 0;         // number of image encoders
   UINT  size = 0;         // size of the image encoder array in bytes

   GdipGetImageEncodersSize( &num, &size );

   hb_retni( num );
}

HB_FUNC( GPLUSGETENCODERSSIZE )
{
   UINT  num  = 0;
   UINT  size = 0;

   GdipGetImageEncodersSize( &num, &size );

   hb_retni( size );
}

HB_FUNC( GPLUSGETENCODERS )
{
   UINT  num  = 0;
   UINT  size = 0;
   UINT  i;
   IMAGE_CODEC_INFO *pImageCodecInfo;
   PHB_ITEM pResult = hb_itemArrayNew( 0 );
   PHB_ITEM pItem;
   char *RecvMimeType;

   GdipGetImageEncodersSize( &num, &size );
   if( size == 0 )
   {
      #ifdef __XHARBOUR__
         hb_itemRelease( hb_itemReturn( pResult ) );
      #else
         hb_itemReturnRelease( pResult );
      #endif
   }

   pImageCodecInfo = (IMAGE_CODEC_INFO *) hb_xalloc( size );
   if( pImageCodecInfo == NULL )
   {
      // return a empty array
      #ifdef __XHARBOUR__
         hb_itemRelease( hb_itemReturn( pResult ) );
      #else
         hb_itemReturnRelease( pResult );
      #endif
   }

   RecvMimeType = LocalAlloc( LPTR, size );
   if( RecvMimeType == NULL)
   {
      hb_xfree( pImageCodecInfo );
      #ifdef __XHARBOUR__
         hb_itemRelease( hb_itemReturn( pResult ) );
      #else
         hb_itemReturnRelease( pResult );
      #endif
   }

   GdipGetImageEncoders( num, size, pImageCodecInfo );

   pItem = hb_itemNew( NULL );
   for( i = 0; i < num; ++i )
   {
      WideCharToMultiByte( CP_ACP, 0, pImageCodecInfo[i].MimeType, -1, RecvMimeType, size, NULL, NULL );

      pItem = hb_itemPutC( NULL, RecvMimeType );
      hb_arrayAdd( pResult, pItem );
   }

   // free resource
   LocalFree( RecvMimeType );
   hb_xfree( pImageCodecInfo );
   hb_itemRelease( pItem );

   // return a result array
   #ifdef __XHARBOUR__
      hb_itemRelease( hb_itemReturn( pResult ) );
   #else
      hb_itemReturnRelease( pResult );
   #endif
}

/*
Save hBitmap to a file
*/
HB_FUNC( GPLUSSAVEHBITMAPTOFILE )
{
   HBITMAP hbmp = (HBITMAP) hb_parnl( 1 );

   hb_retl( SaveHBitmapToFile( (void*) hbmp, hb_parc( 2 ), (UINT) hb_parnl( 3 ), (UINT) hb_parnl( 4 ), hb_parc( 5 ), (ULONG) hb_parnl( 6 ), (ULONG) hb_parnl( 7 ) ) );
}

BOOL SaveHBitmapToFile( void *HBitmap, const char *FileName, unsigned int Width, unsigned int Height, const char *MimeType, ULONG JpgQuality, ULONG ColorDepth )
{
   void *GBitmap;
   void *GBitmapThumbnail;
   LPWSTR WFileName;
   static CLSID Clsid;
   ENCODER_PARAMETERS *EncoderParameters;
   ULONG quality;

   if( ( HBitmap == NULL ) || ( FileName == NULL ) || ( MimeType == NULL ) || ( GdiPlusHandle == NULL ) )
   {
      return FALSE;
   }

   if ( MimeTypeOld == NULL )
   {
      if( ! GetEnCodecClsid( MimeType, &Clsid ) )
      {
         // Wrong MimeType
         return FALSE;
      }

      MimeTypeOld = LocalAlloc( LPTR, strlen( MimeType ) + 1 );
      if( MimeTypeOld == NULL )
      {
         // LocalAlloc Error
         return FALSE;
      }

      strcpy( ( char * ) MimeTypeOld, MimeType );
   }
   else
   {
      if( strcmp( ( char * ) MimeTypeOld, MimeType ) != 0 )
      {
         LocalFree( MimeTypeOld );

         if( ! GetEnCodecClsid( MimeType, &Clsid ) )
         {
            // Wrong MimeType
            return FALSE;
         }

         MimeTypeOld = LocalAlloc( LPTR, strlen( MimeType ) + 1 );
         if( MimeTypeOld == NULL )
         {
            // LocalAlloc Error
            return FALSE;
         }
         strcpy( ( char * ) MimeTypeOld, MimeType );
      }
   }

   GBitmap = 0;

   if( GdipCreateBitmapFromHBITMAP( HBitmap, NULL, &GBitmap ) )
   {
      // CreateBitmap Operation Error
      return FALSE;
   }

   WFileName = LocalAlloc( LPTR, ( strlen( FileName ) * sizeof( WCHAR ) ) + 1 );
   if( WFileName == NULL )
   {
      // WFile LocalAlloc Error
      return FALSE;
   }

   MultiByteToWideChar( CP_ACP, 0, FileName, -1, WFileName, ( strlen( FileName ) * sizeof( WCHAR ) ) - 1 );

   if( ( Width > 0 ) && ( Height > 0 ) )
   {
      GBitmapThumbnail = NULL;

      if( GdipGetImageThumbnail( GBitmap, Width, Height, &GBitmapThumbnail, NULL, NULL ) )
      {
         GdipDisposeImage(GBitmap);
         LocalFree( WFileName );
         // Thumbnail Operation Error
         return FALSE;
      }

      GdipDisposeImage( GBitmap );
      GBitmap = GBitmapThumbnail;
   }

   // Build parameters and save
   if( strcmp( MimeType, "image/jpeg" ) == 0 )
   {
      EncoderParameters = (ENCODER_PARAMETERS *) hb_xgrab( sizeof( ENCODER_PARAMETERS ) + 1 * sizeof( ENCODER_PARAMETER ) );
      ZeroMemory( EncoderParameters, sizeof( ENCODER_PARAMETERS ) + 1 * sizeof( ENCODER_PARAMETER ) );
      EncoderParameters->Count = 1;

      // Quality: TGUID = 1d5be4b5-fa4a-452d-9cdd-5db35105e7eb
      // Valid values: 0 (greatest compression, low quality) to 100 (least compression, high quality)
      // Defaults to 75.
      if( JpgQuality > 100 )
      {
         JpgQuality = 75;
      }
      EncoderParameters->Parameter[0].Guid.Data1 = 0x1d5be4b5;
      EncoderParameters->Parameter[0].Guid.Data2 = 0xfa4a;
      EncoderParameters->Parameter[0].Guid.Data3 = 0x452d;
      EncoderParameters->Parameter[0].Guid.Data4[0] = 0x9c;
      EncoderParameters->Parameter[0].Guid.Data4[1] = 0xdd;
      EncoderParameters->Parameter[0].Guid.Data4[2] = 0x5d;
      EncoderParameters->Parameter[0].Guid.Data4[3] = 0xb3;
      EncoderParameters->Parameter[0].Guid.Data4[4] = 0x51;
      EncoderParameters->Parameter[0].Guid.Data4[5] = 0x05;
      EncoderParameters->Parameter[0].Guid.Data4[6] = 0xe7;
      EncoderParameters->Parameter[0].Guid.Data4[7] = 0xeb;
      EncoderParameters->Parameter[0].NumberOfValues = 1;
      EncoderParameters->Parameter[0].Type = 4;
      EncoderParameters->Parameter[0].Value = (void*) &JpgQuality;

      // Colordepth for JPEG images is always 24 bpp

      // Save
      if( GdipSaveImageToFile( GBitmap, WFileName, &Clsid, EncoderParameters ) != 0 )
      {
         GdipDisposeImage( GBitmap );
         LocalFree( WFileName );
         hb_xfree( EncoderParameters );
         // Save Operation Error
         return FALSE;
      }
      hb_xfree( EncoderParameters );
   }
   else if( strcmp( MimeType, "image/tiff" ) == 0 )
   {
      EncoderParameters = (ENCODER_PARAMETERS *) hb_xgrab( sizeof( ENCODER_PARAMETERS ) + 2 * sizeof( ENCODER_PARAMETER ) );
      ZeroMemory( EncoderParameters, sizeof( ENCODER_PARAMETERS ) + 2 * sizeof( ENCODER_PARAMETER ) );
      EncoderParameters->Count = 2;

      // Compression: e09d739d-ccd4-44ee-8eba-3fbf8be4fc58
      EncoderParameters->Parameter[0].Guid.Data1 = 0xe09d739d;
      EncoderParameters->Parameter[0].Guid.Data2 = 0xccd4;
      EncoderParameters->Parameter[0].Guid.Data3 = 0x44ee;
      EncoderParameters->Parameter[0].Guid.Data4[0] = 0x8e;
      EncoderParameters->Parameter[0].Guid.Data4[1] = 0xba;
      EncoderParameters->Parameter[0].Guid.Data4[2] = 0x3f;
      EncoderParameters->Parameter[0].Guid.Data4[3] = 0xbf;
      EncoderParameters->Parameter[0].Guid.Data4[4] = 0x8b;
      EncoderParameters->Parameter[0].Guid.Data4[5] = 0xe4;
      EncoderParameters->Parameter[0].Guid.Data4[6] = 0xfc;
      EncoderParameters->Parameter[0].Guid.Data4[7] = 0x58;
      EncoderParameters->Parameter[0].NumberOfValues = 1;
      EncoderParameters->Parameter[0].Type = 4;
      if( JpgQuality == 0 )
      {
         quality = EncoderValueCompressionNone;
      }
      else
      {
         quality = EncoderValueCompressionLZW;
      }
      EncoderParameters->Parameter[0].Value = (void*) &quality;

      // ColorDepth: 66087055-ad66-4c7c-9a18-38a2310b8337
      // Valid values for TIFF images are 1, 4, 8, 24, 32 bpp
      // Use 24 bpp if you want to include the image in a PDF file using TPDF class
      if( ! ( ( ColorDepth == 1 ) || ( ColorDepth == 4 ) || ( ColorDepth == 8 ) || ( ColorDepth == 24 ) || ( ColorDepth == 32 ) ) )
      {
         ColorDepth = 24;
      }
      EncoderParameters->Parameter[1].Guid.Data1 = 0x66087055;
      EncoderParameters->Parameter[1].Guid.Data2 = 0xad66;
      EncoderParameters->Parameter[1].Guid.Data3 = 0x4c7c;
      EncoderParameters->Parameter[1].Guid.Data4[0] = 0x9a;
      EncoderParameters->Parameter[1].Guid.Data4[1] = 0x18;
      EncoderParameters->Parameter[1].Guid.Data4[2] = 0x38;
      EncoderParameters->Parameter[1].Guid.Data4[3] = 0xa2;
      EncoderParameters->Parameter[1].Guid.Data4[4] = 0x31;
      EncoderParameters->Parameter[1].Guid.Data4[5] = 0x0b;
      EncoderParameters->Parameter[1].Guid.Data4[6] = 0x83;
      EncoderParameters->Parameter[1].Guid.Data4[7] = 0x37;
      EncoderParameters->Parameter[1].NumberOfValues = 1;
      EncoderParameters->Parameter[1].Type = 4;
      EncoderParameters->Parameter[1].Value = (void*) &ColorDepth;

      // Save
      if( GdipSaveImageToFile( GBitmap, WFileName, &Clsid, EncoderParameters ) != 0 )
      {
         GdipDisposeImage( GBitmap );
         LocalFree( WFileName );
         hb_xfree( EncoderParameters );
         // Save Operation Error
         return FALSE;
      }
      hb_xfree( EncoderParameters );
   }
   else
   {
      // Other formats do not support parameters

      // Save
      if( GdipSaveImageToFile( GBitmap, WFileName, &Clsid, NULL ) != 0 )
      {
         GdipDisposeImage( GBitmap );
         LocalFree( WFileName );
         // Save Operation Error
         return FALSE;
      }
   }

   GdipDisposeImage( GBitmap );
   LocalFree( WFileName );

   return TRUE;
}

BOOL GetEnCodecClsid( const char *MimeType, CLSID *Clsid )
{
   UINT num  = 0;
   UINT size = 0;
   IMAGE_CODEC_INFO *ImageCodecInfo;
   UINT CodecIndex;
   char *RecvMimeType;
   BOOL OkSearchCodec = FALSE;

   hb_xmemset( Clsid, 0, sizeof( CLSID ) );

   if( ( MimeType == NULL ) || ( Clsid == NULL ) || ( GdiPlusHandle == NULL ) )
      return FALSE;

   if( GdipGetImageEncodersSize( &num, &size ) )
      return FALSE;

   if( ( ImageCodecInfo = hb_xalloc( size ) ) == NULL )
      return FALSE;

   hb_xmemset( ImageCodecInfo, 0, sizeof( IMAGE_CODEC_INFO ) );

   if( GdipGetImageEncoders( num, size, ImageCodecInfo ) || ( ImageCodecInfo == NULL ) )
   {
      hb_xfree( ImageCodecInfo );

      return FALSE;
   }

   if( ( RecvMimeType = LocalAlloc( LPTR, size ) ) == NULL )
   {
      hb_xfree( ImageCodecInfo );

      return FALSE;
   }

   for( CodecIndex = 0; CodecIndex < num; ++CodecIndex )
   {
      WideCharToMultiByte( CP_ACP, 0, ImageCodecInfo[CodecIndex].MimeType, -1, RecvMimeType, size, NULL, NULL );

      if( strcmp( MimeType, RecvMimeType ) == 0 )
      {
         OkSearchCodec = TRUE;
         break;
      }
   }

   if( OkSearchCodec )
      CopyMemory( Clsid, &ImageCodecInfo[CodecIndex].Clsid, sizeof( CLSID ) );

   hb_xfree( ImageCodecInfo );
   LocalFree( RecvMimeType );

   return ( OkSearchCodec ? TRUE : FALSE );
}

/*
Load an image from a file
*/
HB_FUNC( GPLUSLOADIMAGEFROMFILE )
{
   gPlusImage gImage;

   if( LoadImageFromFile( hb_parc( 1 ), &gImage ) == 0 )
      hb_retgPlusImage( gImage );
   else
      hb_ret();
}

LONG LoadImageFromFile( const char *FileName, gPlusImagePtr gImage )
{
   LPWSTR WFileName;
   LONG result;

   WFileName = LocalAlloc( LPTR, ( strlen( FileName ) * sizeof( WCHAR ) ) + 1 );
   if( WFileName == NULL )
     return -1L;

   MultiByteToWideChar( CP_ACP, 0, FileName, -1, WFileName, ( strlen( FileName ) * sizeof( WCHAR ) ) - 1 );

   result = GdipLoadImageFromFile( WFileName, gImage );

   LocalFree( WFileName );

   return result;
}

HB_FUNC( GPLUSLOADIMAGEFROMBUFFER )
{
   gPlusImage gImage;
   IStream *iStream;
   HGLOBAL hGlobal;
   int iSize;

   hGlobal = 0;

   iSize = hb_parclen( 1 );
   if( iSize )
   {
      hGlobal = GlobalAlloc( GPTR, iSize );
   }
   if( hGlobal )
   {
      gImage = 0;
      memset( hGlobal, 0, iSize );
      memcpy( hGlobal, hb_parc( 1 ), iSize );
      CreateStreamOnHGlobal( hGlobal, FALSE, &iStream );
      GdipLoadImageFromStream( iStream, &gImage );
      iStream->lpVtbl->Release( iStream );
      GlobalFree( hGlobal );
   }

   if( gImage )
   {
      hb_retgPlusImage( gImage );
   }
   else
   {
      hb_ret();
   }
}

/*
Image size
*/
HB_FUNC( GPLUSGETIMAGEWIDTH )
{
   gPlusImage image;
   UINT width = 0;

   image = hb_pargPlusImage( 1 );
   if ( image == NULL )
   {
      hb_retni( -1 );
      return;
   }
   GdipGetImageWidth( image, &width );

   hb_retni( width );
}

HB_FUNC( GPLUSGETIMAGEHEIGHT )
{
   gPlusImage image;
   UINT height = 0;

   image = hb_pargPlusImage( 1 );
   if ( image == NULL )
   {
      hb_retni( -1 );
      return;
   }
   GdipGetImageHeight( image, &height );

   hb_retni( height );
}

HB_FUNC( GPLUSDISPOSEIMAGE )
{
   gPlusImage image;

   image = hb_pargPlusImage( 1 );
   if( image )
   {
      GdipDisposeImage( image );
   }
}

BOOL GDIP_IsInit( void )
{
   return GDIP_InitOK;
}

static int _OOHG_GdiPlus = 2;

HB_FUNC( _OOHG_SETGDIP )
{
   int iNewStatus;

   if( HB_ISNUM( 1 ) )
   {
      iNewStatus = hb_parni( 1 );
      if( iNewStatus >= 0 && iNewStatus <= 2 )
      {
         _OOHG_GdiPlus = iNewStatus;
      }
   }
   else if( HB_ISLOG( 1 ) )
   {
      _OOHG_GdiPlus = hb_parl( 1 ) ? 1 : 0;
   }

   if( _OOHG_GdiPlus == 0 )
   {
      InitDeinitGdiPlus( FALSE );
   }
   else if( _OOHG_GdiPlus == 1 )
   {
      InitDeinitGdiPlus( TRUE );
   }

   hb_retni( _OOHG_GdiPlus );
}

BOOL _OOHG_UseGDIP( void )
{
   BOOL bRet = FALSE;

   if( _OOHG_GdiPlus == 1 || _OOHG_GdiPlus == 2 )
   {
      bRet = InitDeinitGdiPlus( TRUE );
   }

   return bRet;
}

HB_FUNC( _OOHG_USEGDIP )
{
   hb_retl( _OOHG_UseGDIP() );
}

HANDLE _OOHG_GDIPLoadPicture( HGLOBAL hGlobal, HWND hWnd, LONG lBackColor, long lWidth2, long lHeight2, BOOL bIgnoreBkClr )
{
   HBITMAP hImage = 0, hOldImage;
   IStream * iStream;
   gPlusImage gImage;
   UINT uiWidth, uiHeight;

   // Creates Stream
   CreateStreamOnHGlobal( hGlobal, FALSE, &iStream );

   // Creates Gdi+ image
   if( GdipCreateBitmapFromStream( iStream, &gImage ) != 0 )
   {
      iStream->lpVtbl->Release( iStream );
      return 0;
   }
   iStream->lpVtbl->Release( iStream );
   GdipGetImageWidth(  gImage, ( UINT * ) &uiWidth );
   GdipGetImageHeight( gImage, ( UINT * ) &uiHeight );

   // Back color
   if( bIgnoreBkClr )
   {
      lBackColor = 0;
   }
   else
   {
      if( lBackColor == -1 )
      {
         lBackColor = GetSysColor( COLOR_BTNFACE );
      }
   }

   // Creates HBITMAP
   if( GdipCreateHBITMAPFromBitmap( gImage, &hImage, COLORREFtoARGB( lBackColor ) ) != 0 )
   {
      hImage = 0;
   }

   // Release Gdi+ image
   GdipDisposeImage( gImage );

   if( hImage )
   {
      // Resize image
      if( lWidth2 && lHeight2 )
      {
         // GetClientRect( hWnd, &rect );
         // lWidth2 = rect.right;
         // lHeight2 = rect.bottom;
      }
      else
      {
         // Takes "real" image size
         lWidth2  = uiWidth;
         lHeight2 = uiHeight;
      }

      if( lWidth2 != ( long ) uiWidth || lHeight2 != ( long ) uiHeight )
      {
         hOldImage = hImage;
         hImage = _OOHG_ScaleImage( hWnd, hOldImage, lWidth2, lHeight2, FALSE, lBackColor, bIgnoreBkClr, 0, 0 );
         DeleteObject( hOldImage );
      }

   }

   return ( HANDLE ) hImage;
}
