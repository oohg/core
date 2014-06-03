/*
* $Id: h_print.prg,v 1.134 2014-06-03 00:34:12 fyurisich Exp $
*/

#include 'hbclass.ch'
#include 'oohg.ch'
#include 'miniprint.ch'
#define NO_HBPRN_DECLARATION
#include 'winprint.ch'
#include "fileio.ch"

#ifndef _BARCODE_
#define _BARCODE_

MEMVAR _OOHG_PrintLibrary
MEMVAR _OOHG_PRINTER_DocName
MEMVAR _HMG_PRINTER_APRINTERPROPERTIES
MEMVAR _HMG_PRINTER_HDC
MEMVAR _HMG_PRINTER_COPIES
MEMVAR _HMG_PRINTER_COLLATE
MEMVAR _HMG_PRINTER_PREVIEW
MEMVAR _HMG_PRINTER_TIMESTAMP
MEMVAR _HMG_PRINTER_NAME
MEMVAR _HMG_PRINTER_PAGECOUNT
MEMVAR _HMG_PRINTER_HDC_BAK

#define hbprn ::oHBPrn

*-----------------------------------------------------------------------------*
FUNCTION TPrint( cLibX )
*-----------------------------------------------------------------------------*
LOCAL o_Print_

   IF cLibX = NIL
      IF Type("_OOHG_PrintLibrary") = "C"
         IF _OOHG_PrintLibrary = "HBPRINTER"
            o_Print_ := thbprinter()
         ELSEIF _OOHG_PrintLibrary = "MINIPRINT"
            o_Print_ := tminiprint()
         ELSEIF _OOHG_PrintLibrary = "DOSPRINT"
            o_Print_ := tdosprint()
         ELSEIF _OOHG_PrintLibrary = "EXCELPRINT"
            o_Print_ := texcelprint()
         ELSEIF _OOHG_PrintLibrary = "CALCPRINT"
            o_Print_ := tcalcprint()
         ELSEIF _OOHG_PrintLibrary = "RTFPRINT"
            o_Print_ := trtfprint()
         ELSEIF _OOHG_PrintLibrary = "CSVPRINT"
            o_Print_ := tcsvprint()
         ELSEIF _OOHG_PrintLibrary = "HTMLPRINT"
            o_Print_ := thtmlprint()
         ELSEIF _OOHG_PrintLibrary = "PDFPRINT"
            o_Print_ := tpdfprint()
         ELSEIF _OOHG_PrintLibrary = "RAWPRINT"
            o_Print_ := tRAWprint()
         ELSEIF _OOHG_PrintLibrary = "SPREADSHEETPRINT"
            o_Print_ := tspreadsheetprint()

         ELSE
            o_Print_ := thbprinter()
         ENDIF
      ELSE
         o_Print_ := tminiprint()
         _OOHG_PrintLibrary := "MINIPRINT"
      ENDIF
   ELSE
      IF ValType( cLibX ) = "C"
         IF cLibX = "HBPRINTER"
            o_Print_ := thbprinter()
         ELSEIF cLibX = "MINIPRINT"
            o_Print_ := tminiprint()
         ELSEIF cLibX = "DOSPRINT"
            o_Print_ := tdosprint()
         ELSEIF cLibX = "EXCELPRINT"
            o_Print_ := texcelprint()
         ELSEIF cLibX = "CALCPRINT"
            o_Print_ := tcalcprint()
         ELSEIF cLibX = "RTFPRINT"
            o_Print_ := trtfprint()
         ELSEIF cLibX = "CSVPRINT"
            o_Print_ := tcsvprint()
         ELSEIF cLibX = "HTMLPRINT"
            o_Print_ := thtmlprint()
         ELSEIF cLibX = "PDFPRINT"
            o_Print_ := tpdfprint()
         ELSEIF cLibX = "RAWPRINT"
            o_Print_ := trawprint()
         ELSEIF cLibX = "SPREADSHEETPRINT"
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





CLASS TPRINTBASE

   DATA cPrintLibrary      INIT "HBPRINTER"   READONLY
   DATA nmHor              INIT ( 10 / 4.75 ) READONLY
   DATA nmVer              INIT ( 10 / 2.35 ) READONLY
   DATA nhFij              INIT ( 12 / 3.70 ) READONLY
   DATA nvFij              INIT ( 12 / 1.65 ) READONLY
   DATA cUnits             INIT "ROWCOL"      READONLY
   DATA nLMargin           INIT 0
   DATA nTMargin           INIT 0
   DATA cPrinter           INIT ""            READONLY
   DATA aPrinters          INIT {}            READONLY
   DATA aPorts             INIT {}            READONLY
   DATA lPrError           INIT .F.           READONLY
   DATA Exit               INIT .F.           READONLY
   DATA aColor             INIT {0, 0, 0}     READONLY    // brush color
   DATA cFontName          INIT "Courier New" READONLY
   DATA nFontSize          INIT 12                        // never set READONLY
   DATA aFontColor         INIT {0, 0, 0}     READONLY    // font color
   DATA lFontBold          INIT .F.           READONLY
   DATA lFontItalic        INIT .F.           READONLY
   DATA nwPen              INIT 0.1           READONLY    // pen width
   DATA TempFile           INIT GetTempDir() + "T" + AllTrim( Str( Int( HB_Random( 999999 ) ), 8 ) ) + ".prn" READONLY
   DATA ImPreview          INIT .F.           READONLY
   DATA lWinHide           INIT .T.           READONLY
   DATA cVersion           INIT "(oohg-tprint)V 4.9" READONLY
   DATA Cargo              INIT "list"                    // document name
   DATA nLinPag            INIT 0             READONLY
   DATA aLinCelda          INIT {}            READONLY
   DATA nUnitsLin          INIT 1             READONLY
   DATA lProp              INIT .F.           READONLY
   DATA cPort              INIT "prn"

   METHOD Init
   METHOD InitX            BLOCK { || NIL }
   METHOD SetProp
   METHOD SetCpl
   METHOD BeginDoc
   METHOD BeginDocX        BLOCK { || NIL }
   METHOD EndDoc
   METHOD EndDocX          BLOCK { || NIL }
   METHOD PrintDos
   METHOD PrintDosX        BLOCK { || NIL }
   METHOD PrintRaw
   METHOD PrintRawX        BLOCK { || NIL }
   METHOD BeginPage
   METHOD BeginPageX       BLOCK { || NIL }
   METHOD CondenDos        BLOCK { || NIL }
   METHOD CondenDosX       BLOCK { || NIL }
   METHOD NormalDos        BLOCK { || NIL }
   METHOD NormalDosX       BLOCK { || NIL }
   METHOD EndPage
   METHOD EndPageX         BLOCK { || NIL }
   METHOD Release
   METHOD ReleaseX         BLOCK { || NIL }
   METHOD PrintData
   METHOD PrintDataX       BLOCK { || NIL }
   METHOD PrintBarcode
   METHOD PrintBarcodeX    BLOCK { || NIL }
   METHOD Ean13
   METHOD Code128
   METHOD Code3_9
   METHOD Int25
   METHOD Ean8
   METHOD Upca
   METHOD Sup5
   METHOD Codabar
   METHOD Ind25
   METHOD Mat25
   METHOD Go_Code
   METHOD PrintImage
   METHOD PrintImageX      BLOCK { || NIL }
   METHOD PrintLine
   METHOD PrintLineX       BLOCK { || NIL }
   METHOD PrintRectangle
   METHOD PrintRectangleX  BLOCK { || NIL }
   METHOD SelPrinter
   METHOD SelPrinterX      BLOCK { || NIL }
   METHOD GetDefPrinter
   METHOD GetDefPrinterX   BLOCK { || NIL }
   METHOD SetColor
   METHOD SetColorX        BLOCK { || NIL }
   METHOD SetFont
   METHOD SetFontX         BLOCK { || NIL }
   METHOD SetPreviewSize
   METHOD SetPreviewSizeX  BLOCK { || NIL }
   METHOD SetUnits                                   // mm or rowcol
   METHOD PrintRoundRectangle
   METHOD PrintRoundRectangleX  BLOCK { || NIL }
   METHOD Version               INLINE ::cVersion
   METHOD SetLMargin
   METHOD SetTMargin
   METHOD PrintMode

ENDCLASS

*-----------------------------------------------------------------------------*
METHOD SetPreviewSize( nSize ) CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
RETURN ::SetPreviewSizeX( nSize )

*-----------------------------------------------------------------------------*
METHOD SetProp( lMode ) CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
   DEFAULT lMode TO .F.
   IF lMode
      ::lProp := .T.
   ELSE
      ::lProp := .F.
   ENDIF
RETURN NIL

*-----------------------------------------------------------------------------*
METHOD SetCpl( nCpl ) CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
   DO CASE
   CASE nCpl = 60
      ::nFontSize := 14
   CASE nCpl = 80
      ::nFontSize := 12
   CASE nCpl = 96
      ::nFontSize := 10
   CASE nCpl = 120
      ::nFontSize := 8
   CASE nCpl = 140
      ::nFontSize := 7
   CASE nCpl = 160
      ::nFontSize := 6
   OTHERWISE
      ::nFontSize := 12
   ENDCASE
RETURN NIL

*-----------------------------------------------------------------------------*
METHOD Release() CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
   IF ::Exit
      RETURN NIL
   ENDIF
   ::ReleaseX()
RETURN NIL

*-----------------------------------------------------------------------------*
METHOD Init() CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
   IF IsWindowActive( _modalhide )
      MsgStop( _OOHG_Messages( 12, 1 ) )
      ::Exit := .T.
      RETURN NIL
   ENDIF
   ::InitX()
RETURN Self

*-----------------------------------------------------------------------------*
METHOD SelPrinter( lSelect, lPreview, lLandscape, nPaperSize, cPrinterX, lHide, nRes, nBin, nDuplex, lCollate, nCopies, lColor, nScale, nPaperLength, nPaperWidth ) CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
   DEFAULT lSelect TO .T.

   IF ::Exit
      ::lPrError := .T.
      RETURN NIL
   ENDIF

   IF lHide # NIL
      ::lWinHide := lHide
   ENDIF

   DEFAULT lLandscape TO .F.

   DEFAULT lPreview TO .T.
   IF lPreview
    ::ImPreview := .T.
   ENDIF

   ::SelPrinterX( lSelect, lPreview, lLandscape, nPaperSize, cPrinterX, nRes, nBin, nDuplex, lCollate, nCopies, lColor, nScale, nPaperLength, nPaperWidth )
RETURN Self

*-----------------------------------------------------------------------------*
METHOD BeginDoc( cDocm ) CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
LOCAL oLabel, oImage, cDoc

   cDoc := _OOHG_Messages( 12, 2 )

   IF HB_IsString( cDocm )
      ::Cargo := cDocm
   ENDIF

   SETPRC( 0, 0 )

   // See ::Init()
   DEFINE WINDOW _modalhide ;
      AT 0,0 ;
      WIDTH 0 HEIGHT 0 ;
      TITLE cDoc MODAL NOSHOW NOSIZE NOSYSMENU NOCAPTION
   END WINDOW
   ACTIVATE WINDOW _modalhide NOWAIT

   IF ! IsWindowDefined( _oohg_winreport )
      DEFINE WINDOW _oohg_winreport ;
         AT 0,0 ;
         WIDTH 400 HEIGHT 120 ;
         TITLE cDoc CHILD NOSIZE NOSYSMENU NOCAPTION

         @ 5, 5 FRAME myframe WIDTH 390 HEIGHT 110

         @ 15, 195 IMAGE image_101 OBJ oImage ;
            PICTURE 'hbprint_print' ;
            WIDTH 25 ;
            HEIGHT 30 ;
            STRETCH ;
            NODIBSECTION

         @ 22, 225 LABEL label_101 VALUE '......' FONT "Courier New" SIZE 10

         @ 55, 10 LABEL label_1 OBJ oLabel VALUE cDoc WIDTH 300 HEIGHT 32 FONT "Courier New"

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

*-----------------------------------------------------------------------------*
METHOD SetLMargin( nLMar ) CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
   ::nLMargin := nLMar
RETURN Self

*-----------------------------------------------------------------------------*
METHOD SetTMargin( nTMar ) CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
   ::nTMargin := nTMar
RETURN Self

*-----------------------------------------------------------------------------*
STATIC FUNCTION Action_Timer( oLabel, oImage )
*-----------------------------------------------------------------------------*
   IF IsWindowDefined( _oohg_winreport )
      oLabel:FontBold := IIF( oLabel:FontBold, .F., .T. )
      oImage:Visible :=  IIF( oLabel:FontBold, .T., .F. )
   ENDIF
RETURN NIL

*-----------------------------------------------------------------------------*
METHOD EndDoc() CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
   ::EndDocX()
   _oohg_winreport.Release()
   _modalhide.Release()
RETURN Self

*-----------------------------------------------------------------------------*
METHOD SetColor( atColor ) CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
   ::aColor := atColor
   ::SetColorX()
RETURN Self

*-----------------------------------------------------------------------------*
METHOD SetFont( cFont, nSize, aColor, lBold, lItalic ) CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
   DEFAULT cFont   TO ::cFontName
   DEFAULT nSize   TO ::nFontSize
   DEFAULT aColor  TO ::aFontColor
   DEFAULT lBold   TO ::lFontBold
   DEFAULT lItalic TO ::lFontItalic

   ::cFontName   := cFont
   ::nFontSize   := nSize
   ::aFontColor  := aColor
   ::lFontBold   := lBold
   ::lFontItalic := lItalic
RETURN Self

*-----------------------------------------------------------------------------*
METHOD BeginPage() CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
   ::BeginPageX()
RETURN Self

*-----------------------------------------------------------------------------*
METHOD EndPage() CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
   ::EndPageX()
RETURN Self

*-----------------------------------------------------------------------------*
METHOD GetDefPrinter() CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
RETURN ::GetDefPrinterX()

