/*
 * $Id: h_status.prg,v 1.15 2006-07-15 23:54:38 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG statusbar functions
 *
 * Copyright 2005 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.guerra.com.mx
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

   METHOD SetClock
   METHOD SetKeybrd

   METHOD Define
   METHOD Item
   METHOD Events_Notify
   METHOD Events_Size
   METHOD RefreshData
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, y, x, w, h, caption, ProcedureName, ;
               fontname, nFontsize, tooltip, clock, date, kbd, nClrF, nClrB, ;
               bold, italic, underline, strikeout, lTop ) CLASS TMessageBar
*-----------------------------------------------------------------------------*
Local ControlHandle

   EMPTY( nClrF )
   EMPTY( nClrB )
   y := x := 0

	if valtype (caption) == 'U'
      caption := ""
	EndIf
	if valtype (w) == 'U'
		w := 50
	EndIf
	if valtype (h) == 'U'
		h := 0
	EndIf

   ::SetForm( ControlName, ParentForm, FontName, nFontSize )
   ::Container := nil

   _OOHG_ActiveMessageBar := Self

//   ControlHandle := InitMessageBar( ::Parent:hWnd, Caption, 0, 0, 0, w , h, '', 0, clock, date, kbd  )
   ControlHandle := InitMessageBar( ::Parent:hWnd, Caption, 0, lTop  )

   ::Register( ControlHandle, ControlName, , , ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )
   ::SizePos( y, x, w, h )

   ::OnClick := ProcedureName
   ::Caption := Caption

   // Re-defines first status item
   IF ! Empty( Caption )
      TItemMessage():Define( , Self, , , Caption, ProcedureName, w, h, , , tooltip )
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

   // Add to browselist array to update on window activation
   aAdd( ::Parent:BrowseList, Self )

Return Self
/*
AGREGAR: lTop!!!  acImages!!!
Function _EndStatusBar ( cParentForm, acCaptions, anWidths, acImages, abActions, acToolTips, anStyles, ;
            cFontName, nFontSize, lFontBold, lFontItalic, lFontUnderLine, lFontStrikeOut, lTop )
	nControlhandle := InitStatusBar (	nParentHandle	, ;
						nId		, ;
						acCaptions	, ;
						anWidths	, ;
						acImages	, ;
						acToolTips	, ;
						anStyles	, ;
						lTop		;
					)
*/

*-----------------------------------------------------------------------------*
METHOD SetClock( Width , ToolTip , action ) CLASS TMessageBar
*-----------------------------------------------------------------------------*
local nrItem

   If ValType( Width ) != 'N'
		Width := 70
	EndIf
   If ! ValType( ToolTip ) $ "CM"
		ToolTip := 'Clock'
	EndIf
   If ValType( Action ) == 'U'
		Action := ''
	EndIf

   nrItem := TItemMessage():Define( "TimerBar",  Self, 0, 0, Time(), action , Width, 0, "" , ToolTip )

   TTimer():Define( 'StatusTimer', ::aControls[ nrItem ], 1000 , { || ::Item( nrItem , Time() ) } )

Return Nil

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

   nrItem1 := TItemMessage():Define( "TimerNum", Self, 0, 0, "Num", If ( empty (Action), {|| KeyToggle( VK_NUMLOCK ) }, Action ), GetTextWidth( NIL, "Num", ::FontHandle ) + 36, 0, ;
                     if ( IsNumLockActive() , "zzz_led_on" , "zzz_led_off" ), "", ToolTip)

   nrItem2 := TItemMessage():Define( "TimerCaps", Self, 0, 0, "Caps", If ( empty (Action), {|| KeyToggle( VK_CAPITAL ) }, Action ), GetTextWidth( NIL, "Caps", ::FontHandle ) + 36, 0,;
                     if ( IsCapsLockActive() , "zzz_led_on" , "zzz_led_off" ), "", ToolTip)

   nrItem3 := TItemMessage():Define( "TimerInsert", Self, 0, 0, "Ins", If ( empty (Action), {|| KeyToggle( VK_INSERT ) }, Action ), GetTextWidth( NIL, "Ins", ::FontHandle ) + 36, 0,;
                     if ( IsInsertActive() , "zzz_led_on" , "zzz_led_off" ), "", ToolTip)

   TTimer():Define( "StatusKeyBrd", ::aControls[ nrItem1 ], 400 , ;
      {|| SetStatusItemIcon( ::hWnd, nrItem1 , if ( IsNumLockActive() , "zzz_led_on" , "zzz_led_off" ) ), ;
          SetStatusItemIcon( ::hWnd, nrItem2 , if ( IsCapsLockActive() , "zzz_led_on" , "zzz_led_off" ) ), ;
          SetStatusItemIcon( ::hWnd, nrItem3 , if ( IsInsertActive() , "zzz_led_on" , "zzz_led_off" ) ) } )

