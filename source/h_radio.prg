/*
 * $Id: h_radio.prg $
 */
/*
 * ooHG source code:
 * RadioGroup control
 *
 * Copyright 2005-2021 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2021 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2021 Contributors, https://harbour.github.io/
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
 * Boston, MA 02110-1335, USA (or download from http://www.gnu.org/licenses/).
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

   DATA aOptions                  INIT {}
   DATA IconWidth                 INIT 19
   DATA LeftAlign                 INIT .F.
   DATA lHorizontal               INIT .F.
   DATA lLibDraw                  INIT .F.
   DATA lNoFocusRect              INIT .F.
   DATA lTabStop                  INIT .T.
   DATA nHeight                   INIT 25
   DATA nLimit                    INIT 0
   DATA nShift                    INIT 120
   DATA nSpacing                  INIT 25
   DATA nWidth                    INIT 120
   DATA Type                      INIT "RADIOGROUP" READONLY

   METHOD AddItem
   METHOD AdjustResize
   METHOD Background              SETGET
   METHOD Caption
   METHOD ColMargin               BLOCK { |Self| - ::Col }
   METHOD Define
   METHOD DeleteItem
   METHOD DoChange
   METHOD Enabled                 SETGET
   METHOD GroupHeight
   METHOD GroupWidth
   METHOD InsertItem
   METHOD ItemCount               BLOCK { |Self| Len( ::aOptions ) }
   METHOD ItemEnabled
   METHOD ItemReadOnly
   METHOD ItemToolTip
   METHOD Limit                   SETGET
   METHOD lFocusRect              BLOCK { | Self, lValue | iif( HB_ISLOGICAL( lValue ), ::lNoFocusRect := ! lValue, ! ::lNoFocusRect ) }
   METHOD oBkGrnd                 SETGET
   METHOD ReadOnly                SETGET
   METHOD RePaint
   METHOD RowMargin               BLOCK { |Self| - ::Row }
   METHOD SetFocus
   METHOD SetFont
   METHOD Shift                   SETGET
   METHOD SizePos
   METHOD Spacing                 SETGET
   METHOD TabStop                 SETGET
   METHOD ToolTip                 SETGET
   METHOD Value                   SETGET
   METHOD Visible                 SETGET

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( cControlName, uParentForm, nCol, nRow, aOptions, uValue, cFontName, nFontSize, uToolTip, bChange, ;
               nWidth, nSpacing, nHelpId, lInvisible, lNoTabStop, lBold, lItalic, lUnderline, lStrikeout, uBackColor, ;
               uFontColor, lTransparent, lAutoSize, lHorizontal, lDisabled, lRtl, nHeight, lDrawBy, oBkGrnd, lLeft, ;
               uReadonly, lNoFocusRect, nLimit, nShift ) CLASS TRadioGroup

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
   ASSIGN ::nLimit       VALUE nLimit           TYPE "N"

   IF HB_ISLOGICAL( lDrawBy )
      ::lLibDraw := lDrawBy
   ELSEIF ::lNoFocusRect
      ::lLibDraw := .T.
   ELSEIF uFontColor # NIL
      ::lLibDraw := .T.
   ELSE
      ::lLibDraw := _OOHG_UseLibraryDraw
   ENDIF

   IF HB_ISNUMERIC( nSpacing )
      ::nSpacing := nSpacing
   ELSEIF ::lHorizontal
      ::nSpacing := ::nWidth
   ELSE
     ::nSpacing := ::nHeight
   ENDIF

   IF HB_ISNUMERIC( nShift )
      ::nShift := nShift
   ELSEIF ::lHorizontal
      ::nShift := ::nHeight
   ELSE
     ::nShift := ::nWidth
   ENDIF

   IF HB_ISLOGICAL( lNoTabStop )
      ::lTabStop := ! lNoTabStop
   ENDIF

   ::SetForm( cControlName, uParentForm, cFontName, nFontSize, uFontColor, uBackColor, NIL, lRtl )
   ::InitStyle( NIL, NIL, lInvisible, NIL, lDisabled )
   ::Register( 0, NIL, nHelpId )

   IF _OOHG_LastFrameType() == "TABPAGE"
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

   FOR i := 1 TO Len( aOptions )
      oItem := TRadioItem():Define( NIL, Self, NIL, NIL, NIL, NIL, aOptions[ i ], .F., ( i == 1 ), NIL, NIL, ;
                  NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, ;
                  .T., .T., NIL, NIL, NIL, NIL, NIL, NIL )
      AAdd( ::aOptions, oItem )
   NEXT
   ::RePaint()

   ::ReadOnly := uReadonly
   ::ToolTip  := uToolTip
   ::Value    := uValue

   IF ::Value == 0
      ::aOptions[ 1 ]:TabStop := ::lTabStop
   ENDIF

   ::Enabled := ! lDisabled

   ::SetFont( NIL, NIL, lBold, lItalic, lUnderline, lStrikeout )

   ASSIGN ::OnChange VALUE bChange TYPE "B"

   ::Visible := ::Visible

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Background( oCtrl ) CLASS TRadioGroup

   RETURN ::oBkGrnd( oCtrl )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD oBkGrnd( oCtrl ) CLASS TRadioGroup

   LOCAL i

   IF PCount() > 0
      IF oCtrl == NIL .OR. HB_ISOBJECT( oCtrl )
         ::BrushHandle := NIL
         ::BackgroundObject := oCtrl
         FOR i := 1 TO Len( ::aOptions )
            ::aOptions[ i ]:oBkGrnd := oCtrl
         NEXT
      ENDIF
   ENDIF

   RETURN ::BackgroundObject

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GroupHeight() CLASS TRadioGroup

   LOCAL nStart, i, nEnd := 0, nHeight := 0, nRet := 0

   IF Len( ::aOptions ) > 0
      nStart := ::aOptions[ 1 ]:Row
      FOR i := 2 TO Len( ::aOptions )
         nStart := Min( nStart, ::aOptions[ i ]:Row )
      NEXT i
      FOR i := 1 TO Len( ::aOptions )
         IF ::aOptions[ i ]:Row > nEnd
            nEnd := ::aOptions[ i ]:Row
            nHeight := ::aOptions[ i ]:Height
         ENDIF
      NEXT i
      nRet := nEnd + nHeight - nStart
   ENDIF

   RETURN nRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GroupWidth() CLASS TRadioGroup

   LOCAL nStart, i, nEnd := 0, nWidth := 0, nRet := 0

   IF Len( ::aOptions ) > 0
      nStart := ::aOptions[ 1 ]:Col
      FOR i := 2 TO Len( ::aOptions )
         nStart := Min( nStart, ::aOptions[ i ]:Col )
      NEXT i
      FOR i := 1 TO Len( ::aOptions )
         IF ::aOptions[ i ]:Col > nEnd
            nEnd := ::aOptions[ i ]:Col
            nWidth := ::aOptions[ i ]:Width
         ENDIF
      NEXT i
      nRet := nEnd + nWidth - nStart
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
   AEval( ::aControls, { |o| o:SizePos( o:Row + nDeltaRow, o:Col + nDeltaCol, nWidth, nHeight ) } )

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
      AEval( ::aControls, { |o| o:Visible := lVisible } )
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
METHOD InsertItem( nPosition, cCaption, nImage, uToolTip, oBkGrnd, lLeft, lDisabled, nCol, nRow, nWidth, nHeight ) CLASS TRadioGroup

   LOCAL nValue, oItem, hWnd

   HB_SYMBOL_UNUSED( nImage )

   nValue := ::Value

   nPosition := Int( nPosition )
   IF nPosition < 1 .OR. nPosition > Len( ::aOptions )
      nPosition := Len( ::aOptions ) + 1
   ENDIF

   oItem := TRadioItem():Define( NIL, Self, nCol, nRow, nWidth, nHeight, cCaption, .F., ( nPosition == 1 ), NIL, NIL, ;
               NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, uToolTip, NIL, ;
               .T., .T., lDisabled, NIL, oBkGrnd, lLeft, NIL, NIL )

   AAdd( ::aOptions, NIL )
   AIns( ::aOptions, nPosition )
   ::aOptions[ nPosition ] := oItem

   IF nCol == NIL .OR. nRow == NIL
      ::RePaint()
   ENDIF

   IF nPosition > 1
      SetWindowPos( oItem:hWnd, ::aOptions[ nPosition - 1 ]:hWnd, 0, 0, 0, 0, SWP_NOSIZE + SWP_NOMOVE )
   ELSEIF Len( ::aOptions ) >= 2
      WindowStyleFlag( ::aOptions[ 2 ]:hWnd, WS_GROUP, 0 )
      hWnd := GetWindow( ::aOptions[ 2 ]:hWnd, GW_HWNDPREV )
      SetWindowPos( oItem:hWnd, hWnd, 0, 0, 0, 0, SWP_NOSIZE + SWP_NOMOVE )
   ENDIF

   IF nValue >= nPosition
      ::Value := ::Value
   ENDIF

   ::Visible := ::Visible

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DeleteItem( nItem, lRePaint ) CLASS TRadioGroup

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

      IF lRePaint
         ::RePaint()
      ENDIF
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Caption( nItem, uValue ) CLASS TRadioGroup

   RETURN ( ::aOptions[ nItem ]:Caption := uValue )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD AdjustResize( nDivh, nDivw ) CLASS TRadioGroup

   LOCAL nFixedHeightUsed

   IF ::lAdjust
      /* nFixedHeightUsed = pixels used by non-scalable elements inside client area */
      IF ::container == NIL
         nFixedHeightUsed := ::Parent:nFixedHeightUsed
      ELSE
         nFixedHeightUsed := ::Container:nFixedHeightUsed
      ENDIF

      /* Change position without using ::SizePos to avoid changing the items position */
      ::nRow := ( ::nRow - nFixedHeightUsed ) * nDivh + nFixedHeightUsed
      ::nCol *= nDivw

      IF _OOHG_AdjustWidth
         IF ! ::lFixWidth
            /* Change width, height, spacing and shift without changing the items */
            ::nHeight  *= nDivh
            ::nWidth   *= nDivw
            ::nSpacing *= iif( ::lHorizontal, nDivh, nDivw )
            ::nShift   *= iif( ::lHorizontal, nDivw, nDivh )

            IF _OOHG_AdjustFont
               IF ! ::lFixFont
                  ::nFontSize := ::nFontSize * nDivw
               ENDIF
            ENDIF
         ENDIF
      ENDIF

      AEval( ::aControls, { |o| o:AdjustResize( nDivh, nDivw ) } )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD RePaint() CLASS TRadioGroup

   LOCAL nCol, nRow, i, nCount := 0

   nCol := ::Col
   nRow := ::Row

   FOR i := 1 TO Len( ::aOptions )
      ::aOptions[ i ]:SizePos( nRow, nCol )

      nCount ++
      IF ::lHorizontal
         IF ::nLimit > 0 .AND. nCount == ::nLimit
            nRow += ::nShift
            nCol := ::Col
            nCount := 0
         ELSE
            nCol += ::nSpacing
         ENDIF
      ELSE
         IF ::nLimit > 0 .AND. nCount == ::nLimit
            nCol += ::nShift
            nRow := ::Row
            nCount := 0
         ELSE
            nRow += ::nSpacing
         ENDIF
      ENDIF
   NEXT i

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Limit( nLimit ) CLASS TRadioGroup

   IF HB_ISNUMERIC( nLimit ) .AND. nLimit >= 0
      ::nLimit := nLimit
      ::RePaint()
   ENDIF

   RETURN ::nLimit

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Spacing( nSpacing ) CLASS TRadioGroup

   IF HB_ISNUMERIC( nSpacing )
      ::nSpacing := nSpacing
      ::RePaint()
   ENDIF

   RETURN ::nSpacing

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Shift( nShift ) CLASS TRadioGroup

   IF HB_ISNUMERIC( nShift )
      ::nShift := nShift
      ::RePaint()
   ENDIF

   RETURN ::nShift

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
   ELSEIF _OOHG_LastFrameType() == "TABPAGE"
      oTabPage := _OOHG_ActiveFrame
      IF oTabPage:Parent:hWnd == ::Parent:hWnd
         ::TabHandle := ::Container:Container:hWnd
      ENDIF
   ENDIF

   ::Caption := cCaption
   ::Value   := lValue

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Background( oCtrl ) CLASS TRadioItem

   RETURN ::oBkGrnd( oCtrl )

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
METHOD Events_Command( wParam  ) CLASS TRadioItem

   LOCAL Hi_wParam := HIWORD( wParam  )

   IF Hi_wParam == BN_CLICKED
      ::DoChange()
      IF ::Container # NIL .AND. ::Container:Type == "RADIOGROUP"
         ::Container:DoChange()
      ENDIF
      RETURN NIL
   ENDIF

   RETURN ::Super:Events_Command( wParam  )

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

