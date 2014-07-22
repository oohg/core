/*
 * $Id: moside.prg,v 1.7 2014-07-22 00:53:19 fyurisich Exp $
 */

#include 'oohg.ch'

DECLARE WINDOW Form_1

*** move / size / delete
*--------------------------------
function KMove( myIDe )  //// keyboard move
*--------------------------------
   if nhandlep=0
      MsgStop( "You must select a control first.","OOHG IDE+")
      return nil
   endif

   if myform:ncontrolw=1
      return nil
   endif
   swkm:=.T.
   ON KEY LEFT       OF Form_1 ACTION KMueve( "L", myIDe )
   ON KEY RIGHT      OF Form_1 ACTION KMueve( "R", myIDe )
   ON KEY UP         OF Form_1 ACTION KMueve( "U", myIDe )
   ON KEY DOWN       OF Form_1 ACTION KMueve( "D", myIDe )
   ON KEY ESCAPE     OF Form_1 ACTION KMueve( "E", myIDe )
	ON KEY CTRL+LEFT  OF Form_1 ACTION KMueve( "W-", myIDe )
   ON KEY CTRL+RIGHT OF Form_1 ACTION KMueve( "W+", myIDe )
   ON KEY CTRL+UP    OF Form_1 ACTION KMueve( "H-", myIDe )
   ON KEY CTRL+DOWN  OF Form_1 ACTION KMueve( "H+", myIDe )

   if iscontroldefined(statusbar,form_1)
      form_1.statusbar.release()
   endif
   DEFINE STATUSBAR of form_1
        STATUSITEM ""
   END STATUSBAR
   kmueve( "", myIDe )
return nil

*------------------------
FUNCTION KMueve( cPar, myIde )
*------------------------
LOCAL jj, nR, nC, nCaux, nRaux, oControlm

   IF nHandleP == 0
      RETURN NIL
   ENDIF
   jj := nHandleP
   oControlm := GetFormObject( "Form_1" ):aControls[jj]
   cName := oControlm:Name
   Dibuja( cName )
   h := GetFormHandle( myForm:DesignForm )
   BaseRow := GetWindowRow( h ) + GetBorderHeight()
   BaseCol := GetWindowCol( h ) + GetBorderWidth()
   nR := oControlm:Row + BaseRow + GetTitleHeight() + GetBorderHeight() + 18
   nC := oControlm:Col + BaseCol + ( oControlm:Width / 2 )
   SetCursorPos( nC , nR )

   DO CASE
   CASE cPar == "L"
      Form_1:&cName:Col := Form_1:&cName:Col - IIF( myIde:lSnap == 1, myIde:nPxMove, 1 )
      myForm:lFSave := .F.
   CASE cPar == "R"
      Form_1:&cName:Col := Form_1:&cName:Col + IIF( myIde:lSnap == 1, myIde:nPxMove, 1 )
      myForm:lFSave := .F.
   CASE cPar == "U"
      Form_1:&cName:Row := Form_1:&cName:Row - IIF( myIde:lSnap == 1, myIde:nPxMove, 1 )
      myForm:lFSave := .F.
   CASE cPar == "D"
      Form_1:&cName:Row := Form_1:&cName:Row + IIF( myIde:lSnap == 1, myIde:nPxMove, 1 )
      myForm:lFSave := .F.
   CASE cPar == "W-"
      Form_1:&cName:Width := Form_1:&cName:Width - IIF( myIde:lSnap == 1, myIde:nPxSize, 1 )
      myForm:lFSave := .F.
   CASE cPar == "W+"
      Form_1:&cName:Width := Form_1:&cName:Row + IIF( myIde:lSnap == 1, myIde:nPxSize, 1 )
      myForm:lFSave := .F.
   CASE cPar == "H-"
      Form_1:&cName:Height := Form_1:&cName:Row - IIF( myIde:lSnap == 1, myIde:nPxSize, 1 )
      myForm:lFSave := .F.
   CASE cPar == "H+"
      Form_1:&cName:Height := Form_1:&cName:Row + IIF( myIde:lSnap == 1, myIde:nPxSize, 1 )
      myForm:lFSave := .F.
   CASE cPar == "E"
      RELEASE KEY LEFT   OF Form_1
      RELEASE KEY RIGHT  OF Form_1
      RELEASE KEY UP     OF Form_1
      RELEASE KEY DOWN   OF Form_1
      RELEASE KEY ESCAPE OF Form_1
      swkm := .F.
      Form_1.StatusBar.Release
      IF myForm:lSStat
         DEFINE STATUSBAR OF Form_1
         IF Len( myForm:cSCaption ) > 0
            STATUSITEM myForm:cSCaption
         ELSE
            STATUSITEM ""
         ENDIF
         IF myForm:lSKeyboard
            KEYBOARD
         ENDIF
         IF myForm:lSDate
            DATE WIDTH 90
         ENDIF
         IF myForm:lSTime
            CLOCK WIDTH 90
         ENDIF
         END STATUSBAR
      ENDIF
      IF myIde:lSnap == 1
         Snap( cName )
      ENDIF
   ENDCASE

   IF swkm
      Form_1.StatusBar.Item( 1 ) := " Row = " + Str( Form_1:&cName:Row, 4 ) + "  Col = " + Str( Form_1:&cName:Col, 4 ) + "  Use Arrow Keys to Move and [Esc] To Exit Keyboard Move"
   ENDIF
   Dibuja1( jj )
