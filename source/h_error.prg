/*
 * $Id: h_error.prg,v 1.22 2006-11-29 14:51:30 declan2005 Exp $
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
Function MsgOOHGError(Message)
    Local n, ai, HtmArch, xText, txtarch
    MemVar _OOHG_TXTERROR

   // Kill timers and hot keys
   _KillAllTimers()
   _KillAllKeys()

   If Type( "_OOHG_TXTERROR" ) != "L"
      _OOHG_TXTERROR := .F.
   EndIf

if  .not. _OOHG_TXTERROR
    HtmArch := Html_ErrorLog()
    Html_LineText(HtmArch, '<p class="updated">Date:' + Dtoc(Date()) + "  " + "Time: " + Time() )
    n := 1
    ai := ooHGVersion() + chr( 13 ) + chr( 10 ) + Message + chr( 13 ) + chr( 10 )
    Html_LineText( HtmArch, "Version: " + ooHGVersion() )
    Html_LineText( HtmArch, "Alias in use: " + alias() )
    Html_LineText( HtmArch, "Error: "+Message +"</p>" )
    DO WHILE ! Empty( ProcName( n ) )
       xText := "Called from " + ProcName( n ) + "(" + AllTrim( Str( ProcLine( n++ ) ) ) + ")" + CHR( 13 ) + CHR( 10 )
       ai += xText
       Html_LineText( HtmArch, xText )
    ENDDO
    Html_Line( HtmArch )
else
    If .Not. File("\"+CurDir()+"\ErrorLog.txt")
        txtArch := Fcreate("\"+CurDir()+"\ErrorLog.txt")
    Else
        txtArch := FOPEN("\"+CurDir()+"\ErrorLog.txt",2)
        FSeek(txtArch,0,2)    //End Of File
    EndIf

    FWRITE(txtARCH,""+CHR(13)+CHR(10))
    FWRITE(txtARCH,replicate("-",80)+CHR(13)+CHR(10))
    FWRITE(txtARCH,""+CHR(13)+CHR(10))
    FWRITE(txtARCH,"Date:" + Dtoc( Date() ) + "  " + "Time: " + Time()+CHR(13)+CHR(10))
    n := 1
    ai := ooHGVersion() + chr( 13 ) + chr( 10 ) + Message + chr( 13 ) + chr( 10 )
    FWRITE(txtARCH,"Version: " + ooHGVersion()+CHR(13)+CHR(10))
    FWRITE(txtARCH,"Alias in use: "+alias()+CHR(13)+CHR(10))
    FWRITE(txtARCH,"Error: "+ Message+CHR(13)+CHR(10))
    FWRITE(txtARCH,""+CHR(13)+CHR(10))
    FWRITE(txtARCH,""+CHR(13)+CHR(10))
    DO WHILE ! Empty( ProcName( n ) )
       xText := "Called from " + ProcName( n ) + "(" + AllTrim( Str( ProcLine( n++ ) ) ) + ")"
       ai += xText + chr(13)  + chr(10)
           FWRITE(txtARCH,ai)
    ENDDO
    fclose(txtarch)
endif
    ShowError( ai )
Return Nil

#include "oohg.ch"
#include "error.ch"
#include "common.ch"

*------------------------------------------------------------------------------*
PROCEDURE ErrorSys
*------------------------------------------------------------------------------*

	ErrorBlock( { | oError | DefError( oError ) } )

RETURN

STATIC FUNCTION DefError( oError )
   LOCAL cMessage
   LOCAL cDOSError
   LOCAL n
   Local Ai
   LOCAL HtmArch, xText, txtarch
   MemVar _OOHG_TXTERROR

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

   If Type( "_OOHG_TXTERROR" ) != "L"
      _OOHG_TXTERROR := .F.
   EndIf

   if ! _OOHG_TXTERROR
      HtmArch := Html_ErrorLog()
   endif
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
   if ! _OOHG_TXTERROR
      Html_LineText(HtmArch, '<p class="updated">Date:' + Dtoc(Date()) + "  " + "Time: " + Time() )
      Html_LineText(HtmArch, "Version: " + ooHGVersion()  )
      Html_LineText(HtmArch, "Alias in use: "+alias()  )
      Html_LineText(HtmArch, "Error: " + cMessage + "</p>" )
      n := 2
      ai = cmessage + chr(13) + chr (10) + chr(13) + chr (10)
      WHILE ! Empty( ProcName( n ) )
         xText := "Called from " + ProcName( n ) + "(" + AllTrim( Str( ProcLine( n++ ) ) ) + ")" +CHR(13) +CHR(10)
         ai = ai + xText
         Html_LineText(HtmArch,xText)
      ENDDO
      Html_Line(HtmArch)
   else
   If .Not. File("\"+CurDir()+"\ErrorLog.txt")
        txtArch := Fcreate("\"+CurDir()+"\ErrorLog.txt")
    Else
        txtArch := FOPEN("\"+CurDir()+"\ErrorLog.txt",2)
        FSeek(txtArch,0,2)    //End Of File
    EndIf

    FWRITE(txtARCH," "+CHR(13)+CHR(10))
    FWRITE(txtARCH,replicate("-",80)+CHR(13)+CHR(10))
    FWRITE(txtARCH," "+CHR(13)+CHR(10))
    FWRITE(txtARCH,"Date:" + Dtoc( Date() ) + "  " + "Time: " + Time()+CHR(13)+CHR(10))
      n := 2
      ai := ooHGVersion() + chr( 13 ) + chr( 10 ) +cMessage + chr( 13 ) + chr( 10 )
      FWRITE(txtARCH,"Version: " + ooHGVersion()+CHR(13)+CHR(10))
    FWRITE(txtARCH,"Alias in use: "+ alias()+CHR(13)+CHR(10))
    FWRITE(txtARCH,"Error: " + Cmessage+CHR(13)+CHR(10))
    FWRITE(txtARCH," "+CHR(13)+CHR(10))
    FWRITE(txtARCH," "+CHR(13)+CHR(10))
      DO WHILE ! Empty( ProcName( n ) )
         xText := "Called from " + ProcName( n ) + "(" + AllTrim( Str( ProcLine( n++ ) ) ) + ")"
         ai += xText + chr(13) + chr(10)
         FWRITE(txtARCH,xtext)
      ENDDO
      fclose(txtarch)
   endif
   ShowError(ai)

   QUIT

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

*******************************************
Function ShowError ( ErrorMesssage )
********************************************

	dbcloseall()

	C_MSGSTOP ( ErrorMesssage , 'Program Error' )

   ExitProcess(0)

Return Nil

*------------------------------------------------------------------------------
*-01-01-2003
*-AUTHOR: Antonio Novo
*-Create/Open the ErrorLog.Htm file
*-Note: Is used in: errorsys.prg and h_error.prg
*------------------------------------------------------------------------------
FUNCTION HTML_ERRORLOG
*---------------------
    Local HtmArch := 0
    If .Not. File("\"+CurDir()+"\ErrorLog.Htm")
        HtmArch := HtmL_Ini("\"+CurDir()+"\ErrorLog.Htm","ooHG Errorlog File")
        Html_Line(HtmArch)
    Else
        HtmArch := FOPEN("\"+CurDir()+"\ErrorLog.Htm",2)
        FSeek(HtmArch,0,2)    //End Of File
    EndIf
RETURN (HtmArch)

*------------------------------------------------------------------------------
*-30-12-2002
*-AUTHOR: Antonio Novo
*-HTML Page Head
*------------------------------------------------------------------------------
FUNCTION HTML_INI(ARCH,TIT)
*-------------------------
    LOCAL HTMARCH
    LOCAL cStilo:= "<style> "                       +;
                     "body{ "                       +;
                       "font-family: sans-serif;"   +;
                       "background-color: #ffffff;" +;
                       "font-size: 75%;"            +;
                       "color: #000000;"            +;
                       "}"                          +;
                     "h1{"                          +;
                       "font-family: sans-serif;"   +;
                       "font-size: 150%;"           +;
                       "color: #0000cc;"            +;
                       "font-weight: bold;"         +;
                       "background-color: #f0f0f0;" +;
                       "}"                          +;
                     ".updated{"                    +;
                       "font-family: sans-serif;"   +;
                       "color: #cc0000;"            +;
                       "font-size: 110%;"           +;
                       "}"                          +;
                     ".normaltext{"                 +;
                      "font-family: sans-serif;"    +;
                      "font-size: 100%;"            +;
                      "color: #000000;"             +;
                      "font-weight: normal;"        +;
                      "text-transform: none;"       +;
                      "text-decoration: none;"      +;
                    "}"                             +;
                    "</style>"

    HTMARCH := FCREATE(ARCH)
    FWRITE(HTMARCH,"<HTML><HEAD><TITLE>"+TIT+"</TITLE></HEAD>" + cStilo +"<BODY>"+CHR(13)+CHR(10))
    FWRITE(HTMARCH,'<H1 Align=Center>'+TIT+'</H1><BR>'+CHR(13)+CHR(10))
RETURN (HTMARCH)

*------------------------------------------------------------------------------
*-30-12-2002
*-AUTHOR: Antonio Novo
*-HTM Page Line
*------------------------------------------------------------------------------
FUNCTION HTML_LINETEXT(HTMARCH,LINEA)
*-----------------------------------
 //   LOCAL XLINEA
 //   XLINEA := RTRIM(LINEA)
    FWRITE(HTMARCH, RTRIM( LINEA ) + "<BR>"+CHR(13)+CHR(10))
RETURN (.T.)

*------------------------------------------------------------------------------
*-30-12-2002
*-AUTHOR: Antonio Novo
*-HTM Line
*------------------------------------------------------------------------------
FUNCTION HTML_LINE(HTMARCH)
*-------------------------
    FWRITE(HTMARCH,"<HR>"+CHR(13)+CHR(10))
RETURN (.T.)


*------------------------------------------------------------------------------
Function ooHGVersion()
*------------------------------------------------------------------------------
Return "ooHG V1.6 - 2006.11.29"

Function MiniGuiVersion()
Return ooHGVersion()