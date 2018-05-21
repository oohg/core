/*
 * $Id: h_registry.prg $
 */
/*
 * ooHG source code:
 * TReg32 class and registry functions
 *
 * Copyright 2005-2018 Vicente Guerra <vicente@guerra.com.mx>
 * https://oohg.github.io/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2018, https://harbour.github.io/
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

CLASS TReg32

   DATA cRegKey
   DATA nKey
   DATA nHandle
   DATA nError
   DATA lError

   METHOD New( nKey, cRegKey, lShowError )
   METHOD Create( nKey, cRegKey, lShowError )
   METHOD Get( cSubKey, uVar )
   METHOD Set( cSubKey, uVar, nType )
   METHOD Delete( cSubKey )
   METHOD KeyDelete( cSubKey )
   METHOD Close() BLOCK {| Self | If( ::lError, , ( ::nError := RegCloseKey( ::nHandle ) ) ) }

   ENDCLASS

METHOD New( nKey, cRegKey, lShowError ) CLASS TReg32

   Local nReturn, nHandle := 0

   ASSIGN cRegKey VALUE cRegKey TYPE "C" DEFAULT ""

   If ( nReturn := RegOpenKeyExA( nKey, cRegKey, @nHandle ) ) == ERROR_SUCCESS
      ::lError := .F.
   Else
      ::lError := .T.
      If ! HB_IsLogical( lShowError ) .OR. lShowError
         MsgStop( "Error creating TReg32 object (" + LTrim( Str( nReturn ) ) + ")" )
      EndIf
   EndIf

   ::nError := nReturn
   ::nHandle := nHandle
   ::cRegKey := cRegKey

   Return Self

METHOD Create( nKey, cRegKey, lShowError ) CLASS TReg32

   Local nReturn, nHandle := 0

   ASSIGN cRegKey VALUE cRegKey TYPE "C" DEFAULT ""

   If ( nReturn := RegCreateKey( nKey, cRegKey, @nHandle ) ) == ERROR_SUCCESS
      ::lError := .F.
   Else
      ::lError := .T.
      If ! HB_IsLogical( lShowError ) .OR. lShowError
         MsgStop( "Error creating TReg32 object (" + LTrim( Str( nReturn ) ) + ")" )
      EndIf
   EndIf

   ::nError := RegOpenKeyExA( nKey, cRegKey, @nHandle )

   ::lError := ( ::nError != ERROR_SUCCESS )
   ::nHandle := nHandle
   ::cRegKey := cRegKey

   Return Self

METHOD Get( cSubkey, uVar ) CLASS TReg32

   Local cValue := "", nType := 0, nLen := 0, cType

   If ! ::lError
      ::nError := RegQueryValueExA( ::nHandle, cSubkey, 0, @nType, @cValue, @nLen )

      cType := ValType( uVar )
      uVar := cValue
      Do Case
      Case cType == "D"
         uVar := CToD( uVar )
      Case cType == "L"
         uVar := ( Upper( uVar ) == ".T." )
      Case cType == "N"
         uVar := Val( uVar )
      Case cType == "T"
         uVar := CToT( uVar )
      EndCase
   EndIf

   Return uVar

METHOD Set( cSubKey, uVar, nType ) CLASS TReg32

   Local cType, nLen

   If ! ::lError
      cType := ValType( uVar )

      If ValType( nType ) != "N"
         nType := REG_SZ
         Do Case
         Case cType == "D"
            uVar := DToC( uVar )
         Case cType == "L"
            uVar := If( uVar, ".T.", ".F." )
         Case cType == "N"
            uVar := LTrim( Str( uVar ) )
         Case cType == "T"
            uVar := TToC( uVar )
         EndCase
      Else
         nLen := Len( uVar )
         If nLen == 0
            uVar := Chr( 0 )
            nLen := 1
         EndIf
      EndIf

      If nType == REG_SZ .OR. nType == REG_EXPAND_SZ
         nLen := At( Chr( 0 ), uVar )
         If nLen == 0
            nLen := Len( uVar ) + 1
            If nLen == 1
               uVar := Chr( 0 )
            EndIf
         EndIf
      EndIf

      ::nError := RegSetValueExA( ::nHandle, cSubkey, 0, nType, @uVar, nLen )
   EndIf

   Return Nil

METHOD Delete( cSubKey ) CLASS TReg32

   If ! ::lError
      ::nError := RegDeleteValueA( ::nHandle, cSubkey )
   EndIf

   Return Nil

METHOD KeyDelete( cSubKey ) CLASS TReg32

   If ! ::lError
      ::nError := RegDeleteKey( ::nHandle, cSubkey )
   EndIf

   Return Nil


#pragma BEGINDUMP

#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "winreg.h"
#include "tchar.h"

//------------------------------------------------------------------------------
HB_FUNC( REGCLOSEKEY )
//------------------------------------------------------------------------------
{
   hb_retnl( RegCloseKey( (HKEY) hb_parnl( 1 ) ) );
}

//------------------------------------------------------------------------------
HB_FUNC( REGOPENKEYEXA )
//------------------------------------------------------------------------------
{
   long lError;
   HKEY phwHandle;

   lError = RegOpenKeyExA( (HKEY) hb_parnl( 1 ), (LPCTSTR) hb_parc( 2 ), 0, KEY_ALL_ACCESS, &phwHandle );
   if ( lError == ERROR_SUCCESS )
   {
      hb_stornl( PtrToLong( phwHandle ), 3 );
   }
   hb_retnl( lError );
}

//------------------------------------------------------------------------------
HB_FUNC( REGQUERYVALUEEXA )
//------------------------------------------------------------------------------
{
   long lError;
   DWORD lpType = hb_parnl( 4 );
   DWORD lpcbData = 0;

   lError = RegQueryValueExA( (HKEY) hb_parnl( 1 ), (LPTSTR) hb_parc( 2 ), NULL, &lpType, NULL, &lpcbData );
   if ( lError == ERROR_SUCCESS )
   {
      BYTE * lpData;
      lpData = (BYTE *) hb_xgrab( (int) lpcbData + 1 );

      lError = RegQueryValueExA( (HKEY) hb_parnl( 1 ), (LPTSTR) hb_parc( 2 ), NULL, &lpType, (BYTE *) lpData, &lpcbData );
      if ( lError == ERROR_SUCCESS )
      {
         hb_stornl( (long) lpType, 4 );
         hb_storc( (char *) lpData, 5 );
         hb_stornl( (long) lpcbData, 6 );
      }
      hb_xfree( (BYTE *) lpData );
   }
   hb_retnl( lError );
}

//------------------------------------------------------------------------------
HB_FUNC( REGENUMKEYEXA )
//------------------------------------------------------------------------------
{
   FILETIME ft;
   long lError;
   TCHAR Buffer[255];
   DWORD dwBuffSize = 255;
   TCHAR Class[255];
   DWORD dwClass = 255;

   lError = RegEnumKeyEx( (HKEY) hb_parnl( 1 ), hb_parnl( 2 ), Buffer, &dwBuffSize, NULL, Class, &dwClass, &ft );
   if ( lError == ERROR_SUCCESS )
   {
      hb_storc( Buffer, 3 );
      hb_stornl( (long) dwBuffSize, 4 );
      hb_storc( Class , 6 );
      hb_stornl( (long) dwClass, 7 );
   }
   hb_retnl( lError );
}

//------------------------------------------------------------------------------
HB_FUNC( REGSETVALUEEXA )
//------------------------------------------------------------------------------
{
   hb_retnl( RegSetValueExA( (HKEY) hb_parnl( 1 ), hb_parc( 2 ), (DWORD) NULL, hb_parnl( 4 ), (BYTE *) hb_parc( 5 ), hb_parnl( 6 ) ) );
}

//------------------------------------------------------------------------------
HB_FUNC( REGCREATEKEY )
//------------------------------------------------------------------------------
{
   HKEY hKey;
   long lError;

   lError = RegCreateKey( (HKEY) hb_parnl( 1 ), hb_parc( 2 ), &hKey );
   if ( lError == ERROR_SUCCESS )
   {
      hb_stornl( PtrToLong( hKey ), 3 );
   }
   hb_retnl( lError );
}

//------------------------------------------------------------------------------
HB_FUNC( REGENUMVALUEA )
//------------------------------------------------------------------------------
{
   DWORD lpType = 1;
   TCHAR Buffer[255];
   DWORD dwBuffSize = 255;
   DWORD dwClass = 255;
   long lError;

   lError = RegEnumValueA( (HKEY) hb_parnl( 1 ), hb_parnl( 2 ), Buffer, &dwBuffSize, NULL, &lpType, NULL, &dwClass );
   if ( lError == ERROR_SUCCESS )
   {
      hb_storc( Buffer, 3 );
      hb_stornl( (long) dwBuffSize, 4 );
      hb_stornl( (long) lpType, 6 );
      hb_stornl( (long) dwClass, 8 );
   }
   hb_retnl( lError );
}

//------------------------------------------------------------------------------
HB_FUNC( REGDELETEKEY )
//------------------------------------------------------------------------------
{
   hb_retnl( RegDeleteKey( (HKEY) hb_parnl( 1 ), hb_parc( 2 ) ) );
}

//------------------------------------------------------------------------------
HB_FUNC( REGDELETEVALUEA )
//------------------------------------------------------------------------------
{
   hb_retnl( RegDeleteValueA( (HKEY) hb_parnl( 1 ), hb_parc( 2 ) ) );
}

//------------------------------------------------------------------------------
HB_FUNC( REGCONNECTREGISTRY )
//------------------------------------------------------------------------------
{
   LPCTSTR lpValue = hb_parc( 1 );
   HKEY hwKey = (HKEY) hb_parnl( 2 );
   long lError;
   HKEY phwHandle;

   lError = RegConnectRegistry( lpValue, hwKey, &phwHandle );

   if( lError == ERROR_SUCCESS )
   {
      hb_stornl( PtrToLong( phwHandle ), 3 );
   }
   hb_retnl( lError );
}

#pragma ENDDUMP

/*
 * This functions were adapted from HMG Extended
 */


