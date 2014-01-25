/*
 * $Id: h_registry.prg,v 1.4 2014-01-25 01:23:22 guerra000 Exp $
 */
/*
 * ooHG source code:
 * Registry functions
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
/*
	Class TReg32 for (x)Harbour
*/

#include "hbclass.ch"
#include "i_misc.ch"

CLASS TReg32
   DATA cRegKey, nKey, nHandle, nError, lError
   METHOD New( nKey, cRegKey, lShowError )
   METHOD Create( nKey, cRegKey, lShowError )
   METHOD Get( cSubKey, uVar )
   METHOD Set( cSubKey, uVar, nType )
   METHOD Delete( cSubKey )
   METHOD KeyDelete( cSubKey )
   METHOD Close()    BLOCK {| Self | If( ::lError, , RegCloseKey( ::nHandle ) ) }
ENDCLASS


METHOD New( nKey, cRegKey, lShowError ) CLASS TReg32
Local nReturn, nHandle := 0
   If ! ValType( cRegKey ) $ "CM"
      cRegKey := ""
   EndIf
   nReturn := RegOpenKeyExA( nKey, cRegKey,, 63, @nHandle )
   ::cRegKey := cRegKey
   ::nHandle := nHandle
   If nReturn != 0
      ::lError := .t.
      If ValType( lShowError ) != "L" .OR. lShowError
         MsgStop( "Error creating TReg32 object (" + LTrim( Str( nReturn ) ) + ")" )
      EndIf
   Else
      ::lError := .F.
   Endif
Return Self


METHOD Create( nKey, cRegKey, lShowError ) CLASS TReg32
Local nReturn, nHandle := 0
   If ! ValType( cRegKey ) $ "CM"
      cRegKey := ""
   EndIf
   nReturn := RegCreateKey(nKey,cRegKey,@nHandle )
   if nReturn != 0
      ::lError := .t.
      IF lShowError=NIL .OR. lShowError
         MsgStop("Error creating TReg32 object ("+LTrim(Str(nReturn))+")" )
      ENDIF
   else
      ::lError := .f.
   endif
   ::nError := RegOpenKeyExA(nKey,cRegKey,,63,@nHandle )
   ::cRegKey = cRegKey
   ::nHandle = nHandle
return Self


METHOD Get( cSubkey, uVar ) CLASS TReg32
   local cValue := ""
   local nType := 0
   local nLen := 0
   local cType

   if !::lError
      cType := ValType(uVar )
      ::nError = RegQueryValueExA(::nHandle,cSubkey,0,@nType,@cValue,@nLen )
      uVar = cValue
      do case
         case cType == "D"
              uVar = CToD(uVar )
         case cType == "L"
              uVar = (Upper(uVar ) == ".T." )
         case cType == "N"
              uVar = Val(uVar )
         case cType == "T"
              uVar = CToT(uVar )
      endcase
   endif
return uVar


METHOD Set( cSubKey, uVar, nType ) CLASS TReg32
Local cType, nLen

   if ! ::lError
      cType := ValType( uVar )

      If ValType( nType ) != "N"
         nType := REG_SZ
         do case
            case cType == "D"
                 uVar = DToC( uVar )
            case cType == "L"
                 uVar := If( uVar, ".T.", ".F." )
            case cType == "N"
                 uVar := LTRIM( STR( uVar ) )
            case cType == "T"
                 uVar = TToC( uVar )
         endcase
      Else
         nLen := Len( uVar )
         If nLen == 0
            uVar := CHR( 0 )
            nLen := 1
         EndIf
      EndIf

      If nType == REG_SZ .OR. nType == REG_EXPAND_SZ
         nLen := AT( CHR( 0 ), uVar )
         If nLen == 0
            nLen := LEN( uVar ) + 1
            If nLen == 1
               uVar := CHR( 0 )
            EndIf
         EndIf
      EndIf

      ::nError := RegSetValueExA( ::nHandle, cSubkey, 0, nType, @uVar, nLen )
   EndIf

Return nil


METHOD Delete( cSubKey ) CLASS TReg32
   if !::lError
      ::nError = RegDeleteValueA(::nHandle,cSubkey )
   endif
return nil


METHOD KeyDelete( cSubKey ) CLASS TReg32
   if !::lError
      ::nError = RegDeleteKey(::nHandle,cSubkey )
   endif
return nil


#pragma BEGINDUMP

#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "winreg.h"
#include "tchar.h"

/*
 * Harbour Project source code:
 * Registry functions for Harbour
 *
 * Copyright 2001 Luiz Rafael Culik<culik@sl.conex.net>
 * www - http://www.harbour-project.org
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
 * As a special exception, the Harbour Project gives permission for
 * additional uses of the text contained in its release of Harbour.
 *
 * The exception is that, if you link the Harbour libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the Harbour library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the Harbour
 * Project under the name Harbour.  If you copy code from other
 * Harbour Project or Free Software Foundation releases into a copy of
 * Harbour, as the General Public License permits, the exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for Harbour, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */

