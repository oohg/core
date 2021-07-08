/*
 * $Id: c_gdiplus.c $
 */
/*
 * ooHG source code:
 * GDI+ related functions
 *
 * Copyright 2013-2021 Fernando Yurisich <fyurisich@oohg.org> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Based upon:
 * hbGdiPlus library
 * Copyright 2007 P.Chornyj <myorg63@mail.ru>
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2021 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2021 Contributors, https://harbour.github.io/
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


#include "oohg.h"
#include "hbapiitm.h"

typedef void ( __stdcall * DEBUGEVENTPROC )( void *, char * );

typedef int ( __stdcall * GET_THUMBNAIL_IMAGE_ABORT )( void * );

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
   GUID  FormatID;
   const unsigned short * CodecName;
   const unsigned short * DllName;
   const unsigned short * FormatDescription;
   const unsigned short * FilenameExtension;
   const unsigned short * MimeType;
   ULONG Flags;
   ULONG Version;
   ULONG SigCount;
   ULONG SigSize;
   const unsigned char * SigPattern;
   const unsigned char * SigMask;
} IMAGE_CODEC_INFO;

typedef struct
{
   GUID   Guid;
   ULONG  NumberOfValues;
   ULONG  Type;
   void * Value;
} ENCODER_PARAMETER;

typedef struct
{
   UINT Count;
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

#define ARGB( a, r, g, b )     ( (ARGB) ( ( (DWORD) ( a ) << 24 ) | ( (DWORD) ( r ) << 16 ) | ( (DWORD) ( g ) << 8 ) | ( (DWORD) ( b ) ) ) )

#define COLORREFtoARGB( rgb )  ( ARGB( 0xFF, GetRValue( rgb ), GetGValue( rgb ), GetBValue( rgb ) ) )

typedef void * gPlusImage;
typedef gPlusImage * gPlusImagePtr;

typedef long ( __stdcall * GDIPLUSSTARTUP )( ULONG *, const GDIPLUS_STARTUP_INPUT *, void * );
typedef long ( __stdcall * GDIPLUSSHUTDOWN )( ULONG );

typedef long ( __stdcall * GDIPCREATEBITMAPFROMHBITMAP )( void *, void *, void ** );
typedef long ( __stdcall * GDIPGETIMAGEENCODERSSIZE )( UINT *, UINT * );
typedef long ( __stdcall * GDIPGETIMAGEENCODERS )( UINT, UINT, IMAGE_CODEC_INFO * );
typedef long ( __stdcall * GDIPSAVEIMAGETOFILE )( void *, const unsigned short *, const CLSID *, const ENCODER_PARAMETERS * );
typedef long ( __stdcall * GDIPLOADIMAGEFROMSTREAM )( IStream *, void ** );
typedef long ( __stdcall * GDIPCREATEBITMAPFROMSTREAM )( IStream *, void ** );
typedef long ( __stdcall * GDIPCREATEHBITMAPFROMBITMAP )( void *, void *, ARGB );
typedef long ( __stdcall * GDIPDISPOSEIMAGE )( void * );
typedef long ( __stdcall * GDIPGETIMAGETHUMBNAIL )( void *, UINT, UINT, void **, GET_THUMBNAIL_IMAGE_ABORT, void * );

typedef long ( __stdcall * GDIPLOADIMAGEFROMFILE )( const unsigned short *, void ** );
typedef long ( __stdcall * GDIPGETIMAGEWIDTH )( void *, UINT * );
typedef long ( __stdcall * GDIPGETIMAGEHEIGHT )( void *, UINT * );

static gPlusImagePtr hb_pargPlusImage( int );
static BOOL LoadGdiPlusDll( void );

/*
 * Module static vars
 */

static HMODULE GdiPlusHandle = NULL;
static ULONG GdiPlusToken  = 0;
static BOOL GDIP_InitOK = FALSE;
static int _OOHG_GdiPlus = 2;
static unsigned char * MimeTypeOld = NULL;

