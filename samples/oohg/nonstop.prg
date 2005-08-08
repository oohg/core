#include "oohg.ch"

PROCEDURE MAIN

    DEFINE WINDOW MainWindow AT 0,0 ;
           WIDTH 200 HEIGHT 100 ;
           MAIN ;
           TITLE "Non-stop window test"

        @ 10,10 BUTTON Start CAPTION "Start!" ACTION NonStop()

    END WINDOW
    CENTER WINDOW MainWindow
    ACTIVATE WINDOW MainWindow

RETURN

PROCEDURE NonStop()
LOCAL oWnd, nSeconds, nCount, lLoop

    DEFINE WINDOW NonStop OBJ oWnd AT 0,0 ;
           WIDTH 100 HEIGHT 70 TITLE "Working..." MODAL NOSYSMENU NOSIZE ;
           ON RELEASE ( IF( lLoop, ( lLoop := .F., MsgInfo( "Aborted by user request!" ) ), ) )

        @ 10,10 LABEL Progress VALUE "" WIDTH 80 HEIGHT 20

    END WINDOW
    CENTER WINDOW NonStop
    // ACTIVATE WINDOW NonStop
    oWnd:Activate( .T. )

    nCount := 11
    nSeconds := 0
    lLoop := .T.
    DO WHILE nCount > 0 .AND. lLoop
        IF ABS( SECONDS() - nSeconds ) >= 1
            nCount--
            oWnd:Progress:Value := LTRIM( STR( nCount ) )
            nSeconds := SECONDS()
        ENDIF
        DO EVENTS
    ENDDO

    IF lLoop
        MsgInfo( "Done!" )
        lLoop := .F.
        oWnd:Release()
    ENDIF

RETURN
