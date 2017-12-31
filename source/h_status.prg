/*
* $Id: h_status.prg $
*/
/*
* ooHG source code:
* Statusbar control
* Copyright 2005-2017 Vicente Guerra <vicente@guerra.com.mx>
* https://oohg.github.io/
* Portions of this project are based upon Harbour MiniGUI library.
* Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
* Portions of this project are based upon Harbour GUI framework for Win32.
* Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
* Copyright 2001 Antonio Linares <alinares@fivetech.com>
* Portions of this project are based upon Harbour Project.
* Copyright 1999-2017, https://harbour.github.io/
*/
/*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2, or (at your option)
* any later version.
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
* You should have received a copy of the GNU General Public License
* along with this software; see the file LICENSE.txt. If not, write to
* the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1335,USA (or download from http://www.gnu.org/licenses/).
* As a special exception, the ooHG Project gives permission for
* additional uses of the text contained in its release of ooHG.
* The exception is that, if you link the ooHG libraries with other
* files to produce an executable, this does not by itself cause the
* resulting executable to be covered by the GNU General Public License.
* Your use of that executable is in no way restricted on account of
* linking the ooHG library code into it.
* This exception does not however invalidate any other reasons why
* the executable file might be covered by the GNU General Public License.
* This exception applies only to the code released by the ooHG
* Project under the name ooHG. If you copy code from other
* ooHG Project or Free Software Foundation releases into a copy of
* ooHG, as the General Public License permits, the exception does
* not apply to the code that you add in this way. To avoid misleading
* anyone as to the status of such modified files, you must delete
* this exception notice from them.
* If you write modifications of your own for ooHG, it is your choice
* whether to permit this exception to apply to your modifications.
* If you do not wish that, delete this exception notice.
*/

#include "oohg.ch"
#include "hbclass.ch"
#include "i_windefs.ch"

STATIC _OOHG_ActiveMessageBar := Nil

CLASS TMessageBar FROM TControl

   DATA Type        INIT "MESSAGEBAR" READONLY
   DATA aClicks     INIT Nil
   DATA aRClicks    INIT Nil
   DATA aDblClicks  INIT Nil
   DATA aRDblClicks INIT Nil
   DATA aWidths     INIT Nil
   DATA lAutoAdjust INIT .T.
   DATA lTop        INIT .F.
   DATA ladjust     INIT .F.
   DATA cLedOn      INIT "zzz_led_on"
   DATA cLedOff     INIT "zzz_led_off"
   DATA aAligns     INIT {}

   METHOD Define
   METHOD EndStatus                      BLOCK { || _EndMessageBar() }

   METHOD AddItem
   METHOD Item
   METHOD Caption(nItem, cCaption, cAlign) BLOCK { |Self, nItem, cCaption, cAlign| ::Item( nItem, cCaption, cAlign ) }
   METHOD ItemWidth
   METHOD ItemCount                      BLOCK { |Self| GetItemCount( ::hWnd ) }
   METHOD ItemToolTip
   METHOD ItemIcon
   METHOD ItemClick
   METHOD ItemRClick
   METHOD ItemDblClick
   METHOD ItemRDblClick
   METHOD ClientHeightUsed               BLOCK { |Self| GetWindowHeight( ::hWnd ) * IF( ::lTop, 1, -1 ) }
   METHOD MinHeight                      SETGET
   METHOD BackColor                      SETGET
   METHOD ItemAlign
   METHOD SetClock
   METHOD SetKeybrd
   METHOD SetDate

   METHOD Events_Notify
   METHOD Events_Size
   METHOD RefreshData

   ENDCLASS

