/*
 * $Id: h_grid.prg,v 1.181 2012-08-25 17:20:33 fyurisich Exp $
 */
/*
 * ooHG source code:
 * PRG grid functions
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

#include "oohg.ch"
#include "hbclass.ch"
#include "i_windefs.ch"

CLASS TGrid FROM TControl
   DATA Type                  INIT "GRID" READONLY
   DATA nWidth                INIT 240
   DATA nHeight               INIT 120
   DATA aWidths               INIT {}
   DATA aHeaders              INIT {}
   DATA aHeadClick            INIT Nil
   DATA aJust                 INIT Nil
   DATA AllowEdit             INIT .F.
   DATA GridForeColor         INIT {}
   DATA GridBackColor         INIT {}
   DATA DynamicForeColor      INIT {}
   DATA DynamicBackColor      INIT {}
   DATA Picture               INIT Nil
   DATA OnDispInfo            INIT Nil
   DATA SetImageListCommand   INIT LVM_SETIMAGELIST
   DATA SetImageListWParam    INIT LVSIL_SMALL
   DATA InPlace               INIT .F.
   DATA FullMove              INIT .F.
   DATA Append                INIT .F.
   DATA EditControls          INIT Nil
   DATA ReadOnly              INIT Nil
   DATA Valid                 INIT Nil
   DATA ValidMessages         INIT Nil
   DATA OnEditCell            INIT Nil
   DATA OnAbortEdit           INIT Nil
   DATA OnAppend              INIT Nil
   DATA aWhen                 INIT {}
   DATA cRowEditTitle         INIT Nil
   DATA lNested               INIT .F.
   DATA AllowMoveColumn       INIT .T.
   DATA AllowChangeSize       INIT .T.
   DATA lNestedEdit           INIT .F.
   DATA nRowPos               INIT 1
   DATA nColPos               INIT 1
   DATA lEditMode             INIT .F.
   DATA lAppendMode           INIT .F.
   DATA bOnEnter              INIT Nil
   DATA HeaderImageList       INIT Nil
   DATA aHeaderImage          INIT {}
   DATA aHeaderImageAlign     INIT {}
   DATA GridSelectedColors    INIT {}
   DATA aSelectedColors       INIT {}
   DATA aEditKeys             INIT Nil
   DATA lCheckBoxes           INIT .F.
   DATA OnCheckChange         INIT Nil
   DATA lFocusRect            INIT .T.
   DATA lNoGrid               INIT .F.
   DATA lPLM                  INIT .F.
   DATA SearchCol             INIT 1
   DATA SearchWrap            INIT .T.
   DATA SearchLapse           INIT 1000
   DATA cText                 INIT ""
   DATA uIniTime              INIT 0

   METHOD Define
   METHOD Define2
   METHOD Value               SETGET
   METHOD OnEnter             SETGET
   METHOD Events
   METHOD Events_Enter
   METHOD Events_Notify
   METHOD AddColumn
   METHOD DeleteColumn
   METHOD Cell
   METHOD CellCaption( nRow, nCol, uValue ) BLOCK { | Self, nRow, nCol, uValue | CellRawValue( ::hWnd, nRow, nCol, 1, uValue ) }
   METHOD CellImage( nRow, nCol, uValue )   BLOCK { | Self, nRow, nCol, uValue | CellRawValue( ::hWnd, nRow, nCol, 2, uValue ) }
   METHOD EditCell
   METHOD EditCell2
   METHOD EditAllCells
   METHOD EditItem
   METHOD EditItem2
   METHOD EditGrid
   METHOD IsColumnReadOnly
   METHOD IsColumnWhen
   METHOD ToExcel
   METHOD AddItem
   METHOD AppendItem
   METHOD InsertItem
   METHOD InsertBlank
   METHOD DeleteItem
   METHOD DeleteAllItems      BLOCK { | Self | ListViewReset( ::hWnd ), ::GridForeColor := Nil, ::GridBackColor := Nil, ::DoChange() }
   METHOD Item
   METHOD SetItemColor
   METHOD ItemCount           BLOCK { | Self | ListViewGetItemCount( ::hWnd ) }
   METHOD CountPerPage        BLOCK { | Self | ListViewGetCountPerPage( ::hWnd ) }
   METHOD FirstSelectedItem   BLOCK { | Self | ListView_GetFirstItem( ::hWnd ) }
   METHOD Header
   METHOD FontColor           SETGET
   METHOD BackColor           SETGET
   METHOD ColumnCount
   METHOD SetRangeColor
   METHOD ColumnWidth
   METHOD ColumnAutoFit
   METHOD ColumnAutoFitH
   METHOD ColumnsAutoFit
   METHOD ColumnsAutoFitH
   METHOD ColumnBetterAutoFit
   METHOD ColumnsBetterAutoFit
   METHOD ColumnHide
   METHOD ColumnShow
   METHOD SortColumn
   METHOD Up
   METHOD Down
   METHOD Left
   METHOD Right
   METHOD PageDown
   METHOD PageUp
   METHOD GoTop
   METHOD GoBottom
   METHOD HeaderImage
   METHOD HeaderImageAlign
   METHOD Release
   METHOD LoadHeaderImages
   METHOD SetSelectedColors   SETGET
   METHOD CheckItem           SETGET
   METHOD Justify
   METHOD HeaderHeight
   METHOD ItemHeight
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
               aRows, value, fontname, fontsize, tooltip, change, dblclick, ;
               aHeadClick, gotfocus, lostfocus, nogrid, aImage, aJust, ;
               break, HelpId, bold, italic, underline, strikeout, ownerdata, ;
               ondispinfo, itemcount, editable, backcolor, fontcolor, ;
               dynamicbackcolor, dynamicforecolor, aPicture, lRtl, inplace, ;
               editcontrols, readonly, valid, validmessages, editcell, ;
               aWhenFields, lDisabled, lNoTabStop, lInvisible, lHasHeaders, ;
               onenter, aHeaderImage, aHeaderImageAlign, FullMove, ;
               aSelectedColors, aEditKeys, lCheckBoxes, oncheck, lDblBffr, ;
               lFocusRect, lPLM, lFixedCols, abortedit, click ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local nStyle := LVS_SINGLESEL

   ::Define2( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
              aRows, value, fontname, fontsize, tooltip, change, dblclick, ;
              aHeadClick, gotfocus, lostfocus, nogrid, aImage, aJust, ;
              break, HelpId, bold, italic, underline, strikeout, ownerdata, ;
              ondispinfo, itemcount, editable, backcolor, fontcolor, ;
              dynamicbackcolor, dynamicforecolor, aPicture, lRtl, nStyle, ;
              inplace, editcontrols, readonly, valid, validmessages, ;
              editcell, aWhenFields, lDisabled, lNoTabStop, lInvisible, ;
              lHasHeaders, onenter, aHeaderImage, aHeaderImageAlign, FullMove, ;
              aSelectedColors, aEditKeys, lCheckBoxes, oncheck, lDblBffr, ;
              lFocusRect, lPLM, lFixedCols, abortedit, click )
Return Self

*-----------------------------------------------------------------------------*
METHOD Define2( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
                aRows, value, fontname, fontsize, tooltip, change, dblclick, ;
                aHeadClick, gotfocus, lostfocus, nogrid, aImage, aJust, ;
                break, HelpId, bold, italic, underline, strikeout, ownerdata, ;
                ondispinfo, itemcount, editable, backcolor, fontcolor, ;
                dynamicbackcolor, dynamicforecolor, aPicture, lRtl, nStyle, ;
                inplace, editcontrols, readonly, valid, validmessages, ;
                editcell, aWhenFields, lDisabled, lNoTabStop, lInvisible, ;
                lHasHeaders, onenter, aHeaderImage, aHeaderImageAlign, FullMove, ;
                aSelectedColors, aEditKeys, lCheckBoxes, oncheck, lDblBffr, ;
                lFocusRect, lPLM, lFixedCols, abortedit, click ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local ControlHandle, aImageList, i

   ::SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor, .t., lRtl )

   ASSIGN ::aWidths  VALUE aWidths  TYPE "A"
   ASSIGN ::aHeaders VALUE aHeaders TYPE "A"

   If Len( ::aHeaders ) != Len( ::aWidths )
      MsgOOHGError( "Grid: HEADERS/WIDTHS array size mismatch. Program Terminated." )
   EndIf
   If HB_IsArray( aRows )
      If aScan( aRows, { |a| ! HB_IsArray( a ) .OR. Len( a ) != Len( aHeaders ) } ) > 0
         MsgOOHGError( "Grid: ITEMS length mismatch. Program Terminated." )
      EndIf
   Else
      aRows := {}
   EndIf

   ASSIGN ::nWidth      VALUE w           TYPE "N"
   ASSIGN ::nHeight     VALUE h           TYPE "N"
   ASSIGN ::nRow        VALUE y           TYPE "N"
   ASSIGN ::nCol        VALUE x           TYPE "N"

   If HB_IsArray( aHeadClick )
      ::aHeadClick := aHeadClick
   ElseIf HB_IsBlock( aHeadClick )
      ::aHeadClick := Array( Len(  ::aHeaders ) )
      aFill( ::aHeadClick, aHeadClick )
   Else
      ::aHeadClick := {}
   EndIf

   If HB_IsLogical( lFixedCols )
      ::AllowMoveColumn := ! lFixedCols
   EndIf

   ASSIGN ::aJust       VALUE aJust       TYPE "A"
   ASSIGN ::Picture     VALUE aPicture    TYPE "A"

   ASSIGN ::lNoGrid     VALUE nogrid      TYPE "L" DEFAULT .F.
   ASSIGN ::lCheckBoxes VALUE lCheckBoxes TYPE "L" DEFAULT .F.
   ASSIGN ::lFocusRect  VALUE lFocusRect  TYPE "L" DEFAULT .T.
   ASSIGN ::lPLM        VALUE lPLM        TYPE "L" DEFAULT .F.

   If ::lCheckBoxes .AND. ::lPLM
      MsgOOHGError( "CHECKBOXES and PAINTLEFTMARGIN clauses can't be used simultaneously. Program Terminated." )
   EndIf

   nStyle := ::InitStyle( nStyle,, lInvisible, lNoTabStop, lDisabled ) + ;
             If( HB_IsLogical( lHasHeaders ) .AND. ! lHasHeaders, LVS_NOCOLUMNHEADER, 0 )

   If ! HB_IsArray( ::aJust )
      ::aJust := aFill( Array( Len( ::aHeaders ) ), 0 )
   Else
      aSize( ::aJust, Len( ::aHeaders ) )
      aEval( ::aJust, { |x,i| ::aJust[ i ] := If( ! HB_IsNumeric( x ), 0, x ) } )
   EndIf

   If ! HB_IsArray( ::Picture )
      ::Picture := Array( Len( ::aHeaders ) )
   Else
      aSize( ::Picture, Len( ::aHeaders ) )
   EndIf
   aEval( ::Picture, { |x,i| ::Picture[ i ] := If( ( ValType( x ) $ "CM" .AND. ! Empty( x ) ) .OR. HB_IsLogical( x ), x, Nil ) } )

   ::SetSplitBoxInfo( Break )
   ControlHandle := InitListView( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, '', 0, If( ::lNoGrid, 0, 1 ), ownerdata, itemcount, nStyle, ::lRtl, ::lCheckBoxes, lDblBffr )

   If HB_IsArray( aImage )
//      aImageList := ImageList_Init( aImage, CLR_NONE, LR_LOADTRANSPARENT )
      aImageList := ImageList_Init( aImage, CLR_DEFAULT, LR_LOADTRANSPARENT + LR_DEFAULTCOLOR + LR_LOADMAP3DCOLORS )
      SendMessage( ControlHandle, ::SetImageListCommand, ::SetImageListWParam, aImageList[ 1 ] )
      ::ImageList := aImageList[ 1 ]
      If aScan( ::Picture, .T. ) == 0
         ::Picture[ 1 ] := .T.
         ::aWidths[ 1 ] := Max( ::aWidths[ 1 ], aImageList[ 2 ] + If( ::lCheckBoxes, GetStateListWidth( ControlHandle ) + 4, 4 ) ) // Set Column 1 width to Bitmap width plus checkboxes
      EndIf
   ElseIf ::lCheckBoxes
      ::aWidths[ 1 ] := Max( ::aWidths[ 1 ], GetStateListWidth( ControlHandle ) + 4 ) // Set Column 1 width to checkboxes width
   EndIf

   InitListViewColumns( ControlHandle, ::aHeaders, ::aWidths, ::aJust )

   ::Register( ControlHandle, ControlName, HelpId, , ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   ::FontColor := ::Super:FontColor
   ::BackColor := ::Super:BackColor

   ::DynamicForeColor := dynamicforecolor
   ::DynamicBackColor := dynamicbackcolor
   ::Readonly := readonly
   ::Valid := valid
   ::ValidMessages := validmessages
   ::aEditKeys := aEditKeys
   ::EditControls := editcontrols
   ::OnEditCell := editcell
   ::OnAbortEdit := abortedit
   ::aWhen := aWhenFields
   ASSIGN ::InPlace   VALUE inplace  TYPE "L"
   ASSIGN ::FullMove  VALUE FullMove TYPE "L"
   ASSIGN ::AllowEdit VALUE editable .OR. inplace TYPE "L"

   // Load images alignments
   // This should come before than 'Load header images'
   ::aHeaderImageAlign := aFill( Array( Len( ::aHeaders ) ), HEADER_IMG_AT_LEFT )

   If HB_IsArray( aHeaderImageAlign )
      For i := 1 To Len( aHeaderImageAlign )
         If HB_IsNumeric( aHeaderImageAlign[ i ] ) .AND. aHeaderImageAlign[ i ] == HEADER_IMG_AT_RIGHT
           ::aHeaderImageAlign[ i ] := HEADER_IMG_AT_RIGHT
         EndIf
      Next i
   EndIf

   // Load header images
   // This should come after 'Load images alignments'
   ::LoadHeaderImages( aHeaderImage )

   If ValidHandler( ::HeaderImageList )
      // Associate the imagelist with the listview's header control
      SetHeaderImageList( ControlHandle, ::HeaderImageList )

      // Set images aligments
      For i := 1 To Len( ::aHeaders )
        ::HeaderImage( i, ::aHeaderImage[ i ] )
        ::HeaderImageAlign( i, ::aHeaderImageAlign[ i ] )
      Next i
   EndIf

   // Load rows
   aEval( aRows, { |u| ::AddItem( u ) } )

   If ! HB_IsArray( aSelectedColors )
      aSelectedColors := {}
   EndIf
   ::SetSelectedColors( aSelectedColors, .F. )
   
   ::Value := value

   // Must be set after control is initialized
   ASSIGN ::OnLostFocus   VALUE lostfocus  TYPE "B"
   ASSIGN ::OnGotFocus    VALUE gotfocus   TYPE "B"
   ASSIGN ::OnChange      VALUE Change     TYPE "B"
   ASSIGN ::OnDblClick    VALUE dblclick   TYPE "B"
   ASSIGN ::OnClick       VALUE click      TYPE "B"
   ASSIGN ::OnDispInfo    VALUE ondispinfo TYPE "B"
   ASSIGN ::OnEnter       VALUE onenter    TYPE "B"
   ASSIGN ::OnCheckChange VALUE oncheck    TYPE "B"

Return Self

*-----------------------------------------------------------------------------*
METHOD CheckItem( nItem, lChecked ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local lRet, lOld

   If ::lCheckBoxes .AND. HB_IsNumeric( nItem )
      lOld := ListView_GetCheckState( ::hwnd, nItem )

      If HB_IsLogical( lChecked ) .AND. lChecked # lOld
         ListView_SetCheckState( ::hwnd, nItem, lChecked )

         lRet := ListView_GetCheckState( ::hwnd, nItem )

         If lRet # lOld
            ::DoEvent( ::OnCheckChange, "CHECKCHANGE", { nItem } )
         EndIf
      Else
         lRet := lOld
      EndIf
   Else
      lRet := .F.
   EndIf

Return lRet

*-----------------------------------------------------------------------------*
METHOD SetSelectedColors( aSelectedColors, lRedraw ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local i, aColors[ 4 ]

   If HB_IsArray( aSelectedColors )
      aSelectedColors := aClone( aSelectedColors )
      aSize( aSelectedColors, 4 )

      // For text of selected row when grid has the focus
      If ! ValType( aSelectedColors[ 1 ] ) $ "ANB"
         aSelectedColors[ 1 ] := GetSysColor( COLOR_HIGHLIGHTTEXT )
      EndIf
      // For background of selected row when grid has the focus
      If ! ValType( aSelectedColors[ 2 ] ) $ "ANB"
         aSelectedColors[ 2 ] := GetSysColor( COLOR_HIGHLIGHT )
      EndIf
      // For text of selected row when grid doesn't has the focus
      If ! ValType( aSelectedColors[ 3 ] ) $ "ANB"
         aSelectedColors[ 3 ] := GetSysColor( COLOR_WINDOWTEXT )
      EndIf
      // For background of selected row when doesn't has the focus
      If ! ValType( aSelectedColors[ 4 ] ) $ "ANB"
         aSelectedColors[ 4 ] := GetSysColor( COLOR_3DFACE )
      EndIf

      ::aSelectedColors := aSelectedColors

      For i := 1 to 4
         aColors[ i ] := _OOHG_GetArrayItem( aSelectedColors, i )
      Next i

      ::GridSelectedColors := aColors

      If lRedraw
         RedrawWindow( ::hWnd )
      EndIf
   Else
      aSelectedColors := aClone( ::aSelectedColors )
   EndIf

Return aSelectedColors

*-----------------------------------------------------------------------------*
METHOD LoadHeaderImages( aNewHeaderImage ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local i, nPos, nCount, aImageList, nImagesWidth, aHeaderImage, aImageName := {}

   // Clone the array in case aNewHeaderImage is the same as ::aHeaderImage
   If HB_IsArray( aNewHeaderImage )
      aHeaderImage := aClone( aNewHeaderImage )
   Else
      aHeaderImage := Nil
   EndIf

   // Destroy previous imagelist
   If ValidHandler( ::HeaderImageList )
      ImageList_Destroy( ::HeaderImageList )
   EndIf
   ::HeaderImageList := Nil

   // Load images into imagelist
   ::aHeaderImage := aFill( Array( Len( ::aHeaders ) ), 0 )

   If HB_IsArray( aHeaderImage )
      For i := 1 To Len( aHeaderImage )
         If ValType( aHeaderImage[ i ] ) $ "CM" .AND. ! Empty( aHeaderImage[ i ] )
            If ValidHandler( ::HeaderImageList )
               nPos := aScan( aImageName, aHeaderImage[ i ] )
               If nPos > 0                                                 // Image already loaded, reuse it
                  ::aHeaderImage[ i ] := nPos
               Else
                  nCount := ImageList_GetImageCount( ::HeaderImageList )
                  nPos := ImageList_Add( ::HeaderImageList, aHeaderImage[ i ], LR_LOADTRANSPARENT + LR_DEFAULTCOLOR + LR_LOADMAP3DCOLORS, CLR_DEFAULT )
                  If ImageList_GetImageCount( ::HeaderImageList ) == nCount
                     nPos := 0
                  EndIf

                  If nPos == 0                       // Image not added
                     aHeaderImage[ i ] := Nil
                  Else
                     aAdd( aImageName, aHeaderImage[ i ] )
                     ::aHeaderImage[ i ] := nPos
                     ::aWidths[ i ] := Max( ::aWidths[ i ], nImagesWidth )
                  EndIf
               EndIf
            Else
               aImageList := ImageList_Init( { aHeaderImage[ i ] }, CLR_DEFAULT, LR_LOADTRANSPARENT + LR_DEFAULTCOLOR + LR_LOADMAP3DCOLORS )

               If ValidHandler( aImageList[ 1 ] )
                  ::HeaderImageList := aImageList[ 1 ]
                  aAdd( aImageName, aHeaderImage[ i ] )
                  ::aHeaderImage[ i ] := 1
                  nImagesWidth := aImageList[ 2 ] + 4
                  If i == 1
                     ::aWidths[ 1 ] := Max( ::aWidths[ 1 ], nImagesWidth + If( ::lCheckBoxes, GetStateListWidth( ::hWnd ), 0 ) )
                  Else
                     ::aWidths[ i ] := Max( ::aWidths[ i ], nImagesWidth )
                  EndIf
               Else
                  aHeaderImage[ i ] := Nil
               EndIf
            EndIf
         Else
            aHeaderImage[ i ] := Nil                 // Header has no image
         EndIf
      Next i
   EndIf

   If ValidHandler( ::HeaderImageList )
      // Associate the imagelist with the header control of the listview
      SetHeaderImageList( ::hWnd, ::HeaderImageList )

      // Set images aligments
      For i := 1 To Len( ::aHeaders )
        ::HeaderImage( i, ::aHeaderImage[ i ] )
        ::HeaderImageAlign( i, ::aHeaderImageAlign[ i ] )
      Next i
   Else
      // Deassociate the imagelist
      SetHeaderImageList( ::hWnd, 0 )
   EndIf
   
Return Nil

*-----------------------------------------------------------------------------*
METHOD OnEnter( bEnter ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local bRet
   If HB_IsBlock( bEnter )
      If _OOHG_SameEnterDblClick
         ::OnDblClick := bEnter
      Else
         ::bOnEnter := bEnter
      EndIf
      bRet := bEnter
   Else
      bRet := If( _OOHG_SameEnterDblClick, ::OnDblClick, ::bOnEnter )
   EndIf
Return bRet

*--------------------------------------------------------------------------*
METHOD AppendItem() CLASS TGrid
*--------------------------------------------------------------------------*
   ::lAppendMode := .T.
   ::InsertBlank( ::ItemCount + 1 )
   ::Value := ::ItemCount
   ::Events_Enter()
Return Nil

*--------------------------------------------------------------------------*
METHOD EditGrid( nRow, nCol ) CLASS TGrid
*--------------------------------------------------------------------------*
Local lRet
   If ! HB_IsNumeric( nRow )
      nRow := ::FirstSelectedItem
   EndIf
   If ! HB_IsNumeric( nCol )
      nCol := 1
   EndIf
   If nRow < 1 .OR. nRow > ::ItemCount .OR. nCol < 1 .OR. nCol > Len( ::aHeaders )
      // Cell out of range
      Return .F.
   EndIf
   ::nRowPos := nRow
   ::nColPos := nCol

   lRet := .T.

   Do While ::nColPos <= Len( ::aHeaders ) .AND. ::nRowPos <= ::ItemCount .AND. lRet
      _OOHG_ThisItemCellValue := ::Cell( ::nRowPos, ::nColPos )

      If ::IsColumnReadOnly( ::nColPos )
         // Read only column
      ElseIf ! ::IsColumnWhen( ::nColPos )
         // Not a valid WHEN
      Else

         ::leditmode := .T.
         lRet := ::EditCell( ::nRowPos, ::nColPos )
         ::leditmode := .F.

         If ::lAppendMode
            ::lAppendMode := .F.
            If lRet
               ::DoEvent( ::OnAppend, "APPEND" )
            Else
               ::DeleteItem( ::ItemCount )
               ::Value := ::ItemCount
               ::nRowPos := ::FirstSelectedItem
            EndIf
         EndIf

         If ! lRet
            Exit
         EndIf
      EndIf

      // ::OnEditCell() may change ::nRowPos and/or ::nColPos using ::Up(),
      // ::Down(), ::Left() and/or ::Right()
      If ::nColPos < Len( ::aHeaders )
         ::nColPos ++
      Else
         If ::FullMove
            If ::nRowPos == ::ItemCount
               If ::Append
                  // Add a new item
                  ::lAppendMode := .T.
                  ::InsertBlank( ::ItemCount + 1 )
               Else
                  Exit
               EndIf
            EndIf

            ::nRowPos ++
            ::nColPos := 1
         Else
            Exit
         EndIf
      EndIf

      ::Value := ::nRowPos
   EndDo

   If lRet
      ListView_Scroll( ::hWnd, - _OOHG_GridArrayWidths( ::hWnd, ::aWidths ), 0)
   EndIf
Return lRet

*--------------------------------------------------------------------------*
METHOD Right() CLASS TGrid
*--------------------------------------------------------------------------*
   If ::lEditMode .AND. ::FullMove
      If ::nColPos < Len( ::aHeaders )
         ::nColPos ++
      ElseIf ::nRowPos < ::ItemCount
         ::nRowPos ++
         ::nColPos := 1
      EndIf
   EndIf
Return Self

*--------------------------------------------------------------------------*
METHOD Left() CLASS TGrid
*--------------------------------------------------------------------------*
   If ::lEditMode .AND. ::FullMove
      If ::nColPos > 1
         ::nColPos --
         ::nColPos --
      ElseIf ::nRowPos > 1
         ::nRowPos --
         ::nColPos := Len( ::aHeaders ) - 1
      EndIf
   EndIf
Return Self

*--------------------------------------------------------------------------*
METHOD Down() CLASS TGrid
*--------------------------------------------------------------------------*
   If ::lEditMode
      If ::nRowPos < ::ItemCount
         ::nRowPos ++
      EndIf
   Else
      If ::FirstSelectedItem < ::ItemCount
         ::Value := ::FirstSelectedItem + 1
      ElseIf ::Append
         ::AppendItem()
      EndIf
   EndIf
Return Self

*--------------------------------------------------------------------------*
METHOD Up() CLASS TGrid
*--------------------------------------------------------------------------*
   If ::lEditMode
      If ::nRowPos > 1
         ::nRowPos --
      EndIf
   Else
      If ::FirstSelectedItem > 1
         ::Value := ::FirstSelectedItem - 1
      EndIf
   EndIf
Return Self

*--------------------------------------------------------------------------*
METHOD PageUp() CLASS TGrid
*--------------------------------------------------------------------------*
   If ::FirstSelectedItem > ::CountPerPage
      ::Value := ::Value - ::CountPerPage
   Else
      ::GoTop()
   EndIf
Return Self

*-------------------------------------------------------------------------*
METHOD PageDown() CLASS TGrid
*-------------------------------------------------------------------------*
   If ::FirstSelectedItem < ::ItemCount - ::CountPerPage
      ::Value := ::Value + ::CountPerPage
   Else
     ::GoBottom()
   EndIf
Return Self

*---------------------------------------------------------------------------*
METHOD GoTop() CLASS TGrid
*---------------------------------------------------------------------------*
   If ::ItemCount > 0
      ::Value := 1
   EndIf
Return Self

*---------------------------------------------------------------------------*
METHOD GoBottom() CLASS TGrid
*---------------------------------------------------------------------------*
   If ::ItemCount > 0
      ::Value := ::ItemCount
   EndIf
Return Self

*-----------------------------------------------------------------------------*
METHOD ToExcel( cTitle, nRow ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local lin := 4
Local oExcel, oHoja, i

   DEFAULT ctitle TO ""

   #ifndef __XHARBOUR__
      If ( oExcel := win_oleCreateObject( "Excel.Application" ) ) == Nil
         MsgStop( "Error: MS Excel not available. [" + win_oleErrorText()+ "]" )
         Return Nil
      EndIf
   #else
      oExcel := TOleAuto():New( "Excel.Application" )
      If Ole2TxtError() != 'S_OK'
         MsgStop('Excel not found','error')
         Return Nil
      EndIf
   #EndIf

   oExcel:WorkBooks:Add()
   oHoja := oExcel:ActiveSheet()
   oHoja:Cells:Font:Name := "Arial"
   oHoja:Cells:Font:Size := 10

   oHoja:Cells( 1, 1 ):Value := Upper( cTitle )
   oHoja:Cells( 1, 1 ):Font:Bold := .T.

   For i := 1 To Len( ::aHeaders )
      oHoja:Cells( lin, i ):Value := Upper( ::aHeaders[i] )
      oHoja:Cells( lin, i ):Font:Bold := .T.
   Next i
   lin ++
   lin ++

   If ! HB_IsNumeric( nRow ) .OR. nRow < 1
      nRow := ::FirstSelectedItem
   EndIf
   Do While nRow <= ::ItemCount .AND. nRow > 0
      For i := 1 To Len( ::aHeaders )
         oHoja:Cells( lin, i ):Value := ::Cell( nRow, i )
      Next i
      nRow ++
      lin ++
   Enddo

   For i := 1 To Len( ::Aheaders )
      oHoja:Columns( i ):AutoFit()
   Next i

   oHoja:Cells( 1, 1 ):Select()
   oExcel:Visible := .T.
   oHoja := Nil
   oExcel:= Nil

Return Nil

*-----------------------------------------------------------------------------*
METHOD EditItem() CLASS TGrid
*-----------------------------------------------------------------------------*
Local nItem, aItems, aEditControls, nColumn
   nItem := ::FirstSelectedItem
   If nItem == 0
      Return Nil
   EndIf
   
   aItems := ::Item( nItem )

   aEditControls := Array( Len( aItems ) )
   For nColumn := 1 To Len( aEditControls )
      aEditControls[ nColumn ] := GetEditControlFromArray( Nil, ::EditControls, nColumn, Self )
      If ! HB_IsObject( aEditControls[ nColumn ] )
         // Check for imagelist
         If HB_IsNumeric( aItems[ nColumn ] )
            If HB_IsLogical( ::Picture[ nColumn ] ) .AND. ::Picture[ nColumn ]
               aEditControls[ nColumn ] := TGridControlImageList():New( Self )
            ElseIf HB_IsNumeric( ListViewGetItem( ::hWnd, nItem, Len( ::aHeaders ) )[ nColumn ] )
               aEditControls[ nColumn ] := TGridControlImageList():New( Self )
            EndIf
         EndIf
      EndIf
   Next

   aItems := ::EditItem2( nItem, aItems, aEditControls,, If( ValType( ::cRowEditTitle ) $ "CM", ::cRowEditTitle, _OOHG_Messages( 1, 5 ) ) )
   If Empty( aItems )
      _OOHG_Eval( ::OnAbortEdit, nItem, 0 )
   Else
      ::Item( nItem, aSize( aItems, Len( ::aHeaders ) ) )
      _SetThisCellInfo( ::hWnd, nItem, 1, Nil )
      _OOHG_Eval( ::OnEditCell, nItem, 0 )
      _ClearThisCellInfo()
   EndIf
Return Nil

*-----------------------------------------------------------------------------*
METHOD EditItem2( nItem, aItems, aEditControls, aMemVars, cTitle ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local l, actpos := {0,0,0,0}, GCol, iRow, i, oWnd, nWidth, nMaxHigh, oMain
Local oCtrl, aEditControls2, nRow, lSplitWindow, nControlsMaxHeight
Local aReturn

   If ::lNested
      Return {}
   EndIf
   ::lNested := .T.

   If ! HB_IsNumeric( nItem )
      nItem := ::FirstSelectedItem
   EndIf
   If nItem < 1 .OR. nItem > ::ItemCount
     ::lNested := .F.
      Return {}
   EndIf

   If ! HB_IsArray( aItems ) .OR. Len( aItems ) == 0
      aItems := ::Item( nItem )
   EndIf
   aItems := aClone( aItems )
   If Len( aItems ) > Len( ::aHeaders )
       aSize( aItems, Len( ::aHeaders ) )
   EndIf

   l := Len( aItems )

   iRow := ListViewGetItemRow( ::hWnd, nItem )

   GetWindowRect( ::hWnd, actpos )

   _SetThisCellInfo( ::hWnd, nItem, 1 )

   nControlsMaxHeight := GetDesktopHeight() - 130

   nWidth := 140
   nRow := 0
   aEditControls2 := Array( l )
   For i := 1 To l
      oCtrl := GetEditControlFromArray( Nil, aEditControls, i, Self )
      oCtrl := GetEditControlFromArray( oCtrl, ::EditControls, i, Self )
      If ! HB_IsObject( oCtrl )
         If HB_IsArray( ::Picture ) .AND. Len( ::Picture ) >= i .AND. ValType( ::Picture[ i ] ) $ "CM"
            oCtrl := TGridControlTextBox():New( ::Picture[ i ],, "C" )
         Else
            oCtrl := TGridControlTextBox():New()
         EndIf
      EndIf
      aEditControls2[ i ] := oCtrl
      nWidth := Max( nWidth, oCtrl:nDefWidth )
      nRow += oCtrl:nDefHeight + 6
   Next

   lSplitWindow := ( nRow > nControlsMaxHeight )

   nWidth += If( lSplitWindow, 170, 140 )

   GCol := actpos[ 1 ] + ( ( ( actpos[ 3 ] - actpos[ 1 ] ) - nWidth ) / 2 )
   GCol := Max( Min( GCol, ( GetSystemMetrics( SM_CXFULLSCREEN ) - nWidth ) ), 0 )

   nMaxHigh := Min( nControlsMaxHeight, nRow ) + 70 + GetTitleHeight()
   iRow := Max( Min( iRow, ( GetSystemMetrics( SM_CYFULLSCREEN ) - nMaxHigh ) ), 0 )

   aReturn := {}

   DEFINE WINDOW 0 OBJ oMain AT iRow,GCol ;
      WIDTH nWidth HEIGHT nMaxHigh ;
      TITLE cTitle MODAL NOSIZE

   If lSplitWindow
      DEFINE SPLITBOX
         DEFINE WINDOW 0 OBJ oWnd;
            WIDTH nWidth ;
            HEIGHT nControlsMaxHeight ;
            VIRTUAL HEIGHT nRow + 20 ;
            SPLITCHILD NOCAPTION FONT 'Arial' SIZE 10 BREAK FOCUSED
   Else
      oWnd := oMain
   EndIf

   nRow := 10

   For i := 1 To l
      @ nRow + 3, 10 LABEL 0 PARENT ( oWnd ) VALUE AllTrim( ::aHeaders[ i ] ) + ":" WIDTH 110 NOWORDWRAP
      aEditControls2[ i ]:CreateControl( aItems[ i ], oWnd:Name, nRow, 120, aEditControls2[ i ]:nDefWidth, aEditControls2[ i ]:nDefHeight )
      nRow += aEditControls2[ i ]:nDefHeight + 6
      If HB_IsArray( aMemVars ) .AND. Len( aMemVars ) >= i
         aEditControls2[ i ]:cMemVar := aMemVars[ i ]
         // "Creates" memvars
         If ValType( aMemVars[ i ] ) $ "CM" .AND. ! Empty( aMemVars[ i ] )
            &( aMemVars[ i ] ) := Nil
         EndIf
      EndIf
      If HB_IsArray( ::Valid ) .AND. Len( ::Valid ) >= i
         aEditControls2[ i ]:bValid := ::Valid[ i ]
      EndIf
      If HB_IsArray( ::ValidMessages ) .AND. Len( ::ValidMessages ) >= i
         aEditControls2[ i ]:cValidMessage := ::ValidMessages[ i ]
      EndIf

      If HB_IsArray( ::aWhen ) .AND. Len( ::aWhen ) >= i
         aEditControls2[ i ]:bWhen := ::aWhen[ i ]
      EndIf
      If ::IsColumnReadOnly( i )
         aEditControls2[ i ]:Enabled := .F.
         aEditControls2[ i ]:bWhen := { || .F. }
      EndIf

   Next

   If HB_IsArray( ::aEditKeys )
      For i := 1 To Len( ::aEditKeys )
         If HB_IsArray( ::aEditKeys[ i ] ) .AND. Len( ::aEditKeys[ i ] ) > 1 .AND. ValType( ::aEditKeys[ i, 1 ] ) $ "CM" .AND. HB_IsBlock( ::aEditKeys[ i, 2 ] )
            _DefineAnyKey( oWnd, ::aEditKeys[ i, 1 ], ::aEditKeys[ i, 2 ] )
         EndIf
      Next
   EndIf

   If lSplitWindow
      END WINDOW

      DEFINE WINDOW 0 OBJ oWnd ;
         WIDTH nWidth ;
         HEIGHT 50 ;
         SPLITCHILD NOCAPTION FONT 'Arial' SIZE 10 BREAK

      nRow := 10
   Else
      nRow += 10
   EndIf

   @ nRow,  25 BUTTON 0 PARENT ( oWnd ) CAPTION _OOHG_Messages( 1, 6 ) ;
         ACTION ( TGrid_EditItem_Check( aEditControls2, aItems, oMain, aReturn ) )

   @ nRow, 145 BUTTON 0 PARENT ( oWnd ) CAPTION _OOHG_Messages( 1, 7 ) ;
         ACTION oMain:Release()

   END WINDOW

   If lSplitWindow
      END SPLITBOX
      END WINDOW
   EndIf

   aEval( aEditControls2, { |o| o:OnLostFocus := { || TGrid_EditItem_When( aEditControls2 ) } } )

   TGrid_EditItem_When( aEditControls2 )

   aEditControls2[ 1 ]:SetFocus()

   oMain:Activate()

   _ClearThisCellInfo()

   ::SetFocus()

   ::lNested := .F.

Return aReturn

*-----------------------------------------------------------------------------*
STATIC FUNCTION TGrid_EditItem_When( aEditControls )
*-----------------------------------------------------------------------------*
Local nItem, lEnabled, aValues
   // Save values
   aValues := Array( Len( aEditControls ) )
   For nItem := 1 To Len( aEditControls )
      aValues[ nItem ] := aEditControls[ nItem ]:ControlValue
      If ValType( aEditControls[ nItem ]:cMemVar ) $ "CM" .AND. ! Empty( aEditControls[ nItem ]:cMemVar )
         &( aEditControls[ nItem ]:cMemVar ) := aValues[ nItem ]
      EndIf
   Next

   // WHEN clause
   For nItem := 1 To Len( aEditControls )
      _OOHG_ThisItemCellValue := aValues[ nItem ]
      lEnabled := _OOHG_Eval( aEditControls[ nItem ]:bWhen, nItem, aValues )
      If _CheckCellNewValue( aEditControls[ nItem ], aValues[ nItem ] )
         aValues[ nItem ] := _OOHG_ThisItemCellValue
      EndIf
      If HB_IsLogical( lEnabled ) .AND. ! lEnabled
         aEditControls[ nItem ]:Enabled := .F.
      Else
         aEditControls[ nItem ]:Enabled := .T.
      EndIf
   Next
Return aValues

*-----------------------------------------------------------------------------*
STATIC PROCEDURE TGrid_EditItem_Check( aEditControls, aItems, oWnd, aReturn )
*-----------------------------------------------------------------------------*
Local lRet, nItem, aValues, lValid, cValidMessage
   // Save values
   aValues := TGrid_EditItem_When( aEditControls )

   // Check VALID clauses
   lRet := .T.
   For nItem := 1 To Len( aEditControls )
      _OOHG_ThisItemCellValue := aValues[ nItem ]
      lValid := _OOHG_Eval( aEditControls[ nItem ]:bValid, aValues[ nItem ], nItem, aValues )
      If _CheckCellNewValue( aEditControls[ nItem ], aValues[ nItem ] )
         aValues[ nItem ] := _OOHG_ThisItemCellValue
      EndIf
      If HB_IsLogical( lValid ) .AND. ! lValid
         lRet := .F.
         cValidMessage := aEditControls[ nItem ]:cValidMessage
         If HB_IsBlock( cValidMessage )
            cValidMessage := Eval( cValidMessage, _OOHG_ThisItemCellValue )
         EndIf
         If ValType( cValidMessage ) $ "CM" .AND. ! Empty( cValidMessage )
            MsgExclamation( cValidMessage )
         Else
            MsgExclamation( _OOHG_Messages( 3, 11 ) )
         EndIf
         aEditControls[ nItem ]:SetFocus()
      EndIf
   Next

   // If all controls are valid, save values into "aItems"
   If lRet
      aSize( aReturn, Len( aItems ) )
      aEval( aValues, { |u,i| aItems[ i ] := aReturn [ i ] := u } )
      oWnd:Release()
   EndIf
Return

*-----------------------------------------------------------------------------*
METHOD IsColumnReadOnly( nCol ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local uReadOnly
   uReadOnly := _OOHG_GetArrayItem( ::ReadOnly, nCol )
Return ( HB_IsLogical( uReadOnly ) .AND. uReadOnly )

*-----------------------------------------------------------------------------*
METHOD IsColumnWhen( nCol ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local uWhen
   If nCol >= 1 .AND. HB_IsArray( ::aWhen ) .AND. Len( ::aWhen ) >= nCol
      uWhen := ::aWhen[ nCol ]
      If HB_IsBlock( uWhen )
         uWhen := Eval( uWhen, nCol, ::Item( ::Value ) )
      EndIf
   Else
      uWhen := Nil
   EndIf
Return ( ! HB_IsLogical( uWhen ) .OR. uWhen )

*-----------------------------------------------------------------------------*
METHOD AddColumn( nColIndex, cCaption, nWidth, nJustify, uForeColor, uBackColor, ;
                  lNoDelete, uPicture, uEditControl, uHeadClick, uValid, ;
                  uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local nColumns, uGridColor, uDynamicColor

   // Set Default Values
   nColumns := Len( ::aHeaders ) + 1

   If ! HB_IsNumeric( nColIndex ) .OR. nColIndex > nColumns
      nColIndex := nColumns
   ElseIf nColIndex < 1
      nColIndex := 1
   EndIf

   If ! ValType( cCaption ) $ 'CM'
      cCaption := ''
   EndIf

   If ! HB_IsNumeric( nWidth )
      nWidth := 120
   EndIf

   If ! HB_IsNumeric( nJustify )
      nJustify := 0
   EndIf

   // Update Headers
   aSize( ::aHeaders, nColumns )
   aIns( ::aHeaders, nColIndex )
   ::aHeaders[ nColIndex ] := cCaption

   // Update Pictures
   aSize( ::Picture, nColumns )
   aIns( ::Picture, nColIndex )
   ::Picture[ nColIndex ] := If( ( ValType( uPicture ) $ "CM" .AND. ! Empty( uPicture ) ) .OR. HB_IsLogical( uPicture ), uPicture, Nil )

   // Update Widths
   aSize( ::aWidths, nColumns )
   aIns( ::aWidths, nColIndex )
   ::aWidths[ nColIndex ] := nWidth

   If ! HB_IsLogical( lNoDelete )
      lNoDelete := .F.
   EndIf

   // Update Foreground Color
   uGridColor := ::GridForeColor
   uDynamicColor := ::DynamicForeColor
   TGrid_AddColumnColor( @uGridColor, nColIndex, uForeColor, @uDynamicColor, nColumns, ::ItemCount, lNoDelete, ::hWnd )
   ::GridForeColor := uGridColor
   ::DynamicForeColor := uDynamicColor

   // Update Background Color
   uGridColor := ::GridBackColor
   uDynamicColor := ::DynamicBackColor
   TGrid_AddColumnColor( @uGridColor, nColIndex, uBackColor, @uDynamicColor, nColumns, ::ItemCount, lNoDelete, ::hWnd )
   ::GridBackColor := uGridColor
   ::DynamicBackColor := uDynamicColor

   // Update edit control
   If ValType( uEditControl ) != Nil .OR. HB_IsArray( ::EditControls )
      If ! HB_IsArray( ::EditControls )
         ::EditControls := Array( nColumns )
      ElseIf Len( ::EditControls ) < nColumns
         aSize( ::EditControls, nColumns )
      EndIf
      aIns( ::EditControls, nColIndex )
      ::EditControls[ nColIndex ] := uEditControl
   EndIf

   // Update justification
   aSize( ::aJust, nColumns )
   aIns( ::aJust, nColIndex )
   ::aJust[ nColIndex ] := nJustify

   // Update on head click codeblock
   aSize( ::aHeadClick, nColumns )
   aIns( ::aHeadClick, nColIndex )
   ::aHeadClick[ nColIndex ] := uHeadClick

   // Update valid
   If HB_IsArray( ::Valid )
      aSize( ::Valid, nColumns )
      aIns( ::Valid, nColIndex )
      ::Valid[ nColIndex ] := uValid
   ElseIf uValid != Nil
      ::Valid := Array( nColumns )
      ::Valid[ nColIndex ] := uValid
   EndIf

   // Update validmessages
   If HB_IsArray( ::ValidMessages )
      aSize( ::ValidMessages, nColumns )
      aIns( ::ValidMessages, nColIndex )
      ::ValidMessages[ nColIndex ] := uValidMessage
   ElseIf uValidMessage != Nil
      ::ValidMessages := Array( nColumns )
      ::ValidMessages[ nColIndex ] := uValidMessage
   EndIf

   // Update when
   If HB_IsArray( ::aWhen )
      aSize( ::aWhen, nColumns )
      aIns( ::aWhen, nColIndex )
      ::aWhen[ nColIndex ] := uWhen
   ElseIf uWhen != Nil
      ::aWhen := Array( nColumns )
      ::aWhen[ nColIndex ] := uWhen
   EndIf

   // Update header image
   aSize( ::aHeaderImage, nColumns )
   aIns( ::aHeaderImage, nColIndex )
   If ! HB_IsNumeric( nHeaderImage ) .OR. nHeaderImage < 0
      nHeaderImage := 0
   EndIf
   ::HeaderImage( nColIndex, nHeaderImage )

   // Update header image alignment
   aSize( ::aHeaderImageAlign, nColumns )
   aIns( ::aHeaderImageAlign, nColIndex )
   If ! HB_IsNumeric( nHeaderImageAlign ) .OR. nHeaderImageAlign != HEADER_IMG_AT_RIGHT
      nHeaderImageAlign := HEADER_IMG_AT_LEFT
   EndIf
   ::HeaderImageAlign( nColIndex, nHeaderImageAlign )

   // Call C-Level Routine
   ListView_AddColumn( ::hWnd, nColIndex, nWidth, cCaption, nJustify, lNoDelete )

Return nColIndex

// aGrid and uDynamicColor may be passed by reference
*-----------------------------------------------------------------------------*
STATIC FUNCTION TGrid_AddColumnColor( aGrid, nColumn, uColor, uDynamicColor, nWidth, nItemCount, lNoDelete, hWnd )
*-----------------------------------------------------------------------------*
Local uTemp, x
   If ValType( uDynamicColor ) == "A"
      If Len( uDynamicColor ) < nWidth
         aSize( uDynamicColor, nWidth )
      EndIf
      aIns( uDynamicColor, nColumn )
      uDynamicColor[ nColumn ] := uColor
   ElseIf ValType( uColor ) $ "ANB"
      uTemp := uDynamicColor
      uDynamicColor := Array( nWidth )
      aFill( uDynamicColor, uTemp )
      uDynamicColor[ nColumn ] := uColor
   EndIf
   If ! lNoDelete
      uDynamicColor := Nil
   ElseIf HB_IsArray( aGrid ) .OR. ValType( uColor ) $ "ANB" .OR. ValType( uDynamicColor ) $ "ANB"
      If HB_IsArray( aGrid )
         If Len( aGrid ) < nItemCount
            aSize( aGrid, nItemCount )
         Else
            nItemCount := Len( aGrid )
         EndIf
      Else
         aGrid := Array( nItemCount )
      EndIf
      For x := 1 To nItemCount
         If HB_IsArray( aGrid[ x ] )
            If Len( aGrid[ x ] ) < nWidth
                aSize( aGrid[ x ], nWidth )
            EndIf
            aIns( aGrid[ x ], nColumn )
         Else
            aGrid[ x ] := Array( nWidth )
         EndIf
         _SetThisCellInfo( hWnd, x, nColumn, Nil )
         aGrid[ x ][ nColumn ] := _OOHG_GetArrayItem( uDynamicColor, nColumn, x )
         _ClearThisCellInfo()
      Next
   EndIf
Return Nil

*----------------------------------------------------------------------------*
METHOD ColumnBetterAutoFit( nColIndex ) CLASS Tgrid
*----------------------------------------------------------------------------*
Local n, nh
   If HB_IsNumeric( nColIndex )
      If nColindex > 0
         nh := ::ColumnAutoFitH( nColIndex )
         n := ::ColumnAutoFit( nColIndex )
         If nh > n
            ::ColumnAutoFitH( nColIndex )
         EndIf
      EndIf
   EndIf
Return Nil

*-----------------------------------------------------------------------------*
METHOD ColumnHide( nColIndex ) CLASS TGrid
*-----------------------------------------------------------------------------*
   If HB_IsNumeric( nColIndex )
      If nColindex > 0
         ::ColumnWidth( nColIndex, 0 )
      EndIf
   EndIf
Return Nil

*-----------------------------------------------------------------------------*
METHOD ColumnShow( nColIndex ) CLASS TGrid
*-----------------------------------------------------------------------------*
   If HB_IsNumeric( nColIndex )
      If nColindex > 0
         ::ColumnBetterAutoFit ( nColIndex )
      EndIf
   EndIf
Return Nil

*-----------------------------------------------------------------------------*
METHOD DeleteColumn( nColIndex, lNoDelete ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local nColumns

   // Update Headers
   nColumns := Len( ::aHeaders )
   If nColumns == 0
      Return 0
   EndIf

   If ! HB_IsNumeric( nColIndex ) .OR. nColIndex > nColumns
      nColIndex := nColumns
   ElseIf nColIndex < 1
      nColIndex := 1
   EndIf

   _OOHG_DeleteArrayItem( ::aHeaders, nColIndex )
   _OOHG_DeleteArrayItem( ::aWidths, nColIndex )
   _OOHG_DeleteArrayItem( ::Picture, nColIndex )
   _OOHG_DeleteArrayItem( ::aHeadClick, nColIndex )
   _OOHG_DeleteArrayItem( ::aJust, nColIndex )
   _OOHG_DeleteArrayItem( ::Valid, nColIndex )
   _OOHG_DeleteArrayItem( ::ValidMessages, nColIndex )
   _OOHG_DeleteArrayItem( ::aWhen, nColIndex )
   _OOHG_DeleteArrayItem( ::aHeaderImage, nColIndex )
   _OOHG_DeleteArrayItem( ::aHeaderImageAlign, nColIndex )
   _OOHG_DeleteArrayItem( ::DynamicForeColor, nColIndex )
   _OOHG_DeleteArrayItem( ::DynamicBackColor, nColIndex )

   If HB_IsLogical( lNoDelete ) .AND. lNoDelete
      If HB_IsArray( ::GridForeColor )
         aEval( ::GridForeColor, { |a| _OOHG_DeleteArrayItem( a, nColIndex ) } )
      EndIf
      If ValType( ::GridBackColor ) == "A"
         aEval( ::GridBackColor, { |a| _OOHG_DeleteArrayItem( a, nColIndex ) } )
      EndIf
   Else
      ::GridForeColor := Nil
      ::GridBackColor := Nil
   EndIf

   // Update edit control
   If HB_IsArray( ::EditControls )
      If Len( ::EditControls ) >= nColIndex
         aDel( ::EditControls, nColIndex )
      EndIf
   EndIf

   // Call C-Level Routine
   ListView_DeleteColumn( ::hWnd, nColIndex, lNoDelete )

Return nColIndex

*-----------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TGrid
*-----------------------------------------------------------------------------*
   If HB_IsNumeric( uValue )
      ListView_SetCursel( ::hWnd, uValue )
      ListView_EnsureVisible( ::hWnd, uValue )
   ELSE
      uValue := ::FirstSelectedItem
   EndIf
Return uValue

*-----------------------------------------------------------------------------*
METHOD Cell( nRow, nCol, uValue ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local aItem, uValue2 := Nil
   If nRow >= 1 .AND. nRow <= ::ItemCount
      aItem := ::Item( nRow )
      If nCol >= 1 .AND. nCol <= Len( aItem )
         If PCount() > 2
            aItem[ nCol ] := uValue
            ::Item( nRow, aItem )
         EndIf
         uValue2 := aItem[ nCol ]
      EndIf
   EndIf
Return uValue2

*-----------------------------------------------------------------------------*
METHOD EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local lRet
   If ! HB_IsNumeric( nRow )
      nRow := ::FirstSelectedItem
   EndIf
   If ! HB_IsNumeric( nCol )
      nCol := 1
   EndIf
   If nRow < 1 .OR. nRow > ::ItemCount .OR. nCol < 1 .OR. nCol > Len( ::aHeaders )
      // Cell out of range
      Return .F.
   EndIf

   If ValType( uOldValue ) == "U"
      uOldValue := ::Cell( nRow, nCol )
   EndIf

   EditControl := GetEditControlFromArray( EditControl, ::EditControls, nCol, Self )
   If ! HB_IsObject( EditControl )
      // If EditControl is not specified, check for imagelist
      If HB_IsNumeric( uOldValue )
         If HB_IsLogical( ::Picture[ nCol ] ) .AND. ::Picture[ nCol ]
            EditControl := TGridControlImageList():New( Self )
         ElseIf HB_IsNumeric( ListViewGetItem( ::hWnd, nRow, Len( ::aHeaders ) )[ nCol ] )
            EditControl := TGridControlImageList():New( Self )
         EndIf
      EndIf
   EndIf

   lRet := ::EditCell2( @nRow, @nCol, EditControl, uOldValue, @uValue, cMemVar )
   If lRet
      If ValType( uValue ) $ "CM"
         uValue := Trim( uValue )
      EndIf
      ::Cell( nRow, nCol, uValue )
      _SetThisCellInfo( ::hWnd, nRow, nCol, uValue )
      _OOHG_Eval( ::OnEditCell, nRow, nCol )
      If _CheckCellNewValue( EditControl, @uValue )
         ::Cell( nRow, nCol, uValue )
      EndIf
      _ClearThisCellInfo()
   Else
      _OOHG_Eval( ::OnAbortEdit, nRow, nCol )
   EndIf
Return lRet

// nRow, nCol and uValue may be passed by reference
*-----------------------------------------------------------------------------*
METHOD EditCell2( nRow, nCol, EditControl, uOldValue, uValue, cMemVar ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local r, r2, lRet := .F., nWidth
   If ::lNested
      Return .F.
   EndIf
   ::lNested := .T.

   If ValType( cMemVar ) != "C"
      cMemVar := "_OOHG_NULLVAR_"
   EndIf
   If ! HB_IsNumeric( nRow )
      nRow := ::FirstSelectedItem
   EndIf
   If ! HB_IsNumeric( nCol )
      nCol := 1
   EndIf

   // This var may be used in When codeblock
   _OOHG_ThisItemCellValue := ::Cell( nRow, nCol )

   If nRow < 1 .OR. nRow > ::ItemCount .OR. nCol < 1 .OR. nCol > Len( ::aHeaders )
      // Cell out of range

   ElseIf ::IsColumnReadOnly( nCol )
      // Read only column
      PlayHand()

   ElseIf ! ::IsColumnWhen( nCol )
      // Not a valid WHEN

   Else
      // Cell value
      If ValType( uOldValue ) == "U"
         uValue := ::Cell( nRow, nCol )
      Else
         uValue := uOldValue
      EndIf

      // Determines control type
      EditControl := GetEditControlFromArray( EditControl, ::EditControls, nCol, Self )
      If HB_IsObject( EditControl )
         // EditControl specified
      ElseIf ValType( ::Picture[ nCol ] ) == "C"
         // Picture-based
         EditControl := TGridControlTextBox():New( ::Picture[ nCol ],, ValType( uValue ) )
      Else
         // Checks according to data type
         EditControl := GridControlObjectByType( uValue )
      EndIf

      If ! HB_IsObject( EditControl )
         MsgExclamation( _OOHG_Messages( 1, 12 ), _OOHG_Messages( 1, 5 ) )
      Else
         r := { 0, 0, 0, 0 }                                        // left, top, right, bottom
         GetClientRect( ::hWnd, r )
         nWidth := r[ 3 ] - r[ 1 ]
         r2 := { 0, 0, 0, 0 }                                       // left, top, right, bottom
         GetWindowRect( ::hWnd, r2 )
         ListView_EnsureVisible( ::hWnd, nRow - 1 )
         r := ListView_GetSubitemRect( ::hWnd, nRow - 1, nCol - 1 ) // top, left, width, height
         r[ 3 ] := ListView_GetColumnWidth( ::hWnd, nCol - 1 )
         // Ensures cell is visible
         If r[ 2 ] + r[ 3 ] + GetVScrollBarWidth() > nWidth
            ListView_Scroll( ::hWnd, ( r[ 2 ] + r[ 3 ] + GetVScrollBarWidth() - nWidth ), 0 )
            r := ListView_GetSubitemRect( ::hWnd, nRow - 1, nCol - 1 )
            r[ 3 ] := Min( ListView_GetColumnWidth( ::hWnd, nCol - 1 ), nWidth )
         EndIf
         If r[ 2 ] < 0
            ListView_Scroll( ::hWnd, r[ 2 ], 0 )
            r := ListView_GetSubitemRect( ::hWnd, nRow - 1, nCol - 1 )
            r[ 3 ] := Min( ListView_GetColumnWidth( ::hWnd, nCol - 1 ), nWidth )
         EndIf
         r[ 1 ] += r2[ 2 ] + 2
         r[ 2 ] += r2[ 1 ] + 3

         EditControl:cMemVar := cMemVar
         If HB_IsArray( ::Valid ) .AND. Len( ::Valid ) >= nCol
            EditControl:bValid := ::Valid[ nCol ]
         EndIf
         If HB_IsArray( ::ValidMessages ) .AND. Len( ::ValidMessages ) >= nCol
            EditControl:cValidMessage := ::ValidMessages[ nCol ]
         EndIf
         If ValType( uValue ) $ "CM"
            uValue := Trim( uValue )
         EndIf
         _SetThisCellInfo( ::hWnd, nRow, nCol, uValue )
         lRet := EditControl:CreateWindow( uValue, r[ 1 ], r[ 2 ], r[ 3 ], r[ 4 ], ::FontName, ::FontSize, ::aEditKeys )
         If lRet
            uValue := EditControl:Value
         Else
            ::SetFocus()
         EndIf

         _OOHG_ThisType := ''
         _ClearThisCellInfo()

      EndIf
   EndIf
   ::lNested := .F.
Return lRet

*-----------------------------------------------------------------------------*
METHOD EditAllCells( nRow, nCol ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local lRet
   If ::FullMove
      Return ::EditGrid( nRow, nCol )
   EndIf

   If ! HB_IsNumeric( nRow )
      nRow := ::FirstSelectedItem
   EndIf
   If ! HB_IsNumeric( nCol )
      nCol := 1
   EndIf
   If nRow < 1 .OR. nRow > ::ItemCount .OR. nCol < 1 .OR. nCol > Len( ::aHeaders )
      // Cell out of range
      Return .F.
   EndIf

   lRet := .T.
   
   Do While nCol <= Len( ::aHeaders ) .AND. lRet
      _OOHG_ThisItemCellValue := ::Cell( nRow, nCol )

      If ::IsColumnReadOnly( nCol )
         // Read only column
      ElseIf ! ::IsColumnWhen( nCol )
         // Not a valid WHEN
      Else
         lRet := ::EditCell( nRow, nCol )

         If ::lAppendMode
            ::lAppendMode := .F.
            If lRet
               ::DoEvent( ::OnAppend, "APPEND" )
            Else
               ::DeleteItem( ::ItemCount )
               ::Value := ::ItemCount
            EndIf
         EndIf
      EndIf

      nCol++
   EndDo
   
   If lRet
      ListView_Scroll( ::hWnd, - _OOHG_GridArrayWidths( ::hWnd, ::aWidths ), 0 )
   EndIf
Return lRet

*-----------------------------------------------------------------------------*
FUNCTION _OOHG_TGrid_Events2( Self, hWnd, nMsg, wParam, lParam ) // CLASS TGrid
*-----------------------------------------------------------------------------*
Local aCellData, nItem, i
   Empty( lParam )

   If nMsg == WM_LBUTTONDBLCLK
      If ! ::lCheckBoxes .OR. ListView_HitOnCheckBox( hWnd, GetCursorRow() - GetWindowRow( hWnd ), GetCursorCol() - GetWindowCol( hWnd ) ) == 0
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
         _OOHG_ThisItemCellValue  := ::Cell( _OOHG_ThisItemRowIndex, _OOHG_ThisItemColIndex )

         If ! ::AllowEdit
            If HB_IsBlock( ::OnDblClick )
               ::DoEvent( ::OnDblClick, "DBLCLICK" )
            EndIf

         ElseIf ::FullMove
            If ::IsColumnReadOnly( _OOHG_ThisItemColIndex )
               // Cell is readonly
            ElseIf ! ::IsColumnWhen( _OOHG_ThisItemColIndex )
               // Not a valid WHEN
            Else
               ::EditGrid( _OOHG_ThisItemRowIndex, _OOHG_ThisItemColIndex )
            EndIf

         ElseIf ::InPlace
            If ::IsColumnReadOnly( _OOHG_ThisItemColIndex )
               // Cell is readonly
            ElseIf ! ::IsColumnWhen( _OOHG_ThisItemColIndex )
               // Not a valid WHEN
            Else
               ::EditCell( _OOHG_ThisItemRowIndex, _OOHG_ThisItemColIndex )
            EndIf

         Else
            ::EditItem()

         EndIf

         _ClearThisCellInfo()
         _PopEventInfo()
      EndIf
      Return 0

   ElseIf nMsg == WM_CHAR
      If wParam < 32
         ::cText := ""
         Return 0
      ElseIf Empty( ::cText )
         ::uIniTime := HB_MilliSeconds()
         ::cText := Upper( Chr( wParam ) )
      ElseIf HB_MilliSeconds() > ::uIniTime + ::SearchLapse
         ::uIniTime := HB_MilliSeconds()
         ::cText := Upper( Chr( wParam ) )
      Else
         ::cText += Upper( Chr( wParam ) )
      EndIf

      If ::SearchCol > 1
         nItem := 0

         If ::SearchCol <= ::ColumnCount
            For i := ::FirstSelectedItem + 1 To ::ItemCount
               If Upper( Left( ::CellCaption( i, ::SearchCol ), Len( ::cText ) ) ) == ::cText
                  nItem := i
                  Exit
               EndIf
            Next i

            If nItem == 0 .AND. ::SearchWrap
               For i := 1 To ::FirstSelectedItem
                 If Upper( Left( ::CellCaption( i, ::SearchCol ), Len( ::cText ) ) ) == ::cText
                    nItem := i
                    Exit
                 EndIf
               Next i
            EndIf
         EndIf
      Else
         nItem := ListView_FindItem( hWnd, ::FirstSelectedItem - 1, ::cText, ::SearchWrap )
      EndIf
      If nItem > 0
         ::Value := nItem
      EndIf
      Return 0

   EndIf

Return Nil

*-----------------------------------------------------------------------------*
FUNCTION _OOHG_TGrid_Notify2( Self, wParam, lParam ) // CLASS TGrid
*-----------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam )      //, nColumn := NMHeader_iItem( lParam )

   Empty( wParam )

   If nNotify == HDN_BEGINDRAG
      If HB_IsLogical( ::AllowMoveColumn ) .AND. ! ::AllowMoveColumn
         Return 1
      EndIf
   ElseIf nNotify == HDN_ENDDRAG
      // ::AllowMoveColumn
      // Termina de arrastrar el encabezado de nColumn
      // Return 1 para no permitirlo
   ElseIf nNotify == HDN_BEGINTRACK
      If HB_IsLogical( ::AllowChangeSize ) .AND. ! ::AllowChangeSize
         Return 1
      EndIf
   ElseIf nNotify == HDN_ENDTRACK
      // ::AllowChangeSize
      // Termina de cambiar el tamaño de nColumn
   ElseIf nNotify == HDN_DIVIDERDBLCLICK
      If HB_IsLogical( ::AllowChangeSize ) .AND. ! ::AllowChangeSize
         Return 1
      EndIf
   EndIf

Return Nil

*-----------------------------------------------------------------------------*
METHOD Events_Enter() CLASS TGrid
*-----------------------------------------------------------------------------*
   ::cText := ""
   If ! ::AllowEdit
      ::DoEvent( ::OnEnter, "ENTER" )
   ElseIf ::FullMove
      ::EditGrid()
   ElseIf ::InPlace
      If ! ::lNestedEdit
         ::lNestedEdit := .T.
         ::EditAllCells()
         ::lNestedEdit := .F.
      EndIf
   ElseIf ! ::lNestedEdit
      ::lNestedEdit := .T.
      ::EditItem()
      ::lNestedEdit := .F.
   EndIf
Return Nil

*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam )
Local lvc, _ThisQueryTemp, nvkey, uValue, uRet

   If nNotify == NM_CUSTOMDRAW
      uValue := ::FirstSelectedItem
      uRet := TGrid_Notify_CustomDraw( Self, lParam, .F., uValue, 0, ::lCheckBoxes, ::lFocusRect, ::lNoGrid, ::lPLM )
      ListView_SetCursel( ::hWnd, uValue )
      Return uRet

   ElseIf nNotify == LVN_KEYDOWN
      If GetGridvKeyAsChar( lParam ) == 0
         ::cText := ""
      EndIf

      nvKey := GetGridvKey( lParam )

      If nvkey == VK_DOWN
         If ::FirstSelectedItem == ::ItemCount .AND. ! ::lEditMode
            If ::Append
               ::AppendItem()
               Return Nil
            EndIf
         EndIf
      ElseIf nvkey == VK_SPACE .AND. ::lCheckBoxes
         // detect item
         uValue := ::FirstSelectedItem
         If uValue > 0
            // change check mark
            ::CheckItem( uValue, ! ::CheckItem( uValue ) )
            // skip default action
            Return 1
         EndIf
      EndIf

   ElseIf nNotify == LVN_GETDISPINFO

      // Grid OnQueryData ............................

      If HB_IsBlock( ::OnDispInfo )

         _PushEventInfo()
         _OOHG_ThisForm := ::Parent
         _OOHG_ThisType := 'C'
         _OOHG_ThisControl := Self
         _ThisQueryTemp  := GetGridDispInfoIndex( lParam )
         _OOHG_ThisQueryRowIndex  := _ThisQueryTemp [1]
         _OOHG_ThisQueryColIndex  := _ThisQueryTemp [2]
         ::DoEvent( ::OnDispInfo, "DISPINFO" )
         If HB_IsNumeric( _OOHG_ThisQueryData )
            SetGridQueryImage ( lParam, _OOHG_ThisQueryData )
         ElseIf ValType( _OOHG_ThisQueryData ) $ "CM"
            SetGridQueryData ( lParam, _OOHG_ThisQueryData )
         EndIf
         _OOHG_ThisQueryRowIndex  := 0
         _OOHG_ThisQueryColIndex  := 0
         _OOHG_ThisQueryData := ""
         _PopEventInfo()
      EndIf

   ElseIf nNotify == LVN_ITEMCHANGED
      If GetGridOldState( lParam ) == 0 .AND. GetGridNewState( lParam ) != 0
         ::DoChange()
         Return Nil
      EndIf

   ElseIf nNotify == LVN_COLUMNCLICK
      If HB_IsArray ( ::aHeadClick )
         lvc := GetGridColumn( lParam ) + 1
         If Len( ::aHeadClick ) >= lvc
            _SetThisCellInfo( ::hWnd, 0, lvc )
            ::DoEvent( ::aHeadClick[ lvc ], "HEADCLICK", { lvc } )
            _ClearThisCellInfo()
            Return Nil
         EndIf
      EndIf

   ElseIf nNotify == LVN_ENDSCROLL
      // There is a bug in ListView under XP that causes the gridlines to be
      // incorrectly scrolled when the left button is clicked to scroll.
      // This is supposedly documented at KB 813791.
      RedrawWindow( ::hWnd )

   ElseIf nNotify == NM_CLICK
      If ::lCheckBoxes .AND. HB_IsBlock( ::OnCheckChange )
         // detect item
         uValue := ListView_HitOnCheckBox( ::hWnd, GetCursorRow() - GetWindowRow( ::hWnd ), GetCursorCol() - GetWindowCol( ::hWnd ) )
      Else
         uValue := 0
      EndIf

      If HB_IsBlock( ::OnClick )
         If ! ::NestedClick
            ::NestedClick := ! _OOHG_NestedSameEvent()
            ::DoEvent( ::OnClick, "CLICK" )
            ::NestedClick := .F.
         EndIf
      EndIf

      If uValue > 0
         // change check mark
         ::CheckItem( uValue, ! ::CheckItem( uValue ) )
         // skip default action
         Return 1
      EndIf

   ElseIf nNotify == NM_RCLICK
      If ::lCheckBoxes .AND. HB_IsBlock( ::OnCheckChange )
         // detect item
         uValue := ListView_HitOnCheckBox( ::hWnd, GetCursorRow() - GetWindowRow( ::hWnd ), GetCursorCol() - GetWindowCol( ::hWnd ) )
      Else
         uValue := 0
      EndIf

      If HB_IsBlock( ::OnRClick )
         ::DoEvent( ::OnRClick, "RCLICK" )
      EndIf

      If uValue > 0
         // change check mark
         ::CheckItem( uValue, ! ::CheckItem( uValue ) )
         // fire context menu
         If ::ContextMenu != nil
            ::ContextMenu:Activate()
         EndIf
         // skip default action
         Return 1
      EndIf

   EndIf

Return ::Super:Events_Notify( wParam, lParam )

*-----------------------------------------------------------------------------*
METHOD AddItem( aRow, uForeColor, uBackColor ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local aText
   If Len( ::aHeaders ) != Len( aRow )
      MsgOOHGError( "Grid.AddItem: Item size mismatch. Program Terminated." )
   EndIf

   aText := TGrid_SetArray( Self, aRow )
   ::SetItemColor( ::ItemCount + 1, uForeColor, uBackColor, aRow )
   AddListViewItems( ::hWnd, aText )
Return Nil

*-----------------------------------------------------------------------------*
METHOD InsertItem( nItem, aRow, uForeColor, uBackColor ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local aText
   If Len( ::aHeaders ) != Len( aRow )
      MsgOOHGError( "Grid.InsertItem: Item size mismatch. Program Terminated." )
   EndIf

   aText := TGrid_SetArray( Self, aRow )
   nItem := ::InsertBlank( nItem )
   If nItem > 0
      ::SetItemColor( nItem, uForeColor, uBackColor, aRow )
      ListViewSetItem( ::hWnd, aText, nItem )
   EndIf
Return nItem

*-----------------------------------------------------------------------------*
METHOD InsertBlank( nItem ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local aGrid
   aGrid := ::GridForeColor
   If HB_IsArray( aGrid ) .AND. Len( aGrid ) >= nItem
      aAdd( aGrid, Nil )
      aIns( aGrid, nItem )
   EndIf
   aGrid := ::GridBackColor
   If HB_IsArray( aGrid ) .AND. Len( aGrid ) >= nItem
      aAdd( aGrid, Nil )
      aIns( aGrid, nItem )
   EndIf
Return InsertListViewItem( ::hWnd, Array( Len( ::aHeaders ) ), nItem )

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
   If PCount() > 1
      aTemp := TGrid_SetArray( Self, uValue )
      ::SetItemColor( nItem, uForeColor, uBackColor, uValue )
      ListViewSetItem( ::hWnd, aTemp, nItem )
   EndIf
   uValue := ListViewGetItem( ::hWnd, nItem, Len( ::aHeaders ) )
   If HB_IsArray( ::EditControls )
      For nColumn := 1 To Len( uValue )
         oEditControl := GetEditControlFromArray( Nil, ::EditControls, nColumn, Self )
         If HB_IsObject( oEditControl )
            If oEditControl:Type == "TGRIDCONTROLIMAGEDATA"
               // when the column has images, ListViewGetItem returns only the image's index number
               uValue[ nColumn ] := { ::CellCaption( nItem, nColumn ), ::CellImage( nItem, nColumn ) }
            EndIf
            uValue[ nColumn ] := oEditControl:Str2Val( uValue[ nColumn ] )
         EndIf
      Next
   EndIf
Return uValue

*-----------------------------------------------------------------------------*
FUNCTION TGrid_SetArray( Self, uValue )
*-----------------------------------------------------------------------------*
Local aTemp, nColumn, xValue, oEditControl
   aTemp := Array( Len( uValue ) )
   For nColumn := 1 To Len( uValue )
      xValue := uValue[ nColumn ]
      oEditControl := GetEditControlFromArray( Nil, ::EditControls, nColumn, Self )
      If HB_IsObject( oEditControl )
         aTemp[ nColumn ] := oEditControl:GridValue( xValue )
      ElseIf ValType( ::Picture[ nColumn ] ) $ "CM"
         aTemp[ nColumn ] := Trim( Transform( xValue, ::Picture[ nColumn ] ) )
      Else
         aTemp[ nColumn ] := xValue
      EndIf
   Next
Return aTemp

*-----------------------------------------------------------------------------*
METHOD SetItemColor( nItem, uForeColor, uBackColor, uExtra ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local nWidth
   nWidth := Len( ::aHeaders )
   If ! HB_IsArray( uExtra )
      uExtra := Array( nWidth )
   ElseIf Len( uExtra ) < nWidth
      aSize( uExtra, nWidth )
   EndIf
   ::GridForeColor := TGrid_CreateColorArray( ::GridForeColor, nItem, uForeColor, ::DynamicForeColor, nWidth, uExtra, ::hWnd )
   ::GridBackColor := TGrid_CreateColorArray( ::GridBackColor, nItem, uBackColor, ::DynamicBackColor, nWidth, uExtra, ::hWnd )
Return Nil

*-----------------------------------------------------------------------------*
STATIC FUNCTION TGrid_CreateColorArray( aGrid, nItem, uColor, uDynamicColor, nWidth, uExtra, hWnd )
*-----------------------------------------------------------------------------*
Local aTemp, nLen
   If ! ValType( uColor ) $ "ANB" .AND. ValType( uDynamicColor ) $ "ANB"
      uColor := uDynamicColor
   EndIf
   If ValType( uColor ) $ "ANB"
      If HB_IsArray( aGrid )
         If Len( aGrid ) < nItem
            aSize( aGrid, nItem )
         EndIf
      ELSE
         aGrid := Array( nItem )
      EndIf
      aTemp := Array( nWidth )
      If HB_IsArray( uColor ) .AND. Len( uColor ) < nWidth
         nLen := Len( uColor )
         uColor := aClone( uColor )
         If ValType( uDynamicColor ) $ "NB"
            aSize( uColor, nWidth )
            aFill( uColor, uDynamicColor, nLen + 1 )
         ElseIf HB_IsArray( uDynamicColor ) .AND. Len( uDynamicColor ) > nLen
            aSize( uColor, Min( nWidth, Len( uDynamicColor ) ) )
            aEval( uColor, { |x,i| uColor[ i ] := uDynamicColor[ i ], x }, nLen + 1 )
         EndIf
      EndIf
      aEval( aTemp, { |x,i| _SetThisCellInfo( hWnd, nItem, i, uExtra[ i ] ), aTemp[ i ] := _OOHG_GetArrayItem( uColor, i, nItem, uExtra ), x } )
      _ClearThisCellInfo()
      aGrid[ nItem ] := aTemp
   EndIf
Return aGrid

*-----------------------------------------------------------------------------*
METHOD Justify( nColumn, uValue ) CLASS TGrid
*-----------------------------------------------------------------------------*
   If HB_IsNumeric( uValue )
      ::aJust[ nColumn ] := uValue
      SetGridColumnJustify( ::hWnd, nColumn, uValue )
   EndIf
Return ::aJust[ nColumn ]

*-----------------------------------------------------------------------------*
METHOD Header( nColumn, uValue ) CLASS TGrid
*-----------------------------------------------------------------------------*
   If ValType( uValue ) $ "CM"
      ::aHeaders[ nColumn ] := uValue
      SetGridColumnHeader( ::hWnd, nColumn, uValue )
   EndIf
Return ::aHeaders[ nColumn ]

*-----------------------------------------------------------------------------*
METHOD HeaderImage( nColumn, nImg ) CLASS TGrid
*-----------------------------------------------------------------------------*
   If HB_IsNumeric( nImg ) .AND. nImg >= 0 .AND. nImg # ::aHeaderImage[ nColumn ]
      ::aHeaderImage[ nColumn ] := nImg
      
      If nImg == 0
        RemoveGridColumnImage( ::hWnd, nColumn )
      ElseIf ValidHandler( ::HeaderImageList )
        SetGridColumnImage( ::hWnd, nColumn, nImg, .F. )
      EndIf
   EndIf
Return ::aHeaderImage[ nColumn ]

*-----------------------------------------------------------------------------*
METHOD HeaderImageAlign( nColumn, nPlace ) CLASS TGrid
*-----------------------------------------------------------------------------*
   If ::aHeaderImage[ nColumn ] != 0
      If HB_IsNumeric( nPlace )
         If nPlace == HEADER_IMG_AT_RIGHT
            ::aHeaderImageAlign[ nColumn ] := HEADER_IMG_AT_RIGHT

            If ValidHandler( ::HeaderImageList )
               SetGridColumnImage( ::hWnd, nColumn, ::aHeaderImage[ nColumn ], .T. )
            EndIf
         ELSE
            ::aHeaderImageAlign[ nColumn ] := HEADER_IMG_AT_LEFT

            If ValidHandler( ::HeaderImageList )
               SetGridColumnImage( ::hWnd, nColumn, ::aHeaderImage[ nColumn ], .F. )
            EndIf
         EndIf
      EndIf
   EndIf
Return ::aHeaderImageAlign[ nColumn ]

*------------------------------------------------------------------------------*
METHOD Release() CLASS TGrid
*------------------------------------------------------------------------------*

   If ValidHandler( ::HeaderImageList )
      ImageList_Destroy( ::HeaderImageList )
      ::HeaderImageList := Nil
   EndIf

Return ::Super:Release()

*-----------------------------------------------------------------------------*
METHOD SetRangeColor( uForeColor, uBackColor, nTop, nLeft, nBottom, nRight ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local nAux, nLong := ::ItemCount
   If ! HB_IsNumeric( nBottom )
      nBottom := nTop
   EndIf
   If ! HB_IsNumeric( nRight )
      nRight := nLeft
   EndIf
   If nTop > nBottom
      nAux := nBottom
      nBottom := nTop
      nTop := nAux
   EndIf
   If nLeft > nRight
      nAux := nRight
      nRight := nLeft
      nLeft := nAux
   EndIf
   If nBottom > nLong
      nBottom := nLong
   EndIf
   If nRight > Len( ::aHeaders )
      nRight := Len( ::aHeaders )
   EndIf
   If nTop <= nLong .AND. nLeft <= Len( ::aHeaders ) .AND. nTop >= 1 .AND. nLeft >= 1
      ::GridForeColor := TGrid_FillColorArea( ::GridForeColor, uForeColor, nTop, nLeft, nBottom, nRight, ::hWnd )
      ::GridBackColor := TGrid_FillColorArea( ::GridBackColor, uBackColor, nTop, nLeft, nBottom, nRight, ::hWnd )
   EndIf
Return Nil

*-----------------------------------------------------------------------------*
STATIC FUNCTION TGrid_FillColorArea( aGrid, uColor, nTop, nLeft, nBottom, nRight, hWnd )
*-----------------------------------------------------------------------------*
Local nAux
   If ValType( uColor ) $ "ANB"
      If ! HB_IsArray( aGrid )
         aGrid := Array( nBottom )
      ElseIf Len( aGrid ) < nBottom
         aSize( aGrid, nBottom )
      EndIf
      For nAux := nTop To nBottom
         If ! HB_IsArray( aGrid[ nAux ] )
            aGrid[ nAux ] := Array( nRight )
         ElseIf Len( aGrid[ nAux ] ) < nRight
            aSize( aGrid[ nAux ], nRight )
         EndIf
         aEval( aGrid[ nAux ], { |x,i| _SetThisCellInfo( hWnd, nAux, i ), aGrid[ nAux ][ i ] := _OOHG_GetArrayItem( uColor, i, nAux ), x }, nLeft, ( nRight - nLeft + 1 ) )
         _ClearThisCellInfo()
      Next
   EndIf
Return aGrid

*-----------------------------------------------------------------------------*
METHOD ColumnWidth( nColumn, nWidth ) CLASS TGrid
*-----------------------------------------------------------------------------*
   If HB_IsNumeric( nColumn ) .AND. nColumn >= 1 .AND. nColumn <= Len( ::aHeaders )
      If HB_IsNumeric( nWidth )
         nWidth := ListView_SetColumnWidth( ::hWnd, nColumn - 1, nWidth )
      Else
         nWidth := ListView_GetColumnWidth( ::hWnd, nColumn - 1 )
      EndIf
      ::aWidths[ nColumn ] := nWidth
   Else
      nWidth := 0
   EndIf
Return nWidth

*-----------------------------------------------------------------------------*
METHOD ColumnAutoFit( nColumn ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local nWidth
   If HB_IsNumeric( nColumn ) .AND. nColumn >= 1 .AND. nColumn <= Len( ::aHeaders )
      nWidth := ListView_SetColumnWidth( ::hWnd, nColumn - 1, LVSCW_AUTOSIZE )
      If nColumn == 1
         nWidth := nWidth + 6
         nWidth := ListView_SetColumnWidth( ::hWnd, nColumn - 1, nWidth )
      EndIf
      ::aWidths[ nColumn ] := nWidth
   Else
      nWidth := 0
   EndIf
Return nWidth

*-----------------------------------------------------------------------------*
METHOD ColumnAutoFitH( nColumn ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local nWidth
   If HB_IsNumeric( nColumn ) .AND. nColumn >= 1 .AND. nColumn <= Len( ::aHeaders )
      nWidth := ListView_SetColumnWidth( ::hWnd, nColumn - 1, LVSCW_AUTOSIZE_USEHEADER )
      If nColumn == 1
         nWidth := nWidth + 6
         nWidth := ListView_SetColumnWidth( ::hWnd, nColumn - 1, nWidth )
      EndIf
      ::aWidths[ nColumn ] := nWidth
   Else
      nWidth := 0
   EndIf
Return nWidth

*-----------------------------------------------------------------------------*
METHOD ColumnsBetterAutoFit() CLASS TGrid
*-----------------------------------------------------------------------------*
Local nColumn
   For nColumn := 1 To Len( ::aHeaders )
       ::ColumnBetterAutoFit ( nColumn )
   Next nColumn
Return Nil

*-----------------------------------------------------------------------------*
METHOD ColumnsAutoFit() CLASS TGrid
*-----------------------------------------------------------------------------*
Local nColumn, nWidth
   For nColumn := 1 To Len( ::aHeaders )
      nWidth := ListView_SetColumnWidth( ::hWnd, nColumn - 1, LVSCW_AUTOSIZE )
      ::aWidths[ nColumn ] := nWidth
   Next
Return nWidth

*-----------------------------------------------------------------------------*
METHOD ColumnsAutoFitH() CLASS TGrid
*-----------------------------------------------------------------------------*
Local nColumn, nWidth
   For nColumn := 1 To Len( ::aHeaders )
      nWidth := ListView_SetColumnWidth( ::hWnd, nColumn - 1, LVSCW_AUTOSIZE_USEHEADER )
      ::aWidths[ nColumn ] := nWidth
   Next
Return nWidth

*-----------------------------------------------------------------------------*
METHOD SortColumn( nColumn, lDescending ) CLASS TGrid
*-----------------------------------------------------------------------------*
Return ListView_SortItemsEx( ::hWnd, nColumn, lDescending )

*---------------------------------------------------------------------------*
METHOD ItemHeight() CLASS TGrid
*---------------------------------------------------------------------------*
Local aCellRect
   aCellRect := ListView_GetSubitemRect( ::hWnd, 0, 0 )
Return aCellRect[ 4 ]





CLASS TGridMulti FROM TGrid
   DATA Type         INIT "MULTIGRID" READONLY

   METHOD Define
   METHOD Value      SETGET
   METHOD AppendItem
   METHOD EditGrid
   METHOD Down
   METHOD Up
   METHOD PageUp
   METHOD PageDown
   METHOD GoTop
   METHOD GoBottom
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
               aRows, value, fontname, fontsize, tooltip, change, dblclick, ;
               aHeadClick, gotfocus, lostfocus, nogrid, aImage, aJust, ;
               break, HelpId, bold, italic, underline, strikeout, ownerdata, ;
               ondispinfo, itemcount, editable, backcolor, fontcolor, ;
               dynamicbackcolor, dynamicforecolor, aPicture, lRtl, inplace, ;
               editcontrols, readonly, valid, validmessages, editcell, ;
               aWhenFields, lDisabled, lNoTabStop, lInvisible, lHasHeaders, ;
               onenter, aHeaderImage, aHeaderImageAlign, FullMove, ;
               aSelectedColors, aEditKeys, lCheckBoxes, oncheck, lDblBffr, ;
               lFocusRect, lPLM, lFixedCols, abortedit, click ) CLASS TGridMulti
*-----------------------------------------------------------------------------*
Local nStyle := 0

   ::Define2( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
              aRows, value, fontname, fontsize, tooltip, change, dblclick, ;
              aHeadClick, gotfocus, lostfocus, nogrid, aImage, aJust, ;
              break, HelpId, bold, italic, underline, strikeout, ownerdata, ;
              ondispinfo, itemcount, editable, backcolor, fontcolor, ;
              dynamicbackcolor, dynamicforecolor, aPicture, lRtl, nStyle, ;
              inplace, editcontrols, readonly, valid, validmessages, ;
              editcell, aWhenFields, lDisabled, lNoTabStop, lInvisible, ;
              lHasHeaders, onenter, aHeaderImage, aHeaderImageAlign, FullMove, ;
              aSelectedColors, aEditKeys, lCheckBoxes, oncheck, lDblBffr, ;
              lFocusRect, lPLM, lFixedCols, abortedit, click )
Return Self

*-----------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TGridMulti
*-----------------------------------------------------------------------------*
   If HB_IsArray( uValue )
      ListViewSetMultiSel( ::hWnd, uValue )
      If Len( uValue ) > 0
         ListView_EnsureVisible( ::hWnd, uValue[ 1 ] )
      EndIf
   EndIf
RETURN ListViewGetMultiSel( ::hWnd )

*--------------------------------------------------------------------------*
METHOD AppendItem() CLASS TGridMulti
*--------------------------------------------------------------------------*
   ::lAppendMode := .T.
   ::InsertBlank( ::ItemCount + 1 )
   ::Value := { ::ItemCount }
   ::Events_Enter()
Return Nil

*--------------------------------------------------------------------------*
METHOD EditGrid( nRow, nCol ) CLASS TGridMulti
*--------------------------------------------------------------------------*
Local lRet
   If ! HB_IsNumeric( nRow )
      nRow := ::FirstSelectedItem
   EndIf
   If ! HB_IsNumeric( nCol )
      nCol := 1
   EndIf
   If nRow < 1 .OR. nRow > ::ItemCount .OR. nCol < 1 .OR. nCol > Len( ::aHeaders )
      // Cell out of range
      Return .F.
   EndIf
   ::nRowPos := nRow
   ::nColPos := nCol

   lRet := .T.

   Do While ::nColPos <= Len( ::aHeaders ) .AND. ::nRowPos <= ::ItemCount .AND. lRet
      _OOHG_ThisItemCellValue := ::Cell( ::nRowPos, ::nColPos )

      If ::IsColumnReadOnly( ::nColPos )
         // Read only column
      ElseIf ! ::IsColumnWhen( ::nColPos )
         // Not a valid WHEN
      Else

         ::leditmode:=.T.
         lRet := ::EditCell( ::nRowPos, ::nColPos )
         ::leditmode:=.F.

         If ::lAppendMode
            ::lAppendMode:=.F.
            If lRet
               ::DoEvent( ::OnAppend, "APPEND" )
            Else
               ::DeleteItem( ::ItemCount )
               ::Value := { ::ItemCount }
               ::nRowPos := ::FirstSelectedItem
            EndIf
         EndIf

         If ! lRet
            Exit
         EndIf
      EndIf

      // ::OnEditCell() may change ::nRowPos and/or ::nColPos using ::Up(),
      // ::Down(), ::Left() and/or ::Right()
      If ::nColPos < Len( ::aHeaders )
         ::nColPos ++
      Else
         If ::FullMove
            If ::nRowPos == ::ItemCount
               If ::Append
                  // Add a new item
                  ::lAppendMode := .T.
                  ::InsertBlank( ::ItemCount + 1 )
               Else
                  Exit
               EndIf
            EndIf

            ::nRowPos ++
            ::nColPos := 1
         Else
            Exit
         EndIf
      EndIf

      ::Value := { ::nRowPos }
   EndDo

   If lRet
      ListView_Scroll( ::hWnd, - _OOHG_GridArrayWidths( ::hWnd, ::aWidths ), 0)
   EndIf
Return lRet

*--------------------------------------------------------------------------*
METHOD Down() CLASS TGridMulti
*--------------------------------------------------------------------------*
   If ::lEditMode
      If ::nRowPos < ::ItemCount
         ::nRowPos ++
      EndIf
   Else
      If ::FirstSelectedItem < ::ItemCount
         ::Value := { ::FirstSelectedItem + 1 }
      ElseIf ::Append
         ::AppendItem()
      EndIf
   EndIf
Return Self

*--------------------------------------------------------------------------*
METHOD Up() CLASS TGridMulti
*--------------------------------------------------------------------------*
   If ::lEditMode
      If ::nRowPos > 1
         ::nRowPos --
      EndIf
   Else
      If ::FirstSelectedItem > 1
         ::Value := { ::FirstSelectedItem - 1 }
      EndIf
   EndIf
Return Self

*--------------------------------------------------------------------------*
METHOD PageUp() CLASS TGridMulti
*--------------------------------------------------------------------------*
   If ::lEditMode
      If ::nRowPos > ::CountPerPage
         ::nRowPos -= ::CountPerPage
      Else
         ::nRowPos := 1
      EndIf
   Else
      If ::FirstSelectedItem > ::CountPerPage
         ::Value := { ::FirstSelectedItem - ::CountPerPage }
      Else
         ::GoTop()
      EndIf
   EndIf
Return Self

*-------------------------------------------------------------------------*
METHOD PageDown() CLASS TGridMulti
*-------------------------------------------------------------------------*
   If ::lEditMode
      If ::nRowPos < ::ItemCount - ::CountPerPage
         ::nRowPos += ::CountPerPage
      Else
         ::nRowPos := ::ItemCount
      EndIf
   Else
      If ::FirstSelectedItem < ::ItemCount - ::CountPerPage
         ::Value := { ::FirstSelectedItem + ::CountPerPage }
      Else
         ::GoBottom()
      EndIf
   EndIf
Return Self

*---------------------------------------------------------------------------*
METHOD GoTop() CLASS TGridMulti
*---------------------------------------------------------------------------*
   If ::ItemCount > 0
      ::Value := { 1 }
   EndIf
Return Self

*---------------------------------------------------------------------------*
METHOD GoBottom() CLASS TGridMulti
*---------------------------------------------------------------------------*
   If ::ItemCount > 0
      ::Value := { ::Itemcount }
   EndIf
Return Self





CLASS TGridByCell FROM TGrid
   DATA Type                INIT "GRIDBYCELL" READONLY
   DATA nRowPos             INIT 0 HIDDEN
   DATA nColPos             INIT 0 HIDDEN

   METHOD Define
   METHOD Value             SETGET
   METHOD AppendItem
   METHOD EditGrid
   METHOD Right
   METHOD Left
   METHOD Down
   METHOD Up
   METHOD PageUp
   METHOD PageDown
   METHOD GoTop
   METHOD GoBottom
   METHOD IsColumnWhen
   METHOD AddColumn
   METHOD ColumnHide
   METHOD DeleteColumn
   METHOD EditCell
   METHOD EditCell2
   METHOD Events
   METHOD Events_Enter
   METHOD Events_Notify
   METHOD DeleteItem
   METHOD DoChange
   METHOD SetSelectedColors SETGET

   METHOD EditItem          BLOCK {|| Nil }
   METHOD EditItem2         BLOCK {|| Nil }

   MESSAGE EditAllCells     METHOD EditGrid
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
               aRows, value, fontname, fontsize, tooltip, change, dblclick, ;
               aHeadClick, gotfocus, lostfocus, nogrid, aImage, aJust, ;
               break, HelpId, bold, italic, underline, strikeout, ownerdata, ;
               ondispinfo, itemcount, editable, backcolor, fontcolor, ;
               dynamicbackcolor, dynamicforecolor, aPicture, lRtl, inplace, ;
               editcontrols, readonly, valid, validmessages, editcell, ;
               aWhenFields, lDisabled, lNoTabStop, lInvisible, lHasHeaders, ;
               onenter, aHeaderImage, aHeaderImageAlign, FullMove, ;
               aSelectedColors, aEditKeys, lCheckBoxes, oncheck, lDblBffr, ;
               lFocusRect, lPLM, lFixedCols, abortedit, click ) CLASS TGridByCell
*-----------------------------------------------------------------------------*
Local nStyle := LVS_SINGLESEL

   ASSIGN lFocusRect VALUE lFocusRect TYPE "L" DEFAULT .F.

   ::Define2( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
              aRows, value, fontname, fontsize, tooltip, change, dblclick, ;
              aHeadClick, gotfocus, lostfocus, nogrid, aImage, aJust, ;
              break, HelpId, bold, italic, underline, strikeout, ownerdata, ;
              ondispinfo, itemcount, editable, backcolor, fontcolor, ;
              dynamicbackcolor, dynamicforecolor, aPicture, lRtl, nStyle, ;
              InPlace, editcontrols, readonly, valid, validmessages, ;
              editcell, aWhenFields, lDisabled, lNoTabStop, lInvisible, ;
              lHasHeaders, onenter, aHeaderImage, aHeaderImageAlign, FullMove, ;
              aSelectedColors, aEditKeys, lCheckBoxes, oncheck, lDblBffr, ;
              lFocusRect, lPLM, lFixedCols, abortedit, click )

   // By default, search in the current column
   ::SearchCol := 0

   // This is not really needed because TGridByCell ignores it
   ::InPlace := .T.

Return Self

*-----------------------------------------------------------------------------*
METHOD SetSelectedColors( aSelectedColors, lRedraw ) CLASS TGridByCell
*-----------------------------------------------------------------------------*
Local i, aColors[ 8 ]

   If HB_IsArray( aSelectedColors )
      aSelectedColors := aClone( aSelectedColors )
      aSize( aSelectedColors, 8 )

      // For text of selected cell when grid has the focus
      If ! ValType( aSelectedColors[ 1 ] ) $ "ANB"
         aSelectedColors[ 1 ] := GetSysColor( COLOR_HIGHLIGHTTEXT )
      EndIf
      // For background of selected cell when grid has the focus
      If ! ValType( aSelectedColors[ 2 ] ) $ "ANB"
         aSelectedColors[ 2 ] := GetSysColor( COLOR_HIGHLIGHT )
      EndIf
      // For text of selected cell when grid doesn't has the focus
      If ! ValType( aSelectedColors[ 3 ] ) $ "ANB"
         aSelectedColors[ 3 ] := GetSysColor( COLOR_WINDOWTEXT )
      EndIf
      // For background of selected cell when grid doesn't has the focus
      If ! ValType( aSelectedColors[ 4 ] ) $ "ANB"
         aSelectedColors[ 4 ] := GetSysColor( COLOR_3DFACE )
      EndIf

      // For text of other cells in the selected row when grid has the focus
      If ! ValType( aSelectedColors[ 5 ] ) $ "ANB"
         aSelectedColors[ 5 ] := -1                    // defaults to DYNAMICFORECOLOR, or FONTCOLOR or COLOR_WINDOWTEXT
      EndIf
      // For background of other cells in the selected row when grid has the focus
      If ! ValType( aSelectedColors[ 6 ] ) $ "ANB"
         aSelectedColors[ 6 ] := -1                    // defaults to DYNAMICBACKCOLOR, or BACKCOLOR or COLOR_WINDOW
      EndIf
      // For text of other cells in the selected row when grid doesn't has the focus
      If ! ValType( aSelectedColors[ 7 ] ) $ "ANB"
         aSelectedColors[ 7 ] := -1                    // defaults to DYNAMICFORECOLOR, or FONTCOLOR or COLOR_WINDOWTEXT
      EndIf
      // For background of other cells in the selected row when grid doesn't has the focus
      If ! ValType( aSelectedColors[ 8 ] ) $ "ANB"
         aSelectedColors[ 8 ] := -1                    // defaults to DYNAMICBACKCOLOR, or BACKCOLOR or COLOR_WINDOW
      EndIf

      ::aSelectedColors := aSelectedColors

      For i := 1 to 8
         aColors[ i ] := _OOHG_GetArrayItem( aSelectedColors, i )
      Next i

      ::GridSelectedColors := aColors

      If lRedraw
         RedrawWindow( ::hWnd )
      EndIf
   Else
      aSelectedColors := aClone( ::aSelectedColors )
   EndIf

Return aSelectedColors

*-----------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TGridByCell
*-----------------------------------------------------------------------------*
   If HB_IsArray( uValue ) .AND. Len( uValue ) > 1 .AND. HB_IsNumeric( uValue[ 1 ] ) .AND. HB_IsNumeric( uValue[ 2 ] )
      If uValue[ 1 ] < 1 .OR. uValue[ 1 ] > ::ItemCount .OR. uValue[ 2 ] < 1 .OR. uValue[ 2 ] > Len( ::aHeaders )
         uValue[ 1 ] := 0
         uValue[ 2 ] := 0
      EndIf

      ::nRowPos := uValue[ 1 ]
      ::nColPos := uValue[ 2 ]

      ListView_SetCursel( ::hWnd, uValue[ 1 ] )
      ListView_EnsureVisible( ::hWnd, uValue[ 1 ] )
      ListView_RedrawItems( ::hWnd, uValue[ 1 ], uValue[ 1 ] )
      ::DoChange()
   Else
      uValue := { ::nRowPos, ::nColPos }
   EndIf
RETURN uValue

*--------------------------------------------------------------------------*
METHOD AppendItem() CLASS TGridByCell
*--------------------------------------------------------------------------*
   ::lAppendMode := .T.
   ::InsertBlank( ::ItemCount + 1 )
   ::Value := { ::ItemCount, 1 }
   ::Events_Enter()
Return Nil

*--------------------------------------------------------------------------*
METHOD EditGrid( nRow, nCol ) CLASS TGridByCell
*--------------------------------------------------------------------------*
Local lRet, uValue
   uValue := ::Value

   If ! HB_IsNumeric( nRow )
      If uValue[ 1 ] > 0
         nRow := uValue[ 1 ]
      Else
         nRow := 1
      EndIf
   EndIf
   If ! HB_IsNumeric( nCol )
      If uValue[ 2 ] > 0
         nCol := uValue[ 2 ]
      Else
         nCol := 1
      EndIf
   EndIf
   If nRow < 1 .OR. nRow > ::ItemCount .OR. nCol < 1 .OR. nCol > Len( ::aHeaders )
      // Cell out of range
      Return .F.
   EndIf
   uValue := ::Value := { nRow, nCol }

   lRet := .T.

   Do While uValue[ 2 ] <= Len( ::aHeaders ) .AND. uValue[ 1 ] <= ::ItemCount .AND. lRet
      _OOHG_ThisItemCellValue := ::Cell( uValue[ 1 ], uValue[ 2 ] )

      If ::IsColumnReadOnly( uValue[ 2 ] )
         // Read only column
      ElseIf ! ::IsColumnWhen( uValue[ 2 ] )
         // Not a valid WHEN
      Else
         // Edit one cell
         ::leditmode := .T.
         lRet := ::EditCell( uValue[ 1 ], uValue[ 2 ] )
         ::leditmode := .F.

         If ::lAppendMode
            ::lAppendMode := .F.
            If lRet
               ::DoEvent( ::OnAppend, "APPEND" )
            Else
               ::DeleteItem( ::ItemCount )
               ::Value := { ::ItemCount, Len( ::aHeaders ) }
            EndIf
         EndIf

         If ! lRet
            Exit
         EndIf
      EndIf

      // ::OnEditCell() may change ::Value using ::Up(), ::Down(), ::Left(),
      // ::Right(), ::PageUp(), ::PageDown(), ::GoTop() and/or ::GoBottom()
      uValue := ::Value
      If uValue[ 2 ] < Len( ::aHeaders )
         ::Value := { uValue[ 1 ], uValue[ 2 ] + 1 }
      ElseIf ::FullMove
         If uValue[ 1 ] < ::ItemCount
            ::Value := { uValue[ 1 ] + 1, 1 }
         ElseIf ::Append
            // Add a new item
            ::lAppendMode := .T.
            ::InsertBlank( ::ItemCount + 1 )
            ::Value := { ::ItemCount, 1 }
         Else
            ::Value := { 1, 1 }
         EndIf
      Else
         Exit
      EndIf

      uValue := ::Value
   EndDo

   // TODO: revisar si esto es necesario
   If lRet
      ListView_Scroll( ::hWnd, - _OOHG_GridArrayWidths( ::hWnd, ::aWidths ), 0)
   EndIf
Return lRet

*--------------------------------------------------------------------------*
METHOD Right() CLASS TGridByCell
*--------------------------------------------------------------------------*
Local uValue
   uValue := ::Value

   If uValue[ 1 ] < 1 .OR. uValue[ 1 ] > ::ItemCount .OR. uValue[ 2 ] < 1 .or. uValue[ 2 ] > Len( ::aHeaders )
      ::Value := { 1, 1 }
   ElseIf uValue[ 2 ] < Len( ::aHeaders )
      ::Value := { uValue[ 1 ], uValue[ 2 ] + 1 }
   ElseIf uValue[ 1 ] < ::ItemCount
      If ::FullMove
         ::Value := { uValue[ 1 ] + 1, 1 }
      Else
         // ignore
      EndIf
   ElseIf ::lNestedEdit
      // EditGrid is active, ignore de command
   ElseIf ::Append
      ::AppendItem()
   ElseIf ::FullMove
      ::Value := { 1, 1 }
   EndIf
Return Self

*--------------------------------------------------------------------------*
METHOD Left() CLASS TGridByCell
*--------------------------------------------------------------------------*
Local uValue
   uValue := ::Value

   If uValue[ 1 ] < 1 .OR. uValue[ 1 ] > ::ItemCount .OR. uValue[ 2 ] < 1 .or. uValue[ 2 ] > Len( ::aHeaders )
      // ignore
   ElseIf uValue[ 2 ] > 1
      ::Value := { uValue[ 1 ], uValue[ 2 ] - 1 }
   ElseIf ::FullMove
      If uValue[ 1 ] > 1
         ::Value := { uValue[ 1 ] - 1, Len( ::aHeaders ) }
      Else
         ::Value := { ::ItemCount, Len( ::aHeaders ) }
      EndIf
   Else
      // ignore
   EndIf
Return Self

*--------------------------------------------------------------------------*
METHOD Up() CLASS TGridByCell
*--------------------------------------------------------------------------*
Local uValue
   uValue := ::Value

   If uValue[ 1 ] < 1 .OR. uValue[ 1 ] > ::ItemCount .OR. uValue[ 2 ] < 1 .or. uValue[ 2 ] > Len( ::aHeaders )
      // ignore
   ElseIf uValue[ 1 ] > 1
      ::Value := { uValue[ 1 ] - 1, uValue[ 2 ] }
   ElseIf ::FullMove
      ::Value := { ::ItemCount, uValue[ 2 ] }
   Else
      // ignore
   EndIf
Return Self

*--------------------------------------------------------------------------*
METHOD Down() CLASS TGridByCell
*--------------------------------------------------------------------------*
Local uValue
   uValue := ::Value

   If uValue[ 1 ] < 1 .OR. uValue[ 1 ] > ::ItemCount .OR. uValue[ 2 ] < 1 .or. uValue[ 2 ] > Len( ::aHeaders )
      ::Value := { 1, 1 }
   ElseIf uValue[ 1 ] < ::ItemCount
      ::Value := { uValue[ 1 ] + 1, uValue[ 2 ] }
   ElseIf ::lNestedEdit
      // EditGrid is active, ignore de command
   ElseIf ::Append
      ::AppendItem()
   ElseIf ::FullMove
      ::Value := { 1, uValue[ 2 ] }
   EndIf
Return Self

*--------------------------------------------------------------------------*
METHOD PageUp() CLASS TGridByCell
*--------------------------------------------------------------------------*
Local uValue
   uValue := ::Value

   If uValue[ 1 ] < 1 .OR. uValue[ 1 ] > ::ItemCount .OR. uValue[ 2 ] < 1 .or. uValue[ 2 ] > Len( ::aHeaders )
      ::Value := { 1, 1 }
   ElseIf uValue[ 1 ] > ::CountPerPage
      ::Value := { uValue[ 1 ] - ::CountPerPage, uValue[ 2 ] }
   Else
      ::Value := { 1, uValue[ 2 ] }
   EndIf
Return Self

*-------------------------------------------------------------------------*
METHOD PageDown() CLASS TGridByCell
*-------------------------------------------------------------------------*
Local uValue
   uValue := ::Value

   If uValue[ 1 ] < 1 .OR. uValue[ 1 ] > ::ItemCount .OR. uValue[ 2 ] < 1 .or. uValue[ 2 ] > Len( ::aHeaders )
      If ::CountPerPage <= ::ItemCount
         ::Value := { ::CountPerPage, 1 }
      Else
         ::Value := { ::ItemCount, 1 }
      EndIf
   ElseIf uValue[ 1 ] < ::ItemCount - ::CountPerPage
      ::Value := { uValue[ 1 ] + ::CountPerPage, uValue[ 2 ] }
   Else
      ::Value := { ::Itemcount, uValue[ 2 ] }
   EndIf
Return Self

*---------------------------------------------------------------------------*
METHOD GoTop() CLASS TGridByCell
*---------------------------------------------------------------------------*
   If ::ItemCount > 0
      ::Value := { 1, 1 }
   EndIf
Return Self

*---------------------------------------------------------------------------*
METHOD GoBottom() CLASS TGridByCell
*---------------------------------------------------------------------------*
   If ::ItemCount > 0
      ::Value := { ::Itemcount, Len( ::aHeaders ) }
   EndIf
Return Self

*-----------------------------------------------------------------------------*
METHOD IsColumnWhen( nCol ) CLASS TGridByCell
*-----------------------------------------------------------------------------*
Local uWhen
   If nCol >= 1 .AND. HB_IsArray( ::aWhen ) .AND. Len( ::aWhen ) >= nCol
      uWhen := ::aWhen[ nCol ]
      If HB_IsBlock( uWhen )
         uWhen := Eval( uWhen, nCol, ::Item( ::Value[ 1 ] ) )
      EndIf
   Else
      uWhen := Nil
   EndIf
Return ( ! HB_IsLogical( uWhen ) .OR. uWhen )

*-----------------------------------------------------------------------------*
METHOD AddColumn( nColIndex, cCaption, nWidth, nJustify, uForeColor, uBackColor, ;
                  lNoDelete, uPicture, uEditControl, uHeadClick, uValid, ;
                  uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign ) CLASS TGridByCell
*-----------------------------------------------------------------------------*
Local aValue
   aValue := ::Value

   nColIndex := ::Super:AddColumn( nColIndex, cCaption, nWidth, nJustify, uForeColor, uBackColor, ;
                                   lNoDelete, uPicture, uEditControl, uHeadClick, uValid, ;
                                   uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign )

   If nColIndex < aValue[ 2 ]
      ::Value := { aValue[ 1 ], aValue[ 2 ] + 1 }
   EndIf

Return nColIndex

*-----------------------------------------------------------------------------*
METHOD ColumnHide( nColIndex ) CLASS TGridByCell
*-----------------------------------------------------------------------------*
Local aValue
   aValue := ::Value

   If HB_IsNumeric( nColIndex )
      If nColindex > 0
         If aValue[ 2 ] == nColIndex
            ::Value := { 0, 0 }
         EndIf
         ::ColumnWidth( nColIndex, 0 )
      EndIf
   EndIf
Return Nil

*-----------------------------------------------------------------------------*
METHOD DeleteColumn( nColIndex, lNoDelete ) CLASS TGridByCell
*-----------------------------------------------------------------------------*
Local aValue
   aValue := ::Value

   nColIndex := ::Super:DeleteColumn( nColIndex, lNoDelete )

   If aValue[ 2 ] == nColIndex
      ::Value := { 0, 0 }
   EndIf

Return nColIndex

*-----------------------------------------------------------------------------*
METHOD EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar ) CLASS TGridByCell
*-----------------------------------------------------------------------------*
Local aValue
   aValue := ::Value

   If ! HB_IsNumeric( nRow )
      nRow := aValue[ 1 ]
   EndIf
   If ! HB_IsNumeric( nCol )
      nCol := aValue[ 2 ]
   EndIf

Return ::Super:EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar )

// nRow, nCol and uValue may be passed by reference
*-----------------------------------------------------------------------------*
METHOD EditCell2( nRow, nCol, EditControl, uOldValue, uValue, cMemVar ) CLASS TGridByCell
*-----------------------------------------------------------------------------*
Local aValue
   aValue := ::Value

   If ! HB_IsNumeric( nRow )
      nRow := aValue[ 1 ]
   EndIf
   If ! HB_IsNumeric( nCol )
      nCol := aValue[ 2 ]
   EndIf

Return ::Super:EditCell2( @nRow, @nCol, EditControl, uOldValue, @uValue, cMemVar )

*-----------------------------------------------------------------------------*
FUNCTION _OOHG_TGridByCell_Events2( Self, hWnd, nMsg, wParam, lParam ) // CLASS TGridByCell
*-----------------------------------------------------------------------------*
Local aCellData, nItem, i, nSearchCol
   Empty( lParam )

   If nMsg == WM_LBUTTONDBLCLK
      If ! ::lCheckBoxes .OR. ListView_HitOnCheckBox( hWnd, GetCursorRow() - GetWindowRow( hWnd ), GetCursorCol() - GetWindowCol( hWnd ) ) == 0
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
         _OOHG_ThisItemCellValue  := ::Cell( _OOHG_ThisItemRowIndex, _OOHG_ThisItemColIndex )

         If ::AllowEdit
            If ::IsColumnReadOnly( _OOHG_ThisItemColIndex )
               // Cell is readonly
            ElseIf ! ::IsColumnWhen( _OOHG_ThisItemColIndex )
               // Not a valid WHEN
            ElseIf ! ::lNestedEdit
               ::lNestedEdit := .T.
               ::EditGrid( _OOHG_ThisItemRowIndex, _OOHG_ThisItemColIndex )
               ::lNestedEdit := .F.
            EndIf

         ElseIf HB_IsBlock( ::OnDblClick )
            ::DoEvent( ::OnDblClick, "DBLCLICK" )

         EndIf

         _ClearThisCellInfo()
         _PopEventInfo()
      EndIf
      Return 0

   ElseIf nMsg == WM_LBUTTONDOWN .OR. nMsg == WM_RBUTTONDOWN
      If ! ::lCheckBoxes .OR. ListView_HitOnCheckBox( hWnd, GetCursorRow() - GetWindowRow( hWnd ), GetCursorCol() - GetWindowCol( hWnd ) ) == 0
         aCellData := _GetGridCellData( Self )
         ::Value := { aCellData[ 1 ], aCellData[ 2 ] }
      EndIf

   ElseIf nMsg == WM_MOUSEWHEEL
      If GET_WHEEL_DELTA_WPARAM( wParam ) > 0
         ::Up()
      Else
         ::Down()
      EndIf
      Return 1

   ElseIf nMsg == WM_CHAR
      If wParam < 32
         ::cText := ""
         Return 0
      ElseIf Empty( ::cText )
         ::uIniTime := HB_MilliSeconds()
         ::cText := Upper( Chr( wParam ) )
      ElseIf HB_MilliSeconds() > ::uIniTime + ::SearchLapse
         ::uIniTime := HB_MilliSeconds()
         ::cText := Upper( Chr( wParam ) )
      Else
         ::cText += Upper( Chr( wParam ) )
      EndIf

      If ::SearchCol < 1 .OR. ::SearchCol > ::ColumnCount
         nSearchCol := ::Value[ 2 ]
         If nSearchCol < 1 .OR. nSearchCol > ::ColumnCount
            Return 1
         EndIf
      Else
         nSearchCol := ::SearchCol
      EndIf
      If nSearchCol == 1
         nItem := ListView_FindItem( hWnd, ::FirstSelectedItem - 1, ::cText, ::SearchWrap )
      Else
         nItem := 0

         For i := ::FirstSelectedItem + 1 To ::ItemCount
            If Upper( Left( ::CellCaption( i, nSearchCol ), Len( ::cText ) ) ) == ::cText
               nItem := i
               Exit
            EndIf
         Next i

         If nItem == 0 .AND. ::SearchWrap
            For i := 1 To ::FirstSelectedItem
              If Upper( Left( ::CellCaption( i, nSearchCol ), Len( ::cText ) ) ) == ::cText
                 nItem := i
                 Exit
              EndIf
            Next i
         EndIf
      EndIf
      If nItem > 0
         ::Value := { nItem, nSearchCol }
      EndIf
      Return 0

   EndIf

Return Nil

*-----------------------------------------------------------------------------*
METHOD Events_Enter() CLASS TGridByCell
*-----------------------------------------------------------------------------*
   ::cText := ""
   If ::AllowEdit
      If ! ::lNestedEdit
         ::lNestedEdit := .T.
         ::EditGrid()
         ::lNestedEdit := .F.
      EndIf
   Else
      ::DoEvent( ::OnEnter, "ENTER" )
   EndIf
Return Nil

*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TGridByCell
*-----------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam )
Local nvkey, uRet, aValue, nItem

   If nNotify == NM_CUSTOMDRAW
      aValue := ::Value
      uRet := TGrid_Notify_CustomDraw( Self, lParam, .T., aValue[ 1 ], aValue[ 2 ], ::lCheckBoxes, ::lFocusRect, ::lNoGrid, ::lPLM )
      ListView_SetCursel( ::hWnd, aValue[ 1 ] )
      Return uRet

   ElseIf nNotify == LVN_KEYDOWN
      If GetGridvKeyAsChar( lParam ) == 0
         ::cText := ""
      EndIf

      nvKey := GetGridvKey( lParam )

      If nvkey == VK_DOWN
         ::Down()
      ElseIf nvkey == VK_UP
         ::Up()
      ElseIf nvkey == VK_PRIOR
         ::PageUp()
      ElseIf nvkey == VK_NEXT
         ::PageDown()
      ElseIf nvkey == VK_HOME
         ::GoTop()
      ElseIf nvkey == VK_END
         ::GoBottom()
      ElseIf nvkey == VK_LEFT
         ::Left()
      ElseIf nvkey == VK_RIGHT
         ::Right()
      ElseIf nvkey == VK_SPACE .AND. ::lCheckBoxes
         // detect item
         nItem := ::FirstSelectedItem

         If nItem > 0
            // change check mark
            ::CheckItem( nItem, ! ::CheckItem( nItem ) )
            // skip default action
            Return 1
         EndIf
      EndIf
      Return Nil

   ElseIf nNotify == LVN_ITEMCHANGED
      Return Nil

   EndIf

Return ::Super:Events_Notify( wParam, lParam )

*-----------------------------------------------------------------------------*
METHOD DeleteItem( nItem ) CLASS TGridByCell
*-----------------------------------------------------------------------------*
Local aValue
   aValue := ::Value
   If nItem == aValue[ 1 ]
      ::Value := { 0, 0 }
   EndIf

Return ::Super:DeleteItem( nItem )

*-----------------------------------------------------------------------------*
METHOD DoChange() CLASS TGridByCell
*-----------------------------------------------------------------------------*
Local xValue, cType, cOldType
   xValue   := ::Value
   cType    := ValType( xValue )
   cOldType := ValType( ::xOldValue )
   cType    := If( cType    == "M", "C", cType )
   cOldType := If( cOldType == "M", "C", cOldType )

   If cOldType == "U" .OR. ! cType == cOldType .OR. ;
      ( HB_IsArray( xValue ) .AND. ! HB_IsArray( ::xOldValue ) ) .OR. ;
      ( ! HB_IsArray( xValue ) .AND. HB_IsArray( ::xOldValue ) ) .OR. ;
      Len( xValue ) # Len( ::xOldValue ) .OR. ;
      ! ValType( xValue[ 1 ] ) == ValType( ::xOldValue[ 1 ] ) .OR. ;
      ! ValType( xValue[ 2 ] ) == ValType( ::xOldValue[ 2 ] ) .OR. ;
      ! xValue[ 1 ] == ::xOldValue[ 1 ] .OR. ;
      ! xValue[ 2 ] == ::xOldValue[ 2 ]

      ::xOldValue := xValue
      ::DoEvent( ::OnChange, "CHANGE" )
   EndIf
Return Nil





*------------------------------------------------------------------------------*
FUNCTION _GetGridCellData( Self )
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

   r := ListView_HitTest ( ::hWnd, GetCursorRow() - GetWindowRow ( ::hWnd ), GetCursorCol() - GetWindowCol ( ::hWnd ) )
   If r [2] == 1
      ListView_Scroll( ::hWnd,  -10000, 0 )
      r := ListView_HitTest ( ::hWnd, GetCursorRow() - GetWindowRow ( ::hWnd ), GetCursorCol() - GetWindowCol ( ::hWnd ) )
   Else
      r := ListView_GetSubitemRect ( ::hWnd, r[1] - 1, r[2] - 1 )

                  //   CellCol            CellWidth
      xs := ( ( ::ContainerCol + r [2] ) +( r[3] ))  -  ( ::ContainerCol + ::Width )

      If ListViewGetItemCount( ::hWnd ) >  ListViewGetCountPerPage( ::hWnd )
         xd := 20
      Else
         xd := 0
      EndIf

      If xs > -xd
         ListView_Scroll( ::hWnd,  xs + xd, 0 )
      Else
         If r [2] < 0
            ListView_Scroll( ::hWnd, r[2], 0 )
         EndIf
      EndIf

      r := ListView_HitTest ( ::hWnd, GetCursorRow() - GetWindowRow ( ::hWnd ), GetCursorCol() - GetWindowCol ( ::hWnd ) )
   EndIf

   ThisItemRowIndex := r[1]
   ThisItemColIndex := r[2]

   If r [2] == 1
      r := ListView_GetItemRect ( ::hWnd, r[1] - 1 )
   Else
      r := ListView_GetSubitemRect ( ::hWnd, r[1] - 1, r[2] - 1 )
   EndIf

   ThisItemCellRow := ::ContainerRow + r [1]
   ThisItemCellCol := ::ContainerCol + r [2]
   ThisItemCellWidth := r[3]
   ThisItemCellHeight := r[4]

   aCellData := { ThisItemRowIndex, ThisItemColIndex, ThisItemCellRow, ThisItemCellCol, ThisItemCellWidth, ThisItemCellHeight }

Return aCellData

*------------------------------------------------------------------------------*
PROCEDURE _SetThisCellInfo( hWnd, nRow, nCol, uValue )
*------------------------------------------------------------------------------*
Local aControlRect, aCellRect
   aControlRect := { 0, 0, 0, 0 }
   GetWindowRect( hWnd, aControlRect )
   aCellRect := ListView_GetSubitemRect( hWnd, nRow - 1, nCol - 1 )
   aCellRect[ 3 ] := ListView_GetColumnWidth( hWnd, nCol - 1 )

   _OOHG_ThisItemRowIndex   := nRow
   _OOHG_ThisItemColIndex   := nCol
   _OOHG_ThisItemCellRow    := aCellRect[ 1 ] + aControlRect[ 2 ] + 2
   _OOHG_ThisItemCellCol    := aCellRect[ 2 ] + aControlRect[ 1 ] + 3
   _OOHG_ThisItemCellWidth  := aCellRect[ 3 ]
   _OOHG_ThisItemCellHeight := aCellRect[ 4 ]
   _OOHG_ThisItemCellValue  := uValue
Return

*------------------------------------------------------------------------------*
PROCEDURE _ClearThisCellInfo()
*------------------------------------------------------------------------------*
   _OOHG_ThisItemRowIndex   := 0
   _OOHG_ThisItemColIndex   := 0
   _OOHG_ThisItemCellRow    := 0
   _OOHG_ThisItemCellCol    := 0
   _OOHG_ThisItemCellWidth  := 0
   _OOHG_ThisItemCellHeight := 0
Return

*------------------------------------------------------------------------------*
FUNCTION _CheckCellNewValue()
*------------------------------------------------------------------------------*
Return .F.
/*
// uValue may be passed by reference
*------------------------------------------------------------------------------*
FUNCTION _CheckCellNewValue( oControl, uValue )
*------------------------------------------------------------------------------*
Local lChange, uValue2
   uValue2 := _OOHG_ThisItemCellValue
   If uValue == uValue2
      If ValType( oControl:cMemVar ) $ "CM"
         uValue2 := &( oControl:cMemVar )
      EndIf
   EndIf
   If ! uValue == uValue2
      oControl:ControlValue := uValue2
      _OOHG_ThisItemCellValue := uValue2
      If ValType( oControl:cMemVar ) $ "CM"
         &( oControl:cMemVar ) := uValue2
      EndIf
      uValue := uValue2
      lChange := .T.
   Else
      lChange := .F.
   EndIf
Return lChange
*/

