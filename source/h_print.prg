/*
* $Id: h_print.prg,v 1.34 2006-08-26 16:45:53 declan2005 Exp $
*/

#include 'hbclass.ch'
#include 'common.ch'
#include 'oohg.ch'
#include 'miniprint.ch'
#include 'winprint.ch'

memvar _OOHG_PRINTLIBRARY
memvar _HMG_PRINTER_APRINTERPROPERTIES
memvar _HMG_PRINTER_HDC
memvar _HMG_PRINTER_COPIES
memvar _HMG_PRINTER_COLLATE
memvar _HMG_PRINTER_PREVIEW
memvar _HMG_PRINTER_TIMESTAMP
memvar _HMG_PRINTER_NAME
memvar _HMG_PRINTER_PAGECOUNT
memvar _HMG_PRINTER_HDC_BAK
memvar _OOHG_printer_docname
memvar oPrintexcel
memvar oPrinthoja
memvar oprintrtf1
memvar oprintrtf2
memvar oprintrtf3
memvar rutaficrtf1
memvar ntcsvprint
memvar ntcsvprint1
memvar oprintcsv1
memvar milinea1
memvar milinea2
memvar oprintcsv2
memvar oprintcsv3
////memvar sicvar

*-------------------------
FUNCTION TPrint( clibx )
*-------------------------
LOCAL o_Print_
if clibx=NIL
   if type("_OOHG_printlibrary")="C"
      if _OOHG_printlibrary="HBPRINTER"
         o_print_:=thbprinter()
      elseif _OOHG_printlibrary="MINIPRINT"
         o_print_:=tminiprint()
      elseif _OOHG_printlibrary="DOSPRINT"
         o_print_:=tdosprint()
      elseif _OOHG_printlibrary="EXCELPRINT"
         o_print_:=texcelprint()
      elseif _OOHG_printlibrary="RTFPRINT"
         o_print_:=trtfprint()
      elseif _OOHG_printlibrary="CSVPRINT"
         o_print_:=tcsvprint()
      else
         o_print_:=thbprinter()
      endif
   else
       o_print_:=tminiprint()
      _OOHG_printlibrary="MINIPRINT"
   endif
else
   if valtype(clibx)="C"
      if clibx="HBPRINTER"
         o_print_:=thbprinter()
      elseif clibx="MINIPRINT"
         o_print_:=tminiprint()
      elseif clibx="DOSPRINT"
         o_print_:=tdosprint()
      elseif clibx="EXCELPRINT"
         o_print_:=texcelprint()
      elseif clibx="RTFPRINT"
         o_print_:=trtfprint()
      elseif clibx="CSVPRINT"
         o_print_:=tcsvprint()
      else
         o_print_:=tminiprint()
      endif
    else
      o_print_:=tminiprint()
      _OOHG_printlibrary="MINIPRINT"
    endif
endif
RETURN o_Print_


CREATE CLASS TPRINTBASE

DATA cprintlibrary      INIT "HBPRINTER" READONLY
DATA nmhor              INIT (10)/4.75   READONLY
DATA nmver              INIT (10)/2.45   READONLY
DATA nhfij              INIT (12/3.70)   READONLY
DATA nvfij              INIT (12/1.65)   READONLY
DATA cunits             INIT "ROWCOL"    READONLY
DATA cprinter           INIT ""          READONLY

DATA aprinters          INIT {}   READONLY
DATA aports             INIT {}   READONLY

DATA lprerror           INIT .F.  READONLY
DATA exit               INIT  .F. READONLY
DATA acolor             INIT {1,1,1}  READONLY
DATA cfontname          INIT "Courier New" READONLY
DATA nfontsize          INIT 10 READONLY
DATA nwpen              INIT 0.1   READONLY //// pen width
DATA tempfile           INIT gettempdir()+"T"+alltrim(str(int(hb_random(999999)),8))+".prn" READONLY
DATA impreview          INIT .F.  READONLY
DATA lwinhide           INIT .T.   READONLY
DATA cversion           INIT  "(oohg)V 1.6" READONLY
DATA cargo              INIT  .F.

DATA nlinpag            INIT 0            READONLY
DATA alincelda          INIT {}           READONLY
DATA nunitslin          INIT 1            READONLY

*-------------------------
METHOD init()
METHOD initx() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD begindoc()
METHOD begindocx() BLOCK { || nil }
*-------------------------
*-------------------------
METHOD enddoc()
METHOD enddocx() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD printdos()
METHOD printdosx() BLOCK { || nil }
*-------------------------
*-------------------------
METHOD beginpage()
METHOD beginpagex() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD condendos() BLOCK { || nil }
METHOD condendosx() BLOCK { || nil }
*-------------------------