HB_FUNC( REGCLOSEKEY )
{
   HKEY hwHandle = ( HKEY ) hb_parnl( 1 );

   if ( RegCloseKey( hwHandle ) == ERROR_SUCCESS )
      {
         hb_retnl( ERROR_SUCCESS );
      }
   else
      {
         hb_retnl( -1 );
      }

}

HB_FUNC( REGOPENKEYEXA )
{
   HKEY hwKey = ( ( HKEY ) hb_parnl( 1 ) );
   LPCTSTR lpValue=hb_parc( 2 );
   LONG lError;
   HKEY phwHandle;

   lError = RegOpenKeyExA( ( HKEY ) hwKey , lpValue , 0 , KEY_ALL_ACCESS , &phwHandle );

   if ( lError > 0 )
      {
         hb_retnl( -1 );
      }
   else
      {
         hb_stornl( PtrToLong( phwHandle ) , 5 );
         hb_retnl( 0 );
      }
}

HB_FUNC( REGQUERYVALUEEXA )
{
   LONG lError;
   DWORD lpType=hb_parnl( 4 );
   DWORD lpcbData=0;

   lError=RegQueryValueExA( ( HKEY ) hb_parnl( 1 ) , ( LPTSTR ) hb_parc( 2 ) , NULL , &lpType , NULL , &lpcbData );

   if ( lError == ERROR_SUCCESS )
   {
      BYTE *lpData;
      lpData= (BYTE*) malloc( ( int ) lpcbData+1 );
      lError= RegQueryValueExA( ( HKEY ) hb_parnl( 1 ) , ( LPTSTR ) hb_parc( 2 ) , NULL , &lpType , ( BYTE* ) lpData , &lpcbData );

      if ( lError > 0 )
      {
         hb_retnl( -1 );
      }
      else
      {
//       hb_storc( ( LPBYTE ) lpData , 5 );
         hb_storc( ( char * ) lpData , 5 );
         hb_retnl( 0 );
      }
      free( ( BYTE* ) lpData );
   }
   else
      hb_retnl( -1 );
}


HB_FUNC( REGENUMKEYEXA )
{
   FILETIME ft;
   long bErr;
   TCHAR Buffer[255];
   DWORD dwBuffSize = 255;
   TCHAR Class[255];
   DWORD dwClass = 255;

    bErr = RegEnumKeyEx( ( HKEY ) hb_parnl( 1 ) , hb_parnl( 2 ) , Buffer , &dwBuffSize , NULL , Class , &dwClass , &ft );

    if ( bErr != ERROR_SUCCESS )
      {
         hb_retnl(-1);
      }
    else
      {
         hb_storc( Buffer , 3 );
         hb_stornl( ( long ) dwBuffSize , 4 );
         hb_storc( Class , 6 );
         hb_stornl( ( long ) dwClass , 7 );
         hb_retnl( 1 );
      }
}

HB_FUNC( REGSETVALUEEXA )
{
   if( RegSetValueExA( ( HKEY ) hb_parnl( 1 ) , hb_parc( 2 ) , ( DWORD ) NULL , hb_parnl( 4 ), ( BYTE * ) hb_parc( 5 ), hb_parnl( 6 ) ) == ERROR_SUCCESS )
   {
      hb_retnl( 0 );
   }
   else
   {
      hb_retnl( -1 );
   }
}

HB_FUNC( REGCREATEKEY )
{
   HKEY hKey;

   if ( RegCreateKey( ( HKEY ) hb_parnl( 1 ) , hb_parc( 2 ) , &hKey ) == ERROR_SUCCESS )
   {
      hb_stornl( PtrToLong( hKey ) , 3 );
      hb_retnl( 0 );
   }
   else
   {
      hb_retnl( -1 );
   }
}


HB_FUNC( REGENUMVALUEA )
{

   DWORD lpType=1;
   TCHAR Buffer[255];
   DWORD dwBuffSize = 255;
   DWORD dwClass = 255;
   long  lError;

   lError = RegEnumValueA( (HKEY) hb_parnl(1),hb_parnl(2), Buffer, &dwBuffSize, NULL, &lpType, NULL, &dwClass);

   if ( lError != ERROR_SUCCESS )
      {
         hb_retnl(-1);
      }
    else
      {
         hb_storc( Buffer , 3 );
         hb_stornl( ( long ) dwBuffSize , 4 );
         hb_stornl( ( long ) dwClass , 8 );

         hb_retnl( 0 );
      }
}

HB_FUNC( REGDELETEKEY )
{
   hb_retnl( RegDeleteKey( ( HKEY ) hb_parnl( 1 ), hb_parc( 2 ) ) );
}

HB_FUNC( REGDELETEVALUEA )
{
   if ( RegDeleteValueA( ( HKEY ) hb_parnl( 1 ) , hb_parc( 2 ) ) == ERROR_SUCCESS )
   {
      hb_retnl( ERROR_SUCCESS );
   }
   else
   {
      hb_retnl( -1 );
   }
}


#pragma ENDDUMP
