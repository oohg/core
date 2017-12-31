/*
* $Id: h_grid.prg $
*/
/*
* ooHG source code:
* Grid, GridMulti, GridByCell and GridControl controls
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

CLASS TGrid FROM TControl

   DATA aEditControls             INIT Nil
   DATA aEditKeys                 INIT Nil
   DATA aHeadClick                INIT Nil
   DATA aHeaderImage              INIT {}
   DATA aHeaderImageAlign         INIT {}
   DATA aHeaders                  INIT {}
   DATA aHiddenCols               INIT {}
   DATA aJust                     INIT Nil
   DATA AllowAppend               INIT .F.
   DATA AllowChangeSize           INIT .T.
   DATA AllowDelete               INIT .F.
   DATA AllowEdit                 INIT .F.
   DATA AllowMoveColumn           INIT .T.
   DATA aSelectedColors           INIT {}
   DATA aWhen                     INIT {}
   DATA aWidths                   INIT {}
   DATA bAfterColMove             INIT Nil
   DATA bAfterColSize             INIT Nil
   DATA bBeforeAutofit            INIT Nil
   DATA bBeforeColMove            INIT Nil
   DATA bBeforeColSize            INIT Nil
   DATA bCompareItems             INIT Nil
   DATA bDelWhen                  INIT Nil
   DATA bEditCellValue            INIT Nil
   DATA bHeadRClick               INIT Nil
   DATA bOnEnter                  INIT Nil
   DATA bPosition                 INIT 0
   DATA cEditKey                  INIT "F2"
   DATA ClickOnCheckbox           INIT .T.
   DATA cRowEditTitle             INIT Nil
   DATA cText                     INIT ""
   DATA DelMsg                    INIT Nil
   DATA DynamicBackColor          INIT {}
   DATA DynamicForeColor          INIT {}
   DATA EditControls              INIT Nil
   DATA FullMove                  INIT .F.
   DATA GridBackColor             INIT {}
   DATA GridForeColor             INIT {}
   DATA GridSelectedColors        INIT {}
   DATA HeaderFontHandle          INIT 0
   DATA HeaderImageList           INIT 0
   DATA ImageListColor            INIT CLR_DEFAULT
   DATA ImageListFlags            INIT LR_LOADTRANSPARENT + LR_DEFAULTCOLOR + LR_LOADMAP3DCOLORS
   DATA InPlace                   INIT .F.
   DATA lAppendMode               INIT .F.
   DATA lAppendOnAltA             INIT .F.
   DATA lAtFirstCol               INIT .T.
   DATA lBeginTrack               INIT .F.
   DATA lButtons                  INIT .F.
   DATA lCalledFromClass          INIT .F. PROTECTED
   DATA lChangeBeforeEdit         INIT .F.
   DATA lCheckBoxes               INIT .F.
   DATA lDividerDblclick          INIT .F.
   DATA lEditMode                 INIT .F.
   DATA lEndTrack                 INIT .F.
   DATA lExtendDblClick           INIT .F.
   DATA lFixedControls            INIT .F.
   DATA lFocusRect                INIT .T.
   DATA lKeysLikeClipper          INIT .F.
   DATA lLikeExcel                INIT .F.
   DATA lKeysOn                   INIT .T.
   DATA lNested                   INIT .F.
   DATA lNestedEdit               INIT .F.
   DATA lNoDelMsg                 INIT .F.
   DATA lNoGrid                   INIT .F.
   DATA lNoModal                  INIT .F.
   DATA lNoneUnsels               INIT .F.
   DATA lPLM                      INIT .F.
   DATA lScrollBarUsesClientArea  INIT .F.
   DATA lShowItemAtTop            INIT .F.
   DATA lSilent                   INIT .F.
   DATA lTracking                 INIT .F.
   DATA nColPos                   INIT 0 PROTECTED
   DATA nDelayedClick             INIT { 0, 0, 0, Nil } PROTECTED
   DATA nEditRow                  INIT 0 PROTECTED
   DATA nHeight                   INIT 120
   DATA nRowPos                   INIT 0 PROTECTED
   DATA nVisibleItems             INIT 0
   DATA nWidth                    INIT 240
   DATA OnAbortEdit               INIT Nil
   DATA OnAppend                  INIT Nil
   DATA OnBeforeEditCell          INIT Nil
   DATA OnCheckChange             INIT Nil
   DATA onDelete                  INIT Nil
   DATA OnDispInfo                INIT Nil
   DATA OnEditCell                INIT Nil
   DATA OnEditCellEnd             INIT Nil
   DATA OnInsert                  INIT Nil
   DATA Picture                   INIT Nil
   DATA RClickOnCheckbox          INIT .T.
   DATA ReadOnly                  INIT Nil
   DATA SearchCol                 INIT 0
   DATA SearchLapse               INIT 1000
   DATA SearchWrap                INIT .T.
   DATA SetImageListCommand       INIT LVM_SETIMAGELIST
   DATA SetImageListWParam        INIT LVSIL_SMALL
   DATA Type                      INIT "GRID" READONLY
   DATA uIniTime                  INIT 0
   DATA Valid                     INIT Nil
   DATA ValidMessages             INIT Nil

   METHOD AddBitMap
   METHOD AddColumn
   METHOD AddItem
   METHOD AdjustResize
   METHOD Append                  SETGET
   METHOD AppendItem
   METHOD BackColor               SETGET
   METHOD Cell
   METHOD CellCaption             BLOCK { | Self, nRow, nCol, uValue | CellRawValue( ::hWnd, nRow, nCol, 1, uValue ) }
   METHOD CellImage               BLOCK { | Self, nRow, nCol, uValue | CellRawValue( ::hWnd, nRow, nCol, 2, uValue ) }
   METHOD CheckItem               SETGET
   METHOD ColumnAutoFit
   METHOD ColumnAutoFitH
   METHOD ColumnBetterAutoFit
   METHOD ColumnCount
   METHOD ColumnHide
   METHOD ColumnOrder             SETGET
   METHOD ColumnsAutoFit
   METHOD ColumnsAutoFitH
   METHOD ColumnsBetterAutoFit
   METHOD ColumnShow
   METHOD ColumnWidth
   METHOD CompareItems
   METHOD CountPerPage            BLOCK { | Self | ListViewGetCountPerPage( ::hWnd ) }
   METHOD Define
   METHOD Define2
   METHOD Define4
   METHOD DeleteAllItems          BLOCK { | Self | ListViewReset( ::hWnd ), ::GridForeColor := Nil, ::GridBackColor := Nil, ::DoChange() }
   METHOD DeleteColumn
   METHOD DeleteItem
   METHOD Down
   METHOD EditAllCells
   METHOD EditCell
   METHOD EditCell2
   METHOD EditGrid
   METHOD EditItem
   METHOD EditItem2
   METHOD Events
   METHOD Events_Enter
   METHOD Events_Notify
   METHOD FirstColInOrder
   METHOD FirstSelectedItem       BLOCK { | Self | ListView_GetFirstItem( ::hWnd ) }
   METHOD FirstVisibleColumn
   METHOD FirstVisibleItem
   METHOD FixControls             SETGET
   METHOD FontColor               SETGET
   METHOD GoBottom
   METHOD GoTop
   METHOD Header
   METHOD HeaderHeight
   METHOD HeaderImage
   METHOD HeaderImageAlign
   METHOD HeaderSetFont
   METHOD InsertBlank
   METHOD InsertItem
   METHOD IsColumnReadOnly
   METHOD IsColumnWhen
   METHOD Item
   METHOD ItemCount               BLOCK { | Self | ListViewGetItemCount( ::hWnd ) }
   METHOD ItemHeight
   METHOD Justify
   METHOD LastColInOrder
   METHOD LastVisibleColumn
   METHOD Left
   METHOD LoadHeaderImages
   METHOD NextColInOrder
   METHOD OnEnter                 SETGET
   METHOD PageDown
   METHOD PageUp
   METHOD PriorColInOrder
   METHOD Release
   METHOD Right
   METHOD ScrollToCol
   METHOD ScrollToLeft
   METHOD ScrollToNext
   METHOD ScrollToPrior
   METHOD ScrollToRight
   METHOD SetColumn
   METHOD SetControlValue         BLOCK { |Self, nRow, nCol| Empty( nCol ), ::Value := nRow }
   METHOD SetItemColor
   METHOD SetRangeColor
   METHOD SetSelectedColors
   METHOD SortColumn
   METHOD SortItems
   METHOD ToExcel
   METHOD ToOpenOffice
   METHOD Up
   METHOD Value                   SETGET

   MESSAGE End                    METHOD GoBottom
   MESSAGE Home                   METHOD GoTop
   MESSAGE PanToLeft              METHOD ScrollToPrior
   MESSAGE PanToRight             METHOD ScrollToNext

   ENDCLASS

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
      lFocusRect, lPLM, lFixedCols, abortedit, click, lFixedWidths, ;
      bBeforeColMove, bAfterColMove, bBeforeColSize, bAfterColSize, ;
      bBeforeAutofit, lLikeExcel, lButtons, AllowDelete, onDelete, ;
      bDelWhen, DelMsg, lNoDelMsg, AllowAppend, onappend, lNoModal, ;
      lFixedCtrls, bHeadRClick, lClickOnCheckbox, lRClickOnCheckbox, ;
      lExtDbl, lSilent, lAltA, lNoShowAlways, lNone, lCBE, onrclick, ;
      oninsert, editend, lAtFirst, bbeforeditcell, bEditCellValue, klc ) CLASS TGrid

   ::Define2( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, aRows, ;
      value, fontname, fontsize, tooltip, aHeadClick, nogrid, ;
      aImage, aJust, break, HelpId, bold, italic, underline, ;
      strikeout, ownerdata, itemcount, editable, backcolor, ;
      fontcolor, dynamicbackcolor, dynamicforecolor, aPicture, lRtl, ;
      LVS_SINGLESEL, inplace, editcontrols, readonly, valid, validmessages, ;
      aWhenFields, lDisabled, lNoTabStop, lInvisible, lHasHeaders, ;
      aHeaderImage, aHeaderImageAlign, FullMove, aSelectedColors, ;
      aEditKeys, lCheckBoxes, lDblBffr, lFocusRect, lPLM, ;
      lFixedCols, lFixedWidths, lLikeExcel, lButtons, AllowDelete, ;
      DelMsg, lNoDelMsg, AllowAppend, lNoModal, lFixedCtrls, ;
      lClickOnCheckbox, lRClickOnCheckbox, lExtDbl, lSilent, lAltA, ;
      lNoShowAlways, lNone, lCBE, lAtFirst, klc )

   // Must be set after control is initialized
   ::Define4( change, dblclick, gotfocus, lostfocus, ondispinfo, editcell, ;
      onenter, oncheck, abortedit, click, bbeforecolmove, baftercolmove, ;
      bbeforecolsize, baftercolsize, bbeforeautofit, ondelete, ;
      bdelwhen, onappend, bheadrclick, onrclick, oninsert, editend, ;
      bbeforeditcell, bEditCellValue )

   RETURN Self

METHOD Define2( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, aRows, ;
      value, fontname, fontsize, tooltip, aHeadClick, nogrid, ;
      aImage, aJust, break, HelpId, bold, italic, underline, ;
      strikeout, ownerdata, itemcount, editable, backcolor, ;
      fontcolor, dynamicbackcolor, dynamicforecolor, aPicture, lRtl, ;
      nStyle, inplace, editcontrols, readonly, valid, validmessages, ;
      aWhenFields, lDisabled, lNoTabStop, lInvisible, lHasHeaders, ;
      aHeaderImage, aHeaderImageAlign, FullMove, aSelectedColors, ;
      aEditKeys, lCheckBoxes, lDblBffr, lFocusRect, lPLM, ;
      lFixedCols, lFixedWidths, lLikeExcel, lButtons, AllowDelete, ;
      DelMsg, lNoDelMsg, AllowAppend, lNoModal, lFixedCtrls, ;
      lClickOnCheckbox, lRClickOnCheckbox, lExtDbl, lSilent, lAltA, ;
      lNoShowAlways, lNone, lCBE, lAtFirst, klc ) CLASS TGrid

   LOCAL ControlHandle, aImageList, i

   ::SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor, .t., lRtl )

   ASSIGN ::aWidths  VALUE aWidths  TYPE "A"
   ASSIGN ::aHeaders VALUE aHeaders TYPE "A"

   IF Len( ::aHeaders ) != Len( ::aWidths )
      MsgOOHGError( "Grid: HEADERS/WIDTHS array size mismatch. Program terminated." )
   ENDIF
   IF HB_IsArray( aRows )
      IF AScan( aRows, { |a| ! HB_IsArray( a ) .OR. Len( a ) != Len( aHeaders ) } ) > 0
         MsgOOHGError( "Grid: ITEMS length mismatch. Program terminated." )
      ENDIF
   ELSE
      aRows := {}
   ENDIF

   ASSIGN ::nWidth  VALUE w TYPE "N"
   ASSIGN ::nHeight VALUE h TYPE "N"
   ASSIGN ::nRow    VALUE y TYPE "N"
   ASSIGN ::nCol    VALUE x TYPE "N"

   IF HB_IsArray( aHeadClick )
      ::aHeadClick := aHeadClick
      ASize( ::aHeadClick, Len( ::aHeaders ) )
   ELSE
      ::aHeadClick := Array( Len( ::aHeaders ) )
      IF HB_IsBlock( aHeadClick )
         AFill( ::aHeadClick, aHeadClick )
      ENDIF
   ENDIF

   IF HB_IsLogical( lFixedCols )
      ::AllowMoveColumn := ! lFixedCols
   ENDIF

   IF HB_IsLogical( lFixedWidths )
      ::AllowChangeSize := ! lFixedWidths
   ENDIF

   ASSIGN ::aJust             VALUE aJust             TYPE "A"
   ASSIGN ::Picture           VALUE aPicture          TYPE "A"
   ASSIGN ownerdata           VALUE ownerdata         TYPE "L" DEFAULT .F.
   ASSIGN ::lNoGrid           VALUE nogrid            TYPE "L"
   ASSIGN ::lCheckBoxes       VALUE lCheckBoxes       TYPE "L"
   ASSIGN ::lFocusRect        VALUE lFocusRect        TYPE "L"
   ASSIGN ::lPLM              VALUE lPLM              TYPE "L"
   ASSIGN ::lLikeExcel        VALUE lLikeExcel        TYPE "L"
   ASSIGN ::lButtons          VALUE lButtons          TYPE "L"
   ASSIGN ::AllowEdit         VALUE editable          TYPE "L"
   ASSIGN ::AllowDelete       VALUE AllowDelete       TYPE "L"
   ASSIGN ::AllowAppend       VALUE AllowAppend       TYPE "L"
   ASSIGN ::lNoDelMsg         VALUE lNoDelMsg         TYPE "L"
   ASSIGN ::DelMsg            VALUE DelMsg            TYPE "C"
   ASSIGN ::lNoModal          VALUE lNoModal          TYPE "L"
   ASSIGN ::ClickOnCheckbox   VALUE lClickOnCheckbox  TYPE "L"
   ASSIGN ::RClickOnCheckbox  VALUE lRClickOnCheckbox TYPE "L"
   ASSIGN ::lExtendDblClick   VALUE lExtDbl           TYPE "L"
   ASSIGN ::lSilent           VALUE lSilent           TYPE "L"
   ASSIGN ::lAppendOnAltA     VALUE lAltA             TYPE "L"
   ASSIGN ::lNoneUnsels       VALUE lNone             TYPE "L"
   ASSIGN ::lChangeBeforeEdit VALUE lCBE              TYPE "L"
   ASSIGN ::lAtFirstCol       VALUE lAtFirst          TYPE "L"
   ASSIGN ::lKeysLikeClipper  VALUE klc               TYPE "L"

   /*
   * This must be placed before calling ::Register because when the
   * control is an XBrowse, ::Register will call ::ColumnBlock and
   * this method needs ::EditControls
   */
   ::EditControls := editcontrols

   IF ::lCheckBoxes .AND. ::lPLM
      MsgOOHGError( "CHECKBOXES and PAINTLEFTMARGIN clauses can't be used simultaneously. Program terminated." )
   ENDIF

   nStyle := ::InitStyle( nStyle,, lInvisible, lNoTabStop, lDisabled ) + ;
      If( HB_IsLogical( lHasHeaders ) .AND. ! lHasHeaders, LVS_NOCOLUMNHEADER, 0 ) + ;
      If( HB_IsLogical( lNoShowAlways ) .AND. ! lNoShowAlways, LVS_SHOWSELALWAYS, 0 )

   IF ! HB_IsArray( ::aJust )
      ::aJust := AFill( Array( Len( ::aHeaders ) ), 0 )
   ELSE
      ASize( ::aJust, Len( ::aHeaders ) )
      AEval( ::aJust, { |x,i| ::aJust[ i ] := If( ! HB_IsNumeric( x ), 0, x ) } )
   ENDIF

   IF ! HB_IsArray( ::Picture )
      ::Picture := Array( Len( ::aHeaders ) )
   ELSE
      ASize( ::Picture, Len( ::aHeaders ) )
   ENDIF
   AEval( ::Picture, { |x,i| ::Picture[ i ] := If( ( ValType( x ) $ "CM" .AND. ! Empty( x ) ) .OR. HB_IsLogical( x ), x, Nil ) } )

   ::SetSplitBoxInfo( Break )
   ControlHandle := InitListView( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, '', 0, If( ::lNoGrid, 0, 1 ), ownerdata, itemcount, nStyle, ::lRtl, ::lCheckBoxes, OSisWinXPorLater() .AND. lDblBffr )

   IF HB_IsArray( aImage )
      // Can't use ::AddBitMap( aImage ) because control is not registered yet
      aImageList := ImageList_Init( aImage, ::ImageListColor, ::ImageListFlags )
      IF ValidHandler( aImageList[ 1 ] )
         SendMessage( ControlHandle, ::SetImageListCommand, ::SetImageListWParam, aImageList[ 1 ] )
         ::ImageList := aImageList[ 1 ]
         i := AScan( ::Picture, .T. )
         IF i == 0
            ::Picture[ 1 ] := .T.
            ::aWidths[ 1 ] := Max( ::aWidths[ 1 ], aImageList[ 2 ] + If( ::lCheckBoxes, GetStateListWidth( ControlHandle ) + 4, 4 ) ) // Ensure there's enough room for bitmap plus checkboxes
         ELSE
            ::aWidths[ i ] := Max( ::aWidths[ i ], aImageList[ 2 ] )  // Ensure there's enough room for bitmap
         ENDIF
      ENDIF
   ELSEIF ::lCheckBoxes
      ::aWidths[ 1 ] := Max( ::aWidths[ 1 ], GetStateListWidth( ControlHandle ) + 4 ) // Set Column 1 width to checkboxes width
   ENDIF

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
   ::aWhen := aWhenFields
   ASSIGN ::InPlace   VALUE inplace  TYPE "L"
   ASSIGN ::FullMove  VALUE FullMove TYPE "L"

   ASSIGN lFixedCtrls VALUE lFixedCtrls TYPE "L" DEFAULT _OOHG_GridFixedControls
   ::FixControls( lFixedCtrls )

   // Load images alignments
   // This should come before than 'Load header images'
   ::aHeaderImageAlign := AFill( Array( Len( ::aHeaders ) ), HEADER_IMG_AT_LEFT )

   IF HB_IsArray( aHeaderImageAlign )
      FOR i := 1 To Len( aHeaderImageAlign )
         IF HB_IsNumeric( aHeaderImageAlign[ i ] ) .AND. aHeaderImageAlign[ i ] == HEADER_IMG_AT_RIGHT
            ::aHeaderImageAlign[ i ] := HEADER_IMG_AT_RIGHT
         ENDIF
      NEXT i
   ENDIF

   // Load header images
   // This should come after 'Load images alignments'
   ::LoadHeaderImages( aHeaderImage )

   IF ValidHandler( ::HeaderImageList )
      // Associate the imagelist with the listview's header control
      SetHeaderImageList( ControlHandle, ::HeaderImageList )

      // Set images aligments
      FOR i := 1 To Len( ::aHeaders )
         ::HeaderImage( i, ::aHeaderImage[ i ] )
         ::HeaderImageAlign( i, ::aHeaderImageAlign[ i ] )
      NEXT i
   ENDIF

   // Load rows
   AEval( aRows, { |u| ::AddItem( u ) } )

   IF ! HB_IsArray( aSelectedColors )
      aSelectedColors := {}
   ENDIF
   ::SetSelectedColors( aSelectedColors, .F. )

   ::Value := value

   RETURN Self

METHOD Define4( change, dblclick, gotfocus, lostfocus, ondispinfo, editcell, ;
      onenter, oncheck, abortedit, click, bbeforecolmove, baftercolmove, ;
      bbeforecolsize, baftercolsize, bbeforeautofit, ondelete, ;
      bDelWhen, onappend, bheadrclick, onrclick, oninsert, editend, ;
      bbeforeditcell, bEditCellValue ) CLASS TGrid

   // Must be set after control is initialized
   ASSIGN ::OnChange         VALUE change         TYPE "B"
   ASSIGN ::OnDblClick       VALUE dblclick       TYPE "B"
   ASSIGN ::OnGotFocus       VALUE gotfocus       TYPE "B"
   ASSIGN ::OnLostFocus      VALUE lostfocus      TYPE "B"
   ASSIGN ::OnDispInfo       VALUE ondispinfo     TYPE "B"
   ASSIGN ::OnEditCell       VALUE editcell       TYPE "B"
   ASSIGN ::OnEnter          VALUE onenter        TYPE "B"
   ASSIGN ::OnCheckChange    VALUE oncheck        TYPE "B"
   ASSIGN ::OnAbortEdit      VALUE abortedit      TYPE "B"
   ASSIGN ::OnClick          VALUE click          TYPE "B"
   ASSIGN ::bBeforeColMove   VALUE bbeforecolmove TYPE "B"
   ASSIGN ::bAfterColMove    VALUE baftercolmove  TYPE "B"
   ASSIGN ::bBeforeColSize   VALUE bbeforecolsize TYPE "B"
   ASSIGN ::bAfterColSize    VALUE baftercolsize  TYPE "B"
   ASSIGN ::bBeforeAutofit   VALUE bbeforeautofit TYPE "B"
   ASSIGN ::OnDelete         VALUE ondelete       TYPE "B"
   ASSIGN ::bDelWhen         VALUE bdelwhen       TYPE "B"
   ASSIGN ::OnAppend         VALUE onappend       TYPE "B"
   ASSIGN ::bHeadRClick      VALUE bheadrclick    TYPE "B"
   ASSIGN ::OnRClick         VALUE onrclick       TYPE "B"
   ASSIGN ::OnInsert         VALUE oninsert       TYPE "B"
   ASSIGN ::OnEditCellEnd    VALUE editend        TYPE "B"
   ASSIGN ::OnBeforeEditCell VALUE bbeforeditcell TYPE "B"
   ASSIGN ::bEditCellValue   VALUE bEditCellValue TYPE "B"

   RETURN Self

METHOD AddBitMap( uImage ) CLASS TGrid

   LOCAL aImageList, nPos, nCount, i

   IF ValidHandler( ::ImageList )
      nCount := ImageList_GetImageCount( ::ImageList )
      IF HB_IsArray( uImage )
         nPos := ImageList_Add( ::ImageList, uImage[ 1 ], ::ImageListFlags, ::ImageListColor )
         AEval( uImage, { |c| ImageList_Add( ::ImageList, c, ::ImageListFlags, ::ImageListColor ) }, 2 )
      ELSE
         nPos := ImageList_Add( ::ImageList, uImage, ::ImageListFlags, ::ImageListColor )
      ENDIF
      IF nCount == ImageList_GetImageCount( ::ImageList )
         nPos := 0
      ENDIF
      SendMessage( ::hWnd, ::SetImageListCommand, ::SetImageListWParam, ::ImageList )
   ELSE
      IF HB_IsArray( uImage )
         aImageList := ImageList_Init( uImage, ::ImageListColor, ::ImageListFlags )
      ELSE
         aImageList := ImageList_Init( { uImage }, ::ImageListColor, ::ImageListFlags )
      ENDIF
      IF ValidHandler( aImageList[ 1 ] )
         ::ImageList := aImageList[ 1 ]
         nPos := 1
         SendMessage( ::hWnd, ::SetImageListCommand, ::SetImageListWParam, aImageList[ 1 ] )
         i := AScan( ::Picture, .T. )
         IF i == 0
            ::Picture[ 1 ] := .T.
            ::aWidths[ 1 ] := Max( ::ColumnWidth( 1 ), aImageList[ 2 ] + If( ::lCheckBoxes, GetStateListWidth( ::hWnd ) + 4, 4 ) ) // Ensure there's enough room for bitmap plus checkboxes
         ELSE
            ::aWidths[ i ] := Max( ::ColumnWidth( i ), aImageList[ 2 ] )  // Ensure there's enough room for bitmap
         ENDIF
      ELSE
         nPos := 0
      ENDIF
   ENDIF

   RETURN nPos

METHOD FirstVisibleItem CLASS TGrid

   LOCAL nRet

   IF ::ItemCount > 0
      nRet := ListView_GetTopIndex( ::hWnd )
      IF nRet < 1 .OR. nRet > ::ItemCount
         nRet := 0
      ENDIF
   ELSE
      nRet := 0
   ENDIF

   RETURN nRet

METHOD FirstVisibleColumn( lStart ) CLASS TGrid

   LOCAL aColumnOrder, nLen, i, r, nRet := 0, lEmpty := .F., nClientWidth, nScrollWidth

   ASSIGN lStart VALUE lStart TYPE "L" DEFAULT .F.

   IF ::ItemCount < 1
      lEmpty := .T.
      InsertListViewItem( ::hWnd, Array( Len( ::aHeaders ) ), 1 )
   ENDIF

   IF lStart
      // We are looking for the leftmost column whose left side is visible.
      // To check we need the width of the grid's client area minus the width of the scrollbar if one is present.
      r := { 0, 0, 0, 0 }                                        // left, top, right, bottom
      GetClientRect( ::hWnd, r )
      nClientWidth := r[ 3 ] - r[ 1 ]
      IF ::lScrollBarUsesClientArea .AND. ::ItemCount > ::CountPerPage
         nScrollWidth := GetVScrollBarWidth()
      ELSE
         nScrollWidth := 0
      ENDIF
   ENDIF

   aColumnOrder := ::ColumnOrder
   nLen := Len( aColumnOrder )
   i := 1
   DO WHILE i <= nLen
      IF AScan( ::aHiddenCols, aColumnOrder[ i ] ) == 0
         // get the column's rect
         r := ListView_GetSubitemRect( ::hWnd, 0, aColumnOrder[ i ] - 1 )     // top, left, width, height
         IF lStart
            // check if the left side is inside the client area
            IF r[ 2 ] >= 0 .AND. r[ 2 ] < nClientWidth - nScrollWidth
               nRet := aColumnOrder[ i ]
               EXIT
            ENDIF
         ELSE
            // We are looking for the leftmost column
            IF r[ 2 ] + r[ 3 ] - 1 >= 0
               nRet := aColumnOrder[ i ]
               EXIT
            ENDIF
         ENDIF
      ENDIF
      i ++
   ENDDO

   IF lEmpty
      ListViewDeleteString( ::hWnd, 1 )
   ENDIF

   RETURN nRet

METHOD LastVisibleColumn( lEnd ) CLASS TGrid

   LOCAL aColumnOrder, nLen, i, r, nRet := 0, lEmpty := .F., nClientWidth, nScrollWidth

   ASSIGN lEnd VALUE lEnd TYPE "L" DEFAULT .F.

   IF ::ItemCount < 1
      lEmpty := .T.
      InsertListViewItem( ::hWnd, Array( Len( ::aHeaders ) ), 1 )
   ENDIF

   // To check we need the width of the grid's client area minus the width of the scrollbar if one is present.
   r := { 0, 0, 0, 0 }                                        // left, top, right, bottom
   GetClientRect( ::hWnd, r )
   nClientWidth := r[ 3 ] - r[ 1 ]
   IF ::lScrollBarUsesClientArea .AND. ::ItemCount >  ::CountPerPage
      nScrollWidth := GetVScrollBarWidth()
   ELSE
      nScrollWidth := 0
   ENDIF

   aColumnOrder := ::ColumnOrder
   nLen := Len( aColumnOrder )
   i := nLen
   DO WHILE i >= 1
      IF AScan( ::aHiddenCols, aColumnOrder[ i ] ) == 0
         // get the column's rect
         r := ListView_GetSubitemRect( ::hWnd, 0, aColumnOrder[ i ] - 1 )     // top, left, width, height
         IF lEnd
            // check if the right side is inside the client area
            IF r[ 2 ] + r[ 3 ] >= 0 .AND. r[ 2 ] + r[ 3 ] <= nClientWidth - nScrollWidth
               nRet := aColumnOrder[ i ]
               EXIT
            ENDIF
         ELSE
            // We are looking for the rightmost column
            IF r[ 2 ] <= nClientWidth - nScrollWidth
               nRet := aColumnOrder[ i ]
               EXIT
            ENDIF
         ENDIF
      ENDIF
      i --
   ENDDO

   IF lEmpty
      ListViewDeleteString( ::hWnd, 1 )
   ENDIF

   RETURN nRet

METHOD FixControls( lFix ) CLASS TGrid

   LOCAL i

   IF HB_IsLogical( lFix )
      IF lFix
         ::aEditControls := Array( Len( ::aHeaders ) )
         FOR i := 1 To Len( ::aHeaders )
            ::aEditControls[ i ] := GetEditControlFromArray( Nil, ::EditControls, i, Self )
         NEXT i
         ::lFixedControls := .T.
      ELSE
         ::lFixedControls := .F.
      ENDIF
   ENDIF

   RETURN ::lFixedControls

METHOD Append( lAppend ) CLASS TGrid

   IF HB_IsLogical( lAppend )
      ::AllowAppend := lAppend
   ENDIF

   RETURN ::AllowAppend

METHOD CheckItem( nItem, lChecked ) CLASS TGrid

   LOCAL lRet, lOld

   IF ::lCheckBoxes .AND. HB_IsNumeric( nItem )
      lOld := ListView_GetCheckState( ::hwnd, nItem )

      IF HB_IsLogical( lChecked ) .AND. lChecked # lOld
         ListView_SetCheckState( ::hwnd, nItem, lChecked )

         lRet := ListView_GetCheckState( ::hwnd, nItem )

         IF lRet # lOld
            ::DoEvent( ::OnCheckChange, "CHECKCHANGE", { nItem } )
         ENDIF
      ELSE
         lRet := lOld
      ENDIF
   ELSE
      lRet := .F.
   ENDIF

   RETURN lRet

METHOD SetSelectedColors( aSelectedColors, lRedraw ) CLASS TGrid

   LOCAL i, aColors[ 4 ]

   IF HB_IsArray( aSelectedColors )
      aSelectedColors := AClone( aSelectedColors )
      ASize( aSelectedColors, 4 )

      // For text of selected row when grid has the focus
      IF ! ValType( aSelectedColors[ 1 ] ) $ "ANB"
         aSelectedColors[ 1 ] := GetSysColor( COLOR_HIGHLIGHTTEXT )
      ENDIF
      // For background of selected row when grid has the focus
      IF ! ValType( aSelectedColors[ 2 ] ) $ "ANB"
         aSelectedColors[ 2 ] := GetSysColor( COLOR_HIGHLIGHT )
      ENDIF
      // For text of selected row when grid doesn't has the focus
      IF ! ValType( aSelectedColors[ 3 ] ) $ "ANB"
         aSelectedColors[ 3 ] := GetSysColor( COLOR_WINDOWTEXT )
      ENDIF
      // For background of selected row when doesn't has the focus
      IF ! ValType( aSelectedColors[ 4 ] ) $ "ANB"
         aSelectedColors[ 4 ] := GetSysColor( COLOR_3DFACE )
      ENDIF

      ::aSelectedColors := aSelectedColors

      FOR i := 1 To 4
         aColors[ i ] := _OOHG_GetArrayItem( aSelectedColors, i )
      NEXT i

      ::GridSelectedColors := aColors

      IF lRedraw
         RedrawWindow( ::hWnd )
      ENDIF
   ELSE
      aSelectedColors := AClone( ::aSelectedColors )
   ENDIF

   RETURN aSelectedColors

METHOD LoadHeaderImages( aNewHeaderImage ) CLASS TGrid

   LOCAL i, nPos, nCount, aImageList, nImagesWidth, aHeaderImage, aImageName := {}

   // Clone the array in case aNewHeaderImage is the same as ::aHeaderImage
   IF HB_IsArray( aNewHeaderImage )
      aHeaderImage := AClone( aNewHeaderImage )
   ELSE
      aHeaderImage := Nil
   ENDIF

   // Destroy previous imagelist
   IF ValidHandler( ::HeaderImageList )
      ImageList_Destroy( ::HeaderImageList )
   ENDIF
   ::HeaderImageList := 0

   // Load images into imagelist
   ::aHeaderImage := AFill( Array( Len( ::aHeaders ) ), 0 )

   IF HB_IsArray( aHeaderImage )
      FOR i := 1 To Len( aHeaderImage )
         IF ValType( aHeaderImage[ i ] ) $ "CM" .AND. ! Empty( aHeaderImage[ i ] )
            IF ValidHandler( ::HeaderImageList )
               nPos := AScan( aImageName, aHeaderImage[ i ] )
               IF nPos > 0                                                 // Image already loaded, reuse it
                  ::aHeaderImage[ i ] := nPos
               ELSE
                  nCount := ImageList_GetImageCount( ::HeaderImageList )
                  nPos := ImageList_Add( ::HeaderImageList, aHeaderImage[ i ], ::ImageListFlags, ::ImageListColor )
                  IF ImageList_GetImageCount( ::HeaderImageList ) == nCount
                     nPos := 0
                  ENDIF

                  IF nPos == 0                       // Image not added
                     aHeaderImage[ i ] := Nil
                  ELSE
                     AAdd( aImageName, aHeaderImage[ i ] )
                     ::aHeaderImage[ i ] := nPos
                     ::ColumnWidth( i, Max( ::ColumnWidth( i ), nImagesWidth ) )
                  ENDIF
               ENDIF
            ELSE
               aImageList := ImageList_Init( { aHeaderImage[ i ] }, ::ImageListColor, ::ImageListFlags )

               IF ValidHandler( aImageList[ 1 ] )
                  ::HeaderImageList := aImageList[ 1 ]
                  AAdd( aImageName, aHeaderImage[ i ] )
                  ::aHeaderImage[ i ] := 1
                  nImagesWidth := aImageList[ 2 ] + 4
                  IF i == 1
                     ::ColumnWidth( i, Max( ::ColumnWidth( i ), nImagesWidth + If( ::lCheckBoxes, GetStateListWidth( ::hWnd ), 0 ) ) )
                  ELSE
                     ::ColumnWidth( i, Max( ::ColumnWidth( i ), nImagesWidth ) )
                  ENDIF
               ELSE
                  aHeaderImage[ i ] := Nil
               ENDIF
            ENDIF
         ELSE
            aHeaderImage[ i ] := Nil                 // Header has no image
         ENDIF
      NEXT i
   ENDIF

   IF ValidHandler( ::HeaderImageList )
      // Associate the imagelist with the header control of the listview
      SetHeaderImageList( ::hWnd, ::HeaderImageList )

      // Set images aligments
      FOR i := 1 To Len( ::aHeaders )
         ::HeaderImage( i, ::aHeaderImage[ i ] )
         ::HeaderImageAlign( i, ::aHeaderImageAlign[ i ] )
      NEXT i
   ELSE
      // Deassociate the imagelist
      SetHeaderImageList( ::hWnd, 0 )
   ENDIF

   RETURN Self

METHOD OnEnter( bEnter ) CLASS TGrid

   LOCAL bRet

   IF HB_IsBlock( bEnter )
      IF _OOHG_SameEnterDblClick
         ::OnDblClick := bEnter
      ELSE
         ::bOnEnter := bEnter
      ENDIF
      bRet := bEnter
   ELSE
      bRet := If( _OOHG_SameEnterDblClick, ::OnDblClick, ::bOnEnter )
   ENDIF

   RETURN bRet

METHOD AppendItem( lAppend ) CLASS TGrid

   LOCAL lRet := .F.

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   IF ( ::AllowAppend .OR. lAppend ).AND. ! ::lNestedEdit
      ::lNestedEdit := .T.
      ::cText := ""
      IF ::FirstVisibleColumn # 0
         ::lAppendMode := .T.
         ::InsertBlank( ::ItemCount + 1 )
         ::SetControlValue( ::ItemCount )
         IF ::FullMove
            lRet := ::EditGrid()
         ELSEIF ::InPlace
            lRet := ::EditAllCells()
         ELSE
            lRet := ::EditItem()
         ENDIF
         ::lAppendMode := .F.
      ENDIF
      ::lNestedEdit := .F.
   ENDIF

   RETURN lRet

