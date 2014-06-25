/*
 * $Id: menued.prg,v 1.5 2014-06-25 20:11:58 fyurisich Exp $
 */

#include "dbstruct.ch"
#include "oohg.ch"
#include "hbclass.ch"

#define CRLF CHR(13) + CHR(10)

DECLARE WINDOW myMenuEd

CLASS TmyMenuEd FROM TForm1
   VAR nlevel      INIT 0
   VAR cfBackcolor INIT Nil

   METHOD menu_ed( ntipo )
   METHOD exitmenu( ntipo)
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
   METHOD readlevel()
   METHOD insertar()
   METHOD cursordown()
   METHOD cursorup()
ENDCLASS

*-----------------------------------------------
METHOD menu_ed( nTipo, cButton ) CLASS TMYMENUED
*-----------------------------------------------
Local cTitulo := '', cArchivo := ''

   ::Abrir()
   ZAP

   DO CASE
   CASE nTipo == 1
      cTitulo := 'Main'
      cArchivo := myForm:cFName + '.mnm'
      IF File( cArchivo )
         APPEND FROM &cArchivo
      ENDIF
   CASE nTipo == 2
      cTitulo := 'Context'
      cArchivo := myForm:cFName + '.mnc'
      IF File( cArchivo )
         APPEND FROM &cArchivo
      ENDIF
   CASE nTipo == 3
      cTitulo := 'Notify'
      cArchivo := myForm:cFName + '.mnn'
      IF File( cArchivo )
         APPEND FROM &cArchivo
      ENDIF
   CASE nTipo == 4
      cTitulo := 'Drop Down'
      cArchivo := myForm:cFName + '.' + AllTrim( cButton ) + '.mnd'
      IF File( cArchivo )
         APPEND FROM &cArchivo
      ENDIF
   ENDCASE

   GO TOP

   LOAD WINDOW myMenuEd
   myMenuEd.BackColor := myIde:aSystemColor
   myMenuEd.browse_101.Value := 1
   IF nTipo > 1
      myMenuEd.button_104.Enabled := .F.
      myMenuEd.button_105.Enabled := .F.
   ENDIF
   myMenuEd.Title := 'ooHG IDE+ ' + cTitulo + ' menu editor'

   ACTIVATE WINDOW myMenuEd
RETURN NIL

/*
*-------------------------
static function entlev()
*-------------------------
go myMenuEd.browse_101.value
cdata:=alltrim(menues->lev)
cnivelu:=inputbox('Data','User level',cdata)
if len(cnivelu)>0
   replace menues->lev with cnivelu
endif
return
*/
*------------------------------------------------------
METHOD exitmenu( ntipo,cbutton )  CLASS TMYMENUED  &&&&&&& save and exit
*------------------------------------------------------
select menues
go top

count to nregs for .not. deleted()
define main menu of form_1
end menu
swpop:=0
if ntipo=1 .and. nregs>0
   go top
   DEFINE MAIN MENU of form_1
   do while .not. eof()
      if recn() < reccount()
         skip
         signiv:=level
         skip -1
      else
         signiv=0
      endif
      niv=level
      if signiv>level
         if lower(trim(auxit))='separator'
            SEPARATOR
         else
            POPUP alltrim(auxit)
            swpop++
         endif
      else
         if lower(trim(auxit))='separator'
            SEPARATOR
         else
            ITEM  alltrim(auxit)  ACTION  NIL
            if trim(named)==''
            else
               if menues->checked='X'
               endif
               if menues->enabled='X'
               endif
            endif
         endif
**********************************
         do while signiv<niv
            END POPUP
            swpop--
            niv--
         enddo
      endif
      skip
   enddo
   nnivaux:=niv-1
   do while swpop>0
      nnivaux--
      END POPUP
      swpop--
   enddo

   END MENU
endif
/////use
myMenuEd.release()
inkey(0.9)
CLOSE DATABASES
if ntipo=1
   archivo:=myform:cfname+'.mnm'
   copy file menues.dbf to &archivo
endif
if ntipo=2
   archivo:=myform:cfname+'.mnc'
   copy file menues.dbf to &archivo
endif
if ntipo=3
   archivo:=myform:cfname+'.mnn'
   copy file menues.dbf to &archivo
endif
if ntipo=4
   archivo:=myform:cfname+'.'+alltrim(cbutton)+'.mnd'
   copy file menues.dbf to &archivo
   if nregs=0
      erase &archivo
   endif
endif
myform:lfsave:=.F.
mispuntos()
return
*--------------------------------
METHOD discard() CLASS TMYMENUED
*--------------------------------
select menues
myMenuEd.release()
inkey(0.9)
close data
mispuntos()
return

