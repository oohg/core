/*
 * $Id: h_tab.prg,v 1.22 2006-07-19 03:46:04 guerra000 Exp $
 */
/*
 * ooHG source code:
 * Tab functions
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

CLASS TTab FROM TControl
   DATA Type       INIT "TAB" READONLY
   DATA aPages     INIT {}
   DATA lInternals INIT .F.
//            himl = ImageList_Create( cx , cy , ILC_COLOR8 | ILC_MASK , l + 1 , l + 1 );
//            ImageList_AddMasked( himl, hbmp, CLR_DEFAULT ) ;
   DATA ImageListColor      INIT CLR_DEFAULT
   DATA ImageListFlags      INIT LR_LOADTRANSPARENT + LR_DEFAULTCOLOR + LR_LOADMAP3DCOLORS
   DATA SetImageListCommand INIT TCM_SETIMAGELIST
   DATA SetImageListWParam  INIT 0

   METHOD Define

   METHOD Refresh
   METHOD Release
   METHOD SizePos
   METHOD Value               SETGET
   METHOD Enabled             SETGET
   METHOD Visible             SETGET
   METHOD ForceHide

   METHOD Events_Notify

   METHOD AddPage
   METHOD AddControl
   METHOD DeleteControl
   METHOD DeletePage
   METHOD Caption
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, aCaptions, aPageMap, ;
               value, fontname, fontsize, tooltip, change, Buttons, Flat, ;
               HotTrack, Vertical, notabstop, aMnemonic, bold, italic, ;
               underline, strikeout, Images, lRtl, lInternals ) CLASS TTab
*-----------------------------------------------------------------------------*
Local z
Local Caption, Page, Image, Mnemonic
Local ControlHandle

   ASSIGN ::lInternals VALUE lInternals TYPE "L"

   ::SetForm( ControlName, ParentForm, FontName, FontSize,,,, lRtl )

   // Since we still can't set a TAB's backcolor, we assume it (and
   // internal controls) as system-default backcolor  :(
   ::BackColor := -1

   IF VALTYPE( aCaptions ) != "A"
      aCaptions := {}
   ENDIF
   IF VALTYPE( aPageMap ) != "A"
      aPageMap := {}
   ENDIF
   IF VALTYPE( Images ) != "A"
      Images := {}
   ENDIF

   ASSIGN ::nWidth  VALUE w TYPE "N"
   ASSIGN ::nHeight VALUE h TYPE "N"
   ASSIGN ::nRow    VALUE y TYPE "N"
   ASSIGN ::nCol    VALUE x TYPE "N"

   ControlHandle = InitTabControl( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, {}, value, '', 0 , Buttons , Flat , HotTrack , Vertical , notabstop , ::lRtl )
   IF ! ::lInternals
      SetWindowPos( ControlHandle, 0, 0, 0, 0, 0, 3 )
   ENDIF

   ::Register( ControlHandle, ControlName, , , ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   // Add page by page
   z := 1
   DO WHILE z <= LEN( aCaptions ) .AND. z <= LEN( aPageMap ) .AND. z <= LEN( Images )
      IF z <= LEN( Images ) .AND. VALTYPE( Images[ z ] ) $ "CM"
         Image := Images[ z ]
      ELSE
         Image := ""
      ENDIF
      IF z <= LEN( aCaptions ) .AND. VALTYPE( aCaptions[ z ] ) $ "CM"
         Caption := aCaptions[ z ]
      ELSE
         Caption := ""
      ENDIF
      IF z <= LEN( aPageMap ) .AND. VALTYPE( aPageMap[ z ] ) == "A"
         Page := aPageMap[ z ]
      ELSE
         Page := {}
      ENDIF
      IF z <= LEN( aMnemonic ) .AND. VALTYPE( aMnemonic[ z ] ) == "B"
         Mnemonic := aMnemonic[ z ]
      ELSE
         Mnemonic := nil
      ENDIF
      ::AddPage( z, Caption , Image, Page, Mnemonic )
      z++
   ENDDO

   ::OnChange   :=  Change

   IF VALTYPE( value ) == "N"
      ::Value := value
   ELSE
      ::Value := 1
   ENDIF

   _OOHG_AddFrame( Self )

Return Self

*-----------------------------------------------------------------------------*
METHOD Refresh() CLASS TTab
*-----------------------------------------------------------------------------*
Local nPage
   nPage := IF( ::Visible, ::Value, 0 )
   // AEVAL( ::aPages, { |p,i| p:Position := i } )
   // AEVAL( ::aPages, { |p,i| if( i == nPage, p:Show(), p:ForceHide() ) } )
   AEVAL( ::aPages, { |p,i| p:Position := i , if( i == nPage, p:Show(), p:ForceHide() ) } )
Return Nil

*-----------------------------------------------------------------------------*
METHOD Release() CLASS TTab
*-----------------------------------------------------------------------------*
   AEVAL( ::aPages, { |o| o:Release() } )
Return ::Super:Release()

*-----------------------------------------------------------------------------*
METHOD SizePos( Row, Col, Width, Height ) CLASS TTab
*-----------------------------------------------------------------------------*
   ::Super:SizePos( Row, Col, Width, Height )
   AEVAL( ::aPages, { |o| o:Events_Size() } )
Return Nil

*-----------------------------------------------------------------------------*
METHOD Value( nValue ) CLASS TTab
*-----------------------------------------------------------------------------*
   IF VALTYPE( nValue ) == "N"
      TABCTRL_SETCURSEL( ::hWnd, nValue )
      ::Refresh()
   ENDIF
RETURN TABCTRL_GETCURSEL( ::hWnd )

*-----------------------------------------------------------------------------*
METHOD Enabled( lEnabled ) CLASS TTab
*-----------------------------------------------------------------------------*
LOCAL nPos
   IF VALTYPE( lEnabled ) == "L"
      ::Super:Enabled := lEnabled
      nPos := TabCtrl_GetCurSel( ::hWnd )
      IF nPos <= LEN( ::aPages ) .AND. nPos >= 1
         ::aPages[ nPos ]:Enabled := ::aPages[ nPos ]:Enabled
      ENDIF
   ENDIF
RETURN ::Super:Enabled

*-----------------------------------------------------------------------------*
METHOD Visible( lVisible ) CLASS TTab
*-----------------------------------------------------------------------------*
LOCAL nPos, aPages
   IF VALTYPE( lVisible ) == "L"
      ::Super:Visible := lVisible
      nPos := TabCtrl_GetCurSel( ::hWnd )
      aPages := ::aPages
      IF nPos <= LEN( aPages ) .AND. nPos >= 1
         IF lVisible .AND. aPages[ nPos ]:Visible
            aPages[ nPos ]:Visible := .T.
         ELSE
            aPages[ nPos ]:ForceHide()
         ENDIF
      ENDIF
   ENDIF
RETURN ::lVisible

*-----------------------------------------------------------------------------*
METHOD ForceHide() CLASS TTab
*-----------------------------------------------------------------------------*
LOCAL nPos
   nPos := TabCtrl_GetCurSel( ::hWnd )
   IF nPos <= LEN( ::aPages ) .AND. nPos >= 1
      ::aPages[ nPos ]:ForceHide()
   ENDIF
RETURN ::Super:ForceHide()

*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TTab
*-----------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam )

   If nNotify == TCN_SELCHANGE
      ::Refresh()
      ::DoEvent( ::OnChange )
      Return nil

   EndIf

Return ::Super:Events_Notify( wParam, lParam )

*-----------------------------------------------------------------------------*
METHOD AddPage( Position, Caption, Image, aControls, Mnemonic, Name, oSubClass ) CLASS TTab
*-----------------------------------------------------------------------------*
Local oPage, nPos, nKey

   IF VALTYPE( Position ) != "N" .OR. Position < 1 .OR. Position > LEN( ::aPages )
      Position := LEN( ::aPages ) + 1
   ENDIF

   If ! ValType( Image ) $ 'CM'
		Image := ''
	EndIf

   If ! ValType( Caption ) $ 'CM'
		Caption := ''
   Else
      IF ! EMPTY( Image ) .AND. IsXPThemeActive() .AND. At( '&' , Caption ) != 0
         Caption := Space( 3 ) + Caption
      ENDIF
	EndIf

   TABCTRL_INSERTITEM( ::hWnd, Position - 1 , Caption )

   If ValType( oSubClass ) == "O"
      oPage := oSubClass
   ElseIf ::lInternals
      oPage := TTabPageInternal()
   Else
      oPage := TTabPage()
   EndIf
   oPage:Define( Name, Self, Position )

   oPage:Caption   := Caption
   oPage:Picture   := Image

   AADD( ::aPages, nil )
   AINS( ::aPages, Position )
   ::aPages[ Position ] := oPage

   IF ! Empty( Image )
      SetTabPageImage( ::hWnd, ::AddBitMap( Image ) - 1 )
   ENDIF

   If ValType( aControls ) == "A"
      AEVAL( aControls, { |o| ::AddControl( o, Position ) } )
   EndIf

   nPos := At( '&', Caption )

   IF nPos > 0 .AND. nPos < LEN( Caption )
      nPos := AT( Upper( SubStr( Caption, nPos + 1, 1 ) ), "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" )
      IF nPos > 0
         nKey := { VK_A, VK_B, VK_C, VK_D, VK_E, VK_F, VK_G, VK_H, ;
                   VK_I, VK_J, VK_K, VK_L, VK_M, VK_N, VK_O, VK_P, ;
                   VK_Q, VK_R, VK_S, VK_T, VK_U, VK_V, VK_W, VK_X, ;
                   VK_Y, VK_Z, VK_0, VK_1, VK_2, VK_3, VK_4, VK_5, ;
                   VK_6, VK_7, VK_8, VK_9 }[ nPos ]
         IF VALTYPE( Mnemonic ) != "B"
*            Mnemonic := {|| ( ::Value := Position , iif ( valtype( ::OnChange ) =='B' , Eval( ::OnChange ) , Nil ) ) }
            Mnemonic := {|| ( oPage:SetFocus() , iif ( valtype( ::OnChange ) =='B' , Eval( ::OnChange ) , Nil ) ) }
         ENDIF
         ::Parent:HotKey( nKey, MOD_ALT, Mnemonic )
      ENDIF
   ENDIF

   ::Refresh()

Return oPage

*------------------------------------------------------------------------------*
Function _BeginTabPage( caption, image, Position, Name, oSubClass )
*------------------------------------------------------------------------------*
local oCtrl, oPage
   IF _OOHG_LastFrame() == "TABPAGE"
      // ERROR: Last page not finished
      _EndTabPage()
   ENDIF
   IF _OOHG_LastFrame() == "TAB"
      oCtrl := ATAIL( _OOHG_ActiveFrame )
      oPage := oCtrl:AddPage( Position, Caption, Image,,, Name, oSubClass )
   Else
      // ERROR: No TAB started
      oPage := NIL
   EndIf
Return oPage

*------------------------------------------------------------------------------*
Function _EndTabPage()
*------------------------------------------------------------------------------*
   _OOHG_DeleteFrame( "TABPAGE" )
RETURN nil

*------------------------------------------------------------------------------*
Function _EndTab()
*------------------------------------------------------------------------------*
   IF _OOHG_LastFrame() == "TABPAGE"
      // ERROR: Last page not finished
      _EndTabPage()
   ENDIF
   _OOHG_DeleteFrame( "TAB" )
Return Nil

*-----------------------------------------------------------------------------*
METHOD AddControl( oCtrl , PageNumber , Row , Col ) CLASS TTab
*-----------------------------------------------------------------------------*

   If ValType( oCtrl ) $ "CM"
      oCtrl := ::Parent:Control( oCtrl )
   EndIf

   IF valtype( PageNumber ) != "N" .OR. PageNumber > LEN( ::aPages )
      PageNumber := LEN( ::aPages )
   ENDIF

   IF PageNumber < 1
      PageNumber := 1
   ENDIF

   IF valtype( Row ) != "N"
      Row := oCtrl:ContainerRow - ::ContainerRow
   ENDIF

   IF valtype( Col ) != "N"
      Col := oCtrl:ContainerCol - ::ContainerCol
   ENDIF

   ::aPages[ PageNumber ]:AddControl( oCtrl, Row, Col )

Return Nil

*-----------------------------------------------------------------------------*
METHOD DeletePage( Position ) CLASS TTab
*-----------------------------------------------------------------------------*
Local NewValue

   IF VALTYPE( Position ) != "N" .OR. Position < 1 .OR. Position > LEN( ::aPages )
      Position := LEN( ::aPages )
   ENDIF

   // Control Map

   ::aPages[ Position ]:Release()

   _OOHG_DeleteArrayItem( ::aPages, Position )

   TabCtrl_DeleteItem( ::hWnd, Position - 1 )

   NewValue := Position - 1

   If NewValue == 0
      NewValue := 1
   EndIf

   TABCTRL_SETCURSEL( ::hWnd, NewValue )

   ::Refresh()

Return Nil

*-----------------------------------------------------------------------------*
METHOD Caption( nColumn, uValue ) CLASS TTab
*-----------------------------------------------------------------------------*
   IF VALTYPE( uValue ) $ "CM"
      ::aPages[ nColumn ]:Caption := uValue
      SETTABCAPTION( ::hWnd, nColumn, uValue )
   ENDIF
Return ::aPages[ nColumn ]:Caption

*-----------------------------------------------------------------------------*
METHOD DeleteControl( oCtrl ) CLASS TTab
*-----------------------------------------------------------------------------*
Return AEVAL( ::aPages, { |o| o:DeleteControl( oCtrl ) } )






CLASS TTabPage FROM TControl
   DATA Type      INIT "TABPAGE" READONLY
   DATA Picture   INIT ""
   DATA Position  INIT 0
   DATA nImage    INIT -1

   METHOD Define
   METHOD Enabled
   METHOD Visible             SETGET

   METHOD ContainerVisible

   METHOD AddControl
   METHOD SetFocus            BLOCK { |Self| ::Container:SetFocus() , ::Container:Value := ::Position , Self }
   METHOD ForceHide           BLOCK { |Self| AEVAL( ::aControls, { |o| o:ForceHide() } ) }
   METHOD Events_Size         BLOCK { |Self| AEVAL( ::aControls, { |o| o:SizePos() } ) }
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, Position ) CLASS TTabPage
*-----------------------------------------------------------------------------*
   Empty( Position )
   ::SetForm( ControlName, ParentForm )
   _OOHG_AddFrame( Self )
Return Self

*-----------------------------------------------------------------------------*
METHOD Enabled( lEnabled ) CLASS TTabPage
*-----------------------------------------------------------------------------*
   IF VALTYPE( lEnabled ) == "L"
      ::Super:Enabled := lEnabled
      AEVAL( ::aControls, { |o| o:Enabled := o:Enabled } )
   ENDIF
RETURN ::Super:Enabled

*-----------------------------------------------------------------------------*
METHOD Visible( lVisible ) CLASS TTabPage
*-----------------------------------------------------------------------------*
   IF VALTYPE( lVisible ) == "L"
      ::Super:Visible := lVisible
      AEVAL( ::aControls, { |o| o:Visible := o:Visible } )
   ENDIF
RETURN ::lVisible

*-----------------------------------------------------------------------------*
METHOD ContainerVisible() CLASS TTabPage
*-----------------------------------------------------------------------------*
Local lRet := .F.
   IF ::Super:ContainerVisible
      lRet := ( TabCtrl_GetCurSel( ::Container:hWnd ) == ::Position )
   ENDIF
RETURN lRet

*-----------------------------------------------------------------------------*
METHOD AddControl( oCtrl , Row , Col ) CLASS TTabPage
*-----------------------------------------------------------------------------*

   oCtrl:Visible := oCtrl:Visible

   ::Super:AddControl( oCtrl )

   oCtrl:Container := Self

   oCtrl:SizePos( Row, Col )

   oCtrl:Visible := oCtrl:Visible

Return Nil





CLASS TTabPageInternal FROM TFormInternal
   DATA Type       INIT "TABPAGE" READONLY
   DATA Picture    INIT ""
   DATA Position   INIT 0
   DATA nImage     INIT -1
   DATA nRowMargin INIT 0
   DATA nColMargin INIT 0

   METHOD Define
   METHOD Events_Size

/*
   METHOD ContainerVisible
*/

   METHOD RowMargin           SETGET
   METHOD ColMargin           SETGET

   METHOD SetFocus            BLOCK { |Self| ::Container:SetFocus() , ::Container:Value := ::Position , ::Super:SetFocus() }
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, Position ) CLASS TTabPageInternal
*-----------------------------------------------------------------------------*
Local aArea

   ::SearchParent( ParentForm )
   ASSIGN Position VALUE Position TYPE "N" DEFAULT LEN( ::Container:aPages ) + 1
   aArea := _OOHG_TabPage_GetArea( ::Container, Position )
   ::Super:Define( ControlName,, aArea[ 1 ], aArea[ 2 ], aArea[ 3 ], aArea[ 4 ], ParentForm )
   END WINDOW
   ::ContainerhWndValue := ::hWnd
   _OOHG_AddFrame( Self )

   ::RowMargin := - aArea[ 2 ]
   ::ColMargin := - aArea[ 1 ]