*-----------------------------------------------------------------------------*
METHOD SetUnits( cUnitsX, nUnitsLinX ) CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
   IF cUnitsX = "MM"
      ::cUnits := "MM"
   ELSE
      ::cUnits := "ROWCOL"
   ENDIF
   IF nUnitsLinX = NIL
      ::nUnitsLin := 1
   ELSE
      ::nUnitsLin := nUnitsLinX
   ENDIF
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintData( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, lItalic, nAngle ) CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
LOCAL cText, cSpace, uAux, cType := ValType( uData )

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
      cText := DtoC( uData )
   CASE cType == 'L'
      cText := IIF( uData, 'T', 'F' )
   CASE cType == 'M'
      cText := uData
   CASE cType == 'T'
      cText := TtoC( uData )
   CASE cType == 'O'
      cText := "< Object >"
   CASE cType == 'A'
      cText := "< Array >"
   OTHERWISE
      cText := ""
   ENDCASE

   DEFAULT cAlign TO "L"
   DEFAULT nLen   TO 15

   DO CASE
   CASE cAlign = "C"
      cSpace := Space( ( Int( nLen ) - Len( cText ) ) / 2 )
   CASE cAlign = "R"
      cSpace := Space( Int( nLen ) - Len( cText ) )
   OTHERWISE
      cSpace := ""
   ENDCASE

   DEFAULT nLin    TO 1
   DEFAULT nCol    TO 1
   DEFAULT cText   TO ""
   DEFAULT cFont   TO ::cFontName
   DEFAULT nSize   TO ::nFontSize
   DEFAULT aColor  TO ::aFontColor
   DEFAULT lBold   TO ::lFontBold
   DEFAULT lItalic TO ::lFontItalic
   DEFAULT nAngle  TO 0

   IF ::cUnits = "MM"
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

   IF ::cUnits = "MM"
      cText := cText
   ELSE
      cText := cSpace + cText
   ENDIF

   ::PrintDataX( ::nTMargin + nLin, ::nLMargin + nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, cText, lItalic, nAngle )
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintBarcode( nLin, nCol, cBarcode, cType, aColor, lHori, nWidth, nHeight ) CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
LOCAL nSize := 10

   DEFAULT nHeight  TO 10
   DEFAULT nWidth   TO NIL
   DEFAULT cBarcode TO ""
   DEFAULT lHori    TO .T.
   DEFAULT aColor   TO {1, 1, 1}
   DEFAULT cType    TO "CODE128C"
   DEFAULT nLin     TO 1
   DEFAULT nCol     TO 1
   DEFAULT aColor   TO ::aColor

   cBarcode := Upper( cBarcode )

   IF ::cUnits = "MM"
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
   CASE cType = "CODE128A"
      ::Code128( nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2, cBarcode, "A", aColor, lHori, nWidth, nHeight )
   CASE cType = "CODE128B"
      ::Code128( nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2, cBarcode, "B", aColor, lHori, nWidth, nHeight )
   CASE cType = "CODE128C"
      ::Code128( nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2, cBarcode, "C", aColor, lHori, nWidth, nHeight )
   CASE cType = "CODE39"
      ::Code3_9( nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2, cBarcode, aColor, lHori, nWidth, nHeight )
   CASE cType = "EAN8"
      ::Ean8( nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2, cBarcode, aColor, lHori, nWidth, nHeight )
   CASE cType = "EAN13"
      ::Ean13( nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2, cBarcode, aColor, lHori, nWidth, nHeight )
   CASE cType = "INTER25"
      ::Int25( nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2, cBarcode, aColor, lHori, nWidth, nHeight )
   CASE cType = "UPCA"
      ::Upca( nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2, cBarcode, aColor, lHori, nWidth, nHeight )
   CASE cType = "SUP5"
      ::Sup5( nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2, cBarcode, aColor, lHori, nWidth, nHeight )
   CASE cType = "CODABAR"
      ::Codabar( nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2, cBarcode, aColor, lHori, nWidth, nHeight )
   CASE cType = "IND25"
      ::Ind25( nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2, cBarcode, aColor, lHori, nWidth, nHeight )
   CASE cType = "MAT25"
      ::Mat25( nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2, cBarcode, aColor, lHori, nWidth, nHeight )
   ENDCASE
RETURN Self

*-----------------------------------------------------------------------------*
METHOD Ean8( nRow, nCol, cCode, aColor, lHorz, nWidth, nHeigth ) CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
LOCAL nLen := 0

   // TODO: test parameters
   DEFAULT nHeigth TO 1.5
   IF lHorz
      ::Go_Code( _Upc( cCode, 7 ), nRow, nCol, lHorz, aColor, nWidth, nHeigth * 0.90 )
   ELSE
      ::Go_Code( _Upc( cCode, 7 ), nRow, nCol + nLen, lHorz, aColor, nWidth, nHeigth * 0.90 )
   ENDIF
   ::Go_Code( _Ean13bl( 8 ), nRow, nCol, lHorz, aColor, nWidth, nHeigth )
RETURN Self

*-----------------------------------------------------------------------------*
METHOD Ean13( nRow, nCol, cCode, aColor, lHorz, nWidth, nHeigth ) CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
 LOCAL nLen := 0

   // TODO: test parameters
   DEFAULT nHeigth TO 1.5
   IF lHorz
      ::Go_Code( _Ean13( cCode ), nRow, nCol, lHorz, aColor, nWidth, nHeigth * 0.90 )
   ELSE
      ::Go_Code( _Ean13( cCode ), nRow, nCol + nLen, lHorz, aColor, nWidth, nHeigth * 0.90 )
   ENDIF
   ::Go_Code( _Ean13bl( 12 ), nRow, nCol, lHorz, aColor, nWidth, nHeigth )
RETURN Self

*-----------------------------------------------------------------------------*
METHOD Code128( nRow, nCol, cCode, cMode, aColor, lHorz, nWidth, nHeigth ) CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
   // TODO: test parameters

        ::Go_Code( _Code128( cCode, cMode ), nRow, nCol, lHorz, aColor, nWidth, nHeigth )
RETURN Self

*-----------------------------------------------------------------------------*
METHOD Code3_9( nRow, nCol, cCode, aColor, lHorz, nWidth, nHeigth ) CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
LOCAL lCheck := .T.

   // TODO: test parameters
   ::Go_Code( _Code3_9( cCode, lCheck ), nRow, nCol, lHorz, aColor, nWidth, nHeigth )
RETURN Self

*-----------------------------------------------------------------------------*
METHOD Int25( nRow, nCol, cCode, aColor, lHorz, nWidth, nHeigth ) CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
LOCAL lCheck := .T.

   // TODO: test parameters
   ::Go_Code( _int25( cCode, lCheck ), nRow, nCol, lHorz, aColor, nWidth, nHeigth )
RETURN Self

*-----------------------------------------------------------------------------*
METHOD Upca( nRow, nCol, cCode, aColor, lHorz, nWidth, nHeigth ) CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
LOCAL nLen := 0

   // TODO: test parameters
   DEFAULT nHeigth TO 1.5
   IF lHorz
      ::Go_Code( _Upc( cCode ), nRow, nCol, lHorz, aColor, nWidth, nHeigth * 0.90 )
   ELSE
      ::Go_Code( _Upc( cCode ), nRow, nCol + nLen, lHorz, aColor, nWidth, nHeigth * 0.90 )
   ENDIF
   ::Go_Code( _Upcabl( cCode ), nRow, nCol, lHorz, aColor, nWidth, nHeigth )
RETURN Self

*-----------------------------------------------------------------------------*
METHOD Sup5( nRow, nCol, cCode, aColor, lHorz, nWidth, nHeigth ) CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
   ::Go_Code( _Sup5( cCode ), nRow, nCol, lHorz, aColor, nWidth, nHeigth )
RETURN Self

*-----------------------------------------------------------------------------*
METHOD Codabar( nRow, nCol, cCode, aColor, lHorz, nWidth, nHeigth ) CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
   // TODO: test parameters
   ::Go_Code( _Codabar( cCode ), nRow, nCol, lHorz, aColor, nWidth, nHeigth )
RETURN Self

*-----------------------------------------------------------------------------*
METHOD Ind25( nRow, nCol, cCode, aColor, lHorz, nWidth, nHeigth ) CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
LOCAL lCheck := .T.

   // TODO: test parameters
   ::Go_Code( _Ind25( cCode, lCheck ), nRow, nCol, lHorz, aColor, nWidth, nHeigth )
RETURN Self

*-----------------------------------------------------------------------------*
METHOD Mat25( nRow, nCol, cCode, aColor, lHorz, nWidth, nHeigth ) CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
LOCAL lCheck := .T.

   // TODO: test parameters
   ::Go_Code( _Mat25( cCode, lCheck), nRow, nCol, lHorz, aColor, nWidth, nHeigth )
RETURN Self

*-----------------------------------------------------------------------------*
METHOD Go_Code( cBarcode, ny, nx, lHorz, aColor, nWidth, nLen ) CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
LOCAL n

   DEFAULT aColor TO { 0, 0, 0 }
   DEFAULT lHorz  TO .T.
   DEFAULT nWidth TO 0.495           // 1/3 M/mm 0.25 width
   DEFAULT nLen   TO 15             // mm height

   FOR n := 1 TO Len( cBarcode )
      IF SubStr( cBarcode, n, 1 ) = '1'
         IF lHorz
            ::PrintBarcodeX( ny, nx, ny + nLen, nx + nWidth, aColor )
            nx += nWidth
         ELSE
            ::PrintBarcodeX( ny, nx, ny + nWidth, nx + nLen, aColor )
            ny += nWidth
         ENDIF
      ELSE
          //////////////////////////////////
     /////      IF SubStr( cBarcode, n, 1 ) = '1'
      ///   IF lHorz
      ////      ::PrintBarcodeX( ny, nx, ny + nLen, nx + nWidth, {255,255,255} )
          ///  nx += nWidth
       ///  ELSE
      ////      ::PrintBarcodeX( ny, nx, ny + nWidth, nx + nlen , {255,255,255} )
         ///   ny += nWidth
      ////   ENDIF
          /////////////////////////////////
         IF lHorz
            nx += nWidth
         ELSE
            ny += nWidth
         ENDIF
      ENDIF
   NEXT n
RETURN NIL

*-----------------------------------------------------------------------------*
METHOD PrintImage( nLin, nCol, nLinF, nColF, cImage ) CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
   DEFAULT nLin   TO 1
   DEFAULT nCol   TO 1
   DEFAULT cImage TO ""
   DEFAULT nLinF  TO 4
   DEFAULT nColF  TO 4

   IF ::cUnits = "MM"
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

   ::PrintImageX( ::nTMargin + nLin, ::nLMargin + nCol, ::nTMargin + nLinF, ::nLMargin + nColF, cImage )
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintLine( nLin, nCol, nLinF, nColF, atColor, ntwPen ) CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
   DEFAULT nLin    TO 1
   DEFAULT nCol    TO 1
   DEFAULT nLinF   TO 4
   DEFAULT nColF   TO 4
   DEFAULT atColor TO ::aColor
   DEFAULT ntwPen  TO ::nwPen

   IF ::cUnits = "MM"
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

   ::PrintLineX( ::nTMargin + nLin, ::nLMargin + nCol, ::nTMargin + nLinF, ::nLMargin + nColF, atColor, ntwPen )
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintRectangle( nLin, nCol, nLinF, nColF, atColor, ntwPen, arColor ) CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
   DEFAULT nLin    TO 1
   DEFAULT nCol    TO 1
   DEFAULT nLinF   TO 4
   DEFAULT nColF   TO 4
   DEFAULT atColor TO ::aColor
   DEFAULT ntwPen  TO ::nwPen
   DEFAULT arColor TO { 255, 255, 255 }

   IF ::cUnits = "MM"
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

   ::PrintRectangleX( ::nTMargin + nLin, ::nLMargin + nCol, ::nTMargin + nLinF, ::nLMargin + nColF, atColor, ntwPen, arColor )
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintRoundRectangle( nLin, nCol, nLinF, nColF, atColor, ntwPen ) CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
   DEFAULT nLin    TO 1
   DEFAULT nCol    TO 1
   DEFAULT nLinF   TO 4
   DEFAULT nColF   TO 4
   DEFAULT atColor TO ::aColor
   DEFAULT ntwPen  TO ::nwPen

   IF ::cUnits = "MM"
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

   ::PrintRoundRectangleX( ::nTMargin + nLin, ::nLMargin + nCol, ::nTMargin + nLinF, ::nLMargin + nColF, atColor, ntwPen )
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintMode() CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
   DO CASE
   CASE ::cPrintLibrary = "RAWPRINT"
      ::PrintRaw()
   CASE ::cPrintLibrary = "DOSPRINT"
      ::PrintDos()
   ENDCASE
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintDos() CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
LOCAL cBat, nHdl

   cBat := 'b' + AllTrim( Str( HB_Random( 999999 ), 6 ) ) + '.bat'
   nHdl := FCreate( cBat )
   FWrite( nHdl, "copy " + ::TempFile + " " + ::cPort + Chr( 13 ) + Chr( 10 ) )
   FWrite( nHdl, "rem " + _OOHG_Messages( 12, 3 ) + Chr( 13 ) + Chr( 10 ) )
   FClose( nHdl )
   InKey( 1 )
   WaitRun( cBat, 0 )
   FErase( cBat )
RETURN NIL

// Based upon an example of Lucho Miranda (elsanes)
*-----------------------------------------------------------------------------*
METHOD PrintRaw() CLASS TPRINTBASE
*-----------------------------------------------------------------------------*
LOCAL nResult := NIL
LOCAL cMsg := ""
LOCAL aData

   aData := { {  1, ::TempFile + _OOHG_Messages( 12, 4 ) }, ;
              { -1, _OOHG_Messages( 12, 5 ) }, ;
              { -2, _OOHG_Messages( 12, 6 ) }, ;
              { -3, _OOHG_Messages( 12, 7 ) }, ;
              { -4, _OOHG_Messages( 12, 8 ) }, ;
              { -5, _OOHG_Messages( 12, 9 ) }, ;
              { -6, ::TempFile + _OOHG_Messages( 12, 10 ) } }

   IF ! Empty( ::cPrinter )
      InKey( 1 )
      nResult := PrintFileRaw( ::cPrinter, ::TempFile, "raw print" )
      IF nResult # 1
         cMsg += aData[ AScan( aData, { | x | x[ 1 ] == nResult } ), 2 ]
         AutoMsgInfo( cMsg )
      ENDIF
   ELSE
      MsgStop( _OOHG_Messages( 12, 11 ), _OOHG_Messages( 12, 12 ) )
   ENDIF
RETURN NIL





