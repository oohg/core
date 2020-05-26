/*
 * $Id: h_status.prg $
 */
/*
 * ooHG source code:
 * Statusbar control
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
   DATA oTimer      INIT NIL

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
   METHOD InitTimeout
   METHOD Release
   METHOD Events_Notify
   METHOD Events_Size
   METHOD RefreshData

   ENDCLASS

METHOD Define( ControlName, ParentForm, y, x, w, h, caption, ProcedureName, ;
               fontname, nFontsize, tooltip, clock, date, kbd, nClrF, nClrB, ;
               bold, italic, underline, strikeout, lTop, lNoAutoAdjust, ;
               Width, icon, cstyl, cAlign ) CLASS TMessageBar

   Local ControlHandle

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
   If ValType( Caption ) $ "CM"
      ::AddItem( Caption, Width, ProcedureName, ToolTip, icon, cstyl, cAlign, NIL )

      // Set as default message
      ::cStatMsg := Caption
   Endif

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

   Return Self

METHOD AddItem( Caption, Width, action, ToolTip, icon, cstyl, cAlign, lDefault ) CLASS TMessageBar

   Local styl, nItem, i, nRep

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

   nRep := 0
   If ValType( cAlign ) $ "CM" .AND. ! Empty( cAlign )
      cAlign := UPPER( ALLTRIM( cAlign ) )
      If cAlign == "CENTER"
         nRep := 1
      ElseIf cAlign == "RIGHT"
         nRep := 2
      EndIf
   EndIf

   If ! ::lAutoAdjust
      nItem := InitItemBar( ::hWnd, Replicate( Chr( 9 ), nRep ) + Caption, 0, Width, 2, Icon, ToolTip, styl )
   ElseIf LEN( ::aWidths ) == 0
      nItem := InitItemBar( ::hWnd, Replicate( Chr( 9 ), nRep ) + Caption, 0, Width, 0, Icon, ToolTip, styl )
   Else
      nItem := InitItemBar( ::hWnd, Replicate( Chr( 9 ), nRep ) + Caption, 0, Width, 1, Icon, ToolTip, styl )
   EndIf

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
   If i > 0 .AND. i < LEN( Caption )
      DEFINE HOTKEY 0 PARENT ( Self ) KEY "ALT+" + SubStr( Caption, i + 1, 1 ) ACTION ::DoEvent( ::aClicks[ nItem ], "CLICK" )
   EndIf

   IF HB_ISLOGICAL( lDefault ) .AND. lDefault
      ::cStatMsg := Caption
   ENDIF

   Return nItem

METHOD Item( nItem, uValue, cAlign ) CLASS TMessageBar

   /* If third parameter is NIL the previous alignment is used */
   Local nRep

   If ValType( uValue ) $ "CM"
      nRep := 0
      If cAlign == Nil .AND. nItem >= 1 .AND. nItem <= Len( ::aAligns )
         cAlign := ::aAligns[ nItem ]
      EndIf
      If ValType( cAlign ) $ "CM" .AND. ! Empty( cAlign )
         cAlign := UPPER( ALLTRIM( cAlign ) )
         If cAlign == "CENTER"
            nRep := 1
         ElseIf cAlign == "RIGHT"
            nRep := 2
         EndIf
      EndIf
      If nItem >= 1 .AND. nItem <= Len( ::aAligns )
         ::aAligns[ nItem ] := cAlign
      EndIf
      SetItemBar( ::hWnd, Replicate( Chr( 9 ), nRep ) + uValue, nItem - 1 )
   EndIf

   Return GetItemBar( ::hWnd, nItem - 1 )

METHOD ItemAlign( nItem, cAlign )

   Local uRet

   If ValType( cAlign ) $ "CM" .AND. nItem >= 1 .AND. nItem <= Len( ::aAligns )
      ::Item( nItem, ::Item( nItem ), cAlign )
      uRet := ::aAligns[ nItem ]
   Else
      uRet := Nil
   EndIf

   Return uRet

