/*
 * $Id: toolbed.prg,v 1.5 2014-07-17 02:59:37 fyurisich Exp $
 */

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
   VAR Backcolor INIT Nil
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
   METHOD Close()

ENDCLASS


*-------------------------
METHOD tbsave() CLASS tmytoolbared
*-------------------------
//select dtoolbar
select 10
go 1
ctext1:=myToolbarEd.text_1.value
ctext2:=str(myToolbarEd.text_2.value , 4)
ctext3:=str(myToolbarEd.text_3.value , 4)
ctext4:=myToolbarEd.text_4.value
ccheck1:=iif(myToolbarEd.checkbox_1.value,'.T.','.F.')
ccheck2:=iif(myToolbarEd.checkbox_2.value,'.T.','.F.')
ccheck3:=iif(myToolbarEd.checkbox_3.value,'.T.','.F.')
ccheck4:=iif(myToolbarEd.checkbox_4.value,'.T.','.F.')

cfont := ::cfont
cnsize:=str(::nsize)
clitalic:=iif(::litalic,'.T.','.F.')
clbold:=iif(::lbold,'.T.','.F.')
clstrikeout:=iif(::lstrikeout,'.T.','.F.')
clunderline:=iif(::lunderline,'.T.','.F.')
ccolorr:=str(::ccolorr,3)
ccolorg:=str(::ccolorg,3)
ccolorb:=str(::ccolorb,3)
wdv:=' , '
/////msginfo( ctext1+wdv+ctext2+wdv+ctext3+wdv+ctext4+wdv+ccheck1+wdv+ccheck2+wdv+ccheck3+wdv+ccheck4+wdv+cfont+wdv+nsize+wdv+litalic+wdv+lbold+wdv+lstrikeout+wdv+lunderline+wdv+ccolorr+wdv+ccolorg+wdv+ccolorb)
replace auxit with  ctext1+wdv+ctext2+wdv+ctext3+wdv+ctext4+wdv+ccheck1+wdv+ccheck2+wdv+ccheck3+wdv+ccheck4+wdv+cfont+wdv+cnsize+wdv+clitalic+wdv+clbold+wdv+clstrikeout+wdv+clunderline+wdv+ccolorr+wdv+ccolorg+wdv+ccolorb
return nil

//------------------------------------------------------------------------------
METHOD tb_ed() CLASS Tmytoolbared
//------------------------------------------------------------------------------
Local ctitulo := '', archivo := ''
   ::abrir()
   ZAP
   cTitulo := 'Toolbar'
   archivo := myform:cfname + '.tbr'
   If File( archivo )
      APPEND FROM &archivo
   EndIf
   LOAD WINDOW mytoolbared
   mytoolbared.title := 'ooHG IDE+ ' + ctitulo + ' editor'
   myToolbarEd.backcolor := ::Backcolor
   myToolbarEd.browse_101.value := 1
   tbparsea( Self )
   ACTIVATE WINDOW mytoolbared
Return Nil


*-------------------------
function tbparsea( tMyToolb )
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
   tMyToolb:ctbname:=apar[1]
else
 tMyToolb:ctbname:='toolbar_1'
endif
////if iscontroldefined
if iscontroldefined(text_1,mytoolbared)
   mytoolbared.text_1.value:=tMyToolb:ctbname
endif

if len(alltrim(apar[2]))>0
   tMyToolb:nwidth:=val(apar[2])
else
   tMyToolb:nwidth:=65
endif
if iscontroldefined(text_2,mytoolbared)
  mytoolbared.text_2.value:=(tMyToolb:nwidth)
endif

if len(alltrim(apar[3]))>0
   tMyToolb:nheight:=val(apar[3])
else
   tMyToolb:nheight:=65
endif
if iscontroldefined(text_3,mytoolbared)
   myToolbarEd.text_3.value:=(tMyToolb:nheight)
endif

tMyToolb:ctooltip:=apar[4]
if iscontroldefined(text_4,mytoolbared)
   myToolbarEd.text_4.value:=tMyToolb:ctooltip
endif
////msgbox(apar[5])
if alltrim(apar[5])='.T.'
    tMyToolb:lflat:=.T.
else
    tMyToolb:lflat:=.F.
endif
if iscontroldefined(checkbox_1,mytoolbared)
   myToolbarEd.checkbox_1.value:=tMyToolb:lflat
endif

