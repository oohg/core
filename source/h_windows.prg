/*
 * $Id: h_windows.prg,v 1.69 2006-03-15 06:39:12 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG Windows handling functions
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
#include "i_windefs.ch"
#include "common.ch"
#include "error.ch"

STATIC _OOHG_aFormhWnd := {}, _OOHG_aFormObjects := {}
STATIC _OOHG_aEventInfo := {}        // Event's stack
STATIC _OOHG_UserWindow := nil       // User's window
STATIC _OOHG_InteractiveClose := 1   // Interactive close
STATIC _OOHG_MessageLoops := {}      // Message loops
STATIC _OOHG_ActiveModal := {}       // Modal windows' stack
STATIC _OOHG_DialogCancelled := .F.  //
STATIC _OOHG_HotKeys := {}           // Application-wide hot keys
STATIC _OOHG_TooltipBackcolor :=NIL
STATIC _OOHG_TooltipForecolor :=NIL


#include "hbclass.ch"

// C static variables
#pragma BEGINDUMP

#include "hbapi.h"
#include "hbapiitm.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windows.h>
#include <commctrl.h>
#include <olectl.h>
#include "../include/oohg.h"

#ifdef HB_ITEM_NIL
   #define hb_dynsymSymbol( pDynSym )        ( ( pDynSym )->pSymbol )
#endif

int _OOHG_ShowContextMenus = 1;      //
int _OOHG_GlobalRTL = 0;             // Force RTL functionality
int _OOHG_NestedSameEvent = 0;       // Allows to nest an event currently performed (i.e. CLICK button)
PHB_ITEM _OOHG_LastSelf = NULL;

#pragma ENDDUMP

*------------------------------------------------------------------------------*
CLASS TWindow
*------------------------------------------------------------------------------*
   DATA hWnd       INIT 0
   DATA aControlInfo INIT { CHR( 0 ) }
   DATA Name       INIT ""
   DATA Type       INIT ""
   DATA Parent     INIT nil
   DATA nRow       INIT 0
   DATA nCol       INIT 0
   DATA nWidth     INIT 0
   DATA nHeight    INIT 0
   DATA cFontName  INIT ""
   DATA nFontSize  INIT 0
   DATA Bold       INIT .F.
   DATA Italic     INIT .F.
   DATA Underline  INIT .F.
   DATA Strikeout  INIT .F.
   DATA RowMargin  INIT 0
   DATA ColMargin  INIT 0
   DATA Container  INIT nil
   DATA lRtl       INIT .F.
   DATA ContextMenu    INIT nil
   DATA Cargo          INIT nil
   DATA lEnabled       INIT .T.
   DATA aControls      INIT {}
   DATA aControlsNames INIT {}
   DATA lInternal      INIT .T.
   DATA WndProc        INIT nil
   DATA OverWndProc    INIT nil

   DATA OnClick        INIT nil
   DATA OnGotFocus     INIT nil
   DATA OnLostFocus    INIT nil
   DATA OnMouseDrag    INIT nil
   DATA OnMouseMove    INIT nil
   DATA aKeys          INIT {}  // { Id, Mod, Key, Action }   Application-controlled hotkeys
   DATA aHotKeys       INIT {}  // { Id, Mod, Key, Action }   OperatingSystem-controlled hotkeys

   DATA NestedClick    INIT .F.

   DATA DefBkColorEdit  INIT nil

   METHOD SethWnd
   METHOD Release
   METHOD StartInfo
   METHOD SetFocus
   METHOD ImageList           SETGET
   METHOD BrushHandle         SETGET
   METHOD FontColor           SETGET
   METHOD BackColor           SETGET
   METHOD FontColorSelected   SETGET
   METHOD BackColorSelected   SETGET
   METHOD Events

   METHOD Enabled             SETGET
   METHOD RTL                 SETGET
   METHOD Action              SETGET
   METHOD Print
   METHOD AddControl
   METHOD DeleteControl

   ERROR HANDLER Error
   METHOD Control

   METHOD HotKey                // OperatingSystem-controlled hotkeys
   METHOD SetKey                // Application-controlled hotkeys
   METHOD LookForKey
ENDCLASS

#pragma BEGINDUMP

HB_FUNC_STATIC( TWINDOW_SETHWND )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( hb_pcount() >= 1 && ISNUM( 1 ) )
   {
      oSelf->hWnd = ( HWND ) hb_parnl( 1 );
   }

   hb_retnl( ( LONG ) oSelf->hWnd );
}

HB_FUNC_STATIC( TWINDOW_RELEASE )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   // ImageList
   if( oSelf->ImageList )
   {
      ImageList_Destroy( oSelf->ImageList );
      oSelf->ImageList = 0;
   }

   // Auxiliar Buffer
   if( oSelf->AuxBuffer )
   {
      hb_xfree( oSelf->AuxBuffer );
      oSelf->AuxBuffer = NULL;
      oSelf->AuxBufferLen = 0;
   }

   // Brush handle
   if( oSelf->BrushHandle )
   {
      DeleteObject( oSelf->BrushHandle );
      oSelf->BrushHandle = NULL;
   }

   // ::hWnd := -1
   oSelf->hWnd = ( HWND ) -1;
   _OOHG_Send( pSelf, s__hWnd );
   hb_vmPushInteger( -1 );
   hb_vmSend( 1 );
}

HB_FUNC_STATIC( TWINDOW_STARTINFO )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   oSelf->hWnd = ( HWND ) hb_parnl( 1 );

   oSelf->lFontColor = -1;
   oSelf->lBackColor = -1;
   oSelf->lFontColorSelected = -1;
   oSelf->lBackColorSelected = -1;

   // HACK! Latest created control... Needed for WM_MEASUREITEM :(
   if( ! _OOHG_LastSelf )
   {
      _OOHG_LastSelf = hb_itemNew( NULL );
   }
   hb_itemCopy( _OOHG_LastSelf, pSelf );
}

HB_FUNC_STATIC( TWINDOW_SETFOCUS )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   PHB_ITEM pReturn;

   SetFocus( oSelf->hWnd );

   pReturn = hb_itemNew( NULL );
   hb_itemCopy( pReturn, pSelf );
   hb_itemReturn( pReturn );
   hb_itemRelease( pReturn );
}

HB_FUNC_STATIC( TWINDOW_IMAGELIST )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( hb_pcount() >= 1 && ISNUM( 1 ) )
   {
      oSelf->ImageList = ( HIMAGELIST ) hb_parnl( 1 );
   }

   hb_retnl( ( LONG ) oSelf->ImageList );
}

HB_FUNC_STATIC( TWINDOW_BRUSHHANDLE )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( hb_pcount() >= 1 && ISNUM( 1 ) )
   {
      oSelf->BrushHandle = ( HBRUSH ) hb_parnl( 1 );
   }

   hb_retnl( ( LONG ) oSelf->BrushHandle );
}

HB_FUNC_STATIC( TWINDOW_FONTCOLOR )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( hb_pcount() >= 1 )
   {
      oSelf->lFontColor = -1;
      _OOHG_DetermineColor( hb_param( 1, HB_IT_ANY ), &oSelf->lFontColor );
      if( oSelf->hWnd )
      {
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   if( oSelf->lFontColor != -1 )
   {
      hb_reta( 3 );
      hb_stornl( GetRValue( oSelf->lFontColor ), -1, 1 );
      hb_stornl( GetGValue( oSelf->lFontColor ), -1, 2 );
      hb_stornl( GetBValue( oSelf->lFontColor ), -1, 3 );
   }
   else
   {
      hb_ret();
   }
}

HB_FUNC_STATIC( TWINDOW_BACKCOLOR )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( hb_pcount() >= 1 )
   {
      oSelf->lBackColor = -1;
      _OOHG_DetermineColor( hb_param( 1, HB_IT_ANY ), &oSelf->lBackColor );
      if( oSelf->hWnd )
      {
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   if( oSelf->lBackColor != -1 )
   {
      hb_reta( 3 );
      hb_stornl( GetRValue( oSelf->lBackColor ), -1, 1 );
      hb_stornl( GetGValue( oSelf->lBackColor ), -1, 2 );
      hb_stornl( GetBValue( oSelf->lBackColor ), -1, 3 );
   }
   else
   {
      hb_ret();
   }
}

HB_FUNC_STATIC( TWINDOW_FONTCOLORSELECTED )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( hb_pcount() >= 1 )
   {
      oSelf->lFontColorSelected = -1;
      _OOHG_DetermineColor( hb_param( 1, HB_IT_ANY ), &oSelf->lFontColorSelected );
      if( oSelf->hWnd )
      {
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   if( oSelf->lFontColorSelected != -1 )
   {
      hb_reta( 3 );
      hb_stornl( GetRValue( oSelf->lFontColorSelected ), -1, 1 );
      hb_stornl( GetGValue( oSelf->lFontColorSelected ), -1, 2 );
      hb_stornl( GetBValue( oSelf->lFontColorSelected ), -1, 3 );
   }
   else
   {
      hb_ret();
   }
}

HB_FUNC_STATIC( TWINDOW_BACKCOLORSELECTED )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( hb_pcount() >= 1 )
   {
      oSelf->lBackColorSelected = -1;
      _OOHG_DetermineColor( hb_param( 1, HB_IT_ANY ), &oSelf->lBackColorSelected );
      if( oSelf->hWnd )
      {
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   if( oSelf->lBackColorSelected != -1 )
   {
      hb_reta( 3 );
      hb_stornl( GetRValue( oSelf->lBackColorSelected ), -1, 1 );
      hb_stornl( GetGValue( oSelf->lBackColorSelected ), -1, 2 );
      hb_stornl( GetBValue( oSelf->lBackColorSelected ), -1, 3 );
   }
   else
   {
      hb_ret();
   }
}

HB_FUNC_STATIC( TWINDOW_EVENTS )
{
   HWND hWnd      = ( HWND )   hb_parnl( 1 );
   UINT message   = ( UINT )   hb_parni( 2 );
   WPARAM wParam  = ( WPARAM ) hb_parni( 3 );
   LPARAM lParam  = ( LPARAM ) hb_parnl( 4 );
   PHB_ITEM pSelf = hb_stackSelfItem();

   switch( message )
   {
      case WM_CTLCOLORSTATIC:
         _OOHG_Send( GetControlObjectByHandle( ( LONG ) lParam ), s_Events_Color );
         hb_vmPushLong( wParam );
         hb_vmPushLong( COLOR_3DFACE );
         hb_vmSend( 2 );
         break;

      case WM_CTLCOLOREDIT:
      case WM_CTLCOLORLISTBOX:
         _OOHG_Send( GetControlObjectByHandle( ( LONG ) lParam ), s_Events_Color );
         hb_vmPushLong( wParam );
         hb_vmPushLong( COLOR_WINDOW );
         hb_vmSend( 2 );
         break;

      case WM_NOTIFY:
         _OOHG_Send( GetControlObjectByHandle( ( LONG ) ( ( ( NMHDR FAR * ) lParam )->hwndFrom ) ), s_Events_Notify );
         hb_vmPushLong( wParam );
         hb_vmPushLong( lParam );
         hb_vmSend( 2 );
         break;

      case WM_DRAWITEM:
         _OOHG_Send( GetControlObjectByHandle( ( LONG ) ( ( ( LPDRAWITEMSTRUCT ) lParam )->hwndItem ) ), s_Events_DrawItem );
         hb_vmPushLong( lParam );
         hb_vmSend( 1 );
         break;

      case WM_MEASUREITEM:
         if( wParam )
         {
            _OOHG_Send( GetControlObjectById( ( LONG ) ( ( ( LPMEASUREITEMSTRUCT ) lParam )->CtlID ), ( LONG ) hWnd ), s_Events_MeasureItem );
         }
         else
         {
            _OOHG_Send( _OOHG_LastSelf, s_Events_MeasureItem );
         }
         hb_vmPushLong( lParam );
         hb_vmSend( 1 );
         break;

/********

      case WM_CONTEXTMENU:
         if( _OOHG_ShowContextMenus )
         {
            PHB_ITEM pControl, pContext;

            SetFocus( ( HWND ) wParam );
            pControl = GetControlObjectByHandle( ( LONG ) wParam );

            // Check if control have context menu
            _OOHG_Send( pControl, s_ContextMenu );
            hb_vmSend( 0 );
            pContext = hb_param( -1, HB_IT_OBJECT );
            // Check if form have context menu
            if( ! pContext )
            {
               // _OOHG_Send( pSelf, s_ContextMenu );
               _OOHG_Send( pSelf, s_ContextMenu );
               hb_vmSend( 0 );
               pContext = hb_param( -1, HB_IT_OBJECT );
            }

            // If there's a context menu, show it
            if( pContext )
            {
//               int iRow, iCol;
//               // _OOHG_MouseRow := HIWORD( lParam ) - ::RowMargin
//               _OOHG_Send( pSelf, s_RowMargin );
//               hb_vmSend( 0 );
//               iRow = HIWORD( lParam ) - hb_parni( -1 );
//               // _OOHG_MouseCol := LOWORD( lParam ) - ::ColMargin
//               _OOHG_Send( pSelf, s_ColMargin );
//               hb_vmSend( 0 );
//               iCol = LOWORD( lParam ) - hb_parni( -1 );

               // HMENU
               _OOHG_Send( pContext, s_hWnd );
               hb_vmSend( 0 );
               TrackPopupMenu( ( HMENU ) hb_parnl( -1 ), 0, ( int ) LOWORD( lParam ), ( int ) HIWORD( lParam ), 0, hWnd, 0 );
               PostMessage( hWnd, WM_NULL, 0, 0 );
               hb_ret();
            }
            else
            {
               hb_ret();
            }
         }
         else
         {
            hb_ret();
         }
         break;
********/

      default:
         _OOHG_Send( pSelf, s_WndProc );
         hb_vmSend( 0 );
         if( hb_param( -1, HB_IT_BLOCK ) )
         {
            hb_vmPushSymbol( &hb_symEval );
            hb_vmPush( hb_param( -1, HB_IT_BLOCK ) );
            hb_vmPushLong( ( LONG ) hWnd );
            hb_vmPushLong( message );
            hb_vmPushLong( wParam );
            hb_vmPushLong( lParam );
            hb_vmPush( pSelf );
            hb_vmDo( 5 );
         }
         else
         {
            hb_ret();
         }
         break;
   }
}

