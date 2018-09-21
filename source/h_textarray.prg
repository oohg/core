/*
 * $Id: h_textarray.prg $
 */
/*
 * ooHG source code:
 * TTextArray control source code
 *
 * Copyright 2006-2018 Vicente Guerra <vicente@guerra.com.mx>
 * https://oohg.github.io/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2018, https://harbour.github.io/
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


#include "oohg.ch"
#include "hbclass.ch"
#include "i_windefs.ch"

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TTextArray FROM TControl

   DATA Type                       INIT "TEXTARRAY" READONLY

   METHOD AssumeFixed              SETGET
   METHOD Clear
   METHOD Cls                      BLOCK { |Self| ::Clear(), ::DevPos( 0, 0 ) }
   METHOD ColCount                 SETGET
   METHOD CursorType               SETGET
   METHOD Define
   METHOD DevPos
   METHOD Events
   METHOD QOut( t )                BLOCK { |Self, t| ::Write( CRLF ), ::Write( t ) }
   METHOD QQOut( t )               BLOCK { |Self, t| ::Write( t ) }
   METHOD RowCount                 SETGET
   METHOD Scroll
   METHOD SetFont
   METHOD TextCol                  SETGET
   METHOD TextRow                  SETGET
   METHOD Write
   METHOD WriteLn( t, c, r, f, b ) BLOCK { |Self, t, c, r, f, b| ::Write( t, c, r, f, b), ::Write( CRLF ) }
   METHOD WriteRaw

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( cControlName, uParentForm, nCol, nRow, nWidth, nHeight, nRowCount, nColCount, lBorder, lClientEdge, ;
      uFontColor, uBackColor, bProcedureName, cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout, ;
      cToolTip, nHelpId, lInvisible, lRtl, cValue, lNoTabStop, lDisabled, bGotFocus, bLostFocus ) CLASS TTextArray

   LOCAL nControlHandle, nStyle, nStyleEx

   ASSIGN ::nCol    VALUE nCol    TYPE "N"
   ASSIGN ::nRow    VALUE nRow    TYPE "N"
   ASSIGN ::nWidth  VALUE nWidth  TYPE "N"
   ASSIGN ::nHeight VALUE nHeight TYPE "N"

   IF uBackColor == NIL
      uBackColor := GetSysColor( COLOR_3DFACE )
   ENDIF

   ::SetForm( cControlName,uParentForm, cFontName, nFontSize, uFontColor, uBackColor, , lRtl )

   nStyle := ::InitStyle(, , lInvisible, lNoTabStop, lDisabled ) + ;
             iif( ValType( lBorder ) == "L" .AND. lBorder, WS_BORDER, 0 )

   nStyleEx := iif( ValType( lClientEdge ) == "L" .AND. lClientEdge, WS_EX_CLIENTEDGE, 0 )

   nControlhandle := InitTextArray( ::ContainerhWnd, ::ContainerCol, ::ContainerRow, ::nWidth, ::nHeight, nStyle, nStyleEx, ::lRtl )

   ::Register( nControlHandle, cControlName, nHelpId, , cToolTip )
   ::SetFont(, , lBold, lItalic, lUnderline, lStrikeout )

   ASSIGN ::RowCount VALUE nRowCount TYPE "N" DEFAULT TTextArray_MaxChars( Self, 0 )
   ASSIGN ::ColCount VALUE nColCount TYPE "N" DEFAULT TTextArray_MaxChars( Self, 1 )

   ::Write( cValue )

*   If ::Transparent
*      RedrawWindowControlRect( ::ContainerhWnd, ::ContainerRow, ::ContainerCol, ::ContainerRow + ::Height, ::ContainerCol + ::Width )
*   EndIf

   DEFINE TIMER 0 OF ( Self ) INTERVAL 500 ACTION TTextArray_CursorTimer( Self )

   ASSIGN ::OnClick     VALUE bProcedureName TYPE "B"
   ASSIGN ::OnGotFocus  VALUE bGotFocus      TYPE "B"
   ASSIGN ::OnLostFocus VALUE bLostFocus     TYPE "B"

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetFont( cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout ) CLASS TTextArray

   ::Super:SetFont( cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout )
   TTextArray_SetFontSize( Self )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
#pragma BEGINDUMP

#define s_Super s_TControl

#include "hbapi.h"
#include "hbapiitm.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windows.h>
#include <commctrl.h>
#include "oohg.h"

typedef struct {
   BYTE character;
   LONG FontColor;
   LONG BackColor;
} CHARCELL, *PCHARCELL;

/*
   lAux[ 0 ] = Col count
   lAux[ 1 ] = Row count
   lAux[ 2 ] = Col
   lAux[ 3 ] = Row
   lAux[ 4 ] = Text width
   lAux[ 5 ] = Text height
   lAux[ 6 ] = Cursor type
   lAux[ 7 ] = Cursor time (show or hide)
   lAux[ 8 ] = Assume fixed font
*/
#define SELF_COLCOUNT( xSelf )   xSelf->lAux[ 0 ]
#define SELF_ROWCOUNT( xSelf )   xSelf->lAux[ 1 ]
#define SELF_COL( xSelf )        xSelf->lAux[ 2 ]
#define SELF_ROW( xSelf )        xSelf->lAux[ 3 ]
#define SELF_TEXTWIDTH( xSelf )  xSelf->lAux[ 4 ]
#define SELF_TEXTHEIGHT( xSelf ) xSelf->lAux[ 5 ]
#define SELF_CURSORTYPE( xSelf ) xSelf->lAux[ 6 ]
#define SELF_CURSORTIME( xSelf ) xSelf->lAux[ 7 ]
#define SELF_FIXED( xSelf )      xSelf->lAux[ 8 ]

#define RANGEMINMAX( iMin, iValue, iMax ) if( iValue < ( iMin ) ) { iValue = (iMin); } else if( iValue > ( iMax ) ) { iValue = ( iMax ); }
#define LO_HI_AUX( _Lo, _Hi, _Aux )       if( _Lo > _Hi ) { _Aux = _Hi; _Hi = _Lo; _Lo = _Aux; }

