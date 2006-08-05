/*
 * $Id: h_textarray.prg,v 1.1 2006-08-05 02:20:30 guerra000 Exp $
 */
/*
 * ooHG source code:
 * TTextArray control source code
 *
 * Copyright 2006 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.guerra.com.mx
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

#include "oohg.ch"
#include "hbclass.ch"
#include "i_windefs.ch"

CLASS TTextArray FROM TControl
   DATA Type       INIT "TEXTARRAY" READONLY

   METHOD Define
   METHOD SetFont

   METHOD Events

   METHOD RowCount       SETGET
   METHOD ColCount       SETGET
   METHOD TextRow        SETGET
   METHOD TextCol        SETGET
   METHOD Write          SETGET
   METHOD WriteRaw       SETGET
   METHOD Scroll
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, RowCount, ColCount, ;
               BORDER, CLIENTEDGE, FontColor, BackColor, ProcedureName, ;
               fontname, fontsize, bold, italic, underline, strikeout, ;
               ToolTip, HelpId, invisible, lRtl, value ) CLASS TTextArray
*-----------------------------------------------------------------------------*
Local ControlHandle, nStyle, nStyleEx

   ASSIGN ::nCol        VALUE x TYPE "N"
   ASSIGN ::nRow        VALUE y TYPE "N"
   ASSIGN ::nWidth      VALUE w TYPE "N"
   ASSIGN ::nHeight     VALUE h TYPE "N"
   ASSIGN invisible     VALUE invisible    TYPE "L" DEFAULT .F.

   ::SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor, , lRtl )

   nStyle := if( ValType( invisible ) != "L" .OR. ! invisible, WS_VISIBLE,  0 ) + ;
             if( ValType( BORDER ) == "L"    .AND. BORDER,     WS_BORDER,   0 )

   nStyleEx := if( ValType( CLIENTEDGE ) == "L"   .AND. CLIENTEDGE,   WS_EX_CLIENTEDGE,  0 )

   Controlhandle := InitTextArray( ::ContainerhWnd, ::ContainerCol, ::ContainerRow, ::nWidth, ::nHeight, nStyle, nStyleEx, ::lRtl )

   ::Register( ControlHandle, ControlName, HelpId, ! Invisible, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   ASSIGN ::RowCount VALUE RowCount TYPE "N" DEFAULT 10
   ASSIGN ::ColCount VALUE ColCount TYPE "N" DEFAULT 10

   ::Write( value )

*   If ::Transparent
*      RedrawWindowControlRect( ::ContainerhWnd, ::ContainerRow, ::ContainerCol, ::ContainerRow + ::Height, ::ContainerCol + ::Width )
*   EndIf

   ::OnClick := ProcedureName

Return Self

*-----------------------------------------------------------------------------*
METHOD SetFont( FontName, FontSize, Bold, Italic, Underline, Strikeout ) CLASS TTextArray
*-----------------------------------------------------------------------------*
LOCAL uRet
   uRet := ::Super:SetFont( FontName, FontSize, Bold, Italic, Underline, Strikeout )
   TTextArray_SetFontSize( Self )
Return Nil

#pragma BEGINDUMP

#define s_Super s_TControl

#include "hbapi.h"
#include "hbapiitm.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windows.h>
#include <commctrl.h>
#include "../include/oohg.h"

typedef struct {
   BYTE     character;
   LONG     FontColor;
   LONG     BackColor;
} CHARCELL, *PCHARCELL;

void TTextArray_Empty( PCHARCELL pCell, POCTRL oSelf )
{
   pCell->character = ' ';
   pCell->FontColor = oSelf->lFontColor;
   pCell->BackColor = oSelf->lBackColor;
}

// lAux[ 0 ] = ColCount
// lAux[ 1 ] = RowCount
// lAux[ 2 ] = Col
// lAux[ 3 ] = Row
// lAux[ 4 ] = Text width
// lAux[ 5 ] = Text height

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

static BOOL bRegistered = 0;

HB_FUNC_STATIC( TTEXTARRAY_EVENTS )
{
   HWND hWnd      = ( HWND )   hb_parnl( 1 );
   UINT message   = ( UINT )   hb_parni( 2 );
   WPARAM wParam  = ( WPARAM ) hb_parni( 3 );
   LPARAM lParam  = ( LPARAM ) hb_parnl( 4 );
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   switch( message )
   {
      case WM_PAINT:
         {
            PAINTSTRUCT ps;
            HDC         hdc;
            HFONT       hOldFont;
            RECT        updateRect, rect2;
            COLORREF    FontColor, BackColor;
            LONG        x, y, lCell, lMaxCell;
            CHARCELL    sNull, *pCell;

            if ( ! GetUpdateRect( hWnd, &updateRect, FALSE ) )
            {
               hb_retni( 0 );
            }
            else
            {
               TTextArray_Empty( &sNull, oSelf );
               sNull.FontColor = ( ( sNull.FontColor == -1 ) ? GetSysColor( COLOR_WINDOWTEXT ) : sNull.FontColor );
               sNull.BackColor = ( ( sNull.BackColor == -1 ) ? GetSysColor( COLOR_WINDOW )     : sNull.BackColor );

// scrollbar!

               hdc = BeginPaint( hWnd, &ps );
               FontColor = SetTextColor( hdc, sNull.FontColor );
               BackColor = SetBkColor(   hdc, sNull.BackColor );
               SetTextAlign( hdc, TA_LEFT );  // TA_CENTER

               if( ! oSelf->AuxBuffer )
               {
                  ExtTextOut( hdc, 0, 0, ETO_CLIPPED | ETO_OPAQUE, &updateRect, "", 0, NULL );
               }
               else
               {
                  hOldFont = ( HFONT ) SelectObject( hdc, oSelf->hFontHandle );
                  lMaxCell = oSelf->AuxBufferLen / sizeof( CHARCELL );
                  y = updateRect.top / oSelf->lAux[ 5 ];
                  rect2.top = y * oSelf->lAux[ 5 ];
                  rect2.bottom = rect2.top + oSelf->lAux[ 5 ];
                  while( rect2.top <= updateRect.bottom )
                  {
                     x = updateRect.left / oSelf->lAux[ 4 ];
                     rect2.left = x * oSelf->lAux[ 4 ];
                     rect2.right = rect2.left + oSelf->lAux[ 4 ];
                     lCell = ( y * oSelf->lAux[ 0 ] ) + x;
                     pCell = &( ( ( PCHARCELL )( oSelf->AuxBuffer ) )[ lCell ] );
                     if( x > oSelf->lAux[ 0 ] )
                     {
                        x = oSelf->lAux[ 0 ];
                     }
                     while( x <= oSelf->lAux[ 0 ] && rect2.left <= updateRect.right )
                     {
                        if( lCell >= lMaxCell || x >= oSelf->lAux[ 0 ] )
                        {
                           pCell = &sNull;
                           rect2.right = updateRect.right;
                        }
                        SetTextColor( hdc, ( ( pCell->FontColor == -1 ) ? GetSysColor( COLOR_WINDOWTEXT ) : pCell->FontColor ) );
                        SetBkColor(   hdc, ( ( pCell->BackColor == -1 ) ? GetSysColor( COLOR_WINDOW )     : pCell->BackColor ) );
// any different font??
                        ExtTextOut( hdc, rect2.left, rect2.top, ETO_CLIPPED | ETO_OPAQUE, &rect2, ( char * ) &( pCell->character ), 1, NULL );
                        lCell++;
                        pCell++;
                        rect2.left = rect2.right;
                        rect2.right += oSelf->lAux[ 4 ];
                        x++;
                     }
                     rect2.top = rect2.bottom;
                     rect2.bottom += oSelf->lAux[ 5 ];
                     y++;
                  }
                  SelectObject( hdc, hOldFont );
               }
               SetTextColor( hdc, FontColor );
               SetBkColor( hdc, BackColor );
               EndPaint( hWnd, &ps );
               hb_retni( 1 );
            }
         }
         break;

      default:
         _OOHG_Send( pSelf, s_Super );
         hb_vmSend( 0 );
         _OOHG_Send( hb_param( -1, HB_IT_OBJECT ), s_Events );
         hb_vmPushLong( ( LONG ) hWnd );
         hb_vmPushLong( message );
         hb_vmPushLong( wParam );
         hb_vmPushLong( lParam );
         hb_vmSend( 4 );
         break;
   }
}

HB_FUNC_STATIC( TTEXTARRAY_SETFONTSIZE )
{
   PHB_ITEM pSelf;
   POCTRL oSelf;
   HDC hDC;
   HFONT hFont;
   SIZE sz;

   pSelf = hb_param( 1, HB_IT_OBJECT );
   if( pSelf )
   {
      oSelf = _OOHG_GetControlInfo( pSelf );

      hDC = GetDC( oSelf->hWnd );
      hFont = SelectObject( hDC, oSelf->hFontHandle );
      GetTextExtentPoint32( hDC, "W", 1, &sz );
      if( hFont )
      {
         SelectObject( hDC, hFont );
      }
      ReleaseDC( oSelf->hWnd, hDC );

      oSelf->lAux[ 4 ] = sz.cx;
      oSelf->lAux[ 5 ] = sz.cy;
      RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
   }
}

#define RANGEMINMAX( iMin, iValue, iMax )   if( iValue < ( iMin ) ) { iValue = (iMin); } else if( iValue > ( iMax ) ) { iValue = ( iMax ); }
#define LO_HI_AUX( _Lo, _Hi, _Aux )         if( _Lo > _Hi ) { _Aux = _Hi; _Hi = _Lo; _Lo = _Aux; }

static void TTextArray_Scroll( POCTRL oSelf, int iCol1, int iRow1, int iCol2, int iRow2, int iVert, int iHoriz )
{
   int iAux, iDelta, iRow;
   PCHARCELL pCell;
   RECT rect;

   RANGEMINMAX( 0, iCol1, ( oSelf->lAux[ 0 ] - 1 ) )
   RANGEMINMAX( 0, iCol2, ( oSelf->lAux[ 0 ] - 1 ) )
   RANGEMINMAX( 0, iRow1, ( oSelf->lAux[ 1 ] - 1 ) )
   RANGEMINMAX( 0, iRow2, ( oSelf->lAux[ 1 ] - 1 ) )
   LO_HI_AUX( iCol1, iCol2, iAux )
   LO_HI_AUX( iRow1, iRow2, iAux )

   RANGEMINMAX( ( iRow1 - iRow2 - 1 ), iVert,  ( iRow2 - iRow1 + 1 ) )
   RANGEMINMAX( ( iCol1 - iCol2 - 1 ), iHoriz, ( iCol2 - iCol1 + 1 ) )

   pCell = ( PCHARCELL ) oSelf->AuxBuffer;

   if( iVert > 0 )
   {
      iDelta = iRow2 - iRow1 + 1 - iVert;
      iRow = iRow1;
      while( iDelta )
      {
         memcpy( &pCell[ ( iRow * oSelf->lAux[ 0 ] ) + iCol1 ], &pCell[ ( ( iRow + iVert ) * oSelf->lAux[ 0 ] ) + iCol1 ], ( sizeof( CHARCELL ) * ( iCol2 - iCol1 + 1 ) ) );
         iRow++;
         iDelta--;
      }
      while( iVert )
      {
         for( iAux = iCol1; iAux <= iCol2; iAux++ )
         {
            TTextArray_Empty( &pCell[ ( iRow * oSelf->lAux[ 0 ] ) + iAux ], oSelf );
         }
         iRow++;
         iVert--;
      }
   }
   else if( iVert < 0 )
   {
      iDelta = iRow2 - iRow1 + 1 - iVert;
      iRow = iRow2;
      while( iDelta )
      {
         memcpy( &pCell[ ( iRow * oSelf->lAux[ 0 ] ) + iCol1 ], &pCell[ ( ( iRow + iVert ) * oSelf->lAux[ 0 ] ) + iCol1 ], ( sizeof( CHARCELL ) * ( iCol2 - iCol1 + 1 ) ) );
         iRow--;
         iDelta--;
      }
      while( iVert )
      {
         for( iAux = iCol1; iAux <= iCol2; iAux++ )
         {
            TTextArray_Empty( &pCell[ ( iRow * oSelf->lAux[ 0 ] ) + iAux ], oSelf );
         }
         iRow--;
         iVert++;
      }
   }

   if( iHoriz > 0 )
   {
      iDelta = iCol2 - iCol1 + 1 - iHoriz;
      iRow = iRow1;
      while( iRow <= iRow2 )
      {
         memcpy( &pCell[ ( iRow * oSelf->lAux[ 0 ] ) + iCol1 ], &pCell[ ( iRow * oSelf->lAux[ 0 ] ) + iCol1 + iHoriz ], ( sizeof( CHARCELL ) * iDelta ) );
         for( iAux = iCol1 + iDelta; iAux <= iCol2; iAux++ )
         {
            TTextArray_Empty( &pCell[ ( iRow * oSelf->lAux[ 0 ] ) + iAux ], oSelf );
         }
         iRow++;
      }
   }
   else if( iHoriz < 0 )
   {
      iRow = iRow1;
      while( iRow <= iRow2 )
      {
         for( iAux = iCol2; iAux >= iCol1 - iHoriz; iAux-- )
         {
            memcpy( &pCell[ ( iRow * oSelf->lAux[ 0 ] ) + iAux ], &pCell[ ( iRow * oSelf->lAux[ 0 ] ) + iAux + iHoriz ], sizeof( CHARCELL ) );
         }
         for( ; iAux >= iCol1; iAux-- )
         {
            TTextArray_Empty( &pCell[ ( iRow * oSelf->lAux[ 0 ] ) + iAux ], oSelf );
         }
         iRow++;
      }
   }

   rect.top    = iRow1 * oSelf->lAux[ 5 ];
   rect.left   = iCol1 * oSelf->lAux[ 4 ];
   rect.bottom = ( iRow2 + 1 ) * oSelf->lAux[ 5 ];
   rect.right  = ( iCol2 + 1 ) * oSelf->lAux[ 4 ];
   RedrawWindow( oSelf->hWnd, &rect, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
}

static void TTextArray_ReSize( POCTRL oSelf, int iRow, int iCol )
{
   int iOldRow, iOldCol, x, y, iCopy;
   ULONG lSize;
   BYTE *pBuffer;
   PCHARCELL pCell;

   if( ! oSelf->AuxBuffer )
   {
      oSelf->lAux[ 0 ] = 0;
      oSelf->lAux[ 1 ] = 0;
      oSelf->AuxBufferLen = 0;
   }
   iOldRow = oSelf->lAux[ 1 ];
   iOldCol = oSelf->lAux[ 0 ];

   if( iRow < 1 )
   {
      iRow = 1;
   }
   if( iCol < 1 )
   {
      iCol = 1;
   }

   lSize = sizeof( CHARCELL ) * iCol * iRow;
   if( iOldCol >= iCol && oSelf->AuxBufferLen >= lSize )
   {
      pBuffer = oSelf->AuxBuffer;
      lSize = oSelf->AuxBufferLen;
   }
   else
   {
      pBuffer = hb_xgrab( sizeof( CHARCELL ) * iCol * iRow );
   }

   if( iCol > iOldCol )
   {
      iCopy = iOldCol;
   }
   else
   {
      iCopy = iCol;
   }

   for( y = 0; y < iRow; y++ )
   {
      pCell = &( ( ( PCHARCELL ) pBuffer )[ iCol * y ] );
      if( y >= iOldRow )
      {
         iOldCol = 0;
         iCopy = 0;
      }
      if( iOldCol )
      {
         memcpy( pCell, &( ( ( PCHARCELL ) oSelf->AuxBuffer )[ iOldCol * y ] ), sizeof( CHARCELL ) * iCopy );
         pCell += iCopy;
      }
      for( x = iCopy; x < iCol ; x++ )
      {
         TTextArray_Empty( pCell, oSelf );
         pCell++;
      }
   }

   if( oSelf->AuxBuffer != pBuffer && oSelf->AuxBuffer )
   {
      hb_xfree( oSelf->AuxBuffer );
   }
   oSelf->AuxBuffer = pBuffer;
   oSelf->AuxBufferLen = lSize;
   oSelf->lAux[ 0 ] = iCol;
   oSelf->lAux[ 1 ] = iRow;

   if( oSelf->lAux[ 2 ] >= iCol )
   {
      oSelf->lAux[ 2 ] = iCol - 1;
   }
   if( oSelf->lAux[ 3 ] >= iRow )
   {
      oSelf->lAux[ 3 ] = iRow - 1;
   }

   RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
}

static void TTextArray_Out( POCTRL oSelf, BYTE cByte )
{
   PCHARCELL pCell;
   RECT rect;

   if( oSelf->AuxBuffer && oSelf->lAux[ 0 ] && oSelf->lAux[ 1 ] )
   {
      if( oSelf->lAux[ 2 ] >= oSelf->lAux[ 0 ] )
      {
         oSelf->lAux[ 2 ] = 0;
         oSelf->lAux[ 3 ]++;
      }
      if( oSelf->lAux[ 3 ] >= oSelf->lAux[ 1 ] )
      {
         oSelf->lAux[ 3 ] = oSelf->lAux[ 1 ] - 1;
         TTextArray_Scroll( oSelf, 0, 0, oSelf->lAux[ 0 ] - 1, oSelf->lAux[ 1 ] - 1, 1, 0 );
      }

      pCell = &( ( ( PCHARCELL ) oSelf->AuxBuffer )[ ( oSelf->lAux[ 3 ] * oSelf->lAux[ 0 ] ) + oSelf->lAux[ 2 ] ] );
      pCell->character = cByte;
      pCell->FontColor = oSelf->lFontColor;
      pCell->BackColor = oSelf->lBackColor;

      rect.top    = oSelf->lAux[ 3 ] * oSelf->lAux[ 5 ];
      rect.left   = oSelf->lAux[ 2 ] * oSelf->lAux[ 4 ];
      rect.bottom = rect.top  + oSelf->lAux[ 5 ];
      rect.right  = rect.left + oSelf->lAux[ 4 ];
      RedrawWindow( oSelf->hWnd, &rect, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );

      oSelf->lAux[ 2 ]++;
   }
}

static void TTextArray_MoveTo( POCTRL oSelf, int iRow, int iCol )
{
   if( iRow < 0 )
   {
      iRow = 0;
   }
   else if( iRow >= oSelf->lAux[ 1 ] )
   {
      iRow = oSelf->lAux[ 1 ] - 1;
   }
   oSelf->lAux[ 3 ] = iRow;

   if( iCol < 0 )
   {
      iCol = 0;
   }
   oSelf->lAux[ 2 ] = iCol;
}

HB_FUNC_STATIC( TTEXTARRAY_ROWCOUNT )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( hb_pcount() >= 1 && ISNUM( 1 ) )
   {
      TTextArray_ReSize( oSelf, hb_parni( 1 ), oSelf->lAux[ 0 ] );
   }

   hb_retni( oSelf->lAux[ 1 ] );
}

HB_FUNC_STATIC( TTEXTARRAY_COLCOUNT )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( hb_pcount() >= 1 && ISNUM( 1 ) )
   {
      TTextArray_ReSize( oSelf, oSelf->lAux[ 1 ], hb_parni( 1 ) );
   }

   hb_retni( oSelf->lAux[ 0 ] );
}

HB_FUNC_STATIC( TTEXTARRAY_TEXTROW )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( hb_pcount() >= 1 && ISNUM( 1 ) )
   {
      TTextArray_MoveTo( oSelf, hb_parni( 1 ), oSelf->lAux[ 2 ] );
   }

   hb_retni( oSelf->lAux[ 3 ] );
}

HB_FUNC_STATIC( TTEXTARRAY_TEXTCOL )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( hb_pcount() >= 1 && ISNUM( 1 ) )
   {
      TTextArray_MoveTo( oSelf, oSelf->lAux[ 3 ], hb_parni( 1 ) );
   }

   hb_retni( oSelf->lAux[ 2 ] );
}

HB_FUNC_STATIC( TTEXTARRAY_WRITE )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   BYTE *pBuffer, cByte;
   ULONG lBuffer;
   int iRow, iCol;

   iCol = ISNUM( 2 ) ? hb_parni( 2 ) : oSelf->lAux[ 2 ];
   iRow = ISNUM( 3 ) ? hb_parni( 3 ) : oSelf->lAux[ 3 ];
   TTextArray_MoveTo( oSelf, iRow, iCol );

   if( ISCHAR( 1 ) && oSelf->AuxBuffer && oSelf->lAux[ 0 ] && oSelf->lAux[ 1 ] )
   {
      pBuffer = ( BYTE * ) hb_parc( 1 );
      lBuffer = hb_parclen( 1 );
      while( lBuffer )
      {
         cByte = *pBuffer++;
         switch( cByte )
         {
            case 13:
               oSelf->lAux[ 2 ] = 0;
               break;

            case 10:
               oSelf->lAux[ 3 ]++;
               if( oSelf->lAux[ 3 ] >= oSelf->lAux[ 1 ] )
               {
                  oSelf->lAux[ 3 ] = oSelf->lAux[ 1 ] - 1;
                  TTextArray_Scroll( oSelf, 0, 0, oSelf->lAux[ 0 ] - 1, oSelf->lAux[ 1 ] - 1, 1, 0 );
               }
               break;

            default:
               TTextArray_Out( oSelf, cByte );
               break;
         }
         lBuffer--;
      }
   }
}

HB_FUNC_STATIC( TTEXTARRAY_WRITERAW )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   BYTE *pBuffer;
   ULONG lBuffer;
   int iRow, iCol;

   iCol = ISNUM( 2 ) ? hb_parni( 2 ) : oSelf->lAux[ 2 ];
   iRow = ISNUM( 3 ) ? hb_parni( 3 ) : oSelf->lAux[ 3 ];
   TTextArray_MoveTo( oSelf, iRow, iCol );

   if( ISCHAR( 1 ) && oSelf->AuxBuffer && oSelf->lAux[ 0 ] && oSelf->lAux[ 1 ] )
   {
      pBuffer = ( BYTE * ) hb_parc( 1 );
      lBuffer = hb_parclen( 1 );
      while( lBuffer )
      {
         TTextArray_Out( oSelf, *pBuffer++ );
         lBuffer--;
      }
   }
}

HB_FUNC_STATIC( TTEXTARRAY_SCROLL )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   int iCol1, iRow1, iCol2, iRow2, iVert, iHoriz;

   iCol1  = ISNUM( 2 ) ? hb_parni( 2 ) : 0;
   iRow1  = ISNUM( 1 ) ? hb_parni( 1 ) : 0;
   iCol2  = ISNUM( 4 ) ? hb_parni( 4 ) : oSelf->lAux[ 0 ] - 1;
   iRow2  = ISNUM( 3 ) ? hb_parni( 3 ) : oSelf->lAux[ 1 ] - 1;
   iVert  = ISNUM( 5 ) ? hb_parni( 5 ) : 0;
   iHoriz = ISNUM( 6 ) ? hb_parni( 6 ) : 0;

   TTextArray_Scroll( oSelf, iCol1, iRow1, iCol2, iRow2, iVert, iHoriz );
}

static LRESULT CALLBACK _OOHG_TextArray_WndProc( HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam )
{
   return DefWindowProc( hWnd, message, wParam, lParam );
}

void _OOHG_TextArray_Register( void )
{
   WNDCLASS WndClass;

   memset( &WndClass, 0, sizeof( WndClass ) );
   WndClass.style         = CS_HREDRAW | CS_VREDRAW | CS_OWNDC | CS_DBLCLKS;
   WndClass.lpfnWndProc   = _OOHG_TextArray_WndProc;
   WndClass.lpszClassName = "_OOHG_TEXTARRAY";
   WndClass.hInstance     = GetModuleHandle( NULL );
   WndClass.hbrBackground = ( HBRUSH )( COLOR_BTNFACE + 1 );

   if( ! RegisterClass( &WndClass ) )
   {
      char cBuffError[ 1000 ];
      sprintf( cBuffError, "_OOHG_TEXTARRAY Registration Failed! Error %i", ( int ) GetLastError() );
      MessageBox( 0, cBuffError, "Error!", MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
      ExitProcess( 0 );
   }

   bRegistered = 1;
}

HB_FUNC( INITTEXTARRAY )
{
   HWND hwnd;
   HWND hbutton;

   int Style, ExStyle;

   if( ! bRegistered )
   {
      _OOHG_TextArray_Register();
   }

   hwnd = HWNDparam( 1 );
   Style = hb_parni( 6 ) | WS_CHILD;
   ExStyle = hb_parni( 7 ) | _OOHG_RTL_Status( hb_parl( 8 ) );

   hbutton = CreateWindowEx( ExStyle, "_OOHG_TEXTARRAY", "", Style,
             hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ),
             hwnd, NULL, GetModuleHandle( NULL ), NULL );

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( hbutton, GWL_WNDPROC, ( LONG ) SubClassFunc );

   HWNDret( hbutton );
}

#pragma ENDDUMP
