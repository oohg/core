/*
 * $Id: c_media.c,v 1.7 2017-08-25 19:42:17 fyurisich Exp $
 */
/*
 * ooHG source code:
 * C multimedia functions
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

#include <windows.h>
#include <mmsystem.h>
#include <commctrl.h>
#include "hbapi.h"
#include "../include/oohg.h"

#include <commctrl.h>

HB_FUNC ( PLAYBEEP )
{
	MessageBeep(0xFFFFFFFF);
}

HB_FUNC ( PLAYASTERISK )
{
	MessageBeep(MB_ICONASTERISK);
}

HB_FUNC ( PLAYEXCLAMATION )
{
	MessageBeep(MB_ICONEXCLAMATION);
}

HB_FUNC ( PLAYHAND )
{
	MessageBeep(MB_ICONHAND);
}

HB_FUNC ( PLAYQUESTION )
{
	MessageBeep(MB_ICONQUESTION);
}

HB_FUNC ( PLAYOK )
{
	MessageBeep(MB_OK);
}

HB_FUNC (C_PLAYWAVE)
{
	int Style = SND_ASYNC;
        HMODULE hmod=NULL;
	if (  hb_parl(2) )
		{
		Style = Style | SND_RESOURCE ;
		hmod = GetModuleHandle(NULL) ;
		}
        else
		Style = Style | SND_FILENAME ;

	if (  hb_parl (3) )
		Style = Style | SND_SYNC ;
	if (  hb_parl (4) )
		Style = Style | SND_NOSTOP ;
	if (  hb_parl (5) )
		Style = Style | SND_LOOP;
	if (  hb_parl (6) )
		Style = Style | SND_NODEFAULT;

        hb_retl(PlaySound(hb_parc(1),hmod,Style));
}

HB_FUNC (STOPWAVE)
{
        hb_retl(PlaySound( (LPCSTR) NULL , (HMODULE) GetModuleHandle(NULL) , SND_PURGE ) ) ;
}
