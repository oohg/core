/*
* $Id: h_print.prg,v 1.19 2006-02-17 13:31:41 declan2005 Exp $
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

CREATE CLASS TPRINT

DATA cprintlibrary      INIT "HBPRINTER" PROTECTED
DATA nmhor              INIT (10)/4.75   PROTECTED
DATA nmver              INIT (10)/2.45   PROTECTED
DATA nhfij              INIT (12/3.70)   PROTECTED
DATA nvfij              INIT (12/1.65)   PROTECTED
DATA cunits             INIT "ROWCOL"    PROTECTED
DATA cprinter           INIT ""          PROTECTED

DATA aprinters          INIT {}   PROTECTED
DATA aports             INIT {}   PROTECTED

DATA lprerror           INIT .F.  PROTECTED
DATA exit               INIT  .F. PROTECTED
DATA acolor             INIT {1,1,1}  PROTECTED
DATA cfontname          INIT "courier new" PROTECTED
DATA nfontsize          INIT 10 PROTECTED
DATA nwpen              INIT 0.1   PROTECTED //// pen width
DATA tempfile           INIT gettempdir()+"T"+alltrim(str(int(hb_random(999999)),8))+".prn" PROTECTED
DATA impreview          INIT .F.  PROTECTED
DATA lwinhide           INIT .T.   PROTECTED
DATA cversion           INIT  "(oohg)V 1.16"



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
METHOD condendos()
*-------------------------


*-------------------------
METHOD NORMALDOS()
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
METHOD condenDOS() CLASS TPRINT
*-------------------------
if ::cprintlibrary="DOS"
   @ prow(), pcol() say chr(15)
endif
return nil

*-------------------------
method normaldos() CLASS TPRINT
*-------------------------
if ::cprintlibrary="DOS"
   @ prow(), pcol() say chr(18)
endif
return nil

*-------------------------
METHOD setpreviewsize(ntam)
*-------------------------
if ntam=NIL .or. ntam>5
   ntam=1
endif
if ::cprintlibrary="HBPRINTER"
   SET PREVIEW SCALE ntam
endif
return nil

*-------------------------
METHOD release() CLASS TPRINT
*-------------------------
if ::exit
   return nil
endif
do case
case ::cprintlibrary="HBPRINTER"
   RELEASE PRINTSYS
   RELEASE HBPRN
case ::cprintlibrary="MINIPRINT"
   release _HMG_PRINTER_APRINTERPROPERTIES
   release _HMG_PRINTER_HDC
   release _HMG_PRINTER_COPIES
   release _HMG_PRINTER_COLLATE
   release _HMG_PRINTER_PREVIEW
   release _HMG_PRINTER_TIMESTAMP
   release _HMG_PRINTER_NAME
   release _HMG_PRINTER_PAGECOUNT
   release _HMG_PRINTER_HDC_BAK
endcase
RETURN NIL


*-------------------------
METHOD init(clibx) CLASS TPRINT
*-------------------------
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

do case
case ::cprintlibrary="HBPRINTER"
   public hbprn
   INIT PRINTSYS
   GET PRINTERS TO ::aprinters
   GET PORTS TO ::aports
   SET UNITS MM
case ::cprintlibrary="MINIPRINT"

   public _HMG_PRINTER_APRINTERPROPERTIES
   public _HMG_PRINTER_HDC
   public _HMG_PRINTER_COPIES
   public  _HMG_PRINTER_COLLATE
   public _HMG_PRINTER_PREVIEW
   public _HMG_PRINTER_TIMESTAMP
   public _HMG_PRINTER_NAME
   public _HMG_PRINTER_PAGECOUNT
   public _HMG_PRINTER_HDC_BAK

   ::aprinters:=aprinters()

case ::cprintlibrary="DOS"
   ::impreview:=.F.
endcase
return nil

*-------------------------
METHOD selprinter( lselect , lpreview, llandscape , npapersize ,cprinterx, lhide ) CLASS TPRINT
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
if llandscape=NIL
   llandscape:=.F.
endif

do case
case ::cprintlibrary="HBPRINTER"
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

case ::cprintlibrary="MINIPRINT"

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

case ::cprintlibrary="DOS"
   do while file(::tempfile)
      ::tempfile:=gettempdir()+"T"+alltrim(str(int(hb_random(999999)),8))+".prn"
   enddo
   if lpreview
      ::impreview:=.T.
   endif
endcase

RETURN nil

*-------------------------
METHOD BEGINDOC(cdoc) CLASS TPRINT
*-------------------------
IF cdoc=NIL
   cDOc:="ooHG printing"
endif

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

do case
case ::cprintlibrary="HBPRINTER"
   START DOC NAME cdoc
case ::cprintlibrary="MINIPRINT"
   START PRINTDOC
case ::cprintlibrary="DOS"
   SET PRINTER TO &(::tempfile)
   SET DEVICE TO PRINT
endcase

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
local _nhandle, wr
do case
case ::cprintlibrary="HBPRINTER"
   END DOC
case ::cprintlibrary="MINIPRINT"
   END PRINTDOC
case ::cprintlibrary="DOS"
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
endcase

_oohg_winreport.release()
_modalhide.release()

RETURN self


*-------------------------
METHOD SETCOLOR(atColor) CLASS TPRINT
*-------------------------
::acolor:=atColor
if ::cprintlibrary="HBPRINTER"
   CHANGE PEN "C0" WIDTH ::nwpen COLOR ::acolor
   SELECT PEN "C0"
endif
RETURN NIL

*-------------------------
METHOD beginPAGE() CLASS TPRINT
*-------------------------
do case
case ::cprintlibrary="HBPRINTER"
   START PAGE
case ::cprintlibrary="MINIPRINT"
   START PRINTPAGE
case ::cprintlibrary="DOS"
   @ 0,0 SAY ""
endcase
RETURN self

*-------------------------
METHOD ENDPAGE() CLASS TPRINT
*-------------------------
do case
case ::cprintlibrary="HBPRINTER"
   END PAGE
case ::cprintlibrary="MINIPRINT"
   END PRINTPAGE
case ::cprintlibrary="DOS"
   EJECT
endcase
RETURN self

*-------------------------
METHOD getdefprinter() CLASS TPRINT
*-------------------------
local cdefprinter
do case
case ::cprintlibrary="HBPRINTER"
   GET DEFAULT PRINTER TO cdefprinter
case ::cprintlibrary="MINIPRINT"
   cdefprinter:=GetDefaultPrinter()
endcase
RETURN cdefprinter


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

if calign=NIL
   calign:="L"
endif

if nlen=NIL
   nlen:=15
endif

do case
case calign = "C"
   cspace=  space((int(nlen)-len(ctext))/2 )
case calign = "R"
   cspace = space(int(nlen)-len(ctext))
otherwise
   cspace = ""
endcase

if nlin=nil
   nlin:=1
endif
if ncol=nil
   ncol:=1
endif
if ctext=NIL
   ctext:=""
endif
if lbold=NIL
   lbold:=.F.
endif
if cfont=NIL
   cfont:=::cfontname
endif
if nsize=NIL
   nsize:=::nfontsize
endif

if acolor=NIL
   acolor:=::acolor
endif

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

do case
case ::cprintlibrary="HBPRINTER"
   change font "F0" name cfont size nsize
   change font "F1" name cfont size nsize BOLD
   SET TEXTCOLOR ::acolor
   if .not. lbold
      if calign="R"
///         for i:=1 to nlen
///             caux:=substr(ctext,i,1)
///             @ nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2+(i*nsize/4.75) SAY (caux) font "F0" TO PRINT
///         next i
        SET TEXT ALIGN RIGHT
        @ nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2 +((nlen+1)*nsize/4.75) SAY (ctext) font "F0" TO PRINT
        SET TEXT ALIGN LEFT
      else
         @ nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2 SAY (ctext) font "F0" TO PRINT
      endif
   else
      if calign="R"
///         for i:=1 to nlen
///             caux:=substr(ctext,i,1)
///             @ nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2+(i*nsize/4.75) SAY (caux) font "F1" TO PRINT
///         next i
        SET TEXT ALIGN RIGHT
        @ nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2 +((nlen+1)*nsize/4.75) SAY (ctext) font "F1" TO PRINT
        SET TEXT ALIGN LEFT

      else
         @ nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2  SAY (ctext) font "F1" TO PRINT
      endif

   endif

case ::cprintlibrary="MINIPRINT"
   if .not. lbold
      if calign="R"
//         for i:=1 to nlen
//             caux:=substr(ctext,i,1)
//             @ nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2+(i*nsize/4.75) PRINT (caux) font cfont size nsize COLOR ::acolor
//         next i

       textalign( 2 )
       @ nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2  +((nlen+1)*nsize/4.75) PRINT (ctext) font cfont size nsize COLOR ::acolor
       textalign( 0 )
      else
         @ nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2 PRINT (ctext) font cfont size nsize COLOR ::acolor
      endif
   else
      if calign="R"
///         for i:=1 to nlen
///             caux:=substr(ctext,i,1)
             textalign( 2 )
             @ nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2+((nlen+1)*nsize/4.75) PRINT (ctext) font cfont size nsize  BOLD COLOR ::acolor
             textalign( 0 )
///         next i
      else
         @ nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2 PRINT (ctext) font cfont size nsize  BOLD COLOR ::acolor
      endif
   endif
case ::cprintlibrary="DOS"
   if .not. lbold
      @ nlin,ncol say (ctext)
   else
      @ nlin,ncol say (ctext)
      @ nlin,ncol say (ctext)
   endif
endcase
RETURN self

*-------------------------
METHOD printimage(nlin,ncol,nlinf,ncolf,cimage) CLASS TPRINT
*-------------------------
if nlin=NIL
   nlin:=1
endif
if ncol=NIL
   ncol:=1
endif
if cimage=NIL
   cimage:=""
endif
if nlinf=NIL
   nlinf:=4
endif
if ncolf=NIL
   ncolf:=4
endif

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
do case
case ::cprintlibrary="HBPRINTER"
   @  nlin*::nmver+::nvfij ,ncol*::nmhor+::nhfij*2 PICTURE cimage SIZE  (nlinf+0.5-nlin-4)*::nmver+::nvfij , (ncolf-ncol-3)*::nmhor+::nhfij*2
case ::cprintlibrary="MINIPRINT"
   @  nlin*::nmver+::nvfij , ncol*::nmhor+::nhfij*2 PRINT IMAGE cimage WIDTH ((ncolf - ncol-1)*::nmhor + ::nhfij) HEIGHT ((nlinf+0.5 - nlin)*::nmver+::nvfij)
endcase
RETURN nil


*-------------------------
METHOD printline(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TPRINT
*-------------------------
if nlin=NIL
   nlin:=1
endif
if ncol=NIL
   ncol:=1
endif
if nlinf=NIL
   nlinf:=4
endif
if ncolf=NIL
   ncolf:=4
endif
if atcolor=NIL
   atcolor:= ::acolor
endif

if ntwpen=NIL
   ntwpen:= ::nwpen
endif

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


do case
case ::cprintlibrary="HBPRINTER"
   CHANGE PEN "C0" WIDTH ntwpen*10  COLOR atcolor
   SELECT PEN "C0"
   @  nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2 , (nlinf)*::nmver+::nvfij,ncolf*::nmhor+::nhfij*2  LINE PEN "C0"  //// CPEN
case ::cprintlibrary="MINIPRINT"
   @  (nlin+.2)*::nmver+::nvfij,ncol*::nmhor+::nhfij*2 PRINT LINE TO  (nlinf+.2)*::nmver+::nvfij,ncolf*::nmhor+::nhfij*2  COLOR atcolor PENWIDTH ntwpen  //// CPEN
case ::cprintlibrary="DOS"
   if nlin=nlinf
      @ nlin,ncol say replicate("-",ncolf-ncol+1)
   endif
endcase
RETURN nil

*-------------------------
METHOD printrectangle(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TPRINT
*-------------------------
if nlin=NIL
   nlin:=1
endif
if ncol=NIL
   ncol:=1
endif
if nlinf=NIL
   nlinf:=4
endif
if ncolf=NIL
   ncolf:=4
endif

if atcolor=NIL
   atcolor:= ::acolor
endif

if ntwpen=NIL
   ntwpen:= ::nwpen
endif

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
do case
case ::cprintlibrary="HBPRINTER"
   CHANGE PEN "C0" WIDTH ntwpen*10 COLOR atcolor
   SELECT PEN "C0"
   @  nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2, (nlinf+0.5)*::nmver+::nvfij, ncolf*::nmhor+::nhfij*2  RECTANGLE  PEN "C0" //// CPEN  RECTANGLE  ///// [PEN <cpen>] [BRUSH <cbrush>]
case ::cprintlibrary="MINIPRINT"
   @  nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2 PRINT RECTANGLE TO  (nlinf+0.5)*::nmver+::nvfij,ncolf*::nmhor+::nhfij*2 COLOR atcolor  PENWIDTH ntwpen  //// CPEN
endcase
RETURN nil

*------------------------
METHOD printroundrectangle(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TPRINT
*-------------------------
if nlin=NIL
   nlin:=1
endif
if ncol=NIL
   ncol:=1
endif
if nlinf=NIL
   nlinf:=4
endif
if ncolf=NIL
   ncolf:=4
endif

if atcolor=NIL
   atcolor:= ::acolor
endif

if ntwpen=NIL
ntwpen:= ::nwpen
endif

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
do case
case ::cprintlibrary="HBPRINTER"
   CHANGE PEN "C0" WIDTH ntwpen*10 COLOR atcolor
   SELECT PEN "C0"
   hbprn:RoundRect( nlin*::nmver+::nvfij  ,ncol*::nmhor+::nhfij*2 ,(nlinf+0.5)*::nmver+::nvfij ,ncolf*::nmhor+::nhfij*2 ,10, 10,"C0")
case ::cprintlibrary="MINIPRINT"
   @  nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2 PRINT RECTANGLE TO  (nlinf+0.5)*::nmver+::nvfij,ncolf*::nmhor+::nhfij*2 COLOR atcolor  PENWIDTH ntwpen  ROUNDED //// CPEN
endcase
RETURN nil


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

*-------------------------
static function zoom(cOp)
*-------------------------
if cop="+" .and. print_preview.edit_p.fontsize <= 24
   print_preview.edit_p.fontsize:=  print_preview.edit_p.fontsize + 2
endif

if cop="-" .and. print_preview.edit_p.fontsize > 7
   print_preview.edit_p.fontsize:=  print_preview.edit_p.fontsize - 2
endif
return nil

