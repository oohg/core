/*
 * $Id: c_image.c,v 1.2 2005-08-25 05:57:42 guerra000 Exp $
 */
/*
 * ooHG source code:
 * C image functions
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

#ifndef CINTERFACE
	#define CINTERFACE
#endif
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
#include <winuser.h>
#include <wingdi.h>
#include "olectl.h"
#include "../include/oohg.h"

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProc( GetControlObjectByHandle( ( LONG ) hWnd ), hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

HBITMAP loadolepicture(char * filename,int width,int height, HWND handle, int scalestrech , int whitebackground , int transparent ) ;

HB_FUNC (INITIMAGE)
{
   HWND  h;
   HBITMAP hBitmap;
   HWND hwnd;
   int Style, StyleEx;
   int whitebackground ;

   hwnd = (HWND) hb_parnl (1);

   StyleEx = 0;
   if ( hb_parl( 11 ) )
   {
      StyleEx |= WS_EX_LAYOUTRTL | WS_EX_RIGHTSCROLLBAR | WS_EX_RTLREADING;
   }

   Style = WS_CHILD | SS_BITMAP | SS_NOTIFY;

   if ( ! hb_parl (8) )
   {
      Style |= WS_VISIBLE ;
   }

        if ( hb_parl (10) )
        {
                whitebackground = 1 ;
        }
	else
	{
                whitebackground = 0 ;
	}

   h = CreateWindowEx(StyleEx,"static",NULL,
        Style,
        hb_parni(3), hb_parni(4), 0, 0,
        hwnd,(HMENU)hb_parni(2) , GetModuleHandle(NULL) , NULL ) ;

   hBitmap = loadolepicture(hb_parc(5),hb_parni(6),hb_parni(7),h,hb_parni(9) , whitebackground, 0 ) ;
   if (hBitmap!=NULL)
   {
      SendMessage(h,(UINT)STM_SETIMAGE,(WPARAM)IMAGE_BITMAP,(LPARAM)hBitmap);
   }

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( ( HWND ) h, GWL_WNDPROC, ( LONG ) SubClassFunc );

   hb_retnl ( (LONG) h );
}

HB_FUNC (C_SETPICTURE)
{

// 1. CONTROL HANDLE
// 2. FILENAME
// 3. WIDTH
// 4. HEIGHT

        HBITMAP hBitmap;

        hBitmap = loadolepicture(hb_parc(2),hb_parni(3),hb_parni(4),(HWND) hb_parnl (1),hb_parni(5) , 0 , 0 );
        if (hBitmap!=NULL)
             SendMessage((HWND) hb_parnl (1),(UINT)STM_SETIMAGE,(WPARAM)IMAGE_BITMAP,(LPARAM)hBitmap);
}

HBITMAP loadolepicture(char * filename,int width,int height, HWND handle, int scalestrech , int whitebackground  , int transparent )
{

	HINSTANCE hinstance=GetModuleHandle(NULL);

	LPVOID lpVoid ;
	int nSize ;

	HRSRC hSource ;
	HGLOBAL hGlobalres ;

	IStream *iStream ;
	IPicture *iPicture = NULL;
	HGLOBAL hGlobal;
	HANDLE hFile;
	DWORD nFileSize;
	DWORD nReadByte;
	RECT rect,rect2;
	HBITMAP hpic,hpic2;
	BITMAP bm;
	SIZE size;
	long lWidth,lHeight;
	HDC imgDC = GetDC ( handle ) ;
	HDC tmpDC = CreateCompatibleDC(imgDC);
	HDC tmp2DC = CreateCompatibleDC(imgDC);

	if (width==0 & height==0)
	{
		GetClientRect(handle,&rect);
	}
	else
	{
		SetRect(&rect,0,0,width,height);
	}

	SetRect(&rect2,0,0,rect.right,rect.bottom);

	if ( transparent == 0 )
	{
		hpic2 = (HBITMAP)LoadImage(0,filename,IMAGE_BITMAP,0,0,LR_LOADFROMFILE|LR_CREATEDIBSECTION ) ;
	}
	else
	{
		hpic2 = (HBITMAP)LoadImage(0,filename,IMAGE_BITMAP,0,0,LR_LOADFROMFILE|LR_CREATEDIBSECTION  | LR_LOADMAP3DCOLORS | LR_LOADTRANSPARENT  );
	}

	if (hpic2==NULL)
	{

		if ( transparent == 0 )
		{
			hpic2 = (HBITMAP)LoadImage(GetModuleHandle(NULL),filename,IMAGE_BITMAP,0,0,LR_CREATEDIBSECTION);
		}
		else
		{
			hpic2 = (HBITMAP)LoadImage(GetModuleHandle(NULL),filename,IMAGE_BITMAP,0,0,LR_CREATEDIBSECTION  | LR_LOADMAP3DCOLORS | LR_LOADTRANSPARENT  );
		}

	}

	if (hpic2!=NULL)
	{
		GetObject(hpic2,sizeof(BITMAP),&bm);
		lWidth=bm.bmWidth;
		lHeight=bm.bmHeight;
		SelectObject(tmp2DC,hpic2);
	}
	else
	{
		hFile = CreateFile(filename, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);

		if (hFile == INVALID_HANDLE_VALUE)
		{

			hSource = FindResource(hinstance,filename,"GIF");

			if (hSource==NULL)
			{
				hSource = FindResource(hinstance,filename,"JPG");
			}

			if (hSource==NULL)
			{
				return NULL ;
			}

			hGlobalres = LoadResource(hinstance, hSource);

			if (hGlobalres==NULL)
			{
				return NULL ;
			}

			lpVoid = LockResource(hGlobalres);

			if (lpVoid==NULL)
			{
				return NULL ;
			}

			nSize = SizeofResource(hinstance, hSource);

			hGlobal=GlobalAlloc(GPTR, nSize);

			if (hGlobal==NULL)
			{
				return NULL;
			}

			memcpy(hGlobal,lpVoid, nSize);

			FreeResource(hGlobalres);

			CreateStreamOnHGlobal(hGlobal, TRUE, &iStream);

			OleLoadPicture(iStream, nFileSize, TRUE, &IID_IPicture, (LPVOID*)&iPicture);
			if (iPicture==NULL)
			{
				return NULL;
			}

			iPicture->lpVtbl->get_Width(iPicture,&lWidth);
			iPicture->lpVtbl->get_Height(iPicture,&lHeight);

		}
		else
		{

			nFileSize = GetFileSize(hFile, NULL);
			hGlobal = GlobalAlloc(GPTR, nFileSize);
			ReadFile(hFile, hGlobal, nFileSize, &nReadByte, NULL);
			CloseHandle(hFile);
			CreateStreamOnHGlobal(hGlobal, TRUE, &iStream);
			OleLoadPicture(iStream, nFileSize, TRUE, &IID_IPicture, (LPVOID*)&iPicture);

			if (iPicture==NULL)
			{
				return NULL ;
			}

			iPicture->lpVtbl->get_Width(iPicture,&lWidth);
			iPicture->lpVtbl->get_Height(iPicture,&lHeight);

		}

	}

	if (scalestrech==0)
	{
		if ((int)lWidth*rect.bottom/lHeight <= rect.right)
		{
			rect.right=(int)lWidth*rect.bottom/lHeight;
		}
		else
		{
			rect.bottom=(int)lHeight*rect.right/lWidth;
		}
	}

	rect.left = (int) (width-rect.right)/2;
	rect.top = (int) (height-rect.bottom)/2;

	hpic=CreateCompatibleBitmap(imgDC,width,height);

	SelectObject(tmpDC,hpic);

	if ( whitebackground == 1 )
	{
		  FillRect(tmpDC,&rect2,(HBRUSH) GetStockObject(WHITE_BRUSH));
	}
	else
	{
		FillRect(tmpDC,&rect2,(HBRUSH) GetSysColorBrush(COLOR_BTNFACE));
	}

	if (iPicture!=NULL)
	{
		iPicture->lpVtbl->Render(iPicture,tmpDC,rect.left,rect.top,rect.right,rect.bottom, 0, lHeight, lWidth, -lHeight, NULL);
		iPicture->lpVtbl->Release(iPicture);
		GlobalFree(hGlobal);
	}
	else
	{
		StretchBlt(tmpDC,rect.left,rect.top,rect.right,rect.bottom,tmp2DC,0,0,lWidth,lHeight,SRCCOPY);
		DeleteDC(tmp2DC);
		DeleteObject(hpic2);
	}

	DeleteDC(imgDC);
	DeleteDC(tmpDC);

	return hpic;

}