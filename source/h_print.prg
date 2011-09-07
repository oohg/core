/*
* $Id: h_print.prg,v 1.115 2011-09-07 15:45:31 nulcrc Exp $
*/

#include 'hbclass.ch'
#include 'oohg.ch'
#include 'miniprint.ch'
#include 'winprint.ch'

#include "fileio.ch"

#ifndef _BARCODE_
#define _BARCODE_


#define  derecha "1110010110011011011001000010101110010011101010000100010010010001110100"
#define  izda1    "0001101001100100100110111101010001101100010101111011101101101110001011"
#define  izda2   "0100111011001100110110100001001110101110010000101001000100010010010111"
#define  primero "ooooooooeoeeooeeoeooeeeooeooeeoeeooeoeeeoooeoeoeoeoeeooeeoeo"

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
      ELSEIF _OOHG_printlibrary="RAWPRINT"
         o_print_:=tRAWprint()
      ELSEIF _OOHG_printlibrary="SPREADSHEETPRINT"
         o_print_:=tspreadsheetprint()

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
      ELSEIF clibx="RAWPRINT"
         o_print_:=trawprint()
      ELSEIF clibx="SPREADSHEETPRINT"
         o_print_:=tspreadsheetprint()

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
DATA nmver              INIT (10)/2.35   READONLY
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
DATA nfontsize          INIT 12            /////// nunca ponerle read only
DATA afontcolor         INIT {0,0,0}      READONLY
DATA lfontbold          INIT .F.          READONLY
DATA lfontitalic        INIT .F.          READONLY
DATA nwpen              INIT 0.1   READONLY //// pen width
DATA tempfile           INIT gettempdir()+"T"+alltrim(str(int(hb_random(999999)),8))+".prn" READONLY
DATA impreview          INIT .F.  READONLY
DATA lwinhide           INIT .T.   READONLY
DATA cversion           INIT  "(oohg-tprint)V 4.3" READONLY
DATA cargo              INIT  "list"     //// document name
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
METHOD printraw()
*-------------------------

*-------------------------
METHOD printrawx() BLOCK { || nil }
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

METHOD printbarcode()

METHOD printbarcodex() BLOCK {|| nil }

method ean13()

method code128()

method code3_9()

method int25()

method ean8()

method  upca()

method sup5()

method codabar()

method ind25()

method mat25()

method go_code()

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
METHOD setfont()
*-------------------------

*-------------------------
METHOD setfontx() BLOCK { || nil }
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
::initx()
RETURN self

*-------------------------
METHOD selprinter( lselect , lpreview, llandscape , npapersize ,cprinterx, lhide,nres, nbin ) CLASS TPRINTBASE
*-------------------------
local lsucess := .T.

default nbin to 1

IF ::exit
   ::lprerror:=.T.
   RETURN nil
ENDIF

IF lhide#NIL
   ::lwinhide:=lhide
ENDIF

DEFAULT llandscape to .F.

IF lpreview
 ::impreview:=.T.
ENDIF

::selprinterx( lselect , lpreview, llandscape , npapersize ,cprinterx, nres, nbin )
RETURN self


*-------------------------
METHOD BEGINDOC(cDocm) CLASS TPRINTBASE
*-------------------------
local olabel,oimage,cdoc
cDoc:="ooHG printing"
IF hb_isstring(cDocm)

   ::cargo:=cDocm

ENDIF

SETPRC(0,0)

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

::begindocx()
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
METHOD SETFONT(cfont,nsize,acolor,lbold,litalic) CLASS TPRINTBASE
*-------------------------
DEFAULT cfont   to ::cfontname
DEFAULT nsize   to ::nfontsize
DEFAULT acolor  to ::afontcolor
DEFAULT lbold   to ::lfontbold
DEFAULT litalic to ::lfontitalic
::cfontname:=cfont
::nfontsize:=nsize
::afontcolor:=acolor
::lfontbold:=lbold
::lfontitalic:=litalic
return self

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
METHOD setunits(cunitsx,nunitslinx) CLASS TPRINTBASE
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
METHOD printdata(nlin,ncol,data,cfont,nsize,lbold,acolor,calign,nlen,litalic,nangle) CLASS TPRINTBASE
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
DEFAULT cfont to ::cfontname
DEFAULT nsize to ::nfontsize
DEFAULT acolor to ::acolor
DEFAULT lbold   to ::lfontbold
DEFAULT litalic to ::lfontitalic
DEFAULT nangle to 0

IF ::cunits="MM"
   ::nmver:=1
   ::nvfij:=0
   ::nmhor:=1
   ::nhfij:=0
ELSE
   ::nmhor  := nsize/4.75
   IF ::lprop
      ::nmver  := (::nfontsize)/2.35
   ELSE
      ::nmver  :=  10/2.35
   ENDIF

      ::nvfij  := (12/1.65)
      ::nhfij  := (12/3.70)
 ENDIF

if ::cunits="MM"
   ctext:= ctext
else
   ctext:= cspace + ctext
endif

::printdatax(::ntmargin+nlin,::nlmargin+ncol,data,cfont,nsize,lbold,acolor,calign,nlen,ctext,litalic,nangle)
RETURN self

*-------------------------
METHOD printbarcode(nlin,ncol,cbarcode,ctipo,acolor,lhori,nwidth,nheight ) CLASS TPRINTBASE
*-------------------------
local nsize:=10
default nheight  to 10
default nwidth to NIL
default cbarcode to ""
cbarcode:=upper(cbarcode)

DEFAULT lhori to  .T.
default  acolor to {1,1,1}
default ctipo to "CODE128C"

DEFAULT nlin to 1
DEFAULT ncol to 1

DEFAULT acolor to ::acolor

IF ::cunits="MM"
   ::nmver:=1
   ::nvfij:=0
   ::nmhor:=1
   ::nhfij:=0
ELSE
   ::nmhor  := nsize/4.75
   IF ::lprop
      ::nmver  := (::nfontsize)/2.35
   ELSE
      ::nmver  :=  10/2.35
   ENDIF

      ::nvfij  := (12/1.65)
      ::nhfij  := (12/3.70)
 ENDIF

 do case
   case ctipo="CODE128A"
            ::Code128( nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2 , cbarcode, "A" , acolor , lhori, nwidth, nheight )
   case ctipo="CODE128B"
             ::Code128( nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2 , cbarcode, "B" , acolor , lhori, nwidth, nheight )
   case ctipo="CODE128C"
             ::Code128( nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2 , cbarcode, "C" , acolor , lhori, nwidth, nheight )
   CASE  ctipo="CODE39"
             ::Code3_9( nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2 , cbarcode , acolor , lhori, nwidth, nheight )
   case ctipo="EAN8"
             ::EAN8( nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2 , cbarcode , acolor , lhori, nwidth, nheight )
    case ctipo="EAN13"
             ::EAN13( nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2 , cbarcode , acolor , lhori, nwidth, nheight )
    case ctipo="INTER25"
             ::INT25( nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2  , cbarcode , acolor , lhori, nwidth, nheight )
    case ctipo="UPCA"
            ::UPCA( nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2 ,  cbarcode , acolor , lhori, nwidth, nheight )
     case ctipo="SUP5"
           ::SUP5(nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2  , cbarcode , acolor , lhori, nwidth, nheight )
     case ctipo="CODABAR"
           ::CODABAR( nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2 , cbarcode , acolor , lhori, nwidth, nheight )
     case ctipo="IND25"
        ::IND25( nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2  , cbarcode , acolor , lhori, nwidth, nheight )
     case ctipo="MAT25"
        ::MAT25( nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2 , cbarcode , acolor , lhori, nwidth, nheight )

endcase
return self


METHOD ean8(nRow,nCol,cCode,Color,lHorz,nWidth,nHeigth)    CLASS TPRINTBASE
    local nLen:=0
    // test de parametros
    // por implementar
    default nHeigth to  1.5
    if lHorz
        ::go_code(_UPC(cCode,7),nRow,nCol,lHorz,Color,nWidth,nHeigth*0.90)
    else
        ::go_code(_UPC(cCode,7),nRow,nCol+nLen,lHorz,Color,nWidth,nHeigth*0.90)
    endif
    ::go_code(_ean13Bl(8),nRow,nCol,lHorz,Color,nWidth,nHeigth)