CLASS TMINIPRINT FROM TPRINTBASE

   METHOD InitX
   METHOD BeginDocX
   METHOD EndDocX
   METHOD BeginPageX
   METHOD EndPageX
   METHOD ReleaseX
   METHOD PrintDataX
   METHOD PrintImageX
   METHOD PrintLineX
   METHOD PrintRectangleX
   METHOD SelPrinterX
   METHOD GetDefPrinterX
   METHOD PrintRoundRectangleX
   METHOD PrintBarcodeX
   METHOD SetPreviewSizeX

ENDCLASS

*-----------------------------------------------------------------------------*
METHOD SetPreviewSizeX( nSize ) CLASS TMINIPRINT
*-----------------------------------------------------------------------------*
   IF _HMG_PRINTER_Preview
      IF nSize == NIL .OR. nSize < -9.99 .OR. nSize > 99.99
         nSize := 0
      ENDIF
      SET PREVIEW ZOOM nSize
   ENDIF
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintBarcodeX( y, x, y1, x1, aColor ) CLASS TMINIPRINT
*-----------------------------------------------------------------------------*
   @ y, x PRINT FILL TO y1, x1 COLOR aColor
RETURN Self

*-----------------------------------------------------------------------------*
METHOD InitX() CLASS TMINIPRINT
*-----------------------------------------------------------------------------*
   PUBLIC _HMG_PRINTER_aPrinterProperties
   PUBLIC _HMG_PRINTER_hDC
   PUBLIC _HMG_PRINTER_Copies
   PUBLIC _HMG_PRINTER_Collate
   PUBLIC _HMG_PRINTER_Preview
   PUBLIC _HMG_PRINTER_TimeStamp
   PUBLIC _HMG_PRINTER_Name
   PUBLIC _HMG_PRINTER_PageCount
   PUBLIC _HMG_PRINTER_hDC_Bak
   PUBLIC _HMG_PRINTER_PreviewSize

   ::aPrinters := aPrinters()
   ::cPrintLibrary := "MINIPRINT"
RETURN Self

*-----------------------------------------------------------------------------*
METHOD BeginDocX() CLASS TMINIPRINT
*-----------------------------------------------------------------------------*
   START PRINTDOC NAME ::Cargo
RETURN Self

*-----------------------------------------------------------------------------*
METHOD EndDocX() CLASS TMINIPRINT
*-----------------------------------------------------------------------------*
   END PRINTDOC
RETURN Self

*-----------------------------------------------------------------------------*
METHOD BeginPageX() CLASS TMINIPRINT
*-----------------------------------------------------------------------------*
   START PRINTPAGE
RETURN Self

*-----------------------------------------------------------------------------*
METHOD EndPageX() CLASS TMINIPRINT
*-----------------------------------------------------------------------------*
   END PRINTPAGE
RETURN Self

*-----------------------------------------------------------------------------*
METHOD ReleaseX() CLASS TMINIPRINT
*-----------------------------------------------------------------------------*
   RELEASE _HMG_PRINTER_aPrinterProperties
   RELEASE _HMG_PRINTER_hDC
   RELEASE _HMG_PRINTER_Copies
   RELEASE _HMG_PRINTER_Collate
   RELEASE _HMG_PRINTER_Preview
   RELEASE _HMG_PRINTER_TimeStamp
   RELEASE _HMG_PRINTER_Name
   RELEASE _HMG_PRINTER_PageCount
   RELEASE _HMG_PRINTER_hDC_Bak
   RELEASE _HMG_PRINTER_PreviewSize
RETURN NIL

*-----------------------------------------------------------------------------*
METHOD PrintDataX( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, cText, lItalic, nAngle ) CLASS TMINIPRINT
*-----------------------------------------------------------------------------*
   Empty( uData )
   DEFAULT aColor TO ::aFontColor
   Empty( nLen )
   Empty( nAngle )

   IF ::cUnits = "MM"
      DO CASE
      CASE lItalic
         IF ! lBold
            IF cAlign = "R"
               TextAlign( 2 )
               @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize ITALIC COLOR aColor
            ELSEIF cAlign = "C"
               TextAlign( 1 )
               @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize ITALIC COLOR aColor
            ELSE
               @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize ITALIC COLOR aColor
            ENDIF
         ELSE
            IF cAlign = "R"
               TextAlign( 2 )
               @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD ITALIC COLOR aColor
            ELSEIF cAlign = "C"
               TextAlign( 1 )
               @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD ITALIC COLOR aColor
            ELSE
               @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD ITALIC COLOR aColor
            ENDIF
         ENDIF
      OTHERWISE
         IF ! lBold
            IF cAlign = "R"
               TextAlign( 2 )
               @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize COLOR aColor
            ELSEIF cAlign="C"
               TextAlign( 1 )
               @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize COLOR aColor
            ELSE
               @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize COLOR aColor
            ENDIF
         ELSE
            IF cAlign = "R"
               TextAlign( 2 )
               @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD COLOR aColor
            ELSEIF cAlign = "C"
               TextAlign( 1 )
               @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD COLOR aColor
            ELSE
               @ nLin, nCol PRINT ( cText ) FONT cFont SIZE nSize BOLD COLOR aColor
            ENDIF
         ENDIF
      ENDCASE

      TextAlign( 0 )
   ELSE
      DO CASE
      CASE lItalic
         IF ! lBold
            IF cAlign = "R"
               TextAlign( 2 )
               @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 + ( Len( cText ) ) * ::nmHor PRINT ( cText ) FONT cFont SIZE nSize ITALIC COLOR aColor
               TextAlign( 0 )
            ELSE
               @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT ( cText ) FONT cFont SIZE nSize ITALIC COLOR aColor
            ENDIF
         ELSE
            IF cAlign = "R"
               TextAlign( 2 )
               @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 + ( Len( cText ) ) * ::nmHor PRINT ( cText ) FONT cFont SIZE nSize  BOLD ITALIC COLOR aColor
               TextAlign( 0 )
            ELSE
               @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT ( cText ) FONT cFont SIZE nSize BOLD ITALIC COLOR aColor
            ENDIF
         ENDIF
      OTHERWISE
         IF ! lBold
            IF cAlign = "R"
               TextAlign( 2 )
               @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 + ( Len( cText ) ) * ::nmHor PRINT ( cText ) FONT cFont SIZE nSize COLOR aColor
               TextAlign( 0 )
            ELSE
               @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT ( cText ) FONT cFont SIZE nSize COLOR aColor
            ENDIF
         ELSE
            IF cAlign = "R"
               TextAlign( 2 )
               @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 + ( Len( cText ) ) * ::nmHor PRINT ( cText ) FONT cFont SIZE nSize BOLD COLOR aColor
               TextAlign( 0 )
            ELSE
               @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT ( cText ) FONT cFont SIZE nSize BOLD COLOR aColor
            ENDIF
         ENDIF
      ENDCASE
   ENDIF
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintImageX( nLin, nCol, nLinF, nColF, cImage ) CLASS TMINIPRINT
*-----------------------------------------------------------------------------*
   IF ::cUnits = "MM"
      @ nLin, nCol PRINT IMAGE cImage WIDTH ( nColF - nCol ) HEIGHT ( nLinF - nLin ) STRETCH
   ELSE
      @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT IMAGE cImage WIDTH ( ( nColF - nCol - 1 ) * ::nmHor + ::nhFij ) HEIGHT ( ( nLinF + 0.5 - nLin ) * ::nmVer + ::nvFij ) STRETCH
   ENDIF
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintLineX( nLin, nCol, nLinF, nColF, atColor, ntwPen ) CLASS TMINIPRINT
*-----------------------------------------------------------------------------*
LOCAL nVDispl := 1

   DEFAULT atColor TO ::aColor

   IF ::cUnits = "MM"
      @ nLin, nCol PRINT LINE TO nLinF, nColF COLOR atColor PENWIDTH ntwPen
   ELSE
      @ nLin * ::nmVer * nVDispl + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT LINE TO nLinF * ::nmVer * nVDispl + ::nvFij, nColF * ::nmHor + ::nhFij * 2 COLOR atColor PENWIDTH ntwPen
   ENDIF
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintRectangleX( nLin, nCol, nLinF, nColF, atColor, ntwPen ) CLASS TMINIPRINT
*-----------------------------------------------------------------------------*
LOCAL nVDispl := 1

   DEFAULT atColor TO ::aColor

   IF ::cUnits = "MM"
      @ nLin, nCol PRINT RECTANGLE TO nLinF, nColF COLOR atColor PENWIDTH ntwPen
   ELSE
      @ nLin * ::nmVer * nVDispl + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT RECTANGLE TO nLinF * ::nmVer * nVDispl + ::nvFij, nColF * ::nmHor + ::nhFij * 2 COLOR atColor PENWIDTH ntwPen
   ENDIF
RETURN Self

*-----------------------------------------------------------------------------*
METHOD SelPrinterX( lSelect, lPreview, lLandscape, nPaperSize, cPrinterX, nRes, nBin, nDuplex, lCollate, nCopies, lColor, nScale, nPaperLength, nPaperWidth ) CLASS TMINIPRINT
*-----------------------------------------------------------------------------*
LOCAL nOrientation, lSucess, nCollate, nColor

   IF lLandscape
      nOrientation := PRINTER_ORIENT_LANDSCAPE
   ELSE
      nOrientation := PRINTER_ORIENT_PORTRAIT
   ENDIF

   DEFAULT nPaperSize   TO -999
   DEFAULT nRes         TO -999
   DEFAULT nBin         TO -999
   DEFAULT nDuplex      TO -999
   DEFAULT nCopies      TO -999
   DEFAULT nScale       TO -999
   DEFAULT nPaperLength TO -999
   DEFAULT nPaperWidth  TO -999

   IF HB_IsLogical( lCollate )
      IF lCollate
         nCollate := PRINTER_COLLATE_TRUE
      ELSE
         nCollate := PRINTER_COLLATE_FALSE
      ENDIF
   ELSE
      nCollate := -999
   ENDIF

   IF HB_IsLogical( lColor )
      IF lColor
         nColor := PRINTER_COLOR_COLOR
      ELSE
         nColor := PRINTER_COLOR_MONOCHROME
      ENDIF
   ELSE
      nColor := -999
   ENDIF

   IF cPrinterX = NIL
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

*-----------------------------------------------------------------------------*
METHOD GetDefPrinterX() CLASS TMINIPRINT
*-----------------------------------------------------------------------------*
RETURN GetDefaultPrinter()

*-----------------------------------------------------------------------------*
METHOD PrintRoundRectangleX( nLin, nCol, nLinF, nColF, atColor, ntwPen ) CLASS TMINIPRINT
*-----------------------------------------------------------------------------*
LOCAL nVDispl := 1  // nVDispl := 1.009

   DEFAULT atColor TO ::aColor

   IF ::cUnits = "MM"
      @ nLin, nCol PRINT RECTANGLE TO nLinF, nColF COLOR atColor PENWIDTH ntwPen ROUNDED
   ELSE
      @ nLin * ::nmVer * nVDispl + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PRINT RECTANGLE TO nLinF * ::nmVer * nVDispl + ::nvFij, nColF * ::nmHor + ::nhFij * 2 COLOR atColor PENWIDTH ntwPen ROUNDED
   ENDIF
RETURN Self





CLASS THBPRINTER FROM TPRINTBASE

   VAR oHBPrn INIT Nil

   METHOD InitX
   METHOD BeginDocX
   METHOD EndDocX
   METHOD BeginPageX
   METHOD EndPageX
   METHOD ReleaseX
   METHOD PrintDataX
   METHOD PrintImageX
   METHOD PrintLineX
   METHOD PrintRectangleX
   METHOD SelPrinterX
   METHOD GetDefPrinterX
   METHOD SetColorX
   METHOD SetPreviewSizeX
   METHOD PrintRoundRectangleX
   METHOD PrintBarcodeX

ENDCLASS

*-----------------------------------------------------------------------------*
METHOD InitX() CLASS THBPRINTER
*-----------------------------------------------------------------------------*
   INIT PRINTSYS
   GET PRINTERS TO ::aPrinters
   GET PORTS TO ::aPorts
   SET UNITS MM
   SET CHANGES LOCAL         // sets printer options not permanent
   SET PREVIEW SCALE 2
   ::cPrintLibrary := "HBPRINTER"
RETURN Self

*-----------------------------------------------------------------------------*
METHOD BeginDocX() CLASS THBPRINTER
*-----------------------------------------------------------------------------*
   START DOC NAME ::Cargo
   DEFINE FONT "F0" NAME "Courier New" SIZE 10
   DEFINE FONT "F1" NAME "Courier New" SIZE 10 BOLD
   DEFINE FONT "F2" NAME "Courier New" SIZE 10 ITALIC
   DEFINE FONT "F3" NAME "Courier New" SIZE 10 BOLD ITALIC
RETURN Self

*-----------------------------------------------------------------------------*
METHOD EndDocX() CLASS THBPRINTER
*-----------------------------------------------------------------------------*
   END DOC
RETURN Self

*-----------------------------------------------------------------------------*
METHOD BeginPageX() CLASS THBPRINTER
*-----------------------------------------------------------------------------*
  START PAGE
RETURN Self

*-----------------------------------------------------------------------------*
METHOD EndPageX() CLASS THBPRINTER
*-----------------------------------------------------------------------------*
   END PAGE
RETURN Self

