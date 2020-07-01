/*
 * $Id: h_textbox.prg $
 */
/*
 * ooHG source code:
 * TextBox control
 *
 * Copyright 2005-2020 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2020 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2020 Contributors, https://harbour.github.io/
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
#include "i_windefs.ch"
#include "hbclass.ch"
#include "set.ch"
#include "hblang.ch"

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TText FROM TLabel

   DATA aBitmap                   INIT NIL
   DATA bAction1                  INIT NIL
   DATA bAction2                  INIT NIL
   DATA bWhen                     INIT NIL
   DATA cCue                      INIT ""
   DATA cToolTipBut1              INIT NIL
   DATA cToolTipBut2              INIT NIL
   DATA lAutoSkip                 INIT .F.
   DATA lFocused                  INIT .F.
   DATA lInsert                   INIT .T.
   DATA lPrevUndo                 INIT .F.
   DATA lRecreateOnReset          INIT .T.
   DATA lSetting                  INIT .F.
   DATA nBtnWidth                 INIT 20
   DATA nDefAnchor                INIT 13   // TopBottomRight
   DATA nHeight                   INIT 24
   DATA nInsertType               INIT 0
   DATA nMaxLength                INIT 0
   DATA nOnFocusPos               INIT -2
   DATA nWidth                    INIT 120
   DATA oButton1                  INIT NIL
   DATA oButton2                  INIT NIL
   DATA OnTextFilled              INIT NIL
   DATA Type                      INIT "TEXT" READONLY
   DATA When_Procesing            INIT .F.
   DATA When_Processed            INIT .F.
   DATA xPrevUndo                 INIT NIL
   DATA xUndo                     INIT NIL

   METHOD AddControl
   METHOD AdjustResize( nDivh, nDivw ) BLOCK { |Self, nDivh, nDivw| ::Super:AdjustResize( nDivh, nDivw, .T. ) }
   METHOD CanUnDo                      BLOCK { |Self| SendMessage( ::hWnd, EM_CANUNDO, 0, 0 ) # 0 }
   METHOD CaretPos                     SETGET
   METHOD Clear                        BLOCK { |Self| SendMessage( ::hWnd, WM_COPY, 0, 0 ) }
   METHOD ControlArea                  SETGET
   METHOD ControlPosition              SETGET
   METHOD Copy                         BLOCK { |Self| SendMessage( ::hWnd, WM_CLEAR, 0, 0 ) }
   METHOD CueBanner                    SETGET
   METHOD Cut                          BLOCK { |Self| SendMessage( ::hWnd, WM_CUT, 0, 0 ) }
   METHOD Define
   METHOD Define2
   METHOD DefineAction
   METHOD DefineAction2
   METHOD DeleteControl
   METHOD DoAutoSkip
   METHOD Enabled                      SETGET
   METHOD Events
   METHOD Events_Command
   METHOD GetCharFromPos
   METHOD GetCurrentLine               BLOCK { |Self| ::GetLineFromChar( -1 ) }
   METHOD GetFirstVisibleLine          BLOCK { |Self| SendMessage( ::hWnd, EM_GETFIRSTVISIBLELINE, 0, 0 ) }
   METHOD GetLastVisibleLine
   METHOD GetLine
   METHOD GetLineCount                 BLOCK { |Self| SendMessage( ::hWnd, EM_GETLINECOUNT, 0, 0 ) }
   METHOD GetLineFromChar( nChar )
   METHOD GetLineIndex( nLine )        BLOCK { |Self, nLine| SendMessage( ::hWnd, EM_LINEINDEX, nLine, 0 ) }
   METHOD GetLineLength( nLine )       BLOCK { |Self, nLine| SendMessage( ::hWnd, EM_LINELENGTH, ::GetLineIndex( nLine ), 0 ) }
   METHOD GetRect
   METHOD GetSelection
   METHOD GetSelText
   METHOD InsertStatus                 SETGET
   METHOD MaxLength                    SETGET
   METHOD PasswordChar                 SETGET
   METHOD Paste                        BLOCK { |Self| SendMessage( ::hWnd, WM_PASTE, 0, 0 ) }
   METHOD ReadOnly                     SETGET
   METHOD RedefinePasswordStyle
   METHOD Refresh                      BLOCK { |Self| ::RefreshData() }
   METHOD RefreshData
   METHOD Release
   METHOD ReleaseAction
   METHOD ReleaseAction2
   METHOD ScrollCaret                  BLOCK { |Self| SendMessage( ::hWnd, EM_SCROLLCARET, 0, 0 ) }
   METHOD SetFocus
   METHOD SetRect
   METHOD SetSelection
   METHOD SizePos
   METHOD UnDo                         BLOCK { |Self| SendMessage( ::hWnd, EM_UNDO, 0, 0 ) }
   METHOD Value                        SETGET
   METHOD Visible                      SETGET

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( cControlName, cParentForm, nCol, nRow, nWidth, nHeight, cValue, cFontName, nFontSize, cToolTip, nMaxLength, ;
               lUpper, lLower, lPassword, bLostFocus, bGotFocus, bChange, bEnter, lRight, nHelpId, lReadOnly, lBold, lItalic, ;
               lUnderline, lStrikeout, cField, uBackColor, uFontColor, lInvisible, lNoTabStop, lRtl, lAutoSkip, lNoBorder, ;
               bOnFocusPos, lDisabled, bValid, bAction1, aBitmap, nBtnWidth, bAction2, bWhen, lCenter, bOnTextFilled, nInsType, ;
               lAtLeft, lNoCntxtMnu, cTTipB1, cTTipB2, cCue ) CLASS TText

   LOCAL nStyle := ES_AUTOHSCROLL, nStyleEx := 0

   nStyle += iif( HB_ISLOGICAL( lUpper ) .AND. lUpper, ES_UPPERCASE, 0 ) + ;
             iif( HB_ISLOGICAL( lLower ) .AND. lLower, ES_LOWERCASE, 0 )

   ::Define2( cControlName, cParentForm, nCol, nRow, nWidth, nHeight, cValue, cFontName, nFontSize, cToolTip, nMaxLength, ;
              lPassword, bLostFocus, bGotFocus, bChange, bEnter, lRight, nHelpId, lReadOnly, lBold, lItalic, lUnderline, ;
              lStrikeout, cField, uBackColor, uFontColor, lInvisible, lNoTabStop, nStyle, lRtl, lAutoSkip, nStyleEx, lNoBorder, ;
              bOnFocusPos, lDisabled, bValid, bAction1, aBitmap, nBtnWidth, bAction2, bWhen, lCenter, bOnTextFilled, nInsType, ;
              lAtLeft, lNoCntxtMnu, cTTipB1, cTTipB2, cCue )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define2( cControlName, cParentForm, x, y, w, h, cValue, cFontName, nFontSize, cToolTip, nMaxLength, lPassword, ;
                bLostFocus, bGotFocus, bChange, bEnter, lRight, nHelpId, lReadOnly, lBold, lItalic, lUnderline, lStrikeout, ;
                cField, uBackColor, uFontColor, lInvisible, lNoTabStop, nStyle, lRtl, lAutoSkip, nStyleEx, lNoBorder, ;
                bOnFocusPos, lDisabled, bValid, bAction1, aBitmap, nBtnWidth, bAction2, bWhen, lCenter, bOnTextFilled, nInsType, ;
                lAtLeft, lNoCntxtMnu, cTTipB1, cTTipB2, cCue ) CLASS TText

   LOCAL nControlHandle, aAux, lBreak := NIL

   ASSIGN ::nCol         VALUE x        TYPE "N"
   ASSIGN ::nRow         VALUE y        TYPE "N"
   ASSIGN ::nWidth       VALUE w        TYPE "N"
   ASSIGN ::nHeight      VALUE h        TYPE "N"
   ASSIGN ::bWhen        VALUE bWhen    TYPE "B"
   ASSIGN ::nInsertType  VALUE nInsType TYPE "N"

   IF HB_ISNUMERIC( nMaxLength ) .AND. nMaxLength >= 0
      ::nMaxLength := Int( nMaxLength )
   ENDIF

   ASSIGN nStyle   VALUE nStyle   TYPE "N" DEFAULT 0
   ASSIGN nStyleEx VALUE nStyleEx TYPE "N" DEFAULT 0

   ::SetForm( cControlName, cParentForm, cFontName, nFontSize, uFontColor, uBackColor, .T., lRtl )

   IF HB_ISLOGICAL( lCenter ) .AND. lCenter
      lRight := .F.
   ELSE
      lCenter := .F.
   ENDIF

   // Style definition
   nStyle += ::InitStyle( NIL, NIL, lInvisible, lNoTabStop, lDisabled ) + ;
             iif( HB_ISLOGICAL( lPassword ) .AND. lPassword, ES_PASSWORD, 0 ) + ;
             iif( HB_ISLOGICAL( lRight ) .AND. lRight, ES_RIGHT, 0 ) + ;
             iif( HB_ISLOGICAL( lCenter ) .AND. lCenter, ES_CENTER, 0 ) + ;
             iif( HB_ISLOGICAL( lReadOnly ) .AND. lReadOnly, ES_READONLY, 0 )

   nStyleEx += iif( ! HB_ISLOGICAL( lNoBorder ) .OR. ! lNoBorder, WS_EX_CLIENTEDGE, 0 )

   // Creates the control window.
   ::SetSplitBoxInfo( lBreak )

   nControlHandle := InitTextBox( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, nStyle, ::nMaxLength, ::lRtl, nStyleEx )

   ::Register( nControlHandle, cControlName, nHelpId, NIL, cToolTip )
   ::SetFont( NIL, NIL, lBold, lItalic, lUnderline, lStrikeout )

   ::SetVarBlock( cField, cValue )

   ASSIGN ::OnLostFocus  VALUE bLostFocus    TYPE "B"
   ASSIGN ::OnGotFocus   VALUE bGotFocus     TYPE "B"
   ASSIGN ::OnChange     VALUE bChange       TYPE "B"
   ASSIGN ::OnEnter      VALUE bEnter        TYPE "B"
   ASSIGN ::OnTextFilled VALUE bOnTextFilled TYPE "B"
   ASSIGN ::postBlock    VALUE bValid        TYPE "B"
   ASSIGN ::lAutoSkip    VALUE lAutoSkip     TYPE "L"
   ASSIGN ::nOnFocusPos  VALUE bOnFocusPos   TYPE "N"
   ASSIGN ::nBtnWidth    VALUE nBtnWidth     TYPE "N"
   ASSIGN lAtLeft        VALUE lAtLeft       TYPE "L" DEFAULT .F.

   ::ControlPosition := iif( lAtLeft, 0, 1 )

   IF HB_ISARRAY( aBitmap )
      aAux := AClone( aBitmap )
      IF Len( aAux ) < 2
         ASize( aAux, 2 )
      ENDIF
   ELSE
      aAux := { aBitmap, NIL }
   ENDIF
   ::aBitmap := aBitmap

   ::DefineAction( bAction1, aAux[ 1 ], cTTipB1 )
   ::DefineAction2( bAction2, aAux[ 2 ], cTTipB2 )

   IF HB_ISLOGICAL( lNoCntxtMnu ) .AND. lNoCntxtMnu
      ::ContextMenu := TMenuContext():Define( Self )
   ENDIF

   ::CueBanner := cCue

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD CueBanner( cCue ) CLASS TText

   IF HB_ISSTRING( cCue )
      SendMessageWideString( ::hWnd, EM_SETCUEBANNER, .T., cCue )
      ::cCue := cCue
   ENDIF

   RETURN ::cCue

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Release() CLASS TText

   ::ReleaseAction()
   ::bAction1 := NIL
   ::cToolTipBut1 := NIL

   ::ReleaseAction2()
   ::bAction2 := NIL
   ::cToolTipBut2 := NIL

   ::aBitmap := NIL

   /* ::ContextMenu is released by ::Super */

   RETURN ::Super:Release()

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ReleaseAction()  CLASS TText

   IF HB_ISOBJECT( ::oButton1 )
     ::oButton1:Release()
     ::oButton1 := NIL
     ::Redraw()
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ReleaseAction2()  CLASS TText

   IF HB_ISOBJECT( ::oButton2 )
     ::oButton2:Release()
     ::oButton1 := NIL
     ::Redraw()
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DefineAction( bAction, uBitmap, cToolTip ) CLASS TText

   IF HB_ISBLOCK( bAction )
      ::bAction1 := bAction
      ::cToolTipBut1 := cToolTip

      IF ::ControlPosition == 0
         IF Empty( uBitmap )
            @ 2,2 BUTTON 0 OF ( Self ) OBJ ::oButton1 ;
               WIDTH ::nBtnWidth HEIGHT 100 ;
               ACTION Eval( bAction ) ;
               CAPTION '...' ;
               TOOLTIP cToolTip
         ELSE
            @ 2,2 BUTTON 0 OF ( Self ) OBJ ::oButton1 ;
               WIDTH ::nBtnWidth HEIGHT 100 ;
               ACTION Eval( bAction ) ;
               PICTURE uBitmap AUTOFIT ;
               TOOLTIP cToolTip
         ENDIF
      ELSE
         IF Empty( uBitmap )
            @ 2,::ClientWidth + 2 - ::nBtnWidth BUTTON 0 OF ( Self ) OBJ ::oButton1 ;
               WIDTH ::nBtnWidth HEIGHT 100 ;
               ACTION Eval( bAction ) ;
               CAPTION '...' ;
               TOOLTIP cToolTip
         ELSE
            @ 2,::ClientWidth + 2 - ::nBtnWidth BUTTON 0 OF ( Self ) OBJ ::oButton1 ;
               WIDTH ::nBtnWidth HEIGHT 100 ;
               ACTION Eval( bAction ) ;
               PICTURE uBitmap AUTOFIT ;
               TOOLTIP cToolTip
         ENDIF
      ENDIF
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DefineAction2( bAction, uBitmap, cToolTip ) CLASS TText

   IF HB_ISBLOCK( bAction )
      ::bAction2 := bAction
      ::cToolTipBut2 := cToolTip

      IF ::ControlPosition == 0
         IF Empty( uBitmap )
            @ 2,2 BUTTON 0 OF ( Self ) OBJ ::oButton2 ;
               WIDTH ::nBtnWidth HEIGHT 100 ;
               ACTION Eval( bAction ) ;
               CAPTION '...' ;
               TOOLTIP cToolTip
         ELSE
            @ 2,2 BUTTON 0 OF ( Self ) OBJ ::oButton2 ;
               WIDTH ::nBtnWidth HEIGHT 100 ;
               ACTION Eval( bAction ) ;
               PICTURE uBitmap AUTOFIT ;
               TOOLTIP cToolTip
         ENDIF
      ELSE
         IF Empty( uBitmap )
            @ 2,::ClientWidth + 2 - ::nBtnWidth BUTTON 0 OF ( Self ) OBJ ::oButton2 ;
               WIDTH ::nBtnWidth HEIGHT 100 ;
               ACTION Eval( bAction ) ;
               CAPTION '...' ;
               TOOLTIP cToolTip
         ELSE
            @ 2,::ClientWidth + 2 - ::nBtnWidth BUTTON 0 OF ( Self ) OBJ ::oButton2 ;
               WIDTH ::nBtnWidth HEIGHT 100 ;
               ACTION Eval( bAction ) ;
               PICTURE uBitmap AUTOFIT ;
               TOOLTIP cToolTip
         ENDIF
      ENDIF
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD RedefinePasswordStyle() CLASS TText

   LOCAL nStyle, nStyleEx, nNewHandle, nOldHandle, cOldValue, aBitmap1, aBitmap2

   nOldHandle := ::hWnd
   cOldValue := ::Value

   nStyle := GetWindowStyle( nOldHandle ) + iif( IsWindowStyle( nOldHandle, ES_PASSWORD ), 0, ES_PASSWORD )
   nStyleEx := GetWindowExStyle( nOldHandle )

   nNewHandle := InitTextBox( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, nStyle, ::nMaxLength, ::lRtl, nStyleEx )
   ::hWnd := nNewHandle
   ::SethWnd( nNewHandle )

   ::SetFont()
   ::Value := cOldValue

   IF ! ::PosAddToCtrlsArrays()
      MsgOOHGError( "Cant' redefine TText control: " + ::Name + " of " + ::ParentName + ". Program terminated." )
   ENDIF

   IF HB_ISARRAY( ::aBitmap )
      IF Len( ::aBitmap ) > 0
         aBitmap1 := ::aBitmap[ 1 ]
         IF Len( ::aBitmap ) > 1
            aBitmap2 := ::aBitmap[ 2 ]
         ENDIF
      ENDIF
   ENDIF

   ::ReleaseAction()
   ::ReleaseAction2()
   ::DefineAction( ::bAction1, aBitmap1, ::cToolTipBut1 )
   ::DefineAction2( ::bAction2, aBitmap2, ::cToolTipBut2 )

   DestroyWindow( nOldHandle )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PasswordChar( uPassChr ) CLASS TText

   IF PCount() > 0
      IF uPassChr == NIL
         IF IsWindowStyle( ::hWnd, ES_PASSWORD )
            /* Remove password char */
            SendMessage( ::hWnd, EM_SETPASSWORDCHAR, 0, 0 )
            ::Value := ::Value
            // ::Redraw()
            // ::SetFocus()
         ENDIF
      ELSEIF ValType( uPassChr ) == "N"
         IF uPassChr == 32
            /* Reset to default password char.
             * Note that we can't reset to the
             * original char because it's
             * unicode 0x25cf (9679)
             */
            IF ::lRecreateOnReset
               ::RedefinePasswordStyle()
            ELSE
               SendMessage( ::hWnd, EM_SETPASSWORDCHAR, Asc( "*" ), 0 )
            ENDIF
            ::Value := ::Value
            // ::Redraw()
            // ::SetFocus()
         ELSEIF uPassChr > 32
            /* Set to char */
            SendMessage( ::hWnd, EM_SETPASSWORDCHAR, uPassChr, 0 )
            ::Value := ::Value
            // ::Redraw()
            // ::SetFocus()
         ENDIF
      ELSEIF ValType( uPassChr ) $ "CM"
         IF Len( uPassChr ) >= 1
            uPassChr := Left( uPassChr, 1 )
            IF uPassChr == " "
               /* Reset to default password char.
                * Note that we can't reset to the
                * original char because it's
                * unicode 0x25cf (9679)
                */
               IF ::lRecreateOnReset
                  ::RedefinePasswordStyle()
               ELSE
                  SendMessage( ::hWnd, EM_SETPASSWORDCHAR, Asc( "*" ), 0 )
               ENDIF
            ELSE
               /* Set to char */
               SendMessage( ::hWnd, EM_SETPASSWORDCHAR, Asc( uPassChr ), 0 )
            ENDIF
            ::Value := ::Value
            // ::Redraw()
            // ::SetFocus()
         ELSEIF IsWindowStyle( ::hWnd, ES_PASSWORD )
            /* Remove password char */
            SendMessage( ::hWnd, EM_SETPASSWORDCHAR, 0, 0 )
            ::Value := ::Value
            // ::Redraw()
            // ::SetFocus()
         ENDIF
      ENDIF
   ENDIF

   IF IsWindowStyle( ::hWnd, ES_PASSWORD )
      uPassChr := SendMessage( ::hWnd, EM_GETPASSWORDCHAR, 0, 0 )
   ELSE
      uPassChr := ""
   ENDIF

   RETURN uPassChr

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD RefreshData() CLASS TText

   LOCAL uValue

   IF HB_ISBLOCK( ::Block )
      uValue := Eval( ::Block )
      IF ValType ( uValue ) $ 'CM'
         uValue := RTrim( uValue )
      ENDIF
      ::Value := uValue
   ENDIF
   AEval( ::aControls, { |o| iif( o:Container == NIL, o:RefreshData(), ) } )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SizePos( nRow, nCol, nWidth, nHeight ) CLASS TText

   LOCAL xRet

   xRet := ::Super:SizePos( nRow, nCol, nWidth, nHeight )
   AEval( ::aControls, { |o| o:Redraw() } )

   RETURN xRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Enabled( lEnabled ) CLASS TText

   IF HB_ISLOGICAL( lEnabled )
      ::Super:Enabled := lEnabled
      AEval( ::aControls, { |o| o:Enabled := o:Enabled } )
   ENDIF

   RETURN ::Super:Enabled

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Visible( lVisible ) CLASS TText

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
METHOD AddControl( oCtrl ) CLASS TText

   LOCAL nArea

   ::Super:AddControl( oCtrl )
   oCtrl:Container := Self

   nArea := ::ControlArea
   ::ControlArea := nArea + oCtrl:Width

   oCtrl:Visible := oCtrl:Visible
   IF ::ControlPosition == 1   // on the right
      oCtrl:SizePos( 2, ::ClientWidth + 2, NIL, ::ClientHeight )
   ELSE
      oCtrl:SizePos( 2, nArea + 2, NIL, ::ClientHeight )
   ENDIF
   oCtrl:Anchor := ::nDefAnchor

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DeleteControl( oCtrl ) CLASS TText

   LOCAL nCount

   nCount := Len( ::aControls )
   ::Super:DeleteControl( oCtrl )
   IF Len( ::aControls ) < nCount
      ::ControlArea := ::ControlArea - oCtrl:Width
      IF ::ControlPosition == 1   // on the right
         AEval( ::aControls, { |o| iif( o:Col < oCtrl:Col + oCtrl:Width, o:Col += oCtrl:Width, NIL ) } )
      ELSE
         AEval( ::aControls, { |o| iif( o:Col > oCtrl:Col, o:Col -= oCtrl:Width, NIL ) } )
      ENDIF
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value( uValue ) CLASS TText

   RETURN ( ::Caption := iif( ValType( uValue ) $ "CM", RTrim( uValue ), NIL ) )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetFocus() CLASS TText

   LOCAL uRet, nLen

   uRet := ::Super:SetFocus()
   IF ::nOnFocusPos == -3
      nLen := Len( RTrim( ::Caption ) )
      SendMessage( ::hWnd, EM_SETSEL, 0, nLen )
   ELSEIF ::nOnFocusPos == -2
      SendMessage( ::hWnd, EM_SETSEL, 0, -1 )
   ELSEIF ::nOnFocusPos == -1
      nLen := Len( ::Caption )
      SendMessage( ::hWnd, EM_SETSEL, nLen, nLen )
   ELSEIF ::nOnFocusPos >= 0
      SendMessage( ::hWnd, EM_SETSEL, ::nOnFocusPos, ::nOnFocusPos )
   ENDIF

   RETURN uRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD CaretPos( nPos ) CLASS TText

   LOCAL aPos

   IF HB_ISNUMERIC( nPos )
      SendMessage( ::hWnd, EM_SETSEL, nPos, nPos )
      ::ScrollCaret()
   ENDIF
   aPos := ::GetSelection()

   RETURN aPos[ 2 ]                                // nEnd

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GetSelection() CLASS TText

   LOCAL aPos

   aPos := TText_GetSelectionData( ::hWnd )

   RETURN aPos                                     // { nStart, nEnd }

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetSelection( nStart, nEnd ) CLASS TText

   // Use nStart = 0 and nEnd = -1 to select all
   SendMessage( ::hWnd, EM_SETSEL, nStart, nEnd )

   RETURN ::GetSelection()

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GetSelText CLASS TText

   LOCAL aPos := ::GetSelection()

   RETURN SubStr( ::Caption, aPos[1] + 1, aPos[2] - aPos[1] )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ReadOnly( lReadOnly ) CLASS TText

   IF HB_ISLOGICAL( lReadOnly )
      SendMessage( ::hWnd, EM_SETREADONLY, iif( lReadOnly, 1, 0 ), 0 )
   ENDIF

   RETURN IsWindowStyle( ::hWnd, ES_READONLY )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD MaxLength( nLen ) CLASS TText

   IF HB_ISNUMERIC( nLen )
      ::nMaxLength := iif( nLen >= 1, nLen, 0 )
      SendMessage( ::hWnd, EM_LIMITTEXT, ::nMaxLength, 0 )
   ENDIF

   RETURN SendMessage( ::hWnd, EM_GETLIMITTEXT, 0, 0 )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DoAutoSkip() CLASS TText

   IF HB_ISBLOCK( ::OnTextFilled )
      ::DoEvent( ::OnTextFilled, "TEXTFILLED" )
   ELSE
      _SetNextFocus()
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Events_Command( wParam  ) CLASS TText

   LOCAL nNotifyCode := HiWord( wParam  )
   LOCAL lWhen

   IF nNotifyCode == EN_CHANGE
      IF ::Transparent
         RedrawWindowControlRect( ::ContainerhWnd, ::ContainerRow, ::ContainerCol, ::ContainerRow + ::Height, ::ContainerCol + ::Width )
      ENDIF
      IF ::lSetting
         ::lSetting := .F.
      ELSE
         ::DoChange()
         IF ::lAutoSkip .AND. ::nMaxLength > 0 .AND. ::CaretPos >= ::nMaxLength
            ::DoAutoSkip()
         ENDIF
      ENDIF
      IF ::lPrevUndo
         ::xUndo := ::xPrevUndo
         ::lPrevUndo := .F.
      ENDIF
      RETURN NIL

   ELSEIF nNotifyCode == EN_KILLFOCUS
      IF ! ::When_Procesing
         ::When_Processed := .F.
      ENDIF
      ::lFocused := .F.
      RETURN ::DoLostFocus()

   ELSEIF nNotifyCode == EN_SETFOCUS
      lWhen := .T.

      IF ! ::When_Processed
         ::When_Processed := .T.
         ::When_Procesing := .T.
         IF ! Empty( ::bWhen )
            lWhen := Eval ( ::bWhen, ::Value )
         ENDIF
         ::When_Procesing := .F.
      ENDIF

      IF ::When_Processed
         IF lWhen
            ::xPrevUndo := ::Value
            ::lPrevUndo := .T.
            ::lFocused := .T.
            IF ::nInsertType == 0
               ::InsertStatus := ( ::Type != "TEXTPICTURE" )
            ENDIF
            ::SetFocus()
            // TControl's Events_Command method is responsible for
            // setting the focus effect and firing the OnGotFocus event.
         ELSE
            IF GetKeyState( VK_TAB ) < 0 .AND. GetKeyFlagState() == MOD_SHIFT
               _SetPrevFocus()
            ELSE
               _SetNextFocus()
            ENDIF
         ENDIF
      ENDIF

   ENDIF

   RETURN ::Super:Events_Command( wParam  )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InsertStatus( lValue ) CLASS TText

   /*
   * ::nInsertType values
   *
   * 0 = Default: each time the control gots focus, it's set to
   *     overwrite for TTextPicture and to insert for the rest.
   *
   * 1 = Same as default for the first time the control gots focus,
   *     the next times the control got focus, it remembers the previous value.
   *
   * 2 = The state of the INSERT key is used to set the type, instead of lInsert.
   */
   IF HB_ISLOGICAL( lValue )
      // Set
      IF ::nInsertType != 2
         ::lInsert := lValue
      ENDIF
   ELSE
      // Get
      IF ::nInsertType == 2
         ::lInsert := IsInsertActive()
      ENDIF
   ENDIF

   RETURN ::lInsert

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GetLineFromChar( nChar ) CLASS TText

   LOCAL nLine

   IF nChar > 64000
      nLine := SendMessage( ::hWnd, EM_EXLINEFROMCHAR, 0, nChar)
   ELSE
      nLine := SendMessage( ::hWnd, EM_LINEFROMCHAR, nChar, 0)
   ENDIF

   RETURN nLine

