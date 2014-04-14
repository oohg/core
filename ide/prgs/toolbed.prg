#include "dbstruct.ch"
#include "oohg.ch"
#include "hbclass.ch"
#DEFINE CRLF CHR(13)+CHR(10)

declare window mytoolbared

CLASS Tmytoolbared FROM TFORM1
   
   VAR ctbname    INIT 'toolbar_1'
   VAR nwidth     INIT 65
   VAR nheight    INIT 65
   VAR ctooltip   INIT ''
   VAR lflat      INIT .F.
   VAR lbottom    INIT .F.
   VAR lrighttext INIT .F.
   VAR lborder    INIT .F.
   
   VAR cfont      INIT 'Arial'
   VAR nsize      INIT 10
   VAR litalic    INIT .F.
   VAR lbold      INIT .F.
   VAR lstrikeout INIT .F.
   VAR lunderline INIT .F.
   VAR ccolorr    INIT 0
   VAR ccolorg    INIT 0
   VAR ccolorb    INIT 0
   
   METHOD tb_ed()
   METHOD exittb()
   METHOD discard()
   METHOD abrir()
   METHOD borrar()
   METHOD nextm()
   METHOD escribe()
   METHOD escribe1()
   METHOD escribe1a()
   METHOD escribe1x()
   METHOD escribe1y()
   METHOD escribe1z()
   METHOD escribe2()
   METHOD escribe3a()
   METHOD escribet()
   METHOD escribe3b()
   METHOD readlevel()
   METHOD insertar()
   METHOD cursordown()
   METHOD cursorup()
   METHOD tbsave()
   METHOD leefont()
   
ENDCLASS


*-------------------------
METHOD tbsave() CLASS tmytoolbared
*-------------------------
//select dtoolbar
select 10
go 1
ctext1:=mytoolbared:text_1:value
ctext2:=str(mytoolbared:text_2:value , 4)
ctext3:=str(mytoolbared:text_3:value , 4)
ctext4:=mytoolbared:text_4:value
ccheck1:=iif(mytoolbared:checkbox_1:value,'.T.','.F.')
ccheck2:=iif(mytoolbared:checkbox_2:value,'.T.','.F.')
ccheck3:=iif(mytoolbared:checkbox_3:value,'.T.','.F.')
ccheck4:=iif(mytoolbared:checkbox_4:value,'.T.','.F.')

cfont:=tmytoolb:cfont
cnsize:=str(tmytoolb:nsize)
clitalic:=iif(tmytoolb:litalic,'.T.','.F.')
clbold:=iif(tmytoolb:lbold,'.T.','.F.')
clstrikeout:=iif(tmytoolb:lstrikeout,'.T.','.F.')
clunderline:=iif(tmytoolb:lunderline,'.T.','.F.')
ccolorr:=str(tmytoolb:ccolorr,3)
ccolorg:=str(tmytoolb:ccolorg,3)
ccolorb:=str(tmytoolb:ccolorb,3)
wdv:=' , '
/////msginfo( ctext1+wdv+ctext2+wdv+ctext3+wdv+ctext4+wdv+ccheck1+wdv+ccheck2+wdv+ccheck3+wdv+ccheck4+wdv+cfont+wdv+nsize+wdv+litalic+wdv+lbold+wdv+lstrikeout+wdv+lunderline+wdv+ccolorr+wdv+ccolorg+wdv+ccolorb)
replace auxit with  ctext1+wdv+ctext2+wdv+ctext3+wdv+ctext4+wdv+ccheck1+wdv+ccheck2+wdv+ccheck3+wdv+ccheck4+wdv+cfont+wdv+cnsize+wdv+clitalic+wdv+clbold+wdv+clstrikeout+wdv+clunderline+wdv+ccolorr+wdv+ccolorg+wdv+ccolorb
return nil

*-------------------------
METHOD tb_ed() CLASS Tmytoolbared
*-------------------------
local ctitulo:=''
local archivo:=''
tmytoolb:abrir()
zap
ctitulo:='Toolbar'
archivo:=myform:cfname+'.tbr'
if file(archivo)
   append from &archivo
endif
load window mytoolbared
mytoolbared.title:='ooHGIDE+ '+ctitulo+' editor'
mytoolbared:=getformobject("mytoolbared")
mytoolbared:backcolor:=myide:asystemcolor
mytoolbared:browse_101:value:=1
tbparsea()
ACTIVATE WINDOW mytoolbared
Return


