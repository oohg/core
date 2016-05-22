/*
 * $Id: textfile.prg,v 1.5 2016-05-22 23:53:21 fyurisich Exp $
 */
/*
 * ooHGRecord textfile-as-database demo. (c) 2010-2016 Vic
 * This demo reads a text file as a sequential database
 * using a textfile-as-database class.
 */

#ifndef NO_SAMPLE

#include "oohg.ch"
#include "hbcompat.ch"

PROCEDURE Main
Local oTable, aStructure
Local nHdl, cFile := "TestFile.txt"

   nHdl := FCREATE( cFile )
   FWRITE( nHdl, "  1,Text,One" + CHR( 13 ) + CHR( 10 ) )
   FWRITE( nHdl, "2,Number,1" + CHR( 13 ) + CHR( 10 ) )
   FWRITE( nHdl, "003,Padded,001" + CHR( 13 ) + CHR( 10 ) )
   FWRITE( nHdl, "-4,Negative,-1" + CHR( 13 ) + CHR( 10 ) )
   FCLOSE( nHdl )

   aStructure := { { "Line", "N" }, ;
                   { "Key" },       ;
                   { "Value" }      }

   DEFINE WINDOW Main WIDTH 400 HEIGHT 400 CLIENTAREA ;
                 TITLE "Textfile-as-database Sample"

      @ 10,10 GRID Grid WIDTH 380 HEIGHT 380 ;
              HEADERS { "Line", "Key", "Value" } ;
              WIDTHS { 100, 100, 100 } ;
              JUSTIFY ;
              { GRID_JTFY_CENTER , GRID_JTFY_RIGHT , GRID_JTFY_LEFT } ;

      oTable := ooTextFile():New( cFile, aStructure, "," )
      oTable:GoTop()
      DO WHILE ! oTable:Eof()
         Main.Grid.AddItem( { LTRIM( STR( oTable:Line ) ), ;
                              oTable:Key, ;
                              oTable:Value } )
         oTable:Skip()
      ENDDO
      oTable:Close()

   END WINDOW
   ACTIVATE WINDOW Main

RETURN

#endif   // #ifndef NO_SAMPLE

#include "hbclass.ch"
#include "fileio.ch"

/*
 *  This is a template for ooHGRecord's subclasses (database class used
 *  by XBrowse).
 */

/*
 *  NOTE: This class doesn't works on a XBROWSE control!
 *  It's only a "looks-alike" class.
 */

*-----------------------------------------------------------------------------*
CLASS ooTextFile
*-----------------------------------------------------------------------------*
   // Methods always used by XBrowse
*   METHOD Skipper
   METHOD GoTop
*   METHOD GoBottom

   // Methods used by XBrowse if you'll have a scrollbar
   METHOD RecNo              BLOCK { | Self | ::nRecNo }
   METHOD RecCount           BLOCK { | Self | ::nRecNo - IF( ::Eof, 1, 0 ) }
*   METHOD GoTo
   METHOD OrdKeyNo           BLOCK { | Self | ::nRecNo }
   METHOD OrdKeyCount        BLOCK { | Self | ::nRecNo - IF( ::Eof, 1, 0 ) }
*   METHOD OrdKeyGoTo

   // Methods used by XBrowse if you'll allow edition
   DATA cAlias__             INIT nil
   METHOD Eof                BLOCK { | Self | ::lEof }

   // Used by "own" (ooTextFile) class (not used by XBrowse itself)
   DATA nRecNo               INIT 1
   DATA nHandle              INIT 0
   DATA aStructure           INIT {}
   DATA cDelimiter           INIT ""
   DATA nRecordWidth         INIT 0
   DATA lEof                 INIT .F.
   DATA aFields              INIT {}
   DATA nTopOffset           INIT 0
   METHOD New
   METHOD ReadHeader
   METHOD ReadRecord
   METHOD ReadData
   METHOD Text2Data

   // Implemented but not used for this sample (not used by XBrowse itself)
   MESSAGE Use               METHOD New
   METHOD Skip
   METHOD Bof                INLINE .F.
   METHOD Close
   METHOD FieldGet( nPos )   BLOCK { | Self, nPos | IF( HB_IsNumeric( nPos ) .AND. nPos >= 1 .AND. LEN( ::aFields ) >= nPos, ::aFields[ nPos ], "" ) }
