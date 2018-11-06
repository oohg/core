/*
 * $Id: h_listbox.prg $
 */
/*
 * ooHG source code:
 * ListBox and ListBoxMulti controls
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
#include "common.ch"
#include "hbclass.ch"
#include "i_windefs.ch"

CLASS TList FROM TControl

   DATA Type                      INIT "LIST" READONLY
   DATA nWidth                    INIT 120
   DATA nHeight                   INIT 120
   DATA nTextHeight               INIT 0
   DATA bOnEnter                  INIT Nil
   DATA lAdjustImages             INIT .F.
   DATA ImageListColor            INIT CLR_DEFAULT
   DATA ImageListFlags            INIT LR_LOADTRANSPARENT + LR_DEFAULTCOLOR + LR_LOADMAP3DCOLORS
   DATA lFocused                  INIT .F.
   DATA lMultiTab                 INIT .F.
   DATA nColWidth                 INIT 120
   DATA DragItem                  INIT 0
   DATA DragTo                    INIT 0

   METHOD Define
   METHOD Define2
   METHOD Value                   SETGET
   METHOD OnEnter                 SETGET
   METHOD Events
   METHOD Events_Command
   METHOD Events_Drag
   METHOD Events_DrawItem
   METHOD Events_MeasureItem
   METHOD AddItem
   METHOD DeleteItem( nItem )     BLOCK { |Self, nItem| ListBoxDeleteString( Self, nItem ) }
   METHOD DeleteAllItems          BLOCK { |Self| ListBoxReset( ::hWnd ) }
   METHOD Item
   METHOD InsertItem
   METHOD ItemCount               BLOCK { |Self| ListBoxGetItemCount( ::hWnd ) }
   METHOD ItemHeight              BLOCK { |Self| ListBoxGetItemHeight( ::hWnd ) }
   METHOD ColumnWidth             SETGET
   METHOD TopIndex                SETGET
   METHOD EnsureVisible
   METHOD aItems                  SETGET

   ENDCLASS

METHOD Define( ControlName, ParentForm, x, y, w, h, rows, value, fontname, ;
               fontsize, tooltip, changeprocedure, dblclick, gotfocus, ;
               lostfocus, break, HelpId, invisible, notabstop, sort, bold, ;
               italic, underline, strikeout, backcolor, fontcolor, lRtl, ;
               lDisabled, onenter, aImage, TextHeight, lAdjustImages, ;
               novscroll, multicol, colwidth, multitab, aWidth, dragitems ) CLASS TList

   LOCAL nStyle := 0

   ::Define2( ControlName, ParentForm, x, y, w, h, rows, value, fontname, ;
              fontsize, tooltip, changeprocedure, dblclick, gotfocus, ;
              lostfocus, break, HelpId, invisible, notabstop, sort, bold, ;
              italic, underline, strikeout, backcolor, fontcolor, nStyle, ;
              lRtl, lDisabled, onenter, aImage, TextHeight, lAdjustImages, ;
              novscroll, multicol, colwidth, multitab, aWidth, dragitems )

   RETURN Self

METHOD Define2( ControlName, ParentForm, x, y, w, h, rows, value, fontname, ;
                fontsize, tooltip, changeprocedure, dblclick, gotfocus, ;
                lostfocus, break, HelpId, invisible, notabstop, sort, bold, ;
                italic, underline, strikeout, backcolor, fontcolor, nStyle, ;
                lRtl, lDisabled, onenter, aImage, TextHeight, lAdjustImages, ;
                novscroll, multicol, colwidth, multitab, aWidth, dragitems ) CLASS TList

   LOCAL ControlHandle, i

   ASSIGN ::nWidth        VALUE w             TYPE "N"
   ASSIGN ::nHeight       VALUE h             TYPE "N"
   ASSIGN ::nRow          VALUE y             TYPE "N"
   ASSIGN ::nCol          VALUE x             TYPE "N"
   ASSIGN ::nTextHeight   VALUE TextHeight    TYPE "N"
   ASSIGN ::lAdjustImages VALUE lAdjustImages TYPE "L"
   ASSIGN ::lMultiTab     VALUE multitab      TYPE "L"
   ASSIGN dragitems       VALUE dragitems     TYPE "L" DEFAULT .F.

   ::SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor, .T., lRtl )

   nStyle := ::InitStyle( nStyle,, invisible, notabstop, lDisabled ) + ;
             IIF( HB_ISLOGICAL( novscroll ) .AND. novscroll, 0, WS_VSCROLL + LBS_DISABLENOSCROLL ) + ;
             IIF( HB_ISLOGICAL( sort ) .AND. sort, LBS_SORT, 0 ) + ;
             IIF( HB_IsArray( aImage ) .OR. ::nTextHeight > 0,  LBS_OWNERDRAWFIXED, 0) + ;
             IIF( HB_ISLOGICAL( multicol ) .AND. multicol, LBS_MULTICOLUMN, 0 ) + ;
             IIF( ::lMultiTab, LBS_USETABSTOPS, 0 )

   ::SetSplitBoxInfo( Break )
   ControlHandle := InitListBox( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, nStyle, ::lRtl, dragitems )
   ::Register( ControlHandle, ControlName, HelpId, , ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   IF HB_IsArray( aImage )
      ::AddBitMap( aImage )
   ENDIF

   IF ::lMultiTab
      IF ! HB_IsArray( aWidth )
         aWidth := {}
      ENDIF

      IF LEN( rows ) > 0
         IF LEN( aWidth ) == 0
            IF HB_IsArray( rows[1] )
               FOR i := 1 TO LEN( rows[1] )
                  AADD( aWidth, INT( w / LEN( rows[1] ) ) )
               NEXT
            ENDIF
         ENDIF
         FOR i := 1 TO LEN( rows )
            IF HB_IsArray( rows[i] )
               rows[i] := LB_Array2String( rows[i] )
            ENDIF
         NEXT
      ENDIF
   ENDIF

   ::ColumnWidth := colwidth

   IF HB_IsArray( rows )
      AEVAL( rows, { |c| ListboxAddString2( Self, c ) } )
   ENDIF

   IF ::lMultiTab
      ListBoxSetMultiTab( ControlHandle, aWidth )
   ENDIF

   ::Value := Value

   ASSIGN ::OnLostFocus VALUE lostfocus  TYPE "B"
   ASSIGN ::OnGotFocus  VALUE gotfocus   TYPE "B"
   ASSIGN ::OnChange    VALUE ChangeProcedure TYPE "B"
   ASSIGN ::OnDblClick  VALUE dblclick   TYPE "B"
   ASSIGN ::OnEnter     VALUE onenter    TYPE "B"

   RETURN Self

METHOD Value( uValue ) CLASS TList

   IF VALTYPE( uValue ) == "N"
      ListBoxSetCursel( ::hWnd, uValue )
      ::DoChange()
   ENDIF

   RETURN ListBoxGetCursel( ::hWnd )

METHOD OnEnter( bEnter ) CLASS TList

   LOCAL bRet

   IF HB_IsBlock( bEnter )
      IF _OOHG_SameEnterDblClick
         ::OnDblClick := bEnter
      ELSE
         ::bOnEnter := bEnter
      ENDIF
      bRet := bEnter
   ELSE
      bRet := IIF( _OOHG_SameEnterDblClick, ::OnDblClick, ::bOnEnter )
   ENDIF

   RETURN bRet

METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TList

   IF nMsg == WM_LBUTTONDBLCLK
      IF ! ::lFocused
         ::SetFocus()
      ENDIF
      RETURN Nil

   ELSEIF nMsg == WM_LBUTTONDOWN
      IF ! ::NestedClick
         ::NestedClick := ! _OOHG_NestedSameEvent()
         IF ::lFocused
            ::DoEventMouseCoords( ::OnClick, "CLICK" )
         ELSE
            ::SetFocus()
            ::DoEventMouseCoords( ::OnClick, "CLICK" )
         ENDIF
         ::NestedClick := .F.
      ENDIF

   ENDIF

   RETURN ::Super:Events( hWnd, nMsg, wParam, lParam )

METHOD Events_Command( wParam ) CLASS TList

   LOCAL Hi_wParam := HIWORD( wParam )

   IF Hi_wParam == LBN_SELCHANGE
      ::DoChange()
      RETURN Nil

   ELSEIF Hi_wParam == LBN_KILLFOCUS
      ::lFocused := .F.
      RETURN ::DoLostFocus()

   ELSEIF Hi_wParam == LBN_SETFOCUS
      ::lFocused := .T.
      GetFormObjectByHandle( ::ContainerhWnd ):LastFocusedControl := ::hWnd
      ::FocusEffect()
      ::DoEvent( ::OnGotFocus, "GOTFOCUS" )
      RETURN Nil

   ELSEIF Hi_wParam == LBN_DBLCLK
      ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
      RETURN Nil

   ENDIF

   RETURN ::Super:Events_Command( wParam )

METHOD Events_Drag( lParam ) CLASS TList

   SWITCH GET_DRAG_LIST_NOTIFICATION_CODE( lParam )
   CASE DL_BEGINDRAG
      ::DragItem := GET_DRAG_LIST_DRAGITEM( lParam )
      RETURN 1

   CASE DL_DRAGGING
      ::DragTo := GET_DRAG_LIST_DRAGITEM( lParam )
      IF ::DragTo > ::DragItem
         DRAG_LIST_DRAWINSERT( ::Parent:hWnd, lParam, ::DragTo + 1 )
      ELSE
         DRAG_LIST_DRAWINSERT( ::Parent:hWnd, lParam, ::DragTo )
      ENDIF
      IF ::DragTo <> -1
         IF ::DragTo > ::DragItem
            SetResCursor( LoadCursor( GetInstance(), "MINIGUI_DRAGDOWN" ) )
         ELSE
            SetResCursor( LoadCursor( GetInstance(), "MINIGUI_DRAGUP" ) )
         ENDIF
         RETURN DL_CURSORSET
      ENDIF
      RETURN DL_STOPCURSOR

   CASE DL_CANCELDRAG
      ::DragItem := -1
      EXIT

   CASE DL_DROPPED
      ::DragTo := GET_DRAG_LIST_DRAGITEM( lParam )
      IF ::DragTo <> -1
         DRAG_LIST_MOVE_ITEMS( lParam, ::DragItem, ::DragTo )
      ENDIF
      DRAG_LIST_DRAWINSERT( ::Parent:hWnd, lParam, -1 )
      ::DragItem := -1
      EXIT

   END SWITCH

   RETURN Nil

METHOD AddItem( uValue ) CLASS TList

   IF ::lMultiTab .AND. HB_IsArray( uValue )
      uValue := LB_Array2String( uValue )
   ENDIF

   RETURN ListBoxAddstring2( Self, uValue )

METHOD aItems( aRows ) CLASS TList

   LOCAL i, uValue, aItems

   IF PCount() > 0
      uValue := ::Value

      ListBoxReset( ::hWnd )
      ::DoChange()

      AEval( aRows, { |u| ::AddItem( u ) } )

      ::Value := uValue
   ENDIF

   aItems := {}

   FOR i := 1 TO ::ItemCount
      AAdd( aItems, ::Item( i ) )
   NEXT i

   RETURN aItems

METHOD Item( nItem, uValue ) CLASS TList

   LOCAL cRet

   IF ! uValue == NIL
      ListBoxDeleteString( Self, nItem )
      IF ::lMultiTab .AND. HB_IsArray( uValue )
         uValue := LB_Array2String( uValue )
      ENDIF
      ListBoxInsertString2( Self, uValue, nItem )
   ENDIF
   cRet := ListBoxGetString( ::hWnd, nItem )
   IF ::lMultiTab
      cRet := LB_String2Array( cRet )
   ENDIF

   RETURN cRet

METHOD InsertItem( nItem, uValue ) CLASS TList

   LOCAL cRet

   IF ! uValue == NIL
      IF ::lMultiTab .AND. HB_IsArray( uValue )
         uValue := LB_Array2String( uValue )
      ENDIF
      ListBoxInsertString2( Self, uValue, nItem )
   ENDIF
   cRet := ListBoxGetString( ::hWnd, nItem )
   IF ::lMultiTab
      cRet := LB_String2Array( cRet )
   ENDIF

   RETURN cRet

METHOD ColumnWidth( uValue ) CLASS TList

   IF ValType( uValue ) == "N" .AND. uValue > 0
      ::nColWidth := uValue
      ListBoxSetColumnWidth( ::hWnd, uValue )
   ENDIF

   RETURN ::nColWidth

METHOD TopIndex( nTopIndex ) CLASS TList

   IF ValType( nTopIndex ) == "N" .and. nTopIndex > 0
      ListBoxSetTopIndex( ::hWnd, nTopIndex )
   ENDIF

   RETURN ListBoxGetTopIndex( :: hWnd )

FUNCTION LB_Array2String( aData, Sep )

   LOCAL n, cData

   IF HB_IsArray( aData ) .AND. LEN( aData ) > 0
      ASSIGN Sep VALUE Sep TYPE "CM" DEFAULT Chr(9)

      cData := aData[1]
      FOR n := 2 TO LEN( aData )
         cData += ( Sep + aData[n] )
      NEXT
   ELSE
      cData := ""
   ENDIF

   RETURN cData


CLASS TListMulti FROM TList

   DATA Type                      INIT "MULTILIST" READONLY

   METHOD Define
   METHOD Value                   SETGET

   ENDCLASS

METHOD Define( ControlName, ParentForm, x, y, w, h, rows, value, fontname, ;
               fontsize, tooltip, changeprocedure, dblclick, gotfocus, ;
               lostfocus, break, HelpId, invisible, notabstop, sort, bold, ;
               italic, underline, strikeout, backcolor, fontcolor, lRtl, ;
               lDisabled, onenter, aImage, TextHeight, lAdjustImages, ;
               novscroll, multicol, colwidth, multitab, aWidth, dragitems ) CLASS TListMulti

   LOCAL nStyle := LBS_EXTENDEDSEL + LBS_MULTIPLESEL

   ::Define2( ControlName, ParentForm, x, y, w, h, rows, value, fontname, ;
              fontsize, tooltip, changeprocedure, dblclick, gotfocus, ;
              lostfocus, break, HelpId, invisible, notabstop, sort, bold, ;
              italic, underline, strikeout, backcolor, fontcolor, nStyle, ;
              lRtl, lDisabled, onenter, aImage, TextHeight, lAdjustImages, ;
              novscroll, multicol, colwidth, multitab, aWidth, dragitems )

   RETURN Self

METHOD Value( uValue ) CLASS TListMulti

   IF VALTYPE( uValue ) == "A"
      ListBoxSetMultiSel( ::hWnd, uValue )
   ELSEIF VALTYPE( uValue ) == "N"
      ListBoxSetMultiSel( ::hWnd, { uValue } )
   ENDIF

   RETURN ListBoxGetMultiSel( ::hWnd )


#pragma BEGINDUMP

#include <windows.h>
#include <commctrl.h>
#include <hbapi.h>
#include <hbvm.h>
#include <hbstack.h>
#include <windowsx.h>
#include "oohg.h"

/*--------------------------------------------------------------------------------------------------------------------------------*/
static WNDPROC _OOHG_TListBox_lpfnOldWndProc( WNDPROC lp )
{
   static WNDPROC lpfnOldWndProc = 0;

   if( ! lpfnOldWndProc )
   {
      lpfnOldWndProc = lp;
   }

   return lpfnOldWndProc;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, _OOHG_TListBox_lpfnOldWndProc( 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( INITLISTBOX )          /* FUNCTION InitListBox( hWnd, hMenu, nCol, nRow, nWidth, nHeight, nStyle, lRtl, lDragItems ) -> hWnd */
{
   int Style = WS_CHILD | LBS_NOTIFY | LBS_NOINTEGRALHEIGHT | LBS_HASSTRINGS | hb_parni( 7 );
   int ExStyle = WS_EX_CLIENTEDGE | _OOHG_RTL_Status( hb_parl( 8 ) );

   HWND hCtrl = CreateWindowEx( ExStyle, "LISTBOX", "", Style, hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ),
                                HWNDparam( 1 ), HMENUparam( 2 ), GetModuleHandle( NULL ), NULL );

   _OOHG_TListBox_lpfnOldWndProc( (WNDPROC) SetWindowLongPtr( hCtrl, GWL_WNDPROC, (LONG_PTR) SubClassFunc ) );

   if( hb_parl( 9 ) )
   {
      MakeDragList( hCtrl );
   }

   HWNDret( hCtrl );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
void TList_DelImageBuffer( POCTRL oSelf, int nItem )
{
   BYTE *cBuffer;
   ULONG ulSize, ulSize2;
   int *pImage, nCount;

   if( oSelf->AuxBuffer )
   {
      if( nItem < (int) oSelf->AuxBufferLen )
      {
         pImage = &( (int *) oSelf->AuxBuffer )[ nItem * 2 ];
         nCount = ListBox_GetCount( oSelf->hWnd );
         if( nItem < nCount )
         {
            ulSize  = sizeof( int ) * 2 * nCount;
            ulSize2 = sizeof( int ) * 2 * nItem;
            cBuffer = (BYTE *) hb_xgrab( ulSize );
            memset( cBuffer, -1, ulSize );
            if( ( nItem + 1 ) < nCount )
            {
               memcpy( cBuffer, &pImage[ 2 ], ulSize - ulSize2 );
            }
            memcpy( &pImage[ 0 ], cBuffer, ulSize - ulSize2 );
            hb_xfree( cBuffer );
         }
      }
   }
}

void TList_SetImageBuffer( POCTRL oSelf, struct IMAGE_PARAMETER pStruct, int nItem )
{
   BYTE *cBuffer;
   ULONG ulSize, ulSize2;
   int *pImage, nCount;

   if( oSelf->AuxBuffer || pStruct.iImage1 != -1 || pStruct.iImage2 != -1 )
   {
      if( nItem >= (int) oSelf->AuxBufferLen )
      {
         ulSize = sizeof( int ) * 2 * ( nItem + 100 );
         cBuffer = (BYTE *) hb_xgrab( ulSize );
         memset( cBuffer, -1, ulSize );
         if( oSelf->AuxBuffer )
         {
            memcpy( cBuffer, oSelf->AuxBuffer, ( sizeof( int ) * 2 * oSelf->AuxBufferLen ) );
            hb_xfree( oSelf->AuxBuffer );
         }
         oSelf->AuxBuffer = cBuffer;
         oSelf->AuxBufferLen = nItem + 100;
      }

      pImage = &( (int *) oSelf->AuxBuffer )[ nItem * 2 ];
      nCount = ListBox_GetCount( oSelf->hWnd );
      if( nItem < nCount )
      {
         ulSize  = sizeof( int ) * 2 * nCount;
         ulSize2 = sizeof( int ) * 2 * nItem;
         cBuffer = (BYTE *) hb_xgrab( ulSize );
         memcpy( cBuffer, pImage, ulSize - ulSize2 );
         memcpy( &pImage[ 2 ], cBuffer, ulSize - ulSize2 );
         hb_xfree( cBuffer );
      }
      pImage[ 0 ] = pStruct.iImage1;
      pImage[ 1 ] = pStruct.iImage2;
   }
}

HB_FUNC( LISTBOXADDSTRING )
{
   char *cString = (char *) hb_parc( 2 );
   int nIndex = SendMessage( HWNDparam( 1 ), LB_ADDSTRING, 0, (LPARAM) cString );
   if( ( nIndex == LB_ERR ) || ( nIndex == LB_ERRSPACE ) )
      hb_retni( 0 );
   else
      hb_retni( nIndex + 1 );
}

HB_FUNC( LISTBOXADDSTRING2 )
{
   PHB_ITEM pSelf = (PHB_ITEM) hb_param( 1, HB_IT_ANY );
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   struct IMAGE_PARAMETER pStruct;
   int nItem = ListBox_GetCount( oSelf->hWnd );
   int nIndex;

   ImageFillParameter( &pStruct, hb_param( 2, HB_IT_ANY ) );
   TList_SetImageBuffer( oSelf, pStruct, nItem );
   nIndex = SendMessage( oSelf->hWnd, LB_ADDSTRING, 0, (LPARAM) pStruct.cString );
   if( ( nIndex == LB_ERR ) || ( nIndex == LB_ERRSPACE ) )
      hb_retni( 0 );
   else
      hb_retni( nIndex + 1 );
}

HB_FUNC( LISTBOXGETSTRING )
{
   int  iLen = SendMessage( HWNDparam( 1 ), LB_GETTEXTLEN, (WPARAM) ( hb_parni( 2 ) - 1 ), 0 );
   char *cString;

   if( ( iLen > 0 ) && ( NULL != ( cString = (char *) hb_xgrab( ( iLen + 1 ) * sizeof( TCHAR ) ) ) ) )
   {
      SendMessage( HWNDparam( 1 ), LB_GETTEXT, (WPARAM) ( hb_parni( 2 ) - 1 ), (LPARAM) cString );
      hb_retclen_buffer( cString, iLen );
   }
   else
   {
      hb_retc_null();
   }
}

HB_FUNC( LISTBOXINSERTSTRING )
{
   char *cString = (char *) hb_parc( 2 );
   SendMessage( HWNDparam( 1 ), LB_INSERTSTRING, (WPARAM) ( hb_parni(3) - 1 ), (LPARAM) cString );
}

HB_FUNC( LISTBOXINSERTSTRING2 )
{
   PHB_ITEM pSelf = (PHB_ITEM) hb_param( 1, HB_IT_ANY );
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   PHB_ITEM pValue = hb_param( 2, HB_IT_ANY );
   int nItem = hb_parni( 3 ) - 1;
   struct IMAGE_PARAMETER pStruct;

   ImageFillParameter( &pStruct, pValue );
   TList_SetImageBuffer( oSelf, pStruct, nItem );
   SendMessage( oSelf->hWnd, LB_INSERTSTRING, (WPARAM) nItem, (LPARAM) pStruct.cString );
}

HB_FUNC( LISTBOXSETCURSEL )
{
   SendMessage( HWNDparam( 1 ), LB_SETCURSEL, (WPARAM) ( hb_parni( 2 ) - 1 ), 0 );
}

HB_FUNC( LISTBOXGETCURSEL )
{
   hb_retni( SendMessage( HWNDparam( 1 ), LB_GETCURSEL, 0, 0 ) + 1 );
}

HB_FUNC( LISTBOXDELETESTRING )
{
   PHB_ITEM pSelf = (PHB_ITEM) hb_param( 1, HB_IT_ANY );
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   int nItem = hb_parni( 2 ) - 1;

   TList_DelImageBuffer( oSelf, nItem );
   SendMessage( oSelf->hWnd, LB_DELETESTRING, (WPARAM) nItem, 0 );
}

HB_FUNC( LISTBOXRESET )
{
   SendMessage( HWNDparam( 1 ), LB_RESETCONTENT, 0, 0 );
}

HB_FUNC( LISTBOXGETMULTISEL )
{
   HWND hwnd = HWNDparam( 1 );
   int i;
   int *buffer;
   int n;

   n = SendMessage( hwnd, LB_GETSELCOUNT, 0, 0);

   if( n > 0 )
   {
      hb_reta( n );

      buffer = (int *) hb_xgrab( ( n + 1 ) * sizeof( int ) );

      SendMessage( hwnd, LB_GETSELITEMS, (WPARAM) n, (LPARAM) buffer );

      for( i = 0; i < n; i++ )
      {
         HB_STORNI( ( buffer[ i ] + 1 ), -1, ( i + 1 ) );
      }

      hb_xfree( buffer );
   }
   else
   {
      hb_reta( 0 );
   }
}

HB_FUNC( LISTBOXSETMULTISEL )
{
   PHB_ITEM wArray;
   HWND hwnd = HWNDparam( 1 );
   int i;
   int n;
   int l;

   wArray = hb_param( 2, HB_IT_ARRAY );

   l = hb_parinfa( 2, 0 );

   n = SendMessage( hwnd, LB_GETCOUNT, 0, 0 );

   // CLEAR CURRENT SELECTIONS
   for( i = 0; i < n; i ++ )
   {
      SendMessage( hwnd, LB_SETSEL, 0, (LPARAM) i );
   }

   // SET NEW SELECTIONS
   for( i = 1; i <= l ; i ++ )
   {
      SendMessage( hwnd, LB_SETSEL, (WPARAM) 1, (LPARAM) ( hb_arrayGetNI( wArray, i ) - 1 ) );
   }
}

HB_FUNC( LISTBOXSETMULTITAB )
{
   PHB_ITEM wArray;
   int      *nTabStops;
   int      l, i;
   DWORD    dwDlgBase = GetDialogBaseUnits();
   int      baseunitX = LOWORD( dwDlgBase );
   HWND     hwnd = HWNDparam( 1 );

   wArray = hb_param( 2, HB_IT_ARRAY );

   l = hb_parinfa( 2, 0 ) - 1;

   if( l >= 0 )
   {
      nTabStops = (int *) hb_xgrab( ( l + 1 ) * sizeof( int ) );

      for( i = 0; i <= l; i++ )
         nTabStops[ i ] = MulDiv( hb_arrayGetNI( wArray, i + 1 ), 4, baseunitX );

      SendMessage( hwnd, LB_SETTABSTOPS, (WPARAM) ( l + 1 ), (LPARAM) nTabStops );

      hb_xfree( nTabStops );
   }
}


HB_FUNC( LISTBOXGETITEMCOUNT )
{
   hb_retni( SendMessage( HWNDparam( 1 ), LB_GETCOUNT, 0, 0 ) );
}

HB_FUNC_STATIC( TLIST_EVENTS_DRAWITEM )   // METHOD Events_DrawItem( lParam )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   LPDRAWITEMSTRUCT lpdis = (LPDRAWITEMSTRUCT) HB_PARNL( 1 );
   COLORREF FontColor, BackColor;
   TEXTMETRIC lptm;
   char cBuffer[ 2048 ];
   int x, y, cx, cy, iImage, dy;

   if( lpdis->itemID == (UINT) -1 )
   {
      hb_retl( FALSE );
   }
   else
   {
      if( ( lpdis->itemAction == ODA_SELECT ) || ( lpdis->itemAction == ODA_DRAWENTIRE ) )
      {
         // Text color
         if( lpdis->itemState & ODS_SELECTED )
         {
            FontColor = SetTextColor( lpdis->hDC, ( ( oSelf->lFontColorSelected == -1 ) ? GetSysColor( COLOR_HIGHLIGHTTEXT ) : (COLORREF) oSelf->lFontColorSelected ) );
            BackColor = SetBkColor( lpdis->hDC, ( ( oSelf->lBackColorSelected == -1 ) ? GetSysColor( COLOR_HIGHLIGHT ) : (COLORREF) oSelf->lBackColorSelected ) );
         }
         else if( lpdis->itemState & ODS_DISABLED )
         {
            FontColor = SetTextColor( lpdis->hDC, GetSysColor( COLOR_GRAYTEXT ) );
            BackColor = SetBkColor( lpdis->hDC, GetSysColor( COLOR_BTNFACE ) );
         }
         else
         {
            FontColor = SetTextColor( lpdis->hDC, ( ( oSelf->lFontColor == -1 ) ? GetSysColor( COLOR_WINDOWTEXT ) : (COLORREF) oSelf->lFontColor ) );
            BackColor = SetBkColor( lpdis->hDC, ( ( oSelf->lBackColor == -1 ) ? GetSysColor( COLOR_WINDOW ) : (COLORREF) oSelf->lBackColor ) );
         }

         // See if the current item has an image
         if( oSelf->ImageList && oSelf->AuxBuffer && ( lpdis->itemID + 1 ) <= oSelf->AuxBufferLen )
         {
            iImage = ( (int *) oSelf->AuxBuffer )[ ( lpdis->itemID * 2 ) + ( lpdis->itemState & ODS_SELECTED ? 1 : 0 ) ];
            if( iImage >= 0 && iImage < ImageList_GetImageCount( oSelf->ImageList ) )
            {
               ImageList_GetIconSize( oSelf->ImageList, &cx, &cy );
            }
            else
            {
               cx = 0;
               cy = 0;
               iImage = -1;
            }
         }
         else
         {
            cx = 0;
            cy = 0;
            iImage = -1;
         }

         // Window position
         GetTextMetrics( lpdis->hDC, &lptm );
         y = ( lpdis->rcItem.bottom + lpdis->rcItem.top - lptm.tmHeight ) / 2;
         x = LOWORD( GetDialogBaseUnits() ) / 2;

         // Text
         SendMessage( lpdis->hwndItem, LB_GETTEXT, lpdis->itemID, (LPARAM) cBuffer );
         ExtTextOut( lpdis->hDC, cx + x, y, ETO_CLIPPED | ETO_OPAQUE, &lpdis->rcItem, (LPCSTR) cBuffer, strlen( cBuffer ), NULL );

         // Restore DC
         SetTextColor( lpdis->hDC, FontColor );
         SetBkColor( lpdis->hDC, BackColor );

         // Draws image vertically centered
         if( iImage != -1 )
         {
            if( cy <= lpdis->rcItem.bottom - lpdis->rcItem.top )                  // there is spare space
            {
               y = ( lpdis->rcItem.bottom + lpdis->rcItem.top - cy ) / 2;         // center image
               dy = cy;                                                           // use real size
            }
            else
            {
               y = lpdis->rcItem.top;                                             // place image at top

               _OOHG_Send( pSelf, s_lAdjustImages );
               hb_vmSend( 0 );

               if( hb_parl( -1 ) )
               {
                  dy = ( lpdis->rcItem.bottom - lpdis->rcItem.top );              // clip exceeding pixels or stretch image
               }
               else
               {
                  dy = cy;                                                        // use real size
               }
            }

            ImageList_DrawEx( oSelf->ImageList, iImage, lpdis->hDC, 0, y, cx, dy, CLR_DEFAULT, CLR_NONE, ILD_NORMAL );
         }
      }

      hb_retl( TRUE );
   }
}

HB_FUNC_STATIC( TLIST_EVENTS_MEASUREITEM )   // METHOD Events_MeasureItem( lParam )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   LPMEASUREITEMSTRUCT lpmis = (LPMEASUREITEMSTRUCT) HB_PARNL( 1 );

   HWND hWnd = GetActiveWindow();
   HDC hDC = GetDC( hWnd );
   HFONT hFont, hOldFont;
   SIZE sz;
   int iSize;

   // Checks for a pre-defined text size
   _OOHG_Send( pSelf, s_nTextHeight );
   hb_vmSend( 0 );
   iSize = hb_parni( -1 );

   hFont = oSelf->hFontHandle;

   hOldFont = (HFONT) SelectObject( hDC, hFont );
   GetTextExtentPoint32( hDC, "_", 1, &sz );

   SelectObject( hDC, hOldFont );
   ReleaseDC( hWnd, hDC );

   if( iSize < sz.cy + 2 )
   {
      iSize = sz.cy + 2;
   }

   lpmis->itemHeight = iSize;

   hb_retnl( 1 );
}

