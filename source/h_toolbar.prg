/*
 * $Id: h_toolbar.prg $
 */
/*
 * ooHG source code:
 * ToolBar and ToolButton controls
 *
 * Copyright 2005-2018 Vicente Guerra <vicente@guerra.com.mx>
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

STATIC _OOHG_ActiveToolBar := Nil    // Active toolbar

#pragma BEGINDUMP

#ifndef HB_OS_WIN_32_USED
   #define HB_OS_WIN_32_USED
#endif

#ifndef _WIN32_IE
   #define _WIN32_IE 0x0500
#endif
#if ( _WIN32_IE < 0x0500 )
   #undef _WIN32_IE
   #define _WIN32_IE 0x0500
#endif

#ifndef _WIN32_WINNT
   #define _WIN32_WINNT 0x0400
#endif
#if ( _WIN32_WINNT < 0x0400 )
   #undef _WIN32_WINNT
   #define _WIN32_WINNT 0x0400
#endif

#include <shlobj.h>
#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "winreg.h"
#include "tchar.h"
#include <stdlib.h>
#include "oohg.h"

#pragma ENDDUMP


CLASS TToolBar FROM TControl

   DATA Type                      INIT "TOOLBAR" READONLY
   DATA lAdjust                   INIT .T.
   DATA lfixfont                  INIT .T.
   DATA lTop                      INIT .T.
   DATA nButtonHeight             INIT 0
   DATA nButtonWidth              INIT 0
   DATA lVertical                 INIT .F.

   METHOD Define
   METHOD Events_Size
   METHOD Events_Notify
   METHOD Events
   METHOD Events_Command
   METHOD LookForKey
   METHOD ClientHeightUsed        BLOCK { |Self| GetWindowHeight( ::hWnd ) }
   METHOD Height                  SETGET
   METHOD Width                   SETGET
   METHOD AddButton
   METHOD DeleteButton

   ENDCLASS

METHOD Define( ControlName, ParentForm, x, y, w, h, caption, ProcedureName, ;
               fontname, fontsize, tooltip, flat, bottom, righttext, break, ;
               bold, italic, underline, strikeout, border, lRtl, lNoTabStop, ;
               lVertical, lOwnToolTip ) CLASS TToolBar

   Local ControlHandle, id, lSplitActive, nStyle, oCtrl

   If ValType( caption ) == 'U'
      caption := ""
   EndIf

   ASSIGN ::nCol          VALUE x         TYPE "N"
   ASSIGN ::nRow          VALUE y         TYPE "N"
   ASSIGN ::nButtonWidth  VALUE w         TYPE "N"
   ASSIGN ::nButtonHeight VALUE h         TYPE "N"
   ASSIGN flat            VALUE flat      TYPE "L" DEFAULT .F.
   ASSIGN ::lTop          VALUE ! bottom  TYPE "L"
   ASSIGN righttext       VALUE righttext TYPE "L" DEFAULT .F.
   ASSIGN border          VALUE border    TYPE "L" DEFAULT .F.
   ASSIGN ::lVertical     VALUE lVertical TYPE "L"

   If ! ::lTop .AND. ::lVertical
      MsgOOHGError( "BOTTOM and VERTICAL clauses can't be used simultaneously. Program terminated." )
   EndIf

   ::SetForm( ControlName, ParentForm, fontName, fontSize, Nil, Nil, Nil, lRtl )

   _OOHG_ActiveToolBar := Self

   Id := _GetId()

   lSplitActive := ::SetSplitBoxInfo( Break, caption, ::nButtonWidth, Nil, .T. )
   nStyle := ::InitStyle( Nil, Nil, Nil, lNoTabStop, Nil )
   ControlHandle := InitToolBar( ::ContainerhWnd, Caption, id, ::ContainerCol, ::ContainerRow, ::nButtonWidth, ::nButtonHeight, "", 0, flat, ! ::lTop, righttext, lSplitActive, border, ::lRtl, nStyle, ::lVertical )

   ::Register( ControlHandle, ControlName, Nil, Nil, Nil, Id )

   ::SetFont( Nil, Nil, bold, italic, underline, strikeout )

   ::ContainerhWndValue := ::hWnd

   ASSIGN lOwnToolTip VALUE lOwnToolTip TYPE "L" DEFAULT .F.
   If ! lOwnToolTip .AND. ! HB_IsObject( :: Parent:oToolTip )
      lOwnToolTip := .T.
   EndIf
   If lOwnToolTip
      oCtrl := TToolTip():Define( Nil, Self )
      If HB_IsObject( ::Parent:oToolTip )
         With Object ::Parent:oToolTip
            oCtrl:AutoPopTime := :AutoPopTime
            oCtrl:InitialTime := :InitialTime
            oCtrl:ReshowTime  := :ReshowTime
            oCtrl:WindowWidth := :WindowWidth
            oCtrl:Title       := :Title
            oCtrl:Icon        := :Icon
            oCtrl:WindowWidth := :WindowWidth
            oCtrl:MultiLine   := :MultiLine
         End With
      EndIf
      ::oToolTip := oCtrl
   Else
      // Use parent's tooltip
      oCtrl :=  ::oToolTip
   EndIf
   SendMessage( ::hWnd, TB_SETTOOLTIPS, oCtrl:hWnd , 0 )
   ::Tooltip := tooltip

   ASSIGN ::OnClick VALUE ProcedureName TYPE "B"

   Return Self

FUNCTION _EndToolBar( lBreak )

   Local w, MinWidth, MinHeight
   Local Self

   Self := _OOHG_ActiveToolBar

   MaxTextBtnToolBar( ::hWnd, ::nButtonWidth, ::nButtonHeight )

   If ::SetSplitBoxInfo()
      w := GetSizeToolBar( ::hWnd )
      MinWidth  := HiWord( w )
      MinHeight := LoWord( w )

      w := GetWindowWidth( ::hWnd )

      SetSplitBoxItem( ::hWnd, ::Container:hWnd, w, Nil, Nil, MinWidth, MinHeight, ::Container:lInverted )

      ASSIGN lBreak VALUE lBreak TYPE "L" DEFAULT .T.

      ::SetSplitBoxInfo( lBreak )  // .T. forces break for next control...
   EndIf

   _OOHG_ActiveToolBar := Nil

   Return Nil

METHOD Height( nHeight ) CLASS TToolBar

   If HB_IsNumeric( nHeight )
      ::SizePos( Nil, Nil, Nil, nHeight )
   EndIf

   Return GetWindowHeight( ::hWnd )

METHOD Width( nWidth ) CLASS TToolBar

   If HB_IsNumeric( nWidth )
      ::SizePos( Nil, Nil, nWidth )
   EndIf

   Return GetWindowWidth( ::hWnd )

METHOD Events_Size() CLASS TToolBar

   SendMessage( ::hWnd, TB_AUTOSIZE, 0, 0 )

   Return ::Super:Events_Size()

METHOD Events_Notify( wParam, lParam ) CLASS TToolBar

   Local nNotify := GetNotifyCode( lParam )
   Local ws, x, aPos, cToolTip

   If nNotify == TBN_DROPDOWN
      ws := GetButtonPos( lParam )
      x  := aScan( ::aControls, { |o| o:Id == ws } )
      If x > 0
         aPos:= { 0, 0, 0, 0 }
         GetWindowRect( ::hWnd, aPos )
         ws := GetButtonBarRect( ::hWnd, ::aControls[ x ]:Position - 1 )
         ::aControls[ x ]:ContextMenu:Activate( aPos[2]+HiWord(ws)+(aPos[4]-aPos[2]-HiWord(ws))/2, aPos[1]+LoWord(ws) )
      EndIf
      Return Nil

   ElseIf nNotify == TTN_NEEDTEXT
      ws := GetButtonPos( lParam )
      x  := aScan( ::aControls, { |o| o:Id == ws } )
      If x > 0
         cToolTip := ::aControls[ x ]:ToolTip
         If HB_IsBlock( cToolTip )
            ::aControls[ x ]:DoEvent( { || cToolTip := EVAL( cToolTip, ::aControls[ x ] ) }, "TOOLTIP" )
         EndIf
         If HB_IsString( cToolTip )
            ShowToolButtonTip( lParam, cToolTip )
         EndIf
      EndIf
      Return Nil

   /*
   If nNotify == TBN_ENDDRAG  // -702
      ws := GetButtonPos( lParam )
      x  := aScan( ::aControls, { |o| o:Id == ws } )
      If x > 0
         aPos:= {0,0,0,0}
         GetWindowRect( ::hWnd, aPos )
         ws := GetButtonBarRect( ::hWnd, ::aControls[ x ]:Position - 1 )
         // TrackPopupMenu ( ::aControls[ x ]:ContextMenu:hWnd, aPos[1]+LoWord(ws),aPos[2]+HiWord(ws)+(aPos[4]-aPos[2]-HiWord(ws))/2, ::hWnd )
         ::aControls[ x ]:ContextMenu:Activate( aPos[2]+HiWord(ws)+(aPos[4]-aPos[2]-HiWord(ws))/2, aPos[1]+LoWord(ws) )
      EndIf
      Return Nil
   */

   ElseIf nNotify == TBN_GETINFOTIP
      ws := _ToolBarGetInfoTip( lParam )
      x  := aScan ( ::aControls, { |o| o:Id == ws } )
      If x > 0
         cToolTip := ::aControls[ x ]:ToolTip
         If HB_IsBlock( cToolTip )
            ::aControls[ x ]:DoEvent( { || cToolTip := EVAL( cToolTip, ::aControls[ x ] ) }, "TOOLTIP" )
         EndIf
         If HB_IsString( cToolTip )
            _ToolBarSetInfoTip( lParam, cToolTip )
         EndIf
      EndIf

   EndIf

   Return ::Super:Events_Notify( wParam, lParam )

METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TToolBar

   If nMsg == WM_COMMAND .AND. LOWORD( wParam ) != 0
      // Prevents a double menu click
      Return Nil
   EndIf

   Return ::Super:Events( hWnd, nMsg, wParam, lParam )

METHOD Events_Command( wParam ) CLASS TToolBar

   Local Hi_wParam := HIWORD( wParam )
   Local oControl

   If Hi_wParam == BN_CLICKED
      oControl := GetControlObjectById( LOWORD( wParam ), ::Parent:hWnd )
      If ! oControl:NestedClick
         oControl:NestedClick := ! _OOHG_NestedSameEvent()
         oControl:DoEventMouseCoords( oControl:OnClick, "CLICK" )
         oControl:NestedClick := .F.
      EndIf
      Return 1
   EndIf

   Return ::Super:Events_Command( wParam )

METHOD LookForKey( nKey, nFlags ) CLASS TToolBar

   Local ButtonIndex, i, oControl

   If nKey == VK_RETURN .AND. nFlags == 0
      ::Events_Enter()
      If GetFocus() == ::hWnd
         ButtonIndex := SendMessage( ::hWnd, TB_GETHOTITEM, 0, 0 )
         If ButtonIndex >= 0
            i := aScan( ::aControls, { |o| o:Type == "TOOLBUTTON" .AND. o:Position == ButtonIndex + 1 } )
            If i > 0
               oControl := ::aControls[ i ]
               If ! oControl:NestedClick
                  oControl:NestedClick := ! _OOHG_NestedSameEvent()
                  oControl:DoEvent( oControl:OnClick, "CLICK" )
                  oControl:NestedClick := .F.
               EndIf
            EndIf
         EndIf
      EndIf
      Return .T.
   EndIf

   Return ::Super:LookForKey( nKey, nFlags )

