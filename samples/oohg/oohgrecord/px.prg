/*
 * $Id: px.prg,v 1.15 2014-02-04 21:23:02 guerra000 Exp $
 */
/*
 * This is a ooHGRecord's subclasses (database class used
 * by ooHG's XBrowse) for direct Paradox file access.
 * NOTE: It's a READ ONLY access!!
 */

#ifndef NO_SAMPLE

#include "oohg.ch"

PROCEDURE Main
LOCAL cFile

   SET CENTURY ON
   SET DATE BRITISH

   DO WHILE .T.
      cFile := GetFile( { { "Paradox files", "*.db" } }, "Select file",, .F., .T. )
      IF EMPTY( cFile )
         EXIT
      ENDIF
      BrowsePx( cFile )
   ENDDO

RETURN

PROCEDURE BrowsePx( cFile )
Local oPx, aHeaders, aWidths, aFields, oWnd

   oPx := XBrowse_Paradox():New( cFile, .T. )

   aWidths := AFILL( ARRAY( oPx:nFields ), 100 )
   aFields := ARRAY( oPx:nFields + 1 )
   aFields[ 1 ] := { || oPx:Recno }
   AEVAL( aWidths, { |x,i| aFields[ i + 1 ] := NewFieldGet( oPx, i ) } )
   aHeaders := ARRAY( oPx:nFields + 1 )
   aHeaders[ 1 ] := "recno()"
   AEVAL( aWidths, { |x,i| aHeaders[ i + 1 ] := oPx:aFields[ i ] + "/" + oPx:aTypes[ i ] } )
   AADD( aWidths, 100 )

   DEFINE WINDOW Main WIDTH 500 HEIGHT 400 CLIENTAREA ;
                 TITLE "Paradox Browse Sample" OBJ oWnd
       @ 10,10 XBROWSE Brw WIDTH 480 HEIGHT 380 ;
               WORKAREA ( oPx ) ;
               HEADERS aHeaders ;
               WIDTHS aWidths ;
               FIELDS aFields
       oWnd:Brw:Anchor := "TOPLEFTBOTTOMRIGHT"

   END WINDOW
   ACTIVATE WINDOW Main

   oPx:Close()

RETURN

FUNCTION NewFieldGet( oBase, nPos )
RETURN { || oBase:FieldGet( nPos ) }

#endif   // #ifndef NO_SAMPLE

/*
 *  Pseudo-file class.
 */

#include "hbclass.ch"
#include "fileio.ch"

#pragma BEGINDUMP
#ifdef __XHARBOUR__
#define HB_ULONGLONG ULONGLONG
#endif
#pragma ENDDUMP

*-----------------------------------------------------------------------------*
CLASS XBrowse_PseudoFile
*-----------------------------------------------------------------------------*
   DATA nHdl
   METHOD Open
   METHOD Read
   METHOD Seek
   METHOD Close
   METHOD Write
ENDCLASS