*-------------------------
METHOD NORMALDOS() BLOCK { || nil }
METHOD normaldosx() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD endpage()
METHOD endpagex() BLOCK { || nil }
*-------------------------
*-------------------------
METHOD release()
METHOD releasex() BLOCK { || nil }
*-------------------------
*-------------------------
METHOD printdata()
METHOD printdatax() BLOCK { || nil }
*-------------------------
*-------------------------
METHOD printimage()
METHOD printimagex() BLOCK { || nil }
*-------------------------
*-------------------------
METHOD printline()
METHOD printlinex() BLOCK { || nil }
*-------------------------


*-------------------------
METHOD printrectangle()
METHOD printrectanglex() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD selprinter()
METHOD selprinterx() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD getdefprinter()
METHOD getdefprinterx() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD setcolor()
METHOD setcolorx() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD setpreviewsize()
METHOD setpreviewsizex() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD setunits()   ////// mm o rowcol
METHOD setunitsx() BLOCK { || nil }
*-------------------------

*-------------------------
METHOD printroundrectangle()
METHOD printroundrectanglex() BLOCK { || nil }
*-------------------------

METHOD version() INLINE ::cversion

ENDCLASS

*-------------------------

*-------------------------
METHOD setpreviewsize(ntam) CLASS TPRINTBASE
*-------------------------
if ntam=NIL .or. ntam>5
   ntam:=1
endif
::setpreviewsizex(ntam)
return self

*-------------------------
METHOD release() CLASS TPRINTBASE
*-------------------------
if ::exit
   return nil
endif
////setinteractiveclose(::cargo)
::releasex()
return nil

*-------------------------
METHOD init( ) CLASS TPRINTBASE
*-------------------------
if iswindowactive(_oohg_winreport)
   msgstop("Print preview pending, close first")
   ::exit:=.T.
   return nil
endif
Public _OOHG_printer_docname
::initx()
RETURN self

*-------------------------
METHOD selprinter( lselect , lpreview, llandscape , npapersize ,cprinterx, lhide,nres ) CLASS TPRINTBASE
*-------------------------
local lsucess := .T.
if ::exit
   ::lprerror:=.T.
   return nil
endif

if lhide#NIL
  ::lwinhide:=lhide
endif

SETPRC(0,0)
DEFAULT llandscape to .F.

::selprinterx( lselect , lpreview, llandscape , npapersize ,cprinterx, nres)
return self


*-------------------------
METHOD BEGINDOC(cdoc) CLASS TPRINTBASE
*-------------------------

DEFAULT cDoc to "ooHG printing"


DEFINE WINDOW _modalhide ;
AT 0,0 ;
WIDTH 0 HEIGHT 0 ;
TITLE cdoc MODAL NOSHOW NOSIZE NOSYSMENU NOCAPTION  ;

end window


DEFINE WINDOW _oohg_winreport ;
AT 0,0 ;
WIDTH 400 HEIGHT 120 ;
TITLE cdoc CHILD NOSIZE NOSYSMENU NOCAPTION ;

@ 5,5 frame myframe width 390 height 110

@ 15,195 IMAGE IMAGE_101 ;
picture 'hbprint_print'  ;
WIDTH 25  ;
HEIGHT 30 ;
STRETCH

@ 22,225 LABEL LABEL_101 VALUE '......' FONT "Courier New" SIZE 10

@ 55,10  label label_1 value cdoc WIDTH 300 HEIGHT 32 FONT "Courier New"

DEFINE TIMER TIMER_101  ;
INTERVAL 1000  ;
ACTION action_timer()

if .not. ::lwinhide
   _oohg_winreport.hide()
endif

end window
center window _oohg_winreport
activate window _modalhide NOWAIT
activate window _oohg_winreport NOWAIT

::begindocx(cdoc)
return self



*-------------------------
function action_timer()
*-------------------------
if iswindowdefined(_oohg_winreport)
   _oohg_winreport.label_1.fontbold:=IIF(_oohg_winreport.label_1.fontbold,.F.,.T.)
   _oohg_winreport.image_101.visible:=IIF(_oohg_winreport.label_1.fontbold,.T.,.F.)
endif
return nil

*-------------------------
METHOD ENDDOC() CLASS TPRINTBASE
*-------------------------
::enddocx()
_oohg_winreport.release()
_modalhide.release()
return self


*-------------------------
METHOD SETCOLOR(atColor) CLASS TPRINTBASE
*-------------------------
::acolor:=atColor
::setcolorx()
return self

*-------------------------
METHOD beginPAGE() CLASS TPRINTBASE
*-------------------------
::beginpagex()
return self

*-------------------------
METHOD ENDPAGE() CLASS TPRINTBASE
*-------------------------
::endpagex()
return self


*-------------------------
METHOD getdefprinter() CLASS TPRINTBASE
*-------------------------
RETURN ::getdefprinterx()

*-------------------------
METHOD setunits(cunitsx) CLASS TPRINTBASE
*-------------------------
if cunitsx="MM"
   ::cunits:="MM"
