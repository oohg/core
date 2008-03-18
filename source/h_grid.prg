/*
 * $Id: h_grid.prg,v 1.100 2008-03-18 00:33:10 guerra000 Exp $
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
   DATA nWidth           INIT 240
   DATA nHeight          INIT 120
   DATA aWidths          INIT {}
   DATA aHeaders         INIT {}
   DATA aHeadClick       INIT nil
   DATA aJust            INIT nil
   DATA AllowEdit        INIT .F.
   DATA GridForeColor    INIT {}
   DATA GridBackColor    INIT {}
   DATA DynamicForeColor INIT {}
   DATA DynamicBackColor INIT {}
   DATA Picture          INIT nil
   DATA OnDispInfo       INIT nil
   DATA SetImageListCommand INIT LVM_SETIMAGELIST
   DATA SetImageListWParam  INIT LVSIL_SMALL
   DATA InPlace          INIT .F.
   DATA fullmove          INIT .F.
   DATA Append           INIT .F.
   DATA EditControls     INIT nil
   DATA ReadOnly         INIT nil
   DATA Valid            INIT nil
   DATA ValidMessages    INIT nil
   DATA OnEditCell       INIT nil
   DATA aWhen            INIT {}
   DATA cRowEditTitle    INIT nil
   DATA lNested          INIT .F.
   DATA AllowMoveColumn  INIT .T.
   DATA AllowChangeSize  INIT .T.

   DATA Nrowpos      INIT 1
   DATA Ncolpos      INIT 1
   DATA Leditmode    INIT .F.
   DATA Lappendmode INIT .F.

   METHOD Define
   METHOD Define2
   METHOD Value            SETGET

   DATA bOnEnter           INIT nil
   METHOD OnEnter          SETGET

   METHOD Events
   METHOD Events_Enter
   METHOD Events_Notify

   METHOD AddColumn
   METHOD DeleteColumn

   METHOD Cell
   METHOD CellCaption( nRow, nCol, uValue )         BLOCK { | Self, nRow, nCol, uValue | CellRawValue( ::hWnd, nRow, nCol, 1, uValue ) }
   METHOD CellImage( nRow, nCol, uValue )           BLOCK { | Self, nRow, nCol, uValue | CellRawValue( ::hWnd, nRow, nCol, 2, uValue ) }
   METHOD EditCell
   METHOD EditCell2
   METHOD EditAllCells
   METHOD EditItem
   METHOD EditItem2
   METHOD EditGrid
   METHOD IsColumnReadOnly
   METHOD IsColumnWhen
   METHOD toexcel

   METHOD AddItem
   METHOD Appenditem
   METHOD InsertItem
   METHOD InsertBlank
   METHOD DeleteItem
   METHOD DeleteAllItems      BLOCK { | Self | ListViewReset( ::hWnd ), ::GridForeColor := nil, ::GridBackColor := nil }
   METHOD Item
   METHOD SetItemColor
   METHOD ItemCount           BLOCK { | Self | ListViewGetItemCount( ::hWnd ) }
   METHOD CountPerPage        BLOCK { | Self | ListViewGetCountPerPage( ::hWnd ) }
   METHOD FirstSelectedItem   BLOCK { | Self | ListView_GetFirstItem( ::hWnd ) }
   METHOD Header
   METHOD FontColor      SETGET
   METHOD BackColor      SETGET
   METHOD ColumnCount
   METHOD SetRangeColor
   METHOD ColumnWidth
   METHOD ColumnAutoFit
   METHOD ColumnAutoFitH
   METHOD ColumnsAutoFit
   METHOD ColumnsAutoFitH
   METHOD SortColumn

   METHOD Up
   METHOD Down
   METHOD left
   METHOD right
   METHOD PageDown
   METHOD PageUP
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
               aWhenFields, lDisabled, lNoTabStop, lInvisible, lNoHeaders, ;
               onenter ) CLASS TGrid
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
              lNoHeaders, onenter )
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
                lNoHeaders, onenter ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local ControlHandle, aImageList

   ::SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor, .t., lRtl )

   ASSIGN ::aWidths    VALUE aWidths    TYPE "A"
   ASSIGN ::aHeaders   VALUE aHeaders   TYPE "A"

   If Len( ::aHeaders ) != Len( ::aWidths )
      MsgOOHGError( "Grid: HEADERS/WIDTHS array size mismatch. Program Terminated." )
	EndIf
   If HB_IsArray( aRows )
      If ASCAN( aRows, { |a| !( HB_IsArray( a ) .OR. Len( a ) != Len( aHeaders ) ) } ) > 0
         MsgOOHGError( "Grid: ITEMS length mismatch. Program Terminated." )
		EndIf
   Else
		aRows := {}
	EndIf

   ASSIGN ::nWidth  VALUE w TYPE "N"
   ASSIGN ::nHeight VALUE h TYPE "N"
   ASSIGN ::nRow    VALUE y TYPE "N"
   ASSIGN ::nCol    VALUE x TYPE "N"

   ASSIGN ::aHeadClick VALUE aHeadClick TYPE "A" DEFAULT {}
   ASSIGN ::aJust      VALUE aJust      TYPE "A"
   ASSIGN ::Picture    VALUE aPicture   TYPE "A"

   ASSIGN nogrid       VALUE nogrid     TYPE "L" DEFAULT .F.

   nStyle := ::InitStyle( nStyle,, lInvisible, lNoTabStop, lDisabled ) + ;
             IF( HB_ISLOGICAL( lNoHeaders ) .AND. ! lNoHeaders, LVS_NOCOLUMNHEADER , 0 )

   If !HB_IsArray( ::aJust )
      ::aJust := aFill( Array( len( ::aHeaders ) ), 0 )
	else
      aSize( ::aJust, len( ::aHeaders ) )
      aEval( ::aJust, { |x,i| ::aJust[ i ] := iif( ! HB_IsNumeric( x ) , 0, x ) } )
	endif

   if !HB_IsArray( ::Picture )
      ::Picture := Array( len( ::aHeaders ) )
	else
      aSize( ::Picture, len( ::aHeaders ) )
	endif
   aEval( ::Picture, { |x,i| ::Picture[ i ] := iif( ( ValType( x ) $ "CM" .AND. ! Empty( x ) ) .OR. HB_IsLogical( x ) , x, nil ) } )

   ::SetSplitBoxInfo( Break )
   ControlHandle := InitListView( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, '', 0, iif( nogrid, 0, 1 ) , ownerdata  , itemcount  , nStyle, ::lRtl )

   if HB_IsArray( aImage )
      aImageList := ImageList_Init( aImage, CLR_NONE, LR_LOADTRANSPARENT )
      SendMessage( ControlHandle, ::SetImageListCommand, ::SetImageListWParam, aImageList[ 1 ] )
      ::ImageList := aImageList[ 1 ]
      If ASCAN( ::Picture, .T. ) == 0
         ::Picture[ 1 ] := .T.
         ::aWidths[ 1 ] := max( ::aWidths[ 1 ], aImageList[ 2 ] + 2 ) // Set Column 1 width to Bitmap width
      EndIf
   EndIf

   InitListViewColumns( ControlHandle, ::aHeaders, ::aWidths, ::aJust )

   ::Register( ControlHandle, ControlName, HelpId, , ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   ::FontColor := ::Super:FontColor
   ::BackColor := ::Super:BackColor

   ::DynamicForeColor := dynamicforecolor
   ::DynamicBackColor := dynamicbackcolor
   ::readonly := readonly
   ::valid := valid
   ::validmessages := validmessages
   ::EditControls := editcontrols
   ::OnEditCell := editcell
   ::aWhen := aWhenFields
   ASSIGN ::InPlace   VALUE inplace  TYPE "L"
   ASSIGN ::AllowEdit VALUE Editable TYPE "L"

   AEVAL( aRows, { |u| ::AddItem( u ) } )

   ::Value := value

   // Must be set after control is initialized
   ASSIGN ::OnLostFocus VALUE lostfocus  TYPE "B"
   ASSIGN ::OnGotFocus  VALUE gotfocus   TYPE "B"
   ASSIGN ::OnChange    VALUE Change     TYPE "B"
   ASSIGN ::OnDblClick  VALUE dblclick   TYPE "B"
   ASSIGN ::OnDispInfo  VALUE ondispinfo TYPE "B"
   ASSIGN ::OnEnter     value onenter    TYPE "B"

Return Self

*-----------------------------------------------------------------------------*
METHOD OnEnter( bEnter ) CLASS TGrid
*-----------------------------------------------------------------------------*
LOCAL bRet
   IF HB_IsBlock( bEnter )
      IF _OOHG_SameEnterDblClick
         ::OnDblClick := bEnter
      ELSE
         ::bOnEnter := bEnter
      ENDIF
      bRet := bEnter
   ELSE
      bRet := IF( _OOHG_SameEnterDblClick, ::OnDblClick, ::bOnEnter )
   ENDIF
RETURN bRet

METHOD appenditem() CLASS TGrid
Local aNew,i
         ::lappendmode:=.T.
         anew:={}
         for i:=1 to len(::aheaders)
             aadd(anew,::cell(::itemcount(),i))
             if HB_IsNumeric(anew[i])
                anew[i]:=0
             endif
             if Valtype(anew[i]) $ "CM"
                anew[i]:=""
             endif
             if HB_IsDate(anew[i])
                anew[i]:=stod("        ")
             endif
             if HB_IsLogical(anew[i])
                anew[i]:=.F.
             endif
         next i
         ::additem( anew, NIL, NIL )
         ::nrowpos++
         KEYBD_EVENT(VK_RETURN)
RETURN NIL

METHOD EDITGRID(nrow,ncol) CLASS TGrid

   Local lRet, i, nLast
   IF !HB_IsNumeric( nRow )
      nRow := ::FirstSelectedItem
   ENDIF
   IF !HB_IsNumeric( nCol )
      nCol := 1
   ENDIF
   ::nrowpos:=nrow
   ::ncolpos:=ncol
   If nRow < 1 .OR. ::nrowpos > ::ItemCount() .OR. ::ncolpos < 1 .OR. ::ncolpos > Len(::aHeaders )
      // Cell out of range
      Return .F.
   EndIf


   lRet := .T.

   Do While ::ncolpos <= Len( ::aHeaders ) .and. ::nrowpos <= ::itemcount() .AND. lRet

      nlast:=len(::aheaders)
      for i:= len(::aheaders) to 1 step -1
          if (.not. ::iscolumnreadonly(i)) .or. ( ::iscolumnwhen(i))
             nlast:=i
             exit
          endif
      next i

      _OOHG_ThisItemCellValue := ::Cell( ::nrowpos, ::ncolpos )
      If ::IsColumnReadOnly( ::ncolpos )
         // Read only column
      ElseIf ! ::IsColumnWhen( ::ncolpos )
         // Not a valid WHEN
      Else

         ::leditmode:=.T.
         lRet := ::EditCell( ::nrowpos, ::ncolpos )
         ::leditmode:=.F.


         if ::lappendmode .and. .not. lret
            if ::ncolpos = 1
               ::deleteitem(::itemcount())
               ::lappendmode:=.F.
               ::value := ::itemcount()
               ::nrowpos := ::FirstSelectedItem
            endif
         endif

      EndIf
      if (::nrowpos=::itemcount() .and. lret) .and. ::ncolpos = nlast   /////////.and. ::ncolpos=len(::aheaders) .and. lret

         if ::Append
            ::appenditem()
         endif

      else
         if ::ncolpos = nlast
            ::nrowpos++
            ::ncolpos:=0
         endif
      endif


      ::value := ::nrowpos
      ::ncolpos++
   EndDo

   if ::ncolpos=1 .and. ::FirstSelectedItem > 1
      ::Value := ::nrowpos-1
   endif
   If lRet // .OR. nCol > Len( ::aHeaders )
      ListView_Scroll( ::hWnd, - _OOHG_GridArrayWidths( ::hWnd, ::aWidths ), 0)
   Endif
   ::lnested:=.F.
   Return lRet


   METHOD RIGHT() CLASS TGrid
   if ::leditmode .and. ::fullmove
      if ::ncolpos<len(::aheaders)
         ::ncolpos++
      endif
   endif
   return self

   METHOD LEFT() CLASS TGrid
   if ::leditmode .and. ::fullmove
      if ::ncolpos>1
         ::ncolpos--
         ::ncolpos--
      endif
   endif
   return self



   METHOD DOWN() CLASS TGrid
   if ::leditmode
      if ::nrowpos<::itemcount()
         ::nrowpos++
      endif
   else
      IF ::FirstSelectedItem < ::itemcount
         ::value++
      ENDIF
   endif
   return self

   METHOD UP() CLASS TGrid
   if ::leditmode
      if ::nrowpos>1
         ::nrowpos--
      endif
   else
      IF ::FirstSelectedItem > 1
         ::value--
      ENDIF
   endif
   return self

*--------------------------------------------------------------------------*
METHOD PageUp() CLASS TGrid
*--------------------------------------------------------------------------*
   if ::FirstSelectedItem > ::CountPerPage
      ::value := ::value - ::CountPerPage
   else
      ::GoTop()
   endif
return self

*-------------------------------------------------------------------------*
METHOD PageDown() CLASS TGrid
*-------------------------------------------------------------------------*
   if ::FirstSelectedItem < ::itemcount - ::CountPerPage
      ::value := ::value + ::CountPerPage
   else
     ::GoBottom()
   endif
return self

*---------------------------------------------------------------------------*
METHOD GoTop() CLASS TGrid
*---------------------------------------------------------------------------*
   IF ::itemcount > 0
      ::value := 1
   ENDIF
return self

*---------------------------------------------------------------------------*
METHOD GoBottom() CLASS TGrid
*---------------------------------------------------------------------------*
   IF ::itemcount > 0
      ::value := ::Itemcount
   ENDIF
return self

*-----------------------------------------------------------------------------*
METHOD toExcel( cTitle, nRow ) CLASS TGrid
*-----------------------------------------------------------------------------*
 Local LIN:=4
 LOCAL oExcel, oHoja,i

   default ctitle to ""

   oExcel := TOleAuto():New( "Excel.Application" )
   IF Ole2TxtError() != 'S_OK'
      MsgStop('Excel not found','error')
      RETURN Nil
   ENDIF
   oExcel:WorkBooks:Add()
   oHoja := oExcel:ActiveSheet()
   oHoja:Cells:Font:Name := "Arial"
   oHoja:Cells:Font:Size := 10

   oHoja:Cells( 1, 1 ):Value := upper( cTitle )
   oHoja:Cells( 1, 1 ):font:bold := .T.

   for i:= 1 to len( ::aHeaders )
      oHoja:Cells( LIN, i ):Value := upper( ::aHeaders[i] )
      oHoja:Cells( LIN, i ):font:bold:= .T.
   next i
   LIN++
   LIN++
   ::gotop()

   If !HB_IsNumeric( nRow ) .OR. nRow < 1
      nRow := ::FirstSelectedItem
   EndIf
   Do while nRow <= ::ItemCount .AND. nRow > 0
      for i := 1 to len( ::aHeaders )
         oHoja:Cells( LIN, i ):Value := ::cell( nRow, i )
      next i
      nRow++
      LIN++
   Enddo

   FOR i:=1 TO LEN( ::Aheaders )
      oHoja:Columns( i ):AutoFit()
   NEXT

   oHoja:Cells( 1, 1 ):Select()
   oExcel:Visible := .T.
   oHoja := NIL
   oExcel:= NIL

  RETURN nil


*-----------------------------------------------------------------------------*
METHOD EditItem() CLASS TGrid
*-----------------------------------------------------------------------------*
Local nItem, aItems, aEditControls, nColumn
   nItem := ::FirstSelectedItem
   If nItem == 0
      Return NIL
   EndIf
   aItems := ::Item( nItem )

   aEditControls := ARRAY( Len( aItems ) )
   For nColumn := 1 To Len( aEditControls )
      aEditControls[ nColumn ] := GetEditControlFromArray( nil, ::EditControls, nColumn, Self )
      If !HB_IsObject( aEditControls[ nColumn ] )
         // Check for imagelist
         If HB_IsNumeric( aItems[ nColumn ] )
            If HB_IsLogical( ::Picture[ nColumn ] ) .AND. ::Picture[ nColumn ]
               aEditControls[ nColumn ] := TGridControlImageList():New( Self )
            ElseIf HB_IsNumeric( ListViewGetItem( ::hWnd, nItem, Len( ::aHeaders ) )[ nColumn ] )
               aEditControls[ nColumn ] := TGridControlImageList():New( Self )
            EndIf
         Endif
      Endif
   Next

   aItems := ::EditItem2( nItem, aItems, aEditControls,, if( ValType( ::cRowEditTitle ) $ "CM", ::cRowEditTitle, _OOHG_Messages( 1, 5 ) ) )
   If ! Empty( aItems )
      ::Item( nItem, ASIZE( aItems, LEN( ::aHeaders ) ) )
      _SetThisCellInfo( ::hWnd, nItem, 1, nil )
      _OOHG_Eval( ::OnEditCell, nItem, 0 )

      _ClearThisCellInfo()
   EndIf
Return NIL


*-----------------------------------------------------------------------------*
METHOD EditItem2( nItem, aItems, aEditControls, aMemVars, cTitle ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local l, actpos := {0,0,0,0}, GCol, IRow, i, oWnd, nWidth, nMaxHigh, oMain
Local oCtrl, aEditControls2, nRow, lSplitWindow, nControlsMaxHeight
Local aReturn

   If ::lNested
      Return {}
   EndIf

   If !HB_IsNumeric( nItem )
      nItem := ::FirstSelectedItem
   EndIf
   If nItem == 0 .OR. nItem > ::ItemCount
      Return {}
   EndIf

   ::lNested := .T.

   If !HB_IsArray( aItems ) .OR. Len( aItems ) == 0
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
      If !HB_IsObject( oCtrl )
         If HB_IsArray( ::Picture ) .AND. Len( ::Picture ) >= i .AND. ValType( ::Picture[ i ] ) $ "CM"
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

   aReturn := {}

   DEFINE WINDOW 0 OBJ oMain AT IRow,GCol ;
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

   For i := 1 to l
      @ nRow + 3, 10 LABEL 0 PARENT ( oWnd ) VALUE Alltrim( ::aHeaders[ i ] ) + ":" WIDTH 110 NOWORDWRAP
      aEditControls2[ i ]:CreateControl( aItems[ i ], oWnd:Name, nRow, 120, aEditControls2[ i ]:nDefWidth, aEditControls2[ i ]:nDefHeight )
      nRow += aEditControls2[ i ]:nDefHeight + 6
      If HB_IsArray( aMemVars ) .AND. Len( aMemVars ) >= i
         aEditControls2[ i ]:cMemVar := aMemVars[ i ]
         // "Creates" memvars
         If ValType( aMemVars[ i ] ) $ "CM" .AND. ! Empty( aMemVars[ i ] )
            &( aMemVars[ i ] ) := nil
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
         ACTION ( TGrid_EditItem_Check( aEditControls2, aItems, oMain, aReturn ) )

   @ nRow, 145 BUTTON 0 PARENT ( oWnd ) CAPTION _OOHG_Messages( 1, 7 ) ;
         ACTION oMain:Release()

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

Return aReturn

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
      _OOHG_ThisItemCellValue := aValues[ nItem ]
      lEnabled := _OOHG_EVAL( aEditControls[ nItem ]:bWhen )
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

Static Procedure TGrid_EditItem_Check( aEditControls, aItems, oWnd, aReturn )
Local lRet, nItem, aValues, lValid
   // Save values
   aValues := TGrid_EditItem_When( aEditControls )

   // Check VALID clauses
   lRet := .T.
   For nItem := 1 To Len( aEditControls )
      _OOHG_ThisItemCellValue := aValues[ nItem ]
      lValid := _OOHG_Eval( aEditControls[ nItem ]:bValid, aValues[ nItem ] )
      If _CheckCellNewValue( aEditControls[ nItem ], aValues[ nItem ] )
         aValues[ nItem ] := _OOHG_ThisItemCellValue
      EndIf
      If HB_IsLogical( lValid ) .AND. ! lValid
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
      ASIZE( aReturn, LEN( aItems ) )
      AEVAL( aValues, { |u,i| aItems[ i ] := aReturn [ i ] := u } )
      oWnd:Release()
   Endif
Return

*-----------------------------------------------------------------------------*
METHOD IsColumnReadOnly( nCol ) CLASS TGrid
*-----------------------------------------------------------------------------*
LOCAL uReadOnly
   uReadOnly := _OOHG_GetArrayItem( ::ReadOnly, nCol )
RETURN ( HB_IsLogical( uReadOnly )  .AND. uReadOnly )

*-----------------------------------------------------------------------------*
METHOD IsColumnWhen( nCol ) CLASS TGrid
*-----------------------------------------------------------------------------*
LOCAL uWhen
   uWhen := _OOHG_GetArrayItem( ::aWhen, nCol )
RETURN ( !HB_IsLogical( uWhen ) .OR. uWhen )

*-----------------------------------------------------------------------------*
METHOD AddColumn( nColIndex, cCaption, nWidth, nJustify, uForeColor, uBackColor, lNoDelete, uPicture, uEditControl ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local nColumns, uGridColor, uDynamicColor

   // Set Default Values
   nColumns := Len( ::aHeaders ) + 1

   If !HB_IsNumeric( nColIndex ) .OR. nColIndex > nColumns
      nColIndex := nColumns
   ElseIf nColIndex < 1
      nColIndex := 1
   EndIf

   If ! ValType( cCaption ) $ 'CM'
      cCaption := ''
   EndIf

   If !HB_IsNumeric( nWidth )
      nWidth := 120
   EndIf

   If !HB_IsNumeric( nJustify )
      nJustify := 0
   EndIf

   // Update Headers
   ASIZE( ::aHeaders, nColumns )
   AINS( ::aHeaders, nColIndex )
   ::aHeaders[ nColIndex ] := cCaption

   // Update Pictures
   ASIZE( ::Picture, nColumns )
   AINS( ::Picture, nColIndex )
   ::Picture[ nColIndex ] := iif( ( ValType( uPicture ) $ "CM" .AND. ! Empty( uPicture ) ) .OR. HB_IsLogical( uPicture ) , uPicture, nil )

   // Update Widths
   ASIZE( ::aWidths, nColumns )
   AINS( ::aWidths, nColIndex )
   ::aWidths[ nColIndex ] := nWidth

   IF !HB_IsLogical( lNoDelete )
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

   // Update edit control
   IF VALTYPE( uEditControl ) != NIL .OR. HB_IsArray( ::EditControls )
      IF !HB_IsArray( ::EditControls )
         ::EditControls := ARRAY( nColumns )
      ELSEIF LEN( ::EditControls ) < nColumns
         ASIZE( ::EditControls, nColumns )
      ENDIF
      AINS( ::EditControls, nColIndex )
      ::EditControls[ nColIndex ] := uEditControl
   ENDIF

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
   ElseIf HB_IsArray( aGrid ) .OR. ValType( uColor ) $ "ANB" .OR. ValType( uDynamicColor ) $ "ANB"
      IF HB_IsArray( aGrid )
         IF Len( aGrid ) < nItemCount
            ASIZE( aGrid, nItemCount )
         Else
            nItemCount := Len( aGrid )
         ENDIF
      Else
         aGrid := ARRAY( nItemCount )
      ENDIF
      FOR x := 1 TO nItemCount
         IF HB_IsArray( aGrid[ x ] )
            IF LEN( aGrid[ x ] ) < nWidth
                ASIZE( aGrid[ x ], nWidth )
            ENDIF
            AINS( aGrid[ x ], nColumn )
         Else
            aGrid[ x ] := ARRAY( nWidth )
         ENDIF
         _SetThisCellInfo( hWnd, x, nColumn, nil )
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

   If !HB_IsNumeric( nColIndex ) .OR. nColIndex > nColumns
      nColIndex := nColumns
   ElseIf nColIndex < 1
      nColIndex := 1
	EndIf

   _OOHG_DeleteArrayItem( ::aHeaders, nColIndex )
   _OOHG_DeleteArrayItem( ::aWidths,  nColIndex )
   _OOHG_DeleteArrayItem( ::Picture,  nColIndex )

   _OOHG_DeleteArrayItem( ::DynamicForeColor, nColIndex )
   _OOHG_DeleteArrayItem( ::DynamicBackColor, nColIndex )

   If HB_IsLogical( lNoDelete ) .AND. lNoDelete
      IF HB_IsArray( ::GridForeColor )
         AEVAL( ::GridForeColor, { |a| _OOHG_DeleteArrayItem( a, nColIndex ) } )
      ENDIF
      IF ValType( ::GridBackColor ) == "A"
         AEVAL( ::GridBackColor, { |a| _OOHG_DeleteArrayItem( a, nColIndex ) } )
      ENDIF
   Else
      ::GridForeColor := nil
      ::GridBackColor := nil
   EndIf

   // Update edit control
   IF HB_IsArray( ::EditControls )
      IF LEN( ::EditControls ) >= nColIndex
         ADEL( ::EditControls, nColIndex )
      ENDIF
   ENDIF

	// Call C-Level Routine
   ListView_DeleteColumn( ::hWnd, nColIndex, lNoDelete )

Return nil

*-----------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TGrid
*-----------------------------------------------------------------------------*
   IF HB_IsNumeric( uValue )
      ListView_SetCursel( ::hWnd, uValue )
      ListView_EnsureVisible( ::hWnd, uValue )
   ELSE
      uValue := ::FirstSelectedItem
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
   IF !HB_IsNumeric( nRow )
      nRow := ::FirstSelectedItem
   ENDIF
   IF !HB_IsNumeric( nCol )
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
   If !HB_IsObject( EditControl )
      // If EditControl is not specified, check for imagelist
      If HB_IsNumeric( uOldValue )
         If HB_IsLogical( ::Picture[ nCol ] ) .AND. ::Picture[ nCol ]
            EditControl := TGridControlImageList():New( Self )
         ElseIf HB_IsNumeric( ListViewGetItem( ::hWnd, nRow, Len( ::aHeaders ) )[ nCol ] )
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
      _SetThisCellInfo( ::hWnd, nRow, nCol, uValue )
      _OOHG_Eval( ::OnEditCell, nRow, nCol )
      If _CheckCellNewValue( EditControl, @uValue )
         ::Cell( nRow, nCol, uValue )
      EndIf
      _ClearThisCellInfo()
   ENDIF
Return lRet

*-----------------------------------------------------------------------------*
METHOD EditCell2( nRow, nCol, EditControl, uOldValue, uValue, cMemVar ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local r, r2, lRet := .F., nWidth
   If ::lNested
      Return .F.
   EndIf
   ::lNested := .T.

   IF ValType( cMemVar ) != "C"
      cMemVar := "_OOHG_NULLVAR_"
   ENDIF
   IF !HB_IsNumeric( nRow )
      nRow := ::FirstSelectedItem
   ENDIF
   IF !HB_IsNumeric( nCol )
      nCol := 1
   ENDIF
   _OOHG_ThisItemCellValue := ::Cell( nRow, nCol )
   IF nRow < 1 .OR. nRow > ::ItemCount() .OR. nCol < 1 .OR. nCol > Len( ::aHeaders )
      // Cell out of range
   ElseIf ::IsColumnReadOnly( nCol )
      // Read only column
      PlayHand()
   ElseIf ! ::IsColumnWhen( nCol )
      // Not a valid WHEN

   Else

      // Cell value
      IF ValType( uOldValue ) == "U"
         uValue := ::Cell( nRow, nCol )
      Else
         uValue := uOldValue
      ENDIF

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

      If !HB_IsObject( EditControl )
         MsgExclamation( "ooHG can't determine cell type for INPLACE edit." )
      Else
         r := { 0, 0, 0, 0 }
         GetClientRect( ::hWnd, r )
         nWidth := r[ 3 ] - r[ 1 ]
         r2 := { 0, 0, 0, 0 }
         GetWindowRect( ::hWnd, r2 )
         ListView_EnsureVisible( ::hWnd, nRow - 1 )
         r := LISTVIEW_GETSUBITEMRECT( ::hWnd, nRow - 1, nCol - 1 )
         r[ 3 ] := ListView_GetColumnWidth( ::hWnd, nCol - 1 )
         // Ensures cell is visible
         If r[ 2 ] + r[ 3 ] + GetVScrollBarWidth() > nWidth
            ListView_Scroll( ::hWnd, ( r[ 2 ] + r[ 3 ] + GetVScrollBarWidth() - nWidth ), 0 )
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

         EditControl:cMemVar := cMemVar
         If HB_IsArray( ::Valid ) .AND. Len( ::Valid ) >= nCol
            EditControl:bValid := ::Valid[ nCol ]
         EndIf
         If HB_IsArray( ::ValidMessages ) .AND. Len( ::ValidMessages ) >= nCol
            EditControl:cValidMessage := ::ValidMessages[ nCol ]
         EndIf
         If ValType( uValue ) $ "CM"
            uValue := TRIM( uValue )
         EndIf
         _SetThisCellInfo( ::hWnd, nRow, nCol, uValue )
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
   ::lNested := .F.
Return lRet

*-----------------------------------------------------------------------------*
METHOD EditAllCells( nRow, nCol ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local lRet
   IF !HB_IsNumeric( nRow )
      nRow := ::FirstSelectedItem
   ENDIF
   IF !HB_IsNumeric( nCol )
      nCol := 1
   ENDIF
   If nRow < 1 .OR. nRow > ::ItemCount() .OR. nCol < 1 .OR. nCol > Len( ::aHeaders )
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
      EndIf
      if ::lappendmode .and. .not. lret
         if nCol = 1
               ::deleteitem(::itemcount())
               ::lappendmode:=.F.
               ::value := ::itemcount()
         endif
      endif
      nCol++
   EndDo
   If lRet // .OR. nCol > Len( ::aHeaders )
      ListView_Scroll( ::hWnd, - _OOHG_GridArrayWidths( ::hWnd, ::aWidths ), 0 )
   Endif
   ::lNested := .F.
Return lRet

#pragma BEGINDUMP

#ifndef _WIN32_IE
   #define _WIN32_IE 0x0400
#endif
#if ( _WIN32_IE < 0x0400 )
   #undef _WIN32_IE
   #define _WIN32_IE 0x0400
#endif

#ifndef _WIN32_WINNT
   #define _WIN32_WINNT 0x0400
#endif
#if ( _WIN32_WINNT < 0x0400 )
   #undef _WIN32_WINNT
   #define _WIN32_WINNT 0x0400
#endif

#define s_Super s_TControl
#include "hbapi.h"
#include "hbapiitm.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windows.h>
#include <commctrl.h>
#include "oohg.h"

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
            VK_UP ,  // virtual-key code
            0,    // hardware scan code
            0,    // flags specifying various function options
            0     // additional data associated with keystroke
            );
         }
         else
         {
            keybd_event(
            VK_DOWN  ,  // virtual-key code
            0,    // hardware scan code
            0,    // flags specifying various function options
            0     // additional data associated with keystroke
            );
         }
         hb_retni( 1 );
         bDefault = FALSE;
         break;

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
#pragma ENDDUMP

*-----------------------------------------------------------------------------*
FUNCTION _OOHG_TGrid_Events2( Self, hWnd, nMsg, wParam, lParam ) // CLASS TGrid
*-----------------------------------------------------------------------------*
Local aCellData
   Empty( hWnd )
   Empty( wParam )
   Empty( lParam )

   If nMsg == WM_LBUTTONDBLCLK

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

      If ::fullmove
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
    ////            ::EditAllCells(  _OOHG_ThisItemRowIndex, _OOHG_ThisItemColIndex )
         EndIf

      ElseIf ::AllowEdit
         ::EditItem()

      ElseIf HB_IsBlock( ::OnDblClick )
         ::DoEvent( ::OnDblClick, "DBLCLICK" )

      EndIf

      _ClearThisCellInfo()
      _PopEventInfo()
      Return 0

   EndIf

RETURN nil

*-----------------------------------------------------------------------------*
FUNCTION _OOHG_TGrid_Notify2( Self, wParam, lParam ) // CLASS TGrid
*-----------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam ), nColumn := NMHeader_iItem( lParam )

   Empty( wParam ) // DUMMY...

   If     nNotify == HDN_BEGINDRAG
      If HB_IsLogical( ::AllowMoveColumn ) .AND. ! ::AllowMoveColumn
         Return 1
      EndIf
   ElseIf nNotify == HDN_ENDDRAG
      // ::AllowMoveColumn
      // Termina a arrastrar el encabezado de nColumn
      // RETURN 1 para no permitirlo
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

RETURN nil

*-----------------------------------------------------------------------------*
METHOD Events_Enter() CLASS TGrid
*-----------------------------------------------------------------------------*
   If ::fullmove
      ::EditGRID()
      return nil
   Endif
   If ::InPlace
      ::EditAllCells()
   ElseIf ::AllowEdit
      ::EditItem()
   Else
      ::DoEvent( ::OnEnter, "ENTER" )
   EndIf
Return nil


*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam )
Local lvc, _ThisQueryTemp, nvkey

   If nNotify == NM_CUSTOMDRAW

      Return TGRID_NOTIFY_CUSTOMDRAW( Self, lParam )

   ElseIF nNotify == LVN_KEYDOWN


     nvKey := GetGridvKey( lParam )

     if nvkey == VK_DOWN

       if ::FirstSelectedItem == ::itemcount() .and. .not. ::leditmode
           if ::Append
              ::appenditem()
           endif
        endif
     endif

     nvkey :=0

   ElseIf nNotify == LVN_GETDISPINFO

      * Grid OnQueryData ............................

      if HB_IsBlock( ::OnDispInfo )

         _PushEventInfo()
         _OOHG_ThisForm := ::Parent
         _OOHG_ThisType := 'C'
         _OOHG_ThisControl := Self
         _ThisQueryTemp  := GETGRIDDISPINFOINDEX ( lParam )
         _OOHG_ThisQueryRowIndex  := _ThisQueryTemp [1]
         _OOHG_ThisQueryColIndex  := _ThisQueryTemp [2]
         ::DoEvent( ::OnDispInfo, "DISPINFO" )
         IF HB_IsNumeric( _OOHG_ThisQueryData )
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
         ::DoEvent( ::OnChange, "CHANGE" )
         Return nil
      EndIf

   elseif nNotify == LVN_COLUMNCLICK

      if HB_IsArray ( ::aHeadClick )
         lvc := GetGridColumn(lParam) + 1
         if len( ::aHeadClick ) >= lvc
            _SetThisCellInfo( ::hWnd, 0, lvc )
            ::DoEvent( ::aHeadClick[ lvc ], "HEADCLICK" )
            _ClearThisCellInfo()
            Return nil
         EndIf
      EndIf

* ¨Qu‚ es -181?
   elseif nNotify == -181  // ???????

      redrawwindow( ::hWnd )

   EndIf

Return ::Super:Events_Notify( wParam, lParam )

*-----------------------------------------------------------------------------*
METHOD AddItem( aRow, uForeColor, uBackColor ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local aText
   If Len( ::aHeaders ) != Len( aRow )
      MsgOOHGError( "Grid.AddItem: Item size mismatch. Program Terminated" )
   EndIf

   aText := TGrid_SetArray( Self, aRow )
   ::SetItemColor( ::ItemCount() + 1, uForeColor, uBackColor, aRow )
   AddListViewItems( ::hWnd , aText )
Return Nil

*-----------------------------------------------------------------------------*
METHOD InsertItem( nItem, aRow, uForeColor, uBackColor ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local aText
   If Len( ::aHeaders ) != Len( aRow )
      MsgOOHGError( "Grid.InsertItem: Item size mismatch. Program Terminated" )
   EndIf

   aText := TGrid_SetArray( Self, aRow )
   ::InsertBlank( nItem )
   ::SetItemColor( nItem, uForeColor, uBackColor, aRow )
   ListViewSetItem( ::hWnd, aText, nItem )
Return Nil

*-----------------------------------------------------------------------------*
METHOD InsertBlank( nItem ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local aGrid
   aGrid := ::GridForeColor
   If HB_IsArray( aGrid ) .AND. Len( aGrid ) >= nItem
      AADD( aGrid, nil )
      AINS( aGrid, nItem )
   EndIf
   aGrid := ::GridBackColor
   If HB_IsArray( aGrid ) .AND. Len( aGrid ) >= nItem
      AADD( aGrid, nil )
      AINS( aGrid, nItem )
   EndIf
   InsertListViewItem( ::hWnd, ARRAY( LEN( ::aHeaders ) ), nItem )
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
   If HB_IsArray( ::EditControls )
      For nColumn := 1 To Len( uValue )
         oEditControl := GetEditControlFromArray( nil, ::EditControls, nColumn, Self )
         If HB_IsObject( oEditControl )
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
///      automsgbox(xvalue)
      oEditControl := GetEditControlFromArray( nil, ::EditControls, nColumn, Self )
      If HB_IsObject( oEditControl )
/////      automsgbox(xvalue)
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
LOCAL nWidth
   nWidth := LEN( ::aHeaders )
   IF !HB_IsArray( uExtra )
      uExtra := ARRAY( nWidth )
   ELSEIF LEN( uExtra ) < nWidth
      ASIZE( uExtra, nWidth )
   ENDIF
   ::GridForeColor := TGrid_CreateColorArray( ::GridForeColor, nItem, uForeColor, ::DynamicForeColor, nWidth, uExtra, ::hWnd )
   ::GridBackColor := TGrid_CreateColorArray( ::GridBackColor, nItem, uBackColor, ::DynamicBackColor, nWidth, uExtra, ::hWnd )
Return Nil

STATIC Function TGrid_CreateColorArray( aGrid, nItem, uColor, uDynamicColor, nWidth, uExtra, hWnd )
Local aTemp, nLen
   IF ! ValType( uColor ) $ "ANB" .AND. ValType( uDynamicColor ) $ "ANB"
      uColor := uDynamicColor
   ENDIF
   IF ValType( uColor ) $ "ANB"
      IF HB_IsArray( aGrid )
         IF Len( aGrid ) < nItem
            ASIZE( aGrid, nItem )
         ENDIF
      ELSE
         aGrid := ARRAY( nItem )
      ENDIF
      aTemp := ARRAY( nWidth )
      IF HB_IsArray( uColor ) .AND. LEN( uColor ) < nWidth
         nLen := LEN( uColor )
         uColor := ACLONE( uColor )
         IF VALTYPE( uDynamicColor ) $ "NB"
            ASIZE( uColor, nWidth )
            AFILL( uColor, uDynamicColor, nLen + 1 )
         ELSEIF HB_IsArray( uDynamicColor ) .AND. LEN( uDynamicColor ) > nLen
            ASIZE( uColor, MIN( nWidth, LEN( uDynamicColor ) ) )
            AEVAL( uColor, { |x,i| uColor[ i ] := uDynamicColor[ i ], x }, nLen + 1 )
         ENDIF
      ENDIF
      AEVAL( aTemp, { |x,i| _SetThisCellInfo( hWnd, nItem, i, uExtra[ i ] ), aTemp[ i ] := _OOHG_GetArrayItem( uColor, i, nItem, uExtra ), x } )
      _ClearThisCellInfo()
      aGrid[ nItem ] := aTemp
   ENDIF
Return aGrid

*-----------------------------------------------------------------------------*
METHOD Header( nColumn, uValue ) CLASS TGrid
*-----------------------------------------------------------------------------*
   IF VALTYPE( uValue ) $ "CM"
      ::aHeaders[ nColumn ] := uValue
      SETGRIDCOLUMNHEADER( ::hWnd, nColumn, uValue )
   ENDIF
Return ::aHeaders[ nColumn ]

#pragma BEGINDUMP
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
#pragma ENDDUMP

*-----------------------------------------------------------------------------*
METHOD SetRangeColor( uForeColor, uBackColor, nTop, nLeft, nBottom, nRight ) CLASS TGrid
*-----------------------------------------------------------------------------*
Local nAux, nLong := ::ItemCount()
   IF !HB_IsNumeric( nBottom )
      nBottom := nTop
   ENDIF
   IF !HB_IsNumeric( nRight )
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
      IF !HB_IsArray( aGrid )
         aGrid := ARRAY( nBottom )
      ELSEIF LEN( aGrid ) < nBottom
         ASIZE( aGrid, nBottom )
      ENDIF
      FOR nAux := nTop TO nBottom
         IF !HB_IsArray( aGrid[ nAux ] )
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
   IF HB_IsNumeric( nColumn ) .AND. nColumn >= 1 .AND. nColumn <= Len( ::aHeaders )
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
   IF HB_IsNumeric( nColumn ) .AND. nColumn >= 1 .AND. nColumn <= Len( ::aHeaders )
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

*-----------------------------------------------------------------------------*
METHOD SortColumn( nColumn, lDescending ) CLASS TGrid
*-----------------------------------------------------------------------------*
Return ListView_SortItemsEx( ::hWnd, nColumn, lDescending )





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
               aWhenFields, lDisabled, lNoTabStop, lInvisible, lNoHeaders, ;
               onenter ) CLASS TGridMulti
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
              lNoHeaders, onenter )
Return Self

*-----------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TGridMulti
*-----------------------------------------------------------------------------*
   IF HB_IsArray( uValue )
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
Procedure _SetThisCellInfo( hWnd, nRow, nCol, uValue )
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
   _OOHG_ThisItemCellValue  := uValue
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

Function _CheckCellNewValue()
Return .F.
/*
*------------------------------------------------------------------------------*
Function _CheckCellNewValue( oControl, uValue )
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

EXTERN InitListView, InitListViewColumns, AddListViewItems, InsertListViewItem
EXTERN ListViewSetItem, ListViewGetItem, FillGridFromArray

#pragma BEGINDUMP

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

HB_FUNC( INITLISTVIEW )
{
   HWND hwnd;
   HWND hbutton;
   int style, StyleEx;

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
   hb_parni(3), hb_parni(4) , hb_parni(5), hb_parni(6) ,
   hwnd, ( HMENU ) HWNDparam( 2 ) , GetModuleHandle(NULL) , NULL ) ;

   SendMessage(hbutton,LVM_SETEXTENDEDLISTVIEWSTYLE, 0, hb_parni(9) | LVS_EX_FULLROWSELECT | LVS_EX_HEADERDRAGDROP | LVS_EX_SUBITEMIMAGES );

   if ( hb_parl( 10 ) )
   {
      ListView_SetItemCount( hbutton , hb_parni( 11 ) ) ;
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
      COL.pszText = hb_arrayGetCPtr( hArray, s + 1 );
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

HB_FUNC( SETGRIDCOLUMNHEADER )
{
        LV_COLUMN COL;

        COL.mask = LVCF_FMT | LVCF_TEXT ;
        COL.pszText = hb_parc(3) ;
        COL.fmt = hb_parni(4) ;

        ListView_SetColumn ( HWNDparam( 1 ) , hb_parni (2)-1 , &COL ) ;
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
   ListView_InsertItem( h, &LI );

   _OOHG_ListView_FillItem( h, c, hArray );
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
      LI.pszText = hb_parc( 5 );
      ListView_SetItem( hWnd, &LI );
   }
   else if( iType == 2 && ISNUM( 5 ) )
   {
      LI.iImage = hb_parni( 5 );
      ListView_SetItem( hWnd, &LI );
   }

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
#pragma ENDDUMP





*-----------------------------------------------------------------------------*
FUNCTION GridControlObject( aEditControl, oGrid )
*-----------------------------------------------------------------------------*
Local oGridControl, aEdit2, cControl
   oGridControl := nil
   If HB_IsArray( aEditControl ) .AND. Len( aEditControl ) >= 1 .AND. ValType( aEditControl[ 1 ] ) $ "CM"
      aEdit2 := ACLONE( aEditControl )
      ASIZE( aEdit2, 4 )
      cControl := UPPER( ALLTRIM( aEditControl[ 1 ] ) )
      Do Case
         Case cControl == "MEMO"
            oGridControl := TGridControlMemo():New()
         Case cControl == "DATEPICKER"
            oGridControl := TGridControlDatePicker():New( aEdit2[ 2 ] )
         Case cControl == "COMBOBOX"
            oGridControl := TGridControlComboBox():New( aEdit2[ 2 ], oGrid )
         Case cControl == "COMBOBOXTEXT"
            oGridControl := TGridControlComboBoxText():New( aEdit2[ 2 ], oGrid )
         Case cControl == "SPINNER"
            oGridControl := TGridControlSpinner():New( aEdit2[ 2 ], aEdit2[ 3 ] )
         Case cControl == "CHECKBOX"
            oGridControl := TGridControlCheckBox():New( aEdit2[ 2 ], aEdit2[ 3 ] )
         Case cControl == "TEXTBOX"
            oGridControl := TGridControlTextBox():New( aEdit2[ 3 ], aEdit2[ 4 ], aEdit2[ 2 ] )
         Case cControl == "IMAGELIST"
            oGridControl := TGridControlDatePicker():New( oGrid )
         Case cControl == "LCOMBOBOX"
            oGridControl := TGridControlLComboBox():New( aEdit2[ 2 ], aEdit2[ 3 ] )
      EndCase
   EndIf
Return oGridControl

*-----------------------------------------------------------------------------*
FUNCTION GridControlObjectByType( uValue )
*-----------------------------------------------------------------------------*
Local oGridControl := NIL, cMask, nPos
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
         oGridControl := TGridControlTextBox():New( ,, "C" )
      OtherWise
         // Non-implemented data type!!!
   EndCase
Return oGridControl

Function GetEditControlFromArray( oEditControl, aEditControls, nColumn, oGrid )
   If HB_IsArray( oEditControl )
      oEditControl := GridControlObject( oEditControl, oGrid )
   EndIf
   If !HB_IsObject( oEditControl ) .AND. HB_IsArray( aEditControls ) .AND. HB_IsNumeric( nColumn ) .AND. nColumn >= 1 .AND. Len( aEditControls ) >= nColumn
      oEditControl := aEditControls[ nColumn ]
      If HB_IsArray( oEditControl )
         oEditControl := GridControlObject( oEditControl, oGrid )
      EndIf
   EndIf
   If !HB_IsObject( oEditControl )
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
   METHOD SetFocus          BLOCK { |Self| ::oControl:SetFocus() }
   METHOD SetValue(uValue)  BLOCK { |Self,uValue| ::oControl:Value := uValue }
   METHOD ControlValue      SETGET
   METHOD Enabled           SETGET
   METHOD OnLostFocus       SETGET
ENDCLASS

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize ) CLASS TGridControl
Local lRet := .F.
   if .not. iswindowdefined(_oohg_gridwn)
       DEFINE WINDOW _oohg_gridwn OBJ ::oWindow ;
          AT nRow, nCol WIDTH nWidth HEIGHT nHeight ;
          MODAL NOSIZE NOCAPTION ;
          FONT cFontName SIZE nFontSize

          ON KEY RETURN OF ( ::oWindow ) ACTION ( IF( ::oWindow:Active, lRet := ::Valid(), Nil ) )
          ON KEY ESCAPE OF ( ::oWindow ) ACTION ( IF( ::oWindow:Active, ::oWindow:Release(), Nil ) )

          ::CreateControl( uValue, ::oWindow, 0, 0, nWidth, nHeight )
          ::Value := ::ControlValue

      END WINDOW
   endif
   if iswindowdefined(_oohg_gridwn) .and. .not. iswindowactive(_oohg_gridwn)
      if HB_IsObject(::oControl)
         ::oControl:SetFocus()
      endif
      if HB_IsObject(::oWindow)
         ::oWindow:Activate()
      endif
   endif
Return lRet

METHOD Valid() CLASS TGridControl
Local lValid, uValue

   uValue := ::ControlValue

   If ValType( ::cMemVar ) $ "CM" .AND. ! Empty( ::cMemVar )
      &( ::cMemVar ) := uValue
   EndIf

   _OOHG_ThisItemCellValue := uValue
   lValid := _OOHG_Eval( ::bValid, uValue )
   _CheckCellNewValue( Self, @uValue )
   If !HB_IsLogical( lValid )
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

METHOD ControlValue( uValue ) CLASS TGridControl
   If PCOUNT() >= 1
      ::oControl:Value := uValue
   EndIf
Return ::oControl:Value

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
   METHOD CreateWindow
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

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize ) CLASS TGridControlTextBox
Return ::Super:CreateWindow( uValue, nRow - 3, nCol - 3, nWidth + 6, nHeight + 6, cFontName, nFontSize )

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlTextBox
   If Valtype( uValue ) == "C"
      uValue := ::Str2Val( uValue )
   EndIf
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

          ON KEY ESCAPE OF ( ::oWindow ) ACTION ( ::oWindow:Release() )

          @ 07,10 LABEL 0    PARENT ( ::oWindow ) VALUE ""   WIDTH 280
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
   @ nRow,nCol EDITBOX 0 OBJ ::oControl PARENT ( cWindow ) VALUE STRTRAN( uValue, chr(141), ' ' ) HEIGHT nHeight WIDTH nWidth
Return ::oControl

*-----------------------------------------------------------------------------*
CLASS TGridControlDatePicker FROM TGridControl
*-----------------------------------------------------------------------------*
   DATA lUpDown

   METHOD New
   METHOD CreateWindow
   METHOD CreateControl
   METHOD Str2Val(uValue)   BLOCK { |Self,uValue| Empty( Self ), CTOD( uValue ) }
   METHOD GridValue(uValue) BLOCK { |Self,uValue| Empty( Self ), DTOC( uValue ) }
ENDCLASS

METHOD New( lUpDown ) CLASS TGridControlDatePicker
   If !HB_IsLogical( lUpDown )
      lUpDown := .F.
   Endif
   ::lUpDown := lUpDown
Return Self

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize ) CLASS TGridControlDatePicker
Return ::Super:CreateWindow( uValue, nRow - 3, nCol - 3, nWidth + 6, nHeight + 6, cFontName, nFontSize )

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlDatePicker
   If ValType( uValue ) == "C"
      uValue := CTOD( uValue )
   EndIf
   If ::lUpDown
      @ nRow,nCol DATEPICKER 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue UPDOWN
   Else
      @ nRow,nCol DATEPICKER 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth HEIGHT nHeight VALUE uValue
   EndIf
Return ::oControl

*-----------------------------------------------------------------------------*
CLASS TGridControlComboBox FROM TGridControl
*-----------------------------------------------------------------------------*
   DATA aItems INIT {}
   DATA oGrid  INIT nil

   METHOD New
   METHOD CreateWindow
   METHOD CreateControl
   METHOD Str2Val
   METHOD GridValue(uValue) BLOCK { |Self,uValue| if( ( uValue >= 1 .AND. uValue <= Len( ::aItems ) ), ::aItems[ uValue ], "" ) }
ENDCLASS

METHOD New( aItems, oGrid ) CLASS TGridControlComboBox
   If HB_IsArray( aItems )
      ::aItems := aItems
   EndIf
   ::oGrid := oGrid
Return Self

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize ) CLASS TGridControlComboBox
Return ::Super:CreateWindow( uValue, nRow - 3, nCol - 3, nWidth + 6, nHeight + 6, cFontName, nFontSize )

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlComboBox
   Empty( nHeight )
   If ValType( uValue ) == "C"
      uValue := aScan( ::aItems, { |c| c == uValue } )
   EndIf
   @ nRow,nCol COMBOBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth VALUE uValue ITEMS ::aItems
   If ! Empty( ::oGrid ) .AND. ::oGrid:ImageList != 0
      ::oControl:ImageList := ImageList_Duplicate( ::oGrid:ImageList )
   EndIf
Return ::oControl

METHOD Str2Val( uValue ) CLASS TGridControlComboBox
Return ASCAN( ::aItems, { |c| c == uValue } )

*-----------------------------------------------------------------------------*
CLASS TGridControlComboBoxText FROM TGridControl
*-----------------------------------------------------------------------------*
   DATA aItems INIT {}
   DATA oGrid  INIT nil

   METHOD New
   METHOD CreateWindow
   METHOD CreateControl
   METHOD Str2Val
   METHOD GridValue(uValue) BLOCK { |Self,uValue| ::Str2Val(uValue) }
   METHOD ControlValue      SETGET
ENDCLASS

METHOD New( aItems, oGrid ) CLASS TGridControlComboBoxText
   If HB_IsArray( aItems )
      ::aItems := aItems
   EndIf
   ::oGrid := oGrid
Return Self

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize ) CLASS TGridControlComboBoxText
Return ::Super:CreateWindow( uValue, nRow - 3, nCol - 3, nWidth + 6, nHeight + 6, cFontName, nFontSize )

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
   nPos := ASCAN( ::aItems, { |c| c == uValue } )
Return IF( nPos == 0, "", ::aItems[ nPos ] )

METHOD ControlValue( uValue ) CLASS TGridControlComboBoxText
Local nPos
   If PCOUNT() >= 1
      ::oControl:Value := ::Str2Val( uValue )
   EndIf
   nPos := ::oControl:Value
Return IF( nPos == 0, "", ::aItems[ nPos ] )

*-----------------------------------------------------------------------------*
CLASS TGridControlSpinner FROM TGridControl
*-----------------------------------------------------------------------------*
   DATA nRangeMin INIT 0
   DATA nRangeMax INIT 100

   METHOD New
   METHOD CreateWindow
   METHOD CreateControl
   METHOD Str2Val(uValue)   BLOCK { |Self,uValue| Empty( Self ), Val( AllTrim( uValue ) ) }
   METHOD GridValue(uValue) BLOCK { |Self,uValue| Empty( Self ), LTrim( Str( uValue ) ) }
ENDCLASS

METHOD New( nRangeMin, nRangeMax ) CLASS TGridControlSpinner
   If HB_IsNumeric( nRangeMin )
      ::nRangeMin := nRangeMin
   EndIf
   If HB_IsNumeric( nRangeMax )
      ::nRangeMax := nRangeMax
   EndIf
Return Self

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize ) CLASS TGridControlSpinner
Return ::Super:CreateWindow( uValue, nRow - 3, nCol - 3, nWidth + 6, nHeight + 6, cFontName, nFontSize )

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

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize ) CLASS TGridControlCheckBox
Return ::Super:CreateWindow( uValue, nRow - 3, nCol - 3, nWidth + 6, nHeight + 6, cFontName, nFontSize )

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlCheckBox
   If ValType( uValue ) == "C"
      uValue := ( uValue == ::cTrue .OR. UPPER( uValue ) == ".T." )
   EndIf
   @ nRow,nCol CHECKBOX 0 OBJ ::oControl PARENT ( cWindow ) CAPTION if( uValue, ::cTrue, ::cFalse ) WIDTH nWidth HEIGHT nHeight VALUE uValue ;
               ON CHANGE ( ::oControl:Caption := if( ::oControl:Value, ::cTrue, ::cFalse ) )
Return ::oControl

*-----------------------------------------------------------------------------*
CLASS TGridControlImageList FROM TGridControl
*-----------------------------------------------------------------------------*
   DATA oGrid

   METHOD New
   METHOD CreateWindow
   METHOD CreateControl
   METHOD Str2Val(uValue)   BLOCK { |Self,uValue| Empty( Self ), Val( uValue ) }
   METHOD ControlValue      SETGET
ENDCLASS

METHOD New( oGrid ) CLASS TGridControlImageList
   ::oGrid := oGrid
Return Self

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize ) CLASS TGridControlImageList
Return ::Super:CreateWindow( uValue, nRow - 3, nCol - 3, nWidth + 6, nHeight + 6, cFontName, nFontSize )

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlImageList
   Empty( nHeight )
   If ValType( uValue ) == "C"
      uValue := Val( uValue )
   EndIf
   @ nRow,nCol COMBOBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth VALUE 0 ITEMS {}
   If ! Empty( ::oGrid ) .AND. ::oGrid:ImageList != 0
      ::oControl:ImageList := ImageList_Duplicate( ::oGrid:ImageList )
   EndIf
   AEVAL( ARRAY( ImageList_GetImageCount( ::oGrid:ImageList ) ), { |x,i| ::oControl:AddItem( i - 1 ), x } )
   ::oControl:Value := uValue + 1
Return ::oControl

METHOD ControlValue( uValue ) CLASS TGridControlImageList
   If PCOUNT() >= 1
      ::oControl:Value := uValue + 1
   EndIf
Return ::oControl:Value - 1

*-----------------------------------------------------------------------------*
CLASS TGridControlLComboBox FROM TGridControl
*-----------------------------------------------------------------------------*
   DATA cTrue  INIT ".T."
   DATA cFalse INIT ".F."

   METHOD New
   METHOD CreateWindow
   METHOD CreateControl
   METHOD Str2Val(uValue)   BLOCK { |Self,uValue| ( uValue == ::cTrue .OR. UPPER( uValue ) == ".T." ) }
   METHOD GridValue(uValue) BLOCK { |Self,uValue| If( uValue, ::cTrue, ::cFalse ) }
   METHOD ControlValue      SETGET
ENDCLASS

METHOD New( cTrue, cFalse ) CLASS TGridControlLComboBox
   If ValType( cTrue ) $ "CM"
      ::cTrue := cTrue
   EndIf
   If ValType( cFalse ) $ "CM"
      ::cFalse := cFalse
   EndIf
Return Self

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize ) CLASS TGridControlLComboBox
Return ::Super:CreateWindow( uValue, nRow - 3, nCol - 3, nWidth + 6, nHeight + 6, cFontName, nFontSize )

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS TGridControlLComboBox
   Empty( nHeight )
   If ValType( uValue ) == "C"
      uValue := ( uValue == ::cTrue .OR. UPPER( uValue ) == ".T." )
   EndIf
   uValue := if( uValue, 1, 2 )
   @ nRow,nCol COMBOBOX 0 OBJ ::oControl PARENT ( cWindow ) WIDTH nWidth VALUE uValue ITEMS { ::cTrue, ::cFalse }
Return ::oControl

METHOD ControlValue( uValue ) CLASS TGridControlLComboBox
   If PCOUNT() >= 1
      ::oControl:Value := If( uValue, 1, 2 )
   EndIf
Return ( ::oControl:Value == 1 )