*-----------------------------------------------------------------------------*
METHOD ReleaseX() CLASS THBPRINTER
*-----------------------------------------------------------------------------*
   RELEASE PRINTSYS
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintDataX( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, cText, lItalic, nAngle ) CLASS THBPRINTER
*-----------------------------------------------------------------------------*
   Empty( uData )
   DEFAULT aColor TO ::aFontColor
   Empty( nLen )

   SELECT FONT "F0"
   CHANGE FONT "F0" NAME cFont SIZE nSize ANGLE nAngle

   IF lBold
      SELECT FONT "F1"
      CHANGE FONT "F1" NAME cFont SIZE nSize ANGLE nAngle BOLD
   ENDIF

   IF lItalic
      IF lBold
         SELECT FONT "F3"
         CHANGE FONT "F3" NAME cFont SIZE nSize ANGLE nAngle BOLD ITALIC
      ELSE
         SELECT FONT "F2"
         CHANGE FONT "F2" NAME cFont SIZE nSize ANGLE nAngle ITALIC
      ENDIF
   ENDIF

   SET TEXTCOLOR aColor

   IF ::cUnits = "MM"
      IF ! lBold
         IF cAlign = "R"
            @ nLin, nCol SAY ( cText ) ALIGN TA_RIGHT TO PRINT
         ELSEIF cAlign = "C"
            @ nLin, nCol SAY ( cText ) ALIGN TA_CENTER TO PRINT
         ELSE
            @ nLin, nCol SAY ( cText ) TO PRINT
         ENDIF
      ELSE
         IF cAlign = "R"
            @ nLin, nCol SAY ( cText ) ALIGN TA_RIGHT TO PRINT
         ELSEIF cAlign = "C"
            @ nLin, nCol SAY ( cText ) ALIGN TA_CENTER TO PRINT
         ELSE
            @ nLin, nCol SAY ( cText ) TO PRINT
         ENDIF
      ENDIF
   ELSE
      IF ! lBold
         IF cAlign = "R"
            SET TEXT ALIGN RIGHT
            @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 + ( Len( cText ) ) * ::nmHor SAY ( cText ) TO PRINT
            SET TEXT ALIGN LEFT
         ELSE
            @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 SAY ( cText ) TO PRINT
         ENDIF
      ELSE
         IF cAlign = "R"
            SET TEXT ALIGN RIGHT
            @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 + ( Len( cText ) ) * ::nmHor SAY ( cText ) TO PRINT
            SET TEXT ALIGN LEFT
         ELSE
            @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 SAY ( cText ) TO PRINT
         ENDIF
      ENDIF
   ENDIF
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintBarcodeX( y, x, y1, x1, aColor ) CLASS THBPRINTER
*-----------------------------------------------------------------------------*
   DEFAULT aColor TO ::aColor
   DEFINE BRUSH "obrush" COLOR aColor STYLE BS_SOLID
   SELECT BRUSH "obrush"
   @ y, x, y1, x1 FILLRECT BRUSH "obrush"
   DEFINE BRUSH "obrush1" COLOR {255,255,255} STYLE BS_SOLID
   SELECT BRUSH "obrush1"
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintImageX( nLin, nCol, nLinF, nColF, cImage ) CLASS THBPRINTER
*-----------------------------------------------------------------------------*
   IF ::cUnits = "MM"
      @ nLin, nCol PICTURE cImage SIZE ( nLinF - nLin ), ( nColF - nCol )
   ELSE
      @ nLin * ::nmVer + ::nvFij, nCol * ::nmHor + ::nhFij * 2 PICTURE cImage SIZE ( nLinF - nLin ) * ::nmVer + ::nvFij, ( nColF - nCol - 3 ) * ::nmHor + ::nhFij * 2
   ENDIF
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintLineX( nLin, nCol, nLinF, nColF, atColor, ntwPen ) CLASS THBPRINTER
*-----------------------------------------------------------------------------*
LOCAL nVDispl := 1

   DEFAULT atColor TO ::aColor
   CHANGE PEN "C0" WIDTH ntwPen * 10 COLOR atColor
   SELECT PEN "C0"
   IF ::cUnits = "MM"
      @ nLin, nCol, nLinF, nColF LINE PEN "C0"
   ELSE
      @ nLin * ::nmVer * nVDispl + ::nvFij, nCol * ::nmHor + ::nhFij * 2, nLinF * ::nmVer * nVDispl + ::nvFij, nColF * ::nmHor + ::nhFij * 2 LINE PEN "C0"
   ENDIF
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintRectangleX( nLin, nCol, nLinF, nColF, atColor, ntwPen ) CLASS THBPRINTER
*-----------------------------------------------------------------------------*
LOCAL nVDispl := 1

   DEFAULT atColor TO ::aColor
   CHANGE PEN "C0" WIDTH ntwPen * 10 COLOR atColor
   SELECT PEN "C0"
   IF ::cUnits = "MM"
      @ nLin, nCol, nLinF, nColF RECTANGLE PEN "C0"
   ELSE
      @ nLin * ::nmVer * nVDispl + ::nvFij, nCol * ::nmHor + ::nhFij * 2, nLinF * ::nmVer * nVDispl + ::nvFij, nColF * ::nmHor + ::nhFij * 2 RECTANGLE PEN "C0"
   ENDIF
RETURN Self

*-----------------------------------------------------------------------------*
METHOD SelPrinterX( lSelect, lPreview, lLandscape, nPaperSize, cPrinterX, nRes, nBin, nDuplex, lCollate, nCopies, lColor, nScale, nPaperLength, nPaperWidth ) CLASS THBPRINTER
*-----------------------------------------------------------------------------*
   IF lSelect .AND. lPreview .AND. cPrinterX = NIL
      SELECT BY DIALOG PREVIEW
   ENDIF
   IF lSelect .AND. ( ! lPreview ) .AND. cPrinterX = NIL
      SELECT BY DIALOG
   ENDIF
   IF ( ! lSelect ) .AND. lPreview .AND. cPrinterX = NIL
      SELECT DEFAULT PREVIEW
   ENDIF
   IF ( ! lSelect ) .AND. ( ! lPreview ) .AND. cPrinterX = NIL
      SELECT DEFAULT
   ENDIF

   IF cPrinterX # NIL
      IF lPreview
         SELECT PRINTER cPrinterX PREVIEW
      ELSE
         SELECT PRINTER cPrinterX
      ENDIF
   ENDIF

   IF HBPRNERROR != 0
      ::lPrError := .T.
      RETURN NIL
   ENDIF

   DEFINE FONT "f0" NAME ::cFontName SIZE ::nFontSize
   DEFINE FONT "f1" NAME ::cFontName SIZE ::nFontSize BOLD

   DEFINE PEN "C0" WIDTH ::nwPen COLOR ::aColor
   SELECT PEN "C0"

   IF lLandscape
      SET PAGE ORIENTATION DMORIENT_LANDSCAPE FONT "f0"
   ELSE
      SET PAGE ORIENTATION DMORIENT_PORTRAIT  FONT "f0"
   ENDIF
   IF nPaperSize # NIL
      SET PAGE PAPERSIZE nPaperSize
   ENDIF

   IF nRes # NIL
      SET QUALITY nRes   // Default is PRINTER_RES_MEDIUM
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

   IF HB_IsLogical( lCollate )
      IF lCollate
         SET COLLATE ON
      ELSE
         SET COLLATE OFF
      ENDIF
   ENDIF

   IF nCopies # NIL
      SET COPIES TO nCopies
   ENDIF

   IF HB_IsLogical( lColor )
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

*-----------------------------------------------------------------------------*
METHOD GetDefPrinterX() CLASS THBPRINTER
*-----------------------------------------------------------------------------*
LOCAL cDefPrinter

   GET DEFAULT PRINTER TO cDefPrinter
RETURN cDefPrinter

*-----------------------------------------------------------------------------*
METHOD SetColorX() CLASS THBPRINTER
*-----------------------------------------------------------------------------*
   CHANGE PEN "C0" WIDTH ::nwPen COLOR ::aColor
   SELECT PEN "C0"
RETURN Self

*-----------------------------------------------------------------------------*
METHOD SetPreviewSizeX( nSize ) CLASS THBPRINTER
*-----------------------------------------------------------------------------*
   IF nSize == NIL .OR. nSize < 1 .OR. nSize > 5
      nSize := 2
   ENDIF
   SET PREVIEW SCALE nSize
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintRoundRectangleX( nLin, nCol, nLinF, nColF, atColor, ntwPen ) CLASS THBPRINTER
*-----------------------------------------------------------------------------*
LOCAL nVDispl := 1

   DEFAULT atColor TO ::aColor
   CHANGE PEN "C0" WIDTH ntwPen * 10 COLOR atColor
   SELECT PEN "C0"
   IF ::cUnits = "MM"
      @ nLin, nCol, nLinF, nColF ROUNDRECT ROUNDR 10 ROUNDC 10 PEN "C0"
   ELSE
      @ nLin * ::nmVer * nVDispl + ::nvFij, nCol * ::nmHor + ::nhFij * 2, nLinF * ::nmVer * nVDispl + ::nvFij, nColF * ::nmHor + ::nhFij * 2 ROUNDRECT ROUNDR 10 ROUNDC 10 PEN "C0"
   ENDIF
RETURN Self





CLASS TDOSPRINT FROM TPRINTBASE

   DATA cString INIT ""
   DATA cbusca  INIT ""
   DATA nOccur  INIT 0
   DATA liswin  INIT .F.

   METHOD InitX
   METHOD BeginDocX
   METHOD EndDocX
   METHOD BeginPageX
   METHOD EndPageX
   METHOD PrintDataX
   METHOD PrintLineX
   METHOD SelPrinterX
   METHOD CondenDosX
   METHOD NormalDosX
   METHOD SearchString
   METHOD NextSearch

ENDCLASS

*-----------------------------------------------------------------------------*
METHOD InitX() CLASS TDOSPRINT
*-----------------------------------------------------------------------------*
   ::cPrintLibrary := "DOSPRINT"
RETURN Self

*-----------------------------------------------------------------------------*
METHOD SelPrinterX( lSelect, lPreview, lLandscape, nPaperSize, cPrinterX ) CLASS TDOSPRINT
*-----------------------------------------------------------------------------*
   Empty( lPreview )
   Empty( lLandscape )
   Empty( nPaperSize )

   IF HB_IsString( cPrinterX )
      cPrinterX := Upper( cPrinterX )
      IF ! cPrinterX $ "PRN LPT1: LPT2: LPT3: LPT4: LPT5: LPT6:"
          AutoMsgStop( _OOHG_Messages( 12, 13 ) )
          ::lPrError := .T.
          RETURN NIL
      ENDIF
   ENDIF

   DO WHILE File( ::TempFile )
      ::TempFile := GetTempDir() + "T" + AllTrim( Str( Int( HB_Random( 999999 ) ), 8 ) ) + ".prn"
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

         @ 53,175 BUTTON cancel CAPTION _OOHG_Messages( 12, 16 ) ACTION ( ::lPrError := .T., myselprinter.Release() )
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

*-----------------------------------------------------------------------------*
FUNCTION aLocalPorts()
*-----------------------------------------------------------------------------*
LOCAL aPrnPort, aResults := {}

   aPrnPort := GetPrintersInfo()
   IF aPrnPort <> ",,"
      aPrnPort := str2arr( aPrnPort, ",," )
      AEval( aPrnPort, { | x, xi | aPrnPort[ xi ] := str2arr( x, ',' ) } )
      AEval( aPrnPort, { | x | AAdd( aResults, x[ 2 ] + ", " + x[ 1 ] ) } )
   ENDIF
RETURN aResults

*-----------------------------------------------------------------------------*
METHOD BeginDocX() CLASS TDOSPRINT
*-----------------------------------------------------------------------------*
   SET PRINTER TO ( ::TempFile )
   SET DEVICE TO PRINT
RETURN Self

*-----------------------------------------------------------------------------*
METHOD EndDocX() CLASS TDOSPRINT
*-----------------------------------------------------------------------------*
LOCAL nHandle, wr, nx, ny

   nx := GetDesktopWidth()
   ny := GetDesktopHeight()

   SET DEVICE TO SCREEN
   SET PRINTER TO

   nHandle := FOpen( ::TempFile, 0 + 64 )

   IF ::ImPreview
      wr := MemoRead( ( ::TempFile ) )

      DEFINE WINDOW print_preview  ;
         AT 0, 0 ;
         WIDTH nx HEIGHT ny - 70 - 40 ;
         TITLE _OOHG_Messages( 12, 17 ) + ::TempFile + " " + ::cPrintLibrary ;
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
            BUTTON but_4 CAPTION _OOHG_Messages( 12, 18 ) ACTION ( print_preview.Release() ) TOOLTIP _OOHG_Messages( 12, 19 )
            BUTTON but_1 CAPTION _OOHG_Messages( 12, 20 ) ACTION Zoom( "+" ) TOOLTIP _OOHG_Messages( 12, 21 )
            BUTTON but_2 CAPTION _OOHG_Messages( 12, 22 ) ACTION Zoom( "-" ) TOOLTIP _OOHG_Messages( 12, 23 )
            BUTTON but_3 CAPTION _OOHG_Messages( 12, 24 ) ACTION ::PrintMode() TOOLTIP _OOHG_Messages( 12, 25 ) + ::cPrintLibrary
            BUTTON but_5 CAPTION _OOHG_Messages( 12, 26 ) ACTION ::SearchString( print_preview.edit_p.Value ) TOOLTIP _OOHG_Messages( 12, 27 )
            BUTTON but_6 CAPTION _OOHG_Messages( 12, 28 ) ACTION ::NextSearch() TOOLTIP _OOHG_Messages( 12, 29 )
         END TOOLBAR

//       @ 010, nx - 40 BUTTON but_4 CAPTION "X" WIDTH 30 ACTION ( print_preview.Release() ) TOOLTIP _OOHG_Messages( 12, 19 )
//       @ 090, nx - 40 BUTTON but_1 CAPTION "+ +" WIDTH 30 ACTION Zoom( "+" ) TOOLTIP _OOHG_Messages( 12, 21 )
//       @ 170, nx - 40 BUTTON but_2 CAPTION "- -" WIDTH 30 ACTION Zoom( "-" ) TOOLTIP _OOHG_Messages( 12, 23 )
//       @ 250, nx - 40 BUTTON but_3 CAPTION "P" WIDTH 30 ACTION ::PrintMode() TOOLTIP _OOHG_Messages( 12, 25 ) + ::cPrintLibrary
//       @ 330, nx - 40 BUTTON but_5 CAPTION "S" WIDTH 30 ACTION ( ::SearchString( print_preview.edit_p.Value ) ) TOOLTIP _OOHG_Messages( 12, 27 )
//       @ 410, nx - 40 BUTTON but_6 CAPTION "N" WIDTH 30 ACTION ::NextSearch() TOOLTIP _OOHG_Messages( 12, 29 )
      END WINDOW

      CENTER WINDOW print_preview
      ACTIVATE WINDOW print_preview
   ELSE
      ::PrintMode()
   ENDIF

   IF File( ::TempFile )
      FClose( nHandle )
      Ferase( ::TempFile )
   ENDIF
RETURN Self

*-----------------------------------------------------------------------------*
METHOD BeginPageX() CLASS TDOSPRINT
*-----------------------------------------------------------------------------*
   @ 0, 0 SAY ""
RETURN Self

