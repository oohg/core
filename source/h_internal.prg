/*
 * $Id: h_internal.prg,v 1.17 2017-10-01 15:52:26 fyurisich Exp $
 */
/*
 * ooHG source code:
 * Internal Window control
 *
 * Copyright 2006-2017 Vicente Guerra <vicente@guerra.com.mx>
 * https://sourceforge.net/projects/oohg/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2017, https://harbour.github.io/
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
 * along with this software; see the file COPYING.  If not, write to
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


#include 'oohg.ch'
#include 'hbclass.ch'
#include "i_windefs.ch"
#include "common.ch"

*------------------------------------------------------------------------------*
CLASS TInternal FROM TControl
*------------------------------------------------------------------------------*
   DATA Type      INIT "INTERNAL" READONLY
   DATA nVirtualHeight INIT 0
   DATA nVirtualWidth  INIT 0
   DATA RangeHeight    INIT 0
   DATA RangeWidth     INIT 0
   DATA OnScrollUp     INIT nil
   DATA OnScrollDown   INIT nil
   DATA OnScrollLeft   INIT nil
   DATA OnScrollRight  INIT nil
   DATA OnHScrollBox   INIT nil
   DATA OnVScrollBox   INIT nil

   METHOD Define
   METHOD Events_VScroll
   METHOD Events_HScroll
   METHOD VirtualWidth        SETGET
   METHOD VirtualHeight       SETGET
   METHOD SizePos
   METHOD ScrollControls
   METHOD Events
   METHOD BackColor           SETGET
   METHOD BackColorCode       SETGET

   /* HB_SYMBOL_UNUSED( _OOHG_AllVars ) */
ENDCLASS

*------------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, OnClick, w, h, ;
               backcolor, tooltip, gotfocus, lostfocus, ;
               Transparent, BORDER, CLIENTEDGE, icon, ;
               Virtualheight, VirtualWidth, ;
               MouseDragProcedure, MouseMoveProcedure, ;
               NoTabStop, HelpId, invisible, lRtl ) CLASS TInternal
*------------------------------------------------------------------------------*
Local ControlHandle, nStyle, nStyleEx := 0

   ASSIGN ::nCol        VALUE x TYPE "N"
   ASSIGN ::nRow        VALUE y TYPE "N"
   ASSIGN ::nWidth      VALUE w TYPE "N"
   ASSIGN ::nHeight     VALUE h TYPE "N"
   ASSIGN ::Transparent VALUE Transparent TYPE "L" DEFAULT .F.

   if valtype( VirtualHeight ) != "N"
      VirtualHeight := 0
   endif

   if valtype( VirtualWidth ) != "N"
      VirtualWidth := 0
   endif

   ::SetForm( ControlName, ParentForm,,,, backcolor,, lRtl )

   nStyle := ::InitStyle( ,, Invisible, NoTabStop ) + ;
             if( ValType( BORDER ) == "L"    .AND. BORDER,     WS_BORDER, 0 )  + ;
             SS_NOTIFY

   nStyleEx += if( ValType( CLIENTEDGE ) == "L" .AND. CLIENTEDGE, WS_EX_CLIENTEDGE, 0 ) + ;
               if( ::Transparent, WS_EX_TRANSPARENT, 0 )
   nStyleEx += WS_EX_CONTROLPARENT

   Controlhandle := InitInternal( ::ContainerhWnd, ::ContainerCol, ::ContainerRow, ::nWidth, ::nHeight, nStyle, nStyleEx, ::lRtl )

   ::Register( ControlHandle, ControlName, HelpId,, ToolTip )

   ::HScrollBar := TScrollBar():Define( "0", Self,,,,,,,, ;
                   { |Scroll| _OOHG_Eval( ::OnScrollLeft, Scroll ) }, ;
                   { |Scroll| _OOHG_Eval( ::OnScrollRight, Scroll ) }, ;
                   { |Scroll| _OOHG_Eval( ::OnHScrollBox, Scroll ) }, ;
                   { |Scroll| _OOHG_Eval( ::OnHScrollBox, Scroll ) }, ;
                   { |Scroll| _OOHG_Eval( ::OnHScrollBox, Scroll ) }, ;
                   { |Scroll| _OOHG_Eval( ::OnHScrollBox, Scroll ) }, ;
                   { |Scroll,n| _OOHG_Eval( ::OnHScrollBox, Scroll, n ) }, ;
                   ,,,,,, SB_HORZ, .T. )
   ::HScrollBar:nLineSkip  := 1
   ::HScrollBar:nPageSkip  := 20

   ::VScrollBar := TScrollBar():Define( "0", Self,,,,,,,, ;
                   { |Scroll| _OOHG_Eval( ::OnScrollUp, Scroll ) }, ;
                   { |Scroll| _OOHG_Eval( ::OnScrollDown, Scroll ) }, ;
                   { |Scroll| _OOHG_Eval( ::OnVScrollBox, Scroll ) }, ;
                   { |Scroll| _OOHG_Eval( ::OnVScrollBox, Scroll ) }, ;
                   { |Scroll| _OOHG_Eval( ::OnVScrollBox, Scroll ) }, ;
                   { |Scroll| _OOHG_Eval( ::OnVScrollBox, Scroll ) }, ;
                   { |Scroll,n| _OOHG_Eval( ::OnVScrollBox, Scroll, n ) }, ;
                   ,,,,,, SB_VERT, .T. )
   ::VScrollBar:nLineSkip  := 1
   ::VScrollBar:nPageSkip  := 20

   ::nVirtualHeight := VirtualHeight
   ::nVirtualWidth  := VirtualWidth
   ValidateScrolls( Self, .F. )

   ::hCursor := LoadCursorFromFile( icon )

   If ::Transparent
      RedrawWindowControlRect( ::ContainerhWnd, ::ContainerRow, ::ContainerCol, ::ContainerRow + ::Height, ::ContainerCol + ::Width )
   EndIf

   ::ContainerhWndValue := ::hWnd
   _OOHG_AddFrame( Self )

   ASSIGN ::OnClick     VALUE OnClick   TYPE "B"
   ASSIGN ::OnLostFocus VALUE LostFocus TYPE "B"
   ASSIGN ::OnGotFocus  VALUE GotFocus  TYPE "B"
   ::OnMouseDrag := MouseDragProcedure
   ::OnMouseMove := MouseMoveProcedure

