/*
 * $Id: h_application.prg,v 1.7 2017-07-21 00:35:20 fyurisich Exp $
 */
/*
 * ooHG source code:
 * Application object
 *
 * Based upon
 * HMG Extended source code
 * Copyright 2009 by Grigory Filatov <gfilatov@inbox.ru>
 *
 * Copyright 2014-2016 Fernando Yurisich <fyurisich@oohg.org>
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
#include "hbclass.ch"


CLASS TApplication
   DATA ArgC         INIT HB_ArgC()
   DATA Args         INIT GetCommandLineArgs()
   DATA ExeName      INIT GetProgramFileName()

   METHOD BackColor  SETGET
   METHOD Col        SETGET
   METHOD Cursor     SETGET
   METHOD Drive      BLOCK { |Self| Left( ::ExeName, 1 ) }
   METHOD Icon       SETGET
   METHOD MainName   BLOCK { || If( HB_IsObject( _OOHG_Main ), _OOHG_Main:Name, Nil ) }
   METHOD FormObject BLOCK { || _OOHG_Main }
   METHOD Handle     BLOCK { || If( HB_IsObject( _OOHG_Main ), _OOHG_Main:hWnd, Nil ) }
   METHOD Height     SETGET
   METHOD HelpButton SETGET
   METHOD Name       BLOCK { |Self| Substr( ::ExeName, RAt( '\', ::ExeName ) + 1 ) }
   METHOD Path       BLOCK { |Self| Left( ::ExeName, RAt( '\', ::ExeName ) - 1 ) }
   METHOD Row        SETGET
   METHOD Title      SETGET
   METHOD TopMost    SETGET
   METHOD Width      SETGET
ENDCLASS


//------------------------------------------------------------------------------
METHOD BackColor( uColor ) CLASS TApplication
//------------------------------------------------------------------------------
   Local uRet := Nil

   If PCount() > 0
      If HB_IsObject( _OOHG_Main )
         uRet := _OOHG_Main:BackColor( uColor )
      EndIf
   Else
      If HB_IsObject( _OOHG_Main )
         uRet := _OOHG_Main:BackColor()
      EndIf
   EndIf
Return uRet

//------------------------------------------------------------------------------
METHOD Col( nCol ) CLASS TApplication
//------------------------------------------------------------------------------
Return If( HB_IsObject( _OOHG_Main ), _OOHG_Main:Col( nCol ), Nil )


//------------------------------------------------------------------------------
METHOD Cursor( uValue ) CLASS TApplication
//------------------------------------------------------------------------------
Return If( HB_IsObject( _OOHG_Main ), _OOHG_Main:Cursor( uValue ), Nil )


//------------------------------------------------------------------------------
METHOD Height( nHeight ) CLASS TApplication
//------------------------------------------------------------------------------
Return If( HB_IsObject( _OOHG_Main ), _OOHG_Main:Height( nHeight ), Nil )


//------------------------------------------------------------------------------
METHOD Icon( cIcon ) CLASS TApplication
//------------------------------------------------------------------------------
   If PCount() > 0
      _OOHG_Main_Icon := cIcon
   EndIf
Return _OOHG_Main_Icon


//------------------------------------------------------------------------------
METHOD HelpButton( lShow ) CLASS TApplication
//------------------------------------------------------------------------------
Return If( HB_IsObject( _OOHG_Main ), _OOHG_Main:HelpButton( lShow ), Nil )


//------------------------------------------------------------------------------
METHOD Row( nRow ) CLASS TApplication
//------------------------------------------------------------------------------
Return If( HB_IsObject( _OOHG_Main ), _OOHG_Main:Row( nRow ), Nil )


//------------------------------------------------------------------------------
METHOD Title( cTitle ) CLASS TApplication
//------------------------------------------------------------------------------
Return If( HB_IsObject( _OOHG_Main ), _OOHG_Main:Title( cTitle ), Nil )


//------------------------------------------------------------------------------
METHOD TopMost( lTopmost ) CLASS TApplication
//------------------------------------------------------------------------------
Return If( HB_IsObject( _OOHG_Main ), _OOHG_Main:TopMost( lTopmost ), Nil )


//------------------------------------------------------------------------------
METHOD Width( nWidth ) CLASS TApplication
//------------------------------------------------------------------------------
Return If( HB_IsObject( _OOHG_Main ), _OOHG_Main:Width( nWidth ), Nil )


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