FUNCTION IsRegistryKey( nKey, cRegKey )

   Local oReg, lExist

   oReg := TReg32():New( nKey, cRegKey, .F. )
   lExist := ! oReg:lError
   oReg:Close()

   Return lExist

FUNCTION CreateRegistryKey( nKey, cRegKey )

   Local oReg, lSuccess

   oReg := TReg32():Create( nKey, cRegKey, .F. )
   lSuccess := ! oReg:lError
   oReg:Close()

   Return lSuccess

FUNCTION GetRegistryValue( nKey, cRegKey, cRegVar, cType )

   Local oReg, uVal

   DEFAULT cRegVar TO '', cType TO 'C'

   oReg := TReg32():New( nKey, cRegKey, .F. )
   If ! oReg:lError
      Do Case
      Case cType == 'N'
         uVal := 0
      Case cType == 'D'
         uVal := CToD( '' )
      Case cType == 'L'
         uVal := .F.
      Otherwise
         uVal := ''
      EndCase

      uVal := oReg:Get( cRegVar, uVal )
      IF oReg:nError != ERROR_SUCCESS
         uVal := NIL
      EndIf
   EndIf
   oReg:Close()

   Return uVal

FUNCTION SetRegistryValue( nKey, cRegKey, cRegVar, uVal )

   Local oReg, lSuccess

   DEFAULT cRegVar TO ''

   oReg := TReg32():New( nKey, cRegKey, .F. )
   If ( lSuccess := ! oReg:lError )
      oReg:Set( cRegVar, uVal )
      lSuccess := ( oReg:nError == ERROR_SUCCESS )
   EndIf
   oReg:Close()

   Return lSuccess

FUNCTION DeleteRegistryVar( nKey, cRegKey, cRegVar )

   Local oReg, lSuccess

   DEFAULT cRegVar TO ''

   oReg := TReg32():New( nKey, cRegKey, .F. )
   If ( lSuccess := ! oReg:lError )
      oReg:Delete( cRegVar )
      lSuccess := ( oReg:nError == ERROR_SUCCESS )
   EndIf
   oReg:Close()

   Return lSuccess

FUNCTION DeleteRegistryKey( nKey, cRegKey, cSubKey )

   Local oReg, lSuccess

   oReg := TReg32():New( nKey, cRegKey, .F. )
   If ( lSuccess := ! oReg:lError )
      oReg:KeyDelete( cSubKey )
      lSuccess := ( oReg:nError == ERROR_SUCCESS )
   EndIf
   oReg:Close()

   Return lSuccess
