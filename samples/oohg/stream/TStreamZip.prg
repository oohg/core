/*
 * $Id: TStreamZip.prg,v 1.1 2011-07-17 14:57:50 guerra000 Exp $
 */
/*
 * Data stream from (((compress/)))uncompress management class.
 * It uses zlib library.
 *
 * TStreamUnZip. Reads compressed data and returns uncompressed.
 */
/* zlib.h -- interface of the 'zlib' general purpose compression library
  version 1.2.3, July 18th, 2005

  Copyright (C) 1995-2005 Jean-loup Gailly and Mark Adler

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.

  Jean-loup Gailly jloup@gzip.org
  Mark Adler madler@alumni.caltech.edu
*/

#include "hbclass.ch"

CLASS TStreamUnZip FROM TStreamBase
   DATA oStream    INIT nil    // Data source
   DATA p_zStream  INIT nil    // Stream-info pointer

   METHOD New           // New stream
   METHOD IsConnected   // Check if stream is connected
   //
   METHOD RealFill      // Real filler
   METHOD Disconnect    // Disconnect
   //
   // METHOD Write         INLINE 0   // No WRITE method.
ENDCLASS

METHOD New( oStream ) CLASS TStreamUnZip
   ::Close()
   IF HB_IsObject( oStream )
      ::p_zStream := TStreamUnZip_InflateInit()
      IF ! EMPTY( ::p_zStream )
         ::oStream := oStream
         ::ReSize( ::nMax )
      ENDIF
   ENDIF
RETURN Self

METHOD IsConnected() CLASS TStreamUnZip
RETURN ( TStreamUnZip_IsPendingBuffer( ::p_zStream ) .OR. ( HB_IsObject( ::oStream ) .AND. ::oStream:IsActive() ) )

METHOD RealFill( pBuffer, nPos, nCount ) CLASS TStreamUnZip
LOCAL nBytes, nBlock
   nBytes := 0
   DO WHILE nCount > 0

      // Takes output buffer
      nBlock := TStreamUnZip_TakeOut( pBuffer, nPos, nCount, ::p_zStream )
      IF nBlock == -1
         IF nBytes == 0
            nBytes := -1
         ENDIF
         nCount := 0
      ELSEIF nBlock > 0
         nBytes += nBlock
         nPos   += nBlock
         nCount -= nBlock
      ENDIF

      IF nCount > 0

         // Fills buffer
         nBlock := TStreamUnZip_BytesToIn( ::p_zStream )
         IF nBlock > 0 .AND. HB_IsObject( ::oStream ) .AND. ::oStream:IsActive()
            ::oStream:Fill()
            nBlock := TStreamUnZip_TakeIn( ::p_zStream, ::oStream:Read( nBlock ) )
            IF nBlock < 0
               IF nBytes == 0
                  nBytes := -1
               ENDIF
               nCount := 0
            ENDIF
         ENDIF
         IF HB_IsObject( ::oStream ) .AND. ! ::oStream:IsActive()
            ::oStream := NIL
         ENDIF

         // Decompress buffer
         nBlock := TStreamUnZip_Inflate( ::p_zStream )
         IF nBlock < 0
            IF nBytes == 0
               nBytes := -1
            ENDIF
            nCount := 0
         ELSEIF nBlock == 0
            IF ! ::IsConnected()
               // EOF
               TStreamUnZip_InflateEnd( ::p_zStream )
               ::p_zStream := NIL
               EXIT
            ENDIF
         ENDIF
      ENDIF
   ENDDO
RETURN nBytes // StreamFile_Read( pBuffer, ::nHdl, nPos, nCount )

METHOD Disconnect() CLASS TStreamUnZip
   IF HB_IsObject( ::oStream )
      ::oStream:Close()
      ::oStream := NIL
   ENDIF
   IF ! EMPTY( ::p_zStream )
      TStreamUnZip_InflateEnd( ::p_zStream )
      ::p_zStream := NIL
   ENDIF
RETURN ::Super:Disconnect()

#pragma BEGINDUMP

#include <hbapi.h>
#include <hbzlib.h>

struct Stream_z_stream {
   z_stream z_stream;
   Bytef *in;
   Bytef *out;
   int iEof;
};

#define STREAM_BLOCK 16384

