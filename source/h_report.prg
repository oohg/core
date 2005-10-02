/*
 * $Id: h_report.prg,v 1.3 2005-10-02 03:35:48 declan2005 Exp $
 */
/*
 * ooHG source code:
 * Initialization procedure
 *
 * Copyright 2005 Ciro Vargas Clemow <sistemascvc@softhome.net>
 * www - http://sistemascvc.tripod.com
 *
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the ooHG Project gives permission for
 * additional uses of the text contained in its release of ooHG.
 *
 * The exception is that, if you link the ooHG libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the ooHG library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the ooHG
 * Project under the name ooHG. If you copy code from other
 * ooHG Project or Free Software Foundation releases into a copy of
 * ooHG, as the General Public License permits, the exception does
 * not apply to the code that you add in this way. To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for ooHG, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */

#include 'hbclass.ch'
#include 'common.ch'
#include 'oohg.ch'
#include 'winprint.ch'

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
MEMVAR WFIELD1
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
MEMVAR auxobject
MEMVAR sicvar
MEMVAR ctitle1
MEMVAR cheader

FUNCTION easyreport(ctitle,aheaders1,aheaders2,afields,awidths,atotals,nlpp,ldos,lpreview,cgraphic,nfi,nci,nff,ncf,lmul,cgrpby,chdrgrp,llandscape,ncpl,lselect,calias,nllmargin,aformats,npapersize,cheader) 
PRIVATE ctitle1,auxobject,sicvar
auxobject:=_OOHG_REPORT()
auxobject:swt:=.F.
ctitle1:=lower(substr(ctitle,at('|',ctitle)+1))+'...'
if cheader=NIL
  cheader:=''
endif

DEFINE WINDOW _winreport ;
        AT 0,0 ;
        WIDTH 400 HEIGHT 120 ;
        TITLE ctitle1 MODAL NOSIZE NOSYSMENU NOCAPTION ;



        @ 15,195 IMAGE IMAGE_101 OF _winreport ;
        picture 'hbprint_print'  ;
        WIDTH 25  ;
        HEIGHT 30 ;
        STRETCH

        @ 22,225 LABEL LABEL_101 VALUE '......' FONT "Courier new" SIZE 10

        @ 55,10  label label_1 value ctitle1 WIDTH 400 HEIGHT 32 FONT "Courier new" SIZE 10

        DEFINE TIMER TIMER_101 OF _winreport ;
        INTERVAL 1000  ;
        ACTION action_timer()
     
        end window
        center window _winreport
        ACTIVATE WINDOW _winreport NOWAIT
        _listreport(ctitle,aheaders1,aheaders2,afields,awidths,atotals,nlpp,ldos,lpreview,cgraphic,nfi,nci,nff,ncf,lmul,cgrpby,chdrgrp,llandscape,ncpl,lselect,calias,nllmargin,aformats,npapersize,cheader) 
RETURN NIL

function action_timer()
if iswindowdefined(_winreport)
   _winreport.label_1.fontbold:=IIF(_winreport.label_1.fontbold,.F.,.T.)
   _winreport.image_101.visible:=IIF(_winreport.label_1.fontbold,.T.,.F.)
   auxobject:swt:=.T.
endif
return nil

FUNCTION _listreport(ctitle,aheaders1,aheaders2,afields,awidths,atotals,nlpp,ldos,lpreview,cgraphic,nfi,nci,nff,ncf,lmul,cgrpby,chdrgrp,llandscape,ncpl,lselect,calias,nllmargin,aformats,npapersize,cheader) 
private repobject,sicvar
repobject:=_OOHG_REPORT()
sicvar := SetInterActiveClose()
SET INTERACTIVECLOSE ON
repobject:easyreport1(ctitle,aheaders1,aheaders2,afields,awidths,atotals,nlpp,ldos,lpreview,cgraphic,nfi,nci,nff,ncf,lmul,cgrpby,chdrgrp,llandscape,ncpl,lselect,calias,nllmargin,aformats,npapersize,cheader) 
SetInterActiveClose( sicvar )
if iswindowdefined(_winreport)
   _winreport.timer_101.enabled:=.F.
   RELEASE WINDOW _winreport
