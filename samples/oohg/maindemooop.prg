/*
 * $Id: maindemooop.prg,v 1.3 2015-03-09 02:52:06 fyurisich Exp $
 */

/*
 * ooHG Main Demo oop
 * (c) 2005-2015 Vic
 * Taken from samples distributed in OOHG distro
 * by Ciro Vargas
 */

#include "oohg.ch"
#include "i_windefs.ch"
#include "i_graph.ch"

*-------------------------
Function Main()
*-------------------------
LOCAL oLabel
Local oWnd

PUblic _OOHG_printlibrary:="MINIPRINT"

set century on

SET TOOLTIPSTYLE BALLOON
SET TOOLTIPBACKCOLOR  {255,0,0 }
SET TOOLTIPFORECOLOR  {0,255,0 }

SET AUTOADJUST ON

oWnd := TFormMain():Define()
oWnd:col := 0
oWnd:row := 0
oWnd:width:=800
oWnd:height:=600
oWnd:title:="Main Demo oop version"
oWnd:OnClick:={|| msginfo(str(_OOHG_MouseRow)+str(_OOHG_MouseCol)) }


_DefineAnyKey( oWnd, "ESCAPE", {|| oWnd:Release } )

   DEFINE TOOLBAR Toolbr buttonsize 50,20
      BUTTON TBN1 CAPTION "Boton 1" ACTION MSGINFO("Toolbar 1!")
      BUTTON TBN2 CAPTION "Boton 2" ACTION MSGINFO("Toolbar 2!") dropdown
   END TOOLBAR

   DEFINE DROPDOWN MENU BUTTON TBN2
      ITEM "Tool 1" ACTION MSGINFO("Tool 1")
      ITEM "Tool 2" ACTION MSGINFO("Tool 2")
   END MENU

    oMenum := TMenuMain():Define( )
      oMenup := TMenuItem():DefinePopUp( "Uno" )
         oItem := TMenuItem():DefineItem( "1.1" , {|| MSGINFO("Menu 1.1")} , "menu1" )
         oMenup := TMenuItem():DefinePopUp( "1.2" , "menu2" )
            oItem := TMenuItem():DefineItem( "1.2.1" , {|| MSGINFO("Menu 1.2.1")} )
            oMenup:separator()
            oMenup := TMenuItem():DefinePopUp( "1.2.2" )
               oItem := TMenuItem():DefineItem( "1.2.2.1" , {|| MSGINFO("Menu 1.2.2.1")}  )
               oItem := TMenuItem():DefineItem( "1.2.2.2" , {|| MSGINFO("Menu 1.2.2.2")} )
               oItem := TMenuItem():DefineItem( "1.2.2.3" , {|| MSGINFO("Menu 1.2.2.3")} )
            oMenup:endpopup()
            oItem := TMenuItem():DefineItem( "1.2.3" , {|| MSGINFO("Menu 1.2.3")} )
         oMenup:endpopup()
         oItem := TMenuItem():DefineItem( "1.3" , {|| MSGINFO("Menu 1.3")} )
      oMenup:endpopup()
      oMenup := TMenuItem():DefinePopUp( "Dos" , "menu3"  )
         oItem := TMenuItem():DefineItem( "2.1" , {|| MSGINFO("Menu 2.1")} )
         oItem := TMenuItem():DefineItem( "2.2" , {|| MSGINFO("Menu 2.2")} )
         TMenuItem():DefineItem( "2.3" , {|| MSGINFO("Menu 2.3")} )
      oMenup:endpopup()