else
   ::cunits:="ROWCOL"
endif
RETURN nil

*-------------------------
METHOD printdata(nlin,ncol,data,cfont,nsize,lbold,acolor,calign,nlen) CLASS TPRINTBASE
*-------------------------
local ctext,cspace
do case
case valtype(data)=='C'
   ctext:=data
case valtype(data)=='N'
   ctext:=alltrim(str(data))
case valtype(data)=='D'
   ctext:=dtoc(data)
case valtype(data)=='L'
   ctext:= iif(data,'T','F')
case valtype(data)=='M'
   ctext:=data
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

DEFAULT cfont to ::cfontname

DEFAULT nsize to ::nfontsize

DEFAULT acolor to ::acolor

if ::cunits="MM"
   ::nmver:=1
   ::nvfij:=0
   ::nmhor:=1
   ::nhfij:=0
else
   ::nmhor  := (::nfontsize)/4.75
   ::nmver  := (::nfontsize)/2.45
   ::nvfij  := (12/1.65)
   ::nhfij  := (12/3.70)
endif

ctext:=cspace + ctext
::printdatax(nlin,ncol,data,cfont,nsize,lbold,acolor,calign,nlen,ctext)
return self


*-------------------------
METHOD printimage(nlin,ncol,nlinf,ncolf,cimage) CLASS TPRINTBASE
*-------------------------
DEFAULT nlin to 1

DEFAULT ncol to 1

DEFAULT cimage to ""

DEFAULT nlinf to 4

DEFAULT ncolf to 4

if ::cunits="MM"
   ::nmver:=1
   ::nvfij:=0
   ::nmhor:=1
   ::nhfij:=0
else
   ::nmhor  := (::nfontsize)/4.75
   ::nmver  := (::nfontsize)/2.45
   ::nvfij  := (12/1.65)
   ::nhfij  := (12/3.70)
endif
::printimagex(nlin,ncol,nlinf,ncolf,cimage)
return self


*-------------------------
METHOD printline(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TPRINTBASE
*-------------------------
DEFAULT nlin to 1

DEFAULT ncol to 1

DEFAULT nlinf to 4

DEFAULT ncolf to 4

DEFAULT atcolor to ::acolor

DEFAULT ntwpen to ::nwpen

if ::cunits="MM"
   ::nmver:=1
   ::nvfij:=0
   ::nmhor:=1
   ::nhfij:=0
else
   ::nmhor  := (::nfontsize)/4.75
   ::nmver  := (::nfontsize)/2.45
   ::nvfij  := (12/1.65)
   ::nhfij  := (12/3.70)
endif
::printlinex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen )

return self

*-------------------------
METHOD printrectangle(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TPRINTBASE
*-------------------------

DEFAULT nlin to 1

DEFAULT ncol to 1

DEFAULT nlinf to 4

DEFAULT ncolf to 4

DEFAULT atcolor to ::acolor

DEFAULT ntwpen to ::nwpen

if ::cunits="MM"
  ::nmver:=1
  ::nvfij:=0
  ::nmhor:=1
  ::nhfij:=0
else
  ::nmhor  := (::nfontsize)/4.75
  ::nmver  := (::nfontsize)/2.45
  ::nvfij  := (12/1.65)
  ::nhfij  := (12/3.70)
endif
::printrectanglex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen )

return self


*------------------------
METHOD printroundrectangle(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TPRINTBASE
*-------------------------
DEFAULT nlin to 1

DEFAULT ncol to 1

DEFAULT nlinf to 4

DEFAULT ncolf to 4

DEFAULT atcolor to ::acolor

DEFAULT ntwpen to ::nwpen

if ::cunits="MM"
   ::nmver:=1
   ::nvfij:=0
   ::nmhor:=1
   ::nhfij:=0
else
   ::nmhor  := (::nfontsize)/4.75
   ::nmver  := (::nfontsize)/2.45
   ::nvfij  := (12/1.65)
   ::nhfij  := (12/3.70)
endif

::printroundrectanglex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen )

return self

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
return nil

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
return self


*-------------------------
METHOD begindocx(  cdoc ) CLASS TMINIPRINT
*-------------------------
_OOHG_printer_docname:=cdoc
START PRINTDOC NAME cDoc
return self

*-------------------------
METHOD enddocx() CLASS TMINIPRINT
*-------------------------
END PRINTDOC
return self

*-------------------------
METHOD beginpagex() CLASS TMINIPRINT
*-------------------------
START PRINTPAGE
return self

*-------------------------
METHOD endpagex() CLASS TMINIPRINT
*-------------------------
END PRINTPAGE
return self


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
return nil

*-------------------------
METHOD printdatax(nlin,ncol,data,cfont,nsize,lbold,acolor,calign,nlen,ctext) CLASS TMINIPRINT
*-------------------------
   Empty( Data )
   Empty( aColor )