return self


METHOD   ean13(nRow,nCol,cCode,Color,lHorz,nWidth,nHeigth) CLASS TPRINTBASE
    local nLen:=0
    // test de parametros
    // por implementar
    default nHeigth to 1.5
    // desplazamiento...
    if lHorz
        ::go_code(_ean13(cCode),nRow,nCol,lHorz,Color,nWidth,nHeigth*0.90)
    else
        ::go_code(_ean13(cCode),nRow,nCol+nLen,lHorz,Color,nWidth,nHeigth*0.90)
    endif
    ::go_code(_ean13Bl(12),nRow,nCol,lHorz,Color,nWidth,nHeigth)
return SELF

METHOD Code128(nRow,nCol,cCode,cMode,Color,lHorz,nWidth,nHeigth) CLASS TPRINTBASE
    // test de parametros
    // por implementar
    ::go_code(_code128(cCode,cMode),nRow,nCol,lHorz,Color,nWidth,nHeigth)
return self

METHOD Code3_9(nRow,nCol,cCode,Color,lHorz,nWidth,nHeigth)      CLASS TPRINTBASE
    // test de parametros
    // por implementar
    local lcheck:=.T.
    ::go_code(_code3_9(cCode,lCheck),nRow,nCol,lHorz,Color,nWidth,nHeigth)
return self

METHOD int25(nRow,nCol,cCode,Color,lHorz,nWidth,nHeigth)            CLASS TPRINTBASE
    // test de parametros
    // por implementar
    local lcheck:=.T.
    ::go_code(_int25(cCode,lCheck),nRow,nCol,lHorz,Color,nWidth,nHeigth)
return SELF

method UPCA(nRow,nCol,cCode,Color,lHorz,nWidth,nHeigth)           CLASS TPRINTBASE
    local nLen:=0
    // test de parametros
    // por implementar
    default nHeigth to 1.5
    if lHorz
       ::go_code(_UPC(cCode),nRow,nCol,lHorz,Color,nWidth,nHeigth*0.90)
    else
        ::go_code(_UPC(cCode),nRow,nCol+nLen,lHorz,Color,nWidth,nHeigth*0.90)
    endif
    ::go_code(_UPCABl(cCode),nRow,nCol,lHorz,Color,nWidth,nHeigth)
return self

method sup5(nRow,nCol,cCode,Color,lHorz,nWidth,nHeigth)      CLASS TPRINTBASE
    ::go_code(_sup5(cCode),nRow,nCol,lHorz,Color,nWidth,nHeigth)
return self

method Codabar(nRow,nCol,cCode,Color,lHorz,nWidth,nHeigth)   CLASS TPRINTBASE
    // test de parametros
    // por implementar
    ::go_code(_Codabar(cCode),nRow,nCol,lHorz,Color,nWidth,nHeigth)
return self

method ind25(nRow,nCol,cCode,Color,lHorz,nWidth,nHeigth)     CLASS TPRINTBASE
    // test de parametros
    // por implementar
    local lcheck := .T.
    ::go_code(_ind25(cCode,lCheck),nRow,nCol,lHorz,Color,nWidth,nHeigth)
return self

method mat25 (nRow,nCol,cCode,Color,lHorz,nWidth,nHeigth)       CLASS TPRINTBASE
    // test de parametros
    // por implementar
    local lcheck:=.T.
    ::go_code(_mat25(cCode, lcheck),nRow,nCol,lHorz,  Color,   nWidth,  nHeigth)
return self

method go_code(     cBarra,         ny,    nx,lHoRz,  aColor,  nWidth,   nLen) CLASS TPRINTBASE
    local n

    default  aColor to  {0,0,0}

    default lHorz to .t.

    default nWidth to 0.50 // 1/3 M/mm      0.25    ancho

    default nLen to  15 // mm    alto

    for n:=1 to len(cBarra)
        if substr(cBarra,n,1) ='1'
            if lHorz
               ::printbarcodex(ny,nx,ny+nlen,nx+nwidth,acolor )
               nx+=nwidth
            else
               ::printbarcodex(ny,nx, ny+nwidth,nx+nlen,acolor )
               ny+=nWidth
            endif
        else
           if lHorz
              nx+=nWidth
           else
              ny += nWidth
           endif
        endif
    next n

return nil

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
      ::nmver  := (::nfontsize)/2.35
   ELSE
      ::nmver  :=  10/2.35
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
      ::nmver  := (::nfontsize)/2.35
   ELSE
      ::nmver  :=  10/2.35
   ENDIF

   ::nvfij  := (12/1.65)
   ::nhfij  := (12/3.70)
ENDIF
::printlinex(::ntmargin+nlin,::nlmargin+ncol,::ntmargin+nlinf,::nlmargin+ncolf,atcolor,ntwpen )
RETURN self

*-------------------------
METHOD printrectangle(nlin,ncol,nlinf,ncolf,atcolor,ntwpen,arcolor ) CLASS TPRINTBASE
*-------------------------

DEFAULT nlin to 1
DEFAULT ncol to 1
DEFAULT nlinf to 4
DEFAULT ncolf to 4

DEFAULT atcolor to ::acolor
DEFAULT ntwpen to ::nwpen
DEFAULT arcolor to {255,255,255}

IF ::cunits="MM"
   ::nmver:=1
   ::nvfij:=0
   ::nmhor:=1
   ::nhfij:=0
ELSE
   ::nmhor  := (::nfontsize)/4.75

   IF ::lprop
      ::nmver  := (::nfontsize)/2.35
   ELSE
      ::nmver  :=  10/2.35
   ENDIF

   ::nvfij  := (12/1.65)
   ::nhfij  := (12/3.70)
ENDIF
::printrectanglex(::ntmargin+nlin,::nlmargin+ncol,::ntmargin+nlinf,::nlmargin+ncolf,atcolor,ntwpen,arcolor )

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
      ::nmver  := (::nfontsize)/2.35
   ELSE
      ::nmver  :=  10/2.35
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
cbat:='b'+alltrim(str(hb_random(999999),6))+'.bat'
nHdl := FCREATE( cBat )
FWRITE( nHdl, "copy " + ::tempfile + " "+::cport + CHR( 13 ) + CHR( 10 ) )
FWRITE( nHdl, "rem comando auxiliar de impresion" + CHR( 13 ) + CHR( 10 ) )
FCLOSE( nHdl )
waitrun( cBat, 0 )
erase &cbat
RETURN nil

*----------------------------
method printraw()  CLASS TPRINTBASE   /////  Based upon an example of Lucho Miranda
*----------------------------
LOCAL cPrinter :=GETDEFAULTPRINTER()
LOCAL nResult  :=NIL
LOCAL cMsg     :=""
LOCAL aDatos :=                              {;
{ 1 , ::tempfile + " PRINTED OK!!!"              },;
{-1 ,"Invalid PARAMETERS passed TO function"},;
{-2 ,"WinAPI OpenPrinter() CALL failed"     },;
{-3 ,"WinAPI StartDocPrinter() CALL failed" },;
{-4 ,"WinAPI StartPagePrinter() CALL failed"},;
{-5 ,"WinAPI malloc() OF MEMORY failed"     },;
{-6 ,"File " + ::tempfile + " not found"         } }


IF ! EMPTY( cPrinter )
   nResult :=PRINTFILERAW( cPrinter, ::tempfile, "raw print" )
   if nResult#1
      cMsg +=aDatos[ASCAN(aDatos,{|x| x[1] ==nResult}),2]
        MSGINFO( cMsg )
   endif
ELSE
   MSGSTOP("No Default Printer found","Error...")
ENDIF

RETURN(NIL)


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

METHOD printbarcodex()

ENDCLASS

*------------------------------------------------------------
METHOD printbarcodex(y, x, y1, x1 ,acolor) CLASS TMINIPRINT
*------------------------------------------------------------
 @ y,x PRINT FILL TO y1, x1 COLOR aColor
return self

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
METHOD begindocx(   ) CLASS TMINIPRINT
*-------------------------
START PRINTDOC NAME ::cargo
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
METHOD printdatax(nlin,ncol,data,cfont,nsize,lbold,acolor,calign,nlen,ctext,litalic,nangle) CLASS TMINIPRINT
*-------------------------
Empty( Data )
DEFAULT aColor to ::acolor
Empty( nLen )
Empty( nangle )

