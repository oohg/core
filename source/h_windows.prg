/*
 * $Id: h_windows.prg,v 1.236 2012-07-12 00:22:27 fyurisich Exp $
 */
/*
 * ooHG source code:
 * PRG Windows handling functions
 *
 * Copyright 2005-2011 Vicente Guerra <vicente@guerra.com.mx>
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
/*
	Cayetano Gómez ( 11/04/2011)
	usar :
	//CGR
	Para encontrar ls modificaciones
	añadidos los bordes, a todos los controles.
	08082011 - Colores en el foco
	13082011 - angle y width en la fuente.
*/	

#include "oohg.ch"
#include "i_windefs.ch"
#include "common.ch"
#include "error.ch"

STATIC _OOHG_aEventInfo := {}        // Event's stack
STATIC _OOHG_DialogCancelled := .F.  //
STATIC _OOHG_HotKeys := {}           // Application-wide hot keys
STATIC _OOHG_bKeyDown := nil         // Application-wide WM_KEYDOWN handler

#include "hbclass.ch"

// C static variables
#pragma BEGINDUMP

#ifndef WINVER
   #define WINVER 0x0500
#endif
#if ( WINVER < 0x0500 )
   #undef WINVER
   #define WINVER 0x0500
#endif

#ifndef _WIN32_WINNT
   #define _WIN32_WINNT 0x0500
#endif
#if ( _WIN32_WINNT < 0x0500 )
   #undef _WIN32_WINNT
   #define _WIN32_WINNT 0x0500
#endif

#include "hbapi.h"
#include "hbapiitm.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windows.h>
#include <commctrl.h>
#include <olectl.h>
#include "oohg.h"

#ifdef HB_ITEM_NIL
   #define hb_dynsymSymbol( pDynSym )        ( ( pDynSym )->pSymbol )
#endif

int  _OOHG_ShowContextMenus = 1;      //
int  _OOHG_GlobalRTL = 0;             // Force RTL functionality
int  _OOHG_NestedSameEvent = 0;       // Allows to nest an event currently performed (i.e. CLICK button)
int  _OOHG_MouseCol = 0;              // Mouse's column
int  _OOHG_MouseRow = 0;              // Mouse's row
PHB_ITEM _OOHG_LastSelf = NULL;

void _OOHG_SetMouseCoords( PHB_ITEM pSelf, int iCol, int iRow )
{
   PHB_ITEM pSelf2;

   pSelf2 = hb_itemNew( NULL );
   hb_itemCopy( pSelf2, pSelf );

   _OOHG_Send( pSelf2, s_ColMargin );
   hb_vmSend( 0 );
   _OOHG_MouseCol = iCol - hb_parni( -1 );

   _OOHG_Send( pSelf2, s_RowMargin );
   hb_vmSend( 0 );
   _OOHG_MouseRow = iRow - hb_parni( -1 );

   hb_itemRelease( pSelf2 );
}

HB_FUNC( _OOHG_SETMOUSECOORDS )
{
   _OOHG_SetMouseCoords( (PHB_ITEM) hb_param( 1, HB_IT_ARRAY ), hb_parni( 2 ), hb_parni( 3 ) );
}

#pragma ENDDUMP


*------------------------------------------------------------------------------*
CLASS TWindow
*------------------------------------------------------------------------------*
   DATA hWnd                INIT 0
   DATA aControlInfo        INIT { CHR( 0 ) }
   DATA Name                INIT ""
   DATA Type                INIT ""
   DATA Parent              INIT nil
   DATA nRow                INIT 0
   DATA nCol                INIT 0
   DATA nWidth              INIT 0
   DATA nHeight             INIT 0
   DATA Active              INIT .F.
   DATA cFontName           INIT ""
   DATA nFontSize           INIT 0
   DATA Bold                INIT .F.
   DATA Italic              INIT .F.
   DATA Underline           INIT .F.
   DATA Strikeout           INIT .F.
   DATA FntWidth			INIT 0
   DATA FntAngle				INIT 0
   //CGR
   DATA cFocusFontName           INIT ""
   DATA nFocusFontSize           INIT 0
   DATA FocusBold                INIT .F.
   DATA FocusItalic              INIT .F.
   DATA FocusUnderline           INIT .F.
   DATA FocusStrikeout           INIT .F.
   DATA FocusColor
   DATA FocusBackColor
   
   DATA RowMargin           INIT 0
   DATA ColMargin           INIT 0
   DATA Container           INIT nil
   DATA ContainerhWndValue  INIT nil
   DATA lRtl                INIT .F.
   DATA lVisible            INIT .T.
   DATA ContextMenu         INIT nil
   DATA Cargo               INIT nil
   DATA lEnabled            INIT .T.
   DATA aControls           INIT {}
   DATA aControlsNames      INIT {}
   DATA WndProc             INIT nil
   DATA OverWndProc         INIT nil
   DATA lInternal           INIT .T.
   DATA lForm               INIT .F.
   DATA lReleasing          INIT .F.
   DATA lDestroyed          INIT .F.
   DATA Block               INIT nil
   DATA VarName             INIT ""

   DATA lAdjust             INIT .T.
   DATA lFixFont            INIT .F.
   DATA lfixwidth           INIT .F.
   DATA ClientHeightUsed    INIT 0
   DATA nFixedHeightUsed    INIT 0

   DATA OnClick             INIT nil
   DATA OnDblClick          INIT nil
   DATA OnRClick            INIT nil
   DATA OnRDblClick         INIT nil
   DATA OnMClick            INIT nil
   DATA OnMDblClick         INIT nil
   DATA OnGotFocus          INIT nil
   DATA OnLostFocus         INIT nil
   DATA OnMouseDrag         INIT nil
   DATA OnMouseDrop         INIT nil
   DATA DropEnabled         INIT .F.              // .T. if control accepts drops
   DATA HasDragFocus        INIT .F.              // .T. when drag image is upon the control and the control is drop enabled
   DATA OnDrop              INIT {}               // executed after drop is finished
   DATA OnMouseMove         INIT nil
   DATA OnDropFiles         INIT nil
   DATA aKeys               INIT {}  // { Id, Mod, Key, Action }   Application-controlled hotkeys
   DATA aHotKeys            INIT {}  // { Id, Mod, Key, Action }   OperatingSystem-controlled hotkeys
   DATA aAcceleratorKeys    INIT {}  // { Id, Mod, Key, Action }   Accelerator hotkeys
   DATA bKeyDown            INIT nil     // WM_KEYDOWN handler
   DATA NestedClick         INIT .F.
   DATA HScrollBar          INIT nil
   DATA VScrollBar          INIT nil

    //////// all redimension Vars
   DATA nOldw               INIT NIL
   DATA nOLdh               INIT NIL
   DATA nWindowState        INIT 0   /// 2 Maximizada 1 minimizada  0 Normal
   // Anchor
   DATA nAnchor             INIT nil
   DATA nDefAnchor          INIT 3

   ///////

   DATA DefBkColorEdit      INIT nil

   //CGR
   // Client adjust
   DATA ClientAdjust        INIT 0 // 0=none, 1=top, 2=bottom, 3=left, 4=right, 5=Client
   DATA IsAdjust            INIT .F.
   DATA nBorders			      INIT {0,0,0} // ancho externo, estacio, ancho interno.
   DATA aBECOLORS			      INIT {{0,0,0},{0,0,0},{0,0,0},{0,0,0}} // color externo: arriba, derecha, abajo, izquierda
   DATA aBICOLORS			      INIT {{0,0,0},{0,0,0},{0,0,0},{0,0,0}} // color interno: arriba, derecha, abajo, izquierda
   DATA nPaintCount			                                           // contador para GetDc y ReleaseDc
   DATA hDC					                                               // puntero al contexto del canvas.

   METHOD SethWnd
   METHOD Release
   METHOD PreRelease
   METHOD StartInfo
   METHOD SetFocus
   METHOD ImageList           SETGET
   METHOD BrushHandle         SETGET
   METHOD FontHandle          SETGET
   METHOD FontColor           SETGET
   METHOD FontColorCode       SETGET
   METHOD BackColor           SETGET
   METHOD BackColorCode       SETGET
   METHOD FontColorSelected   SETGET
   METHOD BackColorSelected   SETGET
   METHOD BackBitMap          SETGET
   METHOD Caption             SETGET
   METHOD Events

   METHOD Object              BLOCK { |Self| Self }
   METHOD Enabled             SETGET
   METHOD Enable              BLOCK { |Self| ::Enabled := .T. }
   METHOD Disable             BLOCK { |Self| ::Enabled := .F. }
   METHOD Click               BLOCK { |Self| ::DoEvent( ::OnClick, "CLICK" ) }
   METHOD Value               BLOCK { || nil }
   METHOD TabStop             SETGET
   METHOD Style               SETGET
   METHOD RTL                 SETGET
   METHOD AcceptFiles         SETGET
   METHOD Action              SETGET
   METHOD SaveData
   METHOD RefreshData
   METHOD Print
   METHOD SaveAs
   METHOD GetBitMap(l)        BLOCK { |Self,l| _GetBitMap( ::hWnd, l ) }
   METHOD AddControl
   METHOD DeleteControl
   METHOD SearchParent
   METHOD ParentDefaults

   METHOD Events_Size         BLOCK { || nil }
   METHOD Events_VScroll      BLOCK { || nil }
   METHOD Events_HScroll      BLOCK { || nil }
   METHOD Events_Enter        BLOCK { || nil }
   METHOD Events_Color        BLOCK { || nil }

   ERROR HANDLER Error
   METHOD Control

   METHOD HotKey                // OperatingSystem-controlled hotkeys
   METHOD SetKey                // Application-controlled hotkeys
   METHOD AcceleratorKey        // Accelerator hotkeys
   METHOD LookForKey
   METHOD ReleaseAttached
   METHOD Visible             SETGET
   METHOD Show                BLOCK { |Self| ::Visible := .T. }
   METHOD Hide                BLOCK { |Self| ::Visible := .F. }
   METHOD ForceHide           BLOCK { |Self| HideWindow( ::hWnd ) , ::CheckClientsPos() }
   METHOD ReDraw              BLOCK { |Self| RedrawWindow( ::hWnd ) }
   METHOD DefWindowProc(nMsg,wParam,lParam)       BLOCK { |Self,nMsg,wParam,lParam| DefWindowProc( ::hWnd, nMsg, wParam, lParam ) }
   METHOD GetTextWidth
   METHOD GetTextHeight
   METHOD GetMaxCharsInWidth
   METHOD ClientWidth         SETGET
   METHOD ClientHeight        SETGET
   METHOD AdjustResize
   //
   METHOD Anchor              SETGET
   METHOD AdjustAnchor

   //CGR
   METHOD CheckClientsPos
   METHOD ClientsPos
   METHOD ClientsPos2
   METHOD Adjust              SETGET
   METHOD GetDC() INLINE If( ::hDC == nil, ::hDC := GetDC( ::hWnd ),),;
       If( ::nPaintCount == nil, ::nPaintCount := 1, ::nPaintCount++ ), ::hDC
   METHOD ReleaseDC() INLINE  If( --::nPaintCount == 0,;
       If( ReleaseDC( ::hWnd, ::hDC ), ::hDC := nil,),)

   METHOD DebugMessageName
   METHOD DebugMessageQuery
   METHOD DebugMessageNameCommand
   METHOD DebugMessageNameNotify
   METHOD DebugMessageQueryNotify

   METHOD ContainerVisible    BLOCK { |Self| ::lVisible .AND. IF( ::Container != NIL, ::Container:ContainerVisible, .T. ) }
   METHOD ContainerEnabled    BLOCK { |Self| ::lEnabled .AND. IF( ::Container != NIL, ::Container:ContainerEnabled, .T. ) }
   METHOD ContainerReleasing  BLOCK { |Self| ::lReleasing .OR. IF( ::Container != NIL, ::Container:ContainerReleasing, IF( ::Parent != NIL, ::Parent:ContainerReleasing, .F. ) ) }

   // Specific HACKS :(
   METHOD SetSplitBox         BLOCK { || .F. }
   METHOD SetSplitBoxInfo     BLOCK { |Self,a,b,c,d| if( ::Container != nil, ::Container:SetSplitBox( a,b,c,d ), .F. ) }
   
   // Graphics Methods
   //CGR
   METHOD Line
   METHOD Fill
   Method Box
   Method RoundBox   
   METHOD Ellipse   
   METHOD Arc
   METHOD Pie
   /*
   METHOD ArcTo(row,col,torow,tocol,rowrad1,colrad1,rowrad2,colrad2,defpen)
   METHOD Chord(row,col,torow,tocol,rowrad1,colrad1,rowrad2,colrad2,defpen,defbrush)
   METHOD Polygon(apoints,defpen,defbrush,style)
   METHOD PolyBezier(apoints,defpen)
   METHOD PolyBezierTo(apoints,defpen)
*/
ENDCLASS

#pragma BEGINDUMP

HB_FUNC_STATIC( TWINDOW_SETHWND )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( hb_pcount() >= 1 && ISNUM( 1 ) )
   {
      oSelf->hWnd = HWNDparam( 1 );
   }

   HWNDret( oSelf->hWnd );
}

HB_FUNC_STATIC( TWINDOW_RELEASE )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   // ImageList
   if( ValidHandler( oSelf->ImageList ) )
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
   if( ValidHandler( oSelf->BrushHandle ) )
   {
      DeleteObject( oSelf->BrushHandle );
      oSelf->BrushHandle = NULL;
   }

   // Context menu
   _OOHG_Send( pSelf, s_ContextMenu );
   hb_vmSend( 0 );
   if( hb_param( -1, HB_IT_OBJECT ) )
   {
      _OOHG_Send( hb_param( -1, HB_IT_OBJECT ), s_Release );
      hb_vmSend( 0 );
      _OOHG_Send( pSelf, s__ContextMenu );
      hb_vmPushNil();
      hb_vmSend( 1 );
   }

   // ::hWnd := -1
   oSelf->hWnd = ( HWND )( ~0 );
   _OOHG_Send( pSelf, s__hWnd );
   HWNDpush( ~0 );
   hb_vmSend( 1 );
}

