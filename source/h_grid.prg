/*
 * $Id: h_grid.prg,v 1.19 2005-10-04 05:01:13 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG grid functions
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

#include 'oohg.ch'
#include 'hbclass.ch'
#include "i_windefs.ch"

CLASS TGrid FROM TControl
   DATA Type             INIT "GRID" READONLY
   DATA aWidths          INIT {}
   DATA aHeaders         INIT ""
   DATA aHeadClick       INIT {}
   DATA AllowEdit        INIT .F.
   DATA GridForeColor    INIT {}
   DATA GridBackColor    INIT {}
   DATA DynamicForeColor INIT {}
   DATA DynamicBackColor INIT {}
   DATA Picture          INIT {}
   DATA OnDispInfo       INIT nil
   DATA SetImageListCommand INIT LVM_SETIMAGELIST
   DATA SetImageListWParam  INIT LVSIL_SMALL
   DATA InPlace          INIT .F.
   DATA EditControls     INIT nil
   DATA ReadOnly         INIT nil
   DATA Valid            INIT nil
   DATA ValidMessages    INIT nil
   DATA OnEditCell       INIT nil

   METHOD Define
   METHOD Define2
   METHOD Value            SETGET

   METHOD Events
   METHOD Events_Enter
   METHOD Events_Notify

   METHOD EditItem
   METHOD AddColumn
   METHOD DeleteColumn
   METHOD Cell
   METHOD EditCell
   METHOD EditCell2

   METHOD AddItem
   METHOD DeleteItem
   METHOD DeleteAllItems      BLOCK { | Self | ListViewReset( ::hWnd ), ::GridForeColor := nil, ::GridBackColor := nil }
   METHOD Item
   METHOD SetItemColor
   METHOD ItemCount           BLOCK { | Self | ListViewGetItemCount( ::hWnd ) }
   METHOD Header
   METHOD FontColor      SETGET
   METHOD BackColor      SETGET
   METHOD SetRangeColor
   METHOD ColumnWidth
   METHOD ColumnAutoFit
   METHOD ColumnAutoFitH
   METHOD ColumnsAutoFit
   METHOD ColumnsAutoFitH
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
               aRows, value, fontname, fontsize, tooltip, change, dblclick, ;
               aHeadClick, gotfocus, lostfocus, nogrid, aImage, aJust, ;
               break, HelpId, bold, italic, underline, strikeout, ownerdata, ;
               ondispinfo, itemcount, editable, backcolor, fontcolor, ;
               dynamicbackcolor, dynamicforecolor, aPicture, lRtl, inplace, ;
               editcontrols, readonly, valid, validmessages, editcell ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local nStyle := LVS_SINGLESEL

   ::Define2( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
              aRows, value, fontname, fontsize, tooltip, change, dblclick, ;
              aHeadClick, gotfocus, lostfocus, nogrid, aImage, aJust, ;
              break, HelpId, bold, italic, underline, strikeout, ownerdata, ;
              ondispinfo, itemcount, editable, backcolor, fontcolor, ;
              dynamicbackcolor, dynamicforecolor, aPicture, lRtl, nStyle, ;
              inplace, editcontrols, readonly, valid, validmessages, editcell )
Return Self

*-----------------------------------------------------------------------------*
METHOD Define2( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
                aRows, value, fontname, fontsize, tooltip, change, dblclick, ;
                aHeadClick, gotfocus, lostfocus, nogrid, aImage, aJust, ;
                break, HelpId, bold, italic, underline, strikeout, ownerdata, ;
                ondispinfo, itemcount, editable, backcolor, fontcolor, ;
                dynamicbackcolor, dynamicforecolor, aPicture, lRtl, nStyle, ;
                inplace, editcontrols, readonly, valid, validmessages, editcell ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local ControlHandle, aImageList

   ::SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor, .t., lRtl )

   if ValType ( aHeaders ) != 'A'
      MsgOOHGError ("Grid: HEADERS not defined .Program Terminated")
	EndIf
   if ValType ( aWidths ) != 'A'
      MsgOOHGError ("Grid: WIDTHS not defined. Program Terminated")
	EndIf
	if Len ( aHeaders ) != Len ( aWidths )
      MsgOOHGError ("Browse/Grid: FIELDS/HEADERS/WIDTHS array size mismatch .Program Terminated")
	EndIf
   if ValType( aRows ) == 'A'
		if Len (aRows) > 0
			if Len (aRows[1]) != Len ( aHeaders )
            MsgOOHGError ("Grid: ITEMS length mismatch. Program Terminated")
			EndIf
		EndIf
   Else
		aRows := {}
	EndIf

   if valtype( w ) != "N"
		w := 240
	endif
   if valtype( h ) != "N"
		h := 120
	endif
   if valtype(aJust) != "A"
		aJust := Array( len( aHeaders ) )
		aFill( aJust, 0 )
	else
		aSize( aJust, len( aHeaders ) )
      aEval( aJust, { |x| x := iif( ValType( x ) != "N", 0, x ) } )
	endif

   if valtype( aPicture ) != "A"
      aPicture := Array( len( aHeaders ) )
	else
      aSize( aPicture, len( aHeaders ) )
	endif
   aEval( aPicture, { |x,i| aPicture[ i ] := iif( ( ValType( x ) $ "CM" .AND. ! Empty( x ) ) .OR. ValType( x ) == "L", x, nil ) } )

   if valtype( x ) != "N" .OR. valtype( y ) != "N"

      if _OOHG_SplitForceBreak
         Break := .T.
      endif
      _OOHG_SplitForceBreak := .F.

         ControlHandle := InitListView ( ::Parent:ReBarHandle, 0, 0, 0, w, h ,'',0,iif( nogrid, 0, 1 ) , ownerdata , itemcount , nStyle, ::lRtl )

         x := GetWindowCol( Controlhandle )
         y := GetWindowRow( Controlhandle )

         AddSplitBoxItem( Controlhandle, ::Parent:ReBarHandle, w , break , , , , _OOHG_ActiveSplitBoxInverted )

	Else

      ControlHandle := InitListView ( ::ContainerhWnd, 0, x, y, w, h ,'',0, iif( nogrid, 0, 1 ) , ownerdata  , itemcount  , nStyle, ::lRtl )

	endif

   if valtype( aImage ) == "A"
      aImageList := ImageList_Init( aImage, CLR_NONE, LR_LOADTRANSPARENT )
      SendMessage( ControlHandle, ::SetImageListCommand, ::SetImageListWParam, aImageList[ 1 ] )
      ::ImageList := aImageList[ 1 ]
      If ASCAN( aPicture, .T. ) == 0
         aPicture[ 1 ] := .T.
         aWidths[ 1 ] := max( aWidths[ 1 ], aImageList[ 2 ] + 2 ) // Set Column 1 width to Bitmap width
      EndIf
   EndIf

   InitListViewColumns( ControlHandle, aHeaders , aWidths, aJust )

   ::New( ControlHandle, ControlName, HelpId, , ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )
   ::SizePos( y, x, w, h )

   ::FontColor := ::aFontColor
   ::BackColor := ::aBackColor

   if valtype(aHeadClick) != "A"
		aHeadClick := {}
	endif

   ::OnDispInfo := ondispinfo
   ::aWidths := aWidths
   ::aHeaders :=  aHeaders
   ::OnLostFocus := LostFocus
   ::OnGotFocus :=  GotFocus
   ::OnChange   :=  Change
   ::OnDblClick := dblclick
   ::aHeadClick :=  aHeadClick
   ::AllowEdit :=  Editable
   ::DynamicForeColor := dynamicforecolor
   ::DynamicBackColor := dynamicbackcolor
   ::Picture := aPicture
   ::readonly := readonly
   ::valid := valid
   ::validmessages := validmessages
   IF ValType( inplace ) == "L"
      ::InPlace := inplace
   ENDIF
   ::EditControls := editcontrols
   ::OnEditCell := editcell

   AEVAL( aRows, { |u| ::AddItem( u ) } )

   ::Value := value

Return Self

*-----------------------------------------------------------------------------*
METHOD EditItem() CLASS TGrid
*-----------------------------------------------------------------------------*
Local a,l,g,actpos:={0,0,0,0},GRow,GCol,GWidth,Col,IRow,LN , TN , item,i, oWnd, aSave
Local aNum, oCtrl

   a := ::aHeaders

   item := ::Value
   IF item == 0
      return nil
   ENDIF

	l := Len(a)

   g := ::Item( Item )

   IRow := ListViewGetItemRow ( ::hWnd, Item )

   GetWindowRect( ::hWnd, actpos )

	GRow 	:= actpos [2]
	GCol 	:= actpos [1]
	GWidth 	:= actpos [3] - actpos [1]
   aSave := {}

	Col := GCol + ( ( GWidth - 260 ) / 2 )

	DEFINE WINDOW _EditItem ;
      OBJ oWnd ;
		AT IRow,Col ;
		WIDTH 260 ;
		HEIGHT (l*30) + 70 + GetTitleHeight() ;
      TITLE _OOHG_MESSAGE [5] ;
		MODAL ;
      NOSIZE

		For i := 1 to l
			LN := 'Label_' + Alltrim(Str(i,2,0))
			TN := 'Text_' + Alltrim(Str(i,2,0))
			@ (i*30) - 17 , 10 LABEL &LN OF _EditItem VALUE Alltrim(a[i]) +":"
         If ValType( g[ i ] ) == "N"
            @ (i*30) - 20 , 120 COMBOBOX &TN OF _EditItem ITEMS {} VALUE 0
            oCtrl := oWnd:Control( TN )
            aNum := ARRAY( ImageList_GetImageCount( ::ImageList ) )
            SendMessage( oCtrl:hWnd, oCtrl:SetImageListCommand, oCtrl:SetImageListWParam, ::ImageList )
            AEVAL( aNum, { |x,i| ComboAddString( oCtrl:hWnd, i - 1 ), x } )
            oCtrl:Value := g[ i ] + 1
            AADD( aSave, TGrid_EditItemBlock2( g, i, oWnd:Control( TN ) ) )
         ElseIf ValType( ::Picture ) == "A" .AND. Len( ::Picture ) >= i .AND. ValType( ::Picture[ i ] ) $ "CM"
            @ (i*30) - 20 , 120 TEXTBOX  &TN OF _EditItem VALUE g[i] PICTURE ::Picture[ i ]
            AADD( aSave, TGrid_EditItemBlock1( g, i, oWnd:Control( TN ) ) )
         Else
            @ (i*30) - 20 , 120 TEXTBOX  &TN OF _EditItem VALUE g[i]
            AADD( aSave, TGrid_EditItemBlock1( g, i, oWnd:Control( TN ) ) )
         ENDIF
		Next i
* readonly, valid, validmessages clauses!!!!!!!!!!!!!!!!!

		@ (l*30) + 20 , 20 BUTTON BUTTON_1 ;
		OF _EDITITEM ;
      CAPTION _OOHG_MESSAGE [6] ;
      ACTION { || AEVAL( aSave, { |b| _OOHG_EVAL( b ) } ), ::Item( Item , g ), oWnd:Release(), _OOHG_Eval( ::OnEditCell, item, 0 ) }

		@ (l*30) + 20 , 130 BUTTON BUTTON_2 ;
		OF _EDITITEM ;
      CAPTION _OOHG_MESSAGE [7] ;
      ACTION oWnd:Release()

	END WINDOW

   oWnd:Text_1:SetFocus()

   oWnd:Activate()

   ::SetFocus()

Return Nil

STATIC FUNCTION TGrid_EditItemBlock1( aItems, nItem, oControl )
Return { || aItems[ nItem ] := oControl:Value }

STATIC FUNCTION TGrid_EditItemBlock2( aItems, nItem, oControl )
Return { || aItems[ nItem ] := oControl:Value - 1 }

*-----------------------------------------------------------------------------*
METHOD AddColumn( nColIndex, cCaption, nWidth, nJustify, uForeColor, uBackColor, lNoDelete, uPicture ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local nColumns, uGridColor, uDynamicColor

	// Set Default Values
   nColumns := Len( ::aHeaders ) + 1

   If ValType( nColIndex ) != 'N' .OR. nColIndex > nColumns
      nColIndex := nColumns
   ElseIf nColIndex < 1
      nColIndex := 1
	EndIf

   If ! ValType( cCaption ) $ 'CM'
		cCaption := ''
	EndIf

   If ValType( nWidth ) != 'N'
		nWidth := 120
	EndIf

   If ValType( nJustify ) != 'N'
		nJustify := 0
	EndIf

   // Update Headers
   ASIZE( ::aHeaders, nColumns )
   AINS( ::aHeaders, nColIndex )
   ::aHeaders[ nColIndex ] := cCaption

   // Update Pictures
   ASIZE( ::Picture, nColumns )
   AINS( ::Picture, nColIndex )
   ::Picture[ nColIndex ] := iif( ( ValType( uPicture ) $ "CM" .AND. ! Empty( uPicture ) ) .OR. ValType( uPicture ) == "L", uPicture, nil )

   IF ValType( lNoDelete ) != "L"
      lNoDelete := .F.
   ENDIF

   // Update Foreground Color
   uGridColor := ::GridForeColor
   uDynamicColor := ::DynamicForeColor
   TGrid_AddColumnColor( @uGridColor, nColIndex, uForeColor, @uDynamicColor, nColumns, ::ItemCount(), lNoDelete )
   ::GridForeColor := uGridColor
   ::DynamicForeColor := uDynamicColor

   // Update Background Color
   uGridColor := ::GridBackColor
   uDynamicColor := ::DynamicBackColor
   TGrid_AddColumnColor( @uGridColor, nColIndex, uBackColor, @uDynamicColor, nColumns, ::ItemCount(), lNoDelete )
   ::GridBackColor := uGridColor
   ::DynamicBackColor := uDynamicColor

	// Call C-Level Routine
   ListView_AddColumn( ::hWnd, nColIndex, nWidth, cCaption, nJustify, lNoDelete )

Return nil

STATIC Function TGrid_AddColumnColor( aGrid, nColumn, uColor, uDynamicColor, nWidth, nItemCount, lNoDelete )
Local uTemp, x
   IF ValType( uDynamicColor ) == "A"
      IF Len( uDynamicColor ) < nWidth
         ASIZE( uDynamicColor, nWidth )
      ENDIF
      AINS( uDynamicColor, nColumn )
      uDynamicColor[ nColumn ] := uColor
   ElseIf ValType( uColor ) $ "ANB"
      uTemp := uDynamicColor
      uDynamicColor := ARRAY( nWidth )
      AFILL( uDynamicColor, uTemp )
      uDynamicColor[ nColumn ] := uColor
   ENDIF
   IF ! lNoDelete
      uDynamicColor := nil
   ElseIf ValType( aGrid ) == "A" .OR. ValType( uColor ) $ "ANB" .OR. ValType( uDynamicColor ) $ "ANB"
      IF ValType( aGrid ) == "A"
         IF Len( aGrid ) < nItemCount
            ASIZE( aGrid, nItemCount )
         Else
            nItemCount := Len( aGrid )
         ENDIF
      Else
         aGrid := ARRAY( nItemCount )
      ENDIF
      FOR x := 1 TO nItemCount
         IF ValType( aGrid[ x ] ) == "A"
            IF LEN( aGrid[ x ] ) < nWidth
                ASIZE( aGrid[ x ], nWidth )
            ENDIF
            AINS( aGrid[ x ], nColumn )
         Else
            aGrid[ x ] := ARRAY( nWidth )
         ENDIF
         aGrid[ x ][ nColumn ] := _OOHG_GetArrayItem( uDynamicColor, nColumn, x )
      NEXT
   ENDIF
Return NIL

*-----------------------------------------------------------------------------*
METHOD DeleteColumn( nColIndex, lNoDelete ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local nColumns

   // Update Headers
   nColumns := Len( ::aHeaders )
   IF nColumns == 0
      Return nil
   ENDIF

   If ValType( nColIndex ) != 'N' .OR. nColIndex > nColumns
      nColIndex := nColumns
   ElseIf nColIndex < 1
      nColIndex := 1
	EndIf

   _OOHG_DeleteArrayItem( ::aHeaders, nColIndex )
   _OOHG_DeleteArrayItem( ::Picture,  nColIndex )

   _OOHG_DeleteArrayItem( ::DynamicForeColor, nColIndex )
   _OOHG_DeleteArrayItem( ::DynamicBackColor, nColIndex )

   If ValType( lNoDelete ) == "L" .AND. lNoDelete
      IF ValType( ::GridForeColor ) == "A"
         AEVAL( ::GridForeColor, { |a| _OOHG_DeleteArrayItem( a, nColIndex ) } )
      ENDIF
      IF ValType( ::GridBackColor ) == "A"
         AEVAL( ::GridBackColor, { |a| _OOHG_DeleteArrayItem( a, nColIndex ) } )
      ENDIF
   Else
      ::GridForeColor := nil
      ::GridBackColor := nil
   EndIf

	// Call C-Level Routine
   ListView_DeleteColumn( ::hWnd, nColIndex, lNoDelete )

Return nil

*-----------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TGrid
*-----------------------------------------------------------------------------*
   IF VALTYPE( uValue ) == "N"
      ListView_SetCursel( ::hWnd, uValue )
      ListView_EnsureVisible( ::hWnd, uValue )
   ELSE
      uValue := LISTVIEW_GETFIRSTITEM( ::hWnd )
   ENDIF
RETURN uValue

*-----------------------------------------------------------------------------*
METHOD Cell( nRow, nCol, uValue ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local aItem, uValue2 := nil
   IF nRow >= 1 .AND. nRow <= ListViewGetItemCount( ::hWnd )
      aItem := ListViewGetItem( ::hWnd, nRow, Len( ::aHeaders ) )
      IF nCol >= 1 .AND. nCol <= Len( aItem )
         IF PCOUNT() > 2
            aItem[ nCol ] := uValue
            ::Item( nRow, aItem )
         ENDIF
         uValue2 := aItem[ nCol ]
      ENDIF
   ENDIF
Return uValue2

*-----------------------------------------------------------------------------*
METHOD EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local lRet, lForceString, lIcon
   lIcon := .F.
   IF ValType( nCol ) != "N"
      nCol := 1
   ENDIF
   IF ValType( nRow ) != "N"
      nRow := LISTVIEW_GETFIRSTITEM( ::hWnd )
   ENDIF
   If nRow < 1 .OR. nRow > ::ItemCount() .OR. nCol < 1 .OR. nCol > Len( ::aHeaders )
      Return .F.
   EndIf

   If ValType( uOldValue ) == "U"
      uOldValue := ::Cell( nRow, nCol )
      If ValType( uOldValue ) == "N"
         lIcon := .T.
      EndIf
   ElseIf ValType( uOldValue ) == "N" .AND. ValType( ::Picture[ nCol ] ) == "L" .AND. ::Picture[ nCol ]
      lIcon := .T.
   EndIf

   // Checks if it must require a text value
   IF ValType( ::Picture[ nCol ] ) $ "CM" .OR. lIcon
      lForceString := .F.
   Else
      lForceString := .T.
   ENDIF

   // If it's an image, checks for image list
   IF lIcon
      IF ValType( EditControl ) != "A" .OR. Len( EditControl ) == 0
         EditControl := { "IMAGELIST" }
      ENDIF
   ENDIF

   lRet := ::EditCell2( @nRow, @nCol, EditControl, uOldValue, @uValue, cMemVar, lForceString )
   IF lRet
      IF ValType( uValue ) $ "CM"
         uValue := Trim( uValue )
      ENDIF
      ::Cell( nRow, nCol, uValue )
      _OOHG_Eval( ::OnEditCell, nRow, nCol )
   ENDIF
Return lRet

*-----------------------------------------------------------------------------*
METHOD EditCell2( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, lForceString ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local r, r2, oInPlace, lRet := .F., nControlType, bForceString, cMask, aItems
   IF ValType( cMemVar ) != "C"
      cMemVar := "_OOHG_NULLVAR_"
   ENDIF
   IF ValType( nRow ) != "N"
      nRow := LISTVIEW_GETFIRSTITEM( ::hWnd )
   ENDIF
   IF ValType( nCol ) != "N"
      nCol := 1
   ENDIF
   IF nRow < 1 .OR. nRow > ::ItemCount() .OR. nCol < 1 .OR. nCol > Len( ::aHeaders )
      // Cell out of range
   ElseIf VALTYPE( ::ReadOnly ) == "A" .AND. Len( ::ReadOnly ) >= nCol .AND. ValType( ::ReadOnly[ nCol ] ) == "L" .AND. ::ReadOnly[ nCol ]
      // Read only column
      PlayHand()
   Else

      // Cell value
      IF ValType( uOldValue ) == "U"
         uValue := ::Cell( nRow, nCol )
      Else
         uValue := uOldValue
      ENDIF

      // Determines control type
      If ValType( EditControl ) == "A" .AND. Len( EditControl ) >= 1
         // EditControl specified
      ElseIf ValType( ::EditControls ) == "A" .AND. Len( ::EditControls ) >= nCol .AND. ValType( ::EditControls[ nCol ] ) == "A" .AND. Len( ::EditControls[ nCol ] ) >= 1
         // EditControl specified at control definition
         EditControl := ::EditControls[ nCol ]
      ElseIf ValType( ::Picture[ nCol ] ) == "C"
         // Picture-based
         EditControl := { "TEXTBOX", ValType( uValue ), ::Picture[ nCol ], "" }
      Else
         // Checks according to data type
         Do Case
            Case ValType( uValue ) == "N"
               r := Str( uValue )
               EditControl := { "TEXTBOX", "N", Replicate( "9", Len( r ) ), "" }
               r := At( ".", r )
               IF r != 0
                  EditControl[ 3 ] := Left( EditControl[ 3 ], r - 1 ) + "." + SubStr( EditControl[ 3 ], r + 1 )
               ENDIF
            Case ValType( uValue ) == "L"
               // EditControl := { "CHECKBOX", ".T.", ".F." }
               EditControl := { "LCOMBOBOX", ".T.", ".F." }
            Case ValType( uValue ) == "D"
               // EditControl := { "DATEPICKER", .T. }
               EditControl := { "TEXTBOX", "D", "", "D" }
            Case ValType( uValue ) == "M"
               EditControl := { "MEMO" }
            Case ValType( uValue ) == "C"
               EditControl := { "TEXTBOX", "C" }
            OtherWise
               // Non-implemented data type!!!
         EndCase

      EndIf

      r2 := { 0, 0, 0, 0 }
      GetWindowRect( ::hWnd, r2  )

      If ValType( EditControl ) != "A" .OR. Len( EditControl ) < 1
         MsgExclamation( "ooHG can't determine cell type for INPLACE edit." )
      Else
         nControlType := aScan( { "MEMO", "DATEPICKER", "COMBOBOX", "SPINNER", "CHECKBOX", "TEXTBOX", "IMAGELIST", "LCOMBOBOX" }, { |c| Upper( EditControl[ 1 ] ) == c } )
         If nControlType == 0
            MsgExclamation( "GRID: Invalid control type: " + EditControl[ 1 ] )
         Else

            ListView_EnsureVisible( ::hWnd, nRow - 1 )
            r := LISTVIEW_GETSUBITEMRECT( ::hWnd, nRow - 1, nCol - 1 )
            r[ 3 ] := ListView_GetColumnWidth( ::hWnd, nCol - 1 )
            // Ensures cell is visible
            If r[ 2 ] + r[ 3 ] + GetVScrollBarWidth() > ::Width
               ListView_Scroll( ::hWnd, ( r[ 2 ] + r[ 3 ] + GetVScrollBarWidth() - ::Width ), 0 )
               r := LISTVIEW_GETSUBITEMRECT( ::hWnd, nRow - 1, nCol - 1 )
               r[ 3 ] := ListView_GetColumnWidth( ::hWnd, nCol - 1 )
            EndIf
            If r[ 2 ] < 0
               ListView_Scroll( ::hWnd, r[ 2 ], 0 )
               r := LISTVIEW_GETSUBITEMRECT( ::hWnd, nRow - 1, nCol - 1 )
               r[ 3 ] := ListView_GetColumnWidth( ::hWnd, nCol - 1 )
            EndIf
            r[ 4 ] += 6

            r[ 1 ] += r2[ 2 ] + 2
            r[ 2 ] += r2[ 1 ] + 3
            If nControlType == 1 // Caption/size
               DEFINE WINDOW 0 OBJ oInPlace ;
                  AT r[ 2 ], r[ 1 ] WIDTH r[ 3 ] HEIGHT r[ 4 ] ;
                  MODAL NOSIZE
            Else
               DEFINE WINDOW 0 OBJ oInPlace ;
                  AT r[ 1 ], r[ 2 ] WIDTH r[ 3 ] HEIGHT r[ 4 ] ;
                  MODAL NOSIZE NOCAPTION

               ON KEY RETURN ACTION ( lRet := TGrid_InPlaceValid( Self, oInPlace, nCol, cMemVar, @uValue ) )
            ENDIF

            ON KEY ESCAPE ACTION ( oInPlace:Release() , ::SetFocus() )

            Do Case
               Case nControlType == 1    // Memo
                  oInPlace:Width  := 350
                  oInPlace:Height := GetTitleHeight() + 265
                  oInPlace:Center()
                  oInPlace:Title := "Edit Memo"
                  @ 07,10 LABEL _Label      VALUE ""   WIDTH 280
                  @ 30,10 EDITBOX Control_1 VALUE STRTRAN( uValue, chr(141), ' ' ) HEIGHT 176  WIDTH 320
                  @ 217,120 BUTTON _Ok      CAPTION _OOHG_MESSAGE[ 6 ] ACTION ( lRet := TGrid_InPlaceValid( Self, oInPlace, nCol, cMemVar, @uValue ) )
                  @ 217,230 BUTTON _Cancel  CAPTION _OOHG_MESSAGE[ 7 ] ACTION ( oInPlace:Release() , ::SetFocus() )
                  bForceString := { |value| value }

               Case nControlType == 2    // DatePicker
                  If ValType( uValue ) == "C"
                     uValue := CTOD( uValue )
                  EndIf
                  If Len( EditControl ) >= 2 .AND. ValType( EditControl[ 2 ] ) == "L"
                     If EditControl[ 2 ]
                        @ 0,0 DATEPICKER Control_1 WIDTH r[ 3 ] HEIGHT r[ 4 ] + 6 VALUE uValue UPDOWN
                     Else
                        @ 0,0 DATEPICKER Control_1 WIDTH r[ 3 ] HEIGHT r[ 4 ] + 6 VALUE uValue
                     EndIf
                  EndIf
                  bForceString := { |value| DTOC( value ) }

               Case nControlType == 3    // ComboBox
                  If ValType( uValue ) == "C"
                     uValue := aScan( EditControl[ 2 ], { |c| c == uValue  } )
                  EndIf
                  @ 0,0 COMBOBOX Control_1 WIDTH r[ 3 ] VALUE uValue ITEMS EditControl[ 2 ]
                  SendMessage( oInPlace:Control_1:hWnd, oInPlace:Control_1:SetImageListCommand, oInPlace:Control_1:SetImageListWParam, ::ImageList )
                  bForceString := { |value| if( value == 0 , "", EditControl[ 2 ][ value ] ) }

               Case nControlType == 4    // Spinner
                  If ValType( uValue ) == "C"
                     uValue := Val( uValue )
                  EndIf
                  @ 0,0 SPINNER Control_1 RANGE EditControl[ 2 ], EditControl[ 3 ] WIDTH r[ 3 ] HEIGHT r[ 4 ] VALUE uValue
                  bForceString := { |value| LTRIM( STR( value ) ) }

               Case nControlType == 5    // CheckBox
                  If ValType( uValue ) == "C"
                     uValue := ( uValue == EditControl[ 2 ] )
                  EndIf
                  @ 0,0 CHECKBOX Control_1 CAPTION if( uValue, EditControl[ 2 ], EditControl[ 3 ] ) WIDTH r[ 3 ] HEIGHT r[ 4 ] VALUE uValue ;
                        ON CHANGE ( oInPlace:Control_1:Caption := if( oInPlace:Control_1:Value, EditControl[ 2 ], EditControl[ 3 ] ) )
                  bForceString := { |value| if( value, EditControl[ 2 ], EditControl[ 3 ] ) }

               Case nControlType == 6    // TextBox
                  If Valtype( uValue ) == "C"
                     Do Case
                        Case EditControl[ 2 ] = "N"
                           uValue := Val( uValue )
                        Case EditControl[ 2 ] = "D"
                           uValue := CTOD( uValue )
                     EndCase
                  EndIf

                  cMask := ""
                  If Len( EditControl ) >= 3
                     IF ValType( EditControl[ 3 ] ) $ "CM" .AND. ! Empty( EditControl[ 3 ] )
                        cMask := EditControl[ 3 ]
                     ENDIF
                     IF Len( EditControl ) >= 4 .AND. ValType( EditControl[ 4 ] ) $ "CM" .AND. ! Empty( EditControl[ 4 ] )
                        cMask := "@" + EditControl[ 4 ] + " " + cMask
                     ENDIF
                  EndIf
                  If ! Empty( cMask )
                     @ 0,0 TEXTBOX Control_1 WIDTH r[ 3 ] HEIGHT r[ 4 ] VALUE uValue INPUTMASK cMask
                  Else
                     @ 0,0 TEXTBOX Control_1 WIDTH r[ 3 ] HEIGHT r[ 4 ] VALUE uValue
                  EndIf
                  Do Case
                     Case ValType( uValue ) == "N"
                        bForceString := { |value| LTrim( Str( value ) ) }
                     Case ValType( uValue ) == "D"
                        bForceString := { |value| DTOC( value ) }
                     OtherWise
                        bForceString := { |value| value }
                  EndCase

               Case nControlType == 7    // ImageList
                  If ValType( uValue ) == "C"
                     uValue := Val( uValue )
                  EndIf
                  @ 0,0 COMBOBOX Control_1 WIDTH r[ 3 ] VALUE 0 ITEMS {}
                  SendMessage( oInPlace:Control_1:hWnd, oInPlace:Control_1:SetImageListCommand, oInPlace:Control_1:SetImageListWParam, ::ImageList )
                  AEVAL( ARRAY( ImageList_GetImageCount( ::ImageList ) ), { |x,i| ComboAddString( oInPlace:Control_1:hWnd, i - 1 ), x } )
                  uValue++
                  oInPlace:Control_1:Value := uValue
                  oInPlace:OnRelease := { || uValue-- }
                  bForceString := { |value| LTrim( Str( value ) ) }

               Case nControlType == 8    // Logic-ComboBox
                  aItems := { ".T.", ".F." }
                  IF Len( EditControl ) >= 2 .AND. ValType( EditControl[ 2 ] ) $ "CM"
                     aItems[ 1 ] := EditControl[ 2 ]
                  ENDIF
                  IF Len( EditControl ) >= 3 .AND. ValType( EditControl[ 3 ] ) $ "CM"
                     aItems[ 2 ] := EditControl[ 3 ]
                  ENDIF
                  If ValType( uValue ) == "C"
                     uValue := ( uValue == aItems[ 2 ] .OR. UPPER( uValue ) == ".T." )
                  EndIf
                  uValue := if( uValue, 1, 2 )
                  @ 0,0 COMBOBOX Control_1 WIDTH r[ 3 ] VALUE uValue ITEMS aItems
                  SendMessage( oInPlace:Control_1:hWnd, oInPlace:Control_1:SetImageListCommand, oInPlace:Control_1:SetImageListWParam, ::ImageList )
                  oInPlace:OnRelease := { || uValue := ( uValue == 1 ) }
                  bForceString := { |value| if( value == 0 , "", aItems[ value ] ) }

            EndCase

            oInplace:Control_1:SetFocus()
            END WINDOW
            oInPlace:Activate()

            If lRet .AND. ValType( lForceString ) == "L" .AND. lForceString
               uValue := Eval( bForceString, uValue )
            EndIf
         EndIf
      EndIf
   EndIf
Return lRet

Static Function TGrid_InPlaceValid( Self, oInPlace, nCol, cMemVar, uValue )
Local lRet, lValid, uValue2
   lRet := .F.
   uValue2 := oInPlace:Control_1:Value
   If ValType( ::Valid ) == 'A' .AND. Len ( ::Valid ) >= nCol .AND. ValType( ::Valid[ nCol ] ) == "B"
      &cMemVar := uValue2
      lValid := _OOHG_Eval( ::Valid[ nCol ], uValue2 )
      IF ValType( lValid ) != "L"
         lValid := .T.
      ENDIF
   Else
      lValid := .T.
   Endif

   If lValid
      lRet := .T.
      uValue := uValue2
      oInPlace:Release()
   Else
      If ValType( ::ValidMessages ) == 'A' .AND. Len ( ::ValidMessages ) >= nCol .AND. ValType( ::ValidMessages[ nCol ] ) $ "CM"
         MsgExclamation( ::ValidMessages[ nCol ] )
      Else
         MsgExclamation( _OOHG_BRWLangError[ 11 ] )
      Endif
      oInPlace:Control_1:SetFocus()
   Endif
Return lRet

#pragma BEGINDUMP
#define s_Super s_TControl
#include "hbapi.h"
#include "hbvm.h"
#include <windows.h>
#include "../include/oohg.h"

// -----------------------------------------------------------------------------
HB_FUNC_STATIC( TGRID_EVENTS )   // METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TGrid
// -----------------------------------------------------------------------------
{
// int TGrid_Notify_CustomDraw( PHB_ITEM pSelf, LPARAM lParam );
   HWND hWnd      = ( HWND )   hb_parnl( 1 );
   UINT message   = ( UINT )   hb_parni( 2 );
   WPARAM wParam  = ( WPARAM ) hb_parni( 3 );
   LPARAM lParam  = ( LPARAM ) hb_parnl( 4 );
   PHB_ITEM pSelf = hb_stackSelfItem();

   if ( message == WM_MOUSEWHEEL )
	{

      if ( ( short ) HIWORD ( wParam ) > 0 )
		{

			keybd_event(
			VK_UP	,	// virtual-key code
			0,		// hardware scan code
			0,		// flags specifying various function options
			0		// additional data associated with keystroke
			);

		}
		else
		{

			keybd_event(
			VK_DOWN	,	// virtual-key code
			0,		// hardware scan code
			0,		// flags specifying various function options
			0		// additional data associated with keystroke
			);

		}

      hb_retni( 1 );
	}
	else
	{
      _OOHG_Send( pSelf, s_Super );
      hb_vmSend( 0 );
      _OOHG_Send( hb_param( -1, HB_IT_OBJECT ), s_Events );
      hb_vmPushLong( ( LONG ) hWnd );
      hb_vmPushLong( message );
      hb_vmPushLong( wParam );
      hb_vmPushLong( lParam );
      hb_vmSend( 4 );
	}
}
#pragma ENDDUMP

*-----------------------------------------------------------------------------*
METHOD Events_Enter() CLASS TGrid
*-----------------------------------------------------------------------------*

   If ::InPlace
      ::EditCell()
   ElseIf ::AllowEdit
      ::EditItem()
   Else
      ::DoEvent( ::OnDblClick )
   EndIf

Return nil

*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam )
Local lvc, aCellData, _ThisQueryTemp

   If nNotify == NM_CUSTOMDRAW

      Return TGRID_NOTIFY_CUSTOMDRAW( Self, lParam )

   ElseIf nNotify == LVN_GETDISPINFO

      * Grid OnQueryData ............................

      if valtype( ::OnDispInfo ) == 'B'

         _PushEventInfo()
         _OOHG_ThisForm := ::Parent
         _OOHG_ThisType := 'C'
         _OOHG_ThisControl := Self
         _ThisQueryTemp  := GETGRIDDISPINFOINDEX ( lParam )
         _OOHG_ThisQueryRowIndex  := _ThisQueryTemp [1]
         _OOHG_ThisQueryColIndex  := _ThisQueryTemp [2]
         Eval( ::OnDispInfo )
         IF ValType( _OOHG_ThisQueryData ) == "N"
            SetGridQueryImage ( lParam , _OOHG_ThisQueryData )
         ElseIf ValType( _OOHG_ThisQueryData ) $ "CM"
            SetGridQueryData ( lParam , _OOHG_ThisQueryData )
         EndIf
         _OOHG_ThisQueryRowIndex  := 0
         _OOHG_ThisQueryColIndex  := 0
         _OOHG_ThisQueryData := ""
         _PopEventInfo()

      EndIf

   elseif nNotify == LVN_ITEMCHANGED

      If GetGridOldState(lParam) == 0 .and. GetGridNewState(lParam) != 0
         ::DoEvent( ::OnChange )
         Return nil
      EndIf

   elseif nNotify == LVN_COLUMNCLICK

      if ValType ( ::aHeadClick ) == 'A'
         lvc := GetGridColumn(lParam) + 1
         if len ( ::aHeadClick ) >= lvc
            ::DoEvent ( ::aHeadClick [lvc] )
            Return nil
         EndIf
      EndIf

   elseif nNotify == NM_DBLCLK

      _PushEventInfo()
      _OOHG_ThisForm := ::Parent
      _OOHG_ThisType := 'C'
      _OOHG_ThisControl := Self

      aCellData := _GetGridCellData( Self )
      _OOHG_ThisItemRowIndex   := aCellData[ 1 ]
      _OOHG_ThisItemColIndex   := aCellData[ 2 ]
      _OOHG_ThisItemCellRow    := aCellData[ 3 ]
      _OOHG_ThisItemCellCol    := aCellData[ 4 ]
      _OOHG_ThisItemCellWidth  := aCellData[ 5 ]
      _OOHG_ThisItemCellHeight := aCellData[ 6 ]

      If ::InPlace

         ::EditCell( _OOHG_ThisItemRowIndex, _OOHG_ThisItemColIndex )

      ElseIf ::AllowEdit

         ::EditItem()

      ElseIf ValType( ::OnDblClick ) == "B"

         Eval( ::OnDblClick )

      EndIf

      _OOHG_ThisItemRowIndex   := 0
      _OOHG_ThisItemColIndex   := 0
      _OOHG_ThisItemCellRow    := 0
      _OOHG_ThisItemCellCol    := 0
      _OOHG_ThisItemCellWidth  := 0
      _OOHG_ThisItemCellHeight := 0
      _PopEventInfo()

      Return nil

* ¿Qué es -181?
   elseif nNotify == -181  // ???????

      redrawwindow( ::hWnd )

   EndIf

Return ::Super:Events_Notify( wParam, lParam )

*-----------------------------------------------------------------------------*
METHOD AddItem( aRow, uForeColor, uBackColor ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local iIm := 0

   if Len( ::aHeaders ) != Len( aRow )
      MsgOOHGError( "Grid.AddItem: Item size mismatch. Program Terminated" )
	EndIf

   aRow := ACLONE( aRow )
   AEVAL( ::Picture, { |x,i| if( ValType( x ) $ "CM", aRow[ i ] := Transform( aRow[ i ], x ), ) } )

   ::SetItemColor( ::ItemCount() + 1, uForeColor, uBackColor, aRow )

   AddListViewItems( ::hWnd , aRow )

Return Nil

*-----------------------------------------------------------------------------*
METHOD DeleteItem( nItem ) CLASS TGrid
*-----------------------------------------------------------------------------*
   _OOHG_DeleteArrayItem( ::GridForeColor, nItem )
   _OOHG_DeleteArrayItem( ::GridBackColor, nItem )
Return ListViewDeleteString( ::hWnd, nItem )

*-----------------------------------------------------------------------------*
METHOD Item( nItem, uValue, uForeColor, uBackColor ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local nColumn, aTemp, cMask, xValue
   IF PCOUNT() > 1
      aTemp := Array( Len( uValue ) )
      xValue := uValue[ nColumn ]
      For nColumn := 1 To Len( uValue )
         If ValType( ::Picture[ nColumn ] ) $ "CM"
            aTemp[ nColumn ] := Transform( xValue, ::Picture[ nColumn ] )
         ElseIf ValType( ::Picture[ nColumn ] ) == "N"
            aTemp[ nColumn ] := xValue
         ElseIf ValType( ::EditControls ) == "A" .AND. ValType( ::EditControls[ nColumn ] ) == "A" .AND. Len( ::EditControls[ nColumn ] ) >= 1
            If  ::EditControls[ nColumn ][ 1 ] == "DATEPICKER"
               aTemp[ nColumn ] := Transform( xValue, "@D" )
            ElseIf ::EditControls[ nColumn ][ 1 ] == "SPINNER"
               aTemp[ nColumn ] := LTrim( Str( xValue ) )
            ElseIf ::EditControls[ nColumn ][ 1 ] == "CHECKBOX"
               aTemp[ nColumn ] := If( xValue, ::EditControls[ nColumn ][ 2 ], ::EditControls[ nColumn ][ 3 ] )
            ElseIf ::EditControls[ nColumn ][ 1 ] == "COMBOBOX"
               If xValue >= 1 .AND. xValue <= Len( ::EditControls[ nColumn ][ 2 ] )
                  aTemp[ nColumn ] := ::EditControls[ nColumn ][ 2 ][ xValue ]
               Else
                  aTemp[ nColumn ] := ""
               Endif
            ElseIf ::EditControls[ nColumn ][ 1 ] == "LCOMBOBOX"
               If xValue
                  If Len( ::EditControls[ nColumn ] ) >= 2 .AND. ValType( ::EditControls[ nColumn ][ 2 ] ) $ "CM"
                     aTemp[ nColumn ] := ::EditControls[ nColumn ][ 2 ]
                  Else
                     aTemp[ nColumn ] := ".T."
                  Endif
               Else
                  If Len( ::EditControls[ nColumn ] ) >= 3 .AND. ValType( ::EditControls[ nColumn ][ 3 ] ) $ "CM"
                     aTemp[ nColumn ] := ::EditControls[ nColumn ][ 3 ]
                  Else
                     aTemp[ nColumn ] := ".F."
                  Endif
               Endif
            ElseIf ::EditControls[ nColumn ][ 1 ] == "IMAGELIST"
               aTemp[ nColumn ] := xValue
            ElseIf ::EditControls[ nColumn ][ 1 ] == "TEXTBOX"
               cMask := ""
               If Len( ::EditControls[ nColumn ] ) >= 4 .AND. ValType( ::EditControls[ nColumn ][ 4 ] ) $ "CM"
                  cMask := "@" + ::EditControls[ nColumn ][ 4 ] + " "
               EndIf
               If Len( ::EditControls[ nColumn ] ) >= 3 .AND. ValType( ::EditControls[ nColumn ][ 3 ] ) $ "CM"
                  cMask += ::EditControls[ nColumn ][ 3 ]
               EndIf
               If Empty( cMask )
                  If ::EditControls[ nColumn ][ 2 ] = "D"
                     aTemp[ nColumn ] := Transform( xValue, "@D" )
                  ElseIf ::EditControls[ nColumn ][ 2 ] = "N"
                     aTemp[ nColumn ] := LTrim( Str( xValue ) )
                  ElseIf ::EditControls[ nColumn ][ 2 ] = "L"
                     aTemp[ nColumn ] := If( xValue, ".T.", ".F." )
                  Else
                     aTemp[ nColumn ] := xValue
                  EndIf
               Else
                  aTemp[ nColumn ] := Transform( xValue, cMask )
               Endif
            EndIf
         Else
            aTemp[ nColumn ] := xValue
         EndIf
      Next
      ::SetItemColor( nItem, uForeColor, uBackColor, aTemp )
      ListViewSetItem( ::hWnd, uValue, nItem )
   ENDIF
   uValue := ListViewGetItem( ::hWnd, nItem , Len( ::aHeaders ) )
Return uValue

*-----------------------------------------------------------------------------*
METHOD SetItemColor( nItem, uForeColor, uBackColor, uExtra ) CLASS TGrid
*-----------------------------------------------------------------------------*
   ::GridForeColor := TGrid_CreateColorArray( ::GridForeColor, nItem, uForeColor, ::DynamicForeColor, LEN( ::aHeaders ), uExtra )
   ::GridBackColor := TGrid_CreateColorArray( ::GridBackColor, nItem, uBackColor, ::DynamicBackColor, LEN( ::aHeaders ), uExtra )
Return Nil

STATIC Function TGrid_CreateColorArray( aGrid, nItem, uColor, uDynamicColor, nWidth, uExtra )
Local aTemp, nLen
   IF ! ValType( uColor ) $ "ANB" .AND. ValType( uDynamicColor ) $ "ANB"
      uColor := uDynamicColor
   ENDIF
   IF ValType( uColor ) $ "ANB"
      IF ValType( aGrid ) == "A"
         IF Len( aGrid ) < nItem
            ASIZE( aGrid, nItem )
         ENDIF
      ELSE
         aGrid := ARRAY( nItem )
      ENDIF
      aTemp := ARRAY( nWidth )
      IF ValType( uColor ) == "A" .AND. LEN( uColor ) < nWidth
         nLen := LEN( uColor )
         uColor := ACLONE( uColor )
         IF VALTYPE( uDynamicColor ) $ "NB"
            ASIZE( uColor, nWidth )
            AFILL( uColor, uDynamicColor, nLen + 1 )
         ELSEIF VALTYPE( uDynamicColor ) == "A" .AND. LEN( uDynamicColor ) > nLen
            ASIZE( uColor, MIN( nWidth, LEN( uDynamicColor ) ) )
            AEVAL( uColor, { |x,i| uColor[ i ] := uDynamicColor[ i ], x }, nLen + 1 )
         ENDIF
      ENDIF
      AEVAL( aTemp, { |x,i| aTemp[ i ] := _OOHG_GetArrayItem( uColor, i, nItem, uExtra ), x } )
      aGrid[ nItem ] := aTemp
   ENDIF
Return aGrid

*-----------------------------------------------------------------------------*
METHOD Header( nColumn, uValue ) CLASS TGrid
*-----------------------------------------------------------------------------*
   IF VALTYPE( uValue ) $ "CM"
      ::aHeaders[ nColumn ] := uValue
      SETGRIDCOLOMNHEADER( ::hWnd, nColumn, uValue )
   ENDIF
Return ::aHeaders[ nColumn ]

*-----------------------------------------------------------------------------*
METHOD FontColor( uValue ) CLASS TGrid
*-----------------------------------------------------------------------------*
LOCAL nTmp
   IF VALTYPE( uValue ) == "A"
      ::Super:FontColor := uValue
      IF ::hWnd > 0
         ListView_SetTextColor( ::hWnd, ::aFontColor[1] , ::aFontColor[2] , ::aFontColor[3] )
         RedrawWindow( ::hWnd )
      ENDIF
   ENDIF
   IF ::hWnd > 0
      nTmp := ListView_GetTextColor( ::hWnd )
      ::aFontColor := { GetRed( nTmp ), GetGreen( nTmp ), GetBlue( nTmp ) }
   ENDIF
Return ::aFontColor

*-----------------------------------------------------------------------------*
METHOD BackColor( uValue ) CLASS TGrid
*-----------------------------------------------------------------------------*
LOCAL nTmp
   IF VALTYPE( uValue ) == "A"
      ::Super:BackColor := uValue
      IF ::hWnd > 0
         ListView_SetBkColor( ::hWnd, ::aBackColor[1] , ::aBackColor[2] , ::aBackColor[3] )
         ListView_SetTextBkColor( ::hWnd, ::aBackColor[1] , ::aBackColor[2] , ::aBackColor[3] )
         RedrawWindow( ::hWnd )
      ENDIF
   ENDIF
   IF ::hWnd > 0
      nTmp := ListView_GetBkColor( ::hWnd )
      ::aBackColor := { GetRed( nTmp ), GetGreen( nTmp ), GetBlue( nTmp ) }
   ENDIF
Return ::aBackColor

*-----------------------------------------------------------------------------*
METHOD SetRangeColor( uForeColor, uBackColor, nTop, nLeft, nBottom, nRight ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local nAux, nLong := ::ItemCount()
   IF ValType( nBottom ) != "N"
      nBottom := nTop
   ENDIF
   IF ValType( nRight ) != "N"
      nRight := nLeft
   ENDIF
   IF nTop > nBottom
      nAux := nBottom
      nBottom := nTop
      nTop := nAux
   ENDIF
   IF nLeft > nRight
      nAux := nRight
      nRight := nLeft
      nLeft := nAux
   ENDIF
   IF nBottom > nLong
      nBottom := nLong
   ENDIF
   IF nRight > Len( ::aHeaders )
      nRight := Len( ::aHeaders )
   ENDIF
   IF nTop <= nLong .AND. nLeft <= Len( ::aHeaders ) .AND. nTop >= 1 .AND. nLeft >= 1
      ::GridForeColor := TGrid_FillColorArea( ::GridForeColor, uForeColor, nTop, nLeft, nBottom, nRight )
      ::GridBackColor := TGrid_FillColorArea( ::GridBackColor, uBackColor, nTop, nLeft, nBottom, nRight )
   ENDIF
Return nil

STATIC Function TGrid_FillColorArea( aGrid, uColor, nTop, nLeft, nBottom, nRight )
Local nAux
   IF ValType( uColor ) $ "ANB"
      IF ValType( aGrid ) != "A"
         aGrid := ARRAY( nBottom )
      ELSEIF LEN( aGrid ) < nBottom
         ASIZE( aGrid, nBottom )
      ENDIF
      FOR nAux := nTop TO nBottom
         IF ValType( aGrid[ nAux ] ) != "A"
            aGrid[ nAux ] := ARRAY( nRight )
         ELSEIF LEN( aGrid[ nAux ] ) < nRight
            ASIZE( aGrid[ nAux ], nRight )
         ENDIF
         AEVAL( aGrid[ nAux ], { |x,i| aGrid[ nAux ][ i ] := _OOHG_GetArrayItem( uColor, i, nAux ), x }, nLeft, ( nRight - nLeft + 1 ) )
      NEXT
   ENDIF
Return aGrid

*-----------------------------------------------------------------------------*
METHOD ColumnWidth( nColumn, nWidth ) CLASS TGrid
*-----------------------------------------------------------------------------*
   IF ValType( nColumn ) == "N" .AND. nColumn >= 1 .AND. nColumn <= Len( ::aHeaders )
      If ValType( nWidth ) == "N"
         nWidth := ListView_SetColumnWidth( ::hWnd, nColumn - 1, nWidth )
      Else
         nWidth := ListView_GetColumnWidth( ::hWnd, nColumn - 1 )
      EndIf
      ::aWidths[ nColumn ] := nWidth
   Else
      nWidth := 0
   ENDIF
Return nWidth

*-----------------------------------------------------------------------------*
METHOD ColumnAutoFit( nColumn ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local nWidth
   IF ValType( nColumn ) == "N" .AND. nColumn >= 1 .AND. nColumn <= Len( ::aHeaders )
      nWidth := ListView_SetColumnWidth( ::hWnd, nColumn - 1, LVSCW_AUTOSIZE )
      ::aWidths[ nColumn ] := nWidth
   Else
      nWidth := 0
   ENDIF
Return nWidth

*-----------------------------------------------------------------------------*
METHOD ColumnAutoFitH( nColumn ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local nWidth
   IF ValType( nColumn ) == "N" .AND. nColumn >= 1 .AND. nColumn <= Len( ::aHeaders )
      nWidth := ListView_SetColumnWidth( ::hWnd, nColumn - 1, LVSCW_AUTOSIZE_USEHEADER )
      ::aWidths[ nColumn ] := nWidth
   Else
      nWidth := 0
   ENDIF
Return nWidth

*-----------------------------------------------------------------------------*
METHOD ColumnsAutoFit() CLASS TGrid
*-----------------------------------------------------------------------------*
Local nColumn, nWidth, nSum := 0
   FOR nColumn := 1 TO Len( ::aHeaders )
      nWidth := ListView_SetColumnWidth( ::hWnd, nColumn - 1, LVSCW_AUTOSIZE )
      ::aWidths[ nColumn ] := nWidth
      nSum += nWidth
   NEXT
Return nWidth

*-----------------------------------------------------------------------------*
METHOD ColumnsAutoFitH() CLASS TGrid
*-----------------------------------------------------------------------------*
Local nColumn, nWidth, nSum := 0
   FOR nColumn := 1 TO Len( ::aHeaders )
      nWidth := ListView_SetColumnWidth( ::hWnd, nColumn - 1, LVSCW_AUTOSIZE_USEHEADER )
      ::aWidths[ nColumn ] := nWidth
      nSum += nWidth
   NEXT
Return nWidth





CLASS TGridMulti FROM TGrid
   DATA Type      INIT "MULTIGRID" READONLY

   METHOD Define
   METHOD Value
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
               aRows, value, fontname, fontsize, tooltip, change, dblclick, ;
               aHeadClick, gotfocus, lostfocus, nogrid, aImage, aJust, ;
               break, HelpId, bold, italic, underline, strikeout, ownerdata, ;
               ondispinfo, itemcount, editable, backcolor, fontcolor, ;
               dynamicbackcolor, dynamicforecolor, aPicture, lRtl, inplace, ;
               editcontrols, readonly, valid, validmessages, editcell ) CLASS TGridMulti
*-----------------------------------------------------------------------------*
Local nStyle := 0
   ::Define2( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
              aRows, value, fontname, fontsize, tooltip, change, dblclick, ;
              aHeadClick, gotfocus, lostfocus, nogrid, aImage, aJust, ;
              break, HelpId, bold, italic, underline, strikeout, ownerdata, ;
              ondispinfo, itemcount, editable, backcolor, fontcolor, ;
              dynamicbackcolor, dynamicforecolor, aPicture, lRtl, nStyle, ;
              inplace, editcontrols, readonly, valid, validmessages, editcell )
Return Self

*-----------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TGridMulti
*-----------------------------------------------------------------------------*
   IF VALTYPE( uValue ) == "A"
      LISTVIEWSETMULTISEL( ::hWnd, uValue )
      If Len( uValue ) > 0
         ListView_EnsureVisible( ::hWnd, uValue[ 1 ] )
		EndIf
   ENDIF
RETURN ListViewGetMultiSel( ::hWnd )

*------------------------------------------------------------------------------*
Function _GetGridCellData( Self )
*------------------------------------------------------------------------------*
Local ThisItemRowIndex
Local ThisItemColIndex
Local ThisItemCellRow
Local ThisItemCellCol
Local ThisItemCellWidth
Local ThisItemCellHeight
Local r
Local xs
Local xd
Local aCellData

   r := ListView_HitTest ( ::hWnd, GetCursorRow() - GetWindowRow ( ::hWnd )  , GetCursorCol() - GetWindowCol ( ::hWnd ) )
	If r [2] == 1
      ListView_Scroll( ::hWnd,  -10000  , 0 )
      r := ListView_HitTest ( ::hWnd, GetCursorRow() - GetWindowRow ( ::hWnd )  , GetCursorCol() - GetWindowCol ( ::hWnd ) )
	Else
      r := LISTVIEW_GETSUBITEMRECT ( ::hWnd, r[1] - 1 , r[2] - 1 )

               	*	CellCol				CellWidth
      xs := ( ( ::ContainerCol + r [2] ) +( r[3] ))  -  ( ::ContainerCol + ::Width )

      If ListViewGetItemCount( ::hWnd ) >  ListViewGetCountPerPage( ::hWnd )
			xd := 20
		Else
			xd := 0
		EndIf

		If xs > -xd
         ListView_Scroll( ::hWnd,  xs + xd , 0 )
		Else
			If r [2] < 0
            ListView_Scroll( ::hWnd, r[2]   , 0 )
			EndIf
		EndIf

      r := ListView_HitTest ( ::hWnd, GetCursorRow() - GetWindowRow ( ::hWnd )  , GetCursorCol() - GetWindowCol ( ::hWnd ) )

	EndIf

	ThisItemRowIndex := r[1]
	ThisItemColIndex := r[2]

	If r [2] == 1
      r := LISTVIEW_GETITEMRECT ( ::hWnd, r[1] - 1 )
	Else
      r := LISTVIEW_GETSUBITEMRECT ( ::hWnd, r[1] - 1 , r[2] - 1 )
	EndIf

   ThisItemCellRow := ::ContainerRow + r [1]
   ThisItemCellCol := ::ContainerCol + r [2]
	ThisItemCellWidth := r[3]
	ThisItemCellHeight := r[4]

	aCellData := { ThisItemRowIndex , ThisItemColIndex , ThisItemCellRow , ThisItemCellCol , ThisItemCellWidth , ThisItemCellHeight }

Return aCellData