METHOD AddButton( ControlName, x, y, Caption, ProcedureName, w, h, image, ;
                  tooltip, gotfocus, lostfocus, flat, separator, autosize, ;
                  check, group, dropdown, WholeDropdown ) CLASS TToolBar

   Return TToolButton():Define( ControlName, x, y, Caption, ProcedureName, w, h, image, ;
                             tooltip, gotfocus, lostfocus, flat, separator, autosize, ;
                             check, group, dropdown, WholeDropdown, Self )

METHOD DeleteButton( nButtonIndex ) CLASS TToolBar

   Local i, oControl, lRet := .F.

   If nButtonIndex > 0 .AND. nButtonIndex <= GetButtonBarCount( ::hWnd )
      i := aScan( ::aControls, { |o| o:Type == "TOOLBUTTON" .AND. o:Position == nButtonIndex } )
      If i > 0
         oControl := ::aControls[ i ]
         oControl:Release()
         lRet := .T.
      EndIf
   EndIf

   Return lRet


CLASS TToolButton FROM TControl

   DATA Type      INIT "TOOLBUTTON" READONLY
   DATA Position  INIT 0
   DATA hImage    INIT 0
   DATA cPicture  INIT ""
   DATA oHotKey   INIT Nil

   DATA lAdjust   INIT .F.

   METHOD Define
   METHOD Value         SETGET
   METHOD Enabled       SETGET
   METHOD Picture       SETGET
   METHOD HBitMap       SETGET
   METHOD Buffer        SETGET
   METHOD Release
   METHOD Caption       SETGET
   METHOD RePaint
   METHOD Events_Notify

   ENDCLASS

