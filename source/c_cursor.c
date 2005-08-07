/*
 * $Id: c_cursor.c,v 1.1 2005-08-07 00:02:34 guerra000 Exp $
 */
/*
 * ooHG source code:
 * C cursor functions
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
File:		c_cursor.c
Contributors:	Jacek Kubica <kubica@wssk.wroc.pl>
                Grigory Filatov <gfilatov@freemail.ru>
Description:	Mouse Cursor Shapes handling for MiniGUI
Status:		Public Domain
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

/*
HB_FUNC ( LOADCURSOR )
{
HINSTANCE hInstance    = (ISNIL(1) ? NULL : (HINSTANCE) hb_parnl(1));
LPCTSTR   lpCursorName = (hb_parinfo(2)== HB_IT_STRING ? hb_parc(2): MAKEINTRESOURCE( hb_parnl( 2 ) ) );
hb_retnl( (long) LoadCursor( hInstance, lpCursorName ) );
}
*/

HB_FUNC( LOADCURSORFROMFILE )
{
  LPCTSTR   lpFileName = (LPCTSTR)   hb_parc(1);   // file with cursor picture or anims (.cur .ani)
  hb_retnl( (long) LoadCursorFromFile( lpFileName ) );
}

HB_FUNC( SETRESCURSOR )
{
   hb_retnl( (LONG) SetCursor( (HCURSOR) hb_parnl( 1 ) ) ) ;
}


HB_FUNC( FILECURSOR )
{
   hb_retnl( (long) SetCursor( LoadCursorFromFile( hb_parc (1) ) ) );
}

/* Removed to avoid compilation problems under Win98 reported by Ryszard Rylko
HB_FUNC( CURSORHAND )
{
   hb_retnl( (long) SetCursor( LoadCursor( 0, IDC_HAND ) ) );
}
*/

HB_FUNC( CURSORARROW )
{
   hb_retnl( (long) SetCursor( LoadCursor( 0, IDC_ARROW ) ) );
}

HB_FUNC( CURSORHELP )
{
   hb_retnl( (long) SetCursor( LoadCursor( 0, IDC_HELP ) ) );
}
/*
HB_FUNC( CURSORWAIT )
{
   hb_retnl( (long) SetCursor( LoadCursor( 0, IDC_WAIT ) ) );
}
*/
HB_FUNC( CURSORCROSS )
{
   hb_retnl( (long) SetCursor( LoadCursor( 0, IDC_CROSS ) ) );
}
HB_FUNC( CURSORIBEAM )
{
   hb_retnl( (long) SetCursor( LoadCursor( 0, IDC_IBEAM ) ) );
}
HB_FUNC( CURSORAPPSTARTING )
{
   hb_retnl( (long) SetCursor( LoadCursor( 0, IDC_APPSTARTING ) ) );
}

HB_FUNC( CURSORNO )
{
   hb_retnl( (long) SetCursor( LoadCursor( 0, IDC_NO ) ) );
}

HB_FUNC( CURSORSIZEALL )
{
   hb_retnl( (long) SetCursor( LoadCursor( 0, IDC_SIZEALL ) ) );
}

HB_FUNC( CURSORSIZENESW )
{
   hb_retnl( (long) SetCursor( LoadCursor( 0, IDC_SIZENESW ) ) );
}

HB_FUNC( CURSORSIZENWSE )
{
   hb_retnl( (long) SetCursor( LoadCursor( 0, IDC_SIZENWSE ) ) );
}

HB_FUNC( CURSORSIZENS )
{
   hb_retnl( (long) SetCursor( LoadCursor( 0, IDC_SIZENS ) ) );
}
HB_FUNC( CURSORSIZEWE )
{
   hb_retnl( (long) SetCursor( LoadCursor( 0, IDC_SIZEWE ) ) );
}
HB_FUNC( CURSORUPARROW )
{
   hb_retnl( (long) SetCursor( LoadCursor( 0, IDC_UPARROW ) ) );
}

HB_FUNC ( SETWINDOWCURSOR )
{

	HCURSOR ch;

	if( ISCHAR(2) )
	{
		ch = LoadCursor( GetModuleHandle( NULL ), hb_parc( 2 ) ) ;

		if ( ch == NULL )
		{
			ch = LoadCursorFromFile ( (LPCTSTR) hb_parc( 2 ) ) ;
		}
	}
	else
	{
		ch = LoadCursor( NULL, MAKEINTRESOURCE( hb_parnl( 2 ) ) ) ;
	}


	SetClassLong( (HWND) hb_parnl(1) ,    // window handle
		GCL_HCURSOR,      // change cursor
		(LONG) ch );   // new cursor

}