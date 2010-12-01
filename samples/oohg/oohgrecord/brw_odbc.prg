/*
 * $Id: brw_odbc.prg,v 1.2 2010-12-01 18:49:59 guerra000 Exp $
 */
/*
 * ooHG XBrowse ODBC demo. (c) 2008 Vic
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
   oODBC:Open()

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
   METHOD FieldGet( nPos )   BLOCK { | Self, nPos | ::oODBC:Fields[ nPos ]:Value }
   METHOD FieldPut( p, u )   BLOCK { | Self, p, u | ::oODBC:Fields[ p ]:Value := u }

   // Implemented but not used for this sample (not used by XBrowse itself)
   METHOD Use( oODBC )       BLOCK { | Self, oODBC | ::oODBC := oODBC , Self }
   METHOD Skip( n )          BLOCK { | Self, n | ::Skipper( n ) }
   METHOD Bof                BLOCK { | Self | ::oODBC:Bof }
   METHOD FieldBlock
   METHOD Commit             BLOCK { | Self | ::oODBC:Commit() }
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
METHOD FieldBlock( nPos ) CLASS XBrowse_ODBC
*-----------------------------------------------------------------------------*
RETURN { | uValue | IF( PCOUNT() > 0, ::oODBC:Fields[ nPos ]:Value := uValue, ::oODBC:Fields[ nPos ]:Value ) }

// Database methods not implemented (not used by XBrowse)
*   METHOD OrdScope
*   METHOD Filter

*   METHOD Field      BLOCK { | Self, nPos |                   ( ::cAlias__ )->( Field( nPos ) ) }                 // Field's name
*   METHOD FieldName  BLOCK { | Self, nPos |                   ( ::cAlias__ )->( FieldName( nPos ) ) }             // Field's name
*   METHOD FieldPos   BLOCK { | Self, cField |                 ( ::cAlias__ )->( FieldPos( cField ) ) }            // Field's position

*   METHOD Locate     BLOCK { | Self, bFor, bWhile, nNext, nRec, lRest | ( ::cAlias__ )->( __dbLocate( bFor, bWhile, nNext, nRec, lRest ) ) }
*   METHOD Seek       BLOCK { | Self, uKey, lSoftSeek, lLast | ( ::cAlias__ )->( DbSeek( uKey, lSoftSeek, lLast ) ) }
*   METHOD Unlock     BLOCK { | Self |                         ( ::cAlias__ )->( DbUnlock() ) }
*   METHOD Delete     BLOCK { | Self |                         ( ::cAlias__ )->( DbDelete() ) }
*   METHOD Close      BLOCK { | Self |                         ( ::cAlias__ )->( DbCloseArea() ) }
*   METHOD Found      BLOCK { | Self |                         ( ::cAlias__ )->( Found() ) }
*   METHOD SetOrder   BLOCK { | Self, uOrder |                 ( ::cAlias__ )->( ORDSETFOCUS( uOrder ) ) }
*   METHOD SetIndex   BLOCK { | Self, cFile, lAdditive |       IF( EMPTY( lAdditive ), ( ::cAlias__ )->( ordListClear() ), ) , ( ::cAlias__ )->( ordListAdd( cFile ) ) }
*   METHOD Append     BLOCK { | Self |                         ( ::cAlias__ )->( DbAppend() ) }
*   METHOD Lock       BLOCK { | Self |                         ( ::cAlias__ )->( RLock() ) }
*   METHOD DbStruct   BLOCK { | Self |                         ( ::cAlias__ )->( DbStruct() ) }

*   ERROR HANDLER FieldAssign
