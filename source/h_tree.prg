/*
 * $Id: h_tree.prg,v 1.16 2008-01-08 15:45:57 declan2005 Exp $
 */
/*
 * ooHG source code:
 * PRG tree functions
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

STATIC _OOHG_ActiveTree := nil

CLASS TTree FROM TControl
   DATA Type          INIT "TREE" READONLY
   DATA nWidth        INIT 120
   DATA nHeight       INIT 120
   DATA ItemIds       INIT .F.
   DATA aTreeMap      INIT {}
   DATA aTreeIdMap    INIT {}
   DATA aTreeNode     INIT {}
   DATA InitValue     INIT 0
   DATA SetImageListCommand INIT TVM_SETIMAGELIST

   METHOD Define
   METHOD AddItem
   METHOD DeleteItem
   METHOD DeleteAllItems
   METHOD Item
   METHOD ItemCount      BLOCK { | Self | TreeView_GetCount( ::hWnd ) }
   METHOD Collapse
   METHOD Expand
   METHOD EndTree

   METHOD Value       SETGET
ENDCLASS

*------------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, row, col, width, height, change, ;
               tooltip, fontname, fontsize, gotfocus, lostfocus, dblclick, ;
               break, value, HelpId, aImgNode, aImgItem, noBot, bold, italic, ;
               underline, strikeout, itemids, lRtl, onenter, lDisabled, ;
               invisible, notabstop ) CLASS TTree
*------------------------------------------------------------------------------*
Local Controlhandle, nStyle, ImgDefNode, ImgDefItem, aBitmaps := array(4)

   ASSIGN ::nWidth    VALUE Width  TYPE "N"
   ASSIGN ::nHeight   VALUE Height TYPE "N"
   ASSIGN ::nRow      VALUE row    TYPE "N"
   ASSIGN ::nCol      VALUE col    TYPE "N"
   ASSIGN ::InitValue VALUE Value  TYPE "N"

   ::SetForm( ControlName, ParentForm, FontName, FontSize, , , .t., lRtl )

   nStyle := ::InitStyle( nStyle,, invisible, notabstop, lDisabled ) + ;
             IF( HB_ISLOGICAL( noBot ) .AND. noBot, 0, TVS_LINESATROOT )

   ::SetSplitBoxInfo( Break )
   ControlHandle := InitTree( ::ContainerhWnd, ::ContainerCol, ::ContainerRow, ::Width, ::Height, nStyle, ::lRtl )

   ImgDefNode := iif( HB_IsArray( aImgNode )  , len( aImgNode ), 0 )  //Tree+
   ImgDefItem := iif( HB_IsArray( aImgItem )  , len( aImgItem ), 0 )  //Tree+

   If ImgDefNode > 0

                aBitmaps[1] := aImgNode[1]                          // Node default
                aBitmaps[2] := aImgNode[ImgDefNode]

                if ImgDefItem > 0

                        aBitmaps[3] := aImgItem[1]                  // Item default
                        aBitmaps[4] := aImgItem[ImgDefItem]

                else

                        aBitmaps[3] := aImgNode[1]                   // Copy Node def if no Item def
                        aBitmaps[4] := aImgNode[ImgDefNode]

                endif

      ::AddBitMap( aBitmaps )
   EndIf

   ::Register( ControlHandle, ControlName, HelpId, , ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   ::ItemIds :=  itemids
   ::aTreeMap   :=  {}
   ::aTreeIdMap :=  {}
   ::aTreeNode  :=  {}

   ASSIGN ::OnLostFocus VALUE lostfocus  TYPE "B"
   ASSIGN ::OnGotFocus  VALUE gotfocus   TYPE "B"
   ASSIGN ::OnChange    VALUE Change     TYPE "B"
   ASSIGN ::OnDblClick  VALUE dblclick   TYPE "B"
   ASSIGN ::OnEnter     value onenter    TYPE "B"

   _OOHG_ActiveTree := Self

Return Self

*------------------------------------------------------------------------------*
METHOD AddItem( Value, Parent, Id, aImage ) CLASS TTree
*------------------------------------------------------------------------------*
Local TreeItemHandle
Local ImgDef, iUnSel, iSel
Local NewHandle , TempHandle , i , aPos , ChildHandle , BackHandle , ParentHandle

      if ! ::ItemIds

         If Parent > TreeView_GetCount( ::hWnd ) .or. Parent < 0
            MsgOOHGError ("Additem Method:  Invalid Parent Value. Program Terminated" )
                        EndIf

                EndIf

                ImgDef := iif( HB_IsArray( aImage )  , len( aImage ), 0 )  //Tree+

      if ! Empty( Parent )

         if ! ::ItemIds
            TreeItemHandle := ::aTreeMap [ Parent ]
                        Else
            aPos := ascan ( ::aTreeIdMap , Parent )

                                If aPos == 0
               MsgOOHGError ("Additem Method: Invalid Parent Value. Program Terminated" )
                                EndIf

            TreeItemHandle := ::aTreeMap [ aPos ]

                        EndIf

                        if ImgDef == 0

                                iUnsel := 2        // Pointer to defalut Node Bitmaps, no Bitmap loaded
                                iSel   := 3
                        else
            iUnSel := ::AddBitMap( aImage[1] ) -1
            iSel   := iif( ImgDef == 1, iUnSel, ::AddBitMap( aImage[2] ) -1 )
                                // If only one bitmap in array iSel = iUnsel, only one Bitmap loaded
                        endif

         NewHandle := AddTreeItem ( ::hWnd, TreeItemHandle , Value, iUnsel, iSel , Id )

                        * Determine Position of New Item

         TempHandle := TreeView_GetChild ( ::hWnd, TreeItemHandle )

                        i := 0

                        Do While .t.

                                i++

                                If TempHandle == NewHandle
                                        Exit
                                EndIf

            ChildHandle := TreeView_GetChild ( ::hWnd, TempHandle )

                                If ChildHandle == 0
                                        BackHandle := TempHandle
               TempHandle := TreeView_GetNextSibling ( ::hWnd, TempHandle )
                                Else
                                        i++
                                        BackHandle := Childhandle
               TempHandle := TreeView_GetNextSibling ( ::hWnd, ChildHandle )
                                EndIf

                                Do While TempHandle == 0

               ParentHandle := TreeView_GetParent ( ::hWnd, BackHandle )

               TempHandle := TreeView_GetNextSibling ( ::hWnd, ParentHandle )

                                        If TempHandle == 0
                                                BackHandle := ParentHandle
                                        EndIf

                                EndDo

                        EndDo

                        * Resize Array

         aSize ( ::aTreeMap , TreeView_GetCount ( ::hWnd ) )
         aSize ( ::aTreeIdMap, TreeView_GetCount ( ::hWnd ) )

                        * Insert New Element

         if ! ::ItemIds
            aIns ( ::aTreeMap , Parent + i  )
            aIns ( ::aTreeIdMap, Parent + i  )
                        Else
            aIns ( ::aTreeMap , aPos + i )
            aIns ( ::aTreeIdMap, aPos + i )
                        EndIf

                        * Assign Handle

         if ! ::ItemIds
            ::aTreeMap [ Parent + i ] := NewHandle
            ::aTreeIdMap [ Parent + i ] := Id
                        Else

            If ascan ( ::aTreeIdMap, Id ) != 0
               MsgOOHGError ("Additem Method:  Item Id "+alltrim(str(Id))+" Already In Use. Program Terminated" )
                                EndIf

            ::aTreeMap [ aPos + i ] := NewHandle
            ::aTreeIdMap [ aPos + i ] := Id

                        EndIf

                Else
                        TreeItemHandle := 0

                        if ImgDef == 0

                                iUnsel := 0        // Pointer to defalut Node Bitmaps, no Bitmap loaded
                                iSel   := 1
                        else
            iUnSel := ::AddBitMap( aImage[1] ) -1
            iSel   := iif( ImgDef == 1, iUnSel, ::AddBitMap( aImage[2] ) -1 )
                                // If only one bitmap in array iSel = iUnsel, only one Bitmap loaded
                        endif

         NewHandle := AddTreeItem ( ::hWnd , 0 , Value, iUnsel, iSel , Id )

         aadd ( ::aTreeMap , NewHandle )

         if ::ItemIds

            If ascan ( ::aTreeIdMap , Id ) != 0
               MsgOOHGError ("Additem Method:  Item Id Already In Use. Program Terminated" )
                                EndIf

                        EndIf

         aadd ( ::aTreeIdMap , Id )

                EndIf

Return nil

*------------------------------------------------------------------------------*
METHOD DeleteItem( Value ) CLASS TTree
*------------------------------------------------------------------------------*
Local BeforeCount , AfterCount , DeletedCount , i , aPos
Local TreeItemHandle

   BeforeCount := TreeView_GetCount( ::hWnd )

   if ! ::ItemIds

                        If Value > BeforeCount .or. Value < 1
            MsgOOHGError ("DeleteItem Method: Invalid Item Specified. Program Terminated" )
                        EndIf

         TreeItemHandle := ::aTreeMap [ Value ]
         TreeView_DeleteItem ( ::hWnd, TreeItemHandle )

                Else

         aPos := ascan ( ::aTreeIdMap, Value )

                        If aPos == 0
            MsgOOHGError ("DeleteItem Method: Invalid Item Id. Program Terminated" )
                        EndIf

         TreeItemHandle := ::aTreeMap [ aPos ]
         TreeView_DeleteItem ( ::hWnd, TreeItemHandle )

                EndIf

      AfterCount := TreeView_GetCount ( ::hWnd )

                DeletedCount := BeforeCount - AfterCount

      if ! ::ItemIds

                        If DeletedCount == 1

            Adel ( ::aTreeMap , Value )

                        Else

                                For i := 1 To DeletedCount
               Adel ( ::aTreeMap , Value )
                                Next i

                        EndIf

                Else

                        If DeletedCount == 1

            Adel ( ::aTreeMap , aPos )
            Adel ( ::aTreeIdMap, aPos )

                        Else

                                For i := 1 To DeletedCount
               Adel ( ::aTreeMap , aPos )
               Adel ( ::aTreeIdMap, aPos )
         Next i

      EndIf

   EndIf

   aSize ( ::aTreeMap,   AfterCount )
   aSize ( ::aTreeIdMap, AfterCount )

Return nil

*------------------------------------------------------------------------------*
METHOD DeleteAllItems() CLASS TTree
*------------------------------------------------------------------------------*
   TreeView_DeleteAllItems( ::hWnd )
   aSize( ::aTreeMap,   0 )
   aSize( ::aTreeIdMap, 0 )
Return nil

*------------------------------------------------------------------------------*
METHOD Item( Item, Value ) CLASS TTree
*------------------------------------------------------------------------------*
Local aPos, TreeHandle, ItemHandle

   IF pcount() > 1
      // set

      if ! ::ItemIds
         If Item > TreeView_GetCount ( ::hWnd ) .or. Item < 1
            MsgOOHGError ("Item Property: Invalid Item Reference. Program Terminated" )
                        EndIf
                EndIf

      TreeHandle := ::hWnd

      if ! ::ItemIds
         ItemHandle := ::aTreeMap [ Item ]
                Else

         aPos := ascan ( ::aTreeIdMap, Item )

                        If aPos == 0
            MsgOOHGError ("Item Property: Invalid Item Id. Program Terminated" )
                        EndIf

         ItemHandle := ::aTreeMap [ aPos ]

                EndIf

                TreeView_SetItem ( TreeHandle , ItemHandle , Value )

   else
      // get
      if ! ::ItemIds
         If Item > TreeView_GetCount ( ::hWnd ) .or. Item < 1
            MsgOOHGError ("Item Property: Invalid Item Reference. Program Terminated" )
                        EndIf
                EndIf

      TreeHandle := ::hWnd

      if ! ::ItemIds
         ItemHandle := ::aTreeMap [ Item ]
                Else

         aPos := ascan ( ::aTreeIdMap, Item )

                        If aPos == 0
            MsgOOHGError ("Item Property: Invalid Item Id. Program Terminated" )
                        EndIf

         ItemHandle := ::aTreeMap [ aPos ]

                EndIf

      Value   := TreeView_GetItem ( TreeHandle , ItemHandle )

   ENDIF

Return Value

*------------------------------------------------------------------------------*
METHOD Collapse( Item ) CLASS TTree
*------------------------------------------------------------------------------*
Local ItemHandle := 0 , Pos

   if ! ::ItemIds
      If Item <= Len ( ::aTreeMap )
         ItemHandle := ::aTreeMap [Item]
      EndIf
   Else
      Pos := ascan ( ::aTreeIdMap, Item )
      If Pos > 0
         ItemHandle := ::aTreeMap [ Pos ]
      EndIf
   EndIf

   If ItemHandle > 0
      SendMessage( ::hWnd, TVM_EXPAND, TVE_COLLAPSE, ItemHandle )
   EndIf

Return nil

*------------------------------------------------------------------------------*
METHOD Expand( Item ) CLASS TTree
*------------------------------------------------------------------------------*
Local ItemHandle := 0 , Pos

   if ! ::ItemIds
      If Item <= Len ( ::aTreeMap )
         ItemHandle := ::aTreeMap [Item]
      EndIf
   Else
      Pos := ascan ( ::aTreeIdMap, Item )
      If Pos > 0
         ItemHandle := ::aTreeMap [ Pos ]
      EndIf
   EndIf

   If ItemHandle > 0

      SendMessage( ::hWnd, TVM_EXPAND, TVE_EXPAND, ItemHandle )

   EndIf

Return nil

*------------------------------------------------------------------------------*
METHOD EndTree() CLASS TTree
*------------------------------------------------------------------------------*
   If ::InitValue > 0
      If ! ::ItemIds
         TreeView_SelectItem( ::hWnd, ::aTreeMap[ ::InitValue ] )
      Else
         TreeView_SelectItem( ::hWnd, ::aTreeMap[ ascan( ::aTreeIdMap, ::InitValue ) ] )
      EndIf
   EndIf
Return Nil

*------------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TTree
*------------------------------------------------------------------------------*
Local TreeItemHandle, aPos

   IF HB_IsNumeric( uValue )

      if ! ::ItemIds
         If uValue > TreeView_GetCount( ::hWnd )
            Return 0
                        EndIf
                EndIf

      if ! ::ItemIds
         TreeItemHandle :=  ::aTreeMap [ uValue ]
                Else

         aPos := ascan ( ::aTreeIdMap, uValue )

                        If aPos == 0
            MsgOOHGError ("Value Property: Invalid TreeItem Reference. Program Terminated")
                        EndIf

         TreeItemHandle := ::aTreeMap [ aPos ]

                EndIf

      TreeView_SelectItem ( ::hWnd, TreeItemHandle )

   ENDIF
   // get
   if ! ::ItemIds
      uValue :=  aScan( ::aTreeMap , TreeView_GetSelection( ::hWnd ) )
   Else
      uValue :=  TreeView_GetSelectionId( ::hWnd )
   EndIf
RETURN uValue

*------------------------------------------------------------------------------*
Function _DefineTreeNode ( text, aImage , Id )
*------------------------------------------------------------------------------*
Local         ImgDef, iUnSel, iSel
Local Item

        If ValType ( Id ) == 'U'
                Id := 0
        EndIf

        ImgDef := iif( HB_IsArray( aImage )  , len( aImage ), 0 )  //Tree+

        if ImgDef == 0

                iUnsel := 0        // Pointer to defalut Node Bitmaps, no Bitmap loaded
                iSel   := 1

        else
      iUnSel := _OOHG_ActiveTree:AddBitMap( aImage[ 1 ] ) - 1
      iSel   := iif( ImgDef == 1, iUnSel, _OOHG_ActiveTree:AddBitMap( aImage[ 2 ] ) - 1 )
                // If only one bitmap in array iSel = iUnsel, only one Bitmap loaded
        endif

   Item := AddTreeItem ( _OOHG_ActiveTree:hWnd, ATAIL( _OOHG_ActiveTree:aTreeNode ) , text, iUnsel, iSel , Id )
   aAdd ( _OOHG_ActiveTree:aTreeMap , Item )
   aAdd ( _OOHG_ActiveTree:aTreeNode , Item )
   aAdd ( _OOHG_ActiveTree:aTreeIdMap , Id )

Return Nil

*------------------------------------------------------------------------------*
Function _EndTreeNode()
*------------------------------------------------------------------------------*

   ASIZE( _OOHG_ActiveTree:aTreeNode,   LEN( _OOHG_ActiveTree:aTreeNode ) - 1 )

Return Nil

*------------------------------------------------------------------------------*
Function _DefineTreeItem ( text, aImage , Id )
*------------------------------------------------------------------------------*
Local handle, ImgDef, iUnSel, iSel

        If ValType ( Id ) == 'U'
                Id := 0
        EndIf

        ImgDef := iif( HB_IsArray( aImage )  , len( aImage ), 0 )  //Tree+

        if ImgDef == 0

                iUnsel := 2        // Pointer to defalut Item Bitmaps, no Bitmap loaded
                iSel   := 3

        else
      iUnSel := _OOHG_ActiveTree:AddBitMap( aImage[ 1 ] ) - 1
      iSel   := iif( ImgDef == 1, iUnSel, _OOHG_ActiveTree:AddBitMap( aImage[ 2 ] ) -1 )
                // If only one bitmap in array iSel = iUnsel, only one Bitmap loaded
        endif

   handle := AddTreeItem ( _OOHG_ActiveTree:hWnd, ATAIL( _OOHG_ActiveTree:aTreeNode ) , text, iUnSel, iSel , Id )
   aAdd ( _OOHG_ActiveTree:aTreeMap , Handle )
   aAdd ( _OOHG_ActiveTree:aTreeIdMap , Id )

Return Nil

*------------------------------------------------------------------------------*
Procedure _EndTree()
*------------------------------------------------------------------------------*
   _OOHG_ActiveTree:EndTree()
   _OOHG_ActiveTree := nil
Return

#pragma BEGINDUMP
#define _WIN32_IE      0x0500

#ifndef HB_OS_WIN_32_USED
   #define HB_OS_WIN_32_USED
#endif

#define _WIN32_WINNT   0x0400

#define WM_TASKBAR     WM_USER+1043

#include <shlobj.h>
#include <windows.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "winreg.h"
#include "tchar.h"

#include <commctrl.h>

#include "oohg.h"


#define HTREEparam( x )     ( HTREEITEM ) HWNDparam( ( x ) )
#define HTREEret( x )       HWNDret( ( HWND ) ( x ) )

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

HB_FUNC( INITTREE )
{
	INITCOMMONCONTROLSEX icex;

   HWND hWndTV;
   UINT iStyle;
   int StyleEx;

   iStyle = hb_parni( 6 ) | WS_CHILD | TVS_HASLINES | TVS_HASBUTTONS | TVS_SHOWSELALWAYS;
   StyleEx = WS_EX_CLIENTEDGE | _OOHG_RTL_Status( hb_parl( 7 ) );

   icex.dwSize = sizeof( INITCOMMONCONTROLSEX );
   icex.dwICC  = ICC_TREEVIEW_CLASSES ;
	InitCommonControlsEx(&icex);

   hWndTV = CreateWindowEx( StyleEx, WC_TREEVIEW, "", iStyle,
                            hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ),
                            HWNDparam( 1 ), NULL, GetModuleHandle( NULL ), NULL );

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( ( HWND ) hWndTV, GWL_WNDPROC, ( LONG ) SubClassFunc );

   HWNDret( hWndTV );
}

HB_FUNC( ADDTREEITEM )
{
   HWND hWndTV = HWNDparam( 1 );
   HTREEITEM hPrev = HTREEparam( 2 );
	TV_ITEM tvi;
   TV_INSERTSTRUCT is;

   tvi.mask       = TVIF_TEXT | TVIF_IMAGE | TVIF_SELECTEDIMAGE | TVIF_PARAM;

   tvi.pszText        = hb_parc( 3 );
   tvi.cchTextMax     = 1024;
   tvi.iImage         = hb_parni( 4 );
   tvi.iSelectedImage = hb_parni( 5 );
   tvi.lParam         = hb_parni( 6 );

#ifdef __BORLANDC__
   is.DUMMYUNIONNAME.item = tvi;
#else
   is.item   = tvi;
#endif

   if( ! hPrev )
	{
		is.hInsertAfter = hPrev;
		is.hParent      = NULL;
	}
	else
	{
		is.hInsertAfter = TVI_LAST;
		is.hParent      = hPrev;
	}

   HTREEret( TreeView_InsertItem( hWndTV, &is ) );
}

HB_FUNC( TREEVIEW_GETSELECTION )
{
   HWNDret( TreeView_GetSelection( HWNDparam( 1 ) ) );
}

HB_FUNC( TREEVIEW_SELECTITEM )
{
   TreeView_SelectItem( HWNDparam( 1 ), HTREEparam( 2 ) );
}

HB_FUNC( TREEVIEW_DELETEITEM )
{
   TreeView_DeleteItem( HWNDparam( 1 ), HTREEparam( 2 ) );
}

HB_FUNC( TREEVIEW_DELETEALLITEMS )
{
   TreeView_DeleteAllItems( HWNDparam( 1 ) );
}

HB_FUNC( TREEVIEW_GETCOUNT )
{
   hb_retni( TreeView_GetCount( HWNDparam( 1 ) ) );
}

HB_FUNC( TREEVIEW_GETPREVSIBLING )
{
   HTREEret( TreeView_GetPrevSibling( HWNDparam( 1 ), HTREEparam( 2 ) ) );
}

HB_FUNC( TREEVIEW_GETITEM )
{
   HTREEITEM   TreeItemHandle;
   TV_ITEM     TreeItem;
   char     ItemText [256];

   memset( &TreeItem, 0, sizeof( TV_ITEM ) );

   TreeItemHandle = HTREEparam( 2 );

   TreeItem.mask = TVIF_HANDLE | TVIF_TEXT;
   TreeItem.hItem = TreeItemHandle;

   TreeItem.pszText = ItemText;
	TreeItem.cchTextMax = 256 ;

   TreeView_GetItem( HWNDparam( 1 ), &TreeItem );

   hb_retc( ItemText );
}

HB_FUNC( TREEVIEW_SETITEM )
{
   HTREEITEM   TreeItemHandle;
   TV_ITEM     TreeItem;
   char     ItemText [256];

   memset( &TreeItem, 0, sizeof( TV_ITEM ) );

   TreeItemHandle = HTREEparam( 2 );
   strcpy( ItemText , hb_parc( 3 ) );

   TreeItem.mask = TVIF_HANDLE | TVIF_TEXT;
   TreeItem.hItem = TreeItemHandle;

   TreeItem.pszText = ItemText;
   TreeItem.cchTextMax = 256;

   TreeView_SetItem( HWNDparam( 1 ), &TreeItem );
}

HB_FUNC( TREEVIEW_GETSELECTIONID )
{
	HWND TreeHandle ;
   HTREEITEM ItemHandle;

	TV_ITEM		TreeItem ;

   TreeHandle = HWNDparam( 1 );
	ItemHandle = TreeView_GetSelection( TreeHandle );

   memset( &TreeItem, 0, sizeof( TV_ITEM ) );

   TreeItem.mask = TVIF_HANDLE | TVIF_PARAM;
   TreeItem.hItem  = ItemHandle;

   TreeView_GetItem( TreeHandle, &TreeItem );

   hb_retnl( TreeItem.lParam );
}

HB_FUNC( TREEVIEW_GETNEXTSIBLING )
{
   HTREEret( TreeView_GetNextSibling( HWNDparam( 1 ), HTREEparam( 2 ) ) );
}

HB_FUNC( TREEVIEW_GETCHILD )
{
   HTREEret( TreeView_GetChild( HWNDparam( 1 ), HTREEparam( 2 ) ) );
}

HB_FUNC( TREEVIEW_GETPARENT )
{
   HTREEret( TreeView_GetParent( HWNDparam( 1 ), HTREEparam( 2 ) ) );
}
#pragma ENDDUMP
