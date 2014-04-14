#include "oohg.ch"
#DEFINE CRLF CHR(13)+CHR(10)
*----------------------------
Function repo_edit(cfilerep)
*----------------------------
local nContlin,i
local ctitle:=''
local aheaders:='{},{}'
local afields:='{}'       
local awidths:='{}'       
local atotals:=''       
local nformats:=''       
local nlpp:=50
local ncpl:=80
local nllmargin:=0
local cpapersize:='DMPAPER_LETTER'
local calias:=''
local ldos:=.F.
local lpreview:=.F.
local lselect:=.F.
local lmul:=.F.
local cgraphic:=" '     ' at 0,0 to 0,0"
local cgrpby:=''
local chdrgrp:=''
local landscape:=.F.      
myide:aliner:={}
myide:lvirtual:=.T.        

creport:=memoread(cfilerep)
   if file(cfilerep)
       nContlin:=mlcount(Creport)
       For i:=1 to nContlin
          aAdd (myide:Aliner,memoline(Creport,500,i))
       next i       
       ctitle:=(leadator('REPORT','TITLE',''))
       aheaders:=leadator('REPORT','HEADERS','{},{}')

       afields:=leadator('REPORT','FIELDS','{}')       
       awidths:=leadator('REPORT','WIDTHS','{}')       
       atotals:=leadator('REPORT','TOTALS','')       

       nformats:=leadator('REPORT','NFORMATS','')       

       nlpp:=val(leadator('REPORT','LPP','55'))
       ncpl:=val(leadator('REPORT','CPL','80'))
       nllmargin:=val(leadator('REPORT','LMARGIN',''))
       cpapersize:=(leadator('REPORT','PAPERSIZE',''))
       calias:=leadator('REPORT','WORKAREA','')
       ldos:=leadatologicr('REPORT','DOSMODE',.F.)
       lpreview:=leadatologicr('REPORT','PREVIEW',.F.)
       lselect:=leadatologicr('REPORT','SELECT',.F.)
       lmul:=leadatologicr('REPORT','MULTIPLE',.F.)
       cgraphic:=leadator('REPORT','IMAGE','')


***       cgrpby:=cleanr(leadator('REPORT','GROUPED BY',''))
       cgrpby:=(leadator('REPORT','GROUPED BY',''))
       chdrgrp:=cleanr(leadator('REPORT','HEADRGRP',''))
       landscape:=leadatologicr('REPORT','LANDSCAPE',.F.)      
   endif
   myide:lvirtual:=.T.
   Title:="Report parameters of "+cfilerep
   aLabels         := { 'Title'        ,'Headers'  ,'Fields','Widths ','Totals','Nformats','Workarea','Lpp','Cpl','Lmargin' ,'Dosmode','Preview','Select','Image / at - to','Multiple','Grouped by','Group header','Landscape','Papersize' }         
   aInitValues     := { ctitle         ,   aheaders, afields , awidths , atotals, nformats , calias   ,nlpp ,ncpl , nllmargin,ldos     , lpreview, lselect, cgraphic        , lmul     ,cgrpby      , chdrgrp      , landscape, cpapersize }    
   aFormats        := { 320            , 320       , 320     , 160     ,160     , 320      , 20       ,'999','999', '999'    , .F.     , .T.     , .F.    , 50              , .F.      , 50         ,28            ,.F.       , 30   }
   aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
   if aresults[1] == Nil
      **   msginfo('Properties abandoned','Information')
      return                    
   endif

    Output := 'DO REPORT ;'+CRLF
    Output += "TITLE "+aresults[1]+' ;'+CRLF   
    Output +="HEADERS "+ aresults[2]+' ;'+CRLF   
    Output +="FIELDS "+aresults[3]+' ;'+CRLF   
    Output += "WIDTHS "+aresults[4]+' ;'+CRLF   
    if len(aresults[5])>0
       Output +="TOTALS "+ aresults[5]+' ;'+CRLF   
    endif
    if len(aresults[6])>0
       Output += "NFORMATS "+aresults[6]+' ;'+CRLF   
    endif
    Output +="WORKAREA "+ aresults[7]+' ;'+CRLF   
    Output += "LPP "+str(aresults[8],3)+' ;'+CRLF   
    Output += "CPL "+str(aresults[9],3)+' ;'+CRLF   
    if aresults[10]>0
       Output += "LMARGIN "+str(aresults[10],3)+' ;'+CRLF   
    endif
    if len(aresults[19])>0
       Output += "PAPERSIZE "+upper(aresults[19])+' ;'+CRLF   
    endif

    if aresults[11]
       Output += "DOSMODE "+' ;'+CRLF   
    endif
    if aresults[12] 
       Output += "PREVIEW "+' ;'+CRLF   
    endif
    if aresults[13]
       Output += "SELECT "+' ;'+CRLF   
    endif
    if len(aresults[14])>0
       Output +="IMAGE "+ aresults[14]+' ;'+CRLF   
    endif
    if aresults[15]
       Output += "MULTIPLE "+' ;'+CRLF   
    endif

    if len(aresults[16])>0
       Output += "GROUPED BY "+aresults[16]+' ;'+CRLF   
    endif
    if len(aresults[17])>0
       Output += "HEADRGRP "+"'"+aresults[17]+"'"+' ;'+CRLF   
    endif
    if aresults[18]
       Output += "LANDSCAPE "+' ;'+CRLF   
    endif
    output+=CRLF+CRLF
    if memowrit(cfilerep,output)
       msginfo('Report saved','Information')
    else
       msginfo('Error saving report','Information')
    endif
