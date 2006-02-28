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
			ITEM 'dos' ACTION printtest("DOS")
			ITEM 'report form hbprinter' ACTION repof("HBPRINTER")
                        ITEM 'report form MINIPRINT' ACTION repof("MINIPRINT")
                        ITEM 'report form DOS' ACTION repof("DOS")
                        ITEM 'edit demo hbprinter' ACTION editp("HBPRINTER")
                        ITEM 'edit demo miniprint' ACTION editp("MINIPRINT")
                        ITEM 'edit demo DOS' ACTION editp("DOS")
                        ITEM 'editex demo hbprinter' ACTION editpx("HBPRINTER")
                        ITEM 'editex demo miniprint' ACTION editpx("MINIPRINT")
                        ITEM 'editex demo DOS' ACTION editpx("DOS")
		END POPUP
	END MENU

	end window

	activate window pr_form

Return Nil

function printtest(ctlibrary)
local oprint

set date ansi
set century on
*****************
**************************
oprint:=tprint()
oprint:init(ctlibrary)   ////// printlibrary
oprint:selprinter(.T. , .T.  )  /// select,preview,landscape,papersize
if oprint:lprerror
   oprint:release()
   return nil
endif
oprint:begindoc("mi documento")
///oprint:begindoc()
oprint:setpreviewsize(2)  /// tama¤o del preview  1 menor,2 mas grande ,3 mas...
oprint:beginpage()
oprint:printdata(10,10,"esta es una prueba","times new roman",10,.F.) /// 
oprint:printdata(11,10,"esta es una prueba") /// 

oprint:printdata(13,10,"esta es una prueba", , , .F. , ,"L" ,30)
oprint:printdata(14,10,"esta es una prueba", , , .F. , ,"C" ,30)
oprint:printdata(15,10,"esta es una prueba", , , .F. , ,"R" ,30)

oprint:printimage(20,10,30,30,"cvcjpg.jpg")
oprint:printline(20,10,30,30)
oprint:printrectangle(35,10,50,30)
oprint:printroundrectangle(35,40,50,55)
oprint:endpage()
oprint:enddoc()
oprint:RELEASE()
release oprint

return nil

function repof(CLIBRARY)
 _OOHG_PRINTLIBRARY=CLIBRARY
 close data
 use test
 DO REPORT FORM report1
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


