/*
 * $Id: printtest.prg,v 1.12 2016-12-30 16:36:23 fyurisich Exp $
 */

#include 'oohg.ch'

PROCEDURE Test()
   PUBLIC _OOHG_PRINTLIBRARY

   SET CENTURY ON
   SET DATE ANSI

	DEFINE WINDOW pr_form ;
		AT 0, 0 ;
      WIDTH 300 ;
      HEIGHT 300 ;
		TITLE 'Print Test' ;
      MODAL

      ON KEY ESCAPE OF pr_form ACTION pr_form.Release

      @ 50, 50 IMAGE image_1 PICTURE "hbprint_print" WIDTH 80 HEIGHT 80

      DEFINE MAIN MENU
         POPUP 'File 1'
   			ITEM 'hbprinter'   ACTION PrintTest( "HBPRINTER" )
   			ITEM 'miniprint'   ACTION PrintTest( "MINIPRINT" )
            ITEM 'dos'         ACTION PrintTest( "DOSPRINT" )
            ITEM 'raw'         ACTION PrintTest( "RAWPRINT" )
            ITEM 'excel'       ACTION PrintTest( "EXCELPRINT" )
            ITEM 'OpenCalc'    ACTION PrintTest( "CALCPRINT" )
            ITEM 'RTF'         ACTION PrintTest( "RTFPRINT" )
            ITEM 'CSV'         ACTION PrintTest( "CSVPRINT" )
            ITEM 'HTML'        ACTION PrintTest( "HTMLPRINT" )
            ITEM 'PDF'         ACTION PrintTest( "PDFPRINT" )
            ITEM "SpreadSheet" ACTION PrintTest( "SPREADSHEETPRINT" )
         END POPUP

         POPUP "File 2"
           	ITEM 'hbprinter A' ACTION Eje_Imprimir( "HBPRINTER" )
   			ITEM 'miniprint A' ACTION Eje_Imprimir( "MINIPRINT" )
            ITEM 'dos A'       ACTION Eje_Imprimir( "DOSPRINT" )
            ITEM 'raw A'       ACTION Eje_Imprimir( "RAWPRINT" )
            ITEM 'excel A'     ACTION Eje_Imprimir( "EXCELPRINT" )
            ITEM 'OpenCalc A'  ACTION Eje_Imprimir( "CALCPRINT" )
            ITEM 'RTF A'       ACTION Eje_Imprimir( "RTFPRINT" )
            ITEM 'CSV A'       ACTION Eje_Imprimir( "CSVPRINT" )
            ITEM 'HTML A'      ACTION Eje_Imprimir( "HTMLPRINT" )
            ITEM 'PDF A'       ACTION Eje_Imprimir( "PDFPRINT" )
            ITEM "SpreadSheet" ACTION Eje_Imprimir( "SPREADSHEETPRINT" )
         END POPUP

         POPUP "File 3"
   			ITEM 'report form hbprinter'  ACTION repof( "HBPRINTER" )
            ITEM 'report form MINIPRINT'  ACTION repof( "MINIPRINT" )
            ITEM 'report form DOS'        ACTION repof( "DOSPRINT" )
            ITEM 'report form RAW'        ACTION repof( "RAWPRINT" )
            ITEM 'report form excelprint' ACTION repof( "EXCELPRINT" )
            ITEM 'report form Opencalc'   ACTION repof( "CALCPRINT" )
            ITEM 'report form RTF'        ACTION repof( "RTFPRINT" )
            ITEM 'report form CSV'        ACTION repof( "CSVPRINT" )
            ITEM 'report form HTML'       ACTION repof( "HTMLPRINT" )
            ITEM 'report form PDF'        ACTION repof( "PDFPRINT" )
            ITEM "SpreadSheet"            ACTION repof( "SPREADSHEETPRINT" )
         END POPUP

         POPUP "FIle 4"
            ITEM 'edit demo hbprinter'   ACTION editp( "HBPRINTER" )
            ITEM 'edit demo miniprint'   ACTION editp( "MINIPRINT" )
            ITEM 'edit demo DOS'         ACTION editp( "DOSPRINT" )
            ITEM 'edit demo EXCEL'       ACTION editp( "EXCELPRINT" )
            ITEM 'edit demo RTF'         ACTION editp( "RTFPRINT" )
            ITEM 'edit demo CSV'         ACTION editp( "CSVPRINT" )
            ITEM 'editex demo hbprinter' ACTION editpx( "HBPRINTER" )
            ITEM 'editex demo miniprint' ACTION editpx( "MINIPRINT" )
            ITEM 'editex demo DOS'       ACTION editpx( "DOSPRINT" )
            ITEM 'editex demo EXCEL'     ACTION editpx( "EXCELPRINT" )
            ITEM 'editex demo RTF'       ACTION editpx( "RTFPRINT" )
            ITEM 'editex demo CSV'       ACTION editpx( "CSVPRINT" )
         END POPUP
      END MENU

	END WINDOW

   CENTER WINDOW pr_form
   ACTIVATE WINDOW pr_form

RETURN Nil


