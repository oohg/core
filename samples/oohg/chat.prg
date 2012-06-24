/*
 * $Id: chat.prg,v 1.2 2012-06-24 16:35:16 fyurisich Exp $
 */
/*
 *  Simple chat program, using TStreamWSocket class.
 *
 *  For compile, be sure TStream.prg and TStreamSocket.prg
 *  files are in the include path (or in current path).
 */

#include "oohg.ch"

#define CRLF   CHR( 13 ) + CHR( 10 )

PROCEDURE MAIN
LOCAL oWnd
LOCAL lHost := .F., oSocket := NIL, aClients := {}

   // Startup window
   DEFINE WINDOW Connect OBJ oWnd TITLE "Chat sample" ;
          WIDTH 290 HEIGHT 130 ;
          NOSIZE NOMAXIMIZE CLIENTAREA ;
          FONT "MS Sans Serif" SIZE 9

      @  12, 10 LABEL L_Server VALUE "Host name" AUTOSIZE
      @  10, 80 TEXTBOX Server WIDTH 200 HEIGHT 19 VALUE "127.0.0.1"
      @  35, 10 CHECKBOX Host  AUTOSIZE ;
                CAPTION "This computer will be host" ;
                ON CHANGE ( oWnd:Server:Enabled := ! oWnd:Host:Value )
      @  62, 10 LABEL L_Port   VALUE "Port number" AUTOSIZE
      @  60, 80 TEXTBOX Port   WIDTH 45 HEIGHT 19 VALUE 3000 ;
                MAXLENGTH 5 NUMERIC
      @  95,100 BUTTON Ok      WIDTH 80 HEIGHT 25 CAPTION "Connect" ;
                ACTION ( oSocket := CreateConnection( oWnd, @lHost ) )
      @  95,200 BUTTON Exit    WIDTH 80 HEIGHT 25 CAPTION "Exit"    ;
                ACTION oWnd:Release()

      ON KEY RETURN ACTION oWnd:Ok:Click()
      ON KEY ESCAPE ACTION oWnd:Exit:Click()
   END WINDOW
   oWnd:Center()
   oWnd:Activate()

   IF oSocket == NIL
      RETURN
   ENDIF

   // Chat window
   DEFINE WINDOW Chat OBJ oWnd TITLE "Chat sample" + ;
                                     IF( lHost, " (host)", "" ) ;
          WIDTH 440 HEIGHT 400 CLIENTAREA ;
          MINWIDTH 200 MINHEIGHT 200 ;
          ON INIT oWnd:Text:SetFocus() ;
          ON INTERACTIVECLOSE ( oWnd:Close:Click() , .F. ) ;
          FONT "MS Sans Serif" SIZE 9

      @  10, 10 LISTBOX Chat WIDTH 420 HEIGHT 310
      oWnd:Chat:Anchor := "TOPLEFTBOTTOMRIGHT"

      @ 330, 10 TEXTBOX Text WIDTH 380 HEIGHT 19 ;
                ON ENTER oWnd:Send:Click()
      oWnd:Text:Anchor := "LEFTBOTTOMRIGHT"
                
      @ 330,395 BUTTON Send  CAPTION "Send" WIDTH 35 HEIGHT 19 ;
                ACTION SendText( oWnd, oSocket, lHost, aClients )
      oWnd:Send:Anchor := "BOTTOMRIGHT"

      @ 365,370 BUTTON Close CAPTION "Exit" WIDTH 60 HEIGHT 25 ;
                ACTION CheckForExit( oWnd, oSocket, lHost, aClients )
      oWnd:Close:Anchor := "BOTTOMRIGHT"

      ON KEY ESCAPE ACTION oWnd:Close:Click()
   END WINDOW

   IF lHost
      aClients := ARRAY( 100 )
      oSocket:bAccept := { || NewClient( oSocket:Accept(), oWnd, aClients ) }
   ELSE
      oSocket:bClose := { || oWnd:Text:Enabled := .F. , ;
                             oWnd:Send:Enabled := .F. }
      oSocket:bRead  := { || ReadFromHost( oSocket, oWnd ) }
   ENDIF
   oSocket:Async( oWnd:hWnd )
   oWnd:WndProc := { |a,b,c,d,e| SocketEvents( a, b, c, d, e ) }

   oWnd:Center()
   oWnd:Activate()