Return Self

*------------------------------------------------------------------------------*
METHOD Events_VScroll( wParam ) CLASS TInternal
*------------------------------------------------------------------------------*
Local uRet
   uRet := ::VScrollBar:Events_VScroll( wParam )
   ::RowMargin := - ::VScrollBar:Value
   ::ScrollControls()
Return uRet

*------------------------------------------------------------------------------*
METHOD Events_HScroll( wParam ) CLASS TInternal
*------------------------------------------------------------------------------*
Local uRet
   uRet := ::HScrollBar:Events_HScroll( wParam )
   ::ColMargin := - ::HScrollBar:Value
   ::ScrollControls()
Return uRet

*------------------------------------------------------------------------------*
METHOD VirtualWidth( nSize ) CLASS TInternal
*------------------------------------------------------------------------------*
   If valtype( nSize ) == "N"
      ::nVirtualWidth := nSize
      ValidateScrolls( Self, .T. )
   EndIf
Return ::nVirtualWidth

*------------------------------------------------------------------------------*
METHOD VirtualHeight( nSize ) CLASS TInternal
*------------------------------------------------------------------------------*
   If valtype( nSize ) == "N"
      ::nVirtualHeight := nSize
      ValidateScrolls( Self, .T. )
   EndIf
Return ::nVirtualHeight

*------------------------------------------------------------------------------*
METHOD SizePos( Row, Col, Width, Height ) CLASS TInternal
*------------------------------------------------------------------------------*
LOCAL uRet
   uRet := ::Super:SizePos( Row, Col, Width, Height )
   ValidateScrolls( Self, .T. )
RETURN uRet

*------------------------------------------------------------------------------*
METHOD ScrollControls() CLASS TInternal
*------------------------------------------------------------------------------*
   AEVAL( ::aControls, { |o| If( o:Container:hWnd == ::hWnd, o:SizePos(), ) } )
   ReDrawWindow( ::hWnd )
RETURN Self

*------------------------------------------------------------------------------*
Function _EndInternal()
*------------------------------------------------------------------------------*
Return _OOHG_DeleteFrame( "INTERNAL" )

#pragma BEGINDUMP

#ifndef HB_OS_WIN_32_USED
   #define HB_OS_WIN_32_USED
#endif

#ifndef _WIN32_WINNT
   #define _WIN32_WINNT 0x0400
#endif
#if ( _WIN32_WINNT < 0x0400 )
   #undef _WIN32_WINNT
   #define _WIN32_WINNT 0x0400
#endif

#define s_Super s_TControl

#include "hbapi.h"
#include "hbapiitm.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windows.h>
#include <commctrl.h>
#include "oohg.h"

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

static BOOL bRegistered = 0;       // TODO: Thread safe ?

