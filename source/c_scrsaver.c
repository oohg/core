/*
 * $Id: c_scrsaver.c $
 */
/*
 * ooHG source code:
 * C screen saver functions
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

typedef BOOL (WINAPI *VERIFYSCREENSAVEPWD)(HWND hwnd);
typedef VOID (WINAPI *PWDCHANGEPASSWORD) (LPCSTR lpcRegkeyname,HWND hwnd,UINT uiReserved1,UINT uiReserved2);

HB_FUNC( VERIFYPASSWORD )
{
   // Under NT, we return TRUE immediately. This lets the saver quit,
   // and the system manages passwords. Under '95, we call VerifyScreenSavePwd.
   // This checks the appropriate registry key and, if necessary,
   // pops up a verify dialog

   HWND hwnd;
   HINSTANCE hpwdcpl;
   VERIFYSCREENSAVEPWD VerifyScreenSavePwd;
   BOOL bres;

   if(GetVersion() < 0x80000000)
      hb_retl( TRUE );

   hpwdcpl = LoadLibrary("PASSWORD.CPL");

   if(hpwdcpl == NULL)
   {
      hb_retl( FALSE );
   }

   VerifyScreenSavePwd = (VERIFYSCREENSAVEPWD)GetProcAddress(hpwdcpl, "VerifyScreenSavePwd");
   if(VerifyScreenSavePwd==NULL)
   {
      FreeLibrary(hpwdcpl);
      hb_retl( FALSE );
   }

        hwnd = HWNDparam( 1 );

        bres = VerifyScreenSavePwd(hwnd);
   FreeLibrary(hpwdcpl);

   hb_retl( bres );
}

HB_FUNC( CHANGEPASSWORD )
{
   // This only ever gets called under '95, when started with the /a option.
   HWND hwnd;

   HINSTANCE hmpr = LoadLibrary("MPR.DLL");
   PWDCHANGEPASSWORD PwdChangePassword;

   if(hmpr == NULL)
      hb_retl( FALSE );

   PwdChangePassword = (PWDCHANGEPASSWORD)GetProcAddress(hmpr, "PwdChangePasswordA");

   if(PwdChangePassword == NULL)
   {
      FreeLibrary(hmpr);
      hb_retl( FALSE );
   }

        hwnd = HWNDparam( 1 );
   PwdChangePassword("SCRSAVE", hwnd, 0, 0);
   FreeLibrary(hmpr);

   hb_retl( TRUE );
}
