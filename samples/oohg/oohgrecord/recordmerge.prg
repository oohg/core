/*
 * $Id: recordmerge.prg,v 1.6 2017-08-25 19:28:46 fyurisich Exp $
 */
/*
 * ooHG XBrowse multiple database in one browse. (c) 2008-2017 Vic
 * This demo shows multiple databases on a single browse.
 *
 * NOTES: You can't use XBROWSE's scrollbar or edit capabilities.
 *        However, you can create your own edit procedure.
 */

#ifndef NO_SAMPLE

#include "oohg.ch"
#include "hbcompat.ch"

PROCEDURE MAIN
LOCAL oBase1, oBase2, I, J, K, nCount, oMix

   SET DELETED ON

   DBCREATE( "BASE1", { { "KEY", "C", 5, 0 } , { "DATA", "C", 30, 0 } } )
   USE BASE1
   INDEX ON KEY TO BASE1
   DBCloseArea()

   DBCREATE( "BASE2", { { "KEY", "C", 5, 0 } , { "DATA", "C", 30, 0 } } )
   USE BASE2
   INDEX ON KEY TO BASE2
   DBCloseArea()

   oBase1 := ooHGRecord():Use( "BASE1" )
   oBase1:SetIndex( "BASE1" )

   oBase2 := ooHGRecord():Use( "BASE2" )
   oBase2:SetIndex( "BASE2" )

   nCount := 0
   FOR I := 1 TO 50
      K := HB_RANDOM( 3 )
      FOR J := 1 TO K
         nCount++
         oBase1:Append()
         oBase1:Key  := STRZERO( I, 5 )
         oBase1:Data := "Key " + STRZERO( I, 5 ) + "/A-" + STRZERO( J, 2 ) + " count " + STRZERO( nCount, 4 )
      NEXT
      K := HB_RANDOM( 3 )
      FOR J := 1 TO K
         nCount++
         oBase2:Append()
         oBase2:Key  := STRZERO( I, 5 )
         oBase2:Data := "Key " + STRZERO( I, 5 ) + "/B-" + STRZERO( J, 2 ) + " count " + STRZERO( nCount, 4 )
      NEXT
   NEXT

   oMix := TRecordMerge():New( { oBase1, oBase2 } )

   DEFINE WINDOW MAIN ;
          AT 0,0 WIDTH 420 HEIGHT 320 CLIENTAREA ;
          TITLE "Tables merged" ;
          FONT "MS Sans Serif" SIZE 9

      @ 10,10 XBROWSE Browse                            ;
              WIDTH 400                                 ;
              HEIGHT 300                                ;
              WORKAREA ( oMix )                         ;
              FONT 'VERDANA' SIZE 7 NOVSCROLL           ;
              HEADERS { "Key",         "Data" }         ;
              WIDTHS  { 50,            300 }            ;
              FIELDS  { { |o| o:Key }, { |o| o:Data } }

   END WINDOW
   ACTIVATE WINDOW MAIN

RETURN

#endif   // NO_SAMPLE

#include "hbclass.ch"

CLASS TRecordMerge

   // Used by "user's" class
   DATA aAreas
   DATA nCurrent
   DATA oCurrent
   DATA aKeys
   DATA bIndexKey          INIT nil
   METHOD New
   METHOD SkipArea
   METHOD GetIndexKey
   METHOD ReadAllKeys

   // Methods always used by XBrowse
   METHOD Skipper
   METHOD GoTop
   METHOD GoBottom

   // Methods used by XBrowse if you'll have a scrollbar
*   METHOD RecNo              BLOCK { | Self | ::nRecNo }
*   METHOD RecCount           BLOCK { | Self | LEN( ::aArray ) }
*   METHOD GoTo( n )          BLOCK { | Self, n | ::nRecNo := MAX( MIN( n, LEN( ::aArray ) ), 1 ) }
*   METHOD OrdKeyNo           BLOCK { | Self | ::nRecNo }
*   METHOD OrdKeyCount        BLOCK { | Self | LEN( ::aArray ) }
*   METHOD OrdKeyGoTo( n )    BLOCK { | Self, n | ::nRecNo := MAX( MIN( n, LEN( ::aArray ) ), 1 ) }

   // Methods used by XBrowse if you'll allow edition
*   DATA cAlias__             INIT nil
*   METHOD Eof                INLINE .F.

   // Implemented
   METHOD Skip( n )          BLOCK { | Self, n | ::Skipper( n ) }
   METHOD Seek
   ERROR HANDLER FieldAssign

ENDCLASS

METHOD New( aAreas ) CLASS TRecordMerge
   ::aAreas := aAreas
   ::GoTop()
RETURN Self