*-----------------------------------------------------------------------------*
FUNCTION GridControlObject( aEditControl, oGrid )
*-----------------------------------------------------------------------------*
Local oGridControl, aEdit2, cControl
   oGridControl := Nil
   If HB_IsArray( aEditControl ) .AND. Len( aEditControl ) >= 1 .AND. ValType( aEditControl[ 1 ] ) $ "CM"
      aEdit2 := aClone( aEditControl )
      aSize( aEdit2, 4 )
      cControl := Upper( AllTrim( aEditControl[ 1 ] ) )
      Do Case
         Case cControl == "MEMO"
            oGridControl := TGridControlMemo():New( aEdit2[ 2 ] )
         Case cControl == "DATEPICKER"
            oGridControl := TGridControlDatePicker():New( aEdit2[ 2 ], aEdit2[ 3 ] )
         Case cControl == "COMBOBOX"
            oGridControl := TGridControlComboBox():New( aEdit2[ 2 ], oGrid, aEdit2[ 3 ], aEdit2[ 4 ] )
         Case cControl == "COMBOBOXTEXT"
            oGridControl := TGridControlComboBoxText():New( aEdit2[ 2 ], oGrid )
         Case cControl == "SPINNER"
            oGridControl := TGridControlSpinner():New( aEdit2[ 2 ], aEdit2[ 3 ] )
         Case cControl == "CHECKBOX"
            oGridControl := TGridControlCheckBox():New( aEdit2[ 2 ], aEdit2[ 3 ] )
         Case cControl == "TEXTBOX"
            oGridControl := TGridControlTextBox():New( aEdit2[ 3 ], aEdit2[ 4 ], aEdit2[ 2 ] )
         Case cControl == "IMAGELIST"
            oGridControl := TGridControlImageList():New( oGrid )
         Case cControl == "IMAGEDATA"
            oGridControl := TGridControlImageData():New( oGrid, GridControlObject( aEdit2[ 2 ] ) )
         Case cControl == "LCOMBOBOX"
            oGridControl := TGridControlLComboBox():New( aEdit2[ 2 ], aEdit2[ 3 ] )
      EndCase
   EndIf