endif
return nil

FUNCTION extreport(cfilerep,cheader)
PRIVATE repobject
repobject:=_OOHG_REPORT()
repobject:extreport1(cfilerep,cheader)
RETURN NIL

CREATE CLASS _OOHG_REPORT

VAR npager    INIT 0
VAR angrpby   INIT {}
VAR nlmargin  INIT 0
VAR nfsize    INIT 0
VAR swt       INIT .F.

VAR aline     INIT {}

METHOD easyreport1(ctitle,aheaders1,aheaders2,afields,awidths,atotals,nlpp,ldos,lpreview,cgraphic,nfi,nci,nff,ncf,lmul,cgrpby,chdrgrp,llandscape,ncpl,lselect,calias,nllmargin,aformats,npapersize,cheader) 
METHOD headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp,cheader)
METHOD mypreview(cfilerepo,ncpl) 
METHOD JUSTIFICALINEA(WPR_LINE,WTOPE) 
METHOD extreport1(cfilerep) 
METHOD leadato(cName,cPropmet,cDefault) 
METHOD leaimage(cName,cPropmet,cDefault) 
METHOD leadatoh(cName,cPropmet,cDefault,npar) 
METHOD leadatologic(cName,cPropmet,cDefault) 
METHOD clean(cfvalue) 
METHOD learowi(cname,npar)
METHOD leacoli(cname,npar) 

ENDCLASS


METHOD easyreport1(ctitle,aheaders1,aheaders2,afields,awidths,atotals,nlpp,ldos,lpreview,cgraphic,nfi,nci,nff,ncf,lmul,cgrpby,chdrgrp,llandscape,ncpl,lselect,calias,nllmargin,aformats,npapersize,cheader) CLASS _OOHG_REPORT
local nlin,i,ncol,aresul,lmode,swt:=0,nran,grpby,k,aprinters,aports,ncvcopt
private  wfield

INIT PRINTSYS
GET PRINTERS TO aprinters
GET PORTS TO aports
RELEASE PRINTSYS


if nllmargin = NIL
   repobject:nlmargin:=0
else
   repobject:nlmargin:=nllmargin
endif
if aformats==NIL
   aformats:=array(len(afields))
   for i:=1 to len(afields)
       aformats[i]:=''
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
if ldos
   lmode:=.F.
   ********** tipo de letra

   if ncpl= NIL
      ncpl=80      
      @ prow(),pcol() say chr(18) 
   else
      if ncpl=132
         @ prow(),pcol() say chr(15)
      else
          do case
         case ncpl= 80
            ncvcopt:=1
         case ncpl= 96
            ncvcopt:=2
         case ncpl= 120
            ncvcopt:=3
         case ncpl= 140
            ncvcopt:=4
         case ncpl= 160 
            ncvcopt:=5
         otherwise
            ncvcopt:=1
      endcase 
*******         @ prow(),pcol() say chr(18) 
      endif

   endif

   *********
   if lpreview
      nran:=random(9999999)
      cfilerepo:='T'+alltrim(str(nran))+'.prn'
      do while file('&cfilerepo')
         nran:=random(9999999)
         cfilerepo:='T'+alltrim(str(nran))+'.prn'
      enddo
      set printer to &cfilerepo
      set device to print
   else
      set device to print
   endif
/////   setprc(0,0)
else
   if ncpl = NIL
      ncpl:=80
      repobject:nfsize=12
   else
      do case
         case ncpl= 80
            ncvcopt:=1
            repobject:nfsize:=12
         case ncpl= 96
            ncvcopt:=2
            repobject:nfsize=10
         case ncpl= 120
            ncvcopt:=3
            repobject:nfsize:=8
         case ncpl= 140
            ncvcopt:=4
           repobject:nfsize:=7
         case ncpl= 160 
            ncvcopt:=5
           repobject:nfsize:=6
         otherwise
            ncvcopt:=1
           repobject:nfsize:=12
      endcase
   endif
