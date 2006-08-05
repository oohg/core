/*
 * $Id: h_progressmeter.prg,v 1.9 2006-08-05 22:14:20 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG progress meter functions
 *
 * Copyright 2005 Vicente Guerra <vicente@guerra.com.mx>
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

CLASS TProgressMeter FROM TLabel
   DATA Type        INIT "PROGRESSMETER" READONLY
   DATA nRangeMin   INIT 0
   DATA nRangeMax   INIT 100
   DATA nPercent    INIT 0
   DATA nValue      INIT 0
   DATA nWidth      INIT 100
   DATA nHeight     INIT 18

   METHOD Define
   METHOD Value               SETGET
   METHOD ReCalc

   METHOD RangeMin            SETGET
   METHOD RangeMax            SETGET

   METHOD Events
   METHOD SetPercent
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, lo, hi, value, tooltip, ;
               fontname, fontsize, bold, italic, underline, strikeout, ;
               FontColor, BackColor, ProcedureName, HelpId, invisible, lRtl, ;
               CLIENTEDGE ) CLASS TProgressMeter
*-----------------------------------------------------------------------------*
Local ControlHandle, nStyle, nStyleEx

   IF FontColor != NIL
      ::FontColor := FontColor
   ENDIF
   IF ::FontColor == NIL
      ::FontColor := { 255, 255, 255 }
   ENDIF

   IF BackColor != NIL
      ::BackColor := BackColor
   ENDIF
   IF ::BackColor == NIL
      ::BackColor := { 0, 0, 255 }
   ENDIF

   ASSIGN ::nCol        VALUE x TYPE "N"
   ASSIGN ::nRow        VALUE y TYPE "N"
   ASSIGN ::nWidth      VALUE w TYPE "N"
   ASSIGN ::nHeight     VALUE h TYPE "N"
   ASSIGN invisible     VALUE invisible    TYPE "L" DEFAULT .F.

   ::SetForm( ControlName, ParentForm, FontName, FontSize, ::FontColor, ::BackColor, , lRtl )

   nStyle := if( ValType( invisible ) != "L" .OR. ! invisible, WS_VISIBLE,  0 )

   nStyleEx := if( ValType( CLIENTEDGE ) == "L"   .AND. CLIENTEDGE,   WS_EX_CLIENTEDGE,  0 )

   Controlhandle := InitLabel( ::ContainerhWnd, "", 0, ::ContainerCol, ::ContainerRow, ::nWidth, ::nHeight, '', 0, Nil , nStyle, nStyleEx, ::lRtl )

   ::Register( ControlHandle, ControlName, HelpId, ! Invisible, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   ::OnClick := ProcedureName

   ::RangeMin := lo
   ::RangeMax := hi

   ::Value := If( Valtype( value ) == "N", value, ::RangeMin )
   ::ReCalc( .T. )

Return Self

*------------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TProgressMeter
*------------------------------------------------------------------------------*
   IF VALTYPE( uValue ) == "N"
      ::nValue := uValue
      ::ReCalc()
   ENDIF
RETURN ::nValue

*------------------------------------------------------------------------------*
METHOD ReCalc( lForce ) CLASS TProgressMeter
*------------------------------------------------------------------------------*
Local nPercent
   IF ValType( lForce ) != "L"
      lForce := .F.
   ENDIF
   nPercent := ( ::nValue - ::RangeMin ) / ( ::RangeMax - ::RangeMin )
   ::SetPercent( nPercent * 100, lForce )
RETURN nil

*------------------------------------------------------------------------------*
METHOD RangeMin( uValue ) CLASS TProgressMeter
*------------------------------------------------------------------------------*
   IF VALTYPE( uValue ) == "N"
      ::nRangeMin := uValue
      ::ReCalc()
   ENDIF
RETURN ::nRangeMin

*------------------------------------------------------------------------------*
METHOD RangeMax( uValue ) CLASS TProgressMeter
*------------------------------------------------------------------------------*
   IF VALTYPE( uValue ) == "N"
      ::nRangeMax := uValue
      ::ReCalc()
   ENDIF
RETURN ::nRangeMax

#pragma BEGINDUMP

#define s_Super s_TLabel

#include "hbapi.h"
#include "hbapiitm.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windows.h>
#include <commctrl.h>
#include "../include/oohg.h"

// lAux[ 0 ] = Percent

HB_FUNC_STATIC( TPROGRESSMETER_EVENTS )
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
            COLORREF    FontColor, BackColor, xFont, xBack;
            int         x, iWidth1, iWidth2;
            char        cPercent[ 100 ];

            if ( ! GetUpdateRect( hWnd, &updateRect, FALSE ) )
            {
               hb_retni( 0 );
            }
            else
            {
               GetClientRect( hWnd, &rect2 );
               iWidth2 = rect2.right - rect2.left;
               x = iWidth2 / 2;
               iWidth1 = iWidth2 * oSelf->lAux[ 0 ] / 10000;
               sprintf( cPercent, "%i%%", oSelf->lAux[ 0 ] / 100 );
               hdc = BeginPaint( hWnd, &ps );
               xFont = ( ( oSelf->lFontColor == -1 ) ? GetSysColor( COLOR_WINDOWTEXT ) : oSelf->lFontColor );
               xBack = ( ( oSelf->lBackColor == -1 ) ? GetSysColor( COLOR_WINDOW     ) : oSelf->lBackColor );
               FontColor = SetTextColor( hdc, xFont );
               BackColor = SetBkColor(   hdc, xBack );
               SetTextAlign( hdc, TA_CENTER );
               hOldFont = ( HFONT ) SelectObject( hdc, oSelf->hFontHandle );
               rect2.right = iWidth1;
               ExtTextOut( hdc, x, 0, ETO_CLIPPED | ETO_OPAQUE, &rect2, cPercent, strlen( cPercent ), NULL );
               rect2.left = iWidth1;
               rect2.right = iWidth2;
               SetTextColor( hdc, xBack );
               SetBkColor(   hdc, xFont );
               ExtTextOut( hdc, x, 0, ETO_CLIPPED | ETO_OPAQUE, &rect2, cPercent, strlen( cPercent ), NULL );
               SelectObject( hdc, hOldFont );
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

HB_FUNC_STATIC( TPROGRESSMETER_SETPERCENT )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   double dNum;
   LONG lNum;

   dNum = oSelf->lAux[ 0 ];
   hb_retnd( dNum / 100 );

   if( ISNUM( 1 ) )
   {
      dNum = hb_parnd( 1 ) * 100;
      if( dNum > 10000 )
      {
         lNum = 10000;
      }
      else if( dNum < 0 )
      {
         lNum = 0;
      }
      else
      {
         lNum = dNum;
      }
      if( lNum != oSelf->lAux[ 0 ] || ( ISLOG( 2 ) && hb_parl( 2 ) ) )
      {
         oSelf->lAux[ 0 ] = lNum;
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }
}

#pragma ENDDUMP
