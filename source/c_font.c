/*
 * $Id: c_font.c $
 */
/*
 * OOHG source code:
 * Font related functions
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
#include "hbapiitm.h"

/*--------------------------------------------------------------------------------------------------------------------------------*/
HFONT PrepareFont( const char * FontName, int FontSize, int Weight, int Italic, int Underline, int StrikeOut, int Escapement, int Charset, int Width, int Orientation, int Advanced )
{
   HDC hDC;
   int cyp, nEscapement, nOrientation, nHeight, nWidth, nWeight;
   DWORD dwItalic, dwUnderline, dwStrikeOut, dwCharSet, dwOutputPrecision, dwClipPrecision, dwQuality, dwPitchAndFamily;
   LPCTSTR lpszFace;

   hDC = GetDC( HWND_DESKTOP );
   cyp = GetDeviceCaps( hDC, LOGPIXELSY );

   nEscapement = Escapement;                             /* Angle between the escapement vector and the x-axis */
   if( Advanced )
   {
      SetGraphicsMode( hDC, GM_ADVANCED );
      nOrientation = Orientation;                        /* Angle between character's base line and the x-axis */
   }
   else
   {
      SetGraphicsMode( hDC, GM_COMPATIBLE );
      nOrientation = Escapement;                         /* Angle between character's base line and the x-axis */
   }
   ReleaseDC( HWND_DESKTOP, hDC );

   nHeight           = 0 - ( FontSize * cyp ) / 72;
   nWidth            = Width;                            /* Width of characters in the requested font */
   nWeight           = Weight;                           /* Bold */
   dwItalic          = ( DWORD ) Italic;
   dwUnderline       = ( DWORD ) Underline;
   dwStrikeOut       = ( DWORD ) StrikeOut;
   dwCharSet         = ( DWORD ) Charset;
   dwOutputPrecision = ( DWORD ) OUT_TT_PRECIS;
   dwClipPrecision   = ( DWORD ) CLIP_DEFAULT_PRECIS;
   dwQuality         = ( DWORD ) DEFAULT_QUALITY;
   dwPitchAndFamily  = ( DWORD ) FF_DONTCARE;
   lpszFace          = (LPCTSTR) FontName;

   return CreateFont( nHeight, nWidth, nEscapement, nOrientation, nWeight, dwItalic, dwUnderline, dwStrikeOut,
      dwCharSet, dwOutputPrecision, dwClipPrecision, dwQuality, dwPitchAndFamily, lpszFace );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( INITFONT )          /* FUNCTION InitFont( cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout, nAngle, nCharset, nWidth, nOrientation, lAdvanced ) -> hFont */
{
   int bold        = hb_parl( 3 ) ? FW_BOLD : FW_NORMAL;
   int italic      = hb_parl( 4 ) ? 1 : 0;
   int underline   = hb_parl( 5 ) ? 1 : 0;
   int strikeout   = hb_parl( 6 ) ? 1 : 0;
   int angle       = ( HB_ISNUM( 7 ) ? hb_parni( 7 ) : 0 );
   int charset     = ( HB_ISNUM( 8 ) ? hb_parni( 8 ) : DEFAULT_CHARSET );
   int width       = ( HB_ISNUM( 9 ) ? hb_parni( 9 ) : 0 );
   int orientation = ( HB_ISNUM( 10 ) ? hb_parni( 10 ) : 0 );
   int advanced    = hb_parl( 11 ) ? 1 : 0;

   HFONT font = PrepareFont( hb_parc( 1 ), hb_parni( 2 ), bold, italic, underline, strikeout, angle, charset, width, orientation, advanced );
   HFONTret( font );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _SETFONT )          /* FUNCTION _SetFont( hWnd, cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout, nAngle, nCharset, nWidth, nOrientation, lAdvanced ) -> hFont */
{
   int bold        = hb_parl( 4 ) ? FW_BOLD : FW_NORMAL;
   int italic      = hb_parl( 5 ) ? 1 : 0;
   int underline   = hb_parl( 6 ) ? 1 : 0;
   int strikeout   = hb_parl( 7 ) ? 1 : 0;
   int angle       = ( HB_ISNUM( 8 ) ? hb_parni( 8 ) : 0 );
   int charset     = ( HB_ISNUM( 9 ) ? hb_parni( 9 ) : DEFAULT_CHARSET );
   int width       = ( HB_ISNUM( 10 ) ? hb_parni( 10 ) : 0 );
   int orientation = ( HB_ISNUM( 11 ) ? hb_parni( 11 ) : 0 );
   int advanced    = hb_parl( 12 ) ? 1 : 0;

   HFONT font = PrepareFont( hb_parc( 2 ), hb_parni( 3 ), bold, italic, underline, strikeout, angle, charset, width, orientation, advanced );
   SendMessage( HWNDparam( 1 ), (UINT) WM_SETFONT, (WPARAM) font, MAKELPARAM( TRUE, 0 ) );
   HFONTret( font );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GETSYSTEMFONT )          /* FUNCTION GetSystemFont() -> { cFontName, nSize } */
{
   LOGFONT lfDlgFont;
   NONCLIENTMETRICS ncm;
#ifdef UNICODE
   LPSTR pStr;
#endif

   ncm.cbSize = sizeof( ncm );

   /* Get metrics associated with the nonclient area of a nonminimized window */
   SystemParametersInfo( SPI_GETNONCLIENTMETRICS, sizeof( ncm ), &ncm, 0 );

   /* information about the font used in message boxes */
   lfDlgFont = ncm.lfMessageFont;

   hb_reta( 2 );
#ifndef UNICODE
   HB_STORC( lfDlgFont.lfFaceName, -1, 1 );
#else
   pStr = WideToAnsi( lfDlgFont.lfFaceName );
   HB_STORC( pStr, -1, 1 );
   hb_xfree( pStr );
#endif
   HB_STORNI( 21 + lfDlgFont.lfHeight, -1, 2 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GETSYSTEMFONTEX )
{
   NONCLIENTMETRICS ncm;
	LONG PointSize;
	INT isBold;
   LOGFONT lf;

   ncm.cbSize = sizeof( ncm );

	if ( ! SystemParametersInfo( SPI_GETNONCLIENTMETRICS, sizeof( ncm ), &ncm, 0 ) )
	{
		hb_reta( 7 );
		HB_STORC( "", -1, 1 );
		HB_STORNL3( 0, -1, 2 );
		HB_STORL( 0, -1, 3 );
		HB_STORL( 0, -1, 4 );
		HB_STORNL3( 0, -1, 5 );
		HB_STORL( 0, -1, 6 );
		HB_STORL( 0, -1, 7 );
		return;
	}

  switch( hb_parni( 1 ) )
  {
    case 1:
      /* information about the font used in message boxes */
      lf = ncm.lfMessageFont;
      break;
    case 2:
      /* information about the caption font */
      lf = ncm.lfCaptionFont;
      break;
    case 3:
      /* information about the small caption font */
      lf = ncm.lfSmCaptionFont;
      break;
    case 4:
      /* information about the font used in menu bars */
      lf = ncm.lfMenuFont;
      break;
    case 5:
      /* information about the font used in status bars and tooltips */
      lf = ncm.lfStatusFont;
      break;
   }

   PointSize = - MulDiv( lf.lfHeight, 72, GetDeviceCaps( GetDC( GetActiveWindow() ), LOGPIXELSY ) );

   if ( lf.lfWeight == 700 )
	{
		isBold = 1;
	}
	else
	{
		isBold = 0;
	}

   hb_reta( 7 );
	HB_STORC( lf.lfFaceName, -1, 1 );
	HB_STORNL3( PointSize, -1, 2 );
	HB_STORL( isBold, -1, 3 );
	HB_STORL( lf.lfItalic, -1, 4 );
	HB_STORL( lf.lfUnderline, -1, 5 );
	HB_STORL( lf.lfStrikeOut, -1, 6 );
	HB_STORNI( lf.lfCharSet, -1, 7 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GETOTHERMETRICS )
{
   NONCLIENTMETRICS ncm;

   ncm.cbSize = sizeof( ncm );

	if ( ! SystemParametersInfo( SPI_GETNONCLIENTMETRICS, sizeof( ncm ), &ncm, 0 ) )
	{
		hb_reta( 10 );
		HB_STORNI( 0, -1, 1 );
		HB_STORNI( 0, -1, 2 );
		HB_STORNI( 0, -1, 3 );
		HB_STORNI( 0, -1, 4 );
		HB_STORNI( 0, -1, 5 );
		HB_STORNI( 0, -1, 6 );
		HB_STORNI( 0, -1, 7 );
		HB_STORNI( 0, -1, 8 );
		HB_STORNI( 0, -1, 9 );
		HB_STORNI( 0, -1, 10 );
		return;
	}

   hb_reta( 10 );
	HB_STORNI( ncm.iBorderWidth, -1, 1 );
	HB_STORNI( ncm.iScrollWidth, -1, 2 );
	HB_STORNI( ncm.iScrollHeight, -1, 3 );
	HB_STORNI( ncm.iCaptionWidth, -1, 4 );
	HB_STORNI( ncm.iCaptionHeight, -1, 5 );
	HB_STORNI( ncm.iSmCaptionWidth, -1, 6 );
	HB_STORNI( ncm.iSmCaptionHeight, -1, 7 );
	HB_STORNI( ncm.iMenuWidth, -1, 8 );
	HB_STORNI( ncm.iMenuHeight, -1, 9 );
	HB_STORNI( ncm.iPaddedBorderWidth, -1, 10 );
}

/*
 * Borrowed from HGM Extended.
 * Based on the works of Petr Chornyj, Claudio Soto, Viktor Szakats and Grigory Filatov.
 * EnumFontsEx( [hDC], [cFontFamilyName], [nCharSet], [nPitch], [nFontType], [SortCodeBlock], [@aFontName] ) ->{ { cFontName, nCharSet, nPitchAndFamily, nFontType }, ... }
 */

static int CALLBACK _EnumFontFamExProc( const LOGFONT * lpelfe, const TEXTMETRIC * lpntme, DWORD dwFontType, LPARAM pArray );

HB_FUNC( ENUMFONTSEX )
{
   HDC hdc;
   LOGFONT lf;
   PHB_ITEM pArray= hb_itemArrayNew( 0 );
   BOOL bReleaseDC = FALSE;

   memset( &lf, 0, sizeof( LOGFONT ) );

   if( GetObjectType( HGDIOBJparam( 1 ) ) == OBJ_DC )
      hdc = HDCparam( 1 );
   else
   {
      hdc = GetDC( NULL );
      bReleaseDC = TRUE;
   }

   if( hb_parclen( 2 ) > 0 )
      hb_strncpy( lf.lfFaceName, hb_parc( 2 ), HB_MIN( LF_FACESIZE - 1, hb_parclen( 2 ) ) );
   else
      lf.lfFaceName[ 0 ] = TEXT( '\0' );

   lf.lfCharSet        = (BYTE) ( HB_ISNUM( 3 ) ? ( hb_parni( 3 ) == DEFAULT_CHARSET ? GetTextCharset ( hdc ) : hb_parni( 3 ) ) : -1 );
   lf.lfPitchAndFamily = (BYTE) ( HB_ISNUM( 4 ) ? ( hb_parni( 4 ) == DEFAULT_PITCH ? -1 : ( hb_parni( 4 ) | FF_DONTCARE ) ) : -1 );
   /* TODO - nFontType */

   EnumFontFamiliesEx( hdc, &lf, _EnumFontFamExProc, (LPARAM) pArray, 0 );

   if( bReleaseDC )
      ReleaseDC( NULL, hdc );

   if( HB_ISBLOCK( 6 ) )
      hb_arraySort( pArray, NULL, NULL, hb_param( 6, HB_IT_BLOCK ) );

   if( HB_ISBYREF( 7 ) )
   {
      PHB_ITEM aFontName = hb_param( 7, HB_IT_ANY );
      int nLen = (int) hb_arrayLen( pArray ), i;

      hb_arrayNew( aFontName, nLen );

      for( i = 1; i <= nLen; i++ )
         hb_arraySetC( aFontName, i, hb_arrayGetC( hb_arrayGetItemPtr( pArray, i ), 1 ) );
   }

   hb_itemReturnRelease( pArray );
}

static int CALLBACK _EnumFontFamExProc( const LOGFONT * lpelfe, const TEXTMETRIC * lpntme, DWORD dwFontType, LPARAM pArray )
{
   if( lpelfe->lfFaceName[ 0 ] != '@' )
   {
      PHB_ITEM pSubArray = hb_itemArrayNew( 4 );

      hb_arraySetC( pSubArray, 1, lpelfe->lfFaceName );
      HB_ARRAYSETNL( pSubArray, 2, lpntme->tmCharSet );
      hb_arraySetNI( pSubArray, 3, lpelfe->lfPitchAndFamily & FIXED_PITCH );
      hb_arraySetNI( pSubArray, 4, dwFontType & TRUETYPE_FONTTYPE );

      hb_arrayAddForward( (PHB_ITEM) pArray, pSubArray );
      hb_itemRelease( pSubArray );
   }
   return 1;
}

