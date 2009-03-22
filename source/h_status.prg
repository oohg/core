/*
 * $Id: h_status.prg,v 1.32 2009-03-22 22:39:59 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG statusbar functions
 *
 * Copyright 2005-2009 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.oohg.org
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

#include "oohg.ch"
#include "hbclass.ch"
#include "i_windefs.ch"

STATIC _OOHG_ActiveMessageBar := nil

CLASS TMessageBar FROM TControl
   DATA Type      INIT "MESSAGEBAR" READONLY
   DATA aClicks   INIT nil
   DATA aWidths   INIT nil
   DATA lAutoAdjust   INIT .T.
   DATA lTop          INIT .F.

   DATA ladjust  INIT .F.  /// redimensionar

   METHOD Define
   METHOD EndStatus           BLOCK { || _EndMessageBar() }

   METHOD AddItem
   METHOD Item
   METHOD Caption(nItem,cCaption)        BLOCK { |Self,nItem,cCaption| ::Item( nItem, cCaption ) }
   METHOD ItemWidth
   METHOD ItemCount        BLOCK { |Self| GetItemCount( ::hWnd ) }
   METHOD ItemToolTip
   METHOD ClientHeightUsed     BLOCK { |Self| GetWindowHeight( ::hWnd ) * IF( ::lTop, 1, -1 ) }

   METHOD BackColor        SETGET

   METHOD SetClock
   METHOD SetKeybrd

   METHOD Events_Notify
   METHOD Events_Size
   METHOD RefreshData

   EMPTY( _OOHG_AllVars )
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, y, x, w, h, caption, ProcedureName, ;
               fontname, nFontsize, tooltip, clock, date, kbd, nClrF, nClrB, ;
               bold, italic, underline, strikeout, lTop, lNoAutoAdjust, ;
               Width, icon, cstyl ) CLASS TMessageBar
*-----------------------------------------------------------------------------*
Local ControlHandle

   EMPTY( nClrF )
   EMPTY( nClrB )
   EMPTY( x )
   EMPTY( y )
   EMPTY( w )
   EMPTY( h )
   ASSIGN ::lTop        VALUE lTop TYPE "L"

   ::aClicks := {}
   ::aWidths := {}

   ::SetForm( ControlName, ParentForm, FontName, nFontSize )
   ::Container := nil

   _OOHG_ActiveMessageBar := Self

   ControlHandle := InitMessageBar( ::Parent:hWnd, Caption, 0, ::lTop  )

   ::Register( ControlHandle, ControlName, , , ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   ::Caption := Caption
   IF VALTYPE( lNoAutoAdjust ) == "L"
      ::lAutoAdjust := ! lNoAutoAdjust
   ENDIF

   // Re-defines first status item
   If ValType( Caption ) $ "CM"
      ::AddItem( Caption, Width, ProcedureName, ToolTip, icon, cstyl )
   Endif

   IF VALTYPE( clock ) == "L" .AND. clock
      ::SetClock()
   ENDIF

   IF VALTYPE( kbd ) == "L" .AND. kbd
      ::SetKeybrd()
   ENDIF

   IF VALTYPE( date ) == "L" .AND. date
*      ::SetDate()
   ENDIF

   _OOHG_AddFrame( Self )
   ::ContainerhWndValue := ::hWnd

   ASSIGN ::OnClick     VALUE ProcedureName TYPE "B"

Return Self

*-----------------------------------------------------------------------------*
METHOD AddItem( Caption, Width, action, ToolTip, icon, cstyl ) CLASS TMessageBar
*-----------------------------------------------------------------------------*
Local styl, nItem, i

   ASSIGN Width VALUE Width TYPE "N" DEFAULT 50

   styl := 0
   If ValType( cStyl ) $ "CM" .AND. ! Empty( cStyl )
      cStyl := UPPER( ALLTRIM( cStyl ) )
      If     "RAISED" = cStyl
         styl := 1
      ElseIf "FLAT"   = cStyl
         styl := 2
      EndIf
   EndIf

   If ! ::lAutoAdjust
      nItem := InitItemBar( ::hWnd, Caption, 0, Width, 2, Icon, ToolTip, styl )
   ElseIf LEN( ::aWidths ) == 0
      nItem := InitItemBar( ::hWnd, Caption, 0, Width, 0, Icon, ToolTip, styl )
   Else
      nItem := InitItemBar( ::hWnd, Caption, 0, Width, 1, Icon, ToolTip, styl )
   EndIf

   ASIZE( ::aClicks, nItem )
   ::aClicks[ nItem ] := action

   ASIZE( ::aWidths, nItem )
   ::aWidths[ nItem ] := Width

   i := At( "&", Caption )
   If i > 0 .AND. i < LEN( Caption )
      DEFINE HOTKEY 0 PARENT ( Self ) KEY "ALT+" + SubStr( Caption, i + 1, 1 ) ACTION ::DoEvent( ::aClicks[ nItem ], "CLICK" )
	EndIf

Return nItem

*-----------------------------------------------------------------------------*
METHOD Item( nItem, uValue ) CLASS TMessageBar
*-----------------------------------------------------------------------------*
   IF VALTYPE( uValue ) $ "CM"
      SetItemBar( ::hWnd, uValue, nItem - 1 )
   ENDIF
RETURN GetItemBar( ::hWnd, nItem - 1 )

*-----------------------------------------------------------------------------*
METHOD ItemWidth( nItem, nWidth ) CLASS TMessageBar
*-----------------------------------------------------------------------------*
   If ValType( nWidth ) == "N" .AND. nItem >= 2 .AND. nItem <= ::ItemCount
      If Len( ::aWidths ) < ::ItemCount
         ASIZE( ::aWidths, ::ItemCount )
      EndIf
      ::aWidths[ nItem ] := nWidth
      RefreshItemBar( ::hWnd, ::aWidths, ::lAutoAdjust )
      ::aWidths[ 1 ] := GetItemWidth( ::hWnd, 1 )
   EndIf
Return GetItemWidth( ::hWnd, nItem )

*-----------------------------------------------------------------------------*
METHOD ItemToolTip( nItem, cValue ) CLASS TMessageBar
*-----------------------------------------------------------------------------*
   IF VALTYPE( cValue ) $ "CM"
      SetItemToolTip( ::hWnd, cValue, nItem - 1 )
   ENDIF
RETURN GetItemToolTip( ::hWnd, nItem - 1 )

*-----------------------------------------------------------------------------*
METHOD SetClock( Width, ToolTip, action, lAmPm ) CLASS TMessageBar
*-----------------------------------------------------------------------------*
local nrItem

   If ValType( lAmPm ) != "L"
      lAmPm := .F.
   EndIf
   If ValType( Width ) != 'N'
      Width := If( lAmPm, 95, 70 )
   EndIf
   If ! ValType( ToolTip ) $ "CM"
      ToolTip := 'Clock'
   EndIf

   If ! lAmPm
      nrItem := ::AddItem( Time(), Width, action, ToolTip )
      TTimer():Define( , Self, 1000, { || ::Item( nrItem, Time() ) } )
   Else
      nrItem := ::AddItem( TMessageBar_AmPmClock(), Width, action, ToolTip )
      TTimer():Define( , Self, 1000, { || ::Item( nrItem, TMessageBar_AmPmClock() ) } )
   Endif

Return Nil

STATIC FUNCTION TMessageBar_AmPmClock()
LOCAL cTime, nHour
   cTime := TIME()
   nHour := VAL( LEFT( cTime, 2 ) )
   IF nHour > 12
      cTime := STRZERO( nHour - 12, 2 ) + SUBSTR( cTime, 3 ) + " pm"
   ELSEIF nHour == 12
      cTime := cTime + " pm"
   ELSEIF nHour == 0
      cTime := "12" + SUBSTR( cTime, 3 ) + " am"
   ELSE
      cTime := cTime + " am"
   ENDIF
RETURN cTime

*-----------------------------------------------------------------------------*
METHOD SetKeybrd( Width , ToolTip , action ) CLASS TMessageBar
*-----------------------------------------------------------------------------*
local nrItem1 , nrItem2 , nrItem3

   If ValType (Width) == 'U'
      Width := 45
   EndIf
   If ValType (ToolTip) == 'U'
      ToolTip := ''
   EndIf
   If ValType (Action) == 'U'
      Action := ''
   EndIf

   nrItem1 := ::AddItem( "Num",  GetTextWidth( NIL, "Num",  ::FontHandle ) + 36, action, ToolTip, if( IsNumLockActive(),  "zzz_led_on", "zzz_led_off" ) )
   nrItem2 := ::AddItem( "Caps", GetTextWidth( NIL, "Caps", ::FontHandle ) + 36, action, ToolTip, if( IsCapsLockActive(), "zzz_led_on", "zzz_led_off" ) )
   nrItem3 := ::AddItem( "Ins",  GetTextWidth( NIL, "Ins",  ::FontHandle ) + 36, action, ToolTip, if( IsCapsLockActive(), "zzz_led_on", "zzz_led_off" ) )

   If Empty( Action )
      ::aClicks[ nrItem1 ] := { || KeyToggle( VK_NUMLOCK ) }
      ::aClicks[ nrItem2 ] := { || KeyToggle( VK_CAPITAL ) }
      ::aClicks[ nrItem3 ] := { || KeyToggle( VK_INSERT ) }
   Else
      ::aClicks[ nrItem1 ] := Action
      ::aClicks[ nrItem2 ] := Action
      ::aClicks[ nrItem3 ] := Action
   EndIf

   TTimer():Define( , Self, 400 , ;
      {|| SetStatusItemIcon( ::hWnd, nrItem1 , if ( IsNumLockActive() , "zzz_led_on" , "zzz_led_off" ) ), ;
          SetStatusItemIcon( ::hWnd, nrItem2 , if ( IsCapsLockActive() , "zzz_led_on" , "zzz_led_off" ) ), ;
          SetStatusItemIcon( ::hWnd, nrItem3 , if ( IsInsertActive() , "zzz_led_on" , "zzz_led_off" ) ) } )

Return Nil

*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TMessageBar
*-----------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam )
Local x
   If nNotify == NM_CLICK
      DefWindowProc( ::hWnd, NM_CLICK, wParam, lParam )
      x := GetItemPos( lParam ) + 1
      if x > 0 .AND. x <= Len( ::aClicks )
         if ::DoEvent( ::aClicks[ x ], "CLICK" )
            Return nil
         EndIf
      EndIf
   EndIf
Return ::Super:Events_Notify( wParam, lParam )

*-----------------------------------------------------------------------------*
METHOD Events_Size() CLASS TMessageBar
*-----------------------------------------------------------------------------*
   ::RefreshData()
   AEVAL( ::aControls, { |o| o:Events_Size() } )
Return Super:Events_Size()

*-----------------------------------------------------------------------------*
METHOD RefreshData() CLASS TMessageBar
*-----------------------------------------------------------------------------*
   RefreshItemBar( ::hWnd, ::aWidths, ::lAutoAdjust )
   IF LEN( ::aWidths ) >= 1
      ::aWidths[ 1 ] := GetItemWidth( ::hWnd, 1 )
   ENDIF
Return ::Super:RefreshData()

*-----------------------------------------------------------------------------*
Function _EndMessageBar()
*-----------------------------------------------------------------------------*
   _OOHG_ActiveMessageBar := nil
   _OOHG_DeleteFrame( "MESSAGEBAR" )
Return Nil





FUNCTION _SetStatusClock( nSize, cToolTip, uAction, lAmPm )
Return _OOHG_ActiveMessageBar:SetClock( nSize, cToolTip, uAction, lAmPm )

FUNCTION _SetStatusKeybrd( nSize, cToolTip, uAction )
Return _OOHG_ActiveMessageBar:SetKeybrd( nSize, cToolTip, uAction )

FUNCTION _SetStatusItem( Caption, Width, action, ToolTip, icon, cstyl )
Return _OOHG_ActiveMessageBar:AddItem( Caption, Width, action, ToolTip, icon, cstyl )





#pragma BEGINDUMP

#ifndef _WIN32_IE
   #define _WIN32_IE 0x0400
#endif
#if ( _WIN32_IE < 0x0400 )
   #undef _WIN32_IE
   #define _WIN32_IE 0x0400
#endif

#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"
#include "hbstack.h"
#include "oohg.h"

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

#define NUM_OF_PARTS 40

HB_FUNC( INITMESSAGEBAR )
{
   HWND hWndSB;
   int  iStyle;

   iStyle = WS_CHILD | WS_VISIBLE | WS_BORDER | SBT_TOOLTIPS;
   if( hb_parl( 4 ) )
   {
      iStyle |= CCS_TOP;
   }

   hWndSB = CreateStatusWindow( iStyle, hb_parc( 2 ), HWNDparam( 1 ), hb_parni ( 3 ) );

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( hWndSB, GWL_WNDPROC, ( LONG ) SubClassFunc );

   HWNDret( hWndSB );
}

HB_FUNC( GETITEMCOUNT )
{
   hb_retni( SendMessage( HWNDparam( 1 ), SB_GETPARTS, 0, 0 ) );
}

HB_FUNC( SETITEMBAR )
{
   SendMessage( HWNDparam( 1 ), SB_SETTEXT, hb_parni( 3 ), ( LPARAM ) hb_parc( 2 ) );
}

HB_FUNC( GETITEMBAR )
{
   char *cString;
   HWND hWnd;
   int iPos;

   hWnd = HWNDparam( 1 );
   iPos = hb_parni( 2 );
   cString = (char *) hb_xgrab( LOWORD( SendMessage( hWnd, SB_GETTEXTLENGTH, iPos, 0 ) ) + 1 );
   SendMessage( hWnd, SB_GETTEXT, ( WPARAM ) iPos, ( LPARAM ) cString );
   hb_retc( cString );
   hb_xfree( cString );
}

//////////// to check...
HB_FUNC( INITITEMBAR )
{
   HWND  hWndSB;
   int   cSpaceInBetween = 8;
   int   ptArray[ NUM_OF_PARTS ];   // Array defining the number of parts/sections
   int   nrOfParts = 0;
   int   n ;
   RECT  rect;
   HDC   hDC;
   WORD  displayFlags;
   HICON hIcon;
   int   cx;
   int   cy;

   hWndSB = HWNDparam( 1 );
   switch( hb_parni( 8 ) )
   {
      case  0:  displayFlags = 0 ; break;
      case  1:  displayFlags = SBT_POPOUT ; break;
      case  2:  displayFlags = SBT_NOBORDERS ; break;
      default : displayFlags = 0;
   }

   if ( hb_parnl( 5 ) )
   {
      nrOfParts = SendMessage( hWndSB, SB_GETPARTS, 0, 0 );
      SendMessage( hWndSB, SB_GETPARTS, NUM_OF_PARTS, ( LPARAM )( LPINT ) ptArray );
   }
   nrOfParts++;

   hDC = GetDC( hWndSB );
   GetClientRect( hWndSB, &rect );

   if( hb_parnl( 5 ) == 2 )
   {
      if( nrOfParts == 1 )
      {
         ptArray[ 0 ] = hb_parni( 4 );
      }
      else
      {
         ptArray[ nrOfParts - 1 ] = ptArray[ nrOfParts - 2 ] + hb_parni( 4 );
      }
   }
   else if( hb_parnl( 5 ) == 0 )
   {
      ptArray[ nrOfParts - 1 ] = rect.right;
   }
   else
   {
      for( n = 0; n < nrOfParts - 1; n++ )
      {
         ptArray[ n ] -= hb_parni( 4 ) - cSpaceInBetween;
      }
      ptArray[ nrOfParts - 1 ] = rect.right;
   }

   ReleaseDC( hWndSB, hDC );

   SendMessage( hWndSB, SB_SETPARTS, nrOfParts, ( LPARAM ) ( LPINT ) ptArray );

   cy = rect.bottom - rect.top - 4;
   cx = cy;

   hIcon = ( HICON ) LoadImage( 0, hb_parc( 6 ), IMAGE_ICON, cx, cy, LR_LOADFROMFILE );

   if( ! hIcon )
   {
      hIcon = (HICON)LoadImage(GetModuleHandle(NULL),hb_parc(6),IMAGE_ICON ,cx,cy, 0 );
   }

   if( hIcon == NULL )
   {
      SendMessage( hWndSB, SB_SETICON, ( WPARAM ) nrOfParts - 1, ( LPARAM ) hIcon );
   }

   SendMessage( hWndSB, SB_SETTEXT, ( nrOfParts - 1 ) | displayFlags, ( LPARAM ) hb_parc( 2 ) );
   SendMessage( hWndSB, SB_SETTIPTEXT, ( WPARAM ) nrOfParts - 1, ( LPARAM ) hb_parc( 7 ) );

   hb_retni( nrOfParts );
}

//////////// to check...
HB_FUNC( GETITEMWIDTH )
{
   HWND  hWnd;
   int   *piItems;
   unsigned int iItems, iSize, iPos;

   hWnd = HWNDparam( 1 );
   iPos = hb_parni( 2 );
   iItems = SendMessage( hWnd, SB_GETPARTS, 0, 0 );
   iSize = 0;
   if( iItems != 0 && iPos <= iItems )
   {
      piItems = (int *) hb_xgrab( sizeof( int ) * iItems );
      SendMessage( hWnd, SB_GETPARTS, iItems, ( LPARAM ) piItems );
      if( iPos == 1 )
      {
         iSize = piItems[ iPos - 1 ];
      }
      else
      {
         iSize = piItems[ iPos - 1 ] - piItems[ iPos - 2 ];
      }
      hb_xfree( piItems );
   }
   hb_retni( iSize );
}

HB_FUNC( SETITEMTOOLTIP )
{
   SendMessage( HWNDparam( 1 ), SB_SETTIPTEXT, hb_parni( 3 ), ( LPARAM ) hb_parc( 2 ) );
}

HB_FUNC( GETITEMTOOLTIP )
{
   char cBuffer[ 1024 ];

   cBuffer[ 0 ] = 0;
   SendMessage( HWNDparam( 1 ), SB_GETTIPTEXT,
                MAKEWPARAM( hb_parni( 2 ), 1023 ),
                ( LPARAM ) cBuffer );

   hb_retc( cBuffer );
}

//////////// to check...
HB_FUNC( REFRESHITEMBAR )   // ( hWnd, aWidths, lAutoAdjust )
{
   HWND  hWnd;
   int   *piItems;
   int   iItems, iWidth, iCount;
   RECT  rect;

   hWnd = HWNDparam( 1 );
   iItems = SendMessage( hWnd, SB_GETPARTS, 0, 0 );
   if( iItems != 0 )
   {
      // GetWindowRect( hWnd, &rect );
      GetClientRect( GetParent( hWnd ), &rect );
      iWidth = rect.right - rect.left;

      piItems = (int *) hb_xgrab( sizeof( int ) * iItems );
      SendMessage( hWnd, SB_GETPARTS, iItems, ( WPARAM ) piItems );
      if( hb_parl( 3 ) )
      {
         iCount = iItems;
         while( iCount )
         {
            iCount--;
            piItems[ iCount ] = iWidth;
            iWidth -= hb_parni( 2, iCount + 1 );
         }
      }
      else
      {
         iWidth = 0;
         for( iCount = 0; iCount < iItems; iCount++ )
         {
            iWidth += hb_parni( 2, iCount + 1 );
            piItems[ iCount ] = iWidth;
         }
      }
      SendMessage( hWnd, SB_SETPARTS, iItems, ( LPARAM ) piItems );
      MoveWindow( hWnd, 0, 0, 0, 0, TRUE );
      hb_xfree( piItems );
   }
   hb_retni( iItems );
}

//////////// to check...
HB_FUNC_EXTERN( SETSTATUSITEMICON )
{
   HWND  hwnd;
   RECT  rect;
   HICON hIcon ;
   int   cx;
   int   cy;

   hwnd = HWNDparam( 1 );

   // Unloads from memory current icon
   DestroyIcon( ( HICON ) SendMessage( hwnd, SB_GETICON, ( WPARAM ) hb_parni( 2 ) - 1, ( LPARAM ) 0 ) );

   //
   GetClientRect( hwnd, &rect );
   cy = rect.bottom - rect.top-4;
   cx = cy;

   hIcon = ( HICON ) LoadImage( GetModuleHandle( NULL ), hb_parc( 3 ), IMAGE_ICON, cx, cy, 0 );

   if( ! hIcon )
   {
      hIcon = ( HICON ) LoadImage( 0, hb_parc( 3 ), IMAGE_ICON, cx, cy, LR_LOADFROMFILE );
   }

   SendMessage( hwnd, SB_SETICON, ( WPARAM ) hb_parni( 2 ) - 1, ( LPARAM ) hIcon );
}

HB_FUNC( KEYTOGGLE )
{
   BYTE pBuffer[ 256 ];
   WORD wKey = ( WORD ) hb_parni( 1 );

   GetKeyboardState( pBuffer );

   if( pBuffer[ wKey ] & 0x01 )
      pBuffer[ wKey ] &= 0xFE;
   else
      pBuffer[ wKey ] |= 0x01;

   SetKeyboardState( pBuffer );
}

HB_FUNC_STATIC( TMESSAGEBAR_BACKCOLOR )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   COLORREF  Color;

   if( _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &oSelf->lBackColor, ( hb_pcount() >= 1 ) ) )
   {
      if( ValidHandler( oSelf->hWnd ) )
      {
         Color = ( oSelf->lBackColor == -1 ) ? CLR_DEFAULT : oSelf->lBackColor;
         SendMessage( oSelf->hWnd, SB_SETBKCOLOR, 0, Color );
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   // Return value was set in _OOHG_DetermineColorReturn()
}
#pragma ENDDUMP
