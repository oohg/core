/*
* $Id: h_print.prg,v 1.25 2006-03-26 01:51:34 declan2005 Exp $
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
      else
         o_print_:=thbprinter()
      endif      
   else
       o_print_:=thbprinter()
   endif
else
   if valtype(clibx)="C"
      if clibx="HBPRINTER"
         o_print_:=thbprinter()
      elseif clibx="MINIPRINT"
         o_print_:=tminiprint()
      elseif clibx="DOSPRINT"
         o_print_:=tdosprint()
      else
         o_print_:=thbprinter()
      endif
    else
      o_print_:=thbprinter()
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
DATA cfontname          INIT "courier new" READONLY
DATA nfontsize          INIT 10 READONLY
DATA nwpen              INIT 0.1   READONLY //// pen width
DATA tempfile           INIT gettempdir()+"T"+alltrim(str(int(hb_random(999999)),8))+".prn" READONLY
DATA impreview          INIT .F.  READONLY
DATA lwinhide           INIT .T.   READONLY
DATA cversion           INIT  "(oohg)V 1.4" READONLY


*-------------------------
METHOD init()
METHOD initx() inline NIL
*-------------------------

*-------------------------
METHOD begindoc()
METHOD begindocx() inline NIL
*-------------------------
*-------------------------
METHOD enddoc()
METHOD enddocx() inline NIL
*-------------------------

*-------------------------
METHOD printdos()
METHOD printdosx() INLINE nil
*-------------------------
*-------------------------
METHOD beginpage()
METHOD beginpagex() INLINE nil
*-------------------------


*-------------------------
METHOD condendos() INLINE nil
METHOD condendosx() INLINE nil
*-------------------------


*-------------------------
METHOD NORMALDOS() INLINE NIL
METHOD normaldosx() INLINE nil
*-------------------------

*-------------------------
METHOD endpage()
METHOD endpagex() INLINE nil
*-------------------------
*-------------------------
METHOD release()
METHOD releasex() INLINE nil
*-------------------------
*-------------------------
METHOD printdata()
METHOD printdatax() INLINE nil
*-------------------------
*-------------------------
METHOD printimage()
METHOD printimagex() INLINE nil
*-------------------------
*-------------------------
METHOD printline()
METHOD printlinex() INLINE nil
*-------------------------


*-------------------------
METHOD printrectangle()
METHOD printrectanglex() INLINE nil
*-------------------------

*-------------------------
METHOD selprinter()
METHOD selprinterx() INLINE nil
*-------------------------

*-------------------------
METHOD getdefprinter()
METHOD getdefprinterx() INLINE NIL
*-------------------------

*-------------------------
METHOD setcolor()
METHOD setcolorx() INLINE NIL
*-------------------------

*-------------------------
METHOD setpreviewsize()
METHOD setpreviewsizex() INLINE nil
*-------------------------

*-------------------------
METHOD setunits()   ////// mm o rowcol
METHOD setunitsx() INLINE NIL
*-------------------------

*-------------------------
METHOD printroundrectangle()
METHOD printroundrectanglex() INLINE NIL
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
::releasex()
return nil

*-------------------------
METHOD init(clibx) CLASS TPRINTBASE
*-------------------------
if iswindowactive(_oohg_winreport)
   msgstop("Print preview pending, close first")
   ::exit:=.T.
   return nil
endif
::initx()
RETURN self

*-------------------------
METHOD selprinter( lselect , lpreview, llandscape , npapersize ,cprinterx, lhide ) CLASS TPRINTBASE
*-------------------------
local Worientation, lsucess := .T.
if ::exit
   ::lprerror:=.T.
   return nil
endif

if lhide#NIL
  ::lwinhide:=lhide
endif

SETPRC(0,0)
DEFAULT llandscape to .F.

::selprinterx( lselect , lpreview, llandscape , npapersize ,cprinterx, lhide)
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

@ 22,225 LABEL LABEL_101 VALUE '......' FONT "Courier new" SIZE 10

@ 55,10  label label_1 value cdoc WIDTH 300 HEIGHT 32 FONT "Courier new"

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
local cdefprinter:= ::getdefprinterx()
RETURN cdefprinter

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
METHOD begindocx(cdoc) CLASS TMINIPRINT
*-------------------------
START PRINTDOC //////////////NAME cDoc
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
if .not. lbold
if calign="R"
   textalign( 2 )
   @ nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2  +((nlen+1)*nsize/4.75) PRINT (ctext) font cfont size nsize COLOR ::acolor
   textalign( 0 )
else
   @ nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2 PRINT (ctext) font cfont size nsize COLOR ::acolor
endif
else
if calign="R"
   textalign( 2 )
   @ nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2+((nlen+1)*nsize/4.75) PRINT (ctext) font cfont size nsize  BOLD COLOR ::acolor
   textalign( 0 )
else
   @ nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2 PRINT (ctext) font cfont size nsize  BOLD COLOR ::acolor
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
METHOD selprinterx( lselect , lpreview, llandscape , npapersize ,cprinterx) CLASS TMINIPRINT
*-------------------------
local worientation,lsucess
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
   PREVIEW
else
   SELECT PRINTER ::cprinter to lsucess ;
   ORIENTATION worientation ;
   PREVIEW
endif
endif

if (.not. lselect) .and. lpreview .and. cprinterx = NIL

if npapersize#NIL
   SELECT PRINTER DEFAULT TO lsucess ;
   ORIENTATION worientation  ;
   PAPERSIZE npapersize       ;
   PREVIEW
else
   SELECT PRINTER DEFAULT TO lsucess ;
   ORIENTATION worientation  ;
   PREVIEW
endif
endif

if (.not. lselect) .and. (.not. lpreview) .and. cprinterx = NIL

if npapersize#NIL
   SELECT PRINTER DEFAULT TO lsucess  ;
   ORIENTATION worientation  ;
   PAPERSIZE npapersize
else
   SELECT PRINTER DEFAULT TO lsucess  ;
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
   PAPERSIZE npapersize
else
   SELECT PRINTER ::cprinter to lsucess ;
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
   PAPERSIZE npapersize ;
   PREVIEW
else
   SELECT PRINTER cprinterx to lsucess ;
   ORIENTATION worientation ;
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
   PAPERSIZE npapersize
else
   SELECT PRINTER cprinterx to lsucess ;
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
change font "F0" name cfont size nsize
change font "F1" name cfont size nsize BOLD
SET TEXTCOLOR ::acolor
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
METHOD selprinterx( lselect , lpreview, llandscape , npapersize ,cprinterx) CLASS THBPRINTER
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
METHOD releasex() INLINE nil
*-------------------------

*-------------------------
METHOD printdatax()
*-------------------------

*-------------------------
METHOD printimage() INLINE nil
*-------------------------

*-------------------------
METHOD printlinex()
*-------------------------

*-------------------------
METHOD printrectanglex INLINE nil
*-------------------------

*-------------------------
METHOD selprinterx()
*-------------------------

*-------------------------
METHOD getdefprinterx() INLINE NIL
*-------------------------

*-------------------------
METHOD setcolorx() INLINE NIL
*-------------------------

*-------------------------
METHOD setpreviewsizex() INLINE NIL
*-------------------------

*-------------------------
METHOD printroundrectanglex() INLINE NIL
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
local _nhandle,wr
SET PRINTER TO &(::tempfile)
SET DEVICE TO PRINT
return self

*-------------------------
METHOD enddocx() CLASS TDOSPRINT
*-------------------------
local _nhandle,wr

 SET DEVICE TO SCREEN
   SET PRINTER TO
   _nhandle:=FOPEN(::tempfile,0+64)
   if ::impreview
      wr:=memoread((::tempfile))
      DEFINE WINDOW PRINT_PREVIEW  ;
         AT 10,10 ;
         WIDTH 640 HEIGHT 480 ;
         TITLE 'Preview -----> ' + ::tempfile ;
         MODAL

         @ 0,0 EDITBOX EDIT_P ;
         OF PRINT_PREVIEW ;
         WIDTH 590 ;
         HEIGHT 440 ;
         VALUE WR ;
         READONLY ;
         FONT 'Courier new' ;
         SIZE 10

         @ 10,600 button but_4 caption "X" width 30 action ( print_preview.release() )
         @ 110,600 button but_1 caption "+ +" width 30 action zoom("+")
         @ 210,600 button but_2 caption "- -" width 30 action zoom("-")
         @ 310,600 button but_3 caption "P" width 30 action (::printdos())


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
if .not. lbold
@ nlin,ncol say (ctext)
else
@ nlin,ncol say (ctext)
@ nlin,ncol say (ctext)
endif
return self


*-------------------------
METHOD printlinex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TDOSPRINT
*-------------------------
if nlin=nlinf
@ nlin,ncol say replicate("-",ncolf-ncol+1)
endif
return self


*-------------------------
METHOD selprinterx( lselect , lpreview, llandscape , npapersize ,cprinterx) CLASS TDOSPRINT
*-------------------------
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