METHOD Define( ControlName, ParentForm, y, x, w, h, caption, ProcedureName, ;
      fontname, nFontsize, tooltip, clock, date, kbd, nClrF, nClrB, ;
      bold, italic, underline, strikeout, lTop, lNoAutoAdjust, ;
      Width, icon, cstyl, cAlign ) CLASS TMessageBar

   LOCAL ControlHandle

   EMPTY( nClrF )
   EMPTY( nClrB )
   EMPTY( x )
   EMPTY( y )
   EMPTY( w )
   EMPTY( h )
   ASSIGN ::lTop        VALUE lTop TYPE "L"

   ::aClicks := {}
   ::aRClicks := {}
   ::aDblClicks := {}
   ::aRDblClicks := {}
   ::aWidths := {}

   ::SetForm( ControlName, ParentForm, FontName, nFontSize )
   ::Container := Nil

   _OOHG_ActiveMessageBar := Self

   ControlHandle := InitMessageBar( ::Parent:hWnd, Caption, 0, ::lTop )

   ::Register( ControlHandle, ControlName, , , ToolTip )
   ::SetFont(, , bold, italic, underline, strikeout )

   ::Caption := Caption
   IF ValType( lNoAutoAdjust ) == "L"
      ::lAutoAdjust := ! lNoAutoAdjust
   ENDIF

   // Re-defines first status item
   IF ValType( Caption ) $ "CM"
      ::AddItem( Caption, Width, ProcedureName, ToolTip, icon, cstyl, cAlign )
   ENDIF

   IF ValType( clock ) == "L" .AND. clock
      ::SetClock()
   ENDIF

   IF ValType( kbd ) == "L" .AND. kbd
      ::SetKeybrd()
   ENDIF

   IF ValType( date ) == "L" .AND. date
      ::SetDate()
   ENDIF

   _OOHG_AddFrame( Self )
   ::ContainerhWndValue := ::hWnd

   ASSIGN ::OnClick     VALUE ProcedureName TYPE "B"

   ::nWidth := GetWindowWidth( ::hWnd )

   RETURN Self

METHOD AddItem( Caption, Width, action, ToolTip, icon, cstyl, cAlign ) CLASS TMessageBar

   LOCAL styl, nItem, i, nRep

   ASSIGN Width VALUE Width TYPE "N" DEFAULT 50

   styl := 0
   IF ValType( cStyl ) $ "CM" .AND. ! Empty( cStyl )
      cStyl := UPPER( ALLTRIM( cStyl ) )
      IF     "RAISED" = cStyl
         styl := 1
      ELSEIF "FLAT"   = cStyl
         styl := 2
      ENDIF
   ENDIF

   nRep := 0
   IF ValType( cAlign ) $ "CM" .AND. ! Empty( cAlign )
      cAlign := UPPER( ALLTRIM( cAlign ) )
      IF cAlign == "CENTER"
         nRep := 1
      ELSEIF cAlign == "RIGHT"
         nRep := 2
      ENDIF
   ENDIF

   IF ! ::lAutoAdjust
      nItem := InitItemBar( ::hWnd, Replicate( Chr( 9 ), nRep ) + Caption, 0, Width, 2, Icon, ToolTip, styl )
   ELSEIF LEN( ::aWidths ) == 0
      nItem := InitItemBar( ::hWnd, Replicate( Chr( 9 ), nRep ) + Caption, 0, Width, 0, Icon, ToolTip, styl )
   ELSE
      nItem := InitItemBar( ::hWnd, Replicate( Chr( 9 ), nRep ) + Caption, 0, Width, 1, Icon, ToolTip, styl )
   ENDIF

   ASIZE( ::aClicks, nItem )
   ::aClicks[ nItem ] := action

   ASIZE( ::aRClicks, nItem )

   ASIZE( ::aDblClicks, nItem )

   ASIZE( ::aRDblClicks, nItem )

   ASIZE( ::aWidths, nItem )
   ::aWidths[ nItem ] := Width

   ASIZE( ::aAligns, nItem )
   ::aAligns[ nItem ] := cAlign

   i := At( "&", Caption )
   IF i > 0 .AND. i < LEN( Caption )
      DEFINE HOTKEY 0 PARENT ( Self ) KEY "ALT+" + SubStr( Caption, i + 1, 1 ) ACTION ::DoEvent( ::aClicks[ nItem ], "CLICK" )
   ENDIF

   RETURN nItem