METHOD Define( ControlName, x, y, Caption, ProcedureName, w, h, image, ;
               tooltip, gotfocus, lostfocus, flat, separator, autosize, ;
               check, group, dropdown, WholeDropdown, toolbar ) CLASS TToolButton

   Local id, nPos

   ASSIGN ::nCol    VALUE x TYPE "N"
   ASSIGN ::nRow    VALUE y TYPE "N"
   ASSIGN ::nWidth  VALUE w TYPE "N"
   ASSIGN ::nHeight VALUE h TYPE "N"

   Empty( flat )

   ASSIGN toolbar   VALUE toolbar TYPE "O" DEFAULT _OOHG_ActiveToolBar
   ::SetForm( ControlName, toolbar )

   ASSIGN Caption       VALUE Caption       TYPE "CM" DEFAULT ""
   ASSIGN separator     VALUE separator     TYPE "L"  DEFAULT .F.
   ASSIGN autosize      VALUE autosize      TYPE "L"  DEFAULT .F.
   ASSIGN check         VALUE check         TYPE "L"  DEFAULT .F.
   ASSIGN group         VALUE group         TYPE "L"  DEFAULT .F.
   ASSIGN dropdown      VALUE dropdown      TYPE "L"  DEFAULT .F.
   ASSIGN WholeDropdown VALUE WholeDropdown TYPE "L"  DEFAULT .F.

   If ValType( ProcedureName ) == "B" .and. WholeDropdown
      MsgOOHGError( "ACTION and WHOLEDROPDOWN clauses can't be used simultaneously. Program terminated." )
   EndIf

   id := _GetId()

   InitToolButton( ::ContainerhWnd, Caption, id, ::ContainerCol, ::ContainerRow, ::nWidth, ::nHeight, Nil, 0, separator, autosize, check, group, dropdown, WholeDropdown, ::Parent:visible, GetControlObjectByHandle( ::ContainerhWnd ):lVertical )

   nPos := GetButtonBarCount( ::ContainerhWnd ) - if( separator, 1, 0 )

   ::Register( Nil, ControlName, Nil, Nil, ToolTip, Id )

   ::Position  :=  nPos
   ::Caption := Caption

   nPos := At( '&', Caption )
   If nPos > 0 .AND. nPos < LEN( Caption )
      DEFINE HOTKEY 0 OBJ ::oHotKey PARENT ( ::Parent ) KEY "ALT+" + SubStr( Caption, nPos + 1, 1 ) ACTION IF( ::Enabled, ::Click(), )
   EndIf

   ::Picture := image

   ASSIGN ::OnClick     VALUE ProcedureName TYPE "B"
   ASSIGN ::OnLostFocus VALUE lostfocus     TYPE "B"
   ASSIGN ::OnGotFocus  VALUE gotfocus      TYPE "B"

   Return Self

METHOD Value( lValue ) CLASS TToolButton

   If ValType( lValue ) == "L"
      CheckButtonBar( ::ContainerhWnd, ::Position - 1, lValue )
   EndIf

   Return IsButtonBarChecked( ::ContainerhWnd, ::Position - 1 )

METHOD Enabled( lEnabled ) CLASS TToolButton

   If ValType( lEnabled ) == "L"
      ::Super:Enabled := lEnabled
      If lEnabled
         cEnableToolbarButton( ::ContainerhWnd, ::Id )
      Else
         cDisableToolbarButton( ::ContainerhWnd, ::Id )
      EndIf
   EndIf

   Return ::Super:Enabled

METHOD Events_Notify( wParam, lParam ) CLASS TToolButton

   Local cToolTip, nNotify := GetNotifyCode( lParam )

   If nNotify == TTN_NEEDTEXT
      cToolTip := ::ToolTip
      If HB_IsBlock( cToolTip )
         ::DoEvent( { || cToolTip := EVAL( cToolTip, Self ) }, "TOOLTIP" )
      EndIf
      If HB_IsString( cToolTip )
         ShowToolButtonTip( lParam, cToolTip )
      EndIf
      Return Nil
   EndIf

   Return ::Super:Events_Notify( wParam, lParam )

