/*
 * $Id: c_msgbox.c $
 */
/*
 * OOHG source code:
 * MessageBox related functions
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
#include <shlobj.h>
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "winreg.h"
#include "tchar.h"

HB_FUNC( C_MSGRETRYCANCEL )
{
   int uType;

   if( HB_ISNIL( 3 ) )
   {
      uType = MB_SYSTEMMODAL;
   }
   else
   {
      uType = hb_parni( 3 );
   }

   hb_retni( MessageBox( GetActiveWindow(), hb_parc( 1 ), hb_parc( 2 ), MB_RETRYCANCEL | MB_ICONQUESTION | uType ) ) ;
}

HB_FUNC( C_MSGOKCANCEL )
{
   int uType;

   if( HB_ISNIL( 3 ) )
   {
      uType = MB_SYSTEMMODAL;
   }
   else
   {
      uType = hb_parni( 3 );
   }

   hb_retni ( MessageBox( GetActiveWindow(), hb_parc( 1 ), hb_parc( 2 ) , MB_OKCANCEL | MB_ICONQUESTION | uType ) ) ;
}

HB_FUNC( C_MSGYESNO )
{
   int uType;

   if( HB_ISNIL( 3 ) )
   {
      uType = MB_SYSTEMMODAL;
   }
   else
   {
      uType = hb_parni( 3 );
   }

   hb_retni( MessageBox( GetActiveWindow(), hb_parc( 1 ), hb_parc( 2 ), MB_YESNO | MB_ICONQUESTION | uType ) );
}

HB_FUNC( C_MSGYESNOCANCEL )
{
   int uType;

   if( HB_ISNIL( 3 ) )
   {
      uType = MB_SYSTEMMODAL;
   }
   else
   {
      uType = hb_parni( 3 );
   }

   hb_retni( MessageBox( GetActiveWindow(), hb_parc( 1 ), hb_parc( 2 ), MB_YESNOCANCEL | MB_ICONQUESTION | uType ) );
}

HB_FUNC( C_MSGYESNO_ID )
{
   int uType;

   if( HB_ISNIL( 3 ) )
   {
      uType = MB_SYSTEMMODAL;
   }
   else
   {
      uType = hb_parni( 3 );
   }

   hb_retni( MessageBox( GetActiveWindow(), hb_parc( 1 ), hb_parc( 2 ), MB_YESNO | MB_ICONQUESTION | uType | MB_DEFBUTTON2 ) );
}

HB_FUNC( C_MSGBOX )
{
   int uType;

   if( HB_ISNIL( 3 ) )
   {
      uType = MB_SYSTEMMODAL;
   }
   else
   {
      uType = hb_parni( 3 );
   }

   MessageBox( GetActiveWindow(), hb_parc( 1 ), hb_parc( 2 ), uType );
}

HB_FUNC( C_MSGINFO )
{
   int uType;

   if( HB_ISNIL( 3 ) )
   {
      uType = MB_SYSTEMMODAL;
   }
   else
   {
      uType = hb_parni( 3 );
   }

   MessageBox( GetActiveWindow(), hb_parc( 1 ), hb_parc( 2 ), MB_OK | MB_ICONINFORMATION | uType );
}

HB_FUNC( C_MSGSTOP )
{
   int uType;

   if( HB_ISNIL( 3 ) )
   {
      uType = MB_SYSTEMMODAL;
   }
   else
   {
      uType = hb_parni( 3 );
   }

   MessageBox( GetActiveWindow(), hb_parc( 1 ), hb_parc( 2 ), MB_OK | MB_ICONSTOP | uType );
}

HB_FUNC( C_MSGEXCLAMATION )
{
   int uType;

   if( HB_ISNIL( 3 ) )
   {
      uType = MB_SYSTEMMODAL;
   }
   else
   {
      uType = hb_parni( 3 );
   }

   MessageBox( GetActiveWindow(), hb_parc( 1 ), hb_parc( 2 ), MB_ICONEXCLAMATION | MB_OK | uType );
}

HB_FUNC( C_MSGEXCLAMATIONYESNO )
{
   int uType;

   if( HB_ISNIL( 3 ) )
   {
      uType = MB_SYSTEMMODAL;
   }
   else
   {
      uType = hb_parni( 3 );
   }

   hb_retni( MessageBox( GetActiveWindow(), hb_parc( 1 ), hb_parc( 2 ), MB_YESNO | MB_ICONEXCLAMATION | uType ) );
}

/*
 * MessageBoxIndirect( [hWnd], cText, [cCaption], [nStyle], [xIcon], [hInst], [nHelpId], [nProc], [nLang] )
 * Contributed by Andy Wos <andywos@unwired.com.au>
 */
HB_FUNC( MESSAGEBOXINDIRECT )
{
   MSGBOXPARAMS mbp;

   mbp.cbSize             = sizeof( MSGBOXPARAMS );
   mbp.hwndOwner          = HB_ISNIL( 1 ) ? GetActiveWindow() : HWNDparam( 1 );
   mbp.hInstance          = HB_ISNIL( 6 ) ? GetModuleHandle( NULL ) : HINSTANCEparam( 6 );
   mbp.lpszText           = HB_ISCHAR( 2 ) ? hb_parc( 2 ) : ( HB_ISNIL( 2 ) ? NULL : MAKEINTRESOURCE( hb_parni( 2 ) ) );
   mbp.lpszCaption        = HB_ISCHAR( 3 ) ? hb_parc( 3 ) : ( HB_ISNIL( 3 ) ? "" : MAKEINTRESOURCE( hb_parni( 3 ) ) );
   mbp.dwStyle            = (DWORD) hb_parni( 4 );
   mbp.lpszIcon           = HB_ISCHAR( 5 ) ? hb_parc( 5 ) : ( HB_ISNIL( 5 ) ? NULL : MAKEINTRESOURCE( hb_parni( 5 ) ) );
   mbp.dwContextHelpId    = HB_ISNIL( 7 ) ? 0 : (DWORD) hb_parni( 7 );
   mbp.lpfnMsgBoxCallback = HB_ISNIL( 8 ) ? NULL : MSGBOXCALLBACKparam( 8 );
   mbp.dwLanguageId       = HB_ISNIL( 9 ) ? MAKELANGID( LANG_NEUTRAL, SUBLANG_NEUTRAL ) : (DWORD) hb_parni( 9 );

   hb_retni( (int) MessageBoxIndirect( &mbp ) );
}

int WINAPI MessageBoxTimeout( HWND hWnd, LPCSTR lpText, LPCSTR lpCaption, UINT uType, WORD wLanguageId, DWORD dwMilliseconds );

/* MessageBoxTimeout( Text, Caption, nTypeButton, nMilliseconds ) ---> Return iRetButton */
HB_FUNC( MESSAGEBOXTIMEOUT )
{
   HWND hWnd = GetActiveWindow();
   const char *lpText = hb_parc( 1 );
   const char *lpCaption = hb_parc( 2 );
   UINT uType = HB_ISNIL( 3 ) ? MB_OK : (UINT) hb_parnl( 3 );
   WORD wLanguageId = MAKELANGID( LANG_NEUTRAL, SUBLANG_NEUTRAL );
   DWORD dwMilliseconds = HB_ISNIL( 4 ) ? (DWORD) 0xFFFFFFFF : (DWORD) hb_parnl( 4 );

   hb_retni( MessageBoxTimeout( hWnd, lpText, lpCaption, uType, wLanguageId, dwMilliseconds ) );
}