*   METHOD FieldPut
   METHOD FieldPos
   METHOD FieldBlock
   METHOD Field( nPos )      BLOCK { | Self, nPos | IF( HB_IsNumeric( nPos ) .AND. nPos >= 1 .AND. LEN( ::aStructure ) >= nPos, ::aStructure[ nPos ][ 1 ], "" ) }
   METHOD FieldName( nPos )  BLOCK { | Self, nPos | IF( HB_IsNumeric( nPos ) .AND. nPos >= 1 .AND. LEN( ::aStructure ) >= nPos, ::aStructure[ nPos ][ 1 ], "" ) }

   ERROR HANDLER FieldAssign
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD GoTop() CLASS ooTextFile
*-----------------------------------------------------------------------------*
   FSEEK( ::nHandle, ::nTopOffset, FS_SET )
   ::lEof := .F.
   ::nRecNo := 1
   ::ReadRecord()
RETURN nil

// Database methods not implemented (not used by XBrowse)
*   METHOD OrdScope
*   METHOD Filter

*   METHOD Locate     BLOCK { | Self, bFor, bWhile, nNext, nRec, lRest | ( ::cAlias__ )->( __dbLocate( bFor, bWhile, nNext, nRec, lRest ) ) }
*   METHOD Seek       BLOCK { | Self, uKey, lSoftSeek, lLast | ( ::cAlias__ )->( DbSeek( uKey, lSoftSeek, lLast ) ) }
*   METHOD Commit     BLOCK { | Self |                         ( ::cAlias__ )->( DbCommit() ) }
*   METHOD Unlock     BLOCK { | Self |                         ( ::cAlias__ )->( DbUnlock() ) }
*   METHOD Delete     BLOCK { | Self |                         ( ::cAlias__ )->( DbDelete() ) }
*   METHOD Found      BLOCK { | Self |                         ( ::cAlias__ )->( Found() ) }
*   METHOD SetOrder   BLOCK { | Self, uOrder |                 ( ::cAlias__ )->( ORDSETFOCUS( uOrder ) ) }
*   METHOD SetIndex   BLOCK { | Self, cFile, lAdditive |       IF( EMPTY( lAdditive ), ( ::cAlias__ )->( ordListClear() ), ) , ( ::cAlias__ )->( ordListAdd( cFile ) ) }
*   METHOD Append     BLOCK { | Self |                         ( ::cAlias__ )->( DbAppend() ) }
*   METHOD Lock       BLOCK { | Self |                         ( ::cAlias__ )->( RLock() ) }
*   METHOD DbStruct   BLOCK { | Self |                         ( ::cAlias__ )->( DbStruct() ) }

