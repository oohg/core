/*
 * $Id: h_msgbox.prg,v 1.10 2011-03-21 04:47:54 declan2005 Exp $
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
#include 'i_var.ch'
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


FUNCTION MsgInfoExt(cInfo, cTitulo, nSecs)
* -------------------------------
* (c) LuchoMiranda@telefonica.Net
* modified by Ciro Vargas Clemow for ooHG
* -------------------------------
LOCAL _x_____:= cInfo :=STRTRAN(cInfo,CHR(13),CHR(13) + CHR(10))
LOCAL nWidth  :=MAX(MAXLINE(cInfo),LEN(cTitulo)) *12
LOCAL nHeight :=MLCOUNT(cInfo) * 20

DEFAULT nSecs TO 0

DefineWindow( "_Win_1",, 0, 0, nWidth, 115 + nHeight, .F., .F., .F., .F., .T.,,,,,,, {204,216,124},, .F., .T.,,,,,,,,,,,,,,,,, .F.,,,, .F.,,, .F., .F.,, .F., .F., .F., .F., .F., .F., .F., .F., .F., .F.,, .F.,,,,,,,,,, ) ;

   _DefineAnyKey(, "ESCAPE", {|| _OOHG_AllVars [ 13 ]:release()} )
   _DefineAnyKey(, "RETURN", {|| _OOHG_AllVars [ 13 ]:release()} )

   IF nSecs = 1 .OR. nSecs > 1
      _OOHG_SelectSubClass( TTimer(), ): Define( "_timer__x",, nSecs*1000, {|| _OOHG_AllVars [ 13 ]:Release() }, .F. )
   ENDIF

   _OOHG_SelectSubClass( TLabel(), ):Define( "Label_1",, 000, 12, cTitulo, nWidth, 40, "Times NEW Roman", 18, .F., .F. , .F. , .F. , .F. , .T. ,, {0,0,0},,,, .F., .F., .F., .F. , .F. , .F. , .T. , .F. , .F. , .F. , )
   _OOHG_SelectSubClass( TLabel(), ):Define( "Label_2",, 0-5, 46, "", nWidth+10, 20 + nHeight, "Arial", 13, .T., .T. , .T. , .F. , .F. , .F. , {248,244,199}, {250,50,100},,,, .F., .F., .F., .F. , .F. , .F. , .T. , .F. , .F. , .F. , )
   _OOHG_SelectSubClass( TLabel(), ):Define( "Label_3",, 000, 56, cInfo, nWidth, 00 + nHeight, "Times NEW Roman", 14, .F., .F. , .F. , .F. , .F. , .T. , {177,156,037}, {000,00,000},,,, .F., .F., .F., .F. , .F. , .F. , .T. , .F. , .F. , .F. , )

   _OOHG_SelectSubClass( TButton(), ): Define( "Button_1",, (nWidth/2)-40, GetExistingFormObject( "_Win_1" ):Height-40,, {|| _OOHG_AllVars [ 13 ]:Release()}, 60, 25, "Arial", 10,,,, .F., .F.,, .F. ,.F., .F., .F., .F., .F., .F., .F.,,, "MINIGUI_EDIT_OK", .F., .F., .F., )

   GetExistingControlObject( "button_1", "_Win_1" ):setfocus ()

_EndWindow ()
DoMethod ( "_Win_1" , "Center" )
_ActivateWindow( {"_Win_1"}, .F. )

RETURN( NIL )

Function  AutoMsgInfoExt(uInfo, cTitulo, nSecs)
 MsgInfoExt (autotype(uInfo) , cTitulo, Nsecs)
Return nil

*-----------------------------------------------------------------------------*
Function autoMsgBox ( uMessage , cTitle )
*-----------------------------------------------------------------------------*


 DEFAULT cTitle TO ''

 umessage :=  autotype(uMessage)
 c_msgbox(umessage,ctitle)

Return Nil

*-----------------------------------------------------------------------------*
Function autoMsgExclamation ( uMessage , cTitle )
*-----------------------------------------------------------------------------*

 DEFAULT cTitle TO ''
 umessage := autotype(uMessage)
 c_msgexclamation(umessage,ctitle)

Return Nil

*-----------------------------------------------------------------------------*
Function autoMsgStop ( uMessage , cTitle )
*-----------------------------------------------------------------------------*

 DEFAULT cTitle TO ''
        umessage := autotype(uMessage)
 c_msgstop(umessage,ctitle)

Return Nil

*-----------------------------------------------------------------------------*
Function autoMsgInfo ( uMessage , cTitle )
*-----------------------------------------------------------------------------*

 DEFAULT cTitle TO ''
        umessage := autotype(uMessage)
 c_msginfo(umessage,ctitle)

Return Nil

*-----------------------------------------------------------------------------*
static function autotype( Message)
*-----------------------------------------------------------------------------*
Local cMessage, ctype, l , i

   ctype := valtype( Message )

   do case
      case ctype $ "CNLDM"
         cMessage :=  transform( Message, "@" )+"  "
      case cType = "O"
         cMessage := ":Object:   "
      case ctype = "A"
         l:=len( Message )
         cMessage:=""
         for i:=1 to l
             cMessage = cMessage +  if ( i=l  , autotype( Message [ i ] )+chr(13)+chr(10)  ,  autotype( Message[ i ] ) )
         next i
      case ctype = "B"
         cMessage := "{|| Codeblock }   "
      case cType = "H"
         cMessage := ":Hash:   "
      case cType = "P"
         cMessage :=":Pointer:   "
      otherwise
         cMessage :="<NIL>   "
   endcase
return cMessage
