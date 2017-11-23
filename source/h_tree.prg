/*
* $Id: h_tree.prg $
*/
/*
* ooHG source code:
* Tree control
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

STATIC _OOHG_ActiveTree := Nil

CLASS TTree FROM TControl

   DATA Type                 INIT "TREE" READONLY
   DATA nWidth               INIT 120
   DATA nHeight              INIT 120
   DATA ItemIds              INIT .F.
   DATA aTreeMap             INIT {}
   DATA aTreeIdMap           INIT {}
   DATA aTreeNode            INIT {}
   DATA InitValue            INIT Nil
   DATA SetImageListCommand  INIT TVM_SETIMAGELIST
   DATA bOnEnter             INIT Nil
   DATA aSelColor            INIT BLUE             // background color of the select node
   DATA OnLabelEdit          INIT Nil
   DATA Valid                INIT Nil
   DATA aTreeRO              INIT {}
   DATA ReadOnly             INIT .T.
   DATA OnCheckChange        INIT Nil
   DATA hWndEditCtrl         INIT Nil
   DATA lSelBold             INIT .F.
   DATA aTreeEnabled         INIT {}
   DATA AutoScrollTimer      INIT Nil
   DATA AutoExpandTimer      INIT Nil
   DATA aTreeNoDrag          INIT {}
   DATA DragImageList        INIT 0                // contains drag image
   DATA DragActive           INIT .F.              // .T. if a drag and drop operation is going on
   DATA DragEnding           INIT .F.              // .T. if a drag and drop operation is ending
   DATA ItemOnDrag           INIT 0                // handle of the item being dragged
   DATA aTarget              INIT {}               // posible targets for the drop
   DATA LastTarget           INIT Nil              // last target hovered
   DATA CtrlLastDrop         INIT Nil              // reference to the control target of last drop operation
   DATA ItemLastDrop         INIT Nil              // reference to item added o moved in last drop operation
   DATA nLastIDNumber        INIT 0                // last number used by AutoID function
   DATA aItemIDs             INIT {}
   DATA OnMouseDrop          INIT Nil
   DATA OnDrop              INIT nil               // executed after drop is finished

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
   METHOD ItemReadonly
   METHOD SelColor           SETGET
   METHOD CheckItem
   METHOD GetParent
   METHOD GetChildren
   METHOD LookForKey
   METHOD Release
   METHOD BoldItem
   METHOD ItemEnabled
   METHOD CopyItem
   METHOD MoveItem
   METHOD ItemImages
   METHOD ItemDraggable
   METHOD IsItemCollapsed
   METHOD HandleToItem
   METHOD ItemToHandle
   METHOD ItemVisible
   METHOD IsItemExpanded
   METHOD IsItemVisible
   METHOD FirstVisible
   METHOD PrevVisible
   METHOD NextVisible
   METHOD LastVisible
   METHOD VisibleCount
   METHOD ItemHeight         SETGET
   METHOD SelectionID        SETGET
   METHOD IsItemValid
   METHOD BackColor          SETGET

   ENDCLASS

METHOD Define( ControlName, ParentForm, row, col, width, height, change, ;
      tooltip, fontname, fontsize, gotfocus, lostfocus, dblclick, ;
      break, value, HelpId, aImgNode, aImgItem, noBot, bold, italic, ;
      underline, strikeout, itemids, lRtl, onenter, lDisabled, ;
      invisible, notabstop, fontcolor, BackColor, lFullRowSel, ;
      lChkBox, lEdtLbl, lNoHScr, lNoScroll, lHotTrak, lNoLines, ;
      lNoBut, lDrag, lSingle, lNoBor, aSelCol, labeledit, valid, ;
      checkchange, indent, lSelBold, lDrop, aTarget, ondrop, lOwnToolTip ) CLASS TTree

   LOCAL Controlhandle, nStyle, ImgDefNode, ImgDefItem, aBitmaps := array(4), oCtrl

   ASSIGN ::nWidth      VALUE Width    TYPE "N"
   ASSIGN ::nHeight     VALUE Height   TYPE "N"
   ASSIGN ::nRow        VALUE row      TYPE "N"
   ASSIGN ::nCol        VALUE col      TYPE "N"
   ASSIGN ::lSelBold    VALUE lSelBold TYPE "L"
   ASSIGN ::DropEnabled VALUE lDrop    TYPE "L"
   ASSIGN ::ItemIds     VALUE itemids  TYPE "L"

   ::SetForm( ControlName, ParentForm, FontName, FontSize, , , .t., lRtl )

   nStyle := ::InitStyle( nStyle, , invisible, notabstop, lDisabled )
   IF HB_IsLogical( lFullRowSel ) .AND. lFullRowSel
      nStyle += TVS_FULLROWSELECT
   ELSEIF ! HB_IsLogical( lNoLines ) .OR. ! lNoLines
      nStyle += TVS_HASLINES

      IF ! HB_IsLogical( noBot ) .OR. ! noBot
         nStyle += TVS_LINESATROOT
      ENDIF
   ENDIF
   IF ! HB_IsLogical( lDrag ) .OR. ! lDrag
      nStyle += TVS_DISABLEDRAGDROP
   ENDIF
   IF HB_IsLogical( lEdtLbl ) .AND. lEdtLbl
      nStyle += TVS_EDITLABELS
      ::ReadOnly := .F.
   ENDIF
   IF HB_IsLogical( lNoScroll ) .AND. lNoScroll
      nStyle += TVS_NOSCROLL
   ELSEIF HB_IsLogical( lNoHScr ) .AND. lNoHScr
      nStyle += TVS_NOHSCROLL
   ENDIF
   IF ! HB_IsLogical( lNoBut ) .OR. ! lNoBut
      nStyle += TVS_HASBUTTONS
   ENDIF
   IF HB_IsLogical( lHotTrak ) .AND. lHotTrak
      nStyle += TVS_TRACKSELECT
   ENDIF
   IF HB_IsLogical( lSingle ) .AND. lSingle
      nStyle += TVS_SINGLEEXPAND
   ENDIF
   nStyle += TVS_SHOWSELALWAYS

   ASSIGN lChkBox VALUE lChkBox TYPE "L" DEFAULT .F.

   ::SetSplitBoxInfo( Break )
   ControlHandle := InitTree( ::ContainerhWnd, ::ContainerCol, ::ContainerRow, ::Width, ::Height, nStyle, ::lRtl, lChkBox, !HB_IsLogical( lNoBor ) .OR. ! lNoBor )

   ::Register( ControlHandle, ControlName, HelpId )
   ::SetFont( , , bold, italic, underline, strikeout )

   ImgDefNode := iif( HB_IsArray( aImgNode ), len( aImgNode ), 0 )
   ImgDefItem := iif( HB_IsArray( aImgItem ), len( aImgItem ), 0 )

   IF ImgDefNode > 0
      // node default
      aBitmaps[ 1 ] := aImgNode[ 1 ]
      aBitmaps[ 2 ] := aImgNode[ ImgDefNode ]

      IF ImgDefItem > 0
         // item default
         aBitmaps[ 3 ] := aImgItem[ 1 ]
         aBitmaps[ 4 ] := aImgItem[ ImgDefItem ]
      ELSE
         // copy node default if there's no item default
         aBitmaps[ 3 ] := aImgNode[ 1 ]
         aBitmaps[ 4 ] := aImgNode[ ImgDefNode ]
      ENDIF

      ::ImageListColor := GetSysColor( COLOR_3DFACE )
      ::ImageListFlags := LR_LOADTRANSPARENT + LR_DEFAULTCOLOR + LR_LOADMAP3DCOLORS

      ::AddBitMap( aBitmaps )
   ENDIF

   ::aTreeMap     := {}
   ::aTreeIdMap   := {}
   ::aTreeNode    := {}
   ::aTreeRO      := {}
   ::aTreeEnabled := {}
   ::aTreeNoDrag  := {}
   ::aItemIDs     := {}

   IF ::ItemIds
      ::InitValue := Value
   ELSE
      ASSIGN ::InitValue VALUE Value TYPE "N" DEFAULT 0
   ENDIF

   ::BackColor := BackColor

   ASSIGN ::OnDrop        VALUE ondrop      TYPE "B"
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
   ASSIGN ::aTarget       VALUE aTarget     TYPE "A" DEFAULT { Self }

   // this functions is called in WM_MOUSEMOVE event
   IF ! HB_IsBlock( ::OnMouseDrag )
      ::OnMouseDrag := {|oOrigin, oTarget, wParam| TTree_OnMouseDrag( oOrigin, oTarget, wParam ) }
   ENDIF

   // this functions is called in WM_LBUTTONUP event
   IF ! HB_IsBlock( ::OnMouseDrop )
      ::OnMouseDrop := {|oOrigin, oTarget, wParam| TTree_OnMouseDrop( oOrigin, oTarget, wParam ) }
   ENDIF

   ASSIGN lOwnToolTip VALUE lOwnToolTip TYPE "L" DEFAULT .F.
   IF ! lOwnToolTip .AND. ! HB_IsObject( :: Parent:oToolTip )
      lOwnToolTip := .T.
   ENDIF
   IF lOwnToolTip
      oCtrl := TToolTip():Define( Nil, Self )
      IF HB_IsObject( ::Parent:oToolTip )
         WITH OBJECT ::Parent:oToolTip
            oCtrl:AutoPopTime := :AutoPopTime
            oCtrl:InitialTime := :InitialTime
            oCtrl:ReshowTime  := :ReshowTime
            oCtrl:WindowWidth := :WindowWidth
            oCtrl:Title       := :Title
            oCtrl:Icon        := :Icon
            oCtrl:WindowWidth := :WindowWidth
            oCtrl:MultiLine   := :MultiLine
         END WITH
      ENDIF
      ::oToolTip := oCtrl
   ELSE
      // Use parent's tooltip
      oCtrl :=  ::oToolTip
   ENDIF
   SendMessage( ::hWnd, TVM_SETTOOLTIPS, oCtrl:hWnd , 0 )
   ::Tooltip := tooltip

   _OOHG_ActiveTree := Self

   RETURN Self

FUNCTION AutoID( oTree )

   LOCAL Id

   DO WHILE .T.
      oTree:nLastIDNumber ++

      Id := oTree:Name + "_" + ltrim(str( oTree:nLastIDNumber ) )

      IF aScan( oTree:aTreeIdMap, Id) == 0
         EXIT
      ENDIF
   ENDDO

   RETURN Id

METHOD AddItem( Value, Parent, Id, aImage, lChecked, lReadOnly, lBold, ;
      lDisabled, lNoDrag, lAssignID ) CLASS TTree

   LOCAL TreeItemHandle, ImgDef, iUnSel, iSel, iID
   LOCAL NewHandle, TempHandle, i, Pos, ChildHandle, BackHandle, ParentHandle, iPos

   ASSIGN lChecked  VALUE lChecked  TYPE "L" DEFAULT .F.
   ASSIGN lReadOnly VALUE lReadOnly TYPE "L" DEFAULT .F.
   ASSIGN lBold     VALUE lBold     TYPE "L" DEFAULT .F.
   ASSIGN lDisabled VALUE lDisabled TYPE "L" DEFAULT .F.
   ASSIGN lNoDrag   VALUE lNoDrag   TYPE "L" DEFAULT .F.
   ASSIGN lAssignID VALUE lAssignID TYPE "L" DEFAULT .F.

   ImgDef := iif( HB_IsArray( aImage ), len( aImage ), 0 )

   IF ( ::ItemIds .and. Parent == Nil ) .OR. ( ! ::ItemIds .and. Parent == 0 )
      IF ImgDef == 0
         // pointer to default node bitmaps, no bitmap loaded
         iUnsel := 0
         iSel   := 1
      ELSE
         IF HB_IsNumeric( aImage[ 1 ] )
            iUnSel := aImage[ 1 ]
         ELSE
            IF ! ValidHandler( ::ImageList )
               ::ImageListColor := GetSysColor( COLOR_3DFACE )
               ::ImageListFlags := LR_LOADTRANSPARENT + LR_DEFAULTCOLOR + LR_LOADMAP3DCOLORS
            ENDIF

            iUnSel := ::AddBitMap( aImage[ 1 ] ) - 1
         ENDIF

         IF ImgDef == 1
            // if only one bitmap in array isel = iunsel, only one bitmap loaded
            iSel := iUnSel
         ELSE
            IF HB_IsNumeric( aImage[ 2 ] )
               iSel := aImage[ 2 ]
            ELSE
               IF ! ValidHandler( ::ImageList )
                  ::ImageListColor := GetSysColor( COLOR_3DFACE )
                  ::ImageListFlags := LR_LOADTRANSPARENT + LR_DEFAULTCOLOR + LR_LOADMAP3DCOLORS
               ENDIF

               iSel := ::AddBitMap( aImage[ 2 ] ) - 1
            ENDIF
         ENDIF
      ENDIF

      IF ::ItemIds
         IF Id == Nil
            IF lAssignID
               Id := AutoID( Self )
            ELSE
               MsgOOHGError( "Additem: Item Id Is Nil. Program terminated." )
            ENDIF
         ELSEIF aScan( ::aTreeIdMap, Id ) != 0
            IF lAssignID
               Id := AutoID( Self )
            ELSE
               MsgOOHGError( "Additem: Item Id Already In Use. Program terminated." )
            ENDIF
         ENDIF

         aAdd( ::aItemIDs, Id )
         iID := len( ::aItemIDs )
      ELSE
         IF Id == Nil
            iID := 0
         ELSEIF aScan( ::aTreeIdMap, Id ) == 0
            aAdd( ::aItemIDs, Id )
            iID := len( ::aItemIDs )
         ELSEIF lAssignID
            Id := AutoID( Self )

            aAdd( ::aItemIDs, Id )
            iID := len( ::aItemIDs )
         ELSE
            MsgOOHGError( "Additem: Item Id Already In Use. Program terminated." )
         ENDIF
      ENDIF

      NewHandle := AddTreeItem( ::hWnd, 0, Value, iUnsel, iSel, iID )

      // add new element and save handle, id, readonly, disabled, drag mode
      aAdd( ::aTreeMap, NewHandle )
      aAdd( ::aTreeIdMap, Id )
      aAdd( ::aTreeRO, lReadOnly )
      aAdd( ::aTreeEnabled, ! lDisabled )
      aAdd( ::aTreeNoDrag, lNoDrag )

      // set return value
      IF ::ItemIds
         iPos := Id
      ELSE
         iPos := len( ::aTreeMap )
      ENDIF
   ELSE
      IF ::ItemIds
         Pos := aScan( ::aTreeIdMap, Parent )

         IF Pos == 0
            MsgOOHGError( "Additem: Invalid Parent Reference. Program terminated." )
         ENDIF

         TreeItemHandle := ::aTreeMap[ Pos ]
      ELSE
         IF Parent < 1 .OR. Parent > len( ::aTreeMap )
            MsgOOHGError( "Additem: Invalid Parent Reference. Program terminated." )
         ENDIF

         TreeItemHandle := ::aTreeMap[ Parent ]
      ENDIF

      IF ImgDef == 0
         // pointer to default item bitmaps, no bitmap loaded
         iUnsel := 2
         iSel   := 3
      ELSE
         IF HB_IsNumeric( aImage[ 1 ] )
            iUnSel := aImage[ 1 ]
         ELSE
            IF ! ValidHandler( ::ImageList )
               ::ImageListColor := GetSysColor( COLOR_3DFACE )
               ::ImageListFlags := LR_LOADTRANSPARENT + LR_DEFAULTCOLOR + LR_LOADMAP3DCOLORS
            ENDIF

            iUnSel := ::AddBitMap( aImage[ 1 ] ) - 1
         ENDIF

         IF ImgDef == 1
            // if only one bitmap in array isel = iunsel, only one bitmap loaded
            iSel := iUnSel
         ELSE
            IF HB_IsNumeric( aImage[ 2 ] )
               iSel := aImage[ 2 ]
            ELSE
               IF ! ValidHandler( ::ImageList )
                  ::ImageListColor := GetSysColor( COLOR_3DFACE )
                  ::ImageListFlags := LR_LOADTRANSPARENT + LR_DEFAULTCOLOR + LR_LOADMAP3DCOLORS
               ENDIF

               iSel := ::AddBitMap( aImage[ 2 ] ) - 1
            ENDIF
         ENDIF
      ENDIF

      IF ::ItemIds
         IF Id == Nil
            IF lAssignID
               Id := AutoID( Self )
            ELSE
               MsgOOHGError( "Additem: Item Id Is Nil. Program terminated." )
            ENDIF
         ELSEIF aScan( ::aTreeIdMap, Id ) != 0
            IF lAssignID
               Id := AutoID( Self )
            ELSE
               MsgOOHGError( "Additem: Item Id Already In Use. Program terminated." )
            ENDIF
         ENDIF

         aAdd( ::aItemIDs, Id )
         iID := len( ::aItemIDs )
      ELSE
         IF Id == Nil
            iID := 0
         ELSEIF aScan( ::aTreeIdMap, Id ) == 0
            aAdd( ::aItemIDs, Id )
            iID := len( ::aItemIDs )
         ELSEIF lAssignID
            Id := AutoID( Self )

            aAdd( ::aItemIDs, Id )
            iID := len( ::aItemIDs )
         ELSE
            MsgOOHGError( "Additem: Item Id Already In Use. Program terminated." )
         ENDIF
      ENDIF

      // add new element
      NewHandle := AddTreeItem( ::hWnd, TreeItemHandle, Value, iUnsel, iSel, iID )

      // determine position of new item
      TempHandle := TreeView_GetChild( ::hWnd, TreeItemHandle )

      i := 0
      DO WHILE .t.
         i++

         IF TempHandle == NewHandle
            EXIT
         ENDIF

         ChildHandle := TreeView_GetChild( ::hWnd, TempHandle )

         IF ChildHandle == 0
            BackHandle := TempHandle
            TempHandle := TreeView_GetNextSibling( ::hWnd, TempHandle )
         ELSE
            i++
            BackHandle := Childhandle
            TempHandle := TreeView_GetNextSibling( ::hWnd, ChildHandle )
         ENDIF

         DO WHILE TempHandle == 0
            ParentHandle := TreeView_GetParent( ::hWnd, BackHandle )

            TempHandle := TreeView_GetNextSibling( ::hWnd, ParentHandle )

            IF TempHandle == 0
               BackHandle := ParentHandle
            ENDIF
         ENDDO
      ENDDO

      // insert new element
      aSize( ::aTreeMap, TreeView_GetCount( ::hWnd ) )
      aSize( ::aTreeIdMap, TreeView_GetCount( ::hWnd ) )
      aSize( ::aTreeRO, TreeView_GetCount( ::hWnd ) )
      aSize( ::aTreeEnabled, TreeView_GetCount( ::hWnd ) )
      aSize( ::aTreeNoDrag, TreeView_GetCount( ::hWnd ) )

      IF ::ItemIds
         iPos := Pos + i
      ELSE
         iPos := Parent + i
      ENDIF

      aIns( ::aTreeMap, iPos )
      aIns( ::aTreeIdMap, iPos )
      aIns( ::aTreeRO, iPos )
      aIns( ::aTreeEnabled, iPos )
      aIns( ::aTreeNoDrag, iPos )

      // assign handle, id, readonly, disabled, drag mode
      ::aTreeMap[ iPos ]     := NewHandle
      ::aTreeIdMap[ iPos ]   := Id
      ::aTreeRO[ iPos ]      := lReadOnly
      ::aTreeEnabled[ iPos ] := ! lDisabled
      ::aTreeNoDrag[ iPos ]  := lNoDrag

      // set return value
      IF ::ItemIds
         iPos := Id
      ELSE
         iPos := iPos
      ENDIF
   ENDIF

   ::CheckItem( iPos, lChecked )
   ::BoldItem( iPos, lBold )

   RETURN iPos

METHOD SelectionID( Id ) CLASS TTree

   LOCAL Handle, Pos, OldID, iID

   Handle := TreeView_GetSelection( ::hWnd )
   IF Handle == 0

      RETURN NIL
   ENDIF

   Pos := aScan( ::aTreeMap, Handle )
   IF Pos == 0
      MsgOOHGError( "SelectionID: Item Selected Is Invalid. Program terminated." )
   ENDIF

   IF pcount() > 0
      // set
      OldID := ::aTreeIdMap[ Pos ]

      IF Id != OldID
         IF OldID != Nil
            iID := aScan( ::aItemIDs, OldID )
            IF iID == 0
               MsgOOHGError( "SelectionID: Invalid Item Id. Program terminated." )
            ENDIF

            aDel( ::aItemIDs, iID )
            aSize( ::aItemIDs, len( ::aItemIDs ) - 1 )
         ENDIF

         IF Id == Nil
            IF ::ItemIds
               // items without ID are not allowed, goto get
            ELSE
               ::aTreeIdMap[ Pos ] := Nil

               TreeView_SetSelectionID( ::hWnd, 0 )
            ENDIF
         ELSE
            IF aScan( ::aTreeIdMap, Id ) > 0
               MsgOOHGError( "SelectionID: Item Id Already In Use. Program terminated." )
            ENDIF

            ::aTreeIdMap[ Pos ] := Id

            aAdd( ::aItemIDs, Id )
            iID := len( ::aItemIDs )

            TreeView_SetSelectionID( ::hWnd, iID )
         ENDIF
      ENDIF
   ENDIF

   // get
   iID := TreeView_GetSelectionID( ::hWnd )
   IF iID == 0

      RETURN NIL
   ELSEIF iID < 0 .OR. iID > len( ::aItemIDs )
      MsgOOHGError( "SelectionID: Invalid Item Id. Program terminated." )
   ENDIF

   RETURN ::aItemIDs[ iID ]

METHOD DeleteItem( Item ) CLASS TTree

   LOCAL BeforeCount, AfterCount, DeletedCount, i, Pos, iID
   LOCAL TreeItemHandle

   BeforeCount := TreeView_GetCount( ::hWnd )

   IF ::ItemIds
      Pos := aScan( ::aTreeIdMap, Item )

      IF Pos == 0
         MsgOOHGError( "DeleteItem: Invalid Item Id. Program terminated." )
      ENDIF
   ELSE
      IF Item > BeforeCount .OR. Item < 1
         MsgOOHGError( "DeleteItem: Invalid Item Reference. Program terminated." )
      ENDIF

      Pos := Item
   ENDIF

   TreeItemHandle := ::aTreeMap[ Pos ]
   TreeView_DeleteItem( ::hWnd, TreeItemHandle )

   AfterCount := TreeView_GetCount( ::hWnd )
   DeletedCount := BeforeCount - AfterCount

   FOR i := 1 To DeletedCount
      IF ::aTreeIdMap[ Pos ] # Nil
         iID := aScan( ::aItemIDs, ::aTreeIdMap[ Pos ] )
         IF iID == 0
            MsgOOHGError( "DeleteItem: Invalid Item Id. Program terminated." )
         ENDIF

         aDel( ::aItemIDs, iID )
      ENDIF

      aDel( ::aTreeMap, Pos )
      aDel( ::aTreeIdMap, Pos )
      aDel( ::aTreeRO, Pos )
      aDel( ::aTreeEnabled, Pos )
      aDel( ::aTreeNoDrag, Pos )
   NEXT i

   aSize( ::aTreeMap, AfterCount )
   aSize( ::aTreeIdMap, AfterCount )
   aSize( ::aTreeRO, AfterCount )
   aSize( ::aTreeEnabled, AfterCount )
   aSize( ::aTreeNoDrag, AfterCount )
   aSize( ::aItemIDs, AfterCount )

   RETURN NIL

METHOD DeleteAllItems() CLASS TTree

   TreeView_DeleteAllItems( ::hWnd )
   aSize( ::aTreeMap, 0 )
   aSize( ::aTreeIdMap, 0 )
   aSize( ::aTreeRO, 0 )
   aSize( ::aTreeEnabled, 0 )
   aSize( ::aTreeNoDrag, 0 )
   aSize( ::aItemIDs, 0 )

   RETURN NIL

METHOD Item( Item, Value ) CLASS TTree

   LOCAL ItemHandle

   ItemHandle := ::ItemToHandle( Item )

   IF valtype( Value ) $ "CM"
      TreeView_SetItemText( ::hWnd, ItemHandle, left( Value, 255 ) )
   ENDIF

   RETURN TreeView_GetItemText( ::hWnd, ItemHandle )

METHOD Collapse( Item ) CLASS TTree

   LOCAL lOK

   lOK := ( SendMessage( ::hWnd, TVM_EXPAND, TVE_COLLAPSE, ::ItemToHandle( Item ) ) != 0 )

   RETURN lOK

METHOD Expand( Item ) CLASS TTree

   LOCAL lOK

   lOK := ( SendMessage( ::hWnd, TVM_EXPAND, TVE_EXPAND, ::ItemToHandle( Item ) ) != 0 )

   RETURN lOK

METHOD EndTree() CLASS TTree

   IF ( ::ItemIds .and. ::InitValue != Nil ) .OR. (! ::ItemIds .and. ::InitValue > 0 )
      TreeView_SelectItem( ::hWnd, ::ItemToHandle( ::InitValue ) )
   ENDIF

   RETURN NIL

METHOD Value( uValue ) CLASS TTree

   LOCAL TreeItemHandle, Pos

   IF ::ItemIds
      // by id
      IF uValue != Nil
         // set
         TreeItemHandle := ::ItemToHandle( uValue )
         TreeView_SelectItem( ::hWnd, TreeItemHandle )
      ENDIF

      // get
      TreeItemHandle := TreeView_GetSelection( ::hWnd )
      IF TreeItemHandle == 0
         // no item selected
         uValue := Nil
      ELSE
         Pos := aScan( ::aTreeMap, TreeItemHandle )
         IF Pos == 0
            MsgOOHGError( "Value: Invalid Item Id. Program terminated." )
         ENDIF

         uValue := ::aTreeIdMap[ Pos ]
      ENDIF
   ELSE
      // by item reference
      IF HB_IsNumeric( uValue )
         // set
         IF uValue == 0
            // select no item
            TreeItemHandle := 0
         ELSE
            TreeItemHandle := ::ItemToHandle( uValue )
         ENDIF
         TreeView_SelectItem( ::hWnd, TreeItemHandle )
      ENDIF

      // get
      TreeItemHandle := TreeView_GetSelection( ::hWnd )
      IF TreeItemHandle == 0
         // no item selected
         uValue := 0
      ELSE
         Pos := aScan( ::aTreeMap, TreeItemHandle )
         IF Pos == 0
            MsgOOHGError( "Value: Invalid Item Reference. Program terminated." )
         ENDIF

         uValue := Pos
      ENDIF
   ENDIF

   RETURN uValue

METHOD OnEnter( bEnter ) CLASS TTree

   LOCAL bRet

   IF HB_IsBlock( bEnter )
      IF _OOHG_SameEnterDblClick
         ::OnDblClick := bEnter
      ELSE
         ::bOnEnter := bEnter
      ENDIF
      bRet := bEnter
   ELSE
      bRet := iif( _OOHG_SameEnterDblClick, ::OnDblClick, ::bOnEnter )
   ENDIF

   RETURN bRet

FUNCTION _DefineTreeNode( text, aImage, Id, lChecked, lReadOnly, lBold, ;
      lDisabled, lNoDrag, lAssignID )

   LOCAL ImgDef, iUnSel, iSel, Item, iID, iPos

   ASSIGN lChecked  VALUE lChecked  TYPE "L" DEFAULT .F.
   ASSIGN lReadOnly VALUE lReadOnly TYPE "L" DEFAULT .F.
   ASSIGN lBold     VALUE lBold     TYPE "L" DEFAULT .F.
   ASSIGN lDisabled VALUE lDisabled TYPE "L" DEFAULT .F.
   ASSIGN lNoDrag   VALUE lNoDrag   TYPE "L" DEFAULT .F.
   ASSIGN lAssignID VALUE lAssignID TYPE "L" DEFAULT .F.

   ImgDef := iif( HB_IsArray( aImage ), len( aImage ), 0 )

   IF ImgDef == 0
      // pointer to default node bitmaps, no bitmap loaded
      iUnsel := 0
      iSel   := 1
   ELSE
      IF HB_IsNumeric( aImage[ 1 ] )
         iUnSel := aImage[ 1 ]
      ELSE
         IF ! ValidHandler( _OOHG_ActiveTree:ImageList )
            _OOHG_ActiveTree:ImageListColor := GetSysColor( COLOR_3DFACE )
            _OOHG_ActiveTree:ImageListFlags := LR_LOADTRANSPARENT + LR_DEFAULTCOLOR + LR_LOADMAP3DCOLORS
         ENDIF

         iUnSel := _OOHG_ActiveTree:AddBitMap( aImage[ 1 ] ) - 1
      ENDIF

      IF ImgDef == 1
         // if only one bitmap in array isel = iunsel, only one bitmap loaded
         iSel := iUnSel
      ELSE
         IF HB_IsNumeric( aImage[ 2 ] )
            iSel := aImage[ 2 ]
         ELSE
            IF ! ValidHandler( _OOHG_ActiveTree:ImageList )
               _OOHG_ActiveTree:ImageListColor := GetSysColor( COLOR_3DFACE )
               _OOHG_ActiveTree:ImageListFlags := LR_LOADTRANSPARENT + LR_DEFAULTCOLOR + LR_LOADMAP3DCOLORS
            ENDIF

            iSel := _OOHG_ActiveTree:AddBitMap( aImage[ 2 ] ) - 1
         ENDIF
      ENDIF
   ENDIF

   IF _OOHG_ActiveTree:ItemIds
      IF Id == Nil
         IF lAssignID
            Id := AutoID( _OOHG_ActiveTree )
         ELSE
            MsgOOHGError( "Define Node Function: Item Id Is Nil. Program terminated." )
         ENDIF
      ELSEIF aScan( _OOHG_ActiveTree:aTreeIdMap, Id ) != 0
         IF lAssignID
            Id := AutoID( _OOHG_ActiveTree )
         ELSE
            MsgOOHGError( "Define Node Function: Item Id Already In Use. Program terminated." )
         ENDIF
      ENDIF

      aAdd( _OOHG_ActiveTree:aItemIDs, Id )
      iID := len( _OOHG_ActiveTree:aItemIDs )
   ELSE
      IF Id == Nil
         iID := 0
      ELSEIF aScan( _OOHG_ActiveTree:aTreeIdMap, Id ) == 0
         aAdd( _OOHG_ActiveTree:aItemIDs, Id )
         iID := len( _OOHG_ActiveTree:aItemIDs )
      ELSEIF lAssignID
         Id := AutoID( _OOHG_ActiveTree )

         aAdd( _OOHG_ActiveTree:aItemIDs, Id )
         iID := len( _OOHG_ActiveTree:aItemIDs )
      ELSE
         MsgOOHGError( "Define Node Function: Item Id Already In Use. Program terminated." )
      ENDIF
   ENDIF

   Item := AddTreeItem( _OOHG_ActiveTree:hWnd, aTail( _OOHG_ActiveTree:aTreeNode ), text, iUnsel, iSel, iID )

   aAdd( _OOHG_ActiveTree:aTreeMap, Item )
   aAdd( _OOHG_ActiveTree:aTreeNode, Item )
   aAdd( _OOHG_ActiveTree:aTreeIdMap, Id )
   aAdd( _OOHG_ActiveTree:aTreeRO, lReadOnly )
   aAdd( _OOHG_ActiveTree:aTreeEnabled, ! lDisabled )
   aAdd( _OOHG_ActiveTree:aTreeNoDrag, lNoDrag )

   IF _OOHG_ActiveTree:ItemIds
      iPos := Id
   ELSE
      iPos := len( _OOHG_ActiveTree:aTreeMap )
   ENDIF

   _OOHG_ActiveTree:CheckItem( iPos, lChecked )
   _OOHG_ActiveTree:BoldItem( iPos, lBold )

   RETURN iPos

FUNCTION _EndTreeNode()

   aSize( _OOHG_ActiveTree:aTreeNode, len( _OOHG_ActiveTree:aTreeNode ) - 1 )

   RETURN NIL

FUNCTION _DefineTreeItem( text, aImage, Id, lChecked, lReadOnly, lBold, ;
      lDisabled, lNoDrag, lAssignID )

   LOCAL Item, ImgDef, iUnSel, iSel, iID, iPos

   ASSIGN lChecked  VALUE lChecked  TYPE "L" DEFAULT .F.
   ASSIGN lReadOnly VALUE lReadOnly TYPE "L" DEFAULT .F.
   ASSIGN lBold     VALUE lBold     TYPE "L" DEFAULT .F.
   ASSIGN lDisabled VALUE lDisabled TYPE "L" DEFAULT .F.
   ASSIGN lNoDrag   VALUE lNoDrag   TYPE "L" DEFAULT .F.
   ASSIGN lAssignID VALUE lAssignID TYPE "L" DEFAULT .F.

   ImgDef := iif( HB_IsArray( aImage ), len( aImage ), 0 )

   IF ImgDef == 0
      // pointer to default node bitmaps, no bitmap loaded
      iUnsel := 2
      iSel   := 3
   ELSE
      IF HB_IsNumeric( aImage[ 1 ] )
         iUnSel := aImage[ 1 ]
      ELSE
         IF ! ValidHandler( _OOHG_ActiveTree:ImageList )
            _OOHG_ActiveTree:ImageListColor := GetSysColor( COLOR_3DFACE )
            _OOHG_ActiveTree:ImageListFlags := LR_LOADTRANSPARENT + LR_DEFAULTCOLOR + LR_LOADMAP3DCOLORS
         ENDIF

         iUnSel := _OOHG_ActiveTree:AddBitMap( aImage[ 1 ] ) - 1
      ENDIF

      IF ImgDef == 1
         // if only one bitmap in array isel = iunsel, only one bitmap loaded
         iSel := iUnSel
      ELSE
         IF HB_IsNumeric( aImage[ 2 ] )
            iSel := aImage[ 2 ]
         ELSE
            IF ! ValidHandler( _OOHG_ActiveTree:ImageList )
               _OOHG_ActiveTree:ImageListColor := GetSysColor( COLOR_3DFACE )
               _OOHG_ActiveTree:ImageListFlags := LR_LOADTRANSPARENT + LR_DEFAULTCOLOR + LR_LOADMAP3DCOLORS
            ENDIF

            iSel := _OOHG_ActiveTree:AddBitMap( aImage[ 2 ] ) - 1
         ENDIF
      ENDIF
   ENDIF

   IF _OOHG_ActiveTree:ItemIds
      IF Id == Nil
         IF lAssignID
            Id := AutoID( _OOHG_ActiveTree )
         ELSE
            MsgOOHGError( "Define Item Function: Item Id Is Nil. Program terminated." )
         ENDIF
      ELSEIF aScan( _OOHG_ActiveTree:aTreeIdMap, Id ) != 0
         IF lAssignID
            Id := AutoID( _OOHG_ActiveTree )
         ELSE
            MsgOOHGError( "Define Item Function: Item Id Already In Use. Program terminated." )
         ENDIF
      ENDIF

      aAdd( _OOHG_ActiveTree:aItemIDs, Id )
      iID := len( _OOHG_ActiveTree:aItemIDs )
   ELSE
      IF Id == Nil
         iID := 0
      ELSEIF aScan( _OOHG_ActiveTree:aTreeIdMap, Id ) == 0
         aAdd( _OOHG_ActiveTree:aItemIDs, Id )
         iID := len( _OOHG_ActiveTree:aItemIDs )
      ELSEIF lAssignID
         Id := AutoID( _OOHG_ActiveTree )

         aAdd( _OOHG_ActiveTree:aItemIDs, Id )
         iID := len( _OOHG_ActiveTree:aItemIDs )
      ELSE
         MsgOOHGError( "Define Item Function: Item Id Already In Use. Program terminated." )
      ENDIF
   ENDIF

   Item := AddTreeItem( _OOHG_ActiveTree:hWnd, aTail( _OOHG_ActiveTree:aTreeNode ), text, iUnSel, iSel, iID )

   aAdd( _OOHG_ActiveTree:aTreeMap, Item )
   aAdd( _OOHG_ActiveTree:aTreeIdMap, Id )
   aAdd( _OOHG_ActiveTree:aTreeRO, lReadOnly )
   aAdd( _OOHG_ActiveTree:aTreeEnabled, ! lDisabled )
   aAdd( _OOHG_ActiveTree:aTreeNoDrag, lNoDrag )

   IF _OOHG_ActiveTree:ItemIds
      iPos := Id
   ELSE
      iPos := len( _OOHG_ActiveTree:aTreeMap )
   ENDIF

   _OOHG_ActiveTree:CheckItem( iPos, lChecked )
   _OOHG_ActiveTree:BoldItem( iPos, lBold )

   RETURN iPos

FUNCTION _EndTree()

   _OOHG_ActiveTree:EndTree()
   _OOHG_ActiveTree := Nil

   RETURN NIL

METHOD Indent( nPixels ) CLASS TTree

   IF HB_IsNumeric( nPixels )
      // set the item's indentation, if nPixels is less than the
      // system-defined minimum width, the new width is set to the minimum.
      TreeView_SetIndent( ::hWnd, nPixels )
   ENDIF
   nPixels := TreeView_GetIndent( ::hWnd )

   RETURN nPixels

METHOD Events_Notify( wParam, lParam ) CLASS TTree

   LOCAL nNotify := GetNotifyCode( lParam )
   LOCAL cNewValue, lValid, TreeItemHandle, Item

   IF nNotify == NM_CUSTOMDRAW

      RETURN TreeView_Notify_CustomDraw( Self, lParam, ::HasDragFocus )

   ELSEIF nNotify == TVN_SELCHANGING
      TreeItemHandle := TreeView_ActualSelectedItem( lParam )

      IF TreeItemHandle == 0
         // allow

         RETURN 0
      ELSE
         IF ::ItemEnabled( ::HandleToItem( TreeItemHandle ) )
            // allow

            RETURN 0
         ELSE
            // abort

            RETURN 1
         ENDIF
      ENDIF

   ELSEIF nNotify == TVN_SELCHANGED
      IF ::lSelBold
         TreeItemHandle := TreeView_PreviousSelectedItem( lParam )
         IF TreeItemHandle != 0
            TreeView_SetBoldState( ::hWnd, TreeItemHandle, .F. )
         ENDIF

         TreeItemHandle := TreeView_ActualSelectedItem( lParam )
         IF TreeItemHandle != 0
            TreeView_SetBoldState( ::hWnd, TreeItemHandle, .T. )
         ENDIF
      ENDIF

      ::DoChange()

      RETURN NIL

   ELSEIF nNotify == TVN_BEGINLABELEDIT
      IF ::ReadOnly .OR. ::ItemReadOnly( ::Value ) .OR. ! ::ItemEnabled( ::Value )
         // abort editing

         RETURN 1
      ENDIF

      ::hWndEditCtrl := SendMessage( ::hWnd, TVM_GETEDITCONTROL, 0, 0 )
      IF ::hWndEditCtrl == Nil
         // abort editing

         RETURN 1
      ENDIF

      SubClassEditCtrl( ::hWndEditCtrl, ::hWnd )
      // allow editing

      RETURN 0

   ELSEIF nNotify == TVN_ENDLABELEDIT
      ::hWndEditCtrl := Nil

      cNewValue := TreeView_LabelValue( lParam )

      // editing was aborted
      IF cNewValue == Nil
         // revert to original value

         RETURN 0
      ENDIF

      IF HB_IsBlock( ::Valid )
         lValid := Eval( ::Valid, ::Value, cNewValue )

         IF HB_IsLogical( lValid ) .AND. ! lValid
            // force label editing after exit
            ::EditLabel()

            // revert to original value

            RETURN 0
         ENDIF
      ENDIF

      ::Item( ::Value, cNewValue )
      ::DoEvent( ::OnLabelEdit, "TREEVIEW_LABELEDIT", {::Value, ::Item( ::Value )} )

      // confirm new value

      RETURN 1

   ELSEIF nNotify == NM_CLICK .OR. nNotify == NM_DBLCLK
      TreeItemHandle := TreeView_GetItemHit( lParam )

      IF TreeItemHandle == 0
         // no item was clicked, allow default processing

         RETURN 0
      ENDIF

      IF ! ::ItemEnabled( ::HandleToItem( TreeItemHandle ) )
         // item is disabled, abort processing

         RETURN 1
      ENDIF

      IF TreeView_HitIsOnStateIcon( lParam )
         // trigger OnCheckChange procedure, see Events method
         PostMessage( ::hWnd, WM_APP + 8, 0, TreeItemHandle )
      ENDIF

      // allow default processing

      RETURN 0

   ELSEIF nNotify == TVN_BEGINDRAG
      TreeItemHandle := TreeView_ActualSelectedItem( lParam )
      Item := ::HandleToItem( TreeItemHandle )

      IF ::ItemEnabled( Item ) .AND. ::ItemDraggable( Item )
         // if the treeview has no imagelist it's not possible to create a drag image
         IF ValidHandler( ::ImageList )
            IF ::lSelBold
               ::BoldItem( ::Value, .F. )
            ENDIF

            // must be set before creating drag image to avoid problems in TreeView_Notify_CustomDraw
            ::DragActive := .T.
            ::DragEnding := .F.

            ::DragImageList := TreeView_BeginDrag( ::hWnd, lParam )

            IF ValidHandler( ::DragImageList )
               ::ItemOnDrag := TreeItemHandle
            ELSE
               ::DragActive := .F.
            ENDIF
         ENDIF
      ENDIF

      RETURN NIL

   ENDIF

   RETURN ::Super:Events_Notify( wParam, lParam )

METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TTree

   LOCAL nItem, lChecked, TargetHandle, i, oAux, Value

   IF nMsg == WM_APP + 8
      IF HB_IsBlock( ::OnCheckChange )
         nItem := ::HandleToItem( GetItemHWND( lParam ) )
         lChecked := ::CheckItem( nItem )

         ::DoEvent( ::OnCheckChange, "TREEVIEW_CHANGECHECK", {nItem, lChecked} )
      ENDIF

      RETURN NIL

   ELSEIF nMsg == WM_MOUSEMOVE
      IF ::DragActive .and. ! ::DragEnding
         IF HB_IsObject( ::LastTarget )
            ::LastTarget:HasDragFocus := .F.
         ENDIF

         _OOHG_SetMouseCoords( Self, LOWORD( lParam ), HIWORD( lParam ) )

         TargetHandle := GetWindowUnderCursor()

         IF ValidHandler( TargetHandle )
            FOR i := 1 to len( ::aTarget )
               IF HB_IsObject( ::aTarget[ i ] )
                  oAux := ::aTarget[ i ]
               ELSEIF HB_IsBlock( ::aTarget[ i ] )
                  oAux := Eval( ::aTarget[ i ] )

                  IF ! HB_IsObject( oAux )
                     oAux := Nil
                  ENDIF
               ELSE
                  oAux := Nil
               ENDIF

               IF oAux:hWnd == TargetHandle
                  EXIT
               ENDIF
            NEXT i

            IF i <= len( ::aTarget ) .AND. oAux:DropEnabled
               IF HB_IsObject( ::LastTarget )
                  IF ::LastTarget:hWnd # oAux:hWnd
                     IF __objHasData( ::LastTarget, "AutoScrollTimer" )
                        IF HB_IsObject( ::LastTarget:AutoScrollTimer )
                           ::LastTarget:AutoScrollTimer:Release()
                           ::LastTarget:AutoScrollTimer := Nil
                        ENDIF
                     ENDIF
                     IF __objHasData( ::LastTarget, "AutoExpandTimer" )
                        IF HB_IsObject( ::LastTarget:AutoExpandTimer )
                           ::LastTarget:AutoExpandTimer:Release()
                           ::LastTarget:AutoExpandTimer := Nil
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF

               ::LastTarget := oAux
               oAux:HasDragFocus := .T.

               _OOHG_EVAL( oAux:OnMouseDrag, Self, oAux, wParam )

               RETURN NIL
            ENDIF
         ENDIF

         // when dragging over no target, change cursor to NO and drag image
         TreeView_OnMouseDrag( ::hWnd, ::ItemOnDrag, Nil, wParam )
      ENDIF

      RETURN NIL

   ELSEIF nMsg == WM_LBUTTONUP     // ver WM_RBUTTONUP
      IF ::DragActive
         ::DragEnding := .T.

         IF HB_IsObject( ::LastTarget )
            ::LastTarget:HasDragFocus := .F.

            IF __objHasData( ::LastTarget, "AutoScrollTimer" )
               IF HB_IsObject( ::LastTarget:AutoScrollTimer )
                  ::LastTarget:AutoScrollTimer:Enabled := .F.
               ENDIF
            ENDIF
            IF __objHasData( ::LastTarget, "AutoExpandTimer" )
               IF HB_IsObject( ::LastTarget:AutoExpandTimer )
                  ::LastTarget:AutoExpandTimer:Enabled := .F.
               ENDIF
            ENDIF
         ENDIF

         TargetHandle := GetWindowUnderCursor()

         IF ValidHandler( TargetHandle )
            FOR i := 1 to len( ::aTarget )
               IF HB_IsObject( ::aTarget[ i ] )
                  oAux := ::aTarget[ i ]
               ELSEIF HB_IsBlock( ::aTarget[ i ] )
                  oAux := Eval( ::aTarget[ i ] )

                  IF ! HB_IsObject( oAux )
                     oAux := Nil
                  ENDIF
               ELSE
                  oAux := Nil
               ENDIF

               IF oAux:hWnd == TargetHandle
                  EXIT
               ENDIF
            NEXT

            IF i <= len( ::aTarget ) .AND. oAux:DropEnabled
               _OOHG_SetMouseCoords( Self, LOWORD( lParam ), HIWORD( lParam ) )

               ::CtrlLastDrop := oAux
               ::ItemLastDrop := _OOHG_EVAL( oAux:OnMouseDrop, Self, oAux, wParam )
            ELSE
               ::CtrlLastDrop := Nil
               ::ItemLastDrop := Nil
            ENDIF
         ELSE
            ::CtrlLastDrop := Nil
            ::ItemLastDrop := Nil
         ENDIF

         // this call fires WM_CAPTURECHANGED
         ReleaseCapture()
      ENDIF

   ELSEIF nMsg == WM_CANCELMODE .OR. nMsg == WM_CAPTURECHANGED
      IF ::DragActive
         IF HB_IsObject( ::LastTarget )
            ::LastTarget:HasDragFocus := .F.

            IF __objHasData( ::LastTarget, "AutoScrollTimer" )
               IF HB_IsObject( ::LastTarget:AutoScrollTimer )
                  ::LastTarget:AutoScrollTimer:Release()
                  ::LastTarget:AutoScrollTimer := Nil
               ENDIF
            ENDIF
            IF __objHasData( ::LastTarget, "AutoExpandTimer" )
               IF HB_IsObject( ::LastTarget:AutoExpandTimer )
                  ::LastTarget:AutoExpandTimer:Release()
                  ::LastTarget:AutoExpandTimer := Nil
               ENDIF
            ENDIF
         ENDIF

         ImageList_EndDrag()
         ImageList_Destroy( ::DragImageList )
         ::DragImageList := 0
         ::ItemOnDrag := 0
         ::DragActive := .F.

         IF HB_IsObject( ::LastTarget )
            ::LastTarget:Redraw()
         ENDIF
         ::LastTarget := Nil

         Value := ::Value
         IF ! Empty( Value ) .AND. ::lSelBold
            ::BoldItem( ::Value, .T. )
         ENDIF
         ::Redraw()

         IF HB_IsObject( ::CtrlLastDrop ) .AND. ::ItemLastDrop != Nil
            _OOHG_EVAL( ::CtrlLastDrop:OnDrop, ::ItemLastDrop )
         ENDIF
      ENDIF

   ENDIF

   RETURN ::Super:Events( hWnd, nMsg, wParam, lParam )

FUNCTION TTree_OnMouseDrag( oOrigin, oTarget, wParam )

   IF oTarget:DropEnabled
      IF oTarget:AutoScrollTimer == Nil
         // this timer fires the autoscroll function
         DEFINE TIMER 0 OBJ oTarget:AutoScrollTimer ;
            OF (oTarget) ;
            INTERVAL 200 ;
            ACTION TreeView_AutoScroll( oTarget:hWnd, oOrigin:hWnd, oOrigin:ItemOnDrag )
      ENDIF

      IF oTarget:AutoExpandTimer == Nil
         // this timer fires the autoexpand function
         DEFINE TIMER 0 OBJ oTarget:AutoExpandTimer ;
            OF (oTarget) ;
            INTERVAL 1000 ;
            ACTION TreeView_AutoExpand( oTarget:hWnd, oOrigin:hWnd, oOrigin:ItemOnDrag )
      ENDIF

      // Drag image and change cursor acordingly to target
      TreeView_OnMouseDrag( oOrigin:hWnd, oOrigin:ItemOnDrag, oTarget:hWnd, wParam )
   ELSE
      // when dragging over no target, change cursor to NO and drag image
      TreeView_OnMouseDrag( oOrigin:hWnd, oOrigin:ItemOnDrag, Nil, wParam )
   ENDIF

   RETURN NIL

FUNCTION TTree_OnMouseDrop( oOrigin, oTarget, wParam )

   LOCAL TargetHandle, Item

   IF oTarget:DropEnabled
      TargetHandle := TreeView_OnMouseDrop( oOrigin:hWnd, oOrigin:ItemOnDrag, oTarget:hWnd )

      IF TargetHandle # 0
         IF wParam == MK_CONTROL
            Item := oOrigin:CopyItem( oOrigin:HandleToItem(oOrigin:ItemOnDrag), oTarget, oTarget:HandleToItem( TargetHandle ) )
         ELSE
            Item := oOrigin:MoveItem( oOrigin:HandleToItem(oOrigin:ItemOnDrag), oTarget, oTarget:HandleToItem( TargetHandle ) )
         ENDIF
      ENDIF
   ENDIF

   RETURN Item

METHOD ItemImages( Item, aImages ) CLASS TTree

   LOCAL ItemHandle, Pos

   IF HB_IsArray( aImages ) .AND. len( aImages ) >= 2 .AND. ;
         HB_IsNumeric( aImages[ 1 ] ) .AND. aImages[ 1 ] >= 0 .AND. ;
         HB_IsNumeric( aImages[ 2 ] ) .AND. aImages[ 2 ] >= 0
      //  set
      IF ::ItemIds
         Pos := aScan( ::aTreeIdMap, Item )

         IF Pos == 0
            MsgOOHGError( "ItemImages: Invalid Item Id. Program terminated." )
         ENDIF

         ItemHandle := ::aTreeMap[ Pos ]
      ELSE
         IF Item < 1 .OR. Item > len( ::aTreeMap )
            MsgOOHGError( "ItemImages: Invalid Item Reference. Program terminated." )
         ENDIF

         ItemHandle := ::aTreeMap[ Item ]
      ENDIF

      TreeView_SetImages( ::hWnd, ItemHandle, aImages[ 1 ], aImages[ 2 ] )      // iUnSel, iSel
   ELSE
      // get
      IF ::ItemIds
         Pos := aScan( ::aTreeIdMap, Item )

         IF Pos == 0
            MsgOOHGError( "ItemImages: Invalid Item Id. Program terminated." )
         ENDIF

         ItemHandle := ::aTreeMap[ Pos ]
      ELSE
         IF Item < 1 .OR. Item > len( ::aTreeMap )
            MsgOOHGError( "ItemImages: Invalid Item Reference. Program terminated." )
         ENDIF

         ItemHandle := ::aTreeMap[ Item ]
      ENDIF
   ENDIF

   RETURN TreeView_GetImages( ::hWnd, ItemHandle )                                 // { iUnSel, iSel }

METHOD CopyItem( ItemFrom, oTarget, ItemTo, aId ) CLASS TTree

   LOCAL Pos, FromHandle, aItems, i, ItemOld, j, aImages

   // get the From item's handle
   IF ::ItemIds
      Pos := aScan( ::aTreeIdMap, ItemFrom )

      IF Pos == 0
         MsgOOHGError( "CopyItem: Invalid Origin Item Id. Program terminated." )
      ENDIF
   ELSE
      IF ItemFrom < 1 .OR. ItemFrom > len( ::aTreeMap )
         MsgOOHGError( "CopyItem: Invalid Origin Item Reference. Program terminated." )
      ENDIF

      Pos := ItemFrom
   ENDIF
   FromHandle := ::aTreeMap[ Pos ]

   // store the item and it's subitems into an array
   aItems := {}

   aAdd( aItems, { ItemFrom, ;                                                  // Id or Pos of the origin item
   ::Item( ItemFrom ), ;                                        // value
   ItemTo, ;                                                     // Id or Pos of the parent
   if( ::ItemIds, ItemFrom, ::aTreeIdMap[ ItemFrom ] ), ;       // id of the origin item
   ::ItemImages( ItemFrom ), ;                                  // images
   ::CheckItem( ItemFrom ), ;                                   // checked
   ::ItemReadonly( ItemFrom ), ;                                // readonly
   ::BoldItem( ItemFrom ), ;                                    // bold
   ! ::ItemEnabled( ItemFrom ), ;                               // disabled
   ! ::ItemDraggable( ItemFrom ) } )                            // no drag

   // store it's children
   AddChildren( Self, FromHandle, TreeView_GetChild( ::hWnd, FromHandle ), aItems )

   // if aId has not enough elements to assign to new items, add Nil ones
   // AddItem method will handle missing or duplicated IDs
   IF HB_IsArray( aId )
      aSize( aId, len( aItems ) )
   ELSE
      i := aId

      aId := Array( len( aItems ) )

      aId[ 1 ] := i
   ENDIF

   // insert new items
   FOR i := 1 to len( aItems )
      ItemOld := aItems[ i, 1 ]

      aItems[ i, 1 ] := oTarget:AddItem( aItems[ i, 2 ], aItems[ i, 3 ], aId[ i ], aItems[ i, 5 ], aItems[ i, 6 ], aItems[ i, 7 ], aItems[ i, 8 ], aItems[ i, 9 ], aItems[ i, 10 ], .T. )

      // change parent of children in the rest of the list
      FOR j := i + 1 to len( aItems )
         IF ValType( aItems[ j, 3 ] ) == ValType( ItemOld ) .AND. aItems[ j, 3 ] == ItemOld
            aItems[ j, 3 ] := aItems[ i, 1 ]
         ENDIF
      NEXT j
   NEXT i

   // if To item has item images, change them to node images
   aImages := oTarget:ItemImages( ItemTo )
   IF aImages[ 1 ] == 2 .AND. aImages[ 2 ] == 3
      oTarget:ItemImages( ItemTo, { 0, 1 } )
   ENDIF

   // set focus to new item and return a reference to it

   RETURN oTarget:Value( aItems[ 1, 1 ] )

METHOD MoveItem( ItemFrom, oTarget, ItemTo, aId ) CLASS TTree

   LOCAL Pos, FromHandle, ParentHandle, ToHandle
   LOCAL aItems, i, ItemOld, j, aImages, ItemParent

   // get the From item's handle
   IF ::ItemIds
      Pos := aScan( ::aTreeIdMap, ItemFrom )

      IF Pos == 0
         MsgOOHGError( "MoveItem: Invalid Origin Item Id. Program terminated." )
      ENDIF
   ELSE
      IF ItemFrom < 1 .OR. ItemFrom > len( ::aTreeMap )
         MsgOOHGError( "MoveItem: Invalid Origin Item Reference. Program terminated." )
      ENDIF

      Pos := ItemFrom
   ENDIF
   FromHandle := ::aTreeMap[ Pos ]

   // get the handle of the From item's parent
   ItemParent := ::GetParent( ItemFrom )
   IF ItemParent == Nil
      ParentHandle := 0
   ELSE
      IF ::ItemIds
         Pos := aScan( ::aTreeIdMap, ItemParent )

         IF Pos == 0
            MsgOOHGError( "MoveItem: Invalid Origin Parent Id. Program terminated." )
         ENDIF
      ELSE
         IF ItemParent < 1 .OR. ItemParent > len( ::aTreeMap )
            MsgOOHGError( "MoveItem: Invalid Origin Parent Reference. Program terminated." )
         ENDIF

         Pos := ItemParent
      ENDIF
      ParentHandle := ::aTreeMap[ Pos ]
   ENDIF

   // get the To item's handle
   IF oTarget:ItemIds
      Pos := aScan( oTarget:aTreeIdMap, ItemTo )

      IF Pos == 0
         MsgOOHGError( "MoveItem: Invalid Target Item Id. Program terminated." )
      ENDIF
   ELSE
      IF ItemTo < 1 .OR. ItemTo > len( oTarget:aTreeMap )
         MsgOOHGError( "MoveItem: Invalid Target Item Reference. Program terminated." )
      ENDIF

      Pos := ItemTo
   ENDIF
   ToHandle := oTarget:aTreeMap[ Pos ]

   // store the item and it's subitems into an array
   aItems := {}

   aAdd( aItems, { ItemFrom, ;                                                  // Id or Pos of the origin item
   ::Item( ItemFrom ), ;                                        // value
   Nil, ;                                                       // Id or Pos of the parent
   if( ::ItemIds, ItemFrom, ::aTreeIdMap[ ItemFrom ] ), ;       // id of the new item
   ::ItemImages( ItemFrom ), ;                                  // images
   ::CheckItem( ItemFrom ), ;                                   // checked
   ::ItemReadonly( ItemFrom ), ;                                // readonly
   ::BoldItem( ItemFrom ), ;                                    // bold
   ! ::ItemEnabled( ItemFrom ), ;                               // disabled
   ! ::ItemDraggable( ItemFrom ) } )                            // no drag

   // store it's children
   AddChildren( Self, FromHandle, TreeView_GetChild( ::hWnd, FromHandle ), aItems )

   // delete old items
   // we must delete before inserting new items to avoid duplicated ids
   ::DeleteItem( ItemFrom )

   // search for the To item's handle to get the item's reference
   // because it may have changed after deleting old items (only if target == origin)
   Pos := aScan( oTarget:aTreeMap, ToHandle )
   IF oTarget:ItemIds
      ItemTo := oTarget:aTreeIdMap[ Pos ]
   ELSE
      ItemTo := Pos
   ENDIF

   // put the resulting item's reference as parent of first item in array
   aItems[ 1, 3 ] := ItemTo

   // assign IDs
   // if aId is nil, use origin IDs already loaded in aItems
   // AddItem method will handle missing or duplicated IDs
   IF aId != Nil
      IF HB_IsArray( aId )
         aSize( aId, len( aItems ) )
      ELSE
         i := aId

         aId := Array( len( aItems ) )

         aId[ 1 ] := i
      ENDIF

      FOR i := 1 to len( aItems )
         aItems[ i, 4 ] := aId[ i ]
      NEXT i
   ENDIF

   // insert new items
   FOR i := 1 to len( aItems )
      ItemOld := aItems[ i, 1 ]

      aItems[ i, 1 ] := oTarget:AddItem( aItems[ i, 2 ], aItems[ i, 3 ], aItems[ i, 4 ], aItems[ i, 5 ], aItems[ i, 6 ], aItems[ i, 7 ], aItems[ i, 8 ], aItems[ i, 9 ], aItems[ i, 10 ], .T. )

      // change parent of children in the rest of the list
      FOR j := i + 1 to len( aItems )
         IF ValType( aItems[ j, 3 ] ) == ValType( ItemOld ) .AND. aItems[ j, 3 ] == ItemOld
            aItems[ j, 3 ] := aItems[ i, 1 ]
         ENDIF
      NEXT j
   NEXT i

   // search for the To item's handle to get the item's reference
   // because it may have changed after inserting new items
   Pos := aScan( oTarget:aTreeMap, ToHandle )
   IF oTarget:ItemIds
      ItemTo := oTarget:aTreeIdMap[ Pos ]
   ELSE
      ItemTo := Pos
   ENDIF

   // if To item has item images, change them to node images
   aImages := oTarget:ItemImages( ItemTo )
   IF aImages[ 1 ] == 2 .AND. aImages[ 2 ] == 3
      oTarget:ItemImages( ItemTo, { 0, 1 } )
   ENDIF

   // if parent of From item has node images but has no children left
   // change images to item images except if it's root item
   IF ParentHandle != 0
      Pos := aScan( ::aTreeMap, ParentHandle )
      IF ::ItemIds
         ItemTo := ::aTreeIdMap[ Pos ]
      ELSE
         ItemTo := Pos
      ENDIF

      aImages := ::ItemImages( ItemTo )
      IF aImages[ 1 ] == 0 .AND. aImages[ 2 ] == 1
         IF len(::GetChildren( ItemTo ) ) == 0
            IF ::GetParent( ItemTo ) != Nil
               ::ItemImages( ItemTo, { 2, 3 } )
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   // set focus to new item and return reference to it

   RETURN oTarget:Value( aItems[ 1, 1 ] )

STATIC FUNCTION AddChildren( Self, ParentHandle, ChildHandle, aItems )

   LOCAL ParentPos, ParentItem, NextChild, NextPos, NextItem

   IF ChildHandle != 0
      ParentPos := aScan( ::aTreeMap, ParentHandle )
      IF ParentPos == 0
         MsgOOHGError( "AddChildren Function: Invalid Parent Item. Program terminated." )
      ENDIF
      ParentItem := if( Self:ItemIds, Self:aTreeIdMap[ ParentPos ], ParentPos )

      NextChild := ChildHandle

      DO WHILE NextChild != 0
         NextPos := aScan( ::aTreeMap, NextChild )
         IF NextPos == 0
            MsgOOHGError( "AddChildren Function: Invalid Child Item. Program terminated." )
         ENDIF
         NextItem := if( Self:ItemIds, Self:aTreeIdMap[ NextPos ], NextPos )

         aAdd( aItems, { NextItem, ;
            Self:Item( NextItem ), ;
            ParentItem, ;
            if( Self:ItemIds, NextItem, Self:aTreeIdMap[ NextItem ] ), ;
            Self:ItemImages( NextItem ), ;
            Self:CheckItem( NextItem ), ;
            Self:ItemReadonly( NextItem ), ;
            Self:BoldItem( NextItem ), ;
            ! Self:ItemEnabled( NextItem ), ;                               // disabled
         ! Self:ItemDraggable( NextItem ) } )                            // no drag

         // add sub-children
         AddChildren( Self, NextChild, TreeView_GetChild( Self:hWnd, NextChild ), aItems )

         // next sibling
         NextChild := TreeView_GetNextSibling( Self:hWnd, NextChild )
      ENDDO
   ENDIF

   RETURN NIL

METHOD EditLabel() CLASS TTree

   ::SetFocus()

   TreeView_EditLabel( ::hWnd, TreeView_GetSelection( ::hWnd ) )

   RETURN NIL

METHOD SelColor( aColor ) CLASS TTree

   IF aColor != Nil
      ::aSelColor := aColor
      ::Redraw()
   ENDIF

   RETURN ::aSelColor

METHOD CheckItem( Item, lChecked ) CLASS TTree

   LOCAL ItemHandle, Pos

   IF HB_IsLogical( lChecked )
      //  set
      IF ::ItemIds
         Pos := aScan( ::aTreeIdMap, Item )

         IF Pos == 0
            MsgOOHGError( "CheckItem: Invalid Item Id. Program terminated." )
         ENDIF

         ItemHandle := ::aTreeMap[ Pos ]
      ELSE
         IF Item < 1 .OR. Item > len( ::aTreeMap )
            MsgOOHGError( "CheckItem: Invalid Item Reference. Program terminated." )
         ENDIF

         ItemHandle := ::aTreeMap[ Item ]
      ENDIF

      TreeView_SetCheckState( ::hWnd, ItemHandle, lChecked )
   ELSE
      // get
      IF ::ItemIds
         Pos := aScan( ::aTreeIdMap, Item )

         IF Pos == 0
            MsgOOHGError( "CheckItem: Invalid Item Id. Program terminated." )
         ENDIF

         ItemHandle := ::aTreeMap[ Pos ]
      ELSE
         IF Item < 1 .OR. Item > len( ::aTreeMap )
            MsgOOHGError( "CheckItem: Invalid Item Reference. Program terminated." )
         ENDIF

         ItemHandle := ::aTreeMap[ Item ]
      ENDIF
   ENDIF

   RETURN TreeView_GetCheckState( ::hWnd, ItemHandle ) == 1

METHOD BoldItem( Item, lBold ) CLASS TTree

   LOCAL ItemHandle, Pos

   IF HB_IsLogical( lBold )
      //  set
      IF ::ItemIds
         Pos := aScan( ::aTreeIdMap, Item )

         IF Pos == 0
            MsgOOHGError( "BoldItem: Invalid Item Id. Program terminated." )
         ENDIF

         ItemHandle := ::aTreeMap[ Pos ]
      ELSE
         IF Item < 1 .OR. Item > len( ::aTreeMap )
            MsgOOHGError( "BoldItem: Invalid Item Reference. Program terminated." )
         ENDIF

         ItemHandle := ::aTreeMap[ Item ]
      ENDIF

      TreeView_SetBoldState( ::hWnd, ItemHandle, lBold )
   ELSE
      // get
      IF ::ItemIds
         Pos := aScan( ::aTreeIdMap, Item )

         IF Pos == 0
            MsgOOHGError( "BoldItem: Invalid Item Id. Program terminated." )
         ENDIF

         ItemHandle := ::aTreeMap[ Pos ]
      ELSE
         IF Item < 1 .OR. Item > len( ::aTreeMap )
            MsgOOHGError( "BoldItem: Invalid Item Reference. Program terminated." )
         ENDIF

         ItemHandle := ::aTreeMap[ Item ]
      ENDIF
   ENDIF

   RETURN TreeView_GetBoldState( ::hWnd, ItemHandle )

METHOD ItemReadonly( Item, lReadOnly ) CLASS TTree

   LOCAL Pos

   IF HB_IsLogical( lReadOnly )
      // set
      IF ::ItemIds
         Pos := aScan( ::aTreeIdMap, Item )

         IF Pos == 0
            MsgOOHGError( "ItemReadonly: Invalid Item Id. Program terminated." )
         ENDIF
      ELSE
         IF Item < 1 .OR. Item > len( ::aTreeMap )
            MsgOOHGError( "ItemReadonly: Invalid Item Reference. Program terminated." )
         ENDIF

         Pos := Item
      ENDIF

      ::aTreeRO[ Pos ] := lReadOnly
   ELSE
      // get
      IF ::ItemIds
         Pos := aScan( ::aTreeIdMap, Item )

         IF Pos == 0
            MsgOOHGError( "ItemReadonly: Invalid Item Id. Program terminated." )
         ENDIF
      ELSE
         IF Item < 1 .OR. Item > len( ::aTreeMap )
            MsgOOHGError( "ItemReadonly: Invalid Item Reference. Program terminated." )
         ENDIF

         Pos := Item
      ENDIF
   ENDIF

   RETURN ::aTreeRO[ Pos ]

METHOD ItemEnabled( Item, lEnabled ) CLASS TTree

   LOCAL Pos

   IF HB_IsLogical( lEnabled )
      // set
      IF ::ItemIds
         Pos := aScan( ::aTreeIdMap, Item )

         IF Pos == 0
            MsgOOHGError( "ItemEnabled: Invalid Item Id. Program terminated." )
         ENDIF
      ELSE
         IF Item < 1 .OR. Item > len( ::aTreeMap )
            MsgOOHGError( "ItemEnabled: Invalid Item Reference. Program terminated." )
         ENDIF

         Pos := Item
      ENDIF

      ::aTreeEnabled[ Pos ] := lEnabled
   ELSE
      // get
      IF ::ItemIds
         Pos := aScan( ::aTreeIdMap, Item )

         IF Pos == 0
            MsgOOHGError( "ItemEnabled: Invalid Item Id. Program terminated." )
         ENDIF
      ELSE
         IF Item < 1 .OR. Item > len( ::aTreeMap )
            MsgOOHGError( "ItemEnabled: Invalid Item Reference. Program terminated." )
         ENDIF

         Pos := Item
      ENDIF
   ENDIF

   RETURN ::aTreeEnabled[ Pos ]

METHOD ItemDraggable( Item, lDraggable ) CLASS TTree

   LOCAL Pos

   IF HB_IsLogical( lDraggable )
      // set
      IF ::ItemIds
         Pos := aScan( ::aTreeIdMap, Item )

         IF Pos == 0
            MsgOOHGError( "ItemDraggable: Invalid Item Id. Program terminated." )
         ENDIF
      ELSE
         IF Item < 1 .OR. Item > len( ::aTreeMap )
            MsgOOHGError( "ItemDraggable: Invalid Item Reference. Program terminated." )
         ENDIF

         Pos := Item
      ENDIF

      ::aTreeNoDrag[ Pos ] := ! lDraggable
   ELSE
      // get
      IF ::ItemIds
         Pos := aScan( ::aTreeIdMap, Item )

         IF Pos == 0
            MsgOOHGError( "ItemDraggable: Invalid Item Id. Program terminated." )
         ENDIF
      ELSE
         IF Item < 1 .OR. Item > len( ::aTreeMap )
            MsgOOHGError( "ItemDraggable: Invalid Item Reference. Program terminated." )
         ENDIF

         Pos := Item
      ENDIF
   ENDIF

   RETURN ! ::aTreeNoDrag[ Pos ]

METHOD GetParent( Item ) CLASS TTree

   LOCAL Pos, ItemHandle, ParentHandle, ParentItem

   IF ::ItemIds
      Pos := aScan( ::aTreeIdMap, Item )

      IF Pos == 0
         MsgOOHGError( "GetParent: Invalid Item Id. Program terminated." )
      ENDIF
   ELSE
      IF Item < 1 .OR. Item > len( ::aTreeMap )
         MsgOOHGError( "GetParent: Invalid Item Reference. Program terminated." )
      ENDIF

      Pos := Item
   ENDIF

   ItemHandle := ::aTreeMap[ Pos ]
   ParentHandle := TreeView_GetParent( ::hWnd, ItemHandle )

   IF ParentHandle == 0
      ParentItem := Nil
   ELSEIF ::ItemIds
      ParentItem := ::aTreeIdMap[ aScan( ::aTreeMap, ParentHandle ) ]
   ELSE
      ParentItem := aScan( ::aTreeMap, ParentHandle )
   ENDIF

   RETURN ParentItem

METHOD GetChildren( Item ) CLASS TTree

   LOCAL Pos, ItemHandle, ChildHandle, ChildItem, ChildrenItems

   IF ::ItemIds
      Pos := aScan( ::aTreeIdMap, Item )

      IF Pos == 0
         MsgOOHGError( "GetChildren: Invalid Item Id. Program terminated." )
      ENDIF
   ELSE
      IF Item < 1 .OR. Item > len( ::aTreeMap )
         MsgOOHGError( "GetChildren: Invalid Item Reference. Program terminated." )
      ENDIF

      Pos := Item
   ENDIF

   ItemHandle := ::aTreeMap[ Pos ]

   ChildrenItems := {}

   ChildHandle := TreeView_GetChild( ::hWnd, ItemHandle )

   DO WHILE ChildHandle != 0
      IF ::ItemIds
         ChildItem := ::aTreeIdMap[ aScan( ::aTreeMap, ChildHandle ) ]
      ELSE
         ChildItem := aScan( ::aTreeMap, ChildHandle )
      ENDIF

      aAdd( ChildrenItems, ChildItem )

      ChildHandle := TreeView_GetNextSibling( ::hWnd, ChildHandle )
   ENDDO

   RETURN ChildrenItems

METHOD LookForKey( nKey, nFlags ) CLASS TTree

   IF nKey == VK_ESCAPE .and. nFlags == 0
      IF ::hWndEditCtrl != Nil

         RETURN NIL

      ELSEIF ::DragActive
         // this call fires WM_CAPTURECHANGED
         ReleaseCapture()

         RETURN NIL
      ENDIF
   ENDIF

   RETURN ::Super:LookForKey( nKey, nFlags )

METHOD IsItemCollapsed( Item ) CLASS TTree

   LOCAL ItemHandle, Pos

   IF ::ItemIds
      Pos := aScan( ::aTreeIdMap, Item )

      IF Pos == 0
         MsgOOHGError( "IsItemCollapsed: Invalid Item Id. Program terminated." )
      ENDIF
   ELSE
      IF Item < 1 .OR. Item > len( ::aTreeMap )
         MsgOOHGError( "IsItemCollapsed: Invalid Item Reference. Program terminated." )
      ENDIF

      Pos := Item
   ENDIF

   ItemHandle := ::aTreeMap[ Pos ]

   RETURN TreeView_IsItemCollapsed( ::hWnd, ItemHandle )

METHOD IsItemValid( Item ) CLASS TTree

   LOCAL lRet

   IF ::ItemIds
      lRet := aScan( ::aTreeIdMap, Item ) # 0
   ELSE
      lRet := HB_IsNumeric( Item ) .AND. Item == INT( Item ) .AND. Item >= 1 .AND. Item <= len( ::aTreeMap )
   ENDIF

   RETURN lRet

METHOD HandleToItem( Handle) CLASS TTree

   LOCAL Pos

   Pos := aScan( ::aTreeMap, Handle )

   IF Pos == 0
      MsgOOHGError( "HandleToItem: Invalid Item Handle. Program terminated." )
   ENDIF

   IF ::ItemIds
      Pos := ::aTreeIdMap[ Pos ]
   ENDIF

   RETURN Pos

METHOD ItemToHandle( Item ) CLASS TTree

   LOCAL Pos

   IF ::ItemIds
      Pos := aScan( ::aTreeIdMap, Item )

      IF Pos == 0
         MsgOOHGError( "ItemToHandle: Invalid Id Reference. Program terminated." )
      ENDIF
   ELSE
      IF Item < 1 .OR. Item > len( ::aTreeMap )
         MsgOOHGError( "ItemToHandle: Invalid Item Reference. Program terminated." )
      ENDIF

      Pos := Item
   ENDIF

   RETURN ::aTreeMap[ Pos ]

METHOD ItemVisible( Item ) CLASS TTree

   // does not select item just shows it in the tree's window

   RETURN TreeView_EnsureVisible( ::hWnd, ::ItemToHandle( Item ) )

METHOD IsItemExpanded( Item ) CLASS TTree

   // .T. when has children and the list is expanded

   RETURN TreeView_GetExpandedState( ::hWnd, ::ItemToHandle( Item ) )

METHOD IsItemVisible( Item, lWhole ) CLASS TTree

   ASSIGN lWhole VALUE lWhole TYPE "L" DEFAULT .F.
   // FALSE and item partially shown => item is visible
   // TRUE and item partially shown => item is NOT visible

   RETURN TREEVIEW_ISITEMVISIBLE( ::hWnd, ::ItemToHandle( Item ), lWhole )

METHOD FirstVisible() CLASS TTree

   LOCAL Handle, Item

   // first item shown in the control's window
   Handle := TreeView_GetFirstVisible( ::hWnd )

   IF ValidHandler( Handle )
      Item := ::HandleToItem( Handle )
   ELSEIF ::ItemIds
      Item := Nil
   ELSE
      Item := 0
   ENDIF

   RETURN Item

METHOD PrevVisible( Item ) CLASS TTree

   LOCAL Handle, Prev

   // previous item that could be shown
   // it may be outside the control's windows
   // but it will be shown if the control is scrolled down
   // To know if the item is actually shown use
   // IsItemVisible method
   Handle := TreeView_GetPrevVisible( ::hWnd, ::ItemToHandle( Item ) )

   IF ValidHandler( Handle )
      Prev := ::HandleToItem( Handle )
   ELSEIF ::ItemIds
      Prev := Nil
   ELSE
      Prev := 0
   ENDIF

   RETURN Prev

METHOD NextVisible( Item ) CLASS TTree

   LOCAL Handle, Next

   // next item that could be shown
   // it may be outside the control's windows
   // but it will be shown if the control is scrolled up
   // To know if the item is actually shown use
   // IsItemVisible method
   Handle := TreeView_GetNextVisible( ::hWnd, ::ItemToHandle( Item ) )

   IF ValidHandler( Handle )
   NEXT := ::HandleToItem( Handle )
ELSEIF ::ItemIds
NEXT := Nil
ELSE
NEXT := 0
ENDIF

RETURN Next

METHOD LastVisible( ) CLASS TTree

   LOCAL Handle, Item

   // last item that could be shown
   // it may be outside the control's windows
   // but it will be shown if the control is scrolled down
   // To know if the item is actually shown use
   // IsItemVisible method
   Handle := TreeView_GetLastVisible( ::hWnd )

   IF ValidHandler( Handle )
      Item := ::HandleToItem( Handle )
   ELSEIF ::ItemIds
      Item := Nil
   ELSE
      Item := 0
   ENDIF

   RETURN Item

METHOD VisibleCount() CLASS TTree

   // number of items that can be fully visible in the control's window

   RETURN TreeView_GetVisibleCount( ::hWnd )

METHOD ItemHeight( nHeight ) CLASS TTree

   /* New height of every item in the tree view, in pixels.
   * Heights less than 1 will be set to 1.
   * If this argument is not even, it will be rounded down to the nearest even value.
   * If this argument is -1, the control will revert to using its default item height.
   */

   IF HB_IsNumeric( nHeight ) .and. nHeight # 0
      TreeView_SetItemHeight( ::hWnd, nHeight )
   ENDIF

   RETURN TreeView_GetItemHeight( ::hWnd )

