/*
* $Id: h_print.prg,v 1.81 2007-11-03 18:24:57 declan2005 Exp $
*/

#include 'hbclass.ch'
#include 'oohg.ch'
#include 'miniprint.ch'
#include 'winprint.ch'

#include "fileio.ch"

MEMVAR _OOHG_PRINTLIBRARY
MEMVAR _OOHG_printer_docname
MEMVAR _HMG_PRINTER_APRINTERPROPERTIES
MEMVAR _HMG_PRINTER_HDC
MEMVAR _HMG_PRINTER_COPIES
MEMVAR _HMG_PRINTER_COLLATE
MEMVAR _HMG_PRINTER_PREVIEW
MEMVAR _HMG_PRINTER_TIMESTAMP
MEMVAR _HMG_PRINTER_NAME
MEMVAR _HMG_PRINTER_PAGECOUNT
MEMVAR _HMG_PRINTER_HDC_BAK
MEMVAR oprintrtf1
MEMVAR oprintrtf2
MEMVAR oprintrtf3
MEMVAR rutaficrtf1
MEMVAR ntcsvprint
MEMVAR ntcsvprint1
MEMVAR oprintcsv1
MEMVAR milinea1
MEMVAR milinea2
MEMVAR oprintcsv2
MEMVAR oprintcsv3
MEMVAR cname
MEMVAR amicolor

*-------------------------
FUNCTION TPrint( clibx )
*-------------------------
LOCAL o_Print_
IF clibx=NIL
   IF type("_OOHG_printlibrary")="C"
      IF _OOHG_printlibrary="HBPRINTER"
         o_print_:=thbprinter()
      ELSEIF _OOHG_printlibrary="MINIPRINT"
         o_print_:=tminiprint()
      ELSEIF _OOHG_printlibrary="DOSPRINT"
         o_print_:=tdosprint()
      ELSEIF _OOHG_printlibrary="EXCELPRINT"
         o_print_:=texcelprint()
      ELSEIF _OOHG_printlibrary="CALCPRINT"
         o_print_:=tcalcprint()
      ELSEIF _OOHG_printlibrary="RTFPRINT"
         o_print_:=trtfprint()
      ELSEIF _OOHG_printlibrary="CSVPRINT"
         o_print_:=tcsvprint()
      ELSEIF _OOHG_printlibrary="HTMLPRINT"
         o_print_:=thtmlprint()
      ELSEIF _OOHG_printlibrary="PDFPRINT"
         o_print_:=tpdfprint()
      ELSE
         o_print_:=thbprinter()
      ENDIF
   ELSE
      o_print_:=tminiprint()
      _OOHG_printlibrary="MINIPRINT"
   ENDIF
ELSE
   IF valtype(clibx)="C"
      IF clibx="HBPRINTER"
         o_print_:=thbprinter()
      ELSEIF clibx="MINIPRINT"
         o_print_:=tminiprint()
      ELSEIF clibx="DOSPRINT"
         o_print_:=tdosprint()
      ELSEIF clibx="EXCELPRINT"
         o_print_:=texcelprint()
      ELSEIF clibx="CALCPRINT"
         o_print_:=tcalcprint()
      ELSEIF clibx="RTFPRINT"
         o_print_:=trtfprint()
      ELSEIF clibx="CSVPRINT"
         o_print_:=tcsvprint()
      ELSEIF clibx="HTMLPRINT"
         o_print_:=thtmlprint()
      ELSEIF clibx="PDFPRINT"
         o_print_:=tpdfprint()
      ELSE
         o_print_:=tminiprint()
      ENDIF 
   ELSE
      o_print_:=tminiprint()
      _OOHG_printlibrary="MINIPRINT"
   ENDIF 
ENDIF 
RETURN o_Print_


CREATE CLASS TPRINTBASE

DATA cprintlibrary      INIT "HBPRINTER" READONLY
DATA nmhor              INIT (10)/4.75   READONLY
DATA nmver              INIT (10)/2.45   READONLY
DATA nhfij              INIT (12/3.70)   READONLY
DATA nvfij              INIT (12/1.65)   READONLY
DATA cunits             INIT "ROWCOL"    READONLY
DATA nlmargin           INIT 0
DATA ntmargin           INIT 0
DATA cprinter           INIT ""          READONLY

DATA aprinters          INIT {}   READONLY
DATA aports             INIT {}   READONLY

DATA lprerror           INIT .F.  READONLY
DATA exit               INIT  .F. READONLY
DATA acolor             INIT {1,1,1}  READONLY
DATA cfontname          INIT "Courier New" READONLY
DATA nfontsize          INIT 12 READONLY
DATA nwpen              INIT 0.1   READONLY //// pen width
DATA tempfile           INIT gettempdir()+"T"+alltrim(str(int(hb_random(999999)),8))+".prn" READONLY
DATA impreview          INIT .F.  READONLY
DATA lwinhide           INIT .T.   READONLY
DATA cversion           INIT  "(oohg)V 2.3" READONLY
DATA cargo              INIT  .F.
////DATA cString            INIT  ""

DATA nlinpag            INIT 0            READONLY
DATA alincelda          INIT {}           READONLY
DATA nunitslin          INIT 1            READONLY
DATA lprop              INIT .F.          READONLY

*-------------------------
METHOD init()
*-------------------------

*-------------------------
METHOD initx() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD setprop()
*-------------------------

*-------------------------
METHOD setcpl()
*-------------------------

*-------------------------
METHOD begindoc()
*-------------------------

*-------------------------
METHOD begindocx() BLOCK { || nil }
*-------------------------
*-------------------------
METHOD enddoc()
*-------------------------

*-------------------------
METHOD enddocx() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD printdos()
*-------------------------

*-------------------------
METHOD printdosx() BLOCK { || nil }
*-------------------------
*-------------------------
METHOD beginpage()
*-------------------------

*-------------------------
METHOD beginpagex() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD condendos() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD condendosx() BLOCK { || nil }
*-------------------------


*-------------------------
METHOD NORMALDOS() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD normaldosx() BLOCK { || nil }
*-------------------------


*-------------------------
METHOD endpage()
*-------------------------

*-------------------------
METHOD endpagex() BLOCK { || nil }
*-------------------------
*-------------------------
METHOD release()
*-------------------------

*-------------------------
METHOD releasex() BLOCK { || nil }
*-------------------------
*-------------------------
METHOD printdata()
*-------------------------

*-------------------------
METHOD printdatax() BLOCK { || nil }
*-------------------------
*-------------------------
METHOD printimage()
*-------------------------

*-------------------------
METHOD printimagex() BLOCK { || nil }
*-------------------------
*-------------------------
METHOD printline()
*-------------------------

*-------------------------
METHOD printlinex() BLOCK { || nil }
*-------------------------


*-------------------------
METHOD printrectangle()
*-------------------------

*-------------------------
METHOD printrectanglex() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD selprinter()
*-------------------------

*-------------------------
METHOD selprinterx() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD getdefprinter()
*-------------------------

*-------------------------
METHOD getdefprinterx() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD setcolor()
*-------------------------

*-------------------------
METHOD setcolorx() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD setpreviewsize()
*-------------------------

*-------------------------
METHOD setpreviewsizex() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD setunits()   ////// mm o rowcol
*-------------------------

*-------------------------
METHOD setunitsx() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD printroundrectangle()
*-------------------------

*-------------------------
METHOD printroundrectanglex()  BLOCK { || nil }
*-------------------------

*-------------------------
METHOD version() INLINE ::cversion
*-------------------------

*-------------------------
METHOD setlmargin()
*-------------------------

*-------------------------
METHOD settmargin()
*-------------------------

ENDCLASS

*-------------------------

*-------------------------
METHOD setpreviewsize(ntam) CLASS TPRINTBASE
*-------------------------
IF ntam=NIL .or. ntam>5
   ntam:=3
ENDIF 
::setpreviewsizex(ntam)
RETURN self


*-------------------------
METHOD setprop(lmode) CLASS TPRINTBASE
*-------------------------
DEFAULT lmode to .F.
IF lmode
   ::lprop:=.T.
ELSE
   ::lprop:=.F.
ENDIF 
RETURN nil

*-------------------------
METHOD setcpl(ncpl) CLASS TPRINTBASE
*-------------------------
do case
   case ncpl=60
        ::nfontsize:=14
   case ncpl=80
        ::nfontsize:=12
   case ncpl=96
        ::nfontsize:=10
   case ncpl=120
        ::nfontsize:=8
   case ncpl=140
        ::nfontsize:=7
   case ncpl=160
        ::nfontsize:=6
   otherwise
        ::nfontsize:=12
endcase
RETURN nil

*-------------------------
METHOD release() CLASS TPRINTBASE
*-------------------------
IF ::exit
   RETURN nil
ENDIF 
////setinteractiveclose(::cargo)
::releasex()
RETURN nil

*-------------------------
METHOD init( ) CLASS TPRINTBASE
*-------------------------
IF iswindowactive(_oohg_winreport)
   msgstop("Print preview pending, close first")
   ::exit:=.T.
   RETURN nil
ENDIF 
// public _oohg_printer_docname
::initx()
RETURN self

*-------------------------
METHOD selprinter( lselect , lpreview, llandscape , npapersize ,cprinterx, lhide,nres ) CLASS TPRINTBASE
*-------------------------
local lsucess := .T.
IF ::exit
   ::lprerror:=.T.
   RETURN nil
ENDIF 

IF lhide#NIL
   ::lwinhide:=lhide
ENDIF 

SETPRC(0,0)
DEFAULT llandscape to .F.

::selprinterx( lselect , lpreview, llandscape , npapersize ,cprinterx, nres)
RETURN self


*-------------------------
METHOD BEGINDOC(cdoc) CLASS TPRINTBASE
*-------------------------
local olabel,oimage
DEFAULT cDoc to "ooHG printing"


DEFINE WINDOW _modalhide ;
AT 0,0 ;
WIDTH 0 HEIGHT 0 ;
TITLE cdoc MODAL NOSHOW NOSIZE NOSYSMENU NOCAPTION  ;

end window


DEFINE WINDOW _oohg_winreport  ;
AT 0,0 ;
WIDTH 400 HEIGHT 120 ;
TITLE cdoc CHILD NOSIZE NOSYSMENU NOCAPTION ;

@ 5,5 frame myframe width 390 height 110

@ 15,195 IMAGE IMAGE_101 obj oimage ;
picture 'hbprint_print'  ;
WIDTH 25  ;
HEIGHT 30 ;
STRETCH

@ 22,225 LABEL LABEL_101  VALUE '......' FONT "Courier New" SIZE 10

@ 55,10  label label_1 obj olabel value cdoc WIDTH 300 HEIGHT 32 FONT "Courier New"

DEFINE TIMER TIMER_101  ;
INTERVAL 1000  ;
ACTION action_timer(olabel,oimage)

IF .not. ::lwinhide
   _oohg_winreport.hide()
ENDIF 

end window
center window _oohg_winreport
activate window _modalhide NOWAIT
activate window _oohg_winreport NOWAIT

::begindocx(cdoc)
RETURN self


METHOD setlmargin(nlmar) CLASS TPRINTBASE
::nlmargin := nlmar
RETURN self