METHOD EditGrid( nRow, nCol, lAppend, lOneRow, lChange ) CLASS TGrid

   LOCAL lRet, lSomethingEdited, nNextCol

   IF ::FirstVisibleColumn == 0

      RETURN .F.
   ENDIF

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.

   IF ! HB_IsNumeric( nCol )
      IF ::lAppendMode .OR. lAppend .OR. ::lAtFirstCol
         nCol := ::FirstColInOrder
      ELSE
         nCol := ::FirstVisibleColumn
      ENDIF
   ENDIF
   IF nCol < 1 .OR. nCol > Len( ::aHeaders )

      RETURN .F.
   ENDIF

   IF ::lAppendMode
      // Before calling ::EditGrid an empty item was added at ::ItemCount
      nRow := ::ItemCount
   ELSEIF lAppend
      // Add new item, ignore ::AllowAppend
      ::lAppendMode := .T.
      ::InsertBlank( ::ItemCount + 1 )
      ::SetControlValue( ::ItemCount )
      nRow := ::ItemCount
   ELSE
      // Edit item nRow
      IF ! HB_IsNumeric( nRow )
         nRow := Max( ::FirstSelectedItem, 1 )
      ENDIF
      IF nRow < 1 .OR. nRow > ::ItemCount

         RETURN .F.
      ENDIF
      ASSIGN lChange VALUE lChange TYPE "L" DEFAULT ::lChangeBeforeEdit
      IF lChange
         ::SetControlValue( nRow )
      ENDIF
   ENDIF

   ::nRowPos := nRow
   ::nColPos := nCol

   lSomethingEdited := .F.

   DO WHILE ::nColPos >= 1 .AND. ::nColPos <= Len( ::aHeaders )
      _OOHG_ThisItemCellValue := ::Cell( ::nRowPos, ::nColPos )

      IF ::IsColumnReadOnly( ::nColPos, ::nRowPos )
         // Read only column
      ELSEIF ! ::IsColumnWhen( ::nColPos, ::nRowPos )
         // WHEN returned .F.
      ELSEIF AScan( ::aHiddenCols, ::nColPos ) > 0
         // Hidden column
      ELSE
         ::lEditMode := ::FullMove
         ::lCalledFromClass := .T.
         lRet := ::EditCell( ::nRowPos, ::nColPos, , , , , , .F. )
         ::lCalledFromClass := .F.
         ::lEditMode := .F.

         IF ::lAppendMode
            ::lAppendMode := .F.
            IF lRet
               ::DoEvent( ::OnAppend, "APPEND", { ::nRowPos } )
               lSomethingEdited := .T.
            ELSE
               EXIT
            ENDIF
         ELSEIF lRet
            lSomethingEdited := .T.
         ELSE
            EXIT
         ENDIF

         IF ::bPosition == 9                     // MOUSE EXIT
            // Edition window lost focus, resume clic processing and process delayed click
            ::bPosition := 0
            IF ::nDelayedClick[ 1 ] > 0
               // A click message was delayed
               IF ::nDelayedClick[ 3 ] <= 0
                  ::SetControlValue( ::nDelayedClick[ 1 ] )
               ENDIF

               IF HB_IsNil( ::nDelayedClick[ 4 ] )
                  IF HB_IsBlock( ::OnClick )
                     IF ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                        IF ! ::NestedClick
                           ::NestedClick := ! _OOHG_NestedSameEvent()
                           ::DoEventMouseCoords( ::OnClick, "CLICK" )
                           ::NestedClick := .F.
                        ENDIF
                     ENDIF
                  ENDIF
               ELSE
                  IF HB_IsBlock( ::OnRClick )
                     IF ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                        ::DoEventMouseCoords( ::OnRClick, "RCLICK" )
                     ENDIF
                  ENDIF
               ENDIF

               IF ::nDelayedClick[ 3 ] > 0
                  // change check mark
                  ::CheckItem( ::nDelayedClick[ 3 ], ! ::CheckItem( ::nDelayedClick[ 3 ] ) )
               ENDIF

               // fire context menu
               IF ! HB_IsNil( ::nDelayedClick[ 4 ] ) .AND. ::ContextMenu != Nil .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0 )
                  ::ContextMenu:Cargo := ::nDelayedClick[ 4 ]
                  ::ContextMenu:Activate()
               ENDIF
            ENDIF
            EXIT
         ENDIF
      ENDIF

      /*
      * ::OnEditCell may change ::nRowPos and/or ::nColPos using ::Up(), ::PageUp(), ::Home(),
      * ::End(), ::Down(), ::PageDown(), ::GoTop(), ::GoBottom(), ::Left() and/or ::Right()
      */

      IF ::nColPos == 0
         nNextCol := ::FirstColInOrder
      ELSE
         nNextCol := ::NextColInOrder( ::nColPos )
      ENDIF

      IF nNextCol > 0
         ::nColPos := nNextCol
      ELSEIF HB_IsLogical( lOneRow ) .AND. lOneRow
         EXIT
      ELSEIF ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove
         EXIT
      ELSEIF ::nRowPos < ::ItemCount
         ::nColPos := ::FirstColInOrder
         IF ::nColPos == 0
            EXIT
         ENDIF
         ::nRowPos ++
         ::SetControlValue( ::nRowPos )
         ::ScrollToLeft()
      ELSEIF lAppend .OR. ::AllowAppend
         ::nColPos := ::FirstColInOrder
         IF ::nColPos == 0
            EXIT
         ENDIF
         ::lAppendMode := .T.
         ::InsertBlank( ::ItemCount + 1 )
         ::nRowPos := ::ItemCount
         ::SetControlValue( ::nRowPos )
         ::ScrollToLeft()
      ELSE
         EXIT
      ENDIF
   ENDDO

   ::ScrollToLeft()

   RETURN lSomethingEdited

METHOD Right() CLASS TGrid

   LOCAL nNextCol

   IF ::lEditMode
      nNextCol := ::NextColInOrder( ::nColPos )
      IF nNextCol # 0
         ::nColPos := nNextCol
      ENDIF
   ENDIF

   RETURN Self

METHOD Left() CLASS TGrid

   IF ::lEditMode
      IF ::nColPos # ::FirstColInOrder
         ::nColPos := ::PriorColInOrder( ::PriorColInOrder( ::nColPos ) )
      ENDIF
   ENDIF

   RETURN Self

METHOD Down( lAppend ) CLASS TGrid

   IF ::lEditMode
      IF ::nRowPos < ::ItemCount
         ::nRowPos ++
      ENDIF
   ELSE
      IF ::FirstSelectedItem < ::ItemCount
         ::SetControlValue( ::FirstSelectedItem + 1 )
      ELSE
         ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT ::AllowAppend
         IF lAppend
            ::AppendItem()
         ENDIF
      ENDIF
   ENDIF

   RETURN Self

METHOD Up() CLASS TGrid

   IF ::lEditMode
      IF ::nRowPos > 1
         ::nRowPos --
      ENDIF
   ELSE
      IF ::FirstSelectedItem > 1
         ::SetControlValue( ::FirstSelectedItem - 1 )
      ENDIF
   ENDIF

   RETURN Self

METHOD PageUp() CLASS TGrid

   IF ::lEditMode
      IF ::nRowPos > ::CountPerPage
         ::nRowPos -= ::CountPerPage
      ELSE
         ::nRowPos := 1
      ENDIF
   ELSE
      IF ::FirstSelectedItem > ::CountPerPage
         ::SetControlValue( ::FirstSelectedItem - ::CountPerPage )
      ELSE
         ::GoTop()
      ENDIF
   ENDIF

   RETURN Self

METHOD PageDown() CLASS TGrid

   IF ::lEditMode
      IF ::nRowPos < ::ItemCount - ::CountPerPage
         ::nRowPos += ::CountPerPage
      ELSE
         ::nRowPos := ::ItemCount
      ENDIF
   ELSE
      IF ::FirstSelectedItem < ::ItemCount - ::CountPerPage
         ::SetControlValue( ::FirstSelectedItem + ::CountPerPage )
      ELSE
         ::GoBottom()
      ENDIF
   ENDIF

   RETURN Self

METHOD GoTop() CLASS TGrid

   IF ::lEditMode
      ::nRowPos := 1
   ELSE
      IF ::ItemCount > 0
         ::SetControlValue( 1 )
      ENDIF
   ENDIF

   RETURN Self

METHOD GoBottom() CLASS TGrid

   IF ::lEditMode
      ::nRowPos := ::ItemCount
   ELSE
      IF ::ItemCount > 0
         ::SetControlValue( ::ItemCount )
      ENDIF
   ENDIF

   RETURN Self

METHOD ToExcel( cTitle, nItemFrom, nItemTo, nColFrom, nColTo ) CLASS TGrid

   LOCAL oExcel, oSheet, nLin, i, j, uValue, aColumnOrder

   IF ! ValType( cTitle ) $ "CM"
      cTitle := ""
   ENDIF
   IF ! ValType( nItemFrom ) == "N" .OR. nItemFrom < 1 .OR. nItemFrom > ::ItemCount
      nItemFrom := Max( ::FirstSelectedItem, 1 )
   ENDIF
   IF ! ValType( nItemTo ) == "N" .OR. nItemTo < 1 .OR. nItemTo > ::ItemCount .OR. nItemTo < nItemFrom
      nItemTo := ::ItemCount
   ENDIF
   IF ! ValType( nColFrom ) == "N" .OR. nColFrom < 1 .OR. nColFrom > Len( ::aHeaders )
      // nColFrom is an index in ::ColumnOrder
      nColFrom := 1
   ENDIF
   IF ! ValType( nColTo ) == "N" .OR. nColTo < 1 .OR. nColTo > Len( ::aHeaders ) .OR. nColTo < nColFrom
      // nColTo is an index in ::ColumnOrder
      nColTo := Len( ::aHeaders )
   ENDIF

   #ifndef __XHARBOUR__
   IF ( oExcel := win_oleCreateObject( "Excel.Application" ) ) == Nil
      MsgStop( "Error: MS Excel not available. [" + win_oleErrorText()+ "]" )

      RETURN Self
   ENDIF
   #else
   oExcel := TOleAuto():New( "Excel.Application" )
   IF Ole2TxtError() != "S_OK"
      MsgStop( "Excel not found", "Error" )

      RETURN Self
   ENDIF
   #endif

   oExcel:WorkBooks:Add()
   oSheet := oExcel:ActiveSheet()
   oSheet:Cells:Font:Name := "Arial"
   oSheet:Cells:Font:Size := 10

   aColumnOrder := ::ColumnOrder
   nLin := 4

   FOR i := nColFrom To nColTo
      oSheet:Cells( nLin, i - nColFrom + 1 ):Value := ::aHeaders[ aColumnOrder[ i ] ]
      oSheet:Cells( nLin, i - nColFrom + 1 ):Font:Bold := .T.
   NEXT i
   nLin += 2

   FOR j := nItemFrom To nItemTo
      FOR i := nColFrom To nColTo
         uValue := ::Cell( j, aColumnOrder[ i ] )
         IF ! HB_IsDate( uValue ) .OR. ! Empty( uValue )
            oSheet:Cells( nLin, i - nColFrom + 1 ):Value := uValue
         ENDIF
      NEXT i
      nLin ++
   NEXT j

   FOR i := nColFrom To nColTo
      oSheet:Columns( i - nColFrom + 1 ):AutoFit()
   NEXT i

   oSheet:Cells( 1, 1 ):Value := cTitle
   oSheet:Cells( 1, 1 ):Font:Bold := .T.

   oSheet:Cells( 1, 1 ):Select()
   oExcel:Visible := .T.
   oSheet := Nil
   oExcel := Nil

   RETURN Self

METHOD ToOpenOffice( cTitle, nItemFrom, nItemTo, nColFrom, nColTo ) CLASS TGrid

   LOCAL oSerMan, oDesk, oPropVals, oBook, oSheet, nLin, i, j, uValue, aColumnOrder

   IF ! ValType( cTitle ) $ "CM"
      cTitle := ""
   ENDIF
   IF ! ValType( nItemFrom ) == "N" .OR. nItemFrom < 1 .OR. nItemFrom > ::ItemCount
      nItemFrom := Max( ::FirstSelectedItem, 1 )
   ENDIF
   IF ! ValType( nItemTo ) == "N" .OR. nItemTo < 1 .OR. nItemTo > ::ItemCount .OR. nItemTo < nItemFrom
      nItemTo := ::ItemCount
   ENDIF
   IF ! ValType( nColFrom ) == "N" .OR. nColFrom < 1 .OR. nColFrom > Len( ::aHeaders )
      // nColFrom is an index in ::ColumnOrder
      nColFrom := 1
   ENDIF
   IF ! ValType( nColTo ) == "N" .OR. nColTo < 1 .OR. nColTo > Len( ::aHeaders ) .OR. nColTo < nColFrom
      // nColTo is an index in ::ColumnOrder
      nColTo := Len( ::aHeaders )
   ENDIF

   // open service manager
   #ifndef __XHARBOUR__
   IF ( oSerMan := win_oleCreateObject( "com.sun.star.ServiceManager" ) ) == Nil
      MsgStop( "Error: OpenOffice not available. [" + win_oleErrorText()+ "]" )

      RETURN Self
   ENDIF
   #else
   oSerMan := TOleAuto():New( "com.sun.star.ServiceManager" )
   IF Ole2TxtError() != "S_OK"
      MsgStop( "OpenOffice not found", "Error" )

      RETURN Self
   ENDIF
   #endif

   // open desktop service
   IF ( oDesk := oSerMan:CreateInstance( "com.sun.star.frame.Desktop" ) ) == Nil
      MsgStop( "Error: OpenOffice Desktop not available." )

      RETURN Self
   ENDIF

   // set properties for new book
   oPropVals := oSerMan:Bridge_GetStruct( "com.sun.star.beans.PropertyValue" )
   oPropVals:Name := "Hidden"
   oPropVals:Value := .T.

   // open new book
   IF ( oBook := oDesk:LoadComponentFromURL( "private:factory/scalc", "_blank", 0, {oPropVals} ) ) == Nil
      MsgStop( "Error: OpenOffice Calc not available." )
      oDesk := Nil

      RETURN Self
   ENDIF

   // keep only one sheet
   DO WHILE oBook:Sheets:GetCount() > 1
      oSheet := oBook:Sheets:GetByIndex( oBook:Sheets:GetCount() - 1 )
      oBook:Sheets:RemoveByName( oSheet:Name )
   ENDDO

   // select first sheet
   oSheet := oBook:Sheets:GetByIndex( 0 )
   oBook:GetCurrentController:SetActiveSheet( oSheet )

   // set font name and size of all cells
   oSheet:CharFontName := "Arial"
   oSheet:CharHeight := 10

   aColumnOrder := ::ColumnOrder
   nLin := 4

   // put headers using bold style
   FOR i := nColFrom To nColTo
      oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetString( ::aHeaders[ aColumnOrder[ i ] ] )
      oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetPropertyValue( "CharWeight", 150 )
   NEXT i
   nLin += 2

   // put rows
   FOR j := nItemFrom To nItemTo
      FOR i := nColFrom To nColTo
         uValue := ::Cell( j, aColumnOrder[ i ] )
         DO CASE
         CASE uValue == Nil
         CASE ValType( uValue ) == "C"
            IF Left( uValue, 1 ) == "'"
               uValue := "'" + uValue
            ENDIF
            oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetString( uValue )
         CASE ValType( uValue ) == "N"
            oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetValue( uValue )
         CASE ValType( uValue ) == "L"
            oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetValue( uValue )
            oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetPropertyValue("NumberFormat", 99 )
         CASE ValType( uValue ) == "D"
            oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetValue( uValue )
            oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetPropertyValue( "NumberFormat", 36 )
         CASE ValType( uValue ) == "T"
            oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetString( uValue )
         OTHERWISE
            oSheet:GetCellByPosition( i - nColFrom, nLin - 1 ):SetFormula( uValue )
         ENDCASE
      NEXT i
      nLin ++
   NEXT j

   // autofit columns
   FOR i := nColFrom To nColTo
      oSheet:GetColumns:GetByIndex( i - nColFrom ):SetPropertyValue( "OptimalWidth", .T. )
   NEXT i

   // put title using bold style
   oSheet:GetCellByPosition( 0, 0 ):SetString( cTitle )
   oSheet:GetCellByPosition( 0, 0 ):SetPropertyValue( "CharWeight", 150 )

   // show
   oSheet:GetCellRangeByName( "A1:A1" )
   oSheet:IsVisible := .T.
   oBook:GetCurrentController():GetFrame():GetContainerWindow():SetVisible( .T. )
   oBook:GetCurrentController():GetFrame():GetContainerWindow():ToFront()

   // cleanup
   oSheet    := Nil
   oBook     := Nil
   oPropVals := Nil
   oDesk     := Nil
   oSerMan   := Nil

   RETURN Self

METHOD EditItem( nItem, lAppend, lOneRow, lChange ) CLASS TGrid

   LOCAL aItems, lSomethingEdited := .F.

   IF ::FirstVisibleColumn == 0

      RETURN .F.
   ENDIF

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.

   IF ::lAppendMode
      // Before calling ::EditItem an empty item was added at ::ItemCount
      nItem := ::ItemCount
      lChange := .T.
   ELSEIF lAppend
      // Add new item, ignore ::AllowAppend
      ::lAppendMode := .T.
      ::InsertBlank( ::ItemCount + 1 )
      nItem := ::ItemCount
      ASSIGN lChange VALUE lChange TYPE "L" DEFAULT ::lChangeBeforeEdit
      IF lChange
         ::SetControlValue( nItem )
      ENDIF
   ELSE
      // Edit item nItem
      IF ! HB_IsNumeric( nItem )
         nItem := Max( ::FirstSelectedItem, 1 )
      ENDIF
      IF nItem < 1 .OR. nItem > ::ItemCount

         RETURN .F.
      ENDIF
      ASSIGN lChange VALUE lChange TYPE "L" DEFAULT ::lChangeBeforeEdit
      IF lChange
         ::SetControlValue( nItem )
      ENDIF
   ENDIF

   ASSIGN lOneRow VALUE lOneRow TYPE "L" DEFAULT .T.

   DO WHILE .T.
      aItems := ::Item( nItem )

      aItems := ::EditItem2( nItem, aItems, , , If( ValType( ::cRowEditTitle ) $ "CM", ::cRowEditTitle, _OOHG_Messages( 1, 5 ) ) )

      IF Empty( aItems )
         ::DoEvent( ::OnAbortEdit, "ABORTEDIT", { nItem, 0 } )
         IF ::lAppendMode
            ::DeleteItem( ::ItemCount )
            IF lChange
               ::SetControlValue( ::ItemCount )
            ENDIF
         ENDIF
         EXIT
      ENDIF

      lSomethingEdited := .T.
      ::Item( nItem, ASize( aItems, Len( ::aHeaders ) ) )

      _SetThisCellInfo( ::hWnd, nItem, 1, Nil )
      ::DoEvent( ::OnEditCellEnd, "EDITCELLEND", { nItem, 0 } )
      _ClearThisCellInfo()

      IF ::lAppendMode
         _SetThisCellInfo( ::hWnd, nItem, 1, Nil )
         ::DoEvent( ::OnAppend, "APPEND", { nItem } )
         _ClearThisCellInfo()
      ENDIF

      _SetThisCellInfo( ::hWnd, nItem, 1, Nil )
      ::DoEvent( ::OnEditCell, "EDITCELL", { nItem, 0 } )
      _ClearThisCellInfo()

      IF lOneRow
         EXIT
      ELSEIF nItem < ::ItemCount
         nItem ++
         IF lChange
            ::SetControlValue( nItem )
         ENDIF
      ELSEIF lAppend .OR. ::AllowAppend
         ::lAppendMode := .T.
         ::InsertBlank( ::ItemCount + 1 )
         nItem := ::ItemCount
         IF lChange
            ::SetControlValue( nItem )
         ENDIF
      ELSE
         EXIT
      ENDIF
   ENDDO

   ::ScrollToLeft()

   RETURN lSomethingEdited

METHOD EditItem2( nItem, aItems, aEditControls, aMemVars, cTitle ) CLASS TGrid

   LOCAL l, actpos := {0,0,0,0}, GCol, iRow, i, oWnd, nWidth, nMaxHigh, oMain
   LOCAL EditControl, aEditControls2, nRow, lSplitWindow, nControlsMaxHeight
   LOCAL aReturn, lHidden

   IF ::FirstVisibleColumn == 0

      RETURN {}
   ENDIF
   IF ! HB_IsNumeric( nItem )
      nItem := Max( ::FirstSelectedItem, 1 )
   ENDIF
   IF nItem < 1 .OR. nItem > ::ItemCount

      RETURN {}
   ENDIF
   IF ::lNested

      RETURN {}
   ENDIF
   ::lNested := .T.

   IF ! HB_IsArray( aItems ) .OR. Len( aItems ) == 0
      aItems := ::Item( nItem )
   ENDIF
   aItems := AClone( aItems )
   IF Len( aItems ) > Len( ::aHeaders )
      ASize( aItems, Len( ::aHeaders ) )
   ENDIF

   l := Len( aItems )

   iRow := ListViewGetItemRow( ::hWnd, nItem )

   GetWindowRect( ::hWnd, actpos )

   _SetThisCellInfo( ::hWnd, nItem, 1 )

   nControlsMaxHeight := GetDesktopHeight() - 130

   nWidth := 140
   nRow := 0
   aEditControls2 := Array( l )
   FOR i := 1 To l
      IF ::FixControls()
         EditControl := ::aEditControls[ i ]
      ELSE
         EditControl := Nil
      ENDIF
      EditControl := GetEditControlFromArray( EditControl, aEditControls, i, Self )
      EditControl := GetEditControlFromArray( EditControl, ::EditControls, i, Self )
      IF ! HB_IsObject( EditControl )
         IF ValType( ::Picture[ i ] ) $ "CM"
            EditControl := TGridControlTextBox():New( ::Picture[ i ], , "C", , , , Self )
         ELSEIF ValType( ::Picture[ i ] ) == "L" .AND. ::Picture[ i ]
            EditControl := TGridControlImageList():New( Self )
         ELSE
            EditControl := TGridControlTextBox():New( , , , , , , Self )
         ENDIF
      ENDIF
      aEditControls2[ i ] := EditControl
      nWidth := Max( nWidth, EditControl:nDefWidth )
      nRow += EditControl:nDefHeight + 6
   NEXT

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

      IF lSplitWindow
         DEFINE SPLITBOX
            DEFINE WINDOW 0 OBJ oWnd;
                  WIDTH nWidth ;
                  HEIGHT nControlsMaxHeight ;
                  VIRTUAL HEIGHT nRow + 20 ;
                  SPLITCHILD NOCAPTION FONT 'Arial' SIZE 10 BREAK FOCUSED
            ELSE
               oWnd := oMain
            ENDIF

            nRow := 10

            FOR i := 1 To l
               // Do not create label for hidden column
               lHidden := ( AScan( ::aHiddenCols, i ) > 0 )
               IF ! lHidden
                  @ nRow + 3, 10 LABEL 0 PARENT ( oWnd ) VALUE AllTrim( ::aHeaders[ i ] ) + ":" WIDTH 110 NOWORDWRAP
               ENDIF
               aEditControls2[ i ]:CreateControl( aItems[ i ], oWnd:Name, nRow, 120, aEditControls2[ i ]:nDefWidth, aEditControls2[ i ]:nDefHeight )
               nRow += aEditControls2[ i ]:nDefHeight + 6
               IF HB_IsArray( aMemVars ) .AND. Len( aMemVars ) >= i
                  aEditControls2[ i ]:cMemVar := aMemVars[ i ]
                  // Create memvars
                  IF ValType( aMemVars[ i ] ) $ "CM" .AND. ! Empty( aMemVars[ i ] )
                     &( aMemVars[ i ] ) := Nil
                  ENDIF
               ENDIF
               // Set Valid block
               IF lHidden
                  aEditControls2[ i ]:bValid := { || .T. }
                  aEditControls2[ i ]:Visible := .F.
               ELSEIF HB_IsArray( ::Valid ) .AND. Len( ::Valid ) >= i
                  IF HB_IsBlock( ::Valid[ i ] )
                     aEditControls2[ i ]:bValid := ::Valid[ i ]
                  ELSE
                     aEditControls2[ i ]:bValid := { || .T. }
                  ENDIF
               ELSEIF HB_IsBlock( ::Valid )
                  aEditControls2[ i ]:bValid := ::Valid
               ELSE
                  aEditControls2[ i ]:bValid := { || .T. }
               ENDIF
               // Set message for invalid values
               IF HB_IsArray( ::ValidMessages ) .AND. Len( ::ValidMessages ) >= i
                  aEditControls2[ i ]:cValidMessage := ::ValidMessages[ i ]
               ENDIF
               // Set When block
               IF HB_IsArray( ::aWhen ) .AND. Len( ::aWhen ) >= i
                  IF HB_IsBlock( ::aWhen[ i ] )
                     aEditControls2[ i ]:bWhen := ::aWhen[ i ]
                  ELSEIF ! ::IsColumnWhen( i, nItem )
                     aEditControls2[ i ]:Enabled := .F.
                     aEditControls2[ i ]:bWhen := { || .F. }
                  ENDIF
               ELSEIF ! ::IsColumnWhen( i, nItem )
                  aEditControls2[ i ]:Enabled := .F.
                  aEditControls2[ i ]:bWhen := { || .F. }
               ENDIF
               // Set Readonly block
               IF HB_IsArray( ::ReadOnly ) .AND. Len( ::ReadOnly ) >= i
                  IF HB_IsBlock( ::ReadOnly[ i ] )
                     aEditControls2[ i ]:bWhen := ::ReadOnly[ i ]
                  ELSEIF ::IsColumnReadOnly( i, nItem )
                     aEditControls2[ i ]:Enabled := .F.
                     aEditControls2[ i ]:bWhen := { || .F. }
                  ENDIF
               ELSEIF ::IsColumnReadOnly( i, nItem )
                  aEditControls2[ i ]:Enabled := .F.
                  aEditControls2[ i ]:bWhen := { || .F. }
               ENDIF
            NEXT

            IF HB_IsArray( ::aEditKeys )
               FOR i := 1 To Len( ::aEditKeys )
                  IF HB_IsArray( ::aEditKeys[ i ] ) .AND. Len( ::aEditKeys[ i ] ) > 1 .AND. ValType( ::aEditKeys[ i, 1 ] ) $ "CM" .AND. HB_IsBlock( ::aEditKeys[ i, 2 ] )
                     _DefineAnyKey( oWnd, ::aEditKeys[ i, 1 ], ::aEditKeys[ i, 2 ] )
                  ENDIF
               NEXT
            ENDIF

            IF lSplitWindow
            END WINDOW

            DEFINE WINDOW 0 OBJ oWnd ;
                  WIDTH nWidth ;
                  HEIGHT 50 ;
                  SPLITCHILD NOCAPTION FONT 'Arial' SIZE 10 BREAK

               nRow := 10
            ELSE
               nRow += 10
            ENDIF

            @ nRow,  25 BUTTON 0 PARENT ( oWnd ) CAPTION _OOHG_Messages( 1, 6 ) ;
               ACTION ( TGrid_EditItem_Check( aEditControls2, aItems, oMain, aReturn ) )

            @ nRow, 145 BUTTON 0 PARENT ( oWnd ) CAPTION _OOHG_Messages( 1, 7 ) ;
               ACTION oMain:Release()

         END WINDOW

         IF lSplitWindow
         END SPLITBOX
      END WINDOW
   ENDIF

   AEval( aEditControls2, { |o| o:OnLostFocus := { || TGrid_EditItem_When( aEditControls2 ) } } )

   TGrid_EditItem_When( aEditControls2 )

   aEditControls2[ 1 ]:SetFocus()

   oMain:Activate()

   _ClearThisCellInfo()

   ::SetFocus()

   ::lNested := .F.

   RETURN aReturn

STATIC FUNCTION TGrid_EditItem_When( aEditControls )

   LOCAL nItem, lEnabled, aValues

   // Save values
   aValues := Array( Len( aEditControls ) )
   FOR nItem := 1 To Len( aEditControls )
      aValues[ nItem ] := aEditControls[ nItem ]:ControlValue
      IF ValType( aEditControls[ nItem ]:cMemVar ) $ "CM" .AND. ! Empty( aEditControls[ nItem ]:cMemVar )
         &( aEditControls[ nItem ]:cMemVar ) := aValues[ nItem ]
      ENDIF
   NEXT

   // WHEN clause
   FOR nItem := 1 To Len( aEditControls )
      _OOHG_ThisItemCellValue := aValues[ nItem ]
      lEnabled := _OOHG_Eval( aEditControls[ nItem ]:bWhen, nItem, aValues )
      IF _CheckCellNewValue( aEditControls[ nItem ], aValues[ nItem ] )
         aValues[ nItem ] := _OOHG_ThisItemCellValue
      ENDIF
      IF HB_IsLogical( lEnabled ) .AND. ! lEnabled
         aEditControls[ nItem ]:Enabled := .F.
      ELSE
         aEditControls[ nItem ]:Enabled := .T.
      ENDIF
   NEXT

   RETURN aValues

STATIC PROCEDURE TGrid_EditItem_Check( aEditControls, aItems, oWnd, aReturn )

   LOCAL lRet, nItem, aValues, lValid, cValidMessage

   // Save values
   aValues := TGrid_EditItem_When( aEditControls )

   // Check VALID clauses
   lRet := .T.
   FOR nItem := 1 To Len( aEditControls )
      _OOHG_ThisItemCellValue := aValues[ nItem ]
      lValid := _OOHG_Eval( aEditControls[ nItem ]:bValid, aValues[ nItem ], nItem, aValues )
      IF _CheckCellNewValue( aEditControls[ nItem ], aValues[ nItem ] )
         aValues[ nItem ] := _OOHG_ThisItemCellValue
      ENDIF
      IF HB_IsLogical( lValid ) .AND. ! lValid
         lRet := .F.
         cValidMessage := aEditControls[ nItem ]:cValidMessage
         IF HB_IsBlock( cValidMessage )
            cValidMessage := Eval( cValidMessage, _OOHG_ThisItemCellValue )
         ENDIF
         IF ValType( cValidMessage ) $ "CM" .AND. ! Empty( cValidMessage )
            MsgExclamation( cValidMessage )
         ELSE
            MsgExclamation( _OOHG_Messages( 3, 11 ) )
         ENDIF
         aEditControls[ nItem ]:SetFocus()
      ENDIF
   NEXT

   // If all controls are valid, save values into "aItems"
   IF lRet
      ASize( aReturn, Len( aItems ) )
      AEval( aValues, { |u,i| aItems[ i ] := aReturn[ i ] := u } )
      oWnd:Release()
   ENDIF

   RETURN

METHOD IsColumnReadOnly( nCol, nRow ) CLASS TGrid

   LOCAL uReadOnly

   IF ! HB_IsNumeric( nRow ) .OR. nRow < 1 .OR. nRow > :: ItemCount
      nRow := ::FirstSelectedItem
   ENDIF

   IF nRow == 0
      uReadOnly := _OOHG_GetArrayItem( ::ReadOnly, nCol, {} )
   ELSE
      uReadOnly := _OOHG_GetArrayItem( ::ReadOnly, nCol, ::Item( nRow ) )
   ENDIF

   RETURN ( HB_IsLogical( uReadOnly ) .AND. uReadOnly )

METHOD IsColumnWhen( nCol, nRow ) CLASS TGrid

   LOCAL uWhen

   IF ! HB_IsNumeric( nRow ) .OR. nRow < 1 .OR. nRow > :: ItemCount
      nRow := ::FirstSelectedItem
   ENDIF

   IF nRow == 0
      uWhen := _OOHG_GetArrayItem( ::aWhen, nCol, {} )
   ELSE
      uWhen := _OOHG_GetArrayItem( ::aWhen, nCol, ::Item( nRow ) )
   ENDIF

   RETURN ( ! HB_IsLogical( uWhen ) .OR. uWhen )

METHOD AddColumn( nColIndex, cCaption, nWidth, nJustify, uForeColor, uBackColor, ;
      lNoDelete, uPicture, uEditControl, uHeadClick, uValid, ;
      uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign, ;
      uReadOnly ) CLASS TGrid

   LOCAL nColumns, uGridColor, uDynamicColor, i

   // Set Default Values
   nColumns := Len( ::aHeaders ) + 1

   IF ! HB_IsNumeric( nColIndex ) .OR. nColIndex > nColumns
      nColIndex := nColumns
   ELSEIF nColIndex < 1
      nColIndex := 1
   ENDIF

   FOR i := 1 To Len( ::aHiddenCols )
      IF ::aHiddenCols[ i ] >= nColIndex
         ::aHiddenCols[ i ] ++
      ENDIF
   NEXT i

   IF ! ValType( cCaption ) $ 'CM'
      cCaption := ''
   ENDIF

   IF ! HB_IsNumeric( nWidth ) .OR. nWidth < 0
      nWidth := 120
   ENDIF

   IF ! HB_IsNumeric( nJustify )
      nJustify := 0
   ENDIF

   // Update Headers
   ASize( ::aHeaders, nColumns )
   AIns( ::aHeaders, nColIndex )
   ::aHeaders[ nColIndex ] := cCaption

   // Update Pictures
   ASize( ::Picture, nColumns )
   AIns( ::Picture, nColIndex )
   ::Picture[ nColIndex ] := If( ( ValType( uPicture ) $ "CM" .AND. ! Empty( uPicture ) ) .OR. HB_IsLogical( uPicture ), uPicture, Nil )

   // Update Widths
   ASize( ::aWidths, nColumns )
   AIns( ::aWidths, nColIndex )
   ::aWidths[ nColIndex ] := nWidth

   IF ! HB_IsLogical( lNoDelete )
      lNoDelete := .F.
   ENDIF

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
   IF ValType( uEditControl ) != Nil .OR. HB_IsArray( ::EditControls )
      IF ! HB_IsArray( ::EditControls )
         ::EditControls := Array( nColumns )
      ELSEIF Len( ::EditControls ) < nColumns
         ASize( ::EditControls, nColumns )
      ENDIF
      AIns( ::EditControls, nColIndex )
      ::EditControls[ nColIndex ] := uEditControl
      IF ::FixControls()
         ::FixControls( .T. )
      ENDIF
   ENDIF

   // Update justification
   ASize( ::aJust, nColumns )
   AIns( ::aJust, nColIndex )
   ::aJust[ nColIndex ] := nJustify

   // Update on head click codeblock
   ASize( ::aHeadClick, nColumns )
   AIns( ::aHeadClick, nColIndex )
   ::aHeadClick[ nColIndex ] := uHeadClick

   // Update valid
   IF HB_IsArray( ::Valid )
      ASize( ::Valid, nColumns )
      AIns( ::Valid, nColIndex )
      ::Valid[ nColIndex ] := uValid
   ELSEIF uValid != Nil
      ::Valid := Array( nColumns )
      ::Valid[ nColIndex ] := uValid
   ENDIF

   // Update validmessages
   IF HB_IsArray( ::ValidMessages )
      ASize( ::ValidMessages, nColumns )
      AIns( ::ValidMessages, nColIndex )
      ::ValidMessages[ nColIndex ] := uValidMessage
   ELSEIF uValidMessage != Nil
      ::ValidMessages := Array( nColumns )
      ::ValidMessages[ nColIndex ] := uValidMessage
   ENDIF

   // Update when
   IF HB_IsArray( ::aWhen )
      ASize( ::aWhen, nColumns )
      AIns( ::aWhen, nColIndex )
      ::aWhen[ nColIndex ] := uWhen
   ELSEIF uWhen != Nil
      ::aWhen := Array( nColumns )
      ::aWhen[ nColIndex ] := uWhen
   ENDIF

   // Update readonly
   IF HB_IsArray( ::Readonly )
      ASize( ::Readonly, nColumns )
      AIns( ::Readonly, nColIndex )
      ::Readonly[ nColIndex ] := uReadOnly
   ELSEIF uReadOnly != Nil
      ::Readonly := Array( nColumns )
      ::Readonly[ nColIndex ] := uReadOnly
   ENDIF

   // Update header image
   ASize( ::aHeaderImage, nColumns )
   AIns( ::aHeaderImage, nColIndex )
   IF ! HB_IsNumeric( nHeaderImage ) .OR. nHeaderImage < 0
      nHeaderImage := 0
   ENDIF
   ::HeaderImage( nColIndex, nHeaderImage )

   // Update header image alignment
   ASize( ::aHeaderImageAlign, nColumns )
   AIns( ::aHeaderImageAlign, nColIndex )
   IF ! HB_IsNumeric( nHeaderImageAlign ) .OR. nHeaderImageAlign != HEADER_IMG_AT_RIGHT
      nHeaderImageAlign := HEADER_IMG_AT_LEFT
   ENDIF
   ::HeaderImageAlign( nColIndex, nHeaderImageAlign )

   // Call C-Level Routine
   ListView_AddColumn( ::hWnd, nColIndex, nWidth, cCaption, nJustify, lNoDelete )

   RETURN nColIndex

   // aGrid and uDynamicColor may be passed by reference

STATIC FUNCTION TGrid_AddColumnColor( aGrid, nColumn, uColor, uDynamicColor, nWidth, nItemCount, lNoDelete, hWnd )

   LOCAL uTemp, x

   IF ValType( uDynamicColor ) == "A"
      IF Len( uDynamicColor ) < nWidth
         ASize( uDynamicColor, nWidth )
      ENDIF
      AIns( uDynamicColor, nColumn )
      uDynamicColor[ nColumn ] := uColor
   ELSEIF ValType( uColor ) $ "ANB"
      uTemp := uDynamicColor
      uDynamicColor := Array( nWidth )
      AFill( uDynamicColor, uTemp )
      uDynamicColor[ nColumn ] := uColor
   ENDIF

   IF ! lNoDelete
      uDynamicColor := Nil
   ELSEIF HB_IsArray( aGrid ) .OR. ValType( uColor ) $ "ANB" .OR. ValType( uDynamicColor ) $ "ANB"
      IF HB_IsArray( aGrid )
         IF Len( aGrid ) < nItemCount
            ASize( aGrid, nItemCount )
         ELSE
            nItemCount := Len( aGrid )
         ENDIF
      ELSE
         aGrid := Array( nItemCount )
      ENDIF
      FOR x := 1 To nItemCount
         IF HB_IsArray( aGrid[ x ] )
            IF Len( aGrid[ x ] ) < nWidth
               ASize( aGrid[ x ], nWidth )
            ENDIF
            AIns( aGrid[ x ], nColumn )
         ELSE
            aGrid[ x ] := Array( nWidth )
         ENDIF
         _SetThisCellInfo( hWnd, x, nColumn, Nil )
         aGrid[ x ][ nColumn ] := _OOHG_GetArrayItem( uDynamicColor, nColumn, x )
         _ClearThisCellInfo()
      NEXT
   ENDIF

   RETURN NIL

