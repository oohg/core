/*
 * $Id: c_tab.c,v 1.3 2006-02-10 06:35:45 guerra000 Exp $
 */
/*
 * ooHG source code:
 * C tab functions
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

HB_FUNC( INITTABCONTROL )
{

	PHB_ITEM hArray;
	HWND hwnd;
	HWND hbutton;
	TC_ITEM tie;
	int i;

	int Style = WS_CHILD | WS_VISIBLE ;

	if ( hb_parl (11) )
	{
		Style = Style | TCS_BUTTONS ;
	}

	if ( hb_parl (12) )
	{
		Style = Style | TCS_FLATBUTTONS ;
	}

	if ( hb_parl (13) )
	{
		Style = Style | TCS_HOTTRACK ;
	}

	if ( hb_parl (14) )
	{
		Style = Style | TCS_VERTICAL ;
	}

	if ( ! hb_parl (15) )
	{
		Style = Style | WS_TABSTOP ;
	}

	hArray = hb_param( 7, HB_IT_ARRAY );

	hwnd = (HWND) hb_parnl (1);

	hbutton = CreateWindow ( WC_TABCONTROL , NULL ,
	Style ,
	hb_parni(3), hb_parni(4) , hb_parni(5), hb_parni(6) ,
	hwnd,(HMENU)hb_parni(2) , GetModuleHandle(NULL) , NULL ) ;

	tie.mask = TCIF_TEXT ;
	tie.iImage = -1;

   for( i = hb_parinfa( 7, 0 ); i > 0; i-- )
   {
      tie.pszText = hb_arrayGetCPtr( hArray, i );
      TabCtrl_InsertItem( hbutton, 0, &tie );
   }

   TabCtrl_SetCurSel( hbutton, hb_parni( 8 ) - 1 );

   hb_retnl( ( LONG ) hbutton );
}

HB_FUNC (TABCTRL_SETCURSEL)
{

	HWND hwnd;
	int s;

	hwnd = (HWND) hb_parnl (1);

	s = hb_parni (2);

	TabCtrl_SetCurSel( hwnd , s-1 );

}

HB_FUNC (TABCTRL_GETCURSEL)
{
	HWND hwnd;
	hwnd = (HWND) hb_parnl (1);
	hb_retni ( TabCtrl_GetCurSel( hwnd ) + 1 ) ;
}

HB_FUNC (TABCTRL_INSERTITEM)
{
	HWND hwnd ;
	TC_ITEM tie ;
	int i ;

	hwnd = (HWND) hb_parnl (1) ;
	i = hb_parni (2) ;

	tie.mask = TCIF_TEXT ;
	tie.iImage = -1 ;
	tie.pszText = hb_parc(3) ;

	TabCtrl_InsertItem(hwnd, i, &tie) ;

}

HB_FUNC (TABCTRL_DELETEITEM)
{
	HWND hwnd ;
	int i ;

	hwnd = (HWND) hb_parnl (1) ;
	i = hb_parni (2) ;

	TabCtrl_DeleteItem(hwnd, i) ;

}

HB_FUNC( SETTABCAPTION )
{

	TC_ITEM tie;

	tie.mask = TCIF_TEXT ;

	tie.pszText = hb_parc(3) ;

	TabCtrl_SetItem ( (HWND) hb_parnl (1) , hb_parni (2)-1 , &tie);

}

HB_FUNC( SETTABPAGEIMAGE )
{
   TC_ITEM tie;

//            himl = ImageList_Create( cx , cy , ILC_COLOR8 | ILC_MASK , l + 1 , l + 1 );
//            ImageList_AddMasked( himl, hbmp, CLR_DEFAULT ) ;
   tie.mask = TCIF_IMAGE ;
   tie.iImage = hb_parni( 2 );
   TabCtrl_SetItem( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ), &tie );
}