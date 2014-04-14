#include "oohg.ch"
#DEFINE CRLF CHR(13)+CHR(10)
#define IDH_DEFCONTEXTMENU 1302
#define IDH_DEFNOTIFYMENU 1303

function databaseview1
public _DBUdbfopened := .f.
public _DBUfname := ""
set century on
set interactiveclose on
declare window _dbubrowse
declare window _dbu
define window _DBU at 0,0 width 800 height 600 title "ooHG DataBase Utility" icon "dbu.ico" child backcolor myide:asystemcolor  on init DBUtogglemenu() on release DBUclosedbfs() 
   define main menu
      popup "File"
         item "Create" action DBUcreanew() 
	      item "Open" action DBUopendbf() 
	      item "Close" action DBUclosedbf() name _DBUitem1
	      item "Exit" action _DBU.release() 
      end popup
      popup "Edit"
      	item "Structure" action DBUmodistruct() name _DBUitem2
        item "Edit Mode" action DBUeditworkarea() name _DBUitem3
         item "Browse" action DBUbrowse1() name _DBUitem4
      end popup
      popup "Delete"
         item "Recall" action DBUrecallrec() name _DBUitem5
         item "Pack" action DBUpackdbf() name _DBUitem6
	      item "Zap" action DBUzapdbf() name _DBUitem7
      end popup
   end menu
   define statusbar 
      statusitem "DBU by S. Rathinagiri" width 150
      statusitem "Empty" width 400 action DBUopendbf()
      date width 100
      clock width 100
   end statusbar
   define context menu of _DBU
      menuitem "Create" action DBUcreanew()
      menuitem "Open" action DBUopendbf()
      menuitem "Close" action DBUclosedbf() name _DBUcontextclose
      separator
      menuitem "Edit" action DBUeditworkarea() name _DBUcontextedit
      menuitem "Browse" action DBUbrowse1() name _DBUcontextbrowse
   end menu
   define label labeldbu
      row 140
      col 140
      width 600
      height 100
      value "DBU"
   end label
end window
_dbu.labeldbu.fontname:="arial"
_dbu.labeldbu.fontsize:=36
center window _DBU
activate window _DBU
close all
return nil

function DBUcreanew
creanew1()
return nil

function DBUopendbf
_DBUfname1 := ""
_DBUfname1 := getfile({{"Harbour DataBase File  (*.dbf)","*.dbf"}},"Select a dbf to open")
_DBUfname1 := alltrim(_DBUfname1)

if len(_DBUfname1) > 0
   if used()
      if msgyesno("Are you sure to close the dbf opened already?")
         close all
         use &_DBUfname1
         
         _DBUfname := _DBUfname1
         _DBUdbfopened := .t.
         DBUtogglemenu()
      endif
   else
      use &_DBUfname1
      _DBUfname := _DBUfname1
      _DBUdbfopened := .t.

      DBUtogglemenu()
***      msgbox('va')

      DBUeditworkarea()      
   endif
endif
set deleted on
return nil

function DBUclosedbf
if used()
   if msgyesno("Are you sure to close the dbf?",'Information')
      close all
      _DBUfname := ""
      _DBUdbfopened := .f.
      DBUtogglemenu()
      set interactiveclose off
      return nil
   endif
endif
return nil

function DBUmodistruct
modistru()
DBUtogglemenu()
return nil

function DBUbrowse1
local _DBUname1 := ""
local _DBUstructarr := {}
local _DBUanames := {}
local _DBUasizes := {}
local _DBUajustify := {}
if .not. used()
   msginfo("No database is in use.")
   return nil
endif
_DBUstructarr := dbstruct()
for _DBUi := 1 to len(_DBUstructarr)
   aadd(_DBUanames,_DBUstructarr[_DBUi,1])
   _DBUsize := len(alltrim(_DBUstructarr[_DBUi,1]))*15
   _DBUsize1 := _DBUstructarr[_DBUi,3] * 15
   aadd(_DBUasizes,iif(_DBUsize < _DBUsize1,_DBUsize1,_DBUsize))
   if _DBUi == 1
         aadd(_DBUajustify,0)
   else
      if _DBUstructarr[_DBUi,2] == "N"
         aadd(_DBUajustify,1)
      else
         aadd(_DBUajustify,0)
      endif
   endif
next _DBUi
if len(_DBUanames) == 0
   return nil
