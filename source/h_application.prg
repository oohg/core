/*
 * $Id: h_application.prg,v 1.10 2017-10-01 15:52:26 fyurisich Exp $
 */
/*
 * ooHG source code:
 * Application object
 *
 * Based upon
 * HMG Extended source code
 * Copyright 2009 by Grigory Filatov <gfilatov@inbox.ru>
 *
 * Copyright 2014-2017 Fernando Yurisich <fyurisich@oohg.org>
 * https://sourceforge.net/projects/oohg/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2017, https://harbour.github.io/
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
#include "hbclass.ch"


#define NDX_OOHG_ACTIVECONTROLINFO     01
#define NDX_OOHG_ACTIVEFRAME           02
#define NDX_OOHG_ADJUSTFONT            03
#define NDX_OOHG_ADJUSTWIDTH           04
#define NDX_OOHG_AUTOADJUST            05
#define NDX_OOHG_DEFAULTFONTCOLOR      06
#define NDX_OOHG_DEFAULTFONTNAME       07
#define NDX_OOHG_DEFAULTFONTSIZE       08
#define NDX_OOHG_DIALOGCANCELLED       09
#define NDX_OOHG_EXTENDEDNAVIGATION    10
#define NDX_OOHG_MAIN                  11
#define NDX_OOHG_SAMEENTERDBLCLICK     12
#define NDX_OOHG_TEMPWINDOWNAME        13
#define NDX_OOHG_THISCONTROL           14
#define NDX_OOHG_THISEVENTTYPE         15
#define NDX_OOHG_THISFORM              16
#define NDX_OOHG_THISITEMCELLCOL       17
#define NDX_OOHG_THISITEMCELLHEIGHT    18
#define NDX_OOHG_THISITEMCELLROW       19
#define NDX_OOHG_THISITEMCELLVALUE     20
#define NDX_OOHG_THISITEMCELLWIDTH     21
#define NDX_OOHG_THISITEMCOLINDEX      22
#define NDX_OOHG_THISITEMROWINDEX      23
#define NDX_OOHG_THISOBJECT            24
#define NDX_OOHG_THISQUERYCOLINDEX     25
#define NDX_OOHG_THISQUERYDATA         26
#define NDX_OOHG_THISQUERYROWINDEX     27
#define NDX_OOHG_THISTYPE              28
#define NDX_OOHG_MAIN_ICON             29
#define NUMBER_OF_APP_WIDE_VARS        29


STATIC _OOHG_Application := NIL


CLASS TApplication

   DATA AllVars      INIT Nil
   DATA ArgC         INIT HB_ArgC()            READONLY
   DATA Args         INIT GetCommandLineArgs() READONLY
   DATA ExeName      INIT GetProgramFileName() READONLY

   METHOD BackColor  SETGET
   METHOD Col        SETGET
   METHOD Cursor     SETGET
   METHOD Drive      BLOCK { |Self| Left( ::ExeName, 1 ) }
   METHOD FormObject BLOCK { |Self| ::AllVars[ NDX_OOHG_MAIN ] }
   METHOD Handle     BLOCK { |Self| If( HB_IsObject( ::AllVars[ NDX_OOHG_MAIN ] ), ::AllVars[ NDX_OOHG_MAIN ]:hWnd, Nil ) }
   METHOD Height     SETGET
   METHOD HelpButton SETGET
   METHOD Icon       SETGET
   METHOD MainName   BLOCK { |Self| If( HB_IsObject( ::AllVars[ NDX_OOHG_MAIN ] ), ::AllVars[ NDX_OOHG_MAIN ]:Name, Nil ) }
   METHOD Name       BLOCK { |Self| Substr( ::ExeName, RAt( '\', ::ExeName ) + 1 ) }
   METHOD New        CONSTRUCTOR
   METHOD Path       BLOCK { |Self| Left( ::ExeName, RAt( '\', ::ExeName ) - 1 ) }
   METHOD Row        SETGET
   METHOD Title      SETGET
   METHOD TopMost    SETGET
   METHOD Width      SETGET
ENDCLASS


//------------------------------------------------------------------------------
METHOD New() CLASS TApplication
//------------------------------------------------------------------------------

   IF _OOHG_Application == NIL
      ::AllVars := Array( NUMBER_OF_APP_WIDE_VARS )

      ::AllVars[ NDX_OOHG_ACTIVECONTROLINFO ]  := {}
      ::AllVars[ NDX_OOHG_ACTIVEFRAME ]        := {}
      ::AllVars[ NDX_OOHG_ADJUSTFONT ]         := .T.
      ::AllVars[ NDX_OOHG_ADJUSTWIDTH ]        := .T.
      ::AllVars[ NDX_OOHG_AUTOADJUST ]         := .F.
      ::AllVars[ NDX_OOHG_DEFAULTFONTCOLOR ]   := NIL
      ::AllVars[ NDX_OOHG_DEFAULTFONTNAME ]    := 'Arial'
      ::AllVars[ NDX_OOHG_DEFAULTFONTSIZE ]    := 9
      ::AllVars[ NDX_OOHG_DIALOGCANCELLED ]    := .F.
      ::AllVars[ NDX_OOHG_EXTENDEDNAVIGATION ] := .F.
      ::AllVars[ NDX_OOHG_MAIN ]               := NIL
      ::AllVars[ NDX_OOHG_SAMEENTERDBLCLICK ]  := .F.
      ::AllVars[ NDX_OOHG_TEMPWINDOWNAME ]     := ""
      ::AllVars[ NDX_OOHG_THISCONTROL ]        := NIL
      ::AllVars[ NDX_OOHG_THISEVENTTYPE ]      := ''
      ::AllVars[ NDX_OOHG_THISFORM ]           := NIL
      ::AllVars[ NDX_OOHG_THISITEMCELLCOL ]    := 0
      ::AllVars[ NDX_OOHG_THISITEMCELLHEIGHT ] := 0
      ::AllVars[ NDX_OOHG_THISITEMCELLROW ]    := 0
      ::AllVars[ NDX_OOHG_THISITEMCELLVALUE ]  := NIL
      ::AllVars[ NDX_OOHG_THISITEMCELLWIDTH ]  := 0
      ::AllVars[ NDX_OOHG_THISITEMCOLINDEX ]   := 0
      ::AllVars[ NDX_OOHG_THISITEMROWINDEX ]   := 0
      ::AllVars[ NDX_OOHG_THISOBJECT ]         := ''
      ::AllVars[ NDX_OOHG_THISQUERYCOLINDEX ]  := 0
      ::AllVars[ NDX_OOHG_THISQUERYDATA ]      := ""
      ::AllVars[ NDX_OOHG_THISQUERYROWINDEX ]  := 0
      ::AllVars[ NDX_OOHG_THISTYPE ]           := ''
      ::AllVars[ NDX_OOHG_MAIN_ICON ]          := NIL

      _OOHG_Application := Self
   ENDIF

RETURN Self

//------------------------------------------------------------------------------
METHOD BackColor( uColor ) CLASS TApplication
//------------------------------------------------------------------------------
   Local uRet := Nil

   If PCount() > 0
      If HB_IsObject( ::AllVars[ NDX_OOHG_MAIN ] )
         uRet := ::AllVars[ NDX_OOHG_MAIN ]:BackColor( uColor )
      EndIf
   Else
      If HB_IsObject( ::AllVars[ NDX_OOHG_MAIN ] )
         uRet := ::AllVars[ NDX_OOHG_MAIN ]:BackColor()
      EndIf
   EndIf
Return uRet

//------------------------------------------------------------------------------
METHOD Col( nCol ) CLASS TApplication
//------------------------------------------------------------------------------
Return If( HB_IsObject( ::AllVars[ NDX_OOHG_MAIN ] ), ::AllVars[ NDX_OOHG_MAIN ]:Col( nCol ), Nil )


//------------------------------------------------------------------------------
METHOD Cursor( uValue ) CLASS TApplication
//------------------------------------------------------------------------------
Return If( HB_IsObject( ::AllVars[ NDX_OOHG_MAIN ] ), ::AllVars[ NDX_OOHG_MAIN ]:Cursor( uValue ), Nil )


//------------------------------------------------------------------------------
METHOD Height( nHeight ) CLASS TApplication
//------------------------------------------------------------------------------
Return If( HB_IsObject( ::AllVars[ NDX_OOHG_MAIN ] ), ::AllVars[ NDX_OOHG_MAIN ]:Height( nHeight ), Nil )


//------------------------------------------------------------------------------
METHOD Icon( cIcon ) CLASS TApplication
//------------------------------------------------------------------------------
   If PCount() > 0
      ::AllVars[ NDX_OOHG_MAIN_ICON ] := cIcon
   EndIf
Return ::AllVars[ NDX_OOHG_MAIN_ICON ]


//------------------------------------------------------------------------------
METHOD HelpButton( lShow ) CLASS TApplication
//------------------------------------------------------------------------------
Return If( HB_IsObject( ::AllVars[ NDX_OOHG_MAIN ] ), ::AllVars[ NDX_OOHG_MAIN ]:HelpButton( lShow ), Nil )


//------------------------------------------------------------------------------
METHOD Row( nRow ) CLASS TApplication
//------------------------------------------------------------------------------
Return If( HB_IsObject( ::AllVars[ NDX_OOHG_MAIN ] ), ::AllVars[ NDX_OOHG_MAIN ]:Row( nRow ), Nil )


//------------------------------------------------------------------------------
METHOD Title( cTitle ) CLASS TApplication
//------------------------------------------------------------------------------
Return If( HB_IsObject( ::AllVars[ NDX_OOHG_MAIN ] ), ::AllVars[ NDX_OOHG_MAIN ]:Title( cTitle ), Nil )


//------------------------------------------------------------------------------
METHOD TopMost( lTopmost ) CLASS TApplication
//------------------------------------------------------------------------------
Return If( HB_IsObject( ::AllVars[ NDX_OOHG_MAIN ] ), ::AllVars[ NDX_OOHG_MAIN ]:TopMost( lTopmost ), Nil )


//------------------------------------------------------------------------------
METHOD Width( nWidth ) CLASS TApplication
//------------------------------------------------------------------------------
Return If( HB_IsObject( ::AllVars[ NDX_OOHG_MAIN ] ), ::AllVars[ NDX_OOHG_MAIN ]:Width( nWidth ), Nil )


//------------------------------------------------------------------------------
STATIC FUNCTION GetCommandLineArgs
//------------------------------------------------------------------------------
Local i, nCount, aArgs
   nCount := HB_ArgC()
   aArgs := {}
   For i := 1 To nCount
      aAdd( aArgs, HB_ArgV( i ) )
   Next i
Return aArgs