Return oGridControl

*-----------------------------------------------------------------------------*
FUNCTION GridControlObjectByType( uValue )
*-----------------------------------------------------------------------------*
Local oGridControl := Nil, cMask, nPos
   Do Case
   Case HB_IsNumeric( uValue )
      cMask := Str( uValue )
      cMask := Replicate( "9", Len( cMask ) )
      nPos := At( ".", cMask )
      If nPos != 0
         cMask := Left( cMask, nPos - 1 ) + "." + SubStr( cMask, nPos + 1 )
      EndIf
      oGridControl := TGridControlTextBox():New( cMask,, "N" )
   Case HB_IsLogical( uValue )
      // oGridControl := TGridControlCheckBox():New( ".T.", ".F." )
      oGridControl := TGridControlLComboBox():New( ".T.", ".F." )
   Case HB_IsDate( uValue )
      // oGridControl := TGridControlDatePicker():New( .T. )
      oGridControl := TGridControlTextBox():New( "@D",, "D" )
   Case ValType( uValue ) == "M"
      oGridControl := TGridControlMemo():New()
   Case ValType( uValue ) == "C"
      oGridControl := TGridControlTextBox():New( , , "C" )
   OtherWise
      // Non-implemented data type!!!
   EndCase
Return oGridControl

*------------------------------------------------------------------------------*
FUNCTION GetEditControlFromArray( oEditControl, aEditControls, nColumn, oGrid )
*------------------------------------------------------------------------------*
   If HB_IsArray( oEditControl )
      oEditControl := GridControlObject( oEditControl, oGrid )
   EndIf
   If ! HB_IsObject( oEditControl ) .AND. HB_IsArray( aEditControls ) .AND. HB_IsNumeric( nColumn ) .AND. nColumn >= 1 .AND. Len( aEditControls ) >= nColumn
      oEditControl := aEditControls[ nColumn ]
      If HB_IsArray( oEditControl )
         oEditControl := GridControlObject( oEditControl, oGrid )
      EndIf
   EndIf
   If ! HB_IsObject( oEditControl )
      oEditControl := Nil
   EndIf