*****************=========================================
   if lselect .and. lpreview       
      SELECT BY DIALOG PREVIEW
   endif
   if lselect .and. (.not. lpreview)
      SELECT BY DIALOG
   endif
   if (.not. lselect) .and. lpreview
      SELECT DEFAULT PREVIEW
   endif
   if (.not. lselect) .and. (.not. lpreview)
      SELECT DEFAULT
   endif
   IF HBPRNERROR != 0
     return nil
   ENDIF
   define font "f0" name "courier new" size repobject:nfsize
   define font "f1" name "courier new" size repobject:nfsize BOLD
   if llandscape
      set page orientation DMORIENT_LANDSCAPE font "f0"
   else
      set page orientation DMORIENT_PORTRAIT  font "f0"
   endif   
   if npapersize#NIL
      set page papersize npapersize
   endif
*****************=======================================
  select font 'f0'
  START DOC
  START PAGE
endif

nlin:=1
if cgraphic<>NIL  .and. !ldos
   if .not. File(cgraphic)
      msgstop('graphic file not found','error')
   else
     @nfi,nci+repobject:nlmargin  PICTURE cgraphic  size nff-nfi-4, ncf-nci-3 
   endif
endif
ngrpby:=0
nlin:=repobject:headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp,cheader)
for i:=1 to len(afields)
    aresul[i]:=0
    repobject:angrpby[i]:=0
next i
if grpby<> NIL
   crompe:=&grpby
endif
do while .not. eof()
   do events
   ncol:=1+repobject:nlmargin
   swt:=0
   if grpby<>NIL
      if .not.(&grpby == crompe)
         if lmode
            if ascan(atotals,.T.)>0            
               @ nlin,1+repobject:nlmargin say '** Subtotal **' font "f1" TO PRINT
               nlin++
            endif
**************
            for i:=1 to len(afields)
                if atotals[i]
                   @ nlin,ncol say iif(.not.(aformats[i]==''),transform(repobject:angrpby[i],aformats[i]),str(repobject:angrpby[i],awidths[i])) font "f1"TO PRINT
                endif
                ncol:=ncol+awidths[i]+1
            next i
**************
         else
            if ascan(atotals,.T.)>0            
               @ nlin,1+repobject:nlmargin say '** Subtotal **' 
               nlin++
            endif
**************
            for i:=1 to len(afields)
                if atotals[i]
                      @ nlin,ncol say iif(.not.(aformats[i]==''),transform(repobject:angrpby[i],aformats[i]),str(repobject:angrpby[i],awidths[i])) 
                endif
                ncol:=ncol+awidths[i]+1
            next i
**************              
         endif 
        for i:=1 to len(afields)         
          repobject:angrpby[i]:=0
        next i
        crompe:=&grpby
        nlin++
        if lmode
           @ nlin,1+repobject:nlmargin say '** ' +hb_oemtoansi(chdrgrp)+' ** '+hb_oemtoansi(&grpby) font "f1" TO PRINT
       else
           @ nlin,1+repobject:nlmargin say '** ' +chdrgrp+' ** '+&grpby 
       endif    
        nlin++
      endif
   endif
