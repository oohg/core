/*
 * $Id: h_print.prg $
 */
/*
 * ooHG source code:
 * TPrint object
 *
 * Copyright 2006-2018 Vicente Guerra <vicente@guerra.com.mx>
 * https://oohg.github.io/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2018, https://harbour.github.io/
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
 * Boston, MA 02110-1335,USA (or download from http://www.gnu.org/licenses/).
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


#include 'hbclass.ch'
#include 'oohg.ch'
#include 'miniprint.ch'
#define NO_HBPRN_DECLARATION
#include 'winprint.ch'
#include "fileio.ch"

MEMVAR _OOHG_PrintLibrary
MEMVAR _OOHG_PRINTER_DocName
MEMVAR _HMG_PRINTER_aPrinterProperties
MEMVAR _HMG_PRINTER_Collate
MEMVAR _HMG_PRINTER_Copies
MEMVAR _HMG_PRINTER_Error
MEMVAR _HMG_PRINTER_hDC
MEMVAR _HMG_PRINTER_hDC_Bak
MEMVAR _HMG_PRINTER_Name
MEMVAR _HMG_PRINTER_PageCount
MEMVAR _HMG_PRINTER_Preview
MEMVAR _HMG_PRINTER_TimeStamp

#define hbprn ::oHBPrn
#define TEMP_FILE_NAME ( GetTempDir() + "T" + AllTrim( Str( Int( hb_Random( 999999 ) ), 8 ) ) + ".prn" )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION TPrint( cLibX )

   LOCAL o_Print_

   IF cLibX == NIL
      IF Type("_OOHG_PrintLibrary") == "C"
         IF _OOHG_PrintLibrary == "HBPRINTER"
            o_Print_ := thbprinter()
         ELSEIF _OOHG_PrintLibrary == "MINIPRINT"
            o_Print_ := tminiprint()
         ELSEIF _OOHG_PrintLibrary == "DOSPRINT"
            o_Print_ := tdosprint()
         ELSEIF _OOHG_PrintLibrary == "TXTPRINT"
            o_Print_ := ttxtprint()
         ELSEIF _OOHG_PrintLibrary == "EXCELPRINT"
            o_Print_ := texcelprint()
         ELSEIF _OOHG_PrintLibrary == "CALCPRINT"
            o_Print_ := tcalcprint()
         ELSEIF _OOHG_PrintLibrary == "RTFPRINT"
            o_Print_ := trtfprint()
         ELSEIF _OOHG_PrintLibrary == "CSVPRINT"
            o_Print_ := tcsvprint()
         ELSEIF _OOHG_PrintLibrary == "HTMLPRINT"
            o_Print_ := thtmlprint()
         ELSEIF _OOHG_PrintLibrary == "HTMLPRINTFROMCALC"
            o_Print_ := thtmlprintfromcalc()
         ELSEIF _OOHG_PrintLibrary == "HTMLPRINTFROMEXCEL"
            o_Print_ := thtmlprintfromexcel()
         ELSEIF _OOHG_PrintLibrary == "PDFPRINT"
            o_Print_ := tpdfprint()
         ELSEIF _OOHG_PrintLibrary == "RAWPRINT"
            o_Print_ := trawprint()
         ELSEIF _OOHG_PrintLibrary == "SPREADSHEETPRINT"
            o_Print_ := tspreadsheetprint()

         ELSE
            o_Print_ := thbprinter()
         ENDIF
      ELSE
         o_Print_ := tminiprint()
         _OOHG_PrintLibrary := "MINIPRINT"
      ENDIF
   ELSE
      IF ValType( cLibX ) == "C"
         IF cLibX == "HBPRINTER"
            o_Print_ := thbprinter()
         ELSEIF cLibX == "MINIPRINT"
            o_Print_ := tminiprint()
         ELSEIF cLibX == "DOSPRINT"
            o_Print_ := tdosprint()
         ELSEIF cLibX == "TXTPRINT"
            o_Print_ := ttxtprint()
         ELSEIF cLibX == "EXCELPRINT"
            o_Print_ := texcelprint()
         ELSEIF cLibX == "CALCPRINT"
            o_Print_ := tcalcprint()
         ELSEIF cLibX == "RTFPRINT"
            o_Print_ := trtfprint()
         ELSEIF cLibX == "CSVPRINT"
            o_Print_ := tcsvprint()
         ELSEIF cLibX == "HTMLPRINT"
            o_Print_ := thtmlprint()
         ELSEIF cLibX == "HTMLPRINTFROMCALC"
            o_Print_ := thtmlprintfromcalc()
         ELSEIF cLibX == "HTMLPRINTFROMEXCEL"
            o_Print_ := thtmlprintfromexcel()
         ELSEIF cLibX == "PDFPRINT"
            o_Print_ := tpdfprint()
         ELSEIF cLibX == "RAWPRINT"
            o_Print_ := trawprint()
         ELSEIF cLibX == "SPREADSHEETPRINT"
            o_Print_ := tspreadsheetprint()

         ELSE
            o_Print_ := tminiprint()
         ENDIF
      ELSE
         o_Print_ := tminiprint()
         _OOHG_PrintLibrary := "MINIPRINT"
      ENDIF
   ENDIF

   RETURN o_Print_

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TPRINTBASE

   DATA aBarColor                 INIT {1, 1, 1}             READONLY    // brush color for barcodes
   DATA aColor                    INIT {0, 0, 0}             READONLY    // brush color
   DATA aFontColor                INIT {0, 0, 0}             READONLY    // font color
   DATA aLinCelda                 INIT {}                    READONLY
   DATA aPageNames                INIT {}                    READONLY
   DATA aPorts                    INIT {}                    READONLY
   DATA aPrinters                 INIT {}                    READONLY
   DATA Cargo                     INIT "list"                READONLY    // document's name without extension
   DATA cDocument                 INIT ""                    READONLY    // document's name with extension
   DATA cFontName                 INIT "Courier New"         READONLY
   DATA cPageName                 INIT ""                    READONLY    // current page name
   DATA cPort                     INIT "PRN"                 READONLY
   DATA cPrinter                  INIT ""                    READONLY
   DATA cPrintLibrary             INIT "HBPRINTER"           READONLY
   DATA cTempFile                 INIT TEMP_FILE_NAME        READONLY
   DATA cUnits                    INIT "ROWCOL"              READONLY
   DATA cVersion                  INIT "(oohg-tprint)V 4.20" READONLY
   DATA Exit                      INIT .F.                   READONLY
   DATA ImPreview                 INIT .T.                   READONLY
   DATA lFontBold                 INIT .F.                   READONLY
   DATA lFontItalic               INIT .F.                   READONLY
   DATA lFontStrikeout            INIT .F.                   READONLY
   DATA lFontUnderline            INIT .F.                   READONLY
   DATA lIndentAll                INIT .F.                   READONLY    // Indent RicheEdit lines
   DATA lLandscape                INIT .F.                   READONLY    // Page orientation
   DATA lPrError                  INIT .F.                   READONLY
   DATA lProp                     INIT .F.                   READONLY
   DATA lSaveTemp                 INIT .F.                   READONLY
   DATA lSeparateSheets           INIT .F.                   READONLY
   DATA lShowErrors               INIT .T.                   READONLY
   DATA lWinHide                  INIT .F.                   READONLY
   DATA nFontAngle                INIT 0                     READONLY
   DATA nFontSize                 INIT 12                    READONLY
   DATA nFontType                 INIT 1                     READONLY // font type (normal=0 or bold=1)
   DATA nFontWidth                INIT 0                     READONLY
   DATA nhFij                     INIT ( 12 / 3.70 )         READONLY
   DATA nLinPag                   INIT 0                     READONLY
   DATA nLMargin                  INIT 0                     READONLY
   DATA nMaxCol                   INIT 0                     READONLY
   DATA nMaxRow                   INIT 0                     READONLY
   DATA nmHor                     INIT ( 10 / 4.75 )         READONLY
   DATA nmVer                     INIT ( 10 / 2.35 )         READONLY
   DATA nTMargin                  INIT 0                     READONLY
   DATA nUnitsLin                 INIT 1                     READONLY
   DATA nvFij                     INIT ( 12 / 1.65 )         READONLY
   DATA nwPen                     INIT 0.1                   READONLY    // pen width in MM, do not exceed 1

   METHOD BeginDoc
   METHOD BeginDocX               BLOCK { || NIL }
   METHOD BeginPage
   METHOD BeginPageX              BLOCK { || NIL }
   METHOD Codabar
   METHOD Code128
   METHOD Code3_9
   METHOD CondenDos               BLOCK { || NIL }
   METHOD CondenDosX              BLOCK { || NIL }
   METHOD Ean13
   METHOD Ean8
   METHOD EndDoc
   METHOD EndDocX                 BLOCK { || NIL }
   METHOD EndPage
   METHOD EndPageX                BLOCK { || NIL }
   METHOD GetDefPrinter
   METHOD GetDefPrinterX          BLOCK { || NIL }
   METHOD Go_Code
   METHOD Ind25
   METHOD Init
   METHOD InitX                   BLOCK { || NIL }
   METHOD Int25
   METHOD Mat25
   METHOD MaxCol                  INLINE ::nMaxCol
   METHOD MaxRow                  INLINE ::nMaxRow
   METHOD NormalDos               BLOCK { || NIL }
   METHOD NormalDosX              BLOCK { || NIL }
   METHOD PrintBarcode
   METHOD PrintBarcodeX           BLOCK { || NIL }
   METHOD PrintData
   METHOD PrintDataX              BLOCK { || NIL }
   METHOD PrintImage
   METHOD PrintImageX             BLOCK { || NIL }
   METHOD PrintLine
   METHOD PrintLineX              BLOCK { || NIL }
   METHOD PrintMode
   METHOD PrintModeX              BLOCK { || NIL }
   METHOD PrintRectangle
   METHOD PrintRectangleX         BLOCK { || NIL }
   METHOD PrintRoundRectangle
   METHOD PrintRoundRectangleX    BLOCK { || NIL }
   METHOD Release
   METHOD ReleaseX                BLOCK { || NIL }
   METHOD SelPrinter
   METHOD SelPrinterX             BLOCK { || NIL }
   METHOD SetBarColor
   METHOD SetColor
   METHOD SetColorX               BLOCK { || NIL }
   METHOD SetCpl
   METHOD SetDosPort
   METHOD SetFont
   METHOD SetFontType
   METHOD SetFontX                BLOCK { || NIL }
   METHOD SetIndentation
   METHOD SetLMargin
   METHOD SetPreviewSize
   METHOD SetPreviewSizeX         BLOCK { || NIL }
   METHOD SetProp
   METHOD SetRawPrinter
   METHOD SetSeparateSheets
   METHOD SetShowErrors
   METHOD SetTMargin
   METHOD SetUnits
   METHOD Sup5
   METHOD Upca
   METHOD Version                INLINE ::cVersion

   MESSAGE PrintDos              METHOD PrintMode
   MESSAGE PrintRaw              METHOD PrintMode

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetIndentation( lIndentAll ) CLASS TPRINTBASE

   IF HB_ISLOGICAL( lIndentAll )
      ::lIndentAll := lIndentAll
   ELSE
      ::lIndentAll := .F.
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetFontType( nFontType ) CLASS TPRINTBASE

   IF ! HB_ISNUMERIC( nFontType )
      ::nFontType := 0
   ELSEIF nFontType == 0
      ::nFontType := 0
   ELSEIF nFontType == 1
      ::nFontType := 1
   ELSE
      ::nFontType := 0
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetSeparateSheets( lSeparateSheets ) CLASS TPRINTBASE

   IF HB_ISLOGICAL( lSeparateSheets )
      ::lSeparateSheets := lSeparateSheets
   ELSE
      ::lSeparateSheets := .F.
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetShowErrors( lShow ) CLASS TPRINTBASE

   DEFAULT lShow TO .T.
   ::lShowErrors := lShow

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetPreviewSize( nSize ) CLASS TPRINTBASE

   RETURN ::SetPreviewSizeX( nSize )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetProp( lMode ) CLASS TPRINTBASE

   DEFAULT lMode TO .F.
   ::lProp := lMode

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetCpl( nCpl ) CLASS TPRINTBASE

   DEFAULT nCpl TO 80
   DO CASE
   CASE nCpl == 60
      ::nFontSize := 14
   CASE nCpl == 80
      ::nFontSize := 12
   CASE nCpl == 96
      ::nFontSize := 10
   CASE nCpl == 120
      ::nFontSize := 8
   CASE nCpl == 140
      ::nFontSize := 7
   CASE nCpl == 160
      ::nFontSize := 6
   OTHERWISE
      ::nFontSize := 12
   ENDCASE

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Release() CLASS TPRINTBASE

   IF ::Exit
      RETURN NIL
   ENDIF
   ::ReleaseX()

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Init() CLASS TPRINTBASE

   IF IsWindowActive( _modalhide )
      IF ::lShowErrors
         MsgStop( _OOHG_Messages( 12, 1 ), _OOHG_Messages( 12, 12 ) )
      ENDIF
      ::lPrError := .T.
      ::Exit := .T.
      RETURN NIL
   ENDIF
   ::InitX()

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SelPrinter( lSelect, lPreview, lLandscape, nPaperSize, cPrinterX, lHide, nRes, nBin, nDuplex, lCollate, nCopies, lColor, nScale, nPaperLength, nPaperWidth ) CLASS TPRINTBASE

   IF ::Exit
      ::lPrError := .T.
      RETURN NIL
   ENDIF

   DEFAULT lSelect    TO .T.
   DEFAULT lPreview   TO .T.
   DEFAULT lLandscape TO .F.
   DEFAULT lHide      TO .F.

   ::ImPreview := lPreview
   ::lLandscape := lLandscape
   ::lWinHide := lHide

   ::SelPrinterX( lSelect, lPreview, lLandscape, nPaperSize, cPrinterX, nRes, nBin, nDuplex, lCollate, nCopies, lColor, nScale, nPaperLength, nPaperWidth )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginDoc( cDocm ) CLASS TPRINTBASE

   LOCAL oLabel, oImage, cTitle

   cTitle := _OOHG_Messages( 12, 2 )

   IF HB_ISSTRING( cDocm ) .AND. ! Empty( cDocm )
      ::Cargo := cDocm
   ENDIF

   SetPRC( 0, 0 )

   // See ::Init()
   DEFINE WINDOW _modalhide ;
      AT 0,0 ;
      WIDTH 0 HEIGHT 0 ;
      TITLE cTitle MODAL NOSHOW NOSIZE NOSYSMENU NOCAPTION
   END WINDOW
   ACTIVATE WINDOW _modalhide NOWAIT

   IF ! IsWindowDefined( _oohg_winreport )
      DEFINE WINDOW _oohg_winreport ;
         AT 0,0 ;
         WIDTH 400 HEIGHT 120 ;
         TITLE cTitle CHILD NOSIZE NOSYSMENU NOCAPTION

         @ 5, 5 FRAME myframe WIDTH 390 HEIGHT 110

         @ 15, 195 IMAGE image_101 OBJ oImage ;
            PICTURE 'hbprint_print' ;
            WIDTH 25 ;
            HEIGHT 30 ;
            STRETCH ;
            NODIBSECTION

         @ 22, 225 LABEL label_101 VALUE '......' FONT "Courier New" SIZE 10

         @ 55, 10 LABEL label_1 OBJ oLabel VALUE cTitle WIDTH 300 HEIGHT 32 FONT "Courier New"

         DEFINE TIMER timer_101 ;
            INTERVAL 1000 ;
            ACTION Action_Timer( oLabel, oImage )
      END WINDOW
   ENDIF

   IF ! ::lWinHide
      _oohg_winreport.Hide()
   ENDIF

   CENTER WINDOW _oohg_winreport
   ACTIVATE WINDOW _oohg_winreport NOWAIT

   ::BeginDocX()

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetLMargin( nLMar ) CLASS TPRINTBASE

   DEFAULT nLMar TO 0
   ::nLMargin := nLMar

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetTMargin( nTMar ) CLASS TPRINTBASE

   DEFAULT nTMar TO 0
   ::nTMargin := nTMar

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION Action_Timer( oLabel, oImage )

   IF IsWindowDefined( _oohg_winreport )
      oLabel:FontBold := ! oLabel:FontBold
      oImage:Visible :=  oLabel:FontBold
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndDoc( lSaveTemp ) CLASS TPRINTBASE

   DEFAULT lSaveTemp TO .F.
   ::lSaveTemp := lSaveTemp

   ::EndDocX()
   IF IsWindowDefined( _oohg_winreport )
      _oohg_winreport.Release()
   ENDIF
   _modalhide.Release()
   ::aPageNames := {}

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetColor( atColor ) CLASS TPRINTBASE

   DEFAULT atColor TO {0, 0, 0}
   ::aColor := atColor
   ::SetColorX()

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetBarColor( atColor ) CLASS TPRINTBASE

   DEFAULT atColor TO {1, 1, 1}
   ::aBarColor := atColor

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetFont( cFont, nSize, aColor, lBold, lItalic, nAngle, lUnder, lStrike, nWidth ) CLASS TPRINTBASE

   DEFAULT cFont   TO ::cFontName
   DEFAULT nSize   TO ::nFontSize
   DEFAULT aColor  TO ::aFontColor
   DEFAULT lBold   TO ::lFontBold
   DEFAULT lItalic TO ::lFontItalic
   DEFAULT nAngle  TO ::nFontAngle
   DEFAULT lUnder  TO ::lFontUnderline
   DEFAULT lStrike TO ::lFontStrikeout
   DEFAULT nWidth  TO ::nFontWidth

   ::cFontName      := cFont
   ::nFontSize      := nSize
   ::aFontColor     := aColor
   ::lFontBold      := lBold
   ::lFontItalic    := lItalic
   ::nFontAngle     := nAngle
   ::lFontUnderline := lUnder
   ::lFontStrikeout := lStrike
   ::nFontWidth     := nWidth

   ::SetFontX()

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginPage( cName ) CLASS TPRINTBASE

   IF ! Empty( cName )
      IF AScan( ::aPageNames, cName ) > 0
         cName := ""
      ENDIF
   ENDIF
   IF Empty( cName )
      cName := "Page_" + LTrim( Str( Len( ::aPageNames ) + 1 ) )
   ENDIF
   ::cPageName := cName
   AAdd( ::aPageNames, ::cPageName )
   ::BeginPageX()

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndPage() CLASS TPRINTBASE

   ::EndPageX()
   ::cPageName := ""

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GetDefPrinter() CLASS TPRINTBASE

   RETURN ::GetDefPrinterX()

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetUnits( cUnitsX, nUnitsLinX ) CLASS TPRINTBASE

   DEFAULT cUnitsX TO "ROWCOL"
   cUnitsX := Upper( cUnitsX )
   IF cUnitsX == "MM"
      ::cUnits := "MM"
   ELSE
      ::cUnits := "ROWCOL"
   ENDIF
   DEFAULT nUnitsLinX TO 1
   ::nUnitsLin := nUnitsLinX

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintData( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, lItalic, nAngle, lUnder, lStrike, nWidth ) CLASS TPRINTBASE

   LOCAL cText, cSpace, uAux, cType

   DEFAULT nLin    TO 1
   DEFAULT nCol    TO 1
   DEFAULT cFont   TO ::cFontName
   DEFAULT nSize   TO ::nFontSize
   DEFAULT lBold   TO ::lFontBold
   DEFAULT aColor  TO ::aFontColor
   DEFAULT cAlign  TO "L"
   DEFAULT nLen    TO 15
   DEFAULT lItalic TO ::lFontItalic
   DEFAULT nAngle  TO ::nFontAngle
   DEFAULT lUnder  TO ::lFontUnderline
   DEFAULT lStrike TO ::lFontStrikeout
   DEFAULT nWidth  TO ::nFontWidth

   cType := ValType( uData )
   DO WHILE cType == "B"
      uAux := Eval( uData )
      cType := ValType( uAux )
      uData := uAux
   ENDDO
   DO CASE
   CASE cType == 'C'
      cText := uData
   CASE cType == 'N'
      cText := AllTrim( Str( uData ) )
   CASE cType == 'D'
      cText := DToC( uData )
   CASE cType == 'L'
      cText := iif( uData, 'T', 'F' )
   /*
      TODO: use setted language
   */
   CASE cType == 'M'
      cText := uData
   CASE cType == 'T'
      cText := TToC( uData )
   CASE cType == 'O'
      cText := "< Object >"
   CASE cType == 'A'
      cText := "< Array >"
   OTHERWISE
      cText := ""
   ENDCASE

   IF ::cUnits == "MM"
      ::nmVer := 1
      ::nvFij := 0
      ::nmHor := 1
      ::nhFij := 0
   ELSE
      ::nmHor := ( nSize / 4.75 )
      IF ::lProp
         ::nmVer := ( ::nFontSize / 2.35 )
      ELSE
         ::nmVer := ( 10 / 2.35 )
      ENDIF
      ::nvFij := ( 12 / 1.65 )
      ::nhFij := ( 12 / 3.70 )
   ENDIF

   IF ! ::cUnits == "MM"
      DO CASE
      CASE cAlign == "C"
         cSpace := Space( ( Int( nLen ) - Len( cText ) ) / 2 )
      CASE cAlign == "R"
         cSpace := Space( Int( nLen ) - Len( cText ) )
      OTHERWISE
         cSpace := ""
      ENDCASE

      cText := cSpace + cText
   ENDIF

   ::PrintDataX( ::nTMargin + nLin, ::nLMargin + nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, cText, lItalic, nAngle, lUnder, lStrike, nWidth )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintBarcode( nLin, nCol, cBarcode, cType, aColor, lHori, nWidth, nHeight ) CLASS TPRINTBASE

   LOCAL nSize := 10

   DEFAULT nHeight  TO 10
   DEFAULT nWidth   TO NIL
   DEFAULT cBarcode TO ""
   DEFAULT lHori    TO .T.
   DEFAULT aColor   TO ::aBarColor
   DEFAULT cType    TO "CODE128C"
   DEFAULT nLin     TO 1
   DEFAULT nCol     TO 1

   cBarcode := Upper( cBarcode )

   IF ::cUnits == "MM"
      ::nmVer := 1
      ::nvFij := 0
      ::nmHor := 1
      ::nhFij := 0
   ELSE
      ::nmHor := ( nSize / 4.75 )
      IF ::lProp
         ::nmVer := ( ::nFontSize / 2.35 )
      ELSE
         ::nmVer := ( 10 / 2.35 )
      ENDIF
      ::nvFij := ( 12 / 1.65 )
      ::nhFij := ( 12 / 3.70 )
    ENDIF

   DO CASE
   CASE cType == "CODE128A"
      ::Code128( nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2, cBarcode, "A", aColor, lHori, nWidth, nHeight )
   CASE cType == "CODE128B"
      ::Code128( nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2, cBarcode, "B", aColor, lHori, nWidth, nHeight )
   CASE cType == "CODE128C"
      ::Code128( nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2, cBarcode, "C", aColor, lHori, nWidth, nHeight )
   CASE cType == "CODE39"
      ::Code3_9( nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2, cBarcode, aColor, lHori, nWidth, nHeight )
   CASE cType == "EAN8"
      ::Ean8( nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2, cBarcode, aColor, lHori, nWidth, nHeight )
   CASE cType == "EAN13"
      ::Ean13( nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2, cBarcode, aColor, lHori, nWidth, nHeight )
   CASE cType == "INTER25"
      ::Int25( nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2, cBarcode, aColor, lHori, nWidth, nHeight )
   CASE cType == "UPCA"
      ::Upca( nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2, cBarcode, aColor, lHori, nWidth, nHeight )
   CASE cType == "SUP5"
      ::Sup5( nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2, cBarcode, aColor, lHori, nWidth, nHeight )
   CASE cType == "CODABAR"
      ::Codabar( nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2, cBarcode, aColor, lHori, nWidth, nHeight )
   CASE cType == "IND25"
      ::Ind25( nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2, cBarcode, aColor, lHori, nWidth, nHeight )
   CASE cType == "MAT25"
      ::Mat25( nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2, cBarcode, aColor, lHori, nWidth, nHeight )
   ENDCASE

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Ean8( nRow, nCol, cCode, aColor, lHorz, nWidth, nHeigth ) CLASS TPRINTBASE

   LOCAL nLen := 0

   DEFAULT nHeigth TO 1.5
   IF lHorz
      ::Go_Code( _Upc( cCode, 7 ), nRow, nCol, lHorz, aColor, nWidth, nHeigth * 0.90 )
   ELSE
      ::Go_Code( _Upc( cCode, 7 ), nRow, nCol + nLen, lHorz, aColor, nWidth, nHeigth * 0.90 )
   ENDIF
   ::Go_Code( _Ean13bl( 8 ), nRow, nCol, lHorz, aColor, nWidth, nHeigth )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Ean13( nRow, nCol, cCode, aColor, lHorz, nWidth, nHeigth ) CLASS TPRINTBASE

   LOCAL nLen := 0

   DEFAULT nHeigth TO 1.5
   IF lHorz
      ::Go_Code( _Ean13( cCode, ::lShowErrors ), nRow, nCol, lHorz, aColor, nWidth, nHeigth * 0.90 )
   ELSE
      ::Go_Code( _Ean13( cCode, ::lShowErrors ), nRow, nCol + nLen, lHorz, aColor, nWidth, nHeigth * 0.90 )
   ENDIF
   ::Go_Code( _Ean13bl( 12 ), nRow, nCol, lHorz, aColor, nWidth, nHeigth )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Code128( nRow, nCol, cCode, cMode, aColor, lHorz, nWidth, nHeigth ) CLASS TPRINTBASE

   ::Go_Code( _Code128( cCode, cMode, ::lShowErrors ), nRow, nCol, lHorz, aColor, nWidth, nHeigth )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Code3_9( nRow, nCol, cCode, aColor, lHorz, nWidth, nHeigth ) CLASS TPRINTBASE

   LOCAL lCheck := .T.

   ::Go_Code( _Code3_9( cCode, lCheck, ::lShowErrors ), nRow, nCol, lHorz, aColor, nWidth, nHeigth )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Int25( nRow, nCol, cCode, aColor, lHorz, nWidth, nHeigth ) CLASS TPRINTBASE

   LOCAL lCheck := .T.

   ::Go_Code( _Int25( cCode, lCheck, ::lShowErrors ), nRow, nCol, lHorz, aColor, nWidth, nHeigth )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Upca( nRow, nCol, cCode, aColor, lHorz, nWidth, nHeigth ) CLASS TPRINTBASE

   LOCAL nLen := 0

   DEFAULT nHeigth TO 1.5
   IF lHorz
      ::Go_Code( _Upc( cCode ), nRow, nCol, lHorz, aColor, nWidth, nHeigth * 0.90 )
   ELSE
      ::Go_Code( _Upc( cCode ), nRow, nCol + nLen, lHorz, aColor, nWidth, nHeigth * 0.90 )
   ENDIF
   ::Go_Code( _Upcabl( cCode ), nRow, nCol, lHorz, aColor, nWidth, nHeigth )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Sup5( nRow, nCol, cCode, aColor, lHorz, nWidth, nHeigth ) CLASS TPRINTBASE

   ::Go_Code( _Sup5( cCode, ::lShowErrors ), nRow, nCol, lHorz, aColor, nWidth, nHeigth )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Codabar( nRow, nCol, cCode, aColor, lHorz, nWidth, nHeigth ) CLASS TPRINTBASE

   ::Go_Code( _Codabar( cCode, ::lShowErrors ), nRow, nCol, lHorz, aColor, nWidth, nHeigth )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Ind25( nRow, nCol, cCode, aColor, lHorz, nWidth, nHeigth ) CLASS TPRINTBASE

   LOCAL lCheck := .T.

   ::Go_Code( _Ind25( cCode, lCheck, ::lShowErrors ), nRow, nCol, lHorz, aColor, nWidth, nHeigth )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Mat25( nRow, nCol, cCode, aColor, lHorz, nWidth, nHeigth ) CLASS TPRINTBASE

   LOCAL lCheck := .T.

   ::Go_Code( _Mat25( cCode, lCheck, ::lShowErrors ), nRow, nCol, lHorz, aColor, nWidth, nHeigth )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Go_Code( cBarcode, ny, nx, lHorz, aColor, nWidth, nLen ) CLASS TPRINTBASE

   LOCAL n

   DEFAULT ny     TO 0
   DEFAULT nx     TO 0
   DEFAULT aColor TO { 0, 0, 0 }
   DEFAULT lHorz  TO .T.
   DEFAULT nWidth TO 0.495           // 1/3 M/mm 0.25 width
   DEFAULT nLen   TO 15             // mm height

   FOR n := 1 TO Len( cBarcode )
      IF SubStr( cBarcode, n, 1 ) == '1'
         IF lHorz
            ::PrintBarcodeX( ny, nx, ny + nLen, nx + nWidth, aColor )
            nx += nWidth
         ELSE
            ::PrintBarcodeX( ny, nx, ny + nWidth, nx + nLen, aColor )
            ny += nWidth
         ENDIF
      ELSE
         IF lHorz
            nx += nWidth
         ELSE
            ny += nWidth
         ENDIF
      ENDIF
   NEXT n

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintImage( nLin, nCol, nLinF, nColF, cImage, aResol, aSize ) CLASS TPRINTBASE

   DEFAULT nLin   TO 1
   DEFAULT nCol   TO 1
   DEFAULT cImage TO ""
   DEFAULT nLinF  TO 4
   DEFAULT nColF  TO 4

   IF ::cUnits == "MM"
      ::nmVer := 1
      ::nvFij := 0
      ::nmHor := 1
      ::nhFij := 0
   ELSE
      ::nmHor := ( ::nFontSize / 4.75 )
      IF ::lProp
         ::nmVer := ( ::nFontSize / 2.35 )
      ELSE
         ::nmVer := ( 10 / 2.35 )
      ENDIF
      ::nvFij := ( 12 / 1.65 )
      ::nhFij := ( 12 / 3.70 )
   ENDIF

   ::PrintImageX( ::nTMargin + nLin, ::nLMargin + nCol, ::nTMargin + nLinF, ::nLMargin + nColF, cImage, aResol, aSize )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintLine( nLin, nCol, nLinF, nColF, atColor, ntwPen, lSolid ) CLASS TPRINTBASE

   DEFAULT nLin    TO 1
   DEFAULT nCol    TO 1
   DEFAULT nLinF   TO 4
   DEFAULT nColF   TO 4
   DEFAULT atColor TO ::aColor
   DEFAULT ntwPen  TO ::nwPen
   DEFAULT lSolid  TO .T.

   IF ::cUnits == "MM"
      ::nmVer := 1
      ::nvFij := 0
      ::nmHor := 1
      ::nhFij := 0
   ELSE
      ::nmHor := ( ::nFontSize / 4.75 )
      IF ::lProp
         ::nmVer := ( ::nFontSize / 2.35 )
      ELSE
         ::nmVer := ( 10 / 2.35 )
      ENDIF
      ::nvFij := ( 12 / 1.65 )
      ::nhFij := ( 12 / 3.70 )
   ENDIF

   ::PrintLineX( ::nTMargin + nLin, ::nLMargin + nCol, ::nTMargin + nLinF, ::nLMargin + nColF, atColor, ntwPen, lSolid )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintRectangle( nLin, nCol, nLinF, nColF, atColor, ntwPen, lSolid, arColor ) CLASS TPRINTBASE

   DEFAULT nLin    TO 1
   DEFAULT nCol    TO 1
   DEFAULT nLinF   TO 4
   DEFAULT nColF   TO 4
   DEFAULT atColor TO ::aColor
   DEFAULT ntwPen  TO ::nwPen
   DEFAULT lSolid  TO .T.
   DEFAULT arColor TO {255, 255, 255}

   IF ::cUnits == "MM"
      ::nmVer := 1
      ::nvFij := 0
      ::nmHor := 1
      ::nhFij := 0
   ELSE
      ::nmHor := ( ::nFontSize / 4.75 )
      IF ::lProp
         ::nmVer := ( ::nFontSize / 2.35 )
      ELSE
         ::nmVer := ( 10 / 2.35 )
      ENDIF
      ::nvFij := ( 12 / 1.65 )
      ::nhFij := ( 12 / 3.70 )
   ENDIF

   ::PrintRectangleX( ::nTMargin + nLin, ::nLMargin + nCol, ::nTMargin + nLinF, ::nLMargin + nColF, atColor, ntwPen, lSolid, arColor  )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintRoundRectangle( nLin, nCol, nLinF, nColF, atColor, ntwPen, lSolid, arColor ) CLASS TPRINTBASE

   DEFAULT nLin    TO 1
   DEFAULT nCol    TO 1
   DEFAULT nLinF   TO 4
   DEFAULT nColF   TO 4
   DEFAULT atColor TO ::aColor
   DEFAULT ntwPen  TO ::nwPen
   DEFAULT lSolid  TO .T.
   DEFAULT arColor TO {255, 255, 255}

   IF ::cUnits == "MM"
      ::nmVer := 1
      ::nvFij := 0
      ::nmHor := 1
      ::nhFij := 0
   ELSE
      ::nmHor := ( ::nFontSize / 4.75 )
      IF ::lProp
         ::nmVer := ( ::nFontSize / 2.35 )
      ELSE
         ::nmVer := ( 10 / 2.35 )
      ENDIF
      ::nvFij := ( 12 / 1.65 )
      ::nhFij := ( 12 / 3.70 )
   ENDIF

   ::PrintRoundRectangleX( ::nTMargin + nLin, ::nLMargin + nCol, ::nTMargin + nLinF, ::nLMargin + nColF, atColor, ntwPen, lSolid, arColor  )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintMode( cFile ) CLASS TPRINTBASE

   ::PrintModeX( cFile )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetDosPort( cPort ) CLASS TPRINTBASE

   LOCAL nPos, cAux, lFound, i

   DO CASE
   CASE ! HB_ISSTRING( cPort )
      ::cPort := "PRN"
   CASE Empty( cPort )
      ::cPort := "PRN"
   CASE cPort $ "PRN LPT1: LPT2: LPT3: LPT4: LPT5: LPT6:"
      ::cPort := cPort
   OTHERWISE
      ::aPorts := ASort( aLocalPorts() )
      lFound := .F.

      FOR i := 1 TO Len( ::aPorts )
         cAux := ::aPorts[i]
         IF ( nPos := At( ",", cAux ) ) > 0
            cAux := Left( cAux, nPos -  1 )
         ENDIF
         IF cPort == cAux
            lFound := .T.
            EXIT
         ENDIF
      NEXT i

      IF lFound
         ::cPort := cPort
      ELSE
         ::cPort := "PRN"
      ENDIF
   ENDCASE

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetRawPrinter( cPrinter ) CLASS TPRINTBASE

   DO CASE
   CASE ! HB_ISSTRING( cPrinter )
      ::cPrinter := ""
   CASE Empty( cPrinter )
      ::cPrinter := GetDefaultPrinter()
   OTHERWISE
      ::aPrinters := ASort( aPrinters() )
      IF AScan( ::aPrinters, cPrinter ) > 0
         ::cPrinter := cPrinter
      ELSE
         ::cPrinter := GetDefaultPrinter()
      ENDIF
   ENDCASE

   RETURN Self


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TMINIPRINT FROM TPRINTBASE

   METHOD BeginDocX
   METHOD BeginPageX
   METHOD EndDocX
   METHOD EndPageX
   METHOD GetDefPrinterX
   METHOD InitX
   METHOD MaxCol
   METHOD MaxRow
   METHOD PrintBarcodeX
   METHOD PrintDataX
   METHOD PrintImageX
   METHOD PrintLineX
   METHOD PrintRectangleX
   METHOD PrintRoundRectangleX
   METHOD ReleaseX
   METHOD SelPrinterX
   METHOD SetPreviewSizeX

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD MaxCol() CLASS TMINIPRINT

   LOCAL nCol

   IF _HMG_PRINTER_hDC == 0
      nCol := 0
   ELSEIF ::cUnits == "MM"
      nCol := _HMG_PRINTER_GETPAGEWIDTH() - 1
   ELSE
      nCol := _HMG_PRINTER_GETMAXCOL( _HMG_PRINTER_hDC, ::cFontName, ::nFontSize, ::nFontWidth, ::nFontAngle, ::lFontBold, ::lFontItalic, ::lFontUnderline, ::lFontStrikeout )
   ENDIF

   RETURN nCol

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD MaxRow() CLASS TMINIPRINT

   LOCAL nRow

   IF _HMG_PRINTER_hDC == 0
      nRow := 0
   ELSEIF ::cUnits == "MM"
      nRow := _HMG_PRINTER_GETPAGEHEIGHT() - 1
   ELSE
      nRow := _HMG_PRINTER_GETMAXROW( _HMG_PRINTER_hDC, ::cFontName, ::nFontSize, ::nFontWidth, ::nFontAngle, ::lFontBold, ::lFontItalic, ::lFontUnderline, ::lFontStrikeout )
   ENDIF

   RETURN nRow

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetPreviewSizeX( nSize ) CLASS TMINIPRINT

   IF _HMG_PRINTER_Preview
      IF nSize == NIL .OR. nSize < -9.99 .OR. nSize > 99.99
         nSize := 0
      ENDIF
      SET PREVIEW ZOOM nSize
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintBarcodeX( y, x, y1, x1, aColor ) CLASS TMINIPRINT

   @ y, x PRINT FILL TO y1, x1 COLOR aColor

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InitX() CLASS TMINIPRINT

   PUBLIC _HMG_PRINTER_aPrinterProperties
   PUBLIC _HMG_PRINTER_Collate
   PUBLIC _HMG_PRINTER_Copies
   PUBLIC _HMG_PRINTER_Error
   PUBLIC _HMG_PRINTER_hDC
   PUBLIC _HMG_PRINTER_hDC_Bak
   PUBLIC _HMG_PRINTER_Name
   PUBLIC _HMG_PRINTER_PageCount
   PUBLIC _HMG_PRINTER_Preview
   PUBLIC _HMG_PRINTER_TimeStamp

   ::aPrinters := aPrinters()
   ::cPrintLibrary := "MINIPRINT"

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginDocX() CLASS TMINIPRINT

   START PRINTDOC NAME ::Cargo

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndDocX() CLASS TMINIPRINT

   END PRINTDOC

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginPageX() CLASS TMINIPRINT

   START PRINTPAGE

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndPageX() CLASS TMINIPRINT

   END PRINTPAGE

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ReleaseX() CLASS TMINIPRINT

   RELEASE _HMG_PRINTER_aPrinterProperties
   RELEASE _HMG_PRINTER_Collate
   RELEASE _HMG_PRINTER_Copies
   RELEASE _HMG_PRINTER_Error
   RELEASE _HMG_PRINTER_hDC
   RELEASE _HMG_PRINTER_hDC_Bak
   RELEASE _HMG_PRINTER_Name
   RELEASE _HMG_PRINTER_PageCount
   RELEASE _HMG_PRINTER_Preview
   RELEASE _HMG_PRINTER_TimeStamp

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintDataX( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, cText, lItalic, nAngle, lUnder, lStrike, nWidth ) CLASS TMINIPRINT

   HB_SYMBOL_UNUSED( uData )
   HB_SYMBOL_UNUSED( nLen )

   IF ::cUnits == "MM"
      IF lItalic
         IF lBold
            IF lUnder
               IF lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD ITALIC COLOR aColor ANGLE nAngle UNDERLINE STRIKEOUT WIDTH nWidth
                  ELSEIF cAlign == "C"
                     _HMG_PRINTER_TextAlign( TA_CENTER )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD ITALIC COLOR aColor ANGLE nAngle UNDERLINE STRIKEOUT WIDTH nWidth
                  ELSE
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD ITALIC COLOR aColor ANGLE nAngle UNDERLINE STRIKEOUT WIDTH nWidth
                  ENDIF
               ELSE   // ! lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD ITALIC COLOR aColor ANGLE nAngle UNDERLINE  WIDTH nWidth
                  ELSEIF cAlign == "C"
                     _HMG_PRINTER_TextAlign( TA_CENTER )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD ITALIC COLOR aColor ANGLE nAngle UNDERLINE  WIDTH nWidth
                  ELSE
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD ITALIC COLOR aColor ANGLE nAngle UNDERLINE  WIDTH nWidth
                  ENDIF
               ENDIF
            ELSE   // ! lUnder
               IF lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD ITALIC COLOR aColor ANGLE nAngle STRIKEOUT WIDTH nWidth
                  ELSEIF cAlign == "C"
                     _HMG_PRINTER_TextAlign( TA_CENTER )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD ITALIC COLOR aColor ANGLE nAngle STRIKEOUT WIDTH nWidth
                  ELSE
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD ITALIC COLOR aColor ANGLE nAngle STRIKEOUT WIDTH nWidth
                  ENDIF
               ELSE   // ! lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD ITALIC COLOR aColor ANGLE nAngle WIDTH nWidth
                  ELSEIF cAlign == "C"
                     _HMG_PRINTER_TextAlign( TA_CENTER )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD ITALIC COLOR aColor ANGLE nAngle WIDTH nWidth
                  ELSE
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD ITALIC COLOR aColor ANGLE nAngle WIDTH nWidth
                  ENDIF
               ENDIF
            ENDIF
         ELSE   // ! lBold
            IF lUnder
               IF lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize ITALIC COLOR aColor ANGLE nAngle UNDERLINE STRIKEOUT WIDTH nWidth
                  ELSEIF cAlign == "C"
                     _HMG_PRINTER_TextAlign( TA_CENTER )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize ITALIC COLOR aColor ANGLE nAngle UNDERLINE STRIKEOUT WIDTH nWidth
                  ELSE
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize ITALIC COLOR aColor ANGLE nAngle UNDERLINE STRIKEOUT WIDTH nWidth
                  ENDIF
               ELSE   // ! lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize ITALIC COLOR aColor ANGLE nAngle UNDERLINE WIDTH nWidth
                  ELSEIF cAlign == "C"
                     _HMG_PRINTER_TextAlign( TA_CENTER )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize ITALIC COLOR aColor ANGLE nAngle UNDERLINE WIDTH nWidth
                  ELSE
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize ITALIC COLOR aColor ANGLE nAngle UNDERLINE WIDTH nWidth
                  ENDIF
               ENDIF
            ELSE   // ! lUnder
               IF lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize ITALIC COLOR aColor ANGLE nAngle STRIKEOUT WIDTH nWidth
                  ELSEIF cAlign == "C"
                     _HMG_PRINTER_TextAlign( TA_CENTER )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize ITALIC COLOR aColor ANGLE nAngle STRIKEOUT WIDTH nWidth
                  ELSE
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize ITALIC COLOR aColor ANGLE nAngle STRIKEOUT WIDTH nWidth
                  ENDIF
               ELSE   // ! lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize ITALIC COLOR aColor ANGLE nAngle WIDTH nWidth
                  ELSEIF cAlign == "C"
                     _HMG_PRINTER_TextAlign( TA_CENTER )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize ITALIC COLOR aColor ANGLE nAngle WIDTH nWidth
                  ELSE
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize ITALIC COLOR aColor ANGLE nAngle WIDTH nWidth
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ELSE   // ! lItalic
         IF lBold
            IF lUnder
               IF lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD COLOR aColor ANGLE nAngle UNDERLINE STRIKEOUT WIDTH nWidth
                  ELSEIF cAlign == "C"
                     _HMG_PRINTER_TextAlign( TA_CENTER )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD COLOR aColor ANGLE nAngle UNDERLINE STRIKEOUT WIDTH nWidth
                  ELSE
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD COLOR aColor ANGLE nAngle UNDERLINE STRIKEOUT WIDTH nWidth
                  ENDIF
               ELSE   // ! lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD COLOR aColor ANGLE nAngle UNDERLINE WIDTH nWidth
                  ELSEIF cAlign == "C"
                     _HMG_PRINTER_TextAlign( TA_CENTER )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD COLOR aColor ANGLE nAngle UNDERLINE WIDTH nWidth
                  ELSE
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD COLOR aColor ANGLE nAngle UNDERLINE WIDTH nWidth
                  ENDIF
               ENDIF
            ELSE   // ! lUnder
               IF lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD COLOR aColor ANGLE nAngle STRIKEOUT WIDTH nWidth
                  ELSEIF cAlign == "C"
                     _HMG_PRINTER_TextAlign( TA_CENTER )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD COLOR aColor ANGLE nAngle STRIKEOUT WIDTH nWidth
                  ELSE
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD COLOR aColor ANGLE nAngle STRIKEOUT WIDTH nWidth
                  ENDIF
               ELSE   // ! lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD COLOR aColor ANGLE nAngle WIDTH nWidth
                  ELSEIF cAlign == "C"
                     _HMG_PRINTER_TextAlign( TA_CENTER )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD COLOR aColor ANGLE nAngle WIDTH nWidth
                  ELSE
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD COLOR aColor ANGLE nAngle WIDTH nWidth
                  ENDIF
               ENDIF
            ENDIF
         ELSE   // ! lBold
            IF lUnder
               IF lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize COLOR aColor ANGLE nAngle UNDERLINE STRIKEOUT WIDTH nWidth
                  ELSEIF cAlign == "C"
                     _HMG_PRINTER_TextAlign( TA_CENTER )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize COLOR aColor ANGLE nAngle UNDERLINE STRIKEOUT WIDTH nWidth
                  ELSE
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize COLOR aColor ANGLE nAngle UNDERLINE STRIKEOUT WIDTH nWidth
                  ENDIF
               ELSE   // ! lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize COLOR aColor ANGLE nAngle UNDERLINE WIDTH nWidth
                  ELSEIF cAlign == "C"
                     _HMG_PRINTER_TextAlign( TA_CENTER )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize COLOR aColor ANGLE nAngle UNDERLINE WIDTH nWidth
                  ELSE
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize COLOR aColor ANGLE nAngle UNDERLINE WIDTH nWidth
                  ENDIF
               ENDIF
            ELSE   // ! lUnder
               IF lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize COLOR aColor ANGLE nAngle STRIKEOUT WIDTH nWidth
                  ELSEIF cAlign == "C"
                     _HMG_PRINTER_TextAlign( TA_CENTER )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize COLOR aColor ANGLE nAngle STRIKEOUT WIDTH nWidth
                  ELSE
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize COLOR aColor ANGLE nAngle STRIKEOUT WIDTH nWidth
                  ENDIF
               ELSE   // ! lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize COLOR aColor ANGLE nAngle WIDTH nWidth
                  ELSEIF cAlign == "C"
                     _HMG_PRINTER_TextAlign( TA_CENTER )
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize COLOR aColor ANGLE nAngle WIDTH nWidth
                  ELSE
                     @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize COLOR aColor ANGLE nAngle WIDTH nWidth
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      _HMG_PRINTER_TextAlign( TA_NOUPDATECP )
   ELSE   // ::cUnits == "ROWCOL"
      IF lItalic
         IF lBold
            IF lUnder
               IF lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 + ( Len( cText ) ) * ::nmHor PRINT ( cText ) FONT cFont SIZE nSize  BOLD ITALIC COLOR aColor ANGLE nAngle UNDERLINE STRIKEOUT WIDTH nWidth
                     _HMG_PRINTER_TextAlign( TA_NOUPDATECP )
                  ELSE
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT ( cText ) FONT cFont SIZE nSize BOLD ITALIC COLOR aColor ANGLE nAngle UNDERLINE STRIKEOUT WIDTH nWidth
                  ENDIF
               ELSE   // ! lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 + ( Len( cText ) ) * ::nmHor PRINT ( cText ) FONT cFont SIZE nSize  BOLD ITALIC COLOR aColor ANGLE nAngle UNDERLINE WIDTH nWidth
                     _HMG_PRINTER_TextAlign( TA_NOUPDATECP )
                  ELSE
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT ( cText ) FONT cFont SIZE nSize BOLD ITALIC COLOR aColor ANGLE nAngle UNDERLINE WIDTH nWidth
                  ENDIF
               ENDIF
            ELSE   // ! lUnder
               IF lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 + ( Len( cText ) ) * ::nmHor PRINT ( cText ) FONT cFont SIZE nSize  BOLD ITALIC COLOR aColor ANGLE nAngle STRIKEOUT WIDTH nWidth
                     _HMG_PRINTER_TextAlign( TA_NOUPDATECP )
                  ELSE
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT ( cText ) FONT cFont SIZE nSize BOLD ITALIC COLOR aColor ANGLE nAngle STRIKEOUT WIDTH nWidth
                  ENDIF
               ELSE   // ! lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 + ( Len( cText ) ) * ::nmHor PRINT ( cText ) FONT cFont SIZE nSize  BOLD ITALIC COLOR aColor ANGLE nAngle WIDTH nWidth
                     _HMG_PRINTER_TextAlign( TA_NOUPDATECP )
                  ELSE
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT ( cText ) FONT cFont SIZE nSize BOLD ITALIC COLOR aColor ANGLE nAngle WIDTH nWidth
                  ENDIF
               ENDIF
            ENDIF
         ELSE   // ! lBold
            IF lUnder
               IF lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 + ( Len( cText ) ) * ::nmHor PRINT ( cText ) FONT cFont SIZE nSize  ITALIC COLOR aColor ANGLE nAngle UNDERLINE STRIKEOUT WIDTH nWidth
                     _HMG_PRINTER_TextAlign( TA_NOUPDATECP )
                  ELSE
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT ( cText ) FONT cFont SIZE nSize ITALIC COLOR aColor ANGLE nAngle UNDERLINE STRIKEOUT WIDTH nWidth
                  ENDIF
               ELSE   // ! lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 + ( Len( cText ) ) * ::nmHor PRINT ( cText ) FONT cFont SIZE nSize  ITALIC COLOR aColor ANGLE nAngle UNDERLINE WIDTH nWidth
                     _HMG_PRINTER_TextAlign( TA_NOUPDATECP )
                  ELSE
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT ( cText ) FONT cFont SIZE nSize ITALIC COLOR aColor ANGLE nAngle UNDERLINE WIDTH nWidth
                  ENDIF
               ENDIF
            ELSE   // ! lUnder
               IF lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 + ( Len( cText ) ) * ::nmHor PRINT ( cText ) FONT cFont SIZE nSize  ITALIC COLOR aColor ANGLE nAngle STRIKEOUT WIDTH nWidth
                     _HMG_PRINTER_TextAlign( TA_NOUPDATECP )
                  ELSE
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT ( cText ) FONT cFont SIZE nSize ITALIC COLOR aColor ANGLE nAngle STRIKEOUT WIDTH nWidth
                  ENDIF
               ELSE   // ! lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 + ( Len( cText ) ) * ::nmHor PRINT ( cText ) FONT cFont SIZE nSize  ITALIC COLOR aColor ANGLE nAngle WIDTH nWidth
                     _HMG_PRINTER_TextAlign( TA_NOUPDATECP )
                  ELSE
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT ( cText ) FONT cFont SIZE nSize ITALIC COLOR aColor ANGLE nAngle WIDTH nWidth
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ELSE   // ! lItalic
         IF lBold
            IF lUnder
               IF lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 + ( Len( cText ) ) * ::nmHor PRINT ( cText ) FONT cFont SIZE nSize  BOLD COLOR aColor ANGLE nAngle UNDERLINE STRIKEOUT WIDTH nWidth
                     _HMG_PRINTER_TextAlign( TA_NOUPDATECP )
                  ELSE
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT ( cText ) FONT cFont SIZE nSize BOLD COLOR aColor ANGLE nAngle UNDERLINE STRIKEOUT WIDTH nWidth
                  ENDIF
               ELSE   // ! lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 + ( Len( cText ) ) * ::nmHor PRINT ( cText ) FONT cFont SIZE nSize  BOLD COLOR aColor ANGLE nAngle UNDERLINE WIDTH nWidth
                     _HMG_PRINTER_TextAlign( TA_NOUPDATECP )
                  ELSE
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT ( cText ) FONT cFont SIZE nSize BOLD COLOR aColor ANGLE nAngle UNDERLINE WIDTH nWidth
                  ENDIF
               ENDIF
            ELSE   // ! lUnder
               IF lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 + ( Len( cText ) ) * ::nmHor PRINT ( cText ) FONT cFont SIZE nSize  BOLD COLOR aColor ANGLE nAngle STRIKEOUT WIDTH nWidth
                     _HMG_PRINTER_TextAlign( TA_NOUPDATECP )
                  ELSE
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT ( cText ) FONT cFont SIZE nSize BOLD COLOR aColor ANGLE nAngle STRIKEOUT WIDTH nWidth
                  ENDIF
               ELSE   // ! lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 + ( Len( cText ) ) * ::nmHor PRINT ( cText ) FONT cFont SIZE nSize  BOLD COLOR aColor ANGLE nAngle WIDTH nWidth
                     _HMG_PRINTER_TextAlign( TA_NOUPDATECP )
                  ELSE
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT ( cText ) FONT cFont SIZE nSize BOLD COLOR aColor ANGLE nAngle WIDTH nWidth
                  ENDIF
               ENDIF
            ENDIF
         ELSE   // ! lBold
            IF lUnder
               IF lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 + ( Len( cText ) ) * ::nmHor PRINT ( cText ) FONT cFont SIZE nSize  COLOR aColor ANGLE nAngle UNDERLINE STRIKEOUT WIDTH nWidth
                     _HMG_PRINTER_TextAlign( TA_NOUPDATECP )
                  ELSE
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT ( cText ) FONT cFont SIZE nSize COLOR aColor ANGLE nAngle UNDERLINE STRIKEOUT WIDTH nWidth
                  ENDIF
               ELSE   // ! lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 + ( Len( cText ) ) * ::nmHor PRINT ( cText ) FONT cFont SIZE nSize  COLOR aColor ANGLE nAngle UNDERLINE WIDTH nWidth
                     _HMG_PRINTER_TextAlign( TA_NOUPDATECP )
                  ELSE
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT ( cText ) FONT cFont SIZE nSize COLOR aColor ANGLE nAngle UNDERLINE WIDTH nWidth
                  ENDIF
               ENDIF
            ELSE   // ! lUnder
               IF lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 + ( Len( cText ) ) * ::nmHor PRINT ( cText ) FONT cFont SIZE nSize  COLOR aColor ANGLE nAngle STRIKEOUT WIDTH nWidth
                     _HMG_PRINTER_TextAlign( TA_NOUPDATECP )
                  ELSE
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT ( cText ) FONT cFont SIZE nSize COLOR aColor ANGLE nAngle STRIKEOUT WIDTH nWidth
                  ENDIF
               ELSE   // ! lStrike
                  IF cAlign == "R"
                     _HMG_PRINTER_TextAlign( TA_RIGHT )
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 + ( Len( cText ) ) * ::nmHor PRINT ( cText ) FONT cFont SIZE nSize  COLOR aColor ANGLE nAngle WIDTH nWidth
                     _HMG_PRINTER_TextAlign( TA_NOUPDATECP )
                  ELSE
                     @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT ( cText ) FONT cFont SIZE nSize COLOR aColor ANGLE nAngle WIDTH nWidth
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintImageX( nLin, nCol, nLinF, nColF, cImage, aResol, aSize ) CLASS TMINIPRINT

   HB_SYMBOL_UNUSED( aResol )
   HB_SYMBOL_UNUSED( aSize )

   IF ::cUnits == "MM"
      @ nLin, nCol PRINT IMAGE cImage WIDTH ( nColF - nCol ) HEIGHT ( nLinF - nLin ) STRETCH
   ELSE
      @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT IMAGE cImage WIDTH ( ( nColF - nCol - 1 ) * ::nmHor + ::nhFij ) HEIGHT ( ( nLinF + 0.5 - nLin ) * ::nmVer + ::nvFij ) STRETCH
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintLineX( nLin, nCol, nLinF, nColF, atColor, ntwPen, lSolid ) CLASS TMINIPRINT

   LOCAL nVDispl := 1

   IF ::cUnits == "MM"
      @ nLin, nCol PRINT LINE TO nLinF, nColF COLOR atColor PENWIDTH ntwPen STYLE iif( lSolid, PEN_SOLID, PEN_DASH )
   ELSE
      @ nLin * ::nmVer * nVDispl + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT LINE TO nLinF * ::nmVer * nVDispl + ::nvFij, nColF * ::nmHor + ::nhFij * 2 COLOR atColor PENWIDTH ntwPen STYLE iif( lSolid, PEN_SOLID, PEN_DASH )
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintRectangleX( nLin, nCol, nLinF, nColF, atColor, ntwPen, lSolid, arColor ) CLASS TMINIPRINT

   LOCAL nVDispl := 1

   IF ::cUnits == "MM"
      @ nLin, nCol PRINT RECTANGLE TO nLinF, nColF COLOR atColor PENWIDTH ntwPen STYLE iif( lSolid, PEN_SOLID, PEN_DASH ) BRUSHCOLOR arColor
   ELSE
      @ nLin * ::nmVer * nVDispl + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT RECTANGLE TO nLinF * ::nmVer * nVDispl + ::nvFij, nColF * ::nmHor + ::nhFij * 2 COLOR atColor PENWIDTH ntwPen STYLE iif( lSolid, PEN_SOLID, PEN_DASH ) BRUSHCOLOR arColor
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintRoundRectangleX( nLin, nCol, nLinF, nColF, atColor, ntwPen, lSolid, arColor ) CLASS TMINIPRINT

   LOCAL nVDispl := 1  // nVDispl := 1.009

   IF ::cUnits == "MM"
      @ nLin, nCol PRINT RECTANGLE TO nLinF, nColF PENWIDTH ntwPen STYLE iif( lSolid, PEN_SOLID, PEN_DASH ) COLOR atColor BRUSHCOLOR arColor ROUNDED
   ELSE
      @ nLin * ::nmVer * nVDispl + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT RECTANGLE TO nLinF * ::nmVer * nVDispl + ::nvFij, nColF * ::nmHor + ::nhFij * 2 PENWIDTH ntwPen STYLE iif( lSolid, PEN_SOLID, PEN_DASH ) COLOR atColor BRUSHCOLOR arColor ROUNDED
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SelPrinterX( lSelect, lPreview, lLandscape, nPaperSize, cPrinterX, nRes, nBin, nDuplex, lCollate, nCopies, lColor, nScale, nPaperLength, nPaperWidth ) CLASS TMINIPRINT

   LOCAL nOrientation, lSucess, nCollate, nColor

   DEFAULT nPaperSize   TO -999
   DEFAULT nRes         TO -999
   DEFAULT nBin         TO -999
   DEFAULT nDuplex      TO -999
   DEFAULT nCopies      TO -999
   DEFAULT nScale       TO -999
   DEFAULT nPaperLength TO -999
   DEFAULT nPaperWidth  TO -999

   IF lLandscape
      nOrientation := PRINTER_ORIENT_LANDSCAPE
   ELSE
      nOrientation := PRINTER_ORIENT_PORTRAIT
   ENDIF

   IF HB_ISLOGICAL( lCollate )
      IF lCollate
         nCollate := PRINTER_COLLATE_TRUE
      ELSE
         nCollate := PRINTER_COLLATE_FALSE
      ENDIF
   ELSE
      nCollate := -999
   ENDIF

   IF HB_ISLOGICAL( lColor )
      IF lColor
         nColor := PRINTER_COLOR_COLOR
      ELSE
         nColor := PRINTER_COLOR_MONOCHROME
      ENDIF
   ELSE
      nColor := -999
   ENDIF

   IF cPrinterX == NIL
      IF lSelect
         ::cPrinter := GetPrinter()
         IF Empty( ::cPrinter )
            ::lPrError := .T.
            RETURN NIL
         ENDIF

         IF lPreview
            SELECT PRINTER ::cPrinter TO lSucess ;
               ORIENTATION nOrientation ;
               PAPERSIZE nPaperSize ;
               QUALITY nRes ;
               DEFAULTSOURCE nBin ;
               DUPLEX nDuplex ;
               COLLATE nCollate ;
               COPIES nCopies ;
               COLOR nColor ;
               SCALE nScale ;
               PAPERLENGTH nPaperLength ;
               PAPERWIDTH nPaperWidth ;
               PREVIEW
         ELSE
            SELECT PRINTER ::cPrinter TO lSucess ;
               ORIENTATION nOrientation ;
               PAPERSIZE nPaperSize ;
               QUALITY nRes ;
               DEFAULTSOURCE nBin ;
               DUPLEX nDuplex ;
               COLLATE nCollate ;
               COPIES nCopies ;
               COLOR nColor ;
               SCALE nScale ;
               PAPERLENGTH nPaperLength ;
               PAPERWIDTH nPaperWidth
         ENDIF
      ELSE
         ::cPrinter := ::GetDefPrinter()
         IF lPreview
            SELECT PRINTER DEFAULT TO lSucess ;
               ORIENTATION nOrientation  ;
               PAPERSIZE nPaperSize ;
               QUALITY nRes ;
               DEFAULTSOURCE nBin ;
               DUPLEX nDuplex ;
               COLLATE nCollate ;
               COPIES nCopies ;
               COLOR nColor ;
               SCALE nScale ;
               PAPERLENGTH nPaperLength ;
               PAPERWIDTH nPaperWidth ;
               PREVIEW
         ELSE
            SELECT PRINTER DEFAULT TO lSucess  ;
               ORIENTATION nOrientation  ;
               PAPERSIZE nPaperSize ;
               QUALITY nRes ;
               DEFAULTSOURCE nBin ;
               DUPLEX nDuplex ;
               COLLATE nCollate ;
               COPIES nCopies ;
               COLOR nColor ;
               SCALE nScale ;
               PAPERLENGTH nPaperLength ;
               PAPERWIDTH nPaperWidth
         ENDIF
      ENDIF
   ELSE
      ::cPrinter := cPrinterX
      IF Empty( ::cPrinter )
         ::lPrError := .T.
         RETURN NIL
      ENDIF

      IF lPreview
         SELECT PRINTER ::cPrinter TO lSucess ;
            ORIENTATION nOrientation ;
            PAPERSIZE nPaperSize ;
            QUALITY nRes ;
            DEFAULTSOURCE nBin ;
            DUPLEX nDuplex ;
            COLLATE nCollate ;
            COPIES nCopies ;
            COLOR nColor ;
            SCALE nScale ;
            PAPERLENGTH nPaperLength ;
            PAPERWIDTH nPaperWidth ;
            PREVIEW
      ELSE
         SELECT PRINTER ::cPrinter TO lSucess ;
            ORIENTATION nOrientation ;
            PAPERSIZE nPaperSize ;
            QUALITY nRes ;
            DEFAULTSOURCE nBin ;
            DUPLEX nDuplex ;
            COLLATE nCollate ;
            COPIES nCopies ;
            COLOR nColor ;
            SCALE nScale ;
            PAPERLENGTH nPaperLength ;
            PAPERWIDTH nPaperWidth
      ENDIF
   ENDIF

   IF ! lSucess
      ::lPrError := .T.
      RETURN NIL
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GetDefPrinterX() CLASS TMINIPRINT

   RETURN GetDefaultPrinter()


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS THBPRINTER FROM TPRINTBASE

   DATA oHBPrn                    INIT NIL                   READONLY

   METHOD BeginDocX
   METHOD BeginPageX
   METHOD EndDocX
   METHOD EndPageX
   METHOD GetDefPrinterX
   METHOD InitX
   METHOD MaxCol
   METHOD MaxRow
   METHOD PrintBarcodeX
   METHOD PrintDataX
   METHOD PrintImageX
   METHOD PrintLineX
   METHOD PrintRectangleX
   METHOD PrintRoundRectangleX
   METHOD ReleaseX
   METHOD SelPrinterX
   METHOD SetColorX
   METHOD SetPreviewSizeX

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD MaxCol() CLASS THBPRINTER

   LOCAL nCol

   IF HB_ISOBJECT( ::oHBPrn )
      IF ::cUnits == "MM"
         nCol := ::oHBPrn:MaxCol
      ELSE
         SET UNITS ROWCOL
         nCol := ::oHBPrn:MaxCol
         SET UNITS MM
      ENDIF
   ELSE
      nCol := 0
   ENDIF

   RETURN nCol

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD MaxRow() CLASS THBPRINTER

   LOCAL nRow

   IF HB_ISOBJECT( ::oHBPrn )
      IF ::cUnits == "MM"
         nRow := ::oHBPrn:MaxRow
      ELSE
         SET UNITS ROWCOL
         nRow := ::oHBPrn:MaxRow
         SET UNITS MM
      ENDIF
   ELSE
      nRow := 0
   ENDIF

   RETURN nRow

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InitX() CLASS THBPRINTER

   INIT PRINTSYS
   GET PRINTERS TO ::aPrinters
   GET PORTS TO ::aPorts
   SET UNITS MM
   SET CHANGES LOCAL         // sets printer options not permanent
   SET PREVIEW SCALE 2
   ::cPrintLibrary := "HBPRINTER"

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginDocX() CLASS THBPRINTER

   START DOC NAME ::Cargo
   CHANGE FONT "F0" NAME ::cFontName SIZE ::nFontSize
   CHANGE BRUSH "B0" COLOR ::aColor STYLE BS_SOLID
   CHANGE BRUSH "B1" COLOR {255, 255, 255} STYLE BS_SOLID
   CHANGE PEN "P0" WIDTH ::nwPen COLOR ::aColor STYLE PS_SOLID

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndDocX() CLASS THBPRINTER

   END DOC

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginPageX() CLASS THBPRINTER

   START PAGE

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndPageX() CLASS THBPRINTER

   END PAGE

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ReleaseX() CLASS THBPRINTER

   RELEASE PRINTSYS

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintDataX( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, cText, lItalic, nAngle, lUnder, lStrike, nWidth ) CLASS THBPRINTER

   HB_SYMBOL_UNUSED( uData )
   HB_SYMBOL_UNUSED( nLen )

   IF lItalic
      IF lBold
         IF lUnder
            IF lStrike
               CHANGE FONT "F0" NAME cFont SIZE nSize WIDTH nWidth ANGLE nAngle ITALIC BOLD UNDERLINE STRIKEOUT
            ELSE   // ! lStrike
               CHANGE FONT "F0" NAME cFont SIZE nSize WIDTH nWidth ANGLE nAngle ITALIC BOLD UNDERLINE NOSTRIKEOUT
            ENDIF
         ELSE   // ! lUnder
            IF lStrike
               CHANGE FONT "F0" NAME cFont SIZE nSize WIDTH nWidth ANGLE nAngle ITALIC BOLD NOUNDERLINE STRIKEOUT
            ELSE   // ! lStrike
               CHANGE FONT "F0" NAME cFont SIZE nSize WIDTH nWidth ANGLE nAngle ITALIC BOLD NOUNDERLINE NOSTRIKEOUT
            ENDIF
         ENDIF
      ELSE   // ! lBold
         IF lUnder
            IF lStrike
               CHANGE FONT "F0" NAME cFont SIZE nSize WIDTH nWidth ANGLE nAngle ITALIC NOBOLD UNDERLINE STRIKEOUT
            ELSE   // ! lStrike
               CHANGE FONT "F0" NAME cFont SIZE nSize WIDTH nWidth ANGLE nAngle ITALIC NOBOLD UNDERLINE NOSTRIKEOUT
            ENDIF
         ELSE   // ! lUnder
            IF lStrike
               CHANGE FONT "F0" NAME cFont SIZE nSize WIDTH nWidth ANGLE nAngle ITALIC NOBOLD NOUNDERLINE STRIKEOUT
            ELSE   // ! lStrike
               CHANGE FONT "F0" NAME cFont SIZE nSize WIDTH nWidth ANGLE nAngle ITALIC NOBOLD NOUNDERLINE NOSTRIKEOUT
            ENDIF
         ENDIF
      ENDIF
   ELSE   // ! lItalic
      IF lBold
         IF lUnder
            IF lStrike
               CHANGE FONT "F0" NAME cFont SIZE nSize WIDTH nWidth ANGLE nAngle NOITALIC BOLD UNDERLINE STRIKEOUT
            ELSE   // ! lStrike
               CHANGE FONT "F0" NAME cFont SIZE nSize WIDTH nWidth ANGLE nAngle NOITALIC BOLD UNDERLINE NOSTRIKEOUT
            ENDIF
         ELSE   // ! lUnder
            IF lStrike
               CHANGE FONT "F0" NAME cFont SIZE nSize WIDTH nWidth ANGLE nAngle NOITALIC BOLD NOUNDERLINE STRIKEOUT
            ELSE   // ! lStrike
               CHANGE FONT "F0" NAME cFont SIZE nSize WIDTH nWidth ANGLE nAngle NOITALIC BOLD NOUNDERLINE NOSTRIKEOUT
            ENDIF
         ENDIF
      ELSE   // ! lBold
         IF lUnder
            IF lStrike
               CHANGE FONT "F0" NAME cFont SIZE nSize WIDTH nWidth ANGLE nAngle NOITALIC NOBOLD UNDERLINE STRIKEOUT
            ELSE   // ! lStrike
               CHANGE FONT "F0" NAME cFont SIZE nSize WIDTH nWidth ANGLE nAngle NOITALIC NOBOLD UNDERLINE NOSTRIKEOUT
            ENDIF
         ELSE   // ! lUnder
            IF lStrike
               CHANGE FONT "F0" NAME cFont SIZE nSize WIDTH nWidth ANGLE nAngle NOITALIC NOBOLD NOUNDERLINE STRIKEOUT
            ELSE   // ! lStrike
               CHANGE FONT "F0" NAME cFont SIZE nSize WIDTH nWidth ANGLE nAngle NOITALIC NOBOLD NOUNDERLINE NOSTRIKEOUT
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   SELECT FONT "F0"

   SET TEXTCOLOR aColor

   IF ::cUnits == "MM"
      IF cAlign == "R"
         @ nLin, nCol SAY ( cText ) ALIGN TA_RIGHT TO PRINT
      ELSEIF cAlign == "C"
         @ nLin, nCol SAY ( cText ) ALIGN TA_CENTER TO PRINT
      ELSE
         @ nLin, nCol SAY ( cText ) TO PRINT
      ENDIF
   ELSE
      IF cAlign == "R"
         SET TEXT ALIGN RIGHT
         @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 + ( Len( cText ) ) * ::nmHor SAY ( cText ) TO PRINT
         SET TEXT ALIGN LEFT
      ELSE
         @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 SAY ( cText ) TO PRINT
      ENDIF
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintBarcodeX( y, x, y1, x1, aColor ) CLASS THBPRINTER

   CHANGE BRUSH "B0" COLOR aColor STYLE BS_SOLID
   @ y, x, y1, x1 FILLRECT BRUSH "B0"

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintImageX( nLin, nCol, nLinF, nColF, cImage, aResol, aSize ) CLASS THBPRINTER

   HB_SYMBOL_UNUSED( aResol )
   HB_SYMBOL_UNUSED( aSize )

   IF ::cUnits == "MM"
      @ nLin, nCol PICTURE cImage SIZE ( nLinF - nLin ), ( nColF - nCol )
   ELSE
      @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PICTURE cImage SIZE ( nLinF - nLin ) * ::nmVer + ::nvFij, ( nColF - nCol - 3 ) * ::nmHor + ::nhFij * 2
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintLineX( nLin, nCol, nLinF, nColF, atColor, ntwPen, lSolid ) CLASS THBPRINTER

   LOCAL nVDispl := 1

   CHANGE PEN "P0" WIDTH ntwPen * 10 COLOR atColor STYLE iif( lSolid, PS_SOLID, PS_DASH )
   IF ::cUnits == "MM"
      @ nLin, nCol, nLinF, nColF LINE PEN "P0"
   ELSE
      @ nLin * ::nmVer * nVDispl + ::nvFij, nCol * ::nmHor + ::nhFij * 2, nLinF * ::nmVer * nVDispl + ::nvFij, nColF * ::nmHor + ::nhFij * 2 LINE PEN "P0"
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintRectangleX( nLin, nCol, nLinF, nColF, atColor, ntwPen, lSolid, arColor ) CLASS THBPRINTER

   LOCAL nVDispl := 1

   CHANGE PEN "P0" WIDTH ntwPen * 10 COLOR atColor STYLE iif( lSolid, PS_SOLID, PS_DASH )
   CHANGE BRUSH "B1" COLOR arColor STYLE BS_SOLID
   IF ::cUnits == "MM"
      @ nLin, nCol, nLinF, nColF RECTANGLE PEN "P0" BRUSH "B1"
   ELSE
      @ nLin * ::nmVer * nVDispl + ::nvFij, nCol * ::nmHor + ::nhFij * 2, nLinF * ::nmVer * nVDispl + ::nvFij, nColF * ::nmHor + ::nhFij * 2 RECTANGLE PEN "P0" BRUSH "B1"
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintRoundRectangleX( nLin, nCol, nLinF, nColF, atColor, ntwPen, lSolid, arColor ) CLASS THBPRINTER

   LOCAL nVDispl := 1

   CHANGE PEN "P0" WIDTH ntwPen * 10 COLOR atColor STYLE iif( lSolid, PS_SOLID, PS_DASH )
   CHANGE BRUSH "B1" COLOR arColor STYLE BS_SOLID
   IF ::cUnits == "MM"
      @ nLin, nCol, nLinF, nColF ROUNDRECT ROUNDR 10 ROUNDC 10 PEN "P0" BRUSH "B1"
   ELSE
      @ nLin * ::nmVer * nVDispl + ::nvFij, nCol * ::nmHor + ::nhFij * 2, nLinF * ::nmVer * nVDispl + ::nvFij, nColF * ::nmHor + ::nhFij * 2 ROUNDRECT ROUNDR 10 ROUNDC 10 PEN "P0" BRUSH "B1"
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SelPrinterX( lSelect, lPreview, lLandscape, nPaperSize, cPrinterX, nRes, nBin, nDuplex, lCollate, nCopies, lColor, nScale, nPaperLength, nPaperWidth ) CLASS THBPRINTER

   IF lSelect
      IF lPreview
         SELECT BY DIALOG PREVIEW
      ELSE
         SELECT BY DIALOG
      ENDIF
   ELSE
      IF cPrinterX == NIL
         IF lPreview
            SELECT DEFAULT PREVIEW
         ELSE
            SELECT DEFAULT
         ENDIF
      ELSE
         IF lPreview
            SELECT PRINTER cPrinterX PREVIEW
         ELSE
            SELECT PRINTER cPrinterX
         ENDIF
      ENDIF
   ENDIF

   IF HBPRNERROR != 0
      ::lPrError := .T.
      RETURN NIL
   ENDIF

   ::cPrinter := ::oHBPrn:PrinterName

   DEFINE FONT "F0" NAME ::cFontName SIZE ::nFontSize
   SELECT FONT "F0"
   DEFINE BRUSH "B0" COLOR ::aColor STYLE BS_SOLID
   DEFINE BRUSH "B1" COLOR {255, 255, 255} STYLE BS_SOLID
   SELECT BRUSH "B0"
   DEFINE PEN "P0" WIDTH ::nwPen COLOR ::aColor STYLE PS_SOLID
   SELECT PEN "P0"

   IF lLandscape
      SET PAGE ORIENTATION DMORIENT_LANDSCAPE FONT "F0"
   ELSE
      SET PAGE ORIENTATION DMORIENT_PORTRAIT  FONT "F0"
   ENDIF

   IF nPaperSize # NIL
      SET PAGE PAPERSIZE nPaperSize
   ENDIF

   IF nRes # NIL
      SET QUALITY nRes
   ENDIF

   IF nBin # NIL
      SET BIN nBin
   ENDIF

   DO CASE
   CASE nDuplex == DMDUP_VERTICAL
      SET DUPLEX VERTICAL
   CASE nDuplex == DMDUP_HORIZONTAL
      SET DUPLEX HORIZONTAL
   CASE nDuplex == DMDUP_SIMPLEX
      SET DUPLEX OFF
   ENDCASE

   IF HB_ISLOGICAL( lCollate )
      IF lCollate
         SET COLLATE ON
      ELSE
         SET COLLATE OFF
      ENDIF
   ENDIF

   IF nCopies # NIL
      SET COPIES TO nCopies
   ENDIF

   IF HB_ISLOGICAL( lColor )
      IF lColor
         SET COLORMODE DMCOLOR_COLOR
      ELSE
         SET COLORMODE DMCOLOR_MONOCHROME
      ENDIF
   ENDIF

   IF nScale # NIL
      SET SCALE TO nScale
   ENDIF

   IF nPaperLength # NIL
      SET PAPERLENGTH TO nPaperLength
   ENDIF

   IF nPaperWidth # NIL
      SET PAPERWIDTH TO nPaperWidth
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GetDefPrinterX() CLASS THBPRINTER

   LOCAL cDefPrinter

   GET DEFAULT PRINTER TO cDefPrinter

   RETURN cDefPrinter

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetColorX() CLASS THBPRINTER

   CHANGE PEN "P0" WIDTH ::nwPen COLOR ::aColor STYLE PS_SOLID

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetPreviewSizeX( nSize ) CLASS THBPRINTER

   IF nSize == NIL .OR. nSize < 1 .OR. nSize > 5
      nSize := 2
   ENDIF
   SET PREVIEW SCALE nSize

   RETURN Self


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TDOSPRINT FROM TPRINTBASE

   DATA cBusca                    INIT ""                    READONLY
   DATA cString                   INIT ""                    READONLY
   DATA nOccur                    INIT 0                     READONLY

   METHOD BeginDocX
   METHOD BeginPageX
   METHOD CondenDosX
   METHOD EndDocX
   METHOD EndPageX
   METHOD InitX
   METHOD NextSearch
   METHOD NormalDosX
   METHOD PrintDataX
   METHOD PrintImage              BLOCK { || NIL }
   METHOD PrintLineX
   METHOD PrintModeX
   METHOD SearchString
   METHOD SelPrinterX
   METHOD SetPreviewSize          BLOCK { || NIL }
   /*
   TODO: Add METHOD PrintRectangleX using two horizontal lines and pairs of |
   */

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintModeX( cFile ) CLASS TDOSPRINT

   LOCAL cBat, nHdl

   IF HB_ISSTRING( cFile ) .AND. ! Empty( cFile )
      cBat := 'b' + AllTrim( Str( hb_Random( 999999 ), 6 ) ) + '.bat'
      nHdl := FCreate( cBat )
      FWrite( nHdl, 'copy "' + cFile + '" ' + ::cPort + Chr( 13 ) + Chr( 10 ) )
      FWrite( nHdl, "rem " + _OOHG_Messages( 12, 3 ) + Chr( 13 ) + Chr( 10 ) )
      FClose( nHdl )
      hb_idleSleep( 1 )
      WaitRun( cBat, 0 )
      FErase( cBat )

      IF ::lSaveTemp
         BEGIN SEQUENCE
            COPY FILE ( cFile ) TO ( ::cDocument )
         RECOVER
            // TODO: Add error message
         END SEQUENCE
      ENDIF
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InitX() CLASS TDOSPRINT

   ::cPrintLibrary := "DOSPRINT"

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SelPrinterX( lSelect, lPreview, lLandscape, nPaperSize, cPrinterX, nRes, nBin, nDuplex, lCollate, nCopies, lColor, nScale, nPaperLength, nPaperWidth ) CLASS TDOSPRINT

   HB_SYMBOL_UNUSED( lPreview )
   HB_SYMBOL_UNUSED( lLandscape )
   HB_SYMBOL_UNUSED( nPaperSize )
   HB_SYMBOL_UNUSED( nRes )
   HB_SYMBOL_UNUSED( nBin )
   HB_SYMBOL_UNUSED( nDuplex )
   HB_SYMBOL_UNUSED( lCollate )
   HB_SYMBOL_UNUSED( nCopies )
   HB_SYMBOL_UNUSED( lColor )
   HB_SYMBOL_UNUSED( nScale )
   HB_SYMBOL_UNUSED( nPaperLength )
   HB_SYMBOL_UNUSED( nPaperWidth )

   ::cPrinter := "CMD.EXE"

   IF HB_ISSTRING( cPrinterX )
      cPrinterX := Upper( cPrinterX )
      IF ! cPrinterX $ "PRN LPT1: LPT2: LPT3: LPT4: LPT5: LPT6:"
         IF ::lShowError
            MsgStop( _OOHG_Messages( 12, 13 ), _OOHG_Messages( 12, 12 ) )
         ENDIF
         ::lPrError := .T.
         RETURN NIL
      ENDIF
   ENDIF

   DO WHILE File( ::cTempFile )
      ::cTempFile := TEMP_FILE_NAME
   ENDDO

   IF lSelect
      ::aPorts:= ASort( aLocalPorts() )

      DEFINE WINDOW myselprinter ;
         AT 0, 0 ;
         WIDTH 345 ;
         HEIGHT GetTitleHeight() + 100 ;
         TITLE _OOHG_Messages( 12, 14 ) ;
         MODAL ;
         NOSIZE

         @ 15, 10 COMBOBOX combo_1 ITEMS ::aPorts VALUE 1 WIDTH 320

         @ 53, 65 BUTTON ok CAPTION _OOHG_Messages( 12, 15 ) ACTION ( ::cPort := SubStr( myselprinter.combo_1.Item( myselprinter.combo_1.Value ), 1, AT(",", myselprinter.combo_1.Item( myselprinter.combo_1.Value ))-1 ), myselprinter.Release() )

         @ 53,175 BUTTON cancel CAPTION _OOHG_Messages( 12, 16 ) ACTION ( ::cPort := "PRN", ::lPrError := .T., myselprinter.Release() )
      END WINDOW

      CENTER WINDOW myselprinter
      myselprinter.ok.SetFocus()
      ACTIVATE WINDOW myselprinter
   ELSE
      IF ! Empty( cPrinterX )
         ::cPort := cPrinterX
      ELSE
         ::cPort := "PRN"
      ENDIF
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION aLocalPorts()

   LOCAL aPrnPort, aResults := {}

   aPrnPort := GetPrintersInfo()
   IF aPrnPort <> ",,"
      aPrnPort := str2arr( aPrnPort, ",," )
      AEval( aPrnPort, { | x, xi | aPrnPort[ xi ] := str2arr( x, ',' ) } )
      AEval( aPrnPort, { | x | AAdd( aResults, x[ 2 ] + ", " + x[ 1 ] ) } )
   ENDIF

   RETURN aResults

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginDocX() CLASS TDOSPRINT

   ::cDocument := ParseName( ::Cargo, "dos" )
   SET PRINTER TO ( ::cTempFile )
   SET DEVICE TO PRINT

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndDocX() CLASS TDOSPRINT

   LOCAL nHandle, wr, nx, ny

   nx := GetDesktopWidth()
   ny := GetDesktopHeight()

   SET DEVICE TO SCREEN
   SET PRINTER TO

   nHandle := FOpen( ::cTempFile, 0 + 64 )

   IF ::ImPreview
      wr := MemoRead( ( ::cTempFile ) )

      DEFINE WINDOW print_preview  ;
         AT 0, 0 ;
         WIDTH nx HEIGHT ny - 70 - 40 ;
         TITLE _OOHG_Messages( 12, 17 ) + ::cTempFile + " " + ::cPrintLibrary ;
         MODAL

         @ 42, 0 RICHEDITBOX edit_p ;
            OF print_preview ;
            WIDTH nx - 5 ;
            HEIGHT ny - 40 - 70 - 70 ;
            VALUE wr ;
            READONLY ;
            FONT 'Courier New' ;
            SIZE 10 ;
            BACKCOLOR WHITE

         DEFINE TOOLBAR toolbr BUTTONSIZE 80, 20
            BUTTON but_4 CAPTION _OOHG_Messages( 12, 18 )    ACTION ( print_preview.Release() )                  TOOLTIP _OOHG_Messages( 12, 19 )
            BUTTON but_1 CAPTION _OOHG_Messages( 12, 20 )    ACTION Zoom( "+" )                                  TOOLTIP _OOHG_Messages( 12, 21 )
            BUTTON but_2 CAPTION _OOHG_Messages( 12, 22 )    ACTION Zoom( "-" )                                  TOOLTIP _OOHG_Messages( 12, 23 )
            BUTTON but_3 CAPTION _OOHG_Messages( 12, 24, 1 ) ACTION ::PrintMode( ::cTempFile )                   TOOLTIP _OOHG_Messages( 12, 25, 1 ) + ::cPrintLibrary
            BUTTON but_5 CAPTION _OOHG_Messages( 12, 26 )    ACTION ::SearchString( print_preview.edit_p.Value ) TOOLTIP _OOHG_Messages( 12, 27 )
            BUTTON but_6 CAPTION _OOHG_Messages( 12, 28 )    ACTION ::NextSearch()                               TOOLTIP _OOHG_Messages( 12, 29 )
         END TOOLBAR
      END WINDOW

      CENTER WINDOW print_preview
      ACTIVATE WINDOW print_preview
   ELSE
      ::PrintMode( ::cTempFile )
   ENDIF

   IF File( ::cTempFile )
      FClose( nHandle )
      FErase( ::cTempFile )
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginPageX() CLASS TDOSPRINT

   @ 0, 0 SAY ""

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndPageX() CLASS TDOSPRINT

   EJECT

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintDataX( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, cText, lItalic, nAngle, lUnder, lStrike, nWidth ) CLASS TDOSPRINT

   HB_SYMBOL_UNUSED( uData )
   HB_SYMBOL_UNUSED( cFont )
   HB_SYMBOL_UNUSED( nSize )
   HB_SYMBOL_UNUSED( aColor )
   HB_SYMBOL_UNUSED( cAlign )
   HB_SYMBOL_UNUSED( nLen )
   HB_SYMBOL_UNUSED( lItalic )
   HB_SYMBOL_UNUSED( nAngle )
   HB_SYMBOL_UNUSED( lUnder )
   HB_SYMBOL_UNUSED( lStrike )
   HB_SYMBOL_UNUSED( nWidth )

   IF lBold
      @ nLin, nCol SAY ( cText )
      @ nLin, nCol SAY ( cText )
   ELSE
      @ nLin, nCol SAY ( cText )
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintLineX( nLin, nCol, nLinF, nColF, atColor, ntwPen ) CLASS TDOSPRINT

   HB_SYMBOL_UNUSED( atColor )
   HB_SYMBOL_UNUSED( ntwPen )

   IF nLin == nLinF
      @ nLin, nCol SAY Replicate( "-", nColF - nCol + 1 )
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD CondenDosX() CLASS TDOSPRINT

   @ PRow(), PCol() SAY Chr( 15 )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD NormalDosX() CLASS TDOSPRINT

   @ PRow(), PCol() SAY Chr( 18 )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION Zoom( cOp )

   IF cOp == "+" .AND. print_preview.edit_p.FontSize <= 24
      print_preview.edit_p.FontSize := print_preview.edit_p.FontSize + 2
   ENDIF

   IF cOp == "-" .AND. print_preview.edit_p.FontSize > 7
      print_preview.edit_p.FontSize := print_preview.edit_p.FontSize - 2
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SearchString( cTarget) CLASS TDOSPRINT

   print_preview.but_6.Enabled := .F.
   print_preview.edit_p.CaretPos := 1
   ::nOccur := 0
   ::cBusca := cTarget
   ::cString := ""
   ::cString := InputBox( _OOHG_Messages( 12, 30 ), _OOHG_Messages( 12, 31 ) )
   IF Empty( ::cString )
      RETURN NIL
   ENDIF
   print_preview.but_6.Enabled := .T.
   ::NextSearch()

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD NextSearch() CLASS TDOSPRINT

   LOCAL cString, nCaretPos

   cString := Upper( ::cString )
   nCaretPos := AtPlus( AllTrim( cString ), Upper( ::cBusca ), ::nOccur )
   ::nOccur := nCaretPos + 1

   print_preview.edit_p.SetFocus
   IF nCaretPos > 0
      print_preview.edit_p.CaretPos := nCaretPos
      print_preview.edit_p.Refresh
   ELSE
      print_preview.but_6.Enabled := .F.
      MsgInfo( _OOHG_Messages( 12, 32 ), _OOHG_Messages( 12, 33 ) )
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION AtPlus( cSearch, cAll, nStart )

   LOCAL i, nPos, nLencSearch, nLencAll, cUppercSearch

   nPos := 0
   nLencAll := Len( cAll )
   nLencSearch := Len( cSearch )
   cUppercSearch := Upper( cSearch )

   FOR i := nStart TO nLencAll
      IF Upper( SubStr( cAll, i, nLencSearch ) ) == cUppercSearch
         nPos := i
         EXIT
      ENDIF
   NEXT i

   RETURN nPos


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TTXTPRINT FROM TDOSPRINT

   DATA cBusca                    INIT ""                    READONLY
   DATA cString                   INIT ""                    READONLY
   DATA nOccur                    INIT 0                     READONLY

   METHOD BeginDocX
   METHOD EndDocX
   METHOD InitX
   METHOD PrintImage              BLOCK { || NIL }
   METHOD PrintModeX
   METHOD SelPrinterX
   METHOD SetDosPort              BLOCK { || NIL }
   METHOD SetPreviewSize          BLOCK { || NIL }
   /*
   TODO: Add METHOD PrintRectangleX using two horizontal lines and pairs of |
   */

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginDocX() CLASS TTXTPRINT

   ::cDocument := ParseName( ::Cargo, "txt" )
   SET PRINTER TO ( ::cTempFile )
   SET DEVICE TO PRINT

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndDocX() CLASS TTXTPRINT

   LOCAL nHandle, wr, nx, ny

   nx := GetDesktopWidth()
   ny := GetDesktopHeight()

   SET DEVICE TO SCREEN
   SET PRINTER TO

   nHandle := FOpen( ::cTempFile, 0 + 64 )

   IF ::ImPreview
      wr := MemoRead( ( ::cTempFile ) )

      DEFINE WINDOW print_preview  ;
         AT 0, 0 ;
         WIDTH nx HEIGHT ny - 70 - 40 ;
         TITLE _OOHG_Messages( 12, 17 ) + ::cTempFile + " " + ::cPrintLibrary ;
         MODAL

         @ 42, 0 RICHEDITBOX edit_p ;
            OF print_preview ;
            WIDTH nx - 5 ;
            HEIGHT ny - 40 - 70 - 70 ;
            VALUE wr ;
            READONLY ;
            FONT 'Courier New' ;
            SIZE 10 ;
            BACKCOLOR WHITE

         DEFINE TOOLBAR toolbr BUTTONSIZE 80, 20
            BUTTON but_4 CAPTION _OOHG_Messages( 12, 18 )    ACTION ( print_preview.Release() )                  TOOLTIP _OOHG_Messages( 12, 19 )
            BUTTON but_1 CAPTION _OOHG_Messages( 12, 20 )    ACTION Zoom( "+" )                                  TOOLTIP _OOHG_Messages( 12, 21 )
            BUTTON but_2 CAPTION _OOHG_Messages( 12, 22 )    ACTION Zoom( "-" )                                  TOOLTIP _OOHG_Messages( 12, 23 )
            BUTTON but_3 CAPTION _OOHG_Messages( 12, 24, 2 ) ACTION ::PrintMode( ::cTempFile )                   TOOLTIP _OOHG_Messages( 12, 25, 2 ) + ::cPrintLibrary
            BUTTON but_5 CAPTION _OOHG_Messages( 12, 26 )    ACTION ::SearchString( print_preview.edit_p.Value ) TOOLTIP _OOHG_Messages( 12, 27 )
            BUTTON but_6 CAPTION _OOHG_Messages( 12, 28 )    ACTION ::NextSearch()                               TOOLTIP _OOHG_Messages( 12, 29 )
         END TOOLBAR
      END WINDOW

      CENTER WINDOW print_preview
      ACTIVATE WINDOW print_preview
   ELSE
      ::PrintMode( ::cTempFile )
   ENDIF

   IF File( ::cTempFile )
      FClose( nHandle )
      FErase( ::cTempFile )
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InitX() CLASS TTXTPRINT

   ::cPrintLibrary := "TXTPRINT"

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintModeX( cFile ) CLASS TTXTPRINT

   IF HB_ISSTRING( cFile ) .AND. ! Empty( cFile )
      BEGIN SEQUENCE
         COPY FILE ( cFile ) TO ( ::cDocument )
      RECOVER
         // TODO: Add error message
      END SEQUENCE
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SelPrinterX( lSelect, lPreview, lLandscape, nPaperSize, cPrinterX, nRes, nBin, nDuplex, lCollate, nCopies, lColor, nScale, nPaperLength, nPaperWidth ) CLASS TTXTPRINT

   HB_SYMBOL_UNUSED( lSelect )
   HB_SYMBOL_UNUSED( lLandscape )
   HB_SYMBOL_UNUSED( nPaperSize )
   HB_SYMBOL_UNUSED( cPrinterX )
   HB_SYMBOL_UNUSED( nRes )
   HB_SYMBOL_UNUSED( nBin )
   HB_SYMBOL_UNUSED( nDuplex )
   HB_SYMBOL_UNUSED( lCollate )
   HB_SYMBOL_UNUSED( nCopies )
   HB_SYMBOL_UNUSED( lColor )
   HB_SYMBOL_UNUSED( nScale )
   HB_SYMBOL_UNUSED( nPaperLength )
   HB_SYMBOL_UNUSED( nPaperWidth )

   DEFAULT lPreview TO .T.
   ::ImPreview := lPreview

   ::cPrinter := "TXT"

   DO WHILE File( ::cTempFile )
      ::cTempFile := TEMP_FILE_NAME
   ENDDO

   RETURN Self


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TRAWPRINT FROM TDOSPRINT

   METHOD BeginDocX
   METHOD InitX
   METHOD PrintModeX
   METHOD SelPrinterX

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginDocX() CLASS TRAWPRINT

   ::Super:BeginDocX()
   ::cDocument := ParseName( ::Cargo, "raw" )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintModeX( cFile ) CLASS TRAWPRINT