if ::cunits="MM"
do case
   case litalic
     IF .not. lbold
   IF calign="R"
       textalign( 2 )
       @ nlin,ncol PRINT (ctext) font cfont size nsize ITALIC COLOR acolor
   ELSEIF calign="C"
       textalign( 1 )
       @ nlin,ncol PRINT (ctext) font cfont size nsize ITALIC COLOR acolor
   ELSE
       @ nlin,ncol PRINT (ctext) font cfont size nsize ITALIC COLOR acolor
   ENDIF
ELSE
   IF calign="R"
       textalign( 2 )
      @ nlin,ncol PRINT (ctext) font cfont size nsize  BOLD ITALIC COLOR acolor
   ELSEIF calign="C"
       textalign( 1 )
      @ nlin,ncol PRINT (ctext) font cfont size nsize  BOLD ITALIC COLOR acolor
   ELSE
      @ nlin,ncol PRINT (ctext) font cfont size nsize  BOLD ITALIC COLOR acolor
   ENDIF
ENDIF
   otherwise
IF .not. lbold
   IF calign="R"
       textalign( 2 )
       @ nlin,ncol PRINT (ctext) font cfont size nsize COLOR acolor
   ELSEIF calign="C"
       textalign( 1 )
       @ nlin,ncol PRINT (ctext) font cfont size nsize COLOR acolor
   ELSE
       @ nlin,ncol PRINT (ctext) font cfont size nsize COLOR acolor
   ENDIF
ELSE
   IF calign="R"
       textalign( 2 )
      @ nlin,ncol PRINT (ctext) font cfont size nsize  BOLD COLOR acolor
   ELSEIF calign="C"
       textalign( 1 )
      @ nlin,ncol PRINT (ctext) font cfont size nsize  BOLD COLOR acolor
   ELSE
      @ nlin,ncol PRINT (ctext) font cfont size nsize  BOLD COLOR acolor
   ENDIF
ENDIF
endcase

       textalign( 0 )

ELSE

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

ENDIF

RETURN self

*-------------------------
METHOD printimagex(nlin,ncol,nlinf,ncolf,cimage) CLASS TMINIPRINT
*-------------------------
if ::cunits="MM"
@ nlin,ncol PRINT IMAGE cimage WIDTH (ncolf - ncol) HEIGHT (nlinf - nlin) STRETCH
else
@ nlin*::nmver+::nvfij , ncol*::nmhor+::nhfij*2 PRINT IMAGE cimage WIDTH ((ncolf - ncol-1)*::nmhor + ::nhfij) HEIGHT ((nlinf+0.5 - nlin)*::nmver+::nvfij) STRETCH
endif
RETURN self


*-------------------------
METHOD printlinex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TMINIPRINT
*-------------------------
local vdespl:=1
DEFAULT atColor to ::acolor

if ::cunits="MM"
 @ nlin,ncol PRINT LINE TO nlinf,ncolf COLOR atcolor PENWIDTH ntwpen  //// CPEN
else
 @ nlin*::nmver*vdespl+::nvfij,ncol*::nmhor+::nhfij*2 PRINT LINE TO  nlinf*::nmver*vdespl+::nvfij,ncolf*::nmhor+::nhfij*2  COLOR atcolor PENWIDTH ntwpen  //// CPEN
endif

RETURN self

*-------------------------
METHOD printrectanglex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TMINIPRINT
*-------------------------
local vdespl:=1
DEFAULT atColor to ::acolor
if ::cunits="MM"
@ nlin,ncol PRINT RECTANGLE TO nlinf,ncolf COLOR atcolor PENWIDTH ntwpen  //// CPEN
else
@ nlin*::nmver*vdespl+::nvfij,ncol*::nmhor+::nhfij*2 PRINT RECTANGLE TO  nlinf*::nmver*vdespl+::nvfij,ncolf*::nmhor+::nhfij*2 COLOR atcolor  PENWIDTH ntwpen  //// CPEN
endif
RETURN self

*-------------------------
METHOD selprinterx( lselect , lpreview, llandscape , npapersize ,cprinterx,nres,nbin) CLASS TMINIPRINT
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
      DEFAULTSOURCE nbin ;
      PREVIEW
   ELSE
      SELECT PRINTER ::cprinter to lsucess ;
      ORIENTATION worientation ;
      QUALITY nres ;
      DEFAULTSOURCE nbin ;
      PREVIEW
   ENDIF
ENDIF

IF (.not. lselect) .and. lpreview .and. cprinterx = NIL

   IF npapersize#NIL
      SELECT PRINTER DEFAULT TO lsucess ;
      ORIENTATION worientation  ;
      PAPERSIZE npapersize       ;
      QUALITY nres ;
      DEFAULTSOURCE nbin ;
      PREVIEW
   ELSE
     SELECT PRINTER DEFAULT TO lsucess ;
     ORIENTATION worientation  ;
     QUALITY nres ;
     DEFAULTSOURCE nbin ;
     PREVIEW
   ENDIF
ENDIF

IF (.not. lselect) .and. (.not. lpreview) .and. cprinterx = NIL

   IF npapersize#NIL
      SELECT PRINTER DEFAULT TO lsucess  ;
      ORIENTATION worientation  ;
      QUALITY nres ;
      DEFAULTSOURCE nbin ;
      PAPERSIZE npapersize
   ELSE
      SELECT PRINTER DEFAULT TO lsucess  ;
      QUALITY nres ;
      DEFAULTSOURCE nbin ;
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
      DEFAULTSOURCE nbin ;
      PAPERSIZE npapersize
   ELSE
      SELECT PRINTER ::cprinter to lsucess ;
      QUALITY nres ;
      DEFAULTSOURCE nbin ;
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
      DEFAULTSOURCE nbin ;
      PREVIEW
   ELSE
      SELECT PRINTER cprinterx to lsucess ;
      ORIENTATION worientation ;
      QUALITY nres ;
      DEFAULTSOURCE nbin ;
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
      DEFAULTSOURCE nbin ;
      PAPERSIZE npapersize
   ELSE
      SELECT PRINTER cprinterx to lsucess ;
      QUALITY nres ;
      DEFAULTSOURCE nbin ;
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
local vdespl:=1  ////vdespl:=1.009
DEFAULT atColor to ::acolor
if ::cunits="MM"
@ nlin,ncol PRINT RECTANGLE TO nlinf,ncolf COLOR atcolor  PENWIDTH ntwpen  ROUNDED //// CPEN
else
@ nlin*::nmver*vdespl+::nvfij,ncol*::nmhor+::nhfij*2 PRINT RECTANGLE TO  nlinf*::nmver*vdespl+::nvfij,ncolf*::nmhor+::nhfij*2 COLOR atcolor  PENWIDTH ntwpen  ROUNDED //// CPEN
endif
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

method printbarcodex()

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
METHOD BEGINDOCx ( ) CLASS THBPRINTER
*-------------------------
::setpreviewsize(2)
START DOC NAME ::cargo
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
////RELEASE HBPRN  //// por si se tienen dos dialogos abiertos no se vaya el valor de la variable
RETURN self

*-------------------------
METHOD PRINTDATAx(nlin,ncol,data,cfont,nsize,lbold,acolor,calign,nlen,ctext,litalic,nangle) CLASS THBPRINTER
*-------------------------
Empty( Data )

DEFAULT aColor to ::acolor
Empty( nLen )

select font "F0"
change font "F0" name cfont size nsize angle nangle

IF lbold
   select font "F1"
   change font "F1" name cfont size nsize angle nangle BOLD
ENDIF

IF litalic
   IF lbold
      select font "F3"
      change font "F3" name cfont size nsize angle nangle BOLD ITALIC
   ELSE
      select font "F2"
      change font "F2" name cfont size nsize angle nangle ITALIC
   ENDIF
ENDIF

SET TEXTCOLOR acolor