*-------------------------
function tbparsea()
*-------------------------
local i,Apar:=array(17)
//select dtoolbar
select 10
afill(Apar,"")
go 1
wvar:=ltrim(auxit)
nposi:=1
nposf:=1
nind:=0
for i:=1 to len(wvar)
    if substr(wvar,i,1)=','
       nposf:=i
       nind++
       Apar[nind]:=ltrim(substr(wvar,nposi,nposf-nposi-1))
       nposi:=nposf+1
    endif
next i
Apar[17]:=substr(wvar,nposi,6)
///////////////////////////
if len(alltrim(apar[1]))>0
   tmytoolb:ctbname:=apar[1]
else
 tmytoolb:ctbname:='toolbar_1'
endif
////if iscontroldefined
if iscontroldefined(text_1,mytoolbared)
   mytoolbared.text_1.value:=tmytoolb:ctbname
endif

if len(alltrim(apar[2]))>0
   tmytoolb:nwidth:=val(apar[2])
else
   tmytoolb:nwidth:=65
endif
if iscontroldefined(text_2,mytoolbared)
  mytoolbared.text_2.value:=(tmytoolb:nwidth)
endif

if len(alltrim(apar[3]))>0
   tmytoolb:nheight:=val(apar[3])
else
   tmytoolb:nheight:=65
endif
if iscontroldefined(text_3,mytoolbared)
   mytoolbared:text_3:value:=(tmytoolb:nheight)
endif

tmytoolb:ctooltip:=apar[4]
if iscontroldefined(text_4,mytoolbared)
   mytoolbared:text_4:value:=tmytoolb:ctooltip
endif
////msgbox(apar[5])
if alltrim(apar[5])='.T.'
    tmytoolb:lflat:=.T.
else
    tmytoolb:lflat:=.F.
endif
if iscontroldefined(checkbox_1,mytoolbared)
   mytoolbared:checkbox_1:value:=tmytoolb:lflat
endif

if alltrim(apar[6])='.T.'
    tmytoolb:lbottom:=.T.
else
    tmytoolb:lbottom:=.F.
endif
if iscontroldefined(checkbox_2,mytoolbared)
   mytoolbared:checkbox_2:value:=tmytoolb:lbottom
endif

if alltrim(apar[7])='.T.'
    tmytoolb:lrighttext:=.T.
else
    tmytoolb:lrighttext:=.F.
endif
if iscontroldefined(checkbox_3,mytoolbared)
   mytoolbared:checkbox_3:value:=tmytoolb:lrighttext
endif


if alltrim(apar[8])='.T.'
    tmytoolb:lborder:=.T.
else
    tmytoolb:lborder:=.F.
endif
if iscontroldefined(checkbox_4,mytoolbared)
   mytoolbared:checkbox_4:value:=tmytoolb:lborder
else
////  use
endif


******
if len(ltrim(apar[9]))>0
    tmytoolb:cfont:=apar[9]
else
    tmytoolb:cfont:='Arial'
endif

if len(ltrim(apar[10]))>0
    tmytoolb:nsize:=val(apar[10])
else
    tmytoolb:nsize:=10
endif

if alltrim(apar[11])='.T.'
    tmytoolb:litalic:=.T.
else
    tmytoolb:litalic:=.F.
endif

if alltrim(apar[12])='.T.'
    tmytoolb:lbold:=.T.
else
    tmytoolb:lbold:=.F.
endif

if alltrim(apar[13])='.T.'
    tmytoolb:lstrikeout:=.T.
else
    tmytoolb:lstrikeout:=.F.
endif

if alltrim(apar[14])='.T.'
    tmytoolb:lunderline:=.T.
else
    tmytoolb:lunderline:=.F.
endif

if len(trim(apar[15]))>0
    tmytoolb:ccolorr:=val(apar[15])
else
    tmytoolb:ccolorr:=0
endif
if len(trim(apar[16]))>0
    tmytoolb:ccolorg:=val(apar[16])
else
    tmytoolb:ccolorg:=0
endif
if len(trim(apar[17]))>0
    tmytoolb:ccolorb:=val(apar[17])
else
    tmytoolb:ccolorb:=0
endif
return nil


