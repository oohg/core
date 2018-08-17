/*
 * $Id: h_tab.prg $
 */
/*
 * ooHG source code:
 * Tab control
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
#include "hbclass.ch"
#include "i_windefs.ch"

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TTab FROM TTabMulti

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TTabDirect FROM TTabRaw

   DATA aPages                    INIT {}
   DATA lInternals                INIT .F.
   DATA nFirstValue               INIT NIL
// DATA Type                      INIT "TAB" READONLY

   METHOD AddControl
   METHOD AddPage
   METHOD AdjustResize
   METHOD Caption
   METHOD Define
   METHOD DeleteControl
   METHOD DeletePage
   METHOD Enabled                 SETGET
   METHOD EndPage                 BLOCK { || _OOHG_DeleteFrame( "TABPAGE" ) }
   METHOD EndTab
   METHOD ForceHide
   METHOD HidePage
   METHOD ItemCount               BLOCK { |Self| Len( ::aPages ) }
   METHOD Picture
   METHOD RealPosition
   METHOD Refresh
   METHOD RefreshData
   METHOD Release
   METHOD SaveData
   METHOD ShowPage
   METHOD SizePos
   METHOD Value                   SETGET
   METHOD Visible                 SETGET

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( cControlName, uParentForm, nCol, nRow, nWidth, nHeight, aCaptions, aPageMap, nValue, ;
               cFontName, nFontSize, cToolTip, bChange, lButtons, lFlatBut, lHotTrack, lVertical, ;
               lNoTabStop, aMnemonic, lBold, lItalic, lUnderline, lStrikeout, aImages, lRtl, lInternals, ;
               lInvisible, lDisabled, lMultiLin, lNoProc, lRight, lBottom, bRClick, lRagged, lFixWidth, ;
               aTabToolTips, nItemW, nItemH, nMinW, nHPad, nVPad, uBackColor, lIcoLeft, lLblLeft, lRightJus, ;
               lScrollOp, bClick ) CLASS TTabDirect

   LOCAL i, cCaption, cImage, aControls, bMnemonic, uToolTip

   ::Super:Define( cControlName, uParentForm, nCol, nRow, nWidth, nHeight, NIL, NIL, ;
                   cFontName, nFontSize, cToolTip, NIL, lButtons, lFlatBut, ;
                   lHotTrack, lVertical, lNoTabStop, lBold, lItalic, lUnderline, ;
                   lStrikeout, NIL, lRtl, lInvisible, lDisabled, lMultiLin, ;
                   lRight, lBottom, NIL, lRagged, lFixWidth, NIL, nItemW, ;
                   nItemH, nMinW, nHPad, nVPad, uBackColor, lIcoLeft, lLblLeft, ;
                   lRightJus, lScrollOp, NIL )

   IF HB_ISLOGICAL( lNoProc )
      ::lProcMsgsOnVisible := ! lNoProc
   ENDIF

   ASSIGN ::lInternals VALUE lInternals TYPE "L"

   IF ! ::lInternals .AND. ! Empty( ::Container )
      SetWindowPos( ::hWnd, 0, 0, 0, 0, 0, SWP_NOSIZE + SWP_NOMOVE )
   ENDIF

   _OOHG_AddFrame( Self )

   // Add page by page
   IF ! HB_ISARRAY( aCaptions )
      aCaptions := {}
   ENDIF
   IF ! HB_ISARRAY( aImages )
      aImages := {}
   ENDIF
   IF ! HB_ISARRAY( aPageMap )
      aPageMap := {}
   ENDIF
   IF ! HB_ISARRAY( aMnemonic )
      aMnemonic := {}
   ENDIF
   IF ! HB_ISARRAY( aTabToolTips )
      aTabToolTips := {}
   ENDIF
   i := 1
   DO WHILE i <= Len( aCaptions ) .AND. i <= Len( aImages ) .AND. i <= Len( aPageMap )
      IF i <= Len( aCaptions ) .AND. ValType( aCaptions[ i ] ) $ "CM"
         cCaption := aCaptions[ i ]
      ELSE
         cCaption := ""
      ENDIF
      IF i <= Len( aImages ) .AND. ValType( aImages[ i ] ) $ "CM"
         cImage := aImages[ i ]
      ELSE
         cImage := ""
      ENDIF
      IF i <= Len( aPageMap ) .AND. HB_ISARRAY( aPageMap[ i ] )
         aControls := aPageMap[ i ]
      ELSE
         aControls := NIL
      ENDIF
      IF i <= Len( aMnemonic ) .AND. HB_ISBLOCK( aMnemonic[ i ] )
         bMnemonic := aMnemonic[ i ]
      ELSE
         bMnemonic := NIL
      ENDIF
      IF i <= Len( aTabToolTips ) .AND. ( ValType( aTabToolTips[ i ] ) $ "CM" .OR. HB_ISBLOCK( aTabToolTips[ i ] ) )
         uToolTip := aTabToolTips[ i ]
      ELSE
         uToolTip := ""
      ENDIF
      ::AddPage( NIL, cCaption, cImage, aControls, bMnemonic, NIL, NIL, uToolTip )
      i ++
   ENDDO

   IF HB_ISNUMERIC( nValue )
      ::Value := nValue
   ELSE
      ::Value := 1
   ENDIF

   ASSIGN ::OnChange VALUE bChange TYPE "B"
   ASSIGN ::OnClick  VALUE bClick  TYPE "B"
   ASSIGN ::OnRClick VALUE bRClick TYPE "B"

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndTab() CLASS TTabDirect

   IF _OOHG_LastFrame() == "TABPAGE"
      // ERROR: Last page not finished
      ::EndPage()
   ENDIF
   _OOHG_DeleteFrame( ::Type )
   IF HB_ISNUMERIC( ::nFirstValue ) .AND. ! ::Value == ::nFirstValue
      ::Value := ::nFirstValue
   ENDIF
   ::SizePos()

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Refresh() CLASS TTabDirect

   LOCAL nPage, nFocused

   nFocused := GetFocus()
   nPage := iif( ::Visible, ::Value, 0 )
   AEval( ::aPages, { |p,i| p:Position := i, p:ForceHide() } )
   IF nPage >= 1 .AND. nPage <= Len( ::aPages )
      ::aPages[ nPage ]:Show()
      IF ! ::lProcMsgsOnVisible
         ProcessMessages()
      ENDIF
   ENDIF

   IF ValidHandler( nFocused )
      IF IsWindowVisible( nFocused )
         IF ! GetFocus() == nFocused
            SetFocus( nFocused )
         ENDIF
      ELSE
         ::SetFocus()
      ENDIF
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD RefreshData() CLASS TTabDirect

   ::Super:RefreshData()
   AEval( ::aPages, { |o| o:RefreshData() } )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Release() CLASS TTabDirect

   AEval( ::aPages, { |o| o:Release() } )

   RETURN ::Super:Release()

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SizePos( nRow, nCol, nWidth, nHeight ) CLASS TTabDirect

   ::Super:SizePos( nRow, nCol, nWidth, nHeight )
   AEval( ::aPages, { |o| o:Events_Size() } )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value( nValue ) CLASS TTabDirect

   LOCAL nPos, nCount

   IF HB_ISNUMERIC( nValue )
      nPos := ::RealPosition( nValue )
      IF nPos != 0
         TabCtrl_SetCurSel( ::hWnd, nPos )
         ::Refresh()
         ::DoChange()
      ENDIF
   ENDIF
   nPos := TabCtrl_GetCurSel( ::hWnd )
   nCount := 0
   nValue := AScan( ::aPages, { |o| iif( o:lHidden,, nCount ++ ), ( nCount == nPos ) } )

   RETURN nValue

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Enabled( lEnabled ) CLASS TTabDirect

   LOCAL nPos

   IF HB_ISLOGICAL( lEnabled )
      ::Super:Enabled := lEnabled
      nPos := ::Value
      IF nPos <= Len( ::aPages ) .AND. nPos >= 1
         ::aPages[ nPos ]:Enabled := ::aPages[ nPos ]:Enabled
      ENDIF
   ENDIF

   RETURN ::Super:Enabled

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Visible( lVisible ) CLASS TTabDirect

   LOCAL nPos, aPages

   IF HB_ISLOGICAL( lVisible )
      ::Super:Visible := lVisible
      nPos := ::Value
      aPages := ::aPages
      IF nPos <= Len( aPages ) .AND. nPos >= 1
         IF lVisible .AND. aPages[ nPos ]:Visible
            aPages[ nPos ]:Visible := .T.
         ELSE
            aPages[ nPos ]:ForceHide()
         ENDIF
      ENDIF
      IF ! ::lProcMsgsOnVisible
         ProcessMessages()
      ENDIF
   ENDIF

   RETURN ::lVisible

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ForceHide() CLASS TTabDirect

   LOCAL nPos

   nPos := ::Value
   IF nPos <= Len( ::aPages ) .AND. nPos >= 1
      ::aPages[ nPos ]:ForceHide()
   ENDIF

   RETURN ::Super:ForceHide()

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD AdjustResize( nDivh, nDivw, lSelfOnly ) CLASS TTabDirect

   // Next sentence forces the page's width and height to be the same as the
   // container's, because it calls ::SizePos() who call ::Events_Size() for
   // each page. So, for each page, we only need to adjust/resize the controls.
   // .T. is needed to avoid calling ::AdjustResize() for the TTabRaw control.

   ::Super:AdjustResize( nDivh, nDivw, .T. )
   AEval( ::aPages, { |o| o:AdjustResize( nDivh, nDivw, lSelfOnly ) } )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD AddPage( nPosition, cCaption, cImage, aControls, bMnemonic, cName, oSubClass, uToolTip ) CLASS TTabDirect

   LOCAL oPage, nPos

   IF ! HB_ISNUMERIC( nPosition ) .OR. nPosition < 1 .OR. nPosition > Len( ::aPages )
      nPosition := Len( ::aPages ) + 1
   ENDIF

   IF ! ValType( cImage ) $ 'CM'
      cImage := ''
   ENDIF

   IF ! ValType( cCaption ) $ 'CM'
      cCaption := ''
   ELSE
      IF ! Empty( cImage ) .AND. IsXPThemeActive() .AND. At( '&', cCaption ) != 0
         cCaption := Space( 3 ) + cCaption
      ENDIF
   ENDIF

   IF ! ValType( uToolTip ) $ 'CM' .AND. ! HB_ISBLOCK( uToolTip )
      uToolTip := ''
   ENDIF

   IF HB_ISOBJECT( oSubClass )
      oPage := oSubClass
   ELSEIF ::lInternals
      oPage := TTabPageInternal()
   ELSE
      oPage := TTabPage()
   ENDIF
   oPage:Define( cName, Self )

   oPage:Caption   := cCaption
   oPage:Picture   := cImage
   oPage:Position  := nPosition
   oPage:ToolTip   := uToolTip

   AAdd( ::aPages, NIL )
   AIns( ::aPages, nPosition )
   ::aPages[ nPosition ] := oPage

   oPage:Events_Size()

   IF ! Empty( cImage )
      oPage:nImage := ::AddBitMap( cImage ) - 1
   ENDIF

   ::InsertItem( ::RealPosition( nPosition ), cCaption, oPage:nImage, uToolTip )

   IF HB_ISARRAY( aControls )
      AEval( aControls, { |o| ::AddControl( o, nPosition ) } )
   ENDIF

   nPos := At( '&', cCaption )
   IF nPos > 0 .AND. nPos < Len( cCaption )
      IF ! HB_ISBLOCK( bMnemonic )
         bMnemonic := { || oPage:SetFocus() }
      ENDIF
      DEFINE HOTKEY 0 PARENT ( ::Parent ) KEY "ALT+" + SubStr( cCaption, nPos + 1, 1 ) ACTION ::DoEvent( bMnemonic, "CHANGE" )
   ENDIF

   IF ::Value == nPosition
      ::Refresh()
   ELSE
      oPage:ForceHide()
   ENDIF

   oPage:nFixedHeightUsed := ::TabsAreaHeight()

   RETURN oPage

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _BeginTabPage( cCaption, cImage, nPosition, cName, oSubClass, uToolTip )

   LOCAL oCtrl, oPage

   IF _OOHG_LastFrame() == "TABPAGE"
      // ERROR: Last page not finished
      _EndTabPage()
   ENDIF
   ///// IF _OOHG_LastFrame() == "TAB" ...
   oCtrl := ATail( _OOHG_ActiveFrame )
   oPage := oCtrl:AddPage( nPosition, cCaption, cImage, NIL, NIL, cName, oSubClass, uToolTip )
   _OOHG_AddFrame( oPage )

   RETURN oPage

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _EndTabPage()

   _OOHG_DeleteFrame( "TABPAGE" )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _EndTab()

   IF _OOHG_LastFrame() == "TABPAGE"
      // ERROR: Last page not finished
      _EndTabPage()
   ENDIF
   ATail( _OOHG_ActiveFrame ):EndTab()

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD AddControl( oCtrl, nPageNumber, nRow, nCol ) CLASS TTabDirect

   IF ValType( oCtrl ) $ "CM"
      oCtrl := ::Parent:Control( oCtrl )
   ENDIF

   IF ! HB_ISNUMERIC( nPageNumber ) .OR. nPageNumber > Len( ::aPages )
      nPageNumber := Len( ::aPages )
   ENDIF

   IF nPageNumber < 1
      nPageNumber := 1
   ENDIF

   IF ! HB_ISNUMERIC( nRow )
      nRow := oCtrl:ContainerRow - ::ContainerRow
   ENDIF

   IF ! HB_ISNUMERIC( nCol )
      nCol := oCtrl:ContainerCol - ::ContainerCol
   ENDIF

   oCtrl:lProcMsgsOnVisible := ::lProcMsgsOnVisible

   ::aPages[ nPageNumber ]:AddControl( oCtrl, nRow, nCol )
   oCtrl:Container := ::aPages[ nPageNumber ]
   IF oCtrl:Type == "TAB"
      SetWindowPos( oCtrl:oContainerBase:hWnd, 0, 0, 0, 0, 0, SWP_NOSIZE + SWP_NOMOVE )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DeletePage( nPosition ) CLASS TTabDirect

   LOCAL nValue, nRealPosition

   IF ! HB_ISNUMERIC( nPosition ) .OR. nPosition < 1 .OR. nPosition > Len( ::aPages )
      nPosition := Len( ::aPages )
   ENDIF

   nValue := ::Value
   nRealPosition := ::RealPosition( nPosition )

   ::aPages[ nPosition ]:Release()
   _OOHG_DeleteArrayItem( ::aPages, nPosition )
   IF nRealPosition != 0
      ::DeleteItem( nRealPosition )
   ENDIF

   IF nValue == nPosition
      ::Refresh()
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DeleteControl( oCtrl ) CLASS TTabDirect

   RETURN AEval( ::aPages, { |o| o:DeleteControl( oCtrl ) } )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD RealPosition( nPage ) CLASS TTabDirect

   LOCAL nCount := 0

   IF nPage >= 1 .AND. nPage <= Len( ::aPages ) .AND. ! ::aPages[ nPage ]:lHidden
      AEval( ::aPages, { |o| iif( o:lHidden,, nCount ++ ) }, 1, nPage )
   ENDIF

   RETURN nCount

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD HidePage( nPage ) CLASS TTabDirect

   LOCAL nPos

   IF nPage >= 1 .AND. nPage <= Len( ::aPages ) .AND. ! ::aPages[ nPage ]:lHidden
      nPos := ::Value
      // Disable hotkey!
      ::DeleteItem( ::RealPosition( nPage ) )
      ::aPages[ nPage ]:lHidden := .T.
      IF nPos > 0
         ::aPages[ nPos ]:ForceHide()
      ENDIF
      nPos := AScan( ::aPages, { |o| ! o:lHidden }, Max( nPos, 1 ) )
      IF nPos == 0
         nPos := AScan( ::aPages, { |o| ! o:lHidden }, 1 )
      ENDIF
      IF nPos > 0
         ::Value := nPos
         ::aPages[ nPos ]:Show()
         IF ! ::lProcMsgsOnVisible
            ProcessMessages()
         ENDIF
      ENDIF
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ShowPage( nPage ) CLASS TTabDirect

   LOCAL nRealPosition

   IF nPage >= 1 .AND. nPage <= Len( ::aPages ) .AND. ::aPages[ nPage ]:lHidden
      ::aPages[ nPage ]:lHidden := .F.
      nRealPosition := ::RealPosition( nPage )
      ::InsertItem( nRealPosition, ::aPages[ nPage ]:Caption, ::aPages[ nPage ]:nImage, ::aPages[ nPage ]:ToolTip )
      IF ::Value == nPage
         ::Refresh()
      ENDIF
      // Enable hotkey!
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Caption( nColumn, uValue ) CLASS TTabDirect

   LOCAL nRealPosition

   nRealPosition := ::RealPosition( nColumn )
   IF nRealPosition > 0
      IF ValType( uValue ) $ "CM"
         ::Super:Caption( nRealPosition, uValue )
      ENDIF
      ::aPages[ nColumn ]:Caption := ::Super:Caption( nRealPosition )
   ELSE
      IF ValType( uValue ) $ "CM"
         ::aPages[ nColumn ]:Caption := uValue
      ENDIF
   ENDIF

   RETURN ::aPages[ nColumn ]:Caption

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Picture( nColumn, uValue ) CLASS TTabDirect

   LOCAL oPage, nRealPosition

   oPage := ::aPages[ nColumn ]
   IF ValType( uValue ) $ "CM"
      oPage:Picture := uValue
      oPage:nImage := ::AddBitMap( uValue ) - 1
      nRealPosition := ::RealPosition( nColumn )
      IF nRealPosition != 0
         SetTabPageImage( ::hWnd, nRealPosition, oPage:nImage )
         ::Refresh()
      ENDIF
   ENDIF

   RETURN oPage:Picture

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SaveData() CLASS TTabDirect

   _OOHG_EVAL( ::Block, ::Value )
   AEval( ::aPages, { |o| o:SaveData() } )

   RETURN NIL


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TTabCombo FROM TMultiPage

   DATA lInternals                INIT .F.
   DATA Type                      INIT "TAB" READONLY

   METHOD Define

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( cControlName, uParentForm, nCol, nRow, nWidth, nHeight, aCaptions, aPageMap, nValue, ;
               cFontName, nFontSize, cToolTip, bChange, lButtons, lFlatBut, lHotTrack, lVertical, ;
               lNoTabStop, aMnemonic, lBold, lItalic, lUnderline, lStrikeout, aImages, lRtl, ;
               lInternals, lInvisible, lDisabled, lMultiLin, lNoProc, bRClick, bClick ) CLASS TTabCombo

   ::Super:Define( cControlName, uParentForm, nCol, nRow, nWidth, nHeight, NIL, NIL, ;
                   cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout, ;
                   lInvisible, lDisabled, lRtl, bChange, nValue, lNoProc )

   HB_SYMBOL_UNUSED( lButtons )
   HB_SYMBOL_UNUSED( lFlatBut )
   HB_SYMBOL_UNUSED( lHotTrack )
   HB_SYMBOL_UNUSED( lVertical )
   HB_SYMBOL_UNUSED( lMultiLin )

   @ 0,0 COMBOBOX 0 OBJ ::oContainerBase PARENT ( Self ) ;
         ITEMS {} TOOLTIP cToolTip
   IF HB_ISLOGICAL( lNoTabStop ) .AND. lNoTabStop
      ::oContainerBase:TabStop := .F.
   ENDIF

   ASSIGN ::lInternals VALUE lInternals TYPE "L"
   IF ::lInternals
      ::oPageClass := TTabPageInternal()
   ENDIF

   ::CreatePages( aCaptions, aImages, aPageMap, aMnemonic )

   ::oContainerBase:OnChange := { || ::Refresh(), ::DoChange() }
   ::oContainerBase:OnClick  := bClick
   ::oContainerBase:OnRClick := bRClick

   RETURN Self


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TTabRadio FROM TMultiPage

   DATA lInternals                INIT .F.
   DATA Type                      INIT "TAB" READONLY

   METHOD Define

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( cControlName, uParentForm, nCol, nRow, nWidth, nHeight, aCaptions, aPageMap, nValue, ;
               cFontName, nFontSize, cToolTip, bChange, lButtons, lFlatBut, lHotTrack, lVertical, ;
               lNoTabStop, aMnemonic, lBold, lItalic, lUnderline, lStrikeout, aImages, lRtl, ;
               lInternals, lInvisible, lDisabled, lMultiLin, lNoProc, bRClick, aTabToolTips, bClick ) CLASS TTabRadio

   ::Super:Define( cControlName, uParentForm, nCol, nRow, nWidth, nHeight, NIL, NIL, ;
                   cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout, ;
                   lInvisible, lDisabled, lRtl, bChange, nValue, lNoProc )

   HB_SYMBOL_UNUSED( lButtons )
   HB_SYMBOL_UNUSED( lFlatBut )
   HB_SYMBOL_UNUSED( lHotTrack )
   HB_SYMBOL_UNUSED( lMultiLin )

   @ 0,0 RADIOGROUP 0 OBJ ::oContainerBase PARENT ( Self ) ;
         OPTIONS {} TOOLTIP cToolTip HORIZONTAL
   IF HB_ISLOGICAL( lVertical )
      ::oContainerBase:lHorizontal := ! lVertical
   ENDIF
   IF HB_ISLOGICAL( lNoTabStop ) .AND. lNoTabStop
      ::oContainerBase:TabStop := .F.
   ENDIF

   ASSIGN ::lInternals VALUE lInternals TYPE "L"
   IF ::lInternals
      ::oPageClass := TTabPageInternal()
   ENDIF

   ::CreatePages( aCaptions, aImages, aPageMap, aMnemonic, aTabToolTips )

   ::oContainerBase:OnChange := { || ::Refresh(), ::DoChange() }
   ::oContainerBase:OnClick  := bClick
   ::oContainerBase:OnRClick := bRClick

   RETURN Self


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TTabMulti FROM TMultiPage

   DATA lInternals                INIT .F.
   DATA Type                      INIT "TAB" READONLY

   METHOD AddPage
   METHOD Define

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( cControlName, uParentForm, nCol, nRow, nWidth, nHeight, aCaptions, aPageMap, nValue, ;
               cFontName, nFontSize, cToolTip, bChange, lButtons, lFlatBut, lHotTrack, lVertical, ;
               lNoTabStop, aMnemonic, lBold, lItalic, lUnderline, lStrikeout, aImages, lRtl, ;
               lInternals, lInvisible, lDisabled, lMultiLin, lNoProc, lRight, lBottom, bRClick, ;
               lRagged, lFixWidth, aTabToolTips, nItemW, nItemH, nMinW, nHPad, nVPad, uBackColor, ;
               lIcoLeft, lLblLeft, lRightJus, lScrollOp, bClick ) CLASS TTabMulti

   ::Super:Define( cControlName, uParentForm, nCol, nRow, nWidth, nHeight, NIL, NIL, ;
                   cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout, ;
                   lInvisible, lDisabled, lRtl, bChange, nValue, lNoProc )

   ::oContainerBase := TTabRaw()
   ::oContainerBase:Define( NIL, Self, 0, 0, nWidth, nHeight, NIL, NIL, ;
                            NIL, NIL, cToolTip, NIL, lButtons, lFlatBut, ;
                            lHotTrack, lVertical, lNoTabStop, NIL, NIL, NIL, ;
                            NIL, NIL, NIL, NIL, NIL, lMultiLin, ;
                            lRight, lBottom, NIL, lRagged, lFixWidth, NIL, nItemW, ;
                            nItemH, nMinW, nHPad, nVPad, uBackColor, lIcoLeft, lLblLeft, ;
                            lRightJus, lScrollOp, NIL )

   ASSIGN ::lInternals VALUE lInternals TYPE "L"
   IF ! ::lInternals
      IF ! Empty( ::Container )
         SetWindowPos( ::oContainerBase:hWnd, 0, 0, 0, 0, 0, SWP_NOSIZE + SWP_NOMOVE )
      ENDIF
   ELSE
      ::oPageClass := TTabPageInternal()
   ENDIF

   ::CreatePages( aCaptions, aImages, aPageMap, aMnemonic, aTabToolTips )

   ::oContainerBase:OnChange := { || ::Refresh(), ::DoChange() }
   ::oContainerBase:OnClick  := bClick
   ::oContainerBase:OnRClick := bRClick

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD AddPage( nPosition, cCaption, cImage, aControls, bMnemonic, cName, oSubClass, uToolTip ) CLASS TTabMulti

   LOCAL oPage

   oPage := ::Super:AddPage( nPosition, cCaption, cImage, aControls, bMnemonic, cName, oSubClass, uToolTip )
   oPage:nFixedHeightUsed := ::oContainerBase:TabsAreaHeight()

   RETURN oPage


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TMultiPage FROM TControlGroup

   DATA aPages                    INIT {}
   DATA nFirstValue               INIT NIL
   DATA oContainerBase            INIT NIL
   DATA oPageClass                INIT TTabPage()
   DATA Type                      INIT "MULTIPAGE" READONLY

   METHOD AddControl
   METHOD AddPage
   METHOD AdjustResize
   METHOD Caption
   METHOD CreatePages
   METHOD Define
   METHOD DeleteControl
   METHOD DeletePage
   METHOD Enabled                 SETGET
   METHOD EndPage                 BLOCK { |Self| _OOHG_DeleteFrame( ::oPageClass:Type ) }
   METHOD EndTab
   METHOD ForceHide
   METHOD HidePage
   METHOD ItemCount               BLOCK { |Self| Len( ::aPages ) }
   METHOD Picture
   METHOD RealPosition
   METHOD Refresh
   METHOD RefreshData
   METHOD Release
   METHOD SaveData
   METHOD SetFocus                BLOCK { |Self| ::oContainerBase:SetFocus() }
   METHOD ShowPage
   METHOD SizePos
   METHOD Value                   SETGET
   METHOD Visible                 SETGET

   // Control-specific methods
   METHOD bBeforeChange           SETGET
   METHOD ContainerCaption(x,y)   BLOCK { |Self,x,y| ::oContainerBase:Caption(x,y) }
   METHOD ContainerItemCount      BLOCK { |Self| ::oContainerBase:ItemCount() }
   METHOD ContainerValue          SETGET
   METHOD DeleteItem
   METHOD hWnd                    BLOCK { |Self| iif( ::oContainerBase == NIL, 0, ::oContainerBase:hWnd ) }
   METHOD InsertItem(w,x,y,z)     BLOCK { |Self,w,x,y,z| ::oContainerBase:InsertItem(w,x,y,z) }
   METHOD ItemAtPos( x, y )       BLOCK { |Self, x, y| ::oContainerBase:ItemAtPos( x, y ) }
   METHOD OnClick                 SETGET
   METHOD OnRClick                SETGET

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( cControlName, uParentForm, nCol, nRow, nWidth, nHeight, uFontColor, uBackColor, ;
               cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout, ;
               lInvisible, lDisabled, lRtl, bChange, nValue, lNoProc ) CLASS TMultiPage

   ASSIGN ::nCol    VALUE nCol    TYPE "N"
   ASSIGN ::nRow    VALUE nRow    TYPE "N"
   ASSIGN ::nWidth  VALUE nWidth  TYPE "N"
   ASSIGN ::nHeight VALUE nHeight TYPE "N"

   ::SetForm( cControlName, uParentForm, cFontName, nFontSize, uFontColor, uBackColor, NIL, lRtl, NIL, lNoProc )
   ::InitStyle( NIL, NIL, lInvisible, NIL, lDisabled )
   ::Register( 0 )
   ::SetFont( NIL, NIL, lBold, lItalic, lUnderline, lStrikeout )

   IF HB_ISNUMERIC( nValue )
      ::nFirstValue := nValue
   ENDIF

   _OOHG_AddFrame( Self )

   ASSIGN ::OnChange VALUE bChange TYPE "B"

   // ::oContainerBase is not created yet!
   // ::oContainerBase:OnChange := { || ::Refresh(), ::DoChange() }

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD CreatePages( aCaptions, aImages, aPageMap, aMnemonic, aTabToolTips ) CLASS TMultiPage

   LOCAL i, cCaption, cImage, aControls, bMnemonic, uToolTip

   IF ! HB_ISARRAY( aCaptions )
      aCaptions := {}
   ENDIF
   IF ! HB_ISARRAY( aImages )
      aImages := {}
   ENDIF
   IF ! HB_ISARRAY( aPageMap )
      aPageMap := {}
   ENDIF
   IF ! HB_ISARRAY( aMnemonic )
      aMnemonic := {}
   ENDIF
   IF ! HB_ISARRAY( aTabToolTips )
      aTabToolTips := {}
   ENDIF

   i := 1
   DO WHILE i <= Len( aCaptions ) .AND. i <= Len( aImages ) .AND. i <= Len( aPageMap )
      IF i <= Len( aCaptions ) .AND. ValType( aCaptions[ i ] ) $ "CM"
         cCaption := aCaptions[ i ]
      ELSE
         cCaption := ""
      ENDIF
      IF i <= Len( aImages ) .AND. ValType( aImages[ i ] ) $ "CM"
         cImage := aImages[ i ]
      ELSE
         cImage := ""
      ENDIF
      IF i <= Len( aPageMap ) .AND. HB_ISARRAY( aPageMap[ i ] )
         aControls := aPageMap[ i ]
      ELSE
         aControls := NIL
      ENDIF
      IF i <= Len( aMnemonic ) .AND. HB_ISBLOCK( aMnemonic[ i ] )
         bMnemonic := aMnemonic[ i ]
      ELSE
         bMnemonic := NIL
      ENDIF
      IF i <= Len( aTabToolTips ) .AND. ( ValType( aTabToolTips[ i ] ) $ "CM" .OR. HB_ISBLOCK( aTabToolTips[ i ] ) )
         uToolTip := aTabToolTips[ i ]
      ELSE
         uToolTip := ""
      ENDIF
      ::AddPage( NIL, cCaption, cImage, aControls, bMnemonic, uToolTip )
      i ++
   ENDDO

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Refresh() CLASS TMultiPage

   LOCAL nPage, nFocused

   nFocused := GetFocus()
   nPage := iif( ::Visible, ::Value, 0 )
   AEval( ::aPages, { |p,i| p:Position := i, p:ForceHide() } )
   IF nPage >= 1 .AND. nPage <= Len( ::aPages )
      ::aPages[ nPage ]:Show()
      IF ! ::lProcMsgsOnVisible
         ProcessMessages()
      ENDIF
   ENDIF

   IF ValidHandler( nFocused )
      IF IsWindowVisible( nFocused )
         IF ! GetFocus() == nFocused
            SetFocus( nFocused )
         ENDIF
      ELSE
         ::SetFocus()
      ENDIF
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD RefreshData() CLASS TMultiPage

   ::Super:RefreshData()
   AEval( ::aPages, { |o| o:RefreshData() } )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Release() CLASS TMultiPage

   AEval( ::aPages, { |o| o:Release() } )

   RETURN ::Super:Release()

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SizePos( nRow, nCol, nWidth, nHeight ) CLASS TMultiPage

   ::Super:SizePos( nRow, nCol, nWidth, nHeight )
   IF ! ::oContainerBase == NIL
      ::oContainerBase:SizePos( 0, 0, nWidth, nHeight )
   ENDIF
   AEval( ::aPages, { |o| o:Events_Size() } )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value( nValue ) CLASS TMultiPage

   LOCAL nPos, nCount

   IF HB_ISNUMERIC( nValue )
      nPos := ::RealPosition( nValue )
      IF nPos != 0
         ::ContainerValue := nPos
      ENDIF
   ENDIF
   nPos := ::ContainerValue
   nCount := 0
   nValue := AScan( ::aPages, { |o| iif( o:lHidden,, nCount ++ ), ( nCount == nPos ) } )

   RETURN nValue

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Enabled( lEnabled ) CLASS TMultiPage

   LOCAL nPos

   IF HB_ISLOGICAL( lEnabled )
      ::Super:Enabled := lEnabled
      nPos := ::Value
      IF nPos <= Len( ::aPages ) .AND. nPos >= 1
         ::aPages[ nPos ]:Enabled := ::aPages[ nPos ]:Enabled
      ENDIF
   ENDIF

   RETURN ::Super:Enabled

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Visible( lVisible ) CLASS TMultiPage

   LOCAL nPos, aPages

   IF HB_ISLOGICAL( lVisible )
      ::Super:Visible := lVisible
      nPos := ::Value
      aPages := ::aPages
      IF nPos <= Len( aPages ) .AND. nPos >= 1
         IF lVisible .AND. aPages[ nPos ]:Visible
            aPages[ nPos ]:Visible := .T.
         ELSE
            aPages[ nPos ]:ForceHide()
         ENDIF
      ENDIF
      IF ! ::lProcMsgsOnVisible
         ProcessMessages()
      ENDIF
   ENDIF

   RETURN ::lVisible

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ForceHide() CLASS TMultiPage

   LOCAL nPos

   nPos := ::Value
   IF nPos <= Len( ::aPages ) .AND. nPos >= 1
      ::aPages[ nPos ]:ForceHide()
   ENDIF

   RETURN ::Super:ForceHide()

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD AdjustResize( nDivh, nDivw, lSelfOnly ) CLASS TMultiPage

   // Next sentence forces the page's width and height to be the same as the
   // container's, because it calls ::SizePos() who call ::Events_Size() for
   // each page. So, for each age, we only need to adjust/resize the controls.
   // .T. is needed to avoid calling ::AdjustResize() for the TTabRaw control.

   ::Super:AdjustResize( nDivh, nDivw, .T. )
   AEval( ::aPages, { |o| o:AdjustResize( nDivh, nDivw, lSelfOnly ) } )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD AddPage( nPosition, cCaption, cImage, aControls, bMnemonic, cName, oSubClass, uToolTip ) CLASS TMultiPage

   LOCAL oPage, nPos

   IF ! HB_ISNUMERIC( nPosition ) .OR. nPosition < 1 .OR. nPosition > Len( ::aPages )
      nPosition := Len( ::aPages ) + 1
   ENDIF

   IF ! ValType( cImage ) $ 'CM'
      cImage := ''
   ENDIF

   IF ! ValType( cCaption ) $ 'CM'
      cCaption := ''
   ELSE
      IF ! Empty( cImage ) .AND. IsXPThemeActive() .AND. At( '&', cCaption ) != 0
         cCaption := Space( 3 ) + cCaption
      ENDIF
   ENDIF

   IF ! ValType( uToolTip ) $ 'CM' .AND. ! HB_ISBLOCK( uToolTip )
      uToolTip := ''
   ENDIF

   IF HB_ISOBJECT( oSubClass )
      oPage := oSubClass
   ELSE
      oPage := __clsInst( ::oPageClass:ClassH )
   ENDIF
   oPage:Define( cName, Self )

   oPage:Caption  := cCaption
   oPage:Picture  := cImage
   oPage:Position := nPosition
   oPage:ToolTip  := uToolTip

   AAdd( ::aPages, NIL )
   AIns( ::aPages, nPosition )
   ::aPages[ nPosition ] := oPage

   oPage:Events_Size()

   IF ! Empty( cImage )
      oPage:nImage := ::oContainerBase:AddBitMap( cImage ) - 1
   ENDIF

   ::InsertItem( ::RealPosition( nPosition ), cCaption, oPage:nImage, uToolTip )

   IF HB_ISARRAY( aControls )
      AEval( aControls, { |o| ::AddControl( o, nPosition ) } )
   ENDIF

   nPos := At( '&', cCaption )
   IF nPos > 0 .AND. nPos < Len( cCaption )
      IF ! HB_ISBLOCK( bMnemonic )
         bMnemonic := { || oPage:SetFocus() }
      ENDIF
      DEFINE HOTKEY 0 PARENT ( ::Parent ) KEY "ALT+" + SubStr( cCaption, nPos + 1, 1 ) ACTION ::DoEvent( bMnemonic, "CHANGE" )
   ENDIF

   IF ::Value == nPosition
      ::Refresh()
   ELSE
      oPage:ForceHide()
   ENDIF

   RETURN oPage

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD AddControl( oCtrl, nPageNumber, nRow, nCol ) CLASS TMultiPage

   IF ValType( oCtrl ) $ "CM"
      oCtrl := ::Parent:Control( oCtrl )
   ENDIF

   IF Len( ::aPages ) == 0
      RETURN ::Super:AddControl( oCtrl )
   ENDIF

   IF ! HB_ISNUMERIC( nPageNumber ) .OR. nPageNumber > Len( ::aPages )
      nPageNumber := Len( ::aPages )
   ENDIF

   IF nPageNumber < 1
      nPageNumber := 1
   ENDIF

   IF ! HB_ISNUMERIC( nRow )
      nRow := oCtrl:ContainerRow - ::ContainerRow
   ENDIF

   IF ! HB_ISNUMERIC( nCol )
      nCol := oCtrl:ContainerCol - ::ContainerCol
   ENDIF

   oCtrl:lProcMsgsOnVisible := ::lProcMsgsOnVisible

   ::aPages[ nPageNumber ]:AddControl( oCtrl, nRow, nCol )
   oCtrl:Container := ::aPages[ nPageNumber ]
   IF oCtrl:Type == "TAB"
      SetWindowPos( oCtrl:oContainerBase:hWnd, 0, 0, 0, 0, 0, SWP_NOSIZE + SWP_NOMOVE )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DeleteControl( oCtrl ) CLASS TMultiPage

   AEval( ::aPages, { |o| o:DeleteControl( oCtrl ) } )

   RETURN ::Super:DeleteControl( oCtrl )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DeletePage( nPosition ) CLASS TMultiPage

   LOCAL nValue, nRealPosition

   IF !HB_ISNUMERIC( nPosition ) .OR. nPosition < 1 .OR. nPosition > Len( ::aPages )
      nPosition := Len( ::aPages )
   ENDIF

   nValue := ::Value
   nRealPosition := ::RealPosition( nPosition )

   ::aPages[ nPosition ]:Release()
   _OOHG_DeleteArrayItem( ::aPages, nPosition )
   IF nRealPosition != 0
      ::DeleteItem( nRealPosition )
   ENDIF

   IF nValue == nPosition
      ::Refresh()
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD RealPosition( nPage ) CLASS TMultiPage

   LOCAL nCount := 0

   IF nPage >= 1 .AND. nPage <= Len( ::aPages ) .AND. ! ::aPages[ nPage ]:lHidden
      AEval( ::aPages, { |o| iif( o:lHidden,, nCount ++ ) }, 1, nPage )
   ENDIF

   RETURN nCount

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD HidePage( nPage ) CLASS TMultiPage

   LOCAL nPos

   IF nPage >= 1 .AND. nPage <= Len( ::aPages ) .AND. ! ::aPages[ nPage ]:lHidden
      nPos := ::Value
      // Disable hotkey!
      ::DeleteItem( ::RealPosition( nPage ) )
      ::aPages[ nPage ]:lHidden := .T.
      IF nPos > 0
         ::aPages[ nPos ]:ForceHide()
      ENDIF
      nPos := AScan( ::aPages, { |o| ! o:lHidden }, Max( nPos, 1 ) )
      IF nPos == 0
         nPos := AScan( ::aPages, { |o| ! o:lHidden }, 1 )
      ENDIF
      IF nPos > 0
         ::Value := nPos
         ::aPages[ nPos ]:Show()
         IF ! ::lProcMsgsOnVisible
            ProcessMessages()
         ENDIF
      ENDIF
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ShowPage( nPage ) CLASS TMultiPage

   IF nPage >= 1 .AND. nPage <= Len( ::aPages ) .AND. ::aPages[ nPage ]:lHidden
      ::aPages[ nPage ]:lHidden := .F.
      ::InsertItem( ::RealPosition( nPage ), ::aPages[ nPage ]:Caption, ::aPages[ nPage ]:nImage, ::aPages[ nPage ]:ToolTip )
      IF ::Value == nPage
         ::Refresh()
      ENDIF
      // Enable hotkey!
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Caption( nColumn, uValue ) CLASS TMultiPage

   LOCAL oPage, nRealPosition

   oPage := ::aPages[ nColumn ]
   nRealPosition := ::RealPosition( nColumn )
   IF nRealPosition > 0
      IF ValType( uValue ) $ "CM"
         ::ContainerCaption( nRealPosition, uValue )
      ENDIF
      oPage:Caption := ::ContainerCaption( nRealPosition )
   ELSE
      IF ValType( uValue ) $ "CM"
         oPage:Caption := uValue
      ENDIF
   ENDIF

   RETURN oPage:Caption

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Picture( nColumn, uValue ) CLASS TMultiPage

   LOCAL oPage, nRealPosition

   oPage := ::aPages[ nColumn ]
   nRealPosition := ::RealPosition( nColumn )
   IF ValType( uValue ) $ "CM"
      oPage:Picture := uValue
      oPage:nImage := ::oContainerBase:AddBitMap( uValue ) - 1
      IF nRealPosition > 0
         ::oContainerBase:Picture( nRealPosition, oPage:nImage )
      ENDIF
   ENDIF

   RETURN oPage:Picture

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndTab() CLASS TMultiPage

   IF _OOHG_LastFrame() == ::oPageClass:Type
      // ERROR: Last page not finished
      ::EndPage()
   ENDIF
   _OOHG_DeleteFrame( ::Type )
   IF HB_ISNUMERIC( ::nFirstValue ) .AND. ! ::Value == ::nFirstValue
      ::Value := ::nFirstValue
   ELSEIF ::Value == 0
      ::Value := 1
   ENDIF
   ::SizePos()

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ContainerValue( nValue ) CLASS TMultiPage

   IF HB_ISNUMERIC( nValue )
      ::oContainerBase:Value := nValue
   ENDIF

   RETURN iif( ::oContainerBase == NIL, 0, ::oContainerBase:Value )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DeleteItem( nItem ) CLASS TMultiPage

   LOCAL nValue

   nValue := ::ContainerValue
   ::oContainerBase:DeleteItem( nItem )
   IF ::ContainerValue == 0
      ::ContainerValue := Min( nValue, ::ContainerItemCount )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD bBeforeChange( bCode ) CLASS TMultiPage

   IF PCount() > 0
      ::oContainerBase:bBeforeChange := bCode
   ENDIF

   RETURN ::oContainerBase:bBeforeChange

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD OnClick( bCode ) CLASS TMultiPage

   IF PCount() > 0
      ::oContainerBase:OnClick := bCode
   ENDIF

   RETURN ::oContainerBase:OnClick

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD OnRClick( bCode ) CLASS TMultiPage

   IF PCount() > 0
      ::oContainerBase:OnRClick := bCode
   ENDIF

   RETURN ::oContainerBase:OnRClick

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SaveData() CLASS TMultiPage

   _OOHG_EVAL( ::Block, ::Value )
   AEval( ::aPages, { |o| o:SaveData() } )

   RETURN NIL


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TTabRaw FROM TControl

   DATA aToolTips                 INIT {}
   DATA bBeforeChange             INIT NIL
   DATA DefaultToolTip            INIT ""
   DATA ImageListColor            INIT CLR_DEFAULT
   DATA ImageListFlags            INIT LR_LOADTRANSPARENT + LR_DEFAULTCOLOR + LR_LOADMAP3DCOLORS
   DATA SetImageListCommand       INIT TCM_SETIMAGELIST
   DATA Type                      INIT "TAB" READONLY

   METHOD Caption
   METHOD Define
   METHOD DeleteItem
   METHOD Events
   METHOD Events_Notify
   METHOD InsertItem
   METHOD ItemAtPos( y, x )       BLOCK { |Self, y, x| TabCtrl_HitTest( ::hWnd, y, x ) }
   METHOD ItemCount               BLOCK { |Self| TabCtrl_GetItemCount( ::hWnd ) }
   METHOD ItemSize                SETGET
   METHOD MinTabWidth             SETGET
   METHOD Picture
   METHOD SetPadding( w, h )      BLOCK { |Self, w, h| TabCtrl_SetPadding( ::hWnd, w, h ) }    // defaults is {6,3}
   METHOD TabsAreaHeight
   METHOD TabToolTip
   METHOD Value                   SETGET

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( cControlName, uParentForm, nCol, nRow, nWidht, nHeight, aCaptions, nValue, ;
               cFontName, nFontSize, cToolTip, bChange, lButtons, lFlatBut, lHotTrack, ;
               lVertical, lNoTabStop, lBold, lItalic, lUnderline, lStrikeout, aImages, lRtl, ;
               lInvisible, lDisabled, lMultiLin, lRight, lBottom, bRClick, lRagged, lFixWidth, ;
               aToolTips, nItemW, nItemH, nMinW, nHPad, nVPad, uBackColor, lIcoLeft, lLblLeft, ;
               lRightJus, lScrollOp, bClick ) CLASS TTabRaw

   LOCAL cCaption, cImage, i, nStyle, cControlHandle, bToolTip, uToolTip

   ::SetForm( cControlName, uParentForm, cFontName, nFontSize, NIL, NIL, NIL, lRtl )

   IF ! HB_ISARRAY( aCaptions )
      aCaptions := {}
   ENDIF
   IF ! HB_ISARRAY( aImages )
      aImages := {}
   ENDIF
   IF ! HB_ISARRAY( aToolTips )
      aToolTips := {}
   ENDIF
   ASize( aToolTips, Max( Max( Len( aCaptions ), Len( aImages ) ), Len( aToolTips ) ) )

   ASSIGN ::nWidth  VALUE nWidht    TYPE "N"
   ASSIGN ::nHeight VALUE nHeight   TYPE "N"
   ASSIGN ::nRow    VALUE nRow      TYPE "N"
   ASSIGN ::nCol    VALUE nCol      TYPE "N"

   ASSIGN nItemW    VALUE nItemW    TYPE "N" DEFAULT -1
   ASSIGN nItemH    VALUE nItemH    TYPE "N" DEFAULT -1
   ASSIGN nMinW     VALUE nMinW     TYPE "N" DEFAULT -1
   ASSIGN nHPad     VALUE nHPad     TYPE "N" DEFAULT -1
   ASSIGN nVPad     VALUE nVPad     TYPE "N" DEFAULT -1

   ASSIGN lButtons  VALUE lButtons  TYPE "L" DEFAULT .F.
   ASSIGN lHotTrack VALUE lHotTrack TYPE "L" DEFAULT .F.
   ASSIGN lFlatBut  VALUE lFlatBut  TYPE "L" DEFAULT .F.
   ASSIGN lRagged   VALUE lRagged   TYPE "L" DEFAULT .F.
   ASSIGN lFixWidth VALUE lFixWidth TYPE "L" DEFAULT .F.
   ASSIGN lMultiLin VALUE lMultiLin TYPE "L" DEFAULT .F.
   ASSIGN lIcoLeft  VALUE lIcoLeft  TYPE "L" DEFAULT .F.
   ASSIGN lLblLeft  VALUE lLblLeft  TYPE "L" DEFAULT .F.
   ASSIGN lRightJus VALUE lRightJus TYPE "L" DEFAULT .F.
   ASSIGN lScrollOp VALUE lScrollOp TYPE "L" DEFAULT .F.

   ASSIGN lVertical VALUE lVertical TYPE "L" DEFAULT .F.
   ASSIGN lRight    VALUE lRight    TYPE "L" DEFAULT .F.
   ASSIGN lBottom   VALUE lBottom   TYPE "L" DEFAULT .F.
   /*
   lVertical +    lBottom +    lRight    -> Intended result:
   .T.            .F.          .F.          Tabs at LEFT
   .T.            .F.          .T.          Tabs at RIGHT
   .T.            .T.          .F.          Tabs at LEFT
   .T.            .T.          .T.          Tabs at RIGHT
   .F.            .F.          .F.          Tabs at TOP
   .F.            .T.          .F.          Tabs at BOTTOM
   .F.            .F.          .T.          Tabs at RIGHT
   .F.            .T.          .T.          Tabs at TOP

   TCS_VERTICAL + TCS_BOTTOM + TCS_RIGHT -> What Windows does
   .T.            .F.          .F.          Tabs at LEFT
   .T.            .F.          .T.          Tabs at RIGHT
   .T.            .T.          .F.          Tabs at LEFT
   .T.            .T.          .T.          Tabs at RIGHT
   .F.            .F.          .F.          Tabs at TOP
   .F.            .T.          .F.          Tabs at BOTTOM
   .F.            .F.          .T.          Tabs at BOTTOM because for Windows TCS_RIGHT is equivalent to TCS_BOTTOM
   .F.            .T.          .T.          Tabs at TOP
   */
   IF ! lVertical .AND. ! lBottom .AND. lRight
      // To place Tabs at RIGHT we need this
      lVertical := .T.
   ENDIF

   nStyle := ::InitStyle( NIL, NIL, lInvisible, lNoTabStop, lDisabled ) + ;
             iif( lBottom,   TCS_BOTTOM,         0 ) + ;
             iif( lButtons,  TCS_BUTTONS,        0 ) + ;
             iif( lFixWidth, TCS_FIXEDWIDTH,     0 ) + ;
             iif( lFlatBut,  TCS_FLATBUTTONS,    0 ) + ;
             iif( lIcoLeft,  TCS_FORCEICONLEFT,  0 ) + ;
             iif( lLblLeft,  TCS_FORCELABELLEFT, 0 ) + ;
             iif( lHotTrack, TCS_HOTTRACK,       0 ) + ;
             iif( lMultiLin, TCS_MULTILINE,      0 ) + ;
             iif( lRagged,   TCS_RAGGEDRIGHT,    0 ) + ;
             iif( lRight,    TCS_RIGHT,          0 ) + ;
             iif( lRightJus, TCS_RIGHTJUSTIFY,   0 ) + ;
             iif( lScrollOp, TCS_SCROLLOPPOSITE, 0 ) + ;
             iif( lVertical, TCS_VERTICAL,       0 )