if .not. lbold
if calign="R"
   textalign( 2 )
   @ nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2  +((nlen+1)*nsize/4.75) PRINT (ctext) font cfont size nsize COLOR acolor
   textalign( 0 )
else
   @ nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2 PRINT (ctext) font cfont size nsize COLOR acolor
endif
else
if calign="R"
   textalign( 2 )
   @ nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2+((nlen+1)*nsize/4.75) PRINT (ctext) font cfont size nsize  BOLD COLOR acolor
   textalign( 0 )
else
   @ nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2 PRINT (ctext) font cfont size nsize  BOLD COLOR acolor
endif
endif

return self

*-------------------------
METHOD printimagex(nlin,ncol,nlinf,ncolf,cimage) CLASS TMINIPRINT
*-------------------------
@  nlin*::nmver+::nvfij , ncol*::nmhor+::nhfij*2 PRINT IMAGE cimage WIDTH ((ncolf - ncol-1)*::nmhor + ::nhfij) HEIGHT ((nlinf+0.5 - nlin)*::nmver+::nvfij)
return self


*-------------------------
METHOD printlinex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TMINIPRINT
*-------------------------
@  (nlin+.2)*::nmver+::nvfij,ncol*::nmhor+::nhfij*2 PRINT LINE TO  (nlinf+.2)*::nmver+::nvfij,ncolf*::nmhor+::nhfij*2  COLOR atcolor PENWIDTH ntwpen  //// CPEN
return self



*-------------------------
METHOD printrectanglex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TMINIPRINT
*-------------------------
@  nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2 PRINT RECTANGLE TO  (nlinf+0.5)*::nmver+::nvfij,ncolf*::nmhor+::nhfij*2 COLOR atcolor  PENWIDTH ntwpen  //// CPEN
return self


*-------------------------
METHOD selprinterx( lselect , lpreview, llandscape , npapersize ,cprinterx,nres) CLASS TMINIPRINT
*-------------------------
local worientation,lsucess

if nres=NIL
   nres:=PRINTER_RES_MEDIUM
endif
IF llandscape
   Worientation:= PRINTER_ORIENT_LANDSCAPE
ELSE
   Worientation:= PRINTER_ORIENT_PORTRAIT
ENDIF

if lselect .and. lpreview .and. cprinterx = NIL
   ::cPrinter := GetPrinter()
If Empty (::cPrinter)
   ::lprerror:=.T.
   Return Nil
EndIf

if npapersize#NIL
   SELECT PRINTER ::cprinter to lsucess ;
   ORIENTATION worientation ;
   PAPERSIZE npapersize       ;
   QUALITY nres ;
   PREVIEW
else
   SELECT PRINTER ::cprinter to lsucess ;
   ORIENTATION worientation ;
   QUALITY nres ;
   PREVIEW
endif
endif

if (.not. lselect) .and. lpreview .and. cprinterx = NIL

if npapersize#NIL
   SELECT PRINTER DEFAULT TO lsucess ;
   ORIENTATION worientation  ;
   PAPERSIZE npapersize       ;
   QUALITY nres ;
   PREVIEW
else
   SELECT PRINTER DEFAULT TO lsucess ;
   ORIENTATION worientation  ;
   QUALITY nres ;
   PREVIEW
endif
endif

if (.not. lselect) .and. (.not. lpreview) .and. cprinterx = NIL

if npapersize#NIL
   SELECT PRINTER DEFAULT TO lsucess  ;
   ORIENTATION worientation  ;
   QUALITY nres ;
   PAPERSIZE npapersize
else
   SELECT PRINTER DEFAULT TO lsucess  ;
   QUALITY nres ;
   ORIENTATION worientation
endif
endif

if lselect .and. .not. lpreview .and. cprinterx = NIL
::cPrinter := GetPrinter()
If Empty (::cPrinter)
   ::lprerror:=.T.
   Return Nil
EndIf

if npapersize#NIL
   SELECT PRINTER ::cprinter to lsucess ;
   ORIENTATION worientation ;
   QUALITY nres ;
   PAPERSIZE npapersize
else
   SELECT PRINTER ::cprinter to lsucess ;
   QUALITY nres ;
   ORIENTATION worientation
endif
endif

if cprinterx # NIL .AND. lpreview
If Empty (cprinterx)
   ::lprerror:=.T.
   Return Nil
EndIf

if npapersize#NIL
   SELECT PRINTER cprinterx to lsucess ;
   ORIENTATION worientation ;
   QUALITY nres ;
   PAPERSIZE npapersize ;
   PREVIEW
else
   SELECT PRINTER cprinterx to lsucess ;
   ORIENTATION worientation ;
   QUALITY nres ;
   PREVIEW
endif
endif

