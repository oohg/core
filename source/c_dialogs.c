/*
 * $Id: c_dialogs.c $
 */
/*
 * ooHG source code:
 * Dialog related functions
 *
 * Copyright 2005-2020 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2020 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2020 Contributors, https://harbour.github.io/
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
#include <tchar.h>

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( CHOOSEFONT )
{
   CHOOSEFONT cf;
   LOGFONT lf;
   long PointSize;
   int bold;
   HDC hdc;
   HWND hWnd;

   strcpy( lf.lfFaceName, hb_parc( 1 ) );

   hWnd = GetActiveWindow();
   hdc = GetDC( hWnd );

   lf.lfHeight = - MulDiv( hb_parnl( 2 ), GetDeviceCaps( hdc, LOGPIXELSY ), 72 );

   if( hb_parl( 3 ) )
   {
      lf.lfWeight = 700;
   }
   else
   {
      lf.lfWeight = 400;
   }

   if( hb_parl( 4 ) )
   {
      lf.lfItalic = TRUE;
   }
   else
   {
      lf.lfItalic = FALSE;
   }

   if( hb_parl( 6 ) )
   {
       lf.lfUnderline = TRUE;
   }
   else
   {
       lf.lfUnderline = FALSE;
   }

   if( hb_parl( 7 ) )
   {
       lf.lfStrikeOut = TRUE;
   }
   else
   {
       lf.lfStrikeOut = FALSE;
   }

   lf.lfCharSet = (BYTE) hb_parni( 8 );

   cf.lStructSize = sizeof( CHOOSEFONT );
   cf.hwndOwner = hWnd;
   cf.hDC = (HDC) NULL;
   cf.lpLogFont = &lf;
   cf.Flags = CF_SCREENFONTS | CF_EFFECTS | CF_INITTOLOGFONTSTRUCT;
   cf.rgbColors = (COLORREF) hb_parnl( 5 );
   cf.lCustData = 0L;
   cf.lpfnHook = ( LPCFHOOKPROC ) NULL;
   cf.lpTemplateName = (LPSTR) NULL;
   cf.hInstance = (HINSTANCE) NULL;
   cf.lpszStyle = (LPSTR) NULL;
   cf.nFontType = SCREEN_FONTTYPE;
   cf.nSizeMin = 0;
   cf.nSizeMax = 0;

   if( ! ChooseFont( &cf ) )
   {
      hb_reta( 8 );
      HB_STORC( "", -1, 1 );
      HB_STORNL3( 0, -1, 2 );
      HB_STORL( 0, -1, 3 );
      HB_STORL( 0, -1, 4 );
      HB_STORNL3( 0, -1, 5 );
      HB_STORL( 0, -1, 6 );
      HB_STORL( 0, -1, 7 );
      HB_STORNI( 0, -1, 8 );
      return;
   }

   PointSize = - MulDiv( lf.lfHeight, 72, GetDeviceCaps( hdc, LOGPIXELSY ) );

   if( lf.lfWeight == 700 )
   {
      bold = 1;
   }
   else
   {
      bold = 0;
   }

   hb_reta( 8 );
   HB_STORC( lf.lfFaceName, -1, 1 );
   HB_STORNL3( (long) PointSize, -1, 2 );
   HB_STORL( bold, -1, 3 );
   HB_STORL( lf.lfItalic, -1, 4 );
   HB_STORNL3( (long) cf.rgbColors, -1, 5 );
   HB_STORL( lf.lfUnderline, -1, 6 );
   HB_STORL( lf.lfStrikeOut, -1, 7 );
   HB_STORNI( lf.lfCharSet, -1, 8 );

   ReleaseDC( hWnd, hdc );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( C_GETFILE )
{
   OPENFILENAME ofn;
   char buffer[ 32768 ];
   char cFullName[ 64 ][ 1024 ];
   char cCurDir[ 512 ];
   char cFileName[ 512 ];
   int iPosition = 0;
   int iNumSelected = 0;
   int n;
   DWORD flags = OFN_FILEMUSTEXIST;

   if( HB_ISCHAR( 6 ) )
   {
      strcpy( buffer, hb_parc( 6 ) );
   }
   else
   {
      * buffer = 0;
   }

   if( hb_parl( 4 ) )
   {
      flags = flags | OFN_ALLOWMULTISELECT | OFN_EXPLORER;
   }
   if( hb_parl( 5 ) )
   {
      flags = flags | OFN_NOCHANGEDIR;
   }
   if( hb_parl( 7 ) )
   {
      flags = flags | OFN_HIDEREADONLY;
   }

   memset( (void *) &ofn, 0, sizeof( OPENFILENAME ) );
   ofn.lStructSize = sizeof( ofn );
   ofn.hwndOwner = GetActiveWindow();
   ofn.lpstrFilter = hb_parc( 1 );
   ofn.nFilterIndex = 1;
   ofn.lpstrFile = buffer;
   ofn.nMaxFile = sizeof( buffer );
   ofn.lpstrInitialDir = hb_parc( 3 );
   ofn.lpstrTitle = hb_parc( 2 );
   ofn.nMaxFileTitle = 512;
   ofn.Flags = flags;

   if( GetOpenFileName( &ofn ) )
   {
      if( ofn.nFileExtension != 0 )
      {
         hb_retc( ofn.lpstrFile );
      }
      else
      {
         wsprintf( cCurDir, "%s", &buffer[ iPosition ] );
         iPosition = iPosition + (int) strlen( cCurDir ) + 1;

         do
         {
            iNumSelected++;
            wsprintf( cFileName, "%s", &buffer[ iPosition ] );
            iPosition = iPosition + (int) strlen( cFileName ) + 1;
            wsprintf( cFullName[ iNumSelected ], "%s\\%s", cCurDir, cFileName );
         }
         while( ( strlen( cFileName ) != 0) && ( iNumSelected <= 63 ) );

         if( iNumSelected > 1 )
         {
            hb_reta( ( HB_SIZE ) ( iNumSelected - 1 ) );

            for( n = 1; n < iNumSelected; n++ )
            {
               HB_STORC( cFullName[ n ], -1, n );
            }
         }
         else
         {
            hb_retc( &buffer[ 0 ] );
         }
      }
   }
   else
   {
      hb_retc( "" );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( C_PUTFILE )
{
   OPENFILENAME ofn;
   char buffer[ 512 ];
   char cExt[ 4 ];
   DWORD flags = OFN_FILEMUSTEXIST | OFN_EXPLORER;

   if( hb_parl( 4 ) )
   {
      flags = flags | OFN_NOCHANGEDIR;
   }

   if( HB_ISCHAR( 5 ) )
   {
      strcpy( buffer, hb_parc( 5 ) );
   }
   else
   {
      strcpy( buffer, "" );
   }

   memset( (void *) &ofn, 0, sizeof( OPENFILENAME ) );
   ofn.lStructSize = sizeof( ofn );
   ofn.hwndOwner = GetActiveWindow();
   ofn.lpstrFilter = hb_parc( 1 );
   ofn.lpstrFile = buffer;
   ofn.nMaxFile = 512;
   ofn.lpstrInitialDir = hb_parc( 3 );
   ofn.lpstrTitle = hb_parc( 2 );
   ofn.Flags = flags;

   if( hb_parl( 6 ) )
   {
      strcpy( cExt, "" );
      ofn.lpstrDefExt = cExt;
   }

   if( GetSaveFileName( &ofn ) )
   {
      if( hb_parl( 6 ) && ofn.nFileExtension == 0 )
      {
         ofn.lpstrFile = strcat( ofn.lpstrFile, "." );
         ofn.lpstrFile = strcat( ofn.lpstrFile, ofn.lpstrDefExt );
      }

      hb_retc( ofn.lpstrFile );
   }
   else
   {
      hb_retc( "" );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
int CALLBACK BrowseCallbackProc( HWND hWnd, UINT uMsg, LPARAM lParam, LPARAM lpData )
{
   if( uMsg == BFFM_INITIALIZED && lParam == 0 )
   {
      SendMessage( hWnd, BFFM_SETSELECTION, TRUE, lpData );
   }
   return 0;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( C_BROWSEFORFOLDER )          /* FUNCTION C_BrowseForFolder( [<hWnd>], [<cTitle>], <nFlags>, [<nFolderType>], [<cInitPath>] ) -> cPath */
{
   HWND hWnd;
   BROWSEINFO BrowseInfo;
   char * lpBuffer = (char *) hb_xgrab( MAX_PATH + 1 );
   LPITEMIDLIST pidlBrowse;

   hWnd = HWNDparam( 1 );
   if( ! ValidHandler( hWnd ) )
   {
      hWnd = GetActiveWindow();
   }

   SHGetSpecialFolderLocation( hWnd, HB_ISNIL( 4 ) ? CSIDL_DRIVES : hb_parni( 4 ), &pidlBrowse );
   BrowseInfo.hwndOwner = hWnd;
   BrowseInfo.pidlRoot = pidlBrowse;
   BrowseInfo.pszDisplayName = lpBuffer;
   BrowseInfo.lpszTitle = HB_ISNIL( 2 ) ? "Select a Folder" : hb_parc( 2 );
   BrowseInfo.ulFlags = (UINT) ( HB_ISNIL( 3 ) ? 0 : hb_parni( 3 ) );
   BrowseInfo.lpfn = ( BFFCALLBACK ) ( HB_ISCHAR( 5 ) ? BrowseCallbackProc : NULL );
   BrowseInfo.lParam = HB_ISCHAR( 5 ) ? (LPARAM) HB_UNCONST( hb_parc( 5 ) ) : 1;
   BrowseInfo.iImage = 0;
   pidlBrowse = SHBrowseForFolder( &BrowseInfo );

   if( pidlBrowse )
   {
     SHGetPathFromIDList( pidlBrowse, lpBuffer );
     hb_retc( lpBuffer );
   }
   else
   {
     hb_retc( "" );
   }

   hb_xfree( lpBuffer );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( CHOOSECOLOR )
{
   int i;
   CHOOSECOLOR cc;
   static BOOL bFirst = TRUE;
   static COLORREF crCustClr[ 16 ];

   if( bFirst )
   {
      for( i = 0; i < 16; i++ )
      {
         crCustClr[ i ] = GetSysColor( COLOR_BTNFACE );
      }
      bFirst = FALSE;
   }

   if( HB_ISARRAY( 3 ) )
   {
      for( i = 0; i < 16; i++ )
      {
         if( HB_PARVNL( 3, i + 1 ) > 0 )
         {
            crCustClr[ i ] = (COLORREF) HB_PARVNL( 3, i + 1 );
         }
      }
   }

   ZeroMemory( &cc, sizeof( cc ) );
   cc.lStructSize  = sizeof( cc );
   cc.hwndOwner    = HB_ISNIL( 1 ) ? GetActiveWindow() : HWNDparam( 1 );
   cc.rgbResult    = (COLORREF) ( HB_ISNIL( 2 ) ?  0 : hb_parnl( 2 ) );
   cc.lpCustColors = crCustClr;
   cc.Flags        = (WORD) ( HB_ISNIL( 4 ) ? CC_ANYCOLOR | CC_FULLOPEN | CC_RGBINIT : hb_parnl( 4 ) );

   if( ChooseColorA( &cc ) )
   {
      if( HB_ISARRAY( 3 ) )
      {
         for( i = 0; i < 16; i++ )
         {
            HB_STORNL3( (long) crCustClr[ i ], 3, i + 1 );
         }
      }
      hb_retnl( (long) cc.rgbResult );
   }
   else
   {
      hb_retnl( - 1 );
   }
}
