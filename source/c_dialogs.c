/*
 * $Id: c_dialogs.c,v 1.2 2006-09-24 16:36:36 declan2005 Exp $
 */
/*
 * ooHG source code:
 * C dialogs functions
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

HB_FUNC ( CHOOSEFONT )
{

	CHOOSEFONT cf;
	LOGFONT lf;
	long PointSize ;
	int bold ;
	HDC hdc ;
	HWND hwnd ;

	strcpy ( lf.lfFaceName , hb_parc(1) ) ;

	hwnd = GetActiveWindow() ;
	hdc = GetDC(hwnd) ;

	lf.lfHeight = -MulDiv( hb_parnl(2) , GetDeviceCaps(hdc, LOGPIXELSY) , 72 ) ;

	if ( hb_parl (3) )
	{
		lf.lfWeight = 700 ;
	}
	else
	{
		lf.lfWeight = 400 ;
	}

	if ( hb_parl (4) )
	{
		lf.lfItalic = TRUE ;
	}
	else
	{
		lf.lfItalic = FALSE ;
	}

	if ( hb_parl (6) )
	{
		 lf.lfUnderline = TRUE ;
	}
	else
	{
		 lf.lfUnderline = FALSE ;
	}

	if ( hb_parl (7) )
	{
		 lf.lfStrikeOut = TRUE ;
	}
	else
	{
		 lf.lfStrikeOut = FALSE ;
	}

	lf.lfCharSet = hb_parni (8) ;

	cf.lStructSize = sizeof(CHOOSEFONT);
	cf.hwndOwner = hwnd ;
	cf.hDC = (HDC)NULL;
	cf.lpLogFont = &lf;
	cf.Flags = CF_SCREENFONTS | CF_EFFECTS | CF_INITTOLOGFONTSTRUCT	;
	cf.rgbColors = hb_parnl(5) ;
	cf.lCustData = 0L;
	cf.lpfnHook = (LPCFHOOKPROC)NULL;
	cf.lpTemplateName = (LPSTR)NULL;
	cf.hInstance = (HINSTANCE) NULL;
	cf.lpszStyle = (LPSTR)NULL;
	cf.nFontType = SCREEN_FONTTYPE;
	cf.nSizeMin = 0;
	cf.nSizeMax = 0;

	if ( ! ChooseFont(&cf) )
	{
		hb_reta( 8 );
		hb_storc( "" , -1, 1 );
		hb_stornl( (LONG) 0 , -1, 2 );
		hb_storl( 0 , -1, 3 );
		hb_storl( 0 , -1, 4 );
		hb_stornl( 0 , -1, 5 );
		hb_storl( 0 , -1, 6 );
		hb_storl( 0 , -1, 7 );
		hb_storni( 0 , -1, 8 );
		return;
	}

	PointSize = -MulDiv ( lf.lfHeight , 72 , GetDeviceCaps(GetDC(GetActiveWindow()), LOGPIXELSY) ) ;

	if (lf.lfWeight == 700)
	{
		bold = 1;
	}
	else
	{
		bold = 0;
	}

	hb_reta( 8 );
	hb_storc( lf.lfFaceName , -1, 1 );
	hb_stornl( (LONG) PointSize , -1, 2 );
	hb_storl( bold , -1, 3 );
	hb_storl( lf.lfItalic , -1, 4 );
	hb_stornl( cf.rgbColors , -1, 5 );
	hb_storl( lf.lfUnderline , -1, 6 );
	hb_storl( lf.lfStrikeOut , -1, 7 );
	hb_storni( lf.lfCharSet , -1, 8 );

	ReleaseDC (hwnd,hdc) ;

}

HB_FUNC ( C_GETFILE )
{
	OPENFILENAME ofn;
	char buffer[32768];
	char cFullName[64][1024];
	char cCurDir[512];
	char cFileName[512];
	int iPosition = 0;
	int iNumSelected = 0;
	int n;

	int flags = OFN_FILEMUSTEXIST ;

	buffer[0] = 0 ;

	if ( hb_parl(4) )
	{
		flags = flags | OFN_ALLOWMULTISELECT | OFN_EXPLORER ;
	}
	if ( hb_parl(5) )
	{
		flags = flags | OFN_NOCHANGEDIR ;
	}

	memset( (void*) &ofn, 0, sizeof( OPENFILENAME ) );
	ofn.lStructSize = sizeof(ofn);
	ofn.hwndOwner = GetActiveWindow();
	ofn.lpstrFilter = hb_parc(1);
	ofn.nFilterIndex = 1;
	ofn.lpstrFile = buffer;
	ofn.nMaxFile = sizeof(buffer);
	ofn.lpstrInitialDir = hb_parc(3);
	ofn.lpstrTitle = hb_parc(2);
	ofn.nMaxFileTitle = 512;
	ofn.Flags = flags;

	if( GetOpenFileName( &ofn ) )
	{
		if(ofn.nFileExtension!=0)
		{
			hb_retc( ofn.lpstrFile );
		}
		else
		{
			wsprintf(cCurDir,"%s",&buffer[iPosition]);
			iPosition=iPosition+strlen(cCurDir)+1;

			do
			{
				iNumSelected++;
				wsprintf(cFileName,"%s",&buffer[iPosition]);
				iPosition=iPosition+strlen(cFileName)+1;
				wsprintf(cFullName[iNumSelected],"%s\\%s",cCurDir,cFileName);
			}
			while(  (strlen(cFileName)!=0) && ( iNumSelected <= 63 ) );

			if(iNumSelected > 1)
			{
				hb_reta( iNumSelected - 1 );

				for (n = 1; n < iNumSelected; n++)
				{
					hb_storc( cFullName[n], -1, n );
				}
			}
			else
			{
				hb_retc( &buffer[0] );
			}
		}
	}
	else
	{
		hb_retc( "" );
	}
}

HB_FUNC ( C_PUTFILE )
{

 OPENFILENAME ofn;
 char buffer[512];

 int flags = OFN_FILEMUSTEXIST | OFN_EXPLORER ;

 if ( hb_parl(4) )
 {
  flags = flags | OFN_NOCHANGEDIR ;
 }

 strcpy( buffer, "" );

 memset( (void*) &ofn, 0, sizeof( OPENFILENAME ) );
 ofn.lStructSize = sizeof(ofn);
 ofn.hwndOwner = GetActiveWindow() ;
 ofn.lpstrFilter = hb_parc(1) ;
 ofn.lpstrFile = buffer;
 ofn.nMaxFile = 512;
 ofn.lpstrInitialDir = hb_parc(3);
 ofn.lpstrTitle = hb_parc(2) ;
 ofn.Flags = flags;

 if( GetSaveFileName( &ofn ) )
 {
  hb_retc( ofn.lpstrFile );
 }
 else
 {
  hb_retc( "" );
 }

}

HB_FUNC( C_BROWSEFORFOLDER ) // Contributed By Ryszard Ryüko
{
   HWND hwnd = GetActiveWindow();
   BROWSEINFO bi;
   char *lpBuffer = (char*) hb_xgrab( MAX_PATH+1);
   LPITEMIDLIST pidlBrowse;    // PIDL selected by user
   SHGetSpecialFolderLocation(GetActiveWindow(), hb_parni(1) , &pidlBrowse) ;
    bi.hwndOwner = hwnd;
    bi.pidlRoot = pidlBrowse;
    bi.pszDisplayName = lpBuffer;
    bi.lpszTitle = "Choose a Directory";
    bi.ulFlags = hb_parni(2);
    bi.lpfn = NULL;
    bi.lParam = 0;

    // Browse for a folder and return its PIDL.
    pidlBrowse = SHBrowseForFolder(&bi);
    SHGetPathFromIDList(pidlBrowse,lpBuffer);
    hb_retc(lpBuffer);
    hb_xfree( lpBuffer);
}

HB_FUNC ( CHOOSECOLOR )
{
   CHOOSECOLOR cc ;
   COLORREF crCustClr[16] ;
   int i ;

   for( i = 0 ; i <16 ; i++ )
     crCustClr[i] = (ISARRAY(3) ? hb_parnl(3,i+1) : GetSysColor(COLOR_BTNFACE)) ;

   cc.lStructSize    = sizeof( CHOOSECOLOR ) ;
   cc.hwndOwner      = ISNIL(1) ? GetActiveWindow():(HWND) hb_parnl(1) ;
   cc.rgbResult      = (COLORREF)ISNIL(2) ?  0 : hb_parnl(2) ;
   cc.lpCustColors   = crCustClr ;
   cc.Flags          = (WORD) (ISNIL(4) ? CC_ANYCOLOR | CC_FULLOPEN | CC_RGBINIT : hb_parnl(4) ) ;

   if ( ! ChooseColorA( &cc ) )
   {
      hb_retnl( - 1 ) ;
   }
   else
   {
      hb_retnl( cc.rgbResult ) ;
   }

}
