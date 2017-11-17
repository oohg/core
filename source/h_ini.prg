/*
 * $Id: h_ini.prg $
 */
/*
 * ooHG source code:
 * INI files functions
 *
 * Copyright 2005-2017 Vicente Guerra <vicente@guerra.com.mx>
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


#include 'oohg.ch'
#include 'common.ch'
#include 'fileio.ch'

STATIC _OOHG_ActiveIniFile := ''

FUNCTION BeginIni(name, cIniFile )

   LOCAL hFile

   HB_SYMBOL_UNUSED( name )

   if AT("\",cIniFile)==0
      cIniFile := ".\"+cIniFile
   endif

   If ! File( cIniFile )
      hFile := FCreate( cIniFile )
   Else
      hFile := FOpen( cIniFile, FO_READ + FO_SHARED )
   EndIf

   If FError() != 0
      MsgInfo( "Error opening a file INI. DOS ERROR: " + Str( FError(), 2, 0 ) )
      Return ""
   else
      _OOHG_ActiveIniFile := cIniFile
   EndIf

   FClose( hFile )

   Return Nil


// Code GetIni and SetIni based on source of Grigory Filatov

Function _GetIni( cSection, cEntry, cDefault, uVar )

   Local cFile, cVar :=''

   If !empty(_OOHG_ActiveIniFile)
      if valtype(cDefault) == 'U'
         cDefault:=cVar
      endif
      cFile:= _OOHG_ActiveIniFile
      cVar := GetPrivateProfileString(cSection, cEntry, xChar( cDefault ), cFile )
   else
      if cDefault != NIL
         cVar := xChar( cDefault )
      endif
   endif
   uVar := xValue(cVar,ValType( uVar))

   Return uVar

Function _SetIni( cSection, cEntry, cValue )

   Local ret:=.f., cFile

   If ! empty(_OOHG_ActiveIniFile)
      cFile := _OOHG_ActiveIniFile
      ret := WritePrivateProfileString( cSection, cEntry, xChar(cValue), cFile )
   endif

   Return ret

Function  _DelIniEntry( cSection, cEntry )

   Local ret:=.f., cFile

   If !empty(_OOHG_ActiveIniFile)
      cFile := _OOHG_ActiveIniFile
      ret := DelIniEntry( cSection, cEntry, cFile )
   endif

   Return ret

Function  _DelIniSection( cSection )

   Local ret:=.f., cFile

   If !empty(_OOHG_ActiveIniFile)
      cFile := _OOHG_ActiveIniFile
      ret := DelIniSection( cSection, cFile )
   endif

   Return ret

Function _EndIni()

   _OOHG_ActiveIniFile := ''

   Return Nil

FUNCTION xChar( xValue )

   LOCAL cType := ValType( xValue )
   LOCAL cValue := "", nDecimals := Set( _SET_DECIMALS)

   DO CASE
   CASE cType $  "CM";  cValue := xValue
   CASE cType == "N" ;  cValue := LTrim( Str( xValue, 20, nDecimals ) )
   CASE cType == "D" ;  cValue := DToS( xValue )
   CASE cType == "L" ;  cValue := IIf( xValue, "T", "F" )
   CASE cType == "T" ;  cValue := TToS( xValue )
   CASE cType == "A" ;  cValue := AToC( xValue )
   CASE cType $  "UE";  cValue := "NIL"
   CASE cType == "B" ;  cValue := "{|| ... }"
   CASE cType == "O";   cValue := "{" + xValue:className + "}"
   ENDCASE

   RETURN cValue

FUNCTION xValue( cValue, cType )

   LOCAL xValue

   DO CASE
   CASE cType $  "CM";  xValue := cValue
   CASE cType == "D" ;  xValue := SToD( cValue )
   CASE cType == "N" ;  xValue := Val( cValue )
   CASE cType == "L" ;  xValue := ( cValue == 'T' )
   CASE cType == "T" ;  xValue := SToT( cValue )
   CASE cType == "A" ;  xValue := CToA( cValue )
   OTHERWISE;           xValue := NIL                     // nil, block, object
   ENDCASE

   RETURN xValue

FUNCTION AToC( aArray )

   LOCAL i, nLen := Len( aArray )
   LOCAL cType, cElement, cArray := ""

   FOR i := 1 TO nLen
      cElement := xChar( aArray[ i ] )
      IF ( cType := ValType( aArray[ i ] ) ) == "A"
         cArray += cElement
      ELSE
         cArray += Left( cType, 1) + str( Len( cElement ),4 ) + cElement
      ENDIF
   ENDFOR

   RETURN "A" + str( Len( cArray ),4 ) + cArray

FUNCTION CToA( cArray )

   LOCAL cType, nLen, aArray := {}

   cArray := SubStr( cArray, 6 )    // strip off array and length
   WHILE Len( cArray ) > 0
      nLen := Val( SubStr( cArray, 2, 4 ) )
      IF ( cType := Left( cArray, 1 ) ) == "A"
         AAdd( aArray, CToA( SubStr( cArray, 1, nLen + 5 ) ) )
      ELSE
         AAdd( aArray, xValue( SubStr( cArray, 6, nLen ), cType ) )
      ENDIF
      cArray := SubStr( cArray, 6 + nLen )
   END

   RETURN aArray


EXTERN GETPRIVATEPROFILESTRING, WRITEPRIVATEPROFILESTRING, DELINIENTRY, DELINISECTION

#pragma BEGINDUMP

#ifndef HB_OS_WIN_32_USED
   #define HB_OS_WIN_32_USED
#endif

#ifndef _WIN32_WINNT
   #define _WIN32_WINNT 0x0400
#endif
#if ( _WIN32_WINNT < 0x0400 )
   #undef _WIN32_WINNT
   #define _WIN32_WINNT 0x0400
#endif

#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"
#include "hbapiitm.h"
#include "oohg.h"

HB_FUNC (GETPRIVATEPROFILESTRING )
{
   TCHAR bBuffer[ 1024 ] = { 0 };
   DWORD dwLen ;
   char * lpSection = ( char * ) hb_parc( 1 );
   char * lpEntry = HB_ISCHAR(2) ? ( char * ) hb_parc( 2 ) : NULL ;
   char * lpDefault = ( char * ) hb_parc( 3 );
   char * lpFileName = ( char * ) hb_parc( 4 );
   dwLen = GetPrivateProfileString( lpSection , lpEntry ,lpDefault , bBuffer, sizeof( bBuffer ) , lpFileName);
   if( dwLen )
      hb_retclen( ( char * ) bBuffer, dwLen );
   else
      hb_retc( lpDefault );
}

HB_FUNC( WRITEPRIVATEPROFILESTRING )
{
   char * lpSection = ( char * ) hb_parc( 1 );
   char * lpEntry = HB_ISCHAR( 2 ) ? ( char * ) hb_parc( 2 ) : NULL ;
   char * lpData = HB_ISCHAR( 3 ) ? ( char * ) hb_parc( 3 ) : NULL ;
   char * lpFileName= ( char * ) hb_parc( 4 );

   if ( WritePrivateProfileString( lpSection , lpEntry , lpData , lpFileName ) )
      hb_retl( TRUE ) ;
   else
      hb_retl(FALSE);
}

HB_FUNC( DELINIENTRY )
{
   hb_retl( WritePrivateProfileString( hb_parc( 1 ),         // Section
                                       hb_parc( 2 ),         // Entry
                                       NULL,                 // String
                                       hb_parc( 3 ) ) );     // INI File
}

HB_FUNC( DELINISECTION )
{
   hb_retl( WritePrivateProfileString( hb_parc( 1 ),       // Section
                                       NULL,               // Entry
                                       "",                 // String
                                       hb_parc( 2 ) ) );   // INI File
}

#pragma ENDDUMP
