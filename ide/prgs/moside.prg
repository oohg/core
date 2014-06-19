/*
 * $Id: moside.prg,v 1.3 2014-06-19 18:53:30 fyurisich Exp $
 */

#include 'oohg.ch'
*** move / size / delete
*--------------------------------
function kmove( myIDe )  //// keyboard move
*--------------------------------
   if nhandlep=0
      msginfo("you must select a control first","information")
      return nil
   endif

   if myform:ncontrolw=1
      return nil
   endif
   swkm:=.T.
   declare window form_1
   /////erase window form_1
   ON KEY LEFT   OF Form_1 ACTION KMueve( "L", myIDe )
   ON KEY RIGHT  OF Form_1 ACTION KMueve( "R", myIDe )
   ON KEY UP     OF Form_1 ACTION KMueve( "U", myIDe )
   ON KEY DOWN   OF Form_1 ACTION KMueve( "D", myIDe )
   ON KEY ESCAPE OF Form_1 ACTION KMueve( "E", myIDe )


   if iscontroldefined(statusbar,form_1)
      form_1.statusbar.release()
   endif
   DEFINE STATUSBAR of form_1
        STATUSITEM ""
   END STATUSBAR
   kmueve( "", myIDe )
return nil

*------------------------
function kmueve( cpar, myIde )
*------------------------
local jj,nr,nc,ncaux,nraux,ocontrolm
if nhandlep=0
   ////dibuja1(jk)
   return nil
endif
jj:=nhandlep
ocontrolm:=getformobject("Form_1"):acontrols[jj]
cname:=ocontrolm:name
dibuja(cname)
h := GetFormHandle ( myform:designform )
BaseRow := GetWindowRow ( h ) + GetBorderHeight()
BaseCol := GetWindowCol ( h ) + GetBorderWidth()
nr:=ocontrolm:row +  baserow + gettitleheight()  + getborderheight() + 18
nc:=ocontrolm:col + basecol + (ocontrolm:width /2 )
SetCursorPos( nc , nr )

do case
  case cpar="L"
       form_1:&cname:col:= form_1:&cname:col  - iif(myIde:lsnap=1,10,1)
        myform:lfsave:=.F.
  case cpar="R"
       form_1:&cname:col:= form_1:&cname:col  + iif(myIde:lsnap=1,10,1)
        myform:lfsave:=.F.
  case cpar="U"
       form_1:&cname:row:= form_1:&cname:row - iif(myIde:lsnap=1,10,1)
       myform:lfsave:=.F.
  case cpar="D"
       form_1:&cname:row:= form_1:&cname:row  + iif(myIde:lsnap=1,10,1)
        myform:lfsave:=.F.
  case cpar="E"
     RELEASE KEY LEFT   OF Form_1
     RELEASE KEY RIGHT  OF Form_1
     RELEASE KEY UP     OF Form_1
     RELEASE KEY DOWN   OF Form_1
     RELEASE KEY ESCAPE OF Form_1
     swkm:=.F.
     form_1.statusbar.release
        if  myform:lsstat
            DEFINE STATUSBAR of form_1
            if len(myform:cscaption)> 0
               STATUSITEM myform:cscaption
            else
               statusitem ""
            endif
            if myform:lskeyboard
               KEYBOARD
            endif
            if myform:lsdate
               DATE WIDTH 90
            endif
            if myform:lstime
               CLOCK WIDTH 90
            endif
            END STATUSBAR
        endif
        if myIde:lsnap=1
           snap(cname)
        endif
endcase
if swkm
   form_1.statusbar.item(1):=" Row = "+str(form_1:&cname:row,4)+"  Col = "+str(form_1:&cname:col,4)+"  Use Arrow Keys to Move and [Esc] To Exit Keyboard Move"
endif
dibuja1(jj)
return nil

*---------------------
function snap(cname)
*---------------------
nrow:=form_1:&cname:row
ncol:=form_1:&cname:col
do while (nrow/10) # int(nrow/10)
   nrow--
enddo
do while (ncol/10) # int(ncol/10)
   ncol--
enddo
form_1:&cname:row:=nrow
form_1:&cname:col:=ncol
return nil

*------------------------------------------------------------------------------*
function MoveControl( myIde )
*------------------------------------------------------------------------------*
local i , iRow , iCol , iWidth , iHeight , h , j , k , l , z , eRow , eCol , dRow , dCol , BaseRow , BaseCol, BaseWidth , BaseHeight , TitleHeight , BorderWidth , BorderHeight  , CurrentPage , IsInTab , SupMin , iMin,cname,jk,jl
local ocontrol
declare window form_main

