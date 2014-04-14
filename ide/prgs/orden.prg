#include 'oohg.ch'
function ordercontrol()

set interactiveclose on

load window orderf AS ordercontrol
ordercontrol:=getformobject("ordercontrol")
ordercontrol:backcolor:=myide:asystemcolor
center window ordercontrol
activate window ordercontrol
swordenfd:=.F.
mispuntos()
return nil

*------------------------
function llenatipos()
*------------------------
local i
ordercontrol:list_tipos:deleteallitems()
ordercontrol:list_tipos:additem('Form')
for i:=1 to myform:ncontrolw
    if myform:actrltype[i]=='TAB'
       ordercontrol:list_tipos:additem(myform:acontrolw[i])
    endif
next i
ordercontrol:list_tipos:value:=1
llenacon()
return nil

*-------------------
function filterdc()
*-------------------
if .not. swordenfd
   swordenfd:=.T.
else
   swordenfd:=.F.
endif
llenacon()
return nil

*---------------------
function llenacon()
*---------------------
local j,cname,k,sw,wvalue
cursorwait()
sw:=0 &&&& algun TAB
wvalue:=ordercontrol:list_tipos:value
Ordercontrol:Treeorden:deleteAllitems()

if wvalue=1
   sw:=1  &&& forma general
else
   cname=ordercontrol:list_tipos:item(wvalue)
endif

if sw=0 &&& TAB
   currentpage:=1
   j:=ascan(myform:acontrolw,cname)
   ccaption:=myform:acaption[j]
   accaption:=&ccaption
   Ordercontrol:Treeorden:AddItem( 'page '+ accaption[currentpage] )
   For i:= 2 to myform:ncontrolw
   if myform:atabpage[i,1] # NIL
      if  myform:atabpage[i,1]==cname
          if myform:atabpage[i,2]#currentpage
************ swap lines
             currentpage:=myform:atabpage[i,2]
             Ordercontrol:Treeorden:AddItem( 'page '+accaption[currentpage] )
          endif
             if (upper(myform:actrltype[i])$"LABEL FRAME TIMER IMAGE") .and. swordenfd
             else
               Ordercontrol:Treeorden:AddItem( '      '+myform:aname[i] )
             endif
      endif
   endif
   next i
   ordercontrol:treeorden:value:=2
else
   For i:= 2 to myform:ncontrolw
    if (myform:atabpage[i,2]=0 .or. myform:atabpage[i,2]=NIL) .and. myform:acontrolw[i]#''
       if upper(myform:acontrolw[i])#'STATUSBAR'  .AND. upper(myform:acontrolw[i])#'MAINMENU' ;
         .and. upper(myform:acontrolw[i])#'CONTEXTMENU' .AND. upper(myform:acontrolw[i])#'NOTIFYMENU'

             if (upper(myform:actrltype[i])$"LABEL FRAME TIMER IMAGE") .and. swordenfd
             else
                Ordercontrol.Treeorden.AddItem( myform:aname[i])
             endif


       endif
    endif
   next i
ordercontrol:treeorden:value:=1
endif
cursorarrow()
return nil

*---------------------
function ord_arriba()
*---------------------
local t

iabajo:=ordercontrol:treeorden:value
if iabajo=1 .or. iabajo=0
   return nil
endif
if substr(ordercontrol:treeorden:item(iabajo),1,4)='page'
   return nil
endif

iarriba:=iabajo-1
cControl1:=alltrim(ordercontrol:treeorden:item(iabajo))
cControl2:=alltrim(ordercontrol:treeorden:item(iarriba))
*******
iposicion1:=ascan(myform:aname,cControl1)
iposicion2:=ascan(myform:aname,cControl2)
********

if substr(ordercontrol:treeorden:item(iarriba),1,1)#' ' .and. (myform:atabpage[iposicion1,2]#0 .and. myform:atabpage[iposicion1,2]#NIL)
   return nil
endif
cursorwait()
swapea(iposicion1,iposicion2)
****llenacon()
t:=ordercontrol:treeorden:item(iabajo)
ordercontrol.treeorden.item(iabajo):=ordercontrol.treeorden.item(iarriba)
ordercontrol.treeorden.item(iarriba):=t
*****
ordercontrol:treeorden:value:=iarriba
myform:lfSave:=.F.
cursorarrow()
return nil

*--------------------
function ord_abajo()
*--------------------
local t
iarriba:=ordercontrol:treeorden:value
if iarriba=ordercontrol:treeorden:itemcount() .or. iarriba=0
   return nil
endif
if substr(ordercontrol.treeorden.item(iarriba),1,4)='page'
   return nil
endif
iabajo:=iarriba+1
cControl1:=alltrim(ordercontrol:treeorden:item(iarriba))
cControl2:=alltrim(ordercontrol:treeorden:item(iabajo))
*****
iposicion1:=ascan(myform:aname,cControl1)
iposicion2:=ascan(myform:aname,cControl2)
*****
if substr(ordercontrol.treeorden.item(iabajo),1,1)#' ' .and. (myform:atabpage[iposicion1,2]#0 .and. myform:atabpage[iposicion1,2]#NIL)
   return nil
endif
cursorwait()
swapea(iposicion1,iposicion2)
***llenacon()
t:=ordercontrol.treeorden.item(iarriba)
ordercontrol.treeorden.item(iarriba):=ordercontrol.treeorden.item(iabajo)
ordercontrol.treeorden.item(iabajo):=t
***
ordercontrol:treeorden:value:=iabajo
myform:lfSave:=.F.
cursorarrow()
return nil

*----------------
function actsic()
*----------------
set interactiveclose off
return

