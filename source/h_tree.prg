/*
 * $Id: h_tree.prg,v 1.22 2011-09-02 23:08:54 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG tree functions
 *
 * Copyright 2005 Vicente Guerra <vicente@guerra.com.mx>
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

STATIC _OOHG_ActiveTree := Nil

CLASS TTree FROM TControl
   DATA Type                 INIT "TREE" READONLY
   DATA nWidth               INIT 120
   DATA nHeight              INIT 120
   DATA ItemIds              INIT .F.
   DATA aTreeMap             INIT {}
   DATA aTreeIdMap           INIT {}
   DATA aTreeNode            INIT {}
   DATA InitValue            INIT 0
   DATA SetImageListCommand  INIT TVM_SETIMAGELIST
   DATA bOnEnter             INIT Nil
   DATA aSelColor            INIT BLUE             /* background color of the select node */
   DATA OnLabelEdit          INIT Nil
   DATA Valid                INIT Nil
   DATA aTreeRO              INIT {}
   DATA ReadOnly             INIT .T.
   DATA OnCheckChange        INIT Nil
   DATA hWndEditCtrl         INIT Nil

   METHOD Define
   METHOD AddItem
   METHOD DeleteItem
   METHOD DeleteAllItems
   METHOD Item
   METHOD ItemCount          BLOCK { | Self | TreeView_GetCount( ::hWnd ) }
   METHOD Collapse
   METHOD Expand
   METHOD EndTree
   METHOD Value              SETGET
   METHOD OnEnter            SETGET
   METHOD Indent             SETGET
   METHOD Events
   METHOD Events_Notify
   METHOD EditLabel
   METHOD ItemReadonly       SETGET
   METHOD SelColor           SETGET
   METHOD CheckItem          SETGET
   METHOD GetParent
   METHOD GetChildren
   METHOD LookForKey
   METHOD Release
ENDCLASS

*------------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, row, col, width, height, change, ;
               tooltip, fontname, fontsize, gotfocus, lostfocus, dblclick, ;
               break, value, HelpId, aImgNode, aImgItem, noBot, bold, italic, ;
               underline, strikeout, itemids, lRtl, onenter, lDisabled, ;
               invisible, notabstop, fontcolor, BackColor, lFullRowSel, ;
               lChkBox, lEdtLbl, lNoHScr, lNoScroll, lHotTrak, lNoLines, ;
               lNoBut, lNoDD, lSingle, lNoBor, aSelCol, labeledit, valid, ;
               checkchange, indent ) CLASS TTree
