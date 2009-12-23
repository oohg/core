#include "oohg.ch"

PROCEDURE MAIN
LOCAL I
   DBCREATE( "INCR", { { "DATA", "C", 20, 0 } } )
   USE INCR
   INDEX ON DATA TO INCR
   FOR I := 1 TO 50
      INCR->( DBAPPEND() )
      INCR->DATA := CHR( INT( I / 3 ) + 65 ) + STRZERO( I, 3 )
   NEXT
   // INCR->( DBGOTO( INCR->( RECNO() ) / 2 ) )
   INCR->( DBGOTO( RECNO() / 2 ) )
   DEFINE WINDOW Incremental WIDTH 500 HEIGHT 400 CLIENTAREA ;
          TITLE "Incremental search sample"
      @  10, 10 BROWSE Brw WIDTH 480 HEIGHT 350 ;
                WORKAREA INCR ;
                HEADERS { "CODE" } ;
                WIDTHS { 100 } ;
                FIELDS { "INCR->DATA" }
      @ 372, 10 LABEL Lbl VALUE "Code:" AUTOSIZE
      @ 370, 15 + Incremental.Lbl.Width TEXTBOX Txt WIDTH 400 ;
                ON CHANGE Search()
      Incremental.Txt.Setfocus
   END WINDOW
   CENTER WINDOW Incremental
   ACTIVATE WINDOW Incremental
RETURN

PROCEDURE Search()
   INCR->( DBSEEK( UPPER( ALLTRIM( Incremental.Txt.Value ) ), .T. ) )
   IF INCR->( EOF() )
      INCR->( DBGOBOTTOM() )
   ENDIF
   Incremental.Brw.Value := INCR->( RECNO() )
RETURN
