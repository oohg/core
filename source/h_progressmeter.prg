/*
 * $Id: h_progressmeter.prg $
 */
/*
 * ooHG source code:
 * ProgressMeter control
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
   METHOD SetPercent          SETGET
   METHOD Align               SETGET

   ENDCLASS

METHOD Define( ControlName, ParentForm, x, y, w, h, lo, hi, value, tooltip, ;
               fontname, fontsize, bold, italic, underline, strikeout, ;
               FontColor, BackColor, ProcedureName, HelpId, invisible, lRtl, ;
               CLIENTEDGE, lDisabled ) CLASS TProgressMeter

   Local ControlHandle, nStyle, nStyleEx

   IF FontColor != NIL
      ::FontColor := FontColor
   ENDIF
   IF ::FontColor == NIL
      ::FontColor := 0xFFFFFF
   ENDIF

   IF BackColor != NIL
      ::BackColor := BackColor
   ENDIF
   IF ::BackColor == NIL
      ::BackColor := 0xFF0000
   ENDIF

   ASSIGN ::nCol        VALUE x TYPE "N"
   ASSIGN ::nRow        VALUE y TYPE "N"
   ASSIGN ::nWidth      VALUE w TYPE "N"
   ASSIGN ::nHeight     VALUE h TYPE "N"

   ::SetForm( ControlName, ParentForm, FontName, FontSize, ::FontColor, ::BackColor, , lRtl )

   ::Align := 6 // TA_CENTER

   nStyle := ::InitStyle( ,, Invisible, .T., lDisabled )

   nStyleEx := if( ValType( CLIENTEDGE ) == "L"   .AND. CLIENTEDGE,   WS_EX_CLIENTEDGE,  0 )

   Controlhandle := InitLabel( ::ContainerhWnd, "", 0, ::ContainerCol, ::ContainerRow, ::nWidth, ::nHeight, nStyle, nStyleEx, ::lRtl )

   ::Register( ControlHandle, ControlName, HelpId,, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   ::RangeMin := lo
   ::RangeMax := hi

   ::Value := If( Valtype( value ) == "N", value, ::RangeMin )
   ::ReCalc( .T. )

   ASSIGN ::OnClick     VALUE ProcedureName TYPE "B"

   Return Self

METHOD Value( uValue ) CLASS TProgressMeter

   IF VALTYPE( uValue ) == "N"
      ::nValue := uValue
      ::ReCalc()
   ENDIF

   RETURN ::nValue

METHOD ReCalc( lForce ) CLASS TProgressMeter

   Local nPercent

   IF ValType( lForce ) != "L"
      lForce := .F.
   ENDIF
   nPercent := ( ::nValue - ::RangeMin ) / ( ::RangeMax - ::RangeMin )
   ::SetPercent( nPercent * 100, lForce )

   RETURN nil

METHOD RangeMin( uValue ) CLASS TProgressMeter

   IF VALTYPE( uValue ) == "N"
      ::nRangeMin := uValue
      ::ReCalc()
   ENDIF

   RETURN ::nRangeMin

METHOD RangeMax( uValue ) CLASS TProgressMeter

   IF VALTYPE( uValue ) == "N"
      ::nRangeMax := uValue
      ::ReCalc()
   ENDIF

   RETURN ::nRangeMax


#pragma BEGINDUMP

#include "oohg.h"
#include "hbapiitm.h"
#include "hbvm.h"
#include "hbstack.h"

#define s_Super s_TLabel

/* lAux[ 0 ] = Percent
 * lAux[ 1 ] = Align
 */

void ProgressMeter_Paint( POCTRL oSelf, HDC hdc )
{
   HDC         hdc2;
   RECT        rect2;
   COLORREF    FontColor, BackColor, xFont, xBack;
   HFONT       hOldFont;
   int         x, iWidth1, iWidth2, len;
   char        cPercent[ 100 ], *txt;

   if( ! ValidHandler( oSelf->hWnd ) )
   {
      return;
   }

   hdc2 = hdc ? hdc : GetDC( oSelf->hWnd );

   GetClientRect( oSelf->hWnd, &rect2 );
   iWidth2 = rect2.right - rect2.left;
   iWidth1 = iWidth2 * oSelf->lAux[ 0 ] / 10000;
   if( ( oSelf->lAux[ 1 ] & TA_CENTER ) == TA_CENTER )
   {
      x = iWidth2 / 2;
   }
   else if( ( oSelf->lAux[ 1 ] & TA_RIGHT ) == TA_RIGHT )
   {
      x = iWidth2;
   }
   else
   {
      x = 0;
   }

   if( oSelf->AuxBuffer )
   {
      txt = (char *) oSelf->AuxBuffer;
   }
   else
   {
      sprintf( cPercent, "%i%%", (int)( oSelf->lAux[ 0 ] / 100 ) );
      txt = cPercent;
   }
   len = strlen( txt );

   xFont = ( ( oSelf->lFontColor == -1 ) ? GetSysColor( COLOR_WINDOWTEXT ) : (COLORREF) oSelf->lFontColor );
   xBack = ( ( oSelf->lBackColor == -1 ) ? GetSysColor( COLOR_WINDOW     ) : (COLORREF) oSelf->lBackColor );
   FontColor = SetTextColor( hdc2, xFont );
   BackColor = SetBkColor( hdc2, xBack );
   SetTextAlign( hdc2, oSelf->lAux[ 1 ] );
   hOldFont = (HFONT) SelectObject( hdc2, oSelf->hFontHandle );
   rect2.right = iWidth1;
   ExtTextOut( hdc2, x, 0, ETO_CLIPPED | ETO_OPAQUE, &rect2, txt, len, NULL );
   rect2.left = iWidth1;
   rect2.right = iWidth2;
   SetTextColor( hdc2, xBack );
   SetBkColor( hdc2, xFont );
   ExtTextOut( hdc2, x, 0, ETO_CLIPPED | ETO_OPAQUE, &rect2, txt, len, NULL );
   SelectObject( hdc2, hOldFont );
   SetTextColor( hdc2, FontColor );
   SetBkColor( hdc2, BackColor );

   if( ! hdc )
   {
      ReleaseDC( oSelf->hWnd, hdc2 );
   }
}