if ::cunits="MM"
   if .not. lbold
      if calign="R"
   @ nlin,ncol SAY (ctext) ALIGN TA_RIGHT TO PRINT
      elseif calign="C"
   @ nlin,ncol SAY (ctext) ALIGN TA_CENTER TO PRINT
      else
   @ nlin,ncol SAY (ctext) TO PRINT
      endif
   else
      if calign="R"
   @ nlin,ncol  SAY (ctext) ALIGN TA_RIGHT TO PRINT
      elseif calign="C"
   @ nlin,ncol  SAY (ctext) ALIGN TA_CENTER TO PRINT
      else
   @ nlin,ncol  SAY (ctext) TO PRINT
      endif
   endif
else
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
endif
RETURN self

*------------------------------------------------------------
METHOD printbarcodex(y, x, y1, x1 ,acolor) CLASS THBPRINTER
*------------------------------------------------------------
DEFAULT aColor to ::acolor
DEFINE BRUSH "obrush" COLOR aColor style BS_SOLID
SELECT BRUSH "obrush"
@  y,x,y1,x1 FILLRECT BRUSH "obrush"
DEFINE BRUSH "obrush1" COLOR {255,255,255} style BS_SOLID
SELECT BRUSH "obrush1"
return self


*-------------------------
METHOD printimagex(nlin,ncol,nlinf,ncolf,cimage) CLASS thbprinter
*-------------------------
if ::cunits="MM"
@ nlin,ncol PICTURE cimage SIZE  (nlinf-nlin),(ncolf-ncol)
else
@ nlin*::nmver+::nvfij ,ncol*::nmhor+::nhfij*2 PICTURE cimage SIZE  (nlinf-nlin)*::nmver+::nvfij , (ncolf-ncol-3)*::nmhor+::nhfij*2
endif
RETURN self


*-------------------------
METHOD printlinex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS thbprinter
*-------------------------
local vdespl:=1
DEFAULT atColor to ::acolor
CHANGE PEN "C0" WIDTH ntwpen*10  COLOR atcolor
SELECT PEN "C0"
if ::cunits="MM"
@ nlin,ncol , nlinf,ncolf LINE PEN "C0"  //// CPEN
else
@ nlin*::nmver*vdespl+::nvfij,ncol*::nmhor+::nhfij*2 , nlinf*::nmver*vdespl+::nvfij,ncolf*::nmhor+::nhfij*2  LINE PEN "C0"  //// CPEN
endif
RETURN self

*-------------------------
METHOD printrectanglex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS THBPRINTER
*-------------------------
local vdespl:=1
DEFAULT atColor to ::acolor
CHANGE PEN "C0" WIDTH ntwpen*10 COLOR atcolor
SELECT PEN "C0"
if ::cunits="MM"
@ nlin,ncol , nlinf,ncolf  RECTANGLE  PEN "C0" //// CPEN  RECTANGLE  ///// [PEN <cpen>] [BRUSH <cbrush>]
else
@ nlin*::nmver*vdespl+::nvfij,ncol*::nmhor+::nhfij*2, nlinf*::nmver*vdespl+::nvfij, ncolf*::nmhor+::nhfij*2  RECTANGLE  PEN "C0" //// CPEN  RECTANGLE  ///// [PEN <cpen>] [BRUSH <cbrush>]
endif
RETURN self

*-------------------------
METHOD selprinterx( lselect , lpreview, llandscape , npapersize ,cprinterx,nres, nbin ) CLASS THBPRINTER
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
   SET QUALITY nres   ////:=PRINTER_RES_MEDIUM default
ENDIF

SET BIN nbin

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
local vdespl:=1  /////vdespl:=1.009
DEFAULT atColor to ::acolor
CHANGE PEN "C0" WIDTH ntwpen*10 COLOR atcolor
SELECT PEN "C0"
if ::cunits="MM"
hbprn:RoundRect( nlin,ncol ,nlinf,ncolf ,10, 10,"C0")
else
hbprn:RoundRect( nlin*::nmver*vdespl+::nvfij  ,ncol*::nmhor+::nhfij*2 ,nlinf*::nmver*vdespl+::nvfij ,ncolf*::nmhor+::nhfij*2 ,10, 10,"C0")
endif
RETURN self

CREATE CLASS TDOSPRINT FROM TPRINTBASE


DATA cString INIT ""
DATA cbusca INIT ""
DATA nOccur INIT 0
DATA cimpname INIT ""
DATA cportname INIT ""
DATA ctipoimp INIT ""
DATA liswin   INIT .F.
DATA cport    INIT "prn"

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
METHOD selprinterx( lselect , lpreview  , llandscape , npapersize ,cprinterx  ) CLASS TDOSPRINT
*-------------------------
/////Empty( lSelect
empty( lpreview )
empty(llandscape)
empty(npapersize)
default cprinterx to "prn"
::cport:= cprinterx

DO WHILE file(::tempfile)
   ::tempfile:=gettempdir()+"T"+alltrim(str(int(hb_random(999999)),8))+".prn"
ENDDO
//////////////////////////
if lselect

endif
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

CREATE CLASS TRAWPRINT FROM TDOSPRINT


METHOD EndDocx()

ENDCLASS

*-------------------------
METHOD enddocx() CLASS TRAWPRINT
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
   @ 250,nx-40 button but_3 caption "P" width 30 action (::printraw()) tooltip "Print RAW mode"
   @ 330,nx-40 button but_5 caption "S" width 30 action  (::searchstring(print_preview.edit_p.value)) tooltip "Search"
   @ 410,nx-40 button but_6 caption "N" width 30 action  ::nextsearch() tooltip "Next Search"

   END WINDOW

   CENTER WINDOW PRINT_PREVIEW
   ACTIVATE WINDOW PRINT_PREVIEW

ELSE

  ::PRINTRAW()

ENDIF

IF FILE(::tempfile)
   fclose(_nhandle)
   ERASE &(::tempfile)
ENDIF

RETURN self


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

ENDCLASS

*-------------------------
METHOD initx() CLASS TEXCELPRINT
*-------------------------
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

#ifndef __XHARBOUR__
IF ( ::oExcel := win_oleCreateObject( "Excel.Application" ) ) = NIL
#else
::oExcel := TOleAuto():New( "Excel.Application" )
IF Ole2TxtError() != 'S_OK'
#endif
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
::oExcel:visible:=.F.
::oHoja:=::oExcel:ActiveSheet()
::oHoja:Name := ::cargo
::oHoja:Cells:Font:Name := ::cfontname
::oHoja:Cells:Font:Size := ::nfontsize
RETURN self


*-------------------------
METHOD enddocx() CLASS TEXCELPRINT
*-------------------------
local nCol,cName,nNum,cExt
FOR nCol:=1 TO ::oHoja:UsedRange:Columns:Count()
    ::oHoja:Columns( nCol ):AutoFit()
NEXT

 //    aVersion := {    ;
 //           {"12.0","2007"}    ,;
 //           {"11.0","2003"}    ,;
 //           {"10.0","2002/XP"}    ,;
 //           {"9.0","2000"}    ,;
 //          {"8.0","97"}    ,;
 //           {"7.0","95"}    ,;
 //           {"6.0","6"}}


 ::oExcel:DisplayAlerts :=.F.
 ::oHoja:Cells( 1, 1 ):Select()
 ::oExcel:visible:=.F.

  if val(::oExcel:version) > 11.5
     nNum:= 46    /// creoo
     cext:="xlsx"
  else
     nNum:=39
     cext:="xls"
  endif

 cName:=Parsename(::cargo,cext)

  ::oHoja:Saveas(cName)
 ///  ::oHoja:Saveas(cName, nNum ,"","", .f. , .f.)

  inkey(1)
  ::oExcel:Quit()
  ::ohoja := nil
  ::oExcel := nil

IF ::impreview
   IF ShellExecute(0, "open", "rundll32.exe", "url.dll,FileProtocolHandler "+ cName, ,1) <=32
       MSGINFO("XLS Extension not asociated"+CHR(13)+CHR(13)+ ;
       "File saved in:"+CHR(13)+cName)
   ENDIF
ENDIF
//////////////////////////
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
METHOD printimagex(nlin,ncol,nlinf,ncolf,cimage) CLASS TEXCELPRINT
*-------------------------
local cfolder :=  getcurrentfolder()+"\"
local ccol,clin
local crango
empty(nlinf)

if nlin<1
   nlin:=1
endif
if ncol<1
   ncol:=1