METHOD Picture( cPicture ) CLASS TToolButton

   Local nAttrib

   If ValType( cPicture ) $ "CM"
      nAttrib := LR_LOADMAP3DCOLORS + LR_LOADTRANSPARENT
      ::HBitMap := _OOHG_BitmapFromFile( ::Container, cPicture, nAttrib, .F. )
      ::cPicture := cPicture
   EndIf

   Return ::cPicture

METHOD HBitMap( hBitMap ) CLASS TToolButton

   If ValType( hBitMap ) $ "NP"
      DeleteObject( ::hImage )
      ::hImage := hBitMap
      ::RePaint()
      ::cPicture := ""
   EndIf

   Return ::hImage

METHOD Buffer( cBuffer ) CLASS TToolButton

   If ValType( cBuffer ) $ "CM"
      ::HBitMap := _OOHG_BitmapFromBuffer( ::Container, cBuffer, .F. )
   EndIf

   Return Nil

METHOD Release() CLASS TToolButton

   If HB_IsObject( ::oHotKey )
      ::oHotKey:Release()
   EndIf
   If OsIsWinVistaOrLater()
      SendMessage( ::ContainerhWnd, TB_DELETEBUTTON, ::Position - 1, 0 )
   EndIf
   DeleteObject( ::hImage )

   Return ::Super:Release()

METHOD Caption( caption ) CLASS TToolButton

   If ValType( caption ) $ "CM"
      SetToolButtonCaption( ::ContainerhWnd, ::Position - 1, caption )
   EndIf

   Return GetToolButtonCaption( ::ContainerhWnd, ::Position - 1 )

METHOD RePaint() CLASS TToolButton

   If ValidHandler( ::hImage )
      HB_INLINE( ::ContainerhWnd, ::hImage, ::Id ){
         HWND         hwndTB;
         HWND         hImageNew;
         int          iId;
         int          iPos;
         TBBUTTONINFO tbbtn;
         TBADDBITMAP  tbadd;

         hwndTB    = HWNDparam( 1 );
         hImageNew = HWNDparam( 2 );
         iId       = hb_parni( 3 );

         if( hImageNew )
         {
            memset( &tbadd, 0, sizeof( tbadd ) );
            tbadd.hInst = NULL;
            tbadd.nID   = (UINT_PTR) hImageNew;
            SendMessage( hwndTB, TB_BUTTONSTRUCTSIZE, (WPARAM) sizeof( TBBUTTON ), 0 );
            iPos = SendMessage( hwndTB, TB_ADDBITMAP, 1, (LPARAM) &tbadd );
         }
         else
         {
            iPos = 0;
         }

         memset( &tbbtn, 0, sizeof( tbbtn ) );
         tbbtn.cbSize    = sizeof( tbbtn );
         tbbtn.dwMask    = TBIF_IMAGE;
         tbbtn.idCommand = iId;
         tbbtn.iImage    = iPos;
         SendMessage( hwndTB, TB_BUTTONSTRUCTSIZE, (WPARAM) sizeof( TBBUTTON ), 0 );
         SendMessage( hwndTB, TB_CHANGEBITMAP, iId, iPos );
      }
   EndIf

   Return Self


#pragma BEGINDUMP

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

#define NUM_TOOLBAR_BUTTONS 20

