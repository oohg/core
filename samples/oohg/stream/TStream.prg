/*
 * $Id: TStream.prg,v 1.6 2015-12-08 06:01:18 guerra000 Exp $
 */
/*
 * Data stream management class.
 *
 * TStreamBase. It "reads" data from a memory buffer.
 *              It's also "core" base class.
 * TStreamFile. Reads data from a file.
 *              For read from STDIN, you must use "handle" 1.
 */

#include "hbclass.ch"

CLASS TStreamBase
   DATA pBuffer      INIT nil    // Pointer to buffer
   DATA nLen         INIT 0      // Bytes in buffer
   DATA nMax         INIT 1024   // Buffer size
   DATA nMinToFill   INIT 0      // Fills buffer when there're less bytes
   DATA lAutoFill    INIT .T.    // Automatic fill buffer at ::Read()
   DATA nPosition    INIT 0      // Bytes already read
   DATA Cargo        INIT nil    // Dummy...

   METHOD Read          // Read buffer
   METHOD Remove        // Remove some bytes from buffer
   METHOD Fill          // Fill buffer
   METHOD Len           // Length of buffer
   METHOD Left          // Beginning of buffer
   METHOD Right         // End of buffer
   METHOD SubStr        // Internal part of buffer
   METHOD Clear         // Clear buffer
   METHOD Skip          // Skip bytes
   METHOD ReSize        // Resize buffer
   METHOD Close         // Close buffer
   METHOD IsActive      // Check if stream is still active
   METHOD Append        // Appends data to buffer
   DESTRUCTOR Destroy

   // Text-line functionality
   DATA   lLf           INIT .F.   // CR found... waiting for LF
   DATA   nLineLenght   INIT 0     // Lenght of line
   DATA   lWordWrap     INIT .F.   // *******
   DATA   nLine         INIT 0     // Line count
   METHOD IsLine        // Is any line on buffer
   METHOD GetLine       // Reads a text line from buffer
   METHOD CutLineAt     // Where next line begins

   // Write functionality
   METHOD WriteBuffer
   DATA   cDataToWrite  INIT ""
   DATA   lCloseAtEnd   INIT .F.
   METHOD CloseAtEnd
   // ****** These methods can change each subclass
   METHOD CanWrite      SETGET
   METHOD CanWaitForBuffer INLINE .F.

   // Changed each subclass
   METHOD New           // New stream
   METHOD IsConnected   // Check if stream is connected
   METHOD RealFill      // Real filler
   METHOD Disconnect    // Disconnect
   METHOD Write         INLINE 0
ENDCLASS

METHOD New( cBuffer ) CLASS TStreamBase
LOCAL nLen
   IF VALTYPE( cBuffer ) $ "CM" .AND. LEN( cBuffer ) > 0
      nLen := LEN( cBuffer )
      IF ::nMax < nLen
         ::nMax := nLen
      ENDIF
      ::ReSize( ::nMax )
      Stream_Insert( ::pBuffer, cBuffer, 1, nLen )
      ::nLen := nLen
   ELSE
      IF ::nMax < 1
         ::nMax := 1
      ENDIF
      ::ReSize( ::nMax )
   ENDIF
RETURN Self

METHOD Read( nBytes ) CLASS TStreamBase
LOCAL cBuffer
   IF ! EMPTY( ::pBuffer )
      IF ::lAutoFill .OR. ( ::nMinToFill > 0 .AND. ::nLen < ::nMinToFill )
         ::Fill()
      ENDIF
      IF ! HB_ISNUMERIC( nBytes )
         nBytes := ::nLen
      ENDIF
      nBytes := MIN( MAX( nBytes, 0 ), ::nLen )
      cBuffer := ::Left( nBytes )
      ::Remove( nBytes, 1 )
   ELSE
      cBuffer := ""
   ENDIF
RETURN cBuffer

METHOD Remove( nCount, nPosition ) CLASS TStreamBase
   IF ! EMPTY( ::pBuffer )
      IF ! HB_ISNUMERIC( nPosition )
         nPosition := 1
      ELSE
         nPosition := MAX( nPosition, 1 )
      ENDIF
      IF nPosition <= ::nLen
         IF ! HB_ISNUMERIC( nCount )
            nCount := ::nLen - nPosition + 1
         ELSE
            nCount := MIN( nCount, ::nLen - nPosition + 1 )
         ENDIF
         IF nCount > 0
            Stream_Remove( ::pBuffer, ::nLen, nPosition, nCount )
            ::nLen := ::nLen - nCount
            ::nPosition += nCount
         ENDIF
      ENDIF
   ENDIF