#pragma ENDDUMP


function _SetToolTipBackcolor ( acolor )
*--------------------------------------------------
 _OOHG_tooltipbackcolor:=acolor
return nil

*--------------------------------------------------
function _SetToolTipforecolor ( acolor )
*--------------------------------------------------
_OOHG_TooltipForeColor:=acolor
return nil

*------------------------------------------------------------------------------*
METHOD Enabled( lEnabled ) CLASS TWindow
*------------------------------------------------------------------------------*
   IF VALTYPE( lEnabled ) == "L"
      IF lEnabled
         EnableWindow( ::hWnd )
      ELSE
         DisableWindow( ::hWnd )
      ENDIF
      ::lEnabled := lEnabled
   ENDIF
RETURN ::lEnabled

*------------------------------------------------------------------------------*
METHOD RTL( lRTL ) CLASS TWindow
*------------------------------------------------------------------------------*
   If ValType( lRTL ) == "L"
      _UpdateRTL( ::hWnd, lRtl )
      ::lRtl := lRtl
   EndIf
Return ::lRtl

*------------------------------------------------------------------------------*
METHOD Action( bAction ) CLASS TWindow
*------------------------------------------------------------------------------*
   If PCount() > 0
      ::OnClick := bAction
   EndIf
Return ::OnClick

*-----------------------------------------------------------------------------*
METHOD Print( y, x, y1, x1 ) CLASS TWindow
*-----------------------------------------------------------------------------*
Local myobject, cWork
   cWork := '_oohg_t' + alltrim( str( int( random( 999999 ) ) ) ) + '.bmp'
   do while file( cWork )
      cWork := '_oohg_t' + alltrim( str( int( random( 999999 ) ) ) ) + '.bmp'
   enddo

   DEFAULT y1    TO 45
   DEFAULT x1    TO 120
   DEFAULT x    TO 4
   DEFAULT y    TO 2

   bringwindowtotop( ::Hwnd)

   WNDCOPY( ::hWnd, .F., cWork ) //// save as BMP

   myobject:= Tprint()
   myobject:init()
   myobject:selprinter(.T. , .T. , .T.  )  /// select,preview,landscape
   if myobject:lprerror
      myobject:release()
      return nil
   endif
   myobject:begindoc("ooHG printing" )
   myobject:beginpage()
   myobject:printimage(y,x,y1,x1,cwork)
   myobject:endpage()
   myobject:enddoc()
   myobject:release()
   release myobject
   FErase( cWork )
return nil

*-----------------------------------------------------------------------------*
METHOD AddControl( oControl ) CLASS TWindow
*-----------------------------------------------------------------------------*
   AADD( ::aControls,      oControl )
   AADD( ::aControlsNames, UPPER( ALLTRIM( oControl:Name ) ) + CHR( 255 ) )
Return oControl

*-----------------------------------------------------------------------------*
METHOD DeleteControl( oControl ) CLASS TWindow
*-----------------------------------------------------------------------------*
Local nPos
   nPos := aScan( ::aControlsNames, UPPER( ALLTRIM( oControl:Name ) ) + CHR( 255 ) )
   IF nPos > 0
      _OOHG_DeleteArrayItem( ::aControls,      nPos )
      _OOHG_DeleteArrayItem( ::aControlsNames, nPos )
   ENDIF
Return oControl

*-----------------------------------------------------------------------------*
METHOD Error() CLASS TWindow
*-----------------------------------------------------------------------------*
Local nPos, cMessage
   cMessage := __GetMessage()
   nPos := aScan( ::aControlsNames, UPPER( ALLTRIM( cMessage ) ) + CHR( 255 ) )
Return IF( nPos > 0, ::aControls[ nPos ], ::MsgNotFound( cMessage ) )

*-----------------------------------------------------------------------------*
METHOD Control( cControl ) CLASS TWindow
*-----------------------------------------------------------------------------*
Local nPos
   nPos := aScan( ::aControlsNames, UPPER( ALLTRIM( cControl ) ) + CHR( 255 ) )
Return IF( nPos > 0, ::aControls[ nPos ], nil )

#define HOTKEY_ID        1
#define HOTKEY_MOD       2
#define HOTKEY_KEY       3
#define HOTKEY_ACTION    4

*-----------------------------------------------------------------------------*
METHOD HotKey( nKey, nFlags, bAction ) CLASS TWindow
*-----------------------------------------------------------------------------*
Local nPos, nId, uRet := nil
   nPos := ASCAN( ::aHotKeys, { |a| a[ HOTKEY_KEY ] == nKey .AND. a[ HOTKEY_MOD ] == nFlags } )
   If nPos > 0
      uRet := ::aHotKeys[ nPos ][ HOTKEY_ACTION ]
   EndIf
   If PCOUNT() > 2
      If ValType( bAction ) == "B"
         If nPos > 0
            ::aHotKeys[ nPos ][ HOTKEY_ACTION ] := bAction
         Else
            nId := _GetId()
            AADD( ::aHotKeys, { nId, nFlags, nKey, bAction } )
            InitHotKey( ::hWnd, nFlags, nKey, nId )
         EndIf
      Else
         If nPos > 0
            ReleaseHotKey( ::hWnd, ::aHotKeys[ nPos ][ HOTKEY_ID ] )
            _OOHG_DeleteArrayItem( ::aHotKeys, nPos )
         EndIf
      Endif
   EndIf
Return uRet

*-----------------------------------------------------------------------------*
METHOD SetKey( nKey, nFlags, bAction ) CLASS TWindow
*-----------------------------------------------------------------------------*
Return _OOHG_SetKey( ::aKeys, nKey, nFlags, bAction )

*-----------------------------------------------------------------------------*
METHOD LookForKey( nKey, nFlags ) CLASS TWindow
*-----------------------------------------------------------------------------*
Local lDone, nPos
   nPos := ASCAN( ::aKeys, { |a| a[ HOTKEY_KEY ] == nKey .AND. nFlags == a[ HOTKEY_MOD ] } )
   If nPos > 0
      Eval( ::aKeys[ nPos ][ HOTKEY_ACTION ], nKey, nFlags )
      lDone := .T.
   ElseIf ValType( ::Container ) == "O"
      lDone := ::Container:LookForKey( nKey, nFlags )
   ElseIf ValType( ::Parent ) == "O" .AND. ::lInternal
      lDone := ::Parent:LookForKey( nKey, nFlags )
   Else
      nPos := ASCAN( _OOHG_HotKeys, { |a| a[ HOTKEY_KEY ] == nKey .AND. nFlags == a[ HOTKEY_MOD ] } )
      If nPos > 0
         Eval( _OOHG_HotKeys[ nPos ][ HOTKEY_ACTION ], nKey, nFlags )
         lDone := .T.
      Else
         lDone := .F.
      EndIf
   EndIf
Return lDone

*------------------------------------------------------------------------------*
CLASS TForm FROM TWindow
*------------------------------------------------------------------------------*
   DATA Active         INIT .F.
   DATA ToolTipHandle  INIT 0
   DATA NoShow         INIT .F.
   DATA Focused        INIT .F.
   DATA LastFocusedControl INIT 0
   DATA AutoRelease    INIT .F.
   DATA ActivateCount  INIT { 0 }
   DATA ReBarHandle    INIT 0
   DATA BrowseList     INIT {}
   DATA lInternal      INIT .F.

   DATA OnRelease      INIT nil
   DATA OnInit         INIT nil
   DATA OnSize         INIT nil
   DATA OnPaint        INIT nil
   DATA OnScrollUp     INIT nil
   DATA OnScrollDown   INIT nil
   DATA OnScrollLeft   INIT nil
   DATA OnScrollRight  INIT nil
   DATA OnHScrollBox   INIT nil
   DATA OnVScrollBox   INIT nil
   DATA OnInteractiveClose INIT nil
   DATA OnMaximize     INIT nil
   DATA OnMinimize     INIT nil

   DATA VirtualHeight  INIT 0
   DATA VirtualWidth   INIT 0
   DATA RangeHeight    INIT 0
   DATA RangeWidth     INIT 0

   DATA GraphTasks     INIT {}
   DATA SplitChildList INIT {}
   DATA LockedForms    INIT {}

   DATA NotifyIconLeftClick   INIT nil
   DATA NotifyMenuHandle      INIT 0
   DATA cNotifyIconName       INIT ""
   DATA cNotifyIconToolTip    INIT ""
   METHOD NotifyIconName      SETGET
   METHOD NotifyIconToolTip   SETGET
   METHOD Title               SETGET
   METHOD Height              SETGET
   METHOD Width               SETGET
   METHOD Col                 SETGET
   METHOD Row                 SETGET
   METHOD Cursor              SETGET
   METHOD BackColor           SETGET

   METHOD FocusedControl
   METHOD SizePos
   METHOD Define
   METHOD Define2
   METHOD Register
   METHOD Hide
   METHOD Show
   METHOD Activate
   METHOD Release
   METHOD Center()      BLOCK { | Self | C_Center( ::hWnd ) }
   METHOD Restore()     BLOCK { | Self | Restore( ::hWnd ) }
   METHOD Minimize()    BLOCK { | Self | Minimize( ::hWnd ) }
   METHOD Maximize()    BLOCK { | Self | Maximize( ::hWnd ) }

   METHOD SetActivationFlag
   METHOD SetFocusedSplitChild
   METHOD SetActivationFocus
   METHOD ProcessInitProcedure
   METHOD RefreshDataControls
   METHOD OnHideFocusManagement
   METHOD DoEvent

   METHOD Events
   METHOD MessageLoop

ENDCLASS

*------------------------------------------------------------------------------*
METHOD Define( FormName, Caption, x, y, w, h, nominimize, nomaximize, nosize, ;
               nosysmenu, nocaption, initprocedure, ReleaseProcedure, ;
               MouseDragProcedure, SizeProcedure, ClickProcedure, ;
               MouseMoveProcedure, aRGB, PaintProcedure, noshow, topmost, ;
               icon, fontname, fontsize, NotifyIconName, NotifyIconTooltip, ;
               NotifyIconLeftClick, GotFocus, LostFocus, Virtualheight, ;
               VirtualWidth, scrollleft, scrollright, scrollup, scrolldown, ;
               hscrollbox, vscrollbox, helpbutton, maximizeprocedure, ;
               minimizeprocedure, cursor, NoAutoRelease, oParent, ;
               InteractiveCloseProcedure, Focused, Break, GripperText, lRtl, ;
               main, splitchild, child, modal, modalsize, mdi, internal ) CLASS TForm
*------------------------------------------------------------------------------*
Local aError := {}, nMain, hParent, lSplit := .F.
Local nStyle := 0, nStyleEx := 0

   nMain := ASCAN( _OOHG_aFormObjects, { |o| o:Type == "A" } )

   If ValType( oParent ) $ "CM" .AND. ! Empty( oParent )
      oParent := GetFormObject( oParent )
      If oParent:hWnd <= 0
         MsgOOHGError( "Specified parent window is not defined. Program Terminated." )
      Endif
   ElseIf ValType( oParent ) != "O"
      oParent := GetFormObjectByHandle( GetActiveWindow() )
      If oParent:hWnd == 0
         If _OOHG_UserWindow != NIL .AND. ascan( _OOHG_aFormhWnd, _OOHG_UserWindow:hWnd ) > 0
            oParent := _OOHG_UserWindow
         ElseIf Len( _OOHG_ActiveModal ) > 0 .AND. ascan( _OOHG_aFormhWnd, ATAIL( _OOHG_ActiveModal ):hWnd ) > 0
            oParent := ATAIL( _OOHG_ActiveModal )
         Else
            oParent := _OOHG_Main
         Endif
      EndIf
   EndIf

   if Valtype( main ) == "L" .AND. main

      if nMain > 0
         MsgOOHGError( "Main Window Already Defined. Program Terminated." )
		Endif

		if NoAutoRelease == .T.
         MsgOOHGError("NOAUTORELEASE and MAIN Clauses Can't Be Used Simultaneously. Program Terminated" )
		Endif

      AADD( aError, "MAIN" )

      hParent := 0
      ::Type := "A"

      _OOHG_Main := Self

   else

      main := .F.

      if nMain == 0
         MsgOOHGError( "Main Window Not Defined. Program Terminated." )
		Endif

      hParent := 0
      ::Type := "S"

   endif

   if Valtype( splitchild ) == "L" .AND. splitchild