*-------------------------
METHOD leefont() CLASS Tmytoolbared
*-------------------------
local afont,ccolor
//select dtoolbar
select 10
****iif(tmytoolb:lstrikeout='.T.',.T.,.F.)
ccolor:='{'+str(tmytoolb:ccolorr,3)+','+str(tmytoolb:ccolorg,3)+','+str(tmytoolb:ccolorb,3)+'}'
afont:=getfont(tmytoolb:cfont,(tmytoolb:nsize), tmytoolb:lbold,tmytoolb:litalic , &ccolor,tmytoolb:lunderline,tmytoolb:lstrikeout,0)
if afont[1]=""
   return nil
endif
tmytoolb:cfont:=Afont[1]
tmytoolb:nsize:=afont[2]
tmytoolb:lbold:=afont[3]
tmytoolb:litalic:=afont[4]
tmytoolb:ccolorr:=afont[5,1]
tmytoolb:ccolorg:=afont[5,2]
tmytoolb:ccolorb:=afont[5,3]
tmytoolb:lunderline:=afont[6]
tmytoolb:lstrikeout:=afont[7]
return nil


*-------------------------
METHOD exittb()  CLASS Tmytoolbared  &&&&&&& save and exit
*-------------------------
local nbuttons:=0,nw,nh,i
//select dtoolbar
select 10
count to nbuttons for .not. deleted()
if nbuttons>0
*******************
if len(trim(mytoolbared:text_1:value))=0
   msginfo('Toolbar must have a name','Information')
   return nil
endif
if mytoolbared:text_2:value<=0
   msginfo('Width must be grater than 0','Information')
   return nil
endif
if mytoolbared:text_3:value<=0
   msginfo('Height must be grater than 0','Information')
   return nil
endif
tmytoolb:tbsave()    &&&& una vez validados los graba
*******************
nw:=(tmytoolb:nwidth)
nh:=(tmytoolb:nheight)

if iscontroldefined(hmitb,form_1)
    release control hmitb of form_1     
endif
GO 1
DEFINE Toolbar hmitb of form_1  buttonsize nw , nh
      
      for i=1 to nbuttons
          cname:="hmi_cvc_tb_button_"+alltrim(str(i,2) )
          
          WCAPTION:= LTRIM(RTRIM(DTOOLBAR->ITEM))
          button &cname  ;
          caption WCAPTION  ;
          action NIL
          ****************************
          cvarchivo:=myform:cfname+'.'+alltrim(dtoolbar->named)+'.mnd'
          if file(cvarchivo)
             replace dtoolbar->drop with 'X'
          else
             replace dtoolbar->drop with ' '
          endif
          ****************************
          skip
      next i
END TOOLBAR
mytoolbared:release()
//inkey(0.9)
myform:lfsave:=.F.
//close data
use
archivo:=myform:cfname+'.tbr'
copy file dtoolbar.dbf to &archivo  ///////removido por problema en 98
/////close data
else
   if iscontroldefined(hmitb,form_1)
       release control hmitb of form_1
   endif
   mytoolbared:release()
   myform:lfsave:=.F.
   use	
   //close data
   archivo:=myform:cfname+'.tbr'
   if file (archivo)
      erase &archivo
   endif
endif
mispuntos()
return
   
*-------------------------
 METHOD discard() CLASS Tmytoolbared
*-------------------------
mytoolbared:release()
select 10
Use
mispuntos()
return
   

*-------------------------
   METHOD abrir() CLASS Tmytoolbared