RETURN nil

METHOD Fill() CLASS TStreamBase
LOCAL nRead
   IF ! EMPTY( ::pBuffer ) .AND. ::IsConnected()
      IF ::nLen < ::nMax
         nRead = ::RealFill( ::pBuffer, ::nLen + 1, ::nMax - ::nLen )
         IF nRead > 0
            ::nLen += nRead
         ELSEIF nRead < 0
            ::Disconnect()
         ENDIF
      ENDIF
   ENDIF
RETURN nil

METHOD Len() CLASS TStreamBase
   IF ::lAutoFill .OR. ( ::nMinToFill > 0 .AND. ::nLen < ::nMinToFill )
      ::Fill()
   ENDIF
RETURN IIF( ! EMPTY( ::pBuffer ), ::nLen, 0 )

METHOD Left( nCount ) CLASS TStreamBase
LOCAL cBuffer
   IF ! EMPTY( ::pBuffer )
      IF ::lAutoFill .OR. ( ::nMinToFill > 0 .AND. ::nLen < ::nMinToFill )
         ::Fill()
      ENDIF
      IF ! HB_ISNUMERIC( nCount )
         nCount := ::nLen
      ENDIF
      nCount := MIN( MAX( nCount, 0 ), ::nLen )
      cBuffer := Stream_SubStr( ::pBuffer, 1, nCount )
   ELSE
      cBuffer := ""
   ENDIF
RETURN cBuffer

METHOD Right( nCount ) CLASS TStreamBase
LOCAL cBuffer
   IF ! EMPTY( ::pBuffer )
      IF ::lAutoFill .OR. ( ::nMinToFill > 0 .AND. ::nLen < ::nMinToFill )
         ::Fill()
      ENDIF
      IF ! HB_ISNUMERIC( nCount )
         nCount := ::nLen
      ENDIF
      nCount := MIN( MAX( nCount, 0 ), ::nLen )
      cBuffer := Stream_SubStr( ::pBuffer, ::nLen - nCount + 1, nCount )
   ELSE
      cBuffer := ""
   ENDIF
RETURN cBuffer

METHOD SubStr( nPos, nCount ) CLASS TStreamBase
LOCAL cBuffer
   IF ! EMPTY( ::pBuffer )
      IF ::lAutoFill .OR. ( ::nMinToFill > 0 .AND. ::nLen < ::nMinToFill )
         ::Fill()
      ENDIF
      IF ! HB_ISNUMERIC( nPos )
         nPos := 1
      ENDIF
      nPos := MIN( MAX( nPos, 1 ), ::nLen + 1 )
      IF ! HB_ISNUMERIC( nCount )
         nCount := ::nLen
      ENDIF
      nCount := MAX( MIN( nCount, ::nLen - nPos + 1 ), 0 )
      cBuffer := Stream_SubStr( ::pBuffer, nPos, nCount )
   ELSE
      cBuffer := ""
   ENDIF
RETURN cBuffer

METHOD Clear() CLASS TStreamBase
   ::nPosition += ::nLen
   ::nLen := 0
RETURN nil

METHOD Skip( nCount ) CLASS TStreamBase
   IF ! HB_IsNumeric( nCount ) .OR. nCount < 0
      nCount := 0
   ENDIF
   IF nCount == 0 .AND. ( ::lAutoFill .OR. ( ::nMinToFill > 0 .AND. ::nLen < ::nMinToFill ) )
      ::Fill()
   ENDIF
   DO WHILE nCount > 0 .AND. ::IsActive()
      IF ::nLen >= nCount
         ::Remove( nCount )
         nCount := 0
      ELSE
         nCount -= ::nLen
         ::Remove( ::nLen )
      ENDIF
      IF nCount > 0 .OR. ::lAutoFill .OR. ( ::nMinToFill > 0 .AND. ::nLen < ::nMinToFill )
         ::Fill()
      ENDIF
   ENDDO
RETURN nil