Return oEditControl

*------------------------------------------------------------------------------*
FUNCTION GetStateListWidth( hwnd )
*------------------------------------------------------------------------------*

RETURN ImageList_Size( ListView_GetImageList( hwnd, LVSIL_STATE ) ) [ 1 ]





*-----------------------------------------------------------------------------*
CLASS TGridControl
*-----------------------------------------------------------------------------*
   DATA Type                  INIT "TGRIDCONTROL" READONLY
   DATA oControl              INIT Nil
   DATA oWindow               INIT Nil
   DATA Value                 INIT Nil
   DATA bWhen                 INIT Nil
   DATA cMemVar               INIT Nil
   DATA bValid                INIT Nil
   DATA cValidMessage         INIT Nil
   DATA nDefWidth             INIT 140
   DATA nDefHeight            INIT 24

   METHOD New                 BLOCK { |Self| Self }
   METHOD CreateWindow
   METHOD Valid
   METHOD Str2Val( uValue )   BLOCK { |Self, uValue| Empty( Self ), uValue }
   METHOD GridValue( uValue ) BLOCK { |Self, uValue| Empty( Self ), If( ValType( uValue ) $ "CM", Trim( uValue ), uValue ) }
   METHOD SetFocus            BLOCK { |Self| ::oControl:SetFocus() }
   METHOD SetValue( uValue )  BLOCK { |Self, uValue| ::oControl:Value := uValue }
   METHOD ControlValue        SETGET
   METHOD Enabled             SETGET
   METHOD OnLostFocus         SETGET