RETURN

FUNCTION CreateConnection( oWnd, lHost )
LOCAL cServer, nPort, oSocket, oReturn
   cServer := ALLTRIM( oWnd:Server:Value )
   nPort := oWnd:Port:Value
   oReturn := NIL
   oSocket := TStreamWSocket()
   IF oWnd:Host:Value
      IF oSocket:Listen( nPort, 50 )
         oWnd:Release()
         oReturn := oSocket
         lHost := .T.
      ELSE
         MsgInfo( "Can't create host at port " + LTRIM( STR( nPort ) ), ;
                  "Chat host" )
      ENDIF
   ELSEIF EMPTY( cServer )
      MsgInfo( "Must specify host name", "Chat client" )
   ELSE
      oSocket:New( cServer, nPort )
      IF oSocket:IsActive()
         oWnd:Release()
         oReturn := oSocket
      ELSE
         MsgInfo( "Can't connect to server " + cServer + " at port " + ;
                  LTRIM( STR( nPort ) ), "Chat client" )
      ENDIF
   ENDIF
RETURN oReturn

PROCEDURE SendText( oWnd, oSocket, lHost, aClients )
LOCAL cText
   cText := ALLTRIM( oWnd:Text:Value )
   IF ! EMPTY( cText )
      IF lHost
         SendToAll( "000: " + cText, aClients, oWnd )
      ELSE
         oSocket:WriteBuffer( cText + CRLF )
      ENDIF
   ENDIF
   oWnd:Text:Value := ""
   oWnd:Text:SetFocus()
RETURN

PROCEDURE SendToAll( cText, aClients, oWnd )
   cText := LEFT( cText, 900 )
   AEVAL( aClients, { |o| IF( o == NIL,, o:WriteBuffer( cText + CRLF ) ) } )
   ShowText( oWnd, cText )
RETURN

PROCEDURE ShowText( oWnd, cText )
   IF oWnd:Chat:ItemCount > 100
      oWnd:Chat:DeleteItem( 1 )
   ENDIF
   oWnd:Chat:AddItem( cText )
   oWnd:Chat:Value := oWnd:Chat:ItemCount
RETURN

PROCEDURE CheckForExit( oWnd, oSocket, lHost, aClients )
LOCAL lExit
   IF lHost
      lExit := MsgYesNo( "You are the host of this chat" + CRLF + ;
               "Do you want to close chat sample?", "Chat host" )
   ELSE
      lExit := MsgYesNo( "Do you want to close chat sample?", "Chat host" )
   ENDIF
   IF lExit
      oSocket:Close()
      IF lHost
         SendToAll( "Host has been closed.", aClients, oWnd )
         AEVAL( aClients, { |o| IF( o == NIL,, o:Close() ) } )
      ENDIF
      oWnd:Release()
   ENDIF
RETURN

PROCEDURE NewClient( oNewSocket, oWnd, aClients )
LOCAL nPosition
   nPosition := ASCAN( aClients, NIL )
   aClients[ nPosition ] := oNewSocket
   oNewSocket:Cargo := nPosition
   oNewSocket:bClose := { || CloseClient( oNewSocket, aClients, oWnd ) }
   oNewSocket:bRead  := { || ReadFromClient( oNewSocket, aClients, oWnd ) }
   oNewSocket:Async( oWnd:hWnd )
   SendToAll( STRZERO( oNewSocket:Cargo, 3 ) + " has join chat", ;
              aClients, oWnd )
RETURN

PROCEDURE CloseClient( oSocket, aClients, oWnd )
   oSocket:Close()
   aClients[ oSocket:Cargo ] := NIL
   SendToAll( STRZERO( oSocket:Cargo, 3 ) + " has left chat", ;
              aClients, oWnd )
RETURN

PROCEDURE ReadFromHost( oSocket, oWnd )
   DO WHILE oSocket:IsLine()
      ShowText( oWnd, oSocket:GetLine() )
   ENDDO
RETURN

PROCEDURE ReadFromClient( oSocket, aClients, oWnd )
   DO WHILE oSocket:IsLine()
      SendToAll( STRZERO( oSocket:Cargo, 3 ) + ": " + oSocket:GetLine(), ;
                 aClients, oWnd )
   ENDDO
RETURN

#include "stream\TStream.prg"
#include "stream\TStreamSocket.prg"
