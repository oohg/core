/*
 * $Id: h_report.prg $
 */
/*
 * ooHG source code:
 * DO REPORT commands
 *
 * Copyright 2005-2019 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2019 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2019 Contributors, https://harbour.github.io/
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


#include "common.ch"
#include "hbclass.ch"
#include "oohg.ch"
#include "i_init.ch"

#define DOUBLE_QUOTATION_MARK '"'
#define DQM( x )              ( DOUBLE_QUOTATION_MARK + x + DOUBLE_QUOTATION_MARK )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION EasyReport( cTitle, aHeaders1, aHeaders2, aFields, aWidths, aTotals, nLPP, lDos, ;
      lPreview, cGraphic, nFI, nCI, nFF, nCF, lMul, cGrpBy, cHdrGrp, lLandscape, nCPL, ;
      lSelect, cAlias, nLLMargin, aFormats, nPaperSize, cHeader, lNoProp, lGroupEject, ;
      nRes, nBin, nDuplex, lCollate, nCopies, lColor, nScale, nLength, nWidth )

   LOCAL nPrevious

   nPrevious := SetInteractiveClose()
   SET INTERACTIVECLOSE ON

   TReport():EasyReport1( cTitle, aHeaders1, aHeaders2, aFields, aWidths, aTotals, nLPP, lDos, ;
      lPreview, cGraphic, nFI, nCI, nFF, nCF, lMul, cGrpBy, cHdrGrp, lLandscape, nCPL, ;
      lSelect, cAlias, nLLMargin, aFormats, nPaperSize, cHeader, lNoProp, lGroupEject, ;
      nRes, nBin, nDuplex, lCollate, nCopies, lColor, nScale, nLength, nWidth )

   SetInteractiveClose( nPrevious )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION ExtReport( cFileRep, cHeader )

   LOCAL nPrevious

   nPrevious := SetInteractiveClose()
   SET INTERACTIVECLOSE ON

   TReport():ExtReport1( cFilerep, cHeader )

   SetInteractiveClose( nPrevious )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION JustificaLinea( cLine, nLastCol )

   LOCAL i, nCant

   nCant := Len( RTrim( cLine ) )
   FOR i := 1 TO nCant
      IF nCant == nLastCol
         EXIT
      ENDIF
      IF SubStr( cLine, i, 1 ) == " " .AND. SubStr( cLine, i - 1, 1 ) # " "
         cLine := LTrim( SubStr( cLine, 1, i - 1 ) ) + "  " + LTrim( SubStr( cLine, i + 1, Len( cLine ) - i ) )
         nCant ++
      ENDIF
   NEXT i

   RETURN cLine

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TReport FROM TPRINTBASE

   DATA Type                      INIT "REPORT" READONLY
   DATA aLines                    INIT {}
   DATA aNGrpBy                   INIT {}
   DATA lExcel                    INIT .F.
   DATA nFSize                    INIT 0
   DATA nLMargin                  INIT 0
   DATA nLinesLeft                INIT 0
   DATA nPageNumber               INIT 0
   DATA oPrint                    INIT NIL

   METHOD Clean
   METHOD EasyReport1
   METHOD ExtReport1
   METHOD Headers
   METHOD LeaColI
   METHOD LeaDato
   METHOD LeaDatoH
   METHOD LeaDatoLogic
   METHOD LeaImage
   METHOD LeaRowI

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EasyReport1( cTitle, aHeaders1, aHeaders2, aFields, aWidths, aTotals, nLPP, lDos, ;
      lPreview, cGraphic, nFI, nCI, nFF, nCF, lMul, cGrpBy, cHdrGrp, lLandscape, nCPL, ;
      lSelect, cAlias, nLLMargin, aFormats, nPapersize, cHeader, lNoProp, lGroupEject, ;
      nRes, nBin, nDuplex, lCollate, nCopies, lColor, nScale, nLength, nWidth ) CLASS TReport

   LOCAL nFieldsCount, i, lHasTotals, aResul, nOldArea, nLin, cRompe, nCount
   LOCAL cLinea, aLenMemo, aValues, nCantLin, cField, uValue, cType, j

   ASSIGN cTitle      VALUE cTitle      TYPE "CM" DEFAULT ""
   ASSIGN nLPP        VALUE nLPP        TYPE "N"  DEFAULT 58
   ASSIGN lDos        VALUE lDos        TYPE "L"  DEFAULT .F.
   ASSIGN lPreview    VALUE lPreview    TYPE "L"  DEFAULT .F.
   ASSIGN cGraphic    VALUE cGraphic    TYPE "CM" DEFAULT NIL
   ASSIGN nFI         VALUE nFI         TYPE "N"  DEFAULT 0
   ASSIGN nCI         VALUE nCI         TYPE "N"  DEFAULT 0
   ASSIGN nFF         VALUE nFF         TYPE "N"  DEFAULT 0
   ASSIGN nCF         VALUE nCF         TYPE "N"  DEFAULT 0
   ASSIGN lMul        VALUE lMul        TYPE "L"  DEFAULT .F.
   ASSIGN cHdrGrp     VALUE cHdrGrp     TYPE "CM" DEFAULT ""
   ASSIGN lLandscape  VALUE lLandscape  TYPE "L"  DEFAULT .F.
   ASSIGN nCPL        VALUE nCPL        TYPE "N"  DEFAULT 80
   ASSIGN lSelect     VALUE lSelect     TYPE "L"  DEFAULT .F.
   ASSIGN cAlias      VALUE cAlias      TYPE "C"  DEFAULT NIL
   ASSIGN ::nLMargin  VALUE nLLMargin   TYPE "N"  DEFAULT 0
   ASSIGN nPaperSize  VALUE nPaperSize  TYPE "N"  DEFAULT NIL
   ASSIGN cHeader     VALUE cHeader     TYPE "CM" DEFAULT ""
   ASSIGN lNoProp     VALUE lNoProp     TYPE "L"  DEFAULT .F.
   ASSIGN lGroupEject VALUE lGroupEject TYPE "L"  DEFAULT .F.
   ASSIGN nRes        VALUE nRes        TYPE "N"  DEFAULT -2    // low resolution
   ASSIGN nBin        VALUE nBin        TYPE "N"  DEFAULT NIL
   ASSIGN nDuplex     VALUE nDuplex     TYPE "N"  DEFAULT NIL
   ASSIGN lCollate    VALUE lCollate    TYPE "L"  DEFAULT .F.
   ASSIGN nCopies     VALUE nCopies     TYPE "N"  DEFAULT NIL
   ASSIGN lColor      VALUE lColor      TYPE "L"  DEFAULT .F.
   ASSIGN nLength     VALUE nLength     TYPE "N"  DEFAULT NIL
   ASSIGN nLength     VALUE nLength     TYPE "N"  DEFAULT NIL
   ASSIGN nWidth      VALUE nWidth      TYPE "N"  DEFAULT NIL

   IF ! HB_ISARRAY( aFields ) .OR. ( nFieldsCount := Len( aFields ) ) < 1
      MsgOOHGError( "REPORT: Parameter FIELDS is not a valid array of strings. Program terminated." )
   ENDIF
   FOR i := 1 TO nFieldsCount
      IF ! HB_ISSTRING( aFields[ i ] )
         MsgOOHGError( "REPORT: Parameter FIELDS is not a valid array of strings. Program terminated." )
      ENDIF
   NEXT i
   IF ! HB_ISARRAY( aHeaders1 )
      aHeaders1 := Array( nFieldsCount )
   ENDIF
   IF Len( aHeaders1 ) < nFieldsCount
      ASize( aHeaders1, nFieldsCount )
   ENDIF
   FOR i := 1 TO nFieldsCount
      IF ! HB_ISSTRING( aHeaders1[ i ] )
         aHeaders1[ i ] := ""
      ENDIF
   NEXT i
   IF ! HB_ISARRAY( aHeaders2 )
      aHeaders2 := Array( nFieldsCount )
   ENDIF
   IF Len( aHeaders2 ) < nFieldsCount
      ASize( aHeaders2, nFieldsCount )
   ENDIF
   FOR i := 1 TO nFieldsCount
      IF ! HB_ISSTRING( aHeaders2[ i ] )
         aHeaders2[ i ] := ""
      ENDIF
   NEXT i
   IF ! HB_ISARRAY( aWidths )
      aWidths := Array( nFieldsCount )
   ENDIF
   IF Len( aWidths ) < nFieldsCount
      ASize( aWidths, nFieldsCount )
   ENDIF
   FOR i := 1 TO nFieldsCount
      IF ! HB_ISNUMERIC( aWidths[ i ] )
         aWidths[ i ] := 10
      ENDIF
   NEXT i
   IF ! HB_ISARRAY( aTotals )
      aTotals := Array( nFieldsCount )
   ENDIF
   IF Len( aTotals ) < nFieldsCount
      ASize( aTotals, nFieldsCount )
   ENDIF
   FOR i := 1 TO nFieldsCount
      IF ! HB_ISLOGICAL( aTotals[ i ] )
         aTotals[ i ] := .F.
      ENDIF
   NEXT i
   lHasTotals := ( AScan( aTotals, .T. ) > 0 )
   IF HB_ISSTRING( cGrpBy ) .AND. ! Empty( cGrpBy )
      cGrpBy := Upper( cGrpBy )
      // To avoid problems at control break
      cGrpBy := StrTran( cGrpBy, '"', "" )
      cGrpBy := StrTran( cGrpBy, "'", "" )
   ELSE
      cGrpBy := NIL
   ENDIF
   IF ! HB_ISARRAY( aFormats )
      aFormats := Array( nFieldsCount )
   ENDIF
   IF Len( aFormats ) < nFieldsCount
      ASize( aFormats, nFieldsCount )
   ENDIF
   FOR i := 1 TO nFieldsCount
      IF ! HB_ISSTRING( aFormats[ i ] )
         aFormats[ i ] := NIL
      ENDIF
   NEXT i

   aResul := Array( nFieldsCount )
   ::aNGrpBy := Array( nFieldsCount )

   IF lDos
      ::oPrint := TPrint( "DOSPRINT" )              // this does not change _OOHG_PrintLibrary
      ::oPrint:Init()
      IF nCPL <= 80
         ::oPrint:NormalDos()
      ELSE
         ::oPrint:CondenDos()
      ENDIF
   ELSE
      ::oPrint := TPrint()                          // if _OOHG_PrintLibrary is not set defaults TO MINIPRINT
      ::oPrint:Init()
      IF ::oPrint:Type == "EXCELPRINT"
         ::lExcel := .T.
      ELSEIF ::oPrint:Type == "RTFPRINT"
         ::lExcel := .T.
      ELSEIF ::oPrint:Type == "CALCPRINT"
         ::lExcel := .T.
      ELSEIF ::oPrint:Type == "CSVPRINT"
         ::lExcel := .T.
      ELSEIF ::oPrint:Type == "SPREADSHEETPRINT"
         ::lExcel := .T.
      ELSEIF ::oPrint:Type == "HTMLPRINTFROMCALC"
         ::lExcel := .T.
      ELSEIF ::oPrint:Type == "HTMLPRINTFROMEXCEL"
         ::lExcel := .T.
      ELSEIF ::oPrint:Type == "DOSPRINT"
         IF nCPL <= 80
            ::oPrint:NormalDos()
         ELSE
            ::oPrint:CondenDos()
         ENDIF
      ELSEIF ::oPrint:Type == "RAWPRINT"
         IF nCPL <= 80
            ::oPrint:NormalDos()
         ELSE
            ::oPrint:CondenDos()
         ENDIF
      ENDIF
   ENDIF

   DO CASE
   CASE nCPL == 80
      ::nFSize := 12
      IF lNoProp
         ::oPrint:SetCPL( 80 )
      ENDIF
   CASE nCPL == 96
      ::nFSize=10
      IF lNoProp
         ::oPrint:SetCPL( 96 )
      ENDIF
   CASE nCPL == 120
      ::nFSize := 8
      IF lNoProp
         ::oPrint:SetCPL( 120 )
      ENDIF
   CASE nCPL == 140
      ::nFSize := 7
      IF lNoProp
         ::oPrint:SetCPL( 140 )
      ENDIF
   CASE nCPL == 160
      ::nFSize := 6
      IF lNoProp
         ::oPrint:SetCPL( 160 )
      ENDIF
   OTHERWISE
      ::nFSize := 12
      IF lNoProp
         ::oPrint:SetCPL( 80 )
      ENDIF
   ENDCASE

   ::oPrint:SelPrinter( lSelect, lPreview, lLandscape, nPapersize, NIL, NIL, nRes, nBin, nDuplex, lCollate, nCopies, lColor, nScale, nLength, nWidth )
   IF ::oPrint:lPrError
      ::oPrint:Release()
      RETURN NIL
   ENDIF

   nOldArea := Select( cAlias )

   ::oPrint:BeginDoc()
   ::oPrint:BeginPage()
   ::nPageNumber := 0

   IF ! Empty( cGraphic )
      IF File( cGraphic )
         ::oPrint:PrintImage( nFI, nCI + ::nLMargin, nFF, nCF + ::nLMargin, cGraphic )
      ELSE
         MsgStop( _OOHG_Messages( MT_MISCELL, 21 ) + DQM( cGraphic ) + ".", _OOHG_Messages( MT_MISCELL, 9 ) )
      ENDIF
   ENDIF
   nLin := ::Headers( aHeaders1, aHeaders2, aWidths, 1, cTitle, NIL, cGrpBy, cHdrGrp, cHeader )
   FOR i := 1 TO nFieldsCount
       aResul[ i ] := 0
       ::aNGrpBy[ i ] := 0
   NEXT i
   IF cGrpBy <> NIL
      cRompe := &( cGrpBy )
   ENDIF

   nCount := 0

   DO WHILE ! Eof()
      nCount ++
      IF nCount % 10 == 0
         DO EVENTS
         nCount := 0
      ENDIF

      IF cGrpBy <> NIL
         IF ! ( &( cGrpBy ) == cRompe )
            IF lHasTotals
               ::oPrint:PrintData( nLin, ::nLMargin, '** Subtotal **', NIL, ::nFSize, .T. )
               nLin ++
            ENDIF

            cLinea := ""
            FOR i := 1 TO nFieldsCount
               IF aTotals[ i ]
                  cLinea += iif( aFormats[ i ] == NIL, ;
                                 Str( ::aNGrpBy[ i ], aWidths[ i ] ), ;
                                 ( Space( aWidths[ i ] - Len( Transform( ::aNGrpBy[ i ], aFormats[ i ] ) ) ) + Transform( ::aNGrpBy[ i ], aFormats[ i ] ) ) ;
                               ) + ;
                            Space( aWidths[ i ] - ;
                                   Len( iif( Empty( aFormats[ i ] ), ;
                                             Str( ::aNGrpBy[ i ], aWidths[ i ] ), ;
                                             ( Space( aWidths[ i ] - Len( Transform( ::aNGrpBy[ i ], aFormats[ i ] ) ) ) + Transform( ::aNGrpBy[ i ], aFormats[ i ] ) ) ;
                                           ) ;
                                      ) + ;
                                   1 )
               ELSE
                  cLinea := cLinea + Space( aWidths[ i ] + 1 )
               ENDIF
            NEXT i
            ::oPrint:PrintData( nLin, ::nLMargin, cLinea, NIL, ::nFSize, .T. )

            FOR i := 1 TO nFieldsCount
               ::aNGrpBy[ i ] := 0
            NEXT i

            IF lGroupEject
               ::oPrint:EndPage()
               ::oPrint:BeginPage()
               nLin := ( ::Headers( aHeaders1, aHeaders2, aWidths, 1, cTitle, NIL, cGrpBy, cHdrGrp, cHeader ) - 1 )
            ENDIF

            cRompe := &( cGrpBy )
            nLin ++
            ::oPrint:PrintData( nLin, ::nLMargin, '** ' + cHdrGrp + " " + &( cGrpBy ), NIL, ::nFSize, .T. )
            nLin ++
         ENDIF
      ENDIF

      aLenMemo := Array( nFieldsCount )
      AFill( aLenMemo, 0 )
      aValues := Array( nFieldsCount )
      AFill( aValues, NIL )
      nCantLin := 0
      cLinea := ""

      FOR i := 1 TO nFieldsCount
         cField := aFields[ i ]
         IF Type( aFields[ i ] ) == "B"
            uValue := Eval( &( cField ) )
         ELSE
            uValue := &( cField )
         ENDIF
         cType := ValType( uValue )
         IF cType == "O"
            uValue := "<Object>"
            cType  := "C"
         ELSEIF cType == "A"
            uValue := "<Array>"
            cType  := "C"
         ELSEIF cType == "C" .AND. aFormats[ i ] == "M"
            cType := "M"
         ENDIF

         DO CASE
         CASE cType == "C"
            cLinea := cLinea + SubStr( uValue, 1, aWidths[ i ] ) + Space( aWidths[ i ] - Len( SubStr( uValue, 1, aWidths[ i ] ) ) )
         CASE cType == "N"
            cLinea := cLinea + iif( ! ( aFormats[ i ] == NIL ), Space( aWidths[ i ] - Len( Transform( uValue, aFormats[ i ] ) ) ) + Transform( uValue, aFormats[ i ] ), Str( uValue, aWidths[ i ] ) ) + Space( aWidths[ i ] - Len( iif( ! ( aFormats[ i ] == "" ), Space( aWidths[ i ] - Len( Transform( uValue, aFormats[ i ] ) ) ) + Transform( uValue, aFormats[ i ] ), Str( uValue, aWidths[ i ] ) ) ) )
         CASE cType == "D"
            cLinea := cLinea + SubStr( DToC( uValue ), 1, aWidths[ i ] ) + Space( aWidths[ i ] - Len( SubStr( DToC( uValue ), 1, aWidths[ i ] ) ) )
         CASE cType == "L"
            cLinea := cLinea + iif( uValue, "T", "F" ) + Space( aWidths[ i ] - 1 )
         CASE cType == "M"
            aValues[ i ] := RTrim( uValue )
            aLenMemo[ i ] := MLCount( aValues[ i ], aWidths[ i ] )
            IF aLenMemo[ i ] > 0
               cLinea := cLinea + RTrim( JustificaLinea( MemoLine( aValues[ i ], aWidths[ i ], 1 ), aWidths[ i ] ) ) + Space( aWidths[ i ] - Len( RTrim( JustificaLinea( MemoLine( aValues[ i ], aWidths[ i ], 1 ), aWidths[ i ] ) ) ) )
               nCantLin := Max( nCantLin, aLenMemo[ i ] )
            ELSE
               cLinea := cLinea + Space( aWidths[ i ] )
            ENDIF
         OTHERWISE
            cLinea := cLinea + Replicate( "_", aWidths[ i ] )
         ENDCASE

         IF aTotals[ i ]
            aResul[ i ] := aResul[ i ] + uValue
            IF cGrpBy <> NIL
               ::aNGrpBy[ i ] := ::aNGrpBy[ i ] + uValue
            ENDIF
         ENDIF
      NEXT i
      ::oPrint:PrintData( nLin, ::nLMargin, cLinea, NIL, ::nFSize )

      nLin ++
      IF nLin > nLPP
         IF ! lDos      
            ::oPrint:EndPage()
            ::oPrint:BeginPage()
            IF ! Empty( cGraphic ) .AND. lMul
               IF File( cGraphic )
                  ::oPrint:PrintImage( nFI, nCI + ::nLMargin, nFF, nCF + ::nLMargin, cGraphic )
               ELSE
                  MsgStop( _OOHG_Messages( MT_MISCELL, 21 ) + DQM( cGraphic ) + ".", _OOHG_Messages( MT_MISCELL, 9 ) )
               ENDIF
            ENDIF
         ENDIF
         nLin := ::Headers( aHeaders1, aHeaders2, aWidths, 1, cTitle, NIL, cGrpBy, cHdrGrp, cHeader )
      ENDIF

      FOR j := 2 TO nCantLin
         cLinea := ""
         FOR i := 1 TO nFieldsCount
            IF aLenMemo[ i ] >= j
               cLinea := cLinea + JustificaLinea( MemoLine( aValues[ i ], aWidths[ i ], j ), aWidths[ i ] )
            ELSE
               cLinea := cLinea + Space( aWidths[ i ] )
            ENDIF
         NEXT i
         ::oPrint:PrintData( nLin, ::nLMargin, cLinea, NIL, ::nFSize, )

         nLin ++
         IF nLin > nLPP
            IF ! lDos
               ::oPrint:EndPage()
               ::oPrint:BeginPage()
               IF ! Empty( cGraphic ) .AND. lmul
                  IF File( cGraphic )
                     ::oPrint:PrintImage( nFI, nCI + ::nLMargin, nFF, nCF + ::nLMargin, cGraphic )
                  ELSE
                     MsgStop( _OOHG_Messages( MT_MISCELL, 21 ) + DQM( cGraphic ) + ".", _OOHG_Messages( MT_MISCELL, 9 ) )
                  ENDIF
               ENDIF
            ENDIF
            nLin := ::Headers( aHeaders1, aHeaders2, aWidths, 1, cTitle, NIL, cGrpBy, cHdrGrp, cHeader )
         ENDIF
      NEXT j

      SKIP
   ENDDO

   IF cGrpBy <> NIL
      IF ! ( &( cGrpBy ) == cRompe )
         IF lHasTotals
            ::oPrint:PrintData( nLin, ::nLMargin, '** Subtotal **', NIL, ::nFSize, .T. )
            nLin ++
         ENDIF

         cLinea := ""
         FOR i := 1 TO nFieldsCount
             IF aTotals[ i ]
                cLinea := cLinea + iif( ! ( aFormats[ i ] == NIL ), Space( aWidths[ i ] - Len( Transform( ::aNGrpBy[ i ], aFormats[ i ] ) ) ) + Transform( ::aNGrpBy[ i ], aFormats[ i ] ), Str( ::aNGrpBy[ i ], aWidths[ i ] ) ) + Space( aWidths[ i ] - Len( iif( ! ( aFormats[ i ] == '' ), Space( aWidths[ i ] - Len( Transform( ::aNGrpBy[ i ], aFormats[ i ] ) ) )+Transform( ::aNGrpBy[ i ], aFormats[ i ] ), Str( ::aNGrpBy[ i ], aWidths[ i ] ) ) ) )
             ELSE
                cLinea := cLinea + Space( aWidths[ i ] )
             ENDIF
         NEXT i
         ::oPrint:PrintData( nLin, ::nLMargin, cLinea, NIL, ::nFSize, .T. )
         FOR i := 1 TO nFieldsCount
            ::aNGrpBy[ i ] := 0
         NEXT i

         IF lgroupeject
            ::oPrint:EndPage()
            ::oPrint:BeginPage()
            nLin := ( ::Headers( aHeaders1, aHeaders2, aWidths, 1, cTitle, NIL, cGrpBy, cHdrGrp, cHeader ) - 1 )
         ENDIF

         nLin ++
         IF nLin > nLPP
            ::oPrint:EndPage()
            ::oPrint:BeginPage()
            nLin := ::Headers( aHeaders1, aHeaders2, aWidths, 1, cTitle, NIL, cGrpBy, cHdrGrp, cHeader )
         ENDIF
         IF AScan( aTotals, .T. ) > 0
            ::oPrint:PrintData( nLin, 0 + ::nLMargin, '*** Total ***', NIL, ::nFSize, .T. )
         ENDIF
         nLin ++
         cLinea := ""
         FOR i := 1 TO nFieldsCount
            IF aTotals[ i ]
               cLinea := cLinea + iif( ! ( aFormats[ i ] == NIL ), Space( aWidths[ i ] - Len( Transform( aResul[ i ], aFormats[ i ] ) ) ) + Transform( aResul[ i ], aFormats[ i ] ), Str( aResul[ i ], aWidths[ i ] ) ) + Space( aWidths[ i ] - Len( iif( ! ( aFormats[ i ] == '' ), Space( aWidths[ i ] - Len( Transform( aResul[ i ], aFormats[ i ] ) ) ) + Transform( aResul[ i ], aFormats[ i ] ), Str( aResul[ i ], aWidths[ i ] ) ) ) )
            ELSE
               cLinea := cLinea + Space( aWidths[ i ] )
            ENDIF
         NEXT i
         ::oPrint:PrintData( nLin, 0 + ::nLMargin, cLinea, NIL, ::nFSize, .T. )
         nLin ++
         ::oPrint:PrintData( nLin, ::nLMargin, " " )
      ENDIF
   ENDIF

   ::oPrint:EndPage()
   ::oPrint:EndDoc()
   ::oPrint:Release()

   Select( nOldArea )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Headers( aHeaders1, aHeaders2, aWidths, nLin, cTitle, lMode, cGrpBy, cHdrGrp, cHeader ) CLASS TReport

   LOCAL i, nSum, nCenter1, nCenter2, nPosTitle, cTitle1, cTitle2, cLinea

   HB_SYMBOL_UNUSED( lMode )

   nSum := 0
   FOR i := 1 TO Len( aWidths )
      nSum := nSum + aWidths[ i ]
   NEXT i
   nPosTitle := At( '|', cTitle )
   IF nPosTitle > 0
      cTitle1 := Left( cTitle, nPosTitle - 1 )
      cTitle2 := RTrim( SubStr( cTitle, nPosTitle + 1 ) )
   ELSE
      cTitle1 := cTitle
      cTitle2 := ''
   ENDIF
   cTitle1 := RTrim( cTitle1 ) + cHeader
   nCenter1 := ( ( nSum - Len( cTitle1 ) ) / 2 ) - 1
   IF Len( cTitle2 ) > 0
      nCenter2 := ( ( nSum - Len( cTitle2 ) ) / 2 ) - 1
   ENDIF

   ::nPageNumber ++

   IF ::lExcel
      cLinea := PadR( _OOHG_Messages( MT_MISCELL, 8 ), 6 ) + Str( ::nPageNumber, 4 ) + Space( 7 ) + cTitle1 + Space( 7 ) + DToC( Date() )
      ::oPrint:PrintData( nLin, ::nLMargin, cLinea, NIL, ::nFSize )
      nLin ++
      IF Len( cTitle2 ) > 0
         ::oPrint:PrintData( nLin, ::nLMargin + nCenter2, cTitle2 + Space( 7 ) + Time(), NIL, ::nFSize )
      ELSE
         ::oPrint:PrintData( nLin, ::nLMargin + nSum + Len( aWidths ) - 11, Time(), NIL, ::nFSize )
      ENDIF
      nLin ++
   ELSE
      cLinea := PadR( _OOHG_Messages( MT_MISCELL, 8 ), 6 ) + Str( ::nPageNumber, 4 )
      ::oPrint:PrintData( nLin, ::nLMargin, cLinea, NIL, ::nFSize )
      ::oPrint:PrintData( nLin, ::nLMargin + nCenter1, cTitle1, NIL, ::nFSize + 1, .T. )
      ::oPrint:PrintData( nLin, ::nLMargin + nSum + Len( aWidths ) - 11, DToC( Date() ), NIL, ::nFSize )
      nLin ++
      IF Len( cTitle2 ) > 0
         ::oPrint:PrintData( nLin, ::nLMargin + nCenter2, cTitle2, NIL, ::nFSize + 1, .T. )
      ENDIF
       ::oPrint:PrintData( nLin, ::nLMargin + nSum + Len( aWidths ) - 11, Time(), NIL, ::nFSize )
       nLin ++
   ENDIF

   cLinea := ""
   FOR i := 1 TO  Len( aWidths )
      cLinea := cLinea + Replicate( '-', aWidths[ i ] )
   NEXT i
   nLin ++
   ::oPrint:PrintData( nLin, ::nLMargin, cLinea, NIL, ::nFSize )
   nLin ++

   cLinea := ""
   FOR i := 1 TO Len( aWidths )
      cLinea := cLinea + SubStr( aHeaders1[ i ], 1, aWidths[ i ] ) + Space( aWidths[ i ] - Len( aHeaders1[ i ] ) )
   NEXT i
   ::oPrint:PrintData( nLin, ::nLMargin, cLinea, NIL, ::nFSize, .T. )
   nLin ++

   cLinea := ""
   FOR i := 1 TO Len( aWidths )
      cLinea := cLinea + SubStr( aHeaders2[ i ], 1, aWidths[ i ] ) + Space( aWidths[ i ] - Len( aHeaders2[ i ] ) )
   NEXT i
   ::oPrint:PrintData( nLin, ::nLMargin, cLinea, NIL, ::nFSize, .T. )
   nLin ++

   cLinea := ""
   FOR i := 1 TO  Len( aWidths )
      cLinea := cLinea + Replicate( '-', aWidths[ i ] )
   NEXT i
   ::oPrint:PrintData( nLin, ::nLMargin, cLinea, NIL, ::nFSize )
   nLin += 2

   IF ::nPageNumber == 1 .AND. cGrpBy # NIL
      ::oPrint:PrintData( nLin, ::nLMargin, '** ' + cHdrGrp + " " + &( cGrpBy ), NIL, ::nFSize, .T. )
      nLin ++
   ENDIF

   RETURN nLin

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ExtReport1( cFileRep, cHeader ) CLASS TReport

   LOCAL nCount, i, cTitle, aHeaders1, aHeaders2, aFields, aWidths, aTotals, aFormats, lGroupEject
   LOCAL nLPP, nCPL, nLLMargin, cAlias, lDos, lPreview, lSelect, cGraphic, lMul, nFI, nCI, cData
   LOCAL nFF, nCF, cGrpBy, cHdrGrp, lLandscape, lNoProp, cReport, nPaperSize, cGraphicAlt
   LOCAL nRes, nBin, nDuplex, lCollate, nCopies, lColor, nScale, nLength, nWidth, cLine

   IF ! File( cFileRep + '.rpt' )
      MsgStop( _OOHG_Messages( MT_MISCELL, 21 ) + DQM( cFileRep + ".rpt" ) + ".", _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN NIL
   ENDIF

   // load file
   cReport := MemoRead( cFileRep + '.rpt' )
   // count lines
   nCount := MLCount( cReport )
   // find "DO REPORT" or "DEFINE REPORT" line
   FOR i := 1 TO nCount
      cLine := AllTrim( MemoLine( cReport, 500, i ) )
      IF Right( cLine, 1 ) == ";"
         cLine := RTrim( Left( cLine, Len( cLine ) - 1 ) )
      ENDIF
      cLine := " " + cLine + " "
      IF ( ( Upper( Left( cLine, 4 ) ) == " DO " .AND. Upper( Left( LTrim( SubStr( cLine, 5 ) ), 7 ) ) == "REPORT " ) .OR. ;
           ( Upper( Left( cLine, 8 ) ) == " DEFINE " .AND. Upper( Left( LTrim( SubStr( cLine, 9 ) ), 7 ) ) == "REPORT " ) )
         AAdd ( ::aLines, cLine )
         EXIT
      ENDIF
   NEXT i
   IF i > nCount
      MsgStop( _OOHG_Messages( MT_MISCELL, 23, 1 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN NIL
   ENDIF
   // load lines until EOF or END REPORT line
   i ++
   DO WHILE i <= nCount
      cLine := AllTrim( MemoLine( cReport, 500, i ) )
      IF Right( cLine, 1 ) == ";"
         cLine := RTrim( Left( cLine, Len( cLine ) - 1 ) )
      ENDIF
      cLine := " " + cLine + " "
      IF Upper( Left( cLine, 12 ) ) == " END REPORT "
         EXIT
      ENDIF
      AAdd ( ::aLines, cLine )
      i ++
   ENDDO

   // load title
   cTitle := ::LeaDato( 'REPORT', 'TITLE', '' )
   IF Len( cTitle ) > 0
      cTitle := &cTitle
   ENDIF
   // load headers
   aHeaders1 := ::LeaDatoH( 'REPORT', 'HEADERS', '{}', 1 )
   aHeaders1 := &aHeaders1
   aHeaders2 := ::LeaDatoH( 'REPORT', 'HEADERS', '{}', 2 )
   aHeaders2 := &aHeaders2
   // load fields
   aFields := ::LeaDato( 'REPORT', 'FIELDS', '{}' )
   IF Len( aFields ) == 0
      MsgStop( _OOHG_Messages( MT_MISCELL, 23, 2 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN NIL
   ENDIF
   aFields := &aFields
   IF ! HB_ISARRAY( aFields ) .OR. Len( aFields ) == 0
      MsgStop( _OOHG_Messages( MT_MISCELL, 23, 3 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN NIL
   ENDIF
   // load widths
   aWidths := ::LeaDato( 'REPORT', 'WIDTHS', '{}' )
   IF Len( aWidths )=0
      MsgStop( _OOHG_Messages( MT_MISCELL, 23, 4), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN NIL
   ENDIF
   aWidths := &aWidths
   IF ! HB_ISARRAY( aWidths ) .OR. Len( aWidths ) == 0
      MsgStop( _OOHG_Messages( MT_MISCELL, 23, 5 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN NIL
   ENDIF
   // load totals
   aTotals := ::LeaDato( 'REPORT', 'TOTALS', NIL )
   IF aTotals <> NIL
      aTotals := &aTotals
   ENDIF
   // load formats
   aFormats := ::LeaDato( 'REPORT', 'NFORMATS', NIL )
   IF aFormats <> NIL
      aFormats := &aFormats
   ENDIF
   // load workarea
   cAlias := ::LeaDato( 'REPORT', 'WORKAREA', '' )
   // load lines per page
   cData := ::LeaDato( 'REPORT', 'LPP', '' )
   IF Empty( cData )
      nLPP := NIL
   ELSE
      nLPP := Val( cData )
   ENDIF
   // load characters per line
   cData := ::LeaDato( 'REPORT', 'CPL', '' )
   IF Empty( cData )
      nCPL := NIL
   ELSE
      nCPL := Val( cData )
   ENDIF
   // load left margin
   nLLMargin := Val( ::LeaDato( 'REPORT', 'LMARGIN', '0' ) )
   // load papersize
   nPaperSize := ::LeaDato( 'REPORT', 'PAPERSIZE', 'DMPAPER_LETTER' )
   IF nPaperSize == 'DMPAPER_USER'
      nPaperSize := 255
   ELSE
      i := AScan( _OOHG_PaperConstants, nPaperSize )
      IF i == 0
         i := 1
      ENDIF
      nPaperSize := i
   ENDIF
   // load no fixed (proportional) font
   lNoProp := ::LeaDatoLogic( 'REPORT', 'NOFIXED' )
   // load dos mode
   lDos := ::LeaDatoLogic( 'REPORT', 'DOSMODE' )
   // load preview
   lPreview := ::LeaDatoLogic( 'REPORT', 'PREVIEW' )
   // load select
   lSelect := ::LeaDatoLogic( 'REPORT', 'SELECT' )
   // load image
   nFI := nCI := nFF := nCF := 0
   cGraphic := AllTrim( ::Clean( ::LeaImage() ) )   // IMAGE <cgraphic> AT <nfi>, <nci> TO <nff>, <ncf>
   IF Upper( Left( cGraphic, 3 ) ) == "AT "
      nFI := Val( ::LeaRowI( 1 ) )
      nCI := Val( ::LeaColI( 1 ) )
      nFF := Val( ::LeaRowI( 2 ) )
      nCF := Val( ::LeaColI( 2 ) )
   ELSE
      cGraphicAlt := ::LeaDato( 'DEFINE REPORT', 'IMAGE', '' )   // IMAGE { <cgraphic>, <nfi>, <nci> TO <nff>, <ncf> }
      IF ! Empty( cGraphicAlt )
         cGraphicAlt := &( cGraphicalt )
         IF HB_ISARRAY( cGraphicAlt )
            ASize( cGraphicAlt, 5 )
            IF HB_ISSTRING( cGraphicAlt[ 1 ] )
               cGraphic := cGraphicAlt[ 1 ]
               ASSIGN nFI VALUE cGraphicAlt[ 2 ] TYPE "N"
               ASSIGN nCI VALUE cGraphicAlt[ 3 ] TYPE "N"
               ASSIGN nFF VALUE cGraphicAlt[ 4 ] TYPE "N"
               ASSIGN nCF VALUE cGraphicAlt[ 5 ] TYPE "N"
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   // load multiple
   lMul := ::LeaDatoLogic( 'REPORT', 'MULTIPLE' )
   // load grouped by
   cGrpBy := ::LeaDato( 'REPORT', 'GROUPED BY', '' )
   // load group header
   cHdrGrp := ::Clean( ::LeaDato( 'REPORT', 'HEADRGRP', '' ) )
   // load landscape
   lLandscape := ::LeaDatoLogic( 'REPORT', 'LANDSCAPE' )
   // load eject on group
   lGroupEject := ::LeaDatoLogic( 'REPORT', 'GROUPEJECT' )
   // load report header if not already defined
   IF Empty( cHeader )
      cHeader := ::Clean( ::LeaDato( 'REPORT', 'HEADING', '' ) )
   ENDIF
   // load print quality
   cData := ::LeaDato( 'REPORT', 'QUALITY', '' )
   IF Empty( cData )
      nRes := NIL
   ELSE
      nRes := Val( cData )
   ENDIF
   // load printer tray
   cData := ::LeaDato( 'REPORT', 'DEFAULTSOURCE', '' )
   IF Empty( cData )
      nBin := NIL
   ELSE
      nBin := Val( cData )
   ENDIF
   // load duplex priting
   cData := ::LeaDato( 'REPORT', 'DUPLEX', '' )
   IF Empty( cData )
      nDuplex := NIL
   ELSE
      nDuplex := Val( cData )
   ENDIF
   // load output collation
   lCollate := ::LeaDatoLogic( 'REPORT', 'COLLATE' )
   // load number of copies
   cData := ::LeaDato( 'REPORT', 'COPIES', '' )
   IF Empty( cData )
      nCopies := NIL
   ELSE
      nCopies := Val( cData )
   ENDIF
   // load color printing
   lColor := ::LeaDatoLogic( 'REPORT', 'COLOR' )
   // load scaled printing
   cData := ::LeaDato( 'REPORT', 'SCALE', '' )
   IF Empty( cData )
      nScale := NIL
   ELSE
      nScale := Val( cData )
   ENDIF
   // load paper length
   cData := ::LeaDato( 'REPORT', 'PAPERLENGTH', '' )
   IF Empty( cData )
      nLength := NIL
   ELSE
      nLength := Val( cData )
   ENDIF
   // load paper width
   cData := ::LeaDato( 'REPORT', 'PAPERWIDTH', '' )
   IF Empty( cData )
      nWidth := NIL
   ELSE
      nWidth := Val( cData )
   ENDIF

   // execute report
   ::EasyReport1( cTitle, aHeaders1, aHeaders2, aFields, aWidths, aTotals, nLPP, lDos, ;
      lPreview, cGraphic, nFI, nCI, nFF, nCF, lMul, cGrpBy, cHdrGrp, lLandscape, nCPL, ;
      lSelect, cAlias, nLLMargin, aFormats, nPaperSize, cHeader, lNoProp, lGroupEject, ;
      nRes, nBin, nDuplex, lCollate, nCopies, lColor, nScale, nLength, nWidth )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD LeaDato( cName, cKey, cDefault ) CLASS TReport

   LOCAL i, nPos

   cName := " " + Upper( cName ) + " "
   i := AScan( ::aLines, { |l| At( cName, Upper( l ) ) > 0 } ) + 1
   IF i > 1
      cKey := " " + Upper( cKey ) + " "
      DO WHILE i <= Len( ::aLines )
         nPos := At( cKey, Upper( ::aLines[ i ] ) )
         IF nPos > 0
            RETURN AllTrim( SubStr( ::aLines[ i ], nPos + Len( cKey ) ) )
         ENDIF
         i ++
      ENDDO
   ENDIF

   RETURN cDefault

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD LeaImage() CLASS TReport

   LOCAL i, nPos1, nPos2, cLine

   i := AScan( ::aLines, { |l| At( ' REPORT ', Upper( l ) ) > 0 } ) + 1
   IF i > 1
      DO WHILE i <= Len( ::aLines )
         nPos1 := At( ' IMAGE ', Upper( ::aLines[ i ] ) )
         IF nPos1 > 0
            nPos2 := At( ' AT ', Upper( SubStr( ::aLines[ i ], nPos1 + 6 ) ) )
            IF nPos2 > 0
               cLine := AllTrim( SubStr( ::aLines[ i ], nPos1 + 6,  nPos2 ) )
            ELSE
               cLine := AllTrim( SubStr( ::aLines[ i ], nPos1 + 6 ) )
            ENDIF
            RETURN cLine
         ENDIF
         i ++
      ENDDO
   ENDIF

   RETURN ''

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD LeaDatoH( cName, cKey, cDefault, nPar ) CLASS TReport           

   LOCAL i, nPos, nPos1, nPos2, cLine

   cName := " " + Upper( cName ) + " "
   i := AScan( ::aLines, { |l| At( cName, Upper( l ) ) > 0 } ) + 1
   IF i > 1
      cKey := " " + Upper( cKey ) + " "
      DO WHILE i <= Len( ::aLines )
         nPos := At( cKey, Upper( ::aLines[ i ] ) )
         IF nPos > 0
            cLine := SubStr( ::aLines[ i ], nPos )
            IF nPar == 1
               nPos1 := At( '{', cLine )
               nPos2 := At( '}', cLine )
            ELSE
               nPos1 := RAt( '{', cLine )
               nPos2 := RAt( '}', cLine )
            ENDIF
            RETURN SubStr( cLine, nPos1, nPos2 - nPos1 + 1 )
         ENDIF
         i ++
      ENDDO
   ENDIF

   RETURN cDefault

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD LeaDatoLogic( cName, cKey ) CLASS TReport           

   LOCAL i

   cName := " " + Upper( cName ) + " "
   i := AScan( ::aLines, { |l| At( cName, Upper( l ) ) > 0 } ) + 1
   IF i > 1
      cKey := " " + Upper( cKey ) + " "
      DO WHILE i <= Len( ::aLines )
         IF At( cKey, Upper( ::aLines[ i ] ) ) > 0
            RETURN .T.
         ENDIF
         i ++
      ENDDO
   ENDIF

   RETURN .F.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Clean( cValue ) CLASS TReport

   cValue := StrTran( cValue, '"', '' )
   cValue := StrTran( cValue, "'", "" )

   RETURN cValue

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD LeaRowI( nPar ) CLASS TReport

   LOCAL i, nPos1, nPos2, nPos3, cLine, nRow := "0"

   i := AScan( ::aLines, { |l| At( ' REPORT ', Upper( l ) ) > 0 } ) + 1
   IF i > 1
      DO WHILE i <= Len( ::aLines )
         nPos1 := At( ' IMAGE ', Upper( ::aLines[ i ] ) )
         IF nPos1 > 0
            cLine := SubStr( ::aLines[ i ], nPos1 + 6 )
            nPos2 := At( ' AT ', Upper( cLine ) )
            nPos3 := At( ' TO ', Upper( cLine ) )
            IF nPos2 > 0 .AND. nPos3 > 0 .AND. nPos2 < nPos3
               IF nPar == 1
                  cLine := SubStr( cLine, nPos2 + 4, nPos3 - 4 )
               ELSE
                  cLine := SubStr( cLine, nPos3 + 4 )
               ENDIF
               nPos3 := At( ",", cLine )
               IF nPos3 > 0
                  nRow := AllTrim( SubStr( cLine, 1, nPos3 - 1 ) )
               ENDIF
            ENDIF
            EXIT
         ENDIF
         i ++
      ENDDO
   ENDIF

   RETURN nRow

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD LeaColI( nPar ) CLASS TReport

   LOCAL i, nPos1, nPos2, nPos3, cLine, nCol := "0"

   i := AScan( ::aLines, { |l| At( ' REPORT ', Upper( l ) ) > 0 } ) + 1
   IF i > 1
      DO WHILE i <= Len( ::aLines )
         nPos1 := At( ' IMAGE ', Upper( ::aLines[ i ] ) )
         IF nPos1 > 0
            cLine := SubStr( ::aLines[ i ], nPos1 + 6 )
            nPos2 := At( ' AT ', Upper( cLine ) )
            nPos3 := At( ' TO ', Upper( cLine ) )
            IF nPos2 > 0 .AND. nPos3 > 0 .AND. nPos2 < nPos3
               IF nPar == 1
                  cLine := SubStr( cLine, nPos2 + 4, nPos3 - 4 )
               ELSE
                  cLine := SubStr( cLine, nPos3 + 4 )
               ENDIF
               nPos3 := At( ",", cLine )
               IF nPos3 > 0
                  nCol := AllTrim( SubStr( cLine, nPos3 + 1 ) )
               ENDIF
            ENDIF
            EXIT
         ENDIF
         i ++
      ENDDO
   ENDIF

   RETURN nCol

/*
 * MINIFRM-Print FRM files TO TPRINT
 * V. 1.0  
 * Created by Daniel Piperno
 * Modified by Ciro Vargas Clemow
 *
 * Characteristics:
 * Works like the standard FRM.
 * TO PRINT clause sends the report to the printer, when omited a preview is shown.
 * Prints to the default printer.
 * When report width is <= 80 it uses Courier New 12, if not uses Courier New 7.
 *
 * Differences width standard FRM:
 * Added:
 *   Numbers are displayed usend thousand separators unless NOSEPARATORS clause is specified.
 *   Prints titles, subtotals and total using BOLD.
 * Not supported:
 *   PLAIN option.
 *   TO FILE option.
 *   Translations of special characters, CHR( x ).
 *   Page eject before report start.
 */