*-----------------------------------------------------------------------------*
METHOD New( cFile, aStructure, cDelimiter, xHeaderParameter ) CLASS ooTextFile
*-----------------------------------------------------------------------------*
LOCAL nHandle, I, aStructure2, nWidth, lFreeWidth
   // Validate delimiter
   IF HB_IsString( cDelimiter ) .AND. ! EMPTY( cDelimiter )
      ::cDelimiter := ALLTRIM( cDelimiter )
   ELSE
      ::cDelimiter := ""
   ENDIF

   // Validate structure
   nWidth := 0
   lFreeWidth := .F.
   ::aStructure := {}
   IF HB_IsArray( aStructure )
      FOR I := 1 TO LEN( aStructure )
         aStructure2 := {}
         IF HB_IsString( aStructure[ I ] ) .AND. ! EMPTY( aStructure[ I ] )
            aStructure2 := { UPPER( ALLTRIM( aStructure[ I ][ 1 ] ) ) }
         ELSEIF HB_IsArray( aStructure[ I ] )
            IF LEN( aStructure[ I ] ) > 0 .AND. HB_IsString( aStructure[ I ][ 1 ] )
               aStructure2 := { UPPER( ALLTRIM( aStructure[ I ][ 1 ] ) ) }
               IF LEN( aStructure[ I ] ) >= 2 .AND. HB_IsString( aStructure[ I ][ 2 ] ) .AND. ! EMPTY( aStructure[ I ][ 2 ] ) .AND. UPPER( LEFT( ALLTRIM( aStructure[ I ][ 2 ] ), 1 ) ) $ "CNLD"
                  AADD( aStructure2, UPPER( LEFT( ALLTRIM( aStructure[ I ][ 2 ] ), 1 ) ) )
                  IF LEN( aStructure[ I ] ) >= 3 .AND. HB_IsNumeric( aStructure[ I ][ 3 ] ) .AND. aStructure[ I ][ 3 ] >= 1
                     AADD( aStructure2, INT( aStructure[ I ][ 3 ] ) )
                     IF LEN( aStructure[ I ] ) >= 4 .AND. HB_IsNumeric( aStructure[ I ][ 4 ] ) .AND. aStructure[ I ][ 4 ] >= 0 .AND. aStructure[ I ][ 2 ] == "N" .AND. aStructure[ I ][ 4 ] <= aStructure[ I ][ 3 ]
                        AADD( aStructure2, INT( aStructure[ I ][ 4 ] ) )
                     ENDIF
                  ENDIF
               ELSE
                  AADD( aStructure2, "C" )
               ENDIF
            ENDIF
         ENDIF
         IF ! EMPTY( aStructure2 )
            AADD( ::aStructure, aStructure2 )
            IF LEN( aStructure2 ) >= 3 .AND. aStructure2[ 3 ] > 0
               nWidth += aStructure2[ 3 ]
            ELSE
               lFreeWidth := .T.
            ENDIF
         ENDIF
      NEXT
   ENDIF

   IF lFreeWidth .AND. EMPTY( ::cDelimiter ) .AND. LEN( ::aStructure ) > 1
      // Record is not delimited and it doesn't contains any width
      RETURN nil
   ENDIF

   IF ! EMPTY( ::cDelimiter ) .OR. lFreeWidth .OR. LEN( ::aStructure ) == 0
      nWidth := ::nRecordWidth
   ENDIF
   ::nRecordWidth := nWidth

   // Open file
   nHandle := FOPEN( cFile, FO_READ + FO_SHARED )
   IF nHandle < 1
      // Can't open file
      RETURN nil
   ENDIF
   ::nHandle := nHandle

   // Header's initialization
   IF ! ::ReadHeader( xHeaderParameter )
      FCLOSE( nHandle )
      ::nHandle := 0
      RETURN nil
   ENDIF

   // Initializes values

   // TOF
   ::nTopOffset := FSEEK( ::nHandle, 0, FS_RELATIVE )

   // Read first record
   ::GoTop()

RETURN Self

*-----------------------------------------------------------------------------*
METHOD ReadHeader( xHeaderParameter ) CLASS ooTextFile
*-----------------------------------------------------------------------------*
LOCAL aHeaders, nField, aBakStructure
   // This method would allow to read an special header
   //
   // For this class, it takes fields' name from first line
   // ONLY when "xHeaderParameter" is .T.
   IF HB_IsLogical( xHeaderParameter ) .AND. xHeaderParameter
      aHeaders := {}
      aBakStructure := ::aStructure
      IF LEN( ::aStructure ) > 0
         ::aStructure := ARRAY( LEN( aBakStructure ) )
         AEVAL( ::aStructure, { |a,i| a , ::aStructure[ i ] := { aBakStructure[ i ][ 1 ], "C" } } )
         AEVAL( ::aStructure, { |a,i| IF( LEN( aBakStructure[ i ] ) >= 3, AADD( a, aBakStructure[ i ][ 3 ] ), ) } )
      ENDIF
      ::ReadRecord( aHeaders )
      ::aStructure := aBakStructure
      nField := 1
      DO WHILE nField <= LEN( aHeaders ) .AND. HB_IsString( aHeaders[ nField ] ) .AND. ! EMPTY( aHeaders[ nField ] )
         IF LEN( ::aStructure ) < nField
            AADD( ::aStructure, { "" } )
         ENDIF
         ::aStructure[ nField ][ 1 ] := UPPER( ALLTRIM( aHeaders[ nField ] ) )
         nField++
      ENDDO
   ENDIF