////      oMenup:separator()
      oItem := TMenuItem():DefineItem( "Dato" , {|| MSGINFO("Menu Dato")} , "menu4"  )
      oMenup := TMenuItem():DefinePopUp( "Tres" )
         oItem := TMenuItem():DefineItem( "3.1" , {|| MSGINFO("Menu 3.1")}  )
         oItem := TMenuItem():DefineItem( "3.2" , {|| MSGINFO("Menu 3.2")}  )
         oItem := TMenuItem():DefineItem( "3.3" , {|| MSGINFO("Menu 3.3")}  )
      oMenup:endpopup()
      oItem := TMenuItem():DefineItem( "Salir" , {|| oWnd:Release()}  )
   oMenum:endmenu()


   on key F5 action msginfo( str( olabel:row  )+str( olabel:col ),"Hello window" )

   oLabel := TLabel():Define()
   oLabel:Caption := "(F5) Hello!!"
   oLabel:AutoSize := .T.
   oLabel:Row := 40
   oLabel:Col := 400
   oLabel:Action := { || MSGINFO("CLICK!") }

   oHlink:= Thyperlink():Define()
   oHlink:Row := 40
   oHlink:Autosize := .T.
   oHlink:Col := 10
   oHlink:Caption := "www.yahoo.com.mx"
   oHlink:Address := "http://www.yahoo.com.mx"

   oText1 := Ttext():Define()
   oText1:row   := 70
   oText1:col   := 10
   oText1:width := 150
   oText1:height:= 17
   oText1:value := "This is a TEXTBOX!"
   oText1:BAckcolor:=  { GetRed( GetSysColor( COLOR_3DFACE ) ), GetGreen( GetSysColor( COLOR_3DFACE ) ), GetBlue( GetSysColor( COLOR_3DFACE ) ) }
   ////oText1:Noborder := .T.


   @ 90,10 TEXTBOX Txt2 VALUE "0940100101000000" WIDTH 150  height 20 INPUTMASK "@R 999-99-999-99-!!-!!!!" AUTOSKIP

   oLabel := oWnd:Txt2

   oLbl3 := Tlabel():Define()
   oLbl3:row := 110
   oLbl3:col := 10
   oLbl3:value := "Press '-'"
   oLbl3:autosize := .T.

   @ 110,60 TEXTBOX Txt3 VALUE "1234567" WIDTH 100 height 20 INPUTMASK "@R 999.999-9" RIGHTALIGN
   oWnd:Txt3:SetKey( VK_SUBTRACT,  0, { || MoveCursor( oWnd:Txt3 ) } )
   oWnd:Txt3:SetKey( VK_OEM_MINUS, 0, { || MoveCursor( oWnd:Txt3 ) } )
   oWnd:Txt3:OnLostFocus := { || MoveCursor( oWnd:Txt3 ) }

////   @ 130,10 TEXTBOX Txt4 VALUE 111.5 WIDTH 150 height 20 numeric INPUTMASK "999,999.99"

   otxt4:=TTextpicture():Define()
   otxt4:row := 130
   otxt4:col := 10
   otxt4:picture :=  "999,999.99"
   otxt4:value := 111.5
   oTxt4:transparent := .t.

   ////@ 150,10 TEXTBOX Txt5 obj od VALUE date() WIDTH 150 height 20 DATE


   ///DefineTextBox( "Txt5", , 10, 150, 150, 20, date(),,,,, .F., .F., .F.,,,,, .F.,, .F. ,.F., .F., .F., .F. , , , , .F. , .F. , .F., .F., .F.,, .F.,, .T., .F.,,, )

   oTextd := Ttextpicture():Define(,, , , , ,date() ,,,,,  , , ,,,,, ,,  ,, , ,  , , , ,  ,  , , , ,, ,, .T. , ,,,)
   oTextd:row   := 150
   oTextd:col   := 10
   oTextd:width := 150
   oTextd:height:= 20

///   oTextd:value := DATE()


   ochk1:= tcheckbox():Define()
   oChk1:name:="Chk"
   ochk1:row :=170
   ochk1:col := 10
   ochk1:caption := "This control has a context menu!"
   ochk1:value := .T.
   ochk1:onchange :=   {|| msginfo( "change!" ) }
   ochk1:autosize := .T.


   oBtn1 := Tbutton():Define()
   oBtn1:row := 200
   oBtn1:col := 10
   oBtn1:caption := "BUTTON!"
   oBtn1:tooltip := "Click me!"
   oBtn1:action := {|| msginfo(oLabel:vALUE) }


   orad := Tradiogroup():Define(,,10 ,230, { "Uno", "Dos", "Tres" })

   orad:autosize:= .T.
   oRAD:aControls[3]:BACKCOLOR := BLUE
   oRAD:aControls[3]:WIDTH := 100
   oRAD:aControls[3]:COL := 70
   oRAD:aControls[1]:COL := 50
   oRAD:aControls[2]:BACKCOLOR := {255,0,0}
   oRAD:aControls[2]:caption := orAD:aControls[2]:caption
   oRAD:aControls[2]:tooltip := "Individual tooltip"


   oWnd:menu1:checked := .t.
   oWnd:menu2:checked := .t.
   oWnd:menu3:enabled := .f.
   oWnd:menu4:enabled := .f.


   oMcl := Tmonthcal():Define()
   oMcl:row := 320
   oMcl:col := 10
   oMcl:value := date()


     omenuc:=TMenuDropDown():Define( "Chk" , )
       opop:=TMenuItem():DefinePopUp( "Nivel 1" )
          TMenuItem():DefineItem( "Nivel 1.1" , {|| MsgInfo( "Nivel 1.1!" )} ) 
          TMenuItem():DefineItem( "Nivel 1.2" , {|| MsgInfo( "Nivel 1.2!" )} )
       opop:endpopup()
       opop1:=TMenuItem():DefinePopUp( "Nivel 2" )
          TMenuItem():DefineItem( "Nivel 2.1" , {|| MsgInfo( "Nivel 2.1!" )} )
          TMenuItem():DefineItem( "Nivel 2.2" , {|| MsgInfo( "Nivel 2.2!" )} )
       opop1:endpopup()
     omenuc:endmenu()

