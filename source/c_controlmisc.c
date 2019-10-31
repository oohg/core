/*
 * $Id: c_controlmisc.c $
 */
/*
 * ooHG source code:
 * Miscelaneous control related functions
 *
 * Copyright 2005-2019 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2019 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2019 Contributors, https://harbour.github.io/
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
#define _WIN32_WINNT   0x0400
#include <shlobj.h>
#include <commctrl.h>
#include <windows.h>
#include <windowsx.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "winreg.h"
#include "tchar.h"
#include "oohg.h"

#ifdef HB_ITEM_NIL
   #define hb_dynsymSymbol( pDynSym )        ( ( pDynSym )->pSymbol )
#endif

static PHB_SYMB *s_Symbols = NULL;

static char *s_SymbolNames[] = { "EVENTS_NOTIFY",
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
                                 "EVENTS_MEASUREITEM",
                                 "FONTHANDLE",
                                 "TWINDOW",
                                 "WNDPROC",
                                 "OVERWNDPROC",
                                 "HWNDCLIENT",
                                 "REFRESH",
                                 "AUXHANDLE",
                                 "CONTAINERCOL",
                                 "CONTAINERROW",
                                 "LRTL",
                                 "WIDTH",
                                 "HEIGHT",
                                 "VSCROLL",
                                 "SCROLLBUTTON",
                                 "VISIBLE",
                                 "EVENTS_HSCROLL",
                                 "EVENTS_VSCROLL",
                                 "NTEXTHEIGHT",
                                 "EVENTS_ENTER",
                                 "ID",
                                 "NESTEDCLICK",
                                 "_NESTEDCLICK",
                                 "TINTERNAL",
                                 "_CONTEXTMENU",
                                 "RELEASE",
                                 "ACTIVATE",
                                 "OOLE",
                                 "RANGEHEIGHT",
                                 "ONRCLICK",
                                 "ONMCLICK",
                                 "ONDBLCLICK",
                                 "ONRDBLCLICK",
                                 "ONMDBLCLICK",
                                 "ONDROPFILES",
                                 "LADJUSTIMAGES",
                                 "ASELCOLOR",
                                 "TABHANDLE",
                                 "ITEMENABLED",
                                 "HANDLETOITEM",
                                 "GRIDSELECTEDCOLORS",
                                 "TEDIT",
                                 "OBKGRND",
                                 "AEXCLUDEAREA",
                                 "COMPAREITEMS",
                                 "EVENTS_DRAG",
                                 "EVENTS_MENUHILITED",
                                 "EVENTS_INITMENUPOPUP",
                                 "OMENU",
                                 "EVENTS_TIMEOUT",
                                 "RANGEWIDTH",
                                 "LastSymbol" };

void _OOHG_Send( PHB_ITEM pSelf, int iSymbol )
{
   if( ! s_Symbols )
   {
      s_Symbols = (PHB_SYMB *) hb_xgrab( sizeof( PHB_SYMB ) * s_LastSymbol );
      memset( s_Symbols, 0, sizeof( PHB_SYMB ) * s_LastSymbol );
   }

   if( ! s_Symbols[ iSymbol ] )
   {
      s_Symbols[ iSymbol ] = hb_dynsymSymbol( hb_dynsymFind( s_SymbolNames[ iSymbol ] ) );
   }

   hb_vmPushSymbol( s_Symbols[ iSymbol ] );
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

   if( hb_arrayLen( pArray ) < 1 )
   {
      hb_arraySize( pArray, 1 );
   }

   if( ! HB_IS_STRING( hb_arrayGetItemPtr( pArray, 1 ) ) || hb_arrayGetCLen( pArray, 1 ) < _OOHG_Struct_Size )
   {
      pString = (char *) hb_xgrab( _OOHG_Struct_Size );

      // Initializes...
      memset( pString, 0, _OOHG_Struct_Size );
      ( ( POCTRL ) pString )->lFontColor = -1;
      ( ( POCTRL ) pString )->lBackColor = -1;
      ( ( POCTRL ) pString )->lUseBackColor = -1;
      ( ( POCTRL ) pString )->lOldBackColor = -1;

      if( HB_IS_STRING( hb_arrayGetItemPtr( pArray, 1 ) ) && hb_arrayGetCLen( pArray, 1 ) )
      {
         memcpy( pString, hb_arrayGetCPtr( pArray, 1 ), hb_arrayGetCLen( pArray, 1 ) );
      }
      hb_itemPutCL( hb_arrayGetItemPtr( pArray, 1 ), pString, _OOHG_Struct_Size );
      hb_xfree( pString );
   }

   pString = ( char * ) HB_UNCONST( hb_arrayGetCPtr( pArray, 1 ) );

   if( bRelease )
   {
      hb_itemRelease( pArray );
   }

   return ( POCTRL ) pString;
}

void _OOHG_DoEvent( PHB_ITEM pSelf, int iSymbol, char *cType, PHB_ITEM pArray )
{
   PHB_ITEM pSelf2;

   pSelf2 = hb_itemNew( NULL );
   hb_itemCopy( pSelf2, pSelf );
   _OOHG_Send( pSelf2, iSymbol );
   hb_vmSend( 0 );
   _OOHG_Send( pSelf2, s_DoEvent );
   hb_vmPush( hb_param( -1, HB_IT_ANY ) );
   hb_vmPushString( cType, strlen( cType ) );
   if( pArray && HB_IS_ARRAY( pArray ) )
   {
      hb_vmPush( pArray );
      hb_vmSend( 3 );
   }
   else
   {
      hb_vmSend( 2 );
   }
   hb_itemRelease( pSelf2 );
}

void _OOHG_DoEventMouseCoords( PHB_ITEM pSelf, int iSymbol, char *cType, LPARAM lParam )
{
   PHB_ITEM pArray;

   pArray = hb_itemArrayNew( 2 );
   hb_arraySetNI( pArray, 1, GET_Y_LPARAM( lParam ) );
   hb_arraySetNI( pArray, 2, GET_X_LPARAM( lParam ) );

   _OOHG_DoEvent( pSelf, iSymbol, cType, pArray );

   hb_itemRelease( pArray );
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
      else if( HB_IS_ARRAY( pColor ) && hb_arrayLen( pColor ) >= 3 &&
               HB_IS_NUMERIC( hb_arrayGetItemPtr( pColor, 1 ) ) &&
               HB_IS_NUMERIC( hb_arrayGetItemPtr( pColor, 2 ) ) &&
               HB_IS_NUMERIC( hb_arrayGetItemPtr( pColor, 3 ) ) &&
               HB_ARRAYGETNL( pColor, 1 ) != -1 )
      {
         *lColor = RGB( HB_ARRAYGETNL( pColor, 1 ), HB_ARRAYGETNL( pColor, 2 ), HB_ARRAYGETNL( pColor, 3 ) );
         bValid = 1;
      }
      else if( HB_IS_STRING( pColor ) && hb_itemGetCLen( pColor ) >= 3 )
      {
         *lColor = RGB( hb_itemGetCPtr( pColor )[ 0 ],
                        hb_itemGetCPtr( pColor )[ 1 ],
                        hb_itemGetCPtr( pColor )[ 2 ] );
         bValid = 1;
      }
   }

   return bValid;
}

BOOL _OOHG_DetermineColorReturn( PHB_ITEM pColor, LONG *lColor, BOOL fUpdate )
{
   if( fUpdate )
   {
      *lColor = -1;
      _OOHG_DetermineColor( pColor, lColor );
   }

   if( *lColor != -1 )
   {
      hb_reta( 3 );
      HB_STORNL3( GetRValue( *lColor ), -1, 1 );
      HB_STORNL3( GetGValue( *lColor ), -1, 2 );
      HB_STORNL3( GetBValue( *lColor ), -1, 3 );
   }
   else
   {
      hb_ret();
   }

   return fUpdate;
}

HB_FUNC( DELETEOBJECT )
{
   hb_retl( DeleteObject( (HGDIOBJ) HWNDparam( 1 ) ) );
}

HB_FUNC( CSHOWCONTROL )
{
   ShowWindow( HWNDparam( 1 ), SW_SHOW );
}

HB_FUNC( HIDEWINDOW )
{
   ShowWindow( HWNDparam( 1 ), SW_HIDE );
}

HB_FUNC( CHECKDLGBUTTON )
{
   CheckDlgButton( HWNDparam( 2 ), hb_parni( 1 ), BST_CHECKED );
}

HB_FUNC( UNCHECKDLGBUTTON )
{
   CheckDlgButton( HWNDparam( 2 ), hb_parni( 1 ), BST_UNCHECKED );
}

HB_FUNC( SETDLGITEMTEXT )
{
   SetDlgItemText( HWNDparam( 3 ), hb_parni( 1 ), (LPCTSTR) hb_parc( 2 ) );
}

HB_FUNC( SETFOCUS )
{
   HWNDret( SetFocus( HWNDparam( 1 ) ) );
}

HB_FUNC( GETDLGITEMTEXT )
{
   USHORT iLen = 32768;
   char *cText = (char*) hb_xgrab( iLen+1 );

   GetDlgItemText(
        HWNDparam( 2 ),    // handle of dialog box
   hb_parni(1),      // identifier of control
   (LPTSTR) cText,         // address of buffer for text
   iLen                    // maximum size of string
   );

   hb_retc( cText );
   hb_xfree( cText );
}

HB_FUNC( ISDLGBUTTONCHECKED )
{
   hb_retl( ( IsDlgButtonChecked( HWNDparam( 2 ), hb_parni( 1 ) ) == BST_CHECKED ) );
}

HB_FUNC( SETSPINNERVALUE )
{
   SendMessage( HWNDparam( 1 ),
      (UINT)UDM_SETPOS32 ,
      (WPARAM)0,
      (LPARAM) (INT) hb_parni (2)
      ) ;
}

HB_FUNC( GETSPINNERVALUE )
{
   hb_retnl(
             SendMessage( HWNDparam( 1 ),
                          ( UINT ) UDM_GETPOS32,
                          ( WPARAM ) 0,
                          ( LPARAM ) 0 )
           );
}

HB_FUNC( INSERTTAB )
{
   keybd_event(
      VK_TAB,          // virtual-key code
      0,               // hardware scan code
      0,               // flags specifying various function options
      0                // additional data associated with keystroke
   );
}

HB_FUNC( INSERTSHIFTTAB )
{
   keybd_event(
      VK_SHIFT,        // virtual-key code
      0,               // hardware scan code
      0,               // flags specifying various function options
      0                // additional data associated with keystroke
   );

   keybd_event(
      VK_TAB,          // virtual-key code
      0,               // hardware scan code
      0,               // flags specifying various function options
      0                // additional data associated with keystroke
   );

   keybd_event(
      VK_SHIFT,        // virtual-key code
      0,               // hardware scan code
      KEYEVENTF_KEYUP, // flags specifying various function options
      0                // additional data associated with keystroke
   );
}

HB_FUNC( RELEASECONTROL )
{
   SendMessage( HWNDparam( 1 ), WM_SYSCOMMAND, SC_CLOSE, 0 );
}

HB_FUNC( INSERTBACKSPACE )
{
   keybd_event(
      VK_BACK,         // virtual-key code
      0,               // hardware scan code
      0,               // flags specifying various function options
      0                // additional data associated with keystroke
   );
}

HB_FUNC( INSERTPOINT )
{
   keybd_event(
      VK_DECIMAL,      // virtual-key code
      0,               // hardware scan code
      0,               // flags specifying various function options
      0                // additional data associated with keystroke
   );
}

HB_FUNC( GETMODULEFILENAME )
{
   BYTE bBuffer[ MAX_PATH + 1 ] = { 0 } ;

   GetModuleFileName( ( HMODULE ) HWNDparam( 1 ), ( char * ) bBuffer, 249 );
   hb_retc( ( char * ) bBuffer );
}

HB_FUNC( SETCURSORPOS )
{
   SetCursorPos( hb_parni( 1 ), hb_parni( 2 ) );
}

HB_FUNC( SHOWCURSOR )
{
   hb_retni( ShowCursor( hb_parl( 1 ) ) );
}

HB_FUNC( SYSTEMPARAMETERSINFO )
{
   if( SystemParametersInfoA( (UINT) hb_parni( 1 ),
                              (UINT) hb_parni( 2 ),
                              (VOID *) HB_UNCONST( hb_parc( 3 ) ),
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
   HDC   hDC = ( HDC ) HB_PARNL( 1 );
   HWND  hWnd = 0;
   BOOL  bDestroyDC = FALSE;
   HFONT hFont = ( HFONT ) HB_PARNL( 3 );
   HFONT hOldFont = 0;
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

HB_FUNC( GETTEXTHEIGHT )  // returns the height of a string in pixels
{
   HDC   hDC = ( HDC ) HB_PARNL( 1 );
   HWND  hWnd = 0;
   BOOL  bDestroyDC = FALSE;
   HFONT hFont = ( HFONT ) HB_PARNL( 3 );
   HFONT hOldFont = 0;
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

HB_FUNC( KEYBD_EVENT )
{
   keybd_event(
      ( BYTE ) hb_parni( 1 ),                       // virtual-key code
      ( BYTE ) MapVirtualKey( hb_parni( 1 ), 0 ),   // hardware scan code
      hb_parl( 2 ) ? KEYEVENTF_KEYUP : 0,           // flags specifying various function options
      0                                             // additional data associated with keystroke
   );
}

HB_FUNC( INSERTRETURN )
{

   keybd_event(
      VK_RETURN,                                    // virtual-key code
      0,                                            // hardware scan code
      0,                                            // flags specifying various function options
      0                                             // additional data associated with keystroke
   );
}

#ifndef VK_A
   #define VK_A 65
#endif

HB_FUNC( INSERT_ALT_A )
{
   keybd_event(
      VK_MENU,                                      // virtual-key code
      0,                                            // hardware scan code
      0,                                            // flags specifying various function options
      0                                             // additional data associated with keystroke
   );

   keybd_event(
      VK_A,                                         // virtual-key code
      0,                                            // hardware scan code
      0,                                            // flags specifying various function options
      0                                             // additional data associated with keystroke
   );

   keybd_event(
      VK_MENU,                                      // virtual-key code
      0,                                            // hardware scan code
      KEYEVENTF_KEYUP,                              // flags specifying various function options
      0                                             // additional data associated with keystroke
   );
}

HB_FUNC( INSERTUP )
{
   keybd_event(
      VK_UP,                                        // virtual-key code
      0,                                            // hardware scan code
      0,                                            // flags specifying various function options
      0                                             // additional data associated with keystroke
   );
}

HB_FUNC( INSERTDOWN )
{
   keybd_event(
      VK_DOWN,                                      // virtual-key code
      0,                                            // hardware scan code
      0,                                            // flags specifying various function options
      0                                             // additional data associated with keystroke
   );
}

HB_FUNC( INSERTPRIOR )
{
   keybd_event(
      VK_PRIOR,                                     // virtual-key code
      0,                                            // hardware scan code
      0,                                            // flags specifying various function options
      0                                             // additional data associated with keystroke
   );
}

HB_FUNC( INSERTNEXT )
{
   keybd_event(
      VK_NEXT,                                      // virtual-key code
      0,                                            // hardware scan code
      0,                                            // flags specifying various function options
      0                                             // additional data associated with keystroke
   );
}

HB_FUNC( GETSHOWCMD )
{

   WINDOWPLACEMENT WP;
   HWND h;
        int i;

    h = HWNDparam( 1 );

   WP.length = sizeof(WINDOWPLACEMENT) ;

    GetWindowPlacement( h, &WP ) ;

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
   BITMAP bm;
   PHB_ITEM hArray;
   char *caption;
   int iLen, s, cx = 0, cy = 0, iStyle;
   COLORREF clrDefault;

   iLen = hb_parinfa( 1, 0 );
   hArray = hb_param( 1, HB_IT_ARRAY );
   if( iLen != 0 )
   {
      clrDefault = ( COLORREF ) hb_parni( 2 );
      iStyle = hb_parni( 3 );

      for( s = 1; s <= iLen; s++ )
      {
         caption = ( char * ) HB_UNCONST( hb_arrayGetCPtr( hArray, s ) );

         hbmp = ( HBITMAP ) LoadImage( GetModuleHandle( NULL ), caption, IMAGE_BITMAP, 0, 0, iStyle );
         if( hbmp == NULL )
         {
            hbmp = ( HBITMAP ) LoadImage( GetModuleHandle( NULL ), caption, IMAGE_BITMAP, 0, 0, iStyle | LR_LOADFROMFILE );
         }

         if( hbmp )
         {
            if( ! himl )
            {
               GetObject( hbmp, sizeof( bm ), &bm );
               cx = bm.bmWidth;
               cy = bm.bmHeight;
               himl = ImageList_Create( cx, cy, ILC_COLOR32 | ILC_MASK, 16, 16 );
            }

            if( clrDefault == CLR_NONE )
            {
               ImageList_Add( himl, hbmp, NULL );
            }
            else
            {
               ImageList_AddMasked( himl, hbmp, clrDefault );
            }
            DeleteObject( hbmp );
         }
      }
   }

   hb_reta( 3 );
   HB_STORVNL( ( LONG_PTR ) himl, -1, 1 );
   HB_STORNI( cx, -1, 2 );
   HB_STORNI( cy, -1, 3 );
}

HB_FUNC( IMAGELIST_DESTROY )
{
   hb_retl( ImageList_Destroy( ( HIMAGELIST ) HB_PARNL( 1 ) ) );
}

HB_FUNC( IMAGELIST_ADD )
{
   HIMAGELIST himl = ( HIMAGELIST ) HWNDparam( 1 );
   HBITMAP hbmp;
   int cx, cy, ic = 0;
   int iStyle = hb_parni( 3 );
   COLORREF clrDefault = ( COLORREF ) hb_parni( 4 );

   if( himl )
   {
      ImageList_GetIconSize( himl, &cx, &cy );

      hbmp = ( HBITMAP ) LoadImage( GetModuleHandle( NULL ), hb_parc( 2 ), IMAGE_BITMAP, cx, cy, iStyle );
      if( ! hbmp )
      {
         hbmp = ( HBITMAP ) LoadImage( GetModuleHandle( NULL ), hb_parc( 2 ), IMAGE_BITMAP, cx, cy, iStyle | LR_LOADFROMFILE );
      }

      if( hbmp )
      {
         ImageList_AddMasked( himl, hbmp, clrDefault );
         DeleteObject( hbmp );
      }

      ic = ImageList_GetImageCount( himl );
   }

   hb_retni( ic );
}

HB_FUNC( IMAGELIST_GETIMAGECOUNT )
{
   hb_retni( ImageList_GetImageCount( ( HIMAGELIST ) HWNDparam( 1 ) ) );
}

HB_FUNC( IMAGELIST_DUPLICATE )
{
   HWNDret( ImageList_Duplicate( ( HIMAGELIST ) HWNDparam( 1 ) ) );
}

HB_FUNC( IMAGELIST_SIZE )
{
   HIMAGELIST himl = ( HIMAGELIST ) HWNDparam( 1 ) ;
   int cx, cy ;

   if( himl )
   {
      ImageList_GetIconSize( himl, &cx, &cy );
   }
   else
   {
      cx = 0 ;
      cy = 0 ;
   }

   hb_reta( 2 );
   HB_STORNI( ( int )  cx,   -1, 1 );
   HB_STORNI( ( int )  cy,   -1, 2 );
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
   else if( pString && HB_IS_ARRAY( pString ) && hb_arrayLen( pString ) > 0 )
   {
      pResult->cString = hb_arrayGetC( pString, 1 );
      if( hb_arrayLen( pString ) > 1 && HB_IS_NUMERIC( hb_arrayGetItemPtr( pString, 2 ) ) )
      {
         pResult->iImage1 = hb_arrayGetNI( pString, 2 );
         if( hb_arrayLen( pString ) > 2 && HB_IS_NUMERIC( hb_arrayGetItemPtr( pString, 3 ) ) )
         {
            pResult->iImage2 = hb_arrayGetNI( pString, 3 );
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

// Thread safe, see _OOHG_INIT_C_VARS_CONTROLS_C_SIDE, GetControlObjectByHandle(), _OOHG_GetExistingObject() and GetControlObjectById()
static PHB_SYMB _ooHG_Symbol_TControl = 0;
static PHB_ITEM _OOHG_aControlhWnd, _OOHG_aControlObjects, _OOHG_aControlIds;

HB_FUNC( _OOHG_INIT_C_VARS_CONTROLS_C_SIDE )
{
   // See _OOHG_Init_C_Vars_Controls() at h_controlmisc.prg
   _ooHG_Symbol_TControl = hb_dynsymSymbol( hb_dynsymFind( "TCONTROL" ) );
   _OOHG_aControlhWnd    = hb_itemNew( NULL );
   _OOHG_aControlObjects = hb_itemNew( NULL );
   _OOHG_aControlIds     = hb_itemNew( NULL );
   hb_itemCopy( _OOHG_aControlhWnd,    hb_param( 1, HB_IT_ARRAY ) );
   hb_itemCopy( _OOHG_aControlObjects, hb_param( 2, HB_IT_ARRAY ) );
   hb_itemCopy( _OOHG_aControlIds,     hb_param( 3, HB_IT_ARRAY ) );
}

int _OOHG_SearchControlHandleInArray( HWND hWnd )
{
/*
 * This function must be called enclosed between
 * WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
 * and ReleaseMutex( _OOHG_GlobalMutex() ); calls.
 * See GetControlObjectByHandle() and _OOHG_GetExistingObject().
 */
   ULONG ulCount, ulPos = 0;

   if( ! _ooHG_Symbol_TControl )
   {
      hb_vmPushSymbol( hb_dynsymSymbol( hb_dynsymFind( "_OOHG_INIT_C_VARS_CONTROLS" ) ) );
      hb_vmPushNil();
      hb_vmDo( 0 );
   }

   for( ulCount = 1; ulCount <= hb_arrayLen( _OOHG_aControlhWnd ); ulCount++ )
   {
      #ifdef OOHG_HWND_POINTER
         if( hWnd == ( HWND ) hb_arrayGetPtr( _OOHG_aControlhWnd, ulCount ) )
      #else
         if( hWnd == ( HWND ) HB_ARRAYGETNL( _OOHG_aControlhWnd, ulCount ) )
      #endif
      {
         ulPos = ulCount;
         ulCount = hb_arrayLen( _OOHG_aControlhWnd );
      }
   }

   return ulPos;
}