*-----------------------------------------------------------------------------*
METHOD EndPageX() CLASS TDOSPRINT
*-----------------------------------------------------------------------------*
   EJECT
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintDataX( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, cText, lItalic ) CLASS TDOSPRINT
*-----------------------------------------------------------------------------*
   Empty( uData )
   Empty( cFont )
   Empty( nSize )
   Empty( aColor )
   Empty( cAlign )
   Empty( nLen )
   Empty( lItalic)

   IF ! lBold
      @ nLin, nCol SAY ( cText )
   ELSE
      @ nLin, nCol SAY ( cText )
      @ nLin, nCol SAY ( cText )
   ENDIF
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintLineX( nLin, nCol, nLinF, nColF /*, atColor, ntwPen*/ ) CLASS TDOSPRINT
*-----------------------------------------------------------------------------*
   IF nLin = nLinF
      @ nLin, nCol SAY Replicate( "-", nColF - nCol + 1 )
   ENDIF
RETURN Self

*-----------------------------------------------------------------------------*
METHOD CondenDosX() CLASS TDOSPRINT
*-----------------------------------------------------------------------------*
   @ PRow(), PCol() SAY Chr( 15 )
RETURN Self

*-----------------------------------------------------------------------------*
METHOD NormalDosX() CLASS TDOSPRINT
*-----------------------------------------------------------------------------*
   @ PRow(), PCol() SAY Chr( 18 )
RETURN Self

*-----------------------------------------------------------------------------*
STATIC FUNCTION Zoom( cOp )
*-----------------------------------------------------------------------------*
   IF cOp = "+" .AND. print_preview.edit_p.FontSize <= 24
      print_preview.edit_p.FontSize := print_preview.edit_p.FontSize + 2
   ENDIF

   IF cOp = "-" .AND. print_preview.edit_p.FontSize > 7
      print_preview.edit_p.FontSize := print_preview.edit_p.FontSize - 2
   ENDIF
RETURN NIL

*-----------------------------------------------------------------------------*
METHOD SearchString( cTarget) CLASS TDOSPRINT
*-----------------------------------------------------------------------------*
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
RETURN NIL

*-----------------------------------------------------------------------------*
METHOD NextSearch() CLASS TDOSPRINT
*-----------------------------------------------------------------------------*
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
RETURN NIL

*-----------------------------------------------------------------------------*
STATIC FUNCTION AtPlus( cSearch, cAll, nStart )
*-----------------------------------------------------------------------------*
LOCAL i, nPos, nLencSearch, nLencAll, cUppercSearch

   nPos := 0
   nLencAll := Len( cAll )
   nLencSearch := Len( cSearch )
   cUppercSearch := Upper( cSearch )

   FOR i := nStart TO nLencAll
      IF Upper( SubStr( cAll, i, nLencSearch ) ) = cUppercSearch
         nPos := i
         EXIT
      ENDIF
   NEXT i
RETURN nPos





CLASS TRAWPRINT FROM TDOSPRINT

   METHOD InitX
   METHOD SelPrinterX

ENDCLASS

*-----------------------------------------------------------------------------*
METHOD InitX() CLASS TRAWPRINT
*-----------------------------------------------------------------------------*
   ::cPrintLibrary := "RAWPRINT"
RETURN Self

*-----------------------------------------------------------------------------*
METHOD SelPrinterX( lSelect, lPreview, lLandscape, nPaperSize, cPrinterX ) CLASS TRAWPRINT
*-----------------------------------------------------------------------------*
   Empty( lPreview )
   Empty( lLandscape )
   Empty( nPaperSize )

   DO WHILE File( ::TempFile )
      ::TempFile := GetTempDir() + "T" + AllTrim( Str( Int( HB_Random( 999999 ) ), 8 ) ) + ".prn"
   ENDDO

   IF lSelect
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
      IF ! Empty( cPrinterX )
         ::cPrinter := cPrinterX
      ELSE
         ::cPrinter := GetDefaultPrinter()
      ENDIF
   ENDIF
RETURN Self





// Based upon a contribution of Jose Miguel josemisu@yahoo.com.ar
CLASS TEXCELPRINT FROM TPRINTBASE

    DATA oExcel  INIT NIL
    DATA oHoja   INIT NIL
    DATA cTlinea INIT ""

   METHOD InitX
   METHOD BeginDocX
   METHOD EndDocX
   METHOD EndPageX
   METHOD ReleaseX
   METHOD PrintDataX
   METHOD PrintImageX
   METHOD SelPrinterX

ENDCLASS

*-----------------------------------------------------------------------------*
METHOD InitX() CLASS TEXCELPRINT
*-----------------------------------------------------------------------------*
   ::cPrintLibrary := "EXCELPRINT"
RETURN Self

*-----------------------------------------------------------------------------*
METHOD SelPrinterX( lSelect, lPreview, lLandscape, nPaperSize, cPrinterX ) CLASS TEXCELPRINT
*-----------------------------------------------------------------------------*
   Empty( lSelect )
   Empty( lPreview )
   Empty( lLandscape )
   Empty( nPaperSize )
   Empty( cPrinterX )

   #ifndef __XHARBOUR__
   IF ( ::oExcel := win_oleCreateObject( "Excel.Application" ) ) = NIL
   #else
   ::oExcel := TOleAuto():New( "Excel.Application" )
   IF Ole2TxtError() != 'S_OK'
   #endif
      MsgStop( _OOHG_Messages( 12, 34 ), _OOHG_Messages( 12, 12 ) )
      ::lPrError := .T.
      ::Exit := .T.
      RETURN NIL
   ENDIF
RETURN Self

*-----------------------------------------------------------------------------*
METHOD BeginDocX() CLASS TEXCELPRINT
*-----------------------------------------------------------------------------*
   ::oExcel:WorkBooks:Add()
   ::oExcel:Visible:=.F.
   ::oHoja := ::oExcel:ActiveSheet()
   ::oHoja:Name := ::Cargo
   ::oHoja:Cells:Font:Name := ::cFontName
   ::oHoja:Cells:Font:Size := ::nFontSize
RETURN Self

*-----------------------------------------------------------------------------*
METHOD EndDocX() CLASS TEXCELPRINT
*-----------------------------------------------------------------------------*
LOCAL nCol, cName, cExt        //, nNum

   FOR nCol :=1 TO ::oHoja:UsedRange:Columns:Count()
       ::oHoja:Columns( nCol ):AutoFit()
   NEXT

// aVersion := { ;
//               { "12.0", "2007" }, ;
//               { "11.0", "2003" }, ;
//               { "10.0", "2002/XP" }, ;
//               { "9.0", "2000" }, ;
//               { "8.0", "97" }, ;
//               { "7.0", "95" }, ;
//               { "6.0", "6"} }

   ::oExcel:DisplayAlerts :=.F.
   ::oHoja:Cells( 1, 1 ):Select()
   ::oExcel:Visible := .F.

   IF Val( ::oExcel:Version ) > 11.5
//    nNum := 46                       // I'm not sure
      cExt := "xlsx"
   ELSE
//    nNum := 39
      cExt := "xls"
   ENDIF

   cName := ParseName( ::Cargo, cExt )

   ::oHoja:SaveAs( cName )
// ::oHoja:SaveAs( cName, nNum, "", "", .F., .F. )

   InKey( 1 )
   ::oExcel:Quit()
   ::oHoja := NIL
   ::oExcel := NIL

   IF ::ImPreview
      IF ShellExecute( 0, "open", "rundll32.exe", "url.dll,FileProtocolHandler " + cName, , 1) <= 32
         MsgInfo( _OOHG_Messages( 12, 35 ) + Chr( 13 ) + Chr( 13 ) + ;
                  _OOHG_Messages( 12, 36 ) + Chr( 13 ) + cName )
      ENDIF
   ENDIF
RETURN Self

*-----------------------------------------------------------------------------*
METHOD ReleaseX() CLASS TEXCELPRINT
*-----------------------------------------------------------------------------*
   ::oHoja := NIL
   ::oExcel := NIL
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintImageX( nLin, nCol, nLinF, nColF, cImage) CLASS TEXCELPRINT
*-----------------------------------------------------------------------------*
LOCAL cFolder := GetCurrentFolder() + "\"
LOCAL cLin
LOCAL cRange

   Empty( nLinF )

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

   nColF := nLin
   cLin := AllTrim( Str( nLin ) )
   cRange := "A" + cLin
   ::oHoja:Range( cRange ):Select()
   cImage := cFolder + cImage
   ::oHoja:Pictures:Insert( cImage )
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintDataX( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, cText, lItalic ) CLASS TEXCELPRINT
*-----------------------------------------------------------------------------*
LOCAL aLinCellX

   Empty( uData )
   Empty( aColor )
   Empty( nLen )

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
   CASE cAlign = "R"
      ::oHoja:Cells( nLin, aLinCellX ):HorizontalAlignment := -4152  // Right
   CASE cAlign = "C"
      ::oHoja:Cells( nLin, aLinCellX ):HorizontalAlignment := -4108  // Center
   ENDCASE
RETURN Self

*-----------------------------------------------------------------------------*
METHOD EndPageX() CLASS TEXCELPRINT
*-----------------------------------------------------------------------------*
   ::nLinPag := Len( ::aLinCelda ) + 1
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





// Ciro 2011/8/19
CLASS TSPREADSHEETPRINT FROM TPRINTBASE

   DATA aDoc    INIT {}
   DATA nXls    INIT 0
   DATA nLinRel INIT 0
   DATA nLpp    INIT 60        // lines per page

   METHOD InitX
   METHOD BeginDocX
   METHOD EndDocX
   METHOD EndPageX
   METHOD ReleaseX
   METHOD PrintDataX
   METHOD AddPage

ENDCLASS

*-----------------------------------------------------------------------------*
METHOD InitX() CLASS TSPREADSHEETPRINT
*-----------------------------------------------------------------------------*
   ::cPrintLibrary := "SPREADSHEETPRINT"
RETURN Self

*-----------------------------------------------------------------------------*
METHOD AddPage()
*-----------------------------------------------------------------------------*
LOCAL i

   FOR i := 1 TO ::nLpp
      AAdd( ::aDoc, Space( 300 ) )
   NEXT i
RETURN NIL

*-----------------------------------------------------------------------------*
METHOD BeginDocX() CLASS TSPREADSHEETPRINT
*-----------------------------------------------------------------------------*
LOCAL cName
LOCAL cBof := Chr( 9 ) + Chr( 0 ) + Chr( 4 ) + Chr( 0 ) + Chr( 2 ) + Chr( 0 ) + Chr( 10 ) + Chr( 0 )

   cName := ParseName( ::Cargo, "XLS" )
   ::nXls := FCreate( cName )
   FWrite( ::nXls, cBof, Len( cBof ) )
   ::AddPage()
RETURN Self

*-----------------------------------------------------------------------------*
METHOD EndDocX() CLASS TSPREADSHEETPRINT
*-----------------------------------------------------------------------------*
LOCAL cName
LOCAL i
LOCAL anHeader
LOCAL nLen
LOCAL nI
LOCAL cEof

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

   cName := ParseName( ::Cargo, "XLS" )

   IF ::ImPreview
      IF ShellExecute( 0, "open", "rundll32.exe", "url.dll,FileProtocolHandler " + cName, , 1) <= 32
         MsgInfo( _OOHG_Messages( 12, 35 ) + Chr( 13 ) + Chr( 13 ) + ;
                  _OOHG_Messages( 12, 36 ) + Chr( 13 ) + cName )
      ENDIF
   ENDIF
RETURN Self

*-----------------------------------------------------------------------------*
METHOD ReleaseX() CLASS TSPREADSHEETPRINT
*-----------------------------------------------------------------------------*
   Release( ::nXls )           // I'm not sure about this
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintDataX( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, cText, lItalic ) CLASS TSPREADSHEETPRINT
*-----------------------------------------------------------------------------*
LOCAL cLineI, cLineF

   Empty( cFont )
   Empty( nSize )
   Empty( lBold )
   Empty( aColor )
   Empty( cAlign )
   Empty( nLen )
   Empty( cText )
   Empty( lItalic )

   nLin++
   uData := AutoType( uData )
   cLineI := ::aDoc[ nLin + ::nLinRel ]
   cLineF := Stuff( cLineI, nCol, Len( uData ), uData )
   ::aDoc[ nLin + ::nLinRel ]:= cLineF
RETURN Self

*-----------------------------------------------------------------------------*
METHOD EndPageX() CLASS TSPREADSHEETPRINT
*-----------------------------------------------------------------------------*
   ::nLinRel := ::nLinRel + ::nLpp
   ::AddPage()
RETURN Self





CLASS THTMLPRINT FROM TEXCELPRINT

   METHOD EndDocX

ENDCLASS

*-----------------------------------------------------------------------------*
METHOD EndDocX() CLASS THTMLPRINT
*-----------------------------------------------------------------------------*
LOCAL nCol, cName

   FOR nCol := 1 TO ::oHoja:UsedRange:Columns:Count()
      ::oHoja:Columns( nCol ):AutoFit()
   NEXT
   ::oHoja:Cells( 1, 1 ):Select()

   cName := ParseName( ::Cargo, "html" )
   ::oExcel:DisplayAlerts := .F.

   ::oHoja:SaveAs( cName, 44, "", "", .F., .F. )

   ::oExcel:Quit()
   ::ohoja := NIL
   ::oExcel := NIL

   IF ::ImPreview
      IF ShellExecute( 0, "open", "rundll32.exe", "url.dll,FileProtocolHandler " + cName, , 1) <= 32
         MsgInfo( _OOHG_Messages( 12, 37 ) + Chr( 13 ) + Chr( 13 ) + ;
                  _OOHG_Messages( 12, 36 ) + Chr( 13 ) + cName )
      ENDIF
   ENDIF
RETURN Self





CLASS TRTFPRINT FROM TPRINTBASE

   DATA aPrintRtf  INIT {}
   DATA nPrintRtf  INIT 10
   DATA lPrintRtf  INIT .F.
   DATA lIndentAll INIT .F.

   METHOD InitX
   METHOD BeginDocX
   METHOD EndDocX
   METHOD EndPageX
   METHOD PrintDataX
   METHOD PrintLineX
   METHOD SelPrinterX

ENDCLASS

*-----------------------------------------------------------------------------*
METHOD InitX() CLASS TRTFPRINT
*-----------------------------------------------------------------------------*
   ::cPrintLibrary := "RTFPRINT"
RETURN Self