HB_FUNC( INITTOOLBAR )
{
   HWND hwnd;
   HWND hwndTB;
   int Style = WS_CHILD | WS_CLIPCHILDREN | WS_CLIPSIBLINGS | hb_parni( 16 );

   int ExStyle;
   int TbExStyle = TBSTYLE_EX_DRAWDDARROWS;

   hwnd = HWNDparam( 1 );

   ExStyle = _OOHG_RTL_Status( hb_parl( 15 ) );

   if( hb_parl( 14 ) )
   {
      ExStyle |= WS_EX_CLIENTEDGE;
   }

   if ( hb_parl( 10 ) )
   {
      Style = Style | TBSTYLE_FLAT;
   }

   if ( hb_parl( 11 ) )
   {
      Style = Style | CCS_BOTTOM;
   }

   if ( hb_parl( 12 ) )
   {
      Style = Style | TBSTYLE_LIST;
   }

   if ( hb_parl( 13 ) )
   {
      Style = Style | CCS_NOPARENTALIGN | CCS_NODIVIDER | CCS_NORESIZE;
   }

   if ( hb_parl( 17 ) )
   {
      Style = Style | CCS_VERT;
   }

   hwndTB = CreateWindowEx( ExStyle, TOOLBARCLASSNAME, (LPSTR) NULL, Style, 0, 0, 0, 0, hwnd, (HMENU) hb_parni( 3 ), GetModuleHandle( NULL ), NULL );

   lpfnOldWndProc = (WNDPROC) SetWindowLongPtr( hwndTB, GWL_WNDPROC, (LONG_PTR) SubClassFunc );

   if( hb_parni( 6 ) && hb_parni( 7 ) )
   {
      SendMessage( hwndTB, TB_SETBUTTONSIZE, hb_parni( 6 ), hb_parni( 7 ));
      SendMessage( hwndTB, TB_SETBITMAPSIZE, 0, (LPARAM) MAKELONG( hb_parni( 6 ), hb_parni( 7 ) ) );
   }

   SendMessage( hwndTB, TB_SETEXTENDEDSTYLE, 0, (LPARAM) TbExStyle );

   if( hb_parni( 16 ) & WS_VISIBLE )
   {
      ShowWindow( hwndTB, SW_SHOW );
   }
   HWNDret( hwndTB );
}

HB_FUNC( INITTOOLBUTTON )
{
   HWND hwndTB;
   TBBUTTON tbb[ NUM_TOOLBAR_BUTTONS ];
   int index;
   int nBtn;
   int Style;

   memset( tbb, 0, sizeof( tbb ) );

   hwndTB = HWNDparam( 1 );

   // Add the bitmap containing button images to the toolbar.

   Style =  TBSTYLE_BUTTON;

   if ( hb_parl(11) )
   {
      Style = Style | TBSTYLE_AUTOSIZE;
   }

   nBtn = 0;

   // Add the strings

   if( strlen( hb_parc( 2 ) ) > 0 )
   {
      index = SendMessage( hwndTB, TB_ADDSTRING, 0, (LPARAM) hb_parc( 2 ) );
      tbb[nBtn].iString = index;
   }

   if( hb_parl( 12 ) )
   {
      Style = Style | BTNS_CHECK;
   }

   if( hb_parl( 13 ) )
   {
      Style = Style | BTNS_GROUP;
   }

   if( hb_parl( 14 ) )
   {
      Style = Style | BTNS_DROPDOWN;
   }

   if( hb_parl( 15 ) )
   {
      Style = Style | BTNS_WHOLEDROPDOWN;
   }

   SendMessage( hwndTB, TB_AUTOSIZE, 0, 0 );

   // Button New

   tbb[ nBtn ].iBitmap = 0;
   tbb[ nBtn ].idCommand = hb_parni( 3 );
   if( hb_parl( 17 ) )
   {
      tbb[ nBtn ].fsState = TBSTATE_ENABLED | TBSTATE_WRAP;
   }
   else
   {
      tbb[ nBtn ].fsState = TBSTATE_ENABLED;
   }
   tbb[ nBtn ].fsStyle = (BYTE) Style;
   nBtn++;

   if( hb_parl( 10 ) )
   {
      tbb[ nBtn ].fsState = 0;
      tbb[ nBtn ].fsStyle = TBSTYLE_SEP;
      nBtn++;
   }

   SendMessage( hwndTB, TB_BUTTONSTRUCTSIZE, (WPARAM) sizeof( TBBUTTON ), 0 );

   SendMessage( hwndTB, TB_ADDBUTTONS, nBtn, (LPARAM) &tbb );

   if( hb_parl( 16 ) )
   {
      ShowWindow( hwndTB, SW_SHOW );
   }
}

HB_FUNC( CDISABLETOOLBARBUTTON )
{
   hb_retnl( SendMessage( HWNDparam( 1 ), TB_ENABLEBUTTON, hb_parni( 2 ), MAKELONG( 0, 0 ) ) );
}

