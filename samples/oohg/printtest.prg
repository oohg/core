/*
 * $Id: printtest.prg,v 1.9 2012-06-24 16:35:16 fyurisich Exp $
 */

#include 'oohg.ch'

procedure test()
PUBLIC _OOHG_PRINTLIBRARY

set century on
set date ansi

	define window pr_form ;
		at 0,0 ;
                width 300;
                height 300 ;
		title 'print Test' ;
                MODAL

          @ 50,50 Image image_1 picture "hbprint_print" width 80 height 80

	DEFINE MAIN MENU
                POPUP 'File 1'
			ITEM 'hbprinter' ACTION printtest("HBPRINTER")
			ITEM 'miniprint' ACTION printtest("MINIPRINT")
                        ITEM 'dos' ACTION printtest("DOSPRINT")

                        ITEM 'raw' ACTION printtest("RAWPRINT")
                        ITEM 'excel' ACTION printtest("EXCELPRINT")
                        ITEM 'OpenCalc' ACTION PRINTTEST("CALCPRINT")

                        ITEM 'RTF' ACTION printtest("RTFPRINT")
                        ITEM 'CSV' ACTION printtest("CSVPRINT")
                        ITEM 'HTML' ACTION printtest("HTMLPRINT")
                        ITEM 'PDF'  ACTION printtest("PDFPRINT")
                        ITEM "SpreadSheet" ACTION PRINTTEST("SPREADSHEETPRINT")
                END POPUP

                POPUP "File 2"
                       	ITEM 'hbprinter A' ACTION eje_imprimir("HBPRINTER")
			ITEM 'miniprint A' ACTION eje_imprimir("MINIPRINT")
                        ITEM 'dos A' ACTION eje_imprimir("DOSPRINT")

                        ITEM 'raw A' ACTION eje_imprimir("RAWPRINT")
                        ITEM 'excel A' ACTION eje_imprimir("EXCELPRINT")
                        ITEM 'OpenCalc A' ACTION eje_imprimir("CALCPRINT")

                        ITEM 'RTF A' ACTION eje_imprimir("RTFPRINT")
                        ITEM 'CSV A' ACTION eje_imprimir("CSVPRINT")
                        ITEM 'HTML A' ACTION eje_imprimir("HTMLPRINT")
                        ITEM 'PDF A'  ACTION eje_imprimir("PDFPRINT")
                        ITEM "SpreadSheet" ACTION eje_imprimir("SPREADSHEETPRINT")

                 END POPUP
                 POPUP "File 3"
			ITEM 'report form hbprinter' ACTION repof("HBPRINTER")
                        ITEM 'report form MINIPRINT' ACTION repof("MINIPRINT")

                        ITEM 'report form DOS' ACTION repof("DOSPRINT")
                        ITEM 'report form RAW' ACTION repof("RAWPRINT")

                        ITEM 'report form excelprint' ACTION repof("EXCELPRINT")
                        ITEM 'report form Opencalc' ACTION repof("CALCPRINT")

                        ITEM 'report form RTF' ACTION repof("RTFPRINT")
                        ITEM 'report form CSV' ACTION repof("CSVPRINT")
                        ITEM 'report form HTML' ACTION repof("HTMLPRINT")
                        ITEM 'report form PDF' ACTION repof("PDFPRINT")
                        ITEM "SpreadSheet" ACTION repof("SPREADSHEETPRINT")

                  END POPUP
                  POPUP "FIle 4"

                        ITEM 'edit demo hbprinter' ACTION editp("HBPRINTER")
                        ITEM 'edit demo miniprint' ACTION editp("MINIPRINT")
                        ITEM 'edit demo DOS' ACTION editp("DOSPRINT")
                        ITEM 'edit demo EXCEL' ACTION editp("EXCELPRINT")
                        ITEM 'edit demo RTF' ACTION editp("RTFPRINT")
                        ITEM 'edit demo CSV' ACTION editp("CSVPRINT")


                        ITEM 'editex demo hbprinter' ACTION editpx("HBPRINTER")
                        ITEM 'editex demo miniprint' ACTION editpx("MINIPRINT")
                        ITEM 'editex demo DOS' ACTION editpx("DOSPRINT")

                        ITEM 'editex demo EXCEL' ACTION editpx("EXCELPRINT")

                        ITEM 'editex demo RTF' ACTION editpx("RTFPRINT")
                        ITEM 'editex demo CSV' ACTION editpx("CSVPRINT")

                 END POPUP
	END MENU

	end window
        center window pr_form
	activate window pr_form

