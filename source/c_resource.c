/*
 * $Id: c_resource.c $
 */
/*
 * OOHG source code:
 * Resources related functions
 *
 * Copyright 2005-2022 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2022 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2022 Contributors, https://harbour.github.io/
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


#include "oohg.h"

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( LOADICON )
{
   HICONret( LoadIcon( HINSTANCEparam( 1 ), HB_ISCHAR( 2 ) ? hb_parc( 2 ): (LPCTSTR) MAKEINTRESOURCE( hb_parni( 2 ) ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( EXTRACTICON )
{
   HICONret( ExtractIcon( GetModuleHandle( NULL ), hb_parc( 1 ), hb_parni( 2 ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( LOADRESOURCE )
{
   HGLOBALret( LoadResource( HMODULEparam( 1 ), HRSRCparam( 2 ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( FINDRESOURCE )
{
   HRSRCret( FindResource( HMODULEparam( 1 ), hb_parc( 2 ), (LPCTSTR) MAKEINTRESOURCE( hb_parni( 3 ) ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RESOURCEFREE )
{
   FreeResource( HGLOBALparam( 1 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
BOOL SaveResourceToFile( const char * res, const char * filename, const char * type )
{
   HRSRC     hrsrc;
   HINSTANCE hInst;
   DWORD     size, writ;
   HGLOBAL   hglob;
   LPVOID    rdata;
   HANDLE    hFile;

   hInst = GetModuleHandle( NULL );
   hrsrc = FindResource( hInst, res, type );
   if( hrsrc == NULL )
      return FALSE;

  size = SizeofResource( hInst, hrsrc );
  hglob = LoadResource( hInst, hrsrc );
  rdata = LockResource( hglob );

  hFile = CreateFile( filename, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL );
  WriteFile( hFile, rdata, size, &writ, NULL );
  CloseHandle( hFile );

  return TRUE;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( SAVERESOURCETOFILE )
{
   hb_retl( SaveResourceToFile( hb_parc( 1 ), hb_parc( 2 ), hb_parc( 3 ) ) );
}