RETURN .T.

*-----------------------------------------------------------------------------*
METHOD ReadRecord( aFields ) CLASS ooTextFile
*-----------------------------------------------------------------------------*
LOCAL lData, cBuffer, nPos, nCant, nOffset, nEolLen
   IF ! HB_IsArray( aFields )
      aFields := ::aFields
   ENDIF
   lData := .F.
   IF ::nHandle > 0
      nOffset := FSEEK( ::nHandle, 0, FS_RELATIVE )
      cBuffer := SPACE( IF( ::nRecordWidth == 0, 1024, ::nRecordWidth + 1 ) )
      nCant := FREAD( ::nHandle, @cBuffer, LEN( cBuffer ) )
      IF nCant > 0
         lData := .T.
         nPos := SearchEol( cBuffer, nCant, @nEolLen )
         IF nPos > 0
            ::ReadData( cBuffer, nPos - 1, aFields )
            IF nCant > nPos + nEolLen
               FSEEK( ::nHandle, nOffset + nPos + nEolLen - 1, FS_SET )
            ENDIF
         ELSE
            ::ReadData( cBuffer, nCant, aFields )
            // Looks for EOL
            DO WHILE nCant == LEN( cBuffer )
               nOffset := nOffset + nCant
               nCant := FREAD( ::nHandle, @cBuffer, LEN( cBuffer ) )
               nPos := SearchEol( cBuffer, nCant, @nEolLen )
               IF nPos > 0
                  IF nCant > nPos + nEolLen
                     FSEEK( ::nHandle, nOffset + nPos + nEolLen - 1, FS_SET )
                  ENDIF
                  EXIT
               ENDIF
            ENDDO
         ENDIF
      ENDIF
   ENDIF
   IF ! lData
      ::lEof := .T.
      // Empty record
      ::ReadData( "", 0, aFields )
   ENDIF
RETURN lData

STATIC FUNCTION SearchEol( cBuffer, nCant, nEolLen )
LOCAL nPos
   nPos := AT( HB_OSNEWLINE(), cBuffer )
   IF nPos > nCant
      nPos := 0
   ENDIF
   nPos2 := AT( CHR( 10 ), cBuffer )
   IF nPos2 > nCant
      nPos := 0
   ENDIF
   nEolLen := LEN( HB_OSNEWLINE() )
   IF nPos == 0 .OR. ( nPos2 > 0 .AND. nPos2 < nPos )
      nPos := nPos2
      nEolLen := 1
   ENDIF
RETURN nPos

*-----------------------------------------------------------------------------*
METHOD ReadData( cBuffer, nLen, aData ) CLASS ooTextFile
*-----------------------------------------------------------------------------*
LOCAL nPos, nLastPos, xItem, nField
   IF ! HB_IsArray( aData )
      aData := {}
   ENDIF
   IF ! HB_IsNumeric( nLen )
      nLen := LEN( cBuffer )
   ENDIF
   nLen := MIN( nLen, LEN( cBuffer ) )
   nPos := 1
   IF ! EMPTY( ::cDelimiter )
      // Delimited text
      ASIZE( aData, 0 )
      nField := 0
      DO WHILE nPos <= nLen
         nField++
         nLastPos := nPos
         nPos := AT( ::cDelimiter, cBuffer, nLastPos, nLen )
         IF nPos == 0
            nPos := nLen + 1
         ENDIF
         xItem := SUBSTR( cBuffer, nLastPos, nPos - nLastPos )
         IF LEN( ::aStructure ) >= nField
            xItem := ::Text2Data( xItem, ::aStructure[ nField ] )
         ENDIF
         AADD( aData, xItem )
         nPos += LEN( ::cDelimiter )
      ENDDO
      DO WHILE nField < LEN( ::aStructure )
         nField++
         AADD( aData, ::Text2Data( "", ::aStructure[ nField ] ) )
      ENDDO
   ELSE
      // Fixed width
      ASIZE( aData, MAX( LEN( ::aStructure ), 1 ) )
      IF LEN( ::aStructure ) == 0
         aData[ 1 ] := LEFT( cBuffer, nLen )
      ELSEIF LEN( ::aStructure ) == 1 .AND. LEN( ::aStructure[ 1 ] ) <= 2
         aData[ 1 ] := ::Text2Data( LEFT( cBuffer, nLen ), ::aStructure[ 1 ] )
      ELSE
         FOR nField := 1 TO LEN( ::aStructure )
            IF nPos <= nLen
               xData := SUBSTR( cBuffer, nPos, MIN( nLen + 1 - nPos, ::aStructure[ nField ][ 3 ] ) )
               nPos += ::aStructure[ nField ][ 3 ]
            ELSE
               xData := ""
            ENDIF
            aData[ nField ] := ::Text2Data( xData, ::aStructure[ nField ] )
         NEXT
         IF nPos <= nLen
            AADD( aData, SUBSTR( cBuffer, nPos, nLen + 1 - nPos ) )
         ENDIF
      ENDIF
   ENDIF