Return Nil

*-----------------------------------------------------------------------------*
METHOD Item( nItem, uValue ) CLASS TMessageBar
*-----------------------------------------------------------------------------*
   IF VALTYPE( uValue  ) $ "CM"
      ::aControls[ nItem ]:Caption := uValue
      SetItemBar( ::hWnd, uValue, nItem - 1 )
   ENDIF
RETURN ::aControls[ nItem ]:Caption

*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TMessageBar
*-----------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam )
Local x

   If nNotify == NM_CLICK

      DefWindowProc( ::hWnd, NM_CLICK, wParam, lParam )

      x := GetItemPos( lParam )

      x := ASCAN( ::aControls, { |o| o:nPosition == x + 1 } )

      if x != 0

         if ::aControls[ x ]:DoEvent( ::aControls[ x ]:OnClick )

            Return nil

         EndIf

      EndIf

   EndIf

Return ::Super:Events_Notify( wParam, lParam )

*-----------------------------------------------------------------------------*
METHOD Events_Size() CLASS TMessageBar
*-----------------------------------------------------------------------------*
   ::RefreshData()
Return Super:Events_Size()

*-----------------------------------------------------------------------------*
METHOD RefreshData() CLASS TMessageBar
*-----------------------------------------------------------------------------*
Local aWidths
   aWidths := ARRAY( LEN( ::aControls ) )
   AEVAL( ::aControls, { |o,i| aWidths[ i ] := o:Width } )
   RefreshItemBar( ::hWnd, aWidths )
   IF LEN( ::aControls ) > 0
      ::aControls[ 1 ]:Width := GetItemWidth( ::hWnd, 1 )
   ENDIF
Return Self

*-----------------------------------------------------------------------------*
Function _EndMessageBar()
*-----------------------------------------------------------------------------*

   _OOHG_ActiveMessageBar := nil

Return Nil





CLASS TItemMessage FROM TControl
   DATA Type      INIT "ITEMMESSAGE" READONLY
   DATA nPosition INIT 0

   METHOD Define
   METHOD SizePos
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentControl, x, y, Caption, ProcedureName, w, ;
               h, icon, cstyl, tooltip ) CLASS TItemMessage
*-----------------------------------------------------------------------------*
Local i, styl, nKey, ControlHandle

   if valtype( ParentControl ) == 'U'
      ParentControl := _OOHG_ActiveMessageBar
   EndIf

   ::SetForm( , ParentControl )
   IF VALTYPE( ControlName ) $ "CM" .AND. upper( alltrim( ControlName ) ) == "STATUSITEM" .AND. ::Parent:Control( "STATUSITEM" ) == nil
      ::Name := "STATUSITEM"
   ENDIF

	do case
      case ! ValType( cStyl ) $ "CM"
         styl := 0
      case Upper( cStyl ) == "RAISED"
         styl := 1
      case Upper( cStyl ) == "FLAT"
         styl := 2
      otherwise
         styl := 0
 	endcase

   if valtype( w ) != "N"
		w := 70
	endif

   if valtype( h ) != "N"
		h := 0
	endif

   If LEN( ::Container:aControls ) == 0
      ControlHandle := InitItemBar ( ::Container:hWnd, Caption, 0, 0, 0, Icon , ToolTip, styl )
	Else
      ControlHandle := InitItemBar ( ::Container:hWnd, Caption, 0, w, 1, Icon , ToolTip, styl )
	EndIf

   ::Register( 0, ControlName, , , ToolTip )
   ::nPosition := ControlHandle
   ::SizePos( y, x, w, h )

   ::OnClick := ProcedureName
   ::Caption := Caption

   Caption := Upper( Caption )

   i := At( "&", Caption )

   IF i > 0 .AND. i < LEN( Caption )
      i := AT( Upper( SubStr( Caption, i + 1, 1 ) ), "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" )
      IF i > 0
         nKey := { VK_A, VK_B, VK_C, VK_D, VK_E, VK_F, VK_G, VK_H, ;
                   VK_I, VK_J, VK_K, VK_L, VK_M, VK_N, VK_O, VK_P, ;
                   VK_Q, VK_R, VK_S, VK_T, VK_U, VK_V, VK_W, VK_X, ;
                   VK_Y, VK_Z, VK_0, VK_1, VK_2, VK_3, VK_4, VK_5, ;
                   VK_6, VK_7, VK_8, VK_9 }[ i ]
         ::Parent:HotKey( nKey, MOD_ALT, ProcedureName )
      ENDIF
   ENDIF