*-----------------------------------------------------------------------------*
METHOD BeginDocX() CLASS TRTFPRINT
*-----------------------------------------------------------------------------*
LOCAL cMarginSup := LTrim( Str( Round( 15 * 56.7, 0 ) ) )
LOCAL cMarginInf := LTrim( Str( Round( 15 * 56.7, 0 ) ) )
LOCAL cMarginLef := LTrim( Str( Round( 10 * 56.7, 0 ) ) )
LOCAL cMarginRig := LTrim( Str( Round( 10 * 56.7, 0 ) ) )

// If you insert a new font in the document's font table please add it also to array aFontTable in Method PrinDataX
   AAdd( ::aPrintRtf, "{\rtf1\ansi\ansicpg1252\uc1 \deff0\deflang3082\deflangfe3082{\fonttbl{\f0\froman\fcharset0\fprq2{\*\panose 02020603050405020304}Times New Roman;}{\f2\fmodern\fcharset0\fprq1{\*\panose 02070309020205020404}Courier New;}" )
   AAdd( ::aPrintRtf, "{\f106\froman\fcharset238\fprq2 Times New Roman CE;}{\f107\froman\fcharset204\fprq2 Times New Roman Cyr;}{\f109\froman\fcharset161\fprq2 Times New Roman Greek;}{\f110\froman\fcharset162\fprq2 Times New Roman Tur;}" )
   AAdd( ::aPrintRtf, "{\f111\froman\fcharset177\fprq2 Times New Roman (Hebrew);}{\f112\froman\fcharset178\fprq2 Times New Roman (Arabic);}{\f113\froman\fcharset186\fprq2 Times New Roman Baltic;}{\f122\fmodern\fcharset238\fprq1 Courier New CE;}" )
   AAdd( ::aPrintRtf, "{\f123\fmodern\fcharset204\fprq1 Courier New Cyr;}{\f125\fmodern\fcharset161\fprq1 Courier New Greek;}{\f126\fmodern\fcharset162\fprq1 Courier New Tur;}{\f127\fmodern\fcharset177\fprq1 Courier New (Hebrew);}" )
   AAdd( ::aPrintRtf, "{\f128\fmodern\fcharset178\fprq1 Courier New (Arabic);}{\f129\fmodern\fcharset186\fprq1 Courier New Baltic;}}{\colortbl;\red0\green0\blue0;\red0\green0\blue255;\red0\green255\blue255;\red0\green255\blue0;\red255\green0\blue255;\red255\green0\blue0;" )
   AAdd( ::aPrintRtf, "\red255\green255\blue0;\red255\green255\blue255;\red0\green0\blue128;\red0\green128\blue128;\red0\green128\blue0;\red128\green0\blue128;\red128\green0\blue0;\red128\green128\blue0;\red128\green128\blue128;\red192\green192\blue192;}{\stylesheet{" )
   AAdd( ::aPrintRtf, "\ql \li0\ri0\widctlpar\faauto\adjustright\rin0\lin0\itap0 \fs20\lang3082\langfe3082\cgrid\langnp3082\langfenp3082 \snext0 Normal;}{\*\cs10 \additive Default Paragraph Font;}}{\info{\author nobody }{\operator Jose Miguel}" )
   AAdd( ::aPrintRtf, "{\creatim\yr2000\mo12\dy29\hr17\min26}{\revtim\yr2002\mo3\dy6\hr9\min32}{\printim\yr2002\mo3\dy4\hr16\min32}{\version10}{\edmins16}{\nofpages1}{\nofwords167}{\nofchars954}{\*\company xyz}{\nofcharsws0}{\vern8249}}" )
// AAdd( ::aPrintRtf, "\paperw11907\paperh16840\margl284\margr284\margt1134\margb1134 \widowctrl\ftnbj\aenddoc\hyphhotz425\noxlattoyen\expshrtn\noultrlspc\dntblnsbdb\nospaceforul\hyphcaps0\horzdoc\dghspace120\dgvspace120\dghorigin1701\dgvorigin1984\dghshow0\dgvshow3" )
   AAdd( ::aPrintRtf, IIF( ::lPrintRtf, "\paperw16840\paperh11907", "\paperw11907\paperh16840" ) + ;
                                        "\margl" + cMarginLef + "\margr" + cMarginRig + "\margt" + cMarginSup + "\margb" + cMarginInf + ;
                                        " \widowctrl\ftnbj\aenddoc\hyphhotz425\noxlattoyen\expshrtn\noultrlspc\dntblnsbdb\nospaceforul\hyphcaps0\horzdoc\dghspace120\dgvspace120\dghorigin1701\dgvorigin1984\dghshow0\dgvshow3" )
   AAdd( ::aPrintRtf, "\jcompress\viewkind1\viewscale80\nolnhtadjtbl \fet0\sectd \psz9\linex0\headery851\footery851\colsx709\sectdefaultcl {\*\pnseclvl1\pnucrm\pnstart1\pnindent720\pnhang{\pntxta .}}{\*\pnseclvl2\pnucltr\pnstart1\pnindent720\pnhang{\pntxta .}}{\*\pnseclvl3" )
   AAdd( ::aPrintRtf, "\pndec\pnstart1\pnindent720\pnhang{\pntxta .}}{\*\pnseclvl4\pnlcltr\pnstart1\pnindent720\pnhang{\pntxta )}}{\*\pnseclvl5\pndec\pnstart1\pnindent720\pnhang{\pntxtb (}{\pntxta )}}{\*\pnseclvl6\pnlcltr\pnstart1\pnindent720\pnhang{\pntxtb (}{\pntxta )}}" )
   AAdd( ::aPrintRtf, "{\*\pnseclvl7\pnlcrm\pnstart1\pnindent720\pnhang{\pntxtb (}{\pntxta )}}{\*\pnseclvl8\pnlcltr\pnstart1\pnindent720\pnhang{\pntxtb (}{\pntxta )}}{\*\pnseclvl9\pnlcrm\pnstart1\pnindent720\pnhang{\pntxtb (}{\pntxta )}}\pard\plain " )
   AAdd( ::aPrintRtf, "\qj \li0\ri0\nowidctlpar\faauto\adjustright\rin0\lin0\itap0 \fs20\lang3082\langfe3082\cgrid\langnp3082\langfenp3082" )
   IF ::cUnits = "MM"
      AAdd( ::aPrintRtf, "{\f0\lang1034\langfe3082\cgrid0\langnp1034" )
   ELSE
      AAdd( ::aPrintRtf, "{\f2\lang1034\langfe3082\cgrid0\langnp1034" )
   ENDIF
RETURN Self

*-----------------------------------------------------------------------------*
METHOD EndDocX() CLASS TRTFPRINT
*-----------------------------------------------------------------------------*
LOCAL i, cFilePath

   IF RIGHT( ::aPrintRtf[ Len( ::aPrintRtf ) ], 6) = " \page"
      ::aPrintRtf[ Len( ::aPrintRtf ) ] := Left( ::aPrintRtf[ Len( ::aPrintRtf ) ], Len( ::aPrintRtf[ Len( ::aPrintRtf ) ] ) - 6 )
   ENDIF
   AAdd( ::aPrintRtf, "\par }}" )
   cFilePath := ParseName( ::Cargo, "rtf" )
   SET PRINTER TO ( cFilePath )
   SET DEVICE TO PRINTER
   SETPRC( 0, 0 )
   FOR i := 1 TO Len( ::aPrintRtf )
      @ PRow(), PCol() SAY ::aPrintRtf[ i ]
      @ PRow() + 1, 0 SAY ""
   NEXT
   SET DEVICE TO SCREEN
   SET PRINTER TO
   IF ::ImPreview
      IF ShellExecute( 0, "open", "rundll32.exe", "url.dll,FileProtocolHandler " + cFilePath, , 1 ) <= 32
         MsgInfo( _OOHG_Messages( 12, 38 ) + Chr( 13 ) + Chr( 13 ) + ;
                  _OOHG_Messages( 12, 36 ) + Chr( 13 ) + cFilePath )
      ENDIF
   ENDIF
RETURN Self