METHOD ItemWidth( nItem, nWidth ) CLASS TMessageBar

   If ValType( nWidth ) == "N" .AND. nItem >= 2 .AND. nItem <= ::ItemCount
      If Len( ::aWidths ) < ::ItemCount
         ASIZE( ::aWidths, ::ItemCount )
      EndIf
      ::aWidths[ nItem ] := nWidth
      RefreshItemBar( ::hWnd, ::aWidths, ::lAutoAdjust )
      ::aWidths[ 1 ] := GetItemWidth( ::hWnd, 1 )
   EndIf

   Return GetItemWidth( ::hWnd, nItem )

METHOD ItemToolTip( nItem, cValue ) CLASS TMessageBar

   IF ValType( cValue ) $ "CM"
      SetItemToolTip( ::hWnd, cValue, nItem - 1 )
   ENDIF

   Return GetItemToolTip( ::hWnd, nItem - 1 )

METHOD ItemIcon( nItem, cIcon ) CLASS TMessageBar

   Return SetStatusItemIcon( ::hWnd, nItem, cIcon )

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

   Return bAction

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

   Return bAction

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

   Return bAction

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

   Return bAction

METHOD InitTimeout( nLapse, nItem ) CLASS TMessageBar

   IF ! HB_ISNUMERIC( nLapse )
      nLapse := GetDoubleClickTime() * 10
   ELSEIF nLapse == 0
      RETURN NIL
   ELSEIF nLapse < 1000
      nLapse := GetDoubleClickTime() * 10
   ENDIF
/*
   IF ! HB_ISNUMERIC( nLapse ) .OR. nLapse < 1000
      nLapse := GetDoubleClickTime() * 10
   ENDIF
*/
   IF ! HB_ISNUMERIC( nItem ) .OR. nItem < 1 .OR. nItem > ::ItemCount
      nItem := 1
   ENDIF
   IF HB_ISOBJECT( ::oTimer )
      ::oTimer:Enabled := .F.
      ::oTimer:Value   := nLapse
      ::oTimer:OnClick := {|| ::oTimer:Enabled := .F., ::Item( nItem, "" ) }
      ::oTimer:Enabled := .T.
   ELSE
      DEFINE TIMER 0 OBJ ::oTimer PARENT ( Self ) INTERVAL nLapse ACTION {|| ::oTimer:Enabled := .F., ::Item( nItem, "" ) }
   ENDIF

   RETURN NIL

METHOD Release() CLASS TMessageBar

   IF HB_ISOBJECT( ::oTimer )
      ::oTimer:Release()
   ENDIF

   RETURN ::Super:Release()

METHOD SetClock( Width, ToolTip, action, lAmPm, icon, cstyl, cAlign ) CLASS TMessageBar

   Local nrItem

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
      nrItem := ::AddItem( Time(), Width, action, ToolTip, icon, cstyl, cAlign )
      TTimer():Define(, Self, 1000, { || ::Item( nrItem, Time(), Nil ) } )
   Else
      nrItem := ::AddItem( TMessageBar_AmPmClock(), Width, action, ToolTip, icon, cstyl, cAlign )
      TTimer():Define(, Self, 1000, { || ::Item( nrItem, TMessageBar_AmPmClock(), Nil ) } )
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

   Return cTime

