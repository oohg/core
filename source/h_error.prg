/*
 * $Id: h_error.prg,v 1.35 2008-04-29 13:32:07 declan2005 Exp $
 */
/*
 * ooHG source code:
 * Error handling system
 *
 * Copyright 2005 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.guerra.com.mx
 *
 * Portions of this code are copyrighted by the Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
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
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
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
 *
 */
/*----------------------------------------------------------------------------
 MINIGUI - Harbour Win32 GUI library source code

 Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 http://www.geocities.com/harbour_minigui/

 This program is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later
 version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along with
 this software; see the file COPYING. If not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or
 visit the web site http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text
 contained in this release of Harbour Minigui.

 The exception is that, if you link the Harbour Minigui library with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the
 Harbour-Minigui library code into it.

 Parts of this project are based upon:

	"Harbour GUI framework for Win32"
 	Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
 	Copyright 2001 Antonio Linares <alinares@fivetech.com>
	www - http://www.harbour-project.org

	"Harbour Project"
	Copyright 1999-2003, http://www.harbour-project.org/
---------------------------------------------------------------------------*/

*------------------------------------------------------------------------------
*-Module: h_error.prg
*-Target: Colect MiniGui Errors
*-Date Created: 01-01-2003
*-Author: Antonio Novo  novoantonio@hotmail.com
*-Compile with: -w -n
*------------------------------------------------------------------------------

*------------------------------------------------------------------------------
*-Function: MsgOOHGError
*-Recieve: Message (String)
*-Return: Nil
*------------------------------------------------------------------------------
#include "oohg.ch"
#include "error.ch"
#include "common.ch"

Function MsgOOHGError( cMessage )
   // Kill timers and hot keys
   _KillAllTimers()
   _KillAllKeys()

   OwnErrorHandler():ErrorMessage( cMessage, 1 )
Return Nil

*------------------------------------------------------------------------------*
PROCEDURE ErrorSys
*------------------------------------------------------------------------------*
	ErrorBlock( { | oError | DefError( oError ) } )
RETURN

STATIC FUNCTION DefError( oError )
LOCAL cMessage, cDOSError

   // By default, division by zero results in zero
   IF oError:genCode == EG_ZERODIV
      RETURN 0
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

   cMessage := ErrorMessage( oError )
   IF ! Empty( oError:osCode )
      cDOSError := "(DOS Error " + LTrim( Str( oError:osCode ) ) + ")"
   ENDIF

   // Kill timers and hot keys
   _KillAllTimers()
   _KillAllKeys()

   // "Quit" selected

   IF ! Empty( oError:osCode )
      cMessage += " " + cDOSError
   ENDIF

   OwnErrorHandler():ErrorMessage( cMessage, 2 )
RETURN .F.

// [vszakats]

STATIC FUNCTION ErrorMessage( oError )
   LOCAL cMessage

   // start error message
   cMessage := iif( oError:severity > ES_WARNING, "Error", "Warning" ) + " "

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

RETURN cMessage

STATIC FUNCTION OwnErrorHandler()
Local oErrorLog
MemVar _OOHG_TxtError
   If Type( "_OOHG_TXTERROR" ) == "L" .AND. _OOHG_TxtError
      oErrorLog := OOHG_TErrorTxt()
   ElseIf Type( "_OOHG_TXTERROR" ) == "O"
      oErrorLog := _OOHG_TxtError
   ELSE
      oErrorLog := OOHG_TErrorHtml()
   EndIf
RETURN oErrorLog

#include "hbclass.ch"

CLASS OOHG_TErrorHtml
   DATA cBufferFile   INIT ""
   DATA cBufferScreen INIT ""
   DATA PreHeader     INIT '<HR>' + CHR( 13 ) + CHR( 10 ) + '<p class="updated">'
   DATA PostHeader    INIT '</p>'
   DATA FileName      INIT "ErrorLog.Htm"
   METHOD Write
   METHOD Write2
   METHOD FileHeader

   METHOD ErrorMessage
   METHOD CreateLog
