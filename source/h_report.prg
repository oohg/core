/*
 * $Id: h_report.prg,v 1.48 2011-08-19 20:27:22 declan2005 Exp $
 */
/*
 * DO REPORT Command support procedures FOR MiniGUI Library.
 * (c) Ciro vargas Clemow [sistemascvc@softhome.net]

 This program is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later
 version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU General Public License FOR more details.

 You should have received a copy of the GNU General Public License along with
 this software; see the file COPYING. IF not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or
 visit the web site http://www.gnu.org/).

 As a special exception, you have permission FOR additional uses of the text
 contained in this file.

 The exception is that, IF you link this code with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking
 this code into it.

*/

#include 'oohg.ch'
#include 'hbclass.ch'
#include 'common.ch'

MEMVAR NPOS
MEMVAR LIN
MEMVAR SW
MEMVAR CREPORT
MEMVAR cgraphicalt
MEMVAR NGRPBY
MEMVAR WFIELD
MEMVAR WFIELDA
MEMVAR WFIELDT
MEMVAR CROMPE
MEMVAR Npapersize
MEMVAR ipaper
MEMVAR _OOHG_printlibrary
MEMVAR lgroupeject
MEMVAR lexcel


/////////////////
MEMVAR LUSELETTER
MEMVAR LFIRSTPASS

STATIC oprint,nposrow,nposcol,areportdata,LP,NPAP, npagenumber, nmaxlinesavail,nlinesleft,areporttotals,agrouptotals
STATIC clengthsbuff,coffsetsbuff,cexprbuff,repobject,sicvar

FUNCTION easyreport(ctitle,aheaders1,aheaders2,afields,awidths,atotals,nlpp,ldos,lpreview,cgraphic,nfi,nci,nff,ncf,lmul,cgrpby,chdrgrp,llandscape,ncpl,lselect,calias,nllmargin,aformats,npapersize,cheader,lnoprop,lgroupeject)
PRIVATE ctitle1

IF lgroupeject=NIL
   lgroupeject:=.F.
ENDIF


IF cheader=NIL
   cheader:=""
ENDIF

IF lnoprop=NIL
   lnoprop=.F.
ENDIF

IF nlpp=NIL
   nlpp:=58
ENDIF
IF ncpl=NIL
   ncpl:=80
ENDIF

 _listreport(CTITLE,AHEADERS1,AHEADERS2,AFIELDS,AWIDTHS,ATOTALS,NLPP,LDOS,LPREVIEW,CGRAPHIC,NFI,NCI,NFF,NCF,LMUL,CGRPBY,CHDRGRP,LLANDSCAPE,NCPL,LSELECT,CALIAS,NLLMARGIN,AFORMATS,NPAPERSIZE,CHEADER,lnoprop,lgroupeject)

RETURN NIL

static FUNCTION _listreport(ctitle,aheaders1,aheaders2,afields,awidths,atotals,nlpp,ldos,lpreview,cgraphic,nfi,nci,nff,ncf,lmul,cgrpby,chdrgrp,llandscape,ncpl,lselect,calias,nllmargin,aformats,npapersize,cheader,lnoprop,lgroupeject)
repobject:=TREPORT()
sicvar:=setinteractiveclose()
SET INTERACTIVECLOSE ON
repobject:easyreport1(ctitle,aheaders1,aheaders2,afields,awidths,atotals,nlpp,ldos,lpreview,cgraphic,nfi,nci,nff,ncf,lmul,cgrpby,chdrgrp,llandscape,ncpl,lselect,calias,nllmargin,aformats,npapersize,cheader,lnoprop,lgroupeject)
setinteractiveclose(sicvar)
release repobject
RETURN nil

FUNCTION extreport(cfilerep,cheader)
repobject:=TREPORT()
repobject:extreport1(cfilerep,cheader)
release repobject
RETURN NIL

function JUSTIFICALINEA(WPR_LINE,WTOPE)
LOCAL I,WLARLIN
WLARLIN=LEN(TRIM(WPR_LINE))
FOR I=1 TO WLARLIN
   IF WLARLIN=WTOPE
      EXIT
   ENDIF
   IF SUBSTR(WPR_LINE,I,1)=SPACE(1) .AND. SUBSTR(WPR_LINE,I-1,1)#SPACE(1) ////// .AND. SUBSTR(WPR_LINE,I+1,1)#SPACE(1)
      WPR_LINE=LTRIM(SUBSTR(WPR_LINE,1,I-1))+SPACE(2)+LTRIM(SUBSTR(WPR_LINE,I+1,LEN(WPR_LINE)-I))
      WLARLIN=WLARLIN+1
   ENDIF
NEXT I
RETURN WPR_LINE


CREATE CLASS TREPORT FROM TPRINTBASE


VAR npager    INIT 0
VAR angrpby   INIT {}
VAR nlmargin  INIT 0
VAR nfsize    INIT 0
VAR swt       INIT .F.
VAR nmhor     INIT 0
VAR nmver     INIT 0
VAR nhfij     INIT 0
VAR nvfij     INIT 0

VAR aline     INIT {}

METHOD easyreport1(ctitle,aheaders1,aheaders2,afields,awidths,atotals,nlpp,ldos,lpreview,cgraphic,nfi,nci,nff,ncf,lmul,cgrpby,chdrgrp,llandscape,ncpl,lselect,calias,nllmargin,aformats,npapersize,cheader,lnoprop,lgroupeject)
METHOD headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp,cheader)
METHOD extreport1(cfilerep,cheader)
METHOD leadato(cName,cPropmet,cDefault)
METHOD leaimage(cName,cPropmet,cDefault)
METHOD leadatoh(cName,cPropmet,cDefault,npar)
METHOD leadatologic(cName,cPropmet,cDefault)
METHOD clean(cfvalue)
METHOD learowi(cname,npar)
METHOD leacoli(cname,npar)

   EMPTY( _OOHG_AllVars )

ENDCLASS


METHOD easyreport1(ctitle,aheaders1,aheaders2,afields,awidths,atotals,nlpp,ldos,lpreview,cgraphic,nfi,nci,nff,ncf,lmul,cgrpby,chdrgrp,llandscape,ncpl,lselect,calias,nllmargin,aformats,npapersize,cheader,lnoprop,lgroupeject) CLASS TREPORT
local nlin,i,aresul,lmode,swt:=0,grpby,k,ncvcopt,swmemo,clinea,ti,nmemo,nspace,wtipo
private  wfield,wfielda,wfieldt,lexcel:=.F.


  IF nllmargin = NIL
   repobject:nlmargin:=0
ELSE
   repobject:nlmargin:=nllmargin
ENDIF
IF aformats==NIL
   aformats:=array(len(afields))
   FOR i:=1 to len(afields)
       aformats[i]:=NIL
   NEXT i
ENDIF
IF atotals==NIL
   atotals:=array(len(afields))
   FOR i:=1 to len(afields)
       atotals[i]:=.F.
   NEXT i
ENDIF
repobject:npager:=0
grpby:=cgrpby
aresul:=array(len(afields))
repobject:angrpby:=array(len(afields))
FOR i:=1 to len(afields)
    afields[i]:=upper(afields[i])
NEXT i
IF grpby<>NIL
   grpby:=upper(grpby)
   grpby:=strtran(grpby,'"','')   //// a¤adi esto por inconvenientes en el rompimiento de control
   grpby:=strtran(grpby,"'","")   //// a¤adi esto por inconvenientes en el rompimiento de control

ENDIF
select(calias)
lmode:=.T.
IF nlpp= NIL
   nlpp=50
ENDIF
setprc(0,0)
IF ncpl = NIL
   ncpl:=80
   repobject:nfsize=12
ENDIF

IF ldos
   oprint:=tprint("DOSPRINT")
   oprint:init()

   IF ncpl<= 80
      oprint:normaldos()
   ELSE
      oprint:condendos()
   ENDIF

ELSE
  IF type("_OOHG_printlibrary")#"C"
     oprint:=tprint("MINIPRINT")
     oprint:init()
     _OOHG_printlibrary="MINIPRINT"
  ENDIF
  IF _OOHG_printlibrary="HBPRINTER"
       oprint:=tprint("HBPRINTER")
       oprint:init()
  ELSEIF _OOHG_printlibrary="MINIPRINT"
       oprint:=tprint("MINIPRINT")
       oprint:init()
   ELSEIF _OOHG_printlibrary="PDFPRINT"
       oprint:=tprint("PDFPRINT")
       oprint:init()
  ELSEIF _OOHG_printlibrary="EXCELPRINT"
       oprint:=tprint("EXCELPRINT")
       oprint:init()
       lexcel:=.T.
  ELSEIF _OOHG_printlibrary="RTFPRINT"
       oprint:=tprint("RTFPRINT")
       oprint:init()
       lexcel:=.T.
   ELSEIF _OOHG_printlibrary="CALCPRINT"
       oprint:=tprint("CALCPRINT")
       oprint:init()
       lexcel:=.T.
  ELSEIF _OOHG_printlibrary="CSVPRINT"
       oprint:=tprint("CSVPRINT")
       oprint:init()
       lexcel:=.T.
  ELSEIF _OOHG_printlibrary="SPREADSHEETPRINT"
       oprint:=tprint("SPREADSHEETPRINT")
       oprint:init()
       lexcel:=.T.

  ELSEIF _OOHG_printlibrary="HTMLPRINT"
       oprint:=tprint("HTMLPRINT")
       oprint:init()
       lexcel:=.T.

  ELSEIF _OOHG_printlibrary="DOSPRINT"
       oprint:=tprint("DOSPRINT")
       oprint:init()
       IF ncpl<=80
         oprint:normaldos()
       ELSE
         oprint:condendos()
       ENDIF
  ELSEIF _OOHG_printlibrary="RAWPRINT"
       oprint:=tprint("RAWPRINT")
       oprint:init()
       IF ncpl<=80
         oprint:normaldos()
       ELSE
         oprint:condendos()
       ENDIF

  ELSE
       oprint:=tprint("MINIPRINT")
       oprint:init()
       _OOHG_printlibrary="MINIPRINT"
  ENDIF

ENDIF

