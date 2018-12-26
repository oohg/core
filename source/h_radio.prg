/*
 * $Id: h_radio.prg $
 */
/*
 * ooHG source code:
 * RadioGroup control
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
#include "common.ch"
#include "hbclass.ch"
#include "i_windefs.ch"

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TRadioGroup FROM TLabel

   DATA aOptions                   INIT {}
   DATA IconWidth                  INIT 19
   DATA LeftAlign                  INIT .F.
   DATA lHorizontal                INIT .F.
   DATA lLibDraw                   INIT .F.
   DATA lNoFocusRect               INIT .F.
   DATA lTabStop                   INIT .T.
   DATA nHeight                    INIT 25
   DATA nSpacing                   INIT 25
   DATA nWidth                     INIT 120
   DATA Type                       INIT "RADIOGROUP" READONLY

   METHOD AddItem
   METHOD AdjustResize
   METHOD Background               SETGET
   METHOD Caption
   METHOD ColMargin                BLOCK { |Self| - ::Col }
   METHOD Define
   METHOD DeleteItem
   METHOD DoChange
   METHOD Enabled                  SETGET
   METHOD GroupHeight
   METHOD GroupWidth
   METHOD InsertItem
   METHOD ItemCount                BLOCK { |Self| Len( ::aOptions ) }
   METHOD ItemEnabled
   METHOD ItemReadOnly
   METHOD ItemToolTip
   METHOD ReadOnly                 SETGET
   METHOD RowMargin                BLOCK { |Self| - ::Row }
   METHOD SetFocus
   METHOD SetFont
   METHOD SizePos
   METHOD Spacing                  SETGET
   METHOD TabStop                  SETGET
   METHOD ToolTip                  SETGET
   METHOD Value                    SETGET
   METHOD Visible                  SETGET

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( cControlName, uParentForm, nCol, nRow, aOptions, uValue, cFontName, nFontSize, uToolTip, bChange, ;
               nWidth, nSpacing, nHelpId, lInvisible, lNoTabStop, lBold, lItalic, lUnderline, lStrikeout, uBackColor, ;
               uFontColor, lTransparent, lAutoSize, lHorizontal, lDisabled, lRtl, nHeight, lDrawBy, oBkGrnd, lLeft, ;
               uReadonly, lNoFocusRect ) CLASS TRadioGroup

   LOCAL oTabPage, i, oItem

   ASSIGN ::nCol         VALUE nCol             TYPE "N"
   ASSIGN ::nRow         VALUE nRow             TYPE "N"
   ASSIGN ::nWidth       VALUE nWidth           TYPE "N"
   ASSIGN ::nHeight      VALUE nHeight          TYPE "N"
   ASSIGN ::lAutoSize    VALUE lAutoSize        TYPE "L"
   ASSIGN ::lHorizontal  VALUE lHorizontal      TYPE "L"
   ASSIGN ::Transparent  VALUE lTransparent     TYPE "L"
   ASSIGN ::LeftAlign    VALUE lLeft            TYPE "L"
   ASSIGN ::lNoFocusRect VALUE lNoFocusRect     TYPE "L"
   ASSIGN ::oBkGrnd      VALUE oBkGrnd          TYPE "O"
   ASSIGN aOptions       VALUE aOptions         TYPE "A" DEFAULT {}
   ASSIGN lDisabled      VALUE lDisabled        TYPE "L" DEFAULT .F.

   IF HB_ISLOGICAL( lDrawBy )
      ::lLibDraw := lDrawBy
   ELSEIF ::lNoFocusRect
      ::lLibDraw := .T.
   ENDIF

   IF HB_ISNUMERIC( nSpacing )
      ::nSpacing := nSpacing
   ELSEIF ::lHorizontal
      ::nSpacing := ::nWidth
   ELSE
     ::nSpacing := ::nHeight
   ENDIF

   IF HB_ISLOGICAL( lNoTabStop )
      ::lTabStop := ! lNoTabStop
   ENDIF

   ::SetForm( cControlName, uParentForm, cFontName, nFontSize, uFontColor, uBackColor, NIL, lRtl )
   ::InitStyle( NIL, NIL, lInvisible, NIL, lDisabled )
   ::Register( 0, NIL, nHelpId )

   IF _OOHG_LastFrame() == "TABPAGE"
      oTabPage := _OOHG_ActiveFrame
      IF oTabPage:Parent:hWnd == ::Parent:hWnd
         ::TabHandle := ::Container:Container:hWnd
      ENDIF
   ENDIF

   /* When the radio items are created, Windows sends a BN_CLICKED event, thus firing OnChange */
   IF HB_ISNUMERIC( uValue ) .AND. uValue > 0 .AND. uValue <= Len( aOptions )
      ::xOldValue := uValue
   ELSE
      ::xOldValue := 0
   ENDIF

   nCol := ::Col
   nRow := ::Row

   ::aOptions := {}
   FOR i := 1 TO Len( aOptions )
      oItem := TRadioItem():Define( NIL, Self, nCol, nRow, NIL, NIL, aOptions[ i ], .F., ( i == 1 ), NIL, ;
                  NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, ;
                  NIL, NIL, NIL, .T., NIL, NIL, NIL, NIL, NIL, NIL )
      AAdd( ::aOptions, oItem )
      IF ::lHorizontal
         nCol += ::nSpacing
      ELSE
         nRow += ::nSpacing
      ENDIF
   NEXT

   ::ReadOnly := uReadonly
   ::ToolTip  := uToolTip
   ::Value    := uValue

   IF ::Value == 0
      ::aOptions[ 1 ]:TabStop := ::lTabStop
   ENDIF

   ::Enabled := ! lDisabled

   ::SetFont( NIL, NIL, lBold, lItalic, lUnderline, lStrikeout )

   ASSIGN ::OnChange VALUE bChange TYPE "B"

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Background( oBkGrnd ) CLASS TRadioGroup

   LOCAL i

   IF HB_ISOBJECT( oBkGrnd )
      ::oBkGrnd := oBkGrnd
      FOR i := 1 TO Len( ::aOptions )
         ::aOptions[ i ]:Background := oBkGrnd
      NEXT
   ENDIF

   RETURN ::oBkGrnd

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GroupHeight() CLASS TRadioGroup

   LOCAL nRet, oFirst, oLast

   IF ::lHorizontal
      nRet := ::Height
   ELSE
      IF Len( ::aOptions ) > 0
         oFirst := ::aOptions[ 1 ]
         oLast  := ATail( ::aOptions )
         nRet   := oLast:Row + oLast:Height - oFirst:Row
      ELSE
         nRet := 0
      ENDIF
   ENDIF

   RETURN nRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GroupWidth() CLASS TRadioGroup

   LOCAL nRet, oFirst, oLast

   IF ::lHorizontal
      IF Len( ::aOptions ) > 0
         oFirst := ::aOptions[ 1 ]
         oLast  := ATail( ::aOptions )
         nRet   := oLast:Col + oLast:Width - oFirst:Col
      ELSE
         nRet := 0
      ENDIF
   ELSE
      nRet := ::Width
   ENDIF

   RETURN nRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetFont( cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout, nAngle, nCharset, nWidth, nOrientation, lAdvanced ) CLASS TRadioGroup

   IF ! Empty( cFontName ) .AND. ValType( cFontName ) $ "CM"
      ::cFontName := cFontName
   ENDIF
   IF ! Empty( nFontSize ) .AND. HB_ISNUMERIC( nFontSize )
      ::nFontSize := nFontSize
   ENDIF
   IF HB_ISLOGICAL( lBold )
      ::Bold := lBold
   ENDIF
   IF HB_ISLOGICAL( lItalic )
      ::Italic := lItalic
   ENDIF
   IF HB_ISLOGICAL( lUnderline )
      ::Underline := lUnderline
   ENDIF
   IF HB_ISLOGICAL( lStrikeout )
      ::Strikeout := lStrikeout
   ENDIF
   IF ! Empty( nAngle ) .AND. HB_ISNUMERIC( nAngle )
      ::FntAngle := nAngle
   ENDIF
   IF ! Empty( nCharset ) .AND. HB_ISNUMERIC( nCharset )
      ::FntCharset := nCharset
   ENDIF
   IF ! Empty( nWidth ) .AND. HB_ISNUMERIC( nWidth )
      ::FntWidth := nWidth
   ENDIF
   IF HB_ISLOGICAL( lAdvanced )
      ::FntAdvancedGM := lAdvanced
   ENDIF
   IF ::FntAdvancedGM
      IF ! Empty( nOrientation ) .AND. HB_ISNUMERIC( nOrientation )
         ::FntOrientation := nOrientation
      ENDIF
   ELSE
      ::FntOrientation := ::FntAngle
   ENDIF

   AEval( ::aOptions, { |o| o:SetFont( cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout ) } )

   RETURN ::aOptions[ 1 ]:FontHandle

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SizePos( nRow, nCol, nWidth, nHeight ) CLASS TRadioGroup

   LOCAL nDeltaRow, nDeltaCol, uRet

   nDeltaRow := ::Row
   nDeltaCol := ::Col
   uRet := ::Super:SizePos( nRow, nCol, nWidth, nHeight )
   nDeltaRow := ::Row - nDeltaRow
   nDeltaCol := ::Col - nDeltaCol
   AEval( ::aControls, { |o| o:Visible := .F., o:SizePos( o:Row + nDeltaRow, o:Col + nDeltaCol, nWidth, nHeight ), o:Visible := .T. } )

   RETURN uRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value( nValue ) CLASS TRadioGroup

   LOCAL i, lSetFocus

   IF HB_ISNUMERIC( nValue )
      nValue := Int( nValue )
      lSetFocus := ( AScan( ::aOptions, { |o| o:hWnd == GetFocus() } ) > 0 )
      FOR i := 1 TO Len( ::aOptions )
         ::aOptions[ i ]:Value := ( i == nValue )
      NEXT
      nValue := ::Value
      FOR i := 1 TO Len( ::aOptions )
         ::aOptions[ i ]:TabStop := ( ::lTabStop .AND. i == Max( nValue, 1 ) )
      NEXT
      IF lSetFocus
         IF nValue > 0
            ::aOptions[ nValue ]:SetFocus()
         ENDIF
      ENDIF
      ::DoChange()
   ENDIF

   RETURN AScan( ::aOptions, { |o| o:Value } )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DoChange() CLASS TRadioGroup

   LOCAL i, nValue

   nValue := ::Value
   FOR i := 1 TO Len( ::aOptions )
      ::aOptions[ i ]:TabStop := ( ::lTabStop .AND. i == Max( nValue, 1 ) )
   NEXT

   RETURN ::Super:DoChange()

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD TabStop( lTabStop ) CLASS TRadioGroup

   LOCAL nValue, i

   IF HB_ISLOGICAL( lTabStop )
      ::lTabStop := lTabStop
      nValue := ::Value
      FOR i := 1 TO Len( ::aOptions )
         ::aOptions[ i ]:TabStop := ( lTabStop .AND. i == Max( nValue, 1 ) )
      NEXT
   ENDIF

   RETURN ::lTabStop

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Enabled( lEnabled ) CLASS TRadioGroup

   IF HB_ISLOGICAL( lEnabled )
      ::Super:Enabled := lEnabled
      AEval( ::aControls, { |o| o:Enabled := o:Enabled } )
   ENDIF

   RETURN ::Super:Enabled

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetFocus() CLASS TRadioGroup

   LOCAL nValue

   nValue := ::Value
   IF nValue >= 1 .AND. nValue <= Len( ::aOptions )
      ::aOptions[ nValue ]:SetFocus()
   ELSE
      ::aOptions[ 1 ]:SetFocus()
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Visible( lVisible ) CLASS TRadioGroup

   IF HB_ISLOGICAL( lVisible )
      ::Super:Visible := lVisible
      IF lVisible
         AEval( ::aControls, { |o| o:Visible := o:Visible } )
      ELSE
         AEval( ::aControls, { |o| o:ForceHide() } )
      ENDIF
   ENDIF

   RETURN ::lVisible

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD AddItem( cCaption, nImage, uToolTip ) CLASS TRadioGroup

   RETURN ::InsertItem( ::ItemCount + 1, cCaption, nImage, uToolTip )

   /*
   TODO:
   RadioItem with Image instead/and Text.

   Note that TMultiPage control expects an Image as third parameter.
   */

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InsertItem( nPosition, cCaption, nImage, uToolTip, oBkGrnd, lLeft, lDisabled ) CLASS TRadioGroup

   LOCAL i, oItem, nCol, nRow, nValue, hWnd

   HB_SYMBOL_UNUSED( nImage )

   nValue := ::Value

   nPosition := Int( nPosition )
   IF nPosition < 1 .OR. nPosition > Len( ::aOptions )
      nPosition := Len( ::aOptions ) + 1
   ENDIF

   AAdd( ::aOptions, NIL )
   AIns( ::aOptions, nPosition )
   i := Len( ::aOptions )
   DO WHILE i > nPosition
      IF ::lHorizontal
         ::aOptions[ i ]:Col += ::nSpacing
      ELSE
         ::aOptions[ i ]:Row += ::nSpacing
      ENDIF
      i --
   ENDDO

   IF nPosition == 1
      nCol := ::Col
      nRow := ::Row
      IF Len( ::aOptions ) > 1
         WindowStyleFlag( ::aOptions[ 2 ]:hWnd, WS_GROUP, 0 )
      ENDIF
   ELSE
      nCol := ::aOptions[ nPosition - 1 ]:Col
      nRow := ::aOptions[ nPosition - 1 ]:Row
      IF ::lHorizontal
         nCol += ::nSpacing
      ELSE
         nRow += ::nSpacing
      ENDIF
   ENDIF

   oItem := TRadioItem():Define( NIL, Self, nCol, nRow, NIL, NIL, cCaption, .F., ( nPosition == 1 ), NIL, ;
               NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, ;
               uToolTip, NIL, NIL, .T., lDisabled, NIL, oBkGrnd, lLeft, NIL, NIL )

   ::aOptions[ nPosition ] := oItem

   IF nPosition > 1
      SetWindowPos( oItem:hWnd, ::aOptions[ nPosition - 1 ]:hWnd, 0, 0, 0, 0, SWP_NOSIZE + SWP_NOMOVE )
   ELSEIF Len( ::aOptions ) >= 2
      hWnd := GetWindow( ::aOptions[ 2 ]:hWnd, GW_HWNDPREV )
      SetWindowPos( oItem:hWnd, hWnd, 0, 0, 0, 0, SWP_NOSIZE + SWP_NOMOVE )
   ENDIF

   IF nValue >= nPosition
      ::Value := ::Value
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DeleteItem( nItem ) CLASS TRadioGroup

   LOCAL nValue

   nItem := Int( nItem )
   IF nItem >= 1 .AND. nItem <= Len( ::aOptions )
      nValue := ::Value
      ::aOptions[ nItem ]:Release()
      _OOHG_DeleteArrayItem( ::aOptions, nItem )
      IF nItem == 1 .AND. Len( ::aOptions ) > 0
         WindowStyleFlag( ::aOptions[ 1 ]:hWnd, WS_GROUP, WS_GROUP )
      ENDIF
      IF nValue >= nItem
         ::Value := nValue
      ENDIF
   ENDIF

   IF nValue >= nItem
      ::Value := ::Value
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Caption( nItem, uValue ) CLASS TRadioGroup

   RETURN ( ::aOptions[ nItem ]:Caption := uValue )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD AdjustResize( nDivh, nDivw ) CLASS TRadioGroup

   LOCAL nFixedHeightUsed

   IF ::lAdjust
      IF ::lHorizontal
         ::Spacing := ::nSpacing * nDivw
      ELSE
         ::Spacing := ::nSpacing * nDivh
      ENDIF

      //// nFixedHeightUsed = pixels used by non-scalable elements inside client area
      IF ::Container == NIL
         nFixedHeightUsed := ::Parent:nFixedHeightUsed
      ELSE
         nFixedHeightUsed := ::Container:nFixedHeightUsed
      ENDIF

      ::Sizepos( ( ::Row - nFixedHeightUsed ) * nDivh + nFixedHeightUsed, ::Col * nDivw )

      IF _OOHG_AdjustWidth
         IF ! ::lFixWidth
            ::Sizepos( , , ::Width * nDivw, ::Height * nDivh )

            IF _OOHG_AdjustFont
               IF ! ::lFixFont
                  ::FontSize := ::FontSize * nDivw
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Spacing( nSpacing ) CLASS TRadioGroup

   LOCAL nCol, nRow, i, oCtrl

   IF HB_ISNUMERIC( nSpacing )
      nCol := ::Col
      nRow := ::Row
      FOR i = 1 TO Len( ::aOptions )
         oCtrl := ::aOptions[ i ]
         oCtrl:Visible := .F.
         oCtrl:SizePos( nRow, nCol )
         oCtrl:Visible := .T.
         IF ::lHorizontal
            nCol += nSpacing
         ELSE
            nRow += nSpacing
         ENDIF
      NEXT
      ::nSpacing := nSpacing
   ENDIF

   RETURN ::nSpacing

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ItemEnabled( nItem, lEnabled ) CLASS TRadioGroup

   IF HB_ISLOGICAL( lEnabled )
      ::aOptions[ nItem ]:Enabled := lEnabled
   ENDIF

   RETURN ::aOptions[ nItem ]:Enabled

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ItemReadonly( nItem, lReadOnly ) CLASS TRadioGroup

   IF HB_ISLOGICAL( lReadOnly )
      ::aOptions[ nItem ]:Enabled := ! lReadOnly
   ENDIF

   RETURN ! ::aOptions[ nItem ]:Enabled

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ItemToolTip( nItem, uToolTip ) CLASS TRadioGroup

   IF ValType( uToolTip ) $ "CMB"
      ::aOptions[ nItem ]:ToolTip := uToolTip
   ENDIF

   RETURN ! ::aOptions[ nItem ]:uToolTip

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ToolTip( uToolTip ) CLASS TRadioGroup

  LOCAL i, aToolTip, nLen := Len( ::aOptions )

   IF ValType( uToolTip ) $ "CMB"
      aToolTip := Array( nLen )
      AFill( aToolTip, uToolTip )
   ELSEIF HB_ISARRAY( uToolTip )
      ASize( uToolTip, nLen )
      aToolTip := Array( nLen )
      FOR i := 1 TO nLen
         IF ValType( uToolTip[ i ] ) $ "CMB"
            aToolTip[ i ] := uToolTip[ i ]
         ENDIF
      NEXT i
   ENDIF

   IF HB_ISARRAY( aToolTip )
      FOR i := 1 TO nLen
         IF ValType( aToolTip[ i ] ) $ "CMB"
            ::aOptions[ i ]:ToolTip := aToolTip[ i ]
         ENDIF
      NEXT i
   ELSE
      aToolTip := Array( nLen )
   ENDIF

   FOR i := 1 TO nLen
      aToolTip[ i ] := ::aOptions[ i ]:ToolTip
   NEXT i

   RETURN aToolTip

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ReadOnly( uReadOnly ) CLASS TRadioGroup

  LOCAL i, aReadOnly

   IF HB_ISLOGICAL( uReadOnly )
      aReadOnly := Array( Len( ::aOptions ) )
      AFill( aReadOnly, uReadOnly )
   ELSEIF HB_ISARRAY( uReadOnly )
      aReadOnly := Array( Len( ::aOptions ) )
      FOR i := 1 TO Len( uReadOnly )
         IF HB_ISLOGICAL( uReadOnly[ i ] )
            aReadOnly[ i ] := uReadOnly[ i ]
         ENDIF
      NEXT i
   ENDIF

   IF HB_ISARRAY( aReadOnly )
      FOR i := 1 TO Len( ::aOptions )
         IF HB_ISLOGICAL( aReadOnly[ i ] )
            ::aOptions[ i ]:Enabled := ! aReadOnly[ i ]
         ENDIF
      NEXT i
   ELSE
      aReadOnly := Array( Len( ::aOptions ) )
   ENDIF

   FOR i := 1 TO Len( ::aOptions )
      aReadOnly[ i ] := ! ::aOptions[ i ]:Enabled
   NEXT i

   RETURN aReadOnly


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TRadioItem FROM TLabel

   DATA IconWidth                  INIT 19
   DATA LeftAlign                  INIT .F.
   DATA lLibDraw                   INIT .F.
   DATA lNoFocusRect               INIT .F.
   DATA nHeight                    INIT 25
   DATA nWidth                     INIT 120
   DATA Type                       INIT "RADIOITEM" READONLY

   METHOD Background               SETGET
   METHOD Define
   METHOD Events
   METHOD Events_Color
   METHOD Events_Command
   METHOD Events_Notify
   METHOD Value                    SETGET

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( cControlName, uParentForm, nCol, nRow, nWidth, nHeight, cCaption, lValue, lFirst, lAutoSize, lTransparent, ;
               uFontColor, uBackColor, cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout, uToolTip, nHelpId, ;
               lInvisible, lNoTabStop, lDisabled, lRtl, oBkGrnd, lLeft, lDrawBy, lNoFocusRect ) CLASS TRadioItem

   LOCAL nControlHandle, nStyle, nStyleEx := 0, oTabPage

   ASSIGN ::nCol VALUE nCol TYPE "N"

   ASSIGN ::nRow VALUE nRow TYPE "N"

   ::SetForm( cControlName, uParentForm, cFontName, nFontSize, uFontColor, uBackColor, NIL, lRtl )

   IF HB_ISNUMERIC( nWidth )
      ::nWidth := nWidth
   ELSEIF ::Container # NIL .AND. ::Container:Type == "RADIOGROUP"
      ::nWidth := ::Container:nWidth
   ENDIF

   IF HB_ISNUMERIC( nHeight )
      ::nHeight := nHeight
   ELSEIF ::Container # NIL .AND. ::Container:Type == "RADIOGROUP"
      ::nHeight := ::Container:nHeight
   ENDIF

   IF HB_ISLOGICAL( lAutoSize )
      ::lAutosize := lAutoSize
   ELSEIF ::Container # NIL .AND. ::Container:Type == "RADIOGROUP"
      ::lAutoSize := ::Container:AutoSize
   ENDIF

   IF HB_ISLOGICAL( lTransparent )
      ::Transparent := lTransparent
   ELSEIF ::Container # NIL .AND. ::Container:Type == "RADIOGROUP"
      ::Transparent := ::Container:Transparent
   ENDIF

   IF HB_ISNUMERIC( nHelpId )
      ::HelpId := nHelpId
   ELSEIF ::Container # NIL .AND. ::Container:Type == "RADIOGROUP"
      ::HelpId := ::Container:HelpId
   ENDIF

   IF ! HB_ISLOGICAL( lInvisible )
      IF ::Container # NIL .AND. ::Container:Type == "RADIOGROUP"
         lInvisible := ! ::Container:Visible
      ELSE
         lInvisible := .F.
      ENDIF
   ENDIF

   IF ::Container # NIL .AND. ::Container:Type == "RADIOGROUP"
      lNoTabStop := .T.
   ELSEIF ! HB_ISLOGICAL( lNoTabStop )
      lNoTabStop := ! ::Container:TabStop
   ENDIF

   ASSIGN lDisabled VALUE lDisabled TYPE "L" DEFAULT .F.

   IF HB_ISOBJECT( oBkGrnd )
      ::oBkGrnd := oBkGrnd
   ELSEIF ::Container # NIL .AND. ::Container:Type == "RADIOGROUP"
      ::oBkGrnd := ::Container:oBkGrnd
   ENDIF

   IF HB_ISLOGICAL( lLeft )
      ::LeftAlign := lLeft
   ELSEIF ::Container # NIL .AND. ::Container:Type == "RADIOGROUP"
      ::LeftAlign := ::Container:LeftAlign
   ENDIF

   IF HB_ISLOGICAL( lNoFocusRect )
      ::lNoFocusRect := lNoFocusRect
   ELSEIF ::Container # NIL .AND. ::Container:Type == "RADIOGROUP"
      ::lNoFocusRect := ::Container:lNoFocusRect
   ENDIF

   IF HB_ISLOGICAL( lDrawBy )
      ::lLibDraw := lDrawBy
   ELSEIF ::Container # NIL .AND. ::Container:Type == "RADIOGROUP"
      ::lLibDraw := ::Container:lLibDraw
   ELSEIF ::lNoFocusRect
      ::lLibDraw := .T.
   ENDIF

   nStyle := ::InitStyle( , , lInvisible, lNoTabStop, lDisabled )
   IF ::Transparent
      nStyleEx += WS_EX_TRANSPARENT
   ENDIF

   /* When the control is created, Windows sends a BN_CLICKED event, thus firing OnChange */
   ::xOldValue := ( HB_ISLOGICAL( lValue ) .AND. lValue )

   IF HB_ISLOGICAL( lFirst ) .AND. lFirst
      nControlHandle := InitRadioGroup( ::ContainerhWnd, ::ContainerCol, ::ContainerRow, nStyle, ::lRtl, ::Width, ::Height, ::LeftAlign, nStyleEx )
   ELSE
      nControlHandle := InitRadioButton( ::ContainerhWnd, ::ContainerCol, ::ContainerRow, nStyle, ::lRtl, ::Width, ::Height, ::LeftAlign, nStyleEx )
   ENDIF

   ::Register( nControlHandle,, nHelpId,, uToolTip )
   ::SetFont( NIL, NIL, lBold, lItalic, lUnderline, lStrikeout )

   IF ::Container # NIL .AND. ::Container:Type == "RADIOGROUP"
      ::TabHandle := ::Container:TabHandle
   ELSEIF _OOHG_LastFrame() == "TABPAGE"
      oTabPage := _OOHG_ActiveFrame
      IF oTabPage:Parent:hWnd == ::Parent:hWnd
         ::TabHandle := ::Container:Container:hWnd
      ENDIF
   ENDIF

   ::Caption := cCaption
   ::Value   := lValue

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value( lValue ) CLASS TRadioItem

   LOCAL lOldValue

   IF HB_ISLOGICAL( lValue )
      lOldValue := ( SendMessage( ::hWnd, BM_GETCHECK, 0, 0 ) == BST_CHECKED )
      IF lValue # lOldValue
         SendMessage( ::hWnd, BM_SETCHECK, IF( lValue, BST_CHECKED, BST_UNCHECKED ), 0 )
      ENDIF
   ENDIF

   RETURN ( SendMessage( ::hWnd, BM_GETCHECK, 0, 0 ) == BST_CHECKED )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Background( oBkGrnd ) CLASS TRadioItem

   IF HB_ISOBJECT( oBkGrnd )
      ::oBkGrnd := oBkGrnd
      ::Redraw()
   ENDIF

   RETURN ::oBkGrnd

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TRadioItem

   IF nMsg == WM_LBUTTONDBLCLK
      IF HB_ISBLOCK( ::OnDblClick )
         ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
      ELSEIF ::Container # NIL
         ::Container:DoEventMouseCoords( ::Container:OnDblClick, "DBLCLICK" )
      ENDIF
      RETURN NIL
   ELSEIF nMsg == WM_RBUTTONUP
      IF HB_ISBLOCK( ::OnRClick )
         ::DoEventMouseCoords( ::OnRClick, "RCLICK" )
      ELSEIF ::Container # NIL
         ::Container:DoEventMouseCoords( ::Container:OnRClick, "RCLICK" )
      ENDIF
      RETURN NIL
   ENDIF

   RETURN ::Super:Events( hWnd, nMsg, wParam, lParam )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Events_Command( wParam ) CLASS TRadioItem

   LOCAL Hi_wParam := HIWORD( wParam )

   IF Hi_wParam == BN_CLICKED
      ::DoChange()
      IF ::Container # NIL .AND. ::Container:Type == "RADIOGROUP"
         ::Container:DoChange()
      ENDIF
      RETURN NIL
   ENDIF

   RETURN ::Super:Events_Command( wParam )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Events_Color( wParam, nDefColor, lDrawBkGrnd ) CLASS TRadioItem

   HB_SYMBOL_UNUSED( lDrawBkGrnd )

   RETURN ::Super:Events_Color( wParam, nDefColor, .T. )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Events_Notify( wParam, lParam ) CLASS TRadioItem

   LOCAL nNotify := GetNotifyCode( lParam )

   IF nNotify == NM_CUSTOMDRAW
      IF ::lLibDraw .AND. ::IsVisualStyled
         // The extra space is to mimic WINDRAW behaviour
         RETURN TRadioItem_Notify_CustomDraw( Self, lParam, ::Caption + " ", ;
                                              ( HB_ISOBJECT( ::TabHandle ) .AND. ! HB_ISOBJECT( ::oBkGrnd ) ), ;
                                              ::LeftAlign, ::lNoFocusRect )
      ENDIF
   ENDIF

   RETURN ::Super:Events_Notify( wParam, lParam )