*------------------------------------------------------------------------------*
Local Controlhandle, nStyle, ImgDefNode, ImgDefItem, aBitmaps := array(4)

   ASSIGN ::nWidth    VALUE Width  TYPE "N"
   ASSIGN ::nHeight   VALUE Height TYPE "N"
   ASSIGN ::nRow      VALUE row    TYPE "N"
   ASSIGN ::nCol      VALUE col    TYPE "N"
   ASSIGN ::InitValue VALUE Value  TYPE "N"

   ::SetForm( ControlName, ParentForm, FontName, FontSize, , BackColor, .t., lRtl )

   nStyle := ::InitStyle( nStyle, , invisible, notabstop, lDisabled )
   If HB_IsLogical( lFullRowSel ) .AND. lFullRowSel
      nStyle += TVS_FULLROWSELECT
   ElseIf ! HB_IsLogical( lNoLines ) .OR. ! lNoLines
      nStyle += TVS_HASLINES
         
      If ! HB_IsLogical( noBot ) .OR. ! noBot
         nStyle += TVS_LINESATROOT
      EndIf
   EndIf
   If HB_IsLogical( lNoDD ) .AND. lNoDD
      nStyle += TVS_DISABLEDRAGDROP
   EndIf
   If HB_IsLogical( lEdtLbl ) .AND. lEdtLbl
      nStyle += TVS_EDITLABELS
      ::ReadOnly := .F.
   EndIf
   If HB_IsLogical( lNoScroll ) .AND. lNoScroll
      nStyle += TVS_NOSCROLL
   ElseIf HB_IsLogical( lNoHScr ) .AND. lNoHScr
      nStyle += TVS_NOHSCROLL
   EndIf
   If ! HB_IsLogical( lNoBut ) .OR. ! lNoBut
      nStyle += TVS_HASBUTTONS
   EndIf
   If HB_IsLogical( lHotTrak ) .AND. lHotTrak
      nStyle += TVS_TRACKSELECT
   EndIf
   If HB_IsLogical( lSingle ) .AND. lSingle
      nStyle += TVS_SINGLEEXPAND
   EndIf
   nStyle += TVS_SHOWSELALWAYS
   
   ::SetSplitBoxInfo( Break )
   ControlHandle := InitTree( ::ContainerhWnd, ::ContainerCol, ::ContainerRow, ::Width, ::Height, nStyle, ::lRtl, lChkBox, !HB_IsLogical( lNoBor ) .OR. ! lNoBor )

   ::Register( ControlHandle, ControlName, HelpId, , ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   ImgDefNode := iif( HB_IsArray( aImgNode ), len( aImgNode ), 0 )
   ImgDefItem := iif( HB_IsArray( aImgItem ), len( aImgItem ), 0 )

   If ImgDefNode > 0
      /* node default */
      aBitmaps[ 1 ] := aImgNode[ 1 ]
      aBitmaps[ 2 ] := aImgNode[ ImgDefNode ]

      If ImgDefItem > 0
         /* item default */
         aBitmaps[ 3 ] := aImgItem[ 1 ]
         aBitmaps[ 4 ] := aImgItem[ ImgDefItem ]
      else
         /* copy node default if there's no item default */
         aBitmaps[ 3 ] := aImgNode[ 1 ]
         aBitmaps[ 4 ] := aImgNode[ ImgDefNode ]
      EndIf

      If ::BackColor != Nil
         ::ImageListColor := RGB( ::BackColor[ 1 ], ::BackColor[ 2 ], ::BackColor[ 3 ] )
         ::ImageListFlags := LR_LOADTRANSPARENT + LR_DEFAULTCOLOR + LR_LOADMAP3DCOLORS
      EndIf
      
      ::AddBitMap( aBitmaps )
   EndIf

   ::ItemIds    := itemids
   ::aTreeMap   := {}
   ::aTreeIdMap := {}
   ::aTreeNode  := {}
   ::aTreeRO    := {}

   ASSIGN ::OnLostFocus   VALUE lostfocus   TYPE "B"
   ASSIGN ::OnGotFocus    VALUE gotfocus    TYPE "B"
   ASSIGN ::OnChange      VALUE Change      TYPE "B"
   ASSIGN ::OnDblClick    VALUE dblclick    TYPE "B"
   ASSIGN ::OnEnter       VALUE onenter     TYPE "B"
   ASSIGN ::OnLabelEdit   VALUE labeledit   TYPE "B"
   ASSIGN ::OnCheckChange VALUE checkchange TYPE "B"
   ASSIGN ::Valid         VALUE valid       TYPE "B"
   ASSIGN ::FontColor     VALUE fontcolor   TYPE "A"
   ASSIGN ::aSelColor     VALUE aSelCol     TYPE "ANCM"
   ASSIGN ::Indent        VALUE indent      TYPE "N"

   _OOHG_ActiveTree := Self

Return Self

*------------------------------------------------------------------------------*
METHOD AddItem( Value, Parent, Id, aImage, lChecked, lReadOnly ) CLASS TTree
*------------------------------------------------------------------------------*
Local TreeItemHandle
Local ImgDef, iUnSel, iSel
Local NewHandle, TempHandle, i, Pos, ChildHandle, BackHandle, ParentHandle, iPos

   ASSIGN lChecked    VALUE lChecked    TYPE "L" DEFAULT .F.
   ASSIGN lReadOnly   VALUE lReadOnly   TYPE "L" DEFAULT .F.

   ImgDef := iif( HB_IsArray( aImage ), len( aImage ), 0 )

   If ! Empty( Parent )
      If ! ::ItemIds
         If Parent < 1 .OR. Parent > len( ::aTreeMap )
            MsgOOHGError( "Additem Method: Invalid Parent Reference. Program Terminated" )
         EndIf

         TreeItemHandle := ::aTreeMap[ Parent ]
      Else
         Pos := aScan( ::aTreeIdMap, Parent )
         
         If Pos == 0
            MsgOOHGError( "Additem Method: Invalid Parent Reference. Program Terminated" )
         EndIf

         TreeItemHandle := ::aTreeMap[ Pos ]
      EndIf

      If ImgDef == 0
         /* pointer to default node bitmaps, no bitmap loaded */
         iUnsel := 2
         iSel   := 3
      Else
         If ! ValidHandler( ::ImageList )
            If ::BackColor != Nil
               ::ImageListColor := RGB( ::BackColor[ 1 ], ::BackColor[ 2 ], ::BackColor[ 3 ] )
               ::ImageListFlags := LR_LOADTRANSPARENT + LR_DEFAULTCOLOR + LR_LOADMAP3DCOLORS
            EndIf
         EndIf

         iUnSel := ::AddBitMap( aImage[ 1 ] ) -1
         /* if only one bitmap in array isel = iunsel, only one bitmap loaded */
         iSel   := iif( ImgDef == 1, iUnSel, ::AddBitMap( aImage[ 2 ] ) -1 )
      EndIf

      NewHandle := AddTreeItem( ::hWnd, TreeItemHandle, Value, iUnsel, iSel, Id )

      /* determine position of new item */
      TempHandle := TreeView_GetChild( ::hWnd, TreeItemHandle )

      i := 0
      Do While .t.
         i++

         If TempHandle == NewHandle
            Exit
         EndIf

         ChildHandle := TreeView_GetChild( ::hWnd, TempHandle )

         If ChildHandle == 0
            BackHandle := TempHandle
            TempHandle := TreeView_GetNextSibling( ::hWnd, TempHandle )
         Else
            i++
            BackHandle := Childhandle
            TempHandle := TreeView_GetNextSibling( ::hWnd, ChildHandle )
         EndIf

         Do While TempHandle == 0
            ParentHandle := TreeView_GetParent( ::hWnd, BackHandle )

            TempHandle := TreeView_GetNextSibling( ::hWnd, ParentHandle )

            If TempHandle == 0
               BackHandle := ParentHandle
            EndIf
         EndDo
      EndDo

      /* insert new element */
      aSize( ::aTreeMap, TreeView_GetCount( ::hWnd ) )
      aSize( ::aTreeIdMap, TreeView_GetCount( ::hWnd ) )
      aSize( ::aTreeRO, TreeView_GetCount( ::hWnd ) )

      If ! ::ItemIds
         aIns( ::aTreeMap, Parent + i  )
         aIns( ::aTreeIdMap, Parent + i  )
         aIns( ::aTreeRO, Parent + i  )
         iPos := Parent + i
      Else
         aIns( ::aTreeMap, Pos + i )
         aIns( ::aTreeIdMap, Pos + i )
         aIns( ::aTreeRO, Pos + i )
         iPos := Pos + i
      EndIf

      /* assign handle, id, readonly */
      If ! ::ItemIds
         ::aTreeMap[ Parent + i ] := NewHandle
         ::aTreeIdMap[ Parent + i ] := Id
         ::aTreeRO[ Parent + i ] := lReadOnly
      Else
         If aScan( ::aTreeIdMap, Id ) != 0
            MsgOOHGError( "Additem Method: Item Id " + alltrim( str( Id ) ) + " Already In Use. Program Terminated" )
         EndIf

         ::aTreeMap[ Pos + i ] := NewHandle
         ::aTreeIdMap[ Pos + i ] := Id
         ::aTreeRO[ Pos + i ] := lReadOnly
      EndIf
   Else
      If ImgDef == 0
         /* pointer to default node bitmaps, no bitmap loaded */
         iUnsel := 0
         iSel   := 1
      Else
         If ! ValidHandler( ::ImageList )
            If ::BackColor != Nil
               ::ImageListColor := RGB( ::BackColor[ 1 ], ::BackColor[ 2 ], ::BackColor[ 3 ] )
               ::ImageListFlags := LR_LOADTRANSPARENT + LR_DEFAULTCOLOR + LR_LOADMAP3DCOLORS
            EndIf
         EndIf

         iUnSel := ::AddBitMap( aImage[ 1 ] ) -1
         /* if only one bitmap in array isel = iunsel, only one bitmap loaded */
         iSel   := iif( ImgDef == 1, iUnSel, ::AddBitMap( aImage[ 2 ] ) -1 )
      EndIf

      If ::ItemIds
         If aScan( ::aTreeIdMap, Id ) != 0
            MsgOOHGError ("Additem Method: Item Id Already In Use. Program Terminated" )
         EndIf
      EndIf

      NewHandle := AddTreeItem( ::hWnd, 0, Value, iUnsel, iSel, Id )

      /* add new element and assign handle, id, readonly */
      aAdd( ::aTreeMap, NewHandle )
      aAdd( ::aTreeIdMap, Id )
      aAdd( ::aTreeRO, lReadOnly )

      iPos := Len( ::aTreeMap )
   EndIf

   ::CheckItem( iPos, lChecked )

Return Nil

*------------------------------------------------------------------------------*
METHOD DeleteItem( Item ) CLASS TTree
*------------------------------------------------------------------------------*
Local BeforeCount, AfterCount, DeletedCount, i, Pos
Local TreeItemHandle

   BeforeCount := TreeView_GetCount( ::hWnd )

   If ! ::ItemIds
      If Item > BeforeCount .OR. Item < 1
         MsgOOHGError( "DeleteItem Method: Invalid Item Reference. Program Terminated" )
      EndIf

      TreeItemHandle := ::aTreeMap[ Item ]
      TreeView_DeleteItem( ::hWnd, TreeItemHandle )
   Else
      Pos := aScan( ::aTreeIdMap, Item )

      If Pos == 0
         MsgOOHGError( "DeleteItem Method: Invalid Item Id. Program Terminated" )
      EndIf

      TreeItemHandle := ::aTreeMap[ Pos ]
      TreeView_DeleteItem( ::hWnd, TreeItemHandle )
   EndIf

   AfterCount := TreeView_GetCount( ::hWnd )
   DeletedCount := BeforeCount - AfterCount

   If ! ::ItemIds
      If DeletedCount == 1
         aDel( ::aTreeMap, Item )
         aDel( ::aTreeRO, Item )
      Else
         For i := 1 To DeletedCount
            aDel( ::aTreeMap, Item )
            aDel( ::aTreeRO, Item )
         Next i
      EndIf
   Else
      If DeletedCount == 1
         aDel( ::aTreeMap, Pos )
         aDel( ::aTreeIdMap, Pos )
         aDel( ::aTreeRO, Item )
      Else
         For i := 1 To DeletedCount
            aDel( ::aTreeMap, Pos )
            aDel( ::aTreeIdMap, Pos )
            aDel( ::aTreeRO, Item )
         Next i
      EndIf
   EndIf

   aSize( ::aTreeMap, AfterCount )
   aSize( ::aTreeIdMap, AfterCount )
   aSize( ::aTreeRO, AfterCount )

Return Nil

*------------------------------------------------------------------------------*
METHOD DeleteAllItems() CLASS TTree
*------------------------------------------------------------------------------*

   TreeView_DeleteAllItems( ::hWnd )
   aSize( ::aTreeMap, 0 )
   aSize( ::aTreeIdMap, 0 )
   aSize( ::aTreeRO, 0 )

Return Nil

*------------------------------------------------------------------------------*
METHOD Item( Item, Value ) CLASS TTree
*------------------------------------------------------------------------------*
Local Pos, ItemHandle

   If pcount() > 1
      /* set */
      If ! ::ItemIds
         If Item < 1 .OR. Item > Len( ::aTreeMap )
            MsgOOHGError( "Item Method: Invalid Item Reference. Program Terminated" )
         EndIf

         ItemHandle := ::aTreeMap[ Item ]
      Else
         Pos := aScan( ::aTreeIdMap, Item )
         
         If Pos == 0
            MsgOOHGError( "Item Method: Invalid Item Id. Program Terminated" )
         EndIf

         ItemHandle := ::aTreeMap[ Pos ]
      EndIf

      TreeView_SetItem( ::hWnd, ItemHandle, Value )
   Else
      /* get */
      If ! ::ItemIds
         If Item < 1 .OR. Item > Len( ::aTreeMap )
            MsgOOHGError( "Item Method: Invalid Item Reference. Program Terminated" )
         EndIf

         ItemHandle := ::aTreeMap[ Item ]
         Value := TreeView_GetItem( ::hWnd, ItemHandle )
      Else
         Pos := aScan( ::aTreeIdMap, Item )
         
         If Pos == 0
            MsgOOHGError( "Item Method: Invalid Item Id. Program Terminated" )
         EndIf

         ItemHandle := ::aTreeMap[ Pos ]
         Value := TreeView_GetItem( ::hWnd, ItemHandle )
      EndIf
   EndIf

Return Value

*------------------------------------------------------------------------------*
METHOD Collapse( Item ) CLASS TTree
*------------------------------------------------------------------------------*
Local ItemHandle := 0, Pos

   If ! ::ItemIds
      If Item > 0 .AND. Item <= Len( ::aTreeMap )
         ItemHandle := ::aTreeMap[ Item ]
      EndIf
   Else
      Pos := aScan( ::aTreeIdMap, Item )
      
      If Pos > 0
         ItemHandle := ::aTreeMap[ Pos ]
      EndIf
   EndIf

   If ItemHandle > 0
      SendMessage( ::hWnd, TVM_EXPAND, TVE_COLLAPSE, ItemHandle )
   EndIf

Return Nil

*------------------------------------------------------------------------------*
METHOD Expand( Item ) CLASS TTree
*------------------------------------------------------------------------------*
Local ItemHandle := 0, Pos

   If ! ::ItemIds
      If Item > 0 .AND. Item <= Len( ::aTreeMap )
         ItemHandle := ::aTreeMap[ Item ]
      EndIf
   Else
      Pos := aScan( ::aTreeIdMap, Item )
      
      If Pos > 0
         ItemHandle := ::aTreeMap[ Pos ]
      EndIf
   EndIf

   If ItemHandle > 0
      SendMessage( ::hWnd, TVM_EXPAND, TVE_EXPAND, ItemHandle )
   EndIf

Return Nil

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
Local TreeItemHandle, Pos

   If HB_IsNumeric( uValue )
      /* set */
      If ! ::ItemIds
         If uValue < 1 .OR. uValue > Len( ::aTreeMap )
            Return 0
         EndIf

         TreeItemHandle := ::aTreeMap[ uValue ]
      Else
         Pos := aScan( ::aTreeIdMap, uValue )
         
         If Pos == 0
            Return 0
         EndIf

         TreeItemHandle := ::aTreeMap[ Pos ]
      EndIf

      TreeView_SelectItem( ::hWnd, TreeItemHandle )
   EndIf

   /* get */
   If ! ::ItemIds
      /* item reference */
      uValue := aScan( ::aTreeMap, TreeView_GetSelection( ::hWnd ) )
   Else
      /* id */
      uValue := TreeView_GetSelectionId( ::hWnd )
   EndIf
   
Return uValue

*-----------------------------------------------------------------------------*
METHOD OnEnter( bEnter ) CLASS TTree
*-----------------------------------------------------------------------------*
LOCAL bRet

   If HB_IsBlock( bEnter )
      If _OOHG_SameEnterDblClick
         ::OnDblClick := bEnter
      Else
         ::bOnEnter := bEnter
      EndIf
      bRet := bEnter
   Else
      bRet := iif( _OOHG_SameEnterDblClick, ::OnDblClick, ::bOnEnter )
   EndIf
   
Return bRet

*------------------------------------------------------------------------------*
Function _DefineTreeNode( text, aImage, Id, lChecked, lReadOnly )
*------------------------------------------------------------------------------*
Local ImgDef, iUnSel, iSel
Local Item

   ASSIGN lChecked    VALUE lChecked    TYPE "L" DEFAULT .F.
   ASSIGN lReadOnly   VALUE lReadOnly   TYPE "L" DEFAULT .F.

   If ValType( Id ) == 'U'
      Id := 0
   EndIf

   ImgDef := iif( HB_IsArray( aImage ), len( aImage ), 0 )

   If ImgDef == 0
      /* pointer to default node bitmaps, no bitmap loaded */
      iUnsel := 0
      iSel   := 1
   Else
      If ! ValidHandler( _OOHG_ActiveTree:ImageList )
         If _OOHG_ActiveTree:BackColor != Nil
            _OOHG_ActiveTree:ImageListColor := RGB( _OOHG_ActiveTree:BackColor[ 1 ], _OOHG_ActiveTree:BackColor[ 2 ], _OOHG_ActiveTree:BackColor[ 3 ] )
            _OOHG_ActiveTree:ImageListFlags := LR_LOADTRANSPARENT + LR_DEFAULTCOLOR + LR_LOADMAP3DCOLORS
         EndIf
      EndIf

      iUnSel := _OOHG_ActiveTree:AddBitMap( aImage[ 1 ] ) - 1
      /* if only one bitmap in array isel = iunsel, only one bitmap loaded */
      iSel   := iif( ImgDef == 1, iUnSel, _OOHG_ActiveTree:AddBitMap( aImage[ 2 ] ) - 1 )
   EndIf

   Item := AddTreeItem( _OOHG_ActiveTree:hWnd, aTail( _OOHG_ActiveTree:aTreeNode ), text, iUnsel, iSel, Id )
   
   aAdd( _OOHG_ActiveTree:aTreeMap, Item )
   aAdd( _OOHG_ActiveTree:aTreeNode, Item )
   aAdd( _OOHG_ActiveTree:aTreeIdMap, Id )
   aAdd( _OOHG_ActiveTree:aTreeRO, lReadOnly )

   _OOHG_ActiveTree:CheckItem( Len( _OOHG_ActiveTree:aTreeMap ), lChecked )

Return Nil

*------------------------------------------------------------------------------*
Function _EndTreeNode()
*------------------------------------------------------------------------------*

   aSize( _OOHG_ActiveTree:aTreeNode, Len( _OOHG_ActiveTree:aTreeNode ) - 1 )

Return Nil

*------------------------------------------------------------------------------*
Function _DefineTreeItem( text, aImage, Id, lChecked, lReadOnly )
*------------------------------------------------------------------------------*
Local handle, ImgDef, iUnSel, iSel

   ASSIGN lChecked    VALUE lChecked    TYPE "L" DEFAULT .F.
   ASSIGN lReadOnly   VALUE lReadOnly   TYPE "L" DEFAULT .F.

   If ValType( Id ) == 'U'
      Id := 0
   EndIf

   ImgDef := iif( HB_IsArray( aImage ), len( aImage ), 0 )

   If ImgDef == 0
      /* pointer to default item bitmaps, no bitmap loaded */
      iUnsel := 2
      iSel   := 3
   Else
      If ! ValidHandler( _OOHG_ActiveTree:ImageList )
         If _OOHG_ActiveTree:BackColor != Nil
            _OOHG_ActiveTree:ImageListColor := RGB( _OOHG_ActiveTree:BackColor[ 1 ], _OOHG_ActiveTree:BackColor[ 2 ], _OOHG_ActiveTree:BackColor[ 3 ] )
            _OOHG_ActiveTree:ImageListFlags := LR_LOADTRANSPARENT + LR_DEFAULTCOLOR + LR_LOADMAP3DCOLORS
         EndIf
      EndIf

      iUnSel := _OOHG_ActiveTree:AddBitMap( aImage[ 1 ] ) - 1
      /* if only one bitmap in array isel = iunsel, only one bitmap loaded */
      iSel   := iif( ImgDef == 1, iUnSel, _OOHG_ActiveTree:AddBitMap( aImage[ 2 ] ) -1 )
   EndIf

   handle := AddTreeItem( _OOHG_ActiveTree:hWnd, aTail( _OOHG_ActiveTree:aTreeNode ), text, iUnSel, iSel, Id )

   aAdd( _OOHG_ActiveTree:aTreeMap, Handle )
   aAdd( _OOHG_ActiveTree:aTreeIdMap, Id )
   aAdd( _OOHG_ActiveTree:aTreeRO, lReadOnly )

   _OOHG_ActiveTree:CheckItem( Len( _OOHG_ActiveTree:aTreeMap ), lChecked )
   
Return Nil

*------------------------------------------------------------------------------*
Function _EndTree()
*------------------------------------------------------------------------------*

   _OOHG_ActiveTree:EndTree()
   _OOHG_ActiveTree := Nil

Return Nil

/* Sets/retrieves the item's indentation. If this parameter is less than the
 * system-defined minimum width, the new width is set to the minimum.
 */
*-----------------------------------------------------------------------------*
METHOD Indent( nPixels ) CLASS TTree
*-----------------------------------------------------------------------------*

   If HB_IsNumeric( nPixels )
      TreeView_SetIndent( ::hWnd, nPixels )
   EndIf
   nPixels := TreeView_GetIndent( ::hWnd )

Return nPixels

*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TTree
*-----------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam )
Local cNewValue, lValid

   If nNotify == NM_CUSTOMDRAW
      Return Treeview_Notify_CustomDraw( Self, lParam )

   ElseIf nNotify == TVN_SELCHANGED
      ::DoChange()

   ElseIf nNotify == TVN_BEGINLABELEDIT
     If ::ReadOnly .OR. ::ItemReadOnly( ::Value )
        /* abort editing */
        Return 1
      EndIf

      ::hWndEditCtrl := SendMessage( ::hWnd, TVM_GETEDITCONTROL, 0, 0 )
      if ::hWndEditCtrl == Nil
        Return 1
      endif

      SubClassEditCtrl( ::hWndEditCtrl, ::hWnd )
      Return 0

   ElseIf nNotify == TVN_ENDLABELEDIT
      ::hWndEditCtrl := Nil

      cNewValue := Treeview_LabelValue( lParam )

      /* editing was aborted */
      If cNewValue == Nil
        /* revert to original value */
        Return 0                      
      Endif

      If HB_IsBlock( ::Valid )
         lValid := _OOHG_Eval( ::Valid, ::Value, cNewValue )
         If HB_IsLogical( lValid ) .AND. ! lValid
            ::EditLabel()
            Return 0
         EndIf
      EndIf

      ::Item( ::Value, cNewValue )
      ::DoEvent( ::OnLabelEdit, "TREEVIEW_LABELEDIT", {::Value, ::Item( ::Value )} )
      Return 1

   ElseIf nNotify == NM_CLICK
      PreProcess_StateChange( ::hWnd, lParam )
      /* allow processing */
      Return 0

   EndIf