do case
        case ncpl= 80
            ncvcopt:=1
            repobject:nfsize:=12
            IF lnoprop
               oprint:setcpl(80)
            ENDIF
         case ncpl= 96
            ncvcopt:=2
            repobject:nfsize=10
            IF lnoprop
               oprint:setcpl(96)
            ENDIF
         case ncpl= 120
            ncvcopt:=3
            repobject:nfsize:=8
            IF lnoprop
               oprint:setcpl(120)
            ENDIF
         case ncpl= 140
            ncvcopt:=4
           repobject:nfsize:=7
           IF lnoprop
              oprint:setcpl(140)
           ENDIF
         case ncpl= 160
            ncvcopt:=5
            repobject:nfsize:=6
            IF lnoprop
                oprint:setcpl(160)
            ENDIF
         otherwise
            ncvcopt:=1
            repobject:nfsize:=12
            IF lnoprop
                oprint:setcpl(80)
            ENDIF
endcase

*****************=======================================
oprint:selprinter(lselect,lpreview,llandscape,npapersize,,,-2)
IF oprint:lprerror
   oprint:release()
   RETURN NIL
ENDIF
oprint:begindoc()
oprint:beginpage()
nlin:=1
IF cgraphic<>NIL
   IF .not. File(cgraphic)
      msgstop('graphic file not found','error')
   ELSE
      oprint:printimage(nfi,nci+repobject:nlmargin,nff,ncf+repobject:nlmargin,cgraphic)
   ENDIF
ENDIF
ngrpby:=0
nlin:=repobject:headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp,cheader)
FOR i:=1 to len(afields)
    aresul[i]:=0
    repobject:angrpby[i]:=0
NEXT i
IF grpby<> NIL
   crompe:=&(grpby)
ENDIF
do while .not. eof()
   do events
////   ncol:=repobject:nlmargin
   swt:=0
   IF grpby<>NIL

      IF .not.(&(grpby) = crompe)
            IF ascan(atotals,.T.)>0
               oprint:printdata(nlin,repobject:nlmargin, '** Subtotal **',,repobject:nfsize,.T.)
               nlin++
            ENDIF
**************
            clinea:=""
            FOR i:=1 to len(afields)
                 IF atotals[i]
                  clinea:=clinea +iif(.not.(aformats[i]==NIL),space(awidths[i]-len(transform(repobject:angrpby[i],aformats[i])))+transform(repobject:angrpby[i],aformats[i]),str(repobject:angrpby[i],awidths[i]))+ space(awidths[i] -   len(  iif(.not.(aformats[i]==''),space(awidths[i]-len(transform(repobject:angrpby[i],aformats[i])))+transform(repobject:angrpby[i],aformats[i]),str(repobject:angrpby[i],awidths[i])))   )+" "
                 ELSE
                  clinea:=clinea+ space(awidths[i])+" "
                ENDIF
             NEXT i
             oprint:printdata(nlin,0+repobject:nlmargin,clinea,,repobject:nfsize ,.T.)

**************
        FOR i:=1 to len(afields)
          repobject:angrpby[i]:=0
        NEXT i
********
******** seria aqui si decido hacer el rompe por pagina
       *********** IF EJECTGROUP  oprint:endpage()
      IF lgroupeject
         nlin:=1
         oprint:endpage()
         oprint:beginpage()
         nlin:=repobject:headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp,cheader)
         nlin--
      ENDIF

       *************
********
        crompe:=&(grpby)
        nlin++
        oprint:printdata(nlin,repobject:nlmargin,  '** ' + (chdrgrp)+' '+ (&(grpby)),,repobject:nfsize,.T.)
        nlin++
      ENDIF
   ENDIF
**********
   clinea:=""
   swmemo:=.F.
   FOR i:=1 to len(afields)
       wfielda:=afields[i]
       IF type('&wfielda')=='B'
          wfield:=eval(&wfielda)
          wtipo:=valtype(wfield)
       ELSE
          wfield:=&(wfielda)
          wtipo=type('&wfielda')
          IF type('&wfielda')=='M'
             swmemo=.T.
             wfieldt:=wfield
             ti:=i
          ENDIF
          IF type('&wfielda')=='O'
             wfield:="< Object >"
             wtipo:="C"
          ENDIF
          IF type('&wfielda')=='A'
             wfield:="< Array >"
             wtipo:="C"
          ENDIF

       ENDIF

            do case
               case wtipo == 'C'
               clinea:=clinea+substr(wfield,1,awidths[i])+space(awidths[i]-len(substr(wfield,1,awidths[i]) ))+" "
               case wtipo == 'N'
                    clinea:=clinea + iif(.not.(aformats[i]==NIL),space(awidths[i]-len(transform(wfield,aformats[i])))+transform(wfield,aformats[i]),str(wfield,awidths[i]))+ space(awidths[i] -   len(  iif(.not.(aformats[i]==''),space(awidths[i]-len(transform(wfield,aformats[i])))+transform(wfield,aformats[i]),str(wfield,awidths[i])))   )+" "
               case wtipo == 'D'
                    clinea:=clinea+ substr(dtoc(wfield),1,awidths[i])+space(awidths[i]-len(substr(dtoc(wfield),1,awidths[i])) )+" "
               case wtipo == 'L'
                    clinea:=clinea+iif(wfield,"T","F")+space(awidths[i]-1)+" "

              case wtipo == 'M' .or. wtipo == 'C' //// ojo no quitar la a
                  nmemo:=mlcount(rtrim(wfield),awidths[i])
                  IF nmemo>0
                     clinea:=clinea + rtrim(justificalinea(memoline(rtrim(wfield),awidths[i] ,1),awidths[i]))+space(awidths[i]-len(rtrim(justificalinea(memoline(rtrim(wfield),awidths[i] ,1),awidths[i])) ) )+" "
                  ELSE
                     clinea:=clinea + space(awidths[i])+" "
                  ENDIF
               otherwise
                  clinea:=clinea+replicate('_',awidths[i])+" "
            endcase
       IF atotals[i]
          aresul[i]:=aresul[i]+wfield
          swt:=1
          IF grpby<>NIL
             repobject:angrpby[i]:=repobject:angrpby[i]+wfield
          ENDIF
       ENDIF
NEXT i
oprint:printdata(nlin,repobject:nlmargin,clinea,,repobject:nfsize)
nlin++
IF nlin>nlpp
   nlin:=1
   IF .not. ldos
      oprint:endpage()
      oprint:beginpage()
      IF cgraphic<>NIL .and. lmul
         IF .not. File(cgraphic)
         msgstop('graphic file not found','error')
      ELSE
         oprint:printimage(nfi,nci+repobject:nlmargin,nff,ncf,cgraphic )
      ENDIF
   ENDIF
ENDIF
nlin:=repobject:headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp,cheader)
ENDIF
**************resto de memo
IF swmemo
   IF nmemo > 1
   clinea:=""
   nspace:=0
   FOR k:=1 to ti-1
       nspace:=nspace+awidths[k]+1
   NEXT k
   FOR k:=2 to nmemo
       clinea:=space(nspace)+justificalinea(memoline(rtrim(wfieldt),awidths[ti] ,k),awidths[ti] )
       oprint:printdata(nlin,0+repobject:nlmargin,clinea , , repobject:nfsize ,  )
       nlin++
       IF nlin>nlpp
          nlin:=1
          oprint:endpage()
          oprint:beginpage()
   IF cgraphic<>NIL .and. lmul
             IF .not. File(cgraphic)
          msgstop('graphic file not found','error')
             ELSE
                 oprint:printimage(nfi,nci+repobject:nlmargin,nff,ncf,cgraphic )
             ENDIF
  ENDIF
  nlin:=repobject:headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp,cheader)
       ENDIF
    NEXT k
////    nlin--
   ENDIF
ENDIF
**************
skip
enddo

IF swt==1
   IF grpby<>NIL
      IF .not.(&(grpby) == crompe)
         IF ascan(atotals,.T.)>0
            oprint:printdata(nlin,repobject:nlmargin,  '** Subtotal **',,repobject:nfsize,.T.)
**** ojo
            nlin++
         ENDIF
         clinea:=""
         FOR i:=1 to len(afields)
                IF atotals[i]
                   clinea:=clinea +iif(.not.(aformats[i]==NIL),space(awidths[i]-len(transform(repobject:angrpby[i],aformats[i])))+transform(repobject:angrpby[i],aformats[i]),str(repobject:angrpby[i],awidths[i]))+ space(awidths[i] -   len(  iif(.not.(aformats[i]==''),space(awidths[i]-len(transform(repobject:angrpby[i],aformats[i])))+transform(repobject:angrpby[i],aformats[i]),str(repobject:angrpby[i],awidths[i])))   )+" "
                ELSE
                   clinea:=clinea+ space(awidths[i])+" "
                ENDIF
         NEXT i
        oprint:printdata(nlin,repobject:nlmargin, clinea , ,repobject:nfsize ,.T. )
        FOR i:=1 to len(afields)
          repobject:angrpby[i]:=0
        NEXT i
        crompe:=&(grpby)
      ENDIF
   ENDIF
************** rompe por pagina si tiene el parametro
      IF lgroupeject
         nlin:=1
         oprint:endpage()
         oprint:beginpage()
         nlin:=repobject:headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp,cheader)
         nlin--
      ENDIF

**************
   nlin++
   IF nlin>nlpp
      nlin:=1
      oprint:endpage()
      oprint:beginpage()
      nlin:=repobject:headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp,cheader)
   ENDIF
   IF ascan(atotals,.T.)>0
      oprint:printdata(nlin, 0+repobject:nlmargin,'*** Total ***',,repobject:nfsize,.T.)
   ENDIF
   nlin++
   clinea:=""
   FOR i:=1 to len(afields)
       IF atotals[i]
           clinea:=clinea +iif(.not.(aformats[i]==NIL),space(awidths[i]-len(transform(aresul[i],aformats[i])))+transform(aresul[i],aformats[i]),str(aresul[i],awidths[i]))+ space(awidths[i] -   len(  iif(.not.(aformats[i]==''),space(awidths[i]-len(transform(aresul[i],aformats[i])))+transform(aresul[i],aformats[i]),str(aresul[i],awidths[i])))   )+" "
        ELSE
         clinea:=clinea+ space(awidths[i])+" "
       ENDIF
   NEXT i
    oprint:printdata(nlin,0+repobject:nlmargin,clinea, ,repobject:nfsize ,.T.)
   nlin++
   oprint:printdata(nlin,repobject:nlmargin," ")
