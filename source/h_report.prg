/*
 * $Id: h_report.prg,v 1.2 2005-08-26 06:04:16 guerra000 Exp $
 */
/*
 * ooHG source code:
 * Report generator
 *
 * Copyright 2005 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.guerra.com.mx
 *
 * Portions of this code are copyrighted by the Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
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
/*----------------------------------------------------------------------------
 MINIGUI - Harbour Win32 GUI library source code

 Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 http://www.geocities.com/harbour_minigui/

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
 contained in this release of Harbour Minigui.

 The exception is that, if you link the Harbour Minigui library with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the
 Harbour-Minigui library code into it.

 Parts of this project are based upon:

	"Harbour GUI framework for Win32"
 	Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
 	Copyright 2001 Antonio Linares <alinares@fivetech.com>
	www - http://www.harbour-project.org

	"Harbour Project"
	Copyright 1999-2003, http://www.harbour-project.org/
---------------------------------------------------------------------------*/

#include 'oohg.ch'
#include 'winprint.ch'

MEMVAR NPOS
MEMVAR NPOS1
MEMVAR NPOS2
MEMVAR LIN
MEMVAR SW
MEMVAR SW1
MEMVAR CREPORT
MEMVAR aline
MEMVAR cgraphicalt
MEMVAR WLARLIN
MEMVAR _npage
MEMVAR angrpby
MEMVAR CGRPBY
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
MEMVAR AFIELDSG
MEMVAR AWIDTHS
MEMVAR NPOSGRP
MEMVAR NLMARGIN
MEMVAR NLLMARGIN
MEMVAR CROMPE
MEMVAR CHDRGRP
MEMVAR WFILEREPO
MEMVAR CALIAS
MEMVAR AT
MEMVAR AW
MEMVAR AD
MEMVAR NLPP
MEMVAR NCPL
MEMVAR LPREVIEW
MEMVAR CFILEREPO
MEMVAR NFSIZE
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

function easyreport
parameters ctitle,aheaders1,aheaders2,afields,awidths,atotals,nlpp,ldos,lpreview,cgraphic,nfi,nci,nff,ncf,lmul,cgrpby,chdrgrp,llandscape,ncpl,lselect,calias,nllmargin,aformats,npapersize
local nlin,i,ncol,aresul,lmode,swt:=0,nran,grpby,cfile,k,aprinters,aports
public _npage,angrpby,wfield,nlmargin,nfsize


INIT PRINTSYS
GET PRINTERS TO aprinters
GET PORTS TO aports
RELEASE PRINTSYS


if nllmargin = NIL
   nlmargin:=0
else
   nlmargin:=nllmargin
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

if npapersize==NIL
   npapersize=DMPAPER_LETTER
endif

_npage:=0
grpby:=cgrpby
aresul:=array(len(afields))
angrpby:=array(len(afields))
for i:=1 to len(afields)
    afields[i]:=upper(afields[i])
next i
if grpby<>NIL
   grpby:=upper(grpby)
endif
cfile:=calias
select(calias)
AFieldsg:= &cfile->(ARRAY(FCOUNT()))
aT := &cfile->(ARRAY(FCOUNT()))
aW := &cfile->(ARRAY(FCOUNT()))
aD := &cfile->(ARRAY(FCOUNT()))
&cfile->(AFIELDS(aFieldsg, aT, aW, aD))
lmode:=.T.
if nlpp= NIL
   nlpp=50
endif
if ldos
   lmode:=.F.
   ********** tipo de letra
   if ncpl= NIL
      ncpl=80
**      @ prow(),pcol() say chr(18)
   else
      if ncpl=132
         @ prow(),pcol() say chr(15)
**      else
***         @ prow(),pcol() say chr(18)
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
else
   if ncpl = NIL
      ncpl:=80
      nfsize=12
   else
      do case
         case ncpl= 80
            nfsize:=12
         case ncpl= 96
            nfsize=10
         case ncpl= 120
            nfsize:=8
         case ncpl= 140
           nfsize:=7
         case ncpl= 160
           nfsize:=6
         otherwise
           nfsize:=12
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
   define font "f0" name "courier new" size nfsize
   define font "f1" name "courier new" size nfsize BOLD
   if llandscape
      set page orientation DMORIENT_LANDSCAPE font "f0"
   else
      set page orientation DMORIENT_PORTRAIT  font "f0"
   endif
   set page papersize npapersize
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
     @nfi,nci+nlmargin  PICTURE cgraphic  size nff-nfi-4, ncf-nci-3
   endif
endif
ngrpby:=0
nlin:=headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp)
for i:=1 to len(afields)
    aresul[i]:=0
    angrpby[i]:=0
