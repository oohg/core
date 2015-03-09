/*
 * $Id: brw_odbc.prg,v 1.5 2015-03-09 02:52:06 fyurisich Exp $
 */
/*
 * ooHG XBrowse ODBC demo. (c) 2008-2015 Vic
 * This demo shows how to use XBrowse for show an ODBC query.
 * It includes an "ODBC-as-ooHGRecord" object.
 */

#ifndef NO_SAMPLE

#include "oohg.ch"

PROCEDURE Main
Local oODBC, oBrw, I

   oODBC := TODBC():New( ;
            "DBQ=bd1.mdb;" + ;
            "Driver={Microsoft Access Driver (*.mdb)}" )

   oODBC:SetSQL( "SELECT * FROM table1" )

   IF ! oODBC:Open()
      RETURN
   ENDIF

   oBrw := XBrowse_ODBC():New( oODBC )

   DEFINE WINDOW Main WIDTH 400 HEIGHT 400 CLIENTAREA ;
                 TITLE "ODBC Browse Sample"
       @ 10,10 XBROWSE Brw WIDTH 380 HEIGHT 380 ;
               WORKAREA ( oBrw ) ;
               HEADERS { "Center", "Right", "Left" } ;
               WIDTHS { 100, 100, 100 } ;
               FIELDS { { |o| o:FieldGet( 1 ) } , ;
                        { |o| o:FieldGet( 1 ) } , ;
                        { |o| o:FieldGet( 1 ) } } ;
               JUSTIFY ;
               { GRID_JTFY_CENTER , GRID_JTFY_RIGHT , GRID_JTFY_LEFT } ;
               ; // Edition
               EDIT INPLACE ;
               REPLACEFIELD { { |x,o| o:FieldPut( 1, x ) } , ;
                              { |x,o| o:FieldPut( 1, x ) } , ;
                              { |x,o| o:FieldPut( 1, x ) } }
   END WINDOW
   ACTIVATE WINDOW Main

   oODBC:Destroy()

RETURN

#endif   // #ifndef NO_SAMPLE

#include "hbclass.ch"

/*
 *  This is a template for ooHGRecord's subclasses (database class used
 *  by XBrowse).
 *
 *  All methods are defined specifically for XBrowse_ODBC. If you create
 *  your own class, you must define them for your own requirements.
 */

*-----------------------------------------------------------------------------*
CLASS XBrowse_ODBC
*-----------------------------------------------------------------------------*
   // Methods always used by XBrowse
   METHOD Skipper
   METHOD GoTop              BLOCK { | Self | ::oODBC:First() }
   METHOD GoBottom           BLOCK { | Self | ::oODBC:Last() }

   // Methods used by XBrowse if you'll have a scrollbar
   METHOD RecNo              BLOCK { | Self | ::oODBC:RecNo }
   METHOD RecCount           BLOCK { | Self | ::oODBC:RecCount }
   METHOD GoTo( n )          BLOCK { | Self, n | ::oODBC:GoTo( n ) }
   METHOD OrdKeyNo           BLOCK { | Self | ::oODBC:RecNo }
   METHOD OrdKeyCount        BLOCK { | Self | ::oODBC:RecCount }
   METHOD OrdKeyGoTo( n )    BLOCK { | Self, n | ::oODBC:GoTo( n ) }

   // Methods used by XBrowse if you'll allow edition
   DATA cAlias__             INIT nil
   METHOD Eof                BLOCK { | Self | ::oODBC:Eof }

   // Used by "own" (XBrowse_ODBC) class (not used by XBrowse itself)
   DATA oODBC
   METHOD New( oODBC )       BLOCK { | Self, oODBC | ::oODBC := oODBC , Self }
   METHOD FieldGet( p )      BLOCK { | Self, p | ::oODBC:Fields[ p ]:Value }
   METHOD FieldPut( p, u )   BLOCK { | Self, p, u | ::oODBC:Fields[ p ]:Value := u }
   METHOD Field( p )         BLOCK { | Self, p | ::oODBC:Fields[ p ]:FieldName }
   METHOD FieldName( p )     BLOCK { | Self, p | ::oODBC:Fields[ p ]:FieldName }
   METHOD FieldPos

   // Implemented but not used for this sample (not used by XBrowse itself)
   METHOD Use( oODBC )       BLOCK { | Self, oODBC | ::oODBC := oODBC , Self }
   METHOD Skip
   METHOD Bof                BLOCK { | Self | ::oODBC:Bof }
   METHOD FieldBlock
   METHOD Commit             BLOCK { | Self | ::oODBC:Commit() }

   // Interface to ODBC object
   METHOD Connect(cString)   BLOCK { | Self, cString | ::oODBC := TODBC() , ::oODBC:New( cString ) , Self }
   METHOD Query
   METHOD Close              BLOCK { | Self | ::oODBC:Close() }
   METHOD SQLErrorMessage    BLOCK { | Self | ::oODBC:SQLErrorMessage() }
   METHOD Destroy            BLOCK { | Self | ::oODBC:Destroy() }

   ERROR HANDLER FieldAssign
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Skipper( nSkip ) CLASS XBrowse_ODBC
*-----------------------------------------------------------------------------*
LOCAL nCount
   nCount := 0
   IF nSkip > 0
      DO WHILE nSkip > 0
         ::oODBC:Next()
         nSkip--
         IF ::oODBC:EOF()
            ::oODBC:Prior()
            EXIT
         ENDIF
         nCount++
      ENDDO
   ELSE
      DO WHILE nSkip < 0
         ::oODBC:Prior()
         nSkip++
         IF ::oODBC:BOF()
            EXIT
         ENDIF
         nCount--
      ENDDO
   ENDIF