Return ::Super:Events_Notify( wParam, lParam )

*-----------------------------------------------------------------------------*
METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TTree
*-----------------------------------------------------------------------------*
Local nItem, lChecked

   If nMsg == WM_APP + 8
      If HB_IsBlock( ::OnCheckChange )
         nItem := aScan( ::aTreeMap, GetItemHWND( lParam ) )
         lChecked := ::CheckItem( nItem )

         ::DoEvent( ::OnCheckChange, "TREEVIEW_CHANGECHECK", {nItem, lChecked} )
      EndIf

      Return Nil
   EndIf
   
Return ::Super:Events( hWnd, nMsg, wParam, lParam )

*-----------------------------------------------------------------------------*
METHOD EditLabel() CLASS TTree
*-----------------------------------------------------------------------------*

   ::SetFocus()

   TreeView_EditLabel( ::hWnd, TreeView_GetSelection( ::hWnd ) )
   
Return Nil

*-----------------------------------------------------------------------------*
METHOD SelColor( aColor ) CLASS TTree
*-----------------------------------------------------------------------------*

  If aColor != Nil
      ::aSelColor := aColor
      ::Redraw()
   Endif

Return ::aSelColor

*------------------------------------------------------------------------------*
METHOD CheckItem( Item, lChecked ) CLASS TTree
*------------------------------------------------------------------------------*
Local ItemHandle, Pos

   If HB_IsLogical( lChecked )
      /*  set */
      If ! ::ItemIds
         If Item < 1 .OR. Item > Len( ::aTreeMap )
            MsgOOHGError( "CheckItem Method: Invalid Item Reference. Program Terminated" )
         EndIf

         ItemHandle := ::aTreeMap[ Item ]
      Else
         Pos := aScan( ::aTreeIdMap, Item )
         
         If Pos == 0
            MsgOOHGError( "CheckItem Method: Invalid Item Id. Program Terminated" )
         EndIf

         ItemHandle := ::aTreeMap[ Pos ]
      EndIf

      TreeView_SetCheckState( ::hWnd, ItemHandle, lChecked )
   Else
      /* get */
      If ! ::ItemIds
         If Item < 1 .OR. Item > Len( ::aTreeMap )
            MsgOOHGError( "CheckItem Method: Invalid Item Reference. Program Terminated" )
         EndIf

         ItemHandle := ::aTreeMap[ Item ]
      Else
         Pos := aScan( ::aTreeIdMap, Item )
         
         If Pos == 0
            MsgOOHGError( "CheckItem Method: Invalid Item Id. Program Terminated" )
         EndIf

         ItemHandle := ::aTreeMap[ Pos ]
      EndIf
   EndIf
   