ENDCLASS

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, aKeys ) CLASS TGridControl
Local lRet := .F., i

   If ! IsWindowDefined( _oohg_gridwn )
       DEFINE WINDOW _oohg_gridwn OBJ ::oWindow ;
          AT nRow, nCol WIDTH nWidth HEIGHT nHeight ;
          MODAL NOSIZE NOCAPTION ;
          FONT cFontName SIZE nFontSize

          ON KEY RETURN OF ( ::oWindow ) ACTION ( lRet := ::Valid() )
          ON KEY ESCAPE OF ( ::oWindow ) ACTION ( ::oWindow:Release() )

          If HB_IsArray( aKeys )
             For i := 1 To Len( aKeys )
                If HB_IsArray( aKeys[ i ] ) .AND. Len( aKeys[ i ] ) > 1 .AND. ValType( aKeys[ i, 1 ] ) $ "CM" .AND. HB_IsBlock( aKeys[ i, 2 ] ) .AND. ! ( aKeys[ i, 1 ] == "RETURN" .OR. aKeys[ i, 1 ] == "ESCAPE" )
                   _DefineAnyKey( ::oWindow, aKeys[ i, 1 ], aKeys[ i, 2 ] )
                EndIf
             Next
          EndIf

          ::CreateControl( uValue, ::oWindow, 0, 0, nWidth, nHeight )
          ::Value := ::ControlValue
      END WINDOW
   EndIf

   If IsWindowDefined( _oohg_gridwn ) .AND. ! IsWindowActive( _oohg_gridwn )
      If HB_IsObject( ::oControl )
         ::oControl:SetFocus()
      EndIf
      If HB_IsObject( ::oWindow )
         ::oWindow:Activate()
      EndIf
   EndIf