METHOD Open( cFile, lShared, lReadOnly, cExtension ) CLASS XBrowse_PseudoFile
LOCAL nOpen, nHdl, xRet, nPos, nPos2

   // Changes filename's extension
   IF ! EMPTY( cExtension )
      nPos := RAT( ".", cFile )
      nPos2 := MAX( MAX( AT( ":", cFile ) , AT( "\", cFile ) ) , AT( "/", cFile ) )
      IF nPos < nPos2 .OR. nPos == 0
         cFile := cFile + "." + cExtension
      ELSE
         cFile := LEFT( cFile, nPos - 1 ) + "." + cExtension
      ENDIF
   ENDIF

   // Open file
   nOpen := 0
   nOpen += IF( HB_IsLogical( lReadOnly ) .AND. lReadOnly, FO_READ,   FO_READWRITE )
   nOpen += IF( HB_IsLogical( lShared )   .AND. lShared,   FO_SHARED, FO_EXCLUSIVE )
   nHdl := FOPEN( cFile, nOpen )
   IF nHdl > 0
      ::nHdl := nHdl
      xRet := Self
   ELSE
      xRet := Nil
   ENDIF
RETURN xRet

METHOD Read( cBuffer, nBytes ) CLASS XBrowse_PseudoFile
RETURN FREAD( ::nHdl, @cBuffer, nBytes )

METHOD Seek( nPosition, nOrigin ) CLASS XBrowse_PseudoFile
RETURN FSEEK( ::nHdl, nPosition, nOrigin )

METHOD Close() CLASS XBrowse_PseudoFile
   FCLOSE( ::nHdl )
   ::nHdl := 0
RETURN nil

METHOD Write( cBuffer, nBytes ) CLASS XBrowse_PseudoFile
RETURN FWRITE( ::nHdl, cBuffer, nBytes )

/*
 *  This is a template for ooHGRecord's subclasses (database class used
 *  by XBrowse).
 *
 *  It allows to manage files as objects (instead of using directly
 *  low-level file functions). It allows to use virtual files.
 */

*-----------------------------------------------------------------------------*
CLASS XBrowse_DirectFile
*-----------------------------------------------------------------------------*
   // Pseudo-file management
   DATA oFile
   DATA bOpenFile     INIT { |c,l1,l2,e| XBrowse_PseudoFile():Open( c, l1, l2, e ) }
   METHOD OpenFile

   // Table structure
   DATA nFields              INIT 0
   DATA aFields              INIT nil

   // "Skeleton" methods
   METHOD Skipper
   DATA cAlias__             INIT nil
   METHOD Field      BLOCK { | Self, nPos | ::FieldName( nPos ) }
   METHOD FieldName  BLOCK { | Self, nPos | IF( nPos < 1 .OR. nPos > ::nFields, "", UPPER( ::aFields[ nPos ] ) ) }
   METHOD FieldBlock
   METHOD FieldPos
   ERROR HANDLER FieldAssign
ENDCLASS

METHOD OpenFile( cFile, lShared, lReadOnly ) CLASS XBrowse_DirectFile
LOCAL oFile
   oFile := EVAL( ::bOpenFile, cFile, lShared, lReadOnly )
   IF oFile != NIL
      ::oFile := oFile
   ENDIF
RETURN ( oFile != NIL )

METHOD Skipper( nSkip ) CLASS XBrowse_DirectFile
LOCAL nCount
   nCount := 0
   nSkip := IF( VALTYPE( nSkip ) == "N", INT( nSkip ), 1 )
   IF nSkip == 0
      ::Skip( 0 )
   ELSE
      DO WHILE nSkip != 0
         IF nSkip > 0
            ::Skip( 1 )
            IF ::Eof()
               ::Skip( -1 )
               EXIT
            ELSE
               nCount++
               nSkip--
            ENDIF
         ELSE
            ::Skip( -1 )
            IF ::Bof()
               EXIT
            ELSE
               nCount--
               nSkip++
            ENDIF
         ENDIF
      ENDDO
   ENDIF
RETURN nCount

METHOD FieldBlock( cField ) CLASS XBrowse_DirectFile
LOCAL bBlock, nPos
   nPos := ::FieldPos( cField )
   IF nPos > 0
      bBlock := { |_x_| IF( PCOUNT() > 0, ::FieldPut( nPos, _x_ ), ::FieldGet( nPos ) ) }
   ELSE
      bBlock := { || NIL }
   ENDIF
RETURN bBlock

METHOD FieldPos( cField ) CLASS XBrowse_DirectFile
LOCAL cField2
   cField2 := UPPER( ALLTRIM( cField ) )
RETURN ASCAN( ::aFields, { |c| UPPER( c ) == cField2 } )

METHOD FieldAssign( xValue ) CLASS XBrowse_DirectFile
LOCAL nPos, cMessage, uRet, lError
   cMessage := ALLTRIM( UPPER( __GetMessage() ) )
   lError := .T.
   IF PCOUNT() == 0
      nPos := ::FieldPos( cMessage )
      IF nPos > 0
         uRet := ::FieldGet( nPos )
         lError := .F.
      ENDIF
   ELSEIF PCOUNT() == 1
      nPos := ::FieldPos( SUBSTR( cMessage, 2 ) )
      IF nPos > 0
         uRet := ::FieldPut( nPos, xValue )
         lError := .F.
      ENDIF
   ENDIF
   IF lError
      uRet := NIL
      ::MsgNotFound( cMessage )
   ENDIF
RETURN uRet

/*
 *  This is a template for ooHGRecord's subclasses (database class used
 *  by XBrowse).
 *
 *  All methods are defined specifically for XBrowse_Paradox. If you create
 *  your own class, you must define them for your own requirements.
 */

*-----------------------------------------------------------------------------*
CLASS XBrowse_Paradox FROM XBrowse_DirectFile
*-----------------------------------------------------------------------------*
   METHOD New

   // Methods always used by XBrowse
   // It's on XBrowse_DirectFile class... METHOD Skipper
   METHOD GoTop
   METHOD GoBottom

   // Methods used by XBrowse if you'll have a scrollbar
   METHOD RecNo              BLOCK { | Self | ::nRecNo }
   METHOD RecCount
   METHOD GoTo
   METHOD OrdKeyNo
   METHOD OrdKeyCount
   METHOD OrdKeyGoTo

   // Methods used by XBrowse if you'll allow edition
   // It's on XBrowse_DirectFile class... DATA cAlias__             INIT nil
   METHOD Eof                INLINE ::lEof

   // Methods used by XBrowse if you'll allow NOSHOWEMPTYROW
   METHOD IsTableEmpty

   // Implementations
   METHOD Bof                INLINE ::lBof
   METHOD Skip

   // It's on XBrowse_DirectFile class... METHOD Field      BLOCK { | Self, nPos | ::FieldName( nPos ) }
   // It's on XBrowse_DirectFile class... METHOD FieldName  BLOCK { | Self, nPos | IF( nPos < 1 .OR. nPos > ::nFields, "", UPPER( ::aFields[ nPos ] ) ) }
   METHOD FieldGet
   METHOD FieldDecode
   METHOD FieldPut
   // It's on XBrowse_DirectFile class... METHOD FieldBlock
   // It's on XBrowse_DirectFile class... METHOD FieldPos

   METHOD OrdScope
*   METHOD Filter

*   METHOD Locate     BLOCK { | Self, bFor, bWhile, nNext, nRec, lRest | ( ::cAlias__ )->( __dbLocate( bFor, bWhile, nNext, nRec, lRest ) ) }
   METHOD Seek
*   METHOD Commit     BLOCK { | Self |                         ( ::cAlias__ )->( DbCommit() ) }
*   METHOD Unlock     BLOCK { | Self |                         ( ::cAlias__ )->( DbUnlock() ) }
*   METHOD Delete     BLOCK { | Self |                         ( ::cAlias__ )->( DbDelete() ) }
   METHOD Close
   METHOD Found              INLINE ::lFound
   METHOD SetOrder
*   METHOD SetIndex   BLOCK { | Self, cFile, lAdditive |       IF( EMPTY( lAdditive ), ( ::cAlias__ )->( ordListClear() ), ) , ( ::cAlias__ )->( ordListAdd( cFile ) ) }
*   METHOD Append     BLOCK { | Self |                         ( ::cAlias__ )->( DbAppend() ) }
*   METHOD Lock       BLOCK { | Self |                         ( ::cAlias__ )->( RLock() ) }
   METHOD DbStruct

   // "Internal" stuff
   DATA lShared              INIT .T.
   // Record management
   DATA lHot                 INIT .F.
   DATA lValidBuffer         INIT .F.
   DATA nRecno               INIT 1
   DATA nRecCount            INIT 0
   DATA lBof                 INIT .F.
   DATA lEof                 INIT .F.
   DATA lFound               INIT .F.
   // Structure
   DATA aTypes               INIT nil
   DATA aTypesHarbour        INIT nil
   DATA aCodeTypes           INIT nil
   DATA aWidths              INIT nil
   DATA aBufferPos           INIT nil
   DATA nRecordLen           INIT 0
   DATA cRecord              INIT ""
   // File info
   DATA nVersion             INIT 0
   DATA nVersionId           INIT 0
   DATA aBlocks              INIT nil
   DATA nUsedBlocks          INIT 0
   DATA nTotalBlocks         INIT 0
   DATA nHeaderSize          INIT 0
   DATA nBlockSize           INIT 0
   DATA nFirstBlock          INIT 0
   DATA nLastBlock           INIT 0
   DATA nFreeBlock           INIT 0
   // Fast skip
   DATA cCurrentBlockBuffer  INIT nil
   DATA nCurrentBlock        INIT 0
   DATA nCurrentBlockRecord  INIT 0
   // PX info
   DATA lHasIndex            INIT .F.
   DATA nOrder               INIT 0
   DATA nKeyFields           INIT 0
   DATA oPxFile              INIT nil
   DATA nPxKeyCount          INIT 0
   DATA nPxKeyLen            INIT 0
   DATA nPxHeaderSize        INIT 0
   DATA nPxBlockSize         INIT 0
   DATA nPxRootBlock         INIT 0
   DATA nPxIndexLevels       INIT 0
   DATA cScopeFrom           INIT ""
   DATA cScopeTo             INIT ""
   //
   METHOD GoCold
   METHOD RefreshHeader
   METHOD ReadRecord
   METHOD ReadBlock
   METHOD ReadBlockHeader
   METHOD SeekSpecifiedKey
   METHOD SeekKey
   METHOD SeekKeyTree
   METHOD ValueToBuffer
   METHOD CurrentIndexKey
ENDCLASS

STATIC FUNCTION StrLen( cBuffer, nStart, nLen )
RETURN HB_InLine( cBuffer, nStart, nLen ){
   int iCount, iLen;
   char *cBuffer;

   // Buffer's length
   iLen = hb_parclen( 1 );
   cBuffer = ( char * ) hb_parc( 1 );
   // Length specified at 3rd. parameter
   if( HB_ISNUM( 3 ) )
   {
      iCount = hb_parni( 3 );
      if( iLen > iCount )
      {
         iLen = iCount;
      }
   }
   // Skipped bytes
   iCount = hb_parni( 2 );
   if( iCount > iLen )
   {
      iLen = 0;
   }
   else if( iCount > 1 )
   {
      iCount--;
      iLen -= iCount;
      cBuffer += iCount;
   }

   // "Main loop"
   iCount = 0;
   while( iLen && *cBuffer != 0 )
   {
      iCount++;
      cBuffer++;
      iLen--;
   }

   hb_retni( iCount );
}

STATIC FUNCTION ReadLittleEndian( cBuffer, nPos, nCount, lTrimTopBit )
RETURN HB_InLine( cBuffer, nPos, nCount ){
   int iCount, iLen, iTrimTopBit;
   char *cBuffer;
   HB_ULONGLONG llNum, llSign;

   // Buffer's length
   iLen = hb_parclen( 1 );
   cBuffer = ( char * ) hb_parc( 1 );
   iTrimTopBit = hb_parl( 4 );
   // Skipped bytes
   iCount = hb_parni( 2 );
   if( iCount > iLen )
   {
      iLen = 0;
   }
   else if( iCount > 1 )
   {
      iCount--;
      iLen -= iCount;
      cBuffer += iCount;
   }

   // Number size
   iCount = hb_parni( 3 );
   if( iCount > iLen )
   {
      iCount = iLen;
   }

   llNum = 0;
   llSign = 0;
   cBuffer += iCount;
   while( iCount )
   {
      cBuffer--;
      iCount--;
      llNum = ( llNum << 8 ) | ( HB_ULONGLONG ) ( unsigned char ) *cBuffer;
      if( llSign )
      {
         llSign = llSign << 8;
      }
      else
      {
         llSign = 0x80;
      }
   }

   if( iTrimTopBit )
   {
      llNum = llNum & ( llSign - 1 );
   }

   hb_retnll( llNum );
}

EXTERN READBIGENDIAN

#pragma BEGINDUMP

HB_ULONGLONG ReadBigEndian( char *cBuffer, int iLen, int iPos, int iCount, int iUnsigned, int iTrimTopBit )
{
   HB_ULONGLONG llNum, llSign;

   // Skipped bytes
   if( iPos > iLen )
   {
      iLen = 0;
   }
   else if( iPos > 1 )
   {
      iPos--;
      iLen -= iPos;
      cBuffer += iPos;
   }

   // Number size
   if( iCount > iLen )
   {
      iCount = iLen;
   }

   llNum = 0;
   llSign = 0;
   while( iCount )
   {
      iCount--;
      llNum = ( llNum << 8 ) | ( HB_ULONGLONG ) ( unsigned char ) *cBuffer;
      cBuffer++;
      if( llSign )
      {
         llSign = llSign << 8;
      }
      else
      {
         llSign = 0x80;
      }
   }

   if( iTrimTopBit )
   {
      llNum = llNum & ( llSign - 1 );
   }
   else if( iUnsigned )
   {
      llNum = llNum ^ llSign;
   }
   else
   {
      llNum = llNum - llSign;
   }

   return llNum;
}

HB_FUNC( READBIGENDIAN )   // ( cBuffer, nPos, nCount, lUnsigned, lTrimTopBit )
{
   hb_retnll( ReadBigEndian( ( char * ) hb_parc( 1 ), hb_parclen( 1 ), hb_parni( 2 ), hb_parni( 3 ), hb_parl( 4 ), hb_parl( 5 ) ) );
}

HB_FUNC( WRITEBIGENDIAN )   // ( nNum, nCount )
{
   HB_ULONGLONG llNum;
   int iCount, iPos;
   char *cBuffer;

   llNum = hb_parnll( 1 );
   iCount = hb_parni( 2 );
   cBuffer = hb_xgrab( iCount + 1 );
   cBuffer[ iCount + 1 ] = 0;
   iPos = iCount;
   while( iPos )
   {
      iPos--;
      cBuffer[ iPos ] = ( char ) ( unsigned char ) ( llNum & 0xFF );
      llNum = llNum >> 8;
   }
   *cBuffer ^= 0x80;

   hb_retclen_buffer( cBuffer, iCount );
}

#pragma ENDDUMP

METHOD New( cFile, lShared, lReadOnly ) CLASS XBrowse_Paradox
LOCAL cBuffer, nLen, nBase, nPos, nBase2, nPos2, cKeyTypes
   IF HB_IsLogical( lShared )
      ::lShared := lShared
   ENDIF

* ¨Validar/guardar lReadOnly para uso futuro?

   // Open file
   IF ! ::OpenFile( cFile, ::lShared, lReadOnly )
      RETURN nil
   ENDIF

   // Reads header
   cBuffer := SPACE( 2048 )
   ::oFile:Seek( 0, FS_SET )
   IF ::oFile:Read( @cBuffer, 2048 ) != 2048
      ::oFile:Close()
      RETURN nil
   ENDIF
   nLen := ReadLittleEndian( cBuffer, 3, 2 )
   ::nHeaderSize := nLen
   IF nLen <= 2048
      // Header is on buffer
      nRead := nLen
   ELSE
      cBuffer := SPACE( nLen )
      ::oFile:Seek( 0, FS_SET )
      IF ! ::oFile:Read( @cBuffer, nLen ) == nLen
         ::oFile:Close()
         RETURN nil
      ENDIF
   ENDIF

   // Analyze header
   ::nRecordLen := ReadLittleEndian( cBuffer, 1, 2 )
   ::lHasIndex := ( ASC( SUBSTR( cBuffer, 5, 1 ) ) == 0 )   // 0.Indexed, 2.Not indexed
   ::nBlockSize := ASC( SUBSTR( cBuffer, 6, 1 ) ) * 1024
   ::nFields := ReadLittleEndian( cBuffer, 34, 2 )
   ::nVersionId := ASC( SUBSTR( cBuffer, 58, 1 ) )   // 3=3.0, 4=3.5, (5-9)=4.x, (10-11)=5.x, 12=7.x
   ::nVersion := { 0, 1, 2, 3, 3.5, 4, 4, 4, 4, 4, 5, 5, 7 }[ MIN( MAX( ::nVersionId, 0 ), 12 ) + 1 ]
   ::nKeyFields := ReadLittleEndian( cBuffer, 36, 2 )
*   ::nEncription := ReadLittleEndian( cBuffer, 38, 4 )
*   ::nOrderType := ASC( SUBSTR( cBuffer, 42, 1 ) )
   IF ::nVersion >= 4
      nBase := 121
      // Paradox 4+ Header
*      IF ::nEncription== 0xFF00FF00
*         ::nEncription := ReadLittleEndian( cBuffer, 93, 4 )
*      ENDIF
*      ::nCodePage := ReadLittleEndian( cBuffer, 107, 2 )
   ELSE
      nBase := 89
   ENDIF
   nBase2 := IF( ::nVersion >= 7, 261, 79 )
   nPos2 := nBase + ( ::nFields * 6 ) + 4
*   ::cFileName := SUBSTR( cBuffer, nPos2, StrLen( cBuffer, nPos2, MIN( nLen, nPos2 + nBase2 - 1 ) ) )
   nBase2 := nPos2 + nBase2
   ::aFields := ARRAY( ::nFields )
   ::aCodeTypes := ARRAY( ::nFields )
   ::aTypes := ARRAY( ::nFields )
   ::aTypesHarbour := ARRAY( ::nFields )
   ::aWidths := ARRAY( ::nFields )
   ::aBufferPos := ARRAY( ::nFields )
   cKeyTypes := SUBSTR( cBuffer, nBase, ::nKeyFields * 2 )
   FOR nPos := 1 TO ::nFields
      ::aCodeTypes[ nPos ] := ASC( SUBSTR( cBuffer, nBase, 1 ) )
      ::aTypes[ nPos ] :=        SUBSTR( " ADSI$N  L  MBFOG   T@+#Y", MIN( MAX( ::aCodeTypes[ nPos ], 0 ), 24 ) + 1, 1 )
      ::aTypesHarbour[ nPos ] := SUBSTR( " CDNNNN  L  MMMMM   NTNNC", MIN( MAX( ::aCodeTypes[ nPos ], 0 ), 24 ) + 1, 1 )
      nBase++
      IF ::aTypes[ nPos ] == "#"
         ::aWidths[ nPos ] := 17
      ELSE
         ::aWidths[ nPos ] := ASC( SUBSTR( cBuffer, nBase, 1 ) )
      ENDIF
      IF nPos == 1
         ::aBufferPos[ nPos ] := 1
      ELSE
         ::aBufferPos[ nPos ] := ::aBufferPos[ nPos - 1 ] + ::aWidths[ nPos - 1 ]
      ENDIF
      nBase++
      nPos2 := StrLen( cBuffer, nBase2, nLen )
      ::aFields[ nPos ] := SUBSTR( cBuffer, nBase2, nPos2 )
      nBase2 += nPos2 + 1
   NEXT
*   * nBase2 apunta a encrypted additional data......
*   nBase2 += ::nFields * 2
*   ::cOrderId := SUBSTR( cBuffer, nBase2, StrLen( cBuffer, nBase2, nLen ) )

   ::nOrder := 0
   IF ::lHasIndex
      ::oPxFile := EVAL( ::bOpenFile, cFile, lShared, lReadOnly, "px" )
      IF ::oPxFile != NIL
         cBuffer := SPACE( 88 + ( ::nKeyFields * 2 ) )
         ::oPxFile:Seek( 0, FS_SET )
         IF ! ::oPxFile:Read( @cBuffer, LEN( cBuffer ) ) == ( 88 + ( ::nKeyFields * 2 ) ) ;   // Can't read file
            .OR. ASC( SUBSTR( cBuffer, 5, 1 ) ) != 1                  ;   // Not a PX file!
            .OR. ReadLittleEndian( cBuffer, 34, 2 ) != ::nKeyFields   ;   // Key fields count error!
            .OR. ! SUBSTR( cBuffer, 89, ::nKeyFields * 2 ) == cKeyTypes   ;   // Not the same field types
            // Error!
            ::oPxFile:Close()
            ::oPxFile := NIL
         ELSE
            ::nPxKeyLen := ReadLittleEndian( cBuffer, 1, 2 )
            ::nPxHeaderSize := ReadLittleEndian( cBuffer, 3, 2 )
            ::nPxBlockSize := ASC( SUBSTR( cBuffer, 6, 1 ) ) * 1024
            ::nOrder := 1
         ENDIF
      ENDIF
   ELSE
      ::oPxFile := nil
   ENDIF

   ::RefreshHeader( .T. )

   // Init
   ::lHot := .F.
   ::lValidBuffer := .F.
   ::GoTop()
RETURN Self

METHOD GoTop() CLASS XBrowse_Paradox
LOCAL lFound, nFrom, nTo
   ::RefreshHeader()
   IF ::nOrder == 0
      ::GoTo( 1 )
   ELSE // IF ::nOrder == 1
      IF LEN( ::cScopeFrom ) + LEN( ::cScopeTo ) > 0 .AND. ::cScopeFrom <= ::cScopeTo
         nFrom := ::SeekKey( ::cScopeFrom, .T., .F., @lFound )
         IF ! lFound
            nFrom++
         ENDIF
         nTo   := ::SeekKey( ::cScopeTo,   .T., .T. )
         IF nFrom > nTo
            ::GoTo( 0 )
         ELSE
            ::GoTo( nFrom )
         ENDIF
      ELSE
         ::GoTo( 1 )
      ENDIF
   ENDIF
RETURN nil

METHOD GoBottom() CLASS XBrowse_Paradox
LOCAL lFound, nFrom, nTo
   ::RefreshHeader()
   IF ::nOrder == 0
      ::GoTo( ::nRecCount )
   ELSE // IF ::nOrder == 1
      IF LEN( ::cScopeFrom ) + LEN( ::cScopeTo ) > 0 .AND. ::cScopeFrom <= ::cScopeTo
         nFrom := ::SeekKey( ::cScopeFrom, .T., .F., @lFound )
         IF ! lFound
            nFrom++
         ENDIF
         nTo   := ::SeekKey( ::cScopeTo,   .T., .T. )
         IF nFrom > nTo
            ::GoTo( 0 )
         ELSE
            ::GoTo( nTo )
         ENDIF
      ELSE
         ::GoTo( ::nRecCount )
      ENDIF
   ENDIF
RETURN nil

METHOD RecCount() CLASS XBrowse_Paradox
   ::RefreshHeader()
RETURN ::nRecCount

METHOD GoTo( nRecno ) CLASS XBrowse_Paradox
   ::RefreshHeader()
   IF nRecno < 1 .OR. nRecno > ::nRecCount
      nRecno := ::nRecCount + 1
   ENDIF
   ::GoCold()
   ::lValidBuffer := .F.
   ::nRecNo := INT( nRecno )
   ::lBof := ( ::nRecCount == 0 )
   ::lEof := ( ::nRecno > ::nRecCount )
   ::lFound := .F.
RETURN nil

METHOD OrdKeyNo() CLASS XBrowse_Paradox
LOCAL nRet, lFound, nFrom, nTo
   ::RefreshHeader()
   IF ::nOrder == 0
      nRet := ::nRecNo
   ELSE // IF ::nOrder == 1
      IF LEN( ::cScopeFrom ) + LEN( ::cScopeTo ) > 0 .AND. ::cScopeFrom <= ::cScopeTo
         nFrom := ::SeekKey( ::cScopeFrom, .T., .F., @lFound )
         IF ! lFound
            nFrom++
         ENDIF
         nTo   := ::SeekKey( ::cScopeTo,   .T., .T. )
         IF ::nRecno < nFrom .OR. ::nRecno > nTo
            nRet := 0
         ELSE
            nRet := ::nRecno - nFrom + 1
         ENDIF
      ELSE
         nRet := ::nRecNo
      ENDIF
   ENDIF
RETURN nRet

METHOD OrdKeyCount() CLASS XBrowse_Paradox
LOCAL nRet, lFound, nFrom, nTo
   ::RefreshHeader()
   IF ::nOrder == 0
      nRet := ::nRecCount
   ELSE // IF ::nOrder == 1
      IF LEN( ::cScopeFrom ) + LEN( ::cScopeTo ) > 0 .AND. ::cScopeFrom <= ::cScopeTo
         nFrom := ::SeekKey( ::cScopeFrom, .T., .F., @lFound )
         IF ! lFound
            nFrom++
         ENDIF
         nTo   := ::SeekKey( ::cScopeTo,   .T., .T. )
         nRet := nTo - nFrom + 1
      ELSE
         nRet := ::nRecCount
      ENDIF
   ENDIF
RETURN nRet

METHOD OrdKeyGoTo( nRecNo ) CLASS XBrowse_Paradox
LOCAL lFound, nFrom, nTo
   ::RefreshHeader()
   IF ::nOrder == 0
      ::GoTo( nRecNo )
   ELSE // IF ::nOrder == 1
      IF LEN( ::cScopeFrom ) + LEN( ::cScopeTo ) > 0 .AND. ::cScopeFrom <= ::cScopeTo
         nFrom := ::SeekKey( ::cScopeFrom, .T., .F., @lFound )
         IF ! lFound
            nFrom++
         ENDIF
         nTo   := ::SeekKey( ::cScopeTo,   .T., .T. )
         IF nRecNo > ( nTo - nFrom + 1 ) .OR. nRecNo < 1
            ::GoTo( 0 )
         ELSE
            ::GoTo( nRecNo + nFrom - 1 )
         ENDIF
      ELSE
         ::GoTo( nRecNo )
      ENDIF
   ENDIF
RETURN nil

METHOD IsTableEmpty() CLASS XBrowse_Paradox
LOCAL lEmpty, lFound, nFrom, nTo
   ::RefreshHeader()
   IF ::nOrder == 0
      lEmpty := ( ::RecCount == 0 )
   ELSE // IF ::nOrder == 1
      IF LEN( ::cScopeFrom ) + LEN( ::cScopeTo ) > 0 .AND. ::cScopeFrom <= ::cScopeTo
         nFrom := ::SeekKey( ::cScopeFrom, .T., .F., @lFound )
         IF ! lFound
            nFrom++
         ENDIF
         nTo   := ::SeekKey( ::cScopeTo,   .T., .T. )
         lEmpty := ( nFrom > nTo )
      ELSE
         lEmpty := ( ::RecCount == 0 )
      ENDIF
   ENDIF
RETURN lEmpty

METHOD Skip( nCount ) CLASS XBrowse_Paradox
LOCAL lFound, nFrom, nTo, nRecordsInBlock, nAux
LOCAL lBof
   ::GoCold()
   ::RefreshHeader()
   IF ! HB_IsNumeric( nCount )
      nCount := 1
   ENDIF
   nCount := INT( nCount )
   lBof := .F.

   IF     ::nOrder == 1                                                                    .AND. ;   // Table is sorted
          LEN( ::cScopeFrom ) + LEN( ::cScopeTo ) > 0 .AND. ::cScopeFrom <= ::cScopeTo     .AND. ;   // There's SCOPE active
          ::Recno > ::RecCount                                                                       // Current record is EOF
      ::GoBottom()
      IF ::Recno > ::RecCount .AND. nCount < 1
         lBof := .T.
      ENDIF
      nCount := nCount + 1
   ENDIF

   IF ::nOrder == 1 .AND. ::lValidBuffer .AND. ::lShared .AND. ! ::cCurrentBlockBuffer == ::ReadBlock( ::nCurrentBlock )
      // Block has changed, so locate current key (new record's position)
      ::SeekSpecifiedKey( ::CurrentIndexKey(), .T. )
   ENDIF

   // Fast skip
   IF     ::lValidBuffer                               .AND. ;     // Data in progress
          ! ::cCurrentBlockBuffer == NIL               .AND. ;     // Block is on memory
          ABS( nCount ) <= ( INT( ::nBlockSize / ::nRecordLen ) * 2 )      // How many records for "fast" skip?
      IF ! ::lShared .OR. ::cCurrentBlockBuffer == ::ReadBlock( ::nCurrentBlock )
         DO WHILE nCount != 0
            nRecordsInBlock := INT( ReadLittleEndian( ::cCurrentBlockBuffer, 5, 2, .T. ) / ::nRecordLen ) + 1
            IF nCount < 0
               IF ::nCurrentBlockRecord == 0
                  // Row 0 means "comes from other block"
                  ::nCurrentBlockRecord := nRecordsInBlock + 1
               ENDIF
               IF     LEN( ::cScopeFrom ) + LEN( ::cScopeTo ) > 0 .AND. ::cScopeFrom <= ::cScopeTo .AND. SUBSTR( ::cCurrentBlockBuffer, 7, LEN( ::cScopeFrom ) ) < ::cScopeFrom
                  // There's SCOPE and first item in block is out of range
                  DO WHILE nCount != 0 .AND. SUBSTR( ::cCurrentBlockBuffer, ( ( ::nCurrentBlockRecord - 2 ) * ::nRecordLen ) + 7, LEN( ::cScopeFrom ) ) >= ::cScopeFrom
                     nCount++
                     ::nCurrentBlockRecord--
                     ::nRecNo--
                  ENDDO
                  IF nCount < 0
                     ::GoTop()
                     ::lBof := .T.
                     ::lEof := .F.
                     RETURN nil
                  ENDIF
                  EXIT
               ELSEIF ( - nCount ) < ::nCurrentBlockRecord
                  ::nRecNo += nCount
                  ::nCurrentBlockRecord += nCount
                  nCount := 0
               ELSE
                  nAux := ::nCurrentBlockRecord - 1
                  nCount += nAux
                  ::nRecNo -= nAux
                  ::nCurrentBlockRecord := 0
                  nAux := ::nCurrentBlock
                  ::nCurrentBlock := ReadLittleEndian( ::cCurrentBlockBuffer, 3, 2 )
                  IF ::nCurrentBlock == 0
                     EXIT
                  ENDIF
                  ::cCurrentBlockBuffer := ::ReadBlock( ::nCurrentBlock )
                  IF ! nAux == ReadLittleEndian( ::cCurrentBlockBuffer, 1, 2 )
                     // Broken block link!
                     EXIT
                  ENDIF
               ENDIF
            ELSE // IF nCount > 0
               IF     LEN( ::cScopeFrom ) + LEN( ::cScopeTo ) > 0 .AND. ::cScopeFrom <= ::cScopeTo .AND. SUBSTR( ::cCurrentBlockBuffer, ( ( nRecordsInBlock - 1 ) * ::nRecordLen ) + 7, LEN( ::cScopeTo ) ) > ::cScopeTo
                  // There's SCOPE and last item in block is out of range
                  DO WHILE nCount != 0 .AND. SUBSTR( ::cCurrentBlockBuffer, ( ::nCurrentBlockRecord * ::nRecordLen ) + 7, LEN( ::cScopeTo ) ) <= ::cScopeTo
                     nCount--
                     ::nCurrentBlockRecord++
                     ::nRecNo++
                  ENDDO
                  IF nCount > 0
                     ::GoTo( 0 )
                     RETURN nil
                  ENDIF
                  EXIT
               ELSEIF nCount + ::nCurrentBlockRecord <= nRecordsInBlock
                  ::nRecNo += nCount
                  ::nCurrentBlockRecord += nCount
                  nCount := 0
               ELSEIF ::nCurrentBlockRecord > nRecordsInBlock
                  // Error!
                  EXIT
               ELSE
                  nAux := nRecordsInBlock - ::nCurrentBlockRecord
                  nCount -= nAux
                  ::nRecNo += nAux
                  ::nCurrentBlockRecord := 0
                  nAux := ::nCurrentBlock
                  ::nCurrentBlock := ReadLittleEndian( ::cCurrentBlockBuffer, 1, 2 )
                  IF ::nCurrentBlock == 0
                     EXIT
                  ENDIF
                  ::cCurrentBlockBuffer := ::ReadBlock( ::nCurrentBlock )
                  IF ! nAux == ReadLittleEndian( ::cCurrentBlockBuffer, 3, 2 )
                     // Broken block link!
                     EXIT
                  ENDIF
               ENDIF
            ENDIF
         ENDDO
         IF nCount == 0
            ::lFound := .F.
            ::lBof := .F.
            ::lEof := .F.
            ::cRecord := SUBSTR( ::cCurrentBlockBuffer, 7 + ( ( ::nCurrentBlockRecord - 1 ) * ::nRecordLen ), ::nRecordLen )
            RETURN nil
         ELSE
            ::lValidBuffer := .F.
            ::cCurrentBlockBuffer := NIL
         ENDIF
      ENDIF
   ENDIF
   // Fast skip

   IF ::nOrder == 0
      nCount := ::nRecno + nCount
      IF nCount < 1
         nCount := 1
         lBof := .T.
      ELSEIF nCount > ::nRecCount
         nCount := ::nRecCount + 1
      ENDIF
      ::GoTo( nCount )

   ELSE // IF ::nOrder == 1
      nCount := ::nRecno + nCount
      IF nCount < 1
         nCount := 1
         lBof := .T.
      ELSEIF nCount > ::nRecCount
         nCount := ::nRecCount + 1
      ENDIF
      ::GoTo( nCount )
      //
      IF LEN( ::cScopeFrom ) + LEN( ::cScopeTo ) > 0 .AND. ::cScopeFrom <= ::cScopeTo
         IF ::Recno <= ::RecCount
            IF ::CurrentIndexKey( LEN( ::cScopeTo ) ) > ::cScopeTo
               ::GoTo( 0 )
            ELSEIF ::CurrentIndexKey( LEN( ::cScopeFrom ) ) < ::cScopeFrom
               ::GoTop()
               lBof := .T.
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   IF lBof
      ::lBof := .T.
      ::lEof := .F.
   ENDIF
RETURN nil

METHOD FieldGet( nPos ) CLASS XBrowse_Paradox
LOCAL uValue, nBufferPos
   uValue := NIL
   IF nPos >= 1 .AND. nPos <= ::nFields
      IF ! ::lValidBuffer
         ::ReadRecord()
      ENDIF
      nBufferPos := ::aBufferPos[ nPos ]
      uValue := ::FieldDecode( ::aTypes[ nPos ], ::cRecord, ::aBufferPos[ nPos ], ::aWidths[ nPos ] )
   ENDIF
RETURN uValue

METHOD FieldDecode( cType, cRecord, nBufferPos, nWidth ) CLASS XBrowse_Paradox
RETURN HB_INLINE( cType, cRecord, nBufferPos, nWidth ){
            char *cBuffer;
            int iLen, iBufferPos, iWidth, iMax;
            unsigned long lAux;

            cBuffer = ( char * ) hb_parc( 2 );
            iLen = hb_parclen( 2 );
            iBufferPos = hb_parni( 3 );
            iWidth = hb_parni( 4 );
            if( iBufferPos > 0 )
            {
               iBufferPos--;
            }
            if( iBufferPos >= iLen )
            {
               iMax = 0;
            }
            else
            {
               iMax = ( iBufferPos + iWidth > iLen ) ? ( iLen - iBufferPos ) : iWidth;
            }

            switch( hb_parc( 1 )[ 0 ] )
            {

               case 'A':
                  // Character
                  if( iMax == 0 )
                  {
                     hb_retc( "" );
                  }
                  else
                  {
                     int iBytes, iSize;

                     iSize = iMax;
                     iBytes = 0;
                     while( iSize )
                     {
                        iSize--;
                        if( cBuffer[ iBufferPos + iBytes ] == 0 )
                        {
                           iSize = 0;
                        }
                        else
                        {
                           iBytes++;
                        }
                     }
                     hb_retclen( cBuffer + iBufferPos, iBytes );
                  }
                  break;

               case 'D':
                  // Date
                  if( iMax < 4 )
                  {
                     hb_retds( "" );
                  }
                  else
                  {
                     hb_retdl( 1757585 - 36160 + ReadBigEndian( cBuffer, iLen, iBufferPos + 1, 4, 0, 0 ) );
                  }
                  break;

               case 'S':
                  // Small integer ( WORD )
                  hb_retni( ReadBigEndian( cBuffer, iLen, iBufferPos + 1, 2, 0, 0 ) );
                  break;

               case 'I':
                  // Long integer ( LONG )
                  hb_retnl( ReadBigEndian( cBuffer, iLen, iBufferPos + 1, 4, 0, 0 ) );
                  break;

               case '$':
               case 'N':
                  // Currency / numeric double
                  if( iMax < 8 )
                  {
                     hb_retnd( 0 );
                  }
                  else
                  {
                     char cNumber[ 8 ];
                     int iMove;
                     for( iMove = 0; iMove < 8; iMove++ )
                     {
                        cNumber[ iMove ] = cBuffer[ iBufferPos + 7 - iMove ];
                     }
                     hb_retnd( *( ( double * ) &cNumber[ 0 ] ) );
                  }
                  break;

               case 'L':
                  // Logical
                  if( iMax < 1 )
                  {
                     hb_retl( 0 );
                  }
                  else
                  {
                     hb_retl( cBuffer[ iBufferPos ] != 0 );
                  }
                  break;

               case 'M':
               case 'B':
               case 'F':
               case 'O':
               case 'G':
                  // MEMO Y PARECIDOS...
                  hb_retc( "" );
                  break;

               case 'T':
                  // Time
                  if( iMax < 4 ||
                      ( cBuffer[ iBufferPos ]     == 0 &&
                        cBuffer[ iBufferPos + 1 ] == 0 &&
                        cBuffer[ iBufferPos + 2 ] == 0 &&
                        cBuffer[ iBufferPos + 3 ] == 0 ) )
                  {
                     hb_retc( "**:**:**" );
                  }
                  else
                  {
                     lAux = ReadBigEndian( cBuffer, iLen, iBufferPos + 1, 4, 0, 0 ) / 1000;
                     // hb_retnl( lAux );
                     {
                        int iNum;
                        char cDate[ 10 ];
                        iNum = lAux % 60;
                        lAux = lAux / 60;
                        cDate[ 8 ] = 0;
                        cDate[ 7 ] = '0' + ( iNum % 10 );
                        cDate[ 6 ] = '0' + ( iNum / 10 );
                        iNum = lAux % 60;
                        lAux = lAux / 60;
                        cDate[ 5 ] = ':';
                        cDate[ 4 ] = '0' + ( iNum % 10 );
                        cDate[ 3 ] = '0' + ( iNum / 10 );
                        cDate[ 2 ] = ':';
                        cDate[ 1 ] = '0' + ( lAux % 10 );
                        cDate[ 0 ] = '0' + ( lAux / 10 );
                        hb_retc( cDate );
                     }
                  }
                  break;

               case '@':
                  // Timestamp
                  //
                  if( iMax < 8 )
                  {
                     hb_retds( "" );
                  }
                  else
                  {
                     long   lDate, lTime;
                     double dDateTime;

                     *( ( HB_ULONGLONG * ) ( &dDateTime ) ) = ReadBigEndian( cBuffer, iLen, iBufferPos + 1, 8, 1, 0 );
                     lDate = ( long ) ( dDateTime / ( double ) 86400000 );
                     lTime = ( long ) ( dDateTime - ( ( double ) lDate * ( double ) 86400000 ) );
                     // lTime = lTime * HB_DATETIMEINSEC / 1000;
                     hb_retdtl( lDate + 1757585 - 36160, lTime );
                  }
                  break;

               case '+':
                  // Autoincrement
                  hb_retnl( ReadBigEndian( cBuffer, iLen, iBufferPos + 1, 4, 0, 0 ) );
                  break;

               case '#':
// BCD .... ????
                  hb_retclen( cBuffer + iBufferPos, iMax );
                  break;

               case 'Y':
// BYTES ????
                  hb_retclen( cBuffer + iBufferPos, iMax );
                  break;

               default:
                  hb_ret();
                  break;
            }
         }

METHOD FieldPut( nPos, xValue ) CLASS XBrowse_Paradox
RETURN NIL

METHOD OrdScope( uFrom, uTo ) CLASS XBrowse_Paradox
LOCAL cKey
   IF PCOUNT() == 0
      ::cScopeFrom := ""
      ::cScopeTo := ""
   ELSE
      cKey := ""
      IF HB_IsArray( uFrom )
         AEVAL( uFrom, { |x,i| cKey += ::ValueToBuffer( x, ::aTypes[ i ], ::aWidths[ i ] ) },, ::nKeyFields )
      ELSE
         cKey := ::ValueToBuffer( uFrom, ::aTypes[ 1 ], ::aWidths[ 1 ] )
      ENDIF
      ::cScopeFrom := LEFT( cKey, ::nPxKeyLen - 6 )
      //
      IF PCOUNT() == 1
         ::cScopeTo := ::cScopeFrom
      ELSE
         cKey := ""
         IF HB_IsArray( uTo )
            AEVAL( uTo, { |x,i| cKey += ::ValueToBuffer( x, ::aTypes[ i ], ::aWidths[ i ] ) },, ::nKeyFields )
         ELSE
            cKey := ::ValueToBuffer( uTo, ::aTypes[ 1 ], ::aWidths[ 1 ] )
         ENDIF
         ::cScopeTo := LEFT( cKey, ::nPxKeyLen - 6 )
      ENDIF
   ENDIF
RETURN NIL

METHOD Seek( uKey, lSoftSeek, lLast ) CLASS XBrowse_Paradox
LOCAL cKey
   IF ::nOrder == 0
      ::lFound := .F.
      ::GoTo( 0 )
   ELSE
      // Checks key
      cKey := ""
      IF HB_IsArray( uKey )
         AEVAL( uKey, { |x,i| cKey += ::ValueToBuffer( x, ::aTypes[ i ], ::aWidths[ i ] ) },, ::nKeyFields )
      ELSE // IF VALTYPE( uKey ) == VALTYPE( ::FieldGet( 1 ) )
         cKey := ::ValueToBuffer( uKey, ::aTypes[ 1 ], ::aWidths[ 1 ] )
      ENDIF
      ::lFound := ::SeekSpecifiedKey( cKey, lSoftSeek, lLast )
   ENDIF
RETURN ::lFound

METHOD Close() CLASS XBrowse_Paradox
   IF ::oFile != NIL
      ::oFile:Close()
      ::oFile := NIL
   ENDIF
   IF ::oPxFile != NIL
      ::oPxFile:Close()
      ::oPxFile := NIL
   ENDIF
RETURN nil

METHOD SetOrder( nOrder ) CLASS XBrowse_Paradox
   IF nOrder == 1
      ::nOrder := 1
   ELSE
      ::nOrder := 0
   ENDIF
RETURN nil

METHOD DbStruct() CLASS XBrowse_Paradox
LOCAL aFields, I
   aFields := ARRAY( ::nFields )
   FOR I := 1 TO ::nFields
      aFields[ I ] := { UPPER( ::aFields[ I ] ), "C", ::aWidths[ I ], 0 }
      IF     ::aTypes[ I ] == "A"
         // Character
         // Default type
      ELSEIF ::aTypes[ I ] == "D"
         // Date
         aFields[ I ][ 2 ] := "D"
         aFields[ I ][ 3 ] := 8
      ELSEIF ::aTypes[ I ] == "S"
         // Small integer ( WORD )
         aFields[ I ][ 2 ] := "N"
         aFields[ I ][ 3 ] := 5
      ELSEIF ::aTypes[ I ] == "I"
         // Long integer ( LONG )
         aFields[ I ][ 2 ] := "N"
         aFields[ I ][ 3 ] := 10
***      ELSEIF ::aTypes[ I ] == "$" .OR. ::aTypes[ I ] == "N"
***         // Float
*****************
      ELSEIF ::aTypes[ I ] == "L"
         // Logical
         aFields[ I ][ 2 ] := "L"
         aFields[ I ][ 3 ] := 1
      ELSEIF ::aTypes[ I ] == "M" .OR. ::aTypes[ I ] == "B" .OR. ::aTypes[ I ] == "F" .OR. ::aTypes[ I ] == "O" .OR. ::aTypes[ I ] == "G"
**** MEMO Y PARECIDOS...
         aFields[ I ][ 2 ] := "M"
         aFields[ I ][ 3 ] := 10
      ELSEIF ::aTypes[ I ] == "T"
         // Time
         aFields[ I ][ 2 ] := "C"
         aFields[ I ][ 3 ] := 8
      ELSEIF ::aTypes[ I ] == "@"
         // Timestamp
         aFields[ I ][ 2 ] := "T"
         aFields[ I ][ 3 ] := 8
      ELSEIF ::aTypes[ I ] == "+"
         // Autoincrement
         aFields[ I ][ 2 ] := "N"
         aFields[ I ][ 3 ] := 10
***      ELSEIF ::aTypes[ I ] == "#"
**** BCD
***         uValue := SUBSTR( ::cRecord, nBufferPos, ::aWidths[ nPos ] )
***      ELSEIF ::aTypes[ I ] == "Y"
**** BYTES ????
***         uValue := SUBSTR( ::cRecord, nBufferPos, ::aWidths[ nPos ] )
      ENDIF
   NEXT
RETURN aFields

METHOD GoCold() CLASS XBrowse_Paradox
   IF ::lHot
      * GRABAR BUFFERS!
      ::lHot := .F.
   ENDIF
RETURN nil

METHOD RefreshHeader( lForce ) CLASS XBrowse_Paradox
LOCAL cBuffer
   IF ::lShared .OR. ( HB_IsLogical( lForce ) .AND. lForce )
      cBuffer := SPACE( 79 )
      ::oFile:Seek( 0, FS_SET )
      IF ! ::oFile:Read( @cBuffer, 79 ) == 79
         // Error!
      ENDIF
      ::nRecCount := ReadLittleEndian( cBuffer, 7, 4 )
      ::nUsedBlocks := ReadLittleEndian( cBuffer, 11, 2 )
      ::nTotalBlocks := ReadLittleEndian( cBuffer, 13, 2 )
      ::nFirstBlock := ReadLittleEndian( cBuffer, 15, 2 )
      ::nLastBlock := ReadLittleEndian( cBuffer, 17, 2 )
      ::nFreeBlock := ReadLittleEndian( cBuffer, 78, 2 )
*      ::nMagicFileChanged := ReadLittleEndian( cBuffer, 19, 2 )
*      ::nMagicHeaderChanged := ReadLittleEndian( cBuffer, 43, 2 )
*      * ::nMagic_x := ReadLittleEndian( cBuffer, 45, 2 )
*      ::lFileChanged := ( ASC( SUBSTR( cBuffer, 21, 1 ) ) != 0 .OR. ASC( SUBSTR( cBuffer, 43, 1 ) ) != 0 )
*      ::lWriteProtected := ( ASC( SUBSTR( cBuffer, 57, 1 ) ) != 0 )
*      ::nAutoInc := ReadLittleEndian( cBuffer, 74, 4 )
      IF ::aBlocks == NIL
         ::aBlocks := ARRAY( ::nUsedBlocks )
      ENDIF

      IF ::oPxFile != NIL
         cBuffer := SPACE( 34 )
         ::oPxFile:Seek( 0, FS_SET )
         IF ! ::oPxFile:Read( @cBuffer, 33 ) == 33
            // Error!
         ENDIF
         ::nPxKeyCount := ReadLittleEndian( cBuffer, 7, 4 )
         ::nPxRootBlock := ReadLittleEndian( cBuffer, 31, 2 )
         ::nPxIndexLevels := ASC( SUBSTR( cBuffer, 33, 1 ) )
/*
*si:      ::nUsedBlocks := ReadLittleEndian( cBuffer, 11, 2 )
*si:      ::nTotalBlocks := ReadLittleEndian( cBuffer, 13, 2 )
*si:      ::nFirstBlock := ReadLittleEndian( cBuffer, 15, 2 )
*si:      ::nLastBlock := ReadLittleEndian( cBuffer, 17, 2 )
*      ::nFreeBlock := ReadLittleEndian( cBuffer, 78, 2 )
*      ::nMagicFileChanged := ReadLittleEndian( cBuffer, 19, 2 )
*      ::nMagicHeaderChanged := ReadLittleEndian( cBuffer, 43, 2 )
*      * ::nMagic_x := ReadLittleEndian( cBuffer, 45, 2 )
*      ::lFileChanged := ( ASC( SUBSTR( cBuffer, 21, 1 ) ) != 0 .OR. ASC( SUBSTR( cBuffer, 43, 1 ) ) != 0 )
*      ::lWriteProtected := ( ASC( SUBSTR( cBuffer, 57, 1 ) ) != 0 )
*/
      ENDIF
   ENDIF
RETURN nil

METHOD ReadRecord() CLASS XBrowse_Paradox
LOCAL nCant1, nCant2, nPos, nBlock, cBuffer
LOCAL nLevel
   * ??? ::RefreshHeader()
   ::GoCold()
   IF ::nRecno > ::nRecCount .OR. ::nRecno < 1
      ::cRecord := REPLICATE( CHR( 0 ), ::nRecordLen )
      ::cCurrentBlockBuffer := nil
   ELSEIF ::nOrder == 0
      IF ::lShared
* HABRA QUE LEER EL MAPA DE BLOQUES OTRA VEZ....
      ENDIF
      nBlock := 0

      // Search block containing record (from the first one)
      nCant1 := 0
      nPos := 1
      DO WHILE nPos <= LEN( ::aBlocks ) .AND. ::aBlocks[ nPos ] != NIL
         IF nCant1 + ::aBlocks[ nPos ][ 1 ] >= ::nRecno
            nBlock := nPos
            EXIT
         ELSE
            nCant1 += ::aBlocks[ nPos ][ 1 ]
            nPos++
         ENDIF
      ENDDO

      // Search block containing record (from the last one)
      IF nBlock == 0
         nCant2 := ::nRecCount
         nPos := ::nUsedBlocks
         DO WHILE nPos >= 1 .AND. ::aBlocks[ nPos ] != NIL
            nCant2 -= ::aBlocks[ nPos ][ 1 ]
            IF nCant2 < ::nRecno
               nCant1 := nCant2
               nBlock := nPos
               EXIT
            ELSE
               nPos--
            ENDIF
         ENDDO
      ENDIF

      // Block not found
      IF nBlock == 0
         IF ( ::nRecno - nCant1 ) < ( nCant2 - ::nRecno )
            // Continue from top
            nCant1 := 0
            nPos := 1
            DO WHILE nPos <= LEN( ::aBlocks ) .AND. ::aBlocks[ nPos ] != NIL
               IF nCant1 + ::aBlocks[ nPos ][ 1 ] >= ::nRecno
                  nBlock := nPos
                  EXIT
               ELSE
                  nCant1 += ::aBlocks[ nPos ][ 1 ]
                  nPos++
               ENDIF
            ENDDO
            DO WHILE nBlock == 0
               IF nPos == 1
                  ::aBlocks[ nPos ] := ::ReadBlockHeader( ::nFirstBlock )
               ELSE
                  ::aBlocks[ nPos ] := ::ReadBlockHeader( ::aBlocks[ nPos - 1 ][ 3 ] )
               ENDIF
               IF nCant1 + ::aBlocks[ nPos ][ 1 ] >= ::nRecno
                  nBlock := nPos
               ELSE
                  nCant1 += ::aBlocks[ nPos ][ 1 ]
               ENDIF
               nPos++
            ENDDO
         ELSE
            // Continue from bottom
            nCant1 := ::nRecCount
            nPos := ::nUsedBlocks
            DO WHILE nPos >= 1 .AND. ::aBlocks[ nPos ] != NIL
               nCant1 -= ::aBlocks[ nPos ][ 1 ]
               IF nCant1 < ::nRecno
                  nBlock := nPos
                  EXIT
               ELSE
                  nPos--
               ENDIF
            ENDDO
            DO WHILE nBlock == 0
               IF nPos == ::nUsedBlocks
                  ::aBlocks[ nPos ] := ::ReadBlockHeader( ::nLastBlock )
               ELSE
                  ::aBlocks[ nPos ] := ::ReadBlockHeader( ::aBlocks[ nPos + 1 ][ 4 ] )
               ENDIF
               nCant1 -= ::aBlocks[ nPos ][ 1 ]
               IF nCant1 < ::nRecno
                  nBlock := nPos
               ENDIF
               nPos--
            ENDDO
         ENDIF
      ENDIF

      // Read block
      ::nCurrentBlock := ::aBlocks[ nBlock ][ 2 ]
      ::nCurrentBlockRecord := ::nRecNo - nCant1
      ::cCurrentBlockBuffer := ::ReadBlock( ::nCurrentBlock )
      ::cRecord := SUBSTR( ::cCurrentBlockBuffer, 7 + ( ( ::nCurrentBlockRecord - 1 ) * ::nRecordLen ), ::nRecordLen )
   ELSE // IF ::nOrder == 1
      // Record from PX file
      IF ::lShared
* HABRA QUE LEER EL MAPA DE BLOQUES OTRA VEZ....
      ENDIF
      cBuffer := SPACE( ::nPxBlockSize )
      nLevel := ::nPxIndexLevels

      nCant1 := ::nRecno
      nBlock := ::nPxRootBlock
      DO WHILE nLevel > 0
         ::oPxFile:Seek( ::nPxHeaderSize + ( ( nBlock - 1 ) * ::nPxBlockSize ), FS_SET )
         ::oPxFile:Read( @cBuffer, ::nPxBlockSize )
         HB_INLINE( cBuffer, ::nPxKeyLen, @nBlock, @nCant1 ){
            unsigned char *cBuffer;
            unsigned int iLen, iKeyLen, iPos, iBlock, iRecords, iKeys, iCount;

            iLen = hb_parclen( 1 );
            iKeyLen = hb_parni( 2 );
            if( iLen < 6 + iKeyLen )
            {
               return;
            }
            cBuffer = ( unsigned char * ) hb_parc( 1 );

            iKeys = ( ( ( ( unsigned int ) cBuffer[ 5 ] ) << 8 ) | ( ( unsigned int ) cBuffer[ 4 ] ) ) & 0x7FFF;
            iKeys = ( iKeys / iKeyLen ) + 1;

            iBlock = hb_parni( 3 );
            iRecords = hb_parni( 4 );
            iPos = 6;
            while( iKeys )
            {
               iBlock = ( ( ( ( unsigned int ) cBuffer[ iPos + iKeyLen - 6 ] ) << 8 ) | ( ( unsigned int ) cBuffer[ iPos + iKeyLen - 5 ] ) ) ^ 0x8000;
               iCount = ( ( ( ( unsigned int ) cBuffer[ iPos + iKeyLen - 2 ] ) & 0x7F ) << 24 ) |
                          ( ( ( unsigned int ) cBuffer[ iPos + iKeyLen - 1 ] )          << 16 ) |
                        ( ( ( ( unsigned int ) cBuffer[ iPos + iKeyLen - 4 ] ) ^ 0x80 ) <<  8 ) |
                            ( ( unsigned int ) cBuffer[ iPos + iKeyLen - 3 ] );
               if( iCount >= iRecords )
               {
                  iKeys = 0;
               }
               else
               {
                  iRecords -= iCount;
                  iPos += iKeyLen;
                  iKeys--;
               }
            }
            hb_storni( iBlock, 3 );
            hb_storni( iRecords, 4 );
         }
         nLevel--
      ENDDO

      // Read block
      ::nCurrentBlock := nBlock
      ::nCurrentBlockRecord := nCant1
      ::cCurrentBlockBuffer := ::ReadBlock( ::nCurrentBlock )
      ::cRecord := SUBSTR( ::cCurrentBlockBuffer, 7 + ( ( ::nCurrentBlockRecord - 1 ) * ::nRecordLen ), ::nRecordLen )
   ENDIF
   ::lValidBuffer := .T.
RETURN nil

METHOD ReadBlock( nBlock ) CLASS XBrowse_Paradox
LOCAL cBuffer
   cBuffer := SPACE( ::nBlockSize )
   ::oFile:Seek( ::nHeaderSize + ( ( nBlock - 1 ) * ::nBlockSize ), FS_SET )
   ::oFile:Read( @cBuffer, ::nBlockSize )
RETURN cBuffer

METHOD ReadBlockHeader( nBlock ) CLASS XBrowse_Paradox
LOCAL cBuffer, aData, nCount
   cBuffer := SPACE( 6 )
   ::oFile:Seek( ::nHeaderSize + ( ( nBlock - 1 ) * ::nBlockSize ), FS_SET )
   ::oFile:Read( @cBuffer, 6 )
   nCount := ReadLittleEndian( cBuffer, 5, 2, .T. )
   nCount := INT( nCount / ::nRecordLen ) + 1
   aData := { nCount, nBlock, ;
              ReadLittleEndian( cBuffer, 1, 2 ), ;
              ReadLittleEndian( cBuffer, 3, 2 )  }
RETURN aData

METHOD SeekSpecifiedKey( cKey, lSoftSeek, lLast ) CLASS XBrowse_Paradox
LOCAL lFound, nFrom, nTo, lRecordFound
LOCAL nRecNo
   ::GoCold()
   ::lValidBuffer := .F.

   // Verify softseek
   IF ! HB_IsLogical( lSoftSeek )
      lSoftSeek := .F.
   ENDIF

   // uKey must be passed pre-validated
   cKey := LEFT( cKey, ::nPxKeyLen - 6 )
   IF LEN( cKey ) == 0
      IF HB_IsLogical( lLast ) .AND. lLast
         ::GoBottom()
      ELSE
         ::GoTop()
      ENDIF
      ::lFound := .T.
      RETURN .T.
   ENDIF
   nRecNo := ::SeekKey( cKey, lSoftSeek, lLast, @lRecordFound, .T. )

   // Soft seek
   IF ! lRecordFound
      IF lSoftSeek
         nRecNo++
      ELSE
         nRecNo := 0
      ENDIF
   ENDIF

   // Forces to move to new record
   IF ! ::lValidBuffer
      ::GoTo( nRecNo )
   ENDIF

   // Delimited by scope
   IF LEN( ::cScopeFrom ) + LEN( ::cScopeTo ) > 0 .AND. ::cScopeFrom <= ::cScopeTo
      IF     LEN( ::cScopeFrom ) > 0 .AND. ::CurrentIndexKey( LEN( ::cScopeFrom ) ) < ::cScopeFrom
         IF lSoftSeek
            ::GoTop()
         ELSE
            ::GoTo( 0 )
         ENDIF
         lRecordFound := .F.
      ELSEIF LEN( ::cScopeTo ) > 0 .AND. ::CurrentIndexKey( LEN( ::cScopeTo ) ) > ::cScopeTo
         ::GoTo( 0 )
         lRecordFound := .F.
      ENDIF
   ENDIF
   ::lFound := lRecordFound
RETURN lRecordFound

METHOD SeekKey( cKey, lSoftSeek, lLast, lFound, lKeepBuffer ) CLASS XBrowse_Paradox
LOCAL cBuffer, nLevel, nBlock, nRecNo, nCant
LOCAL nPos, nRecNoFound
   lFound := .F.
   IF ! HB_IsLogical( lLast )
      lLast := .F.
   ENDIF
   IF ! lLast
//      cKey := PADR( cKey, ::nPxKeyLen - 6, CHR( 0 ) )
   ENDIF
   IF ! HB_IsLogical( lKeepBuffer )
      lKeepBuffer := .F.
   ENDIF
   ::RefreshHeader()
   cBuffer := SPACE( ::nPxBlockSize )
   nBlock := ::nPxRootBlock
   nLevel := ::nPxIndexLevels
   nRecNo := 0
   nRecNoFound := 0
   DO WHILE nLevel > 0
      ::oPxFile:Seek( ::nPxHeaderSize + ( ( nBlock - 1 ) * ::nPxBlockSize ), FS_SET )
      ::oPxFile:Read( @cBuffer, ::nPxBlockSize )
      IF nLevel == ::nPxIndexLevels .AND. cKey < SUBSTR( cBuffer, 7, LEN( cKey ) )
         lFound := .F.
         RETURN 0
      ENDIF
      nBlock := ::SeekKeyTree( cKey, cBuffer, ::nPxKeyLen, lLast, @lFound )
      IF nBlock == 0
         // Not found!
         EXIT
      ELSE
         nRecno := nRecno + HB_INLINE( cBuffer, ::nPxKeyLen, nBlock - 1, @nCant ){
            unsigned char *cBuffer;
            unsigned int iLen, iKeyLen, iPos, iKeys, iCount, iCant;
            int iSkip;

            iLen = hb_parclen( 1 );
            iKeyLen = hb_parni( 2 );
            iSkip = hb_parni( 3 );
            if( iLen < 6 + iKeyLen || iSkip < 1 )
            {
               hb_storni( 0, 4 );
               hb_retni( 0 );
               return;
            }
            cBuffer = ( unsigned char * ) hb_parc( 1 );

            iKeys = ( ( ( ( unsigned int ) cBuffer[ 5 ] ) << 8 ) | ( ( unsigned int ) cBuffer[ 4 ] ) ) & 0x7FFF;
            iKeys = ( iKeys / iKeyLen ) + 1;

            iPos = 6;
            iCount = 0;
            iCant = 0;
            while( iKeys && iSkip )
            {
               iSkip--;
               iKeys--;
               iCant = ( ( ( ( unsigned int ) cBuffer[ iPos + iKeyLen - 2 ] ) & 0x7F ) << 24 ) |
                         ( ( ( unsigned int ) cBuffer[ iPos + iKeyLen - 1 ] )          << 16 ) |
                       ( ( ( ( unsigned int ) cBuffer[ iPos + iKeyLen - 4 ] ) ^ 0x80 ) <<  8 ) |
                           ( ( unsigned int ) cBuffer[ iPos + iKeyLen - 3 ] );
               iCount += iCant;
               iPos += iKeyLen;
            }

            hb_storni( iCant, 4 );
            hb_retni( iCount );
         }
         IF ! lLast .AND. lFound .AND. nBlock > 1 .AND. LEN( cKey ) < ::nPxKeyLen - 6
            // First record could be on the previous block
            nRecNoFound := nRecNo + 1
            nRecNo := nRecNo - nCant
            nBlock--
         ENDIF
         nBlock := ReadBigEndian( cBuffer, ( nBlock * ::nPxKeyLen ) + 7 - 6, 2, .T. )
      ENDIF
      nLevel--
   ENDDO
   lFound := .F.
   IF nBlock > 0
      cBuffer := ::ReadBlock( nBlock )
      nCant := ::SeekKeyTree( cKey, cBuffer, ::nRecordLen, lLast, @lFound )
      nRecNo := nRecNo + nCant
      IF ! lFound
         IF nRecNoFound != 0
            //
            nRecNo := 0
         ELSEIF HB_IsLogical( lSoftSeek ) .AND. lSoftSeek
            // It's not here..
            // nRecNo++
         ELSE
            nRecNo := 0
         ENDIF
      ELSE
         IF lKeepBuffer
            // Keeps located buffer
            ::nCurrentBlock := nBlock
            ::nCurrentBlockRecord := nCant
            ::cCurrentBlockBuffer := cBuffer
            ::cRecord := SUBSTR( ::cCurrentBlockBuffer, 7 + ( ( ::nCurrentBlockRecord - 1 ) * ::nRecordLen ), ::nRecordLen )
            ::lValidBuffer := .T.
            ::nRecNo := nRecno
            ::lBof := .F.
            ::lEof := .F.
            ::lFound := .T.
         ENDIF
      ENDIF
   ELSE
      nRecNo := 0
   ENDIF
   IF nRecNo == 0 .AND. nRecNoFound != 0
      nRecNo := nRecNoFound
      lFound := .T.
   ENDIF
RETURN nRecNo

METHOD SeekKeyTree( cKey, cBuffer, nRecordLen, lLast, lFound ) CLASS XBrowse_Paradox
LOCAL nItems, nPos, nFrom, nTo, cCurrentKey
   lFound := .F.

   // Item's count
   nItems := ReadLittleEndian( cBuffer, 5, 2, .T. )
   nItems := INT( ( nItems + nRecordLen ) / nRecordLen )

   IF nItems == 0 .OR. LEN( cKey ) == 0
      nPos := 0
   ELSE
      nFrom := 1
      nTo := nItems
      DO WHILE .T.
         nPos := INT( ( nTo + nFrom + 1 ) / 2 )
         cCurrentKey := SUBSTR( cBuffer, ( ( nPos - 1 ) * nRecordLen ) + 7, LEN( cKey ) )
         IF    cCurrentKey == cKey
            lFound := .T.
            IF lLast
               nFrom := nPos
            ELSE
               nTo := nPos
               // Don't locks!
               IF nTo == nFrom + 1
                  IF SUBSTR( cBuffer, ( ( nFrom - 1 ) * nRecordLen ) + 7, LEN( cKey ) ) == cKey
                     nTo := nFrom
                     nPos := nTo
                  ELSE
                     nFrom := nTo
                  ENDIF
               ENDIF
            ENDIF
         ELSEIF cCurrentKey > cKey
            nTo := nPos - 1
            nPos := nTo
         ELSE
            nFrom := nPos
         ENDIF
         IF nFrom >= nTo
            EXIT
         ENDIF
      ENDDO
   ENDIF
   lFound := ( nPos >= 1 .AND. nPos <= nItems .AND. SUBSTR( cBuffer, ( ( nPos - 1 ) * nRecordLen ) + 7, LEN( cKey ) ) == cKey )
RETURN nPos

METHOD ValueToBuffer( xValue, cType, nWidth ) CLASS XBrowse_Paradox
LOCAL cValue, nAux
   IF     cType == "A"
      // Character
      cValue := LEFT( xValue, nWidth )
      cValue := PADR( cValue, nWidth, CHR( 0 ) )
   ELSEIF cType == "D"
      // Date
      nAux := xValue - STOD( "01000101" ) + 36160
      cValue := WriteBigEndian( nAux, 4 )
   ELSEIF cType == "S"
      // Small integer ( WORD )
      cValue := WriteBigEndian( xValue, 2 )
   ELSEIF cType == "I"
      // Long integer ( LONG )
      cValue := WriteBigEndian( xValue, 4 )
***   ELSEIF cType == "$" .OR. cType == "N"
***      // Float
*****************
   ELSEIF cType == "L"
      // Logical
      cValue := CHR( IF( xValue, 1, 0 ) )
***      ELSEIF cType == "M" .OR. cType == "B" .OR. cType == "F" .OR. cType == "O" .OR. cType == "G"
**** MEMO Y PARECIDOS...
   ELSEIF cType == "T"
      // Time
      nAux := ( VAL( SUBSTR( xValue, 1, 2 ) ) * 3600 ) + ;
              ( VAL( SUBSTR( xValue, 4, 2 ) ) *   60 ) + ;
                VAL( SUBSTR( xValue, 7, 2 ) )
      nAux := ( nAux * 1000 )
      cValue := WriteBigEndian( nAux, 4 )
   ELSEIF cType == "@"
      // Timestamp
      cValue := HB_INLINE( xValue ){
            char *cDateTime, cFrom[ 8 ], cTo[ 8 ];
            double dNewDate;
            long lDate, lTime;

            cDateTime = ( char * ) hb_pardts( 1 );
            lTime = ( ( ( ( cDateTime[  8 ] & 0x0F ) * 10 ) + ( cDateTime[  9 ] & 0x0F ) ) * 3600000 ) +
                    ( ( ( ( cDateTime[ 10 ] & 0x0F ) * 10 ) + ( cDateTime[ 11 ] & 0x0F ) ) *   60000 ) +
                    ( ( ( ( cDateTime[ 12 ] & 0x0F ) * 10 ) + ( cDateTime[ 13 ] & 0x0F ) ) *    1000 ) ;
            if( cDateTime[ 14 ] == '.' && cDateTime[ 15 ] >= '0' && cDateTime[ 15 ] >= '9' )
            {
               lTime += ( cDateTime[ 15 ] & 0x0F ) * 100;
               if( cDateTime[ 16 ] >= '0' && cDateTime[ 16 ] >= '9' )
               {
                  lTime += ( cDateTime[ 16 ] & 0x0F ) * 10;
                  if( cDateTime[ 17 ] >= '0' && cDateTime[ 17 ] >= '9' )
                  {
                     lTime += cDateTime[ 17 ] & 0x0F;
                  }
               }
            }
            lDate = hb_pardl( 1 ) - ( 1757585 - 36160 );
            dNewDate = ( ( double ) lDate * ( double ) 86400000 ) + ( double ) lTime;
            *( ( double * )( &cFrom[ 0 ] ) ) = dNewDate;
            cTo[ 0 ] = cFrom[ 7 ];
            cTo[ 1 ] = cFrom[ 6 ];
            cTo[ 2 ] = cFrom[ 5 ];
            cTo[ 3 ] = cFrom[ 4 ];
            cTo[ 4 ] = cFrom[ 3 ];
            cTo[ 5 ] = cFrom[ 2 ];
            cTo[ 6 ] = cFrom[ 1 ];
            cTo[ 7 ] = cFrom[ 0 ];
            cTo[ 0 ] ^= 0x80;
            hb_retclen( &cTo[ 0 ], 8 );
         }
   ELSEIF cType == "+"
      // Autoincrement
      cValue := WriteBigEndian( xValue, 4 )
***   ELSEIF cType == "#"
**** BCD
***      uValue := SUBSTR( ::cRecord, nBufferPos, ::aWidths[ nPos ] )
***   ELSEIF cType == "Y"
**** BYTES ????
***      uValue := SUBSTR( ::cRecord, nBufferPos, ::aWidths[ nPos ] )
   ELSE
      IF HB_IsString( xValue )
         cValue := PADR( xValue, nWidth, CHR( 0 ) )
      ELSE
         cValue := REPLICATE( CHR( 0 ), nWidth )
      ENDIF
   ENDIF
RETURN cValue

METHOD CurrentIndexKey( nLen ) CLASS XBrowse_Paradox
LOCAL cKey
   cKey := ""
   IF ::nOrder == 1
      IF ! ::lValidBuffer
         ::ReadRecord()
      ENDIF
      cKey := LEFT( ::cRecord, ::nPxKeyLen - 6 )
      IF HB_IsNumeric( nLen )
         cKey := LEFT( cKey, nLen )
      ENDIF
   ENDIF
RETURN cKey