RETURN NIL

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
FUNCTION MoveControl( myIde )
*------------------------------------------------------------------------------*
local i, iRow, iCol, iWidth, iHeight, h, j, k, l, z, eRow, eCol, dRow, dCol, BaseRow, BaseCol, BaseWidth, BaseHeight, TitleHeight, BorderWidth, BorderHeight , CurrentPage, IsInTab, SupMin, iMin, cname, jk, jl, ocontrol

   jk := nhandlep
   if jk > 0
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
      Dibuja1( jk )
   endif
RETURN NIL

*------------------------------------------------------------------------------*
FUNCTION SizeControl()
*------------------------------------------------------------------------------*
local i, iRow, iCol, iWidth, iHeight, eHeight, eWidth, j, k, z, Controlhandle, AbortSize := .f., ControlIndex, h, l, BaseRow, BaseCol, BaseWidth, BaseHeight, TitleHeight, BorderWidth, BorderHeight, SupMin, iMin, jk, jl, ocontrol

   jk := nhandlep
   if jk > 0
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
      Dibuja1( jk )
   endif
RETURN NIL

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
FUNCTION DeleteControl()
*------------------------------------------------------------------------------*
LOCAL ia, i, j, k, x, z, h, l, SupMin, iMin
LOCAL swf, jl, jk, ocontrol, jcvc

   if myform:ncontrolw=1
      return nil
   endif
   swf:=0
   jl:=0
   jk:=0
   ia := nhandlep
   if ia > 0  .and. ! siesdeste(ia,'TAB')  &&&& si no es tab
      ocontrol:=getformobject('Form_1'):acontrols[ia]
      jcvc := ascan( myform:acontrolw, { |c| lower( c ) ==  lower(ocontrol:name)  } )
      if jcvc>1
         if .not. msgyesno('Are you sure you want to delete control ' + myform:aname[jcvc] + ' ?', "OOHG IDE+" )
            return nil
         endif
         cname:=lower(ocontrol:name)
         form_1:&cname:release()
         myform:iniarray(myform:nform,jcvc,'','',.T.)
        ////////// ojo aqui adel
      endif
      myform:lFsave:=.F.
      ERASE WINDOW Form_1
      cordenada()
      mispuntos()
      RefreshControlInspector()
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
ERASE WINDOW Form_1
mispuntos()
RefreshControlInspector()
return

