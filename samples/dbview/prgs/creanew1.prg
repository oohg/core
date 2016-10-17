/*
 * $Id: creanew1.prg,v 1.2 2016-10-17 01:55:33 fyurisich Exp $
 */

/*
 *
 * MINIGUI - Harbour Win32 GUI library
 * Copyright 2002-2012 Roberto Lopez <harbourminigui@gmail.com>
 * http://harbourminigui.googlepages.com/
 *
 * Program to view DBF files using standard Browse control
 * Miguel Angel Juárez A. - 2009-2012 MigSoft <mig2soft/at/yahoo.com>
 * Includes the code of Grigory Filatov <gfilatov@inbox.ru>
 * and Rathinagiri <srathinagiri@gmail.com>
 *
 */

#include "oohg.ch"
#include "dbuvar.ch"

function DBUcreanew(cBase)

_DBUstructarr := {}
_DBUdbfsaved := .f.

_dbufname := cBase

DEFINE WINDOW _DBUcreadbf AT 295 , 312 WIDTH 549 HEIGHT 266 title PROGRAM+VERSION+"- Create a New DataBase Table (.dbf)" MODAL nosize nosysmenu

     DEFINE TEXTBOX _DBUfieldname
            ROW    40
            COL    30
            WIDTH  120
            HEIGHT 24
     END TEXTBOX 

     DEFINE COMBOBOX _DBUfieldtype
            ROW    40
            COL    160
            WIDTH  120
            HEIGHT 100
            ITEMS {"Character","Numeric","Date","Logical","Memo"}
            VALUE 1
            ON LOSTFOCUS DBUtypelostfocus()
            ON ENTER DBUtypelostfocus()
     END COMBOBOX

     DEFINE LABEL _DBUnamelabel
            ROW    20
            COL    30
            WIDTH  80
            HEIGHT 20
            VALUE "Field"
     END LABEL  

     DEFINE LABEL _DBUtypelabel
            ROW    20
            COL    160
            WIDTH  80
            HEIGHT 20
            VALUE "Type"
     END LABEL  

     DEFINE LABEL _DBUsizelabel
            ROW    20
            COL    290
            WIDTH  60
            HEIGHT 20
            VALUE "Size"
     END LABEL

     DEFINE LABEL _DBUdecimallabel
            ROW    20
            COL    360
            WIDTH  60
            HEIGHT 16
            VALUE "Digits"
     END LABEL  

     DEFINE SPINNER _DBUfieldsize
            ROW    40
            COL    290
            WIDTH  60
            HEIGHT 24
            RANGEMIN 1
            RANGEMAX 100
            VALUE 10
            on lostfocus DBUsizelostfocus()
     END SPINNER  

     DEFINE SPINNER _DBUfielddecimals
            ROW    40
            COL    360
            WIDTH  60
            HEIGHT 24
            RANGEMIN 0
            RANGEMAX 99
            on lostfocus DBUdeclostfocus()
     END SPINNER

    DEFINE BUTTON _DBUaddline
           ROW    40
           COL    430
           WIDTH  80
           HEIGHT 28
           CAPTION "Add"
           action DBUaddstruct()
     END BUTTON  

    DEFINE BUTTON _DBUinsline
           ROW    70
           COL    430
           WIDTH  80
           HEIGHT 28
           CAPTION "Insert"
           action DBUinsstruct()
     END BUTTON  

    DEFINE BUTTON _DBUdelline
           ROW    100
           COL    430
           WIDTH  80
           HEIGHT 28
           CAPTION "Delete"
           action DBUdelstruct()
     END BUTTON

     DEFINE GRID _DBUstruct
            ROW    80
            COL    30
            WIDTH  390
            HEIGHT 120
            WIDTHS {145,80,70,70}
            HEADERS {"Name","Type","Size","Decimals"}
            justify {0,0,1,1}
            items _DBUstructarr
            on dblclick DBUlineselected()
     END GRID

    DEFINE BUTTON _DBUsavestruct
           ROW    140
           COL    430
           WIDTH  80
           HEIGHT 28
           CAPTION "Create"
           action DBUsavestructure()
     END BUTTON

    DEFINE BUTTON _DBUexitnew
           ROW    170
           COL    430
           WIDTH  80
           HEIGHT 28
           CAPTION "Exit"
           action DBUexitcreatenew()
     END BUTTON

END WINDOW

center window _DBUcreadbf
activate window _DBUcreadbf
return nil