**********
   ncol:=1+repobject:nlmargin
   for i:=1 to len(afields)
       wfield:=afields[i]
       if type('&wfield')=='UI' 
          wfield:=&wfield
       endif
       if lmode           
            do case
               case type('&wfield')=='C' 
                 @ nlin,ncol say substr(hb_oemtoansi(&wfield),1,awidths[i]) font "f0" TO PRINT
               case type('&wfield')=='N'
                @ nlin,ncol say  iif(.not.(aformats[i]==''),transform(&wfield,aformats[i]),str(&wfield,awidths[i])) font "f0" TO PRINT
               case type('&wfield')=='D'
                 @ nlin,ncol say substr(dtoc(&wfield),1,awidths[i]) font "f0" TO PRINT
               case type('&wfield')=='L'
                 @ nlin,ncol say iif(&wfield,'T','F') font "f0" TO PRINT               
               case type('&wfield')=='M'  
                 for k:=1 to mlcount(&wfield,awidths[i])
                     @ nlin,ncol say repobject:justificalinea(memoline(&wfield,awidths[i] ,k),awidths[i]) font "f0" TO PRINT
                     nlin++
   			if nlin>nlpp
			   nlin:=1
 			   	if .not. ldos
                                      END PAGE
                                      START PAGE
				      if cgraphic<>NIL .and. lmul .and. !ldos
				         if .not. File(cgraphic)
					         msgstop('graphic file not found','error')
					 else
                                                 @nfi,nci+repobject:nlmargin  PICTURE cgraphic  size nff-nfi-4, ncf-nci-3
					 endif
	 			   endif
				endif
			nlin:=repobject:headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp,cheader)
			endif 
                 next k         
               otherwise
                 @ nlin,ncol say replicate('_',awidths[i]) font "f0" TO PRINT
            endcase
       else
            do case
               case type('&wfield')=='C'
                  @ nlin,ncol say substr(&wfield,1,awidths[i]) 
               case type('&wfield')=='N'
                  @ nlin,ncol say iif(.not.(aformats[i]==''),transform(&wfield,aformats[i]),str(&wfield,awidths[i]))
               case type('&wfield')=='D'
                 @ nlin,ncol say substr(dtoc(&wfield),1,awidths[i])
               case type('&wfield')=='L'
                 @ nlin,ncol say iif(&wfield,'.T.','.F.') 
               case type('&wfield')=='M'  
                 for k:=1 to mlcount(&wfield,awidths[i])
                     @ nlin,ncol say repobject:justificalinea(memoline(&wfield,awidths[i] ,k),awidths[i])
                     nlin++
   			if nlin>nlpp
			   nlin:=1			   	
***                           setprc(0,0)
  			nlin:=repobject:headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp,cheader)
		     endif 
                 next k
                 *if i<len(afields)
                 *   nlin:=nlin-k-1
                 *endif
               otherwise
                 @ nlin,ncol say replicate('_',awidths[i])
            endcase
       endif

       ncol:=ncol+awidths[i]+1
       if atotals[i]
          
          aresul[i]:=aresul[i]+&wfield
          swt:=1
          if grpby<>NIL
             repobject:angrpby[i]:=repobject:angrpby[i]+&wfield
          endif
       endif
next i

nlin++
if nlin>nlpp
   nlin:=1
   if .not. ldos
           END PAGE
           START PAGE
      if cgraphic<>NIL .and. lmul .and. !ldos
         if .not. File(cgraphic)
         msgstop('graphic file not found','error')
      else
         @nfi,nci+repobject:nlmargin  PICTURE cgraphic  size nff-nfi-4, ncf-nci-3
      endif
   endif
endif
nlin:=repobject:headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp,cheader)
endif 
skip
enddo

if swt==1
   ncol:=1+repobject:nlmargin
   if grpby<>NIL
      if .not.(&grpby == crompe)
         if lmode
            if ascan(atotals,.T.)>0            
               @ nlin,1+repobject:nlmargin say '** Subtotal **' font "f1" TO PRINT
               nlin++
            endif
            for i:=1 to len(afields)
                if atotals[i]
                      @ nlin,ncol say iif(.not.(aformats[i]==''),transform(repobject:angrpby[i],aformats[i]),str(repobject:angrpby[i],awidths[i])) font "f1" TO PRINT
                endif
                ncol:=ncol+awidths[i]+1
            next i
         else
            if ascan(atotals,.T.)>0            
               @ nlin,1+repobject:nlmargin say '** Subtotal **'
               nlin++
            endif
            for i:=1 to len(afields)
                if atotals[i]
                   @ nlin,ncol say iif(.not.(aformats[i]==''),transform(repobject:angrpby[i],aformats[i]),str(repobject:angrpby[i],awidths[i]))
                endif
                ncol:=ncol+awidths[i]+1
            next i
        endif          
        for i:=1 to len(afields)         
          repobject:angrpby[i]:=0
        next i
        crompe:=&grpby
      endif
   endif