next i
if grpby<> NIL
   nposgrp:=ascan(afieldsg,grpby)
   if nposgrp>0
      wfield1:=afieldsg[nposgrp]
      crompe:= &wfield1
   endif
endif
do while .not. eof()
   ncol:=1+nlmargin
   swt:=0
   if grpby<>NIL
      wfield1:=afieldsg[nposgrp]
      if .not.(&wfield1 == crompe)
         if lmode
            if ascan(atotals,.T.)>0
               @ nlin,1+nlmargin say '** Subtotal **' font "f1" TO PRINT
               nlin++
            endif
**************
            for i:=1 to len(afields)
                if atotals[i]
                   @ nlin,ncol say iif(.not.(aformats[i]==''),transform(angrpby[i],aformats[i]),str(angrpby[i],awidths[i])) font "f1"TO PRINT
                endif
                ncol:=ncol+awidths[i]+1
            next i
**************
         else
            if ascan(atotals,.T.)>0
               @ nlin,1+nlmargin say '** Subtotal **'
               nlin++
            endif
**************
            for i:=1 to len(afields)
                if atotals[i]
                      @ nlin,ncol say iif(.not.(aformats[i]==''),transform(angrpby[i],aformats[i]),str(angrpby[i],awidths[i]))
                endif
                ncol:=ncol+awidths[i]+1
            next i
**************
         endif
        for i:=1 to len(afields)
          angrpby[i]:=0
        next i
        crompe:=&wfield1
        nlin++
        if lmode
***             change  font "f0" size nfsize BOLD
           @ nlin,1+nlmargin say '** ' +hb_oemtoansi(chdrgrp)+' ** '+hb_oemtoansi(&grpby) font "f1" TO PRINT
       else
           @ nlin,1+nlmargin say '** ' +chdrgrp+' ** '+&grpby
       endif
        nlin++
      endif
   endif
**********
   ncol:=1+nlmargin
   for i:=1 to len(afields)
       wfield:=afields[i]
       if lmode
            do case
               case type('&wfield')=='C'
                 @ nlin,ncol say substr(hb_oemtoansi(&wfield),1,awidths[i]) font "f0" TO PRINT
               case type('&wfield')=='N'
                @ nlin,ncol say  iif(.not.(aformats[i]==''),transform(&wfield,aformats[i]),str(&wfield,awidths[i])) font "f0" TO PRINT

               case type('&wfield')=='D'
                 @ nlin,ncol say substr(dtoc(&wfield),1,awidths[i]) font "f0" TO PRINT
               case type('&wfield')=='L'
                 @ nlin,ncol say iif(&wfield,'.T.','.F.') font "f0" TO PRINT
               case type('&wfield')=='M'
                 for k:=1 to mlcount(&wfield,awidths[i])
                     @ nlin,ncol say justificalinea(memoline(&wfield,awidths[i] ,k),awidths[i]) font "f0" TO PRINT
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
                                                         @nfi,nci+nlmargin  PICTURE cgraphic  size nff-nfi-4, ncf-nci-3
						 endif
					   endif
				endif
			nlin:=headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp)
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
**                 @ nlin,ncol say str(&wfield,awidths[i])
                  @ nlin,ncol say iif(.not.(aformats[i]==''),transform(&wfield,aformats[i]),str(&wfield,awidths[i]))
               case type('&wfield')=='D'
                 @ nlin,ncol say substr(dtoc(&wfield),1,awidths[i])
               case type('&wfield')=='L'
                 @ nlin,ncol say iif(&wfield,'.T.','.F.')
               case type('&wfield')=='M'
                 for k:=1 to mlcount(&wfield,awidths[i])
                     @ nlin,ncol say justificalinea(memoline(&wfield,awidths[i] ,k),awidths[i])
                     nlin++
   			if nlin>nlpp
			   nlin:=1

  			nlin:=headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp)
			endif
                 next k

               otherwise
                 @ nlin,ncol say replicate('_',awidths[i])
            endcase
       endif

       ncol:=ncol+awidths[i]+1
       if atotals[i]
          aresul[i]:=aresul[i]+&wfield
          swt:=1
          if grpby<>NIL
             angrpby[i]:=angrpby[i]+&wfield
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
         @nfi,nci+nlmargin  PICTURE cgraphic  size nff-nfi-4, ncf-nci-3
      endif
   endif
endif
nlin:=headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp)
endif
skip
enddo

if swt==1
   ncol:=1+nlmargin
   if grpby<>NIL
      wfield1:=afieldsg[nposgrp]
      if .not.(&wfield1 == crompe)
         if lmode