METHOD ReSize( nSize ) CLASS TStreamBase
   IF ! HB_ISNUMERIC( nSize )
      nSize := 1
   ENDIF
   nSize := MAX( nSize, 1 )
   IF EMPTY( ::pBuffer ) .OR. ::nLen != nSize
      ::pBuffer := Stream_ReSize( ::pBuffer, nSize )
   ENDIF
   IF ! EMPTY( ::pBuffer )
      IF ::nLen > nSize
         ::nPosition += ( ::nLen - nSize )
         ::nLen := nSize
      ENDIF
   ELSE
      ::nLen := 0
   ENDIF
   ::nMax := nSize
RETURN nil

METHOD Close() CLASS TStreamBase
   ::Disconnect()
   IF ! EMPTY( ::pBuffer )
      Stream_Release( ::pBuffer )
      ::pBuffer := NIL
   ENDIF
   ::nLen := 0
   ::nPosition := 0
RETURN nil

METHOD IsActive() CLASS TStreamBase
RETURN ( ! EMPTY( ::pBuffer ) .AND. ( ::nLen > 0 .OR. ::IsConnected() ) )

METHOD IsConnected() CLASS TStreamBase
RETURN .F.

METHOD Append( cBuffer ) CLASS TStreamBase
LOCAL nBytes := 0
   IF HB_IsString( cBuffer ) .AND. LEN( cBuffer ) > 0
      IF ! EMPTY( ::pBuffer ) .AND. ::IsConnected()
         IF ::nLen < ::nMax
            nBytes := MIN( LEN( cBuffer ), ::nMax - ::nLen )
            Stream_Insert( ::pBuffer, cBuffer, ::nLen + 1, nBytes )
            ::nLen += nBytes
         ENDIF
      ENDIF
   ENDIF
RETURN nBytes

PROCEDURE Destroy() CLASS TStreamBase
   ::Close()
RETURN

METHOD IsLine() CLASS TStreamBase
LOCAL lIsLine := .F.
   IF ! EMPTY( ::pBuffer )
      IF ::lAutoFill .OR. ( ::nMinToFill > 0 .AND. ::nLen < ::nMinToFill )
         ::Fill()
      ENDIF
      IF ::nLen > 0 .AND. ::lLf
         IF ::Left( 1 ) == CHR( 10 )
            ::Remove( 1, 1 )
         ENDIF
         ::lLf := .F.
      ENDIF
      IF ::nLen > 0
         lIsLine := ( ::CutLineAt() > 0 )
      ENDIF
   ENDIF
RETURN lIsLine

METHOD GetLine() CLASS TStreamBase
LOCAL cBuffer := "", nPos
   IF ! EMPTY( ::pBuffer )
      IF ::lAutoFill .OR. ( ::nMinToFill > 0 .AND. ::nLen < ::nMinToFill )
         ::Fill()
      ENDIF
      IF ::nLen > 0 .AND. ::lLf
         IF ::Left( 1 ) == CHR( 10 )
            ::Remove( 1, 1 )
         ENDIF
         ::lLf := .F.
      ENDIF
      IF ::nLen > 0
         nPos := ::CutLineAt()
         IF nPos > 0
            ::nLine++
            IF ::lWordWrap .AND. nPos > 1 .AND. ::SubStr( nPos - 1, 1 ) == " "
               cBuffer := ::Left( nPos - 2 )
            ELSE
               cBuffer := ::Left( nPos - 1 )
            ENDIF
            IF nPos <= ::nLen .AND. ::SubStr( nPos, 1 ) $ CHR( 13 ) + CHR( 10 ) + CHR( 0 )
               IF ::SubStr( nPos, 1 ) == CHR( 13 )
                  IF nPos == ::nLen
                     ::lLf := .T.
                  ELSEIF ::SubStr( nPos + 1, 1 ) == CHR( 10 )
                     nPos++
                  ENDIF
               ENDIF
               ::Remove( nPos, 1 )
            ELSE
               ::Remove( nPos - 1, 1 )
            ENDIF
         ENDIF
      ENDIF
   ENDIF
RETURN cBuffer

METHOD CutLineAt() CLASS TStreamBase
LOCAL nPos := 0
   IF ! EMPTY( ::pBuffer ) .AND. ::nLen > 0
      nPos := Stream_CutLineAtB( ::pBuffer, ::nLen, ::IsConnected(), ::nLineLenght, ::lWordWrap )
   ENDIF
RETURN nPos

METHOD RealFill() CLASS TStreamBase
   // Dummy
RETURN nil

METHOD Disconnect() CLASS TStreamBase
   // Dummy
RETURN nil