HB_FUNC_STATIC( TWINDOW_STARTINFO )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   oSelf->hWnd = HWNDparam( 1 );

   oSelf->lFontColor = -1;
   oSelf->lBackColor = -1;
   oSelf->lFontColorSelected = -1;
   oSelf->lBackColorSelected = -1;
   oSelf->lOldBackColor = -1;
   oSelf->lUseBackColor = -1;

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

   if( ValidHandler( oSelf->hWnd ) )
   {
      SetFocus( oSelf->hWnd );
   }

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

   HWNDret( oSelf->ImageList );
}

HB_FUNC_STATIC( TWINDOW_BRUSHHANDLE )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   HBRUSH hBrush;

   hBrush = ( HBRUSH ) HWNDparam( 1 );
   if( hb_pcount() >= 1 )
   {
      if( oSelf->BrushHandle )
      {
         DeleteObject( oSelf->BrushHandle );
      }
      oSelf->BrushHandle = ValidHandler( hBrush ) ? hBrush : 0;
   }

   HWNDret( oSelf->BrushHandle );
}

HB_FUNC_STATIC( TWINDOW_FONTHANDLE )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( hb_pcount() >= 1 && ISNUM( 1 ) )
   {
      oSelf->hFontHandle = ( HFONT ) HWNDparam( 1 );
   }

   HWNDret( oSelf->hFontHandle );
}

HB_FUNC_STATIC( TWINDOW_FONTCOLOR )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &oSelf->lFontColor, ( hb_pcount() >= 1 ) ) )
   {
      if( ValidHandler( oSelf->hWnd ) )
      {
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   // Return value was set in _OOHG_DetermineColorReturn()
}

HB_FUNC_STATIC( TWINDOW_FONTCOLORCODE )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( hb_pcount() >= 1 )
   {
      if( ! _OOHG_DetermineColor( hb_param( 1, HB_IT_ANY ), &oSelf->lFontColor ) )
      {
         oSelf->lFontColor = -1;
      }
      if( ValidHandler( oSelf->hWnd ) )
      {
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   hb_retnl( oSelf->lFontColor );
}

HB_FUNC_STATIC( TWINDOW_BACKCOLOR )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &oSelf->lBackColor, ( hb_pcount() >= 1 ) ) )
   {
      if( ValidHandler( oSelf->hWnd ) )
      {
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   // Return value was set in _OOHG_DetermineColorReturn()
}

HB_FUNC_STATIC( TWINDOW_BACKCOLORCODE )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( hb_pcount() >= 1 )
   {
      if( ! _OOHG_DetermineColor( hb_param( 1, HB_IT_ANY ), &oSelf->lBackColor ) )
      {
         oSelf->lBackColor = -1;
      }
      if( ValidHandler( oSelf->hWnd ) )
      {
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   hb_retnl( oSelf->lBackColor );
}

HB_FUNC_STATIC( TWINDOW_FONTCOLORSELECTED )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &oSelf->lFontColorSelected, ( hb_pcount() >= 1 ) ) )
   {
      if( ValidHandler( oSelf->hWnd ) )
      {
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   // Return value was set in _OOHG_DetermineColorReturn()
}

HB_FUNC_STATIC( TWINDOW_BACKCOLORSELECTED )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &oSelf->lBackColorSelected, ( hb_pcount() >= 1 ) ) )
   {
      if( ValidHandler( oSelf->hWnd ) )
      {
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   // Return value was set in _OOHG_DetermineColorReturn()
}

HB_FUNC_STATIC( TWINDOW_BACKBITMAP )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   HBITMAP hBitMap;

   hBitMap = ( HBITMAP ) HWNDparam( 1 );
   if( ValidHandler( hBitMap ) )
   {
      if( oSelf->BrushHandle )
      {
         DeleteObject( oSelf->BrushHandle );
      }
      oSelf->BrushHandle = CreatePatternBrush( hBitMap );
   }

   HWNDret( oSelf->BrushHandle );
}

HB_FUNC_STATIC( TWINDOW_CAPTION )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   int iLen;
   LPTSTR cText;

   if( ISCHAR( 1 ) )
   {
      SetWindowText( oSelf->hWnd, ( LPCTSTR ) hb_parc( 1 ) );
   }

   iLen = GetWindowTextLength( oSelf->hWnd ) + 1;
   cText = ( LPTSTR ) hb_xgrab( iLen );
   GetWindowText( oSelf->hWnd, cText, iLen );
   hb_retc( cText );
   hb_xfree( cText );
}

HB_FUNC_STATIC( TWINDOW_ACCEPTFILES )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( ISLOG( 1 ) )
   {
      DragAcceptFiles( oSelf->hWnd, hb_parl( 1 ) );
   }

   hb_retl( ( GetWindowLong( oSelf->hWnd, GWL_EXSTYLE ) & WS_EX_ACCEPTFILES ) == WS_EX_ACCEPTFILES );
}