METHOD settmargin(ntmar) CLASS TPRINTBASE
::ntmargin := ntmar
RETURN self

*-------------------------
static function action_timer(olabel,oimage)
*-------------------------
IF iswindowdefined(_oohg_winreport)
   olabel:fontbold := IIF(olabel:fontbold,.F.,.T.)
   oimage:visible :=  IIF(olabel:fontbold,.T.,.F.)
ENDIF 
RETURN nil

*-------------------------
METHOD ENDDOC() CLASS TPRINTBASE
*-------------------------
::enddocx()
_oohg_winreport.release()
_modalhide.release()
RETURN self


*-------------------------
METHOD SETCOLOR(atColor) CLASS TPRINTBASE
*-------------------------
::acolor:=atColor
::setcolorx()
RETURN self

*-------------------------
METHOD beginPAGE() CLASS TPRINTBASE
*-------------------------
::beginpagex()
RETURN self

*-------------------------
METHOD ENDPAGE() CLASS TPRINTBASE
*-------------------------
::endpagex()
RETURN self

*-------------------------
METHOD getdefprinter() CLASS TPRINTBASE
*-------------------------
RETURN ::getdefprinterx()

*-------------------------
METHOD setunits(cunitsx) CLASS TPRINTBASE
*-------------------------
IF cunitsx="MM"
   ::cunits:="MM"
ELSE
   ::cunits:="ROWCOL"
ENDIF 
RETURN nil

*-------------------------
METHOD printdata(nlin,ncol,data,cfont,nsize,lbold,acolor,calign,nlen,litalic) CLASS TPRINTBASE
*-------------------------
local ctext,cspace,uAux,cTipo:=Valtype(data)
do While cTipo == "B"
   uAux:=EVal(data)
   cTipo:=valType(uAux)
   data:=uAux
enddo
do case
case cTipo == 'C'
   ctext:=data
case cTipo == 'N'
   ctext:=alltrim(str(data))
case cTipo == 'D'
   ctext:=dtoc(data)
case Ctipo == 'L'
   ctext:= iif(data,'T','F')
case cTipo == 'M'
   ctext:=data
case cTipo == 'O'
   ctext:="< Object >"
case cTipo == 'A'
   ctext:="< Array >"
otherwise
   ctext:=""
endcase

DEFAULT calign to "L"
DEFAULT nlen to 15

do case
case calign = "C"
   cspace=  space((int(nlen)-len(ctext))/2 )
case calign = "R"
   cspace = space(int(nlen)-len(ctext))
otherwise
   cspace = ""
endcase

DEFAULT nlin to 1
DEFAULT ncol to 1
DEFAULT ctext to ""
DEFAULT lbold to .F.
DEFAULT litalic to .F.
DEFAULT cfont to ::cfontname
DEFAULT nsize to ::nfontsize
DEFAULT acolor to ::acolor

IF ::cunits="MM"
   ::nmver:=1
   ::nvfij:=0
   ::nmhor:=1
   ::nhfij:=0
ELSE
   ::nmhor  := nsize/4.75
   IF ::lprop
      ::nmver  := (::nfontsize)/2.45
   ELSE
      ::nmver  :=  10/2.45
   ENDIF 
   ::nvfij  := (12/1.65)
   ::nhfij  := (12/3.70)
ENDIF 

ctext:= cspace + ctext

::printdatax(::ntmargin+nlin,::nlmargin+ncol,data,cfont,nsize,lbold,acolor,calign,nlen,ctext,litalic)
RETURN self

*-------------------------
METHOD printimage(nlin,ncol,nlinf,ncolf,cimage) CLASS TPRINTBASE
*-------------------------
DEFAULT nlin to 1
DEFAULT ncol to 1
DEFAULT cimage to ""
DEFAULT nlinf to 4
DEFAULT ncolf to 4

IF ::cunits="MM"
   ::nmver:=1
   ::nvfij:=0
   ::nmhor:=1
   ::nhfij:=0
ELSE
   ::nmhor  := (::nfontsize)/4.75
   IF ::lprop
      ::nmver  := (::nfontsize)/2.45
   ELSE
      ::nmver  :=  10/2.45
   ENDIF 

   ::nvfij  := (12/1.65)
   ::nhfij  := (12/3.70)
ENDIF 
::printimagex(::ntmargin+nlin,::nlmargin+ncol,::ntmargin+nlinf,::nlmargin+ncolf,cimage)
RETURN self