METHOD Release() CLASS TTree

   LOCAL StateImageList := TreeView_GetImageList( ::hWnd, TVSIL_STATE )

   IF ::DragActive
      // this call fires WM_CAPTURECHANGED
      ReleaseCapture()
   ENDIF

   ::OnLabelEdit := Nil
   ::OnCheckChange := Nil

   IF ValidHandler( StateImageList )
      ImageList_Destroy( StateImageList )
   ENDIF

   RETURN ::Super:Release()

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

   iStyle = hb_parni( 6 ) | WS_CHILD | TVS_NOTOOLTIPS ;

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

HB_FUNC( TREEVIEW_GETITEMTEXT )
{
   TV_ITEM TreeItem;
   char ItemText [ 256 ];

   memset( &TreeItem, 0, sizeof( TV_ITEM ) );

   TreeItem.mask = TVIF_HANDLE | TVIF_TEXT;
   TreeItem.hItem = HTREEparam( 2 );
   TreeItem.pszText = ItemText;
   TreeItem.cchTextMax = 256 ;

   TreeView_GetItem( HWNDparam( 1 ), &TreeItem );

   hb_retc( ItemText );
}

HB_FUNC( TREEVIEW_SETITEMTEXT )
{
   TV_ITEM TreeItem;
   char ItemText [ 256 ];

   memset( &TreeItem, 0, sizeof( TV_ITEM ) );

   strcpy( ItemText, hb_parc( 3 ) );

   TreeItem.mask = TVIF_HANDLE | TVIF_TEXT;
   TreeItem.hItem = HTREEparam( 2 );
   TreeItem.pszText = ItemText;
   TreeItem.cchTextMax = 256;

   TreeView_SetItem( HWNDparam( 1 ), &TreeItem );
}