HB_FUNC_STATIC( TWINDOW_EVENTS )
{
   HWND hWnd      = HWNDparam( 1 );
   UINT message   = ( UINT )   hb_parni( 2 );
   WPARAM wParam  = ( WPARAM ) hb_parni( 3 );
   LPARAM lParam  = ( LPARAM ) hb_parnl( 4 );
   PHB_ITEM pSelf = hb_stackSelfItem();

   switch( message )
   {
      case WM_CTLCOLORBTN:
      case WM_CTLCOLORSTATIC:
         _OOHG_Send( _OOHG_GetExistingObject( ( HWND ) lParam, FALSE, TRUE ), s_Events_Color );
         hb_vmPushLong( wParam );
         hb_vmPushLong( GetSysColor( COLOR_3DFACE ) );
         hb_vmSend( 2 );
         break;

      case WM_CTLCOLOREDIT:
      case WM_CTLCOLORLISTBOX:
         _OOHG_Send( _OOHG_GetExistingObject( ( HWND ) lParam, FALSE, TRUE ), s_Events_Color );
         hb_vmPushLong( wParam );
         hb_vmPushLong( GetSysColor( COLOR_WINDOW ) );
         hb_vmSend( 2 );
         break;

      case WM_NOTIFY:
         _OOHG_Send( GetControlObjectByHandle( ( ( NMHDR FAR * ) lParam )->hwndFrom ), s_Events_Notify );
         hb_vmPushLong( wParam );
         hb_vmPushLong( lParam );
         hb_vmSend( 2 );
         break;

      case WM_COMMAND:
         if( wParam == 1 )
         {
            // Enter key
            _OOHG_Send( _OOHG_GetExistingObject( GetFocus(), TRUE, TRUE ), s_Events_Enter );
            hb_vmSend( 0 );
         }
         else
         {
            PHB_ITEM pControl, pOnClick;

            pControl = hb_itemNew( NULL );
            hb_itemCopy( pControl, GetControlObjectById( LOWORD( wParam ), hWnd ) );
            _OOHG_Send( pControl, s_Id );
            hb_vmSend( 0 );
            if( hb_parni( -1 ) != 0 )
            {
               // By Id
               // From MENU
               BOOL bClicked = 0;

               _OOHG_Send( pControl, s_NestedClick );
               hb_vmSend( 0 );
               if( ! hb_parl( -1 ) )
               {
                  _OOHG_Send( pControl, s__NestedClick );
                  hb_vmPushLogical( ! _OOHG_NestedSameEvent );
                  hb_vmSend( 1 );

                  _OOHG_Send( pControl, s_OnClick );
                  hb_vmSend( 0 );
                  if( hb_param( -1, HB_IT_BLOCK ) )
                  {
                     pOnClick = hb_itemNew( NULL );
                     hb_itemCopy( pOnClick, hb_param( -1, HB_IT_ANY ) );
                     _OOHG_Send( pControl, s_DoEvent );
                     hb_vmPush( pOnClick );
                     hb_vmPushString( "CLICK", 5 );
// aqui!
//DefWindowProc( hWnd, message, wParam, lParam );
EndMenu();
                     hb_vmSend( 2 );
                     hb_itemRelease( pOnClick );
                     bClicked = 1;
                  }

                  _OOHG_Send( pControl, s__NestedClick );
                  hb_vmPushLogical( 0 );
                  hb_vmSend( 1 );
               }
               hb_itemRelease( pControl );
               if( bClicked )
               {
                  hb_retni( 1 );
               }
               else
               {
                  hb_ret();
               }
            }
            else
            {
               hb_itemRelease( pControl );
               // By handle
               _OOHG_Send( _OOHG_GetExistingObject( ( HWND ) lParam, FALSE, TRUE ), s_Events_Command );
               hb_vmPushLong( wParam );
               hb_vmSend( 1 );
            }
         }
         break;

      case WM_TIMER:
         _OOHG_DoEvent( GetControlObjectById( LOWORD( wParam ), hWnd ), s_OnClick, "TIMER", NULL );
         hb_ret();
         break;

      case WM_DRAWITEM:
         _OOHG_Send( GetControlObjectByHandle( ( ( LPDRAWITEMSTRUCT ) lParam )->hwndItem ), s_Events_DrawItem );
         hb_vmPushLong( lParam );
         hb_vmSend( 1 );
         break;

      case WM_MEASUREITEM:
         if( wParam )
         {
            _OOHG_Send( GetControlObjectById( ( LONG ) ( ( ( LPMEASUREITEMSTRUCT ) lParam )->CtlID ), hWnd ), s_Events_MeasureItem );
         }
         else
         {
            _OOHG_Send( _OOHG_LastSelf, s_Events_MeasureItem );
         }
         hb_vmPushLong( lParam );
         hb_vmSend( 1 );
         break;

      case WM_CONTEXTMENU:
         if( _OOHG_ShowContextMenus )
         {
            PHB_ITEM pControl, pContext;

            // Sets mouse coords
            _OOHG_SetMouseCoords( pSelf, LOWORD( lParam ), HIWORD( lParam ) );

            SetFocus( ( HWND ) wParam );
            pControl = GetControlObjectByHandle( ( HWND ) wParam );

            // Check if control have context menu
            _OOHG_Send( pControl, s_ContextMenu );
            hb_vmSend( 0 );
            pContext = hb_param( -1, HB_IT_OBJECT );
            if( ! pContext )
            {
               // TODO: Check for CONTEXTMENU at container control...

               // Check if form have context menu
               _OOHG_Send( pSelf, s_ContextMenu );
               hb_vmSend( 0 );
               pContext = hb_param( -1, HB_IT_OBJECT );
            }

            // If there's a context menu, show it
            if( pContext )
            {

               // HMENU
               _OOHG_Send( pContext, s_Activate );
               hb_vmPushLong( HIWORD( lParam ) );
               hb_vmPushLong( LOWORD( lParam ) );
               hb_vmSend( 2 );
               hb_retni( 1 );
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

      case WM_MENURBUTTONUP:
         {
            PHB_ITEM pMenu;
            MENUITEMINFO MenuItemInfo;
            POINT Point;

            pMenu = hb_itemNew( NULL );
            hb_itemCopy( pMenu, GetControlObjectByHandle( ( HWND ) lParam ) );
            _OOHG_Send( pMenu, s_hWnd );
            hb_vmSend( 0 );
            if( ValidHandler( HWNDparam( -1 ) ) )
            {
               memset( &MenuItemInfo, 0, sizeof( MenuItemInfo ) );
               MenuItemInfo.cbSize = sizeof( MenuItemInfo );
               MenuItemInfo.fMask = MIIM_ID | MIIM_SUBMENU;
               GetMenuItemInfo( ( HMENU ) lParam, wParam, MF_BYPOSITION, &MenuItemInfo );
               if( MenuItemInfo.hSubMenu )
               {
                  hb_itemCopy( pMenu, GetControlObjectByHandle( ( HWND ) MenuItemInfo.hSubMenu ) );
               }
               else
               {
                  hb_itemCopy( pMenu, GetControlObjectById( MenuItemInfo.wID, hWnd ) );
               }
               _OOHG_Send( pMenu, s_ContextMenu );
               hb_vmSend( 0 );
               if( hb_param( -1, HB_IT_OBJECT ) )
               {
                  hb_itemCopy( pMenu, hb_param( -1, HB_IT_OBJECT ) );
                  GetCursorPos( &Point );
                  // HMENU
                  _OOHG_Send( pMenu, s_hWnd );
                  hb_vmSend( 0 );
                  TrackPopupMenuEx( ( HMENU ) HWNDparam( -1 ), TPM_RECURSE, Point.x, Point.y, hWnd, 0 );
                  PostMessage( hWnd, WM_NULL, 0, 0 );
               }
            }
            hb_itemRelease( pMenu );
            hb_ret();
         }
         break;

      case WM_HSCROLL:
         if( lParam )
         {
            _OOHG_Send( GetControlObjectByHandle( ( HWND ) lParam ), s_Events_HScroll );
            hb_vmPushLong( wParam );
            hb_vmSend( 1 );
         }
         else
         {
            _OOHG_Send( pSelf, s_Events_HScroll );
            hb_vmPushLong( wParam );
            hb_vmSend( 1 );
         }
         break;

      case WM_VSCROLL:
         if( lParam )
         {
            _OOHG_Send( GetControlObjectByHandle( ( HWND ) lParam ), s_Events_VScroll );
            hb_vmPushLong( wParam );
            hb_vmSend( 1 );
         }
         else
         {
            _OOHG_Send( pSelf, s_Events_VScroll );
            hb_vmPushLong( wParam );
            hb_vmSend( 1 );
         }
         break;

      case WM_DROPFILES:
         {
            POINT mouse;
            HDROP hDrop;
            PHB_ITEM pArray, pFiles;
            UINT iCount, iPos, iLen, iLen2;
            BYTE *pBuffer;

            hDrop = ( HDROP ) wParam;
            DragQueryPoint( hDrop, ( LPPOINT ) &mouse );
            iCount = DragQueryFile( hDrop, ~0, NULL, 0 );
            iLen = 0;
            for( iPos = 0; iPos < iCount; iPos++ )
            {
               iLen2 = DragQueryFile( hDrop, iPos, NULL, 0 );
               if( iLen < iLen2 )
               {
                  iLen = iLen2;
               }
            }
            iLen++;
            pBuffer = (BYTE *) hb_xgrab( iLen + 1 );
            pArray = hb_itemNew( NULL );
            hb_arrayNew( pArray, 3 );
            hb_itemPutNI( hb_arrayGetItemPtr( pArray, 2 ), mouse.x );
            hb_itemPutNI( hb_arrayGetItemPtr( pArray, 3 ), mouse.x );
            pFiles = hb_arrayGetItemPtr( pArray, 1 );
            hb_arrayNew( pFiles, iCount );
            for( iPos = 0; iPos < iCount; iPos++ )
            {
               iLen2 = DragQueryFile( hDrop, iPos, ( char * ) pBuffer, iLen );
               hb_itemPutCL( hb_arrayGetItemPtr( pFiles, iPos + 1 ), ( char * ) pBuffer, iLen2 );
            }
            hb_xfree( pBuffer );
            _OOHG_DoEvent( pSelf, s_OnDropFiles, "DROPFILES", pArray );
            hb_itemRelease( pArray );
         }
         break;

      default:
         _OOHG_Send( pSelf, s_WndProc );
         hb_vmSend( 0 );
         if( hb_param( -1, HB_IT_BLOCK ) )
         {
#ifdef __XHARBOUR__
      hb_vmPushSymbol( &hb_symEval );
#else
      hb_vmPushEvalSym();
#endif
            hb_vmPush( hb_param( -1, HB_IT_BLOCK ) );
            HWNDpush( hWnd );
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

*------------------------------------------------------------------------------*
METHOD PreRelease() CLASS TWindow
*------------------------------------------------------------------------------*
   AEVAL( ::aControls, { |o| o:PreRelease() } )
RETURN Self

*------------------------------------------------------------------------------*
METHOD Enabled( lEnabled ) CLASS TWindow
*------------------------------------------------------------------------------*
   IF HB_IsLogical( lEnabled )
      ::lEnabled := lEnabled
      IF ::ContainerEnabled
         EnableWindow( ::hWnd )
      ELSE
         DisableWindow( ::hWnd )
      ENDIF
   ENDIF
RETURN ::lEnabled

*------------------------------------------------------------------------------*
METHOD TabStop( lTabStop ) CLASS TWindow
*------------------------------------------------------------------------------*
   IF HB_IsLogical( lTabStop )
      WindowStyleFlag( ::hWnd, WS_TABSTOP, IF( lTabStop, WS_TABSTOP, 0 ) )
   ENDIF
RETURN ( WindowStyleFlag( ::hWnd, WS_TABSTOP ) != 0 )

*------------------------------------------------------------------------------*
METHOD Style( nStyle ) CLASS TWindow
*------------------------------------------------------------------------------*
   IF HB_IsNumeric( nStyle )
      SetWindowStyle( ::hWnd, nStyle )
   ENDIF
RETURN GetWindowStyle( ::hWnd )

*------------------------------------------------------------------------------*
METHOD RTL( lRTL ) CLASS TWindow
*------------------------------------------------------------------------------*
   If HB_IsLogical( lRTL )
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
METHOD SaveData() CLASS TWindow
*-----------------------------------------------------------------------------*
   _OOHG_EVAL( ::Block, ::Value )
   AEVAL( ::aControls, { |o| If( o:Container == nil, o:SaveData(), ) } )
Return nil

*-----------------------------------------------------------------------------*
METHOD RefreshData() CLASS TWindow
*-----------------------------------------------------------------------------*
   If HB_IsBlock( ::Block )
      ::Value := _OOHG_EVAL( ::Block )
   EndIf
   AEVAL( ::aControls, { |o| o:RefreshData() } )
Return nil

*-----------------------------------------------------------------------------*
METHOD Print( y, x, y1, x1 ) CLASS TWindow
*-----------------------------------------------------------------------------*
Local myobject, cWork
   cWork := '_oohg_t' + alltrim( str( int( hb_random( 999999 ) ) ) ) + '.bmp'
   do while file( cWork )
      cWork := '_oohg_t' + alltrim( str( int( hb_random( 999999 ) ) ) ) + '.bmp'
   enddo

   DEFAULT y1    TO 44
   DEFAULT x1    TO 110
   DEFAULT x    TO 1
   DEFAULT y    TO 1

   ::SaveAs( cWork ) //// save as BMP

   myobject := Tprint()
   
   With Object myobject
      :init()
      :selprinter( .T., .T., .T. )  /// select,preview,landscape
      If ! :lprerror
         :begindoc("ooHG printing" )
         :beginpage()
         :printimage(y,x,y1,x1,cwork)
         :endpage()
         :enddoc()
      EndIf
      :release()
   End

   FErase( cWork )
return nil

*-----------------------------------------------------------------------------*
METHOD SaveAs( cFile, lAll ) CLASS TWindow
*-----------------------------------------------------------------------------*
Local hBitMap
   bringwindowtotop( ::hWnd )
   hBitMap := ::GetBitMap( lAll )
   _SaveBitmap( hBitMap, cFile )
   DeleteObject( hBitMap )
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
METHOD SearchParent( uParent ) CLASS TWindow
*-----------------------------------------------------------------------------*
Local nPos
   If ValType( uParent ) $ "CM" .AND. ! Empty( uParent )
      If ! _IsWindowDefined( uParent )
         MsgOOHGError( "Window: "+ uParent + " is not defined. Program Terminated." )
      Else
         uParent := GetFormObject( uParent )
      Endif
   EndIf

   If ! HB_IsObject( uParent )
      uParent := SearchParentWindow( ::lInternal )
   EndIf

   If ::lInternal
      If ! HB_IsObject( uParent )
         MsgOOHGError( "Window: No window name specified. Program Terminated." )
      EndIf

      // NOTE: For INTERNALs, sets ::Parent and ::Container
      // Checks if parent is a form or container
      If uParent:lForm
         ::Parent := uParent
         // Checks for an open "control container" structure in the specified parent form
         nPos := 0
         AEVAL( _OOHG_ActiveFrame, { |o,i| IF( o:Parent:hWnd == ::Parent:hWnd, nPos := i, ) } )
         If nPos > 0
            ::Container := _OOHG_ActiveFrame[ nPos ]
         EndIf
      Else
         ::Container := uParent
         ::Parent := ::Container:Parent
      EndIf

   EndIf
Return uParent

*-----------------------------------------------------------------------------*
METHOD ParentDefaults( cFontName, nFontSize, uFontColor ) CLASS TWindow
*-----------------------------------------------------------------------------*
   // Font Name:
   If ValType( cFontName ) == "C" .AND. ! EMPTY( cFontName )
      // Specified font
      ::cFontName := cFontName
   ElseIf ValType( ::cFontName ) == "C" .AND. ! Empty( ::cFontName )
      // Pre-registered
   elseif ::Container != nil .AND. ValType( ::Container:cFontName ) == "C" .AND. ! Empty( ::Container:cFontName )
      // Container
      ::cFontName := ::Container:cFontName
   elseif ::Parent != nil .AND. ValType( ::Parent:cFontName ) == "C" .AND. ! Empty( ::Parent:cFontName )
      // Parent form
      ::cFontName := ::Parent:cFontName
   else
       // Default
      ::cFontName := _OOHG_DefaultFontName
   endif

   // Font Size:
   If HB_IsNumeric( nFontSize ) .AND. nFontSize != 0
      // Specified size
      ::nFontSize := nFontSize
   ElseIf HB_IsNumeric( ::nFontSize ) .AND. ::nFontSize != 0
      // Pre-registered
   elseif ::Container != nil .AND. HB_IsNumeric( ::Container:nFontSize ) .AND. ::Container:nFontSize != 0
      // Container
      ::nFontSize := ::Container:nFontSize
   elseif ::Parent != nil .AND. HB_IsNumeric( ::Parent:nFontSize ) .AND. ::Parent:nFontSize != 0
      // Parent form
      ::nFontSize := ::Parent:nFontSize
   else
       // Default
      ::nFontSize := _OOHG_DefaultFontSize
   endif

   // Font Color:
   If ValType( uFontColor ) $ "ANCM"
      // Specified color
      ::FontColor := uFontColor
   ElseIf ValType( ::FontColor ) $ "ANCM"
      // Pre-registered
      * To detect about "-1" !!!
   elseif ::Container != nil .AND. ValType( ::Container:FontColor ) $ "ANCM"
      // Container
      ::FontColor := ::Container:FontColor
   elseif ::Parent != nil .AND. ValType( ::Parent:FontColor ) $ "ANCM"
      // Parent form
      ::FontColor := ::Parent:FontColor
   else
       // Default
   endif

Return Self

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
      If HB_IsBlock( bAction )
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
Local bCode
   bCode := _OOHG_SetKey( ::aKeys, nKey, nFlags )
   If PCOUNT() > 2
      _OOHG_SetKey( ::aKeys, nKey, nFlags, bAction )
   EndIf
Return bCode

*-----------------------------------------------------------------------------*
METHOD AcceleratorKey( nKey, nFlags, bAction ) CLASS TWindow
*-----------------------------------------------------------------------------*
Local nPos, nId, uRet := nil
   nPos := ASCAN( ::aAcceleratorKeys, { |a| a[ HOTKEY_KEY ] == nKey .AND. a[ HOTKEY_MOD ] == nFlags } )
   If nPos > 0
      uRet := ::aAcceleratorKeys[ nPos ][ HOTKEY_ACTION ]
   EndIf
   If PCOUNT() > 2
      If HB_IsBlock( bAction )
         If nPos > 0
            ::aAcceleratorKeys[ nPos ][ HOTKEY_ACTION ] := bAction
         Else
            nId := _GetId()
            AADD( ::aAcceleratorKeys, { nId, nFlags, nKey, bAction } )
            InitHotKey( ::hWnd, nFlags, nKey, nId )
         EndIf
      Else
         If nPos > 0
            ReleaseHotKey( ::hWnd, ::aAcceleratorKeys[ nPos ][ HOTKEY_ID ] )
            _OOHG_DeleteArrayItem( ::aAcceleratorKeys, nPos )
         EndIf
      Endif
   EndIf
Return uRet

*-----------------------------------------------------------------------------*
METHOD LookForKey( nKey, nFlags ) CLASS TWindow
*-----------------------------------------------------------------------------*
Local lDone
   If ::Active .AND. LookForKey_Check_HotKey( ::aKeys, nKey, nFlags, Self )
      lDone := .T.
   ElseIf ::Active .AND. LookForKey_Check_bKeyDown( ::bKeyDown, nKey, nFlags, Self )
      lDone := .T.
   ElseIf HB_IsObject( ::Container )
      lDone := ::Container:LookForKey( nKey, nFlags )
   ElseIf HB_IsObject( ::Parent ) .AND. ::lInternal
      lDone := ::Parent:LookForKey( nKey, nFlags )
   Else
      If LookForKey_Check_HotKey( _OOHG_HotKeys, nKey, nFlags, TForm() )
         lDone := .T.
      ElseIf LookForKey_Check_bKeyDown( _OOHG_bKeyDown, nKey, nFlags, TForm() )
         lDone := .T.
      Else
         lDone := .F.
      EndIf
   EndIf
Return lDone

STATIC FUNCTION LookForKey_Check_HotKey( aKeys, nKey, nFlags, Self )
Local nPos, lDone
   nPos := ASCAN( aKeys, { |a| a[ HOTKEY_KEY ] == nKey .AND. nFlags == a[ HOTKEY_MOD ] } )
   If nPos > 0
      ::DoEvent( aKeys[ nPos ][ HOTKEY_ACTION ], "HOTKEY", { nKey, nFlags } )
      lDone := .T.
   Else
      lDone := .F.
   EndIf
Return lDone

STATIC FUNCTION LookForKey_Check_bKeyDown( bKeyDown, nKey, nFlags, Self )
Local lDone
   If HB_IsBlock( bKeyDown )
      lDone := ::DoEvent( bKeyDown, "KEYDOWN", { nKey, nFlags } )
      If !HB_IsLogical( lDone )
         lDone := .F.
      EndIf
   Else
      lDone := .F.
   EndIf
Return lDone

*-----------------------------------------------------------------------------*
METHOD ReleaseAttached() CLASS TWindow
*-----------------------------------------------------------------------------*

   // Release hot keys
   aEval( ::aHotKeys, { |a| ReleaseHotKey( ::hWnd, a[ HOTKEY_ID ] ) } )
   ::aHotKeys := {}
   aEval( ::aAcceleratorKeys, { |a| ReleaseHotKey( ::hWnd, a[ HOTKEY_ID ] ) } )
   ::aAcceleratorKeys := {}

   // Remove Child Controls
   DO WHILE LEN( ::aControls ) > 0
      ::aControls[ 1 ]:Release()
   ENDDO

Return nil

*------------------------------------------------------------------------------*
METHOD Visible( lVisible ) CLASS TWindow
*------------------------------------------------------------------------------*
   If HB_IsLogical( lVisible )
      ::lVisible := lVisible
      If ::ContainerVisible
         CShowControl( ::hWnd )
      Else
         HideWindow( ::hWnd )
      EndIf

      ProcessMessages()    //// ojo con esto

      //CGR
      ::CheckClientsPos()
  
   EndIf
Return ::lVisible

*------------------------------------------------------------------------------*
METHOD GetTextWidth( cString ) CLASS TWindow
*------------------------------------------------------------------------------*
Return GetTextWidth( nil, cString, ::FontHandle )

*------------------------------------------------------------------------------*
METHOD GetTextHeight( cString ) CLASS TWindow
*------------------------------------------------------------------------------*
Return GetTextHeight( nil, cString, ::FontHandle )

*------------------------------------------------------------------------------*
METHOD ClientWidth( nWidth ) CLASS TWindow
*------------------------------------------------------------------------------*
LOCAL aClientRect

   If HB_IsNumeric( nWidth )
      aClientRect := { 0, 0, 0, 0 }
      GetClientRect( ::hWnd, aClientRect )
      ::Width := ::Width - ( aClientRect[ 3 ] - aClientRect[ 1 ] ) + nWidth
   EndIf

   // Window may be greater than requested width... verify it again
   aClientRect := { 0, 0, 0, 0 }
   GetClientRect( ::hWnd, aClientRect )
Return aClientRect[ 3 ] - aClientRect[ 1 ]

*------------------------------------------------------------------------------*
METHOD ClientHeight( nHeight ) CLASS TWindow
*------------------------------------------------------------------------------*
LOCAL aClientRect

   If HB_IsNumeric( nHeight )
      aClientRect := { 0, 0, 0, 0 }
      GetClientRect( ::hWnd, aClientRect )
      ::Height := ::Height - ( aClientRect[ 4 ] - aClientRect[ 2 ] ) + nHeight
   EndIf

   // Window may be greater than requested height... verify it again
   aClientRect := { 0, 0, 0, 0 }
   GetClientRect( ::hWnd, aClientRect )
Return aClientRect[ 4 ] - aClientRect[ 2 ]

*------------------------------------------------------------------------------*
METHOD AdjustResize( nDivh, nDivw, lSelfOnly ) CLASS TWindow
*------------------------------------------------------------------------------*
LOCAL nFixedHeightUsed
   IF ::lAdjust
      //// nFixedHeightUsed = pixels used by non-scalable elements inside client area
      IF ::container == nil
         nFixedHeightUsed := ::parent:nFixedHeightUsed
      ELSE
         nFixedHeightUsed := ::container:nFixedHeightUsed
      ENDIF

      ::Sizepos( ( ::Row - nFixedHeightUsed ) * nDivh + nFixedHeightUsed, ::Col * nDivw )

      IF _OOHG_adjustWidth
         IF ! ::lFixWidth
            ::Sizepos( , , ::width * nDivw, ::height * nDivh )

            IF  _OOHG_adjustFont
                IF ! ::lFixFont
                   ::fontsize := ::fontsize * nDivw
                ENDIF
            ENDIF
         ENDIF
      ENDIF

      IF ! HB_IsLogical( lSelfOnly ) .OR. ! lSelfOnly
         AEVAL( ::aControls, { |o| o:AdjustResize( nDivh, nDivw ) } )
      ENDIF
   ENDIF
Return nil

*------------------------------------------------------------------------------*
METHOD Anchor( xAnchor ) CLASS TWindow
*------------------------------------------------------------------------------*
LOCAL nTop, nLeft, nBottom, nRight
   If HB_IsNumeric( xAnchor )
      ::nAnchor := INT( xAnchor ) % 16
   ElseIf HB_IsString( xAnchor )
      xAnchor := UPPER( ALLTRIM( xAnchor ) )
      If xAnchor == "NONE"
         ::nAnchor := 0
      ElseIf xAnchor == "ALL"
         ::nAnchor := 16
      Else
         nTop := nLeft := nBottom := nRight := 0
         DO WHILE ! EMPTY( xAnchor )
            If     LEFT( xAnchor, 3 ) == "TOP"
               nTop := 1
               xAnchor := SUBSTR( xAnchor, 4 )
            ElseIf LEFT( xAnchor, 4 ) == "LEFT"
               nLeft := 2
               xAnchor := SUBSTR( xAnchor, 5 )
            ElseIf LEFT( xAnchor, 6 ) == "BOTTOM"
               nBottom := 4
               xAnchor := SUBSTR( xAnchor, 7 )
            ElseIf LEFT( xAnchor, 5 ) == "RIGHT"
               nRight := 8
               xAnchor := SUBSTR( xAnchor, 6 )
            Else
               nTop := ::nAnchor
               nLeft := nBottom := nRight := 0
               EXIT
            EndIf
         ENDDO
         ::nAnchor := nTop + nLeft + nBottom + nRight
      EndIf
   EndIf
Return ::nAnchor

*------------------------------------------------------------------------------*
METHOD AdjustAnchor( nDeltaH, nDeltaW ) CLASS TWindow
*------------------------------------------------------------------------------*
LOCAL nAnchor, lTop, lLeft, lBottom, lRight, nRow, nCol, nWidth, nHeight, lChange
   If ::nAnchor == NIL
      Return nil
   EndIf
   nAnchor := INT( ::nAnchor ) % 16
   If nAnchor != 3 .AND. ( nDeltaH != 0 .OR. nDeltaW != 0 )
      lTop    := ( ( nAnchor %  2 ) >= 1 )
      lLeft   := ( ( nAnchor %  4 ) >= 2 )
      lBottom := ( ( nAnchor %  8 ) >= 4 )
      lRight  := ( ( nAnchor % 16 ) >= 8 )
      nRow    := ::Row
      nCol    := ::Col
      nWidth  := ::Width
      nHeight := ::Height
      lChange := .F.
      // Height checking
      If nDeltaH == 0
         //
      ElseIf lTop .AND. lBottom
         nHeight += nDeltaH
         lChange := .T.
      ElseIf lBottom
         nRow += nDeltaH
         lChange := .T.
      ElseIf ! lTop
         nRow += ( nDeltaH / 2 )
         lChange := .T.
      EndIf
      // Width checking
      If nDeltaW == 0
         //
      ElseIf lLeft .AND. lRight
         nWidth += nDeltaW
         lChange := .T.
      ElseIf lRight
         nCol += nDeltaW
         lChange := .T.
      ElseIf ! lLeft
         nCol += ( nDeltaW / 2 )
         lChange := .T.
      EndIf
      // Any change?
      If lChange
         ::SizePos( nRow, nCol, nWidth, nHeight )
      EndIf
   EndIf
Return nil

//CGR - metodo insertado
*------------------------------------------------------------------------------*
METHOD CheckClientsPos() CLASS TWindow
*------------------------------------------------------------------------------*
   If ::ClientAdjust > 0
      If ::Container != NIL
         ::Container:ClientsPos()
      ElseIf ::Parent != NIL
         ::Parent:ClientsPos()
      EndIf
   EndIf
Return nil

*------------------------------------------------------------------------------*
METHOD ClientsPos() CLASS TWindow
*------------------------------------------------------------------------------*
Return ::ClientsPos2( ::aControls, ::Width, ::Height )

*------------------------------------------------------------------------------*
METHOD ClientsPos2( aControls, nWidth, nHeight ) CLASS TWindow
*------------------------------------------------------------------------------*
// ajusta los controles dentro de la ventana por ClientAdjust
local n, nAdjust, oControl, nRow := 0, nCol := 0
local nOffset // desplazamientos por borde


   If ::IsAdjust
      Return self
   EndIf
   nOffSet := ::nBorders[1]+::nBorders[2]+::nBorders[3]
   nOffset  := if ( nOffset>0,nOffset+1,0)
   nRow:=nOffset
   nCol:=nOffset
   nWidth:=nWidth-2*nOffset
   nHeight:=nHeight-2*nOffset
   ::IsAdjust := .T.
   // remove toolbar .and. statusbar
   for n:=1 to len(aControls)
		if aControls[n]:type="TOOLBAR"
			if aControls[n]:ltop
				nRow+=aControls[n]:ClientHeightUsed()
				nHeight-=aControls[n]:ClientHeightUsed()
			else
				nHeight-=aControls[n]:ClientHeightUsed()
			end
		elseif aControls[n]:type="MESSAGEBAR"
		    nHeight+=aControls[n]:ClientHeightUsed()
		end
   next
   // nCol := ::Height - GetStatusbarHeight( ::name ) - GetTitleHeight() - 2 * GetBorderHeight()
   For n := 1 to len( aControls )
      oControl := aControls[ n ]
      nAdjust := oControl:ClientAdjust
      If nAdjust > 0 .and. nAdjust < 5 .and. aControls[ n ]:ContainerVisible
		oControl:Hide()
         If nAdjust == 1 // top
            oControl:Col := nCol
            oControl:Row := nRow
            oControl:Width := nWidth
            nRow := nRow + oControl:nHeight
            nHeight := nHeight - oControl:nHeight
         ElseIf nAdjust == 2 // bottom
            oControl:Col := nCol
            oControl:Row := nHeight - oControl:nHeight + nRow
            oControl:Width:=nWidth
            nHeight := nHeight - oControl:nHeight
         ElseIf nAdjust == 3 //left
            oControl:Col := nCol
            oControl:Row := nRow
            oControl:Height := nHeight
            nCol := nCol + oControl:nWidth
            nWidth := nWidth - oControl:nWidth
         ElseIf nAdjust == 4 //right
            oControl:Col := nWidth - oControl:nWidth + nCol
            oControl:Row := nRow
            oControl:Height := nHeight
            nWidth := nWidth - oControl:nWidth
         EndIf
         
         //oControl:SizePos()
         oControl:Show()
      EndIf
   Next
   For n := 1 to len( aControls )
      If aControls[ n ]:ClientAdjust == 5 .and. aControls[ n ]:Visible
         aControls[ n ]:Hide()
         //aControls[ n ]:SizePos( nRow, nCol, nWidth - 2, nHeight - 2 )
		 aControls[n]:width:=nWidth -2
		 aControls[n]:height:=nHeight -2
		 aControls[n]:col:=nCol
		 aControls[n]:row:=nRow
         aControls[ n ]:Show()
      EndIf
   Next
   ::IsAdjust := .F.
Return nil

*------------------------------------------------------------------------------*
METHOD Adjust( nAdjust ) CLASS TWindow
*------------------------------------------------------------------------------*
Local Adjustpos
   If PCOUNT() > 0
      If HB_IsString( nAdjust )
         AdjustPos := upper( alltrim( nAdjust ) )
         If AdjustPos == 'TOP'
            ::ClientAdjust := 1
         Elseif AdjustPos == 'BOTTOM'
            ::ClientAdjust := 2
         Elseif AdjustPos == 'LEFT'
            ::ClientAdjust := 3
         Elseif AdjustPos == 'RIGHT'
            ::ClientAdjust := 4
         Elseif AdjustPos == 'CLIENT'
            ::ClientAdjust := 5
         EndIf
         * ::nHeight := ::nWidth  // ???
      ElseIf hb_IsNumeric( nAdjust )
         If nAdjust <> ::ClientAdjust
            ::ClientAdjust := nAdjust
            ::CheckClientsPos()
         EndIf
      EndIf
   EndIf
Return ::ClientAdjust

*------------------------------------------------------------------------------*
METHOD GetMaxCharsInWidth( cString, nWidth ) CLASS TWindow
*------------------------------------------------------------------------------*
Local nChars, nMin, nMax, nSize
   If ! VALTYPE( cString ) $ "CM" .OR. LEN( cString ) == 0 .OR. ! HB_ISNUMERIC( nWidth ) .OR. nWidth <= 0
      nChars := 0
   Else
      nSize := ::GetTextWidth( cString )
      nMax := LEN( cString )
      If nSize <= nWidth
         nChars := nMax
      Else
         nMin := 0
         Do While nMax != nMin + 1
            nChars := INT( ( nMin + nMax ) / 2 )
            nSize := ::GetTextWidth( LEFT( cString, nChars ) )
            If nSize <= nWidth
               nMin := nChars
            Else
               nMax := nChars
            EndIf
         EndDo
         nChars := nMin
      EndIf
   EndIf
Return nChars

*------------------------------------------------------------------------------*
METHOD DebugMessageName( nMsg ) CLASS TWindow
*------------------------------------------------------------------------------*
STATIC aNames := NIL
LOCAL cName
   IF aNames == NIL
      aNames := { "WM_CREATE", "WM_DESTROY", "WM_MOVE", NIL, "WM_SIZE", ;
                  "WM_ACTIVATE", "WM_SETFOCUS", "WM_KILLFOCUS", NIL, "WM_ENABLE", ;
                  "WM_SETREDRAW", "WM_SETTEXT", "WM_GETTEXT", "WM_GETTEXTLENGTH", "WM_PAINT", ;
                  "WM_CLOSE", "WM_QUERYENDSESSION", "WM_QUIT", "WM_QUERYOPEN", "WM_ERASEBKGND", ;
                  "WM_SYSCOLORCHANGE", "WM_ENDSESSION", NIL, "WM_SHOWWINDOW", NIL, ;
                  "WM_WININICHANGE", "WM_DEVMODECHANGE", "WM_ACTIVATEAPP", "WM_FONTCHANGE", "WM_TIMECHANGE", ;
                  "WM_CANCELMODE", "WM_SETCURSOR", "WM_MOUSEACTIVATE", "WM_CHILDACTIVATE", "WM_QUEUESYNC", ;
                  "WM_GETMINMAXINFO", NIL, "WM_PAINTICON", "WM_ICONERASEBKGND", "WM_NEXTDLGCTL", ;
                  NIL, "WM_SPOOLERSTATUS", "WM_DRAWITEM", "WM_MEASUREITEM", "WM_DELETEITEM", ;
                  "WM_VKEYTOITEM", "WM_CHARTOITEM", "WM_SETFONT", "WM_GETFONT", "WM_SETHOTKEY", ;
                  "WM_GETHOTKEY", NIL, NIL, NIL, "WM_QUERYDRAGICON", ;
                  NIL, "WM_COMPAREITEM", NIL, NIL, NIL, ;
                  "WM_GETOBJECT", NIL, NIL, NIL, "WM_COMPACTING", ;
                  NIL, NIL, "WM_COMMNOTIFY", NIL, "WM_WINDOWPOSCHANGING", ;
                  "WM_WINDOWPOSCHANGED", "WM_POWER", NIL, "WM_COPYDATA", "WM_CANCELJOURNAL", ;
                  NIL, NIL, "WM_NOTIFY", NIL, "WM_INPUTLANGCHANGEREQUEST", ;
                  "WM_INPUTLANGCHANGE", "WM_TCARD", "WM_HELP", "WM_USERCHANGED", "WM_NOTIFYFORMAT", ;
                  NIL, NIL, NIL, NIL, NIL, ;
                  NIL, NIL, NIL, NIL, NIL, ;
                  NIL, NIL, NIL, NIL, NIL, ;
                  NIL, NIL, NIL, NIL, NIL, ;
                  NIL, NIL, NIL, NIL, NIL, ;
                  NIL, NIL, NIL, NIL, NIL, ;
                  NIL, NIL, NIL, NIL, NIL, ;
                  NIL, NIL, "WM_CONTEXTMENU", "WM_STYLECHANGING", "WM_STYLECHANGED", ;
                  "WM_DISPLAYCHANGE", "WM_GETICON", "WM_SETICON", "WM_NCCREATE", "WM_NCDESTROY", ;
                  "WM_NCCALCSIZE", "WM_NCHITTEST", "WM_NCPAINT", "WM_NCACTIVATE", "WM_GETDLGCODE", ;
                  "WM_SYNCPAINT", NIL, NIL, NIL, NIL, ;
                  NIL, NIL, NIL, NIL, NIL, ;
                  NIL, NIL, NIL, NIL, NIL, ;
                  NIL, NIL, NIL, NIL, NIL, ;
                  NIL, NIL, NIL, NIL, "WM_NCMOUSEMOVE", ;
                  "WM_NCLBUTTONDOWN", "WM_NCLBUTTONUP", "WM_NCLBUTTONDBLCLK", "WM_NCRBUTTONDOWN", "WM_NCRBUTTONUP", ;
                  "WM_NCRBUTTONDBLCLK", "WM_NCMBUTTONDOWN", "WM_NCMBUTTONUP", "WM_NCMBUTTONDBLCLK", NIL, ;
                  "WM_NCXBUTTONDOWN", "WM_NCXBUTTONUP", "WM_NCXBUTTONDBLCLK" }
      ASIZE( aNames, 1024 )

      AEVAL( { "WM_KEYFIRST", ;
               "WM_KEYUP", "WM_CHAR", "WM_DEADCHAR", "WM_SYSKEYDOWN", "WM_SYSKEYUP", ;
               "WM_SYSCHAR", "WM_SYSDEADCHAR", "WM_KEYLAST", NIL, NIL, ;
               NIL, NIL, "WM_IME_STARTCOMPOSITION", "WM_IME_ENDCOMPOSITION", "WM_IME_COMPOSITION", ;
               "WM_INITDIALOG", "WM_COMMAND", "WM_SYSCOMMAND", "WM_TIMER", "WM_HSCROLL", ;
               "WM_VSCROLL", "WM_INITMENU", "WM_INITMENUPOPUP", NIL, NIL, ;
               NIL, NIL, NIL, NIL, NIL, ;
               "WM_MENUSELECT", "WM_MENUCHAR", "WM_ENTERIDLE", "WM_MENURBUTTONUP", "WM_MENUDRAG", ;
               "WM_MENUGETOBJECT", "WM_UNINITMENUPOPUP", "WM_MENUCOMMAND", "WM_CHANGEUISTATE", "WM_UPDATEUISTATE", ;
               "WM_QUERYUISTATE", NIL, NIL, NIL, NIL, ;
               NIL, NIL, NIL, NIL, "WM_CTLCOLORMSGBOX", ;
               "WM_CTLCOLOREDIT", "WM_CTLCOLORLISTBOX", "WM_CTLCOLORBTN", "WM_CTLCOLORDLG", "WM_CTLCOLORSCROLLBAR", ;
               "WM_CTLCOLORSTATIC" }, ;
             { |c,i| aNames[ i + 0x0FF ] := c } )

      AEVAL( { "WM_MOUSEMOVE", ;
               "WM_LBUTTONDOWN", "WM_LBUTTONUP", "WM_LBUTTONDBLCLK", "WM_RBUTTONDOWN", "WM_RBUTTONUP", ;
               "WM_RBUTTONDBLCLK", "WM_MBUTTONDOWN", "WM_MBUTTONUP", "WM_MBUTTONDBLCLK", "WM_MOUSEWHEEL", ;
               "WM_XBUTTONDOWN", "WM_XBUTTONUP", "WM_XBUTTONDBLCLK", NIL, NIL, ;
               "WM_PARENTNOTIFY", "WM_ENTERMENULOOP", "WM_EXITMENULOOP", "WM_NEXTMENU", "WM_SIZING", ;
               "WM_CAPTURECHANGED", "WM_MOVING", NIL, "WM_POWERBROADCAST", "WM_DEVICECHANGE", ;
               NIL, NIL, NIL, NIL, NIL, ;
               NIL, "WM_MDICREATE", "WM_MDIDESTROY", "WM_MDIACTIVATE", "WM_MDIRESTORE", ;
               "WM_MDINEXT", "WM_MDIMAXIMIZE", "WM_MDITILE", "WM_MDICASCADE", "WM_MDIICONARRANGE", ;
               "WM_MDIGETACTIVE", NIL, NIL, NIL, NIL, ;
               NIL, NIL, "WM_MDISETMENU", "WM_ENTERSIZEMOVE", "WM_EXITSIZEMOVE", ;
               "WM_DROPFILES", "WM_MDIREFRESHMENU" }, ;
             { |c,i| aNames[ i + 0x1FF ] := c } )

      AEVAL( { "WM_IME_SETCONTEXT", "WM_IME_NOTIFY", "WM_IME_CONTROL", "WM_IME_COMPOSITIONFULL", "WM_IME_SELECT", ;
               "WM_IME_CHAR", NIL, "WM_IME_REQUEST", NIL, NIL, ;
               NIL, NIL, NIL, NIL, NIL, ;
               "WM_IME_KEYDOWN", "WM_IME_KEYUP", NIL, NIL, NIL, ;
               NIL, NIL, NIL, NIL, NIL, ;
               NIL, NIL, NIL, NIL, NIL, ;
               NIL, "WM_NCMOUSEHOVER", "WM_MOUSEHOVER", "WM_NCMOUSELEAVE", "WM_MOUSELEAVE" }, ;
             { |c,i| aNames[ i + 0x280 ] := c } )

      AEVAL( { "WM_CUT", ;
               "WM_COPY", "WM_PASTE", "WM_CLEAR", "WM_UNDO", "WM_RENDERFORMAT", ;
               "WM_RENDERALLFORMATS", "WM_DESTROYCLIPBOARD", "WM_DRAWCLIPBOARD", "WM_PAINTCLIPBOARD", "WM_VSCROLLCLIPBOARD", ;
               "WM_SIZECLIPBOARD", "WM_ASKCBFORMATNAME", "WM_CHANGECBCHAIN", "WM_HSCROLLCLIPBOARD", "WM_QUERYNEWPALETTE", ;
               "WM_PALETTEISCHANGING", "WM_PALETTECHANGED", "WM_HOTKEY", NIL, NIL, ;
               NIL, NIL, "WM_PRINT", "WM_PRINTCLIENT", "WM_APPCOMMAND" }, ;
             { |c,i| aNames[ i + 0x2FF ] := c } )

      aNames[ 0x358 ] := "WM_HANDHELDFIRST"
      aNames[ 0x35F ] := "WM_HANDHELDLAST"
      aNames[ 0x360 ] := "WM_AFXFIRST"
      aNames[ 0x37F ] := "WM_AFXLAST"
      aNames[ 0x380 ] := "WM_PENWINFIRST"
      aNames[ 0x38F ] := "WM_PENWINLAST"

      aNames[ 0x400 ] := "WM_USER"

      // Edit control messages
      AEVAL( { "EM_GETSEL", ;
               "EM_SETSEL", "EM_GETRECT", "EM_SETRECT", "EM_SETRECTNP", "EM_SCROLL", ;
               "EM_LINESCROLL", "EM_SCROLLCARET", "EM_GETMODIFY", "EM_SETMODIFY", "EM_GETLINECOUNT", ;
               "EM_LINEINDEX", "EM_SETHANDLE", "EM_GETHANDLE", "EM_GETTHUMB", NIL, ;
               NIL, "EM_LINELENGTH", "EM_REPLACESEL", NIL, "EM_GETLINE", ;
               "EM_SETLIMITTEXT", "EM_CANUNDO", "EM_UNDO", "EM_FMTLINES", "EM_LINEFROMCHAR", ;
               NIL, "EM_SETTABSTOPS", "EM_SETPASSWORDCHAR", "EM_EMPTYUNDOBUFFER", "EM_GETFIRSTVISIBLELINE", ;
               "EM_SETREADONLY", "EM_SETWORDBREAKPROC", "EM_GETWORDBREAKPROC", "EM_GETPASSWORDCHAR", "EM_SETMARGINS", ;
               "EM_GETMARGINS", "EM_GETLIMITTEXT", "EM_POSFROMCHAR", "EM_CHARFROMPOS", "EM_SETIMESTATUS", ;
               "EM_GETIMESTATUS" }, ;
             { |c,i| aNames[ i + 0xAF ] := c } )

      // Scroll bar messages
      AEVAL( { "SBM_SETPOS", ;
               "SBM_GETPOS", "SBM_SETRANGE", "SBM_GETRANGE", "SBM_ENABLE_ARROWS", NIL, ;
               "SBM_SETRANGEREDRAW", NIL, NIL, "SBM_SETSCROLLINFO", "SBM_GETSCROLLINFO" }, ;
             { |c,i| aNames[ i + 0xDF ] := c } )

      // Button control messages
      AEVAL( { "BM_GETCHECK", ;
               "BM_SETCHECK", "BM_GETSTATE", "BM_SETSTATE", "BM_SETSTYLE", "BM_CLICK", ;
               "BM_GETIMAGE", "BM_SETIMAGE" }, ;
             { |c,i| aNames[ i + 0xEF ] := c } )

      // Static control messages
      AEVAL( { "STM_SETICON", ;
               "STM_GETICON", "STM_SETIMAGE", "STM_GETIMAGE", "STM_MSGMAX" }, ;
             { |c,i| aNames[ i + 0x16F ] := c } )
   ENDIF
   IF nMsg == 0
      cName := "WM_NULL"
   ELSEIF LEN( aNames ) >= nMsg .AND. aNames[ nMsg ] != NIL
      cName := aNames[ nMsg ]
   ELSE
      cName := "(unknown_" + _OOHG_HEX( nMsg ) + ")"
   ENDIF
RETURN cName

*------------------------------------------------------------------------------*
METHOD DebugMessageQuery( nMsg, wParam, lParam ) CLASS TWindow
*------------------------------------------------------------------------------*
LOCAL cValue, oControl
   IF nMsg == WM_COMMAND
      oControl := GetControlObjectById( LOWORD( wParam ) )
      IF oControl:Id == 0
         oControl := GetControlObjectByHandle( lParam )
      ENDIF
      cValue := ::Name + "." + oControl:Name + ": WM_COMMAND." + ;
                oControl:DebugMessageNameCommand( HIWORD( wParam ) )
   ELSEIF nMsg == WM_NOTIFY
      cValue := GetControlObjectByHandle( GethWndFrom( lParam ) ):DebugMessageQueryNotify( ::Name, wParam, lParam )
   ELSEIF nMsg == WM_CTLCOLORBTN
      oControl := GetControlObjectByHandle( lParam )
      cValue := ::Name + "." + oControl:Name + ": WM_CTLCOLORBTN   0x" + _OOHG_HEX( wParam, 8 )
                oControl:DebugMessageNameCommand( HIWORD( wParam ) )
   ELSEIF nMsg == WM_CTLCOLORSTATIC
      oControl := GetControlObjectByHandle( lParam )
      cValue := ::Name + "." + oControl:Name + ": WM_CTLCOLORSTATIC   0x" + _OOHG_HEX( wParam, 8 )
                oControl:DebugMessageNameCommand( HIWORD( wParam ) )
   ELSEIF nMsg == WM_CTLCOLOREDIT
      oControl := GetControlObjectByHandle( lParam )
      cValue := ::Name + "." + oControl:Name + ": WM_CTLCOLOREDIT   0x" + _OOHG_HEX( wParam, 8 )
                oControl:DebugMessageNameCommand( HIWORD( wParam ) )
   ELSEIF nMsg == WM_CTLCOLORLISTBOX
      oControl := GetControlObjectByHandle( lParam )
      cValue := ::Name + "." + oControl:Name + ": WM_CTLCOLORLISTBOX   0x" + _OOHG_HEX( wParam, 8 )
   ELSE
      cValue := IF( ::lForm, "", ::Parent:Name + "." ) + ::Name + ": " + ;
                "(0x" + _OOHG_HEX( nMsg, 4 ) + ") " + ::DebugMessageName( nMsg ) + ;
                " 0x" + _OOHG_HEX( wParam, 8 ) + " 0x" + _OOHG_HEX( lParam, 8 )
   ENDIF
RETURN cValue

*------------------------------------------------------------------------------*
METHOD DebugMessageNameCommand( nCommand ) CLASS TWindow
*------------------------------------------------------------------------------*
RETURN _OOHG_HEX( nCommand, 4 )

*------------------------------------------------------------------------------*
METHOD DebugMessageNameNotify( nNotify ) CLASS TWindow
*------------------------------------------------------------------------------*
LOCAL cName
STATIC aNames := NIL
   IF aNames == NIL
      aNames := { "NM_OUTOFMEMORY", "NM_CLICK", "NM_DBLCLK", "NM_RETURN", "NM_RCLICK", ;
                  "NM_RDBLCLK", "NM_SETFOCUS", "NM_KILLFOCUS", NIL, NIL, ;
                  NIL, "NM_CUSTOMDRAW", "NM_HOVER", "NM_NCHITTEST", "NM_KEYDOWN", ;
                  "NM_RELEASEDCAPTURE", "NM_SETCURSOR", "NM_CHAR", "NM_TOOLTIPSCREATED", "NM_LDOWN", ;
                  "NM_RDOWN" }
      ASIZE( aNames, 200 )

      // Scroll bar messages
      AEVAL( { "LVN_ITEMCHANGING", ;
               "LVN_ITEMCHANGED", "LVN_INSERTITEM", "LVN_DELETEITEM", "LVN_DELETEALLITEMS", "LVN_BEGINLABELEDITA", ;
               "LVN_ENDLABELEDITA", NIL, "LVN_COLUMNCLICK", "LVN_BEGINDRAG", NIL, ;
               "LVN_BEGINRDRAG", NIL, "LVN_ODCACHEHINT", "LVN_ITEMACTIVATE", "LVN_ODSTATECHANGED", ;
               NIL, NIL, NIL, NIL, NIL, ;
               "LVN_HOTTRACK", NIL, NIL, NIL, NIL, ;
               NIL, NIL, NIL, NIL, NIL, ;
               NIL, NIL, NIL, NIL, NIL, ;
               NIL, NIL, NIL, NIL, NIL, ;
               NIL, NIL, NIL, NIL, NIL, ;
               NIL, NIL, NIL, NIL, "LVN_GETDISPINFOA", ;
               "LVN_SETDISPINFOA", "LVN_ODFINDITEMA", NIL, NIL, "LVN_KEYDOWN", ;
               "LVN_MARQUEEBEGIN", "LVN_GETINFOTIPA", "LVN_GETINFOTIPW", NIL, NIL, ;
               NIL, NIL, NIL, NIL, NIL, ;
               NIL, NIL, NIL, NIL, NIL, ;
               NIL, NIL, NIL, NIL, "LVN_BEGINLABELEDITW", ;
               "LVN_ENDLABELEDITW", "LVN_GETDISPINFOW", "LVN_SETDISPINFOW", "LVN_ODFINDITEMW" }, ;
             { |c,i| aNames[ i + 99 ] := c } )
   ENDIF
   IF nNotify < 0
      nNotify := - nNotify
   ENDIF
   IF nNotify > 0 .AND. LEN( aNames ) >= nNotify .AND. aNames[ nNotify ] != NIL
      cName := aNames[ nNotify ]
   ELSE
      cName := _OOHG_HEX( 65536 - nNotify, 4 )
   ENDIF
RETURN cName

*------------------------------------------------------------------------------*
METHOD DebugMessageQueryNotify( cParentName, wParam, lParam ) CLASS TWindow
*------------------------------------------------------------------------------*
LOCAL cValue
   EMPTY( wParam )
   cValue := cParentName + "." + ;
             IF( EMPTY( ::Name ), _OOHG_HEX( GethWndFrom( lParam ), 8 ), ::Name ) + ;
             ": WM_NOTIFY." + ::DebugMessageNameNotify( GetNotifyCode( lParam ) )
RETURN cValue

//CGR
*-----------------------------------------------------------------------------*
METHOD LINE(nRow ,nCol ,nToRow ,nToCol ,nWidth ,aColor, nStyle ) CLASS TWindow
*-----------------------------------------------------------------------------*
	default aColor to {0,0,0}
	default nWidth to 1
	::GetDc()
	c_Line(::hdc,nRow ,nCol ,nToRow ,nToCol ,nWidth ,aColor[1] ;
		,aColor[2] ,aColor[3] ,.t. ,.t., !empty(nStyle) ,nStyle )
	::ReleaseDc()
return nil	

*------------------------------------------------------------------------------*
METHOD FILL(nRow , nCol , nToRow , nToCol , aColor) Class TWindow
*------------------------------------------------------------------------------*

	default aColor to {0,0,0}
	::GetDc()
    C_FILL(::Hdc ,nRow ,nCol ,nToRow ,nToCol ,aColor[1] ,aColor[2] ,aColor[3] , .t. )
	::ReleaseDc()
Return nil

*------------------------------------------------------------------------------*
METHOD Box (nRow ,nCol ,nToRow ,nToCol ,nWidth , aColor, ;
	nStyle, nBrStyle, aBrColor) CLASS TWindow
*------------------------------------------------------------------------------*
local lBrColor

	default aColor to {0,0,0}
	default nWidth to 1

	if empty(aBrColor)
		aBrColor:={0,0,0}
		lBrColor:=.f.
	else
		lBrColor:=.t.
	end
	
	::GetDc()
    C_RECTANGLE(::Hdc ,nRow ,nCol ,nToRow ,nToCol ,nWidth ,;
		aColor[1] ,aColor[2] ,aColor[3] ,.t. ,.t., !empty(nStyle) ,nStyle , !empty(nBrStyle),;
		nBrStyle, lBrColor , aBrColor[1],aBrColor[2],aBrColor[3]  )
	::ReleaseDc()
Return nil

*------------------------------------------------------------------------------*
METHOD ROUNDbox (nRow ,nCol ,nToRow ,nToCol ,nWidth , aColor, lStyle, ;
	nStyle, nBrStyle, aBrColor ) CLASS tWindow
*------------------------------------------------------------------------------*
local lBrushColor

   EMPTY( lStyle )

	default aColor to {0,0,0}
	default nWidth to 1

	if empty(aBrColor)
		aBrColor:={0,0,0}
		lBrushColor:=.f.
	else
		lBrushColor:=.t.
	end
	
	::GetDc()
    C_ROUNDRECTANGLE(::Hdc ,nRow ,nCol ,nToRow ,nToCol ,nWidth ,;
		aColor[1] ,aColor[2] ,aColor[3] ,.t. ,.t., !empty(nStyle),nStyle ,!empty(nBrStyle),;
		nBrStyle, lBrushColor, aBrColor[1],aBrColor[2],aBrColor[3] )
	::ReleaseDc()
	
Return nil


*------------------------------------------------------------------------------*
METHOD Ellipse (nRow ,nCol ,nToRow ,nToCol ,nWidth , aColor, lStyle, ;
	nStyle, nBrStyle, aBrColor ) CLASS tWindow
*------------------------------------------------------------------------------*
local lBrushColor

   EMPTY( lStyle )

	default aColor to {0,0,0}
	default nWidth to 1

	if empty(aBrColor)
		aBrColor:={0,0,0}
		lBrushColor:=.f.
	else
		lBrushColor:=.t.
	end
	
	::GetDc()
    C_ELLIPSE(::Hdc ,nRow ,nCol ,nToRow ,nToCol ,nWidth ,;
		aColor[1] ,aColor[2] ,aColor[3] ,.t. ,.t., !empty(nStyle),nStyle ,!empty(nBrStyle),;
		nBrStyle, lBrushColor, aBrColor[1],aBrColor[2],aBrColor[3] )
	::ReleaseDc()
	
Return nil

*-----------------------------------------------------------------------------*
METHOD Arc(nRow ,nCol ,nToRow ,nToCol,X1,Y1,X2,Y2 ,nWidth ,aColor, nStyle ) CLASS TWindow
*-----------------------------------------------------------------------------*
	default aColor to {0,0,0}
	default nWidth to 1
	::GetDc()
	c_arc(::hdc,nRow ,nCol ,nToRow ,nToCol,X1,Y1,X2,Y2,nWidth ,aColor[1] ;
		,aColor[2] ,aColor[3] ,.t. ,.t., !empty(nStyle) ,nStyle )
	::ReleaseDc()
return nil	

*------------------------------------------------------------------------------*
METHOD Pie(nRow ,nCol ,nToRow ,nToCol,x1,y1,x2,y2,nWidth , aColor, lStyle, ;
	nStyle, nBrStyle, aBrColor ) CLASS tWindow
*------------------------------------------------------------------------------*
local lBrushColor

   EMPTY( lStyle )

	default aColor to {0,0,0}
	default nWidth to 1

	if empty(aBrColor)
		aBrColor:={0,0,0}
		lBrushColor:=.f.
	else
		lBrushColor:=.t.
	end
	
	::GetDc()
    C_PIE(::Hdc ,nRow ,nCol ,nToRow ,nToCol ,x1 ,y1 ,x2 ,y2 ,nWidth ,;
		aColor[1] ,aColor[2] ,aColor[3] ,.t. ,.t., !empty(nStyle),nStyle ,!empty(nBrStyle),;
		nBrStyle, lBrushColor, aBrColor[1],aBrColor[2],aBrColor[3] )
	::ReleaseDc()
	
Return nil






#pragma BEGINDUMP
HB_FUNC( _OOHG_HEX )   // nNum, nDigits
{
   char cLine[ 50 ], cBuffer[ 50 ];
   unsigned int iNum;
   int iCount, iLen, iDigit;

   iCount = 0;
   iNum = ( unsigned int ) hb_parni( 1 );
   iLen = hb_parni( 2 );
   while( iNum )
   {
      iDigit = iNum & 0xF;
      if( iDigit > 9 )
      {
         iDigit += 7;
      }
      cBuffer[ iCount++ ] = '0' + iDigit;
      iNum = iNum >> 4;
   }
   if( ! iCount )
   {
      cBuffer[ iCount++ ] = '0';
   }
   if( iLen > 0 )
   {
      if( iLen > 45 )
      {
         iLen = 45;
      }
      while( iCount < iLen )
      {
         cBuffer[ iCount++ ] = '0';
      }
      iCount = iLen;
   }
   iLen = 0;
   while( iCount )
   {
      cLine[ iLen++ ] = cBuffer[ --iCount ];
   }
   hb_retclen( cLine, iLen );
}
#pragma ENDDUMP

*------------------------------------------------------------------------------*
FUNCTION _OOHG_AddFrame( oFrame )
*------------------------------------------------------------------------------*
   AADD( _OOHG_ActiveFrame, oFrame )
Return oFrame

*------------------------------------------------------------------------------*
FUNCTION _OOHG_DeleteFrame( cType )
*------------------------------------------------------------------------------*
Local oCtrl
   If LEN( _OOHG_ActiveFrame ) == 0
      // ERROR: No FRAME started
      Return .F.
   EndIf
   oCtrl := ATAIL( _OOHG_ActiveFrame )
   If oCtrl:Type == cType
      ASIZE( _OOHG_ActiveFrame, LEN( _OOHG_ActiveFrame ) - 1 )
   Else
      // ERROR: No FRAME started
      Return .F.
   EndIf
Return .T.

*------------------------------------------------------------------------------*
FUNCTION _OOHG_LastFrame()
*------------------------------------------------------------------------------*
Local cRet
   If LEN( _OOHG_ActiveFrame ) == 0
      cRet := ""
   Else
      cRet := ATAIL( _OOHG_ActiveFrame ):Type
   EndIf
Return cRet

#pragma BEGINDUMP
HB_FUNC( _OOHG_SELECTSUBCLASS ) // _OOHG_SelectSubClass( oClass, oSubClass )
{
   PHB_ITEM pRet, pCopy;

   pCopy = hb_itemNew( NULL );
   pRet = hb_param( 2, HB_IT_OBJECT );
   if( ! pRet )
   {
      pRet = hb_param( 1, HB_IT_ANY );
   }
   hb_itemCopy( pCopy, pRet );
   hb_itemReturn( pCopy );
   hb_itemRelease( pCopy );
// Return if( ValType( oSubClass ) == "O", oSubClass, oClass )
}
#pragma ENDDUMP

*-----------------------------------------------------------------------------*
Function InputBox ( cInputPrompt , cDialogCaption , cDefaultValue , nTimeout , cTimeoutValue , lMultiLine )
*-----------------------------------------------------------------------------*

	Local RetVal , mo

	DEFAULT cInputPrompt	TO ""
	DEFAULT cDialogCaption	TO ""
	DEFAULT cDefaultValue	TO ""

	RetVal := ''

   If HB_IsLogical (lMultiLine) .AND. lMultiLine
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

      ON KEY ESCAPE ACTION ( _OOHG_DialogCancelled := .T. , if(iswindowactive(_Inputbox), _InputBox.Release ,nil)   )

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
         ON ENTER ( _OOHG_DialogCancelled := .F. , RetVal := _InputBox._TextBox.Value , if(iswindowactive(_Inputbox), _InputBox.Release ,nil)   )

                endif
//
		@ 67+mo,120 BUTTON _Ok		;
			CAPTION if( Set ( _SET_LANGUAGE ) == 'ES', 'Aceptar' ,'Ok' )		;
         ACTION ( _OOHG_DialogCancelled := .F. , RetVal := _InputBox._TextBox.Value , if(iswindowactive(_Inputbox), _InputBox.Release ,nil)   )

		@ 67+mo,230 BUTTON _Cancel		;
			CAPTION if( Set ( _SET_LANGUAGE ) == 'ES', 'Cancelar', 'Cancel'	);
         ACTION   ( _OOHG_DialogCancelled := .T. , if(iswindowactive(_Inputbox), _InputBox.Release ,nil)   )

			If ValType (nTimeout) != 'U'

				If ValType (cTimeoutValue) != 'U'

					DEFINE TIMER _InputBox ;
					INTERVAL nTimeout ;
					ACTION  ( RetVal := cTimeoutValue , if(iswindowactive(_Inputbox), _InputBox.Release ,nil)   )

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
Local oCtrl, hControl

   hControl := GetNextDlgTabITem( GetActiveWindow(), GetFocus(), 0 )
   oCtrl := GetControlObjectByHandle( hControl )
   If oCtrl:hWnd == hControl
      oCtrl:SetFocus()
   Else
      InsertTab()
   EndIf

Return

*-----------------------------------------------------------------------------*
Procedure _SetPrevFocus()
*-----------------------------------------------------------------------------*
Local oCtrl, hControl

   hControl := GetNextDlgTabITem( GetActiveWindow(), GetFocus(), 1 )
   oCtrl := GetControlObjectByHandle( hControl )
   If oCtrl:hWnd == hControl
      oCtrl:SetFocus()
   Else
      InsertShiftTab()
   EndIf

Return

*------------------------------------------------------------------------------*
Procedure _PushEventInfo()
*------------------------------------------------------------------------------*
   aAdd( _OOHG_aEventInfo, { _OOHG_ThisForm, ;
                             _OOHG_ThisEventType, ;
                             _OOHG_ThisType, ;
                             _OOHG_ThisControl, ;
                             _OOHG_ThisObject, ;
                             _OOHG_ThisItemRowIndex, ;
                             _OOHG_ThisItemColIndex, ;
                             _OOHG_ThisItemCellRow, ;
                             _OOHG_ThisItemCellCol, ;
                             _OOHG_ThisItemCellWidth, ;
                             _OOHG_ThisItemCellHeight, ;
                             _OOHG_ThisItemCellValue } )
Return

*------------------------------------------------------------------------------*
Procedure _PopEventInfo()
*------------------------------------------------------------------------------*
Local l
   l := Len( _OOHG_aEventInfo )
   If l > 0
      _OOHG_ThisForm           := _OOHG_aEventInfo[ l ][ 01 ]
      _OOHG_ThisEventType      := _OOHG_aEventInfo[ l ][ 02 ]
      _OOHG_ThisType           := _OOHG_aEventInfo[ l ][ 03 ]
      _OOHG_ThisControl        := _OOHG_aEventInfo[ l ][ 04 ]
      _OOHG_ThisObject         := _OOHG_aEventInfo[ l ][ 05 ]
      _OOHG_ThisItemRowIndex   := _OOHG_aEventInfo[ l ][ 06 ]
      _OOHG_ThisItemColIndex   := _OOHG_aEventInfo[ l ][ 07 ]
      _OOHG_ThisItemCellRow    := _OOHG_aEventInfo[ l ][ 08 ]
      _OOHG_ThisItemCellCol    := _OOHG_aEventInfo[ l ][ 09 ]
      _OOHG_ThisItemCellWidth  := _OOHG_aEventInfo[ l ][ 10 ]
      _OOHG_ThisItemCellHeight := _OOHG_aEventInfo[ l ][ 11 ]
      _OOHG_ThisItemCellValue  := _OOHG_aEventInfo[ l ][ 12 ]
      aSize( _OOHG_aEventInfo, l - 1 )
   Else
      _OOHG_ThisForm           := nil
      _OOHG_ThisType           := ''
      _OOHG_ThisEventType      := ''
      _OOHG_ThisControl        := nil
      _OOHG_ThisObject         := nil
      _OOHG_ThisItemRowIndex   := 0
      _OOHG_ThisItemColIndex   := 0
      _OOHG_ThisItemCellRow    := 0
      _OOHG_ThisItemCellCol    := 0
      _OOHG_ThisItemCellWidth  := 0
      _OOHG_ThisItemCellHeight := 0
      _OOHG_ThisItemCellValue  := nil
   EndIf
Return

*------------------------------------------------------------------------------*
Function _ListEventInfo()
*------------------------------------------------------------------------------*
Local aEvents, nLen
   If EMPTY( _OOHG_ThisObject )
      aEvents := {}
   Else
      _PushEventInfo()
      nLen := LEN( _OOHG_aEventInfo )
      aEvents := ARRAY( nLen )
      AEVAL( _OOHG_aEventInfo, { | a, i | aEvents[ nLen - i + 1 ] := a[ 1 ]:Name + ;
                                 IF( a[ 4 ] == NIL, "", "." + a[ 4 ]:Name ) + ;
                                 "." + a[ 2 ] }, 2 )
      ASIZE( aEvents, nLen - 1 )
      // TODO: Add line number / procedure name
      _PopEventInfo()
   EndIf
Return aEvents

Function SetAppHotKey( nKey, nFlags, bAction )
Local bCode
   bCode := _OOHG_SetKey( _OOHG_HotKeys, nKey, nFlags )
   If PCOUNT() > 2
      _OOHG_SetKey( _OOHG_HotKeys, nKey, nFlags, bAction )
   EndIf
Return bCode

Function SetAppHotKeyByName( cKey, bAction )
Local aKey, bCode
   aKey := _DetermineKey( cKey )
   If aKey[ 1 ] != 0
      bCode := _OOHG_SetKey( _OOHG_HotKeys, aKey[ 1 ], aKey[ 2 ] )
      If PCOUNT() > 1
         _OOHG_SetKey( _OOHG_HotKeys, aKey[ 1 ], aKey[ 2 ], bAction )
      EndIf
   Else
      bCode := NIL
   EndIf
Return bCode

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
   IF ! EMPTY( oError )
      BREAK oError
   ENDIF
RETURN 1

FUNCTION ExitProcess( nExit )
   DBCloseAll()
RETURN _ExitProcess2( nExit )

FUNCTION _OOHG_UsesVisualStyle()
RETURN ( GetComCtl32Version() >= 6 .AND. IsAppThemed() )

EXTERN IsXPThemeActive, IsAppThemed, GetComCtl32Version
EXTERN _OOHG_Eval, EVAL
EXTERN _OOHG_ShowContextMenus, _OOHG_GlobalRTL, _OOHG_NestedSameEvent
EXTERN ValidHandler

#pragma BEGINDUMP

#include <shlwapi.h>

typedef LONG ( * CALL_ISTHEMEACTIVE )( void );
typedef LONG ( * CALL_ISAPPTHEMED )( void );
typedef HRESULT ( CALLBACK * CALL_DLLGETVERSION )( DLLVERSIONINFO * );

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

HB_FUNC( ISAPPTHEMED )
{
   BOOL bResult = FALSE;
   HMODULE hInstDLL;
   CALL_ISAPPTHEMED dwProcAddr;
   LONG lResult;

   OSVERSIONINFO os;

   os.dwOSVersionInfoSize = sizeof( os );

   if( GetVersionEx( &os ) && ( os.dwMajorVersion > 5 || ( os.dwMajorVersion == 5 && os.dwMinorVersion >= 1 ) ) )
   {
      hInstDLL = LoadLibrary( "UXTHEME.DLL" );
      if( hInstDLL )
      {
         dwProcAddr = ( CALL_ISAPPTHEMED ) GetProcAddress( hInstDLL, "IsAppThemed" );
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

HB_FUNC( GETCOMCTL32VERSION )
{
   int iResult = 0;
   HMODULE hInstDLL;
   CALL_DLLGETVERSION dwProcAddr;
   DLLVERSIONINFO dll;

   hInstDLL = LoadLibrary( "Comctl32.dll" );
   if( hInstDLL )
   {
      dwProcAddr = ( CALL_DLLGETVERSION ) GetProcAddress( hInstDLL, "DllGetVersion" );
      if( dwProcAddr )
      {
         memset( &dll, 0, sizeof( dll ) );
         dll.cbSize = sizeof( dll );
         if( ( dwProcAddr )( &dll ) == S_OK )
         {
            iResult = dll.dwMajorVersion;
         }
      }

      FreeLibrary( hInstDLL );
   }

   hb_retni( iResult );
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

HB_FUNC( _OOHG_EVAL_ARRAY )
{
   static PHB_SYMB s_Eval = 0;

   if( ISBLOCK( 1 ) )
   {
      int iCount, iLen;
      PHB_ITEM pArray, pItem;

      if( ! s_Eval )
      {
         s_Eval = hb_dynsymSymbol( hb_dynsymFind( "EVAL" ) );
      }
      hb_vmPushSymbol( s_Eval );
      hb_vmPushNil();
      hb_vmPush( hb_param( 1, HB_IT_BLOCK ) );
      pArray = hb_param( 2, HB_IT_ARRAY );
      iCount = 1;
      if( pArray )
      {
         iLen = hb_arrayLen( pArray );
         while( iCount <= iLen )
         {
            pItem = hb_itemArrayGet( pArray, iCount );
            hb_vmPush( pItem );
            hb_itemRelease( pItem );
            iCount++;
         }
      }
      hb_vmDo( iCount );
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

HB_FUNC( VALIDHANDLER )
{
   HWND hWnd;
   hWnd = HWNDparam( 1 );
   hb_retl( ValidHandler( hWnd ) );
}

HB_FUNC( _OOHG_GETMOUSECOL )
{
   hb_retni( _OOHG_MouseCol );
}

HB_FUNC( _OOHG_GETMOUSEROW )
{
   hb_retni( _OOHG_MouseRow );
}

#pragma ENDDUMP

Function _OOHG_GetArrayItem( uaArray, nItem, uExtra1, uExtra2 )
Local uRet
   IF !HB_IsArray( uaArray )
      uRet := uaArray
   ElseIf LEN( uaArray ) >= nItem .AND. nItem >= 1
      uRet := uaArray[ nItem ]
   Else
      uRet := NIL
   ENDIF
   IF HB_IsBlock( uRet )
      uRet := Eval( uRet, nItem, uExtra1, uExtra2 )
   ENDIF
Return uRet

Function _OOHG_DeleteArrayItem( aArray, nItem )
#ifdef __XHARBOUR__
   Return ADel( aArray, nItem, .T. )
#else
   IF HB_IsArray( aArray ) .AND. Len( aArray ) >= nItem
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
   If PCOUNT() > 3
      If HB_IsBlock( bAction )
         If !HB_IsNumeric( nId )
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

FUNCTION _OOHG_SetbKeyDown( bKeyDown )
Local uRet
   uRet := _OOHG_bKeyDown
   If HB_IsBlock( bKeyDown )
      _OOHG_bKeyDown := bKeyDown
   ElseIf PCOUNT() > 0
      _OOHG_bKeyDown := nil
   EndIf
Return uRet

PROCEDURE _OOHG_CallDump( cTitle )
LOCAL nLevel, cText
   cText := ""
   nLevel := 1
   DO WHILE ! Empty( PROCNAME( nLevel ) )
      IF nLevel > 1
         cText += CHR( 13 ) + CHR( 10 )
      ENDIF
      cText += PROCNAME( nLevel ) + "(" + LTRIM( STR( PROCLINE( nLevel ) ) ) + ")"
      nLevel++
   ENDDO
   MSGINFO( cText, cTitle )
Return

// PATCH :(
FUNCTION _OOHG_SetControlParent( lNewState )
STATIC lState := .T.
   If HB_IsLogical( lNewState )
      lState := lNewState
   EndIf
RETURN lState


#pragma BEGINDUMP

HB_FUNC ( C_LINE )
{

	// 1: hDC
	// 2: y
	// 3: x
	// 4: toy
	// 5: tox
	// 6: width
	// 7: R Color
	// 8: G Color
	// 9: B Color
	// 10: lWindth
	// 11: lColor
	// 12: lStyle
	// 13: nStyle

	int r ;
	int g ;
	int b ;

	int x = hb_parni(3) ;
	int y = hb_parni(2) ;

	int tox = hb_parni(5) ;
	int toy = hb_parni(4) ;

	int width = 0;
        int nStyle;

	HDC hdc = (HDC) hb_parnl( 1 );
	HGDIOBJ hgdiobj;
	HPEN hpen;

	
	if ( hdc != 0 )
	{
		// Width
		if ( hb_parl(10) )
		{
			width = hb_parni(6) ;
		}
		// Color
		if ( hb_parl(11) )
		{
			r = hb_parni(7) ;
			g = hb_parni(8) ;
			b = hb_parni(9) ;
		}
		else
		{
			r = 0 ;
			g = 0 ;
			b = 0 ;
		}
		if ( hb_parl(12) )
		{
			nStyle = hb_parni(13) ;
		}
		else
		{
			nStyle = (int) PS_SOLID ;
		}
		hpen = CreatePen( nStyle ,  width , (COLORREF) RGB( r , g , b ) );
		hgdiobj = SelectObject( (HDC) hdc , hpen );
		MoveToEx( (HDC) hdc , x, y ,NULL	);
		LineTo ( (HDC) hdc, tox ,toy 	);
		SelectObject( (HDC) hdc , (HGDIOBJ) hgdiobj );
		DeleteObject( hpen );
		//InvalidateRect( (HDC) hdc ,NULL, TRUE );
	}

}

HB_FUNC ( C_FILL )
{

	// 1: hDC
	// 2: y
	// 3: x
	// 4: toy
	// 5: tox
	// 6: R Color
	// 7: G Color
	// 8: B Color
	// 9: lColor

	int r ;
	int g ;
	int b ;

	int x = hb_parnl(3) ;
	int y = hb_parnl(2) ;

	int tox = hb_parnl(5) ;
	int toy = hb_parnl(4) ;
	
	
	RECT rect ;

	HDC hdc = (HDC) hb_parnl(1) ;
	HGDIOBJ hgdiobj;
	HBRUSH hBrush;

	if ( hdc != 0 )
	{
		// Color

		if ( hb_parl(9) )
		{
			r = hb_parni(6) ;
			g = hb_parni(7) ;
			b = hb_parni(8) ;
		}
		else
		{
			r = 0 ;
			g = 0 ;
			b = 0 ;
		}
		rect.left=x;
		rect.top=y;
		rect.right=tox ;
		rect.bottom=toy;

		hBrush = CreateSolidBrush( RGB(r,g,b) );
		hgdiobj = SelectObject( (HDC) hdc , hBrush );
		FillRect( (HDC) hdc , &rect , (HBRUSH) hBrush ) ;
		SelectObject( (HDC) hdc , (HGDIOBJ) hgdiobj );
		DeleteObject( hBrush );
	}
}

HB_FUNC ( C_RECTANGLE )
{

	// 1: hDC
	// 2: y
	// 3: x
	// 4: toy
	// 5: tox
	// 6: width
	// 7: R Color
	// 8: G Color
	// 9: B Color
	// 10: lWindth
	// 11: lColor
	// 12: lStyle
	// 13: nStyle
	// 14: lBrusStyle
	// 15: nBrushStyle
	// 16: lBrushColor
	// 17: nColorR
	// 18: nColorG
	// 19: nColorB
	
	int r ;
	int g ;
	int b ;

	int x = hb_parni(3) ;
	int y = hb_parni(2) ;

	int tox = hb_parni(5) ;
	int toy = hb_parni(4) ;

	int width ;
	int nStyle ;
	
	int br ;
	int bg ;
	int bb ;
	int nBr ;
	long nBh ;
	
	HDC hdc = (HDC) hb_parnl(1) ;
	HGDIOBJ hgdiobj,hgdiobj2;
	HPEN hpen;
	LOGBRUSH pbr;
	HBRUSH hbr ;

	if ( hdc != 0 )
	{
		// Width
		if ( hb_parl(10) )
		{
			width = hb_parni(6) ;
		}
		else
		{
			width = 1  ;
		}
		// Color
		if ( hb_parl(11) )
		{
			r = hb_parni(7) ;
			g = hb_parni(8) ;
			b = hb_parni(9) ;
		}
		else
		{
			r = 0 ;
			g = 0 ;
			b = 0 ;
		}
		if ( hb_parl(12) )
		{
			nStyle = hb_parni(13) ;
		}
		else
		{
			nStyle = (int) PS_SOLID ;
		}
		if ( hb_parl(14) )
		{
			nBh = hb_parni(15);
			nBr = 2 ;
		}
		else
		{
			if ( hb_parl(16) )
			{
			nBr = 0 ;
			}
			else
			{
			nBr = 1 ;
			}
			nBh = 0  ;
		}
		
		if ( hb_parl(16) )
		{
			br = hb_parni(17) ;
			bg = hb_parni(18) ;
			bb = hb_parni(19) ;
		}
		else
		{
			br = 0 ;
			bg = 0 ;
			bb = 0 ;
		}

		pbr.lbStyle=nBr ;
		pbr.lbColor=(COLORREF) RGB( br , bg , bb );
		pbr.lbHatch=(LONG) nBh;

		hpen = CreatePen( nStyle,  width , (COLORREF) RGB( r , g , b ) );
		hbr =CreateBrushIndirect(&pbr) ;
		hgdiobj = SelectObject( (HDC) hdc , hpen );
		hgdiobj2 = SelectObject( (HDC) hdc , hbr );
		Rectangle( (HDC) hdc ,x,y,tox,toy);

		SelectObject( (HDC) hdc , (HGDIOBJ) hgdiobj );
		SelectObject( (HDC) hdc , (HGDIOBJ) hgdiobj2 );

		DeleteObject( hpen );
		DeleteObject( hbr );
	}

}

HB_FUNC ( C_ROUNDRECTANGLE )
{

	// 1: hDC
	// 2: y
	// 3: x
	// 4: toy
	// 5: tox
	// 6: width
	// 7: R Color
	// 8: G Color
	// 9: B Color
	// 10: lWindth
	// 11: lColor
	// 12: lStyle
	// 13: nStyle
	// 14: lBrusStyle
	// 15: nBrushStyle
	// 16: lBrushColor
	// 17: nColorR
	// 18: nColorG
	// 19: nColorB

	int r ;
	int g ;
	int b ;

	int x = hb_parni(3) ;
	int y = hb_parni(2) ;

	int tox = hb_parni(5) ;
	int toy = hb_parni(4) ;

	int width ;

	int p ;
	int nStyle ;
	
	int br ;
	int bg ;
	int bb ;
	int nBr ;
	long nBh ;
	
	HDC hdc = (HDC) hb_parnl(1) ;
	HGDIOBJ hgdiobj,hgdiobj2;
	HPEN hpen;
	LOGBRUSH pbr;
	HBRUSH hbr ;

	if ( hdc != 0 )
	{

		// Width

		if ( hb_parl(10) )
		{
			width = hb_parni(6) ;
		}
		else
		{
			width = 1  ;
		}

		// Color

		if ( hb_parl(11) )
		{
			r = hb_parni(7) ;
			g = hb_parni(8) ;
			b = hb_parni(9) ;
		}
		else
		{
			r = 0 ;
			g = 0 ;
			b = 0 ;
		}

		if ( hb_parl(12) )
		{
			nStyle = hb_parni(13) ;
		}
		else
		{
			nStyle = (int) PS_SOLID ;
		}

		if ( hb_parl(14) )
		{
			nBh = hb_parni(15);
			nBr = 2 ;
		}
		else
		{
			if ( hb_parl(16) )
			{
			nBr = 0 ;
			}
			else
			{
			nBr = 1 ;
			}
			nBh = 0  ;
		}
		
		if ( hb_parl(16) )
		{
			br = hb_parni(17) ;
			bg = hb_parni(18) ;
			bb = hb_parni(19) ;
		}
		else
		{
			br = 0 ;
			bg = 0 ;
			bb = 0 ;
		}

		pbr.lbStyle=nBr ;
		pbr.lbColor=(COLORREF) RGB( br , bg , bb );
		pbr.lbHatch=(LONG) nBh;
		
		hpen = CreatePen( nStyle, width , (COLORREF) RGB( r , g , b ) );
		hbr =CreateBrushIndirect(&pbr) ;
		hgdiobj = SelectObject( (HDC) hdc , hpen );
		hgdiobj2 = SelectObject( (HDC) hdc , hbr );

		p = ( tox + toy ) / 2 ;
		p = p / 10 ;

		RoundRect( (HDC) hdc ,x,y,tox,toy,p,p);

		SelectObject( (HDC) hdc , (HGDIOBJ) hgdiobj );
		SelectObject( (HDC) hdc , (HGDIOBJ) hgdiobj2 );



		DeleteObject( hpen );
		DeleteObject( hbr );

	}

}

HB_FUNC ( C_ELLIPSE )
{

	// 1: hDC
	// 2: y
	// 3: x
	// 4: toy
	// 5: tox
	// 6: width
	// 7: R Color
	// 8: G Color
	// 9: B Color
	// 10: lWindth
	// 11: lColor
	// 12: lStyle
	// 13: nStyle
	// 14: lBrusStyle
	// 15: nBrushStyle
	// 16: lBrushColor
	// 17: nColorR
	// 18: nColorG
	// 19: nColorB

	int r ;
	int g ;
	int b ;

	int x = hb_parni(3) ;
	int y = hb_parni(2) ;

	int tox = hb_parni(5) ;
	int toy = hb_parni(4) ;

	int width ;

	int nStyle ;
	
	int br ;
	int bg ;
	int bb ;
	int nBr ;
	long nBh ;
	
	HDC hdc = (HDC) hb_parnl(1) ;
	HGDIOBJ hgdiobj,hgdiobj2;
	HPEN hpen;
	LOGBRUSH pbr;
	HBRUSH hbr ;

	if ( hdc != 0 )
	{

		// Width

		if ( hb_parl(10) )
		{
			width = hb_parni(6) ;
		}
		else
		{
			width = 1 * 10000 / 254 ;
		}

		// Color

		if ( hb_parl(11) )
		{
			r = hb_parni(7) ;
			g = hb_parni(8) ;
			b = hb_parni(9) ;
		}
		else
		{
			r = 0 ;
			g = 0 ;
			b = 0 ;
		}

		if ( hb_parl(12) )
		{
			nStyle = hb_parni(13) ;
		}
		else
		{
			nStyle = (int) PS_SOLID ;
		}

		if ( hb_parl(14) )
		{
			nBh = hb_parni(15);
			nBr = 2 ;
		}
		else
		{
			if ( hb_parl(16) )
			{
			nBr = 0 ;
			}
			else
			{
			nBr = 1 ;
			}
			nBh = 0  ;
		}
		
		if ( hb_parl(16) )
		{
			br = hb_parni(17) ;
			bg = hb_parni(18) ;
			bb = hb_parni(19) ;
		}
		else
		{
			br = 0 ;
			bg = 0 ;
			bb = 0 ;
		}

		pbr.lbStyle=nBr ;
		pbr.lbColor=(COLORREF) RGB( br , bg , bb );
		pbr.lbHatch=(LONG) nBh;
		
		hpen = CreatePen( nStyle, width , (COLORREF) RGB( r , g , b ) );
		hbr =CreateBrushIndirect(&pbr) ;
		hgdiobj = SelectObject( (HDC) hdc , hpen );
		hgdiobj2 = SelectObject( (HDC) hdc , hbr );

		Ellipse( (HDC) hdc ,x,y,tox,toy);

		SelectObject( (HDC) hdc , (HGDIOBJ) hgdiobj );
		SelectObject( (HDC) hdc , (HGDIOBJ) hgdiobj2 );



		DeleteObject( hpen );
		DeleteObject( hbr );

	}

}

HB_FUNC ( C_ARC )
{

	// 1: hDC
	// 2: y
	// 3: x
	// 4: toy
	// 5: tox
	// 6-9,x1,y1,x2,y2
	// 10: width
	// 11: R Color
	// 12: G Color
	// 13: B Color
	// 14: lWindth
	// 15: lColor
	// 16: lStyle
	// 17: nStyle


	int r ;
	int g ;
	int b ;

	int x = hb_parni(3) ;
	int y = hb_parni(2) ;

	int tox = hb_parni(5) ;
	int toy = hb_parni(4) ;

	int x1 = hb_parni(7);
	int y1 = hb_parni(6);
	int x2 = hb_parni(9);
	int y2 = hb_parni(8);

	int width = 0;
        int nStyle;

	HDC hdc = (HDC) hb_parnl( 1 );
	HGDIOBJ hgdiobj;
	HPEN hpen;

	
	if ( hdc != 0 )
	{
		// Width
		if ( hb_parl(14) )
		{
			width = hb_parni(10) ;
		}
		// Color
		if ( hb_parl(15) )
		{
			r = hb_parni(11) ;
			g = hb_parni(12) ;
			b = hb_parni(13) ;
		}
		else
		{
			r = 0 ;
			g = 0 ;
			b = 0 ;
		}
		if ( hb_parl(16) )
		{
			nStyle = hb_parni(17) ;
		}
		else
		{
			nStyle = (int) PS_SOLID ;
		}
		hpen = CreatePen( nStyle ,  width , (COLORREF) RGB( r , g , b ) );
		hgdiobj = SelectObject( (HDC) hdc , hpen );		
		Arc ( (HDC) hdc, x,y,tox ,toy,x1,y1,x2,y2 	);
		SelectObject( (HDC) hdc , (HGDIOBJ) hgdiobj );
		DeleteObject( hpen );
		//InvalidateRect( (HDC) hdc ,NULL, TRUE );
	}

}


HB_FUNC ( C_PIE )
{

	// 1: hDC
	// 2: y
	// 3: x
	// 4: toy
	// 5: tox
	// 6-9,x1,y1,x2,y2
	// 10: width
	// 11: R Color
	// 12: G Color
	// 13: B Color
	// 14: lWindth
	// 15: lColor
	// 16: lStyle
	// 17: nStyle
	// 18: lBrusStyle
	// 19: nBrushStyle
	// 20: lBrushColor
	// 21: nColorR
	// 22: nColorG
	// 23: nColorB
	
	int r ;
	int g ;
	int b ;

	int x = hb_parni(3) ;
	int y = hb_parni(2) ;

	int tox = hb_parni(5) ;
	int toy = hb_parni(4) ;

	int x1 = hb_parni(7);
	int y1 = hb_parni(6);
	int x2 = hb_parni(9);
	int y2 = hb_parni(8);

	int width = 0;
        int nStyle;
	
	int br ;
	int bg ;
	int bb ;
	int nBr ;
	long nBh ;
	
	HDC hdc = (HDC) hb_parnl(1) ;
	HGDIOBJ hgdiobj,hgdiobj2;
	HPEN hpen;
	LOGBRUSH pbr;
	HBRUSH hbr ;
	
	if ( hdc != 0 )
	{
		// Width
		if ( hb_parl(14) )
		{
			width = hb_parni(10) ;
		}
		// Color
		if ( hb_parl(15) )
		{
			r = hb_parni(11) ;
			g = hb_parni(12) ;
			b = hb_parni(13) ;
		}
		else
		{
			r = 0 ;
			g = 0 ;
			b = 0 ;
		}
		if ( hb_parl(16) )
		{
			nStyle = hb_parni(17) ;
		}
		else
		{
			nStyle = (int) PS_SOLID ;
		}

		if ( hb_parl(18) )
		{
			nBh = hb_parni(19);
			nBr = 2 ;
		}
		else
		{
			if ( hb_parl(20) )
			{
			nBr = 0 ;
			}
			else
			{
			nBr = 1 ;
			}
			nBh = 0  ;
		}
		
		if ( hb_parl(20) )
		{
			br = hb_parni(21) ;
			bg = hb_parni(22) ;
			bb = hb_parni(23) ;
		}
		else
		{
			br = 0 ;
			bg = 0 ;
			bb = 0 ;
		}

		pbr.lbStyle=nBr ;
		pbr.lbColor=(COLORREF) RGB( br , bg , bb );
		pbr.lbHatch=(LONG) nBh;
		
		hpen = CreatePen( nStyle, width , (COLORREF) RGB( r , g , b ) );
		hbr =CreateBrushIndirect(&pbr) ;
		hgdiobj = SelectObject( (HDC) hdc , hpen );
		hgdiobj2 = SelectObject( (HDC) hdc , hbr );
	
		Pie ( (HDC) hdc, x,y,tox ,toy,x1,y1,x2,y2 	);
		SelectObject( (HDC) hdc , (HGDIOBJ) hgdiobj );
		SelectObject( (HDC) hdc , (HGDIOBJ) hgdiobj2 );

		DeleteObject( hpen );
		DeleteObject( hbr );
		//InvalidateRect( (HDC) hdc ,NULL, TRUE );
	}

}

#pragma ENDDUMP