HB_FUNC( TSTREAMUNZIP_INFLATEINIT )   // ()
{
   struct Stream_z_stream *p_zStream;

   p_zStream = hb_xgrab( sizeof( struct Stream_z_stream ) );
   memset( p_zStream, 0, sizeof( struct Stream_z_stream ) );
   p_zStream->z_stream.next_in  = Z_NULL;
   p_zStream->z_stream.avail_in = 0;
   p_zStream->z_stream.zalloc   = Z_NULL;
   p_zStream->z_stream.zfree    = Z_NULL;
   p_zStream->z_stream.opaque   = Z_NULL;

   if( inflateInit2( ( z_stream * ) p_zStream, - MAX_WBITS ) != Z_OK )
   {
      hb_xfree( p_zStream );
      p_zStream = 0;
   }
   else
   {
      p_zStream->iEof = 0;
      p_zStream->in   = hb_xgrab( STREAM_BLOCK );
      p_zStream->out  = hb_xgrab( STREAM_BLOCK );
      p_zStream->z_stream.next_in   = p_zStream->in;
      p_zStream->z_stream.next_out  = p_zStream->out;
      p_zStream->z_stream.avail_in  = 0;
      p_zStream->z_stream.avail_out = STREAM_BLOCK;
   }

   hb_retptr( p_zStream );
}

HB_FUNC( TSTREAMUNZIP_INFLATEEND )   // ( p_zStream )
{
   struct Stream_z_stream *p_zStream;

   p_zStream = hb_parptr( 1 );
   if( p_zStream )
   {
      inflateEnd( ( z_stream * ) p_zStream );
      if( p_zStream->in )
      {
         hb_xfree( p_zStream->in );
      }
      if( p_zStream->out )
      {
         hb_xfree( p_zStream->out );
      }
      hb_xfree( p_zStream );
   }
}

HB_FUNC( TSTREAMUNZIP_TAKEOUT )   // ( pBuffer, nPos, nCount, p_zStream )
{
   char * pBuffer;
   struct Stream_z_stream *p_zStream;
   int iCount, iRead, iAvailable;

   pBuffer = ( char * ) hb_parptr( 1 );
   iCount = hb_parni( 3 );
   p_zStream = hb_parptr( 4 );
   if( pBuffer && p_zStream )
   {
      iAvailable = STREAM_BLOCK - p_zStream->z_stream.avail_out;
      iRead = ( iAvailable > iCount ) ? iCount : iAvailable;
      if( iRead )
      {
         memcpy( pBuffer + hb_parni( 2 ) - 1, p_zStream->out, iRead );
         memcpy( p_zStream->out, p_zStream->out + iRead, iAvailable - iRead );
         p_zStream->z_stream.avail_out += iRead;
         p_zStream->z_stream.next_out  -= iRead;
      }
   }
   else
   {
      iRead = -1;
   }

   hb_retni( iRead );
}

HB_FUNC( TSTREAMUNZIP_BYTESTOIN )   // ( p_zStream )
{
   struct Stream_z_stream *p_zStream;
   int iSpace;

   p_zStream = hb_parptr( 1 );
   if( p_zStream )
   {
      iSpace = STREAM_BLOCK - p_zStream->z_stream.avail_in;
   }
   else
   {
      iSpace = -1;
   }

   hb_retni( iSpace );
}

HB_FUNC( TSTREAMUNZIP_ISPENDINGBUFFER )   // ( p_zStream )
{
   struct Stream_z_stream *p_zStream;
   int iBuffer;

   p_zStream = hb_parptr( 1 );
   if( p_zStream )
   {
      iBuffer = ( STREAM_BLOCK - p_zStream->z_stream.avail_out ) || ( p_zStream->z_stream.avail_in );
   }
   else
   {
      iBuffer = 0;
   }

   hb_retl( iBuffer );
}

HB_FUNC( TSTREAMUNZIP_TAKEIN )   // ( p_zStream, cBuffer )
{
   struct Stream_z_stream *p_zStream;
   int iLen, iRead, iSpace;

   p_zStream = hb_parptr( 1 );
   if( p_zStream )
   {
      if( p_zStream->iEof )
      {
         iRead = ( STREAM_BLOCK - p_zStream->z_stream.avail_out > 0 ) ? 0 : -1;
      }
      else
      {
         iLen = hb_parclen( 2 );
         iSpace = STREAM_BLOCK - p_zStream->z_stream.avail_in;
         if( iSpace && iLen )
         {
            iRead = ( iSpace > iLen ) ? iLen : iSpace;
            if( p_zStream->in != p_zStream->z_stream.next_in )
            {
               memcpy( p_zStream->in, p_zStream->z_stream.next_in, p_zStream->z_stream.avail_in );
               p_zStream->z_stream.next_in = p_zStream->in;
            }
            memcpy( p_zStream->in + p_zStream->z_stream.avail_in, hb_parc( 2 ), iRead );
            p_zStream->z_stream.avail_in += iRead;
         }
         else
         {
            iRead = 0;
         }
      }
   }
   else
   {
      iRead = -1;
   }

   hb_retni( iRead );
}