Return nil

*------------------------------------------
function leadator(cName,cPropmet,cDefault)
*------------------------------------------
local i,sw,cfvalue
sw:=0
For i:=1 to len(myide:aliner)
if .not. at(upper(cname)+' ',upper(myide:aliner[i]))==0   
   sw:=1
else
   if sw==1
      npos:=at(upper(cPropmet)+' ',upper(myide:aliner[i]))
      if len(trim(myide:aliner[i]))==0
         return cDefault
      endif
      if npos>0 
         cfvalue:=substr(myide:aliner[i],npos+len(Cpropmet),len(myide:aliner[i]))
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
*-------------------------------------------
function leaimage(cName,cPropmet,cDefault)
*-------------------------------------------
local i,sw
sw1:=0
lin:=0
For i:=1 to len(myide:aliner)
        if at(upper('IMAGE'),myide:aliner[i])>0
               npos1:=at(upper('IMAGE'),upper(myide:aliner[i]))+6
               npos2:=at(upper('AT'),upper(myide:aliner[i]))-1
            lin:=i
            i:=len(myide:aliner)+1
            sw1:=1
        endif                 
next i
if sw1=1
   return substr(myide:aliner[lin],npos1,npos2-npos1+1)
endif
return cDefault
*----------------------------------------------
function leadatoh(cName,cPropmet,cDefault,npar)
*----------------------------------------------
local i,sw
sw1:=0
lin:=0
For i:=1 to len(myide:aliner)
        if at(upper('HEADERS'),myide:aliner[i])>0
            if npar=1
               npos1:=at(upper('{'),upper(myide:aliner[i]))
               npos2:=at(upper('}'),upper(myide:aliner[i]))
            else
               npos1:=rat(upper('{'),upper(myide:aliner[i]))
               npos2:=rat(upper('}'),upper(myide:aliner[i]))
            endif
            lin:=i
            i:=len(myide:aliner)+1
            sw1:=1
        endif                 
next i
if sw1=1
   return substr(myide:aliner[lin],npos1,npos2-npos1+1)
endif
return cDefault
*-----------------------------------------------
function leadatologicr(cName,cPropmet,cDefault)
*-----------------------------------------------
local i,sw
sw:=0
For i:=1 to len(myide:aliner)
if at(upper(cname)+' ',upper(myide:aliner[i]))#0   
   sw:=1
else
   if sw==1
      if at(upper(cPropmet)+' ',upper(myide:aliner[i]))>0
         return .T.
      endif
      if len(trim(myide:aliner[i]))==0
         return cDefault
      endif
   endif
endif
Next i
return cDefault

*-------------------------
function cleanr(cfvalue)
*-------------------------
cfvalue:=strtran(cfvalue,'"','')
cfvalue:=strtran(cfvalue,"'","")
return cfvalue

*----------------------------
function learowi(cname,npar)
*----------------------------
local i,npos1,npos2,nrow
sw:=0
nrow:='0'
For i:=1 to len(myide:aliner)
    if at(upper('IMAGE')+' ',upper(myide:aliner[i]))#0   
       if npar=1
          npos1:=at("AT",upper(myide:aliner[i]))
          npos2:=at(",",myide:aliner[i])
       else
          npos1:=at("TO",upper(myide:aliner[i]))
          npos2:=rat(",",myide:aliner[i])
       endif
       nrow:=substr(myide:aliner[i],npos1+3,len(myide:aliner[i])-npos2)
       i:=len(myide:aliner)
    endif
Next i
return nrow

*---------------------------
function leacoli(cname,npar)
*---------------------------
local i,npos,ncol
ncol:='0'
For i:=1 to len(myide:aliner)
if at(upper('IMAGE')+' ',upper(myide:aliner[i]))#0   
   if npar=1
      npos:=at(",",myide:aliner[i])
      ncol:=substr(myide:aliner[i],npos+1,3)
   else
      npos:=rat(",",myide:aliner[i])
      ncol:=substr(myide:aliner[i],npos+1,3)
   endif
   i:=len(myide:aliner)
endif
Next i
return ncol