if cprinterx # NIL .AND. .not. lpreview
If Empty (cprinterx)
   ::lprerror:=.T.
   Return Nil
EndIf

if npapersize#NIL
   SELECT PRINTER cprinterx to lsucess ;
   ORIENTATION worientation ;
   QUALITY nres ;
   PAPERSIZE npapersize
else
   SELECT PRINTER cprinterx to lsucess ;
   QUALITY nres ;
   ORIENTATION worientation
endif
endif

IF .NOT. lsucess
   ::lprerror:=.T.
   return nil
ENDIF
return self

*-------------------------
METHOD getdefprinterx() CLASS TMINIPRINT
*-------------------------
return getDefaultPrinter()


*-------------------------
METHOD printroundrectanglex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TMINIPRINT
*-------------------------
@  nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2 PRINT RECTANGLE TO  (nlinf+0.5)*::nmver+::nvfij,ncolf*::nmhor+::nhfij*2 COLOR atcolor  PENWIDTH ntwpen  ROUNDED //// CPEN
return self


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
return self


*-------------------------
METHOD BEGINDOCx (cdoc) CLASS THBPRINTER
*-------------------------
START DOC NAME cDoc
return self


*-------------------------
METHOD ENDDOCx() CLASS THBPRINTER
*-------------------------
END DOC
return self


*-------------------------
METHOD BEGINPAGEx() CLASS THBPRINTER
*-------------------------
START PAGE
return self


*-------------------------
METHOD ENDPAGEx() CLASS THBPRINTER
*-------------------------
END PAGE
return self


*-------------------------
METHOD RELEASEx() CLASS THBPRINTER
*-------------------------
RELEASE PRINTSYS
RELEASE HBPRN
return self


*-------------------------
METHOD PRINTDATAx(nlin,ncol,data,cfont,nsize,lbold,acolor,calign,nlen,ctext) CLASS THBPRINTER
*-------------------------
   Empty( Data )
   Empty( aColor )
change font "F0" name cfont size nsize
change font "F1" name cfont size nsize BOLD
SET TEXTCOLOR acolor
if .not. lbold
if calign="R"
set text align right
@ nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2+((nlen+1)*nsize/4.75) SAY (ctext) font "F0" TO PRINT
set text align left
else
@ nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2 SAY (ctext) font "F0" TO PRINT
endif
else
if calign="R"
set text align right
@ nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2+((nlen+1)*nsize/4.75) SAY (ctext) font "F1" TO PRINT
set text align left

else
@ nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2  SAY (ctext) font "F1" TO PRINT
endif
endif
return self


*-------------------------
METHOD printimagex(nlin,ncol,nlinf,ncolf,cimage) CLASS thbprinter
*-------------------------
@  nlin*::nmver+::nvfij ,ncol*::nmhor+::nhfij*2 PICTURE cimage SIZE  (nlinf+0.5-nlin-4)*::nmver+::nvfij , (ncolf-ncol-3)*::nmhor+::nhfij*2
return self


*-------------------------
METHOD printlinex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS thbprinter
*-------------------------
CHANGE PEN "C0" WIDTH ntwpen*10  COLOR atcolor
SELECT PEN "C0"
@  nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2 , (nlinf)*::nmver+::nvfij,ncolf*::nmhor+::nhfij*2  LINE PEN "C0"  //// CPEN
return self


*-------------------------
METHOD printrectanglex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS THBPRINTER
*-------------------------
CHANGE PEN "C0" WIDTH ntwpen*10 COLOR atcolor
SELECT PEN "C0"
@  nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2, (nlinf+0.5)*::nmver+::nvfij, ncolf*::nmhor+::nhfij*2  RECTANGLE  PEN "C0" //// CPEN  RECTANGLE  ///// [PEN <cpen>] [BRUSH <cbrush>]
return self


*-------------------------
METHOD selprinterx( lselect , lpreview, llandscape , npapersize ,cprinterx,nres ) CLASS THBPRINTER
*-------------------------

if lselect .and. lpreview .and. cprinterx=NIL
   SELECT BY DIALOG PREVIEW
endif
if lselect .and. (.not. lpreview) .and. cprinterx=NIL
   SELECT BY DIALOG
endif
if (.not. lselect) .and. lpreview .and. cprinterx=NIL
   SELECT DEFAULT PREVIEW
endif
if (.not. lselect) .and. (.not. lpreview) .and. cprinterx=NIL
   SELECT DEFAULT
endif

if cprinterx # NIL
IF lpreview
   SELECT PRINTER cprinterx PREVIEW
ELSE
   SELECT PRINTER cprinterx
ENDIF
endif

IF HBPRNERROR != 0
   ::lprerror:=.T.
   return nil
ENDIF
define font "f0" name ::cfontname size ::nfontsize
define font "f1" name ::cfontname size ::nfontsize BOLD
define pen "C0" WIDTH ::nwpen COLOR ::acolor
select pen "C0"
if llandscape
   set page orientation DMORIENT_LANDSCAPE font "f0"