Return TreeView_GetCheckState( ::hWnd, ItemHandle ) == 1

*------------------------------------------------------------------------------*
METHOD ItemReadonly( Item, lReadOnly ) CLASS TTree
*------------------------------------------------------------------------------*
Local Pos

   If HB_IsLogical( lReadOnly )
      /* set */
      If ! ::ItemIds
         If Item < 1 .OR. Item > Len( ::aTreeMap )
            MsgOOHGError( "ItemReadonly Method: Invalid Item Reference. Program Terminated" )
         EndIf

         Pos := Item
      Else
         Pos := aScan( ::aTreeIdMap, Item )
         
         If Pos == 0
            MsgOOHGError( "ItemReadonly Method: Invalid Item Id. Program Terminated" )
         EndIf
      EndIf
      
      ::aTreeRO[ Pos ] := lReadOnly
   Else
      /* get */
      If ! ::ItemIds
         If Item < 1 .OR. Item > Len( ::aTreeMap )
            MsgOOHGError( "ItemReadonly Method: Invalid Item Reference. Program Terminated" )
         EndIf
         
         Pos := Item
      Else
         Pos := aScan( ::aTreeIdMap, Item )
         
         If Pos == 0
            MsgOOHGError( "ItemReadonly Method: Invalid Item Id. Program Terminated" )
         EndIf
      EndIf
   EndIf