**              change  font "f0" size nfsize BOLD
            if ascan(atotals,.T.)>0
               @ nlin,1+nlmargin say '** Subtotal **' font "f1" TO PRINT
               nlin++
            endif
            for i:=1 to len(afields)
                if atotals[i]
                      @ nlin,ncol say iif(.not.(aformats[i]==''),transform(angrpby[i],aformats[i]),str(angrpby[i],awidths[i])) font "f1" TO PRINT
                endif
                ncol:=ncol+awidths[i]+1
            next i
***              change  font "f0" size nfsize  NOBOLD
         else
            if ascan(atotals,.T.)>0
               @ nlin,1+nlmargin say '** Subtotal **'
               nlin++
            endif
            for i:=1 to len(afields)
                if atotals[i]
***                   @ nlin,ncol say str(angrpby[i],awidths[i])
                   @ nlin,ncol say iif(.not.(aformats[i]==''),transform(angrpby[i],aformats[i]),str(angrpby[i],awidths[i]))
                endif
                ncol:=ncol+awidths[i]+1
            next i
        endif
        for i:=1 to len(afields)
          angrpby[i]:=0
        next i
        crompe:=&wfield1
      endif
   endif
**************
   nlin++
   ncol:=1+nlmargin
   if nlin>nlpp
      nlin:=1
      if .not. ldos
           END PAGE
           START PAGE
      endif
      nlin:=headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp)
   endif
   if lmode
**      change  font "f0"  size nfsize BOLD
      if ascan(atotals,.T.)>0
         @nlin,ncol say '*** Total ***' font "f1" TO PRINT
      endif
   else
      if ascan(atotals,.T.)>0
         @nlin,ncol say '*** Total ***'
      endif
   endif
   nlin++
   ncol:=1+nlmargin
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
   if lmode
***      change  font "f0"  size nfsize NOBOLD
   endif
   ncol:=1+nlmargin
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
   mypreview(cfilerepo)
else
   set device to screen
endif
if .not. ldos
  END PAGE
  END DOC
endif
release _npage,angrpby,wfield,nlmargin
return Nil

function headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp)
local i,ncol,nsum,ncenter,ncenter2,npostitle,ctitle1,ctitle2
nsum:=0
for i:=1 to len(awidths)
    nsum:=nsum+awidths[i]
next i
npostitle:=at('|',ctitle)
ctitle1:=ctitle2:=''
if npostitle>0
   ctitle1:=left(ctitle,npostitle-1)
   ctitle2:=substr(ctitle,npostitle+1,len(ctitle))
else
   ctitle1:=ctitle
endif
ncenter:=(nsum-len(ctitle1))/2
if len(ctitle2)>0
   ncenter2:=(nsum-len(ctitle2))/2
endif
_npage++
if lmode
   @ nlin,1+nlmargin say _OOHG_MESSAGE [8] font "f0" TO PRINT
   @ nlin,6+nlmargin say str(_npage,4) font "f0" TO PRINT
***     change  font "f0"  size nfsize BOLD
   @ nlin,ncenter+nlmargin say hb_oemtoansi(ctitle1) font "f1" TO PRINT
***     change  font "f0"  size nfsize NOBOLD
   @ nlin, nsum-10+len(afields)+nlmargin say date() font "f0" TO PRINT
else
   @ nlin,1+nlmargin say _OOHG_MESSAGE [8]
   @ nlin,6+nlmargin say str(_npage,4)
   @ nlin,ncenter+nlmargin say ctitle1
   @ nlin, nsum-10+len(afields)+nlmargin say date()
endif
if len(ctitle2)>0
   nlin++
   if lmode
**        change  font "f0" size nfsize  BOLD
      @ nlin,ncenter2+nlmargin say hb_oemtoansi(ctitle2) font "f1" TO PRINT
***        change  font "f0" size nfsize  NOBOLD
      @ nlin, nsum-10+len(afields)+nlmargin say time() font "f0" TO PRINT
   else
      @ nlin,ncenter2+nlmargin say ctitle2
      @ nlin, nsum-10+len(afields)+nlmargin say time()
   endif
else
   nlin++
   if lmode
      @ nlin, nsum-10+len(afields)+nlmargin say time() font "f0" TO PRINT
   else
      @ nlin, nsum-10+len(afields)+nlmargin say time()
   endif
endif

nlin++
nlin++
ncol:=1+nlmargin
for i:=1 to  len(awidths)
    if lmode
        @ nlin,ncol say replicate('-',awidths[i]) font "f0" TO PRINT
    else
       @ nlin,ncol say replicate('-',awidths[i])
    endif
    ncol=ncol+awidths[i]+1