else
   set page orientation DMORIENT_PORTRAIT  font "f0"
endif
if npapersize#NIL
   set page papersize npapersize
endif

if nres#NIL
   SET QUALITY nres   ////:=PRINTER_RES_MEDIUM
endif

return self


*-------------------------
METHOD getdefprinterx() CLASS THBPRINTER
*-------------------------
local cdefprinter
GET DEFAULT PRINTER TO cdefprinter
return cdefprinter


*-------------------------
METHOD setcolorx() CLASS THBPRINTER
*-------------------------
CHANGE PEN "C0" WIDTH ::nwpen COLOR ::acolor
SELECT PEN "C0"
return self


*-------------------------
METHOD setpreviewsizex(ntam) CLASS THBPRINTER
*-------------------------
SET PREVIEW SCALE ntam
return self


*-------------------------
METHOD printroundrectanglex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS THBPRINTER
*-------------------------
CHANGE PEN "C0" WIDTH ntwpen*10 COLOR atcolor
SELECT PEN "C0"
hbprn:RoundRect( nlin*::nmver+::nvfij  ,ncol*::nmhor+::nhfij*2 ,(nlinf+0.5)*::nmver+::nvfij ,ncolf*::nmhor+::nhfij*2 ,10, 10,"C0")
return self

CREATE CLASS TDOSPRINT FROM TPRINTBASE

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
ENDCLASS

*-------------------------
METHOD initx() CLASS TDOSPRINT
*-------------------------
::impreview:=.F.
::cprintlibrary:="DOSPRINT"
return self


*-------------------------
METHOD begindocx() CLASS TDOSPRINT
*-------------------------
   SET PRINTER TO &(::tempfile)
   SET DEVICE TO PRINT
return self

*-------------------------
METHOD enddocx() CLASS TDOSPRINT
*-------------------------
local _nhandle,wr,nx,ny

nx:=getdesktopwidth()
ny:=getdesktopheight()

 SET DEVICE TO SCREEN
   SET PRINTER TO
   _nhandle:=FOPEN(::tempfile,0+64)
   if ::impreview
      wr:=memoread((::tempfile))
      DEFINE WINDOW PRINT_PREVIEW  ;
         AT 0,0 ;
         WIDTH nx HEIGHT ny-70 ;
         TITLE 'Preview -----> ' + ::tempfile ;
         MODAL

         @ 0,0 EDITBOX EDIT_P ;
         OF PRINT_PREVIEW ;
         WIDTH nx-50 ;
         HEIGHT ny-40-70 ;
         VALUE WR ;
         READONLY ;
         FONT 'Courier New' ;
         SIZE 10

         @ 10,nx-40 button but_4 caption "X" width 30 action ( print_preview.release() )
         @ 110,nx-40 button but_1 caption "+ +" width 30 action zoom("+")
         @ 210,nx-40 button but_2 caption "- -" width 30 action zoom("-")
         @ 310,nx-40 button but_3 caption "P" width 30 action (::printdos())


      END WINDOW

      CENTER WINDOW PRINT_PREVIEW
      ACTIVATE WINDOW PRINT_PREVIEW

   else

      ::PRINTDOS()

   endif

   IF FILE(::tempfile)
      fclose(_nhandle)
      ERASE &(::tempfile)
   ENDIF



RETURN self

*-------------------------
METHOD beginpagex() CLASS TDOSPRINT
*-------------------------
@ 0,0 SAY ""
return self


*-------------------------
METHOD endpagex() CLASS TDOSPRINT
*-------------------------
EJECT
return self


*-------------------------
METHOD printdatax(nlin,ncol,data,cfont,nsize,lbold,acolor,calign,nlen,ctext) CLASS TDOSPRINT
*-------------------------
   Empty( Data )
   Empty( cFont )
   Empty( nSize )
   Empty( aColor )
   Empty( cAlign )
   Empty( nLen )
   if .not. lbold
      @ nlin,ncol say (ctext)
   else
      @ nlin,ncol say (ctext)
      @ nlin,ncol say (ctext)
   endif
return self


*-------------------------
METHOD printlinex(nlin,ncol,nlinf,ncolf /* ,atcolor,ntwpen */ ) CLASS TDOSPRINT
*-------------------------
if nlin=nlinf
   @ nlin,ncol say replicate("-",ncolf-ncol+1)
endif
return self


*-------------------------
METHOD selprinterx( lselect , lpreview /* , llandscape , npapersize ,cprinterx */ ) CLASS TDOSPRINT
*-------------------------
   Empty( lSelect )
   do while file(::tempfile)
      ::tempfile:=gettempdir()+"T"+alltrim(str(int(hb_random(999999)),8))+".prn"
   enddo
   if lpreview
      ::impreview:=.T.
   endif