METHOD Item( nItem, uValue, cAlign ) CLASS TMessageBar

   /* If third parameter is NIL the previous alignment is used */
   LOCAL nRep

   IF ValType( uValue ) $ "CM"
      nRep := 0
      IF cAlign == Nil .AND. nItem >= 1 .AND. nItem <= Len( ::aAligns )
         cAlign := ::aAligns[ nItem ]
      ENDIF
      IF ValType( cAlign ) $ "CM" .AND. ! Empty( cAlign )
         cAlign := UPPER( ALLTRIM( cAlign ) )
         IF cAlign == "CENTER"
            nRep := 1
         ELSEIF cAlign == "RIGHT"
            nRep := 2
         ENDIF
      ENDIF
      IF nItem >= 1 .AND. nItem <= Len( ::aAligns )
         ::aAligns[ nItem ] := cAlign
      ENDIF
      SetItemBar( ::hWnd, Replicate( Chr( 9 ), nRep ) + uValue, nItem - 1 )
   ENDIF

   RETURN GetItemBar( ::hWnd, nItem - 1 )

METHOD ItemAlign( nItem, cAlign )

   LOCAL uRet

   IF ValType( cAlign ) $ "CM" .AND. nItem >= 1 .AND. nItem <= Len( ::aAligns )
      ::Item( nItem, ::Item( nItem ), cAlign )
      uRet := ::aAligns[ nItem ]
   ELSE
      uRet := Nil
   ENDIF

   RETURN uRet

METHOD ItemWidth( nItem, nWidth ) CLASS TMessageBar

   IF ValType( nWidth ) == "N" .AND. nItem >= 2 .AND. nItem <= ::ItemCount
      IF Len( ::aWidths ) < ::ItemCount
         ASIZE( ::aWidths, ::ItemCount )
      ENDIF
      ::aWidths[ nItem ] := nWidth
      RefreshItemBar( ::hWnd, ::aWidths, ::lAutoAdjust )
      ::aWidths[ 1 ] := GetItemWidth( ::hWnd, 1 )
   ENDIF

   RETURN GetItemWidth( ::hWnd, nItem )

METHOD ItemToolTip( nItem, cValue ) CLASS TMessageBar

   IF ValType( cValue ) $ "CM"
      SetItemToolTip( ::hWnd, cValue, nItem - 1 )
   ENDIF

   RETURN GetItemToolTip( ::hWnd, nItem - 1 )

METHOD ItemIcon( nItem, cIcon ) CLASS TMessageBar

   RETURN SetStatusItemIcon( ::hWnd, nItem, cIcon )

METHOD ItemClick( nItem, bAction ) CLASS TMessageBar

   IF nItem >= 1 .AND. nItem <= LEN( ::aClicks )
      IF PCOUNT() >= 2
         IF ! HB_IsBlock( bAction )
            bAction := NIL
         ENDIF
         ::aClicks[ nItem ] := bAction
      ELSE
         bAction := ::aClicks[ nItem ]
      ENDIF
   ENDIF

   RETURN bAction

METHOD ItemRClick( nItem, bAction ) CLASS TMessageBar

   IF nItem >= 1 .AND. nItem <= LEN( ::aRClicks )
      IF PCOUNT() >= 2
         IF ! HB_IsBlock( bAction )
            bAction := NIL
         ENDIF
         ::aRClicks[ nItem ] := bAction
      ELSE
         bAction := ::aRClicks[ nItem ]
      ENDIF
   ENDIF

   RETURN bAction

METHOD ItemDblClick( nItem, bAction ) CLASS TMessageBar

   IF nItem >= 1 .AND. nItem <= LEN( ::aDblClicks )
      IF PCOUNT() >= 2
         IF ! HB_IsBlock( bAction )
            bAction := NIL
         ENDIF
         ::aDblClicks[ nItem ] := bAction
      ELSE
         bAction := ::aDblClicks[ nItem ]
      ENDIF
   ENDIF

   RETURN bAction