Return ControlHandle

*-----------------------------------------------------------------------------*
METHOD SizePos( Row, Col, Width, Height ) CLASS TItemMessage
*-----------------------------------------------------------------------------*
   IF VALTYPE( Row ) == "N"
      ::nRow := Row
   ENDIF
   IF VALTYPE( Col ) == "N"
      ::nCol := Col
   ENDIF
   IF VALTYPE( Width ) == "N"
      ::nWidth := Width
   ENDIF
   IF VALTYPE( Height ) == "N"
      ::nHeight := Height
   ENDIF
Return 0





FUNCTION _SetStatusClock( nSize, cToolTip, uAction )
Return _OOHG_ActiveMessageBar:SetClock( nSize, cToolTip, uAction )

FUNCTION _SetStatusKeybrd( nSize, cToolTip, uAction )
Return _OOHG_ActiveMessageBar:SetKeybrd( nSize, cToolTip, uAction )





EXTERN InitMessageBar, InitItemBar, SetItemBar
EXTERN GetItemBar, GetItemCount, GetItemWidth, RefreshItemBar, KeyToggle, SetStatusItemIcon

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
// #include "hbvm.h"
// #include "hbstack.h"
// #include "hbapiitm.h"
// #include "winreg.h"
// #include "tchar.h"
// #include <stdlib.h>

#include "../include/oohg.h"

#define NUM_OF_PARTS 40

HB_FUNC( INITMESSAGEBAR )
{
    HWND hwnd;
    HWND hWndSB;
    int   ptArray[ NUM_OF_PARTS ];   // Array defining the number of parts/sections
    int  nrOfParts = 1;
    int  iStyle;

    hwnd = HWNDparam( 1 );

    iStyle = WS_CHILD | WS_VISIBLE | WS_BORDER | SBT_TOOLTIPS;
    if( hb_parl( 4 ) )
    {
       iStyle |= CCS_TOP;
    }

    hWndSB = CreateStatusWindow( iStyle, hb_parc(2), hwnd, hb_parni (3));
    if(hWndSB)
    {
	SendMessage(hWndSB, SB_SETPARTS, nrOfParts,  (LPARAM)(LPINT)ptArray);
    }

    HWNDret( hWndSB );
}
//--------------------------------------------------------