function DBUexitcreatenew
if len(_DBUstructarr) == 0 .or. _DBUdbfsaved
//   DBUtogglemenu()
   release window _DBUcreadbf
else
   if msgyesno("Are you sure to abort creating this dbf?",PROGRAM)
//      DBUtogglemenu()
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
      msgexclamation("Field size can not be zero!",PROGRAM)
      _DBUcreadbf._DBUfieldsize.setfocus()
      
      return nil
   endif
   DBUtypelostfocus()
   DBUsizelostfocus()
   DBUdeclostfocus()
   if _DBUcreadbf._DBUfieldtype.value == 2 .and. _DBUcreadbf._DBUfielddecimals.value >= _DBUcreadbf._DBUfieldsize.value
      msgexclamation("You can not have decimal points more than the size!",PROGRAM)
      _DBUcreadbf._DBUfielddecimals.setfocus()
      
      return nil
   endif
   if len(_DBUstructarr) > 0
      for _DBUi := 1 to len(_DBUstructarr)
         if upper(alltrim(_DBUcreadbf._DBUfieldname.value)) == upper(alltrim(_DBUstructarr[_DBUi,1]))
            msgexclamation("Duplicate field names are not allowed!",PROGRAM)
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
         msgexclamation("Field size can not be zero!",PROGRAM)
         _DBUcreadbf._DBUfieldsize.setfocus()

         return nil
      endif
      DBUtypelostfocus()
      DBUsizelostfocus()
      DBUdeclostfocus()
      if _DBUcreadbf._DBUfieldtype.value == 2 .and. _DBUcreadbf._DBUfielddecimals.value >= _DBUcreadbf._DBUfieldsize.value
         msgexclamation("You can not have decimal points more than the size!",PROGRAM)
         _DBUcreadbf._DBUfielddecimals.setfocus()
         
         return nil
      endif
      if len(_DBUstructarr) > 0
         for _DBUi := 1 to len(_DBUstructarr)
            if upper(alltrim(_DBUcreadbf._DBUfieldname.value)) == upper(alltrim(_DBUstructarr[_DBUi,1])) .and. _DBUi <> _DBUcurline
               msgexclamation("Duplicate field names are not allowed!",PROGRAM)
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
   msgexclamation("Field size can not be zero!",PROGRAM)
   _DBUcreadbf._DBUfieldsize.setfocus()
   
   return nil
endif
DBUtypelostfocus()
DBUsizelostfocus()
DBUdeclostfocus()
if _DBUcreadbf._DBUfieldtype.value == 2 .and. _DBUcreadbf._DBUfielddecimals.value >= _DBUcreadbf._DBUfieldsize.value
   msgexclamation("You can not have decimal points more than the size!",PROGRAM)
   _DBUcreadbf._DBUfielddecimals.setfocus()
   
   return nil
endif
if len(_DBUstructarr) > 0
   for _DBUi := 1 to len(_DBUstructarr)
      if upper(alltrim(_DBUcreadbf._DBUfieldname.value)) == upper(alltrim(_DBUstructarr[_DBUi,1]))
         msgexclamation("Duplicate field names are not allowed!",PROGRAM)
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
public _DBUi := 0
if len(_DBUname) == 0
   msgexclamation("Field Name can not be empty!",PROGRAM)
   _DBUcreadbf._DBUfieldname.setfocus()
   return .f.
endif
if val(substr(_DBUname,1,1)) > 0 .or. substr(_DBUname,1,1) == "_"
   msgexclamation("First letter of the field name can not be a numeric character or special character!",PROGRAM)
   _DBUcreadbf._DBUfieldname.setfocus()
   return .f.
else
   for _DBUi := 1 to len(_DBUname)
      if at(upper(substr(_DBUname,_DBUi,1)),_DBUlegalchars) == 0
         msgexclamation("Field name contains illegal characters. Allowed characters are alphabets, numbers and the special character '_'.",PROGRAM)
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
      if msgyesno("Are you sure to create this database file?",PROGRAM)
         dbcreate(_DBUfname1,_DBUstructarr)
	      msginfo("File has been created successfully",PROGRAM)
*	      if .not. used()
*  	         use &_DBUfname1
*	         _DBUfname := _DBUfname1
*	         _DBUdbfopened := .t.
//                 DBUtogglemenu()
                 release window _DBUcreadbf
*	      else
*                 release window _DBUcreadbf
*   	   endif
      endif
   endif
endif
return nil