Return ::aTreeRO[ Pos ]

*------------------------------------------------------------------------------*
METHOD GetParent( Item ) CLASS TTree
*------------------------------------------------------------------------------*
Local Pos, ItemHandle, ParentHandle, ParentItem

   If ! ::ItemIds
      If Item < 1 .OR. Item > Len( ::aTreeMap )
         MsgOOHGError( "GetParent Method: Invalid Item Reference. Program Terminated" )
      EndIf

      Pos := Item
   Else
      Pos := aScan( ::aTreeIdMap, Item )

      If Pos == 0
         MsgOOHGError( "GetParent Method: Invalid Item Id. Program Terminated" )
      EndIf
   EndIf

   ItemHandle := ::aTreeMap[ Pos ]
   ParentHandle := TreeView_GetParent( ::hWnd, ItemHandle )
   
   If ! ::ItemIds
      ParentItem := aScan( ::aTreeMap, ParentHandle )
   Else
      ParentItem := ::aTreeIdMap( aScan( ::aTreeMap, ParentHandle ) )
   EndIf
   
Return ParentItem

*------------------------------------------------------------------------------*
METHOD GetChildren( Item ) CLASS TTree
*------------------------------------------------------------------------------*
Local Pos, ItemHandle, ChildHandle, ChildItem, ChildrenItems

   If ! ::ItemIds
      If Item < 1 .OR. Item > Len( ::aTreeMap )
         MsgOOHGError( "GetParent Method: Invalid Item Reference. Program Terminated" )
      EndIf

      Pos := Item
   Else
      Pos := aScan( ::aTreeIdMap, Item )

      If Pos == 0
         MsgOOHGError( "GetParent Method: Invalid Item Id. Program Terminated" )
      EndIf
   EndIf

   ItemHandle := ::aTreeMap[ Pos ]
   
   ChildrenItems := {}
   
   ChildHandle := TreeView_GetChild( ::hWnd, ItemHandle )
   
   do while ChildHandle != 0
      If ! ::ItemIds
         ChildItem := aScan( ::aTreeMap, ChildHandle )
      Else
         ChildItem := ::aTreeIdMap( aScan( ::aTreeMap, ChildHandle ) )
      EndIf

      aAdd( ChildrenItems, ChildItem )
      
      ChildHandle := TreeView_GetNextSibling( ::hWnd, ChildHandle )
   enddo