Return lRet

METHOD Valid() CLASS TGridControl
Local lValid, uValue, cValidMessage

   uValue := ::ControlValue

   If ValType( ::cMemVar ) $ "CM" .AND. ! Empty( ::cMemVar )
      &( ::cMemVar ) := uValue
   EndIf

   _OOHG_ThisItemCellValue := uValue
   lValid := _OOHG_Eval( ::bValid, uValue )
   _CheckCellNewValue( Self, @uValue )
   If ! HB_IsLogical( lValid )
      lValid := .T.
   EndIf

   If lValid
      ::Value := uValue
      ::oWindow:Release()
   Else
      cValidMessage := ::cValidMessage
      If HB_IsBlock( cValidMessage )
         cValidMessage := Eval( cValidMessage, uValue )
      EndIf
      If ValType( cValidMessage ) $ "CM" .AND. ! Empty( cValidMessage )
         MsgExclamation( cValidMessage )
      Else
         MsgExclamation( _OOHG_Messages( 3, 11 ) )
      EndIf
      ::oControl:SetFocus()
   EndIf
Return lValid

METHOD ControlValue( uValue ) CLASS TGridControl
   If PCount() >= 1
      ::oControl:Value := uValue
   EndIf
Return ::oControl:Value

METHOD Enabled( uValue ) CLASS TGridControl
Return ( ::oControl:Enabled := uValue )

METHOD OnLostFocus( uValue ) CLASS TGridControl
   If PCount() >= 1
      ::oControl:OnLostFocus := uValue
   EndIf
Return ::oControl:OnLostFocus

*-----------------------------------------------------------------------------*
CLASS TGridControlTextBox FROM TGridControl
*-----------------------------------------------------------------------------*
   DATA cMask INIT ""
   DATA cType INIT ""

   METHOD New
   METHOD CreateWindow
   METHOD CreateControl
   METHOD Str2Val
   METHOD GridValue
ENDCLASS

METHOD New( cPicture, cFunction, cType ) CLASS TGridControlTextBox
   ::cMask := ""
   If ValType( cPicture ) $ "CM" .AND. ! Empty( cPicture )
      ::cMask := cPicture
   EndIf
   If ValType( cFunction ) $ "CM" .AND. ! Empty( cFunction )
      ::cMask := "@" + cFunction + " " + ::cMask
   EndIf

   If ValType( cType ) $ "CM" .AND. ! Empty( cType )
      cType := Upper( Left( AllTrim( cType ), 1 ) )
      ::cType := If( ( ! cType $ "CDNL" ), "C", cType )
   Else
      ::cType := "C"
   EndIf
   If ::cType == "D" .AND. Empty( ::cMask )
      ::cMask := "@D"
   ElseIf ::cType == "N" .AND. Empty( ::cMask )
//    ::cMask := "@D"
   ElseIf ::cType == "L" .AND. Empty( ::cMask )
      ::cMask := "L"
   EndIf
Return Self

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, aKeys ) CLASS TGridControlTextBox
Return ::Super:CreateWindow( uValue, nRow - 3, nCol - 3, nWidth + 6, nHeight + 6, cFontName, nFontSize, aKeys )

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlTextBox
/*
 TODO: Delete if everything is all right
   If ValType( uValue ) == "C"
      uValue := ::Str2Val( uValue )
   EndIf
*/
   If ! Empty( ::cMask )
      @ nRow,nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue INPUTMASK ::cMask
   ElseIf HB_IsNumeric( uValue )
      @ nRow,nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue NUMERIC
   ElseIf HB_IsDAte( uValue )
      @ nRow,nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue DATE
   Else
      @ nRow,nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue
   EndIf
Return ::oControl

METHOD Str2Val( uValue ) CLASS TGridControlTextBox
   Do Case
   Case ::cType == "D"
      uValue := CtoD( uValue )
   Case ::cType == "L"
      uValue := ( PadL( uValue, 1 ) $ "TtYy" )
   Case ::cType == "N"
      uValue := Val( StrTran( _OOHG_UnTransform( uValue, ::cMask, ::cType ), " ", "" ) )
   Otherwise
      If ! Empty( ::cMask )
         uValue := _OOHG_UnTransform( uValue, ::cMask, ::cType )
      EndIf
   EndCase
Return uValue

METHOD GridValue( uValue ) CLASS TGridControlTextBox
   If Empty( ::cMask )
      If ::cType == "D"
         uValue := DtoC( uValue )
      ElseIf ::cType == "N"
         uValue := LTrim( Str( uValue ) )
      ElseIf ::cType == "L"
         uValue := If( uValue, "T", "F" )
      ElseIf ::cType $ "CM"
         uValue := Trim( uValue )
      EndIf
   Else
      uValue := Trim( Transform( uValue, ::cMask ) )
   EndIf
Return uValue

*-----------------------------------------------------------------------------*
CLASS TGridControlMemo FROM TGridControl
*-----------------------------------------------------------------------------*
   DATA nDefHeight INIT 84
   DATA cTitle     INIT _OOHG_Messages( 1, 11 )

   METHOD New
   METHOD CreateWindow
   METHOD CreateControl
ENDCLASS

METHOD New( cTitle ) CLASS TGridControlMemo
   If ValType( cTitle ) $ "CM" .AND. ! Empty( cTitle )
      ::cTitle := cTitle
   EndIf
Return Self

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, aKeys ) CLASS TGridControlMemo
Local lRet := .F., i
   Empty( nWidth )
   Empty( nHeight )
   Empty( cFontName )
   Empty( nFontSize )

   DEFINE WINDOW 0 OBJ ::oWindow ;
      AT nRow, nCol WIDTH 350 HEIGHT GetTitleHeight() + 265 TITLE ::cTitle ;
      MODAL NOSIZE

      ON KEY ESCAPE OF ( ::oWindow ) ACTION ( ::oWindow:Release() )

      If HB_IsArray( aKeys )
         For i := 1 To Len( aKeys )
            If HB_IsArray( aKeys[ i ] ) .AND. Len( aKeys[ i ] ) > 1 .AND. ValType( aKeys[ i, 1 ] ) $ "CM" .AND. HB_IsBlock( aKeys[ i, 2 ] ) .AND. ! aKeys[ i, 1 ] == "ESCAPE"
               _DefineAnyKey( ::oWindow, aKeys[ i, 1 ], aKeys[ i, 2 ] )
            EndIf
         Next
      EndIf

      @ 07,10 LABEL 0 PARENT ( ::oWindow ) VALUE "" WIDTH 280

      ::CreateControl( uValue, ::oWindow:Name, 30, 10, 320, 176 )
      ::Value := ::ControlValue

      @ 217,120 BUTTON 0 PARENT ( ::oWindow ) CAPTION _OOHG_Messages( 1, 6 ) ACTION ( lRet := ::Valid() )
      @ 217,230 BUTTON 0 PARENT ( ::oWindow ) CAPTION _OOHG_Messages( 1, 7 ) ACTION ( ::oWindow:Release() )
   END WINDOW

   ::oWindow:Center()
   ::oControl:SetFocus()
   ::oWindow:Activate()
Return lRet

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlMemo
   @ nRow,nCol EDITBOX 0 OBJ ::oControl PARENT ( cWindow ) VALUE StrTran( uValue, Chr(141), ' ' ) HEIGHT nHeight WIDTH nWidth
Return ::oControl

*-----------------------------------------------------------------------------*
CLASS TGridControlDatePicker FROM TGridControl
*-----------------------------------------------------------------------------*
   DATA lUpDown
   DATA lShowNone

   METHOD New
   METHOD CreateWindow
   METHOD CreateControl
   METHOD Str2Val( uValue )   BLOCK { |Self, uValue| Empty( Self ), CtoD( uValue ) }
   METHOD GridValue( uValue ) BLOCK { |Self, uValue| Empty( Self ), DtoC( uValue ) }
ENDCLASS

METHOD New( lUpDown, lShowNone ) CLASS TGridControlDatePicker
   If ! HB_IsLogical( lUpDown )
      lUpDown := .F.
   EndIf
   ::lUpDown := lUpDown

   If ! HB_IsLogical( lShowNone )
      lShowNone := .F.
   EndIf
   ::lShowNone := lShowNone
Return Self

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, aKeys ) CLASS TGridControlDatePicker
Return ::Super:CreateWindow( uValue, nRow - 3, nCol - 3, nWidth + 6, nHeight + 6, cFontName, nFontSize, aKeys )

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlDatePicker
   If ValType( uValue ) == "C"
      uValue := CtoD( uValue )
   EndIf
   If ::lUpDown
      If ::lShowNone
         @ nRow,nCol DATEPICKER 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue UPDOWN SHOWNONE
      Else
         @ nRow,nCol DATEPICKER 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue UPDOWN
      EndIf
   Else
      If ::lShowNone
         @ nRow,nCol DATEPICKER 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue SHOWNONE
      Else
         @ nRow,nCol DATEPICKER 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue
      EndIf
  EndIf
Return ::oControl

*-----------------------------------------------------------------------------*
CLASS TGridControlComboBox FROM TGridControl
*-----------------------------------------------------------------------------*
   DATA aItems       INIT {}
   DATA oGrid        INIT Nil
   DATA aValues      INIT Nil
   DATA cWorkArea    INIT ""
   DATA cField       INIT ""
   DATA cValueSource INIT ""
   DATA cRetValType  INIT "N"   // Needed because cWorkArea can be not opened yet when ::New is first executed

   METHOD New
   METHOD CreateWindow
   METHOD CreateControl
   METHOD Str2Val
   METHOD GridValue
   METHOD Refresh
ENDCLASS

METHOD New( aItems, oGrid, aValues, cRetValType ) CLASS TGridControlComboBox
   DEFAULT cRetValType TO "NUMERIC"
   If HB_IsArray( aItems )
      ::aItems := aItems
      If HB_IsArray( aValues ) .AND. Len( aValues ) > 0
         If ValType( aValues[1] ) $ "CM"
            ::aValues := aValues
            ::cRetValType := "C"
         ElseIf ValType( aValues[1] ) == "N"
            ::aValues := aValues
         EndIf
      EndIf
   ElseIf ValType( aItems ) $ "CM" .AND. '->' $ aItems
      ::cWorkArea := Left( aItems, At( '->', aItems ) - 1 )
      ::cField := Right( aItems, Len( aItems ) - At( '->', aItems ) - 1 )
      If ValType( aValues ) $ "CM"
         If Upper( cRetValType ) == "CHARACTER"
            ::cValueSource := aValues
            ::cRetValType := "C"
         ElseIf Upper( cRetValType ) == "NUMERIC"
            ::cValueSource := aValues
         EndIf
      EndIf
      ::Refresh()
   EndIf
   ::oGrid := oGrid
Return Self

METHOD Refresh CLASS TGridControlComboBox
Local cValueSource, cWorkArea, cField, nRecno, aIt, aVa, uValue
   cWorkArea := ::cWorkArea
   cField := ::cField
   cValueSource := ::cValueSource
   If Select( cWorkArea ) != 0
      nRecno := ( cWorkArea )->( RecNo() )
      ( cWorkArea )->( DBGoTop() )
      aIt := {}
      aVa := {}
      Do While ! ( cWorkArea )->( Eof() )
         AADD( aIt, ( cWorkArea )->&( cField ) )
         If Empty( cValueSource )
            uValue := ( cWorkArea )->( RecNo() )
         Else
            uValue := &( cValueSource )
            If ! ValType( uValue ) == ::cRetValType
               MsgOOHGError( "GridControl: ValueSource/RetVal type mismatch. Program Terminated." )
            EndIf
            If ValType( uValue ) $ "CM"
               uValue := Trim( uValue )
            EndIf
         EndIf
         AADD( aVa, uValue )
         ( cWorkArea )->( DBSkip() )
      EndDo
      ( cWorkArea )->( DBGoTo( nRecno ) )
      ::aItems := aIt
      ::aValues := aVa
      ::cField := cField
      ::cWorkArea := cWorkArea
      ::cValueSource := cValueSource
   EndIf
Return Nil

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, aKeys ) CLASS TGridControlComboBox
Return ::Super:CreateWindow( uValue, nRow - 3, nCol - 3, nWidth + 6, nHeight + 6, cFontName, nFontSize, aKeys )

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlComboBox
   Empty( nHeight )
   ::Refresh()
   @ nRow,nCol COMBOBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth VALUE uValue ITEMS ::aItems VALUESOURCE ( ::aValues )
   If ! Empty( ::oGrid ) .AND. ::oGrid:ImageList != 0
      ::oControl:ImageList := ImageList_Duplicate( ::oGrid:ImageList )
   EndIf
Return ::oControl

// Transforms the combo's display value (string) into the cell content
METHOD Str2Val( uValue ) CLASS TGridControlComboBox
Local xValue
   xValue := aScan( ::aItems, { |c| c == uValue } )
   If HB_IsArray( ::aValues )
      If xValue >= 1 .AND. xValue <= Len( ::aValues )
         xValue := ::aValues[ xValue ]
      ElseIf ::cRetValType == "C"
         xValue := ""
      Else
         xValue := 0
      EndIf
   ElseIf ::cRetValType == "C"
      xValue := ""
   EndIf
Return xValue

// Transforms the cell content into a string to show in the listview
METHOD GridValue( uValue ) CLASS TGridControlComboBox
   If HB_IsArray( ::aValues )
      uValue := aScan( ::aValues, { |c| c == uValue } )
   ElseIf ! ValType( uValue ) == "N"
     uValue := 0
   EndIf
Return If( ( uValue >= 1 .AND. uValue <= Len( ::aItems ) ), ::aItems[ uValue ], "" )

*-----------------------------------------------------------------------------*
CLASS TGridControlComboBoxText FROM TGridControl
*-----------------------------------------------------------------------------*
   DATA aItems INIT {}
   DATA oGrid  INIT Nil

   METHOD New
   METHOD CreateWindow
   METHOD CreateControl
   METHOD Str2Val
   METHOD GridValue( uValue ) BLOCK { |Self, uValue| ::Str2Val( uValue ) }
   METHOD ControlValue        SETGET
ENDCLASS

METHOD New( aItems, oGrid ) CLASS TGridControlComboBoxText
   If HB_IsArray( aItems )
      ::aItems := Array( Len( aItems ) )
      aEval( aItems, { |x,i| ::aItems[ i ] := Trim( x ) } )
   EndIf
   ::oGrid := oGrid
Return Self

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, aKeys ) CLASS TGridControlComboBoxText
Return ::Super:CreateWindow( uValue, nRow - 3, nCol - 3, nWidth + 6, nHeight + 6, cFontName, nFontSize, aKeys )

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlComboBoxText
   Empty( nHeight )
   uValue := aScan( ::aItems, { |c| c == uValue } )
   @ nRow,nCol COMBOBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth VALUE uValue ITEMS ::aItems
   If ! Empty( ::oGrid ) .AND. ::oGrid:ImageList != 0
      ::oControl:ImageList := ImageList_Duplicate( ::oGrid:ImageList )
   EndIf
Return ::oControl

METHOD Str2Val( uValue ) CLASS TGridControlComboBoxText
Local nPos
   nPos := aScan( ::aItems, { |c| c == Trim( uValue ) } )
Return If( nPos == 0, "", ::aItems[ nPos ] )

METHOD ControlValue( uValue ) CLASS TGridControlComboBoxText
Local nPos
   If PCount() >= 1
      ::oControl:Value := ::Str2Val( uValue )
   EndIf
   nPos := ::oControl:Value
Return If( nPos == 0, "", ::aItems[ nPos ] )

*-----------------------------------------------------------------------------*
CLASS TGridControlSpinner FROM TGridControl
*-----------------------------------------------------------------------------*
   DATA nRangeMin INIT 0
   DATA nRangeMax INIT 100

   METHOD New
   METHOD CreateWindow
   METHOD CreateControl
   METHOD Str2Val( uValue )  BLOCK { |Self, uValue| Empty( Self ), Val( AllTrim( uValue ) ) }
   METHOD GridValue( uValue) BLOCK { |Self, uValue| Empty( Self ), LTrim( Str( uValue ) ) }
ENDCLASS

METHOD New( nRangeMin, nRangeMax ) CLASS TGridControlSpinner
   If HB_IsNumeric( nRangeMin )
      ::nRangeMin := nRangeMin
   EndIf
   If HB_IsNumeric( nRangeMax )
      ::nRangeMax := nRangeMax
   EndIf
Return Self

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, aKeys ) CLASS TGridControlSpinner
Return ::Super:CreateWindow( uValue, nRow - 3, nCol - 3, nWidth + 6, nHeight + 6, cFontName, nFontSize, aKeys )

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlSpinner
   If ValType( uValue ) == "C"
      uValue := Val( uValue )
   EndIf
   @ nRow,nCol SPINNER 0 OBJ ::oControl PARENT ( cWindow ) RANGE ::nRangeMin, ::nRangeMax WIDTH nWidth HEIGHT nHeight VALUE uValue
Return ::oControl

*-----------------------------------------------------------------------------*
CLASS TGridControlCheckBox FROM TGridControl
*-----------------------------------------------------------------------------*
   DATA cTrue  INIT ".T."
   DATA cFalse INIT ".F."

   METHOD New
   METHOD CreateWindow
   METHOD CreateControl
   METHOD Str2Val( uValue )   BLOCK { |Self, uValue| ( uValue == ::cTrue .OR. Upper( uValue ) == ".T." ) }
   METHOD GridValue( uValue ) BLOCK { |Self, uValue| If( uValue, ::cTrue, ::cFalse ) }
ENDCLASS

METHOD New( cTrue, cFalse ) CLASS TGridControlCheckBox
   If ValType( cTrue ) $ "CM"
      ::cTrue := cTrue
   EndIf
   If ValType( cFalse ) $ "CM"
      ::cFalse := cFalse
   EndIf
Return Self

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, aKeys ) CLASS TGridControlCheckBox
Return ::Super:CreateWindow( uValue, nRow - 3, nCol - 3, nWidth + 6, nHeight + 6, cFontName, nFontSize, aKeys )

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlCheckBox
   If ValType( uValue ) == "C"
      uValue := ( uValue == ::cTrue .OR. Upper( uValue ) == ".T." )
   EndIf
   @ nRow,nCol CHECKBOX 0 OBJ ::oControl PARENT ( cWindow ) CAPTION If( uValue, ::cTrue, ::cFalse ) WIDTH nWidth HEIGHT nHeight VALUE uValue ;
               ON CHANGE ( ::oControl:Caption := If( ::oControl:Value, ::cTrue, ::cFalse ) )
Return ::oControl

*-----------------------------------------------------------------------------*
CLASS TGridControlImageList FROM TGridControl
*-----------------------------------------------------------------------------*
   DATA oGrid

   METHOD New
   METHOD CreateWindow
   METHOD CreateControl
   METHOD Str2Val( uValue ) BLOCK { |Self, uValue| Empty( Self ), If( ValType( uValue ) == "C", Val( uValue ), uValue ) }
   METHOD ControlValue      SETGET
ENDCLASS

METHOD New( oGrid ) CLASS TGridControlImageList
   ::oGrid := oGrid
   If ! Empty( ::oGrid ) .AND. ::oGrid:ImageList != 0
      ::nDefHeight := ImageList_Size( ::oGrid:ImageList ) [ 2 ] + 6
   EndIf
Return Self

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, aKeys ) CLASS TGridControlImageList
Return ::Super:CreateWindow( uValue, nRow - 3, nCol - 3, nWidth + 6, nHeight + 6, cFontName, nFontSize, aKeys )

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlImageList
   Empty( nHeight )
   If ValType( uValue ) == "C"
      uValue := Val( uValue )
   EndIf
   If ! Empty( ::oGrid ) .AND. ::oGrid:ImageList != 0
      @ nRow,nCol COMBOBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth VALUE 0 ITEMS {} IMAGE {} TEXTHEIGHT ImageList_Size( ::oGrid:ImageList ) [ 2 ]
      ::oControl:ImageList := ImageList_Duplicate( ::oGrid:ImageList )
   Else
      @ nRow,nCol COMBOBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth VALUE 0 ITEMS {}
   EndIf
   aEval( Array( ImageList_GetImageCount( ::oGrid:ImageList ) ), { |x,i| ::oControl:AddItem( i - 1 ), x } )
   ::oControl:Value := uValue + 1
Return ::oControl

METHOD ControlValue( uValue ) CLASS TGridControlImageList
   If PCount() >= 1
      ::oControl:Value := uValue + 1
   EndIf
Return ::oControl:Value - 1

*-----------------------------------------------------------------------------*
CLASS TGridControlImageData FROM TGridControl
*-----------------------------------------------------------------------------*
   DATA Type INIT "TGRIDCONTROLIMAGEDATA" READONLY
   DATA oGrid
   DATA oData

   METHOD New
   METHOD CreateWindow
   METHOD CreateControl
   METHOD ControlValue SETGET
ENDCLASS

METHOD New( oGrid, oData ) CLASS TGridControlImageData
   ::oGrid := oGrid
   If oData == Nil
      oData := TGridControlTextBox():New
   EndIf
   ::oData := oData
