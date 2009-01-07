/*
 * $Id: h_msgbox.prg,v 1.6 2009-01-07 04:30:39 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG message boxes functions
 *
 * Copyright 2005-2009 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.oohg.org
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

#include 'common.ch'

*-----------------------------------------------------------------------------*
Function MsgYesNo( Message, Title, lRevertDefault )
*-----------------------------------------------------------------------------*
Local t

	DEFAULT Message TO ''
	DEFAULT Title TO ''

   IF HB_IsLogical( lRevertDefault ) .AND. lRevertDefault
      t := c_msgyesno_id( message, title )
   ELSE
      t := c_msgyesno( message, title )
   ENDIF

Return ( t == 6 )

*-----------------------------------------------------------------------------*
Function MsgYesNoCancel( Message, Title )
*-----------------------------------------------------------------------------*
Local t

	DEFAULT Message TO ''
	DEFAULT Title TO ''

   t := c_msgyesnocancel( message, title )

Return iif( t == 6, 1, iif( t == 7, 2, 0 ) )

*-----------------------------------------------------------------------------*
Function MsgRetryCancel( Message , Title )
*-----------------------------------------------------------------------------*
Local t

	DEFAULT Message TO ''
	DEFAULT Title TO ''

   t := c_msgretrycancel( message , title )

Return ( t == 4 )

*-----------------------------------------------------------------------------*
Function MsgOkCancel ( Message , Title )
*-----------------------------------------------------------------------------*
Local t

	DEFAULT Message TO ''
	DEFAULT Title TO ''

	t := c_msgokcancel(message,title)

Return ( t == 1 )

*-----------------------------------------------------------------------------*
Function MsgInfo( Message , Title )
*-----------------------------------------------------------------------------*

	DEFAULT Message TO ''
	DEFAULT Title TO ''

	c_msginfo(message,title)

Return Nil

*-----------------------------------------------------------------------------*
Function MsgStop( Message , Title )
*-----------------------------------------------------------------------------*

	DEFAULT Message TO ''
	DEFAULT Title TO ''

	c_msgstop(message,title)

Return Nil

*-----------------------------------------------------------------------------*
Function MsgExclamation ( Message , Title )
*-----------------------------------------------------------------------------*

	DEFAULT Message TO ''
	DEFAULT Title TO ''

	c_msgexclamation(message,title)

Return Nil

*-----------------------------------------------------------------------------*
Function MsgBox ( Message , Title )
*-----------------------------------------------------------------------------*

	DEFAULT Message TO ''
	DEFAULT Title TO ''

	c_msgbox(message,title)

Return Nil

*-----------------------------------------------------------------------------*
Function autoMsgBox ( Message , Title )
*-----------------------------------------------------------------------------*

	DEFAULT Message TO ''
	DEFAULT Title TO ''

        message :=  autotype(Message)
	c_msgbox(message,title)

Return Nil

*-----------------------------------------------------------------------------*
Function autoMsgExclamation ( Message , Title )
*-----------------------------------------------------------------------------*

	DEFAULT Message TO ''
	DEFAULT Title TO ''
        message := autotype(Message)
	c_msgexclamation(message,title)

Return Nil

*-----------------------------------------------------------------------------*
Function autoMsgStop ( Message , Title )
*-----------------------------------------------------------------------------*

	DEFAULT Message TO ''
	DEFAULT Title TO ''
        message := autotype(Message)
	c_msgstop(message,title)

Return Nil

*-----------------------------------------------------------------------------*
Function autoMsgInfo ( Message , Title )
*-----------------------------------------------------------------------------*

	DEFAULT Message TO ''
	DEFAULT Title TO ''
        message := autotype(Message)
	c_msginfo(message,title)

Return Nil

*-----------------------------------------------------------------------------*
Static function autotype( Message)
*-----------------------------------------------------------------------------*
Local cMessage, ctype
   ctype := valtype( Message )
   do case
      case ctype = "C"
         cMessage := Message
      case ctype = "N"
         cMessage := str( Message )
      case ctype = "L"
         cMessage := iif( Message, ".T.", ".F." )
      case cType = "D"
         cMessage := Dtos( Message )
      case cType = "O"
         cMessage := ":Object:"
      case ctype = "M"
         cMessage := Message
      case ctype = "A"
         cMessage := "{ Array }"
      case ctype = "B"
         cMessage := "{|| Codeblock }"
      case cType = "H"
         cMessage := ":Hash:"
      case cType = "P"
         cMessage := ":Pointer:"
      otherwise
         cMessage := "<NIL>"
   endcase
return cMessage
