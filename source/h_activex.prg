/*
 * $Id: h_activex.prg $
 */
/*
 * ooHG source code:
 * ActiveX control
 *
 * Copyright 2007-2021 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Based upon:
 * TActiveX for [x]Harbour Minigui by Marcelo Torres and Fernando Santolin
 * Copyright 2006 <lichitorres@yahoo.com.ar> and <CarozoDeQuilmes@gmail.com>
 * TActiveX_FreeWin class for Fivewin programmed by Oscar Joel Lira Lira Oscar
 * Copyright 2006 [oSkAr] <oscarlira78@hotmail.com>
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2021 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2021 Contributors, https://harbour.github.io/
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
#include "hbclass.ch"

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TActiveX FROM TControl

   DATA aAxEv                     INIT {}
   DATA aAxExec                   INIT {}
   DATA cProgId                   INIT ""
   DATA hAtl                      INIT NIL
   DATA hSink                     INIT NIL
   DATA nHeight                   INIT NIL
   DATA nWidth                    INIT NIL
   DATA oOle                      INIT NIL
   DATA Type                      INIT "ACTIVEX" READONLY

   METHOD Define
   METHOD Release
   METHOD EventMap( nMsg, xExec, oSelf )

   DELEGATE Set TO oOle
   DELEGATE Get TO oOle
   ERROR HANDLER __Error

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( ControlName, ParentForm, nCol, nRow, nWidth, nHeight, cProgId, ;
               lNoTabStop, lDisabled, lInvisible ) CLASS TActiveX

   LOCAL nStyle, oError, nControlHandle, bErrorBlock, hSink

   ASSIGN ::nCol    VALUE nCol      TYPE "N"
   ASSIGN ::nRow    VALUE nRow      TYPE "N"
   ASSIGN ::nWidth  VALUE nWidth    TYPE "N"
   ASSIGN ::nHeight VALUE nHeight   TYPE "N"

   ::SetForm( ControlName, ParentForm )

   ASSIGN ::nWidth  VALUE ::nWidth  TYPE "N" DEFAULT ::Parent:Width
   ASSIGN ::nHeight VALUE ::nHeight TYPE "N" DEFAULT ::Parent:Height
   ASSIGN ::cProgId VALUE cProgId   TYPE "CM"

   nStyle := ::InitStyle( ,, lInvisible, lNoTabStop, lDisabled )

   nControlHandle := InitActiveX( ::ContainerhWnd, ::cProgId, ::ContainerCol, ::ContainerRow, ::Width, ::Height, nStyle )
   IF ! ValidHandler( nControlHandle )
      OOHG_MsgError( "TActiveX.Define: Container initialization failed. Program terminated." )
   ENDIF
   ::hAtl := AtlAxGetDisp( nControlHandle )
   IF ! ValidHandler( ::hAtl )
      OOHG_MsgError( OOHG_MsgReplace( "TActiveX.Define: Interface pointer initialization failed with code @1. Program terminated.", { { "@1", LTrim( Str( AtlAxHResult() ) ) } } ) )
   ENDIF

   ::Register( nControlHandle, ControlName )

   bErrorBlock := ErrorBlock( { |x| Break( x ) } )
   #ifdef __XHARBOUR__
      TRY
         ::oOle := ToleAuto():New( ::hAtl )
      CATCH oError
         MsgInfo( oError:Description )
      END
   #else
      BEGIN SEQUENCE
         ::oOle := ToleAuto():New( ::hAtl )
      RECOVER USING oError
         MsgInfo( oError:Description )
      END
   #endif
   ErrorBlock( bErrorBlock )

   SetupConnectionPoint( ::hAtl, @hSink, ::aAxEv, ::aAxExec )
   ::hSink := hSink

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Release() CLASS TActiveX

   ::oOle := NIL
   ShutdownConnectionPoint( ::hSink )
   ReleaseDispatch( ::hAtl )

   RETURN ::Super:Release()

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EventMap( nMsg, xExec, oSelf ) CLASS TActiveX

   LOCAL nAt

   nAt := AScan( ::aAxEv, nMsg )
   IF nAt == 0
      AAdd( ::aAxEv, nMsg )
      AAdd( ::aAxExec, { NIL, NIL } )
      nAt := Len( ::aAxEv )
   ENDIF
   ::aAxExec[ nAt ] := { xExec, oSelf }

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD __Error( ... ) CLASS TActiveX

   LOCAL cMessage

   cMessage := __GetMessage()

   RETURN hb_ExecFromArray( ::oOle, cMessage, hb_AParams() )
