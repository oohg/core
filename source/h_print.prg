/*
 * $Id: h_print.prg $
 */
/*
 * ooHG source code:
 * TPrint object
 *
 * Copyright 2006-2019 Ciro Vargas C. <cvc@oohg.org> and contributors of
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


#include "fileio.ch"
#include "hbclass.ch"
#include "oohg.ch"
#include "i_windefs.ch"
#include "i_init.ch"
#include "miniprint.ch"

#define NO_HBPRN_DECLARATION
#include "winprint.ch"

MEMVAR _OOHG_PrintLibrary

#define hbprn ::oHBPrn
#define TEMP_FILE_NAME ( GetTempDir() + "T" + AllTrim( Str( Int( hb_Random( 999999 ) ), 8 ) ) + ".prn" )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION TPrint( cLibX )

   LOCAL oPrint

   IF cLibX == NIL .OR. ! ValType( cLibX ) == "C"
      IF Type( "_OOHG_PrintLibrary" ) == "C"
         cLibX := _OOHG_PrintLibrary
      ELSE
         cLibX := "MINIPRINT"
      ENDIF
   ENDIF

   IF cLibX == "HBPRINTER"
      oPrint := THBPrinter()
   ELSEIF cLibX == "MINIPRINT"
      oPrint := TMiniPrint()
   ELSEIF cLibX == "DOSPRINT"
      oPrint := TDosPrint()
   ELSEIF cLibX == "TXTPRINT"
      oPrint := TTxtPrint()
   ELSEIF cLibX == "EXCELPRINT"
      oPrint := TExcelPrint()
   ELSEIF cLibX == "CALCPRINT"
      oPrint := TCalcPrint()
   ELSEIF cLibX == "RTFPRINT"
      oPrint := TRtfPrint()
   ELSEIF cLibX == "CSVPRINT"
      oPrint := TCsvPrint()
   ELSEIF cLibX == "HTMLPRINT"
      oPrint := THtmlPrint()
   ELSEIF cLibX == "HTMLPRINTFROMCALC"
      oPrint := THtmlPrintFromCalc()
   ELSEIF cLibX == "HTMLPRINTFROMEXCEL"
      oPrint := THtmlPrintFromExcel()
   ELSEIF cLibX == "PDFPRINT"
      oPrint := TPdfPrint()
   ELSEIF cLibX == "RAWPRINT"
      oPrint := TRawPrint()
   ELSEIF cLibX == "SPREADSHEETPRINT"
      oPrint := TSpreadsheetPrint()
   ELSE
      oPrint := TMiniPrint()
   ENDIF

   RETURN oPrint

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TPrintBase

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
   DATA cPrintLibrary             INIT ""                    READONLY
   DATA cTempFile                 INIT TEMP_FILE_NAME        READONLY
   DATA cUnits                    INIT "ROWCOL"              READONLY
   DATA cVersion                  INIT "(oohg-tprint)V 4.20" READONLY
   DATA ImPreview                 INIT .T.                   READONLY
   DATA lDocIsOpen                INIT .F.                   READONLY
   DATA lFontBold                 INIT .F.                   READONLY
   DATA lFontItalic               INIT .F.                   READONLY
   DATA lFontStrikeout            INIT .F.                   READONLY
   DATA lFontUnderline            INIT .F.                   READONLY
   DATA lIgnorePropertyError      INIT .T.                   
   DATA lIndentAll                INIT .F.                   READONLY    // Indent RicheEdit lines
   DATA lLandscape                INIT .F.                   READONLY    // Page orientation
   DATA lNoErrMsg                 INIT .T.
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
   DATA nPreviewSize              INIT 2                     READONLY
   DATA nStage                    INIT 0                     READONLY
   DATA nTMargin                  INIT 0                     READONLY
   DATA nUnitsLin                 INIT 1                     READONLY
   DATA nvFij                     INIT ( 12 / 1.65 )         READONLY
   DATA nwPen                     INIT 0.1                   READONLY    // pen width in MM, do not exceed 1
   DATA oParent                   INIT NIL                   READONLY
   DATA oWinReport                INIT NIL                   READONLY

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
   METHOD IsDocOpen
   METHOD IsDocOpenX              INLINE ::lDocIsOpen
   METHOD Mat25
   METHOD MaxCol                  INLINE ::nMaxCol
   METHOD MaxRow                  INLINE ::nMaxRow
   METHOD NormalDos               BLOCK { || NIL }
   METHOD NormalDosX              BLOCK { || NIL }
   METHOD PrintBarcode
   METHOD PrintBarcodeX           BLOCK { || NIL }
   METHOD PrintBitmap
   METHOD PrintBitmapX            BLOCK { || NIL }
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
   METHOD PrintResource
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
   METHOD SetPreviewSizeX         BLOCK { |Self| ::nPreviewSize }
   METHOD SetProp
   METHOD SetRawPrinter
   METHOD SetSeparateSheets
   METHOD SetShowErrors
   METHOD SetTMargin
   METHOD SetUnits
   METHOD Sup5
   METHOD Upca
   METHOD Version                 INLINE ::cVersion

   MESSAGE PrintDos               METHOD PrintMode
   MESSAGE PrintRaw               METHOD PrintMode

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetIndentation( lIndentAll ) CLASS TPrintBase
   IF HB_ISLOGICAL( lIndentAll )
      ::lIndentAll := lIndentAll
   ENDIF

   RETURN ::lIndentAll

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetFontType( nFontType ) CLASS TPrintBase

   IF HB_ISNUMERIC( nFontType )
      IF nFontType == 0
         ::nFontType := 0
      ELSEIF nFontType == 1
         ::nFontType := 1
      ENDIF
   ENDIF

   RETURN ::nFontType

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetSeparateSheets( lSeparateSheets ) CLASS TPrintBase

   IF HB_ISLOGICAL( lSeparateSheets )
      ::lSeparateSheets := lSeparateSheets
   ENDIF

   RETURN ::lSeparateSheets

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetShowErrors( lShow ) CLASS TPrintBase

   IF HB_ISLOGICAL( lShow )
      ::lShowErrors := lShow
   ENDIF

   RETURN ::lShowErrors

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetPreviewSize( nSize ) CLASS TPrintBase

   RETURN ::SetPreviewSizeX( nSize )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetProp( lMode ) CLASS TPrintBase

   IF HB_ISLOGICAL( lMode )
      ::lProp := lMode
   ENDIF

   RETURN ::lProp

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetCpl( nCpl ) CLASS TPrintBase

   IF HB_ISNUMERIC( nCpl )
      DO CASE
      CASE nCpl <= 60
         ::nFontSize := 14
      CASE nCpl <= 80
         ::nFontSize := 12
      CASE nCpl <= 96
         ::nFontSize := 10
      CASE nCpl <= 120
         ::nFontSize := 8
      CASE nCpl <= 140
         ::nFontSize := 7
      CASE nCpl <= 160
         ::nFontSize := 6
      OTHERWISE
         ::nFontSize := 5
      ENDCASE
   ENDIF

   RETURN ::nFontSize

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Release() CLASS TPrintBase

   IF ::nStage > 0
      ::ReleaseX()
      ::nStage := 0
   ENDIF
   IF HB_ISOBJECT( ::oWinReport )
      ::oWinReport:Release()
   ENDIF
   TApplication():Define():WinMHRelease()

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Init( uParent, cLang ) CLASS TPrintBase

   LOCAL lOk

   IF ::nStage == 0
      IF ValType( uParent ) == "C"
         ::oParent := GetExistingFormObject( uParent )
      ELSE
         ::oParent := uParent
      ENDIF
      IF ( lOk := ::InitX( cLang ) )
         ::nStage := 1
      ENDIF
   ELSE
      IF ::lShowErrors
         MsgStop( _OOHG_Messages( MT_PRINTER, 1 ), _OOHG_Messages( MT_PRINTER, 12 ) )
      ENDIF
      lOk := .F.
   ENDIF

   RETURN lOk

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SelPrinter( lSelect, lPreview, lLandscape, nPaperSize, cPrinterX, lHide, nRes, nBin, nDuplex, lCollate, nCopies, lColor, nScale, nPaperLength, nPaperWidth, cLang ) CLASS TPrintBase

   IF ::lPrError
      IF ::lShowErrors
         MsgStop( _OOHG_Messages( MT_PRINTER, 49 ), _OOHG_Messages( MT_PRINTER, 12 ) )
      ENDIF
      RETURN .F.
   ENDIF

   ASSIGN lSelect    VALUE lSelect    TYPE "L" DEFAULT .T.
   ASSIGN lPreview   VALUE lPreview   TYPE "L" DEFAULT ::ImPreview
   ASSIGN lHide      VALUE lHide      TYPE "L" DEFAULT .F.

   ::ImPreview := lPreview
   ::lWinHide := lHide

   RETURN ::SelPrinterX( lSelect, lPreview, lLandscape, nPaperSize, cPrinterX, nRes, nBin, nDuplex, lCollate, nCopies, lColor, nScale, nPaperLength, nPaperWidth, cLang )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD IsDocOpen() CLASS TPrintBase

   RETURN ::IsDocOpenX()

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginDoc( cDocm ) CLASS TPrintBase

   LOCAL oLabel, cTitle, lOk

   IF ::lPrError
      IF ::lShowErrors
         MsgStop(  "BeginDoc: " + _OOHG_Messages( MT_PRINTER, 49 ), _OOHG_Messages( MT_PRINTER, 12 ) )
      ENDIF
      RETURN .F.
   ELSEIF ::nStage > 2
      IF ::IsDocOpen()   // Preview is open
         IF ::lShowErrors
            MsgStop(  "BeginDoc: " + _OOHG_Messages( MT_PRINTER, 46 ), _OOHG_Messages( MT_PRINTER, 12 ) )
         ENDIF
         RETURN .F.
      ELSE
         ::nStage := 1
      ENDIF
   ELSEIF ::nStage > 1   // Another BeginDoc is active
      IF ::lShowErrors
         MsgStop(  "BeginDoc: " + _OOHG_Messages( MT_PRINTER, 47 ), _OOHG_Messages( MT_PRINTER, 12 ) )
      ENDIF
      RETURN .F.
   ELSEIF ::nStage < 1    // TPrint object is not initialized
      IF ::lShowErrors
         MsgStop(  "BeginDoc: " + _OOHG_Messages( MT_PRINTER, 48 ), _OOHG_Messages( MT_PRINTER, 12 ) )
      ENDIF
      RETURN .F.
   ENDIF

   cTitle := _OOHG_Messages( MT_PRINTER, 2 )

   IF HB_ISSTRING( cDocm ) .AND. ! Empty( cDocm )
      ::Cargo := cDocm
   ENDIF

   SetPRC( 0, 0 )

   IF HB_ISOBJECT( ::oWinReport )
      IF ::lWinHide
         ::oWinReport:Hide()
      ELSE
         ::oWinReport:Show()
      ENDIF
   ELSE
      TApplication():Define():WinMHDefine()

      DEFINE WINDOW 0 OBJ ::oWinReport ;
         PARENT ( ::oParent ) ;
         AT 0, 0 ;
         WIDTH 300 HEIGHT 120 ;
         CHILD NOSIZE NOSYSMENU NOCAPTION

         @ 5, 5 FRAME 0 ;
            WIDTH ::oWinReport:ClientWidth - 10 ;
            HEIGHT ::oWinReport:ClientHeight - 10

         @ 45, 30 IMAGE 0 ;
            PICTURE 'ZZZ_PRINTICON' ;
            WIDTH 25 ;
            HEIGHT 30 ;
            STRETCH

         @ 45, 70 LABEL 0 OBJ oLabel ;
            VALUE cTitle ;
            WIDTH ::oWinReport:ClientWidth - 80 ;
            HEIGHT 30 ;
            VCENTERALIGN ;
            BOLD

         DEFINE TIMER 0 ;
            INTERVAL 800 ;
            ACTION { || oLabel:Visible := ! oLabel:Visible }

      END WINDOW

      IF ::lWinHide
         ::oWinReport:Hide()
      ELSE
         ::oWinReport:Show()
      ENDIF

      ::oWinReport:Center()
      ::oWinReport:Activate( .T. )
   ENDIF

   IF ( lOk := ::BeginDocX() )
      ::nStage := 2
   ENDIF

   RETURN lOk

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetLMargin( nLMar ) CLASS TPrintBase

   IF HB_ISNUMERIC( nLMar ) .AND. nLMar >= 0
      ::nLMargin := nLMar
   ENDIF

   RETURN ::nLMargin

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetTMargin( nTMar ) CLASS TPrintBase

   IF HB_ISNUMERIC( nTMar ) .AND. nTMar >= 0
      ::nTMargin := nTMar
   ENDIF

   RETURN ::nTMargin

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndDoc( lSaveTemp, lWait, lSize ) CLASS TPrintBase

   LOCAL lOk

   IF ::lPrError
      IF ::lShowErrors
         MsgStop(  "EndDoc: " + _OOHG_Messages( MT_PRINTER, 49 ), _OOHG_Messages( MT_PRINTER, 12 ) )
      ENDIF
      RETURN .F.
   ELSEIF ::nStage > 2
      IF ::IsDocOpen()   // Preview is open
         IF ::lShowErrors
            MsgStop( "EndDoc: " + _OOHG_Messages( MT_PRINTER, 46 ), _OOHG_Messages( MT_PRINTER, 12 ) )
         ENDIF
         RETURN .F.
      ELSE
         ::nStage := 1
      ENDIF
   ELSEIF ::nStage < 1    // TPrint object is not initialized
      IF ::lShowErrors
         MsgStop(  "EndDoc: " + _OOHG_Messages( MT_PRINTER, 48 ), _OOHG_Messages( MT_PRINTER, 12 ) )
      ENDIF
      RETURN .F.
   ELSEIF ::nStage < 2   // BeginDoc is missing
      IF ::lShowErrors
         MsgStop(  "EndDoc: " + _OOHG_Messages( MT_PRINTER, 50 ), _OOHG_Messages( MT_PRINTER, 12 ) )
      ENDIF
      RETURN .F.
   ENDIF

   ASSIGN ::lSaveTemp VALUE lSaveTemp TYPE "L" DEFAULT .F.
   ASSIGN lWait       VALUE lWait     TYPE "L" DEFAULT ::ImPreview
   ASSIGN lSize       VALUE lSize     TYPE "L" DEFAULT NIL

   IF ::ImPreview .AND. HB_ISOBJECT( ::oWinReport )
      ::oWinReport:Hide()
   ENDIF
   ::nStage := 3
   lOk := ::EndDocX( lWait, lSize )
   IF lWait
      ::nStage := 1
   ENDIF
   ::aPageNames := {}

   RETURN lOk

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetColor( atColor ) CLASS TPrintBase

   IF ArrayIsValidColor( atColor )
      ::aColor := atColor
      ::SetColorX()
   ENDIF

   RETURN ::aColor

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetBarColor( atColor ) CLASS TPrintBase

   IF ArrayIsValidColor( atColor )
      ::aBarColor := atColor
   ENDIF

   RETURN ::aBarColor

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetFont( cFont, nSize, aColor, lBold, lItalic, nAngle, lUnder, lStrike, nWidth ) CLASS TPrintBase

   ASSIGN cFont   VALUE cFont   TYPE "C" DEFAULT ::cFontName
   ASSIGN nSize   VALUE nSize   TYPE "N" DEFAULT ::nFontSize
   ASSIGN aColor  VALUE aColor  TYPE "A" DEFAULT ::aFontColor
   ASSIGN lBold   VALUE lBold   TYPE "L" DEFAULT ::lFontBold
   ASSIGN lItalic VALUE lItalic TYPE "L" DEFAULT ::lFontItalic
   ASSIGN nAngle  VALUE nAngle  TYPE "N" DEFAULT ::nFontAngle
   ASSIGN lUnder  VALUE lUnder  TYPE "L" DEFAULT ::lFontUnderline
   ASSIGN lStrike VALUE lStrike TYPE "L" DEFAULT ::lFontStrikeout
   ASSIGN nWidth  VALUE nWidth  TYPE "N" DEFAULT ::nFontWidth

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

   RETURN { ::cFontName, ::nFontSize, ::aFontColor, ::lFontBold, ::lFontItalic, ::nFontAngle, ::lFontUnderline, ::lFontStrikeout, ::nFontWidth }

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginPage( cName ) CLASS TPrintBase

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

   RETURN ::cPageName

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndPage() CLASS TPrintBase

   ::EndPageX()
   ::cPageName := ""

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GetDefPrinter() CLASS TPrintBase

   RETURN ::GetDefPrinterX()

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetUnits( cUnitsX, nUnitsLinX ) CLASS TPrintBase

   IF HB_ISSTRING( cUnitsX )
      IF Upper( cUnitsX ) == "MM"
         ::cUnits := "MM"
      ELSEIF Upper( cUnitsX ) == "ROWCOL"
         ::cUnits := "ROWCOL"
      ENDIF
   ENDIF
   IF HB_ISNUMERIC( nUnitsLinX ) .AND. nUnitsLinX >= 1
      ::nUnitsLin := nUnitsLinX
   ENDIF

   RETURN { ::cUnits, ::nUnitsLin }

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintData( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, lItalic, nAngle, lUnder, lStrike, nWidth ) CLASS TPrintBase

   LOCAL cText, cSpace, uAux, cType

   ASSIGN nLin    VALUE nLin    TYPE "N" DEFAULT 1
   ASSIGN nCol    VALUE nCol    TYPE "N" DEFAULT 1
   ASSIGN cFont   VALUE cFont   TYPE "C" DEFAULT ::cFontName
   ASSIGN nSize   VALUE nSize   TYPE "N" DEFAULT ::nFontSize
   ASSIGN lBold   VALUE lBold   TYPE "L" DEFAULT ::lFontBold
   ASSIGN aColor  VALUE aColor  TYPE "A" DEFAULT ::aFontColor
   ASSIGN cAlign  VALUE cAlign  TYPE "C" DEFAULT "L"
   ASSIGN nLen    VALUE nLen    TYPE "N" DEFAULT 15
   ASSIGN lItalic VALUE lItalic TYPE "L" DEFAULT ::lFontItalic
   ASSIGN nAngle  VALUE nAngle  TYPE "N" DEFAULT ::nFontAngle
   ASSIGN lUnder  VALUE lUnder  TYPE "L" DEFAULT ::lFontUnderline
   ASSIGN lStrike VALUE lStrike TYPE "L" DEFAULT ::lFontStrikeout
   ASSIGN nWidth  VALUE nWidth  TYPE "N" DEFAULT ::nFontWidth

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

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintBarcode( nLin, nCol, cBarcode, cType, aColor, lHori, nWidth, nHeight, lMode ) CLASS TPrintBase

   LOCAL nSize := 10

   ASSIGN nHeight  VALUE nHeight  TYPE "N" DEFAULT 10
   ASSIGN nWidth   VALUE nWidth   TYPE "N" DEFAULT NIL
   ASSIGN cBarcode VALUE cBarcode TYPE "C" DEFAULT ""
   ASSIGN lHori    VALUE lHori    TYPE "L" DEFAULT .T.
   ASSIGN aColor   VALUE aColor   TYPE "A" DEFAULT ::aBarColor
   ASSIGN cType    VALUE cType    TYPE "C" DEFAULT "CODE128C"
   ASSIGN nLin     VALUE nLin     TYPE "N" DEFAULT 1
   ASSIGN nCol     VALUE nCol     TYPE "N" DEFAULT 1

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
      ::Int25( nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2, cBarcode, aColor, lHori, nWidth, nHeight, lMode )
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

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Ean8( nRow, nCol, cCode, aColor, lHorz, nWidth, nHeigth ) CLASS TPrintBase

   ASSIGN nHeigth VALUE nHeigth TYPE "N" DEFAULT 1.5

   ::Go_Code( _Upc( cCode, 7 ), nRow, nCol, lHorz, aColor, nWidth, nHeigth * 0.90 )
   ::Go_Code( _Ean13bl( 8 ), nRow, nCol, lHorz, aColor, nWidth, nHeigth )

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Ean13( nRow, nCol, cCode, aColor, lHorz, nWidth, nHeigth ) CLASS TPrintBase

   ASSIGN nHeigth VALUE nHeigth TYPE "N" DEFAULT 1.5

   ::Go_Code( _Ean13( cCode, ::lShowErrors ), nRow, nCol, lHorz, aColor, nWidth, nHeigth * 0.90 )
   ::Go_Code( _Ean13bl( 12 ), nRow, nCol, lHorz, aColor, nWidth, nHeigth )

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Code128( nRow, nCol, cCode, cMode, aColor, lHorz, nWidth, nHeigth ) CLASS TPrintBase

   ::Go_Code( _Code128( cCode, cMode, ::lShowErrors ), nRow, nCol, lHorz, aColor, nWidth, nHeigth )

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Code3_9( nRow, nCol, cCode, aColor, lHorz, nWidth, nHeigth ) CLASS TPrintBase

   ::Go_Code( _Code3_9( cCode, .T., ::lShowErrors ), nRow, nCol, lHorz, aColor, nWidth, nHeigth )

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Int25( nRow, nCol, cCode, aColor, lHorz, nWidth, nHeigth, lMode ) CLASS TPrintBase

   ASSIGN lMode VALUE lMode TYPE "L" DEFAULT .T.

   ::Go_Code( _Int25( cCode, lMode, ::lShowErrors ), nRow, nCol, lHorz, aColor, nWidth, nHeigth )

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Upca( nRow, nCol, cCode, aColor, lHorz, nWidth, nHeigth ) CLASS TPrintBase

   ASSIGN nHeigth VALUE nHeigth TYPE "N" DEFAULT 1.5

   ::Go_Code( _Upc( cCode ), nRow, nCol, lHorz, aColor, nWidth, nHeigth * 0.90 )
   ::Go_Code( _Upcabl( cCode ), nRow, nCol, lHorz, aColor, nWidth, nHeigth )

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Sup5( nRow, nCol, cCode, aColor, lHorz, nWidth, nHeigth ) CLASS TPrintBase

   ::Go_Code( _Sup5( cCode, ::lShowErrors ), nRow, nCol, lHorz, aColor, nWidth, nHeigth )

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Codabar( nRow, nCol, cCode, aColor, lHorz, nWidth, nHeigth ) CLASS TPrintBase

   ::Go_Code( _Codabar( cCode, ::lShowErrors ), nRow, nCol, lHorz, aColor, nWidth, nHeigth )

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Ind25( nRow, nCol, cCode, aColor, lHorz, nWidth, nHeigth ) CLASS TPrintBase

   ::Go_Code( _Ind25( cCode, .T., ::lShowErrors ), nRow, nCol, lHorz, aColor, nWidth, nHeigth )

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Mat25( nRow, nCol, cCode, aColor, lHorz, nWidth, nHeigth ) CLASS TPrintBase

   ::Go_Code( _Mat25( cCode, .T., ::lShowErrors ), nRow, nCol, lHorz, aColor, nWidth, nHeigth )

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Go_Code( cBarcode, ny, nx, lHorz, aColor, nWidth, nLen ) CLASS TPrintBase

   LOCAL n

   ASSIGN ny     VALUE ny     TYPE "N" DEFAULT 0
   ASSIGN nx     VALUE nx     TYPE "N" DEFAULT 0
   ASSIGN aColor VALUE aColor TYPE "A" DEFAULT { 0, 0, 0 }
   ASSIGN lHorz  VALUE lHorz  TYPE "L" DEFAULT .T.
   ASSIGN nWidth VALUE nWidth TYPE "N" DEFAULT 0.495           // 1/3 M/mm 0.25 width
   ASSIGN nLen   VALUE nLen   TYPE "N" DEFAULT 15              // mm height

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

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintResource( nLin, nCol, nLinF, nColF, cResource, aResol, aSize, aExt, lNoDIB, lNo3DC, lNoTra, lNoChk ) CLASS TPrintBase

   LOCAL nAttrib, aPictSize, lSet, hBitmap

   // This is the same code used by method Picture of class TImage.
   IF ValType( cResource ) $ "CM"
      ASSIGN lNoDIB VALUE lNoDIB TYPE "L" DEFAULT .F.
      ASSIGN lNo3DC VALUE lNo3DC TYPE "L" DEFAULT .F.
      ASSIGN lNoTra VALUE lNoTra TYPE "L" DEFAULT .F.
      ASSIGN lNoChk VALUE lNoChk TYPE "L" DEFAULT .F.

      IF lNoDIB
         nAttrib := LR_DEFAULTCOLOR
         IF ! lNo3DC .OR. ! lNoTra
            IF lNoChk
               lSet := .T.
            ELSE
               aPictSize := _OOHG_SizeOfBitmapFromFile( cResource )      // {width, height, depth}
               lSet := aPictSize[ 3 ] <= 8
            ENDIF
            IF lSet
              IF ! lNo3DC
                 nAttrib += LR_LOADMAP3DCOLORS
              ENDIF
              IF ! lNoTra
                 nAttrib += LR_LOADTRANSPARENT
              ENDIF
            ENDIF
         ENDIF
      ELSE
         nAttrib := LR_CREATEDIBSECTION
      ENDIF
      hBitmap := _OOHG_BitmapFromFile( NIL, cResource, nAttrib, .F. )

      ::PrintBitmap( nLin, nCol, nLinF, nColF, hBitmap, aResol, aSize, aExt )
      DeleteObject( hBitmap )
   ENDIF

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintBitmap( nLin, nCol, nLinF, nColF, hBitmap, aResol, aSize, aExt ) CLASS TPrintBase

   IF ! ValidHandler( hBitmap )
      RETURN .F.
   ENDIF

   ASSIGN nLin  VALUE nLin  TYPE "N" DEFAULT 1
   ASSIGN nCol  VALUE nCol  TYPE "N" DEFAULT 1
   ASSIGN nLinF VALUE nLinF TYPE "N" DEFAULT 4
   ASSIGN nColF VALUE nColF TYPE "N" DEFAULT 4

   IF ! HB_ISARRAY( aExt )
      aExt := { nLinF, nColF }
   ELSE
      IF Len( aExt ) < 2
         aExt := ASize( aExt, 2 )
      ENDIF
      IF ! HB_ISNUMERIC( aExt[ 1 ] ) .OR. aExt[ 1 ] < nLinF
         aExt[ 1 ] := nLinF
      ENDIF
      IF ! HB_ISNUMERIC( aExt[ 2 ] ) .OR. aExt[ 2 ] < nColF
         aExt[ 2 ] := nColF
      ENDIF
   ENDIF

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

   ::PrintBitmapX( ::nTMargin + nLin, ::nLMargin + nCol, ::nTMargin + nLinF, ::nLMargin + nColF, hBitmap, aResol, aSize, aExt )

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintImage( nLin, nCol, nLinF, nColF, cImage, aResol, aSize, aExt ) CLASS TPrintBase

   ASSIGN nLin   VALUE nLin   TYPE "N" DEFAULT 1
   ASSIGN nCol   VALUE nCol   TYPE "N" DEFAULT 1
   ASSIGN cImage VALUE cImage TYPE "C" DEFAULT ""
   ASSIGN nLinF  VALUE nLinF  TYPE "N" DEFAULT 4
   ASSIGN nColF  VALUE nColF  TYPE "N" DEFAULT 4

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

   ::PrintImageX( ::nTMargin + nLin, ::nLMargin + nCol, ::nTMargin + nLinF, ::nLMargin + nColF, cImage, aResol, aSize, aExt )

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintLine( nLin, nCol, nLinF, nColF, atColor, ntwPen, lSolid ) CLASS TPrintBase

   ASSIGN nLin    VALUE nLin    TYPE "N" DEFAULT 1
   ASSIGN nCol    VALUE nCol    TYPE "N" DEFAULT 1
   ASSIGN nLinF   VALUE nLinF   TYPE "N" DEFAULT 4
   ASSIGN nColF   VALUE nColF   TYPE "N" DEFAULT 4
   ASSIGN atColor VALUE atColor TYPE "A" DEFAULT ::aColor
   ASSIGN ntwPen  VALUE ntwPen  TYPE "N" DEFAULT ::nwPen
   ASSIGN lSolid  VALUE lSolid  TYPE "L" DEFAULT .T.

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

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintRectangle( nLin, nCol, nLinF, nColF, atColor, ntwPen, lSolid, arColor ) CLASS TPrintBase

   ASSIGN nLin    VALUE nLin    TYPE "N" DEFAULT 1
   ASSIGN nCol    VALUE nCol    TYPE "N" DEFAULT 1
   ASSIGN nLinF   VALUE nLinF   TYPE "N" DEFAULT 4
   ASSIGN nColF   VALUE nColF   TYPE "N" DEFAULT 4
   ASSIGN atColor VALUE atColor TYPE "A" DEFAULT ::aColor
   ASSIGN ntwPen  VALUE ntwPen  TYPE "N" DEFAULT ::nwPen
   ASSIGN lSolid  VALUE lSolid  TYPE "L" DEFAULT .T.
   ASSIGN arColor VALUE arColor TYPE "A" DEFAULT NIL

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

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintRoundRectangle( nLin, nCol, nLinF, nColF, atColor, ntwPen, lSolid, arColor ) CLASS TPrintBase

   ASSIGN nLin    VALUE nLin    TYPE "N" DEFAULT 1
   ASSIGN nCol    VALUE nCol    TYPE "N" DEFAULT 1
   ASSIGN nLinF   VALUE nLinF   TYPE "N" DEFAULT 4
   ASSIGN nColF   VALUE nColF   TYPE "N" DEFAULT 4
   ASSIGN atColor VALUE atColor TYPE "A" DEFAULT ::aColor
   ASSIGN ntwPen  VALUE ntwPen  TYPE "N" DEFAULT ::nwPen
   ASSIGN lSolid  VALUE lSolid  TYPE "L" DEFAULT .T.
   ASSIGN arColor VALUE arColor TYPE "A" DEFAULT NIL

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

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintMode( cFile ) CLASS TPrintBase

   ::PrintModeX( cFile )

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetDosPort( cPort ) CLASS TPrintBase

   LOCAL nPos, cAux, lFound, i

   IF HB_ISSTRING( cPort ) .AND. ! Empty( cPort )
      IF cPort $ "PRN LPT1: LPT2: LPT3: LPT4: LPT5: LPT6:"
         ::cPort := cPort
      ELSE
         lFound := .F.
         ::aPorts := ASort( aLocalPorts() )
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
         ENDIF
      ENDIF
   ENDIF

   RETURN ::cPort

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetRawPrinter( cPrinter ) CLASS TPrintBase

   IF HB_ISSTRING( cPrinter )
      IF Empty( cPrinter )
         ::cPrinter := GetDefaultPrinter()
      ELSE
         ::aPrinters := ASort( _HMG_PRINTER_aPrinters() )
         IF AScan( ::aPrinters, cPrinter ) > 0
            ::cPrinter := cPrinter
         ELSE
            ::cPrinter := GetDefaultPrinter()
         ENDIF
      ENDIF
   ENDIF

   RETURN ::cPrinter


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TMiniPrint FROM TPrintBase

   DATA Type                      INIT "MINIPRINT"           READONLY

   METHOD BeginDocX
   METHOD BeginPageX
   METHOD EndDocX
   METHOD EndPageX
   METHOD GetDefPrinterX
   METHOD InitX
   METHOD IsDocOpenX
   METHOD MaxCol
   METHOD MaxRow
   METHOD PrintBarcodeX
   METHOD PrintBitmapX
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
METHOD MaxCol() CLASS TMiniPrint

   LOCAL hdcPrint, nCol

   hdcPrint := OpenPrinterGetDC()

   IF hdcPrint == 0
      nCol := 0
   ELSEIF ::cUnits == "MM"
      nCol := _HMG_PRINTER_GETPAGEWIDTH() - 1
   ELSE
      nCol := _HMG_PRINTER_GETMAXCOL( hdcPrint, ::cFontName, ::nFontSize, ::nFontWidth, ::nFontAngle, ::lFontBold, ::lFontItalic, ::lFontUnderline, ::lFontStrikeout )
   ENDIF

   RETURN nCol

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD MaxRow() CLASS TMiniPrint

   LOCAL hdcPrint, nRow

   hdcPrint := OpenPrinterGetDC()

   IF hdcPrint == 0
      nRow := 0
   ELSEIF ::cUnits == "MM"
      nRow := _HMG_PRINTER_GETPAGEHEIGHT() - 1
   ELSE
      nRow := _HMG_PRINTER_GETMAXROW( hdcPrint, ::cFontName, ::nFontSize, ::nFontWidth, ::nFontAngle, ::lFontBold, ::lFontItalic, ::lFontUnderline, ::lFontStrikeout )
   ENDIF

   RETURN nRow

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetPreviewSizeX( nSize ) CLASS TMiniPrint

   IF _HMG_PRINTER_Preview
      IF nSize == NIL .OR. nSize < -9.99 .OR. nSize > 99.99
         nSize := 0
      ENDIF
      ::nPreviewSize := nSize
      SET PREVIEW ZOOM nSize
   ENDIF

   RETURN ::nPreviewSize

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintBarcodeX( y, x, y1, x1, aColor ) CLASS TMiniPrint

   @ y, x PRINT FILL TO y1, x1 COLOR aColor

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InitX( cLang ) CLASS TMiniPrint

   _HMG_PRINTER_InitUserMessages( cLang )
   ::aPrinters := _HMG_PRINTER_aPrinters()
   ::cPrintLibrary := "MINIPRINT"
   ::lPrError := .F.

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginDocX() CLASS TMiniPrint

   START PRINTDOC NAME ::Cargo

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndDocX( lWait, lSize ) CLASS TMiniPrint

   ASSIGN lWait VALUE lWait TYPE "L" DEFAULT ::ImPreview
   ASSIGN lSize VALUE lSize TYPE "L" DEFAULT .T.
   IF lSize
      IF lWait .OR. ! HB_ISOBJECT( ::oWinReport )
         END PRINTDOC
         ::lDocIsOpen := .F.
      ELSE
         END PRINTDOC NOWAIT PARENT ( ::oWinReport:Name )
         ::lDocIsOpen := .T.
         DEFINE TIMER 0 ;
            PARENT ( ::oWinReport:Name ) ;
            INTERVAL 800 ;
            ACTION { || iif( ::IsDocOpen(), NIL, ::Release() ) }
      ENDIF
   ELSE
      IF lWait .OR. ! HB_ISOBJECT( ::oWinReport )
         END PRINTDOC NOSIZE
         ::lDocIsOpen := .F.
      ELSE
         END PRINTDOC NOWAIT NOSIZE PARENT ( ::oWinReport:Name )
         ::lDocIsOpen := .T.
         DEFINE TIMER 0 ;
            PARENT ( ::oWinReport:Name ) ;
            INTERVAL 800 ;
            ACTION { || iif( ::IsDocOpen(), NIL, ::Release() ) }
      ENDIF
   ENDIF

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD IsDocOpenX() CLASS TMiniPrint

   IF ::lDocIsOpen
      IF ! IsWindowDefined( "_HMG_PRINTER_AUXIL" )
         ::lDocIsOpen := .F.
      ENDIF
   ENDIF

   RETURN ::lDocIsOpen

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginPageX() CLASS TMiniPrint

   START PRINTPAGE

   RETURN ::cPageName

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndPageX() CLASS TMiniPrint

   END PRINTPAGE

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ReleaseX() CLASS TMiniPrint

   IF ! ::IsDocOpen()
      RELEASE _HMG_MiniPrint
   ENDIF

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintDataX( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, cText, lItalic, nAngle, lUnder, lStrike, nWidth ) CLASS TMiniPrint

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

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintBitmapX( nLin, nCol, nLinF, nColF, hBitmap, aResol, aSize, aExt ) CLASS TMiniPrint

   HB_SYMBOL_UNUSED( aResol )
   HB_SYMBOL_UNUSED( aExt )

   // Coordinates of the rectangle for the first copy of the image.
   ASSIGN nLin  VALUE nLin  TYPE "N" DEFAULT 1   // Start row
   ASSIGN nCol  VALUE nCol  TYPE "N" DEFAULT 1   // Start col
   ASSIGN nLinF VALUE nLinF TYPE "N" DEFAULT 4   // End row
   ASSIGN nColF VALUE nColF TYPE "N" DEFAULT 4   // End col
   ASSIGN aSize VALUE aSize TYPE "L" DEFAULT .F.

   // Coordinates of the lower right corner of the extension rectangle.
   // It will be filled with as many additional copies of the image as they fit.
   ASSIGN aExt  VALUE aExt  TYPE "A" DEFAULT { nLinF, nColF }

   IF ::cUnits == "MM"
      IF aSize
         @ nLin, nCol PRINT BITMAP hBitmap IMAGESIZE
      ELSE
         @ nLin, nCol PRINT BITMAP hBitmap WIDTH ( nColF - nCol ) HEIGHT ( nLinF - nLin )
      ENDIF
   ELSE
      IF aSize
         @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT BITMAP hBitmap IMAGESIZE
      ELSE
         @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT BITMAP hBitmap ;
            WIDTH ( nColF - nCol ) * ::nmHor HEIGHT ( nLinF - nLin ) * ::nmVer
      ENDIF
   ENDIF

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintImageX( nLin, nCol, nLinF, nColF, cImage, aResol, aSize, aExt ) CLASS TMiniPrint

   HB_SYMBOL_UNUSED( aResol )
   HB_SYMBOL_UNUSED( aExt )

   ASSIGN aSize VALUE aSize TYPE "L" DEFAULT .F.

   IF aSize
      IF ::cUnits == "MM"
         @ nLin, nCol PRINT IMAGE cImage IMAGESIZE
      ELSE
         @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT IMAGE cImage IMAGESIZE
      ENDIF
   ELSE
      IF ::cUnits == "MM"
         @ nLin, nCol PRINT IMAGE cImage WIDTH ( nColF - nCol ) HEIGHT ( nLinF - nLin ) STRETCH
      ELSE
         @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT IMAGE cImage ;
            WIDTH ( ( nColF - nCol - 1 ) * ::nmHor + ::nhFij ) ;
            HEIGHT ( ( nLinF + 0.5 - nLin ) * ::nmVer + ::nvFij ) ;
            STRETCH
      ENDIF
   ENDIF

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintLineX( nLin, nCol, nLinF, nColF, atColor, ntwPen, lSolid ) CLASS TMiniPrint

   LOCAL nVDispl := 1

   IF ::cUnits == "MM"
      @ nLin, nCol PRINT LINE TO nLinF, nColF COLOR atColor PENWIDTH ntwPen STYLE iif( lSolid, PEN_SOLID, PEN_DASH )
   ELSE
      @ nLin * ::nmVer * nVDispl + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT LINE TO nLinF * ::nmVer * nVDispl + ::nvFij, nColF * ::nmHor + ::nhFij * 2 COLOR atColor PENWIDTH ntwPen STYLE iif( lSolid, PEN_SOLID, PEN_DASH )
   ENDIF

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintRectangleX( nLin, nCol, nLinF, nColF, atColor, ntwPen, lSolid, arColor ) CLASS TMiniPrint

   LOCAL nVDispl := 1

   IF ::cUnits == "MM"
      IF Empty( arColor )
         @ nLin, nCol PRINT RECTANGLE TO nLinF, nColF COLOR atColor PENWIDTH ntwPen STYLE iif( lSolid, PEN_SOLID, PEN_DASH )
      ELSE
         @ nLin, nCol PRINT RECTANGLE TO nLinF, nColF COLOR atColor PENWIDTH ntwPen STYLE iif( lSolid, PEN_SOLID, PEN_DASH ) BRUSHCOLOR arColor
      ENDIF
   ELSE
      @ nLin * ::nmVer * nVDispl + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT RECTANGLE TO nLinF * ::nmVer * nVDispl + ::nvFij, nColF * ::nmHor + ::nhFij * 2 COLOR atColor PENWIDTH ntwPen STYLE iif( lSolid, PEN_SOLID, PEN_DASH ) BRUSHCOLOR arColor
   ENDIF

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintRoundRectangleX( nLin, nCol, nLinF, nColF, atColor, ntwPen, lSolid, arColor ) CLASS TMiniPrint

   LOCAL nVDispl := 1  // nVDispl := 1.009

   IF ::cUnits == "MM"
      IF Empty( arColor )
         @ nLin, nCol PRINT RECTANGLE TO nLinF, nColF PENWIDTH ntwPen STYLE iif( lSolid, PEN_SOLID, PEN_DASH ) COLOR atColor ROUNDED
      ELSE
         @ nLin, nCol PRINT RECTANGLE TO nLinF, nColF PENWIDTH ntwPen STYLE iif( lSolid, PEN_SOLID, PEN_DASH ) COLOR atColor BRUSHCOLOR arColor ROUNDED
      ENDIF
   ELSE
      @ nLin * ::nmVer * nVDispl + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT RECTANGLE TO nLinF * ::nmVer * nVDispl + ::nvFij, nColF * ::nmHor + ::nhFij * 2 PENWIDTH ntwPen STYLE iif( lSolid, PEN_SOLID, PEN_DASH ) COLOR atColor BRUSHCOLOR arColor ROUNDED
   ENDIF

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SelPrinterX( lSelect, lPreview, lLandscape, nPaperSize, cPrinterX, nRes, nBin, nDuplex, lCollate, nCopies, lColor, nScale, nPaperLength, nPaperWidth, cLang ) CLASS TMiniPrint

   LOCAL nOrientation, lSuccess, nCollate, nColor

   ASSIGN nPaperSize   VALUE nPaperSize   TYPE "N" DEFAULT -999
   ASSIGN nRes         VALUE nRes         TYPE "N" DEFAULT -999
   ASSIGN nBin         VALUE nBin         TYPE "N" DEFAULT -999
   ASSIGN nDuplex      VALUE nDuplex      TYPE "N" DEFAULT -999
   ASSIGN nCopies      VALUE nCopies      TYPE "N" DEFAULT -999
   ASSIGN nScale       VALUE nScale       TYPE "N" DEFAULT -999
   ASSIGN nPaperLength VALUE nPaperLength TYPE "N" DEFAULT -999
   ASSIGN nPaperWidth  VALUE nPaperWidth  TYPE "N" DEFAULT -999

   IF HB_ISLOGICAL( lLandscape )
      IF lLandscape
         nOrientation := PRINTER_ORIENT_LANDSCAPE
      ELSE
         nOrientation := PRINTER_ORIENT_PORTRAIT
      ENDIF
   ELSE
      nOrientation := -999
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
         ::cPrinter := _HMG_PRINTER_GetPrinter( cLang )
         IF Empty( ::cPrinter )
            ::lPrError := .T.
            RETURN .F.
         ENDIF

         IF ::lIgnorePropertyError
            IF ::lNoErrMsg
               IF lPreview
                  SELECT PRINTER ::cPrinter TO lSuccess ;
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
                     PREVIEW ;
                     IGNOREERRORS ;
                     NOERRORMSGS
               ELSE
                  SELECT PRINTER ::cPrinter TO lSuccess ;
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
                     IGNOREERRORS ;
                     NOERRORMSGS
               ENDIF
            ELSE
               IF lPreview
                  SELECT PRINTER ::cPrinter TO lSuccess ;
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
                     PREVIEW ;
                     IGNOREERRORS
               ELSE
                  SELECT PRINTER ::cPrinter TO lSuccess ;
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
                     IGNOREERRORS
               ENDIF
            ENDIF
         ELSE
            IF lPreview
               SELECT PRINTER ::cPrinter TO lSuccess ;
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
               SELECT PRINTER ::cPrinter TO lSuccess ;
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
      ELSE
         ::cPrinter := ::GetDefPrinter()
         IF ::lIgnorePropertyError
            IF ::lNoErrMsg
               IF lPreview
                  SELECT PRINTER DEFAULT TO lSuccess ;
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
                     PREVIEW ;
                     IGNOREERRORS ;
                     NOERRORMSGS
               ELSE
                  SELECT PRINTER DEFAULT TO lSuccess  ;
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
                     IGNOREERRORS ;
                     NOERRORMSGS
               ENDIF
            ELSE
               IF lPreview
                  SELECT PRINTER DEFAULT TO lSuccess ;
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
                     PREVIEW ;
                     IGNOREERRORS
               ELSE
                  SELECT PRINTER DEFAULT TO lSuccess  ;
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
                     IGNOREERRORS
               ENDIF
            ENDIF
         ELSE
            IF lPreview
               SELECT PRINTER DEFAULT TO lSuccess ;
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
               SELECT PRINTER DEFAULT TO lSuccess  ;
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
      ENDIF
   ELSE
      ::cPrinter := cPrinterX
      IF Empty( ::cPrinter )
         ::lPrError := .T.
         RETURN .F.
      ENDIF

      IF ::lIgnorePropertyError
         IF ::lNoErrMsg
            IF lPreview
               SELECT PRINTER ::cPrinter TO lSuccess ;
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
                  PREVIEW ;
                  IGNOREERRORS ;
                  NOERRORMSGS
            ELSE
               SELECT PRINTER ::cPrinter TO lSuccess ;
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
                  IGNOREERRORS ;
                  NOERRORMSGS
            ENDIF
         ELSE
            IF lPreview
               SELECT PRINTER ::cPrinter TO lSuccess ;
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
                  PREVIEW ;
                  IGNOREERRORS
            ELSE
               SELECT PRINTER ::cPrinter TO lSuccess ;
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
                  IGNOREERRORS
            ENDIF
         ENDIF
      ELSE
         IF lPreview
            SELECT PRINTER ::cPrinter TO lSuccess ;
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
            SELECT PRINTER ::cPrinter TO lSuccess ;
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
   ENDIF

   ::lPrError := ! lSuccess

   IF lSuccess .AND. HB_ISNUMERIC( _HMG_PRINTER_aPrinterProperties[ 6 ] )
      ::lLandscape := ( _HMG_PRINTER_aPrinterProperties[ 6 ] == PRINTER_ORIENT_LANDSCAPE )
   ENDIF

   RETURN lSuccess

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GetDefPrinterX() CLASS TMiniPrint

   RETURN GetDefaultPrinter()


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS THBPrinter FROM TPrintBase

   DATA oHBPrn                    INIT NIL                   READONLY
   DATA Type                      INIT "HBPRINTER"           READONLY

   METHOD BeginDocX
   METHOD BeginPageX
   METHOD EndDocX
   METHOD EndPageX
   METHOD GetDefPrinterX
   METHOD InitX
   METHOD IsDocOpenX
   METHOD MaxCol
   METHOD MaxRow
   METHOD PrintBarcodeX
   METHOD PrintDataX
   METHOD PrintBitmapX
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
METHOD MaxCol() CLASS THBPrinter

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
METHOD MaxRow() CLASS THBPrinter

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
METHOD InitX( cLang ) CLASS THBPrinter

   IF cLang == NIL
      INIT PRINTSYS
   ELSE
      INIT PRINTSYS LANGUAGE cLang
   ENDIF
   GET PRINTERS TO ::aPrinters
   GET PORTS TO ::aPorts
   SET UNITS MM
   SET CHANGES LOCAL         // sets printer options not permanent
   SET PREVIEW SCALE 2
   ::cPrintLibrary := "HBPRINTER"
   ::lPrError := .F.

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginDocX() CLASS THBPrinter

   START DOC NAME ::Cargo
   CHANGE FONT "F0" NAME ::cFontName SIZE ::nFontSize
   CHANGE BRUSH "B0" COLOR ::aColor STYLE BS_SOLID
   CHANGE BRUSH "B1" COLOR {255, 255, 255} STYLE BS_SOLID
   CHANGE PEN "P0" WIDTH ::nwPen COLOR ::aColor STYLE PS_SOLID

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD IsDocOpenX() CLASS THBPrinter

   IF ::lDocIsOpen
      IF HB_ISOBJECT( ::oHBPrn )
         IF ! HB_ISOBJECT( ::oHBPrn:oWinPreview )
            ::lDocIsOpen := .F.
         ENDIF
      ENDIF
   ENDIF

   RETURN ::lDocIsOpen

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndDocX( lWait, lSize ) CLASS THBPrinter

   ASSIGN lWait VALUE lWait TYPE "L" DEFAULT ::ImPreview
   ASSIGN lSize VALUE lSize TYPE "L" DEFAULT .F.
   IF lSize
      IF lWait .OR. ! HB_ISOBJECT( ::oWinReport )
         END DOC SIZE
         ::lDocIsOpen := .F.
      ELSE
         END DOC NOWAIT SIZE PARENT ( ::oWinReport:Name )
         ::lDocIsOpen := .T.
         DEFINE TIMER 0 ;
            PARENT ( ::oWinReport:Name ) ;
            INTERVAL 800 ;
            ACTION { || iif( ::IsDocOpen(), NIL, ::Release() ) }
      ENDIF
   ELSE
      IF lWait .OR. ! HB_ISOBJECT( ::oWinReport )
         END DOC
         ::lDocIsOpen := .F.
      ELSE
         END DOC NOWAIT PARENT ( ::oWinReport:Name )
         ::lDocIsOpen := .T.
         DEFINE TIMER 0 ;
            PARENT ( ::oWinReport:Name ) ;
            INTERVAL 800 ;
            ACTION { || iif( ::IsDocOpen(), NIL, ::Release() ) }
      ENDIF
   ENDIF

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginPageX() CLASS THBPrinter

   START PAGE

   RETURN ::cPageName

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndPageX() CLASS THBPrinter

   END PAGE

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ReleaseX() CLASS THBPrinter

   RELEASE PRINTSYS

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintDataX( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, cText, lItalic, nAngle, lUnder, lStrike, nWidth ) CLASS THBPrinter

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

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintBarcodeX( y, x, y1, x1, aColor ) CLASS THBPrinter

   CHANGE BRUSH "B0" COLOR aColor STYLE BS_SOLID
   @ y, x, y1, x1 FILLRECT BRUSH "B0"

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintBitmapX( nLin, nCol, nLinF, nColF, hBitmap, aResol, aSize, aExt ) CLASS THBPrinter

   HB_SYMBOL_UNUSED( aResol )

   // Coordinates of the rectangle for the first copy of the image.
   ASSIGN nLin  VALUE nLin  TYPE "N" DEFAULT 1   // Start row
   ASSIGN nCol  VALUE nCol  TYPE "N" DEFAULT 1   // Start col
   ASSIGN nLinF VALUE nLinF TYPE "N" DEFAULT 4   // End row
   ASSIGN nColF VALUE nColF TYPE "N" DEFAULT 4   // End col
   ASSIGN aSize VALUE aSize TYPE "L" DEFAULT .F.

   // Coordinates of the lower right corner of the extension rectangle.
   // It will be filled with as many additional copies of the image as they fit.
   ASSIGN aExt  VALUE aExt  TYPE "A" DEFAULT { nLinF, nColF }

   IF ::cUnits == "MM"
      IF aSize
         @ nLin, nCol BITMAP hBitmap IMAGESIZE
      ELSE
         @ nLin, nCol BITMAP hBitmap SIZE ( nLinF - nLin ), ( nColF - nCol ) EXTEND ( aExt[ 1 ] - nLinF ), ( aExt[ 2 ] - nColF )
      ENDIF
   ELSE
      IF aSize
         @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 BITMAP hBitmap IMAGESIZE
      ELSE
         @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 BITMAP hBitmap ;
            SIZE ( nLinF - nLin ) * ::nmVer, ( nColF - nCol ) * ::nmHor ;
            EXTEND ( aExt[ 1 ] - nLinF ) * ::nmVer, ( aExt[ 2 ] - nColF ) * ::nmHor
      ENDIF
   ENDIF

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintImageX( nLin, nCol, nLinF, nColF, cImage, aResol, aSize, aExt ) CLASS THBPrinter

   HB_SYMBOL_UNUSED( aResol )

   ASSIGN aSize VALUE aSize TYPE "L" DEFAULT .F.

   IF ::cUnits == "MM"
      IF aSize
         @ nLin, nCol PICTURE cImage IMAGESIZE
      ELSEIF aExt == NIL
         @ nLin, nCol PICTURE cImage SIZE ( nLinF - nLin ), ( nColF - nCol )
      ELSE 
         @ nLin, nCol PICTURE cImage SIZE ( nLinF - nLin ), ( nColF - nCol ) EXTEND aExt[ 1 ], aExt[ 2 ]
      ENDIF
   ELSE
      IF aSize
         @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PICTURE cImage IMAGESIZE
      ELSEIF aExt == NIL
         @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PICTURE cImage ;
            SIZE ( nLinF - nLin ) * ::nmVer + ::nvFij, ( nColF - nCol ) * ::nmHor + ::nhFij * 2
      ELSE
         @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PICTURE cImage ;
            SIZE ( nLinF - nLin ) * ::nmVer + ::nvFij, ( nColF - nCol ) * ::nmHor + ::nhFij * 2 ;
            EXTEND aExt[ 1 ], aExt[ 2 ]
      ENDIF
   ENDIF

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintLineX( nLin, nCol, nLinF, nColF, atColor, ntwPen, lSolid ) CLASS THBPrinter

   LOCAL nVDispl := 1

   CHANGE PEN "P0" WIDTH ntwPen * 10 COLOR atColor STYLE iif( lSolid, PS_SOLID, PS_DASH )
   IF ::cUnits == "MM"
      @ nLin, nCol, nLinF, nColF LINE PEN "P0"
   ELSE
      @ nLin * ::nmVer * nVDispl + ::nvFij, nCol * ::nmHor + ::nhFij * 2, nLinF * ::nmVer * nVDispl + ::nvFij, nColF * ::nmHor + ::nhFij * 2 LINE PEN "P0"
   ENDIF

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintRectangleX( nLin, nCol, nLinF, nColF, atColor, ntwPen, lSolid, arColor ) CLASS THBPrinter

   LOCAL nVDispl := 1

   CHANGE PEN "P0" WIDTH ntwPen * 10 COLOR atColor STYLE iif( lSolid, PS_SOLID, PS_DASH )
   CHANGE BRUSH "B1" COLOR arColor STYLE BS_SOLID
   IF ::cUnits == "MM"
      @ nLin, nCol, nLinF, nColF RECTANGLE PEN "P0" BRUSH "B1"
   ELSE
      @ nLin * ::nmVer * nVDispl + ::nvFij, nCol * ::nmHor + ::nhFij * 2, nLinF * ::nmVer * nVDispl + ::nvFij, nColF * ::nmHor + ::nhFij * 2 RECTANGLE PEN "P0" BRUSH "B1"
   ENDIF

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintRoundRectangleX( nLin, nCol, nLinF, nColF, atColor, ntwPen, lSolid, arColor ) CLASS THBPrinter

   LOCAL nVDispl := 1

   CHANGE PEN "P0" WIDTH ntwPen * 10 COLOR atColor STYLE iif( lSolid, PS_SOLID, PS_DASH )
   CHANGE BRUSH "B1" COLOR arColor STYLE BS_SOLID
   IF ::cUnits == "MM"
      @ nLin, nCol, nLinF, nColF ROUNDRECT ROUNDR 10 ROUNDC 10 PEN "P0" BRUSH "B1"
   ELSE
      @ nLin * ::nmVer * nVDispl + ::nvFij, nCol * ::nmHor + ::nhFij * 2, nLinF * ::nmVer * nVDispl + ::nvFij, nColF * ::nmHor + ::nhFij * 2 ROUNDRECT ROUNDR 10 ROUNDC 10 PEN "P0" BRUSH "B1"
   ENDIF

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SelPrinterX( lSelect, lPreview, lLandscape, nPaperSize, cPrinterX, nRes, nBin, nDuplex, lCollate, nCopies, lColor, nScale, nPaperLength, nPaperWidth, cLang ) CLASS THBPrinter

   HB_SYMBOL_UNUSED( cLang )

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
      RETURN .F.
   ENDIF

   ::cPrinter := ::oHBPrn:PrinterName

   DEFINE FONT "F0" NAME ::cFontName SIZE ::nFontSize
   SELECT FONT "F0"
   DEFINE BRUSH "B0" COLOR ::aColor STYLE BS_SOLID
   DEFINE BRUSH "B1" COLOR {255, 255, 255} STYLE BS_SOLID
   SELECT BRUSH "B0"
   DEFINE PEN "P0" WIDTH ::nwPen COLOR ::aColor STYLE PS_SOLID
   SELECT PEN "P0"

   IF lLandscape # NIL
      IF lLandscape
         SET PAGE ORIENTATION DMORIENT_LANDSCAPE FONT "F0"
      ELSE
         SET PAGE ORIENTATION DMORIENT_PORTRAIT  FONT "F0"
      ENDIF
   ENDIF
   ::lLandscape := ( ::oHBPrn:DevCaps[ 15 ] == PRINTER_ORIENT_LANDSCAPE )

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

   IF cLang # NIL
      ::oHBPrn:InitMessages( cLang )
   ENDIF

   ::lPrError := .F.

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GetDefPrinterX() CLASS THBPrinter

   LOCAL cDefPrinter

   GET DEFAULT PRINTER TO cDefPrinter

   RETURN cDefPrinter

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetColorX() CLASS THBPrinter

   CHANGE PEN "P0" WIDTH ::nwPen COLOR ::aColor STYLE PS_SOLID

   RETURN ::aColor

/*---------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetPreviewSizeX( nSize ) CLASS THBPrinter

   IF nSize == NIL .OR. nSize < 1 .OR. nSize > 5
      nSize := 2
   ENDIF
   ::nPreviewSize := nSize
   SET PREVIEW SCALE nSize

   RETURN ::nPreviewSize


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TDosPrint FROM TPrintBase

   DATA cBusca                    INIT ""                    READONLY
   DATA cString                   INIT ""                    READONLY
   DATA nOccur                    INIT 0                     READONLY
   DATA oWinPreview               INIT NIL                   READONLY
   DATA Type                      INIT "DOSPRINT"            READONLY

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
   METHOD Zoom
   /*
   TODO: Add METHOD PrintRectangleX using two horizontal lines and pairs of |
   */

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintModeX( cFile ) CLASS TDosPrint

   LOCAL cBat, nHdl, lOk := .T.

   IF HB_ISSTRING( cFile ) .AND. ! Empty( cFile )
      cBat := 'b' + AllTrim( Str( hb_Random( 999999 ), 6 ) ) + '.bat'
      nHdl := FCreate( cBat )
      FWrite( nHdl, 'copy "' + cFile + '" ' + ::cPort + Chr( 13 ) + Chr( 10 ) )
      FWrite( nHdl, "rem " + _OOHG_Messages( MT_PRINTER, 3 ) + Chr( 13 ) + Chr( 10 ) )
      FClose( nHdl )
      hb_idleSleep( 1 )
      WaitRun( cBat, 0 )
      FErase( cBat )

      IF ::lSaveTemp
         BEGIN SEQUENCE
            COPY FILE ( cFile ) TO ( ::cDocument )
         RECOVER
            IF ::lShowErrors
               MsgStop( _OOHG_Messages( MT_PRINTER, 45 ) + Chr( 13 ) + ::cDocument, _OOHG_Messages( MT_PRINTER, 12 ) )
            ENDIF
            lOk := .F.
         END SEQUENCE
      ENDIF
   ENDIF

   RETURN lOk

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InitX( cLang ) CLASS TDosPrint

   HB_SYMBOL_UNUSED( cLang )

   ::cPrintLibrary := "DOSPRINT"
   ::lPrError := .F.

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SelPrinterX( lSelect, lPreview, lLandscape, nPaperSize, cPrinterX, nRes, nBin, nDuplex, lCollate, nCopies, lColor, nScale, nPaperLength, nPaperWidth, cLang ) CLASS TDosPrint

   LOCAL oWin

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
   HB_SYMBOL_UNUSED( cLang )

   ::cPrinter := "CMD.EXE"

   IF HB_ISSTRING( cPrinterX )
      cPrinterX := Upper( cPrinterX )
      IF ! cPrinterX $ "PRN LPT1: LPT2: LPT3: LPT4: LPT5: LPT6:"
         IF ::lShowError
            MsgStop( _OOHG_Messages( MT_PRINTER, 13 ), _OOHG_Messages( MT_PRINTER, 12 ) )
         ENDIF
         ::lPrError := .T.
         RETURN .F.
      ENDIF
   ENDIF

   DO WHILE File( ::cTempFile )
      ::cTempFile := TEMP_FILE_NAME
   ENDDO

   ::lPrError := .F.

   IF lSelect
      ::aPorts:= ASort( aLocalPorts() )

      DEFINE WINDOW 0 OBJ oWin ;
         AT 0, 0 ;
         WIDTH 345 ;
         HEIGHT GetTitleHeight() + 100 ;
         TITLE _OOHG_Messages( MT_PRINTER, 14 ) ;
         MODAL ;
         NOSIZE

         @ 15, 10 COMBOBOX combo_1 ITEMS ::aPorts VALUE 1 WIDTH 320

         @ 53, 65 BUTTON ok CAPTION _OOHG_Messages( MT_PRINTER, 15 ) ACTION ( ::cPort := SubStr( oWin:combo_1:Item( oWin:combo_1:Value ), 1, AT(",", oWin:combo_1:Item( oWin:combo_1:Value ))-1 ), oWin:Release() )

         @ 53,175 BUTTON cancel CAPTION _OOHG_Messages( MT_PRINTER, 16 ) ACTION ( ::cPort := "PRN", ::lPrError := .T., oWin:Release() )
      END WINDOW

      oWin:Center()
      oWin:ok:SetFocus()
      oWin:Activate()
   ELSE
      IF ! Empty( cPrinterX )
         ::cPort := cPrinterX
      ELSE
         ::cPort := "PRN"
      ENDIF
   ENDIF

   RETURN ( ! ::lPrError )

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION aLocalPorts()

   LOCAL aPrnPort, aResults := {}

   aPrnPort := GetPrintersInfo()
   IF aPrnPort <> ",,"
      aPrnPort := RR_STR2ARR( aPrnPort, ",," )
      AEval( aPrnPort, { | x, xi | aPrnPort[ xi ] := RR_STR2ARR( x, ',' ) } )
      AEval( aPrnPort, { | x | AAdd( aResults, x[ 2 ] + ", " + x[ 1 ] ) } )
   ENDIF

   RETURN aResults

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginDocX() CLASS TDosPrint

   ::cDocument := ParseName( ::Cargo, "dos" )
   SET PRINTER TO ( ::cTempFile )
   SET DEVICE TO PRINT

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION ParseName( cName, cExt, lInvSlash )

   LOCAL i, cLongName, lExt

   ASSIGN lInvSlash VALUE lInvSlash TYPE "L" DEFAULT .F.
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
METHOD EndDocX() CLASS TDosPrint

   LOCAL nHandle, wr, nx, ny

   nx := GetDesktopRealWidth()
   ny := GetDesktopRealHeight()

   SET DEVICE TO SCREEN
   SET PRINTER TO

   nHandle := FOpen( ::cTempFile, 0 + 64 )

   IF ::ImPreview
      wr := MemoRead( ( ::cTempFile ) )

      DEFINE WINDOW 0 OBJ ::oWinPreview ;
         AT 0, 0 ;
         WIDTH nx HEIGHT ny - 70 - 40 ;
         TITLE _OOHG_Messages( MT_PRINTER, 17 ) + ::cTempFile + " " + ::cPrintLibrary ;
         MODAL

         @ 42, 0 RICHEDITBOX edit_p ;
            WIDTH nx - 5 ;
            HEIGHT ny - 40 - 70 - 70 ;
            VALUE wr ;
            READONLY ;
            FONT 'Courier New' ;
            SIZE 10 ;
            BACKCOLOR WHITE

         DEFINE TOOLBAR toolbr BUTTONSIZE 80, 20
            BUTTON but_4 CAPTION _OOHG_Messages( MT_PRINTER, 18 )    ACTION ::oWinPreview:Release()                      TOOLTIP _OOHG_Messages( MT_PRINTER, 19 )
            BUTTON but_1 CAPTION _OOHG_Messages( MT_PRINTER, 20 )    ACTION ::Zoom( "+" )                                TOOLTIP _OOHG_Messages( MT_PRINTER, 21 )
            BUTTON but_2 CAPTION _OOHG_Messages( MT_PRINTER, 22 )    ACTION ::Zoom( "-" )                                TOOLTIP _OOHG_Messages( MT_PRINTER, 23 )
            BUTTON but_3 CAPTION _OOHG_Messages( MT_PRINTER, 24, 1 ) ACTION ::PrintMode( ::cTempFile )                   TOOLTIP _OOHG_Messages( MT_PRINTER, 25, 1 ) + ::cPrintLibrary
            BUTTON but_5 CAPTION _OOHG_Messages( MT_PRINTER, 26 )    ACTION ::SearchString( ::oWinPreview:edit_p:Value ) TOOLTIP _OOHG_Messages( MT_PRINTER, 27 )
            BUTTON but_6 CAPTION _OOHG_Messages( MT_PRINTER, 28 )    ACTION ::NextSearch()                               TOOLTIP _OOHG_Messages( MT_PRINTER, 29 )
         END TOOLBAR
      END WINDOW

      ::oWinPreview:Center()
      ::oWinPreview:Activate()
   ELSE
      ::PrintMode( ::cTempFile )
   ENDIF

   IF File( ::cTempFile )
      FClose( nHandle )
      FErase( ::cTempFile )
   ENDIF

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginPageX() CLASS TDosPrint

   @ 0, 0 SAY ""

   RETURN ::cPageName

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndPageX() CLASS TDosPrint

   EJECT

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintDataX( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, cText, lItalic, nAngle, lUnder, lStrike, nWidth ) CLASS TDosPrint

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

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintLineX( nLin, nCol, nLinF, nColF, atColor, ntwPen ) CLASS TDosPrint

   HB_SYMBOL_UNUSED( atColor )
   HB_SYMBOL_UNUSED( ntwPen )

   IF nLin == nLinF
      @ nLin, nCol SAY Replicate( "-", nColF - nCol + 1 )
   ENDIF

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD CondenDosX() CLASS TDosPrint

   @ PRow(), PCol() SAY Chr( 15 )

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD NormalDosX() CLASS TDosPrint

   @ PRow(), PCol() SAY Chr( 18 )

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Zoom( cOp ) CLASS TDosPrint

   IF cOp == "+" .AND. ::oWinPreview:edit_p:FontSize <= 25
      ::oWinPreview:edit_p:FontSize := ::oWinPreview:edit_p:FontSize + 1
   ENDIF

   IF cOp == "-" .AND. ::oWinPreview:edit_p:FontSize > 6
      ::oWinPreview:edit_p:FontSize := ::oWinPreview:edit_p:FontSize - 1
   ENDIF

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SearchString( cTarget) CLASS TDosPrint

   ::oWinPreview:but_6:Enabled := .F.
   ::oWinPreview:edit_p:CaretPos := 1
   ::nOccur := 0
   ::cBusca := cTarget
   ::cString := ""
   ::cString := InputBox( _OOHG_Messages( MT_PRINTER, 30 ), _OOHG_Messages( MT_PRINTER, 31 ) )
   IF Empty( ::cString )
      RETURN .F.
   ENDIF
   ::oWinPreview:but_6:Enabled := .T.
   ::NextSearch()

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD NextSearch() CLASS TDosPrint

   LOCAL cString, nCaretPos

   cString := Upper( ::cString )
   nCaretPos := AtPlus( AllTrim( cString ), Upper( ::cBusca ), ::nOccur )
   ::nOccur := nCaretPos + 1

   ::oWinPreview:edit_p:SetFocus()
   IF nCaretPos > 0
      ::oWinPreview:edit_p:CaretPos := nCaretPos
      ::oWinPreview:edit_p:Refresh()
   ELSE
      ::oWinPreview:but_6:Enabled := .F.
      MsgInfo( _OOHG_Messages( MT_PRINTER, 32 ), _OOHG_Messages( MT_PRINTER, 33 ) )
   ENDIF

   RETURN .T.

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
CLASS TTxtPrint FROM TDosPrint

   DATA cBusca                    INIT ""                    READONLY
   DATA cString                   INIT ""                    READONLY
   DATA nOccur                    INIT 0                     READONLY
   DATA Type                      INIT "TXTPRINT"            READONLY

   METHOD BeginDocX
   METHOD EndDocX
   METHOD InitX
   METHOD PrintImage              BLOCK { || NIL }
   METHOD PrintModeX
   METHOD SelPrinterX
   METHOD SetDosPort              BLOCK { || NIL }
   /*
   TODO: Add METHOD PrintRectangleX using two horizontal lines and pairs of |
   */

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginDocX() CLASS TTxtPrint

   ::cDocument := ParseName( ::Cargo, "txt" )
   SET PRINTER TO ( ::cTempFile )
   SET DEVICE TO PRINT

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndDocX() CLASS TTxtPrint

   LOCAL nHandle, wr, nx, ny

   nx := GetDesktopRealWidth()
   ny := GetDesktopRealHeight()

   SET DEVICE TO SCREEN
   SET PRINTER TO

   nHandle := FOpen( ::cTempFile, 0 + 64 )

   IF ::ImPreview
      wr := MemoRead( ( ::cTempFile ) )

      DEFINE WINDOW 0 OBJ ::oWinPreview ;
         AT 0, 0 ;
         WIDTH nx HEIGHT ny - 70 - 40 ;
         TITLE _OOHG_Messages( MT_PRINTER, 17 ) + ::cTempFile + " " + ::cPrintLibrary ;
         MODAL

         @ 42, 0 RICHEDITBOX edit_p ;
            WIDTH nx - 5 ;
            HEIGHT ny - 40 - 70 - 70 ;
            VALUE wr ;
            READONLY ;
            FONT 'Courier New' ;
            SIZE 10 ;
            BACKCOLOR WHITE

         DEFINE TOOLBAR toolbr BUTTONSIZE 80, 20
            BUTTON but_4 CAPTION _OOHG_Messages( MT_PRINTER, 18 )    ACTION ::oWinPreview:Release()                      TOOLTIP _OOHG_Messages( MT_PRINTER, 19 )
            BUTTON but_1 CAPTION _OOHG_Messages( MT_PRINTER, 20 )    ACTION ::Zoom( "+" )                                TOOLTIP _OOHG_Messages( MT_PRINTER, 21 )
            BUTTON but_2 CAPTION _OOHG_Messages( MT_PRINTER, 22 )    ACTION ::Zoom( "-" )                                TOOLTIP _OOHG_Messages( MT_PRINTER, 23 )
            BUTTON but_3 CAPTION _OOHG_Messages( MT_PRINTER, 24, 2 ) ACTION ::PrintMode( ::cTempFile )                   TOOLTIP _OOHG_Messages( MT_PRINTER, 25, 2 ) + ::cPrintLibrary
            BUTTON but_5 CAPTION _OOHG_Messages( MT_PRINTER, 26 )    ACTION ::SearchString( ::oWinPreview:edit_p:Value ) TOOLTIP _OOHG_Messages( MT_PRINTER, 27 )
            BUTTON but_6 CAPTION _OOHG_Messages( MT_PRINTER, 28 )    ACTION ::NextSearch()                               TOOLTIP _OOHG_Messages( MT_PRINTER, 29 )
         END TOOLBAR
      END WINDOW

      ::oWinPreview:Center()
      ::oWinPreview:Activate()
   ELSE
      ::PrintMode( ::cTempFile )
   ENDIF

   IF File( ::cTempFile )
      FClose( nHandle )
      FErase( ::cTempFile )
   ENDIF

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InitX( cLang ) CLASS TTxtPrint

   HB_SYMBOL_UNUSED( cLang )

   ::cPrintLibrary := "TXTPRINT"
   ::lPrError := .F.

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintModeX( cFile ) CLASS TTxtPrint

   LOCAL lOk := .T.

   IF HB_ISSTRING( cFile ) .AND. ! Empty( cFile )
      BEGIN SEQUENCE
         COPY FILE ( cFile ) TO ( ::cDocument )
      RECOVER
         IF ::lShowErrors
            MsgStop( _OOHG_Messages( MT_PRINTER, 45 ) + Chr( 13 ) + ::cDocument, _OOHG_Messages( MT_PRINTER, 12 ) )
         ENDIF
         lOk := .F.
      END SEQUENCE
   ENDIF

   RETURN lOk

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SelPrinterX( lSelect, lPreview, lLandscape, nPaperSize, cPrinterX, nRes, nBin, nDuplex, lCollate, nCopies, lColor, nScale, nPaperLength, nPaperWidth, cLang ) CLASS TTxtPrint

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
   HB_SYMBOL_UNUSED( cLang )

   ASSIGN lPreview VALUE lPreview TYPE "L" DEFAULT .T.
   ::ImPreview := lPreview

   ::cPrinter := "TXT"

   DO WHILE File( ::cTempFile )
      ::cTempFile := TEMP_FILE_NAME
   ENDDO

   RETURN .T.


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TRawPrint FROM TDosPrint

   DATA Type                      INIT "RAWPRINT"            READONLY

   METHOD BeginDocX
   METHOD InitX
   METHOD PrintModeX
   METHOD SelPrinterX

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginDocX() CLASS TRawPrint

   ::Super:BeginDocX()
   ::cDocument := ParseName( ::Cargo, "raw" )

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintModeX( cFile ) CLASS TRawPrint

   LOCAL nResult, cMsg, aData, lOk := .T.

   IF HB_ISSTRING( cFile ) .AND. ! Empty( cFile )
      IF ::lSaveTemp
         BEGIN SEQUENCE
            COPY FILE ( cFile ) TO ( ::cDocument )
         RECOVER
            IF ::lShowErrors
               MsgStop( _OOHG_Messages( MT_PRINTER, 45 ) + Chr( 13 ) + ::cDocument, _OOHG_Messages( MT_PRINTER, 12 ) )
            ENDIF
            lOk := .F.
         END SEQUENCE
      ENDIF

      IF Empty( ::cPrinter )
         IF ::lShowErrors
            MsgStop( _OOHG_Messages( MT_PRINTER, 11 ), _OOHG_Messages( MT_PRINTER, 12 ) )
         ENDIF
         lOk := .F.
      ELSE
         nResult := PrintFileRaw( ::cPrinter, cFile, "raw print" )
         hb_idleSleep( 1 )
         IF nResult # 1
            IF ::lShowErrors
               aData := { {  1, cFile + _OOHG_Messages( MT_PRINTER, 4 ) }, ;
                          { -1, _OOHG_Messages( MT_PRINTER, 5 ) }, ;
                          { -2, _OOHG_Messages( MT_PRINTER, 6 ) }, ;
                          { -3, _OOHG_Messages( MT_PRINTER, 7 ) }, ;
                          { -4, _OOHG_Messages( MT_PRINTER, 8 ) }, ;
                          { -5, _OOHG_Messages( MT_PRINTER, 9 ) }, ;
                          { -6, cFile + _OOHG_Messages( MT_PRINTER, 10 ) } }
               cMsg := aData[ AScan( aData, { | x | x[ 1 ] == nResult } ), 2 ]
               MsgStop( cMsg, _OOHG_Messages( MT_PRINTER, 12 ) )
            ENDIF
            lOk := .F.
         ENDIF
      ENDIF
   ELSE
      lOk := .F.
   ENDIF

   RETURN lOk

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InitX( cLang ) CLASS TRawPrint

   HB_SYMBOL_UNUSED( cLang )

   ::cPrintLibrary := "RAWPRINT"
   ::lPrError := .F.

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SelPrinterX( lSelect, lPreview, lLandscape, nPaperSize, cPrinterX, nRes, nBin, nDuplex, lCollate, nCopies, lColor, nScale, nPaperLength, nPaperWidth, cLang ) CLASS TRawPrint

   LOCAL oWin

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
   HB_SYMBOL_UNUSED( cLang )

   ::ImPreview := .F.

   DO WHILE File( ::cTempFile )
      ::cTempFile := TEMP_FILE_NAME
   ENDDO

   ::lPrError := .F.

   IF lSelect
      ::cPrinter := ""
      ::aPrinters := ASort( _HMG_PRINTER_aPrinters() )

      DEFINE WINDOW 0 OBJ oWin  ;
         AT 0, 0 ;
         WIDTH 345 ;
         HEIGHT GetTitleHeight() + 100 ;
         TITLE _OOHG_Messages( MT_PRINTER, 14 ) ;
         MODAL ;
         NOSIZE

         @ 15, 10 COMBOBOX combo_1 ITEMS ::aPrinters VALUE AScan( ::aPrinters, GetDefaultPrinter() ) WIDTH 320

         @ 53, 65 BUTTON ok CAPTION _OOHG_Messages( MT_PRINTER, 15 ) ACTION ( ::cPrinter := oWin:combo_1:Item( oWin:combo_1:Value ), oWin:Release() )
         @ 53, 175 BUTTON cancel CAPTION _OOHG_Messages( MT_PRINTER, 16 ) ACTION ( ::lPrError := .T., oWin:Release() )
      END WINDOW

      oWin:Center()
      oWin:ok:SetFocus()
      oWin:Activate()
   ELSE
      IF Empty( cPrinterX )
         ::cPrinter := GetDefaultPrinter()
      ELSE
         ::cPrinter := cPrinterX
      ENDIF
   ENDIF

   RETURN ::lPrError


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TExcelPrint FROM TPrintBase
// Based upon a contribution of Jose Miguel josemisu@yahoo.com.ar

   DATA oExcel                    INIT NIL                   READONLY
   DATA oBook                     INIT NIL                   READONLY
   DATA oHoja                     INIT NIL                   READONLY
   DATA Type                      INIT "EXCELPRINT"          READONLY

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
   /*
   TODO: Add METHOD PrintLineX using cell borders.
   TODO: Add METHOD PrintRectangleX using cell borders.
   TODO: Add support for "printing" in multiple cells.
   TODO: Add SelPrinterX to open a dialog to select file.
   */

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InitX( cLang ) CLASS TExcelPrint

   HB_SYMBOL_UNUSED( cLang )

   ::cPrintLibrary := "EXCELPRINT"

   #ifndef __XHARBOUR__
   IF ( ::oExcel := win_oleCreateObject( "Excel.Application" ) ) == NIL
   #else
   ::oExcel := TOleAuto():New( "Excel.Application" )
   IF Ole2TxtError() != 'S_OK'
   #endif
      IF ::lShowErrors
         MsgStop( _OOHG_Messages( MT_PRINTER, 34 ), _OOHG_Messages( MT_PRINTER, 12 ) )
      ENDIF
      ::lPrError := .T.
   ELSE
      ::oExcel:Visible := .F.
      ::oExcel:DisplayAlerts :=.F.
      ::lPrError := .F.
   ENDIF

   RETURN ( ! ::lPrError )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginDocX() CLASS TExcelPrint

   LOCAL nBefore

   ::cDocument := ParseName( ::Cargo, iif( Val( ::oExcel:Version ) > 11.5, "xlsx", "xls" ) )

   nBefore := ::oExcel:SheetsInNewWorkbook
   ::oExcel:SheetsInNewWorkbook := 1
   ::oBook := ::oExcel:WorkBooks:Add()
   ::oExcel:SheetsInNewWorkbook := nBefore

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginPageX() CLASS TExcelPrint

   ::oHoja := ::oBook:ActiveSheet()
   IF ::lSeparateSheets
      ::oHoja:Name := ::cPageName
      ::oHoja:Cells:Font:Name := ::cFontName
      ::oHoja:Cells:Font:Size := ::nFontSize
   ENDIF

   RETURN ::cPageName

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndDocX() CLASS TExcelPrint

   LOCAL nCol, bErrorBlock, lOk := .T.

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
         MsgStop( _OOHG_Messages( MT_PRINTER, 45 ) + Chr( 13 ) + ::cDocument, _OOHG_Messages( MT_PRINTER, 12 ) )
      ENDIF
      lOk := .F.
   END SEQUENCE
   ErrorBlock( bErrorBlock )

   ::oBook:Close( .F. )
   ::oBook := NIL

   IF lOk .AND. ::ImPreview
      IF ShellExecute( 0, "open", "rundll32.exe", "url.dll,FileProtocolHandler " + ::cDocument, , 1) <= 32
         IF ::lShowErrors
            MsgStop( _OOHG_Messages( MT_PRINTER, 35 ) + Chr( 13 ) + Chr( 13 ) + _OOHG_Messages( MT_PRINTER, 36 ) + Chr( 13 ) + ::cDocument, _OOHG_Messages( MT_PRINTER, 12 ) )
         ENDIF
      ENDIF
      lOk := .F.
   ENDIF

   RETURN lOk

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ReleaseX() CLASS TExcelPrint

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

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintImageX( nLin, nCol, nLinF, nColF, cImage, aResol, aSize, aExt ) CLASS TExcelPrint

   HB_SYMBOL_UNUSED( nLinF )
   HB_SYMBOL_UNUSED( nColF )
   HB_SYMBOL_UNUSED( aResol )
   HB_SYMBOL_UNUSED( aSize )
   HB_SYMBOL_UNUSED( aExt )

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
   TODO: Add support for images in the resource file
   TODO: Add support for image scaling (now is printed at imagesize)
   */

   ::oHoja:Range( "A" + AllTrim( Str( nLin ) ) ):Select()
   IF At( '\', cImage ) == 0
      cImage := GetCurrentFolder() + '\' + cImage
   ENDIF
   ::oHoja:Pictures:Insert( cImage )

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintDataX( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, cText, lItalic, nAngle, lUnder, lStrike, nWidth ) CLASS TExcelPrint

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

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndPageX() CLASS TExcelPrint

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

   RETURN .T.


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
CLASS TSpreadsheetPrint FROM TPrintBase

   DATA aDoc                      INIT {}                    READONLY
   DATA nLinRel                   INIT 0                     READONLY
   DATA nLpp                      INIT 60                    READONLY    // lines per page
   DATA nXls                      INIT 0                     READONLY
   DATA Type                      INIT "SPREADSHEETPRINT"    READONLY

   METHOD AddPage
   METHOD BeginDocX
   METHOD EndDocX
   METHOD EndPageX
   METHOD InitX
   METHOD PrintDataX
   METHOD PrintImage              BLOCK { || NIL }
   METHOD ReleaseX
   METHOD SelPrinterX             BLOCK { |Self| ::cPrinter := "BIFF" }
   /*
   TODO: Add SelPrinterX to open a dialog to select file.
   */

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InitX( cLang ) CLASS TSpreadsheetPrint

   HB_SYMBOL_UNUSED( cLang )

   ::cPrintLibrary := "SPREADSHEETPRINT"
   ::lPrError := .F.

   RETURN .T.


/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD AddPage()

   LOCAL i

   FOR i := 1 TO ::nLpp
      AAdd( ::aDoc, Space( 300 ) )
   NEXT i

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginDocX() CLASS TSpreadsheetPrint

   LOCAL cBof := Chr( 9 ) + Chr( 0 ) + Chr( 4 ) + Chr( 0 ) + Chr( 2 ) + Chr( 0 ) + Chr( 10 ) + Chr( 0 )

   ::cDocument := ParseName( ::Cargo, "xls" )
   ::nXls := FCreate( ::cDocument )
   FWrite( ::nXls, cBof, Len( cBof ) )
   ::AddPage()

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndDocX() CLASS TSpreadsheetPrint

   LOCAL i, anHeader, nLen, nI, cEof, lOk := .T.

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
     nI := i - 1
     anHeader[ TXT_ROW1 ] := nI - ( Int( nI / 256 ) * 256 )
     anHeader[ TXT_ROW2 ] := Int( nI / 256 )
     anHeader[ TXT_COL1 ] := 1 - 1

     // Write header
     AEval( anHeader, { |v| FWrite( ::nXls, Chr( v ), 1 ) } )

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
            MsgStop( _OOHG_Messages( MT_PRINTER, 35 ) + Chr( 13 ) + Chr( 13 ) + _OOHG_Messages( MT_PRINTER, 36 ) + Chr( 13 ) + ::cDocument, _OOHG_Messages( MT_PRINTER, 12 ) )
         ENDIF
         lOk  := .F.
      ENDIF
   ENDIF
   ::aDoc := {}

   RETURN lOk

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ReleaseX() CLASS TSpreadsheetPrint

   Release( ::nXls )           // Do not wait for garbage collector

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintDataX( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, cText, lItalic, nAngle, lUnder, lStrike, nWidth ) CLASS TSpreadsheetPrint

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

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndPageX() CLASS TSpreadsheetPrint

   ::nLinRel := ::nLinRel + ::nLpp
   ::AddPage()

   RETURN .T.


/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION THtmlPrint
// CLASS THtmlPrint

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
CLASS THtmlPrintFromExcel FROM TExcelPrint

   DATA Type                      INIT "HTMLPRINTFROMEXCEL"  READONLY

   METHOD BeginDocX
   METHOD EndDocX
   METHOD InitX

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginDocX() CLASS THtmlPrintFromExcel

   ::Super:BeginDocX()
   ::cDocument := ParseName( ::Cargo, "html" )

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndDocX() CLASS THtmlPrintFromExcel

   LOCAL nCol, bErrorBlock, lOk := .T.

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
         MsgStop( _OOHG_Messages( MT_PRINTER, 45 ) + Chr( 13 ) + ::cDocument, _OOHG_Messages( MT_PRINTER, 12 ) )
      ENDIF
      lOk := .F.
   END SEQUENCE
   ErrorBlock( bErrorBlock )

   ::oBook:Close( .F. )
   ::oBook := NIL

   IF lOk .AND. ::ImPreview
      IF ShellExecute( 0, "open", "rundll32.exe", "url.dll,FileProtocolHandler " + ::cDocument, , 1) <= 32
         IF ::lShowErrors
            MsgStop( _OOHG_Messages( MT_PRINTER, 37 ) + Chr( 13 ) + Chr( 13 ) + _OOHG_Messages( MT_PRINTER, 36 ) + Chr( 13 ) + ::cDocument, _OOHG_Messages( MT_PRINTER, 12 ) )
         ENDIF
         lOk := .F.
      ENDIF
   ENDIF

   RETURN lOk

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InitX( cLang ) CLASS THtmlPrintFromExcel

   ::Super:InitX( cLang )
   ::cPrintLibrary := "HTMLPRINTFROMEXCEL"
   ::lPrError := .F.

   RETURN .T.


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS THtmlPrintFromCalc FROM TCalcPrint

   DATA Type                      INIT "HTMLPRINTFROMCALC"   READONLY

   METHOD BeginDocX
   METHOD EndDocX
   METHOD InitX

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginDocX() CLASS THtmlPrintFromCalc

   ::Super:BeginDocX()
   ::cDocument := ParseName( ::Cargo, "html" )

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndDocX() CLASS THtmlPrintFromCalc

   LOCAL bErrorBlock, oPropertyValue, lOk := .T.

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
         MsgStop( _OOHG_Messages( MT_PRINTER, 45 ) + Chr( 13 ) + ::cDocument, _OOHG_Messages( MT_PRINTER, 12 ) )
      ENDIF
      lOk := .F.
   END SEQUENCE
   ErrorBlock( bErrorBlock )

   ::oDocument:Close( 1 )
   ::oDocument := NIL

   IF lOk .AND. ::ImPreview
      IF ShellExecute( 0, "open", "rundll32.exe", "url.dll,FileProtocolHandler " + ::cDocument, , 1) <= 32
         IF ::lShowErrors
            MsgStop( _OOHG_Messages( MT_PRINTER, 37 ) + Chr( 13 ) + Chr( 13 ) + _OOHG_Messages( MT_PRINTER, 36 ) + Chr( 13 ) + ::cDocument, _OOHG_Messages( MT_PRINTER, 12 ) )
         ENDIF
         lOk := .F.
      ENDIF
   ENDIF

   RETURN lOk

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InitX( cLang ) CLASS THtmlPrintFromCalc

   ::Super:InitX( cLang )
   ::cPrintLibrary := "HTMLPRINTFROMCALC"
   ::lPrError := .F.

   RETURN .T.


#define RTF_FONT_TABLE  2
#define RTF_COLOR_TABLE 3

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TRtfPrint FROM TPrintBase

   DATA aPrintRtf                 INIT {}                    READONLY    // Document lines
   DATA nPrintRtf                 INIT 0                     READONLY    // Last font size used
   DATA nFontSize                 INIT 10                    READONLY    // In TPrintBase is 12
   DATA nMarginLef                INIT 10                    READONLY    // in mm
   DATA nMarginSup                INIT 15                    READONLY    // in mm
   DATA nMarginRig                INIT 10                    READONLY    // in mm
   DATA nMarginInf                INIT 15                    READONLY    // in mm
   DATA Type                      INIT "RTFPRINT"            READONLY

   METHOD BeginDocX
   METHOD EndDocX
   METHOD EndPageX
   METHOD InitX
   METHOD PrintDataX
   METHOD PrintImage              BLOCK { || NIL }
   METHOD PrintLineX
   METHOD SelPrinterX
   METHOD SetPageMargins
   /*
   TODO: Add BeginPageX
   TODO: Add SetFontX to change default font, adding it
         to the font table if is not included (only if
         the font table is already initialized).
   */

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InitX( cLang ) CLASS TRtfPrint

   HB_SYMBOL_UNUSED( cLang )

   ::cPrintLibrary := "RTFPRINT"
   ::lPrError := .F.

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetPageMargins( nMarginLef, nMarginSup, nMarginRig, nMarginInf) CLASS TRtfPrint

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
METHOD BeginDocX() CLASS TRtfPrint

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

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndDocX() CLASS TRtfPrint

   LOCAL i, bErrorBlock, lOk := .T.

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
               MsgStop( _OOHG_Messages( MT_PRINTER, 38 ) + Chr( 13 ) + Chr( 13 ) + _OOHG_Messages( MT_PRINTER, 36 ) + Chr( 13 ) + ::cDocument, _OOHG_Messages( MT_PRINTER, 12 ) )
            ENDIF
            lOk := .F.
         ENDIF
      ENDIF
   RECOVER
      IF ::lShowErrors
         MsgStop( _OOHG_Messages( MT_PRINTER, 45 ) + Chr( 13 ) + ::cDocument, _OOHG_Messages( MT_PRINTER, 12 ) )
      ENDIF
      lOk := .F.
   END SEQUENCE
   ErrorBlock( bErrorBlock )

   ::aPrintRtf := {}

   RETURN lOk

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndPageX() CLASS TRtfPrint

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

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintDataX( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, cText, lItalic, nAngle, lUnder, lStrike, nWidth ) CLASS TRtfPrint

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

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintLineX( nLin, nCol, nLinF, nColF, atColor, ntwPen ) CLASS TRtfPrint

   HB_SYMBOL_UNUSED( ntwPen )

   IF nLin == nLinF
      ::PrintDataX( nLin, nCol, , ::cFontName, ::nFontSize, ::lFontBold, atColor, "L", , Replicate( "-", nColF - nCol + 1 ), ::lFontItalic, ::nFontAngle, ::lFontUnderline, ::lFontStrikeout, ::nFontWidth )
   ENDIF

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SelPrinterX( lSelect, lPreview, lLandscape, nPaperSize, cPrinterX, nRes, nBin, nDuplex, lCollate, nCopies, lColor, nScale, nPaperLength, nPaperWidth, cLang ) CLASS TRtfPrint

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
   HB_SYMBOL_UNUSED( cLang )

   ASSIGN ::lLandscape VALUE lLandscape TYPE "L" DEFAULT .F.

   ::cPrinter := "RTF"

   RETURN .T.


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TCsvPrint FROM TPrintBase

   DATA aPrintCsv                 INIT {}                    READONLY
   DATA Type                      INIT "CSVPRINT"            READONLY

   METHOD BeginDocX
   METHOD EndDocX
   METHOD EndPageX
   METHOD InitX
   METHOD PrintDataX
   METHOD PrintImage              BLOCK { || NIL }
   METHOD SelPrinterX             BLOCK { |Self| ::cPrinter := "CSV" }
   /*
   TODO: Add SelPrinterX to open a dialog to select file.
   */

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginDocX() CLASS TCsvPrint

   ::cDocument := ParseName( ::Cargo, "csv" )

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InitX( cLang ) CLASS TCsvPrint

   HB_SYMBOL_UNUSED( cLang )

   ::cPrintLibrary := "CSVPRINT"
   ::lPrError := .F.

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndDocX() CLASS TCsvPrint

   LOCAL i, lOk := .T.

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
            MsgStop( _OOHG_Messages( MT_PRINTER, 39 ) + Chr( 13 ) + Chr( 13 ) + _OOHG_Messages( MT_PRINTER, 36 ) + Chr( 13 ) + ::cDocument, _OOHG_Messages( MT_PRINTER, 12 ) )
         ENDIF
         lOk := .F.
      ENDIF
   ENDIF
   ::aPrintCsv := {}

   RETURN lOk

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndPageX() CLASS TCsvPrint

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

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintDataX( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, cText, lItalic, nAngle, lUnder, lStrike, nWidth ) CLASS TCsvPrint

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

   RETURN .T.


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TPdfPrint FROM TPrintBase

   DATA aPaper                    INIT {}                    READONLY // paper types supported by pdf class
   DATA cPageSize                 INIT ""                    READONLY // page size
   DATA oPDF                      INIT NIL                   READONLY // reference to the TPDF object
   DATA Type                      INIT "PDFPRINT"            READONLY

   METHOD BeginDocX
   METHOD BeginPageX
   METHOD EndDocX
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

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD MaxCol CLASS TPdfPrint

   LOCAL nRet

   IF ::cUnits == "MM"
      nRet := ::oPDF:Width( "M" ) - ::oPDF:Left( "M" ) * 2
   ELSE
      nRet := ::oPDF:Width( "R" ) - ::oPDF:Left( "R" ) * 2
   ENDIF

   RETURN nRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD MaxRow CLASS TPdfPrint

   LOCAL nRet

   IF ::cUnits == "MM"
      nRet := ::oPDF:Bottom( "M" )
   ELSE
      nRet := ::oPDF:Bottom( "R" )
   ENDIF

   RETURN nRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InitX( cLang ) CLASS TPdfPrint

   HB_SYMBOL_UNUSED( cLang )

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
   ::lPrError := .F.

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginDocX() CLASS TPdfPrint

   ::cDocument := ParseName( ::Cargo, "pdf" )
   ::oPdf := TPDF():Init( ::cDocument )

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndDocX() CLASS TPdfPrint

   LOCAL lOk := .T.

   ::oPdf:Close()
   IF ::ImPreview
      IF ShellExecute( 0, "open", "rundll32.exe", "url.dll,FileProtocolHandler " + ::cDocument, , 1) <= 32
         IF ::lShowErrors
            MsgStop( _OOHG_Messages( MT_PRINTER, 40 ) + Chr( 13 ) + Chr( 13 ) + _OOHG_Messages( MT_PRINTER, 36 ) + Chr( 13 ) + ::cDocument, _OOHG_Messages( MT_PRINTER, 12 ) )
         ENDIF
         lOk := .F.
      ENDIF
   ENDIF

   RETURN lOk

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginPageX() CLASS TPdfPrint

   ::oPdf:NewPage( ::cPageSize, iif( ::lLandscape, "L", "P" ), NIL, ::cFontName, ::nFontType, ::nFontSize )

   RETURN ::cPageName

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintDataX( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, cText, lItalic, nAngle, lUnder, lStrike, nWidth ) CLASS TPdfPrint

   LOCAL nType, cColor, cRealText, nSpaces

   HB_SYMBOL_UNUSED( uData )
   HB_SYMBOL_UNUSED( cAlign )
   HB_SYMBOL_UNUSED( nLen )
   HB_SYMBOL_UNUSED( nAngle )
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
   ELSE
      IF cAlign $ "CR"
         cRealText := LTrim( cText )
         nSpaces := Len( cText ) - Len( cRealText )
         cText := cRealText
      ELSE
         nSpaces := 0
      ENDIF
   ENDIF

   cText := cColor + cText
   IF lUnder
      cText := ::oPdf:Underline( cText )
   ENDIF

   IF ::cUnits == "MM"
      IF cAlign == "C"
         ::oPdf:Center( cText, nLin, nCol + nLen / 2, "M" )
      ELSEIF cAlign == "R"
         ::oPdf:RJust( cText, nLin, nCol + nLen - 1, "M" )
      ELSE
         ::oPdf:AtSay( cText, nLin, nCol, "M" )
      ENDIF
   ELSE
      ::oPdf:AtSay( cText, nLin * ::nmVer + ::nvFij, ( nCol + nSpaces ) * ::nmHor + ::nhFij * 2, "M" )
   ENDIF

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintBarcodeX( nLin, nCol, nLinF, nColF, atColor ) CLASS TPdfPrint

   LOCAL cColor

   IF HB_ISARRAY( atColor )
      cColor := Chr( 253 ) + Chr( atColor[1] ) + Chr( atColor[2] ) + Chr( atColor[3] )
   ELSE
      cColor := NIL
   ENDIF

   ::oPdf:Box( nLin, nCol, nLinF, nColF, 0, 1, "M", cColor, "t1" )

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintImageX( nLin, nCol, nLinF, nColF, cImage, aResol, aSize, aExt ) CLASS TPdfPrint

   LOCAL nVDispl := 0.980
   LOCAL nHDispl := 1.300
   LOCAL nWidth, nHeight
   LOCAL nH, nW

   HB_SYMBOL_UNUSED( aResol )
   HB_SYMBOL_UNUSED( aExt )

   IF HB_ISSTRING( cImage )
      cImage := Upper( cImage )
      // The only supported image formats are bmp, jpg and tiff.
      IF AScan( { ".bmp", ".jpg", ".jpeg", ".tif", ".tiff" }, Lower( SubStr( cImage, RAt( ".", cImage ) ) ) ) == 0
         RETURN .F.
      ENDIF
   ELSE
     RETURN .F.
   ENDIF

   IF HB_ISLOGICAL( aSize ) .AND. aSize
      nH := 0
      nW := 0
   ELSE
      nHeight := nLinF - nLin   // when nHeight is zero, the image is printed at its real height and resolution
      nWidth  := nColF - nCol   // when nWidth is zero, the image is printed at its real width and resolution
      IF ::cUnits == "MM"
         nH := nHeight
         nW := nWidth
      ELSE
         nH := nHeight * ::nmVer * nVDispl + ::nvFij
         nW := nWidth * ::nmHor + ::nhFij * nHDispl
      ENDIF
   ENDIF

   // TODO: Add support for images in the resource file (copy them to a temp file or use a hidden image control)

   IF ::cUnits == "MM"
      ::oPdf:Image( cImage, nLin, nCol, "M", nH, nW )
   ELSE
      ::oPdf:Image( cImage, nLin * ::nmVer * nVDispl + ::nvFij, nCol * ::nmHor + ::nhFij * nHDispl, "M", nH, nW )
   ENDIF

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintLineX( nLin, nCol, nLinF, nColF, atColor, ntwPen, lSolid ) CLASS TPdfPrint

   LOCAL ctColor

   // TODO: check if we can print oblique lines
   HB_SYMBOL_UNUSED( lSolid )

   IF HB_ISARRAY( atColor )
      ctColor := Chr( 253 ) + Chr( atColor[1] ) + Chr( atColor[2] ) + Chr( atColor[3] )
   ELSE
      ctColor := NIL
   ENDIF

   IF ::cUnits == "MM"
      ::oPdf:_OOHG_Line( ( nLin - 0.9 ) + ::nvFij, ( nCol + 1.3 ) + ::nhFij, ( nLinF - 0.9 ) + ::nvFij, ( nColF + 1.3 ) + ::nhFij, ntwPen * 1.2, ctColor )
   ELSE
      ::oPdf:_OOHG_Line( ( nLin - 0.9 ) * ::nmVer + ::nvFij, ( nCol + 1.3 ) * ::nmHor + ::nhFij, ( nLinF - 0.9 ) * ::nmVer + ::nvFij, ( nColF + 1.3 ) * ::nmHor+ ::nhFij, ntwPen * 1.2, ctColor )
   ENDIF

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintRectangleX( nLin, nCol, nLinF, nColF, atColor, ntwPen, lSolid, arColor ) CLASS TPdfPrint

   LOCAL ctColor, crColor

   HB_SYMBOL_UNUSED( lSolid )

   IF HB_ISARRAY( atColor )
      ctColor := Chr( 253 ) + Chr( atColor[1] ) + Chr( atColor[2] ) + Chr( atColor[3] )
   ELSE
      ctColor := NIL
   ENDIF
   IF HB_ISARRAY( arColor )
      crColor := Chr( 253 ) + Chr( arColor[1] ) + Chr( arColor[2] ) + Chr( arColor[3] )
   ELSE
      crColor := NIL
   ENDIF

   IF ::cUnits == "MM"
      ::oPdf:_OOHG_Box( ( nLin - 0.9 ) + ::nvFij, ( nCol + 1.3 ) + ::nhFij, ( nLinF - 0.9 ) + ::nvFij, ( nColF + 1.3 ) + ::nhFij, ntwPen * 1.2, ctColor, crColor )
   ELSE
      ::oPdf:_OOHG_Box( ( nLin - 0.9 ) * ::nmVer + ::nvFij, ( nCol + 1.3 ) * ::nmHor + ::nhFij, ( nLinF - 0.9 ) * ::nmVer + ::nvFij, ( nColF + 1.3 ) * ::nmHor+ ::nhFij, ntwPen * 1.2, ctColor, crColor )
   ENDIF

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintRoundRectangleX( nLin, nCol, nLinF, nColF, atColor, ntwPen, lSolid, arColor ) CLASS TPdfPrint

   // We can't have a rounded rectangle so we make a rectangular one
   ::PrintRectangleX( nLin, nCol, nLinF, nColF, atColor, ntwPen, lSolid, arColor )

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ReleaseX() CLASS TPdfPrint

   ::oPdf := NIL

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SelPrinterX( lSelect, lPreview, lLandscape, nPaperSize, cPrinterX, nRes, nBin, nDuplex, lCollate, nCopies, lColor, nScale, nPaperLength, nPaperWidth, cLang ) CLASS TPdfPrint

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
   HB_SYMBOL_UNUSED( cLang )

   ASSIGN ::lLandscape VALUE lLandscape TYPE "L" DEFAULT .F.
   ASSIGN nPaperSize   VALUE nPaperSize TYPE "N" DEFAULT 0

   nPos := AScan( ::aPaper, { | x | x[ 1 ] == nPaperSize } )
   If nPos > 0
      ::cPageSize := ::aPaper[ nPos ][ 2 ]
   ELSE
      ::cPageSize := "LETTER"
   ENDIF

   ::cPrinter := "PDF"

   RETURN .T.


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TCalcPrint FROM TPrintBase
// CALC contributed by Jose Miguel, adapted by CVC

   DATA oCell                     INIT NIL                   READONLY
   DATA oDesktop                  INIT NIL                   READONLY
   DATA oDocument                 INIT NIL                   READONLY
   DATA oSchedule                 INIT NIL                   READONLY
   DATA oServiceManager           INIT NIL                   READONLY
   DATA oSheet                    INIT NIL                   READONLY
   DATA nHorzResol                INIT PixelsPerInchX()      READONLY
   DATA nVertResol                INIT PixelsPerInchY()      READONLY
   DATA Type                      INIT "CALCPRINT"           READONLY

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
   /*
   TODO: Add METHOD PrintLineX using cell borders.
   TODO: Add METHOD PrintRectangleX using cell borders.
   TODO: Add SelPrinterX to open a dialog to select file.
   TODO: Add support for "printing" in multiple cells.
   */

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InitX( cLang ) CLASS TCalcPrint

   LOCAL bErrorBlock := ErrorBlock( { | x | Break( x ) } )

   HB_SYMBOL_UNUSED( cLang )

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
      ::lPrError := .F.
   RECOVER
      IF ::lShowErrors
         MsgStop( _OOHG_Messages( MT_PRINTER, 44 ), _OOHG_Messages( MT_PRINTER, 12 ) )
      ENDIF
      ::lPrError := .T.
   END SEQUENCE
   ErrorBlock( bErrorBlock )

   RETURN ( ! ::lPrError )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ReleaseX() CLASS TCalcPrint

   LOCAL bErrorBlock := ErrorBlock( { | x | Break( x ) } )

   BEGIN SEQUENCE
      ::oDesktop:Terminate()
   END SEQUENCE
   ErrorBlock( bErrorBlock )
   ::oDesktop := NIL
   ::oServiceManager := NIL

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginDocX() CLASS TCalcPrint

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

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BeginPageX() CLASS TCalcPrint

   ::oSheet := ::oDocument:GetCurrentController:GetActiveSheet()
   IF ::lSeparateSheets
      ::oSheet:Name := ::cPageName
      ::oSheet:CharFontName := ::cFontName
      ::oSheet:CharHeight := ::nFontSize
   ENDIF

   RETURN ::cPageName

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndDocX() CLASS TCalcPrint

   LOCAL bErrorBlock, lOk := .T.

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
         MsgStop( _OOHG_Messages( MT_PRINTER, 45 ) + Chr( 13 ) + ::cDocument, _OOHG_Messages( MT_PRINTER, 12 ) )
      ENDIF
      lOk := .F.
   END SEQUENCE
   ErrorBlock( bErrorBlock )

   ::oDocument:Close( 1 )
   ::oDocument := NIL

   IF lOk .AND. ::ImPreview
      IF ShellExecute( 0, "open", "rundll32.exe", "url.dll,FileProtocolHandler " + ::cDocument, , 1) <= 32
         IF ::lShowErrors
            MsgStop( _OOHG_Messages( MT_PRINTER, 41 ) + Chr( 13 ) + Chr( 13 ) + _OOHG_Messages( MT_PRINTER, 36 ) + Chr( 13 ) + ::cDocument, _OOHG_Messages( MT_PRINTER, 12 ) )
         ENDIF
         lOk := .F.
      ENDIF
   ENDIF

   RETURN lOk

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndPageX() CLASS TCalcPrint

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

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintDataX( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, cText, lItalic, nAngle, lUnder, lStrike, nWidth ) CLASS TCalcPrint

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

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintImageX( nLin, nCol, nLinF, nColF, cImage, aResol, aSize, aExt ) CLASS TCalcPrint

   LOCAL cURL, oGraph, oPage, cName, cFullName, oSize, aImgSize, oTable, oShape, nW, nH, lUseResol, i

   HB_SYMBOL_UNUSED( aExt )

   IF nLin < 1
      nLin := 1
   ENDIF
   IF nLinF < 1
      nLinF := 1
   ENDIF
   IF nLinF < nLin
      nLinF := nLin
   ENDIF
   IF nCol < 1
      nCol := 1
   ENDIF
   IF nColF < 1
      nColF := 1
   ENDIF
   IF nColF < nCol
      nColF := nCol
   ENDIF
   nLin++
   nLinF++
   IF ::nUnitsLin > 1
      nLin := Round( nLin / ::nUnitsLin, 0 )
      nCol := Round( nCol / ::nUnitsLin, 0 )
      nLinF := Round( nLinF / ::nUnitsLin, 0 )
      nColF := Round( nColF / ::nUnitsLin, 0 )
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
         ELSEIF HB_ISLOGICAL( aSize )
            IF aSize
               lUseResol := .T.
               nW := ::nHorzResol
               nH := ::nVertResol
            ELSE
               lUseResol := .F.
               nW := 0
               FOR i := nCol TO nColF
                  nW += ::oSheet:Columns:GetByIndex( i - 1 ):Width
               NEXT i
               nH := 0
               FOR i := nLin TO nLinF
                  nH += ::oSheet:Rows:GetByIndex( i - 1 ):Height
               NEXT i
            ENDIF
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

   RETURN .T.

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

   ASSIGN lShowErrors VALUE lShowErrors TYPE "L" DEFAULT .T.
   IF ValType( cCode ) == 'C'
      cCode := Upper( cCode )
      FOR n := 1 TO Len( cCode )
         IF ( nCar := At( SubStr( cCode, n, 1 ), CODABAR_CHARS ) ) > 0
            cBarcode += CODABAR_CODES[ nCar ]
         ENDIF
      NEXT
   ELSE
      IF lShowErrors
         MsgStop( _OOHG_Messages( MT_PRINTER, 42 ), _OOHG_Messages( MT_PRINTER, 12 ) )
      ENDIF
   ENDIF

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

   ASSIGN lShowErrors VALUE lShowErrors TYPE "L" DEFAULT .T.
   IF ValType( cCode ) != 'C'
      IF lShowErrors
         MsgStop( _OOHG_Messages( MT_PRINTER, 42 ), _OOHG_Messages( MT_PRINTER, 12 ) )
      ENDIF
      RETURN ""
   ENDIF
   IF ! Empty( cMode )
      IF ValType( cMode ) == 'C' .AND. Upper( cMode ) $ 'ABC'
         cMode := Upper( cMode )
      ELSE
         IF lShowErrors
            MsgStop( _OOHG_Messages( MT_PRINTER, 43 ), _OOHG_Messages( MT_PRINTER, 12 ) )
         ENDIF
         RETURN ""
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

   ASSIGN lShowErrors VALUE lShowErrors TYPE "L" DEFAULT .T.
   IF ValType( cCode ) != 'C'
      IF lShowErrors
         MsgStop( _OOHG_Messages( MT_PRINTER, 42 ), _OOHG_Messages( MT_PRINTER, 12 ) )
      ENDIF
      RETURN ""
   ENDIF
   ASSIGN lCheck VALUE lCheck TYPE "L" DEFAULT .F.

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

   ASSIGN lShowErrors VALUE lShowErrors TYPE "L" DEFAULT .T.
   IF ValType( cCode ) != 'C'
      IF lShowErrors
         MsgStop( _OOHG_Messages( MT_PRINTER, 42 ), _OOHG_Messages( MT_PRINTER, 12 ) )
      ENDIF
      RETURN ""
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

   ASSIGN cCode VALUE cCode TYPE "C" DEFAULT '0'
   ASSIGN nLen  VALUE nLen  TYPE "N" DEFAULT 11
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

   ASSIGN lShowErrors VALUE lShowErrors TYPE "L" DEFAULT .T.
   IF ValType( cCode ) != 'C'
      IF lShowErrors
         MsgStop( _OOHG_Messages( MT_PRINTER, 42 ), _OOHG_Messages( MT_PRINTER, 12 ) )
      ENDIF
      RETURN ""
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

   ASSIGN lShowErrors VALUE lShowErrors TYPE "L" DEFAULT .T.
   IF ValType( cCode ) != 'C'
      IF lShowErrors
         MsgStop( _OOHG_Messages( MT_PRINTER, 42 ), _OOHG_Messages( MT_PRINTER, 12 ) )
      ENDIF
      RETURN ""
   ENDIF
   ASSIGN lMode VALUE lMode TYPE "L" DEFAULT .T.

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

   ASSIGN lShowErrors VALUE lShowErrors TYPE "L" DEFAULT .T.
   IF ValType( cCode ) != 'C'
      IF lShowErrors
         MsgStop( _OOHG_Messages( MT_PRINTER, 42 ), _OOHG_Messages( MT_PRINTER, 12 ) )
      ENDIF
      RETURN ""
   ENDIF
   ASSIGN lCheck VALUE lCheck TYPE "L" DEFAULT .F.

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

   ASSIGN lShowErrors VALUE lShowErrors TYPE "L" DEFAULT .T.
   IF ValType( cCode ) != 'C'
      IF lShowErrors
         MsgStop( _OOHG_Messages( MT_PRINTER, 42 ), _OOHG_Messages( MT_PRINTER, 12 ) )
      ENDIF
      RETURN ""
   ENDIF
   ASSIGN lCheck VALUE lCheck TYPE "L" DEFAULT .F.

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

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION ArrayIsValidColor( aColor )

   RETURN HB_ISARRAY( aColor ) .AND. ;
          HB_ISNUMERIC( aColor[1] ) .AND. aColor[1] >= 0 .AND. aColor[1] <= 255 .AND. ;
              HB_ISNUMERIC( aColor[2] ) .AND. aColor[2] >= 0 .AND. aColor[2] <= 255 .AND. ;
              HB_ISNUMERIC( aColor[3] ) .AND. aColor[3] >= 0 .AND. aColor[3] <= 255



#pragma BEGINDUMP

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
HB_FUNC( GETPRINTERSINFO )          /* FUNCTION GetPrintersInfo() -> cBuffer */
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
HB_FUNC( PIXELSPERINCHX )          /* FUNCTION PixelsPerInchX() -> nPPI */
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
HB_FUNC( PIXELSPERINCHY )          /* FUNCTION PixelsPerInchY() -> nPPI */
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
