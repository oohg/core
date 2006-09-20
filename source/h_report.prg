/*
 * $Id: h_report.prg,v 1.29 2006-09-20 19:06:23 declan2005 Exp $
 */
/*
 * DO REPORT Command support procedures For MiniGUI Library.
 * (c) Ciro vargas Clemow [sistemascvc@softhome.net]

 This program is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later
 version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along with
 this software; see the file COPYING. If not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or
 visit the web site http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text
 contained in this file.

 The exception is that, if you link this code with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking
 this code into it.

*/

#include 'hbclass.ch'
#include 'common.ch'
#include 'oohg.ch'

MEMVAR NPOS
MEMVAR NPOS1
MEMVAR NPOS2
MEMVAR LIN
MEMVAR SW
MEMVAR SW1
MEMVAR CREPORT
MEMVAR cgraphicalt
MEMVAR WLARLIN
MEMVAR AFIELDS
MEMVAR LSELECT
MEMVAR LDOS
MEMVAR NGRPBY
MEMVAR LLANDSCAPE
MEMVAR AHEADERS1
MEMVAR AHEADERS2
MEMVAR CTITLE
MEMVAR CGRAPHIC
MEMVAR WFIELD
MEMVAR WFIELDA
MEMVAR WFIELDT
MEMVAR ATOTALS
MEMVAR AFORMATS
MEMVAR AWIDTHS
MEMVAR NPOSGRP
MEMVAR NLLMARGIN
MEMVAR CROMPE
MEMVAR CHDRGRP
MEMVAR WFILEREPO
MEMVAR CALIAS
MEMVAR NLPP
MEMVAR NCPL
MEMVAR LPREVIEW
MEMVAR CFILEREPO
MEMVAR LMUL
MEMVAR PAGE
MEMVAR EXT
MEMVAR NFI
MEMVAR NCI
MEMVAR NFF
MEMVAR NCF
MEMVAR Npapersize
MEMVAR Apapeles
MEMVAR ipaper
MEMVAR repobject
MEMVAR sicvar
MEMVAR ctitle1
MEMVAR ctitle2
MEMVAR cheader
MEMVAR CPRINTER
MEMVAR WORIENTATION
MEMVAR LSUCESS
MEMVAR CBAT
MEMVAR _OOHG_printlibrary
MEMVAR oprint
MEMVAR nposat
MEMVAR lgroupeject
MEMVAR lexcel

FUNCTION easyreport(ctitle,aheaders1,aheaders2,afields,awidths,atotals,nlpp,ldos,lpreview,cgraphic,nfi,nci,nff,ncf,lmul,cgrpby,chdrgrp,llandscape,ncpl,lselect,calias,nllmargin,aformats,npapersize,cheader,lnoprop,lgroupeject)
PRIVATE ctitle1,sicvar

if lgroupeject=NIL
   lgroupeject:=.F.
endif


if cheader=NIL
   cheader:=""
endif

if lnoprop=NIL
   lnoprop=.F.
endif

if nlpp=NIL
   nlpp:=58
endif
if ncpl=NIL
   ncpl:=80
endif

 _listreport(CTITLE,AHEADERS1,AHEADERS2,AFIELDS,AWIDTHS,ATOTALS,NLPP,LDOS,LPREVIEW,CGRAPHIC,NFI,NCI,NFF,NCF,LMUL,CGRPBY,CHDRGRP,LLANDSCAPE,NCPL,LSELECT,CALIAS,NLLMARGIN,AFORMATS,NPAPERSIZE,CHEADER,lnoprop,lgroupeject)

RETURN NIL

static FUNCTION _listreport(ctitle,aheaders1,aheaders2,afields,awidths,atotals,nlpp,ldos,lpreview,cgraphic,nfi,nci,nff,ncf,lmul,cgrpby,chdrgrp,llandscape,ncpl,lselect,calias,nllmargin,aformats,npapersize,cheader,lnoprop,lgroupeject)
private repobject,sicvar
repobject:=TREPORT()
sicvar:=setinteractiveclose()
SET INTERACTIVECLOSE ON
repobject:easyreport1(ctitle,aheaders1,aheaders2,afields,awidths,atotals,nlpp,ldos,lpreview,cgraphic,nfi,nci,nff,ncf,lmul,cgrpby,chdrgrp,llandscape,ncpl,lselect,calias,nllmargin,aformats,npapersize,cheader,lnoprop,lgroupeject)
setinteractiveclose(sicvar)
release repobject
return nil

