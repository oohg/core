/*
 * $Id: xbrowsearray.prg,v 1.5 2011-08-31 01:34:37 fyurisich Exp $
 */
/*
 * ooHG XBrowse array-as-database demo. (c) 2008 Vic
 * This demo shows how to use XBrowse for show an array.
 * It includes an "array-as-database" object.
 */

#ifndef NO_SAMPLE

#include "oohg.ch"

PROCEDURE Main
Local aArray, oArray, I

   aArray := ARRAY( 50 )
   FOR I := 1 TO LEN( aArray )
      aArray[ I ] := { LTRIM( STR( I * 10 + 3 ) ) , ;
                       LTRIM( STR( I * 10 + 4 ) ) , ;
                       LTRIM( STR( I * 10 + 5 ) ) }
   NEXT

   oArray := XBrowse_Array():New( aArray )

   DEFINE WINDOW Main WIDTH 400 HEIGHT 400 CLIENTAREA ;
                 TITLE "Array Browse Sample"
       @ 10,10 XBROWSE Brw WIDTH 380 HEIGHT 380 ;
               WORKAREA ( oArray ) ;
               HEADERS { "Center", "Right", "Left" } ;
               WIDTHS { 100, 100, 100 } ;
               FIELDS { { |o| o:FieldGet( 1 ) } , ;
                        { |o| o:FieldGet( 2 ) } , ;
                        { |o| o:FieldGet( 3 ) } } ;
               JUSTIFY ;
               { GRID_JTFY_CENTER , GRID_JTFY_RIGHT , GRID_JTFY_LEFT } ;
               ; // Edition
               APPEND ;
               EDIT INPLACE ;
               REPLACEFIELD { { |x,o| o:FieldPut( 1, x ) } , ;
                              { |x,o| o:FieldPut( 2, x ) } , ;
                              { |x,o| o:FieldPut( 3, x ) } }
   END WINDOW
   ACTIVATE WINDOW Main

RETURN

#endif    // #ifndef NO_SAMPLE

#include "hbclass.ch"

/*
 *  This is a template for ooHGRecord's subclasses (database class used
 *  by XBrowse).
 *
 *  All methods are defined specifically for XBrowse_Array. If you create
 *  your own class, you must define them for your own requirements.
 */

*-----------------------------------------------------------------------------*
CLASS XBrowse_Array
*-----------------------------------------------------------------------------*
   // Methods always used by XBrowse
   METHOD Skipper
   METHOD GoTop              BLOCK { | Self | ::GoTo( 1 ) }
   METHOD GoBottom           BLOCK { | Self | ::GoTo( ::RecCount ) }

   // Methods used by XBrowse if you'll have a scrollbar
   METHOD RecNo              BLOCK { | Self | ::nRecNo }
   METHOD RecCount           BLOCK { | Self | LEN( ::aArray ) }
   METHOD GoTo
   METHOD OrdKeyNo           BLOCK { | Self | ::nRecNo }
   METHOD OrdKeyCount        BLOCK { | Self | LEN( ::aArray ) }
   METHOD OrdKeyGoTo( n )    BLOCK { | Self, n | ::GoTo( n ) }

   // Methods used by XBrowse if you'll allow edition
   DATA cAlias__             INIT nil
   METHOD Eof                BLOCK { | Self | ( ::RecNo > ::RecCount ) }

   // Method used by XBrowse if you'll allow appends
   METHOD Append             BLOCK { | Self | aAdd( ::aArray, {"", "", ""} ), ::GoTo( len( ::aArray ) ) }

   // Method used by XBrowse if you'll allow deletes
*   METHOD Delete     BLOCK { | Self |                         ( ::cAlias__ )->( DbDelete() ) }

   // Methods used by XBrowse if you use locking scheme
*   METHOD Commit     BLOCK { | Self |                         ( ::cAlias__ )->( DbCommit() ) }
*   METHOD Unlock     BLOCK { | Self |                         ( ::cAlias__ )->( DbUnlock() ) }
*   METHOD Lock       BLOCK { | Self |                         ( ::cAlias__ )->( RLock() ) }

   // Method used by XBrowse if you don´t use FIELDS clause or if values in array are not fields