Return Nil

function printtest(ctlibrary)
local oprint
set date ansi
set century on
oprint:=tprint(ctlibrary)
oprint:init()
oprint:selprinter(.T. , .T.  )  /// select,preview,landscape,papersize
if oprint:lprerror
   oprint:release()
      return nil
      endif
      oprint:begindoc("hola")
      oprint:setpreviewsize(1)  /// tamaño del preview  1 menor,2 mas grande ,3 mas...
      oprint:beginpage()
      oprint:printdata(0,1,"impresion linea 0")
      oprint:setlmargin(4)
      oprint:settmargin(2)
      oprint:printdata(1,1,"margen izquierdo a 4 caracteres, de arriba 2 lineas")
      oprint:printdata(8,10,"esta es una prueba con times new roman size 18","times new roman",18,.F.) ///
      oprint:printdata(11,10,"esta es una prueba con acentos  áéíóúñÑ ",,,,{0,0,255}) ///
      oprint:printdata(12,10,"esta es una prueba con negrita",,,.T.) ///
      oprint:printdata(13,10,.T.)
      oprint:printdata(13,20,.F.)

      oprint:printdata(14,10,"esto es left italic", , , .F. , ,"L" ,30, .T.)
      oprint:setcolor({0,128,255})
      oprint:printdata(15,10,"esta es center", , , .F. , ,"C" ,30)
      oprint:printdata(16,10,1500.00, ,10 , .F. , ,"R" ,30) ///a la derecha courier new
      oprint:printdata(17,10,25000.00 ,,10 , .F. , ,"R" ,30)

      oprint:printdata(18,10, TRANSFORM(1500.00, "999,999.99"),"arial",10 , .F. , ,"R" ,)
      /// a la derecha con letra arial
      oprint:printdata(19,10, TRANSFORM(25000.00,"999,999.99"),"arial",10 , .F. , ,"R" ,)
      oprint:printdata(29,40,"TPRINT Version: "+oprint:version())
      oprint:printimage(21,10,30,30,"cvcjpg.jpg")
      oprint:printline(21,10,21,30,,1)
      oprint:printrectangle(35,10,50,30,{0,0,255},1)
////      oprint:printrectangle(35,10,50,30)
      oprint:printroundrectangle(35,40,50,55)
      oprint:printbarcode(53,20,"123456789012","EAN13")
      oprint:printline(51,50,58,50,,1)
      oprint:endpage()
      oprint:enddoc()
      oprint:RELEASE()
      release oprint
return nil

function repof(CLIBRARY)
 _OOHG_PRINTLIBRARY=CLIBRARY
 close data
 use test
 DO REPORT FORM report1 HEADING " PRINT DEMO"


return nil


function editp(clibrary)
 _OOHG_PRINTLIBRARY=CLIBRARY
 close data
 use test
 EDIT WORKAREA test
return nil

function editpx(clibrary)
 _OOHG_PRINTLIBRARY=CLIBRARY
 close data
 use test
 index on code to lista
 EDIT EXTENDED WORKAREA test
return nil


Function Eje_imprimir(clibrary)
_OOHG_PRINTLIBRARY=CLIBRARY
  oprint:=tprint(CLIBRARY)
  oprint:init()
  //////////////////
    //////////////////
  oprint:selprinter(.T. , .T.  )
  if oprint:lprerror
      oprint:release()
      return nil
  endif
  oprint:begindoc()
  oprint:beginpage()
  x:=0
  oprint:printdata(x,0,CLIBRARY+" PADRON DE CLIENTES al "+DTOC(DATE()), ,9,.T., , , ,.F.)
  x = x + 1

  DO WHILE x < 60
    oprint:printrectangle(x,00,x+1,03)
    oprint:printrectangle(x,03,x+1,19)
    oprint:printrectangle(x,19,x+1,33)
    oprint:printrectangle(x,33,x+1,37)
    oprint:printrectangle(x,37,x+1,46)
    oprint:printrectangle(x,46,x+1,53)
    oprint:printrectangle(x,53,x+1,62)
    oprint:printrectangle(x,62,x+1,78)
    oprint:printdata(x,0," Cuen              Nombre                      Dirección            Nro       Localidad          Cuit          Teléfono              Observaciones", ,6,.T., , , ,.F.)
    x = x + 1
  ENDDO

  oprint:endpage()
  oprint:enddoc()
  oprint:release()
RETU(.T.)
