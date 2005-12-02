/*
 * $Id: h_error.prg,v 1.8 2005-12-02 04:27:17 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG error messages functions
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
    Local n, ai, HtmArch, xText
    MemVar _OOHG_TXTERROR

   // Kill timers and hot keys
   _KillAllTimers()
   _KillAllKeys()

if type("_OOHG_TXTERROR") == "U"
   _OOHG_TXTERROR=.F.
endif


if  .not. _OOHG_TXTERROR
    HtmArch := Html_ErrorLog()
    Html_LineText( HtmArch, "Date:" + Dtoc( Date() ) + "  " + "Time: " + Time() )
    n := 1
    ai := MiniGuiVersion() + chr( 13 ) + chr( 10 ) + Message + chr( 13 ) + chr( 10 ) + chr( 13 ) + chr( 10 )
    Html_LineText( HtmArch, "Error: " + MiniGuiVersion() )
    Html_LineText( HtmArch, Message)
    DO WHILE ! Empty( ProcName( n ) )
       xText := "Called from " + ProcName( n ) + "(" + AllTrim( Str( ProcLine( n++ ) ) ) + ")" + CHR( 13 ) + CHR( 10 )
       ai += xText
       Html_LineText( HtmArch, xText )
    ENDDO
    Html_Line( HtmArch )
else
    set printer to errorlog.txt additive
    set print on
    ? ""
    ? replicate("-",80)
    ? "Date:" + Dtoc( Date() ) + "  " + "Time: " + Time()
    ? " "
    n := 1
    ai := MiniGuiVersion() + chr( 13 ) + chr( 10 ) + Message + chr( 13 ) + chr( 10 ) + chr( 13 ) + chr( 10 )
    ? "Version: " + MiniGuiVersion()
    ?
    ? Message
    ?
    DO WHILE ! Empty( ProcName( n ) )
       xText := "Called from " + ProcName( n ) + "(" + AllTrim( Str( ProcLine( n++ ) ) ) + ")" +chr(13)+chr(10)
       ai += xText
       ? xtext
    ENDDO
    set print off
    set printer to
endif
    ShowError( ai )
Return Nil

*------------------------------------------------------------------------------
Function ooHGVersion()
*------------------------------------------------------------------------------
Return "ooHG pre-release - 2005.12.01"

Function MiniGuiVersion()
Return ooHGVersion()