*   METHOD DbStruct   BLOCK { | Self |                         ( ::cAlias__ )->( DbStruct() ) }

   // Used by "own" (XBrowse_Array) class (not used by XBrowse itself)
   DATA aArray
   DATA nRecNo               INIT 1
   DATA lBof                 INIT .F.
   METHOD New( aArray )      BLOCK { | Self, aArray | ::aArray := aArray , Self }
   METHOD FieldGet( nPos )   BLOCK { | Self, nPos | ::aArray[ ::nRecNo ][ nPos ] }
   METHOD FieldPut( p, u )   BLOCK { | Self, p, u | ::aArray[ ::nRecNo ][ p ] := u }

   // Implemented but not used for this sample (not used by XBrowse itself)
   METHOD Use( aArray )      BLOCK { | Self, aArray | ::aArray := aArray , Self }
   METHOD Skip
   METHOD Bof                BLOCK { | Self | ::lBof }
   METHOD FieldBlock
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Skipper( nSkip ) CLASS XBrowse_Array
*-----------------------------------------------------------------------------*
LOCAL nRecNo
   nRecNo := ::nRecNo
   ::nRecNo := MAX( MIN( nRecNo + nSkip, LEN( ::aArray ) ), 1 )
RETURN ( ::nRecNo - nRecNo )

*-----------------------------------------------------------------------------*
METHOD GoTo( nRecno ) CLASS XBrowse_Array
*-----------------------------------------------------------------------------*
   IF nRecno < 1 .OR. nRecno > LEN( ::aArray )
      ::nRecno := LEN( ::aArray ) + 1
   ELSE
      ::nRecno := INT( nRecno )
   ENDIF
   ::lBof := ( ::RecCount == 0 )
RETURN ::nRecno

*-----------------------------------------------------------------------------*
METHOD FieldBlock( nPos ) CLASS XBrowse_Array
*-----------------------------------------------------------------------------*
RETURN { | uValue | IF( PCOUNT() > 0, ::aArray[ ::nRecNo ][ nPos ] := uValue, ::aArray[ ::nRecNo ][ nPos ] ) }

*-----------------------------------------------------------------------------*
METHOD Skip( nRecno ) CLASS XBrowse_Array
*-----------------------------------------------------------------------------*
   IF ! HB_IsNumeric( nRecno )
      nRecno := 1
   ENDIF
   ::nRecNo := INT( ::RecNo + nRecno )
   ::lBof := .F.
   IF ::nRecNo < 1
      ::nRecNo := 1
      ::lBof := .T.
   ELSEIF ::nRecNo > ::RecCount()
      ::nRecNo := ::RecCount() + 1
   ENDIF
RETURN nil

// Database methods not implemented (not used by XBrowse)
*   METHOD OrdScope
*   METHOD Filter

*   METHOD Field      BLOCK { | Self, nPos |                   ( ::cAlias__ )->( Field( nPos ) ) }                 // Field's name
*   METHOD FieldName  BLOCK { | Self, nPos |                   ( ::cAlias__ )->( FieldName( nPos ) ) }             // Field's name
*   METHOD FieldPos   BLOCK { | Self, cField |                 ( ::cAlias__ )->( FieldPos( cField ) ) }            // Field's position

*   METHOD Locate     BLOCK { | Self, bFor, bWhile, nNext, nRec, lRest | ( ::cAlias__ )->( __dbLocate( bFor, bWhile, nNext, nRec, lRest ) ) }
*   METHOD Seek       BLOCK { | Self, uKey, lSoftSeek, lLast | ( ::cAlias__ )->( DbSeek( uKey, lSoftSeek, lLast ) ) }
*   METHOD Close      BLOCK { | Self |                         ( ::cAlias__ )->( DbCloseArea() ) }
*   METHOD Found      BLOCK { | Self |                         ( ::cAlias__ )->( Found() ) }
*   METHOD SetOrder   BLOCK { | Self, uOrder |                 ( ::cAlias__ )->( ORDSETFOCUS( uOrder ) ) }
*   METHOD SetIndex   BLOCK { | Self, cFile, lAdditive |       IF( EMPTY( lAdditive ), ( ::cAlias__ )->( ordListClear() ), ) , ( ::cAlias__ )->( ordListAdd( cFile ) ) }

*   ERROR HANDLER FieldAssign