HB_FUNC( CENABLETOOLBARBUTTON )
{
   hb_retnl( SendMessage( HWNDparam( 1 ), TB_ENABLEBUTTON, hb_parni( 2 ), MAKELONG( 1, 0 ) ) );
}

HB_FUNC( GETSIZETOOLBAR )
{
   SIZE lpSize;
   TBBUTTON lpBtn;
   int i, nBtn;
   OSVERSIONINFO osvi;

   SendMessage( HWNDparam( 1 ), TB_GETMAXSIZE, 0, (LPARAM)&lpSize );

   osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
   GetVersionEx(&osvi);

   nBtn = SendMessage( HWNDparam( 1 ), TB_BUTTONCOUNT, 0, 0 );

   for( i = 0 ; i < nBtn ; i++ )
   {
      SendMessage( HWNDparam( 1 ),TB_GETBUTTON, i, (LPARAM)  &lpBtn);

      if( osvi.dwPlatformId != VER_PLATFORM_WIN32_NT && osvi.dwMajorVersion >= 4 )
      {
         if( lpBtn.fsStyle & BTNS_DROPDOWN )
         {
            lpSize.cx = lpSize.cx + 15 ;
         }
      }

   }

   hb_retnl( MAKELONG( lpSize.cy, lpSize.cx ) );
}

LONG WidestBtn(LPCTSTR pszStr, HWND hwnd)
{
   SIZE     sz;
   LOGFONT  lf;
   HFONT    hFont;
   HDC      hdc;

   SystemParametersInfo(SPI_GETICONTITLELOGFONT,sizeof(LOGFONT),&lf,0);

   hdc = GetDC(hwnd);
   hFont = CreateFontIndirect(&lf);
   SelectObject(hdc,hFont);

   GetTextExtentPoint32(hdc, pszStr, strlen(pszStr), &sz);

   ReleaseDC(hwnd, hdc);
   DeleteObject(hFont);

   return (MAKELONG(sz.cx, sz.cy) );
}

HB_FUNC( MAXTEXTBTNTOOLBAR )      //(HWND hwndTB, int cx, int cy)
{
   char cString[255] = "" ;

   int i,nBtn;
   int tmax = 0;
   int ty = 0;
   DWORD tSize;
   DWORD Style;
   TBBUTTON lpBtn;
   HWND hWnd;

   hWnd = HWNDparam( 1 );
   nBtn  = SendMessage( hWnd, TB_BUTTONCOUNT,0,0);
   for( i = 0; i < nBtn; i++ )
   {
      SendMessage( hWnd, TB_GETBUTTON, i, (LPARAM)  &lpBtn);
      SendMessage( hWnd, TB_GETBUTTONTEXT, lpBtn.idCommand, (LPARAM)(LPCTSTR) cString);

      tSize = WidestBtn(cString, hWnd );
      ty = HIWORD(tSize);

      if( tmax < LOWORD(tSize) )
      {
         tmax = LOWORD(tSize);
      }
   }

   if( tmax == 0 )
   {
      SendMessage( hWnd, TB_SETBUTTONSIZE, hb_parni(2),hb_parni(3));//  -ty);
      SendMessage( hWnd, TB_SETBITMAPSIZE,  0,(LPARAM)MAKELONG(hb_parni(2),hb_parni(3)));
   }
   else
   {
      Style = SendMessage( hWnd, TB_GETSTYLE, 0, 0);
      if( Style & TBSTYLE_LIST )
      {
         SendMessage( hWnd, TB_SETBUTTONSIZE, hb_parni(2),hb_parni(3)+2);
         SendMessage( hWnd, TB_SETBITMAPSIZE,0,(LPARAM) MAKELONG(hb_parni(3),hb_parni(3)));
      }
      else
      {
         SendMessage( hWnd, TB_SETBUTTONSIZE, hb_parni(2),hb_parni(3)-ty+2);
         SendMessage( hWnd, TB_SETBITMAPSIZE,0,(LPARAM) MAKELONG(hb_parni(3)-ty,hb_parni(3)-ty));
      }
      SendMessage( hWnd,TB_SETBUTTONWIDTH, 0, (LPARAM) MAKELONG(hb_parni(2),hb_parni(2)+2));
   }
   SendMessage( hWnd,TB_AUTOSIZE,0,0);  //JP62
}