next i
nlin++
if lmode
***     change  font "f0"  size nfsize BOLD
endif

ncol:=1+nlmargin
for i:=1 to len(awidths)
    if lmode
       @ nlin,ncol say substr(hb_oemtoansi(aheaders1[i]),1,awidths[i]) font "f1" TO PRINT
    else
       @ nlin,ncol say substr(aheaders1[i],1,awidths[i])
    endif
    ncol=ncol+awidths[i]+1
next i
nlin++

ncol:=1+nlmargin
for i:=1 to len(awidths)
    if lmode
        @ nlin,ncol say substr(hb_oemtoansi(aheaders2[i]),1,awidths[i]) font "f1" TO PRINT
    else
        @ nlin,ncol say substr(aheaders2[i],1,awidths[i])
    endif
    ncol=ncol+awidths[i]+1
next i
nlin++
if lmode
**     change  font "f0"  size nfsize NOBOLD
endif
ncol:=1+nlmargin
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
**             change  font "f0"  size nfsize BOLD
           @ nlin,1+nlmargin say '** ' +hb_oemtoansi(chdrgrp)+' ** '+hb_oemtoansi(&grpby) font "f1" TO PRINT
***         change  font "f0"  size nfsize NOBOLD
       else
           @ nlin,1+nlmargin say '** ' +chdrgrp+' ** '+&grpby
       endif
       nlin++
endif
return nlin

function mypreview(cfilerepo)
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

   IF MSGYESNO ('Print ? ','Question')
      RUN TYPE &WFILEREPO > PRN
   ENDIF
   IF FILE('&WFILErepo')
      ERASE &WFILEREPO
   ENDIF
return nil

FUNCTION JUSTIFICALINEA(WPR_LINE,WTOPE)
LOCAL I
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

function extreport(cfilerep)
local nContlin,i,ctitle,aheaders1,aheaders2,afields,awidths,atotals,aformats
local nlpp,ncpl,nllmargin,calias,ldos,lpreview,lselect,cgraphic,lmul,nfi,nci
local nff,ncf,cgrpby,chdrgrp,llandscape
Public aline:={}
       if .not. file(cfilerep+'.rpt')
          msginfo('('+cfilerep+'.rpt)  File not found','Information')
          release aline
          return Nil
       endif

       creport:=memoread(cfilerep+'.rpt')
       nContlin:=mlcount(Creport)
       For i:=1 to nContlin
          aAdd (Aline,memoline(Creport,500,i))
       next i
       ctitle:=leadato('REPORT','TITLE','')
       if len(ctitle)>0
          ctitle:=&ctitle
       endif
       aheaders1:=leadatoh('REPORT','HEADERS','{}',1)
       aheaders1:=&aheaders1
       aheaders2:=leadatoh('REPORT','HEADERS','{}',2)
       aheaders2:=&aheaders2
       afields:=leadato('REPORT','FIELDS','{}')
       if len(afields)=0
          msginfo('Fields not defined','Information')
          release aline
          return Nil
       endif
       afields:=&afields
       awidths:=leadato('REPORT','WIDTHS','{}')
       if len(awidths)=0
          msginfo('Widths not defined','Information')
          release aline
          return Nil
       endif
       awidths:=&awidths
       atotals:=leadato('REPORT','TOTALS',NIL)
       if atotals<>NIL
          atotals:=&atotals
       endif
       aformats:=leadato('REPORT','NFORMATS',NIL)
       if aformats<>NIL
          aformats:=&aformats
       endif
       nlpp:=val(leadato('REPORT','LPP',''))
       ncpl:=val(leadato('REPORT','CPL',''))
       nllmargin:=val(leadato('REPORT','LMARGIN','0'))
       npapersize:=leadato('REPORT','PAPERSIZE','DMPAPER_LETTER')
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
       calias:=leadato('REPORT','WORKAREA','')
       ldos:=leadatologic('REPORT','DOSMODE',.F.)
       lpreview:=leadatologic('REPORT','PREVIEW',.F.)
       lselect:=leadatologic('REPORT','SELECT',.F.)
       lmul:=leadatologic('REPORT','MULTIPLE',.F.)

       cgraphic:=clean(leaimage('REPORT','IMAGE',''))
       if len(cgraphic)==0
          cgraphic:=NIL
       endif
       nfi:=val((learowi('IMAGE',1)))
       nci:=val((leacoli('IMAGE',1)))
       nff:=val((learowi('IMAGE',2)))
       ncf:=val((leacoli('IMAGE',2)))
       cgraphicalt:=(leadato('DEFINE REPORT','IMAGE',''))
       if len(cgraphicalt)>0  &&& para sintaxis DEFINE REPORT
          cgraphicalt:=&cgraphicalt
          cgraphic:=cgraphicalt[1]
          nfi:=cgraphicalt[2]
          nci:=cgraphicalt[3]
          nff:=cgraphicalt[4]
          ncf:=cgraphicalt[5]
       endif
       cgrpby:=clean(leadato('REPORT','GROUPED BY',''))
       if len(cgrpby)=0
          cgrpby=NIL
       endif
       chdrgrp:=clean(leadato('REPORT','HEADRGRP',''))
       llandscape:=leadatologic('REPORT','LANDSCAPE',.F.)
       easyreport(ctitle,aheaders1,aheaders2,afields,awidths,atotals,nlpp,ldos,lpreview,cgraphic,nfi,nci,nff,ncf,lmul,cgrpby,chdrgrp,llandscape,ncpl,lselect,calias,nllmargin,aformats,npapersize)
       release aline
