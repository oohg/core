/*
 * $Id: h_winapimisc.prg $
 */
/*
 * ooHG source code:
 * Windows API functions
 *
 * Copyright 2005-2021 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
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

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION GetWindowsFolder()

   RETURN GetWindowsDir()

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION GetSystemFolder()

   RETURN GetSystemDir()

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION GetTempFolder()

   RETURN GetTempDir()

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION GetMyDocumentsFolder()

   RETURN GetSpecialFolder( CSIDL_PERSONAL )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION GetDesktopFolder()

   RETURN GetSpecialFolder( CSIDL_DESKTOPDIRECTORY )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION GetProgramFilesFolder()

   RETURN GetSpecialFolder( CSIDL_PROGRAM_FILES )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION GetSpecialFolder( nCSIDL ) // Contributed By Ryszard Rylko

   RETURN C_GETSPECIALFOLDER( nCSIDL )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _GetCompactPath( cFile, nMax ) // Contributed By Jacek Kubica

   LOCAL cShort

   IF ! HB_ISNUMERIC( nMax )
      nMax := 64
   ENDIF
   cShort := Space( nMax )

   RETURN iif( GETCOMPACTPATH( @cShort, cFile, nMax + 1, NIL ), cShort, cFile )

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE ProcessMessages

   DO WHILE _ProcessMess()
   ENDDO

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION WindowsVersion()

   LOCAL cKey, aRetVal := Array( 4 )

   IF hb_osisWin10()
      cKey := "SOFTWARE\Microsoft\Windows NT\CurrentVersion"
      aRetVal[ 1 ] := GetRegistryValue( HKEY_LOCAL_MACHINE, cKey, "ProductName" )
      aRetVal[ 2 ] := GetRegistryValue( HKEY_LOCAL_MACHINE, cKey, "ReleaseId" )
      aRetVal[ 3 ] := GetRegistryValue( HKEY_LOCAL_MACHINE, cKey, "CurrentBuild" ) + "." + ;
                      hb_ntos( GetRegistryValue( HKEY_LOCAL_MACHINE, cKey, "UBR", "N" ) )
      aRetVal[ 4 ] := ""
   ELSE
      aRetVal := WinVersion()
   ENDIF

RETURN { aRetVal[ 1 ] + aRetVal[ 4 ], aRetVal[ 2 ], 'Build ' + aRetVal[ 3 ] }

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _Execute( nActiveWindowhandle, cOperation, cFile, cParaMeters, cDefault, nState )

   IF ValType( nActiveWindowhandle ) == 'U'
      nActiveWindowhandle := 0
   ENDIF

   IF ValType( cOperation ) == 'U'
      cOperation := NIL
   ENDIF

   IF ValType( cFile ) == 'U'
      cFile := ""
   ENDIF

   IF ValType( cParaMeters ) == 'U'
      cParaMeters := NIL
   ENDIF

   IF ValType( cDefault ) == 'U'
       cDefault := NIL
   ENDIF

   IF ValType( nState ) == 'U'
       nState := 10 // SW_SHOWDEFAULT
   ENDIF

   RETURN ShellExecute( nActiveWindowhandle, cOperation, cFile, cParaMeters, cDefault, nState )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION BmpSize( uImage )

   LOCAL aRet

   DO CASE
   CASE HB_ISSTRING( uImage )
      aRet := _OOHG_SizeOfBitmapFromFile( uImage )
   CASE HB_ISNUMERIC( uImage ) .AND. ValidHandler( uImage )
      aRet := _OOHG_SizeOfHBitmap( uImage )
   OTHERWISE
      // This is for compatibility with HMG
      aRet := { 0, 0, 4 }
   ENDCASE

   RETURN aRet