METHOD SetColumn( nColIndex, cCaption, nWidth, nJustify, uForeColor, uBackColor, ;
      lNoDelete, uPicture, uEditControl, uHeadClick, uValid, ;
      uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign, ;
      uReadonly ) CLASS TGrid

   LOCAL nColumns, uGridColor, uDynamicColor

   // Set Default Values
   nColumns := Len( ::aHeaders )

   IF ! HB_IsNumeric( nColIndex ) .OR. nColIndex > nColumns
      nColIndex := nColumns
   ELSEIF nColIndex < 1
      nColIndex := 1
   ENDIF

   IF ! ValType( cCaption ) $ 'CM'
      cCaption := ''
   ENDIF

   IF ! HB_IsNumeric( nWidth ) .OR. nWidth < 0
      nWidth := ::ColumnWidth( nColIndex )
   ENDIF

   IF ! HB_IsNumeric( nJustify )
      nJustify := 0
   ENDIF

   // Update Headers
   ::aHeaders[ nColIndex ] := cCaption

   // Update Pictures
   ::Picture[ nColIndex ] := If( ( ValType( uPicture ) $ "CM" .AND. ! Empty( uPicture ) ) .OR. HB_IsLogical( uPicture ), uPicture, Nil )

   // Update Widths
   ::aWidths[ nColIndex ] := nWidth

   IF ! HB_IsLogical( lNoDelete )
      lNoDelete := .F.
   ENDIF

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
   IF ValType( uEditControl ) != Nil .OR. HB_IsArray( ::EditControls )
      IF ! HB_IsArray( ::EditControls )
         ::EditControls := Array( nColumns )
      ELSEIF Len( ::EditControls ) < nColumns
         ASize( ::EditControls, nColumns )
      ENDIF
      ::EditControls[ nColIndex ] := uEditControl
      IF ::FixControls()
         ::FixControls( .T. )
      ENDIF
   ENDIF

   // Update justification
   ::aJust[ nColIndex ] := nJustify

   // Update on head click codeblock
   ::aHeadClick[ nColIndex ] := uHeadClick

   // Update valid
   IF HB_IsArray( ::Valid )
      ::Valid[ nColIndex ] := uValid
   ELSEIF uValid != Nil
      ::Valid := Array( nColumns )
      ::Valid[ nColIndex ] := uValid
   ENDIF

   // Update validmessages
   IF HB_IsArray( ::ValidMessages )
      ::ValidMessages[ nColIndex ] := uValidMessage
   ELSEIF uValidMessage != Nil
      ::ValidMessages := Array( nColumns )
      ::ValidMessages[ nColIndex ] := uValidMessage
   ENDIF

   // Update when
   IF HB_IsArray( ::aWhen )
      ::aWhen[ nColIndex ] := uWhen
   ELSEIF uWhen != Nil
      ::aWhen := Array( nColumns )
      ::aWhen[ nColIndex ] := uWhen
   ENDIF

   // Update readonly
   IF HB_IsArray( ::Readonly )
      ::Readonly[ nColIndex ] := uReadOnly
   ELSEIF uReadOnly != Nil
      ::Readonly := Array( nColumns )
      ::Readonly[ nColIndex ] := uReadOnly
   ENDIF

   // Update header image
   IF ! HB_IsNumeric( nHeaderImage ) .OR. nHeaderImage < 0
      nHeaderImage := 0
   ENDIF
   ::HeaderImage( nColIndex, nHeaderImage )

   // Update header image alignment
   IF ! HB_IsNumeric( nHeaderImageAlign ) .OR. nHeaderImageAlign != HEADER_IMG_AT_RIGHT
      nHeaderImageAlign := HEADER_IMG_AT_LEFT
   ENDIF
   ::HeaderImageAlign( nColIndex, nHeaderImageAlign )

   // Call C-Level Routine
   ListView_SetColumn( ::hWnd, nColIndex, nWidth, cCaption, nJustify, lNoDelete )

   RETURN nColIndex

METHOD ColumnBetterAutoFit( nColIndex ) CLASS Tgrid

   LOCAL n, nh

   IF HB_IsNumeric( nColIndex )
      IF nColindex > 0
         nh := ::ColumnAutoFitH( nColIndex )
         n := ::ColumnAutoFit( nColIndex )
         IF nh > n
            ::ColumnAutoFitH( nColIndex )
         ENDIF
      ENDIF
   ENDIF

   RETURN Self

METHOD ColumnHide( nColIndex ) CLASS TGrid

   IF HB_IsNumeric( nColIndex )
      IF nColIndex > 0 .AND. nColIndex <= Len( ::aHeaders ) .AND. AScan( ::aHiddenCols, nColIndex ) == 0
         ::ColumnWidth( nColIndex, 0 )
      ENDIF
   ENDIF

   RETURN Self

METHOD ColumnShow( nColIndex ) CLASS TGrid

   LOCAL i

   IF HB_IsNumeric( nColIndex )
      IF nColindex > 0
         i := AScan( ::aHiddenCols, nColIndex )
         IF i > 0
            ::ColumnBetterAutoFit ( nColIndex )
            _OOHG_DeleteArrayItem( ::aHiddenCols, i )
         ENDIF
      ENDIF
   ENDIF

   RETURN Self

METHOD ColumnOrder( aOrder ) CLASS TGrid

   IF HB_IsArray( aOrder )
      ListView_SetColumnOrder( ::hWnd, aOrder )
      ::Refresh()
   ENDIF

   RETURN ListView_GetColumnOrder( ::hWnd )

METHOD DeleteColumn( nColIndex, lNoDelete ) CLASS TGrid

   LOCAL nColumns, i

   nColumns := Len( ::aHeaders )
   IF nColumns == 0

      RETURN 0
   ENDIF

   IF ! HB_IsNumeric( nColIndex ) .OR. nColIndex > nColumns
      nColIndex := nColumns
   ELSEIF nColIndex < 1
      nColIndex := 1
   ENDIF

   IF ( i := AScan( ::aHiddenCols, nColIndex ) ) > 0
      _OOHG_DeleteArrayItem( ::aHiddenCols, i )
   ENDIF

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
   _OOHG_DeleteArrayItem( ::Readonly, nColIndex )
   _OOHG_DeleteArrayItem( ::EditControls, nColIndex )
   _OOHG_DeleteArrayItem( ::aEditControls, nColIndex )

   IF HB_IsLogical( lNoDelete ) .AND. lNoDelete
      IF HB_IsArray( ::GridForeColor )
         AEval( ::GridForeColor, { |a| _OOHG_DeleteArrayItem( a, nColIndex ) } )
      ENDIF
      IF ValType( ::GridBackColor ) == "A"
         AEval( ::GridBackColor, { |a| _OOHG_DeleteArrayItem( a, nColIndex ) } )
      ENDIF
   ELSE
      ::GridForeColor := Nil
      ::GridBackColor := Nil
   ENDIF

   // Call C-Level Routine
   ListView_DeleteColumn( ::hWnd, nColIndex, lNoDelete )

   RETURN nColIndex

METHOD Value( uValue ) CLASS TGrid

   IF HB_IsNumeric( uValue )
      IF ::lNoneUnsels .AND. ( uValue < 1 .OR. uValue > ::ItemCount() )
         IF ::FirstSelectedItem # 0
            ListView_ClearCursel( ::hWnd, 0 )
            ::DoChange()
         ENDIF
      ELSE
         ListView_SetCursel( ::hWnd, uValue )
         ListView_EnsureVisible( ::hWnd, uValue )
      ENDIF
   ENDIF

   RETURN ::FirstSelectedItem

METHOD Cell( nRow, nCol, uValue ) CLASS TGrid

   LOCAL aItem, uValue2 := Nil

   IF nRow >= 1 .AND. nRow <= ::ItemCount
      aItem := ::Item( nRow )
      IF nCol >= 1 .AND. nCol <= Len( aItem )
         IF PCount() > 2
            aItem[ nCol ] := uValue
            ::Item( nRow, aItem )
         ENDIF
         uValue2 := aItem[ nCol ]
      ENDIF
   ENDIF

   RETURN uValue2

METHOD EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, nOnFocusPos, lChange ) CLASS TGrid

   LOCAL lRet, lRet2

   IF ::FirstVisibleColumn == 0

      RETURN .F.
   ENDIF
   IF ! HB_IsNumeric( nRow )
      nRow := Max( ::FirstSelectedItem, 1 )
   ENDIF
   IF ! HB_IsNumeric( nCol )
      IF ::lAppendMode .OR. ::lAtFirstCol
         nCol := ::FirstColInOrder
      ELSE
         nCol := ::FirstVisibleColumn
      ENDIF
   ENDIF
   IF nRow < 1 .OR. nRow > ::ItemCount .OR. nCol < 1 .OR. nCol > Len( ::aHeaders )

      RETURN .F.
   ENDIF
   IF AScan( ::aHiddenCols, nCol ) > 0

      RETURN .F.
   ENDIF

   ASSIGN lChange VALUE lChange TYPE "L" DEFAULT ::lChangeBeforeEdit
   IF lChange
      ::SetControlValue( nRow )
   ENDIF

   IF HB_IsBlock( ::OnBeforeEditCell )
      _OOHG_ThisItemCellValue := ::Cell( nRow, nCol )
      lRet2 := ::DoEvent( ::OnBeforeEditCell, "BEFOREEDITCELL", { nRow, nCol } )
      _ClearThisCellInfo()
      IF ! HB_IsLogical( lRet2 )
         lRet2 := .T.
      ENDIF
   ELSE
      lRet2 := .T.
   ENDIF

   IF lRet2
      lRet := ::EditCell2( @nRow, @nCol, @EditControl, uOldValue, @uValue, cMemVar, nOnFocusPos )
   ELSE
      lRet := .F.
   ENDIF

   IF lRet
      IF ValType( uValue ) $ "CM"
         uValue := Trim( uValue )
      ENDIF
      IF HB_IsBlock( ::OnEditCellEnd )
         _SetThisCellInfo( ::hWnd, nRow, nCol, uValue )
         lRet2 := ::DoEvent( ::OnEditCellEnd, "EDITCELLEND", { nRow, nCol } )
         _ClearThisCellInfo()
         IF HB_IsLogical( lRet2 ) .and. ! lRet2
            lRet := .F.
         ENDIF
      ENDIF

      IF lRet
         ::Cell( nRow, nCol, uValue )
         _SetThisCellInfo( ::hWnd, nRow, nCol, uValue )
         IF HB_IsBlock( ::OnEditCell )
            lRet2 := ::DoEvent( ::OnEditCell, "EDITCELL", { nRow, nCol } )
            IF HB_IsLogical( lRet2 ) .and. ! lRet2
               lRet := .F.
            ENDIF
         ENDIF
         IF lRet
            IF _CheckCellNewValue( EditControl, @uValue )
               ::Cell( nRow, nCol, uValue )
            ENDIF
         ENDIF
         _ClearThisCellInfo()

         IF lRet
            IF ! ::lCalledFromClass .AND. ::bPosition == 9
               // Edition window lost focus, resume clic processing and process delayed click
               ::bPosition := 0
               IF ::nDelayedClick[ 1 ] > 0
                  // A click message was delayed
                  IF ::nDelayedClick[ 3 ] <= 0
                     ::SetControlValue( ::nDelayedClick[ 1 ] )
                  ENDIF

                  IF HB_IsNil( ::nDelayedClick[ 4 ] )
                     IF HB_IsBlock( ::OnClick )
                        IF ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                           IF ! ::NestedClick
                              ::NestedClick := ! _OOHG_NestedSameEvent()
                              ::DoEventMouseCoords( ::OnClick, "CLICK" )
                              ::NestedClick := .F.
                           ENDIF
                        ENDIF
                     ENDIF
                  ELSE
                     IF HB_IsBlock( ::OnRClick )
                        IF ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                           ::DoEventMouseCoords( ::OnRClick, "RCLICK" )
                        ENDIF
                     ENDIF
                  ENDIF

                  IF ::nDelayedClick[ 3 ] > 0
                     // change check mark
                     ::CheckItem( ::nDelayedClick[ 3 ], ! ::CheckItem( ::nDelayedClick[ 3 ] ) )
                  ENDIF

                  // fire context menu
                  IF ! HB_IsNil( ::nDelayedClick[ 4 ] ) .AND. ::ContextMenu != Nil .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0 )
                     ::ContextMenu:Cargo := ::nDelayedClick[ 4 ]
                     ::ContextMenu:Activate()
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   IF ! lRet
      IF ::lAppendMode
         ::DoEvent( ::OnAbortEdit, "ABORTEDIT", { 0, 0 } )
         ::DeleteItem( ::ItemCount )
         ::SetControlValue( ::ItemCount )
      ELSE
         ::DoEvent( ::OnAbortEdit, "ABORTEDIT", { nRow, nCol } )
      ENDIF
   ENDIF

   RETURN lRet

   // nRow, nCol, EditControl and uValue may be passed by reference

METHOD EditCell2( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, nOnFocusPos ) CLASS TGrid

   LOCAL r, r2, lRet := .F., nClientWidth, nScrollWidth

   IF ! ValType( cMemVar ) $ "CM" .OR. Empty( cMemVar )
      cMemVar := "_OOHG_NULLVAR_"
   ENDIF
   IF ! HB_IsNumeric( nRow )
      nRow := Max( ::FirstSelectedItem, 1 )
   ENDIF
   IF ! HB_IsNumeric( nCol )
      IF ::lAtFirstCol
         nCol := ::FirstColInOrder
      ELSE
         nCol := ::FirstVisibleColumn
      ENDIF
   ENDIF
   IF nRow < 1 .OR. nRow > ::ItemCount .OR. nCol < 1 .OR. nCol > Len( ::aHeaders )

      RETURN .F.
   ENDIF
   IF ::lNested

      RETURN .F.
   ENDIF
   ::lNested := .T.

   IF ! ::lCalledFromClass
      // This var may be used in When codeblock
      _OOHG_ThisItemCellValue := ::Cell( nRow, nCol )

      IF ::IsColumnReadOnly( nCol, nRow )
         // Read only column
         IF ! ::lSilent
            PlayHand()
         ENDIF
         ::lNested := .F.

         RETURN .F.
      ELSEIF ! ::IsColumnWhen( nCol, nRow )
         // WHEN Returned .F.
         ::lNested := .F.

         RETURN .F.
      ELSEIF AScan( ::aHiddenCols, nCol ) > 0
         // Hidden column
         ::lNested := .F.

         RETURN .F.
      ENDIF
   ENDIF

   // Get the initial value of the EditControl
   IF ValType( uOldValue ) == "U"
      uValue := ::Cell( nRow, nCol )
   ELSEIF HB_IsBlock( ::bEditCellValue )
      uValue := Eval( ::bEditCellValue, nCol, nRow, uOldValue )
   ELSE
      uValue := uOldValue
   ENDIF

   // Determine control type
   IF ! HB_IsObject( EditControl ) .AND. ::FixControls()
      EditControl := ::aEditControls[ nCol ]
   ENDIF
   EditControl := GetEditControlFromArray( EditControl, ::EditControls, nCol, Self )
   IF HB_IsObject( EditControl )
      // EditControl specified
   ELSEIF ValType( ::Picture[ nCol ] ) $ "CM"
      // Picture-based
      EditControl := TGridControlTextBox():New( ::Picture[ nCol ], , ValType( uValue ), , , , Self )
   ELSEIF ValType( ::Picture[ nCol ] ) == "L" .AND. ::Picture[ nCol ]
      EditControl := TGridControlImageList():New( Self )
   ELSE
      // Derive from data type
      EditControl := GridControlObjectByType( uValue, Self )
   ENDIF

   IF ! HB_IsObject( EditControl )
      MsgExclamation( _OOHG_Messages( 1, 12 ), _OOHG_Messages( 1, 5 ) )
   ELSE
      r := { 0, 0, 0, 0 }                                        // left, top, right, bottom
      GetClientRect( ::hWnd, r )
      nClientWidth := r[ 3 ] - r[ 1 ]
      r2 := { 0, 0, 0, 0 }                                       // left, top, right, bottom
      GetWindowRect( ::hWnd, r2 )
      // Ensure cell is visible and compute editing window's rect
      IF ! OsIsWinVistaOrLater() .OR. ! ListView_IsItemVisible( ::hWnd, nRow )
         ListView_EnsureVisible( ::hWnd, nRow )
      ENDIF
      r := ListView_GetSubitemRect( ::hWnd, nRow - 1, nCol - 1 ) // top, left, width, height
      IF ::lScrollBarUsesClientArea .AND. ::ItemCount > ::CountPerPage
         nScrollWidth := GetVScrollBarWidth()
      ELSE
         nScrollWidth := 0
      ENDIF
      IF r[ 2 ] + r[ 3 ] + nScrollWidth > nClientWidth
         ListView_Scroll( ::hWnd, ( r[ 2 ] + r[ 3 ] + nScrollWidth - nClientWidth ), 0 )
         r := ListView_GetSubitemRect( ::hWnd, nRow - 1, nCol - 1 )
         r[ 3 ] := Min( r[ 3 ], nClientWidth )
      ENDIF
      IF r[ 2 ] < 0
         ListView_Scroll( ::hWnd, r[ 2 ], 0 )
         r := ListView_GetSubitemRect( ::hWnd, nRow - 1, nCol - 1 )
         r[ 3 ] := Min( r[ 3 ], nClientWidth )
      ENDIF

      // Transform to screen coordinates, add some margins and check it's within form's rect
      r[ 1 ] += r2[ 2 ] + 2
      r[ 2 ] += r2[ 1 ] + 3
      r[ 3 ] := Min( r[ 3 ], ::Parent:Col + ::Parent:Width - GetBorderWidth() - r[ 2 ] )

      EditControl:cMemVar := cMemVar
      // Create memvar
      &( cMemVar ) := Nil

      IF HB_IsArray( ::Valid ) .AND. Len( ::Valid ) >= nCol
         IF HB_IsBlock( ::Valid[ nCol ] )
            EditControl:bValid := ::Valid[ nCol ]
         ELSE
            EditControl:bValid := { || .T. }
         ENDIF
      ELSEIF HB_IsBlock( ::Valid )
         EditControl:bValid := ::Valid
      ELSE
         EditControl:bValid := { || .T. }
      ENDIF
      IF HB_IsArray( ::ValidMessages ) .AND. Len( ::ValidMessages ) >= nCol
         EditControl:cValidMessage := ::ValidMessages[ nCol ]
      ENDIF
      IF nOnFocusPos # Nil
         EditControl:nOnFocusPos := nOnFocusPos
      ENDIF
      IF ValType( uValue ) $ "CM"
         uValue := Trim( uValue )
      ENDIF

      ::nEditRow := nRow
      ::nDelayedClick := { 0, 0, 0, .F. }
      ::bPosition := -2
      _SetThisCellInfo( ::hWnd, nRow, nCol, uValue )
      lRet := EditControl:CreateWindow( uValue, r[ 1 ], r[ 2 ], r[ 3 ], r[ 4 ], ::FontName, ::FontSize, ::aEditKeys, Self )
      IF lRet
         uValue := EditControl:Value
      ELSE
         ::SetFocus()
      ENDIF

      _OOHG_ThisType := ''
      _ClearThisCellInfo()

   ENDIF

   ::lNested := .F.

   RETURN lRet

METHOD EditAllCells( nRow, nCol, lAppend, lOneRow, lChange ) CLASS TGrid

   LOCAL lRet, lSomethingEdited

   IF ::FullMove

      RETURN ::EditGrid( nRow, nCol, lAppend, lOneRow, lChange )
   ENDIF

   IF ::FirstVisibleColumn == 0

      RETURN .F.
   ENDIF

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.

   IF ! HB_IsNumeric( nCol )
      IF ::lAppendMode .OR. lAppend .OR. ::lAtFirstCol
         nCol := ::FirstColInOrder
      ELSE
         nCol := ::FirstVisibleColumn
      ENDIF
   ENDIF
   IF nCol < 1 .OR. nCol > Len( ::aHeaders )

      RETURN .F.
   ENDIF

   IF ::lAppendMode
      // Before calling ::EditAllCells an empty item was added at ::ItemCount
      nRow := ::ItemCount
   ELSEIF lAppend
      // Add new item, ignore ::AllowAppend
      ::lAppendMode := .T.
      ::InsertBlank( ::ItemCount + 1 )
      ::SetControlValue( ::ItemCount, nCol )       // Needed by TGridByCell:EditAllCells
      nRow := ::ItemCount
   ELSE
      // Edit item nRow
      IF ! HB_IsNumeric( nRow )
         nRow := Max( ::FirstSelectedItem, 1 )
      ENDIF
      IF nRow < 1 .OR. nRow > ::ItemCount

         RETURN .F.
      ENDIF
      ASSIGN lChange VALUE lChange TYPE "L" DEFAULT ::lChangeBeforeEdit
      IF lChange
         ::SetControlValue( nRow, nCol )           // Needed by TGridByCell:EditAllCells
      ENDIF
   ENDIF

   ASSIGN lOneRow VALUE lOneRow TYPE "L" DEFAULT .T.

   lSomethingEdited := .F.

   DO WHILE nCol >= 1 .AND. nCol <= Len( ::aHeaders )
      _OOHG_ThisItemCellValue := ::Cell( nRow, nCol )

      IF ::IsColumnReadOnly( nCol, nRow )
         // Read only column
      ELSEIF ! ::IsColumnWhen( nCol, nRow )
         // WHEN Returned .F.
      ELSEIF AScan( ::aHiddenCols, nCol ) > 0
         // Hidden column
      ELSE
         ::lCalledFromClass := .T.
         lRet := ::EditCell( nRow, nCol, , , , , , .F. )
         ::lCalledFromClass := .F.

         IF ::lAppendMode
            ::lAppendMode := .F.
            IF lRet
               ::DoEvent( ::OnAppend, "APPEND", { nRow } )
               lSomethingEdited := .T.
            ELSE
               EXIT
            ENDIF
         ELSEIF lRet
            lSomethingEdited := .T.
         ELSE
            EXIT
         ENDIF

         IF ::bPosition == 9                     // MOUSE EXIT
            // Edition window lost focus, resume clic processing and process delayed click
            ::bPosition := 0
            IF ::nDelayedClick[ 1 ] > 0
               // A click message was delayed
               IF ::nDelayedClick[ 3 ] <= 0
                  ::SetControlValue( ::nDelayedClick[ 1 ], ::nDelayedClick[ 2 ] )           // Second parameter is needed by TGridByCell:EditAllCells
               ENDIF

               IF HB_IsNil( ::nDelayedClick[ 4 ] )
                  IF HB_IsBlock( ::OnClick )
                     IF ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                        IF ! ::NestedClick
                           ::NestedClick := ! _OOHG_NestedSameEvent()
                           ::DoEventMouseCoords( ::OnClick, "CLICK" )
                           ::NestedClick := .F.
                        ENDIF
                     ENDIF
                  ENDIF
               ELSE
                  IF HB_IsBlock( ::OnRClick )
                     IF ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                        ::DoEventMouseCoords( ::OnRClick, "RCLICK" )
                     ENDIF
                  ENDIF
               ENDIF

               IF ::nDelayedClick[ 3 ] > 0
                  // change check mark
                  ::CheckItem( ::nDelayedClick[ 3 ], ! ::CheckItem( ::nDelayedClick[ 3 ] ) )
               ENDIF

               // fire context menu
               IF ! HB_IsNil( ::nDelayedClick[ 4 ] ) .AND. ::ContextMenu != Nil .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0 )
                  ::ContextMenu:Cargo := ::nDelayedClick[ 4 ]
                  ::ContextMenu:Activate()
               ENDIF
            ENDIF
            EXIT
         ENDIF
      ENDIF

      nCol := ::NextColInOrder( nCol )
      IF nCol > 0
         ::SetControlValue( nRow, nCol )           // Needed by TGridByCell:EditAllCells
      ELSEIF lOneRow
         EXIT
      ELSEIF nRow < ::ItemCount
         nRow ++
         nCol := ::FirstColInOrder
         IF nCol == 0
            EXIT
         ENDIF
         ::SetControlValue( nRow, nCol )           // Needed by TGridByCell:EditAllCells
         ::ScrollToLeft()
      ELSEIF lAppend .OR. ::AllowAppend
         nCol := ::FirstColInOrder
         IF nCol == 0
            EXIT
         ENDIF
         ::lAppendMode := .T.
         ::InsertBlank( ::ItemCount + 1 )
         nRow := ::ItemCount
         ::SetControlValue( nRow, nCol )           // Needed by TGridByCell:EditAllCells
         ::ScrollToLeft()
      ELSE
         EXIT
      ENDIF
   ENDDO

   ::ScrollToLeft()

   RETURN lSomethingEdited

FUNCTION _OOHG_TGrid_Events2( Self, hWnd, nMsg, wParam, lParam ) // CLASS TGrid

   LOCAL aCellData, nItem, i, aPos

   IF nMsg == WM_LBUTTONDBLCLK
      IF  ! ::lCheckBoxes .OR. ListView_HitOnCheckBox( hWnd, GetCursorRow() - GetWindowRow( hWnd ), GetCursorCol() - GetWindowCol( hWnd ) ) <= 0
         _PushEventInfo()
         _OOHG_ThisForm := ::Parent
         _OOHG_ThisType := 'C'
         _OOHG_ThisControl := Self

         // Identify item & subitem hitted
         aPos := Get_XY_LPARAM( lParam )
         aPos := ListView_HitTest( ::hWnd, aPos[ 1 ], aPos[ 2 ] )

         aCellData := _GetGridCellData( Self, aPos )
         _OOHG_ThisItemRowIndex   := aCellData[ 1 ]
         _OOHG_ThisItemColIndex   := aCellData[ 2 ]
         _OOHG_ThisItemCellRow    := aCellData[ 3 ]
         _OOHG_ThisItemCellCol    := aCellData[ 4 ]
         _OOHG_ThisItemCellWidth  := aCellData[ 5 ]
         _OOHG_ThisItemCellHeight := aCellData[ 6 ]
         _OOHG_ThisItemCellValue  := ::Cell( _OOHG_ThisItemRowIndex, _OOHG_ThisItemColIndex )

         IF ! ::AllowEdit .OR. _OOHG_ThisItemRowIndex < 1 .OR. _OOHG_ThisItemRowIndex > ::ItemCount .OR. _OOHG_ThisItemColIndex < 1 .OR. _OOHG_ThisItemColIndex > Len( ::aHeaders )
            IF HB_IsBlock( ::OnDblClick )
               ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
            ENDIF
         ELSEIF ::FullMove
            IF ::IsColumnReadOnly( _OOHG_ThisItemColIndex, _OOHG_ThisItemRowIndex )
               // Cell is readonly
               IF ::lExtendDblClick .and. HB_IsBlock( ::OnDblClick )
                  ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
               ENDIF
            ELSEIF ! ::IsColumnWhen( _OOHG_ThisItemColIndex, _OOHG_ThisItemRowIndex )
               // WHEN returned .F.
               IF ::lExtendDblClick .and. HB_IsBlock( ::OnDblClick )
                  ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
               ENDIF
            ELSEIF AScan( ::aHiddenCols, _OOHG_ThisItemColIndex ) > 0
               // Hidden column
               IF ::lExtendDblClick .and. HB_IsBlock( ::OnDblClick )
                  ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
               ENDIF
            ELSE
               ::EditGrid( _OOHG_ThisItemRowIndex, _OOHG_ThisItemColIndex )
            ENDIF
         ELSEIF ::InPlace
            IF ::IsColumnReadOnly( _OOHG_ThisItemColIndex, _OOHG_ThisItemRowIndex )
               // Cell is readonly
               IF ::lExtendDblClick .and. HB_IsBlock( ::OnDblClick )
                  ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
               ENDIF
            ELSEIF ! ::IsColumnWhen( _OOHG_ThisItemColIndex, _OOHG_ThisItemRowIndex )
               // WHEN returned .F.
               IF ::lExtendDblClick .and. HB_IsBlock( ::OnDblClick )
                  ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
               ENDIF
            ELSEIF AScan( ::aHiddenCols, _OOHG_ThisItemColIndex ) > 0
               // Hidden column
               IF ::lExtendDblClick .and. HB_IsBlock( ::OnDblClick )
                  ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
               ENDIF
            ELSE
               ::EditCell( _OOHG_ThisItemRowIndex, _OOHG_ThisItemColIndex )
            ENDIF
         ELSE
            ::EditItem()
         ENDIF

         _ClearThisCellInfo()
         _PopEventInfo()
      ENDIF

      RETURN 0

   ELSEIF nMsg == WM_MOUSEWHEEL
      IF GET_WHEEL_DELTA_WPARAM( wParam ) > 0
         ::Up()
      ELSE
         ::Down()
      ENDIF

      RETURN 1

   ELSEIF nMsg == WM_CHAR
      IF wParam < 32
         ::cText := ""

         RETURN 0
      ELSEIF Empty( ::cText )
         ::uIniTime := HB_MilliSeconds()
         ::cText := Upper( Chr( wParam ) )
      ELSEIF HB_MilliSeconds() > ::uIniTime + ::SearchLapse
         ::uIniTime := HB_MilliSeconds()
         ::cText := Upper( Chr( wParam ) )
      ELSE
         ::uIniTime := HB_MilliSeconds()
         ::cText += Upper( Chr( wParam ) )
      ENDIF

      IF ::SearchCol >= 1
         nItem := 0

         IF ::SearchCol <= ::ColumnCount .AND. AScan( ::aHiddenCols, ::SearchCol ) == 0
            FOR i := ::FirstSelectedItem + 1 To ::ItemCount
               IF Upper( Left( ::CellCaption( i, ::SearchCol ), Len( ::cText ) ) ) == ::cText
                  nItem := i
                  EXIT
               ENDIF
            NEXT i

            IF nItem == 0 .AND. ::SearchWrap
               FOR i := 1 To ::FirstSelectedItem
                  IF Upper( Left( ::CellCaption( i, ::SearchCol ), Len( ::cText ) ) ) == ::cText
                     nItem := i
                     EXIT
                  ENDIF
               NEXT i
            ENDIF
         ENDIF
      ELSE
         nItem := ListView_FindItem( hWnd, ::FirstSelectedItem - 2, ::cText, ::SearchWrap )
      ENDIF
      IF nItem > 0
         ::SetControlValue( nItem )
      ENDIF

      RETURN 0

   ENDIF

   RETURN NIL

FUNCTION _OOHG_TGrid_Notify2( Self, wParam, lParam ) // CLASS TGrid

   LOCAL nNotify, nColumn, lGo, nNewWidth, nResul, aRect

   nNotify := GetNotifyCode( lParam )
   nColumn := NMHeader_iItem( lParam )

   IF nNotify == HDN_BEGINDRAG
      // The user has begun dragging a column
      IF HB_IsLogical( ::AllowMoveColumn ) .AND. ! ::AllowMoveColumn
         // Prevent the action

         RETURN 1
      ENDIF

      IF HB_IsBlock( ::bBeforeColMove )
         lGo := Eval( ::bBeforeColMove, nColumn )
         IF HB_IsLogical( lGo ) .and. ! lGo
            // Prevent the action

            RETURN 1
         ENDIF
      ENDIF

   ELSEIF nNotify == HDN_ENDDRAG
      // The user has finished dragging a column
      IF HB_IsBlock( ::bAfterColMove )
         // HDITEM_iOrder() Returns the destination position in the header
         lGo := Eval( ::bAfterColMove, nColumn, HDITEM_iOrder( lParam ) )
         IF HB_IsLogical( lGo ) .and. ! lGo
            // Prevent the action so the column remains in it's original place

            RETURN 1
         ENDIF
      ENDIF

   ELSEIF nNotify == HDN_BEGINTRACK
      // The user has begun dragging a column divider
      IF HB_IsLogical( ::AllowChangeSize ) .AND. ! ::AllowChangeSize
         // Prevent the action

         RETURN 1
      ENDIF

      // Is a hidden column ?
      IF AScan( ::aHiddenCols, nColumn ) > 0
         // Prevent the action

         RETURN 1
      ENDIF

      IF HB_IsBlock( ::bBeforeColSize )
         lGo := Eval( ::bBeforeColSize, nColumn )
         IF HB_IsLogical( lGo ) .and. ! lGo
            // Prevent the action

            RETURN 1
         ENDIF
      ENDIF

      /*
      Notification sequence:
      for XP, Win7 with manifest
      when user starts dragging
      HDN_BEGINTRACK
      while tracking goes on
      HDN_ITEMCHANGING
      HDN_ITEMCHANGED
      when user releases the mouse button
      HDN_ENDTRACK
      HDN_ITEMCHANGING
      HDN_ITEMCHANGED
      NM_RELEASEDCAPTURE

      for Win7 without manifest
      when user starts dragging
      HDN_BEGINTRACK
      while tracking goes on
      HDN_TRACK
      when user releases the mouse button
      HDN_ENDTRACK
      HDN_ITEMCHANGING
      HDN_ITEMCHANGED
      NM_RELEASEDCAPTURE
      */

      // Set HDN_BEGINTRACK flag and reset others
      ::lBeginTrack      := .T.
      ::lEndTrack        := .F.
      ::lDividerDblclick := .F.
      ::lTracking        := .F.
      ::nVisibleItems    := ::CountPerPage()

   ELSEIF nNotify == HDN_ENDTRACK
      // The user has finished dragging a column divider but the new width is not set yet
      IF HB_IsBlock( ::bAfterColSize )
         // HDITEM_cxy() gets the user's selected width from lParam
         nNewWidth := Eval( ::bAfterColSize, nColumn, HDITEM_cxy( lParam ) )
         IF HB_IsNumeric( nNewWidth ) .and. nNewWidth >= 0
            // Set_HDITEM_cxy() sets the Returned width into lParam
            Set_HDITEM_cxy( lParam, nNewWidth )
         ENDIF
      ENDIF

      // Set HDN_ENDTRACK flag
      ::lEndTrack := .T.

   ELSEIF nNotify == HDN_TRACK
      // A column divider is been dragged under Win7 without manifest
      ::lTracking := .T.

   ELSEIF nNotify == HDN_DIVIDERDBLCLICK
      IF HB_IsLogical( ::AllowChangeSize ) .AND. ! ::AllowChangeSize
         // Prevent column autofit

         RETURN 1
      ENDIF

      IF HB_IsBlock( ::bBeforeAutofit )
         lGo := Eval( ::bBeforeAutofit, nColumn )
         IF HB_IsLogical( lGo ) .and. ! lGo
            // Prevent column autofit

            RETURN 1
         ENDIF
      ENDIF

      /*
      Notification sequence for XP and Win7 with/without manifest:
      when the user doubleclicks a header separator
      HDN_BEGINTRACK
      HDN_ENDTRACK
      HDN_ITEMCHANGING
      HDN_ITEMCHANGED
      NM_RELEASEDCAPTURE
      HDN_DIVIDERDBLCLICK
      HDN_ITEMCHANGING
      HDN_ITEMCHANGED
      */

      // Set HDN_DIVIDERDBLCLICK flag
      ::lDividerDblclick := .T.

   ELSEIF nNotify == HDN_ITEMCHANGING
      IF ::lBeginTrack .AND. ! ::lEndTrack
         // A column divider is been dragged under XP or Win7 with manifest
         ::lTracking := .T.
      ENDIF

   ELSEIF nNotify == HDN_ITEMCHANGED
      IF ::lDividerDblclick
         ::lDividerDblclick := .F.
         // Do default processing (needed to properly update header)
         nResul := ExecOldWndProc( ::hWnd, WM_NOTIFY, wParam, lParam )

         // Ensure column is visible
         aRect := ListView_GetSubitemRect( ::hWnd, 0, nColumn - 1 )     // top, left, width, height
         IF aRect[ 2 ] < 0
            ListView_Scroll( ::hWnd, aRect[ 2 ], 0 )
         ENDIF

         // Force the repaint of the last row in case the horizontal scrollbar became hidden
         IF ::nVisibleItems # ::CountPerPage()
            ::Refresh()
         ENDIF

         // Repaint the grid
         RedrawWindow( ::ContainerhWnd )

         // Update column's width in array
         _OOHG_GridArrayWidths( ::hWnd, ::aWidths )

         //Prevent default processing

         RETURN nResul
      ENDIF

   ELSEIF nNotify == NM_RELEASEDCAPTURE
      IF ::lTracking
         ::lTracking := .F.
         // Forces the repaint of the last row in case the horizontal scrollbar became hidden
         IF ::nVisibleItems # ::CountPerPage()
            ::Refresh()
         ENDIF

         // Repaint the grid
         RedrawWindow( ::ContainerhWnd )

         // Update column's width in array
         _OOHG_GridArrayWidths( ::hWnd, ::aWidths )
      ENDIF

   ELSEIF nNotify == NM_RCLICK
      IF HB_IsBlock( ::bHeadRClick )
         nColumn := Header_HitTest( SendMessage( ::hWnd, LVM_GETHEADER, 0, 0 ) )
         Eval( ::bHeadRClick, nColumn, Self )
      ENDIF
      // Prevent propagation to ::Events_Notify()

      RETURN 1

   ENDIF

   RETURN NIL

METHOD Events_Enter() CLASS TGrid

   IF ! ::lNestedEdit
      ::lNestedEdit := .T.
      ::cText := ""
      IF ! ::AllowEdit
         ::DoEvent( ::OnEnter, "ENTER" )
      ELSEIF ::FullMove
         ::EditGrid()
      ELSEIF ::InPlace
         ::EditAllCells()
      ELSE
         ::EditItem()
      ENDIF
      ::lNestedEdit := .F.
   ENDIF

   RETURN Self