Return Self

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, aKeys ) CLASS TGridControlImageData
Return ::Super:CreateWindow( uValue, nRow - 3, nCol - 3, nWidth + 6, nHeight + 6, cFontName, nFontSize, aKeys )

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlImageData
Local oCData, oCImage, nSize
   Empty( nHeight )
   If ValType( uValue[ 2 ] ) == "C"
      uValue[ 2 ] := Val( uValue[ 2 ] )
   EndIf
   nSize := ImageList_Size( ::oGrid:ImageList )[ 1 ] + LoWord( GetDialogBaseUnits() ) + GetVScrollBarWidth()
   If ! Empty( ::oGrid ) .AND. ::oGrid:ImageList != 0
      @ nRow,nCol COMBOBOX 0 OBJ oCImage PARENT ( cWindow ) WIDTH nSize VALUE 0 ITEMS {} IMAGE {} TEXTHEIGHT ImageList_Size( ::oGrid:ImageList )[ 2 ]
      oCImage:ImageList := ImageList_Duplicate( ::oGrid:ImageList )
   Else
      @ nRow,nCol COMBOBOX 0 OBJ oCImage PARENT ( cWindow ) WIDTH nSize VALUE 0 ITEMS {}
   EndIf
   oCData := ::oData:CreateControl( uValue[ 1 ], cWindow, nRow, nCol + nSize, nWidth - nSize, oCImage:Width )
   ::oControl := { oCData, oCImage }

   aEval( Array( ImageList_GetImageCount( ::oGrid:ImageList ) ), { |x,i| oCImage:AddItem( i - 1 ), x } )
   oCImage:Value := uValue[ 2 ] + 1
Return ::oControl

METHOD ControlValue( uValue ) CLASS TGridControlImageData
Local oCData, oCImage
      oCData := ::oControl[1]
      oCImage := ::oControl[2]
   If PCount() >= 1
      oCData:value := uValue[1]
      oCImage:value := uValue[2] + 1
   EndIf
Return { oCData:Value, oCImage:value - 1 }

*-----------------------------------------------------------------------------*
CLASS TGridControlLComboBox FROM TGridControl
*-----------------------------------------------------------------------------*
   DATA cTrue  INIT ".T."
   DATA cFalse INIT ".F."

   METHOD New
   METHOD CreateWindow
   METHOD CreateControl
   METHOD Str2Val( uValue )   BLOCK { |Self, uValue| ( uValue == ::cTrue .OR. Upper( uValue ) == ".T." ) }
   METHOD GridValue( uValue ) BLOCK { |Self, uValue| If( uValue, ::cTrue, ::cFalse ) }
   METHOD ControlValue        SETGET
ENDCLASS

METHOD New( cTrue, cFalse ) CLASS TGridControlLComboBox
   If ValType( cTrue ) $ "CM"
      ::cTrue := cTrue
   EndIf
   If ValType( cFalse ) $ "CM"
      ::cFalse := cFalse
   EndIf
Return Self

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, aKeys ) CLASS TGridControlLComboBox
Return ::Super:CreateWindow( uValue, nRow - 3, nCol - 3, nWidth + 6, nHeight + 6, cFontName, nFontSize, aKeys )

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlLComboBox
   Empty( nHeight )
   If ValType( uValue ) == "C"
      uValue := ( uValue == ::cTrue .OR. Upper( uValue ) == ".T." )
   EndIf
   uValue := If( uValue, 1, 2 )
   @ nRow,nCol COMBOBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth VALUE uValue ITEMS { ::cTrue, ::cFalse }
Return ::oControl

METHOD ControlValue( uValue ) CLASS TGridControlLComboBox
   If PCount() >= 1
      ::oControl:Value := If( uValue, 1, 2 )
   EndIf
Return ( ::oControl:Value == 1 )

EXTERN InitListView, InitListViewColumns, AddListViewItems, InsertListViewItem
EXTERN ListViewSetItem, ListViewGetItem, FillGridFromArray
EXTERN ListView_SetItemCount, ListView_GetFirstItem, ListView_SetCurSel, ListViewDeleteString
EXTERN ListViewReset, ListViewGetMultiSel, ListViewSetMultiSel, ListViewGetItemRow
EXTERN ListViewGetItemCount, ListViewGetCountPerPage, ListView_EnsureVisible, ListView_GetTopIndex
EXTERN ListView_RedrawItems, ListView_HitTest, ListView_GetSubItemRect, ListView_GetItemRect
EXTERN ListView_Update, ListView_Scroll, ListView_SetBkColor, ListView_SetTextBkColor
EXTERN ListView_SetTextColor, ListView_GetTextColor, ListView_GetBkColor, ListView_GetColumnWidth
EXTERN ListView_SetColumnWidth, _OOHG_GridArrayWidths, ListView_AddColumn, ListView_DeleteColumn
EXTERN GetGridVKey, TGrid_Notify_CustomDraw

#pragma BEGINDUMP

#ifndef WINVER
   #define WINVER 0x0500
#endif
#if ( WINVER < 0x0500 )
   #undef WINVER
   #define WINVER 0x0500
#endif

#ifndef _WIN32_IE
   #define _WIN32_IE 0x0400
#endif
#if ( _WIN32_IE < 0x0400 )
   #undef _WIN32_IE
   #define _WIN32_IE 0x0400
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
#include "oohg.h"

#ifndef LVS_EX_DOUBLEBUFFER
   #define LVS_EX_DOUBLEBUFFER 0x00010000
#endif

#define s_Super s_TControl

// -----------------------------------------------------------------------------
HB_FUNC_STATIC( TGRID_EVENTS )   // METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TGrid
// -----------------------------------------------------------------------------
{
   HWND hWnd      = HWNDparam( 1 );
   UINT message   = ( UINT )   hb_parni( 2 );
   WPARAM wParam  = ( WPARAM ) hb_parni( 3 );
   LPARAM lParam  = ( LPARAM ) hb_parnl( 4 );
   PHB_ITEM pSelf = hb_stackSelfItem();
   static PHB_SYMB s_Events2 = 0;
   static PHB_SYMB s_Notify2 = 0;
   BOOL bDefault = TRUE;

   switch( message )
   {
      case WM_MOUSEWHEEL:
         if ( ( short ) HIWORD ( wParam ) > 0 )
         {
            keybd_event(
            VK_UP,  // virtual-key code
            0,    // hardware scan code
            0,    // flags specifying various function options
            0     // additional data associated with keystroke
            );
         }
         else
         {
            keybd_event(
            VK_DOWN,  // virtual-key code
            0,    // hardware scan code
            0,    // flags specifying various function options
            0     // additional data associated with keystroke
            );
         }
         hb_retni( 1 );
         bDefault = FALSE;
         break;

      case WM_CHAR:
      case WM_LBUTTONDBLCLK:
         if( ! s_Events2 )
         {
            s_Events2 = hb_dynsymSymbol( hb_dynsymFind( "_OOHG_TGRID_EVENTS2" ) );
         }
         hb_vmPushSymbol( s_Events2 );
         hb_vmPushNil();
         hb_vmPush( pSelf );
         HWNDpush( hWnd );
         hb_vmPushLong( message );
         hb_vmPushLong( wParam );
         hb_vmPushLong( lParam );
         hb_vmDo( 5 );
         bDefault = FALSE;
         break;

      case WM_NOTIFY:
         if( ( ( NMHDR FAR * ) lParam )->hwndFrom == ( HWND ) SendMessage( hWnd, LVM_GETHEADER, 0, 0 ) )
         {
            if( ! s_Notify2 )
            {
               s_Notify2 = hb_dynsymSymbol( hb_dynsymFind( "_OOHG_TGRID_NOTIFY2" ) );
            }
            hb_vmPushSymbol( s_Notify2 );
            hb_vmPushNil();
            hb_vmPush( pSelf );
            hb_vmPushLong( wParam );
            hb_vmPushLong( lParam );
            hb_vmDo( 3 );
            if( ISNUM( -1 ) )
            {
               bDefault = FALSE;
            }
         }
         break;
   }

   if( bDefault )
   {
      _OOHG_Send( pSelf, s_Super );
      hb_vmSend( 0 );
      _OOHG_Send( hb_param( -1, HB_IT_OBJECT ), s_Events );
      HWNDpush( hWnd );
      hb_vmPushLong( message );
      hb_vmPushLong( wParam );
      hb_vmPushLong( lParam );
      hb_vmSend( 4 );
   }
}

HB_FUNC_STATIC( TGRID_FONTCOLOR )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &oSelf->lFontColor, ( hb_pcount() >= 1 ) ) )
   {
      if( ValidHandler( oSelf->hWnd ) )
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
   {
      if( ValidHandler( oSelf->hWnd ) )
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

HB_FUNC_STATIC( TGRID_COLUMNCOUNT )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   int iCount;

   if( ValidHandler( oSelf->hWnd ) )
   {
      iCount = Header_GetItemCount( ListView_GetHeader( oSelf->hWnd ) );
   }
   else
   {
      iCount = 0;
   }

   hb_retni( iCount );
}

HB_FUNC_STATIC( TGRID_HEADERHEIGHT )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   RECT rc;
   int iHeight;

   if( ValidHandler( oSelf->hWnd ) )
   {
      if( Header_GetItemRect( ListView_GetHeader( oSelf->hWnd ), 0, &rc ) )
      {
         iHeight = rc.bottom - rc.top;
      }
      else
      {
         iHeight = 0;
      }
   }
   else
   {
      iHeight = 0;
   }

   hb_retni( iHeight );
}

// -----------------------------------------------------------------------------
HB_FUNC_STATIC( TGRIDBYCELL_EVENTS )   // METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TGridByCell
// -----------------------------------------------------------------------------
{
   HWND hWnd      = HWNDparam( 1 );
   UINT message   = ( UINT )   hb_parni( 2 );
   WPARAM wParam  = ( WPARAM ) hb_parni( 3 );
   LPARAM lParam  = ( LPARAM ) hb_parnl( 4 );
   PHB_ITEM pSelf = hb_stackSelfItem();
   static PHB_SYMB s_Events2 = 0;
   static PHB_SYMB s_Notify2 = 0;
   BOOL bDefault = TRUE;

   switch( message )
   {
      case WM_CHAR:
      case WM_MOUSEWHEEL:
      case WM_LBUTTONDBLCLK:
      case WM_LBUTTONDOWN:
      case WM_RBUTTONDOWN:
         if( ! s_Events2 )
         {
            s_Events2 = hb_dynsymSymbol( hb_dynsymFind( "_OOHG_TGRIDBYCELL_EVENTS2" ) );
         }
         hb_vmPushSymbol( s_Events2 );
         hb_vmPushNil();
         hb_vmPush( pSelf );
         HWNDpush( hWnd );
         hb_vmPushLong( message );
         hb_vmPushLong( wParam );
         hb_vmPushLong( lParam );
         hb_vmDo( 5 );
         if( ISNUM( -1 ) )
         {
            bDefault = FALSE;
         }
         break;

      case WM_NOTIFY:
         if( ( ( NMHDR FAR * ) lParam )->hwndFrom == ( HWND ) SendMessage( hWnd, LVM_GETHEADER, 0, 0 ) )
         {
            if( ! s_Notify2 )
            {
               s_Notify2 = hb_dynsymSymbol( hb_dynsymFind( "_OOHG_TGRID_NOTIFY2" ) );
            }
            hb_vmPushSymbol( s_Notify2 );
            hb_vmPushNil();
            hb_vmPush( pSelf );
            hb_vmPushLong( wParam );
            hb_vmPushLong( lParam );
            hb_vmDo( 3 );
            if( ISNUM( -1 ) )
            {
               bDefault = FALSE;
            }
         }
         break;
   }

   if( bDefault )
   {
      _OOHG_Send( pSelf, s_Super );
      hb_vmSend( 0 );
      _OOHG_Send( hb_param( -1, HB_IT_OBJECT ), s_Events );
      HWNDpush( hWnd );
      hb_vmPushLong( message );
      hb_vmPushLong( wParam );
      hb_vmPushLong( lParam );
      hb_vmSend( 4 );
   }
}

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

HB_FUNC( INITLISTVIEW )
{
   HWND hwnd;
   HWND hbutton;
   int style, StyleEx, extStyle;

   INITCOMMONCONTROLSEX i;

   i.dwSize = sizeof( INITCOMMONCONTROLSEX );
   i.dwICC = ICC_DATE_CLASSES;
   InitCommonControlsEx( &i );

   hwnd = HWNDparam( 1 );

   StyleEx = WS_EX_CLIENTEDGE | _OOHG_RTL_Status( hb_parl( 13 ) );

   style = LVS_SHOWSELALWAYS | WS_CHILD | LVS_REPORT;
   if ( hb_parl( 10 ) )
   {
      style = style | LVS_OWNERDATA;
   }

   hbutton = CreateWindowEx(StyleEx,"SysListView32","",
   ( style | hb_parni( 12 ) ),
   hb_parni(3), hb_parni(4), hb_parni(5), hb_parni(6),
   hwnd, ( HMENU ) HWNDparam( 2 ), GetModuleHandle(NULL), NULL ) ;

   extStyle = hb_parni(9) | LVS_EX_FULLROWSELECT | LVS_EX_HEADERDRAGDROP | LVS_EX_SUBITEMIMAGES;
   if ( hb_parl( 14 ) )
   {
      extStyle = extStyle | LVS_EX_CHECKBOXES;
   }
   if ( hb_parl( 15 ) )
   {
      extStyle = extStyle | LVS_EX_DOUBLEBUFFER;
   }
   SendMessage(hbutton, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, extStyle );

   if ( hb_parl( 10 ) )
   {
      ListView_SetItemCount( hbutton, hb_parni( 11 ) ) ;
   }

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( hbutton, GWL_WNDPROC, ( LONG ) SubClassFunc );

   HWNDret( hbutton );
}

HB_FUNC( INITLISTVIEWCOLUMNS )
{
   PHB_ITEM wArray;
   PHB_ITEM hArray;
   PHB_ITEM jArray;

   HWND hc;
   LV_COLUMN COL;
   int iLen;
   int s;
   int iColumn;

   hc = HWNDparam( 1 );

   iLen = hb_parinfa( 2, 0 ) - 1;
   hArray = hb_param( 2, HB_IT_ARRAY );
   wArray = hb_param( 3, HB_IT_ARRAY );
   jArray = hb_param( 4, HB_IT_ARRAY );

   COL.mask = LVCF_FMT | LVCF_WIDTH | LVCF_TEXT | LVCF_SUBITEM;

   iColumn = 0;
   for( s = 0; s <= iLen; s++ )
   {
      COL.fmt = hb_arrayGetNI( jArray, s + 1 );
      COL.cx = hb_arrayGetNI( wArray, s + 1 );
      COL.pszText = ( char * ) hb_arrayGetCPtr( hArray, s + 1 );
      COL.iSubItem = iColumn;
      ListView_InsertColumn( hc, iColumn, &COL );
      if( iColumn == 0 && COL.fmt != LVCFMT_LEFT )
      {
         iColumn++;
         COL.iSubItem = iColumn;
         ListView_InsertColumn( hc, iColumn, &COL );
      }
      iColumn++;
   }

   if( iColumn != s )
   {
      ListView_DeleteColumn( hc, 0 );
   }
}

static void _OOHG_ListView_FillItem( HWND hWnd, int nItem, PHB_ITEM pItems )
{
   LV_ITEM LI;
   ULONG s, ulLen;
   struct IMAGE_PARAMETER pStruct;

   ulLen = hb_arrayLen( pItems );

   for( s = 0; s < ulLen; s++ )
   {
      LI.mask = LVIF_TEXT | LVIF_IMAGE;
      LI.state = 0;
      LI.stateMask = 0;
      LI.iItem = nItem;
      LI.iSubItem = s;
      ImageFillParameter( &pStruct, hb_arrayGetItemPtr( pItems, s + 1 ) );
      LI.pszText = pStruct.cString;
      LI.iImage = pStruct.iImage1;
      ListView_SetItem( hWnd, &LI );
   }
}

HB_FUNC( SETGRIDCOLUMNJUSTIFY )
{
   LV_COLUMN COL;

   COL.mask = LVCF_FMT;

   ListView_GetColumn( HWNDparam( 1 ), hb_parni( 2 ) - 1, &COL );

   COL.fmt &= ~ ( COL.fmt & LVCFMT_JUSTIFYMASK );

   COL.fmt |= hb_parni( 3 );

   ListView_SetColumn( HWNDparam( 1 ), hb_parni( 2 ) - 1, &COL );
}

HB_FUNC( SETGRIDCOLUMNHEADER )
{
   LV_COLUMN COL;

   COL.mask = LVCF_TEXT;
   COL.pszText = ( char * ) hb_parc( 3 ) ;
   COL.fmt = hb_parni( 4 ) ;

   ListView_SetColumn( HWNDparam( 1 ), hb_parni( 2 ) - 1, &COL );
}

HB_FUNC( SETHEADERIMAGELIST )
{
   SendMessage( ListView_GetHeader( HWNDparam( 1 ) ), HDM_SETIMAGELIST, 0, (LPARAM) hb_parnl( 2 ) );
}

HB_FUNC( SETGRIDCOLUMNIMAGE )
{
   LV_COLUMN COL;

   COL.mask = LVCF_FMT;

   ListView_GetColumn( HWNDparam( 1 ), hb_parni( 2 ) - 1, &COL );

   COL.mask |= LVCF_IMAGE;

   COL.fmt |= LVCFMT_IMAGE;

   if ( hb_parl( 4 ) )
   {
      COL.fmt |= LVCFMT_BITMAP_ON_RIGHT;
   }
   else
   {
      COL.fmt &= ~LVCFMT_BITMAP_ON_RIGHT;
   }

   COL.iImage = hb_parni( 3 ) - 1;

   ListView_SetColumn( HWNDparam( 1 ), hb_parni( 2 ) - 1, &COL );
}

HB_FUNC( REMOVEGRIDCOLUMNIMAGE )
{
   LV_COLUMN COL;

   COL.mask = LVCF_FMT | LVCF_IMAGE;

   ListView_GetColumn( HWNDparam( 1 ), hb_parni( 2 ) - 1, &COL );

   COL.fmt &= ~LVCFMT_IMAGE;
   COL.iImage = -1;

   ListView_SetColumn( HWNDparam( 1 ), hb_parni( 2 ) - 1, &COL );
}

HB_FUNC( ADDLISTVIEWITEMS )
{
   PHB_ITEM hArray;
   LV_ITEM LI;
   HWND h;
   int c;

   hArray = hb_param( 2, HB_IT_ARRAY );
   if( ! hArray || hb_arrayLen( hArray ) == 0 )
   {
      return;
   }
   h = HWNDparam( 1 );
   c = ListView_GetItemCount( h );

   // First "default" item
   LI.mask = LVIF_TEXT | LVIF_IMAGE;
   LI.state = 0;
   LI.stateMask = 0;
   LI.iItem = c;
   LI.iSubItem = 0;
   LI.pszText = "";
   LI.iImage = -1;
   ListView_InsertItem( h, &LI );

   _OOHG_ListView_FillItem( h, c, hArray );
}

HB_FUNC( INSERTLISTVIEWITEM )
{
   PHB_ITEM hArray;
   LV_ITEM LI;
   HWND h;
   int c;
   int nItem;

   hArray = hb_param( 2, HB_IT_ARRAY );
   if( ! hArray || hb_arrayLen( hArray ) == 0 )
   {
      return;
   }
   h = HWNDparam( 1 );
   c = hb_parni( 3 ) - 1;

   // First "default" item
   LI.mask = LVIF_TEXT | LVIF_IMAGE;
   LI.state = 0;
   LI.stateMask = 0;
   LI.iItem = c;
   LI.iSubItem = 0;
   LI.pszText = "";
   LI.iImage = -1;
   nItem = ListView_InsertItem( h, &LI ) + 1;

   if( nItem > 0)
   {
      _OOHG_ListView_FillItem( h, c, hArray );
   }

   hb_retni( nItem );
}

HB_FUNC( LISTVIEWSETITEM )
{
   _OOHG_ListView_FillItem( HWNDparam( 1 ), hb_parni( 3 ) - 1, hb_param( 2, HB_IT_ARRAY ) );
}

HB_FUNC( LISTVIEWGETITEM )
{
   char buffer[ 1024 ];
   HWND h;
   int s, c, l;
   LV_ITEM LI;
   PHB_ITEM pArray, pString;

   h = HWNDparam( 1 );

   c = hb_parni( 2 ) - 1;

   l = hb_parni( 3 );

   pArray = hb_itemArrayNew( l );
   pString = hb_itemNew( NULL );

   for( s = 0; s < l; s++ )
   {
      memset( &LI, 0, sizeof( LI ) );
      LI.iImage = -1;
      LI.mask = LVIF_TEXT | LVIF_IMAGE;
      LI.state = 0;
      LI.stateMask = 0;
      LI.iSubItem = s;
      LI.cchTextMax = 1022;
      LI.pszText = buffer;
      LI.iItem = c;
      buffer[ 0 ] = 0;
      buffer[ 1023 ] = 0;
      ListView_GetItem( h, &LI );
      buffer[ 1023 ] = 0;

      if( LI.iImage == -1 )
      {
         hb_itemPutC( pString, buffer );
      }
      else
      {
         hb_itemPutNI( pString, LI.iImage );
      }
      hb_itemArrayPut( pArray, s + 1, pString );
   }

   hb_itemReturn( pArray );
   hb_itemRelease( pArray );
   hb_itemRelease( pString );
}

HB_FUNC( FILLGRIDFROMARRAY )
{
   HWND hWnd = HWNDparam( 1 );
   ULONG iCount = ListView_GetItemCount( hWnd );
   PHB_ITEM pScreen = hb_param( 2, HB_IT_ARRAY );
   ULONG iLen = hb_arrayLen( pScreen );
   LV_ITEM LI;

   while( iCount > iLen )
   {
      iCount--;
      SendMessage( hWnd, LVM_DELETEITEM, ( WPARAM ) iCount, 0 );
   }
   while( iCount < iLen )
   {
      LI.mask = LVIF_TEXT | LVIF_IMAGE;
      LI.state = 0;
      LI.stateMask = 0;
      LI.iItem = iCount;
      LI.iSubItem = 0;
      LI.pszText = "";
      LI.iImage = -1;
      ListView_InsertItem( hWnd, &LI );
      iCount++;
   }

   for( iCount = 1; iCount <= iLen; iCount++ )
   {
      _OOHG_ListView_FillItem( hWnd, iCount, hb_arrayGetItemPtr( pScreen, iCount ) );
   }
}

HB_FUNC( CELLRAWVALUE )   // hWnd, nRow, nCol, nType, uValue
{
   HWND hWnd;
   LV_ITEM LI;
   char buffer[ 1024 ];
   int iType;

   hWnd = HWNDparam( 1 );
   iType = hb_parni( 4 );

   LI.mask = LVIF_TEXT | LVIF_IMAGE;
   LI.state = 0;
   LI.stateMask = 0;
   LI.iItem = hb_parni( 2 ) - 1;
   LI.iSubItem = hb_parni( 3 ) - 1;
   LI.cchTextMax = 1022;
   LI.pszText = buffer;
   buffer[ 0 ] = 0;
   buffer[ 1023 ] = 0;

   ListView_GetItem( hWnd, &LI );

   if( iType == 1 && ISCHAR( 5 ) )
   {
      LI.cchTextMax = 1022;
      LI.pszText = ( char * ) hb_parc( 5 );
      ListView_SetItem( hWnd, &LI );
   }
   else if( iType == 2 && ISNUM( 5 ) )
   {
      LI.iImage = hb_parni( 5 );
      ListView_SetItem( hWnd, &LI );
   }

   LI.cchTextMax = 1022;
   LI.pszText = buffer;
   buffer[ 0 ] = 0;
   buffer[ 1023 ] = 0;
   ListView_GetItem( hWnd, &LI );

   if( iType == 1 )
   {
      hb_retc( LI.pszText );
   }
   else // if( iType == 2 )
   {
      hb_retni( LI.iImage );
   }
}

typedef struct __OOHG_SortItemsInfo_ {
   HWND hWnd;
   int  iColumn;
   BOOL bDescending;
} _OOHG_SortItemsInfo;

PFNLVCOMPARE CALLBACK _OOHG_SortItems( LPARAM lParam1, LPARAM lParam2, LPARAM lParamSort )
{
   _OOHG_SortItemsInfo *si;
   int iRet;
   LVITEM lvItem1, lvItem2;
   char cString1[ 1024 ], cString2[ 1024 ];

   si = ( _OOHG_SortItemsInfo * ) lParamSort;

   lvItem1.mask       = LVIF_TEXT;
   lvItem1.iItem      = lParam1;
   lvItem1.iSubItem   = si->iColumn;
   lvItem1.cchTextMax = 1022;
   lvItem1.pszText    = cString1;
   cString1[ 0 ] = cString1[ 1023 ] = 0;
   ListView_GetItem( si->hWnd, &lvItem1 );
   cString1[ 1023 ] = 0;

   lvItem2.mask       = LVIF_TEXT;
   lvItem2.iItem      = lParam2;
   lvItem2.iSubItem   = si->iColumn;
   lvItem2.cchTextMax = 1022;
   lvItem2.pszText    = cString2;
   cString2[ 0 ] = cString2[ 1023 ] = 0;
   ListView_GetItem( si->hWnd, &lvItem2 );
   cString2[ 1023 ] = 0;

   iRet = strcmp( cString1, cString2 );
   if( si->bDescending )
   {
      iRet = - iRet;
   }

   return ( PFNLVCOMPARE ) iRet;
}