jk=nhandlep
if jk>0
   ocontrol:=getformobject('Form_1'):acontrols[jk]
   nRowAnterior := GetWindowRow( oControl:hWnd )
   ncolAnterior := GetWindowcol( oControl:hWnd )
   myinteractivemovehandle(ocontrol:hwnd)
   myform:lfsave:=.F.
   CHideControl (ocontrol:hwnd)

   nRowActual   := GetWindowRow( oControl:hWnd )
   ncolActual   := GetWindowcol( oControl:hWnd )
   oControl:Row := oControl:Row + ( nRowActual - nRowAnterior )
   oControl:col := oControl:col + ( ncolActual - ncolAnterior )

   if myIde:lsnap=1
      snap(ocontrol:name)
   endif
   CShowControl (ocontrol:hwnd)
   if ocontrol:type='TAB'
      form_1.hide
      form_1.show
   endif
   erase window form_1
   mispuntos()
   dibuja1(jk)
   return
else
   return
endif

Return

*------------------------------------------------------------------------------*
function SizeControl()
*------------------------------------------------------------------------------*
local i , iRow , iCol , iWidth , iHeight , eHeight , eWidth , j , k , z , Controlhandle , AbortSize := .f. , ControlIndex ,h , l , BaseRow , BaseCol ,BaseWidth , BaseHeight , TitleHeight , BorderWidth , BorderHeight , SupMin , iMin,jk,jl
local ocontrol
jk=nhandlep
if jk>0
   if siesdeste(jk,'MONTHCALENDAR') .or. siesdeste(jk,'TIMER')  .or. siesdeste(jk,'COMBO')
      return
   endif
   ocontrol:=getformobject('Form_1'):acontrols[jk]
   cname:=ocontrol:name
   nnheight:=ocontrol:height
   if siesdeste(jk,'COMBO')

   else
      interactivesizehandle( ocontrol:hwnd)
   endif
   ///CHideControl (ocontrol:hwnd)
   myform:lfsave:=.F.
   ////CShowControl (ocontrol:hwnd)
   if siesdeste(jk,'RADIOGROUP')
      ocontrol:width := GetWindowwidth ( ocontrol:hwnd )
      form_1:&cname:height:=nnheight
   else
         nheighta:= GetWindowHeight ( ocontrol:hwnd )
         nwidtha:= GetWindowwidth ( ocontrol:hwnd )
         ocontrol:Width := nwidtha
         ocontrol:Height := nheighta
   endif
   ////erase window form_1
   dibuja1(jk)
   return
else
   return
endif
Return

*-------------------------------
Function siesdeste(ih,ctype)   ////  (indice en oohg, tipo de control)
*-------------------------------
local i
IF HB_IsNumeric( ih ) .and. HB_IsString( ctype)
   if ih<=0
      return .f.
   endif
   cname:=getformobject("form_1"):acontrols[ih]:name
   for i:=1 to len(myform:acontrolw)
       if lower(cname) == lower(myform:acontrolw[i]) .and. lower(myform:actrltype[i]) == lower(ctype)
          return .T.
       endif
   next i
ENDIF
return .F.

*------------------------------------------------------------------------------*
function DeleteControl()
*------------------------------------------------------------------------------*
local ia,i , j , k , x , z , h , l , SupMin , iMin
local swf,jl,jk,ocontrol,jcvc
swf:=0
jl:=0
jk:=0
   if myform:ncontrolw=1
      return nil
   endif
ia := nhandlep
if ia > 0  .and. ! siesdeste(ia,'TAB')  &&&& si no es tab
   ocontrol:=getformobject('Form_1'):acontrols[ia]
   jcvc := ascan( myform:acontrolw, { |c| lower( c ) ==  lower(ocontrol:name)  } )
   if jcvc>1
      if .not. msgyesno('Are you sure delete control '+myform:aname[jcvc]+' ?','Question')
         return nil
      endif
     cname:=lower(ocontrol:name)
     form_1:&cname:release()
     myform:iniarray(myform:nform,jcvc,'','',.T.)
     ////////// ojo aqui adel
   endif
   myform:lFsave:=.F.
   erase window form_1
   cordenada()
   mispuntos()
   muestrasino()  //// rellena controles en lsitbox
   return
else                   &&&& si es tab
   if ia>0
      ocontrol:=getformobject('Form_1'):acontrols[ia]
      cname:=ocontrol:name
   else
      return nil
   endif
endif

if oControl:hwnd > 0
   if oControl:type=='MESSAGEBAR'
      return
   endif
   jk:= ascan( myform:acontrolw, { |c| lower( c ) ==  lower(ocontrol:name)  } )
   if jk>0
      cnamew:=myform:aname[jk]
      if .not. msgyesno('Are you sure delete control '+cnamew+' ?','Question')
         return nil
      endif

      if ocontrol:type='TAB'


 *************  si es un TAB
         cname:=lower(ocontrol:name)
         l:=myform:ncontrolw
         for j:=l to 1 step -1
             if lower(myform:atabpage[j,1])=cname
                 myform:iniarray(1,j,'','',.T.)
             endif
         next j

        myform:iniarray(myform:nform,jk,'','',.T.)
        form_1:&cname:release()
      else
       /////////// si no es TAB

       myform:iniarray(myform:nform,jk,'','',.T.)
       form_1:&cnamew:release()
      endif
    endif
***************
endif
myform:lFsave:=.F.
erase window form_1
mispuntos()
muestrasino()  //// rellena controles en listbox
return