/*--------------------------------------------------------------------------------------------------------------------------------*/
#pragma BEGINDUMP

#ifndef _WIN32_IE
   #define _WIN32_IE  0x0500
#endif
#if ( _WIN32_IE < 0x0500 )
   #undef _WIN32_IE
   #define _WIN32_IE  0x0500
#endif

#ifndef _WIN32_WINNT
   #define _WIN32_WINNT  0x0501
#endif
#if ( _WIN32_WINNT < 0x0501 )
   #undef _WIN32_WINNT
   #define _WIN32_WINNT  0x0501
#endif

#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windows.h>
#include <commctrl.h>
#include "oohg.h"

#ifndef BST_HOT
   #define BST_HOT  0x0200
#endif

/*
This files are not present in BCC 551
#include <uxtheme.h>
#include <tmschema.h>
*/

typedef struct _MARGINS {
   INT cxLeftWidth;
   INT cxRightWidth;
   INT cyTopHeight;
   INT cyBottomHeight;
} MARGINS, *PMARGINS;

typedef HANDLE HTHEME;

typedef enum THEMESIZE {
   TS_MIN,
   TS_TRUE,
   TS_DRAW
} THEMESIZE;

#ifndef __MSABI_LONG
#  ifndef __LP64__
#    define __MSABI_LONG( x )  ( x ## l )
#  else
#    define __MSABI_LONG( x )  ( x )
#  endif
#endif

