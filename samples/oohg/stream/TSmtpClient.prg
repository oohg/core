/*
 * $Id: TSmtpClient.prg,v 1.3 2015-10-31 17:07:44 fyurisich Exp $
 */
/*
 * Simple SMTP client using TStreamSocket() class.
 */

#ifndef NO_SAMPLE
#include "oohg.ch"

PROCEDURE MAIN
LOCAL oWnd

   DEFINE WINDOW MAIN OBJ oWnd ;
                 WIDTH 500 HEIGHT 400 CLIENTAREA ;
                 FONT "MS Sans Serif" SIZE 9 ;
                 TITLE "Mail sender sample"

         @  12, 10 LABEL L_Server   VALUE "SMTP server" AUTOSIZE
         @  10, 80 TEXTBOX Server   WIDTH 300 HEIGHT 19
         @  12,410 LABEL L_Port     VALUE "Port" AUTOSIZE
         @  10,440 TEXTBOX Port     WIDTH 50 HEIGHT 19 VALUE 25 NUMERIC

         @  32, 10 LABEL L_User     VALUE "AUTH. User" AUTOSIZE
         @  30, 80 TEXTBOX User     WIDTH 190 HEIGHT 19
         @  32,290 LABEL L_Password VALUE "Password" AUTOSIZE
         @  30,340 TEXTBOX Password WIDTH 150 HEIGHT 19 PASSWORD

         @  72, 10 LABEL L_From     VALUE "From" AUTOSIZE
         @  70, 60 TEXTBOX From     WIDTH 430 HEIGHT 19
         @  97, 10 LABEL L_To       VALUE "To" AUTOSIZE
         @  95, 60 TEXTBOX To       WIDTH 430 HEIGHT 19
         @ 122, 10 LABEL L_Subject  VALUE "Subject" AUTOSIZE
         @ 120, 60 TEXTBOX Subject  WIDTH 430 HEIGHT 19
         @ 147, 10 LABEL L_Message  VALUE "Message" AUTOSIZE
         @ 145, 60 EDITBOX Message  WIDTH 430 HEIGHT 210

         @ 365,410 BUTTON Send      WIDTH 80 HEIGHT 25 CAPTION "Send" ACTION Send( oWnd )
   END WINDOW
   CENTER WINDOW MAIN
   ACTIVATE WINDOW MAIN

RETURN

PROCEDURE Send( oWnd )
LOCAL oEmail, oSmtp

   oEmail := TEmail():New( oWnd:From:Value, oWnd:To:Value, oWnd:Subject:Value, oWnd:Message:Value )

   oSmtp := TSmtp()

   IF oSmtp:SendEmail( oEmail, oWnd:Server:Value, oWnd:Port:Value,, oWnd:User:Value, oWnd:Password:Value )
      MsgInfo( "Message sent" )
   ELSE
      MsgInfo( "Error sending message" )
   ENDIF

RETURN

#include "TStream.prg"
#include "TStreamSocket.prg"

#endif

#include "hbclass.ch"

CLASS TSmtp
   DATA oSocket
   DATA nTimeOut       INIT 300
   DATA bIdle          INIT nil

   METHOD Connect
   METHOD IsConnected
   METHOD End
   //
   METHOD SendEmail

   METHOD Command
   METHOD WaitForAnswer
   METHOD SendData
   //
   METHOD ExtractAddress

   METHOD Login
   METHOD ValidAuth
   METHOD CramMd5

   METHOD Encode64
   METHOD Decode64
   METHOD MD5
ENDCLASS

METHOD Connect( cHost, nPort ) CLASS TSmtp
   IF ! ::oSocket == NIL
      ::oSocket:Close()
   ENDIF

   IF ! HB_IsNumeric( nPort ) .OR. nPort == 0
      nPort := 25
   ENDIF

   ::oSocket := TStreamSocket():New( cHost, nPort )

   IF ! LEFT( ::WaitForAnswer(), 1 ) == "2"
      ::oSocket:Close()
   ENDIF
RETURN ::IsConnected()

METHOD IsConnected() CLASS TSmtp
   IF ::oSocket == NIL
      RETURN .F.
   ENDIF
RETURN ::oSocket:IsConnected()

METHOD End() CLASS TSmtp
   IF ! ::oSocket == NIL
      ::oSocket:Close()
   ENDIF
   ::oSocket := NIL
RETURN nil