*------------------------------
FUNCTION ManualMoSI( nOpcion, myIde )
*------------------------------
LOCAL jl, oControl, jk, cName, cNameW, nRow, nCol, nWidth, nHeight, cTitle, aLabels, aInitValues, aFormats, aResults, lChanged

   IF myForm:nControlW == 1
      RETURN NIL
   ENDIF
   lChanged := .F.
   IF nOpcion == 1
      jl := nHandleP
      IF jl > 0
         oControl := GetFormObject( 'Form_1' ):aControls[jl]
         jk := aScan( myform:aControlW, { |c| Lower( c ) == Lower( oControl:Name ) } )

         cName   := myform:aControlW[jk]
         cNameW  := myform:aName[jk]
         nRow    := Form_1:&cName:Row
         nCol    := Form_1:&cName:Col
         nWidth  := Form_1:&cName:Width
         nHeight := Form_1:&cName:Height
         cTitle  := cName + " Move/Size properties"

         IF SiEsDEste( jl, 'RADIOGROUP' )
            aLabels     := { 'Row', 'Col', 'Width' }
            aInitValues := { nRow, nCol, nWidth }
            aFormats    := { '9999', '9999', '9999' }
            aResults    := myInputWindow( cTitle, aLabels, aInitValues, aFormats )
            IF aResults[1] == NIL
               RETURN NIL
            ENDIF
            IF aResults[1] >= 0
               lChanged := .T.
               Form_1:&cName:Row := aResults[1]
            ENDIF
            IF aResults[2] >= 0
               lChanged := .T.
               Form_1:&cName:Col := aResults[2]
            ENDIF
            IF aResults[3] >= 0
               lChanged := .T.
               Form_1:&cName:Width := aResults[3]
            ENDIF
         ELSE
            aLabels     := { 'Row', 'Col', 'Width', 'Height' }
            aInitValues := { nRow, nCol, nWidth, nHeight }
            aFormats    := { '9999', '9999', '9999', '9999' }
            aResults    := myInputWindow( cTitle, aLabels, aInitValues, aFormats )
            IF aResults[1] == NIL
               RETURN NIL
            ENDIF
            IF aResults[1] >= 0
               lChanged := .T.
               Form_1:&cName:Row := aResults[1]
            ENDIF
            IF aResults[2] >= 0
               lChanged := .T.
               Form_1:&cName:Col := aResults[2]
            ENDIF
            IF ! SiEsDEste( jl, 'MONTHCALENDAR' ) .AND. ! SiEsDEste( jl, 'TIMER' )
               IF aResults[3] >= 0
                  lChanged := .T.
                  Form_1:&cName:Width  := aResults[3]
               ENDIF
               IF aResults[4] >= 0
                  lChanged := .T.
                  Form_1:&cName:Height := aResults[4]
               ENDIF
            ENDIF
         ENDIF
         IF lChanged
            IF myIde:lSnap == 1
               Snap( cName )
            ENDIF
            Dibuja1( jl )
            myForm:lFSave := .F.
         ENDIF
      ENDIF
   ELSE
      nRow    := Form_1.Row
      nCol    := Form_1.Col
      nWidth  := Form_1.Width
      nHeight := Form_1.Height
      cTitle  := " Form Move/Size properties"

      aLabels     := { 'Row', 'Col', 'Width', 'Height' }
      aInitValues := { nRow, nCol, nWidth, nHeight }
      aFormats    := { '9999', '9999', '9999', '9999' }
      aResults    := myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         RETURN NIL
      ENDIF
      IF aResults[1] >= 0
         lChanged := .T.
         Form_1.Row := aResults[1]
      ENDIF
      IF aResults[2] >= 0
         lChanged := .T.
         Form_1.Col := aResults[2]
      ENDIF
      IF aResults[3] >= 0
         lChanged := .T.
         Form_1.Width := aResults[3]
      ENDIF
      IF aResults[4] >= 0
         lChanged := .T.
         Form_1.Height := aResults[4]
      ENDIF
      IF lChanged
         myForm:lFSave := .F.
      ENDIF
   ENDIF
RETURN NIL

*--------------------------------------
FUNCTION MyInteractiveMoveHandle( handle )
*--------------------------------------
   ERASE WINDOW Form_1
   MisPuntos()
   InteractiveMoveHandle( handle )
RETURN NIL

********** chequeo para ver si es frame o no
*-----------------------
function CheckIfIsFrame()
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
