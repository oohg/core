/*
 * $Id: h_registry.prg $
 */
/*
 * ooHG source code:
 * TReg32 class and registry functions
 *
 * Copyright 2005-2019 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2019 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2019 Contributors, https://harbour.github.io/
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


#include "hbclass.ch"
#include "oohg.ch"
#include "i_init.ch"

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TReg32

   DATA cRegKey
   DATA nKey
   DATA nHandle
   DATA nError
   DATA lError

   METHOD New
   METHOD Create
   METHOD Get
   METHOD Set
   METHOD Delete
   METHOD KeyDelete
   METHOD Close      BLOCK { |Self| iif( ::lError, NIL, ( ::nError := RegCloseKey( ::nHandle ) ) ) }

   ENDCLASS

METHOD New( nKey, cRegKey, lShowError ) CLASS TReg32

   LOCAL nReturn, nHandle := 0

   ASSIGN cRegKey VALUE cRegKey TYPE "C" DEFAULT ""

   IF ( nReturn := RegOpenKeyExA( nKey, cRegKey, iif( IsWow64(), hb_bitOr( KEY_ALL_ACCESS, KEY_WOW64_64KEY ), KEY_ALL_ACCESS ), @nHandle ) ) == ERROR_SUCCESS
      ::lError := .F.
   ELSE
      IF ( nReturn := RegOpenKeyExA( nKey, cRegKey, KEY_READ, @nHandle ) ) == ERROR_SUCCESS
         ::lError := .F.
      ELSE
         ::lError := .T.
         IF ! HB_ISLOGICAL( lShowError ) .OR. lShowError
            MsgStop( _OOHG_Messages( MT_MISCELL, 19 ) + " [" + LTrim( Str( nReturn ) ) + "].", _OOHG_Messages( MT_MISCELL, 9 ) )
         ENDIF
      ENDIF
   ENDIF

   ::nError := nReturn
   ::nHandle := nHandle
   ::cRegKey := cRegKey

   RETURN Self

METHOD Create( nKey, cRegKey, lShowError ) CLASS TReg32

   LOCAL nReturn, nHandle := 0

   ASSIGN cRegKey VALUE cRegKey TYPE "C" DEFAULT ""

   IF ( nReturn := RegCreateKey( nKey, cRegKey, @nHandle ) ) == ERROR_SUCCESS
      ::lError := .F.
   ELSE
      ::lError := .T.
      IF ! HB_ISLOGICAL( lShowError ) .OR. lShowError
         MsgStop( _OOHG_Messages( MT_MISCELL, 19 ) + " [" + LTrim( Str( nReturn ) ) + "].", _OOHG_Messages( MT_MISCELL, 9 ) )
      ENDIF
   ENDIF

   ::nError := RegOpenKeyExA( nKey, cRegKey, iif( IsWow64(), hb_BitOr( KEY_ALL_ACCESS, KEY_WOW64_64KEY ), KEY_ALL_ACCESS ), @nHandle )

   ::lError := ( ::nError != ERROR_SUCCESS )
   ::nHandle := nHandle
   ::cRegKey := cRegKey

   RETURN Self

METHOD Get( cRegVar, uVar ) CLASS TReg32

   LOCAL cValue := "", nType := 0, nLen := 0, cType, i

   ASSIGN cRegVar VALUE cRegVar TYPE "C" DEFAULT ""

   IF ! ::lError
      ::nError := RegQueryValueExA( ::nHandle, cRegVar, 0, @nType, @cValue, @nLen )

      IF Empty( ::nError )
         cType := ValType( uVar )
         DO CASE
         CASE cType == "A"
            uVar := Array( nLen )
            FOR i := 1 TO nLen
               uVar[ i ] := Asc( SubStr( cValue, i, 1 ) )
            NEXT i
         CASE cType == "L"
            uVar := ( Upper( cValue ) == ".T." )
         CASE cType == "D"
            uVar := CToD( cValue )
         CASE cType == "N"
            IF nType == REG_SZ
               uVar := Val( cValue )
            ELSE
               uVar := Bin2U( cValue )
            ENDIF
         CASE cType == "T"
            uVar := CToT( cValue )
         OTHERWISE                      
            uVar := cValue
         ENDCASE
      ENDIF
   ENDIF

   RETURN uVar

METHOD Set( cRegVar, uVar, nType ) CLASS TReg32

   LOCAL uData, nByte, nLen := 0

   IF ! ::lError
      SWITCH ValType( uVar )
      CASE "A"   // array of binary values
         IF ! HB_ISNUMERIC( nType )
            nType := REG_BINARY
         ELSEIF nType != REG_BINARY
            // Not supported
            RETURN NIL
         ENDIF
         uData := ""
         FOR EACH nByte IN uVar
            IF ! HB_ISNUMERIC( nByte ) .OR. nByte < 0 .OR. nByte > 255
               RETURN NIL
            ENDIF
            uData += Chr( nByte )
         NEXT
         nLen := Len( uData )
         EXIT
      CASE "L"
         IF ! HB_ISNUMERIC( nType )
            nType := REG_SZ
            uData := iif( uVar, ".T.", ".F." )
         ELSEIF nType == REG_SZ
            uData := iif( uVar, ".T.", ".F." )
         ELSEIF nType == REG_DWORD
            uData := iif( uVar, 1, 0 )
         ELSE
            // Not supported
            RETURN NIL
         ENDIF
         EXIT
      CASE "D"
         IF ! HB_ISNUMERIC( nType )
            nType := REG_SZ
            uData := DToC( uVar )
         ELSEIF nType == REG_SZ
            uData := DToC( uVar )
         ELSE
            // Not supported
            RETURN NIL
         ENDIF
         EXIT
      CASE "N"
         IF ! HB_ISNUMERIC( nType )
            IF _OOHG_SaveAsDWORD
               nType := REG_DWORD
               uData := uVar
            ELSE
               nType := REG_SZ
               uData := LTrim( Str( uVar ) )
            ENDIF
         ELSEIF nType == REG_DWORD .OR. ;
                nType == REG_DWORD_LITTLE_ENDIAN .OR. ;
                nType == REG_DWORD_BIG_ENDIAN .OR. ;
                nType == REG_QWORD .OR. ;
                nType == REG_QWORD_LITTLE_ENDIAN
               uData := uVar
         ELSE
            // Not supported
            RETURN NIL
         ENDIF
         EXIT
      CASE "T"
         IF ! HB_ISNUMERIC( nType )
            nType := REG_SZ
            uData := TToC( uVar )
         ELSEIF nType == REG_SZ
            uData := TToC( uVar )
         ELSE
            // Not supported
            RETURN NIL
         ENDIF
         EXIT
      CASE "C"
      CASE "M"
         IF ! HB_ISNUMERIC( nType )
            nType := REG_SZ
            uData := uVar
         ELSEIF nType == REG_SZ .OR. ;
                nType == REG_EXPAND_SZ .OR. ;
                nType == REG_BINARY .OR. ;
                nType == REG_MULTI_SZ
            uData := uVar
         ELSE
            // Not supported
            RETURN NIL
         ENDIF
         EXIT
      CASE "B"
      CASE "O"
         // Not supported
         RETURN NIL
#ifndef __XHARBOUR__
      OTHERWISE
#else
      DEFAULT
#endif
         IF ! HB_ISNUMERIC( nType )
            nType := REG_NONE
            uData := NIL
         ELSEIF nType == REG_NONE
            uData := NIL
         ELSE
            // Not supported
            RETURN NIL
         ENDIF
         EXIT
      ENDSWITCH

      SWITCH nType
      CASE REG_SZ
      CASE REG_EXPAND_SZ
         IF ValType( uData ) $ "CM"
            nLen := At( Chr( 0 ), uData )
            IF nLen == 0
               uData += Chr( 0 )
               nLen := Len( uData )
            ENDIF
         ELSE
            uData := Chr( 0 )
            nLen := 1
         ENDIF
         EXIT
      CASE REG_MULTI_SZ
         IF ValType( uData ) $ "CM"
            nLen := At( Chr( 0 ) + Chr( 0 ), uData )
            IF nLen == 0
               uData += Chr( 0 ) + Chr( 0 )
               nLen := 1
            ENDIF
            nLen ++
         ELSE
            uData := Chr( 0 ) + Chr( 0 )
            nLen := 2
         ENDIF
         EXIT
      ENDSWITCH

      ASSIGN cRegVar VALUE cRegVar TYPE "C" DEFAULT ""

      ::nError := RegSetValueExA( ::nHandle, cRegVar, 0, nType, @uData, nLen )
   ENDIF

   RETURN NIL

METHOD Delete( cRegVar ) CLASS TReg32

   IF ! ::lError
      ASSIGN cRegVar VALUE cRegVar TYPE "C" DEFAULT ""

      ::nError := RegDeleteValueA( ::nHandle, cRegVar )
   ENDIF

   RETURN NIL

METHOD KeyDelete( cSubKey ) CLASS TReg32

   IF ! ::lError
      ::nError := RegDeleteKey( ::nHandle, cSubkey )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
#pragma BEGINDUMP

#include "oohg.h"
#include <winreg.h>
#include <tchar.h>
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"

typedef long LSTATUS;

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( REGCLOSEKEY )
{
   HB_RETNL( RegCloseKey( (HKEY) HB_PARNL( 1 ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( REGOPENKEYEXA )
{
   LSTATUS lError;
   HKEY phwHandle;

   lError = RegOpenKeyExA( (HKEY) HB_PARNL( 1 ), (LPCTSTR) hb_parc( 2 ), 0, (REGSAM) HB_PARNL( 3 ), &phwHandle );
   if( lError == ERROR_SUCCESS )
   {
      HKEYstor( phwHandle, 4 );
   }
   HB_RETNL( lError );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( REGQUERYVALUEEXA )
{
   LSTATUS lError;
   DWORD lpType = hb_parnl( 4 );
   DWORD lpcbData = 0;

   lError = RegQueryValueExA( (HKEY) HB_PARNL( 1 ), (LPCTSTR) hb_parc( 2 ), NULL, &lpType, NULL, &lpcbData );
   if( lError == ERROR_SUCCESS )
   {
      BYTE * lpData;
      lpData = (BYTE *) hb_xgrab( (int) lpcbData + 1 );

      lError = RegQueryValueExA( (HKEY) HB_PARNL( 1 ), (LPCTSTR) hb_parc( 2 ), NULL, &lpType, (BYTE *) lpData, &lpcbData );
      if( lError == ERROR_SUCCESS )
      {
         HB_STORNL( (long) lpType, 4 );
         hb_storc( (char *) lpData, 5 );
         HB_STORNL( (long) lpcbData, 6 );
      }
      hb_xfree( (BYTE *) lpData );
   }
   HB_RETNL( lError );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( REGENUMKEYEXA )
{
   FILETIME ft;
   LSTATUS lError;
   TCHAR Buffer[255];
   DWORD dwBuffSize = 255;
   TCHAR Class[255];
   DWORD dwClass = 255;

   lError = RegEnumKeyEx( (HKEY) HB_PARNL( 1 ), (DWORD) hb_parnl( 2 ), (LPSTR) Buffer, &dwBuffSize, NULL, (LPSTR) Class, &dwClass, &ft );
   if( lError == ERROR_SUCCESS )
   {
      hb_storc( Buffer, 3 );
      HB_STORNL( (long) dwBuffSize, 4 );
      hb_storc( Class , 6 );
      HB_STORNL( (long) dwClass, 7 );
   }
   HB_RETNL( lError );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( REGSETVALUEEXA )
{
   DWORD dwType = (DWORD) hb_parnl( 4 );

   if( dwType == REG_DWORD )
   {
      DWORD nSpace = (DWORD) hb_parnl( 5 );
      HB_RETNL( RegSetValueExA( (HKEY) HB_PARNL( 1 ), (LPCSTR) hb_parc( 2 ), 0, dwType, (const BYTE *) &nSpace, sizeof( DWORD ) ) );
   }
#if defined( REG_QWORD )
   else if( dwType == REG_QWORD )
   {
      HB_U64 nSpace = (HB_U64) hb_parnint( 5 );
      HB_RETNL( RegSetValueExA( (HKEY) HB_PARNL( 1 ), (LPCSTR) hb_parc( 2 ), 0, dwType, (const BYTE *) &nSpace, sizeof( HB_U64 ) ) );
   }
#endif
   else
   {
      HB_RETNL( RegSetValueExA( (HKEY) HB_PARNL( 1 ), (LPCSTR) hb_parc( 2 ), 0, dwType, (const BYTE *) hb_parc( 5 ), (DWORD) hb_parnl( 6 ) ) );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( REGCREATEKEY )
{
   HKEY hKey;
   LSTATUS lError;

   lError = RegCreateKey( (HKEY) HB_PARNL( 1 ), (LPCSTR) hb_parc( 2 ), &hKey );
   if( lError == ERROR_SUCCESS )
   {
      HKEYstor( hKey, 3 );
   }
   HB_RETNL( lError );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( REGENUMVALUEA )
{
   DWORD lpType = 1;
   TCHAR Buffer[255];
   DWORD dwBuffSize = 255;
   DWORD dwClass = 255;
   LSTATUS lError;

   lError = RegEnumValueA( (HKEY) HB_PARNL( 1 ), hb_parnl( 2 ), Buffer, &dwBuffSize, NULL, &lpType, NULL, &dwClass );
   if( lError == ERROR_SUCCESS )
   {
      hb_storc( Buffer, 3 );
      HB_STORNL( (long) dwBuffSize, 4 );
      HB_STORNL( (long) lpType, 6 );
      HB_STORNL( (long) dwClass, 8 );
   }
   HB_RETNL( lError );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( REGDELETEKEY )
{
   HB_RETNL( RegDeleteKey( (HKEY) HB_PARNL( 1 ), (LPCSTR) hb_parc( 2 ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( REGDELETEVALUEA )
{
   HB_RETNL( RegDeleteValueA( (HKEY) HB_PARNL( 1 ), (LPCSTR) hb_parc( 2 ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( REGCONNECTREGISTRY )
{
   LPCTSTR lpValue = hb_parc( 1 );
   HKEY hwKey = (HKEY) HB_PARNL( 2 );
   LSTATUS lError;
   HKEY phwHandle;

   lError = RegConnectRegistry( lpValue, hwKey, &phwHandle );

   if( lError == ERROR_SUCCESS )
   {
      HKEYstor( phwHandle, 3 );
   }
   HB_RETNL( lError );
}

typedef BOOL ( WINAPI *LPFN_ISWOW64PROCESS ) ( HANDLE, PBOOL );

HB_FUNC( ISWOW64 )
{
   BOOL bIsWow64 = FALSE;
   LPFN_ISWOW64PROCESS fnIsWow64Process;

   fnIsWow64Process = ( LPFN_ISWOW64PROCESS ) _OOHG_GetProcAddress( GetModuleHandle( "kernel32" ), "IsWow64Process" );
   if( NULL != fnIsWow64Process )
   {
      fnIsWow64Process( GetCurrentProcess(), &bIsWow64 );
   }

   hb_retl( bIsWow64 );
}

#pragma ENDDUMP

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION IsRegistryKey( nKey, cRegKey )

   LOCAL oReg, lExist

   oReg := TReg32():New( nKey, cRegKey, .F. )
   lExist := ! oReg:lError
   oReg:Close()

   RETURN lExist

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION CreateRegistryKey( nKey, cRegKey )

   LOCAL oReg, lSuccess

   oReg := TReg32():Create( nKey, cRegKey, .F. )
   lSuccess := ! oReg:lError
   oReg:Close()

   RETURN lSuccess

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION GetRegistryValue( nKey, cRegKey, cRegVar, cType )

   LOCAL oReg, uVal

   ASSIGN cType VALUE cType TYPE "C" DEFAULT "C"

   oReg := TReg32():New( nKey, cRegKey, .F. )
   IF ! oReg:lError
      DO CASE
      CASE cType == "A"
         uVal := {}
      CASE cType == "N"
         uVal := 0
      CASE cType == "D"
         uVal := CToD( "" )
      CASE cType == "L"
         uVal := .F.
      OTHERWISE
         uVal := ""
      ENDCASE

      uVal := oReg:Get( cRegVar, uVal )
      IF oReg:nError != ERROR_SUCCESS
         uVal := NIL
      ENDIF
   ENDIF
   oReg:Close()

   RETURN uVal

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION SetRegistryValue( nKey, cRegKey, cRegVar, uVal, nType )

   LOCAL oReg, lSuccess

   oReg := TReg32():New( nKey, cRegKey, .F. )
   IF oReg:lError
      lSuccess := .F.
   ELSE
      oReg:Set( cRegVar, uVal, nType )
      lSuccess := ( oReg:nError == ERROR_SUCCESS )
   ENDIF
   oReg:Close()

   RETURN lSuccess

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION DeleteRegistryVar( nKey, cRegKey, cRegVar )

   LOCAL oReg, lSuccess

   oReg := TReg32():New( nKey, cRegKey, .F. )
   IF oReg:lError
      lSuccess := .F.
   ELSE
      oReg:Delete( cRegVar )
      lSuccess := ( oReg:nError == ERROR_SUCCESS )
   ENDIF
   oReg:Close()

   RETURN lSuccess

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION DeleteRegistryKey( nKey, cRegKey, cSubKey )

   LOCAL oReg, lSuccess

   oReg := TReg32():New( nKey, cRegKey, .F. )
   IF oReg:lError
      lSuccess := .F.
   ELSE
      oReg:KeyDelete( cSubKey )
      lSuccess := ( oReg:nError == ERROR_SUCCESS )
   ENDIF
   oReg:Close()

   RETURN lSuccess

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION Bin2U( c )

   LOCAL l := Bin2L( c )

   RETURN iif( l < 0, l + 4294967296, l )