METHOD Events_Notify( wParam, lParam ) CLASS TGrid

   LOCAL nNotify := GetNotifyCode( lParam )
   LOCAL lvc, _ThisQueryTemp, nvkey, uValue, lGo, aItem

   IF nNotify == NM_CUSTOMDRAW

      RETURN TGrid_Notify_CustomDraw( Self, lParam, .F., , , ::lCheckBoxes, ::lFocusRect, ::lNoGrid, ::lPLM )

   ELSEIF nNotify == LVN_KEYDOWN
      IF GetGridvKeyAsChar( lParam ) == 0
         ::cText := ""
      ENDIF

      nvKey := GetGridvKey( lParam )

      IF nvkey == VK_DOWN
         IF ::FirstSelectedItem == ::ItemCount
            ::AppendItem()

            RETURN NIL
         ENDIF
      ELSEIF nvkey == VK_SPACE .AND. ::lCheckBoxes
         // detect item
         uValue := ::FirstSelectedItem
         IF uValue > 0
            // change check mark
            ::CheckItem( uValue, ! ::CheckItem( uValue ) )
            // skip default action

            RETURN 1
         ENDIF
      ELSEIF nvKey == VK_DELETE .AND. ::AllowDelete
         // detect item
         uValue := ::FirstSelectedItem
         IF uValue > 0
            IF ValType( ::bDelWhen ) == "B"
               lGo := _OOHG_EVAL( ::bDelWhen )
            ELSE
               lGo := .t.
            ENDIF

            IF lGo
               IF ::lNoDelMsg .OR. MsgYesNo( _OOHG_Messages(4, 1), _OOHG_Messages(4, 3) )
                  aItem := ::Item( uValue )
                  ::DeleteItem( uValue )
                  ::Value := Min( uValue, ::ItemCount )
                  ::DoEvent( ::OnDelete, "DELETE", { aItem } )
               ENDIF
            ELSEIF ! Empty( ::DelMsg )
               MsgExclamation( ::DelMsg, _OOHG_Messages(4, 3) )
            ENDIF
         ENDIF
      ELSEIF nvKey == VK_A .AND. GetKeyFlagState() == MOD_ALT
         IF ::lAppendOnAltA
            ::AppendItem()

            RETURN NIL
         ENDIF
      ENDIF

   ELSEIF nNotify == LVN_GETDISPINFO

      // Grid OnQueryData ............................

      IF HB_IsBlock( ::OnDispInfo )

         _PushEventInfo()
         _OOHG_ThisForm := ::Parent
         _OOHG_ThisType := 'C'
         _OOHG_ThisControl := Self
         _ThisQueryTemp  := GetGridDispInfoIndex( lParam )
         _OOHG_ThisQueryRowIndex  := _ThisQueryTemp[ 1 ]
         _OOHG_ThisQueryColIndex  := _ThisQueryTemp[ 2 ]
         ::DoEvent( ::OnDispInfo, "DISPINFO" )
         IF HB_IsNumeric( _OOHG_ThisQueryData )
            SetGridQueryImage ( lParam, _OOHG_ThisQueryData )
         ELSEIF ValType( _OOHG_ThisQueryData ) $ "CM"
            SetGridQueryData ( lParam, _OOHG_ThisQueryData )
         ENDIF
         _OOHG_ThisQueryRowIndex  := 0
         _OOHG_ThisQueryColIndex  := 0
         _OOHG_ThisQueryData := ""
         _PopEventInfo()
      ENDIF

   ELSEIF nNotify == LVN_ITEMCHANGED
      IF GetGridOldState( lParam ) == 0 .AND. GetGridNewState( lParam ) != 0
         IF ::bPosition # -2 .AND. ::bPosition # 9
            ::DoChange()
         ENDIF

         RETURN NIL
      ENDIF

   ELSEIF nNotify == LVN_COLUMNCLICK
      lvc := GetGridColumn( lParam ) + 1
      IF HB_IsBlock( ::aHeadClick[ lvc ] )
         _SetThisCellInfo( ::hWnd, 0, lvc )
         ::DoEvent( ::aHeadClick[ lvc ], "HEADCLICK", { lvc } )
         _ClearThisCellInfo()

         RETURN NIL
      ENDIF

   ELSEIF nNotify == LVN_ENDSCROLL
      // There is a bug in ListView under XP that causes the gridlines to be
      // incorrectly scrolled when the left button is clicked to scroll.
      // This is supposedly documented at KB 813791.
      RedrawWindow( ::hWnd )

   ELSEIF nNotify == NM_CLICK
      IF ::lCheckBoxes
         // detect item
         uValue := ListView_HitOnCheckBox( ::hWnd, GetCursorRow() - GetWindowRow( ::hWnd ), GetCursorCol() - GetWindowCol( ::hWnd ) )
      ELSE
         uValue := 0
      ENDIF

      IF ::bPosition == -2 .OR. ::bPosition == 9
         ::nDelayedClick := { ::FirstSelectedItem, 0, uValue, Nil }
         IF ::nEditRow > 0
            ListView_SetCursel( ::hWnd, ::nEditRow )
         ELSE
            ListView_ClearCursel( ::hWnd )
         ENDIF
      ELSE
         IF HB_IsBlock( ::OnClick )
            IF ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. uValue <= 0
               IF ! ::NestedClick
                  ::NestedClick := ! _OOHG_NestedSameEvent()
                  ::DoEventMouseCoords( ::OnClick, "CLICK" )
                  ::NestedClick := .F.
               ENDIF
            ENDIF
         ENDIF

         IF uValue > 0
            // change check mark
            ::CheckItem( uValue, ! ::CheckItem( uValue ) )
         ELSEIF uValue < 0
            // select item
            ::SetControlValue( ListView_ItemActivate( lParam )[ 1 ] )
         ENDIF
      ENDIF

      // skip default action

      RETURN 1

   ELSEIF nNotify == NM_RCLICK
      IF ::lCheckBoxes
         // detect item
         uValue := ListView_HitOnCheckBox( ::hWnd, GetCursorRow() - GetWindowRow( ::hWnd ), GetCursorCol() - GetWindowCol( ::hWnd ) )
      ELSE
         uValue := 0
      ENDIF

      IF ::bPosition == -2 .OR. ::bPosition == 9
         ::nDelayedClick := { ::FirstSelectedItem, 0, uValue, _GetGridCellData( Self, ListView_ItemActivate( lParam ) ) }
         IF ::nEditRow > 0
            ListView_SetCursel( ::hWnd, ::nEditRow )
         ELSE
            ListView_ClearCursel( ::hWnd )
         ENDIF
      ELSE
         IF HB_IsBlock( ::OnRClick )
            IF ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. uValue <= 0
               ::DoEventMouseCoords( ::OnRClick, "RCLICK" )
            ENDIF
         ENDIF

         IF uValue > 0
            // change check mark
            ::CheckItem( uValue, ! ::CheckItem( uValue ) )
         ELSEIF uValue < 0
            // select item
            ::SetControlValue( ListView_ItemActivate( lParam )[ 1 ] )
         ENDIF

         // fire context menu
         IF ::ContextMenu != Nil .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. uValue <= 0 )
            ::ContextMenu:Cargo := _GetGridCellData( Self, ListView_ItemActivate( lParam ) )
            ::ContextMenu:Activate()
         ENDIF
      ENDIF

      // skip default action

      RETURN 1

   ENDIF

   RETURN ::Super:Events_Notify( wParam, lParam )

METHOD AddItem( aRow, uForeColor, uBackColor ) CLASS TGrid

   LOCAL aText

   IF Len( ::aHeaders ) != Len( aRow )
      MsgOOHGError( "Grid.AddItem: Item size mismatch. Program terminated." )
   ENDIF

   aText := TGrid_SetArray( Self, aRow )
   ::SetItemColor( ::ItemCount + 1, uForeColor, uBackColor, aRow )

   RETURN AddListViewItems( ::hWnd, aText )

METHOD InsertItem( nItem, aRow, uForeColor, uBackColor ) CLASS TGrid

   LOCAL aText

   /*
   * This method may change the selected item's number if the new item is
   * inserted before or at the position of the selected item. For example:
   * ::FirstSelectedItem is 10, after inserting a new item at 5
   * ::FirestSelecteItem is 11. This is equivalent to ::Value == 10
   * before insertion and ::Value == 11 after.
   * This method does not trigger ::DoChange() because the selected item
   * is not changed.
   */

   IF Len( ::aHeaders ) != Len( aRow )
      MsgOOHGError( "Grid.InsertItem: Item size mismatch. Program terminated." )
   ENDIF

   aText := TGrid_SetArray( Self, aRow )
   nItem := ::InsertBlank( nItem )
   IF nItem > 0
      ::SetItemColor( nItem, uForeColor, uBackColor, aRow )
      ListViewSetItem( ::hWnd, aText, nItem )
   ENDIF

   RETURN nItem

METHOD InsertBlank( nItem ) CLASS TGrid

   LOCAL aGrid

   /*
   * This method may change the selected item's number if the new item is
   * inserted before or at the position of the selected item. For example:
   * ::FirstSelectedItem is 10, after inserting a new item at 5
   * ::FirstSelectedItem is 11. This is equivalent to ::Value == 10
   * before insertion and ::Value == 11 after.
   * This method does not trigger ::DoChange() because the selected item
   * is not changed.
   */

   aGrid := ::GridForeColor
   IF HB_IsArray( aGrid ) .AND. Len( aGrid ) >= nItem
      AAdd( aGrid, Nil )
      AIns( aGrid, nItem )
   ENDIF
   aGrid := ::GridBackColor
   IF HB_IsArray( aGrid ) .AND. Len( aGrid ) >= nItem
      AAdd( aGrid, Nil )
      AIns( aGrid, nItem )
   ENDIF

   nItem := InsertListViewItem( ::hWnd, Array( Len( ::aHeaders ) ), nItem )

   ::DoEvent( ::OnInsert, "INSERT", { nItem } )

   RETURN nItem

METHOD DeleteItem( nItem ) CLASS TGrid

   LOCAL lRet

   /*
   * This method may change the selected item's number if the deleted item
   * precedes the selected item. For example:
   * ::FirstSelectedItem is 10, after deleting item at 5 ::FirestSelecteItem is 9.
   * This is equivalent to ::Value == 10 before deletion and ::Value == 9 after.
   * In this case, this method does not trigger ::DoChange() because the selected
   * item is not changed.
   * If the deleted item is the selected item, ::FirstSelectedItem and ::Value
   * become 0. ::DoChange() is triggered only when ::lNoneUnsels is .T.
   */

   _OOHG_DeleteArrayItem( ::GridForeColor, nItem )
   _OOHG_DeleteArrayItem( ::GridBackColor, nItem )

   lRet := ListViewDeleteString( ::hWnd, nItem )

   IF ::lNoneUnsels .AND. ::FirstSelectedItem == 0
      ::DoChange()
   ENDIF

   RETURN lRet

METHOD Item( nItem, uValue, uForeColor, uBackColor ) CLASS TGrid

   LOCAL nColumn, aTemp, oEditControl

   IF PCount() > 1
      aTemp := TGrid_SetArray( Self, uValue )
      ::SetItemColor( nItem, uForeColor, uBackColor, uValue )
      ListViewSetItem( ::hWnd, aTemp, nItem )
   ENDIF
   uValue := ListViewGetItem( ::hWnd, nItem, Len( ::aHeaders ) )
   IF ::FixControls()
      FOR nColumn := 1 To Len( uValue )
         oEditControl := ::aEditControls[ nColumn ]
         IF HB_IsObject( oEditControl )
            IF oEditControl:Type == "TGRIDCONTROLIMAGEDATA"
               // when the column has images, ListViewGetItem Returns only the image's index number
               uValue[ nColumn ] := { ::CellCaption( nItem, nColumn ), ::CellImage( nItem, nColumn ) }
            ENDIF
            uValue[ nColumn ] := oEditControl:Str2Val( uValue[ nColumn ] )
         ENDIF
      NEXT
   ELSE
      ::aEditControls := Array( Len( uValue ) )
      IF HB_IsArray( ::EditControls )
         FOR nColumn := 1 To Len( uValue )
            oEditControl := GetEditControlFromArray( Nil, ::EditControls, nColumn, Self )
            ::aEditControls[ nColumn ] := oEditControl
            IF HB_IsObject( oEditControl )
               IF oEditControl:Type == "TGRIDCONTROLIMAGEDATA"
                  // when the column has images, ListViewGetItem Returns only the image's index number
                  uValue[ nColumn ] := { ::CellCaption( nItem, nColumn ), ::CellImage( nItem, nColumn ) }
               ENDIF
               uValue[ nColumn ] := oEditControl:Str2Val( uValue[ nColumn ] )
            ENDIF
         NEXT
      ENDIF
   ENDIF

   RETURN uValue

FUNCTION TGrid_SetArray( Self, uValue )

   LOCAL aTemp, nColumn, xValue, oEditControl

   aTemp := Array( Len( uValue ) )
   IF ::FixControls()
      FOR nColumn := 1 To Len( uValue )
         xValue := uValue[ nColumn ]
         oEditControl := ::aEditControls[ nColumn ]
         IF HB_IsObject( oEditControl )
            aTemp[ nColumn ] := oEditControl:GridValue( xValue )
         ELSEIF ValType( ::Picture[ nColumn ] ) $ "CM"
            aTemp[ nColumn ] := Trim( Transform( xValue, ::Picture[ nColumn ] ) )
         ELSE
            aTemp[ nColumn ] := xValue
         ENDIF
      NEXT
   ELSE
      ::aEditControls := Array( Len( uValue ) )
      FOR nColumn := 1 To Len( uValue )
         xValue := uValue[ nColumn ]
         oEditControl := GetEditControlFromArray( Nil, ::EditControls, nColumn, Self )
         ::aEditControls[ nColumn ] := oEditControl
         IF HB_IsObject( oEditControl )
            aTemp[ nColumn ] := oEditControl:GridValue( xValue )
         ELSEIF ValType( ::Picture[ nColumn ] ) $ "CM"
            aTemp[ nColumn ] := Trim( Transform( xValue, ::Picture[ nColumn ] ) )
         ELSE
            aTemp[ nColumn ] := xValue
         ENDIF
      NEXT
   ENDIF

   RETURN aTemp

METHOD SetItemColor( nItem, uForeColor, uBackColor, uExtra, lSetThisCellInfo ) CLASS TGrid

   LOCAL nWidth

   nWidth := Len( ::aHeaders )
   IF ! HB_IsArray( uExtra )
      uExtra := Array( nWidth )
   ELSEIF Len( uExtra ) < nWidth
      ASize( uExtra, nWidth )
   ENDIF
   ::GridForeColor := TGrid_CreateColorArray( ::GridForeColor, nItem, uForeColor, ::DynamicForeColor, nWidth, uExtra, ::hWnd, lSetThisCellInfo )
   ::GridBackColor := TGrid_CreateColorArray( ::GridBackColor, nItem, uBackColor, ::DynamicBackColor, nWidth, uExtra, ::hWnd, lSetThisCellInfo )

   RETURN Self

STATIC FUNCTION TGrid_CreateColorArray( aGrid, nItem, uColor, uDynamicColor, nWidth, uExtra, hWnd, lSetThisCellInfo )

   LOCAL aTemp, nLen

   IF ! ValType( uColor ) $ "ANB" .AND. ValType( uDynamicColor ) $ "ANB"
      uColor := uDynamicColor
   ENDIF
   IF ValType( uColor ) $ "ANB"
      IF HB_IsArray( aGrid )
         IF Len( aGrid ) < nItem
            ASize( aGrid, nItem )
         ENDIF
      ELSE
         aGrid := Array( nItem )
      ENDIF
      aTemp := Array( nWidth )
      IF HB_IsArray( uColor ) .AND. Len( uColor ) < nWidth
         nLen := Len( uColor )
         uColor := AClone( uColor )
         IF ValType( uDynamicColor ) $ "NB"
            ASize( uColor, nWidth )
            AFill( uColor, uDynamicColor, nLen + 1 )
         ELSEIF HB_IsArray( uDynamicColor ) .AND. Len( uDynamicColor ) > nLen
            ASize( uColor, Min( nWidth, Len( uDynamicColor ) ) )
            AEval( uColor, { |x,i| uColor[ i ] := uDynamicColor[ i ], x }, nLen + 1 )
         ENDIF
      ENDIF
      IF HB_IsLogical( lSetThisCellInfo ) .AND. ! lSetThisCellInfo
         // Set lSetThisCellInfo to .F. to avoid endless loop when calling this function inside the ON QUERYDATA block.
         AEval( aTemp, { |x,i| aTemp[ i ] := _OOHG_GetArrayItem( uColor, i, nItem, uExtra ), x } )
      ELSE
         AEval( aTemp, { |x,i| _SetThisCellInfo( hWnd, nItem, i, uExtra[ i ] ), aTemp[ i ] := _OOHG_GetArrayItem( uColor, i, nItem, uExtra ), x } )
         _ClearThisCellInfo()
      ENDIF
      aGrid[ nItem ] := aTemp
   ENDIF

   RETURN aGrid

METHOD Justify( uPar1, uPar2, uPar3 ) CLASS TGrid

   LOCAL uRet, aNew, i, nLen

   /*
   * Expected params:
   *   For multiple columns change:
   *      uPar1 -> array of BROWSE_JTFY_LEFT, BROWSE_JTFY_RIGHT or BROWSE_JTFY_CENTER.
   *               Note that invalid items are not changed.
   *      uPar2 -> .T. to force the control's redraw, defaults to .F.
   *      uPar3 -> not needed, it's ignored.
   *   For single column change:
   *      uPar1 -> numeric >= 1 and <= Len( ::aHeaders ).
   *      uPar2 -> BROWSE_JTFY_LEFT, BROWSE_JTFY_RIGHT OR BROWSE_JTFY_CENTER.
   *      uPar3 -> .T. to force the control's redraw, defaults to .F.
   *   For single column retrieve:
   *      uPar1 -> numeric >= 1 and <= Len( ::aHeaders ).
   *      uPar2 -> ommited.
   *      uPar3 -> not needed, it's ignored.
   *   For multiple columns retrieve:
   *      None.
   * Return value:
   *   For multiple columns change:
   *      A copy of the resulting ::aJust property or a copy of the
   *      current ::aJust property if no change was made.
   *   For single column change:
   *      uPar2 if it was accepted by the control or column's current
   *      justification if it wasn't.
   *   For single column retrieve:
   *      uPar1's current justification.
   *   For multiple columns retrieve:
   *      A copy of the current ::aJust property.
   *   When uPar1 is not array nor a numeric:
   *      A copy of the current ::aJust property.
   *   When uPar1 is not a valid number:
   *      Nil.
   *   When uPar1 is a valid number and uPar2 is not a valid value:
   *      uPar1's current justification.
   */

   IF HB_IsArray( uPar1 )
      aNew := aClone( uPar1 )
      nLen := Len( ::aHeaders )
      ASize( aNew, nLen )

      FOR i := 1 to nLen
         IF HB_IsNumeric( aNew[i] )
            uRet := SetGridColumnJustify( ::hWnd, i, aNew[i] )
            IF uRet != ::aJust[ i ]
               ::aJust[ i ] := uRet
            ENDIF
         ENDIF
      NEXT i

      uRet := aClone( ::aJust )
      IF HB_IsLogical( uPar2 ) .AND. uPar2
         RedrawWindow( ::hWnd )
      ENDIF
   ELSEIF ! HB_IsNumeric( uPar1 )
      uRet := aClone( ::aJust )
   ELSEIF uPar1 < 1 .OR. uPar1 > Len( ::aHeaders )
      uRet := Nil
   ELSEIF ! HB_IsNumeric( uPar2 )
      uRet := ::aJust[ uPar1 ]
   ELSE
      uRet := SetGridColumnJustify( ::hWnd, uPar1, uPar2 )
      IF uRet != ::aJust[ uPar1 ]
         ::aJust[ uPar1 ] := uRet
         IF HB_IsLogical( uPar3 ) .AND. uPar3
            RedrawWindow( ::hWnd )
         ENDIF
      ENDIF
   ENDIF

   RETURN uRet

METHOD Header( nColumn, uValue ) CLASS TGrid

   IF ValType( uValue ) $ "CM"
      ::aHeaders[ nColumn ] := uValue
      SetGridColumnHeader( ::hWnd, nColumn, uValue )
   ENDIF

   RETURN ::aHeaders[ nColumn ]

METHOD HeaderImage( nColumn, nImg ) CLASS TGrid

   IF HB_IsNumeric( nImg ) .AND. nImg >= 0 .AND. nImg # ::aHeaderImage[ nColumn ]
      ::aHeaderImage[ nColumn ] := nImg

      IF nImg == 0
         RemoveGridColumnImage( ::hWnd, nColumn )
      ELSEIF ValidHandler( ::HeaderImageList )
         SetGridColumnImage( ::hWnd, nColumn, nImg, .F. )
      ENDIF
   ENDIF

   RETURN ::aHeaderImage[ nColumn ]

METHOD HeaderImageAlign( nColumn, nPlace ) CLASS TGrid

   IF ::aHeaderImage[ nColumn ] != 0
      IF HB_IsNumeric( nPlace )
         IF nPlace == HEADER_IMG_AT_RIGHT
            ::aHeaderImageAlign[ nColumn ] := HEADER_IMG_AT_RIGHT

            IF ValidHandler( ::HeaderImageList )
               SetGridColumnImage( ::hWnd, nColumn, ::aHeaderImage[ nColumn ], .T. )
            ENDIF
         ELSE
            ::aHeaderImageAlign[ nColumn ] := HEADER_IMG_AT_LEFT

            IF ValidHandler( ::HeaderImageList )
               SetGridColumnImage( ::hWnd, nColumn, ::aHeaderImage[ nColumn ], .F. )
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   RETURN ::aHeaderImageAlign[ nColumn ]

METHOD HeaderSetFont( cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout, nFntAngle, nFntwidth ) CLASS TGrid

   LOCAL HeaderHandle

   IF ValidHandler( ::HeaderFontHandle )
      DeleteObject( ::HeaderFontHandle )
   ENDIF
   ASSIGN cFontName  VALUE cFontName  TYPE "CM" DEFAULT ""
   ASSIGN nFontSize  VALUE nFontSize  TYPE "N"  DEFAULT 0
   ASSIGN lBold      VALUE lBold      TYPE "L"  DEFAULT .F.
   ASSIGN lItalic    VALUE lItalic    TYPE "L"  DEFAULT .F.
   ASSIGN lUnderline VALUE lUnderline TYPE "L"  DEFAULT .F.
   ASSIGN lStrikeout VALUE lStrikeout TYPE "L"  DEFAULT .F.
   ASSIGN nFntAngle  VALUE nFntAngle  TYPE "N"  DEFAULT 0
   ASSIGN nFntWidth  VALUE nFntWidth  TYPE "N"  DEFAULT 0
   HeaderHandle := GetHeader( ::hWnd )
   IF ValidHandler( HeaderHandle )
      ::HeaderFontHandle := _SetFont( HeaderHandle, cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout, nFntAngle, nFntWidth )
   ENDIF

   RETURN Self

METHOD Release() CLASS TGrid

   IF ValidHandler( ::HeaderImageList )
      ImageList_Destroy( ::HeaderImageList )
      ::HeaderImageList := 0
   ENDIF

   IF ValidHandler( ::HeaderFontHandle)
      DeleteObject( ::HeaderFontHandle )
      ::HeaderFontHandle := 0
   ENDIF

   RETURN ::Super:Release()

METHOD SetRangeColor( uForeColor, uBackColor, nTop, nLeft, nBottom, nRight ) CLASS TGrid

   LOCAL nAux, nLong := ::ItemCount

   IF ! HB_IsNumeric( nBottom )
      nBottom := nTop
   ENDIF
   IF ! HB_IsNumeric( nRight )
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

   RETURN Self

STATIC FUNCTION TGrid_FillColorArea( aGrid, uColor, nTop, nLeft, nBottom, nRight, hWnd )

   LOCAL nAux

   IF ValType( uColor ) $ "ANB"
      IF ! HB_IsArray( aGrid )
         aGrid := Array( nBottom )
      ELSEIF Len( aGrid ) < nBottom
         ASize( aGrid, nBottom )
      ENDIF
      FOR nAux := nTop To nBottom
         IF ! HB_IsArray( aGrid[ nAux ] )
            aGrid[ nAux ] := Array( nRight )
         ELSEIF Len( aGrid[ nAux ] ) < nRight
            ASize( aGrid[ nAux ], nRight )
         ENDIF
         AEval( aGrid[ nAux ], { |x,i| _SetThisCellInfo( hWnd, nAux, i ), aGrid[ nAux ][ i ] := _OOHG_GetArrayItem( uColor, i, nAux ), x }, nLeft, ( nRight - nLeft + 1 ) )
         _ClearThisCellInfo()
      NEXT
   ENDIF

   RETURN aGrid

METHOD ColumnWidth( nColumn, nWidth ) CLASS TGrid

   LOCAL i

   IF HB_IsNumeric( nColumn ) .AND. nColumn >= 1 .AND. nColumn <= Len( ::aHeaders )
      IF HB_IsNumeric( nWidth ) .AND. nWidth >= 0
         IF nWidth == 0
            IF AScan( ::aHiddenCols, nColumn ) == 0
               AAdd( ::aHiddenCols, nColumn )
            ENDIF
         ELSE
            i := AScan( ::aHiddenCols, nColumn )
            IF i # 0
               _OOHG_DeleteArrayItem( ::aHiddenCols, i )
            ENDIF
         ENDIF
         nWidth := ListView_SetColumnWidth( ::hWnd, nColumn - 1, nWidth )
      ELSE
         nWidth := ListView_GetColumnWidth( ::hWnd, nColumn - 1 )
      ENDIF
      ::aWidths[ nColumn ] := nWidth
   ELSE
      nWidth := 0
   ENDIF

   RETURN nWidth

METHOD ColumnAutoFit( nColumn ) CLASS TGrid

   LOCAL nWidth

   IF HB_IsNumeric( nColumn ) .AND. nColumn >= 1 .AND. nColumn <= Len( ::aHeaders )
      nWidth := ListView_SetColumnWidth( ::hWnd, nColumn - 1, LVSCW_AUTOSIZE )
      IF nColumn == ::FirstColInOrder
         nWidth := nWidth + 6
         nWidth := ListView_SetColumnWidth( ::hWnd, nColumn - 1, nWidth )
      ENDIF
      ::aWidths[ nColumn ] := nWidth
   ELSE
      nWidth := 0
   ENDIF

   RETURN nWidth

METHOD ColumnAutoFitH( nColumn ) CLASS TGrid

   LOCAL nWidth

   IF HB_IsNumeric( nColumn ) .AND. nColumn >= 1 .AND. nColumn <= Len( ::aHeaders )
      nWidth := ListView_SetColumnWidth( ::hWnd, nColumn - 1, LVSCW_AUTOSIZE_USEHEADER )
      IF nColumn == ::FirstColInOrder
         nWidth := nWidth + 6
         nWidth := ListView_SetColumnWidth( ::hWnd, nColumn - 1, nWidth )
      ENDIF
      ::aWidths[ nColumn ] := nWidth
   ELSE
      nWidth := 0
   ENDIF

   RETURN nWidth

METHOD ColumnsBetterAutoFit() CLASS TGrid

   LOCAL nColumn

   FOR nColumn := 1 To Len( ::aHeaders )
      ::ColumnBetterAutoFit ( nColumn )
   NEXT nColumn

   RETURN Self

METHOD ColumnsAutoFit() CLASS TGrid

   LOCAL nColumn, nWidth

   FOR nColumn := 1 To Len( ::aHeaders )
      nWidth := ListView_SetColumnWidth( ::hWnd, nColumn - 1, LVSCW_AUTOSIZE )
      ::aWidths[ nColumn ] := nWidth
   NEXT

   RETURN nWidth

METHOD ColumnsAutoFitH() CLASS TGrid

   LOCAL nColumn, nWidth

   FOR nColumn := 1 To Len( ::aHeaders )
      nWidth := ListView_SetColumnWidth( ::hWnd, nColumn - 1, LVSCW_AUTOSIZE_USEHEADER )
      ::aWidths[ nColumn ] := nWidth
   NEXT

   RETURN nWidth

METHOD SortColumn( nColumn, lDescending ) CLASS TGrid

   RETURN ListView_SortItemsEx( ::hWnd, nColumn, lDescending )

METHOD SortItems( bBlock ) CLASS TGrid

   LOCAL lRet := .F.

   IF HB_IsBlock( bBlock )
      ::bCompareItems := bBlock
      lRet := ListView_SortItemsEx_User( Self )
   ENDIF

   RETURN lRet

METHOD CompareItems( nItem1, nItem2 ) CLASS TGrid

   // Must Return -1 if nItem1 precedes nItem2 or 1 if nItem1 follows nItem2

   RETURN Eval( ::bCompareItems, Self, nItem1, nItem2 )

METHOD ItemHeight() CLASS TGrid

   LOCAL aCellRect

   IF ::ItemCount == 0

      RETURN 0
   ENDIF
   aCellRect := ListView_GetSubitemRect( ::hWnd, 0, 0 )

   RETURN aCellRect[ 4 ]

METHOD ScrollToLeft CLASS TGrid

   ListView_Scroll( ::hWnd, - _OOHG_GridArrayWidths( ::hWnd, ::aWidths ), 0 )

   RETURN Self

METHOD ScrollToRight CLASS TGrid

   ListView_Scroll( ::hWnd, _OOHG_GridArrayWidths( ::hWnd, ::aWidths ), 0 )

   RETURN Self

METHOD ScrollToCol( nCol ) CLASS TGrid

   LOCAL r

   r := ListView_GetSubitemRect( ::hWnd, 0, nCol - 1 ) // top, left, width, height
   IF r[ 2 ] # 0
      ListView_Scroll( ::hWnd, r[ 2 ], 0 )
   ENDIF

   RETURN Self

METHOD ScrollToPrior CLASS TGrid

   LOCAL nColF, nColT, nColN

   nColF := ::FirstVisibleColumn( .F. )
   IF nColF > 0
      nColT := ::FirstVisibleColumn( .T. )
      IF nColT # nColF
         ::ScrollToCol( nColF )
      ELSE
         nColN := ::PriorColInOrder( nColF )
         IF nColN # 0
            ::ScrollToCol( nColN )
         ENDIF
      ENDIF
   ENDIF

   RETURN Self

METHOD ScrollToNext CLASS TGrid

   LOCAL nColF, nColN

   nColF := ::FirstVisibleColumn( .F. )
   IF nColF > 0
      nColN := ::NextColInOrder( nColF )
      IF nColN # 0
         ::ScrollToCol( nColN )
      ENDIF
   ENDIF

   RETURN Self

METHOD PriorColInOrder( nCol ) CLASS TGrid

   LOCAL nRet, aColumnOrder, i

   nRet := 0
   aColumnOrder := ::ColumnOrder
   i := AScan( aColumnOrder, nCol )
   DO WHILE i > 1
      IF AScan( ::aHiddenCols, aColumnOrder[ i - 1 ] ) == 0
         nRet := aColumnOrder[ i - 1 ]
         EXIT
      ENDIF
      i --
   ENDDO

   RETURN nRet

METHOD NextColInOrder( nCol ) CLASS TGrid

   LOCAL nRet, aColumnOrder, i

   nRet := 0
   aColumnOrder := ::ColumnOrder
   i := AScan( aColumnOrder, nCol )
   DO WHILE i < Len( aColumnOrder )
      IF AScan( ::aHiddenCols, aColumnOrder[ i + 1 ] ) == 0
         nRet := aColumnOrder[ i + 1 ]
         EXIT
      ENDIF
      i ++
   ENDDO

   RETURN nRet

METHOD FirstColInOrder() CLASS TGrid

   LOCAL nRet, aColumnOrder, i

   nRet := 0
   aColumnOrder := ::ColumnOrder
   FOR i := 1 To Len( aColumnOrder )
      IF AScan( ::aHiddenCols, aColumnOrder[ i ] ) == 0
         nRet := aColumnOrder[ i ]
         EXIT
      ENDIF
   NEXT i

   RETURN nRet

METHOD LastColInOrder() CLASS TGrid

   LOCAL nRet, aColumnOrder, i

   nRet := 0
   aColumnOrder := ::ColumnOrder
   FOR i := Len( aColumnOrder ) To 1 Step -1
      IF AScan( ::aHiddenCols, aColumnOrder[ i ] ) == 0
         nRet := aColumnOrder[ i ]
         EXIT
      ENDIF
   NEXT i

   RETURN nRet

METHOD AdjustResize( nDivh, nDivw, lSelfOnly ) CLASS TGrid

   LOCAL nCols, i

   nCols := ::ColumnCount
   FOR i := 1 To nCols
      ::ColumnWidth( i, ::ColumnWidth( i ) * nDivw )
   NEXT i

   RETURN ::Super:AdjustResize( nDivh, nDivw, lSelfOnly )

CLASS TGridMulti FROM TGrid

   DATA lDeleteAll                INIT .F.
   DATA Type                      INIT "MULTIGRID" READONLY

   METHOD Define
   METHOD DoChange
   METHOD Events_Notify
   METHOD SetControlValue         BLOCK { |Self, nRow, nCol| Empty( nCol ), ::Value := { nRow } }
   METHOD Value                   SETGET

   ENDCLASS

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
      lFocusRect, lPLM, lFixedCols, abortedit, click, lFixedWidths, ;
      bBeforeColMove, bAfterColMove, bBeforeColSize, bAfterColSize, ;
      bBeforeAutofit, lLikeExcel, lButtons, AllowDelete, onDelete, ;
      bDelWhen, DelMsg, lNoDelMsg, AllowAppend, onappend, lNoModal, ;
      lFixedCtrls, bHeadRClick, lClickOnCheckbox, lRClickOnCheckbox, ;
      lExtDbl, lSilent, lAltA, lNoShowAlways, lNone, lCBE, onrclick, ;
      oninsert, editend, lAtFirst, bbeforeditcell, bEditCellValue, klc ) CLASS TGridMulti

   LOCAL nStyle := 0

   HB_SYMBOL_UNUSED( lNone )

   ::Define2( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, aRows, ;
      value, fontname, fontsize, tooltip, aHeadClick, nogrid, ;
      aImage, aJust, break, HelpId, bold, italic, underline, ;
      strikeout, ownerdata, itemcount, editable, backcolor, ;
      fontcolor, dynamicbackcolor, dynamicforecolor, aPicture, lRtl, ;
      nStyle, inplace, editcontrols, readonly, valid, validmessages, ;
      aWhenFields, lDisabled, lNoTabStop, lInvisible, lHasHeaders, ;
      aHeaderImage, aHeaderImageAlign, FullMove, aSelectedColors, ;
      aEditKeys, lCheckBoxes, lDblBffr, lFocusRect, lPLM, ;
      lFixedCols, lFixedWidths, lLikeExcel, lButtons, AllowDelete, ;
      DelMsg, lNoDelMsg, AllowAppend, lNoModal, lFixedCtrls, ;
      lClickOnCheckbox, lRClickOnCheckbox, lExtDbl, lSilent, lAltA, ;
      lNoShowAlways, .T., lCBE, lAtFirst, klc )

   // Must be set after control is initialized
   ::Define4( change, dblclick, gotfocus, lostfocus, ondispinfo, editcell, ;
      onenter, oncheck, abortedit, click, bBeforeColMove, bAfterColMove, ;
      bBeforeColSize, bAfterColSize, bBeforeAutofit, onDelete, ;
      bDelWhen, onappend, bHeadRClick, onrclick, oninsert, editend, ;
      bbeforeditcell, bEditCellValue )

   RETURN Self

METHOD Value( uValue ) CLASS TGridMulti

   LOCAL aRet, aNew

   IF HB_IsArray( uValue )
      aRet := ListViewGetMultiSel( ::hWnd )
      aNew := aSort( AClone( uValue ), Nil, Nil, {|x, y| x < y } )
      IF ! aEqual( aNew, aRet )
         ListViewSetMultiSel( ::hWnd, uValue )
         IF Len( uValue ) > 0
            ListView_EnsureVisible( ::hWnd, uValue[ 1 ] )
         ENDIF
         aRet := ListViewGetMultiSel( ::hWnd )
      ENDIF
   ELSE
      aRet := ListViewGetMultiSel( ::hWnd )
   ENDIF

   RETURN aRet

FUNCTION aEqual( array1, array2 )

   LOCAL lRet, nLen, i, cType

   IF HB_IsArray( array1 ) .AND. HB_IsArray( array2 )
      nLen := LEN( array1 )
      IF LEN( array2 ) == nLen
         lRet := .T.
         FOR i := 1 to nLen
            cType := VALTYPE( array1[ i ] )
            IF ! VALTYPE( array2[ i ] ) == cType
               lRet := .F.
               EXIT
            ELSEIF cType == "A" .AND. ! ArraysAreEqual( array1[ i ], array2[ i ] )
               lRet := .F.
               EXIT
            ELSEIF ! array1[ i ] == array2[ i ]
               lRet := .F.
               EXIT
            ENDIF
         NEXT i
      ELSE
         lRet := .F.
      ENDIF
   ELSE
      MsgOOHGError( 'ArraysAreEqual: Argument is not an array !!!' )
   ENDIF

   RETURN lRet

METHOD DoChange() CLASS TGridMulti

   LOCAL xValue, cType, cOldType

   xValue   := ::Value
   cType    := ValType( xValue )
   cOldType := ValType( ::xOldValue )
   cType    := If( cType == "M", "C", cType )
   cOldType := If( cOldType == "M", "C", cOldType )
   IF ( cOldType == "U" .OR. ! cType == cOldType .OR. ;
         ( HB_IsArray( xValue ) .AND. ! HB_IsArray( ::xOldValue ) ) .OR. ;
         ( ! HB_IsArray( xValue ) .AND. HB_IsArray( ::xOldValue ) ) .OR. ;
         ! aEqual( xValue, ::xOldValue ) )
      ::xOldValue := xValue
      ::DoEvent( ::OnChange, "CHANGE" )
   ENDIF

   RETURN Self