endif
nlin++
IF ::nunitslin>1
   nlin:=round(nlin/::nunitslin,0)
   ncol:=round(ncol/::nunitslin,0)
ENDIF

ncolf:=nlin

clin :=alltrim(str(nlin))

ccol :=alltrim(str(ncolf))


crango := "A"+clin
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

*-------------------------
METHOD endpagex() CLASS TEXCELPRINT
*-------------------------
::nlinpag:=LEN(::alincelda)+1
::alincelda:={}
RETURN self

// Label Header
#define TXT_ELEMS   12
#define TXT_OPCO1    1
#define TXT_OPCO2    2
#define TXT_LEN1     3
#define TXT_LEN2     4
#define TXT_ROW1     5
#define TXT_ROW2     6
#define TXT_COL1     7
#define TXT_COL2     8
#define TXT_RGBAT1   9
#define TXT_RGBAT2  10
#define TXT_RGBAT3  11
#define TXT_LEN     12

///////////////////////
CREATE CLASS TSPREADSHEETPRINT FROM TPRINTBASE     //// Ciro 2011/8/19

    DATA aDoc  INIT {}
    DATA nXls  INIT 0
    DATA nlinrel INIT 0
    DATA nlpp  INIT 60          /// lines per page

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
METHOD beginpagex() BLOCK {|| NIL }
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
METHOD printimagex() BLOCK {|| NIL }
*-------------------------

*-------------------------
METHOD printlinex() BLOCK {|| NIL }
*-------------------------

*-------------------------
METHOD printrectanglex BLOCK {|| NIL }
*-------------------------

*-------------------------
METHOD selprinterx()    BLOCK {|| NIL }
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

*--------------------
method addpage()
*--------------------

ENDCLASS


*-------------------------
METHOD initx() CLASS TSPREADSHEETPRINT
*-------------------------
::cprintlibrary:="SPREADSHEETPRINT"
RETURN self

*-----------------------
method addpage()
*-----------------------
local i
for i:=1 to ::nlpp
   aadd(::Adoc,space(300))
next i
return nil

*-------------------------
METHOD begindocx() CLASS TSPREADSHEETPRINT
*-------------------------
local cName
local cBof := Chr(  9 ) + Chr(  0 ) + Chr(  4 ) + Chr(  0 ) +  Chr(  2 ) + Chr(  0 ) + Chr( 10 ) + Chr(  0 )

cName:=Parsename(::cargo,"XLS")
::nXls := fCreate( cName )
fWrite( ::nXls, cBof, Len( cBof ))

::addpage()

RETURN self


*-------------------------
METHOD enddocx() CLASS TSPREADSHEETPRINT
*-------------------------
local cname
local i
local anHeader
local nLen
local nI
local ceof

for i:=1 to len(::aDoc)

////////////////////////

  //---------------------------------------------------
  // Arreglo para almacenar el marcador de registro
  // etiqueta
  //---------------------------------------------------
  anHeader               := Array( TXT_ELEMS )
  anHeader[ TXT_OPCO1  ] :=  4
  anHeader[ TXT_OPCO2  ] :=  0
  anHeader[ TXT_LEN1   ] := 10
  anHeader[ TXT_LEN2   ] :=  0
  anHeader[ TXT_ROW2   ] :=  0
  anHeader[ TXT_COL2   ] :=  0
  anHeader[ TXT_RGBAT1 ] :=  0
  anHeader[ TXT_RGBAT2 ] :=  0
  anHeader[ TXT_RGBAT3 ] :=  0
  anHeader[ TXT_LEN    ] :=  2

  nLen 		       := Len( rtrim(::aDoc[i]) )

  //------------------------------
  // Longitud del texto a escribir
  //------------------------------
  anHeader[ TXT_LEN ]    := nLen

  //----------------------
  // Longitud del registro
  //----------------------
  anHeader[ TXT_LEN1 ]   := 8 + nLen

  //---------------------------------------------
  // En le formato BIFF se comienza desde cero y
  // no desde 1 como estamos pasando los datos
  //---------------------------------------------
  nI                     := i - 1
  anHeader[ TXT_ROW1 ]   := nI   - (Int( nI / 256 ) * 256 )
  anHeader[ TXT_ROW2 ]   := Int( nI / 256 )
  anHeader[ TXT_COL1 ]   := 1 - 1

  //-------------------
  // Escribe encabezado
  //-------------------
  Aeval( anHeader, { | v | fWrite( ::nXls, Chr( v ), 1 )})

  //-----------------------------------------------------
  // Escribe la data
  //-----------------------------------------------------
  for nI:=1 to nLen
    fWrite( ::nXls, SubStr( rtrim(::aDoc[i]), nI, 1 ), 1 )
  next nI

////////////////////////

next i

cEof := Chr( 10 ) + Chr( 0 ) + Chr( 0 ) + Chr( 0 )

fWrite( ::nXls, cEof, Len( cEof ))
fClose( ::nXls )


cName:=Parsename(::cargo,"XLS")

IF ::impreview
   IF ShellExecute(0, "open", "rundll32.exe", "url.dll,FileProtocolHandler "+ cName, ,1) <=32
       MSGINFO("XLS Extension not asociated"+CHR(13)+CHR(13)+ ;
       "File saved in:"+CHR(13)+cName)
   ENDIF
ENDIF

RETURN self

*-------------------------
METHOD releasex() CLASS TSPREADSHEETPRINT
*-------------------------
release( ::nXls )
RETURN self


*-------------------------
METHOD printdatax(nlin,ncol,data,cfont,nsize,lbold,acolor,calign,nlen,ctext,litalic) CLASS TSPREADSHEETPRINT
*-------------------------
local clineai,clineaf
Empty( cfont )
Empty( nsize )
Empty( lbold )
Empty( acolor )
Empty( calign )
Empty( nlen )
Empty( ctext )
Empty( litalic )
nlin++
data:=autotype(data)
clineai:=::aDoc[nlin+::nlinrel]
clineaf:=STUFF(clineai, ncol, len(data), data)
::aDoc[nlin+::nlinrel]:= clineaf
RETURN self


*-------------------------
METHOD endpagex() CLASS TSPREADSHEETPRINT
*-------------------------
::nlinrel:=::nlinrel+::nlpp
::addpage()
RETURN self

////////////////////////

CREATE CLASS THTMLPRINT FROM TEXCELPRINT

*-------------------------
METHOD enddocx()
*-------------------------

ENDCLASS

METHOD enddocx() CLASS THTMLPRINT
local nCol,cName
For nCol:= 1 to ::oHoja:UsedRange:Columns:Count()
    ::oHoja:Columns( nCol ):AutoFit()
NEXT
::oHoja:Cells( 1, 1 ):Select()

cName:=Parsename(::cargo,"html")
::oExcel:DisplayAlerts :=.F.


::oHoja:SaveAs(cName, 44,"","", .f. , .f.)

::oExcel:Quit()
::ohoja := nil
::oExcel := nil
IF ::impreview
   IF ShellExecute(0, "open", "rundll32.exe", "url.dll,FileProtocolHandler "+ cName, ,1) <=32
       MSGINFO("html Extension not asociated"+CHR(13)+CHR(13)+ ;
       "File saved in:"+CHR(13)+cName)
   ENDIF
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


ENDCLASS


*-------------------------
METHOD initx() CLASS TRTFPRINT
*-------------------------
::cprintlibrary:="RTFPRINT"
RETURN self

*-------------------------
METHOD begindocx( ) CLASS TRTFPRINT
*-------------------------
local   MARGENSUP:=LTRIM(STR(ROUND(15*56.7,0)))
local   MARGENINF:=LTRIM(STR(ROUND(15*56.7,0)))
local   MARGENIZQ:=LTRIM(STR(ROUND(10*56.7,0)))
local   MARGENDER:=LTRIM(STR(ROUND(10*56.7,0)))

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
RUTAFICRTF1:=Parsename(::cargo,"rtf")
SET PRINTER TO &(RUTAFICRTF1)
SET DEVICE TO PRINTER
SETPRC(0,0)
FOR nTRTFPRINT=1 TO LEN(oPrintRTF1)
@ PROW(),PCOL() SAY oPrintRTF1[nTRTFPRINT]
@ PROW()+1,0 SAY ""
NEXT
SET DEVICE TO SCREEN
SET PRINTER TO
RELEASE oPrintRTF1,oPrintRTF2,oPrintRTF3
IF ::impreview
   IF ShellExecute(0, "open", "rundll32.exe", "url.dll,FileProtocolHandler "+ RUTAFICRTF1 , ,1) <=32
         MSGINFO("RTF Extension not asociated"+CHR(13)+CHR(13)+ ;
         "File saved in:"+CHR(13)+rutaficrtf1)
   ENDIF
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