METHOD WriteBuffer( cData ) CLASS TStreamBase
LOCAL nRet, lRet := .F.
   IF ::IsConnected()
      IF VALTYPE( cData ) $ "CM"
         ::cDataToWrite += cData
      ENDIF
      IF ::CanWrite .AND. LEN( ::cDataToWrite ) > 0
         nRet := ::Write( ::cDataToWrite )
         IF nRet == LEN( ::cDataToWrite )
            ::cDataToWrite := ""
            lRet := .T.
         ELSE
            ::CanWrite := .F.
            IF nRet >= 0
               IF nRet > 0
                  ::cDataToWrite := SUBSTR( ::cDataToWrite, nRet + 1 )
               ENDIF
            ELSEIF ::CanWaitForBuffer()
               //
            ELSE
               ::Disconnect()
            ENDIF
         ENDIF
      ENDIF
      IF LEN( ::cDataToWrite ) == 0 .AND. ::lCloseAtEnd
         ::Close()
      ENDIF
   ENDIF
RETURN lRet

METHOD CanWrite() CLASS TStreamBase
RETURN .F.

METHOD CloseAtEnd( lCloseAtEnd ) CLASS TStreamBase
   IF HB_IsLogical( lCloseAtEnd )
      ::lCloseAtEnd := lCloseAtEnd
      IF LEN( ::cDataToWrite ) == 0 .AND. ::lCloseAtEnd
         ::Close()
      ENDIF
   ENDIF
RETURN ::lCloseAtEnd

#pragma BEGINDUMP

#include <hbapi.h>
#include <windows.h>

HB_FUNC( STREAM_INSERT )   // ( pBuffer, cBuffer, nPos, nLen )
{
   char * pBuffer;

   pBuffer = ( char * ) hb_parptr( 1 );
   if( pBuffer )
   {
      memcpy( pBuffer + hb_parni( 3 ) - 1, hb_parc( 2 ), hb_parni( 4 ) );
   }
}

HB_FUNC( STREAM_REMOVE )   // ( pBuffer, nLen, nPosition, nCount )
{
   char * pBuffer;
   int iPos, iCount;

   pBuffer = ( char * ) hb_parptr( 1 );
   if( pBuffer )
   {
      iPos = hb_parni( 3 ) - 1;
      iCount = hb_parni( 4 );
      memcpy( pBuffer + iPos, pBuffer + iPos + iCount, hb_parni( 2 ) - iPos - iCount );
   }
}

HB_FUNC( STREAM_SUBSTR )   // ( pBuffer, nStart, nCount )
{
   char * pBuffer;

   pBuffer = ( char * ) hb_parptr( 1 );
   if( pBuffer )
   {
      hb_retclen( pBuffer + hb_parni( 2 ) - 1, hb_parni( 3 ) );
   }
   else
   {
      hb_retc( "" );
   }
}

HB_FUNC( STREAM_RESIZE )   // ( pBuffer, nSize )
{
   char * pBuffer;

   pBuffer = ( char * ) hb_parptr( 1 );
   if( pBuffer )
   {
      pBuffer = hb_xrealloc( pBuffer, hb_parni( 2 ) );
   }
   else
   {
      pBuffer = hb_xgrab( hb_parni( 2 ) );
   }

   hb_retptr( pBuffer );
}

HB_FUNC( STREAM_RELEASE )   // ( pBuffer )
{
   char * pBuffer;

   pBuffer = ( char * ) hb_parptr( 1 );
   if( pBuffer )
   {
      hb_xfree( pBuffer );
   }
}

HB_FUNC( STREAM_CUTLINEATB )
{
   char * pBuffer;
   int iLen, iLineLenght, iPos, iRet, iSpace;
   BOOL bConnected, bWordWrap, bSw;

   pBuffer     = hb_parptr( 1 );
   iLen        = hb_parni( 2 );
   bConnected  = hb_parl( 3 );
   iLineLenght = hb_parni( 4 );
   bWordWrap   = hb_parl( 5 );

   iPos = 0;
   bSw = 1;
   iRet = 0;
   iSpace = ( ~0 );
   while( bSw )
   {
      if( iPos == iLen )
      {
         bSw = 0;
         if( ! bConnected )
         {
            iRet = iLen + 1;
         }
      }
      else if( pBuffer[ iPos ] == 13 || pBuffer[ iPos ] == 10 || pBuffer[ iPos ] == 0 )
      {
         iRet = iPos + 1;
         bSw = 0;
      }
      else if( iLineLenght > 0 && iPos == iLineLenght )
      {
         if( bWordWrap )
         {
            if( pBuffer[ iPos ] == 32 )
            {
               iRet = iPos + 2;
            }
            else if( iSpace == ( ~0 ) )
            {
               iRet = iPos + 1;
            }
            else
            {
               iRet = iSpace + 2;
            }
         }
         else
         {
            iRet = iPos + 1;
         }
         bSw = 0;
      }
      else
      {
         if( pBuffer[ iPos ] == 32 )
         {
            iSpace = iPos;
         }
      }
      iPos++;
   }

   hb_retni( iRet );
}