*-------------------------
   local aDbf[11][4]
   aDbf[1][ DBS_NAME ] := "Auxit"
   aDbf[1][ DBS_TYPE ] := "Character"
   aDbf[1][ DBS_LEN ]  := 200
   aDbf[1][ DBS_DEC ]  := 0
   
   aDbf[2][ DBS_NAME ] := "Item"
   aDbf[2][ DBS_TYPE ] := "Character"
   aDbf[2][ DBS_LEN ]  := 80
   aDbf[2][ DBS_DEC ]  := 0
   
   aDbf[3][ DBS_NAME ] := "Named"
   aDbf[3][ DBS_TYPE ] := "Character"
   aDbf[3][ DBS_LEN ]  := 40
   aDbf[3][ DBS_DEC ]  := 0
   
   aDbf[4][ DBS_NAME ] := "Action"
   aDbf[4][ DBS_TYPE ] := "Character"
   aDbf[4][ DBS_LEN ]  := 250
   aDbf[4][ DBS_DEC ]  := 0
   
   aDbf[5][ DBS_NAME ] := "Check"
   aDbf[5][ DBS_TYPE ] := "Character"
   aDbf[5][ DBS_LEN ]  := 1
   aDbf[5][ DBS_DEC ]  := 0
   
   aDbf[6][ DBS_NAME ] := "Autosize"
   aDbf[6][ DBS_TYPE ] := "Character"
   aDbf[6][ DBS_LEN ]  := 1
   aDbf[6][ DBS_DEC ]  := 0
   
   aDbf[7][ DBS_NAME ] := "Image"
   aDbf[7][ DBS_TYPE ] := "Character"
   aDbf[7][ DBS_LEN ]  := 40
   aDbf[7][ DBS_DEC ]  := 0
   
   aDbf[8][ DBS_NAME ] := "Separator"
   aDbf[8][ DBS_TYPE ] := "Character"
   aDbf[8][ DBS_LEN ]  := 1
   aDbf[8][ DBS_DEC ]  := 0
   
   aDbf[9][ DBS_NAME ] := "Group"
   aDbf[9][ DBS_TYPE ] := "Character"
   aDbf[9][ DBS_LEN ]  := 1
   aDbf[9][ DBS_DEC ]  := 0

   aDbf[10][ DBS_NAME ] := "Drop"
   aDbf[10][ DBS_TYPE ] := "Character"
   aDbf[10][ DBS_LEN ]  := 1
   aDbf[10][ DBS_DEC ]  := 0


   aDbf[11][ DBS_NAME ] := "Tooltip"
   aDbf[11][ DBS_TYPE ] := "Character"
   aDbf[11][ DBS_LEN ]  := 80
   aDbf[11][ DBS_DEC ]  := 0

   //

   DBCREATE("dtoolbar", aDbf, "DBFNTX")
   select 10
   use dtoolbar exclusive alias dtoolbar
   Return
   

*-------------------------
   METHOD borrar() CLASS Tmytoolbared
*-------------------------
   local nx
   //select dtoolbar
   select 10
   mytoolbared:browse_101:setfocus()
   go mytoolbared:browse_101:value
   nx:=mytoolbared:browse_101:value
   delete
   //inkey(0.5)
   pack
   mytoolbared:browse_101:value:=1
   mytoolbared:browse_101:refresh()
   Return
   
*-------------------------
   METHOD nextm() CLASS Tmytoolbared
*-------------------------
   //select dtoolbar
   select 10
   append blank
   mytoolbared:browse_101:value:=reccount()
   mytoolbared:browse_101:refresh()
   ****mytoolbared:browse_101:setfocus()
   Return
   
*-------------------------
   METHOD escribe() CLASS Tmytoolbared
*-------------------------
   //select dtoolbar
	select 10
   go mytoolbared:browse_101:value
   replace item with ltrim(mytoolbared:text_101:value)

///   commit
   mytoolbared:browse_101:refresh()
   Return

   *-------------------------------------
  METHOD escribet() CLASS Tmytoolbared
  *--------------------------------------
   //select dtoolbar
	select 10
   go mytoolbared:browse_101:value
   replace tooltip with mytoolbared:text_5:value
   mytoolbared:browse_101:refresh()
   Return

*-------------------------
   METHOD escribe1() CLASS Tmytoolbared
*-------------------------
   //select dtoolbar
select 10
   go mytoolbared:browse_101:value
   replace named with mytoolbared:text_102:value
   mytoolbared:browse_101:refresh()
   Return


*-------------------------
   METHOD escribe1a() CLASS Tmytoolbared
*-------------------------
   //select dtoolbar
	select 10
   go mytoolbared:browse_101:value
   replace image with mytoolbared:text_103:value
   mytoolbared:browse_101:refresh()
   Return


*-------------------------
   METHOD escribe1x() CLASS Tmytoolbared
*-------------------------
   //select dtoolbar
   select 10
   go mytoolbared:browse_101:value
   replace action with mytoolbared:edit_101:value
   mytoolbared:browse_101:refresh()
   return


*-------------------------
   METHOD escribe1y() CLASS Tmytoolbared