#define DTT_TEXTCOLOR     ( __MSABI_LONG(1U) << 0 )
#define DTT_BORDERCOLOR   ( __MSABI_LONG(1U) << 1 )
#define DTT_SHADOWCOLOR   ( __MSABI_LONG(1U) << 2 )
#define DTT_SHADOWTYPE    ( __MSABI_LONG(1U) << 3 )
#define DTT_SHADOWOFFSET  ( __MSABI_LONG(1U) << 4 )
#define DTT_BORDERSIZE    ( __MSABI_LONG(1U) << 5 )
#define DTT_FONTPROP      ( __MSABI_LONG(1U) << 6 )
#define DTT_COLORPROP     ( __MSABI_LONG(1U) << 7 )
#define DTT_STATEID       ( __MSABI_LONG(1U) << 8 )
#define DTT_CALCRECT      ( __MSABI_LONG(1U) << 9 )
#define DTT_APPLYOVERLAY  ( __MSABI_LONG(1U) << 10 )
#define DTT_GLOWSIZE      ( __MSABI_LONG(1U) << 11 )
#define DTT_CALLBACK      ( __MSABI_LONG(1U) << 12 )
#define DTT_COMPOSITED    ( __MSABI_LONG(1U) << 13 )
#define DTT_VALIDBITS     ( DTT_TEXTCOLOR | DTT_BORDERCOLOR | DTT_SHADOWCOLOR | DTT_SHADOWTYPE | DTT_SHADOWOFFSET | DTT_BORDERSIZE | \
                            DTT_FONTPROP | DTT_COLORPROP | DTT_STATEID | DTT_CALCRECT | DTT_APPLYOVERLAY | DTT_GLOWSIZE | DTT_COMPOSITED )