METHOD SkipArea( nArea, nStep ) CLASS TRecordMerge
LOCAL oArea, lSkipped
   IF HB_IsNumeric( nStep )
      nStep := INT( nStep )
   ELSE
      nStep := 0
   ENDIF
   lSkipped := .F.
   oArea := ::aAreas[ nArea ]
   IF nStep == 0
      //
   ELSEIF nStep > 0
      oArea:Skip( 1 )
      IF oArea:Eof()
         oArea:GoBottom()
      ELSE
         lSkipped := .T.
      ENDIF
   ELSE
      oArea:Skip( -1 )
      IF oArea:Bof()
         oArea:GoTop()
      ELSE
         lSkipped := .T.
      ENDIF
   ENDIF
   ::aKeys[ nArea ] := ::GetIndexKey( oArea )
RETURN lSkipped

METHOD GetIndexKey( oArea ) CLASS TRecordMerge
LOCAL bKey, cKey
   bKey := ::bIndexKey
   IF HB_IsBlock( bKey )
      cKey := EVAL( bKey, oArea )
   ELSE
      cKey := ( oArea:cAlias__ )->( &( INDEXKEY() ) )
   ENDIF
RETURN cKey

METHOD ReadAllKeys() CLASS TRecordMerge
LOCAL I, oArea
   ::aKeys := ARRAY( LEN( ::aAreas ) )
   FOR I := 1 TO LEN( ::aAreas )
      oArea := ::aAreas[ I ]
      IF oArea:Eof()
         oArea:GoBottom()
      ENDIF
      IF ! oArea:Eof()
         ::aKeys[ I ] := ::GetIndexKey( oArea )
      ENDIF
   NEXT
RETURN nil

METHOD Skipper( nSkip ) CLASS TRecordMerge
LOCAL nCount, aKeys, cKey, nArea, cKey2
   IF HB_IsNumeric( nSkip )
      nSkip := INT( nSkip )
   ELSE
      nSkip := 1
   ENDIF
   IF nSkip == 0
      RETURN 0
   ENDIF
   nCount := 0
   aKeys := ARRAY( LEN( ::aAreas ) )
   AEVAL( ::aKeys, { |c,i| aKeys[ i ] := ( c != NIL )  } )
   IF ASCAN( aKeys, .T. ) == 0
      RETURN 0
   ENDIF
   cKey := ::aKeys[ ::nCurrent ]
   IF nSkip > 0
      FOR nArea := 1 TO LEN( aKeys )
         DO WHILE aKeys[ nArea ] .AND. ( ::aKeys[ nArea ] < cKey .OR. ( ::aKeys[ nArea ] == cKey .AND. nArea < ::nCurrent ) )
            aKeys[ nArea ] := ::SkipArea( nArea, 1 )
         ENDDO
      NEXT
   ELSE
      FOR nArea := 1 TO LEN( aKeys )
         DO WHILE aKeys[ nArea ] .AND. ( ::aKeys[ nArea ] > cKey .OR. ( ::aKeys[ nArea ] == cKey .AND. nArea > ::nCurrent ) )
            aKeys[ nArea ] := ::SkipArea( nArea, -1 )
         ENDDO
      NEXT
   ENDIF
   DO WHILE nSkip != 0 .AND. ASCAN( aKeys, .T. ) > 0
      IF nSkip > 0
         nSkip--
         aKeys[ ::nCurrent ] := ::SkipArea( ::nCurrent, 1 )
         cKey2 := ::aKeys[ ::nCurrent ]
         IF aKeys[ ::nCurrent ] .AND. cKey2 == cKey
            nCount++
         ELSEIF ASCAN( aKeys, .T. ) == 0
            // EOF
            EXIT
         ELSE
            nCount++
            nArea := ASCAN( ::aKeys, { |c,i| aKeys[ i ] .AND. c == cKey } )
            IF nArea > 0
               ::nCurrent := nArea
            ELSE
               ::nCurrent := ASCAN( aKeys, .T. )
               cKey := ::aKeys[ ::nCurrent ]
               nArea := ::nCurrent + 1
               DO WHILE nArea <= LEN( ::aAreas )
                  cKey2 := ::aKeys[ nArea ]
                  IF aKeys[ nArea ] .AND. cKey2 < cKey
                     cKey := cKey2
                     ::nCurrent := nArea
                  ENDIF
                  nArea++
               ENDDO
            ENDIF
            ::oCurrent := ::aAreas[ ::nCurrent ]
         ENDIF
      ELSE
         nSkip++
         aKeys[ ::nCurrent ] := ::SkipArea( ::nCurrent, -1 )
         cKey2 := ::aKeys[ ::nCurrent ]
         IF aKeys[ ::nCurrent ] .AND. cKey2 == cKey
            nCount--
         ELSEIF ASCAN( aKeys, .T. ) == 0
            // EOF
            EXIT
         ELSE
            nCount--
            nArea := RASCAN( ::aKeys, { |c,i| aKeys[ i ] .AND. c == cKey } )
            IF nArea > 0
               ::nCurrent := nArea
            ELSE
               ::nCurrent := RASCAN( aKeys, .T. )
               cKey := ::aKeys[ ::nCurrent ]
               nArea := ::nCurrent - 1
               DO WHILE nArea >= 1
                  cKey2 := ::aKeys[ nArea ]
                  IF aKeys[ nArea ] .AND. cKey2 > cKey
                     cKey := cKey2
                     ::nCurrent := nArea
                  ENDIF
                  nArea--
               ENDDO
            ENDIF
            ::oCurrent := ::aAreas[ ::nCurrent ]
         ENDIF
      ENDIF
   ENDDO