*-------------------------
   //select dtoolbar
   select 10
   if len(trim(mytoolbared:text_102:value))=0 .and. mytoolbared:checkbox_101:value=.T.
      mytoolbared:checkbox_101:value:=.F.
      msginfo('You must define first a name for this item')
      return
   endif
   go mytoolbared:browse_101:value
   if mytoolbared:checkbox_101:value = .T.
      replace check with 'X'
   else
      replace check with ' '
   endif
   mytoolbared:browse_101:refresh()
   return



*-------------------------
   METHOD escribe1z() CLASS Tmytoolbared
*-------------------------
   //select dtoolbar
  select 10
   if len(trim(mytoolbared:text_102:value))=0 .and. mytoolbared:checkbox_102:value=.T.
      mytoolbared:checkbox_102:value:= .F.
      msginfo('You must define first a name for this item')
      return
   endif
   go mytoolbared:browse_101:value
   if mytoolbared:checkbox_102:value = .T.
      replace autosize with 'X'
   else
      replace autosize with ' '
   endif
///   commit
   mytoolbared:browse_101:refresh()
   return
   

*-------------------------
   METHOD escribe3a() CLASS Tmytoolbared
*-------------------------
   //select dtoolbar
  select 10
   if len(trim(mytoolbared:text_102:value))=0 .and. mytoolbared:checkbox_103:value=.T.
      mytoolbared:checkbox_103:value:= .F.
      msginfo('You must define first a name for this item')
      return
   endif
   go mytoolbared:browse_101:value
   if mytoolbared:checkbox_103:value = .T.
      replace separator with 'X'
   else
      replace separator with ' '
   endif

   mytoolbared:browse_101:refresh()
   return


*-------------------------
   METHOD escribe3b() CLASS Tmytoolbared
*-------------------------
   //select dtoolbar
   select 10
   if len(trim(mytoolbared:text_102:value))=0 .and. mytoolbared:checkbox_104:value=.T.
      mytoolbared:checkbox_104:value:= .F.
      msginfo('You must define first a name for this item')
      return
   endif
   go mytoolbared:browse_101:value
   if mytoolbared:checkbox_104:value = .T.
      replace group with 'X'
   else
      replace group with ' '
   endif

   mytoolbared:browse_101:refresh()
   return
   
   

*-------------------------
   METHOD escribe2() CLASS Tmytoolbared
*-------------------------
   //select dtoolbar
   select 10
   go mytoolbared:browse_101:value
   replace item with ltrim(item)

   mytoolbared:browse_101:refresh()
   Return
   
   

*-------------------------
   METHOD readlevel() CLASS Tmytoolbared
*-------------------------
   //select dtoolbar
   select 10
   go mytoolbared:browse_101:value
   ***tmytoolb:nlevel:= dtoolbar->level
   mytoolbared:text_101:value:=ltrim(dtoolbar->item)
   mytoolbared:text_102:value:=dtoolbar->named
   mytoolbared:edit_101:value:=dtoolbar->action
   mytoolbared:text_103:value:=dtoolbar->image
   mytoolbared:text_5:value:=dtoolbar->tooltip
   if dtoolbar->check='X'
      mytoolbared:checkbox_101:value:=.T.
   else
      mytoolbared:checkbox_101:value:=.F.
   endif
   if dtoolbar->autosize='X'
      mytoolbared:checkbox_102:value:=.T.
   else
      mytoolbared:checkbox_102:value:=.F.
   endif
   if dtoolbar->separator='X'
      mytoolbared:checkbox_103:value:=.T.
   else
      mytoolbared:checkbox_103:value:=.F.
   endif
   if dtoolbar->group='X'
      mytoolbared:checkbox_104:value:=.T.
   else
      mytoolbared:checkbox_104:value:=.F.
   endif
   Return
   
   

*-------------------------
   METHOD insertar() CLASS Tmytoolbared