*---------------------
function swapea(x1,x2)
*---------------------
local t83,t84
cambia("myform:acontrolw",x1,x2)
cambia("myform:actrltype",x1,x2)
cambia("myform:aenabled",x1,x2)
cambia("myform:avisible",x1,x2)
cambia("myform:afontname",x1,x2)
cambia("myform:afontsize",x1,x2)
cambia("myform:abold",x1,x2)
cambia("myform:abackcolor",x1,x2)
cambia("myform:afontcolor",x1,x2)
cambia("myform:afontitalic",x1,x2)
cambia("myform:afontunderline",x1,x2)
cambia("myform:afontstrikeout",x1,x2)
cambia("myform:atransparent",x1,x2)
cambia("myform:acaption",x1,x2)
cambia("myform:apicture",x1,x2)
cambia("myform:avalue",x1,x2)
cambia("myform:avaluen",x1,x2)
cambia("myform:avaluel",x1,x2)
cambia("myform:atooltip",x1,x2)
cambia("myform:amaxlength",x1,x2)
cambia("myform:awrap",x1,x2)
cambia("myform:aincrement",x1,x2)
cambia("myform:auppercase",x1,x2)
cambia("myform:apassword",x1,x2)
cambia("myform:anumeric",x1,x2)
cambia("myform:ainputmask",x1,x2)
cambia("myform:alowercase",x1,x2)
cambia("myform:aaction",x1,x2)
cambia("myform:aopaque",x1,x2)
cambia("myform:arange",x1,x2)
cambia("myform:anotabstop",x1,x2)
cambia("myform:asort",x1,x2)
cambia("myform:afile",x1,x2)
cambia("myform:ainvisible",x1,x2)
cambia("myform:aautoplay",x1,x2)
cambia("myform:acenter",x1,x2)
cambia("myform:acenteralign",x1,x2)
cambia("myform:atransparent",x1,x2)
cambia("myform:ashownone",x1,x2)
cambia("myform:aupdown",x1,x2)
cambia("myform:areadonly",x1,x2)
cambia("myform:avertical",x1,x2)
cambia("myform:asmooth",x1,x2)
cambia("myform:anoticks",x1,x2)
cambia("myform:aboth",x1,x2)
cambia("myform:atop",x1,x2)
cambia("myform:aleft",x1,x2)
cambia("myform:abreak",x1,x2)
cambia("myform:aitems",x1,x2)
cambia("myform:aitemsource",x1,x2)
cambia("myform:avaluesource",x1,x2)
cambia("myform:amultiselect",x1,x2)
cambia("myform:ahelpid",x1,x2)
cambia("myform:aspacing",x1,x2)
cambia("myform:aheaders",x1,x2)
cambia("myform:awidths",x1,x2)
cambia("myform:aonheadclick",x1,x2)
cambia("myform:anolines",x1,x2)
cambia("myform:aimage",x1,x2)
cambia("myform:astretch",x1,x2)
cambia("myform:aworkarea",x1,x2)
cambia("myform:afields",x1,x2)
cambia("myform:afield",x1,x2)
cambia("myform:avalid",x1,x2)
cambia("myform:awhen",x1,x2)
cambia("myform:avalidmess",x1,x2)
cambia("myform:areadonlyb",x1,x2)
cambia("myform:alock",x1,x2)
cambia("myform:adelete",x1,x2)
cambia("myform:ajustify",x1,x2)
cambia("myform:adate",x1,x2)
cambia("myform:aongotfocus",x1,x2)
cambia("myform:aonchange",x1,x2)
cambia("myform:aonlostfocus",x1,x2)
cambia("myform:aonenter",x1,x2)
cambia("myform:aondisplaychange",x1,x2)
cambia("myform:aondblclick",x1,x2)
cambia("myform:arightalign",x1,x2)
cambia("myform:anotoday",x1,x2)
cambia("myform:anotodaycircle",x1,x2)
cambia("myform:aweeknumbers",x1,x2)
cambia("myform:aaddress",x1,x2)
cambia("myform:ahandcursor",x1,x2)
////// aqui iria atab  pero esta mas abajo pq so varias lineas
cambia("myform:aname",x1,x2)
cambia("myform:anumber",x1,x2)
cambia("myform:aflat",x1,x2)
cambia("myform:abuttons",x1,x2)
cambia("myform:ahottrack",x1,x2)
cambia("myform:adisplayedit",x1,x2)
cambia("myform:anodeimages",x1,x2)
cambia("myform:aitemimages",x1,x2)
cambia("myform:anorootbutton",x1,x2)
cambia("myform:aitemids",x1,x2)
cambia("myform:anovscroll",x1,x2)
cambia("myform:anohscroll",x1,x2)
cambia("myform:adynamicbackcolor",x1,x2)
cambia("myform:adynamicforecolor",x1,x2)
cambia("myform:acolumncontrols",x1,x2)
cambia("myform:aoneditcell",x1,x2)
cambia("myform:aonappend",x1,x2)
cambia("myform:ainplace",x1,x2)
cambia("myform:aedit",x1,x2)
cambia("myform:aappend",x1,x2)
cambia("myform:aclientedge",x1,x2)
cambia("myform:afocusedpos",x1,x2)

cambia("myform:anumber",x1,x2)
cambia("myform:aspeed",x1,x2)


t83:=myform:atabpage[x1,1]  &&& nombre del TAB a que pertenece
t84:=myform:atabpage[x1,2]   &&& numero de la pagina
myform:atabpage[x1,1]:=  myform:atabpage[x2,1]
myform:atabpage[x1,2]:=  myform:atabpage[x2,2]
myform:atabpage[x2,1]:= t83
myform:atabpage[x2,2]:= t84

return nil

*-----------------------------
function cambia(arreglo,x1,x2)
*-----------------------------
local t
t:=&arreglo[x1]
&arreglo[x1]:=&arreglo[x2]
&arreglo[x2]:=t
return nil
