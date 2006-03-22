/*
* $Id: h_print.prg,v 1.24 2006-03-22 16:57:07 declan2005 Exp $
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

MEMVAR o_prin_

CREATE CLASS TPRINT

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
DATA cversion           INIT  "(oohg)V 1.16" READONLY


*-------------------------
METHOD init()
*-------------------------
*-------------------------
METHOD begindoc()
*-------------------------
*-------------------------
METHOD enddoc()
*-------------------------

*-------------------------
method printdos()
*-------------------------
*-------------------------
METHOD beginpage()
*-------------------------

*-------------------------
METHOD condendos() INLINE NIL
*-------------------------

*-------------------------
METHOD NORMALDOS() INLINE NIL
*-------------------------

*-------------------------
METHOD endpage()
*-------------------------
*-------------------------
METHOD release()
*-------------------------
*-------------------------
METHOD printdata()
*-------------------------
*-------------------------
METHOD printimage
*-------------------------
*-------------------------
METHOD printline
*-------------------------

*-------------------------
METHOD printrectangle
*-------------------------

*-------------------------
METHOD selprinter()
*-------------------------

*-------------------------
METHOD getdefprinter()
*-------------------------

*-------------------------
METHOD setcolor()
*-------------------------

*-------------------------
METHOD setpreviewsize()
*-------------------------

*-------------------------
METHOD setunits()   ////// mm o rowcol
*-------------------------

*-------------------------
METHOD printroundrectangle()
*-------------------------

METHOD version() INLINE ::cversion

ENDCLASS

*-------------------------

*-------------------------
METHOD setpreviewsize(ntam)
*-------------------------
if ntam=NIL .or. ntam>5
   ntam:=1
endif
o_prin_:setpreviewsize(ntam)
return self

*-------------------------
METHOD release() CLASS TPRINT
*-------------------------
if ::exit
   return nil
endif
o_prin_:release()

RETURN NIL


*-------------------------
METHOD init(clibx) CLASS TPRINT
*-------------------------
local crun
public o_prin_

if iswindowactive(_oohg_winreport)
   msgstop("Print preview pending, close first")
   ::exit:=.T.
return nil
endif
if clibx=NIL
   if type("_OOHG_printlibrary")="C"
      ::cprintlibrary:=upper(_OOHG_PRINTLIBRARY)
   else
      ::cprintlibrary:="HBPRINTER"
   endif
else
   ::cprintlibrary:=upper(clibx)
endif

crun:="T"+::cprintlibrary  ////////// +iif(::cprintlibrary="DOS","PRINT","")
o_prin_:=&crun()
o_prin_:init()

return nil

*-------------------------
METHOD selprinter( lselect , lpreview, llandscape , npapersize ,cprinterx, lhide ) CLASS TPRINT
*-------------------------
if ::exit
   ::lprerror:=.T.
   return nil
endif

if lhide#NIL
  ::lwinhide:=lhide
endif

SETPRC(0,0)
DEFAULT llandscape to .F.
o_prin_:selprinter( lselect , lpreview, llandscape , npapersize ,cprinterx)
if o_prin_:lprerror
   ::lprerror:=.T.
   return nil
endif

RETURN nil

*-------------------------
METHOD BEGINDOC(cdoc) CLASS TPRINT
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
o_prin_:begindoc(cdoc)

RETURN nil

*-------------------------
function action_timer()
*-------------------------
if iswindowdefined(_oohg_winreport)
   _oohg_winreport.label_1.fontbold:=IIF(_oohg_winreport.label_1.fontbold,.F.,.T.)
   _oohg_winreport.image_101.visible:=IIF(_oohg_winreport.label_1.fontbold,.T.,.F.)
endif
return nil

*-------------------------
METHOD ENDDOC() CLASS TPRINT
*-------------------------
o_prin_:enddoc()
_oohg_winreport.release()
_modalhide.release()

RETURN self


*-------------------------
METHOD SETCOLOR(atColor) CLASS TPRINT
*-------------------------
::acolor:=atColor
o_prin_:setcolor()
RETURN self

*-------------------------
METHOD beginPAGE() CLASS TPRINT
*-------------------------
o_prin_:beginpage()
RETURN self

*-------------------------
METHOD ENDPAGE() CLASS TPRINT
*-------------------------
o_prin_:endpage()
return self

*-------------------------
METHOD getdefprinter() CLASS TPRINT
*-------------------------
RETURN o_prin_:getdefprinter()

*-------------------------
METHOD setunits(cunitsx) CLASS TPRINT
*-------------------------
if cunitsx="MM"
   ::cunits:="MM"
else
   ::cunits:="ROWCOL"
endif
RETURN nil

*-------------------------
METHOD printdata(nlin,ncol,data,cfont,nsize,lbold,acolor,calign,nlen) CLASS TPRINT
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
o_prin_:printdata(nlin,ncol,data,cfont,nsize,lbold,acolor,calign,nlen,ctext)
return self

*-------------------------
METHOD printimage(nlin,ncol,nlinf,ncolf,cimage) CLASS TPRINT
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
o_prin_:printimage(nlin,ncol,nlinf,ncolf,cimage)
return self

*-------------------------
METHOD printline(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TPRINT
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
o_prin_:printline(nlin,ncol,nlinf,ncolf,atcolor,ntwpen )

RETURN self

*-------------------------
METHOD printrectangle(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TPRINT
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
o_prin_:printrectangle(nlin,ncol,nlinf,ncolf,atcolor,ntwpen )

RETURN self

*------------------------
METHOD printroundrectangle(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TPRINT
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
o_prin_:printroundrectangle(nlin,ncol,nlinf,ncolf,atcolor,ntwpen )

RETURN self

*-------------------------
method printdos() CLASS TPRINT
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

CREATE CLASS TMINIPRINT FROM TPRINT

METHOD init()
METHOD begindoc()
METHOD enddoc()
METHOD beginpage()
METHOD endpage()
METHOD release()
METHOD printdata()
METHOD printimage()
METHOD printline()
METHOD printrectangle
METHOD selprinter()
METHOD getdefprinter()
METHOD setcolor() INLINE NIL
METHOD setpreviewsize() INLINE NIL
METHOD printroundrectangle()
method condendos() INLINE nil
method normaldos() INLINE nil
ENDCLASS

*-------------------------
METHOD init() CLASS TMINIPRINT
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
     public _OOHG_printer_docname

::aprinters:=aprinters()

return self

*-------------------------
METHOD begindoc(cdoc) CLASS TMINIPRINT
*-------------------------
   _OOHG_printer_docname:=cdoc
   START PRINTDOC NAME cDoc
return self

*-------------------------
METHOD enddoc() CLASS TMINIPRINT
   END PRINTDOC
return self

*-------------------------
METHOD beginpage() CLASS TMINIPRINT
*-x------------------------
   START PRINTPAGE
return self

*-------------------------
METHOD endpage() CLASS TMINIPRINT
*-------------------------
  END PRINTPAGE
return self

*-------------------------
METHOD release() CLASS TMINIPRINT
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
     release _OOHG_printer_docname
return nil

*-------------------------
METHOD printdata(nlin,ncol,data,cfont,nsize,lbold,acolor,calign,nlen,ctext) CLASS TMINIPRINT
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
METHOD printimage(nlin,ncol,nlinf,ncolf,cimage) CLASS TMINIPRINT
*-------------------------
   @  nlin*::nmver+::nvfij , ncol*::nmhor+::nhfij*2 PRINT IMAGE cimage WIDTH ((ncolf - ncol-1)*::nmhor + ::nhfij) HEIGHT ((nlinf+0.5 - nlin)*::nmver+::nvfij)
return self

METHOD printline(nlin,ncol,nlinf,ncolf,atcolor,ntwpen )
   @  (nlin+.2)*::nmver+::nvfij,ncol*::nmhor+::nhfij*2 PRINT LINE TO  (nlinf+.2)*::nmver+::nvfij,ncolf*::nmhor+::nhfij*2  COLOR atcolor PENWIDTH ntwpen  //// CPEN
return self


METHOD printrectangle(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TMINIPRINT
*-------------------------
@  nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2 PRINT RECTANGLE TO  (nlinf+0.5)*::nmver+::nvfij,ncolf*::nmhor+::nhfij*2 COLOR atcolor  PENWIDTH ntwpen  //// CPEN
return self

METHOD selprinter( lselect , lpreview, llandscape , npapersize ,cprinterx) CLASS TMINIPRINT
*-------------------------
local Worientation, lsucess := .T.
   if llandscape
      Worientation:= PRINTER_ORIENT_LANDSCAPE
   else
      Worientation:= PRINTER_ORIENT_PORTRAIT
   endif

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
METHOD getdefprinter() CLASS TMINIPRINT
*-------------------------
return getDefaultPrinter()


METHOD printroundrectangle(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TMINIPRINT
   @  nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2 PRINT RECTANGLE TO  (nlinf+0.5)*::nmver+::nvfij,ncolf*::nmhor+::nhfij*2 COLOR atcolor  PENWIDTH ntwpen  ROUNDED //// CPEN
return self

///////////////// hbprinter

CREATE CLASS THBPRINTER FROM TPRINT

METHOD init()
METHOD begindoc()
METHOD enddoc()
METHOD beginpage()
METHOD endpage()
METHOD release()
METHOD printdata()
METHOD printimage()
METHOD printline()
METHOD printrectangle
METHOD selprinter()
METHOD getdefprinter()
METHOD setcolor() 
METHOD setpreviewsize() 
METHOD printroundrectangle()
method condendos() INLINE nil
method normaldos() INLINE nil
ENDCLASS

METHOD INIT() CLASS THBPRINTER

   public hbprn

   INIT PRINTSYS
   GET PRINTERS TO ::aprinters
   GET PORTS TO ::aports
   SET UNITS MM
return self

METHOD BEGINDOC (cdoc) CLASS THBPRINTER
   START DOC NAME cDoc
return self

METHOD ENDDOC() CLASS THBPRINTER
   END DOC
return self

METHOD BEGINPAGE() CLASS THBPRINTER
   START PAGE
return self

METHOD ENDPAGE() CLASS THBPRINTER
   END PAGE
return self

METHOD RELEASE() CLASS THBPRINTER
     RELEASE PRINTSYS
     RELEASE HBPRN
return self

METHOD PRINTDATA(nlin,ncol,data,cfont,nsize,lbold,acolor,calign,nlen,ctext) CLASS THBPRINTER
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

METHOD printimage(nlin,ncol,nlinf,ncolf,cimage) CLASS thbprinter
 @  nlin*::nmver+::nvfij ,ncol*::nmhor+::nhfij*2 PICTURE cimage SIZE  (nlinf+0.5-nlin-4)*::nmver+::nvfij , (ncolf-ncol-3)*::nmhor+::nhfij*2
return self

METHOD printline(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS thbprinter
   CHANGE PEN "C0" WIDTH ntwpen*10  COLOR atcolor
   SELECT PEN "C0"
   @  nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2 , (nlinf)*::nmver+::nvfij,ncolf*::nmhor+::nhfij*2  LINE PEN "C0"  //// CPEN
return self

METHOD printrectangle(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS THBPRINTER
   CHANGE PEN "C0" WIDTH ntwpen*10 COLOR atcolor
   SELECT PEN "C0"
   @  nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2, (nlinf+0.5)*::nmver+::nvfij, ncolf*::nmhor+::nhfij*2  RECTANGLE  PEN "C0" //// CPEN  RECTANGLE  ///// [PEN <cpen>] [BRUSH <cbrush>]
return self

METHOD selprinter( lselect , lpreview, llandscape , npapersize ,cprinterx) CLASS THBPRINTER

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

METHOD getdefprinter() CLASS THBPRINTER
   local cdefprinter
   GET DEFAULT PRINTER TO cdefprinter
return cdefprinter

METHOD setcolor() CLASS THBPRINTER
   CHANGE PEN "C0" WIDTH ::nwpen COLOR ::acolor
   SELECT PEN "C0"   
return self

METHOD setpreviewsize(ntam) CLASS THBPRINTER
   SET PREVIEW SCALE ntam
return self

METHOD printroundrectangle(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS THBPRINTER
   CHANGE PEN "C0" WIDTH ntwpen*10 COLOR atcolor
   SELECT PEN "C0"
   hbprn:RoundRect( nlin*::nmver+::nvfij  ,ncol*::nmhor+::nhfij*2 ,(nlinf+0.5)*::nmver+::nvfij ,ncolf*::nmhor+::nhfij*2 ,10, 10,"C0")
return self

//////////////////////// DOS

CREATE CLASS TDOSPRINT FROM TPRINT

METHOD init()
METHOD begindoc()
METHOD enddoc()
METHOD beginpage()
METHOD endpage()
METHOD release() INLINE nil
METHOD printdata()
METHOD printimage() INLINE nil
METHOD printline()
METHOD printrectangle INLINE nil
METHOD selprinter()
METHOD getdefprinter() INLINE NIL
METHOD setcolor() INLINE NIL
METHOD setpreviewsize() INLINE NIL
METHOD printroundrectangle() INLINE NIL
method condendos() 
method normaldos() 
ENDCLASS

METHOD init() CLASS TDOSPRINT
    ::impreview:=.F.
return self

METHOD begindoc() CLASS TDOSPRINT
   SET PRINTER TO &(::tempfile)
   SET DEVICE TO PRINT    
return self

METHOD enddoc() CLASS TDOSPRINT
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

METHOD beginpage() CLASS TDOSPRINT
   @ 0,0 SAY ""
return self

METHOD endpage() CLASS TDOSPRINT
   EJECT
return self

METHOD printdata(nlin,ncol,data,cfont,nsize,lbold,acolor,calign,nlen,ctext) CLASS TDOSPRINT
   if .not. lbold
       @ nlin,ncol say (ctext)
   else   
       @ nlin,ncol say (ctext)
       @ nlin,ncol say (ctext)
   endif
return self

METHOD printline(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TDOSPRINT
  if nlin=nlinf
     @ nlin,ncol say replicate("-",ncolf-ncol+1)
  endif
return self

METHOD selprinter ( lselect , lpreview, llandscape , npapersize ,cprinterx) CLASS TDOSPRINT
   do while file(::tempfile)
      ::tempfile:=gettempdir()+"T"+alltrim(str(int(hb_random(999999)),8))+".prn"
   enddo
   if lpreview
      ::impreview:=.T.
   endif
return self

METHOD condendos() CLASS TDOSPRINT
   @ prow(), pcol() say chr(15)
return self

METHOD normaldos() CLASS TDOSPRINT
   @ prow(), pcol() say chr(18)
return self

static function zoom(cOp)
 
if cop="+" .and. print_preview.edit_p.fontsize <= 24
  print_preview.edit_p.fontsize:=  print_preview.edit_p.fontsize + 2
endif

if cop="-" .and. print_preview.edit_p.fontsize > 7
  print_preview.edit_p.fontsize:=  print_preview.edit_p.fontsize - 2
endif
return nil