ENDCLASS


*-------------------------
METHOD initx() CLASS TCSVPRINT
*-------------------------
::impreview:=.F.
::cprintlibrary:="CSVPRINT"
RETURN self


*-------------------------
METHOD begindocx( ) CLASS TCSVPRINT
*-------------------------
////cDoc:= ::cargo
RETURN self


*-------------------------
METHOD enddocx() CLASS TCSVPRINT
*-------------------------
RUTAFICRTF1:=Parsename(::cargo,"csv")
SET PRINTER TO &(RUTAFICRTF1)
SET DEVICE TO PRINTER
SETPRC(0,0)
FOR nTCSVPRINT=1 TO LEN(oPrintCSV1)
@ PROW(),PCOL() SAY oPrintCSV1[nTCSVPRINT]
@ PROW()+1,0 SAY ""
NEXT
SET DEVICE TO SCREEN
SET PRINTER TO
RELEASE oPrintCSV1,oPrintCSV2,oPrintCSV3

IF ::impreview
   IF ShellExecute(0, "open", "rundll32.exe", "url.dll,FileProtocolHandler "+ RUTAFICRTF1 , ,1) <=32
         MSGINFO("CSV Extension not asociated"+CHR(13)+CHR(13)+ ;
         "File saved in:"+CHR(13)+rutaficrtf1)
   ENDIF
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
method printbarcodex()
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

//// 1) nombre normal         prueba.xxx
//// 2) nombre con ruta       c:\tmp\prueba.xxx
//// 3) sin nombre            -------


STATIC FUNCTION PARSENAME( cname, cext, invslash )
local x,longname,lext,y

default invslash to .F.
cext:=lower(cext)

//// quitar la extension si la hay
 y:=at( ".",cname)
 if y>0
   cname:=substr(cname,1,y-1)
 endif
x:=rat( "\",cname)
if x=0
   longname :=  Getmydocumentsfolder()+"\"+cname
else
   longname := cname
endif
lext:=len(cext)   /// largo extension
if right(longname,lext)<>"."+cext
   longname:=longname+"."+cext
endif
if invslash
 longname:=strtran(longname,"\","/")
endif
return longname


*-------------------------
METHOD BEGINDOCx () CLASS TPDFPRINT
*-------------------------
::cDocument:=Parsename(::cargo,"pdf")
::oPdf := TPDF():init(::cDocument)
RETURN self


*-------------------------
METHOD ENDDOCx() CLASS TPDFPRINT
*-------------------------
::oPdf:Close()
IF ::imPreview
   IF ShellExecute(0, "open", "rundll32.exe", "url.dll,FileProtocolHandler "+ ::cDocument , ,1) <=32
       MSGINFO("PDF Extension not asociated"+CHR(13)+CHR(13)+ ;
       "File saved in: "+CHR(13)+::cDocument)
   ENDIF
endif
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

DEFAULT aColor to ::acolor

if .not. hb_islogical(lBold)
   lbold:=.f.
endif

if .not. hb_islogical(lItalic)
   lItalic:=.f.
endif


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

METHOD printbarcodex(nlin, ncol, nlinf, ncolf ,atcolor) CLASS TPDFPRINT
local cColor  := ""
local i
DEFAULT atColor to ::acolor

For Each I in atColor
    cColor += Chr(I)
Next
::oPdf:Box(nlin,ncol , nlinf,ncolf, 0,1,"M",cColor,"t1")

RETURN self



*-------------------------
METHOD printimagex(nlin,ncol,nlinf,ncolf,cimage) CLASS TPDFPRINT
*-------------------------
local vdespl  := 0.980
local hdespl  := 1.300

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
   hdespl:=1
   ::oPdf:Image( cImage, nlin,ncol,"M",nlinf,ncolf)
ELSE
   ::oPdf:Image( cImage,   nlin*::nmver*vdespl +::nvfij   ,ncol*::nmhor+ ::nhfij*hdespl,"M"   ,nlinf*::nmver*vdespl+::nvfij   ,ncolf*::nmhor+ ::nhfij*hdespl)
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
DEFAULT atColor to ::acolor

Default ntwpen to ::nwpen

For Each I in atColor
    cColor += Chr(I)
Next

IF ::cunits=="MM"
      ::oPdf:Box((nlin-0.9)+::nvfij,(ncol+1.3) + ::nhfij,  (nlinf-0.9)+::nvfij,(ncolf+1.3)+ ::nhfij, ntwpen*1.2 ,0,"M","B","t1")
ELSE
    ::oPdf:Box((nlin-0.9)*::nmver+::nvfij,(ncol+1.3)*::nmhor + ::nhfij,  (nlinf-0.9)*::nmver+::nvfij,(ncolf+1.3)*::nmhor+ ::nhfij, ntwpen*1.2 ,0,"M","B","t1")
ENDIF

RETURN self

*-------------------------
METHOD printroundrectanglex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TPDFPRINT
*-------------------------
/////*Que hace esto?  hace un rectangulo con bordes redondeados pero como aqui no se puede va sin redondeo
   ::printrectanglex(nlin,ncol,nlinf,ncolf,atcolor,ntwpen )
RETURN self


*-------------------------
METHOD selprinterx( lselect , lpreview, llandscape , npapersize ) CLASS TPDFPRINT
*-------------------------
local nPos := 0

EMPTY( lpreview )

Default llandscape to .f.
Default npapersize to 0

empty( lselect )

/*lSelect no lo tomamos en cuenta aqui*/

*----Si se va a necesitar abrir el pdf al finalizar la generacion------*
::lPreview := ::impreview
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

ENDCLASS


*-------------------------
METHOD initx() CLASS TCALCPRINT
*-------------------------
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
   MsgStop('OpenOficce Calc not found','error')
   RETURN Nil
ENDIF
return self

*-------------------------
METHOD begindocx() CLASS TCALCPRINT
*-------------------------
local laPropertyValue:= array(10)

laPropertyValue[1]= ::oServiceManager:Bridge_GetStruct( "com.sun.star.beans.PropertyValue" )
laPropertyValue[1]:name = "Hidden"
laPropertyValue[1]:value = .T.

::oDocument := ::oDesktop:loadComponentFromURL("private:factory/scalc","_blank", 0, @laPropertyValue )
::oSchedule := ::oDocument:GetSheets()
::oSheet := ::oSchedule:GetByIndex(0)
*::oSheet:CharFontName := ::cfontname
*::oSheet:CharHeight   := ::nfontsize
return self


*-------------------------
METHOD enddocx() CLASS TCALCPRINT
*-------------------------
local cname
::oSheet:getColumns():setPropertyValue("OptimalWidth", .T.)
cname:=parsename(::cargo,"odt",.T.)

::oDocument:storeToURL("file:///"+cname, {})
 inkey(0.5)

::oDocument:close( 1 )
::oServiceManager := nil
::oDesktop := nil
::oDocument := nil
::oSchedule := nil
::oSheet := nil
::oCell := nil
::oColums := nil
::oColumn := nil

IF ::imPreview
   cname:=parsename(::cargo,"odt")
   IF ShellExecute(0, "open", "rundll32.exe", "url.dll,FileProtocolHandler " + cname , ,1) <=32
       MSGINFO("PDF Extension not asociated"+CHR(13)+CHR(13)+ ;
       "File saved in: "+CHR(13)+ cname)
   ENDIF
ENDIF

RETURN self


*-------------------------
METHOD releasex() CLASS TCALCPRINT
*-------------------------

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





//////////////////////////// codigos de barra


#define abar  {"101010001110",;
              "101011100010",;
              "101000101110",;
              "111000101010",;
              "101110100010",;
              "111010100010",;
              "100010101110",;
              "100010111010",;
              "100011101010",;
              "111010001010",;
              "101000111010",;
              "101110001010",;
              "11101011101110",;
              "11101110101110",;
              "11101110111010",;
              "10111011101110",;
              "10111000100010",;
              "10001000101110",;
              '10100011100010',;
              '10111000100010',;
              '10001000101110',;
              '10100010001110',;
              '10100011100010'}

#define cChar  '0123456789-$:/.+ABCDTN*E'

// importante, this system not test de start /end code.

function _codabar( cCode )
    local n, cBarra := '', nCar
    cCode := upper( cCode )
    for n:=1 to len( cCode )
        if (nCar:=at(substr(cCode,n,1),cChar)) > 0
            cBarra += abar[ nCar ]
        endif
    next
return cBarra

#define aCode  {"212222",;
                   "222122",;
                   "222221",;
                   "121223",;
                   "121322",;
                   "131222",;
                   "122213",;
                   "122312",;
                   "132212",;
                   "221213",;
                   "221312",;
                   "231212",;
                   "112232",;
                   "122132",;
                   "122231",;
                   "113222",;
                   "123122",;
                   "123221",;
                   "223211",;
                   "221132",;
                   "221231",;
                   "213212",;
                   "223112",;
                   "312131",;
                   "311222",;
                   "321122",;
                   "321221",;
                   "312212",;
                   "322112",;
                   "322211",;
                   "212123",;
                   "212321",;
                   "232121",;
                   "111323",;
                   "131123",;
                   "131321",;
                   "112313",;
                   "132113",;
                   "132311",;
                   "211313",;
                   "231113",;
                   "231311",;
                   "112133",;
                   "112331",;
                   "132131",;
                   "113123",;
                   "113321",;
                   "133121",;
                   "313121",;
                   "211331",;
                   "231131",;
                   "213113",;
                   "213311",;
                   "213131",;
                   "311123",;
                   "311321",;
                   "331121",;
                   "312113",;
                   "312311",;
                   "332111",;
                   "314111",;
                   "221411",;
                   "431111",;
                   "111224",;
                   "111422",;
                   "121124",;
                   "121421",;
                   "141122",;
                   "141221",;
                   "112214",;
                   "112412",;
                   "122114",;
                   "122411",;
                   "142112",;
                   "142211",;
                   "241211",;
                   "221114",;
                   "213111",;
                   "241112",;
                   "134111",;
                   "111242",;
                   "121142",;
                   "121241",;
                   "114212",;
                   "124112",;
                   "124211",;
                   "411212",;
                   "421112",;
                   "421211",;
                   "212141",;
                   "214121",;
                   "412121",;
                   "111143",;
                   "111341",;
                   "131141",;
                   "114113",;
                   "114311",;
                   "411113",;
                   "411311",;
                   "113141",;
                   "114131",;
                   "311141",;
                   "411131",;
                   "211412",;
                   "211214",;
                   "211232",;
                   "2331112"}