RETURN aData

*-----------------------------------------------------------------------------*
METHOD Text2Data( xItem, aStructure ) CLASS ooTextFile
*-----------------------------------------------------------------------------*
   IF HB_IsArray( aStructure ) .AND. LEN( aStructure ) >= 2
      DO CASE
         CASE aStructure[ 2 ] == "D"
            xItem := ALLTRIM( xItem )
            IF "/" $ xItem .OR. "-" $ xItem
               xData := CTOD( xItem )
            ELSE
               xItem := STOD( xItem )
            ENDIF
         CASE aStructure[ 2 ] == "L"
            xItem := ( ! EMPTY( xItem ) .AND. LEFT( ALLTRIM( xItem ), 1 ) $ "TtYy*Ss" )
         CASE aStructure[ 2 ] == "N"
            xItem := ALLTRIM( xItem )
            IF LEFT( xItem, 2 ) == "- "
               xItem := "-" + LTRIM( SUBSTR( xItem, 2 ) )
            ENDIF
            IF LEN( aStructure ) >= 4 .AND. aStructure[ 4 ] > 0 .AND. ! ( "." $ xItem )
               xItem := LEFT( xItem, LEN( xItem ) - aStructure[ 4 ] ) + "." + RIGHT( xItem, aStructure[ 4 ] )
            ENDIF
            xItem := VAL( xItem )
         OTHERWISE // CASE aStructure[ 2 ] == "C"
            IF LEN( aStructure ) >= 3 .AND. aStructure[ 3 ] > 0
               xItem := PADR( xItem, aStructure[ 3 ] )
            ENDIF
      ENDCASE
   ENDIF
RETURN xItem

*-----------------------------------------------------------------------------*
METHOD Skip( nSkip ) CLASS ooTextFile
*-----------------------------------------------------------------------------*
   IF ! HB_IsNumeric( nSkip )
      nSkip := 1
   ENDIF
   nSkip := INT( nSkip )
   DO WHILE nSkip > 0
      IF ! ::ReadRecord()
         EXIT
      ENDIF
      ::nRecNo++
      nSkip--
   ENDDO
RETURN nil

*-----------------------------------------------------------------------------*
METHOD Close() CLASS ooTextFile
*-----------------------------------------------------------------------------*
   IF ::nHandle > 0
      FCLOSE( ::nHandle )
      ::lEof := .T.
      ::ReadData( "", 0, ::aFields )
   ENDIF
RETURN nil

*-----------------------------------------------------------------------------*
METHOD FieldPos( cField ) CLASS ooTextFile
*-----------------------------------------------------------------------------*
   cField := UPPER( cField )
RETURN ASCAN( ::aStructure, { |a| a[ 1 ] == cField } )

*-----------------------------------------------------------------------------*
METHOD FieldBlock( nPos ) CLASS ooTextFile
*-----------------------------------------------------------------------------*
RETURN { | uValue | IF( PCOUNT() > 0, ::FieldPut( nPos, uValue ), ::FieldGet( nPos ) ) }

*-----------------------------------------------------------------------------*
METHOD FieldAssign( xValue ) CLASS ooTextFile
*-----------------------------------------------------------------------------*
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