PHB_ITEM GetControlObjectByHandle( HWND hWnd, BOOL bMutex )
{
   PHB_ITEM pControl;
   ULONG ulPos;

   if( bMutex )
      WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );

   ulPos = _OOHG_SearchControlHandleInArray( hWnd );
   if( ulPos )
   {
      pControl = hb_arrayGetItemPtr( _OOHG_aControlObjects, ulPos );
   }
   else
   {
      hb_vmPushSymbol( _ooHG_Symbol_TControl );
      hb_vmPushNil();
      hb_vmDo( 0 );
      pControl = hb_param( -1, HB_IT_ANY );
   }

   if( bMutex )
      ReleaseMutex( _OOHG_GlobalMutex() );

   return pControl;
}

HB_FUNC( GETCONTROLOBJECTBYHANDLE )
{
   PHB_ITEM pReturn;

   pReturn = hb_itemNew( NULL );
   hb_itemCopy( pReturn, GetControlObjectByHandle( HWNDparam( 1 ), TRUE ) );

   hb_itemReturn( pReturn );
   hb_itemRelease( pReturn );
}

PHB_ITEM GetControlObjectById( LONG lId, HWND hWnd )
{
   PHB_ITEM pControl;
   ULONG ulCount;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( ! _ooHG_Symbol_TControl )
   {
      hb_vmPushSymbol( hb_dynsymSymbol( hb_dynsymFind( "_OOHG_INIT_C_VARS_CONTROLS" ) ) );
      hb_vmPushNil();
      hb_vmDo( 0 );
   }

   pControl = NULL;
   if( lId )
   {
      for( ulCount = 1; ulCount <= hb_arrayLen( _OOHG_aControlIds ); ulCount++ )
      {
         if( lId  == HB_ARRAYGETNL( hb_arrayGetItemPtr( _OOHG_aControlIds, ulCount ), 1 ) &&
             hWnd ==
#ifdef OOHG_HWND_POINTER
                     hb_arrayGetPtr( hb_arrayGetItemPtr( _OOHG_aControlIds, ulCount ), 2 )
#else
                     ( HWND ) HB_ARRAYGETNL( hb_arrayGetItemPtr( _OOHG_aControlIds, ulCount ), 2 )
#endif
           )
         {
            pControl = hb_arrayGetItemPtr( _OOHG_aControlObjects, ulCount );
            ulCount = hb_arrayLen( _OOHG_aControlIds );
         }
      }
   }
   if( ! pControl )
   {
      hb_vmPushSymbol( _ooHG_Symbol_TControl );
      hb_vmPushNil();
      hb_vmDo( 0 );
      pControl = hb_param( -1, HB_IT_ANY );
   }
   ReleaseMutex( _OOHG_GlobalMutex() );

   return pControl;
}