FUNCTION extreport(cfilerep,cheader)
PRIVATE repobject
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

Private oprint

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

ENDCLASS


METHOD easyreport1(ctitle,aheaders1,aheaders2,afields,awidths,atotals,nlpp,ldos,lpreview,cgraphic,nfi,nci,nff,ncf,lmul,cgrpby,chdrgrp,llandscape,ncpl,lselect,calias,nllmargin,aformats,npapersize,cheader,lnoprop,lgroupeject) CLASS TREPORT
local nlin,i,aresul,lmode,swt:=0,grpby,k,ncvcopt,swmemo,clinea,ti,nmemo,nspace
private  wfield,wfielda,wfieldt,lexcel:=.F.


  if nllmargin = NIL
   repobject:nlmargin:=0
else
   repobject:nlmargin:=nllmargin
endif
if aformats==NIL
   aformats:=array(len(afields))
   for i:=1 to len(afields)
       aformats[i]:=NIL
   next i
endif
if atotals==NIL
   atotals:=array(len(afields))
   for i:=1 to len(afields)
       atotals[i]:=.F.
   next i
endif
repobject:npager:=0
grpby:=cgrpby
aresul:=array(len(afields))
repobject:angrpby:=array(len(afields))
for i:=1 to len(afields)
    afields[i]:=upper(afields[i])
next i
if grpby<>NIL
   grpby:=upper(grpby)
endif
select(calias)
lmode:=.T.
if nlpp= NIL
   nlpp=50
endif
setprc(0,0)
if ncpl = NIL
   ncpl:=80
   repobject:nfsize=12
endif

if ldos
   oprint:=tprint("DOSPRINT")      
   oprint:init()

   if ncpl<= 80
      oprint:normaldos()
   else
      oprint:condendos()
   endif

else
  if type("_OOHG_printlibrary")#"C"     
     oprint:=tprint("MINIPRINT")
     oprint:init()   
     _OOHG_printlibrary="MINIPRINT"
  endif  
  if _OOHG_printlibrary="HBPRINTER"
       oprint:=tprint("HBPRINTER")
       oprint:init()
  elseif _OOHG_printlibrary="MINIPRINT"
       oprint:=tprint("MINIPRINT")
       oprint:init()
  elseif _OOHG_printlibrary="EXCELPRINT"
       oprint:=tprint("EXCELPRINT")
       oprint:init()
       lexcel:=.T.
  elseif _OOHG_printlibrary="RTFPRINT"
       oprint:=tprint("RTFPRINT")
       oprint:init()
       lexcel:=.T.
  elseif _OOHG_printlibrary="CSVPRINT"
       oprint:=tprint("CSVPRINT")
       oprint:init()
       lexcel:=.T.

  elseif _OOHG_printlibrary="DOSPRINT"
       oprint:=tprint("DOSPRINT")
       oprint:init()
       if ncpl<=80
         oprint:normaldos()
       else
         oprint:condendos()
       endif
  else
       oprint:=tprint("MINIPRINT")
       oprint:init()
       _OOHG_printlibrary="MINIPRINT"
  endif
  
endif

do case
        case ncpl= 80
            ncvcopt:=1
            repobject:nfsize:=12
            if lnoprop
               oprint:nfontsize:=12
            endif
         case ncpl= 96
            ncvcopt:=2
            repobject:nfsize=10
            if lnoprop
               oprint:nfontsize:=10
            endif
         case ncpl= 120
            ncvcopt:=3
            repobject:nfsize:=8
            if lnoprop
               oprint:nfontsize:=8
            endif
         case ncpl= 140
            ncvcopt:=4
           repobject:nfsize:=7
           if lnoprop
              oprint:nfontsize:=7
           endif
         case ncpl= 160
            ncvcopt:=5
            repobject:nfsize:=6
            if lnoprop
                oprint:nfontsize:=6
            endif
         otherwise
            ncvcopt:=1
            repobject:nfsize:=12
            if lnoprop
                oprint:nfontsize:=12
            endif
endcase

*****************=======================================
oprint:selprinter(lselect,lpreview,llandscape,npapersize)
if oprint:lprerror
   oprint:release()
   RETURN NIL