static GDIPLUS_STARTUP_INPUT       GdiPlusStartupInput;
static GDIPLUSSTARTUP              GdiPlusStartup;
static GDIPLUSSHUTDOWN             GdiPlusShutdown;
static GDIPCREATEBITMAPFROMHBITMAP GdipCreateBitmapFromHBITMAP;
static GDIPGETIMAGEENCODERSSIZE    GdipGetImageEncodersSize;
static GDIPGETIMAGEENCODERS        GdipGetImageEncoders;
static GDIPSAVEIMAGETOFILE         GdipSaveImageToFile;
static GDIPLOADIMAGEFROMSTREAM     GdipLoadImageFromStream;
static GDIPCREATEBITMAPFROMSTREAM  GdipCreateBitmapFromStream;
static GDIPCREATEHBITMAPFROMBITMAP GdipCreateHBITMAPFromBitmap;
static GDIPDISPOSEIMAGE            GdipDisposeImage;
static GDIPGETIMAGETHUMBNAIL       GdipGetImageThumbnail;
static GDIPLOADIMAGEFROMFILE       GdipLoadImageFromFile;
static GDIPGETIMAGEWIDTH           GdipGetImageWidth;
static GDIPGETIMAGEHEIGHT          GdipGetImageHeight;

/*--------------------------------------------------------------------------------------------------------------------------------*/
static HB_GARBAGE_FUNC( hb_gPlusImage_Destructor )
{
   /* Retrieve image pointer holder */
   gPlusImagePtr *imPtr = (gPlusImagePtr *) Cargo;

   /* Check if pointer is not NULL to avoid multiple freeing */
   if( *imPtr )
   {
      GdipDisposeImage( *imPtr );
      *imPtr = NULL;
   }
}

#ifdef __XHARBOUR__

