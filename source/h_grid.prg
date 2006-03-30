/*
 * $Id: h_grid.prg,v 1.38 2006-03-30 04:54:37 guerra000 Exp $
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

#include "oohg.ch"
#include "hbclass.ch"
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
   DATA aWhen            INIT {}
   DATA cRowEditTitle    INIT nil
   DATA lNested          INIT .F.

   METHOD Define
   METHOD Define2
   METHOD Value            SETGET

   METHOD Events
   METHOD Events_Enter
   METHOD Events_Notify

   METHOD AddColumn
   METHOD DeleteColumn

   METHOD Cell
   METHOD EditCell
   METHOD EditCell2
   METHOD EditAllCells
   METHOD EditItem
   METHOD EditItem2

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
               editcontrols, readonly, valid, validmessages, editcell, ;
               aWhenFields ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local nStyle := LVS_SINGLESEL

   ::Define2( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
              aRows, value, fontname, fontsize, tooltip, change, dblclick, ;
              aHeadClick, gotfocus, lostfocus, nogrid, aImage, aJust, ;
              break, HelpId, bold, italic, underline, strikeout, ownerdata, ;
              ondispinfo, itemcount, editable, backcolor, fontcolor, ;
              dynamicbackcolor, dynamicforecolor, aPicture, lRtl, nStyle, ;
              inplace, editcontrols, readonly, valid, validmessages, ;
              editcell, aWhenFields )
Return Self

*-----------------------------------------------------------------------------*
METHOD Define2( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
                aRows, value, fontname, fontsize, tooltip, change, dblclick, ;
                aHeadClick, gotfocus, lostfocus, nogrid, aImage, aJust, ;
                break, HelpId, bold, italic, underline, strikeout, ownerdata, ;
                ondispinfo, itemcount, editable, backcolor, fontcolor, ;
                dynamicbackcolor, dynamicforecolor, aPicture, lRtl, nStyle, ;
                inplace, editcontrols, readonly, valid, validmessages, ;
                editcell, aWhenFields ) CLASS TGrid
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

   ::SetSplitBoxInfo( Break, )
   ControlHandle := InitListView( ::ContainerhWnd, 0, x, y, w, h ,'',0, iif( nogrid, 0, 1 ) , ownerdata  , itemcount  , nStyle, ::lRtl )

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

   ::Register( ControlHandle, ControlName, HelpId, , ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )
   ::SizePos( y, x, w, h )

   ::FontColor := ::Super:FontColor
   ::BackColor := ::Super:BackColor

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
   ::aWhen := aWhenFields

   AEVAL( aRows, { |u| ::AddItem( u ) } )

   ::Value := value

Return Self

*-----------------------------------------------------------------------------*
METHOD EditItem() CLASS TGrid
*-----------------------------------------------------------------------------*
Local nItem, aItems, aEditControls, nColumn
   nItem := ::Value
   If nItem == 0
      Return NIL
   EndIf
   aItems := ::Item( nItem )

   aEditControls := ARRAY( Len( aItems ) )
   For nColumn := 1 To Len( aEditControls )
      aEditControls[ nColumn ] := GetEditControlFromArray( nil, ::EditControls, nColumn, Self )
      If ValType( aEditControls[ nColumn ] ) != "O"
         // Check for imagelist
         If ValType( aItems[ nColumn ] ) == "N"
            If ValType( ::Picture[ nColumn ] ) == "L" .AND. ::Picture[ nColumn ]
               aEditControls[ nColumn ] := TGridControlImageList():New( Self )
            ElseIf ValType( ListViewGetItem( ::hWnd, nItem, Len( ::aHeaders ) )[ nColumn ] ) == "N"
               aEditControls[ nColumn ] := TGridControlImageList():New( Self )
            EndIf
         Endif
      Endif
   Next

   aItems := ::EditItem2( nItem, aItems, aEditControls,, if( ValType( ::cRowEditTitle ) $ "CM", ::cRowEditTitle, _OOHG_Messages( 1, 5 ) ) )
   If ! Empty( aItems )
      ::Item( nItem, ASIZE( aItems, LEN( ::aHeaders ) ) )
      _SetThisCellInfo( ::hWnd, nItem, 1 )
      _OOHG_Eval( ::OnEditCell, nItem, 0 )
      _ClearThisCellInfo()
   EndIf
Return NIL

*-----------------------------------------------------------------------------*
METHOD EditItem2( nItem, aItems, aEditControls, aMemVars, cTitle ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local l, actpos := {0,0,0,0}, GCol, IRow, i, oWnd, nWidth, nMaxHigh, oMain
Local oCtrl, aEditControls2, nRow, lSplitWindow, nControlsMaxHeight

   If ::lNested
      Return {}
   EndIf

   If ValType( nItem ) != "N"
      nItem := LISTVIEW_GETFIRSTITEM( ::hWnd )
   EndIf
   If nItem == 0 .OR. nItem > ::ItemCount
      Return {}
   EndIf

   ::lNested := .T.

   If ValType( aItems ) != "A" .OR. Len( aItems ) == 0
      aItems := ::Item( nItem )
   EndIf
   aItems := ACLONE( aItems )
   If Len( aItems ) > Len( ::aHeaders )
       ASIZE( aItems, Len( ::aHeaders ) )
   EndIf

   l := Len( aItems )

   IRow := ListViewGetItemRow( ::hWnd, nItem )

   GetWindowRect( ::hWnd, actpos )

   _SetThisCellInfo( ::hWnd, nItem, 1 )

   nControlsMaxHeight := GetDesktopHeight() - 130

   nWidth := 140
   nRow := 0
   aEditControls2 := ARRAY( l )
   For i := 1 To l
      oCtrl := GetEditControlFromArray( nil, aEditControls, i, Self )
      oCtrl := GetEditControlFromArray( oCtrl, ::EditControls, i, Self )
      If ValType( oCtrl ) != "O"
         If ValType( ::Picture ) == "A" .AND. Len( ::Picture ) >= i .AND. ValType( ::Picture[ i ] ) $ "CM"
            oCtrl := TGridControlTextBox():New( ::Picture[ i ],, "C" )
         Else
            oCtrl := TGridControlTextBox():New()
         EndIf
      Endif
      aEditControls2[ i ] := oCtrl
      nWidth := MAX( nWidth, oCtrl:nDefWidth )
      nRow += oCtrl:nDefHeight + 6
   Next

   lSplitWindow := ( nRow > nControlsMaxHeight )

   nWidth += If( lSplitWindow, 170, 140 )

   GCol := actpos[ 1 ] + ( ( ( actpos[ 3 ] - actpos[ 1 ] ) - nWidth ) / 2 )
   GCol := MAX( MIN( GCol, ( GetSystemMetrics( SM_CXFULLSCREEN ) - nWidth ) ), 0 )

   nMaxHigh := Min( nControlsMaxHeight, nRow ) + 70 + GetTitleHeight()
   IRow := MAX( MIN( IRow, ( GetSystemMetrics( SM_CYFULLSCREEN ) - nMaxHigh ) ), 0 )

   If lSplitWindow
      DEFINE WINDOW 0 OBJ oMain AT IRow,GCol ;
         WIDTH nWidth HEIGHT nMaxHigh ;
         TITLE cTitle MODAL NOSIZE

      DEFINE SPLITBOX
         DEFINE WINDOW 0 OBJ oWnd;
            WIDTH nWidth ;
            HEIGHT nControlsMaxHeight ;
            VIRTUAL HEIGHT nRow + 20 ;
				SPLITCHILD NOCAPTION FONT 'Arial' SIZE 10 BREAK FOCUSED
   Else
      DEFINE WINDOW 0 OBJ oWnd AT IRow,GCol ;
         WIDTH nWidth HEIGHT nMaxHigh ;
         TITLE cTitle MODAL NOSIZE

      oMain := oWnd
   EndIf

   nRow := 10

   For i := 1 to l
      @ nRow + 3, 10 LABEL 0 PARENT ( oWnd ) VALUE Alltrim( ::aHeaders[ i ] ) + ":"
      aEditControls2[ i ]:CreateControl( aItems[ i ], oWnd:Name, nRow, 120, aEditControls2[ i ]:nDefWidth, aEditControls2[ i ]:nDefHeight )
      nRow += aEditControls2[ i ]:nDefHeight + 6
      If ValType( aMemVars ) == "A" .AND. Len( aMemVars ) >= i
         aEditControls2[ i ]:cMemVar := aMemVars[ i ]
      EndIf
      If ValType( ::Valid ) == "A" .AND. Len( ::Valid ) >= i
         aEditControls2[ i ]:bValid := ::Valid[ i ]
      EndIf
      If ValType( ::ValidMessages ) == "A" .AND. Len( ::ValidMessages ) >= i
         aEditControls2[ i ]:cValidMessage := ::ValidMessages[ i ]
      EndIf

      If ValType( ::aWhen ) == "A" .AND. Len( ::aWhen ) >= i
         aEditControls2[ i ]:bWhen := ::aWhen[ i ]
      EndIf
      If ValType( ::ReadOnly ) == "A" .AND. Len( ::ReadOnly ) >= i .AND. ValType( ::ReadOnly[ i ] ) == "L" .AND. ::ReadOnly[ i ]
         aEditControls2[ i ]:Enabled := .F.
         aEditControls2[ i ]:bWhen := { || .F. }
      EndIf

   Next

   If lSplitWindow
      END WINDOW

      DEFINE WINDOW 0 OBJ oWnd ;
         WIDTH nWidth ;
         HEIGHT 50 ;
         SPLITCHILD NOCAPTION FONT 'Arial' SIZE 10 BREAK

      nRow := 10
   Else
      nRow += 10
   Endif

   @ nRow,  25 BUTTON 0 PARENT ( oWnd ) CAPTION _OOHG_Messages( 1, 6 ) ;
         ACTION ( TGrid_EditItem_Check( aEditControls2, aItems, oMain ) )

   @ nRow, 145 BUTTON 0 PARENT ( oWnd ) CAPTION _OOHG_Messages( 1, 7 ) ;
         ACTION ( aItems := {}, oMain:Release() )

	END WINDOW

   If lSplitWindow
      END SPLITBOX
      END WINDOW
   Endif

   AEVAL( aEditControls2, { |o| o:OnLostFocus := { || TGrid_EditItem_When( aEditControls2 ) } } )

   TGrid_EditItem_When( aEditControls2 )

   aEditControls2[ 1 ]:SetFocus()

   oMain:Activate()

   _ClearThisCellInfo()

   ::SetFocus()

   ::lNested := .F.

Return aItems

Static Function TGrid_EditItem_When( aEditControls )
Local nItem, lEnabled, aValues
   // Save values
   aValues := ARRAY( Len( aEditControls ) )
   For nItem := 1 To Len( aEditControls )
      aValues[ nItem ] := aEditControls[ nItem ]:ControlValue
      If ValType( aEditControls[ nItem ]:cMemVar ) $ "CM" .AND. ! Empty( aEditControls[ nItem ]:cMemVar )
         &( aEditControls[ nItem ]:cMemVar ) := aValues[ nItem ]
      EndIf
   Next

   // WHEN clause
   For nItem := 1 To Len( aEditControls )
      lEnabled := _OOHG_EVAL( aEditControls[ nItem ]:bWhen )
      If ValType( lEnabled ) == "L" .AND. ! lEnabled
         aEditControls[ nItem ]:Enabled := .F.
      Else
         aEditControls[ nItem ]:Enabled := .T.
      EndIf
   Next
Return aValues

Static Procedure TGrid_EditItem_Check( aEditControls, aItems, oWnd )
Local lRet, nItem, aValues, lValid
   // Save values
   aValues := TGrid_EditItem_When( aEditControls )

   // Check VALID clauses
   lRet := .T.
   For nItem := 1 To Len( aEditControls )
      lValid := _OOHG_Eval( aEditControls[ nItem ]:bValid, aValues[ nItem ] )
      If ValType( lValid ) == "L" .AND. ! lValid
         lRet := .F.
         If ValType( aEditControls[ nItem ]:cValidMessage ) $ "CM" .AND. ! Empty( aEditControls[ nItem ]:cValidMessage )
            MsgExclamation( aEditControls[ nItem ]:cValidMessage )
         Else
            MsgExclamation( _OOHG_Messages( 3, 11 ) )
         Endif
         aEditControls[ nItem ]:SetFocus()
      EndIf
   Next

   // If all controls are valid, save values into "aItems"
   If lRet
      AEVAL( aValues, { |u,i| aItems[ i ] := u } )
      oWnd:Release()
   Endif
Return

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
   TGrid_AddColumnColor( @uGridColor, nColIndex, uForeColor, @uDynamicColor, nColumns, ::ItemCount(), lNoDelete, ::hWnd )
   ::GridForeColor := uGridColor
   ::DynamicForeColor := uDynamicColor

   // Update Background Color
   uGridColor := ::GridBackColor
   uDynamicColor := ::DynamicBackColor
   TGrid_AddColumnColor( @uGridColor, nColIndex, uBackColor, @uDynamicColor, nColumns, ::ItemCount(), lNoDelete, ::hWnd )
   ::GridBackColor := uGridColor
   ::DynamicBackColor := uDynamicColor

	// Call C-Level Routine
   ListView_AddColumn( ::hWnd, nColIndex, nWidth, cCaption, nJustify, lNoDelete )

Return nil

STATIC Function TGrid_AddColumnColor( aGrid, nColumn, uColor, uDynamicColor, nWidth, nItemCount, lNoDelete, hWnd )
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
         _SetThisCellInfo( hWnd, x, nColumn )
         aGrid[ x ][ nColumn ] := _OOHG_GetArrayItem( uDynamicColor, nColumn, x )
         _ClearThisCellInfo()
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
      aItem := ::Item( nRow )
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
Local lRet
   IF ValType( nRow ) != "N"
      nRow := LISTVIEW_GETFIRSTITEM( ::hWnd )
   ENDIF
   IF ValType( nCol ) != "N"
      nCol := 1
   ENDIF
   If nRow < 1 .OR. nRow > ::ItemCount() .OR. nCol < 1 .OR. nCol > Len( ::aHeaders )
      // Cell out of range
      Return .F.
   EndIf

   If ValType( uOldValue ) == "U"
      uOldValue := ::Cell( nRow, nCol )
   EndIf

   EditControl := GetEditControlFromArray( EditControl, ::EditControls, nCol, Self )
   If ValType( EditControl ) != "O"
      // If EditControl is not specified, check for imagelist
      If ValType( uOldValue ) == "N"
         If ValType( ::Picture[ nCol ] ) == "L" .AND. ::Picture[ nCol ]
            EditControl := TGridControlImageList():New( Self )
         ElseIf ValType( ListViewGetItem( ::hWnd, nRow, Len( ::aHeaders ) )[ nCol ] ) == "N"
            EditControl := TGridControlImageList():New( Self )
         EndIf
      Endif
   Endif

   lRet := ::EditCell2( @nRow, @nCol, EditControl, uOldValue, @uValue, cMemVar )
   IF lRet
      IF ValType( uValue ) $ "CM"
         uValue := Trim( uValue )
      ENDIF
      ::Cell( nRow, nCol, uValue )
      _SetThisCellInfo( ::hWnd, nRow, nCol )
      _OOHG_Eval( ::OnEditCell, nRow, nCol )
      _ClearThisCellInfo()
   ENDIF
Return lRet

*-----------------------------------------------------------------------------*
METHOD EditCell2( nRow, nCol, EditControl, uOldValue, uValue, cMemVar ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local r, r2, lRet := .F.
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
      EditControl := GetEditControlFromArray( EditControl, ::EditControls, nCol, Self )
      If ValType( EditControl ) == "O"
         // EditControl specified
      ElseIf ValType( ::Picture[ nCol ] ) == "C"
         // Picture-based
         EditControl := TGridControlTextBox():New( ::Picture[ nCol ],, ValType( uValue ) )
      Else
         // Checks according to data type
         EditControl := GridControlObjectByType( uValue )
      EndIf

      If ValType( EditControl ) != "O"
         MsgExclamation( "ooHG can't determine cell type for INPLACE edit." )
      Else
         r2 := { 0, 0, 0, 0 }
         GetWindowRect( ::hWnd, r2 )
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
         r[ 1 ] += r2[ 2 ] + 2
         r[ 2 ] += r2[ 1 ] + 3

         _SetThisCellInfo( ::hWnd, nRow, nCol )

         r[ 4 ] += 6

         EditControl:cMemVar := cMemVar
         If ValType( ::Valid ) == "A" .AND. Len( ::Valid ) >= nCol
            EditControl:bValid := ::Valid[ nCol ]
         EndIf
         If ValType( ::ValidMessages ) == "A" .AND. Len( ::ValidMessages ) >= nCol
            EditControl:cValidMessage := ::ValidMessages[ nCol ]
         EndIf
         lRet := EditControl:CreateWindow( uValue, r[ 1 ], r[ 2 ], r[ 3 ], r[ 4 ], ::FontName, ::FontSize )
         If lRet
            uValue := EditControl:Value
         Else
            ::SetFocus()
         EndIf

         _OOHG_ThisType := ''
         _ClearThisCellInfo()

      EndIf
   EndIf
Return lRet

*-----------------------------------------------------------------------------*
METHOD EditAllCells( nRow, nCol ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local lRet
   IF ValType( nRow ) != "N"
      nRow := LISTVIEW_GETFIRSTITEM( ::hWnd )
   ENDIF
   IF ValType( nCol ) != "N"
      nCol := 1
   ENDIF
   If nRow < 1 .OR. nRow > ::ItemCount() .OR. nCol < 1 .OR. nCol > Len( ::aHeaders )
      // Cell out of range
      Return .F.
   EndIf

   lRet := .T.
   Do While nCol <= Len( ::aHeaders ) .AND. lRet
      If VALTYPE( ::ReadOnly ) == "A" .AND. Len( ::ReadOnly ) >= nCol .AND. ValType( ::ReadOnly[ nCol ] ) == "L" .AND. ::ReadOnly[ nCol ]
         // Read only column
      Else
         lRet := ::EditCell( nRow, nCol )
      EndIf
      nCol++
   EndDo
   If lRet // .OR. nCol > Len( ::aHeaders )
      ListView_Scroll( ::hWnd, - _OOHG_GridArrayWidths( ::hWnd, ::aWidths ), 0 )
   Endif
Return lRet

#pragma BEGINDUMP
#define s_Super s_TControl
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windows.h>
#include <commctrl.h>
#include "../include/oohg.h"

// -----------------------------------------------------------------------------
HB_FUNC_STATIC( TGRID_EVENTS )   // METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TGrid
// -----------------------------------------------------------------------------
{
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
      ::EditAllCells()
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
Local lvc, aCellData, _ThisQueryTemp, lWhen

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

         If ValType( ::ReadOnly ) == "A" .AND. Len( ::ReadOnly ) >= _OOHG_ThisItemColIndex .AND. ValType( ::ReadOnly[ _OOHG_ThisItemColIndex ] ) == "L" .AND. ::ReadOnly[ _OOHG_ThisItemColIndex ]
            // Cell is readonly
         ElseIf ValType( ::aWhen ) == "A" .AND. Len( ::aWhen ) >= _OOHG_ThisItemColIndex .AND. ValType( ( lWhen := _OOHG_EVAL( ::aWhen[ _OOHG_ThisItemColIndex ] ) ) ) == "L" .AND. ! lWhen
            // Cell denies WHEN clause
         Else
            ::EditCell( _OOHG_ThisItemRowIndex, _OOHG_ThisItemColIndex )
         EndIf

      ElseIf ::AllowEdit

         ::EditItem()

      ElseIf ValType( ::OnDblClick ) == "B"

         Eval( ::OnDblClick )

      EndIf

      _ClearThisCellInfo()
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

   aRow := TGrid_SetArray( Self, aRow )
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
Local nColumn, aTemp, oEditControl
   IF PCOUNT() > 1
      aTemp := TGrid_SetArray( Self, uValue )
      ::SetItemColor( nItem, uForeColor, uBackColor, uValue )
      ListViewSetItem( ::hWnd, aTemp, nItem )
   ENDIF
   uValue := ListViewGetItem( ::hWnd, nItem , Len( ::aHeaders ) )
   If ValType( ::EditControls ) == "A"
      For nColumn := 1 To Len( uValue )
         oEditControl := GetEditControlFromArray( nil, ::EditControls, nColumn, Self )
         If ValType( oEditControl ) == "O"
            uValue[ nColumn ] := oEditControl:Str2Val( uValue[ nColumn ] )
         EndIf
      Next
   EndIf
Return uValue

FUNCTION TGrid_SetArray( Self, uValue )
Local aTemp, nColumn, xValue, oEditControl
   aTemp := Array( Len( uValue ) )
   For nColumn := 1 To Len( uValue )
      xValue := uValue[ nColumn ]
      oEditControl := GetEditControlFromArray( nil, ::EditControls, nColumn, Self )
      If ValType( oEditControl ) == "O"
         aTemp[ nColumn ] := oEditControl:GridValue( xValue )
      ElseIf ValType( ::Picture[ nColumn ] ) $ "CM"
         aTemp[ nColumn ] := Trim( Transform( xValue, ::Picture[ nColumn ] ) )
      Else
         aTemp[ nColumn ] := xValue
      EndIf
   Next
RETURN aTemp

*-----------------------------------------------------------------------------*
METHOD SetItemColor( nItem, uForeColor, uBackColor, uExtra ) CLASS TGrid
*-----------------------------------------------------------------------------*
   ::GridForeColor := TGrid_CreateColorArray( ::GridForeColor, nItem, uForeColor, ::DynamicForeColor, LEN( ::aHeaders ), uExtra, ::hWnd )
   ::GridBackColor := TGrid_CreateColorArray( ::GridBackColor, nItem, uBackColor, ::DynamicBackColor, LEN( ::aHeaders ), uExtra, ::hWnd )
Return Nil

STATIC Function TGrid_CreateColorArray( aGrid, nItem, uColor, uDynamicColor, nWidth, uExtra, hWnd )
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
      AEVAL( aTemp, { |x,i| _SetThisCellInfo( hWnd, nItem, i ), aTemp[ i ] := _OOHG_GetArrayItem( uColor, i, nItem, uExtra ), x } )
      _ClearThisCellInfo()
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

#pragma BEGINDUMP
HB_FUNC_STATIC( TGRID_FONTCOLOR )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &oSelf->lFontColor, ( hb_pcount() >= 1 ) ) )
   {
      if( oSelf->hWnd )
      {
         if( oSelf->lFontColor != -1 )
         {
            ListView_SetTextColor( oSelf->hWnd, oSelf->lFontColor );
         }
         else
         {
            ListView_SetTextColor( oSelf->hWnd, GetSysColor( COLOR_WINDOWTEXT ) );
         }
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   // Return value was set in _OOHG_DetermineColorReturn()
}

HB_FUNC_STATIC( TGRID_BACKCOLOR )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &oSelf->lBackColor, ( hb_pcount() >= 1 ) ) )
   if( hb_pcount() >= 1 )
   {
      if( oSelf->hWnd )
      {
         if( oSelf->lBackColor != -1 )
         {
            ListView_SetBkColor( oSelf->hWnd, oSelf->lBackColor );
         }
         else
         {
            ListView_SetBkColor( oSelf->hWnd, GetSysColor( COLOR_WINDOW ) );
         }
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   // Return value was set in _OOHG_DetermineColorReturn()
}
#pragma ENDDUMP

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
      ::GridForeColor := TGrid_FillColorArea( ::GridForeColor, uForeColor, nTop, nLeft, nBottom, nRight, ::hWnd )
      ::GridBackColor := TGrid_FillColorArea( ::GridBackColor, uBackColor, nTop, nLeft, nBottom, nRight, ::hWnd )
   ENDIF
Return nil

STATIC Function TGrid_FillColorArea( aGrid, uColor, nTop, nLeft, nBottom, nRight, hWnd )
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
         AEVAL( aGrid[ nAux ], { |x,i| _SetThisCellInfo( hWnd, nAux, i ), aGrid[ nAux ][ i ] := _OOHG_GetArrayItem( uColor, i, nAux ), x }, nLeft, ( nRight - nLeft + 1 ) )
         _ClearThisCellInfo()
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
               editcontrols, readonly, valid, validmessages, editcell, ;
               aWhenFields ) CLASS TGridMulti
*-----------------------------------------------------------------------------*
Local nStyle := 0
   ::Define2( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
              aRows, value, fontname, fontsize, tooltip, change, dblclick, ;
              aHeadClick, gotfocus, lostfocus, nogrid, aImage, aJust, ;
              break, HelpId, bold, italic, underline, strikeout, ownerdata, ;
              ondispinfo, itemcount, editable, backcolor, fontcolor, ;
              dynamicbackcolor, dynamicforecolor, aPicture, lRtl, nStyle, ;
              inplace, editcontrols, readonly, valid, validmessages, ;
              editcell, aWhenFields )
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

*------------------------------------------------------------------------------*
Procedure _SetThisCellInfo( hWnd, nRow, nCol )
*------------------------------------------------------------------------------*
Local aControlRect, aCellRect
   aControlRect := { 0, 0, 0, 0 }
   GetWindowRect( hWnd, aControlRect )
   aCellRect := LISTVIEW_GETSUBITEMRECT( hWnd, nRow - 1, nCol - 1 )
   aCellRect[ 3 ] := ListView_GetColumnWidth( hWnd, nCol - 1 )

   _OOHG_ThisItemRowIndex   := nRow
   _OOHG_ThisItemColIndex   := nCol
   _OOHG_ThisItemCellRow    := aCellRect[ 1 ] + aControlRect[ 2 ] + 2
   _OOHG_ThisItemCellCol    := aCellRect[ 2 ] + aControlRect[ 1 ] + 3
   _OOHG_ThisItemCellWidth  := aCellRect[ 3 ]
   _OOHG_ThisItemCellHeight := aCellRect[ 4 ]
Return

*------------------------------------------------------------------------------*
Procedure _ClearThisCellInfo()
*------------------------------------------------------------------------------*
   _OOHG_ThisItemRowIndex   := 0
   _OOHG_ThisItemColIndex   := 0
   _OOHG_ThisItemCellRow    := 0
   _OOHG_ThisItemCellCol    := 0
   _OOHG_ThisItemCellWidth  := 0
   _OOHG_ThisItemCellHeight := 0
Return





*-----------------------------------------------------------------------------*
FUNCTION GridControlObject( aEditControl, oGrid )
*-----------------------------------------------------------------------------*
Local oGridControl, aEdit2
   oGridControl := nil
   If ValType( aEditControl ) == "A" .AND. Len( aEditControl ) >= 1 .AND. ValType( aEditControl[ 1 ] ) $ "CM"
      aEdit2 := ACLONE( aEditControl )
      ASIZE( aEdit2, 4 )
      Do Case
         Case aEditControl[ 1 ] == "MEMO"
            oGridControl := TGridControlMemo():New()
         Case aEditControl[ 1 ] == "DATEPICKER"
            oGridControl := TGridControlDatePicker():New( aEdit2[ 2 ] )
         Case aEditControl[ 1 ] == "COMBOBOX"
            oGridControl := TGridControlComboBox():New( aEdit2[ 2 ], oGrid )
         Case aEditControl[ 1 ] == "SPINNER"
            oGridControl := TGridControlSpinner():New( aEdit2[ 2 ], aEdit2[ 3 ] )
         Case aEditControl[ 1 ] == "CHECKBOX"
            oGridControl := TGridControlCheckBox():New( aEdit2[ 2 ], aEdit2[ 3 ] )
         Case aEditControl[ 1 ] == "TEXTBOX"
            oGridControl := TGridControlTextBox():New( aEdit2[ 3 ], aEdit2[ 4 ], aEdit2[ 2 ] )
         Case aEditControl[ 1 ] == "IMAGELIST"
            oGridControl := TGridControlDatePicker():New( oGrid )
         Case aEditControl[ 1 ] == "LCOMBOBOX"
            oGridControl := TGridControlLComboBox():New( aEdit2[ 2 ], aEdit2[ 3 ] )
      EndCase
   EndIf
Return oGridControl

*-----------------------------------------------------------------------------*
FUNCTION GridControlObjectByType( uValue )
*-----------------------------------------------------------------------------*
Local oGridControl := NIL, cMask, nPos
   Do Case
      Case ValType( uValue ) == "N"
         cMask := Str( uValue )
         cMask := Replicate( "9", Len( cMask ) )
         nPos := At( ".", cMask )
         If nPos != 0
            cMask := Left( cMask, nPos - 1 ) + "." + SubStr( cMask, nPos + 1 )
         EndIf
         oGridControl := TGridControlTextBox():New( cMask,, "N" )
      Case ValType( uValue ) == "L"
         // oGridControl := TGridControlCheckBox():New( ".T.", ".F." )
         oGridControl := TGridControlLComboBox():New( ".T.", ".F." )
      Case ValType( uValue ) == "D"
         // oGridControl := TGridControlDatePicker():New( .T. )
         oGridControl := TGridControlTextBox():New( "@D",, "D" )
      Case ValType( uValue ) == "M"
         oGridControl := TGridControlMemo():New()
      Case ValType( uValue ) == "C"
         oGridControl := TGridControlTextBox():New( ,, "C" )
      OtherWise
         // Non-implemented data type!!!
   EndCase
Return oGridControl

Function GetEditControlFromArray( oEditControl, aEditControls, nColumn, oGrid )
   If ValType( oEditControl ) == "A"
      oEditControl := GridControlObject( oEditControl, oGrid )
   EndIf
   If ValType( oEditControl ) != "O" .AND. ValType( aEditControls ) == "A" .AND. ValType( nColumn ) == "N" .AND. nColumn >= 1 .AND. Len( aEditControls ) >= nColumn
      oEditControl := aEditControls[ nColumn ]
      If ValType( oEditControl ) == "A"
         oEditControl := GridControlObject( oEditControl, oGrid )
      EndIf
   EndIf
   If ValType( oEditControl ) != "O"
      oEditControl := nil
   EndIf
Return oEditControl

*-----------------------------------------------------------------------------*
CLASS TGridControl
*-----------------------------------------------------------------------------*
   DATA oControl      INIT nil
   DATA oWindow       INIT nil
   DATA Value         INIT nil
   DATA bWhen         INIT nil
   DATA cMemVar       INIT nil
   DATA bValid        INIT nil
   DATA cValidMessage INIT nil
   DATA nDefWidth     INIT 140
   DATA nDefHeight    INIT 24

   METHOD New               BLOCK { |Self| Self }
   METHOD CreateWindow
   METHOD Valid
//   METHOD CreateControl
   METHOD Str2Val(uValue)   BLOCK { |Self,uValue| Empty( Self ), uValue }
   METHOD GridValue(uValue) BLOCK { |Self,uValue| Empty( Self ), If( ValType( uValue ) $ "CM", Trim( uValue ), uValue ) }
   METHOD ControlValue      BLOCK { |Self| ::oControl:Value }
   METHOD SetFocus          BLOCK { |Self| ::oControl:SetFocus() }
   METHOD Enabled           SETGET
   METHOD OnLostFocus       SETGET
ENDCLASS

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize ) CLASS TGridControl
Local lRet := .F.
   DEFINE WINDOW 0 OBJ ::oWindow ;
          AT nRow, nCol WIDTH nWidth HEIGHT nHeight ;
          MODAL NOSIZE NOCAPTION ;
          FONT cFontName SIZE nFontSize

          ON KEY RETURN OF &( ::oWindow:Name ) ACTION ( lRet := ::Valid() )
          ON KEY ESCAPE OF &( ::oWindow:Name ) ACTION ( ::oWindow:Release() )

          ::CreateControl( uValue, ::oWindow:Name, 0, 0, nWidth, nHeight )
          ::Value := ::ControlValue

   END WINDOW
   ::oControl:SetFocus()
   ::oWindow:Activate()
Return lRet

METHOD Valid() CLASS TGridControl
Local lValid, uValue

   uValue := ::ControlValue

   If ValType( ::cMemVar ) $ "CM" .AND. ! Empty( ::cMemVar )
      &( ::cMemVar ) := uValue
   EndIf

   lValid := _OOHG_Eval( ::bValid, uValue )
   If ValType( lValid ) != "L"
      lValid := .T.
   EndIf

   If lValid
      ::Value := uValue
      ::oWindow:Release()
   Else
      If ValType( ::cValidMessage ) $ "CM" .AND. ! Empty( ::cValidMessage )
         MsgExclamation( ::cValidMessage )
      Else
         MsgExclamation( _OOHG_Messages( 3, 11 ) )
      Endif
      ::oControl:SetFocus()
   Endif
Return lValid

METHOD Enabled( uValue ) CLASS TGridControl
Return ( ::oControl:Enabled := uValue )

METHOD OnLostFocus( uValue ) CLASS TGridControl
   If PCOUNT() >= 1
      ::oControl:OnLostFocus := uValue
   EndIf
Return ::oControl:OnLostFocus

*-----------------------------------------------------------------------------*
CLASS TGridControlTextBox FROM TGridControl
*-----------------------------------------------------------------------------*
   DATA cMask INIT ""
   DATA cType INIT ""

   METHOD New
   METHOD CreateControl
   METHOD Str2Val
   METHOD GridValue
ENDCLASS

METHOD New( cPicture, cFunction, cType ) CLASS TGridControlTextBox
   ::cMask := ""
   IF ValType( cPicture ) $ "CM" .AND. ! Empty( cPicture )
      ::cMask := cPicture
   ENDIF
   IF ValType( cFunction ) $ "CM" .AND. ! Empty( cFunction )
      ::cMask := "@" + cFunction + " " + ::cMask
   ENDIF

   If ValType( cType ) $ "CM" .AND. ! Empty( cType )
      cType := UPPER( LEFT( ALLTRIM( cType ), 1 ) )
      ::cType := IF( ( ! cType $ "CDNL" ), "C", cType )
   Else
      ::cType := "C"
   EndIf
   If ::cType == "D" .AND. Empty( ::cMask )
      ::cMask := "@D"
   ElseIf ::cType == "N" .AND. Empty( ::cMask )
****      ::cMask := "@D"
   ElseIf ::cType == "L" .AND. Empty( ::cMask )
      ::cMask := "L"
   EndIf
Return Self

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlTextBox
   If Valtype( uValue ) == "C"
      uValue := ::Str2Val( uValue )
   EndIf
   If ! Empty( ::cMask )
      @ nRow,nCol TEXTBOX 0 OBJ ::oControl PARENT &cWindow WIDTH nWidth HEIGHT nHeight VALUE uValue INPUTMASK ::cMask
   ElseIf ValType( uValue ) == "N"
      @ nRow,nCol TEXTBOX 0 OBJ ::oControl PARENT &cWindow WIDTH nWidth HEIGHT nHeight VALUE uValue NUMERIC
   ElseIf ValType( uValue ) == "D"
      @ nRow,nCol TEXTBOX 0 OBJ ::oControl PARENT &cWindow WIDTH nWidth HEIGHT nHeight VALUE uValue DATE
   Else
      @ nRow,nCol TEXTBOX 0 OBJ ::oControl PARENT &cWindow WIDTH nWidth HEIGHT nHeight VALUE uValue
   EndIf
Return ::oControl

METHOD Str2Val( uValue ) CLASS TGridControlTextBox
   Do Case
      Case ::cType == "D"
         uValue := CTOD( uValue )
      Case ::cType == "L"
         uValue := ( PADL( uValue, 1 ) $ "TtYy" )
      Case ::cType == "N"
         uValue := Val( StrTran( _OOHG_UnTransform( uValue, ::cMask, ::cType ), " ", "" ) )
      Otherwise
         If ! Empty( ::cMask )
            uValue := _OOHG_UnTransform( uValue, ::cMask, ::cType )
         Endif
   EndCase
Return uValue

METHOD GridValue( uValue ) CLASS TGridControlTextBox
   If Empty( ::cMask )
      If ::cType == "D"
         uValue := DTOC( uValue )
      ElseIf ::cType == "N"
         uValue := LTrim( Str( uValue ) )
      ElseIf ::cType == "L"
         uValue := If( uValue, "T", "F" )
      ElseIf ::cType $ "CM"
         uValue := Trim( uValue )
      EndIf
   Else
      uValue := Trim( Transform( uValue, ::cMask ) )
   Endif
Return uValue

*-----------------------------------------------------------------------------*
CLASS TGridControlMemo FROM TGridControl
*-----------------------------------------------------------------------------*
   DATA nDefHeight    INIT 84

   METHOD CreateWindow
   METHOD CreateControl
ENDCLASS

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize ) CLASS TGridControlMemo
Local lRet := .F.
   Empty( nWidth )
   Empty( nHeight )
   Empty( cFontName )
   Empty( nFontSize )
   DEFINE WINDOW 0 OBJ ::oWindow ;
          AT nRow, nCol WIDTH 350 HEIGHT GetTitleHeight() + 265 TITLE "Edit Memo" ;
          MODAL NOSIZE

          ON KEY ESCAPE OF &( ::oWindow:Name ) ACTION ( ::oWindow:Release() )

          @ 07,10 LABEL 0    PARENT &( ::oWindow:Name ) VALUE ""   WIDTH 280
          ::CreateControl( uValue, ::oWindow:Name, 30, 10, 320, 176 )
          ::Value := ::ControlValue
          @ 217,120 BUTTON 0 PARENT &( ::oWindow:Name ) CAPTION _OOHG_Messages( 1, 6 ) ACTION ( lRet := ::Valid() )
          @ 217,230 BUTTON 0 PARENT &( ::oWindow:Name ) CAPTION _OOHG_Messages( 1, 7 ) ACTION ( ::oWindow:Release() )

   END WINDOW
   ::oWindow:Center()
   ::oControl:SetFocus()
   ::oWindow:Activate()
Return lRet

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlMemo
   @ nRow,nCol EDITBOX 0 OBJ ::oControl PARENT &cWindow VALUE STRTRAN( uValue, chr(141), ' ' ) HEIGHT nHeight WIDTH nWidth
Return ::oControl

*-----------------------------------------------------------------------------*
CLASS TGridControlDatePicker FROM TGridControl
*-----------------------------------------------------------------------------*
   DATA lUpDown

   METHOD New
   METHOD CreateControl
   METHOD Str2Val(uValue)   BLOCK { |Self,uValue| Empty( Self ), CTOD( uValue ) }
   METHOD GridValue(uValue) BLOCK { |Self,uValue| Empty( Self ), DTOC( uValue ) }
ENDCLASS

METHOD New( lUpDown ) CLASS TGridControlDatePicker
   If ValType( lUpDown ) != "L"
      lUpDown := .F.
   Endif
   ::lUpDown := lUpDown
Return Self

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlDatePicker
   If ValType( uValue ) == "C"
      uValue := CTOD( uValue )
   EndIf
   If ::lUpDown
      @ nRow,nCol DATEPICKER 0 OBJ ::oControl PARENT &cWindow WIDTH nWidth HEIGHT nHeight VALUE uValue UPDOWN
   Else
      @ nRow,nCol DATEPICKER 0 OBJ ::oControl PARENT &cWindow WIDTH nWidth HEIGHT nHeight VALUE uValue
   EndIf
Return ::oControl

*-----------------------------------------------------------------------------*
CLASS TGridControlComboBox FROM TGridControl
*-----------------------------------------------------------------------------*
   DATA aItems INIT {}
   DATA oGrid  INIT nil

   METHOD New
   METHOD CreateControl
   METHOD Str2Val
   METHOD GridValue(uValue) BLOCK { |Self,uValue| if( ( uValue >= 1 .AND. uValue <= Len( ::aItems ) ), ::aItems[ uValue ], "" ) }
ENDCLASS

METHOD New( aItems, oGrid ) CLASS TGridControlComboBox
   If ValType( aItems ) == "A"
      ::aItems := aItems
   EndIf
   ::oGrid := oGrid
Return Self

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlComboBox
   Empty( nHeight )
   If ValType( uValue ) == "C"
      uValue := aScan( ::aItems, { |c| c == uValue } )
   EndIf
   @ nRow,nCol COMBOBOX 0 OBJ ::oControl PARENT &cWindow WIDTH nWidth VALUE uValue ITEMS ::aItems
   If ! Empty( ::oGrid ) .AND. ::oGrid:ImageList != 0
      ::oControl:ImageList := ImageList_Duplicate( ::oGrid:ImageList )
   EndIf
Return ::oControl

METHOD Str2Val( uValue ) CLASS TGridControlComboBox
Return ASCAN( ::aItems, { |c| c == uValue } )

*-----------------------------------------------------------------------------*
CLASS TGridControlSpinner FROM TGridControl
*-----------------------------------------------------------------------------*
   DATA nRangeMin INIT 0
   DATA nRangeMax INIT 100

   METHOD New
   METHOD CreateControl
   METHOD Str2Val(uValue)   BLOCK { |Self,uValue| Empty( Self ), Val( AllTrim( uValue ) ) }
   METHOD GridValue(uValue) BLOCK { |Self,uValue| Empty( Self ), LTrim( Str( uValue ) ) }
ENDCLASS

METHOD New( nRangeMin, nRangeMax ) CLASS TGridControlSpinner
   If ValType( nRangeMin ) == "N"
      ::nRangeMin := nRangeMin
   EndIf
   If ValType( nRangeMax ) == "N"
      ::nRangeMax := nRangeMax
   EndIf
Return Self

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlSpinner
   If ValType( uValue ) == "C"
      uValue := Val( uValue )
   EndIf
   @ nRow,nCol SPINNER 0 OBJ ::oControl PARENT &cWindow RANGE ::nRangeMin, ::nRangeMax WIDTH nWidth HEIGHT nHeight VALUE uValue
Return ::oControl

*-----------------------------------------------------------------------------*
CLASS TGridControlCheckBox FROM TGridControl
*-----------------------------------------------------------------------------*
   DATA cTrue  INIT ".T."
   DATA cFalse INIT ".F."

   METHOD New
   METHOD CreateControl
   METHOD Str2Val(uValue)   BLOCK { |Self,uValue| ( uValue == ::cTrue .OR. UPPER( uValue ) == ".T." ) }
   METHOD GridValue(uValue) BLOCK { |Self,uValue| If( uValue, ::cTrue, ::cFalse ) }
ENDCLASS

METHOD New( cTrue, cFalse ) CLASS TGridControlCheckBox
   If ValType( cTrue ) $ "CM"
      ::cTrue := cTrue
   EndIf
   If ValType( cFalse ) $ "CM"
      ::cFalse := cFalse
   EndIf
Return Self

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlCheckBox
   If ValType( uValue ) == "C"
      uValue := ( uValue == ::cTrue .OR. UPPER( uValue ) == ".T." )
   EndIf
   @ nRow,nCol CHECKBOX 0 OBJ ::oControl PARENT &cWindow CAPTION if( uValue, ::cTrue, ::cFalse ) WIDTH nWidth HEIGHT nHeight VALUE uValue ;
               ON CHANGE ( ::oControl:Caption := if( ::oControl:Value, ::cTrue, ::cFalse ) )
Return ::oControl

*-----------------------------------------------------------------------------*
CLASS TGridControlImageList FROM TGridControl
*-----------------------------------------------------------------------------*
   DATA oGrid

   METHOD New
   METHOD CreateControl
   METHOD Str2Val(uValue)   BLOCK { |Self,uValue| Empty( Self ), Val( uValue ) }
   METHOD ControlValue      BLOCK { |Self| ::oControl:Value - 1 }
ENDCLASS

METHOD New( oGrid ) CLASS TGridControlImageList
   ::oGrid := oGrid
Return Self

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlImageList
   Empty( nHeight )
   If ValType( uValue ) == "C"
      uValue := Val( uValue )
   EndIf
   @ nRow,nCol COMBOBOX 0 OBJ ::oControl PARENT &cWindow WIDTH nWidth VALUE 0 ITEMS {}
   If ! Empty( ::oGrid ) .AND. ::oGrid:ImageList != 0
      ::oControl:ImageList := ImageList_Duplicate( ::oGrid:ImageList )
   EndIf
   AEVAL( ARRAY( ImageList_GetImageCount( ::oGrid:ImageList ) ), { |x,i| ::oControl:AddItem( i - 1 ), x } )
   ::oControl:Value := uValue + 1
Return ::oControl

*-----------------------------------------------------------------------------*
CLASS TGridControlLComboBox FROM TGridControl
*-----------------------------------------------------------------------------*
   DATA cTrue  INIT ".T."
   DATA cFalse INIT ".F."

   METHOD New
   METHOD CreateControl
   METHOD Str2Val(uValue)   BLOCK { |Self,uValue| ( uValue == ::cTrue .OR. UPPER( uValue ) == ".T." ) }
   METHOD GridValue(uValue) BLOCK { |Self,uValue| If( uValue, ::cTrue, ::cFalse ) }
   METHOD ControlValue      BLOCK { |Self| ( ::oControl:Value == 1 ) }
ENDCLASS

METHOD New( cTrue, cFalse ) CLASS TGridControlLComboBox
   If ValType( cTrue ) $ "CM"
      ::cTrue := cTrue
   EndIf
   If ValType( cFalse ) $ "CM"
      ::cFalse := cFalse
   EndIf
Return Self

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlLComboBox
   Empty( nHeight )
   If ValType( uValue ) == "C"
      uValue := ( uValue == ::cTrue .OR. UPPER( uValue ) == ".T." )
   EndIf
   uValue := if( uValue, 1, 2 )
   @ nRow,nCol COMBOBOX 0 OBJ ::oControl PARENT &cWindow WIDTH nWidth VALUE uValue ITEMS { ::cTrue, ::cFalse }
Return ::oControl