function _code128(cCode,cMode)

    local nSum:=0, cBarra, cCar
    local cTemp, n, nCAr, nCount:=0
    local lCodeC := .f. ,lCodeA:= .f.


    // control de errores
    if valtype(cCode) !='C'
        msginfo('Barcode c128 required a Character value. ')
        return nil
    end
    if !empty(cMode)
        if valtype(cMode)='C' .and. Upper(cMode)$'ABC'
            cMode := Upper(cMode)
        else
            msginfo('Code 128 Modes are A,B o C. Character values.')
        end
    end
    if empty(cMode) // modo variable
        // an lisis de tipo  de c¢digo...
        if str(val(cCode),len(cCode))=cCode // s¢lo n£meros
            lCodeC := .t.
            cTemp:=aCode[106]
            nSum := 105
        else
            for n:=1 to len(cCode)
                nCount+=if(substr(cCode,n,1)>31,1,0) // no cars. de control
            end
            if nCount < len(cCode) /2
                lCodeA := .t.
                cTemp := aCode[104]
                nSum := 103
            else
                cTemp := aCode[105]
                nSum := 104
            end
        end
    else
        if cMode =='C'
            lCodeC := .t.
            cTemp:=aCode[106]
            nSum := 105
        elseif cMode =='A'
            lCodeA := .t.
            cTemp := aCode[104]
            nSum := 103
        else
            cTemp := aCode[105]
            nSum := 104
        end
    end

    nCount := 0 // caracter registrado
    for n:= 1 to len(cCode)
        nCount ++
        cCar := substr(cCode,n,1)
        if lCodeC
            if len(cCode)=n  // ultimo caracter
                CTemp += aCode[101] // SHIFT Code B
                nCar := asc(cCar)-31
            else
                nCar := Val(substr(cCode,n,2))+1
                n++
            end
        elseif lCodeA
            if cCar> '_' // Shift Code B
                cTemp += aCode[101]
                nCar := asc(cCar)-31
            elseif cCar <= ' '
                nCar := asc(cCar)+64
            else
                nCar := asc(cCar)-31
            endif
        else // code B standard
            if cCar <= ' ' // shift code A
                cTemp += aCode[102]
                nCar := asc(cCar)+64
            else
                nCar := asc(cCar)-31
            end
        endif
        nSum += (nCar-1)*nCount
        cTemp := cTemp +aCode[nCar]
    next
    nSum := nSum%103 +1
    cTemp := cTemp + aCode[ nSum ] +aCode[107]
    cBarra := ''
    for n:=1 to len(cTemp) step 2
        cBarra+=replicate('1',val(substr(cTemp,n,1)))
        cBarra+=replicate('0',val(substr(cTemp,n+1,1)))
    next
return cBarra



function _Code3_9( cCode, lCheck )
    static cCars := '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ-. *$/+%'
    STATIC aBarras:={'1110100010101110',;
                     '1011100010101110',;
                     '1110111000101010',;
                     '1010001110101110',;
                     '1110100011101010',;
                     '1011100011101010',;
                     '1010001011101110',;
                     '1110100010111010',;
                     '1011100010111010',;
                     '1010001110111010',;
                     '1110101000101110',;
                     '1011101000101110',;
                     '1110111010001010',;
                     '1010111000101110',;
                     '1110101110001010',;//E
                     '1011101110001010',;
                     '1010100011101110',;
                     '1110101000111010',;
                     '1011101000111010',;
                     '1010111000111010',;
                     '1110101010001110',; //K
                     '1011101010001110',;
                     '1110111010100010',;
                     '1010111010001110',;
                     '1110101110100010',;
                     '1011101110100010',;//p
                     '1010101110001110',;
                     '1110101011100010',;
                     '1011101011100010',;
                     '1010111011100010',;
                     '1110001010101110',;
                     '1000111010101110',;
                     '1110001110101010',;
                     '1000101110101110',;
                     '1110001011101010',;
                     '1000111011101010',;//Z
                     '1000101011101110',;
                     '1110001010111010',;
                     '1000111010111010',; // ' '
                     '1000101110111010',;
                     '1000100010100010',;
                     '1000100010100010',;
                     '1000101000100010',;
                     '1010001000100010'}

    local cCar,m, n, cBarra := '',  nCheck := 0

    default lCheck := .f.
    cCode := upper(cCode)
    if len(cCode )>32
        cCode := left(cCode,32)
    end
    cCode := '*'+cCode+'*'
    for n:= 1 to len( cCode )
        cCar := substr( cCode,n,1)
        m:=at( cCar, cCars )
        if n>0 // otros caracteres se ignoran :-))
            cBarra := cBarra + aBarras[m]
            nCheck += (m-1)
        end
    next

   if lCheck
    cBarra+= aBarras[nCheck%43 +1]
   end
return cBarra


// genera codigo ean13





