/*
 * $Id: h_tree.prg,v 1.9 2006-05-04 04:02:35 guerra000 Exp $
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

   METHOD Value       SETGET
   METHOD Events_Enter
ENDCLASS

*------------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, row, col, width, height, change, ;
               tooltip, fontname, fontsize, gotfocus, lostfocus, dblclick, ;
               break, value, HelpId, aImgNode, aImgItem, noBot, bold, ;
               italic, underline, strikeout, itemids, lRtl ) CLASS TTree
*------------------------------------------------------------------------------*
Local Controlhandle , ImgDefNode, ImgDefItem, aBitmaps := array(4)

   ::SetForm( ControlName, ParentForm, FontName, FontSize, , , .t., lRtl )

   if valtype(Value) == "N"
      ::InitValue := Value
	EndIf
	if valtype(Width) == "U"
		Width := 120
	endif
	if valtype(Height) == "U"
		Height := 120
	endif

   ::SetSplitBoxInfo( Break, )
   ControlHandle := InitTree ( ::ContainerhWnd, col , row , width , height , 0 , '' , 0, iif(noBot,1,0), ::lRtl )

	ImgDefNode := iif( valtype( aImgNode ) == "A" , len( aImgNode ), 0 )  //Tree+
	ImgDefItem := iif( valtype( aImgItem ) == "A" , len( aImgItem ), 0 )  //Tree+

	if ImgDefNode > 0

		aBitmaps[1] := aImgNode[1]  			// Node default
		aBitmaps[2] := aImgNode[ImgDefNode]

		if ImgDefItem > 0

			aBitmaps[3] := aImgItem[1]  		// Item default
			aBitmaps[4] := aImgItem[ImgDefItem]

		else

			aBitmaps[3] := aImgNode[1]  		 // Copy Node def if no Item def
			aBitmaps[4] := aImgNode[ImgDefNode]

		endif

      ::AddBitMap( aBitmaps )
	endif

	if valtype(change) == "U"
		change := ""
	endif

	if valtype(gotfocus) == "U"
		gotfocus := ""
	endif

	if valtype(lostfocus) == "U"
		lostfocus := ""
	endif

	if valtype(dblclick) == "U"
		dblclick := ""
	endif

   ::Register( ControlHandle, ControlName, HelpId, , ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )
   ::SizePos( Row, Col, Width, Height )

   ::ItemIds :=  itemids
   ::OnLostFocus := LostFocus
   ::OnGotFocus :=  GotFocus
   ::OnChange   :=  Change
   ::OnDblClick := dblclick
   ::aTreeMap   :=  {}
   ::aTreeIdMap :=  {}
   ::aTreeNode  :=  {}

   _OOHG_ActiveTree := Self

Return Self

*------------------------------------------------------------------------------*
METHOD AddItem( Value , Parent, aImage , Id ) CLASS TTree
*------------------------------------------------------------------------------*
Local TreeItemHandle
Local 	ImgDef, iUnSel, iSel
Local NewHandle , TempHandle , i , aPos , ChildHandle , BackHandle , ParentHandle

      if ! ::ItemIds

         If Parent > TreeView_GetCount( ::hWnd ) .or. Parent < 0
            MsgOOHGError ("Additem Method:  Invalid Parent Value. Program Terminated" )
			EndIf

		EndIf

		ImgDef := iif( valtype( aImage ) == "A" , len( aImage ), 0 )  //Tree+

		if Parent != 0

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

				iUnsel := 2	// Pointer to defalut Node Bitmaps, no Bitmap loaded
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

				iUnsel := 0	// Pointer to defalut Node Bitmaps, no Bitmap loaded
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

      BeforeCount := TreeView_GetCount ( ::hWnd )

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

      aSize ( ::aTreeMap , AfterCount )
      aSize ( ::aTreeIdMap, AfterCount )

Return nil

*------------------------------------------------------------------------------*
METHOD DeleteAllItems() CLASS TTree
*------------------------------------------------------------------------------*
      TreeView_DeleteAllItems ( ::hWnd )
      aSize ( ::aTreeMap , 0 )
      aSize ( ::aTreeIdMap, 0 )
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
METHOD Value( uValue ) CLASS TTree
*------------------------------------------------------------------------------*
Local TreeItemHandle, aPos

   IF VALTYPE( uValue ) == "N"

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

*-----------------------------------------------------------------------------*
METHOD Events_Enter() CLASS TTree
*-----------------------------------------------------------------------------*

   ::DoEvent( ::OnEnter )

Return nil

*------------------------------------------------------------------------------*
Function _DefineTreeNode ( text, aImage , Id )
*------------------------------------------------------------------------------*
Local 	ImgDef, iUnSel, iSel
Local Item

	If ValType ( Id ) == 'U'
		Id := 0
	EndIf

	ImgDef := iif( valtype( aImage ) == "A" , len( aImage ), 0 )  //Tree+

	if ImgDef == 0

		iUnsel := 0	// Pointer to defalut Node Bitmaps, no Bitmap loaded
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

	ImgDef := iif( valtype( aImage ) == "A" , len( aImage ), 0 )  //Tree+

	if ImgDef == 0

		iUnsel := 2	// Pointer to defalut Item Bitmaps, no Bitmap loaded
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
Function _EndTree()
*------------------------------------------------------------------------------*
Local Self := _OOHG_ActiveTree

   If ::InitValue > 0

      If ! ::ItemIds
         TreeView_SelectItem ( ::hWnd, ::aTreeMap [ ::InitValue ] )
		Else
         TreeView_SelectItem ( ::hWnd, ::aTreeMap [ ascan ( ::aTreeIdMap , ::InitValue ) ] )
		EndIf

	EndIf

Return Nil