*-----------------------------------------------------------------------------*
METHOD EndPageX() CLASS TRTFPRINT
*-----------------------------------------------------------------------------*
LOCAL nLin, i1, i2

   ASort( ::aLinCelda, , , { | x, y | Str( x[ 1 ] ) + Str( x[ 2 ] ) < Str( y[ 1 ] ) + Str( y[ 2 ] ) } )
   nLin := 0
   FOR i1 := 1 TO Len( ::aLinCelda )
      IF nLin < ::aLinCelda[ i1, 1 ]
         DO WHILE nLin < ::aLinCelda[ i1, 1 ]
            AAdd( ::aPrintRtf, "\par " )
            nLin++
         ENDDO
         IF ::cUnits = "MM"
            ::aPrintRtf[ Len( ::aPrintRtf ) ] := ::aPrintRtf[ Len( ::aPrintRtf ) ] + "}\pard \qj \li0\ri0\nowidctlpar"
            FOR i2 := 1 TO Len( ::aLinCelda )
               IF ::aLinCelda[ i2, 1 ] = ::aLinCelda[ i1, 1 ]
                  DO CASE
                  CASE ::aLinCelda[ i2, 5 ] = "R"
                     ::aPrintRtf[ Len( ::aPrintRtf ) ] := ::aPrintRtf[ Len( ::aPrintRtf ) ] + "\tqr" + "\tx" + LTrim( Str( Round( ( ::aLinCelda[ i2, 2 ] - 10 ) * 56.7, 0 ) ) )
                  CASE ::aLinCelda[ i2, 5 ] = "C"
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
         DO CASE
         CASE ::nPrintRtf <= 8
            IF ::cUnits = "MM"
               ::aPrintRtf[ Len( ::aPrintRtf ) ] := ::aPrintRtf[ Len( ::aPrintRtf ) ] + "}{\f0\fs16\lang1034\langfe3082\cgrid0\langnp1034"
            ELSE
               ::aPrintRtf[ Len( ::aPrintRtf ) ] := ::aPrintRtf[ Len( ::aPrintRtf ) ] + "}{\f2\fs16\lang1034\langfe3082\cgrid0\langnp1034"
            ENDIF
         CASE ::nPrintRtf >= 9 .AND. ::nPrintRtf <= 10
            IF ::cUnits = "MM"
               ::aPrintRtf[ Len( ::aPrintRtf ) ] := ::aPrintRtf[ Len( ::aPrintRtf ) ] + "}{\f0\lang1034\langfe3082\cgrid0\langnp1034"
            ELSE
               ::aPrintRtf[ Len( ::aPrintRtf ) ] := ::aPrintRtf[ Len( ::aPrintRtf ) ] + "}{\f2\lang1034\langfe3082\cgrid0\langnp1034"
            ENDIF
         CASE ::nPrintRtf >= 11 .AND. ::nPrintRtf <= 12
            IF ::cUnits = "MM"
            ::aPrintRtf[ Len( ::aPrintRtf ) ] := ::aPrintRtf[ Len( ::aPrintRtf ) ] + "}{\f0\fs24\lang1034\langfe3082\cgrid\langnp1034"
            ELSE
            ::aPrintRtf[ Len( ::aPrintRtf ) ] := ::aPrintRtf[ Len( ::aPrintRtf ) ] + "}{\f2\fs24\lang1034\langfe3082\cgrid\langnp1034"
            ENDIF
         CASE ::nPrintRtf >= 13
            IF ::cUnits = "MM"
            ::aPrintRtf[ Len( ::aPrintRtf ) ] := ::aPrintRtf[ Len( ::aPrintRtf ) ] + "}{\f0\fs28\lang1034\langfe3082\cgrid\langnp1034"
            ELSE
            ::aPrintRtf[ Len( ::aPrintRtf ) ] := ::aPrintRtf[ Len( ::aPrintRtf ) ] + "}{\f2\fs28\lang1034\langfe3082\cgrid\langnp1034"
            ENDIF
         ENDCASE
      ENDIF

      IF ::cUnits = "MM"
         ::aPrintRtf[ Len( ::aPrintRtf ) ] := ::aPrintRtf[ Len( ::aPrintRtf ) ] + "\tab " + if( ::aLinCelda[ i1, 6 ], "\b ", "" ) + ::aLinCelda[ i1, 3 ] + if( ::aLinCelda[ i1, 6 ], "\b0", "" )
      ELSE
         IF ::aLinCelda[ i1, 6 ]        // Bold
            ::aPrintRtf[ Len( ::aPrintRtf ) ] := ::aPrintRtf[ Len( ::aPrintRtf ) ] + "\b " + space(::aLinCelda[ i1, 2 ]) + ::aLinCelda[ i1, 3 ] + "\b0"
         ELSE
            ::aPrintRtf[ Len( ::aPrintRtf ) ] := ::aPrintRtf[ Len( ::aPrintRtf ) ] + if( Right( ::aPrintRtf[ Len( ::aPrintRtf ) ], 1 ) == " ", "", " " ) + space(::aLinCelda[ i1, 2 ]) + ::aLinCelda[ i1, 3 ]
         ENDIF
      ENDIF
   NEXT

   ::aPrintRtf[ Len( ::aPrintRtf ) ] := ::aPrintRtf[ Len( ::aPrintRtf ) ] + "\page"
   ::aLinCelda := {}
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintDataX( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, cText, lItalic ) CLASS TRTFPRINT
*-----------------------------------------------------------------------------*
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

   Empty( uData )
   Empty( cFont )
   Empty( aColor )
   Empty( nLen )
   Empty( lItalic )

   nLin++
   IF ::nUnitsLin > 1
      nLin := Round( nLin / ::nUnitsLin, 0 )
   ENDIF
   IF ::cUnits = "MM"
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
               cText := SubStr( cText, 1, nFontTableStart - 1 ) + substr( cText, i + 1 )
               EXIT
            ENDIF

            IF SubStr( cText, i, 3 ) == "{\f"
               // process font number
               cFontNumber := ""
               i += 3
               DO WHILE i <= Len( cText ) .AND. ( cNext := SubStr( cText, i, 1 ) ) $ "0123456789"
                  cFontNumber += cNext
                  i ++
               ENDDO
               IF Len( cFontNumber ) < 1 .OR. i > Len( cText ) .OR. ! cNext $ " \{"
                  // RTF text is non compliant with the standard
                  EXIT
               ENDIF

               nParLevel := 0
               DO WHILE .T.
                  IF cNext == " "
                     i ++
                     IF i > Len( cText )
                        EXIT
                     ENDIF
                     cNext := SubStr( cText, i, 1 )
                  ENDIF

                  IF cNext == "\"
                     i ++
                     DO WHILE i <= Len( cText ) .AND. ! ( cNext := SubStr( cText, i, 1 ) ) $ " \{}"
                        i ++
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
                     nParLevel ++
                     DO WHILE nParLevel > 0
                        i ++
                        DO WHILE i <= Len( cText ) .AND. ! ( cNext := SubStr( cText, i, 1 ) ) $ "{}"
                           i ++
                        ENDDO
                        IF i > Len( cText )
                           EXIT
                        ELSEIF cNext == "{"
                           nParLevel ++
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
                     i ++
                     IF i > Len( cText )
                        EXIT
                     ENDIF
                     cNext := SubStr( cText, i, 1 )
                  ENDDO
                  IF i > Len( cText )
                     EXIT
                  ENDIF
                  i ++
                  IF i > Len( cText )
                     EXIT
                  ENDIF
                  IF ! ( cNext := SubStr( cText, i, 1 ) ) == "}"
                     EXIT
                  ENDIF

                  AADD( aFonts, { cFontNumber, Upper( cFontName ) } )

                  i ++
                  EXIT
               ENDDO
            ELSE
               EXIT
            ENDIF
         ENDDO

         FOR i := 1 TO Len( aFonts )
            IF ( j := ASCAN( aFontTable, { |f| f[2] == aFonts[i, 2] } ) ) > 0
               // Substitute font references
               cText := StrTran( cText, '\f' + aFonts[i, 1] + ' ', '\f' + aFontTable[j, 1] + ' ' )
               cText := StrTran( cText, '\f' + aFonts[i, 1] + '\', '\f' + aFontTable[j, 1] + '\' )
               cText := StrTran( cText, '\f' + aFonts[i, 1] + '{', '\f' + aFontTable[j, 1] + '{' )
            ELSE
               // Add new font
               ::aPrintRtf[1] += "{\f" + ltrim(str(nNextFont)) + " " + aFonts[i, 2] + ";}"
            ENDIF
         NEXT

         IF ::lIndentAll .AND. ::cUnits == "ROWCOL"
            cText := StrTran( cText, "\par ", "\par " + space( nCol ) )
            cText := StrTran( cText, "\par" + chr(13) + chr(10), "\par " + space( nCol ) )
         ENDIF
      ENDIF
   ENDIF

   AAdd( ::aLinCelda, { nLin, nCol, Space( ::nLMargin ) + cText, nSize, cAlign, lBold } )
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintLineX( nLin, nCol, nLinF, nColF, atColor, ntwPen ) CLASS TRTFPRINT
*-----------------------------------------------------------------------------*
   Empty( nLin )
   Empty( nCol )
   Empty( nLinF )
   Empty( nColF )
   Empty( atColor )
   Empty( ntwPen )
RETURN Self

*-----------------------------------------------------------------------------*
METHOD SelPrinterX( lSelect, lPreview, lLandscape, nPaperSize, cPrinterX ) CLASS TRTFPRINT
*-----------------------------------------------------------------------------*
   Empty( lSelect )
   Empty( lPreview )
   Empty( nPaperSize )
   Empty( cPrinterX )

   ::aPrintRtf := {}
   ::nPrintRtf := 10
   ::lPrintRtf := lLandscape
RETURN Self





CLASS TCSVPRINT FROM TPRINTBASE

   DATA aPrintCsv INIT {}

   METHOD InitX
   METHOD EndDocX
   METHOD EndPageX
   METHOD PrintDataX
   METHOD PrintLineX
   METHOD SelPrinterX

ENDCLASS

*-----------------------------------------------------------------------------*
METHOD InitX() CLASS TCSVPRINT
*-----------------------------------------------------------------------------*
   ::ImPreview := .F.
   ::cPrintLibrary := "CSVPRINT"
RETURN Self

*-----------------------------------------------------------------------------*
METHOD EndDocX() CLASS TCSVPRINT
*-----------------------------------------------------------------------------*
LOCAL cFilePath := ParseName( ::Cargo, "csv" )
LOCAL i

   SET PRINTER TO ( cFilePath )
   SET DEVICE TO PRINTER
   SETPRC( 0, 0 )
   FOR i := 1 TO Len( ::aPrintCsv )
      @ PRow(), PCol() SAY ::aPrintCsv[ i ]
      @ PRow() + 1, 0 SAY ""
   NEXT
   SET DEVICE TO SCREEN
   SET PRINTER TO

   IF ::ImPreview
      IF ShellExecute( 0, "open", "rundll32.exe", "url.dll,FileProtocolHandler " + cFilePath, , 1 ) <= 32
         MsgInfo( _OOHG_Messages( 12, 39 ) + Chr( 13 ) + Chr( 13 ) + ;
                  _OOHG_Messages( 12, 36 ) + Chr( 13 ) + cFilePath )
      ENDIF
   ENDIF
RETURN Self

*-----------------------------------------------------------------------------*
METHOD EndPageX() CLASS TCSVPRINT
*-----------------------------------------------------------------------------*
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

      IF Len( ::aPrintCsv[ Len( ::aPrintCsv ) ] ) = 0
         ::aPrintCsv[ Len( ::aPrintCsv ) ] := ::aLinCelda[ i, 3 ]
      ELSE
         ::aPrintCsv[ Len( ::aPrintCsv ) ] := ::aPrintCsv[ Len( ::aPrintCsv ) ] + ";" + StrTran( ::aLinCelda[ i, 3 ], ";", "," )
      ENDIF
   NEXT
   ::aLinCelda := {}
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintDataX( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, cText, lItalic ) CLASS TCSVPRINT
*-----------------------------------------------------------------------------*
   Empty( uData )
   Empty( cFont )
   Empty( lBold )
   Empty( aColor )
   Empty( nLen )
   Empty( lItalic )

   nLin ++
   IF ::nUnitsLin > 1
      nLin := Round( nLin / ::nUnitsLin, 0 )
   ENDIF
   IF ::cUnits = "MM"
      cText := AllTrim( cText )
   ENDIF
   AAdd( ::aLinCelda, { nLin, nCol, Space( ::nLMargin ) + cText, nSize, cAlign } )
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintLineX( nLin, nCol, nLinF, nColF, atColor, ntwPen ) CLASS TCSVPRINT
*-----------------------------------------------------------------------------*
   Empty( nLin )
   Empty( nCol )
   Empty( nLinF )
   Empty( nColF )
   Empty( atColor )
   Empty( ntwPen )
RETURN Self

*-----------------------------------------------------------------------------*
METHOD SelPrinterX( lSelect, lPreview, lLandscape, nPaperSize, cPrinterX ) CLASS TCSVPRINT
*-----------------------------------------------------------------------------*
   Empty( lSelect )
   Empty( lPreview )
   Empty( lLandscape )
   Empty( nPaperSize )
   Empty( cPrinterX )

   ::aPrintCsv := {}
RETURN Self





CLASS TPDFPRINT FROM TPRINTBASE

   DATA oPDF        AS OBJECT                     // the pdf object
   DATA cDocument   AS CHARACTER INIT ""          // document's name
   DATA cPageSize   AS CHARACTER INIT ""          // page size
   DATA cPageOrient AS CHARACTER INIT ""          // P = portrait, L = Landscape
   DATA nFontType   AS NUMERIC   INIT 1           // font type (normal=0 or bold=1)
   DATA lPreview    AS LOGICAL   INIT .F.         // .T. will open the document after creation
   DATA aPaper      AS ARRAY     INIT {} HIDDEN   // paper types supported by pdf class

   METHOD InitX
   METHOD BeginDocX
   METHOD EndDocX
   METHOD BeginPageX
   METHOD PrintDataX
   METHOD PrintBarcodeX
   METHOD PrintImageX
   METHOD PrintLineX
   METHOD PrintRectangleX
   METHOD SelPrinterX
   METHOD PrintRoundRectangleX

ENDCLASS

*-----------------------------------------------------------------------------*
METHOD InitX() CLASS TPDFPRINT
*-----------------------------------------------------------------------------*

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

*-----------------------------------------------------------------------------*
STATIC FUNCTION ParseName( cName, cExt, lInvSlash )
*-----------------------------------------------------------------------------*
LOCAL x, cLongName, lExt, y

   DEFAULT lInvSlash TO .F.
   cExt := Lower( cExt )

   // remove extension if there's one
   y := At( ".", cName )
   IF y > 0
      cName := SubStr( cName, 1, y - 1 )
   ENDIF

   // if name is not full qualified asume MyDocuments folder
   x := RAt( "\", cName )
   IF x = 0
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

*-----------------------------------------------------------------------------*
METHOD BeginDocX () CLASS TPDFPRINT
*-----------------------------------------------------------------------------*
   ::cDocument := ParseName( ::Cargo, "pdf" )
   ::oPdf := TPDF():Init( ::cDocument )
RETURN Self

*-----------------------------------------------------------------------------*
METHOD EndDocX() CLASS TPDFPRINT
*-----------------------------------------------------------------------------*
   ::oPdf:Close()
   IF ::ImPreview
      IF ShellExecute( 0, "open", "rundll32.exe", "url.dll,FileProtocolHandler " + ::cDocument, , 1) <= 32
         MsgInfo( _OOHG_Messages( 12, 40 ) + Chr( 13 ) + Chr( 13 ) + ;
                  _OOHG_Messages( 12, 36 ) + Chr( 13 ) + ::cDocument )
      ENDIF
   ENDIF
RETURN Self

*-----------------------------------------------------------------------------*
METHOD BeginPageX() CLASS TPDFPRINT
*-----------------------------------------------------------------------------*
   ::oPdf:NewPage( ::cPageSize, ::cPageOrient, , ::cFontName, ::nFontType, ::nFontSize )
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintDataX( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, cText, lItalic ) CLASS TPDFPRINT
*-----------------------------------------------------------------------------*
LOCAL nType
LOCAL cColor := Chr( 253 )
LOCAL i

   DEFAULT cFont  TO ::cFontName
   DEFAULT nSize  TO ::nFontSize
   DEFAULT aColor TO ::aFontColor

   IF ! HB_IsLogical( lBold )
      lBold := .F.
   ENDIF

   IF ! HB_IsLogical( lItalic )
      lItalic := .F.
   ENDIF

   Empty( uData )
   Empty( cAlign )
   Empty( nLen )

   FOR Each i in aColor
      cColor += Chr( i )
   NEXT

   IF lBold
      nType := 1      // bold
   ELSE
      nType := 0      // normal
   ENDIF

   IF lItalic
      IF lBold
         nType := 3   // bold and italic
      ELSE
         nType:= 2    // only italic
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

*-----------------------------------------------------------------------------*
METHOD PrintBarcodeX( nLin, nCol, nLinF, nColF, atColor ) CLASS TPDFPRINT
*-----------------------------------------------------------------------------*
LOCAL cColor := ""
LOCAL i

   DEFAULT atColor TO ::aColor

   FOR Each i in atColor
      cColor += Chr( i )
   NEXT

   ::oPdf:Box( nLin, nCol, nLinF, nColF, 0, 1, "M", cColor, "t1" )
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintImageX( nLin, nCol, nLinF, nColF, cImage ) CLASS TPDFPRINT
*-----------------------------------------------------------------------------*
LOCAL nVDispl := 0.980
LOCAL nHDispl := 1.300

   IF HB_IsString( cImage )
      cImage := Upper( cImage )
      // The only supported image formats are jpg and tiff.
      IF ASCAN( { ".jpg", ".jpeg", ".tif", ".tiff" }, LOWER( SUBSTR( cImage, RAT( ".", cImage ) ) ) ) == 0
         RETURN Self
      ENDIF
   ELSE
     RETURN Self
   ENDIF

   nLinF := nLinF - nLin
   nColF := nColF - nCol

   IF ::cUnits == "MM"
      ::oPdf:Image( cImage, nLin, nCol, "M", nLinF, nColF )
   ELSE
      ::oPdf:Image( cImage, nLin * ::nmVer * nVDispl + ::nvFij, nCol * ::nmHor + ::nhFij * nHDispl, "M", nLinF * ::nmVer * nVDispl + ::nvFij, nColF * ::nmHor + ::nhFij * nHDispl )
   ENDIF
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintLineX( nLin, nCol, nLinF, nColF, atColor, ntwPen ) CLASS TPDFPRINT
*-----------------------------------------------------------------------------*
   DEFAULT atColor TO ::aColor
   IF nLin = nLinF .OR. nCol = nColF
      ::PrintRectangleX( nLin, nCol, nLinF, nColF, atColor, ntwPen /2 )
   ENDIF
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintRectangleX( nLin, nCol, nLinF, nColF, atColor, ntwPen ) CLASS TPDFPRINT
*-----------------------------------------------------------------------------*
LOCAL cColor  := ""
LOCAL i

   DEFAULT atColor TO ::aColor
   DEFAULT ntwPen TO ::nwPen

   FOR EACH i IN atColor
      cColor += Chr( i )
   NEXT

   IF ::cUnits == "MM"
      ::oPdf:Box( ( nLin - 0.9 ) + ::nvFij, ( nCol + 1.3 ) + ::nhFij, ( nLinF - 0.9 ) + ::nvFij, ( nColF + 1.3 ) + ::nhFij, ntwPen * 1.2, 0, "M", "B", "t1" )
   ELSE
      ::oPdf:Box( ( nLin - 0.9 ) * ::nmVer + ::nvFij, ( nCol + 1.3 ) * ::nmHor + ::nhFij, ( nLinF - 0.9 ) * ::nmVer + ::nvFij, ( nColF + 1.3 ) * ::nmHor+ ::nhFij, ntwPen * 1.2, 0, "M", "B", "t1" )
   ENDIF
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintRoundRectangleX( nLin, nCol, nLinF, nColF, atColor, ntwPen ) CLASS TPDFPRINT
*-----------------------------------------------------------------------------*
   // We can't have a rounded rectangle so we make a normal one
   ::PrintRectangleX( nLin, nCol, nLinF, nColF, atColor, ntwPen )
RETURN Self

*-----------------------------------------------------------------------------*
METHOD SelPrinterX( lSelect, lPreview, lLandscape, nPaperSize ) CLASS TPDFPRINT
*-----------------------------------------------------------------------------*
LOCAL nPos

   Empty( lPreview )
   DEFAULT lLandscape TO .F.
   DEFAULT nPaperSize TO 0
   Empty( lSelect )

   ::lPreview := ::ImPreview
   ::cPageOrient := IIF( lLandscape, "L", "P" )
   nPos := AScan( ::aPaper, { | x | x[ 1 ] = nPaperSize } )

   If nPos > 0
      ::cPageSize := ::aPaper[ nPos ][ 2 ]
   ELSE
      ::cPageSize := "LETTER"
   ENDIF
RETURN Self





// CALC contributed by Jose Miguel, adapted by CVC
CLASS TCALCPRINT FROM TPRINTBASE

    DATA oServiceManager INIT NIL
    DATA oDesktop        INIT NIL
    DATA oDocument       INIT NIL
    DATA oSchedule       INIT NIL
    DATA oSheet          INIT NIL
    DATA oCell           INIT NIL
    DATA oColums         INIT NIL
    DATA oColumn         INIT NIL

   METHOD InitX
   METHOD BeginDocX
   METHOD EndDocX
   METHOD EndPageX
   METHOD PrintDataX
   METHOD SelPrinterX

ENDCLASS

*-----------------------------------------------------------------------------*
METHOD InitX() CLASS TCALCPRINT
*-----------------------------------------------------------------------------*
   ::cPrintLibrary := "CALCPRINT"
RETURN Self

*-----------------------------------------------------------------------------*
METHOD SelPrinterX( lSelect, lPreview, lLandscape, nPaperSize, cPrinterX ) CLASS TCALCPRINT
*-----------------------------------------------------------------------------*
LOCAL bErrorBlock
LOCAL oError

   Empty( lSelect )
   Empty( lPreview )
   Empty( lLandscape )
   Empty( nPaperSize )
   Empty( cPrinterX )

   bErrorBlock := ErrorBlock( { | x | break( x ) } )

   #ifdef __XHARBOUR__
   TRY
      ::oServiceManager := TOleAuto():New( "com.sun.star.ServiceManager" )
      ::oDesktop := ::oServiceManager:createInstance( "com.sun.star.frame.Desktop" )
   CATCH oError
      oError:Description := _OOHG_Messages( 12, 44 )
      MsgStop( oError:Description, _OOHG_Messages( 12, 12 ) )
      ::lPrError := .T.
      RETURN NIL
   END
   #else
   BEGIN SEQUENCE
      ::oServiceManager := TOleAuto():New( "com.sun.star.ServiceManager" )
      ::oDesktop := ::oServiceManager:createInstance( "com.sun.star.frame.Desktop" )
   RECOVER USING oError
      oError:Description := _OOHG_Messages( 12, 44 )
      MsgStop( oError:Description, _OOHG_Messages( 12, 12 ) )
      ::lPrError := .T.
      RETURN NIL
   END
   #endif

   ErrorBlock( bErrorBlock )
RETURN Self

*-----------------------------------------------------------------------------*
METHOD BeginDocX() CLASS TCALCPRINT
*-----------------------------------------------------------------------------*
LOCAL laPropertyValue := Array( 10 )

   laPropertyValue[ 1 ] := ::oServiceManager:Bridge_GetStruct( "com.sun.star.beans.PropertyValue" )
   laPropertyValue[ 1 ]:Name := "Hidden"
   laPropertyValue[ 1 ]:Value := .T.

   ::oDocument := ::oDesktop:loadComponentFromURL( "private:factory/scalc", "_blank", 0, @laPropertyValue )
   ::oSchedule := ::oDocument:GetSheets()
   ::oSheet := ::oSchedule:GetByIndex( 0 )
// ::oSheet:CharFontName := ::cFontName
// ::oSheet:CharHeight := ::nFontSize
RETURN Self

*-----------------------------------------------------------------------------*
METHOD EndDocX() CLASS TCALCPRINT
*-----------------------------------------------------------------------------*
LOCAL cName

   ::oSheet:getColumns():setPropertyValue( "OptimalWidth", .T. )
   cName := ParseName( ::Cargo, "odt", .T. )

   ::oDocument:storeToURL( "file:///" + cName, {} )
   InKey( 0.5 )

   ::oDocument:Close( 1 )
   ::oServiceManager := NIL
   ::oDesktop := NIL
   ::oDocument := NIL
   ::oSchedule := NIL
   ::oSheet := NIL
   ::oCell := NIL
   ::oColums := NIL
   ::oColumn := NIL

   IF ::ImPreview
      cName := ParseName( ::Cargo, "odt" )
      IF ShellExecute( 0, "open", "rundll32.exe", "url.dll,FileProtocolHandler " + cName, , 1) <= 32
         MsgInfo( _OOHG_Messages( 12, 41 ) + Chr( 13 ) + Chr( 13 ) + ;
                  _OOHG_Messages( 12, 36 ) + Chr( 13 ) + cName )
      ENDIF
   ENDIF
RETURN Self

*-----------------------------------------------------------------------------*
METHOD EndPageX() CLASS TCALCPRINT
*-----------------------------------------------------------------------------*
LOCAL nLin, i, nCol, aColor

   ASort( ::aLinCelda, , , { | x, y | Str( x[ 1 ] ) + Str( x[ 2 ] ) < Str( y[ 1 ] ) + Str( y[ 2 ] ) } )
   IF ::nLinPag = 0 .AND. Len( ::aLinCelda ) > 0
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
      ::oCell := ::oSheet:getCellByPosition( nCol - 1, ::nLinPag + nLin ) // columna,linea
      IF ValType( ::aLinCelda[ i, 3 ] ) = "N"
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
      IF ::aLinCelda[ i, 7] = .T.
         ::oCell:CharWeight := 150
      ENDIF
      DO CASE
      CASE ::aLinCelda[ i, 5 ] = "R"
         ::oCell:HoriJustify := 3
      CASE ::aLinCelda[ i, 5 ] = "C"
         ::oCell:HoriJustify := 2
      ENDCASE
      aColor := ::aLinCelda[ i, 8 ]
      IF aColor[ 3 ] <> 0 .OR. aColor[ 2 ] <> 0 .OR. aColor[ 1 ] <> 0
         ::oCell:CharColor := RGB( aColor[ 3 ], aColor[ 2 ], aColor[ 1 ] )
      ENDIF
      nCol++
   NEXT
   ::nLinPag := ::nLinPag + nLin + 1
   ::aLinCelda := {}
RETURN Self

*-----------------------------------------------------------------------------*
METHOD PrintDataX( nLin, nCol, uData, cFont, nSize, lBold, aColor, cAlign, nLen, cText, nAngle ) CLASS TCALCPRINT
*-----------------------------------------------------------------------------*
   Empty( nAngle )
   Empty( nCol )
   Empty( uData )
   Empty( aColor )
   Empty( nLen )

   IF ::nUnitsLin > 1
      nLin := Round( nLin / ::nUnitsLin, 0 )
   ENDIF
   IF ::cUnits = "MM"
      cText := AllTrim( cText )
   ENDIF
   AAdd( ::aLinCelda, { nLin, nCol, cText, nSize, cAlign, cFont, lBold, aColor } )
RETURN Self





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

// Important: this function do not sets the start and end codes
*-----------------------------------------------------------------------------*
FUNCTION _Codabar( cCode )
*-----------------------------------------------------------------------------*
LOCAL n, cBarcode := '', nCar

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

*-----------------------------------------------------------------------------*
FUNCTION _Code128( cCode, cMode )
*-----------------------------------------------------------------------------*
LOCAL nSum := 0, cBarcode, cCar
LOCAL cTemp, n, nCar, nCount := 0
LOCAL lCodeC := .F., lCodeA := .F.

   IF ValType( cCode ) != 'C'
      MsgInfo( _OOHG_Messages( 12, 42 ) )
      RETURN NIL
   ENDIF
   IF ! Empty( cMode )
      IF ValType( cMode ) = 'C' .AND. Upper( cMode ) $ 'ABC'
         cMode := Upper( cMode )
      ELSE
         MsgInfo( _OOHG_Messages( 12, 43 ) )
      ENDIF
   ENDIF
   IF Empty( cMode ) // variable mode
      // analize code type
      IF Str( Val( cCode ), Len( cCode ) ) = cCode // numbers only
         lCodeC := .T.
         cTemp := CODE128_CODES[ 106 ]
         nSum := 105
      ELSE
         FOR n := 1 TO Len( cCode )
            nCount += IIF( SubStr( cCode, n, 1 ) > 31, 1, 0) // number of control chars
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
      nCount ++
      cCar := SubStr( cCode, n, 1 )
      IF lCodeC
         IF Len( cCode ) = n           // last character
            CTemp += CODE128_CODES[ 101 ]      // SHIFT Code B
            nCar := Asc( cCar ) - 31
         ELSE
            nCar := Val( SubStr( cCode, n, 2 ) ) + 1
            n ++
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

*-----------------------------------------------------------------------------*
FUNCTION _Code3_9( cCode, lCheck )
*-----------------------------------------------------------------------------*
LOCAL cCar, m, n, cBarcode := '', nCheck := 0

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

*-----------------------------------------------------------------------------*
FUNCTION _Ean13( cCode )
*-----------------------------------------------------------------------------*
LOCAL cBarcode, nChar
LOCAL cLeft, cRight, cString, cMask, k, n

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
      IF SubStr( cMask, n, 1 ) = "o"
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

*-----------------------------------------------------------------------------*
FUNCTION Ean13_Check( cCode )
*-----------------------------------------------------------------------------*
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

*-----------------------------------------------------------------------------*
FUNCTION _Ean13bl( nLen )
*-----------------------------------------------------------------------------*
   nLen := Int( nLen / 2 )
RETURN '101' + Replicate( '0', nLen * 7 ) + '01010' + Replicate( '0', nLen * 7) + '101'

*-----------------------------------------------------------------------------*
FUNCTION _Upc( cCode, nLen )
*-----------------------------------------------------------------------------*
LOCAL n, cBarcode, nChar
LOCAL cLeft, cRight, k

   DEFAULT cCode TO '0'
   DEFAULT nLen TO 11
   nLen := IIF( nLen = 11, 11, 7 )               // valid values for nLen are 11 and 7

   k := Left( AllTrim( cCode ) + '000000000000', nLen )
   k := k + Upc_Check( cCode, nLen )                                 // check digit

   nLen++
   cBarcode := ""
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

*-----------------------------------------------------------------------------*
FUNCTION _Upcabl()
*-----------------------------------------------------------------------------*
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

*-----------------------------------------------------------------------------*
FUNCTION Upc_Check( cCode, nLen )
*-----------------------------------------------------------------------------*
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

// EAN 5 digit supplement
*-----------------------------------------------------------------------------*
FUNCTION _Sup5( cCode )
*-----------------------------------------------------------------------------*
LOCAL k, cControl, n, cBarcode := '1011', nCar

   k := Left( AllTrim( cCode ) + '00000', 5 )
   cControl := Right( Str( Val( SubStr( k, 1, 1 ) ) * 3 + ;
                           Val( SubStr( k, 3, 1 ) ) * 3 + ;
                           Val( SubStr( k, 5, 1 ) ) * 3 + ;
                           Val( SubStr( k, 2, 1 ) ) * 9 + ;
                           Val( SubStr( k, 4, 1 ) ) * 9, 5, 0 ), 1 )
   cControl := SubStr( EAN_FIRST, Val( cControl ) * 6 + 2, 5 )

   FOR n := 1 TO 5
      nCar := Val( SubStr( k, n, 1 ) )
      IF SubStr( cControl, n, 1 ) = 'o'
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
*-----------------------------------------------------------------------------*
FUNCTION _Int25( cCode, lMode )
*-----------------------------------------------------------------------------*
LOCAL n, cBarCode :='', cLeft, cRight, nLen, nCheck := 0, cPre, m

   DEFAULT lMode TO .T.

   cCode := Transform( cCode, '@9' )     // get rid of characters
   nLen := Len( cCode )
   IF ( nLen % 2 = 1 .AND. ! lMode )
      nLen++
      cCode += '0'
   ENDIF

   IF lMode
		IF nLen % 2 = 0
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
      IF SubStr( cPre, n, 1 ) = '1'
         cBarCode += '111'
      ELSE
         cBarCode += '1'
      ENDIF
      IF SubStr( cPre, n + 1, 1 ) = '1'
         cBarCode += '000'
      ELSE
         cBarCode += '0'
      ENDIF
   NEXT
RETURN cBarCode

// Matrix 25
*-----------------------------------------------------------------------------*
FUNCTION _Mat25( cCode, lCheck )
*-----------------------------------------------------------------------------*
LOCAL cPre, cBarcode := '', nCheck, n

   DEFAULT lCheck TO .F.

   cCode := Transform( cCode, '@9' ) // get rid of characters
   IF lCheck
      FOR n := 1 TO Len( cCode ) STEP 2
           nCheck += Val( SubStr( cCode, n, 1 ) ) * 3 + Val( SubStr( cCode, n + 1, 1 ) )
      next
      cCode += Right( Str( nCheck, 10, 0 ), 1 )
   ENDIF

   cPre := '10000'                                             // matrix start
   FOR n := 1 TO Len( cCode )
      cPre += CODE25_CODES[ Val( SubStr( cCode, n, 1 ) ) + 1 ] + '0'
   NEXT
   cPre += '10000'                                             // matrix stop

   FOR n := 1 TO Len( cPre ) STEP 2
      IF SubStr( cPre, n, 1 ) = '1'
         cBarcode += '111'
      ELSE
         cBarcode += '1'
      ENDIF
      IF SubStr( cPre, n + 1, 1) = '1'
         cBarcode+='000'
      else
         cBarcode+='0'
      end
   next
return cBarcode

// Industrial 25
*-----------------------------------------------------------------------------*
FUNCTION _Ind25(cCode,lCheck)
*-----------------------------------------------------------------------------*
LOCAL cPre, cBarCode := '', nCheck, n

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
     IF substr( cPre, n, 1 ) = '1'
         cBarCode += '1110'
     ELSE
         cBarCode += '10'
     ENDIF
   NEXT
RETURN cBarCode



#PRAGMA BEGINDUMP

#define _WIN32_IE 0x0500
#define HB_OS_WIN_32_USED
#define _WIN32_WINNT 0x0400
#define WINVER 0x0400

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

static OSVERSIONINFO osvi;

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

#PRAGMA ENDDUMP