*------------------------------
function manualmosi( nopcion, myIde )
*------------------------------
local i,cname,j, Title , aLabels , aInitValues , aFormats , aResults,ctipo
local ocontrol
****************
if myform:ncontrolw=1
   return nil
endif
if nopcion=1
                jl:=nhandlep
                if jl>0    ////////   .and. myform:swframe=1
                   ocontrol:=getformobject('Form_1'):acontrols[jl]
                   jk:=ascan(myform:acontrolw,{  |c| lower( c ) == lower(ocontrol:name)  } )
                   cname:=myform:acontrolw[jk]
                   cnamew:=myform:aname[jk]
                   ///if jk>0                 ///cambie jl por jk  no se q paso aqui
                        row   := form_1:&cname:row
                        col   := form_1:&cname:col
                        width := form_1:&cname:width
                        height:= form_1:&cname:height

                        Title:=cname+" Move/Size properties"
                           if siesdeste(jl,'RADIOGROUP')
                              aLabels         := { 'Row' ,'Col','Width' }
                         aInitValues     := { Row, col, width     }
                         aFormats        := { '9999','9999','9999'}
                              aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                              if aresults[1] == Nil
                            return
                              endif
                              if aresults[1] >0 .and. aresults[2]>0 .and. aresults[3]>0
                              ///   form_1.hide
                            form_1:&cname:row := aresults[1]
                                 form_1:&cname:col := aresults[2]
                                 form_1:&cname:width := aresults[3]
                              endif
                          ///    form_1.show
                           else
                              aLabels         := { 'Row' ,'Col','Width', 'Height' }
                         aInitValues     := { Row, col, width, height     }
                         aFormats        := { '9999','9999','9999','9999'}
                              aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                              if aresults[1] == Nil
                            return
                              endif
                              if aresults[1] >0 .and. aresults[2]>0 .and. aresults[3]>0 .and. aresults[4]>0
                            ///     form_1.hide
                            form_1:&cname:row := aresults[1]
                                 form_1:&cname:col := aresults[2]
                                 if siesdeste(jl,'MONTHCALENDAR') .or. siesdeste(jl,'TIMER')
                                 else
                                    form_1:&cname:width := aresults[3]
                                     form_1:&cname:height:= aresults[4]
                                 endif
                            //     form_1.show
                          endif
                           endif

                   //// endif
                   ///// erase window form_1
                    if myIde:lsnap=1
                       snap(cname)
                    endif

                    dibuja1(jl)
                    myform:lfsave:=.F.
                    return
                else
                    return
                endif
else
                nrow   := form_1.row
                ncol   := form_1.col
                nwidth := form_1.width
                nheight:= form_1.height


                Title:=" Form Move/Size properties"
                aLabels         := { 'Row' ,'Col','Width', 'Height' }
                aInitValues     := { nRow, ncol, nwidth, nheight     }
                aFormats        := { '9999','9999','9999','9999'}
                aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )

                if aresults[1] == Nil
                    return
                endif

              ///  form_1.hide

                form_1.row := aresults[1]
                form_1.col := aresults[2]
                form_1.width := aresults[3]
                form_1.height := aresults[4]

             ///   form_1.show

endif

Return

*--------------------------------------
function myinteractivemovehandle(handle)
*--------------------------------------
erase window form_1
mispuntos()
interactivemovehandle(handle)
////mispuntos()
return

********** chequeo para ver si es frame o no
*-----------------------
function chiffram()
*-----------------------
local i,cname,j,row,col,width,height,sw,fr,o,imin,supmin
sw:=0
****************************************

SupMin := 99999999
iMin := 0

w_ooHG_mouserow = _ooHG_mouserow  - getBorderHeight()
w_ooHG_mousecol = _ooHG_mousecol  - getBorderWidth()
************************
        for i:=1 to len(GetformObject( "Form_1" ):aControls)

         o:=GetformObject( "Form_1" ):aControls[i]
         if o:row=o:containerrow .and. o:col=o:containercol

         If ( w_ooHG_mouserow >= o:Row .and. w_ooHG_mouserow <= o:Row + o:height ;
         .and. w_ooHG_mousecol >= o:Col .and. w_ooHG_mousecol <= o:Col+ o:width ;
         .and. o:type == 'FRAME' .and. iswindowvisible(o:hwnd) )

              if supMin > o:height * o:width
                 SupMin := o:height * o:width
                 iMin := i
              EndIf
         endif
         else
         If ( w_ooHG_mouserow >= o:containerRow .and. w_ooHG_mouserow <= o:containerRow + o:height ;
         .and. w_ooHG_mousecol >= o:containerCol .and. w_ooHG_mousecol <= o:containerCol+ o:width ;
         .and. o:type == 'FRAME' .and. iswindowvisible(o:hwnd) )

              if supMin > o:height * o:width
                 SupMin := o:height * o:width
                 iMin := i
              EndIf
         endif
         endif
         next i
         If iMin != 0
            i := iMin
            return i
         EndIf
return 0