HB_FUNC_STATIC( TPROGRESSMETER_EVENTS )          /* METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TProgressMeter */
{
   HWND hWnd      = HWNDparam( 1 );
   UINT message   = (UINT)   hb_parni( 2 );
   WPARAM wParam  = WPARAMparam( 3 );
   LPARAM lParam  = LPARAMparam( 4 );
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf   = _OOHG_GetControlInfo( pSelf );

   switch( message )
   {
      case WM_PAINT:
         {
            PAINTSTRUCT ps;
            HDC         hdc;
            RECT        updateRect;

            if( ! GetUpdateRect( hWnd, &updateRect, FALSE ) )
            {
               hb_retni( 0 );
            }
            else
            {
               hdc = BeginPaint( hWnd, &ps );
               ProgressMeter_Paint( oSelf, hdc );
               EndPaint( hWnd, &ps );
               hb_retni( 1 );
            }
         }
         break;

      case WM_GETTEXT:
         {
            char *txt;
            ULONG len;
            char cPercent[ 100 ];

            if( oSelf->AuxBuffer )
            {
               txt = (char *) oSelf->AuxBuffer;
            }
            else
            {
               sprintf( cPercent, "%i%%", (int)( oSelf->lAux[ 0 ] / 100 ) );
               txt = cPercent;
            }
            len = strlen( txt ) + 1;
            if( len > wParam )
            {
               len = wParam;
               if( len == 0 )
               {
                  len = 1;
               }
            }
            len--;
            if( len )
            {
               memcpy( (char *) lParam, txt, len );
            }
            ( (char *) lParam )[ len ] = 0;

            hb_retnl( len );
         }
         break;

      case WM_GETTEXTLENGTH:
         if( oSelf->AuxBuffer )
         {
            hb_retnl( strlen( (char *) oSelf->AuxBuffer ) );
         }
         else
         {
            char cPercent[ 100 ];
            sprintf( cPercent, "%i%%", (int)( oSelf->lAux[ 0 ] / 100 ) );
            hb_retnl( strlen( cPercent ) );
         }
         break;

      case WM_SETTEXT:
         {
            ULONG iLen;

            iLen = lParam ? strlen( (char *) lParam ) : 0;
            if( iLen )
            {
               if( iLen > oSelf->AuxBufferLen )
               {
                  if( oSelf->AuxBuffer )
                  {
                     hb_xfree( oSelf->AuxBuffer );
                  }
                  oSelf->AuxBuffer = (BYTE *) hb_xgrab( iLen + 1 );
                  oSelf->AuxBufferLen = iLen;
               }
               memcpy( oSelf->AuxBuffer, (char *) lParam, iLen + 1 );
            }
            else
            {
               if( oSelf->AuxBuffer )
               {
                  hb_xfree( oSelf->AuxBuffer );
                  oSelf->AuxBuffer = NULL;
                  oSelf->AuxBufferLen = 0;
               }
            }
            ProgressMeter_Paint( oSelf, NULL );
            hb_retni( TRUE );
         }
         break;

      default:
         _OOHG_Send( pSelf, s_Super );
         hb_vmSend( 0 );
         _OOHG_Send( hb_param( -1, HB_IT_OBJECT ), s_Events );
         HWNDpush( hWnd );
         hb_vmPushLong( message );
         hb_vmPushNumInt( wParam  );
         hb_vmPushNumInt( lParam );
         hb_vmSend( 4 );
         break;
   }
}

HB_FUNC_STATIC( TPROGRESSMETER_SETPERCENT )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   double dNum;
   long lNum;

   if( HB_ISNUM( 1 ) )
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
         lNum = (long) dNum;
      }
      if( lNum != oSelf->lAux[ 0 ] || ( HB_ISLOG( 2 ) && hb_parl( 2 ) ) )
      {
         oSelf->lAux[ 0 ] = lNum;
         ProgressMeter_Paint( oSelf, NULL );
      }
   }

   hb_retnd( oSelf->lAux[ 0 ] / 100 );
}

HB_FUNC_STATIC( TPROGRESSMETER_ALIGN )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( HB_ISNUM( 1 ) )
   {
      oSelf->lAux[ 1 ] = hb_parni( 1 );
      ProgressMeter_Paint( oSelf, NULL );
   }

   hb_retni( oSelf->lAux[ 1 ] );
}

#pragma ENDDUMP