METHOD ItemRDblClick( nItem, bAction ) CLASS TMessageBar

   IF nItem >= 1 .AND. nItem <= LEN( ::aRDblClicks )
      IF PCOUNT() >= 2
         IF ! HB_IsBlock( bAction )
            bAction := NIL
         ENDIF
         ::aRDblClicks[ nItem ] := bAction
      ELSE
         bAction := ::aRDblClicks[ nItem ]
      ENDIF
   ENDIF

   RETURN bAction

METHOD SetClock( Width, ToolTip, action, lAmPm, icon, cstyl, cAlign ) CLASS TMessageBar

   LOCAL nrItem

   IF ValType( lAmPm ) != "L"
      lAmPm := .F.
   ENDIF
   IF ValType( Width ) != 'N'
      Width := If( lAmPm, 95, 70 )
   ENDIF
   IF ! ValType( ToolTip ) $ "CM"
      ToolTip := 'Clock'
   ENDIF

   IF ! lAmPm
      nrItem := ::AddItem( Time(), Width, action, ToolTip, icon, cstyl, cAlign )
      TTimer():Define(, Self, 1000, { || ::Item( nrItem, Time(), Nil ) } )
   ELSE
      nrItem := ::AddItem( TMessageBar_AmPmClock(), Width, action, ToolTip, icon, cstyl, cAlign )
      TTimer():Define(, Self, 1000, { || ::Item( nrItem, TMessageBar_AmPmClock(), Nil ) } )
   ENDIF

   RETURN NIL

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

METHOD SetKeybrd( Width, ToolTip, action, icon, cstyl, cAlign ) CLASS TMessageBar

   LOCAL nrItem1, nrItem2, nrItem3

   IF ValType( Width ) == 'U'
      Width := 45
   ENDIF
   IF ValType( ToolTip ) == 'U'
      ToolTip := ''
   ENDIF
   IF ValType( Action ) == 'U'
      Action := ''
   ENDIF
   IF ValType( icon ) $ "CM"
      ::cLedOn := icon
   ELSEIF ValType( icon ) == "A" .AND. Len( icon ) > 0
      IF ValType( icon[ 1 ] ) $ "CM"
         ::cLedOn := icon[ 1 ]
      ENDIF
      IF Len( icon ) > 1 .AND. ValType( icon[ 2 ] ) $ "CM"
         ::cLedOff := icon[ 2 ]
      ENDIF
   ENDIF

   nrItem1 := ::AddItem( "Num", Max( GetTextWidth( Nil, "Num", ::FontHandle ) + 36, Width ), action, ToolTip, if( IsNumLockActive(), ::cLedOn, ::cLedOff ), cstyl, cAlign )
   nrItem2 := ::AddItem( "Caps", Max( GetTextWidth( Nil, "Caps", ::FontHandle ) + 36, Width ), action, ToolTip, if( IsCapsLockActive(), ::cLedOn, ::cLedOff ), cstyl, cAlign )
   nrItem3 := ::AddItem( "Ins", Max( GetTextWidth( Nil, "Ins", ::FontHandle ) + 36, Width ), action, ToolTip, if( IsCapsLockActive(), ::cLedOn, ::cLedOff ), cstyl, cAlign )

   IF Empty( Action )
      ::aClicks[ nrItem1 ] := { || KeyToggle( VK_NUMLOCK ) }
      ::aClicks[ nrItem2 ] := { || KeyToggle( VK_CAPITAL ) }
      ::aClicks[ nrItem3 ] := { || KeyToggle( VK_INSERT ) }
   ELSE
      ::aClicks[ nrItem1 ] := Action
      ::aClicks[ nrItem2 ] := Action
      ::aClicks[ nrItem3 ] := Action
   ENDIF

   TTimer():Define(, Self, 400, ;
      {|| SetStatusItemIcon( ::hWnd, nrItem1, if ( IsNumLockActive(), ::cLedOn, ::cLedOff ) ), ;
      SetStatusItemIcon( ::hWnd, nrItem2, if ( IsCapsLockActive(), ::cLedOn, ::cLedOff ) ), ;
      SetStatusItemIcon( ::hWnd, nrItem3, if ( IsInsertActive(), ::cLedOn, ::cLedOff ) ) } )

   RETURN NIL