METHOD Events_Notify( wParam, lParam ) CLASS TGridMulti

   LOCAL nvkey, uValue, lGo, aSel, aItems, i, nNotify := GetNotifyCode( lParam )

   IF nNotify == LVN_KEYDOWN
      IF GetGridvKeyAsChar( lParam ) == 0
         ::cText := ""
      ENDIF

      nvKey := GetGridvKey( lParam )

      IF nvKey == VK_DELETE .AND. ::AllowDelete
         uValue := ::FirstSelectedItem
         IF uValue > 0
            IF ValType( ::bDelWhen ) == "B"
               lGo := _OOHG_EVAL( ::bDelWhen )
            ELSE
               lGo := .t.
            ENDIF

            IF lGo
               IF ::lNoDelMsg .OR. MsgYesNo( _OOHG_Messages(4, 1), _OOHG_Messages(4, 3) )
                  IF ::lDeleteAll
                     aItems := {}
                     aSel := ::Value
                     FOR i := Len( aSel ) To 1 Step -1
                        ASize( aItems, Len( aItems ) + 1 )
                        AIns( aItems, 1 )
                        aItems[ 1 ] := ::Item( aSel[ i ] )
                        ::DeleteItem( aSel[ i ] )
                     NEXT i
                  ELSE
                     aItems := ::Item( uValue )
                     ::DeleteItem( uValue )
                  ENDIF
                  ::Value := { Min( uValue, ::ItemCount ) }
                  ::DoEvent( ::OnDelete, "DELETE", { aItems } )
               ENDIF
            ELSEIF ! Empty( ::DelMsg )
               MsgExclamation( ::DelMsg, _OOHG_Messages(4, 3) )
            ENDIF
         ENDIF

         RETURN NIL
      ENDIF

   ENDIF

   RETURN ::Super:Events_Notify( wParam, lParam )

CLASS TGridByCell FROM TGrid

   DATA Type                      INIT "GRIDBYCELL" READONLY

   METHOD AddColumn
   METHOD Define
   METHOD DeleteAllItems
   METHOD DeleteColumn
   METHOD DeleteItem
   METHOD DoChange
   METHOD Down
   METHOD EditCell
   METHOD EditCell2
   METHOD EditGrid
   METHOD End
   METHOD Events
   METHOD Events_Notify
   METHOD GoBottom
   METHOD GoTop
   METHOD Home
   METHOD InsertBlank
   METHOD Left
   METHOD MoveToFirstCol
   METHOD MoveToFirstVisibleCol
   METHOD MoveToLastCol
   METHOD MoveToLastVisibleCol
   METHOD PageDown
   METHOD PageUp
   METHOD Right
   METHOD SetControlValue         BLOCK { |Self, nRow, nCol| If( HB_IsNil( nCol ), nCol := 1, ), ::Value := { nRow, nCol } }
   METHOD SetSelectedColors
   METHOD Up
   METHOD Value                   SETGET

   ENDCLASS

METHOD Define( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
      aRows, value, fontname, fontsize, tooltip, change, dblclick, ;
      aHeadClick, gotfocus, lostfocus, nogrid, aImage, aJust, ;
      break, HelpId, bold, italic, underline, strikeout, ownerdata, ;
      ondispinfo, itemcount, editable, backcolor, fontcolor, ;
      dynamicbackcolor, dynamicforecolor, aPicture, lRtl, InPlace, ;
      editcontrols, readonly, valid, validmessages, editcell, ;
      aWhenFields, lDisabled, lNoTabStop, lInvisible, lHasHeaders, ;
      onenter, aHeaderImage, aHeaderImageAlign, FullMove, ;
      aSelectedColors, aEditKeys, lCheckBoxes, oncheck, lDblBffr, ;
      lFocusRect, lPLM, lFixedCols, abortedit, click, lFixedWidths, ;
      bBeforeColMove, bAfterColMove, bBeforeColSize, bAfterColSize, ;
      bBeforeAutofit, lLikeExcel, lButtons, AllowDelete, onDelete, ;
      bDelWhen, DelMsg, lNoDelMsg, AllowAppend, onappend, lNoModal, ;
      lFixedCtrls, bHeadRClick, lClickOnCheckbox, lRClickOnCheckbox, ;
      lExtDbl, lSilent, lAltA, lNoShowAlways, lNone, lCBE, onrclick, ;
      oninsert, editend, lAtFirst, bbeforeditcell, bEditCellValue, klc ) CLASS TGridByCell

   ASSIGN lFocusRect VALUE lFocusRect TYPE "L" DEFAULT .F.
   ASSIGN lNone      VALUE lNone      TYPE "L" DEFAULT .T.
   ASSIGN lCBE       VALUE lCBE       TYPE "L" DEFAULT .T.

   ::Define2( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, aRows, ;
      value, fontname, fontsize, tooltip, aHeadClick, nogrid, ;
      aImage, aJust, break, HelpId, bold, italic, underline, ;
      strikeout, ownerdata, itemcount, editable, backcolor, ;
      fontcolor, dynamicbackcolor, dynamicforecolor, aPicture, lRtl, ;
      LVS_SINGLESEL, inplace, editcontrols, readonly, valid, validmessages, ;
      aWhenFields, lDisabled, lNoTabStop, lInvisible, lHasHeaders, ;
      aHeaderImage, aHeaderImageAlign, FullMove, aSelectedColors, ;
      aEditKeys, lCheckBoxes, lDblBffr, lFocusRect, lPLM, ;
      lFixedCols, lFixedWidths, lLikeExcel, lButtons, AllowDelete, ;
      DelMsg, lNoDelMsg, AllowAppend, lNoModal, lFixedCtrls, ;
      lClickOnCheckbox, lRClickOnCheckbox, lExtDbl, lSilent, lAltA, ;
      lNoShowAlways, .T., lCBE, lAtFirst, klc )

   // Search the current column
   ::SearchCol := -1

   // Must be set after control is initialized
   ::Define4( change, dblclick, gotfocus, lostfocus, ondispinfo, editcell, ;
      onenter, oncheck, abortedit, click, bBeforeColMove, bAfterColMove, ;
      bBeforeColSize, bAfterColSize, bBeforeAutofit, onDelete, ;
      bDelWhen, onappend, bHeadRClick, onrclick, oninsert, editend, ;
      bbeforeditcell, bEditCellValue )

   RETURN Self

METHOD AddColumn( nColIndex, cCaption, nWidth, nJustify, uForeColor, uBackColor, ;
      lNoDelete, uPicture, uEditControl, uHeadClick, uValid, ;
      uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign, ;
      uReadOnly ) CLASS TGridByCell

   nColIndex := ::Super:AddColumn( nColIndex, cCaption, nWidth, nJustify, uForeColor, uBackColor, ;
      lNoDelete, uPicture, uEditControl, uHeadClick, uValid, ;
      uValidMessage, uWhen, nHeaderImage, nHeaderImageAlign, ;
      uReadOnly )

   IF nColIndex <= ::nColPos
      ::Value := { ::nRowPos, ::nColPos + 1 }
   ENDIF

   RETURN nColIndex

METHOD SetSelectedColors( aSelectedColors, lRedraw ) CLASS TGridByCell

   LOCAL i, aColors[ 8 ]

   IF HB_IsArray( aSelectedColors )
      aSelectedColors := AClone( aSelectedColors )
      ASize( aSelectedColors, 8 )

      // For text of selected cell when grid has the focus
      IF ! ValType( aSelectedColors[ 1 ] ) $ "ANB"
         aSelectedColors[ 1 ] := GetSysColor( COLOR_HIGHLIGHTTEXT )
      ENDIF
      // For background of selected cell when grid has the focus
      IF ! ValType( aSelectedColors[ 2 ] ) $ "ANB"
         aSelectedColors[ 2 ] := GetSysColor( COLOR_HIGHLIGHT )
      ENDIF
      // For text of selected cell when grid doesn't has the focus
      IF ! ValType( aSelectedColors[ 3 ] ) $ "ANB"
         aSelectedColors[ 3 ] := GetSysColor( COLOR_WINDOWTEXT )
      ENDIF
      // For background of selected cell when grid doesn't has the focus
      IF ! ValType( aSelectedColors[ 4 ] ) $ "ANB"
         aSelectedColors[ 4 ] := GetSysColor( COLOR_3DFACE )
      ENDIF

      // For text of other cells in the selected row when grid has the focus
      IF ! ValType( aSelectedColors[ 5 ] ) $ "ANB"
         aSelectedColors[ 5 ] := -1                    // defaults to DYNAMICFORECOLOR, or FONTCOLOR or COLOR_WINDOWTEXT
      ENDIF
      // For background of other cells in the selected row when grid has the focus
      IF ! ValType( aSelectedColors[ 6 ] ) $ "ANB"
         aSelectedColors[ 6 ] := -1                    // defaults to DYNAMICBACKCOLOR, or BACKCOLOR or COLOR_WINDOW
      ENDIF
      // For text of other cells in the selected row when grid doesn't has the focus
      IF ! ValType( aSelectedColors[ 7 ] ) $ "ANB"
         aSelectedColors[ 7 ] := -1                    // defaults to DYNAMICFORECOLOR, or FONTCOLOR or COLOR_WINDOWTEXT
      ENDIF
      // For background of other cells in the selected row when grid doesn't has the focus
      IF ! ValType( aSelectedColors[ 8 ] ) $ "ANB"
         aSelectedColors[ 8 ] := -1                    // defaults to DYNAMICBACKCOLOR, or BACKCOLOR or COLOR_WINDOW
      ENDIF

      ::aSelectedColors := aSelectedColors

      FOR i := 1 To 8
         aColors[ i ] := _OOHG_GetArrayItem( aSelectedColors, i )
      NEXT i

      ::GridSelectedColors := aColors

      IF lRedraw
         RedrawWindow( ::hWnd )
      ENDIF
   ELSE
      aSelectedColors := AClone( ::aSelectedColors )
   ENDIF

   RETURN aSelectedColors

METHOD DeleteAllItems() CLASS TGridByCell

   ::nRowPos := 0
   ::nColPos := 0

   RETURN ::Super:DeleteAllItems()

METHOD Value( uValue ) CLASS TGridByCell

   LOCAL r, nClientWidth, nScrollWidth, lRowChanged, lColChanged

   IF HB_IsArray( uValue ) .AND. Len( uValue ) > 1 .AND. HB_IsNumeric( uValue[ 1 ] ) .AND. HB_IsNumeric( uValue[ 2 ] )
      IF uValue[ 1 ] < 1 .OR. uValue[ 1 ] > ::ItemCount .OR. uValue[ 2 ] < 1 .OR. uValue[ 2 ] > Len( ::aHeaders )
         ::nRowPos := 0
         ::nColPos := 0
         ListView_ClearCursel( ::hWnd, 0 )
      ELSE
         lRowChanged := ( ::FirstSelectedItem # uValue[ 1 ] )
         lColChanged := ( ::nColPos # uValue[ 2 ] )
         ::nRowPos := uValue[ 1 ]
         ::nColPos := uValue[ 2 ]

         // Ensure that the column is inside the client area
         IF lColChanged
            r := { 0, 0, 0, 0 }                                                              // left, top, right, bottom
            GetClientRect( ::hWnd, r )
            nClientWidth := r[ 3 ] - r[ 1 ]
            r := ListView_GetSubitemRect( ::hWnd, ::nRowPos - 1, ::nColPos - 1 )             // top, left, width, height
            IF ::lScrollBarUsesClientArea .AND. ::ItemCount >  ::CountPerPage
               nScrollWidth := GetVScrollBarWidth()
            ELSE
               nScrollWidth := 0
            ENDIF
            IF r[ 2 ] + r[ 3 ] + nScrollWidth > nClientWidth
               // Move right side into client area
               ListView_Scroll( ::hWnd, ( r[ 2 ] + r[ 3 ] + nScrollWidth - nClientWidth ), 0 )
               // Get new position
               r := ListView_GetSubitemRect( ::hWnd, ::nRowPos - 1, ::nColPos - 1 )          // top, left, width, height
            ENDIF
            IF r[ 2 ] < 0
               // Move left side into client area
               ListView_Scroll( ::hWnd, r[ 2 ], 0 )
            ENDIF
         ENDIF

         // Ensure cell is visible
         IF lRowChanged
            IF ::lShowItemAtTop
               ListView_SetCursel( ::hWnd, ::ItemCount )
               IF ! ListView_IsItemVisible( ::hWnd, ::ItemCount )
                  ListView_EnsureVisible( ::hWnd, ::ItemCount )
               ENDIF
            ENDIF
            ListView_SetCursel( ::hWnd, ::nRowPos )
         ENDIF
         IF ! ListView_IsItemVisible( ::hWnd, ::nRowPos )
            ListView_EnsureVisible( ::hWnd, ::nRowPos )
         ENDIF
         ListView_RedrawItems( ::hWnd, ::nRowPos, ::ItemCount )
      ENDIF
      ::DoChange()
   ELSE
      ::nRowPos := ::FirstSelectedItem
      IF ::nRowPos == 0
         ::nColPos := 0
      ENDIF
   ENDIF

   RETURN { ::nRowPos, ::nColPos }

METHOD EditGrid( nRow, nCol, lAppend, lOneRow, lChange ) CLASS TGridByCell

   LOCAL lRet, lSomethingEdited

   HB_SYMBOL_UNUSED( lChange )

   IF ::FirstVisibleColumn == 0

      RETURN .F.
   ENDIF
   IF ! HB_IsNumeric( nRow )
      nRow := Max( ::FirstSelectedItem, 1 )
   ENDIF
   IF ! HB_IsNumeric( nCol )
      IF ::nColPos >= 1
         nCol := ::nColPos
      ELSE
         nCol := ::FirstColInOrder
      ENDIF
   ENDIF
   IF nCol < 1 .OR. nCol > Len( ::aHeaders )

      RETURN .F.
   ENDIF

   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.

   IF ::lAppendMode
      // Before calling ::EditGrid an empty item was added at ::ItemCount
   ELSEIF lAppend
      // Add new item, ignore ::AllowAppend
      ::lAppendMode := .T.
      ::InsertBlank( ::ItemCount + 1 )
      ::Value := { ::ItemCount, nCol }
   ELSE
      // Edit item nRow
      IF ! HB_IsNumeric( nRow )
         nRow := Max( ::FirstSelectedItem, 1 )
      ENDIF
      IF nRow < 1 .OR. nRow > ::ItemCount

         RETURN .F.
      ENDIF
      ::Value := { nRow, nCol }
   ENDIF

   lSomethingEdited := .F.

   DO WHILE ::nRowPos >= 1 .AND. ::nRowPos <= ::ItemCount .AND. ::nColPos >= 1 .AND. ::nColPos <= Len( ::aHeaders )
      _OOHG_ThisItemCellValue := ::Cell( ::nRowPos, ::nColPos )

      IF ::IsColumnReadOnly( ::nColPos, ::nRowPos )
         // Read only column
      ELSEIF ! ::IsColumnWhen( ::nColPos, ::nRowPos )
         // WHEN returned .F.
      ELSEIF AScan( ::aHiddenCols, ::nColPos ) > 0
         // Hidden column
      ELSE
         ::lCalledFromClass := .T.
         lRet := ::Super:EditCell( ::nRowPos, ::nColPos, , , , , , .F. )
         ::lCalledFromClass := .F.

         IF ::lAppendMode
            ::lAppendMode := .F.
            IF lRet
               ::DoEvent( ::OnAppend, "APPEND", { ::nRowPos } )
               lSomethingEdited := .T.
            ELSE
               EXIT
            ENDIF
         ELSEIF lRet
            lSomethingEdited := .T.
         ELSE
            EXIT
         ENDIF
      ENDIF

      /*
      * ::OnEditCell may change ::nRowPos and/or ::nColPos using ::Up(), ::PageUp(), ::Home(),
      * ::End(), ::Down(), ::PageDown(), ::GoTop(), ::GoBottom(), ::Left() and/or ::Right()
      */

      // ::bPosition is set by TGridControl()
      IF ::bPosition == 1                            // UP
         IF ::nRowPos < 1 .OR. ::nRowPos > ::ItemCount + 1 .OR. ::nColPos < 1 .OR. ::nColPos > Len( ::aHeaders )
            EXIT
         ELSEIF HB_IsLogical( lOneRow ) .AND. lOneRow
            EXIT
         ELSEIF ::nRowPos > 1
            ::Value := { ::nRowPos - 1, ::nColPos }
         ELSEIF ::FullMove
            ::Value := { ::ItemCount, ::nColPos }
         ELSE
            EXIT
         ENDIF
      ELSEIF ::bPosition == 2                        // RIGHT
         IF ::nRowPos < 1 .OR. ::nRowPos > ::ItemCount .OR. ::nColPos < 1 .OR. ::nColPos > Len( ::aHeaders )
            EXIT
         ELSE
            nCol := ::NextColInOrder( ::nColPos )
            IF nCol == 0
               IF HB_IsLogical( lOneRow ) .AND. lOneRow
                  EXIT
               ELSEIF ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove
                  EXIT
               ENDIF
               nCol := ::FirstColInOrder
               IF nCol == 0
                  EXIT
               ELSEIF ::nRowPos < ::ItemCount
                  ::Value := { ::nRowPos + 1, nCol }
               ELSEIF ::AllowAppend .OR. lAppend
                  ::lAppendMode := .T.
                  ::InsertBlank( ::ItemCount + 1 )
                  ::Value := { ::ItemCount, nCol }
               ELSEIF ::FullMove
                  ::Value := { 1, nCol }
               ENDIF
            ELSE
               ::Value := { ::nRowPos, nCol }
            ENDIF
         ENDIF
      ELSEIF ::bPosition == 3                        // LEFT
         IF ::nRowPos < 1 .OR. ::nRowPos > ::ItemCount .OR. ::nColPos < 1 .OR. ::nColPos > Len( ::aHeaders )
            EXIT
         ELSE
            nCol := ::PriorColInOrder( ::nColPos )
            IF nCol == 0
               IF HB_IsLogical( lOneRow ) .AND. lOneRow
                  EXIT
               ELSEIF ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove
                  EXIT
               ENDIF
               nCol := ::LastColInOrder
               IF nCol == 0
                  EXIT
               ELSEIF ::nRowPos > 1
                  ::Value := { ::nRowPos - 1, nCol }
               ELSEIF ::FullMove
                  ::Value := { ::ItemCount, nCol }
               ENDIF
            ELSE
               ::Value := { ::nRowPos, nCol }
            ENDIF
         ENDIF
      ELSEIF ::bPosition == 4                        // HOME
         IF ::nRowPos < 1 .OR. ::nRowPos > ::ItemCount .OR. ::nColPos < 1 .OR. ::nColPos > Len( ::aHeaders )
            EXIT
         ELSEIF HB_IsLogical( lOneRow ) .AND. lOneRow
            EXIT
         ELSE
            ::Value := { 1, ::FirstColInOrder }
            IF ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove
               EXIT
            ENDIF
         ENDIF
      ELSEIF ::bPosition == 5                        // END
         IF ::nRowPos < 1 .OR. ::nRowPos > ::ItemCount .OR. ::nColPos < 1 .OR. ::nColPos > Len( ::aHeaders )
            EXIT
         ELSEIF HB_IsLogical( lOneRow ) .AND. lOneRow
            EXIT
         ELSE
            ::Value := { ::ItemCount, ::LastColInOrder }
            IF ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove
               EXIT
            ENDIF
         ENDIF
      ELSEIF ::bPosition == 6                        // DOWN
         IF ::nRowPos < 1 .OR. ::nRowPos > ::ItemCount .OR. ::nColPos < 1 .OR. ::nColPos > Len( ::aHeaders )
            EXIT
         ELSEIF HB_IsLogical( lOneRow ) .AND. lOneRow
            EXIT
         ELSEIF ::nRowPos < ::ItemCount
            ::Value := { ::nRowPos + 1, ::nColPos }
         ELSEIF ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove
            EXIT
         ELSEIF ::AllowAppend .OR. lAppend
            ::lAppendMode := .T.
            ::InsertBlank( ::ItemCount + 1 )
            ::Value := { ::ItemCount, ::nColPos }
         ELSEIF ::FullMove
            ::Value := { 1, ::nColPos }
         ENDIF
      ELSEIF ::bPosition == 7                        // PRIOR
         IF ::nRowPos < 1 .OR. ::nRowPos > ::ItemCount .OR. ::nColPos < 1 .OR. ::nColPos > Len( ::aHeaders )
            EXIT
         ELSEIF HB_IsLogical( lOneRow ) .AND. lOneRow
            EXIT
         ELSEIF ::nRowPos > ::CountPerPage
            ::Value := { ::nRowPos - ::CountPerPage, ::nColPos }
         ELSE
            ::Value := { 1, ::nColPos }
         ENDIF
         IF ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove
            EXIT
         ENDIF
      ELSEIF ::bPosition == 8                        // NEXT
         IF ::nRowPos < 1 .OR. ::nRowPos > ::ItemCount .OR. ::nColPos < 1 .OR. ::nColPos > Len( ::aHeaders )
            EXIT
         ELSEIF HB_IsLogical( lOneRow ) .AND. lOneRow
            EXIT
         ELSEIF ::nRowPos < ::ItemCount - ::CountPerPage
            ::Value := { ::nRowPos + ::CountPerPage, ::nColPos }
         ELSE
            ::Value := { ::ItemCount, ::nColPos }
         ENDIF
         IF ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove
            EXIT
         ENDIF
      ELSEIF ::bPosition == 9                        // MOUSE EXIT
         // Edition window lost focus, resume clic processing and process delayed click
         ::bPosition := 0
         IF ::nDelayedClick[ 1 ] > 0
            // A click message was delayed
            IF ::nDelayedClick[ 3 ] <= 0
               ::Value := { ::nDelayedClick[ 1 ], ::nDelayedClick[ 2 ] }
            ENDIF

            IF HB_IsNil( ::nDelayedClick[ 4 ] )
               IF HB_IsBlock( ::OnClick )
                  IF ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                     IF ! ::NestedClick
                        ::NestedClick := ! _OOHG_NestedSameEvent()
                        ::DoEventMouseCoords( ::OnClick, "CLICK" )
                        ::NestedClick := .F.
                     ENDIF
                  ENDIF
               ENDIF
            ELSE
               IF HB_IsBlock( ::OnRClick )
                  IF ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                     ::DoEventMouseCoords( ::OnRClick, "RCLICK" )
                  ENDIF
               ENDIF
            ENDIF

            IF ::nDelayedClick[ 3 ] > 0
               // change check mark
               ::CheckItem( ::nDelayedClick[ 3 ], ! ::CheckItem( ::nDelayedClick[ 3 ] ) )
            ENDIF

            // fire context menu
            IF ! HB_IsNil( ::nDelayedClick[ 4 ] ) .AND. ::ContextMenu != Nil .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0 )
               ::ContextMenu:Cargo := ::nDelayedClick[ 4 ]
               ::ContextMenu:Activate()
            ENDIF
         ENDIF
         EXIT
      ELSE                                           // OK
         IF ::nRowPos < 1 .OR. ::nRowPos > ::ItemCount .OR. ::nColPos < 1 .OR. ::nColPos > Len( ::aHeaders )
            EXIT
         ELSE
            nCol := ::NextColInOrder( ::nColPos )
            IF nCol == 0
               IF HB_IsLogical( lOneRow ) .AND. lOneRow
                  EXIT
               ELSEIF ! HB_IsLogical( lOneRow ) .AND. ! ::FullMove
                  EXIT
               ENDIF
               nCol := ::FirstColInOrder
               IF nCol == 0
                  EXIT
               ELSEIF ::nRowPos < ::ItemCount
                  ::Value := { ::nRowPos + 1, nCol }
               ELSEIF ::AllowAppend .OR. lAppend
                  ::lAppendMode := .T.
                  ::InsertBlank( ::ItemCount + 1 )
                  ::Value := { ::ItemCount, nCol }
               ELSEIF ::FullMove
                  ::Value := { 1, nCol }
               ENDIF
            ELSE
               ::Value := { ::nRowPos, nCol }
            ENDIF
         ENDIF
      ENDIF
   ENDDO

   RETURN lSomethingEdited

METHOD Right( lAppend ) CLASS TGridByCell

   LOCAL nCol, lRet := .F.

   IF ::nRowPos < 1 .OR. ::nRowPos > ::ItemCount .OR. ::nColPos < 1 .OR. ::nColPos > Len( ::aHeaders )
      IF ::ItemCount > 0
         nCol := ::FirstColInOrder
         IF nCol == 0
            ::Value := { 0, 0 }
         ELSE
            ::Value := { 1, nCol }
         ENDIF
      ELSE
         ::Value := { 0, 0 }
      ENDIF
      lRet := .T.
   ELSE
      nCol := ::NextColInOrder( ::nColPos )
      IF nCol == 0
         IF ::nRowPos < ::ItemCount
            IF ::FullMove
               nCol := ::FirstColInOrder
               IF nCol # 0
                  ::Value := { ::nRowPos + 1, nCol }
                  lRet := .T.
               ENDIF
            ENDIF
         ELSE
            ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT ::AllowAppend
            IF lAppend
               lRet := ::AppendItem()
            ELSEIF ::FullMove
               ::Value := { 1, ::FirstColInOrder }
               lRet := .T.
            ENDIF
         ENDIF
      ELSE
         ::Value := { ::nRowPos, nCol }
         lRet := .T.
      ENDIF
   ENDIF

   RETURN lRet

METHOD Left() CLASS TGridByCell

   LOCAL nCol, lRet := .F.

   IF ::nRowPos < 1 .OR. ::nRowPos > ::ItemCount .OR. ::nColPos < 1 .OR. ::nColPos > Len( ::aHeaders )
      IF ::ItemCount > 0
         nCol := ::FirstColInOrder
         IF nCol == 0
            ::Value := { 0, 0 }
         ELSE
            ::Value := { 1, nCol }
         ENDIF
      ELSE
         ::Value := { 0, 0 }
      ENDIF
      lRet := .T.
   ELSE
      nCol := ::PriorColInOrder( ::nColPos )
      IF nCol == 0
         IF ::nRowPos > 1
            IF ::FullMove
               nCol := ::LastColInOrder
               IF nCol # 0
                  ::Value := { ::nRowPos - 1, nCol }
                  lRet := .T.
               ENDIF
            ENDIF
         ELSEIF ::FullMove
            ::Value := { ::ItemCount, ::LastColInOrder }
         ENDIF
      ELSE
         ::Value := { ::nRowPos, nCol }
         lRet := .T.
      ENDIF
   ENDIF

   RETURN lRet

METHOD Up( lLast ) CLASS TGridByCell

   LOCAL nCol, lRet := .F.

   IF ::nRowPos < 1 .OR. ::nRowPos > ::ItemCount .OR. ::nColPos < 1 .OR. ::nColPos > Len( ::aHeaders )
      IF ::ItemCount > 0
         nCol := ::FirstColInOrder
         IF nCol == 0
            ::Value := { 0, 0 }
         ELSE
            ::Value := { 1, nCol }
         ENDIF
      ELSE
         ::Value := { 0, 0 }
      ENDIF
      lRet := .T.
   ELSEIF ::nRowPos > 1
      IF HB_IsLogical( lLast ) .AND. lLast
         nCol := ::LastColInOrder
         IF nCol # 0
            ::Value := { ::nRowPos - 1, nCol }
            lRet := .T.
         ENDIF
      ELSE
         ::Value := { ::nRowPos - 1, ::nColPos }
         lRet := .T.
      ENDIF
   ELSEIF ::FullMove
      ::Value := { ::ItemCount, ::nColPos }
      lRet := .T.
   ENDIF

   RETURN lRet

METHOD Down( lAppend ) CLASS TGridByCell

   LOCAL nCol, lRet := .F.

   IF ::nRowPos < 1 .OR. ::nRowPos > ::ItemCount .OR. ::nColPos < 1 .OR. ::nColPos > Len( ::aHeaders )
      IF ::ItemCount > 0
         nCol := ::FirstColInOrder
         IF nCol == 0
            ::Value := { 0, 0 }
         ELSE
            ::Value := { 1, nCol }
         ENDIF
      ELSE
         ::Value := { 0, 0 }
      ENDIF
      lRet := .T.
   ELSEIF ::nRowPos < ::ItemCount
      ::Value := { ::nRowPos + 1, ::nColPos }
      lRet := .T.
   ELSE
      ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT ::AllowAppend
      IF lAppend
         lRet := ::AppendItem()
      ELSEIF ::FullMove
         ::Value := { ::ItemCount, ::nColPos }
         lRet := .T.
      ENDIF
   ENDIF

   RETURN lRet

METHOD PageUp() CLASS TGridByCell

   LOCAL nCol, lRet

   IF ::nRowPos < 1 .OR. ::nRowPos > ::ItemCount .OR. ::nColPos < 1 .OR. ::nColPos > Len( ::aHeaders )
      IF ::ItemCount > 0
         nCol := ::FirstColInOrder
         IF nCol == 0
            ::Value := { 0, 0 }
         ELSE
            ::Value := { 1, nCol }
         ENDIF
      ELSE
         ::Value := { 0, 0 }
      ENDIF
      lRet := .T.
   ELSEIF ::nRowPos > ::CountPerPage
      ::Value := { ::nRowPos - ::CountPerPage, ::nColPos }
      lRet := .T.
   ELSEIF ::nRowPos # 1
      ::Value := { 1, ::nColPos }
      lRet := .T.
   ELSE
      lRet := .F.
   ENDIF

   RETURN lRet

METHOD PageDown() CLASS TGridByCell

   LOCAL nCol, lRet

   IF ::nRowPos < 1 .OR. ::nRowPos > ::ItemCount .OR. ::nColPos < 1 .OR. ::nColPos > Len( ::aHeaders )
      IF ::ItemCount > 0
         nCol := ::FirstColInOrder
         IF nCol == 0
            ::Value := { 0, 0 }
         ELSE
            ::Value := { 1, nCol }
         ENDIF
      ELSE
         ::Value := { 0, 0 }
      ENDIF
      lRet := .T.
   ELSEIF ::nRowPos < ::ItemCount - ::CountPerPage
      ::lShowItemAtTop := .T.
      ::Value := { ::nRowPos + ::CountPerPage, ::nColPos }
      ::lShowItemAtTop := .F.
      lRet := .T.
   ELSEIF ::nRowPos # ::ItemCount
      ::Value := { ::ItemCount, ::nColPos }
      lRet := .T.
   ELSE
      lRet := .F.
   ENDIF

   RETURN lRet

METHOD Home() CLASS TGridByCell

   LOCAL lDone

   IF ::lKeysLikeClipper
      lDone := ::MoveToFirstVisibleCol()
   ELSE
      lDone := ::GoTop( ::FirstColInOrder )
   ENDIF

   RETURN lDone

METHOD GoTop( nCol ) CLASS TGridByCell

   LOCAL lRet := .F.

   IF ::ItemCount > 0
      IF ! HB_IsNumeric( nCol )
         IF ::lKeysLikeClipper
            nCol := ::nColPos
         ELSE
            nCol := ::FirstColInOrder
         ENDIF
      ENDIF
      IF nCol # 0
         IF ::nRowPos # 1 .OR. ::nColPos # nCol
            ::Value := { 1, nCol }
            lRet := .T.
         ENDIF
      ENDIF
   ENDIF

   RETURN lRet

METHOD End() CLASS TGridByCell

   LOCAL lDone

   IF ::lKeysLikeClipper
      lDone := ::MoveToLastVisibleCol()
   ELSE
      lDone := ::GoBottom( ::LastColInOrder )
   ENDIF

   RETURN lDone

METHOD GoBottom( nCol ) CLASS TGridByCell

   LOCAL lRet := .F.

   IF ::ItemCount > 0
      IF ! HB_IsNumeric( nCol )
         IF ::lKeysLikeClipper
            nCol := ::nColPos
         ELSE
            nCol := ::LastColInOrder
         ENDIF
      ENDIF
      IF nCol # 0
         IF ::nRowPos # ::ItemCount .OR. ::nColPos # nCol
            ::Value := { ::ItemCount, nCol }
            lRet := .T.
         ENDIF
      ENDIF
   ENDIF

   RETURN lRet

METHOD InsertBlank( nItem ) CLASS TGridByCell

   nItem := ::Super:InsertBlank( nItem )

   IF nItem > 0
      IF nItem <= ::nRowPos
         ::Value := { ::nRowPos + 1, ::nColPos }
      ENDIF
   ENDIF

   RETURN nItem

METHOD DeleteItem( nItem ) CLASS TGridByCell

   LOCAL lRet

   lRet := ::Super:DeleteItem( nItem )
   IF lRet
      IF nItem <= ::nRowPos
         ::Value := { ::nRowPos - 1, ::nColPos }
      ENDIF
   ENDIF

   RETURN lRet

METHOD DeleteColumn( nColIndex, lNoDelete ) CLASS TGridByCell

   nColIndex := ::Super:DeleteColumn( nColIndex, lNoDelete )
   IF nColIndex > 0
      IF nColIndex == ::nColPos
         ::Value := { 0, 0 }
      ELSEIF nColIndex < ::nColPos
         ::Value := { ::nRowPos, ::nColPos - 1 }
      ENDIF
   ENDIF

   RETURN nColIndex

METHOD EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, nOnFocusPos, lChange ) CLASS TGridByCell

   LOCAL lRet

   HB_SYMBOL_UNUSED( lChange )

   IF ::FirstVisibleColumn == 0

      RETURN .F.
   ENDIF
   IF ! HB_IsNumeric( nRow )
      nRow := Max( ::nRowPos, 1 )
   ENDIF
   IF ! HB_IsNumeric( nCol )
      IF ::nColPos >= 1
         nCol := ::nColPos
      ELSE
         nCol := ::FirstColInOrder
      ENDIF
   ENDIF
   IF nRow < 1 .OR. nRow > ::ItemCount .OR. nCol < 1 .OR. nCol > Len( ::aHeaders )

      RETURN .F.
   ENDIF
   IF AScan( ::aHiddenCols, nCol ) > 0

      RETURN .F.
   ENDIF

   ::Value := { nRow, nCol }

   ::lCalledFromClass := .T.
   lRet := ::Super:EditCell( ::nRowPos, ::nColPos, EditControl, uOldValue, uValue, cMemVar, nOnFocusPos, .F. )
   ::lCalledFromClass := .F.

   IF lRet
      // ::bPosition is set by TGridControl()
      IF ::bPosition == 1                            // UP
         ::Up()
      ELSEIF ::bPosition == 2                        // RIGHT
         ::Right( .F. )
      ELSEIF ::bPosition == 3                        // LEFT
         ::Left()
      ELSEIF ::bPosition == 4                        // HOME
         ::GoTop()
      ELSEIF ::bPosition == 5                        // END
         ::GoBottom( .F. )
      ELSEIF ::bPosition == 6                        // DOWN
         ::Down( .F. )
      ELSEIF ::bPosition == 7                        // PRIOR
         ::PageUp()
      ELSEIF ::bPosition == 8                        // NEXT
         ::PageDown( .F. )
      ELSEIF ::bPosition == 9                        // MOUSE EXIT
         // Edition window lost focus, resume clic processing and process delayed click
         ::bPosition := 0
         IF ::nDelayedClick[ 1 ] > 0
            // A click message was delayed
            IF ::nDelayedClick[ 3 ] <= 0
               ::Value := { ::nDelayedClick[ 1 ], ::nDelayedClick[ 2 ] }
            ENDIF

            IF HB_IsNil( ::nDelayedClick[ 4 ] )
               IF HB_IsBlock( ::OnClick )
                  IF ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                     IF ! ::NestedClick
                        ::NestedClick := ! _OOHG_NestedSameEvent()
                        ::DoEventMouseCoords( ::OnClick, "CLICK" )
                        ::NestedClick := .F.
                     ENDIF
                  ENDIF
               ENDIF
            ELSE
               IF HB_IsBlock( ::OnRClick )
                  IF ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0
                     ::DoEventMouseCoords( ::OnRClick, "RCLICK" )
                  ENDIF
               ENDIF
            ENDIF

            IF ::nDelayedClick[ 3 ] > 0
               // change check mark
               ::CheckItem( ::nDelayedClick[ 3 ], ! ::CheckItem( ::nDelayedClick[ 3 ] ) )
            ENDIF

            // fire context menu
            IF ! HB_IsNil( ::nDelayedClick[ 4 ] ) .AND. ::ContextMenu != Nil .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. ::nDelayedClick[ 3 ] <= 0 )
               ::ContextMenu:Cargo := ::nDelayedClick[ 4 ]
               ::ContextMenu:Activate()
            ENDIF
         ENDIF
      ELSE                                           // OK
         IF ::nRowPos >= 1 .AND. ::nRowPos <= ::ItemCount .AND. ::nColPos >= 1 .AND. ::nColPos <= Len( ::aHeaders )
            nCol := ::NextColInOrder( ::nColPos )
            IF nCol == 0
               IF ::FullMove
                  nCol := ::FirstColInOrder
                  IF nCol > 0
                     IF ::nRowPos < ::ItemCount
                        ::Value := { ::nRowPos + 1, nCol }
                     ELSE
                        ::Value := { 1, nCol }
                     ENDIF
                  ENDIF
               ENDIF
            ELSE
               ::Value := { ::nRowPos, nCol }
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   RETURN lRet

   // nRow, nCol and uValue may be passed by reference

METHOD EditCell2( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, nOnFocusPos ) CLASS TGridByCell

   IF ! HB_IsNumeric( nRow )
      nRow := Max( ::nRowPos, 1 )
   ENDIF
   IF ! HB_IsNumeric( nCol )
      IF ::nColPos >= 1
         nCol := ::nColPos
      ELSE
         nCol := ::FirstColInOrder
      ENDIF
   ENDIF

   RETURN ::Super:EditCell2( @nRow, @nCol, @EditControl, uOldValue, @uValue, cMemVar, nOnFocusPos )

METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TGridByCell

   LOCAL aCellData, nItem, i, nSearchCol, aPos

   IF nMsg == WM_LBUTTONDBLCLK
      IF ! ::lCheckBoxes .OR. ListView_HitOnCheckBox( hWnd, GetCursorRow() - GetWindowRow( hWnd ), GetCursorCol() - GetWindowCol( hWnd ) ) <= 0
         _PushEventInfo()
         _OOHG_ThisForm := ::Parent
         _OOHG_ThisType := 'C'
         _OOHG_ThisControl := Self

         // Identify item & subitem hitted
         aPos := Get_XY_LPARAM( lParam )
         aPos := ListView_HitTest( ::hWnd, aPos[ 1 ], aPos[ 2 ] )

         aCellData := _GetGridCellData( Self, aPos )
         _OOHG_ThisItemRowIndex   := aCellData[ 1 ]
         _OOHG_ThisItemColIndex   := aCellData[ 2 ]
         _OOHG_ThisItemCellRow    := aCellData[ 3 ]
         _OOHG_ThisItemCellCol    := aCellData[ 4 ]
         _OOHG_ThisItemCellWidth  := aCellData[ 5 ]
         _OOHG_ThisItemCellHeight := aCellData[ 6 ]
         _OOHG_ThisItemCellValue  := ::Cell( _OOHG_ThisItemRowIndex, _OOHG_ThisItemColIndex )

         IF ! ::AllowEdit .OR. _OOHG_ThisItemRowIndex < 1 .OR. _OOHG_ThisItemRowIndex > ::ItemCount .OR. _OOHG_ThisItemColIndex < 1 .OR. _OOHG_ThisItemColIndex > Len( ::aHeaders )
            IF HB_IsBlock( ::OnDblClick )
               ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
            ENDIF
         ELSEIF ::IsColumnReadOnly( _OOHG_ThisItemColIndex, _OOHG_ThisItemRowIndex )
            // Cell is readonly
            IF ::lExtendDblClick .and. HB_IsBlock( ::OnDblClick )
               ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
            ENDIF
         ELSEIF ! ::IsColumnWhen( _OOHG_ThisItemColIndex, _OOHG_ThisItemRowIndex )
            // WHEN returned .F.
            IF ::lExtendDblClick .and. HB_IsBlock( ::OnDblClick )
               ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
            ENDIF
         ELSEIF AScan( ::aHiddenCols, _OOHG_ThisItemColIndex ) > 0
            // Cell is in a hidden column
            IF ::lExtendDblClick .and. HB_IsBlock( ::OnDblClick )
               ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
            ENDIF
         ELSE
            ::EditGrid( _OOHG_ThisItemRowIndex, _OOHG_ThisItemColIndex )
         ENDIF

         _ClearThisCellInfo()
         _PopEventInfo()
      ENDIF

      RETURN 0

   ELSEIF nMsg == WM_CHAR
      IF ::AllowEdit .AND. ( ::lLikeExcel .OR. EditControlLikeExcel( Self, ::Value[ 2 ] ) )
         ::EditCell( , , , Chr( wParam ) )

         RETURN 0

      ELSE
         IF wParam < 32
            ::cText := ""

            RETURN 0
         ELSEIF Empty( ::cText )
            ::uIniTime := HB_MilliSeconds()
            ::cText := Upper( Chr( wParam ) )
         ELSEIF HB_MilliSeconds() > ::uIniTime + ::SearchLapse
            ::uIniTime := HB_MilliSeconds()
            ::cText := Upper( Chr( wParam ) )
         ELSE
            ::uIniTime := HB_MilliSeconds()
            ::cText += Upper( Chr( wParam ) )
         ENDIF

         IF ::SearchCol < 0
            // Current column
            nSearchCol := ::Value[ 2 ]
            IF nSearchCol < 1 .OR. nSearchCol > ::ColumnCount .OR. AScan( ::aHiddenCols, nSearchCol ) # 0

               RETURN 0
            ENDIF
         ELSEIF ::SearchCol == 0
            // Listview search
            nSearchCol := 0
         ELSEIF ::SearchCol > ::ColumnCount

            RETURN 0
         ELSEIF AScan( ::aHiddenCols, ::SearchCol ) # 0

            RETURN 0
         ELSE
            nSearchCol := ::SearchCol
         ENDIF

         IF nSearchCol >= 1
            nItem := 0

            FOR i := ::FirstSelectedItem + 1 To ::ItemCount
               IF Upper( Left( ::CellCaption( i, nSearchCol ), Len( ::cText ) ) ) == ::cText
                  nItem := i
                  EXIT
               ENDIF
            NEXT i

            IF nItem == 0 .AND. ::SearchWrap
               FOR i := 1 To ::FirstSelectedItem
                  IF Upper( Left( ::CellCaption( i, nSearchCol ), Len( ::cText ) ) ) == ::cText
                     nItem := i
                     EXIT
                  ENDIF
               NEXT i
            ENDIF
         ELSE
            nItem := ListView_FindItem( hWnd, ::FirstSelectedItem - 2, ::cText, ::SearchWrap )
            nSearchCol := 1
         ENDIF
         IF nItem > 0
            ::Value := { nItem, nSearchCol }
         ENDIF

         RETURN 0
      ENDIF

   ENDIF

   RETURN ::Super:Events( hWnd, nMsg, wParam, lParam )

FUNCTION EditControlLikeExcel( oGrid, nColumn )

   LOCAL oEditControl

   IF nColumn < 1

      RETURN .F.
   ENDIF
   IF oGrid:FixControls()
      oEditControl := oGrid:aEditControls[ nColumn ]
   ENDIF
   oEditControl := GetEditControlFromArray( oEditControl, oGrid:EditControls, nColumn, oGrid )

   RETURN HB_IsObject( oEditControl ) .AND. oEditControl:lLikeExcel

METHOD MoveToFirstCol CLASS TGridByCell

   LOCAL aBefore, nCol, aAfter, lDone := .F.

   aBefore := ::Value
   nCol := ::FirstColInOrder
   IF nCol # 0
      ::Value := { aBefore[ 1 ], nCol }
      aAfter := ::Value
      lDone := ( aAfter[ 1 ] # aBefore[ 1 ] .OR. aAfter[ 2 ] # aBefore[ 2 ] )
   ENDIF

   RETURN lDone

METHOD MoveToLastCol CLASS TGridByCell

   LOCAL aBefore, nCol, aAfter, lDone := .F.

   aBefore := ::Value
   nCol := ::LastColInOrder
   IF nCol # 0
      ::Value := { aBefore[ 1 ], nCol }
      aAfter := ::Value
      lDone := ( aAfter[ 1 ] # aBefore[ 1 ] .OR. aAfter[ 2 ] # aBefore[ 2 ] )
   ENDIF

   RETURN lDone

METHOD MoveToFirstVisibleCol CLASS TGridByCell

   LOCAL aBefore, nCol, aAfter, lDone := .F.

   aBefore := ::Value
   ::ScrollToPrior()
   nCol := ::FirstVisibleColumn
   IF nCol # 0
      ::Value := { aBefore[ 1 ], nCol }
      aAfter := ::Value
      lDone := ( aAfter[ 1 ] # aBefore[ 1 ] .OR. aAfter[ 2 ] # aBefore[ 2 ] )
   ENDIF

   RETURN lDone

METHOD MoveToLastVisibleCol CLASS TGridByCell

   LOCAL aBefore, nCol, aAfter, lDone := .F.

   aBefore := ::Value
   ::ScrollToPrior()
   nCol := ::LastVisibleColumn
   IF nCol # 0
      ::Value := { aBefore[ 1 ], nCol }
      aAfter := ::Value
      lDone := ( aAfter[ 1 ] # aBefore[ 1 ] .OR. aAfter[ 2 ] # aBefore[ 2 ] )
   ENDIF

   RETURN lDone

METHOD Events_Notify( wParam, lParam ) CLASS TGridByCell

   LOCAL nNotify := GetNotifyCode( lParam )
   LOCAL nvkey, lGo, aItem, nRow, nCol, uValue, aCellData

   IF nNotify == NM_CUSTOMDRAW

      RETURN TGrid_Notify_CustomDraw( Self, lParam, .T., ::nRowPos, ::nColPos, ::lCheckBoxes, ::lFocusRect, ::lNoGrid, ::lPLM )

   ELSEIF nNotify == LVN_KEYDOWN
      IF GetGridvKeyAsChar( lParam ) == 0
         ::cText := ""
      ENDIF

      nvKey := GetGridvKey( lParam )

      IF ::FirstVisibleColumn == 0
         // Do nothing
      ELSEIF nvkey == VK_DOWN
         IF GetKeyFlagState() == MOD_CONTROL
            IF ! ::lKeysLikeClipper
               ::Value := { ::ItemCount, ::nColPos }
            ENDIF
         ELSE
            ::Down()
         ENDIF
      ELSEIF nvkey == VK_UP
         IF GetKeyFlagState() == MOD_CONTROL
            IF ! ::lKeysLikeClipper
               ::Value := { 1, ::nColPos }
            ENDIF
         ELSE
            ::Up()
         ENDIF
      ELSEIF nvkey == VK_PRIOR
         IF ::lKeysLikeClipper .AND. GetKeyFlagState() == MOD_CONTROL
            ::GoTop()
         ELSE
            ::PageUp()
         ENDIF
      ELSEIF nvkey == VK_NEXT
         IF ::lKeysLikeClipper .AND. GetKeyFlagState() == MOD_CONTROL
            ::GoBottom()
         ELSE
            ::PageDown()
         ENDIF
      ELSEIF nvkey == VK_HOME
         IF ::lKeysLikeClipper
            IF GetKeyFlagState() == MOD_CONTROL
               ::MoveToFirstCol()
            ELSE
               ::MoveToFirstVisibleCol()
            ENDIF
         ELSE
            ::GoTop()
         ENDIF
      ELSEIF nvkey == VK_END
         IF ::lKeysLikeClipper
            IF GetKeyFlagState() == MOD_CONTROL
               ::MoveToLastCol()
            ELSE
               ::MoveToLastVisibleCol()
            ENDIF
         ELSE
            ::GoBottom()
         ENDIF
      ELSEIF nvkey == VK_LEFT
         IF GetKeyFlagState() == MOD_CONTROL
            IF ::lKeysLikeClipper
               ::PanToLeft()
            ELSE
               ::MoveToFirstCol()
            ENDIF
         ELSE
            ::Left()
         ENDIF
      ELSEIF nvkey == VK_RIGHT
         IF GetKeyFlagState() == MOD_CONTROL
            IF ::lKeysLikeClipper
               ::PanToRight()
            ELSE
               ::MoveToLastCol()
            ENDIF
         ELSE
            ::Right()
         ENDIF
      ELSEIF nvkey == VK_SPACE .AND. ::lCheckBoxes
         // detect item
         IF ::nRowPos > 0
            // change check mark
            ::CheckItem( ::nRowPos, ! ::CheckItem( ::nRowPos ) )
         ENDIF
      ELSEIF nvKey == VK_DELETE .AND. ::AllowDelete
         // detect item
         IF ::nRowPos > 0
            IF ValType( ::bDelWhen ) == "B"
               lGo := _OOHG_EVAL( ::bDelWhen )
            ELSE
               lGo := .t.
            ENDIF

            IF lGo
               IF ::lNoDelMsg .OR. MsgYesNo( _OOHG_Messages(4, 1), _OOHG_Messages(4, 3) )
                  nRow := ::nRowPos
                  nCol := ::nColPos
                  aItem := ::Item( nRow )
                  ::DeleteItem( nRow )
                  IF ::ItemCount > 0
                     ::Value := { Min( nRow, ::ItemCount ), nCol }
                  ELSE
                     ::Value := { 0, 0 }
                  ENDIF
                  ::DoEvent( ::OnDelete, "DELETE", { aItem } )
               ENDIF
            ELSEIF ! Empty( ::DelMsg )
               MsgExclamation( ::DelMsg, _OOHG_Messages(4, 3) )
            ENDIF
         ENDIF
      ELSEIF nvKey == VK_A .AND. GetKeyFlagState() == MOD_ALT
         IF ::lAppendOnAltA
            ::AppendItem()
         ENDIF
      ENDIF
      // skip default action

      RETURN 1

   ELSEIF nNotify == LVN_ITEMCHANGED
      IF GetGridOldState( lParam ) == 0 .AND. GetGridNewState( lParam ) != 0

         RETURN NIL
      ENDIF

   ELSEIF nNotify == NM_CLICK
      IF ::lCheckBoxes
         // detect item
         uValue := ListView_HitOnCheckBox( ::hWnd, GetCursorRow() - GetWindowRow( ::hWnd ), GetCursorCol() - GetWindowCol( ::hWnd ) )
      ELSE
         uValue := 0
      ENDIF

      IF ::bPosition == -2 .OR. ::bPosition == 9
         aCellData := _GetGridCellData( Self, ListView_ItemActivate( lParam ) )
         ::nDelayedClick := { aCellData[ 1 ], aCellData[ 2 ], uValue, Nil }
         IF ::nEditRow > 0
            ListView_SetCursel( ::hWnd, ::nEditRow )
         ELSE
            ListView_ClearCursel( ::hWnd )
         ENDIF
      ELSE
         IF HB_IsBlock( ::OnClick )
            IF ! ::lCheckBoxes .OR. ::ClickOnCheckbox .OR. uValue <= 0
               IF ! ::NestedClick
                  ::NestedClick := ! _OOHG_NestedSameEvent()
                  ::DoEventMouseCoords( ::OnClick, "CLICK" )
                  ::NestedClick := .F.
               ENDIF
            ENDIF
         ENDIF

         IF uValue > 0
            // change check mark
            ::CheckItem( uValue, ! ::CheckItem( uValue ) )
         ELSE
            // select cell
            aCellData := _GetGridCellData( Self, ListView_ItemActivate( lParam ) )
            ::Value := { aCellData[ 1 ], aCellData[ 2 ] }
         ENDIF
      ENDIF

      // skip default action

      RETURN 1

   ELSEIF nNotify == NM_RCLICK
      IF ::lCheckBoxes
         // detect item
         uValue := ListView_HitOnCheckBox( ::hWnd, GetCursorRow() - GetWindowRow( ::hWnd ), GetCursorCol() - GetWindowCol( ::hWnd ) )
      ELSE
         uValue := 0
      ENDIF

      IF ::bPosition == -2 .OR. ::bPosition == 9
         aCellData := _GetGridCellData( Self, ListView_ItemActivate( lParam ) )
         ::nDelayedClick := { aCellData[ 1 ], aCellData[ 2 ], uValue, aCellData }
         IF ::nEditRow > 0
            ListView_SetCursel( ::hWnd, ::nEditRow )
         ELSE
            ListView_ClearCursel( ::hWnd )
         ENDIF
      ELSE
         IF HB_IsBlock( ::OnRClick )
            IF ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. uValue <= 0
               ::DoEventMouseCoords( ::OnRClick, "RCLICK" )
            ENDIF
         ENDIF

         IF uValue > 0
            // change check mark
            ::CheckItem( uValue, ! ::CheckItem( uValue ) )
         ELSE
            // select cell
            aCellData := _GetGridCellData( Self, ListView_ItemActivate( lParam ) )
            ::Value := { aCellData[ 1 ], aCellData[ 2 ] }
         ENDIF

         // fire context menu
         IF ::ContextMenu != Nil .AND. ( ! ::lCheckBoxes .OR. ::RClickOnCheckbox .OR. uValue <= 0 )
            ::ContextMenu:Cargo := _GetGridCellData( Self, ListView_ItemActivate( lParam ) )
            ::ContextMenu:Activate()
         ENDIF
      ENDIF

      // skip default action

      RETURN 1

   ENDIF

   RETURN ::Super:Events_Notify( wParam, lParam )

METHOD DoChange() CLASS TGridByCell

   LOCAL xValue, cType, cOldType

   xValue   := ::Value
   cType    := ValType( xValue )
   cOldType := ValType( ::xOldValue )
   cType    := If( cType == "M", "C", cType )
   cOldType := If( cOldType == "M", "C", cOldType )

   IF ( cOldType == "U" .OR. ! cType == cOldType .OR. ;
         ( HB_IsArray( xValue ) .AND. ! HB_IsArray( ::xOldValue ) ) .OR. ;
         ( ! HB_IsArray( xValue ) .AND. HB_IsArray( ::xOldValue ) ) .OR. ;
         ! aEqual( xValue, ::xOldValue ) )
      ::xOldValue := xValue
      ::DoEvent( ::OnChange, "CHANGE" )
   ENDIF

   RETURN Self

FUNCTION _GetGridCellData( Self, aPos )

   LOCAL ThisItemRowIndex
   LOCAL ThisItemColIndex
   LOCAL ThisItemCellRow
   LOCAL ThisItemCellCol
   LOCAL ThisItemCellWidth
   LOCAL ThisItemCellHeight
   LOCAL r
   LOCAL nScrollWidth
   LOCAL aCellData
   LOCAL nClientWidth
   LOCAL aControlRect

   IF aPos[ 1 ] == 0
      // Hit on an empty row

      RETURN { 0, 0, 0, 0, 0, 0 }
   ENDIF
   ThisItemRowIndex := aPos[ 1 ]              // item
   ThisItemColIndex := aPos[ 2 ]              // subitem (column)

   // Ensure that the column is inside the client area
   aControlRect := { 0, 0, 0, 0 }                                                         // left, top, right, bottom
   GetClientRect( ::hWnd, aControlRect )
   nClientWidth := aControlRect[ 3 ] - aControlRect[ 1 ]
   aControlRect := { 0, 0, 0, 0 }                                                         // left, top, right, bottom
   GetWindowRect( ::hWnd, aControlRect )
   r := ListView_GetSubitemRect( ::hWnd, ThisItemRowIndex - 1, ThisItemColIndex - 1 )     // top, left, width, height
   IF ::lScrollBarUsesClientArea .AND. ListViewGetItemCount( ::hWnd ) >  ListViewGetCountPerPage( ::hWnd )
      nScrollWidth := GetVScrollBarWidth()
   ELSE
      nScrollWidth := 0
   ENDIF

   IF r[ 2 ] + r[ 3 ] + nScrollWidth > nClientWidth
      // Move right side into client area
      ListView_Scroll( ::hWnd, ( r[ 2 ] + r[ 3 ] + nScrollWidth - nClientWidth ), 0 )
      // Get new position
      r := ListView_GetSubitemRect( ::hWnd, ThisItemRowIndex - 1, ThisItemColIndex - 1 )  // top, left, width, height
   ENDIF
   IF r[ 2 ] < 0
      // Move left side into client area
      ListView_Scroll( ::hWnd, r[ 2 ], 0 )
   ENDIF

   // Get final position
   r := ListView_GetSubitemRect( ::hWnd, ThisItemRowIndex - 1, ThisItemColIndex - 1 )

   ThisItemCellRow    := r[ 1 ] + aControlRect[ 2 ]
   ThisItemCellCol    := r[ 2 ] + aControlRect[ 1 ]
   ThisItemCellWidth  := r[ 3 ]
   ThisItemCellHeight := r[ 4 ]

   aCellData := { ThisItemRowIndex, ThisItemColIndex, ThisItemCellRow, ThisItemCellCol, ThisItemCellWidth, ThisItemCellHeight }

   RETURN aCellData

PROCEDURE _SetThisCellInfo( hWnd, nRow, nCol, uValue )

   LOCAL aControlRect, aCellRect

   aControlRect := { 0, 0, 0, 0 }                                               // left, top, right, bottom
   GetWindowRect( hWnd, aControlRect )
   aCellRect := ListView_GetSubitemRect( hWnd, nRow - 1, nCol - 1 )             // top, left, width, height

   _OOHG_ThisItemRowIndex   := nRow
   _OOHG_ThisItemColIndex   := nCol
   _OOHG_ThisItemCellRow    := aCellRect[ 1 ] + aControlRect[ 2 ] + 2
   _OOHG_ThisItemCellCol    := aCellRect[ 2 ] + aControlRect[ 1 ] + 3
   _OOHG_ThisItemCellWidth  := aCellRect[ 3 ]
   _OOHG_ThisItemCellHeight := aCellRect[ 4 ]
   _OOHG_ThisItemCellValue  := uValue

   RETURN

PROCEDURE _ClearThisCellInfo()

   _OOHG_ThisItemRowIndex   := 0
   _OOHG_ThisItemColIndex   := 0
   _OOHG_ThisItemCellRow    := 0
   _OOHG_ThisItemCellCol    := 0
   _OOHG_ThisItemCellWidth  := 0
   _OOHG_ThisItemCellHeight := 0

   RETURN

   // uValue may be passed by reference

FUNCTION _CheckCellNewValue( oControl, uValue )

   LOCAL lChange, uValue2

   uValue2 := _OOHG_ThisItemCellValue
   IF uValue == uValue2
      IF ValType( oControl:cMemVar ) $ "CM" .AND. ! Empty( oControl:cMemVar ) .AND. Left( Type( oControl:cMemVar ), 1 ) != "U"
         uValue2 := &( oControl:cMemVar )
      ENDIF
   ENDIF
   IF ! uValue == uValue2
      oControl:ControlValue := uValue2
      _OOHG_ThisItemCellValue := uValue2
      IF ValType( oControl:cMemVar ) $ "CM" .AND. ! Empty( oControl:cMemVar )
         &( oControl:cMemVar ) := uValue2
      ENDIF
      uValue := uValue2
      lChange := .T.
   ELSE
      lChange := .F.
   ENDIF

   RETURN lChange

FUNCTION GridControlObject( aEditControl, oGrid )

   LOCAL oGridControl, aEdit2, cControl

   oGridControl := Nil
   IF HB_IsArray( aEditControl ) .AND. Len( aEditControl ) >= 1 .AND. ValType( aEditControl[ 1 ] ) $ "CM"
      aEdit2 := AClone( aEditControl )
      ASize( aEdit2, 11 )
      cControl := Upper( AllTrim( aEditControl[ 1 ] ) )
      DO CASE
      CASE cControl == "MEMO"
         oGridControl := TGridControlMemo():New( aEdit2[ 2 ], aEdit2[ 3 ], oGrid, aEdit2[ 4 ], aEdit2[ 5 ], aEdit2[ 6 ], aEdit2[ 7 ] )
      CASE cControl == "DATEPICKER"
         oGridControl := TGridControlDatePicker():New( aEdit2[ 2 ], aEdit2[ 3 ], aEdit2[ 4 ], aEdit2[ 5 ], oGrid, aEdit2[ 6 ] )
      CASE cControl == "COMBOBOX"
         oGridControl := TGridControlComboBox():New( aEdit2[ 2 ], oGrid, aEdit2[ 3 ], aEdit2[ 4 ], aEdit2[ 5 ], aEdit2[ 6 ], aEdit2[ 7 ] )
      CASE cControl == "COMBOBOXTEXT"
         oGridControl := TGridControlComboBoxText():New( aEdit2[ 2 ], oGrid, aEdit2[ 3 ], aEdit2[ 4 ], aEdit2[ 5 ], aEdit2[ 6 ], aEdit2[ 7 ] )
      CASE cControl == "SPINNER"
         oGridControl := TGridControlSpinner():New( aEdit2[ 2 ], aEdit2[ 3 ], aEdit2[ 4 ], aEdit2[ 5 ], oGrid, aEdit2[ 6 ] )
      CASE cControl == "CHECKBOX"
         oGridControl := TGridControlCheckBox():New( aEdit2[ 2 ], aEdit2[ 3 ], aEdit2[ 4 ], aEdit2[ 5 ], oGrid, aEdit2[ 6 ] )
      CASE cControl == "TEXTBOX"
         oGridControl := TGridControlTextBox():New( aEdit2[ 3 ], aEdit2[ 4 ], aEdit2[ 2 ], aEdit2[ 5 ], aEdit2[ 6 ], aEdit2[ 7 ], oGrid, aEdit2[ 8 ], aEdit2[ 9 ], aEdit2[ 10 ] )
      CASE cControl == "TEXTBOXACTION"
         oGridControl := TGridControlTextBoxAction():New( aEdit2[ 3 ], aEdit2[ 4 ], aEdit2[ 2 ], aEdit2[ 5 ], aEdit2[ 6 ], aEdit2[ 7 ], oGrid, aEdit2[ 8 ], aEdit2[ 9 ], aEdit2[ 10 ], aEdit2[ 11 ] )
      CASE cControl == "IMAGELIST"
         oGridControl := TGridControlImageList():New( oGrid, aEdit2[ 2 ], aEdit2[ 3 ], aEdit2[ 4 ] )
      CASE cControl == "IMAGEDATA"
         oGridControl := TGridControlImageData():New( oGrid, GridControlObject( aEdit2[ 2 ], oGrid ), aEdit2[ 3 ], aEdit2[ 4 ], aEdit2[ 5 ] )
      CASE cControl == "LCOMBOBOX"
         oGridControl := TGridControlLComboBox():New( aEdit2[ 2 ], aEdit2[ 3 ], aEdit2[ 4 ], aEdit2[ 5 ], oGrid, aEdit2[ 6 ] )
      ENDCASE
   ENDIF

   RETURN oGridControl

FUNCTION GridControlObjectByType( uValue, oGrid )

   LOCAL oGridControl := Nil, cMask, nPos

   DO CASE
   CASE HB_IsNumeric( uValue )
      cMask := Str( uValue )
      cMask := Replicate( "9", Len( cMask ) )
      nPos := At( ".", cMask )
      IF nPos != 0
         cMask := Left( cMask, nPos - 1 ) + "." + SubStr( cMask, nPos + 1 )
      ENDIF
      oGridControl := TGridControlTextBox():New( cMask, , "N", , , , oGrid )
   CASE HB_IsLogical( uValue )
      // oGridControl := TGridControlCheckBox():New( ".T.", ".F.", oGrid )
      oGridControl := TGridControlLComboBox():New( ".T.", ".F.", , , oGrid )
   CASE HB_IsDate( uValue )
      // oGridControl := TGridControlDatePicker():New( .T., , oGrid )
      oGridControl := TGridControlTextBox():New( "@D", , "D", , , , oGrid )
   CASE ValType( uValue ) == "M"
      oGridControl := TGridControlMemo():New( , , oGrid )
   CASE ValType( uValue ) == "C"
      oGridControl := TGridControlTextBox():New( , , "C", , , , oGrid )
   OTHERWISE
      // Unimplemented data type!!!
   ENDCASE

   RETURN oGridControl

FUNCTION GetEditControlFromArray( oEditControl, aEditControls, nColumn, oGrid )

   IF HB_IsArray( oEditControl )
      oEditControl := GridControlObject( oEditControl, oGrid )
   ENDIF
   IF ! HB_IsObject( oEditControl ) .AND. HB_IsArray( aEditControls ) .AND. HB_IsNumeric( nColumn ) .AND. nColumn >= 1 .AND. Len( aEditControls ) >= nColumn
      oEditControl := aEditControls[ nColumn ]
      IF HB_IsArray( oEditControl )
         oEditControl := GridControlObject( oEditControl, oGrid )
      ENDIF
   ENDIF
   IF ! HB_IsObject( oEditControl )
      oEditControl := Nil
   ENDIF

   RETURN oEditControl

FUNCTION GetStateListWidth( hwnd )

   RETURN ImageList_Size( ListView_GetImageList( hwnd, LVSIL_STATE ) )[ 1 ]

CLASS TGridControl

   DATA Type                      INIT "TGRIDCONTROL" READONLY
   DATA oControl                  INIT Nil
   DATA oWindow                   INIT Nil
   DATA oGrid                     INIT Nil
   DATA Value                     INIT Nil
   DATA bWhen                     INIT Nil
   DATA cMemVar                   INIT Nil
   DATA bValid                    INIT Nil
   DATA cValidMessage             INIT Nil
   DATA nDefWidth                 INIT 140
   DATA nDefHeight                INIT 24
   DATA bCancel                   INIT Nil
   DATA bOk                       INIT Nil
   DATA lButtons                  INIT .F.
   DATA cImageOk                  INIT 'EDIT_OK_16'
   DATA cImageCancel              INIT 'EDIT_CANCEL_16'
   DATA lLikeExcel                INIT .F.
   DATA nOnFocusPos               INIT Nil
   DATA lNoModal                  INIT .F.

   METHOD New                     BLOCK { | Self | Self }
   METHOD CreateWindow
   METHOD Valid
   METHOD Str2Val( uValue )       BLOCK { | Self, uValue | Empty( Self ), uValue }
   METHOD GridValue( uValue )     BLOCK { | Self, uValue | Empty( Self ), If( ValType( uValue ) $ "CM", Trim( uValue ), uValue ) }
   METHOD SetFocus                BLOCK { | Self | ::oControl:SetFocus() }
   METHOD SetValue( uValue )      BLOCK { | Self, uValue | ::oControl:Value := uValue }
   METHOD ControlValue            SETGET
   METHOD Enabled                 SETGET
   METHOD OnLostFocus             SETGET
   METHOD Visible                 SETGET

   ENDCLASS

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, aKeys, oGrid ) CLASS TGridControl

   LOCAL lRet := .F., i, nSize

   IF HB_IsObject( oGrid )
      ::oGrid := oGrid
   ENDIF

   IF HB_IsObject( ::oGrid ) .AND. ::oGrid:InPlace .AND. ( ::lNoModal .OR. ::oGrid:lNoModal )

      DEFINE WINDOW 0 OBJ ::oWindow ;
            AT nRow, nCol WIDTH nWidth HEIGHT nHeight ;
            CHILD NOSIZE NOCAPTION ;
            FONT cFontName SIZE nFontSize ;
            ON INIT ( ::onLostFocus := { |bAux| ::oGrid:bPosition := 9, bAux := ::onLostFocus, ::onLostFocus := Nil, lRet := ::Valid(), ::onLostFocus := bAux } )

         ::bOk := { |nPos, bAux| ::oGrid:bPosition := nPos, bAux := ::onLostFocus, ::onLostFocus := Nil, lRet := ::Valid(), ::onLostFocus := bAux }
         ::bCancel := { || ::oGrid:bPosition := 0, ::oWindow:Release() }

      ELSEIF HB_IsObject( ::oGrid )

         DEFINE WINDOW 0 OBJ ::oWindow ;
               AT nRow, nCol WIDTH nWidth HEIGHT nHeight ;
               MODAL NOSIZE NOCAPTION ;
               FONT cFontName SIZE nFontSize

            ::bOk := { |nPos| ::oGrid:bPosition := nPos, lRet := ::Valid() }
            ::bCancel := { || ::oGrid:bPosition := 0, ::oWindow:Release() }

         ELSE

            DEFINE WINDOW 0 OBJ ::oWindow ;
                  AT nRow, nCol WIDTH nWidth HEIGHT nHeight ;
                  MODAL NOSIZE NOCAPTION ;
                  FONT cFontName SIZE nFontSize

               ::bOk := { || lRet := ::Valid() }
               ::bCancel := { || ::oWindow:Release() }

            ENDIF

            ON KEY RETURN OF ( ::oWindow ) ACTION EVAL( ::bOk, -1 )
            ON KEY ESCAPE OF ( ::oWindow ) ACTION EVAL( ::bCancel )

            IF HB_IsArray( aKeys )
               FOR i := 1 To Len( aKeys )
                  IF HB_IsArray( aKeys[ i ] ) .AND. Len( aKeys[ i ] ) > 1 .AND. ValType( aKeys[ i, 1 ] ) $ "CM" .AND. HB_IsBlock( aKeys[ i, 2 ] ) .AND. ! ( aKeys[ i, 1 ] == "RETURN" .OR. aKeys[ i, 1 ] == "ESCAPE" )
                     _DefineAnyKey( ::oWindow, aKeys[ i, 1 ], aKeys[ i, 2 ] )
                  ENDIF
               NEXT
            ENDIF

            IF ::lButtons .OR. ( HB_IsObject( ::oGrid ) .AND. ::oGrid:lButtons )
               nSize := nHeight - 4
               ::CreateControl( uValue, ::oWindow, 0, 0, nWidth - nSize * 2 - 6, nHeight )
               @ 2, nWidth - nSize * 2 - 6 + 2 BUTTON 0 WIDTH nSize HEIGHT nSize ACTION EVAL( ::bOk, -1 ) OF ( ::oWindow ) PICTURE ::cImageOk
               @ 2, nWidth - nSize - 2 BUTTON 0 WIDTH nSize HEIGHT nSize ACTION EVAL( ::bCancel ) OF ( ::oWindow ) PICTURE ::cImageCancel
            ELSE
               ::CreateControl( uValue, ::oWindow, 0, 0, nWidth, nHeight )
            ENDIF
            ::Value := ::ControlValue
         END WINDOW

         IF HB_IsObject( ::oControl )
            ::oControl:SetFocus()
         ENDIF
         IF HB_IsObject( ::oWindow )
            ::oWindow:Activate()
         ENDIF
         ::oWindow := Nil

         RETURN lRet

METHOD Valid() CLASS TGridControl

   LOCAL lValid, uValue, cValidMessage

   uValue := ::ControlValue

   IF ValType( ::cMemVar ) $ "CM" .AND. ! Empty( ::cMemVar )
      &( ::cMemVar ) := uValue
   ENDIF

   _OOHG_ThisItemCellValue := uValue
   _PushEventInfo()
   lValid := _OOHG_Eval( ::bValid, uValue )
   _PopEventInfo()
   _CheckCellNewValue( Self, @uValue )
   IF ! HB_IsLogical( lValid )
      lValid := .T.
   ENDIF

   IF lValid
      ::Value := uValue
      ::oWindow:Release()
   ELSE
      cValidMessage := ::cValidMessage
      IF HB_IsBlock( cValidMessage )
         cValidMessage := Eval( cValidMessage, uValue )
      ENDIF
      IF ValType( cValidMessage ) $ "CM" .AND. ! Empty( cValidMessage )
         MsgExclamation( cValidMessage )
      ELSE
         MsgExclamation( _OOHG_Messages( 3, 11 ) )
      ENDIF
      ::oControl:SetFocus()
   ENDIF

   RETURN lValid

METHOD ControlValue( uValue ) CLASS TGridControl

   IF PCount() >= 1
      ::oControl:Value := uValue
   ENDIF

   RETURN ::oControl:Value

METHOD Enabled( uValue ) CLASS TGridControl

   RETURN ( ::oControl:Enabled := uValue )

METHOD Visible( uValue ) CLASS TGridControl

   RETURN ( ::oControl:Visible := uValue )

METHOD OnLostFocus( uValue ) CLASS TGridControl

   IF PCount() >= 1
      ::oControl:OnLostFocus := uValue
   ENDIF

   RETURN ::oControl:OnLostFocus

CLASS TGridControlTextBox FROM TGridControl

   DATA cMask                     INIT ""
   DATA cType                     INIT ""
   DATA cEditKey                  INIT "F2"
   DATA lForceModal               INIT .F.
   DATA Type                      INIT "TGRIDCONTROLTEXTBOX" READONLY

   METHOD New
   METHOD CreateWindow
   METHOD CreateControl
   METHOD Str2Val
   METHOD GridValue

   ENDCLASS

   /*
   COLUMNCONTROLS syntax:
   {'TEXTBOX', cType, cPicture, cFunction, nOnFocusPos, lButtons, aImages, lLikeExcel, cEditKey, lNoModal}
   */

METHOD New( cPicture, cFunction, cType, nOnFocusPos, lButtons, aImages, oGrid, lLikeExcel, cEditKey, lNoModal ) CLASS TGridControlTextBox

   ::cMask := ""
   IF ValType( cPicture ) $ "CM" .AND. ! Empty( cPicture )
      ::cMask := cPicture
   ENDIF
   IF ValType( cFunction ) $ "CM" .AND. ! Empty( cFunction )
      ::cMask := "@" + cFunction + " " + ::cMask
   ENDIF

   IF ValType( cType ) $ "CM" .AND. ! Empty( cType )
      cType := Upper( Left( AllTrim( cType ), 1 ) )
      ::cType := If( ( ! cType $ "CDNL" ), "C", cType )
   ELSE
      ::cType := "C"
   ENDIF
   IF ::cType == "D" .AND. Empty( ::cMask )
      ::cMask := "@D"
   ELSEIF ::cType == "N" .AND. Empty( ::cMask )
      //    ::cMask := "@D"
   ELSEIF ::cType == "L" .AND. Empty( ::cMask )
      ::cMask := "L"
   ENDIF

   ASSIGN ::nOnFocusPos VALUE nOnFocusPos TYPE "N"

   ASSIGN ::lButtons VALUE lButtons TYPE "L"
   IF HB_IsArray( aImages )
      IF Len( aImages ) < 2
         ASize( aImages, 2 )
      ENDIF
      ASSIGN ::cImageCancel VALUE aImages[ 1 ] TYPE "CM"
      ASSIGN ::cImageOk     VALUE aImages[ 2 ] TYPE "CM"
   ENDIF

   ::oGrid := oGrid

   ASSIGN ::lLikeExcel VALUE lLikeExcel TYPE "L"

   IF ValType( cEditKey ) $ "CM"
      ::cEditKey := cEditKey
   ELSEIF HB_IsObject( ::oGrid )
      ::cEditKey := ::oGrid:cEditKey
   ENDIF

   ASSIGN ::lNoModal VALUE lNoModal TYPE "L"

   // TODO: use buttons with NOMODAL state
   IF ::lButtons
      ::lForceModal := .T.
   ENDIF

   RETURN Self

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, aKeys, oGrid ) CLASS TGridControlTextBox

   LOCAL lRet := .F., i, aPos, nPos1, nPos2, cText, nPos

   IF HB_IsObject( oGrid )
      ::oGrid := oGrid
   ENDIF

   IF HB_IsObject( ::oGrid ) .AND. ::oGrid:InPlace .AND. ( ::lNoModal .OR. ::oGrid:lNoModal ) .AND. ! ::lForceModal

      DEFINE WINDOW 0 OBJ ::oWindow ;
            AT nRow - 3, nCol - 3 WIDTH nWidth + 6 HEIGHT nHeight + 6 ;
            CHILD NOSIZE NOCAPTION ;
            FONT cFontName SIZE nFontSize ;
            ON INIT ( ::onLostFocus := { |bAux| ::oGrid:bPosition := 9, bAux := ::onLostFocus, ::onLostFocus := Nil, lRet := ::Valid(), ::onLostFocus := bAux } )

         ::bOk := { |nPos, bAux| ::oGrid:bPosition := nPos, bAux := ::onLostFocus, ::onLostFocus := Nil, lRet := ::Valid(), ::onLostFocus := bAux }
         ::bCancel := { || ::oGrid:bPosition := 0, ::oWindow:Release() }

      ELSEIF HB_IsObject( ::oGrid )

         DEFINE WINDOW 0 OBJ ::oWindow ;
               AT nRow - 3, nCol - 3 WIDTH nWidth + 6 HEIGHT nHeight + 6 ;
               MODAL NOSIZE NOCAPTION ;
               FONT cFontName SIZE nFontSize

            ::bOk := { |nPos| ::oGrid:bPosition := nPos, lRet := ::Valid() }
            ::bCancel := { || ::oGrid:bPosition := 0, ::oWindow:Release() }

         ELSE

            DEFINE WINDOW 0 OBJ ::oWindow ;
                  AT nRow - 3, nCol - 3 WIDTH nWidth + 6 HEIGHT nHeight + 6 ;
                  MODAL NOSIZE NOCAPTION ;
                  FONT cFontName SIZE nFontSize

               ::bOk := { || lRet := ::Valid() }
               ::bCancel := { || ::oWindow:Release() }

            ENDIF

            ON KEY RETURN OF ( ::oWindow ) ACTION EVAL( ::bOk, -1 )
            ON KEY ESCAPE OF ( ::oWindow ) ACTION EVAL( ::bCancel )

            IF HB_IsArray( aKeys )
               FOR i := 1 To Len( aKeys )
                  IF HB_IsArray( aKeys[ i ] ) .AND. Len( aKeys[ i ] ) > 1
                     IF ValType( aKeys[ i, 1 ] ) $ "CM" .AND. HB_IsBlock( aKeys[ i, 2 ] )
                        IF ! ( aKeys[ i, 1 ] == "RETURN" .OR. aKeys[ i, 1 ] == "ESCAPE" .OR. ( aKeys[ i, 1 ] == ::cEditKey .AND. HB_IsObject( ::oGrid ) .AND. ::oGrid:InPlace .AND. ( ::lLikeExcel .OR. ::oGrid:lLikeExcel ) ) )
                           _DefineAnyKey( ::oWindow, aKeys[ i, 1 ], aKeys[ i, 2 ] )
                        ENDIF
                     ENDIF
                  ENDIF
               NEXT
            ENDIF

            ::CreateControl( uValue, ::oWindow, 0, 0, nWidth + 6, nHeight + 6 )

            IF HB_IsObject( ::oGrid ) .AND. ::oGrid:InPlace .AND. ( ::lLikeExcel .OR. ::oGrid:lLikeExcel ) .AND. ::oGrid:lKeysOn
               ON KEY UP             OF ( ::oControl ) ACTION EVAL( ::bOk, 1 )
               ON KEY RIGHT          OF ( ::oControl ) ACTION EVAL( ::bOk, 2 )
               ON KEY LEFT           OF ( ::oControl ) ACTION EVAL( ::bOk, 3 )
               ON KEY HOME           OF ( ::oControl ) ACTION EVAL( ::bOk, 4 )
               ON KEY END            OF ( ::oControl ) ACTION EVAL( ::bOk, 5 )
               ON KEY DOWN           OF ( ::oControl ) ACTION EVAL( ::bOk, 6 )
               ON KEY PRIOR          OF ( ::oControl ) ACTION EVAL( ::bOk, 7 )
               ON KEY NEXT           OF ( ::oControl ) ACTION EVAL( ::bOk, 8 )
               ON KEY ( ::cEditKey ) OF ( ::oControl ) ACTION TGridControlTextBox_ReleaseKeys( ::oControl, ::cEditKey )
               ::oControl:OnClick     := { || TGridControlTextBox_ReleaseKeys( ::oControl, ::cEditKey ) }
               ::oControl:OnDblClick  := { || TGridControlTextBox_ReleaseKeys( ::oControl, ::cEditKey ) }
               ::oControl:OnRClick    := { || TGridControlTextBox_ReleaseKeys( ::oControl, ::cEditKey ) }
               ::oControl:OnRDblClick := { || TGridControlTextBox_ReleaseKeys( ::oControl, ::cEditKey ) }
               ::oControl:OnMClick    := { || TGridControlTextBox_ReleaseKeys( ::oControl, ::cEditKey ) }
               ::oControl:OnMDblClick := { || TGridControlTextBox_ReleaseKeys( ::oControl, ::cEditKey ) }
               IF ::oGrid:lKeysLikeClipper
                  ON KEY CTRL+HOME   OF ( ::oControl ) ACTION EVAL( ::bOk, 14 )
                  ON KEY CTRL+END    OF ( ::oControl ) ACTION EVAL( ::bOk, 15 )
                  ON KEY CTRL+PRIOR  OF ( ::oControl ) ACTION EVAL( ::bOk, 17 )
                  ON KEY CTRL+NEXT   OF ( ::oControl ) ACTION EVAL( ::bOk, 18 )
               ELSE
                  ON KEY CTRL+RIGHT  OF ( ::oControl ) ACTION EVAL( ::bOk, 12 )
                  ON KEY CTRL+LEFT   OF ( ::oControl ) ACTION EVAL( ::bOk, 13 )
               ENDIF
            ENDIF

            ::Value := ::ControlValue
         END WINDOW

         IF HB_IsObject( ::oControl )
            ::oControl:SetFocus()
            IF HB_IsObject( ::oGrid ) .AND. ::oGrid:InPlace .AND. ( ::lLikeExcel .OR. ::oGrid:lLikeExcel )
               IF ::oControl:Type == "TEXTPICTURE"
                  IF ValType( uValue ) $ "CM" .AND. Len( uValue ) == 1
                     aPos := ::oControl:GetSelection()
                     nPos1 := aPos[ 1 ]
                     nPos2 := aPos[ 2 ]
                     cText := ::oControl:Caption
                     nPos := nPos1
                     cText := TTextPicture_Clear( cText, nPos + 1, nPos2 - nPos1, ::oControl:ValidMask, ::oControl:InsertStatus )
                     IF TTextPicture_Events2_String( ::oControl, @cText, @nPos, uValue, ::oControl:ValidMask, ::oControl:PictureMask, ::oControl:InsertStatus )
                        ::oControl:Caption := cText
                        SendMessage( ::oControl:hWnd, EM_SETSEL, nPos, nPos )
                     ENDIF
                  ENDIF
               ELSE
                  ::oControl:CaretPos := -1
               ENDIF
            ENDIF
         ENDIF
         IF HB_IsObject( ::oWindow )
            ::oWindow:Activate()
         ENDIF
         ::oWindow := Nil

         RETURN lRet

FUNCTION TGridControlTextBox_ReleaseKeys( oControl, cEditKey )

   RELEASE KEY LEFT         OF ( oControl )
   RELEASE KEY UP           OF ( oControl )
   RELEASE KEY RIGHT        OF ( oControl )
   RELEASE KEY DOWN         OF ( oControl )
   RELEASE KEY HOME         OF ( oControl )
   RELEASE KEY END          OF ( oControl )
   RELEASE KEY PRIOR        OF ( oControl )
   RELEASE KEY DOWN         OF ( oControl )
   RELEASE KEY CTRL+RIGHT   OF ( oControl )
   RELEASE KEY CTRL+LEFT    OF ( oControl )
   RELEASE KEY CTRL+HOME    OF ( oControl )
   RELEASE KEY CTRL+END     OF ( oControl )
   RELEASE KEY CTRL+PRIOR   OF ( oControl )
   RELEASE KEY CTRL+NEXT    OF ( oControl )
   RELEASE KEY ( cEditKey ) OF ( oControl )

   RETURN NIL

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlTextBox

   IF ValType( uValue ) == "C" .AND. ::cType $ "DNL"
      uValue := ::Str2Val( uValue )
   ENDIF
   IF ! Empty( ::cMask )
      IF ::lButtons .OR. ( HB_IsObject( ::oGrid ) .AND. ::oGrid:lButtons )
         @ nRow, nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue INPUTMASK ::cMask FOCUSEDPOS ::nOnFocusPos ACTION EVAL( ::bCancel ) ACTION2 EVAL( ::bOK, -1 ) IMAGE {::cImageCancel, ::cImageOk}
      ELSE
         @ nRow,nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue INPUTMASK ::cMask FOCUSEDPOS ::nOnFocusPos
      ENDIF
   ELSEIF ::cType == "N"
      IF ::lButtons .OR. ( HB_IsObject( ::oGrid ) .AND. ::oGrid:lButtons )
         @ nRow, nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue NUMERIC FOCUSEDPOS ::nOnFocusPos ACTION EVAL( ::bCancel ) ACTION2 EVAL( ::bOK, -1 ) IMAGE {::cImageCancel, ::cImageOk}
      ELSE
         @ nRow, nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue NUMERIC FOCUSEDPOS ::nOnFocusPos
      ENDIF
   ELSEIF ::cType == "D"
      IF ::lButtons .OR. ( HB_IsObject( ::oGrid ) .AND. ::oGrid:lButtons )
         @ nRow, nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue DATE FOCUSEDPOS ::nOnFocusPos ACTION EVAL( ::bCancel ) ACTION2 EVAL( ::bOK, -1 ) IMAGE {::cImageCancel, ::cImageOk}
      ELSE
         @ nRow, nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue DATE FOCUSEDPOS ::nOnFocusPos
      ENDIF
   ELSE
      IF ::lButtons .OR. ( HB_IsObject( ::oGrid ) .AND. ::oGrid:lButtons )
         @ nRow, nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue FOCUSEDPOS ::nOnFocusPos ACTION EVAL( ::bCancel ) ACTION2 EVAL( ::bOK, -1 ) IMAGE {::cImageCancel, ::cImageOk}
      ELSE
         @ nRow, nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue FOCUSEDPOS ::nOnFocusPos
      ENDIF
   ENDIF
   IF ::lButtons .OR. ( HB_IsObject( ::oGrid ) .AND. ::oGrid:lButtons )
      ::oControl:oButton1:TabIndex := 2
   ENDIF

   RETURN ::oControl

METHOD Str2Val( uValue ) CLASS TGridControlTextBox

   DO CASE
   CASE ::cType == "D"
      uValue := CtoD( uValue )
   CASE ::cType == "L"
      uValue := ( PadL( uValue, 1 ) $ "TtYy" )
   CASE ::cType == "N"
      uValue := Val( StrTran( _OOHG_UnTransform( uValue, ::cMask, ::cType ), " ", "" ) )
   CASE ::cType == "T"
      uValue := CtoT( uValue )
   OTHERWISE
      IF ! Empty( ::cMask )
         uValue := _OOHG_UnTransform( uValue, ::cMask, ::cType )
      ENDIF
   ENDCASE

   RETURN uValue

METHOD GridValue( uValue ) CLASS TGridControlTextBox

   IF Empty( ::cMask )
      IF ::cType == "D"
         uValue := DtoC( uValue )
      ELSEIF ::cType == "N"
         uValue := LTrim( Str( uValue ) )
      ELSEIF ::cType == "L"
         uValue := If( uValue, "T", "F" )
      ELSEIF ::cType $ "CM"
         uValue := Trim( uValue )
      ELSEIF ::cType == "T"
         uValue := TtoC( uValue )
      ENDIF
   ELSE
      uValue := Trim( Transform( uValue, ::cMask ) )
   ENDIF

   RETURN uValue

CLASS TGridControlTextBoxAction FROM TGridControlTextBox

   DATA bAction                   INIT Nil
   DATA bAction2                  INIT Nil
   DATA Type                      INIT "TGRIDCONTROLTEXTBOXACTION" READONLY

   METHOD New
   METHOD CreateControl

   ENDCLASS

   /*
   COLUMNCONTROLS syntax:
   {'TEXTBOXACTION', cType, cPicture, cFunction, nOnFocusPos, aImages, lLikeExcel, cEditKey, lNoModal, bAction, bAction2}
   */

METHOD New( cPicture, cFunction, cType, nOnFocusPos, aImages, oGrid, lLikeExcel, cEditKey, lNoModal, bAction, bAction2 ) CLASS TGridControlTextBoxAction

   ::cMask := ""
   IF ValType( cPicture ) $ "CM" .AND. ! Empty( cPicture )
      ::cMask := cPicture
   ENDIF
   IF ValType( cFunction ) $ "CM" .AND. ! Empty( cFunction )
      ::cMask := "@" + cFunction + " " + ::cMask
   ENDIF

   IF ValType( cType ) $ "CM" .AND. ! Empty( cType )
      cType := Upper( Left( AllTrim( cType ), 1 ) )
      ::cType := If( ( ! cType $ "CDNL" ), "C", cType )
   ELSE
      ::cType := "C"
   ENDIF
   IF ::cType == "D" .AND. Empty( ::cMask )
      ::cMask := "@D"
   ELSEIF ::cType == "N" .AND. Empty( ::cMask )
      //    ::cMask := "@D"
   ELSEIF ::cType == "L" .AND. Empty( ::cMask )
      ::cMask := "L"
   ENDIF

   ASSIGN ::nOnFocusPos VALUE nOnFocusPos TYPE "N"

   IF HB_IsArray( aImages )
      IF Len( aImages ) < 2
         ASize( aImages, 2 )
      ENDIF
      ASSIGN ::cImageCancel VALUE aImages[ 1 ] TYPE "CM"
      ASSIGN ::cImageOk     VALUE aImages[ 2 ] TYPE "CM"
   ENDIF

   ::oGrid := oGrid

   ASSIGN ::lLikeExcel VALUE lLikeExcel TYPE "L"

   IF ValType( cEditKey ) $ "CM"
      ::cEditKey := cEditKey
   ELSEIF HB_IsObject( ::oGrid )
      ::cEditKey := ::oGrid:cEditKey
   ENDIF

   ASSIGN ::lNoModal VALUE lNoModal TYPE "L"
   ASSIGN ::bAction  VALUE bAction  TYPE "B"
   ASSIGN ::bAction2 VALUE bAction2 TYPE "B"

   // TODO: use actions with NOMODAL state
   IF HB_IsBlock( ::bAction ) .OR. HB_IsBlock( ::bAction2 )
      ::lForceModal := .T.
   ENDIF

   RETURN Self

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlTextBoxAction

   IF ValType( uValue ) == "C" .AND. ::cType $ "DNL"
      uValue := ::Str2Val( uValue )
   ENDIF
   IF ! Empty( ::cMask )
      IF HB_IsBlock( ::bAction ) .AND. HB_IsBlock( ::bAction2 )
         @ nRow, nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue INPUTMASK ::cMask FOCUSEDPOS ::nOnFocusPos ACTION EVAL( ::bAction ) ACTION2 EVAL( ::bAction2 ) IMAGE {::cImageCancel, ::cImageOk}
      ELSEIF HB_IsBlock( ::bAction )
         @ nRow, nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue INPUTMASK ::cMask FOCUSEDPOS ::nOnFocusPos ACTION EVAL( ::bAction ) IMAGE {::cImageCancel, }
      ELSEIF HB_IsBlock( ::bAction2 )
         @ nRow, nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue INPUTMASK ::cMask FOCUSEDPOS ::nOnFocusPos ACTION2 EVAL( ::bAction2 ) IMAGE { , ::cImageOk}
      ELSEIF HB_IsObject( ::oGrid ) .AND. ::oGrid:lButtons
         @ nRow, nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue INPUTMASK ::cMask FOCUSEDPOS ::nOnFocusPos ACTION EVAL( ::bCancel ) ACTION2 EVAL( ::bOK, -1 ) IMAGE {::cImageCancel, ::cImageOk}
      ELSE
         @ nRow,nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue INPUTMASK ::cMask FOCUSEDPOS ::nOnFocusPos
      ENDIF
   ELSEIF ::cType == "N"
      IF HB_IsBlock( ::bAction ) .AND. HB_IsBlock( ::bAction2 )
         @ nRow, nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue NUMERIC FOCUSEDPOS ::nOnFocusPos ACTION EVAL( ::bAction ) ACTION2 EVAL( ::bAction2 ) IMAGE {::cImageCancel, ::cImageOk}
      ELSEIF HB_IsBlock( ::bAction )
         @ nRow, nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue NUMERIC FOCUSEDPOS ::nOnFocusPos ACTION EVAL( ::bAction ) IMAGE {::cImageCancel, }
      ELSEIF HB_IsBlock( ::bAction2 )
         @ nRow, nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue NUMERIC FOCUSEDPOS ::nOnFocusPos ACTION2 EVAL( ::bAction2 ) IMAGE { , ::cImageOk}
      ELSEIF HB_IsObject( ::oGrid ) .AND. ::oGrid:lButtons
         @ nRow, nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue NUMERIC FOCUSEDPOS ::nOnFocusPos ACTION EVAL( ::bCancel ) ACTION2 EVAL( ::bOK, -1 ) IMAGE {::cImageCancel, ::cImageOk}
      ELSE
         @ nRow, nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue NUMERIC FOCUSEDPOS ::nOnFocusPos
      ENDIF
   ELSEIF ::cType == "D"
      IF HB_IsBlock( ::bAction ) .AND. HB_IsBlock( ::bAction2 )
         @ nRow, nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue DATE FOCUSEDPOS ::nOnFocusPos ACTION EVAL( ::bAction ) ACTION2 EVAL( ::bAction2 ) IMAGE {::cImageCancel, ::cImageOk}
      ELSEIF HB_IsBlock( ::bAction )
         @ nRow, nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue DATE FOCUSEDPOS ::nOnFocusPos ACTION EVAL( ::bAction ) IMAGE {::cImageCancel, }
      ELSEIF HB_IsBlock( ::bAction2 )
         @ nRow, nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue DATE FOCUSEDPOS ::nOnFocusPos ACTION2 EVAL( ::bAction2 ) IMAGE { , ::cImageOk}
      ELSEIF HB_IsObject( ::oGrid ) .AND. ::oGrid:lButtons
         @ nRow, nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue DATE FOCUSEDPOS ::nOnFocusPos ACTION EVAL( ::bCancel ) ACTION2 EVAL( ::bOK, -1 ) IMAGE {::cImageCancel, ::cImageOk}
      ELSE
         @ nRow, nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue DATE FOCUSEDPOS ::nOnFocusPos
      ENDIF
   ELSE
      IF HB_IsBlock( ::bAction ) .AND. HB_IsBlock( ::bAction2 )
         @ nRow, nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue FOCUSEDPOS ::nOnFocusPos ACTION EVAL( ::bAction ) ACTION2 EVAL( ::bAction2 ) IMAGE {::cImageCancel, ::cImageOk}
      ELSEIF HB_IsBlock( ::bAction )
         @ nRow, nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue FOCUSEDPOS ::nOnFocusPos ACTION EVAL( ::bAction ) IMAGE {::cImageCancel, }
      ELSEIF HB_IsBlock( ::bAction2 )
         @ nRow, nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue FOCUSEDPOS ::nOnFocusPos ACTION2 EVAL( ::bAction2 ) IMAGE { , ::cImageOk}
      ELSEIF HB_IsObject( ::oGrid ) .AND. ::oGrid:lButtons
         @ nRow, nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue FOCUSEDPOS ::nOnFocusPos ACTION EVAL( ::bCancel ) ACTION2 EVAL( ::bOK, -1 ) IMAGE {::cImageCancel, ::cImageOk}
      ELSE
         @ nRow, nCol TEXTBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue FOCUSEDPOS ::nOnFocusPos
      ENDIF
   ENDIF
   IF HB_IsBlock( ::bAction )
      ::oControl:oButton1:TabIndex := 2
   ELSEIF HB_IsBlock( ::bAction2 )
      ::oControl:oButton1:TabIndex := 2
   ELSEIF HB_IsObject( ::oGrid ) .AND. ::oGrid:lButtons
      ::oControl:oButton1:TabIndex := 2
   ENDIF

   RETURN ::oControl

CLASS TGridControlMemo FROM TGridControl

   DATA nDefHeight                INIT 84
   DATA cTitle                    INIT _OOHG_Messages( 1, 11 )
   DATA lCleanCRLF                INIT .F.
   DATA nWidth                    INIT 350
   DATA nHeight                   INIT 265
   DATA lSize                     INIT .F.
   DATA lNoHScroll                INIT .F.
   DATA Type                      INIT "TGRIDCONTROLMEMO" READONLY

   METHOD New
   METHOD CreateWindow
   METHOD CreateControl
   METHOD GridValue

   ENDCLASS

   /*
   COLUMNCONTROLS syntax:
   {'MEMO', cTitle, lCleanCRLF, nWidth, nHeight, lSize, lNoHScroll}
   */

METHOD New( cTitle, lCleanCRLF, oGrid, nWidth, nHeight, lSize, lNoHScroll ) CLASS TGridControlMemo

   IF ValType( cTitle ) $ "CM" .AND. ! Empty( cTitle )
      ::cTitle := cTitle
   ENDIF
   IF HB_IsLogical( lCleanCRLF )
      ::lCleanCRLF := lCleanCRLF
   ENDIF
   ::oGrid := oGrid
   IF HB_IsNumeric( nWidth ) .and. nWidth > 230
      ::nWidth := nWidth
   ENDIF
   IF HB_IsNumeric( nHeight ) .and. nHeight > 230
      ::nHeight := nHeight
   ENDIF
   IF HB_IsLogical( lSize )
      ::lSize := lSize
   ENDIF
   IF HB_IsLogical( lNoHScroll )
      ::lNoHScroll := lNoHScroll
   ENDIF

   RETURN Self

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, aKeys, oGrid ) CLASS TGridControlMemo

   LOCAL lRet := .F., i, oBut1, oBut2

   HB_SYMBOL_UNUSED( nWidth )
   HB_SYMBOL_UNUSED( nHeight )

   IF ::lSize

      DEFINE WINDOW 0 OBJ ::oWindow ;
            AT nRow, nCol ;
            WIDTH ::nWidth ;
            HEIGHT ::nHeight ;
            CLIENTAREA ;
            MINWIDTH 350 ;
            MINHEIGHT 265 ;
            TITLE ::cTitle ;
            MODAL ;
            ON SIZE ( ::oControl:Width := ::oWindow:ClientWidth - 20, ;
            ::oControl:Height := ::oWindow:ClientHeight - 90, ;
            i := Int( Max( ::oWindow:ClientWidth - 200, 0 ) / 3 ), ;
            oBut1:Row := ::oWindow:ClientHeight - 40, ;
            oBut1:Col := i, ;
            oBut2:Row := oBut1:Row, ;
            oBut2:Col := i + 100 + i )

      ELSE

         DEFINE WINDOW 0 OBJ ::oWindow ;
               AT nRow, nCol ;
               WIDTH ::nWidth ;
               HEIGHT ::nHeight ;
               CLIENTAREA ;
               TITLE ::cTitle ;
               MODAL ;
               NOSIZE

         ENDIF

         IF HB_IsObject( oGrid )
            ::oGrid := oGrid
            ::bOk := { |nPos| ::oGrid:bPosition := nPos, lRet := ::Valid() }
            ::bCancel := { || ::oGrid:bPosition := 0, ::oWindow:Release() }
         ELSE
            ::bOk := { || lRet := ::Valid() }
            ::bCancel := { || ::oWindow:Release() }
         ENDIF

         ON KEY ESCAPE OF ( ::oWindow ) ACTION EVAL( ::bCancel )

         IF HB_IsArray( aKeys )
            FOR i := 1 To Len( aKeys )
               IF HB_IsArray( aKeys[ i ] ) .AND. Len( aKeys[ i ] ) > 1 .AND. ValType( aKeys[ i, 1 ] ) $ "CM" .AND. HB_IsBlock( aKeys[ i, 2 ] ) .AND. ! aKeys[ i, 1 ] == "ESCAPE"
                  _DefineAnyKey( ::oWindow, aKeys[ i, 1 ], aKeys[ i, 2 ] )
               ENDIF
            NEXT
         ENDIF

         @ 07,10 LABEL 0 PARENT ( ::oWindow ) VALUE "" WIDTH 280

         ::CreateControl( uValue, ::oWindow:Name, 30, 10, ::oWindow:ClientWidth - 20, ::oWindow:ClientHeight - 90 )
         ::oControl:SetFont( cFontName, nFontSize )
         ::Value := ::ControlValue

         i := Int( Max( ::oWindow:ClientWidth - 200, 0 ) / 3 )

         @ ::oWindow:ClientHeight - 40,i BUTTON 0 OBJ oBut1 PARENT ( ::oWindow ) CAPTION _OOHG_Messages( 1, 6 ) ACTION EVAL( ::bOk, -1 )
         @ oBut1:Row,i + 100 + i BUTTON 0 OBJ oBut2 PARENT ( ::oWindow ) CAPTION _OOHG_Messages( 1, 7 ) ACTION EVAL( ::bCancel )
      END WINDOW

      ::oWindow:Center()
      ::oControl:SetFocus()
      ::oWindow:Activate()
      ::oWindow := Nil

      RETURN lRet

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlMemo

   IF ::lNoHScroll
      @ nRow,nCol EDITBOX 0 OBJ ::oControl PARENT ( cWindow ) VALUE StrTran( uValue, Chr(141), ' ' ) HEIGHT nHeight WIDTH nWidth NOHSCROLL
   ELSE
      @ nRow,nCol EDITBOX 0 OBJ ::oControl PARENT ( cWindow ) VALUE StrTran( uValue, Chr(141), ' ' ) HEIGHT nHeight WIDTH nWidth
   ENDIF

   RETURN ::oControl

METHOD GridValue( uValue ) CLASS TGridControlMemo

   LOCAL uRet

   IF ValType( uValue ) == "C"
      uRet := Trim( uValue )
   ELSEIF ValType( uValue ) == "M"
      IF ::lCleanCRLF
         uRet := StrTran( Trim( uValue ), Chr(13) + Chr(10), " " )
      ELSE
         uRet := Trim( uValue )
      ENDIF
   ELSE
      uRet := uValue
   ENDIF

   RETURN uRet

CLASS TGridControlDatePicker FROM TGridControl

   DATA lUpDown
   DATA lShowNone
   DATA Type                      INIT "TGRIDCONTROLDATEPICKER" READONLY

   METHOD New
   METHOD CreateWindow
   METHOD CreateControl
   METHOD Str2Val( uValue )   BLOCK { |Self, uValue| Empty( Self ), CtoD( uValue ) }
   METHOD GridValue( uValue ) BLOCK { |Self, uValue| Empty( Self ), DtoC( uValue ) }

   ENDCLASS

   /*
   COLUMNCONTROLS syntax:
   {'DATEPICKER', lUpDown, lShowNone, lButtons, aImages, lNoModal}
   */

METHOD New( lUpDown, lShowNone, lButtons, aImages, oGrid, lNoModal ) CLASS TGridControlDatePicker

   IF ! HB_IsLogical( lUpDown )
      lUpDown := .F.
   ENDIF
   ::lUpDown := lUpDown

   IF ! HB_IsLogical( lShowNone )
      lShowNone := .F.
   ENDIF
   ::lShowNone := lShowNone

   ASSIGN ::lButtons VALUE lButtons TYPE "L"
   IF HB_IsArray( aImages )
      IF Len( aImages ) < 2
         ASize( aImages, 2 )
      ENDIF
      ASSIGN ::cImageCancel VALUE aImages[ 1 ] TYPE "CM"
      ASSIGN ::cImageOk     VALUE aImages[ 2 ] TYPE "CM"
   ENDIF

   ::oGrid := oGrid

   ASSIGN ::lNoModal VALUE lNoModal TYPE "L"

   RETURN Self

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, aKeys, oGrid ) CLASS TGridControlDatePicker

   RETURN ::Super:CreateWindow( uValue, nRow - 3, nCol - 3, nWidth + 6, nHeight + 6, cFontName, nFontSize, aKeys, oGrid )

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlDatePicker

   IF ValType( uValue ) == "C"
      uValue := CtoD( uValue )
   ENDIF
   IF ::lUpDown
      IF ::lShowNone
         @ nRow,nCol DATEPICKER 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue UPDOWN SHOWNONE
      ELSE
         @ nRow,nCol DATEPICKER 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue UPDOWN
      ENDIF
   ELSE
      IF ::lShowNone
         @ nRow,nCol DATEPICKER 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue SHOWNONE
      ELSE
         @ nRow,nCol DATEPICKER 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue
      ENDIF
   ENDIF

   RETURN ::oControl