*--------------------------------
METHOD abrir() CLASS TMYMENUED
*--------------------------------
local aDbf[9][10]
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

 aDbf[5][ DBS_NAME ] := "Level"
 aDbf[5][ DBS_TYPE ] := "numeric"
 aDbf[5][ DBS_LEN ]  := 1
 aDbf[5][ DBS_DEC ]  := 0

 aDbf[6][ DBS_NAME ] := "Checked"
 aDbf[6][ DBS_TYPE ] := "Character"
 aDbf[6][ DBS_LEN ]  := 1
 aDbf[6][ DBS_DEC ]  := 0

 aDbf[7][ DBS_NAME ] := "Enabled"
 aDbf[7][ DBS_TYPE ] := "Character"
 aDbf[7][ DBS_LEN ]  := 1
 aDbf[7][ DBS_DEC ]  := 0

 aDbf[8][ DBS_NAME ] := "Lev"
 aDbf[8][ DBS_TYPE ] := "Character"
 aDbf[8][ DBS_LEN ]  := 1
 aDbf[8][ DBS_DEC ]  := 0

 aDbf[9][ DBS_NAME ] := "Image"
 aDbf[9][ DBS_TYPE ] := "Character"
 aDbf[9][ DBS_LEN ]  := 40
 aDbf[9][ DBS_DEC ]  := 0

// aDbf[10][ DBS_NAME ] := "codigomenu"
/// aDbf[10][ DBS_TYPE ] := "Character"
/// aDbf[10][ DBS_LEN ]  := 8
/// aDbf[10][ DBS_DEC ]  := 0

/// aDbf[11][ DBS_NAME ] := "menus"
/// aDbf[11][ DBS_TYPE ] := "Character"
// aDbf[11][ DBS_LEN ]  := 40
// aDbf[11][ DBS_DEC ]  := 0

/// aDbf[12][ DBS_NAME ] := "nivel"
/// aDbf[12][ DBS_TYPE ] := "Character"
/// aDbf[12][ DBS_LEN ]  := 10
/// aDbf[12][ DBS_DEC ]  := 0

/// aDbf[13][ DBS_NAME ] := "nivelu"
/// aDbf[13][ DBS_TYPE ] := "Character"
/// aDbf[13][ DBS_LEN ]  := 1
/// aDbf[13][ DBS_DEC ]  := 0






 DBCREATE("menues", aDbf, "DBFNTX")
 select 20
 use menues exclusive
Return

*-------------------------------
METHOD borrar() CLASS TMYMENUED
*-------------------------------
   select menues
   go myMenuEd.browse_101.value
   delete
   pack
   myMenuEd.browse_101.value := 1
   myMenuEd.browse_101.refresh()
   myMenuEd.browse_101.setfocus()
Return

*------------------------------
METHOD nextm() CLASS TMYMENUED
*------------------------------
select menues
///msgbox(1)
append blank
//automsgbox(2)
myMenuEd.browse_101.value:=reccount()
///automsgbox(3)
myMenuEd.browse_101.refresh()
Return

*--------------------------------
METHOD escribe() CLASS TMYMENUED
*--------------------------------
select menues
go myMenuEd.browse_101.value
replace item with space(::nlevel*3)+ltrim(myMenuEd.text_101.value)
replace auxit with ltrim(myMenuEd.text_101.value)

myMenuEd.browse_101.refresh()
Return
*---------------------------------
METHOD escribe1() CLASS TMYMENUED
*---------------------------------
select menues
go myMenuEd.browse_101.value
replace named with myMenuEd.text_102.value

myMenuEd.browse_101.refresh()
Return

*----------------------------------
METHOD escribe1a() CLASS TMYMENUED
*----------------------------------
select menues
go myMenuEd.browse_101.value
replace image with myMenuEd.text_103.value

myMenuEd.browse_101.refresh()
Return

*----------------------------------
METHOD escribe1x() CLASS TMYMENUED
*----------------------------------
select menues
go myMenuEd.browse_101.value
replace action with myMenuEd.edit_101.value

myMenuEd.browse_101.refresh()
return
*----------------------------------
METHOD escribe1y() CLASS TMYMENUED
*----------------------------------
select menues
if len(trim(myMenuEd.text_102.value))=0 .and. myMenuEd.checkbox_101.value=.T.
   myMenuEd.checkbox_101.value:=.F.
   msginfo('You must define first a name for this item')
   return
endif
go myMenuEd.browse_101.value
if myMenuEd.checkbox_101.value = .T.
   replace checked with 'X'
else
   replace checked with ' '
endif

myMenuEd.browse_101.refresh()
return

*-----------------------------------
METHOD escribe1z() CLASS TMYMENUED
*-----------------------------------
select menues
if len(trim(myMenuEd.text_102.value))=0 .and. myMenuEd.checkbox_102.value=.T.
   myMenuEd.checkbox_102.value:= .F.
   msginfo('You must define first a name for this item')
   return