endif
oprint:begindoc()
oprint:beginpage()
nlin:=1
if cgraphic<>NIL
   if .not. File(cgraphic)
      msgstop('graphic file not found','error')
   else
      oprint:printimage(nfi,nci+repobject:nlmargin,nff,ncf+repobject:nlmargin,cgraphic)
   endif
endif
ngrpby:=0
nlin:=repobject:headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp,cheader)
for i:=1 to len(afields)
    aresul[i]:=0
    repobject:angrpby[i]:=0
next i
if grpby<> NIL
   crompe:=&(grpby)
endif
do while .not. eof()
   do events
////   ncol:=repobject:nlmargin
   swt:=0
   if grpby<>NIL
      if .not.(&(grpby) = crompe)
            if ascan(atotals,.T.)>0
               oprint:printdata(nlin,repobject:nlmargin, '** Subtotal **',,repobject:nfsize,.T.)
               nlin++
            endif
**************
            clinea:=""
            for i:=1 to len(afields)
                 if atotals[i]
                  clinea:=clinea +iif(.not.(aformats[i]==NIL),space(awidths[i]-len(transform(repobject:angrpby[i],aformats[i])))+transform(repobject:angrpby[i],aformats[i]),str(repobject:angrpby[i],awidths[i]))+ space(awidths[i] -   len(  iif(.not.(aformats[i]==''),space(awidths[i]-len(transform(repobject:angrpby[i],aformats[i])))+transform(repobject:angrpby[i],aformats[i]),str(repobject:angrpby[i],awidths[i])))   )+" "
                 else
                  clinea:=clinea+ space(awidths[i])+" "
                endif
             next i
             oprint:printdata(nlin,0+repobject:nlmargin,clinea,,repobject:nfsize ,.T.)

**************
        for i:=1 to len(afields)
          repobject:angrpby[i]:=0
        next i
********
******** seria aqui si decido hacer el rompe por pagina
       *********** if EJECTGROUP  oprint:endpage()
      if lgroupeject
         nlin:=1
         oprint:endpage()
         oprint:beginpage()
         nlin:=repobject:headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp,cheader)
         nlin--
      endif

       *************
********
        crompe:=&(grpby)
        nlin++
        oprint:printdata(nlin,repobject:nlmargin,  '** ' + (chdrgrp)+' ** '+ (&(grpby)),,repobject:nfsize,.T.)
        nlin++
      endif
   endif
**********
   clinea:=""
   swmemo:=.F.
   for i:=1 to len(afields)
       wfielda:=afields[i]
       wfield:=&(wfielda)
       if type('&wfielda')=='M'
          swmemo=.T.
          wfieldt:=wfield
          ti:=i
       endif
            do case
               case type('&wfielda')=='C'
                 clinea:=clinea+substr(wfield,1,awidths[i])+space(awidths[i]-len(substr(wfield,1,awidths[i]) ))+" "
               case type('&wfielda')=='N'
                    clinea:=clinea + iif(.not.(aformats[i]==NIL),space(awidths[i]-len(transform(wfield,aformats[i])))+transform(wfield,aformats[i]),str(wfield,awidths[i]))+ space(awidths[i] -   len(  iif(.not.(aformats[i]==''),space(awidths[i]-len(transform(wfield,aformats[i])))+transform(wfield,aformats[i]),str(wfield,awidths[i])))   )+" "
               case type('&wfielda')=='D'
                    clinea:=clinea+ substr(dtoc(wfield),1,awidths[i])+space(awidths[i]-len(substr(dtoc(wfield),1,awidths[i])) )+" "
               case type('&wfielda')=='L'
                    clinea:=clinea+iif(wfield,"T","F")+space(awidths[i]-1)+" "
              case type('&wfielda')=='M' .or. type('&wfielda')=='C' //// ojo no quitar la a
                  nmemo:=mlcount(rtrim(wfield),awidths[i])
                  if nmemo>0
                     clinea:=clinea + rtrim(justificalinea(memoline(rtrim(wfield),awidths[i] ,1),awidths[i]))+space(awidths[i]-len(rtrim(justificalinea(memoline(rtrim(wfield),awidths[i] ,1),awidths[i])) ) )+" "
                  else
                     clinea:=clinea + space(awidths[i])+" "
                  endif
               otherwise
               clinea:=clinea+replicate('_',awidths[i])+" "
            endcase
       if atotals[i]
          aresul[i]:=aresul[i]+wfield
          swt:=1
          if grpby<>NIL
             repobject:angrpby[i]:=repobject:angrpby[i]+wfield
          endif
       endif
