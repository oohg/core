/*
 * $Id: hello.prg,v 1.8 2005-10-08 15:47:46 declan2005 Exp $
 */
/*
* ooHG Hello World Demo
* (c) 2005 Vic
*/

#include "oohg.ch"

Function Main()
LOCAL oLabel
Private oWnd


set cent on

        DEFINE WINDOW Win_1 OBJ oWnd ;
		AT 0,0 ;
                WIDTH 640 ;
                HEIGHT 480 ;
		TITLE 'Hello World!' ;
                on mouseclick msginfo(str(_OOHG_MouseRow)+str(_OOHG_MouseCol)) ;
                MAIN ;
                virtual height 768 ;
                virtual WIDTH 1024

                // oWnd := GetFormObject( "Win_1" )

                DEFINE TOOLBAR Toolbr buttonsize 50,20
                    BUTTON TBN1 CAPTION "Boton 1" ACTION MSGINFO("Toolbar 1!")
                    BUTTON TBN2 CAPTION "Boton 2" ACTION MSGINFO("Toolbar 2!") dropdown
                END TOOLBAR

                DEFINE DROPDOWN MENU BUTTON TBN2
                   ITEM "Tool 1" ACTION MSGINFO("Tool 1")
                   ITEM "Tool 2" ACTION MSGINFO("Tool 2")
                END MENU

                DEFINE MAIN MENU
                    POPUP "Uno"
                       ITEM "1.1" ACTION MSGINFO("Menu 1.1") name menu1
                       POPUP "1.2" name menu2
                          ITEM "1.2.1" ACTION MSGINFO("Menu 1.2.1")
                          SEPARATOR
                          POPUP "1.2.2"
                              ITEM "1.2.2.1" ACTION MSGINFO("Menu 1.2.2.1")
                              ITEM "1.2.2.2" ACTION MSGINFO("Menu 1.2.2.2")
                              ITEM "1.2.2.3" ACTION MSGINFO("Menu 1.2.2.3")
                          END POPUP
                          ITEM "1.2.3" ACTION MSGINFO("Menu 1.2.3")
                       END POPUP
                       ITEM "1.3" ACTION MSGINFO("Menu 1.3")
                    END POPUP
                    POPUP "Dos" name menu3
                       ITEM "2.1" ACTION MSGINFO("Menu 2.1")
                       ITEM "2.2" ACTION MSGINFO("Menu 2.2")
                       ITEM "2.3" ACTION MSGINFO("Menu 2.3")
                    END POPUP
                    SEPARATOR
                    ITEM "Dato" ACTION MSGINFO("Menu Dato") name menu4
                    POPUP "Tres"
                       ITEM "3.1" ACTION MSGINFO("Menu 3.1")
                       ITEM "3.2" ACTION MSGINFO("Menu 3.2")
                       ITEM "3.3" ACTION MSGINFO("Menu 3.3")
                    END POPUP
                    ITEM "Salir" ACTION Win_1.Release
                END MENU

                on key F5 action msginfo( str( olabel:row  )+str( olabel:col ),"Hello window" )

                // @ 10,10 LABEL Hello VALUE "(F5) Hello!!" AUTOSIZE ACTION MSGINFO("CLICK!")
                oLabel := TLabel():Define()
                oLabel:Caption := "(F5) Hello!!"
                oLabel:AutoSize := .T.
                oLabel:Row := 10
                oLabel:Col := 400
                oLabel:OnClick := { || MSGINFO("CLICK!") }

                @ 40,10 HYPERLINK HLNK VALUE "www.yahoo.com.mx" autosize address "http://www.yahoo.com.mx"

                @ 70,10 TEXTBOX Txt1 value "Text!" WIDTH 150 height 20

                @ 90,10 TEXTBOX Txt2 VALUE "0940100101000000" WIDTH 150  height 20 INPUTMASK "@R 999-99-999-99-!!-!!!!"

oLabel := oWnd:Txt2

                @ 110,10 TEXTBOX Txt3 VALUE 55 WIDTH 150 numeric height 20