METHOD SendEmail( oEmail, cServer, nPort, cFromHost, cAuthUser, cAuthPassword ) CLASS TSmtp

   IF EMPTY( cServer )
      cServer := "localhost"
   ENDIF

   IF EMPTY( cFromHost )
      cFromHost := "localhost"
   ENDIF

   IF ! ::Connect( cServer, nPort )
      RETURN .F.
   ENDIF

   // NOTE: This code is not "optimized" because it's a skeleton for reference...

   IF ! ::Login( cFromHost, cAuthUser, cAuthPassword )
      ::Command( "QUIT" )
      ::End()
      RETURN .F.
   ENDIF

   IF ! LEFT( ::Command( "MAIL FROM: " + ::ExtractAddress( oEmail:From ) ), 1 ) == "2"
      ::Command( "QUIT" )
      ::End()
      RETURN .F.
   ENDIF

   IF ! LEFT( ::Command( "RCPT TO: " + ::ExtractAddress( oEmail:To ) ), 1 ) == "2"
      ::Command( "QUIT" )
      ::End()
      RETURN .F.
   ENDIF

   IF ! LEFT( ::Command( "DATA" ), 3 ) == "354"
      ::Command( "QUIT" )
      ::End()
      RETURN .F.
   ENDIF

   IF ! LEFT( ::SendData( oEmail:Head + CHR( 13 ) + CHR( 10 ) + oEmail:Body ), 1 ) == "2"
      ::Command( "QUIT" )
      ::End()
      RETURN .F.
   ENDIF

   ::Command( "QUIT" )
   ::End()
RETURN .T.

METHOD Command( cCommand ) CLASS TSmtp
* // ? "C: " + cCommand
   IF ! ::IsConnected()
      RETURN ""
   ENDIF
   ::oSocket:Write( cCommand + CHR( 13 ) + CHR( 10 ) )
RETURN ::WaitForAnswer()

METHOD WaitForAnswer() CLASS TSmtp
LOCAL cResponse, nSeconds, nTimeOut, nCurrentSeconds, cLine
LOCAL nIdle := 1 // bIdle step
   IF ! ::IsConnected()
      RETURN ""
   ENDIF
   nSeconds := NIL
   cResponse := ""
   DO WHILE ::IsConnected()
      IF ! ::oSocket:IsLine()
         ::oSocket:Fill()
         IF nSeconds == NIL
            nSeconds := SECONDS()
            nTimeOut := ::nTimeOut
         ELSE
            nCurrentSeconds := SECONDS()
            IF nSeconds > nCurrentSeconds
               nSeconds := nCurrentSeconds - nIdle
            ENDIF
            IF nCurrentSeconds - nSeconds >= nIdle
               nTimeOut := nTimeOut - ( nCurrentSeconds - nSeconds )
               nSeconds := nCurrentSeconds
               IF HB_IsBlock( ::bIdle )
                  EVAL( ::bIdle )
               ENDIF
               IF nTimeOut <= 0
                  // TIMEOUT!
                  ::oSocket:Close()
                  EXIT
               ENDIF
            ENDIF
         ENDIF
      ELSE
         cLine := ::oSocket:GetLine()
         cResponse := cResponse + cLine
         IF ! SUBSTR( cLine, 4, 1 ) == "-"
            EXIT
         ENDIF
         cResponse := cResponse + CHR( 13 ) + CHR( 10 )
         nSeconds := NIL
      ENDIF
   ENDDO
* // ? "S: " + cResponse
RETURN cResponse

METHOD SendData( cData ) CLASS TSmtp
LOCAL nSeconds, nTimeOut, nCurrentSeconds, nSent, lAllSent
LOCAL nIdle := 1 // bIdle step
LOCAL nBlockSize := 1000
   IF ! ::IsConnected()
      RETURN ""
   ENDIF
   cData := cData + "." + CHR( 13 ) + CHR( 10 )
   nSeconds := NIL
   nPreBuffer := 0
   DO WHILE ::IsConnected() .AND. LEN( cData ) > 0
      IF LEN( cData ) > nBlockSize
         nSent := ::oSocket:Write( LEFT( cData, nBlockSize ) )
         lAllSent := ( nSent == nBlockSize )
      ELSE
         nSent := ::oSocket:Write( cData )
         lAllSent := ( nSent == LEN( cData ) )
      ENDIF
      IF nSent > 0
* // ? "C: " + LEFT( cData, nSent )
         cData := SUBSTR( cData, nSent + 1 )
      ENDIF
      //
      IF ! lAllSent
         ::oSocket:Fill()
         IF nSeconds == NIL
            nSeconds := SECONDS()
            nTimeOut := ::nTimeOut
         ELSE
            nCurrentSeconds := SECONDS()
            IF nSeconds > nCurrentSeconds
               nSeconds := nCurrentSeconds - nIdle
            ENDIF
            IF nCurrentSeconds - nSeconds >= nIdle
               nTimeOut := nTimeOut - ( nCurrentSeconds - nSeconds )
               nSeconds := nCurrentSeconds
               IF HB_IsBlock( ::bIdle )
                  EVAL( ::bIdle )
               ENDIF
               IF nTimeOut <= 0
                  // TIMEOUT!
                  ::oSocket:Close()
                  EXIT
               ENDIF
            ENDIF
         ENDIF
      ELSE
         nSeconds := NIL
      ENDIF
   ENDDO
RETURN ::WaitForAnswer()