//   @  0,200 GRID grd obj ogrid1 width 150 height 100 headers { "UNO", "DOS", "TRES" } widths {45,45,45} edit ;
//   items { {"1","2","3"},{"A","@","C"},{"x","y","z"} } ;
//   JUSTIFY { GRID_JTFY_RIGHT, GRID_JTFY_CENTER, GRID_JTFY_LEFT } ;
//   FONTCOLOR ORANGE;
//   DYNAMICBACKCOLOR { RGB(0,255,0), , RGB(255,0,0) } ;
//   DYNAMICFORECOLOR { NIL, RGB(255,255,0), NIL } ;
 //  ON headclick { {|| ogrid1:toexcel } , {|| NIL}, {|| NIL}   }

/*   ogrid1:= tgrid():Define()
   ogrid1:row := 40
   ogrid1:col := 200
   ogrid1:width := 150
   ogrid1:height := 100
   ogrid1:aheaders := { "UNO", "DOS", "TRES" }
   ogrid1:AddItem( {"1","2","3"}, NIL, NIL )
///   ogrid1:awidths :=  {45,45,45}
///   ogrid1:aitems :=  { {"1","2","3"},{"A","@","C"},{"x","y","z"} }
   ogrid1:ajust :=  { GRID_JTFY_RIGHT, GRID_JTFY_CENTER, GRID_JTFY_LEFT }
   ogrid1:fontcolor := ORANGE
   ogrid1:dynamicbackcolor :=  { RGB(0,255,0), , RGB(255,0,0) }
   ogrid1:dynamicforecolor :=  { NIL, RGB(255,255,0), NIL }
   ogrid1:Aheadclick :=  { {|| ogrid1:toexcel() } , {|| NIL}, {|| NIL}   }
   ogrid1:SetRangeColor( 0, , 2, 2 )
*/
   define tab tab at 140,210 width 150 height 100
      ownd:tab:transparent := .t.
      define page "uno"
      @ 30,10 label ll1 value "tab 1" autosize
      end page
      define page "dos"
      @ 50,10 label ll2 value "tab 2" autosize
      end page
      define page "tres"
      @ 30,10 label ll3 value "tab 3" autosize

      define tab tab2 at 50,10 width 150 height 50
         define page "aaa"
         @ 30,10 label ll4 value "tab a" autosize
         end page
         define page "bbb"
         @ 30,14 label ll5 value "tab b" autosize
         end page
         define page "ccc"
         @ 30,18 label ll6 value "tab c" autosize
         end page
      end tab

      end page
   end tab

   ospin:= tspinner():Define()
   ospin:row := 250
   ospin:col := 200
   ospin:width := 150
   ospin:height := 20
   ospin:rangemin := 0
   ospin:rangemax := 100

   oCombo:= tcombo():Define()
   oCombo:row :=280
   oCombo:col := 200
   oCombo:width := 150
   oCombo:additem("Uno")
   oCombo:additem("Dos")
   oCombo:additem("tres")

   oDatep:= tdatepick():Define()
   oDatep:row := 310
   oDatep:col := 240
   oDatep:value := DATE()

////  normal oop
//    oTimep:= ttimepick():Define()
//    oTimep:row :=513
//    oTimep:col :=21
//    oTimep:value := time()

///// otra forma con object
    With object oTimep:=ttimepick():Define()
       :row := 513
       :col := 21
       :value :=time()
    End

   oprogm:=TProgressMeter():Define()
   Oprogm:row := 350
   oprogm:col := 240
   oprogm:width := 120
   oprogm:height := 20
   oprogm:value := 75
   


   DEFINE WINDOW internal obj ointernal AT 390,240 WIDTH 120 HEIGHT 100 INTERNAL VIRTUAL WIDTH 200 VIRTUAL HEIGHT 150
   @ 10, 10 LABEL LabelRed   VALUE "A" WIDTH 50 HEIGHT 100 CENTER BACKCOLOR RED
   @ 10, 60 LABEL LabelGreen VALUE "B" WIDTH 50 HEIGHT 100 CENTER BACKCOLOR GREEN
   @ 10,110 LABEL LabelBlue  VALUE "C" WIDTH 50 HEIGHT 100 CENTER BACKCOLOR BLUE
   END WINDOW