*-------------------------
   local nregaux
   //select dtoolbar
   select 10
   mytoolbared:browse_101:setfocus()
   go mytoolbared:browse_101:value
   nregaux=recn()
   go bottom
   ********** insert record
   wwitem:=item
   wwname:=named
   wwaction:=action
   wwauxit:=auxit
   ***wwlevel:=level
   wwimage:=image
   wwtooltip:=tooltip
   append blank
   do while recn() > nregaux
      skip -1
      witem:=item
      wname:=named
      waction:=action
      wauxit:=auxit
      ***   wlevel:=level
      wimage:=image
      wtooltip:=tooltip
      skip
      replace item with witem
      replace named with wname
      replace action with waction
      replace auxit with wauxit
      replace image with wimage
      replace tooltip with wtooltip
      skip -1
   enddo
   replace item with ""
   replace named with ""
   replace action with ""
   replace auxit with ""
   replace image with ""
   replace tooltip with ""
   commit
   skip -1
   mytoolbared:browse_101:refresh()
   mytoolbared:text_101:value:=''
   mytoolbared:text_102:value:=''
   mytoolbared:text_103:value:=''
   mytoolbared:edit_101:value:=''
   Return
   
   

*-------------------------
   METHOD cursordown() CLASS Tmytoolbared
*-------------------------
   local nregaux,zq
   //select dtoolbar
   select 10
   nregaux=mytoolbared:browse_101:value
   if nregaux=reccount()
      playbeep()
      return nil
   endif
   go nregaux
   nregaux++
   ********** swap down record
   wwitem:=item
   wwname:=named
   wwaction:=action
   wwauxit:=auxit
   ***wwlevel:=level
   wwimage:=image
   wwautosize:=autosize
   wwcheck:=check
   wwseparator:=separator
   wwgroup:=group
   wwtooltip:=tooltip
   skip
   w2witem:=item
   w2wname:=named
   w2waction:=action
   w2wauxit:=auxit
   **w2wlevel:=level
   w2wimage:=image
   w2autosize:=autosize
   w2check:=check
   w2separator:=separator
   w2group:=group
   w2tooltip:=tooltip
   replace item with wwitem
   replace named with wwname
   replace action with wwaction
   replace auxit with wwauxit
   ***replace level with wwlevel
   replace image with wwimage
   replace autosize with wwautosize
   replace check  with wwcheck
   replace separator with wwseparator
   replace group     with wwgroup
   replace tooltip with wwtooltip
   skip -1
   replace item with w2witem
   replace named with w2wname
   replace action with w2waction
   replace auxit with w2wauxit
   ***replace level with w2wlevel
   replace image with w2wimage
   replace autosize with w2autosize
   replace check  with w2check
   replace separator with w2separator
   replace group     with w2group
   replace tooltip  with w2tooltip
   //commit
   zq:=mytoolbared:browse_101:value
   zq++
   mytoolbared:browse_101:value:=zq
   mytoolbared:browse_101:setfocus()
   mytoolbared:browse_101:refresh()
   Return
   
   

*-------------------------
   METHOD cursorup() CLASS Tmytoolbared
*-------------------------
   local nregaux,zq
   //select dtoolbar
   select 10
   nregaux=mytoolbared:browse_101:value
   if nregaux=1
      playbeep()
      return nil
   endif
   go nregaux
   nregaux--
   ********** swap down record
   wwitem:=item
   wwname:=named
   wwaction:=action
   wwauxit:=auxit
   ***wwlevel:=level
   wwimage:=image
   wwautosize:=autosize
   wwcheck:=check
   wwseparator:=separator
   wwgroup:=group
   wwtooltip:=tooltip
   skip-1
   w2witem:=item
   w2wname:=named
   w2waction:=action
   w2wauxit:=auxit
   **w2wlevel:=level
   w2wimage:=image
   w2autosize:=autosize
   w2check:=check
   w2separator:=separator
   w2group:=group
   w2tooltip:=tooltip
   replace item with wwitem
   replace named with wwname
   replace action with wwaction
   replace auxit with wwauxit
   ***replace level with wwlevel
   replace image with wwimage
   replace autosize with wwautosize
   replace check  with wwcheck
   replace separator with wwseparator
   replace group     with wwgroup
   replace tooltip   with wwtooltip
   skip
   replace item with w2witem
   replace named with w2wname
   replace action with w2waction
   replace auxit with w2wauxit
   ***replace level with w2wlevel
   replace image with w2wimage
   replace autosize with w2autosize
   replace check  with w2check
   replace separator with w2separator
   replace group     with w2group
   replace tooltip   with w2tooltip
   zq:=mytoolbared:browse_101:value
   zq--
   mytoolbared:browse_101:value:=zq
   mytoolbared:browse_101:setfocus()
   mytoolbared:browse_101:refresh()
   Return
   
   
   
   
   
   
   
   
   