HB_FUNC( TSTREAMUNZIP_INFLATE )   // ( p_zStream )
{
   struct Stream_z_stream *p_zStream;
   int iRet;

   p_zStream = hb_parptr( 1 );
   if( p_zStream )
   {
      if( p_zStream->z_stream.avail_in > 0 )
      {
         iRet = inflate( ( z_stream * ) p_zStream, Z_SYNC_FLUSH );
         if( iRet == Z_OK )
         {
            iRet = STREAM_BLOCK - p_zStream->z_stream.avail_out;
         }
         else if( iRet == Z_STREAM_END )
         {
            p_zStream->z_stream.avail_in = 0;
            iRet = STREAM_BLOCK - p_zStream->z_stream.avail_out;
            p_zStream->iEof = 1;
         }
         else
         {
            iRet = -1;
         }
      }
      else
      {
         iRet = STREAM_BLOCK - p_zStream->z_stream.avail_out;
      }
   }
   else
   {
      iRet = -1;
   }

   hb_retni( iRet );
}

#pragma ENDDUMP

FUNCTION Zip_IsHeader( oStream )
LOCAL lRet := .F.
LOCAL cBuffer, nLen
   IF oStream:Left( 4 ) == "PK" + CHR( 3 ) + CHR( 4 ) .AND. oStream:Len() >= 30
      cBuffer := oStream:Left( 30 )
      nLen := ASC( cBuffer[ 27 ] ) + ( ASC( cBuffer[ 28 ] ) * 256 ) + ASC( cBuffer[ 29 ] ) + ( ASC( cBuffer[ 30 ] ) * 256 )
      lRet := ( oStream:Len() >= 30 + nLen )
   ENDIF
RETURN lRet

FUNCTION Zip_GetHeader( oStream )
LOCAL hHeader := NIL
LOCAL cBuffer, nAux
   IF Zip_IsHeader( oStream )
      cBuffer := oStream:Read( 30 )
      hHeader := { => }
      hHeader:FileName   := oStream:Read( ASC( cBuffer[ 27 ] ) + ( ASC( cBuffer[ 28 ] ) * 256 ) )
      IF LEFT( hHeader:FileName, 1 ) == "/" .OR. LEFT( hHeader:FileName, 1 ) == "\"
         hHeader:FileName := SUBSTR( hHeader:FileName, 2 )
      ENDIF
      hHeader:Extra      := oStream:Read( ASC( cBuffer[ 29 ] ) + ( ASC( cBuffer[ 30 ] ) * 256 ) )
      hHeader:Method     := ASC( cBuffer[ 9 ] ) + ( ASC( cBuffer[ 10 ] ) * 256 )
      //
      nAux := ASC( cBuffer[ 11 ] ) + ( ASC( cBuffer[ 12 ] ) * 256 )
      hHeader:Time       := STRZERO( INT( nAux / 2048 ), 2 ) + ":" + STRZERO( INT( nAux / 32 ) % 64, 2 ) + ":" + STRZERO( ( nAux % 32 ) * 2, 2 )
      nAux := ASC( cBuffer[ 13 ] ) + ( ASC( cBuffer[ 14 ] ) * 256 )
      hHeader:Date       := STOD( STRZERO( INT( nAux / 512 ) + 1980, 4 ) + STRZERO( INT( nAux / 32 ) % 16, 2 ) + STRZERO( nAux % 32, 2 ) )
      hHeader:Size       := ASC( cBuffer[ 23 ] ) + ( ASC( cBuffer[ 24 ] ) * 256 ) + ( ASC( cBuffer[ 25 ] ) * 65536 ) + ( ASC( cBuffer[ 26 ] ) * 16777216 )
      hHeader:CompressedSize := ASC( cBuffer[ 19 ] ) + ( ASC( cBuffer[ 20 ] ) * 256 ) + ( ASC( cBuffer[ 21 ] ) * 65536 ) + ( ASC( cBuffer[ 22 ] ) * 16777216 )
      //
      nAux := ASC( cBuffer[ 7 ] ) + ( ASC( cBuffer[ 8 ] ) * 256 )
      hHeader:Encrypted  := ( ( nAux & 0x0001 ) != 0 )
      hHeader:Descriptor := ( ( nAux & 0x0008 ) != 0 )
      hHeader:Patched    := ( ( nAux & 0x0020 ) != 0 )
      hHeader:VersionHi  := ASC( cBuffer[ 5 ] )
      hHeader:VersionLo  := ASC( cBuffer[ 6 ] )
      hHeader:CRC32      := ASC( cBuffer[ 15 ] ) + ( ASC( cBuffer[ 16 ] ) * 256 ) + ( ASC( cBuffer[ 17 ] ) * 65536 ) + ( ASC( cBuffer[ 18 ] ) * 16777216 )
   ENDIF