METHOD SetKeybrd( Width, ToolTip, action, icon, cstyl, cAlign ) CLASS TMessageBar

   local nrItem1, nrItem2, nrItem3

   If ValType( Width ) == 'U'
      Width := 45
   EndIf
   If ValType( ToolTip ) == 'U'
      ToolTip := ''
   EndIf
   If ValType( Action ) == 'U'
      Action := ''
   EndIf
   If ValType( icon ) $ "CM"
      ::cLedOn := icon
   ElseIf ValType( icon ) == "A" .AND. Len( icon ) > 0
      If ValType( icon[ 1 ] ) $ "CM"
         ::cLedOn := icon[ 1 ]
      EndIf
      If Len( icon ) > 1 .AND. ValType( icon[ 2 ] ) $ "CM"
         ::cLedOff := icon[ 2 ]
      EndIf
   EndIf

   nrItem1 := ::AddItem( "Num", Max( GetTextWidth( Nil, "Num", ::FontHandle ) + 36, Width ), action, ToolTip, if( IsNumLockActive(), ::cLedOn, ::cLedOff ), cstyl, cAlign )
   nrItem2 := ::AddItem( "Caps", Max( GetTextWidth( Nil, "Caps", ::FontHandle ) + 36, Width ), action, ToolTip, if( IsCapsLockActive(), ::cLedOn, ::cLedOff ), cstyl, cAlign )
   nrItem3 := ::AddItem( "Ins", Max( GetTextWidth( Nil, "Ins", ::FontHandle ) + 36, Width ), action, ToolTip, if( IsCapsLockActive(), ::cLedOn, ::cLedOff ), cstyl, cAlign )

   If Empty( Action )
      ::aClicks[ nrItem1 ] := { || KeyToggle( VK_NUMLOCK ) }
      ::aClicks[ nrItem2 ] := { || KeyToggle( VK_CAPITAL ) }
      ::aClicks[ nrItem3 ] := { || KeyToggle( VK_INSERT ) }
   Else
      ::aClicks[ nrItem1 ] := Action
      ::aClicks[ nrItem2 ] := Action
      ::aClicks[ nrItem3 ] := Action
   EndIf

   TTimer():Define(, Self, 400, ;
      {|| SetStatusItemIcon( ::hWnd, nrItem1, if ( IsNumLockActive(), ::cLedOn, ::cLedOff ) ), ;
          SetStatusItemIcon( ::hWnd, nrItem2, if ( IsCapsLockActive(), ::cLedOn, ::cLedOff ) ), ;
          SetStatusItemIcon( ::hWnd, nrItem3, if ( IsInsertActive(), ::cLedOn, ::cLedOff ) ) } )

   Return Nil

METHOD SetDate( Width, ToolTip, action, icon, cstyl, cAlign ) CLASS TMessageBar

   ASSIGN Width VALUE Width TYPE "N" DEFAULT If( "yyyy" $ Lower( Set( _SET_DATEFORMAT ) ), 95, 75 )

   Return ::AddItem( Dtoc( Date() ), Width, action, ToolTip, icon, cstyl, cAlign )

METHOD Events_Notify( wParam, lParam ) CLASS TMessageBar

   Local nNotify := GetNotifyCode( lParam )
   Local x, lRet

   If nNotify == NM_CLICK
      DefWindowProc( ::hWnd, NM_CLICK, wParam, lParam )
      x := GetItemPos( lParam ) + 1
      If x > 0 .AND. x <= Len( ::aClicks )
         lRet := ::DoEventMouseCoords( ::aClicks[ x ], "CLICK" )
         If HB_IsLogical( lRet ) .AND. lRet
            // supress default processing
            Return lRet
         EndIf
      EndIf
   ElseIf nNotify == NM_RCLICK
      DefWindowProc( ::hWnd, NM_RCLICK, wParam, lParam )
      x := GetItemPos( lParam ) + 1
      If x > 0 .AND. x <= Len( ::aRClicks )
         lRet := ::DoEventMouseCoords( ::aRClicks[ x ], "RCLICK" )
         If HB_IsLogical( lRet ) .AND. lRet
            // supress default processing
            Return lRet
         EndIf
      EndIf
   ElseIf nNotify == NM_DBLCLK
      DefWindowProc( ::hWnd, NM_DBLCLK, wParam, lParam )
      x := GetItemPos( lParam ) + 1
      If x > 0 .AND. x <= Len( ::aDblClicks )
         lRet := ::DoEventMouseCoords( ::aDblClicks[ x ], "DBLCLICK" )
         If HB_IsLogical( lRet ) .AND. lRet
            // supress default processing
            Return lRet
         EndIf
      EndIf
   ElseIf nNotify == NM_RDBLCLK
      DefWindowProc( ::hWnd, NM_RDBLCLK, wParam, lParam )
      x := GetItemPos( lParam ) + 1
      If x > 0 .AND. x <= Len( ::aRDblClicks )
         lRet := ::DoEventMouseCoords( ::aRDblClicks[ x ], "RDBLCLICK" )
         If HB_IsLogical( lRet ) .AND. lRet
            // supress default processing
            Return lRet
         EndIf
      EndIf
   EndIf

   Return ::Super:Events_Notify( wParam, lParam )

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

   Return ::Super:Events_Size()