DEFINE TREE Tree_1 AT 80,400 WIDTH 150 HEIGHT 240 VALUE 15

   NODE 'Item 1'
   TREEITEM 'Item 1.1'
   TREEITEM 'Item 1.2' ID 999
   TREEITEM 'Item 1.3'
   END NODE

   NODE 'Item 2'

   TREEITEM 'Item 2.1'

   NODE 'Item 2.2'
   TREEITEM 'Item 2.2.1'
   TREEITEM 'Item 2.2.2'
   TREEITEM 'Item 2.2.3'
   TREEITEM 'Item 2.2.4'
   TREEITEM 'Item 2.2.5'
   TREEITEM 'Item 2.2.6'
   END NODE

   TREEITEM 'Item 2.3'

   END NODE

   NODE 'Item 3'
   TREEITEM 'Item 3.1'
   TREEITEM 'Item 3.2'

   NODE 'Item 3.3'
   TREEITEM 'Item 3.3.1'
   TREEITEM 'Item 3.3.2'
   END NODE

   END NODE

END TREE

obtn2:=tbutton():Defineimage()
obtn2:row:=330
obtn2:col:=400
obtn2:width :=100
obtn2:height:=100
obtn2:Picture:="RESOURCES\EDIT_NEW.BMP"
oBtn2:ToolTip := "Graph Print"
oBtn2:Action := { || printform( ) }


obtn3:=tbutton():Defineimage()
obtn3:row:=330
obtn3:col:=510
obtn3:width :=90
obtn3:height:=90
obtn3:Picture:="RESOURCES\EDIT_NEW.BMP"
oBtn3:ToolTip := "Tprint examples"
oBtn3:Action := { || test( ) }

oframe:= tframe():Define()
oframe:row := 10
oframe:col := 600
oframe:width := 150
oframe:height := 60
oframe:caption := "Frame"

otip:= tipaddress():Define()
otip:row := 30
otip:col := 610
otip:width := 130
otip:value := {1,2,3,4}


oprog:= tprogressbar():Define()
oprog:row := 90
oprog:col := 600
oprog:width := 150
oprog:height := 20
oprog:rangemin :=0
oprog:rangemax := 100
oprog:value := 50


oedit:= tedit():Define()
oedit:Row := 120
oedit:Col := 600
oedit:width := 150
oedit:height := 60
oedit:value :=  "texto1"

orich:= teditrich():Define()
orich:row := 200
orich:col := 600
orich:width := 150
orich:height := 60
orich:value :=  "texto2"

olist:= tlistmulti():Define()
olist:row := 280
olist:col := 600
olist:width := 150
////olist:rows := {"uno","dos","tres"}
olist:additem("Uno")
olist:additem("Dos")
olist:additem("Tres")



DEFINE STATUSBAR

   STATUSITEM "This is a statusbar test!" ACTION MSGINFO( "Statusbar!" )
   CLOCK ACTION MSGINFO( "Clock!" )

END STATUSBAR

ownd:EndWindow()
ownd:Center()
ownd:activate()
Return


*-------------------------
function printform( )
*-------------------------

Public aSer:={ {14280,20420,12870,25347, 7640},;
               { 8350,10315,15870, 5347,12340},;
               {12345, -8945,10560,15600,17610} }


	Define Window GraphTest obj graphtest ;
		At 0,0 ;
		Width 640 ;
		Height 480 ;
		Title "Printing Bar Graphs" ;
		 modal ;
                BACKCOLOR {255,255,255 } ;
		On Init DrawBarGraph ( aser ) ;
                on mouseclick graphtest:print()


	End Window

	GraphTest.Center

	Activate Window GraphTest

Return

Procedure DrawBarGraph ( aSer )

	ERASE WINDOW GraphTest

	DRAW GRAPH							;
		IN WINDOW GraphTest					;
		AT 20,20						;
		TO 400,610						;
		TITLE "Sales and Product"				;
		TYPE BARS						;
		SERIES aSer						;
		YVALUES {"Jan","Feb","Mar","Apr","May"}			;
		DEPTH 15						;
		BARWIDTH 15						;
		HVALUES 5						;
		SERIENAMES {"Serie 1","Serie 2","Serie 3"}		;
		COLORS { {128,128,255}, {255,102, 10}, {55,201, 48} }	;
		3DVIEW    						;
		SHOWGRID                        			;
		SHOWXVALUES                     			;
		SHOWYVALUES                     			;
		SHOWLEGENDS

Return nil


*-------------------------------
PROCEDURE MoveCursor( oCtrl )
*-------------------------------
   oCtrl:Value := PADL( STRTRAN( LEFT( oCtrl:Value, 6 ), " ", "" ), 6 ) + RIGHT( oCtrl:Value, 1 )
   oCtrl:CaretPos := 8
RETURN

#include "printtest.prg"