*-------------------------
METHOD printline(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TPRINTBASE
*-------------------------
DEFAULT nlin to 1
DEFAULT ncol to 1
DEFAULT nlinf to 4
DEFAULT ncolf to 4
DEFAULT atcolor to ::acolor
DEFAULT ntwpen to ::nwpen

IF ::cunits="MM"
   ::nmver:=1
   ::nvfij:=0
   ::nmhor:=1
   ::nhfij:=0
ELSE
   ::nmhor  := (::nfontsize)/4.75
   IF ::lprop
      ::nmver  := (::nfontsize)/2.45
   ELSE
      ::nmver  :=  10/2.45
   ENDIF 

   ::nvfij  := (12/1.65)
   ::nhfij  := (12/3.70)
ENDIF 
::printlinex(::ntmargin+nlin,::nlmargin+ncol,::ntmargin+nlinf,::nlmargin+ncolf,atcolor,ntwpen )
RETURN self

*-------------------------
METHOD printrectangle(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TPRINTBASE
*-------------------------

DEFAULT nlin to 1
DEFAULT ncol to 1
DEFAULT nlinf to 4
DEFAULT ncolf to 4

DEFAULT atcolor to ::acolor
DEFAULT ntwpen to ::nwpen

IF ::cunits="MM"
   ::nmver:=1
   ::nvfij:=0
   ::nmhor:=1
   ::nhfij:=0
ELSE
   ::nmhor  := (::nfontsize)/4.75

   IF ::lprop
      ::nmver  := (::nfontsize)/2.45
   ELSE
      ::nmver  :=  10/2.45
   ENDIF 


   ::nvfij  := (12/1.65)
   ::nhfij  := (12/3.70)
ENDIF 
::printrectanglex(::ntmargin+nlin,::nlmargin+ncol,::ntmargin+nlinf,::nlmargin+ncolf,atcolor,ntwpen )

RETURN self


*------------------------
METHOD printroundrectangle(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TPRINTBASE
*-------------------------
DEFAULT nlin to 1
DEFAULT ncol to 1
DEFAULT nlinf to 4
DEFAULT ncolf to 4

DEFAULT atcolor to ::acolor
DEFAULT ntwpen to ::nwpen

IF ::cunits="MM"
   ::nmver:=1
   ::nvfij:=0
   ::nmhor:=1
   ::nhfij:=0
ELSE
   ::nmhor  := (::nfontsize)/4.75

   IF ::lprop
      ::nmver  := (::nfontsize)/2.45
   ELSE
      ::nmver  :=  10/2.45
   ENDIF 

   ::nvfij  := (12/1.65)
   ::nhfij  := (12/3.70)
ENDIF 

::printroundrectanglex(::ntmargin+nlin,::nlmargin+ncol,::ntmargin+nlinf,::nlmargin+ncolf,atcolor,ntwpen )

RETURN self

*-------------------------
method printdos() CLASS TPRINTBASE
*-------------------------
local cbat, nHdl
cbat:='b'+alltrim(str(random(999999),6))+'.bat'
nHdl := FCREATE( cBat )
FWRITE( nHdl, "copy " + ::tempfile + " prn" + CHR( 13 ) + CHR( 10 ) )
FWRITE( nHdl, "rem comando auxiliar de impresion" + CHR( 13 ) + CHR( 10 ) )
FCLOSE( nHdl )
waitrun( cBat, 0 )
erase &cbat
RETURN nil

CREATE CLASS TMINIPRINT FROM TPRINTBASE


*-------------------------
METHOD initx()
*-------------------------

*-------------------------
METHOD begindocx()
*-------------------------

*-------------------------
METHOD enddocx()
*-------------------------

*-------------------------
METHOD beginpagex()
*-------------------------

*-------------------------
METHOD endpagex()
*-------------------------

*-------------------------
METHOD releasex()
*-------------------------

*-------------------------
METHOD printdatax()
*-------------------------

*-------------------------
METHOD printimagex()
*-------------------------

*-------------------------
METHOD printlinex()
*-------------------------

*-------------------------
METHOD printrectanglex
*-------------------------

*-------------------------
METHOD selprinterx()
*-------------------------

*-------------------------
METHOD getdefprinterx()
*-------------------------

*-------------------------
METHOD printroundrectanglex()
*-------------------------
ENDCLASS

*-------------------------
METHOD initx() CLASS TMINIPRINT
*-------------------------
public _HMG_PRINTER_APRINTERPROPERTIES
public _HMG_PRINTER_HDC
public _HMG_PRINTER_COPIES
public _HMG_PRINTER_COLLATE
public _HMG_PRINTER_PREVIEW
public _HMG_PRINTER_TIMESTAMP
public _HMG_PRINTER_NAME
public _HMG_PRINTER_PAGECOUNT
public _HMG_PRINTER_HDC_BAK

::aprinters:=aprinters()
::cprintlibrary:="MINIPRINT"
RETURN self


*-------------------------
METHOD begindocx(  cDoc ) CLASS TMINIPRINT
*-------------------------
IF cDoc#Nil
   START PRINTDOC NAME cDoc
ELSE
   START PRINTDOC
ENDIF 
RETURN self

*-------------------------
METHOD enddocx() CLASS TMINIPRINT
*-------------------------
END PRINTDOC
RETURN self

*-------------------------
METHOD beginpagex() CLASS TMINIPRINT
*-------------------------
START PRINTPAGE
RETURN self

*-------------------------
METHOD endpagex() CLASS TMINIPRINT
*-------------------------
END PRINTPAGE
RETURN self


*-------------------------
METHOD releasex() CLASS TMINIPRINT
*-------------------------
release _HMG_PRINTER_APRINTERPROPERTIES
release _HMG_PRINTER_HDC
release _HMG_PRINTER_COPIES
release _HMG_PRINTER_COLLATE
release _HMG_PRINTER_PREVIEW
release _HMG_PRINTER_TIMESTAMP
release _HMG_PRINTER_NAME
release _HMG_PRINTER_PAGECOUNT
release _HMG_PRINTER_HDC_BAK
RETURN nil

*-------------------------
METHOD printdatax(nlin,ncol,data,cfont,nsize,lbold,acolor,calign,nlen,ctext,litalic) CLASS TMINIPRINT
*-------------------------
Empty( Data )
DEFAULT aColor to ::acolor
Empty( nLen )

do case
   case litalic
     IF .not. lbold
   IF calign="R"
      textalign( 2 )
       @ nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2 +(len(ctext))*::nmhor  PRINT (ctext) font cfont size nsize ITALIC COLOR acolor
      textalign( 0 )
   ELSE
      @ nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2 PRINT (ctext) font cfont size nsize ITALIC COLOR acolor
   ENDIF 
ELSE
   IF calign="R"
      textalign( 2 )
      @ nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2 +(len(ctext))*::nmhor  PRINT (ctext) font cfont size nsize  BOLD ITALIC COLOR acolor
      textalign( 0 )
   ELSE
      @ nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2 PRINT (ctext) font cfont size nsize  BOLD ITALIC COLOR acolor
   ENDIF 
ENDIF 

   otherwise
IF .not. lbold
   IF calign="R"
      textalign( 2 )
       @ nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2 +(len(ctext))*::nmhor  PRINT (ctext) font cfont size nsize COLOR acolor
      textalign( 0 )
   ELSE
      @ nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2 PRINT (ctext) font cfont size nsize COLOR acolor
   ENDIF 
ELSE
   IF calign="R"
      textalign( 2 )
      @ nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2 +(len(ctext))*::nmhor  PRINT (ctext) font cfont size nsize  BOLD COLOR acolor
      textalign( 0 )
   ELSE
      @ nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2 PRINT (ctext) font cfont size nsize  BOLD COLOR acolor
   ENDIF 
ENDIF 
endcase
RETURN self

*-------------------------
METHOD printimagex(nlin,ncol,nlinf,ncolf,cimage) CLASS TMINIPRINT
*-------------------------
@  nlin*::nmver+::nvfij , ncol*::nmhor+::nhfij*2 PRINT IMAGE cimage WIDTH ((ncolf - ncol-1)*::nmhor + ::nhfij) HEIGHT ((nlinf+0.5 - nlin)*::nmver+::nvfij)
RETURN self


*-------------------------
METHOD printlinex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TMINIPRINT
*-------------------------
DEFAULT atColor to ::acolor
@  (nlin+.2)*::nmver+::nvfij,ncol*::nmhor+::nhfij*2 PRINT LINE TO  (nlinf+.2)*::nmver+::nvfij,ncolf*::nmhor+::nhfij*2  COLOR atcolor PENWIDTH ntwpen  //// CPEN
RETURN self

*-------------------------
METHOD printrectanglex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TMINIPRINT
*-------------------------
DEFAULT atColor to ::acolor
@  nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2 PRINT RECTANGLE TO  (nlinf+0.5)*::nmver+::nvfij,ncolf*::nmhor+::nhfij*2 COLOR atcolor  PENWIDTH ntwpen  //// CPEN
RETURN self


*-------------------------
METHOD selprinterx( lselect , lpreview, llandscape , npapersize ,cprinterx,nres) CLASS TMINIPRINT
*-------------------------
local worientation,lsucess

IF nres=NIL
   nres:=PRINTER_RES_MEDIUM
ENDIF 
IF llandscape
   Worientation:= PRINTER_ORIENT_LANDSCAPE
ELSE
   Worientation:= PRINTER_ORIENT_PORTRAIT
ENDIF

IF lselect .and. lpreview .and. cprinterx = NIL
   ::cPrinter := GetPrinter()
   If Empty (::cPrinter)
      ::lprerror:=.T.
      Return Nil
   EndIf

   IF npapersize#NIL
      SELECT PRINTER ::cprinter to lsucess ;
      ORIENTATION worientation ;
      PAPERSIZE npapersize       ;
      QUALITY nres ;
      PREVIEW
   ELSE
      SELECT PRINTER ::cprinter to lsucess ;
      ORIENTATION worientation ;
      QUALITY nres ;
      PREVIEW
   ENDIF 
ENDIF 

IF (.not. lselect) .and. lpreview .and. cprinterx = NIL

   IF npapersize#NIL
      SELECT PRINTER DEFAULT TO lsucess ;
      ORIENTATION worientation  ;
      PAPERSIZE npapersize       ;
      QUALITY nres ;
      PREVIEW
   ELSE
     SELECT PRINTER DEFAULT TO lsucess ;
     ORIENTATION worientation  ;
     QUALITY nres ;
     PREVIEW
   ENDIF 
ENDIF 

IF (.not. lselect) .and. (.not. lpreview) .and. cprinterx = NIL

   IF npapersize#NIL
      SELECT PRINTER DEFAULT TO lsucess  ;
      ORIENTATION worientation  ;
      QUALITY nres ;
      PAPERSIZE npapersize
   ELSE
      SELECT PRINTER DEFAULT TO lsucess  ;
      QUALITY nres ;
      ORIENTATION worientation
   ENDIF 
ENDIF 

IF lselect .and. .not. lpreview .and. cprinterx = NIL
   ::cPrinter := GetPrinter()
   If Empty (::cPrinter)
      ::lprerror:=.T.
      Return Nil
   EndIf

   IF npapersize#NIL
      SELECT PRINTER ::cprinter to lsucess ;
      ORIENTATION worientation ;
      QUALITY nres ;
      PAPERSIZE npapersize
   ELSE
      SELECT PRINTER ::cprinter to lsucess ;
      QUALITY nres ;
      ORIENTATION worientation
   ENDIF 
ENDIF 

IF cprinterx # NIL .AND. lpreview
   If Empty (cprinterx)
      ::lprerror:=.T.
      Return Nil
   EndIf

   IF npapersize#NIL
      SELECT PRINTER cprinterx to lsucess ;
      ORIENTATION worientation ;
      QUALITY nres ;
      PAPERSIZE npapersize ;
      PREVIEW
   ELSE
      SELECT PRINTER cprinterx to lsucess ;
      ORIENTATION worientation ;
      QUALITY nres ;
      PREVIEW
   ENDIF 
ENDIF 

IF cprinterx # NIL .AND. .not. lpreview
   If Empty (cprinterx)
      ::lprerror:=.T.
      Return Nil
   EndIf

   IF npapersize#NIL
      SELECT PRINTER cprinterx to lsucess ;
      ORIENTATION worientation ;
      QUALITY nres ;
      PAPERSIZE npapersize
   ELSE
      SELECT PRINTER cprinterx to lsucess ;
      QUALITY nres ;
      ORIENTATION worientation
   ENDIF 
ENDIF 

IF .NOT. lsucess
   ::lprerror:=.T.
   RETURN nil
ENDIF
RETURN self

*-------------------------
METHOD getdefprinterx() CLASS TMINIPRINT
*-------------------------
RETURN getdefaultprinter()


*-------------------------
METHOD printroundrectanglex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TMINIPRINT
*-------------------------
DEFAULT atColor to ::acolor
@  nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2 PRINT RECTANGLE TO  (nlinf+0.5)*::nmver+::nvfij,ncolf*::nmhor+::nhfij*2 COLOR atcolor  PENWIDTH ntwpen  ROUNDED //// CPEN
RETURN self


CREATE CLASS THBPRINTER FROM TPRINTBASE


*-------------------------
METHOD initx()
*-------------------------

*-------------------------
METHOD begindocx()
*-------------------------

*-------------------------
METHOD enddocx()
*-------------------------

*-------------------------
METHOD beginpagex()
*-------------------------

*-------------------------
METHOD endpagex()
*-------------------------

*-------------------------
METHOD releasex()
*-------------------------

*-------------------------
METHOD printdatax()
*-------------------------

*-------------------------
METHOD printimagex()
*-------------------------

*-------------------------
METHOD printlinex()
*-------------------------

*-------------------------
METHOD printrectanglex
*-------------------------

*-------------------------
METHOD selprinterx()
*-------------------------

*-------------------------
METHOD getdefprinterx()
*-------------------------

*-------------------------
METHOD setcolorx()
*-------------------------

*-------------------------
METHOD setpreviewsizex()
*-------------------------

*-------------------------
METHOD printroundrectanglex()
*-------------------------
ENDCLASS


*-------------------------
METHOD INITx() CLASS THBPRINTER
*-------------------------
public hbprn

INIT PRINTSYS
GET PRINTERS TO ::aprinters
GET PORTS TO ::aports
SET UNITS MM
::cprintlibrary:="HBPRINTER"
RETURN self


*-------------------------
METHOD BEGINDOCx (cdoc) CLASS THBPRINTER
*-------------------------
::setpreviewsize(2)
START DOC NAME cDoc
 define font "F0" name "courier new" size 10
 define font "F1" name "courier new" size 10 BOLD


 define font "F2" name "courier new" size 10 ITALIC
 define font "F3" name "courier new" size 10 BOLD ITALIC
RETURN self


*-------------------------
METHOD ENDDOCx() CLASS THBPRINTER
*-------------------------
END DOC
RETURN self


*-------------------------
METHOD BEGINPAGEx() CLASS THBPRINTER
*-------------------------
START PAGE
RETURN self


*-------------------------
METHOD ENDPAGEx() CLASS THBPRINTER
*-------------------------
END PAGE
RETURN self


*-------------------------
METHOD RELEASEx() CLASS THBPRINTER
*-------------------------
RELEASE PRINTSYS
RELEASE HBPRN
RETURN self


*-------------------------
METHOD PRINTDATAx(nlin,ncol,data,cfont,nsize,lbold,acolor,calign,nlen,ctext,litalic) CLASS THBPRINTER
*-------------------------
Empty( Data )

DEFAULT aColor to ::acolor
Empty( nLen )

select font "F0"
change font "F0" name cfont size nsize

IF lbold
   select font "F1"
   change font "F1" name cfont size nsize BOLD
ENDIF 

IF litalic
   IF lbold
      select font "F3"
      change font "F3" name cfont size nsize BOLD ITALIC
   ELSE
      select font "F2"
      change font "F2" name cfont size nsize ITALIC
   ENDIF 
ENDIF 

SET TEXTCOLOR acolor

IF .not. lbold
   IF calign="R"
      set text align right
      @ nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2 +(len(ctext))*::nmhor  SAY (ctext) TO PRINT
      set text align left
   ELSE
      @ nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2 SAY (ctext) TO PRINT
   ENDIF
ELSE
   IF calign="R"
      set text align right
          @ nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2 +(len(ctext))*::nmhor  SAY (ctext) TO PRINT
      set text align left
   ELSE
        @ nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2  SAY (ctext) TO PRINT
   ENDIF 
ENDIF 
RETURN self


*-------------------------
METHOD printimagex(nlin,ncol,nlinf,ncolf,cimage) CLASS thbprinter
*-------------------------
@  nlin*::nmver+::nvfij ,ncol*::nmhor+::nhfij*2 PICTURE cimage SIZE  (nlinf+0.5-nlin-4)*::nmver+::nvfij , (ncolf-ncol-3)*::nmhor+::nhfij*2
RETURN self


*-------------------------
METHOD printlinex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS thbprinter
*-------------------------
DEFAULT atColor to ::acolor
CHANGE PEN "C0" WIDTH ntwpen*10  COLOR atcolor
SELECT PEN "C0"
@  nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2 , (nlinf)*::nmver+::nvfij,ncolf*::nmhor+::nhfij*2  LINE PEN "C0"  //// CPEN
RETURN self

*-------------------------
METHOD printrectanglex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS THBPRINTER
*-------------------------
DEFAULT atColor to ::acolor
CHANGE PEN "C0" WIDTH ntwpen*10 COLOR atcolor
SELECT PEN "C0"
@  nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2, (nlinf+0.5)*::nmver+::nvfij, ncolf*::nmhor+::nhfij*2  RECTANGLE  PEN "C0" //// CPEN  RECTANGLE  ///// [PEN <cpen>] [BRUSH <cbrush>]
RETURN self

*-------------------------
METHOD selprinterx( lselect , lpreview, llandscape , npapersize ,cprinterx,nres ) CLASS THBPRINTER
*-------------------------

IF lselect .and. lpreview .and. cprinterx=NIL
   SELECT BY DIALOG PREVIEW
ENDIF 
IF lselect .and. (.not. lpreview) .and. cprinterx=NIL
   SELECT BY DIALOG
ENDIF 
IF (.not. lselect) .and. lpreview .and. cprinterx=NIL
   SELECT DEFAULT PREVIEW
ENDIF 
IF (.not. lselect) .and. (.not. lpreview) .and. cprinterx=NIL
   SELECT DEFAULT
ENDIF 

IF cprinterx # NIL
   IF lpreview
      SELECT PRINTER cprinterx PREVIEW
   ELSE
      SELECT PRINTER cprinterx
   ENDIF
ENDIF 

IF HBPRNERROR != 0
   ::lprerror:=.T.
   RETURN nil
ENDIF

define font "f0" name ::cfontname size ::nfontsize
define font "f1" name ::cfontname size ::nfontsize BOLD

define pen "C0" WIDTH ::nwpen COLOR ::acolor
select pen "C0"
IF llandscape
   set page orientation DMORIENT_LANDSCAPE font "f0"
ELSE
   set page orientation DMORIENT_PORTRAIT  font "f0"
ENDIF 
IF npapersize#NIL
   set page papersize npapersize
ENDIF 

IF nres#NIL
   SET QUALITY nres   ////:=PRINTER_RES_MEDIUM
ENDIF 

RETURN self


*-------------------------
METHOD getdefprinterx() CLASS THBPRINTER
*-------------------------
local cdefprinter
GET DEFAULT PRINTER TO cdefprinter
RETURN cdefprinter


*-------------------------
METHOD setcolorx() CLASS THBPRINTER
*-------------------------
CHANGE PEN "C0" WIDTH ::nwpen COLOR ::acolor
SELECT PEN "C0"
RETURN self


*-------------------------
METHOD setpreviewsizex(ntam) CLASS THBPRINTER
*-------------------------
SET PREVIEW SCALE ntam
RETURN self


*-------------------------
METHOD printroundrectanglex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS THBPRINTER
*-------------------------
DEFAULT atColor to ::acolor
CHANGE PEN "C0" WIDTH ntwpen*10 COLOR atcolor
SELECT PEN "C0"
hbprn:RoundRect( nlin*::nmver+::nvfij  ,ncol*::nmhor+::nhfij*2 ,(nlinf+0.5)*::nmver+::nvfij ,ncolf*::nmhor+::nhfij*2 ,10, 10,"C0")
RETURN self

CREATE CLASS TDOSPRINT FROM TPRINTBASE


DATA cString INIT ""
DATA cbusca INIT ""
DATA nOccur INIT 0

*-------------------------
METHOD initx()
*-------------------------

*-------------------------
METHOD begindocx()
*-------------------------

*-------------------------
METHOD enddocx()
*-------------------------

*-------------------------
METHOD beginpagex()
*-------------------------

*-------------------------
METHOD endpagex()
*-------------------------

*-------------------------
METHOD releasex() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD printdatax()
*-------------------------

*-------------------------
METHOD printimage() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD printlinex()
*-------------------------

*-------------------------
METHOD printrectanglex BLOCK { || nil }
*-------------------------

*-------------------------
METHOD selprinterx()
*-------------------------

*-------------------------
METHOD getdefprinterx() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD setcolorx() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD setpreviewsizex() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD printroundrectanglex() BLOCK { || nil }
*-------------------------

*-------------------------
method condendosx()
*-------------------------

*-------------------------
method normaldosx()
*-------------------------

method searchstring()

method nextsearch()

ENDCLASS



*-------------------------
METHOD initx() CLASS TDOSPRINT
*-------------------------
local i
::impreview:=.F.
::cprintlibrary:="DOSPRINT"
RETURN self


*-------------------------
METHOD begindocx() CLASS TDOSPRINT
*-------------------------
SET PRINTER TO &(::tempfile)
SET DEVICE TO PRINT
RETURN self

*-------------------------
METHOD enddocx() CLASS TDOSPRINT
*-------------------------
local _nhandle,wr,nx,ny

nx:=getdesktopwidth()
ny:=getdesktopheight()

SET DEVICE TO SCREEN
SET PRINTER TO
_nhandle:=FOPEN(::tempfile,0+64)
IF ::impreview
   wr:=memoread((::tempfile))
   DEFINE WINDOW PRINT_PREVIEW  ;
   AT 0,0 ;
   WIDTH nx HEIGHT ny-70 ;
   TITLE 'Preview -----> ' + ::tempfile ;
   MODAL

   @ 0,0 RICHEDITBOX EDIT_P ;
   OF PRINT_PREVIEW ;
   WIDTH nx-50 ;
   HEIGHT ny-40-70 ;
   VALUE WR ;
   READONLY ;
   FONT 'Courier New' ;
   SIZE 10 ;
   BACKCOLOR WHITE

   @ 010,nx-40 button but_4 caption "X" width 30 action ( print_preview.release() ) tooltip "close"
   @ 090,nx-40 button but_1 caption "+ +" width 30 action zoom("+") tooltip "zoom +"
   @ 170,nx-40 button but_2 caption "- -" width 30 action zoom("-") tooltip "zoom -"
   @ 250,nx-40 button but_3 caption "P" width 30 action (::printdos()) tooltip "Print DOS mode"
   @ 330,nx-40 button but_5 caption "S" width 30 action  (::searchstring(print_preview.edit_p.value)) tooltip "Search"
   @ 410,nx-40 button but_6 caption "N" width 30 action  ::nextsearch() tooltip "Next Search"

   END WINDOW

   CENTER WINDOW PRINT_PREVIEW
   ACTIVATE WINDOW PRINT_PREVIEW

ELSE

  ::PRINTDOS()

ENDIF

IF FILE(::tempfile)
   fclose(_nhandle)
   ERASE &(::tempfile)
ENDIF

RETURN self


*-------------------------
METHOD beginpagex() CLASS TDOSPRINT
*-------------------------
@ 0,0 SAY ""
RETURN self


*-------------------------
METHOD endpagex() CLASS TDOSPRINT
*-------------------------
EJECT
RETURN self


*-------------------------
METHOD printdatax(nlin,ncol,data,cfont,nsize,lbold,acolor,calign,nlen,ctext,litalic) CLASS TDOSPRINT
*-------------------------
Empty( Data )
Empty( cFont )
Empty( nSize )
Empty( aColor )
Empty( cAlign )
Empty( nLen )
Empty( lItalic)

IF .not. lbold
   @ nlin,ncol say (ctext)
ELSE
   @ nlin,ncol say (ctext)
   @ nlin,ncol say (ctext)
ENDIF
RETURN self


*-------------------------
METHOD printlinex(nlin,ncol,nlinf,ncolf /* ,atcolor,ntwpen */ ) CLASS TDOSPRINT
*-------------------------
IF nlin=nlinf
   @ nlin,ncol say replicate("-",ncolf-ncol+1)
ENDIF
RETURN self


*-------------------------
METHOD selprinterx( lselect , lpreview /* , llandscape , npapersize ,cprinterx */ ) CLASS TDOSPRINT
*-------------------------
Empty( lSelect )
DO WHILE file(::tempfile)
   ::tempfile:=gettempdir()+"T"+alltrim(str(int(hb_random(999999)),8))+".prn"
ENDDO
IF lpreview
   ::impreview:=.T.
ENDIF
//////////////////////////


/////////////////////////
RETURN self


*-------------------------
METHOD condendosx() CLASS TDOSPRINT
*-------------------------
@ prow(), pcol() say chr(15)
RETURN self


*-------------------------
METHOD normaldosx() CLASS TDOSPRINT
*-------------------------
@ prow(), pcol() say chr(18)
RETURN self


*-------------------------
static function zoom(cOp)
*-------------------------
IF cOp="+" .and. print_preview.edit_p.fontsize <= 24
   print_preview.edit_p.fontsize:=  print_preview.edit_p.fontsize + 2
ENDIF 

IF cOp="-" .and. print_preview.edit_p.fontsize > 7
   print_preview.edit_p.fontsize:=  print_preview.edit_p.fontsize - 2
ENDIF 
RETURN nil


*-------------------------
Method searchstring(cTarget) CLASS TDOSPRINT
*-------------------------
print_preview.but_6.enabled:=.F.
print_preview.edit_p.caretpos:=1
::nOccur:=0
::cBusca:= cTarget
::cString := ""
::cString  := inputbox('Text: ','Search String')
IF empty(::cString)
   RETURN(NIL)
ENDIF 
print_preview.but_6.enabled:=.t.
::nextsearch()
RETURN(nil)

*-----------------------------------------------------*
Method nextsearch( )
*-----------------------------------------------------*
local cString,ncaretpos
cString := UPPER(::cstring)
////ncount:=STRCOUNT( chr(13),cString, print_preview.edit_p.caretpos )
nCaretpos := ATplus(ALLTRIM(cString),UPPER(::cBusca),::nOccur)
::nOccur:=nCaretpos+1

print_preview.edit_p.setfocus
IF nCaretpos>0
   print_preview.edit_p.caretpos:=nCaretPos
   print_preview.edit_p.refresh
ELSE
   print_preview.but_6.enabled:=.F.
   msginfo("End search","Information")
ENDIF 
RETURN nil

*-------------------------
static function strcount(cbusca,cencuentra,n)
*-------------------------
local nc:=0,i
cbusca:=alltrim(cbusca)
for i:=1 to n
    IF upper(substr(cencuentra,i,len(cbusca)))=upper(cbusca)
       nc++
    ENDIF 
next i
RETURN nc


*-------------------------
static function atplus(cbusca,ctodo,ninicio)
*-------------------------
local i,nposluna,lencbusca,lenctodo,uppercbusca
nposluna:=0
lenctodo:=len(ctodo)
lencbusca:=len(cbusca)
uppercbusca:=upper(cbusca)
for i:= ninicio to lenctodo
    IF upper(substr(ctodo,i,lencbusca))=uppercbusca
       nposluna:=i
       exit
    ENDIF 
next i
RETURN nposluna

/// excelprint based upon contribution of Jose Miguel josemisu@yahoo.com.ar

CREATE CLASS TEXCELPRINT FROM TPRINTBASE

    DATA oExcel INIT nil
    DATA oHoja  INIT nil
    DATA cTlinea INIT ""

*-------------------------
METHOD initx()
*-------------------------

*-------------------------
METHOD begindocx()
*-------------------------

*-------------------------
METHOD enddocx()
*-------------------------

*-------------------------
METHOD beginpagex()
*-------------------------

*-------------------------
METHOD endpagex()
*-------------------------

*-------------------------
METHOD releasex()
*-------------------------

*-------------------------
METHOD printdatax()
*-------------------------

*-------------------------
METHOD printimagex()
*-------------------------

*-------------------------
METHOD printlinex() BLOCK {|| NIL }
*-------------------------

*-------------------------
METHOD printrectanglex BLOCK {|| NIL }
*-------------------------

*-------------------------
METHOD selprinterx()
*-------------------------

*-------------------------
METHOD getdefprinterx() BLOCK {|| NIL }
*-------------------------

*-------------------------
METHOD setcolorx() BLOCK {|| NIL }
*-------------------------

*-------------------------
METHOD setpreviewsizex() BLOCK {|| NIL }
*-------------------------

*-------------------------
METHOD printroundrectanglex() BLOCK {|| NIL }
*-------------------------

*-------------------------
method condendosx() BLOCK {|| NIL }
*-------------------------

*-------------------------
method normaldosx() BLOCK {|| NIL }
*-------------------------

*-------------------------
METHOD setunitsx()    // mm o rowcol , mm por renglon
*-------------------------

ENDCLASS


*-------------------------
METHOD initx() CLASS TEXCELPRINT
*-------------------------
::impreview:=.F.
::cprintlibrary:="EXCELPRINT"
RETURN self

*-------------------------
METHOD selprinterx( lselect , lpreview, llandscape , npapersize ,cprinterx) CLASS TEXCELPRINT
*-------------------------
empty(lselect)
empty(lpreview)
empty(llandscape)
empty(npapersize)
empty(cprinterx)

///::oExcel := CreateObject( "Excel.Application" )
::oExcel := TOleAuto():New( "Excel.Application" )
IF Ole2TxtError() != 'S_OK'
   MsgStop('Excel not found','error')
   ::lprerror:=.T.
   ::exit:=.T.
   RETURN Nil
ENDIF
RETURN self

*-------------------------
METHOD begindocx() CLASS TEXCELPRINT
*-------------------------
::oExcel:WorkBooks:Add()
::oHoja:=::oExcel:ActiveSheet()
::oHoja:Name := "List"
::oHoja:Cells:Font:Name := ::cfontname
::oHoja:Cells:Font:Size := ::nfontsize
RETURN self


*-------------------------
METHOD enddocx() CLASS TEXCELPRINT
*-------------------------
local nCol
///     ::oHoja:Cells(nlin,alinceldax):Select() 			//------Select row-------//
//     Copyclipboard(space(ncol)+ctext)				//----copy the data at the clipboard-----//
///     ::oHoja:Paste()					//----paste in the excel page-----//
///     ClearClipboard()     si no copio y pego toda una hoja entera esto no tiene sentido......

FOR nCol:=1 TO ::oHoja:UsedRange:Columns:Count()
    ::oHoja:Columns( nCol ):AutoFit()
NEXT
::oHoja:Cells( 1, 1 ):Select()
::oExcel:Visible := .T.
::oHoja:= NIL
::oExcel:= NIL
RETURN self


*-------------------------
METHOD releasex() CLASS TEXCELPRINT
*-------------------------
::oHoja := nil
::oExcel := nil
RETURN self


*-------------------------
METHOD beginpagex() CLASS TEXCELPRINT
*-------------------------
RETURN self


*-------------------------
METHOD endpagex() CLASS TEXCELPRINT
*-------------------------
::nlinpag:=LEN(::alincelda)+1
::alincelda:={}
RETURN self


*-------------------------
METHOD setunitsx(cunitsx,nunitslinx) CLASS TEXCELPRINT
*-------------------------
IF cunitsx="MM"
   ::cunits:="MM"
ELSE
   ::cunits:="ROWCOL"
ENDIF 
IF nunitslinx=NIL
   ::nunitslin:=1
ELSE
   ::nunitslin:=nunitslinx
ENDIF 
RETURN self


*-------------------------
METHOD printimagex(nlin,ncol,nlinf,ncolf,cimage) CLASS TEXCELPRINT
*-------------------------
local cfolder :=  getcurrentfolder()+"\"
local ccol :=alltrim(str(ncol))
local crango := "A"+ccol+":"+"A"+ccol
empty(nlin)
empty(nlinf)
empty(ncolf)

::oHoja:range( crango ):Select()
cimage:=cfolder+cimage
::oHoja:Pictures:Insert(cimage)

RETURN self

*-------------------------
METHOD printdatax(nlin,ncol,data,cfont,nsize,lbold,acolor,calign,nlen,ctext,litalic) CLASS TEXCELPRINT
*-------------------------
local alinceldax
////empty(ncol)
empty(data)
empty(acolor)
empty(nlen)
nlin++
IF ::nunitslin>1
   nlin:=round(nlin/::nunitslin,0)
ENDIF 
nlin:=nlin+::nlinpag
IF LEN(::alincelda)<nlin
   DO WHILE LEN(::alincelda)<nlin
      AADD(::alincelda,0)
   ENDDO
ENDIF
::alincelda[nlin]:=::alincelda[nlin]+1
alinceldax:=::alincelda[nlin]
///::cTlinea:=::cTlinea+ ctext+chr(13)+chr(10)   //// mirando como hacrlo con el portapapeles, pero no es nada facil...

::oHoja:Cells(nlin,alinceldax):Value := "'"+space(ncol)+ctext
IF cfont#::cfontname
   ::oHoja:Cells(nlin,alinceldax):Font:Name := cfont
ENDIF 
IF nsize#::nfontsize
   ::oHoja:Cells(nlin,alinceldax):Font:Size := nsize
ENDIF 
IF lbold
   ::oHoja:Cells(nlin,alinceldax):Font:Bold := lbold
ENDIF

IF lItalic
   ::oHoja:Cells(nlin,alinceldax):Font:Italic := lItalic
ENDIF

do case
case calign="R"
   ::oHoja:Cells(nlin,alinceldax):HorizontalAlignment:= -4152  //Derecha
case calign="C"
   ::oHoja:Cells(nlin,alinceldax):HorizontalAlignment:= -4108  //Centrar
endcase
RETURN self

////////////////////////

CREATE CLASS THTMLPRINT FROM TEXCELPRINT

*-------------------------
METHOD enddocx()
*-------------------------

ENDCLASS

METHOD enddocx() CLASS THTMLPRINT
local nCol,cRuta
For nCol:= 1 to ::oHoja:UsedRange:Columns:Count()
    ::oHoja:Columns( nCol ):AutoFit()
NEXT
::oHoja:Cells( 1, 1 ):Select()
cRuta:=GetmydocumentsFolder()
::oExcel:DisplayAlerts :=.F.
::oHoja:SaveAs(cRuta+"\Printer.html", 44,"","", .f. , .f.)
::oExcel:Quit()
::ohoja := nil
::oExcel := nil
IF ShellExecute(0, "open", "rundll32.exe", "url.dll,FileProtocolHandler "+ cRuta+ "\Printer.html", ,1) <=32
     MSGINFO("html Extension not asociated"+CHR(13)+CHR(13)+ ;
     "File saved in:"+CHR(13)+cRuta+"\printer.html")
ENDIF
RETURN self


CREATE CLASS TRTFPRINT FROM TPRINTBASE

*-------------------------
METHOD initx()
*-------------------------

*-------------------------
METHOD begindocx()
*-------------------------

*-------------------------
METHOD enddocx()
*-------------------------

*-------------------------
METHOD beginpagex()
*-------------------------

*-------------------------
METHOD endpagex()
*-------------------------

*-------------------------
METHOD releasex() BLOCK {|| NIL }
*-------------------------

*-------------------------
METHOD printdatax()
*-------------------------

*-------------------------
METHOD printimage() BLOCK {|| NIL }
*-------------------------

*-------------------------
METHOD printlinex()
*-------------------------

*-------------------------
METHOD printrectanglex BLOCK {|| NIL }
*-------------------------

*-------------------------
METHOD selprinterx()
*-------------------------

*-------------------------
METHOD getdefprinterx() BLOCK {|| NIL }
*-------------------------

*-------------------------
METHOD setcolorx() BLOCK {|| NIL }
*-------------------------

*-------------------------
METHOD setpreviewsizex() BLOCK {|| NIL }
*-------------------------

*-------------------------
METHOD printroundrectanglex() BLOCK {|| NIL }
*-------------------------

*-------------------------
method condendosx()
*-------------------------

*-------------------------
method normaldosx()
*-------------------------

*-------------------------
METHOD setunits()   // mm o rowcol , mm por renglon
*-------------------------

ENDCLASS


*-------------------------
METHOD initx() CLASS TRTFPRINT
*-------------------------
::impreview:=.F.
::cprintlibrary:="RTFPRINT"
RETURN self

*-------------------------
METHOD begindocx(cdoc) CLASS TRTFPRINT
*-------------------------
local   MARGENSUP:=LTRIM(STR(ROUND(15*56.7,0)))
local   MARGENINF:=LTRIM(STR(ROUND(15*56.7,0)))
local   MARGENIZQ:=LTRIM(STR(ROUND(10*56.7,0)))
local   MARGENDER:=LTRIM(STR(ROUND(10*56.7,0)))

////Empty( cdoc )

Default cDoc to "List"

AADD(oPrintRTF1,"{\rtf1\ansi\ansicpg1252\uc1 \deff0\deflang3082\deflangfe3082{\fonttbl{\f0\froman\fcharset0\fprq2{\*\panose 02020603050405020304}Times New Roman;}{\f2\fmodern\fcharset0\fprq1{\*\panose 02070309020205020404}Courier New;}")
AADD(oPrintRTF1,"{\f106\froman\fcharset238\fprq2 Times New Roman CE;}{\f107\froman\fcharset204\fprq2 Times New Roman Cyr;}{\f109\froman\fcharset161\fprq2 Times New Roman Greek;}{\f110\froman\fcharset162\fprq2 Times New Roman Tur;}")
AADD(oPrintRTF1,"{\f111\froman\fcharset177\fprq2 Times New Roman (Hebrew);}{\f112\froman\fcharset178\fprq2 Times New Roman (Arabic);}{\f113\froman\fcharset186\fprq2 Times New Roman Baltic;}{\f122\fmodern\fcharset238\fprq1 Courier New CE;}")
AADD(oPrintRTF1,"{\f123\fmodern\fcharset204\fprq1 Courier New Cyr;}{\f125\fmodern\fcharset161\fprq1 Courier New Greek;}{\f126\fmodern\fcharset162\fprq1 Courier New Tur;}{\f127\fmodern\fcharset177\fprq1 Courier New (Hebrew);}")
AADD(oPrintRTF1,"{\f128\fmodern\fcharset178\fprq1 Courier New (Arabic);}{\f129\fmodern\fcharset186\fprq1 Courier New Baltic;}}{\colortbl;\red0\green0\blue0;\red0\green0\blue255;\red0\green255\blue255;\red0\green255\blue0;\red255\green0\blue255;\red255\green0\blue0;")
AADD(oPrintRTF1,"\red255\green255\blue0;\red255\green255\blue255;\red0\green0\blue128;\red0\green128\blue128;\red0\green128\blue0;\red128\green0\blue128;\red128\green0\blue0;\red128\green128\blue0;\red128\green128\blue128;\red192\green192\blue192;}{\stylesheet{")
AADD(oPrintRTF1,"\ql \li0\ri0\widctlpar\faauto\adjustright\rin0\lin0\itap0 \fs20\lang3082\langfe3082\cgrid\langnp3082\langfenp3082 \snext0 Normal;}{\*\cs10 \additive Default Paragraph Font;}}{\info{\author nobody }{\operator Jose Miguel}")
AADD(oPrintRTF1,"{\creatim\yr2000\mo12\dy29\hr17\min26}{\revtim\yr2002\mo3\dy6\hr9\min32}{\printim\yr2002\mo3\dy4\hr16\min32}{\version10}{\edmins16}{\nofpages1}{\nofwords167}{\nofchars954}{\*\company xyz}{\nofcharsws0}{\vern8249}}")
*AADD(oPrintRTF1,"\paperw11907\paperh16840\margl284\margr284\margt1134\margb1134 \widowctrl\ftnbj\aenddoc\hyphhotz425\noxlattoyen\expshrtn\noultrlspc\dntblnsbdb\nospaceforul\hyphcaps0\horzdoc\dghspace120\dgvspace120\dghorigin1701\dgvorigin1984\dghshow0\dgvshow3")
AADD(oPrintRTF1,IF(oPrintRTF3=.T.,"\paperw16840\paperh11907","\paperw11907\paperh16840")+ ;
"\margl"+MARGENIZQ+"\margr"+MARGENDER+"\margt"+MARGENSUP+"\margb"+MARGENINF+ ;
" \widowctrl\ftnbj\aenddoc\hyphhotz425\noxlattoyen\expshrtn\noultrlspc\dntblnsbdb\nospaceforul\hyphcaps0\horzdoc\dghspace120\dgvspace120\dghorigin1701\dgvorigin1984\dghshow0\dgvshow3")
AADD(oPrintRTF1,"\jcompress\viewkind1\viewscale80\nolnhtadjtbl \fet0\sectd \psz9\linex0\headery851\footery851\colsx709\sectdefaultcl {\*\pnseclvl1\pnucrm\pnstart1\pnindent720\pnhang{\pntxta .}}{\*\pnseclvl2\pnucltr\pnstart1\pnindent720\pnhang{\pntxta .}}{\*\pnseclvl3")
AADD(oPrintRTF1,"\pndec\pnstart1\pnindent720\pnhang{\pntxta .}}{\*\pnseclvl4\pnlcltr\pnstart1\pnindent720\pnhang{\pntxta )}}{\*\pnseclvl5\pndec\pnstart1\pnindent720\pnhang{\pntxtb (}{\pntxta )}}{\*\pnseclvl6\pnlcltr\pnstart1\pnindent720\pnhang{\pntxtb (}{\pntxta )}}")
AADD(oPrintRTF1,"{\*\pnseclvl7\pnlcrm\pnstart1\pnindent720\pnhang{\pntxtb (}{\pntxta )}}{\*\pnseclvl8\pnlcltr\pnstart1\pnindent720\pnhang{\pntxtb (}{\pntxta )}}{\*\pnseclvl9\pnlcrm\pnstart1\pnindent720\pnhang{\pntxtb (}{\pntxta )}}\pard\plain ")
AADD(oPrintRTF1,"\qj \li0\ri0\nowidctlpar\faauto\adjustright\rin0\lin0\itap0 \fs20\lang3082\langfe3082\cgrid\langnp3082\langfenp3082")
IF ::cunits="MM"
   AADD(oPrintRTF1,"{\b\f0\lang1034\langfe3082\cgrid0\langnp1034")
ELSE
   AADD(oPrintRTF1,"{\b\f2\lang1034\langfe3082\cgrid0\langnp1034")
ENDIF

RETURN self


*-------------------------
METHOD enddocx() CLASS TRTFPRINT
*-------------------------
local nTRTFPRINT
private rutaficrtf1
IF RIGHT(oPrintRTF1[LEN(oPrintRTF1)],6)=" \page"
   oPrintRTF1[LEN(oPrintRTF1)]:=LEFT(oPrintRTF1[LEN(oPrintRTF1)] , LEN(oPrintRTF1[LEN(oPrintRTF1)])-6 )
ENDIF
AADD(oPrintRTF1,"\par }}")
RUTAFICRTF1:=GetmydocumentsFolder()
SET PRINTER TO &RUTAFICRTF1\printer.RTF
SET DEVICE TO PRINTER
SETPRC(0,0)
FOR nTRTFPRINT=1 TO LEN(oPrintRTF1)
@ PROW(),PCOL() SAY oPrintRTF1[nTRTFPRINT]
@ PROW()+1,0 SAY ""
NEXT
SET DEVICE TO SCREEN
SET PRINTER TO
RELEASE oPrintRTF1,oPrintRTF2,oPrintRTF3
IF ShellExecute(0, "open", "rundll32.exe", "url.dll,FileProtocolHandler "+ RUTAFICRTF1 + "\Printer.rtf", ,1) <=32
         MSGINFO("RTF Extension not asociated"+CHR(13)+CHR(13)+ ;
         "File saved in:"+CHR(13)+rutaficrtf1+"\printer.rtf")
ENDIF
RETURN self


*-------------------------
METHOD beginpagex() CLASS TRTFPRINT
*-------------------------
RETURN self

*-------------------------
METHOD endpagex() CLASS TRTFPRINT
*-------------------------
local milinea,nTRTFPRINT1,nTRTFPRINT2
ASORT(::alincelda,,, { |x, y| STR(x[1])+STR(x[2]) < STR(y[1])+STR(y[2]) })
MiLinea:=0
FOR nTRTFPRINT1=1 TO LEN(::alincelda)
    IF MiLinea<::alincelda[nTRTFPRINT1,1]
       DO WHILE MiLinea<::alincelda[nTRTFPRINT1,1]
          AADD(oPrintRTF1,"\par ")
          MiLinea++
       ENDDO
       IF ::cunits="MM"
          oPrintRTF1[LEN(oPrintRTF1)]:=oPrintRTF1[LEN(oPrintRTF1)]+"}\pard \qj \li0\ri0\nowidctlpar"
          FOR nTRTFPRINT2=1 TO LEN(::alincelda)
              IF ::alincelda[nTRTFPRINT2,1]=::alincelda[nTRTFPRINT1,1]
              do case
              case ::alincelda[nTRTFPRINT2,5]="R"
              oPrintRTF1[LEN(oPrintRTF1)]:=oPrintRTF1[LEN(oPrintRTF1)]+"\tqr"+"\tx"+LTRIM(STR(ROUND((::alincelda[nTRTFPRINT2,2]-10)*56.7,0)))
              case ::alincelda[nTRTFPRINT2,5]="C"
              oPrintRTF1[LEN(oPrintRTF1)]:=oPrintRTF1[LEN(oPrintRTF1)]+"\tqc"+"\tx"+LTRIM(STR(ROUND((::alincelda[nTRTFPRINT2,2]-10)*56.7,0)))
              otherwise
              oPrintRTF1[LEN(oPrintRTF1)]:=oPrintRTF1[LEN(oPrintRTF1)]+"\tql"+"\tx"+LTRIM(STR(ROUND((::alincelda[nTRTFPRINT2,2]-10)*56.7,0)))
              endcase
              ENDIF
         NEXT
         oPrintRTF1[LEN(oPrintRTF1)]:=oPrintRTF1[LEN(oPrintRTF1)]+"\faauto\adjustright\rin0\lin0\itap0 {"
      ENDIF
    ENDIF
IF oPrintRTF2<>::alincelda[nTRTFPRINT1,4]
   oPrintRTF2:=::alincelda[nTRTFPRINT1,4]
   DO CASE
   CASE oPrintRTF2<=8
   IF ::cunits="MM"
      oPrintRTF1[LEN(oPrintRTF1)]:=oPrintRTF1[LEN(oPrintRTF1)]+"}{\b\f0\fs16\lang1034\langfe3082\cgrid0\langnp1034"
   ELSE
      oPrintRTF1[LEN(oPrintRTF1)]:=oPrintRTF1[LEN(oPrintRTF1)]+"}{\b\f2\fs16\lang1034\langfe3082\cgrid0\langnp1034"
   ENDIF
   CASE oPrintRTF2>=9 .AND. oPrintRTF2<=10
   IF ::cunits="MM"
      oPrintRTF1[LEN(oPrintRTF1)]:=oPrintRTF1[LEN(oPrintRTF1)]+"}{\b\f0\lang1034\langfe3082\cgrid0\langnp1034"
   ELSE
      oPrintRTF1[LEN(oPrintRTF1)]:=oPrintRTF1[LEN(oPrintRTF1)]+"}{\b\f2\lang1034\langfe3082\cgrid0\langnp1034"
   ENDIF
   CASE oPrintRTF2>=11 .AND. oPrintRTF2<=12
   IF ::cunits="MM"
   oPrintRTF1[LEN(oPrintRTF1)]:=oPrintRTF1[LEN(oPrintRTF1)]+"}{\b\f0\fs24\lang1034\langfe3082\cgrid\langnp1034"
   ELSE
   oPrintRTF1[LEN(oPrintRTF1)]:=oPrintRTF1[LEN(oPrintRTF1)]+"}{\b\f2\fs24\lang1034\langfe3082\cgrid\langnp1034"
   ENDIF
   CASE oPrintRTF2>=13
   IF ::cunits="MM"
   oPrintRTF1[LEN(oPrintRTF1)]:=oPrintRTF1[LEN(oPrintRTF1)]+"}{\b\f0\fs28\lang1034\langfe3082\cgrid\langnp1034"
   ELSE
   oPrintRTF1[LEN(oPrintRTF1)]:=oPrintRTF1[LEN(oPrintRTF1)]+"}{\b\f2\fs28\lang1034\langfe3082\cgrid\langnp1034"
   ENDIF
   ENDCASE
ENDIF

IF ::cunits="MM"
   oPrintRTF1[LEN(oPrintRTF1)]:=oPrintRTF1[LEN(oPrintRTF1)]+"\tab "
ENDIF

oPrintRTF1[LEN(oPrintRTF1)]:=oPrintRTF1[LEN(oPrintRTF1)]+::alincelda[nTRTFPRINT1,3]
NEXT
oPrintRTF1[LEN(oPrintRTF1)]:=oPrintRTF1[LEN(oPrintRTF1)]+" \page"
::alincelda:={}
RETURN self


*-------------------------
METHOD setunits(cunitsx,cunitslinx) CLASS TRTFPRINT
*-------------------------
IF cunitsx="MM"
   ::cunits:="MM"
ELSE
   ::cunits:="ROWCOL"
ENDIF 
IF cunitslinx=NIL
   ::nunitslin:=1
ELSE
   ::nunitslin:=cunitslinx
ENDIF 
RETURN self


*-------------------------
METHOD printdatax(nlin,ncol,data,cfont,nsize,lbold,acolor,calign,nlen,ctext,lItalic) CLASS TRTFPRINT
*-------------------------
Empty( data )
Empty( cfont )
Empty( lbold )
Empty( acolor )
Empty( nlen )
Empty( lItalic )
nlin++
IF ::nunitslin>1
   nlin:=round(nlin/::nunitslin,0)
ENDIF 
IF ::cunits="MM"
   ctext:=ALLTRIM(ctext)
ENDIF
AADD(::alincelda,{nlin,ncol,space(::nlmargin)+ctext,nsize,calign})
RETURN self


*-------------------------
METHOD printlinex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TRTFPRINT
*-------------------------
Empty( nlin )
Empty( ncol )
Empty( nlinf )
Empty( ncolf )
Empty( atcolor )
Empty( ntwpen )
RETURN self


*-------------------------
METHOD selprinterx( lselect , lpreview, llandscape , npapersize ,cprinterx) CLASS TRTFPRINT
*-------------------------
PUBLIC oPrintRTF1,oPrintRTF2,oPrintRTF3
Empty( lselect )
Empty( lpreview )
Empty( npapersize )
Empty( cprinterx )
oPrintRTF1:={}
oPrintRTF2:=10
oPrintRTF3:=llandscape
RETURN self


*-------------------------
METHOD condendosx() CLASS TRTFPRINT
*-------------------------
RETURN self


*-------------------------
METHOD normaldosx() CLASS TRTFPRINT
*-------------------------
RETURN self


//////////////////////// CSV

CREATE CLASS TCSVPRINT FROM TPRINTBASE


*-------------------------
METHOD initx()
*-------------------------

*-------------------------
METHOD begindocx()
*-------------------------

*-------------------------
METHOD enddocx()
*-------------------------

*-------------------------
METHOD beginpagex()
*-------------------------

*-------------------------
METHOD endpagex()
*-------------------------

*-------------------------
METHOD releasex() BLOCK { || NIL }
*-------------------------

*-------------------------
METHOD printdatax()
*-------------------------

*-------------------------
METHOD printimage() BLOCK { || NIL }
*-------------------------

*-------------------------
METHOD printlinex()
*-------------------------

*-------------------------
METHOD printrectanglex BLOCK { || NIL }
*-------------------------

*-------------------------
METHOD selprinterx()
*-------------------------

*-------------------------
METHOD getdefprinterx() BLOCK { || NIL }
*-------------------------

*-------------------------
METHOD setcolorx() BLOCK { || NIL }
*-------------------------

*-------------------------
METHOD setpreviewsizex() BLOCK { || NIL }
*-------------------------

*-------------------------
METHOD printroundrectanglex() BLOCK { || NIL }
*-------------------------

*-------------------------
method condendosx()
*-------------------------

*-------------------------
method normaldosx()
*-------------------------

*-------------------------
METHOD setunits()   // mm o rowcol , mm por renglon
*-------------------------

ENDCLASS


*-------------------------
METHOD initx() CLASS TCSVPRINT
*-------------------------
::impreview:=.F.
::cprintlibrary:="CSVPRINT"
RETURN self


*-------------------------
METHOD begindocx(cdoc) CLASS TCSVPRINT
*-------------------------
Default cDoc to "List"
RETURN self


*-------------------------
METHOD enddocx() CLASS TCSVPRINT
*-------------------------
RUTAFICRTF1:=GetmydocumentsFolder()
SET PRINTER TO &RUTAFICRTF1\printer.CSV
SET DEVICE TO PRINTER
SETPRC(0,0)
FOR nTCSVPRINT=1 TO LEN(oPrintCSV1)
@ PROW(),PCOL() SAY oPrintCSV1[nTCSVPRINT]
@ PROW()+1,0 SAY ""
NEXT
SET DEVICE TO SCREEN
SET PRINTER TO
RELEASE oPrintCSV1,oPrintCSV2,oPrintCSV3

IF ShellExecute(0, "open", "rundll32.exe", "url.dll,FileProtocolHandler "+ RUTAFICRTF1 + "\Printer.csv", ,1) <=32
         MSGINFO("CSV Extension not asociated"+CHR(13)+CHR(13)+ ;
         "File saved in:"+CHR(13)+rutaficrtf1+"\printer.csv")
ENDIF
RETURN self


*-------------------------
METHOD beginpagex() CLASS TCSVPRINT
*-------------------------
RETURN self


*-------------------------
METHOD endpagex() CLASS TCSVPRINT
*-------------------------
ASORT(::alincelda,,, { |x, y| STR(x[1])+STR(x[2]) < STR(y[1])+STR(y[2]) })
MiLinea1:=0
MiLinea2:=0
FOR nTCSVPRINT1=1 TO LEN(::alincelda)
IF MiLinea1<::alincelda[nTCSVPRINT1,1]
   DO WHILE MiLinea1<::alincelda[nTCSVPRINT1,1]
      AADD(oPrintCSV1,"")
      MiLinea1++
   ENDDO
ENDIF

   IF LEN(oPrintCSV1[LEN(oPrintCSV1)])=0
      oPrintCSV1[LEN(oPrintCSV1)]:=::alincelda[nTCSVPRINT1,3]
    ELSE
      oPrintCSV1[LEN(oPrintCSV1)]:=oPrintCSV1[LEN(oPrintCSV1)]+";"+STRTRAN(::alincelda[nTCSVPRINT1,3],";",",")
    ENDIF

NEXT
::alincelda:={}
RETURN self

*-------------------------
METHOD setunits(cunitsx,cunitslinx) CLASS TCSVPRINT
*-------------------------
IF cunitsx="MM"
   ::cunits:="MM"
ELSE
   ::cunits:="ROWCOL"
ENDIF 
IF cunitslinx=NIL
   ::nunitslin:=1
ELSE
   ::nunitslin:=cunitslinx
ENDIF 
RETURN self


*-------------------------
METHOD printdatax(nlin,ncol,data,cfont,nsize,lbold,acolor,calign,nlen,ctext,lItalic) CLASS TCSVPRINT
*-------------------------
Empty( data )
Empty( cfont )
Empty( lbold )
Empty( acolor )
Empty( nlen )
Empty( lItalic )

nlin++
IF ::nunitslin>1
   nlin:=round(nlin/::nunitslin,0)
ENDIF 
IF ::cunits="MM"
   ctext:=ALLTRIM(ctext)
ENDIF
AADD(::alincelda,{nlin,ncol,space(::nlmargin)+ctext,nsize,calign})
RETURN self


*-------------------------
METHOD printlinex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TCSVPRINT
*-------------------------
Empty( nlin )
Empty( ncol )
Empty( nlinf )
Empty( ncolf )
Empty( atcolor )
Empty( ntwpen )
*-------------------------
RETURN self


*-------------------------
METHOD selprinterx( lselect , lpreview, llandscape , npapersize ,cprinterx) CLASS TCSVPRINT
*-------------------------
PUBLIC oPrintCSV1,oPrintCSV2,oPrintCSV3
Empty( lselect )
Empty( lpreview )
Empty( npapersize )
Empty( cprinterx )
oPrintCSV1:={}
oPrintCSV2:=10
oPrintCSV3:=llandscape
RETURN self


*-------------------------
METHOD condendosx() CLASS TCSVPRINT
*-------------------------
RETURN self


*-------------------------
METHOD normaldosx() CLASS TCSVPRINT
*-------------------------
RETURN self

*---------------------------------------
CREATE CLASS TPDFPRINT FROM TPRINTBASE

/////PRIVATE:
DATA oPDF        as object                     //el objeto pdf
DATA cDocument   as character init ""          //nombre del documento
DATA cPageSize   as character init ""          //tamaño de pagina.
DATA cPageOrient as character init ""          //P = portrait, L = Landscape
DATA nFontType   as numeric   init 1           //tipo de fuente(normal=0 o negrita=1)
DATA lPreview    as logical   init .f.         //indica si abrimos el pdf al finalizar
DATA aPaper      as array     init {} hidden   //array con los tipos de papel soportados por la clase pdf.


METHOD initx()
METHOD begindocx()
METHOD enddocx()
METHOD beginpagex()
METHOD endpagex()
METHOD releasex()
METHOD printdatax()
METHOD printimagex()
METHOD printlinex()
METHOD printrectanglex
METHOD selprinterx()
METHOD getdefprinterx()
METHOD setcolorx()
METHOD setpreviewsizex()
METHOD printroundrectanglex()

ENDCLASS
*---------------------------------------

*-------------------------
METHOD INITx() CLASS TPDFPRINT
*-------------------------

*-----Estos son los unicos tipos de papel que soporta-------*
aadd(::aPaper,{DMPAPER_LETTER      , "LETTER"   })
aadd(::aPaper,{DMPAPER_LEGAL       , "LEGAL"    })
aadd(::aPaper,{DMPAPER_TABLOID     , "LEDGER"   })
aadd(::aPaper,{DMPAPER_EXECUTIVE   , "EXECUTIVE"})
aadd(::aPaper,{DMPAPER_A3          , "A3"       })
aadd(::aPaper,{DMPAPER_A4          , "A4"       })
aadd(::aPaper,{DMPAPER_ENV_10      , "COM10"    })
aadd(::aPaper,{DMPAPER_B4          , "JIS B4"   })
aadd(::aPaper,{DMPAPER_B5          , "JIS B5"   })
aadd(::aPaper,{DMPAPER_P32K        , "JPOST"    })
aadd(::aPaper,{DMPAPER_ENV_C5      , "C5"       })
aadd(::aPaper,{DMPAPER_ENV_DL      , "DL"       })
aadd(::aPaper,{DMPAPER_ENV_B5      , "B5"       })
aadd(::aPaper,{DMPAPER_ENV_MONARCH , "MONARCH"  })

::cprintlibrary:="PDFPRINT"

RETURN self


*-------------------------
METHOD BEGINDOCx () CLASS TPDFPRINT
*-------------------------
local cpdfname:= Getmydocumentsfolder()+"\pdfprint.pdf"
::oPdf := TPDF():init(cpdfname)
RETURN self


*-------------------------
METHOD ENDDOCx() CLASS TPDFPRINT
*-------------------------
local cMydoc := getmydocumentsfolder()
::oPdf:Close()
IF ShellExecute(0, "open", "rundll32.exe", "url.dll,FileProtocolHandler "+ cMydoc+ "\Pdfprint.pdf", ,1) <=32
     MSGINFO("html Extension not asociated"+CHR(13)+CHR(13)+ ;
     "File saved in:"+CHR(13)+cMydoc+"\pdfprint.pdf")
ENDIF
RETURN self


*-------------------------
METHOD BEGINPAGEx() CLASS TPDFPRINT
*-------------------------
::oPdf:NewPage( ::cPageSize, ::cPageOrient, , ::cFontName, ::nFontType, ::nFontSize )
RETURN self


*-------------------------
METHOD ENDPAGEx() CLASS TPDFPRINT
*-------------------------
RETURN self


*-------------------------
METHOD RELEASEx() CLASS TPDFPRINT
*-------------------------
RETURN self


*-------------------------
METHOD PRINTDATAx(nlin,ncol,data,cfont,nsize,lbold,acolor,calign,nlen,ctext,lItalic ) CLASS TPDFPRINT
*-------------------------
local nType   := 0
local nlength := 0
local cColor  := Chr(253)
local I

Default cFont to ::cFontName
Default nSize to ::nFontSize
////Default lBold to .f.
DEFAULT aColor to ::acolor


empty( data )
empty( calign )
empty( nlen )

For Each I in aColor
    cColor += Chr(I)
Next

If lBold
   nType := 1  ///  bold
Else
   nType := 0  ///  normal
Endif

If lItalic
   IF lBold
       ntype:=3   /// bold and italic
   ELSE
      ntype:= 2   /// only italic
   ENDIF 
Endif


IF "roman"$lower(cFont)
   cFont:="TIMES"
ELSE
   IF "helvetica"$lower(cfont) .or. "arial"$lower(cfont)
      cFont:="HELVETICA"
   ELSE
      cFont:="COURIER"
   ENDIF 
ENDIF 


::oPdf:SetFont(cFont, nType, nSize)


IF ::cunits == "MM"
   nlin += 3
Endif

cText:=cColor + cText

IF ::cunits == "MM"
   ::oPdf:AtSay( ctext, nlin, nCol, "M" )
ELSE
   ::oPdf:AtSay( ctext, nlin*::nmver+::nvfij , nCol*::nmhor+ ::nhfij*2, "M")
ENDIF 
RETURN self


*-------------------------
METHOD printimagex(nlin,ncol,nlinf,ncolf,cimage) CLASS TPDFPRINT
*-------------------------

IF HB_IsString(cImage)
   cImage := Upper(cImage)
 *----Solo soporta jpg y tiff como formatos de imagen------*
   IF At(".JPG",cImage) = 0 .and. At(".TIF",cImage) = 0
      Return Self
   Endif
ELSE
  Return Self
ENDIF

*----Ajustamos las medidas al hbprinter-----*
nlinf := nlinf - nlin
ncolf := nColf - nCol

IF ::cunits == "MM"
   ::oPdf:Image( cImage, nlin,ncol,"M",nlinf,ncolf)
ELSE
   ::oPdf:Image( cImage, nlin*::nmver+::nvfij,ncol*::nmhor+ ::nhfij*2,"M",nlinf*::nmver+::nvfij,ncolf*::nmhor+ ::nhfij*2)
ENDIF 
RETURN self


*-------------------------
METHOD printlinex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TPDFPRINT
*-------------------------
DEFAULT atColor to ::acolor
IF nlin = nlinf .or. ncol = ncolf
   ::printrectanglex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen /2)
ENDIF 
RETURN self

*-------------------------
METHOD printrectanglex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TPDFPRINT
*-------------------------
local cColor  := ""
local I
local nvval  := 3.04
local nhval  := 3.00
DEFAULT atColor to ::acolor

Default ntwpen to ::nwpen

For Each I in atColor
    cColor += Chr(I)
Next

IF ::cunits=="MM"
      ::oPdf:Box1(nlin*nvVal,ncol*nhval,nlinf*nvval,ncolf*nhval,ntwpen*2,cColor)
ELSE
   ::oPdf:Box1(nlin*nvVal*::nmver+::nvfij,ncol*nhval*::nmhor+ ::nhfij*2,nlinf*nvval*::nmver+::nvfij,ncolf*nhval*::nmhor+ ::nhfij*2,ntwpen*2,cColor)
ENDIF 

RETURN self

*-------------------------
METHOD selprinterx( lselect , lpreview, llandscape , npapersize ) CLASS TPDFPRINT
*-------------------------
local nPos := 0

Default lpreview to .f.
Default llandscape to .f.
Default npapersize to 0

empty( lselect )

/*lSelect no lo tomamos en cuenta aqui*/

*----Si se va a necesitar abrir el pdf al finalizar la generacion------*
::lPreview := lpreview
*----Establecemos la orientacion de la hoja-----*
::cPageOrient := IIF(lLandScape,"L","P")

*----Establecemos el tamaño del papel------*

nPos := aScan(::aPaper,{|x|x[1] = npapersize})

If nPos > 0
   ::cPageSize := ::aPaper[nPos][2]
Else
   ::cPageSize := "LETTER"
Endif

/*cprinterx no lo tomamos en cuenta aqui*/

RETURN self


*-------------------------
METHOD getdefprinterx() CLASS TPDFPRINT
*-------------------------
local cdefprinter
RETURN cdefprinter


*-------------------------
METHOD setcolorx() CLASS TPDFPRINT
*-------------------------
RETURN self


*-------------------------
METHOD setpreviewsizex( /* ntam */) CLASS TPDFPRINT
*-------------------------
RETURN self


*-------------------------
METHOD printroundrectanglex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TPDFPRINT
*-------------------------
/////*Que hace esto?  hace un rectangulo con bordes redondeados pero como aqui no se puede va sin redondeo
   ::printrectanglex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen )
RETURN self


//////////////////////// CALC Contribucion de Jose Miguel con ajustes CVC

CREATE CLASS TCALCPRINT FROM TPRINTBASE

    DATA oServiceManager INIT nil
    DATA oDesktop INIT nil
    DATA oDocument INIT nil
    DATA oSchedule INIT nil
    DATA oSheet INIT nil
    DATA oCell INIT nil
    DATA oColums INIT nil
    DATA oColumn INIT nil

*-------------------------
METHOD initx()
*-------------------------

*-------------------------
METHOD begindocx()
*-------------------------

*-------------------------
METHOD enddocx()
*-------------------------

*-------------------------
METHOD beginpagex()
*-------------------------

*-------------------------
METHOD endpagex()
*-------------------------

*-------------------------
METHOD releasex()
*-------------------------

*-------------------------
METHOD printdatax()
*-------------------------

*-------------------------
METHOD printimage() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD printlinex() BLOCK {|| NIL }
*-------------------------

*-------------------------
METHOD printrectanglex BLOCK { || nil }
*-------------------------

*-------------------------
METHOD selprinterx()
*-------------------------

*-------------------------
METHOD getdefprinterx() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD setcolorx() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD setpreviewsizex() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD printroundrectanglex() BLOCK { || nil }
*-------------------------

*-------------------------
method condendosx() BLOCK {|| NIL }
*-------------------------

*-------------------------
method normaldosx() BLOCK {|| NIL }
*-------------------------

*-------------------------
METHOD setunits()   // mm o rowcol , mm por renglon
*-------------------------

ENDCLASS


*-------------------------
METHOD initx() CLASS TCALCPRINT
*-------------------------
::impreview:=.F.
::cprintlibrary:="CALCPRINT"
return self

*-------------------------
METHOD selprinterx( lselect , lpreview, llandscape , npapersize ,cprinterx) CLASS TCALCPRINT
*-------------------------
empty(lselect)
empty(lpreview)
empty(llandscape)
empty(npapersize)
empty(cprinterx)

::oServiceManager := TOleAuto():New("com.sun.star.ServiceManager")
::oDesktop := ::oServiceManager:createInstance("com.sun.star.frame.Desktop")
IF ::oDesktop = NIL
   MsgStop('OpenOficce Calc no encontrado','error')
   RETURN Nil
ENDIF
return self

*-------------------------
METHOD begindocx() CLASS TCALCPRINT
*-------------------------
::oDocument := ::oDesktop:loadComponentFromURL("private:factory/scalc","_blank", 0, {})
::oSchedule := ::oDocument:GetSheets()
::oSheet := ::oSchedule:GetByIndex(0)
*::oSheet:CharFontName := ::cfontname
*::oSheet:CharHeight   := ::nfontsize
return self


*-------------------------
METHOD enddocx() CLASS TCALCPRINT
*-------------------------
::oSheet:getColumns():setPropertyValue("OptimalWidth", .T.)
RETURN self


*-------------------------
METHOD releasex() CLASS TCALCPRINT
*-------------------------
   ::oServiceManager := nil
   ::oDesktop := nil
   ::oDocument := nil
   ::oSchedule := nil
   ::oSheet := nil
   ::oCell := nil
   ::oColums := nil
   ::oColumn := nil
RETURN self


*-------------------------
METHOD beginpagex() CLASS TCALCPRINT
*-------------------------
return self


*-------------------------
METHOD endpagex() CLASS TCALCPRINT
*-------------------------
local MiLinea,nTEXECLPRINT1,MiCol2
ASORT(::alincelda,,, { |x, y| STR(x[1])+STR(x[2]) < STR(y[1])+STR(y[2]) })
IF ::nlinpag=0 .AND. LEN(::alincelda)>0
   ::cfontname:=::alincelda[1,6]
   ::nfontsize:=::alincelda[1,4]
   ::oSheet:CharFontName := ::cfontname
   ::oSheet:CharHeight   := ::nfontsize
ENDIF
MiLinea:=0
MiCol2:=1
FOR nTEXECLPRINT1=1 TO LEN(::alincelda)
   DO WHILE MiLinea<::alincelda[nTEXECLPRINT1,1]
      MiLinea++
      MiCol2:=1
   ENDDO
   ::oCell:=::oSheet:getCellByPosition(MiCol2-1,::nlinpag+MiLinea) // columna,linea
   IF VALTYPE(::alincelda[nTEXECLPRINT1,3])="N"
      ::oCell:SetValue(::alincelda[nTEXECLPRINT1,3])
   ELSE
      ::oCell:SetString(::alincelda[nTEXECLPRINT1,3])
   ENDIF
   IF ::alincelda[nTEXECLPRINT1,6]<>::cfontname
      ::oCell:CharFontName:=::alincelda[nTEXECLPRINT1,6]
   ENDIF
   IF ::alincelda[nTEXECLPRINT1,4]<>::nfontsize
      ::oCell:CharHeight  :=::alincelda[nTEXECLPRINT1,4]
   ENDIF
   IF ::alincelda[nTEXECLPRINT1,7]=.T.
      ::oCell:CharWeight=150
   ENDIF
   do case
   case ::alincelda[nTEXECLPRINT1,5]="R"
      ::oCell:HoriJustify:=3
   case ::alincelda[nTEXECLPRINT1,5]="C"
      ::oCell:HoriJustify:=2
   endcase
   aMiColor:=::alincelda[nTEXECLPRINT1,8]
   IF aMiColor[3]<>0 .OR. aMiColor[2]<>0 .OR. aMiColor[1]<>0
      ::oCell:CharColor:=RGB(aMiColor[3],aMiColor[2],aMiColor[1])
   ENDIF
   MiCol2++
NEXT
::nlinpag:= ::nlinpag + MiLinea+1
::alincelda:={}
return self


*-------------------------
METHOD setunits(cunitsx,cunitslinx) CLASS TCALCPRINT
*-------------------------
if cunitsx="MM"
   ::cunits:="MM"
else
   ::cunits:="ROWCOL"
endif
if cunitslinx=NIL
   ::nunitslin:=1
else
   ::nunitslin:=cunitslinx
endif
RETURN self


*-------------------------
METHOD printdatax(nlin,ncol,data,cfont,nsize,lbold,acolor,calign,nlen,ctext,nangle) CLASS TCALCPRINT
*-------------------------
empty(nangle)
empty(ncol)
empty(data)
empty(acolor)
empty(nlen)
if ::nunitslin>1
   nlin:=round(nlin/::nunitslin,0)
endif
IF ::cunits="MM"
   ctext:=ALLTRIM(ctext)
ENDIF
AADD(::alincelda,{nlin,ncol,ctext,nsize,calign,cfont,lbold,acolor})
return self