METHOD SetDate( Width, ToolTip, action, icon, cstyl, cAlign ) CLASS TMessageBar

   ASSIGN Width VALUE Width TYPE "N" DEFAULT If( "yyyy" $ Lower( Set( _SET_DATEFORMAT ) ), 95, 75 )

   RETURN ::AddItem( Dtoc( Date() ), Width, action, ToolTip, icon, cstyl, cAlign )

METHOD Events_Notify( wParam, lParam ) CLASS TMessageBar

   LOCAL nNotify := GetNotifyCode( lParam )
   LOCAL x, lRet

   IF nNotify == NM_CLICK
      DefWindowProc( ::hWnd, NM_CLICK, wParam, lParam )
      x := GetItemPos( lParam ) + 1
      IF x > 0 .AND. x <= Len( ::aClicks )
         lRet := ::DoEventMouseCoords( ::aClicks[ x ], "CLICK" )
         IF HB_IsLogical( lRet ) .AND. lRet
            // supress default processing

            RETURN lRet
         ENDIF
      ENDIF
   ELSEIF nNotify == NM_RCLICK
      DefWindowProc( ::hWnd, NM_RCLICK, wParam, lParam )
      x := GetItemPos( lParam ) + 1
      IF x > 0 .AND. x <= Len( ::aRClicks )
         lRet := ::DoEventMouseCoords( ::aRClicks[ x ], "RCLICK" )
         IF HB_IsLogical( lRet ) .AND. lRet
            // supress default processing

            RETURN lRet
         ENDIF
      ENDIF
   ELSEIF nNotify == NM_DBLCLK
      DefWindowProc( ::hWnd, NM_DBLCLK, wParam, lParam )
      x := GetItemPos( lParam ) + 1
      IF x > 0 .AND. x <= Len( ::aDblClicks )
         lRet := ::DoEventMouseCoords( ::aDblClicks[ x ], "DBLCLICK" )
         IF HB_IsLogical( lRet ) .AND. lRet
            // supress default processing

            RETURN lRet
         ENDIF
      ENDIF
   ELSEIF nNotify == NM_RDBLCLK
      DefWindowProc( ::hWnd, NM_RDBLCLK, wParam, lParam )
      x := GetItemPos( lParam ) + 1
      IF x > 0 .AND. x <= Len( ::aRDblClicks )
         lRet := ::DoEventMouseCoords( ::aRDblClicks[ x ], "RDBLCLICK" )
         IF HB_IsLogical( lRet ) .AND. lRet
            // supress default processing

            RETURN lRet
         ENDIF
      ENDIF
   ENDIF

   RETURN ::Super:Events_Notify( wParam, lParam )

METHOD Events_Size() CLASS TMessageBar

   LOCAL nWidth, nOldWidth

   nWidth := GetWindowWidth( ::hWnd )
   IF ! ::nWidth == nWidth
      nOldWidth := ::nWidth
      ::nWidth := nWidth
      AEVAL( ::aControls, { |o| o:AdjustAnchor( 0, nWidth - nOldWidth ) } )
   ENDIF
   ::RefreshData()
   AEVAL( ::aControls, { |o| o:Events_Size() } )

   RETURN ::Super:Events_Size()

METHOD RefreshData() CLASS TMessageBar

   RefreshItemBar( ::hWnd, ::aWidths, ::lAutoAdjust )
   IF LEN( ::aWidths ) >= 1
      ::aWidths[ 1 ] := GetItemWidth( ::hWnd, 1 )
   ENDIF

   RETURN ::Super:RefreshData()