CLASS TGridControlComboBox FROM TGridControl

   DATA aItems                    INIT {}
   DATA aValues                   INIT Nil
   DATA cWorkArea                 INIT ""
   DATA cField                    INIT ""
   DATA cValueSource              INIT ""
   DATA cRetValType               INIT "N"   // Needed because cWorkArea can be not opened yet when ::New is first executed
   DATA Type                      INIT "TGRIDCONTROLCOMBOBOX" READONLY

   METHOD New
   METHOD CreateWindow
   METHOD CreateControl
   METHOD Str2Val
   METHOD GridValue
   METHOD Refresh

   ENDCLASS

   /*
   COLUMNCONTROLS syntax:
   {'COMBOBOX', aItems, aValues, cRetValType, lButtons, aImages, lNoModal}
   */

METHOD New( aItems, oGrid, aValues, cRetValType, lButtons, aImages, lNoModal ) CLASS TGridControlComboBox

   DEFAULT cRetValType TO "NUMERIC"
   IF HB_IsArray( aItems )
      ::aItems := aItems
      IF HB_IsArray( aValues ) .AND. Len( aValues ) > 0
         IF ValType( aValues[1] ) $ "CM"
            ::aValues := aValues
            ::cRetValType := "C"
         ELSEIF ValType( aValues[1] ) == "N"
            ::aValues := aValues
         ENDIF
      ENDIF
   ELSEIF ValType( aItems ) $ "CM" .AND. '->' $ aItems
      ::cWorkArea := Left( aItems, At( '->', aItems ) - 1 )
      ::cField := Right( aItems, Len( aItems ) - At( '->', aItems ) - 1 )
      IF ValType( aValues ) $ "CM"
         IF Upper( cRetValType ) == "CHARACTER"
            ::cValueSource := aValues
            ::cRetValType := "C"
         ELSEIF Upper( cRetValType ) == "NUMERIC"
            ::cValueSource := aValues
         ENDIF
      ENDIF
      ::Refresh()
   ENDIF
   ::oGrid := oGrid

   ASSIGN ::lButtons VALUE lButtons TYPE "L"
   IF HB_IsArray( aImages )
      IF Len( aImages ) < 2
         ASize( aImages, 2 )
      ENDIF
      ASSIGN ::cImageCancel VALUE aImages[ 1 ] TYPE "CM"
      ASSIGN ::cImageOk     VALUE aImages[ 2 ] TYPE "CM"
   ENDIF

   ASSIGN ::lNoModal VALUE lNoModal TYPE "L"

   RETURN Self

METHOD Refresh CLASS TGridControlComboBox

   LOCAL cValueSource, cWorkArea, cField, nRecno, aIt, aVa, uValue

   cWorkArea := ::cWorkArea
   cField := ::cField
   cValueSource := ::cValueSource
   IF Select( cWorkArea ) != 0
      nRecno := ( cWorkArea )->( RecNo() )
      ( cWorkArea )->( DBGoTop() )
      aIt := {}
      aVa := {}
      DO WHILE ! ( cWorkArea )->( Eof() )
         AAdd( aIt, ( cWorkArea )->&( cField ) )
         IF Empty( cValueSource )
            uValue := ( cWorkArea )->( RecNo() )
         ELSE
            uValue := &( cValueSource )
            IF ! ValType( uValue ) == ::cRetValType
               MsgOOHGError( "GridControl: ValueSource/RetVal type mismatch. Program terminated." )
            ENDIF
         ENDIF
         AAdd( aVa, uValue )
         ( cWorkArea )->( DBSkip() )
      ENDDO
      ( cWorkArea )->( DBGoTo( nRecno ) )
      ::aItems := aIt
      ::aValues := aVa
   ENDIF

   RETURN Self

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, aKeys, oGrid ) CLASS TGridControlComboBox

   RETURN ::Super:CreateWindow( uValue, nRow - 3, nCol - 3, nWidth + 6, nHeight + 6, cFontName, nFontSize, aKeys, oGrid )

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlComboBox

   HB_SYMBOL_UNUSED( nHeight )

   ::Refresh()
   @ nRow,nCol COMBOBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth VALUE uValue ITEMS ::aItems VALUESOURCE ( ::aValues )
   IF ! Empty( ::oGrid ) .AND. ValidHandler( ::oGrid:ImageList )
      ::oControl:ImageList := ImageList_Duplicate( ::oGrid:ImageList )
   ENDIF

   RETURN ::oControl

METHOD Str2Val( uValue ) CLASS TGridControlComboBox

   LOCAL xValue

   xValue := AScan( ::aItems, { |c| c == uValue } )
   IF HB_IsArray( ::aValues )
      IF xValue >= 1 .AND. xValue <= Len( ::aValues )
         xValue := ::aValues[ xValue ]
      ELSEIF ::cRetValType == "C"
         xValue := ""
      ELSE
         xValue := 0
      ENDIF
   ELSEIF ::cRetValType == "C"
      xValue := ""
   ENDIF

   RETURN xValue

METHOD GridValue( uValue ) CLASS TGridControlComboBox

   IF HB_IsArray( ::aValues )
      uValue := AScan( ::aValues, { |c| c == uValue } )
   ELSEIF ! ValType( uValue ) == "N"
      uValue := 0
   ENDIF

   RETURN If( ( uValue >= 1 .AND. uValue <= Len( ::aItems ) ), ::aItems[ uValue ], "" )

CLASS TGridControlComboBoxText FROM TGridControl

   DATA aItems                    INIT {}
   DATA lIncremental              INIT .F.
   DATA lWinSize                  INIT .F.
   DATA Type                      INIT "TGRIDCONTROLCOMBOBOXTEXT" READONLY

   METHOD New
   METHOD CreateWindow
   METHOD CreateControl
   METHOD Str2Val
   METHOD GridValue( uValue )     BLOCK { |Self, uValue| ::Str2Val( uValue ) }
   METHOD ControlValue            SETGET

   ENDCLASS

   /*
   COLUMNCONTROLS syntax:
   {'COMBOBOXTEXT', aItems, lIncremental, lWinSize, lButtons, aImages, lNoModal}
   */

METHOD New( aItems, oGrid, lIncremental, lWinSize, lButtons, aImages, lNoModal ) CLASS TGridControlComboBoxText

   ASSIGN ::lIncremental VALUE lIncremental TYPE "L" DEFAULT .F.
   ASSIGN ::lWinSize     VALUE lWinSize     TYPE "L" DEFAULT .F.
   IF HB_IsArray( aItems )
      ::aItems := Array( Len( aItems ) )
      AEval( aItems, { |x,i| ::aItems[ i ] := Trim( x ) } )
   ENDIF
   ::oGrid := oGrid

   ASSIGN ::lButtons VALUE lButtons TYPE "L"
   IF HB_IsArray( aImages )
      IF Len( aImages ) < 2
         ASize( aImages, 2 )
      ENDIF
      ASSIGN ::cImageCancel VALUE aImages[ 1 ] TYPE "CM"
      ASSIGN ::cImageOk     VALUE aImages[ 2 ] TYPE "CM"
   ENDIF

   ASSIGN ::lNoModal VALUE lNoModal TYPE "L"

   RETURN Self

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, aKeys, oGrid ) CLASS TGridControlComboBoxText

   RETURN ::Super:CreateWindow( uValue, nRow - 3, nCol - 3, nWidth + 6, nHeight + 6, cFontName, nFontSize, aKeys, oGrid )

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlComboBoxText

   HB_SYMBOL_UNUSED( nHeight )

   uValue := AScan( ::aItems, { |c| c == uValue } )
   IF ::lIncremental
      IF ::lWinSize
         @ nRow,nCol COMBOBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth VALUE uValue ITEMS ::aItems INTEGRALHEIGHT INCREMENTAL
      ELSE
         @ nRow,nCol COMBOBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth VALUE uValue ITEMS ::aItems INCREMENTAL
      ENDIF
   ELSE
      IF ::lWinSize
         @ nRow,nCol COMBOBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth VALUE uValue ITEMS ::aItems INTEGRALHEIGHT
      ELSE
         @ nRow,nCol COMBOBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth VALUE uValue ITEMS ::aItems
      ENDIF
   ENDIF
   IF ! Empty( ::oGrid ) .AND. ValidHandler( ::oGrid:ImageList )
      ::oControl:ImageList := ImageList_Duplicate( ::oGrid:ImageList )
   ENDIF

   RETURN ::oControl

METHOD Str2Val( uValue ) CLASS TGridControlComboBoxText

   LOCAL nPos

   nPos := AScan( ::aItems, { |c| c == Trim( uValue ) } )

   RETURN If( nPos == 0, "", ::aItems[ nPos ] )

METHOD ControlValue( uValue ) CLASS TGridControlComboBoxText

   LOCAL nPos

   IF PCount() >= 1
      ::oControl:Value := ::Str2Val( uValue )
   ENDIF
   nPos := ::oControl:Value

   RETURN If( nPos == 0, "", ::aItems[ nPos ] )