HB_FUNC( TREEVIEW_SETIMAGES )
{
   TV_ITEM TreeItem;

   memset( &TreeItem, 0, sizeof( TV_ITEM ) );

   TreeItem.mask = TVIF_HANDLE | TVIF_IMAGE | TVIF_SELECTEDIMAGE;
   TreeItem.hItem = HTREEparam( 2 );
   TreeItem.iImage = hb_parni( 3 );
   TreeItem.iSelectedImage = hb_parni( 4 );

   TreeView_SetItem( HWNDparam( 1 ), &TreeItem );
}

HB_FUNC( TREEVIEW_GETIMAGES )
{
   TV_ITEM TreeItem;

   memset( &TreeItem, 0, sizeof( TV_ITEM ) );

   TreeItem.mask = TVIF_HANDLE | TVIF_IMAGE | TVIF_SELECTEDIMAGE;
   TreeItem.hItem = HTREEparam( 2 );

   TreeView_GetItem( HWNDparam( 1 ), &TreeItem );

   hb_reta( 2 );
   HB_STORNI( TreeItem.iImage, -1, 1 );
   HB_STORNI( TreeItem.iSelectedImage, -1, 2 );
}

HB_FUNC( TREEVIEW_GETSELECTIONID )
{
   HWND TreeHandle ;
   HTREEITEM ItemHandle;
   TV_ITEM TreeItem ;

   TreeHandle = HWNDparam( 1 );
   ItemHandle = TreeView_GetSelection( TreeHandle );

   if( ! ItemHandle )
   {
      hb_retnl( 0 );
   }

   memset( &TreeItem, 0, sizeof( TV_ITEM ) );

   TreeItem.mask = TVIF_HANDLE | TVIF_PARAM;
   TreeItem.hItem  = ItemHandle;

   TreeView_GetItem( TreeHandle, &TreeItem );

   hb_retnl( TreeItem.lParam );
}