return Nil

function leadato(cName,cPropmet,cDefault)
local i,sw,cfvalue
sw:=0
For i:=1 to len(aline)
if .not. at(upper(cname)+' ',upper(aline[i]))==0
   sw:=1
else
   if sw==1
      npos:=at(upper(cPropmet)+' ',upper(aline[i]))
      if len(trim(aline[i]))==0
         i=len(aline)+1
         return cDefault
      endif
      if npos>0
         cfvalue:=substr(aline[i],npos+len(Cpropmet),len(aline[i]))
         i:=len(aline)+1
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

function leaimage(cName,cPropmet,cDefault)
local i

* Unused Parameters
CNAME := Nil
CPROPMET := Nil
*

sw1:=0
lin:=0
For i:=1 to len(aline)
    if at(upper('IMAGE'),aline[i])>0
       npos1:=at(upper('IMAGE'),upper(aline[i]))+6
       npos2:=at(upper('AT'),upper(aline[i]))-1
       lin:=i
       i:=len(aline)+1
       sw1:=1
    endif
next i
if sw1=1
   return substr(aline[lin],npos1,npos2-npos1+1)
endif
return cDefault

function leadatoh(cName,cPropmet,cDefault,npar)
local i
sw1:=0
lin:=0

* Unused Parameters
CNAME := Nil
CPROPMET := Nil
*

For i:=1 to len(aline)
        if at(upper('HEADERS'),aline[i])>0
            if npar=1
               npos1:=at(upper('{'),upper(aline[i]))
               npos2:=at(upper('}'),upper(aline[i]))
            else
               npos1:=rat(upper('{'),upper(aline[i]))
               npos2:=rat(upper('}'),upper(aline[i]))
            endif
            lin:=i
            i:=len(aline)+1
            sw1:=1
        endif
next i
if sw1=1
   return substr(aline[lin],npos1,npos2-npos1+1)
endif
return cDefault

function leadatologic(cName,cPropmet,cDefault)
local i,sw
sw:=0
For i:=1 to len(aline)
if at(upper(cname)+' ',upper(aline[i]))#0
   sw:=1
else
   if sw==1
      if at(upper(cPropmet)+' ',upper(aline[i]))>0
         return .T.
      endif
      if len(trim(aline[i]))==0
         i=len(aline)+1
         return cDefault
      endif
   endif
endif
Next i
return cDefault

function clean(cfvalue)
cfvalue:=strtran(cfvalue,'"','')
cfvalue:=strtran(cfvalue,"'","")
return cfvalue

function learowi(cname,npar)
local i,npos1,nrow
sw:=0
nrow:='0'

* Unused Parameters
CNAME := Nil
*

For i:=1 to len(aline)
    if at(upper('IMAGE')+' ',upper(aline[i]))#0
       if npar=1
          npos1:=at("AT",upper(aline[i]))
       else
          npos1:=at("TO",upper(aline[i]))
       endif
       nrow:=substr(aline[i],npos1+3,4)
       i:=len(aline)
    endif
Next i
return nrow

function leacoli(cname,npar)
local i,npos,ncol
ncol:='0'

* Unused Parameters
CNAME := Nil
*

For i:=1 to len(aline)
if at(upper('IMAGE')+' ',upper(aline[i]))#0
   if npar=1
      npos:=at(",",aline[i])
   else
      npos:=rat(",",aline[i])
   endif
   ncol:=substr(aline[i],npos+1,4)
   i:=len(aline)
endif
Next i
return ncol

