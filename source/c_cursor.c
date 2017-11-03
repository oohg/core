/*
 * $Id: c_cursor.c,v 1.11 2017-08-25 19:42:17 fyurisich Exp $
 */
/*
 * ooHG source code:
 * C cursor functions
 *
 * Based upon
 * HMG Extended original work placed in public domain by
 * Jacek Kubica <kubica@wssk.wroc.pl>
 * Grigory Filatov <gfilatov@inbox.ru>
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


#define _WIN32_IE      0x0500
#define HB_OS_WIN_32_USED
#define _WIN32_WINNT   0x0400

#include <shlobj.h>
#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "winreg.h"
#include "tchar.h"
#include "../include/oohg.h"

HB_FUNC( LOADCURSOR )
{
   HINSTANCE hInstance    = ( HB_ISNIL(1) ? NULL : (HINSTANCE) hb_parnl(1) );
   LPCTSTR   lpCursorName = ( hb_parinfo(2) == HB_IT_STRING ? hb_parc(2): MAKEINTRESOURCE( hb_parnl(2) ) );

   hb_retnl( (LONG) LoadCursor( hInstance, lpCursorName ) );
}

HB_FUNC( LOADCURSORFROMFILE )
{
   // file with cursor picture or anims (.cur .ani)
   LPCTSTR   lpFileName = (LPCTSTR) hb_parc(1);

   hb_retnl( (LONG) LoadCursorFromFile( lpFileName ) );
}

HB_FUNC( SETRESCURSOR )
{
   hb_retnl( (LONG) SetCursor( (HCURSOR) hb_parnl(1) ) );
}

HB_FUNC( FILECURSOR )
{
   hb_retnl( (LONG) SetCursor( LoadCursorFromFile( hb_parc(1) ) ) );
}

HB_FUNC( CURSORHAND )
{
#if ( WINVER >= 0x0500 )
   hb_retnl( (LONG) SetCursor( LoadCursor( NULL, IDC_HAND ) ) );
#else
   hb_retnl( (LONG) SetCursor( LoadCursor( GetModuleHandle( NULL ), "MINIGUI_FINGER" ) ) );
#endif
}

HB_FUNC( CURSORARROW )
{
   hb_retnl( (LONG) SetCursor( LoadCursor( NULL, IDC_ARROW ) ) );
}

HB_FUNC( CURSORHELP )
{
   hb_retnl( (LONG) SetCursor( LoadCursor( NULL, IDC_HELP ) ) );
}

HB_FUNC( CURSORWAIT )
{
   hb_retnl( (LONG) SetCursor( LoadCursor( NULL, IDC_WAIT ) ) );
}

HB_FUNC( CURSORCROSS )
{
   hb_retnl( (LONG) SetCursor( LoadCursor( NULL, IDC_CROSS ) ) );
}

HB_FUNC( CURSORIBEAM )
{
   hb_retnl( (LONG) SetCursor( LoadCursor( NULL, IDC_IBEAM ) ) );
}

HB_FUNC( CURSORAPPSTARTING )
{
   hb_retnl( (LONG) SetCursor( LoadCursor( NULL, IDC_APPSTARTING ) ) );
}

HB_FUNC( CURSORNO )
{
   hb_retnl( (LONG) SetCursor( LoadCursor( NULL, IDC_NO ) ) );
}

HB_FUNC( CURSORSIZEALL )
{
   hb_retnl( (LONG) SetCursor( LoadCursor( NULL, IDC_SIZEALL ) ) );
}

HB_FUNC( CURSORSIZENESW )
{
   hb_retnl( (LONG) SetCursor( LoadCursor( NULL, IDC_SIZENESW ) ) );
}

HB_FUNC( CURSORSIZENWSE )
{
   hb_retnl( (LONG) SetCursor( LoadCursor( NULL, IDC_SIZENWSE ) ) );
}

HB_FUNC( CURSORSIZENS )
{
   hb_retnl( (LONG) SetCursor( LoadCursor( NULL, IDC_SIZENS ) ) );
}

HB_FUNC( CURSORSIZEWE )
{
   hb_retnl( (LONG) SetCursor( LoadCursor( NULL, IDC_SIZEWE ) ) );
}

HB_FUNC( CURSORUPARROW )
{
   hb_retnl( (LONG) SetCursor( LoadCursor( NULL, IDC_UPARROW ) ) );
}

HB_FUNC( SETWINDOWCURSOR )
{
   HCURSOR ch;
   ULONG_PTR ret;

   if( HB_ISCHAR(2) )
   {
      ch = LoadCursor( GetModuleHandle( NULL ), hb_parc(2) );

      if ( ch == NULL )
      {
         ch = LoadCursorFromFile( (LPCTSTR) hb_parc(2) );
      }
   }
   else
   {
      ch = LoadCursor( NULL, MAKEINTRESOURCE( hb_parnl(2) ) );
   }

   ret = SetClassLongPtr( HWNDparam(1), GCL_HCURSOR, (LONG_PTR) ch );

   hb_retl( ret != 0 || GetLastError() == 0 );
}

HB_FUNC( SETHANDCURSOR )
{
#if ( WINVER >= 0x0500 )
   SetClassLong( HWNDparam(1), GCL_HCURSOR, (LONG) LoadCursor( NULL, IDC_HAND ) );
#else
   SetClassLong( HWNDparam(1), GCL_HCURSOR, (LONG) LoadCursor( GetModuleHandle( NULL ), "MINIGUI_FINGER") );
#endif
}

HB_FUNC( SETWAITCURSOR )
{
   SetClassLong( HWNDparam(1), GCL_HCURSOR, ( LONG ) LoadCursor(NULL, IDC_WAIT) );
}

HB_FUNC( SETARROWCURSOR )
{
   SetClassLong( HWNDparam(1), GCL_HCURSOR, (LONG) LoadCursor( NULL, IDC_ARROW ) );
}