#pragma ENDDUMP

///////////////////////////////////////////////////////////////////////////////////////

CLASS TStreamFile FROM TStreamBase
   DATA nHdl INIT 0

   METHOD New
   METHOD IsConnected
   //
   METHOD RealFill
   METHOD Disconnect
   //
   METHOD Write
   //
   METHOD Skip
ENDCLASS

METHOD New( cFile, nMode, nHdl ) CLASS TStreamFile
   ::Close()
   IF ! HB_IsNumeric( nHdl ) .OR. nHdl <= 0
      ::nHdl := FOpen( cFile, nMode )
   ELSE
      ::nHdl := nHdl
   ENDIF
   IF ::nHdl > 0
      ::ReSize( ::nMax )
   ENDIF
RETURN Self

METHOD IsConnected() CLASS TStreamFile
RETURN ( ::nHdl > 0 )

METHOD RealFill( pBuffer, nPos, nCount ) CLASS TStreamFile
RETURN StreamFile_Read( pBuffer, ::nHdl, nPos, nCount )

METHOD Disconnect() CLASS TStreamFile
   IF ::nHdl > 0
      FClose( ::nHdl )
      ::nHdl := 0
   ENDIF
RETURN ::Super:Disconnect()

METHOD Write( cBuffer ) CLASS TStreamFile
LOCAL nWrite := 0
   IF ::IsConnected()
      IF VALTYPE( cBuffer ) $ "CM" .AND. LEN( cBuffer ) > 0
         nWrite := FWrite( ::nHdl, cBuffer )
         IF nWrite < 0
            ::Disconnect()
         ENDIF
      ENDIF
   ENDIF
RETURN nWrite

METHOD Skip( nCount ) CLASS TStreamFile
LOCAL nCurrent, nSize

   // HACK to access STDIN at 0
   IF ::nHdl == 1
      // NOT A RANDOM ACCESS FILE !!!
      RETURN ::Super:Skip( nCount )
   ENDIF

   IF ! HB_IsNumeric( nCount ) .OR. nCount < 0
      nCount := 0
   ENDIF
   nCount := INT( nCount )
   IF ::nLen >= nCount
      ::Remove( nCount )
      nCount := 0
   ELSE
      nCount := nCount - ::nLen
      ::Remove( ::nLen )
      IF ::IsConnected() .AND. nCount > 0
         nCurrent := FSeek( ::nHdl, 0, 1 )
         nSize := FSeek( ::nHdl, 0, 2 )
         nCount := MIN( nCount, MAX( nSize - nCurrent, 0 ) )
         FSeek( ::nHdl, nCurrent + nCount, 0 )
         ::nPosition := ::nPosition + nCount
      ENDIF
   ENDIF
   IF ::lAutoFill .OR. ( ::nMinToFill > 0 .AND. ::nLen < ::nMinToFill )
      ::Fill()
   ENDIF
RETURN nil

#pragma BEGINDUMP

#include <hbapifs.h>

#ifndef __XHARBOUR__
   #define FHANDLE HB_FHANDLE
#endif

HB_FUNC( STREAMFILE_READ )   // ( pBuffer, nHdl, nStart, nCount )
{
   char * pBuffer;
   FHANDLE iHdl;
   int iRead = 0;

   pBuffer = ( char * ) hb_parptr( 1 );
   iHdl = hb_parni( 2 );
   if( pBuffer && iHdl > 0 )
   {
      // HACK to access STDIN at 0
      if( iHdl == 1 )
      {
         iHdl = 0;
      }

      iRead = hb_fsReadLarge( iHdl, ( BYTE * ) pBuffer + hb_parni( 3 ) - 1, hb_parni( 4 ) );

      if( iRead == 0 )
      {
         // EOF...
         iRead = -1;
      }
   }

   hb_retni( iRead );
}

#pragma ENDDUMP