**************
   nlin++
   ncol:=1+repobject:nlmargin
   if nlin>nlpp
      nlin:=1     
      if .not. ldos
         END PAGE
         START PAGE
      endif
      nlin:=repobject:headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp,cheader)
   endif 
   if lmode
      if ascan(atotals,.T.)>0            
         @nlin,ncol say '*** Total ***' font "f1" TO PRINT
      endif
   else
      if ascan(atotals,.T.)>0            
         @nlin,ncol say '*** Total ***'
      endif
   endif
   nlin++
   ncol:=1+repobject:nlmargin
   for i:=1 to len(afields) 
       if atotals[i]
          if lmode
             @nlin,ncol say iif(.not.(aformats[i]==''),transform(aresul[i],aformats[i]),str(aresul[i],awidths[i])) font "f1" TO PRINT
          else
             @nlin,ncol say iif(.not.(aformats[i]==''),transform(aresul[i],aformats[i]),str(aresul[i],awidths[i]))
          endif
       endif
       ncol:= ncol + awidths[i] + 1
   next i
   ncol:=1+repobject:nlmargin
   nlin++
   if lmode
      @ nlin,ncol say ' ' font "f0" TO PRINT
   else
      @ nlin,ncol say ' '
      eject
    
   endif
   
endif
if lpreview .and. ldos
   set device to screen
   set printer to
   repobject:mypreview(cfilerepo,ncvcopt)
else
   set device to screen
endif
if .not. ldos
  END PAGE
  END DOC
endif
****release nlmargin
return Nil

METHOD headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp,cheader) CLASS _OOHG_REPORT
local i,ncol,nsum,ncenter,ncenter2,npostitle,ctitle1,ctitle2
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
ncenter:=(nsum-len(ctitle1))/2
if len(ctitle2)>0
   ncenter2:=(nsum-len(ctitle2))/2
endif
repobject:npager++
if lmode
   @ nlin,1+repobject:nlmargin say _ooHG_MESSAGE[8] font "f0" TO PRINT
   @ nlin,6+repobject:nlmargin say str(repobject:npager,4) font "f0" TO PRINT
   @ nlin,ncenter+repobject:nlmargin say hb_oemtoansi(ctitle1) font "f1" TO PRINT
   @ nlin, nsum-10+len(awidths)+repobject:nlmargin say date() font "f0" TO PRINT
else
   @ nlin,1+repobject:nlmargin say _ooHG_MESSAGE[8]
   @ nlin,6+repobject:nlmargin say str(repobject:npager,4) 
   @ nlin,ncenter+repobject:nlmargin say ctitle1
   @ nlin, nsum-10+len(awidths)+repobject:nlmargin say date()
endif
if len(ctitle2)>0
   nlin++
   if lmode
      @ nlin,ncenter2+repobject:nlmargin say hb_oemtoansi(ctitle2) font "f1" TO PRINT
      @ nlin, nsum-10+len(awidths)+repobject:nlmargin say time() font "f0" TO PRINT
   else
      @ nlin,ncenter2+repobject:nlmargin say ctitle2 
      @ nlin, nsum-10+len(awidths)+repobject:nlmargin say time()
   endif
else
   nlin++
   if lmode
      @ nlin, nsum-10+len(awidths)+repobject:nlmargin say time() font "f0" TO PRINT
   else
      @ nlin, nsum-10+len(awidths)+repobject:nlmargin say time()
   endif
endif

nlin++
nlin++
ncol:=1+repobject:nlmargin
for i:=1 to  len(awidths)
    if lmode
        @ nlin,ncol say replicate('-',awidths[i]) font "f0" TO PRINT
    else
       @ nlin,ncol say replicate('-',awidths[i])
    endif
    ncol=ncol+awidths[i]+1
next i
nlin++

ncol:=1+repobject:nlmargin
for i:=1 to len(awidths)
    if lmode
       @ nlin,ncol say substr(hb_oemtoansi(aheaders1[i]),1,awidths[i]) font "f1" TO PRINT
    else
       @ nlin,ncol say substr(aheaders1[i],1,awidths[i])
    endif
    ncol=ncol+awidths[i]+1
next i
nlin++

ncol:=1+repobject:nlmargin
for i:=1 to len(awidths)
    if lmode
        @ nlin,ncol say substr(hb_oemtoansi(aheaders2[i]),1,awidths[i]) font "f1" TO PRINT
    else
        @ nlin,ncol say substr(aheaders2[i],1,awidths[i])
    endif
    ncol=ncol+awidths[i]+1