METHOD MinHeight( nWidth ) CLASS TMessageBar

   SendMessage( ::hWnd, SB_SETMINHEIGHT, nWidth, 0 )
   SendMessage( ::hWnd, WM_SIZE, 0, 0 )

   RETURN ::ClientHeightUsed()

FUNCTION _EndMessageBar()

   _OOHG_ActiveMessageBar := Nil
   _OOHG_DeleteFrame( "MESSAGEBAR" )

   RETURN NIL

FUNCTION _SetStatusClock( nSize, cToolTip, uAction, lAmPm, icon, cstyl, cAlign )

   RETURN _OOHG_ActiveMessageBar:SetClock( nSize, cToolTip, uAction, lAmPm, icon, cstyl, cAlign )

FUNCTION _SetStatusKeybrd( nSize, cToolTip, uAction, icon, cstyl, cAlign )

   RETURN _OOHG_ActiveMessageBar:SetKeybrd( nSize, cToolTip, uAction, icon, cstyl, cAlign )

FUNCTION _SetStatusItem( Caption, Width, action, ToolTip, icon, cstyl, cAlign )

   RETURN _OOHG_ActiveMessageBar:AddItem( Caption, Width, action, ToolTip, icon, cstyl, cAlign )

#pragma BEGINDUMP

#ifndef HB_OS_WIN_32_USED
   #define HB_OS_WIN_32_USED
#endif

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

HB_FUNC( INITITEMBAR )
{
   HWND  hWndSB;
   int   cSpaceInBetween = 8;
   int   ptArray[ NUM_OF_PARTS ];
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
      SendMessage( hWndSB, SB_GETPARTS, (WPARAM) NUM_OF_PARTS, (LPARAM) (LPINT) ptArray );
   }
   nrOfParts ++;

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
      for( n = 0; n < nrOfParts - 1; n ++ )
      {
         ptArray[ n ] -= hb_parni( 4 ) - cSpaceInBetween;
      }
      ptArray[ nrOfParts - 1 ] = rect.right;
   }

   ReleaseDC( hWndSB, hDC );

   SendMessage( hWndSB, SB_SETPARTS, (WPARAM) nrOfParts, (LPARAM) (LPINT) ptArray );

   cy = rect.bottom - rect.top - 4;
   cx = cy;

   hIcon = (HICON) LoadImage( 0, hb_parc( 6 ), IMAGE_ICON, cx, cy, LR_LOADFROMFILE );

   if( ! hIcon )
   {
      hIcon = (HICON) LoadImage( GetModuleHandle(NULL), hb_parc( 6 ), IMAGE_ICON, cx, cy, 0 );
   }

   if( hIcon != NULL )
   {
      SendMessage( hWndSB, SB_SETICON, (WPARAM) ( nrOfParts - 1 ), (LPARAM) hIcon );
   }

   SendMessage( hWndSB, SB_SETTEXT, (WPARAM) ( ( nrOfParts - 1 ) | displayFlags ), (LPARAM) hb_parc( 2 ) );
   SendMessage( hWndSB, SB_SETTIPTEXT, (WPARAM) ( nrOfParts - 1 ), (LPARAM) hb_parc( 7 ) );

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
            iWidth -= HB_PARNI( 2, (iCount + 1 ));
         }
      }
      else
      {
         iWidth = 0;
         for( iCount = 0; iCount < iItems; iCount++ )
         {
            iWidth += HB_PARNI( 2, (iCount + 1) );
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
   COLORREF Color;

   if( _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &oSelf->lBackColor, ( hb_pcount() >= 1 ) ) )
   {
      if( ValidHandler( oSelf->hWnd ) )
      {
         Color = ( oSelf->lBackColor == -1 ) ? CLR_DEFAULT : (COLORREF) oSelf->lBackColor;
         SendMessage( oSelf->hWnd, SB_SETBKCOLOR, 0, Color );
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   // Return value was set in _OOHG_DetermineColorReturn()
}

#pragma ENDDUMP