*      [ GRIPPERTEXT <grippertext> ] ;
*      [ <break: BREAK> ] ;
*      [ <focused: FOCUSED> ] ;

      nStyleEx += WS_EX_STATICEDGE + WS_EX_TOOLWINDOW

      AADD( aError, "SPLITCHILD" )

      oParent := ATail( _OOHG_ActiveForm )

      If _OOHG_ActiveSplitBox == .F.
         MsgOOHGError( "SplitChild Windows Can be Defined Only Inside SplitBox. Program terminated." )
      EndIf

      if _OOHG_SplitForceBreak .AND. ! _OOHG_ActiveSplitBoxInverted
         Break := .T.
      endif
      _OOHG_SplitForceBreak := .F.

      helpbutton := nominimize := nomaximize := nosize := nosysmenu := noshow := .F.
      // aRgb := { -1, -1, -1 }

      ::Type := "X"
      ::Focused := Focused
      ::Parent := oParent

      aAdd ( oParent:SplitChildList, Self )
      ::ActivateCount[ 1 ] += 999

      lSplit := .T.

   else
      splitchild := .F.
*      solo splitchild: [ GRIPPERTEXT <grippertext> ] ;    main????
*      solo splitchild: [ <break: BREAK> ] ;               main????
*      solo splitchild: [ <focused: FOCUSED> ] ;           main????
   endif

   if Valtype( child ) == "L" .AND. child

      AADD( aError, "CHILD" )

      hParent := oParent:hWnd

      ::Type := "C"

   else

      child := .F.

   endif

   if Valtype( modal ) == "L" .AND. modal

      AADD( aError, "MODAL" )
      ::Type := "M"
      ::Parent := oParent
      hParent := oParent:hWnd
      nominimize := nomaximize := .T.

   else

      modal := .F.

   endif

   if Valtype( modalsize ) == "L" .AND. modalsize

      AADD( aError, "MODALSIZE" )
      ::Type := "M"
      ::Parent := oParent
      hParent := oParent:hWnd

   else

      modalsize := .F.

   endif

   if Valtype( mdi ) == "L" .AND. mdi

      oParent := ATail( _OOHG_ActiveForm )

      AADD( aError, "MDI" )
      ::Type := "D"
      ::Focused := Focused
      ::Parent := oParent
      hParent := oParent:hWnd

      aAdd( oParent:SplitChildList, Self )
      ::ActivateCount[ 1 ] += 999

      nStyle   += WS_CHILD - WS_POPUP

   else

      mdi := .F.

   endif

   if Valtype( internal ) == "L" .AND. internal

      oParent := ATail( _OOHG_ActiveForm )

      AADD( aError, "INTERNAL" )
      ::Type := "I"
      ::Focused := Focused
      ::Parent := oParent
      hParent := oParent:hWnd
      ::lInternal := .T.

      aAdd( oParent:SplitChildList, Self )
      ::ActivateCount[ 1 ] += 999

      nStyle   += WS_CHILD - WS_POPUP

      // Removes borders
      helpbutton := .f.
      nominimize := nomaximize := nosize := nosysmenu := nocaption := .t.

   else

      internal := .F.

   endif

   if Len( aError ) > 1
      MsgOOHGError( "Window: " + aError[ 1 ] + " and " + aError[ 2 ] + " clauses can't be used Simultaneously. Program Terminated." )
   endif

   nStyleEx += if( ValType( topmost ) == "L" .AND. topmost, WS_EX_TOPMOST, 0 )

   ::Define2( FormName, Caption, x, y, w, h, hParent, helpbutton, nominimize, nomaximize, nosize, nosysmenu, ;
              nocaption, virtualheight, virtualwidth, hscrollbox, vscrollbox, fontname, fontsize, aRGB, cursor, ;
              icon, noshow, gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, maximizeprocedure, ;
              minimizeprocedure, initprocedure, ReleaseProcedure, SizeProcedure, ClickProcedure, PaintProcedure, ;
              MouseMoveProcedure, MouseDragProcedure, InteractiveCloseProcedure, NoAutoRelease, nStyle, nStyleEx, ;
              lSplit, lRtl )

   if ! valtype( NotifyIconName ) $ "CM"
      NotifyIconName := ""
   Else
      ShowNotifyIcon( ::hWnd, .T. , LoadTrayIcon(GETINSTANCE(), NotifyIconName ), NotifyIconTooltip )
      ::NotifyIconName := NotifyIconName
      ::NotifyIconToolTip := NotifyIconToolTip
      ::NotifyIconLeftClick := NotifyIconLeftClick
   endif

   if splitchild
      AddSplitBoxItem( ::hWnd, oParent:ReBarHandle, w , break , grippertext ,  ,  , _OOHG_ActiveSplitBoxInverted )
   endif

Return Self

*------------------------------------------------------------------------------*
METHOD Define2( FormName, Caption, x, y, w, h, Parent, helpbutton, nominimize, nomaximize, nosize, nosysmenu, ;
                nocaption, virtualheight, virtualwidth, hscrollbox, vscrollbox, fontname, fontsize, aRGB, cursor, ;
                icon, noshow, gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, maximizeprocedure, ;
                minimizeprocedure, initprocedure, ReleaseProcedure, SizeProcedure, ClickProcedure, PaintProcedure, ;
                MouseMoveProcedure, MouseDragProcedure, InteractiveCloseProcedure, NoAutoRelease, nStyle, nStyleEx, ;
                lSplit, lRtl ) CLASS TForm
*------------------------------------------------------------------------------*
Local Formhandle

   If _OOHG_GlobalRTL()
      lRtl := .T.
   ElseIf ValType( lRtl ) != "L"
      lRtl := .F.
   Endif

   ::lRtl := lRtl

   if ! valtype( FormName ) $ "CM"
      FormName := _OOHG_TempWindowName
	endif

   FormName := _OOHG_GetNullName( FormName )

   If _IsWindowDefined( FormName )
      MsgOOHGError( "Window: " + FormName + " already defined. Program Terminated" )
	endif

   if ! valtype( Caption ) $ "CM"
		Caption := ""
	endif

   if valtype( VirtualHeight ) != "N"
      VirtualHeight := 0
	endif

   if valtype( VirtualWidth ) != "N"
      VirtualWidth := 0
   endif

   if Valtype ( aRGB ) != 'A'
      aRGB := { GetRed ( GetSysColor ( COLOR_3DFACE) ) , GetGreen ( GetSysColor ( COLOR_3DFACE) ) , GetBlue ( GetSysColor ( COLOR_3DFACE) ) }
	EndIf

   UnRegisterWindow( FormName )
   ::BrushHandle := RegisterWindow( icon, FormName, aRGB, lSplit )

   nStyle   += WS_POPUP
   If ValType( helpbutton ) == "L" .AND. helpbutton
      nStyleEx += WS_EX_CONTEXTHELP
   Else
      nStyle += if( ValType( nominimize ) != "L" .OR. ! nominimize, WS_MINIMIZEBOX, 0 ) + ;
                if( ValType( nomaximize ) != "L" .OR. ! nomaximize, WS_MAXIMIZEBOX, 0 )
   EndIf
   nStyle    += if( ValType( nosize )     != "L" .OR. ! nosize,    WS_SIZEBOX, 0 ) + ;
                if( ValType( nosysmenu )  != "L" .OR. ! nosysmenu, WS_SYSMENU, 0 ) + ;
                if( ValType( nocaption )  != "L" .OR. ! nocaption, WS_CAPTION, 0 )

   Formhandle := InitWindow( Caption, x, y, w, h, Parent, FormName, nStyle, nStyleEx, lRtl )

   if Valtype( cursor ) $ "CM"
		SetWindowCursor( Formhandle , cursor )
	EndIf

   ::Register( FormHandle, FormName )
   ::ToolTipHandle := InitToolTip( FormHandle, _SetToolTipBalloon() )
   if _OOHG_TooltipBackColor#NIL
        SendMessage( ::ToolTipHandle , TTM_SETTIPBKCOLOR, RGB( _OOHG_TooltipBackColor[1] , _OOHG_TooltipBackColor[2] , _OOHG_TooltipBackColor[3] ), 0)
   endif

   if _OOHG_TooltipForeColor#NIL
      SendMessage( ::ToolTipHandle , TTM_SETTIPTEXTCOLOR, RGB( _OOHG_TooltipForeColor[1] , _OOHG_TooltipForeColor[2] , _OOHG_TooltipForeColor[3] ), 0)
   endif
   // Font Name:
   if ! empty( FontName )
      // Specified font
      ::cFontName := FontName
   else
       // Default
      ::cFontName := _OOHG_DefaultFontName
   endif

   // Font Size:
   if ! empty( FontSize )
      // Specified size
      ::nFontSize := FontSize
   else
       // Default
      ::nFontSize := _OOHG_DefaultFontSize
   endif

   AADD( _OOHG_ActiveForm, Self )

   InitDummy( FormHandle )

   ::nRow    := y
   ::nCol    := x
   ::nWidth  := w
   ::nHeight := h

   ValidateScrolls( Self, .F. )

   ::OnRelease := ReleaseProcedure
   ::OnInit := InitProcedure
   ::OnSize := SizeProcedure
   ::OnClick := ClickProcedure
   ::OnGotFocus := GotFocus
   ::OnLostFocus := LostFocus
   ::OnPaint := PaintProcedure
   ::OnMouseDrag := MouseDragProcedure
   ::OnMouseMove := MouseMoveProcedure
   ::OnScrollUp := ScrollUp
   ::OnScrollDown := ScrollDown
   ::OnScrollLeft := ScrollLeft
   ::OnScrollRight := ScrollRight
   ::OnHScrollBox := HScrollBox
   ::OnVScrollBox := VScrollBox
   ::OnInteractiveClose := InteractiveCloseProcedure
   ::OnMaximize := MaximizeProcedure
   ::OnMinimize := MinimizeProcedure
   ::VirtualHeight := VirtualHeight
   ::VirtualWidth := VirtualWidth
   ::NoShow := NoShow
   ::BackColor := aRGB
   ::AutoRelease := ! NoAutoRelease

Return Self


*--------------------------------------------------
Function _SetToolTipBalloon ( lNewBalloon )
*--------------------------------------------------
Static lBalloon := .F.
Local lOldBalloon := lBalloon

        If lNewBalloon <> Nil
           lBalloon := lNewBalloon
        Endif

return lOldBalloon

*--------------------------------------------------

*------------------------------------------------------------------------------*
METHOD Register( hWnd, cName ) CLASS TForm
*------------------------------------------------------------------------------*
Local mVar
   ::hWnd := hWnd
   ::StartInfo( hWnd )
   ::Name := cName

   AADD( _OOHG_aFormhWnd,    hWnd )
   AADD( _OOHG_aFormObjects, Self )

   mVar := "_" + cName
   Public &mVar. := Self
RETURN Self

*-----------------------------------------------------------------------------*
METHOD Hide() CLASS TForm
*-----------------------------------------------------------------------------*
   If IsWindowVisible( ::hWnd )
      If ::Type == "M"
         If Len( _OOHG_ActiveModal ) == 0 .OR. ATAIL( _OOHG_ActiveModal ):hWnd <> ::hWnd
            MsgOOHGError( "Non top modal windows can't be hide. Program terminated." )
/*
Testing...
         ElseIf ::ActivateCount[ 1 ] > 1 .OR. ! ::ActivateCount == ATAIL( _OOHG_MessageLoops )
            MsgOOHGError( "Modal windows can't be hide when it have sub-windows. Program terminated." )
*/
         EndIf
      EndIf
      HideWindow( ::hWnd )
      ::OnHideFocusManagement()
	EndIf
Return Nil

*-----------------------------------------------------------------------------*
METHOD Show() CLASS TForm
*-----------------------------------------------------------------------------*
   if ::Type == "M"
		// Find Parent

/*
      If Len( _OOHG_ActiveModal ) != 0
         ::Parent := ATAIL( _OOHG_ActiveModal )
		Else
         IF _OOHG_UserWindow != NIL .AND. ascan( _OOHG_aFormhWnd, _OOHG_UserWindow:hWnd ) > 0
            ::Parent := _OOHG_UserWindow
			else
            ::Parent := _OOHG_Main
			endif
		endif
*/
      If ::Parent == NIL .OR. ASCAN( _OOHG_aFormhWnd, ::Parent:hWnd ) == 0
         ::Parent := GetFormObjectByHandle( GetActiveWindow() )
         If ::Parent:hWnd == 0
            If _OOHG_UserWindow != NIL .AND. ascan( _OOHG_aFormhWnd, _OOHG_UserWindow:hWnd ) > 0
               ::Parent := _OOHG_UserWindow
            ElseIf Len( _OOHG_ActiveModal ) != 0 .AND. ascan( _OOHG_aFormhWnd, ATAIL( _OOHG_ActiveModal ):hWnd ) > 0
               ::Parent := ATAIL( _OOHG_ActiveModal )
            Else
               ::Parent := _OOHG_Main
            Endif
         EndIf
      EndIf

      AEVAL( _OOHG_aFormObjects, { |o| if( o:Type != "X" .AND. o:hWnd != ::hWnd .AND. IsWindowEnabled( o:hWnd ), ( AADD( ::LockedForms, o ), DisableWindow( o:hWnd ) ) , ) } )
      AEVAL( ::SplitChildList, { |o| EnableWindow( o:hWnd ) } )

      AADD( _OOHG_ActiveModal, Self )
      EnableWindow( ::hWnd )

      If ! ::SetFocusedSplitChild()
         ::SetActivationFocus()
		endif
	EndIf
   ShowWindow( ::hWnd )
	ProcessMessages()