typedef int ( WINAPI * DTT_CALLBACK_PROC ) ( HDC hdc, LPWSTR pszText, INT cchText, LPRECT prc, UINT dwFlags, LPARAM lParam );

#ifdef __BORLANDC__
typedef BOOL  WINBOOL;
#endif

typedef struct _DTTOPTS {
   DWORD dwSize;
   DWORD dwFlags;
   COLORREF crText;
   COLORREF crBorder;
   COLORREF crShadow;
   INT iTextShadowType;
   POINT ptShadowOffset;
   INT iBorderSize;
   INT iFontPropId;
   INT iColorPropId;
   INT iStateId;
   WINBOOL fApplyOverlay;
   INT iGlowSize;
   DTT_CALLBACK_PROC pfnDrawTextCallback;
   LPARAM lParam;
} DTTOPTS, *PDTTOPTS;

enum {
   BP_PUSHBUTTON = 1,
   BP_RADIOBUTTON = 2,
   BP_CHECKBOX = 3,
   BP_GROUPBOX = 4,
   BP_USERBUTTON = 5
};

enum {
   RBS_UNCHECKEDNORMAL = 1,
   RBS_UNCHECKEDHOT = 2,
   RBS_UNCHECKEDPRESSED = 3,
   RBS_UNCHECKEDDISABLED = 4,
   RBS_CHECKEDNORMAL = 5,
   RBS_CHECKEDHOT = 6,
   RBS_CHECKEDPRESSED = 7,
   RBS_CHECKEDDISABLED = 8
};