HB_FUNC( GETCONTROLOBJECTBYID )
{
   PHB_ITEM pReturn;

   pReturn = hb_itemNew( NULL );
   hb_itemCopy( pReturn, GetControlObjectById( hb_parnl( 1 ), HWNDparam( 2 ) ) );

   hb_itemReturn( pReturn );
   hb_itemRelease( pReturn );
}

HB_FUNC( SETCLIPBOARDTEXT )
{
   HGLOBAL hglbCopy;
   LPTSTR lptstrCopy;
   int nLen = hb_parclen( 1 );

   if( OpenClipboard( NULL ) )
   {
      EmptyClipboard();

      hglbCopy = GlobalAlloc( GMEM_DDESHARE, (nLen+1) * sizeof(TCHAR) );
      if (hglbCopy != NULL)
      {
         lptstrCopy = (LPTSTR) GlobalLock( hglbCopy );
         memcpy( lptstrCopy, hb_parc( 1 ), nLen * sizeof(TCHAR));
         lptstrCopy[nLen] = (TCHAR) 0;
         GlobalUnlock(hglbCopy);

         SetClipboardData( CF_TEXT, hglbCopy );
      }

      CloseClipboard();
   }
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
         cString = (LPSTR) GlobalLock( hClip );
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

HB_FUNC( GETPARENT )
{
   HWNDret( GetParent( HWNDparam( 1 ) ) );
}

HB_FUNC( GETDLGCTRLID )
{
   hb_retnl( GetDlgCtrlID( HWNDparam( 1 ) ) );
}

void SetDragCursorARROW( BOOL isCtrlKeyDown )
{
   if( isCtrlKeyDown )
   {
      SetCursor( LoadCursor( GetModuleHandle(NULL), "DRAG_ARROW_COPY" ) );
   }
   else
   {
      SetCursor( LoadCursor( GetModuleHandle(NULL), "DRAG_ARROW_MOVE" ) );
   }
}

HB_FUNC( GENERIC_ONMOUSEDRAG )
{
   POINT pnt;

   /* get the current position of the mouse pointer in screen coordinates and drag the image there */
   GetCursorPos( &pnt );
   if( ImageList_DragMove( pnt.x, pnt.y ) )
   {
      /* set drag cursor */
      SetDragCursorARROW( ( ( (WPARAM) hb_parnl( 1 ) & MK_CONTROL) == MK_CONTROL ) );

      /* hide the dragged image so the background can be refreshed */
      ImageList_DragShowNolock( FALSE );

      /* show the drag image */
      ImageList_DragShowNolock( TRUE );
   }
}