Return Nil

*-----------------------------------------------------------------------------*
METHOD Activate( lNoStop, oWndLoop ) CLASS TForm
*-----------------------------------------------------------------------------*

   If _OOHG_ThisEventType == 'WINDOW_RELEASE'
      MsgOOHGError("ACTIVATE WINDOW: activate windows within an 'on release' window procedure is not allowed. Program terminated" )
	EndIf

   If Len( _OOHG_ActiveForm ) > 0
      MsgOOHGError("ACTIVATE WINDOW: DEFINE WINDOW Structure is not closed. Program terminated" )
	Endif

   If _OOHG_ThisEventType == 'WINDOW_GOTFOCUS'
      MsgOOHGError("ACTIVATE WINDOW / Activate(): Not allowed in window's GOTFOCUS event procedure. Program terminated" )
	Endif

   If _OOHG_ThisEventType == 'WINDOW_LOSTFOCUS'
      MsgOOHGError("ACTIVATE WINDOW / Activate(): Not allowed in window's LOSTFOCUS event procedure. Program terminated" )
	Endif

	// Main Check

   If _OOHG_Main == nil
      If ::Type != "A"
         MsgOOHGError("ACTIVATE WINDOW: Main Window Must be Activated In First ACTIVATE WINDOW Command. Program terminated" )
		EndIf
	Else
      If ::Type == "A" .AND. ::hWnd != _OOHG_Main:hWnd
         MsgOOHGError("ACTIVATE WINDOW: Main Window Already Active. Program terminated" )
		EndIf
	EndIf

	// Set Main Active Public Flag
   IF ::Type == "A"
      _OOHG_Main := Self
   ENDIF

   If ::Active
      MsgOOHGError("Window: "+ ::Name + " already active. Program terminated" )
   Endif

   // Checks for non-stop window
   IF ValType( lNoStop ) != "L"
      lNoStop := .F.
   ENDIF
   IF ValType( oWndLoop ) != "O"
      oWndLoop := IF( lNoStop, if( ValType( ::Parent ) == "O", ::Parent, _OOHG_Main), Self )
   ENDIF
   ::ActivateCount := oWndLoop:ActivateCount
   ::ActivateCount[ 1 ]++

   IF ::ReBarHandle > 0
      SizeRebar( ::ReBarHandle )
   ENDIF

   // Show window
   if ::Type == "M"

      ::Show()

      ::SetActivationFlag()
      ::ProcessInitProcedure()
      ::RefreshDataControls()

   Else

* Testing... it allows to create non-modal windows when modal windows are active.
* The problem is, what should do when modal window is ... disabled? hidden? WM_CLOSE? WM_DESTROY?
/*
      If Len( _OOHG_ActiveModal ) != 0 .AND. ATAIL( _OOHG_ActiveModal ):Active
         MsgOOHGError("Non Modal Windows can't be activated when a modal window is active. " + ::Name + ". Program Terminated" )
      endif
*/

      If ! ::NoShow
         ShowWindow( ::hWnd )
      EndIf

      ::SetActivationFlag()
      ::ProcessInitProcedure()
      ::RefreshDataControls()

      If ! ::SetFocusedSplitChild()
         ::SetActivationFocus()
      endif

   Endif

   // Starts the Message Loop
   IF ! lNoStop
      ::MessageLoop()
   ENDIF

Return Nil

*-----------------------------------------------------------------------------*
METHOD MessageLoop() CLASS TForm
*-----------------------------------------------------------------------------*
   AADD( _OOHG_MessageLoops, ::ActivateCount )
   _DoMessageLoop()
   _OOHG_DeleteArrayItem( _OOHG_MessageLoops, Len( _OOHG_MessageLoops ) )
   If Len( _OOHG_MessageLoops ) > 0 .AND. ATAIL( _OOHG_MessageLoops )[ 1 ] < 1
      PostQuitMessage( 0 )
   EndIf
Return nil

*-----------------------------------------------------------------------------*
METHOD Release() CLASS TForm
*-----------------------------------------------------------------------------*
Local b

   b := _OOHG_InteractiveClose
   _OOHG_InteractiveClose := 1

   If ! ::Active
      MsgOOHGError("Window: "+ ::Name + " is not active. Program terminated" )
	Endif

   If _OOHG_ThisEventType == 'WINDOW_RELEASE'
      If _OOHG_ThisForm != nil .AND. ::Name == _OOHG_ThisForm:Name
         MsgOOHGError("Release a window in its own 'on release' procedure or release the main window in any 'on release' procedure is not allowed. Program terminated" )
		EndIf
	EndIf

	* If the window to release is the main application window, release all
	* windows command will be executed

   If ::Type == "A"

      If _OOHG_ThisEventType == 'WINDOW_RELEASE'
         MsgOOHGError("Release a window in its own 'on release' procedure or release the main window in any 'on release' procedure is not allowed. Program terminated" )
		Else
			ReleaseAllWindows()
		EndIf

	EndIf

	* Release Window

   if ::Type == "M" .and. ( Len( _OOHG_ActiveModal ) == 0 .OR. ATAIL( _OOHG_ActiveModal ):hWnd <> ::hWnd )

      If IsWindowVisible( ::hWnd )

         MsgOOHGError("Non top modal windows can't be released. Program terminated *" + ::Name + "*" )

      EndIf

	EndIf

   // Checks if the released window still have child windows
   * AEVAL( _OOHG_aFormObjects, { |o| IF( o:Parent != nil .AND. o:Parent:hWnd == ::hWnd, o:Parent := _OOHG_Main, )  } )
   // This window's parent will be child window's parent...
   * Check if ::Parent isn't NIL...
   AEVAL( _OOHG_aFormObjects, { |o| IF( o:Parent != nil .AND. o:Parent:hWnd == ::hWnd, o:Parent := ::Parent, )  } )

   EnableWindow( ::hWnd )
   SendMessage( ::hWnd, WM_SYSCOMMAND, SC_CLOSE, 0 )

   _OOHG_InteractiveClose := b

Return Nil

*-----------------------------------------------------------------------------*
METHOD SetActivationFlag() CLASS TForm
*-----------------------------------------------------------------------------*
   ::Active := .t.
   AEVAL( ::SplitChildList, { |o| o:Active := .t., if( ! o:NoShow, o:Show(), ) } )
Return Nil

*-----------------------------------------------------------------------------*
METHOD SetFocusedSplitChild() CLASS TForm
*-----------------------------------------------------------------------------*
Local SplitFocusFlag := .f.
   AEVAL( ::SplitChildList, { |o| IF( o:Focused, ( o:SetFocus(), SplitFocusFlag := .T. ), ) } )
Return SplitFocusFlag

*-----------------------------------------------------------------------------*
METHOD SetActivationFocus() CLASS TForm
*-----------------------------------------------------------------------------*
Local Sp
   Sp := GetFocus()

   IF ASCAN( ::aControls, { |o| o:IsHandle( Sp ) } ) == 0
      setfocus( GetNextDlgTabItem( ::hWnd , 0 , 0 ) )
   ENDIF
Return nil

*-----------------------------------------------------------------------------*
METHOD ProcessInitProcedure() CLASS TForm
*-----------------------------------------------------------------------------*
   if valtype( ::OnInit )=='B'
      ProcessMessages()
      _PushEventInfo()
      _OOHG_ThisEventType := 'WINDOW_INIT'
      _OOHG_ThisForm := Self
      _OOHG_ThisType := 'W'
      _OOHG_ThisControl := nil
      AADD( _OOHG_MessageLoops, ::ActivateCount )
      Eval( ::OnInit )
      _OOHG_DeleteArrayItem( _OOHG_MessageLoops, Len( _OOHG_MessageLoops ) )
      _PopEventInfo()
   EndIf
   AEVAL( ::SplitChildList, { |o| o:ProcessInitProcedure() } )
Return nil

*-----------------------------------------------------------------------------*
METHOD NotifyIconName( IconName ) CLASS TForm
*-----------------------------------------------------------------------------*
   IF PCOUNT() > 0
      ChangeNotifyIcon( ::hWnd, LoadTrayIcon(GETINSTANCE(), IconName ) , ::NotifyIconTooltip )
      ::cNotifyIconName := IconName
   ENDIF
RETURN ::cNotifyIconName

*-----------------------------------------------------------------------------*
METHOD NotifyIconTooltip( TooltipText ) CLASS TForm
*-----------------------------------------------------------------------------*
   IF PCOUNT() > 0
      ChangeNotifyIcon( ::hWnd, LoadTrayIcon(GETINSTANCE(), ::NotifyIconName ) , TooltipText )
      ::cNotifyIconTooltip := TooltipText
   ENDIF
RETURN ::cNotifyIconTooltip

*------------------------------------------------------------------------------*
METHOD Title( cTitle ) CLASS TForm
*------------------------------------------------------------------------------*
   if valtype( cTitle ) $ "CM"
      SetWindowText( ::hWnd, cTitle )
   endif
Return GetWindowText( ::hWnd )

*------------------------------------------------------------------------------*
METHOD Height( nHeight ) CLASS TForm
*------------------------------------------------------------------------------*
   if valtype( nHeight ) == "N"
      ::SizePos( , , , nHeight )
   endif
Return GetWindowHeight( ::hWnd )

*------------------------------------------------------------------------------*
METHOD Width( nWidth ) CLASS TForm
*------------------------------------------------------------------------------*
   if valtype( nWidth ) == "N"
      ::SizePos( , , nWidth )
   endif
Return GetWindowWidth( ::hWnd )

*------------------------------------------------------------------------------*
METHOD Col( nCol ) CLASS TForm
*------------------------------------------------------------------------------*
   if valtype( nCol ) == "N"
      ::SizePos( , nCol )
   endif
Return GetWindowCol( ::hWnd )

*------------------------------------------------------------------------------*
METHOD Row( nRow ) CLASS TForm
*------------------------------------------------------------------------------*
   if valtype( nRow ) == "N"
      ::SizePos( nRow )
   endif
Return GetWindowRow( ::hWnd )

*------------------------------------------------------------------------------*
METHOD FocusedControl() CLASS TForm
*------------------------------------------------------------------------------*
Local nFocusedControlHandle , nPos
   nFocusedControlHandle := GetFocus()
   nPos := ASCAN( ::aControls, { |o| o:IsHandle( nFocusedControlHandle ) } )
Return if( nPos == 0, "", ::aControls[ nPos ]:Name )

*------------------------------------------------------------------------------*
METHOD Cursor( uValue ) CLASS TForm
*------------------------------------------------------------------------------*
   IF uValue != nil
      SetWindowCursor( ::hWnd, uValue )
   ENDIF
Return nil