METHOD ExtractAddress( cEmail ) CLASS TSmtp
   IF LEFT( cEmail, 1 ) == CHR( 34 ) .AND. RIGHT( cEmail, 1 ) == CHR( 34 )
      cEmail := SUBSTR( cEmail, LEN( cEmail ) - 2 )
   ENDIF
   IF RIGHT( cEmail, 1 ) == ">"
      cEmail := SUBSTR( cEmail, RAT( "<", cEmail ) + 1 )
      cEmail := LEFT( cEmail, LEN( cEmail ) - 1 )
   ENDIF
RETURN cEmail

METHOD Login( cDomain, cUser, cPassword, aProtocols ) CLASS TSmtp
LOCAL cResponse, lRet, nPos, cProtocol
   IF ! ::IsConnected()
      RETURN .F.
   ENDIF

   IF EMPTY( cDomain )
      cDomain := "localhost"
   ENDIF

   IF ! HB_IsArray( aProtocols )
      aProtocols := HB_aParams()
      ADEL( aProtocols, 1, .T. )   // cDomain
      ADEL( aProtocols, 1, .T. )   // cUser
      ADEL( aProtocols, 1, .T. )   // cPassword
   ENDIF

   IF EMPTY( cUser ) .OR. ! HB_IsString( cPassword )
      // Login HELO
      cResponse := ::Command( "HELO " + cDomain )
      lRet := ( LEFT( cResponse, 1 ) == "2" )
   ELSE
      // Login EHLO
      cResponse := ::Command( "EHLO " + cDomain )
      nPos := AT( CHR( 10 ) + "250-AUTH ", cResponse )
      IF nPos == 0
         RETURN .F.
      ENDIF

      // AUTH options
      cResponse := SUBSTR( cResponse, nPos + 10 )
      nPos := AT( CHR( 13 ) + CHR( 10 ), cResponse )
      IF nPos > 0
         cResponse := LEFT( cResponse, nPos - 1 )
      ENDIF
      cResponse := " " + UPPER( ALLTRIM( cResponse ) ) + " "
      nPos := 1
      DO WHILE nPos <= LEN( aProtocols )
         cProtocol := UPPER( ALLTRIM( aProtocols[ nPos ] ) )
         IF cProtocol $ ::ValidAuth() .AND. " " + cProtocol + " " $ cResponse
            EXIT
         ENDIF
         nPos++
      ENDDO
      IF nPos > LEN( aProtocols )
         aProtocols := ::ValidAuth()
         nPos := 1
         DO WHILE nPos <= LEN( aProtocols )
            cProtocol := aProtocols[ nPos ]
            IF " " + cProtocol + " " $ cResponse
               EXIT
            ENDIF
            nPos++
         ENDDO
         IF nPos > LEN( aProtocols )
            RETURN .F.
         ENDIF
      ENDIF
      //
      lRet := .F.
      DO CASE
         CASE cProtocol == "CRAM-MD5"
            cResponse := ::Command( "AUTH CRAM-MD5" )
            IF LEFT( cResponse, 4 ) == "334 "
               cResponse := ::Command( ::CramMd5( cUser, cPassword, ::Decode64( SUBSTR( cResponse, 5 ) ) ) )
               IF LEFT( cResponse, 3 ) == "235"
                  lRet := .T.
               ELSE
                  // Wrong password
               ENDIF
            ENDIF

         CASE cProtocol == "PLAIN"
            cResponse := ::Command( "AUTH PLAIN " + ::Encode64( cUser + CHR( 0 ) + cUser + CHR( 0 ) + cPassword ) )
            IF LEFT( cResponse, 3 ) == "235"
               lRet := .T.
            ELSE
               // Wrong password
            ENDIF

         CASE cProtocol == "LOGIN"
            cResponse := ::Command( "AUTH LOGIN" )
            IF LEFT( cResponse, 3 ) == "334"
               cResponse := ::Command( ::Encode64( cUser ) )
               IF LEFT( cResponse, 3 ) == "334"
                  cResponse := ::Command( ::Encode64( cPassword ) )
                  IF LEFT( cResponse, 3 ) == "235"
                     lRet := .T.
                  ELSE
                     // Wrong password
                  ENDIF
               ENDIF
            ENDIF

      ENDCASE
   ENDIF

RETURN lRet

METHOD ValidAuth() CLASS TSmtp
RETURN { /* "CRAM-MD5", */ "PLAIN", "LOGIN" }

METHOD CramMd5( cUser, cPassword, cChallenge ) CLASS TSmtp
LOCAL nPos, cPassword1, cPassword2
LOCAL oPad := 0x5C , iPad := 0x36
* // ? "CRAM: ", cUser, cPassword, cChallenge
   IF LEN( cPassword ) > 64
      cPassword := HEXTOSTR( ::MD5( cPassword ) )
   ENDIF
   cPassword := LEFT( cPassword + REPLICATE( CHR( 0 ), 64 ), 64 )
   cPassword1 := cPassword
   cPassword2 := cPassword
   FOR nPos := 1 TO LEN( cPassword )