oWnd:Txt3:transparent := .t.

                @ 130,10 TEXTBOX Txt4 VALUE 111.5 WIDTH 150 height 20 numeric INPUTMASK "999,999.99"

                @ 150,10 TEXTBOX Txt5 VALUE date() WIDTH 150 height 20 date

                @ 170,10 checkBOX chk caption "This control have context menu!" VALUE .t. on change msginfo("change!") autosize

                @ 200,10 button btn1 caption "BUTTON!" ACTION msginfo(oLabel:vALUE)

                @ 230,10 radio rad options { "Uno", "Dos", "Tres" } autosize
oWnd:RAD:AITEMS[3]:autosize := .t.
oWnd:RAD:AITEMS[3]:BACKCOLOR := BLUE
oWnd:RAD:AITEMS[3]:WIDTH := 100
oWnd:RAD:AITEMS[3]:COL := 70
oWnd:RAD:AITEMS[1]:COL := 50
oWnd:RAD:AITEMS[2]:BACKCOLOR := {255,0,0}
oWnd:RAD:AITEMS[2]:caption := oWnd:RAD:AITEMS[2]:caption

                oWnd:menu1:checked := .t.
                oWnd:menu2:checked := .t.
                oWnd:menu3:enabled := .f.
                oWnd:menu4:enabled := .f.

                @ 320,10 monthcal mtc value date()

                DEFINE CONTEXT MENU CONTROL Chk
                    POPUP "Nivel 1"
                        ITEM "Nivel 1.1" ACTION MsgInfo( "Nivel 1.1!" )
                        ITEM "Nivel 1.2" ACTION MsgInfo( "Nivel 1.2!" )
                    END POPUP
                    POPUP "Nivel 2"
                        ITEM "Nivel 2.1" ACTION MsgInfo( "Nivel 2.1!" )
                        ITEM "Nivel 2.2" ACTION MsgInfo( "Nivel 2.2!" )
                    END POPUP
                END MENU


                @  10,200 GRID grd width 150 height 100 headers { "UNO", "DOS", "TRES" } widths {45,45,45} edit ;
                          items { {"1","2","3"},{"A","@","C"},{"x","y","z"} } ;
                          JUSTIFY { GRID_JTFY_RIGHT, GRID_JTFY_CENTER, GRID_JTFY_LEFT } ;
                          FONTCOLOR ORANGE;
                          DYNAMICBACKCOLOR { RGB(0,255,0), , RGB(255,0,0) } ;
                          DYNAMICFORECOLOR { NIL, RGB(255,255,0), NIL }
oWnd:Grd:SetRangeColor( 0, , 2, 2 )

                define tab tab at 130,210 width 150 height 100
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

                @ 250,200 spinner spin range 0,100 width 150 height 20

                @ 280,200 combobox cmb items { "Uno", "Dos", "Tres" } width 150

                @ 310,240 datepicker DTP value date()

                @ 350,240 progressmeter pgm width 120 height 20 value 75

                Xdefine WINDOW internal obj ointernal AT 390,240 WIDTH 120 HEIGHT 100 INTERNAL VIRTUAL WIDTH 200 VIRTUAL HEIGHT 150
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

                @ 330,400 BUTTON BTN2 PICTURE "RESOURCES\EDIT_NEW.BMP" width 100 height 100 action printform()

                OWND:BTN2:TOOLTIP := "Print this form"
/////                OWND:BTN2:action := { || ownd:print() } 

                @ 10,600 FRAME frame WIDTH 150 HEIGHT 60 CAPTION "Frame"

                @ 30,610 ipaddress IPA value {1,2,3,4} width 130

                @ 90,600 PROGRESSBAR prog WIDTH 150 HEIGHT 20 VALUE 50 RANGE 0,100

                @ 120,600 edit edit1 WIDTH 150 HEIGHT 60 value "texto1"

                @ 200,600 richeditbox edit2 WIDTH 150 HEIGHT 60 value "texto2"

                @ 280,600 LISTBOX lbx items { "Uno", "Dos", "Tres" } width 150 multi



                DEFINE STATUSBAR

                    STATUSITEM "This is a statusbar's test!" ACTION MSGINFO( "Statusbar!" )
                    CLOCK ACTION MSGINFO( "Clock!" )

                END STATUSBAR

        END WINDOW

        ownd:Center()
        ownd:activate()

Return

function printform()
  OWND:BTN2:enabled:=.F. 
  ownd:print()
  OWND:BTN2:enabled:=.T. 
return nil