ENDCLASS

METHOD Write( cTxt ) CLASS OOHG_TErrorHtml
   ::cBufferFile   += ::Write2( cTxt )
   ::cBufferScreen += cTxt + CHR( 13 ) + CHR( 10 )
RETURN nil

METHOD Write2( cTxt ) CLASS OOHG_TErrorHtml
RETURN RTRIM( cTxt ) + "<br>" + CHR( 13 ) + CHR( 10 )

*------------------------------------------------------------------------------
*-30-12-2002
*-AUTHOR: Antonio Novo
*-HTML Page Head
*------------------------------------------------------------------------------

METHOD FileHeader( cTitle ) CLASS OOHG_TErrorHtml
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

METHOD CreateLog() CLASS OOHG_TErrorHtml
LOCAL nHdl, cFile, cTop, cBottom, nPos
   cFile := "\" + CurDir() + "\" + ::FileName
   cBottom := MEMOREAD( cFile )
   nPos := AT( ::PreHeader(), cBottom )
   IF nPos == 0
      cTop := ::FileHeader( "Clip2Win Errorlog File" )
   ELSE
      cTop := LEFT( cBottom, nPos - 1 )
      cBottom := SUBSTR( cBottom, nPos )
   ENDIF
   nHdl := FCREATE( cFile )
   FWRITE( nHdl, cTop )
   FWRITE( nHdl, ::cBufferFile )
   FWRITE( nHdl, cBottom )
   FCLOSE( nHdl )
RETURN nil

METHOD ErrorMessage( cError, nPosition ) CLASS OOHG_TErrorHtml
   #ifdef __ERROR_EVENTS__
      Local aEvents
   #endif

   // Header
   ::cBufferScreen += ooHGVersion() + CHR( 13 ) + CHR( 10 ) + cError + CHR( 13 ) + CHR( 10 )
   //
   ::cBufferFile   += ::Write2( ::PreHeader() + "Date: " + Dtoc( Date() ) + "  " + "Time: " + Time() )
   ::cBufferFile   += ::Write2( "Version: " + ooHGVersion() )
   ::cBufferFile   += ::Write2( "Alias in use: "+ alias() )
   ::cBufferFile   += ::Write2( "Error: " + cError + ::PostHeader() )

   // Called functions
   nPosition++
   DO WHILE ! Empty( ProcName( nPosition ) )
      ::Write( "Called from " + ProcName( nPosition ) + "(" + AllTrim( Str( ProcLine( nPosition++ ) ) ) + ")" )
   ENDDO

   // Event list
   #ifdef __ERROR_EVENTS__
      aEvents := _ListEventInfo()
      ::Write( "Events:" )
      AEVAL( aEvents, { | c | ::Write( c ) } )
   #endif

	dbcloseall()
   ::CreateLog()
   C_MSGSTOP( ::cBufferScreen, "Program Error" )
   ExitProcess( 0 )
RETURN nil

CLASS OOHG_TErrorTxt FROM OOHG_TErrorHtml
   DATA cBufferFile   INIT ""
   DATA cBufferScreen INIT ""
   DATA PreHeader     INIT " " + CHR( 13 ) + CHR( 10 ) + replicate( "-", 80 ) + CHR( 13 ) + CHR( 10 ) + " " + CHR( 13 ) + CHR( 10 )
   DATA PostHeader    INIT CHR( 13 ) + CHR( 10 ) + CHR( 13 ) + CHR( 10 )
   DATA FileName      INIT "ErrorLog.txt"
   METHOD Write2
   DATA FileHeader    INIT ""
ENDCLASS

METHOD Write2( cTxt ) CLASS OOHG_TErrorTxt
RETURN RTRIM( cTxt ) + CHR( 13 ) + CHR( 10 )

*------------------------------------------------------------------------------
Function ooHGVersion()
*------------------------------------------------------------------------------
Return "ooHG V2.8 - 2008.04.28"

Function MiniGuiVersion()
Return ooHGVersion()