// Based upon an example of Lucho Miranda (elsanes)

   LOCAL nResult, cMsg, aData

   IF HB_ISSTRING( cFile ) .AND. ! Empty( cFile )
      IF ::lSaveTemp
         BEGIN SEQUENCE
            COPY FILE ( cFile ) TO ( ::cDocument )
         RECOVER
            // TODO: Add error message
         END SEQUENCE
      ENDIF

      IF Empty( ::cPrinter )
         IF ::lShowErrors
            MsgStop( _OOHG_Messages( 12, 11 ), _OOHG_Messages( 12, 12 ) )
         ENDIF
         RETURN NIL
      ENDIF

      nResult := PrintFileRaw( ::cPrinter, cFile, "raw print" )
      hb_idleSleep( 1 )

      IF nResult # 1
         IF ::lShowErrors
            aData := { {  1, cFile + _OOHG_Messages( 12, 4 ) }, ;
                       { -1, _OOHG_Messages( 12, 5 ) }, ;
                       { -2, _OOHG_Messages( 12, 6 ) }, ;
                       { -3, _OOHG_Messages( 12, 7 ) }, ;
                       { -4, _OOHG_Messages( 12, 8 ) }, ;
                       { -5, _OOHG_Messages( 12, 9 ) }, ;
                       { -6, cFile + _OOHG_Messages( 12, 10 ) } }
            cMsg := aData[ AScan( aData, { | x | x[ 1 ] == nResult } ), 2 ]
            MsgStop( cMsg, _OOHG_Messages( 12, 12 ) )
         ENDIF
         RETURN NIL
      ENDIF
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InitX() CLASS TRAWPRINT

   ::cPrintLibrary := "RAWPRINT"

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SelPrinterX( lSelect, lPreview, lLandscape, nPaperSize, cPrinterX, nRes, nBin, nDuplex, lCollate, nCopies, lColor, nScale, nPaperLength, nPaperWidth ) CLASS TRAWPRINT

   HB_SYMBOL_UNUSED( lPreview )
   HB_SYMBOL_UNUSED( lLandscape )
   HB_SYMBOL_UNUSED( nPaperSize )
   HB_SYMBOL_UNUSED( nRes )
   HB_SYMBOL_UNUSED( nBin )
   HB_SYMBOL_UNUSED( nDuplex )
   HB_SYMBOL_UNUSED( lCollate )
   HB_SYMBOL_UNUSED( nCopies )
   HB_SYMBOL_UNUSED( lColor )
   HB_SYMBOL_UNUSED( nScale )
   HB_SYMBOL_UNUSED( nPaperLength )
   HB_SYMBOL_UNUSED( nPaperWidth )

   ::ImPreview := .F.

   DO WHILE File( ::cTempFile )
      ::cTempFile := TEMP_FILE_NAME
   ENDDO

   IF lSelect
      ::cPrinter := ""
      ::aPrinters := ASort( aPrinters() )

      DEFINE WINDOW myselprinter  ;
         AT 0, 0 ;
         WIDTH 345 ;
         HEIGHT GetTitleHeight() + 100 ;
         TITLE _OOHG_Messages( 12, 14 ) ;
         MODAL ;
         NOSIZE

         @ 15, 10 COMBOBOX combo_1 ITEMS ::aPrinters VALUE AScan( ::aPrinters, GetDefaultPrinter() ) WIDTH 320

         @ 53, 65 BUTTON ok CAPTION _OOHG_Messages( 12, 15 ) ACTION ( ::cPrinter := myselprinter.combo_1.Item( myselprinter.combo_1.Value ), myselprinter.Release() )
         @ 53, 175 BUTTON cancel CAPTION _OOHG_Messages( 12, 16 ) ACTION ( ::lPrError := .T., myselprinter.Release() )
      END WINDOW

      CENTER WINDOW myselprinter
      myselprinter.ok.SetFocus()
      ACTIVATE WINDOW myselprinter
   ELSE
      IF Empty( cPrinterX )
         ::cPrinter := GetDefaultPrinter()
      ELSE
         ::cPrinter := cPrinterX
      ENDIF
   ENDIF

   RETURN Self


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TEXCELPRINT FROM TPRINTBASE
// Based upon a contribution of Jose Miguel josemisu@yahoo.com.ar

   DATA oExcel                    INIT NIL                   READONLY
   DATA oBook                     INIT NIL                   READONLY
   DATA oHoja                     INIT NIL                   READONLY

   METHOD BeginDocX
   METHOD BeginPageX
   METHOD EndDocX
   METHOD EndPageX
   METHOD InitX
   METHOD MaxCol                  INLINE iif( HB_ISOBJECT( ::oHoja ), ::oHoja:Columns:Count, 0 )
   METHOD MaxRow                  INLINE iif( HB_ISOBJECT( ::oHoja ), ::oHoja:Rows:Count, 0 )
   METHOD PrintDataX
   METHOD PrintImageX
   METHOD ReleaseX
   METHOD SelPrinterX             BLOCK { |Self| ::cPrinter := "EXCEL" }
   METHOD SetPreviewSize          BLOCK { || NIL }
   /*
   TODO: Add METHOD PrintLineX using cell borders.
   TODO: Add METHOD PrintRectangleX using cell borders.
   TODO: Add support for "printing" in multiple cells.
   TODO: Add SelPrinterX to open a dialog to select file.
   */

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InitX() CLASS TEXCELPRINT

   ::cPrintLibrary := "EXCELPRINT"

   #ifndef __XHARBOUR__
   IF ( ::oExcel := win_oleCreateObject( "Excel.Application" ) ) == NIL
   #else
   ::oExcel := TOleAuto():New( "Excel.Application" )
   IF Ole2TxtError() != 'S_OK'
   #endif
      IF ::lShowErrors
         MsgStop( _OOHG_Messages( 12, 34 ), _OOHG_Messages( 12, 12 ) )
      ENDIF
      ::lPrError := .T.
      ::Exit := .T.
      RETURN NIL
   ENDIF
   ::oExcel:Visible := .F.
   ::oExcel:DisplayAlerts :=.F.

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginDocX() CLASS TEXCELPRINT

   LOCAL nBefore

   ::cDocument := ParseName( ::Cargo, iif( Val( ::oExcel:Version ) > 11.5, "xlsx", "xls" ) )

   nBefore := ::oExcel:SheetsInNewWorkbook
   ::oExcel:SheetsInNewWorkbook := 1
   ::oBook := ::oExcel:WorkBooks:Add()
   ::oExcel:SheetsInNewWorkbook := nBefore

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginPageX() CLASS TEXCELPRINT

   ::oHoja := ::oBook:ActiveSheet()
   IF ::lSeparateSheets
      ::oHoja:Name := ::cPageName
      ::oHoja:Cells:Font:Name := ::cFontName
      ::oHoja:Cells:Font:Size := ::nFontSize
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndDocX() CLASS TEXCELPRINT

   LOCAL nCol, bErrorBlock, uRet := Self

   IF ::lSeparateSheets
      ::oHoja:Delete()
      ::oHoja := ::oBook:Sheets( 1 ):Select()
   ELSE
      FOR nCol := 1 TO ::oHoja:UsedRange:Columns:Count()
         ::oHoja:Columns( nCol ):AutoFit()
      NEXT
   ENDIF
   ::oHoja:Cells( 1, 1 ):Select()
   ::oHoja := NIL

   bErrorBlock := ErrorBlock( { | x | Break( x ) } )
   BEGIN SEQUENCE
      ::oBook:SaveAs( ::cDocument )
      hb_idleSleep( 1 )
   RECOVER
      IF ::lShowErrors
         MsgStop( _OOHG_Messages( 12, 45 ) + Chr( 13 ) + ::cDocument, _OOHG_Messages( 12, 12 ) )
      ENDIF
      uRet := NIL
   END SEQUENCE
   ErrorBlock( bErrorBlock )

   ::oBook:Close( .F. )
   ::oBook := NIL

   IF uRet # NIL .AND. ::ImPreview
      IF ShellExecute( 0, "open", "rundll32.exe", "url.dll,FileProtocolHandler " + ::cDocument, , 1) <= 32
         IF ::lShowErrors
            MsgStop( _OOHG_Messages( 12, 35 ) + Chr( 13 ) + Chr( 13 ) + _OOHG_Messages( 12, 36 ) + Chr( 13 ) + ::cDocument, _OOHG_Messages( 12, 12 ) )
         ENDIF
         uRet := NIL
      ENDIF
   ENDIF

   RETURN uRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ReleaseX() CLASS TEXCELPRINT

   LOCAL bErrorBlock := ErrorBlock( { | x | Break( x ) } )

   BEGIN SEQUENCE
      IF ::oBook # NIL
         ::oBook:Close( .F. )
      ENDIF
      IF ::oExcel # NIL
         ::oExcel:Quit()
      ENDIF
   END SEQUENCE
   ErrorBlock( bErrorBlock )
   ::oHoja := NIL
   ::oBook := NIL
   ::oExcel := NIL

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintImageX( nLin, nCol, nLinF, nColF, cImage, aResol, aSize ) CLASS TEXCELPRINT

   LOCAL cLin, cRange

   HB_SYMBOL_UNUSED( nLinF )
   HB_SYMBOL_UNUSED( aResol )
   HB_SYMBOL_UNUSED( aSize )

   IF nLin < 1
      nLin := 1
   ENDIF
   IF nCol < 1
      nCol := 1
   ENDIF
   nLin++
   IF ::nUnitsLin > 1
      nLin := Round( nLin / ::nUnitsLin, 0 )
      nCol := Round( nCol / ::nUnitsLin, 0 )
   ENDIF
   /*
   TODO: Add support for images in the resource file (copy them to a temp file)
   */

   nColF := nLin
   cLin := AllTrim( Str( nLin ) )
   cRange := "A" + cLin
   ::oHoja:Range( cRange ):Select()
   IF At( '\', cImage ) == 0
      cImage := GetCurrentFolder() + '\' + cImage
   ENDIF
   ::oHoja:Pictures:Insert( cImage )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintDataX( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, cText, lItalic, nAngle, lUnder, lStrike, nWidth ) CLASS TEXCELPRINT

   /*
   TODO: Add an aCargo array of {property, value} to apply to the cell
   */

   LOCAL aLinCellX

   HB_SYMBOL_UNUSED( uData )
   HB_SYMBOL_UNUSED( nLen )
   HB_SYMBOL_UNUSED( nWidth )

   nLin++
   IF ::nUnitsLin > 1
      nLin := Round( nLin / ::nUnitsLin, 0 )
   ENDIF
   nLin := nLin + ::nLinPag
   IF Len( ::aLinCelda ) < nLin
      DO WHILE Len( ::aLinCelda ) < nLin
         AAdd( ::aLinCelda, 0 )
      ENDDO
   ENDIF
   ::aLinCelda[ nLin ] := ::aLinCelda[ nLin ] + 1
   aLinCellX := ::aLinCelda[ nLin ]

   ::oHoja:Cells( nLin, aLinCellX ):Value := "'" + Space( nCol ) + cText

   IF cFont # ::cFontName
      ::oHoja:Cells( nLin, aLinCellX ):Font:Name := cFont
   ENDIF
   IF nSize # ::nFontSize
      ::oHoja:Cells( nLin, aLinCellX ):Font:Size := nSize
   ENDIF
   IF lBold
      ::oHoja:Cells( nLin, aLinCellX ):Font:Bold := lBold
   ENDIF
   IF lItalic
      ::oHoja:Cells( nLin, aLinCellX ):Font:Italic := lItalic
   ENDIF
   DO CASE
   CASE cAlign == "R"
      ::oHoja:Cells( nLin, aLinCellX ):HorizontalAlignment := -4152  // Right
   CASE cAlign == "C"
      ::oHoja:Cells( nLin, aLinCellX ):HorizontalAlignment := -4108  // Center
   ENDCASE
   ::oHoja:Cells( nLin, aLinCellX ):Font:Color := RGB( aColor[ 3 ], aColor[ 2 ], aColor[ 1 ] )
   ::oHoja:Cells( nLin, aLinCellX ):Orientation := nAngle
   /*
      Orientation valid values are:
      -90 <= nAngle <= 90
      xlDownward   -4170 Text runs from top to bottom (each
                         character is rotated -90 degrees).
      xlHorizontal -4128 Text runs horizontally.
      xlUpward     -4171 Text runs from bottom to top (each
                         character is rotated 90 degrees).
      xlVertical   -4166 Text runs from top to bottom (but
                         characters are not rotated).
   */
   ::oHoja:Cells( nLin, aLinCellX ):Font:Underline := iif( lUnder, 2, -4142 )  // xlUnderlineStyleSingle , xlUnderlineStyleNone
   ::oHoja:Cells( nLin, aLinCellX ):Font:StrikeThrough := lStrike

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndPageX() CLASS TEXCELPRINT

   LOCAL nCol

   IF ::lSeparateSheets
      FOR nCol := 1 TO ::oHoja:UsedRange:Columns:Count()
         ::oHoja:Columns( nCol ):AutoFit()
      NEXT
      ::oHoja := ::oBook:Sheets:Add()
      ::nLinPag := 0
   ELSE
      ::nLinPag := Len( ::aLinCelda ) + 1
   ENDIF
   ::aLinCelda := {}

   RETURN Self


// Label Header
#define TXT_ELEMS  12
#define TXT_OPCO1   1
#define TXT_OPCO2   2
#define TXT_LEN1    3
#define TXT_LEN2    4
#define TXT_ROW1    5
#define TXT_ROW2    6
#define TXT_COL1    7
#define TXT_COL2    8
#define TXT_RGBAT1  9
#define TXT_RGBAT2 10
#define TXT_RGBAT3 11
#define TXT_LEN    12

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TSPREADSHEETPRINT FROM TPRINTBASE

   DATA aDoc                      INIT {}                    READONLY
   DATA nLinRel                   INIT 0                     READONLY
   DATA nLpp                      INIT 60                    READONLY    // lines per page
   DATA nXls                      INIT 0                     READONLY

   METHOD AddPage
   METHOD BeginDocX
   METHOD EndDocX
   METHOD EndPageX
   METHOD InitX
   METHOD PrintDataX
   METHOD PrintImage              BLOCK { || NIL }
   METHOD ReleaseX
   METHOD SelPrinterX             BLOCK { |Self| ::cPrinter := "BIFF" }
   METHOD SetPreviewSize          BLOCK { || NIL }
   /*
   TODO: Add SelPrinterX to open a dialog to select file.
   */

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InitX() CLASS TSPREADSHEETPRINT

   ::cPrintLibrary := "SPREADSHEETPRINT"

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD AddPage()

   LOCAL i

   FOR i := 1 TO ::nLpp
      AAdd( ::aDoc, Space( 300 ) )
   NEXT i

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginDocX() CLASS TSPREADSHEETPRINT

   LOCAL cBof := Chr( 9 ) + Chr( 0 ) + Chr( 4 ) + Chr( 0 ) + Chr( 2 ) + Chr( 0 ) + Chr( 10 ) + Chr( 0 )

   ::cDocument := ParseName( ::Cargo, "xls" )
   ::nXls := FCreate( ::cDocument )
   FWrite( ::nXls, cBof, Len( cBof ) )
   ::AddPage()

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndDocX() CLASS TSPREADSHEETPRINT

   LOCAL i, anHeader, nLen, nI, cEof

   FOR i := 1 TO Len( ::aDoc )
     // This array holds the record marker
     anHeader := Array( TXT_ELEMS )
     anHeader[ TXT_OPCO1 ]  :=  4
     anHeader[ TXT_OPCO2 ]  :=  0
     anHeader[ TXT_LEN1 ]   := 10
     anHeader[ TXT_LEN2 ]   :=  0
     anHeader[ TXT_ROW2 ]   :=  0
     anHeader[ TXT_COL2 ]   :=  0
     anHeader[ TXT_RGBAT1 ] :=  0
     anHeader[ TXT_RGBAT2 ] :=  0
     anHeader[ TXT_RGBAT3 ] :=  0
     anHeader[ TXT_LEN ]    :=  2

     nLen := Len( RTrim( ::aDoc[ i ] ) )

     // Length of the text to write
     anHeader[ TXT_LEN ]    := nLen

     // Record length
     anHeader[ TXT_LEN1 ]   := 8 + nLen

     // BIFF format starts from zero
     // Passed data starts from one
     nI                     := i - 1
     anHeader[ TXT_ROW1 ]   := nI - ( Int( nI / 256 ) * 256 )
     anHeader[ TXT_ROW2 ]   := Int( nI / 256 )
     anHeader[ TXT_COL1 ]   := 1 - 1

     // Write header
     AEval( anHeader, { | v | FWrite( ::nXls, Chr( v ), 1 ) } )

     // Write data
     FOR nI := 1 TO nLen
       FWrite( ::nXls, SubStr( RTrim( ::aDoc[ i ] ), nI, 1 ), 1 )
     NEXT nI
   NEXT i

   cEof := Chr( 10 ) + Chr( 0 ) + Chr( 0 ) + Chr( 0 )

   FWrite( ::nXls, cEof, Len( cEof ) )
   FClose( ::nXls )

   IF ::ImPreview
      IF ShellExecute( 0, "open", "rundll32.exe", "url.dll,FileProtocolHandler " + ::cDocument, , 1) <= 32
         IF ::lShowErrors
            MsgStop( _OOHG_Messages( 12, 35 ) + Chr( 13 ) + Chr( 13 ) + _OOHG_Messages( 12, 36 ) + Chr( 13 ) + ::cDocument, _OOHG_Messages( 12, 12 ) )
         ENDIF
         RETURN NIL
      ENDIF
   ENDIF
   ::aDoc := {}

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ReleaseX() CLASS TSPREADSHEETPRINT

   Release( ::nXls )           // Do not wait for garbage collector

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintDataX( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, cText, lItalic, nAngle, lUnder, lStrike, nWidth ) CLASS TSPREADSHEETPRINT

   LOCAL cLineI, cLineF

   HB_SYMBOL_UNUSED( cFont )
   HB_SYMBOL_UNUSED( nSize )
   HB_SYMBOL_UNUSED( lBold )
   HB_SYMBOL_UNUSED( aColor )
   HB_SYMBOL_UNUSED( cAlign )
   HB_SYMBOL_UNUSED( nLen )
   HB_SYMBOL_UNUSED( cText )
   HB_SYMBOL_UNUSED( lItalic )
   HB_SYMBOL_UNUSED( nAngle )
   HB_SYMBOL_UNUSED( lUnder )
   HB_SYMBOL_UNUSED( lStrike )
   HB_SYMBOL_UNUSED( nWidth )

   nLin++
   uData := AutoType( uData )
   cLineI := ::aDoc[ nLin + ::nLinRel ]
   cLineF := Stuff( cLineI, nCol, Len( uData ), uData )
   ::aDoc[ nLin + ::nLinRel ]:= cLineF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndPageX() CLASS TSPREADSHEETPRINT

   ::nLinRel := ::nLinRel + ::nLpp
   ::AddPage()

   RETURN Self


/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION THtmlPrint
// CLASS THTMLPRINT

   LOCAL oBase, lError

   // Try Excel
   oBase := TExcelPrint()
   oBase:SetShowErrors( .F. )
   oBase:Init()
   lError := oBase:lPrError
   oBase:Release()
   IF lError
      // Try Calc
      oBase := TCalcPrint()
      oBase:SetShowErrors( .F. )
      oBase:Init()
      lError := oBase:lPrError
      oBase:Release()

      IF ! lError
         RETURN THtmlPrintFromCalc()
      ENDIF
   ENDIF

   RETURN THtmlPrintFromExcel()
   // ENDCLASS


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS THTMLPRINTFROMEXCEL FROM TEXCELPRINT

   METHOD BeginDocX
   METHOD EndDocX
   METHOD InitX

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginDocX() CLASS THTMLPRINTFROMEXCEL

   ::Super:BeginDocX()
   ::cDocument := ParseName( ::Cargo, "html" )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndDocX() CLASS THTMLPRINTFROMEXCEL

   LOCAL nCol, bErrorBlock, uRet := Self

   IF ::lSeparateSheets
      ::oHoja:Delete()
      ::oHoja := ::oBook:Sheets( 1 ):Select()
   ELSE
      FOR nCol := 1 TO ::oHoja:UsedRange:Columns:Count()
         ::oHoja:Columns( nCol ):AutoFit()
      NEXT
   ENDIF
   ::oHoja:Cells( 1, 1 ):Select()
   ::oHoja := NIL

   bErrorBlock := ErrorBlock( { | x | Break( x ) } )
   BEGIN SEQUENCE
      ::oHoja:SaveAs( ::cDocument, 44, "", "", .F., .F. )
      hb_idleSleep( 1 )
   RECOVER
      IF ::lShowErrors
         MsgStop( _OOHG_Messages( 12, 45 ) + Chr( 13 ) + ::cDocument, _OOHG_Messages( 12, 12 ) )
      ENDIF
      uRet := NIL
   END SEQUENCE
   ErrorBlock( bErrorBlock )

   ::oBook:Close( .F. )
   ::oBook := NIL

   IF uRet # NIL .AND. ::ImPreview
      IF ShellExecute( 0, "open", "rundll32.exe", "url.dll,FileProtocolHandler " + ::cDocument, , 1) <= 32
         IF ::lShowErrors
            MsgStop( _OOHG_Messages( 12, 37 ) + Chr( 13 ) + Chr( 13 ) + _OOHG_Messages( 12, 36 ) + Chr( 13 ) + ::cDocument, _OOHG_Messages( 12, 12 ) )
         ENDIF
         uRet := NIL
      ENDIF
   ENDIF

   RETURN uRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InitX() CLASS THTMLPRINTFROMEXCEL

   ::Super:InitX()
   ::cPrintLibrary := "HTMLPRINTFROMEXCEL"

   RETURN Self


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS THTMLPRINTFROMCALC FROM TCALCPRINT

   METHOD BeginDocX
   METHOD EndDocX
   METHOD InitX

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginDocX() CLASS THTMLPRINTFROMCALC

   ::Super:BeginDocX()
   ::cDocument := ParseName( ::Cargo, "html" )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndDocX() CLASS THTMLPRINTFROMCALC

   LOCAL bErrorBlock, uRet := Self, oPropertyValue

   IF ::lSeparateSheets
      ::oDocument:Sheets:RemoveByName( ::oSheet:Name )
      ::oSheet := ::oDocument:Sheets:GetByIndex( 0 )
   ELSE
      ::oSheet:GetColumns():SetPropertyValue( "OptimalWidth", .T. )
   ENDIF
   ::oDocument:GetCurrentController:SetActiveSheet( ::oSheet )
   ::oDocument:GetCurrentController:Select( ::oSheet:GetCellByPosition( 0, 0 ) )
   ::oCell := NIL
   ::oSheet := NIL
   ::oSchedule := NIL

   bErrorBlock := ErrorBlock( { | x | Break( x ) } )
   BEGIN SEQUENCE
      oPropertyValue := ::oServiceManager:Bridge_GetStruct( "com.sun.star.beans.PropertyValue" )
      oPropertyValue:Name := "FilterName"
      oPropertyValue:Value := "HTML (StarCalc)"
      ::oDocument:StoreToURL( OO_ConvertToURL( ::cDocument ), {oPropertyValue} )
      hb_idleSleep( 1 )
   RECOVER
      IF ::lShowErrors
         MsgStop( _OOHG_Messages( 12, 45 ) + Chr( 13 ) + ::cDocument, _OOHG_Messages( 12, 12 ) )
      ENDIF
      uRet := NIL
   END SEQUENCE
   ErrorBlock( bErrorBlock )

   ::oDocument:Close( 1 )
   ::oDocument := NIL

   IF uRet # NIL .AND. ::ImPreview
      IF ShellExecute( 0, "open", "rundll32.exe", "url.dll,FileProtocolHandler " + ::cDocument, , 1) <= 32
         IF ::lShowErrors
            MsgStop( _OOHG_Messages( 12, 37 ) + Chr( 13 ) + Chr( 13 ) + _OOHG_Messages( 12, 36 ) + Chr( 13 ) + ::cDocument, _OOHG_Messages( 12, 12 ) )
         ENDIF
         uRet := NIL
      ENDIF
   ENDIF

   RETURN uRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InitX() CLASS THTMLPRINTFROMCALC

   ::Super:InitX()
   ::cPrintLibrary := "HTMLPRINTFROMCALC"

   RETURN Self


#define RTF_FONT_TABLE  2
#define RTF_COLOR_TABLE 3

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TRTFPRINT FROM TPRINTBASE

   DATA aPrintRtf                 INIT {}                    READONLY    // Document lines
   DATA nPrintRtf                 INIT 0                     READONLY    // Last font size used
   DATA nFontSize                 INIT 10                    READONLY    // In TPRINTBASE is 12
   DATA nMarginLef                INIT 10                    READONLY    // in mm
   DATA nMarginSup                INIT 15                    READONLY    // in mm
   DATA nMarginRig                INIT 10                    READONLY    // in mm
   DATA nMarginInf                INIT 15                    READONLY    // in mm

   METHOD BeginDocX
   METHOD EndDocX
   METHOD EndPageX
   METHOD InitX
   METHOD PrintDataX
   METHOD PrintImage              BLOCK { || NIL }
   METHOD PrintLineX
   METHOD SelPrinterX
   METHOD SetCpl
   METHOD SetPageMargins
   METHOD SetPreviewSize          BLOCK { || NIL }
   /*
   TODO: Add BeginPageX
   TODO: Add SetFontX to change default font, adding it
         to the font table if is not included (only if
         the font table is already initialized).
   */

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InitX() CLASS TRTFPRINT

   ::cPrintLibrary := "RTFPRINT"

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetCpl( nCpl ) CLASS TRTFPRINT

   DEFAULT nCpl to 96
   DO CASE
   CASE nCpl == 60
      ::nFontSize := 14
   CASE nCpl == 80
      ::nFontSize := 12
   CASE nCpl == 96
      ::nFontSize := 10
   CASE nCpl == 120
      ::nFontSize := 8
   CASE nCpl == 140
      ::nFontSize := 7
   CASE nCpl == 160
      ::nFontSize := 6
   OTHERWISE
      ::nFontSize := 10   // TPRINTBASE defaults to 12
   ENDCASE

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetPageMargins( nMarginLef, nMarginSup, nMarginRig, nMarginInf) CLASS TRTFPRINT

   IF nMarginLef # NIL
      ::nMarginLef := nMarginLef
   ENDIF
   IF nMarginSup # NIL
      ::nMarginSup := nMarginSup
   ENDIF
   IF nMarginRig # NIL
      ::nMarginRig := nMarginRig
   ENDIF
   IF nMarginInf # NIL
      ::nMarginInf := nMarginInf
   ENDIF

   RETURN { ::nMarginLef, ::nMarginSup, ::nMarginRig, ::nMarginInf }

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginDocX() CLASS TRTFPRINT

   LOCAL cMarginSup := LTrim( Str( Round( ::nMarginSup * 56.7, 0 ) ) )          // mm to twips
   LOCAL cMarginInf := LTrim( Str( Round( ::nMarginInf * 56.7, 0 ) ) )
   LOCAL cMarginLef := LTrim( Str( Round( ::nMarginLef * 56.7, 0 ) ) )
   LOCAL cMarginRig := LTrim( Str( Round( ::nMarginRig * 56.7, 0 ) ) )

   ::cDocument := ParseName( ::Cargo, "rtf" )

   // Document header
   AAdd( ::aPrintRtf, "{\rtf1\ansi\ansicpg1252\uc1 \deff0\deflang3082\deflangfe3082" )
   // Font table start
   // If you insert a new font in the document's font table please add it also to array aFontTable in Method PrinDataX
   /*
   TODO: Add to font table all fonts defined by ::SetFontX()
   */
   AAdd( ::aPrintRtf, "{\fonttbl" )
   // Default font for MM
   ::aPrintRtf[ RTF_FONT_TABLE ] += "{\f0\froman\fcharset0\fprq2{\*\panose 02020603050405020304}Times New Roman;}"
   // Default font for ROWCOL, must be monospaced
   ::aPrintRtf[ RTF_FONT_TABLE ] += "{\f2\fmodern\fcharset0\fprq1{\*\panose 02070309020205020404}Courier New;}"
   // Aditional fonts
   ::aPrintRtf[ RTF_FONT_TABLE ] += "{\f106\froman\fcharset238\fprq2 Times New Roman CE;}"
   ::aPrintRtf[ RTF_FONT_TABLE ] += "{\f107\froman\fcharset204\fprq2 Times New Roman Cyr;}"
   ::aPrintRtf[ RTF_FONT_TABLE ] += "{\f109\froman\fcharset161\fprq2 Times New Roman Greek;}"
   ::aPrintRtf[ RTF_FONT_TABLE ] += "{\f110\froman\fcharset162\fprq2 Times New Roman Tur;}"
   ::aPrintRtf[ RTF_FONT_TABLE ] += "{\f111\froman\fcharset177\fprq2 Times New Roman (Hebrew);}"
   ::aPrintRtf[ RTF_FONT_TABLE ] += "{\f112\froman\fcharset178\fprq2 Times New Roman (Arabic);}"
   ::aPrintRtf[ RTF_FONT_TABLE ] += "{\f113\froman\fcharset186\fprq2 Times New Roman Baltic;}"
   ::aPrintRtf[ RTF_FONT_TABLE ] += "{\f122\fmodern\fcharset238\fprq1 Courier New CE;}"
   ::aPrintRtf[ RTF_FONT_TABLE ] += "{\f123\fmodern\fcharset204\fprq1 Courier New Cyr;}"
   ::aPrintRtf[ RTF_FONT_TABLE ] += "{\f125\fmodern\fcharset161\fprq1 Courier New Greek;}"
   ::aPrintRtf[ RTF_FONT_TABLE ] += "{\f126\fmodern\fcharset162\fprq1 Courier New Tur;}"
   ::aPrintRtf[ RTF_FONT_TABLE ] += "{\f127\fmodern\fcharset177\fprq1 Courier New (Hebrew);}"
   ::aPrintRtf[ RTF_FONT_TABLE ] += "{\f128\fmodern\fcharset178\fprq1 Courier New (Arabic);}"
   ::aPrintRtf[ RTF_FONT_TABLE ] += "{\f129\fmodern\fcharset186\fprq1 Courier New Baltic;}"
   // Font table end
   ::aPrintRtf[ RTF_FONT_TABLE ] += "}"
   // Color table start, defines {0,0,0} as "auto" color
   AAdd( ::aPrintRtf, "{\colortbl;" )
   // Colors
   ::aPrintRtf[ RTF_COLOR_TABLE ] += "\red0\green0\blue0;"
   ::aPrintRtf[ RTF_COLOR_TABLE ] += "\red0\green0\blue255;"
   ::aPrintRtf[ RTF_COLOR_TABLE ] += "\red0\green255\blue255;"
   ::aPrintRtf[ RTF_COLOR_TABLE ] += "\red0\green255\blue0;"
   ::aPrintRtf[ RTF_COLOR_TABLE ] += "\red255\green0\blue255;"
   ::aPrintRtf[ RTF_COLOR_TABLE ] += "\red255\green0\blue0;"
   ::aPrintRtf[ RTF_COLOR_TABLE ] += "\red255\green255\blue0;"
   ::aPrintRtf[ RTF_COLOR_TABLE ] += "\red255\green255\blue255;"
   ::aPrintRtf[ RTF_COLOR_TABLE ] += "\red0\green0\blue128;"
   ::aPrintRtf[ RTF_COLOR_TABLE ] += "\red0\green128\blue128;"
   ::aPrintRtf[ RTF_COLOR_TABLE ] += "\red0\green128\blue0;"
   ::aPrintRtf[ RTF_COLOR_TABLE ] += "\red128\green0\blue128;"
   ::aPrintRtf[ RTF_COLOR_TABLE ] += "\red128\green0\blue0;"
   ::aPrintRtf[ RTF_COLOR_TABLE ] += "\red128\green128\blue0;"
   ::aPrintRtf[ RTF_COLOR_TABLE ] += "\red128\green128\blue128;"
   ::aPrintRtf[ RTF_COLOR_TABLE ] += "\red192\green192\blue192;"
   // Color table end
   ::aPrintRtf[ RTF_COLOR_TABLE ] += "}"
   // StyleSheet
   AAdd( ::aPrintRtf, "{\stylesheet{\ql \li0\ri0\widctlpar\faauto\adjustright\rin0\lin0\itap0 \fs" + ltrim(str(::nFontSize * 2)) + "\lang3082\langfe3082\cgrid\langnp3082\langfenp3082 \snext0 Normal;}{\*\cs10 \additive Default Paragraph Font;}}" )
   // Information group
   /*
   TODO: customize
   */
   AAdd( ::aPrintRtf, "{\info{\author nobody }{\operator Jose Miguel}{\creatim\yr2000\mo12\dy29\hr17\min26}{\revtim\yr2002\mo3\dy6\hr9\min32}{\printim\yr2002\mo3\dy4\hr16\min32}{\version10}{\edmins16}{\nofpages1}{\nofwords167}{\nofchars954}{\*\company xyz}{\nofcharsws0}{\vern8249}}" )
   // Paper orientation
   AAdd( ::aPrintRtf, iif( ::lLandscape, "\paperw16840\paperh11907", "\paperw11907\paperh16840" ) )
   // Margins
   AAdd( ::aPrintRtf, "\margl" + cMarginLef + "\margr" + cMarginRig + "\margt" + cMarginSup + "\margb" + cMarginInf )
   // Other document formatting properties
   AAdd( ::aPrintRtf, " \widowctrl\ftnbj\aenddoc\hyphhotz425\noxlattoyen\expshrtn\noultrlspc\dntblnsbdb\nospaceforul\hyphcaps0\horzdoc\dghspace120\dgvspace120\dghorigin1701\dgvorigin1984\dghshow0\dgvshow3" )
   AAdd( ::aPrintRtf, "\jcompress\viewkind1\viewscale80\nolnhtadjtbl \fet0\sectd \psz9\linex0\headery851\footery851\colsx709\sectdefaultcl {\*\pnseclvl1\pnucrm\pnstart1\pnindent720\pnhang{\pntxta .}}{\*\pnseclvl2\pnucltr\pnstart1\pnindent720\pnhang{\pntxta .}}" )
   AAdd( ::aPrintRtf, "{\*\pnseclvl3\pndec\pnstart1\pnindent720\pnhang{\pntxta .}}{\*\pnseclvl4\pnlcltr\pnstart1\pnindent720\pnhang{\pntxta )}}{\*\pnseclvl5\pndec\pnstart1\pnindent720\pnhang{\pntxtb (}{\pntxta )}}{\*\pnseclvl6\pnlcltr\pnstart1\pnindent720\pnhang{\pntxtb (}{\pntxta )}}" )
   AAdd( ::aPrintRtf, "{\*\pnseclvl7\pnlcrm\pnstart1\pnindent720\pnhang{\pntxtb (}{\pntxta )}}{\*\pnseclvl8\pnlcltr\pnstart1\pnindent720\pnhang{\pntxtb (}{\pntxta )}}{\*\pnseclvl9\pnlcrm\pnstart1\pnindent720\pnhang{\pntxtb (}{\pntxta )}}" )
   // First paragraph start
   AAdd( ::aPrintRtf, "\pard\plain \qj \li0\ri0\nowidctlpar\faauto\adjustright\rin0\lin0\itap0 \fs" + ltrim(str(::nFontSize * 2)) + "\lang3082\langfe3082\cgrid\langnp3082\langfenp3082" )
   IF ::cUnits == "MM"
      AAdd( ::aPrintRtf, "{\f0\lang1034\langfe3082\cgrid0\langnp1034" )
   ELSE
      AAdd( ::aPrintRtf, "{\f2\lang1034\langfe3082\cgrid0\langnp1034" )
   ENDIF
   ::nPrintRtf := ::nFontSize

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndDocX() CLASS TRTFPRINT

   LOCAL i, bErrorBlock, uRet := Self

   IF RIGHT( ::aPrintRtf[ Len( ::aPrintRtf ) ], 6) == " \page"
      ::aPrintRtf[ Len( ::aPrintRtf ) ] := Left( ::aPrintRtf[ Len( ::aPrintRtf ) ], Len( ::aPrintRtf[ Len( ::aPrintRtf ) ] ) - 6 )
   ENDIF
   AAdd( ::aPrintRtf, "\par }}" )

   bErrorBlock := ErrorBlock( { | x | Break( x ) } )
   BEGIN SEQUENCE
      SET PRINTER TO ( ::cDocument )
      SET DEVICE TO PRINTER
      SetPRC( 0, 0 )
      FOR i := 1 TO Len( ::aPrintRtf )
         @ PRow(), PCol() SAY ::aPrintRtf[ i ]
         @ PRow() + 1, 0 SAY ""
      NEXT
      SET DEVICE TO SCREEN
      SET PRINTER TO
      IF ::ImPreview
         IF ShellExecute( 0, "open", "rundll32.exe", "url.dll,FileProtocolHandler " + ::cDocument, , 1 ) <= 32
            IF ::lShowErrors
               MsgStop( _OOHG_Messages( 12, 38 ) + Chr( 13 ) + Chr( 13 ) + _OOHG_Messages( 12, 36 ) + Chr( 13 ) + ::cDocument, _OOHG_Messages( 12, 12 ) )
            ENDIF
            uRet := NIL
         ENDIF
      ENDIF
   RECOVER
      IF ::lShowErrors
         MsgStop( _OOHG_Messages( 12, 45 ) + Chr( 13 ) + ::cDocument, _OOHG_Messages( 12, 12 ) )
      ENDIF
      uRet := NIL
   END SEQUENCE
   ErrorBlock( bErrorBlock )

   ::aPrintRtf := {}

   RETURN uRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndPageX() CLASS TRTFPRINT

   LOCAL nLin, i1, i2

   ASort( ::aLinCelda, , , { | x, y | Str( x[ 1 ] ) + Str( x[ 2 ] ) < Str( y[ 1 ] ) + Str( y[ 2 ] ) } )
   nLin := 0
   FOR i1 := 1 TO Len( ::aLinCelda )
      IF nLin < ::aLinCelda[ i1, 1 ]
         DO WHILE nLin < ::aLinCelda[ i1, 1 ]
            AAdd( ::aPrintRtf, "\par " )
            nLin++
         ENDDO
         IF ::cUnits == "MM"
            ::aPrintRtf[ Len( ::aPrintRtf ) ] := ::aPrintRtf[ Len( ::aPrintRtf ) ] + "}\pard \qj \li0\ri0\nowidctlpar"
            FOR i2 := 1 TO Len( ::aLinCelda )
               IF ::aLinCelda[ i2, 1 ] == ::aLinCelda[ i1, 1 ]
                  DO CASE
                  CASE ::aLinCelda[ i2, 5 ] == "R"
                     ::aPrintRtf[ Len( ::aPrintRtf ) ] := ::aPrintRtf[ Len( ::aPrintRtf ) ] + "\tqr" + "\tx" + LTrim( Str( Round( ( ::aLinCelda[ i2, 2 ] - 10 ) * 56.7, 0 ) ) )
                  CASE ::aLinCelda[ i2, 5 ] == "C"
                     ::aPrintRtf[ Len( ::aPrintRtf ) ] := ::aPrintRtf[ Len( ::aPrintRtf ) ] + "\tqc" + "\tx" + LTrim( Str( Round( ( ::aLinCelda[ i2, 2 ] - 10 ) * 56.7, 0 ) ) )
                  OTHERWISE
                     ::aPrintRtf[ Len( ::aPrintRtf ) ] := ::aPrintRtf[ Len( ::aPrintRtf ) ] + "\tql" + "\tx" + LTrim( Str( Round( ( ::aLinCelda[ i2, 2 ] - 10 ) * 56.7, 0 ) ) )
                  ENDCASE
               ENDIF
            NEXT
            ::aPrintRtf[ Len( ::aPrintRtf ) ] := ::aPrintRtf[ Len( ::aPrintRtf ) ] + "\faauto\adjustright\rin0\lin0\itap0 {"
         ENDIF
      ENDIF

      IF ::nPrintRtf <> ::aLinCelda[ i1, 4 ]
         ::nPrintRtf := ::aLinCelda[ i1, 4 ]
         IF ::nPrintRtf == ::nFontSize
            IF ::cUnits == "MM"
               ::aPrintRtf[ Len( ::aPrintRtf ) ] := ::aPrintRtf[ Len( ::aPrintRtf ) ] + "}{\f0\lang1034\langfe3082\cgrid0\langnp1034"
            ELSE
               ::aPrintRtf[ Len( ::aPrintRtf ) ] := ::aPrintRtf[ Len( ::aPrintRtf ) ] + "}{\f2\lang1034\langfe3082\cgrid0\langnp1034"
            ENDIF
         ELSE
            IF ::cUnits == "MM"
               ::aPrintRtf[ Len( ::aPrintRtf ) ] := ::aPrintRtf[ Len( ::aPrintRtf ) ] + "}{\f0\fs" + Ltrim( Str( ::nPrintRtf ) ) + "\lang1034\langfe3082\cgrid0\langnp1034"
            ELSE
               ::aPrintRtf[ Len( ::aPrintRtf ) ] := ::aPrintRtf[ Len( ::aPrintRtf ) ] + "}{\f2\fs" + Ltrim( Str ( ::nPrintRtf ) ) + "\lang1034\langfe3082\cgrid0\langnp1034"
            ENDIF
         ENDIF
      ENDIF

      IF ::cUnits == "MM"
         ::aPrintRtf[ Len( ::aPrintRtf ) ] := ::aPrintRtf[ Len( ::aPrintRtf ) ] + "\tab " + ;
                                              iif( ::aLinCelda[ i1, 6 ], "\b ", "" ) + ;
                                              iif( ::aLinCelda[ i1, 7 ], "\i ", "" ) + ;
                                              iif( ::aLinCelda[ i1, 8 ], "\ul ", "" ) + ;
                                              iif( ::aLinCelda[ i1, 9 ], "\strike ", "" ) + ;
                                              ::aLinCelda[ i1, 3 ] + ;
                                              iif( ::aLinCelda[ i1, 6 ], "\b0", "" ) + ;
                                              iif( ::aLinCelda[ i1, 7 ], "\i0", "" ) + ;
                                              iif( ::aLinCelda[ i1, 8 ], "\ul0 ", "" ) + ;
                                              iif( ::aLinCelda[ i1, 9 ], "\strike0 ", "" )
      ELSE
         IF ::aLinCelda[ i1, 6 ]        // Bold
            ::aPrintRtf[ Len( ::aPrintRtf ) ] += "\b "
         ENDIF
         IF ::aLinCelda[ i1, 7 ]        // Italic
            ::aPrintRtf[ Len( ::aPrintRtf ) ] += "\i "
         ENDIF
        IF ::aLinCelda[ i1, 8 ]        // Underline
            ::aPrintRtf[ Len( ::aPrintRtf ) ] += "\ul "
         ENDIF
         IF ::aLinCelda[ i1, 9 ]        // Strikeout
            ::aPrintRtf[ Len( ::aPrintRtf ) ] += "\strike "
         ENDIF
         IF Right( ::aPrintRtf[ Len( ::aPrintRtf ) ], 1 ) # " "
            ::aPrintRtf[ Len( ::aPrintRtf ) ] += " "
         ENDIF
         ::aPrintRtf[ Len( ::aPrintRtf ) ] += space(::aLinCelda[ i1, 2 ]) + ::aLinCelda[ i1, 3 ]
         IF ::aLinCelda[ i1, 9 ]        // Strikeout
            ::aPrintRtf[ Len( ::aPrintRtf ) ] += "\strike0"
         ENDIF
         IF ::aLinCelda[ i1, 8 ]        // Underline
            ::aPrintRtf[ Len( ::aPrintRtf ) ] += "\ul0"
         ENDIF
         IF ::aLinCelda[ i1, 7 ]        // Italic
            ::aPrintRtf[ Len( ::aPrintRtf ) ] += "\i0"
         ENDIF
         IF ::aLinCelda[ i1, 6 ]        // Bold
            ::aPrintRtf[ Len( ::aPrintRtf ) ] += "\b0"
         ENDIF
      ENDIF
   NEXT
   /*
   TODO: Add color support.
   */

   ::aPrintRtf[ Len( ::aPrintRtf ) ] += " \page"
   ::aLinCelda := {}

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintDataX( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, cText, lItalic, nAngle, lUnder, lStrike, nWidth ) CLASS TRTFPRINT

   LOCAL nFontTableStart, i, j, aFonts, cFontNumber, cNext, nParLevel, cFontName
   LOCAL nNextFont := 201, aFontTable := { {"0",   "TIMES NEW ROMAN" }, ;
                                           {"2",   "COURIER NEW" }, ;
                                           {"106", "TIMES NEW ROMAN CE" }, ;
                                           {"107", "TIMES NEW ROMAN CYR" }, ;
                                           {"109", "TIMES NEW ROMAN GREEK" }, ;
                                           {"110", "TIMES NEW ROMAN TUR" }, ;
                                           {"111", "TIMES NEW ROMAN (HEBREW)" }, ;
                                           {"112", "TIMES NEW ROMAN (ARABIC)" }, ;
                                           {"113", "TIMES NEW ROMAN BALTIC" }, ;
                                           {"122", "COURIER NEW CE" }, ;
                                           {"123", "COURIER NEW CYR" }, ;
                                           {"125", "COURIER NEW GREEK" }, ;
                                           {"126", "COURIER NEW TUR" }, ;
                                           {"127", "COURIER NEW (HEBREW)" }, ;
                                           {"128", "COURIER NEW (ARABIC)" }, ;
                                           {"129", "COURIER NEW BALTIC" } }

   HB_SYMBOL_UNUSED( uData )
   HB_SYMBOL_UNUSED( cFont )
   HB_SYMBOL_UNUSED( aColor )
   HB_SYMBOL_UNUSED( nLen )
   HB_SYMBOL_UNUSED( nAngle )
   HB_SYMBOL_UNUSED( nWidth )

   /*
     TODO: Add support for new fonts using cFont.
           They must be added to font table if it's already initialized.
           aFontTable should become a DATA.
           Add color support using aColor.
   */

   nLin++
   IF ::nUnitsLin > 1
      nLin := Round( nLin / ::nUnitsLin, 0 )
   ENDIF
   IF ::cUnits == "MM"
      cText := AllTrim( cText )
   ENDIF

   IF Left( cText, 6 ) == "{\rtf1"
      // A RTF document can have only one font table.
      // We must change the number of already defined fonts and
      // add new one to original font table.
      IF ( nFontTableStart := At( "{\fonttbl", cText ) ) > 0
         i := nFontTableStart + 9

         aFonts := {}

         DO WHILE i <= Len( cText )
            IF SubStr( cText, i, 1 ) == "}"
               cText := SubStr( cText, 1, nFontTableStart - 1 ) + SubStr( cText, i + 1 )
               EXIT
            ENDIF

            IF SubStr( cText, i, 3 ) == "{\f"
               // process font number
               cFontNumber := ""
               i += 3
               DO WHILE i <= Len( cText ) .AND. ( cNext := SubStr( cText, i, 1 ) ) $ "0123456789"
                  cFontNumber += cNext
                  i++
               ENDDO
               IF Len( cFontNumber ) < 1 .OR. i > Len( cText ) .OR. ! cNext $ " \{"
                  // RTF text is non compliant with the standard
                  EXIT
               ENDIF

               nParLevel := 0
               DO WHILE .T.
                  IF cNext == " "
                     i++
                     IF i > Len( cText )
                        EXIT
                     ENDIF
                     cNext := SubStr( cText, i, 1 )
                  ENDIF

                  IF cNext == "\"
                     i++
                     DO WHILE i <= Len( cText ) .AND. ! ( cNext := SubStr( cText, i, 1 ) ) $ " \{}"
                        i++
                     ENDDO
                     IF i > Len( cText ) .OR. cNext == "}"
                        EXIT
                     ELSEIF cNext == " "
                        LOOP
                     ELSEIF cNext == "\"
                        LOOP
                     ENDIF
                  ENDIF

                  IF cNext == "{"
                     nParLevel++
                     DO WHILE nParLevel > 0
                        i++
                        DO WHILE i <= Len( cText ) .AND. ! ( cNext := SubStr( cText, i, 1 ) ) $ "{}"
                           i++
                        ENDDO
                        IF i > Len( cText )
                           EXIT
                        ELSEIF cNext == "{"
                           nParLevel++
                        ELSE
                           nParLevel --
                        ENDIF
                     ENDDO
                     IF i > Len( cText )
                        EXIT
                     ENDIF
                     i++
                     IF i > Len( cText )
                        EXIT
                     ENDIF
                     cNext := SubStr( cText, i, 1 )
                  ENDIF

                  cFontName := ""
                  DO WHILE ! cNext == ";"
                     cFontName += cNext
                     i++
                     IF i > Len( cText )
                        EXIT
                     ENDIF
                     cNext := SubStr( cText, i, 1 )
                  ENDDO
                  IF i > Len( cText )
                     EXIT
                  ENDIF
                  i++
                  IF i > Len( cText )
                     EXIT
                  ENDIF
                  IF ! ( cNext := SubStr( cText, i, 1 ) ) == "}"
                     EXIT
                  ENDIF

                  AAdd( aFonts, { cFontNumber, Upper( cFontName ) } )

                  i++
                  EXIT
               ENDDO
            ELSE
               EXIT
            ENDIF
         ENDDO

         FOR i := 1 TO Len( aFonts )
            IF ( j := AScan( aFontTable, { |f| f[2] == aFonts[i, 2] } ) ) > 0
               // Substitute font references
               cText := StrTran( cText, '\f' + aFonts[i, 1] + ' ', '\f' + aFontTable[j, 1] + ' ' )
               cText := StrTran( cText, '\f' + aFonts[i, 1] + '\', '\f' + aFontTable[j, 1] + '\' )
               cText := StrTran( cText, '\f' + aFonts[i, 1] + '{', '\f' + aFontTable[j, 1] + '{' )
            ELSE
               // Add new font
               ::aPrintRtf[ RTF_FONT_TABLE ] += "{\f" + LTrim(Str(nNextFont)) + " " + aFonts[i, 2] + ";}"
               nNextFont++
            ENDIF
         NEXT

         IF ::lIndentAll .AND. ::cUnits == "ROWCOL"
            /*
               Useful for printing the RichValue of a RichEditBox: if it has more than one line,
               all lines are placed at the column specified in the PrintData call.
            */
            cText := StrTran( cText, "\par ", "\par " + Space( nCol ) )
            cText := StrTran( cText, "\par" + Chr(13) + Chr(10), "\par " + Space( nCol ) )
         ENDIF
      ENDIF
   ENDIF
   /*
   TODO: Add color support. Colors not in colortbl must be added.
   */

   AAdd( ::aLinCelda, { nLin, nCol, Space( ::nLMargin ) + cText, nSize, cAlign, lBold, lItalic, lUnder, lStrike } )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintLineX( nLin, nCol, nLinF, nColF, atColor, ntwPen ) CLASS TRTFPRINT

   HB_SYMBOL_UNUSED( ntwPen )

   IF nLin == nLinF
      ::PrintDataX( nLin, nCol, , ::cFontName, ::nFontSize, ::lFontBold, atColor, "L", , Replicate( "-", nColF - nCol + 1 ), ::lFontItalic, ::nFontAngle, ::lFontUnderline, ::lFontStrikeout, ::nFontWidth )
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SelPrinterX( lSelect, lPreview, lLandscape, nPaperSize, cPrinterX, nRes, nBin, nDuplex, lCollate, nCopies, lColor, nScale, nPaperLength, nPaperWidth ) CLASS TRTFPRINT

   HB_SYMBOL_UNUSED( lSelect )
   /*
   TODO: Add support for a dialog to select file
   */
   HB_SYMBOL_UNUSED( lPreview )
   HB_SYMBOL_UNUSED( nPaperSize )
   /*
   TODO: Add support for other paper sizes
   */
   HB_SYMBOL_UNUSED( cPrinterX )
   HB_SYMBOL_UNUSED( nRes )
   HB_SYMBOL_UNUSED( nBin )
   HB_SYMBOL_UNUSED( nDuplex )
   HB_SYMBOL_UNUSED( lCollate )
   HB_SYMBOL_UNUSED( nCopies )
   HB_SYMBOL_UNUSED( lColor )
   HB_SYMBOL_UNUSED( nScale )
   HB_SYMBOL_UNUSED( nPaperLength )
   HB_SYMBOL_UNUSED( nPaperWidth )

   ::lLandscape := lLandscape
   ::cPrinter := "RTF"

   RETURN Self


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TCSVPRINT FROM TPRINTBASE

   DATA aPrintCsv                 INIT {}                    READONLY

   METHOD BeginDocX
   METHOD EndDocX
   METHOD EndPageX
   METHOD InitX
   METHOD PrintDataX
   METHOD PrintImage              BLOCK { || NIL }
   METHOD SelPrinterX             BLOCK { |Self| ::cPrinter := "CSV" }
   METHOD SetPreviewSize          BLOCK { || NIL }
   /*
   TODO: Add SelPrinterX to open a dialog to select file.
   */

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginDocX() CLASS TCSVPRINT

   ::cDocument := ParseName( ::Cargo, "csv" )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InitX() CLASS TCSVPRINT

   ::cPrintLibrary := "CSVPRINT"

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndDocX() CLASS TCSVPRINT

   LOCAL i

   SET PRINTER TO ( ::cDocument )
   SET DEVICE TO PRINTER
   SetPRC( 0, 0 )
   FOR i := 1 TO Len( ::aPrintCsv )
      @ PRow(), PCol() SAY ::aPrintCsv[ i ]
      @ PRow() + 1, 0 SAY ""
   NEXT
   SET DEVICE TO SCREEN
   SET PRINTER TO

   IF ::ImPreview
      IF ShellExecute( 0, "open", "rundll32.exe", "url.dll,FileProtocolHandler " + ::cDocument, , 1 ) <= 32
         IF ::lShowErrors
            MsgStop( _OOHG_Messages( 12, 39 ) + Chr( 13 ) + Chr( 13 ) + _OOHG_Messages( 12, 36 ) + Chr( 13 ) + ::cDocument, _OOHG_Messages( 12, 12 ) )
         ENDIF
         RETURN NIL
      ENDIF
   ENDIF
   ::aPrintCsv := {}

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndPageX() CLASS TCSVPRINT

   LOCAL nLin, i

   ASort( ::aLinCelda, , , { | x, y | Str( x[ 1 ] ) + Str( x[ 2 ] ) < Str( y[ 1 ] ) + Str( y[ 2 ] ) } )
   nLin := 0
   FOR i := 1 TO Len( ::aLinCelda )
      IF nLin < ::aLinCelda[ i, 1 ]
         DO WHILE nLin < ::aLinCelda[ i, 1 ]
            AAdd( ::aPrintCsv, "" )
            nLin++
         ENDDO
      ENDIF

      IF Len( ::aPrintCsv[ Len( ::aPrintCsv ) ] ) == 0
         ::aPrintCsv[ Len( ::aPrintCsv ) ] := ::aLinCelda[ i, 3 ]
      ELSE
         ::aPrintCsv[ Len( ::aPrintCsv ) ] := ::aPrintCsv[ Len( ::aPrintCsv ) ] + ";" + StrTran( ::aLinCelda[ i, 3 ], ";", "," )
      ENDIF
   NEXT
   ::aLinCelda := {}

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintDataX( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, cText, lItalic, nAngle, lUnder, lStrike, nWidth ) CLASS TCSVPRINT

   HB_SYMBOL_UNUSED( uData )
   HB_SYMBOL_UNUSED( cFont )
   HB_SYMBOL_UNUSED( nSize )
   HB_SYMBOL_UNUSED( lBold )
   HB_SYMBOL_UNUSED( aColor )
   HB_SYMBOL_UNUSED( cAlign )
   HB_SYMBOL_UNUSED( nLen )
   HB_SYMBOL_UNUSED( lItalic )
   HB_SYMBOL_UNUSED( nAngle )
   HB_SYMBOL_UNUSED( lUnder )
   HB_SYMBOL_UNUSED( lStrike )
   HB_SYMBOL_UNUSED( nWidth )

   nLin++
   IF ::nUnitsLin > 1
      nLin := Round( nLin / ::nUnitsLin, 0 )
   ENDIF
   IF ::cUnits == "MM"
      cText := AllTrim( cText )
   ENDIF
   AAdd( ::aLinCelda, { nLin, nCol, Space( ::nLMargin ) + cText } )

   RETURN Self


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TPDFPRINT FROM TPRINTBASE

   DATA aPaper                    INIT {}                    READONLY // paper types supported by pdf class
   DATA cPageOrient               INIT "P"                   READONLY // P = portrait, L = Landscape
   DATA cPageSize                 INIT ""                    READONLY // page size
   DATA oPDF                      INIT NIL                   READONLY // reference to the TPDF object

   METHOD BeginDocX
   METHOD BeginPageX
   METHOD EndDocX
   METHOD InitX
   METHOD PrintBarcodeX
   METHOD PrintDataX
   METHOD PrintImageX
   METHOD PrintLineX
   METHOD PrintRectangleX
   METHOD PrintRoundRectangleX
   METHOD SelPrinterX
   METHOD SetPreviewSize          BLOCK { || NIL }

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InitX() CLASS TPDFPRINT

   // These are the only paper types supported
   AAdd( ::aPaper, { DMPAPER_LETTER,      "LETTER"    } )
   AAdd( ::aPaper, { DMPAPER_LEGAL,       "LEGAL"     } )
   AAdd( ::aPaper, { DMPAPER_TABLOID,     "LEDGER"    } )
   AAdd( ::aPaper, { DMPAPER_EXECUTIVE,   "EXECUTIVE" } )
   AAdd( ::aPaper, { DMPAPER_A3,          "A3"        } )
   AAdd( ::aPaper, { DMPAPER_A4,          "A4"        } )
   AAdd( ::aPaper, { DMPAPER_ENV_10,      "COM10"     } )
   AAdd( ::aPaper, { DMPAPER_B4,          "JIS B4"    } )
   AAdd( ::aPaper, { DMPAPER_B5,          "JIS B5"    } )
   AAdd( ::aPaper, { DMPAPER_P32K,        "JPOST"     } )
   AAdd( ::aPaper, { DMPAPER_ENV_C5,      "C5"        } )
   AAdd( ::aPaper, { DMPAPER_ENV_DL,      "DL"        } )
   AAdd( ::aPaper, { DMPAPER_ENV_B5,      "B5"        } )
   AAdd( ::aPaper, { DMPAPER_ENV_MONARCH, "MONARCH"   } )

   ::cPrintLibrary := "PDFPRINT"

   RETURN Self

FUNCTION ParseName( cName, cExt, lInvSlash )

   LOCAL i, cLongName, lExt

   DEFAULT lInvSlash TO .F.
   cExt := Lower( cExt )

   // remove extension if there's one
   i := At( ".", cName )
   IF i > 0
      cName := SubStr( cName, 1, i - 1 )
   ENDIF

   // if name is not full qualified asume MyDocuments folder
   i := RAt( "\", cName )
   IF i == 0
      cLongName := GetMyDocumentsFolder() + "\" + cName
   ELSE
      cLongName := cName
   ENDIF

   // assign the specified extension
   lExt := Len( cExt )
   IF Right( cLongName, lExt) <> "." + cExt
      cLongName := cLongName + "." + cExt
   ENDIF

   // if specified change backslashes to slashes
   IF lInvSlash
      cLongName := StrTran( cLongName, "\", "/")
   ENDIF

   RETURN cLongName

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginDocX () CLASS TPDFPRINT

   ::cDocument := ParseName( ::Cargo, "pdf" )
   ::oPdf := TPDF():Init( ::cDocument )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndDocX() CLASS TPDFPRINT

   ::oPdf:Close()
   IF ::ImPreview
      IF ShellExecute( 0, "open", "rundll32.exe", "url.dll,FileProtocolHandler " + ::cDocument, , 1) <= 32
         IF ::lShowErrors
            MsgStop( _OOHG_Messages( 12, 40 ) + Chr( 13 ) + Chr( 13 ) + _OOHG_Messages( 12, 36 ) + Chr( 13 ) + ::cDocument, _OOHG_Messages( 12, 12 ) )
         ENDIF
         RETURN NIL
      ENDIF
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginPageX() CLASS TPDFPRINT

   ::oPdf:NewPage( ::cPageSize, ::cPageOrient, , ::cFontName, ::nFontType, ::nFontSize )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintDataX( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, cText, lItalic, nAngle, lUnder, lStrike, nWidth ) CLASS TPDFPRINT

   LOCAL nType, cColor

   HB_SYMBOL_UNUSED( uData )
   HB_SYMBOL_UNUSED( cAlign )
   HB_SYMBOL_UNUSED( nLen )
   HB_SYMBOL_UNUSED( nAngle )
   HB_SYMBOL_UNUSED( lUnder )    // TODO: Add underline support
   HB_SYMBOL_UNUSED( lStrike )
   HB_SYMBOL_UNUSED( nWidth )

   cColor := Chr( 253 ) + Chr( aColor[1] ) + Chr( aColor[2] ) + Chr( aColor[3] )

   IF lBold
      nType := 1      // bold
   ELSE
      nType := 0      // normal
   ENDIF

   IF lItalic
      IF lBold
         nType := 3   // bold and italic
      ELSE
         nType := 2    // only italic
      ENDIF
   ENDIF

   IF "roman" $ Lower( cFont )
      cFont := "TIMES"
   ELSE
      IF "helvetica" $ Lower( cFont ) .OR. "arial" $ Lower( cFont )
         cFont := "HELVETICA"
      ELSE
         cFont := "COURIER"
      ENDIF
   ENDIF

   ::oPdf:SetFont( cFont, nType, nSize )

   IF ::cUnits == "MM"
      nLin += 3
   ENDIF

   cText := cColor + cText

   IF ::cUnits == "MM"
      ::oPdf:AtSay( cText, nLin, nCol, "M" )
   ELSE
      ::oPdf:AtSay( cText, nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2, "M" )
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintBarcodeX( nLin, nCol, nLinF, nColF, atColor ) CLASS TPDFPRINT

   LOCAL cColor := Chr( 253 ) + Chr( atColor[1] ) + Chr( atColor[2] ) + Chr( atColor[3] )

   ::oPdf:Box( nLin, nCol, nLinF, nColF, 0, 1, "M", cColor, "t1" )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintImageX( nLin, nCol, nLinF, nColF, cImage, uSorR ) CLASS TPDFPRINT

   LOCAL nVDispl := 0.980
   LOCAL nHDispl := 1.300

   HB_SYMBOL_UNUSED( uSorR )

   IF HB_ISSTRING( cImage )
      cImage := Upper( cImage )
      // The only supported image formats are jpg and tiff.
      IF AScan( { ".jpg", ".jpeg", ".tif", ".tiff" }, Lower( SubStr( cImage, RAt( ".", cImage ) ) ) ) == 0
         RETURN NIL
      ENDIF
   ELSE
     RETURN NIL
   ENDIF

   nLinF := nLinF - nLin
   nColF := nColF - nCol

   // TODO: Add support for images in the resource file (copy them to a temp file)

   IF ::cUnits == "MM"
      ::oPdf:Image( cImage, nLin, nCol, "M", nLinF, nColF )
   ELSE
      ::oPdf:Image( cImage, nLin * ::nmVer * nVDispl + ::nvFij, nCol * ::nmHor + ::nhFij * nHDispl, "M", nLinF * ::nmVer * nVDispl + ::nvFij, nColF * ::nmHor + ::nhFij * nHDispl )
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintLineX( nLin, nCol, nLinF, nColF, atColor, ntwPen, lSolid ) CLASS TPDFPRINT

   LOCAL ctColor := Chr( 253 ) + Chr( atColor[1] ) + Chr( atColor[2] ) + Chr( atColor[3] )

   // TODO: check if we can print oblique lines
   HB_SYMBOL_UNUSED( lSolid )

   IF ::cUnits == "MM"
      ::oPdf:_OOHG_Line( ( nLin - 0.9 ) + ::nvFij, ( nCol + 1.3 ) + ::nhFij, ( nLinF - 0.9 ) + ::nvFij, ( nColF + 1.3 ) + ::nhFij, ntwPen * 1.2, ctColor )
   ELSE
      ::oPdf:_OOHG_Line( ( nLin - 0.9 ) * ::nmVer + ::nvFij, ( nCol + 1.3 ) * ::nmHor + ::nhFij, ( nLinF - 0.9 ) * ::nmVer + ::nvFij, ( nColF + 1.3 ) * ::nmHor+ ::nhFij, ntwPen * 1.2, ctColor )
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintRectangleX( nLin, nCol, nLinF, nColF, atColor, ntwPen, lSolid, arColor  ) CLASS TPDFPRINT

   LOCAL ctColor := Chr( 253 ) + Chr( atColor[1] ) + Chr( atColor[2] ) + Chr( atColor[3] )
   LOCAL crColor := Chr( 253 ) + Chr( arColor[1] ) + Chr( arColor[2] ) + Chr( arColor[3] )

   HB_SYMBOL_UNUSED( lSolid )

   IF ::cUnits == "MM"
      ::oPdf:_OOHG_Box( ( nLin - 0.9 ) + ::nvFij, ( nCol + 1.3 ) + ::nhFij, ( nLinF - 0.9 ) + ::nvFij, ( nColF + 1.3 ) + ::nhFij, ntwPen * 1.2, ctColor, crColor )
   ELSE
      ::oPdf:_OOHG_Box( ( nLin - 0.9 ) * ::nmVer + ::nvFij, ( nCol + 1.3 ) * ::nmHor + ::nhFij, ( nLinF - 0.9 ) * ::nmVer + ::nvFij, ( nColF + 1.3 ) * ::nmHor+ ::nhFij, ntwPen * 1.2, ctColor, crColor )
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintRoundRectangleX( nLin, nCol, nLinF, nColF, atColor, ntwPen, lSolid, arColor ) CLASS TPDFPRINT

   // We can't have a rounded rectangle so we make a normal one
   ::PrintRectangleX( nLin, nCol, nLinF, nColF, atColor, ntwPen, lSolid, arColor )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SelPrinterX( lSelect, lPreview, lLandscape, nPaperSize, cPrinterX, nRes, nBin, nDuplex, lCollate, nCopies, lColor, nScale, nPaperLength, nPaperWidth ) CLASS TPDFPRINT

   LOCAL nPos

   HB_SYMBOL_UNUSED( lSelect )
   /*
   TODO: Add support for a dialog to select file
   */
   HB_SYMBOL_UNUSED( lPreview )
   HB_SYMBOL_UNUSED( cPrinterX )
   HB_SYMBOL_UNUSED( nRes )
   HB_SYMBOL_UNUSED( nBin )
   HB_SYMBOL_UNUSED( nDuplex )
   HB_SYMBOL_UNUSED( lCollate )
   HB_SYMBOL_UNUSED( nCopies )
   HB_SYMBOL_UNUSED( lColor )
   HB_SYMBOL_UNUSED( nScale )
   HB_SYMBOL_UNUSED( nPaperLength )
   HB_SYMBOL_UNUSED( nPaperWidth )

   DEFAULT lLandscape TO .F.
   DEFAULT nPaperSize TO 0

   ::cPageOrient := iif( lLandscape, "L", "P" )
   nPos := AScan( ::aPaper, { | x | x[ 1 ] == nPaperSize } )

   If nPos > 0
      ::cPageSize := ::aPaper[ nPos ][ 2 ]
   ELSE
      ::cPageSize := "LETTER"
   ENDIF

   ::cPrinter := "PDF"

   RETURN Self


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TCALCPRINT FROM TPRINTBASE
// CALC contributed by Jose Miguel, adapted by CVC

   DATA oCell                     INIT NIL                   READONLY
   DATA oDesktop                  INIT NIL                   READONLY
   DATA oDocument                 INIT NIL                   READONLY
   DATA oSchedule                 INIT NIL                   READONLY
   DATA oServiceManager           INIT NIL                   READONLY
   DATA oSheet                    INIT NIL                   READONLY
   DATA nHorzResol                INIT PixelsPerInchX()      READONLY
   DATA nVertResol                INIT PixelsPerInchY()      READONLY

   METHOD BeginDocX
   METHOD BeginPageX
   METHOD EndDocX
   METHOD EndPageX
   METHOD InitX
   METHOD MaxCol                  INLINE iif( HB_ISOBJECT( ::oSheet ), ::oSheet:Columns:Count, 0 )
   METHOD MaxRow                  INLINE iif( HB_ISOBJECT( ::oSheet ), ::oSheet:Rows:Count, 0 )
   METHOD PrintDataX
   METHOD PrintImageX
   METHOD ReleaseX
   METHOD SelPrinterX             BLOCK { |Self| ::cPrinter := "CALC" }
   METHOD SetPreviewSize          BLOCK { || NIL }
   /*
   TODO: Add METHOD PrintLineX using cell borders.
   TODO: Add METHOD PrintRectangleX using cell borders.
   TODO: Add SelPrinterX to open a dialog to select file.
   TODO: Add support for "printing" in multiple cells.
   */

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InitX() CLASS TCALCPRINT

   LOCAL bErrorBlock := ErrorBlock( { | x | Break( x ) } ), uRet

   ::cPrintLibrary := "CALCPRINT"

   BEGIN SEQUENCE
      #ifndef __XHARBOUR__
      IF ( ::oServiceManager := win_oleCreateObject( "com.sun.star.ServiceManager" ) ) == NIL
      #else
      ::oServiceManager := TOleAuto():New( "com.sun.star.ServiceManager" )
      IF Ole2TxtError() != 'S_OK'
      #endif
         Break
      ENDIF
      IF ( ::oDesktop := ::oServiceManager:CreateInstance( "com.sun.star.frame.Desktop" ) ) == NIL
         Break
      ENDIF
      uRet := Self
   RECOVER
      IF ::lShowErrors
         MsgStop( _OOHG_Messages( 12, 44 ), _OOHG_Messages( 12, 12 ) )
      ENDIF
      ::lPrError := .T.
      ::Exit := .T.
      uRet := NIL
   END SEQUENCE
   ErrorBlock( bErrorBlock )

   RETURN uRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ReleaseX() CLASS TCALCPRINT

   LOCAL bErrorBlock := ErrorBlock( { | x | Break( x ) } )

   BEGIN SEQUENCE
      ::oDesktop:Terminate()
   END SEQUENCE
   ErrorBlock( bErrorBlock )
   ::oDesktop := NIL
   ::oServiceManager := NIL

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginDocX() CLASS TCALCPRINT

   LOCAL oPropertyValue, oSheet

   ::cDocument := ParseName( ::Cargo, "odt" )

   oPropertyValue := ::oServiceManager:Bridge_GetStruct( "com.sun.star.beans.PropertyValue" )
   oPropertyValue:Name := "Hidden"
   oPropertyValue:Value := .T.
   ::oDocument := ::oDesktop:LoadComponentFromURL( "private:factory/scalc", "_blank", 0, { oPropertyValue } )
   DO WHILE ::oDocument:Sheets:GetCount() > 1
      oSheet := ::oDocument:Sheets:GetByIndex( ::oDocument:Sheets:GetCount() - 1)
      ::oDocument:Sheets:RemoveByName( oSheet:Name )
   ENDDO
   oSheet := ::oDocument:Sheets:GetByIndex( 0 )
   ::oDocument:getCurrentController:SetActiveSheet( oSheet )
   ::oSchedule := ::oDocument:GetSheets()

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginPageX() CLASS TCALCPRINT

   ::oSheet := ::oDocument:GetCurrentController:GetActiveSheet()
   IF ::lSeparateSheets
      ::oSheet:Name := ::cPageName
      ::oSheet:CharFontName := ::cFontName
      ::oSheet:CharHeight := ::nFontSize
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndDocX() CLASS TCALCPRINT

   LOCAL bErrorBlock, uRet := Self

   IF ::lSeparateSheets
      ::oDocument:Sheets:RemoveByName( ::oSheet:Name )
      ::oSheet := ::oDocument:Sheets:GetByIndex( 0 )
   ELSE
      ::oSheet:GetColumns():SetPropertyValue( "OptimalWidth", .T. )
   ENDIF
   ::oDocument:GetCurrentController:SetActiveSheet( ::oSheet )
   ::oDocument:GetCurrentController:Select( ::oSheet:GetCellByPosition( 0, 0 ) )
   ::oCell := NIL
   ::oSheet := NIL
   ::oSchedule := NIL

   bErrorBlock := ErrorBlock( { | x | Break( x ) } )
   BEGIN SEQUENCE
      ::oDocument:StoreToURL( OO_ConvertToURL( ::cDocument ), {} )
      hb_idleSleep( 1 )
   RECOVER
      IF ::lShowErrors
         MsgStop( _OOHG_Messages( 12, 45 ) + Chr( 13 ) + ::cDocument, _OOHG_Messages( 12, 12 ) )
      ENDIF
      uRet := NIL
   END SEQUENCE
   ErrorBlock( bErrorBlock )

   ::oDocument:Close( 1 )
   ::oDocument := NIL

   IF uRet # NIL .AND. ::ImPreview
      IF ShellExecute( 0, "open", "rundll32.exe", "url.dll,FileProtocolHandler " + ::cDocument, , 1) <= 32
         IF ::lShowErrors
            MsgStop( _OOHG_Messages( 12, 41 ) + Chr( 13 ) + Chr( 13 ) + _OOHG_Messages( 12, 36 ) + Chr( 13 ) + ::cDocument, _OOHG_Messages( 12, 12 ) )
         ENDIF
         uRet := NIL
      ENDIF
   ENDIF

   RETURN uRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndPageX() CLASS TCALCPRINT

   LOCAL nLin, i, nCol, aColor, oPage, oGraph, aAnchor := {}, cName

   // Images must be anchored to the page to avoid resizing by changes in cell's width of height
   oPage := ::oSheet:GetDrawPage()
   FOR i := 1 TO oPage:GetCount()
      oGraph := oPage:GetByIndex( i - 1 )
      AAdd( aAnchor, oGraph:Anchor )
      oGraph:Anchor := ::oSheet
   NEXT i

   ASort( ::aLinCelda, , , { | x, y | Str( x[ 1 ] ) + Str( x[ 2 ] ) < Str( y[ 1 ] ) + Str( y[ 2 ] ) } )
   IF ::nLinPag == 0 .AND. Len( ::aLinCelda ) > 0
      ::cFontName := ::aLinCelda[ 1, 6 ]
      ::nFontSize := ::aLinCelda[ 1, 4 ]
      ::oSheet:CharFontName := ::cFontName
      ::oSheet:CharHeight := ::nFontSize
   ENDIF
   nLin := 0
   nCol := 1
   FOR i := 1 TO Len( ::aLinCelda )
      DO WHILE nLin < ::aLinCelda[ i, 1 ]
         nLin++
         nCol := 1
      ENDDO
      ::oCell := ::oSheet:GetCellByPosition( nCol - 1, ::nLinPag + nLin ) // columna,linea
      IF ValType( ::aLinCelda[ i, 3 ] ) == "N"
         ::oCell:SetValue( ::aLinCelda[ i, 3 ] )
      ELSE
         ::oCell:SetString( ::aLinCelda[ i, 3 ] )
      ENDIF
      IF ::aLinCelda[ i, 6 ] <> ::cFontName
         ::oCell:CharFontName := ::aLinCelda[ i, 6 ]
      ENDIF
      IF ::aLinCelda[ i, 4 ] <> ::nFontSize
         ::oCell:CharHeight := ::aLinCelda[ i, 4 ]
      ENDIF
      IF ::aLinCelda[ i, 7] == .T.
         ::oCell:CharWeight := 150                                 // Bold
      ELSE
         ::oCell:CharWeight := 100
      ENDIF
      DO CASE
      CASE ::aLinCelda[ i, 5 ] == "R"
         ::oCell:HoriJustify := 3
      CASE ::aLinCelda[ i, 5 ] == "C"
         ::oCell:HoriJustify := 2
      ENDCASE
      aColor := ::aLinCelda[ i, 8 ]
      IF aColor[ 3 ] <> 0 .OR. aColor[ 2 ] <> 0 .OR. aColor[ 1 ] <> 0
         ::oCell:CharColor := RGB( aColor[ 3 ], aColor[ 2 ], aColor[ 1 ] )
      ENDIF
      ::oCell:CharPosture := iif( ::aLinCelda[ i, 9], 1, 0 )       // Italic
      DO CASE                                                      // Angle/Orientation
      CASE ::aLinCelda[ i, 10] == -4128                            // STANDARD
         ::oCell:Orientation := 0
      CASE ::aLinCelda[ i, 10] == -4170                            // TOPBOTTOM
         ::oCell:Orientation := 1
      CASE ::aLinCelda[ i, 10] == -4171                            // BOTTOMTOP
         ::oCell:Orientation := 2
      CASE ::aLinCelda[ i, 10] == -4166                            // STACKED
         ::oCell:Orientation := 3
      OTHERWISE
         ::oCell:RotateAngle := ::aLinCelda[ i, 10]
      ENDCASE
      ::oCell:CharUnderline := iif( ::aLinCelda[ i, 11], 1, 0 )
      ::oCell:CharStrikeout := iif( ::aLinCelda[ i, 12], 1, 0 )
      nCol++
   NEXT

   // Resize
   ::oSheet:GetColumns():SetPropertyValue( "OptimalWidth", .T. )
   // Restore the anchor
   FOR i := 1 TO oPage:GetCount
      oGraph := oPage:GetByIndex( i - 1 )
      oGraph:Anchor := aAnchor[i]
   NEXT i

   IF ::lSeparateSheets
      // Add new sheet
      i := 0
      DO WHILE .T.
         cName := "Sheet" + LTrim( Str( i ) )
         IF ! ::oDocument:Sheets:HasByName( cName )
            ::oDocument:Sheets:InsertNewByName( cName, ::oDocument:Sheets:GetCount() )
            ::oSheet := ::oDocument:Sheets:GetByIndex( ::oDocument:Sheets:GetCount() - 1 )
            ::oDocument:GetCurrentController:SetActiveSheet( ::oSheet )
            EXIT
         ENDIF
         i++
      ENDDO
      // Reset line count
      ::nLinPag := 0
   ELSE
      ::nLinPag := ::nLinPag + nLin + 1
   ENDIF
   ::aLinCelda := {}

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintDataX( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, cText, lItalic, nAngle, lUnder, lStrike, nWidth ) CLASS TCALCPRINT

   HB_SYMBOL_UNUSED( uData )
   HB_SYMBOL_UNUSED( nLen )
   HB_SYMBOL_UNUSED( nWidth )

   IF ::nUnitsLin > 1
      nLin := Round( nLin / ::nUnitsLin, 0 )
   ENDIF
   IF ::cUnits == "MM"
      cText := AllTrim( cText )
   ENDIF
   AAdd( ::aLinCelda, { nLin, nCol, cText, nSize, cAlign, cFont, lBold, aColor, lItalic, nAngle, lUnder, lStrike } )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintImageX( nLin, nCol, nLinF, nColF, cImage, aResol, aSize ) CLASS TCALCPRINT

   LOCAL cURL, oGraph, oPage, cName, cFullName, oSize, aImgSize, oTable, oShape, nW, nH, lUseResol

   HB_SYMBOL_UNUSED( nColF )
   HB_SYMBOL_UNUSED( nLinF )

   IF nLin < 1
      nLin := 1
   ENDIF
   IF nCol < 1
      nCol := 1
   ENDIF
   nLin++
   IF ::nUnitsLin > 1
      nLin := Round( nLin / ::nUnitsLin, 0 )
      nCol := Round( nCol / ::nUnitsLin, 0 )
   ENDIF

   IF At( '\', cImage ) == 0
      cFullName := GetCurrentFolder() + '\' + cImage
   ELSE
      cFullName := cImage
   ENDIF

   IF File( cFullName )
      cURL := OO_ConvertToURL( cFullName )
      cName := StrTran( SubStr( cImage, RAt( '\', cImage ) + 1 ), '.', '_' ) + StrTran( Time(), ":", "_" )

      /*
       * OO scales the image using it's resolution.
       * This data is not available using Windows functions,
       * it must be calculated from the image's file.
       * So we use aResol parameter.
       */

      oSize := ::oServiceManager:Bridge_GetStruct( "com.sun.star.awt.Size" )
      IF aResol == NIL
         IF aSize == NIL
            lUseResol := .T.
            nW := ::nHorzResol
            nH := ::nVertResol
         ELSEIF HB_ISARRAY( aSize )
            lUseResol := .F.
            nW := aSize[1]
            nH := aSize[2]
         ELSE
            lUseResol := .F.
            nW := aSize
            nH := aSize
         ENDIF
      ELSEIF HB_ISARRAY( aResol )
         lUseResol := .T.
         nW := aResol[1]
         nH := aResol[2]
      ELSE
         lUseResol := .T.
         nW := aResol
         nH := aResol
      ENDIF
      IF lUseResol
         aImgSize := _OOHG_SizeOfBitmapFromFile( cFullName )
         oSize:Width := Round( aImgSize[1] * 2.54 * 1000 / nW, -1 )   // in 100/th mm
         oSize:Height := Round( aImgSize[2] * 2.54 * 1000 / nH, -1 )
      ELSE
         oSize:Width := nW
         oSize:Height := nH
      ENDIF

      oTable := ::oDocument:createInstance("com.sun.star.drawing.BitmapTable")
      oTable:insertByName( cName, cURL )
      oShape := ::oDocument:createInstance( "com.sun.star.drawing.GraphicObjectShape" )
      oShape:Name := cName
      oShape:Title := cFullName
      oShape:Size := oSize
      oShape:GraphicURL := oTable:getByName( cName )
      oPage := ::oSheet:getDrawPage()
      oPage:Add( oShape )
      oGraph := oPage:getByIndex( oPage:getCount - 1 )
      oGraph:Anchor := ::oSheet:getCellByPosition( 0, nLin - 1 )
      oTable:removeByName( cName )
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION OO_ConvertToURL( cFile )

   // From https://github.com/harbour/core/blob/master/contrib/hbwin/tests/ole.prg
   IF ! Left( cFile, 2 ) == "\\"
      cFile := StrTran( cFile, ":", "|" )
      cFile := "///" + cFile
   ENDIF
   cFile := StrTran( cFile, "\", "/" )
   cFile := StrTran( cFile, " ", "%20" )

   RETURN "file:" + cFile


// Barcode related defines and functions

#define CODABAR_CODES { "101010001110", ;
                        "101011100010", ;
                        "101000101110", ;
                        "111000101010", ;
                        "101110100010", ;
                        "111010100010", ;
                        "100010101110", ;
                        "100010111010", ;
                        "100011101010", ;
                        "111010001010", ;
                        "101000111010", ;
                        "101110001010", ;
                        "11101011101110", ;
                        "11101110101110", ;
                        "11101110111010", ;
                        "10111011101110", ;
                        "10111000100010", ;
                        "10001000101110", ;
                        "10100011100010", ;
                        "10111000100010", ;
                        "10001000101110", ;
                        "10100010001110", ;
                        "10100011100010" }

#define CODABAR_CHARS '0123456789-$:/.+ABCDTN*E'

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _Codabar( cCode, lShowErrors )
// Important: this function does not set the start and end codes

   LOCAL n, cBarcode := '', nCar

   DEFAULT lShowErrors TO .T.
   IF ValType( cCode ) != 'C'
      IF lShowErrors
         MsgStop( _OOHG_Messages( 12, 42 ), _OOHG_Messages( 12, 12 ) )
      ENDIF
      RETURN NIL
   ENDIF
   cCode := Upper( cCode )
   FOR n := 1 TO Len( cCode )
      IF ( nCar := At( SubStr( cCode, n, 1 ), CODABAR_CHARS ) ) > 0
         cBarcode += CODABAR_CODES[ nCar ]
      ENDIF
   NEXT

   RETURN cBarcode

#define CODE128_CODES {"212222", ;
                       "222122", ;
                       "222221", ;
                       "121223", ;
                       "121322", ;
                       "131222", ;
                       "122213", ;
                       "122312", ;
                       "132212", ;
                       "221213", ;
                       "221312", ;
                       "231212", ;
                       "112232", ;
                       "122132", ;
                       "122231", ;
                       "113222", ;
                       "123122", ;
                       "123221", ;
                       "223211", ;
                       "221132", ;
                       "221231", ;
                       "213212", ;
                       "223112", ;
                       "312131", ;
                       "311222", ;
                       "321122", ;
                       "321221", ;
                       "312212", ;
                       "322112", ;
                       "322211", ;
                       "212123", ;
                       "212321", ;
                       "232121", ;
                       "111323", ;
                       "131123", ;
                       "131321", ;
                       "112313", ;
                       "132113", ;
                       "132311", ;
                       "211313", ;
                       "231113", ;
                       "231311", ;
                       "112133", ;
                       "112331", ;
                       "132131", ;
                       "113123", ;
                       "113321", ;
                       "133121", ;
                       "313121", ;
                       "211331", ;
                       "231131", ;
                       "213113", ;
                       "213311", ;
                       "213131", ;
                       "311123", ;
                       "311321", ;
                       "331121", ;
                       "312113", ;
                       "312311", ;
                       "332111", ;
                       "314111", ;
                       "221411", ;
                       "431111", ;
                       "111224", ;
                       "111422", ;
                       "121124", ;
                       "121421", ;
                       "141122", ;
                       "141221", ;
                       "112214", ;
                       "112412", ;
                       "122114", ;
                       "122411", ;
                       "142112", ;
                       "142211", ;
                       "241211", ;
                       "221114", ;
                       "413111", ;
                       "241112", ;
                       "134111", ;
                       "111242", ;
                       "121142", ;
                       "121241", ;
                       "114212", ;
                       "124112", ;
                       "124211", ;
                       "411212", ;
                       "421112", ;
                       "421211", ;
                       "212141", ;
                       "214121", ;
                       "412121", ;
                       "111143", ;
                       "111341", ;
                       "131141", ;
                       "114113", ;
                       "114311", ;
                       "411113", ;
                       "411311", ;
                       "113141", ;
                       "114131", ;
                       "311141", ;
                       "411131", ;
                       "211412", ;
                       "211214", ;
                       "211232", ;
                       "2331112" }

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _Code128( cCode, cMode, lShowErrors )

   LOCAL nSum, cBarcode, cCar
   LOCAL cTemp, n, nCar, nCount := 0
   LOCAL lCodeC := .F., lCodeA := .F.

   DEFAULT lShowErrors TO .T.
   IF ValType( cCode ) != 'C'
      IF lShowErrors
         MsgStop( _OOHG_Messages( 12, 42 ), _OOHG_Messages( 12, 12 ) )
      ENDIF
      RETURN NIL
   ENDIF
   IF ! Empty( cMode )
      IF ValType( cMode ) == 'C' .AND. Upper( cMode ) $ 'ABC'
         cMode := Upper( cMode )
      ELSE
         IF lShowErrors
            MsgStop( _OOHG_Messages( 12, 43 ), _OOHG_Messages( 12, 12 ) )
         ENDIF
         RETURN NIL
      ENDIF
   ENDIF
   IF Empty( cMode ) // variable mode
      // analize code type
      IF Str( Val( cCode ), Len( cCode ) ) == cCode // numbers only
         lCodeC := .T.
         cTemp := CODE128_CODES[ 106 ]
         nSum := 105
      ELSE
         FOR n := 1 TO Len( cCode )
            nCount += iif( SubStr( cCode, n, 1 ) > 31, 1, 0 ) // number of control chars
         NEXT
         IF nCount < Len( cCode ) / 2
            lCodeA := .T.
            cTemp := CODE128_CODES[ 104 ]
            nSum := 103
         ELSE
            cTemp := CODE128_CODES[ 105 ]
            nSum := 104
         ENDIF
      ENDIF
   ELSE
      IF cMode == 'C'
         lCodeC := .T.
         cTemp := CODE128_CODES[ 106 ]
         nSum := 105
      ELSEIF cMode == 'A'
         lCodeA := .T.
         cTemp := CODE128_CODES[ 104 ]
         nSum := 103
      ELSE
         cTemp := CODE128_CODES[ 105 ]
         nSum := 104
      ENDIF
   ENDIF

   nCount := 0                         // registered char
   FOR n := 1 TO Len( cCode )
      nCount++
      cCar := SubStr( cCode, n, 1 )
      IF lCodeC
         IF Len( cCode ) == n           // last character
            CTemp += CODE128_CODES[ 101 ]      // SHIFT Code B
            nCar := Asc( cCar ) - 31
         ELSE
            nCar := Val( SubStr( cCode, n, 2 ) ) + 1
            n++
         ENDIF
      ELSEIF lCodeA
         IF cCar > '_'                 // Shift Code B
            cTemp += CODE128_CODES[ 101 ]
            nCar := Asc( cCar ) - 31
         ELSEIF cCar <= ' '
            nCar := Asc( cCar ) + 64
         ELSE
            nCar := Asc( cCar ) - 31
         ENDIF
      ELSE                             // code B standard
         IF cCar <= ' '                // shift code A
            cTemp += CODE128_CODES[ 102 ]
            nCar := Asc( cCar ) + 64
         ELSE
            nCar := Asc( cCar ) - 31
         ENDIF
      ENDIF
      nSum += ( nCar - 1 ) * nCount
      cTemp := cTemp + CODE128_CODES[ nCar ]
   NEXT
   nSum := nSum % 103 + 1
   cTemp := cTemp + CODE128_CODES[ nSum ] + CODE128_CODES[ 107 ]
   cBarcode := ''
   FOR n := 1 TO Len( cTemp ) STEP 2
      cBarcode += Replicate( '1', Val( SubStr( cTemp, n, 1 ) ) )
      cBarcode += Replicate( '0', Val( SubStr( cTemp, n + 1, 1 ) ) )
   NEXT

   RETURN cBarcode

#define CODE3_9_CODES { '1110100010101110', ;
                        '1011100010101110', ;
                        '1110111000101010', ;
                        '1010001110101110', ;
                        '1110100011101010', ;
                        '1011100011101010', ;
                        '1010001011101110', ;
                        '1110100010111010', ;
                        '1011100010111010', ;
                        '1010001110111010', ;
                        '1110101000101110', ;
                        '1011101000101110', ;
                        '1110111010001010', ;
                        '1010111000101110', ;
                        '1110101110001010', ; //E
                        '1011101110001010', ;
                        '1010100011101110', ;
                        '1110101000111010', ;
                        '1011101000111010', ;
                        '1010111000111010', ;
                        '1110101010001110', ; //K
                        '1011101010001110', ;
                        '1110111010100010', ;
                        '1010111010001110', ;
                        '1110101110100010', ;
                        '1011101110100010', ; //P
                        '1010101110001110', ;
                        '1110101011100010', ;
                        '1011101011100010', ;
                        '1010111011100010', ;
                        '1110001010101110', ;
                        '1000111010101110', ;
                        '1110001110101010', ;
                        '1000101110101110', ;
                        '1110001011101010', ;
                        '1000111011101010', ; //Z
                        '1000101011101110', ;
                        '1110001010111010', ;
                        '1000111010111010', ; // ' '
                        '1000101110111010', ;
                        '1000100010100010', ;
                        '1000100010100010', ;
                        '1000101000100010', ;
                        '1010001000100010'}

#define CODE3_9_CHARS '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ-. *$/+%'

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _Code3_9( cCode, lCheck, lShowErrors )

   LOCAL cCar, m, n, cBarcode := '', nCheck := 0

   DEFAULT lShowErrors TO .T.
   IF ValType( cCode ) != 'C'
      IF lShowErrors
         MsgStop( _OOHG_Messages( 12, 42 ), _OOHG_Messages( 12, 12 ) )
      ENDIF
      RETURN NIL
   ENDIF
   DEFAULT lCheck TO .F.

   cCode := Upper( cCode )
   IF Len( cCode ) > 32
      cCode := Left( cCode, 32 )
   ENDIF
   cCode := '*' + cCode + '*'
   FOR n := 1 TO Len( cCode )
      cCar := SubStr( cCode, n, 1 )
      m := At( cCar, CODE3_9_CHARS )
      IF n > 0              // Other characters are ignored
         cBarcode := cBarcode + CODE3_9_CODES[ m ]
         nCheck += ( m - 1 )
     ENDIF
   NEXT

   IF lCheck
      cBarcode += CODE3_9_CODES[ nCheck % 43 + 1 ]
   ENDIF

   RETURN cBarcode

#define EAN_RIGHT "1110010110011011011001000010101110010011101010000100010010010001110100"
#define EAN_LEFT1 "0001101001100100100110111101010001101100010101111011101101101110001011"
#define EAN_LEFT2 "0100111011001100110110100001001110101110010000101001000100010010010111"
#define EAN_FIRST "ooooooooeoeeooeeoeooeeeooeooeeoeeooeoeeeoooeoeoeoeoeeooeeoeo"

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _Ean13( cCode, lShowErrors )

   LOCAL cBarcode, nChar, cLeft, cRight, cString, cMask, k, n

   DEFAULT lShowErrors TO .T.
   IF ValType( cCode ) != 'C'
      IF lShowErrors
         MsgStop( _OOHG_Messages( 12, 42 ), _OOHG_Messages( 12, 12 ) )
      ENDIF
      RETURN NIL
   ENDIF

   k := Left( AllTrim( cCode ) + '000000000000', 12 )
   k := k + Ean13_Check( k )                           // Check digit

   cRight := SubStr( k, 8, 6)
   cLeft := SubStr( k, 2, 6)
   cMask := SubStr( EAN_FIRST, ( Val( SubStr( k, 1, 1 ) ) * 6 ) + 1, 6 )

   // delimiter
   cBarcode := "101"

   // left part
   FOR n := 1 TO 6
      nChar := Val( SubStr( cLeft, n, 1 ) )
      IF SubStr( cMask, n, 1 ) == "o"
         cString := SubStr( EAN_LEFT1, nChar * 7 + 1, 7 )
      ELSE
         cString := SubStr( EAN_LEFT2, nChar * 7 + 1, 7 )
      ENDIF
      cBarcode := cBarcode + cString
   NEXT

   // delimiter
   cBarcode := cBarcode + "01010"

   // right part
   FOR n := 1 TO 6
      nChar := Val( SubStr( cRight, n, 1 ) )
      cString := SubStr( EAN_RIGHT, nChar * 7 + 1, 7 )
      cBarcode := cBarcode + cString
   NEXT

   // delimiter
   cBarcode := cBarcode + "101"

   RETURN cBarcode

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION Ean13_Check( cCode )

   LOCAL s1, s2, l, nControl, n

   s1 := 0                                // odd positions sum
   s2 := 0                                // even positions sum
   FOR n := 1 TO 6
      s1 := s1 + Val( SubStr( cCode, ( n * 2 ) - 1, 1 ) )
      s2 := s2 + Val( SubStr( cCode, ( n * 2), 1 ) )
   NEXT

   nControl := ( s2 * 3 ) + s1
   l := 10
   DO WHILE nControl > l
      l := l + 10
   ENDDO
   nControl := l - nControl

   RETURN Str( nControl, 1, 0)

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _Ean13bl( nLen )

   nLen := Int( nLen / 2 )

   RETURN '101' + Replicate( '0', nLen * 7 ) + '01010' + Replicate( '0', nLen * 7) + '101'

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _Upc( cCode, nLen )

   LOCAL n, cBarcode, nChar, cLeft, cRight, k

   DEFAULT cCode TO '0'
   DEFAULT nLen TO 11
   nLen := iif( nLen == 11, 11, 7 )               // valid values for nLen are 11 and 7

   k := Left( AllTrim( cCode ) + '000000000000', nLen )
   k := k + Upc_Check( cCode, nLen )                                 // check digit

   nLen++
   cRight := Right( k, nLen / 2 )
   cLeft := Left( k, nLen / 2 )

   // delimiter
   cBarcode := "101"

   // left part
   FOR n := 1 TO Len( cLeft )
      nChar := Val( SubStr( cLeft, n, 1 ) )
      cBarcode += SubStr( EAN_LEFT1, nChar * 7 + 1, 7 )
   NEXT
   cBarcode := cBarcode + "01010"

   // right part
   FOR n := 1 TO Len( cRight )
      nChar := Val( SubStr( cRight, n, 1 ) )
      cBarcode += SubStr( EAN_RIGHT, nChar * 7 + 1, 7 )
   NEXT

   // delimiter
   cBarcode := cBarcode + "101"

   RETURN cBarcode

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _Upcabl()

   LOCAL cBarcode

   // delimiter
   cBarcode := "101"

   // left part
   // cBarcode += SubStr( EAN_LEFT1, Val( Left( k, 1 ) ) * 7 + 1, 7 )
   cBarcode += Replicate( '0', 42 )

   // delimiter
   cBarcode := cBarcode + "01010"

   // right part
   cBarcode += Replicate( '0', 42 )
   // cBarcode += SubStr( EAN_RIGHT, Val( Right( k, 1 ) ) * 7 + 1, 7 )

   // delimiter
   cBarcode := cBarcode + "101"

   RETURN cBarcode

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION Upc_Check( cCode, nLen )

   LOCAL s1, s2, n, l, nControl

   s1 := 0                                         // odd positions sum
   s2 := 0                                         // even positions sum
   FOR n := 1 TO nLen step 2
      s1 := s1 + Val( SubStr( cCode, n, 1 ) )
      s2 := s2 + Val( SubStr( cCode, n + 1, 1 ) )
   NEXT

   nControl := ( s1 * 3 ) + s2
   l := 10
   DO WHILE nControl > l
      l := l + 10
   ENDDO
   nControl := l - nControl

   RETURN Str( nControl, 1, 0 )

#define EAN_PARITY [eeoooeoeooeooeoeoooeoeeooooeeooooeeoeoeooeooeooeoe]

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _Sup5( cCode, lShowErrors )
// EAN 5 digit supplement

   LOCAL k, cControl, n, cBarcode := '1011', nCar

   DEFAULT lShowErrors TO .T.
   IF ValType( cCode ) != 'C'
      IF lShowErrors
         MsgStop( _OOHG_Messages( 12, 42 ), _OOHG_Messages( 12, 12 ) )
      ENDIF
      RETURN NIL
   ENDIF
   k := Left( AllTrim( cCode ) + '00000', 5 )
   cControl := Right( Str( Val( SubStr( k, 1, 1 ) ) * 3 + ;
                           Val( SubStr( k, 3, 1 ) ) * 3 + ;
                           Val( SubStr( k, 5, 1 ) ) * 3 + ;
                           Val( SubStr( k, 2, 1 ) ) * 9 + ;
                           Val( SubStr( k, 4, 1 ) ) * 9, 5, 0 ), 1 )
   cControl := SubStr( EAN_FIRST, Val( cControl ) * 6 + 2, 5 )

   FOR n := 1 TO 5
      nCar := Val( SubStr( k, n, 1 ) )
      IF SubStr( cControl, n, 1 ) == 'o'
         cBarcode += SubStr( EAN_LEFT2, nCar * 7 + 1, 7 )
      ELSE
         cBarcode += SubStr( EAN_LEFT1, nCar * 7 + 1, 7 )
      ENDIF
      IF n < 5
         cBarcode += '01'
      ENDIF
   NEXT

   RETURN cBarcode

#define CODE25_CODES { "00110", ;
                       "10001", ;
                       "01001", ;
                       "11000", ;
                       "00101", ;
                       "10100", ;
                       "01100", ;
                       "00011", ;
                       "10010", ;
                       "01010" }

// Code 25 interleaved

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _Int25( cCode, lMode, lShowErrors )

   LOCAL n, cBarCode :='', cLeft, cRight, nLen, nCheck := 0, cPre, m

   DEFAULT lShowErrors TO .T.
   IF ValType( cCode ) != 'C'
      IF lShowErrors
         MsgStop( _OOHG_Messages( 12, 42 ), _OOHG_Messages( 12, 12 ) )
      ENDIF
      RETURN NIL
   ENDIF
   DEFAULT lMode TO .T.

   cCode := Transform( cCode, '@9' )     // get rid of characters
   nLen := Len( cCode )
   IF ( nLen % 2 == 1 .AND. ! lMode )
      nLen++
      cCode += '0'
   ENDIF

   IF lMode
      IF nLen % 2 == 0
         nLen++
         cCode := '0' + cCode
      ENDIF
      FOR n := 1 TO Len( cCode ) STEP 2
         nCheck += Val( SubStr( cCode, n, 1 ) ) * 3 + Val( SubStr( cCode, n + 1, 1 ) )
      NEXT
      cCode += Right( Str( nCheck, 10, 0), 1 )
   ENDIF

   cPre := '0000'                                                     // Start
   FOR n := 1 TO nLen STEP 2
      cLeft := CODE25_CODES[ Val( SubStr( cCode, n, 1 ) ) + 1 ]
      cRight := CODE25_CODES[ Val( SubStr( cCode, n + 1, 1 ) ) + 1 ]
      FOR m := 1 TO 5
         cPre += SubStr( cLeft, m, 1 ) + SubStr( cRight, m, 1 )
      NEXT
   NEXT
   cPre += '100'                                                      // Stop

   FOR n := 1 TO Len( cPre ) STEP 2
      IF SubStr( cPre, n, 1 ) == '1'
         cBarCode += '111'
      ELSE
         cBarCode += '1'
      ENDIF
      IF SubStr( cPre, n + 1, 1 ) == '1'
         cBarCode += '000'
      ELSE
         cBarCode += '0'
      ENDIF
   NEXT

   RETURN cBarCode

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _Mat25( cCode, lCheck, lShowErrors )
// Matrix 25

   LOCAL cPre, cBarcode := '', nCheck, n

   DEFAULT lShowErrors TO .T.
   IF ValType( cCode ) != 'C'
      IF lShowErrors
         MsgStop( _OOHG_Messages( 12, 42 ), _OOHG_Messages( 12, 12 ) )
      ENDIF
      RETURN NIL
   ENDIF
   DEFAULT lCheck TO .F.

   cCode := Transform( cCode, '@9' ) // get rid of characters
   IF lCheck
      FOR n := 1 TO Len( cCode ) STEP 2
           nCheck += Val( SubStr( cCode, n, 1 ) ) * 3 + Val( SubStr( cCode, n + 1, 1 ) )
      NEXT
      cCode += Right( Str( nCheck, 10, 0 ), 1 )
   ENDIF

   cPre := '10000'                                             // matrix start
   FOR n := 1 TO Len( cCode )
      cPre += CODE25_CODES[ Val( SubStr( cCode, n, 1 ) ) + 1 ] + '0'
   NEXT
   cPre += '10000'                                             // matrix stop

   FOR n := 1 TO Len( cPre ) STEP 2
      IF SubStr( cPre, n, 1 ) == '1'
         cBarcode += '111'
      ELSE
         cBarcode += '1'
      ENDIF
      IF SubStr( cPre, n + 1, 1) == '1'
         cBarcode+='000'
      ELSE
         cBarcode+='0'
      ENDIF
   NEXT

   RETURN cBarcode

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _Ind25( cCode, lCheck, lShowErrors )
// Industrial 25

   LOCAL cPre, cBarCode := '', nCheck, n

   DEFAULT lShowErrors TO .T.
   IF ValType( cCode ) != 'C'
      IF lShowErrors
         MsgStop( _OOHG_Messages( 12, 42 ), _OOHG_Messages( 12, 12 ) )
      ENDIF
      RETURN NIL
   ENDIF
   DEFAULT lCheck TO .F.

   cCode := Transform( cCode, '@9' ) // // get rid of characters
   IF lCheck
      FOR n :=1 TO Len( cCode ) STEP 2
         nCheck += Val( SubStr( cCode, n, 1 ) ) * 3 + Val( SubStr( cCode, n + 1, 1 ) )
      NEXT
      cCode += Right( Str( nCheck, 10, 0), 1 )
   ENDIF

   // preencoding
   cPre := '110'                                         // industrial 2 of 5,  start code
   FOR n := 1 TO Len( cCode )
      cPre += CODE25_CODES[ Val( Substr( cCode, n, 1 ) ) + 1 ] + '0'
   NEXT
   cPre += '101'                                         // industrial 2 of 5,  stop code

   // interleaving
   FOR n := 1 TO Len( cPre )
     IF substr( cPre, n, 1 ) == '1'
         cBarCode += '1110'
     ELSE
         cBarCode += '10'
     ENDIF
   NEXT

   RETURN cBarCode


#pragma BEGINDUMP

#ifndef HB_OS_WIN_USED
   #define HB_OS_WIN_USED
#endif

#ifndef WINVER
   #define WINVER 0x0400
#endif
#if ( WINVER < 0x0400 )
   #undef WINVER
   #define WINVER 0x0400
#endif

#ifndef _WIN32_IE
   #define _WIN32_IE 0x0500
#endif
#if ( _WIN32_IE < 0x0500 )
   #undef _WIN32_IE
   #define _WIN32_IE 0x0500
#endif

#ifndef _WIN32_WINNT
   #define _WIN32_WINNT 0x0400
#endif
#if ( _WIN32_WINNT < 0x0400 )
   #undef _WIN32_WINNT
   #define _WIN32_WINNT 0x0400
#endif

#include <windows.h>
#include <winuser.h>
#include <wingdi.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include <olectl.h>
#include <ocidl.h>
#include <commctrl.h>
#include "oohg.h"

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GETPRINTERSINFO )
{
   DWORD dwSize = 0;
   DWORD dwPrinters = 0;
   DWORD i;
   char * pBuffer ;
   char * cBuffer ;
   PRINTER_INFO_5* pInfo5;
   DWORD level;
   DWORD flags;
   OSVERSIONINFO osvi;

   osvi.dwOSVersionInfoSize = sizeof( OSVERSIONINFO );
   GetVersionEx( &osvi );

   level = 5;
   flags = PRINTER_ENUM_LOCAL;

   EnumPrinters( flags, NULL, level, NULL, 0, &dwSize, &dwPrinters );

   pBuffer = (char *) GlobalAlloc( GPTR, dwSize );
   if ( pBuffer == NULL )
   {
      hb_retc( ",," );
      return;
   }
   EnumPrinters( flags, NULL, level, (BYTE *) pBuffer, dwSize, &dwSize, &dwPrinters );

   if ( dwPrinters == 0 )
   {
      hb_retc( ",," );
      return;
   }
   cBuffer = (char *) GlobalAlloc( GPTR, dwPrinters * 256 );

   if ( osvi.dwPlatformId == VER_PLATFORM_WIN32_NT )

   {
      pInfo5 = (PRINTER_INFO_5 *) pBuffer;

      for ( i = 0; i < dwPrinters; i++ )
      {
         strcat( cBuffer, pInfo5->pPrinterName );
         strcat( cBuffer, "," );
         strcat( cBuffer, pInfo5->pPortName );

         pInfo5++;

         if ( i < dwPrinters - 1 )
            strcat( cBuffer, ",," );
      }
   }

   hb_retc( cBuffer );
   GlobalFree( pBuffer );
   GlobalFree( cBuffer );
   return;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( PIXELSPERINCHX )
{
   HDC hDC;
   int iDPI;

   memset( &iDPI, 0, sizeof( iDPI ) );
   memset( &hDC, 0, sizeof( hDC ) );

   hDC = GetDC( HWND_DESKTOP );

   iDPI = GetDeviceCaps( hDC, LOGPIXELSX );

   ReleaseDC( HWND_DESKTOP, hDC );

   hb_retni( iDPI );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( PIXELSPERINCHY )
{
   HDC hDC;
   int iDPI;

   memset( &iDPI, 0, sizeof( iDPI ) );
   memset( &hDC, 0, sizeof( hDC ) );

   hDC = GetDC( HWND_DESKTOP );

   iDPI = GetDeviceCaps( hDC, LOGPIXELSY );

   ReleaseDC( HWND_DESKTOP, hDC );

   hb_retni( iDPI );
}

#pragma ENDDUMP