ENDIF
  oprint:endpage()
  oprint:enddoc()
  oprint:release()
RETURN Nil

METHOD headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp,cheader) CLASS TREPORT
local i,nsum,ncenter,ncenter2,npostitle,ctitle1,ctitle2,clinea,clinea1,clinea2
empty(lmode)
nsum:=0
FOR i:=1 to len(awidths)
    nsum:=nsum+awidths[i]
NEXT i
npostitle:=at('|',ctitle)
ctitle1:=ctitle2:=''
IF npostitle>0
   ctitle1:=left(ctitle,npostitle-1)
   ctitle2:=trim(substr(ctitle,npostitle+1,len(ctitle)))
ELSE
   ctitle1:=ctitle
ENDIF
ctitle1:=trim(ctitle1)+cheader
ncenter:=((nsum-len(ctitle1))/2)-1
IF len(ctitle2)>0
   ncenter2:=((nsum-len(ctitle2))/2)-1
ENDIF
repobject:npager++
IF .not. lexcel
   clinea:=trim(_oohg_MESSAGES(1,8) )+ space(6-len(trim(_OOHG_MESSAGES(1,8) ))) + str(repobject:npager,4)
   clinea1:=space(ncenter)+ctitle1
   clinea2:=space(nsum+len(awidths)-11)+dtoc(date())
   oprint:printdata(nlin,repobject:nlmargin , clinea,,repobject:nfsize )
   oprint:printdata(nlin,repobject:nlmargin , clinea1,,repobject:nfsize+1,.T. )
   oprint:printdata(nlin,repobject:nlmargin , clinea2,,repobject:nfsize )
ELSE
   clinea:=trim(_oohg_MESSAGES(1,8) )+ space(6-len(trim(_OOHG_MESSAGES(1,8) ))) + str(repobject:npager,4)+"       "+ctitle1+"       "+dtoc(date())
   oprint:printdata(nlin,repobject:nlmargin , clinea,,repobject:nfsize )
ENDIF


IF .not. lexcel

   IF len(ctitle2)>0
      nlin++
      clinea1:=space(ncenter2)+ctitle2
      clinea2:=space(nsum+len(awidths)-11)+time()
      oprint:printdata(nlin,repobject:nlmargin, clinea1,,repobject:nfsize+1,.T. )
      oprint:printdata(nlin,repobject:nlmargin, clinea2,,repobject:nfsize )
   ELSE
      nlin++
      clinea2:=space(nsum+len(awidths)-11)+time()
      oprint:printdata(nlin,repobject:nlmargin , clinea2,,repobject:nfsize )
   ENDIF
ELSE
   IF len(ctitle2)>0
      nlin++
      clinea1:=space(ncenter2)+ctitle2+"       "+time()
      oprint:printdata(nlin,repobject:nlmargin , clinea1,,repobject:nfsize )
   ELSE
      nlin++
      clinea1:=space(nsum+len(awidths)-11)+time()
      oprint:printdata(nlin,repobject:nlmargin , clinea1,,repobject:nfsize )
   ENDIF
ENDIF

nlin++
nlin++
clinea:=""
FOR i:=1 to  len(awidths)
    clinea:=clinea+ replicate('-',awidths[i])+" "
NEXT i
oprint:printdata(nlin,repobject:nlmargin, clinea,,repobject:nfsize  )
nlin++

clinea:=""
FOR i:=1 to len(awidths)
  clinea:= clinea + substr(aheaders1[i],1,awidths[i] ) + space( awidths[i]-len(aheaders1[i] )) +" "
NEXT i
oprint:printdata(nlin,repobject:nlmargin, clinea,,repobject:nfsize ,.T.)
nlin++

clinea:=""
FOR i:=1 to len(awidths)
    clinea:= clinea + substr(aheaders2[i],1,awidths[i] ) + space( awidths[i]-len(aheaders2[i] )) +" "
NEXT i
   oprint:printdata(nlin,repobject:nlmargin, clinea,,repobject:nfsize ,.T.)
nlin++

clinea:=""
FOR i:=1 to  len(awidths)
    clinea:=clinea + replicate('-',awidths[i])+" "
NEXT i
oprint:printdata(nlin,repobject:nlmargin, clinea,,repobject:nfsize   )
nlin:=nlin+2


IF repobject:npager=1 .and. grpby#NIL
   oprint:printdata(nlin,repobject:nlmargin, '** ' +chdrgrp+' '+  &(grpby) , ,repobject:nfsize ,.T.   )
   nlin++
ENDIF
RETURN nlin

METHOD extreport1(cfilerep,cheader) CLASS TREPORT
local nContlin,i,ctitle,aheaders1,aheaders2,afields,awidths,atotals,aformats
local nlpp,ncpl,nllmargin,calias,ldos,lpreview,lselect,cgraphic,lmul,nfi,nci
local nff,ncf,cgrpby,chdrgrp,llandscape,lnoprop
       IF .not. file(cfilerep+'.rpt')
          msginfo('('+cfilerep+'.rpt)  File not found','Information')
          RETURN Nil
       ENDIF

       creport:=memoread(cfilerep+'.rpt')
       nContlin:=mlcount(Creport)
       FOR i:=1 to nContlin
          aAdd (repobject:Aline,memoline(Creport,500,i))
       NEXT i
       ctitle:=repobject:leadato('REPORT','TITLE','')
       IF len(ctitle)>0
          ctitle:=&ctitle
       ENDIF
       aheaders1:=repobject:leadatoh('REPORT','HEADERS','{}',1)
       aheaders1:=&aheaders1
       aheaders2:=repobject:leadatoh('REPORT','HEADERS','{}',2)
       aheaders2:=&aheaders2
       afields:=repobject:leadato('REPORT','FIELDS','{}')
       IF len(afields)=0
          msginfo('Fields not defined','Information')
          RETURN Nil
       ENDIF
       afields:=&afields
       awidths:=repobject:leadato('REPORT','WIDTHS','{}')
       IF len(awidths)=0
          msginfo('Widths not defined','Information')
          RETURN Nil
       ENDIF
       awidths:=&awidths
       atotals:=repobject:leadato('REPORT','TOTALS',NIL)
       IF atotals<>NIL
          atotals:=&atotals
       ENDIF
       aformats:=repobject:leadato('REPORT','NFORMATS',NIL)
       IF aformats<>NIL
          aformats:=&aformats
       ENDIF
       nlpp:=val(repobject:leadato('REPORT','LPP',''))
       ncpl:=val(repobject:leadato('REPORT','CPL',''))
       nllmargin:=val(repobject:leadato('REPORT','LMARGIN','0'))
       npapersize:=repobject:leadato('REPORT','PAPERSIZE','DMPAPER_LETTER')
       IF npapersize='DMPAPER_USER'
          npapersize=255
       ENDIF
       IF len(npapersize)=0
          npapersize:=NIL
       ELSE
          ipaper := ascan ( apapeles , npapersize )
          IF ipaper=0
             ipaper=1
          ENDIF
          npapersize:=ipaper
       ENDIF
       calias:=repobject:leadato('REPORT','WORKAREA','')
       ldos:=repobject:leadatologic('REPORT','DOSMODE',.F.)
       lpreview:=repobject:leadatologic('REPORT','PREVIEW',.F.)
       lselect:=repobject:leadatologic('REPORT','SELECT',.F.)
       lmul:=repobject:leadatologic('REPORT','MULTIPLE',.F.)
       lnoprop:=repobject:leadatologic('REPORT','NOFIXED',.F.)

       cgraphic:=repobject:clean(repobject:leaimage('REPORT','IMAGE',''))
       IF len(cgraphic)==0
          cgraphic:=NIL
       ENDIF
       nfi:=val((repobject:learowi('IMAGE',1)))
       nci:=val((repobject:leacoli('IMAGE',1)))
       nff:=val((repobject:learowi('IMAGE',2)))
       ncf:=val((repobject:leacoli('IMAGE',2)))
       cgraphicalt:=(repobject:leadato('DEFINE REPORT','IMAGE',''))
       IF len(cgraphicalt)>0  &&& para sintaxis DEFINE REPORT
          cgraphicalt:=&cgraphicalt
          cgraphic:=cgraphicalt[1]
          nfi:=cgraphicalt[2]
          nci:=cgraphicalt[3]
          nff:=cgraphicalt[4]
          ncf:=cgraphicalt[5]
       ENDIF
       cgrpby:=repobject:leadato('REPORT','GROUPED BY','')
       IF len(cgrpby)=0
          cgrpby=NIL
       ENDIF
       chdrgrp:=repobject:clean(repobject:leadato('REPORT','HEADRGRP',''))
       llandscape:=repobject:leadatologic('REPORT','LANDSCAPE',.F.)
       lgroupeject:=repobject:leadatologic('REPORT','GROUPEJECT',.F.)

       easyreport(ctitle,aheaders1,aheaders2,afields,awidths,atotals,nlpp,ldos,lpreview,cgraphic,nfi,nci,nff,ncf,lmul,cgrpby,chdrgrp,llandscape,ncpl,lselect,calias,nllmargin,aformats,npapersize,cheader,lnoprop,lgroupeject)
RETURN Nil

METHOD leadato(cName,cPropmet,cDefault) CLASS TREPORT
local i,sw,cfvalue
sw:=0
FOR i:=1 to len(repobject:aline)
IF .not. at(upper(cname)+' ',upper(repobject:aline[i]))==0
   sw:=1
