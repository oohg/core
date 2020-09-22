/*
 * $Id: h_msgbox.prg $
 */
/*
 * ooHG source code:
 * Messaging functions
 *
 * Copyright 2005-2020 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2020 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2020 Contributors, https://harbour.github.io/
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


#include "oohg.ch"
#include "i_windefs.ch"

STATIC _OOHG_AutoTypeNoSpaces  := .F.
STATIC _OOHG_OneItemPerLine    := .F.
STATIC _OOHG_MsgDefaultMessage := ''
STATIC _OOHG_MsgDefaultTitle   := ''
STATIC _OOHG_MsgDefaultMode    := NIL
// NIL equals MB_SYSTEMMODAL, other valid values are MB_APPLMODAL and MB_TASKMODAL
// See https://msdn.microsoft.com/en-us/library/windows/desktop/ms645505(v=vs.85).aspx


FUNCTION SetAutoTypeNoSpaces( lSet )

   IF HB_ISLOGICAL( lSet )
      _OOHG_AutoTypeNoSpaces := lSet
   ENDIF

   RETURN _OOHG_AutoTypeNoSpaces

FUNCTION SetOneArrayItemPerLine( lSet )

   IF HB_ISLOGICAL( lSet )
      _OOHG_OneItemPerLine := lSet
   ENDIF

   RETURN _OOHG_OneItemPerLine

FUNCTION SetMsgDefaultMessage( cMessage )

   IF ValType( cMessage ) == "C"
      _OOHG_MsgDefaultMessage := cMessage
   ENDIF

   RETURN _OOHG_MsgDefaultMessage

FUNCTION SetMsgDefaultTitle( cTitle )

   IF ValType( cTitle ) == "C"
      _OOHG_MsgDefaultTitle := cTitle
   ENDIF

   RETURN _OOHG_MsgDefaultTitle

FUNCTION SetMsgDefaultMode( nMode )

   IF ValType( nMode ) == "N"
      _OOHG_MsgDefaultMode := nMode
   ENDIF

   RETURN _OOHG_MsgDefaultMode

FUNCTION MsgYesNo( Message, Title, lRevertDefault, Mode )

   LOCAL t

   DEFAULT Message TO _OOHG_MsgDefaultMessage
   DEFAULT Title   TO _OOHG_MsgDefaultTitle
   DEFAULT Mode    TO _OOHG_MsgDefaultMode

   IF HB_ISLOGICAL( lRevertDefault ) .AND. lRevertDefault
      t := C_MSGYESNO_ID( Message, Title, Mode )
   ELSE
      t := C_MSGYESNO( Message, Title, Mode )
   ENDIF

   RETURN ( t == 6 )

FUNCTION MsgYesNoCancel( Message, Title, Mode )

   LOCAL t

   DEFAULT Message TO _OOHG_MsgDefaultMessage
   DEFAULT Title   TO _OOHG_MsgDefaultTitle
   DEFAULT Mode    TO _OOHG_MsgDefaultMode

   t := C_MSGYESNOCANCEL( Message, Title, Mode )

   RETURN iif( t == 6, 1, iif( t == 7, 2, 0 ) )

FUNCTION MsgRetryCancel( Message, Title, Mode )

   LOCAL t

   DEFAULT Message TO _OOHG_MsgDefaultMessage
   DEFAULT Title   TO _OOHG_MsgDefaultTitle
   DEFAULT Mode    TO _OOHG_MsgDefaultMode

   t := C_MSGRETRYCANCEL( Message, Title, Mode )

   RETURN ( t == 4 )

FUNCTION MsgOkCancel( Message, Title, Mode )

   LOCAL t

   DEFAULT Message TO _OOHG_MsgDefaultMessage
   DEFAULT Title   TO _OOHG_MsgDefaultTitle
   DEFAULT Mode    TO _OOHG_MsgDefaultMode

   t := C_MSGOKCANCEL( Message, Title, Mode )

   RETURN ( t == 1 )

FUNCTION MsgInfo( Message, Title, Mode )

   DEFAULT Message TO _OOHG_MsgDefaultMessage
   DEFAULT Title   TO _OOHG_MsgDefaultTitle
   DEFAULT Mode    TO _OOHG_MsgDefaultMode

   C_MSGINFO( Message, Title, Mode )

   RETURN NIL

FUNCTION MsgStop( Message, Title, Mode )

   DEFAULT Message TO _OOHG_MsgDefaultMessage
   DEFAULT Title   TO _OOHG_MsgDefaultTitle
   DEFAULT Mode    TO _OOHG_MsgDefaultMode

   C_MSGSTOP( Message, Title, Mode )

   RETURN NIL

FUNCTION MsgExclamation( Message, Title, Mode )

   DEFAULT Message TO _OOHG_MsgDefaultMessage
   DEFAULT Title   TO _OOHG_MsgDefaultTitle
   DEFAULT Mode    TO _OOHG_MsgDefaultMode

   C_MSGEXCLAMATION( Message, Title, Mode )

   RETURN NIL

FUNCTION MsgExclamationYesNo( Message, Title, Mode )

   LOCAL t

   DEFAULT Message TO _OOHG_MsgDefaultMessage
   DEFAULT Title   TO _OOHG_MsgDefaultTitle
   DEFAULT Mode    TO _OOHG_MsgDefaultMode

   t := C_MSGEXCLAMATIONYESNO( Message, Title, Mode )

   RETURN ( t == 6 )

FUNCTION MsgBox( Message, Title, Mode )

   DEFAULT Message TO _OOHG_MsgDefaultMessage
   DEFAULT Title   TO _OOHG_MsgDefaultTitle
   DEFAULT Mode    TO _OOHG_MsgDefaultMode

   C_MSGBOX( Message, Title, Mode )

   RETURN NIL

FUNCTION MsgInfoExt( cInfo, cTitulo, nSecs, aBackColor )

   LOCAL nWidth, nHeight, _Win_1

   DEFAULT cInfo      TO _OOHG_MsgDefaultMessage
   DEFAULT cTitulo    TO _OOHG_MsgDefaultTitle
   DEFAULT nSecs      TO 0
   DEFAULT aBackColor TO {204, 216, 124}

   cInfo   := StrTran( StrTran( cInfo, Chr( 13 ), CRLF ), CRLF + Chr( 10 ), CRLF )
   nWidth  := Max( 100, Max( MaxLine( cInfo ), Len( cTitulo ) ) * 12 )
   nHeight := MLCount( cInfo ) * 20

   DEFINE WINDOW 0 ;
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

      _Win_1 := _OOHG_ThisForm

      ON KEY ESCAPE ACTION _Win_1:Release()
      ON KEY RETURN ACTION _Win_1:Release()

      IF nSecs >= 1
         DEFINE TIMER 0 ;
            INTERVAL nSecs * 1000 ;
            ACTION _Win_1:Release()
      ENDIF

      @ 12, 00 LABEL Label_1 ;
         VALUE cTitulo ;
         WIDTH _Win_1:ClientWidth ;
         HEIGHT 40 ;
         FONT "Times NEW Roman" ;
         SIZE 18 ;
         TRANSPARENT ;
         FONTCOLOR {0, 0, 0} ;
         CENTERALIGN

      @ 46, 00 LABEL Label_2 ;
         VALUE "" ;
         WIDTH _Win_1:ClientWidth ;
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
         VALUE cInfo ;
         WIDTH _Win_1:ClientWidth ;
         HEIGHT nHeight ;
         FONT "Times NEW Roman" ;
         SIZE 14 ;
         TRANSPARENT ;
         BACKCOLOR {177, 156, 037} ;
         FONTCOLOR {0, 0, 0} ;
         CENTERALIGN

      @ _Win_1:ClientHeight - 40, ( _Win_1:ClientWidth - 60 ) / 2  BUTTON Button_1 ;
         ACTION _Win_1:Release() ;
         WIDTH 60 ;
         HEIGHT 25 ;
         ICON "MINIGUI_EDIT_OK"
   END WINDOW

   _Win_1:Button_1:SetFocus()
   _Win_1:Center()
   _Win_1:Activate()

   RETURN NIL

FUNCTION AutoMsgInfoExt( uInfo, cTitulo, nSecs )

   MsgInfoExt( AutoType( uInfo ), cTitulo, Nsecs )

   RETURN NIL

FUNCTION AutoMsgBox( uMessage, cTitle, nMode )

   DEFAULT cTitle TO _OOHG_MsgDefaultTitle
   DEFAULT nMode  TO _OOHG_MsgDefaultMode

   uMessage := AutoType( uMessage )
   C_MSGBOX( uMessage, cTitle, nMode )

   RETURN NIL

FUNCTION AutoMsgExclamation( uMessage, cTitle, nMode )

   DEFAULT cTitle TO _OOHG_MsgDefaultTitle
   DEFAULT nMode  TO _OOHG_MsgDefaultMode

   uMessage := AutoType( uMessage )
   C_MSGEXCLAMATION( uMessage, cTitle, nMode )

   RETURN NIL

FUNCTION AutoMsgStop( uMessage, cTitle, nMode )

   DEFAULT cTitle TO _OOHG_MsgDefaultTitle
   DEFAULT nMode  TO _OOHG_MsgDefaultMode

   uMessage := AutoType( uMessage )
   C_MSGSTOP( uMessage, cTitle, nMode )

   RETURN NIL

FUNCTION AutoMsgInfo( uMessage, cTitle, nMode )

   DEFAULT cTitle TO _OOHG_MsgDefaultTitle
   DEFAULT nMode  TO _OOHG_MsgDefaultMode

   uMessage := AutoType( uMessage )
   C_MSGINFO( uMessage, cTitle, nMode )

   RETURN NIL

FUNCTION AutoType( Message )

   LOCAL cMessage, cType, l, i

   cType := ValType( Message )

   DO CASE
   CASE cType $ "CNLDM"
      cMessage := Transform( Message, "@" ) + iif( _OOHG_AutoTypeNoSpaces, "", "   " )
   CASE cType == "O"
      cMessage := Message:ClassName() + " :Object:" + iif( _OOHG_AutoTypeNoSpaces, "", "   " )
   CASE cType == "A"
      l := Len( Message )
      cMessage := ""
      FOR i := 1 TO l
         IF _OOHG_OneItemPerLine
            cMessage := cMessage + iif( i == l, AutoType( Message[ i ] ), AutoType( Message[ i ] ) + iif( _OOHG_AutoTypeNoSpaces, "", "   " ) + CRLF )
         ELSE
            cMessage := cMessage + iif( i == l, AutoType( Message[ i ] ) + CRLF, AutoType( Message[ i ] ) + iif( _OOHG_AutoTypeNoSpaces, "", "   " ) )
         ENDIF
      NEXT i
   CASE cType == "B"
      cMessage := "{|| Codeblock }" + iif( _OOHG_AutoTypeNoSpaces, "", "   " )
   CASE cType == "H"
      cMessage := ":Hash:" + iif( _OOHG_AutoTypeNoSpaces, "", "   " )
   CASE cType == "P"
      cMessage :=  LTrim( hb_ValToStr( Message )) + " HexToNum()=> " + LTrim( Str( HexToNum( SubStr( hb_ValToStr( Message ), 3 ) ) ) ) + iif( _OOHG_AutoTypeNoSpaces, "", "   " )
   CASE cType == "T"
      cMessage := "t'" + hb_TSToStr( Message, .T. ) + "'" + iif( _OOHG_AutoTypeNoSpaces, "", "   " )
   CASE cType == "S"
      cMessage := "@" + Message:name + "()" + iif( _OOHG_AutoTypeNoSpaces, "", "   " )
   CASE cMessage == NIL
      cMessage := "<NIL>" + iif( _OOHG_AutoTypeNoSpaces, "", "   " )
   OTHERWISE
      cMessage := "???:" + cType + iif( _OOHG_AutoTypeNoSpaces, "", "   " )
   ENDCASE

   RETURN cMessage

FUNCTION MsgDebug( ... )

   LOCAL i, cMessage, nCnt := PCount()

   cMessage := "Called from: " + ;
               ProcName( 1 ) + ;
               " (" + AllTrim( Str( ProcLine( 1 ) ) ) + ")" + ;
               iif( Empty( ProcFile( 1 ) ), "", " in " + ProcFile( 1 ) ) + ;
               CRLF + CRLF

   FOR i = 1 TO nCnt
      cMessage += ValToPrgExp( PValue( i ) ) + iif( i < nCnt, ", ", "" )
   NEXT

   MsgInfo( cMessage, "DEBUG INFO" )

RETURN cMessage

FUNCTION _MsgBox( Message, Title, Style, Icon, SysModal, TopMost )

   LOCAL cMessage

   DEFAULT Message TO _OOHG_MsgDefaultMessage
   DEFAULT Title   TO _OOHG_MsgDefaultTitle

   cMessage := AutoType( Message )

   IF ! HB_ISLOGICAL( SysModal ) .OR. SysModal
      Style += MB_SYSTEMMODAL
   ELSE
       Style += MB_APPLMODAL
   ENDIF

   IF ! HB_ISLOGICAL( TopMost ) .OR. TopMost
      Style += MB_TOPMOST
   ENDIF

   RETURN MESSAGEBOXINDIRECT( NIL, cMessage, Title, Style, Icon )