next i
oprint:printdata(nlin,repobject:nlmargin,clinea,,repobject:nfsize)
nlin++
if nlin>nlpp
   nlin:=1
   if .not. ldos
      oprint:endpage()
      oprint:beginpage()
      if cgraphic<>NIL .and. lmul
         if .not. File(cgraphic)
         msgstop('graphic file not found','error')
      else
         oprint:printimage(nfi,nci+repobject:nlmargin,nff,repobject:nfc,cgraphic )
      endif
   endif
endif
nlin:=repobject:headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp,cheader)
endif
**************resto de memo
if swmemo
   if nmemo > 1
   clinea:=""
   nspace:=0
   for k:=1 to ti-1
       nspace:=nspace+awidths[k]+1
   next k
   for k:=2 to nmemo
       clinea:=space(nspace)+justificalinea(memoline(rtrim(wfieldt),awidths[ti] ,k),awidths[ti] )
       oprint:printdata(nlin,0+repobject:nlmargin,clinea , , repobject:nfsize ,  )
       nlin++
       if nlin>nlpp
          nlin:=1
          oprint:endpage()
          oprint:beginpage()
	  if cgraphic<>NIL .and. lmul
             if .not. File(cgraphic)
	         msgstop('graphic file not found','error')
             else
                 oprint:printimage(nfi,nci+repobject:nlmargin,nff,repobject:nfc,cgraphic )
             endif
	 endif
	 nlin:=repobject:headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp,cheader)
       endif
    next k
////    nlin--
   endif
endif
**************
skip
enddo

if swt==1
   if grpby<>NIL
      if .not.(&(grpby) == crompe)
         if ascan(atotals,.T.)>0
            oprint:printdata(nlin,repobject:nlmargin,  '** Subtotal **',,repobject:nfsize,.T.)
**** ojo
            nlin++
         endif
         clinea:=""
         for i:=1 to len(afields)
                if atotals[i]
                   clinea:=clinea +iif(.not.(aformats[i]==NIL),space(awidths[i]-len(transform(repobject:angrpby[i],aformats[i])))+transform(repobject:angrpby[i],aformats[i]),str(repobject:angrpby[i],awidths[i]))+ space(awidths[i] -   len(  iif(.not.(aformats[i]==''),space(awidths[i]-len(transform(repobject:angrpby[i],aformats[i])))+transform(repobject:angrpby[i],aformats[i]),str(repobject:angrpby[i],awidths[i])))   )+" "
                else
                   clinea:=clinea+ space(awidths[i])+" "
                endif
         next i
        oprint:printdata(nlin,repobject:nlmargin, clinea , ,repobject:nfsize ,.T. )
        for i:=1 to len(afields)
          repobject:angrpby[i]:=0
        next i
        crompe:=&(grpby)
      endif
   endif
************** rompe por pagina si tiene el parametro
      if lgroupeject
         nlin:=1
         oprint:endpage()
         oprint:beginpage()
         nlin:=repobject:headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp,cheader)
         nlin--
      endif

**************
   nlin++
   if nlin>nlpp
      nlin:=1
      oprint:endpage()
      oprint:beginpage()
      nlin:=repobject:headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp,cheader)
   endif
   if ascan(atotals,.T.)>0
      oprint:printdata(nlin, 0+repobject:nlmargin,'*** Total ***',,repobject:nfsize,.T.)
   endif
   nlin++
   clinea:=""
   for i:=1 to len(afields)
       if atotals[i]
           clinea:=clinea +iif(.not.(aformats[i]==NIL),space(awidths[i]-len(transform(aresul[i],aformats[i])))+transform(aresul[i],aformats[i]),str(aresul[i],awidths[i]))+ space(awidths[i] -   len(  iif(.not.(aformats[i]==''),space(awidths[i]-len(transform(aresul[i],aformats[i])))+transform(aresul[i],aformats[i]),str(aresul[i],awidths[i])))   )+" "
        else
         clinea:=clinea+ space(awidths[i])+" "
       endif
   next i
    oprint:printdata(nlin,0+repobject:nlmargin,clinea, ,repobject:nfsize ,.T.)
   nlin++
   oprint:printdata(nlin,repobject:nlmargin," ")
endif
  oprint:endpage()
  oprint:enddoc()
  oprint:release()
return Nil