HB_FUNC( ISBUTTONBARCHECKED )          // hb_parni(2) -> Position in ToolBar
{
   TBBUTTON lpBtn;

   SendMessage( HWNDparam( 1 ),TB_GETBUTTON, hb_parni(2), (LPARAM)  &lpBtn);
   hb_retl( SendMessage( HWNDparam( 1 ),TB_ISBUTTONCHECKED, lpBtn.idCommand, 0 ) );
}

HB_FUNC( CHECKBUTTONBAR )          // hb_parni(2) -> Position in ToolBar
{
   TBBUTTON lpBtn;
   SendMessage( HWNDparam( 1 ),TB_GETBUTTON, hb_parni(2), (LPARAM)  &lpBtn);
   SendMessage( HWNDparam( 1 ),TB_CHECKBUTTON, lpBtn.idCommand, hb_parl(3) );
}

HB_FUNC( GETBUTTONBARRECT )
{
   RECT rc;
   SendMessage( HWNDparam( 1 ), TB_GETITEMRECT,(WPARAM) hb_parnl(2),(LPARAM) &rc);
   hb_retnl( MAKELONG(rc.left,rc.bottom) );
}

HB_FUNC( GETBUTTONPOS )
{
   hb_retnl( (LONG) (((NMTOOLBAR FAR *) hb_parnl(1))->iItem) );
}

HB_FUNC( GETBUTTONBARCOUNT)
{
   hb_retni ( SendMessage( HWNDparam( 1 ), TB_BUTTONCOUNT,0,0) );
}

HB_FUNC( SETBUTTONID )
{
   hb_retni ( SendMessage( HWNDparam( 1 ), TB_SETCMDID,hb_parni(2),hb_parni(3)) );
}

HB_FUNC( SHOWTOOLBUTTONTIP )
{
   LPTOOLTIPTEXT lpttt;
   lpttt = ( LPTOOLTIPTEXT ) hb_parnl( 1 );
   lpttt->hinst = GetModuleHandle( NULL );
   lpttt->lpszText = ( LPSTR ) hb_parc( 2 );
}

HB_FUNC ( GETTOOLBUTTONID )
{
   LPTOOLTIPTEXT lpttt;
   lpttt = (LPTOOLTIPTEXT) hb_parnl(1) ;
   hb_retni ( lpttt->hdr.idFrom ) ;
}

HB_FUNC( _TOOLBARGETINFOTIP )
{
   hb_retni( ( ( LPNMTBGETINFOTIP ) hb_parnl( 1 ) ) -> iItem );
}

HB_FUNC( _TOOLBARSETINFOTIP )
{
   LPNMTBGETINFOTIP lpInfo = ( LPNMTBGETINFOTIP ) hb_parnl( 1 );
   int iLen;

   iLen = hb_parclen( 2 );
   if( iLen >= lpInfo->cchTextMax )
   {
      iLen = lpInfo->cchTextMax;
      if( iLen > 0 )
      {
         iLen--;
      }
   }

   hb_xmemcpy( lpInfo->pszText, hb_parc( 2 ), iLen );
   lpInfo->pszText[ iLen ] = 0;
}

HB_FUNC( GETTOOLBUTTONCAPTION )
{
   TBBUTTON lpBtn;
   char cString[255] = "" ;

   SendMessage( HWNDparam( 1 ), TB_GETBUTTON, hb_parni( 2 ), (LPARAM)  &lpBtn);
   SendMessage( HWNDparam( 1 ), TB_GETBUTTONTEXT, lpBtn.idCommand, (LPARAM)(LPCTSTR) cString);

   hb_retc( cString );
}

HB_FUNC( SETTOOLBUTTONCAPTION )
{
   TBBUTTON lpBtn;
   TBBUTTONINFO tbbtn;

   SendMessage( HWNDparam( 1 ), TB_GETBUTTON, hb_parni( 2 ), (LPARAM) &lpBtn);

   memset( &tbbtn, 0, sizeof( tbbtn ) );
   tbbtn.cbSize  = sizeof( TBBUTTONINFO );
   tbbtn.dwMask  = TBIF_TEXT;
   tbbtn.pszText = (LPTSTR) hb_parc( 3 );

   SendMessage( HWNDparam( 1 ), TB_SETBUTTONINFO, (WPARAM) lpBtn.idCommand, (LPARAM) &tbbtn );
}

#pragma ENDDUMP