ELSE
   IF sw==1
      npos:=at(upper(cPropmet)+' ',upper(repobject:aline[i]))
      IF len(trim(repobject:aline[i]))==0
         i=len(repobject:aline)+1
         RETURN cDefault
      ENDIF
      IF npos>0
         cfvalue:=substr(repobject:aline[i],npos+len(Cpropmet),len(repobject:aline[i]))
         i:=len(repobject:aline)+1
         cfvalue:=trim(cfvalue)
         IF right(cfvalue,1)=';'
            cfvalue:=substr(cfvalue,1,len(cfvalue)-1)
         ELSE
            cfvalue:=substr(cfvalue,1,len(cfvalue))
         ENDIF
         RETURN alltrim(cfvalue)
      ENDIF
   ENDIF
ENDIF
NEXT i
RETURN cDefault

METHOD leaimage(cName,cPropmet,cDefault) CLASS TREPORT
local i,sw1,npos1,npos2
sw1:=0
lin:=0
cname:=''
cpropmet:=''
FOR i:=1 to len(repobject:aline)
    IF at(upper('IMAGE'),repobject:aline[i])>0
       npos1:=at(upper('IMAGE'),upper(repobject:aline[i]))+6
       npos2:=at(upper('AT'),upper(repobject:aline[i]))-1
       lin:=i
       i:=len(repobject:aline)+1
       sw1:=1
    ENDIF
NEXT i
IF sw1=1
   RETURN substr(repobject:aline[lin],npos1,npos2-npos1+1)
ENDIF
RETURN cDefault

METHOD leadatoh(cName,cPropmet,cDefault,npar) CLASS TREPORT
local i,npos1,npos2,sw1
sw1:=0
lin:=0
cName:=''
cPropmet:=''
FOR i:=1 to len(repobject:aline)
        IF at(upper('HEADERS'),repobject:aline[i])>0
            IF npar=1
               npos1:=at(upper('{'),upper(repobject:aline[i]))
               npos2:=at(upper('}'),upper(repobject:aline[i]))
            ELSE
               npos1:=rat(upper('{'),upper(repobject:aline[i]))
               npos2:=rat(upper('}'),upper(repobject:aline[i]))
            ENDIF
            lin:=i
            i:=len(repobject:aline)+1
            sw1:=1
        ENDIF
NEXT i
IF sw1=1
   RETURN substr(repobject:aline[lin],npos1,npos2-npos1+1)
ENDIF
RETURN cDefault

METHOD leadatologic(cName,cPropmet,cDefault) CLASS TREPORT
local i,sw
sw:=0
FOR i:=1 to len(repobject:aline)
IF at(upper(cname)+' ',upper(repobject:aline[i]))#0
   sw:=1
ELSE
   IF sw==1
      IF at(upper(cPropmet)+' ',upper(repobject:aline[i]))>0
         RETURN .T.
      ENDIF
      IF len(trim(repobject:aline[i]))==0
         i=len(repobject:aline)+1
         RETURN cDefault
      ENDIF
   ENDIF
ENDIF
NEXT i
RETURN cDefault

METHOD clean(cfvalue) CLASS TREPORT
cfvalue:=strtran(cfvalue,'"','')
cfvalue:=strtran(cfvalue,"'","")
RETURN cfvalue

METHOD learowi(cname,npar) CLASS TREPORT
local i,npos1,nrow
sw:=0
nrow:='0'
cname:=''
FOR i:=1 to len(repobject:aline)
    IF at(upper('IMAGE')+' ',upper(repobject:aline[i]))#0
       IF npar=1
          npos1:=at("AT",upper(repobject:aline[i]))
       ELSE
          npos1:=at("TO",upper(repobject:aline[i]))
       ENDIF
       nrow:=substr(repobject:aline[i],npos1+3,4)
       i:=len(repobject:aline)
    ENDIF
NEXT i
RETURN nrow

METHOD leacoli(cname,npar) CLASS TREPORT
local i,npos,ncol
ncol:='0'
cname:=''
FOR i:=1 to len(repobject:aline)
IF at(upper('IMAGE')+' ',upper(repobject:aline[i]))#0
   IF npar=1
      npos:=at(",",repobject:aline[i])
   ELSE
      npos:=rat(",",repobject:aline[i])
   ENDIF
   ncol:=substr(repobject:aline[i],npos+1,4)
   i:=len(repobject:aline)
ENDIF
NEXT i
RETURN ncol


*****************************************************************************
*                                                                           *
*          MINIFRM - Print FRM files to TPRINT                              *
*                                                                           *
*                                V 1.0                                      *
*  Creador Daniel Piperno                                                   *
*  Modificado Ciro Vargas Clemow                                            *
*                                                                           *
*****************************************************************************

***************************************** Características *******************************************
* Funciona en forma similar que con el FRM estándar.
* Si está la opción TO PRINT, imprime directamente a la impresora. Si no lo está, hace un preview.
* Usa la impresora por defecto.
* Si el ancho es <= 80 usa Courier New 12, simulando el modo normal.
* Si no usa Courier New  7 simulando condensada.
*
* Diferencias con el FRM estandar
* -------------------------------
* Agregados:
*   - Agrega separadores de miles en los números
*   - Imprime en BOLD los títulos, totales y subtotales
*
* Eliminados:
*   - Está deshabilitada la opción PLAIN
*   - Está deshabilitada la opción TO FILE
*   - No traduce caracteres especiales CHR(xx)
*   - Está deshabilitado el salto de hoja antes del reporte
***************************************************************************************************


#include "error.ch"


********* Parámetros del reporte ************
#define _RF_FIRSTCOL  0  && Offset Primer columna
#define _RF_FIRSTROW  1  && Offset Primer fila
#define _RF_ROWINC    4  && Interlineado
#define _RF_FONT      "Courier New"  && Font a usar (No usar proporcional!)
#define _RF_SIZECONDENSED 7   && Tamaño de font a usar cuando el ancho es mayor de 80 columnas (132)
#define _RF_SIZENORMAL   12   && Tamaño de font a usar cuando el ancho es menor de 80 columnas
#define _RF_ROWSINLETTER  60  && Cantidad de Filas máximo que soporta el tamaño carta. Si hay mas líneas, se usa Legal


**** Constantes para el Nation Message ********
#define _RF_PAGENO       3     && Página
#define _RF_SUBTOTAL     4     && Subtotal
#define _RF_SUBSUBTOTAL  5     && SubSubtotal
#define _RF_TOTAL        6     && Total

********** Tamaños de buffer *************
#define  SIZE_FILE_BUFF             1990
#define  SIZE_LENGTHS_BUFF          110
#define  SIZE_OFFSETS_BUFF          110
#define  SIZE_EXPR_BUFF             1440
#define  SIZE_FIELDS_BUFF           300
#define  SIZE_PARAMS_BUFF           24

**************** offsets *******************
#define  LENGTHS_OFFSET             5
#define  OFFSETS_OFFSET             115
#define  EXPR_OFFSET                225
#define  FIELDS_OFFSET              1665
#define  PARAMS_OFFSET              1965
#define  FIELD_WIDTH_OFFSET         1
#define  FIELD_TOTALS_OFFSET        6
#define  FIELD_DECIMALS_OFFSET      7
#define  FIELD_CONTENT_EXPR_OFFSET  9
#define  FIELD_HEADER_EXPR_OFFSET   11
#define  PAGE_HDR_OFFSET            1
#define  GRP_EXPR_OFFSET            3
#define  SUB_EXPR_OFFSET            5
#define  GRP_HDR_OFFSET             7
#define  SUB_HDR_OFFSET             9
#define  PAGE_WIDTH_OFFSET          11
#define  LNS_PER_PAGE_OFFSET        13
#define  LEFT_MRGN_OFFSET           15
#define  RIGHT_MGRN_OFFSET          17
#define  COL_COUNT_OFFSET           19
#define  DBL_SPACE_OFFSET           21
#define  SUMMARY_RPT_OFFSET         22
#define  PE_OFFSET                  23
#define  OPTION_OFFSET              24

********* Definiciones para el Array del reporte *************
#define RP_HEADER   1
#define RP_WIDTH    2
#define RP_LMARGIN  3
#define RP_RMARGIN  4
#define RP_LINES    5
#define RP_SPACING  6
#define RP_BEJECT   7
#define RP_AEJECT   8
#define RP_PLAIN    9
#define RP_SUMMARY  10
#define RP_COLUMNS  11
#define RP_GROUPS   12
#define RP_HEADING  13

#define RP_COUNT    13


******** Columnas ************
#define RC_EXP      1
#define RC_TEXT     2
#define RC_TYPE     3
#define RC_HEADER   4
#define RC_WIDTH    5

#define RC_DECIMALS 6
#define RC_TOTAL    7
#define RC_PICT     8

#define RC_COUNT    8

****** Grupos ***********
#define RG_EXP      1
#define RG_TEXT     2
#define RG_TYPE     3
#define RG_HEADER   4
#define RG_AEJECT   5

#define RG_COUNT    5

********** Errores ************
#define  F_OK                       0   && Ok!
#define  F_EMPTY                   -3   && Archivo vacío
#define  F_ERROR                   -1   && Error desconocido
#define  F_NOEXIST                  2   && Archivo inexistente

////#include "oohg.ch"

*****************************************************************************
PROCEDURE __ReportFormwin( cFRMName, lPrinter, cAltFile, lNoConsole, bFor, ;
                       bWhile, nNext, nRecord, lRest, lPlain, cHeading, ;
                       lBEject, lSummary )
******************************************************************************

LOCAL nCol, nGroup
LOCAL xBreakVal, lBroke := .F.
LOCAL err, sAuxST
LOCAL lAnyTotals
LOCAL lAnySubTotals ,lSale
Private  lUseLetter

empty(cAltFile)
empty(lNoConsole)
empty(lplain)

sicvar:=setinteractiveclose()
SET INTERACTIVECLOSE ON
********* Parametros ************
IF cFRMName == NIL
  err := ErrorNew()
  err:severity := ES_ERROR
  err:genCode := EG_ARG
  err:subSystem := "FRMLBL"
  Eval(ErrorBlock(), err)
ELSE
  IF AT( ".", cFRMName ) == 0
     cFRMName := TRIM( cFRMName ) + ".FRM"
  ENDIF
ENDIF

IF lPrinter == NIL
 lPrinter   := .F.
ENDIF