Return ChildrenItems

*-----------------------------------------------------------------------------*
METHOD LookForKey( nKey, nFlags ) CLASS TTree
*-----------------------------------------------------------------------------*

   If nKey == VK_ESCAPE .and. ::hWndEditCtrl != Nil
     Return Nil
   Endif
   
Return ::Super:LookForKey( nKey, nFlags )

*------------------------------------------------------------------------------*
METHOD Release() CLASS TTree
*------------------------------------------------------------------------------*
Local StateImageList := Treeview_GetImageList( ::hWnd, TVSIL_STATE )

   ::OnLabelEdit := Nil
   ::OnCheckChange := Nil

   If StateImageList != Nil
      ImageList_Destroy( StateImageList )
   EndIf

Return ::Super:Release()

#pragma BEGINDUMP
#define _WIN32_IE      0x0500

#ifndef HB_OS_WIN_32_USED
   #define HB_OS_WIN_32_USED
#endif

#define _WIN32_WINNT   0x0400

#include <shlobj.h>
#include <windows.h>
#include <windowsx.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "winreg.h"
#include "tchar.h"
#include <olectl.h>
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
   LONG CurStyle;

   iStyle = hb_parni( 6 ) | WS_CHILD ;
   
   StyleEx = _OOHG_RTL_Status( hb_parl( 7 ) );
   if( hb_parl( 9 ) )
   {
      StyleEx = WS_EX_CLIENTEDGE | StyleEx;
   }

   icex.dwSize = sizeof( INITCOMMONCONTROLSEX );
   icex.dwICC  = ICC_TREEVIEW_CLASSES ;
   InitCommonControlsEx(&icex);

   hWndTV = CreateWindowEx( StyleEx, WC_TREEVIEW, "", iStyle,
                            hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ),
                            HWNDparam( 1 ), NULL, GetModuleHandle( NULL ), NULL );

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( ( HWND ) hWndTV, GWL_WNDPROC, ( LONG ) SubClassFunc );

   if( hb_parl( 8 ) )
   {
      CurStyle = GetWindowLong(hWndTV, GWL_STYLE);
      SetWindowLong(hWndTV, GWL_STYLE, CurStyle | TVS_CHECKBOXES);
   }
   
   HWNDret( hWndTV );
}