HB_FUNC( TREEVIEW_SETSELECTIONID )
{
   HWND TreeHandle ;
   HTREEITEM ItemHandle;
   TV_ITEM TreeItem ;

   TreeHandle = HWNDparam( 1 );
   ItemHandle = TreeView_GetSelection( TreeHandle );

   if( ! ItemHandle )
   {
      hb_retnl( 0 );
   }

   memset( &TreeItem, 0, sizeof( TV_ITEM ) );

   TreeItem.mask = TVIF_HANDLE | TVIF_PARAM;
   TreeItem.hItem  = ItemHandle;
   TreeItem.lParam = hb_parni( 2 );

   TreeView_SetItem( TreeHandle, &TreeItem );
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
static HWND hwndTreeView = NULL;                      // TODO: Thread safe ?

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

int Treeview_Notify_CustomDraw( PHB_ITEM pSelf, LPARAM lParam, BOOL lOnDrag )
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
      /* see if drag is activated */
      if( lOnDrag )
      {
         /* lptvcd->nmcd.dwItemSpec it's the handle of the item to draw */
         if( (HTREEITEM) lptvcd->nmcd.dwItemSpec == TreeView_GetDropHilight( oSelf->hWnd ) )
         {
            /* get selected item's color */
            _OOHG_Send( pSelf, s_aSelColor );
            hb_vmSend( 0 );

            lptvcd->clrText = ( ( oSelf->lFontColor == -1 ) ? GetSysColor( COLOR_WINDOW ) : (COLORREF) oSelf->lFontColor );

            if( _OOHG_DetermineColor( hb_param( -1, HB_IT_ANY ), &lSelColor ) )
            {
               lptvcd->clrTextBk = (COLORREF) lSelColor;
            }
            else
            {
               lptvcd->clrTextBk = ( ( oSelf->lFontColor == -1 ) ? GetSysColor( COLOR_WINDOWTEXT ) : (COLORREF) oSelf->lFontColor );
            }
         }
         else
         {
            lptvcd->clrText = ( ( oSelf->lFontColor == -1 ) ? GetSysColor( COLOR_WINDOWTEXT ) : (COLORREF) oSelf->lFontColor );
            lptvcd->clrTextBk = ( ( oSelf->lBackColor == -1 ) ? GetSysColor( COLOR_WINDOW ) : (COLORREF) oSelf->lBackColor ) ;
         }
      }
      else if( lptvcd->nmcd.uItemState & CDIS_SELECTED )
      {
         /* get selected item's color */
         _OOHG_Send( pSelf, s_aSelColor );
         hb_vmSend( 0 );

         lptvcd->clrText = ( ( oSelf->lFontColor == -1 ) ? GetSysColor( COLOR_WINDOW ) : (COLORREF) oSelf->lFontColor );

         if( _OOHG_DetermineColor( hb_param( -1, HB_IT_ANY ), &lSelColor ) )
         {
            lptvcd->clrTextBk = (COLORREF) lSelColor;
         }
         else
         {
            lptvcd->clrTextBk = ( ( oSelf->lFontColor == -1 ) ? GetSysColor( COLOR_WINDOWTEXT ) : (COLORREF) oSelf->lFontColor );
         }
      }
      else
      {
         lptvcd->clrText = ( ( oSelf->lFontColor == -1 ) ? GetSysColor( COLOR_WINDOWTEXT ) : (COLORREF) oSelf->lFontColor );
         lptvcd->clrTextBk = ( ( oSelf->lBackColor == -1 ) ? GetSysColor( COLOR_WINDOW ) : (COLORREF) oSelf->lBackColor ) ;
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
   hb_retni( Treeview_Notify_CustomDraw( hb_param( 1, HB_IT_OBJECT ), (LPARAM) hb_parnl( 2 ), hb_parl( 3 ) ) );
}

HB_FUNC( TREEVIEW_GETITEMHIT )
{
   LPNMHDR lpnmh = (LPNMHDR) (LPARAM) hb_parnl( 1 );
   TVHITTESTINFO ht;

   DWORD dwpos = GetMessagePos();

   ht.pt.x = GET_X_LPARAM( dwpos );
   ht.pt.y = GET_Y_LPARAM( dwpos );

   MapWindowPoints( HWND_DESKTOP, lpnmh->hwndFrom, &ht.pt, 1 );

   (void) TreeView_HitTest( lpnmh->hwndFrom, &ht );

   HTREEret( ht.hItem );
}

HB_FUNC( TREEVIEW_HITISONSTATEICON )
{
   LPNMHDR lpnmh = (LPNMHDR) (LPARAM) hb_parnl( 1 );
   TVHITTESTINFO ht;
   BOOL bRet;

   DWORD dwpos = GetMessagePos();

   ht.pt.x = GET_X_LPARAM( dwpos );
   ht.pt.y = GET_Y_LPARAM( dwpos );

   MapWindowPoints( HWND_DESKTOP, lpnmh->hwndFrom, &ht.pt, 1 );

   (void) TreeView_HitTest( lpnmh->hwndFrom, &ht );

   if( ht.hItem )
   {
      bRet = ( TVHT_ONITEMSTATEICON & ht.flags );
   }
   else
   {
      bRet = FALSE;
   }

   hb_retl( bRet );
}

HB_FUNC( GETITEMHWND )
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

   /* return values: -1 = no checkbox image, 0 = unchecked, 1 = checked */
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

HB_FUNC( TREEVIEW_GETBOLDSTATE )
{
   HTREEITEM TreeItemHandle;
   TV_ITEM   TreeItem;

   memset( &TreeItem, 0, sizeof( TV_ITEM ) );

   TreeItemHandle = HTREEparam( 2 );

   TreeItem.mask = TVIF_HANDLE | TVIF_STATE;
   TreeItem.hItem = TreeItemHandle;
   TreeItem.stateMask = TVIS_BOLD;

   TreeView_GetItem( HWNDparam( 1 ), &TreeItem );

   hb_retl( ( TreeItem.state & TVIS_BOLD ) == TVIS_BOLD );
}

HB_FUNC( TREEVIEW_SETBOLDSTATE )
{
   HTREEITEM TreeItemHandle;
   TV_ITEM   TreeItem;

   memset( &TreeItem, 0, sizeof( TV_ITEM ) );

   TreeItemHandle = HTREEparam( 2 );

   TreeItem.mask = TVIF_HANDLE | TVIF_STATE;
   TreeItem.hItem = TreeItemHandle;
   TreeItem.stateMask = TVIS_BOLD;

   if( hb_parl( 3 ) )
   {
      TreeItem.state |= TVIS_BOLD;
   }
   else
   {
      TreeItem.state &= ~TVIS_BOLD;
   }

   TreeView_SetItem( HWNDparam( 1 ), &TreeItem );
}

HB_FUNC( TREEVIEW_GETEXPANDEDSTATE )
{
   HTREEITEM TreeItemHandle;
   TV_ITEM   TreeItem;

   memset( &TreeItem, 0, sizeof( TV_ITEM ) );

   TreeItemHandle = HTREEparam( 2 );

   TreeItem.mask = TVIF_HANDLE | TVIF_STATE;
   TreeItem.hItem = TreeItemHandle;
   TreeItem.stateMask = TVIS_EXPANDED;

   TreeView_GetItem( HWNDparam( 1 ), &TreeItem );

   hb_retl( ( TreeItem.state & TVIS_EXPANDED ) == TVIS_EXPANDED );
}

HB_FUNC( TREEVIEW_PREVIOUSSELECTEDITEM )
{
   LPNMTREEVIEW lpnmtv = (LPNMTREEVIEW) (LPARAM) hb_parnl( 1 );

   HTREEret( lpnmtv->itemOld.hItem );
}

HB_FUNC( TREEVIEW_ACTUALSELECTEDITEM )
{
   LPNMTREEVIEW lpnmtv = (LPNMTREEVIEW) (LPARAM) hb_parnl( 1 );

   HTREEret( lpnmtv->itemNew.hItem );
}

HB_FUNC( TREEVIEW_BEGINDRAG )
{
   HWND hTree = HWNDparam( 1 );
   LPNMTREEVIEW lpnmtv = (LPNMTREEVIEW) (LPARAM) hb_parnl( 2 );
   HIMAGELIST himl;
   HFONT oldFont, newFont;
   UINT iIndent;
   POINT pnt;

   /* needed in some XP systems to show text in the drag image */
   iIndent = TreeView_GetIndent( hTree );
   oldFont = (HFONT) SendMessage( hTree, (UINT) WM_GETFONT, (WPARAM) 0, (LPARAM )0 );
   newFont = (HFONT) PrepareFont( "MS Sans Serif", 10, FW_NORMAL, 0, 0, 0, 0, 0 );
   SendMessage( hTree, (UINT) WM_SETFONT, (WPARAM) newFont, (LPARAM) 1 );

   /* tell the treeview control to create an image to use for dragging */
   himl = TreeView_CreateDragImage( hTree, lpnmtv->itemNew.hItem );

   /* restore font and indentation */
   SendMessage( hTree, (UINT) WM_SETFONT, (WPARAM) oldFont, 1 );
   TreeView_SetIndent( hTree, iIndent );
   DeleteObject( newFont );

   if( himl )
   {
      /* get the mouse position in tree client coordinates */
      pnt.x = lpnmtv->ptDrag.x;
      pnt.y = lpnmtv->ptDrag.y;

      /* convert to Desktop client coordinates */
      ClientToScreen( hTree, &pnt);

      /* start the drag operation on Desktop */
      ImageList_BeginDrag( himl, 0, 0, 0 );
      ImageList_DragEnter( NULL, pnt.x, pnt.y );

      /* direct mouse input to the treeview window */
      SetCapture( hTree );
   }

   hb_retnl( (LONG) himl );
}

BOOL IsTargetChild( HWND hTree, HTREEITEM hOrigin, HTREEITEM hDestination )
{
   HTREEITEM hitemChild = hDestination;

   while( hitemChild )
   {
      hitemChild = TreeView_GetParent( hTree, hitemChild );
      if( ( hitemChild == hOrigin ) )
      {

         return TRUE;
      }
   }

   return FALSE;
}

HB_FUNC( TREEVIEW_ONMOUSEDRAG )
{
   POINT pnt;
   TVHITTESTINFO tvht;
   HWND hTreeOrigin, hTreeTarget;
   PHB_ITEM pSelf;
   HTREEITEM htiOrigin, htiTarget;

   hTreeOrigin = HWNDparam( 1 );
   htiOrigin   = HTREEparam( 2 );
   hTreeTarget = HWNDparam( 3 );

   /* get the current position of the mouse pointer in screen coordinates and drag the image there */
   GetCursorPos( &pnt );
   ImageList_DragMove( pnt.x, pnt.y );

   /* if destination tree accepts drop */
   if( hTreeTarget )
   {
      /* map to the treeview and see if we are on an item */
      ScreenToClient( hTreeTarget, &pnt );
      tvht.pt.x = pnt.x ;
      tvht.pt.y = pnt.y ;
      htiTarget = TreeView_HitTest( hTreeTarget, &tvht );

      if( htiTarget )
      {
         /* set the cursor according to the item under it */
         if( hTreeOrigin == hTreeTarget && htiTarget == htiOrigin )
         {
            /* an item can't be dropped onto itself */
            SetCursor( LoadCursor( GetModuleHandle(NULL), "DRAG_NO" ) );
         }
         else if( hTreeOrigin == hTreeTarget && IsTargetChild( hTreeOrigin, htiOrigin, htiTarget ) )
         {
            /* an item can't be dropped onto one of its children */
            SetCursor( LoadCursor( GetModuleHandle(NULL), "DRAG_NO" ) );
         }
         else
         {
            /* check if target item is enabled
             * ::ItemEnabled( ::HandleToItem( TreeItemHandle ) )
             */
            pSelf = GetControlObjectByHandle( hTreeTarget );

            _OOHG_Send( pSelf, s_HandleToItem );
            HWNDpush( htiTarget );
            hb_vmSend( 1 );

            _OOHG_Send( pSelf, s_ItemEnabled );
            hb_vmPush( hb_param( -1, HB_IT_ANY ) );
            hb_vmSend( 1 );

            if( hb_parl( -1 ) )
            {
               SetDragCursorARROW( ( ( (WPARAM) hb_parnl( 4 ) & MK_CONTROL) == MK_CONTROL ) );
            }
            else
            {
               SetCursor( LoadCursor( GetModuleHandle(NULL), "DRAG_NO" ) );
            }
         }
      }
      else
      {
         SetCursor( LoadCursor( GetModuleHandle(NULL), "DRAG_NO" ) );
      }

      /* hide the dragged image so the background can be refreshed */
      ImageList_DragShowNolock( FALSE );

      /* if there's an item under the cursor, highlight it, otherwise none will be highlight */
      TreeView_SelectDropTarget( hTreeTarget, htiTarget );

      /* show the drag image */
      ImageList_DragShowNolock( TRUE );
   }
   else
   {
      SetCursor( LoadCursor( GetModuleHandle(NULL), "DRAG_NO" ) );
   }
}

HB_FUNC( GETWINDOWUNDERCURSOR )
{
   POINT pnt;

   GetCursorPos( &pnt );

   HWNDret( WindowFromPoint( pnt ) );
}

HB_FUNC( TREEVIEW_AUTOSCROLL )
{
   POINT pnt;
   HTREEITEM htiTarget, htiToShow;
   TVHITTESTINFO tvht;
   int ScrollRegion;
   RECT rc;
   PHB_ITEM pSelf;
   HWND hTreeTarget = HWNDparam( 1 );
   HWND hTreeOrigin = HWNDparam( 2 );
   HTREEITEM htiOrigin = HTREEparam( 3 );

   /* get the current position of the mouse pointer in screen coordinates and see if it's on an item */
   GetCursorPos( &pnt );
   ScreenToClient( hTreeTarget, &pnt );
   tvht.pt.x = pnt.x ;
   tvht.pt.y = pnt.y ;
   htiTarget = TreeView_HitTest( hTreeTarget, &tvht );

   if( ! htiTarget )
   {

      return;
   }

   /* see if we need to scroll up or down */
   ScrollRegion = TreeView_GetItemHeight( hTreeTarget ) * 2;
   GetClientRect( hTreeTarget, (LPRECT) &rc );

   if( pnt.y >= 0 && pnt.y <= ScrollRegion )
   {
      /* show the preceding visible item */
      htiToShow = TreeView_GetPrevVisible( hTreeTarget, htiTarget );
      if( htiToShow )
      {
         ImageList_DragShowNolock( FALSE );
         TreeView_EnsureVisible( hTreeTarget, htiToShow );
         ImageList_DragShowNolock( TRUE );
      }
   }
   else if( pnt.y > rc.bottom - ScrollRegion )
   {
      /* show the next visible item */
      htiToShow = TreeView_GetNextVisible( hTreeTarget, htiTarget );
      if( htiToShow )
      {
         ImageList_DragShowNolock( FALSE );
         TreeView_EnsureVisible( hTreeTarget, htiToShow );
         ImageList_DragShowNolock( TRUE );
      }
   }

   /* set the cursor according to the item under it */
   if( hTreeTarget == hTreeOrigin && htiTarget == htiOrigin )
   {
      /* an item can't be dropped onto itself */
      SetCursor( LoadCursor( GetModuleHandle(NULL), "DRAG_NO" ) );
   }
   else if( hTreeTarget == hTreeOrigin && IsTargetChild( hTreeTarget, htiOrigin, htiTarget ) )
   {
      /* an item can't be dropped onto one of its children */
      SetCursor( LoadCursor( GetModuleHandle(NULL), "DRAG_NO" ) );
   }
   else
   {
      /* check if target item is enabled
       * ::ItemEnabled( ::HandleToItem( TreeItemHandle ) )
       */
      pSelf = GetControlObjectByHandle( hTreeTarget );

      _OOHG_Send( pSelf, s_HandleToItem );
      HWNDpush( htiTarget );
      hb_vmSend( 1 );

      _OOHG_Send( pSelf, s_ItemEnabled );
      hb_vmPush( hb_param( -1, HB_IT_ANY ) );
      hb_vmSend( 1 );

      if( hb_parl( -1 ) )
      {
         SetDragCursorARROW( GetKeyState( VK_CONTROL ) < 0 );

      }
      else
      {
         SetCursor( LoadCursor( GetModuleHandle(NULL), "DRAG_NO" ) );
      }
   }

   /* hide the dragged image so the background can be refreshed */
   ImageList_DragShowNolock( FALSE );

   /* if there's an item under the cursor, highlight it, otherwise none will be highlight */
   TreeView_SelectDropTarget( hTreeTarget, htiTarget );

   /* show the drag image */
   ImageList_DragShowNolock( TRUE );
}

BOOL TreeView_IsItemCollapsed( HWND hTree, HTREEITEM hItem )
{
   TV_ITEM tvi;
   BOOL bRet = FALSE;

   memset( &tvi, 0, sizeof( TV_ITEM ) );

   tvi.hItem = hItem;
   tvi.mask = TVIF_STATE | TVIF_CHILDREN;

   if( TreeView_GetItem( hTree, &tvi ) )
   {
      bRet = ( ! ( tvi.state & TVIS_EXPANDED ) ) && ( tvi.cChildren != 0 );
   }

   return bRet;
}

HB_FUNC( TREEVIEW_ISITEMCOLLAPSED )
{
   hb_retl( TreeView_IsItemCollapsed( HWNDparam( 1 ), HTREEparam( 2 ) ) );
}

HB_FUNC( TREEVIEW_AUTOEXPAND )
{
   static HTREEITEM htiPrevious = NULL;        // TODO: Thread safe ?
   POINT pnt;
   HTREEITEM htiTarget;
   TVHITTESTINFO tvht;
   PHB_ITEM pSelf;
   HWND hTreeTarget = HWNDparam( 1 );
   HWND hTreeOrigin = HWNDparam( 2 );
   HTREEITEM htiOrigin = HTREEparam( 3 );

   /* get the current position of the mouse pointer in screen coordinates and see if it's on an item */
   GetCursorPos( &pnt );
   ScreenToClient( hTreeTarget, &pnt ) ;
   tvht.pt.x = pnt.x ;
   tvht.pt.y = pnt.y ;
   htiTarget = TreeView_HitTest( hTreeTarget, &tvht );

   if( ! htiTarget )
   {

      return;
   }

   /* don't expand if target is the same as the origin */
   if( hTreeTarget == hTreeOrigin && htiTarget == htiOrigin )
   {

      return;
   }
   /* don't expand if target is the origin's parent */
   else if( hTreeTarget == hTreeOrigin && htiTarget == TreeView_GetParent( hTreeTarget, htiOrigin ) )
   {

      return;
   }
   /* don't expand if target is child of the origin */
   else if( hTreeTarget == hTreeOrigin && IsTargetChild( hTreeTarget, htiOrigin, htiTarget ) )
   {

      return;
   }
   else
   {
      /* don't expand if target item is disabled
       * ::ItemEnabled( ::HandleToItem( TreeItemHandle ) )
       */
      pSelf = GetControlObjectByHandle( hTreeTarget );

      _OOHG_Send( pSelf, s_HandleToItem );
      HWNDpush( htiTarget );
      hb_vmSend( 1 );

      _OOHG_Send( pSelf, s_ItemEnabled );
      hb_vmPush( hb_param( -1, HB_IT_ANY ) );
      hb_vmSend( 1 );

      if( hb_parl( -1 ) )
      {
         /* if enabled show the right cursor */
         SetDragCursorARROW( GetKeyState( VK_CONTROL ) < 0 );
      }
      else
      {

         return;
      }
   }

   /* see if we are on the same item as we were in the previous call */
   if( htiTarget == htiPrevious )
   {
      if( TreeView_IsItemCollapsed( hTreeTarget, htiTarget ) )
      {
         ImageList_DragShowNolock( FALSE );

         TreeView_Expand( hTreeTarget, htiTarget, TVE_EXPAND );

         /* reselect the drop target, the tree may have been scrolled putting a different item under the cursor */
         htiTarget = TreeView_HitTest( hTreeTarget, &tvht );
         TreeView_SelectDropTarget( hTreeTarget, htiTarget );

         UpdateWindow( hTreeTarget );

         ImageList_DragShowNolock( TRUE );
      }
   }

   /* save item for next call */
   htiPrevious = htiTarget;
}

HB_FUNC( TREEVIEW_ONMOUSEDROP)
{
   HWND hTreeOrigin = HWNDparam( 1 );
   HTREEITEM htiOrigin = HTREEparam( 2 );
   HWND hTreeTarget = HWNDparam( 3 );
   HTREEITEM htiTarget;
   PHB_ITEM pSelf;

   /* get target item */
   htiTarget = TreeView_GetDropHilight( hTreeTarget );

   /* see if target item is valid */
   if( htiTarget )
   {
      if( hTreeOrigin == hTreeTarget && htiTarget == htiOrigin )
      {
         /* an item can't be dropped onto itself */
         htiTarget = NULL;
      }
      else if( hTreeOrigin == hTreeTarget && IsTargetChild( hTreeOrigin, htiOrigin, htiTarget ) )
      {
         /* an item can't be dropped onto one of its children */
         htiTarget = NULL;
      }
      else
      {
         /* an item can't be dropped onto a disabled item
          * ::ItemEnabled( ::HandleToItem( TreeItemHandle ) )
          */
         pSelf = GetControlObjectByHandle( hTreeTarget );

         _OOHG_Send( pSelf, s_HandleToItem );
         HWNDpush( htiTarget );
         hb_vmSend( 1 );

         _OOHG_Send( pSelf, s_ItemEnabled );
         hb_vmPush( hb_param( -1, HB_IT_ANY ) );
         hb_vmSend( 1 );

         if( ! hb_parl( -1 ) )
         {
            htiTarget = NULL;
         }
      }
   }

   HTREEret( htiTarget );
}

#if defined( __BORLANDC__ )
WINCOMMCTRLAPI void WINAPI ImageList_EndDrag( void );
#endif

HB_FUNC( IMAGELIST_ENDDRAG )
{
   ImageList_EndDrag();
}

HB_FUNC( RELEASECAPTURE )
{
   ReleaseCapture();
}

HB_FUNC( TREEVIEW_ENSUREVISIBLE )
{
   hb_retl( TreeView_EnsureVisible( HWNDparam( 1 ), HTREEparam( 2 ) ) );
}

HB_FUNC( TREEVIEW_GETFIRSTVISIBLE )
{
   HTREEret( TreeView_GetFirstVisible( HWNDparam( 1 ) ) );
}

HB_FUNC( TREEVIEW_GETPREVVISIBLE )
{
   HTREEret( TreeView_GetPrevVisible( HWNDparam( 1 ), HTREEparam( 2 ) ) );
}

HB_FUNC( TREEVIEW_GETNEXTVISIBLE )
{
   HTREEret( TreeView_GetNextVisible( HWNDparam( 1 ), HTREEparam( 2 ) ) );
}

HB_FUNC( TREEVIEW_GETLASTVISIBLE )
{
   HTREEret( TreeView_GetLastVisible( HWNDparam( 1 ) ) );
}

HB_FUNC( TREEVIEW_GETVISIBLECOUNT )
{
   hb_retni( TreeView_GetVisibleCount( HWNDparam( 1 ) ) );
}

HB_FUNC( TREEVIEW_GETITEMHEIGHT )
{
   hb_retni( TreeView_GetItemHeight( HWNDparam( 1 ) ) );
}

HB_FUNC( TREEVIEW_SETITEMHEIGHT )
{
   hb_retni( TreeView_SetItemHeight( HWNDparam( 1 ), hb_parni( 2 ) ) );
}

HB_FUNC( TREEVIEW_ISITEMVISIBLE )
{
   BOOL bVisible = FALSE;
   RECT iRect, wRect;
   LPRECT lpwRect = (LPRECT) &iRect;

   if( TreeView_GetItemRect( HWNDparam( 1 ), HTREEparam( 2 ), lpwRect, FALSE ) )
   {
      GetClientRect( HWNDparam( 1 ), (LPRECT) &wRect );

      if( hb_parl( 3 ) )
      {
         /* whole item shown */
         if( iRect.bottom <= wRect.bottom )
         {
            bVisible = TRUE;
         }
      }
      else
      {
         /* partially shown */
         if( iRect.top < wRect.bottom )
         {
            bVisible = TRUE;
         }
      }
   }

   hb_retl( bVisible );
}

HB_FUNC_STATIC( TTREE_BACKCOLOR )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &oSelf->lBackColor, ( hb_pcount() >= 1 ) ) )
   {
      if( ValidHandler( oSelf->hWnd ) )
      {
         if( oSelf->lBackColor != -1 )
         {
            (void) TreeView_SetBkColor( oSelf->hWnd, (COLORREF) oSelf->lBackColor );
         }
         else
         {
            (void) TreeView_SetBkColor( oSelf->hWnd, (COLORREF) GetSysColor( COLOR_WINDOW ) );
         }
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   // Return value was set in _OOHG_DetermineColorReturn()
}

#pragma ENDDUMP
