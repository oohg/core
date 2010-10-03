/*
 * $Id: oosql.prg,v 1.1 2010-10-03 01:28:09 guerra000 Exp $
 */
/*
 *  TMySqlServer's layer for use with XBROWSE control.
 */

#include "hbclass.ch"

*-----------------------------------------------------------------------------*
CLASS ooMySql
*-----------------------------------------------------------------------------*
   // Methods always used by XBrowse
   METHOD Skipper
   DELEGATE GoTop            TO oQuery
   DELEGATE GoBottom         TO oQuery

   // Methods used by XBrowse if you'll have a scrollbar
   DELEGATE RecNo            TO oQuery
   METHOD RecCount           INLINE ::oQuery:LastRec()
   DELEGATE GoTo             TO oQuery
   METHOD OrdKeyNo           INLINE ::oQuery:RecNo()
   METHOD OrdKeyCount        INLINE ::oQuery:LastRec()
   METHOD OrdKeyGoTo( n )    BLOCK { | Self, n | ::oQuery:Goto( n ) }

   // Methods used by XBrowse if you'll allow edition
   DATA cAlias__             INIT nil
   DELEGATE Eof              TO oQuery

   // MySql "interaface" (not used by XBrowse itself)
   DELEGATE Refresh          TO oQuery
   DELEGATE GetRow           TO oQuery

   // Used by "own" class (not used by XBrowse itself)
   DATA oQuery
   METHOD New( oQuery )      BLOCK { | Self, oQuery | ::oQuery := oQuery , Self }
   DELEGATE DbStruct         TO oQuery
   DELEGATE FieldGet         TO oQuery
   DELEGATE FieldPut         TO oQuery
   METHOD Use( oQuery )      BLOCK { | Self, oQuery | ::oQuery := oQuery , Self }
   DELEGATE Skip             TO oQuery
   DELEGATE Bof              TO oQuery
   METHOD Field( n )         BLOCK { | Self, n | ::oQuery:FieldName( n ) }
   DELEGATE FieldName        TO oQuery
   DELEGATE FieldPos         TO oQuery
   DELEGATE LastRec          TO oQuery
   METHOD FieldBlock

   ERROR HANDLER FieldAssign
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Skipper( nSkip ) CLASS ooMySql
*-----------------------------------------------------------------------------*
LOCAL nCount := 0
   nSkip := INT( nSkip )
   IF nSkip > 0
      DO WHILE nSkip > 0
         ::Skip( 1 )
         IF ::Eof
            ::Skip( -1 )
            EXIT
         ENDIF
         nCount++
         nSkip--
      ENDDO
   ELSE
      DO WHILE nSkip < 0
         ::Skip( -1 )
         IF ::Bof
            EXIT
         ENDIF
         nCount--
         nSkip++
      ENDDO
   ENDIF
RETURN nCount

*-----------------------------------------------------------------------------*
METHOD FieldBlock( nPos ) CLASS ooMySql
*-----------------------------------------------------------------------------*
RETURN { | _x_ | IF( PCOUNT() > 0 , ::oQuery:FieldPut( nPos, _x_ ) , ::oQuery:FieldGet( nPos ) ) }

*-----------------------------------------------------------------------------*
METHOD FieldAssign( xValue ) CLASS ooMySql
*-----------------------------------------------------------------------------*
LOCAL nPos, cMessage, uRet, lError
   cMessage := ALLTRIM( UPPER( __GetMessage() ) )
   lError := .T.
   IF PCOUNT() == 0
      nPos := ::oQuery:FieldPos( cMessage )
      IF nPos > 0
         uRet := ::oQuery:FieldGet( nPos )
         lError := .F.
      ENDIF
   ELSEIF PCOUNT() == 1
      nPos := ::oQuery:FieldPos( SUBSTR( cMessage, 2 ) )
      IF nPos > 0
         uRet := ::oQuery:FieldPut( nPos, xValue )
         lError := .F.
      ENDIF
   ENDIF
   IF lError
      uRet := NIL
      ::MsgNotFound( cMessage )
   ENDIF
RETURN uRet

// Database methods not implemented (not used by XBrowse)
*   METHOD OrdScope
*   METHOD Filter

*   METHOD Locate     BLOCK { | Self, bFor, bWhile, nNext, nRec, lRest | ( ::cAlias__ )->( __dbLocate( bFor, bWhile, nNext, nRec, lRest ) ) }
*   METHOD Seek       BLOCK { | Self, uKey, lSoftSeek, lLast | ( ::cAlias__ )->( DbSeek( uKey, lSoftSeek, lLast ) ) }
*   METHOD Commit     BLOCK { | Self |                         ( ::cAlias__ )->( DbCommit() ) }
*   METHOD Unlock     BLOCK { | Self |                         ( ::cAlias__ )->( DbUnlock() ) }
*   METHOD Delete     BLOCK { | Self |                         ( ::cAlias__ )->( DbDelete() ) }
*   METHOD Close      BLOCK { | Self |                         ( ::cAlias__ )->( DbCloseArea() ) }
*   METHOD Found      BLOCK { | Self |                         ( ::cAlias__ )->( Found() ) }
*   METHOD SetOrder   BLOCK { | Self, uOrder |                 ( ::cAlias__ )->( ORDSETFOCUS( uOrder ) ) }
*   METHOD SetIndex   BLOCK { | Self, cFile, lAdditive |       IF( EMPTY( lAdditive ), ( ::cAlias__ )->( ordListClear() ), ) , ( ::cAlias__ )->( ordListAdd( cFile ) ) }
*   METHOD Append     BLOCK { | Self |                         ( ::cAlias__ )->( DbAppend() ) }
*   METHOD Lock       BLOCK { | Self |                         ( ::cAlias__ )->( RLock() ) }