function _ean13( cCode )
   local cadena, Numero
   local Izda, Dcha, String, Mascara, k  ,n
   k:=left(alltrim(cCode)+'000000000000',12)     // padding with '0'
   // calculo del digito de control
   k:=k+EAN13_CHECK(k)                           // Chaeck Digit en EAN13
   // preparacion de la cadena de impresion
   cadena:=[]
   dcha:=SUBSTR(K,8,6)
   izda:=substr(k,2,6)
   mascara:=substr(primero,(val(substr(k,1,1))*6)+1,6)
   *  ? mascara
   // barra de delimitacion
   cadena:=[101]
   // parte izda
   for n=1 to 6
      numero:=val(substr(izda,n,1))
      if substr(mascara,n,1)=[o]
         string:=substr(izda1,numero*7+1,7)
      else
         string:=substr(izda2,numero*7+1,7)
      end
      *  ? strzero(numero,1)+[->]+string
      cadena:=cadena+string

   next
   cadena:=cadena+[01010]
   // LADO DERECHO
   for n=1 to 6
      numero:=val(substr(dcha,n,1))
      string:=substr(derecha,numero*7+1,7)
      *  ? strzero(numero,1)+[->]+string
      cadena:=cadena+string
   next
   cadena:=cadena+[101]
   *  ? cadena
   *  cadena:=cadena+[101]
return Cadena


FUNCTION EAN13_CHECK(cCode)
   local s1,s2,l,Control,n
   s1:=0                                         // suma de impares
   s2:=0                                         // suma de pares
   for n=1 to 6
      s1:=s1+val(substr(cCode,(n*2)-1,1))
      s2:=s2+val(substr(cCode,(n*2),1))
   next
   control:=(s2*3)+s1
   l:=10
   do while control>l
      l:=l+10
   end
   control:=l-control

RETURN sTr(control,1,0)


function _ean13BL(nLen)
   nLen:=int(nLen/2)
return '101'+replicate('0',nLen*7)+'01010'+replicate('0',nLen*7)+'101'


function _UPC( cCode, nLen )
   local n,cadena, Numero
   local Izda, Dcha, k
   default nLen to 11
   default cCode to '0'
   // valid values for nLen are 11,7
   nLen:=if(nlen=11,11,7)
   k:=left(alltrim(cCode)+'000000000000',nLen)   // padding with '0'
   // calculo del digito de control
   k=k+Upc_CHECK(cCode,nLen)                     // cCode,nLen
   nLen++
   // preparacion de la cadena de impresion
   cadena:=[]
   dcha:=Right(K,nLen/2)
   izda:=Left(k,nLen/2)
   // barra de delimitacion
   cadena:=[101]
   // parte izda
   for n=1 to len(Izda)
      numero:=val(substr(izda,n,1))
      cadena+=substr(izda1,numero*7+1,7)
   next
   cadena:=cadena+[01010]
   // LADO DERECHO
   for n=1 to len(dcha)
      numero:=val(substr(dcha,n,1))
      cadena+=substr(derecha,numero*7+1,7)
   next
   cadena:=cadena+[101]
return Cadena

function _UPCABL()
   local cadena
   cadena:=[101]
   // parte izda
      //cadena+=substr(izda1,val(left(k,1))*7+1,7)
      cadena+=replicate('0',42) // resto
   cadena:=cadena+[01010] //centro
   // LADO DERECHO
      cadena+=replicate('0',42) // resto
      //cadena+=substr(derecha,val(right(k,1))*7+1,7)
   cadena:=cadena+[101]
return Cadena

Function Upc_CHECK(cCode,nLen)
   local s1,s2,n,l,control
   s1:=0                                         // suma de impares
   s2:=0                                         // suma de pares
   for n=1 to nLen step 2
      s1:=s1+val(substr(cCode,n,1))
      s2:=s2+val(substr(cCode,n+1,1))
   next
   control:=(s1*3)+s2
   l:=10
   do while control>l
      l:=l+10
   end
   control:=l-control

   return str(Control,1,0)

// suplemento de 5 digitos

function _Sup5(cCode)
   local k, control, n, cBarras := '1011',nCar
   static parity:=[eeoooeoeooeooeoeoooeoeeooooeeooooeeoeoeooeooeooeoe]
   k:=left(alltrim(cCode)+'00000',5)             // padding with '0'
   control := right( str( val(substr(k,1,1))*3 + val(substr(k,3,1))*3 ;
      + val(substr(k,5,1))*3 + val(substr(k,2,1))*9+;
      val(substr(k,4,1))*9,5,0 ),1)
   control:=substr(primero,val(control)*6+2,5)
   for n:=1 to 5
      nCar:=val(substr(k,n,1))
      if substr(control,n,1)='o'
         cBarras+=substr(izda2,nCar*7+1,7)
      else
         cBarras+=substr(izda1,nCar*7+1,7)
      end
      if n<5
         cBarras+='01'
      end
   next
return cBarras
// imprime un codigo



function _int25(cCode,lMode)
local aBar:={"00110","10001",'01001','11000','00101','10100','01100',;
              '00011','10010','01010'}
local cStart:='0000'
local cStop:='100'
local cMtSt:='10000' // matrix start/stop
local cInStart := '110' // industrial 2 of 5 start
local cInStop := '101' // industrial 2 of 5 stop

    local n,cBar:='', cIz:='',cDer:='',nLen:=0,nCheck:=0,cBarra:=''
    local m

    default lMode to .t.

    cCode:=trans(cCode,'@9') // elimina caracteres

	nLen:=len(cCode)
    if (nLen%2=1 .and. !lMode)
        nLen++
        cCode+='0'
    end
	
    if lMode
		if nLen%2=0 
			nLen++
			cCode='0'+cCode
		end
		for n:=1 to len(cCode) step 2
            nCheck+=val(substr(cCode,n,1))*3+val(substr(cCode,n+1,1))
        next
        cCode += right(str(nCheck,10,0),1)
    end

 
    cBarra:= cStart
    // preencoding .. interleaving

    for n:=1 to nLen step 2
        cIz:=aBar[val(substr(cCode,n,1))+1]
        cDer:=aBar[val(substr(cCode,n+1,1))+1]
        for m:=1 to 5
            cBarra+=substr(cIz,m,1)+substr(cDer,m,1)
        next
    next
    cBarra+=cStop
    for n:=1 to len(cBarra) step 2
        if substr(cBarra,n,1)='1'
            cBar+='111'
        else
            cBar+='1'
        end
        if substr(cBarra,n+1,1)='1'
            cBar+='000'
        else
            cBar+='0'
        end
    next
return cBar

function _MAT25(cCode,lCheck)
local aBar:={"00110","10001",'01001','11000','00101','10100','01100',;
              '00011','10010','01010'}
local cStart:='0000'
local cStop:='100'
local cMtSt:='10000' // matrix start/stop
local cInStart := '110' // industrial 2 of 5 start
local cInStop := '101' // industrial 2 of 5 stop

    local cBar:='',cBarra:='', nCheck,n
    default lCheck to .f.
    cCode:=trans(cCode,'@9') // only digits
    if lCheck
        for n:=1 to len(cCode) step 2
            nCheck+=val(substr(cCode,n,1))*3+val(substr(cCode,n+1,1))
        next
        cCode += right(str(nCheck,10,0),1)
    end
    cBar:=cMtSt
    for n:=1 to len(cCode)
        cBar+=aBar[val(substr(cCode,n,1))+1]+'0'
    next
    cBar+=cMtSt
    for n:=1 to len(cBar) step 2
        if substr(cBar,n,1)='1'
            cBarra+='111'
        else
            cBarra+='1'
        end
        if substr(cBar,n+1,1)='1'
            cBarra+='000'
        else
            cBarra+='0'
        end
    next
return cBarra

function _Ind25(cCode,lCheck)
local aBar:={"00110","10001",'01001','11000','00101','10100','01100',;
              '00011','10010','01010'}
local cStart:='0000'
local cStop:='100'
local cMtSt:='10000' // matrix start/stop
local cInStart := '110' // industrial 2 of 5 start
local cInStop := '101' // industrial 2 of 5 stop

    local cBar:='',cBarra:='', nCheck,n
    default lCheck to .f.
    cCode:=trans(cCode,'@9') // only digits
    if lCheck
        for n:=1 to len(cCode) step 2
            nCheck+=val(substr(cCode,n,1))*3+val(substr(cCode,n+1,1))
        next
        cCode += right(str(nCheck,10,0),1)
    end
    cBar:=cInStart
    for n:=1 to len(cCode)
        cBar+=aBar[val(substr(cCode,n,1))+1]+'0'
    next
    cBar+=cInStop
    for n:=1 to len(cBar)
        if substr(cBar,n,1)='1'
            cBarra+='1110'
        else
            cBarra+='10'
        end
    next
return cBarra