Return Self

*-----------------------------------------------------------------------------*
METHOD Events_Size() CLASS TTabPageInternal
*-----------------------------------------------------------------------------*
Local aArea
   aArea := _OOHG_TabPage_GetArea( ::Container, ::Position )
   ::SizePos( aArea[ 2 ], aArea[ 1 ], aArea[ 3 ], aArea[ 4 ] )
Return NIL

/*
*-----------------------------------------------------------------------------*
METHOD ContainerVisible() CLASS TTabPageInternal
*-----------------------------------------------------------------------------*
Local lRet := .F.
   IF IsWindowVisible( ::hWnd ) // ::Super:ContainerVisible
      lRet := ( TabCtrl_GetCurSel( ::Container:hWnd ) == ::Position )
   ENDIF
RETURN lRet
*/

STATIC FUNCTION _OOHG_TabPage_GetArea( oTab, nPosition )
LOCAL aRect
   aRect := TabCtrl_GetItemRect( oTab:hWnd, nPosition - 1 )
   aRect := { 2, aRect[ 4 ] + 2, oTab:Width - 2, oTab:Height - 2 }
RETURN { aRect[ 1 ], aRect[ 2 ], aRect[ 3 ] - aRect[ 1 ], aRect[ 4 ] - aRect[ 2 ] } // { Col, Row, Width, Height }

