/*
 * $Id: h_timer.prg $
 */
/*
 * ooHG source code:
 * Timer control
 *
 * Copyright 2005-2017 Vicente Guerra <vicente@guerra.com.mx>
 * https://sourceforge.net/projects/oohg/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
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
 * along with this software; see the file LICENSE.txt. If not, write to
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

CLASS TTimer FROM TControl

   DATA Type      INIT "TIMER" READONLY
   DATA Interval  INIT 0

   METHOD Define
   METHOD Value        SETGET
   METHOD Enabled      SETGET
   METHOD Release

   ENDCLASS

METHOD Define( ControlName, ParentForm, Interval, ProcedureName, lDisabled ) CLASS TTimer

   ::SetForm( ControlName, ParentForm )
   ::InitStyle( ,,,, lDisabled )
   ::Register( 0, ControlName, , , , _GetId() )
   ::OnClick  := ProcedureName
   // "Real" initialization
   ::Value := Interval

   Return Self

METHOD Value( nValue ) CLASS TTimer

   If VALTYPE( nValue ) == "N"
      If ::lEnabled
         KillTimer( ::Parent:hWnd, ::Id )
         InitTimer( ::Parent:hWnd, ::Id, nValue )
      EndIf
      ::Interval := nValue
   EndIf

   RETURN ::Interval

METHOD Enabled( lEnabled ) CLASS TTimer

   IF VALTYPE( lEnabled ) == "L" .AND. ::lEnabled != lEnabled
      IF lEnabled
         InitTimer( ::Parent:hWnd, ::Id, ::Interval )
      ELSE
         KillTimer( ::Parent:hWnd, ::Id )
      ENDIF
      ::lEnabled := lEnabled
   ENDIF

   RETURN ::lEnabled

METHOD Release() CLASS TTimer

   If ::lEnabled
      KillTimer( ::Parent:hWnd, ::Id )
   EndIf
   ::lEnabled := .F.

   RETURN ::Super:Release()


EXTERN InitTimer, KillTimer

#pragma BEGINDUMP

#ifndef HB_OS_WIN_32_USED
   #define HB_OS_WIN_32_USED
#endif

#ifndef _WIN32_IE
   #define _WIN32_IE 0x0500
#endif
#if ( _WIN32_IE < 0x0500 )
   #undef _WIN32_IE
   #define _WIN32_IE 0x0500
#endif

#ifndef _WIN32_WINNT
   #define _WIN32_WINNT 0x0400
#endif
#if ( _WIN32_WINNT < 0x0400 )
   #undef _WIN32_WINNT
   #define _WIN32_WINNT 0x0400
#endif

#include <shlobj.h>
#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "winreg.h"
#include "tchar.h"
#include "oohg.h"

HB_FUNC( INITTIMER )
{
   SetTimer( HWNDparam( 1 ),( UINT ) hb_parni( 2 ), ( UINT ) hb_parni( 3 ), ( TIMERPROC ) NULL );
}

HB_FUNC( KILLTIMER )
{
   KillTimer( HWNDparam( 1 ), ( UINT ) hb_parni( 2 ) );
}

#pragma ENDDUMP