HB_FUNC( ADDTREEITEM )
{
   HWND hWndTV = HWNDparam( 1 );
   HTREEITEM hPrev = HTREEparam( 2 );
   TV_ITEM tvi;
   TV_INSERTSTRUCT is;

   tvi.mask           = TVIF_TEXT | TVIF_IMAGE | TVIF_SELECTEDIMAGE | TVIF_PARAM;
   tvi.pszText        = ( LPSTR ) hb_parc( 3 );
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
   char     ItemText [ 256 ];

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
   char     ItemText [ 256 ];

   memset( &TreeItem, 0, sizeof( TV_ITEM ) );

   TreeItemHandle = HTREEparam( 2 );
   strcpy( ItemText, hb_parc( 3 ) );

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

   TV_ITEM      TreeItem ;

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

HB_FUNC( TREEVIEW_GETINDENT )
{
   UINT iIndent = TreeView_GetIndent( HWNDparam( 1 ) );

   hb_retni( iIndent );
}

HB_FUNC( TREEVIEW_SETINDENT )
{
   TreeView_SetIndent( HWNDparam( 1 ), hb_parni( 2 ) );
}

static WNDPROC lpfnOldWndProcEditCtrl = 0;
static HWND hwndTreeView = NULL;

static LRESULT APIENTRY SubClassFuncEditCtrl( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   LPMSG m ;

   if( msg == WM_GETDLGCODE )
   {
      m = (LPMSG) lParam ;

      if( m && m->message == WM_KEYDOWN )
      {
         if( m->wParam == VK_ESCAPE )
         {
            TreeView_EndEditLabelNow( hwndTreeView, (WPARAM) TRUE );
            return DLGC_WANTMESSAGE;
         }
         else if( m->wParam == VK_RETURN )
         {
            TreeView_EndEditLabelNow( hwndTreeView, (WPARAM) FALSE );
            return DLGC_WANTMESSAGE;
         }
      }
   }

   return (LRESULT) CallWindowProc( lpfnOldWndProcEditCtrl, hWnd, msg, wParam, lParam );
}

HB_FUNC( SUBCLASSEDITCTRL )
{
   hwndTreeView = HWNDparam( 3 ) ;
   lpfnOldWndProcEditCtrl = ( WNDPROC ) SetWindowLong( HWNDparam( 1 ), GWL_WNDPROC, ( LONG ) SubClassFuncEditCtrl );
}

HB_FUNC( TREEVIEW_GETKEYDOWN )
{
   LPNMLVKEYDOWN ptvkd = (LPNMLVKEYDOWN) (LPARAM) hb_parnl( 1 );

   hb_retni( ptvkd->wVKey );
}

HB_FUNC( TREEVIEW_LABELVALUE )
{
   LPNMTVDISPINFO lptvdi = (LPNMTVDISPINFO) (LPARAM) hb_parnl( 1 );

   if( lptvdi->item.pszText )
      hb_retc( lptvdi->item.pszText );
   else
      hb_ret();
}

int Treeview_Notify_CustomDraw( PHB_ITEM pSelf, LPARAM lParam )
{
   LPNMTVCUSTOMDRAW lptvcd = (LPNMTVCUSTOMDRAW) lParam;
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   LONG lSelColor;

   /* stage 1: whole control */
   if( lptvcd->nmcd.dwDrawStage == CDDS_PREPAINT )
   {
      return CDRF_NOTIFYITEMDRAW;
   }
   /* stage 2: for each item */
   else if( lptvcd->nmcd.dwDrawStage == CDDS_ITEMPREPAINT )
   {
      if( lptvcd->nmcd.uItemState & CDIS_SELECTED)
      {
         /* Get selected item's color */
         _OOHG_Send( pSelf, s_aSelColor );
         hb_vmSend( 0 );

         lptvcd->clrText = (COLORREF) ( ( oSelf->lFontColor == -1 ) ? GetSysColor( COLOR_WINDOW ) : oSelf->lFontColor );
         
         if( _OOHG_DetermineColor( hb_param( -1, HB_IT_ANY ), &lSelColor ) )
         {
            lptvcd->clrTextBk = (COLORREF) lSelColor;
         }
         else
         {
            lptvcd->clrTextBk = (COLORREF) ( ( oSelf->lFontColor == -1 ) ? GetSysColor( COLOR_WINDOWTEXT ) : oSelf->lFontColor );
         }
      }
      else
      {
         lptvcd->clrText = (COLORREF) ( ( oSelf->lFontColor == -1 ) ? GetSysColor( COLOR_WINDOWTEXT ) : oSelf->lFontColor );
         lptvcd->clrTextBk = (COLORREF) ( ( oSelf->lBackColor == -1 ) ? GetSysColor( COLOR_WINDOW ) : oSelf->lBackColor ) ;
      }
      return CDRF_NEWFONT;
   }
   /* stage 3: for each subitem of the focused item */
   else if( lptvcd->nmcd.dwDrawStage == ( CDDS_SUBITEM | CDDS_ITEMPREPAINT ) )
   {
      return CDRF_DODEFAULT;
   }
   else
   {
      return CDRF_DODEFAULT;
   }
}

HB_FUNC( TREEVIEW_NOTIFY_CUSTOMDRAW )
{
   hb_retni( Treeview_Notify_CustomDraw( hb_param( 1, HB_IT_OBJECT ), ( LPARAM ) hb_parnl( 2 ) ) );
}

void PreProcess_StateChange( HWND hWnd, LPARAM lParam )
{
   LPNMHDR lpnmh = (LPNMHDR) lParam;
   TVHITTESTINFO ht;

   DWORD dwpos = GetMessagePos();

   ht.pt.x = GET_X_LPARAM( dwpos );
   ht.pt.y = GET_Y_LPARAM( dwpos );

   MapWindowPoints( HWND_DESKTOP, lpnmh->hwndFrom, &ht.pt, 1 );

   TreeView_HitTest( lpnmh->hwndFrom, &ht );

   if( TVHT_ONITEMSTATEICON & ht.flags )
   {
      PostMessage( hWnd, WM_APP + 8, 0, (LPARAM) ht.hItem );
   }
}

HB_FUNC( PREPROCESS_STATECHANGE )
{
   PreProcess_StateChange( HWNDparam( 1 ), (LPARAM) hb_parnl( 2 ) );
}

HB_FUNC ( GETITEMHWND )
{
   HTREEret( HTREEparam( 1 ) );
}

HB_FUNC( TREEVIEW_GETCHECKSTATE )
{
   HTREEITEM TreeItemHandle;
   TV_ITEM   TreeItem;

   memset( &TreeItem, 0, sizeof( TV_ITEM ) );

   TreeItemHandle = HTREEparam( 2 );

   TreeItem.mask = TVIF_HANDLE | TVIF_STATE;
   TreeItem.hItem = TreeItemHandle;
   TreeItem.stateMask = TVIS_STATEIMAGEMASK;

   TreeView_GetItem( HWNDparam( 1 ), &TreeItem );

   TreeItem.state = TreeItem.state >> 12;
   TreeItem.state = TreeItem.state - 1;

   /* Return values: -1 = no checkbox image, 0 = unchecked, 1 = checked */
   hb_retni( TreeItem.state );
}

HB_FUNC( TREEVIEW_SETCHECKSTATE )
{
   HTREEITEM TreeItemHandle;
   TV_ITEM   TreeItem;

   memset( &TreeItem, 0, sizeof( TV_ITEM ) );

   TreeItemHandle = HTREEparam( 2 );

   TreeItem.mask = TVIF_HANDLE | TVIF_STATE;
   TreeItem.hItem = TreeItemHandle;
   TreeItem.stateMask = TVIS_STATEIMAGEMASK;

   if( hb_parl( 3 ) )
   {
      TreeItem.state = 1;
   }
   else
   {
      TreeItem.state = 0;
   }
   TreeItem.state = TreeItem.state + 1;
   TreeItem.state = TreeItem.state << 12;

   TreeView_SetItem( HWNDparam( 1 ), &TreeItem );
}

/*
 * TreeView_GetImageList( :hWnd, TVSIL_NORMAL )
 * Retrieves the normal image list, which contains selected, nonselected, and
 * overlay images for the items of a tree-view control.
 *
 * TreeView_GetImageList( :hWnd, TVSIL_STATE )
 * Retrieves the state image list. You can use state images to indicate
 * application-defined item states. A state image is displayed to the left
 * of an item's selected or nonselected image.
 */
HB_FUNC( TREEVIEW_GETIMAGELIST )
{
   HIMAGELIST himl = TreeView_GetImageList( HWNDparam( 1 ), hb_parni( 2 ) );

   hb_reta( 1 );
   HB_STORNL( ( LONG ) himl, -1, 1 );
}

HB_FUNC( TREEVIEW_EDITLABEL )
{
   HWNDret( TreeView_EditLabel( HWNDparam( 1 ), HTREEparam( 2 ) ) );
}

HB_FUNC( TREEVIEW_ENDEDITLABELNOW )
{
   hb_retl( TreeView_EndEditLabelNow( HWNDparam( 1 ), (WPARAM) hb_parl( 2 ) ) );
}

HB_FUNC_STATIC( TTREE_FONTCOLOR )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &oSelf->lFontColor, ( hb_pcount() >= 1 ) ) )
   {
      if( ValidHandler( oSelf->hWnd ) )
      {
         if( oSelf->lFontColor != -1 )
         {
            TreeView_SetTextColor( oSelf->hWnd, oSelf->lFontColor );
         }
         else
         {
            TreeView_SetTextColor( oSelf->hWnd, GetSysColor( COLOR_WINDOWTEXT ) );
         }
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   /* Return value was set in _OOHG_DetermineColorReturn() */
}

#pragma ENDDUMP