IF cHeading == NIL
 cHeading := ""
ENDIF


lSale:=.F.  //variable para salir si hay algun error o cancela el dialogo
BEGIN SEQUENCE

    ********** Cargo los datos del FRM en el vector aReportData ***********
    aReportData := __FrmLoad( cFRMName )
    nMaxLinesAvail := aReportData[RP_LINES]

     ********** Determino el tipo de papel a usar **********
     lUseLetter  := (aReportData[ RP_LINES ] <= _RF_ROWSINLETTER)
     oprint:=tprint()
     oprint:init()
     lp:=.T.
     IF lprinter
       lp:=.F.
     ENDIF
     IF luseletter
         npap:=1
     ELSE
         npap:=5
     ENDIF
     oprint:selprinter(.T. , lp, ,npap  )  /// select,preview,landscape,papersize
     IF oprint:lprerror
        oprint:release()
        lSale:=.T.
        BREAK
     ENDIF
     ********************** MINIPRINT *******************
IF lSummary != NIL
       aReportData[ RP_SUMMARY ] := lSummary
    ENDIF
    IF lBEject != NIL .AND. lBEject
        aReportData[ RP_BEJECT ]  := .F.
    ENDIF

    aReportData[ RP_HEADING ]    := cHeading

    nPageNumber := 1      && Primer página
    lFirstPass  := .T.

    nLinesLeft  := aReportData[ RP_LINES ]

    *********** Inicializo documento **************

    oprint:begindoc()
    oprint:beginpage()

    nPosRow := _RF_FIRSTROW
    nPosCol := _RF_FIRSTCOL

    ******* Imprimo cabezal *********
    CabezalReporte()

    ******* Inicializo totales *********
    aReportTotals := ARRAY( LEN(aReportData[RP_GROUPS]) + 1, LEN(aReportData[RP_COLUMNS]) )
    FOR nCol := 1 TO LEN(aReportData[RP_COLUMNS])
      IF aReportData[RP_COLUMNS,nCol,RC_TOTAL]
        FOR nGroup := 1 TO LEN(aReportTotals)
           aReportTotals[nGroup,nCol] := 0
        NEXT
      ENDIF
    NEXT
    aGroupTotals := ARRAY( LEN(aReportData[RP_GROUPS]) )

    ********** Ejecuto el reporte ! ***********
    DBEval( { || EjecutoReporte() }, bFor, bWhile, nNext, nRecord, lRest )

    ********* Imprimo los totales, si tiene ***********
    FOR nGroup := LEN(aReportData[RP_GROUPS]) TO 1 STEP -1

      ****** El grupo tiene subtotales? **********
      lAnySubTotals := .F.
      FOR nCol := 1 TO LEN(aReportData[RP_COLUMNS])
        IF aReportData[RP_COLUMNS,nCol,RC_TOTAL]
           lAnySubTotals := .T.
           EXIT
        ENDIF
      NEXT

      IF !lAnySubTotals
        LOOP
      ENDIF

      ************ Verifico salto de hoja **********
      IF nLinesLeft < 2
        EjectPage()
        IF aReportData[ RP_PLAIN ]
           nLinesLeft := 1000
        ELSE
           CabezalReporte()
        ENDIF
      ENDIF

      ********** Imprimo Mensaje de Subtotal **************
      PrintIt(IF(nGroup==1,NationMsg(_RF_SUBTOTAL), NationMsg(_RF_SUBSUBTOTAL)) , .t.)

      ***** Armo la linea de subtotales *****
      sAuxSt := ""
      FOR nCol := 1 TO LEN(aReportData[RP_COLUMNS])
        IF aReportData[RP_COLUMNS,nCol,RC_TOTAL]
           sAuxSt := sAuxSt + " " +  TRANSFORM(aReportTotals[nGroup+1,nCol], ConvPic(aReportData[RP_COLUMNS,nCol,RC_PICT]))
        ELSE
           sAuxSt := sAuxSt + " " + SPACE(aReportData[RP_COLUMNS,nCol,RC_WIDTH])
        ENDIF
      NEXT

      **** Imprimo la linea de subtotales ****
      ImprimoUnaLinea(Substr(sAuxSt,2), .t.)
      SaltoLin()

    NEXT

    ******* Genero el Total general ******
    **** Si me quedan menos de 2 lineas, salto de hoja  ****
    IF nLinesLeft < 2
      EjectPage()
      IF aReportData[ RP_PLAIN ]
        nLinesLeft := 1000
      ELSE
        CabezalReporte()
      ENDIF
    ENDIF

    *********** Veo si hay que imprimir totales ***********
    lAnyTotals := .F.
    FOR nCol := 1 TO LEN(aReportData[RP_COLUMNS])
      IF aReportData[RP_COLUMNS,nCol,RC_TOTAL]
        lAnyTotals := .T.
        EXIT
      ENDIF
    NEXT nCol


    IF lAnyTotals

       ********** Mensaje de total *************
       PrintIt(NationMsg(_RF_TOTAL ) , .t.)

       **** Armo la linea de totales *****
       sAuxSt := ""
       FOR nCol := 1 TO LEN(aReportData[RP_COLUMNS])
         IF aReportData[RP_COLUMNS,nCol,RC_TOTAL]
           sAuxSt := sAuxSt + " " + TRANSFORM(aReportTotals[1,nCol], ConvPic(aReportData[RP_COLUMNS,nCol,RC_PICT]))
         ELSE
           sAuxSt := sAuxSt + " " + SPACE(aReportData[RP_COLUMNS,nCol,RC_WIDTH])
         ENDIF
       NEXT nCol

       ImprimoUnaLinea(Substr(sAuxSt,2), .t.)
       SaltoLin()

    ENDIF

    ******* Si pidió un eject al final del reporte, lo largo *********
    IF aReportData[ RP_AEJECT ]
////       EjectPage()  en windows es mejor no mandar este eject en dos si es valido
    ENDIF


RECOVER USING xBreakVal

  lBroke := .T.

END SEQUENCE

IF lSale
 setinteractiveclose(sicvar)
   RETURN
ENDIF

******** Libero memoria *********
aReportData   := NIL
aReportTotals  := NIL
aGroupTotals   := NIL
nPageNumber   := NIL
lFirstPass    := NIL
nLinesLeft    := NIL
nMaxLinesAvail := NIL

****** Cierro el reporte *******
oprint:endpage()
oprint:enddoc()

IF lBroke
 BREAK xBreakVal
END
  setinteractiveclose(sicvar)
RETURN

*******************************
STATIC PROCEDURE EjecutoReporte
*******************************
*  Ejecutado por DBEVAL() cada vez que un registro está en el scope
LOCAL aRecordHeader  := {}
LOCAL aRecordToPrint := {}
LOCAL nCol
LOCAL nGroup
LOCAL lGroupChanged  := .F.
LOCAL lEjectGrp := .F.
LOCAL nMaxLines
LOCAL nLine
LOCAL cLine

LOCAL lAnySubTotals

******** si la columna tiene totales, los sumo ***********
FOR nCol := 1 TO LEN(aReportData[RP_COLUMNS])
  IF aReportData[RP_COLUMNS,nCol,RC_TOTAL]
     aReportTotals[ 1 ,nCol] += EVAL( aReportData[RP_COLUMNS,nCol,RC_EXP] )
  ENDIF
NEXT

********** veo si cambio alguno de los grupos. Si cambió, totalizo los anteriores *********
IF !lFirstPass
  FOR nGroup := LEN(aReportData[RP_GROUPS]) TO 1 STEP -1
   lAnySubTotals := .F.
   FOR nCol := 1 TO LEN(aReportData[RP_COLUMNS])
     IF aReportData[RP_COLUMNS,nCol,RC_TOTAL]
        lAnySubTotals := .T.
        EXIT
     ENDIF
   NEXT

   IF !lAnySubTotals
     LOOP
   ENDIF

     ******** Veo si cambio el grupo *********
     IF HB_VALTOSTR(EVAL(aReportData[RP_GROUPS,nGroup,RG_EXP]),;
        aReportData[RP_GROUPS,nGroup,RG_TYPE]) != aGroupTotals[nGroup]
        AADD( aRecordHeader, IF(nGroup==1,NationMsg(_RF_SUBTOTAL),;
                                          NationMsg(_RF_SUBSUBTOTAL)) )
        AADD( aRecordHeader, "" )

        IF ( nGroup == 1 )
           lEjectGrp := aReportData[ RP_GROUPS, nGroup, RG_AEJECT ]      
        ENDIF

        ********** Recorro las columnas totalizando *************
        FOR nCol := 1 TO LEN(aReportData[RP_COLUMNS])
           IF aReportData[RP_COLUMNS,nCol,RC_TOTAL]
              aRecordHeader[ LEN(aRecordHeader) ] += TRANSFORM(aReportTotals[nGroup+1,nCol], ConvPic(aReportData[RP_COLUMNS,nCol,RC_PICT]))
              aReportTotals[nGroup+1,nCol] := 0
           ELSE
              aRecordHeader[ LEN(aRecordHeader) ] += SPACE(aReportData[RP_COLUMNS,nCol,RC_WIDTH])
           ENDIF
           aRecordHeader[ LEN(aRecordHeader) ] += " "
        NEXT
        aRecordHeader[LEN(aRecordHeader)] := LEFT( aRecordHeader[LEN(aRecordHeader)], LEN(aRecordHeader[LEN(aRecordHeader)]) - 1 )
     ENDIF
  NEXT

ENDIF

lFirstPass = .F.

IF ( LEN( aRecordHeader ) > 0 ) .AND. lEjectGrp
  IF LEN( aRecordHeader ) > nLinesLeft
     EjectPage()

     IF ( aReportData[ RP_PLAIN ] )
        nLinesLeft := 1000
     ELSE
        CabezalReporte()
     ENDIF

  ENDIF

  AEVAL( aRecordHeader, { | HeaderLine | PrintIt(HeaderLine, .t. ) })

  aRecordHeader := {}

  EjectPage()

  IF ( aReportData[ RP_PLAIN ] )
     nLinesLeft := 1000

  ELSE
     CabezalReporte()
  ENDIF

ENDIF