FUNCTION PrintTest( ctlibrary )
   LOCAL oPrint

   SET DATE ANSI
   SET CENTURY ON

   oPrint := TPrint( ctlibrary )
   oPrint:Init()
   oPrint:SelPrinter( .T., .T. )  /// select, preview, landscape, papersize
   IF oPrint:lPrError
      oPrint:Release()
      RETURN Nil
   ENDIF
   oPrint:BeginDoc( "hola" )
   oPrint:SetPreviewSize( 1 )  /// tamaño del preview  1 menor, 2 mas grande, 3 mas...
   oPrint:BeginPage()
   oPrint:PrintData( 0, 1, "impresion linea 0" )
   oPrint:SetLMargin( 4 )
   oPrint:SetTMargin( 2 )
   oPrint:PrintData( 1, 1, "margen izquierdo a 4 caracteres, de arriba 2 lineas" )
   oPrint:PrintData( 8, 10, "esta es una prueba con times new roman size 18", "times new roman", 18, .F. )
   oPrint:PrintData( 11, 10, "esta es una prueba con acentos  áéíóúñÑ ", , , , {0, 0, 255} )
   oPrint:PrintData( 12, 10, "esta es una prueba con negrita", , , .T. )
   oPrint:PrintData( 13, 10, .T. )
   oPrint:PrintData( 13, 20, .F. )

   oPrint:PrintData( 14, 10, "esto es left italic", , , .F., , "L", 30, .T. )
   oPrint:SetColor( {0, 128, 255} )
   oPrint:PrintData( 15, 10, "esta es center", , , .F., , "C", 30 )

   // letra monoespaciada (por defecto, tprint usa courier new)
   oPrint:PrintData( 16, 10, 1500.00, , 10, .F., , "R", 30 )
   oPrint:PrintData( 17, 10, 25000.00, , 10, .F., , "R", 30 )

   /// letra proporcional, número a la derecha y string a la izquierda
   oPrint:PrintData( 18, 10, Transform( 1500, "999,999.99" ), "arial", 10, .F., , "R", )
   oPrint:PrintData( 18, 50, "At line 18", "arial", 10, .F., , "L", )
   oPrint:PrintData( 19, 10, Transform( 25000, "999,999.99" ), "arial", 10, .F., , "R", )
   oPrint:PrintData( 19, 50, "And this at line 19", "arial", 10, .F., , "L", )

   oPrint:PrintImage( 21, 10, 30, 30, "cvcjpg.jpg", 100 )

   oPrint:PrintLine( 21, 40, 21, 60, , 1, .F. )
   oPrint:PrintData( 29, 40, "TPRINT Version: " + oPrint:Version() )
   oPrint:PrintRectangle( 35, 10, 50, 30, BLUE, 1, .T., RED )
   oPrint:PrintRectangle( 3, 3, 6, 6 )
   oPrint:PrintRoundRectangle( 35, 40, 50, 55, , .5, .F. )
   oPrint:PrintLine( 51, 50, 58, 50, , 1 )
   oPrint:PrintBarCode( 53, 20, "123456789012", "EAN13" )

   oPrint:EndPage()
   oPrint:EndDoc()
   oPrint:Release()

RETURN Nil


FUNCTION repof( cLibrary )

   _OOHG_PRINTLIBRARY := cLibrary
   CLOSE DATA
   USE test
   DO REPORT FORM report1 HEADING "PRINT DEMO"

RETURN Nil


FUNCTION editp( cLibrary )

   _OOHG_PRINTLIBRARY := cLibrary
   CLOSE DATA
   USE test
   EDIT WORKAREA test

RETURN Nil


FUNCTION editpx( cLibrary )

   _OOHG_PRINTLIBRARY := cLibrary
   CLOSE DATA
   USE test
   INDEX ON code TO lista
   EDIT EXTENDED WORKAREA test

RETURN NIL


FUNCTION Eje_Imprimir( cLibrary )

   _OOHG_PRINTLIBRARY := cLibrary
   oPrint := TPrint( cLibrary )

   oPrint:Init()
   oPrint:SelPrinter( .T., .T. )
   IF oPrint:lPrError
      oPrint:Release()
      RETURN Nil
   ENDIF
   oPrint:BeginDoc()
   oPrint:BeginPage()
   x := 0
   oPrint:PrintData( x, 0, cLibrary + " PADRON DE CLIENTES al " + DToC( Date() ), , 9, .T., , , , .F. )
   x := x + 1

   DO WHILE x < 60
      oPrint:PrintRectangle( x, 00, x+1, 03 )
      oPrint:PrintRectangle( x, 03, x+1, 19 )
      oPrint:PrintRectangle( x, 19, x+1, 33 )
      oPrint:PrintRectangle( x, 33, x+1, 37 )
      oPrint:PrintRectangle( x, 37, x+1, 46 )
      oPrint:PrintRectangle( x, 46, x+1, 53 )
      oPrint:PrintRectangle( x, 53, x+1, 62 )
      oPrint:PrintRectangle( x, 62, x+1, 78 )
      oPrint:PrintData( x, 0, " Cuen              Nombre                      Dirección            Nro       Localidad          Cuit          Teléfono              Observaciones", , 6, .T., , , , .F. )
      x = x + 1
   ENDDO

   oPrint:EndPage()
   oPrint:EndDoc()
   oPrint:Release()

RETURN .T.
