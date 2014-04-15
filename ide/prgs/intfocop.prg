/*
 * $Id: intfocop.prg,v 1.2 2014-04-15 00:46:19 fyurisich Exp $
 */

#include 'oohg.ch'
*------------------------------------------------------------------------------*
function intfoco(qw)
*------------------------------------------------------------------------------*
local i , iRow , iCol , iWidth , iHeight , h , j , k , l , z , eRow , eCol , dRow , dCol , BaseRow , BaseCol, BaseWidth , BaseHeight , TitleHeight , BorderWidth , BorderHeight  , CurrentPage , IsInTab , SupMin , iMin,cname,jk,jl
declare window form_main
declare window form_1

        if qw=0
           intfoco1(0)
           return
        endif
        h := GetFormHandle ( myform:designform )
	BaseRow 	:= GetWindowRow ( h ) + GetBorderHeight()
	BaseCol 	:= GetWindowCol ( h ) + GetBorderWidth()
	BaseWidth 	:= GetWindowWidth ( h )
	BaseHeight 	:= GetWindowHeight ( h )
	TitleHeight 	:= GetTitleHeight()
	BorderWidth 	:= GetBorderWidth()
	BorderHeight 	:= GetBorderHeight()
***
                i:=nhandlep

                jk:=i

                if jk>0

                   if siesdeste(jk,'IMAGE') .or. siesdeste(jk,'TIMER') ;
                      .or. siesdeste(jk,'PLAYER')  .or. siesdeste(jk,'ANIMATE') ;
                    .or. siesdeste(jk,'PICCHECKBUTT') .or. siesdeste(jk,'PICBUTT')
                      return
                   endif
                   owindow:=getformobject("form_1")       
                   si:=ascan(myform:acontrolw,{  |c| lower( c ) == lower(owindow:acontrols[jk]:name) } )


                   if si>0
                      intfoco1(si)
                      CHideControl (owindow:acontrols[jk])
                      CShowControl (owindow:acontrols[jk])
                      return
                   endif
                else
                   return
                endif
return
*----------------------
function intfoco1(si)
*----------------------
load window intfonco
if si=0
   intfonco.label_1.value:='  Form : '+myform:cfname
else
   intfonco.label_1.value:='Control: '+myform:aname[si]
endif
activate window intfonco
return

*---------------------
function sdefcol(si)
*---------------------
local cCode:='{',cbackcolor,acolor
local cname
if si=0
else
  cname:=myform:acontrolw[si]
endif
cCode:=myide:asystemcoloraux
if si=0
   myform:cfbackcolor:='NIL'
   myform:lfsave:=.F.
**********
   form_1.backcolor:=cCode
   form_1.hide
   form_1.show
   intfonco.button_103.setfocus
***********
   return
endif
myform:abackcolor[si]:='NIL'
getcontrolobject(cname,"form_1"):backcolor:=cCode
myform:lfsave:=.F.
return

*--------------------
function gfontt(si)
*--------------------
local cname,ncolor,afont

if si=0
   afont:=getfont(myform:cffontname,myform:nffontsize,.F.,.F.,{0,0,0},.F.,.F.,0)
else
   cname:=myform:acontrolw[si]
   nfontcolor:=myform:afontcolor[si]
   afont:=getfont(myform:afontname[si],myform:afontsize[si],myform:abold[si],myform:afontitalic[si],&nfontcolor,myform:afontunderline[si],myform:afontstrikeout[si],0)
endif
if afont[1]="" .and. afont[2]=0.and. (.not. afont[3]) .and. (.not. afont[4]) .and. ( afont[5,1]=NIL .and. afont[5,2]=NIL .and. afont[5,3]=NIL) .and. (.not. afont[6]) .and. (.not. afont[7]) .and. afont[8]=0
   return
endif
if si=0 .and. len(afont[1])>0
   myform:cffontname:=afont[1]
endif
if si=0 .and. afont[2]>0
   myform:nffontsize:=afont[2]
endif
if si=0
   myform:lfsave:=.F.
   return
endif

if len(afont[1])>0
   myform:afontname[si]:=afont[1]
   getcontrolobject(cname,"form_1"):fontname:=afont[1]
endif
if afont[2]>0
   myform:afontsize[si]:=afont[2]
   getcontrolobject(cname,"form_1"):fontsize:=afont[2]
endif

if myform:abold[si]<>afont[3]
   myform:abold[si]:=afont[3]
   getcontrolobject(cname,"form_1"):fontbold:=afont[3]
endif
if myform:afontitalic[si]<>afont[4]
   myform:afontitalic[si]:=afont[4]
   getcontrolobject(cname,"form_1"):fontitalic:=afont[4]
endif
nred:=afont[5,1]
ngreen:=afont[5,2]
nblue:=afont[5,3]
if nred<>NIL .and. ngreen<>NIL .and. nblue<>NIL
   ccolor:='{'+str(nred,3)+','+str(ngreen,3)+','+str(nblue,3)+'}'
   myform:afontcolor[si]:=ccolor
getcontrolobject(cname,"form_1"):fontcolor:=&ccolor
endif

if myform:afontunderline[si]<>afont[6]
   myform:afontunderline[si]:=afont[6]
getcontrolobject(cname,"form_1"):fontunderline:=afont[6]
endif
if myform:afontstrikeout[si]<>afont[7]
   myform:afontstrikeout[si]:=afont[7]
getcontrolobject(cname,"form_1"):fontstrikeout:=afont[7]
endif
myform:lfsave:=.F.
return

*--------------------
function gbackc(si)
*--------------------
local cCode:='{',cbackcolor,acolor
local cname
if si=0
  cbackcolor:=myform:cfbackcolor
else
  cname:=myform:acontrolw[si]
  cbackcolor:=myform:abackcolor[si]
endif
if len(cbackcolor)>0
   acolor:=getcolor(&cbackcolor)
else
   acolor:=getcolor()
endif
if acolor[1]=NIL .and. acolor[2]=NIL .and. acolor[3]=NIL
   return
endif
cCode += ALLTRIM(STR( acolor[1] )) + " , "
cCode += ALLTRIM(STR( acolor[2] )) + " , "
cCode += ALLTRIM(STR( acolor[3] )) + " }"
if si=0
   myform:cfbackcolor:=cCode
   myform:lfsave:=.F.
**********
   form_1.backcolor:=&ccode
   form_1.hide
   form_1.show
   intfonco.button_103.setfocus
***********
   return
endif
myform:abackcolor[si]:=cCode
getcontrolobject(cname,"form_1"):backcolor:=&cCode
myform:lfsave:=.F.
return

/*
#pragma BEGINDUMP

#define HB_OS_WIN_32_USED
#define _WIN32_WINNT   0x0400
#include <windows.h>
#include "hbapi.h"
#include "hbapiitm.h"


HB_FUNC ( ISWINDOWVISIBLE )
{
   hb_retl( IsWindowVisible( ( HWND ) hb_parnl( 1 ) ) );
}

HB_FUNC ( GETWINDOW )
{
   hb_retnl( ( LONG ) GetWindow( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ) ) );
}

#pragma ENDDUMP
*/