********* Agrego un cabezal en los grupos que cambiaron **************
FOR nGroup := 1 TO LEN(aReportData[RP_GROUPS])
  IF HB_VALTOSTR(EVAL(aReportData[RP_GROUPS,nGroup,RG_EXP]),aReportData[RP_GROUPS,nGroup,RG_TYPE]) == aGroupTotals[nGroup]
  ELSE
     AADD( aRecordHeader, "" )
     AADD( aRecordHeader, IF(nGroup==1,"** ","* ") +;
           aReportData[RP_GROUPS,nGroup,RG_HEADER] + " " +;
           HB_VALTOSTR(EVAL(aReportData[RP_GROUPS,nGroup,RG_EXP]), ;
           aReportData[RP_GROUPS,nGroup,RG_TYPE]) )
  ENDIF
NEXT

*********** Generé cabezal? ************
IF LEN( aRecordHeader ) > 0
  **** Si entra, lo imprimo ******
  IF LEN( aRecordHeader ) > nLinesLeft
     EjectPage()
     IF aReportData[ RP_PLAIN ]
        nLinesLeft := 1000
     ELSE
        CabezalReporte()
     ENDIF
  ENDIF

  ******** Imprimo cabezal ***********
  AEVAL( aRecordHeader, { | HeaderLine | PrintIt(HeaderLine, .t. ) } )

  ******* Decremento las lineas disponibles *********
  nLinesLeft -= LEN( aRecordHeader )

  ******* Controlo el salto de hoja ***********
  IF nLinesLeft == 0
     EjectPage()
     IF aReportData[ RP_PLAIN ]
        nLinesLeft := 1000
     ELSE
        CabezalReporte()
     ENDIF
  ENDIF
ENDIF

************** Sumo los totales ********************
FOR nCol := 1 TO LEN(aReportData[RP_COLUMNS])
  IF aReportData[RP_COLUMNS,nCol,RC_TOTAL]
     FOR nGroup := 1 TO LEN( aReportTotals ) - 1
        aReportTotals[nGroup+1,nCol] += EVAL( aReportData[RP_COLUMNS,nCol,RC_EXP] )
     NEXT
  ENDIF
NEXT

************ Reseteo grupos ************
FOR nGroup := 1 TO LEN(aReportData[RP_GROUPS])
  aGroupTotals[nGroup] := HB_VALTOSTR(EVAL(aReportData[RP_GROUPS,nGroup,RG_EXP]),;
                                aReportData[RP_GROUPS,nGroup,RG_TYPE])
NEXT

IF !aReportData[ RP_SUMMARY ]
 **** Calculo cuantas lineas necesita ****
 nMaxLines := 1
  FOR nCol := 1 TO LEN(aReportData[RP_COLUMNS])
     IF aReportData[RP_COLUMNS,nCol,RC_TYPE] $ "CM"
        nMaxLines := MAX(XMLCOUNT(EVAL(aReportData[RP_COLUMNS,nCol,RC_EXP]),;
                     aReportData[RP_COLUMNS,nCol,RC_WIDTH]), nMaxLines)
     ENDIF
  NEXT

  ********* Defino un array con la cantidad de lineas necesarias para imprimir *****
  ASIZE( aRecordToPrint, nMaxLines )
  AFILL( aRecordToPrint, "" )

  ***** Cargo el registro en el array para imprimir ************
  FOR nCol := 1 TO LEN(aReportData[RP_COLUMNS])
     FOR nLine := 1 TO nMaxLines
        ***** Cargo las variables tipo MEMO o CHARACTER **********
        IF aReportData[RP_COLUMNS,nCol,RC_TYPE] $ "CM"
           cLine := XMEMOLINE(TRIM(EVAL(aReportData[RP_COLUMNS,nCol,RC_EXP])),;
                         aReportData[RP_COLUMNS,nCol,RC_WIDTH], nLine )
           cLine := PADR( cLine, aReportData[RP_COLUMNS,nCol,RC_WIDTH] )
        ELSE
           IF nLine == 1
               ********* Aqui le puse los separadores de miles, que no está por defecto en los frm
               ********* Si se desea quitar, descomentar estas líneas y comentar las siguientes
*                  cLine := TRANSFORM(EVAL(aReportData[RP_COLUMNS,nCol,RC_EXP]),;
*                           aReportData[RP_COLUMNS,nCol,RC_PICT])
               cLine := TRANSFORM(EVAL(aReportData[RP_COLUMNS,nCol,RC_EXP]),;
                        ConvPic(aReportData[RP_COLUMNS,nCol,RC_PICT]))

              cLine := PADR( cLine, aReportData[RP_COLUMNS,nCol,RC_WIDTH] )
           ELSE
              cLine := SPACE( aReportData[RP_COLUMNS,nCol,RC_WIDTH])
           ENDIF
        ENDIF
        IF nCol > 1
           aRecordToPrint[ nLine ] += " "
        ENDIF
        aRecordToPrint[ nLine ] += cLine
     NEXT
  NEXT

  ********* Entra el registro en la página?? ********
  IF LEN( aRecordToPrint ) > nLinesLeft
     ***** Si no entra en la página actual, verifico si entra en una página completa
     ***** Si no entra: Lo parto y lo imprimo
     IF LEN( aRecordToPrint ) > nMaxLinesAvail
        nLine := 1
        DO WHILE nLine < LEN( aRecordToPrint )
           PrintIt(aRecordToPrint[nLine], .f. )
           nLine++
           nLinesLeft--
           IF nLinesLeft == 0
              EjectPage()
              IF aReportData[ RP_PLAIN ]
                 nLinesLeft := 1000
              ELSE
                 CabezalReporte()
              ENDIF
           ENDIF
        ENDDO
     ELSE
        EjectPage()
        IF aReportData[ RP_PLAIN ]
           nLinesLeft := 1000
        ELSE
           CabezalReporte()
        ENDIF
        AEVAL( aRecordToPrint, ;
           { | RecordLine | ;
             PrintIt(RecordLine, .f. ) ;
           } ;
        )
        nLinesLeft -= LEN( aRecordToPrint )
     ENDIF
  ELSE
     AEVAL( aRecordToPrint, ;
        { | RecordLine | ;
          PrintIt(RecordLine, .f. ) ;
        } ;
     )
     nLinesLeft -= LEN( aRecordToPrint )
  ENDIF

  ***** Verifico salto de hoja ******
  IF nLinesLeft == 0
     EjectPage()
     IF aReportData[ RP_PLAIN ]
        nLinesLeft := 1000
     ELSE
        CabezalReporte()
     ENDIF
  ENDIF

  **** Si seleccionó espaciado distinto de 1, dejo los renglones en blanco *******
  IF aReportData[ RP_SPACING ] > 1
     IF nLinesLeft > aReportData[ RP_SPACING ] - 1
        FOR nLine := 2 TO aReportData[ RP_SPACING ]
           PrintIt("", .f.)
           nLinesLeft--
        NEXT
     ENDIF
  ENDIF

ENDIF

RETURN


********************************
STATIC PROCEDURE CabezalReporte
********************************
LOCAL nLinesInHeader := 0
LOCAL aPageHeader    := {}
LOCAL nHeadingLength := aReportData[RP_WIDTH] - aReportData[RP_LMARGIN] - 30
LOCAL nCol, nLine, nMaxColLength,  cHeader
LOCAL nHeadLine
LOCAL nRPageSize
LOCAL aTempPgHeader

nRPageSize := aReportData[RP_WIDTH] - aReportData[RP_RMARGIN]

****** Creo el cabezal y lo pongo en el array aPageHeader *****

IF aReportData[RP_HEADING] == ""
   AADD( aPageHeader, NationMsg(_RF_PAGENO) + STR(nPageNumber,6) )
ELSE
   aTempPgHeader := ParseHeader( aReportData[ RP_HEADING ], Occurs( ";", aReportData[ RP_HEADING ] ) + 1 )

   FOR nLine := 1 TO LEN( aTempPgHeader )
       **** Calculo cuantas lineas lleva el cabezal ****
       nLinesInHeader := MAX( XMLCOUNT( LTRIM( aTempPgHeader[ nLine ] ),  nHeadingLength ), 1 )

       ****** Agrego las líneas del cabezal al array *****
       FOR nHeadLine := 1 TO nLinesInHeader
            AADD( aPageHeader, SPACE( 15 ) + PADC( TRIM( XMEMOLINE( LTRIM( aTempPgHeader[ nLine ] ),;
                 nHeadingLength, nHeadLine ) ), nHeadingLength ) )
       NEXT nHeadLine

   NEXT nLine
   aPageHeader[ 1 ] := STUFF( aPageHeader[ 1 ], 1, 14, NationMsg(_RF_PAGENO) + STR(nPageNumber,6) )

ENDIF
AADD( aPageHeader, DTOC(DATE()) )
/////AADD( aPageHeader, TIME() )


********** Agrego el header ************
FOR nLine := 1 TO LEN( aReportData[RP_HEADER] )
  ****** calculo la cantidad de lineas necesarias **********
  nLinesInHeader := MAX( XMLCOUNT( LTRIM( aReportData[RP_HEADER, nLine ] ), nRPageSize ), 1 )

  **** Lo agrego al array *******
  FOR nHeadLine := 1 TO nLinesInHeader
     cHeader := TRIM( XMEMOLINE( LTRIM( aReportData[ RP_HEADER, nLine ] ), nRPageSize, nHeadLine) )
     AADD( aPageHeader, SPACE( ( nRPageSize - aReportData[ RP_LMARGIN ] - LEN( cHeader ) ) / 2 ) + cHeader )
  NEXT nHeadLine

NEXT nLine

******** Agrego cabezales de las columnas *********
nLinesInHeader := LEN( aPageHeader )

**** Busco el cabezal mas ancho *****
nMaxColLength := 0
FOR nCol := 1 TO LEN( aReportData[ RP_COLUMNS ] )
   nMaxColLength := MAX( LEN(aReportData[RP_COLUMNS,nCol,RC_HEADER]), nMaxColLength )