return self


*-------------------------
METHOD condendosx() CLASS TDOSPRINT
*-------------------------
@ prow(), pcol() say chr(15)
return self


*-------------------------
METHOD normaldosx() CLASS TDOSPRINT
*-------------------------
@ prow(), pcol() say chr(18)
return self


*-------------------------
static function zoom(cOp)
*-------------------------
if cOp="+" .and. print_preview.edit_p.fontsize <= 24
   print_preview.edit_p.fontsize:=  print_preview.edit_p.fontsize + 2
endif

if cOp="-" .and. print_preview.edit_p.fontsize > 7
   print_preview.edit_p.fontsize:=  print_preview.edit_p.fontsize - 2
endif
return nil


/// based upon contribution of Jose Miguel josemisu@yahoo.com.ar

CREATE CLASS TEXCELPRINT FROM TPRINTBASE

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
METHOD printimage() BLOCK {|| NIL }
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
return self

*-------------------------
METHOD selprinterx( lselect , lpreview, llandscape , npapersize ,cprinterx) CLASS TEXCELPRINT
*-------------------------
Public oPrintExcel, oPrintHoja
empty(lselect)
empty(lpreview)
empty(llandscape)
empty(npapersize)
empty(cprinterx)

   oPrintExcel := TOleAuto():New( "Excel.Application" )
   IF Ole2TxtError() != 'S_OK'
      MsgStop('Excel no esta disponible','error')
        ::lprerror:=.T.
        ::exit:=.T.
      RETURN Nil
   ENDIF
return self

*-------------------------
METHOD begindocx(cdoc) CLASS TEXCELPRINT
*-------------------------
empty(cdoc)
   oPrintExcel:WorkBooks:Add()
   oPrintHoja:=oPrintExcel:Get( "ActiveSheet" )
   oPrintHoja:Name := "List"
   oPrintHoja:Cells:Font:Name := ::cfontname
   oPrintHoja:Cells:Font:Size := ::nfontsize
return self


*-------------------------
METHOD enddocx() CLASS TEXCELPRINT
*-------------------------
local nCol
FOR nCol:=1 TO FCOUNT()
   oPrintHoja:Columns( nCol ):AutoFit()
NEXT
oPrintHoja:Cells( 1, 1 ):Select()
oPrintExcel:Visible := .T.
oPrintHoja:End()
oPrintExcel:End()
RETURN self

METHOD releasex() CLASS TEXCELPRINT
release oPrintHOja
release oPrintExcel
RETURN self


*-------------------------
METHOD beginpagex() CLASS TEXCELPRINT
*-------------------------
return self


*-------------------------
METHOD endpagex() CLASS TEXCELPRINT
*-------------------------
::nlinpag:=LEN(::alincelda)+1
::alincelda:={}
return self


*-------------------------
METHOD setunitsx(cunitsx,nunitslinx) CLASS TEXCELPRINT
*-------------------------
if cunitsx="MM"
   ::cunits:="MM"
else
   ::cunits:="ROWCOL"
endif
if nunitslinx=NIL
   ::nunitslin:=1
else
   ::nunitslin:=nunitslinx
endif
RETURN self


*-------------------------
METHOD printdatax(nlin,ncol,data,cfont,nsize,lbold,acolor,calign,nlen,ctext) CLASS TEXCELPRINT
*-------------------------
local alinceldax
empty(ncol)
empty(data)
empty(acolor)
empty(nlen)
if ::nunitslin>1
   nlin:=round(nlin/::nunitslin,0)
endif
nlin:=nlin+::nlinpag
IF LEN(::alincelda)<nlin
   DO WHILE LEN(::alincelda)<nlin
      AADD(::alincelda,0)
   ENDDO
ENDIF
::alincelda[nlin]:=::alincelda[nlin]+1
alinceldax:=::alincelda[nlin]
oPrintHoja:Cells(nlin,alinceldax):Value := ctext
oPrintHoja:Cells(nlin,alinceldax):Font:Name := cfont
oPrintHoja:Cells(nlin,alinceldax):Font:Size := nsize
oPrintHoja:Cells(nlin,alinceldax):Font:Bold := lbold
do case
case calign="R"
   oPrintHoja:Cells(nlin,alinceldax):HorizontalAlignment:= -4152  //Derecha
case calign="C"
   oPrintHoja:Cells(nlin,alinceldax):HorizontalAlignment:= -4108  //Centrar
endcase
return self


//////////////////////// RTF

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
return self


*-------------------------
METHOD begindocx(cdoc) CLASS TRTFPRINT
*-------------------------
local   MARGENSUP:=LTRIM(STR(ROUND(15*56.7,0)))
local   MARGENINF:=LTRIM(STR(ROUND(15*56.7,0)))
local   MARGENIZQ:=LTRIM(STR(ROUND(10*56.7,0)))
local   MARGENDER:=LTRIM(STR(ROUND(10*56.7,0)))