typedef int ( CALLBACK * CALL_CLOSETHEMEDATA ) ( HTHEME );
typedef int ( CALLBACK * CALL_DRAWTHEMEBACKGROUND ) ( HTHEME, HDC, INT, INT, const RECT *, const RECT * );
typedef int ( CALLBACK * CALL_DRAWTHEMEPARENTBACKGROUND ) ( HWND, HDC, RECT * );
typedef int ( CALLBACK * CALL_DRAWTHEMETEXTEX ) ( HTHEME, HDC, INT, INT, LPCWSTR, INT, DWORD, const RECT *, const DTTOPTS * pOptions );
typedef int ( CALLBACK * CALL_DRAWTHEMETEXT ) ( HTHEME, HDC, INT, INT, LPCWSTR, INT, DWORD, DWORD, const RECT * );
typedef int ( CALLBACK * CALL_GETTHEMEBACKGROUNDCONTENTRECT ) ( HTHEME, HDC, INT, INT, const RECT *, RECT * );
typedef int ( CALLBACK * CALL_GETTHEMEPARTSIZE ) ( HTHEME, HDC, INT, INT, const RECT *, THEMESIZE, SIZE * );
typedef int ( CALLBACK * CALL_ISTHEMEBACKGROUNDPARTIALLYTRANSPARENT ) ( HTHEME, INT, INT );
typedef int ( CALLBACK * CALL_OPENTHEMEDATA ) ( HWND, LPCWSTR );