//void InitializeStatusBar(HWND hWndStatusbar, char *cMsg, int nSize, int nMsg)

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
      switch(hb_parni(8))
      {
         case  0:  displayFlags = 0 ; break;
         case  1:  displayFlags = SBT_POPOUT ; break;
         case  2:  displayFlags = SBT_NOBORDERS ; break;
         default : displayFlags = 0;
      }


    if ( hb_parnl (5)) {
       nrOfParts = SendMessage( hWndSB, SB_GETPARTS, 0, 0 );
      SendMessage(hWndSB,SB_GETPARTS, NUM_OF_PARTS, (LPARAM)(LPINT)ptArray);
	}
    nrOfParts ++ ;


    hDC = GetDC(hWndSB);
    GetClientRect(hWndSB, &rect);

    if (hb_parnl (5) == 0){
	    ptArray[nrOfParts-1] = rect.right;
    	}
    else {

        for ( n = 0 ; n < nrOfParts-1  ; n++)
            {
	        ptArray[n] -=  hb_parni (4) - cSpaceInBetween ;
	        }
	    ptArray[nrOfParts-1] = rect.right;
    }

	ReleaseDC(hWndSB, hDC);

	SendMessage(hWndSB,  SB_SETPARTS, nrOfParts,(LPARAM)(LPINT)ptArray);

	cy = rect.bottom - rect.top-4;
	cx = cy;

	hIcon = (HICON)LoadImage(0, hb_parc(6),IMAGE_ICON ,cx,cy , LR_LOADFROMFILE );

	if (hIcon==NULL)
	{
		hIcon = (HICON)LoadImage(GetModuleHandle(NULL),hb_parc(6),IMAGE_ICON ,cx,cy, 0 );
	}

	if (!(hIcon ==NULL))
	{
		SendMessage(hWndSB,SB_SETICON,(WPARAM)nrOfParts-1, (LPARAM)hIcon );
	}

   SendMessage( hWndSB, SB_SETTEXT, ( nrOfParts - 1 ) | displayFlags, ( LPARAM ) hb_parc( 2 ) );
   SendMessage( hWndSB, SB_SETTIPTEXT, ( WPARAM ) nrOfParts - 1, ( LPARAM ) hb_parc( 7 ) );

	hb_retni( nrOfParts );
}

HB_FUNC( SETITEMBAR )
{
    SendMessage( HWNDparam( 1 ), SB_SETTEXT, hb_parni( 3 ) , ( LPARAM ) hb_parc( 2 ) );
}

HB_FUNC( GETITEMBAR )
{
    char cString[ 1024 ] = "";
    SendMessage( HWNDparam( 1 ), SB_GETTEXT, ( WPARAM ) hb_parni( 2 ) - 1, ( LPARAM ) cString );
    hb_retc( cString );
}

HB_FUNC( GETITEMCOUNT )
{
    hb_retni( SendMessage( HWNDparam( 1 ), SB_GETPARTS, 0, 0 ) );
}

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
      piItems = hb_xgrab( sizeof( int ) * iItems );
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

HB_FUNC( REFRESHITEMBAR )   // ( hWnd, aWidths )
{
   HWND  hWnd;
   int   *piItems;
   int   iItems, iWidth, iCount;
   RECT  rect;

   hWnd = HWNDparam( 1 );
   iItems = SendMessage( hWnd, SB_GETPARTS, 0, 0 );
   if( iItems != 0 )
   {
      GetWindowRect( hWnd, &rect );
      iWidth = rect.right - rect.left;
      if( iWidth == 0 )    // HACK to force show :(
      {
         GetWindowRect( GetParent( hWnd ), &rect );
         iWidth = rect.right - rect.left;
      }

      piItems = hb_xgrab( sizeof( int ) * iItems );
      for( iCount = iItems; iCount >= 1; iCount-- )
      {
         piItems[ iCount - 1 ] = iWidth;
         iWidth -= hb_parni( 2, iCount );
      }
      SendMessage( hWnd, SB_SETPARTS, iItems, ( LPARAM ) piItems );
      MoveWindow( hWnd, 0, 0, 0, 0, TRUE );
      hb_xfree( piItems );
   }
   hb_retni( iItems );
}

HB_FUNC ( KEYTOGGLE )
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

HB_FUNC_EXTERN( SETSTATUSITEMICON )
{

	HWND  hwnd;
	RECT  rect;
	HICON hIcon ;
	int   cx;
	int   cy;

    hwnd = HWNDparam( 1 );

	// Unloads from memory current icon

	DestroyIcon ( (HICON) SendMessage(hwnd,SB_GETICON,(WPARAM) hb_parni(2)-1, (LPARAM) 0 ) ) ;

	//

	GetClientRect(hwnd, &rect);

	cy = rect.bottom - rect.top-4;
	cx = cy;

	hIcon = (HICON)LoadImage(GetModuleHandle(NULL),hb_parc(3),IMAGE_ICON ,cx,cy, 0 );

	if (hIcon==NULL)
	{
		hIcon = (HICON)LoadImage(0, hb_parc(3),IMAGE_ICON ,cx,cy, LR_LOADFROMFILE );
	}

	SendMessage(hwnd,SB_SETICON,(WPARAM) hb_parni(2)-1, (LPARAM)hIcon );

}
#pragma ENDDUMP