/*--------------------------------------------------------------------------------------------------------------------------------*/
#pragma BEGINDUMP

#include "oohg.h"
#include "hbvm.h"
#include "hbstack.h"

#define s_Super s_TLabel

/*--------------------------------------------------------------------------------------------------------------------------------*/
static WNDPROC _OOHG_TText_lpfnOldWndProc( LONG_PTR lp )
{
   static LONG_PTR lpfnOldWndProc = 0;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( ! lpfnOldWndProc )
   {
      lpfnOldWndProc = lp;
   }
   ReleaseMutex( _OOHG_GlobalMutex() );

   return (WNDPROC) lpfnOldWndProc;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, _OOHG_TText_lpfnOldWndProc( 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( INITTEXTBOX )          /* FUNCTION InitTextBox( hWnd, hMenu, nCol, nRow, nWidth, nHeight, nStyle, nMaxLenght, lRtl, nStyleEx ) -> hWnd */
{
   HWND hCtrl;        
   int Style, StyleEx;

   Style = WS_CHILD | hb_parni( 7 );
   StyleEx = hb_parni( 10 ) | _OOHG_RTL_Status( hb_parl( 9 ) );

   /* Creates the child control. */
   hCtrl = CreateWindowEx( StyleEx, "EDIT", "", Style,
                           hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ),
                           HWNDparam( 1 ), HMENUparam( 2 ), GetModuleHandle( NULL ), NULL );

   if( hb_parni( 8 ) )
   {
      SendMessage( hCtrl, (UINT) EM_LIMITTEXT, (WPARAM) hb_parni( 8 ), (LPARAM) 0 );
   }

   _OOHG_TText_lpfnOldWndProc( SetWindowLongPtr( hCtrl, GWLP_WNDPROC, (LONG_PTR) SubClassFunc ) );

   HWNDret( hCtrl );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TTEXT_EVENTS )          /* METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TText -> nRet */
{
   HWND hWnd      = HWNDparam( 1 );
   UINT message   = (UINT)   hb_parni( 2 );
   WPARAM wParam  = WPARAMparam( 3 );
   LPARAM lParam  = LPARAMparam( 4 );
   PHB_ITEM pSelf = hb_stackSelfItem();

   switch( message )
   {
      case WM_NCCALCSIZE:
      {
         int iRet;
         RECT * rect2;
         POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

         iRet = DefWindowProc( hWnd, message, wParam, lParam );

         if( oSelf->lAux[ 0 ] )                         /* oSelf->lAux[ 0 ] -> Client's area width used by attached controls */
         {
            rect2 = ( RECT * ) lParam;

            if( oSelf->lAux[ 1 ] )                      /* oSelf->lAux[ 1 ] -> 1=attached controls are on the right, 0=on the left */
            {
               rect2->right = rect2->right - oSelf->lAux[ 0 ];
            }
            else
            {
               rect2->left = rect2->left + oSelf->lAux[ 0 ];
            }
         }

         hb_retni( iRet );
         break;
      }

      case WM_NCHITTEST:
      {
         int iRet;

         iRet = DefWindowProc( hWnd, message, wParam, lParam );

         if( iRet == 0 )
         {
            iRet = HTTRANSPARENT;
         }

         hb_retni( iRet );
         break;
      }

      case WM_CHAR:
      case WM_KEYDOWN:
      case WM_LBUTTONDOWN:
      case WM_UNDO:
      {
         if( ( GetWindowLongPtr( hWnd, GWL_STYLE ) & ES_READONLY ) == 0 )
         {
            HB_FUNCNAME( TTEXT_EVENTS2 )();
            break;
         }
      }
      #ifdef __clang__
         __attribute__((fallthrough));
      #endif
         /* FALLTHRU */

      default:
         _OOHG_Send( pSelf, s_Super );
         hb_vmSend( 0 );
         _OOHG_Send( hb_param( -1, HB_IT_OBJECT ), s_Events );
         HWNDpush( hWnd );
         hb_vmPushLong( message );
         hb_vmPushNumInt( wParam  );
         hb_vmPushNumInt( lParam );
         hb_vmSend( 4 );
         break;
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TTEXT_CONTROLAREA )          /* METHOD ControlArea( nWidth ) CLASS TText -> nWidth */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   RECT rect;

   if( HB_ISNUM( 1 ) )
   {
      oSelf->lAux[ 0 ] = hb_parni( 1 );
      GetWindowRect( oSelf->hWnd, &rect );
      SetWindowPos( oSelf->hWnd, NULL, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOZORDER | SWP_FRAMECHANGED | SWP_NOREDRAW | SWP_NOSIZE );
   }

   hb_retni( oSelf->lAux[ 0 ] );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TTEXT_CONTROLPOSITION )          /* METHOD ControlPosition( nPosition ) CLASS TText -> nPos */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   RECT rect;

   if( HB_ISNUM( 1 ) && ! oSelf->lAux[ 0 ] )
   {
      oSelf->lAux[ 1 ] = hb_parni( 1 );
      GetWindowRect( oSelf->hWnd, &rect );
      SetWindowPos( oSelf->hWnd, NULL, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOZORDER | SWP_FRAMECHANGED | SWP_NOREDRAW | SWP_NOSIZE );
   }

   hb_retni( oSelf->lAux[ 1 ] );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TTEXT_GETSELECTIONDATA )          /* FUNCTION TText_GetSelectionData( hWnd ) -> aPos */
{
   DWORD wParam;
   DWORD lParam;

   SendMessage( HWNDparam( 1 ), EM_GETSEL, (WPARAM) &wParam, (LPARAM) &lParam );

   hb_reta( 2 );
   HB_STORNI( (int) wParam, -1, 1 );
   HB_STORNI( (int) lParam, -1, 2 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TTEXT_GETCHARFROMPOS )          /* METHOD GetCharFromPos( nRow, nCol ) CLASS TText -> { nIndex, nLine } */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   long lRet;

   lRet = SendMessage( oSelf->hWnd, EM_CHARFROMPOS, 0, MAKELPARAM( hb_parni( 2 ), hb_parni( 1 ) ) );

   hb_reta( 2 );
   HB_STORNI( (int) LOWORD( lRet ), -1, 1 );        /* zero-based index of the char */
   HB_STORNI( (int) HIWORD( lRet ), -1, 2 );        /* zero-based line containing the char */
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TTEXT_GETRECT )          /* METHOD GetRect() CLASS TText -> { nTop, nLeft, nBottom, nRight } */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   RECT rect;

   SendMessage( oSelf->hWnd, EM_GETRECT, 0, (LPARAM) &rect );

   hb_reta( 4 );
   HB_STORNI( (int) rect.top, -1, 1 );
   HB_STORNI( (int) rect.left, -1, 2 );
   HB_STORNI( (int) rect.bottom, -1, 3 );
   HB_STORNI( (int) rect.right, -1, 4 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TTEXT_SETRECT )          /* METHOD SetRect() CLASS TText -> { nTop, nLeft, nBottom, nRight } */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   RECT rect;

   rect.top = hb_parni( 2 );
   rect.left = hb_parni( 3 );
   rect.bottom = hb_parni( 4 );
   rect.right = hb_parni( 5 );

   SendMessage( oSelf->hWnd, EM_SETRECT, (WPARAM) 1, (LPARAM) &rect );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TTEXT_GETLASTVISIBLELINE )          /* METHOD GetLastVisibleLine() CLASS TText -> nLine */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   RECT rect;

   SendMessage( oSelf->hWnd, EM_GETRECT, 0, (LPARAM) &rect );

   hb_retni( HIWORD( SendMessage( oSelf->hWnd, EM_CHARFROMPOS, 0, MAKELPARAM( rect.left + 1, rect.bottom - 2 ) ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TTEXT_GETLINE )          /* METHOD GetLine( nLine ) CLASS TText -> cText */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   long nChar;
   WORD LenBuff;
   LPTSTR strBuffer;
   LPWORD pBuffer;
   LRESULT lResult;

   nChar = SendMessage( oSelf->hWnd, EM_LINEINDEX, WPARAMparam( 1 ), 0 );
   if( nChar < 0 )
   {
      hb_retc( "" );
   }
   else
   {
      LenBuff = (WORD) SendMessage( oSelf->hWnd, EM_LINELENGTH, nChar, 0 );
      if( LenBuff )
      {
         strBuffer = (LPTSTR) hb_xgrab( ( LenBuff + 1 ) * sizeof( TCHAR ) );
         pBuffer = ( LPWORD ) strBuffer;
         pBuffer[0] = LenBuff;
         strBuffer[LenBuff] = ( TCHAR ) 0;
         lResult = SendMessage( oSelf->hWnd, EM_GETLINE, WPARAMparam( 1 ), (LPARAM) strBuffer );
         if( lResult )
         {
            hb_retc( strBuffer );
         }
         else
         {
            hb_retc( "" );
         }
         hb_xfree( strBuffer );
      }
      else
      {
         hb_retc( "" );
      }
   }
}

#pragma ENDDUMP

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION TText_Events2( hWnd, nMsg, wParam, lParam )

   LOCAL Self := QSelf()
   LOCAL aPos, nStart, nEnd, cText

   IF nMsg == WM_CHAR .AND. wParam >= 32 .AND. ! ::InsertStatus
      aPos := ::GetSelection()
      nStart := aPos[ 1 ]
      nEnd := aPos[ 2 ]

      /* If some characters are selected or if the insertion point is
       * at the end of line then use control's default behavior.
       * Else, select the next character and invoke default behavior.
       */
      IF nEnd == nStart
         IF SubStr( ::Caption, nStart + 1, 2) != Chr( 13 ) + Chr( 10 )
            SendMessage( ::hWnd, EM_SETSEL, nStart, nStart + 1)
         ENDIF
      ENDIF

   ELSEIF nMsg == WM_UNDO .OR. ( nMsg == WM_KEYDOWN .AND. wParam == VK_Z .AND. GetKeyFlagState() == MOD_CONTROL )
      cText := ::Value
      ::Value := ::xUndo
      ::xUndo := cText

   ELSEIF nMsg == WM_LBUTTONDOWN
      IF ! ::lFocused
         ::SetFocus()
      ENDIF
      ::DoEventMouseCoords( ::OnClick, "CLICK" )

   ELSEIF nMsg == WM_KEYDOWN .AND. wParam == VK_INSERT .AND. GetKeyFlagState() == 0
      /* Toggle insertion */
      ::InsertStatus := ! ::InsertStatus

   ENDIF

   RETURN ::Super:Events( hWnd, nMsg, wParam, lParam )

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TTextPicture FROM TText

   DATA cDateFormat               INIT NIL
   DATA cPicture                  INIT ""
   DATA DataType                  INIT "."
   DATA lBritish                  INIT .F.
   DATA lNumericScroll            INIT .F.
   DATA lToUpper                  INIT .F.
   DATA nDecimal                  INIT 0
   DATA nDecimalShow              INIT 0
   DATA nYear                     INIT NIL
   DATA PictureFun                INIT ""
   DATA PictureFunShow            INIT ""
   DATA PictureMask               INIT ""
   DATA PictureShow               INIT ""
   DATA Type                      INIT "TEXTPICTURE" READONLY
   DATA ValidMask                 INIT {}
   DATA ValidMaskShow             INIT {}

   METHOD Define
   METHOD Events
   METHOD Events_Command
   METHOD KeyPressed
   METHOD Picture                 SETGET
   METHOD Value                   SETGET

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( cControlName, cParentForm, nCol, nRow, nWidth, nHeight, uValue, cInputMask, cFontName, nFontSize, cToolTip, ;
               bLostFocus, bGotFocus, bChange, bEnter, lRight, nHelpId, lReadOnly, lBold, lItalic, lUnderline, lStrikeout, ;
               cField, uBackColor, uFontColor, lInvisible, lNoTabStop, lRtl, lAutoSkip, lNoBorder, bOnFocusPos, lDisabled, ;
               bValid, lUpper, lLower, bAction1, aBitmap, nBtnWidth, bAction2, bWhen, lCenter, nYear, bOnTextFilled, nInsType, ;
               lAtLeft, lNoCntxtMnu, cTTipB1, cTTipB2, cCue ) CLASS TTextPicture

   LOCAL nStyle := ES_AUTOHSCROLL, nStyleEx := 0

   nStyle += iif( HB_ISLOGICAL( lUpper ) .AND. lUpper, ES_UPPERCASE, 0 ) + ;
             iif( HB_ISLOGICAL( lLower ) .AND. lLower, ES_LOWERCASE, 0 )

   ASSIGN ::nYear VALUE nYear TYPE "N" DEFAULT -1

   IF uValue == NIL
      uValue := ""
   ELSEIF HB_ISNUMERIC( uValue )
      lRight := .T.
      ::InsertStatus := .F.
      ::lNumericScroll := .T.
   ELSEIF HB_ISDATE( uValue )
      ::lNumericScroll := .T.
   ENDIF

   IF ValType( cInputMask ) $ "CM"
      ::cPicture := cInputMask
   ENDIF
   ::Picture( ::cPicture, uValue )

   ::Define2( cControlName, cParentForm, nCol, nRow, nWidth, nHeight, uValue, cFontName, nFontSize, cToolTip, 0, .F., ;
              bLostFocus, bGotFocus, bChange, bEnter, lRight, nHelpId, lReadOnly, lBold, lItalic, lUnderline, lStrikeout, ;
              cField, uBackColor, uFontColor, lInvisible, lNoTabStop, nStyle, lRtl, lAutoSkip, nStyleEx, lNoBorder, ;
              bOnFocusPos, lDisabled, bValid, bAction1, aBitmap, nBtnWidth, bAction2, bWhen, lCenter, bOnTextFilled, ;
              nInsType, lAtLeft, lNoCntxtMnu, cTTipB1, cTTipB2, cCue )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Picture( cInputMask, uValue ) CLASS TTextPicture

   LOCAL cType, cPicFun, cPicMask, nPos, nScroll, lOldCentury

   IF ValType( cInputMask ) $ "CM"
      IF uValue == NIL
         uValue := ::Value
      ENDIF

      lOldCentury := __SetCentury()
      ::cDateFormat := Set( _SET_DATEFORMAT )
      cType := ValType( uValue )

      IF ! ValType( cInputMask ) $ "CM"
         cInputMask := ""
      ENDIF
      ::lBritish := .F.
      ::lToUpper := .F.

      cPicFun := ""
      IF Left( cInputMask, 1 ) == "@"
         nPos := At( " ", cInputMask )
         IF nPos != 0
            cPicMask := SubStr( cInputMask, nPos + 1 )
            cInputMask := Upper( Left( cInputMask, nPos - 1 ) )
         ELSE
            cPicMask := ""
            cInputMask := Upper( cInputMask )
         ENDIF

         DO WHILE "S" $ cInputMask
            nScroll := 0
            // It's automatic at textbox's width
            nPos := At( "S", cInputMask )
            cInputMask := Left( cInputMask, nPos - 1 ) + SubStr( cInputMask, nPos + 1 )
            DO WHILE Len( cInputMask ) >= nPos .AND. SubStr( cInputMask, nPos, 1 ) $ "0123456789"
               nScroll := ( nScroll * 10 ) + Val( SubStr( cInputMask, nPos, 1 ) )
               cInputMask := Left( cInputMask, nPos - 1 ) + SubStr( cInputMask, nPos + 1 )
            ENDDO
            IF cType $ "CM" .AND. Empty( cPicMask ) .AND. nScroll > 0
               cPicMask := Replicate( "X", nScroll )
            ENDIF
         ENDDO

         IF "A" $ cInputMask
            IF cType $ "CM" .AND. Empty( cPicMask )
               cPicMask := Replicate( "A", Len( uValue ) )
            ENDIF
            cInputMask := StrTran( cInputMask, "A", "" )
         ENDIF

         /*
         IF "B" $ cInputMask
            cPicFun += "B"
            cInputMask := StrTran( cInputMask, "B", "" )
         ENDIF
         */

         IF "2" $ cInputMask
            SET CENTURY OFF
            cInputMask := StrTran( cInputMask, "2", "" )
         ENDIF

         IF "4" $ cInputMask
            SET CENTURY ON
            cInputMask := StrTran( cInputMask, "4", "" )
         ENDIF

         ::cDateFormat := Set( _SET_DATEFORMAT )

         IF "C" $ cInputMask
            cPicFun += "C"
            cInputMask := StrTran( cInputMask, "C", "" )
         ENDIF

         IF "D" $ cInputMask
            cPicMask := ""
            cInputMask := StrTran( cInputMask, "D", "" )
         ENDIF

         IF "E" $ cInputMask
            ::lBritish := .T.
            IF cType == "D"
               cPicMask := iif( __SetCentury(), "dd/mm/yyyy", "dd/mm/yy" )
            ELSEIF cType != "N"
               cPicMask := iif( __SetCentury(), "99/99/9999", "99/99/99" )
            ENDIF
            cPicFun += "E"
            cInputMask := StrTran( cInputMask, "E", "" )
         ENDIF

         IF "K" $ cInputMask
            // Since all text is selected when textbox gets focus, it's automatic
            cInputMask := StrTran( cInputMask, "K", "" )
         ENDIF

         IF "R" $ cInputMask
            cPicFun += "R"
            cInputMask := StrTran( cInputMask, "R", "" )
         ENDIF

         IF "X" $ cInputMask
            cPicFun += "X"
            cInputMask := StrTran( cInputMask, "X", "" )
         ENDIF

         IF "Z" $ cInputMask
            cPicFun += "Z"
            cInputMask := StrTran( cInputMask, "Z", "" )
         ENDIF

         IF "(" $ cInputMask
            cPicFun += "("
            cInputMask := StrTran( cInputMask, "(", "" )
         ENDIF

         IF ")" $ cInputMask
            cPicFun += ")"
            cInputMask := StrTran( cInputMask, ")", "" )
         ENDIF

         IF "!" $ cInputMask
            ::lToUpper := .T.
            cPicFun += "!"
            IF cType $ "CM" .AND. Empty( cPicMask )
               cPicMask := Replicate( "!", Len( uValue ) )
            ENDIF
            cInputMask := StrTran( cInputMask, "!", "" )
         ENDIF

         IF ! cInputMask == "@"
            MsgOOHGError( "@...TEXTBOX: Wrong Format Definition" )
         ENDIF

         IF ! Empty( cPicFun )
            cPicFun := "@" + cPicFun + " "
         ENDIF
      ELSE
         cPicMask := cInputMask
      ENDIF

      IF Empty( cPicMask )
         DO CASE
         CASE cType $ "CM"
            cPicMask := Replicate( "X", Len( uValue ) )
         CASE cType $ "N"
            cPicMask := Str( uValue )
            nPos := At( ".", cPicMask )
            cPicMask := Replicate( "#", Len( cPicMask ) )
            IF nPos != 0
               cPicMask := Left( cPicMask, nPos - 1 ) + "." + SubStr( cPicMask, nPos + 1 )
            ENDIF
         CASE cType $ "D"
            cPicMask := ::cDateFormat
         CASE cType $ "L"
            cPicMask := "L"
         OTHERWISE
            // Invalid data type
         ENDCASE
      ENDIF

      IF cType $ "D"
         ::cDateFormat := cPicMask
         cPicMask := StrTran( StrTran( StrTran( StrTran( StrTran( StrTran( cPicMask, "Y", "9" ), "y", "9" ), "M", "9" ), "m", "9" ), "D", "9" ), "d", "9" )
      ENDIF

      ::PictureFunShow := cPicFun
      ::PictureFun     := iif( ::lBritish, "E", "" ) + iif( "R" $ cPicFun, "R", "" ) + iif( ::lToUpper, "!", "" )
      IF ! Empty( ::PictureFun )
         ::PictureFun := "@" + ::PictureFun + " "
      ENDIF
      ::PictureShow    := cPicMask
      ::PictureMask    := cPicMask
      ::DataType       := iif( cType == "M", "C", cType )
      ::nDecimal       := iif( cType == "N", At( ".", cPicMask ), 0 )
      ::nDecimalShow   := iif( cType == "N", At( ".", cPicMask ), 0 )
      ::ValidMask      := ValidatePicture( cPicMask )
      ::ValidMaskShow  := ValidatePicture( cPicMask )

      IF ::DataType == "N"
         ::PictureMask := StrTran( StrTran( StrTran( ::PictureMask, ",", "" ), "*", "9" ), "$", "9" )
         ::nDecimal    := At( ".", ::PictureMask )
         ::ValidMask   := ValidatePicture( ::PictureMask )
      ENDIF

      ::cPicture := ::PictureFunShow + ::PictureShow
      ::Value := uValue
      __SetCentury( lOldCentury )
   ENDIF

   RETURN ::cPicture

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION ValidatePicture( cPicture )

   LOCAL aValid, nPos
   LOCAL cValidPictures := "ANX9#LY!anxly$*"

   aValid := Array( Len( cPicture ) )
   FOR nPos := 1 TO Len( cPicture )
      aValid[ nPos ] := ( SubStr( cPicture, nPos, 1 ) $ cValidPictures )
   NEXT

   RETURN aValid

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value( uValue ) CLASS TTextPicture

   LOCAL cType, cAux, cDateFormat, lOldCentury, nAt

   IF ! ValidHandler( ::hWnd )
      RETURN NIL
   ENDIF

   IF ::DataType == "D"
      cDateFormat := Set( _SET_DATEFORMAT )
      lOldCentury := __SetCentury()
      __SetCentury( ( "YYYY" $ Upper( ::cDateFormat ) ) )
      Set( _SET_DATEFORMAT, ::cDateFormat )
   ENDIF

   IF PCount() > 0
      cType := ValType( uValue )
      cType := iif( cType == "M", "C", cType )
      IF cType == ::DataType
         IF cType == "D"
            cAux := Transform( uValue, "@D" )
            IF Len( cAux ) < Len( ::cDateFormat )
               cAux := cAux + Space( Len( ::cDateFormat ) - Len( cAux ) )
            ENDIF
         ELSEIF ::lFocused
            cAux := Transform( uValue, ::PictureFun + ::PictureMask )
            IF Len( cAux ) < Len( ::PictureMask )
               cAux := cAux + Space( Len( ::PictureMask ) - Len( cAux ) )
            ENDIF
         ELSE
            cAux := Transform( uValue, ::PictureFunShow + ::PictureShow )
            IF Len( cAux ) != Len( ::PictureShow )
               cAux := PADR( cAux, Len( ::PictureShow ) )
            ENDIF
         ENDIF
         ::Caption := cAux
      ELSE
         // Wrong data type
      ENDIF
   ENDIF
   cType := ::DataType

   // Removes mask
   DO CASE
   CASE cType == "C"
      uValue := iif( ( "R" $ ::PictureFun ), xUnTransform( Self, ::Caption ), ::Caption )
   CASE cType == "N"
      uValue := Val( StrTran( xUnTransform( Self, ::Caption ), " ", "" ) )
   CASE cType == "D"
      uValue := ::Caption
      IF ::nYear >= 100 .and. ::nYear <= 2999
         nAt := At( "YY", Upper(::cDateFormat) )
         IF nAt > 0
            cAux := Transform( uValue, "@D" )

            IF __SetCentury()
               IF Empty( SubStr( cAux, nAt, 4 ) )
                  uValue := Stuff( cAux, nAt, 4, StrZero( ::nYear, 4, 0 ) )
               ENDIF
            ELSE
               IF Empty( SubStr( cAux, nAt, 2 ) )
                  uValue := Stuff( cAux, nAt, 2, StrZero( ::nYear % 100, 2, 0 ) )
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      uValue := CToD( uValue )
   CASE cType == "L"
      uValue := ( Left( xUnTransform( Self, ::Caption ), 1 ) $ "YT" + hb_langMessage( HB_LANG_ITEM_BASE_TEXT + 1 ) )
   OTHERWISE
      // Wrong data type
      uValue := NIL
   ENDCASE

   IF ::DataType == "D"
      __SetCentury( lOldCentury )
      Set( _SET_DATEFORMAT, cDateFormat )
   ENDIF

   RETURN uValue

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION xUnTransform( Self, cCaption )

   LOCAL cRet

   IF ::lFocused
      cRet := _OOHG_UnTransform( cCaption, ::PictureFun + ::PictureMask, ::DataType )
   ELSE
      cRet := _OOHG_UnTransform( cCaption, ::PictureFunShow + ::PictureShow, ::DataType )
   ENDIF

   RETURN cRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
#pragma BEGINDUMP

#undef s_Super
#define s_Super s_TText

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TTEXTPICTURE_EVENTS )          /* METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TTextPicture -> nRet */
{
   HWND hWnd      = HWNDparam( 1 );
   UINT message   = (UINT)   hb_parni( 2 );
   WPARAM wParam  = WPARAMparam( 3 );
   LPARAM lParam  = LPARAMparam( 4 );
   PHB_ITEM pSelf = hb_stackSelfItem();

   switch( message )
   {
      case WM_CHAR:
      case WM_PASTE:
      case WM_KEYDOWN:
      case WM_LBUTTONDOWN:
      case WM_UNDO:
         if( ( GetWindowLongPtr( hWnd, GWL_STYLE ) & ES_READONLY ) == 0 )
         {
            HB_FUNCNAME( TTEXTPICTURE_EVENTS2 )();
            break;
         }
      #ifdef __clang__
         __attribute__((fallthrough));
      #endif
         /* FALLTHRU */

      default:
         _OOHG_Send( pSelf, s_Super );
         hb_vmSend( 0 );
         _OOHG_Send( hb_param( -1, HB_IT_OBJECT ), s_Events );
         HWNDpush( hWnd );
         hb_vmPushLong( message );
         hb_vmPushNumInt( wParam  );
         hb_vmPushNumInt( lParam );
         hb_vmSend( 4 );
         break;
   }
}