NEXT
FOR nCol := 1 TO LEN( aReportData[ RP_COLUMNS ] )
  ASIZE( aReportData[RP_COLUMNS,nCol,RC_HEADER], nMaxColLength )
NEXT

FOR nLine := 1 TO nMaxColLength
  AADD( aPageHeader, "" )
NEXT

FOR nCol := 1 TO LEN(aReportData[RP_COLUMNS])
  FOR nLine := 1 TO nMaxColLength
     IF nCol > 1
        aPageHeader[ nLinesInHeader + nLine ] += " "
     ENDIF
     IF aReportData[RP_COLUMNS,nCol,RC_HEADER,nLine] == NIL
        aPageHeader[ nLinesInHeader + nLine ] += SPACE( aReportData[RP_COLUMNS,nCol,RC_WIDTH] )
     ELSE
        IF aReportData[RP_COLUMNS,nCol,RC_TYPE] == "N"
           aPageHeader[ nLinesInHeader + nLine ] += PADL(aReportData[RP_COLUMNS,nCol,RC_HEADER,nLine],;
                       aReportData[RP_COLUMNS,nCol,RC_WIDTH])
        ELSE
           aPageHeader[ nLinesInHeader + nLine ] += PADR(aReportData[RP_COLUMNS,nCol,RC_HEADER,nLine],;
                       aReportData[RP_COLUMNS,nCol,RC_WIDTH])
        ENDIF
     ENDIF
  NEXT
NEXT

***** Dejo 2 lineas en blanco ******
AADD( aPageHeader, "" )
AADD( aPageHeader, "" )

******** Imprimo el cabezal **********
AEVAL( aPageHeader, { | HeaderLine | PrintIt(HeaderLine, .t. ) } )

*** Incremento el numero de pagina ****
nPageNumber++

nLinesLeft := aReportData[RP_LINES] - LEN( aPageHeader )
nMaxLinesAvail := aReportData[RP_LINES] - LEN( aPageHeader )

RETURN

******************************************
STATIC FUNCTION Occurs( cSearch, cTarget )
******************************************
*  Cuantas veces aparece <cSearch> en <cTarget>

LOCAL nPos, nCount := 0
DO WHILE !EMPTY( cTarget )
   IF (nPos := AT( cSearch, cTarget )) != 0
      nCount++
      cTarget := SUBSTR( cTarget, nPos + 1 )
   ELSE
      cTarget := ""
   ENDIF
ENDDO
RETURN nCount


******************************************
STATIC PROCEDURE PrintIt( cString, lBold )
******************************************
IF cString == NIL
   cString := ""
ENDIF

ImprimoUnaLinea(cString , lBold)
SaltoLin()

RETURN

**************************
STATIC PROCEDURE EjectPage
**************************
*  Finalizo una página y comienzo la siguiente.....
oprint:endpage()
oprint:beginpage()

nPosRow := _RF_FIRSTROW
RETURN

*****************************************************************
STATIC FUNCTION XMLCOUNT( cString, nLineLength, nTabSize, lWrap )
*****************************************************************
nLineLength := IF( nLineLength == NIL, 79, nLineLength )
nTabSize := IF( nTabSize == NIL, 4, nTabSize )
lWrap := IF( lWrap == NIL, .T., .F. )
IF nTabSize >= nLineLength
   nTabSize := nLineLength - 1
ENDIF
RETURN( MLCOUNT( TRIM(cString), nLineLength, nTabSize, lWrap ) )

*******************************************************************************
STATIC FUNCTION XMEMOLINE( cString, nLineLength, nLineNumber, nTabSize, lWrap )
*******************************************************************************
nLineLength := IF( nLineLength == NIL, 79, nLineLength )
nLineNumber := IF( nLineNumber == NIL, 1, nLineNumber )
nTabSize := IF( nTabSize == NIL, 4, nTabSize )
lWrap := IF( lWrap == NIL, .T., lWrap )

IF nTabSize >= nLineLength
   nTabSize := nLineLength - 1
ENDIF
RETURN( MEMOLINE( cString, nLineLength, nLineNumber, nTabSize, lWrap ) )



******************************
STATIC FUNCTION ConvPic(sPic)
******************************
* Agrego separador de miles, que el FRM estandar no lo hace....
* Ojo, esto puede hacer que de un overflow si no se prevee el espacio en la columna

Local nPto, nEnt, nDec, sResult
Local aPics := {"9","99","999","9999","9,999","99,999","999,999","9999,999","9,999,999","99,999,999","999,999,999","9999,999,999","9,999,999,999","99,999,999,999","999,999,999,999"}

nPto = at(".",sPic)

IF (Left(sPic,1) <> "9") .or. (nPto = 0)
   RETURN sPic
ENDIF

nDec = Substr(sPic, nPto)
nEnt = Left(sPic, nPto - 1)

IF Len(nEnt) > 15
   sResult = sPic
ELSE
   sResult = aPics[Len(nEnt)] + nDec
ENDIF
RETURN sResult


*****************************
STATIC Function SaltoLin()
*****************************
//////nPosRow := nPosRow + _RF_ROWINC    ///para asar a rowcol y quitar mm
nPosRow++
nPosCol := _RF_FIRSTCOL
RETURN .t.

*************************************
STATIC Function ImprimoUnaLinea(sLin, lBold)
*************************************
Local sAux

sAux := HB_OEMTOANSI(sLin)
IF aReportData[RP_WIDTH] <= 80
   oprint:printdata(nPosrow,nPoscol+aReportData[RP_LMARGIN],sAux, ,_RF_SIZENORMAL ,lbold)
ELSE
   oprint:printdata(nPosrow,nPoscol+aReportData[RP_LMARGIN],sAux, ,_RF_SIZECONDENSED ,lbold)
ENDIF


nPosCol := nPosCol + Len(sAux)


RETURN .t.


******************************
STATIC FUNCTION __FrmLoad( cFrmFile )
******************************
* Cargo el archivo FRM en un array

LOCAL cFieldsBuff
LOCAL cParamsBuff
LOCAL nFieldOffset   := 0
LOCAL cFileBuff      := SPACE(SIZE_FILE_BUFF)
LOCAL cGroupExp      := SPACE(200)
LOCAL cSubGroupExp   := SPACE(200)
LOCAL nColCount      := 0
LOCAL nCount
LOCAL nFrmHandle
LOCAL nBytesRead
LOCAL nPointer       := 0
LOCAL nFileError
LOCAL cOptionByte

LOCAL aReport[ RP_COUNT ]
LOCAL err

LOCAL cDefPath
LOCAL aPaths
LOCAL nPathIndex := 0

LOCAL aHeader
LOCAL nHeaderIndex

cLengthsBuff  := ""
cOffsetsBuff  := ""
cExprBuff     := ""

********** Valores por defecto ***********
aReport[ RP_HEADER ]    := {}
aReport[ RP_WIDTH ]     := 80
aReport[ RP_LMARGIN ]   := 8
aReport[ RP_RMARGIN ]   := 0
aReport[ RP_LINES ]     := 58
aReport[ RP_SPACING ]   := 1
aReport[ RP_BEJECT ]    := .F.
aReport[ RP_AEJECT ]    := .F.
aReport[ RP_PLAIN ]     := .F.
aReport[ RP_SUMMARY ]   := .F.
aReport[ RP_COLUMNS ]   := {}
aReport[ RP_GROUPS ]    := {}
aReport[ RP_HEADING ]   := ""

******** Abro el FRM **********
nFrmHandle := FOPEN( cFrmFile )