#include "oohg.h"
#include "hbvm.h"
#include "hbstack.h"

#ifndef BST_HOT
   #define BST_HOT  0x0200
#endif

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

/*--------------------------------------------------------------------------------------------------------------------------------*/
static WNDPROC _OOHG_TRadioGroup_lpfnOldWndProc( LONG_PTR lp )
{
   static LONG_PTR lpfnOldWndProcA = 0;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( ! lpfnOldWndProcA )
   {
      lpfnOldWndProcA = lp;
   }
   ReleaseMutex( _OOHG_GlobalMutex() );

   return (WNDPROC) lpfnOldWndProcA;
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

   _OOHG_TRadioGroup_lpfnOldWndProc( SetWindowLongPtr( hgroup, GWLP_WNDPROC, (LONG_PTR) SubClassFuncA ) );

   HWNDret( hgroup );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static WNDPROC _OOHG_TRadioButton_lpfnOldWndProc( LONG_PTR lp )
{
   static LONG_PTR lpfnOldWndProcB = 0;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( ! lpfnOldWndProcB )
   {
      lpfnOldWndProcB = lp;
   }
   ReleaseMutex( _OOHG_GlobalMutex() );

   return (WNDPROC) lpfnOldWndProcB;
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

   _OOHG_TRadioButton_lpfnOldWndProc( SetWindowLongPtr( hbutton, GWLP_WNDPROC, (LONG_PTR) SubClassFuncB ) );

   HWNDret( hbutton );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
int TRadioItem_Notify_CustomDraw( PHB_ITEM pSelf, LPARAM lParam, LPCSTR cCaption, BOOL bDrawBkGrnd, BOOL bLeftAlign, BOOL bNoFocusRect )
{
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   LPNMCUSTOMDRAW pCustomDraw = (LPNMCUSTOMDRAW) lParam;
   DTTOPTS pOptions;
   HTHEME hTheme;
   int state_id, checkState, drawState;
   LONG_PTR style, state;
   RECT textrect, aux_rect;
   SIZE s;
   OSVERSIONINFO osvi;
   static const int rb_states[ 2 ][ 5 ] =
   {
      { RBS_UNCHECKEDNORMAL, RBS_UNCHECKEDHOT, RBS_UNCHECKEDPRESSED, RBS_UNCHECKEDDISABLED, RBS_UNCHECKEDNORMAL },
      { RBS_CHECKEDNORMAL,   RBS_CHECKEDHOT,   RBS_CHECKEDPRESSED,   RBS_CHECKEDDISABLED,   RBS_CHECKEDNORMAL }
   };

   if( pCustomDraw->dwDrawStage == CDDS_PREERASE )
   {
      if( ! _UxTheme_Init() )
      {
         return CDRF_DODEFAULT;
      }

      hTheme = ( HTHEME ) ProcOpenThemeData( pCustomDraw->hdr.hwndFrom, L"BUTTON" );
      if( ! hTheme )
      {
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
      else if( state & BST_HOT)
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
         if( ProcIsThemeBackgroundPartiallyTransparent( hTheme, BP_RADIOBUTTON, state_id ) )
         {
            /* pCustomDraw->rc is the item´s client area */
            ProcDrawThemeParentBackground( pCustomDraw->hdr.hwndFrom, pCustomDraw->hdc, &pCustomDraw->rc );
         }
      }

      /* get button size */
      ProcGetThemePartSize( hTheme, pCustomDraw->hdc, BP_RADIOBUTTON, state_id, NULL, TS_TRUE, &s );

      /* get text rectangle */
      ProcGetThemeBackgroundContentRect( hTheme, pCustomDraw->hdc, BP_RADIOBUTTON, state_id, &pCustomDraw->rc, &textrect );

      aux_rect = pCustomDraw->rc;
      aux_rect.top = aux_rect.top + ( textrect.bottom - textrect.top - s.cy ) / 2;
      aux_rect.bottom = aux_rect.top + s.cy;
      if( bLeftAlign )
      {
         aux_rect.right = aux_rect.right - 3;
         aux_rect.left = aux_rect.right - s.cx;
         textrect.right = aux_rect.left - 5;
      }
      else
      {
         aux_rect.left += 3;
         aux_rect.right = aux_rect.left + s.cx;
         textrect.left = aux_rect.right + 5;
      }

      /* draw button */
      ProcDrawThemeBackground( hTheme, pCustomDraw->hdc, BP_RADIOBUTTON, state_id, &aux_rect, NULL );

      if( strlen( cCaption ) > 0 )
      {
         getwinver( &osvi );
         if( osvi.dwMajorVersion >= 6 )
         {
            /* paint caption */
            memset( &pOptions, 0, sizeof( DTTOPTS ) );
            pOptions.dwSize = sizeof( DTTOPTS );
            if( oSelf->lFontColor != -1 )
            {
               pOptions.dwFlags |= DTT_TEXTCOLOR;
               pOptions.crText = (COLORREF) oSelf->lFontColor;
            }
            ProcDrawThemeTextEx( hTheme, pCustomDraw->hdc, BP_RADIOBUTTON, state_id, AnsiToWide( cCaption ), -1, DT_VCENTER | DT_LEFT | DT_SINGLELINE, &textrect, &pOptions );

            /* paint focus rectangle */
            if( ( state & BST_FOCUS ) && ( ! bNoFocusRect ) )
            {
               aux_rect = textrect;
               pOptions.dwFlags = DTT_CALCRECT;
               ProcDrawThemeTextEx( hTheme, pCustomDraw->hdc, BP_RADIOBUTTON, state_id, AnsiToWide( cCaption ), -1, DT_VCENTER | DT_LEFT | DT_SINGLELINE | DT_CALCRECT, &aux_rect, &pOptions );

               aux_rect.left -= 2;
               aux_rect.bottom = textrect.bottom;

               SetTextColor( pCustomDraw->hdc, (COLORREF) 0 );
               DrawFocusRect( pCustomDraw->hdc, &aux_rect );
            }
         }
         else
         {
            /* paint caption */
            ProcDrawThemeText( hTheme, pCustomDraw->hdc, BP_RADIOBUTTON, state_id, AnsiToWide( cCaption ), -1, DT_VCENTER | DT_LEFT | DT_SINGLELINE, 0, &textrect );

            /* paint focus rectangle */
            if( ( state & BST_FOCUS ) && ( ! bNoFocusRect ) )
            {
               SetTextColor( pCustomDraw->hdc, (COLORREF) 0 );
               DrawFocusRect( pCustomDraw->hdc, &textrect );
            }
         }
      }

      /* cleanup */
      ProcCloseThemeData( hTheme );
   }

   return CDRF_SKIPDEFAULT;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TRADIOITEM_NOTIFY_CUSTOMDRAW )          /* FUNCTION TRadioItem_Notify_CustomDraw( Self, lParam, cCaption, bDrawBkGrnd, lLeftAlign, lNoFocusRect ) -> nRet */
{
   hb_retni( TRadioItem_Notify_CustomDraw( hb_param( 1, HB_IT_OBJECT ), (LPARAM) hb_parnl( 2 ), (LPCSTR) hb_parc( 3 ),
                                           (BOOL) hb_parl( 4 ), (BOOL) hb_parl( 5 ), (BOOL) hb_parl( 6 ) ) );
}

#pragma ENDDUMP