endif
go myMenuEd.browse_101.value
if myMenuEd.checkbox_102.value = .T.
   replace enabled with 'X'
else
   replace enabled with ' '
endif

myMenuEd.browse_101.refresh()
return

*----------------------------------
METHOD escribe2() CLASS TMYMENUED
*----------------------------------
select menues
go myMenuEd.browse_101.value
replace item with space(::nlevel*3)+ltrim(item)
replace level with ::nlevel

myMenuEd.browse_101.refresh()
Return

*----------------------------------
METHOD readlevel() CLASS TMYMENUED
*----------------------------------
select menues
go myMenuEd.browse_101.value
::nlevel:= menues->level
myMenuEd.text_101.value:=ltrim(menues->item)
myMenuEd.text_102.value:=menues->named
myMenuEd.edit_101.value:=menues->action
myMenuEd.text_103.value:=menues->image
if menues->checked='X'
   myMenuEd.checkbox_101.value:=.T.
else
   myMenuEd.checkbox_101.value:=.F.
endif
if menues->enabled='X'
   myMenuEd.checkbox_102.value:=.T.
else
   myMenuEd.checkbox_102.value:=.F.
endif
Return

*---------------------------------
METHOD insertar() CLASS TMYMENUED
*---------------------------------
local nregaux
select menues
myMenuEd.browse_101.setfocus()
go myMenuEd.browse_101.value
nregaux=recn()
go bottom
********** insert record
append blank
do while recn() > nregaux
   skip -1
   witem:=item
   wname:=named
   waction:=action
   wauxit:=auxit
   wlevel:=level
   wimage:=image
   wlev:=lev
   skip
   replace item with witem
   replace named with wname
   replace action with waction
   replace auxit with wauxit
   replace level with wlevel
   replace image with wimage
   replace lev with wlev
   skip -1
enddo
replace item with ""
replace named with ""
replace action with ""
replace auxit with ""
replace level with ::nlevel
replace image with ""
replace lev   with ""

skip -1
myMenuEd.browse_101.refresh()
myMenuEd.text_101.value:=''
myMenuEd.text_102.value:=''
myMenuEd.text_103.value:=''
myMenuEd.edit_101.value:=''
Return

*-----------------------------------
METHOD cursordown() CLASS TMYMENUED
*-----------------------------------
local nregaux,zq
select menues
nregaux=myMenuEd.browse_101.value
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
wwlevel:=level
wwimage:=image
wwenabled:=enabled
wwchecked:=checked
wwlev:=lev
skip
w2witem:=item
w2wname:=named
w2waction:=action
w2wauxit:=auxit
w2wlevel:=level
w2wimage:=image
w2enabled:=enabled
w2checked:=checked
w2lev:=lev
replace item with wwitem
replace named with wwname
replace action with wwaction
replace auxit with wwauxit
replace level with wwlevel
replace image with wwimage
replace enabled with wwenabled
replace checked with wwchecked
replace lev with wwlev
skip -1
replace item with w2witem
replace named with w2wname
replace action with w2waction
replace auxit with w2wauxit
replace level with w2wlevel
replace image with w2wimage
replace enabled with w2enabled
replace checked with w2checked
replace lev  with w2lev

zq:=myMenuEd.browse_101.value
zq++
myMenuEd.browse_101.value:=zq
myMenuEd.browse_101.setfocus()
myMenuEd.browse_101.refresh()
Return

*---------------------------------
METHOD cursorup() CLASS TMYMENUED
*---------------------------------
local nregaux,zq
select menues
nregaux=myMenuEd.browse_101.value
if nregaux=1
   playbeep()
   return nil
endif
go nregaux
nregaux--
********** swap up record
wwitem:=item
wwname:=named
wwaction:=action
wwauxit:=auxit
wwlevel:=level
wwimage:=image
wwenabled:=enabled
wwchecked:=checked
wwlev:=lev
skip-1
w2witem:=item
w2wname:=named
w2waction:=action
w2wauxit:=auxit
w2wlevel:=level
w2wimage:=image
w2enabled:=enabled
w2checked:=checked
w2lev:=lev
replace item with wwitem
replace named with wwname
replace action with wwaction
replace auxit with wwauxit
replace level with wwlevel
replace image with wwimage
replace enabled with wwenabled
replace checked with wwchecked
replace lev with wwlev
skip
replace item with w2witem
replace named with w2wname
replace action with w2waction
replace auxit with w2wauxit
replace level with w2wlevel
replace image with w2wimage
replace enabled with w2enabled
replace checked with w2checked
replace lev with w2lev

zq:=myMenuEd.browse_101.value
zq--
myMenuEd.browse_101.value:=zq
myMenuEd.browse_101.setfocus()
myMenuEd.browse_101.refresh()
Return