RETURN hHeader

FUNCTION Zip_IsCentralHeader( oStream )
LOCAL lRet := .F.
LOCAL cBuffer, nLen
   IF oStream:Left( 4 ) == "PK" + CHR( 1 ) + CHR( 2 ) .AND. oStream:Len() >= 46
      cBuffer := oStream:Left( 30 )
      nLen := ASC( cBuffer[ 29 ] ) + ( ASC( cBuffer[ 30 ] ) * 256 ) + ASC( cBuffer[ 31 ] ) + ( ASC( cBuffer[ 32 ] ) * 256 ) + ASC( cBuffer[ 33 ] ) + ( ASC( cBuffer[ 34 ] ) * 256 )
      lRet := ( oStream:Len() >= 46 + nLen )
   ENDIF
RETURN lRet

FUNCTION Zip_GetCentralHeader( oStream )
LOCAL hHeader := NIL
LOCAL cBuffer, nAux
   IF Zip_IsCentralHeader( oStream )
      cBuffer := oStream:Read( 46 )
      hHeader := { => }
      hHeader:FileName   := oStream:Read( ASC( cBuffer[ 29 ] ) + ( ASC( cBuffer[ 30 ] ) * 256 ) )
      IF LEFT( hHeader:FileName, 1 ) == "/" .OR. LEFT( hHeader:FileName, 1 ) == "\"
         hHeader:FileName := SUBSTR( hHeader:FileName, 2 )
      ENDIF
      hHeader:Extra      := oStream:Read( ASC( cBuffer[ 31 ] ) + ( ASC( cBuffer[ 32 ] ) * 256 ) )
      hHeader:Method     := ASC( cBuffer[ 11 ] ) + ( ASC( cBuffer[ 12 ] ) * 256 )
      //
      nAux := ASC( cBuffer[ 13 ] ) + ( ASC( cBuffer[ 14 ] ) * 256 )
      hHeader:Time       := STRZERO( INT( nAux / 2048 ), 2 ) + ":" + STRZERO( INT( nAux / 32 ) % 64, 2 ) + ":" + STRZERO( ( nAux % 32 ) * 2, 2 )
      nAux := ASC( cBuffer[ 15 ] ) + ( ASC( cBuffer[ 16 ] ) * 256 )
      hHeader:Date       := STOD( STRZERO( INT( nAux / 512 ) + 1980, 4 ) + STRZERO( INT( nAux / 32 ) % 16, 2 ) + STRZERO( nAux % 32, 2 ) )
      hHeader:Size       := ASC( cBuffer[ 25 ] ) + ( ASC( cBuffer[ 26 ] ) * 256 ) + ( ASC( cBuffer[ 27 ] ) * 65536 ) + ( ASC( cBuffer[ 28 ] ) * 16777216 )
      hHeader:CompressedSize := ASC( cBuffer[ 21 ] ) + ( ASC( cBuffer[ 22 ] ) * 256 ) + ( ASC( cBuffer[ 23 ] ) * 65536 ) + ( ASC( cBuffer[ 24 ] ) * 16777216 )
      //
      nAux := ASC( cBuffer[ 9 ] ) + ( ASC( cBuffer[ 10 ] ) * 256 )
      hHeader:Encrypted  := ( ( nAux & 0x0001 ) != 0 )
      hHeader:Descriptor := ( ( nAux & 0x0008 ) != 0 )
      hHeader:Patched    := ( ( nAux & 0x0020 ) != 0 )
      hHeader:VersionHi  := ASC( cBuffer[ 7 ] )
      hHeader:VersionLo  := ASC( cBuffer[ 8 ] )
      hHeader:CRC32      := ASC( cBuffer[ 17 ] ) + ( ASC( cBuffer[ 18 ] ) * 256 ) + ( ASC( cBuffer[ 19 ] ) * 65536 ) + ( ASC( cBuffer[ 20 ] ) * 16777216 )
/*
central file header signature   01: 4 bytes  (0x02014b50)
version made by                 05: 2 bytes
disk number start               35: 2 bytes
internal file attributes        37: 2 bytes
external file attributes        39: 4 bytes
relative offset of local header 43: 4 bytes
*/
      hHeader:Comment    := oStream:Read( ASC( cBuffer[ 33 ] ) + ( ASC( cBuffer[ 34 ] ) * 256 ) )
      hHeader:OffsetHeader := ASC( cBuffer[ 43 ] ) + ( ASC( cBuffer[ 44 ] ) * 256 ) + ( ASC( cBuffer[ 45 ] ) * 65536 ) + ( ASC( cBuffer[ 46 ] ) * 16777216 )
   ENDIF
RETURN hHeader