#ifndef __XHARBOUR__
      cPassword1[ nPos ] := hb_bitXor( cPassword[ nPos ], oPad )
      cPassword2[ nPos ] := hb_bitXor( cPassword[ nPos ], iPad )
#else
      cPassword1[ nPos ] := cPassword[ nPos ] ^^ oPad
      cPassword2[ nPos ] := cPassword[ nPos ] ^^ iPad
#endif
   NEXT
cRet := ::Encode64( cUser + " " + ::MD5( cPassword1 + HEXTOSTR( ::MD5( cPassword2 + cChallenge ) ) ) )
* // ? "cramed: ", cRet
return cRet
*RETURN ::Encode64( cUser + " " + ::MD5( cPassword1 + ::MD5( cPassword2 + cChallenge ) ) )

METHOD Encode64( cData, nLineWidth ) CLASS TSmtp
LOCAL cRet
* // ? "ENCODE: ", cData
   cRet := HB_INLINE( cData, nLineWidth ){
      char *cData, *cRet, *cTo, cChar;
      int iLen, iLenRet, iFill, iPos, iLineWidth, iWidth;
      long lValue;

      cData = ( char * ) hb_parc( 1 );
      iLen = hb_parclen( 1 );
      iLineWidth = hb_parni( 2 );
      iLenRet = ( iLen + 2 ) / 3;
      iLenRet = iLenRet * 4;
      if( iLineWidth )
      {
         iLineWidth = iLineWidth >> 2;
         if( iLineWidth )
         {
            iWidth = ( ( iLenRet / 4 ) + iLineWidth - 1 ) / iLineWidth;
            iLenRet = iLenRet + ( iWidth * 2 );
         }
      }
      cRet = hb_xgrab( iLenRet + 1 );
      cTo = cRet;
      cRet[ iLenRet ] = 0;

      iFill = 0;
      iWidth = 0;
      while( iLen )
      {
         lValue = ( ( long ) ( unsigned long ) ( unsigned char ) *cData++ ) << 16;
         iLen--;
         if( iLen )
         {
            lValue |= ( ( long ) ( unsigned long ) ( unsigned char ) *cData++ ) << 8;
            iLen--;
            if( iLen )
            {
               lValue |= ( long ) ( unsigned long ) ( unsigned char ) *cData++;
               iLen--;
            }
            else
            {
               iFill = 1;
            }
         }
         else
         {
            iFill = 2;
         }

         iPos = 4 - iFill;
         while( iPos )
         {
            cChar = ( char ) ( unsigned char ) ( ( lValue & 0x00FC0000 ) >> 18 );
            lValue = ( lValue & 0x03FFFF ) << 6;
            if( cChar <= 25 )
               cChar = 'A' + cChar;
            else if( cChar <= 51 )
               cChar = 'a' + cChar - 26;
            else if( cChar <= 61 )
               cChar = '0' + cChar - 52;
            else if( cChar == 62 )
               cChar = '+';
            else // if( cChar == 63 )
               cChar = '/';
            iPos--;
            *cTo++ = cChar;
         }
         while( iFill )
         {
            iFill--;
            *cTo++ = '=';
         }

         if( iLineWidth )
         {
            iWidth++;
            if( iWidth == iLineWidth )
            {
               iWidth = 0;
               *cTo++ = 13;
               *cTo++ = 10;
            }
         }
      }

      if( iLineWidth && iWidth )
      {
         *cTo++ = 13;
         *cTo++ = 10;
      }

      *cTo = 0;

#ifndef __XHARBOUR__
      hb_retclen_buffer( cRet, iLenRet );
#else
      hb_retclenAdopt( cRet, iLenRet );
#endif
   }
* // ? "encoded: ", cRet
RETURN cRet

