/*
 * $Id: h_error.prg $
 */
/*
 * OOHG source code:
 * Error handling system
 *
 * Copyright 2005-2022 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    Original source code of Antonio Novo
 *       Copyright 2003 <novoantonio@hotmail.com>
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2022 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2022 Contributors, https://harbour.github.io/
 */
/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file LICENSE.txt. If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1335, USA (or download from http://www.gnu.org/licenses/).
 *
 * As a special exception, the ooHG Project gives permission for
 * additional uses of the text contained in its release of ooHG.
 *
 * The exception is that, if you link the ooHG libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the ooHG library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the ooHG
 * Project under the name ooHG. If you copy code from other
 * ooHG Project or Free Software Foundation releases into a copy of
 * ooHG, as the General Public License permits, the exception does
 * not apply to the code that you add in this way. To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for ooHG, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 */


#include "common.ch"
#include "error.ch"
#include "hbclass.ch"
#include "oohg.ch"
#include "i_init.ch"

STATIC aMsgs := { "Error", "Warning" }

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _OOHG_SetErrorMsgs( cError, cWarning )

   aMsgs[ 1 ] := cError
   aMsgs[ 2 ] := cWarning

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION OOHG_MsgError( cMessage )

   // Kill timers and hot keys
   _KillAllTimers()
   _KillAllKeys()

   OwnErrorHandler():ErrorMessage( cMessage, 1 )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION OOHG_MsgReplace( cMsg, aData )

   LOCAL i, j

   FOR i := 1 TO Len( aData )
      j := At( aData[ i, 1 ], cMsg )
      IF j > 0
         cMsg := Left( cMsg, j - 1 ) + aData[ i, 2 ] + SubStr( cMsg, j + Len( aData[ i, 1 ] ) )
      ENDIF
   NEXT i

   RETURN cMsg

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE ErrorSys

   ErrorBlock( { | oError | DefError( oError ) } )

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION DefError( oError )

   LOCAL cMessage

   // By default, division by zero results in zero
   IF oError:genCode == EG_ZERODIV .AND. ;
      oError:canSubstitute
      RETURN 0
   ENDIF

   // By default, retry on RDD lock error failure */
   IF oError:genCode == EG_LOCK .AND. ;
      oError:canRetry
      RETURN .T.
   ENDIF

   // Set NetErr() if there was a database open error
   IF oError:genCode == EG_OPEN .AND. ;
      oError:osCode == 32 .AND. ;
      oError:canDefault
      NetErr( .T. )
      RETURN .F.
   ENDIF

   // Set NetErr() if there was a lock error on dbAppend()
   IF oError:genCode == EG_APPENDLOCK .AND. ;
      oError:canDefault
      NetErr( .T. )
      RETURN .F.
   ENDIF

   cMessage := _OOHG_ErrorMessage( oError )

   // Kill timers and hot keys
   _KillAllTimers()
   _KillAllKeys()

   // Log error
   OwnErrorHandler():ErrorMessage( cMessage, 2 )

   ExitProcess( Max( ErrorLevel(), 1 ) )

   RETURN .F.

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _OOHG_ErrorMessage( oError )

   LOCAL cMessage, xArg

   // start error message
   cMessage := iif( oError:severity > ES_WARNING, aMsgs[ 1 ], aMsgs [ 2 ] ) + " "

   // add subsystem name if available
   IF HB_ISSTRING( oError:subsystem )
      cMessage += oError:subsystem()
   ELSE
      cMessage += "???"
   ENDIF

   // add subsystem's error code if available
   IF HB_ISNUMERIC( oError:subCode )
      cMessage += "/" + LTrim( Str( oError:subCode ) )
   ELSE
      cMessage += "/???"
   ENDIF

   // add error description if available
   IF HB_ISSTRING( oError:description )
      cMessage += "  " + oError:description
   ENDIF

   // add either filename or operation
   DO CASE
   CASE ! Empty( oError:filename )
      cMessage += ": " + oError:filename
   CASE ! Empty( oError:operation )
      cMessage += ": " + oError:operation
   ENDCASE

   IF ! Empty( oError:osCode )
      cMessage += " (DOS " + aMsgs[ 1 ] + " " + LTrim( Str( oError:osCode ) ) + ")"
   ENDIF

   IF ValType( oError:Args ) == "A"
      cMessage += hb_Eol()
      FOR EACH xArg IN oError:Args
         cMessage += [(] + Ltrim( Str( xArg:__EnumIndex() ) ) + [) = Tipo: ] + ValType( xArg )
         IF xArg != NIL
            cMessage +=  [ Value: ] + Alltrim( hb_ValToExp( xArg ) )
         ENDIF
         cMessage += hb_Eol()
      NEXT
   ENDIF
   RETURN cMessage

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION OwnErrorHandler()

   LOCAL oErrorLog
   MEMVAR _OOHG_TxtError

   IF Type( "_OOHG_TXTERROR" ) == "L" .AND. _OOHG_TxtError
      oErrorLog := OOHG_TErrorTxt():New()
   ELSEIF TYPE( "_OOHG_TXTERROR" ) == "O"
      oErrorLog := _OOHG_TxtError
   ELSE
      oErrorLog := OOHG_TErrorHtml():New()
   ENDIF

   RETURN oErrorLog


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS OOHG_TErrorHtml

   DATA aMessages                 INIT NIL
   DATA cBufferFile               INIT ""
   DATA cBufferScreen             INIT ""
   DATA cLang                     INIT ""
   DATA FileName                  INIT "ErrorLog.htm"
   DATA Path                      INIT ""
   DATA PostHeader                INIT '</p>'
   DATA PreHeader                 INIT '<HR>' + CRLF + '<p class="updated">'

   METHOD CopyLog
   METHOD CreateLog
   METHOD DeleteLog
   METHOD ErrorHeader
   METHOD ErrorMessage
   METHOD FileHeader
   METHOD New
   METHOD PutMsg
   METHOD Write
   METHOD Write2

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD New( cLang ) CLASS OOHG_TErrorHtml

   LOCAL nAt

   IF ! ValType( cLang ) $ "CM" .OR. Empty( cLang )
      IF Empty( ::cLang )
         cLang := _OOHG_GetLanguage()
         ::cLang := cLang
      ELSE
         cLang := Upper( AllTrim( ::cLang ) )
      ENDIF
   ELSE
      IF ( nAt := At( ".", cLang ) ) > 0
         cLang := Left( cLang, nAt - 1 )
      ENDIF
      cLang := Upper( AllTrim( cLang ) )
      ::cLang := cLang
   ENDIF

   DO CASE
   CASE cLang == "HR852" .OR. ;
        cLang == "HR"                               // Croatian
      ::cLang := cLang
      ::aMessages := { "OOHG Errors Log", ;
                       "Application: ", ;
                       "Date: ", ;
                       "Time: ", ;
                       "Version: ", ;
                       "Alias in use: ", ;
                       "Computer Name: ", ;
                       "User Name: ", ;
                       "Error: ", ;
                       "Called from ", ;
                       "Events:", ;
                       "Program Error" }

   CASE cLang == "EU"                               // Basque
      ::cLang := cLang
      ::aMessages := { "OOHG Errors Log", ;
                       "Application: ", ;
                       "Date: ", ;
                       "Time: ", ;
                       "Version: ", ;
                       "Alias in use: ", ;
                       "Computer Name: ", ;
                       "User Name: ", ;
                       "Error: ", ;
                       "Called from ", ;
                       "Events:", ;
                       "Program Error" }

   CASE cLang == "FR"                               // French
      ::cLang := cLang
      ::aMessages := { "OOHG Errors Log", ;
                       "Application: ", ;
                       "Date: ", ;
                       "Time: ", ;
                       "Version: ", ;
                       "Alias in use: ", ;
                       "Computer Name: ", ;
                       "User Name: ", ;
                       "Error: ", ;
                       "Called from ", ;
                       "Events:", ;
                       "Program Error" }

   CASE cLang == "DEWIN" .OR. ;
        cLang == "DE"                               // German
      ::aMessages := { "OOHG Errors Log", ;
                       "Application: ", ;
                       "Date: ", ;
                       "Time: ", ;
                       "Version: ", ;
                       "Alias in use: ", ;
                       "Computer Name: ", ;
                       "User Name: ", ;
                       "Error: ", ;
                       "Called from ", ;
                       "Events:", ;
                       "Program Error" }

   CASE cLang == "IT"                               // Italian
      ::aMessages := { "OOHG Errors Log", ;
                       "Application: ", ;
                       "Date: ", ;
                       "Time: ", ;
                       "Version: ", ;
                       "Alias in use: ", ;
                       "Computer Name: ", ;
                       "User Name: ", ;
                       "Error: ", ;
                       "Called from ", ;
                       "Events:", ;
                       "Program Error" }

   CASE cLang == "PLWIN" .OR. ;
        cLang == "PL852" .OR. ;
        cLang == "PLISO" .OR. ;
        cLang == "PLMAZ"                            // Polish
      ::aMessages := { "OOHG Errors Log", ;
                       "Application: ", ;
                       "Date: ", ;
                       "Time: ", ;
                       "Version: ", ;
                       "Alias in use: ", ;
                       "Computer Name: ", ;
                       "User Name: ", ;
                       "Error: ", ;
                       "Called from ", ;
                       "Events:", ;
                       "Program Error" }

   CASE cLang == "PT"                               // Portuguese
      ::aMessages := { "OOHG Errors Log", ;
                       "Application: ", ;
                       "Date: ", ;
                       "Time: ", ;
                       "Version: ", ;
                       "Alias in use: ", ;
                       "Computer Name: ", ;
                       "User Name: ", ;
                       "Error: ", ;
                       "Called from ", ;
                       "Events:", ;
                       "Program Error" }

   CASE cLang == "RUKOI8" .OR. ;
        cLang == "RU866"  .OR. ;
        cLang == "RUWIN"  .OR. ;
        cLang == "RU"                               // Russian
      ::aMessages := { "OOHG Errors Log", ;
                       "Application: ", ;
                       "Date: ", ;
                       "Time: ", ;
                       "Version: ", ;
                       "Alias in use: ", ;
                       "Computer Name: ", ;
                       "User Name: ", ;
                       "Error: ", ;
                       "Called from ", ;
                       "Events:", ;
                       "Program Error" }

   CASE cLang == "ESWIN" .OR. ;
        cLang == "ES"                               // Spanish
      ::aMessages := { "Registro de Errores de OOHG", ;
                       "Aplicación: ", ;
                       "Fecha: ", ;
                       "Hora: ", ;
                       "Versión: ", ;
                       "Alias en uso: ", ;
                       "Nombre de Equipo: ", ;
                       "Nombre de Usuario: ", ;
                       "Error: ", ;
                       "Llamada desde ", ;
                       "Eventos:", ;
                       "Error de Programa" }

   CASE cLang == "FI"                               // Finnish
      ::aMessages := { "OOHG Errors Log", ;
                       "Application: ", ;
                       "Date: ", ;
                       "Time: ", ;
                       "Version: ", ;
                       "Alias in use: ", ;
                       "Computer Name: ", ;
                       "User Name: ", ;
                       "Error: ", ;
                       "Called from ", ;
                       "Events:", ;
                       "Program Error" }

   CASE cLang == "NL"                               // Dutch
      ::aMessages := { "OOHG Errors Log", ;
                       "Application: ", ;
                       "Date: ", ;
                       "Time: ", ;
                       "Version: ", ;
                       "Alias in use: ", ;
                       "Computer Name: ", ;
                       "User Name: ", ;
                       "Error: ", ;
                       "Called from ", ;
                       "Events:", ;
                       "Program Error" }

   CASE cLang == "SLWIN" .OR. ;
        cLang == "SLISO" .OR. ;
        cLang == "SL852" .OR. ;
        cLang == "SL437" .OR. ;
        cLang == "SL"                               // Slovenian
      ::aMessages := { "OOHG Errors Log", ;
                       "Application: ", ;
                       "Date: ", ;
                       "Time: ", ;
                       "Version: ", ;
                       "Alias in use: ", ;
                       "Computer Name: ", ;
                       "User Name: ", ;
                       "Error: ", ;
                       "Called from ", ;
                       "Events:", ;
                       "Program Error" }

   CASE cLang == "TRWIN" .OR. ;
        cLang == "TR"                               // Turkish
      ::aMessages := { "OOHG Errors Log", ;
                       "Application: ", ;
                       "Date: ", ;
                       "Time: ", ;
                       "Version: ", ;
                       "Alias in use: ", ;
                       "Computer Name: ", ;
                       "User Name: ", ;
                       "Error: ", ;
                       "Called from ", ;
                       "Events:", ;
                       "Program Error" }

   OTHERWISE                                        // Default to English
      ::cLang := "EN"
      ::aMessages := { "OOHG Errors Log", ;
                       "Application: ", ;
                       "Date: ", ;
                       "Time: ", ;
                       "Version: ", ;
                       "Alias in use: ", ;
                       "Computer Name: ", ;
                       "User Name: ", ;
                       "Error: ", ;
                       "Called from ", ;
                       "Events:", ;
                       "Program Error" }
   ENDCASE

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Write( cTxt ) CLASS OOHG_TErrorHtml

   ::cBufferFile   += ::Write2( cTxt )
   ::cBufferScreen += cTxt + CRLF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Write2( cTxt ) CLASS OOHG_TErrorHtml

   RETURN RTrim( cTxt ) + "<br>" + CRLF

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD FileHeader( cTitle ) CLASS OOHG_TErrorHtml

RETURN "<HTML><HEAD><TITLE>" + cTitle + "</TITLE></HEAD>" + CRLF + ;
       "<style> "                                                + ;
         "body{ "                                                + ;
           "font-family: sans-serif;"                            + ;
           "background-color: #ffffff;"                          + ;
           "font-size: 75%;"                                     + ;
           "color: #000000;"                                     + ;
           "}"                                                   + ;
         "h1{"                                                   + ;
           "font-family: sans-serif;"                            + ;
           "font-size: 150%;"                                    + ;
           "color: #0000cc;"                                     + ;
           "font-weight: bold;"                                  + ;
           "background-color: #f0f0f0;"                          + ;
           "}"                                                   + ;
         ".updated{"                                             + ;
           "font-family: sans-serif;"                            + ;
           "color: #cc0000;"                                     + ;
           "font-size: 110%;"                                    + ;
           "}"                                                   + ;
         ".normaltext{"                                          + ;
          "font-family: sans-serif;"                             + ;
          "font-size: 100%;"                                     + ;
          "color: #000000;"                                      + ;
          "font-weight: normal;"                                 + ;
          "text-transform: none;"                                + ;
          "text-decoration: none;"                               + ;
        "}"                                                      + ;
       "</style>"                                                + ;
       "<BODY>" + CRLF                                           + ;
       "<H1 Align=Center>" + cTitle + "</H1><br>" + CRLF

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD CreateLog() CLASS OOHG_TErrorHtml

   LOCAL nHdl, cFile, cTop, cBottom, nPos

   IF Empty( ::Path )
      IF Empty( CurDir() )
        cFile := '\'
      ELSE
        cFile := '\' + CurDir() + '\'
      ENDIF
   ELSE
      IF Right( ::Path, 1 ) == '\'
         cFile := ::Path
      ELSE
         cFile := ::Path + '\'
      ENDIF
   ENDIF
   cFile += ::FileName

   cBottom := MemoRead( cFile )
   nPos := At( ::PreHeader(), cBottom )
   IF nPos == 0
      cTop := ::FileHeader( ::aMessages[1] )
   ELSE
      cTop := Left( cBottom, nPos - 1 )
      cBottom := SubStr( cBottom, nPos )
   ENDIF
   nHdl := FCreate( cFile )
   FWrite( nHdl, cTop )
   FWrite( nHdl, ::cBufferFile )
   FWrite( nHdl, cBottom )
   FClose( nHdl )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DeleteLog() CLASS OOHG_TErrorHtml

   LOCAL cFile

   IF Empty( ::Path )
      IF Empty( CurDir() )
        cFile := '\'
      ELSE
        cFile := '\' + CurDir() + '\'
      ENDIF
   ELSE
      IF Right( ::Path, 1 ) == '\'
         cFile := ::Path
      ELSE
         cFile := ::Path + '\'
      ENDIF
   ENDIF
   cFile += ::FileName

   IF FILE( cFile )
      ERASE ( cFile )
   ENDIF

   RETURN ! FILE( cFile )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD CopyLog( cTo ) CLASS OOHG_TErrorHtml

   LOCAL cFile

   IF ! ValType( cTo ) $ "CM"
      RETURN .F.
   ENDIF
   IF FILE( cTo )
      ERASE ( cTo )
      IF FILE( cTo )
         RETURN .F.
      ENDIF
   ENDIF

   IF Empty( ::Path )
      IF Empty( CurDir() )
        cFile := '\'
      ELSE
        cFile := '\' + CurDir() + '\'
      ENDIF
   ELSE
      IF Right( ::Path, 1 ) == '\'
         cFile := ::Path
      ELSE
         cFile := ::Path + '\'
      ENDIF
   ENDIF
   cFile += ::FileName

   IF ! FILE( cFile )
      RETURN .F.
   ENDIF

   COPY FILE ( cFile ) TO ( cTo )

   RETURN FILE( cTo )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ErrorMessage( cError, nPosition ) CLASS OOHG_TErrorHtml

   #ifdef __ERROR_EVENTS__
      LOCAL aEvents
   #endif

   // Header
   ::cBufferScreen += OOHGVersion() + CRLF + cError + CRLF
   ::cBufferFile   += ::PreHeader()
   ::cBufferFile   += ::Write2( ::aMessages[2] + GetProgramFileName() )
   ::cBufferFile   += ::Write2( ::aMessages[3] + DToC( Date() ) + "  " + ::aMessages[4] + Time() )
   ::cBufferFile   += ::Write2( ::aMessages[5] + OOHGVersion() )
   ::cBufferFile   += ::Write2( ::aMessages[6] + Alias() )
   ::cBufferFile   += ::Write2( ::aMessages[7] + NetName() )
   ::cBufferFile   += ::Write2( ::aMessages[8] + NetName( 1 ) )
   ::cBufferFile   += ::Write2( ::aMessages[9] + cError )
   ::ErrorHeader()
   ::cBufferFile   += ::PostHeader()

   // Called functions
   nPosition ++
   DO WHILE ! Empty( ProcName( nPosition ) )
      ::Write( ::aMessages[10] + ;
               ProcName( nPosition ) + ;
               " (" + ;
               AllTrim( Str( ProcLine( nPosition ) ) ) + ;
               ")" + ;
               iif( Empty( ProcFile( nPosition ) ), "", " in " + ProcFile( nPosition ) ) )
      nPosition ++
   ENDDO

   #ifdef __ERROR_EVENTS__
      aEvents := _OOHG_AppObject():EventInfoList()
      ::Write( ::aMessages[11] )
      AEval( aEvents, { | c | ::Write( c ) } )
   #endif

   dbCloseAll()
   ::CreateLog()
   C_MSGSTOP( ::cBufferScreen, ::aMessages[12] )
   ExitProcess( Max( ErrorLevel(), 1 ) )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PutMsg( cMsg, nPosition, lEvents ) CLASS OOHG_TErrorHtml

   LOCAL aEvents

   ::cBufferFile += ::PreHeader()
   ::cBufferFile += ::Write2( cMsg )
   ::cBufferFile += ::PostHeader()

   IF HB_ISNUMERIC( nPosition )
      // Called functions
      nPosition ++
      DO WHILE ! Empty( ProcName( nPosition ) )
         ::Write( ::aMessages[10] + ;
                  ProcName( nPosition ) + ;
                  " (" + ;
                  AllTrim( Str( ProcLine( nPosition ) ) ) + ;
                  ")" + ;
                  iif( Empty( ProcFile( nPosition ) ), "", " in " + ProcFile( nPosition ) ) )
         nPosition ++
      ENDDO
   ENDIF

   IF HB_ISLOGICAL( lEvents ) .AND. lEvents
      aEvents := _OOHG_AppObject():EventInfoList()
      ::Write( ::aMessages[11] )
      AEval( aEvents, { | c | ::Write( c ) } )
   ENDIF

   ::CreateLog()

   ::cBufferFile := ""
   ::cBufferScreen := ""

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ErrorHeader() CLASS OOHG_TErrorHtml

   // Insert own header's data here

   RETURN NIL


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS OOHG_TErrorTxt FROM OOHG_TErrorHtml

   DATA PreHeader                 INIT " " + CRLF + Replicate( "-", 80 ) + CRLF + " " + CRLF
   DATA PostHeader                INIT CRLF + CRLF
   DATA FileName                  INIT "ErrorLog.txt"
   DATA FileHeader                INIT ""

   METHOD Write2

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Write2( cTxt ) CLASS OOHG_TErrorTxt

   RETURN RTrim( cTxt ) + CRLF