/*--------------------------------------------------------------------------------------------------------------------------------*/
static WNDPROC _OOHG_TRadioGroup_lpfnOldWndProc( WNDPROC lp )
{
   static WNDPROC lpfnOldWndProcA = 0;

   if( ! lpfnOldWndProcA )
   {
      lpfnOldWndProcA = lp;
   }

   return lpfnOldWndProcA;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static LRESULT APIENTRY SubClassFuncA( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, _OOHG_TRadioGroup_lpfnOldWndProc( 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( INITRADIOGROUP )          /* FUNCTION InitRadioGroup( hWnd, nCol, nRow, nStyle, lRtl, nWidth, nHeight, lLeftAlign, nStyleEx ) -> hWnd */
{
   HWND hgroup;
   int Style, StyleEx;

   Style = hb_parni( 4 ) | BS_NOTIFY | WS_CHILD | BS_AUTORADIOBUTTON | WS_GROUP;
   if( hb_parl( 8 ) )
      Style = Style | BS_LEFTTEXT;

   StyleEx = hb_parni( 9 ) | _OOHG_RTL_Status( hb_parl( 5 ) );

   hgroup = CreateWindowEx( StyleEx, "BUTTON", "", Style,
                            hb_parni( 2 ), hb_parni( 3 ), hb_parni( 6 ), hb_parni( 7 ),
                            HWNDparam( 1 ), NULL, GetModuleHandle( NULL ), NULL );

   _OOHG_TRadioGroup_lpfnOldWndProc( ( WNDPROC ) SetWindowLongPtr( hgroup, GWL_WNDPROC, ( LONG_PTR ) SubClassFuncA ) );

   HWNDret( hgroup );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static WNDPROC _OOHG_TRadioButton_lpfnOldWndProc( WNDPROC lp )
{
   static WNDPROC lpfnOldWndProcB = 0;

   if( ! lpfnOldWndProcB )
   {
      lpfnOldWndProcB = lp;
   }

   return lpfnOldWndProcB;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static LRESULT APIENTRY SubClassFuncB( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, _OOHG_TRadioButton_lpfnOldWndProc( 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( INITRADIOBUTTON )          /* FUNCTION InitRadioButton( hWnd, nCol, nRow, nStyle, lRtl, nWidth, nHeight, lLeftAlign, nStyleEx ) -> hWnd */
{
   HWND hbutton;
   int Style, StyleEx;

   Style = hb_parni( 4 ) | BS_NOTIFY | WS_CHILD | BS_AUTORADIOBUTTON;
   if( hb_parl( 8 ) )
      Style = Style | BS_LEFTTEXT;

   StyleEx = hb_parni( 9 ) | _OOHG_RTL_Status( hb_parl( 5 ) );

   hbutton = CreateWindowEx( StyleEx, "BUTTON", "", Style,
                             hb_parni( 2 ), hb_parni( 3 ), hb_parni( 6 ), hb_parni( 7 ),
                             HWNDparam( 1 ), NULL, GetModuleHandle( NULL ), NULL );

   _OOHG_TRadioButton_lpfnOldWndProc( ( WNDPROC ) SetWindowLongPtr( hbutton, GWL_WNDPROC, ( LONG_PTR ) SubClassFuncB ) );

   HWNDret( hbutton );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
INT TRadioItem_Notify_CustomDraw( PHB_ITEM pSelf, LPARAM lParam, LPCSTR cCaption, BOOL bDrawBkGrnd, BOOL bLeftAlign, BOOL bNoFocusRect )
{
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   LPNMCUSTOMDRAW pCustomDraw = (LPNMCUSTOMDRAW) lParam;
   CALL_CLOSETHEMEDATA dwProcCloseThemeData;
   CALL_DRAWTHEMEBACKGROUND dwProcDrawThemeBackground;
   CALL_DRAWTHEMEPARENTBACKGROUND dwProcDrawThemeParentBackground;
   CALL_DRAWTHEMETEXT dwProcDrawThemeText;
   CALL_DRAWTHEMETEXTEX dwProcDrawThemeTextEx;
   CALL_GETTHEMEBACKGROUNDCONTENTRECT dwProcGetThemeBackgroundContentRect;
   CALL_GETTHEMEPARTSIZE dwProcGetThemePartSize;
   CALL_ISTHEMEBACKGROUNDPARTIALLYTRANSPARENT dwProcIsThemeBackgroundPartiallyTransparent;
   CALL_OPENTHEMEDATA dwProcOpenThemeData;
   DTTOPTS pOptions;
   HMODULE hInstDLL;
   HTHEME hTheme;
   int state_id, checkState, drawState;
   LONG_PTR style, state;
   RECT content_rect, aux_rect;
   SIZE s;
   static const int rb_states[ 2 ][ 5 ] =
   {
      { RBS_UNCHECKEDNORMAL, RBS_UNCHECKEDHOT, RBS_UNCHECKEDPRESSED, RBS_UNCHECKEDDISABLED, RBS_UNCHECKEDNORMAL },
      { RBS_CHECKEDNORMAL,   RBS_CHECKEDHOT,   RBS_CHECKEDPRESSED,   RBS_CHECKEDDISABLED,   RBS_CHECKEDNORMAL }
   };

   if( pCustomDraw->dwDrawStage == CDDS_PREERASE )
   {
      hInstDLL = LoadLibrary( "UXTHEME.DLL" );
      if( ! hInstDLL )
      {
         return CDRF_DODEFAULT;
      }

      dwProcCloseThemeData = ( CALL_CLOSETHEMEDATA ) GetProcAddress( hInstDLL, "CloseThemeData" );
      dwProcDrawThemeBackground = ( CALL_DRAWTHEMEBACKGROUND ) GetProcAddress( hInstDLL, "DrawThemeBackground" );
      dwProcDrawThemeParentBackground = ( CALL_DRAWTHEMEPARENTBACKGROUND ) GetProcAddress( hInstDLL, "DrawThemeParentBackground" );
      dwProcDrawThemeText = ( CALL_DRAWTHEMETEXT ) GetProcAddress( hInstDLL, "DrawThemeText" );
      dwProcDrawThemeTextEx = ( CALL_DRAWTHEMETEXTEX ) GetProcAddress( hInstDLL, "DrawThemeTextEx" );
      dwProcGetThemeBackgroundContentRect = ( CALL_GETTHEMEBACKGROUNDCONTENTRECT ) GetProcAddress( hInstDLL, "GetThemeBackgroundContentRect" );
      dwProcGetThemePartSize = ( CALL_GETTHEMEPARTSIZE ) GetProcAddress( hInstDLL, "GetThemePartSize" );
      dwProcIsThemeBackgroundPartiallyTransparent = ( CALL_ISTHEMEBACKGROUNDPARTIALLYTRANSPARENT ) GetProcAddress( hInstDLL, "IsThemeBackgroundPartiallyTransparent" );
      dwProcOpenThemeData = ( CALL_OPENTHEMEDATA ) GetProcAddress( hInstDLL, "OpenThemeData" );

      if( ! ( dwProcCloseThemeData &&
              dwProcDrawThemeBackground &&
              dwProcDrawThemeParentBackground &&
              dwProcGetThemeBackgroundContentRect &&
              dwProcGetThemePartSize &&
              dwProcIsThemeBackgroundPartiallyTransparent &&
              dwProcOpenThemeData &&
              ( dwProcDrawThemeText || dwProcDrawThemeTextEx ) ) )
       {
         FreeLibrary( hInstDLL );
         return CDRF_DODEFAULT;
      }

      hTheme = ( HTHEME ) ( dwProcOpenThemeData )( pCustomDraw->hdr.hwndFrom, L"BUTTON" );
      if( ! hTheme )
      {
         FreeLibrary( hInstDLL );
         return CDRF_DODEFAULT;
      }

      /* determine control's state, note that the order of these tests is significant */
      style = GetWindowLongPtr( pCustomDraw->hdr.hwndFrom, GWL_STYLE );
      state = SendMessage( pCustomDraw->hdr.hwndFrom, BM_GETSTATE, 0, 0 );
      if( state & BST_CHECKED )
      {
         checkState = 1;
      }
      else
      {
         checkState = 0;
      }
      if( style & WS_DISABLED )
      {
         drawState = 3;
      }
      else if( state & BST_HOT )
      {
         drawState = 1;
      }
      else if( state & BST_FOCUS )
      {
         drawState = 4;
      }
      else if( state & BST_PUSHED )
      {
         drawState = 2;
      }
      else
      {
         drawState = 0;
      }
      state_id = rb_states[ checkState ][ drawState ];

      /* draw parent background */
      if( bDrawBkGrnd )
      {
         if( ( dwProcIsThemeBackgroundPartiallyTransparent )( hTheme, BP_RADIOBUTTON, state_id ) )
         {
            /* pCustomDraw->rc is the item´s client area */
            ( dwProcDrawThemeParentBackground )( pCustomDraw->hdr.hwndFrom, pCustomDraw->hdc, &pCustomDraw->rc );
         }
      }

      /* get button size */
      ( dwProcGetThemePartSize )( hTheme, pCustomDraw->hdc, BP_RADIOBUTTON, state_id, NULL, TS_TRUE, &s );

      /* get content rectangle */
      ( dwProcGetThemeBackgroundContentRect )( hTheme, pCustomDraw->hdc, BP_RADIOBUTTON, state_id, &pCustomDraw->rc, &content_rect );

      aux_rect = pCustomDraw->rc;
      aux_rect.top = aux_rect.top + ( content_rect.bottom - content_rect.top - s.cy ) / 2;
      aux_rect.bottom = aux_rect.top + s.cy;
      if( bLeftAlign )
      {
         aux_rect.left = aux_rect.right - s.cx;
         content_rect.right = aux_rect.left - 3;      // Arbitrary margin between text and button
      }
      else
      {
         aux_rect.right = aux_rect.left + s.cx;
         content_rect.left = aux_rect.right + 3;      // Arbitrary margin between text and button
      }

      /* draw button */
      ( dwProcDrawThemeBackground )( hTheme, pCustomDraw->hdc, BP_RADIOBUTTON, state_id, &aux_rect, NULL );

      if( strlen( cCaption ) > 0 )
      {
         if( dwProcDrawThemeTextEx )
         {
            /* paint caption */
            memset( &pOptions, 0, sizeof( DTTOPTS ) );
            pOptions.dwSize = sizeof( DTTOPTS );
            if( oSelf->lFontColor != -1 )
            {
               pOptions.dwFlags |= DTT_TEXTCOLOR;
               pOptions.crText = ( COLORREF ) oSelf->lFontColor;
            }
            ( dwProcDrawThemeTextEx )( hTheme, pCustomDraw->hdc, BP_RADIOBUTTON, state_id, AnsiToWide( cCaption ), -1, DT_VCENTER | DT_LEFT | DT_SINGLELINE, &content_rect, &pOptions );

            /* paint focus rectangle */
            if( ( state & BST_FOCUS ) && ( ! bNoFocusRect ) )
            {
               aux_rect = content_rect;
               pOptions.dwFlags = DTT_CALCRECT;
               ( dwProcDrawThemeTextEx )( hTheme, pCustomDraw->hdc, BP_RADIOBUTTON, state_id, AnsiToWide( cCaption ), -1, DT_VCENTER | DT_LEFT | DT_SINGLELINE | DT_CALCRECT, &aux_rect, &pOptions );

               if( bLeftAlign )
               {
                  aux_rect.right += 1;
               }
               else
               {
                  aux_rect.left -= 1;
                  aux_rect.right += 1;
               }
               DrawFocusRect( pCustomDraw->hdc, &aux_rect );
            }
         }
         else
         {
            /* paint caption */
            ( dwProcDrawThemeText )( hTheme, pCustomDraw->hdc, BP_RADIOBUTTON, state_id, AnsiToWide( cCaption ), -1, DT_VCENTER | DT_LEFT | DT_SINGLELINE, 0, &content_rect );

            /* paint focus rectangle */
            if( ( state & BST_FOCUS ) && ( ! bNoFocusRect ) )
            {
               aux_rect = content_rect;
               if( bLeftAlign )
               {
                  aux_rect.right += 1;
               }
               else
               {
                  aux_rect.left -= 1;
                  aux_rect.right += 1;
               }
               DrawFocusRect( pCustomDraw->hdc, &aux_rect );
            }
         }
      }

      /* cleanup */
      ( dwProcCloseThemeData )( hTheme );
      FreeLibrary( hInstDLL );
   }

   return CDRF_SKIPDEFAULT;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TRADIOITEM_NOTIFY_CUSTOMDRAW )          /* FUNCTION TRadioItem_Notify_CustomDraw( Self, lParam, cCaption, bDrawBkGrnd, lLeftAlign, lNoFocusRect ) -> nRet */
{
   hb_retni( TRadioItem_Notify_CustomDraw( hb_param( 1, HB_IT_OBJECT ), ( LPARAM ) hb_parnl( 2 ), ( LPCSTR ) hb_parc( 3 ),
                                           ( BOOL ) hb_parl( 4 ), ( BOOL ) hb_parl( 5 ), ( BOOL ) hb_parl( 6 ) ) );
}

#pragma ENDDUMP