METHOD Decode64( cData ) CLASS TSmtp
LOCAL cRet
* // ? "DECODE: ", cData
   cRet := HB_INLINE( cData ){
      char *cData, *cRet, *cTo, cChar;
      int iLen, iLenRet, iPos;
      long lValue;

      cData = ( char * ) hb_parc( 1 );
      iLen = hb_parclen( 1 );

      while( iLen && ( cData[ iLen - 1 ] == ' ' || cData[ iLen - 1 ] == 13 || cData[ iLen - 1 ] == 10 || cData[ iLen - 1 ] == 9 ) )
      {
         iLen--;
      }
      if( iLen && cData[ iLen - 1 ] == '=' )
      {
         iLen--;
         while( iLen && ( cData[ iLen - 1 ] == ' ' || cData[ iLen - 1 ] == 13 || cData[ iLen - 1 ] == 10 || cData[ iLen - 1 ] == 9 ) )
         {
            iLen--;
         }
         //
         if( iLen && cData[ iLen - 1 ] == '=' )
         {
            iLen--;
         }
      }

      if( iLen == 0 )
      {
         hb_retc( "" );
         return;
      }

      iLenRet = ( iLen + 3 ) / 4;
      iLenRet = iLenRet * 3;
      cRet = hb_xgrab( iLenRet + 1 );
      cTo = cRet;
      cRet[ iLenRet ] = 0;
      iLenRet = 0;

      while( iLen )
      {
         lValue = 0;
         iPos = 0;
         while( iPos < 4 && iLen )
         {
            while( iLen && ( *cData == ' ' || *cData == 13 || *cData == 10 || *cData == 9 ) )
            {
               iLen--;
               cData++;
            }
            if( iLen )
            {
               iLen--;
               cChar = *cData++;
               if( cChar == '/' )
                  cChar = 63;
               else if( cChar == '+' )
                  cChar = 62;
               else if( cChar >= '0' && cChar <= '9' )
                  cChar = cChar - '0' + 52;
               else if( cChar >= 'a' && cChar <= 'z' )
                  cChar = cChar - 'a' + 26;
               else if( cChar >= 'A' && cChar <= 'Z' )
                  cChar = cChar - 'A';
               else
               {
                  hb_retc( "" );
                  return;
               }

               iPos++;
               lValue = ( lValue << 6 ) | ( long ) cChar;
            }
         }
         if( iPos == 1 )
         {
            hb_retc( "" );   // Only one 6-bit data
            return;
         }
         else if( iPos == 2 )
         {
            lValue = lValue << 12;
         }
         else if( iPos == 3 )
         {
            lValue = lValue << 6;
         }

         iPos--;
         while( iPos )
         {
            *cTo++ = ( char ) ( unsigned char ) ( ( lValue & 0x00FF0000 ) >> 16 );
            lValue = lValue << 8;
            iLenRet++;
            iPos--;
         }
      }
      *cTo = 0;

#ifndef __XHARBOUR__
      hb_retclen_buffer( cRet, iLenRet );
#else
      hb_retclenAdopt( cRet, iLenRet );
#endif
   }
* // ? "decoded: ", LEN( cRet), cRet
RETURN cRet

METHOD MD5( cData ) CLASS TSmtp
* // ? "MD5: ", cData
* // ? "MD5ED: ", HB_MD5( cData )
RETURN HB_MD5( cData )

/*
21* informativos
22* ????
250 Requested mail action okay, completed
251 ????
334 respuesta "valida" de un comando AUTH
354 Esperando el mensaje (termina con ".")
4** error grave
50* error de sintaxis
55* error importante
*/

/*
1. CONECTAR CON EL HOST
2. LOGIN HELO/EHLO ... . ... 250
2.1. AUTH ... 334
3. MAIL FROM: ... 250
4. RCPT TO: ... 250
5. DATA ... 354
*/

CLASS TEmail
   DATA aHeaders      INIT {}
   DATA hHeaders      INIT { => }
   DATA cMessage      INIT ""
   DATA aAttach       INIT {}
   DATA cBoundary     INIT ""

   METHOD New
   METHOD Head
   METHOD Body
   METHOD FixText
   METHOD ProcessMultipart

   //
   METHOD IsUniqueHeader
   METHOD SetHeader
   METHOD GetHeader
   METHOD From        SETGET
   METHOD To          SETGET
   METHOD Subject     SETGET
   //
   METHOD Message     SETGET
   //
   METHOD NewAttach
   METHOD AttachFile
   METHOD AttachString
   METHOD Encode64

ENDCLASS

METHOD New( cFrom, cTo, cSubject, cMessage ) CLASS TEmail
   ::aHeaders := {}
   ::hHeaders := { => }
   ::aAttach := {}
   IF ! EMPTY( cFrom )
      ::From := cFrom
   ENDIF
   IF ! EMPTY( cTo )
      ::To := cTo
   ENDIF
   IF ! EMPTY( cFrom )
      ::Subject := cSubject
   ENDIF
   IF ! EMPTY( cMessage )
      ::Message := cMessage
   ENDIF
RETURN Self