METHOD RefreshData() CLASS TMessageBar

   RefreshItemBar( ::hWnd, ::aWidths, ::lAutoAdjust )
   IF LEN( ::aWidths ) >= 1
      ::aWidths[ 1 ] := GetItemWidth( ::hWnd, 1 )
   ENDIF

   Return ::Super:RefreshData()

METHOD MinHeight( nWidth ) CLASS TMessageBar

   SendMessage( ::hWnd, SB_SETMINHEIGHT, nWidth, 0 )
   SendMessage( ::hWnd, WM_SIZE, 0, 0 )

   Return ::ClientHeightUsed()

Function _EndMessageBar()

   _OOHG_ActiveMessageBar := Nil
   _OOHG_DeleteFrame( "MESSAGEBAR" )

   Return Nil

FUNCTION _SetStatusClock( nSize, cToolTip, uAction, lAmPm, icon, cstyl, cAlign )

   Return _OOHG_ActiveMessageBar:SetClock( nSize, cToolTip, uAction, lAmPm, icon, cstyl, cAlign )

FUNCTION _SetStatusKeybrd( nSize, cToolTip, uAction, icon, cstyl, cAlign )

   Return _OOHG_ActiveMessageBar:SetKeybrd( nSize, cToolTip, uAction, icon, cstyl, cAlign )

FUNCTION _SetStatusItem( Caption, Width, action, ToolTip, icon, cstyl, cAlign, lDefault )

   Return _OOHG_ActiveMessageBar:AddItem( Caption, Width, action, ToolTip, icon, cstyl, cAlign, lDefault )


#pragma BEGINDUMP

#include "oohg.h"
#include "hbstack.h"

#define NUM_OF_PARTS 40