static LRESULT CALLBACK _OOHG_TInternal_WndProc( HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam )
{
   return DefWindowProc( hWnd, message, wParam, lParam );
}

void _OOHG_TInternal_Register( void )
{
   WNDCLASS WndClass;

   memset( &WndClass, 0, sizeof( WndClass ) );
   WndClass.style         = CS_HREDRAW | CS_VREDRAW | CS_OWNDC | CS_DBLCLKS;
   WndClass.lpfnWndProc   = _OOHG_TInternal_WndProc;
   WndClass.lpszClassName = "_OOHG_TINTERNAL";
   WndClass.hInstance     = GetModuleHandle( NULL );
   WndClass.hbrBackground = ( HBRUSH )( COLOR_BTNFACE + 1 );

   if( ! RegisterClass( &WndClass ) )
   {
      char cBuffError[ 1000 ];
      sprintf( cBuffError, "_OOHG_TINTERNAL Registration Failed! Error %i", ( int ) GetLastError() );
      MessageBox( 0, cBuffError, "Error!", MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
      ExitProcess( 0 );
   }

   bRegistered = 1;
}

HB_FUNC( INITINTERNAL )
{
   HWND hwnd;
   HWND hbutton;

   int Style, ExStyle;

   if( ! bRegistered )
   {
      _OOHG_TInternal_Register();
   }

   hwnd = HWNDparam( 1 );
   Style = hb_parni( 6 ) | WS_CHILD;
   ExStyle = hb_parni( 7 ) | _OOHG_RTL_Status( hb_parl( 8 ) );

   hbutton = CreateWindowEx( ExStyle, "_OOHG_TINTERNAL", "", Style,
             hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ),
             hwnd, NULL, GetModuleHandle( NULL ), NULL );

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( hbutton, GWL_WNDPROC, ( LONG ) SubClassFunc );

   HWNDret( hbutton );
}

HB_FUNC_STATIC( TINTERNAL_EVENTS )   // METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TInternal
{
   HWND hWnd      = ( HWND )   hb_parnl( 1 );
   UINT message   = ( UINT )   hb_parni( 2 );
   WPARAM wParam  = ( WPARAM ) hb_parni( 3 );
   LPARAM lParam  = ( LPARAM ) hb_parnl( 4 );
   PHB_ITEM pSelf = hb_stackSelfItem();
 //////  POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   switch( message )
   {
      case WM_MOUSEWHEEL:
         if( ( short ) HIWORD( wParam ) > 0 )
         {
            _OOHG_Send( pSelf, s_Events_VScroll );
            hb_vmPushLong( SB_LINEUP );
            hb_vmSend( 1 );
         }
         else
         {
            _OOHG_Send( pSelf, s_Events_VScroll );
            hb_vmPushLong( SB_LINEDOWN );
            hb_vmSend( 1 );
         }
         hb_retni( 1 );
         break;

      case WM_ERASEBKGND:
         {
            POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
            HBRUSH hBrush;
            RECT rect;
            GetClientRect( hWnd, &rect );
            hBrush = oSelf->BrushHandle ? oSelf->BrushHandle : ( HBRUSH ) ( COLOR_BTNFACE + 1 );
            FillRect( ( HDC ) wParam, &rect, hBrush );
            hb_retni( 1 );
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

HB_FUNC_STATIC( TINTERNAL_BACKCOLOR )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &oSelf->lBackColor, ( hb_pcount() >= 1 ) ) )
   {
      if( oSelf->BrushHandle )
      {
         DeleteObject( oSelf->BrushHandle );
      }
      oSelf->BrushHandle = ( oSelf->lBackColor == -1 ) ? 0 : CreateSolidBrush( oSelf->lBackColor );
      if( ValidHandler( oSelf->hWnd ) )
      {
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   // Return value was set in _OOHG_DetermineColorReturn()
}

HB_FUNC_STATIC( TINTERNAL_BACKCOLORCODE )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( hb_pcount() >= 1 )
   {
      if( ! _OOHG_DetermineColor( hb_param( 1, HB_IT_ANY ), &oSelf->lBackColor ) )
      {
         oSelf->lBackColor = -1;
      }
      if( oSelf->BrushHandle )
      {
         DeleteObject( oSelf->BrushHandle );
      }
      oSelf->BrushHandle = ( oSelf->lBackColor == -1 ) ? 0 : CreateSolidBrush( oSelf->lBackColor );
      if( ValidHandler( oSelf->hWnd ) )
      {
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   hb_retnl( oSelf->lBackColor );
}

#pragma ENDDUMP