if alltrim(apar[6])='.T.'
    tMyToolb:lbottom:=.T.
else
    tMyToolb:lbottom:=.F.
endif
if iscontroldefined(checkbox_2,mytoolbared)
   myToolbarEd.checkbox_2.value:=tMyToolb:lbottom
endif

if alltrim(apar[7])='.T.'
    tMyToolb:lrighttext:=.T.
else
    tMyToolb:lrighttext:=.F.
endif
if iscontroldefined(checkbox_3,mytoolbared)
   myToolbarEd.checkbox_3.value:=tMyToolb:lrighttext
endif


if alltrim(apar[8])='.T.'
    tMyToolb:lborder:=.T.
else
    tMyToolb:lborder:=.F.
endif
if iscontroldefined(checkbox_4,mytoolbared)
   myToolbarEd.checkbox_4.value:=tMyToolb:lborder
else
////  use
endif


******
if len(ltrim(apar[9]))>0
    tMyToolb:cfont:=apar[9]
else
    tMyToolb:cfont:='Arial'
endif

if len(ltrim(apar[10]))>0
    tMyToolb:nsize:=val(apar[10])
else
    tMyToolb:nsize:=10
endif

if alltrim(apar[11])='.T.'
    tMyToolb:litalic:=.T.
else
    tMyToolb:litalic:=.F.
endif

if alltrim(apar[12])='.T.'
    tMyToolb:lbold:=.T.
else
    tMyToolb:lbold:=.F.
endif

if alltrim(apar[13])='.T.'
    tMyToolb:lstrikeout:=.T.
else
    tMyToolb:lstrikeout:=.F.
endif

if alltrim(apar[14])='.T.'
    tMyToolb:lunderline:=.T.
else
    tMyToolb:lunderline:=.F.
endif

if len(trim(apar[15]))>0
    tMyToolb:ccolorr:=val(apar[15])
else
    tMyToolb:ccolorr:=0
endif
if len(trim(apar[16]))>0
    tMyToolb:ccolorg:=val(apar[16])
else
    tMyToolb:ccolorg:=0
endif
if len(trim(apar[17]))>0
    tMyToolb:ccolorb:=val(apar[17])
else
    tMyToolb:ccolorb:=0
endif
return nil


*-------------------------
METHOD leefont() CLASS Tmytoolbared
*-------------------------
local afont,ccolor
//select dtoolbar
select 10
****iif(::lstrikeout='.T.',.T.,.F.)
ccolor:='{'+str(::ccolorr,3)+','+str(::ccolorg,3)+','+str(::ccolorb,3)+'}'
afont:=getfont(::cfont,(::nsize), ::lbold,::litalic , &ccolor,::lunderline,::lstrikeout,0)
if afont[1]=""
   return nil
endif
::cfont:=Afont[1]
::nsize:=afont[2]
::lbold:=afont[3]
::litalic:=afont[4]
::ccolorr:=afont[5,1]
::ccolorg:=afont[5,2]
::ccolorb:=afont[5,3]
::lunderline:=afont[6]
::lstrikeout:=afont[7]
return nil


*-------------------------
METHOD exittb()  CLASS Tmytoolbared  &&&&&&& save and exit
*-------------------------
local nbuttons:=0,nw,nh,i, lDeleted

   //select dtoolbar
   select 10
   count to nbuttons for .not. deleted()
   if nbuttons > 0
      if len( trim( myToolbarEd.text_1.value ) ) = 0
         msginfo( 'Toolbar must have a name', 'OOHG IDE+' )
         return nil
      endif
      if myToolbarEd.text_2.value <= 0
         msginfo( 'Width must be grater than 0', 'OOHG IDE+' )
         return nil
      endif
      if myToolbarEd.text_3.value <= 0
         msginfo( 'Height must be grater than 0', 'OOHG IDE+' )
         return nil
      endif
      ::tbsave()    &&&& una vez validados los graba
      nw:=(::nwidth)
      nh:=(::nheight)

      if iscontroldefined( hmitb, form_1)
         release control hmitb of form_1
      endif
      lDeleted := SET( _SET_DELETED, .T. )
      GO 1
      DEFINE Toolbar hmitb of form_1 buttonsize nw, nh
         for i := 1 to nbuttons
            cname := "hmi_cvc_tb_button_" + alltrim( str( i, 2 ) )
            WCAPTION := LTRIM( RTRIM( DTOOLBAR->ITEM ) )
            button &cname ;
            caption WCAPTION ;
            action NIL
            cvarchivo := myform:cfname + '.' + alltrim( dtoolbar->named ) + '.mnd'
            if file( cvarchivo )
               replace dtoolbar->drop with 'X'
            else
               replace dtoolbar->drop with ' '
            endif
            skip
         next i
      END TOOLBAR
      myToolbarEd.release()
      myform:lfsave := .F.
      use
      SET( _SET_DELETED, lDeleted )
      archivo := myform:cfname + '.tbr'
      copy file dtoolbar.dbf to &archivo
   else
      if iscontroldefined( hmitb, form_1 )
         release control hmitb of form_1
      endif
      myToolbarEd.release()
      myform:lfsave:=.F.
      use
      archivo := myform:cfname + '.tbr'
      if file( archivo )
         erase &archivo
      endif
   endif
   MisPuntos()