/*--------------------------------------------------------------------------------------------------------------------------------*/
static WNDPROC _OOHG_TMessageBar_lpfnOldWndProc( LONG_PTR lp )
{
   static LONG_PTR lpfnOldWndProc = 0;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( ! lpfnOldWndProc )
   {
      lpfnOldWndProc = lp;
   }
   ReleaseMutex( _OOHG_GlobalMutex() );

   return (WNDPROC) lpfnOldWndProc;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, _OOHG_TMessageBar_lpfnOldWndProc( 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( INITMESSAGEBAR )          /* FUNCTION InitMonthCal( hWnd, cCaption, nId, lTop ) -> hWnd */
{
   HWND hCtrl;
   int Style;

   Style = WS_CHILD | WS_VISIBLE | WS_BORDER | SBT_TOOLTIPS;
   if( hb_parl( 4 ) )
   {
      Style |= CCS_TOP;
   }

   InitCommonControls();

   hCtrl = CreateStatusWindow( Style, hb_parc( 2 ), HWNDparam( 1 ), hb_parni ( 3 ) );

   _OOHG_TMessageBar_lpfnOldWndProc( SetWindowLongPtr( hCtrl, GWLP_WNDPROC, (LONG_PTR) SubClassFunc ) );

   HWNDret( hCtrl );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GETITEMCOUNT )
{
   hb_retni( SendMessage( HWNDparam( 1 ), SB_GETPARTS, 0, 0 ) );
}

HB_FUNC( SETITEMBAR )
{
   SendMessage( HWNDparam( 1 ), SB_SETTEXT, hb_parni( 3 ), (LPARAM) HB_UNCONST( hb_parc( 2 ) ) );
}

HB_FUNC( GETITEMBAR )
{
   char *cString;
   HWND hWnd;
   int iPos;

   hWnd = HWNDparam( 1 );
   iPos = hb_parni( 2 );
   cString = (char *) hb_xgrab( LOWORD( SendMessage( hWnd, SB_GETTEXTLENGTH, iPos, 0 ) ) + 1 );
   SendMessage( hWnd, SB_GETTEXT, (WPARAM) iPos, (LPARAM) cString );
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

   SendMessage( hWndSB, SB_SETTEXT, (WPARAM) ( ( nrOfParts - 1 ) | displayFlags ), (LPARAM) HB_UNCONST( hb_parc( 2 ) ) );
   SendMessage( hWndSB, SB_SETTIPTEXT, (WPARAM) ( nrOfParts - 1 ), (LPARAM) HB_UNCONST( hb_parc( 7 ) ) );

   hb_retni( nrOfParts );
}

/* TODO: check */
HB_FUNC( GETITEMWIDTH )
{
   HWND  hWnd;
   int   *piItems;
   UINT iItems, iSize, iPos;

   hWnd = HWNDparam( 1 );
   iPos = hb_parni( 2 );
   iItems = SendMessage( hWnd, SB_GETPARTS, 0, 0 );
   iSize = 0;
   if( iItems != 0 && iPos <= iItems )
   {
      piItems = (int *) hb_xgrab( sizeof(int) * iItems );
      SendMessage( hWnd, SB_GETPARTS, iItems, (LPARAM) piItems );
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
   SendMessage( HWNDparam( 1 ), SB_SETTIPTEXT, hb_parni( 3 ), (LPARAM) HB_UNCONST( hb_parc( 2 ) ) );
}

HB_FUNC( GETITEMTOOLTIP )
{
   char cBuffer[ 1024 ];

   cBuffer[ 0 ] = 0;
   SendMessage( HWNDparam( 1 ), SB_GETTIPTEXT,
                MAKEWPARAM( hb_parni( 2 ), 1023 ),
                (LPARAM) cBuffer );

   hb_retc( cBuffer );
}

/* TODO: check */
HB_FUNC( REFRESHITEMBAR )          /* FUNCTION RefreshItemBar( hWnd, aWidths, lAutoAdjust ) -> nItems */
{
   HWND  hWnd;
   int   *piItems;
   int   iItems, iWidth, iCount;
   RECT  rect;

   hWnd = HWNDparam( 1 );
   iItems = SendMessage( hWnd, SB_GETPARTS, 0, 0 );
   if( iItems != 0 )
   {
      /* GetWindowRect( hWnd, &rect ); */
      GetClientRect( GetParent( hWnd ), &rect );
      iWidth = rect.right - rect.left;

      piItems = (int *) hb_xgrab( sizeof(int) * iItems );
      SendMessage( hWnd, SB_GETPARTS, iItems, (WPARAM) piItems );
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
      SendMessage( hWnd, SB_SETPARTS, iItems, (LPARAM) piItems );
      MoveWindow( hWnd, 0, 0, 0, 0, TRUE );
      hb_xfree( piItems );
   }
   hb_retni( iItems );
}

/* TODO: check */
HB_FUNC( SETSTATUSITEMICON )
{
   HWND hwnd;
   RECT rect;
   HICON hIcon ;
   int cx, cy;

   hwnd = HWNDparam( 1 );

   /* Unloads from memory current icon */
   DestroyIcon( (HICON) SendMessage( hwnd, SB_GETICON, (WPARAM) ( hb_parni( 2 ) - 1 ), (LPARAM) 0 ) );

   GetClientRect( hwnd, &rect );
   cy = rect.bottom - rect.top-4;
   cx = cy;

   hIcon = (HICON) LoadImage( GetModuleHandle( NULL ), hb_parc( 3 ), IMAGE_ICON, cx, cy, 0 );

   if( ! hIcon )
   {
      hIcon = (HICON) LoadImage( 0, hb_parc( 3 ), IMAGE_ICON, cx, cy, LR_LOADFROMFILE );
   }

   SendMessage( hwnd, SB_SETICON, (WPARAM) ( hb_parni( 2 ) - 1 ), (LPARAM) hIcon );
}

HB_FUNC( KEYTOGGLE )
{
   BYTE pBuffer[ 256 ];
   WORD wKey = (WORD) hb_parni( 1 );

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

   /* Return value was set in _OOHG_DetermineColorReturn() */
}

#pragma ENDDUMP