#include "error.ch"

// Report parameters
#define  _RF_FIRSTCOL               0               // First column offset
#define  _RF_FIRSTROW               1               // First row offset
#define  _RF_ROWINC                 4               // Line spacing
#define  _RF_FONT                   "Courier New"   // Use monospaced fonts not proporcional ones
#define  _RF_SIZECONDENSED          7               // Font size for widths greater than 80 columns ( 132 )
#define  _RF_SIZENORMAL             12              // Font size for widths lesser than 80 columns
#define  _RF_ROWSINLETTER           60              // Max number of rows for letter size paper before changing to legal size.

// Nation Message
#define  _RF_PAGENO                 3               // Page
#define  _RF_SUBTOTAL               4               // Subtotal
#define  _RF_SUBSUBTOTAL            5               // Sub-subtotal
#define  _RF_TOTAL                  6               // Total

// Buffer sizes
#define  SIZE_FILE_BUFF             1990
#define  SIZE_LENGTHS_BUFF          110
#define  SIZE_OFFSETS_BUFF          110
#define  SIZE_EXPR_BUFF             1440
#define  SIZE_FIELDS_BUFF           300
#define  SIZE_PARAMS_BUFF           24

// Offsets
#define  LENGTHS_OFFSET             5
#define  OFFSETS_OFFSET             115
#define  EXPR_OFFSET                225
#define  FIELDS_OFFSET              1665
#define  PARAMS_OFFSET              1965
#define  FIELD_WIDTH_OFFSET         1
#define  FIELD_TOTALS_OFFSET        6
#define  FIELD_DECIMALS_OFFSET      7
#define  FIELD_CONTENT_EXPR_OFFSET  9
#define  FIELD_HEADER_EXPR_OFFSET   11
#define  PAGE_HDR_OFFSET            1
#define  GRP_EXPR_OFFSET            3
#define  SUB_EXPR_OFFSET            5
#define  GRP_HDR_OFFSET             7
#define  SUB_HDR_OFFSET             9
#define  PAGE_WIDTH_OFFSET          11
#define  LNS_PER_PAGE_OFFSET        13
#define  LEFT_MRGN_OFFSET           15
#define  RIGHT_MGRN_OFFSET          17
#define  COL_COUNT_OFFSET           19
#define  DBL_SPACE_OFFSET           21
#define  SUMMARY_RPT_OFFSET         22
#define  PE_OFFSET                  23
#define  OPTION_OFFSET              24