next i
nlin++
ncol:=1+repobject:nlmargin
for i:=1 to  len(awidths)
    if lmode
       @ nlin,ncol say replicate('-',awidths[i]) font "f0" TO PRINT
    else
       @ nlin,ncol say replicate('-',awidths[i])
    endif
    ncol=ncol+awidths[i]+1
next i
nlin:=nlin+2
if grpby<>NIL 
       if lmode
           @ nlin,1+repobject:nlmargin say '** ' +hb_oemtoansi(chdrgrp)+' ** '+hb_oemtoansi(&grpby) font "f1" TO PRINT
       else
           @ nlin,1+repobject:nlmargin say '** ' +chdrgrp+' ** '+&grpby 
       endif    
       nlin++
endif
return nlin

METHOD mypreview(cfilerepo) CLASS _OOHG_REPORT
   local wr
   wfilerepo:=cfilerepo
   wr:=hb_oemtoansi(memoread(wfilerepo))
   DEFINE WINDOW PRINT_PREVIEW  ;
   	AT 10,10 ;
   	   WIDTH 640 HEIGHT 480 ;
   	   TITLE 'Preview ----- ' +WFILEREPO ;
   	   MODAL
  
   	@ 0,0 EDITBOX EDIT_P ;
   	OF PRINT_PREVIEW ;
   	WIDTH 630 ;
   	HEIGHT 440 ;
   	VALUE WR ;
   	READONLY ;
   	FONT 'Courier new' ;
   	SIZE 10
   
   END WINDOW
   
   CENTER WINDOW PRINT_PREVIEW
   ACTIVATE WINDOW PRINT_PREVIEW

****ncpl ojoooooooooooo

      IF MSGYESNO ('Print ? ','Question')    &&& directo al puerto
         type &WFILEREPO to print
      ENDIF

*****************
   IF FILE('&WFILErepo')
      ERASE &WFILEREPO
   ENDIF
return nil


METHOD JUSTIFICALINEA(WPR_LINE,WTOPE) CLASS _OOHG_REPORT
LOCAL I,WLARLIN
WLARLIN=LEN(TRIM(WPR_LINE))
FOR I=1 TO WLARLIN
   IF WLARLIN=WTOPE
      EXIT
   ENDIF
   IF SUBSTR(WPR_LINE,I,1)=SPACE(1) .AND. SUBSTR(WPR_LINE,I-1,1)#SPACE(1) .AND. SUBSTR(WPR_LINE,I+1,1)#SPACE(1)
      WPR_LINE=LTRIM(SUBSTR(WPR_LINE,1,I-1))+SPACE(2)+LTRIM(SUBSTR(WPR_LINE,I+1,LEN(WPR_LINE)-I))
      WLARLIN=WLARLIN+1
   ENDIF   
NEXT I
RETURN WPR_LINE

METHOD extreport1(cfilerep,cheader) CLASS _OOHG_REPORT
local nContlin,i,ctitle,aheaders1,aheaders2,afields,awidths,atotals,aformats
local nlpp,ncpl,nllmargin,calias,ldos,lpreview,lselect,cgraphic,lmul,nfi,nci
local nff,ncf,cgrpby,chdrgrp,llandscape
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
       easyreport(ctitle,aheaders1,aheaders2,afields,awidths,atotals,nlpp,ldos,lpreview,cgraphic,nfi,nci,nff,ncf,lmul,cgrpby,chdrgrp,llandscape,ncpl,lselect,calias,nllmargin,aformats,npapersize,cheader)
return Nil

METHOD leadato(cName,cPropmet,cDefault) CLASS _OOHG_REPORT
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

METHOD leaimage(cName,cPropmet,cDefault) CLASS _OOHG_REPORT
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

METHOD leadatoh(cName,cPropmet,cDefault,npar) CLASS _OOHG_REPORT
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

METHOD leadatologic(cName,cPropmet,cDefault) CLASS _OOHG_REPORT
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

METHOD clean(cfvalue) CLASS _OOHG_REPORT
cfvalue:=strtran(cfvalue,'"','')
cfvalue:=strtran(cfvalue,"'","")
return cfvalue

METHOD learowi(cname,npar) CLASS _OOHG_REPORT
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

METHOD leacoli(cname,npar) CLASS _OOHG_REPORT
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