IF ( !EMPTY( nFileError := FERROR() ) ) .AND. !( "\" $ cFrmFile .OR. ":" $ cFrmFile )

  **** Busco en el path ********
  cDefPath := SET( _SET_DEFAULT ) + ";" + SET( _SET_PATH )
  cDefPath := STRTRAN( cDefPath, ",", ";" )
  aPaths := ListAsArray( cDefPath, ";" )

  FOR nPathIndex := 1 TO LEN( aPaths )
     nFrmHandle := FOPEN( aPaths[ nPathIndex ] + "\" + cFrmFile )
     IF EMPTY( nFileError := FERROR() )
        EXIT
     ENDIF
  NEXT nPathIndex

ENDIF

******* No pude abrirlo? ********
IF nFileError != F_OK
  err := ErrorNew()
  err:severity := ES_ERROR
  err:genCode := EG_OPEN
  err:subSystem := "FRMLBL"
  err:osCode := nFileError
  err:filename := cFrmFile
  Eval(ErrorBlock(), err)
ENDIF

******* Pude abrirlo? ********
IF nFileError = F_OK

  FSEEK(nFrmHandle, 0)

  nFileError = FERROR()
  IF nFileError = F_OK

     **** Cargo el FRM al buffer ****
     nBytesRead = FREAD(nFrmHandle, @cFileBuff, SIZE_FILE_BUFF)
     IF nBytesRead = 0
        nFileError = F_EMPTY
     ELSE
        nFileError = FERROR()
     ENDIF

     IF nFileError = F_OK
        *** Verifico que sea un FRM ****
        IF BIN2W(SUBSTR(cFileBuff, 1, 2)) = 2 .AND.;
          BIN2W(SUBSTR(cFileBuff, SIZE_FILE_BUFF - 1, 2)) = 2
           nFileError = F_OK
        ELSE
           nFileError = F_ERROR
        ENDIF

     ENDIF

  ENDIF

  ******* Cierro el archivo *********
  IF !FCLOSE(nFrmHandle)
     nFileError = FERROR()
  ENDIF

ENDIF

****** Todo ok *********
IF nFileError = F_OK

   ***** Cargo el FRM en los buffers *******
   cLengthsBuff = SUBSTR(cFileBuff, LENGTHS_OFFSET, SIZE_LENGTHS_BUFF)
   cOffsetsBuff = SUBSTR(cFileBuff, OFFSETS_OFFSET, SIZE_OFFSETS_BUFF)
   cExprBuff    = SUBSTR(cFileBuff, EXPR_OFFSET, SIZE_EXPR_BUFF)
   cFieldsBuff  = SUBSTR(cFileBuff, FIELDS_OFFSET, SIZE_FIELDS_BUFF)
   cParamsBuff  = SUBSTR(cFileBuff, PARAMS_OFFSET, SIZE_PARAMS_BUFF)

   aReport[ RP_WIDTH ]   := BIN2W(SUBSTR(cParamsBuff, PAGE_WIDTH_OFFSET, 2))
   aReport[ RP_LINES ]   := BIN2W(SUBSTR(cParamsBuff, LNS_PER_PAGE_OFFSET, 2))
   aReport[ RP_LMARGIN ] := BIN2W(SUBSTR(cParamsBuff, LEFT_MRGN_OFFSET, 2))
   aReport[ RP_RMARGIN ] := BIN2W(SUBSTR(cParamsBuff, RIGHT_MGRN_OFFSET, 2))

   nColCount  = BIN2W(SUBSTR(cParamsBuff, COL_COUNT_OFFSET, 2))
   * Espaciado
   aReport[ RP_SPACING ] := IF(SUBSTR(cParamsBuff, DBL_SPACE_OFFSET, 1) $ "YyTt", 2, 1)
   * Resumen?
   aReport[ RP_SUMMARY ] := IF(SUBSTR(cParamsBuff, SUMMARY_RPT_OFFSET, 1) $ "YyTt", .T., .F.)
   cOptionByte = ASC(SUBSTR(cParamsBuff, OPTION_OFFSET, 1))
   * Eject antes?
   IF INT(cOptionByte / 2) = 1
      aReport[ RP_AEJECT ] := .T.
      cOptionByte -= 2
   ENDIF
   nPointer = BIN2W(SUBSTR(cParamsBuff, PAGE_HDR_OFFSET, 2))
   nHeaderIndex := 4
   aHeader := ParseHeader( GetExpr( nPointer ), nHeaderIndex )
   * Elimino los cabezales vacíos...
   DO WHILE ( nHeaderIndex > 0 )
      IF ! EMPTY( aHeader[ nHeaderIndex ] )
   EXIT
   ENDIF
   nHeaderIndex--
   ENDDO

   aReport[ RP_HEADER ] := IIF( EMPTY( nHeaderIndex ) , {}, ASIZE( aHeader, nHeaderIndex ) )

   nPointer = BIN2W(SUBSTR(cParamsBuff, GRP_EXPR_OFFSET, 2))

   IF !EMPTY(cGroupExp := GetExpr( nPointer ))

      ** Agrego un grupo ...
      AADD( aReport[ RP_GROUPS ], ARRAY( RG_COUNT ))
      aReport[ RP_GROUPS ][1][ RG_TEXT ] := cGroupExp
      aReport[ RP_GROUPS ][1][ RG_EXP ] := &( "{ || " + cGroupExp + "}" )
      IF USED()
         aReport[ RP_GROUPS ][1][ RG_TYPE ] := VALTYPE( EVAL( aReport[ RP_GROUPS ][1][ RG_EXP ] ) )
      ENDIF
      * Cabezal del grupo
      nPointer = BIN2W(SUBSTR(cParamsBuff, GRP_HDR_OFFSET, 2))
      aReport[ RP_GROUPS ][1][ RG_HEADER ] := GetExpr( nPointer )
      * Salto de hoja al finalizar el grupo?
      aReport[ RP_GROUPS ][1][ RG_AEJECT ] := IF(SUBSTR(cParamsBuff, PE_OFFSET, 1) $ "YyTt", .T., .F.)

   ENDIF

   * Hay Subgrupos?
   nPointer = BIN2W(SUBSTR(cParamsBuff, SUB_EXPR_OFFSET, 2))

   IF !EMPTY(cSubGroupExp := GetExpr( nPointer ))

      * Agrego el subgrupo
      AADD( aReport[ RP_GROUPS ], ARRAY( RG_COUNT ))
      aReport[ RP_GROUPS ][2][ RG_TEXT ] := cSubGroupExp
      aReport[ RP_GROUPS ][2][ RG_EXP ] := &( "{ || " + cSubGroupExp + "}" )
      IF USED()
         aReport[ RP_GROUPS ][2][ RG_TYPE ] := VALTYPE( EVAL( aReport[ RP_GROUPS ][2][ RG_EXP ] ) )
      ENDIF

      * Cabezal del subgrupo
      nPointer = BIN2W(SUBSTR(cParamsBuff, SUB_HDR_OFFSET, 2))
      aReport[ RP_GROUPS ][2][ RG_HEADER ] := GetExpr( nPointer )
      * Salto de hoja al finalizar el subgrupo?
      aReport[ RP_GROUPS ][2][ RG_AEJECT ] := .F.

   ENDIF

   ********* Agrego columnas ************
   nFieldOffset := 12
   FOR nCount := 1 to nColCount
      AADD( aReport[ RP_COLUMNS ], GetColumn( cFieldsBuff, @nFieldOffset ) )
   NEXT nCount

ENDIF

RETURN aReport

**********************************************
STATIC FUNCTION ParseHeader( cHeaderString, nFields )
**********************************************
LOCAL cItem
LOCAL nItemCount := 0
LOCAL aPageHeader := {}
LOCAL nHeaderLen := 254
LOCAL nPos

DO WHILE ( ++nItemCount <= nFields )
 cItem := SUBSTR( cHeaderString, 1, nHeaderLen )
 * Busco delimitador....
 nPos := AT( ";", cItem )
 IF ! EMPTY( nPos )
  AADD( aPageHeader, SUBSTR( cItem, 1, nPos - 1 ) )
 ELSE
  IF EMPTY( cItem )
   AADD( aPageHeader, "" )
  ELSE
   AADD( aPageHeader, cItem )
  ENDIF
  nPos := nHeaderLen
 ENDIF
 cHeaderString := SUBSTR( cHeaderString, nPos + 1 )
ENDDO

RETURN( aPageHeader )

***********************************
STATIC FUNCTION GetExpr( nPointer )
***********************************
   LOCAL nExprOffset   := 0
   LOCAL nExprLength   := 0
   LOCAL nOffsetOffset := 0
   LOCAL cString := ""

   IF nPointer != 65535
      nPointer++

      IF nPointer > 1
         nOffsetOffset = (nPointer * 2) - 1
      ENDIF

      nExprOffset = BIN2W(SUBSTR(cOffsetsBuff, nOffsetOffset, 2))
      nExprLength = BIN2W(SUBSTR(cLengthsBuff, nOffsetOffset, 2))

      nExprOffset++
      nExprLength--

      cString = SUBSTR(cExprBuff, nExprOffset, nExprLength)

      IF CHR(0) == SUBSTR(cString, 1, 1) .AND. LEN(SUBSTR(cString,1,1)) = 1
         cString = ""
      ENDIF
   ENDIF

   RETURN (cString)


***************************************************
STATIC FUNCTION GetColumn( cFieldsBuffer, nOffset )
***************************************************
LOCAL nPointer := 0, nNumber := 0, aColumn[ RC_COUNT ], cType

** Ancho de la columna
aColumn[ RC_WIDTH ] := BIN2W(SUBSTR(cFieldsBuffer, nOffset + FIELD_WIDTH_OFFSET, 2))

** tiene totales?
aColumn[ RC_TOTAL ] := IF(SUBSTR(cFieldsBuffer, nOffset + FIELD_TOTALS_OFFSET, 1) $ "YyTt", .T., .F.)

** Cantidad de decimales
aColumn[ RC_DECIMALS ] := BIN2W(SUBSTR(cFieldsBuffer, nOffset + FIELD_DECIMALS_OFFSET, 2))

** Expresión con Contenido de la columna
nPointer = BIN2W(SUBSTR(cFieldsBuffer, nOffset + FIELD_CONTENT_EXPR_OFFSET, 2))
aColumn[ RC_TEXT ] := GetExpr( nPointer )
aColumn[ RC_EXP ] := &( "{ || " + GetExpr( nPointer ) + "}" )

** Cabezal de la columna
nPointer = BIN2W(SUBSTR(cFieldsBuffer, nOffset + FIELD_HEADER_EXPR_OFFSET, 2))

aColumn[ RC_HEADER ] := ListAsArray(GetExpr( nPointer ), ";")

** Picture de la columna
IF USED()
  cType := VALTYPE( EVAL(aColumn[ RC_EXP ]) )
  aColumn[ RC_TYPE ] := cType
  DO CASE
  CASE cType = "C" .OR. cType = "M"
     aColumn[ RC_PICT ] := REPLICATE("X", aColumn[ RC_WIDTH ])
  CASE cType = "D"
     aColumn[ RC_PICT ] := "@D"
  CASE cType = "N"
     IF aColumn[ RC_DECIMALS ] != 0
        aColumn[ RC_PICT ] := REPLICATE("9", aColumn[ RC_WIDTH ] - aColumn[ RC_DECIMALS ] -1) + "." + REPLICATE("9", aColumn[ RC_DECIMALS ])
     ELSE
        aColumn[ RC_PICT ] := REPLICATE("9", aColumn[ RC_WIDTH ])
     ENDIF
  CASE cType = "L"
     aColumn[ RC_PICT ] := "@L" + REPLICATE("X",aColumn[ RC_WIDTH ]-1)
  ENDCASE
ENDIF

nOffset += 12

RETURN ( aColumn )

*************************************************
STATIC FUNCTION ListAsArray( cList, cDelimiter )
*************************************************
* Convierto un string delimitado (por comas) a un array
LOCAL nPos
LOCAL aList := {}
LOCAL lDelimLast := .F.

IF cDelimiter == NIL
  cDelimiter := ","
ENDIF

DO WHILE ( LEN(cList) <> 0 )

  nPos := AT(cDelimiter, cList)

  IF ( nPos == 0 )
     nPos := LEN(cList)
  ENDIF

  IF ( SUBSTR( cList, nPos, 1 ) == cDelimiter )
     lDelimLast := .T.
     AADD(aList, SUBSTR(cList, 1, nPos - 1))
  ELSE
     lDelimLast := .F.
     AADD(aList, SUBSTR(cList, 1, nPos))
  ENDIF

  cList := SUBSTR(cList, nPos + 1)

ENDDO

IF ( lDelimLast )
  AADD(aList, "")
ENDIF

RETURN aList