/*
TODO: Use TCS_OWNERDRAWFIXED style to enable real backcolor and paint the upper right unused rectangle.
*/

   cControlHandle = InitTabControl( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, {}, nValue, nStyle, ::lRtl )

   IF ValType( cToolTip ) $ "CM" .OR. HB_ISBLOCK( cToolTip )
      ::DefaultToolTip := cToolTip
   ENDIF
   bToolTip := { |oCtrl| oCtrl:TabToolTip( TabCtrl_HitTest( oCtrl:hWnd, GetCursorRow() - GetWindowRow( oCtrl:hWnd ), GetCursorCol() - GetWindowCol( oCtrl:hWnd ) ) ) }

   ::Register( cControlHandle, cControlName, NIL, NIL, bToolTip )
   ::SetFont( NIL, NIL, lBold, lItalic, lUnderline, lStrikeout )

   // Since we still can't set the TabPage's backcolor lets assume it's the system's default
   IF ( ! ::IsVisualStyled .OR. lButtons .OR. lVertical )
      ASSIGN uBackColor VALUE uBackColor TYPE "ANCM" DEFAULT GetSysColor( COLOR_BTNFACE )
   ELSE
      ASSIGN uBackColor VALUE uBackColor TYPE "ANCM" DEFAULT GetSysColor( COLOR_WINDOW )
   ENDIF
   ::BackColor := uBackColor

   ::MinTabWidth( nMinW )       // win10 returns 42
   IF nHPad >= 0 .AND. nVPad >= 0
      ::SetPadding( nHPad, nVPad )
   ENDIF
   IF lFixWidth .AND. nItemW > 0 .AND. nItemH > 0
      ::ItemSize( nItemW, nItemH )      // win10 returns {96,0} when no tabs are defined and {96,20} after a tab is defined
   ENDIF

   // Add page by page
   i := 1
   DO WHILE i <= Len( aCaptions ) .AND. i <= Len( aImages )
      IF i <= Len( aImages ) .AND. ValType( aImages[ i ] ) $ "CM"
         cImage := aImages[ i ]
      ELSE
         cImage := ""
      ENDIF
      IF i <= Len( aCaptions ) .AND. ValType( aCaptions[ i ] ) $ "CM"
         cCaption := aCaptions[ i ]
      ELSE
         cCaption := ""
      ENDIF
      IF i <= Len( aToolTips ) .AND. ( ValType( aToolTips[ i ] ) $ "CM" .OR. HB_ISBLOCK( aToolTips[ i ] ) )
         uToolTip := aToolTips[ i ]
      ELSE
         uToolTip := ""
      ENDIF
      ::InsertItem( ::ItemCount + 1, cCaption, cImage, uToolTip )
      i ++
   ENDDO

   IF HB_ISNUMERIC( nValue )
      ::Value := nValue
   ELSE
      ::Value := 1
   ENDIF

   ASSIGN ::OnChange VALUE bChange TYPE "B"
   ASSIGN ::OnClick  VALUE bClick  TYPE "B"
   ASSIGN ::OnRClick VALUE bRClick TYPE "B"

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ItemSize( nWidht, nHeight ) CLASS TTabRaw

   LOCAL aRect

   IF HB_ISNUMERIC( nWidht ) .AND. nWidht >= 0 .AND. HB_ISNUMERIC( nHeight ) .AND. nHeight >= 0
      TabCtrl_SetItemSize( ::hWnd, nWidht, nHeight )
   ELSE
      IF ::ItemCount > 0
         aRect := TabCtrl_GetItemRect( ::hWnd, 0 )

         nWidht := aRect[3] - aRect[1]
         nHeight := aRect[4] - aRect[2]
      ELSE
         // default is {96,20} under win10
         nWidht := -1
         nHeight := -1
      ENDIF
   ENDIF

   RETURN { nWidht, nHeight }

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD MinTabWidth( nWidht ) CLASS TTabRaw

   IF HB_ISNUMERIC( nWidht ) .AND. ( nWidht := Int( nWidht ) ) >= -1
      TabCtrl_SetMinTabWidth( ::hWnd, nWidht )
      IF nWidht == -1
         nWidht := TabCtrl_SetMinTabWidth( ::hWnd, -1 )   // -1 means default width
      ENDIF
   ELSE
      nWidht := TabCtrl_SetMinTabWidth( ::hWnd, -1 )
      TabCtrl_SetMinTabWidth( ::hWnd, nWidht )
   ENDIF

   RETURN nWidht

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value( nValue ) CLASS TTabRaw

   IF HB_ISNUMERIC( nValue )
      TabCtrl_SetCurSel( ::hWnd, nValue )
      ::DoChange()
   ENDIF

   RETURN TabCtrl_GetCurSel( ::hWnd )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InsertItem( nPosition, cCaption, uImage, uToolTip ) CLASS TTabRaw

   TABCTRL_INSERTITEM( ::hWnd, nPosition - 1, cCaption )

   IF ValType( uImage ) $ "CM"
      uImage := ::AddBitMap( uImage ) - 1
   ENDIF
   IF HB_ISNUMERIC( uImage ) .AND. uImage >= 0
      SetTabPageImage( ::hWnd, nPosition, uImage )
   ENDIF

   AAdd( ::aToolTips, NIL )
   AIns( ::aToolTips, nPosition )

   IF ( ValType( uToolTip ) $ "CM" .AND. ! Empty( uToolTip ) ) .OR. HB_ISBLOCK( uToolTip )
      ::aToolTips[ nPosition ] := uToolTip
   ELSEIF ValType( ::DefaultToolTip ) $ "CM" .OR. HB_ISBLOCK( ::DefaultToolTip )
      ::aToolTips[ nPosition ] := ::DefaultToolTip
   ELSE
      ::aToolTips[ nPosition ] := ""
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DeleteItem( nPosition ) CLASS TTabRaw

   TabCtrl_DeleteItem( ::hWnd, nPosition - 1 )
   _OOHG_DeleteArrayItem( ::aToolTips, nPosition )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Caption( nColumn, uValue ) CLASS TTabRaw

   IF ValType( uValue ) $ "CM"
      SetTabCaption( ::hWnd, nColumn, uValue )
      ::Refresh()
   ENDIF

   RETURN GetTabCaption( ::hWnd, nColumn )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Picture( nColumn, uValue ) CLASS TTabRaw

   IF ValType( uValue ) $ "CM"
      // ::Picture( nColumn ) := uValue
      uValue := ::AddBitMap( uValue ) - 1
   ENDIF
   IF HB_ISNUMERIC( uValue )
      SetTabPageImage( ::hWnd, nColumn, uValue )
      ::Refresh()
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD TabToolTip( nColumn, uToolTip ) CLASS TTabRaw

   LOCAL cRet

   IF HB_ISNUMERIC( nColumn ) .AND. nColumn >= 1 .AND. nColumn <= Len( ::aToolTips )
      IF ValType( uToolTip ) $ "CM" .OR. HB_ISBLOCK( uToolTip )
         ::aToolTips[ nColumn ] := uToolTip
      ENDIF
      cRet := ::aToolTips[ nColumn ]
   ELSE
      cRet := ""
   ENDIF

   RETURN cRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TTabRaw

   IF nMsg == WM_LBUTTONDOWN
      IF ! ::NestedClick
         ::NestedClick := ! _OOHG_NestedSameEvent()
         ::DoEventMouseCoords( ::OnClick, "CLICK" )
         ::NestedClick := .F.
      ENDIF
   ENDIF

   RETURN ::Super:Events( hWnd, nMsg, wParam, lParam )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Events_Notify( wParam, lParam ) CLASS TTabRaw

   LOCAL lGo, nNotify := GetNotifyCode( lParam )

   IF nNotify == TCN_SELCHANGE
      ::Refresh()
      ::DoChange()
      RETURN NIL

   ELSEIF nNotify == TCN_SELCHANGING
      IF HB_ISBLOCK( ::bBeforeChange )
         lGo := Eval( ::bBeforeChange, ::Value )
         If HB_ISLOGICAL( lGo ) .and. ! lGo
            // Prevent the action
            RETURN 1
         ENDIF
      ENDIF

   ENDIF

   RETURN ::Super:Events_Notify( wParam, lParam )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD TabsAreaHeight() CLASS TTabRaw

   LOCAL  aRect := TabCtrl_GetItemRect( ::hWnd, 0 )

   RETURN ( aRect[ 4 ] - aRect[ 2 ] ) * TabCtrl_GetRowCount( ::hWnd )


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TTabPage FROM TControlGroup

   DATA Caption                   INIT ""
   DATA nImage                    INIT -1
   DATA Picture                   INIT ""
   DATA Position                  INIT 0
   DATA Type                      INIT "TABPAGE" READONLY

   METHOD AdjustResize
   METHOD ContainerVisible
   METHOD EndPage                 BLOCK { |Self| _OOHG_DeleteFrame( ::Type ) }
   METHOD Events_Size
   METHOD SaveData
   METHOD SetFocus                BLOCK { |Self| ::Container:SetFocus(), ::Container:Value := ::Position, Self }

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ContainerVisible() CLASS TTabPage

   LOCAL lRet := .F.

   IF ::Super:ContainerVisible
      lRet := ( ::Container:Value == ::Position )
   ENDIF

   RETURN lRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Events_Size() CLASS TTabPage

   LOCAL oTab

   oTab := ::Container
   ::SizePos(,, oTab:Width, oTab:Height )
   ::Parent:Redraw()

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD AdjustResize( nDivh, nDivw, lSelfOnly ) CLASS TTabPage

   IF ::lAdjust
      // Do not adjust row, col, width and height of the page because they
      // are set by the container. See ::Events_Size() and ::Container:SizePos()
      ::Sizepos()

      IF _OOHG_AdjustWidth
         IF ! ::lFixWidth
            IF _OOHG_AdjustFont
               IF ! ::lFixFont
                  ::FontSize := ::FontSize * nDivw
               ENDIF
            ENDIF
         ENDIF
      ENDIF

      IF ! HB_ISLOGICAL( lSelfOnly ) .OR. ! lSelfOnly
         AEval( ::aControls, { |o| o:AdjustResize( ( ::Height - ::nFixedHeightUsed ) / ( ::Height / nDivh - ::nFixedHeightUsed ), nDivw ) } )
      ENDIF
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SaveData() CLASS TTabPage

   _OOHG_EVAL( ::Block, ::Value )
   AEval( ::aControls, { |o| o:SaveData() } )

   RETURN NIL


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TTabPageInternal FROM TFormInternal

   DATA Caption                   INIT ""
   DATA cToolTip                  INIT ""
   DATA lHidden                   INIT .F.
   DATA nImage                    INIT -1
   DATA Picture                   INIT ""
   DATA Position                  INIT 0
   DATA Type                      INIT "TABPAGE" READONLY

   METHOD AdjustResize
   METHOD Define
   METHOD EndPage                 BLOCK { |Self| _OOHG_DeleteFrame( ::Type ) }
   METHOD Events_Size
   METHOD SetFocus                BLOCK { |Self| ::Container:SetFocus(), ::Container:Value := ::Position, ::Super:SetFocus(), Self }
   METHOD ToolTip                 SETGET

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( cControlName, uParentForm ) CLASS TTabPageInternal

   LOCAL aArea

   ::SearchParent( uParentForm )
   aArea := _OOHG_TabPage_GetArea( ::Container )
   ::Super:Define( cControlName,, aArea[ 1 ], aArea[ 2 ], aArea[ 3 ], aArea[ 4 ], uParentForm )
   END WINDOW
   ::ContainerhWndValue := ::hWnd

   ::RowMargin := - aArea[ 2 ]
   ::ColMargin := - aArea[ 1 ]

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Events_Size() CLASS TTabPageInternal

   LOCAL aArea

   aArea := _OOHG_TabPage_GetArea( ::Container )
   ::RowMargin := - aArea[ 2 ]
   ::ColMargin := - aArea[ 1 ]
   ::SizePos( aArea[ 2 ], aArea[ 1 ], aArea[ 3 ], aArea[ 4 ] )
   ::ScrollControls()

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD AdjustResize( nDivh, nDivw, lSelfOnly ) CLASS TTabPageInternal

   IF ::lAdjust
      // Do not adjust row, col, width and height of the page because they
      // are set by the container. See ::Events_Size() and ::Container:SizePos()
      ::Sizepos()

      IF _OOHG_AdjustWidth
         IF ! ::lFixWidth
            IF _OOHG_AdjustFont
               IF ! ::lFixFont
                  ::FontSize := ::FontSize * nDivw
               ENDIF
            ENDIF
         ENDIF
      ENDIF

      IF ! HB_ISLOGICAL( lSelfOnly ) .OR. ! lSelfOnly
         AEval( ::aControls, { |o| o:AdjustResize( ( ::Height - ::nFixedHeightUsed ) / ( ::Height / nDivh - ::nFixedHeightUsed ), nDivw ) } )
      ENDIF
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ToolTip( cToolTip ) CLASS TTabPageInternal

   IF PCount() > 0
      IF ValType( cToolTip ) $ "CM" .OR. HB_ISBLOCK( cToolTip )
         ::cToolTip := cToolTip
      ELSE
         ::cToolTip := ""
      ENDIF
      IF HB_ISOBJECT( ::Parent:oToolTip )
         ::Parent:oToolTip:Item( ::hWnd, cToolTip )
      ENDIF
   ENDIF

   RETURN ::cToolTip

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION _OOHG_TabPage_GetArea( oTab )

   LOCAL aRect

   aRect := TabCtrl_GetItemRect( oTab:hWnd, 0 )
   aRect := { 2, aRect[ 4 ] + 2, oTab:Width - 2, oTab:Height - 2 }

   RETURN { aRect[ 1 ], aRect[ 2 ], aRect[ 3 ] - aRect[ 1 ], aRect[ 4 ] - aRect[ 2 ] } // { Col, Row, Width, Height }