METHOD headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp,cheader) CLASS TREPORT
local i,nsum,ncenter,ncenter2,npostitle,ctitle1,ctitle2,clinea,clinea1,clinea2
empty(lmode)
nsum:=0
for i:=1 to len(awidths)
    nsum:=nsum+awidths[i]
next i
npostitle:=at('|',ctitle)
ctitle1:=ctitle2:=''
if npostitle>0
   ctitle1:=left(ctitle,npostitle-1)
   ctitle2:=trim(substr(ctitle,npostitle+1,len(ctitle)))
else
   ctitle1:=ctitle
endif
ctitle1:=trim(ctitle1)+cheader
ncenter:=((nsum-len(ctitle1))/2)-1
if len(ctitle2)>0
   ncenter2:=((nsum-len(ctitle2))/2)-1
endif
repobject:npager++
if .not. lexcel
   clinea:=trim(_oohg_MESSAGES(1,8) )+ space(6-len(trim(_OOHG_MESSAGES(1,8) ))) + str(repobject:npager,4)
   clinea1:=space(ncenter)+ctitle1
   clinea2:=space(nsum+len(awidths)-11)+dtoc(date())
   oprint:printdata(nlin,repobject:nlmargin , clinea,,repobject:nfsize )
   oprint:printdata(nlin,repobject:nlmargin , clinea1,,repobject:nfsize+1,.T. )
   oprint:printdata(nlin,repobject:nlmargin , clinea2,,repobject:nfsize )
else
   clinea:=trim(_oohg_MESSAGES(1,8) )+ space(6-len(trim(_OOHG_MESSAGES(1,8) ))) + str(repobject:npager,4)+"       "+ctitle1+"       "+dtoc(date())
   oprint:printdata(nlin,repobject:nlmargin , clinea,,repobject:nfsize )
endif


if .not. lexcel

   if len(ctitle2)>0
      nlin++
      clinea1:=space(ncenter2)+ctitle2
      clinea2:=space(nsum+len(awidths)-11)+time()
      oprint:printdata(nlin,repobject:nlmargin, clinea1,,repobject:nfsize+1,.T. )
      oprint:printdata(nlin,repobject:nlmargin, clinea2,,repobject:nfsize )
   else
      nlin++
      clinea2:=space(nsum+len(awidths)-11)+time()
      oprint:printdata(nlin,repobject:nlmargin , clinea2,,repobject:nfsize )
   endif
else
   if len(ctitle2)>0
      nlin++
      clinea1:=space(ncenter2)+ctitle2+"       "+time()
      oprint:printdata(nlin,repobject:nlmargin , clinea1,,repobject:nfsize )
   else
      nlin++
      clinea1:=space(nsum+len(awidths)-11)+time()
      oprint:printdata(nlin,repobject:nlmargin , clinea1,,repobject:nfsize )
   endif
endif

nlin++
nlin++
clinea:=""
for i:=1 to  len(awidths)
    clinea:=clinea+ replicate('-',awidths[i])+" "
next i
oprint:printdata(nlin,repobject:nlmargin, clinea,,repobject:nfsize  )
nlin++

clinea:=""
for i:=1 to len(awidths)
  clinea:= clinea + substr(aheaders1[i],1,awidths[i] ) + space( awidths[i]-len(aheaders1[i] )) +" "
next i
oprint:printdata(nlin,repobject:nlmargin, clinea,,repobject:nfsize ,.T.)
nlin++

clinea:=""
for i:=1 to len(awidths)
    clinea:= clinea + substr(aheaders2[i],1,awidths[i] ) + space( awidths[i]-len(aheaders2[i] )) +" "
next i
   oprint:printdata(nlin,repobject:nlmargin, clinea,,repobject:nfsize ,.T.)
nlin++

clinea:=""
for i:=1 to  len(awidths)
    clinea:=clinea + replicate('-',awidths[i])+" "
next i
oprint:printdata(nlin,repobject:nlmargin, clinea,,repobject:nfsize   )
nlin:=nlin+2

///if grpby<>NIL
if repobject:npager=1 .and. grpby#NIL
   oprint:printdata(nlin,repobject:nlmargin, '** ' +chdrgrp+' ** '+  &(grpby) , ,repobject:nfsize ,.T.   )
   nlin++
endif
return nlin