Empty( cdoc )

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

return self


*-------------------------
METHOD enddocx() CLASS TRTFPRINT
*-------------------------
local nTRTFPRINT
private rutaficrtf1
IF RIGHT(oPrintRTF1[LEN(oPrintRTF1)],6)=" \page"
   oPrintRTF1[LEN(oPrintRTF1)]:=LEFT(oPrintRTF1[LEN(oPrintRTF1)] , LEN(oPrintRTF1[LEN(oPrintRTF1)])-6 )
ENDIF
AADD(oPrintRTF1,"\par }}")
RUTAFICRTF1:=GetCurrentFolder()
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
IF ShellExecute(0, "open", "soffice.exe", "printer.RTF" , RUTAFICRTF1 , 1)<=32
   IF ShellExecute(0, "open", "WinWord.exe", "printer.RTF" , RUTAFICRTF1 , 1)<=32
      IF ShellExecute(0, "open", "printer.RTF" , RUTAFICRTF1 , , 1)<=32
         MSGINFO("No se ha localizado el programa asociado a la extemsion RTF"+CHR(13)+CHR(13)+ ;
                 "El fichero se ha guardado en:"+CHR(13)+RUTAFICRTF1+"\printer.RTF")
      ENDIF
   ENDIF
ENDIF
RETURN self


*-------------------------
METHOD beginpagex() CLASS TRTFPRINT
*-------------------------
return self


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
return self


*-------------------------
METHOD setunits(cunitsx,cunitslinx) CLASS TRTFPRINT
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
METHOD printdatax(nlin,ncol,data,cfont,nsize,lbold,acolor,calign,nlen,ctext) CLASS TRTFPRINT
*-------------------------
Empty( data )
Empty( cfont )
Empty( lbold )
Empty( acolor )
Empty( nlen )
if ::nunitslin>1
   nlin:=round(nlin/::nunitslin,0)
endif
IF ::cunits="MM"
   ctext:=ALLTRIM(ctext)
ENDIF
AADD(::alincelda,{nlin,ncol,ctext,nsize,calign})
return self


*-------------------------
METHOD printlinex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TRTFPRINT
*-------------------------
Empty( nlin )
Empty( ncol )
Empty( nlinf )
Empty( ncolf )
Empty( atcolor )
Empty( ntwpen )
return self


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
return self


*-------------------------
METHOD condendosx() CLASS TRTFPRINT
*-------------------------
return self


*-------------------------
METHOD normaldosx() CLASS TRTFPRINT
*-------------------------
return self



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
return self


*-------------------------
METHOD begindocx(cdoc) CLASS TCSVPRINT
*-------------------------
Empty( cdoc )
return self


*-------------------------
METHOD enddocx() CLASS TCSVPRINT
*-------------------------
RUTAFICRTF1:=GetCurrentFolder()
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
IF ShellExecute(0, "open", "soffice.exe", "printer.CSV" , RUTAFICRTF1 , 1)<=32
   IF ShellExecute(0, "open", "Excel.exe", "printer.CSV" , RUTAFICRTF1 , 1)<=32
      IF ShellExecute(0, "open", "printer.CSV" , RUTAFICRTF1 , , 1)<=32
         MSGINFO("No se ha localizado el programa asociado a la extemsion CSV"+CHR(13)+CHR(13)+ ;
                 "El fichero se ha guardado en:"+CHR(13)+RUTAFICRTF1+"\printer.CSV")
      ENDIF
   ENDIF
ENDIF
RETURN self


*-------------------------
METHOD beginpagex() CLASS TCSVPRINT
*-------------------------
return self


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
return self


*-------------------------
METHOD setunits(cunitsx,cunitslinx) CLASS TCSVPRINT
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
METHOD printdatax(nlin,ncol,data,cfont,nsize,lbold,acolor,calign,nlen,ctext) CLASS TCSVPRINT
*-------------------------
Empty( data )
Empty( cfont )
Empty( lbold )
Empty( acolor )
Empty( nlen )
if ::nunitslin>1
   nlin:=round(nlin/::nunitslin,0)
endif
IF ::cunits="MM"
   ctext:=ALLTRIM(ctext)
ENDIF
AADD(::alincelda,{nlin,ncol,ctext,nsize,calign})
return self


*-------------------------
METHOD printlinex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TCSVPRINT
Empty( nlin )
Empty( ncol )
Empty( nlinf )
Empty( ncolf )
Empty( atcolor )
Empty( ntwpen )
*-------------------------
return self


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
return self


*-------------------------
METHOD condendosx() CLASS TCSVPRINT
*-------------------------
return self


*-------------------------
METHOD normaldosx() CLASS TCSVPRINT
*-------------------------
return self