#pragma BEGINDUMP
HB_FUNC_STATIC( TFORM_BACKCOLOR )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( hb_pcount() >= 1 )
   {
      oSelf->lBackColor = -1;
      _OOHG_DetermineColor( hb_param( 1, HB_IT_ANY ), &oSelf->lBackColor );
      if( oSelf->BrushHandle )
      {
         DeleteObject( oSelf->BrushHandle );
         oSelf->BrushHandle = 0;
      }
      if( oSelf->hWnd )
      {
         if( oSelf->lBackColor != -1 )
         {
            oSelf->BrushHandle = CreateSolidBrush( oSelf->lBackColor );
            SetClassLong( oSelf->hWnd, GCL_HBRBACKGROUND, ( long ) oSelf->BrushHandle );
         }
         else
         {
            SetClassLong( oSelf->hWnd, GCL_HBRBACKGROUND, ( long )( COLOR_BTNFACE + 1 ) );
         }
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   if( oSelf->lBackColor != -1 )
   {
      hb_reta( 3 );
      hb_stornl( GetRValue( oSelf->lBackColor ), -1, 1 );
      hb_stornl( GetGValue( oSelf->lBackColor ), -1, 2 );
      hb_stornl( GetBValue( oSelf->lBackColor ), -1, 3 );
   }
   else
   {
      hb_ret();
   }
}
#pragma ENDDUMP

*------------------------------------------------------------------------------*
METHOD SizePos( nRow, nCol, nWidth, nHeight ) CLASS TForm
*------------------------------------------------------------------------------*
local actpos:={0,0,0,0}

   IF ::lInternal

      if valtype( nCol ) != "N"
         nCol := ::nCol
      else
         ::nCol := nCol
      endif
      if valtype( nRow ) != "N"
         nRow := ::nRow
      else
         ::nRow := nRow
      endif
      if valtype( nWidth ) != "N"
         nWidth := ::nWidth
      else
         ::nWidth := nWidth
      endif
      if valtype( nHeight ) != "N"
         nHeight := ::nHeight
      else
         ::nHeight := nHeight
      endif
      nCol += ::Parent:ColMargin
      nRow += ::Parent:RowMargin

      ValidateScrolls( Self, .T. )

   Else

      GetWindowRect( ::hWnd, actpos )

      if valtype( nCol ) != "N"
         nCol := actpos[ 1 ]
      endif
      if valtype( nRow ) != "N"
         nRow := actpos[ 2 ]
      endif
      if valtype( nWidth ) != "N"
         nWidth := actpos[ 3 ] - actpos[ 1 ]
      endif
      if valtype( nHeight ) != "N"
         nHeight := actpos[ 4 ] - actpos[ 2 ]
      endif

   ENDIF

Return MoveWindow( ::hWnd , nCol , nRow , nWidth , nHeight , .t. )

*-----------------------------------------------------------------------------*
METHOD RefreshDataControls() CLASS TForm
*-----------------------------------------------------------------------------*

   AEVAL( ::BrowseList, { |o| o:RefreshData() } )

   AEVAL( ::SplitChildList, { |o| o:RefreshDataControls() } )

Return nil

*-----------------------------------------------------------------------------*
METHOD OnHideFocusManagement() CLASS TForm
*-----------------------------------------------------------------------------*

   // Re-enables locked forms
   AEVAL( ::LockedForms, { |o| IF( o:hWnd != -1, EnableWindow( o:hWnd ), ) } )
   ::LockedForms := {}

   If ::Parent == nil

      // _OOHG_Main:SetFocus()

	Else

      ::Parent:SetFocus()

	EndIf

Return nil

*-----------------------------------------------------------------------------*
METHOD DoEvent( bBlock, cEventType ) CLASS TForm
*-----------------------------------------------------------------------------*
Local lRetVal := .F.
	if valtype( bBlock )=='B'
		_PushEventInfo()
      _OOHG_ThisEventType := cEventType
      _OOHG_ThisType := 'W'
      _OOHG_ThisControl := NIL
		lRetVal := Eval( bBlock )
		_PopEventInfo()
	EndIf
Return lRetVal

#pragma BEGINDUMP

// -----------------------------------------------------------------------------
HB_FUNC_STATIC( TFORM_EVENTS )   // METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TForm
// -----------------------------------------------------------------------------
{
   static PHB_SYMB s_Events2 = 0;

   HWND hWnd      = ( HWND )   hb_parnl( 1 );
   UINT message   = ( UINT )   hb_parni( 2 );
   WPARAM wParam  = ( WPARAM ) hb_parni( 3 );
   LPARAM lParam  = ( LPARAM ) hb_parnl( 4 );
   PHB_ITEM pSelf = hb_stackSelfItem();

   switch( message )
   {
      case WM_CONTEXTMENU:
         if( _OOHG_ShowContextMenus )
         {
            PHB_ITEM pControl, pContext;

            SetFocus( ( HWND ) wParam );
            pControl = GetControlObjectByHandle( ( LONG ) wParam );

            // Check if control have context menu
            _OOHG_Send( pControl, s_ContextMenu );
            hb_vmSend( 0 );
            pContext = hb_param( -1, HB_IT_OBJECT );
            // Check if form have context menu
            if( ! pContext )
            {
               // _OOHG_Send( pSelf, s_ContextMenu );
               _OOHG_Send( pSelf, s_ContextMenu );
               hb_vmSend( 0 );
               pContext = hb_param( -1, HB_IT_OBJECT );
            }

            // If there's a context menu, show it
            if( pContext )
            {
/*
               int iRow, iCol;

               // _OOHG_MouseRow := HIWORD( lParam ) - ::RowMargin
               _OOHG_Send( pSelf, s_RowMargin );
               hb_vmSend( 0 );
               iRow = HIWORD( lParam ) - hb_parni( -1 );
               // _OOHG_MouseCol := LOWORD( lParam ) - ::ColMargin
               _OOHG_Send( pSelf, s_ColMargin );
               hb_vmSend( 0 );
               iCol = LOWORD( lParam ) - hb_parni( -1 );
*/
               // HMENU
               _OOHG_Send( pContext, s_hWnd );
               hb_vmSend( 0 );
               TrackPopupMenu( ( HMENU ) hb_parnl( -1 ), 0, ( int ) LOWORD( lParam ), ( int ) HIWORD( lParam ), 0, hWnd, 0 );
               PostMessage( hWnd, WM_NULL, 0, 0 );
               hb_ret();
            }
            else
            {
               hb_ret();
            }
         }
         else
         {
            hb_ret();
         }
         break;

      default:
         if( ! s_Events2 )
         {
            s_Events2 = hb_dynsymSymbol( hb_dynsymFind( "_OOHG_TFORM_EVENTS2" ) );
         }
         hb_vmPushSymbol( s_Events2 );
         hb_vmPushNil();
         hb_vmPush( pSelf );
         hb_vmPushLong( ( LONG ) hWnd );
         hb_vmPushLong( message );
         hb_vmPushLong( wParam );
         hb_vmPushLong( lParam );
         hb_vmDo( 5 );
         break;
   }
}

#pragma ENDDUMP

*-----------------------------------------------------------------------------*
FUNCTION _OOHG_TForm_Events2( Self, hWnd, nMsg, wParam, lParam ) // CLASS TForm
*-----------------------------------------------------------------------------*
Local i, aPos, NextControlHandle, mVar, xRetVal
Local oWnd, oCtrl
* Local hWnd := ::hWnd

	do case

        ***********************************************************************
	case nMsg == WM_HOTKEY
        ***********************************************************************

		* Process HotKeys

      i := ASCAN( ::aHotKeys, { |a| a[ HOTKEY_ID ] == wParam } )

      If i > 0

         _OOHG_EVAL( ::aHotKeys[ i ][ HOTKEY_ACTION ] )

      EndIf

        ***********************************************************************
	case nMsg == WM_MOUSEWHEEL
        ***********************************************************************

      oWnd := GetFormObjectByHandle( GetFocus() )

      IF oWnd:hWnd == 0

         oCtrl := GetControlObjectByHandle( GetFocus() )

         IF oCtrl:hWnd != 0

            oWnd := oCtrl:Parent

         ENDIF

      ENDIF

      If oWnd:hWnd != 0 .AND. oWnd:RangeHeight > 0

			If HIWORD(wParam) == 120
				if GetScrollPos(hwnd,SB_VERT) < 20
					SetScrollPos ( hwnd , SB_VERT , 0 , 1 )
				Else
					SendMessage ( hwnd , WM_VSCROLL , SB_PAGEUP , 0 )
				endif
			Else
				if GetScrollPos(hwnd,SB_VERT) >= GetScrollRangeMax ( hwnd , SB_VERT ) - 10
					SetScrollPos ( hwnd , SB_VERT , GetScrollRangeMax ( hwnd , SB_VERT ) , 1 )
				else
					SendMessage ( hwnd , WM_VSCROLL , SB_PAGEDOWN , 0 )
				endif
			EndIf

		EndIf

        ***********************************************************************
	case nMsg == WM_ACTIVATE
        ***********************************************************************

		if LoWord(wparam) == 0
*****      Self := GetFormObjectByHandle( hWnd )

         aeval( ::aHotKeys, { |a| ReleaseHotKey( ::hWnd, a[ HOTKEY_ID ] ) } )

         ::LastFocusedControl := GetFocus()

         ::DoEvent( ::OnLostFocus, 'WINDOW_LOSTFOCUS' )

		Else

         if Ascan( _OOHG_aFormhWnd, hWnd ) > 0
            UpdateWindow( hWnd )
			EndIf

		EndIf

        ***********************************************************************
	case nMsg == WM_SETFOCUS
        ***********************************************************************

*****      Self := GetFormObjectByHandle( hWnd )

         If ::Active .and. ::Type != "X"
            _OOHG_UserWindow := Self
			EndIf

         aeval( ::aHotKeys, { |a| ReleaseHotKey( ::hWnd, a[ HOTKEY_ID ] ) } )

         aeval( ::aHotKeys, { |a| InitHotKey( ::hWnd, a[ HOTKEY_MOD ], a[ HOTKEY_KEY ], a[ HOTKEY_ID ] ) } )

         ::DoEvent( ::OnGotFocus, 'WINDOW_GOTFOCUS' )

         if ! empty( ::LastFocusedControl )
            SetFocus( ::LastFocusedControl )
         endif

        ***********************************************************************
	case nMsg == WM_HELP
        ***********************************************************************

      HelpTopic( GetControlObjectByHandle( GetHelpData( lParam ) ):HelpId , 2 )

        ***********************************************************************
	case nMsg == WM_VSCROLL
        ***********************************************************************

      if lParam == 0

			* Vertical ScrollBar Processing

         if ::RangeHeight > 0

            If ::ReBarHandle > 0
               MsgOOHGError("SplitBox's Parent Window Can't Be a 'Virtual Dimensioned' Window (Use 'Virtual Dimensioned' SplitChild Instead). Program terminated" )
				EndIf

				If LoWord(wParam) == SB_LINEDOWN

               ::RowMargin := - ( GetScrollPos(hwnd,SB_VERT) + 1 )
               SetScrollPos ( hwnd , SB_VERT , - ::RowMargin , 1 )

				ElseIf LoWord(wParam) == SB_LINEUP

               ::RowMargin := - ( GetScrollPos(hwnd,SB_VERT) - 1 )
               SetScrollPos ( hwnd , SB_VERT , - ::RowMargin , 1 )

				ElseIf LoWord(wParam) == SB_PAGEUP

               ::RowMargin := - ( GetScrollPos(hwnd,SB_VERT) - 20 )
               SetScrollPos ( hwnd , SB_VERT , - ::RowMargin , 1 )

				ElseIf LoWord(wParam) == SB_PAGEDOWN

               ::RowMargin := - ( GetScrollPos(hwnd,SB_VERT) + 20 )
               SetScrollPos ( hwnd , SB_VERT , - ::RowMargin , 1 )

				ElseIf LoWord(wParam) == SB_THUMBPOSITION

               ::RowMargin := - HIWORD(wParam)
               SetScrollPos ( hwnd , SB_VERT , - ::RowMargin , 1 )

				EndIf

				* Control Repositioning

				If LoWord(wParam) == SB_THUMBPOSITION .Or. LoWord(wParam) == SB_LINEDOWN .Or. LoWord(wParam) == SB_LINEUP .or. LoWord(wParam) == SB_PAGEUP .or. LoWord(wParam) == SB_PAGEDOWN

               // AEVAL( ::aControls, { |o| o:SizePos() } )
               AEVAL( ::aControls, { |o| If( o:Container == nil, o:SizePos(), ) } )
               AEVAL( ::SplitChildList, { |o| o:SizePos() } )

					ReDrawWindow ( hwnd )

				EndIf

			EndIf

			If LoWord(wParam) == SB_LINEDOWN
            ::DoEvent( ::OnScrollDown, '' )
			ElseIf LoWord(wParam) == SB_LINEUP
            ::DoEvent( ::OnScrollUp, '' )
			ElseIf LoWord(wParam) == SB_THUMBPOSITION ;
				.or. ;
				LoWord(wParam) == SB_PAGEUP ;
				.or. ;
				LoWord(wParam) == SB_PAGEDOWN

            ::DoEvent( ::OnVScrollBox, '' )

			EndIf

      Else

         Return GetControlObjectByHandle( lParam ):Events_VScroll( wParam )

		EndIf



        ***********************************************************************
	case nMsg == WM_TASKBAR
        ***********************************************************************

*****      Self := GetFormObjectByHandle( hWnd )

		If wParam == ID_TASKBAR .and. lParam # WM_MOUSEMOVE
			aPos := GETCURSORPOS()

			do case

				case lParam == WM_LBUTTONDOWN

                  ::DoEvent( ::NotifyIconLeftClick, '' )

				case lParam == WM_RBUTTONDOWN

               if _OOHG_ShowContextMenus()

                  if ::NotifyMenuHandle != 0
                     TrackPopupMenu( ::NotifyMenuHandle, aPos[2] , aPos[1] , hWnd )
                  Endif

					EndIf

			endcase
		EndIf

        ***********************************************************************
	case nMsg == WM_NEXTDLGCTL
        ***********************************************************************

			If Wparam == 0

            NextControlHandle := GetNextDlgTabItem ( GetActiveWindow() , GetFocus() , 0 )

			Else

            NextControlHandle := GetNextDlgTabItem ( GetActiveWindow() , GetFocus() , 1 )

			EndIf

         oCtrl := GetControlObjectByHandle( NextControlHandle )

         if oCtrl:hWnd == NextControlHandle

            oCtrl:SetFocus()

         else

				setfocus( NextControlHandle )

         endif

        ***********************************************************************
	case nMsg == WM_HSCROLL
        ***********************************************************************

      i := aScan( _OOHG_aFormhWnd, hWnd )
*****      Self := GetFormObjectByHandle( hWnd )

		if i > 0

			* Horizontal ScrollBar Processing

         if ::RangeWidth > 0 .And. lParam == 0

            If ::ReBarHandle > 0
               MsgOOHGError("SplitBox's Parent Window Can't Be a 'Virtual Dimensioned' Window (Use 'Virtual Dimensioned' SplitChild Instead). Program terminated" )
				EndIf

				If LoWord(wParam) == SB_LINERIGHT

               ::ColMargin := - ( GetScrollPos(hwnd,SB_HORZ) + 1 )
               SetScrollPos ( hwnd , SB_HORZ , - ::ColMargin , 1 )

				ElseIf LoWord(wParam) == SB_LINELEFT

               ::ColMargin := - ( GetScrollPos(hwnd,SB_HORZ) - 1 )
               SetScrollPos ( hwnd , SB_HORZ , - ::ColMargin , 1 )

				ElseIf LoWord(wParam) == SB_PAGELEFT

               ::ColMargin := - ( GetScrollPos(hwnd,SB_HORZ) - 20 )
               SetScrollPos ( hwnd , SB_HORZ , - ::ColMargin , 1 )

				ElseIf LoWord(wParam) == SB_PAGERIGHT

               ::ColMargin := - ( GetScrollPos(hwnd,SB_HORZ) + 20 )
               SetScrollPos ( hwnd , SB_HORZ , - ::ColMargin , 1 )

				ElseIf LoWord(wParam) == SB_THUMBPOSITION

               ::ColMargin := - HIWORD(wParam)
               SetScrollPos ( hwnd , SB_HORZ , - ::ColMargin , 1 )

				EndIf

				* Control Repositioning

				If LoWord(wParam) == SB_THUMBPOSITION .Or. LoWord(wParam) == SB_LINELEFT .Or. LoWord(wParam) == SB_LINERIGHT .OR. LoWord(wParam) == SB_PAGELEFT	.OR. LoWord(wParam) == SB_PAGERIGHT

               // AEVAL( ::aControls, { |o| o:SizePos() } )
               AEVAL( ::aControls, { |o| If( o:Container == nil, o:SizePos(), ) } )
               AEVAL( ::SplitChildList, { |o| o:SizePos } )

					RedrawWindow ( hwnd )

				EndIf

			EndIf

			If LoWord(wParam) == SB_LINERIGHT

            ::DoEvent( ::OnScrollRight, '' )

			ElseIf LoWord(wParam) == SB_LINELEFT

            ::DoEvent( ::OnScrollLeft, '' )

			ElseIf	LoWord(wParam) == SB_THUMBPOSITION ;
				.or. ;
				LoWord(wParam) == SB_PAGELEFT ;
				.or. ;
				LoWord(wParam) == SB_PAGERIGHT

            ::DoEvent( ::OnHScrollBox, '' )

			EndIf

		EndIf

      oCtrl := GetControlObjectByHandle( lParam )
			If LoWord (wParam) == TB_ENDTRACK
            oCtrl:DoEvent( oCtrl:OnChange )
			EndIf

        ***********************************************************************
	case nMsg == WM_PAINT
        ***********************************************************************

         // WHY ALL WINDOWS?????
         AEVAL( _OOHG_aFormObjects, { |o| IF( o:Type == "X", AEVAL( o:GraphTasks, { |b| EVAL( b ) } ), ) } )

*****      Self := GetFormObjectByHandle( hWnd )

         AEVAL( ::GraphTasks, { |b| EVAL( b ) } )

         DefWindowProc( hWnd, nMsg, wParam, lParam )

         ::DoEvent( ::OnPaint, '' )

         return 1

        ***********************************************************************
	case nMsg == WM_LBUTTONDOWN
        ***********************************************************************

      _OOHG_MouseRow := HIWORD( lParam ) - ::RowMargin
      _OOHG_MouseCol := LOWORD( lParam ) - ::ColMargin

*****      Self := GetFormObjectByHandle( hWnd )

         ::DoEvent( ::OnClick, '' )

        ***********************************************************************
	case nMsg == WM_LBUTTONUP
        ***********************************************************************

      // Dummy...
      // _OOHG_MouseState := 0

        ***********************************************************************
	case nMsg == WM_MOUSEMOVE
        ***********************************************************************

      _OOHG_MouseRow := HIWORD(lParam) - ::RowMargin
      _OOHG_MouseCol := LOWORD(lParam) - ::ColMargin

         I := Ascan ( _OOHG_aFormhWnd, hWnd )
*****      Self := GetFormObjectByHandle( hWnd )

		if wParam == MK_LBUTTON
            ::DoEvent( ::OnMouseDrag, '' )
		Else
            ::DoEvent( ::OnMouseMove, '' )
		Endif

        ***********************************************************************
	case nMsg == WM_TIMER
        ***********************************************************************

      oCtrl := GetControlObjectById( wParam, hWnd )

      oCtrl:DoEvent( oCtrl:OnClick )

        ***********************************************************************
	case nMsg == WM_SIZE
        ***********************************************************************

      ValidateScrolls( Self, .T. )

      // If _OOHG_Main != nil
      If ::Active

         If wParam == SIZE_MAXIMIZED

            ::DoEvent( ::OnMaximize, '' )

         ElseIf wParam == SIZE_MINIMIZED

            ::DoEvent( ::OnMinimize, '' )

         Else

            ::DoEvent( ::OnSize, '' )

			EndIf

      EndIf

      If ::ReBarHandle > 0
         SizeRebar( ::ReBarHandle )
         RedrawWindow( ::ReBarHandle )
		EndIf

      // AEVAL( ::aControls, { |o| o:Events_Size() } )
      AEVAL( ::aControls, { |o| If( o:Container == nil, o:Events_Size(), ) } )

        ***********************************************************************
	case nMsg == WM_COMMAND
        ***********************************************************************

      IF wParam == 1

         // Enter key

         Return GetControlObjectByHandle( GetFocus() ):Events_Enter()

      ENDIF

      IF ( oCtrl := GetControlObjectById( LoWord( wParam ), hWnd ) ):Id != 0

         // By Id

         // From MENU

//         IF HiWord(wParam) == 0 .And. oCtrl:Type = "MENU"

//         If oCtrl:Type = "TOOLBUTTON"

         oCtrl:DoEvent( oCtrl:OnClick )

//         EndIf

      ElseIf ( oCtrl := GetControlObjectByHandle( lParam ) ):hWnd != 0

         // By handle

         Return oCtrl:Events_Command( wParam )

      ElseIf HIWORD( wParam ) == 1

         // From accelerator
*         Return GetControlObjectByHandle( lParam ):Events_Accelerator( wParam )

      ENDIF

        ***********************************************************************
	case nMsg == WM_CLOSE
        ***********************************************************************

      * Process Interactive Close Event / Setting

      If ValType ( ::OnInteractiveClose ) == 'B'
         xRetVal := ::DoEvent( ::OnInteractiveClose, 'WINDOW_ONINTERACTIVECLOSE' )
         If ValType( xRetVal ) == 'L' .AND. ! xRetVal
            Return (1)
         EndIf
      EndIf

      Do Case
         Case _OOHG_InteractiveClose == 0
            MsgStop( _OOHG_Messages( 1, 3 ) )
				Return (1)
         Case _OOHG_InteractiveClose == 2
            If ! MsgYesNo ( _OOHG_Messages( 1, 1 ), _OOHG_Messages( 1, 2 ) )
					Return (1)
				EndIf
         Case _OOHG_InteractiveClose == 3
            if ::Type == "A"
               If ! MsgYesNo ( _OOHG_Messages( 1, 1 ), _OOHG_Messages( 1, 2 ) )
						Return (1)
					EndIf
				EndIf
      EndCase

      * Process AutoRelease Property

      if ! ::AutoRelease
         ::Hide()
         Return (1)
      EndIf

      * If Not AutoRelease Destroy Window

      if ::Type == "A"
         ReleaseAllWindows()
      Else
         if valtype( ::OnRelease ) == 'B'
            _OOHG_InteractiveCloseStarted := .T.
            ::DoEvent( ::OnRelease, 'WINDOW_RELEASE' )
         EndIf

/*
Testing...
         If ::Type == "M" .AND. ::ActivateCount[ 1 ] > 1 .OR. ! ::ActivateCount == ATAIL( _OOHG_MessageLoops )
            MsgOOHGError( "Modal windows MUST not be closed while it have sub-windows. Program terminated." )
         EndIf
*/

         ::OnHideFocusManagement()

      EndIf

        ***********************************************************************
	case nMsg == WM_DESTROY
        ***********************************************************************

      // Remove Child Controls
      DO WHILE LEN( ::aControls ) > 0
         ::aControls[ 1 ]:Release()
      ENDDO

      // Delete Notify icon
      ShowNotifyIcon( ::hWnd, .F. , 0, "" )
      DeleteObject( ::NotifyMenuHandle )

      // Update Form Index Variable
      If ! Empty( ::Name )
         mVar := '_' + ::Name
         if type( mVar ) != 'U'
            __MVPUT( mVar , 0 )
         EndIf
      EndIf

      // Verify if window was multi-activated
      ::ActivateCount[ 1 ]--
      If Len( _OOHG_MessageLoops ) > 0
         If ATAIL( _OOHG_MessageLoops )[ 1 ] < 1
            PostQuitMessage( 0 )
         Endif
      ElseIf ::ActivateCount[ 1 ] < 1
         PostQuitMessage( 0 )
      Endif

      // Removes WINDOW from the array
      i := Ascan( _OOHG_aFormhWnd, hWnd )
      IF i > 0
         _OOHG_DeleteArrayItem( _OOHG_aFormhWnd, I )
         _OOHG_DeleteArrayItem( _OOHG_aFormObjects, I )
      ENDIF

      // Eliminates active modal
      IF Len( _OOHG_ActiveModal ) != 0 .AND. ATAIL( _OOHG_ActiveModal ):hWnd == ::hWnd
         _OOHG_DeleteArrayItem( _OOHG_ActiveModal, Len( _OOHG_ActiveModal ) )
      ENDIF

      ::Super:Release()

      ::Active := .F.

      _OOHG_InteractiveCloseStarted := .F.

        ***********************************************************************
   otherwise
        ***********************************************************************

      return ::Super:Events( hWnd, nMsg, wParam, lParam )

	endcase

return nil

*-----------------------------------------------------------------------------*
Procedure ValidateScrolls( Self, lMove )
*-----------------------------------------------------------------------------*
Local hWnd, nVirtualWidth, nVirtualHeight
Local aRect, w, h, hscroll, vscroll
   // Initializes variables
   hWnd := ::hWnd
   nVirtualWidth := ::VirtualWidth
   nVirtualHeight := ::VirtualHeight
   If ValType( lMove ) != "L"
      lMove := .F.
   EndIf
   vscroll := hscroll := .F.
   aRect := ARRAY( 4 )
   GetClientRect( hWnd, aRect )
   w := aRect[ 3 ] - aRect[ 1 ]
   h := aRect[ 4 ] - aRect[ 2 ]
   ::RangeWidth := ::RangeHeight := 0

   // Checks if there's space on the window
   If h < nVirtualHeight
      ::RangeHeight := nVirtualHeight - h
      vscroll := .T.
      w -= GetVScrollBarWidth()
   EndIf
   If w < nVirtualWidth
      ::RangeWidth := nVirtualWidth - w
      hscroll := .T.
      h -= GetHScrollBarHeight()
   EndIf
   If h < nVirtualHeight .AND. ! vscroll
      ::RangeHeight := nVirtualHeight - h
      vscroll := .T.
      w -= GetVScrollBarWidth()
   EndIf

   // Shows/hides scroll bars
   _SetScroll( hWnd, hscroll, vscroll )

   // Verifies there's no "extra" space derived from resize
   If vscroll
      SetScrollRange( hWnd, SB_VERT, 0, ::RangeHeight, 1 )
      If ::RangeHeight < ( - ::RowMargin )
         ::RowMargin := - ::RangeHeight
         SetScrollPos( hWnd, SB_VERT, ::RangeHeight, 1 )
      Else
         vscroll := .F.
      EndIf
   ElseIf nVirtualHeight > 0 .AND. ::RowMargin != 0
      ::RowMargin := 0
      vscroll := .T.
   EndIf
   If hscroll
      SetScrollRange( hWnd, SB_HORZ, 0, ::RangeWidth, 1 )
      If ::RangeWidth < ( - ::ColMargin )
         ::ColMargin := - ::RangeWidth
         SetScrollPos( hWnd, SB_HORZ, ::RangeWidth, 1 )
      Else
         hscroll := .F.
      EndIf
   ElseIf nVirtualWidth > 0 .AND. ::ColMargin != 0
      ::ColMargin := 0
      hscroll := .T.
   EndIf

   // Reubicates controls
   If lMove .AND. ( vscroll .OR. hscroll )
      AEVAL( ::aControls, { |o| If( o:Container == nil, o:SizePos(), ) } )
      AEVAL( ::SplitChildList, { |o| o:SizePos } )
      RedrawWindow( hWnd )
   EndIf
Return

*-----------------------------------------------------------------------------*
Procedure _KillAllKeys()
*-----------------------------------------------------------------------------*
Local I, hWnd
   FOR I := 1 TO LEN( _OOHG_aFormhWnd )
      hWnd := _OOHG_aFormObjects[ I ]:hWnd
      AEVAL( _OOHG_aFormObjects[ I ]:aHotKeys, { |a| ReleaseHotKey( hWnd, a[ HOTKEY_ID ] ) } )
   NEXT
Return

// Initializes C variables
*-----------------------------------------------------------------------------*
Procedure _OOHG_Init_C_Vars()
*-----------------------------------------------------------------------------*
   TForm()
   _OOHG_Init_C_Vars_C_Side( _OOHG_aFormhWnd, _OOHG_aFormObjects )
Return

*-----------------------------------------------------------------------------*
Function GetFormObject( FormName )
*-----------------------------------------------------------------------------*
Local mVar
   mVar := '_' + FormName
Return IF( Type( mVar ) == "O", &mVar, TForm() )

*-----------------------------------------------------------------------------*
Function GetWindowType( FormName )
*-----------------------------------------------------------------------------*
Return GetFormObject( FormName ):Type

*-----------------------------------------------------------------------------*
Function _IsWindowActive ( FormName )
*-----------------------------------------------------------------------------*
Return GetFormObject( FormName ):Active

*-----------------------------------------------------------------------------*
Function _IsWindowDefined ( FormName )
*-----------------------------------------------------------------------------*
Local mVar
mVar := '_' + FormName
Return ( Type( mVar ) == "O" )

*-----------------------------------------------------------------------------*
Function GetFormName( FormName )
*-----------------------------------------------------------------------------*
Return GetFormObject( FormName ):Name

*-----------------------------------------------------------------------------*
Function GetFormToolTipHandle( FormName )
*-----------------------------------------------------------------------------*
Return GetFormObject( FormName ):ToolTipHandle

*-----------------------------------------------------------------------------*
Function GetFormHandle( FormName )
*-----------------------------------------------------------------------------*
Return GetFormObject( FormName ):hWnd

*-----------------------------------------------------------------------------*
Function ReleaseAllWindows()
*-----------------------------------------------------------------------------*
Local i, oWnd

   If _OOHG_ThisEventType == 'WINDOW_RELEASE'
      MsgOOHGError("Release a window in its own 'on release' procedure or release the main window in any 'on release' procedure is not allowed. Program terminated" )

	EndIf

   For i = 1 to len (_OOHG_aFormhWnd)
      oWnd := _OOHG_aFormObjects[ i ]
      if oWnd:Active

         oWnd:DoEvent( oWnd:OnRelease, 'WINDOW_RELEASE' )

         if .Not. Empty ( oWnd:NotifyIconName )
            oWnd:NotifyIconName := ''
            ShowNotifyIcon( oWnd:hWnd, .F., NIL, NIL )
			EndIf

		Endif

      aeval( oWnd:aHotKeys, { |a| ReleaseHotKey( oWnd:hWnd, a[ HOTKEY_ID ] ) } )

	Next i

	dbcloseall()

   ExitProcess(0)

Return Nil

*-----------------------------------------------------------------------------*
Function _ReleaseWindow( FormName )
*-----------------------------------------------------------------------------*
Return GetFormObject( FormName ):Release()

*-----------------------------------------------------------------------------*
Function _ShowWindow( FormName )
*-----------------------------------------------------------------------------*
Return GetFormObject( FormName ):Show()

*-----------------------------------------------------------------------------*
Function _HideWindow( FormName )
*-----------------------------------------------------------------------------*
Return GetFormObject( FormName ):Hide()

*-----------------------------------------------------------------------------*
Function _CenterWindow ( FormName )
*-----------------------------------------------------------------------------*
Return GetFormObject( FormName ):Center()

*-----------------------------------------------------------------------------*
Function _RestoreWindow ( FormName )
*-----------------------------------------------------------------------------*
Return GetFormObject( FormName ):Restore()

*-----------------------------------------------------------------------------*
Function _MaximizeWindow ( FormName )
*-----------------------------------------------------------------------------*
Return GetFormObject( FormName ):Maximize()

*-----------------------------------------------------------------------------*
Function _MinimizeWindow ( FormName )
*-----------------------------------------------------------------------------*
Return GetFormObject( FormName ):Minimize()

*-----------------------------------------------------------------------------*
Function _SetWindowSizePos( FormName , row , col , width , height )
*-----------------------------------------------------------------------------*
Return GetFormObject( FormName ):SizePos( row , col , width , height )

*-----------------------------------------------------------------------------*
Function _DefineWindow( FormName, Caption, x, y, w, h ,nominimize ,nomaximize ,nosize ,nosysmenu, nocaption , StatusBar , StatusText ,initprocedure ,ReleaseProcedure , MouseDragProcedure ,SizeProcedure , ClickProcedure , MouseMoveProcedure, aRGB , PaintProcedure , noshow , topmost , main , icon , child , fontname , fontsize , NotifyIconName , NotifyIconTooltip , NotifyIconLeftClick , GotFocus , LostFocus , virtualheight , VirtualWidth , scrollleft , scrollright , scrollup , scrolldown , hscrollbox , vscrollbox , helpbutton , maximizeprocedure , minimizeprocedure , cursor , NoAutoRelease , InteractiveCloseProcedure, lRtl )
*-----------------------------------------------------------------------------*
Local i , Parent
Local Self := TForm()
Local nStyle   := 0
Local nStyleEx := 0

* Unused Parameters
StatusBar := Nil
StatusText := Nil

   i := ASCAN( _OOHG_aFormObjects, { |o| o:Type == "A" } )

	if Main

		if i > 0
         MsgOOHGError("Main Window Already Defined. Program Terminated" )
		Endif

		if Child == .T.
         MsgOOHGError("Child and Main Clauses Can't Be Used Simultaneously. Program Terminated" )
		Endif

		if NoAutoRelease == .T.
         MsgOOHGError("NOAUTORELEASE and MAIN Clauses Can't Be Used Simultaneously. Program Terminated" )
		Endif

	Else

      i := ASCAN( _OOHG_aFormObjects, { |o| o:Type == "A" } )

		if i <= 0
         MsgOOHGError("Main Window Not Defined. Program Terminated" )
		Endif

		If .Not. Empty (NotifyIconName)
         MsgOOHGError("Notification Icon Allowed Only in Main Window. Program Terminated" )
		endif

      if child == .T.
         Parent := _OOHG_Main:hWnd
      Else
         Parent := 0
      endif

	EndIf

   nStyleEx += if( ValType( topmost ) == "L" .AND. topmost, WS_EX_TOPMOST, 0 )

   ::Define2( FormName, Caption, x, y, w, h, Parent, helpbutton, nominimize, nomaximize, nosize, nosysmenu, ;
              nocaption, virtualheight, virtualwidth, hscrollbox, vscrollbox, fontname, fontsize, aRGB, cursor, ;
              icon, noshow, gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, maximizeprocedure, ;
              minimizeprocedure, initprocedure, ReleaseProcedure, SizeProcedure, ClickProcedure, PaintProcedure, ;
              MouseMoveProcedure, MouseDragProcedure, InteractiveCloseProcedure, NoAutoRelease, nStyle, nStyleEx, ;
              .F., lRtl )

	if valtype(NotifyIconName) == "U"
		NotifyIconName := ""
	Else
      ShowNotifyIcon( ::hWnd, .T. , LoadTrayIcon(GETINSTANCE(), NotifyIconName ), NotifyIconTooltip )
	endif

   ::Type := iif ( Main == .t. , "A" , iif( Child == .t., "C", "S" ) )
   ::NotifyIconName := NotifyIconName
   ::NotifyIconToolTip := NotifyIconToolTip
   ::NotifyIconLeftClick := NotifyIconLeftClick

	if Main
      _OOHG_Main := Self
   EndIf

Return Self

*-----------------------------------------------------------------------------*
Function _DefineModalWindow( FormName, Caption, x, y, w, h, Parent ,nosize ,nosysmenu, nocaption , StatusBar , StatusText ,InitProcedure, ReleaseProcedure , MouseDragProcedure , SizeProcedure , ClickProcedure , MouseMoveProcedure, aRGB , PaintProcedure , icon , FontName , FontSize , GotFocus , LostFocus , virtualheight , VirtualWidth , scrollleft , scrollright , scrollup , scrolldown  , hscrollbox , vscrollbox , helpbutton , cursor , noshow  , NoAutoRelease  , InteractiveCloseProcedure, lRtl )
*-----------------------------------------------------------------------------*
Local Self := TForm()
Local nStyle   := 0
Local nStyleEx := 0

* Unused Parameters
StatusBar := Nil
StatusText := Nil
Parent := nil

   if ASCAN( _OOHG_aFormObjects, { |o| o:Type == "A" } ) == 0
      MsgOOHGError("Main Window Not Defined. Program Terminated" )
	Endif

   Parent := GetFormObjectByHandle( GetActiveWindow() )
   IF Parent:hWnd == 0
      If _OOHG_UserWindow != NIL .AND. ascan( _OOHG_aFormhWnd, _OOHG_UserWindow:hWnd ) > 0
         Parent := _OOHG_UserWindow
      ElseIf Len( _OOHG_ActiveModal ) != 0 .AND. ascan( _OOHG_aFormhWnd, ATAIL( _OOHG_ActiveModal ):hWnd ) > 0
         Parent := ATAIL( _OOHG_ActiveModal )
      Else
         Parent := _OOHG_Main
      Endif
   ENDIF

   ::Define2( FormName, Caption, x, y, w, h, Parent:hWnd, helpbutton, .T., .T., nosize, nosysmenu, ;
              nocaption, virtualheight, virtualwidth, hscrollbox, vscrollbox, fontname, fontsize, aRGB, cursor, ;
              icon, noshow, gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, nil, ;
              nil, initprocedure, ReleaseProcedure, SizeProcedure, ClickProcedure, PaintProcedure, ;
              MouseMoveProcedure, MouseDragProcedure, InteractiveCloseProcedure, NoAutoRelease, nStyle, nStyleEx, ;
              .T., lRtl )

   ::Type := "M"
   ::Parent := Parent

Return Self

*-----------------------------------------------------------------------------*
Function _DefineSplitChildWindow( FormName , w , h , break , grippertext  , nocaption , title , fontname , fontsize , gotfocus , lostfocus , virtualheight , VirtualWidth , Focused , scrollleft , scrollright , scrollup , scrolldown  , hscrollbox , vscrollbox , cursor , lRtl )
*-----------------------------------------------------------------------------*
Local nStyle   := 0
Local nStyleEx := WS_EX_STATICEDGE + WS_EX_TOOLWINDOW
Local Self := TForm()
Local oParent

   if ASCAN( _OOHG_aFormObjects, { |o| o:Type == "A" } ) == 0
      MsgOOHGError("Main Window Not Defined. Program Terminated" )
	Endif

   If _OOHG_ActiveSplitBox == .F.
      MsgOOHGError("SplitChild Windows Can be Defined Only Inside SplitBox. Program terminated" )
	EndIf

   oParent := ATail( _OOHG_ActiveForm )

   ::Define2( FormName, Title, 0, 0, w, h, 0, .F., .T., .T., .T., .T., ;
              nocaption, virtualheight, virtualwidth, hscrollbox, vscrollbox, fontname, fontsize, nil, cursor, ;
              "", .F., gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, nil, ;
              nil, nil, nil, nil, nil, nil, ;
              nil, nil, nil, .F., nStyle, nStyleEx, ;
              .T., lRtl )

   if _OOHG_SplitForceBreak .AND. ! _OOHG_ActiveSplitBoxInverted
      Break := .T.
   endif
   _OOHG_SplitForceBreak := .F.

   AddSplitBoxItem ( ::hWnd, oParent:ReBarHandle, w , break , grippertext ,  ,  , _OOHG_ActiveSplitBoxInverted )

   ::Type := "X"
   ::Parent := oParent
   ::Focused := Focused

   aAdd ( oParent:SplitChildList, Self )

Return Self

*-----------------------------------------------------------------------------*
Function _DefineSplitBox( ParentForm, bottom, inverted, lRtl )
*-----------------------------------------------------------------------------*
Local cParentForm, Controlhandle

   If _OOHG_GlobalRTL()
      lRtl := .T.
   ElseIf ValType( lRtl ) != "L"
      lRtl := .F.
   Endif

   if LEN( _OOHG_ActiveForm ) > 0
      ParentForm := ATail( _OOHG_ActiveForm ):Name
	endif
   if LEN( _OOHG_ActiveFrame ) > 0
      MsgOOHGError("SPLITBOX can't be defined inside Tab control. Program terminated" )
	EndIf

	If .Not. _IsWindowDefined (ParentForm)
      MsgOOHGError("Window: "+ ParentForm + " is not defined. Program terminated" )
	Endif

   If ATail( _OOHG_ActiveForm ):Type == "X"
      MsgOOHGError("SplitBox Can't Be Defined inside SplitChild Windows. Program terminated" )
	EndIf

   If _OOHG_ActiveSplitBox == .T.
      MsgOOHGError("SplitBox Controls Can't Be Nested. Program terminated" )
	EndIf

   _OOHG_ActiveSplitBoxInverted := Inverted

   _OOHG_ActiveSplitBox := .T.

   _OOHG_ActiveSplitBoxParentFormName := ParentForm

	cParentForm := ParentForm

   ParentForm = GetFormHandle( ParentForm )

   ControlHandle := InitSplitBox( ParentForm, bottom, inverted, lRtl )

   GetFormObject( cParentForm ):ReBarHandle := ControlHandle
   // oWnd:lRtl := lRtl

Return Nil

*-----------------------------------------------------------------------------*
Function _EndSplitBox ()
*-----------------------------------------------------------------------------*

   _OOHG_SplitForceBreak := .T.

   _OOHG_ActiveSplitBox := .F.

Return Nil

*-----------------------------------------------------------------------------*
Function _EndWindow ()
*-----------------------------------------------------------------------------*

   If Len( _OOHG_ActiveForm ) > 0

      If ATail( _OOHG_ActiveForm ):Type == "X"
         ATail( _OOHG_ActiveForm ):Active := .t.
      EndIf

      _OOHG_DeleteArrayItem( _OOHG_ActiveForm, Len( _OOHG_ActiveForm ) )

	EndIf

Return Nil

*-----------------------------------------------------------------------------*
Function InputBox ( cInputPrompt , cDialogCaption , cDefaultValue , nTimeout , cTimeoutValue , lMultiLine )
*-----------------------------------------------------------------------------*

	Local RetVal , mo

	DEFAULT cInputPrompt	TO ""
	DEFAULT cDialogCaption	TO ""
	DEFAULT cDefaultValue	TO ""

	RetVal := ''

   If ValType (lMultiLine) == 'L' .AND. lMultiLine
      mo := 150
	Else
		mo := 0
	EndIf

	DEFINE WINDOW _InputBox 		;
		AT 0,0 				;
		WIDTH 350 			;
		HEIGHT 115 + mo	+ GetTitleHeight() ;
		TITLE cDialogCaption  		;
		MODAL 				;
		NOSIZE 				;
      FONT 'Arial'      ;
      SIZE 10           ;
      BACKCOLOR ( GetFormObjectByHandle( GetActiveWindow() ):BackColor )

      ON KEY ESCAPE ACTION ( _OOHG_DialogCancelled := .T. , _InputBox.Release )

		@ 07,10 LABEL _Label		;
			VALUE cInputPrompt	;
			WIDTH 280
// JK
                If ValType (lMultiLine) != 'U' .and. lMultiLine == .T.
                @ 30,10 EDITBOX _TextBox	;
			VALUE cDefaultValue	;
			HEIGHT 26 + mo		;
			WIDTH 320
                else
		@ 30,10 TEXTBOX _TextBox	;
			VALUE cDefaultValue	;
			HEIGHT 26 + mo		;
			WIDTH 320		;
         ON ENTER ( _OOHG_DialogCancelled := .F. , RetVal := _InputBox._TextBox.Value , _InputBox.Release )

                endif
//
		@ 67+mo,120 BUTTON _Ok		;
			CAPTION if( Set ( _SET_LANGUAGE ) == 'ES', 'Aceptar' ,'Ok' )		;
         ACTION ( _OOHG_DialogCancelled := .F. , RetVal := _InputBox._TextBox.Value , _InputBox.Release )

		@ 67+mo,230 BUTTON _Cancel		;
			CAPTION if( Set ( _SET_LANGUAGE ) == 'ES', 'Cancelar', 'Cancel'	);
         ACTION   ( _OOHG_DialogCancelled := .T. , _InputBox.Release )

			If ValType (nTimeout) != 'U'

				If ValType (cTimeoutValue) != 'U'

					DEFINE TIMER _InputBox ;
					INTERVAL nTimeout ;
					ACTION  ( RetVal := cTimeoutValue , _InputBox.Release )

				Else

					DEFINE TIMER _InputBox ;
					INTERVAL nTimeout ;
					ACTION _InputBox.Release

				EndIf

			EndIf

	END WINDOW

	_InputBox._TextBox.SetFocus

	CENTER WINDOW _InputBox

	ACTIVATE WINDOW _InputBox

Return ( RetVal )

*-----------------------------------------------------------------------------*
Function _SetWindowRgn(name,col,row,w,h,lx)
*-----------------------------------------------------------------------------*
Return c_SetWindowRgn( GetFormHandle( name ), col, row, w, h, lx )

*-----------------------------------------------------------------------------*
Function _SetPolyWindowRgn(name,apoints,lx)
*-----------------------------------------------------------------------------*
local apx:={},apy:={}

      aeval(apoints,{|x| aadd(apx,x[1]), aadd(apy,x[2])})

Return c_SetPolyWindowRgn( GetFormHandle( name ), apx, apy, lx )

*-----------------------------------------------------------------------------*
Procedure _SetNextFocus()
*-----------------------------------------------------------------------------*
Local oCtrl , NextControlHandle

	NextControlHandle := GetNextDlgTabITem ( GetActiveWindow() , GetFocus() , 0 )
   oCtrl := GetControlObjectByHandle( NextControlHandle )
   if oCtrl:hWnd == NextControlHandle
      oCtrl:SetFocus()
   else
		InsertTab()
   endif

Return

*-----------------------------------------------------------------------------*
Function _ActivateWindow( aForm, lNoWait )
*-----------------------------------------------------------------------------*
Local z, aForm2, oWndActive, oWnd, lModal

* Testing... it allows to create non-modal windows when modal windows are active.
* The problem is, what should do when modal window is ... disabled? hidden? WM_CLOSE? WM_DESTROY?
/*
   // Multiple activation can't be used when modal window is active
   If len( aForm ) > 1 .AND. Len( _OOHG_ActiveModal ) != 0
      MsgOOHGError( "Multiple Activation can't be used when a modal window is active. Program Terminated" )
   Endif
*/

   aForm2 := ACLONE( aForm )

   // Validates NOWAIT flag
   IF ValType( lNoWait ) != "L"
      lNoWait := .F.
   ENDIF
   oWndActive := IF( lNoWait, _OOHG_Main, GetFormObject( aForm2[ 1 ] ) )

   // Looks for MAIN window
   z := ASCAN( aForm2, { |c| GetFormObject( c ):Type == "A" } )
   IF z != 0
      AADD( aForm2, nil )
      AINS( aForm2, 1 )
      aForm2[ 1 ] := aForm2[ z + 1 ]
      _OOHG_DeleteArrayItem( aForm2, z + 1 )
      IF lNoWait
         * MsgOOHGError( "NOWAIT option can't be used in MAIN window. Program Terminated" )
         oWndActive := GetFormObject( aForm2[ 1 ] )
      ENDIF
   ENDIF

   // Activate windows
   lModal := .F.
   FOR z := 1 TO Len( aForm2 )
      oWnd := GetFormObject( aForm2[ z ] )
      IF oWnd:Type == "M" .AND. ! oWnd:NoShow
         IF lModal
            MsgOOHGError( "ACTIVATE WINDOW: Only one initially visible modal window allowed. Program terminated" )
         ENDIF
         lModal := .T.
      ENDIF
      oWnd:Activate( .T., oWndActive )
   NEXT

   If ! lNoWait
      GetFormObject( aForm2[ 1 ] ):MessageLoop()
   Endif

Return Nil

*-----------------------------------------------------------------------------*
Function _ActivateAllWindows()
*-----------------------------------------------------------------------------*
Local i
Local aForm := {}, oWnd
Local MainName := ''

	* If Already Active Windows Abort Command

   If ascan( _OOHG_aFormObjects, { |o| o:Active } ) > 0
      MsgOOHGError("ACTIVATE WINDOW ALL: This Command Should Be Used At Application Startup Only. Program terminated" )
	EndIf

// WHY???   * Force NoShow And NoAutoRelease Styles For Non Main Windows
	* ( Force AutoRelease And Visible For Main )

   For i := 1 To LEN( _OOHG_aFormObjects )
      oWnd := _OOHG_aFormObjects[ i ]
      If oWnd:Type != "X" .AND. ! oWnd:lInternal
         if oWnd:Type == "A"
            oWnd:NoShow := .F.
            oWnd:AutoRelease := .T.
            MainName := oWnd:Name
         ELse
//            oWnd:NoShow := .T.
//            oWnd:AutoRelease := .F.
            aadd( aForm , oWnd:Name )
         EndIf
      EndIf
	Next i

	aadd ( aForm , MainName )

	* Check For Error And Call Activate Window Command

   If Empty( MainName )
      MsgOOHGError( "ACTIVATE WINDOW ALL: Main Window Not Defined. Program terminated" )
   ElseIf Len( aForm ) == 0
      MsgOOHGError( "ACTIVATE WINDOW ALL: No Windows Defined. Program terminated" )
	Else
      _ActivateWindow( aForm )
	EndIf

Return Nil

*------------------------------------------------------------------------------*
Procedure _PushEventInfo
*------------------------------------------------------------------------------*

   aadd ( _OOHG_aEventInfo , { _OOHG_ThisForm, _OOHG_ThisEventType , _OOHG_ThisType , _OOHG_ThisControl } )

Return

*------------------------------------------------------------------------------*
Procedure _PopEventInfo
*------------------------------------------------------------------------------*
Local l

   l := Len( _OOHG_aEventInfo )

	if l > 0

      _OOHG_ThisForm   := _OOHG_aEventInfo [l] [1]
      _OOHG_ThisEventType   := _OOHG_aEventInfo [l] [2]
      _OOHG_ThisType     := _OOHG_aEventInfo [l] [3]
      _OOHG_ThisControl    := _OOHG_aEventInfo [l] [4]

      asize( _OOHG_aEventInfo , l - 1 )

	Else

      _OOHG_ThisForm := nil
      _OOHG_ThisType := ''
      _OOHG_ThisEventType := ''
      _OOHG_ThisControl := nil

	EndIf

Return

Function SetInteractiveClose( nValue )
Local nRet := _OOHG_InteractiveClose
   If ValType( nValue ) == "N" .AND. nValue >= 0 .AND. nValue <= 3
      _OOHG_InteractiveClose := INT( nValue )
   EndIf
Return nRet

Function SetAppHotKey( nKey, nFlags, bAction )
Return _OOHG_SetKey( _OOHG_HotKeys, nKey, nFlags, bAction )

Function _OOHG_MacroCall( cMacro )
Local uRet, oError
   oError := ERRORBLOCK()
   ERRORBLOCK( { | e | _OOHG_MacroCall_Error( e ) } )
   BEGIN SEQUENCE
      uRet := &cMacro
   RECOVER
      uRet := nil
   END SEQUENCE
   ERRORBLOCK( oError )
Return uRet

Static Function _OOHG_MacroCall_Error( oError )
   BREAK oError
RETURN 1

EXTERN IsXPThemeActive, _OOHG_Eval, EVAL
EXTERN _OOHG_ShowContextMenus, _OOHG_GlobalRTL, _OOHG_NestedSameEvent

#pragma BEGINDUMP

typedef LONG ( * CALL_ISTHEMEACTIVE )( void );

HB_FUNC( ISXPTHEMEACTIVE )
{
   BOOL bResult = FALSE;
   HMODULE hInstDLL;
   CALL_ISTHEMEACTIVE dwProcAddr;
   LONG lResult;

   OSVERSIONINFO os;

   os.dwOSVersionInfoSize = sizeof( os );

   if( GetVersionEx( &os ) && os.dwPlatformId == VER_PLATFORM_WIN32_NT && os.dwMajorVersion == 5 && os.dwMinorVersion == 1 )
   {
      hInstDLL = LoadLibrary( "UXTHEME.DLL" );
      if( hInstDLL )
      {
         dwProcAddr = ( CALL_ISTHEMEACTIVE ) GetProcAddress( hInstDLL, "IsThemeActive" );
         if( dwProcAddr )
         {
            lResult = ( dwProcAddr )();
            if( lResult )
            {
               bResult = TRUE;
            }
         }

         FreeLibrary( hInstDLL );
      }
   }

   hb_retl( bResult );
}

HB_FUNC( _OOHG_EVAL )
{
   if( ISBLOCK( 1 ) )
   {
      HB_FUN_EVAL();
   }
   else
   {
      hb_ret();
   }
}

HB_FUNC( _OOHG_SHOWCONTEXTMENUS )
{
   if( ISLOG( 1 ) )
   {
      _OOHG_ShowContextMenus = hb_parl( 1 );
   }
   hb_retl( _OOHG_ShowContextMenus );
}

HB_FUNC( _OOHG_GLOBALRTL )
{
   if( ISLOG( 1 ) )
   {
      _OOHG_GlobalRTL = hb_parl( 1 );
   }
   hb_retl( _OOHG_GlobalRTL );
}

HB_FUNC( _OOHG_NESTEDSAMEEVENT )
{
   if( ISLOG( 1 ) )
   {
      _OOHG_NestedSameEvent = hb_parl( 1 );
   }
   hb_retl( _OOHG_NestedSameEvent );
}

#pragma ENDDUMP

Function _OOHG_GetArrayItem( uaArray, nItem, uExtra1, uExtra2 )
Local uRet
   IF ValType( uaArray ) != "A"
      uRet := uaArray
   ElseIf LEN( uaArray ) >= nItem
      uRet := uaArray[ nItem ]
   Else
      uRet := NIL
   ENDIF
   IF ValType( uRet ) == "B"
      uRet := Eval( uRet, nItem, uExtra1, uExtra2 )
   ENDIF
Return uRet

Function _OOHG_DeleteArrayItem( aArray, nItem )
#ifdef __XHARBOUR__
   Return ADel( aArray, nItem, .T. )
#else
   IF ValType( aArray ) == "A" .AND. Len( aArray ) >= nItem
      ADel( aArray, nItem )
      ASize( aArray, Len( aArray ) - 1 )
   ENDIF
   Return aArray
#endif

FUNCTION _OOHG_SetKey( aKeys, nKey, nFlags, bAction, nId )
Local nPos, uRet := nil
   nPos := ASCAN( aKeys, { |a| a[ HOTKEY_KEY ] == nKey .AND. a[ HOTKEY_MOD ] == nFlags } )
   If nPos > 0
      uRet := aKeys[ nPos ][ HOTKEY_ACTION ]
   EndIf
   If PCOUNT() > 2
      If ValType( bAction ) == "B"
         If ValType( nId ) != "N"
            nId := 0
         EndIf
         If nPos > 0
            aKeys[ nPos ] := { nId, nFlags, nKey, bAction }
         Else
            AADD( aKeys, { nId, nFlags, nKey, bAction } )
         EndIf
      Else
         If nPos > 0
            _OOHG_DeleteArrayItem( aKeys, nPos )
         EndIf
      Endif
   EndIf
Return uRet