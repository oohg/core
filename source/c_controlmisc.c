/*
 * $Id: c_controlmisc.c,v 1.17 2005-11-25 05:38:41 guerra000 Exp $
 */
/*
 * ooHG source code:
 * Miscelaneus C controls functions
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

#if defined(__MINGW32__)
  #define UDM_GETPOS32 0x0472
  #define UDM_SETPOS32 0x0471
#endif

#if defined(_MSC_VER)
  #define UDM_SETPOS32 (WM_USER+113)
  #define UDM_GETPOS32 (WM_USER+114)
#endif

#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "winreg.h"
#include "tchar.h"
#include "../include/oohg.h"

PHB_DYNS *s_Symbols = NULL;

char *s_SymbolNames[] = { "EVENTS_NOTIFY",
                          "GRIDFORECOLOR",
                          "GRIDBACKCOLOR",
                          "FONTCOLOR",
                          "BACKCOLOR",
                          "CONTAINER",
                          "PARENT",
                          "HCURSOR",
                          "EVENTS",
                          "EVENTS_COLOR",
                          "NAME",
                          "TYPE",
                          "TCONTROL",
                          "TLABEL",
                          "TGRID",
                          "CONTEXTMENU",
                          "ROWMARGIN",
                          "COLMARGIN",
                          "HWND",
                          "TTEXT",
                          "ADJUSTRIGHTSCROLL",
                          "ONMOUSEMOVE",
                          "ONMOUSEDRAG",
                          "DOEVENT",
                          "LOOKFORKEY",
                          "ACONTROLINFO",
                          "_ACONTROLINFO",
                          "EVENTS_DRAWITEM",
                          "_HWND",
                          "EVENTS_COMMAND",
                          "ONCHANGE",
                          "ONGOTFOCUS",
                          "ONLOSTFOCUS",
                          "ONCLICK",
                          "TRANSPARENT",
                          "LastSymbol" };

void _OOHG_Send( PHB_ITEM pSelf, int iSymbol )
{
   if( ! s_Symbols )
   {
      s_Symbols = hb_xgrab( sizeof( PHB_DYNS ) * s_LastSymbol );
      memset( s_Symbols, 0, sizeof( PHB_DYNS ) * s_LastSymbol );
   }

   if( ! s_Symbols[ iSymbol ] )
   {
      s_Symbols[ iSymbol ] = hb_dynsymFind( s_SymbolNames[ iSymbol ] );
   }

   hb_vmPushSymbol( s_Symbols[ iSymbol ]->pSymbol );
   hb_vmPush( pSelf );
}

POCTRL _OOHG_GetControlInfo( PHB_ITEM pSelf )
{
   PHB_ITEM pArray;
   BOOL bRelease = 0;
   char *pString;

   _OOHG_Send( pSelf, s_aControlInfo );
   hb_vmSend( 0 );
   pArray = hb_param( -1, HB_IT_ARRAY );
   if( ! pArray )
   {
      bRelease = 1;
      pArray = hb_itemNew( NULL );
      hb_arrayNew( pArray, 1 );
      _OOHG_Send( pSelf, s__aControlInfo );
      hb_vmPush( pArray );
      hb_vmSend( 1 );
   }

   if( pArray->item.asArray.value->ulLen < 1 )
   {
      hb_arraySize( pArray, 1 );
   }

   if( ! HB_IS_STRING( pArray->item.asArray.value->pItems ) || pArray->item.asArray.value->pItems->item.asString.length < _OOHG_Struct_Size )
   {
      pString = hb_xgrab( _OOHG_Struct_Size );

      // Initializes...
      memset( pString, 0, _OOHG_Struct_Size );
      ( ( POCTRL ) pString )->lFontColor = -1;
      ( ( POCTRL ) pString )->lBackColor = -1;

      if( HB_IS_STRING( pArray->item.asArray.value->pItems ) && pArray->item.asArray.value->pItems->item.asString.value && pArray->item.asArray.value->pItems->item.asString.length )
      {
         memcpy( pString, pArray->item.asArray.value->pItems->item.asString.value, pArray->item.asArray.value->pItems->item.asString.length );
      }
      hb_itemPutCL( pArray->item.asArray.value->pItems, pString, _OOHG_Struct_Size );
      hb_xfree( pString );
   }

   pString = pArray->item.asArray.value->pItems->item.asString.value;

   if( bRelease )
   {
      hb_itemRelease( pArray );
   }

   return ( POCTRL ) pString;
}

void _OOHG_DoEvent( PHB_ITEM pSelf, int iSymbol )
{
   PHB_ITEM pSelf2;

   pSelf2 = hb_itemNew( pSelf );
   _OOHG_Send( pSelf2, iSymbol );
   hb_vmSend( 0 );
   _OOHG_Send( pSelf2, s_DoEvent );
   hb_vmPush( hb_param( -1, HB_IT_ANY ) );
   hb_vmSend( 1 );
   hb_itemRelease( pSelf2 );
}

BOOL _OOHG_DetermineColor( PHB_ITEM pColor, LONG *lColor )
{
   BOOL bValid = 0;

   if( pColor )
   {

      if( HB_IS_NUMERIC( pColor ) )
      {
         *lColor = hb_itemGetNL( pColor );
         bValid = 1;
      }
      else if( HB_IS_ARRAY( pColor ) && pColor->item.asArray.value->ulLen >= 3 &&
               HB_IS_NUMERIC( &pColor->item.asArray.value->pItems[ 0 ] ) &&
               HB_IS_NUMERIC( &pColor->item.asArray.value->pItems[ 1 ] ) &&
               HB_IS_NUMERIC( &pColor->item.asArray.value->pItems[ 2 ] ) )
      {
         *lColor = RGB( hb_itemGetNL( &pColor->item.asArray.value->pItems[ 0 ] ),
                        hb_itemGetNL( &pColor->item.asArray.value->pItems[ 1 ] ),
                        hb_itemGetNL( &pColor->item.asArray.value->pItems[ 2 ] ) );
         bValid = 1;
      }
      else if( HB_IS_STRING( pColor ) && pColor->item.asString.length >= 3 )
      {
         *lColor = RGB( pColor->item.asString.value[ 0 ],
                        pColor->item.asString.value[ 1 ],
                        pColor->item.asString.value[ 2 ] );
         bValid = 1;
      }

   }

   return bValid;
}

HB_FUNC ( DELETEOBJECT )
{
   hb_retl ( DeleteObject( (HGDIOBJ) hb_parnl( 1 ) ) ) ;
}

HB_FUNC ( CSHOWCONTROL )
{

	HWND hwnd;

	hwnd = (HWND) hb_parnl (1);

	ShowWindow(hwnd, SW_SHOW);

	return ;
}

HB_FUNC( INITTOOLTIP )
{

	HWND htooltip;
        int Style = TTS_ALWAYSTIP;

        if ( hb_parl(2) )
        {
           Style = Style | TTS_BALLOON ;
        }


	InitCommonControls();

	htooltip = CreateWindowEx( 0,
	"tooltips_class32",
	"",
        Style,
	0,
	0,
	0,
	0,
	(HWND) hb_parnl(1) ,
	(HMENU) 0 ,
	GetModuleHandle ( NULL )
	, NULL ) ;

	hb_retnl ( (LONG) htooltip ) ;

}

HB_FUNC ( SETTOOLTIP )
{

	static  TOOLINFO  ti;

	HWND hWnd ;
	char *Text ;
	HWND hWnd_ToolTip ;

	hWnd = (HWND) hb_parnl (1) ;
	Text = hb_parc (2) ;
	hWnd_ToolTip = (HWND) hb_parnl (3) ;

	memset(&ti,0,sizeof(ti));

	ti.cbSize=sizeof(ti);
	ti.uFlags=TTF_SUBCLASS|TTF_IDISHWND;
	ti.hwnd=GetParent(hWnd);
	ti.uId=(UINT)hWnd;

	if(SendMessage(hWnd_ToolTip,(UINT)TTM_GETTOOLINFO,(WPARAM)0,(LPARAM)&ti))
	{
		SendMessage(hWnd_ToolTip,(UINT)TTM_DELTOOL,(WPARAM)0,(LPARAM)&ti);
	}

	ti.cbSize=sizeof(ti);
	ti.uFlags=TTF_SUBCLASS|TTF_IDISHWND;
	ti.hwnd=GetParent(hWnd);
	ti.uId=(UINT)hWnd;
	ti.lpszText=Text;
	SendMessage(hWnd_ToolTip,(UINT)TTM_ADDTOOL,(WPARAM)0,(LPARAM)&ti);

	hb_retni(0);

}
HB_FUNC ( HIDEWINDOW )
{
	HWND hwnd;

	hwnd = (HWND) hb_parnl (1);

	ShowWindow(hwnd, SW_HIDE);

	return ;
}

HB_FUNC ( CHECKDLGBUTTON )
{
	CheckDlgButton(
	(HWND) hb_parnl (2),
	hb_parni(1),
	BST_CHECKED);
}

HB_FUNC ( UNCHECKDLGBUTTON )
{
	CheckDlgButton(
	(HWND) hb_parnl (2),
	hb_parni(1),
	BST_UNCHECKED);
}

HB_FUNC ( SETDLGITEMTEXT )
{
    SetDlgItemText(
       (HWND) hb_parnl (3) ,
       hb_parni( 1 ),
       (LPCTSTR) hb_parc( 2 )
    );
}

HB_FUNC ( SETFOCUS )
{
   hb_retnl( (LONG) SetFocus( (HWND) hb_parnl( 1 ) ) );
}

HB_FUNC ( GETDLGITEMTEXT )
{
   USHORT iLen = 32768;
   char *cText = (char*) hb_xgrab( iLen+1 );

	GetDlgItemText(
	(HWND) hb_parnl (2),	// handle of dialog box
	hb_parni(1),		// identifier of control
	(LPTSTR) cText,       	// address of buffer for text
	iLen                   	// maximum size of string
	);

   hb_retc( cText );
   hb_xfree( cText );
}

HB_FUNC ( ISDLGBUTTONCHECKED )
{
	UINT r ;

	r = IsDlgButtonChecked( (HWND) hb_parnl (2), hb_parni( 1 ) );

	if ( r == BST_CHECKED )
	{
		hb_retl( TRUE );
	}
	else
	{
		hb_retl( FALSE );
	}
}

HB_FUNC ( SETSPINNERVALUE )
{
	SendMessage((HWND) hb_parnl(1) ,
		(UINT)UDM_SETPOS32 ,
		(WPARAM)0,
		(LPARAM) (INT) hb_parni (2)
		) ;
}
HB_FUNC ( GETSPINNERVALUE )
{
	hb_retnl (
	SendMessage((HWND) hb_parnl(1) ,
		(UINT)UDM_GETPOS32 ,
		(WPARAM) 0 ,
		(LPARAM) 0 )
	) ;
}

HB_FUNC ( INSERTTAB )
{

	keybd_event(
		VK_TAB	,	// virtual-key code
		0,		// hardware scan code
		0,		// flags specifying various function options
		0		// additional data associated with keystroke
	);

}

HB_FUNC ( INSERTSHIFTTAB )
{

	keybd_event(
		VK_SHIFT,	// virtual-key code
		0,		// hardware scan code
		0,		// flags specifying various function options
		0		// additional data associated with keystroke
	);

	keybd_event(
		VK_TAB	,	// virtual-key code
		0,		// hardware scan code
		0,		// flags specifying various function options
		0		// additional data associated with keystroke
	);

	keybd_event(
		VK_SHIFT,	// virtual-key code
		0,		// hardware scan code
		KEYEVENTF_KEYUP,// flags specifying various function options
		0		// additional data associated with keystroke
	);

}



HB_FUNC ( RELEASECONTROL )
{
	SendMessage( (HWND) hb_parnl(1) , WM_SYSCOMMAND , SC_CLOSE , 0 ) ;
}


HB_FUNC ( INSERTBACKSPACE )
{

	keybd_event(
		VK_BACK	,	// virtual-key code
		0,		// hardware scan code
		0,		// flags specifying various function options
		0		// additional data associated with keystroke
	);

}

HB_FUNC ( INSERTPOINT )
{

	keybd_event(
		VK_DECIMAL		,	// virtual-key code
		0,		// hardware scan code
		0,		// flags specifying various function options
		0		// additional data associated with keystroke
	);

}

HB_FUNC ( GETMODULEFILENAME )

{
   BYTE bBuffer[ MAX_PATH + 1 ] = { 0 } ;

   GetModuleFileName( ( HMODULE ) hb_parnl( 1 ), ( char * ) bBuffer, 249 );
   hb_retc( ( char * ) bBuffer );
}

HB_FUNC (SETCURSORPOS)
{
   SetCursorPos( hb_parni( 1 ), hb_parni( 2 ) );
}

HB_FUNC (SHOWCURSOR)
{
   hb_retni( ShowCursor( hb_parl( 1 ) ) );
}

HB_FUNC( SYSTEMPARAMETERSINFO )
{
   if( SystemParametersInfoA( (UINT) hb_parni( 1 ),
                             (UINT) hb_parni( 2 ),
                             (VOID *) hb_parc( 3 ),
                             (UINT) hb_parni( 4 ) ) )
   {
      hb_retl( TRUE );
   }
   else
   {
      hb_retl( FALSE );
   }
}

HB_FUNC( GETTEXTWIDTH )  // returns the width of a string in pixels
{
   HDC   hDC        = ( HDC ) hb_parnl( 1 );
   HWND  hWnd;
   BOOL  bDestroyDC = FALSE;
   HFONT hFont = ( HFONT ) hb_parnl( 3 );
   HFONT hOldFont;
   SIZE sz;

   if( ! hDC )
   {
      bDestroyDC = TRUE;
      hWnd = GetActiveWindow();
      hDC = GetDC( hWnd );
   }

   if( hFont )
      hOldFont = ( HFONT ) SelectObject( hDC, hFont );

   GetTextExtentPoint32( hDC, hb_parc( 2 ), hb_parclen( 2 ), &sz );

   if( hFont )
      SelectObject( hDC, hOldFont );

   if( bDestroyDC )
       ReleaseDC( hWnd, hDC );

   hb_retni( LOWORD( sz.cx ) );
}

HB_FUNC( GETTEXTHEIGHT )  // returns the width of a string in pixels
{
   HDC   hDC        = ( HDC ) hb_parnl( 1 );
   HWND  hWnd;
   BOOL  bDestroyDC = FALSE;
   HFONT hFont = ( HFONT ) hb_parnl( 3 );
   HFONT hOldFont;
   SIZE sz;

   if( ! hDC )
   {
      bDestroyDC = TRUE;
      hWnd = GetActiveWindow();
      hDC = GetDC( hWnd );
   }

   if( hFont )
      hOldFont = ( HFONT ) SelectObject( hDC, hFont );

   GetTextExtentPoint32( hDC, hb_parc( 2 ), hb_parclen( 2 ), &sz );

   if( hFont )
      SelectObject( hDC, hOldFont );

   if( bDestroyDC )
       ReleaseDC( hWnd, hDC );

   hb_retni( LOWORD( sz.cy ) );
}

HB_FUNC ( KEYBD_EVENT )
{

	keybd_event(
        (WORD) hb_parni(1),                // virtual-key code
        (WORD) MapVirtualKey( hb_parni(1), 0 ),    // hardware scan code
		hb_parl(2) ? KEYEVENTF_KEYUP: 0,	// flags specifying various function options
		0					// additional data associated with keystroke
	);

}

HB_FUNC ( INSERTRETURN )
{

	keybd_event(
		VK_RETURN	, // virtual-key code
		0,		// hardware scan code
		0,		// flags specifying various function options
		0		// additional data associated with keystroke
	);

}

HB_FUNC ( GETSHOWCMD )
{

	WINDOWPLACEMENT WP;
	HWND h;
        int i;

	h = (HWND) hb_parnl( 1 ) ;

	WP.length = sizeof(WINDOWPLACEMENT) ;

	GetWindowPlacement( (HWND) h , &WP ) ;

        i =  WP.showCmd;

	hb_retni (i);

}

HB_FUNC( GETPROGRAMFILENAME )
{
   char Buffer [ MAX_PATH + 1 ] = { 0 } ;
   GetModuleFileName( GetModuleHandle(NULL) , Buffer , MAX_PATH ) ;
   hb_retc(Buffer);
}

HB_FUNC( IMAGELIST_INIT )
{
   HIMAGELIST himl = 0;
   HBITMAP hbmp;
   PHB_ITEM hArray;
   char *caption;
   int iLen, s, cx = 0, cy = 0, iStyle;

   iLen = hb_parinfa( 1, 0 );
   hArray = hb_param( 1, HB_IT_ARRAY );
   if( iLen != 0 )
   {
      iStyle = hb_parni( 3 );
      iLen--;
      caption = hb_itemGetCPtr( hArray->item.asArray.value->pItems );

      himl = ImageList_LoadImage( GetModuleHandle( NULL ), caption, 0, iLen, hb_parni( 2 ), IMAGE_BITMAP, iStyle );
      if ( himl == NULL )
      {
         himl = ImageList_LoadImage( GetModuleHandle( NULL ), caption, 0, iLen, hb_parni( 2 ), IMAGE_BITMAP, iStyle | LR_LOADFROMFILE );
      }

      ImageList_GetIconSize( himl, &cx, &cy );

      for( s = 1; s <= iLen; s++ )
      {
         caption = hb_itemGetCPtr( hArray->item.asArray.value->pItems + s );

         hbmp = ( HBITMAP ) LoadImage( GetModuleHandle( NULL ), caption, IMAGE_BITMAP, cx, cy, iStyle );
         if( hbmp == NULL )
         {
            hbmp = ( HBITMAP ) LoadImage( GetModuleHandle( NULL ), caption, IMAGE_BITMAP, cx, cy, iStyle | LR_LOADFROMFILE );
         }

         ImageList_Add( himl, hbmp, NULL );
         DeleteObject( hbmp ) ;
      }
   }

   hb_reta( 3 );
   hb_stornl( ( LONG ) himl, -1, 1 );
   hb_storni( ( int )  cx,   -1, 2 );
   hb_storni( ( int )  cy,   -1, 3 );
}

HB_FUNC( IMAGELIST_DESTROY )
{
   hb_retl( ImageList_Destroy( ( HIMAGELIST ) hb_parnl( 1 ) ) );
}

HB_FUNC( IMAGELIST_ADD )
{
   HIMAGELIST himl = ( HIMAGELIST ) hb_parnl( 1 );
   HBITMAP hbmp;
   int cx, cy, ic = 0;
   int iStyle = hb_parni( 3 );

   if ( himl != NULL )
   {
      ImageList_GetIconSize( himl, &cx, &cy );

      hbmp = ( HBITMAP ) LoadImage( GetModuleHandle( NULL ), hb_parc( 2 ), IMAGE_BITMAP, cx, cy, iStyle );
      if( hbmp == NULL )
      {
         hbmp = ( HBITMAP ) LoadImage( GetModuleHandle( NULL ), hb_parc( 2 ), IMAGE_BITMAP, cx, cy, iStyle | LR_LOADFROMFILE );
      }

      ImageList_Add( himl, hbmp, NULL );
      DeleteObject( hbmp );

      ic = ImageList_GetImageCount( himl );
   }

   hb_retni( ic );
}

HB_FUNC( IMAGELIST_GETIMAGECOUNT )
{
   hb_retni( ImageList_GetImageCount( ( HIMAGELIST ) hb_parnl( 1 ) ) );
}

HB_FUNC( IMAGELIST_DUPLICATE )
{
   hb_retnl( ( LONG ) ImageList_Duplicate( ( HIMAGELIST ) hb_parnl( 1 ) ) );
}

void ImageFillParameter( struct IMAGE_PARAMETER *pResult, PHB_ITEM pString )
{
   if( pString && HB_IS_STRING( pString ) )
   {
      pResult->cString = hb_itemGetC( pString );
      pResult->iImage1 = -1;
      pResult->iImage2 = -1;
   }
   else if( pString && HB_IS_NUMERIC( pString ) )
   {
      pResult->cString = "";
      pResult->iImage1 = hb_itemGetNI( pString );
      pResult->iImage2 = pResult->iImage1;
   }
   else if( pString && HB_IS_LOGICAL( pString ) )
   {
      pResult->cString = "";
      pResult->iImage1 = ( hb_itemGetL( pString ) ? 1 : 0 );
      pResult->iImage2 = pResult->iImage1;
   }
   else if( pString && HB_IS_ARRAY( pString ) && pString->item.asArray.value->ulLen > 0 )
   {
      pResult->cString = hb_itemGetC( pString->item.asArray.value->pItems );
      if( pString->item.asArray.value->ulLen > 1 && HB_IS_NUMERIC( &pString->item.asArray.value->pItems[ 1 ] ) )
      {
         pResult->iImage1 = hb_itemGetNI( &pString->item.asArray.value->pItems[ 1 ] );
         if( pString->item.asArray.value->ulLen > 2 && HB_IS_NUMERIC( &pString->item.asArray.value->pItems[ 2 ] ) )
         {
            pResult->iImage2 = hb_itemGetNI( &pString->item.asArray.value->pItems[ 2 ] );
         }
         else
         {
            pResult->iImage2 = pResult->iImage1;
         }
      }
      else
      {
         pResult->iImage1 = -1;
         pResult->iImage2 = -1;
      }
   }
   else
   {
      pResult->cString = "";
      pResult->iImage1 = -1;
      pResult->iImage2 = -1;
   }
}

int GetKeyFlagState( void )
{
   return ( ( ( GetKeyState( VK_MENU )    & 0x8000 ) != 0 ) ? 1 : 0 ) +
          ( ( ( GetKeyState( VK_CONTROL ) & 0x8000 ) != 0 ) ? 2 : 0 ) +
          ( ( ( GetKeyState( VK_SHIFT )   & 0x8000 ) != 0 ) ? 4 : 0 ) ;
}

HB_FUNC( GETKEYFLAGSTATE )
{
   hb_retni( GetKeyFlagState() );
}

static PHB_DYNS _ooHG_Symbol_TControl = 0;
static HB_ITEM  _OOHG_aControlhWnd, _OOHG_aControlObjects;

HB_FUNC( _OOHG_INIT_C_VARS_CONTROLS_C_SIDE )
{
   _ooHG_Symbol_TControl = hb_dynsymFind( "TCONTROL" );
   memcpy( &_OOHG_aControlhWnd,    hb_param( 1, HB_IT_ARRAY ), sizeof( HB_ITEM ) );
   memcpy( &_OOHG_aControlObjects, hb_param( 2, HB_IT_ARRAY ), sizeof( HB_ITEM ) );
}

PHB_ITEM GetControlObjectByHandle( LONG hWnd )
{
   PHB_ITEM pControl;
   ULONG ulCount;

   if( ! _ooHG_Symbol_TControl )
   {
      hb_vmPushSymbol( hb_dynsymFind( "_OOHG_INIT_C_VARS_CONTROLS" )->pSymbol );
      hb_vmPushNil();
      hb_vmDo( 0 );
   }

   pControl = 0;
   for( ulCount = 0; ulCount < _OOHG_aControlhWnd.item.asArray.value->ulLen; ulCount++ )
   {
      if( hWnd == hb_itemGetNL( &_OOHG_aControlhWnd.item.asArray.value->pItems[ ulCount ] ) )
      {
         pControl = &_OOHG_aControlObjects.item.asArray.value->pItems[ ulCount ];
         ulCount = _OOHG_aControlhWnd.item.asArray.value->ulLen;
      }
   }
   if( ! pControl )
   {
      hb_vmPushSymbol( _ooHG_Symbol_TControl->pSymbol );
      hb_vmPushNil();
      hb_vmDo( 0 );
      pControl = hb_param( -1, HB_IT_ANY );
   }

   return pControl;
}

HB_FUNC( GETCONTROLOBJECTBYHANDLE )
{
   HB_ITEM pReturn;

   pReturn.type = HB_IT_NIL;
   hb_itemCopy( &pReturn, GetControlObjectByHandle( hb_parnl( 1 ) ) );

   hb_itemReturn( &pReturn );
   hb_itemClear( &pReturn );
}

HB_FUNC( GETCLIPBOARDTEXT )
{
   HGLOBAL hClip;
   LPTSTR  cString;

   if( IsClipboardFormatAvailable( CF_TEXT ) && OpenClipboard( NULL ) )
   {
      hClip = GetClipboardData( CF_TEXT );
      if( hClip )
      {
         cString = GlobalLock( hClip );
         if( cString )
         {
            hb_retc( cString );
            GlobalUnlock( hClip );
         }
         else
         {
            hb_retc( "" );
         }
      }
      else
      {
         hb_retc( "" );
      }
      CloseClipboard();
   }
   else
   {
      hb_retc( "" );
   }
}