/*--------------------------------------------------------------------------------------------------------------------------------*/
static WNDPROC _OOHG_TTextArray_lpfnOldWndProc( WNDPROC lp )
{
   static WNDPROC lpfnOldWndProc = 0;

   if( ! lpfnOldWndProc )
   {
      lpfnOldWndProc = lp;
   }

   return lpfnOldWndProc;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, _OOHG_TTextArray_lpfnOldWndProc( 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static LRESULT CALLBACK _OOHG_TTextArray_WndProc( HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam )
{
   return DefWindowProc( hWnd, message, wParam, lParam );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static void _OOHG_TTextArray_Register( void )
{
   static BOOL bRegistered = FALSE;

   if( ! bRegistered )
   {
      WNDCLASS WndClass;

      memset( &WndClass, 0, sizeof( WndClass ) );
      WndClass.style         = CS_HREDRAW | CS_VREDRAW | CS_OWNDC | CS_DBLCLKS;
      WndClass.lpfnWndProc   = _OOHG_TTextArray_WndProc;
      WndClass.lpszClassName = "_OOHG_TTEXTARRAY";
      WndClass.hInstance     = GetModuleHandle( NULL );
      WndClass.hbrBackground = ( HBRUSH )( COLOR_BTNFACE + 1 );

      if( ! RegisterClass( &WndClass ) )
      {
         char cBuffError[ 1000 ];
         sprintf( cBuffError, "_OOHG_TTEXTARRAY Registration Failed! Error %i", ( int ) GetLastError() );
         MessageBox( 0, cBuffError, "Error!", MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
         ExitProcess( 1 );
      }

      bRegistered = TRUE;
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( INITTEXTARRAY )          /* FUNCTION InitTextArray( hWnd, nCol, nRow, nWidth, nHeight, nStyle, nStyleEx, lRtl ) -> hWnd */
{
   HWND hwnd;
   HWND hbutton;
   int Style, ExStyle;

   _OOHG_TTextArray_Register();

   hwnd = HWNDparam( 1 );
   Style = hb_parni( 6 ) | WS_CHILD | SS_NOTIFY;
   ExStyle = hb_parni( 7 ) | _OOHG_RTL_Status( hb_parl( 8 ) );

   hbutton = CreateWindowEx( ExStyle, "_OOHG_TEXTARRAY", "", Style,
             hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ),
             hwnd, NULL, GetModuleHandle( NULL ), NULL );

   _OOHG_TTextArray_lpfnOldWndProc( (WNDPROC) SetWindowLongPtr( hbutton, GWL_WNDPROC, (LONG_PTR) SubClassFunc ) );

   HWNDret( hbutton );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static BOOL IsSameChar( PCHARCELL pCell1, PCHARCELL pCell2 )
{
   return ( pCell1->FontColor == pCell2->FontColor && pCell1->BackColor == pCell2->BackColor );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static void TTextArray_Empty( PCHARCELL pCell, POCTRL oSelf )
{
   pCell->character = ' ';
   pCell->FontColor = oSelf->lFontColor;
   pCell->BackColor = oSelf->lBackColor;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static void FillClear( RECT *rect, HDC hdc, LONG lColor )
{
   COLORREF OldColor;

   OldColor = SetBkColor( hdc, lColor );
   // Transparent?
   ExtTextOut( hdc, 0, 0, ETO_CLIPPED | ETO_OPAQUE, rect, "", 0, NULL );
   SetBkColor( hdc, OldColor );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static void RePaint_Out( HDC hdc, PCHARCELL pCell, RECT *rect2, char *cText, int iTextIndex )
{
   if( iTextIndex )
   {
      cText[ iTextIndex ] = 0;
      SetTextColor( hdc, ( ( pCell->FontColor == -1 ) ? GetSysColor( COLOR_WINDOWTEXT ) : (COLORREF) pCell->FontColor ) );
      SetBkColor(   hdc, ( ( pCell->BackColor == -1 ) ? GetSysColor( COLOR_WINDOW )     : (COLORREF) pCell->BackColor ) );
      // Transparent?
      // Any different font??
      ExtTextOut( hdc, rect2->left, rect2->top, ETO_CLIPPED | ETO_OPAQUE, rect2, cText, iTextIndex, NULL );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static void RePaint( POCTRL oSelf, HDC hdc2, RECT *updateRect )
{
   CHARCELL    sNull, *pCell, xCell = {0,0,0};
   COLORREF    FontColor, BackColor;
   LONG        x, y, lCell, lMaxCell, lStartX, lStartY;
   HFONT       hOldFont;
   RECT        rect2, ClientRect, updateRect2;
   HDC         hdc;

   if( ! ValidHandler( oSelf->hWnd ) )
   {
      return;
   }

   hdc = hdc2 ? hdc2 : GetDC( oSelf->hWnd );

   if( ! updateRect )
   {
      updateRect = &updateRect2;
      GetClientRect( oSelf->hWnd, updateRect );
   }

   TTextArray_Empty( &sNull, oSelf );
   sNull.FontColor = ( ( sNull.FontColor == -1 ) ? GetSysColor( COLOR_WINDOWTEXT ) : (COLORREF) sNull.FontColor );
   sNull.BackColor = ( ( sNull.BackColor == -1 ) ? GetSysColor( COLOR_WINDOW )     : (COLORREF) sNull.BackColor );

   FontColor = SetTextColor( hdc, sNull.FontColor );
   BackColor = SetBkColor(   hdc, sNull.BackColor );
   SetTextAlign( hdc, TA_LEFT );  // TA_CENTER

   if( ! oSelf->AuxBuffer )
   {
      FillClear( updateRect, hdc, sNull.BackColor );
   }
   else
   {
      char *cText = (char *) hb_xgrab( SELF_COLCOUNT( oSelf ) + 2 );
      int iTextIndex, iLeft;

      GetClientRect( oSelf->hWnd, &ClientRect );
      lStartY = - ClientRect.top  + GetScrollPos( oSelf->hWnd, SB_VERT );
      lStartX = - ClientRect.left + GetScrollPos( oSelf->hWnd, SB_HORZ );
      hOldFont = ( HFONT ) SelectObject( hdc, oSelf->hFontHandle );
      lMaxCell = oSelf->AuxBufferLen / sizeof( CHARCELL );
      y = ( updateRect->top + lStartY ) / SELF_TEXTHEIGHT( oSelf );
      if( y < 0 )
      {
         y = ( ClientRect.top + lStartY ) / SELF_TEXTHEIGHT( oSelf );
      }
      rect2.top = ( y * SELF_TEXTHEIGHT( oSelf ) ) - lStartY;
      rect2.bottom = rect2.top + SELF_TEXTHEIGHT( oSelf );
      while( rect2.top <= updateRect->bottom )
      {
         x = ( updateRect->left + lStartX ) / SELF_TEXTWIDTH( oSelf );
         if( x < 0 )
         {
            x = ( ClientRect.left + lStartX ) / SELF_TEXTWIDTH( oSelf );
         }
         iLeft = ( x * SELF_TEXTWIDTH( oSelf ) ) - lStartX;
         rect2.right = iLeft + SELF_TEXTWIDTH( oSelf );
         lCell = ( y * SELF_COLCOUNT( oSelf ) ) + x;
         pCell = &( ( ( PCHARCELL )( oSelf->AuxBuffer ) )[ lCell ] );
         if( x > SELF_COLCOUNT( oSelf ) )
         {
            x = SELF_COLCOUNT( oSelf );
         }
         iTextIndex = 0;
         while( x <= SELF_COLCOUNT( oSelf ) && iLeft <= updateRect->right )
         {
            if( lCell >= lMaxCell || x >= SELF_COLCOUNT( oSelf ) )
            {
               pCell = &sNull;
               rect2.right = updateRect->right;
            }

            if( iTextIndex == 0 )
            {
               memcpy( &xCell, pCell, sizeof( CHARCELL ) );
               rect2.left = iLeft;
            }
            else if( ! SELF_FIXED( oSelf ) || ! IsSameChar( &xCell, pCell ) )
            {
               RePaint_Out( hdc, &xCell, &rect2, cText, iTextIndex );
               memcpy( &xCell, pCell, sizeof( CHARCELL ) );
               rect2.left = iLeft;
               iTextIndex = 0;
            }
            cText[ iTextIndex ] = pCell->character;
            iTextIndex++;
            lCell++;
            pCell++;
            iLeft = rect2.right;
            rect2.right += SELF_TEXTWIDTH( oSelf );
            x++;
         }
         RePaint_Out( hdc, &xCell, &rect2, cText, iTextIndex );
         rect2.top = rect2.bottom;
         rect2.bottom += SELF_TEXTHEIGHT( oSelf );
         y++;
      }
      SelectObject( hdc, hOldFont );
      hb_xfree( cText );
   }
   SetTextColor( hdc, FontColor );
   SetBkColor( hdc, BackColor );

   if( ! hdc2 )
   {
      ReleaseDC( oSelf->hWnd, hdc );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static void Redraw( POCTRL oSelf, int iCol1, int iRow1, int iCol2, int iRow2 )
{
   int iAux, iPos;
   LONG_PTR lStyle, lStyle2;
   RECT rect;
   BOOL bHorizontal, bVertical, bChange;
   SCROLLINFO ScrollInfo;

   if( oSelf->AuxBuffer && SELF_COLCOUNT( oSelf ) && SELF_ROWCOUNT( oSelf ) )
   {
      RANGEMINMAX( 0, iCol1, ( SELF_COLCOUNT( oSelf ) - 1 ) )
      RANGEMINMAX( 0, iCol2, ( SELF_COLCOUNT( oSelf ) - 1 ) )
      RANGEMINMAX( 0, iRow1, ( SELF_ROWCOUNT( oSelf ) - 1 ) )
      RANGEMINMAX( 0, iRow2, ( SELF_ROWCOUNT( oSelf ) - 1 ) )
      LO_HI_AUX( iCol1, iCol2, iAux )
      LO_HI_AUX( iRow1, iRow2, iAux )

      bHorizontal = bVertical = bChange = 0;
      GetClientRect( oSelf->hWnd, &rect );
      lStyle = GetWindowLongPtr( oSelf->hWnd, GWL_STYLE );
      if( lStyle & WS_HSCROLL )
      {
         rect.bottom += GetSystemMetrics( SM_CYHSCROLL );
      }
      if( lStyle & WS_VSCROLL )
      {
         rect.right += GetSystemMetrics( SM_CXVSCROLL );
      }
      if( ( rect.right - rect.left ) < ( SELF_COLCOUNT( oSelf ) * SELF_TEXTWIDTH( oSelf ) ) )
      {
         rect.bottom -= GetSystemMetrics( SM_CYHSCROLL );
         bHorizontal = 1;
      }
      if( ( rect.bottom - rect.top ) < ( SELF_ROWCOUNT( oSelf ) * SELF_TEXTHEIGHT( oSelf ) ) )
      {
         rect.right -= GetSystemMetrics( SM_CXVSCROLL );
         bVertical = 1;
      }
      if( ( rect.right - rect.left ) < ( SELF_COLCOUNT( oSelf ) * SELF_TEXTWIDTH( oSelf ) ) && ! bHorizontal )
      {
         rect.bottom -= GetSystemMetrics( SM_CYHSCROLL );
         bHorizontal = 1;
      }
      lStyle2 = ( lStyle &~ ( WS_HSCROLL | WS_VSCROLL ) ) |
                ( bHorizontal ? WS_HSCROLL : 0 )          |
                ( bVertical   ? WS_VSCROLL : 0 );
      if( lStyle != lStyle2 )
      {
         SetWindowLongPtr( oSelf->hWnd, GWL_STYLE, lStyle2 );
         RePaint( oSelf, NULL, NULL );
         bChange = 1;
      }
      if( bHorizontal )
      {
         ScrollInfo.cbSize = sizeof( SCROLLINFO );
         ScrollInfo.fMask = SIF_PAGE | SIF_POS | SIF_RANGE | SIF_TRACKPOS;
         GetScrollInfo( oSelf->hWnd, SB_HORZ, &ScrollInfo );
         if( ( LONG ) ScrollInfo.nPage != ( rect.right - rect.left ) || ScrollInfo.nMax != ( SELF_COLCOUNT( oSelf ) * SELF_TEXTWIDTH( oSelf ) ) - 1 )
         {
            iPos = ScrollInfo.nPos;
            ScrollInfo.fMask = SIF_PAGE | SIF_RANGE;
            ScrollInfo.nPage = rect.right - rect.left;
            ScrollInfo.nMin  = 0;
            ScrollInfo.nMax  = ( SELF_COLCOUNT( oSelf ) * SELF_TEXTWIDTH( oSelf ) ) - 1;
            SetScrollInfo( oSelf->hWnd, SB_HORZ, &ScrollInfo, 1 );
            ScrollInfo.fMask = SIF_PAGE | SIF_POS | SIF_RANGE | SIF_TRACKPOS;
            GetScrollInfo( oSelf->hWnd, SB_HORZ, &ScrollInfo );
            if( iPos != ScrollInfo.nPos )
            {
               bChange = 1;
            }
         }
      }
      if( bVertical )
      {
         ScrollInfo.cbSize = sizeof( SCROLLINFO );
         ScrollInfo.fMask = SIF_PAGE | SIF_POS | SIF_RANGE | SIF_TRACKPOS;
         GetScrollInfo( oSelf->hWnd, SB_VERT, &ScrollInfo );
         if( ( LONG ) ScrollInfo.nPage != ( rect.bottom - rect.top ) || ScrollInfo.nMax != ( SELF_ROWCOUNT( oSelf ) * SELF_TEXTHEIGHT( oSelf ) ) - 1 )
         {
            iPos = ScrollInfo.nPos;
            ScrollInfo.fMask = SIF_PAGE | SIF_RANGE;
            ScrollInfo.nPage = rect.bottom - rect.top;
            ScrollInfo.nMin  = 0;
            ScrollInfo.nMax  = ( SELF_ROWCOUNT( oSelf ) * SELF_TEXTHEIGHT( oSelf ) ) - 1;
            SetScrollInfo( oSelf->hWnd, SB_VERT, &ScrollInfo, 1 );
            ScrollInfo.fMask = SIF_PAGE | SIF_POS | SIF_RANGE | SIF_TRACKPOS;
            GetScrollInfo( oSelf->hWnd, SB_VERT, &ScrollInfo );
            if( iPos != ScrollInfo.nPos )
            {
               bChange = 1;
            }
         }
      }

      if( bChange )
      {
         SetWindowPos( oSelf->hWnd, 0, 0, 0, 0, 0, SWP_NOSIZE | SWP_NOMOVE | SWP_NOZORDER | SWP_FRAMECHANGED | SWP_NOCOPYBITS | SWP_NOOWNERZORDER | SWP_NOSENDCHANGING );
      }
      else
      {
         iAux = rect.left - ( bHorizontal ? GetScrollPos( oSelf->hWnd, SB_HORZ ) : 0 );
         iCol1 = (   iCol1       * SELF_TEXTWIDTH( oSelf ) ) + iAux;
         iCol2 = ( ( iCol2 + 1 ) * SELF_TEXTWIDTH( oSelf ) ) + iAux;
         iAux = rect.top - ( bVertical ? GetScrollPos( oSelf->hWnd, SB_VERT ) : 0 );
         iRow1 = (   iRow1       * SELF_TEXTHEIGHT( oSelf ) ) + iAux;
         iRow2 = ( ( iRow2 + 1 ) * SELF_TEXTHEIGHT( oSelf ) ) + iAux;
         RANGEMINMAX( rect.left, iCol1, rect.right )
         RANGEMINMAX( rect.left, iCol2, rect.right )
         RANGEMINMAX( rect.top, iRow1, rect.bottom )
         RANGEMINMAX( rect.top, iRow2, rect.bottom )
         if( iCol1 != iCol2 && iRow1 != iRow2 )
         {
            rect.top    = iRow1;
            rect.bottom = iRow2;
            rect.left   = iCol1;
            rect.right  = iCol2;
            RePaint( oSelf, NULL, NULL );
         }
      }
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static void DrawCursor( POCTRL oSelf, BOOL bStatus )
{
   HDC hDC;
   HFONT hFont;
   COLORREF FontColor, BackColor;
   PCHARCELL pCell;
   RECT rect, rect2, rect3;

   if( SELF_CURSORTYPE( oSelf ) && oSelf->AuxBuffer && SELF_COLCOUNT( oSelf ) && SELF_ROWCOUNT( oSelf ) &&
       SELF_COL( oSelf ) < SELF_COLCOUNT( oSelf ) && SELF_ROW( oSelf ) < SELF_ROWCOUNT( oSelf ) )
   {
      GetClientRect( oSelf->hWnd, &rect );
      rect2.left   = ( SELF_COL( oSelf ) * SELF_TEXTWIDTH( oSelf ) ) - GetScrollPos( oSelf->hWnd, SB_HORZ ) + rect.left;
      rect2.top    = ( SELF_ROW( oSelf ) * SELF_TEXTHEIGHT( oSelf ) ) - GetScrollPos( oSelf->hWnd, SB_VERT ) + rect.top;
      rect2.right  = rect2.left + SELF_TEXTWIDTH( oSelf );
      rect2.bottom = rect2.top  + SELF_TEXTHEIGHT( oSelf );
      rect3.top    = rect2.top;
      rect3.left   = rect2.left;
      rect3.bottom = rect2.bottom;
      rect3.right  = rect2.right;
      switch( SELF_CURSORTYPE( oSelf ) )
      {
         case 2:   // Bottom line
            rect3.top = rect2.top + ( ( SELF_TEXTHEIGHT( oSelf ) * 3 ) / 4 );
            break;

         case 3:   // Left line
            rect3.right  = rect2.left + ( SELF_TEXTWIDTH( oSelf ) / 4 );
            break;
      }
      if( ! ( rect3.right <= rect.left || rect3.left >= rect.right ||
              rect3.bottom <= rect.top || rect3.top >= rect.bottom ) )
      {
         RANGEMINMAX( rect.top, rect3.top,    rect.bottom )
         RANGEMINMAX( rect.top, rect3.bottom, rect.bottom )
         RANGEMINMAX( rect.left, rect3.left,  rect.right )
         RANGEMINMAX( rect.left, rect3.right, rect.right )
         hDC = GetDC( oSelf->hWnd );
         hFont = (HFONT) SelectObject( hDC, oSelf->hFontHandle );
         pCell = &( ( ( PCHARCELL ) oSelf->AuxBuffer )[ ( SELF_ROW( oSelf ) * SELF_COLCOUNT( oSelf ) ) + SELF_COL( oSelf ) ] );
         if( bStatus )
         {
            FontColor = SetTextColor( hDC, pCell->BackColor );
            BackColor = SetBkColor(   hDC, pCell->FontColor );
         }
         else
         {
            FontColor = SetTextColor( hDC, pCell->FontColor );
            BackColor = SetBkColor(   hDC, pCell->BackColor );
         }
         SetTextAlign( hDC, TA_LEFT );  // TA_CENTER
         ExtTextOut( hDC, rect2.left, rect2.top, ETO_CLIPPED | ETO_OPAQUE, &rect3, ( char * ) &( pCell->character ), 1, NULL );
         SetTextColor( hDC, FontColor );
         SetBkColor( hDC, BackColor );
         if( hFont )
         {
            SelectObject( hDC, hFont );
         }
         ReleaseDC( oSelf->hWnd, hDC );
      }
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TTEXTARRAY_EVENTS )          /* METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TTextArray -> uRetVal */
{
   HWND hWnd      = HWNDparam( 1 );
   UINT message   = ( UINT )   hb_parni( 2 );
   WPARAM wParam  = ( WPARAM ) HB_PARNL( 3 );
   LPARAM lParam  = ( LPARAM ) HB_PARNL( 4 );
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf   = _OOHG_GetControlInfo( pSelf );

   switch( message )
   {
      case WM_PAINT:
         {
            PAINTSTRUCT ps;
            HDC         hdc;
            RECT        updateRect;

            if ( ! GetUpdateRect( hWnd, &updateRect, FALSE ) )
            {
               hb_retni( 0 );
            }
            else
            {
               hdc = BeginPaint( hWnd, &ps );
               RePaint( oSelf, hdc, &updateRect );
               EndPaint( hWnd, &ps );
               hb_retni( 1 );
            }
         }
         break;

      case WM_HSCROLL:
         {
            int iOldPos, iNewPos;
            SCROLLINFO ScrollInfo;

            ScrollInfo.cbSize = sizeof( SCROLLINFO );
            ScrollInfo.fMask = SIF_PAGE | SIF_POS | SIF_RANGE | SIF_TRACKPOS;
            GetScrollInfo( oSelf->hWnd, SB_HORZ, &ScrollInfo );
            iOldPos = ScrollInfo.nPos;
            iNewPos = ScrollInfo.nPos;
            switch( LOWORD( wParam ) )
            {
               case SB_LINERIGHT:
                  if( iNewPos < ScrollInfo.nMax )
                  {
                     iNewPos++;
                  }
                  break;

               case SB_LINELEFT:
                  if( iNewPos > ScrollInfo.nMin )
                  {
                     iNewPos--;
                  }
                  break;

               case SB_PAGELEFT:
                  if( iNewPos > ScrollInfo.nMin )
                  {
                     iNewPos -= ( ( ( iNewPos - ScrollInfo.nMin ) < ( int ) ScrollInfo.nPage ) ? ( iNewPos - ScrollInfo.nMin ) : (int) ScrollInfo.nPage );
                  }
                  break;

               case SB_PAGERIGHT:
                  if( iNewPos < ScrollInfo.nMax )
                  {
                     iNewPos += ( ( ( ScrollInfo.nMax - iNewPos ) < ( int ) ScrollInfo.nPage ) ? ( ScrollInfo.nMax - iNewPos ) : (int) ScrollInfo.nPage );
                  }
                  break;

               case SB_LEFT:
                  iNewPos = ScrollInfo.nMin;
                  break;

               case SB_RIGHT:
                  iNewPos = ScrollInfo.nMax;
                  break;

               case SB_THUMBPOSITION:
                  iNewPos = HIWORD( wParam );
                  break;

               case SB_THUMBTRACK:
                  iNewPos = HIWORD( wParam );
                  break;

            }
            if( iOldPos != iNewPos && oSelf->AuxBuffer && SELF_COLCOUNT( oSelf ) && SELF_ROWCOUNT( oSelf ) )
            {
               SetScrollPos( oSelf->hWnd, SB_HORZ, iNewPos, 1 );
               RePaint( oSelf, NULL, NULL );
               hb_ret();
            }
         }
         break;

      case WM_VSCROLL:
         {
            int iOldPos, iNewPos;
            SCROLLINFO ScrollInfo;

            ScrollInfo.cbSize = sizeof( SCROLLINFO );
            ScrollInfo.fMask = SIF_PAGE | SIF_POS | SIF_RANGE | SIF_TRACKPOS;
            GetScrollInfo( oSelf->hWnd, SB_VERT, &ScrollInfo );
            iOldPos = ScrollInfo.nPos;
            iNewPos = ScrollInfo.nPos;
            switch( LOWORD( wParam ) )
            {
               case SB_LINEDOWN:
                  if( iNewPos < ScrollInfo.nMax )
                  {
                     iNewPos++;
                  }
                  break;

               case SB_LINEUP:
                  if( iNewPos > ScrollInfo.nMin )
                  {
                     iNewPos--;
                  }
                  break;

               case SB_PAGEUP:
                  if( iNewPos > ScrollInfo.nMin )
                  {
                     iNewPos -= ( ( ( iNewPos - ScrollInfo.nMin ) < ( int ) ScrollInfo.nPage ) ? ( iNewPos - ScrollInfo.nMin ) : (int) ScrollInfo.nPage );
                  }
                  break;

               case SB_PAGEDOWN:
                  if( iNewPos < ScrollInfo.nMax )
                  {
                     iNewPos += ( ( ( ScrollInfo.nMax - iNewPos ) < ( int ) ScrollInfo.nPage ) ? ( ScrollInfo.nMax - iNewPos ) : (int) ScrollInfo.nPage );
                  }
                  break;

               case SB_TOP:
                  iNewPos = ScrollInfo.nMin;
                  break;

               case SB_BOTTOM:
                  iNewPos = ScrollInfo.nMax;
                  break;

               case SB_THUMBPOSITION:
                  iNewPos = HIWORD( wParam );
                  break;

               case SB_THUMBTRACK:
                  iNewPos = HIWORD( wParam );
                  break;

            }
            if( iOldPos != iNewPos && oSelf->AuxBuffer && SELF_COLCOUNT( oSelf ) && SELF_ROWCOUNT( oSelf ) )
            {
               SetScrollPos( oSelf->hWnd, SB_VERT, iNewPos, 1 );
               RePaint( oSelf, NULL, NULL );
               hb_ret();
            }
         }
         break;

/*
      case WM_MOUSEWHEEL:
               _OOHG_Send( pSelf, s_Events_VScroll );
               hb_vmPushLong( ( HIWORD( wParam ) == WHEEL_DELTA ) ? SB_LINEUP : SB_LINEDOWN );
               hb_vmSend( 1 );
         hb_ret();
         break;
*/

      case WM_SETFOCUS:
         _OOHG_Send( pSelf, s_Parent );
         hb_vmSend( 0 );
         _OOHG_Send( hb_param( -1, HB_IT_OBJECT ), s_hWnd );
         hb_vmSend( 0 );
         PostMessage( GetParent( hWnd ), WM_COMMAND, MAKEWPARAM( LOWORD( wParam ), ( WORD ) EN_SETFOCUS ), ( LPARAM ) hWnd );
         hb_ret();
         break;

      case WM_KILLFOCUS:
         _OOHG_Send( pSelf, s_Parent );
         hb_vmSend( 0 );
         _OOHG_Send( hb_param( -1, HB_IT_OBJECT ), s_hWnd );
         hb_vmSend( 0 );
         PostMessage( GetParent( hWnd ), WM_COMMAND, MAKEWPARAM( LOWORD( wParam ), ( WORD ) EN_KILLFOCUS ), ( LPARAM ) hWnd );
         hb_ret();
         break;

      case WM_LBUTTONUP:
         {
            SendMessage( GetParent( hWnd ), WM_COMMAND, MAKEWORD( STN_CLICKED, 0 ), ( LPARAM ) hWnd );
         }
         break;

      default:
         _OOHG_Send( pSelf, s_Super );
         hb_vmSend( 0 );
         _OOHG_Send( hb_param( -1, HB_IT_OBJECT ), s_Events );
         HWNDpush( hWnd );
         hb_vmPushLong( message );
         hb_vmPushNumInt( wParam );
         hb_vmPushNumInt( lParam );
         hb_vmSend( 4 );
         break;
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TTEXTARRAY_SETFONTSIZE )          /* FUNCTION TTextArray_SetFontSize( Self ) -> NIL */
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
      hFont = (HFONT) SelectObject( hDC, oSelf->hFontHandle );
      GetTextExtentPoint32( hDC, "W", 1, &sz );
      if( hFont )
      {
         SelectObject( hDC, hFont );
      }
      ReleaseDC( oSelf->hWnd, hDC );

      SELF_TEXTWIDTH( oSelf ) = sz.cx;
      SELF_TEXTHEIGHT( oSelf ) = sz.cy;
      RePaint( oSelf, NULL, NULL );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TTEXTARRAY_MAXCHARS )          /* FUNCTION TTextArray_SetFontSize( Self, nOrd ) -> NIL */
{
   PHB_ITEM pSelf;
   POCTRL oSelf;
   RECT rect;
   int iRet = 0;

   pSelf = hb_param( 1, HB_IT_OBJECT );
   if( pSelf )
   {
      oSelf = _OOHG_GetControlInfo( pSelf );
      GetClientRect( oSelf->hWnd, &rect );

      if( hb_parni( 2 ) )   // == 1
      {
         iRet = ( rect.right - rect.left ) / SELF_TEXTWIDTH( oSelf );
      }
      else
      {
         iRet = ( rect.bottom - rect.top ) / SELF_TEXTHEIGHT( oSelf );
      }
   }
   hb_retni( iRet );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TTEXTARRAY_CURSORTIMER )          /* FUNCTION TTextArray_CursorTimer( Self ) -> NIL */
{
   PHB_ITEM pSelf;
   POCTRL oSelf;

   pSelf = hb_param( 1, HB_IT_OBJECT );
   if( pSelf )
   {
      oSelf = _OOHG_GetControlInfo( pSelf );
      SELF_CURSORTIME( oSelf ) = ! SELF_CURSORTIME( oSelf );
      DrawCursor( oSelf, SELF_CURSORTIME( oSelf ) );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static void TTextArray_Scroll( POCTRL oSelf, int iCol1, int iRow1, int iCol2, int iRow2, int iVert, int iHoriz )
{
   int iAux, iDelta, iRow;
   PCHARCELL pCell;

   if( oSelf->AuxBuffer && SELF_COLCOUNT( oSelf ) && SELF_ROWCOUNT( oSelf ) )
   {
      RANGEMINMAX( 0, iCol1, ( SELF_COLCOUNT( oSelf ) - 1 ) )
      RANGEMINMAX( 0, iCol2, ( SELF_COLCOUNT( oSelf ) - 1 ) )
      RANGEMINMAX( 0, iRow1, ( SELF_ROWCOUNT( oSelf ) - 1 ) )
      RANGEMINMAX( 0, iRow2, ( SELF_ROWCOUNT( oSelf ) - 1 ) )
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
            memcpy( &pCell[ ( iRow * SELF_COLCOUNT( oSelf ) ) + iCol1 ], &pCell[ ( ( iRow + iVert ) * SELF_COLCOUNT( oSelf ) ) + iCol1 ], ( sizeof( CHARCELL ) * ( iCol2 - iCol1 + 1 ) ) );
            iRow++;
            iDelta--;
         }
         while( iVert )
         {
            for( iAux = iCol1; iAux <= iCol2; iAux++ )
            {
               TTextArray_Empty( &pCell[ ( iRow * SELF_COLCOUNT( oSelf ) ) + iAux ], oSelf );
            }
            iRow++;
            iVert--;
         }
      }
      else if( iVert < 0 )
      {
         iDelta = iRow2 - iRow1 + 1 + iVert;
         iRow = iRow2;
         while( iDelta )
         {
            memcpy( &pCell[ ( iRow * SELF_COLCOUNT( oSelf ) ) + iCol1 ], &pCell[ ( ( iRow + iVert ) * SELF_COLCOUNT( oSelf ) ) + iCol1 ], ( sizeof( CHARCELL ) * ( iCol2 - iCol1 + 1 ) ) );
            iRow--;
            iDelta--;
         }
         while( iVert )
         {
            for( iAux = iCol1; iAux <= iCol2; iAux++ )
            {
               TTextArray_Empty( &pCell[ ( iRow * SELF_COLCOUNT( oSelf ) ) + iAux ], oSelf );
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
            memcpy( &pCell[ ( iRow * SELF_COLCOUNT( oSelf ) ) + iCol1 ], &pCell[ ( iRow * SELF_COLCOUNT( oSelf ) ) + iCol1 + iHoriz ], ( sizeof( CHARCELL ) * iDelta ) );
            for( iAux = iCol1 + iDelta; iAux <= iCol2; iAux++ )
            {
               TTextArray_Empty( &pCell[ ( iRow * SELF_COLCOUNT( oSelf ) ) + iAux ], oSelf );
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
               memcpy( &pCell[ ( iRow * SELF_COLCOUNT( oSelf ) ) + iAux ], &pCell[ ( iRow * SELF_COLCOUNT( oSelf ) ) + iAux + iHoriz ], sizeof( CHARCELL ) );
            }
            for( ; iAux >= iCol1; iAux-- )
            {
               TTextArray_Empty( &pCell[ ( iRow * SELF_COLCOUNT( oSelf ) ) + iAux ], oSelf );
            }
            iRow++;
         }
      }
      Redraw( oSelf, iCol1, iRow1, iCol2, iRow2 );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static void TTextArray_ReSize( POCTRL oSelf, int iRow, int iCol )
{
   int iOldRow, iOldCol, x, y, iCopy;
   ULONG lSize;
   BYTE *pBuffer;
   PCHARCELL pCell;

   if( ! oSelf->AuxBuffer )
   {
      SELF_COLCOUNT( oSelf ) = 0;
      SELF_ROWCOUNT( oSelf ) = 0;
      oSelf->AuxBufferLen = 0;
   }
   iOldRow = SELF_ROWCOUNT( oSelf );
   iOldCol = SELF_COLCOUNT( oSelf );

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
      pBuffer = (BYTE *) hb_xgrab( sizeof( CHARCELL ) * iCol * iRow );
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
   SELF_COLCOUNT( oSelf ) = iCol;
   SELF_ROWCOUNT( oSelf ) = iRow;

   if( SELF_COL( oSelf ) >= iCol )
   {
      SELF_COL( oSelf ) = iCol - 1;
   }
   if( SELF_ROW( oSelf ) >= iRow )
   {
      SELF_ROW( oSelf ) = iRow - 1;
   }

   RePaint( oSelf, NULL, NULL );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static void TTextArray_Out( POCTRL oSelf, BYTE cByte, RECT *rect2 )
{
   PCHARCELL pCell;

   if( oSelf->AuxBuffer && SELF_COLCOUNT( oSelf ) && SELF_ROWCOUNT( oSelf ) )
   {
      if( SELF_COL( oSelf ) >= SELF_COLCOUNT( oSelf ) )
      {
         SELF_COL( oSelf ) = 0;
         SELF_ROW( oSelf )++;
      }
      if( SELF_ROW( oSelf ) >= SELF_ROWCOUNT( oSelf ) )
      {
         SELF_ROW( oSelf ) = SELF_ROWCOUNT( oSelf ) - 1;
         TTextArray_Scroll( oSelf, 0, 0, SELF_COLCOUNT( oSelf ) - 1, SELF_ROWCOUNT( oSelf ) - 1, 1, 0 );
      }

      pCell = &( ( ( PCHARCELL ) oSelf->AuxBuffer )[ ( SELF_ROW( oSelf ) * SELF_COLCOUNT( oSelf ) ) + SELF_COL( oSelf ) ] );
      pCell->character = cByte;
      pCell->FontColor = oSelf->lFontColor;
      pCell->BackColor = oSelf->lBackColor;

      if( rect2 )
      {
         if( SELF_ROW( oSelf ) < rect2->top )    rect2->top    = SELF_ROW( oSelf );
         if( SELF_COL( oSelf ) < rect2->left )   rect2->left   = SELF_COL( oSelf );
         if( SELF_ROW( oSelf ) > rect2->bottom ) rect2->bottom = SELF_ROW( oSelf );
         if( SELF_COL( oSelf ) > rect2->right )  rect2->right  = SELF_COL( oSelf );
      }
      else
      {
         Redraw( oSelf, SELF_COL( oSelf ), SELF_ROW( oSelf ), SELF_COL( oSelf ), SELF_ROW( oSelf ) );
      }

      SELF_COL( oSelf )++;
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static void TTextArray_MoveTo( POCTRL oSelf, int iRow, int iCol )
{
   DrawCursor( oSelf, 0 );
   if( iRow < 0 )
   {
      iRow = 0;
   }
   else if( iRow >= SELF_ROWCOUNT( oSelf ) )
   {
      iRow = SELF_ROWCOUNT( oSelf ) - 1;
   }
   SELF_ROW( oSelf ) = iRow;

   if( iCol < 0 )
   {
      iCol = 0;
   }
   SELF_COL( oSelf ) = iCol;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TTEXTARRAY_ROWCOUNT )          /* METHOD RowCount( nRowCount ) CLASS TTextArray -> nRowCount */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( hb_pcount() >= 1 && HB_ISNUM( 1 ) )
   {
      TTextArray_ReSize( oSelf, hb_parni( 1 ), SELF_COLCOUNT( oSelf ) );
   }

   hb_retni( SELF_ROWCOUNT( oSelf ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TTEXTARRAY_COLCOUNT )          /* METHOD ColCount( nColCount ) CLASS TTextArray -> nColCount */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( hb_pcount() >= 1 && HB_ISNUM( 1 ) )
   {
      TTextArray_ReSize( oSelf, SELF_ROWCOUNT( oSelf ), hb_parni( 1 ) );
   }

   hb_retni( SELF_COLCOUNT( oSelf ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TTEXTARRAY_TEXTROW )          /* METHOD TextRow( nRow ) CLASS TTextArray -> nRow */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( hb_pcount() >= 1 && HB_ISNUM( 1 ) )
   {
      TTextArray_MoveTo( oSelf, hb_parni( 1 ), SELF_COL( oSelf ) );
   }

   hb_retni( SELF_ROW( oSelf ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TTEXTARRAY_TEXTCOL )          /* METHOD TextCol( nCol ) CLASS TTextArray -> nCol */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( hb_pcount() >= 1 && HB_ISNUM( 1 ) )
   {
      TTextArray_MoveTo( oSelf, SELF_ROW( oSelf ), hb_parni( 1 ) );
   }

   hb_retni( SELF_COL( oSelf ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TTEXTARRAY_WRITE )          /* METHOD Write( cText, nCol, nRow, uFontColor, uBackColor ) CLASS TTextArray -> NIL */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   BYTE *pBuffer, cByte;
   ULONG lBuffer;
   LONG lFontColor, lBackColor, lAuxColor;
   int iRow, iCol;
   RECT rect;

   rect.top    = SELF_ROWCOUNT( oSelf );
   rect.bottom = 0;
   rect.left   = SELF_COLCOUNT( oSelf );
   rect.right  = 0;

   iCol = HB_ISNUM( 3 ) ? hb_parni( 3 ) : SELF_COL( oSelf );
   iRow = HB_ISNUM( 2 ) ? hb_parni( 2 ) : SELF_ROW( oSelf );
   TTextArray_MoveTo( oSelf, iRow, iCol );

   lFontColor = oSelf->lFontColor;
   lBackColor = oSelf->lBackColor;
   lAuxColor = -1;
   if( _OOHG_DetermineColor( hb_param( 4, HB_IT_ANY ), &lAuxColor ) )
   {
      oSelf->lFontColor = lAuxColor;
   }
   lAuxColor = -1;
   if( _OOHG_DetermineColor( hb_param( 5, HB_IT_ANY ), &lAuxColor ) )
   {
      oSelf->lBackColor = lAuxColor;
   }

   if( HB_ISCHAR( 1 ) && oSelf->AuxBuffer && SELF_COLCOUNT( oSelf ) && SELF_ROWCOUNT( oSelf ) )
   {
      pBuffer = ( BYTE * ) hb_parc( 1 );
      lBuffer = hb_parclen( 1 );
      while( lBuffer )
      {
         cByte = *pBuffer++;
         switch( cByte )
         {
            case 13:
               SELF_COL( oSelf ) = 0;
               break;

            case 10:
               SELF_ROW( oSelf )++;
               if( SELF_ROW( oSelf ) >= SELF_ROWCOUNT( oSelf ) )
               {
                  SELF_ROW( oSelf ) = SELF_ROWCOUNT( oSelf ) - 1;
                  TTextArray_Scroll( oSelf, 0, 0, SELF_COLCOUNT( oSelf ) - 1, SELF_ROWCOUNT( oSelf ) - 1, 1, 0 );
               }
               break;

            default:
               TTextArray_Out( oSelf, cByte, &rect );
               break;
         }
         lBuffer--;
      }
   }

   oSelf->lFontColor = lFontColor;
   oSelf->lBackColor = lBackColor;

   if( rect.top <= rect.bottom && rect.left <= rect.right )
   {
      Redraw( oSelf, rect.left, rect.top, rect.right, rect.bottom );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TTEXTARRAY_WRITERAW )          /* METHOD WriteRaw( cText, nCol, nRow, uFontColor, uBackColor ) CLASS TTextArray -> NIL */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   BYTE *pBuffer;
   ULONG lBuffer;
   LONG lFontColor, lBackColor, lAuxColor;
   int iRow, iCol;
   RECT rect;

   rect.top    = SELF_ROWCOUNT( oSelf );
   rect.bottom = 0;
   rect.left   = SELF_COLCOUNT( oSelf );
   rect.right  = 0;

   iCol = HB_ISNUM( 3 ) ? hb_parni( 3 ) : SELF_COL( oSelf );
   iRow = HB_ISNUM( 2 ) ? hb_parni( 2 ) : SELF_ROW( oSelf );
   TTextArray_MoveTo( oSelf, iRow, iCol );

   lFontColor = oSelf->lFontColor;
   lBackColor = oSelf->lBackColor;
   lAuxColor = -1;
   if( _OOHG_DetermineColor( hb_param( 4, HB_IT_ANY ), &lAuxColor ) )
   {
      oSelf->lFontColor = lAuxColor;
   }
   lAuxColor = -1;
   if( _OOHG_DetermineColor( hb_param( 5, HB_IT_ANY ), &lAuxColor ) )
   {
      oSelf->lBackColor = lAuxColor;
   }

   if( HB_ISCHAR( 1 ) && oSelf->AuxBuffer && SELF_COLCOUNT( oSelf ) && SELF_ROWCOUNT( oSelf ) )
   {
      pBuffer = ( BYTE * ) hb_parc( 1 );
      lBuffer = hb_parclen( 1 );
      while( lBuffer )
      {
         TTextArray_Out( oSelf, *pBuffer++, &rect );
         lBuffer--;
      }
   }

   oSelf->lFontColor = lFontColor;
   oSelf->lBackColor = lBackColor;

   if( rect.top <= rect.bottom && rect.left <= rect.right )
   {
      Redraw( oSelf, rect.left, rect.top, rect.right, rect.bottom );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TTEXTARRAY_CURSORTYPE )          /* METHOD CursorType( nCursorType ) CLASS TTextArray -> nCursorType */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( hb_pcount() >= 1 && HB_ISNUM( 1 ) )
   {
      DrawCursor( oSelf, 0 );
      SELF_CURSORTYPE( oSelf ) = hb_parni( 1 );
   }

   hb_retni( SELF_CURSORTYPE( oSelf ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TTEXTARRAY_SCROLL )          /* METHOD Scroll( nTop, nLeft, nBottom, nRight, nVertical, nHorizontal ) CLASS TTextArray -> NIL */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   int iCol1, iRow1, iCol2, iRow2, iVert, iHoriz;

   if( oSelf->AuxBuffer && SELF_COLCOUNT( oSelf ) && SELF_ROWCOUNT( oSelf ) )
   {
      iCol1  = HB_ISNUM( 2 ) ? hb_parni( 2 ) : 0;
      iRow1  = HB_ISNUM( 1 ) ? hb_parni( 1 ) : 0;
      iCol2  = HB_ISNUM( 4 ) ? hb_parni( 4 ) : SELF_COLCOUNT( oSelf ) - 1;
      iRow2  = HB_ISNUM( 3 ) ? hb_parni( 3 ) : SELF_ROWCOUNT( oSelf ) - 1;
      iVert  = HB_ISNUM( 5 ) ? hb_parni( 5 ) : 0;
      iHoriz = HB_ISNUM( 6 ) ? hb_parni( 6 ) : 0;

      TTextArray_Scroll( oSelf, iCol1, iRow1, iCol2, iRow2, iVert, iHoriz );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TTEXTARRAY_CLEAR )          /* METHOD Clear( nTop, nLeft, nBottom, nRight ) CLASS TTextArray -> NIL */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   int iCol, iCol1, iRow1, iCol2, iRow2;

   if( oSelf->AuxBuffer && SELF_COLCOUNT( oSelf ) && SELF_ROWCOUNT( oSelf ) )
   {
      iCol1  = HB_ISNUM( 2 ) ? hb_parni( 2 ) : 0;
      iRow1  = HB_ISNUM( 1 ) ? hb_parni( 1 ) : 0;
      iCol2  = HB_ISNUM( 4 ) ? hb_parni( 4 ) : SELF_COLCOUNT( oSelf ) - 1;
      iRow2  = HB_ISNUM( 3 ) ? hb_parni( 3 ) : SELF_ROWCOUNT( oSelf ) - 1;

      RANGEMINMAX( 0, iCol1, ( SELF_COLCOUNT( oSelf ) - 1 ) )
      RANGEMINMAX( 0, iCol2, ( SELF_COLCOUNT( oSelf ) - 1 ) )
      RANGEMINMAX( 0, iRow1, ( SELF_ROWCOUNT( oSelf ) - 1 ) )
      RANGEMINMAX( 0, iRow2, ( SELF_ROWCOUNT( oSelf ) - 1 ) )
      LO_HI_AUX( iCol1, iCol2, iCol )
      LO_HI_AUX( iRow1, iRow2, iCol )

      while( iRow1 <= iRow2 )
      {
         for( iCol = iCol1; iCol <= iCol2; iCol++ )
         {
            TTextArray_Empty( &( ( ( PCHARCELL )( oSelf->AuxBuffer ) )[ ( iRow1 * SELF_COLCOUNT( oSelf ) ) + iCol ] ), oSelf );
         }
         iRow1++;
      }
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TTEXTARRAY_DEVPOS )          /* METHOD DevPos( nRow, nCol ) CLASS TTextArray -> NIL */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   int iRow, iCol;

   iRow = HB_ISNUM( 1 ) ? hb_parni( 1 ) : SELF_ROW( oSelf );
   iCol = HB_ISNUM( 2 ) ? hb_parni( 2 ) : SELF_COL( oSelf );
   TTextArray_MoveTo( oSelf, iRow, iCol );
   hb_ret();
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TTEXTARRAY_ASSUMEFIXED )          /* METHOD AssumeFixed( lAssumeFixed ) CLASS TTextArray -> lAssumeFixed */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( HB_ISLOG( 1 ) )
   {
      SELF_FIXED( oSelf ) = hb_parl( 1 );
   }

   hb_retl( SELF_FIXED( oSelf ) );
}

#pragma ENDDUMP
