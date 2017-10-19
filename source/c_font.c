/*
 * $Id: c_font.c,v 1.9 2017-08-25 19:42:17 fyurisich Exp $
 */
/*
 * ooHG source code:
 * C font functions
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
 * along with this software; see the file COPYING.  If not, write to
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
#include "oohg.h"

HFONT PrepareFont( char *Fontname, int FontSize, int Weight, int Italic, int Underline, int StrikeOut, int Angle, int Width )
{
   HDC  hDC;
   int cyp;

   memset ( &cyp, 0, sizeof ( cyp ) ) ;
   memset ( &hDC, 0, sizeof ( hDC ) ) ;

   hDC = GetDC ( HWND_DESKTOP ) ;

   cyp = GetDeviceCaps ( hDC, LOGPIXELSY ) ;

   ReleaseDC ( HWND_DESKTOP, hDC ) ;

   FontSize = ( FontSize * cyp ) / 72 ;

   return CreateFont ( 0-FontSize, 0, Angle, Width, Weight, Italic, Underline, StrikeOut,
      DEFAULT_CHARSET, OUT_TT_PRECIS, CLIP_DEFAULT_PRECIS,
      DEFAULT_QUALITY, FF_DONTCARE, Fontname ) ;
}

HB_FUNC ( _SETFONT )
{
   HFONT font ;
   int bold = FW_NORMAL;
   int italic = 0;
   int underline = 0;
   int strikeout = 0;

   if ( hb_parl (4) )
   {
      bold = FW_BOLD;
   }

   if ( hb_parl (5) )
   {
      italic = 1;
   }

   if ( hb_parl (6) )
   {
      underline = 1;
   }

   if ( hb_parl (7) )
   {
      strikeout = 1;
   }

        font = PrepareFont ( ( char * ) hb_parc(2) ,
                        (LPARAM) hb_parni(3) ,
                        bold , italic, underline, strikeout, hb_parnl(8), hb_parnl(9) ) ;
    SendMessage( HWNDparam( 1 ) , (UINT)WM_SETFONT,(WPARAM) font , 1 ) ;
   hb_retnl ( (LONG) font );
}

HB_FUNC ( SETFONTNAMESIZE )
{
   int bold = FW_NORMAL;
   int italic = 0;
   int underline = 0;
   int strikeout = 0;

   if ( hb_parl (4) )
   {
      bold = FW_BOLD;
   }

   if ( hb_parl (5) )
   {
      italic = 1;
   }

   if ( hb_parl (6) )
   {
      underline = 1;
   }

   if ( hb_parl (7) )
   {
      strikeout = 1;
   }

    SendMessage( HWNDparam( 1 ) , (UINT)WM_SETFONT , (WPARAM) PrepareFont ( ( char * ) hb_parc(2) , (LPARAM) hb_parni(3),bold,italic,underline,strikeout,hb_parnl(8),hb_parnl(9)) , 1 ) ;
}

void getwinver( OSVERSIONINFO * pOSvi );

HB_FUNC( GETSYSTEMFONT )
{
   LOGFONT lfDlgFont;
   NONCLIENTMETRICS ncm;
   OSVERSIONINFO osvi;
   CHAR *szFName;
   int iHeight;

   getwinver( &osvi );
   if( osvi.dwMajorVersion >= 5 )
   {
      ncm.cbSize = sizeof( ncm );

      SystemParametersInfo( SPI_GETNONCLIENTMETRICS, ncm.cbSize, &ncm, 0 );

      lfDlgFont = ncm.lfMessageFont;

      szFName = lfDlgFont.lfFaceName;
      iHeight = 21 + lfDlgFont.lfHeight;
   }
   else
   {
      szFName = "MS Sans Serif";
      iHeight = 21 + 8;
   }

   hb_reta( 2 );
   HB_STORC( szFName, -1, 1 );
   HB_STORNI( iHeight, -1, 2 );
}
