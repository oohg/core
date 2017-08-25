/*
 * $Id: demo.prg,v 1.4 2017-08-25 19:28:44 fyurisich Exp $
 */
/*
 * This demo shows how to use Autoadjust.
 * Copyright (c)2007-2017 MigSoft <migsoft/at/oohg.org>
 *
 */


#include "oohg.ch"

*----------------------------------------------------*
Function Main()
*----------------------------------------------------*

   SET AUTOADJUST ON

   MsgInfo("Se ajusta posicion, ancho y font","Informacion") 

   DEFINE WINDOW Principal ;
       AT 0,0 WIDTH 648 HEIGHT 404 ; 
       TITLE 'AutoAdjust Demo by MigSoft' ;
       MAIN ;
       ON SIZE Size_Check()

       @ 18,31 FRAME frame_1 CAPTION "Datos Generales" ; 
         WIDTH 576 HEIGHT 281

       principal.frame_1.fontcolor:={0,0,0} 
       principal.frame_1.fontname:='MS Sans Serif' 
       principal.frame_1.fontsize:= 10 

       DEFINE TAB tab_1 AT 40,40 WIDTH 250 HEIGHT 250 ; 
         FONT 'MS Sans Serif' SIZE 10

           DEFINE PAGE " Page1 "     

               @ 48,24 GRID grid_1 WIDTH 200 HEIGHT 158 ;
               HEADERS {'one','two'} WIDTHS  {60,60} ; 
               FONT 'MS Sans Serif' SIZE 10  

               principal.grid_1.fontcolor:={0,0,0} 
               principal.grid_1.AddItem( {"Row1","Row1"} )
               principal.grid_1.AddItem( {"Row2","Row2"} )
               principal.grid_1.AddItem( {"Row3","Row3"} )
               principal.grid_1.value:=1

           END PAGE 

            DEFINE PAGE " Page2 "     

               @ 120,24 PROGRESSBAR progressbar_1 ; 
               WIDTH 190 HEIGHT 32 VALUE 25

               principal.progressbar_1.fontcolor:=BLUE

          END PAGE 

       END TAB 

       @ 128,310 LISTBOX list_1 WIDTH 158 HEIGHT 99 ; 
         FONT 'MS Sans Serif' SIZE 10

       principal.list_1.fontcolor:={0,0,0} 
       principal.list_1.backcolor:={255,255,255} 
       principal.list_1.AddItem( "Item 1" )
       principal.list_1.AddItem( "Item 2" )
       principal.list_1.AddItem( "Item 3" )
       principal.list_1.value:=1

       @ 322,35 LABEL label_1 WIDTH 95 HEIGHT 21 ;
         VALUE 'Nombres' FONT 'MS Sans Serif' SIZE 10

       principal.label_1.fontcolor:={0,0,0}

       @ 321,150 TEXTBOX text_1 HEIGHT 24 WIDTH 219 ; 
         FONT 'MS Sans Serif' SIZE 10 MAXLENGTH 30

       principal.text_1.fontcolor:={0,0,0} 
       principal.text_1.backcolor:={255,255,255} 

       @ 40,491 IMAGE image_1 PICTURE "hbprint_save" ; 
         WIDTH 100 HEIGHT 100 STRETCH

       @ 86,310 DATEPICKER datepicker_1 WIDTH 120 ; 
       FONT 'MS Sans Serif' SIZE 10

       principal.datepicker_1.fontcolor:={0,0,0} 
       principal.datepicker_1.backcolor:={255,255,255} 

       @ 244,310 COMBOBOX combo_1 WIDTH 100 VALUE 1 ;
         ITEMS {"Item 1","Item 2","Item 3"} ; 
         FONT 'MS Sans Serif' SIZE 10

       principal.combo_1.fontcolor:={0,0,0} 
       principal.combo_1.backcolor:={255,255,255} 

       @ 243,488 BUTTON picbutt_3 PICTURE 'hbprint_close'; 
         ACTION msginfo('Pic button pressed') WIDTH 100 HEIGHT 44

       @ 320,400 BUTTON button_1 CAPTION 'Aceptar' ; 
         ACTION msginfo('Button pressed') WIDTH 100 HEIGHT 28 ; 
         FONT 'MS Sans Serif' SIZE 10

       principal.button_1.fontcolor:={0,0,0} 

       @ 320,507 BUTTON button_2 CAPTION 'Cancelar' ;
         ACTION ThisWindow.Release WIDTH 100 HEIGHT 28 ; 
         FONT 'MS Sans Serif' SIZE 10

       principal.button_2.fontcolor:={0,0,0} 

   END WINDOW

   principal.grid_1.setfocus

   CENTER WINDOW Principal

   ACTIVATE WINDOW Principal

Return Nil


*----------------------------------------------------*
Procedure Size_Check
*----------------------------------------------------*

   IF Principal.Width < 608
      Principal.Width := 608
   ENDIF
   IF Principal.Height < 380
      Principal.Height := 380
   ENDIF

Return
