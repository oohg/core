/*
 * $Id: TVirtualField.prg,v 1.1 2015-05-02 04:20:46 fyurisich Exp $
 */

#include "oohg.ch"

PROCEDURE MAIN
PRIVATE oVirtual1, oVirtual2
   DBCREATE( "TEST", { { "CODE", "N", 3, 0 }, { "NAME", "C", 30, 0 } } )
   USE TEST
   DO WHILE RECCOUNT() < 30
      APPEND BLANK
      REPLACE CODE WITH RECNO(), NAME WITH "Code " + STRZERO( RECNO() , 3 )
   ENDDO
   GO TOP

   oVirtual1 := TVirtualField():New( "TEST", .F. )
   oVirtual2 := TVirtualField():New( "TEST", 0 )

   DEFINE WINDOW Main WIDTH 300 HEIGHT 300 CLIENTAREA TITLE "TVirtualField Class"
      @ 10,10 BROWSE Browse WIDTH 280 HEIGHT 280 ;
              HEADERS { "Code", "Name", "Select", "Count" } ;
              WIDTHS { 50, 100, 50, 50 } ;
              FIELDS { "TEST->CODE", "TEST->NAME", ;
                       "oVirtual1:Value", "oVirtual2:Value" } ;
              ON DBLCLICK ChangeValues()
   END WINDOW
   ACTIVATE WINDOW Main
RETURN

PROCEDURE ChangeValues()
   TEST->( DBGOTO( Main.Browse.Value ) )
   oVirtual1:Value := ! oVirtual1:Value
   oVirtual2:Value ++
   Main.Browse.Refresh()
RETURN