RETURN nCount

*-----------------------------------------------------------------------------*
METHOD FieldPos( cField ) CLASS XBrowse_ODBC
*-----------------------------------------------------------------------------*
   cField := UPPER( ALLTRIM( cField ) )
RETURN ASCAN( ::oODBC:Fields, { |h| UPPER( h:FieldName ) == cField } )

*-----------------------------------------------------------------------------*
METHOD Skip( nSkip ) CLASS XBrowse_ODBC
*-----------------------------------------------------------------------------*
   IF nSkip == NIL
      nSkip := 1
   ENDIF
   IF nSkip > 0
      DO WHILE nSkip > 0
         ::oODBC:Next()
         nSkip--
         IF ::oODBC:EOF()
            EXIT
         ENDIF
      ENDDO
   ELSE
      DO WHILE nSkip < 0
         ::oODBC:Prior()
         nSkip++
         IF ::oODBC:BOF()
            EXIT
         ENDIF
      ENDDO
   ENDIF
RETURN NIL

*-----------------------------------------------------------------------------*
METHOD FieldBlock( nPos ) CLASS XBrowse_ODBC
*-----------------------------------------------------------------------------*
RETURN { | uValue | IF( PCOUNT() > 0, ::oODBC:Fields[ nPos ]:Value := uValue, ::oODBC:Fields[ nPos ]:Value ) }

*-----------------------------------------------------------------------------*
METHOD Query( cQuery ) CLASS XBrowse_ODBC
*-----------------------------------------------------------------------------*
LOCAL lRet
   ::oODBC:SetSQL( cQuery )
   lRet := ::oODBC:Open()
   IF lRet
      ::GoTop()
   ENDIF
RETURN lRet

*-----------------------------------------------------------------------------*
METHOD FieldAssign( xValue ) CLASS XBrowse_ODBC
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

// Database methods not implemented (not used by XBrowse)
*   METHOD OrdScope
*   METHOD Filter

*   METHOD Locate     BLOCK { | Self, bFor, bWhile, nNext, nRec, lRest | ( ::cAlias__ )->( __dbLocate( bFor, bWhile, nNext, nRec, lRest ) ) }
*   METHOD Seek       BLOCK { | Self, uKey, lSoftSeek, lLast | ( ::cAlias__ )->( DbSeek( uKey, lSoftSeek, lLast ) ) }
*   METHOD Unlock     BLOCK { | Self |                         ( ::cAlias__ )->( DbUnlock() ) }
*   METHOD Delete     BLOCK { | Self |                         ( ::cAlias__ )->( DbDelete() ) }
*   METHOD Found      BLOCK { | Self |                         ( ::cAlias__ )->( Found() ) }
*   METHOD SetOrder   BLOCK { | Self, uOrder |                 ( ::cAlias__ )->( ORDSETFOCUS( uOrder ) ) }
*   METHOD SetIndex   BLOCK { | Self, cFile, lAdditive |       IF( EMPTY( lAdditive ), ( ::cAlias__ )->( ordListClear() ), ) , ( ::cAlias__ )->( ordListAdd( cFile ) ) }
*   METHOD Append     BLOCK { | Self |                         ( ::cAlias__ )->( DbAppend() ) }
*   METHOD Lock       BLOCK { | Self |                         ( ::cAlias__ )->( RLock() ) }
*   METHOD DbStruct   BLOCK { | Self |                         ( ::cAlias__ )->( DbStruct() ) }
