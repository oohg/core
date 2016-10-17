/*
 * $Id: h_error.prg,v 1.65 2016-10-17 01:55:34 fyurisich Exp $
 */
/*
 * ooHG source code:
 * Error handling system
 *
 * Based upon
 * Original source code of Antonio Novo
 * Copyright 2003 <novoantonio@hotmail.com>
 *
 * Copyright 2005-2016 Vicente Guerra <vicente@guerra.com.mx>
 * https://sourceforge.net/projects/oohg/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2016, http://www.harbour-project.org/
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
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1335,USA (or download from http://www.gnu.org/licenses/).
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


#include "oohg.ch"
#include "error.ch"
#include "common.ch"
#include "hbclass.ch"

*------------------------------------------------------------------------------*
FUNCTION MsgOOHGError( cMessage )
*------------------------------------------------------------------------------*

   // Kill timers and hot keys
   _KillAllTimers()
   _KillAllKeys()

   OwnErrorHandler():ErrorMessage( cMessage, 1 )

RETURN Nil

*------------------------------------------------------------------------------*
PROCEDURE ErrorSys
*------------------------------------------------------------------------------*

   ErrorBlock( { | oError | DefError( oError ) } )

RETURN

*------------------------------------------------------------------------------*
STATIC FUNCTION DefError( oError )
*------------------------------------------------------------------------------*
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

   // Set NetErr() of there was a database open error
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

   // "Quit" selected

   OwnErrorHandler():ErrorMessage( cMessage, 2 )

RETURN .F.

// [vszakats]
*------------------------------------------------------------------------------*
FUNCTION _OOHG_ErrorMessage( oError )
*------------------------------------------------------------------------------*
LOCAL cMessage

   // start error message
   cMessage := iif( oError:severity > ES_WARNING, _OOHG_Messages( 1, 9 ), _OOHG_Messages( 1, 10 ) ) + " "

   // add subsystem name if available
   IF ISCHARACTER( oError:subsystem )
      cMessage += oError:subsystem()
   ELSE
      cMessage += "???"
   ENDIF

   // add subsystem's error code if available
   IF ISNUMBER( oError:subCode )
      cMessage += "/" + LTrim( Str( oError:subCode ) )
   ELSE
      cMessage += "/???"
   ENDIF

   // add error description if available
   IF ISCHARACTER( oError:description )
      cMessage += "  " + oError:description
   ENDIF

   // add either filename or operation
   DO CASE
   CASE !Empty( oError:filename )
      cMessage += ": " + oError:filename
   CASE !Empty( oError:operation )
      cMessage += ": " + oError:operation
   ENDCASE

   IF ! Empty( oError:osCode )
      cMessage += " (DOS " + _OOHG_Messages( 1, 9 ) + " " + LTrim( Str( oError:osCode ) ) + ")"
   ENDIF

RETURN cMessage

*------------------------------------------------------------------------------*
STATIC FUNCTION OwnErrorHandler()
*------------------------------------------------------------------------------*
Local oErrorLog
MemVar _OOHG_TxtError

   IF TYPE( "_OOHG_TXTERROR" ) == "L" .AND. _OOHG_TxtError
      oErrorLog := OOHG_TErrorTxt():New()
   ELSEIF TYPE( "_OOHG_TXTERROR" ) == "O"
      oErrorLog := _OOHG_TxtError
   ELSE
      oErrorLog := OOHG_TErrorHtml():New()
   ENDIF

RETURN oErrorLog



CLASS OOHG_TErrorHtml
   DATA aMessages     INIT Nil
   DATA cBufferFile   INIT ""
   DATA cBufferScreen INIT ""
   DATA cLang         INIT ""
   DATA FileName      INIT "ErrorLog.htm"
   DATA Path          INIT ""
   DATA PostHeader    INIT '</p>'
   DATA PreHeader     INIT '<HR>' + CHR( 13 ) + CHR( 10 ) + '<p class="updated">'

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

   EMPTY( _OOHG_AllVars )
ENDCLASS

*------------------------------------------------------------------------------*
METHOD New( cLang ) CLASS OOHG_TErrorHtml
*------------------------------------------------------------------------------*
LOCAL nAt

   IF ! VALTYPE( cLang ) $ "CM" .OR. EMPTY( cLang )
      // [x]Harbour's default language
      cLang := Set( _SET_LANGUAGE )
   ENDIF
   IF ( nAt := At( ".", cLang ) ) > 0
      cLang := LEFT( cLang, nAt - 1 )
   ENDIF
   ::cLang := UPPER( ALLTRIM( cLang ) )

   DO CASE
   CASE ::cLang == "HR852"                            // Croatian
      ::aMessages := { "ooHG Errors Log", ;
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

   CASE ::cLang == "EU"                               // Basque
      ::aMessages := { "ooHG Errors Log", ;
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

   CASE ::cLang == "FR"                               // French
      ::aMessages := { "ooHG Errors Log", ;
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

   CASE ::cLang == "DEWIN" .OR. ;
        ::cLang == "DE"                               // German
      ::aMessages := { "ooHG Errors Log", ;
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

   CASE ::cLang == "IT"                               // Italian
      ::aMessages := { "ooHG Errors Log", ;
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

   CASE ::cLang == "PLWIN" .OR. ;
        ::cLang == "PL852" .OR. ;
        ::cLang == "PLISO" .OR. ;
        ::cLang == ""      .OR. ;
        ::cLang == "PLMAZ"                            // Polish
      ::aMessages := { "ooHG Errors Log", ;
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

   CASE ::cLang == "PT"                               // Portuguese
      ::aMessages := { "ooHG Errors Log", ;
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

   CASE ::cLang == "RUWIN" .OR. ;
        ::cLang == "RU866" .OR. ;
        ::cLang == "RUKOI8"                           // Russian
      ::aMessages := { "ooHG Errors Log", ;
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

   CASE ::cLang == "ES"    .OR. ;
        ::cLang == "ESWIN"                            // Spanish
      ::aMessages := { "Registro de Errores de ooHG", ;
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

   CASE ::cLang == "FI"                               // Finnish
      ::aMessages := { "ooHG Errors Log", ;
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

   CASE ::cLang == "NL"                               // Dutch
      ::aMessages := { "ooHG Errors Log", ;
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

   CASE ::cLang == "SLWIN" .OR. ;
        ::cLang == "SLISO" .OR. ;
        ::cLang == "SL852" .OR. ;
        ::cLang == "SL437"                            // Slovenian
      ::aMessages := { "ooHG Errors Log", ;
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

   CASE ::cLang == "TR"                            // Turkish
      ::aMessages := { "ooHG Errors Log", ;
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

   OTHERWISE                                          // Default to English
      ::aMessages := { "ooHG Errors Log", ;
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

*------------------------------------------------------------------------------*
METHOD Write( cTxt ) CLASS OOHG_TErrorHtml
*------------------------------------------------------------------------------*

   ::cBufferFile   += ::Write2( cTxt )
   ::cBufferScreen += cTxt + CHR( 13 ) + CHR( 10 )

RETURN Nil

*------------------------------------------------------------------------------*
METHOD Write2( cTxt ) CLASS OOHG_TErrorHtml
*------------------------------------------------------------------------------*

RETURN RTRIM( cTxt ) + "<br>" + CHR( 13 ) + CHR( 10 )


*------------------------------------------------------------------------------*
METHOD FileHeader( cTitle ) CLASS OOHG_TErrorHtml
*------------------------------------------------------------------------------*
*
RETURN "<HTML><HEAD><TITLE>" + cTitle + "</TITLE></HEAD>" + CHR( 13 ) + CHR( 10 ) + ;
       "<style> "                       + ;
         "body{ "                       + ;
           "font-family: sans-serif;"   + ;
           "background-color: #ffffff;" + ;
           "font-size: 75%;"            + ;
           "color: #000000;"            + ;
           "}"                          + ;
         "h1{"                          + ;
           "font-family: sans-serif;"   + ;
           "font-size: 150%;"           + ;
           "color: #0000cc;"            + ;
           "font-weight: bold;"         + ;
           "background-color: #f0f0f0;" + ;
           "}"                          + ;
         ".updated{"                    + ;
           "font-family: sans-serif;"   + ;
           "color: #cc0000;"            + ;
           "font-size: 110%;"           + ;
           "}"                          + ;
         ".normaltext{"                 + ;
          "font-family: sans-serif;"    + ;
          "font-size: 100%;"            + ;
          "color: #000000;"             + ;
          "font-weight: normal;"        + ;
          "text-transform: none;"       + ;
          "text-decoration: none;"      + ;
        "}"                             + ;
       "</style>"                       + ;
       "<BODY>" + CHR( 13 ) + CHR( 10 ) + ;
       "<H1 Align=Center>" + cTitle + "</H1><br>" + CHR( 13 ) + CHR( 10 )

*------------------------------------------------------------------------------*
METHOD CreateLog() CLASS OOHG_TErrorHtml
*------------------------------------------------------------------------------*
LOCAL nHdl, cFile, cTop, cBottom, nPos

   IF EMPTY( ::Path )
      IF EMPTY( CurDir() )
        cFile := '\'
      ELSE
        cFile := '\' + CurDir() + '\'
      ENDIF
   ELSE
      IF RIGHT( ::Path, 1 ) == '\'
         cFile := ::Path
      ELSE
         cFile := ::Path + '\'
      ENDIF
   ENDIF
   cFile += ::FileName

   cBottom := MEMOREAD( cFile )
   nPos := AT( ::PreHeader(), cBottom )
   IF nPos == 0
      cTop := ::FileHeader( ::aMessages[1] )
   ELSE
      cTop := LEFT( cBottom, nPos - 1 )
      cBottom := SUBSTR( cBottom, nPos )
   ENDIF
   nHdl := FCREATE( cFile )
   FWRITE( nHdl, cTop )
   FWRITE( nHdl, ::cBufferFile )
   FWRITE( nHdl, cBottom )
   FCLOSE( nHdl )

RETURN Nil

*------------------------------------------------------------------------------*
METHOD DeleteLog() CLASS OOHG_TErrorHtml
*------------------------------------------------------------------------------*
LOCAL cFile

   IF EMPTY( ::Path )
      IF EMPTY( CurDir() )
        cFile := '\'
      ELSE
        cFile := '\' + CurDir() + '\'
      ENDIF
   ELSE
      IF RIGHT( ::Path, 1 ) == '\'
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

*------------------------------------------------------------------------------*
METHOD CopyLog( cTo ) CLASS OOHG_TErrorHtml
*------------------------------------------------------------------------------*
LOCAL cFile

   IF ! VALTYPE( cTo ) $ "CM"
      RETURN .F.
   ENDIF
   IF FILE( cTo )
      ERASE ( cTo )
      IF FILE( cTo )
         RETURN .F.
      ENDIF
   ENDIF

   IF EMPTY( ::Path )
      IF EMPTY( CurDir() )
        cFile := '\'
      ELSE
        cFile := '\' + CurDir() + '\'
      ENDIF
   ELSE
      IF RIGHT( ::Path, 1 ) == '\'
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

*------------------------------------------------------------------------------*
METHOD ErrorMessage( cError, nPosition ) CLASS OOHG_TErrorHtml
*------------------------------------------------------------------------------*

   #ifdef __ERROR_EVENTS__
      Local aEvents
   #endif

   // Header
   ::cBufferScreen += ooHGVersion() + CHR( 13 ) + CHR( 10 ) + cError + CHR( 13 ) + CHR( 10 )

   ::cBufferFile   += ::PreHeader()
   ::cBufferFile   += ::Write2( ::aMessages[2] + GetProgramFileName() )
   ::cBufferFile   += ::Write2( ::aMessages[3] + Dtoc( Date() ) + "  " + ::aMessages[4] + Time() )
   ::cBufferFile   += ::Write2( ::aMessages[5] + ooHGVersion() )
   ::cBufferFile   += ::Write2( ::aMessages[6] + Alias() )
   ::cBufferFile   += ::Write2( ::aMessages[7] + NetName() )
   ::cBufferFile   += ::Write2( ::aMessages[8] + NetName( 1 ) )
   ::cBufferFile   += ::Write2( ::aMessages[9] + cError )
   ::ErrorHeader()
   ::cBufferFile   += ::PostHeader()

   // Called functions
   nPosition++
   DO WHILE ! Empty( ProcName( nPosition ) )
      ::Write( ::aMessages[10] + ProcName( nPosition ) + "(" + AllTrim( Str( ProcLine( nPosition++ ) ) ) + ")" )
   ENDDO

   // Event list
   #ifdef __ERROR_EVENTS__
      aEvents := _ListEventInfo()
      ::Write( ::aMessages[11] )
      AEVAL( aEvents, { | c | ::Write( c ) } )
   #endif

   dbcloseall()
   ::CreateLog()
   C_MSGSTOP( ::cBufferScreen, ::aMessages[12] )
   ExitProcess( 0 )
RETURN Nil

*------------------------------------------------------------------------------*
METHOD PutMsg( cMsg, nPosition, lEvents ) CLASS OOHG_TErrorHtml
*------------------------------------------------------------------------------*
LOCAL aEvents

   ::cBufferFile += ::PreHeader()
   ::cBufferFile += ::Write2( cMsg )
   ::cBufferFile += ::PostHeader()

   IF HB_IsNumeric( nPosition )
      // Called functions
      nPosition++
      DO WHILE ! Empty( ProcName( nPosition ) )
         ::Write( ::aMessages[10] + ProcName( nPosition ) + "(" + AllTrim( Str( ProcLine( nPosition++ ) ) ) + ")" )
      ENDDO
   ENDIF

   IF HB_IsLogical( lEvents ) .and. lEvents
      // Event list
      aEvents := _ListEventInfo()
      ::Write( ::aMessages[11] )
      AEVAL( aEvents, { | c | ::Write( c ) } )
   ENDIF

   ::CreateLog()

   ::cBufferFile := ""
   ::cBufferScreen := ""
RETURN Nil

*------------------------------------------------------------------------------*
METHOD ErrorHeader() CLASS OOHG_TErrorHtml
*------------------------------------------------------------------------------*

   // Insert own header's data here

RETURN Nil



CLASS OOHG_TErrorTxt FROM OOHG_TErrorHtml
   DATA PreHeader     INIT " " + CHR( 13 ) + CHR( 10 ) + replicate( "-", 80 ) + CHR( 13 ) + CHR( 10 ) + " " + CHR( 13 ) + CHR( 10 )
   DATA PostHeader    INIT CHR( 13 ) + CHR( 10 ) + CHR( 13 ) + CHR( 10 )
   DATA FileName      INIT "ErrorLog.txt"
   DATA FileHeader    INIT ""

   METHOD Write2
ENDCLASS

*------------------------------------------------------------------------------*
METHOD Write2( cTxt ) CLASS OOHG_TErrorTxt
*------------------------------------------------------------------------------*

RETURN RTRIM( cTxt ) + CHR( 13 ) + CHR( 10 )

*------------------------------------------------------------------------------*
Function ooHGVersion()
*------------------------------------------------------------------------------*

Return "ooHG Ver. 2015.03.14"

*------------------------------------------------------------------------------*
Function MiniGuiVersion()
*------------------------------------------------------------------------------*

Return ooHGVersion()