METHOD Head() CLASS TEmail
LOCAL cHead, aForce, aDefault, nPos

   aForce := {}
   IF LEN( ::aAttach ) > 0
      ::cBoundary := HB_MD5( DTOS( DATE() ) + TIME() + STR( SECONDS(), 8, 2 ) )
      AADD( aForce, { "MIME-Version", "1.0" } )
      AADD( aForce, { "Content-type", "multipart/mixed; boundary=" + CHR( 34 ) + ::cBoundary + "-000" + CHR( 34 ) } )
   ENDIF

   aDefault := {}
   AADD( aDefault, { "Date", { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" }[ DOW( DATE() ) ] + ", " + ;
                             STRZERO( DAY( DATE() ), 2 ) + " " + ;
                             { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" }[ MONTH( DATE() ) ] + " " + ;
                             STRZERO( YEAR( DATE() ), 4 ) + " " + TIME() + " " + LocalGmt() } )
   //
   nPos := LEN( aDefault )
   DO WHILE nPos >= 1
      IF ! EMPTY( ::GetHeader( aDefault[ nPos ][ 1 ] ) )
         ADEL( aDefault, nPos, .T. )
      ENDIF
      nPos--
   ENDDO

   cHead := ""
   nPos := 1
   DO WHILE nPos <= LEN( ::aHeaders )
      IF ASCAN( aForce, { |a| UPPER( a[ 1 ] ) == ::aHeaders[ nPos ][ 1 ] } ) == 0
         cHead += LEFT( ::aHeaders[ nPos ][ 1 ] + ": " + ::aHeaders[ nPos ][ 2 ], 998 ) + CHR( 13 ) + CHR( 10 )
      ENDIF
      nPos++
   ENDDO
   AEVAL( aForce, { |a| cHead += LEFT( a[ 1 ] + ": " + a[ 2 ], 998 ) + CHR( 13 ) + CHR( 10 ) } )
   AEVAL( aDefault, { |a| cHead += LEFT( a[ 1 ] + ": " + a[ 2 ], 998 ) + CHR( 13 ) + CHR( 10 ) } )
RETURN cHead

#ifdef __PLATFORM__Windows

#pragma BEGINDUMP

#include <hbapi.h>
#include <windows.h>

HB_FUNC( LOCALGMT )
{
   SYSTEMTIME st, lt;
   FILETIME fst, flt;
   ULARGE_INTEGER ust, ult;
   LONGLONG llDiff;
   char cGMT[ 6 ];

   GetSystemTime( &st );
   SystemTimeToFileTime( &st, &fst );
   ust.u.LowPart  = fst.dwLowDateTime;
   ust.u.HighPart = fst.dwHighDateTime;

   GetLocalTime( &lt );
   SystemTimeToFileTime( &lt, &flt );
   ult.u.LowPart  = flt.dwLowDateTime;
   ult.u.HighPart = flt.dwHighDateTime;

   llDiff = ult.QuadPart - ust.QuadPart;
   llDiff = llDiff / 10000000;
   llDiff = llDiff / 60;

   if( llDiff < 0 )
   {
      cGMT[ 0 ] = '-';
      llDiff = - llDiff;
   }
   else
   {
      cGMT[ 0 ] = '+';
   }

   cGMT[ 1 ] = ( char )( llDiff / 600 ) + '0';
   llDiff = llDiff % 600;
   cGMT[ 2 ] = ( char )( llDiff /  60 ) + '0';
   llDiff = llDiff % 60;
   cGMT[ 3 ] = ( char )( llDiff /  10 ) + '0';
   llDiff = llDiff % 10;
   cGMT[ 4 ] = ( char )( llDiff       ) + '0';
   cGMT[ 5 ] = 0;

   hb_retc( cGMT );
}

#pragma ENDDUMP

#else

FUNCTION LocalGMT()
RETURN ""

#endif

METHOD Body() CLASS TEmail
LOCAL cBody, hAttach, aItems

   IF LEN( ::aAttach ) == 0
      RETURN ::FixText( ::cMessage )
   ENDIF

   aItems := ARRAY( LEN( ::aAttach ) )
   AEVAL( ::aAttach, { |h,i| aItems[ i ] := h } )

   IF ! LEN( ::cMessage ) == 0
      hAttach := ::NewAttach()
      hAttach:Content_Type := ::GetHeader( "Content-type" )
      hAttach:Data         := ::FixText( ::cMessage )
      AADD( aItems, NIL )
      AINS( aItems, 1 )
      aItems[ 1 ] := hAttach
   ENDIF

   cBody := ::ProcessMultipart( aItems, 0 )

RETURN cBody

METHOD FixText( cMessage ) CLASS TEmail
LOCAL cRet
   cRet := HB_INLINE( cMessage ){
      int iLen, iLenRet, iStep, iCount, iLineLen;
      char *cMessage, *cRet, *cFrom, *cTo, cChar;

      cMessage = ( char * ) hb_parc( 1 );
      iLen = hb_parclen( 1 );

      iStep = 0;
      while( iStep < 2 )
      {
         if( iStep == 1 )
         {
            cRet = hb_xgrab( iLenRet + 1 );
            cTo = cRet;
         }
         cFrom = cMessage;
         iCount = iLen;
         iLenRet = 0;

         iLineLen = 0;
         while( iCount )
         {
            cChar = *cFrom++;
            iCount--;
            if( cChar == '.' && iLineLen == 0 )
            {
               iLineLen = 2;
               iLenRet += 2;
               if( iStep == 1 )
               {
                  *cTo++ = '.';
                  *cTo++ = '.';
               }
            }
            else if( cChar == '.' && iLineLen == 998 )
            {
               iLineLen = 2;
               iLenRet += 4;
               if( iStep == 1 )
               {
                  *cTo++ = 13;
                  *cTo++ = 10;
                  *cTo++ = '.';
                  *cTo++ = '.';
               }
            }
            else if( cChar == 10 || cChar == 0 )
            {
               iLineLen = 0;
               iLenRet += 2;
               if( iStep == 1 )
               {
                  *cTo++ = 13;
                  *cTo++ = 10;
               }
            }
            else if( cChar == 13 )
            {
               if( iCount && *cFrom == 10 )
               {
                  iCount--;
                  cFrom++;
               }
               iLineLen = 0;
               iLenRet += 2;
               if( iStep == 1 )
               {
                  *cTo++ = 13;
                  *cTo++ = 10;
               }
            }
            else
            {
               if( iLineLen == 998 )
               {
                  iLineLen = 0;
                  iLenRet += 2;
                  if( iStep == 1 )
                  {
                     *cTo++ = 13;
                     *cTo++ = 10;
                  }
               }
               iLineLen++;
               iLenRet++;
               if( iStep == 1 )
               {
                  *cTo++ = cChar;
               }
            }
         }

         if( iLineLen > 0 || iLen == 0 )
         {
            iLenRet += 2;
            if( iStep == 1 )
            {
               *cTo++ = 13;
               *cTo++ = 10;
            }
         }

         *cTo = 0;

         iStep++;
      }

#ifndef __XHARBOUR__
      hb_retclen_buffer( cRet, iLenRet );
#else
      hb_retclenAdopt( cRet, iLenRet );
#endif
   }
RETURN cRet

METHOD ProcessMultipart( aItems, nLevel ) CLASS TEmail
LOCAL cBody, cBoundary, nPos, hItem
   cBoundary := ::cBoundary + "-" + STRZERO( nLevel, 3 )
   cBody := "--" + cBoundary + CHR( 13 ) + CHR( 10 )

   nPos := 1
   DO WHILE nPos <= LEN( aItems )
      hItem := aItems[ nPos ]
      IF hItem:Multipart
         nLevel++
         cBody += "Content-type: " + IF( EMPTY( hItem:Content_Type ), "multipart/mixed", hItem:Content_Type ) + ;
                                     IF( EMPTY( hItem:Name ), "", "; name=" + CHR( 34 ) + hItem:Name + CHR( 34 ) ) + ;
                                     "; boundary=" + CHR( 34 ) + ::cBoundary + "-" + STRZERO( nLevel, 3 ) + CHR( 34 ) + ;
                                     CHR( 13 ) + CHR( 10 )
         IF ! EMPTY( hItem:Encoding )
            cBody += "Content-transfer-encoding: " + hItem:Encoding + CHR( 13 ) + CHR( 10 )
         ENDIF
         cBody += CHR( 13 ) + CHR( 10 )
         cBody += ::ProcessMultipart( hItem:Data, @nLevel )

      ELSE
         IF ! EMPTY( hItem:Content_Type )
            cBody += "Content-type: " + hItem:Content_Type + ;
                                     IF( EMPTY( hItem:Name ), "", "; name=" + CHR( 34 ) + hItem:Name + CHR( 34 ) ) + ;
                                     CHR( 13 ) + CHR( 10 )
         ENDIF
         IF ! EMPTY( hItem:Encoding )
            cBody += "Content-transfer-encoding: " + hItem:Encoding + CHR( 13 ) + CHR( 10 )
         ENDIF
         cBody += CHR( 13 ) + CHR( 10 )
         cBody += hItem:Data

      ENDIF

      cBody += "--" + cBoundary + IF( nPos == LEN( aItems ), "--", "" ) + CHR( 13 ) + CHR( 10 )
      nPos++
   ENDDO

RETURN cBody

METHOD IsUniqueHeader( cKey ) CLASS TEmail
STATIC hNames := NIL
   IF hNames == NIL
      hNames := { "FROM", "TO", "SUBJECT", "MIME-VERSION", "CONTENT-TYPE" }
   ENDIF
RETURN UPPER( ALLTRIM( cKey ) ) $ hNames

METHOD SetHeader( cKey, cValue ) CLASS TEmail
LOCAL cUpperKey
   cKey := ALLTRIM( cKey )
   cValue := ALLTRIM( cValue )
   IF RIGHT( cKey, 1 ) == ":"
      cKey := TRIM( LEFT( cKey, LEFT( cKey, LEN( cKey ) - 1 ) ) )
   ENDIF
   cUpperKey := UPPER( cKey )
   IF ::IsUniqueHeader( cKey )
      IF cUpperKey $ ::hHeaders
         ::hHeaders[ cUpperKey ][ 2 ] := cValue
      ELSE
         AADD( ::aHeaders, { cKey, cValue } )
         ::hHeaders[ cUpperKey ] := ATAIL( ::aHeaders )
      ENDIF
   ELSE
      AADD( ::aHeaders, { cKey, cValue } )
   ENDIF
RETURN nil

METHOD GetHeader( cKey ) CLASS TEmail
LOCAL cUpperKey
   cKey := ALLTRIM( cKey )
   IF RIGHT( cKey, 1 ) == ":"
      cKey := TRIM( LEFT( cKey, LEFT( cKey, LEN( cKey ) - 1 ) ) )
   ENDIF
   cUpperKey := UPPER( cKey )
RETURN IF( cUpperKey $ ::hHeaders, ::hHeaders[ cUpperKey ][ 2 ], "" )

METHOD From( cValue ) CLASS TEmail
   IF PCOUNT() >= 1
      ::SetHeader( "From", cValue )
   ENDIF
RETURN ::GetHeader( "FROM" )

METHOD To( cValue ) CLASS TEmail
   IF PCOUNT() >= 1
      ::SetHeader( "To", cValue )
   ENDIF
RETURN ::GetHeader( "TO" )

METHOD Subject( cValue ) CLASS TEmail
   IF PCOUNT() >= 1
      ::SetHeader( "Subject", cValue )
   ENDIF
RETURN ::GetHeader( "SUBJECT" )

METHOD Message( cMessage ) CLASS TEmail
   IF PCOUNT() >= 1
      ::cMessage := cMessage
   ENDIF
RETURN ::cMessage

METHOD NewAttach() CLASS TEmail
LOCAL hAttach
   hAttach := { "MULTIPART"    => .F., ;
                "CONTENT_TYPE" => "", ;
                "NAME"         => "", ;
                "ENCODING"     => "", ;
                "DATA"         => "" }
RETURN hAttach

METHOD AttachFile( cFileName, cContent_Type ) CLASS TEmail
LOCAL nPos, nPos2, cExt, cFile, nHdl, nSize

   nPos  := RAT( "\", cFileName )
   nPos2 := RAT( "/", cFileName )
   IF nPos == 0 .OR. nPos2 > nPos
      nPos := nPos2
   ENDIF

   nHdl := FOPEN( cFileName )
   nSize := 0
   cFile := ""
   IF nHdl > 0
      nSize := FSEEK( nHdl, 0, 2 )
      FSEEK( nHdl, 0, 0 )
      IF nSize > 0
         cFile := SPACE( nSize )
         FREAD( nHdl, @cFile, nSize )
      ENDIF
      FCLOSE( nHdl )
   ENDIF

   IF EMPTY( cContent_Type )
      cExt := LOWER( SUBSTR( cFileName, MAX( RAT( ".", cFileName ), 1 ) ) )
      IF     cExt == ".pdf"
         cContent_Type := "application/pdf"
      ELSEIF cExt == ".xml"
         cContent_Type := "application/xml"
      ELSEIF cExt == ".zip"
         cContent_Type := "application/zip"
      ELSEIF cExt == ".gif"
         cContent_Type := "image/gif"
      ELSEIF cExt $ { ".jpg" , ".jpeg" }
         cContent_Type := "image/jpeg"
      ELSEIF cExt == ".png"
         cContent_Type := "image/png"
      ELSEIF cExt == ".bmp"
         cContent_Type := "image/bmp"
      ELSEIF cExt $ { ".tif" , ".tiff" }
         cContent_Type := "image/tiff"
      ELSEIF cExt == ".csv"
         cContent_Type := "text/csv"
      ELSEIF cExt $ { ".htm" , ".html" }
         cContent_Type := "text/html"
      ELSEIF cExt == ".txt"
         cContent_Type := "text/plain"
      ELSEIF cExt == ".avi"
         cContent_Type := "video/avi"
      ELSEIF cExt == ".7z"
         cContent_Type := "application/x-7z-compressed"
      ELSEIF cExt == ".rar"
         cContent_Type := "application/x-rar-compressed"
      ELSE
         cContent_Type := "application/octet-stream"
      ENDIF
   ENDIF

RETURN ::AttachString( cFile, cContent_Type, SUBSTR( cFileName, nPos + 1 ) )

METHOD AttachString( cString, cContent_Type, cName ) CLASS TEmail
LOCAL hAttach
   hAttach := ::NewAttach()

   IF ! EMPTY( cName )
      hAttach:Name := ALLTRIM( cName )
   ENDIF

   IF EMPTY( cContent_Type )
      cContent_Type := "application/octet-stream"
   ENDIF
   hAttach:Content_Type := ALLTRIM( cContent_Type )

   IF hAttach:Content_Type == "text/plain"
      hAttach:Data := ::FixText( cString )
   ELSE
      hAttach:Data := ::Encode64( cString, 64 )
      hAttach:Encoding := "base64"
   ENDIF

   AADD( ::aAttach, hAttach )
RETURN hAttach

METHOD Encode64( cData, nLineLength ) CLASS TEmail
RETURN TSmtp():Encode64( cData, nLineLength )