/*--------------------------------------------------------------------------------------------------------------------------------*/
#pragma BEGINDUMP

#ifndef HB_OS_WIN_USED
   #define HB_OS_WIN_USED
#endif

#ifndef _WIN32_IE
   #define _WIN32_IE 0x0400
#endif
#if ( _WIN32_IE < 0x0400 )
   #undef _WIN32_IE
   #define _WIN32_IE 0x0400
#endif

#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"
#include "oohg.h"

static WNDPROC lpfnOldWndProc = 0;

/*--------------------------------------------------------------------------------------------------------------------------------*/
static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( INITTABCONTROL )
{
   PHB_ITEM hArray;
   HWND hbutton;
   TC_ITEM tie;
   int i;

   int Style = WS_CHILD | hb_parni( 9 );
   int iStyleEx = _OOHG_RTL_Status( hb_parl( 10 ) );

   hArray = hb_param( 7, HB_IT_ARRAY );
   Style |= WS_GROUP;

   hbutton = CreateWindowEx( iStyleEx, WC_TABCONTROL, NULL, Style,
                             hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ),
                             HWNDparam( 1 ), HMENUparam( 2 ), GetModuleHandle( NULL ), NULL );

   tie.mask = TCIF_TEXT ;
   tie.iImage = -1;

   for( i = hb_parinfa( 7, 0 ); i > 0; i-- )
   {
      tie.pszText = (LPTSTR) hb_arrayGetCPtr( hArray, i );
      TabCtrl_InsertItem( hbutton, 0, &tie );
   }

   TabCtrl_SetCurSel( hbutton, hb_parni( 8 ) - 1 );

   lpfnOldWndProc = (WNDPROC) SetWindowLongPtr( hbutton, GWL_WNDPROC, (LONG_PTR) SubClassFunc );

   HWNDret( hbutton );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC (TABCTRL_SETCURSEL)
{
   TabCtrl_SetCurSel( HWNDparam( 1 ),  hb_parni( 2 ) - 1 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TABCTRL_GETCURSEL )
{
   hb_retni( TabCtrl_GetCurSel( HWNDparam( 1 ) ) + 1 ) ;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TABCTRL_GETITEMCOUNT )
{
   hb_retni( TabCtrl_GetItemCount( HWNDparam( 1 ) ) ) ;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TABCTRL_INSERTITEM )
{
   TC_ITEM tie;
   int i;

   i = hb_parni( 2 );

   tie.mask = TCIF_TEXT;
   tie.iImage = -1;
   tie.pszText = ( char * ) hb_parc( 3 );

   TabCtrl_InsertItem( HWNDparam( 1 ), i, &tie );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TABCTRL_DELETEITEM )
{
   TabCtrl_DeleteItem( HWNDparam( 1 ), hb_parni( 2 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( SETTABCAPTION )
{
   TC_ITEM tie;

   tie.mask = TCIF_TEXT ;
   tie.pszText = ( char * ) hb_parc(3) ;

   TabCtrl_SetItem( HWNDparam( 1 ), hb_parni( 2 ) - 1, &tie );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GETTABCAPTION )
{
   TC_ITEM tie;
   char cBuffer[ 1025 ];

   tie.mask = TCIF_TEXT ;
   tie.pszText = ( char * ) cBuffer;
   tie.cchTextMax = 1024;

   cBuffer[ 0 ] = 0;
   TabCtrl_GetItem( HWNDparam( 1 ), hb_parni( 2 ) - 1, &tie );
   cBuffer[ 1024 ] = 0;

   hb_retc( cBuffer );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( SETTABPAGEIMAGE )
{
   TC_ITEM tie;

   tie.mask = TCIF_IMAGE ;
   tie.iImage = hb_parni( 3 );
   TabCtrl_SetItem( HWNDparam( 1 ), hb_parni( 2 ) - 1, &tie );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TABCTRL_GETITEMRECT )
{
   RECT rect;

   TabCtrl_GetItemRect( HWNDparam( 1 ), hb_parni( 2 ), &rect );
   hb_reta( 4 );
   HB_STORNI( rect.left,   -1, 1 );
   HB_STORNI( rect.top,    -1, 2 );
   HB_STORNI( rect.right,  -1, 3 );
   HB_STORNI( rect.bottom, -1, 4 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TABCTRL_GETROWCOUNT )
{
   hb_retni( TabCtrl_GetRowCount( HWNDparam( 1 ) ) ) ;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TABCTRL_HITTEST )
{
   POINT point ;
   TC_HITTESTINFO hti;

   point.y = hb_parni( 2 );
   point.x = hb_parni( 3 );

   hti.pt = point;

   hb_retni( TabCtrl_HitTest( HWNDparam( 1 ), &hti ) + 1 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TABCTRL_SETITEMSIZE )
{
   DWORD oldvals = TabCtrl_SetItemSize( HWNDparam( 1 ), hb_parni( 2 ), hb_parni( 3 ) );

   hb_reta( 2 );
   HB_STORNI( (int) LOWORD( oldvals ), -1, 1 );
   HB_STORNI( (int) HIWORD( oldvals ), -1, 2 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TABCTRL_SETMINTABWIDTH )
{
   hb_retni( TabCtrl_SetMinTabWidth( HWNDparam( 1 ), hb_parni( 2 ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TABCTRL_SETPADDING )
{
   TabCtrl_SetPadding( HWNDparam( 1 ), hb_parni( 2 ), hb_parni( 3 ) );
}

#pragma ENDDUMP
