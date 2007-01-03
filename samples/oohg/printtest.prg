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

	DEFINE MAIN MENU
		POPUP 'File'
			ITEM 'hbprinter' ACTION printtest("HBPRINTER")
			ITEM 'miniprint' ACTION printtest("MINIPRINT")
                        ITEM 'dos' ACTION printtest("DOSPRINT")
                        ITEM 'excel' ACTION printtest("EXCELPRINT")

                        ITEM 'RTF' ACTION printtest("RTFPRINT")
                        ITEM 'CSV' ACTION printtest("CSVPRINT")
                        ITEM 'HTML' ACTION printtest("HTMLPRINT")


			ITEM 'report form hbprinter' ACTION repof("HBPRINTER")
                        ITEM 'report form MINIPRINT' ACTION repof("MINIPRINT")

                        ITEM 'report form DOS' ACTION repof("DOSPRINT")
                        ITEM 'report form excelprint' ACTION repof("EXCELPRINT")
                        ITEM 'report form RTF' ACTION repof("RTFPRINT")
                        ITEM 'report form CSV' ACTION repof("CSVPRINT")

                        ITEM 'report form HTML' ACTION repof("HTMLPRINT")

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
      oprint:begindoc()
      oprint:setpreviewsize(1)  /// tamaœo del preview  1 menor,2 mas grande ,3 mas...
      oprint:beginpage()
      oprint:printdata(8,10,"esta es una prueba con times new roman size 14","times new roman",14,.F.) ///
      oprint:printdata(11,10,"esta es una prueba") ///
      oprint:printdata(12,10,"esta es una prueba con negrita",,,.T.) ///
      oprint:printdata(13,10,.T.)
      oprint:printdata(13,20,.F.)

      oprint:printdata(14,10,"esto es left", , , .F. , ,"L" ,30)
      oprint:printdata(15,10,"esta es center", , , .F. , ,"C" ,30)
      oprint:printdata(16,10,1500.00, ,10 , .F. , ,"R" ,30) ///a la derecha courier new
      oprint:printdata(17,10,25000.00 ,,10 , .F. , ,"R" ,30)

      oprint:printdata(18,10, TRANSFORM(1500.00, "999,999.99"),"arial",10 , .F. , ,"R" ,)
      /// a la derecha con letra arial
      oprint:printdata(19,10, TRANSFORM(25000.00,"999,999.99"),"arial",10 , .F. , ,"R" ,)
      oprint:printdata(29,40,"TPRINT Version: "+oprint:version())
      oprint:printimage(21,10,30,30,"cvcjpg.jpg")
      oprint:printline(21,10,30,30,,2)
      oprint:setcolor({0,128,255})  /// cambia el color en curso a azul
      oprint:printrectangle(35,10,50,30,,3)
      oprint:printroundrectangle(35,40,50,55)
      oprint:printline(54,10,54,50,,4)
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