return

*-------------------------
 METHOD Discard() CLASS Tmytoolbared
*-------------------------
   myToolbarEd.Release()
   ::Close()
   MisPuntos()
RETURN NIL

*-------------------------
 METHOD Close() CLASS Tmytoolbared
*-------------------------
   SELECT 10
   USE
   IF File( "dtoolbar.dbf" )
      ERASE dtoolbar.dbf
   ENDIF
RETURN NIL

*-------------------------
METHOD Abrir() CLASS Tmytoolbared
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
   myToolbarEd.browse_101.setfocus()
   go myToolbarEd.browse_101.value
   nx:=myToolbarEd.browse_101.value
   delete
   //inkey(0.5)
   pack
   myToolbarEd.browse_101.value:=1
   myToolbarEd.browse_101.refresh()
   Return

*-------------------------
   METHOD nextm() CLASS Tmytoolbared
*-------------------------
   //select dtoolbar
   select 10
   append blank
   myToolbarEd.browse_101.value:=reccount()
   myToolbarEd.browse_101.refresh()
   ****myToolbarEd.browse_101.setfocus()
   Return

*-------------------------
   METHOD escribe() CLASS Tmytoolbared
*-------------------------
   //select dtoolbar
   select 10
   go myToolbarEd.browse_101.value
   replace item with ltrim(myToolbarEd.text_101.value)

///   commit
   myToolbarEd.browse_101.refresh()
   Return

   *-------------------------------------
  METHOD escribet() CLASS Tmytoolbared
  *--------------------------------------
   //select dtoolbar
   select 10
   go myToolbarEd.browse_101.value
   replace tooltip with myToolbarEd.text_5.value
   myToolbarEd.browse_101.refresh()
   Return

*-------------------------
   METHOD escribe1() CLASS Tmytoolbared
*-------------------------
   //select dtoolbar
select 10
   go myToolbarEd.browse_101.value
   replace named with myToolbarEd.text_102.value
   myToolbarEd.browse_101.refresh()
   Return


*-------------------------
   METHOD escribe1a() CLASS Tmytoolbared
*-------------------------
   //select dtoolbar
   select 10
   go myToolbarEd.browse_101.value
   replace image with myToolbarEd.text_103.value
   myToolbarEd.browse_101.refresh()
   Return


*-------------------------
   METHOD escribe1x() CLASS Tmytoolbared
*-------------------------
   //select dtoolbar
   select 10
   go myToolbarEd.browse_101.value
   replace action with myToolbarEd.edit_101.value
   myToolbarEd.browse_101.refresh()
   return


*-------------------------
   METHOD escribe1y() CLASS Tmytoolbared
*-------------------------
   //select dtoolbar
   select 10
   if len(trim(myToolbarEd.text_102.value))=0 .and. myToolbarEd.checkbox_101.value=.T.
      myToolbarEd.checkbox_101.value:=.F.
      msginfo('You must define first a name for this item')
      return
   endif
   go myToolbarEd.browse_101.value
   if myToolbarEd.checkbox_101.value = .T.
      replace check with 'X'
   else
      replace check with ' '
   endif
   myToolbarEd.browse_101.refresh()
   return



*-------------------------
   METHOD escribe1z() CLASS Tmytoolbared
