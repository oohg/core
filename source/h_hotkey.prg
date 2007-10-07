/*
 * $Id: h_hotkey.prg,v 1.9 2007-10-07 22:52:57 guerra000 Exp $
 */
/*
 * ooHG source code:
 * Hot keys functions
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

#include "oohg.ch"
#include "hbclass.ch"

STATIC aKeyTables := { "LBUTTON", "RBUTTON", "CANCEL", "MBUTTON", "XBUTTON1", "XBUTTON2", ".7", "BACK", "TAB", ".10", ;
                       ".11", "CLEAR", "RETURN", ".14", ".15", "SHIFT", "CONTROL", "MENU", "PAUSE", "CAPITAL", ;
                       "KANA", ".22", "JUNJA", "FINAL", "HANJA", ".26", "ESCAPE", "CONVERT", "NONCONVERT", "ACCEPT", ;
                       "MODECHANGE", "SPACE", "PRIOR", "NEXT", "END", "HOME", "LEFT", "UP", "RIGHT", "DOWN", ;
                       "SELECT", "PRINT", "EXECUTE", "SNAPSHOT", "INSERT", "DELETE", "HELP", "0", "1", "2", ;
                       "3", "4", "5", "6", "7", "8", "9", ".58", ".59", ".60", ;
                       ".61", ".62", ".63", ".64", "A", "B", "C", "D", "E", "F", ;
                       "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", ;
                       "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", ;
                       "LWIN", "RWIN", "APPS", ".94", "SLEEP", "NUMPAD0", "NUMPAD1", "NUMPAD2", "NUMPAD3", "NUMPAD4", ;
                       "NUMPAD5", "NUMPAD6", "NUMPAD7", "NUMPAD8", "NUMPAD9", "MULTIPLY", "ADD", "SEPARATOR", "SUBTRACT", "DECIMAL", ;
                       "DIVIDE", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", ;
                       "F10", "F11", "F12", "F13", "F14", "F15", "F16", "F17", "F18", "F19", ;
                       "F20", "F21", "F22", "F23", "F24", ".136", ".137", ".138", ".139", ".140", ;
                       ".141", ".142", ".143", "NUMLOCK", "SCROLL", ".146", ".147", ".148", ".149", ".150", ;
                       ".151", ".152", ".153", ".154", ".155", ".156", ".157", ".158", ".159", "LSHIFT", ;
                       "RSHIFT", "LCONTROL", "RCONTROL", "LMENU", "RMENU" } // 165

#define _HOTKEYMETHOD   SetKey

*------------------------------------------------------------------------------*
Function _DefineHotKey( cParentForm, nMod, nKey, bAction )
*------------------------------------------------------------------------------*
Return ( TControl():SetForm( "", cParentForm ):Parent ):_HOTKEYMETHOD( nKey, nMod, bAction )

*------------------------------------------------------------------------------*
Function _ReleaseHotKey( cParentForm, nMod, nKey )
*------------------------------------------------------------------------------*
Return ( TControl():SetForm( "", cParentForm ):Parent ):_HOTKEYMETHOD( nKey, nMod, nil )

*------------------------------------------------------------------------------*
Function _GetHotKey( cParentForm, nMod, nKey )
*------------------------------------------------------------------------------*
Return ( TControl():SetForm( "", cParentForm ):Parent ):_HOTKEYMETHOD( nKey, nMod )

*------------------------------------------------------------------------------*
Function _PushKey( nKey )
*------------------------------------------------------------------------------*
   Keybd_Event( nKey, .f. )
   Keybd_Event( nKey, .t. )
Return Nil

*------------------------------------------------------------------------------*
Function _PushKeyCommand( cKey )
*------------------------------------------------------------------------------*
LOCAL aKey
   aKey := _DetermineKey( cKey )
   IF aKey[ 1 ] != 0
      Keybd_Event( aKey[ 1 ], .f. )
      Keybd_Event( aKey[ 1 ], .t. )
   ELSE
      MsgOOHGError( "PUSH KEY: Key combination name not valid: " + cKey + ". Program Terminated." )
   ENDIF
Return Nil

*------------------------------------------------------------------------------*
FUNCTION _DetermineKey( cKey )
*------------------------------------------------------------------------------*
LOCAL aKey, nAlt, nCtrl, nShift, nWin, nPos, cKey2, cText
   aKey := { 0, 0 }
   nAlt := nCtrl := nShift := nWin := 0
   cKey2 := UPPER( cKey )
   DO WHILE ! EMPTY( cKey2 )
      nPos := AT( "+", cKey2 )
      IF nPos == 0
         cKey2 := ALLTRIM( cKey2 )
         nPos := ASCAN( aKeyTables, { |c| cKey2 == c } )
         cKey2 := ""
         IF nPos != 0
            aKey := { nPos, nAlt + nCtrl + nShift + nWin }
         // ELSE
            // "Key" description not recognized
         ENDIF
      ELSE
         cText := ALLTRIM( LEFT( cKey2, nPos - 1 ) )
         cKey2 := SUBSTR( cKey2, nPos + 1 )
         IF cText == "ALT"
            nAlt := MOD_ALT
         ELSEIF cText == "CTRL" .OR. cText == "CONTROL"
            nCtrl := MOD_CONTROL
         ELSEIF cText == "SHIFT" .OR. cText == "SHFT"
            nShift := MOD_SHIFT
         ELSEIF cText == "WIN"
            nWin := MOD_WIN
         ELSE
            // Invalid keyword!
            cKey2 := ""
         ENDIF
      ENDIF
   ENDDO
RETURN aKey

*------------------------------------------------------------------------------*
Function _DefineAnyKey( cParentForm, cKey, bAction )
*------------------------------------------------------------------------------*
LOCAL aKey, oWnd, bCode
   aKey := _DetermineKey( cKey )
   IF aKey[ 1 ] != 0
      oWnd := TControl():SetForm( "", cParentForm ):Parent
      bCode := oWnd:_HOTKEYMETHOD( aKey[ 1 ], aKey[ 2 ] )
      IF PCOUNT() > 2
         oWnd:_HOTKEYMETHOD( aKey[ 1 ], aKey[ 2 ], bAction )
      ENDIF
   ELSE
      MsgOOHGError( "HOTKEY: Key combination name not valid: " + cKey + ". Program Terminated." )
      // bCode := NIL
   ENDIF
Return bCode

*------------------------------------------------------------------------------*
Function _DefineAccelerator( cParentForm, cKey, bAction )
*------------------------------------------------------------------------------*
LOCAL aKey, oWnd, bCode
   aKey := _DetermineKey( cKey )
   IF aKey[ 1 ] != 0
      oWnd := TControl():SetForm( "", cParentForm ):Parent
      bCode := oWnd:AcceleratorKey( aKey[ 1 ], aKey[ 2 ] )
      IF PCOUNT() > 2
         oWnd:AcceleratorKey( aKey[ 1 ], aKey[ 2 ], bAction )
      ENDIF
   ELSE
      MsgOOHGError( "ACCELERATOR: Key combination name not valid: " + cKey + ". Program Terminated." )
      // bCode := NIL
   ENDIF
Return bCode

EXTERN InitHotKey, ReleaseHotKey

#pragma BEGINDUMP
#include <hbapi.h>
#include <windows.h>
#include <commctrl.h>
#include "../include/oohg.h"

HB_FUNC( INITHOTKEY )   // InitHotKey( hWnd, nMod, nKey, nHotKeyID )
{
   RegisterHotKey( HWNDparam( 1 ), hb_parni( 4 ), hb_parni( 2 ), hb_parni( 3 ) );
}

HB_FUNC( RELEASEHOTKEY )   // ReleaseHotKey( hWnd, nHotKeyID )
{
   UnregisterHotKey( HWNDparam( 1 ), hb_parni( 2 ) );
}
#pragma ENDDUMP





CLASS THotKey FROM TControl
   DATA Type      INIT "HOTKEY" READONLY
   DATA nKey      INIT 0
   DATA nMod      INIT 0
   DATA OnClick

   METHOD Define
   METHOD Enabled      SETGET
   METHOD Release
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, nMod, nKey, bAction, lDisabled ) CLASS THotKey
*-----------------------------------------------------------------------------*
LOCAL aKey
   IF VALTYPE( nKey ) $ "CM"
      aKey := _DetermineKey( nKey )
      nKey := aKey[ 1 ]
      IF ValType( nMod ) == "N"
         nMod := nMod + aKey[ 2 ]    // MUST BE A BINARY OR!!!
      ELSE
         nMod := aKey[ 2 ]
      ENDIF
   ENDIF

   ASSIGN ::nKey    VALUE nKey    TYPE "N"
   ASSIGN ::nMod    VALUE nMod    TYPE "N"
   ASSIGN ::OnClick VALUE bAction TYPE "B"

   ::SetForm( ControlName, ParentForm )
   ::Container := nil
   IF ValType( lDisabled ) == "L" .AND. lDisabled
      ::lEnabled := .F.
   ELSE
      ::Parent:_HOTKEYMETHOD( ::nKey, ::nMod, ::OnClick )
   ENDIF
   ::Register( 0, ControlName )
Return Self

*-----------------------------------------------------------------------------*
METHOD Enabled( lEnabled ) CLASS THotKey
*-----------------------------------------------------------------------------*
   IF VALTYPE( lEnabled ) == "L" .AND. ::lEnabled != lEnabled
      IF lEnabled
         ::Parent:_HOTKEYMETHOD( ::nKey, ::nMod, ::OnClick )
      ELSE
         ::Parent:_HOTKEYMETHOD( ::nKey, ::nMod, nil )
      ENDIF
      ::lEnabled := lEnabled
   ENDIF
RETURN ::lEnabled

*-----------------------------------------------------------------------------*
METHOD Release() CLASS THotKey
*-----------------------------------------------------------------------------*
   If ::lEnabled
      ::Parent:_HOTKEYMETHOD( ::nKey, ::nMod, nil )
      ::lEnabled := .F.
   EndIf
RETURN ::Super:Release()