METHOD extreport1(cfilerep,cheader) CLASS TREPORT
local nContlin,i,ctitle,aheaders1,aheaders2,afields,awidths,atotals,aformats
local nlpp,ncpl,nllmargin,calias,ldos,lpreview,lselect,cgraphic,lmul,nfi,nci
local nff,ncf,cgrpby,chdrgrp,llandscape,lnoprop
       if .not. file(cfilerep+'.rpt')
          msginfo('('+cfilerep+'.rpt)  File not found','Information')
          return Nil
       endif

       creport:=memoread(cfilerep+'.rpt')
       nContlin:=mlcount(Creport)
       For i:=1 to nContlin
          aAdd (repobject:Aline,memoline(Creport,500,i))
       next i
       ctitle:=repobject:leadato('REPORT','TITLE','')
       if len(ctitle)>0
          ctitle:=&ctitle
       endif
       aheaders1:=repobject:leadatoh('REPORT','HEADERS','{}',1)
       aheaders1:=&aheaders1
       aheaders2:=repobject:leadatoh('REPORT','HEADERS','{}',2)
       aheaders2:=&aheaders2
       afields:=repobject:leadato('REPORT','FIELDS','{}')
       if len(afields)=0
          msginfo('Fields not defined','Information')
          return Nil
       endif
       afields:=&afields
       awidths:=repobject:leadato('REPORT','WIDTHS','{}')
       if len(awidths)=0
          msginfo('Widths not defined','Information')
          return Nil
       endif
       awidths:=&awidths
       atotals:=repobject:leadato('REPORT','TOTALS',NIL)
       if atotals<>NIL
          atotals:=&atotals
       endif
       aformats:=repobject:leadato('REPORT','NFORMATS',NIL)
       if aformats<>NIL
          aformats:=&aformats
       endif
       nlpp:=val(repobject:leadato('REPORT','LPP',''))
       ncpl:=val(repobject:leadato('REPORT','CPL',''))
       nllmargin:=val(repobject:leadato('REPORT','LMARGIN','0'))
       npapersize:=repobject:leadato('REPORT','PAPERSIZE','DMPAPER_LETTER')
       if npapersize='DMPAPER_USER'
          npapersize=255
       endif
       if len(npapersize)=0
          npapersize:=NIL
       else
          ipaper := ascan ( apapeles , npapersize )
          if ipaper=0
             ipaper=1
          endif
          npapersize:=ipaper
       endif
       calias:=repobject:leadato('REPORT','WORKAREA','')
       ldos:=repobject:leadatologic('REPORT','DOSMODE',.F.)
       lpreview:=repobject:leadatologic('REPORT','PREVIEW',.F.)
       lselect:=repobject:leadatologic('REPORT','SELECT',.F.)
       lmul:=repobject:leadatologic('REPORT','MULTIPLE',.F.)
       lnoprop:=repobject:leadatologic('REPORT','NOFIXED',.F.)

       cgraphic:=repobject:clean(repobject:leaimage('REPORT','IMAGE',''))
       if len(cgraphic)==0
          cgraphic:=NIL
       endif
       nfi:=val((repobject:learowi('IMAGE',1)))
       nci:=val((repobject:leacoli('IMAGE',1)))
       nff:=val((repobject:learowi('IMAGE',2)))
       ncf:=val((repobject:leacoli('IMAGE',2)))
       cgraphicalt:=(repobject:leadato('DEFINE REPORT','IMAGE',''))
       if len(cgraphicalt)>0  &&& para sintaxis DEFINE REPORT
          cgraphicalt:=&cgraphicalt
          cgraphic:=cgraphicalt[1]
          nfi:=cgraphicalt[2]
          nci:=cgraphicalt[3]
          nff:=cgraphicalt[4]
          ncf:=cgraphicalt[5]
       endif
       cgrpby:=repobject:leadato('REPORT','GROUPED BY','')
       if len(cgrpby)=0
          cgrpby=NIL
       endif
       chdrgrp:=repobject:clean(repobject:leadato('REPORT','HEADRGRP',''))
       llandscape:=repobject:leadatologic('REPORT','LANDSCAPE',.F.)
       lgroupeject:=repobject:leadatologic('REPORT','GROUPEJECT',.F.)

       easyreport(ctitle,aheaders1,aheaders2,afields,awidths,atotals,nlpp,ldos,lpreview,cgraphic,nfi,nci,nff,ncf,lmul,cgrpby,chdrgrp,llandscape,ncpl,lselect,calias,nllmargin,aformats,npapersize,cheader,lnoprop,lgroupeject)
