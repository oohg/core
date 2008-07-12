#include "oohg.ch"

PROCEDURE MAIN
LOCAL oWnd
   DEFINE WINDOW Main WIDTH 320 HEIGHT 320 CLIENTAREA ;
          OBJ oWnd TITLE "Drop files here"
      @ 10,10 EDIT Files READONLY WIDTH 300 HEIGHT 300
      oWnd:Files:AcceptFiles := .T.
      oWnd:Files:OnDropFiles := { |f| AddFiles( f, oWnd ) }
   END WINDOW
   ACTIVATE WINDOW Main
RETURN

PROCEDURE AddFiles( aFiles, oWnd )
   AEVAL( aFiles, { |c| oWnd:Files:Value += c + CHR( 13 ) + CHR( 10 ) } )
RETURN