HB_FUNC( LISTVIEW_SORTITEMSEX )   // hWnd, nColumn, lDescending
{
   _OOHG_SortItemsInfo si;

   si.hWnd = HWNDparam( 1 );
   si.iColumn = hb_parni( 2 ) - 1;
   si.bDescending = hb_parl( 3 );
   hb_retni( SendMessage( si.hWnd, LVM_SORTITEMSEX,
                          ( WPARAM ) ( _OOHG_SortItemsInfo * ) &si,
                          ( LPARAM ) ( PFNLVCOMPARE ) _OOHG_SortItems ) );
}

HB_FUNC( NMHEADER_IITEM )
{
   hb_retnl( ( LONG ) ( ( ( NMHEADER * ) hb_parnl( 1 ) )->iItem ) + 1 );
}

HB_FUNC( LISTVIEW_SETITEMCOUNT )
{
   ListView_SetItemCount ( HWNDparam( 1 ), hb_parni( 2 ) ) ;
}

HB_FUNC( LISTVIEW_GETFIRSTITEM )
{
   hb_retni( ListView_GetNextItem( HWNDparam( 1 ), -1, LVNI_ALL | LVNI_SELECTED ) + 1 );
}

HB_FUNC( LISTVIEW_SETCURSEL )
{
   ListView_SetItemState( HWNDparam( 1 ), ( WPARAM ) hb_parni( 2 ) -1, LVIS_FOCUSED | LVIS_SELECTED, LVIS_FOCUSED | LVIS_SELECTED );
}

HB_FUNC( LISTVIEW_CLEARCURSEL )
{
   ListView_SetItemState( HWNDparam( 1 ), ( WPARAM ) hb_parni( 2 ) - 1, 0, LVIS_FOCUSED | LVIS_SELECTED );
}

HB_FUNC( LISTVIEWDELETESTRING )
{
   SendMessage( HWNDparam( 1 ), LVM_DELETEITEM, ( WPARAM ) hb_parni( 2 ) -1, 0 );
}

HB_FUNC( LISTVIEWRESET )
{
   SendMessage( HWNDparam( 1 ), LVM_DELETEALLITEMS, 0, 0 );
}

HB_FUNC( LISTVIEWGETMULTISEL )
{
   HWND hwnd = HWNDparam( 1 );
   int i;
   int n;
   int j;

   n = SendMessage( hwnd, LVM_GETSELECTEDCOUNT, 0, 0 );

   hb_reta( n );

   i = -1;
   j = 0;

   while( 1 )
   {
      i = ListView_GetNextItem( hwnd, i, LVNI_ALL | LVNI_SELECTED );

      if( i == -1 )
      {
         break;
      }
      else
      {
         j++;
      }

      HB_STORNI( i + 1, -1, j );
   }
}

HB_FUNC( LISTVIEWSETMULTISEL )
{
   PHB_ITEM wArray;
   HWND hwnd = HWNDparam( 1 );
   int i, l, n;

   wArray = hb_param( 2, HB_IT_ARRAY );

   l = hb_parinfa( 2, 0 ) - 1;

   n = SendMessage( hwnd, LVM_GETITEMCOUNT, 0, 0 );

   // CLEAR CURRENT SELECTIONS
   for( i = 0; i < n; i++ )
   {
      ListView_SetItemState( hwnd, ( WPARAM ) i, 0, LVIS_FOCUSED | LVIS_SELECTED );
   }

   // SET NEW SELECTIONS
   for( i = 0; i <= l; i++ )
   {
      ListView_SetItemState( hwnd, hb_arrayGetNI( wArray, i + 1 ) - 1, LVIS_FOCUSED | LVIS_SELECTED, LVIS_FOCUSED | LVIS_SELECTED );
   }
}

HB_FUNC( LISTVIEWGETITEMROW )
{
   POINT point;

   ListView_GetItemPosition( HWNDparam( 1 ), hb_parni( 2 ), &point );

   hb_retnl( point.y );
}

HB_FUNC( LISTVIEWGETITEMCOUNT )
{
   hb_retnl( ListView_GetItemCount( HWNDparam( 1 ) ) );
}


HB_FUNC( LISTVIEWGETCOUNTPERPAGE )
{
   hb_retnl( ListView_GetCountPerPage( HWNDparam( 1 ) ) );
}

HB_FUNC( LISTVIEW_ENSUREVISIBLE )
{
   hb_retl( ListView_EnsureVisible( HWNDparam( 1 ), hb_parni( 2 ) - 1, 1 ) );
}

HB_FUNC( LISTVIEW_GETTOPINDEX )
{
   hb_retnl( ListView_GetTopIndex( HWNDparam( 1 ) ) );
}

HB_FUNC( LISTVIEW_REDRAWITEMS )
{
   hb_retnl( ListView_RedrawItems( HWNDparam( 1 ), hb_parni( 2 ) - 1, hb_parni( 3 ) - 1 ) );
}

HB_FUNC( LISTVIEW_HITTEST )
{
   POINT point ;
   LVHITTESTINFO lvhti;

   point.y = hb_parni( 2 );
   point.x = hb_parni( 3 );

   lvhti.pt = point;

   ListView_SubItemHitTest( HWNDparam( 1 ), &lvhti );

   if( lvhti.flags & LVHT_ONITEM )
   {
      hb_reta( 2 );
      HB_STORNI( lvhti.iItem + 1, -1, 1 );
      HB_STORNI( lvhti.iSubItem + 1, -1, 2 );
   }
   else
   {
      hb_reta( 2 );
      HB_STORNI( 0, -1, 1 );
      HB_STORNI( 0, -1, 2 );
   }
}

HB_FUNC( LISTVIEW_HITONCHECKBOX )
{
   POINT point ;
   LVHITTESTINFO lvhti;
   int item;

   point.y = hb_parni( 2 );
   point.x = hb_parni( 3 );

   lvhti.pt = point;

   ListView_SubItemHitTest( HWNDparam( 1 ), &lvhti );
   
   if( lvhti.flags == LVHT_ONITEMSTATEICON )
   {
      item = lvhti.iItem + 1;
   }
   else
   {
      item = 0;
   }
   
   hb_retni( item );
}

HB_FUNC( LISTVIEW_GETSUBITEMRECT )
{
   RECT Rect ;
   LPRECT lpRect = (LPRECT) &Rect ;

   ListView_GetSubItemRect( HWNDparam( 1 ), hb_parni( 2 ), hb_parni( 3 ), LVIR_BOUNDS, lpRect );

   hb_reta( 4 );
   HB_STORNI( Rect.top,  -1, 1 );
   HB_STORNI( Rect.left, -1, 2 );
   HB_STORNI( Rect.right  - Rect.left, -1, 3 );
   HB_STORNI( Rect.bottom - Rect.top,  -1, 4 );
}

HB_FUNC( LISTVIEW_GETITEMRECT )
{
   RECT Rect ;
   LPRECT lpRect = (LPRECT) &Rect ;

   ListView_GetItemRect( HWNDparam( 1 ), hb_parni( 2 ), lpRect, LVIR_LABEL );

   hb_reta( 4 );
   HB_STORNI( Rect.top,  -1, 1 );
   HB_STORNI( Rect.left, -1, 2 );
   HB_STORNI( Rect.right  - Rect.left, -1, 3 );
   HB_STORNI( Rect.bottom - Rect.top,  -1, 4 );
}

HB_FUNC( LISTVIEW_UPDATE )
{
   ListView_Update( HWNDparam( 1 ), hb_parni( 2 ) - 1 );
}

HB_FUNC( LISTVIEW_SCROLL )
{
   ListView_Scroll( HWNDparam( 1 ), hb_parni( 2 ), hb_parni( 3 ) );
}

HB_FUNC( LISTVIEW_SETBKCOLOR )
{
   ListView_SetBkColor( HWNDparam( 1 ), ( COLORREF ) RGB( hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ) ) );
}

HB_FUNC( LISTVIEW_SETTEXTBKCOLOR )
{
   ListView_SetTextBkColor( HWNDparam( 1 ), ( COLORREF ) RGB( hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ) ) );
}

HB_FUNC( LISTVIEW_SETTEXTCOLOR )
{
   ListView_SetTextColor( HWNDparam( 1 ), ( COLORREF ) RGB( hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ) ) );
}

HB_FUNC( LISTVIEW_GETTEXTCOLOR )
{
   hb_retnl( ListView_GetTextColor( HWNDparam( 1 ) ) );
}

HB_FUNC( LISTVIEW_GETBKCOLOR )
{
   hb_retnl( ListView_GetBkColor( HWNDparam( 1 ) ) );
}

HB_FUNC( LISTVIEW_GETCOLUMNWIDTH )
{
   hb_retni( ListView_GetColumnWidth( HWNDparam( 1 ), hb_parni( 2 ) ) );
}

HB_FUNC( LISTVIEW_SETCOLUMNWIDTH )
{
   HWND hWnd = HWNDparam( 1 );
   int iColumn = hb_parni( 2 );

   ListView_SetColumnWidth( hWnd, iColumn, hb_parni( 3 ) );
   hb_retni( ListView_GetColumnWidth( hWnd, iColumn ) );
}

HB_FUNC( _OOHG_GRIDARRAYWIDTHS )
{
   HWND hWnd = HWNDparam( 1 );
   PHB_ITEM pArray = hb_param( 2, HB_IT_ARRAY );
   ULONG iSum = 0, iCount, iSize;

   if( pArray )
   {
      for( iCount = 0; iCount < hb_arrayLen( pArray ); iCount++ )
      {
         iSize = ListView_GetColumnWidth( hWnd, iCount );
         iSum += iSize;
         HB_STORNI( iSize, 2, iCount + 1 );
      }
   }

   hb_retni( iSum );
}

HB_FUNC( LISTVIEW_ADDCOLUMN )
{
   LV_COLUMN COL;
   int iColumn = hb_parni( 2 ) - 1;
   HWND hwnd = HWNDparam( 1 );

   if( iColumn < 0 )
   {
      return;
   }

   COL.mask = LVCF_WIDTH | LVCF_TEXT | LVCF_FMT | LVCF_SUBITEM; // | LVCF_IMAGE;
   COL.cx = hb_parni( 3 );
   COL.pszText = ( char * ) hb_parc( 4 );
   COL.iSubItem = iColumn;
   COL.fmt = hb_parni( 5 ); // | LVCFMT_IMAGE;

   ListView_InsertColumn( hwnd, iColumn, &COL );
   if( iColumn == 0 && COL.fmt != LVCFMT_LEFT )
   {
      COL.iSubItem = 1;
      ListView_InsertColumn( hwnd, 1, &COL );
      ListView_DeleteColumn( hwnd, 0 );
   }

   if( ! hb_parl( 6 ) )
   {
      SendMessage( hwnd, LVM_DELETEALLITEMS, 0, 0 );
      RedrawWindow( hwnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
   }
}

HB_FUNC( LISTVIEW_DELETECOLUMN )
{
   HWND hwnd = HWNDparam( 1 );
   int iColumn = hb_parni( 2 ) - 1;

   if( iColumn < 0 )
   {
      return;
   }

   ListView_DeleteColumn( hwnd, iColumn );

   if( ! hb_parl( 3 ) )
   {
      SendMessage( hwnd, LVM_DELETEALLITEMS, 0, 0 );
      RedrawWindow( hwnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
   }
}

HB_FUNC( GETGRIDVKEY )
{
   hb_retnl( ( LPARAM ) ( ( ( LV_KEYDOWN * ) hb_parnl( 1 ) ) -> wVKey ) );
}

HB_FUNC( GETGRIDVKEYASCHAR )
{
   hb_retni( MapVirtualKey( (UINT) ( ( (LV_KEYDOWN *) hb_parnl( 1 ) ) -> wVKey ), 2 ) );
}

static int TGrid_Notify_CustomDraw_GetColor( PHB_ITEM pSelf, unsigned int x, unsigned int y, int sGridColor, int sObjColor, int iDefaultColor )
{
   PHB_ITEM pColor;
   LONG iColor;

   _OOHG_Send( pSelf, sGridColor );
   hb_vmSend( 0 );

   pColor = hb_param( -1, HB_IT_ARRAY );
   if( pColor &&                                                 // ValType( aColor ) == "A"
       hb_arrayLen( pColor ) >= y &&                             // Len( aColor ) >= y
       HB_IS_ARRAY( hb_arrayGetItemPtr( pColor, y ) ) &&         // ValType( aColor[ y ] ) == "A"
       hb_arrayLen( hb_arrayGetItemPtr( pColor, y ) ) >= x )     // Len( aColor[ y ] ) >= x
   {
      pColor = hb_arrayGetItemPtr( hb_arrayGetItemPtr( pColor, y ), x );
   }
   else
   {
      pColor = NULL;
   }

   iColor = -1;

   if( ! _OOHG_DetermineColor( pColor, &iColor ) || iColor == -1 )
   {
      _OOHG_Send( pSelf, sObjColor );
      hb_vmSend( 0 );
      if( ! _OOHG_DetermineColor( hb_param( -1, HB_IT_ANY ), &iColor ) || iColor == -1 )
      {
         iColor = GetSysColor( iDefaultColor );
      }
   }

   return iColor;
}

static int TGrid_Notify_CustomDraw_GetSelColor( PHB_ITEM pSelf, unsigned int x )
{
   PHB_ITEM pColor;
   LONG iColor = -1;
   char cBuffError[ 1000 ];

   _OOHG_Send( pSelf, s_GridSelectedColors );
   hb_vmSend( 0 );

   pColor = hb_param( -1, HB_IT_ARRAY );
   if( pColor &&                                                 // ValType( aColor ) == "A"
       hb_arrayLen( pColor ) >= x )                              // Len( aColor[ y ] ) >= x
   {
      pColor = hb_arrayGetItemPtr( pColor, x );

      if( _OOHG_DetermineColor( pColor, &iColor ) || iColor == -1 )
      {
         return iColor;
      }
   }

   sprintf( cBuffError, "GridSelectedColors is not a valid array !!!" );
   MessageBox( 0, cBuffError, "Error", MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
   ExitProcess( 0 );
   return 0;
}

int TGrid_Notify_CustomDraw( PHB_ITEM pSelf, LPARAM lParam, BOOL bByCell, int iRow, int iCol, BOOL bCheckBoxes, BOOL bFocusRect, BOOL bNoGrid, BOOL bPLM )
{
   LPNMLVCUSTOMDRAW lplvcd;
   int x, y;
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   RECT rcIcon, rcBack;
   HBRUSH hBrush;
   LV_ITEM LI;
   char buffer[ 1024 ];

   lplvcd = ( LPNMLVCUSTOMDRAW ) lParam;

   if( lplvcd->nmcd.dwDrawStage == CDDS_PREPAINT )
   {
      return CDRF_NOTIFYITEMDRAW;
   }
   else if( lplvcd->nmcd.dwDrawStage == CDDS_ITEMPREPAINT )
   {
      return CDRF_NOTIFYSUBITEMDRAW;
   }
   else if( lplvcd->nmcd.dwDrawStage == ( CDDS_SUBITEM | CDDS_ITEMPREPAINT ) )
   {
      // Get subitem's image, text and state
      memset( &LI, 0, sizeof( LI ) );
      LI.mask = LVIF_TEXT | LVIF_IMAGE | LVIF_STATE;
      LI.state = 0;
      LI.stateMask = LVIS_SELECTED | LVIS_FOCUSED;
      LI.iImage = -1;
      LI.iItem = lplvcd->nmcd.dwItemSpec;
      LI.iSubItem = lplvcd->iSubItem;
      LI.cchTextMax = 1022;
      LI.pszText = buffer;
      buffer[ 0 ] = 0;
      buffer[ 1023 ] = 0;
      ListView_GetItem( lplvcd->nmcd.hdr.hwndFrom, &LI );
      buffer[ 1023 ] = 0;

      // Get subitem's row (y) and col (x)
      x = lplvcd->iSubItem + 1;
      y = lplvcd->nmcd.dwItemSpec + 1;

      /*
       * Can't use (lplvcd->nmcd.uItemState | CDIS_SELECTED) to tell if the
       * subitem is selected when ListView control has LVS_SHOWSELALWAYS style.
       * See http://msdn.microsoft.com/en-us/library/bb775483(v=vs.85).aspx
       */

      // Get text's color and background color
      if( LI.state & LVIS_SELECTED )
      {
         if( bByCell )
         {
            if( ( y == iRow ) && ( x == iCol ) )
            {
               if( GetFocus() == lplvcd->nmcd.hdr.hwndFrom )
               {
                  lplvcd->clrText   = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 1 );
                  lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 2 );
               }
               else
               {
                  lplvcd->clrText   = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 3 );
                  lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 4 );
               }
            }
            else
            {
               if( GetFocus() == lplvcd->nmcd.hdr.hwndFrom )
               {
                  lplvcd->clrText   = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 5 );
                  lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 6 );
               }
               else
               {
                  lplvcd->clrText   = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 7 );
                  lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 8 );
               }
               if( lplvcd->clrText == (COLORREF) -1 )
               {
                  lplvcd->clrText   = TGrid_Notify_CustomDraw_GetColor( pSelf, x, y, s_GridForeColor, s_FontColor, COLOR_WINDOWTEXT );
               }
               if( lplvcd->clrTextBk == (COLORREF) -1 )
               {
                  lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetColor( pSelf, x, y, s_GridBackColor, s_BackColor, COLOR_WINDOW );
               }
            }
         }
         else
         {
            if( GetFocus() == lplvcd->nmcd.hdr.hwndFrom )
            {
               lplvcd->clrText   = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 1 );
               lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 2 );
            }
            else
            {
               lplvcd->clrText   = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 3 );
               lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 4 );
            }
         }
      }
      else
      {
         lplvcd->clrText   = TGrid_Notify_CustomDraw_GetColor( pSelf, x, y, s_GridForeColor, s_FontColor, COLOR_WINDOWTEXT );
         lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetColor( pSelf, x, y, s_GridBackColor, s_BackColor, COLOR_WINDOW );
      }

      if( LI.state & LVIS_SELECTED )
      {
         lplvcd->nmcd.uItemState -= CDIS_SELECTED;
      }

      if( GetFocus() == lplvcd->nmcd.hdr.hwndFrom )
      {
         if ( LI.state & LVIS_FOCUSED )
         {
            if( ! bFocusRect )
            {
               lplvcd->nmcd.uItemState -= CDIS_FOCUS;
            }
         }
      }

      return CDRF_DODEFAULT | CDRF_NOTIFYPOSTPAINT;
   }
   else if( lplvcd->nmcd.dwDrawStage == ( CDDS_SUBITEM | CDDS_ITEMPOSTPAINT ) )
   {
      // Get subitem's image and state
      memset( &LI, 0, sizeof( LI ) );
      LI.mask = LVIF_IMAGE | LVIF_STATE;
      LI.iImage = -1;
      LI.state = 0;
      LI.stateMask = LVIS_SELECTED;
      LI.iItem = lplvcd->nmcd.dwItemSpec;
      LI.iSubItem = lplvcd->iSubItem;
      ListView_GetItem( lplvcd->nmcd.hdr.hwndFrom, &LI );

      // Get background color
      x = lplvcd->iSubItem + 1;
      y = lplvcd->nmcd.dwItemSpec + 1;

      // Get text's color and background color
      if( LI.state & LVIS_SELECTED )
      {
         if( bByCell )
         {
            if( ( y == iRow ) && ( x == iCol ) )
            {
               if( GetFocus() == lplvcd->nmcd.hdr.hwndFrom )
               {
                  lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 2 );
               }
               else
               {
                  lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 4 );
               }
            }
            else
            {
               if( GetFocus() == lplvcd->nmcd.hdr.hwndFrom )
               {
                  lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 6 );
               }
               else
               {
                  lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 8 );
               }
               if( lplvcd->clrTextBk == (COLORREF) -1 )
               {
                  lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetColor( pSelf, x, y, s_GridBackColor, s_BackColor, COLOR_WINDOW );
               }
            }
         }
         else
         {
            if( GetFocus() == lplvcd->nmcd.hdr.hwndFrom )
            {
               lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 2 );
            }
            else
            {
               lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 4 );
            }
         }
      }
      else
      {
         lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetColor( pSelf, x, y, s_GridBackColor, s_BackColor, COLOR_WINDOW );
      }

      // Subitem has image?
      if( LI.iImage != -1 )
      {
         // Get icon's rect
         ListView_GetSubItemRect( lplvcd->nmcd.hdr.hwndFrom, lplvcd->nmcd.dwItemSpec, lplvcd->iSubItem, LVIR_ICON, &rcIcon );

         // Calculate area for background and paint it
         if( x == 1)
         {
            rcBack.top = rcIcon.top;
            rcBack.left = ( ( x == 1 ) && ( ! bCheckBoxes ) && bPLM ) ? 0 : rcIcon.left;
            rcBack.bottom = bNoGrid ? rcIcon.bottom : ( rcIcon.bottom - 1 );
            rcBack.right = rcIcon.right;
         }
         else
         {
            rcBack.top = rcIcon.top;
            rcBack.left = rcIcon.left;
            rcBack.bottom = bNoGrid ? rcIcon.bottom : ( rcIcon.bottom - 1 );
            rcBack.right = rcIcon.right + 2;
            rcIcon.left += 2;
         }

         hBrush = CreateSolidBrush( lplvcd->clrTextBk );
         FillRect( lplvcd->nmcd.hdc, &rcBack, hBrush );
         DeleteObject( hBrush );

         // Draw image
         ImageList_DrawEx( oSelf->ImageList, LI.iImage, lplvcd->nmcd.hdc, rcIcon.left, rcIcon.top, 0, 0, CLR_DEFAULT, CLR_NONE, ILD_TRANSPARENT );

         return CDRF_SKIPDEFAULT;
      }
      else if( ( x == 1 ) && ( ! bCheckBoxes ) && bPLM )    // Is first subitem and has no image nor checkbox?
      {
         // Get icon's rect
         ListView_GetSubItemRect( lplvcd->nmcd.hdr.hwndFrom, lplvcd->nmcd.dwItemSpec, lplvcd->iSubItem, LVIR_ICON, &rcIcon );

         // Calculate area for background
         rcBack.top = rcIcon.top;
         rcBack.left = 0;
         rcBack.bottom = rcIcon.bottom - 1;
         rcBack.right = rcIcon.right;

         // Paint to get rid of empty space at left
         hBrush = CreateSolidBrush( lplvcd->clrTextBk );
         FillRect( lplvcd->nmcd.hdc, &rcBack, hBrush );
         DeleteObject( hBrush );

         return CDRF_SKIPDEFAULT;
      }

      return CDRF_DODEFAULT;
   }
   else
   {
      return CDRF_DODEFAULT;
   }
}

HB_FUNC( TGRID_NOTIFY_CUSTOMDRAW )
{
   hb_retni( TGrid_Notify_CustomDraw( hb_param( 1, HB_IT_OBJECT ), ( LPARAM ) hb_parnl( 2 ), hb_parl( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parl( 6 ), hb_parl( 7 ), hb_parl( 8 ), hb_parl( 9 ) ) );
}

HB_FUNC( LISTVIEW_GETCHECKSTATE )
{
   hb_retl( ListView_GetCheckState( HWNDparam( 1 ), hb_parni( 2 ) - 1 ) ) ;
}

HB_FUNC( LISTVIEW_SETCHECKSTATE )
{
   ListView_SetCheckState( HWNDparam( 1 ), hb_parni( 2 ) - 1, hb_parl( 3 ) ) ;
}

HB_FUNC( LISTVIEW_GETIMAGELIST )
{
   HWNDret( ListView_GetImageList( HWNDparam( 1 ), hb_parni( 2 ) ) ) ;
}

HB_FUNC( GETDIALOGBASEUNITS )
{
   hb_retnl( GetDialogBaseUnits() ) ;
}

HB_FUNC( LISTVIEW_FINDITEM )
{
   LVFINDINFO fi;

   fi.psz = (LPCTSTR) hb_parc( 3 );
   fi.flags = LVFI_PARTIAL;
   if( hb_parl( 4 ) )
   {
      fi.flags |= LVFI_WRAP;
   }

   hb_retni( ListView_FindItem( HWNDparam( 1 ), (WPARAM) hb_parni( 2 ), (LPARAM) &fi ) + 1 );
}

#ifdef __XHARBOUR__
#include "hbdate.h"
HB_FUNC( HB_MILLISECONDS )
{
   hb_retnint( hb_dateMilliSeconds() );
}
#endif

#pragma ENDDUMP