return Nil

METHOD leadato(cName,cPropmet,cDefault) CLASS TREPORT
local i,sw,cfvalue
sw:=0
For i:=1 to len(repobject:aline)
if .not. at(upper(cname)+' ',upper(repobject:aline[i]))==0
   sw:=1
else
   if sw==1
      npos:=at(upper(cPropmet)+' ',upper(repobject:aline[i]))
      if len(trim(repobject:aline[i]))==0
         i=len(repobject:aline)+1
         return cDefault
      endif
      if npos>0
         cfvalue:=substr(repobject:aline[i],npos+len(Cpropmet),len(repobject:aline[i]))
         i:=len(repobject:aline)+1
         cfvalue:=trim(cfvalue)
         if right(cfvalue,1)=';'
            cfvalue:=substr(cfvalue,1,len(cfvalue)-1)
         else
            cfvalue:=substr(cfvalue,1,len(cfvalue))
         endif
         return alltrim(cfvalue)
      endif
   endif
endif
Next i
return cDefault

METHOD leaimage(cName,cPropmet,cDefault) CLASS TREPORT
local i,sw1,npos1,npos2
sw1:=0
lin:=0
cname:=''
cpropmet:=''
For i:=1 to len(repobject:aline)
    if at(upper('IMAGE'),repobject:aline[i])>0
       npos1:=at(upper('IMAGE'),upper(repobject:aline[i]))+6
       npos2:=at(upper('AT'),upper(repobject:aline[i]))-1
       lin:=i
       i:=len(repobject:aline)+1
       sw1:=1
    endif
next i
if sw1=1
   return substr(repobject:aline[lin],npos1,npos2-npos1+1)
endif
return cDefault

METHOD leadatoh(cName,cPropmet,cDefault,npar) CLASS TREPORT
local i,npos1,npos2,sw1
sw1:=0
lin:=0
cName:=''
cPropmet:=''
For i:=1 to len(repobject:aline)
        if at(upper('HEADERS'),repobject:aline[i])>0
            if npar=1
               npos1:=at(upper('{'),upper(repobject:aline[i]))
               npos2:=at(upper('}'),upper(repobject:aline[i]))
            else
               npos1:=rat(upper('{'),upper(repobject:aline[i]))
               npos2:=rat(upper('}'),upper(repobject:aline[i]))
            endif
            lin:=i
            i:=len(repobject:aline)+1
            sw1:=1
        endif
next i
if sw1=1
   return substr(repobject:aline[lin],npos1,npos2-npos1+1)
endif
return cDefault

METHOD leadatologic(cName,cPropmet,cDefault) CLASS TREPORT
local i,sw
sw:=0
For i:=1 to len(repobject:aline)
if at(upper(cname)+' ',upper(repobject:aline[i]))#0
   sw:=1
else
   if sw==1
      if at(upper(cPropmet)+' ',upper(repobject:aline[i]))>0
         return .T.
      endif
      if len(trim(repobject:aline[i]))==0
         i=len(repobject:aline)+1
         return cDefault
      endif
   endif
endif
Next i
return cDefault

METHOD clean(cfvalue) CLASS TREPORT
cfvalue:=strtran(cfvalue,'"','')
cfvalue:=strtran(cfvalue,"'","")
return cfvalue

METHOD learowi(cname,npar) CLASS TREPORT
local i,npos1,nrow
sw:=0
nrow:='0'
cname:=''
For i:=1 to len(repobject:aline)
    if at(upper('IMAGE')+' ',upper(repobject:aline[i]))#0
       if npar=1
          npos1:=at("AT",upper(repobject:aline[i]))
       else
          npos1:=at("TO",upper(repobject:aline[i]))
       endif
       nrow:=substr(repobject:aline[i],npos1+3,4)
       i:=len(repobject:aline)
    endif
Next i
return nrow

METHOD leacoli(cname,npar) CLASS TREPORT
local i,npos,ncol
ncol:='0'
cname:=''
For i:=1 to len(repobject:aline)
if at(upper('IMAGE')+' ',upper(repobject:aline[i]))#0
   if npar=1
      npos:=at(",",repobject:aline[i])
   else
      npos:=rat(",",repobject:aline[i])
   endif
   ncol:=substr(repobject:aline[i],npos+1,4)
   i:=len(repobject:aline)
endif
Next i
return ncol