*-----------------------------------------------------------------------------*
METHOD RowMargin( nRow ) CLASS TTabPageInternal
*-----------------------------------------------------------------------------*
   ASSIGN ::nRowMargin VALUE nRow Type "N"
RETURN - ::ContainerRow + ::nRowMargin

*-----------------------------------------------------------------------------*
METHOD ColMargin( nCol ) CLASS TTabPageInternal
*-----------------------------------------------------------------------------*
   ASSIGN ::nColMargin VALUE nCol Type "N"
RETURN - ::ContainerCol + ::nColMargin





EXTERN InitTabControl, SetTabCaption, SetTabPageImage
EXTERN TabCtrl_SetCurSel, TabCtrl_GetCurSel, TabCtrl_InsertItem, TabCtrl_DeleteItem, TabCtrl_GetItemRect

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
#include "../include/oohg.h"

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

HB_FUNC( INITTABCONTROL )
{
	PHB_ITEM hArray;
	HWND hwnd;
	HWND hbutton;
	TC_ITEM tie;
	int i;

	int Style = WS_CHILD | WS_VISIBLE ;
   int iStyleEx = _OOHG_RTL_Status( hb_parl( 16 ) );

   if( hb_parl (11) )
	{
		Style = Style | TCS_BUTTONS ;
	}

   if( hb_parl (12) )
	{
		Style = Style | TCS_FLATBUTTONS ;
	}

   if( hb_parl (13) )
	{
		Style = Style | TCS_HOTTRACK ;
	}

   if( hb_parl (14) )
	{
		Style = Style | TCS_VERTICAL ;
	}

   if( ! hb_parl (15) )
	{
		Style = Style | WS_TABSTOP ;
	}

	hArray = hb_param( 7, HB_IT_ARRAY );

   hwnd = HWNDparam( 1 );

   hbutton = CreateWindowEx( iStyleEx, WC_TABCONTROL , NULL ,
	Style ,
	hb_parni(3), hb_parni(4) , hb_parni(5), hb_parni(6) ,
	hwnd,(HMENU)hb_parni(2) , GetModuleHandle(NULL) , NULL ) ;

	tie.mask = TCIF_TEXT ;
	tie.iImage = -1;

   for( i = hb_parinfa( 7, 0 ); i > 0; i-- )
   {
      tie.pszText = hb_arrayGetCPtr( hArray, i );
      TabCtrl_InsertItem( hbutton, 0, &tie );
   }

   TabCtrl_SetCurSel( hbutton, hb_parni( 8 ) - 1 );

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( ( HWND ) hbutton, GWL_WNDPROC, ( LONG ) SubClassFunc );

   HWNDret( hbutton );
}