HB_FUNC( GET_DRAG_LIST_NOTIFICATION_CODE )
{
   LPARAM lParam = (LPARAM) HB_PARNL( 1 );
   LPDRAGLISTINFO lpdli = (LPDRAGLISTINFO) lParam;

   hb_retni( lpdli->uNotification );
}

HB_FUNC( GET_DRAG_LIST_DRAGITEM )
{
   int nDragItem;
   LPARAM lParam = (LPARAM) HB_PARNL( 1 );
   LPDRAGLISTINFO lpdli = (LPDRAGLISTINFO) lParam;

   nDragItem = LBItemFromPt( lpdli->hWnd, lpdli->ptCursor, TRUE );

   hb_retni( nDragItem );
}

HB_FUNC( DRAG_LIST_DRAWINSERT )
{
   HWND hwnd = HWNDparam( 1 );
   LPARAM lParam = (LPARAM) HB_PARNL( 2 );
   int nItem = hb_parni( 3 );
   LPDRAGLISTINFO lpdli = (LPDRAGLISTINFO) lParam;
   int nItemCount;

   nItemCount = SendMessage( ( HWND ) lpdli->hWnd, LB_GETCOUNT, 0, 0 );

   if( nItem < nItemCount )
      DrawInsert( hwnd, lpdli->hWnd, nItem );
   else
      DrawInsert( hwnd, lpdli->hWnd, -1 );
}

