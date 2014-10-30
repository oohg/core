/*
 * $Id: h_msgbox.prg,v 1.18 2014-10-30 20:59:43 fyurisich Exp $
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

#include 'oohg.ch'
#include 'i_windefs.ch'

static _OOHG_OneItemPerLine := .F.
static _OOHG_MsgDefaultMessage := ''
static _OOHG_MsgDefaultTitle := ''
static _OOHG_MsgDefaultMode := Nil
// Nil = MB_SYSTEMMODAL, other values MB_APPLMODAL and MB_TASKMODAL

*-----------------------------------------------------------------------------*
Static Function _Dummy()
*-----------------------------------------------------------------------------*
Return EMPTY( _OOHG_AllVars )

*-----------------------------------------------------------------------------*
Function SetOneArrayItemPerLine( lSet )
*-----------------------------------------------------------------------------*

   IF HB_IsLogical( lSet )
      _OOHG_OneItemPerLine := lSet
   ENDIF

Return _OOHG_OneItemPerLine


*-----------------------------------------------------------------------------*
Function SetMsgDefaultMessage( cMessage )
*-----------------------------------------------------------------------------*
   IF valtype( cMessage ) == "C"
      _OOHG_MsgDefaultMessage := cMessage
   ENDIF
Return _OOHG_MsgDefaultMessage


*-----------------------------------------------------------------------------*
Function SetMsgDefaultTitle( cTitle )
*-----------------------------------------------------------------------------*
   IF valtype( cTitle ) == "C"
      _OOHG_MsgDefaultTitle := cTitle
   ENDIF
Return _OOHG_MsgDefaultTitle


*-----------------------------------------------------------------------------*
Function SetMsgDefaultMode( nMode )
*-----------------------------------------------------------------------------*
   IF valtype( nMode ) == "N"
      _OOHG_MsgDefaultMode := nMode
   ENDIF
Return _OOHG_MsgDefaultMode


*-----------------------------------------------------------------------------*
Function MsgYesNo( Message, Title, lRevertDefault, Mode )
*-----------------------------------------------------------------------------*
Local t

   DEFAULT Message TO _OOHG_MsgDefaultMessage
   DEFAULT Title TO _OOHG_MsgDefaultTitle
   DEFAULT Mode TO _OOHG_MsgDefaultMode

   IF HB_IsLogical( lRevertDefault ) .AND. lRevertDefault
      t := c_msgyesno_id( Message, Title, Mode )
   ELSE
      t := c_msgyesno( Message, Title, Mode )
   ENDIF

Return ( t == 6 )


*-----------------------------------------------------------------------------*
Function MsgYesNoCancel( Message, Title, Mode )
*-----------------------------------------------------------------------------*
Local t

   DEFAULT Message TO _OOHG_MsgDefaultMessage
   DEFAULT Title TO _OOHG_MsgDefaultTitle
   DEFAULT Mode TO _OOHG_MsgDefaultMode

   t := c_msgyesnocancel( Message, Title, Mode )

Return iif( t == 6, 1, iif( t == 7, 2, 0 ) )


*-----------------------------------------------------------------------------*
Function MsgRetryCancel( Message, Title, Mode )
*-----------------------------------------------------------------------------*
Local t

   DEFAULT Message TO _OOHG_MsgDefaultMessage
   DEFAULT Title TO _OOHG_MsgDefaultTitle
   DEFAULT Mode TO _OOHG_MsgDefaultMode

   t := c_msgretrycancel( Message, Title, Mode )

Return ( t == 4 )


*-----------------------------------------------------------------------------*
Function MsgOkCancel( Message, Title, Mode )
*-----------------------------------------------------------------------------*
Local t

   DEFAULT Message TO _OOHG_MsgDefaultMessage
   DEFAULT Title TO _OOHG_MsgDefaultTitle
   DEFAULT Mode TO _OOHG_MsgDefaultMode

   t := c_msgokcancel( Message, Title, Mode )

Return ( t == 1 )


*-----------------------------------------------------------------------------*
Function MsgInfo( Message, Title, Mode )
*-----------------------------------------------------------------------------*

   DEFAULT Message TO _OOHG_MsgDefaultMessage
   DEFAULT Title TO _OOHG_MsgDefaultTitle
   DEFAULT Mode TO _OOHG_MsgDefaultMode

   c_msginfo( Message, Title, Mode )

Return Nil


*-----------------------------------------------------------------------------*
Function MsgStop( Message, Title, Mode )
*-----------------------------------------------------------------------------*

   DEFAULT Message TO _OOHG_MsgDefaultMessage
   DEFAULT Title TO _OOHG_MsgDefaultTitle
   DEFAULT Mode TO _OOHG_MsgDefaultMode

   c_msgstop( Message, Title, Mode )

Return Nil


*-----------------------------------------------------------------------------*
Function MsgExclamation( Message, Title, Mode )
*-----------------------------------------------------------------------------*

   DEFAULT Message TO _OOHG_MsgDefaultMessage
   DEFAULT Title TO _OOHG_MsgDefaultTitle
   DEFAULT Mode TO _OOHG_MsgDefaultMode

   c_msgexclamation( Message, Title, Mode )

Return Nil


*-----------------------------------------------------------------------------*
Function MsgExclamationYesNo( Message, Title, Mode )
*-----------------------------------------------------------------------------*
Local t

   DEFAULT Message TO _OOHG_MsgDefaultMessage
   DEFAULT Title TO _OOHG_MsgDefaultTitle
   DEFAULT Mode TO _OOHG_MsgDefaultMode

   t := c_msgexclamationyesno( Message, Title, Mode )

Return ( t == 6 )


*-----------------------------------------------------------------------------*
Function MsgBox( Message, Title, Mode )
*-----------------------------------------------------------------------------*

   DEFAULT Message TO _OOHG_MsgDefaultMessage
   DEFAULT Title TO _OOHG_MsgDefaultTitle
   DEFAULT Mode TO _OOHG_MsgDefaultMode

   c_msgbox( Message, Title, Mode )

Return Nil


*-----------------------------------------------------------------------------*
Function MsgInfoExt( cInfo, cTitulo, nSecs, aBackColor )
*-----------------------------------------------------------------------------*
* (c) LuchoMiranda@telefonica.Net
* modified by Ciro Vargas Clemow for ooHG
*-----------------------------------------------------------------------------*
Local nWidth, nHeight

   DEFAULT cInfo      TO _OOHG_MsgDefaultMessage
   DEFAULT cTitulo    TO _OOHG_MsgDefaultTitle
   DEFAULT nSecs      TO 0
   DEFAULT aBackColor TO {204, 216, 124}

   cInfo   := StrTran( StrTran(cInfo, Chr( 13 ), CRLF), CRLF + Chr( 10 ), CRLF )
   nWidth  := Max( MaxLine( cInfo ), Len( cTitulo ) ) * 12
   nHeight := MLCount( cInfo ) * 20

   DEFINE WINDOW _Win_1 ;
      AT 0, 0 ;
      WIDTH nWidth ;
      HEIGHT 115 + nHeight ;
      NOCAPTION ;
      BACKCOLOR aBackColor ;
      TOPMOST ;
      MINWIDTH nWidth ;
      MAXWIDTH nWidth ;
      MINHEIGHT 115 + nHeight ;
      MAXHEIGHT 115 + nHeight

      ON KEY ESCAPE ACTION _Win_1.Release
      ON KEY RETURN ACTION _Win_1.Release

      IF nSecs >= 1
         DEFINE TIMER _timer__x ;
            INTERVAL nSecs * 1000 ;
            ACTION _Win_1.Release
      ENDIF
   END WINDOW

   @ 12, 00 LABEL Label_1 ;
      PARENT _Win_1 ;
      VALUE cTitulo ;
      WIDTH _Win_1.ClientWidth ;
      HEIGHT 40 ;
      FONT "Times NEW Roman" ;
      SIZE 18 ;
      TRANSPARENT ;
      FONTCOLOR {0, 0, 0} ;
      CENTERALIGN

   @ 46, 00 LABEL Label_2 ;
      PARENT _Win_1 ;
      VALUE "" ;
      WIDTH _Win_1.ClientWidth ;
      HEIGHT 20 + nHeight ;
      FONT "Arial" ;
      SIZE 13 ;
      BOLD ;
      BORDER ;
      CLIENTEDGE ;
      BACKCOLOR {248, 244, 199} ;
      FONTCOLOR {250, 50, 100} ;
      CENTERALIGN

   @ 56, 00 LABEL Label_3 ;
      PARENT _Win_1 ;
      VALUE cInfo ;
      WIDTH _Win_1.ClientWidth ;
      HEIGHT nHeight ;
      FONT "Times NEW Roman" ;
      SIZE 14 ;
      TRANSPARENT ;
      BACKCOLOR {177, 156, 037} ;
      FONTCOLOR {0, 0, 0} ;
      CENTERALIGN

   @ _Win_1.Height - 40, ( _Win_1.ClientWidth - 60 ) / 2  BUTTON Button_1 ;
      PARENT _Win_1 ;
      ACTION _Win_1.Release ;
      WIDTH 60 ;
      HEIGHT 25 ;
      ICON "MINIGUI_EDIT_OK"

    _Win_1.Button_1.SetFocus()

   _Win_1.Center
   _Win_1.Activate

Return Nil


*-----------------------------------------------------------------------------*
Function AutoMsgInfoExt( uInfo, cTitulo, nSecs )
*-----------------------------------------------------------------------------*

   MsgInfoExt( autoType( uInfo ), cTitulo, Nsecs )

Return nil


*-----------------------------------------------------------------------------*
Function autoMsgBox( uMessage, cTitle, nMode )
*-----------------------------------------------------------------------------*

   DEFAULT cTitle TO _OOHG_MsgDefaultTitle
   DEFAULT nMode TO _OOHG_MsgDefaultMode

   uMessage :=  autoType( uMessage )
   c_msgbox( uMessage, cTitle, nMode )

Return Nil


*-----------------------------------------------------------------------------*
Function autoMsgExclamation( uMessage, cTitle, nMode )
*-----------------------------------------------------------------------------*

   DEFAULT cTitle TO _OOHG_MsgDefaultTitle
   DEFAULT nMode TO _OOHG_MsgDefaultMode
 
   uMessage := autoType( uMessage )
   c_msgexclamation( uMessage, cTitle, nMode )

Return Nil


*-----------------------------------------------------------------------------*
Function autoMsgStop( uMessage, cTitle, nMode )
*-----------------------------------------------------------------------------*

   DEFAULT cTitle TO _OOHG_MsgDefaultTitle
   DEFAULT nMode TO _OOHG_MsgDefaultMode

   uMessage := autoType( uMessage )
   c_msgstop( uMessage, cTitle, nMode )

Return Nil


*-----------------------------------------------------------------------------*
Function autoMsgInfo( uMessage, cTitle, nMode )
*-----------------------------------------------------------------------------*

   DEFAULT cTitle TO _OOHG_MsgDefaultTitle
   DEFAULT nMode TO _OOHG_MsgDefaultMode

   uMessage := autoType( uMessage )
   c_msginfo( uMessage, cTitle, nMode )

Return Nil


*-----------------------------------------------------------------------------*
Function autoType( Message )
*-----------------------------------------------------------------------------*
Local cMessage, cType, l, i

   cType := valtype( Message )

   do case
   case cType $ "CNLDM"
      cMessage := transform( Message, "@" ) + "   "
   case cType = "O"
      cMessage := Message:ClassName() + " :Object:   "
   case cType = "A"
      l := len( Message )
      cMessage := ""
      for i := 1 to l
         if _OOHG_OneItemPerLine
            cMessage := cMessage + iif( i = l, autoType( Message[ i ] ), autoType( Message[ i ] ) + chr( 13 ) + chr( 10 ) )
         else
            cMessage := cMessage + iif( i = l, autoType( Message[ i ] ) + chr( 13 ) + chr( 10 ), autoType( Message[ i ] ) + "   " )
         endif
      next i
   case cType = "B"
      cMessage := "{|| Codeblock }   "
   case cType = "H"
      cMessage := ":Hash:   "
   case cType = "P"
      #ifdef __XHARBOUR__
         cMessage :=  ltrim( Hb_ValToStr( Message )) + " HexToNum()=> " + ltrim( str( HexToNum( substr( Hb_ValToStr( Message ), 3 ) ) ) )
      #else
         cMessage :=  ltrim( Hb_ValToStr( Message )) + " Hb_HexToNum()=> " + ltrim( str( Hb_HexToNum( substr( Hb_ValToStr( Message ), 3 ) ) ) )
      #endif
   otherwise
      cMessage := "<NIL>   "
   endcase

Return cMessage