endif
_DBUname1 := dbf()
if len(alltrim(_DBUname1)) == 0
   _DBUname1 := substr(_DBUfname,rat("\",_DBUfname),at(".",_DBUfname) - 1)
   if len(alltrim(_DBUname1))
      return nil
   endif
endif
define window _DBUbrowse at 0,0 width 700 height 500 title "Browse Window ("+_DBUfname+")" child nomaximize nominimize on init {|| _dbubrowse.maximize}
   define browse _DBUbrowse1
      row 25
      col 80
      width 600
      height 400
      headers _DBUanames
      widths _DBUasizes
      fields _DBUanames
      justify _DBUajustify
      allowappend .t.
      allowdelete .t.
      allowedit .t.
      workarea &_DBUname1
      value 1
      inplaceedit .T.    ///// cvc
      doublebuffer .t.
     end browse
   define label label_bro
      row 450
      col 150
      value  "ALT-A (Add record) - Delete (Delete record) - Dbl_click (Modify record)"
      width 500
   end label
end window
center window _DBUbrowse
activate window _DBUbrowse
DBUtogglemenu()
_dbu.labeldbu.setfocus
return nil

function delrec
if msgyesno("Are you sure?","Question")
   go _DBUbrowse._DBUbrowse1.value
   if rlock()
      delete
      unlock
   else
      msgstop("The Record can't be locked","Error message")
   endif
   _DBUbrowse._DBUbrowse1.refresh
endif
return nil


function DBUeditworkarea()
***edit1()

DBUtogglemenu()
return nil

function DBUrecallrec
if msgyesno("This will recall all the records marked for deletion. If you want to recall a particular record, try using edit mode. Are you sure to recall all?")
   set deleted on
   recall all
endif
return nil

function DBUpackdbf
if msgyesno("All records marked for deletion will be removed physically from the dbf. Are you sure to pack the dbf?")
   if used() 
      pack
      DBUtogglemenu()
   endif
endif
return nil

function DBUzapdbf
if msgyesno("Are you sure to zap this dbf? You can not undo.")
   zap
   DBUtogglemenu()
endif
return nil

function DBUtogglemenu
if .not. _DBUdbfopened
   _DBU.statusbar.item(2) := "Empty"
   _DBU._DBUcontextclose.enabled := .f.
   _DBU._DBUcontextedit.enabled := .f.
   _DBU._DBUcontextbrowse.enabled := .f.
   _DBU._DBUitem1.enabled := .f.
   _DBU._DBUitem2.enabled := .f.
**   _DBU._DBUitem3.enabled := .f.
   _DBU._DBUitem4.enabled := .f.
   _DBU._DBUitem5.enabled := .f.
   _DBU._DBUitem6.enabled := .f.
   _DBU._DBUitem7.enabled := .f.
/*   dbu.item8.enabled := .f.
   */
else
   _DBU.statusbar.item(2) := _DBUfname+" (Fields : "+alltrim(str(fcount(),5,0))+") (Records : "+alltrim(str(reccount(),10,0))+")"
   _DBU._DBUcontextclose.enabled := .t.
   _DBU._DBUcontextedit.enabled := .t.
   _DBU._DBUcontextbrowse.enabled := .t.
   _DBU._DBUitem1.enabled := .t.
   _DBU._DBUitem2.enabled := .t.
   _DBU._DBUitem3.enabled := .t.
   _DBU._DBUitem4.enabled := .t.
   _DBU._DBUitem5.enabled := .t.
   _DBU._DBUitem6.enabled := .t.
   _DBU._DBUitem7.enabled := .t.
/*   dbu.item8.enabled := .t.*/
endif
return nil  

function DBUclosedbfs()
close all
msginfo("Based upon Dbu of rathinagiri. Comments are welcome at srgiri@vsnl.com",'Information')
return nil

function modistru
if len(alltrim(_DBUfname)) == 0 .or. .not. used()
   return nil
endif
_DBUoriginalarr := dbstruct()
_DBUstructarr := dbstruct()
_DBUdbfsaved := .f.
define window _DBUcreadbf at 0,0 width 600 height 500 title "Modify DataBase Table" modal nosize nosysmenu
   define frame _DBUcurfield
      row 10
      col 10
      width 550
      height 150
      caption "Field"
   end frame
   define label _DBUnamelabel
      row 40
      col 40
      width 150
      value "Name"
   end label
   define label _DBUtypelabel
      row 40
      col 195
      width 100
      value "Type"
   end label
   define label _DBUsizelabel
      row 40
      col 300
      width 100
      value "Size"
   end label
   define label _DBUdecimallabel
      row 40
      col 405
      width 75
      value "Decimals"
   end label
   define textbox _DBUfieldname
      row 70
      col 40
      width 150
      uppercase .t.
      maxlength 10
      value ""
   end textbox
   define combobox _DBUfieldtype
      row 70
      col 195
      items {"Character","Numeric","Date","Logical","Memo"}
      width 100
      value 1
      on lostfocus DBUtypelostfocus()
      on enter DBUtypelostfocus()
*      on change typelostfocus()
   end combobox
   define textbox _DBUfieldsize
      row 70
      col 300
      value 10
      numeric .t.
      width 100
      on lostfocus DBUsizelostfocus()
      rightalign .t.
   end textbox
   define textbox _DBUfielddecimals
      row 70
      col 405
      width 75
      value 0
      numeric .t.
      width 100
      on lostfocus DBUdeclostfocus()
      rightalign .t.
   end textbox
   define button _DBUaddline
      row 120
      col 75
      caption "Add"
      width 100
      FLAT .T.
      action DBUaddstruct()
   end button
   define button _DBUinsline
      row 120
      col 225
      caption "Insert"
      width 100
      FLAT .T.
      action DBUinsstruct()
   end button
   define button _DBUdelline
      row 120
      col 400
      caption "Delete"
      width 100
      FLAT .T.
      action DBUdelstruct()
   end button
   define frame _DBUstructframe
      row 190
      col 10
      caption "Structure of DBF"
      width 500
      height 180
   end frame
   define grid _DBUstruct
      row 220
      col 40
      headers {"Name","Type","Size","Decimals"}
      justify {0,0,1,1}
      widths {150,100,100,75}
      width 450
      items _DBUstructarr
      on dblclick DBUlineselected()
      height 120
   end grid
   define button _DBUsavestruct
      row 400
      col 200
      caption "Modify"
      FLAT .T.
      action DBUmodistructure()
   end button
   define button _DBUexitnew
      row 400
      col 400
      caption "Exit"
      FLAT .T.
      action DBUexitmodidbf()
   end button
end window
center window _DBUcreadbf
_DBUcreadbf._DBUstruct.deleteallitems()
for _DBUi := 1 to len(_DBUstructarr)
   do case
      case _DBUstructarr[_DBUi,2] == "C"
         _DBUtype1 := "Character"
      case _DBUstructarr[_DBUi,2] == "N"
         _DBUtype1 := "Numeric"
      case _DBUstructarr[_DBUi,2] == "D"
         _DBUtype1 := "Date"
      case _DBUstructarr[_DBUi,2] == "L"
         _DBUtype1 := "Logical"
      case _DBUstructarr[_DBUi,2] == "M"
         _DBUtype1 := "Memo"
   end case	 
   _DBUcreadbf._DBUstruct.additem({_DBUstructarr[_DBUi,1],;
                          _DBUtype1,;
			  str(_DBUstructarr[_DBUi,3],8,0),;
  			  str(_DBUstructarr[_DBUi,4],3,0)})
next _DBUi
if len(_DBUstructarr) > 0
   _DBUcreadbf._DBUstruct.value := len(_DBUstructarr)
endif
activate window _DBUcreadbf
return nil


function DBUmodistructure
if .not. msgyesno("Caution: If you had modified either the field name or the field type, the data for that fields can not be saved in the modified dbf. However, a backup file (.bak) will be created. Are you sure to modify the structure?","DBU")
   return nil
endif
_DBUmodarr := {}
for _DBUi := 1 to len(_DBUstructarr)
   if _DBUi <= len(_DBUoriginalarr)
      _DBUline := ascan(_DBUoriginalarr,{|_DBUx|upper(alltrim(_DBUx[1])) == upper(alltrim(_DBUstructarr[_DBUi,1]))})
      if _DBUline > 0
         if _DBUoriginalarr[_DBUline,2] == _DBUstructarr[_DBUi,2]
	         aadd(_DBUmodarr,_DBUi)
	      endif
      endif
   endif
next _DBUi
_DBUfname1 := "DBUtemp"
if len(_DBUstructarr) > 0
   _DBUfname1 := "DBUtemp"
   if len(_DBUfname1) > 0
      dbcreate(_DBUfname1,_DBUstructarr)
      close all
      select b
      use &_DBUfname
      select c
      use &_DBUfname1
      select b
      go top
      if len(_DBUmodarr) > 0
         do while .not. eof()
            select c
	         append blank
	         for _DBUi := 1 to len(_DBUmodarr)
	            _DBUfieldname := _DBUstructarr[_DBUmodarr[_DBUi],1]
	            replace c->&_DBUfieldname with b->&_DBUfieldname
	         next _DBUi
    	      commit
	         select b
	         skip
	      enddo
      endif
      select b
      close
      select c
      close
      if at(".",_DBUfname) == 0
         _DBUbackname := alltrim(_DBUfname)+".dbf"
         if file(_DBUbackname)
	         if file(alltrim(_DBUfname)+".bak")
	           ferase(alltrim(_DBUfname)+".bak")
	         endif
	         frename(_DBUbackname,alltrim(_DBUfname)+".bak")
	         frename('DBUtemp.dbf',alltrim(_DBUfname)+".dbf")
	      endif
      else
         _DBUnewname := substr(alltrim(_DBUfname),1,at(".",_DBUfname)-1)+".bak"
         if file(_DBUfname)
            if file(_DBUnewname)
               ferase(_DBUnewname)
            endif
            frename(_DBUfname,_DBUnewname)
            frename('DBUtemp.dbf',alltrim(_DBUfname))
         endif
      endif
      close all
      use &_DBUfname
      release window _DBUcreadbf
   endif
endif
return nil

function DBUexitmodidbf
if len(_DBUstructarr) == 0 .or. _DBUdbfsaved
   release window _DBUcreadbf
else
   if msgyesno("Are you sure to abort Modifying this dbf?","DBU")
      release window _DBUcreadbf
   endif
endif
return nil

function creanew1

_DBUstructarr := {}
_DBUdbfsaved := .f.
define window _DBUcreadbf at 0,0 width 600 height 500 title "Create a New DataBase Table (.dbf)" modal nosize nosysmenu
   define frame _DBUcurfield
      row 10
      col 10
      width 550
      height 150
      caption "Field"
   end frame
   define label _DBUnamelabel
      row 40
      col 40
      width 150
      value "Name"
   end label
   define label _DBUtypelabel
      row 40
      col 195
      width 100
      value "Type"
   end label
   define label _DBUsizelabel
      row 40
      col 300
      width 100
      value "Size"
   end label
   define label _DBUdecimallabel
      row 40
      col 405
      width 75
      value "Decimals"
   end label
   define textbox _DBUfieldname
      row 70
      col 40
      width 150
      uppercase .t.
      maxlength 10
      value ""
   end textbox
   define combobox _DBUfieldtype
      row 70
      col 195
      items {"Character","Numeric","Date","Logical","Memo"}
      width 100
      value 1
      on lostfocus DBUtypelostfocus()
      on enter DBUtypelostfocus()
*      on change DBUtypelostfocus()
   end combobox
   define textbox _DBUfieldsize
      row 70
      col 300
      value 10
      numeric .t.
      width 100
      on lostfocus DBUsizelostfocus()
      rightalign .t.
   end textbox
   define textbox _DBUfielddecimals
      row 70
      col 405
      width 75
      value 0
      numeric .t.
      width 100
      on lostfocus DBUdeclostfocus()
      rightalign .t.
   end textbox
   define button _DBUaddline
      row 120
      col 75
      caption "Add"
      width 100
      FLAT .T.
      action DBUaddstruct()
   end button
   define button _DBUinsline
      row 120
      col 225
      caption "Insert"
      width 100
      FLAT .T.
      action DBUinsstruct()
   end button
   define button _DBUdelline
      row 120
      col 400
      caption "Delete"
      width 100
      FLAT .T.
      action DBUdelstruct()
   end button
   define frame _DBUstructframe
      row 190
      col 10
      caption "Structure of DBF"
      width 500
      height 180
   end frame
   define grid _DBUstruct
      row 220
      col 40
      headers {"Name","Type","Size","Decimals"}
      justify {0,0,1,1}
      widths {150,100,100,75}
      width 450
      on dblclick DBUlineselected()
      height 120
   end grid
   define button _DBUsavestruct
      row 400
      col 200
      caption "Create"
      FLAT .T.
      action DBUsavestructure()
   end button
   define button _DBUexitnew
      row 400
      col 400
      caption "Exit"
      FLAT .T.
      action DBUexitcreatenew()
   end button
end window
center window _DBUcreadbf
activate window _DBUcreadbf
return nil

function DBUexitcreatenew
if len(_DBUstructarr) == 0 .or. _DBUdbfsaved
   release window _DBUcreadbf
else
   if msgyesno("Are you sure to abort creating this dbf?")
      release window _DBUcreadbf
   endif
endif
return nil


function DBUaddstruct
if _DBUcreadbf._DBUaddline.caption == "Add"
   if .not. DBUnamecheck()
      return nil
   endif
   if _DBUcreadbf._DBUfieldsize.value == 0
      msgexclamation("Field size can not be zero!","DBU")
      _DBUcreadbf._DBUfieldsize.setfocus()
      return nil
   endif
   DBUtypelostfocus()
   DBUsizelostfocus()
   DBUdeclostfocus()
   if _DBUcreadbf._DBUfieldtype.value == 2 .and. _DBUcreadbf._DBUfielddecimals.value >= _DBUcreadbf._DBUfieldsize.value
      msgexclamation("You can not have decimal points more than the size!","DBU")
      _DBUcreadbf._DBUfielddecimals.setfocus()
      return nil
   endif
   if len(_DBUstructarr) > 0
      for _DBUi := 1 to len(_DBUstructarr)
         if upper(alltrim(_DBUcreadbf._DBUfieldname.value)) == upper(alltrim(_DBUstructarr[_DBUi,1]))
            msgexclamation("Duplicate field names are not allowed!","DBU")
   	      _DBUcreadbf._DBUfieldname.setfocus()
	         return nil
         endif
      next _DBUi
   endif
   do case
      case _DBUcreadbf._DBUfieldtype.value == 1
         aadd(_DBUstructarr,{alltrim(_DBUcreadbf._DBUfieldname.value),"C",_DBUcreadbf._DBUfieldsize.value,0})
      case _DBUcreadbf._DBUfieldtype.value == 2
         aadd(_DBUstructarr,{alltrim(_DBUcreadbf._DBUfieldname.value),"N",_DBUcreadbf._DBUfieldsize.value,_DBUcreadbf._DBUfielddecimals.value})
      case _DBUcreadbf._DBUfieldtype.value == 3
         aadd(_DBUstructarr,{alltrim(_DBUcreadbf._DBUfieldname.value),"D",8,0})
      case _DBUcreadbf._DBUfieldtype.value == 4
         aadd(_DBUstructarr,{alltrim(_DBUcreadbf._DBUfieldname.value),"L",1,0})
      case _DBUcreadbf._DBUfieldtype.value == 5
         aadd(_DBUstructarr,{alltrim(_DBUcreadbf._DBUfieldname.value),"M",10,0})
   endcase
   _DBUcreadbf._DBUstruct.deleteallitems()
   for _DBUi := 1 to len(_DBUstructarr)
      do case
         case _DBUstructarr[_DBUi,2] == "C"
            _DBUtype1 := "Character"
         case _DBUstructarr[_DBUi,2] == "N"
            _DBUtype1 := "Numeric"
         case _DBUstructarr[_DBUi,2] == "D"
            _DBUtype1 := "Date"
         case _DBUstructarr[_DBUi,2] == "L"
            _DBUtype1 := "Logical"
         case _DBUstructarr[_DBUi,2] == "M"
            _DBUtype1 := "Memo"
      end case	 
      _DBUcreadbf._DBUstruct.additem({_DBUstructarr[_DBUi,1],;
                                     _DBUtype1,;
               			             str(_DBUstructarr[_DBUi,3],8,0),;
  			                            str(_DBUstructarr[_DBUi,4],3,0)})
   next _DBUi
   if len(_DBUstructarr) > 0
      _DBUcreadbf._DBUstruct.value := len(_DBUstructarr)
   endif
   _DBUcreadbf._DBUfieldname.value := ""
   _DBUcreadbf._DBUfieldtype.value := 1
   _DBUcreadbf._DBUfieldsize.value := 10
   _DBUcreadbf._DBUfielddecimals.value := 0
   _DBUcreadbf._DBUfieldname.setfocus()
else
   _DBUcurline := _DBUcreadbf._DBUstruct.value
   if _DBUcurline > 0
      if .not. DBUnamecheck()
         return nil
      endif
      if _DBUcreadbf._DBUfieldsize.value == 0
         msgexclamation("Field size can not be zero!","DBU")
         _DBUcreadbf._DBUfieldsize.setfocus()
         return nil
      endif
      DBUtypelostfocus()
      DBUsizelostfocus()
      DBUdeclostfocus()
      if _DBUcreadbf._DBUfieldtype.value == 2 .and. _DBUcreadbf._DBUfielddecimals.value >= _DBUcreadbf._DBUfieldsize.value
         msgexclamation("You can not have decimal points more than the size!","DBU")
         _DBUcreadbf._DBUfielddecimals.setfocus()
         return nil
      endif
      if len(_DBUstructarr) > 0
         for _DBUi := 1 to len(_DBUstructarr)
            if upper(alltrim(_DBUcreadbf._DBUfieldname.value)) == upper(alltrim(_DBUstructarr[_DBUi,1])) .and. _DBUi <> _DBUcurline
               msgexclamation("Duplicate field names are not allowed!","DBU")
      	       _DBUcreadbf._DBUfieldname.setfocus()
   	       return nil
            endif
         next _DBUi
      endif
      do case
         case _DBUcreadbf._DBUfieldtype.value == 1
            _DBUstructarr[_DBUcurline] := {alltrim(_DBUcreadbf._DBUfieldname.value),"C",_DBUcreadbf._DBUfieldsize.value,0}
         case _DBUcreadbf._DBUfieldtype.value == 2
            _DBUstructarr[_DBUcurline] := {alltrim(_DBUcreadbf._DBUfieldname.value),"N",_DBUcreadbf._DBUfieldsize.value,_DBUcreadbf._DBUfielddecimals.value}
         case _DBUcreadbf._DBUfieldtype.value == 3
            _DBUstructarr[_DBUcurline] := {alltrim(_DBUcreadbf._DBUfieldname.value),"D",8,0}
         case _DBUcreadbf._DBUfieldtype.value == 4
            _DBUstructarr[_DBUcurline] := {alltrim(_DBUcreadbf._DBUfieldname.value),"L",1,0}
         case _DBUcreadbf._DBUfieldtype.value == 5
            _DBUstructarr[_DBUcurline] := {alltrim(_DBUcreadbf._DBUfieldname.value),"M",10,0}
      endcase
      _DBUcreadbf._DBUstruct.deleteallitems()
      for _DBUi := 1 to len(_DBUstructarr)
         do case
            case _DBUstructarr[_DBUi,2] == "C"
               _DBUtype1 := "Character"
            case _DBUstructarr[_DBUi,2] == "N"
               _DBUtype1 := "Numeric"
            case _DBUstructarr[_DBUi,2] == "D"
               _DBUtype1 := "Date"
            case _DBUstructarr[_DBUi,2] == "L"
               _DBUtype1 := "Logical"
            case _DBUstructarr[_DBUi,2] == "M"
               _DBUtype1 := "Memo"
         end case	 
         _DBUcreadbf._DBUstruct.additem({_DBUstructarr[_DBUi,1],;
                                _DBUtype1,;
      			        str(_DBUstructarr[_DBUi,3],8,0),;
  			        str(_DBUstructarr[_DBUi,4],3,0)})
      next _DBUi
      if len(_DBUstructarr) > 0
         _DBUcreadbf._DBUstruct.value := _DBUcurline
      endif
      _DBUcreadbf._DBUaddline.caption := "Add"
      _DBUcreadbf._DBUinsline.enabled := .t.
      _DBUcreadbf._DBUdelline.enabled := .t.
      _DBUcreadbf._DBUfieldname.value := ""
      _DBUcreadbf._DBUfieldtype.value := 1
      _DBUcreadbf._DBUfieldsize.value := 10
      _DBUcreadbf._DBUfielddecimals.value := 0
      _DBUcreadbf._DBUfieldname.setfocus()
   endif
endif
return nil


function DBUinsstruct
if len(_DBUstructarr) == 0 
   DBUaddstruct()
   return nil
endif
if _DBUcreadbf._DBUstruct.value == 0
   DBUaddstruct()
   return nil
endif
if .not. DBUnamecheck()
   return nil
endif
if _DBUcreadbf._DBUfieldsize.value == 0
   msgexclamation("Field size can not be zero!","DBU")
   _DBUcreadbf._DBUfieldsize.setfocus()
   return nil
endif
DBUtypelostfocus()
DBUsizelostfocus()
DBUdeclostfocus()
if _DBUcreadbf._DBUfieldtype.value == 2 .and. _DBUcreadbf._DBUfielddecimals.value >= _DBUcreadbf._DBUfieldsize.value
   msgexclamation("You can not have decimal points more than the size!","DBU")
   _DBUcreadbf._DBUfielddecimals.setfocus()
   return nil
endif
if len(_DBUstructarr) > 0
   for _DBUi := 1 to len(_DBUstructarr)
      if upper(alltrim(_DBUcreadbf._DBUfieldname.value)) == upper(alltrim(_DBUstructarr[_DBUi,1]))
         msgexclamation("Duplicate field names are not allowed!","DBU")
	 _DBUcreadbf._DBUfieldname.setfocus()
	 return nil
      endif
   next _DBUi
endif
_DBUpos := _DBUcreadbf._DBUstruct.value
asize(_DBUstructarr,len(_DBUstructarr)+1)
_DBUstructarr := ains(_DBUstructarr,_DBUpos)
do case
   case _DBUcreadbf._DBUfieldtype.value == 1
      _DBUstructarr[_DBUpos] := {alltrim(_DBUcreadbf._DBUfieldname.value),"C",_DBUcreadbf._DBUfieldsize.value,0}
   case _DBUcreadbf._DBUfieldtype.value == 2
      _DBUstructarr[_DBUpos] := {alltrim(_DBUcreadbf._DBUfieldname.value),"N",_DBUcreadbf._DBUfieldsize.value,_DBUcreadbf._DBUfielddecimals.value}
   case _DBUcreadbf._DBUfieldtype.value == 3
      _DBUstructarr[_DBUpos] := {alltrim(_DBUcreadbf._DBUfieldname.value),"D",8,0}
   case _DBUcreadbf._DBUfieldtype.value == 4
      _DBUstructarr[_DBUpos] := {alltrim(_DBUcreadbf._DBUfieldname.value),"L",1,0}
   case _DBUcreadbf._DBUfieldtype.value == 5
      _DBUstructarr[_DBUpos] := {alltrim(_DBUcreadbf._DBUfieldname.value),"M",10,0}
endcase
_DBUcreadbf._DBUstruct.deleteallitems()
for _DBUi := 1 to len(_DBUstructarr)
   do case
      case _DBUstructarr[_DBUi,2] == "C"
         _DBUtype1 := "Character"
      case _DBUstructarr[_DBUi,2] == "N"
         _DBUtype1 := "Numeric"
      case _DBUstructarr[_DBUi,2] == "D"
         _DBUtype1 := "Date"
      case _DBUstructarr[_DBUi,2] == "L"
         _DBUtype1 := "Logical"
      case _DBUstructarr[_DBUi,2] == "M"
         _DBUtype1 := "Memo"
   end case	 
   _DBUcreadbf._DBUstruct.additem({_DBUstructarr[_DBUi,1],;
                          _DBUtype1,;
			  str(_DBUstructarr[_DBUi,3],8,0),;
			  str(_DBUstructarr[_DBUi,4],3,0)})
next _DBUi
if len(_DBUstructarr) > 0
   _DBUcreadbf._DBUstruct.value := _DBUpos
endif
_DBUcreadbf._DBUfieldname.value := ""
_DBUcreadbf._DBUfieldtype.value := 1
_DBUcreadbf._DBUfieldsize.value := 10
_DBUcreadbf._DBUfielddecimals.value := 0
_DBUcreadbf._DBUfieldname.setfocus()
return nil

function DBUdelstruct
_DBUcurline := _DBUcreadbf._DBUstruct.value
if _DBUcurline > 0
   _DBUstructarr := adel(_DBUstructarr,_DBUcurline)
   _DBUstructarr := asize(_DBUstructarr,len(_DBUstructarr) - 1)
   _DBUcreadbf._DBUstruct.deleteallitems()
   for _DBUi := 1 to len(_DBUstructarr)
      do case
         case _DBUstructarr[_DBUi,2] == "C"
            _DBUtype1 := "Character"
         case _DBUstructarr[_DBUi,2] == "N"
            _DBUtype1 := "Numeric"
         case _DBUstructarr[_DBUi,2] == "D"
            _DBUtype1 := "Date"
         case _DBUstructarr[_DBUi,2] == "L"
            _DBUtype1 := "Logical"
         case _DBUstructarr[_DBUi,2] == "M"
            _DBUtype1 := "Memo"
      end case	 
      _DBUcreadbf._DBUstruct.additem({_DBUstructarr[_DBUi,1],;
                             _DBUtype1,;
   			     str(_DBUstructarr[_DBUi,3],8,0),;
   			     str(_DBUstructarr[_DBUi,4],3,0)})
   next _DBUi
   if len(_DBUstructarr) > 1
      if len(_DBUstructarr) == 1
         _DBUcreadbf._DBUstruct.value := 1
      else
         _DBUcreadbf._DBUstruct.value := iif(_DBUcurline == 1,1,_DBUcurline - 1)
      endif
   endif
endif
return nil

function DBUnamecheck
local _DBUname := alltrim(_DBUcreadbf._DBUfieldname.value)
local _DBUlegalchars := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ_1234567890'
local _DBUi := 0
if len(_DBUname) == 0
   msgexclamation("Field Name can not be empty!","DBU")
   _DBUcreadbf._DBUfieldname.setfocus()
   return .f.
endif
if val(substr(_DBUname,1,1)) > 0 .or. substr(_DBUname,1,1) == "_"
   msgexclamation("First letter of the field name can not be a numeric character or special character!","DBU")
   _DBUcreadbf._DBUfieldname.setfocus()
   return .f.
else
   for _DBUi := 1 to len(_DBUname)
      if at(upper(substr(_DBUname,_DBUi,1)),_DBUlegalchars) == 0
         msgexclamation("Field name contains illegal characters. Allowed characters are alphabets, numbers and the special character '_'.","DBU")
         _DBUcreadbf._DBUfieldname.setfocus()
         return .f.
      endif
   next _DBUi
endif
return .t.

function DBUtypelostfocus
do case
   case _DBUcreadbf._DBUfieldtype.value == 3
      _DBUcreadbf._DBUfieldsize.value := 8
      _DBUcreadbf._DBUfielddecimals.value := 0
   case _DBUcreadbf._DBUfieldtype.value == 4
      _DBUcreadbf._DBUfieldsize.value := 1
      _DBUcreadbf._DBUfielddecimals.value := 0
   case _DBUcreadbf._DBUfieldtype.value == 5
      _DBUcreadbf._DBUfieldsize.value := 10
      _DBUcreadbf._DBUfielddecimals.value := 0
endcase
return nil

function DBUsizelostfocus
DBUtypelostfocus()
if _DBUcreadbf._DBUfieldtype.value == 1
      _DBUcreadbf._DBUfielddecimals.value := 0
endif
return nil

function DBUdeclostfocus
DBUtypelostfocus()
DBUsizelostfocus()
if _DBUcreadbf._DBUfieldtype.value <> 2
   _DBUcreadbf._DBUfielddecimals.value := 0
endif
return nil

function DBUlineselected
_DBUcurline := _DBUcreadbf._DBUstruct.value
if _DBUcurline > 0
   _DBUcreadbf._DBUfieldname.value := _DBUstructarr[_DBUcurline,1]
   do case
      case _DBUstructarr[_DBUcurline,2] == "C"
         _DBUcreadbf._DBUfieldtype.value := 1
      case _DBUstructarr[_DBUcurline,2] == "N"
         _DBUcreadbf._DBUfieldtype.value := 2
      case _DBUstructarr[_DBUcurline,2] == "D"
         _DBUcreadbf._DBUfieldtype.value := 3
      case _DBUstructarr[_DBUcurline,2] == "L"
         _DBUcreadbf._DBUfieldtype.value := 4
      case _DBUstructarr[_DBUcurline,2] == "M"
         _DBUcreadbf._DBUfieldtype.value := 5
   end case
   _DBUcreadbf._DBUfieldsize.value := _DBUstructarr[_DBUcurline,3]
   _DBUcreadbf._DBUfielddecimals.value := _DBUstructarr[_DBUcurline,4]
   _DBUcreadbf._DBUinsline.enabled := .f.
   _DBUcreadbf._DBUdelline.enabled := .f.
   _DBUcreadbf._DBUaddline.caption := "Modify"
   _DBUcreadbf._DBUfieldname.setfocus()
endif
return nil

function DBUsavestructure
_DBUfname1 := ""
if len(_DBUstructarr) > 0
   _DBUfname1 := alltrim(putfile({{"Harbour Database File","*.dbf"}},"Enter a filename"))
   if len(_DBUfname1) > 0
      if msgyesno("Are you sure to create this database file?","DBU")
         dbcreate(_DBUfname1,_DBUstructarr)
	      msginfo("File has been created successfully","DBU")
	      if .not. used()
  	         use &_DBUfname1
	         _DBUfname := _DBUfname1
	         _DBUdbfopened := .t.
            DBUtogglemenu()
   	      release window _DBUcreadbf
	      else
   	      release window _DBUcreadbf
   	   endif
      endif
   endif
endif
return nil

function edit1()
//oldsetting := set(11,.f.) //set deleted
set deleted on
_DBUstructarr := dbstruct()
_DBUcondition := ""
_DBUfiltered := .f.   
if len(_DBUstructarr) == 0
   return nil
endif
_DBUindexed := .f.
_DBUhspace := 5
_DBUvspace := 30
_DBUfieldnames := {}
_DBUmaxrow := 350
_DBUmaxcol := 700
_DBUrow := 40
_DBUcol := 20
_DBUcontrolarr := {} // {row,col,name,width,type,size,decimals,page}
_DBUpages := 1
aadd(_DBUfieldnames,"<None>")   
for _DBUi := 1 to len(_DBUstructarr)
   _DBUfieldnamesize := len(alltrim(_DBUstructarr[_DBUi,1]))
   aadd(_DBUfieldnames,alltrim(_DBUstructarr[_DBUi,1]))
   _DBUfieldsize := _DBUstructarr[_DBUi,3]
   _DBUspecifysize := .f.
   do case
      case _DBUstructarr[_DBUi,2] == "C" .or. _DBUstructarr[_DBUi,2] == "N"
         _DBUsize := iif(max(_DBUfieldnamesize+4,_DBUfieldsize) > 10,150,max(_DBUfieldnamesize+4,_DBUfieldsize)*10)
   	   _DBUspecifysize := .t.
      case _DBUstructarr[_DBUi,2] == "D"
         _DBUsize := iif(max(_DBUfieldnamesize,_DBUfieldsize) > 10,150,120)
      case _DBUstructarr[_DBUi,2] == "L"
         _DBUsize := (_DBUfieldnamesize*10)+30
      case _DBUstructarr[_DBUi,2] == "M"
         _DBUsize := 300
   endcase
   if _DBUcol + _DBUsize + _DBUhspace >= _DBUmaxcol
      _DBUrow := _DBUrow + _DBUvspace + _DBUvspace
      _DBUcol := 20
   endif
   if _DBUrow + _DBUvspace + _DBUvspace >= _DBUmaxrow
      _DBUpages := _DBUpages + 1
      _DBUrow := 40
      _DBUcol := 20
   endif
   aadd(_DBUcontrolarr,{_DBUrow,_DBUcol,alltrim(_DBUstructarr[_DBUi,1]),_DBUsize,"H",iif(_DBUspecifysize,_DBUfieldsize,0),,_DBUpages})
   aadd(_DBUcontrolarr,{_DBUrow+20,_DBUcol,alltrim(_DBUstructarr[_DBUi,1]),_DBUsize,_DBUstructarr[_DBUi,2],_DBUfieldsize,_DBUstructarr[_DBUi,4],_DBUpages})
   _DBUcol := _DBUcol + _DBUhspace + _DBUsize
next _DBUi
***msgbox('va por aca')
*** msgbox('bien 1')
define window _DBUeditdbf at 0,0 width 750 height 520 title "Edit DataBase Records of "+alltrim(_DBUfname) child nosize nosysmenu
   define tab _DBUrecord at 10,10 width 725 height 360
      for _DBUi := 1 to _DBUpages
         define page "Page "+alltrim(str(_DBUi,3,0))
         for _DBUj := 1 to len(_DBUcontrolarr)
            if _DBUcontrolarr[_DBUj,8] == _DBUi
	            do case
	               case _DBUcontrolarr[_DBUj,5] == "H" // Header
  	                  _DBUheader1 := _DBUcontrolarr[_DBUj,3]+"label"
	                  define label &_DBUheader1
		                  row _DBUcontrolarr[_DBUj,1]
		                  col _DBUcontrolarr[_DBUj,2]
		                  value _DBUcontrolarr[_DBUj,3]+iif(_DBUcontrolarr[_DBUj,6] > 0,":"+alltrim(str(_DBUcontrolarr[_DBUj,6],6,0)),"")
		                  width _DBUcontrolarr[_DBUj,4]
			               fontcolor {0,0,255}
      	             end label
		             case _DBUcontrolarr[_DBUj,5] == "C" // Character
		               define textbox &_DBUcontrolarr[_DBUj,3]
		                  row _DBUcontrolarr[_DBUj,1]
			               col _DBUcontrolarr[_DBUj,2]
			               tooltip "Enter the value for the field "+alltrim(_DBUcontrolarr[_DBUj,3])+". Type of the field is Character. Maximum Length is "+alltrim(str(_DBUcontrolarr[_DBUj,6],6,0))+"."
			               width _DBUcontrolarr[_DBUj,4]
			               maxlength _DBUcontrolarr[_DBUj,6]
	                  end textbox
		            case _DBUcontrolarr[_DBUj,5] == "N" // Numeric
		               define textbox &_DBUcontrolarr[_DBUj,3]
		                  row _DBUcontrolarr[_DBUj,1]
			               col _DBUcontrolarr[_DBUj,2]
			               width _DBUcontrolarr[_DBUj,4]
			               maxlength _DBUcontrolarr[_DBUj,6]
			               tooltip "Enter the value for the field "+alltrim(_DBUcontrolarr[_DBUj,3])+". Type of the field is Numeric. Maximum Length is "+alltrim(str(_DBUcontrolarr[_DBUj,6],6,0))+", with decimals "+alltrim(str(_DBUcontrolarr[_DBUj,7],3,0))+"."
			               numeric .t.
			               rightalign .t.
			               if _DBUcontrolarr[_DBUj,7] > 0
			                  inputmask replicate("9",_DBUcontrolarr[_DBUj,6] - _DBUcontrolarr[_DBUj,7] - 1)+"."+replicate("9",_DBUcontrolarr[_DBUj,7])
			               endif   
	                  end textbox
	               case _DBUcontrolarr[_DBUj,5] == "D" // Date
		               define datepicker &_DBUcontrolarr[_DBUj,3]
		                  row _DBUcontrolarr[_DBUj,1]
			               col _DBUcontrolarr[_DBUj,2]
			               tooltip "Enter the date value for the field "+alltrim(_DBUcontrolarr[_DBUj,3])+"."
			               width _DBUcontrolarr[_DBUj,4]
                     end datepicker
		            case _DBUcontrolarr[_DBUj,5] == "L" // Logical
		               define checkbox &_DBUcontrolarr[_DBUj,3]
		                  row _DBUcontrolarr[_DBUj,1]
			               col _DBUcontrolarr[_DBUj,2]
			               tooltip "Select True of False for this Logical Field "+alltrim(_DBUcontrolarr[_DBUj,3])+"."
			               width _DBUcontrolarr[_DBUj,4]
			               caption _DBUcontrolarr[_DBUj,3]
		               end checkbox
		            case _DBUcontrolarr[_DBUj,5] == "M" // Memo
		               define textbox &_DBUcontrolarr[_DBUj,3]
		                  row _DBUcontrolarr[_DBUj,1]
			               col _DBUcontrolarr[_DBUj,2]
			               tooltip "Enter the value for the field "+alltrim(_DBUcontrolarr[_DBUj,3])+". Type of the field is Memo."
			               width _DBUcontrolarr[_DBUj,4]
                     end textbox
               endcase		     
            endif
	      next _DBUj
         end page
      next _DBUi
   end tab
   define button _DBUfirst
      row 390
      col 10
      caption "|<"
      tooltip "Goto First Record"
      width 40
      FLAT .T.
      action DBUfirstclick()
   end button
   define button _DBUprevious
      row 390
      col 70
      caption "<"
      tooltip "Goto Previous Record"
      width 40
      FLAT .T.
      action DBUpreviousclick()
   end button
   define button _DBUnext
      row 390
      col 130
      caption ">"
      tooltip "Goto Next Record"
      width 40
      FLAT .T.
      action DBUnextclick()
   end button
   define button _DBUlast
      row 390
      col 190
      caption ">|"
      tooltip "Goto Last Record"
      width 40
      FLAT .T.
      action DBUlastclick()
   end button
   define button _DBUnewrec
      row 390
      col 250
      caption "New"
      tooltip "Append Blank"
      width 50
      FLAT .T.
      action DBUnewrecclick()
   end button
   define button _DBUsave
      row 390
      col 320
      caption "Save"
      tooltip "Commit"
      width 50
      FLAT .T.
      action DBUsaveclick()
   end button
   define button _DBUdelrec
      row 390
      col 390
      caption "Delete"
      tooltip "Mark Current Record for Deletion"
      width 50
      FLAT .T.
      action DBUdelrecclick()
   end button
   define button _DBUrecall
      row 390
      col 450
      caption "Recall"
      tooltip "Recall Deleted Record"
      width 50
      FLAT .T.
      action DBUrecallclick()
   end button
   define button _DBUgoto
      row 390
      col 520
      caption "Goto"
      tooltip "Goto Record No."
      width 50
      FLAT .T.
      action DBUgotoclick()
   end button
   if reccount() <= 65535
      define slider _DBUrecgotoslider
         row 420
         col 10
         width 490
         tooltip "Select a record number and click Goto for editing a record"
         rangemin iif(reccount() == 0,0,1)
         rangemax reccount()
         on change _DBUeditdbf._DBUrecgoto.value := _DBUeditdbf._DBUrecgotoslider.value
      end slider
   endif
   define textbox _DBUrecgoto
      row 420
      col 520
      width 50
      numeric .t.
      rightalign .t.
      value iif(reccount() == 0,0,recno())
      on enter DBUgotoclick()
   end textbox
   define button _DBUsearch
      row 390
      col 590
      caption "Filter"
      tooltip "Filter the database file with given condition"
      width 50
      FLAT .T.
      action DBUsearchclick()
   end button
   define combobox _DBUindexfield
      row 420
      col 600
      width 100
      items _DBUfieldnames
      value 1
      on change DBUindexchange()
      tooltip "Index on"
   end combobox   
   define button _DBUcloseedit
      row 390
      col 660
      caption "Close"
      tooltip "Close Edit Window"
      width 50
      FLAT .T.
      action DBUcloseedit1()
   end button
   define statusbar size 12 
      statusitem "" 
      statusitem "" 
      statusitem "" width 80
      statusitem "" width 80
   end statusbar      
end window
center window _DBUeditdbf
msginfo('casi')
DBUfirstclick()
activate window _DBUeditdbf
		     
function DBUfirstclick
go top
DBUrefreshdbf()
return nil

function DBUpreviousclick
if recno() > 1
   skip -1
   DBUrefreshdbf()
endif
return nil

function DBUnextclick
if .not. eof() .and. recno() <> reccount()
   skip
   DBUrefreshdbf()
endif
return nil

function DBUlastclick
go bottom
DBUrefreshdbf()
return nil

function DBUnewrecclick
if msgyesno("A new record will be appended to the dbf. You can edit the record and it will be saved only after you click 'Save'. Are you sure to append a blank record?","DBU")
   append blank
   if reccount() <= 65535
      _DBUeditdbf._DBUrecgotoslider.rangemax := reccount()
      if _DBUeditdbf._DBUrecgotoslider.rangemin == 0
         _DBUeditdbf._DBUrecgotoslider.rangemin := 1
      endif
   endif
   DBUrefreshdbf()
   _DBUeditdbf.&_DBUcontrolarr[2,3].setfocus()
endif   
return nil

function DBUsaveclick
if .not. eof()
   _DBUdbfname := alias()
   for _DBUi := 1 to len(_DBUcontrolarr)
      if _DBUcontrolarr[_DBUi,5] <> "H"
         if _DBUcontrolarr[_DBUi,5] <> "L" 
            _DBUpos1 := fieldpos(_DBUcontrolarr[_DBUi,3])
            if _DBUpos1 > 0
               (_DBUdbfname)->(fieldput(_DBUpos1,_DBUeditdbf.&_DBUcontrolarr[_DBUi,3].value))
  	         endif   
	      else   
            _DBUpos1 := fieldpos(_DBUcontrolarr[_DBUi,3])
            if _DBUpos1 > 0
   	         if (_DBUdbfname)->(fieldget(_DBUpos1)) <> nil
                  (_DBUdbfname)->(fieldput(_DBUpos1,_DBUeditdbf.&_DBUcontrolarr[_DBUi,3].value))
  	            endif   
	         endif   
         endif
      endif	 
   next _DBUi
   commit
   DBUrefreshdbf()
else
   msginfo("The record pointer is at eof. You have to click New to append a blank record and then click Save.","DBU")   
endif
return nil

function DBUdelrecclick
if .not. eof()
   delete
   DBUrefreshdbf()
endif
return nil
   
function DBUrecallclick
if deleted()
   recall
   DBUrefreshdbf()
endif
return nil

function DBUgotoclick
if _DBUeditdbf._DBUrecgoto.value > 0 
   if _DBUeditdbf._DBUrecgoto.value <= reccount()
      dbgoto(_DBUeditdbf._DBUrecgoto.value)
      DBUrefreshdbf()
      return nil
   else
      msginfo("You had entered a record number greater than the dbf size!","DBU")
      _DBUeditdbf._DBUrecgoto.value := reccount()
      _DBUeditdbf._DBUrecgoto.setfocus()
      return nil
   endif
endif
return nil
   
function DBUsearchclick
_DBUstructarr := dbstruct()
_DBUfieldsarr := {}
for _DBUi := 1 to len(_DBUstructarr)
   aadd(_DBUfieldsarr,{_DBUstructarr[_DBUi,1]})
next _DBUi
_DBUdbffunctions := {{"ctod()"},{"recno()"},{"max()"},{"min()"},{"deleted()"},{"alltrim()"},{"upper()"},{"lower()"},{"int()"},{"max()"}}
define window _DBUfilterbox at 0,0 width 650 height 400 title "Filter Box" modal nosize nosysmenu
   define editbox _DBUfiltercondition
      row 30
      col 30
      width 400
      height 100
      value _DBUcondition
   end editbox
   define grid _DBUfieldnames
      row 200
      col 30
      value 1
      headers {"Field Name"}
      widths {195}   
      items _DBUfieldsarr
      on dblclick _DBUfilterbox._DBUfiltercondition.value := alltrim(_DBUfilterbox._DBUfiltercondition.value)+" "+alltrim(_DBUfieldsarr[_DBUfilterbox._DBUfieldnames.value,1])
      width 200
      height 100
   end grid
   define button _DBUlessthan
      row 200
      col 250
      width 20
      caption "<"
      FLAT .T.
      action _DBUfilterbox._DBUfiltercondition.value := alltrim(_DBUfilterbox._DBUfiltercondition.value)+" <"
   end button   
   define button _DBUgreaterthan
      row 200
      col 280
      width 20
      caption ">"
      FLAT .T.
      action _DBUfilterbox._DBUfiltercondition.value := alltrim(_DBUfilterbox._DBUfiltercondition.value)+" >"
   end button   
   define button _DBUequal
      row 200
      col 310
      width 20
      caption "=="
      FLAT .T.
      action _DBUfilterbox._DBUfiltercondition.value := alltrim(_DBUfilterbox._DBUfiltercondition.value)+" =="
   end button   
   define button _DBUnotequal
      row 200
      col 340
      width 20
      caption "<>"
      FLAT .T.
      action _DBUfilterbox._DBUfiltercondition.value := alltrim(_DBUfilterbox._DBUfiltercondition.value)+" <>"
   end button   
   define button _DBUand
      row 240
      col 250
      width 40
      caption "and"
      FLAT .T.
      action _DBUfilterbox._DBUfiltercondition.value := alltrim(_DBUfilterbox._DBUfiltercondition.value)+" .and."
   end button   
   define button _DBUor
      row 240
      col 300
      width 40
      caption "or"
      FLAT .T.
      action _DBUfilterbox._DBUfiltercondition.value := alltrim(_DBUfilterbox._DBUfiltercondition.value)+" .or."
   end button   
   define button _DBUnot
      row 240
      col 350
      width 40
      caption "not"
      FLAT .T.
      action _DBUfilterbox._DBUfiltercondition.value := alltrim(_DBUfilterbox._DBUfiltercondition.value)+" .not."
   end button   
   define grid _DBUfunctions
      row 200
      col 400
      value 1
      headers {"Functions"}
      widths {195}   
      items _DBUdbffunctions
      on dblclick _DBUfilterbox._DBUfiltercondition.value := alltrim(_DBUfilterbox._DBUfiltercondition.value)+" "+alltrim(_DBUdbffunctions[_DBUfilterbox._DBUfunctions.value,1])
      width 200
      height 100
   end grid
   define button _DBUsetfilter
      row 340
      col 100
      caption "Set Filter"
      width 100
      FLAT .T.
      action DBUfilterset()
   end button
   define button _DBUclearfilter
      row 340
      col 250
      caption "Clear Filter"
      width 100
      FLAT .T.
      action DBUfilterclear()
   end button
end window 
center window _DBUfilterbox
activate window _DBUfilterbox   
return nil

function DBUcloseedit1
set filter to
release window _DBUeditdbf
return nil
   
function DBUrefreshdbf
if .not. eof()
   _DBUdbfname := alias()
   for _DBUi := 1 to len(_DBUcontrolarr)
      if _DBUcontrolarr[_DBUi,5] <> "H"
         if _DBUcontrolarr[_DBUi,5] <> "L" 
            _DBUpos1 := fieldpos(_DBUcontrolarr[_DBUi,3])
            if _DBUpos1 > 0
  	            _DBUeditdbf.&_DBUcontrolarr[_DBUi,3].value := iif(_DBUcontrolarr[_DBUi,5] == "C",alltrim((_DBUdbfname)->(fieldget(_DBUpos1))),(_DBUdbfname)->(fieldget(_DBUpos1)))
  	         endif   
	      else   
            _DBUpos1 := fieldpos(_DBUcontrolarr[_DBUi,3])
            if _DBUpos1 > 0
   	         if (_DBUdbfname)->(fieldget(_DBUpos1)) <> nil
     	            _DBUeditdbf.&_DBUcontrolarr[_DBUi,3].value := (_DBUdbfname)->(fieldget(_DBUpos1))
  	            endif   
	         endif   
         endif
      endif	 
   next _DBUi
else
   for _DBUi := 1 to len(_DBUcontrolarr)
      if _DBUcontrolarr[_DBUi,5] <> "H"
         do case
            case _DBUcontrolarr[_DBUi,5] == "C" .or. _DBUcontrolarr[_DBUi,5] == "M"
               _DBUeditdbf.&_DBUcontrolarr[_DBUi,3].value := ""
            case _DBUcontrolarr[_DBUi,5] == "N" 
               _DBUeditdbf.&_DBUcontrolarr[_DBUi,3].value := 0
            case _DBUcontrolarr[_DBUi,5] == "D" 
               _DBUeditdbf.&_DBUcontrolarr[_DBUi,3].value := date()
            case _DBUcontrolarr[_DBUi,5] == "L" 
               _DBUeditdbf.&_DBUcontrolarr[_DBUi,3].value := .f.
         endcase               
      endif	 
   next _DBUi
endif
_DBUcurrec := recno()   
count for deleted() to _DBUtotdeleted
dbgoto(_DBUcurrec)
_DBUeditdbf._DBUrecgoto.value := recno()
***if iscontroldefined(_DBUrecgotoslider,_DBUeditdbf)
if iscontroldefined(_DBUeditdbf,_DBUrecgotoslider)
   _DBUeditdbf._DBUrecgotoslider.value := recno()
endif   
_DBUeditdbf.statusbar.item(1) := "Record Pointer is at "+iif(eof(),"0",alltrim(str(recno(),10,0)))+" of "+alltrim(str(reccount(),10,0))+" record(s). "+alltrim(str(_DBUtotdeleted,5,0))+" record(s) are marked for deletion."
_DBUeditdbf.statusbar.item(2) := iif(deleted()," Del","")
_DBUeditdbf.statusbar.item(3) := iif(_DBUfiltered,"Filtered","")
_DBUeditdbf.statusbar.item(4) := iif(_DBUindexed,"Indexed","")
return nil

function DBUfilterset
_DBUcondition1 := alltrim(_DBUfilterbox._DBUfiltercondition.value)
if len(_DBUcondition1) == 0
   set filter to
   _DBUfiltered := .f.      
   release window _DBUfilterbox
   _DBUeditdbf._DBUgoto.enabled := .t.   
   _DBUeditdbf._DBUrecgoto.enabled := .t.
   DBUfirstclick()
else
   dbsetfilter({||&_DBUcondition1},_DBUcondition1)
   _DBUfiltered := .t.      
   release window _DBUfilterbox
   _DBUcondition := _DBUcondition1
   _DBUeditdbf._DBUgoto.enabled := .f.   
   _DBUeditdbf._DBUrecgoto.enabled := .f.
   DBUfirstclick()
endif
return nil

function DBUfilterclear
_DBUcondition := ""
_DBUfiltered := .f.   
set filter to
release window _DBUfilterbox
_DBUeditdbf._DBUgoto.enabled := .t.   
_DBUeditdbf._DBUrecgoto.enabled := .t.
DBUfirstclick()
return nil

function DBUindexchange
if _DBUeditdbf._DBUindexfield.value > 0
   if _DBUeditdbf._DBUindexfield.value == 1
      set index to
      _DBUindexed := .f.
      DBUrefreshdbf()   
   else
      _DBUindexfieldname := _DBUeditdbf._DBUindexfield.item(_DBUeditdbf._DBUindexfield.value)
      index on &_DBUindexfieldname to tmpindex
      _DBUindexed := .t.
      go top
      DBUrefreshdbf()
   endif
else
   set index to 
   _DBUindexed := .f.
endif
return nil