#pragma ENDDUMP

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION TTextPicture_Events2( hWnd, nMsg, wParam, lParam )

   LOCAL Self := QSelf()
   LOCAL nPos, nPos1, nPos2, cText, aPos
   LOCAL aValidMask := ::ValidMask

   IF nMsg == WM_CHAR .AND. wParam >= 32
      aPos := ::GetSelection()
      nPos1 := aPos[ 1 ]
      nPos2 := aPos[ 2 ]
      cText := ::Caption
      nPos := nPos1 + 1
      cText := TTextPicture_Clear( cText, nPos, nPos2 - nPos1, aValidMask, ::InsertStatus )
      IF TTextPicture_Events2_Key( Self, @cText, @nPos, Chr( wParam  ), aValidMask, ::PictureMask, ::InsertStatus )
         ::Caption := cText
         IF ! ::lNumericScroll
            DO WHILE nPos < Len( aValidMask ) .AND. ! aValidMask[ nPos + 1 ]
               nPos++
            ENDDO
         ENDIF
         SendMessage( ::hWnd, EM_SETSEL, nPos, nPos )
      ENDIF
      IF ::lAutoSkip .AND. nPos >= Len( aValidMask )
         ::DoAutoSkip()
      ENDIF
      RETURN 1

   ELSEIF nMsg == WM_KEYDOWN .AND. wParam == VK_DELETE .AND. GetKeyFlagState() == 0
      aPos := ::GetSelection()
      nPos1 := aPos[ 1 ]
      nPos2 := aPos[ 2 ]
      cText := ::Caption
      cText := TTextPicture_Delete( Self, cText, nPos1 + 1, Max( nPos2 - nPos1, 1 ) )
      ::Caption := cText
      SendMessage( ::hWnd, EM_SETSEL, nPos1, nPos1 )
      RETURN 1

   ELSEIF nMsg == WM_KEYDOWN .AND. wParam == VK_END .AND. GetKeyFlagState() == 0
      cText := ::Caption
      nPos := Len( aValidMask )
      DO WHILE nPos > 0 .AND. ( ! aValidMask[ nPos ] .OR. SubStr( cText, nPos, 1 ) == " " )
         nPos--
      ENDDO
      SendMessage( ::hWnd, EM_SETSEL, nPos, nPos )
      RETURN 1

   ELSEIF nMsg == WM_PASTE
      aPos := ::GetSelection()
      nPos1 := aPos[ 1 ]
      nPos2 := aPos[ 2 ]
      cText := ::Caption
      nPos := nPos1
      cText := TTextPicture_Clear( cText, nPos + 1, nPos2 - nPos1, aValidMask, ::InsertStatus )
      IF TTextPicture_Events2_String( Self, @cText, @nPos, GetClipboardText(), aValidMask, ::PictureMask, ::InsertStatus )
         ::Caption := cText
         SendMessage( ::hWnd, EM_SETSEL, nPos, nPos )
      ENDIF
      // Must ::lAutoSkip works when PASTE?
      // IF ::lAutoSkip .AND. nPos >= Len( aValidMask )
      //    ::DoAutoSkip()
      // ENDIF
      RETURN 1

   ELSEIF nMsg == WM_LBUTTONDOWN
      IF ::lFocused
         ::DoEventMouseCoords( ::OnClick, "CLICK" )
      ELSE
         ::SetFocus()
         ::DoEventMouseCoords( ::OnClick, "CLICK" )
         RETURN 1
      ENDIF

   ELSEIF nMsg == WM_UNDO .OR. ;
          ( nMsg == WM_KEYDOWN .AND. wParam == VK_Z .AND. GetKeyFlagState() == MOD_CONTROL )
      cText := ::Value
      ::Value := ::xUndo
      ::xUndo := cText

      // This is necesary to repaint with inputmask
      IF ::lFocused
         ::SetFocus()
      ENDIF
      RETURN 1

   ENDIF

   RETURN ::Super:Events( hWnd, nMsg, wParam, lParam )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD KeyPressed( cString, nPos ) CLASS TTextPicture

   IF ! ValType( cString ) $ "CM"
      cString := ""
   ENDIF
   IF ! HB_ISNUMERIC( nPos ) .OR. nPos < -2
      nPos := ::CaretPos
   ELSEIF nPos < 0
      nPos := Len( ::Caption )
   ENDIF

   RETURN TTextPicture_Events2_String( Self, @::Caption, @nPos, cString, ::ValidMask, ::PictureMask, ::InsertStatus )

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION TTextPicture_Events2_Key( Self, cText, nPos, cChar, aValidMask, cPictureMask, lInsert )

   LOCAL lChange := .F., nPos1, cMask

   IF ::nDecimal != 0 .AND. cChar $ iif( ::lBritish, ",.", "." )
      cText := xUnTransform( Self, cText )
      nPos1 := iif( Left( LTrim( cText ), 1 ) == "-", 1, 0 )
      cText := Transform( Val( StrTran( cText, " ", "" ) ), iif( ::lBritish, "@E ", "" ) + cPictureMask )
      IF nPos1 == 1 .AND. Left( cText, 1 ) == " " .AND. ! "-" $ cText
         nPos1 := Len( cText ) - Len( LTrim( cText ) )
         cText := Left( cText, nPos1 - 1 ) + "-" + SubStr( cText, nPos1 + 1 )
      ENDIF
      nPos := ::nDecimal
      RETURN .T.
   ENDIF
   IF ::lNumericScroll .AND. nPos > 1 .AND. aValidMask[ nPos - 1 ]
      IF nPos > Len( cPictureMask ) .OR. ! aValidMask[ nPos ]
         nPos1 := nPos
         DO WHILE nPos1 > 1 .AND. aValidMask[ nPos1 - 1 ] .AND. ! SubStr( cText, nPos1, 1 ) == " "
            nPos1--
         ENDDO
         IF aValidMask[ nPos1 ] .AND. SubStr( cText, nPos1, 1 ) == " "
            cText := Left( cText, nPos1 - 1 ) + SubStr( cText, nPos1 + 1, nPos - nPos1 - 1 ) + " " + SubStr( cText, nPos )
            nPos--
         ENDIF
      ENDIF
   ENDIF
   DO WHILE nPos <= Len( cPictureMask ) .AND. ! aValidMask[ nPos ]
      nPos++
   ENDDO
   IF nPos <= Len( cPictureMask )
      cMask := SubStr( cPictureMask, nPos, 1 )
      IF ::lToUpper .OR. cMask $ "!lLyY"
         cChar := Upper( cChar )
      ENDIF
      IF ( cMask $ "Nn"  .AND. ( IsAlpha( cChar ) .OR. IsDigit( cChar ) .OR. cChar $ " " )  ) .OR. ;
         ( cMask $ "Aa"  .AND. ( IsAlpha( cChar ) .OR. cChar == " " ) ) .OR. ;
         ( cMask $ "#$*" .AND. ( IsDigit( cChar ) .OR. cChar == "-" ) ) .OR. ;
         ( cMask $ "9"   .AND. ( IsDigit( cChar ) .OR. ( cChar == "-" .AND. ::DataType == "N" ) ) ) .OR. ;
         ( cMask $ "Ll"  .AND. cChar $ ( "TFYN" + hb_langMessage( HB_LANG_ITEM_BASE_TEXT + 1 ) + hb_langMessage( HB_LANG_ITEM_BASE_TEXT + 2 ) ) ) .OR. ;
         ( cMask $ "Yy"  .AND. cChar $ ( "YN"   + hb_langMessage( HB_LANG_ITEM_BASE_TEXT + 1 ) + hb_langMessage( HB_LANG_ITEM_BASE_TEXT + 2 ) ) ) .OR. ;
           cMask $ "Xx!"
         IF ::lNumericScroll
            IF SubStr( cText, nPos, 1 ) == " "
               cText := Left( cText, nPos - 1 ) + cChar + SubStr( cText, nPos + 1 )
            ELSE
               nPos1 := nPos
               DO WHILE nPos1 < Len( cPictureMask ) .AND. aValidMask[ nPos1 + 1 ] .AND. ! SubStr( cText, nPos1, 1 ) == " "
                  nPos1++
               ENDDO
               IF SubStr( cText, nPos1, 1 ) == " "
                  cText := Left( cText, nPos - 1 ) + cChar + SubStr( cText, nPos, nPos1 - nPos ) + SubStr( cText, nPos1 + 1 )
               ELSE
                  nPos1 := nPos
                  DO WHILE nPos1 > 1 .AND. aValidMask[ nPos1 - 1 ] .AND. ! SubStr( cText, nPos1, 1 ) == " "
                     nPos1--
                  ENDDO
                  IF SubStr( cText, nPos1, 1 ) == " "
                     cText := Left( cText, nPos1 - 1 ) + SubStr( cText, nPos1 + 1, nPos - nPos1 - 1 ) + cChar + SubStr( cText, nPos )
                     nPos--
                  ELSE
                     cText := Left( cText, nPos - 1 ) + cChar + SubStr( cText, nPos + 1 )
                  ENDIF
               ENDIF
            ENDIF
         ELSEIF lInsert
            nPos1 := nPos
            DO WHILE nPos1 < Len( cPictureMask ) .AND. aValidMask[ nPos1 + 1 ]
               nPos1++
            ENDDO
            cText := Left( cText, nPos - 1 ) + cChar + SubStr( cText, nPos, nPos1 - nPos ) + SubStr( cText, nPos1 + 1 )
         ELSE
            cText := Left( cText, nPos - 1 ) + cChar + SubStr( cText, nPos + 1 )
         ENDIF
         lChange := .T.
      ELSE
         nPos--
      ENDIF
   ENDIF

   RETURN lChange

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION TTextPicture_Events2_String( Self, cText, nPos, cString, aValidMask, cPictureMask, lInsert )

   LOCAL lChange := .F.

   DO WHILE Len( cString ) > 0 .AND. nPos < Len( cPictureMask )
      nPos++
      IF ! aValidMask[ nPos ] .AND. Left( cString, 1 ) == SubStr( cPictureMask, nPos, 1 )
         cText := Left( cText, nPos - 1 ) + Left( cString, 1 ) + SubStr( cText, nPos + 1 )
         lChange := .T.
      ELSE
         lChange := TTextPicture_Events2_Key( Self, @cText, @nPos, Left( cString, 1 ), aValidMask, cPictureMask, lInsert ) .OR. lChange
      ENDIF
      cString := SubStr( cString, 2 )
   ENDDO

   RETURN lChange

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION TTextPicture_Clear( cText, nPos, nCount, aValidMask, lInsert )

   LOCAL nClear, nBase

   nCount := Max( Min( nCount, ( Len( aValidMask ) - nPos + 1 ) ), 0 )
   IF lInsert
      DO WHILE nCount > 0
         // Skip non-template characters
         DO WHILE nCount > 0 .AND. ! aValidMask[ nPos ]
            nPos++
            nCount--
         ENDDO
         // Count how many blank spaces
         nClear := 0
         nBase := nPos - 1
         DO WHILE nCount > 0 .AND. aValidMask[ nPos ]
            nPos++
            nCount--
            nClear++
         ENDDO
         IF nCount > 0
            // There's a non-template character
            cText := Left( cText, nBase ) + Space( nClear ) + SubStr( cText, nPos )
         ELSEIF nClear != 0
            // The clear area is out of the count's range
            DO WHILE nPos <= Len( aValidMask ) .AND. aValidMask[ nPos ]
               nPos++
            ENDDO
            cText := Left( cText, nBase ) + SubStr( cText, nBase + nClear + 1, nPos - nBase - nClear - 1 ) + Space( nClear ) + SubStr( cText, nPos )
         ENDIF
      ENDDO
   ELSE
      DO WHILE nCount > 0
         IF aValidMask[ nPos ]
            cText := Left( cText, nPos - 1 ) + " " + SubStr( cText, nPos + 1 )
         ENDIF
         nPos++
         nCount--
      ENDDO
   ENDIF

   RETURN cText

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION TTextPicture_Delete( Self, cText, nPos, nCount )

   LOCAL i, j

   // number of template characters to delete
   nCount := Max( Min( nCount, ( Len( ::ValidMask ) - nPos + 1 ) ), 0 )

   // process from right to left
   FOR i := nPos + nCount - 1 TO nPos STEP -1

      // process template characters only
      IF ::ValidMask[ i ]

         // Delete character, shifting to the left all remaining characters
         // until end of line or until next non-template character (whatever
         // occurs first).
         FOR j := i + 1 TO Len( cText )
            IF ! ::ValidMask[ j ]
               EXIT
            ENDIF
         NEXT j

         cText := Left( cText, i - 1 ) + SubStr( cText, i + 1, j - i - 1 ) + " " + SubStr( cText, j )
      ENDIF
   NEXT i

   RETURN cText

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Events_Command( wParam  ) CLASS TTextPicture

   LOCAL nNotifyCode := HiWord( wParam  )
   LOCAL cText, nPos, nPos2, cAux, aPos, cPictureMask, aValidMask

   IF nNotifyCode == EN_CHANGE
      cText := ::Caption
      cPictureMask := ::PictureMask
      IF Len( cText ) != Len( cPictureMask ) .AND. ! ::lSetting .AND. ::lFocused
         aValidMask := ::ValidMask
         aPos := ::GetSelection()
         nPos := aPos[ 2 ]
         IF Len( cText ) > Len( cPictureMask )
            nPos2 := Len( cPictureMask ) - ( Len( cText ) - nPos )
            cAux := SubStr( cText, nPos2 + 1, nPos - nPos2 )
            cText := Left( cText, nPos2 ) + SubStr( cText, nPos + 1 )
            TTextPicture_Events2_String( Self, @cText, @nPos2, cAux, aValidMask, cPictureMask, .F. )
         ELSE
            IF nPos > 0 .AND. nPos < Len( cPictureMask ) .AND. ! aValidMask[ nPos + 1 ]
               nPos--
            ENDIF
            nPos2 := nPos
            nPos := Len( cPictureMask ) - Len( cText )
            cText := Left( cText, nPos2 ) + Space( nPos ) + SubStr( cText, nPos2 + 1 )
            cText := TTextPicture_Clear( cText, nPos2 + 1, nPos, aValidMask, ::InsertStatus )
         ENDIF
         FOR nPos := 1 TO Len( cPictureMask )
            IF ! aValidMask[ nPos ]
               cAux := SubStr( cPictureMask, nPos, 1 )
               IF cAux $ ",." .AND. ::lBritish
                  cAux := iif( cAux == ",", ".", "," )
               ENDIF
               cText := Left( cText, nPos - 1 ) + cAux + SubStr( cText, nPos + 1 )
            ENDIF
         NEXT
         ::Caption := cText
         SendMessage( ::hWnd, EM_SETSEL, nPos2, nPos2 )
      ENDIF

   ELSEIF nNotifyCode == EN_KILLFOCUS
      // This is necesary to repaint with inputmask
      cText := ::Value
      ::lFocused := .F.
      ::lSetting := .T.
      ::Value := cText

   ELSEIF nNotifyCode == EN_SETFOCUS
      // This is necesary to repaint with inputmask
      cText := ::Value
      ::lFocused := .T.
      ::lSetting := .T.
      ::Value := cText

   ENDIF

   RETURN ::Super:Events_Command( wParam  )

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TTextNum FROM TText

   DATA Type                      INIT "NUMTEXT" READONLY

   METHOD Define
   METHOD Events_Command
   METHOD Value                   SETGET

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( cControlName, cParentForm, nCol, nRow, nWidth, nHeight, cValue, cFontName, nFontSize, cToolTip, nMaxLength, ;
               lUpper, lLower, lPassword, bLostFocus, bGotFocus, bChange, bEnter, lRight, nHelpId, lReadOnly, lBold, lItalic, ;
               lUnderline, lStrikeout, cField, uBackColor, uFontColor, lInvisible, lNoTabStop, lRtl, lAutoSkip, lNoBorder, ;
               bOnFocusPos, lDisabled, bValid, bAction1, aBitmap, nBtnWidth, bAction2, bWhen, lCenter, bOnTextFilled, nInsType, ;
               lAtLeft, lNoCntxtMnu, cTTipB1, cTTipB2, cCue ) CLASS TTextNum

   LOCAL nStyle := ES_NUMBER + ES_AUTOHSCROLL, nStyleEx := 0

   HB_SYMBOL_UNUSED( lUpper )
   HB_SYMBOL_UNUSED( lLower )

   ::Define2( cControlName, cParentForm, nCol, nRow, nWidth, nHeight, cValue, cFontName, nFontSize, cToolTip, nMaxLength, ;
              lPassword, bLostFocus, bGotFocus, bChange, bEnter, lRight, nHelpId, lReadOnly, lBold, lItalic, lUnderline, ;
              lStrikeout, cField, uBackColor, uFontColor, lInvisible, lNoTabStop, nStyle, lRtl, lAutoSkip, nStyleEx, ;
              lNoBorder, bOnFocusPos, lDisabled, bValid, bAction1, aBitmap, nBtnWidth, bAction2, bWhen, lCenter, ;
              bOnTextFilled, nInsType, lAtLeft, lNoCntxtMnu, cTTipB1, cTTipB2, cCue )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value( uValue ) CLASS TTextNum

   IF HB_ISNUMERIC( uValue )
      uValue := Int( uValue )
      ::Caption := AllTrim( Str( uValue ) )
   ELSE
      uValue := Int( Val( ::Caption ) )
   ENDIF

   RETURN uValue

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Events_Command( wParam  ) CLASS TTextNum

   LOCAL nNotifyCode := HiWord( wParam  )
   LOCAL cText, nPos, nCursorPos, lChange, aPos

   IF nNotifyCode == EN_CHANGE
      aPos := ::GetSelection()
      nCursorPos := aPos[ 2 ]
      lChange := .F.
      cText := ::Caption
      nPos := 1
      DO WHILE nPos <= Len( cText )
         IF IsDigit( SubStr( cText, nPos, 1 ) )
            nPos++
         ELSE
            cText := Left( cText, nPos - 1 ) + SubStr( cText, nPos + 1 )
            lChange := .T.
            IF nCursorPos >= nPos
               nCursorPos--
            ENDIF
         ENDIF
      ENDDO

      IF lChange
         ::Caption := cText
         SendMessage( ::hWnd, EM_SETSEL, nCursorPos, nCursorPos )
      ENDIF
   ENDIF

   RETURN ::Super:Events_Command( wParam  )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION DefineTextBox( cControlName, cParentForm, nCol, nRow, nWidth, nHeight, uValue, cFontName, nFontSize, cToolTip, ;
                        nMaxLength, lUpper, lLower, lPassword, bLostFocus, bGotFocus, bChange, bEnter, lRight, nHelpId, ;
                        lReadOnly, lBold, lItalic, lUnderline, lStrikeout, cField, uBackColor, uFontColor, lInvisible, ;
                        lNoTabStop, lRtl, lAutoSkip, lNoBorder, bOnFocusPos, lDisabled, bValid, lDate, lNumeric, cInputmask, ;
                        cFormat, oSubclass, bAction1, aBitmap, nBtnWidth, bAction2, bWhen, lCenter, nYear, bOnTextFilled, ;
                        nInsType, lAtLeft, lNoCntxtMnu, cTTipB1, cTTipB2, cCue )

   LOCAL Self, lInsert

   // If format is specified, inputmask is enabled
   IF ValType( cFormat ) $ "CM"
      IF ValType( cInputmask ) $ "CM"
         cInputmask := "@" + cFormat + " " + cInputmask
      ELSE
         cInputmask := "@" + cFormat
      ENDIF
   ENDIF

   // Checks for date textbox
   IF ( HB_ISLOGICAL( lDate ) .AND. lDate ) .OR. HB_ISDATE( uValue )
      lInsert := .F.
      lNumeric := .F.
      IF ValType( uValue ) $ "CM"
         uValue := CToD( uValue )
      ELSEIF ! HB_ISDATE( uValue )
         uValue := SToD( "" )
      ENDIF
      IF ! ValType( cInputmask ) $ "CM"
         cInputmask := "@D"
      ENDIF
   ENDIF

   // Checks for numeric textbox
   IF ! HB_ISLOGICAL( lNumeric )
      lNumeric := .F.
   ELSEIF lNumeric
      lInsert := .F.
      IF ValType( uValue ) $ "CM"
         uValue := Val( uValue )
      ELSEIF ! HB_ISNUMERIC( uValue )
         uValue := 0
      ENDIF
   ENDIF

   IF ValType( cInputmask ) $ "CM"
      // If inputmask is defined, it's TTextPicture()
      Self := _OOHG_SelectSubClass( TTextPicture(), oSubclass )
      ::Define( cControlName, cParentForm, nCol, nRow, nWidth, nHeight, uValue, cInputmask, cFontname, nFontsize, ;
                cTooltip, bLostfocus, bGotfocus, bChange, bEnter, lRight, nHelpId, lReadOnly, lBold, lItalic, lUnderline, ;
                lStrikeout, cField, uBackColor, uFontColor, lInvisible, lNoTabStop, lRtl, lAutoSkip, lNoBorder, ;
                bOnFocusPos, lDisabled, bValid, lUpper, lLower, bAction1, aBitmap, nBtnWidth, bAction2, bWhen, lCenter, ;
                nYear, bOnTextFilled, nInsType, lAtLeft, lNoCntxtMnu, cTTipB1, cTTipB2, cCue )
   ELSE
      Self := _OOHG_SelectSubClass( iif( lNumeric, TTextNum(), TText() ), oSubclass )
      ::Define( cControlName, cParentForm, nCol, nRow, nWidth, nHeight, uValue, cFontName, nFontSize, cToolTip, nMaxLength, ;
                lUpper, lLower, lPassword, bLostFocus, bGotFocus, bChange, bEnter, lRight, nHelpId, lReadOnly, lBold, ;
                lItalic, lUnderline, lStrikeout, cField, uBackColor, uFontColor, lInvisible, lNoTabStop, lRtl, lAutoSkip, ;
                lNoBorder, bOnFocusPos, lDisabled, bValid, bAction1, aBitmap, nBtnWidth, bAction2, bWhen, lCenter, ;
                bOnTextFilled, nInsType, lAtLeft, lNoCntxtMnu, cTTipB1, cTTipB2, cCue )
   ENDIF

   ASSIGN ::InsertStatus VALUE lInsert TYPE "L"

   RETURN Self