HB_FUNC (TABCTRL_SETCURSEL)
{

	HWND hwnd;
	int s;

   hwnd = HWNDparam( 1 );

	s = hb_parni (2);

	TabCtrl_SetCurSel( hwnd , s-1 );

}

HB_FUNC (TABCTRL_GETCURSEL)
{
	HWND hwnd;
   hwnd = HWNDparam( 1 );
	hb_retni ( TabCtrl_GetCurSel( hwnd ) + 1 ) ;
}

HB_FUNC (TABCTRL_INSERTITEM)
{
   TC_ITEM tie;
   int i;

   i = hb_parni( 2 );

   tie.mask = TCIF_TEXT;
   tie.iImage = -1;
   tie.pszText = hb_parc( 3 );

   TabCtrl_InsertItem( HWNDparam( 1 ), i, &tie );
}

HB_FUNC( TABCTRL_DELETEITEM )
{
   TabCtrl_DeleteItem( HWNDparam( 1 ), hb_parni( 2 ) );
}

HB_FUNC( SETTABCAPTION )
{

	TC_ITEM tie;

	tie.mask = TCIF_TEXT ;

	tie.pszText = hb_parc(3) ;

   TabCtrl_SetItem( HWNDparam( 1 ), hb_parni( 2 ) - 1, &tie );
}

HB_FUNC( SETTABPAGEIMAGE )
{
   TC_ITEM tie;

//            himl = ImageList_Create( cx , cy , ILC_COLOR8 | ILC_MASK , l + 1 , l + 1 );
//            ImageList_AddMasked( himl, hbmp, CLR_DEFAULT ) ;
   tie.mask = TCIF_IMAGE ;
   tie.iImage = hb_parni( 2 );
   TabCtrl_SetItem( HWNDparam( 1 ), hb_parni( 2 ), &tie );
}

HB_FUNC( TABCTRL_GETITEMRECT )
{
   RECT rect;

   TabCtrl_GetItemRect( HWNDparam( 1 ), hb_parni( 2 ), &rect );
   hb_reta( 4 );
   hb_storni( rect.left,   -1, 1 );
   hb_storni( rect.top,    -1, 2 );
   hb_storni( rect.right,  -1, 3 );
   hb_storni( rect.bottom, -1, 4 );
}
#pragma ENDDUMP