HB_FUNC( DRAG_LIST_MOVE_ITEMS )
{
   LPARAM lParam = (LPARAM) HB_PARNL( 1 );
   LPDRAGLISTINFO lpdli = (LPDRAGLISTINFO) lParam;
   char string[ 1024 ];
   int result;

   result = ListBox_GetText( lpdli->hWnd, hb_parni( 2 ), string );
   if( result != LB_ERR )
      result = ListBox_DeleteString( lpdli->hWnd, hb_parni( 2 ) );
   if( result != LB_ERR )
      result = ListBox_InsertString( lpdli->hWnd, hb_parni( 3 ), string );
   if( result != LB_ERR )
      result = ListBox_SetCurSel( lpdli->hWnd, hb_parni( 3 ) );

   hb_retl( result != LB_ERR ? TRUE : FALSE );
}

HB_FUNC( TLIST_ENSUREVISIBLE )   // METHOD EnsureVisible( nItem )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   RECT rect;
   int nItemHeight, nVisibleCount, nTopIndex;
   int nItem = hb_parni( 1 );

   GetClientRect( oSelf->hWnd, &rect );
   nItemHeight = SendMessage( oSelf->hWnd, LB_GETITEMHEIGHT, 0, 0 );
   if( nItemHeight > 0)
   {
      nVisibleCount = (int) ( rect.bottom / nItemHeight );
      nTopIndex = SendMessage( oSelf->hWnd, LB_GETTOPINDEX, 0, 0 );
      if( nItem > 0 )
      {
         if( nItem < nTopIndex )
            nTopIndex = nItem - 1;                               // scroll up
         else if( nItem >= nTopIndex + nVisibleCount )
            nTopIndex = nItem - nVisibleCount;                   // scroll down
      }
      SendMessage( oSelf->hWnd, LB_SETTOPINDEX, (WPARAM) nTopIndex, 0 );
   }
}

HB_FUNC( LISTBOXSETTOPINDEX )
{
   SendMessage( HWNDparam( 1 ), LB_SETTOPINDEX, (WPARAM) ( hb_parni( 2 ) - 1 ), 0 );
}

HB_FUNC( LISTBOXGETTOPINDEX )
{
   hb_retni( SendMessage( HWNDparam( 1 ), LB_GETTOPINDEX, 0, 0 ) + 1 );
}

HB_FUNC( LISTBOXGETITEMHEIGHT )
{
   hb_retni( SendMessage( HWNDparam( 1 ), LB_GETITEMHEIGHT, 0, 0 ) );
}

HB_FUNC( LISTBOXSETCOLUMNWIDTH )
{
   SendMessage( HWNDparam( 1 ), LB_SETCOLUMNWIDTH, (WPARAM) ( hb_parni( 2 ) ), 0 );
}

#pragma ENDDUMP