CLASS TGridControlSpinner FROM TGridControl

   DATA nRangeMin                 INIT 0
   DATA nRangeMax                 INIT 100
   DATA Type                      INIT "TGRIDCONTROLSPINNER" READONLY

   METHOD New
   METHOD CreateWindow
   METHOD CreateControl
   METHOD Str2Val( uValue )       BLOCK { |Self, uValue| Empty( Self ), Val( AllTrim( uValue ) ) }
   METHOD GridValue( uValue)      BLOCK { |Self, uValue| Empty( Self ), LTrim( Str( uValue ) ) }

   ENDCLASS

   /*
   COLUMNCONTROLS syntax:
   {'SPINNER', nRangeMin, nRangeMax, lButtons, aImages, lNoModal}
   */

METHOD New( nRangeMin, nRangeMax, lButtons, aImages, oGrid, lNoModal ) CLASS TGridControlSpinner

   IF HB_IsNumeric( nRangeMin )
      ::nRangeMin := nRangeMin
   ENDIF
   IF HB_IsNumeric( nRangeMax )
      ::nRangeMax := nRangeMax
   ENDIF

   ASSIGN ::lButtons VALUE lButtons TYPE "L"
   IF HB_IsArray( aImages )
      IF Len( aImages ) < 2
         ASize( aImages, 2 )
      ENDIF
      ASSIGN ::cImageCancel VALUE aImages[ 1 ] TYPE "CM"
      ASSIGN ::cImageOk     VALUE aImages[ 2 ] TYPE "CM"
   ENDIF

   ::oGrid := oGrid

   ASSIGN ::lNoModal VALUE lNoModal TYPE "L"

   RETURN Self

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, aKeys, oGrid ) CLASS TGridControlSpinner

   RETURN ::Super:CreateWindow( uValue, nRow - 3, nCol - 3, nWidth + 6, nHeight + 6, cFontName, nFontSize, aKeys, oGrid )

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlSpinner

   IF ValType( uValue ) == "C"
      uValue := Val( uValue )
   ENDIF
   @ nRow,nCol SPINNER 0 OBJ ::oControl PARENT ( cWindow ) RANGE ::nRangeMin, ::nRangeMax WIDTH nWidth HEIGHT nHeight VALUE uValue

   RETURN ::oControl

CLASS TGridControlCheckBox FROM TGridControl

   DATA cTrue                     INIT ".T."
   DATA cFalse                    INIT ".F."
   DATA Type                      INIT "TGRIDCONTROLCHECKBOX" READONLY

   METHOD New
   METHOD CreateWindow
   METHOD CreateControl
   METHOD Str2Val( uValue )       BLOCK { |Self, uValue| ( uValue == ::cTrue .OR. Upper( uValue ) == ".T." ) }
   METHOD GridValue( uValue )     BLOCK { |Self, uValue| If( uValue, ::cTrue, ::cFalse ) }

   ENDCLASS

   /*
   COLUMNCONTROLS syntax:
   {'CHECKBOX', cTrue, cFalse, lButtons, aImages, lNoModal}
   */

METHOD New( cTrue, cFalse, lButtons, aImages, oGrid, lNoModal ) CLASS TGridControlCheckBox

   IF ValType( cTrue ) $ "CM"
      ::cTrue := cTrue
   ENDIF
   IF ValType( cFalse ) $ "CM"
      ::cFalse := cFalse
   ENDIF

   ASSIGN ::lButtons VALUE lButtons TYPE "L"
   IF HB_IsArray( aImages )
      IF Len( aImages ) < 2
         ASize( aImages, 2 )
      ENDIF
      ASSIGN ::cImageCancel VALUE aImages[ 1 ] TYPE "CM"
      ASSIGN ::cImageOk     VALUE aImages[ 2 ] TYPE "CM"
   ENDIF

   ::oGrid := oGrid

   ASSIGN ::lNoModal VALUE lNoModal TYPE "L"

   RETURN Self

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, aKeys, oGrid ) CLASS TGridControlCheckBox

   RETURN ::Super:CreateWindow( uValue, nRow - 3, nCol - 3, nWidth + 6, nHeight + 6, cFontName, nFontSize, aKeys, oGrid )

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlCheckBox

   IF ValType( uValue ) == "C"
      uValue := ( uValue == ::cTrue .OR. Upper( uValue ) == ".T." )
   ENDIF
   @ nRow,nCol CHECKBOX 0 OBJ ::oControl PARENT ( cWindow ) CAPTION If( uValue, ::cTrue, ::cFalse ) WIDTH nWidth HEIGHT nHeight VALUE uValue ;
      ON CHANGE ( ::oControl:Caption := If( ::oControl:Value, ::cTrue, ::cFalse ) )

   RETURN ::oControl

CLASS TGridControlImageList FROM TGridControl

   DATA Type                      INIT "TGRIDCONTROLIMAGELIST" READONLY

   METHOD New
   METHOD CreateWindow
   METHOD CreateControl
   METHOD Str2Val( uValue )       BLOCK { |Self, uValue| Empty( Self ), If( ValType( uValue ) == "C", Val( uValue ), uValue ) }
   METHOD ControlValue            SETGET

   ENDCLASS

   /*
   COLUMNCONTROLS syntax:
   {'IMAGELIST', lButtons, aImages, lNoModal}
   */

METHOD New( oGrid, lButtons, aImages, lNoModal ) CLASS TGridControlImageList

   ::oGrid := oGrid
   IF ! Empty( ::oGrid ) .AND. ValidHandler( ::oGrid:ImageList )
      ::nDefHeight := ImageList_Size( ::oGrid:ImageList )[ 2 ] + 6
   ENDIF

   ASSIGN ::lButtons VALUE lButtons TYPE "L"
   IF HB_IsArray( aImages )
      IF Len( aImages ) < 2
         ASize( aImages, 2 )
      ENDIF
      ASSIGN ::cImageCancel VALUE aImages[ 1 ] TYPE "CM"
      ASSIGN ::cImageOk     VALUE aImages[ 2 ] TYPE "CM"
   ENDIF

   ASSIGN ::lNoModal VALUE lNoModal TYPE "L"

   RETURN Self

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, aKeys, oGrid ) CLASS TGridControlImageList

   RETURN ::Super:CreateWindow( uValue, nRow - 3, nCol - 3, nWidth + 6, nHeight + 6, cFontName, nFontSize, aKeys, oGrid )

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlImageList

   HB_SYMBOL_UNUSED( nHeight )

   IF ValType( uValue ) == "C"
      uValue := Val( uValue )
   ENDIF
   IF ! Empty( ::oGrid ) .AND. ValidHandler( ::oGrid:ImageList )
      @ nRow,nCol COMBOBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth VALUE 0 ITEMS {} IMAGE {} TEXTHEIGHT ImageList_Size( ::oGrid:ImageList )[ 2 ]
      ::oControl:ImageList := ImageList_Duplicate( ::oGrid:ImageList )
      AEval( Array( ImageList_GetImageCount( ::oGrid:ImageList ) ), { |x,i| ::oControl:AddItem( i - 1 ), x } )
   ELSE
      @ nRow,nCol COMBOBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth VALUE 0 ITEMS {}
   ENDIF
   ::oControl:Value := uValue + 1

   RETURN ::oControl

METHOD ControlValue( uValue ) CLASS TGridControlImageList

   IF PCount() >= 1
      ::oControl:Value := uValue + 1
   ENDIF

   RETURN ::oControl:Value - 1

CLASS TGridControlImageData FROM TGridControl

   DATA Type                      INIT "TGRIDCONTROLIMAGEDATA" READONLY
   DATA oData

   METHOD New
   METHOD CreateWindow
   METHOD CreateControl
   METHOD ControlValue            SETGET
   METHOD OnLostFocus             SETGET
   METHOD Enabled                 SETGET

   ENDCLASS

   /*
   COLUMNCONTROLS syntax:
   {'IMAGEDATA', oData, lButtons, aImages, lNoModal}
   */

METHOD New( oGrid, oData, lButtons, aImages, lNoModal ) CLASS TGridControlImageData

   ::oGrid := oGrid
   IF oData == Nil
      oData := TGridControlTextBox():New
   ENDIF
   ::oData := oData

   ASSIGN ::lButtons VALUE lButtons TYPE "L"
   IF HB_IsArray( aImages )
      IF Len( aImages ) < 2
         ASize( aImages, 2 )
      ENDIF
      ASSIGN ::cImageCancel VALUE aImages[ 1 ] TYPE "CM"
      ASSIGN ::cImageOk     VALUE aImages[ 2 ] TYPE "CM"
   ENDIF

   ASSIGN ::lNoModal VALUE lNoModal TYPE "L"

   RETURN Self

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, aKeys, oGrid ) CLASS TGridControlImageData

   RETURN ::Super:CreateWindow( uValue, nRow - 3, nCol - 3, nWidth + 6, nHeight + 6, cFontName, nFontSize, aKeys, oGrid )

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlImageData

   LOCAL oCData, oCImage, nSize

   IF ValType( uValue[ 2 ] ) == "C"
      uValue[ 2 ] := Val( uValue[ 2 ] )
   ENDIF
   nSize := LoWord( GetDialogBaseUnits() ) + GetVScrollBarWidth()
   nHeight := 6
   IF ! Empty( ::oGrid ) .AND. ValidHandler( ::oGrid:ImageList )
      nSize += ImageList_Size( ::oGrid:ImageList )[ 1 ]
      nHeight += ImageList_Size( ::oGrid:ImageList )[ 2 ]
      @ nRow,nCol COMBOBOX 0 OBJ oCImage PARENT ( cWindow ) WIDTH nSize VALUE 0 ITEMS {} IMAGE {} TEXTHEIGHT ImageList_Size( ::oGrid:ImageList )[ 2 ]
      oCImage:ImageList := ImageList_Duplicate( ::oGrid:ImageList )
      AEval( Array( ImageList_GetImageCount( ::oGrid:ImageList ) ), { |x,i| oCImage:AddItem( i - 1 ), x } )
   ELSE
      @ nRow,nCol COMBOBOX 0 OBJ oCImage PARENT ( cWindow ) WIDTH nSize VALUE 0 ITEMS {}
   ENDIF
   oCData := ::oData:CreateControl( uValue[ 1 ], cWindow, nRow, nCol + nSize, nWidth - nSize, nHeight )
   ::oControl := { oCData, oCImage }
   oCImage:Value := uValue[ 2 ] + 1

   RETURN ::oControl

METHOD ControlValue( uValue ) CLASS TGridControlImageData

   LOCAL oCData, oCImage

   oCData := ::oControl[1]
   oCImage := ::oControl[2]
   IF PCount() >= 1
      oCData:value := uValue[1]
      oCImage:value := uValue[2] + 1
   ENDIF

   RETURN { oCData:Value, oCImage:value - 1 }

METHOD OnLostFocus( uValue ) CLASS TGridControlImageData

   LOCAL oCData

   oCData := ::oControl[1]
   IF PCount() >= 1
      oCData:OnLostFocus := uValue
   ENDIF

   RETURN oCData:OnLostFocus

METHOD Enabled( uValue ) CLASS TGridControlImageData

   LOCAL oCData

   oCData := ::oControl[1]

   RETURN ( oCData:Enabled := uValue )

CLASS TGridControlLComboBox FROM TGridControl

   DATA cTrue                     INIT ".T."
   DATA cFalse                    INIT ".F."
   DATA Type                      INIT "TGRIDCONTROLLCOMBOBOX" READONLY

   METHOD New
   METHOD CreateWindow
   METHOD CreateControl
   METHOD Str2Val( uValue )       BLOCK { |Self, uValue| ( uValue == ::cTrue .OR. Upper( uValue ) == ".T." ) }
   METHOD GridValue( uValue )     BLOCK { |Self, uValue| If( uValue, ::cTrue, ::cFalse ) }
   METHOD ControlValue            SETGET

   ENDCLASS

   /*
   COLUMNCONTROLS syntax:
   {'LCOMBOBOX', cTrue, cFalse, lButtons, aImages, lNoModal}
   */

METHOD New( cTrue, cFalse, lButtons, aImages, oGrid, lNoModal ) CLASS TGridControlLComboBox

   IF ValType( cTrue ) $ "CM"
      ::cTrue := cTrue
   ENDIF
   IF ValType( cFalse ) $ "CM"
      ::cFalse := cFalse
   ENDIF

   ASSIGN ::lButtons VALUE lButtons TYPE "L"
   IF HB_IsArray( aImages )
      IF Len( aImages ) < 2
         ASize( aImages, 2 )
      ENDIF
      ASSIGN ::cImageCancel VALUE aImages[ 1 ] TYPE "CM"
      ASSIGN ::cImageOk     VALUE aImages[ 2 ] TYPE "CM"
   ENDIF

   ::oGrid := oGrid

   ASSIGN ::lNoModal VALUE lNoModal TYPE "L"

   RETURN Self

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, aKeys, oGrid ) CLASS TGridControlLComboBox

   RETURN ::Super:CreateWindow( uValue, nRow - 3, nCol - 3, nWidth + 6, nHeight + 6, cFontName, nFontSize, aKeys, oGrid )

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlLComboBox

   HB_SYMBOL_UNUSED( nHeight )

   IF ValType( uValue ) == "C"
      uValue := ( uValue == ::cTrue .OR. Upper( uValue ) == ".T." )
   ENDIF
   uValue := If( uValue, 1, 2 )
   @ nRow,nCol COMBOBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth VALUE uValue ITEMS { ::cTrue, ::cFalse }

   RETURN ::oControl

METHOD ControlValue( uValue ) CLASS TGridControlLComboBox

   IF PCount() >= 1
      ::oControl:Value := If( uValue, 1, 2 )
   ENDIF

   RETURN ( ::oControl:Value == 1 )

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

#ifndef HB_OS_WIN_32_USED
   #define HB_OS_WIN_32_USED
#endif

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
#include <windowsx.h>
#include <commctrl.h>
#include "oohg.h"

#ifndef LVS_EX_DOUBLEBUFFER
   #define LVS_EX_DOUBLEBUFFER 0x00010000
#endif

#ifndef WM_MOUSEWHEEL
   #define WM_MOUSEWHEEL  0x020A
#endif

#define s_Super s_TControl

// -----------------------------------------------------------------------------
HB_FUNC_STATIC( TGRID_EVENTS )   // METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TGrid
// -----------------------------------------------------------------------------
{
   HWND hWnd = HWNDparam( 1 );
   UINT message = (UINT ) hb_parni( 2 );
   WPARAM wParam = (WPARAM) hb_parni( 3 );
   LPARAM lParam = (LPARAM) hb_parnl( 4 );
   PHB_ITEM pSelf = hb_stackSelfItem();
   static PHB_SYMB s_Events2 = 0;                             //  TODO: Thread safe ?
   static PHB_SYMB s_Notify2 = 0;                             //  TODO: Thread safe ?
   BOOL bDefault = TRUE;

   switch( message )
   {
      case WM_MOUSEWHEEL:
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
            if( HB_ISNUM( -1 ) )
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

HB_FUNC( LISTVIEW_GETCOLUMNORDER )
{
   HWND hWnd = HWNDparam( 1 );
   int iCount, n;
   int *nArray;

   if( ValidHandler( hWnd ) )
   {
      iCount = Header_GetItemCount( ListView_GetHeader( hWnd ) );
      nArray = (int *) hb_xgrab( ( iCount ) * sizeof( int ) );

      if( ListView_GetColumnOrderArray( hWnd, (WPARAM) iCount, (LPARAM) (LPINT) nArray ) )
      {
         hb_reta( iCount );
         for( n = 0; n < iCount; n++ )
         {
            HB_STORNI( nArray[ n ] + 1, -1, n + 1 );
         }

         hb_xfree( nArray );
      }
      else
      {
         hb_xfree( nArray );

         hb_reta( 0 );
      }
   }
   else
   {
      hb_reta( 0 );
   }
}

HB_FUNC_STATIC( LISTVIEW_SETCOLUMNORDER )
{
   HWND hWnd = HWNDparam( 1 );
   int iCount, n;
   int *iArray;
   PHB_ITEM nArray;
   BOOL bRet = FALSE;

   if( ValidHandler( hWnd ) && HB_ISARRAY( 2 ) )
   {
      iCount = Header_GetItemCount( ListView_GetHeader( hWnd ) );

      if( (int) hb_parinfa( 2, 0 ) == iCount )
      {
         iArray = (int *) hb_xgrab( ( iCount ) * sizeof( int ) );
         nArray = hb_param( 2, HB_IT_ARRAY );

         for( n = 1; n <= iCount; n++ )
         {
            iArray[ n - 1 ] = hb_arrayGetNI( nArray, n ) - 1;
         }

         bRet = ListView_SetColumnOrderArray( hWnd, (WPARAM) iCount, (LPARAM) (LPINT) iArray );

         hb_xfree( iArray );
      }
   }

   hb_retl( bRet );
}

static WNDPROC lpfnOldWndProc = 0;                      //  TODO: Thread safe ?

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{

   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

HB_FUNC( EXECOLDWNDPROC )
{
   hb_retnl( (LRESULT) CallWindowProc( lpfnOldWndProc, HWNDparam( 1 ), (UINT) hb_parni( 2 ), (WPARAM) hb_parnl( 3 ), (LPARAM) hb_parnl( 4 ) ) );
}

HB_FUNC( INITLISTVIEW )
{
   HWND hwnd;
   int style, StyleEx, extStyle;
   INITCOMMONCONTROLSEX i;
   int iCol, iRow, iWidth, iHeight, iNewRow;
   BOOL bVisible;

   i.dwSize = sizeof( INITCOMMONCONTROLSEX );
   i.dwICC = ICC_DATE_CLASSES;
   InitCommonControlsEx( &i );

   StyleEx = WS_EX_CLIENTEDGE | _OOHG_RTL_Status( hb_parl( 13 ) );

   style = WS_CHILD | LVS_REPORT | hb_parni( 12 );
   if ( hb_parl( 10 ) )
   {
      style = style | LVS_OWNERDATA;
   }

   // control must have WS_VISIBLE style or it may not be painted properly

   bVisible = ( style & WS_VISIBLE );

   iCol = hb_parni(3);
   iRow = hb_parni(4);
   iWidth = hb_parni(5);
   iHeight = hb_parni(6);

   iNewRow = iRow;

   if( ! bVisible )
   {
      style = style | WS_VISIBLE;
      iRow = - 1000 - iRow;
   }

   hwnd = CreateWindowEx( StyleEx, "SysListView32", "", style,
                          iCol, iRow, iWidth, iHeight,
                          HWNDparam( 1 ), (HMENU) HWNDparam( 2 ), GetModuleHandle( NULL ), NULL ) ;

   extStyle = hb_parni(9) | LVS_EX_FULLROWSELECT | LVS_EX_HEADERDRAGDROP | LVS_EX_SUBITEMIMAGES;
   if ( hb_parl( 14 ) )
   {
      extStyle = extStyle | LVS_EX_CHECKBOXES;
   }
   if ( hb_parl( 15 ) )
   {
      extStyle = extStyle | LVS_EX_DOUBLEBUFFER;
   }
   SendMessage( hwnd, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, extStyle );

   if( ! bVisible )
   {
      SetWindowLong( hwnd, GWL_STYLE, style & ( ~ WS_VISIBLE ) );
      MoveWindow( hwnd, iCol, iNewRow, iWidth, iHeight, TRUE );
   }

   if ( hb_parl( 10 ) )
   {
      ListView_SetItemCount( hwnd, hb_parni( 11 ) ) ;
   }

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( hwnd, GWL_WNDPROC, ( LONG ) SubClassFunc );

   HWNDret( hwnd );
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
   int iOld, iNew;

   COL.mask = LVCF_FMT;
   ListView_GetColumn( HWNDparam( 1 ), hb_parni( 2 ) - 1, &COL );
   iOld = ( COL.fmt & LVCFMT_JUSTIFYMASK );

   iNew = ( hb_parni( 3 ) & LVCFMT_JUSTIFYMASK );

   if( ( iNew == iOld ) || ( iNew == LVCFMT_JUSTIFYMASK ) )
   {
      hb_retni( iOld );
   }
   else
   {
      COL.fmt &= ~ ( COL.fmt & LVCFMT_JUSTIFYMASK );
      COL.fmt |= iNew;

      if( ListView_SetColumn( HWNDparam( 1 ), hb_parni( 2 ) - 1, &COL ) )
      {
         hb_retni( iNew );
      }
      else
      {
         hb_retni( iOld );
      }
   }
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

HB_FUNC( GETHEADER )
{
   HWNDret( ListView_GetHeader( HWNDparam( 1 ) ) );
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

   COL.mask &= ~LVCF_IMAGE;
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
   int nItem;

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
   nItem = ListView_InsertItem( h, &LI );

   if( nItem > -1 )
   {
      _OOHG_ListView_FillItem( h, nItem, hArray );
   }

   hb_retni( nItem + 1 );
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
   nItem = ListView_InsertItem( h, &LI );

   if( nItem > -1)
   {
      _OOHG_ListView_FillItem( h, nItem, hArray );
   }

   hb_retni( nItem + 1 );
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

   if( iType == 1 && HB_ISCHAR( 5 ) )
   {
      LI.cchTextMax = 1022;
      LI.pszText = ( char * ) hb_parc( 5 );
      ListView_SetItem( hWnd, &LI );
   }
   else if( iType == 2 && HB_ISNUM( 5 ) )
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

PFNLVCOMPARE CALLBACK _OOHG_SortItemsUser( LPARAM lParam1, LPARAM lParam2, LPARAM lParamSort )
{
   _OOHG_Send( (PHB_ITEM) lParamSort, s_CompareItems );
   hb_vmPushLong( (LONG) lParam1 + 1 );
   hb_vmPushLong( (LONG) lParam2 + 1 );
   hb_vmSend( 2 );

   return (PFNLVCOMPARE) hb_parni( -1 );
}

HB_FUNC( LISTVIEW_SORTITEMSEX_USER )
{
   PHB_ITEM pSelf = hb_param( 1, HB_IT_OBJECT );
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   hb_retni( SendMessage( oSelf->hWnd, LVM_SORTITEMSEX, (WPARAM) pSelf, (LPARAM) (PFNLVCOMPARE) _OOHG_SortItemsUser ) );
}

HB_FUNC( NMHEADER_IITEM )
{
   hb_retnl( ( LONG ) ( ( ( NMHEADER * ) hb_parnl( 1 ) )->iItem ) + 1 );
}

HB_FUNC( HDITEM_CXY )
{
   hb_retni( ( int ) ( ( ( ( NMHEADER * ) hb_parnl( 1 ) )->pitem )->cxy ) );
}

HB_FUNC( SET_HDITEM_CXY )
{
   ( ( ( NMHEADER * ) hb_parnl( 1 ) )->pitem )->cxy = hb_parni( 2 );
}

HB_FUNC( HDITEM_IORDER )
{
   hb_retni( ( int ) ( ( ( ( NMHEADER * ) hb_parnl( 1 ) )->pitem )->iOrder + 1 ) );
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
   ListView_SetItemState( HWNDparam( 1 ), ( WPARAM ) ( hb_parni( 2 ) - 1 ), LVIS_FOCUSED | LVIS_SELECTED, LVIS_FOCUSED | LVIS_SELECTED );
}

HB_FUNC( LISTVIEW_CLEARCURSEL )
{
   ListView_SetItemState( HWNDparam( 1 ), ( WPARAM ) ( hb_parni( 2 ) - 1 ), 0, LVIS_FOCUSED | LVIS_SELECTED );
}

HB_FUNC( LISTVIEWDELETESTRING )
{
   hb_retl( ListView_DeleteItem( HWNDparam( 1 ), (WPARAM) ( hb_parni( 2 ) - 1 ) ) );
}

HB_FUNC( LISTVIEWRESET )
{
   hb_retl( ListView_DeleteAllItems( HWNDparam( 1 ) ) );
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
   hb_retl( ListView_EnsureVisible( HWNDparam( 1 ), hb_parni( 2 ) - 1, FALSE ) );
}

HB_FUNC( LISTVIEW_ISITEMVISIBLE )
{
   HWND hwnd = HWNDparam( 1 );
   int iItem = hb_parni( 2 ) - 1;
   int iTop = ListView_GetTopIndex( hwnd );

   hb_retl( ( iItem >= iTop ) && ( iItem <= iTop + ListView_GetCountPerPage( hwnd ) - 1 ) );
}

HB_FUNC( LISTVIEW_GETTOPINDEX )
{
   hb_retnl( ListView_GetTopIndex( HWNDparam( 1 ) ) + 1 );
}

HB_FUNC( LISTVIEW_REDRAWITEMS )
{
   hb_retnl( ListView_RedrawItems( HWNDparam( 1 ), hb_parni( 2 ) - 1, hb_parni( 3 ) - 1 ) );
}

HB_FUNC( LISTVIEW_ITEMACTIVATE )
{
   LPNMITEMACTIVATE pData = ( NMITEMACTIVATE * ) hb_parnl( 1 );

   hb_reta( 2 );
   HB_STORNI( pData->iItem + 1, -1, 1 );
   HB_STORNI( pData->iSubItem + 1, -1, 2 );
}

HB_FUNC( LISTVIEW_LISTVIEW )
{
   LPNMLISTVIEW pData = ( NMLISTVIEW * ) hb_parnl( 1 );

   hb_reta( 2 );
   HB_STORNI( pData->iItem + 1, -1, 1 );
   HB_STORNI( pData->iSubItem + 1, -1, 2 );
}

HB_FUNC( LISTVIEW_HITTEST )
{
   POINT point;
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

HB_FUNC( GET_XY_LPARAM )
{
   POINT point;

   point.x = GET_X_LPARAM( hb_parnl( 1 ) );
   point.y = GET_Y_LPARAM( hb_parnl( 1 ) );

   hb_reta( 2 );
   HB_STORNI( point.y, -1, 1 );
   HB_STORNI( point.x, -1, 2 );
}

HB_FUNC( HEADER_HITTEST )
{
   int i, index;
   RECT rc;
   POINT point;
   HWND hWnd = HWNDparam( 1 );

   DWORD dwpos = GetMessagePos();

   point.x = GET_X_LPARAM( dwpos );
   point.y = GET_Y_LPARAM( dwpos );

   ScreenToClient( hWnd, &point );

   index = -1;
   for( i = 0; Header_GetItemRect( hWnd, i, &rc ); i ++ )
   {
      if( PtInRect( &rc, point ) )
      {
         index = i;
         break;
      }
   }

   hb_retni( index + 1 );
}

HB_FUNC( LISTVIEW_HITONCHECKBOX )
{
   /*
    * The default behaviour of listview is a little odd because it does not limit the toggle
    * of a checkbox to the clicks done inside it (or in it's borders). Sometimes it's toggle
    * when the click is done in the outside of the checkbox, and other times a click inside
    * it is ignored. This happens because the checkbox is drawn in an area different than
    * the defined state area (thus renders the LVHT_ONITEMSTATEICON flag useless).
    * The width of the state area is defined by the state imagelist width (XP=16 Win7=13)
    * and the height equals the height of the row. The checkbox dimensions are 13x13.
    * Under Win7 the clickable zone of the checkbox does not include it's rightmost 2 pixels.
    * Under WinXP the gap between the item's state image area and the item's icon area is
    * 2 pixels wide. Under Win7 is only 1 pixel wide.
    * Win7 places the checkbox centered in the y axe, but instead of using it's real height
    * it uses 16. XP uses a fixed 4 pixel margin.
    * The listview, as far as I know, exports no way of knowing the checkbox's rect nor
    * the size of the aforementioned gap.
    */
   POINT point ;
   LVHITTESTINFO lvhti;
   int item, cx, cy, chkWidth, gapWidth, margin;
   RECT rcIcon;
   LPRECT lprcIcon = &rcIcon;
   OSVERSIONINFO osvi;

   point.y = hb_parni( 2 );
   point.x = hb_parni( 3 );

   lvhti.pt = point;

   ListView_SubItemHitTest( HWNDparam( 1 ), &lvhti );

   if( lvhti.iSubItem == 0)
   {
      ListView_GetSubItemRect( HWNDparam( 1 ), lvhti.iItem, lvhti.iSubItem, LVIR_ICON, lprcIcon );

      ImageList_GetIconSize( ListView_GetImageList( HWNDparam( 1 ), LVSIL_STATE ), &cx, &cy );

      osvi.dwOSVersionInfoSize = sizeof( OSVERSIONINFO );
      GetVersionEx( (OSVERSIONINFO *) &osvi );

      if( osvi.dwMajorVersion >= 6 )                   // Win Vista or later
      {
         chkWidth = cx;
         gapWidth = 1;

         if( ( rcIcon.left - gapWidth > point.x ) && ( point.x >= rcIcon.left - chkWidth - gapWidth ) )
         {
            margin = ( rcIcon.bottom - rcIcon.top - chkWidth - 3 ) / 2;

            if( ( rcIcon.bottom - margin > point.y ) && ( point.y >= rcIcon.bottom - margin - chkWidth ) )
            {
               item = lvhti.iItem + 1;
            }
            else
            {
              item = -1;
            }
         }
         else
         {
            item = -1;
         }
      }
      else                                             // XP or older
      {
         chkWidth = cx - 3;
         gapWidth = 2;

         if( ( rcIcon.left - gapWidth > point.x ) && ( point.x >= rcIcon.left - chkWidth - gapWidth ) )
         {
            margin = 4;

            if( ( rcIcon.top + margin + chkWidth > point.y ) && ( point.y >= rcIcon.top + margin ) )
            {
               item = lvhti.iItem + 1;
            }
            else
            {
               item = -1;
            }
         }
         else
         {
            item = -1;
         }
      }
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
   HWND hWnd = HWNDparam( 1 );

   /*
    * For first column, LVIR_BOUNDS always returns left == 0 and right == sum of all columns' widths
    * As a workaround use LVIR_LABEL to get the subitem's right and compute it's left
    * by substracting the column's width.
    */
   ListView_GetSubItemRect( hWnd, hb_parni( 2 ), hb_parni( 3 ), LVIR_LABEL, lpRect );
   Rect.left = Rect.right - ListView_GetColumnWidth( hWnd, hb_parni( 3 ) );

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

   if( ListView_GetItemRect( HWNDparam( 1 ), hb_parni( 2 ), lpRect, LVIR_LABEL ) )
   {
      hb_reta( 4 );
      HB_STORNI( Rect.top, -1, 1 );
      HB_STORNI( Rect.left, -1, 2 );
      HB_STORNI( Rect.right - Rect.left, -1, 3 );
      HB_STORNI( Rect.bottom - Rect.top, -1, 4 );
   }
   else
   {
      hb_reta( 4 );
      HB_STORNI( -1, -1, 1 );
      HB_STORNI( -1, -1, 2 );
      HB_STORNI( -1, -1, 3 );
      HB_STORNI( -1, -1, 4 );
   }
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
   int iWidth;

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

   if( hb_parl( 6 ) )
   {
      iWidth = ListView_GetColumnWidth( hwnd, iColumn ) + 1;
      ListView_SetColumnWidth( hwnd, iColumn, iWidth );
      ListView_SetColumnWidth( hwnd, iColumn, iWidth - 1 );
   }
   else
   {
      SendMessage( hwnd, LVM_DELETEALLITEMS, 0, 0 );
      RedrawWindow( hwnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
   }
}

HB_FUNC( LISTVIEW_SETCOLUMN )
{
   LV_COLUMN COL;
   int iColumn = hb_parni( 2 ) - 1;
   HWND hwnd = HWNDparam( 1 );

   if( iColumn < 0 || iColumn > Header_GetItemCount( ListView_GetHeader( hwnd ) ) )
   {

      return;
   }

   COL.mask = LVCF_WIDTH | LVCF_TEXT | LVCF_FMT | LVCF_SUBITEM; // | LVCF_IMAGE;
   COL.cx = hb_parni( 3 );
   COL.pszText = ( char * ) hb_parc( 4 );
   COL.iSubItem = iColumn;
   COL.fmt = hb_parni( 5 ); // | LVCFMT_IMAGE;

   ListView_SetColumn( hwnd, iColumn, &COL );

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
   ExitProcess( 1 );

   return 0;
}

int TGrid_Notify_CustomDraw( PHB_ITEM pSelf, LPARAM lParam, BOOL bByCell, int iRow, int iCol, BOOL bCheckBoxes, BOOL bFocusRect, BOOL bNoGrid, BOOL bPLM )
{
   LPNMLVCUSTOMDRAW lplvcd;
   int x, y;
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   RECT rcIcon, rcBack;
   LPRECT lprcIcon = &rcIcon;
   LPRECT lprcBack = &rcBack;
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
               else if( GetWindowLong( lplvcd->nmcd.hdr.hwndFrom, GWL_STYLE ) & LVS_SHOWSELALWAYS )
               {
                  lplvcd->clrText   = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 3 );
                  lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 4 );
               }
               else
               {
                  lplvcd->clrText   = TGrid_Notify_CustomDraw_GetColor( pSelf, x, y, s_GridForeColor, s_FontColor, COLOR_WINDOWTEXT );
                  lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetColor( pSelf, x, y, s_GridBackColor, s_BackColor, COLOR_WINDOW );
               }
            }
            else
            {
               if( GetFocus() == lplvcd->nmcd.hdr.hwndFrom )
               {
                  lplvcd->clrText   = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 5 );
                  lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 6 );
               }
               else if( GetWindowLong( lplvcd->nmcd.hdr.hwndFrom, GWL_STYLE ) & LVS_SHOWSELALWAYS )
               {
                  lplvcd->clrText   = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 7 );
                  lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 8 );
               }
               else
               {
                  lplvcd->clrText   = TGrid_Notify_CustomDraw_GetColor( pSelf, x, y, s_GridForeColor, s_FontColor, COLOR_WINDOWTEXT );
                  lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetColor( pSelf, x, y, s_GridBackColor, s_BackColor, COLOR_WINDOW );
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
            else if( GetWindowLong( lplvcd->nmcd.hdr.hwndFrom, GWL_STYLE ) & LVS_SHOWSELALWAYS )
            {
               lplvcd->clrText   = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 3 );
               lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 4 );
            }
            else
            {
               lplvcd->clrText   = TGrid_Notify_CustomDraw_GetColor( pSelf, x, y, s_GridForeColor, s_FontColor, COLOR_WINDOWTEXT );
               lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetColor( pSelf, x, y, s_GridBackColor, s_BackColor, COLOR_WINDOW );
            }
         }
      }
      else
      {
         lplvcd->clrText   = TGrid_Notify_CustomDraw_GetColor( pSelf, x, y, s_GridForeColor, s_FontColor, COLOR_WINDOWTEXT );
         lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetColor( pSelf, x, y, s_GridBackColor, s_BackColor, COLOR_WINDOW );
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
         if( LI.state & LVIS_SELECTED )
         {
            lplvcd->nmcd.uItemState -= CDIS_SELECTED;
         }
      }
      else if( GetWindowLong( lplvcd->nmcd.hdr.hwndFrom, GWL_STYLE ) & LVS_SHOWSELALWAYS )
      {
         if( LI.state & LVIS_SELECTED )
         {
            lplvcd->nmcd.uItemState -= CDIS_SELECTED;
         }
      }

      if( LI.iImage != -1 )                                 // Subitem has image?
      {

         return CDRF_NOTIFYPOSTPAINT;
      }
      else if( ( x == 1 ) && ( ! bCheckBoxes ) && bPLM )    // Is first subitem and has no image nor checkbox?
      {

         return CDRF_NOTIFYPOSTPAINT;
      }

      return CDRF_DODEFAULT;
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

      // Get subitem's row (y) and col (x)
      x = lplvcd->iSubItem + 1;
      y = lplvcd->nmcd.dwItemSpec + 1;

      // Get text's background color
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
               else if( GetWindowLong( lplvcd->nmcd.hdr.hwndFrom, GWL_STYLE ) & LVS_SHOWSELALWAYS )
               {
                  lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 4 );
               }
               else
               {
                  lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetColor( pSelf, x, y, s_GridBackColor, s_BackColor, COLOR_WINDOW );
               }
            }
            else
            {
               if( GetFocus() == lplvcd->nmcd.hdr.hwndFrom )
               {
                  lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 6 );
               }
               else if( GetWindowLong( lplvcd->nmcd.hdr.hwndFrom, GWL_STYLE ) & LVS_SHOWSELALWAYS )
               {
                  lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 8 );
               }
               else
               {
                  lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetColor( pSelf, x, y, s_GridBackColor, s_BackColor, COLOR_WINDOW );
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
            else if( GetWindowLong( lplvcd->nmcd.hdr.hwndFrom, GWL_STYLE ) & LVS_SHOWSELALWAYS )
            {
               lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetSelColor( pSelf, 4 );
            }
            else
            {
               lplvcd->clrTextBk = TGrid_Notify_CustomDraw_GetColor( pSelf, x, y, s_GridBackColor, s_BackColor, COLOR_WINDOW );
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
         ListView_GetSubItemRect( lplvcd->nmcd.hdr.hwndFrom, lplvcd->nmcd.dwItemSpec, lplvcd->iSubItem, LVIR_ICON, lprcIcon );

         // Calculate area for background and paint it
         if( x == 1)
         {
            rcBack.top = rcIcon.top;
            rcBack.left = ( ( ! bCheckBoxes ) && bPLM ) ? 0 : rcIcon.left;
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
         /*
          * LVIR_BOUNDS always returns left == 0 and right == sum of all columns' widths
          * As a workaround use LVIR_LABEL to get the subitem's right and compute it's left
          * by substracting the column's width.
          * Use LVIR_ICON to get the left of the icon area, and use this value as the right
          * of the area to paint.
          */
         ListView_GetSubItemRect( lplvcd->nmcd.hdr.hwndFrom, lplvcd->nmcd.dwItemSpec, lplvcd->iSubItem, LVIR_LABEL, lprcBack );
         rcBack.left = rcBack.right - ListView_GetColumnWidth( lplvcd->nmcd.hdr.hwndFrom, lplvcd->iSubItem );
         ListView_GetSubItemRect( lplvcd->nmcd.hdr.hwndFrom, lplvcd->nmcd.dwItemSpec, lplvcd->iSubItem, LVIR_ICON, lprcIcon );
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