// Elements of the report's array
#define  RP_HEADER                  1
#define  RP_WIDTH                   2
#define  RP_LMARGIN                 3
#define  RP_RMARGIN                 4
#define  RP_LINES                   5
#define  RP_SPACING                 6
#define  RP_BEJECT                  7
#define  RP_AEJECT                  8
#define  RP_PLAIN                   9
#define  RP_SUMMARY                 10
#define  RP_COLUMNS                 11
#define  RP_GROUPS                  12
#define  RP_HEADING                 13
#define  RP_COUNT                   13

// Elements of the report's RP_COLUMNS subarray
#define  RC_EXP                     1
#define  RC_TEXT                    2
#define  RC_TYPE                    3
#define  RC_HEADER                  4
#define  RC_WIDTH                   5
#define  RC_DECIMALS                6
#define  RC_TOTAL                   7
#define  RC_PICT                    8
#define  RC_COUNT                   8

// Elements of the report's RP_GROUPS subarray
#define  RG_EXP                     1
#define  RG_TEXT                    2
#define  RG_TYPE                    3
#define  RG_HEADER                  4
#define  RG_AEJECT                  5
#define  RG_COUNT                   5

// Errors
#define  F_OK                       0               // No error
#define  F_EMPTY                    -3              // Empty file
#define  F_ERROR                    -1              // Unknown error
#define  F_NOEXIST                  2               // File not found

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION __ReportFormWin( cFRMName, lPrinter, cAltFile, lNoConsole, bFor, bWhile, nNext, nRecord, lRest, lPlain, cHeading, ;
      lBEject, lSummary, lNoSeps, lSelect, lPreview, lLandscape, nPapersize, nRes, nBin, nDuplex, lCollate, ;
      nCopies, lColor, nScale, nLength, nWidth )

   LOCAL nPrevious

   nPrevious := SetInteractiveClose()
   SET INTERACTIVECLOSE ON

   TReportFormWin():DoReport( cFRMName, lPrinter, cAltFile, lNoConsole, bFor, bWhile, nNext, nRecord, lRest, lPlain, cHeading, ;
      lBEject, lSummary, lNoSeps, lSelect, lPreview, lLandscape, nPapersize, nRes, nBin, nDuplex, lCollate, ;
      nCopies, lColor, nScale, nLength, nWidth )

   SetInteractiveClose( nPrevious )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TReportFormWin FROM TPRINTBASE

   DATA aGroupTotals              INIT NIL
   DATA aReportData               INIT NIL
   DATA aReportTotals             INIT NIL
   DATA cExprBuff                 INIT NIL
   DATA cLengthsBuff              INIT NIL
   DATA cOffsetsBuff              INIT NIL
   DATA lFirstPass                INIT .T.
   DATA lNoSeps                   INIT .F.
   DATA nLinesLeft                INIT 0
   DATA nMaxLinesAvail            INIT 0
   DATA nPageNumber               INIT 0
   DATA nPoscol                   INIT 0
   DATA nPosrow                   INIT 0
   DATA oPrint                    INIT NIL
   DATA Type                      INIT "REPORTFORMWIN" READONLY

   METHOD DoEvents
   METHOD DoReport
   METHOD EjectPage
   METHOD GetExpr
   METHOD LoadFRM
   METHOD PrintHeader
   METHOD PrintLine
   METHOD PrintRecord

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DoReport( cFRMName, lPrinter, cAltFile, lNoConsole, bFor, bWhile, nNext, nRecord, lRest, lPlain, cHeading, ;
      lBEject, lSummary, lNoSeps, lSelect, lPreview, lLandscape, nPapersize, nRes, nBin, nDuplex, lCollate, ;
      nCopies, lColor, nScale, nLength, nWidth ) CLASS TReportFormWin

   LOCAL oError, lSale := .F., nCol, nGroup, lAnySubTotals, sAuxST, lAnyTotals, xBreakVal, lBroke := .F.

   HB_SYMBOL_UNUSED( cAltFile )
   HB_SYMBOL_UNUSED( lNoConsole )
   HB_SYMBOL_UNUSED( lPlain )

   IF cFRMName == NIL
      oError := ErrorNew()
      oError:severity  := ES_ERROR
      oError:genCode   := EG_ARG
      oError:subSystem := "FRMLBL"
      Eval( ErrorBlock(), oError )
   ELSE
      IF At( ".", cFRMName ) == 0
         cFRMName := RTrim( cFRMName ) + ".FRM"
      ENDIF
   ENDIF

   ASSIGN lPrinter   VALUE lPrinter   TYPE "L"  DEFAULT .F.
   ASSIGN cHeading   VALUE cHeading   TYPE "CM" DEFAULT ""
   ASSIGN ::lNoSeps  VALUE lNoSeps    TYPE "L"
   ASSIGN lSelect    VALUE lSelect    TYPE "L"  DEFAULT .T.
   ASSIGN lPreview   VALUE lPreview   TYPE "L"  DEFAULT ! lPrinter
   ASSIGN lLandscape VALUE lLandscape TYPE "L"  DEFAULT NIL
   ASSIGN nRes       VALUE nRes       TYPE "N"  DEFAULT -2    // low resolution
   ASSIGN nBin       VALUE nBin       TYPE "N"  DEFAULT NIL
   ASSIGN nDuplex    VALUE nDuplex    TYPE "N"  DEFAULT NIL
   ASSIGN lCollate   VALUE lCollate   TYPE "L"  DEFAULT .F.
   ASSIGN nCopies    VALUE nCopies    TYPE "N"  DEFAULT NIL
   ASSIGN lColor     VALUE lColor     TYPE "L"  DEFAULT .F.
   ASSIGN nLength    VALUE nLength    TYPE "N"  DEFAULT NIL
   ASSIGN nLength    VALUE nLength    TYPE "N"  DEFAULT NIL
   ASSIGN nWidth     VALUE nWidth     TYPE "N"  DEFAULT NIL

   BEGIN SEQUENCE

      ::aReportData := ::LoadFRM( cFRMName )

      IF ValType( nPaperSize ) # "N"
         IF ::aReportData[ RP_LINES ] <= _RF_ROWSINLETTER
            nPaperSize := 1
         ELSE
            nPaperSize := 5
         ENDIF
      ENDIF

      ::oPrint := Tprint()
      ::oPrint:Init()
      ::oPrint:SelPrinter( lSelect, lPreview, lLandscape, nPapersize, NIL, NIL, nRes, nBin, nDuplex, lCollate, nCopies, lColor, nScale, nLength, nWidth )
      IF ::oPrint:lPrError
         ::oPrint:Release()
         lSale := .T.
         BREAK
      ENDIF

      ::nMaxLinesAvail := ::aReportData[ RP_LINES ]
      IF lSummary # NIL
         ::aReportData[ RP_SUMMARY ] := lSummary
      ENDIF
      IF lBEject # NIL .AND. lBEject
         ::aReportData[ RP_BEJECT ] := .F.
      ENDIF
      ::aReportData[ RP_HEADING ] := cHeading

      ::nPageNumber := 1
      ::nLinesLeft := ::aReportData[ RP_LINES ]

      ::oPrint:BeginDoc()
      ::oPrint:BeginPage()

      ::nPosRow := _RF_FIRSTROW
      ::nPosCol := _RF_FIRSTCOL

      // Print header
      ::PrintHeader()

      // Initialize totals
      ::aReportTotals := Array( Len( ::aReportData[ RP_GROUPS ] ) + 1, Len( ::aReportData[ RP_COLUMNS ] ) )
      FOR nCol := 1 TO Len( ::aReportData[ RP_COLUMNS ] )
         IF ::aReportData[ RP_COLUMNS, nCol, RC_TOTAL ]
            FOR nGroup := 1 TO Len( ::aReportTotals )
              ::aReportTotals[ nGroup, nCol ] := 0
            NEXT
         ENDIF
      NEXT
      ::aGroupTotals := Array( Len( ::aReportData[ RP_GROUPS ] ) )

      // Generate the report
      ::nCount := 0
      dbEval( { || ::DoEvents(), ::PrintRecord() }, bFor, bWhile, nNext, nRecord, lRest )

      // Print totals
      FOR nGroup := Len( ::aReportData[ RP_GROUPS ] ) TO 1 STEP -1

         // The group has a total?
         lAnySubTotals := .F.
         FOR nCol := 1 TO Len( ::aReportData[ RP_COLUMNS ] )
            IF ::aReportData[ RP_COLUMNS, nCol, RC_TOTAL ]
               lAnySubTotals := .T.
               EXIT
            ENDIF
         NEXT

         IF ! lAnySubTotals
            LOOP
         ENDIF

         IF ::nLinesLeft < 2
            ::EjectPage()
            IF ::aReportData[ RP_PLAIN ]
               ::nLinesLeft := 1000
            ELSE
               ::PrintHeader()
            ENDIF
         ENDIF

         // Print subtotal
         ::PrintLine( iif( nGroup == 1, NationMsg( _RF_SUBTOTAL ), NationMsg( _RF_SUBSUBTOTAL ) ), .T. )

         // Build subtotal line
         sAuxSt := ""
         FOR nCol := 1 TO Len( ::aReportData[ RP_COLUMNS ] )
            IF ::aReportData[ RP_COLUMNS, nCol, RC_TOTAL ]
               sAuxSt := sAuxSt + " " + Transform( ::aReportTotals[ nGroup + 1, nCol ], ConvPic( ::aReportData[ RP_COLUMNS, nCol, RC_PICT ] ) )
            ELSE
               sAuxSt := sAuxSt + " " + Space( ::aReportData[ RP_COLUMNS, nCol, RC_WIDTH ] )
            ENDIF
         NEXT

         // Print subtotals
         ::PrintLine( SubStr( sAuxSt, 2 ), .T. )
      NEXT

      // Build the grand total
      IF ::nLinesLeft < 2
         ::EjectPage()
         IF ::aReportData[ RP_PLAIN ]
            ::nLinesLeft := 1000
         ELSE
            ::PrintHeader()
         ENDIF
      ENDIF

      // Print the totals
      lAnyTotals := .F.
      FOR nCol := 1 TO Len( ::aReportData[ RP_COLUMNS ] )
         IF ::aReportData [ RP_COLUMNS, nCol, RC_TOTAL ]
            lAnyTotals := .T.
            EXIT
         ENDIF
      NEXT nCol
      IF lAnyTotals
         // Print message
         ::PrintLine( NationMsg( _RF_TOTAL ), .T. )
         // Build the totals
         sAuxSt := ""
         FOR nCol := 1 TO Len( ::aReportData[ RP_COLUMNS ] )
            IF ::aReportData[ RP_COLUMNS, nCol, RC_TOTAL ]
               sAuxSt := sAuxSt + " " + Transform( ::aReportTotals[ 1, nCol ], ConvPic( ::aReportData[ RP_COLUMNS, nCol, RC_PICT ] ) )
            ELSE
               sAuxSt := sAuxSt + " " + Space( ::aReportData[ RP_COLUMNS, nCol, RC_WIDTH ] )
            ENDIF
         NEXT nCol
         // Print the totals
         ::PrintLine( SubStr( sAuxSt, 2 ), .T. )
      ENDIF

      // Eject the paper. Needed under DOS. It's better not to send this under Windows.
      /*
      IF ::aReportData[ RP_AEJECT ]
         ::EjectPage()
      ENDIF
      */

   RECOVER USING xBreakVal

      lBroke := .T.

   END SEQUENCE

   IF ! lSale
      ::oPrint:EndPage()
      ::oPrint:EndDoc()

      IF lBroke
         BREAK xBreakVal
      END
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DoEvents CLASS TReportFormWin

   IF ++ ::nCount % 10 == 0
      DO EVENTS
      ::nCount := 0
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintRecord() CLASS TReportFormWin

   LOCAL aRecordHeader := {}, aRecordToPrint := {}
   LOCAL nCol, nGroup, lEjectGrp := .F., nMaxLines
   LOCAL nLine, cLine, lAnySubTotals

   // Add column total
   FOR nCol := 1 TO Len( ::aReportData[ RP_COLUMNS ] )
      IF ::aReportData[ RP_COLUMNS, nCol, RC_TOTAL ]
         ::aReportTotals[ 1, nCol ] += Eval( ::aReportData[ RP_COLUMNS, nCol, RC_EXP ] )
      ENDIF
   NEXT

   // If some group changed, sum total
   IF ! ::lFirstPass
      FOR nGroup := Len( ::aReportData[ RP_GROUPS ] ) TO 1 STEP -1
         lAnySubTotals := .F.
         FOR nCol := 1 TO Len( ::aReportData[ RP_COLUMNS ] )
            IF ::aReportData[ RP_COLUMNS, nCol, RC_TOTAL ]
               lAnySubTotals := .T.
               EXIT
            ENDIF
         NEXT

         IF ! lAnySubTotals
            LOOP
         ENDIF

         // Check if the group changed
         IF hb_ValToStr( Eval( ::aReportData[ RP_GROUPS, nGroup, RG_EXP ] ), ;
            ::aReportData[ RP_GROUPS, nGroup, RG_TYPE ] ) # ::aGroupTotals[ nGroup ]
            AAdd( aRecordHeader, iif( nGroup == 1, NationMsg( _RF_SUBTOTAL ), NationMsg( _RF_SUBSUBTOTAL ) ) )
            AAdd( aRecordHeader, "" )

            IF ( nGroup == 1 )
               lEjectGrp := ::aReportData[ RP_GROUPS, nGroup, RG_AEJECT ]
            ENDIF

            // Sum columns
            FOR nCol := 1 TO Len( ::aReportData[ RP_COLUMNS ] )
               IF ::aReportData[ RP_COLUMNS, nCol, RC_TOTAL ]
                  aRecordHeader[ Len( aRecordHeader ) ] += Transform( ::aReportTotals[ nGroup + 1, nCol ], ConvPic( ::aReportData[ RP_COLUMNS, nCol, RC_PICT ] ) )
                  ::aReportTotals[ nGroup + 1, nCol ] := 0
               ELSE
                  aRecordHeader[ Len( aRecordHeader ) ] += Space( ::aReportData[ RP_COLUMNS, nCol, RC_WIDTH ] )
               ENDIF
               aRecordHeader[ Len( aRecordHeader ) ] += " "
            NEXT
            aRecordHeader[ Len( aRecordHeader ) ] := Left( aRecordHeader[ Len( aRecordHeader ) ], Len( aRecordHeader[ Len( aRecordHeader ) ] ) - 1 )
         ENDIF
      NEXT

   ENDIF

   ::lFirstPass := .F.

   IF ( Len( aRecordHeader ) > 0 ) .AND. lEjectGrp
      IF Len( aRecordHeader ) > ::nLinesLeft
         ::EjectPage()
         IF ( ::aReportData[ RP_PLAIN ] )
            ::nLinesLeft := 1000
         ELSE
            ::PrintHeader()
         ENDIF
      ENDIF
      AEval( aRecordHeader, { |HeaderLine| ::PrintLine( HeaderLine, .T. ) } )

      aRecordHeader := {}
      ::EjectPage()
      IF ( ::aReportData[ RP_PLAIN ] )
         ::nLinesLeft := 1000
      ELSE
         ::PrintHeader()
      ENDIF
   ENDIF

   // Add a header to the changed groups
   FOR nGroup := 1 TO Len( ::aReportData[ RP_GROUPS ] )
      IF hb_ValToStr( Eval( ::aReportData[ RP_GROUPS, nGroup, RG_EXP ] ), ::aReportData[ RP_GROUPS, nGroup, RG_TYPE ] ) == ::aGroupTotals[ nGroup ]
      ELSE
         AAdd( aRecordHeader, "" )
         AAdd( aRecordHeader, iif( nGroup == 1, "** ", "* " ) + ;
            ::aReportData[ RP_GROUPS, nGroup, RG_HEADER ] + " " + ;
            hb_ValToStr( Eval( ::aReportData[ RP_GROUPS, nGroup, RG_EXP ] ), ;
            ::aReportData[ RP_GROUPS, nGroup, RG_TYPE ] ) )
      ENDIF
   NEXT

   // Was a header generated?
   IF Len( aRecordHeader ) > 0
      // Print if it fits
      IF Len( aRecordHeader ) > ::nLinesLeft
         ::EjectPage()
         IF ::aReportData[ RP_PLAIN ]
            ::nLinesLeft := 1000
         ELSE
            ::PrintHeader()
         ENDIF
      ENDIF

      // Print header
      AEval( aRecordHeader, { |HeaderLine| ::PrintLine( HeaderLine, .T. ) } )

      ::nLinesLeft -= Len( aRecordHeader )
      IF ::nLinesLeft == 0
         ::EjectPage()
         IF ::aReportData[ RP_PLAIN ]
            ::nLinesLeft := 1000
         ELSE
            ::PrintHeader()
         ENDIF
      ENDIF
   ENDIF

   // Sum totals
   FOR nCol := 1 TO Len( ::aReportData[ RP_COLUMNS ] )
      IF ::aReportData[ RP_COLUMNS, nCol, RC_TOTAL ]
         FOR nGroup := 1 TO Len( ::aReportTotals ) - 1
            ::aReportTotals[ nGroup + 1, nCol ] += Eval( ::aReportData[ RP_COLUMNS, nCol, RC_EXP ] )
         NEXT
      ENDIF
   NEXT

   // Reset groups
   FOR nGroup := 1 TO Len( ::aReportData[ RP_GROUPS ] )
      ::aGroupTotals[ nGroup ] := hb_ValToStr( Eval( ::aReportData[ RP_GROUPS, nGroup, RG_EXP ] ), ::aReportData[ RP_GROUPS, nGroup, RG_TYPE ] )
   NEXT

   IF ! ::aReportData[ RP_SUMMARY ]
      // Calculate the lines needed and size the printing array
      nMaxLines := 1
      FOR nCol := 1 TO Len( ::aReportData[ RP_COLUMNS ] )
         IF ::aReportData[ RP_COLUMNS, nCol, RC_TYPE ] $ "CM"
            nMaxLines := MAX( xMLCount( Eval( ::aReportData[ RP_COLUMNS, nCol, RC_EXP ] ), ::aReportData[ RP_COLUMNS, nCol, RC_WIDTH ] ), nMaxLines )
         ENDIF
      NEXT
      ASize( aRecordToPrint, nMaxLines )
      aFill( aRecordToPrint, "" )

      // Load the record in the array to print it
      FOR nCol := 1 TO Len( ::aReportData[ RP_COLUMNS ] )
         FOR nLine := 1 TO nMaxLines
            // Load MEMO and CHARACTER variables
            IF ::aReportData[ RP_COLUMNS, nCol, RC_TYPE ] $ "CM"
               cLine := xMemoLine( RTrim( Eval( ::aReportData[ RP_COLUMNS, nCol, RC_EXP ] ) ), ::aReportData[ RP_COLUMNS, nCol, RC_WIDTH ], nLine )
               cLine := PadR( cLine, ::aReportData[ RP_COLUMNS, nCol, RC_WIDTH ] )
            ELSE
               IF nLine == 1
                  IF ::lNoSeps
                     cLine := Transform( Eval( ::aReportData[ RP_COLUMNS, nCol, RC_EXP ] ), ::aReportData[ RP_COLUMNS, nCol, RC_PICT ] )
                  ELSE
                     cLine := Transform( Eval( ::aReportData[ RP_COLUMNS, nCol, RC_EXP ] ), ConvPic( ::aReportData[ RP_COLUMNS, nCol, RC_PICT ] ) )
                  ENDIF
                  cLine := PadR( cLine, ::aReportData[ RP_COLUMNS, nCol, RC_WIDTH ] )
               ELSE
                  cLine := Space( ::aReportData[ RP_COLUMNS, nCol, RC_WIDTH ] )
               ENDIF
            ENDIF
            IF nCol > 1
               aRecordToPrint[ nLine ] += " "
            ENDIF
            aRecordToPrint[ nLine ] += cLine
         NEXT
      NEXT

      // The record fits in the remaining lines?
      IF Len( aRecordToPrint ) > ::nLinesLeft
         // If the record does not fit in a page, split it.
         IF Len( aRecordToPrint ) > ::nMaxLinesAvail
            nLine := 1
            DO WHILE nLine < Len( aRecordToPrint )
               ::PrintLine( aRecordToPrint[ nLine ], .F. )

               nLine ++
               ::nLinesLeft --
               IF ::nLinesLeft == 0
                  ::EjectPage()
                  IF ::aReportData[ RP_PLAIN ]
                     ::nLinesLeft := 1000
                  ELSE
                     ::PrintHeader()
                  ENDIF
               ENDIF
            ENDDO
         ELSE
            ::EjectPage()
            IF ::aReportData[ RP_PLAIN ]
               ::nLinesLeft := 1000
            ELSE
               ::PrintHeader()
            ENDIF
            AEval( aRecordToPrint, { |RecordLine| ::PrintLine( RecordLine, .F. ) } )

            ::nLinesLeft -= Len( aRecordToPrint )
         ENDIF
      ELSE
         AEval( aRecordToPrint, { |RecordLine| ::PrintLine( RecordLine, .F. ) } )

         ::nLinesLeft -= Len( aRecordToPrint )
      ENDIF

      IF ::nLinesLeft == 0
         ::EjectPage()
         IF ::aReportData[ RP_PLAIN ]
            ::nLinesLeft := 1000
         ELSE
            ::PrintHeader()
         ENDIF
      ENDIF

      // Line spacing
      IF ::aReportData[ RP_SPACING ] > 1
         IF ::nLinesLeft > ::aReportData[ RP_SPACING ] - 1
            FOR nLine := 2 TO ::aReportData[ RP_SPACING ]
               ::PrintLine( "", .F. )
               ::nLinesLeft --
            NEXT
         ENDIF
      ENDIF
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintHeader() CLASS TReportFormWin

   LOCAL nLinesInHeader, aPageHeader := {}
   LOCAL nHeadingLength := ::aReportData[ RP_WIDTH ] - ::aReportData[ RP_LMARGIN ] - 30
   LOCAL nCol, nLine, nMaxColLength, cHeader, nHeadLine, nRPageSize, aTempPgHeader

   nRPageSize := ::aReportData[ RP_WIDTH ] - ::aReportData[ RP_RMARGIN ]

   // Build the header into aPageHeader array
   IF ::aReportData[ RP_HEADING ] == ""
      AAdd( aPageHeader, NationMsg( _RF_PAGENO ) + Str( ::nPageNumber, 6 ) )
   ELSE
      aTempPgHeader := ParseHeader( ::aReportData[ RP_HEADING ], Occurs( ";", ::aReportData[ RP_HEADING ] ) + 1 )

      FOR nLine := 1 TO Len( aTempPgHeader )
         // Compute the amount of lines needed
         nLinesInHeader := Max( xMLCount( LTrim( aTempPgHeader[ nLine ] ), nHeadingLength ), 1 )

         // Add header lines to the array
         FOR nHeadLine := 1 TO nLinesInHeader
            AAdd( aPageHeader, Space( 15 ) + PadC( RTrim( xMemoLine( LTrim( aTempPgHeader[ nLine ] ), nHeadingLength, nHeadLine ) ), nHeadingLength ) )
         NEXT nHeadLine
      NEXT nLine
      aPageHeader[ 1 ] := Stuff( aPageHeader[ 1 ], 1, 14, NationMsg( _RF_PAGENO ) + Str( ::nPageNumber, 6 ) )
   ENDIF
   AAdd( aPageHeader, DToC( Date() ) )

   // Add header
   FOR nLine := 1 TO Len( ::aReportData[ RP_HEADER ] )
      // Compute the amount of lines needed
      nLinesInHeader := MAX( xMLCount( LTrim( ::aReportData[ RP_HEADER, nLine ] ), nRPageSize ), 1 )

      // Add it to the array
      FOR nHeadLine := 1 TO nLinesInHeader
         cHeader := RTrim( xMemoLine( LTrim( ::aReportData[ RP_HEADER, nLine ] ), nRPageSize, nHeadLine ) )
         AAdd( aPageHeader, Space( ( nRPageSize - ::aReportData[ RP_LMARGIN ] - Len( cHeader ) ) / 2 ) + cHeader )
      NEXT nHeadLine

   NEXT nLine

   // Add columns headers
   nLinesInHeader := Len( aPageHeader )

   // Look for the widest header
   nMaxColLength := 0
   FOR nCol := 1 TO Len( ::aReportData[ RP_COLUMNS ] )
      nMaxColLength := Max( Len( ::aReportData[ RP_COLUMNS, nCol, RC_HEADER ] ), nMaxColLength )
   NEXT
   FOR nCol := 1 TO Len( ::aReportData[ RP_COLUMNS ] )
      ASize( ::aReportData[ RP_COLUMNS, nCol, RC_HEADER ], nMaxColLength )
   NEXT

   FOR nLine := 1 TO nMaxColLength
      AAdd( aPageHeader, "" )
   NEXT

   FOR nCol := 1 TO Len( ::aReportData[ RP_COLUMNS ] )
      FOR nLine := 1 TO nMaxColLength
         IF nCol > 1
            aPageHeader[ nLinesInHeader + nLine ] += " "
         ENDIF
         IF ::aReportData[ RP_COLUMNS, nCol, RC_HEADER, nLine ] == NIL
            aPageHeader[ nLinesInHeader + nLine ] += Space( ::aReportData[ RP_COLUMNS, nCol, RC_WIDTH ] )
         ELSE
            IF ::aReportData[ RP_COLUMNS, nCol, RC_TYPE ] == "N"
               aPageHeader[ nLinesInHeader + nLine ] += PadL( ::aReportData[ RP_COLUMNS, nCol, RC_HEADER, nLine ], ;
                                                               ::aReportData[ RP_COLUMNS, nCol, RC_WIDTH ] )
            ELSE
               aPageHeader[ nLinesInHeader + nLine ] += PadR( ::aReportData[ RP_COLUMNS, nCol, RC_HEADER, nLine ], ;
                                                               ::aReportData[ RP_COLUMNS, nCol, RC_WIDTH ] )
            ENDIF
         ENDIF
      NEXT
   NEXT

   // Skip 2 lines
   AAdd( aPageHeader, "" )
   AAdd( aPageHeader, "" )

   // Print header
   AEval( aPageHeader, { |HeaderLine| ::PrintLine( HeaderLine, .T. ) } )

   ::nLinesLeft := ::aReportData[ RP_LINES ] - Len( aPageHeader )
   ::nMaxLinesAvail := ::aReportData[ RP_LINES ] - Len( aPageHeader )
   ::nPageNumber ++

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION Occurs( cSearch, cTarget )

   // How many times <cSearch> appears in <cTarget>

   LOCAL nPos, nCount := 0

   DO WHILE ! Empty( cTarget )
      IF ( nPos := At( cSearch, cTarget ) ) # 0
         nCount ++
         cTarget := SubStr( cTarget, nPos + 1 )
      ELSE
         cTarget := ""
      ENDIF
   ENDDO

   RETURN nCount

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EjectPage() CLASS TReportFormWin

   ::oPrint:EndPage()
   ::oPrint:BeginPage()
   ::nPosRow := _RF_FIRSTROW

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION xMLCount( cString, nLineLength, nTabSize, lWrap )

   ASSIGN nLineLength VALUE nLineLength TYPE "N" DEFAULT 79
   ASSIGN nTabSize    VALUE nTabSize    TYPE "N" DEFAULT 4
   ASSIGN lWrap       VALUE lWrap       TYPE "L" DEFAULT .T.
   IF nTabSize >= nLineLength
      nTabSize := nLineLength - 1
   ENDIF

   RETURN MLCount( RTrim( cString ), nLineLength, nTabSize, lWrap )

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION xMemoLine( cString, nLineLength, nLineNumber, nTabSize, lWrap )

   ASSIGN nLineLength VALUE nLineLength TYPE "N" DEFAULT 79
   ASSIGN nLineNumber VALUE nLineNumber TYPE "N" DEFAULT 1
   ASSIGN nTabSize    VALUE nTabSize    TYPE "N" DEFAULT 4
   ASSIGN lWrap       VALUE lWrap       TYPE "L" DEFAULT .T.
   IF nTabSize >= nLineLength
      nTabSize := nLineLength - 1
   ENDIF

   RETURN MemoLine( cString, nLineLength, nLineNumber, nTabSize, lWrap )

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION ConvPic( sPic )

   // Add thousand separators because standard FRM does not.
   // Note that an overflow may occur it there is not enough space at the column

   LOCAL nPto, nEnt, nDec, sResult
   LOCAL aPics := { "9", "99", "999", "9999", "9,999", "99,999", "999,999", "9999,999", "9,999,999", "99,999,999", "999,999,999", ;
                    "9999,999,999", "9,999,999,999", "99,999,999,999", "999,999,999,999" }

   nPto := At( ".", sPic )
   IF Left( sPic, 1 ) # "9" .OR. nPto == 0
      RETURN sPic
   ENDIF

   nDec := SubStr( sPic, nPto )
   nEnt := Left( sPic, nPto - 1 )

   IF Len( nEnt ) > 15
      sResult := sPic
   ELSE
      sResult := aPics[ Len( nEnt ) ] + nDec
   ENDIF

   RETURN sResult

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintLine( sLin, lBold ) CLASS TReportFormWin

   ASSIGN sLin  VALUE sLin  TYPE "CM" DEFAULT ""
   ASSIGN lBold VALUE lBold TYPE "L"  DEFAULT .F.

   IF ::aReportData[ RP_WIDTH ] <= 80
      ::oPrint:PrintData( ::nPosRow, ::nPosCol + ::aReportData[ RP_LMARGIN ], hb_OEMToANSI( sLin ), NIL, _RF_SIZENORMAL, lBold )
   ELSE
      ::oPrint:PrintData( ::nPosRow, ::nPosCol + ::aReportData[ RP_LMARGIN ], hb_OEMToANSI( sLin ), NIL, _RF_SIZECONDENSED, lBold )
   ENDIF

   ::nPosRow ++
   ::nPosCol := _RF_FIRSTCOL

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD LoadFRM( cFrmFile ) CLASS TReportFormWin

   LOCAL nFieldOffset, cFileBuff := Space( SIZE_FILE_BUFF )
   LOCAL cGroupExp, cSubGroupExp, nColCount, nCount, nFrmHandle, nBytesRead
   LOCAL nPointer, nFileError, cOptionByte, aReport[ RP_COUNT ], oError
   LOCAL cDefPath, aPaths, nPathIndex, aHeader, nHeaderIndex, cParamsBuff
   LOCAL aColumn, cType, cFieldsBuff

   aReport[ RP_HEADER ]  := {}
   aReport[ RP_WIDTH ]   := 80
   aReport[ RP_LMARGIN ] := 8
   aReport[ RP_RMARGIN ] := 0
   aReport[ RP_LINES ]   := 58
   aReport[ RP_SPACING ] := 1
   aReport[ RP_BEJECT ]  := .F.
   aReport[ RP_AEJECT ]  := .F.
   aReport[ RP_PLAIN ]   := .F.
   aReport[ RP_SUMMARY ] := .F.
   aReport[ RP_COLUMNS ] := {}
   aReport[ RP_GROUPS ]  := {}
   aReport[ RP_HEADING ] := ""

   // Open FRM
   nFrmHandle := FOpen( cFrmFile )
   IF ( ! Empty( nFileError := FError() ) ) .AND. ! ( '\' $ cFrmFile .OR. ":" $ cFrmFile )
      cDefPath := SET( _SET_DEFAULT ) + ";" + SET( _SET_PATH )
      cDefPath := StrTran( cDefPath, ",", ";" )
      aPaths   := ListAsArray( cDefPath, ";" )
      // Try to open
      FOR nPathIndex := 1 TO Len( aPaths )
         nFrmHandle := FOpen( aPaths[ nPathIndex ] + '\' + cFrmFile )
         IF Empty( nFileError := FError() )
            EXIT
         ENDIF
      NEXT nPathIndex
   ENDIF
   IF nFileError # F_OK
      oError := ErrorNew()
      oError:severity  := ES_ERROR
      oError:genCode   := EG_OPEN
      oError:subSystem := "FRMLBL"
      oError:osCode    := nFileError
      oError:filename  := cFrmFile
      Eval( ErrorBlock(), oError )
   ENDIF

   // Read FRM
   IF nFileError == F_OK
      FSeek( nFrmHandle, 0 )
      nFileError := FError()
      IF nFileError == F_OK
         nBytesRead := FRead( nFrmHandle, @cFileBuff, SIZE_FILE_BUFF )
         IF nBytesRead == 0
            nFileError := F_EMPTY
         ELSE
            nFileError := FError()
         ENDIF
         IF nFileError == F_OK
            IF Bin2W( SubStr( cFileBuff, 1, 2 ) ) == 2 .AND. Bin2W( SubStr( cFileBuff, SIZE_FILE_BUFF - 1, 2 ) ) == 2
               nFileError := F_OK
            ELSE
               nFileError := F_ERROR
            ENDIF
         ENDIF
      ENDIF
      IF ! FClose( nFrmHandle )
         nFileError := FError()
      ENDIF
   ENDIF

   IF nFileError == F_OK
      // Load FRM
      ::cLengthsBuff := SubStr( cFileBuff, LENGTHS_OFFSET, SIZE_LENGTHS_BUFF )
      ::cOffsetsBuff := SubStr( cFileBuff, OFFSETS_OFFSET, SIZE_OFFSETS_BUFF )
      ::cExprBuff    := SubStr( cFileBuff, EXPR_OFFSET, SIZE_EXPR_BUFF )
      cFieldsBuff    := SubStr( cFileBuff, FIELDS_OFFSET, SIZE_FIELDS_BUFF )
      cParamsBuff    := SubStr( cFileBuff, PARAMS_OFFSET, SIZE_PARAMS_BUFF )

      // Width, lines per page, left and right margin
      aReport[ RP_WIDTH ]   := Bin2W( SubStr( cParamsBuff, PAGE_WIDTH_OFFSET, 2 ) )
      aReport[ RP_LINES ]   := Bin2W( SubStr( cParamsBuff, LNS_PER_PAGE_OFFSET, 2 ) )
      aReport[ RP_LMARGIN ] := Bin2W( SubStr( cParamsBuff, LEFT_MRGN_OFFSET, 2 ) )
      aReport[ RP_RMARGIN ] := Bin2W( SubStr( cParamsBuff, RIGHT_MGRN_OFFSET, 2 ) )

      //Spacing
      aReport[ RP_SPACING ] := iif( SubStr( cParamsBuff, DBL_SPACE_OFFSET, 1 ) $ "YyTt", 2, 1 )

      // Summary
      aReport[ RP_SUMMARY ] := ( SubStr( cParamsBuff, SUMMARY_RPT_OFFSET, 1 ) $ "YyTt" )
      cOptionByte := Asc( SubStr( cParamsBuff, OPTION_OFFSET, 1 ) )

      // Eject
      IF Int( cOptionByte / 2 ) == 1
         aReport[ RP_AEJECT ] := .T.
      ENDIF

      // Headers
      nPointer := Bin2W( SubStr( cParamsBuff, PAGE_HDR_OFFSET, 2 ) )
      nHeaderIndex := 4
      aHeader := ParseHeader( ::GetExpr( nPointer ), nHeaderIndex )
      DO WHILE nHeaderIndex > 0
         IF ! Empty( aHeader[ nHeaderIndex ] )
            EXIT
         ENDIF
         nHeaderIndex --
      ENDDO
      aReport[ RP_HEADER ] := iif( Empty( nHeaderIndex ), {}, ASize( aHeader, nHeaderIndex ) )

      // Groups
      nPointer := Bin2W( SubStr( cParamsBuff, GRP_EXPR_OFFSET, 2 ) )
      IF ! Empty( cGroupExp := ::GetExpr( nPointer ) )
         AAdd( aReport[ RP_GROUPS ], Array( RG_COUNT ) )
         aReport[ RP_GROUPS ][ 1 ][ RG_TEXT ] := cGroupExp
         aReport[ RP_GROUPS ][ 1 ][ RG_EXP ] := &( "{ || " + cGroupExp + "}" )
         IF Used()
            aReport[ RP_GROUPS ][ 1 ][ RG_TYPE ] := ValType( Eval( aReport[ RP_GROUPS ][ 1 ][ RG_EXP ] ) )
         ENDIF
         nPointer := Bin2W( SubStr( cParamsBuff, GRP_HDR_OFFSET, 2 ) )
         aReport[ RP_GROUPS ][ 1 ][ RG_HEADER ] := ::GetExpr( nPointer )
         aReport[ RP_GROUPS ][ 1 ][ RG_AEJECT ] := ( SubStr( cParamsBuff, PE_OFFSET, 1 ) $ "YyTt" )
      ENDIF

      // Subgroups
      nPointer := Bin2W( SubStr( cParamsBuff, SUB_EXPR_OFFSET, 2 ) )
      IF ! Empty( cSubGroupExp := ::GetExpr( nPointer ) )
         AAdd( aReport[ RP_GROUPS ], Array( RG_COUNT ) )
         aReport[ RP_GROUPS ][ 2 ][ RG_TEXT ] := cSubGroupExp
         aReport[ RP_GROUPS ][ 2 ][ RG_EXP ] := &( "{ || " + cSubGroupExp + "}" )
         IF Used()
            aReport[ RP_GROUPS ][ 2 ][ RG_TYPE ] := ValType( Eval( aReport[ RP_GROUPS ][ 2 ][ RG_EXP ] ) )
         ENDIF
         nPointer := Bin2W( SubStr( cParamsBuff, SUB_HDR_OFFSET, 2 ) )
         aReport[ RP_GROUPS ][ 2 ][ RG_HEADER ] := ::GetExpr( nPointer )
         aReport[ RP_GROUPS ][ 2 ][ RG_AEJECT ] := .F.
      ENDIF

      // Columns
      nFieldOffset := 12
      nColCount := Bin2W( SubStr( cParamsBuff, COL_COUNT_OFFSET, 2 ) )
      FOR nCount := 1 TO nColCount
         aColumn := Array( RC_COUNT )
         // Column width
         aColumn[ RC_WIDTH ] := Bin2W( SubStr( cFieldsBuff, nFieldOffset + FIELD_WIDTH_OFFSET, 2 ) )
         // Has total?
         aColumn[ RC_TOTAL ] := ( SubStr( cFieldsBuff, nFieldOffset + FIELD_TOTALS_OFFSET, 1 ) $ "YyTt" )
         // Number of decimals
         aColumn[ RC_DECIMALS ] := Bin2W( SubStr( cFieldsBuff, nFieldOffset + FIELD_DECIMALS_OFFSET, 2 ) )
         // Column content
         nPointer := Bin2W( SubStr( cFieldsBuff, nFieldOffset + FIELD_CONTENT_EXPR_OFFSET, 2 ) )
         aColumn[ RC_TEXT ] := ::GetExpr( nPointer )
         aColumn[ RC_EXP ] := &( "{ || " + ::GetExpr( nPointer ) + "}" )
         // Column header
         nPointer := Bin2W( SubStr( cFieldsBuff, nFieldOffset + FIELD_HEADER_EXPR_OFFSET, 2 ) )
         aColumn[ RC_HEADER ] := ListAsArray( ::GetExpr( nPointer ), ";" )
         // Column picture
         IF Used()
            cType := ValType( Eval( aColumn[ RC_EXP ] ) )
            aColumn[ RC_TYPE ] := cType
            DO CASE
            CASE cType == "C" .OR. cType == "M"
               aColumn[ RC_PICT ] := Replicate( "X", aColumn[ RC_WIDTH ] )
            CASE cType == "D"
               aColumn[ RC_PICT ] := "@D"
            CASE cType == "N"
               IF aColumn[ RC_DECIMALS ] # 0
                  aColumn[ RC_PICT ] := Replicate( "9", aColumn[ RC_WIDTH ] - aColumn[ RC_DECIMALS ] - 1 ) + "." + Replicate( "9", aColumn[ RC_DECIMALS ] )
               ELSE
                  aColumn[ RC_PICT ] := Replicate( "9", aColumn[ RC_WIDTH ] )
               ENDIF
            CASE cType == "L"
               aColumn[ RC_PICT ] := "@L" + Replicate( "X", aColumn[ RC_WIDTH ] - 1 )
            ENDCASE
         ENDIF
         // Add
         AAdd( aReport[ RP_COLUMNS ], aColumn )
         // Next
         nFieldOffset += 12
      NEXT nCount
   ENDIF

   RETURN aReport

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION ParseHeader( cHeaderString, nFields )

   LOCAL cItem, nItemCount := 0, aPageHeader := {}, nHeaderLen := 254, nPos

   DO WHILE ++ nItemCount <= nFields
      cItem := SubStr( cHeaderString, 1, nHeaderLen )
      nPos := At( ";", cItem )
      IF ! Empty( nPos )
         AAdd( aPageHeader, SubStr( cItem, 1, nPos - 1 ) )
      ELSE
         IF Empty( cItem )
            AAdd( aPageHeader, "" )
         ELSE
            AAdd( aPageHeader, cItem )
         ENDIF
         nPos := nHeaderLen
      ENDIF
      cHeaderString := SubStr( cHeaderString, nPos + 1 )
   ENDDO

   RETURN aPageHeader

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GetExpr( nPointer ) CLASS TReportFormWin

   LOCAL nExprOffset, nExprLength, nOffsetOffset := 0, cString := ""

   IF nPointer # 65535
      nPointer ++

      IF nPointer > 1
         nOffsetOffset := ( nPointer * 2 ) - 1
      ENDIF

      nExprOffset := Bin2W( SubStr( ::cOffsetsBuff, nOffsetOffset, 2 ) )
      nExprLength := Bin2W( SubStr( ::cLengthsBuff, nOffsetOffset, 2 ) )

      nExprOffset ++
      nExprLength --

      cString := SubStr( ::cExprBuff, nExprOffset, nExprLength )

      IF Chr( 0 ) == SubStr( cString, 1, 1 ) .AND. Len( SubStr( cString, 1, 1 ) ) == 1
         cString := ""
      ENDIF
   ENDIF

   RETURN cString

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION ListAsArray( cList, cDelimiter )

   // Builds an array from a comma delimited string

   LOCAL nPos, aList := {}, lDelimLast := .F.

   ASSIGN cDelimiter VALUE cDelimiter TYPE "C" DEFAULT ","

   DO WHILE Len( cList ) # 0
      nPos := At( cDelimiter, cList )
      IF nPos == 0
         nPos := Len( cList )
      ENDIF
      IF SubStr( cList, nPos, 1 ) == cDelimiter
         lDelimLast := .T.
         AAdd( aList, SubStr( cList, 1, nPos - 1 ) )
      ELSE
         lDelimLast := .F.
         AAdd( aList, SubStr( cList, 1, nPos ) )
      ENDIF
      cList := SubStr( cList, nPos + 1 )
   ENDDO

   IF lDelimLast
      AAdd( aList, "" )
   ENDIF

   RETURN aList