/*--------------------------------------------------------------------------------------------------------------------------------*/
static gPlusImagePtr hb_pargPlusImage( int iParam )
{
   gPlusImagePtr *imPtr = (gPlusImagePtr *) hb_parptrGC( hb_gPlusImage_Destructor, iParam );

   if( imPtr )
      return *imPtr;
   else
      return NULL;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static void hb_retgPlusImage( gPlusImagePtr image )
{
   gPlusImagePtr *imPtr;

   imPtr  = (gPlusImagePtr *) hb_gcAlloc( sizeof( gPlusImagePtr ), hb_gPlusImage_Destructor );
   *imPtr = image;
   hb_retptrGC( (void *) imPtr );
}

#else

/*--------------------------------------------------------------------------------------------------------------------------------*/
static const HB_GC_FUNCS s_gcPlusImageFuncs =
{
   hb_gPlusImage_Destructor,
   hb_gcDummyMark
};

/*--------------------------------------------------------------------------------------------------------------------------------*/
static gPlusImagePtr hb_pargPlusImage( int iParam )
{
   gPlusImagePtr *imPtr = (gPlusImagePtr *) hb_parptrGC( &s_gcPlusImageFuncs, iParam );

   if( imPtr )
      return *imPtr;
   else
      return NULL;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static void hb_retgPlusImage( gPlusImagePtr image )
{
   gPlusImagePtr *imPtr;

   imPtr  = (gPlusImagePtr *) hb_gcAllocate( sizeof( gPlusImagePtr ), &s_gcPlusImageFuncs );
   *imPtr = image;
   hb_retptrGC( (void *) imPtr );
}

#endif

/*
 * Load and unload library
 */

/*--------------------------------------------------------------------------------------------------------------------------------*/
BOOL InitDeinitGdiPlus( BOOL OnOff )
{
   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );

   if( ! OnOff )
   {
      if( ( GdiPlusShutdown != NULL ) && ( GdiPlusToken != 0 ) )
      {
         GdiPlusShutdown( GdiPlusToken );
      }

      if( GdiPlusHandle != NULL )
      {
         FreeLibrary( GdiPlusHandle );
      }

      if( MimeTypeOld != NULL )
      {
         LocalFree( MimeTypeOld );
         MimeTypeOld = NULL;
      }

      GDIP_InitOK   = FALSE;
      GdiPlusToken  = 0;
      GdiPlusHandle = NULL;

      ReleaseMutex( _OOHG_GlobalMutex() );
      return TRUE;
   }

   if( GDIP_InitOK )
   {
      ReleaseMutex( _OOHG_GlobalMutex() );
      return TRUE;
   }

   if( ! LoadGdiPlusDll() )
   {
      ReleaseMutex( _OOHG_GlobalMutex() );
      return FALSE;
   }

   GdiPlusStartupInput.GdiPlusVersion           = 1;
   GdiPlusStartupInput.DebugEventCallback       = NULL;
   GdiPlusStartupInput.SuppressBackgroundThread = FALSE;
   GdiPlusStartupInput.SuppressExternalCodecs   = FALSE;

   if( GdiPlusStartup( &GdiPlusToken, &GdiPlusStartupInput, NULL ) )
   {
      FreeLibrary( GdiPlusHandle );
      GdiPlusHandle = NULL;

      ReleaseMutex( _OOHG_GlobalMutex() );
      return FALSE;
   }

   GDIP_InitOK = TRUE;

   ReleaseMutex( _OOHG_GlobalMutex() );
   return TRUE;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GPLUSINIT )
{
   hb_retl( InitDeinitGdiPlus( TRUE ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GPLUSDEINIT )
{
   hb_retl( InitDeinitGdiPlus( FALSE ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
int ProcGdipLoadImageFromStream( IStream * istream, void ** image )
{
   return (int) GdipLoadImageFromStream( istream, image );
}
/*--------------------------------------------------------------------------------------------------------------------------------*/
int ProcGdipSaveImageToFile( void * gbitmap, const unsigned short * wfilename, const CLSID * clsid, const ENCODER_PARAMETERS * params )
{
   return (int) GdipSaveImageToFile( gbitmap, wfilename, clsid, params );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static BOOL LoadGdiPlusDll( void )
{
   HMODULE GdiPlusHandle_pre;

   if( ( GdiPlusHandle_pre = LoadLibrary( "GDIPLUS.DLL" ) ) == NULL )
      return FALSE;

   if( ( GdiPlusStartup = (GDIPLUSSTARTUP) _OOHG_GetProcAddress( GdiPlusHandle_pre, "GdiplusStartup" ) ) == NULL )
   {
      FreeLibrary( GdiPlusHandle_pre );
      return FALSE;
   }

   if( ( GdiPlusShutdown = (GDIPLUSSHUTDOWN) _OOHG_GetProcAddress( GdiPlusHandle_pre, "GdiplusShutdown" ) ) == NULL )
   {
      FreeLibrary( GdiPlusHandle_pre );
      return FALSE;
   }

   if( ( GdipLoadImageFromStream = (GDIPLOADIMAGEFROMSTREAM) _OOHG_GetProcAddress( GdiPlusHandle_pre, "GdipLoadImageFromStream" ) ) == NULL )
   {
      FreeLibrary( GdiPlusHandle_pre );
      return FALSE;
   }

   if( ( GdipCreateBitmapFromStream = (GDIPCREATEBITMAPFROMSTREAM) _OOHG_GetProcAddress( GdiPlusHandle_pre, "GdipCreateBitmapFromStream" ) ) == NULL )
   {
      FreeLibrary( GdiPlusHandle_pre );
      return FALSE;
   }

   if( ( GdipCreateHBITMAPFromBitmap = (GDIPCREATEHBITMAPFROMBITMAP) _OOHG_GetProcAddress( GdiPlusHandle_pre, "GdipCreateHBITMAPFromBitmap" ) ) == NULL )
   {
      FreeLibrary( GdiPlusHandle_pre );
      return FALSE;
   }

   if( ( GdipCreateBitmapFromHBITMAP = (GDIPCREATEBITMAPFROMHBITMAP) _OOHG_GetProcAddress( GdiPlusHandle_pre, "GdipCreateBitmapFromHBITMAP" ) ) == NULL )
   {
      FreeLibrary( GdiPlusHandle_pre );
      return FALSE;
   }

   if( ( GdipGetImageEncodersSize = (GDIPGETIMAGEENCODERSSIZE) _OOHG_GetProcAddress( GdiPlusHandle_pre, "GdipGetImageEncodersSize" ) ) == NULL )
   {
      FreeLibrary( GdiPlusHandle_pre );
      return FALSE;
   }

   if( ( GdipGetImageEncoders = (GDIPGETIMAGEENCODERS) _OOHG_GetProcAddress( GdiPlusHandle_pre, "GdipGetImageEncoders" ) ) == NULL )
   {
      FreeLibrary( GdiPlusHandle_pre );
      return FALSE;
   }

   if( ( GdipSaveImageToFile = (GDIPSAVEIMAGETOFILE) _OOHG_GetProcAddress( GdiPlusHandle_pre, "GdipSaveImageToFile" ) ) == NULL )
   {
      FreeLibrary( GdiPlusHandle_pre );
      return FALSE;
   }

   if( ( GdipDisposeImage = (GDIPDISPOSEIMAGE) _OOHG_GetProcAddress( GdiPlusHandle_pre, "GdipDisposeImage" ) ) == NULL )
   {
      FreeLibrary( GdiPlusHandle_pre );
      return FALSE;
   }

   if( ( GdipGetImageThumbnail = (GDIPGETIMAGETHUMBNAIL) _OOHG_GetProcAddress( GdiPlusHandle_pre, "GdipGetImageThumbnail" ) ) == NULL )
   {
      FreeLibrary( GdiPlusHandle_pre );
      return FALSE;
   }

   if( ( GdipLoadImageFromFile = (GDIPLOADIMAGEFROMFILE) _OOHG_GetProcAddress( GdiPlusHandle_pre, "GdipLoadImageFromFile" ) ) == NULL )
   {
      FreeLibrary( GdiPlusHandle_pre );
      return FALSE;
   }

   if( ( GdipGetImageWidth = (GDIPGETIMAGEWIDTH) _OOHG_GetProcAddress( GdiPlusHandle_pre, "GdipGetImageWidth" ) ) == NULL )
   {
      FreeLibrary( GdiPlusHandle_pre );
      return FALSE;
   }

   if( ( GdipGetImageHeight = (GDIPGETIMAGEHEIGHT) _OOHG_GetProcAddress( GdiPlusHandle_pre, "GdipGetImageHeight" ) ) == NULL )
   {
      FreeLibrary( GdiPlusHandle_pre );
      return FALSE;
   }

   GdiPlusHandle = GdiPlusHandle_pre;

   return TRUE;
}

/*
 * Encoders (mime types)
 */

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GPLUSGETENCODERSNUM )
{
   UINT num  = 0;         /* Number of image encoders */
   UINT size = 0;         /* Size of the image encoders array in bytes */

   GdipGetImageEncodersSize( &num, &size );

   hb_retni( num );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GPLUSGETENCODERSSIZE )
{
   UINT num  = 0;
   UINT size = 0;

   GdipGetImageEncodersSize( &num, &size );

   hb_retni( size );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GPLUSGETENCODERS )
{
   UINT num  = 0;
   UINT size = 0;
   UINT i;
   IMAGE_CODEC_INFO * pImageCodecInfo;
   PHB_ITEM pResult = hb_itemArrayNew( 0 );
   PHB_ITEM pItem;
   char * RecvMimeType;

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
      /* Return an empty array */
      #ifdef __XHARBOUR__
      hb_itemRelease( hb_itemReturn( pResult ) );
      #else
      hb_itemReturnRelease( pResult );
      #endif
   }

   RecvMimeType = (char *) LocalAlloc( LPTR, size );
   if( RecvMimeType == NULL )
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
      WideCharToMultiByte( CP_ACP, 0, pImageCodecInfo[ i ].MimeType, -1, RecvMimeType, size, NULL, NULL );

      pItem = hb_itemPutC( NULL, RecvMimeType );
      hb_arrayAdd( pResult, pItem );
   }

   /* Free resource */
   LocalFree( RecvMimeType );
   hb_xfree( pImageCodecInfo );
   hb_itemRelease( pItem );

   /* Return a result array */
   #ifdef __XHARBOUR__
   hb_itemRelease( hb_itemReturn( pResult ) );
   #else
   hb_itemReturnRelease( pResult );
   #endif
}

/*
 * Save hBitmap to a file
 */

/*--------------------------------------------------------------------------------------------------------------------------------*/
BOOL GetEnCodecClsid( const char * MimeType, CLSID * Clsid )
{
   UINT num  = 0;
   UINT size = 0;
   IMAGE_CODEC_INFO * ImageCodecInfo;
   UINT   CodecIndex;
   char * RecvMimeType;
   BOOL   OkSearchCodec = FALSE;

   hb_xmemset( Clsid, 0, sizeof( CLSID ) );

   if( ( MimeType == NULL ) || ( Clsid == NULL ) || ( GdiPlusHandle == NULL ) )
      return FALSE;

   if( GdipGetImageEncodersSize( &num, &size ) )
      return FALSE;

   if( ( ImageCodecInfo = (IMAGE_CODEC_INFO *) hb_xalloc( size ) ) == NULL )
      return FALSE;

   hb_xmemset( ImageCodecInfo, 0, sizeof( IMAGE_CODEC_INFO ) );

   if( GdipGetImageEncoders( num, size, ImageCodecInfo ) || ( ImageCodecInfo == NULL ) )
   {
      hb_xfree( ImageCodecInfo );

      return FALSE;
   }

   if( ( RecvMimeType = (char *) LocalAlloc( LPTR, size ) ) == NULL )
   {
      hb_xfree( ImageCodecInfo );

      return FALSE;
   }

   for( CodecIndex = 0; CodecIndex < num; ++CodecIndex )
   {
      WideCharToMultiByte( CP_ACP, 0, ImageCodecInfo[ CodecIndex ].MimeType, -1, RecvMimeType, size, NULL, NULL );

      if( strcmp( MimeType, RecvMimeType ) == 0 )
      {
         OkSearchCodec = TRUE;
         break;
      }
   }

   if( OkSearchCodec )
      CopyMemory( Clsid, &ImageCodecInfo[ CodecIndex ].Clsid, sizeof( CLSID ) );

   hb_xfree( ImageCodecInfo );
   LocalFree( RecvMimeType );

   return OkSearchCodec ? TRUE : FALSE;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
BOOL SaveHBitmapToFile( HBITMAP HBitmap, const TCHAR *FileName, UINT Width, UINT Height, TCHAR *MimeType, ULONG JpgQuality, ULONG ColorDepth )
{
   void *       GBitmap;
   void *       GBitmapThumbnail;
   LPWSTR       WFileName;
   static CLSID Clsid;
   ENCODER_PARAMETERS * EncoderParameters;
   ULONG quality;

   if( ( HBitmap == NULL ) || ( FileName == NULL ) || ( MimeType == NULL ) || ( GdiPlusHandle == NULL ) )
   {
      return FALSE;
   }

   if( MimeTypeOld == NULL )
   {
      if( ! GetEnCodecClsid( MimeType, &Clsid ) )
      {
         /* Wrong MimeType */
         return FALSE;
      }

      MimeTypeOld = (unsigned char *) LocalAlloc( LPTR, strlen( MimeType ) + 1 );
      if( MimeTypeOld == NULL )
      {
         /* LocalAlloc Error */
         return FALSE;
      }

      strcpy( (char *) MimeTypeOld, MimeType );
   }
   else
   {
      if( strcmp( (char *) MimeTypeOld, MimeType ) != 0 )
      {
         LocalFree( MimeTypeOld );

         if( ! GetEnCodecClsid( MimeType, &Clsid ) )
         {
            /* Wrong MimeType */
            return FALSE;
         }

         MimeTypeOld = (unsigned char *) LocalAlloc( LPTR, strlen( MimeType ) + 1 );
         if( MimeTypeOld == NULL )
         {
            /* LocalAlloc Error */
            return FALSE;
         }
         strcpy( (char *) MimeTypeOld, MimeType );
      }
   }

   GBitmap = 0;

   if( GdipCreateBitmapFromHBITMAP( HBitmap, NULL, &GBitmap ) )
   {
      /* CreateBitmap Operation Error */
      return FALSE;
   }

   WFileName = (LPWSTR) LocalAlloc( LPTR, ( strlen( FileName ) * sizeof( WCHAR ) ) + 1 );
   if( WFileName == NULL )
   {
      /* WFile LocalAlloc Error */
      return FALSE;
   }

   MultiByteToWideChar( CP_ACP, 0, FileName, -1, WFileName, ( strlen( FileName ) * sizeof( WCHAR ) ) - 1 );

   if( ( Width > 0 ) && ( Height > 0 ) )
   {
      GBitmapThumbnail = NULL;

      if( GdipGetImageThumbnail( GBitmap, Width, Height, &GBitmapThumbnail, NULL, NULL ) )
      {
         /* Thumbnail operation error */
         GdipDisposeImage( GBitmap );
         LocalFree( WFileName );
         return FALSE;
      }

      GdipDisposeImage( GBitmap );
      GBitmap = GBitmapThumbnail;
   }

   /* Build parameters and save */
   if( strcmp( MimeType, "image/jpeg" ) == 0 )
   {
      EncoderParameters = (ENCODER_PARAMETERS *) hb_xgrab( sizeof( ENCODER_PARAMETERS ) + 1 * sizeof( ENCODER_PARAMETER ) );
      ZeroMemory( EncoderParameters, sizeof( ENCODER_PARAMETERS ) + 1 * sizeof( ENCODER_PARAMETER ) );
      EncoderParameters->Count = 1;

      /* Quality: TGUID = 1d5be4b5-fa4a-452d-9cdd-5db35105e7eb
       * Valid values: 0 (greatest compression, low quality) to 100 (least compression, high quality)
       * Defaults to 75.
       */
      if( JpgQuality > 100 )
      {
         JpgQuality = 75;
      }
      EncoderParameters->Parameter[ 0 ].Guid.Data1      = 0x1d5be4b5;
      EncoderParameters->Parameter[ 0 ].Guid.Data2      = 0xfa4a;
      EncoderParameters->Parameter[ 0 ].Guid.Data3      = 0x452d;
      EncoderParameters->Parameter[ 0 ].Guid.Data4[ 0 ] = 0x9c;
      EncoderParameters->Parameter[ 0 ].Guid.Data4[ 1 ] = 0xdd;
      EncoderParameters->Parameter[ 0 ].Guid.Data4[ 2 ] = 0x5d;
      EncoderParameters->Parameter[ 0 ].Guid.Data4[ 3 ] = 0xb3;
      EncoderParameters->Parameter[ 0 ].Guid.Data4[ 4 ] = 0x51;
      EncoderParameters->Parameter[ 0 ].Guid.Data4[ 5 ] = 0x05;
      EncoderParameters->Parameter[ 0 ].Guid.Data4[ 6 ] = 0xe7;
      EncoderParameters->Parameter[ 0 ].Guid.Data4[ 7 ] = 0xeb;
      EncoderParameters->Parameter[ 0 ].NumberOfValues  = 1;
      EncoderParameters->Parameter[ 0 ].Type            = 4;
      EncoderParameters->Parameter[ 0 ].Value           = (void *) &JpgQuality;

      /* Colordepth for JPEG images is always 24 bpp */

      /* Save */
      if( GdipSaveImageToFile( GBitmap, WFileName, &Clsid, EncoderParameters ) != 0 )
      {
         /* Save operation error */
         GdipDisposeImage( GBitmap );
         LocalFree( WFileName );
         hb_xfree( EncoderParameters );
         return FALSE;
      }
      hb_xfree( EncoderParameters );
   }
   else if( strcmp( MimeType, "image/tiff" ) == 0 )
   {
      EncoderParameters = (ENCODER_PARAMETERS *) hb_xgrab( sizeof( ENCODER_PARAMETERS ) + 2 * sizeof( ENCODER_PARAMETER ) );
      ZeroMemory( EncoderParameters, sizeof( ENCODER_PARAMETERS ) + 2 * sizeof( ENCODER_PARAMETER ) );
      EncoderParameters->Count = 2;

      /* Compression: e09d739d-ccd4-44ee-8eba-3fbf8be4fc58 */
      quality = JpgQuality ? EncoderValueCompressionLZW : EncoderValueCompressionNone;
      EncoderParameters->Parameter[ 0 ].Guid.Data1      = 0xe09d739d;
      EncoderParameters->Parameter[ 0 ].Guid.Data2      = 0xccd4;
      EncoderParameters->Parameter[ 0 ].Guid.Data3      = 0x44ee;
      EncoderParameters->Parameter[ 0 ].Guid.Data4[ 0 ] = 0x8e;
      EncoderParameters->Parameter[ 0 ].Guid.Data4[ 1 ] = 0xba;
      EncoderParameters->Parameter[ 0 ].Guid.Data4[ 2 ] = 0x3f;
      EncoderParameters->Parameter[ 0 ].Guid.Data4[ 3 ] = 0xbf;
      EncoderParameters->Parameter[ 0 ].Guid.Data4[ 4 ] = 0x8b;
      EncoderParameters->Parameter[ 0 ].Guid.Data4[ 5 ] = 0xe4;
      EncoderParameters->Parameter[ 0 ].Guid.Data4[ 6 ] = 0xfc;
      EncoderParameters->Parameter[ 0 ].Guid.Data4[ 7 ] = 0x58;
      EncoderParameters->Parameter[ 0 ].NumberOfValues  = 1;
      EncoderParameters->Parameter[ 0 ].Type            = 4;
      EncoderParameters->Parameter[ 0 ].Value           = (void *) &quality;

      /* ColorDepth: 66087055-ad66-4c7c-9a18-38a2310b8337
       * Valid values for TIFF images are 1, 4, 8, 24, 32 bpp
       * Use 24 bpp if you want to include the image in a PDF file using TPDF class
       */
      if( ! ( ( ColorDepth == 1 ) || ( ColorDepth == 4 ) || ( ColorDepth == 8 ) || ( ColorDepth == 24 ) || ( ColorDepth == 32 ) ) )
      {
         ColorDepth = 24;
      }
      EncoderParameters->Parameter[ 1 ].Guid.Data1      = 0x66087055;
      EncoderParameters->Parameter[ 1 ].Guid.Data2      = 0xad66;
      EncoderParameters->Parameter[ 1 ].Guid.Data3      = 0x4c7c;
      EncoderParameters->Parameter[ 1 ].Guid.Data4[ 0 ] = 0x9a;
      EncoderParameters->Parameter[ 1 ].Guid.Data4[ 1 ] = 0x18;
      EncoderParameters->Parameter[ 1 ].Guid.Data4[ 2 ] = 0x38;
      EncoderParameters->Parameter[ 1 ].Guid.Data4[ 3 ] = 0xa2;
      EncoderParameters->Parameter[ 1 ].Guid.Data4[ 4 ] = 0x31;
      EncoderParameters->Parameter[ 1 ].Guid.Data4[ 5 ] = 0x0b;
      EncoderParameters->Parameter[ 1 ].Guid.Data4[ 6 ] = 0x83;
      EncoderParameters->Parameter[ 1 ].Guid.Data4[ 7 ] = 0x37;
      EncoderParameters->Parameter[ 1 ].NumberOfValues  = 1;
      EncoderParameters->Parameter[ 1 ].Type            = 4;
      EncoderParameters->Parameter[ 1 ].Value           = (void *) &ColorDepth;

      /* Save */
      if( GdipSaveImageToFile( GBitmap, WFileName, &Clsid, EncoderParameters ) != 0 )
      {
         /* Save operation error */
         GdipDisposeImage( GBitmap );
         LocalFree( WFileName );
         hb_xfree( EncoderParameters );
         return FALSE;
      }
      hb_xfree( EncoderParameters );
   }
   else
   {
      /* Other formats do not support parameters */

      /* Save */
      if( GdipSaveImageToFile( GBitmap, WFileName, &Clsid, NULL ) != 0 )
      {
         /* Save Operation Error */
         GdipDisposeImage( GBitmap );
         LocalFree( WFileName );
         return FALSE;
      }
   }

   GdipDisposeImage( GBitmap );
   LocalFree( WFileName );

   return TRUE;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GPLUSSAVEHBITMAPTOFILE )
{
   hb_retl( SaveHBitmapToFile( HBITMAPparam( 1 ), hb_parc( 2 ), (UINT) hb_parnl( 3 ), (UINT) hb_parnl( 4 ), HB_UNCONST( hb_parc( 5 ) ), (ULONG) hb_parnl( 6 ), (ULONG) hb_parnl( 7 ) ) );
}

/*
 * Load an image from a file
 */

/*--------------------------------------------------------------------------------------------------------------------------------*/
long LoadImageFromFile( const char * FileName, gPlusImagePtr gImage )
{
   LPWSTR WFileName;
   long result;

   WFileName = (LPWSTR) LocalAlloc( LPTR, ( strlen( FileName ) * sizeof( WCHAR ) ) + 1 );
   if( WFileName == NULL )
      return -1L;

   MultiByteToWideChar( CP_ACP, 0, FileName, -1, WFileName, ( strlen( FileName ) * sizeof( WCHAR ) ) - 1 );

   result = GdipLoadImageFromFile( WFileName, gImage );

   LocalFree( WFileName );

   return result;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GPLUSLOADIMAGEFROMFILE )
{
   gPlusImage gImage;

   if( LoadImageFromFile( hb_parc( 1 ), &gImage ) == 0 )
      hb_retgPlusImage( (gPlusImagePtr) gImage );
   else
      hb_ret();
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GPLUSLOADIMAGEFROMBUFFER )
{
   gPlusImage gImage = 0;
   IStream *  iStream;
   HGLOBAL    hGlobal;
   int        iSize;

   hGlobal = 0;

   iSize = hb_parclen( 1 );
   if( iSize )
   {
      hGlobal = GlobalAlloc( GPTR, iSize );
   }
   if( hGlobal )
   {
      memset( hGlobal, 0, iSize );
      memcpy( hGlobal, hb_parc( 1 ), iSize );
      CreateStreamOnHGlobal( hGlobal, FALSE, &iStream );
      GdipLoadImageFromStream( iStream, &gImage );
      iStream->lpVtbl->Release( iStream );
      GlobalFree( hGlobal );
   }

   if( gImage )
   {
      hb_retgPlusImage( &gImage );
   }
   else
   {
      hb_ret();
   }
}

/*
 * Image size
 */

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GPLUSGETIMAGEWIDTH )
{
   gPlusImage image;
   UINT       width = 0;

   image = hb_pargPlusImage( 1 );
   if( image == NULL )
   {
      hb_retni( -1 );
      return;
   }
   GdipGetImageWidth( image, &width );

   hb_retni( width );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GPLUSGETIMAGEHEIGHT )
{
   gPlusImage image;
   UINT       height = 0;

   image = hb_pargPlusImage( 1 );
   if( image == NULL )
   {
      hb_retni( -1 );
      return;
   }
   GdipGetImageHeight( image, &height );

   hb_retni( height );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GPLUSDISPOSEIMAGE )
{
   gPlusImage image;

   image = hb_pargPlusImage( 1 );
   if( image )
   {
      GdipDisposeImage( image );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
BOOL GDIP_IsInit( void )
{
   BOOL bRet;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   bRet = GDIP_InitOK;
   ReleaseMutex( _OOHG_GlobalMutex() );
   return bRet;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
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

/*--------------------------------------------------------------------------------------------------------------------------------*/
BOOL _OOHG_UseGDIP( void )
{
   BOOL bRet = FALSE;

   if( _OOHG_GdiPlus == 1 || _OOHG_GdiPlus == 2 )
   {
      bRet = InitDeinitGdiPlus( TRUE );
   }

   return bRet;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_USEGDIP )
{
   hb_retl( _OOHG_UseGDIP() );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HANDLE _OOHG_GDIPLoadPicture( HGLOBAL hGlobal, HWND hWnd, long lBackColor, long lWidth2, long lHeight2, BOOL bIgnoreBkClr )
{
   HBITMAP    hImage = 0, hOldImage;
   IStream *  iStream;
   gPlusImage gImage;
   UINT       uiWidth, uiHeight;

   /* Creates Stream */
   CreateStreamOnHGlobal( hGlobal, FALSE, &iStream );

   /* Creates GDI+ image */
   if( GdipCreateBitmapFromStream( iStream, &gImage ) != 0 )
   {
      iStream->lpVtbl->Release( iStream );
      return 0;
   }
   iStream->lpVtbl->Release( iStream );
   GdipGetImageWidth(  gImage, (UINT *) &uiWidth );
   GdipGetImageHeight( gImage, (UINT *) &uiHeight );

   /* BackColor */
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

   /* Creates HBITMAP */
   if( GdipCreateHBITMAPFromBitmap( gImage, &hImage, COLORREFtoARGB( lBackColor ) ) != 0 )
   {
      hImage = 0;
   }

   /* Release GDI+ image */
   GdipDisposeImage( gImage );

   if( hImage )
   {
      /* Resize image */
      if( lWidth2 && lHeight2 )
      {
         /* GetClientRect( hWnd, &rect );
          * lWidth2 = rect.right;
          * lHeight2 = rect.bottom;
          */
      }
      else
      {
         /* Takes "real" image size */
         lWidth2  = uiWidth;
         lHeight2 = uiHeight;
      }

      if( lWidth2 != (long) uiWidth || lHeight2 != (long) uiHeight )
      {
         hOldImage = hImage;
         hImage    = _OOHG_ScaleImage( hWnd, hOldImage, lWidth2, lHeight2, FALSE, lBackColor, bIgnoreBkClr, 0, 0 );
         DeleteObject( hOldImage );
      }
   }

   return (HANDLE) hImage;
}