*-------------------------
   //select dtoolbar
  select 10
   if len(trim(myToolbarEd.text_102.value))=0 .and. myToolbarEd.checkbox_102.value=.T.
      myToolbarEd.checkbox_102.value:= .F.
      msginfo('You must define first a name for this item')
      return
   endif
   go myToolbarEd.browse_101.value
   if myToolbarEd.checkbox_102.value = .T.
      replace autosize with 'X'
   else
      replace autosize with ' '
   endif
///   commit
   myToolbarEd.browse_101.refresh()
   return


*-------------------------
   METHOD escribe3a() CLASS Tmytoolbared
*-------------------------
   //select dtoolbar
  select 10
   if len(trim(myToolbarEd.text_102.value))=0 .and. myToolbarEd.checkbox_103.value=.T.
      myToolbarEd.checkbox_103.value:= .F.
      msginfo('You must define first a name for this item')
      return
   endif
   go myToolbarEd.browse_101.value
   if myToolbarEd.checkbox_103.value = .T.
      replace separator with 'X'
   else
      replace separator with ' '
   endif

   myToolbarEd.browse_101.refresh()
   return


*-------------------------
   METHOD escribe3b() CLASS Tmytoolbared
*-------------------------
   //select dtoolbar
   select 10
   if len(trim(myToolbarEd.text_102.value))=0 .and. myToolbarEd.checkbox_104.value=.T.
      myToolbarEd.checkbox_104.value:= .F.
      msginfo('You must define first a name for this item')
      return
   endif
   go myToolbarEd.browse_101.value
   if myToolbarEd.checkbox_104.value = .T.
      replace group with 'X'
   else
      replace group with ' '
   endif

   myToolbarEd.browse_101.refresh()
   return



*-------------------------
   METHOD escribe2() CLASS Tmytoolbared
*-------------------------
   //select dtoolbar
   select 10
   go myToolbarEd.browse_101.value
   replace item with ltrim(item)

   myToolbarEd.browse_101.refresh()
   Return



*-------------------------
   METHOD readlevel() CLASS Tmytoolbared
*-------------------------
   //select dtoolbar
   select 10
   go myToolbarEd.browse_101.value
   ***::nlevel:= dtoolbar->level
   myToolbarEd.text_101.value:=ltrim(dtoolbar->item)
   myToolbarEd.text_102.value:=dtoolbar->named
   myToolbarEd.edit_101.value:=dtoolbar->action
   myToolbarEd.text_103.value:=dtoolbar->image
   myToolbarEd.text_5.value:=dtoolbar->tooltip
   if dtoolbar->check='X'
      myToolbarEd.checkbox_101.value:=.T.
   else
      myToolbarEd.checkbox_101.value:=.F.
   endif
   if dtoolbar->autosize='X'
      myToolbarEd.checkbox_102.value:=.T.
   else
      myToolbarEd.checkbox_102.value:=.F.
   endif
   if dtoolbar->separator='X'
      myToolbarEd.checkbox_103.value:=.T.
   else
      myToolbarEd.checkbox_103.value:=.F.
   endif
   if dtoolbar->group='X'
      myToolbarEd.checkbox_104.value:=.T.
   else
      myToolbarEd.checkbox_104.value:=.F.
   endif
   Return



*-------------------------
   METHOD insertar() CLASS Tmytoolbared
*-------------------------
   local nregaux
   //select dtoolbar
   select 10
   myToolbarEd.browse_101.setfocus()
   go myToolbarEd.browse_101.value
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
   myToolbarEd.browse_101.refresh()
   myToolbarEd.text_101.value:=''
   myToolbarEd.text_102.value:=''
   myToolbarEd.text_103.value:=''
   myToolbarEd.edit_101.value:=''
   Return



*-------------------------
   METHOD cursordown() CLASS Tmytoolbared
*-------------------------
   local nregaux,zq
   //select dtoolbar
   select 10
   nregaux=myToolbarEd.browse_101.value
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
   zq:=myToolbarEd.browse_101.value
   zq++
   myToolbarEd.browse_101.value:=zq
   myToolbarEd.browse_101.setfocus()
   myToolbarEd.browse_101.refresh()
   Return



*-------------------------
   METHOD cursorup() CLASS Tmytoolbared
*-------------------------
   local nregaux,zq
   //select dtoolbar
   select 10
   nregaux=myToolbarEd.browse_101.value
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
   zq:=myToolbarEd.browse_101.value
   zq--
   myToolbarEd.browse_101.value:=zq
   myToolbarEd.browse_101.setfocus()
   myToolbarEd.browse_101.refresh()
   Return