RETURN nCount

METHOD GoTop() CLASS TRecordMerge
LOCAL cKey, nArea, cKey2
   AEVAL( ::aAreas, { |o| o:GoTop() } )
   ::ReadAllKeys()
   ::nCurrent := ASCAN( ::aKeys, { |c| c != NIL } )
   IF ::nCurrent == 0
      ::nCurrent := 1
      ::oCurrent := ::aAreas[ 1 ]
      RETURN Self
   ENDIF
   cKey := ::aKeys[ ::nCurrent ]
   nArea := 2
   DO WHILE nArea <= LEN( ::aAreas )
      cKey2 := ::aKeys[ nArea ]
      IF cKey2 != NIL .AND. cKey2 < cKey
         cKey := cKey2
         ::nCurrent := nArea
      ENDIF
      nArea++
   ENDDO
   ::oCurrent := ::aAreas[ ::nCurrent ]
RETURN Self

METHOD GoBottom() CLASS TRecordMerge
LOCAL cKey, nArea, cKey2
   AEVAL( ::aAreas, { |o| o:GoBottom() } )
   ::ReadAllKeys()
   ::nCurrent := RASCAN( ::aKeys, { |c| c != NIL } )
   IF ::nCurrent == 0
      ::nCurrent := 1
      ::oCurrent := ::aAreas[ 1 ]
      RETURN Self
   ENDIF
   cKey := ::aKeys[ ::nCurrent ]
   nArea := LEN( ::aAreas ) - 1
   DO WHILE nArea >= 1
      cKey2 := ::aKeys[ nArea ]
      IF cKey2 != NIL .AND. cKey2 > cKey
         cKey := cKey2
         ::nCurrent := nArea
      ENDIF
      nArea--
   ENDDO
   ::oCurrent := ::aAreas[ ::nCurrent ]
RETURN Self

#ifndef _SET_SOFTSEEK
   #define _SET_SOFTSEEK 9
#endif

METHOD Seek( xKey, lSoftSeek /* , lLast */ ) CLASS TRecordMerge
LOCAL cKey, nArea, cKey2, aFound, nFound, lLast
   aFound := ARRAY( LEN( ::aAreas ) )
   AEVAL( ::aAreas, { |o,i| aFound[ i ] := o:Seek( xKey, .T. /* , lLast */ ) } )
   IF ! HB_IsLogical( lSoftSeek )
      lSoftSeek := .F.
   ENDIF
   IF ! HB_IsLogical( lLast )
      lLast := .F.
   ENDIF
   IF lLast
      nFound := RASCAN( aFound, .T. )
   ELSE
      nFound := ASCAN( aFound, .T. )
   ENDIF
   ::ReadAllKeys()
   ::nCurrent := ASCAN( ::aKeys, { |c| c != NIL } )
   IF ::nCurrent == 0
      ::nCurrent := 1
      ::oCurrent := ::aAreas[ 1 ]
      RETURN .F.
   ENDIF
   IF lSoftSeek .OR. SET( _SET_SOFTSEEK )
      IF lLast
         IF nFound == 0
            ::nCurrent := RASCAN( ::aKeys, { |c| c != NIL } )
            nArea := ::nCurrent - 1
         ELSE
            ::nCurrent := nFound
            nArea := nFound - 1
         ENDIF
         cKey := ::aKeys[ ::nCurrent ]
         DO WHILE nArea >= 1
            cKey2 := ::aKeys[ nArea ]
            IF cKey2 != NIL .AND. cKey2 > cKey
               cKey := cKey2
               ::nCurrent := nArea
            ENDIF
            nArea--
         ENDDO
      ELSE
         IF nFound == 0
            // ::nCurrent := 1
            nArea := ::nCurrent + 1
         ELSE
            ::nCurrent := nFound
            nArea := nFound + 1
         ENDIF
         cKey := ::aKeys[ ::nCurrent ]
         DO WHILE nArea <= LEN( ::aAreas )
            cKey2 := ::aKeys[ nArea ]
            IF cKey2 != NIL .AND. cKey2 < cKey
               cKey := cKey2
               ::nCurrent := nArea
            ENDIF
            nArea++
         ENDDO
      ENDIF
   ELSE
      ::GoBottom()
   ENDIF
   ::oCurrent := ::aAreas[ ::nCurrent ]
RETURN ( nFound > 0 )

METHOD FieldAssign( xValue ) CLASS TRecordMerge
LOCAL cField
   cField := ALLTRIM( UPPER( __GetMessage() ) )
   IF PCOUNT() > 0
      RETURN ( ::oCurrent:&( cField ) := xValue )
   ELSE
      RETURN ( ::oCurrent:&( cField ) )
   ENDIF
RETURN NIL
